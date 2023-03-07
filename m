Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020B06AFA2F
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 00:21:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbjCGXVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 18:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbjCGXVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 18:21:18 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7409C9E318;
        Tue,  7 Mar 2023 15:21:16 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id k37so8840174wms.0;
        Tue, 07 Mar 2023 15:21:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678231275;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HYZwdboZtaofkxYF/AMrNWZjuYShpz74P+9J9F7wGPo=;
        b=IE/EuwubCFwIUiQ1UCE4AQ9bBvgVDhBE1KKV+0aeH1NMR7eb8xDrgfzzfrLqnqrovt
         6B2Xb3Rupbpw3LTDODH/hN4Gf5oLSExy3UW2IH9b+TpOLAXDQOVNPr56NTAYDLJG6shc
         /1YfSYvhTWyRfWP7+zOsBKaKUj0sb81i/u9vOcZg85orYZ5BI695HdwWBD5mAnNGlrpg
         3kGkmUWH0E/niYYU567fwBzCIcMRDgYC4qLiPFsZiFX6NHRkFXUGZbg37ZHj7PKfOT8T
         CkFynM2V4fBgrPArtyb5FKB+6tYGfPhq9ajWABkQifjxVfC88+oXpo3fC59Nvqt+4IFQ
         5Jaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678231275;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HYZwdboZtaofkxYF/AMrNWZjuYShpz74P+9J9F7wGPo=;
        b=IDgesasvRTc3D590Uz2m/BiLx9M9zvyElQiDjtJ/SU/fTmG9Xy0YQuwrZP0CMRWKW+
         DSGwk5rpF3mr/u6hmiXctfNCDJIbx9LyXKiClfY0meveyglujJsHVj5SHsl404HhiZk6
         s1wd/X1VOY9c3M8Jz/T6ns8VJrb296Edx5hr3n54Lwj1n6oqfdQEXBWQNfhNmOtpb8xA
         piQA/ssWz+4VqLx2kg0e+/DlhXoXao+hcGyZgdLQxUFRBpjupwD2pfF7QaAfDW2zsWM9
         gYeiKRpY/fj4Ves4MZdWbswHWSfB1p3217Do0AlLxxWE54s0W1juYqxtlFaMrYA9RWjO
         Lk1w==
X-Gm-Message-State: AO0yUKX/weu+XIE5xJsukAGUzFzlc7FF/FmyBlxGAK42ymccpzLi7E4d
        29eQanD0lKn89Hx5qyjZONg=
X-Google-Smtp-Source: AK7set8d6nc3OMllfFEEVMQ2FWoY8wuoG+KGTEyes4OWEZZRiJ4RDuQzLH5PGcqH5tUcjI/Eb3a8yg==
X-Received: by 2002:a05:600c:348d:b0:3eb:9822:2907 with SMTP id a13-20020a05600c348d00b003eb98222907mr10953463wmq.4.1678231274745;
        Tue, 07 Mar 2023 15:21:14 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id m1-20020a05600c4f4100b003e01493b136sm19403673wmq.43.2023.03.07.15.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Mar 2023 15:21:14 -0800 (PST)
Message-ID: <6407c6ea.050a0220.7c931.824f@mx.google.com>
X-Google-Original-Message-ID: <ZAd69hshZrKvapYQ@Ansuel-xps.>
Date:   Tue, 7 Mar 2023 18:57:10 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH 01/11] net: dsa: qca8k: add LEDs basic support
References: <20230307170046.28917-1-ansuelsmth@gmail.com>
 <20230307170046.28917-2-ansuelsmth@gmail.com>
 <b03334df-4389-44b5-ac85-8b0878c64512@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b03334df-4389-44b5-ac85-8b0878c64512@lunn.ch>
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_03_06,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 08, 2023 at 12:16:13AM +0100, Andrew Lunn wrote:
> > +qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> > +{
> > +	struct fwnode_handle *ports, *port;
> > +	int port_num;
> > +	int ret;
> > +
> > +	ports = device_get_named_child_node(priv->dev, "ports");
> > +	if (!ports) {
> > +		dev_info(priv->dev, "No ports node specified in device tree!\n");
> > +		return 0;
> > +	}
> > +
> > +	fwnode_for_each_child_node(ports, port) {
> > +		struct fwnode_handle *phy_node, *reg_port_node = port;
> > +
> > +		phy_node = fwnode_find_reference(port, "phy-handle", 0);
> > +		if (!IS_ERR(phy_node))
> > +			reg_port_node = phy_node;
> 
> I don't understand this bit. Why are you looking at the phy-handle?
> 
> > +
> > +		if (fwnode_property_read_u32(reg_port_node, "reg", &port_num))
> > +			continue;
> 
> I would of expect port, not reg_port_node. I'm missing something
> here....
> 

It's really not to implement ugly things like "reg - 1"

On qca8k the port index goes from 0 to 6.
0 is cpu port 1
1 is port0 at mdio reg 0
2 is port1 at mdio reg 1
...
6 is cpu port 2

Each port have a phy-handle that refer to a phy node with the correct
reg and that reflect the correct port index.

Tell me if this looks wrong, for qca8k we have qca8k_port_to_phy() and
at times we introduced the mdio thing to describe the port - 1 directly
in DT. If needed I can drop the additional fwnode and use this function
but I would love to use what is defined in DT thatn a simple - 1.

-- 
	Ansuel
