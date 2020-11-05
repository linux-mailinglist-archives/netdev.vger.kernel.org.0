Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C8092A8106
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 15:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730822AbgKEOfc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 09:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbgKEOfc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 09:35:32 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83B50C0613CF
        for <netdev@vger.kernel.org>; Thu,  5 Nov 2020 06:35:30 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id w14so2016525wrs.9
        for <netdev@vger.kernel.org>; Thu, 05 Nov 2020 06:35:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VdFlC44Jmv4HWHPM5u2hzrenpWay662TCfl0+UoCtbk=;
        b=B6Zuk3FfSgFvbHnhyyqdfNzuJagusEX70MzpgWeeK02zaQGyuL/UCq7kR1HfiC7zus
         TL6IzT9nOMDfEQ62Ay+U3q7eW1m5Q+nfFwfjOBmjgWopy0kzCO43JSp4F5Emui+s7Dwd
         aqyXvO63onyot2Qg6gvkhOdTBxx2stxrclO/vtu1oDvwNOg0QWj/H+ZlHqeugiziXNlP
         r0a4xDg3Sy5dXm9ayONsB+GV6O8Oekzt0E1Mnxzi2m5cLrKuQHWsilKgJ0kNQYmSyhBL
         Ec8ow/kJSWyM69YhG77HEXFtavNdz8ryiZOTDBQZVqw/QOjWeDjAaFJ+Jrejn61JZoxC
         favA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VdFlC44Jmv4HWHPM5u2hzrenpWay662TCfl0+UoCtbk=;
        b=ohVNUP1rspAiMdeIJM2XUJvwZy47+kwkgGDlGXXVIWmbXZPzEV1pbYAFPqACIUANgG
         nOdp1SdeKhzHrlYcFkiM76sgZfPcLRrlGe427+TRZ+mKfuIthcmr+E1AiF3CRDAvdpkq
         FWTzFM4AI0VbD6XCMDu1fShrI2dY3Q4O6mjV1OAHfc91ETVe+aCLUuEO1ofiklJVXyoV
         smohv772Dm64CGKVDtmSFhLLZfsiaSUfiDPHp5nPB6CZcTIcEhLhBV04Acy5jum+8lGW
         TxtkGDyVjEzDbu504gsXxs86LFRId1yo9XmIFR4non+w2PZfo9+bstwDKkALM37vQqoC
         ZPuQ==
X-Gm-Message-State: AOAM531UmZ2bKPLd8kvZ84GTUZ8an4wO9fn8hbVbrMbKyQADB7wNHc8p
        rdcryGJug58n0tmxf0QYDYnvBNznJKqPLQ==
X-Google-Smtp-Source: ABdhPJw1MifQ1QW6XyhnXYO56yG3bY8knoIb4vzMiaCzLwZbw8U2HZ/JDrqpKK/DF/cuaztGFs7Kog==
X-Received: by 2002:a5d:6287:: with SMTP id k7mr3301402wru.402.1604586929047;
        Thu, 05 Nov 2020 06:35:29 -0800 (PST)
Received: from ?IPv6:2003:ea:8f23:2800:59d0:7417:1e79:f522? (p200300ea8f23280059d074171e79f522.dip0.t-ipconnect.de. [2003:ea:8f23:2800:59d0:7417:1e79:f522])
        by smtp.googlemail.com with ESMTPSA id t13sm2994487wru.67.2020.11.05.06.35.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 06:35:28 -0800 (PST)
Subject: Re: [PATCH net] r8169: disable hw csum for short packets and chip
 versions with hw padding bug
To:     David Laight <David.Laight@ACULAB.COM>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <e82f7f4d-8d45-1e7c-a2ef-5a8bfc3992c6@gmail.com>
 <1a20cb5755db4916b873d88460ccf19e@AcuMS.aculab.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <da957ec8-a38b-f015-4a98-d8f78d2f018e@gmail.com>
Date:   Thu, 5 Nov 2020 15:35:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1a20cb5755db4916b873d88460ccf19e@AcuMS.aculab.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05.11.2020 15:20, David Laight wrote:
> From: Heiner Kallweit
>> Sent: 05 November 2020 13:58
>>
>> RTL8125B has same or similar short packet hw padding bug as RTL8168evl.
>> The main workaround has been extended accordingly, however we have to
>> disable also hw checksumming for short packets on affected new chip
>> versions. Change the code in a way that in case of further affected
>> chip versions we have to add them in one place only.
> 
> Why not just disable hw checksumming for short packets on
> all devices (that use this driver).
> 
Thanks for the hint. Briefly thought about that too but then decided
against it as I don't have performance figures. But if everybody is
fine with it, then I'd be happy to simplify short packet handling
in the described way (in a v2).

> It can't make much difference to the performance.
> The lack of conditionals may even make it faster.
> 
> 	David
> 
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1PT, UK
> Registration No: 1397386 (Wales)
> 

Heiner
