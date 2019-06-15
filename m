Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664E846D99
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 03:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfFOBk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 21:40:59 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:36147 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfFOBk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 21:40:59 -0400
Received: by mail-qk1-f194.google.com with SMTP id g18so2920267qkl.3
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 18:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=JCtPFOpGgpLnJj5u7TUubJgflp/D3UgmWZAzwuTJhFI=;
        b=cAg6aC53fWdVHMimgqrp+V/6NZ5KX+T197tVW/IXhZDpHLZEFmFD126LOI4+MjqxW/
         rCW5MSaiVayASrkawU0H6x3XrIe4ZxiDbsZR7kQ5rLh8L4Du9OLEHim4ksfYsJZr/jcu
         nakRy9GnBnj0iZLI/XehAGN7jLmjENQipavtzuYEVqjWDFocraI8qwATDwKLWrMQmS/H
         5173jro9GqoY6vu129QTTM0WX75srS/dkMWhMmnrk1jmgCdfTHk7w+P0qCz4pByffanC
         Sx3ZqQq+qzzWUjeJ0mrCgqWe5mZXVPn3Q87E5WssMEUcCyXDl89d6mHli9kno61UiUuG
         ovyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=JCtPFOpGgpLnJj5u7TUubJgflp/D3UgmWZAzwuTJhFI=;
        b=Hv8mlWAtrKtNhRymwxvry1ndc0n/XcATmiM/JoMUBEs0AIFfT84zL745lWbsQrav3R
         yt0H4U6RasjXu561u8YqaXWCKPxe9cVy+Nnr1RTiX3kKsTtU+zxIA42YgWs/HJ+0J2+F
         qsFO4lOgT8u7zO70A6t/zPcI4nvIUtVTCfnGOu4giVh+wINWHZml1dEhpKe0UyNBechj
         IIi+r+oUYf+OE/t8NR4FqWnTuYolEE0SlKK+bARl2pCx9sSH627zEgfqZPG3p/fVumes
         qhP6HIhpQj03Pjvsy8MhcvPQLB7OSL7UDc9U4tYzPr17lshLa37G9JvMbi+/jhr9CGEs
         mqjw==
X-Gm-Message-State: APjAAAUEZJm7S9kIM6oobub+7ra4ea2vJT36xcT/bPR+vw4EVB9saSUF
        LCJK7EkdD/GRkrlxQq/DRI+lDw==
X-Google-Smtp-Source: APXvYqwtOAaP+SjrI33mbw9cPNL7U0/YfRUqczCN+4x5jmjaTAm3hA0felUDjRw3xvx5iM9bhxWt1A==
X-Received: by 2002:ae9:f209:: with SMTP id m9mr58715974qkg.251.1560562858276;
        Fri, 14 Jun 2019 18:40:58 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id k6sm2137673qkd.21.2019.06.14.18.40.56
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 14 Jun 2019 18:40:58 -0700 (PDT)
Date:   Fri, 14 Jun 2019 18:40:52 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?Qmo=?= =?UTF-8?B?w7ZybiBUw7ZwZWw=?= 
        <bjorn.topel@intel.com>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Jonathan Lemon <bsd@fb.com>,
        Tariq Toukan <tariqt@mellanox.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
Subject: Re: [PATCH bpf-next v4 05/17] xsk: Change the default frame size to
 4096 and allow controlling it
Message-ID: <20190614184052.7de9471b@cakuba.netronome.com>
In-Reply-To: <161cec62-103f-c87c-52b7-8a627940622b@mellanox.com>
References: <20190612155605.22450-1-maximmi@mellanox.com>
        <20190612155605.22450-6-maximmi@mellanox.com>
        <20190612131017.766b4e82@cakuba.netronome.com>
        <b7217210-1ce6-4b27-9964-b4daa4929e8b@mellanox.com>
        <20190613102936.2c8979ed@cakuba.netronome.com>
        <161cec62-103f-c87c-52b7-8a627940622b@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 14 Jun 2019 13:25:28 +0000, Maxim Mikityanskiy wrote:
> On 2019-06-13 20:29, Jakub Kicinski wrote:
> > On Thu, 13 Jun 2019 14:01:39 +0000, Maxim Mikityanskiy wrote:  
> > 
> > Yes, okay, I get that.  But I still don't know what's the exact use you
> > have for AF_XDP buffers being 4k..  Could you point us in the code to
> > the place which relies on all buffers being 4k in any XDP scenario?  

Okay, I still don't get it, but that's for explaining :)  Perhaps it
will become clearer when you resping with patch 17 split into
reviewable chunks :)

> 1. An XDP program is set on all queues, so to support non-4k AF_XDP 
> frames, we would also need to support multiple-packet-per-page XDP for 
> regular queues.

Mm.. do you have some materials of how the mlx5 DMA/RX works?  I'd think
that if you do single packet per buffer as long as all packets are
guaranteed to fit in the buffer (based on MRU) the HW shouldn't care
what the size of the buffer is.

> 2. Page allocation in mlx5e perfectly fits page-sized XDP frames. Some 
> examples in the code are:
> 
> 2.1. mlx5e_free_rx_mpwqe calls a generic mlx5e_page_release to release 
> the pages of a MPWQE (multi-packet work queue element), which is 
> implemented as xsk_umem_fq_reuse for the case of XSK. We avoid extra 
> overhead by using the fact that packet == page.
> 
> 2.2. mlx5e_free_xdpsq_desc performs cleanup after XDP transmits. In case 
> of XDP_TX, we can free/recycle the pages without having a refcount 
> overhead, by using the fact that packet == page.
