Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A4CA6EB67B
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 02:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbjDVA2j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 20:28:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbjDVA2h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 20:28:37 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0A511FC8
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 17:28:35 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-63b64a32fd2so3773411b3a.2
        for <netdev@vger.kernel.org>; Fri, 21 Apr 2023 17:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mistywest-com.20221208.gappssmtp.com; s=20221208; t=1682123315; x=1684715315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=veilCORcRNSuKxm1iLp9ALxqsCd99IMppDQQT/hGk1w=;
        b=OK9g40i8cwTTey0FOQjhh2gGZPC81dP662fMQ4/XV9Uiff9SouZqL9Gw3ZVC8vGalL
         YWTkjZ/bU9QbVFuxBWJLWzRTk5qdIKT/bFIatFDkQa5Z1xC8eM7RIfmSVnhFQgh9icki
         x3++uy444bbV2WtOtBHEDyK3/RbubjZSMsNGbCRgYajO14RcWM9gB4/bv3vXiky7y8UK
         YAREPwGqU8Cdtp+AbjsofujjvTdHaE5lt9BnKJYTWvufivixlkY1al6RhCBzn2IyGyAd
         M80sFZ51plx5CTH1gx1l9LQTUfFxNctXmQMWnoQtxHBKZA4ltb60/RyqzCbhvq3NGpy6
         980g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682123315; x=1684715315;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=veilCORcRNSuKxm1iLp9ALxqsCd99IMppDQQT/hGk1w=;
        b=VBEF3GB24KuNadB7ue5l6xCKm7foxi9PM999xxEfp2OECHuWigPPFmEqn70Gas/T0Z
         9ImxxbdVo6vwg5I6Kmw0umlqmXa4IslaEzfrbWHmJxtgAwRJDfn7c0ScDPtC1+a+/8wf
         T1y22cLs3C+twmksD4z0Eq5/x6jlbl7NFIE4gmPbq9q5TQqAgG3OhKH8MAaoxqUmWmoS
         MCFZlqIOrwFGPqJ4TVzeSKhsnMQjEUrpppB97o4OzM6Z2ixUtnQMbkCTiQ59huH8Io2E
         sOmyDRXVNMf94W299My+Z8C0iadA8KeyYSMal3ZHD2AHQwd78yxb89PuH0/DR9N7U+Sp
         QRlg==
X-Gm-Message-State: AAQBX9dgLZ/F5qlPg18rKfsSRsjycI6WZulFlhj18wHWjgUIbV1K4cQb
        vHirakFPFbZGIRg5hv7TlBEBuw==
X-Google-Smtp-Source: AKy350ZXwg5hCaMZKxkpVP0aZngb3MSY6V2Rpd8FyP7KSgRH02EoFjn1iG3nG1LCHumX4HUbbNz0iQ==
X-Received: by 2002:a05:6a00:1a8b:b0:623:8592:75c4 with SMTP id e11-20020a056a001a8b00b00623859275c4mr8649660pfv.29.1682123315162;
        Fri, 21 Apr 2023 17:28:35 -0700 (PDT)
Received: from [192.168.1.222] (S01061c937c8195ad.vc.shawcable.net. [24.87.33.175])
        by smtp.gmail.com with ESMTPSA id s18-20020a056a00195200b0063b96574b8bsm3461300pfk.220.2023.04.21.17.28.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 17:28:34 -0700 (PDT)
Message-ID: <340234b8-91d3-3c1e-b985-9a2298b377aa@mistywest.com>
Date:   Fri, 21 Apr 2023 17:28:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: issues to bring up two VSC8531 PHYs
Content-Language: en-US
To:     Andrew Lunn <andrew@lunn.ch>
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
From:   Ron Eggler <ron.eggler@mistywest.com>
In-Reply-To: <7bb09c7c-24fc-4c8d-8068-f163082ab781@lunn.ch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/21/23 09:35, Andrew Lunn wrote:
>>> You can also try:
>>>
>>> ethtool --phy-statistics ethX
>> after appliaction of the above patch, ethtool tells me
>>
>> # ethtool --phy-statistics eth0
>> PHY statistics:
>>       phy_receive_errors: 65535
>>      phy_idle_errors: 255
> So these have saturated. Often these counters don't wrap, they stop at
> the maximum value.
>
> These errors also indicate your problem is probably not between the
> MAC and the PHY, but between the PHY and the RJ45 socket. Or maybe how
> the PHY is clocked. It might not have a stable clock, or the wrong
> clock frequency.

