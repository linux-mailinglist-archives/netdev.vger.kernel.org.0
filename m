Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 251E76A219E
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 19:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbjBXSho (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 13:37:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBXShm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 13:37:42 -0500
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD5B6C53E
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:37:41 -0800 (PST)
Received: by mail-qv1-xf2d.google.com with SMTP id o3so93138qvr.1
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 10:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0wRFJ5oqVMFFV2t4PAxLQe2gdBYryrkUfjqvTleHdDY=;
        b=ZfMnUXK5e0M1BTbzkVvBiOD7JUTAai7ALslPNJJqsbYqIBwRJ70iob+lxwRrRDcwRs
         kESwuNyNnBkbG+aVFMP02tnqKOwP/c0mCJp8vqMHP9MFMpzZja/EdAf5CgJCLwbw6EmJ
         lA8k9CgQbDaaLrJEhaCKu7uyDieBydSrEAWzrljjhdNrzbJ/gymSrJzm2FIm2zv2pK0X
         oNdVc0DOi0UkybvFC3OEVFI6mOPTFHMzD6FkipcHlR2633FSRvNHecXESdg2mD8pkJ8K
         1rTqrtEqjirxOjZDbaoCnXrp6APqOD5LukIFGxOVsq5fBSqX4Xb9tIc8LWGCXP+bkqk0
         vOPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0wRFJ5oqVMFFV2t4PAxLQe2gdBYryrkUfjqvTleHdDY=;
        b=s2Fzlpj7pSRprDp40kp6c8PPd2p1Uj4CPQObyrDLv4fEdxgRMhzFgE2LshIKXt46rB
         foMKSzJns3UC2sN/YL9vLugtkOD/lvq0qO7fZZnkyTpwzYlK+xjBu/BEN8qYNFVlpld3
         P6wh4smU4ybTVkpyWaVDUfIMiJs3m0EjCP0sV3yQfthJ4DtkioYMGdbCVm4V3bSRghiq
         4bxZ3ITCX04ORJtywZYBLrDAsdXDUyZSiqKWa0iveaSWzajH+ZFT+4WIcniPMrFZcFFk
         Rq9uWHrr9IqIzKVQwlqaDLl9z4KsLGrfrLGG56kCRKwV1dP/jTNBTtihkAv7SEANDdcN
         Kdug==
X-Gm-Message-State: AO0yUKUyw6sXGk7mIqC+9pXf62qUhq7Y3n2CwmxkkKwGWP1BjfbOsInq
        iGXjN8b07hvNifbSvx/5OQ8=
X-Google-Smtp-Source: AK7set+/z9owqlJvOwsnexUodMibOdzxyEzpbGreWR9b9gSHAR0GUD95MU5RaD0DGcpyWeN1gJzdKQ==
X-Received: by 2002:a05:6214:d49:b0:56e:c00c:bf5c with SMTP id 9-20020a0562140d4900b0056ec00cbf5cmr33470178qvr.31.1677263860637;
        Fri, 24 Feb 2023 10:37:40 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g189-20020a37b6c6000000b00739f84a6c23sm6239449qkf.113.2023.02.24.10.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Feb 2023 10:37:40 -0800 (PST)
Message-ID: <413b0b3f-4afa-a99c-33b5-341278656415@gmail.com>
Date:   Fri, 24 Feb 2023 10:37:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net 1/3] net: dsa: seville: ignore mscc-miim read errors
 from Lynx PCS
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        UNGLinuxDriver@microchip.com, Andrew Lunn <andrew@lunn.ch>,
        Colin Foster <colin.foster@in-advantage.com>,
        Lee Jones <lee@kernel.org>,
        Maksim Kiselev <bigunclemax@gmail.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
References: <20230224155235.512695-1-vladimir.oltean@nxp.com>
 <20230224155235.512695-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230224155235.512695-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/24/23 07:52, Vladimir Oltean wrote:
> During the refactoring in the commit below, vsc9953_mdio_read() was
> replaced with mscc_miim_read(), which has one extra step: it checks for
> the MSCC_MIIM_DATA_ERROR bits before returning the result.
> 
> On T1040RDB, there are 8 QSGMII PCSes belonging to the switch, and they
> are organized in 2 groups. First group responds to MDIO addresses 4-7
> because QSGMIIACR1[MDEV_PORT] is 1, and the second group responds to
> MDIO addresses 8-11 because QSGMIIBCR1[MDEV_PORT] is 2. I have double
> checked that these values are correctly set in the SERDES, as well as
> PCCR1[QSGMA_CFG] and PCCR1[QSGMB_CFG] are both 0b01.
> 
> mscc_miim_read: phyad 8 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 8 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 8 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 8 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 9 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 9 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 9 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 9 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 10 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 10 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 10 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 10 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 11 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 11 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 11 reg 0x1 MIIM_DATA 0x2d
> mscc_miim_read: phyad 11 reg 0x5 MIIM_DATA 0x5801
> mscc_miim_read: phyad 4 reg 0x1 MIIM_DATA 0x3002d, ERROR
> mscc_miim_read: phyad 4 reg 0x5 MIIM_DATA 0x3da01, ERROR
> mscc_miim_read: phyad 5 reg 0x1 MIIM_DATA 0x3002d, ERROR
> mscc_miim_read: phyad 5 reg 0x5 MIIM_DATA 0x35801, ERROR
> mscc_miim_read: phyad 5 reg 0x1 MIIM_DATA 0x3002d, ERROR
> mscc_miim_read: phyad 5 reg 0x5 MIIM_DATA 0x35801, ERROR
> mscc_miim_read: phyad 6 reg 0x1 MIIM_DATA 0x3002d, ERROR
> mscc_miim_read: phyad 6 reg 0x5 MIIM_DATA 0x35801, ERROR
> mscc_miim_read: phyad 6 reg 0x1 MIIM_DATA 0x3002d, ERROR
> mscc_miim_read: phyad 6 reg 0x5 MIIM_DATA 0x35801, ERROR
> mscc_miim_read: phyad 7 reg 0x1 MIIM_DATA 0x3002d, ERROR
> mscc_miim_read: phyad 7 reg 0x5 MIIM_DATA 0x35801, ERROR
> mscc_miim_read: phyad 7 reg 0x1 MIIM_DATA 0x3002d, ERROR
> mscc_miim_read: phyad 7 reg 0x5 MIIM_DATA 0x35801, ERROR
> 
> As can be seen, the data in MIIM_DATA is still valid despite having the
> MSCC_MIIM_DATA_ERROR bits set. The driver as introduced in commit
> 84705fc16552 ("net: dsa: felix: introduce support for Seville VSC9953
> switch") was ignoring these bits, perhaps deliberately (although
> unbeknownst to me).
> 
> This is an old IP and the hardware team cannot seem to be able to help
> me track down a plausible reason for these failures. I'll keep
> investigating, but in the meantime, this is a direct regression which
> must be restored to a working state.
> 
> The only thing I can do is keep ignoring the errors as before.
> 
> Fixes: b99658452355 ("net: dsa: ocelot: felix: utilize shared mscc-miim driver for indirect MDIO access")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

