Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F36C4143AC
	for <lists+netdev@lfdr.de>; Wed, 22 Sep 2021 10:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbhIVIYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 04:24:30 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:42170 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbhIVIY3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 04:24:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632298980; x=1663834980;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xjW/845tnWGlXhM5QyPda/qgpHmpay631ISWld/+EpU=;
  b=XP9iqA020aY470g8CV1uQUix7oTDsFCRyFbckNGxDP1WT53dsRhwI/pi
   fbcunYzyx23l5pJi/UhW/mJTqooMZ0iNmcjg+bCQXChFn+tyJ76C2DvTB
   yT1gtkq8+LXwmGWiXWjuX60M/Ia8SnOD17Q1UZi40/gB5m2E5rFGcuRyx
   CHxCquof1VgH2yDMOWkF781lXM6H2zaKM2/GIICE9dMWzQswWz0uUlBd7
   6wUqjW9/fopDba8Dnwo0ZHtkcZHmbZFXjXnYxBbVbT0ce32ThCiXg1igX
   EaIT1HPmObgusy3BNwgh37pdNOnKyAi/MQyBhKN7KvWS2eKL2/E2eZFAF
   w==;
IronPort-SDR: Io11DU1oxCoW9DJBhO9Z0Tpvl9wTYnln0Mf/81sY/iYrOHQnGAb5KM0qJ/dXkef68bAa+ShXJb
 gMwGJXFfqocdln2uBliOmoA9IhRUxCUF/6WQdCvea6NEG0+oKRGxap7tvtsvCaFv+RwhCbbPeg
 SuTRI6u1DTzynxEshLUjcaF91oH/1wdA/Z0Ld3i9AsAXSC6KZ3gbstMZ/2sZKFaWPK8cxZGrcK
 GLtZt0ZZOxUgOY9EGKqsEXD4cb+iIMaztN0cAFVVJ/FMUd1Fe9q3MZr/KPdTuE8jwf1bBx6IBH
 6TbVug5MtabHNU5QekKfZfPt
X-IronPort-AV: E=Sophos;i="5.85,313,1624345200"; 
   d="scan'208";a="132701188"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2021 01:22:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Wed, 22 Sep 2021 01:22:50 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Wed, 22 Sep 2021 01:22:49 -0700
Date:   Wed, 22 Sep 2021 10:24:18 +0200
From:   Horatiu Vultur <horatiu.vultur@microchip.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>,
        <alexandre.belloni@bootlin.com>, <vladimir.oltean@nxp.com>,
        <UNGLinuxDriver@microchip.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-phy@lists.infradead.org>, <linux-pm@vger.kernel.org>
Subject: Re: [RFC PATCH net-next 01/12] net: mdio: mscc-miim: Fix the mdio
 controller
Message-ID: <20210922082418.xagkhx2aw2yxfwg7@soft-dev3-1.localhost>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-2-horatiu.vultur@microchip.com>
 <YUh15ieAzBiCVeX9@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <YUh15ieAzBiCVeX9@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 09/20/2021 13:52, Andrew Lunn wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> On Mon, Sep 20, 2021 at 11:52:07AM +0200, Horatiu Vultur wrote:
> > According to the documentation the second resource is optional. But the
> > blamed commit ignores that and if the resource is not there it just
> > fails.
> >
> > This patch reverts that to still allow the second resource to be
> > optional because other SoC have the some MDIO controller and doesn't
> > need to second resource.
> >
> > Fixes: 672a1c394950 ("net: mdio: mscc-miim: Make use of the helper function devm_platform_ioremap_resource()")
> > Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Hi Andrew,
> 
> Hi Moratiu
> 
> The script kiddies might come long and 'fix' this again. Maybe
> consider adding devm_platform_ioremap_resource_optional(), following
> the pattern of other _optional() API calls. Otherwise add a comment.

Initially I think I will go with the comment. Because this patch
actually needs to go on net.

> 
>     Andrew

-- 
/Horatiu
