Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB1F96BEAA2
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 15:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbjCQODe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 10:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbjCQODc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 10:03:32 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B240B199F5;
        Fri, 17 Mar 2023 07:03:17 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id t15so4524409wrz.7;
        Fri, 17 Mar 2023 07:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679061796;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=woQ7p/4j+dQV7W5qSwH4t85I/oQFLj6/QY2SjRB5cNM=;
        b=AxtYotNPPWcqMRyYqJgOFK0siL7A02+6sg45DxspnTvvIlbsL/wSTtQfkF1yiKDRNT
         75L2lVXLSIVEuTBF2AopU5XNrOXNPyo4J778wFYo5j9nAxFxYCLynDstBIXuc2RgpxUD
         vGcue06i/6v4BysQnqt9Y+fueAih5NnJbCKVrVu901pWYJVTWH/6xV19WAYoclS99IIs
         Nf7n5Dok+n6xfHUwjO8pnFkD5hmM2tDFgj/bpjCRWv4qtmXqS7IZfA5pN0h+rjJhp2pu
         3UsbAeBt3OLbOOn0k2EdgwVseIqGz/7cWEPP64mjha0gGyAqSdE9KPIS6/eGJe1MITIq
         IVYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679061796;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=woQ7p/4j+dQV7W5qSwH4t85I/oQFLj6/QY2SjRB5cNM=;
        b=OVbvFWkhtlJ8TnEd/YVjge+aQpjydxuq3QhETFVaMzJArFPGyYskYRyCYm3MyGQ+nM
         Xjw25r8fbNAunigYeB3nx3grU1eo/ilYSeTauR0V4K/atpwtuqPTz3gNumj986i1aFnZ
         6Ibrd9DuNCjTrYlu7i1lkG3VLpQRi3tT26uU0/rqLRV4WN7ziOZg1z4wFabIl6PgQ/6W
         d4z7hbYHwxIZKaoVl+4/GyChS3hFan7u7Kl2jHu4MfWGbtSeOuXOckDiaXasUGFJ23pn
         q1bJnBh6mxF0G03PIqEs+rnfa9iAD+NH/Ll4n+o8DQ7p+bDzj12ogff4QKqcSWIZ6aym
         59RQ==
X-Gm-Message-State: AO0yUKWDLaJeYGpCsUW7BfigWJeJszP5syz51LfGkQ0wDnZ8kv032zSm
        IbAxPbk1LvQlxlE9WfAaYgg=
X-Google-Smtp-Source: AK7set8kqOMFiLuMAuGl1FLmfafbrSpiyxgdZ/tzXHkg0A5VEQEx5qi5dDb/E7Y2WsepFWS/CVk2Cg==
X-Received: by 2002:adf:de90:0:b0:2ce:aed4:7f22 with SMTP id w16-20020adfde90000000b002ceaed47f22mr7667054wrl.50.1679061795678;
        Fri, 17 Mar 2023 07:03:15 -0700 (PDT)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id c10-20020adffb0a000000b002c70c99db74sm2024167wrr.86.2023.03.17.07.03.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:03:15 -0700 (PDT)
Message-ID: <64147323.df0a0220.5d6df.c863@mx.google.com>
X-Google-Original-Message-ID: <ZBRzIJqxhUZQIRY2@Ansuel-xps.>
Date:   Fri, 17 Mar 2023 15:03:12 +0100
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
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

Will add some comments, but for reference, it's really just how the
switch regs setup these and provide access and configuration from them.

phy0 and phy4 are in a reg,
phy1-2-3 are in a separate table with different shift and mask.

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
