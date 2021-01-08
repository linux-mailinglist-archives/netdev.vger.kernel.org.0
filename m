Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA3A2EF75B
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbhAHSaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:30:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727648AbhAHSap (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:30:45 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714CAC061381
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:30:05 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id p18so8124939pgm.11
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:30:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y9B1CUTxJPxHuqv7eXG4LFFxxWuUGMqoAm5SJGMN/s0=;
        b=BjxKtbc2zvJR5kR5tM/Opmc0OsNFRVoHi+JaeTDWX1X0EPP6+iGLhm6s4gz9AkQu6u
         Jz/u8dJwlMSsrgBoce7SwGBcG5Ncvv4Y9EEjOST0jpVuPKFHTaOofK1CnsTIgvpahcSs
         x6Wn96+x08rui102Rfed3HLq5Xxp/YSbMhCor9qvX7mgb+56gryYlnTT4Uu5IYrGdh5g
         mjua3UEGDaW/TrBPg1/I7lb5Rkt/SZcO2y/Ak+rV75oQdb1Z89Jomjt4OHHfupM0Tiip
         xAUWncKtHbR41j98JZPsBM9jAweTnsYzORUBUH/rKoQGsWdkw+L9mUHnhWQZ1qnoobee
         CJlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y9B1CUTxJPxHuqv7eXG4LFFxxWuUGMqoAm5SJGMN/s0=;
        b=IVKpdiX7//iXZrvt+RDrkR56LUcJlAHzOKtuEPkfxhIfC63yMkJ66qXiAvqeAxUjPi
         JsfFWN+qehDZK1cLjWvxw/5vODRnCmJA/dBi6bCDHwNHTSBR2xp6EcrN8V5txgiWIbuB
         AMEvv6FT4NKFF8JBxNp65bjbRuU1/KWgkdx76GFZdVZCwwC/6yd1lJGKdfpnZOYOLic9
         AH3CEcV84OqLzIuWxe8L0r98aduReFOSrvF7HZX6ODjWXO4BsTtGBoVgS1X456OU3g2c
         phT0NX2bdNeH0b5R2dw5csLIUTzK8r58BFCnpNMmwENChOSjIWiZT/OZuUTW2z7aUCWo
         oC8A==
X-Gm-Message-State: AOAM5333t4KDuKb1Ggn7gTu9PCm1CHrDT/7N+A3Aa+Au0j/8lufxq/LV
        1nt1DieBFQuFlqhUExbTWiA=
X-Google-Smtp-Source: ABdhPJxfGZJnTQfoBMtuCZFpoCFDHWxRsSH4u7bEJ1hhIF5lTys0B6XETaEbcx+3NgF4LLbZS0L7oQ==
X-Received: by 2002:a63:5a01:: with SMTP id o1mr8311323pgb.407.1610130604914;
        Fri, 08 Jan 2021 10:30:04 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m26sm9191431pfo.123.2021.01.08.10.30.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:30:04 -0800 (PST)
Subject: Re: [PATCH v3 net-next 01/10] net: mscc: ocelot: auto-detect packet
 buffer size and number of frame references
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-2-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <63ec3721-467f-dc21-03db-09f8d796f924@gmail.com>
Date:   Fri, 8 Jan 2021 10:30:00 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-2-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Instead of reading these values from the reference manual and writing
> them down into the driver, it appears that the hardware gives us the
> option of detecting them dynamically.
> 
> The number of frame references corresponds to what the reference manual
> notes, however it seems that the frame buffers are reported as slightly
> less than the books would indicate. On VSC9959 (Felix), the books say it
> should have 128KB of packet buffer, but the registers indicate only
> 129840 bytes (126.79 KB). Also, the unit of measurement for FREECNT from
> the documentation of all these devices is incorrect (taken from an older
> generation). This was confirmed by Younes Leroul from Microchip support.
> 
> Not having anything better to do with these values at the moment* (this
> will change soon), let's just print them.
> 
> *The frame buffer size is, in fact, used to calculate the tail dropping
> watermarks.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
