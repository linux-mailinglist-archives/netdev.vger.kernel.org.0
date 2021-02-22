Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3A43222BD
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhBVXpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230268AbhBVXpG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 18:45:06 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400FBC061574;
        Mon, 22 Feb 2021 15:44:26 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id j12so7608885pfj.12;
        Mon, 22 Feb 2021 15:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8MPdDMyzCFyudOaKlYsypYeIZ6NLuvsPxKi+0++3asc=;
        b=UuHo1B4I1X4om2XxfE5wKW6dA+6ZGKzv1nffsYNnXWu5iOokBiVY1KaHxb5UqeMrGP
         dXv1RONhvMEfM255w5qD7f69sWU9bYGvUw4aDjXvr4eVQfqLpod7dkWlTFi3uNx9VYZa
         YD3BXq0TtY22DtbXa6KTzpOpyeUh+4RpZJR/iaeqaG0dY3269b3vDo59xG57HcxG9V5J
         Y4eIhTxRdH5u/M+83ooSIBeFS89/7eCxuBaMM+PvOZ4/XvjZzQtDCPX44XovaVYwldGH
         TepG+elp9KFUP1KZMIgBXX/SWzYsvPhSoLyK30hK6K2zxOzn3IlcNqHzRGizd9GvpsU8
         pzbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8MPdDMyzCFyudOaKlYsypYeIZ6NLuvsPxKi+0++3asc=;
        b=RVysOukKCJQp3mVsDPXmVLZ+1cBA/SESknWUc1o6knkxYdJXWE6OCSHOwN0kTdY025
         CevfKDH2dZ3VZzWLSH0CsdyTC3YaHarAsvaBAS8nmmt435kGbwU9oaJQb4wNX54L73qX
         PNT005QM8NtOvOH9k0yVpiBM4crl8bZ3QrPSuq0LKqd44KUjkqGOQEqGJxIb+W4zBG1I
         TeCFSFW+qhS1y8C8GlVJ6QJBhm0ek1/dY9BprJxduTTt6RUebGJxK+buV3SQk84H3NFX
         jZ2p9o6VkL2rco/zmD+LgNPD9atct+P4ZZKJ2zeguxv9LajDCNLqkGM4Kxdn0hMZQ9hr
         ZHGQ==
X-Gm-Message-State: AOAM532CKfn+QHLw9V4DnMWD8BPjS9qzyXqiXMcFKrm3wrkVgFz0bQFF
        2OI0u3o5J0T6ANJQYZEaA7cXxRqDOCA=
X-Google-Smtp-Source: ABdhPJwI59/BCK3/B/wWNia+iXUBWDefFSZKbMaob9+EN56mXZ1sB5tgNv3+R0WmngGfFqBs640bhQ==
X-Received: by 2002:aa7:9462:0:b029:1e0:c1d:750a with SMTP id t2-20020aa794620000b02901e00c1d750amr23394891pfq.25.1614037465065;
        Mon, 22 Feb 2021 15:44:25 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 190sm21452018pgh.81.2021.02.22.15.44.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Feb 2021 15:44:24 -0800 (PST)
Subject: Re: [PATCH net v2 2/2] net: dsa: b53: Support setting learning on
 port
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        open list <linux-kernel@vger.kernel.org>
References: <20210222223010.2907234-1-f.fainelli@gmail.com>
 <20210222223010.2907234-3-f.fainelli@gmail.com>
 <20210222231832.fzrq3y3vbok5byd3@skbuf>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3ba2c390-5318-999b-d1bb-097a89486ce1@gmail.com>
Date:   Mon, 22 Feb 2021 15:44:21 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210222231832.fzrq3y3vbok5byd3@skbuf>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/22/2021 3:18 PM, Vladimir Oltean wrote:
> On Mon, Feb 22, 2021 at 02:30:10PM -0800, Florian Fainelli wrote:
>> diff --git a/drivers/net/dsa/b53/b53_regs.h b/drivers/net/dsa/b53/b53_regs.h
>> index c90985c294a2..b2c539a42154 100644
>> --- a/drivers/net/dsa/b53/b53_regs.h
>> +++ b/drivers/net/dsa/b53/b53_regs.h
>> @@ -115,6 +115,7 @@
>>  #define B53_UC_FLOOD_MASK		0x32
>>  #define B53_MC_FLOOD_MASK		0x34
>>  #define B53_IPMC_FLOOD_MASK		0x36
>> +#define B53_DIS_LEARNING		0x3c
>>  
>>  /*
>>   * Override Ports 0-7 State on devices with xMII interfaces (8 bit)
>> diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
>> index 3eaedbb12815..5ee8103b8e9c 100644
>> --- a/drivers/net/dsa/bcm_sf2.c
>> +++ b/drivers/net/dsa/bcm_sf2.c
>> @@ -223,23 +223,10 @@ static int bcm_sf2_port_setup(struct dsa_switch *ds, int port,
>>  	reg &= ~P_TXQ_PSM_VDD(port);
>>  	core_writel(priv, reg, CORE_MEM_PSM_VDD_CTRL);
>>  
>> -	/* Enable learning */
>> -	reg = core_readl(priv, CORE_DIS_LEARN);
>> -	reg &= ~BIT(port);
>> -	core_writel(priv, reg, CORE_DIS_LEARN);
>> -
>>  	/* Enable Broadcom tags for that port if requested */
>> -	if (priv->brcm_tag_mask & BIT(port)) {
>> +	if (priv->brcm_tag_mask & BIT(port))
>>  		b53_brcm_hdr_setup(ds, port);
>>  
>> -		/* Disable learning on ASP port */
>> -		if (port == 7) {
>> -			reg = core_readl(priv, CORE_DIS_LEARN);
>> -			reg |= BIT(port);
>> -			core_writel(priv, reg, CORE_DIS_LEARN);
>> -		}
>> -	}
>> -
> 
> In sf2, CORE_DIS_LEARN is at address 0xf0, while in b53, B53_DIS_LEARN
> is at 0x3c. Are they even configuring the same thing?

They are the SF2 switch was integrated with a bridge that would flatten
its address space such that there would be no need to access the
registers indirectly like what b53_srab does.

This is the reason why we have the SF2_PAGE_REG_MKADDR() macro to
convert from a {page, offset} tuple to a memory mapped address and here
0x3c << 2 = 0xf0.
-- 
Florian
