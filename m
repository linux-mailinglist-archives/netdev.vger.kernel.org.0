Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5552F361354
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 22:10:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235290AbhDOULB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 16:11:01 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40151 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234654AbhDOULA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 16:11:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618517437;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r+6Ec8PvL7gAJlQ60UG94EesWSLVFvJeLHemOou2874=;
        b=ZRjXaFMghXu7na8SosEr0OWzl5wrdo5rIKKTQCs3eL8AAgg6R4KVPSsPhL/uK5V06aTJRa
        6klltx2/3oJ8cEoKKhDXHyVPCc8OwjOBoI+91rl8Xyop/0p/XktUPUT2+7+KIMfo6ztGT9
        LD+TByPSy4/vUxqG5Tcb0/U+gYD8HGs=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-331-hCFbYPoKN_eWecvlpfpXiA-1; Thu, 15 Apr 2021 16:10:26 -0400
X-MC-Unique: hCFbYPoKN_eWecvlpfpXiA-1
Received: by mail-ed1-f71.google.com with SMTP id b9-20020a05640202c9b029038276b571ddso5778950edx.11
        for <netdev@vger.kernel.org>; Thu, 15 Apr 2021 13:10:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r+6Ec8PvL7gAJlQ60UG94EesWSLVFvJeLHemOou2874=;
        b=YUj83mshYVqV11jSgz8TErYSm9sV8E2wxVpxzib8O9m0BBRARhZ2PLlqG90g7k/4Ri
         KlxrM/iOdmp4ReEOmZj+3Q7i3c2fKLv3Ji8wQTMOPT02R/oZpvFn6FrmqGaACrVxTcP3
         kpUQKImgAR2YeWW2mIVVmwPGboPLhiOUJlw8E/1NlnOlPGWyW4mgnuQN79qDwuQMShlM
         p5NCrn9Tx0pPFwe835q7+0uXYPRG+0y3LQPP1wPsT8crLyyN/6fc8AQltnnLQIzzMtt9
         CYkSkiMFzAuW2kJYsbKwoal2d5pFRZDgI0kUqn0nbhKsNQWkyH2imbzYUFXLtYPuxbZt
         EBLQ==
X-Gm-Message-State: AOAM533bZsUYc9kaqNhczjPr/mYxawcFxiKDMEr+NdsC973pjzP9gcni
        OQmCj751YqFd+mRxFnG+UkxAKDmqJSTZg6kR+DPRAQhShCwvDiGTN/U8oVB4aGCIqC62CNN8PQH
        Fsmfi6XO3b3LrEnBA
X-Received: by 2002:a05:6402:31ad:: with SMTP id dj13mr6203234edb.167.1618517425526;
        Thu, 15 Apr 2021 13:10:25 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJywoGJtnn0SEVjzLb5h7Rp4TfuoGtQFwCD0US4htdpPzNHrMV+kbl1J/fyOKqSWMuYjEJhBYg==
X-Received: by 2002:a05:6402:31ad:: with SMTP id dj13mr6203217edb.167.1618517425343;
        Thu, 15 Apr 2021 13:10:25 -0700 (PDT)
Received: from localhost ([151.66.38.94])
        by smtp.gmail.com with ESMTPSA id z20sm3352989edd.0.2021.04.15.13.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Apr 2021 13:10:24 -0700 (PDT)
Date:   Thu, 15 Apr 2021 22:10:21 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, brouer@redhat.com, song@kernel.org
Subject: Re: [PATCH v2 bpf-next] cpumap: bulk skb using netif_receive_skb_list
Message-ID: <YHidrRnmDe25lact@lore-desk>
References: <bb627106428ea3223610f5623142c24270f0e14e.1618330734.git.lorenzo@kernel.org>
 <252403c5-d3a7-03fb-24c3-0f328f8f8c70@iogearbox.net>
 <47f3711d-e13a-a537-4e0e-13c3c5ff6822@gmail.com>
 <YHhj61rDPai8YKjL@lore-desk>
 <7cbba160-c56a-8ec5-b9e1-455889bacb86@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hi23/T0SndxHJlIq"
Content-Disposition: inline
In-Reply-To: <7cbba160-c56a-8ec5-b9e1-455889bacb86@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--hi23/T0SndxHJlIq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 4/15/21 9:03 AM, Lorenzo Bianconi wrote:
> >> On 4/15/21 8:05 AM, Daniel Borkmann wrote:
> >=20
> > [...]
> >>>> &stats);
> >>>
> >>> Given we stop counting drops with the netif_receive_skb_list(), we
> >>> should then
> >>> also remove drops from trace_xdp_cpumap_kthread(), imho, as otherwise=
 it
> >>> is rather
> >>> misleading (as in: drops actually happening, but 0 are shown from the
> >>> tracepoint).
> >>> Given they are not considered stable API, I would just remove those to
> >>> make it clear
> >>> to users that they cannot rely on this counter anymore anyway.
> >>>
> >>
> >> What's the visibility into drops then? Seems like it would be fairly
> >> easy to have netif_receive_skb_list return number of drops.
> >>
> >=20
> > In order to return drops from netif_receive_skb_list() I guess we need =
to introduce
> > some extra checks in the hot path. Moreover packet drops are already ac=
counted
> > in the networking stack and this is currently the only consumer for thi=
s info.
> > Does it worth to do so?
>=20
> right - softnet_stat shows the drop. So the loss here is that the packet
> is from a cpumap XDP redirect.
>=20
> Better insights into drops is needed, but I guess in this case coming
> from the cpumap does not really aid into why it is dropped - that is
> more core to __netif_receive_skb_list_core. I guess this is ok to drop
> the counter from the tracepoint.
>=20

Applying the current patch, drops just counts the number of kmem_cache_allo=
c_bulk()
failures. Looking at kmem_cache_alloc_bulk() code, it does not seem to me t=
here any
failure counters. So I am wondering, is this an important info for the user?
Is so I guess we can just rename the counter in something more meaningful
(e.g. skb_alloc_failures).

Regards,
Lorenzo

--hi23/T0SndxHJlIq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYHidqwAKCRA6cBh0uS2t
rFBIAP9Fs4CJBgQGtdrwe/5E1hPRQ2dun08AVFtJNPVM2FkgqQD9FSaDEajEUfsL
C189CbKtdvCap0OEC9MndyMssPt1CQ0=
=8KvM
-----END PGP SIGNATURE-----

--hi23/T0SndxHJlIq--

