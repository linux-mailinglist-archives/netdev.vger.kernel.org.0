Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7982D4B8141
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 08:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbiBPHRM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 02:17:12 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:32948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbiBPHRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 02:17:09 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C364C12FF
        for <netdev@vger.kernel.org>; Tue, 15 Feb 2022 23:16:57 -0800 (PST)
Received: from ptx.hi.pengutronix.de ([2001:67c:670:100:1d::c0])
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKEYJ-0007Pg-NX; Wed, 16 Feb 2022 08:16:39 +0100
Received: from ore by ptx.hi.pengutronix.de with local (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1nKEYE-0000vr-0Z; Wed, 16 Feb 2022 08:16:34 +0100
Date:   Wed, 16 Feb 2022 08:16:33 +0100
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Nicolas Saenz Julienne <nsaenz@kernel.org>,
        Ray Jui <rjui@broadcom.com>, Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Scott Branden <sbranden@broadcom.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Tony Lindgren <tony@atomide.com>, kernel@pengutronix.de,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-rpi-kernel@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH v3 4/8] ARM: dts: bcm283x: fix ethernet node name
Message-ID: <20220216071633.GB19299@pengutronix.de>
References: <20220215080937.2263111-1-o.rempel@pengutronix.de>
 <20220215080937.2263111-4-o.rempel@pengutronix.de>
 <f5ea3375-0306-e37f-5847-e1472164d7b7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <f5ea3375-0306-e37f-5847-e1472164d7b7@gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 08:10:05 up 67 days, 15:55, 56 users,  load average: 0.27, 0.23,
 0.18
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c0
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 01:01:06PM -0800, Florian Fainelli wrote:
> On 2/15/22 12:09 AM, Oleksij Rempel wrote:
> > It should be "ethernet@x" instead of "usbether@x"
> > 
> > Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> 
> This looks like, a quick grep on the u-boot source code seems to suggest
> that only one file is assuming that 'usbether@1' is to be used as a node
> name and the error message does not even match the code it is patching:
> 
> board/liebherr/xea/xea.c:
>   #ifdef CONFIG_OF_BOARD_SETUP
>   static int fdt_fixup_l2switch(void *blob)
>   {
>           u8 ethaddr[6];
>           int ret;
> 
>           if (eth_env_get_enetaddr("ethaddr", ethaddr)) {
>                   ret = fdt_find_and_setprop(blob,
> 
> "/ahb@80080000/switch@800f0000",
>                                              "local-mac-address",
> ethaddr, 6, 1);
>                   if (ret < 0)
>                           printf("%s: can't find usbether@1 node: %d\n",
>                                  __func__, ret);
>           }

\o/ :)

>           return 0;
>   }
> 
> I will wait for the other maintainers on the other patches to provide
> some feedback, but if all is well, will apply this one soon.

Full path fdt matching has proven to be not stable enough. Especially on
chips with early DT adaptation like iMX. It is better to use aliases
where possible. 

Regards,
Oleksij
-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
