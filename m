Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C576C1F31
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbjCTSMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:12:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230378AbjCTSMR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:12:17 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8647A43467;
        Mon, 20 Mar 2023 11:06:20 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id t17-20020a05600c451100b003edc906aeeaso1873999wmo.1;
        Mon, 20 Mar 2023 11:06:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679335557;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qovCtxHIhDjR5z8X/goS0zamNvJumBaq8hkkid2b0Tk=;
        b=bj32SbhOYrf1MwTLc85rZOoVpreALwN32JNmelOm+FWPYvERh/ppvTQWhxgaVewQiy
         sLr2uQj9GhuuC8x9FuB7/0hP2Ej3U5Al6/Ul8rujw/c4cIfcKBWfpLu1fKkoLn0Az62z
         G6AX3JjdbbS/N6qaLGKU6UihZngo5Ch/TCZMy1S9AspInSNTltUyuSjgGq4ExKLpfMkl
         wkBtK1RZDlXKFaGAEd2vpwzrwuYxPOnI48DZer/u3RQkol9rAZXh5VWWI5Wl86Mp7jAP
         BgOQwP328giT0GOgtPJnTB/B0DxDDCN7Lf3BJwQ+Rd8O0IxnhRGLexh2Y1xZFfZ1/vmb
         HmQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335557;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qovCtxHIhDjR5z8X/goS0zamNvJumBaq8hkkid2b0Tk=;
        b=Ej/XfRpr8uMvdYizFOBpY4qclUsbu7mObS12gj0CB9quVPg4LgD8PV6n7lVcl4XVxK
         eGoymbfEpNPQ8G4FPKyBQEhbuiK0fzY04V3rOu6gT5hBeQTwaN7QqIfpzl6RnJ24U721
         1bKNpIv+44G0NZoHWHRAGWoSIMyMyhtbSQ63FFxA7KYcUrh4d8V/x8FZP7BMQs2kvE/8
         j5pL1kxH8MP9iNwwpl5qS6otBCDwwYViBDASNhYAFBIIlvH3M+JI4F+S1AXJRfNvtQZO
         uYzQv/Bk6G/TeT0Caxa3t+p53kadcQh1cY7lu1tRz8SFg9Jl1BHXm1AE+T0UsyDnbGjf
         3EkQ==
X-Gm-Message-State: AO0yUKWcFal4Ah8Mpnt8LEkCCI127lHq9+JG1qn0RKyKiETICo7OzUCV
        VjZ5c8tcf0LNncCRGQlNfiM=
X-Google-Smtp-Source: AK7set9M7n47ivxwTUlCC32MV4CdFuRaSwXTCh6g3payQgyQeP9Rq3Azb7+JBgZfR4gy7ifkMULB0g==
X-Received: by 2002:a7b:c454:0:b0:3ed:e447:1ed0 with SMTP id l20-20020a7bc454000000b003ede4471ed0mr374765wmi.14.1679335557239;
        Mon, 20 Mar 2023 11:05:57 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id q8-20020a1cf308000000b003ed4f6c6234sm11139577wmq.23.2023.03.20.11.05.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 11:05:56 -0700 (PDT)
Message-ID: <6418a084.1c0a0220.de9c1.53e4@mx.google.com>
X-Google-Original-Message-ID: <ZBiggnNsWspWJ/Fh@Ansuel-xps.>
Date:   Mon, 20 Mar 2023 19:05:54 +0100
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Michal Kubiak <michal.kubiak@intel.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Lee Jones <lee@kernel.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v5 02/15] net: dsa: qca8k: add LEDs basic support
References: <20230319191814.22067-1-ansuelsmth@gmail.com>
 <20230319191814.22067-3-ansuelsmth@gmail.com>
 <ZBiKDX/WJPfJey/+@localhost.localdomain>
 <64188af6.050a0220.c5fe1.1d96@mx.google.com>
 <ZBicg28JwVLugzqz@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBicg28JwVLugzqz@localhost.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 06:48:51PM +0100, Michal Kubiak wrote:
> On Mon, Mar 20, 2023 at 05:33:56PM +0100, Christian Marangi wrote:
> > 
> > Btw ok for the description of the LED mapping? It's a bit complex so
> > tried to do my best to describe them.
> > 
> 
> Yes, now it is much easier to understand the logic behind LED mapping.
> Thanks for adding that! I think it will save some time for anyone who
> will be working with that code in the future.
> 
> The only thing I still do not understand is the initial 14 bit shift:
> 
> >	if (led->port_num == 0 || led->port_num == 4) {
> >		mask = QCA8K_LED_PATTERN_EN_MASK;
> >		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
> 
> For example, according to the code above, for port 4:
> 	- the value is shifted by 14 bits - to bits (15,14)
> 	- mask is also set to bits (15,14)
> 	- then, both mask and value are shifted again by 16 bits:
> 
> >		return regmap_update_bits(priv->regmap, reg_info.reg,
> >					  mask << reg_info.shift,
> >					  val << reg_info.shift);
> 
> because reg_info.shift == QCA8K_LED_PHY4_CONTROL_RULE_SHIFT == 16 for
> port_num == 4.
> 
> It means, in fact, for controlling port 4 we use bits (31,30) which
> seems to be inconsistent with your comment below.
> 
> >	 * To control port 4:
> >	 * - the 2 bit (17, 16) of:
> >	 *   - QCA8K_LED_CTRL0_REG for led1
> >	 *   - QCA8K_LED_CTRL1_REG for led2
> >	 *   - QCA8K_LED_CTRL2_REG for led3
> >	 *
> 
> Are values for ports 0 and 4 correct in your description in
> "qca8k_led_brightness_set()"?
> 

Code is correct, comment is not.

QCA8K_LED_CTRL0_REG is split in 2 part.
- first 16 bit for phy0
- second part (31, 16) for phy4

In these 16 half there are the bit that control the hw control blink
rules AND on the last 2 part of the half, the bit that control the state
of the LED (off, on, always-blink, hw control)

So I just didn't add on top of that MASK the required shift for
QCA8K_LED_PATTERN_EN_SHIFT.

so for phy0

GENMASK(1, 0) << QCA8K_LED_PATTERN_EN_SHIFT << QCA8K_LED_PHY0123_CONTROL_RULE_SHIFT
GENMASK(1, 0) << 14 << 0 

for phy4

GENMASK(1, 0) << QCA8K_LED_PATTERN_EN_SHIFT << QCA8K_LED_PHY4_CONTROL_RULE_SHIFT
GENMASK(1, 0) << 14 << 16

Thanks for the other review tag, will fix the last bit in v6.

-- 
	Ansuel
