Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4603B35990F
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 11:23:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231756AbhDIJX5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 05:23:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230181AbhDIJX4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 05:23:56 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAC4C061760
        for <netdev@vger.kernel.org>; Fri,  9 Apr 2021 02:23:44 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id k128so2547346wmk.4
        for <netdev@vger.kernel.org>; Fri, 09 Apr 2021 02:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=CYGii3KpbI+wAidKrh1T1fkKg4KL4AvLPK+xCKFmuS4=;
        b=kyg8EbB4zCO1AVFluym+QpBfYqeP6xiPF5vwv24NrkWbuW0VaIObyuDDNbLpq0aiZC
         VCOk/NDZg8TKQ/Y60Lv3r+rMcc3K0epFWHf5DzL7wzHOIa3aaKzFc/hTwCdJ0eOpwuyb
         2DT3mAo9amQ3SaQwkAJ8K194NbwcW4rulhzxwMwgyt9YIwmRdec+xCPCV0gXd31CCGL8
         nVR1jUc2kgGKyPO9qzItj4YEZK5yEjWfzJddglgdAlthJhka6f6T03Qh/pka4QSK9n9K
         tp9DXOzbjh8OM60fea31PgIFcJlXNBsVEYq+WhLg43i1CpO3mmjGfk6nGnopxU/gbQMZ
         k8QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=CYGii3KpbI+wAidKrh1T1fkKg4KL4AvLPK+xCKFmuS4=;
        b=pFy6HSaEEdUPbxC2t3btZR7N1HNqy5Vp802eHPgcuqieKU4gITgv9HPYX17Xra0sTO
         oi5YH+OhznOXZVW2Jnldaqanp+/U1E2uH7Smlq8vfxI6ULgJL5QJbKnMHmvvzVp1hb2I
         OAB7Yc6bBvsQbmNjZNHuLJZj9jdbZLd1jPjlHQhfsRp0TtFMC25j6V69UDFa8vsAjnxo
         vxw1henfyVyUOltMvLlZ+tvoGAPBRXKe2Jp+hu3cNZ9e4EeVbXxxUbulTQtyGG7qjlNj
         L02UCvR0RdiFgQ0R7+8N0CzH05Lvba9shY5wDNfJOYYEta3kR8X/nU3eu89WoZ8ScKR0
         vUVA==
X-Gm-Message-State: AOAM531JbBLXaYOjUfX/OQWE9Ofv87cL6Yrat+fKKXZkIYCh/DEeRQJc
        EqQh9U5BVtW4xi19I4V7H+o=
X-Google-Smtp-Source: ABdhPJyfYVGtUOHEJ+xvB+FrtBKHN+sNO+wcFo4cOhKerAR3Ru6Tod76r95mizJb9M9sF154dV9fng==
X-Received: by 2002:a7b:c74e:: with SMTP id w14mr13003753wmk.88.1617960222726;
        Fri, 09 Apr 2021 02:23:42 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:61aa:4c4d:8bbf:6852? (p200300ea8f38460061aa4c4d8bbf6852.dip0.t-ipconnect.de. [2003:ea:8f38:4600:61aa:4c4d:8bbf:6852])
        by smtp.googlemail.com with ESMTPSA id l24sm3132372wmc.4.2021.04.09.02.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 02:23:42 -0700 (PDT)
Subject: Re: [PATCH net-next 0/3] net: make PHY PM ops a no-op if MAC driver
 manages PHY PM
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joakim Zhang <qiangqing.zhang@nxp.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>
References: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Message-ID: <dc45261a-403d-260c-fae6-1956f873ebbc@gmail.com>
Date:   Fri, 9 Apr 2021 11:23:33 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <9e695411-ab1d-34fe-8b90-3e8192ab84f6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07.04.2021 17:50, Heiner Kallweit wrote:
> Resume callback of the PHY driver is called after the one for the MAC
> driver. The PHY driver resume callback calls phy_init_hw(), and this is
> potentially problematic if the MAC driver calls phy_start() in its resume
> callback. One issue was reported with the fec driver and a KSZ8081 PHY
> which seems to become unstable if a soft reset is triggered during aneg.
> 
> The new flag allows MAC drivers to indicate that they take care of
> suspending/resuming the PHY. Then the MAC PM callbacks can handle
> any dependency between MAC and PHY PM.
> 
> Heiner Kallweit (3):
>   net: phy: make PHY PM ops a no-op if MAC driver manages PHY PM
>   net: fec: use mac-managed PHY PM
>   r8169: use mac-managed PHY PM
> 
>  drivers/net/ethernet/freescale/fec_main.c | 3 +++
>  drivers/net/ethernet/realtek/r8169_main.c | 3 +++
>  drivers/net/phy/phy_device.c              | 6 ++++++
>  include/linux/phy.h                       | 2 ++
>  4 files changed, 14 insertions(+)
> 

This series has status "Needs ACK". For which part an ACK is needed?

Regarding the fec driver:
The mail to Fugang, the current fec maintainer, bounced and Joakim
confirmed that he left NXP. Joakim will take over, see
https://patchwork.kernel.org/project/netdevbpf/patch/20210409091145.27488-1-qiangqing.zhang@nxp.com/
Joakim also tested the patch.

Heiner
