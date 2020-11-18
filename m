Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 005942B7367
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 01:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgKRAz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 19:55:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725767AbgKRAz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 19:55:59 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5941AC061A48
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:55:59 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s10so231221ioe.1
        for <netdev@vger.kernel.org>; Tue, 17 Nov 2020 16:55:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ylW5NCL0e3UPslTpW81msXlt2Wst0j2IjMvyDAEYjVQ=;
        b=d7v4P10CXz50DcNIa3HF2I/pQeT6Iim+38XL+OGNZTJm/oz/TjWpsvyGpo1ofVrnAb
         eU1rmP1qGDjMuuiBJ8ysNxMIw2U8nxVKSIuyJeZ5Xs3Hh69qc9dEmJ1sCtB4foM8A5Fz
         Lma6pVOiIAviFvFix69tI2bGISGS/LpbUxDfVQL5QdX5W1p+FBb4o4GMDJgL+nz2SLNQ
         sHimLfEd0kvT6/ZtWfFWjndmumbxIj/fwC8J2Xu7eQGKcbB3i/J8U/uaNZ0tcfgHdTRi
         O2MfAWuh4YcM3mCILgCTaZ94QLAVpgtEJD4bLRD3irMU7w5rNQcLV640/UJRVPZpL9DK
         Hp2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ylW5NCL0e3UPslTpW81msXlt2Wst0j2IjMvyDAEYjVQ=;
        b=EMKE2KDnaGJl29I3jAPptfkFPWUIOy2qPit1u24jZOMVgMcru6DXmbInybE8WAc7DP
         qGfd+ax1GRN+5Lw+25AVdJf0SJn1WCEf14Gu5xFoBLNRsJaDMFmNDbt4DbWs9Rteh1zm
         GjeGRTEdHL152iMoQSlAbrmyaU2sTFmFYM9inXV7V2XS9A0Vkx3dMTGznBzsBY3dbRh6
         wXCZSS+kZcWFxUxtnGERphUucazBRRHssl3fXkVOoicsNn+TtppiRkrNO2HRITuYk38w
         7d8H9v+K8r0d7PhXufiQ8l30wxfiRPtXFuyecez+hppWMOLtuJvaoFUJZR/3Dgf27UXA
         zRkA==
X-Gm-Message-State: AOAM5337/qMUxo+O7jJaz5a8jgWMwSbqAy1wBTt/gkyO/dw7kPVZ8xb9
        dloJFjIg+/ppEXN9hQE0wlg=
X-Google-Smtp-Source: ABdhPJxMzmtUUOn8rM0Hj+GbXwKbnxsv2vMcdtX9q3eX4RKotrTnKtIj89t+lWd110VRocRzFO8YzQ==
X-Received: by 2002:a02:ba90:: with SMTP id g16mr6154224jao.96.1605660958593;
        Tue, 17 Nov 2020 16:55:58 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:c472:ae53:db1e:5dd0])
        by smtp.googlemail.com with ESMTPSA id c8sm11693618ioq.40.2020.11.17.16.55.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2020 16:55:57 -0800 (PST)
Subject: Re: [PATCH] ipv4: use IS_ENABLED instead of ifdef
To:     Jakub Kicinski <kuba@kernel.org>, Florian Klink <flokli@flokli.de>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Kim Phillips <kim.phillips@arm.com>
References: <20201115224509.2020651-1-flokli@flokli.de>
 <20201117160110.42aa3b72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <5cbc79c3-0a66-8cfb-64f4-399aab525d09@gmail.com>
Date:   Tue, 17 Nov 2020 17:55:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201117160110.42aa3b72@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/17/20 5:01 PM, Jakub Kicinski wrote:
> On Sun, 15 Nov 2020 23:45:09 +0100 Florian Klink wrote:
>> Checking for ifdef CONFIG_x fails if CONFIG_x=m.
>>
>> Use IS_ENABLED instead, which is true for both built-ins and modules.
>>
>> Otherwise, a
>>> ip -4 route add 1.2.3.4/32 via inet6 fe80::2 dev eth1  
>> fails with the message "Error: IPv6 support not enabled in kernel." if
>> CONFIG_IPV6 is `m`.
>>
>> In the spirit of b8127113d01e53adba15b41aefd37b90ed83d631.
>>
>> Cc: Kim Phillips <kim.phillips@arm.com>
>> Signed-off-by: Florian Klink <flokli@flokli.de>
> 
> LGTM, this is the fixes tag right?
> 
> Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")

yep.

> 
> CCing David to give him a chance to ack.

Reviewed-by: David Ahern <dsahern@kernel.org>

I looked at this yesterday and got distracted diving into the generated
file to see the difference:

#define CONFIG_IPV6 1

vs

#define CONFIG_IPV6_MODULE 1
