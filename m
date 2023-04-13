Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 440C46E15AD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 22:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbjDMUNH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 16:13:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbjDMUNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 16:13:06 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C684C19
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:13:05 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a524c999d9so8708705ad.3
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 13:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1681416785; x=1684008785;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dUfV66Dz1Veckba/w78Nvkq1ZhRfFoOlu1lwzR3B1ME=;
        b=UJ0rkyzSfNLJs6f9jb62HBdj0Fn7Zq4KtRa4XAAneHHBZYm6/Jp3z3yhWezGGlr1g5
         wKY+7WPEUgUvQT/IK8Ov+7valzWR4YzjNQdcjtrxWhDpQIAsSOhoIi9488vaDYJzo8qD
         frUfqhXAX4PL7eoSF7C91912PLbvwsm27h1da+Z9adw2wfVQJ6E0/0b7iXTTtyXqj35N
         mN6SvkpeCPpLKd2SrLNM8WWoO1Kehdi+r9XFriU3xQTP3j+TkZWSqrb/QmPDrzvUDxf8
         LmhoK+OvM9knnMG+BodjrYgnVM7X+CbMCL/vFUUUtzw9Xu6JvruRoHZLhbcgEROVTUNm
         SSGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681416785; x=1684008785;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dUfV66Dz1Veckba/w78Nvkq1ZhRfFoOlu1lwzR3B1ME=;
        b=fvAn/Q/qFlPg/of+XURfGD8Vokt6gIudJWuFsn9K1jkEg2EnPs4NQpOhTfrJdE7weF
         Pt3bqyqFTHKmO9TQpu3ZdrloayY2kT78NcwCfwOY5Oto60TONebve7Hz5ERHkQFkX1rC
         RhF5RwPKjJdF6VDFob63zZCFey3zP9rH9TLho8skth1tFu/0bpwk6ipnFcl5xa2Z2Y13
         Vk/UFU6Pf8x0JuR9MAmDXTb1eQFwqT+8Q6WfcWiE6mwq+t2nTREd4pmN2mYVas5cmIU2
         U8x93LfwbAtOuN4266QcHPDq0oMEVcsNb1kjP1e+1h95qjmx4+KBQ/B0RieQxij6cWOq
         Qp/Q==
X-Gm-Message-State: AAQBX9eJYchR17u1ZXytW0XKIgFnrJLsJZVL93unjPYptEx8CJLZ7mIR
        ZPKx7l4jnEEaRnxA4lVf9BatRdPwACQP59yYYph8fA==
X-Google-Smtp-Source: AKy350aEjw677TIZRDB/xLGLWHCZypK9tKZFUp9B/3tZDlM1X382Ga/1i2VsG/SUPCcgwPkQch5OxQ==
X-Received: by 2002:a05:6a00:885:b0:62a:4503:53b8 with SMTP id q5-20020a056a00088500b0062a450353b8mr5374358pfj.1.1681416784895;
        Thu, 13 Apr 2023 13:13:04 -0700 (PDT)
Received: from [192.168.100.190] ([209.52.149.8])
        by smtp.gmail.com with ESMTPSA id g18-20020a62e312000000b0062622ae3648sm1762538pfh.78.2023.04.13.13.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 13 Apr 2023 13:13:04 -0700 (PDT)
Message-ID: <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
Date:   Thu, 13 Apr 2023 13:13:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: issues to bring up two VSC8531 PHYs
Content-Language: en-US
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
 <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
From:   Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2023-04-12 3:37 p.m., Heiner Kallweit wrote:
> On 13.04.2023 00:20, Andrew Lunn wrote:
>>>> Also, I hooked up a logic analyzer to the mdio lines and can see communications happening at boot time. Also, it appears that it's able to read the link status correctly (when a cable is plugged):
>>>> # mdio 11c20000.ethernet-ffffffff
>>>>   DEV      PHY-ID  LINK
>>>> 0x00  0x00070572  up
>>>>
>>> AFAICS there's no PHY driver yet for this model. The generic driver may or may not work.
>>> Best add a PHY driver.
>> Hi Heiner
>>
>> mscc.h:#define PHY_ID_VSC8531			  0x00070570
>>
>> mscc_main.c:
> OK, missed that. I just looked at the vitesse driver which also covers
> a number of VSCxxxx PHY's.
>
>>          .phy_id         = PHY_ID_VSC8531,
>>          .name           = "Microsemi VSC8531",
>>          .phy_id_mask    = 0xfffffff0,
>>          /* PHY_GBIT_FEATURES */
>>   
>>> Any specific reason why you set the compatible to
>>> ethernet-phy-ieee802.3-c45 for a c22 PHY?
Since the VSC8531 has a clause 45 register space, I assumed that it is a 
clause 45 PHY.
>> Ah, i missed that! The driver only uses phy_read/phy_write, not
>> phy_write_mmd() and phy_read_mmd().
>>
>> Remove the compatible string. It is not needed for C22 PHYs.

Anyways, I changed the patch specify "ethernet-phy-ieee802.3-c22" 
instead, it seems c22 is just a fallback if it's not specified per 
phy.txt - Documentation/devicetree/bindings/net/phy.txt - Linux source 
code (v4.14) - Bootlin 
<https://elixir.bootlin.com/linux/v4.14/source/Documentation/devicetree/bindings/net/phy.txt>


Okay, I tried it out, booted up and see my network interfaces:

# ifconfig
eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         ether f6:1f:f8:73:ce:f4  txqueuelen 1000  (Ethernet)
         RX packets 0  bytes 0 (0.0 B)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device interrupt 170

eth1: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         ether 7a:18:b6:23:bf:f6  txqueuelen 1000  (Ethernet)
         RX packets 0  bytes 0 (0.0 B)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device interrupt 173

lo: flags=73<UP,LOOPBACK,RUNNING>  mtu 65536  metric 1
         inet 127.0.0.1  netmask 255.0.0.0
         loop  txqueuelen 1000  (Local Loopback)
         RX packets 0  bytes 0 (0.0 B)
         RX errors 0  dropped 0  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0

I'm pumped!

This is a huge step forward, Thank you Heiner & Andrew!

I've set IPs manually (haven't dealt with DHCP yet) but am not able to 
transfer any data yet.
(tried pinging hosts in local network). Also IP doesn't appear to be 
visible on network. Pinging localhost or own IP works fine.

I connected it with a patch cable to a laptop and fired up tcpdump on 
the laptop.
I can see ARP requests going out (from the laptop) but VSC8531s are not 
responding (tried both ports).
What else can I do from here, is it time to probe the RGMII signals on 
the board?


Thanks!

-- 

Ron

