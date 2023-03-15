Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9679A6BA3FE
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 01:23:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbjCOAWr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 20:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229540AbjCOAWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 20:22:45 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17F446148;
        Tue, 14 Mar 2023 17:22:43 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id r11so17483472edd.5;
        Tue, 14 Mar 2023 17:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678839762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=L6eritjJV4LmiZbdr9lP3yT7o1szXMCHsn5LCiyfRYA=;
        b=MlYQbfvWe5d9Ry+P+Vx41YBQ1gL4OtfOQt8b4E0T1AHEtZSohp+M0zt3W6JgqeXI1k
         5Ua7MqtpxoZcOf9mdxWmVqygm20lTj+rqEKPQ+Ghq8fUDsQDltZlFgBnyg5ZJ/u55q/8
         CNekHNxQ6Wr87imnsoRBo0TiE/5BD+NCU8HuP2znUCSod+EWWgDpM4QmmoRyXjfSDeln
         mkYv3yAXq3Rz6wKFueC82MBqn0CGREbh5qD9nPJl8i5h+5ABl8a/MRubv84EtfzyCSqh
         Qgq0fd7yU+hNdgTi+s7ntYP8rAuiMqTQeQyuCPw3iAaB0+BHL1aOihVFlkzZATDGCpMO
         gYKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678839762;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L6eritjJV4LmiZbdr9lP3yT7o1szXMCHsn5LCiyfRYA=;
        b=VmOeAUOXbuKAS5pLYys41jqvfEJiwiTV/g2XdOXHBom+etz8h5V8kL01OvR4V+P9pJ
         JGGWO18pLFDhlXWfnnb1Ybj6jYl6AtvXmmICLBJC0MWfGC/ExgWdGj0Nlbtd10X5HRtt
         P1QA+ULh4efsMlb5bq/IT3ZRY3UmXYsz9BnCpoOmqN4VEwzYh+X+jGtDYi20n7Aye7wl
         N4dfY+1A+EYn0lYFIr5XVlRIf2V+oso2u628Ajt4Ct3PZlfd1+lvMDfo/6rswwO4yOPN
         luFfeG7U2u+WTM5kbHCGWGurz/bhH3zALdfTuB4IUyvTbFA5tuxDR1Exxmv5mZCiH+MN
         stFw==
X-Gm-Message-State: AO0yUKWwy85CFG0p+4/F8Iz+fsKtjtH4MOXpzp/KzhfZ7CGP8mJwIN7c
        f0Zeics4npBy2CrMztmQc8Y=
X-Google-Smtp-Source: AK7set/0jp0llLgxtutMBA0b7r+ILPHtzlYr7jAT9FHTqx5rUM1ZuuQ0b8I5XKt4RCtv+JUlnJp6KQ==
X-Received: by 2002:a17:906:58c6:b0:922:de2c:fdaa with SMTP id e6-20020a17090658c600b00922de2cfdaamr5934299ejs.50.1678839762231;
        Tue, 14 Mar 2023 17:22:42 -0700 (PDT)
Received: from skbuf ([188.27.184.189])
        by smtp.gmail.com with ESMTPSA id ko22-20020a170907987600b008d325e167f3sm1746110ejc.201.2023.03.14.17.22.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 17:22:41 -0700 (PDT)
Date:   Wed, 15 Mar 2023 02:22:39 +0200
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
Subject: Re: [net-next PATCH v3 02/14] net: dsa: qca8k: add LEDs basic support
Message-ID: <20230315002239.ticvivruobuwcvwz@skbuf>
References: <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-1-ansuelsmth@gmail.com>
 <20230314101516.20427-3-ansuelsmth@gmail.com>
 <20230314101516.20427-3-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230314101516.20427-3-ansuelsmth@gmail.com>
 <20230314101516.20427-3-ansuelsmth@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 14, 2023 at 11:15:04AM +0100, Christian Marangi wrote:
> Add LEDs basic support for qca8k Switch Family by adding basic
> brightness_set() support.
> 
> Since these LEDs refelect port status, the default label is set to
> ":port". DT binding should describe the color, function and number of
> the leds using standard LEDs api.
> 
> These LEDs supports only blocking variant of the brightness_set()
> function since they can sleep during access of the switch leds to set
> the brightness.
> 
> While at it add to the qca8k header file each mode defined by the Switch
> Documentation for future use.
> 
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca/Kconfig      |   7 ++
>  drivers/net/dsa/qca/Makefile     |   1 +
>  drivers/net/dsa/qca/qca8k-8xxx.c |   4 +
>  drivers/net/dsa/qca/qca8k-leds.c | 191 +++++++++++++++++++++++++++++++
>  drivers/net/dsa/qca/qca8k.h      |  69 +++++++++++
>  5 files changed, 272 insertions(+)
>  create mode 100644 drivers/net/dsa/qca/qca8k-leds.c
> 
> diff --git a/drivers/net/dsa/qca/Kconfig b/drivers/net/dsa/qca/Kconfig
> index ba339747362c..9ed9d9cf80eb 100644
> --- a/drivers/net/dsa/qca/Kconfig
> +++ b/drivers/net/dsa/qca/Kconfig
> @@ -15,3 +15,10 @@ config NET_DSA_QCA8K
>  	help
>  	  This enables support for the Qualcomm Atheros QCA8K Ethernet
>  	  switch chips.
> +
> +config NET_DSA_QCA8K_LEDS_SUPPORT
> +	bool "Qualcomm Atheros QCA8K Ethernet switch family LEDs support"
> +	depends on NET_DSA_QCA8K
> +	help
> +	  This enabled support for LEDs present on the Qualcomm Atheros
> +	  QCA8K Ethernet switch chips.
> diff --git a/drivers/net/dsa/qca/Makefile b/drivers/net/dsa/qca/Makefile
> index 701f1d199e93..330ae389e489 100644
> --- a/drivers/net/dsa/qca/Makefile
> +++ b/drivers/net/dsa/qca/Makefile
> @@ -2,3 +2,4 @@
>  obj-$(CONFIG_NET_DSA_AR9331)	+= ar9331.o
>  obj-$(CONFIG_NET_DSA_QCA8K)	+= qca8k.o
>  qca8k-y 			+= qca8k-common.o qca8k-8xxx.o
> +obj-$(CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT) += qca8k-leds.o

Isn't this what you want instead?

ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
qca8k-y 			+= qca8k-leds.o
endif

you don't want to have to export the qca8k_setup_led_ctrl() symbol...
you want it to be part of the same module AFAIU.

> +/* Leds Support function */
> +#ifdef CONFIG_NET_DSA_QCA8K_LEDS_SUPPORT
> +int qca8k_setup_led_ctrl(struct qca8k_priv *priv);
> +#else
> +static inline int qca8k_setup_led_ctrl(struct qca8k_priv *priv)
> +{
> +	return 0;
> +}
> +#endif

Could there be just a qca8k-leds.h with the function prototypes exported
by qca8k-leds.c?
