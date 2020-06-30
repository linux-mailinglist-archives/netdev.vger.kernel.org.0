Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E9AA20FBC0
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 20:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390810AbgF3SdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 14:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729676AbgF3SdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 14:33:17 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87E74C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:33:17 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id w3so8118719wmi.4
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 11:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CRoIF/WINBoFoH6+7Ds+SdJ5IZfdp/tQneQYnwizMEk=;
        b=iojJvA35bNuM8DDSumQZXJUBr8fkOmwSKzXWN7rEL5RiSpLeqwzhTj/87cBRT7fO+I
         vpiTbjUhevBcLU1eFGASIa20Yfh7iOqdqzlTGdjBgx1T9Wd5+XIBcD1wzIZgxi4zhf8x
         iXGatQODIhFW6MT90BCO/b2eE/J4zR5uMCWOSlPmeuXwfwT6VBK38I/TnKcHRFXo16Be
         LTlSsa2RWSvEyhIELsSkOW6W4iLwWjKPxL/KOCEnOL+NOa56rvcWHUqCnXJAaWRlfgB4
         3GbzSwY9QOch0jWMgVMtH4w9OjOH6vV9Zv9iJ1NevoPccjBrYyCRFoFuWUcMXaolTZ71
         JxXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CRoIF/WINBoFoH6+7Ds+SdJ5IZfdp/tQneQYnwizMEk=;
        b=QXZny0V/yKcKAYtMSogSh2cumE+UUFBukG/EBilSpgG+pBc6Fqqc5ygctNhmygad94
         ZX47nznAD8ZE6I40k1y8OqrOTsOtpVQ6q5lwcFJHCNWvvru7K4lGcxvIqS0e09iA1XM1
         Zrb4K+2KzfBKQnU0SE1WzlgDBya5j11RjwTCdPKefBzUm6WJ6N0EQm26O2blmexml/64
         UpW7mRDmRAVczW6GRRPJd2GHbn0HzSFFLU0SRUFyweaAvB156SzD7tTbZTLE4rkhYHy9
         WGNq5rtmFeAVPwl1ArL/DoH8zEXm692ZnnfgVS8UfdCBKaY6UQ0NHWeDhHsUnNcwr5D4
         hn3A==
X-Gm-Message-State: AOAM5322xa2WWXArHyi4yMpvHRlrxHWi8Jkunu0iId+DcevM5gAHrxEa
        P8YBHiT/PBnmGv4uRgdB9lmat2Ce
X-Google-Smtp-Source: ABdhPJxg4db7RdXe7lizNb5Ofk3ajsdqS23XY/2zagl+T4g2lghoCIm21U5KVuNQS0SUMRH6si+UEw==
X-Received: by 2002:a1c:f702:: with SMTP id v2mr22090193wmh.71.1593541996037;
        Tue, 30 Jun 2020 11:33:16 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 65sm4577917wre.6.2020.06.30.11.33.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Jun 2020 11:33:15 -0700 (PDT)
Subject: Re: [PATCH RFC net-next 05/13] net: phylink: update PCS when changing
 interface during resolution
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael@walle.cc" <michael@walle.cc>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20200630142754.GC1551@shell.armlinux.org.uk>
 <E1jqHFo-0006Ot-Ac@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4dca06f2-04f3-21c0-8b29-30fed2083d63@gmail.com>
Date:   Tue, 30 Jun 2020 11:33:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <E1jqHFo-0006Ot-Ac@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/30/2020 7:28 AM, Russell King wrote:
> The only PHYs that are used with phylink which change their interface
> are the BCM84881 and MV88X3310 family, both of which only change their
> interface modes on link-up events.  This will break when drivers are
> converted to split-PCS.  Fix this.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
