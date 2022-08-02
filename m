Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38D6587B76
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 13:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236017AbiHBLTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 07:19:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiHBLTH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 07:19:07 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96B16DC3;
        Tue,  2 Aug 2022 04:19:06 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id dc19so2621233ejb.12;
        Tue, 02 Aug 2022 04:19:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=J1y5TNZKON5vlSONcdAln0bXqaVijZkMRn5GW7MzYv0=;
        b=p/34O66hhmCp7kPoP54vVHKU5VRMMY7RjHFHJs8gpBi4Mh+j6QhGshKvP9TtXBGPlB
         rzWLphica/jqIULYDeb8vlhuh3xbo0uwmZ7ZiJMRjiTyhZr4wT3o6WmeGieTVk8J/5G+
         /J9JX5PsPIOsmlYNxpsaqEsG/rmGvkQeF7DdwSXZuZUEWhNf3hUbYUAnTMxHewXtRFL6
         fBbsGU419U1pefRjv/7SmNZbtro+R3kV1I30bVKisNBsDax2rLUgyePrGFQ6zNIQjHRb
         hr3YEVo/teZ/He9ASXHO78CPUSN7rSxyxry0i9QDIMoV5e0cZe/Jg7aYlgQhhst8mh3q
         LxFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J1y5TNZKON5vlSONcdAln0bXqaVijZkMRn5GW7MzYv0=;
        b=WrbVJzftCSrDMutEYZ5B0GMuBhZOglybWZKpTG0eNUwmMbhyOpw5D78NkhozS9qZsH
         9N0LdkzYpEYtndrRTlN9yoQ88UGK0967ccDRxfEnafDYhv1uQZsU7qXORtQfVqcwk1aK
         Pgd97ElZ92g/2Ft8NMEnw05LnVuMsUySNXsVnGbKd8xrx2tt39Xro80aLQomJEpNnsCt
         GRBeQC9H7o8q+SgxOUKhAqwulhi+HPm+2qj7AhzYWpO+IJkVQbG1XjtsglUQzZ2XtnW3
         OH2hKsIsjETfmhEzYb9pOYG6KezgFtf6+aBXSwnXuTHjhr6g47FZtkue2MnJdtLTpUi1
         TTFg==
X-Gm-Message-State: AJIora8I5hFUSuLVieIQaE+0TfwGrUMe+sN9Ia5yX87Q9967BvVbeRj4
        8ENVPLQ4DCF4oVEA4K9XVJS4D90KIS75cw==
X-Google-Smtp-Source: AGRyM1vDCDDrFZaU1k2I6j5t4q6GmmZEjVjjgUKq76tgUTOBVKP50JSuzmdf6hA0W4Y46OYcDmxjLQ==
X-Received: by 2002:a17:907:9491:b0:72f:2827:37c3 with SMTP id dm17-20020a170907949100b0072f282737c3mr16094588ejc.306.1659439145030;
        Tue, 02 Aug 2022 04:19:05 -0700 (PDT)
Received: from skbuf ([188.25.231.115])
        by smtp.gmail.com with ESMTPSA id e24-20020a170906315800b007246492658asm6187025eje.117.2022.08.02.04.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 04:19:04 -0700 (PDT)
Date:   Tue, 2 Aug 2022 14:19:02 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, kernel@pengutronix.de,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v1 02/10] net: dsa: microchip: allow to pass
 return values for PHY read/write accesses
Message-ID: <20220802111902.d4wpp52vglnuxqj4@skbuf>
References: <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-1-o.rempel@pengutronix.de>
 <20220729130346.2961889-3-o.rempel@pengutronix.de>
 <20220729130346.2961889-3-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220729130346.2961889-3-o.rempel@pengutronix.de>
 <20220729130346.2961889-3-o.rempel@pengutronix.de>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 29, 2022 at 03:03:38PM +0200, Oleksij Rempel wrote:
> PHY access may end with errors on different levels. So, allow to forward
> return values where possible.
> 
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
> -void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
> +int ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
>  {
>  	u8 restart, speed, ctrl, data;
>  	const u16 *regs;
> @@ -787,6 +789,9 @@ void ksz8_w_phy(struct ksz_device *dev, u16 phy, u16 reg, u16 val)
>  	default:
>  		break;
>  	}
> +
> +

Too many empty lines.

> +	return 0;
>  }
