Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEE4A35EE8C
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 09:42:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345885AbhDNHlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 03:41:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbhDNHlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 03:41:11 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E9EC061756;
        Wed, 14 Apr 2021 00:40:50 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id w23so22472469edx.7;
        Wed, 14 Apr 2021 00:40:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=80Qd9PfmXEElBq5Bw2RPALbbShqf59gjKQ7KZtbQCCc=;
        b=Q+10TqEOdMlB8xcncrwx/H8MtuiRtvLQtCn5mtyUGhjlf12jzeSH7nNDshfMlCfqWE
         /HrD4DT0x5ZB5RHG9c3Okai3HbrWKXdaSbmELFnuYAm+JjgRHvNUv94nn+e/QJcfuDKU
         ESpEoBMH3NbWz0DlO8Rqcx4TKSMS2vtgczQ/ai0TNV/WYOTxQCs9/BGf3WppWww9hKSF
         VYPE5nFQwcSU7Jim23EQhur0ISooea+1oHTYRE7xXQExBa98rSjJN2+jAHvZ+O7CblGG
         PZmEki6tSGNJ5mHzxYJqD8PG5okaqhXlGP4svWU3KqPSgVFz/SaFTJFdRZN8zbpMxSar
         yhiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=80Qd9PfmXEElBq5Bw2RPALbbShqf59gjKQ7KZtbQCCc=;
        b=MNv0B41UP1+vyYCl7xqtyNvO9Ejv3pqW5xSR2F6DJdFF14F1ZrrWGhKPEzDSru/K83
         W2iumKKeYDUslDygktNibYrpbkio1yVRV57Dc50GkHhs5DkwjFsbp050nA8rWHZHdj7i
         7GDrsiZ5vD1uan1nOkFH0aSPwlGxW5EhYxlix7zCloODoSZDZpxiwFNBTBBN6v+DHP6O
         pFEZH3SOf68wigoywKK663DyQET32oG3p3NIsZ/V25Yl0QcpUg+QECuyIfFglXlbN6vT
         u5VjSROCPFAkppNQu2dAjiSX1N8cq9Brwd4zrCxU6k26rs0npdMHeYub+xJlUrNRBZJP
         UrLw==
X-Gm-Message-State: AOAM532ECX7eXRcSDNnS5gC+cXnlQia9pOzp1wg1AH9p8wKXSZa0MAoV
        W0I5zA00EiRzWhxpIU4z+0s=
X-Google-Smtp-Source: ABdhPJyADL1wSUkLF10xAqr5zOp7oLbVJY2lBhDloGGDQ/XQM7WPNzWdgqAAtfe0X988WW68DhxOog==
X-Received: by 2002:aa7:c549:: with SMTP id s9mr33632223edr.326.1618386049097;
        Wed, 14 Apr 2021 00:40:49 -0700 (PDT)
Received: from localhost (p200300e41f0ee8007e7a91fffecb6227.dip0.t-ipconnect.de. [2003:e4:1f0e:e800:7e7a:91ff:fecb:6227])
        by smtp.gmail.com with ESMTPSA id hs26sm5058083ejc.23.2021.04.14.00.40.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Apr 2021 00:40:47 -0700 (PDT)
Date:   Wed, 14 Apr 2021 09:40:46 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Hunter <jonathanh@nvidia.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>
Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when mac
 resume back
Message-ID: <YHacfq+pWEbQDsZT@aiwendil>
References: <ac9f8a31-536e-ec75-c73f-14a0623c5d56@nvidia.com>
 <DB8PR04MB6795F4333BCA9CE83C288FEEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <DB8PR04MB6795D4C733DC4938B1D62EBDE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <85f02fbc-6956-2b19-1779-cd51b2e71e3d@nvidia.com>
 <DB8PR04MB6795ECCB5E6E2091A45DADAEE67C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <563db756-ebef-6c8b-ce7c-9dcadaecfea1@nvidia.com>
 <e4864046-e52f-63b6-a490-74c3cd8045f4@nvidia.com>
 <DB8PR04MB6795C779FD47D5712DAE11CDE64F9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <YHXBj3rsEjf8Y+qn@orome.fritz.box>
 <DB8PR04MB67953DBB6358D7EC80149E5CE64E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="wPZj+6vf0GB7zbl7"
