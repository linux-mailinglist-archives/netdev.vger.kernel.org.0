Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DCE552DC6A
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 20:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243579AbiESSI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 14:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241236AbiESSI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 14:08:58 -0400
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A5BB0409;
        Thu, 19 May 2022 11:08:55 -0700 (PDT)
Received: by mail-ej1-x62a.google.com with SMTP id gi33so2978590ejc.3;
        Thu, 19 May 2022 11:08:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=bKLtlyj1omDM7cHVqZHxMKZlB2vZKbH6hnKKHTQb34Y=;
        b=kbtrb5R98xSIg+EZHZD6bvl1UORQjsXulPzGLnZ6lrKv5LoDL2Q1YYuwdJeLipkLTI
         bIbVvAK0dmL1ieDE4l4oSvjl0C9Zizmmg8vriVc4wNEYhn2TaWX6uj04pRRx7mRhXQzV
         eJ+rHGX57gnXkez09+RWBKlGDzYPW5EIk5xO1E3WLyS/WMx/WWubBCUzzQfU0e+Tt2TX
         hBOxhpkvZsjVomx/hTU2eraaHAAHG/wZYJekAukjCX1CXgMMjf33/wH+WusL8eOhjM3y
         l1UYQNIoz7XJKtiwqzZH9UgqNO1GUsHWwOsc3lr4yY68rgHueaXMERejYlPK8KxDHbkJ
         Y6fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bKLtlyj1omDM7cHVqZHxMKZlB2vZKbH6hnKKHTQb34Y=;
        b=lMhj5epTSVpuu+dUdjrikgD0nnJ2Oj4yQCnORGsFVpSS9rgjSz/kiq0nJbW1I2FZn9
         jOSzDexCk12Rhv6VzUYJUwXzb76gSA2sxX8oiPiC6S7wdV8jXl0k7L7iJkXRXMIm4Lhi
         Wt9NGRG8ZLiKPJ1NS2/Ywz+JAbua8rzizxsiILPMHkcE6EJuF4u2iIn6TP+oGM+/Ofy9
         l7MJC/KxZ640iAfbu1Ixyw7B8N8vBKwGPy/lRqVSC5sM5brLHaOMmpeIm6Ul2BuE6h+S
         FpSKhjpm9BUQfF7iXm/razpiZ3nSjZvAcvKnkLli7o76PSTmOx2y1cUg0rQ/8ok437ig
         coWg==
X-Gm-Message-State: AOAM5322KHlGWMJs56xXihho9Mc+PNeAIA1eHyjHwqyYb5iz44Yoa9mY
        +G3XJcK7p05k7La71sRJuWY=
X-Google-Smtp-Source: ABdhPJxQTBVx6kY82ts8VrWsL8afJOmcrh0klfXXq/kVOHUSCjoWqljGKBrHes/YN8bkRO+0PsRqGA==
X-Received: by 2002:a17:907:98eb:b0:6f3:ce56:c1a2 with SMTP id ke11-20020a17090798eb00b006f3ce56c1a2mr5532533ejc.173.1652983734493;
        Thu, 19 May 2022 11:08:54 -0700 (PDT)
Received: from skbuf ([188.25.255.186])
        by smtp.gmail.com with ESMTPSA id i14-20020a1709067a4e00b006fea4d258cfsm112476ejo.147.2022.05.19.11.08.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 11:08:53 -0700 (PDT)
Date:   Thu, 19 May 2022 21:08:51 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     =?utf-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?utf-8?Q?Miqu=C3=A8l?= Raynal <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, netdev@vger.kernel.org,
        Jean-Pierre Geslin <jean-pierre.geslin@non.se.com>,
        Phil Edworthy <phil.edworthy@renesas.com>
Subject: Re: [PATCH net-next v5 07/13] net: dsa: rzn1-a5psw: add Renesas
 RZ/N1 advanced 5 port switch driver
Message-ID: <20220519180851.chpqhou7ykt45oty@skbuf>
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-8-clement.leger@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220519153107.696864-8-clement.leger@bootlin.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 05:31:01PM +0200, Clément Léger wrote:
> +static int a5psw_pcs_get(struct a5psw *a5psw)
> +{
> +	struct device_node *ports, *port, *pcs_node;
> +	struct phylink_pcs *pcs;
> +	int ret;
> +	u32 reg;
> +
> +	ports = of_get_child_by_name(a5psw->dev->of_node, "ethernet-ports");
> +	if (!ports)
> +		return -EINVAL;
> +
> +	for_each_available_child_of_node(ports, port) {
> +		pcs_node = of_parse_phandle(port, "pcs-handle", 0);
> +		if (!pcs_node)
> +			continue;
> +
> +		if (of_property_read_u32(port, "reg", &reg)) {
> +			ret = -EINVAL;
> +			goto free_pcs;

I think when you exit the for_each_available_child_of_node() loop you
need to manually call of_node_put(port).

> +		}
> +
> +		if (reg >= ARRAY_SIZE(a5psw->pcs)) {
> +			ret = -ENODEV;
> +			goto free_pcs;
> +		}
> +
> +		pcs = miic_create(pcs_node);
> +		if (IS_ERR(pcs)) {
> +			dev_err(a5psw->dev, "Failed to create PCS for port %d\n",
> +				reg);
> +			ret = PTR_ERR(pcs);
> +			goto free_pcs;
> +		}
> +
> +		a5psw->pcs[reg] = pcs;
> +	}
> +	of_node_put(ports);
> +
> +	return 0;
> +
> +free_pcs:
> +	a5psw_pcs_free(a5psw);
> +	of_node_put(ports);
> +
> +	return ret;
> +}
