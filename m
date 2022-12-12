Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36ECC64A972
	for <lists+netdev@lfdr.de>; Mon, 12 Dec 2022 22:19:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbiLLVT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 16:19:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiLLVSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 16:18:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D8071A3A3
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670879737;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=yEoWp9TQqs4PCV9R29Z8hbV04G7jixIJ+q9chrue/2w=;
        b=QZjZvYki/nSR6UvzfkxFfPnjOAzWh9oDtRBpbheP6jsv1i/Npeh0iPRO0E3muh1x/kukvL
        GBiuEAl2Dg06qqjPHccO9KNtRtT5cYBadHFgTvLTMH8U2fH23pv412r+SBHA+FfE4aOjnW
        jGkkkm0NXkInB80HvgGGw2fkocAYHrI=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-448-f-JoxEWCMN-tomKe08ibaQ-1; Mon, 12 Dec 2022 16:15:36 -0500
X-MC-Unique: f-JoxEWCMN-tomKe08ibaQ-1
Received: by mail-wr1-f72.google.com with SMTP id o8-20020adfba08000000b00241e80f08e0so2578920wrg.12
        for <netdev@vger.kernel.org>; Mon, 12 Dec 2022 13:15:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yEoWp9TQqs4PCV9R29Z8hbV04G7jixIJ+q9chrue/2w=;
        b=4nDlpfYmKVXKPAb21semk7z2n5zcTz5GmOMvrrLGqb0p5I36WDHj1mig1TJoWsJqip
         9YqgrPAmpPSM9Cyp8xdw24bQV7e3KH3xZNhbeLWVxDzTsrsECf0F1+L5W8eBKr48mJOb
         JlOYeen6kTEECRxb63UnoVS5ceAKzwbPPz+UwatQ5MDW+Zb/uHIVNndiEM7jJa1F51kd
         hkJ/I5HPn0p+b1hfV8ukSRk+/k+IT+stcOe4xE770FvYalnZHFJfnuJ9P7OwbhTEBSBU
         oeFA71iHmF+A1LxV8PUFePnp2fUopxp6NMG6XFyQUqXSmqdc/7DIZKhvXSldJG2MMIxP
         Yv1g==
X-Gm-Message-State: ANoB5pkrDZ4nmKgvuz5CGGJRjo5hlN1sHStSi5oalvv5mlMjPU3h1Qg8
        yVdQEdL2y/CbNzU/4eCvvF6fVrMlx49N1mbgdUf4aKO3kk3Oh3QZOac3mJCYP2HTbclMP7KXlo2
        Fdf3Af0K0M1+OrX0i
X-Received: by 2002:a5d:4908:0:b0:242:285:6b39 with SMTP id x8-20020a5d4908000000b0024202856b39mr11821725wrq.50.1670879734893;
        Mon, 12 Dec 2022 13:15:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf5ubOEMzv09PGyyt+9HFIW++TrfGJuB28dzX+Vj/DKXRezPBLjgY9egNLJuojKYxqJIjMYGuQ==
X-Received: by 2002:a5d:4908:0:b0:242:285:6b39 with SMTP id x8-20020a5d4908000000b0024202856b39mr11821712wrq.50.1670879734624;
        Mon, 12 Dec 2022 13:15:34 -0800 (PST)
Received: from localhost (net-188-216-77-84.cust.vodafonedsl.it. [188.216.77.84])
        by smtp.gmail.com with ESMTPSA id e16-20020adffc50000000b00241fab5a296sm9715318wrs.40.2022.12.12.13.15.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Dec 2022 13:15:33 -0800 (PST)
Date:   Mon, 12 Dec 2022 22:15:31 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Subject: Re: [PATCH v3 net-next 0/2] enetc: unlock XDP_REDIRECT for XDP
 non-linear
Message-ID: <Y5eZ87w4EKnmWFuW@lore-desk>
References: <cover.1670680119.git.lorenzo@kernel.org>
 <20221212195130.w2f5ykiwek4jrvqu@skbuf>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RhHQ5CSp6vL0NqPv"
Content-Disposition: inline
In-Reply-To: <20221212195130.w2f5ykiwek4jrvqu@skbuf>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--RhHQ5CSp6vL0NqPv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Sat, Dec 10, 2022 at 02:53:09PM +0100, Lorenzo Bianconi wrote:
> > Unlock XDP_REDIRECT for S/G XDP buffer and rely on XDP stack to properly
> > take care of the frames.
> > Remove xdp_redirect_sg counter and the related ethtool entry since it is
> > no longer used.
> >=20
> > Changes since v2:
> > - remove xdp_redirect_sg ethtool counter
> > Changes since v1:
> > - drop Fixes tag
> > - unlock XDP_REDIRECT
> > - populate missing XDP metadata
> >=20
> > Please note this patch is just compile tested
> >=20
> > Lorenzo Bianconi (2):
> >   net: ethernet: enetc: unlock XDP_REDIRECT for XDP non-linear buffers
> >   net: ethernet: enetc: get rid of xdp_redirect_sg counter
> >=20
> >  drivers/net/ethernet/freescale/enetc/enetc.c  | 25 ++++++++-----------
> >  drivers/net/ethernet/freescale/enetc/enetc.h  |  1 -
> >  .../ethernet/freescale/enetc/enetc_ethtool.c  |  2 --
> >  3 files changed, 10 insertions(+), 18 deletions(-)
>=20
> NACK.
>=20
> xdp_redirect_cpu works, but OOM is still there if we XDP_REDIRECT to
> another interface. That needs to be solved first.

