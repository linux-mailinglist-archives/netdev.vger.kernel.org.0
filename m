Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 709082B3B91
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 03:58:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbgKPC6C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Nov 2020 21:58:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgKPC6B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Nov 2020 21:58:01 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55C9C0613CF;
        Sun, 15 Nov 2020 18:58:01 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id j5so7654122plk.7;
        Sun, 15 Nov 2020 18:58:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eNO29EHcV4BOXQ+t6yVnI/0F8ygGUshqUsY5NTnMcho=;
        b=JJxkKVIiHIRQMXg0bWMZR3Qqv0r7GSUsS1FgXMueJu8fUy2PYyXiBVEmglgfIyeSbG
         Bt60MZKE+aKW/8IKEzNLLlEu+HQ4tloSpZFCu+35d1qFFzPHvTPupGJHeerrUI9+CEyM
         aiMgjPKABglmd8Ay6c6FOdSsjwsTEB+yukusiXXrrngEZ4q4eo14SJ7SUpnF8yhKY7Dr
         RrxYiP0A8MSBLpsk8jFn2Q4TynwpL9YGw5/T4m0P8WpkkmDrCNaxHDUgagO4si5RyD1Q
         Cpw10XOYojhiSnlS1NTRR4Lg+HdK5nt1oV0Bojqp2nJtbGt4hPxq4LaV/1Vas8wawKmw
         folw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eNO29EHcV4BOXQ+t6yVnI/0F8ygGUshqUsY5NTnMcho=;
        b=K96B2YebXlWKOu88MLRMP0rCZXlE9VxD+lqLmXg0VQJuI7fRiXmoh/IKpw/PIbLUyf
         Xepp2rimjz6y0ruFA7gnKJxpNVWcjpkLqyNUg2RVbe3g3BYJbxKUjDdta7IeDcJNGnpL
         R2SKDvvoR6ElztEyBcoMGFKFGqRg7C8/JgHOvjvKLgn8Dr+KqrbPFqwRuYE14G4yn8UR
         5UunPGHTrLz0fU3LDnGRimo0GA8ovkuST3+Ug/jPt05ciSI3f7aQLSjGTBuJRzvXGO41
         SgF5R6ncnM9v6wRt86u6yBcal5v41Mo7fpbKlWm1cZ9nKsyi2VGrQpZ9bTn0PhnZic+p
         uBSA==
X-Gm-Message-State: AOAM5336CP9P7BOgX1KqLCukKGlq+r7Obgk33uvi60C0SCbc7J0x+sfa
        XgNlJ87wYmXfsy6qkYgRFji7yf43hLs=
X-Google-Smtp-Source: ABdhPJxaQ1941oW+zP7Lyz2/b+sd2CaryA1ZvhOyJ7ePTSKkhq3EHOx/2ptx3UoS/fG/++x0S0xo9g==
X-Received: by 2002:a17:902:6ac5:b029:d6:4e05:8343 with SMTP id i5-20020a1709026ac5b02900d64e058343mr10934436plt.8.1605495480663;
        Sun, 15 Nov 2020 18:58:00 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c12sm15393440pgi.14.2020.11.15.18.57.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 15 Nov 2020 18:57:59 -0800 (PST)
Subject: Re: [PATCH v2] net: lantiq: Wait for the GPHY firmware to be ready
To:     Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        hauke@hauke-m.de, netdev@vger.kernel.org
Cc:     andrew@lunn.ch, vivien.didelot@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, linux-kernel@vger.kernel.org
References: <20201115165757.552641-1-martin.blumenstingl@googlemail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <972ccc3f-2e66-16a2-fb58-875552645342@gmail.com>
Date:   Sun, 15 Nov 2020 18:57:52 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201115165757.552641-1-martin.blumenstingl@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/15/2020 8:57 AM, Martin Blumenstingl wrote:
> A user reports (slightly shortened from the original message):
>   libphy: lantiq,xrx200-mdio: probed
>   mdio_bus 1e108000.switch-mii: MDIO device at address 17 is missing.
>   gswip 1e108000.switch lan: no phy at 2
>   gswip 1e108000.switch lan: failed to connect to port 2: -19
>   lantiq,xrx200-net 1e10b308.eth eth0: error -19 setting up slave phy
> 
> This is a single-port board using the internal Fast Ethernet PHY. The
> user reports that switching to PHY scanning instead of configuring the
> PHY within device-tree works around this issue.
> 
> The documentation for the standalone variant of the PHY11G (which is
> probably very similar to what is used inside the xRX200 SoCs but having
> the firmware burnt onto that standalone chip in the factory) states that
> the PHY needs 300ms to be ready for MDIO communication after releasing
> the reset.
> 
> Add a 300ms delay after initializing all GPHYs to ensure that the GPHY
> firmware had enough time to initialize and to appear on the MDIO bus.
> Unfortunately there is no (known) documentation on what the minimum time
> to wait after releasing the reset on an internal PHY so play safe and
> take the one for the external variant. Only wait after the last GPHY
> firmware is loaded to not slow down the initialization too much (
> xRX200 has two GPHYs but newer SoCs have at least three GPHYs).
> 
> Fixes: 14fceff4771e51 ("net: dsa: Add Lantiq / Intel DSA driver for vrx200")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
