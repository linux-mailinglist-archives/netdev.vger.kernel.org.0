Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E4521B77EA
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 16:04:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728562AbgDXODy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 10:03:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:49979 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727863AbgDXODy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 10:03:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587737032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=86M4xLQmCX1+Kj9jFqVw76Vk3b/HPyVBNV1KeyvfXH8=;
        b=a3XaaelA4epJrbJCVSKB3FtMFoxviho57uk87hb8FEJ4R1yDi1bDXIb7a5P/NrNJ9p3wAH
        bFxX4a99lhPAd8QkqFEvtJQIS3W4M2QOl7TtiefHkoUTz9o/T0x8vfA6/5whGUjRAQMhRw
        k7ZlfjXk4g1ZcaKRcXd7+3WTOpbfUb4=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-mBOgew2HMb64Ee5DWAbo8g-1; Fri, 24 Apr 2020 10:03:51 -0400
X-MC-Unique: mBOgew2HMb64Ee5DWAbo8g-1
Received: by mail-lf1-f69.google.com with SMTP id g5so3935624lfh.9
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 07:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=86M4xLQmCX1+Kj9jFqVw76Vk3b/HPyVBNV1KeyvfXH8=;
        b=A0ugrg273JFmy8u8sOt714ksl939D4yyvP9ZyhZyW9IjQcmcRvM/OcPHOFQ6R9fNdA
         Hvb/0Qaf9F+5peLNT0cGDL1vAtgkNUUKrUHm7yDEAIaMomY1jNwycGpGIDQ5S+rV+0QV
         0+TXiczkc7v1GgpdA8MKX0Z5c7MEo5ojaGF3oftAkC6LRcx5lkXT+w374lM0JdnoJHLp
         gWG857vbr6loixm8w5y1F1cegfTigf8dOuNyUrUZ3l+hwOzN3Pn3lCbtAbG8U3FyCVT6
         LpaeG5EP69PN/+CB+YIXzD2C0E6+O1X+x1dkUf/2/4G0p/u5NLsb2zStXtLAqkFQMHdI
         oohg==
X-Gm-Message-State: AGi0PubONN/e3iUauLl6nSXDOkW43pPvajeGT5E9fMF4Ybv265SRvS6S
        mY10RTYex4bOtU3dh0rKPVtPo0KPbbZvsFbekVkcGnerN9ABp2X9de6JQUVTZv8x/7uk1vDqlM/
        k0d9oxSyo3XNWOJ9n
X-Received: by 2002:a2e:97d3:: with SMTP id m19mr5838013ljj.136.1587737029525;
        Fri, 24 Apr 2020 07:03:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypJMYfs1sZxGBXbruY1FnOCks0xsAgGNnkQ+l8pOrzapO4B0sM0RXjSKiML1hjyB3FQOYpf72Q==
X-Received: by 2002:a2e:97d3:: with SMTP id m19mr5837996ljj.136.1587737029225;
        Fri, 24 Apr 2020 07:03:49 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id l7sm4944371lfg.79.2020.04.24.07.03.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 07:03:38 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B91671814FF; Fri, 24 Apr 2020 16:03:23 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, sameehj@amazon.com
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, zorik@amazon.com, akiyano@amazon.com,
        gtzalik@amazon.com, Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>,
        steffen.klassert@secunet.com
Subject: Re: [PATCH net-next 06/33] net: XDP-generic determining XDP frame size
In-Reply-To: <158757167152.1370371.9610663437543094071.stgit@firesoul>
References: <158757160439.1370371.13213378122947426220.stgit@firesoul> <158757167152.1370371.9610663437543094071.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Fri, 24 Apr 2020 16:03:23 +0200
Message-ID: <87blnh3rro.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> The SKB "head" pointer points to the data area that contains
> skb_shared_info, that can be found via skb_end_pointer(). Given
> xdp->data_hard_start have been established (basically pointing to
> skb->head), frame size is between skb_end_pointer() and data_hard_start,
> plus the size reserved to skb_shared_info.
>
> Change the bpf_xdp_adjust_tail offset adjust of skb->len, to be a positive
> offset number on grow, and negative number on shrink.  As this seems more
> natural when reading the code.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

