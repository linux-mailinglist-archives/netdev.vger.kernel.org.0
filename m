Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5505D435B5D
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 09:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231282AbhJUHKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 03:10:40 -0400
Received: from mx1.tq-group.com ([93.104.207.81]:44971 "EHLO mx1.tq-group.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230220AbhJUHKi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 03:10:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634800103; x=1666336103;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=66rOrQeN+xfmoNg6r4UCYTzu2221zyQ3mTB2Kq6ryGo=;
  b=J8BnNJy8oY3SWvpR0cNl2qxbXC2kznt79KyT+cLrqjOYmp7lQJdTFGQc
   /fyiAG57Askr2V+zNrLxmu2UxQtdoPIVHzWnmduXa6GuDyK1USKRU1/4H
   8ZnNJa6aQCi9eHRHBURQrY73Vc1+r/VmgwW7Psw/tdbS+gkJXzAzSUdDf
   p/R01TRF1xvLYQVc/dku3/B+RPKSo+JV2oYiIeFaiSpNVYOA/Gjhkpqvz
   2pVuzQxWlImcCsatAlfffg+Tv0tjjAq6SeMF6DUJMFFRl9iVBF7Rm37RG
   Rb3AsuclgPSljvayIH6j8qtLBsk1F7QALwFh7aV6cCtcwswp5deeicw4r
   A==;
X-IronPort-AV: E=Sophos;i="5.87,169,1631570400"; 
   d="scan'208";a="20167327"
Received: from unknown (HELO tq-pgp-pr1.tq-net.de) ([192.168.6.15])
  by mx1-pgp.tq-group.com with ESMTP; 21 Oct 2021 09:08:21 +0200
Received: from mx1.tq-group.com ([192.168.6.7])
  by tq-pgp-pr1.tq-net.de (PGP Universal service);
  Thu, 21 Oct 2021 09:08:21 +0200
X-PGP-Universal: processed;
        by tq-pgp-pr1.tq-net.de on Thu, 21 Oct 2021 09:08:21 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=tq-group.com; i=@tq-group.com; q=dns/txt; s=key1;
  t=1634800101; x=1666336101;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=66rOrQeN+xfmoNg6r4UCYTzu2221zyQ3mTB2Kq6ryGo=;
  b=B9PypCYcjmdUhu5qgr7SLyUp01H2zjkuDZgHO5ltgyytlEMlCH9dDiJU
   fOvPDfCpchG1uiBz6aNFkheuGtcbJMUFTricIS3mnNCYeDvdLZA3GsFnW
   S2HmhpLv+mzOwXFRHj8Arrroh6IdDw5Lw0lvc/pe+Xh8DnHkOe8eypwl2
   /aq2hP5OUuOIQgqC54E62KIZfCv0m1gAgzM/v9Fa9KFZ+43Gjb/CYBvWm
   7emYiPE0mXJenELbwwRp/nGEGI6JugX40byql4+BhRmkGpwLZ5PrSi1BM
   6wG1FhaaK3qZTOseeCw7LXyH+q/48Nd+dRLbsOFfPoGSUQ3OqyoBCVTBR
   w==;
X-IronPort-AV: E=Sophos;i="5.87,169,1631570400"; 
   d="scan'208";a="20167326"
Received: from vtuxmail01.tq-net.de ([10.115.0.20])
  by mx1.tq-group.com with ESMTP; 21 Oct 2021 09:08:21 +0200
Received: from schifferm-ubuntu4.tq-net.de (schifferm-ubuntu4.tq-net.de [10.121.48.12])
        by vtuxmail01.tq-net.de (Postfix) with ESMTPA id 6B230280065;
        Thu, 21 Oct 2021 09:08:21 +0200 (CEST)
Message-ID: <c286107376a99ca2201db058e1973e2b2264e9fb.camel@ew.tq-group.com>
Subject: Re: (EXT) Re: [PATCH] net: fec: defer probe if PHY on external MDIO
 bus is not available
From:   Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Thu, 21 Oct 2021 09:08:19 +0200
In-Reply-To: <YXBk8gwuCqrxDbVY@lunn.ch>
References: <20211014113043.3518-1-matthias.schiffer@ew.tq-group.com>
         <YW7SWKiUy8LfvSkl@lunn.ch>
         <aae9573f89560a32da0786dc90cb7be0331acad4.camel@ew.tq-group.com>
         <YXBk8gwuCqrxDbVY@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-10-20 at 20:50 +0200, Andrew Lunn wrote:
> > > I've not looked at the details yet, just back from vacation. But this
> > > seems wrong. I would of expected phylib to of returned -EPRODE_DEFER
> > > at some point, when asked for a PHY which does not exist yet. All the
> > > driver should need to do is make sure it returns the
> > > -EPRODE_DEFER.
> > 
> > This is what I expected as well, however there are a few complications:
> > 
> > - At the moment the first time the driver does anything with the PHY is
> >   in fec_enet_open(), not in fec_probe() - way too late to defer
> >   anything
> 
> O.K. Right. Are you using NFS root? For normal user space opening of
> the interface, this has all been sorted out by the time user space
> does anything. The NFS root changes the time in a big way.

NFS root is one of our usecases.

> 
> Anyway, i would say some bits of code need moving from open to probe
> so EPROBE_DEFER can be used.
> 
> We already have:
> 
>         phy_node = of_parse_phandle(np, "phy-handle", 0);
>         if (!phy_node && of_phy_is_fixed_link(np)) {
>                 ret = of_phy_register_fixed_link(np);
>                 if (ret < 0) {
>                         dev_err(&pdev->dev,
>                                 "broken fixed-link specification\n");
>                         goto failed_phy;
>                 }
>                 phy_node = of_node_get(np);
>         }
>         fep->phy_node = phy_node;
> 
> Go one step further. If fep->phy_node is not NULL, we know there
> should be a PHY. So call of_phy_find_device(). If it returns NULL,
> then -EPROBE_DEFER. Otherwise store the phydev into fep, and use it in
> open.
> 
> You will need to move the call to fec_enet_mii_init(pdev) earlier, so
> the MDIO bus is available.

I would love to do this, but driver-api/driver-model/driver.rst
contains the following warning:

      -EPROBE_DEFER must not be returned if probe() has already created
      child devices, even if those child devices are removed again
      in a cleanup path. If -EPROBE_DEFER is returned after a child
      device has been registered, it may result in an infinite loop of
      .probe() calls to the same driver.

My understanding of this is that there is simply no way to return
-EPROBE_DEFER after fec_enet_mii_init(pdev).



> 
>     Andrew