Oh and as for the clock, there's a 25MHz, +/- 20ppm  crystal hooked up 
to XTAL1 & XTAL2 pins which is a supported clock source (per datasheet) 
but I also see in the following:

For RGMII mode: Configure register 20E2 (to access register 20E2, 
register 31 must be set to 2).
Set bit 11 to 0 and set RX_CLK delay and TX_CLK delay accordingly 
through bit [6:4] and/or bit [2:0]
respectively.

I figured out that the register 20E2 is in the extended register space 
which is accessible when register 0x1F is set to 0x0002. I've been able 
to set and read it, I found a nice loop from David Creger that reads the 
complete register space and prints it to stdout:

# x=0; while  [ $x -le 31 ]; do printf  "Register 0x%02X = " $x ; 
phytool read eth0/0/$x  $(( x++ )) ; done
Register 0x00 = 0x1040
Register 0x01 = 0x796d
Register 0x02 = 0x0007
Register 0x03 = 0x0572
Register 0x04 = 0x0101
Register 0x05 = 0x45e1
Register 0x06 = 0x0005
Register 0x07 = 0x2801
Register 0x08 = 0000
Register 0x09 = 0x0200
Register 0x0A = 0x4000
Register 0x0B = 0000
Register 0x0C = 0000
Register 0x0D = 0000
Register 0x0E = 0000
Register 0x0F = 0x3000
Register 0x10 = 0x028e
Register 0x11 = 0x0100
Register 0x12 = 0x0800
Register 0x13 = 0000
Register 0x14 = 0000
Register 0x15 = 0000
Register 0x16 = 0000
Register 0x17 = 0000
Register 0x18 = 0000
Register 0x19 = 0000
Register 0x1A = 0000
Register 0x1B = 0x0ff0
Register 0x1C = 0000
Register 0x1D = 0000
Register 0x1E = 0x0030
Register 0x1F = 0x0002

and per the datasheet, the extended registers space maps into the above 
registers 16 - 30 like:

Address Name
16E2 Cu PMD Transmit Control
17E2 EEE Control
18E2–19E2 Reserved
20E2 RGMII Control
21E2 Wake-on-LAN MAC Address [15:0]
22E2 Wake-on-LAN MAC Address [31:16]
23E2 Wake-on-LAN MAC Address [47:32]
24E2 Secure-On Password [15:0]
25E2 Secure-On Password [31:16]
26E2 Secure-On Password [47:32]
27E2 Wake-on-LAN and MAC Interface Control
28E2 Extended Interrupt Mask
29E2 Extended Interrupt Status
30E2 Reserved

So per my calculations:

Register 0x10 = -> 16E2
Register 0x11 = -> 17E2
Register 0x12 = -> 18E2
Register 0x13 = -> 19E2
Register 0x14 = -> 20E2
Register 0x15 = -> 21E2
Register 0x16 = -> 22E2
Register 0x17 = -> 23E2
Register 0x18 = -> 24E2
Register 0x19 = -> 25E2
Register 0x1A = -> 26E2
Register 0x1B = -> 27E2
Register 0x1C = -> 28E2
Register 0x1D = -> 29E2
Register 0x1E = -> 30E2

20 (0x14) maps into 20E2 but I'm not fully certain what RX_CLK and 
TX_CLK should be set to, can anyone help me out, here?

datasheet: 
https://www.microchip.com/content/dam/mchp/documents/OTH/ProductDocuments/DataSheets/VMDS-10514.pdf

Also, should the above delay configuration not be part of the driver and 
configurable through the device tree?

https://www.kernel.org/doc/Documentation/devicetree/bindings/net/mscc-phy-vsc8531.txt

-- 
RON EGGLER Firmware Engineer (he/him/his) www.mistywest.com