Content-Disposition: inline
In-Reply-To: <DB8PR04MB67953DBB6358D7EC80149E5CE64E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
User-Agent: Mutt/2.0.6 (98f8cb83) (2021-03-06)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--wPZj+6vf0GB7zbl7
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 14, 2021 at 02:18:58AM +0000, Joakim Zhang wrote:
>=20
> > -----Original Message-----
> > From: Thierry Reding <thierry.reding@gmail.com>
> > Sent: 2021=E5=B9=B44=E6=9C=8814=E6=97=A5 0:07
> > To: David S. Miller <davem@davemloft.net>; Jakub Kicinski <kuba@kernel.=
org>
> > Cc: Joakim Zhang <qiangqing.zhang@nxp.com>; Jon Hunter
> > <jonathanh@nvidia.com>; Giuseppe Cavallaro <peppe.cavallaro@st.com>;
> > Alexandre Torgue <alexandre.torgue@st.com>; Jose Abreu
> > <joabreu@synopsys.com>; netdev@vger.kernel.org; Linux Kernel Mailing Li=
st
> > <linux-kernel@vger.kernel.org>; linux-tegra <linux-tegra@vger.kernel.or=
g>
> > Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers when=
 mac
> > resume back
> >=20
> > On Tue, Apr 13, 2021 at 12:13:01PM +0000, Joakim Zhang wrote:
> > >
> > > Hi Jon,
> > >
> > > > -----Original Message-----
> > > > From: Jon Hunter <jonathanh@nvidia.com>
> > > > Sent: 2021=E5=B9=B44=E6=9C=8813=E6=97=A5 16:41
> > > > To: Joakim Zhang <qiangqing.zhang@nxp.com>; Giuseppe Cavallaro
> > > > <peppe.cavallaro@st.com>; Alexandre Torgue
> > > > <alexandre.torgue@st.com>; Jose Abreu <joabreu@synopsys.com>
> > > > Cc: netdev@vger.kernel.org; Linux Kernel Mailing List
> > > > <linux-kernel@vger.kernel.org>; linux-tegra
> > > > <linux-tegra@vger.kernel.org>; Jakub Kicinski <kuba@kernel.org>
> > > > Subject: Re: Regression v5.12-rc3: net: stmmac: re-init rx buffers
> > > > when mac resume back
> > > >
> > > >
> > > > On 01/04/2021 17:28, Jon Hunter wrote:
> > > > >
> > > > > On 31/03/2021 12:41, Joakim Zhang wrote:
> > > > >
> > > > > ...
> > > > >
> > > > >>> In answer to your question, resuming from suspend does work on
> > > > >>> this board without your change. We have been testing
> > > > >>> suspend/resume now on this board since Linux v5.8 and so we have
> > > > >>> the ability to bisect such regressions. So it is clear to me
> > > > >>> that this is the change that caused
> > > > this, but I am not sure why.
> > > > >>
> > > > >> Yes, I know this issue is regression caused by my patch. I just
> > > > >> want to
> > > > analyze the potential reasons. Due to the code change only related
> > > > to the page recycle and reallocate.
> > > > >> So I guess if this page operate need IOMMU works when IOMMU is
> > enabled.
> > > > Could you help check if IOMMU driver resume before STMMAC? Our
> > > > common desire is to find the root cause, right?
> > > > >
> > > > >
> > > > > Yes of course that is the desire here indeed. I had assumed that
> > > > > the suspend/resume order was good because we have never seen any
> > > > > problems, but nonetheless it is always good to check. Using ftrace
> > > > > I enabled tracing of the appropriate suspend/resume functions and
> > > > > this is what I see ...
> > > > >
> > > > > # tracer: function
> > > > > #
> > > > > # entries-in-buffer/entries-written: 4/4   #P:6
> > > > > #
> > > > > #                                _-----=3D> irqs-off
> > > > > #                               / _----=3D> need-resched
> > > > > #                              | / _---=3D> hardirq/softirq
> > > > > #                              || / _--=3D> preempt-depth
> > > > > #                              ||| /     delay
> > > > > #           TASK-PID     CPU#  ||||   TIMESTAMP  FUNCTION
> > > > > #              | |         |   ||||      |         |
> > > > >          rtcwake-748     [000] ...1   536.700777:
> > > > stmmac_pltfr_suspend <-platform_pm_suspend
> > > > >          rtcwake-748     [000] ...1   536.735532:
> > > > arm_smmu_pm_suspend <-platform_pm_suspend
> > > > >          rtcwake-748     [000] ...1   536.757290:
> > > > arm_smmu_pm_resume <-platform_pm_resume
> > > > >          rtcwake-748     [003] ...1   536.856771:
> > > > stmmac_pltfr_resume <-platform_pm_resume
> > > > >
> > > > >
> > > > > So I don't see any ordering issues that could be causing this.
> > > >
> > > >
> > > > Another thing I have found is that for our platform, if the driver
> > > > for the ethernet PHY (in this case broadcom PHY) is enabled, then it
> > > > fails to resume but if I disable the PHY in the kernel
> > > > configuration, then resume works. I have found that if I move the
> > > > reinit of the RX buffers to before the startup of the phy, then it =
can resume
> > OK with the PHY enabled.
> > > >
> > > > Does the following work for you? Does your platform use a specific
> > > > ethernet PHY driver?
> > >
> > > I am also looking into this issue these days, we use the Realtek RTL8=
211FDI
> > PHY, driver is drivers/net/phy/realtek.c.
> > >
> > > For our EQOS MAC integrated in our SoC, Rx side logic depends on RXC =
clock
> > from PHY, so we need phylink_start before MAC.
> > >
> > > I will test below code change tomorrow to see if it can work at my si=
de, since
> > it is only re-init memory, need not RXC clock.
> > >
> > >
> > > > diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > > b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > > index 208cae344ffa..071d15d86dbe 100644
> > > > --- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > > +++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
> > > > @@ -5416,19 +5416,20 @@ int stmmac_resume(struct device *dev)
> > > >                         return ret;
> > > >         }
> > > > +       rtnl_lock();
> > > > +       mutex_lock(&priv->lock);
> > > > +       stmmac_reinit_rx_buffers(priv);
> > > > +       mutex_unlock(&priv->lock);
> > > > +
> > > >         if (!device_may_wakeup(priv->device) || !priv->plat->pmt) {
> > > > -               rtnl_lock();
> > > >                 phylink_start(priv->phylink);
> > > >                 /* We may have called phylink_speed_down before */
> > > >                 phylink_speed_up(priv->phylink);
> > > > -               rtnl_unlock();
> > > >         }
> > > > -       rtnl_lock();
> > > >         mutex_lock(&priv->lock);
> > > >         stmmac_reset_queues_param(priv);
> > > > -       stmmac_reinit_rx_buffers(priv);
> > > >         stmmac_free_tx_skbufs(priv);
> > > >         stmmac_clear_descriptors(priv);
> > > >
> > > >
> > > > It is still not clear to us why the existing call to
> > > > stmmac_clear_descriptors() is not sufficient to fix your problem.
> > >
> > > During suspend/resume stress test, I found rx descriptor may not refi=
ll when
> > system suspended, rx descriptor could be: 008 [0x00000000c4310080]: 0x0
> > 0x40 0x0 0x34010040.
> > > When system resume back, stmmac_clear_descriptors() would change this=
 rx
