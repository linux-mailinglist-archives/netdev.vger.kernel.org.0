Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D4E46BF09A
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 19:21:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbjCQSV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 14:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229799AbjCQSV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 14:21:26 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B75260415
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:21:24 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id fd5so23721838edb.7
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 11:21:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679077283;
        h=content-transfer-encoding:in-reply-to:subject:cc:from
         :content-language:references:to:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5GEf9DhgwNVevW1FesQHPvOROalPqWpYAagy6INTOMk=;
        b=qePKp7YE1wwKbufkkEDAaHsMXl3FeL+aZHLcq4TqUT8C3SlmsNeijiJJj47Dt0wXy2
         lF5LOqD5+DyvOroh2gHfVNgnf70d5G04kxRwc5fCLqBb1CT4F9aLeRByp6jsQudHQzms
         p5VNYmwgQQHk+KEtanmYhoXW1eixNGRkoSb99qJ2gSqR2+c5OaUAo7UXWyhNDwP4v5fC
         TJkBVlR+bxMybDOmFlPhJ1Oa6FAMDV3PSoGFiDj3l+Ss3dcnnM8fmM4DKUL1HG+hM0fw
         W3dDl92PI2sSGdBVH/gBOwcovt7W8O2QwftgMgoEmw0vHZMthapgSIS8waaWx9pWg3qc
         HTBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679077283;
        h=content-transfer-encoding:in-reply-to:subject:cc:from
         :content-language:references:to:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5GEf9DhgwNVevW1FesQHPvOROalPqWpYAagy6INTOMk=;
        b=DXGWjTGni7aSX1NYqlYFzq4DEWbTH8JXNNsj0AogPto0bgk0G4zcea9tS9ZVMM9D2l
         HDXPmBN969JgMdKB2TTe2oQMxKVAvdf2LrIQfFSs1RZvbtaFDCt4bFvWQlHzw/peyfir
         B/9YDyVTKbWqREi5eUPlKc+X4ektJbRIq9rEdogmuLC00YV0u1s46gX1ZTZU8GbOeVAj
         hjYfc7yIqCvlTI6c3TR0v8gNRNN8PPrQRdL6UweN8KHnz+X2INbW5MhGUgCZU0Yfp12V
         uEO0JgTjYE3cIZLlTaEDZTehBvaImtOALJMCld2RwEWqP/l3wCod1g6a4ahstN3vUJrk
         3s8g==
X-Gm-Message-State: AO0yUKXkd5OOVvTXJsgyPz7vqoAfHwPD39oEGLh+k9GDbZuNobdYS9Ob
        fh6PiUmPbv7uvfkI7SibJDE=
X-Google-Smtp-Source: AK7set/iCvtv975Vhdt5MxalFKHlzb/EaG3JyTt3kJkVufffjsmXm8jaGIFpoDq8pKvGUDtCBXSXaA==
X-Received: by 2002:a17:906:3fcf:b0:92d:6078:3878 with SMTP id k15-20020a1709063fcf00b0092d60783878mr371919ejj.33.1679077282852;
        Fri, 17 Mar 2023 11:21:22 -0700 (PDT)
Received: from ?IPV6:2a01:c23:c5b8:6200:464:40e3:4e4f:fcaf? (dynamic-2a01-0c23-c5b8-6200-0464-40e3-4e4f-fcaf.c23.pool.telefonica.de. [2a01:c23:c5b8:6200:464:40e3:4e4f:fcaf])
        by smtp.googlemail.com with ESMTPSA id g12-20020a170906198c00b00930c7b642d0sm1228078ejd.166.2023.03.17.11.21.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 11:21:22 -0700 (PDT)
Message-ID: <3e904a01-7ea8-705c-bf7a-05059729cebf@gmail.com>
Date:   Fri, 17 Mar 2023 19:21:20 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
To:     arturo.buzarra@digi.com
References: <20230317121646.19616-1-arturo.buzarra@digi.com>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH] net: phy: return EPROBE_DEFER if PHY is not accessible
In-Reply-To: <20230317121646.19616-1-arturo.buzarra@digi.com>
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

On 17.03.2023 13:16, arturo.buzarra@digi.com wrote:
> From: Arturo Buzarra <arturo.buzarra@digi.com>
> 
> A PHY driver can dynamically determine the devices features, but in some
> circunstances, the PHY is not yet ready and the read capabilities does not fail
> but returns an undefined value, so incorrect capabilities are assumed and the
> initialization process fails. This commit postpones the PHY probe to ensure the
> PHY is accessible.
> 
To complement what has been said by Florian and Andrew:

"under some circumstances" is too vague in general. List potential such
circumstances and best what happened exactly in your case.

When genphy_read_abilities() is called the PHY has been accessed already,
reading the PHY ID. 

So best start with some details about your use case, which MAC, which PHY, etc.

> Signed-off-by: Arturo Buzarra <arturo.buzarra@digi.com>
> ---
>  drivers/net/phy/phy_device.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
> index 1785f1cead97..f8c31e741936 100644
> --- a/drivers/net/phy/phy_device.c
> +++ b/drivers/net/phy/phy_device.c
> @@ -2628,10 +2628,14 @@ int genphy_read_abilities(struct phy_device *phydev)
>  			       phydev->supported);
>  
>  	val = phy_read(phydev, MII_BMSR);
>  	if (val < 0)
>  		return val;
> +	if (val == 0x0000 || val == 0xffff) {
> +		phydev_err(phydev, "PHY is not accessible\n");
> +		return -EPROBE_DEFER;
> +	}
>  
>  	linkmode_mod_bit(ETHTOOL_LINK_MODE_Autoneg_BIT, phydev->supported,
>  			 val & BMSR_ANEGCAPABLE);
>  
>  	linkmode_mod_bit(ETHTOOL_LINK_MODE_100baseT_Full_BIT, phydev->supported,

