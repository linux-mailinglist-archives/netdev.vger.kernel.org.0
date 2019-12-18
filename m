Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2F8D124597
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 12:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726876AbfLRLTr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 06:19:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:44863 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726851AbfLRLTr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 06:19:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576667986;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n07B+kXgoJYUs4D8MS+09AAL4+VW4I9tgy+52pR36io=;
        b=gPI+3svHun27Mcb8v84k2VzhkNdxjWLIdHRNWSiZBcEm+1+L21OfxfG3vXbuLAtuQnXTcK
        mYwDXvziL1dfgx1hrf0ZV2vv0HzpIQ2N7U8hxUjgaKScVhIQzo42GW0SSI2bkDcLAoVXlH
        cxGC4MCgOqUCGpqRzKEP4QqIpuL+DjQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-EHAzN3sIMTKfKkXPODj6IQ-1; Wed, 18 Dec 2019 06:19:45 -0500
X-MC-Unique: EHAzN3sIMTKfKkXPODj6IQ-1
Received: by mail-lj1-f197.google.com with SMTP id f19so592840ljm.0
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 03:19:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=n07B+kXgoJYUs4D8MS+09AAL4+VW4I9tgy+52pR36io=;
        b=V4/Zrqtv8Rzrg6qIe+UBZolgh5SNXBPEn0Fzz3w2iomY7qqOoue/v1L5T2MccXsnuk
         yLZTbJJvtNd7fH1R+0QmJc6feUzD/C2HTu1Gi01O90sqS+PZ9Tb/AdOWRc/CqtMK/CIL
         Ex/cJ1xV4vD69HGvZscFf1lPGE4uLzj49w/iNxOJBCMIBbIknk1YdvSu4yzZyM9jYM0u
         A9UQYzLFxLd7mcWSmAKnYdXvHUhnNFjgEtEK1gBjn/3GEAh5yhXKc7ZkBpd5VM1h0hU+
         yf/eUH4VnuEVGvdExyx4bYlP4riyHUgTUDTNthMfHPC3okJdjXZDGpEXr1iXK7oUXH6Z
         l85A==
X-Gm-Message-State: APjAAAUScFo4M5kZMNa7b2wJDi9EWmMoZUJAtnGlWKxxoQav03zj/FjX
        DmM5oZKbzULT4qYNFOa756f6vNgdsHw0+zJvJTxhbYmPOFpUBMy2Gl0ACwqSb+VnlQCUehFLtS9
        YfmK0Q36ismIgMeqR
X-Received: by 2002:ac2:531b:: with SMTP id c27mr1364578lfh.91.1576667983690;
        Wed, 18 Dec 2019 03:19:43 -0800 (PST)
X-Google-Smtp-Source: APXvYqxTpse7JbFjgVn/7mZKYkYaCYefEQmTfJFMx8+24/+Xfes+KhZMurnFLwgWiT3NkBtHs46+Tw==
X-Received: by 2002:ac2:531b:: with SMTP id c27mr1364563lfh.91.1576667983552;
        Wed, 18 Dec 2019 03:19:43 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([2a0c:4d80:42:443::2])
        by smtp.gmail.com with ESMTPSA id q27sm906436ljm.25.2019.12.18.03.19.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 03:19:42 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 0EB88180969; Wed, 18 Dec 2019 12:19:42 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>,
        netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: Re: [PATCH bpf-next 4/8] xsk: make xskmap flush_list common for all map instances
In-Reply-To: <20191218105400.2895-5-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com> <20191218105400.2895-5-bjorn.topel@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 12:19:42 +0100
Message-ID: <87tv5x6fu9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> writes:

> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> The xskmap flush list is used to track entries that need to flushed
> from via the xdp_do_flush_map() function. This list used to be
> per-map, but there is really no reason for that. Instead make the
> flush list global for all xskmaps, which simplifies __xsk_map_flush()
> and xsk_map_alloc().
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