> > descriptor to: 008 [0x00000000c4310080]: 0x0 0x40 0x0 0xb5010040, a bro=
ken
> > rx descriptor.
> > > So at my side, stmmac_clear_descriptors() seems to be chief culprit. =
I have a
> > idea if there is way to ensure all rx descriptors are refilled when sus=
pend MAC.
> > >
> > > > How often does the issue you see occur?
> > > Suspend about 2000 times.
> >=20
> > Hi David, Jakub,
> >=20
> > given where we are in the release cycle, I think it'd be best to revert=
 commit
> > 9c63faaa931e ("net: stmmac: re-init rx buffers when mac resume
> > back") for now.
> >=20
> > To summarize the discussion: the patch was meant as a workaround to fix=
 an
> > occasional suspend/resume failure on one board that was not fully root =
caused,
> > and ends up causing fully reproducible suspend/resume failures on at le=
ast one
> > other board.
> >=20
> > Joakim is looking at an alternative solution and Jon and I can provide =
testing
> > from the Tegra side for any fixes.
> >=20
> > Do you want me to send a revert patch or can you revert directly on top=
 of your
> > tree?
>=20
> Hi Thierry, David, Jakub,
>=20
> From my point of view, it is not a good choose to send a revert patch dir=
ectly.
>=20
> At my side, I have found the root cause. When system suspended, it is
> possible that there are packets have not been received yet, such as:
> 008 [0x00000000c4310080]: 0x0 0x40 0x0 0x34010040.
>=20
> After system resume, stmmac_clear_descriptors() clear the descriptor,
> let it becomes below, it is a broken descriptor.
> 008 [0x00000000c4310080]: 0x0 0x40 0x0 0xb5010040

So it sounds like that is what needs to be fixed. Reallocating all
buffers and rewriting the descriptors seems more of a sledgehammer
approach than a proper fix to this problem.

> I think it is a software bug there, and I don't know why others have
> not reported it. This is a random issue, but there is a certain
> probability that it will occur.

If this is really as rare as you say, I'm not completely surprised that
nobody has reported it.

> My patch is a solution, may not a good solution, now it seems not a
> workaround.

It's not an acceptable solution if it causes a regression.

> At Joh's side, said it is related to IOMMU first, and then said
> re-init rx buffers before PHY start also can fix it, and this patch
> also only breaks one of their boards.

It's certainly possible that IOMMU has some sort of impact on the
reproducibility of the issue, but it's also a fact that before this
patch the systems that are now broken had been working.

Also, it's not relevant how many boards are broken. If a patch breaks a
single setup that used to work, that's a regression. What your patch
does is basically exchanging one working setup for another. And the
regression is even worse than the issue that you were trying to fix:
Jetson TX2 reliably fails to resume properly *every time*, whereas you
confirmed that you're only seeing this particular issue about once in
2000 suspend/resume cycles.

That's not how we do kernel development. Jon reported the regression 3
weeks ago and nobody's come up with a fix that solves this properly and
for everyone. Given that we may only have 4 days left before the final
release, the safest course of action at this point is to revert and then
we can try again for the next cycle. Jon and I can help test any patches
on the Tegra side.

> This makes me think there is a specific integration in their SoCs.

Even if this was an integration issue, which I doubt, that's completely
irrelevant. What's relevant is that the setup was working before this
patch.

> I have not seen others report it is broken at their side.

Prior to your patch submission, did anybody report that suspend/resume
was broken for them? Also, if you are the only one seeing this issue,
perhaps this is an integration issue in your SoC?

As you can see this kind of argument makes us go in circles, hence why
we have the rule that when a patch causes a regression it either gets
fixed or reverted. Anything else leads to insanity.

> Theoretically, at least, this patch should have no side effect.

Sorry, but that's not a valid argument. Practically this is causing a
problem and that counts more than theory.

> In conclusion, we can revert this patch if we can find a better way to
> fix this issue (packets have not received when system suspended).

Again, not how it works. The patch should be reverted to restore
functionality for setups that were previously working. Then we can can
try to find a better way to fix this issue.

I'm not confident that we can find that proper fix within the next few
days, so let's try again for the next release cycle.

Thierry

--wPZj+6vf0GB7zbl7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmB2nHsACgkQ3SOs138+
s6G70xAAvoaggSgN+xUnDx6RzxtaEnUiRXQiOTPFsAlYcBtpliC7MXfuKTGOA6v4
dtyEonDhg+bXgJ/xi30DpCyvKtLiYrfTE6+u4T4nIqEFVVlfYkUwPnuWy1eMY0M8
EjnGVnaJmK1rZ6HwkWMoEMwUG41JPSHAcf9QhYxYnS9PZC41lCWpB67LUtb23RxV
JqKVHkNx9qMCYgLqzzrXLxQFeixKkQYHbXJDIhdVzYHY74SOR0WY0lRhb3coSZtY
eemG39U3fWxdFldJfubAzc27V3D+mmi0vDB8TnO6jbqdPoKL/q1+7VOX2RqCbC0g
2jwtMMshDDxn5KVkvqqBy8mSLGdlLyIXDQkX2QK5EBYHGxicZJ8xFv5hKLVSyV04
aCkmEZCRrPziAfpcGZCcATIzN7C4CQsat0d6w/nZNaMs8IenPNUlyvccSLaAYm1y
sJgJaypMRXhbSDzjo65hfteSxl/pTR2U/HBij0liC3Gcbx7QCSSmxojWETSBzbbJ
SMEobabFA9w9L+5L3+LZpZ0EH8kFoEO5X8FuFvHwZviVyXIlFTbaEcZxurrjZh5g
p36JCaIp3HtMKaKPQhkgNc8tehroL7TDjrQe3Ux6d6AdBoP2ag+h/N5ZWKBx+hpY
ROYZlJ0V3UU8JB/BecW9TwfdYyRVw3FQTV2/evphGpmvGR83iEg=
=BBn2
-----END PGP SIGNATURE-----

--wPZj+6vf0GB7zbl7--
