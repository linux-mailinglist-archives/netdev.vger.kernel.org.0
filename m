Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DFFC368AC7
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240492AbhDWByZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 21:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240012AbhDWByY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 21:54:24 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5695C061574;
        Thu, 22 Apr 2021 18:53:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id em21-20020a17090b0155b029014e204a81e6so3666206pjb.1;
        Thu, 22 Apr 2021 18:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3AapXKx/UR2C9m5toXV3NnksmytSDvqetzIlr+4AOIQ=;
        b=Yq+hWTpyUb5jC2aBPRWWAT+1pNXN/PmmoktnFe3+ZoIKpoi9HD+uuf610lPw33ctPd
         Pe1o/4yySjl6O6sverUn9FEPzsuL6C956CAdI1JBBryV5WxvxwW8BYCS4akZ+6MGeSrb
         9LdOLdQGOZbP4+UrfkjrzBsrGPgzVkNXzaPV3ejf7YniWLsyKIucQ3S6RZUQcm7+EwpA
         BieKb/DD2vCGtesqvFbmIQQ4oiILAZlvW3+d/i4weL1A8EiY1N9s+JKdPMtdQU5uYAWf
         ixJto0TfgEHUM7JCxkCreznNHG7uapUOrwvD2NYnFK4K5oV8cxUK2NKMU3/QWuysHgdB
         OjSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3AapXKx/UR2C9m5toXV3NnksmytSDvqetzIlr+4AOIQ=;
        b=r8L7XbjuxIrHcR8kYKMt2iCAjY0z++ByGy2VxgmDV1qlYTEZ2J/w3HLK2/1fPHBWv6
         Hb4/1jOfKZarkOyIZUjBbaQX/MtiVxYuSXYAHipglV/FgiVmJdaU8VkdX8pB5BogkaTG
         +iHqJJyc4mw/E+O0lr5th7P3oaGHZVYJ2Mgs0VsN1SHiabOiQwdXIqYgOQ8jAIwfUGWX
         UFG1+3bFzJShWBL+MOGoEZueT00IICtulasZJzviD6S4rgQXcy9eQ61IVLNezah3IA10
         2XfsOyQOwPvW2uNpFR8MdqoruZ140pnXTWd2hB6yhWrj4pZKCE7UK2UASsyJch7Iwtj1
         XjrA==
X-Gm-Message-State: AOAM5310ibpO9KCMpYq2kS6T0kDOL4IB1GXSVmRhj25iYY4PtGwKPkTC
        l6FkVcjGs4MMBFtQ1io4aLJz3IFajeI=
X-Google-Smtp-Source: ABdhPJyj2Cq7+PyyT+IF3sUuvDH34b1XSGAshK+VWvD3G8i3BbEhLCS1ZOlNdrNvreOFeU2KJJxVcw==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr3110884pjb.27.1619142828040;
        Thu, 22 Apr 2021 18:53:48 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 16sm6073884pjk.15.2021.04.22.18.53.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Apr 2021 18:53:47 -0700 (PDT)
Subject: Re: [PATCH 02/14] drivers: net: dsa: qca8k: tweak internal delay to
 oem spec
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210423014741.11858-1-ansuelsmth@gmail.com>
 <20210423014741.11858-3-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fdddeb1a-33c7-3087-86a1-f3b735a90eb1@gmail.com>
Date:   Thu, 22 Apr 2021 18:53:45 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210423014741.11858-3-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/22/2021 6:47 PM, Ansuel Smith wrote:
> The original code had the internal dalay set to 1 for tx and 2 for rx.
> Apply the oem internal dalay to fix some switch communication error.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
>  drivers/net/dsa/qca8k.c | 6 ++++--
>  drivers/net/dsa/qca8k.h | 9 ++++-----
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/dsa/qca8k.c b/drivers/net/dsa/qca8k.c
> index a6d35b825c0e..b8bfc7acf6f4 100644
> --- a/drivers/net/dsa/qca8k.c
> +++ b/drivers/net/dsa/qca8k.c
> @@ -849,8 +849,10 @@ qca8k_phylink_mac_config(struct dsa_switch *ds, int port, unsigned int mode,
>  		 */
>  		qca8k_write(priv, reg,
>  			    QCA8K_PORT_PAD_RGMII_EN |
> -			    QCA8K_PORT_PAD_RGMII_TX_DELAY(QCA8K_MAX_DELAY) |
> -			    QCA8K_PORT_PAD_RGMII_RX_DELAY(QCA8K_MAX_DELAY));
> +			    QCA8K_PORT_PAD_RGMII_TX_DELAY(1) |
> +			    QCA8K_PORT_PAD_RGMII_RX_DELAY(2) |
> +			    QCA8K_PORT_PAD_RGMII_TX_DELAY_EN |
> +			    QCA8K_PORT_PAD_RGMII_RX_DELAY_EN);

There are standard properties in order to configure a specific RX and TX
delay:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/net/ethernet-controller.yaml#n125

can you use that mechanism and parse that property, or if nothing else,
allow an user to override delays via device tree using these standard
properties?
-- 
Florian
