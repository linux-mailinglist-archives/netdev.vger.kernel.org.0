Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41AE16BA434
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 01:45:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCOApA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 20:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229644AbjCOAo7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 20:44:59 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C27121117A;
        Tue, 14 Mar 2023 17:44:57 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id ek18so38113040edb.6;
        Tue, 14 Mar 2023 17:44:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678841096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=j78xQ/dlyO2w00ZN1x42fWcOhlv4pH4hNYDeYpQy2n8=;
        b=leeP0sVej5vmyF9D2t/OAvWprJsKpLWHi48jtA0CBilduZsy148k3ehRl0W0S/G1sR
         wYR1UYvjb4TZl4M5cGXbO5/hIq/q0rXmxjAb8l+A7nzyXTdD9a0g5y776coHgnL6jMIk
         GWlVbPpd1V+uTpAslb0Ydxx40mucbWxbm6b6S+E79ZajNZyNbAj8Z40oLptQnoL8EviZ
         NRbepbHvRknUgvYnCYh3LUHzaRzdiFjQE7uLSssDadZqLYJt1huoEHw+/KlGEsdc/asp
         hZDocnmwfmxGyXEKNFDPLUH3O72RWqxxNhDbaDaufj5fEuNzzRf6Q+OmRWC8W7nTmSrF
         Lq+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678841096;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j78xQ/dlyO2w00ZN1x42fWcOhlv4pH4hNYDeYpQy2n8=;
        b=zw//2tQejfclI6oSDnrL8I0O4sYTEHnGKza01P5HbhZsPHGdWN3w1qH5XtowKtARq1
         Ox/2EJlNzAifQtdi35eM51uSI+w3RSrFcKimCMaBrjVO8woklL5Sa0zkqn8azh2I1oHK
         T4vlYvsV9D5NHj/lU7jHpejqpFfXHq+7tGO7utEBL6ViJY+ewDapfoICnGYiWTL3sr1D
         gHk9o3BSIVEp8s6Ark6RWvM3JKbzPJAWo3GDAYrUZuyaoHGvdxumg2VNjP8ehkWo/MtK
         p+b14nvnqzR+TjXyLuIomLNKTS98nnIPDsYheL5y4QLGUG8RH1Y05BssAX36o9WAgeYX
         aI2g==
X-Gm-Message-State: AO0yUKU/ozWBXIZ52j6KdOrByLNnylQOm0F1XqYStGxCm1UXlXdXkHhB
        03SIfY6um+CnLZyXEgtk1jA=
X-Google-Smtp-Source: AK7set8pcWkJwyFz0NAnNAYiFWllDpt6MlFJbmaxFj6EunAKetqApp966inRNzHkXw26kbdMNkUhFQ==
X-Received: by 2002:a17:906:1714:b0:870:d9a:9ebb with SMTP id c20-20020a170906171400b008700d9a9ebbmr4595398eje.38.1678841096165;
        Tue, 14 Mar 2023 17:44:56 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id td10-20020a1709078c8a00b009256a5c3b2dsm1785112ejc.90.2023.03.14.17.44.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 17:44:55 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:44:53 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
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
Subject: Re: [net-next PATCH v3 06/14] net: phy: marvell: Add software
 control of the LEDs
Message-ID: <20230315004453.sxzqccyozvsfp374@skbuf>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-7-ansuelsmth@gmail.com>
 <20230314101516.20427-7-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314101516.20427-7-ansuelsmth@gmail.com>
 <20230314101516.20427-7-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:15:08AM +0100, Christian Marangi wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> Add a brightness function, so the LEDs can be controlled from
> software using the standard Linux LED infrastructure.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
> +static int m88e1318_led_brightness_set(struct phy_device *phydev,
> +				       u32 index, enum led_brightness value)
> +{
> +	u16 reg;
> +
> +	reg = phy_read_paged(phydev, MII_MARVELL_LED_PAGE,
> +			     MII_88E1318S_PHY_LED_FUNC);
> +	if (reg < 0)
> +		return reg;

"reg" is declared as unsigned, so it's surely positive.

> +
> +	switch (index) {
> +	case 0:
> +	case 1:
> +	case 2:
> +		reg &= ~(0xf << (4 * index));
> +		if (value == LED_OFF)
> +			reg |= MII_88E1318S_PHY_LED_FUNC_OFF << (4 * index);
> +		else
> +			reg |= MII_88E1318S_PHY_LED_FUNC_ON << (4 * index);
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return phy_write_paged(phydev, MII_MARVELL_LED_PAGE,
> +			       MII_88E1318S_PHY_LED_FUNC, reg);
> +}
