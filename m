Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 168226BFEDA
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 02:29:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbjCSB3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Mar 2023 21:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbjCSB3w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Mar 2023 21:29:52 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B6F25B96;
        Sat, 18 Mar 2023 18:29:51 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id o7so7439616wrg.5;
        Sat, 18 Mar 2023 18:29:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679189390;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=7lNKLSglj57JGHjYbKgUGYzeLKtJa3XagCtxeH4Gxm4=;
        b=g5O17/yYiF7MsLnYQxK8bZe0LAwOuHzL5sr6eFbXNwSyGweCfmV7ILJSe2i+6tpD2p
         zcXXRYps38ph7UNfwn2SUMseog4RyFZrAwDEHkZJBpbAigXbIZkFN0tAhgtSQz2cpchX
         +GKvf5rRiWpvhSfEzjlsS3k7Xp2FJexXDZ070kebeE8ejTm3P0Sd5x4xGfS9Bk/Jt59o
         drC+12zQtDlakn1NT6UysdZWoW/A/jHqwDsoZI86k8kFE86bUWxSP62zR7SiQW58dDlc
         q9tAFMso5QlvOOcR0V3LWddCRodHxt5KMGSbkofM3qH1o5HTyy1dFHu8q8R6skbtdvyZ
         2H4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679189390;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7lNKLSglj57JGHjYbKgUGYzeLKtJa3XagCtxeH4Gxm4=;
        b=o2UNssGxxbuI9mxzHT9bVqV/Hbq7DGAnACaaMBnjZb6XASBq3yUU1gE9hlkA/p/j0X
         3Isr4ntavDIJq4usBqd5zgH0swqrzJIEXc5WrNSHUj5B3mpgIWK4NzC/HdZbjHbIKzyh
         AMvYIWOcDPPZDlkUkT1MWCyG+z3/qygyLerQQ6OUuU6CYZHlYHk31c/4jaxjB/9p4RLH
         Wyf47FsJqw6s9cPlvYr4xfzabrxXqxycg6pbSq0izGi47X248hWJZtwHMsJX3WFhXJi2
         NfYbklhb/3U2yw/tpC5H+gMXLdWWjAIO+OSWc+U46YLgHHjBgAJFUOi3mr+beumqpIPL
         OCaQ==
X-Gm-Message-State: AO0yUKXzAF4nAlB6Cuxw+2Teuhwzv0rXFnKBi4Hzqm+TPyXolSmxbzym
        yvxMaldStnVFtM1l2O5RlU4=
X-Google-Smtp-Source: AK7set/9UCz7mWqjurM1eC1cM6R+T7hiebwpTUU846InJ+Uk33AlEslf61PrYT3Hy0tDT6LDr31DuA==
X-Received: by 2002:a5d:4ed0:0:b0:2d2:22eb:824a with SMTP id s16-20020a5d4ed0000000b002d222eb824amr6706787wrv.34.1679189389654;
        Sat, 18 Mar 2023 18:29:49 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id b18-20020adff912000000b002c567881dbcsm5440215wrr.48.2023.03.18.18.29.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Mar 2023 18:29:49 -0700 (PDT)
Message-ID: <6416658d.df0a0220.cb6f6.f5d2@mx.google.com>
X-Google-Original-Message-ID: <ZBYNjSxnypMfvtZE@Ansuel-xps.>
Date:   Sat, 18 Mar 2023 20:14:21 +0100
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
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v4 03/14] net: dsa: qca8k: add LEDs blink_set()
 support
References: <20230317023125.486-1-ansuelsmth@gmail.com>
 <20230317023125.486-4-ansuelsmth@gmail.com>
 <ZBRU4Xx3kCwbD3Eg@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBRU4Xx3kCwbD3Eg@localhost.localdomain>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 17, 2023 at 12:54:09PM +0100, Michal Kubiak wrote:
> On Fri, Mar 17, 2023 at 03:31:14AM +0100, Christian Marangi wrote:
> > Add LEDs blink_set() support to qca8k Switch Family.
> > These LEDs support hw accellerated blinking at a fixed rate
> > of 4Hz.
> > 
> > Reject any other value since not supported by the LEDs switch.
> > 
> > Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> > Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> > ---
> >  drivers/net/dsa/qca/qca8k-leds.c | 38 ++++++++++++++++++++++++++++++++
> >  1 file changed, 38 insertions(+)
> > 
> > diff --git a/drivers/net/dsa/qca/qca8k-leds.c b/drivers/net/dsa/qca/qca8k-leds.c
> > index adbe7f6e2994..c229575c7e8c 100644
> > --- a/drivers/net/dsa/qca/qca8k-leds.c
> > +++ b/drivers/net/dsa/qca/qca8k-leds.c
> > @@ -92,6 +92,43 @@ qca8k_led_brightness_get(struct qca8k_led *led)
> >  	return val == QCA8K_LED_ALWAYS_ON;
> >  }
> >  
> > +static int
> > +qca8k_cled_blink_set(struct led_classdev *ldev,
> > +		     unsigned long *delay_on,
> > +		     unsigned long *delay_off)
> > +{
> > +	struct qca8k_led *led = container_of(ldev, struct qca8k_led, cdev);
> > +	u32 mask, val = QCA8K_LED_ALWAYS_BLINK_4HZ;
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +
> > +	if (*delay_on == 0 && *delay_off == 0) {
> > +		*delay_on = 125;
> > +		*delay_off = 125;
> > +	}
> > +
> > +	if (*delay_on != 125 || *delay_off != 125) {
> > +		/* The hardware only supports blinking at 4Hz. Fall back
> > +		 * to software implementation in other cases.
> > +		 */
> > +		return -EINVAL;
> > +	}
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	if (led->port_num == 0 || led->port_num == 4) {
> > +		mask = QCA8K_LED_PATTERN_EN_MASK;
> > +		val <<= QCA8K_LED_PATTERN_EN_SHIFT;
> > +	} else {
> > +		mask = QCA8K_LED_PHY123_PATTERN_EN_MASK;
> > +	}
> 
> Could you add a comment as to why the HW requires different approaches for
> inner and outer ports?
>

Since they are really the same thing, I added a big comment that explain
how the thing mask shift and reg works and why in the brightness_set
function.

> > +
> > +	regmap_update_bits(priv->regmap, reg_info.reg, mask << reg_info.shift,
> > +			   val << reg_info.shift);
> > +
> > +	return 0;
> > +}
> > +
> >  static int
> >  qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int port_num)
> >  {
> > @@ -149,6 +186,7 @@ qca8k_parse_port_leds(struct qca8k_priv *priv, struct fwnode_handle *port, int p
> >  
> >  		port_led->cdev.max_brightness = 1;
> >  		port_led->cdev.brightness_set_blocking = qca8k_cled_brightness_set_blocking;
> > +		port_led->cdev.blink_set = qca8k_cled_blink_set;
> >  		init_data.default_label = ":port";
> >  		init_data.devicename = "qca8k";
> >  		init_data.fwnode = led;
> > -- 
> > 2.39.2
> > 
> 
> 
> Thanks,
> Michal

-- 
	Ansuel
