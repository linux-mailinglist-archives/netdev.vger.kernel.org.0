Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20A201E4A76
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 18:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbgE0QkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 12:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725613AbgE0QkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 12:40:13 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CA2FC05BD1E
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:40:12 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id x18so9202855pll.6
        for <netdev@vger.kernel.org>; Wed, 27 May 2020 09:40:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FqsRU4Vn3V5A4st1AodLDFwmDmt3vpdNCX50A/gRKLA=;
        b=KExyOdMxYGhA7k7YVVvg5atcmryUkbMZ/KyW0lGHo4SCKsOt9LVrThdVZsD+IsSmZR
         Ov95GYX+fo9oivudGnx3xySX73LIngZcvR88Ei2LxXuElz/4acwouiYbsf0XtkyNrdT3
         vLjkD0ZUXbnZIueqqz92yTN5T+0riLbMH9uf1shjAs/MrIT7VyW3ssD0lyFup91Pqcsw
         wn7TonNii2Vn0uJYu28UP0acYo0K/R/VYV5v8c/WWjHiig6gidWPxrGqvC7hwTvu+jan
         jIJ81oz/Xu6ZSptNKT4nMwLosw2kAIZpEoBYe8nSpo/3X3XNGQWlZ2Vc8LU5w92loclH
         CQLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FqsRU4Vn3V5A4st1AodLDFwmDmt3vpdNCX50A/gRKLA=;
        b=oyv8VzNtyF+Ftpf6CGEjP6Z6Vhgzpv2+ngxV1FqQFK/4+8A0lRwub8I4VZQnAPk3Gm
         rD1CpYs08+kfsJyoaMdqFnuRi5bgmxOMn31shd1mzR4XbDHYfftiWKG7h6+RN78USnwq
         0klmKUgjmgen/FLZD0Pnwtbufwe7ztrK6VICDR4IApvtnWHGjBETpobLLB2bHzKJAM8W
         4fQlUH+aNfbKMmT4ClpOFkCRx9ulVCUUY2hzLgjHV4XfqYeTbtq2KRhCVERWi+S4GzY1
         rVG1DTEXI8Bd7BsUzTCvvPntEA636ktclmk0PUThBJxfdnTxb9bErp9yhIJC5zRvYOne
         jk0w==
X-Gm-Message-State: AOAM532fXNoKvecqWxvCqhOj4wE0cp5UdLzZoQc3zTVwg1/M1j8B1QPm
        sEc1NacSkAskpthdj6kfQg7c9Gmr
X-Google-Smtp-Source: ABdhPJxzC+ZPg5XgL015uE3mjILNjtX+FrI8x7vVuUSXf0H6sfGg1McS6Ar7Tu+US+CKEEoEI9DY8Q==
X-Received: by 2002:a17:902:c213:: with SMTP id 19mr6698413pll.190.1590597611198;
        Wed, 27 May 2020 09:40:11 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n8sm3001176pjq.49.2020.05.27.09.40.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 May 2020 09:40:10 -0700 (PDT)
Subject: Re: [PATCH RFC v2 9/9] net: phy: read MMD ID from all present MMDs
To:     Russell King <rmk+kernel@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Jeremy Linton <jeremy.linton@arm.com>, netdev@vger.kernel.org
References: <20200527103318.GK1551@shell.armlinux.org.uk>
 <E1jdtOF-00084V-7R@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fb078299-4e50-68ae-fbfc-6a088ebf6126@gmail.com>
Date:   Wed, 27 May 2020 09:40:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <E1jdtOF-00084V-7R@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/27/2020 3:34 AM, Russell King wrote:
> Expand the device_ids[] array to allow all MMD IDs to be read rather
> than just the first 8 MMDs, but only read the ID if the MDIO_STAT2
> register reports that a device really is present here for these new
> devices to maintain compatibility with our current behaviour.
> 
> 88X3310 PHY vendor MMDs do are marked as present in the
> devices_in_package, but do not contain IEE 802.3 compatible register
> sets in their lower space.  This avoids reading incorrect values as MMD
> identifiers.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
