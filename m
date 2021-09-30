Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AA8A41D455
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 09:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348603AbhI3HSt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 03:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348531AbhI3HSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Sep 2021 03:18:48 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E084C06161C
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 00:17:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id v10so18480764edj.10
        for <netdev@vger.kernel.org>; Thu, 30 Sep 2021 00:17:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Lss9wdqf8YfolYvl46tx03H8/GnMKaur6IoNAd3Ska8=;
        b=6J/C36WaUt1JKFgDHnuGXn81R9fw25rUPYy3bM7ueFvGhER3C79XGFsKOhichuCrRI
         dX6MBg/jUoE5adnl/D5fzeutDfQ/+xpDsc0aUu2783hGBb2MWClsn3coPfBwzc0yRDvB
         G/OdIOK3ct9UmrVhNd2lf6nRgcFaonA8CeE1Zp6wZZavRdf5ezrpoCSj0ZmnDc0CoFpb
         S6YCXtZ8CACaZPv7It04fKFiVWkHuvRBwVN2Hlza2SBF7dBeiPzQjJqoLn1vYq6IR6U5
         BqoxFtSztce+TxrAWTsTeMoKQqlap0h/2Lwurrra0zJi4KXi3P3gOmWraITBZjWGOOpE
         dtcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Lss9wdqf8YfolYvl46tx03H8/GnMKaur6IoNAd3Ska8=;
        b=dKV+6rapJShB859Od7VipmJnBiMlcK3cPiWfMOdZaO3Jns/SSmV2ppfn9sT/JYpDRN
         8rec6UA5Kytf9l943p7f4uxH+aGVrMu56G5tfkb1LDjTES2dIDwHSSZphBW/ZA7sRFPb
         zhjhKV1tov8ontNtnkAr+BvQnMQ2r3/LBHQsITVnF4in9352zd38ijbDcPrhwiHBR1MH
         ayjZ7MBpm2bwS5UA/Otv9Jkm66yasDDSxCblIjQC9gqDrHlgfBxl4sc6SzIFBWPa4GyO
         x8mVXDSXtR6eOA8l+07xfC+4A75kick9NecLf8Hw9b3zHq95dBcNqUYGoktVCzxq+T0r
         1sNQ==
X-Gm-Message-State: AOAM5329WeoQZFzcfn7fM5XR4zWBFu9I1RVlJxJYEk9iCP9pcca6Z3mQ
        4b7G/adDUEGwrVxAFFCnS2TUTZjdpRcm9/+u
X-Google-Smtp-Source: ABdhPJwNAz2NzXOVGffFuZM+3qMUD49894cpYky+OE7akd0K8Mk9UIUqaPOf7lPKk6fm4Ev8wSIWqg==
X-Received: by 2002:a50:e188:: with SMTP id k8mr5394130edl.119.1632986224929;
        Thu, 30 Sep 2021 00:17:04 -0700 (PDT)
Received: from [192.168.0.111] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id h8sm1012191ejj.22.2021.09.30.00.17.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Sep 2021 00:17:04 -0700 (PDT)
Subject: Re: [RFC iproute2-next 00/11] ip: nexthop: cache nexthops and print
 routes' nh info
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     roopa@nvidia.com, donaldsharp72@gmail.com, idosch@idosch.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <20210929152848.1710552-1-razor@blackwall.org>
 <0ffec3e8-63ba-ce85-7a5a-d092420749df@gmail.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
Message-ID: <b700e57b-3687-9c36-c741-a25e423562ff@blackwall.org>
Date:   Thu, 30 Sep 2021 10:17:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <0ffec3e8-63ba-ce85-7a5a-d092420749df@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/09/2021 06:42, David Ahern wrote:
> On 9/29/21 9:28 AM, Nikolay Aleksandrov wrote:
>> From: Nikolay Aleksandrov <nikolay@nvidia.com>
>>
>> Hi,
>> This set tries to help with an old ask that we've had for some time
>> which is to print nexthop information while monitoring or dumping routes.
>> The core problem is that people cannot follow nexthop changes while
>> monitoring route changes, by the time they check the nexthop it could be
>> deleted or updated to something else. In order to help them out I've
>> added a nexthop cache which is populated (only used if -d / show_details
>> is specified) while decoding routes and kept up to date while monitoring.
>> The nexthop information is printed on its own line starting with the
>> "nh_info" attribute and its embedded inside it if printing JSON. To
>> cache the nexthop entries I parse them into structures, in order to
>> reuse most of the code the print helpers have been altered so they rely
>> on prepared structures. Nexthops are now always parsed into a structure,
>> even if they won't be cached, that structure is later used to print the
>> nexthop and destroyed if not going to be cached. New nexthops (not found
>> in the cache) are retrieved from the kernel using a private netlink
>> socket so they don't disrupt an ongoing dump, similar to how interfaces
>> are retrieved and cached.
>>
>> I have tested the set with the kernel forwarding selftests and also by
>> stressing it with nexthop create/update/delete in loops while monitoring.
>>
>> Comments are very welcome as usual. :)
> 
> overall it looks fine and not surprised a cache is needed.
> 
> Big comment is to re-order the patches - do all of the refactoring first
> to get the code where you need it and then add what is needed for the cache.
> 

Thanks for the comments, apart from pairing the add parse/use parse functions
in the first few patches only patch 08 seems out of place, although it's there
because it was first needed in patch 09, I don't mind pulling it back.
All other patches after 06 are adding the new cache and print functions and
using them in iproute/ipmonitor, there is no refactoring done in those, so I
plan to keep those as they are.

Cheers,
 Nik

