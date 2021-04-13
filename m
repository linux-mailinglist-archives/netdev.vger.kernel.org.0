Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 864A535E37B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 18:07:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346816AbhDMQHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 12:07:22 -0400
Received: from mail-ej1-f54.google.com ([209.85.218.54]:37460 "EHLO
        mail-ej1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346801AbhDMQHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Apr 2021 12:07:20 -0400
Received: by mail-ej1-f54.google.com with SMTP id w3so26847273ejc.4;
        Tue, 13 Apr 2021 09:07:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6DRUSASlmTAOxWFMoVHeutyBwen2MRnWIkfXsgZb1mI=;
        b=Mlxeee2Z5+SQNstCaif0nLHz6lDQMZL58SDeO5mUPwf88WtlraDT3LFpRtcLmQgSpQ
         pFZgAVdCZT/bZyF65wSl/aNu+h8v1yTJKUN9COmyT/tucMqW8BFfrnhsuW+bRmqpwXUb
         oWWrs2vbO5yGFriJMa4/jQ3uKq4V5xmBAieZApjZQ7b8BIolIEhxXdQO764gWEd+De1m
         Z4saIXohc41IXCa8pwuJQwCccjFFMag345GAOTPpZGOmzs/juqPk01k2bJ8kHtwCI2Dg
         ufnMQQPg0zr3s4Bwal1iXfg8qjybKk0+j8wBGMIV2lvo2UguiisMD7nNOh2w1wK7FR/M
         zw3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6DRUSASlmTAOxWFMoVHeutyBwen2MRnWIkfXsgZb1mI=;
        b=gmH6RDtUhaMDUC/9W24uKuRnSKqYa/X2p7eZoNbB3uZkxMM1QhOQpLLpOfcQc1zBU0
         /gLzbm1sxq7+C0C0xo8Xtv8uX4cky3mTJVt5k6UjTnDc/vgclqO4kS3NoPh1KrQym1VG
         fgXwKd5ClwBQVJwD9dmtf6iEcYXWFrxSkiJiqFho1DntNygIKE8+ofTd0eHrkXzEiXEX
         AOFGRE5yK+dbsh2+sic0Z2Jfi/HaZ4U+UmxpCKtT+lK2woQ39KT6XY0lI0OJE64e1HdA
         eb6qehxuuxF+qV8OSJ8XozJC/42zwFmPOBcox6WFesFn32sx/I+FfQk3dIDb3bwIDrVe
         7pQg==
X-Gm-Message-State: AOAM530U67TNW2zH+sag741LEUT5s4B233Ly58XN3Hc0lhpWnV631rXR
        VfMHBAOyKYL+Unz9M67jUyc=
X-Google-Smtp-Source: ABdhPJzjYpEmvNoGcDoRLAuBWY+pJ4ihTbKy0Arh5zvp557+7r/zKQa2GDrSqOB1daPkUrZOco3aEw==
X-Received: by 2002:a17:906:4bd2:: with SMTP id x18mr1345580ejv.1.1618329960023;
        Tue, 13 Apr 2021 09:06:00 -0700 (PDT)
Received: from localhost ([62.96.65.119])
        by smtp.gmail.com with ESMTPSA id v5sm9983095edx.87.2021.04.13.09.05.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 09:05:58 -0700 (PDT)
Date:   Tue, 13 Apr 2021 18:06:39 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Message-ID: <YHXBj3rsEjf8Y+qn@orome.fritz.box>
References: <8e92b562-fa8f-0a2b-d8da-525ee52fc2d4@nvidia.com>
 <DB8PR04MB67959FC7AF5CFCF1A08D10B2E6629@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
 <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
 <DB8PR04MB6795ECCB5E6E2091A45DADAEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <563db756-ebef-6c8b-ce7c-9dcadaecfea1@nvidia.com>
 <e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com>
 <DB8PR04MB6795C779FD47D5712DAE11CDE64F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="SnS3Je+SOopDMeC1"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB6795C779FD47D5712DAE11CDE64F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SnS3Je+SOopDMeC1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 13, 2021 at 12:13:01PM +0000, Joakim Zhang wrote:
>=20
> Hi Jon,
>=20
> > -----Original Message-----
> > From: Jon Hunter <jonathanh@nvidia.com>
> > Sent: 2021=E5=B9=B44=E6=9C=8813=E6=97=A5 16:41
> > To: Joakim Zhang <qiangqing.zhang@nxp.com>; Giuseppe Cavallaro
> > <peppe.cavallaro@st.com>; Alexandre Torgue <alexandre.torgue@st.com>;
> > Jose Abreu <joabreu@synopsys.com>
> > Cc: netdev@vger.kernel.org; Linux Kernel Mailing List
> > <linux-kernel@vger.kernel.org>; linux-tegra <linux-tegra@vger.kernel.or=
g>;
> > Jakub Kicinski <kuba@kernel.org>
> > Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when=
 mac
> > resume back
> >=20
> >=20
> > On 01/04/2021 17:28, Jon Hunter wrote:
> > >
> > > On 31/03/2021 12:41, Joakim Zhang wrote:
> > >
> > > ...
> > >
> > >>> In answer to your question, resuming from suspend does work on this
> > >>> board without your change. We have been testing suspend/resume now
> > >>> on this board since Linux v5.8 and so we have the ability to bisect
> > >>> such regressions. So it is clear to me that this is the change that=
 caused
> > this, but I am not sure why.
> > >>
> > >> Yes, I know this issue is regression caused by my patch. I just want=
 to
> > analyze the potential reasons. Due to the code change only related to t=
he page
> > recycle and reallocate.
> > >> So I guess if this page operate need IOMMU works when IOMMU is enabl=
ed.
> > Could you help check if IOMMU driver resume before STMMAC? Our common
> > desire is to find the root cause, right?
> > >
> > >
> > > Yes of course that is the desire here indeed. I had assumed that the
> > > suspend/resume order was good because we have never seen any problems,
> > > but nonetheless it is always good to check. Using ftrace I enabled
> > > tracing of the appropriate suspend/resume functions and this is what I
> > > see ...
> > >
> > > # tracer: function
> > > #
> > > # entries-in-buffer/entries-written: 4/4   #P:6
> > > #
> > > #                                _-----=3D> irqs-off
> > > #                               / _----=3D> need-resched
> > > #                              | / _---=3D> hardirq/softirq
> > > #                              || / _--=3D> preempt-depth
> > > #                              ||| /     delay
> > > #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
> > > #              | |         |   ||||      |         |
> > >          rtcwake-748     [000] ...1   536.700777:
> > stmmac_pltfr_suspend <-platform_pm_suspend
> > >          rtcwake-748     [000] ...1   536.735532:
> > arm_smmu_pm_suspend <-platform_pm_suspend
> > >          rtcwake-748     [000] ...1   536.757290:
> > arm_smmu_pm_resume <-platform_pm_resume
> > >          rtcwake-748     [003] ...1   536.856771:
> > stmmac_pltfr_resume <-platform_pm_resume
> > >
> > >
> > > So I don't see any ordering issues that could be causing this.
> >=20
> >=20
> > Another thing I have found is that for our platform, if the driver for =
the ethernet
> > PHY (in this case broadcom PHY) is enabled, then it fails to resume but=
 if I
> > disable the PHY in the kernel configuration, then resume works. I have =
found
> > that if I move the reinit of the RX buffers to before the startup of th=
e phy, then
> > it can resume OK with the PHY enabled.
> >=20
> > Does the following work for you? Does your platform use a specific ethe=
rnet
> > PHY driver?
>=20
> I am also looking into this issue these days, we use the Realtek RTL8211F=
DI PHY, driver is drivers/net/phy/realtek.c.
>=20
> For our EQOS MAC integrated in our SoC, Rx side logic depends on RXC cloc=
k from PHY, so we need phylink_start before MAC.
>=20
> I will test below code change tomorrow to see if it can work at my side, =
since it is only re-init memory, need not RXC clock.
>=20
>=20
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > index 208cae344ffa..071d15d86dbe 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > @@ -5416,19 +5416,20 @@ int stmmac_resume(struct device *dev)
> >                         return ret;
> >         }
> > +       rtnl_lock();
> > +       mutex_lock(&priv->lock);
> > +       stmmac_reinit_rx_buffers(priv);
> > +       mutex_unlock(&priv->lock);
> > +
> >         if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> > -               rtnl_lock();
> >                 phylink_start(priv->phylink);
> >                 /* We may have called phylink_speed_down before */
> >                 phylink_speed_up(priv->phylink);
> > -               rtnl_unlock();
> >         }
> > -       rtnl_lock();
> >         mutex_lock(&priv->lock);
> >         stmmac_reset_queues_param(priv);
> > -       stmmac_reinit_rx_buffers(priv);
> >         stmmac_free_tx_skbufs(priv);
> >         stmmac_clear_descriptors(priv);
> >=20
> >=20
> > It is still not clear to us why the existing call to
> > stmmac_clear_descriptors() is not sufficient to fix your problem.
>=20
> During suspend/resume stress test, I found rx descriptor may not refill w=
hen system suspended, rx descriptor could be: 008 [0x00000000c4310080]: 0x0=
 0x40 0x0 0x34010040.
