Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7441D373284
	for <lists+netdev@lfdr.de>; Wed,  5 May 2021 00:34:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232345AbhEDWej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 May 2021 18:34:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229705AbhEDWeg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 May 2021 18:34:36 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B9DEC061574;
        Tue,  4 May 2021 15:33:40 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id h11so690815pfn.0;
        Tue, 04 May 2021 15:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=N/iQQC7fp/dtYGOuSg6VYXx30On1O4Podmv44Ld28t8=;
        b=cRTWCW0YlQcO68lQFrrYGCgLtQegbYPyhazNFTL3zL/R64bBPmvH0h5Tu9vqfIBhaF
         5KQaPkKxiejgQSJLD35yHwKXO0kqounJlwAw12ms9nnlolkco/OLqwvBLIhVZ3C8JiL9
         8QerknFPKHi/YlICqWSzmNX6BblRirN0iXoFDw4ZIy8Hr59eS6FCsdDuzxZtcEE+Se7S
         tF/BiljZhJZJA8XSMtEuRt9vzw2v9nvF3If9rwpc+sblXIiv5OGLf4zcqo44zSfNuLPS
         ZlrFjXr20bvOQdxkEgH4wAMqttnO4rhW1AwDhYnHNV++ihpOU8IzPzEwjUlM8cXiLYNM
         iGPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=N/iQQC7fp/dtYGOuSg6VYXx30On1O4Podmv44Ld28t8=;
        b=qdKOfoOAXLcYie070TYkw+jvFz1uqVskwQpx3a/usPK1OavC/N8KIWz1YL+mdYPYNO
         qplEKjQUMvOM62IvvAfA6tRo3Ls2ft8rmDgM4WJmZWyt/ZWD4K1+HqX0ZKJ3obR6M8mX
         4a/89vH8NSJSWoWXrsPm/+4jQ1nU5WXLx+0InmMlurwGylS/VOrS38OTRkyKs9dUpt9w
         Odc9B7zVz662Td1lMDcv13cgoQBC8r6qbUocgR8AZCZsRaPxKwizQQIdr61OLkAmU3Rm
         Hy4waQSj71Qrhv5qfm9CsLGLehoZil78gOnBIjzjbbTUekqLf/IOQ4AXiNViZZ+ccQj9
         a+1Q==
X-Gm-Message-State: AOAM5337T5p+uBzXLT6Rw2BiysUEdHLXyiJxW7u1McofKsD8vH7tIoFM
        Q4mnjdTMvTkT/If8ezgLRl0=
X-Google-Smtp-Source: ABdhPJxeUdey3txVslmafHpEU1z7jkArZjP7M9glN+el45WexOPrS6npD8eEng0OPRAMcqu3zUpE0A==
X-Received: by 2002:a63:f443:: with SMTP id p3mr25493518pgk.378.1620167619709;
        Tue, 04 May 2021 15:33:39 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j16sm5013761pgh.69.2021.05.04.15.33.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 May 2021 15:33:39 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v3 17/20] net: phy: phylink: permit to pass
 dev_flags to phylink_connect_phy
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Nicolas Ferre <nicolas.ferre@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
References: <20210504222915.17206-1-ansuelsmth@gmail.com>
 <20210504222915.17206-17-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <79cd97fe-02e8-4373-75a5-78ad0179c42b@gmail.com>
Date:   Tue, 4 May 2021 15:33:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210504222915.17206-17-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/4/21 3:29 PM, Ansuel Smith wrote:
> Add support for phylink_connect_phy to pass dev_flags to the PHY driver.
> Change any user of phylink_connect_phy to pass 0 as dev_flags by
> default.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

I do not think that this patch and the next one are necessary at all,
because phylink_of_phy_connect() already supports passing a dev_flags.

That means that you should be representing the switch's internal MDIO
bus in the Device Tree and then describe how each port of the switch
connects to the internal PHY on that same bus. Once you do that the
logic in net/dsa/slave.c will call phylink_of_phy_connect() and all you
will have to do is implement dsa_switch_ops::get_phy_flags. Can you try
that?
-- 
Florian
