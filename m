Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B41A6EC302
	for <lists+netdev@lfdr.de>; Mon, 24 Apr 2023 00:53:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbjDWWxa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Apr 2023 18:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjDWWx2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Apr 2023 18:53:28 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3FF51702
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 15:53:14 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id d2e1a72fcca58-63d4595d60fso24042141b3a.0
        for <netdev@vger.kernel.org>; Sun, 23 Apr 2023 15:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682290394; x=1684882394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fHwNbkYjD+ypkCqANZwaqJi/1Ie+hSyzgeXLRJJskyw=;
        b=2s5NAYlSlw6dQnk8hBZLBWEBWdO3MKsYyVK0Z8DqUaPSsqEGJH7flc5wNVDMRYR6T6
         YJCv4TbqhOHwRhPNoHzJ/sgP0s7ztptecT0L51z1SUujkjcrOW3Cytqt6yc05Rmu0cHx
         adnM4H6TrATkLHCznw54KAzoodPwhM1mcuGxtbWl2xhJY5rNmUMXpbyDMlzA/igqNpYb
         Ki7ZF3Zny88cjBw4lYof6DjuASPGBBlk4dN7hWIDW7byK2IA6yc8kNdGkx1baoQEbelL
         Hq4TKWadH2NAYoYRzGWAW6oCCV3Pf6MRmITHqmmMecRwlbm5hEqAenq1ad5W7D+eeZMH
         4Gsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682290394; x=1684882394;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fHwNbkYjD+ypkCqANZwaqJi/1Ie+hSyzgeXLRJJskyw=;
        b=Z3J3/sruLv7a3NtUo/eAbYEhqiBhb/71VhbPra0jIUIBDfByn64/hwOUncjxwRUWx7
         4bBH/AsCsqgHNdkMgOdDpcGHM3681oFCZ26fI3GfmMy2uNFodrMHBIKfI7H4hoIr+3s0
         +3sDbGvGr9EOD9HUVYYAQTnRB5n8Uk2SdcFjRNr/aFf1LLg0T2/aR949+wp2sRuMgY3b
         aIwxay2PE9OepBz7lN6VaCDvbS1Syuzlp5hjOnAaE6LI3SKSsuI7S55GMGhqG+mhE60T
         JcLNnGntZze8yBAqA9d94cXoJb5S+IhVzdPDG7TnHy+Iu3uyXE5TC2Rckde4GbQDOg3J
         cVlQ==
X-Gm-Message-State: AAQBX9eMkKuByxLrPwHwfXDKydTp/KBJRIYy2HceIj44sCMArGDt/FfL
        tCnGhS8/ua7hbz4WjhIdnFkBtA==
X-Google-Smtp-Source: AKy350YY3b816x/MvKefrOUEauaHFzkbfpvm9FKCK/gc9rMA66X/ZYUpPOBnwV4IZopTS8oXcXYpVw==
X-Received: by 2002:a17:902:e80d:b0:1a6:46d7:77f0 with SMTP id u13-20020a170902e80d00b001a646d777f0mr20399416plg.0.1682290394371;
        Sun, 23 Apr 2023 15:53:14 -0700 (PDT)
Received: from [192.168.1.222] (S01061c937c8195ad.vc.shawcable.net. [24.87.33.175])
        by smtp.gmail.com with ESMTPSA id k91-20020a17090a14e400b0024bb5fb51fcsm790083pja.34.2023.04.23.15.53.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 23 Apr 2023 15:53:13 -0700 (PDT)