> When system resume back, stmmac_clear_descriptors() would change this rx =
descriptor to: 008 [0x00000000c4310080]: 0x0 0x40 0x0 0xb5010040, a broken =
rx descriptor.
> So at my side, stmmac_clear_descriptors() seems to be chief culprit. I ha=
ve a idea if there is way to ensure all rx descriptors are refilled when su=
spend MAC.
>=20
> > How often does the issue you see occur?
> Suspend about 2000 times.

Hi David, Jakub,

given where we are in the release cycle, I think it'd be best to revert
commit 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume
back") for now.

To summarize the discussion: the patch was meant as a workaround to fix
an occasional suspend/resume failure on one board that was not fully
root caused, and ends up causing fully reproducible suspend/resume
failures on at least one other board.

Joakim is looking at an alternative solution and Jon and I can provide
testing from the Tegra side for any fixes.

Do you want me to send a revert patch or can you revert directly on top
of your tree?

Thanks,
Thierry

--SnS3Je+SOopDMeC1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmB1wY0ACgkQ3SOs138+
s6FlDw//fLvU5IFfg7K8NrwttAmDZCmPUqKe0hplO2oPC63wQQatbKdKP45+/WFJ
yym31/D1MDnH0ppo+sW8BYkoD/3GhGCZrj0J+jWK9jMTDYt4eBuDzauf7VJDWEQZ
G01D6sFEj5AnOaAV8mLV1lXnawf/xFvpNZm2dc/Y/FhZM3ztXl4I8MW/L99yCwgN
ZZ7b6EGo+qzat3VROqiMMoIpkGhmgBLXgNTB8SJXr+2Oy9iOa/OoOdAP6Dtumj/O
bFd2OkQ6pyE/zwaaXtHfufao7Hl68C0M/1GqgOaLHSAwheKTphCeq7AGVvWb8Ubb
vothZhkcuK89VDuCPXlTrZJGTbEAf7p0w7I1TZEtNfC68KSm+NeSMQfTKIzuqoo3
Amd7dF33tAPzzWgPtOToTqRKVsE9qpPT6/ul/Y0HKyaM8oEzt9jm3LG7VCmd/aLJ
I6XVvzVq0AEbBafNZ5VbwDVjNJywF3PZ0tzAzFODshpXHxlXN7YhER+qcP+ns/pr
lOMAfosNHWFGBvgv0mTxV7Chb6A+ec/jKQfOfecsiO/NC2t/RDs2tS6SRbhRjpD7
isU+lzLlMG0iDoXdWxnd7FjHETc1CuzbqD75S3azlCBmhy94s6KE+N8Ip9wYLjjy
aMmmiAnhibLLgS3DYQK33DiDc9DBnCREWuP6fTnYdiQBN2LEqI0=
=X8uh
-----END PGP SIGNATURE-----

--SnS3Je+SOopDMeC1--
