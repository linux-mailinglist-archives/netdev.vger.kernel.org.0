Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A78E5B3C2F
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 17:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232380AbiIIPkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 11:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiIIPjx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 11:39:53 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63390F20
        for <netdev@vger.kernel.org>; Fri,  9 Sep 2022 08:39:25 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id by6so2285880ljb.11
        for <netdev@vger.kernel.org>; Fri, 09 Sep 2022 08:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qFZsms0Dv3NVUxeThUQNo8sDEg3tK+2lEhh1M4gisys=;
        b=Rhr1KEKR4olPmjGIeJmMGyYsDXJcxp3jNLIhCSM7xHdBhNXB4mIXvShHqa33o/4qR8
         1Rn4/Geet2RBhVvQJnSHsfXXeWyEoTuzuCXI8Yd6x7QUCLLWTHGONsuPnpWjqOHYJejV
         cBTDsQGSTnTQaPx0pzA6XUJ8pwu7esj23I9qtAWeytzbmypDzbiEKAY0zG934AbnanB9
         j0S7fdpvWOgB8dgsciiSJT7/l4AB8dL66GRBNNqGxEiXU0ZogdSvrsuEYJ8BgslBRP/f
         q075CvrYoAdCx62Ougj89O4GIwz0xIHZJ98gBg4f+M989kD2EaKVyY3TdhpOkRTOueIR
         GglA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qFZsms0Dv3NVUxeThUQNo8sDEg3tK+2lEhh1M4gisys=;
        b=nSkbS/g+luIv0RcVeWNj3KlWgV47z0ADrhh/1vFx6YV3o369QzNIqZKaPLCH3XhR3T
         lffwdyFHVKUccbQd/pD9Wm2kRrVMeduVp7t+BbP7VRFTz9i4qLKU4vDPdrdqEGnerMwp
         MmfO4TU1yKJr0KSg6CruQmEfsZJLd1tOTHTfmQbuu0pc5aUtqnW1fEfl/zIZ/HcEP99y
         Fapmd0mzgPadXbHHKc2WlOBTxfL7jHKcLMShHNTxvF1/ANUTlOJBVxxhKSWJSVNT0ygt
         RVNjj374Zse5KX1dqwk9wJQcK5KRKJXQqdfUTwukgEfbUoQlL55Qd0JkX1RnJaP9IQcn
         kzZg==
X-Gm-Message-State: ACgBeo3vMcD/tDiEajqzZgRdWzRsgt/y+gKEXWoi0alnhjA8y3tMliO0
        pv4z0FkZsSJP7QxcsbwBky41Pw==
X-Google-Smtp-Source: AA6agR4dq1PWRdB6Tn+4D7OYv2QLunn/rmVg46gVFQ4jkUpLnkZo6JRcx9ECqIkBGuZ7RUMmNfcF+w==
X-Received: by 2002:a2e:96cc:0:b0:26b:d950:1f70 with SMTP id d12-20020a2e96cc000000b0026bd9501f70mr2881788ljj.232.1662737963861;
        Fri, 09 Sep 2022 08:39:23 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id s7-20020a056512214700b00497a6fe85b8sm116555lfr.250.2022.09.09.08.39.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Sep 2022 08:39:23 -0700 (PDT)
Message-ID: <c6d71abe-51d9-945e-bf70-c84b7c5e71bf@linaro.org>
Date:   Fri, 9 Sep 2022 17:39:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH net-next v4 1/5] net: ipqess: introduce the Qualcomm
 IPQESS driver
Content-Language: en-US
To:     Maxime Chevallier <maxime.chevallier@bootlin.com>,
        davem@davemloft.net, Rob Herring <robh+dt@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, thomas.petazzoni@bootlin.com,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Robert Marko <robert.marko@sartura.hr>
References: <20220909152454.7462-1-maxime.chevallier@bootlin.com>
 <20220909152454.7462-2-maxime.chevallier@bootlin.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220909152454.7462-2-maxime.chevallier@bootlin.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/09/2022 17:24, Maxime Chevallier wrote:
> The Qualcomm IPQESS controller is a simple 1G Ethernet controller found
> on the IPQ4019 chip. This controller has some specificities, in that the
> IPQ4019 platform that includes that controller also has an internal
> switch, based on the QCA8K IP.
> 
> It is connected to that switch through an internal link, and doesn't
> expose directly any external interface, hence it only supports the
> PHY_INTERFACE_MODE_INTERNAL for now.
> 
> It has 16 RX and TX queues, with a very basic RSS fanout configured at

Thank you for your patch. There is something to discuss/improve.

> +}
> +
> +static int ipqess_axi_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct net_device *netdev;
> +	phy_interface_t phy_mode;
> +	struct resource *res;
> +	struct ipqess *ess;
> +	int i, err = 0;
> +
> +	netdev = devm_alloc_etherdev_mqs(&pdev->dev, sizeof(struct ipqess),

sizeof(*)

> +					 IPQESS_NETDEV_QUEUES,
> +					 IPQESS_NETDEV_QUEUES);
> +	if (!netdev)
> +		return -ENOMEM;
> +
> +	ess = netdev_priv(netdev);
> +	ess->netdev = netdev;
> +	ess->pdev = pdev;
> +	spin_lock_init(&ess->stats_lock);
> +	SET_NETDEV_DEV(netdev, &pdev->dev);
> +	platform_set_drvdata(pdev, netdev);
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	ess->hw_addr = devm_ioremap_resource(&pdev->dev, res);

Use a helper for this.

> +	if (IS_ERR(ess->hw_addr))
> +		return PTR_ERR(ess->hw_addr);
> +
> +	err = of_get_phy_mode(np, &phy_mode);
> +	if (err) {
> +		dev_err(&pdev->dev, "incorrect phy-mode\n");
> +		return err;
> +	}
> +
> +	ess->ess_clk = devm_clk_get(&pdev->dev, "ess");

There is no such clock "ess"...

> +	if (!IS_ERR(ess->ess_clk))
> +		clk_prepare_enable(ess->ess_clk);
> +
> +	ess->ess_rst = devm_reset_control_get(&pdev->dev, "ess");

Same problem.

> +	if (IS_ERR(ess->ess_rst))
> +		goto err_clk;
> +
> +	ipqess_reset(ess);
> +
> +	ess->phylink_config.dev = &netdev->dev;
> +	ess->phylink_config.type = PHYLINK_NETDEV;
> +	ess->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
> +					       MAC_100 | MAC_1000FD;
> +
> +	__set_bit(PHY_INTERFACE_MODE_INTERNAL,
> +		  ess->phylink_config.supported_interfaces);
> +
> +	ess->phylink = phylink_create(&ess->phylink_config,
> +				      of_fwnode_handle(np), phy_mode,
> +				      &ipqess_phylink_mac_ops);
> +	if (IS_ERR(ess->phylink)) {
> +		err = PTR_ERR(ess->phylink);
> +		goto err_clk;
> +	}
> +

Best regards,
Krzysztof
