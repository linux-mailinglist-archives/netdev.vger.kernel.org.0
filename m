Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D175FE208
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 20:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiJMSva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Oct 2022 14:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiJMSvE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Oct 2022 14:51:04 -0400
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B271547B9F
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:49:17 -0700 (PDT)
Received: by mail-qt1-x832.google.com with SMTP id h15so2308228qtu.2
        for <netdev@vger.kernel.org>; Thu, 13 Oct 2022 11:49:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hh8VSPpCMU9TIR5sHV9wcae/102Ucbb59hlSDBbz5K0=;
        b=jTpqb6zkVQ4xqk9gOWmU9z54LGeG7Qjn3ItnfydnvulihLlcuPeSEWmoivT+l9KQ8N
         KTF9k46oi+jJkFSYtiIrdRWdWwbYc5w5lj9HOI4LKFbB5mL+KTzeOvA5Oj1qsD8GEIv8
         rqZzSALPiyy7BMHRY5aS5crLMMfcAUaRRtXNJo3CcbybGra1OAZq6vGD9vMsRLvjTHcv
         6EUVhMDNaXQzNraQa5xJxDWZjtcBxHER7EA9OzQBqK2s43+Lo5dO0cO5h22QLCFJ0dWi
         5y9AKHe3VsWY1MXbhWpfq8FpZ6/8Lg9Mc1x623wLRAmEa9adgvDvnkxfDwcMBTw7Jsxt
         Jzpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Hh8VSPpCMU9TIR5sHV9wcae/102Ucbb59hlSDBbz5K0=;
        b=Opp5HH+R0jMgZCpNBn4oL1Nmf1HFHYROv8WagIg+GHQhTtTpR073kJD8SQY7X43aqI
         zB0d+2aaByvgbaq8VomKF/093vUhHyA//il7KwEwtb3wDl2pP5YPQ1uLuCGZ5r69bUPH
         /w9Jv8Q9wQtLXRCQOoWMmL7thfvlo5OtvhKMltYG7onFeyfEhIJFCP8hReOMx/WP46MQ
         zQWktHGpnjvzMcsVxuhGmF8G0j90TCfOqn6FB/FqgLOwJv5tEb+sFrlBqLDO/+kwz7eo
         RaRXYedBvGjEM8VjHNGfeRmeqxwO5nCqTYCmv+qmSOpC+6+DzFhe9Iy2b4bfUAMHeoHT
         TsoA==
X-Gm-Message-State: ACrzQf2/CF1aiDKJphsVXiB1CPmOBsUad4OggNqQ5rMIRtXRA+zu5WIE
        V6wZlKctv7B9+L9JWTiMSyg=
X-Google-Smtp-Source: AMsMyM7FqhQ83abcQwq5mIJuWc2u/CV0q4+UWl5+zr+whM9PEeb41Ff7MvU48hn8K17v6H0ubYn0Bg==
X-Received: by 2002:ac8:4d5b:0:b0:39c:b6d2:b631 with SMTP id x27-20020ac84d5b000000b0039cb6d2b631mr1078235qtv.487.1665686882814;
        Thu, 13 Oct 2022 11:48:02 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l3-20020ac84583000000b003986fc4d9fdsm497159qtn.49.2022.10.13.11.47.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Oct 2022 11:48:02 -0700 (PDT)
Message-ID: <2c861748-b881-f464-abd1-1a1588e2a330@gmail.com>
Date:   Thu, 13 Oct 2022 11:47:55 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v5 1/2] net: phylink: add mac_managed_pm in phylink_config
 structure
Content-Language: en-US
To:     Shenwei Wang <shenwei.wang@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, imx@lists.linux.dev,
        Russell King <rmk+kernel@armlinux.org.uk>
References: <20221013133904.978802-1-shenwei.wang@nxp.com>
 <20221013133904.978802-2-shenwei.wang@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221013133904.978802-2-shenwei.wang@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/22 06:39, Shenwei Wang wrote:
> The recent commit
> 
> 'commit 47ac7b2f6a1f ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state")'
> 
> requires the MAC driver explicitly tell the phy driver who is
> managing the PM, otherwise you will see warning during resume
> stage.
> 
> Add a boolean property in the phylink_config structure so that
> the MAC driver can use it to tell the PHY driver if it wants to
> manage the PM.
> 
> 'Fixes: 47ac7b2f6a1f ("net: phy: Warn about incorrect
> mdio_bus_phy_resume() state")'

This is not the way to provide a Fixse tag, it should simply be:

Fixes: 47ac7b2f6a1f ("net: phy: Warn about incorrect 
mdio_bus_phy_resume() state"

With that fixed:

Acked-by: Florian Fainelli <f.fainelli@gmail.com>

as a courtesy, you could CC the author of the patch you are fixing BTW
-- 
Florian