Message-ID: <06e3c69c-2792-66f1-13b4-ddc894787d09@mistywest.com>
Date:   Sun, 23 Apr 2023 15:53:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: issues to bring up two VSC8531 PHYs
Content-Language: en-US
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        Russell King - ARM Linux <linux@armlinux.org.uk>
References: <5eb810d7-6765-4de5-4eb0-ad0972bf640d@mistywest.com>
 <bb62e044-034e-771e-e3a9-a4b274e3dec9@gmail.com>
 <46e4d167-5c96-41a0-8823-a6a97a9fa45f@lunn.ch>
 <ba56f0a4-b8af-a478-7c1d-e6532144b820@gmail.com>
 <59fc6f98-0f67-f4a3-23c9-cd589aaa6af8@mistywest.com>
 <b3776edd-e337-44a4-8196-a6a94b498991@lunn.ch>
 <02b26c6f-f056-cec6-daf1-5e7736363d4e@mistywest.com>
 <7bb09c7c-24fc-4c8d-8068-f163082ab781@lunn.ch>
 <fa806e4a-b706-ce54-b3e0-b95d065e8d4a@mistywest.com>
 <e65a8575-8a76-4b09-c398-aee5272921a7@gmail.com>
From:   Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <e65a8575-8a76-4b09-c398-aee5272921a7@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 4/21/23 17:09, Florian Fainelli wrote:
>
>
> On 4/21/2023 3:55 PM, Ron Eggler wrote:
>>
>> On 4/21/23 09:35, Andrew Lunn wrote:
>>>>> You can also try:
>>>>>
>>>>> ethtool --phy-statistics ethX
>>>> after appliaction of the above patch, ethtool tells me
>>>>
>>>> # ethtool --phy-statistics eth0
>>>> PHY statistics:
>>>>       phy_receive_errors: 65535
>>>>      phy_idle_errors: 255
>>> So these have saturated. Often these counters don't wrap, they stop at
>>> the maximum value.
>>>
>>> These errors also indicate your problem is probably not between the
>>> MAC and the PHY, but between the PHY and the RJ45 socket. Or maybe how
>>> the PHY is clocked. It might not have a stable clock, or the wrong
>>> clock frequency.
>>
>> The man page 
>> (https://www.man7.org/linux/man-pages/man8/ethtool.8.html) does not 
>> give any details about what phy_receive_errors or phy_idle_errors 
>> refer to exactly, is there any documentation about it that I could 
>> not find?
>
> The statistics are inherently PHY specific and how a driver writer 
> choses to map a name to a specific PHY counter is backed within the 
> driver.
Thank you, I think I have moved past this now:
When I reboot, both RX & TX_CLK delay values are set to 0x0044 which 
equates 2.0ns delay and this actually lets me monitor traffic on the 
local network with tcpdump but still, my arp address doesn't go out and 
while my arp table gets populated, I'm not able to get any ping responses:
My interface in question:
# ifconfig eth0
eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         inet 192.168.1.123  netmask 255.255.255.0  broadcast 192.168.1.255
         ether 92:95:1c:76:8c:3e  txqueuelen 1000  (Ethernet)
         RX packets 94  bytes 22123 (21.6 KiB)
         RX errors 0  dropped 36  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device interrupt 170
arp table:
# arp
Address                  HWtype  HWaddress           Flags 
Mask            Iface
192.168.1.222            ether   54:04:a6:f3:19:db C                     
eth0
192.168.1.223            ether   68:ec:c5:ca:13:9f C                     
eth0
none of these hosts would reply to pings though but
# tcpdump -i eth0 ip
shows me traffic on the local network
the phy statistics now look like:
# ethtool --phy-statistics eth0
PHY statistics:
      phy_receive_errors: 0
      phy_false_carrier: 0
      phy_cu_media_link_disconnect: 0
      phy_cu_media_crc_good_count: 9667
      phy_cu_media_crc_error_count: 0
It appears like RX packets are getting dropped but interestingly the TX 
packets are showing 0 even though the ping command should send out some 
data:
# ifconfig eth0
eth0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500  metric 1
         inet 192.168.1.123  netmask 255.255.255.0  broadcast 192.168.1.255
         ether 92:95:1c:76:8c:3e  txqueuelen 1000  (Ethernet)
         RX packets 9885  bytes 2202753 (2.1 MiB)
         RX errors 0  dropped 3916  overruns 0  frame 0
         TX packets 0  bytes 0 (0.0 B)
         TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0
         device interrupt 170

what could be going on here and how can I trouble shoot this further?

Thank you!


-- 
RON EGGLER Firmware Engineer (he/him/his) www.mistywest.com
