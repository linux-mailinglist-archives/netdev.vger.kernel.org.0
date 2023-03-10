Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E56AC6B32AF
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 01:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231424AbjCJATG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 19:19:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229876AbjCJATF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 19:19:05 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DD80ED690;
        Thu,  9 Mar 2023 16:19:03 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id j2so3546552wrh.9;
        Thu, 09 Mar 2023 16:19:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678407542;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c7dl0alc83k3Pp3Xko6c+R33xqt0UW862N4ynk36/DU=;
        b=GrrwBmz4rV3JXTc5sfXhimJtJsl5GW01u3aqSpSblxPNu7ki6TJAiOtM4nXo/efYhg
         7KEq3FcW1+7yoEZT+NlhqDV26TRUiPBnanF2Pfg1SgP7Sdrly2ASppWGXNtokJsSJBCB
         brjzGx9dxVn7wG/QSJTEsUm8XhPyhdFdWYza06JRHmBTfRm2t56gqSVW6u3uwKUPbudR
         8lEZP3sD4rq8+r+dbh1EHMn4WGhp8XwAYS+HubzxqlpZ1LtRBMORPPQMJWg9HwXhwrdC
         lacrbP+Iginx2qsnhqg6iggnDlyfebFzuYE2Q71HoZxSJ0Q9ujcyjh8AcYLkNBsVslJl
         GC/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678407542;
        h=in-reply-to:content-disposition:mime-version:references:subject:cc
         :to:from:date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c7dl0alc83k3Pp3Xko6c+R33xqt0UW862N4ynk36/DU=;
        b=wBGvDbpKQFANNAVAsIsDpYLOjNybOxpyeAlyWmo0RbiQvbt2mLA9RdJnEE5j8ho6ZT
         4wYnKl3VGzg5kxCDaF21x2U1ZyzC74gxUGhYedXIk3dYXopLY2xypOL99EJdFTZ4eJvT
         Lovr6G7g+Ng+6Z7E0QqaTSh8j9DPN0d9HkPFjbwT8Zbs0rwLVBfWbvubGnE33LMV0swv
         k94wvNK0XuGT2KXrCNjrW9bbYnSiZ1K8csZAsFGEPTj2/6GBuof1YQfAZCOzYClSgWOz
         ked5CRzrUsjsIUKhlRrNICrSp4ZmzrFu/qrvuwPc1KKu4qMOgyZwFsKjDMDB9CMQkdaw
         DSCg==
X-Gm-Message-State: AO0yUKUTjyhYYUOQUL3o7fOHCd3LGDpW920vRYiWVe9GO3TzEfT4s3Bz
        C87+jjrKckAEAlg6LdZMWFw=
X-Google-Smtp-Source: AK7set85ENtFtGvDeF+Y/oq3nXZWYElGoArcMrJ/c0/syf+xVDTOZCV+GRwVevQcpjXsxRravVokag==
X-Received: by 2002:adf:eec2:0:b0:2c5:8d06:75c2 with SMTP id a2-20020adfeec2000000b002c58d0675c2mr17947826wrp.35.1678407541846;
        Thu, 09 Mar 2023 16:19:01 -0800 (PST)
Received: from Ansuel-xps. (93-34-89-197.ip49.fastwebnet.it. [93.34.89.197])
        by smtp.gmail.com with ESMTPSA id x15-20020a5d490f000000b002c553e061fdsm596633wrq.112.2023.03.09.16.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 16:19:01 -0800 (PST)
Message-ID: <640a7775.5d0a0220.110eb.3e41@mx.google.com>
X-Google-Original-Message-ID: <ZAp3aL+DpvM6aPFQ@Ansuel-xps.>
Date:   Fri, 10 Mar 2023 01:18:48 +0100
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
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, Lee Jones <lee@kernel.org>,
        linux-leds@vger.kernel.org
Subject: Re: [net-next PATCH v2 02/14] net: dsa: qca8k: add LEDs basic support
References: <20230309223524.23364-1-ansuelsmth@gmail.com>
 <20230309223524.23364-3-ansuelsmth@gmail.com>
 <a8c60aa6-2a89-4b2e-b773-224c6a5b03c0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8c60aa6-2a89-4b2e-b773-224c6a5b03c0@lunn.ch>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 01:12:03AM +0100, Andrew Lunn wrote:
> > +config NET_DSA_QCA8K_LEDS_SUPPORT
> > +	tristate "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
> 
> Is tristate correct here? That means the code can either be built in,
> a module, or not built at all. Is that what you want?
> 
> It seems more normal to use a bool, not a tristate.
>

Think you are right, can't really be a module.

> > +static enum led_brightness
> > +qca8k_led_brightness_get(struct qca8k_led *led)
> > +{
> > +	struct qca8k_led_pattern_en reg_info;
> > +	struct qca8k_priv *priv = led->priv;
> > +	u32 val;
> > +	int ret;
> > +
> > +	qca8k_get_enable_led_reg(led->port_num, led->led_num, &reg_info);
> > +
> > +	ret = regmap_read(priv->regmap, reg_info.reg, &val);
> > +	if (ret)
> > +		return 0;
> > +
> > +	val >>= reg_info.shift;
> > +
> > +	if (led->port_num == 0 || led->port_num == 4) {
> > +		val &= QCA8K_LED_PATTERN_EN_MASK;
> > +		val >>= QCA8K_LED_PATTERN_EN_SHIFT;
> > +	} else {
> > +		val &= QCA8K_LED_PHY123_PATTERN_EN_MASK;
> > +	}
> > +
> > +	return val > 0 ? 1 : 0;
> > +}
> 
> What will this return when in the future you add hardware offload, and
> the LED is actually blinking because of frames being sent etc?
> 
> Is it better to not implement _get() when it is unclear what it should
> return when offload is in operation?
> 
>        Andrew

My idea was that anything that is not 'always off' will have brightness
1. So also in accelerated blink brightness should be 1.

My idea of get was that it should reflect if the led is active or always
off. Is it wrong?

-- 
	Ansuel
