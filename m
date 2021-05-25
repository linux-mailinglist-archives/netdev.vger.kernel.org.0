Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 403D138F843
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 04:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230185AbhEYClP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 22:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbhEYClO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 May 2021 22:41:14 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A727C061574
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:39:46 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id e15so8980055plh.1
        for <netdev@vger.kernel.org>; Mon, 24 May 2021 19:39:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=K682to1ngajsza0NriqBkeMUIgpCq9IFNSkmr8ExMdw=;
        b=oYeR6/5aOXw/rZ5GTA77nHj3Sq94tAX4AqjYbHO+xj4UD0fxFjxIKP2uJgKiqHVt2i
         aYNPDqbGSQOhflFxmKxmNtTOGWr69xDZnHNpzcPZM8uYMYOm07rBxzanMmmwMnAEwTc2
         9dMMCzPJikWnmfeasjoCfQk0JmB2MbpLlbGbpkDCxNEyNyQAkmABjwxkYt2n1zhwO2Ir
         1MJUyKQZeraDbDTLvwLF0ZMen1d030M+iPKmlbzD90YN+QVKnVn9wYXh2T4uihQtOXRC
         yHbB4LGE2urq6q9gsrVvYBre7tJwX9At6G9CXteqeqTVsaCcXQ1btiBpRz3Frgm09ZuG
         6Thg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=K682to1ngajsza0NriqBkeMUIgpCq9IFNSkmr8ExMdw=;
        b=rZwkD6bXb1VQYwRlW24plJV1e7Z4ppWuZGp8MTv0oyMoL0FOoiEWn9XLuNmAnFwUkq
         kQz91GxhgIAU73ALpzsudUcJQA8TbBKlSe863k5g/Kl5Pps/Dp3n1aV1wZKbRLkv5Djp
         eCw2MA+GQZ7pmr9ksRszLWF1qXlkTkISaSDS36jTo4BkdmeZL46vWzy40xeuF3tleqee
         Vjb8xlH2AxM2W4HLt7aA5ZHiqJbg/4S/VVqyP7ONkeQ7zZD83ElUbmTHkdR8G7v9OeQh
         oKYL9/SZcuzRQ/ogTe/vvwgxc/2Au0NdJAxrnEIL6HBVCUrFILH5KbtphMkChI3UhiR+
         gSzA==
X-Gm-Message-State: AOAM531/f/ZogPF1lVlg2dPCnAtXwn9wqQjUIjJJnxALfCwtg0c0mt8N
        frJV+eSHqsFGh4CC7yu0s9U=
X-Google-Smtp-Source: ABdhPJxxCAnkLK+pXXuajDHMtDSUAY5EHqfRhhzBnwteaSY1ozFAObvL3vv7qGlGzAoBGtiqxdowOw==
X-Received: by 2002:a17:902:8e88:b029:ee:b947:d7df with SMTP id bg8-20020a1709028e88b02900eeb947d7dfmr28411935plb.48.1621910385335;
        Mon, 24 May 2021 19:39:45 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ck21sm11159753pjb.24.2021.05.24.19.39.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 May 2021 19:39:44 -0700 (PDT)
Subject: Re: [PATCH net-next 13/13] net: dsa: sja1105: add support for the
 SJA1110 SGMII/2500base-x PCS
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Russell King <linux@armlinux.org.uk>
References: <20210524232214.1378937-1-olteanv@gmail.com>
 <20210524232214.1378937-14-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <65f1ea13-801b-f808-3cc1-4129ba3b14b9@gmail.com>
Date:   Mon, 24 May 2021 19:39:42 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210524232214.1378937-14-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/24/2021 4:22 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Configure the Synopsys PCS for 10/100/1000 SGMII in autoneg on/off
> modes, or for fixed 2500base-x.
> 
> The portion of PCS configuration that forces the speed is common, but
> the portion that initializes the PCS and enables/disables autoneg is
> different, so a new .pcs_config() method was introduced in struct
> sja1105_info to hide away the differences.
> 
> For the xMII Mode Parameters Table to be properly configured for SGMII
> mode on SJA1110, we need to set the "special" bit, since SGMII is
> officially bitwise coded as 0b0011 in SJA1105 (decimal 3, equal to
> XMII_MODE_SGMII), and as 0b1011 in SJA1110 (decimal 11).

That special bit appears to be write only in the patch you submitted, do
we need it?

How much of the programming you are doing is really specific to the
SJA1110 switch family and how much would be universally (or
configurable) applicable to a Synopsys PCS driver that would live
outside of this switch driver?
-- 
Florian
