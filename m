Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC073A91CD
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 08:20:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231346AbhFPGWg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 02:22:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:36499 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230370AbhFPGWf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Jun 2021 02:22:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1623824430; x=1655360430;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=bkOozMexJwsJX12lhLsyLTka4UIj6XIfmvBgGcoA4G0=;
  b=SyWmyPDHkl1VuVqqv6sKYlNTk18zCeAoHs61rcc2BOriMfcsURHKTJNU
   a+5shCqLfx0VwheUjvzO5OEOVGKdQjsFuyMDA5DSq0w0LNss13kHVFR/M
   N5vyV2yK2sXT3z7hqrYWKqUT/McROBoKdUiMNIMKozX9i/4+yLxnAkZqr
   k8pNn1WRFJesEGZwJM+gAxDb5NlBjQMYaH8XfCkgzifG35OE1txfBqrZm
   oaDRpiZxhXzlMWbSnrVqG0N4sJGAxikOj3tom0AQwbLVGjINEKS+ZlH8F
   83M6ncu7SmEpJo9mzX7Ze9p3jzVO2/GOWVzjOlihUgytmNV093vSgf7eK
   Q==;
IronPort-SDR: 3AaM3vcf/OLT7vd2fBPALrBHvTvCPeLOIAMXvNRt2MWGp8Gk9KY1uo9wpI07yqytdzW+ZKnRCh
 hVW/QqXSH4k23Op/dbpFOiNTyGm30OaRizJeSq+NZoV3WsZAO7KuKL1IS6Yv8coJxbYUIZYw84
 YTNI6wxx7p5CchkPmEdD4nsZWk/fcV0PqB6NQMJGlkvNowUqrpitU0HB+R9L3/lEa2LuiqoFQf
 8A28LZOUG1KahNna09J08iA6DavE0f2nHjM+NvVzJXvGebj0PhDpg5LQ7QoHSKg4yv1WDatf28
 2+Q=
X-IronPort-AV: E=Sophos;i="5.83,277,1616482800"; 
   d="scan'208";a="125472459"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Jun 2021 23:20:29 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 15 Jun 2021 23:20:29 -0700
Received: from den-her-m31857h.microchip.com (10.10.115.15) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server id
 15.1.2176.2 via Frontend Transport; Tue, 15 Jun 2021 23:20:25 -0700
Message-ID: <cb6ae093f6db85dd62ac9cafc14362ce18987e6c.camel@microchip.com>
Subject: Re: [PATCH net-next v4 02/10] net: sparx5: add the basic sparx5
 driver
From:   Steen Hegelund <steen.hegelund@microchip.com>
To:     Philipp Zabel <p.zabel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "Alexandre Belloni" <alexandre.belloni@bootlin.com>,
        Madalin Bucur <madalin.bucur@oss.nxp.com>,
        Mark Einon <mark.einon@gmail.com>,
        "Masahiro Yamada" <masahiroy@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Simon Horman <simon.horman@netronome.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Lars Povlsen <lars.povlsen@microchip.com>
Date:   Wed, 16 Jun 2021 08:20:24 +0200
In-Reply-To: <2800a872ff4260fc7a942f2f2ea1c9e3603b13d7.camel@pengutronix.de>
References: <20210615085034.1262457-1-steen.hegelund@microchip.com>
         <20210615085034.1262457-3-steen.hegelund@microchip.com>
         <2800a872ff4260fc7a942f2f2ea1c9e3603b13d7.camel@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Philipp,

Thanks for your comments,

On Tue, 2021-06-15 at 15:22 +0200, Philipp Zabel wrote:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know the content is safe
> 
> Hi Steen,
> 
> On Tue, 2021-06-15 at 10:50 +0200, Steen Hegelund wrote:
> > This adds the Sparx5 basic SwitchDev driver framework with IO range
> > mapping, switch device detection and core clock configuration.
> > 
> > Support for ports, phylink, netdev, mactable etc. are in the following
> > patches.
> > 
> > Signed-off-by: Steen Hegelund <steen.hegelund@microchip.com>
> > Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>
> > Signed-off-by: Lars Povlsen <lars.povlsen@microchip.com>
> [...]
> > diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > new file mode 100644
> > index 000000000000..892bbbaacbd6
> > --- /dev/null
> > +++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
> > @@ -0,0 +1,743 @@
> [...]
> > +static int mchp_sparx5_probe(struct platform_device *pdev)
> > +{
> [...]
> > +     /* Do switch core reset if available */
> > +     reset = devm_reset_control_get_optional_shared(&pdev->dev, "switch");
> 
> Please don't ignore errors here. For example:
> 
>         if (IS_ERR(reset))
>                 return dev_err_probe(&pdev->dev, PTR_ERR(reset),
>                                      "Failed to get reset.\n");
> 
> >       reset_control_reset(reset);

Yes, I will add an error message.

> 
> regards
> Philipp


-- 
BR
Steen

-=-=-=-=-=-=-=-=-=-=-=-=-=-=
steen.hegelund@microchip.com


