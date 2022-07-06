Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10DCA5684FD
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbiGFKPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:15:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbiGFKPF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:15:05 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1597D1039
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:15:04 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id q6so26180357eji.13
        for <netdev@vger.kernel.org>; Wed, 06 Jul 2022 03:15:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ttAMqKQtwb0RJXuBF4mjmqPkEKb/1wAB4g1J0PFBHdE=;
        b=O4xgai6gFhxAa9+lwOBaiqJIvOexNu7AhPZHVLohAl9oxA77gGOMRGIMH/vyFh4n6O
         nyxV4x/HIWb2Od9p+lj0kOdY9jRzmn3P0RFE+OtaNoHXzv8VBNZlDEb0ubH1dR5xEIlt
         RjSmL6aa6JJ9BqWM1vz3vCreafedlaWyC86EGvX3704+9cnlwcZ/NDYQjtdQcMA5lINX
         BMlETp59/NBqm9Ggjkct8297QY+YF8GubozqV0dkQMyqqHuLsWBBVQo7MvUkiJw6cDwD
         mqui+QD/50zOfRozxO+Tbj7AD529bXy9fSxSvuWgESSQElCAVlOB5FipBik8gTTF5VH8
         jZew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ttAMqKQtwb0RJXuBF4mjmqPkEKb/1wAB4g1J0PFBHdE=;
        b=3QsX1qdp6aeHDTE7WgleOQZ3SSbMwcYgDHKEcMDf0Owo7QQ8VtIHym8bmuCVFkWdfu
         UvyvccVnr3xjzQ1jh/mXseGTLXlzcqrPsz54kOvTHoVXlqtptSmSp0cvbiD3z6thKEO7
         9i5B9zX/+6lWL/G6M8qiB1epl5VoG+mA4yk7jNFCzazH3DEBhdOLtFj1hNlCCavKQkry
         LkGW5ZX+OooBLQ/Yme42jOrpx+vHwX/avxIH+xeiuxawOj4JxXX90OknIdnGkrJw3PT+
         ve0T9S6/clldZmpopnuJrCOYqtyifqRKD8APtlE0f8AKGMz6Q7dTC6aSreuzr1hXzPqk
         OQig==
X-Gm-Message-State: AJIora8h9Dh2Z99fnMiB9F5Pl5C5TVbb9azNKJ5qU1epIRUQ6HYa36zP
        sRCN4BHmwC07GeujvNDLSVYNlWpniUxJhpMK
X-Google-Smtp-Source: AGRyM1tV24IGSPnWZkz4l8br66GbwMLZzFHM41FesXj5nSyq4WrZI5oSUTvRM1Z5B7okJ103QSp9PQ==
X-Received: by 2002:a17:906:38e:b0:722:e8f1:df6c with SMTP id b14-20020a170906038e00b00722e8f1df6cmr39123435eja.500.1657102502581;
        Wed, 06 Jul 2022 03:15:02 -0700 (PDT)
Received: from skbuf ([188.26.185.61])
        by smtp.gmail.com with ESMTPSA id ek5-20020a056402370500b0043a253973aasm7723615edb.10.2022.07.06.03.15.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jul 2022 03:15:01 -0700 (PDT)
Date:   Wed, 6 Jul 2022 13:14:59 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "Russell King (Oracle)" <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alvin =?utf-8?Q?=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        DENG Qingfang <dqfext@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        George McCollister <george.mccollister@gmail.com>,
        Hauke Mehrtens <hauke@hauke-m.de>,
        Jakub Kicinski <kuba@kernel.org>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        Sean Wang <sean.wang@mediatek.com>,
        UNGLinuxDriver@microchip.com,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Woojung Huh <woojung.huh@microchip.com>
Subject: Re: [PATCH RFC net-next v2 0/5] net: dsa: always use phylink
Message-ID: <20220706101459.tahby2xpm3e7okjz@skbuf>
References: <YsQIjC7UpcGWJovx@shell.armlinux.org.uk>
 <7fe6b661-06b9-96dd-e064-1db23a9eaae7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7fe6b661-06b9-96dd-e064-1db23a9eaae7@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Florian,

On Tue, Jul 05, 2022 at 09:42:33AM -0700, Florian Fainelli wrote:
> On 7/5/22 02:46, Russell King (Oracle) wrote:
> > A new revision of the series which incorporates changes that Marek
> > suggested. Specifically, the changes are:
> > 
> > 1. Patch 2 - use the phylink_get_caps method in mv88e6xxx to get the
> >     default interface rather than re-using port_max_speed_mode()
> > 
> > 2. Patch 4 - if no default interface is provided, use the supported
> >     interface mask to search for the first interface that gives the
> >     fastest speed.
> > 
> > 3. Patch 5 - now also removes the port_max_speed_mode() method
> 
> This was tested with bcm_sf2.c and b53_srab.b and did not cause regressions,
> however we do have a 'fixed-link' property for the CPU port (always have had
> one), so there was no regression expected.

What about arch/arm/boot/dts/bcm47189-tenda-ac9.dts?
Just to make sure I'm simply not seeing something, I compiled and then
decompiled the dtb. We have:

		ethernet@5000 {
			reg = <0x5000 0x1000>;
			phandle = <0x03>;

			mdio {
				#address-cells = <0x01>;
				#size-cells = <0x00>;

				switch@1e {
					compatible = "brcm,bcm53125";
					reg = <0x1e>;
					status = "okay";

					ports {
						#address-cells = <0x01>;
						#size-cells = <0x00>;

						port@0 {
							reg = <0x00>;
							label = "wan";
						};

						port@1 {
							reg = <0x01>;
							label = "lan1";
						};

						port@2 {
							reg = <0x02>;
							label = "lan2";
						};

						port@3 {
							reg = <0x03>;
							label = "lan3";
						};

						port@4 {
							reg = <0x04>;
							label = "lan4";
						};

						port@5 {
							reg = <0x05>;
							label = "cpu";
							ethernet = <0x03>; <- CPU port with no phy-handle, no fixed-link
						};
					};
				};
			};
		};
