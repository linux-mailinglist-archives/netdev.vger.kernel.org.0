Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B3BB15B19B
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 21:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgBLUNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 15:13:52 -0500
Received: from mail-wm1-f43.google.com ([209.85.128.43]:39361 "EHLO
        mail-wm1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727361AbgBLUNw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 15:13:52 -0500
Received: by mail-wm1-f43.google.com with SMTP id c84so4066226wme.4
        for <netdev@vger.kernel.org>; Wed, 12 Feb 2020 12:13:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=39ZNRUOeWlTyrkTgfwvaI8bMicW3LqYdUBIRb/zxRfU=;
        b=ZenIpIm9Q8V6l4ofyfSWobxzJe3xv0F5DQlmga1X7/8saTigl7394SxbZHj03uWojF
         VJ8xRFY7g/zlCFpLLd79aA6kigbAPqIhS9ze2/0MJuzvNAYfsVMMlSDdKcxP7Yla5RYW
         n/p0ahIkIqhDudpnCjMTbdzvlAj/KsHBLxdyqxmo+RcrF3HTKXwgihKepLUdSDNvRzxZ
         +8acT6gEubgGYkHNuc5u/lf1gvMGxsG77T5JNfLH/8kbjsxuXoFGdSWqYGugoAb7BdNj
         w70tJe6qKOEzzUZX3dXV8tHXW5AiTB5LvITUKcTNPqtO5+b5Gd6YQlgGRPnwyYKfxamj
         gGmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=39ZNRUOeWlTyrkTgfwvaI8bMicW3LqYdUBIRb/zxRfU=;
        b=C+WvsmHT2IWmZqzL0GufGXDz6fDE5CiWmDD10HkFSltJAiD+o8A2QYnz1+/3EK7ZN9
         iNxsNwZWIvJE1sPhqplgH1938VUWaYeNXOGdz7+gdnS0UVs84GJkxSyYCpgSrRi0EnJf
         CN4vG6k65bL3dYN0EftVp9c9Zv1+C/Fpwp3kvGqhlLocbul0bwIrgI5vB66RduoMhWtx
         B+nnJyoiWsDxjdyEVagO0o3rZuZVMRYtIuSKHoT3/FTHwcysscPRFSsLR+/6P6h6dvyk
         L523zp2uGoVQiAqkZeoI2r1leE/+7Kt7zR/OZAFcUff4nwg7VGytL8IEmFFQoM6LH1NS
         Jxww==
X-Gm-Message-State: APjAAAUr5aqWgiwH7tz57DyEianKCEfU4fRzMJGMm9J/AGblyPVlbdgy
        KZS+pnZvbl0o/xoOe3YBFclPqxrQ
X-Google-Smtp-Source: APXvYqxXbr9nfZswJ/NmN2pVEm0iltf+lThGm+Ujep1MXrNeAZ2LxWNqFt8MFVnVV96JK89JvdJCwQ==
X-Received: by 2002:a1c:1f56:: with SMTP id f83mr771246wmf.93.1581538430304;
        Wed, 12 Feb 2020 12:13:50 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:a02c:8004:c041:2ad1? (p200300EA8F296000A02C8004C0412AD1.dip0.t-ipconnect.de. [2003:ea:8f29:6000:a02c:8004:c041:2ad1])
        by smtp.googlemail.com with ESMTPSA id x10sm2016367wrp.58.2020.02.12.12.13.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Feb 2020 12:13:49 -0800 (PST)
Subject: Re: Question related to GSO6 checksum magic
To:     Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <29eb3035-1777-8b9a-c744-f2996fc5fae1@gmail.com>
 <142527b01cfab091b2715d093f75fc1c1c4aa939.camel@linux.intel.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <28d3a327-e065-cea2-52ae-708ec9a05057@gmail.com>
Date:   Wed, 12 Feb 2020 21:13:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
In-Reply-To: <142527b01cfab091b2715d093f75fc1c1c4aa939.camel@linux.intel.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11.02.2020 22:01, Alexander Duyck wrote:
> On Tue, 2020-02-11 at 20:48 +0100, Heiner Kallweit wrote:
>> Few network drivers like Intel e1000e or r8169 have the following in the
>> GSO6 tx path:
>>
>> ipv6_hdr(skb)->payload_len = 0;
>> tcp_hdr(skb)->check = ~csum_ipv6_magic(&ipv6_hdr(skb)->saddr,
>> 				       &ipv6_hdr(skb)->daddr,
>> 				       0, IPPROTO_TCP, 0);
>> (partially also w/o the payload_len assignment)
>>
>> This sounds like we should factor it out to a helper.
>> The code however leaves few questions to me, but I'm not familiar enough
>> with the net core low-level details to answer them:
>>
>> - This code is used in a number of drivers, so is it something that
>>   should be moved to the core? If yes, where would it belong to?
>>
>> - Is clearing payload_len needed? IOW, can it be a problem if drivers
>>   miss this?
>>
>> Thanks, Heiner
> 
> The hardware is expecting the TCP header to contain the partial checksum
> minus the length. It does this because it reuses the value when it
> computes the checksum for the header of outgoing TCP frames and it will
> add the payload length as it is segmenting the frames.
> 
Thanks, that helped a lot!

> An alternative approach would be to pull the original checksum value out
> and simply do the checksum math to subtract the length from it. If I am
> not mistaken there are some drivers that take that approach for some of
> the headers.
> 
> - Alex
> 
Heiner
