Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAF4625E8F6
	for <lists+netdev@lfdr.de>; Sat,  5 Sep 2020 18:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728297AbgIEQFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 12:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgIEQFM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Sep 2020 12:05:12 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E573C061244
        for <netdev@vger.kernel.org>; Sat,  5 Sep 2020 09:05:09 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l191so5890085pgd.5
        for <netdev@vger.kernel.org>; Sat, 05 Sep 2020 09:05:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mGQxHwPkyeSR3kmvGdR0tDF95/3/K90JLgf0mhS7PyM=;
        b=Qrgn3U3Ni2YW+7xcigcL0TbCycZyu4OOlRFfP8d9jTOHVAWqKiSflsZt4LWJWiVNK1
         N2m0f2wuMbgqGKD0VW0YVQnTQw9z+9blsm5Nvgdpp/dSpT22rCO83CGUSjYqTy6sQEhW
         7Rm7Fa/r4QPiUaXf2Djfy++5LDhNkpEbb5wiQoP/rhOTOPgIKKMIzaDGVXXBGQV7Mc+Y
         mb8rpKGQ6yATrmPhHBya7kIvF1CvrBmsY7PFe8XNdRsz0Gwg6U/Mez+j+oiPMcbvu7pa
         DUHkuAJA+7d/gofDB66QUmrPM8jFZe0zOe8g7lk513s5pZvXB4E5ut/uQjho1KsMKu5y
         BAdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mGQxHwPkyeSR3kmvGdR0tDF95/3/K90JLgf0mhS7PyM=;
        b=ktu/K+7vqKjXlttYoCisTI/He/00TIn9EJoB5I3ipEYlDMiSIejp2Hvp21jzQ/N/pk
         hova0b6K1BUF1Y2vc1Ezht2Cs8+Q7FmCfWyGEobG3HFPMgSPnSd7yY8xQqMYEH5gHNcR
         5RFkCumcryav95jJoqoqdSB+jVPAvOU6HXvoumQkicfgKHqZgY2ggTrSuBbbc4IEAq1r
         Decm1h26TEUnBTiX2gs0ck21Z9zfYHizls27vKppcfrbBTyujolk2jjdBJlIWJSdoYaz
         eO5eaM19WVxyMkKR/B6tU2uXkfG4R61eg/pDmXCtLDPaoNtmAETLoP84NwF4aH/rsLJo
         cWsQ==
X-Gm-Message-State: AOAM532xfCEigGwbx8M9MXEFxO4iLB+QAfL9JvCo+B2slKXbRhgqhALF
        LZ8CPv4hdEwUnQLXSdJQOKc2Q6AJFyQ=
X-Google-Smtp-Source: ABdhPJzdPbQ2rUHfHHVQ+Xvvhgh/fsEUyrgOws2n+MA02T7wKEgHYNMV51GG/bQyL70KOw/245ItDw==
X-Received: by 2002:a63:f44d:: with SMTP id p13mr11146161pgk.363.1599321906780;
        Sat, 05 Sep 2020 09:05:06 -0700 (PDT)
Received: from [10.230.30.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v91sm9028397pjv.12.2020.09.05.09.05.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2020 09:05:05 -0700 (PDT)
To:     Paul Barker <pbarker@konsulko.com>, Andrew Lunn <andrew@lunn.ch>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200905140325.108846-1-pbarker@konsulko.com>
 <20200905140325.108846-4-pbarker@konsulko.com>
 <20200905153238.GE3164319@lunn.ch>
 <CAM9ZRVs8e7hcS4T=Nt6M4iyDWA8uT42m=iRnYzQFg0ajL6rwTw@mail.gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 3/4] net: dsa: microchip: Disable RGMII in-band status on
 KSZ9893
Message-ID: <96496522-3ddd-f8b8-bbc0-63bd29637647@gmail.com>
Date:   Sat, 5 Sep 2020 09:04:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.2.1
MIME-Version: 1.0
In-Reply-To: <CAM9ZRVs8e7hcS4T=Nt6M4iyDWA8uT42m=iRnYzQFg0ajL6rwTw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/5/2020 8:53 AM, Paul Barker wrote:
> On Sat, 5 Sep 2020 at 16:32, Andrew Lunn <andrew@lunn.ch> wrote:
>>
>> On Sat, Sep 05, 2020 at 03:03:24PM +0100, Paul Barker wrote:
>>> We can't assume that the link partner supports the in-band status
>>> reporting which is enabled by default on the KSZ9893 when using RGMII
>>> for the upstream port.
>>
>> What do you mean by RGMII inband status reporting? SGMII/1000BaseX has
>> in band signalling, but RGMII?
>>
>>     Andrew
> 
> I'm referencing page 56 of the KSZ9893 datasheet
> (http://ww1.microchip.com/downloads/en/DeviceDoc/KSZ9893R-Data-Sheet-DS00002420D.pdf).
> The datasheet says "The RGMII port will not function properly if IBS
> is enabled in the switch, but it is not receiving in-band status from
> a connected PHY." Since we can't guarantee all possible link partners
> will support this it should be disabled. In particular, the IMX6 SoC
> we're using with this switch doesn't support this on its Ethernet
> port.

The RGMII 2.0 specification, pages 7 and 8 has more details:

http://web.archive.org/web/20160303171328/http://www.hp.com/rnd/pdfs/RGMIIv2_0_final_hp.pdf

and section 3.4.1 indicates that this is optional anyway for link 
status/speed/duplex.

It comes down to putting a appropriate data word on RXD[7:0] to signal 
link status, speed and speed, if the link partner does not provide the 
inter-frame word, then the receiver cannot reconstruct that information, 
or it will incorrectly decode it.

> 
> I don't really know much about how this is implemented or how widely
> it's supported.

It is supported by the Broadcom GENET adapter and probably a few others, 
however for the same reasons, I have not seen it being widely used. You 
would save two reads of BMSR to determine the link status which is nice, 
but link parameter changes are disruptive anyway.
-- 
Florian