Hi Vladimir,

thx for testing. If we perform XDP_REDIRECT with SG XDP frames, the devmap
code will always return an error and the driver is responsible to free the
pending pages. Looking at the code, can the issue be the following?

- enetc_flip_rx_buff() will unmap the page and set rx_swbd->page =3D NULL if
  the page is not reusable.
- enetc_xdp_free() will not be able to free the page since rx_swbd->page is
  NULL.

What do you think? I am wondering if we have a similar issue for 'linear' X=
DP
buffer as well when xdp_do_redirect() returns an error. What do you think?

Regards,
Lorenzo

>=20
> root@debian:~# ./bpf/xdp_redirect eno0 eno2
> [  313.613983] fsl_enetc 0000:00:00.0 eno0: Link is Down
> [  313.699861] fsl_enetc 0000:00:00.0 eno0: PHY [0000:00:00.3:02] driver =
[Qualcomm Atheros AR8031/AR8033] (irq=3DPOLL)
> [  313.735530] fsl_enetc 0000:00:00.0 eno0: configuring for inband/sgmii =
link mode
> [  313.754024] fsl_enetc 0000:00:00.2 eno2: Link is Down
> [  313.798565] fsl_enetc 0000:00:00.2 eno2: configuring for fixed/interna=
l link mode
> [  313.806252] fsl_enetc 0000:00:00.2 eno2: Link is Up - 2.5Gbps/Full - f=
low control rx/tx
> Redirecting from eno0 (ifindex 6; driver fsl_enetc) to eno2 (ifindex 7; d=
river fsl_enetc)
> [  315.791491] fsl_enetc 0000:00:00.0 eno0: Link is Up - 1Gbps/Full - flo=
w control rx/tx
> [  315.799451] IPv6: ADDRCONF(NETDEV_CHANGE): eno0: link becomes ready
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                  19806 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                  81274 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                  81275 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                  81274 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                  81274 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                  75733 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                   1562 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> eno0->eno2                      0 rx/s                  0 err,drop/s     =
       0 xmit/s
> ^Z
> [1]+  Stopped                 ./nxp_board_rootfs/bpf/xdp_redirect eno0 en=
o2
> [  347.901643] bash invoked oom-killer: gfp_mask=3D0x40cc0(GFP_KERNEL|__G=
FP_COMP), order=3D0, oom_score_adj=3D0
> [  347.911254] CPU: 1 PID: 412 Comm: bash Not tainted 6.1.0-rc8-07010-ga9=
b9500ffaac-dirty #754
> [  347.919676] Hardware name: LS1028A RDB Board (DT)
> [  347.924423] Call trace:
> [  347.926901]  dump_backtrace.part.0+0xe8/0xf4
> [  347.931223]  show_stack+0x20/0x50
> [  347.934579]  dump_stack_lvl+0x8c/0xb8
> [  347.938288]  dump_stack+0x18/0x34
> [  347.941644]  dump_header+0x50/0x2ec
> [  347.945182]  oom_kill_process+0x384/0x390
> [  347.949243]  out_of_memory+0x218/0x670
> [  347.953039]  __alloc_pages+0xf28/0x1080
> [  347.956919]  cache_grow_begin+0x98/0x390
> [  347.960887]  fallback_alloc+0x1f8/0x2bc
> [  347.964765]  ____cache_alloc_node+0x17c/0x194
> [  347.969168]  kmem_cache_alloc+0x214/0x2d0
> [  347.973222]  getname_flags.part.0+0x3c/0x1a4
> [  347.977536]  getname_flags+0x4c/0x7c
> [  347.981151]  vfs_fstatat+0x4c/0x90
> [  347.984595]  __do_sys_newfstatat+0x2c/0x70
> [  347.988737]  __arm64_sys_newfstatat+0x28/0x34
> [  347.993140]  invoke_syscall+0x50/0x120
> [  347.996939]  el0_svc_common.constprop.0+0x68/0x124
>=20

--RhHQ5CSp6vL0NqPv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCY5eZ8wAKCRA6cBh0uS2t
rBuiAP9k+VrHRu+ApIqAvt8bQTuO+e3Jk2k/I2OcUxBLGFmwOgD+O0M/g3poFAgj
7XcdFPtEBh0b5A+b0oPOJk7TEUmfBg4=
=6fhj
-----END PGP SIGNATURE-----

--RhHQ5CSp6vL0NqPv--

