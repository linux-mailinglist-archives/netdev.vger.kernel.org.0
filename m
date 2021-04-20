Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70F47365E38
	for <lists+netdev@lfdr.de>; Tue, 20 Apr 2021 19:09:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233092AbhDTRKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Apr 2021 13:10:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59333 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232473AbhDTRKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Apr 2021 13:10:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618938587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=SRf/Tph3L3NAvNbWzjfk07FIkQyOeKwYwW/14Laa07M=;
        b=iykT4qjnPOkqsmY2aSvU2mkG/ky8Bi4lwJiVCVmG3/7dwCh6aVh5u9AgTxNjTZT+KHKZS5
        FHcOxU0hYW16sL2hryfgpC74dftg5lcKhoXeLHFV10mmdK22mUi+BRq1DGYEXS5vKVkTY2
        lShhmb/i5zW1irJ2S9lH5EnsAHBfE+c=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-IjdlzfWdOkyw2cjOK1XG6w-1; Tue, 20 Apr 2021 13:09:43 -0400
X-MC-Unique: IjdlzfWdOkyw2cjOK1XG6w-1
Received: by mail-ej1-f71.google.com with SMTP id g7-20020a1709065d07b029037c872d9cdcso5053582ejt.11
        for <netdev@vger.kernel.org>; Tue, 20 Apr 2021 10:09:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=SRf/Tph3L3NAvNbWzjfk07FIkQyOeKwYwW/14Laa07M=;
        b=QUH1ahHJYDMWk3FNqw5UHUryDw7nVzCly2LV0vjxflw4ce4Cd1l6+Xi8eWTr7VyCTm
         /mEzHK/Le4Nnqeq+6KPjBhFVFQuC/NUjeJr3NmjEcuQlrvDDHGMsxyyHuPyzTMP8viyo
         u3ENti4+sexK+aPH84KAXUSORPKRbH1DAs33/VOHwOaLYMli0FmWv3RkNmumM3FYuQmg
         TYqtXm958tG6PZBKsklrMTDWSo8DVnxDmSaewg3q3kFt0LekcBPAGXtL62tBYo7FQFKL
         pGOxrDDrSlefOLWfvDOq98FHBmQiVoL18C6mzgq8hFtOUBQj1l7wrY7iBA1SE+f/47vK
         8fMg==
X-Gm-Message-State: AOAM533Wemv2YvNOWqEEufSp1kE+BJEGGXwKy4UXHDRY4HTGJXbw+jAm
        HUcnQFZlsrEY0n6YJySM5ns1pniCRcJNdkAiCESIU1TkKE3pkA+78SCYos7PbZ3N1CHrW3UyaHB
        RV71TNy4jBbb72WHO
X-Received: by 2002:a17:906:77c5:: with SMTP id m5mr27364257ejn.201.1618938582562;
        Tue, 20 Apr 2021 10:09:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw6gn2isDw3WqUDXHO63YDx5KhOxC+YyfUal3meuEXKHwTt4Ve781FuwcvJ5bPN0AapIjE8qg==
X-Received: by 2002:a17:906:77c5:: with SMTP id m5mr27364232ejn.201.1618938582404;
        Tue, 20 Apr 2021 10:09:42 -0700 (PDT)
Received: from localhost ([151.66.28.185])
        by smtp.gmail.com with ESMTPSA id r19sm12913751ejr.55.2021.04.20.10.09.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Apr 2021 10:09:41 -0700 (PDT)
Date:   Tue, 20 Apr 2021 19:09:38 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, song@kernel.org,
        toke@redhat.com
Subject: Re: [PATCH v3 bpf-next] cpumap: bulk skb using netif_receive_skb_list
Message-ID: <YH8K0gkYoZVfq0FV@lore-desk>
References: <01cd8afa22786b2c8a4cd7250d165741e990a771.1618927173.git.lorenzo@kernel.org>
 <20210420185440.1dfcf71c@carbon>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="X48EGoxOSC8+66zO"
Content-Disposition: inline
In-Reply-To: <20210420185440.1dfcf71c@carbon>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--X48EGoxOSC8+66zO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[...]
> > +	TP_ARGS(map_id, processed, sched, xdp_stats),
> > =20
> >  	TP_STRUCT__entry(
> >  		__field(int, map_id)
> >  		__field(u32, act)
> >  		__field(int, cpu)
> > -		__field(unsigned int, drops)
> >  		__field(unsigned int, processed)
>=20
> So, struct member @processed will takeover the room for @drops.
>=20
> Can you please test how an old xdp_monitor program will react to this?
> Will it fail, or extract and show wrong values?

Ack, right. I think we should keep the struct layout in order to maintain
back-compatibility. I will fix it in v4.

>=20
> The xdp_mointor tool is in several external git repos:
>=20
>  https://github.com/netoptimizer/prototype-kernel/blob/master/kernel/samp=
les/bpf/xdp_monitor_kern.c
>  https://github.com/xdp-project/xdp-tutorial/tree/master/tracing02-xdp-mo=
nitor
>=20
> Do you have any plans for fixing those tools?

I update xdp_monitor_{kern,user}.c and xdp_redirect_cpu_{kern,user}.c in the
patch. Do you mean to post a dedicated patch for xdp-project tutorial?

Regards,
Lorenzo

>=20
>=20
>=20
>=20
> --=20
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>=20

--X48EGoxOSC8+66zO
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCYH8K0AAKCRA6cBh0uS2t
rNYJAQCb772jtidNWS9ZSDM5wbswkXCz6KJpLOFAehcLc5flGAEAhCs+jMvOs1hI
GWt2R3oUmF1T3uv6Hx14tzIAeUmb1Qk=
=obBe
-----END PGP SIGNATURE-----

--X48EGoxOSC8+66zO--

