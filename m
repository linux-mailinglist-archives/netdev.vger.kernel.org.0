Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0737A6E01F1
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 00:37:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbjDLWha (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Apr 2023 18:37:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjDLWh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Apr 2023 18:37:26 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 769BF8697
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:37:14 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id d8-20020a05600c3ac800b003ee6e324b19so7012369wms.1
        for <netdev@vger.kernel.org>; Wed, 12 Apr 2023 15:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681339033; x=1683931033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fPJ46w3PZ83R4nFUF61RtWI9mqrbxe0eMfBV7gN6wNM=;
        b=LLRMIVxgPiicGXm0M5yQqlpY/jpm3niMKkzwi/azU6Sk0JM7I6kMLY6CYPKYHZxS0j
         Dp5pMBkh/sSoMIbijXT2XDyzeu39tF65htnHQqJXd5G/0SO1372yHdWdhsqpSz9NBGyX
         5c1pbbjEdL8UJa3ArFXbkQyJV9r4TaPPx+EpPUEhqrx4wXfAbencGxAqIlLYm0yYBlVh
         trrOExeepx0A3Ii2fwTaAwnLpKmrQDNJ0p7pCiYgOJqQ2XGPecveVnKBrg+aaXaki1mn
         aStt/2Q3B1Juwr5+oS/GoWD8YQzNsLP4lGyRJecFFrC2pEzQ0HRCZxH7gxPGSFOtrPYy
         xvpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681339033; x=1683931033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fPJ46w3PZ83R4nFUF61RtWI9mqrbxe0eMfBV7gN6wNM=;
        b=Q37utfecsyWJ6FD4JrQo9czdatY3TXxgv/X56pkjE4YtpdQ8FJBoo7ixRMWfX0E1k5
         JB9nzBIoksI2cOFTKxYMpdKioRfynQVDzCyAfzaHgRpMosonz3wOG9z9OvvKBaSJKsb5
         F23jGDpTUL6kkeqX4tyvhOu6rQlQeoqiAZZC/Spe9lG47+ObVBI+xtA2pYmlbJaQJ1Lh
         5ld7x5aIHSFoOoTHMfEHexMdePzEEWB0MlVj8qO/LlopA0PLUBfQNC44izwChdsAs5vM
         GQt9rMCq0C8LjIHQEffNxPEKGzzhCG534EkEZhsY+BVHl2a4GZoYrRkeW6FQdM1Le0Rw
         VMQg==
X-Gm-Message-State: AAQBX9e1QK2mxj9IDIo4cDUdOV6vNuwpEDPkyUSTqDaBan+Ax6ZnGuKA
        /4oHvXIP4spVNpc/yS0V1GCjPVw2qv4=
X-Google-Smtp-Source: AKy350YzLpgg8czcMuRqWv2HfLbgnLwT95+ouo/26YgOHg3Q6NOjRyb/dZLE09N4/43BQwUP+2ZqnQ==
X-Received: by 2002:a05:600c:b8a:b0:3f0:7ec7:aa1 with SMTP id fl10-20020a05600c0b8a00b003f07ec70aa1mr3290597wmb.1.1681339032624;
        Wed, 12 Apr 2023 15:37:12 -0700 (PDT)
Received: from ?IPV6:2a02:3100:903d:3d00:b0e7:6bd7:f613:784b? (dynamic-2a02-3100-903d-3d00-b0e7-6bd7-f613-784b.310.pool.telefonica.de. [2a02:3100:903d:3d00:b0e7:6bd7:f613:784b])
        by smtp.googlemail.com with ESMTPSA id u15-20020a05600c19cf00b003ede3f5c81fsm3785393wmq.41.2023.04.12.15.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 15:37:12 -0700 (PDT)
Message-ID: <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
Date:   Thu, 13 Apr 2023 00:37:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: issues to bring up two VSC8531 PHYs
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Ron Eggler <ron.eggler@mistywest.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
Content-Language: en-US
From:   Heiner Kallweit <hkallweit1@gmail.com>
In-Reply-To: <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13.04.2023 00:20, Andrew Lunn wrote:
>>> Also, I hooked up a logic analyzer to the mdio lines and can see communications happening at boot time. Also, it appears that it's able to read the link status correctly (when a cable is plugged):
>>> # mdio 11c20000.ethernet-ffffffff
>>>  DEV      PHY-ID  LINK
>>> 0x00  0x00070572  up
>>>
>> AFAICS there's no PHY driver yet for this model. The generic driver may or may not work.
>> Best add a PHY driver.
> 
> Hi Heiner
> 
> mscc.h:#define PHY_ID_VSC8531			  0x00070570
> 
> mscc_main.c:

OK, missed that. I just looked at the vitesse driver which also covers
a number of VSCxxxx PHY's.

>         .phy_id         = PHY_ID_VSC8531,
>         .name           = "Microsemi VSC8531",
>         .phy_id_mask    = 0xfffffff0,
>         /* PHY_GBIT_FEATURES */
>  
>> Any specific reason why you set the compatible to
>> ethernet-phy-ieee802.3-c45 for a c22 PHY?
> 
> Ah, i missed that! The driver only uses phy_read/phy_write, not
> phy_write_mmd() and phy_read_mmd().
> 
> Remove the compatible string. It is not needed for C22 PHYs.
> 
>        Andrew

