Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACD466A32E0
	for <lists+netdev@lfdr.de>; Sun, 26 Feb 2023 17:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjBZQmV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Feb 2023 11:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjBZQmU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Feb 2023 11:42:20 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1378410AA6;
        Sun, 26 Feb 2023 08:42:19 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id s26so16386867edw.11;
        Sun, 26 Feb 2023 08:42:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GFVrRwJiceJX6p3MtGyVAnzQ7b5nsJUgQ+NNlDERCOI=;
        b=bXW6FnwAz+6fEyfqxdgUnQr8YdiYse615NWFGzlE8V8nVqJWXk6GYZ6lt10PQftFRQ
         WSw3kLEowuQkCi9PJMs6IK7dcForHdLc0hS+K8C7btNGIUU7SexsDTgvj5ltPl6qZzpV
         3/jELW/vAKSDnqwn6BeyswI/ONmlKejt9hZyIRF8asmG1PxU3ccNzSk5jk1KnqQa1kEX
         PAkRjWlMmnjnrWItLUtv5d2UIC7IzBwCsa/6a+Y6iMOBz+DaTBdBfCrTLKLXikhPELET
         Syds8pdOhjKGuci4X46c0Os4xk3a6y2vhYAre0w3PzGPJi1ovEjEuEdHI6EfNoBtarlq
         ddMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:subject:from:content-language
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GFVrRwJiceJX6p3MtGyVAnzQ7b5nsJUgQ+NNlDERCOI=;
        b=VFeOSav7uPWu0X7PsyZxObyphdtA2DODapjqJop77si+NzO2ppsYaD16g2Amu08O40
         oLnpzlNORJ8Fmx7krO09zpaGzJnzVXKa8UFP0xbFK1OkQ0ZBZ0hX7Z1tEb4NJluhCea4
         aklarKVeRMVK6Ism6zhl67wctDHnU+xEq1dv4NPCYBxBxRXfqH5J/L6hXXLvLHJMhmC5
         rZzOPk+R/V/ni8PKquQ7Xdyx3mMFGqW5pg47bpBZWTOyp9ejWwnMJMwCTL34l/8Crhhq
         tcP0jsWTaOPQ5x6HslFLLyFT0bTphqG3Sq0anzLL+mBKhAVHCaGCaQloeM6iVhfNLSyF
         bMJQ==
X-Gm-Message-State: AO0yUKWd2Ei34L1dElCd76uqhjEqcZXvYyYnMYMUu4bTSJxSTRThZUVX
        jeDNVvUowhp1VvEpTwqEQ9o=
X-Google-Smtp-Source: AK7set+b/aldD90B2+Z55MQrbjcjojOBwZ9aZPldbarWWGd6jE2Zyr+ZF9BmaBnuJyyNniUIqipPmw==
X-Received: by 2002:a05:6402:35cb:b0:4aa:a280:55b5 with SMTP id z11-20020a05640235cb00b004aaa28055b5mr6184728edc.20.1677429736560;
        Sun, 26 Feb 2023 08:42:16 -0800 (PST)
Received: from ?IPV6:2a01:c22:7af0:2200:c0b0:beb3:eda8:5ddf? (dynamic-2a01-0c22-7af0-2200-c0b0-beb3-eda8-5ddf.c22.pool.telefonica.de. [2a01:c22:7af0:2200:c0b0:beb3:eda8:5ddf])
        by smtp.googlemail.com with ESMTPSA id g10-20020a50d0ca000000b004acc123cd94sm2135809edf.30.2023.02.26.08.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Feb 2023 08:42:16 -0800 (PST)
Message-ID: <92332a2e-8e87-567d-7b4c-6ca779c866aa@gmail.com>
Date:   Sun, 26 Feb 2023 17:42:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-renesas-soc@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Russell King <linux@armlinux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230223070519.2211-1-wsa+renesas@sang-engineering.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [REGRESSION PATCH RFC] net: phy: don't resume PHY via MDIO when
 iface is not up
In-Reply-To: <20230223070519.2211-1-wsa+renesas@sang-engineering.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23.02.2023 08:05, Wolfram Sang wrote:
> TLDR; Commit 96fb2077a517 ("net: phy: consider that suspend2ram may cut
> off PHY power") caused regressions for us when resuming an interface
> which is not up. It turns out the problem is another one, the above
> commit only makes it visible. The attached patch is probably not the
> right fix, but at least is proving my assumptions AFAICS.
> 
> Setup: I used Renesas boards for my tests, namely Salvator-XS and Ebisu.
> They both use RAVB driver (drivers/net/ethernet/renesas/ravb_main.c) and
> a Micrel KSZ9031 PHY (drivers/net/phy/micrel.c). I think the problems
> are generic, though.
> 
> Long text: After the above commit, we could see various resume failures
> on our boards, like timeouts when resetting the MDIO bus, or warning
> about skew values in non-RGMII mode, although RGMII was used. All of
> these happened, because phy_init_hw() was now called in
> mdio_bus_phy_resume() which wasn't the case before. But the interface
> was not up yet, e.g. phydev->interface was still the default and not
> RGMII, so the initialization didn't work properly. phy_attach_direct()
> pays attention to this:
> 
> 1504         /* Do initial configuration here, now that
> 1505          * we have certain key parameters
> 1506          * (dev_flags and interface)
> 1507          */
> 1508         err = phy_init_hw(phydev);
> 
> But phy_init_hw() doesn't if the interface is not up, AFAICS.
> 
> This may be a problem in itself, but I then wondered why
> mdio_bus_phy_resume() gets called anyhow because the RAVB driver sets
> 'phydev->mac_managed_pm = true' so once the interface is up
> mdio_bus_phy_resume() never gets called. But again, the interface was
> not up yet, so mac_managed_pm was not set yet.
> 
Setting phydev->mac_managed_pm in the open() callback is too late.
It should be set as soon as the phydev is created. That's in
ravb_mdio_init() after the call to of_mdiobus_register().

It should be possible to get the phydev with:
pn = of_parse_phandle(np, "phy-handle", 0);
phy = of_phy_find_device(pn);


> So, in my quest to avoid mdio_bus_phy_resume() being called, I tried
> this patch declaring the PHY being in suspend state when being probed.
> The KSZ9031 has a soft_reset() callback, so phy_init_hw() will reset the
> suspended flag when the PHY is attached. It works for me(tm),
> suspend/resume now works independently of the interface being up or not.
> 
> I don't think this is the proper solution, though. It will e.g. fail if
> some PHY is not using the soft_reset() callback. And I am missing the
> experience in this subsystem to decide if we can clear the resume flag
> in phy_init_hw() unconditionally. My gut feeling is that we can't.
> 
> So, this patch mostly demonstrates the issues we have and the things I
> found out. I'd be happy if someone could point me to a proper solution,
> or more information that I am missing here. Thank you in advance and
> happy hacking!
> 
> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
> ---
>  drivers/net/phy/phy_device.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 8cff61dbc4b5..5cbb471700a8 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -3108,6 +3108,7 @@ static int phy_probe(struct device *dev)
>  
>  	/* Set the state to READY by default */
>  	phydev->state = PHY_READY;
> +	phydev->suspended = 1;
>  
>  out:
>  	/* Assert the reset signal */

