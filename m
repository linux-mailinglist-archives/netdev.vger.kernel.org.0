Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2498E31ADBB
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 20:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbhBMTSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Feb 2021 14:18:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229703AbhBMTSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Feb 2021 14:18:37 -0500
Received: from mail-io1-xd32.google.com (mail-io1-xd32.google.com [IPv6:2607:f8b0:4864:20::d32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84ED5C061574
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:17:56 -0800 (PST)
Received: by mail-io1-xd32.google.com with SMTP id q7so2813091iob.0
        for <netdev@vger.kernel.org>; Sat, 13 Feb 2021 11:17:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vVS3j2R7w0FiBro8DhNcUkwXjyzu/PTd9Kwt7Ig/Yu0=;
        b=YrtnhcmTmP3JOLfT6A9oE+71IhyfFPDpKdqnQlAGufEyepHbZgkHChttWj7OZP1MfT
         UHoAVT9RBhf0ldvKYw891Vaz3+Ob/+r5BKvXIC92HaBfVCHL4y2hBFYaD5Ef44LLWBUX
         I6M6PsrfmD5rzk6WH90Cj71m4gdUB+LpAMYv3sCgK2E5UXoIsvJ3ao39d8nZnNichzxt
         Rdc1z6yPb+97G7vCkzQ27OwmpbnGqaokYoOuOD+rH2+QTX5c+mpOdaUdiiXEWE63nAdQ
         N9vd7cnOhdXCLesoeXt38TD4P3PTSECASO3ctDww/h7Zwu9ivo6CMP6Gwg7VM8fT71b+
         CK3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vVS3j2R7w0FiBro8DhNcUkwXjyzu/PTd9Kwt7Ig/Yu0=;
        b=CFavhzr/VcHX0AXRE7WzScscYZXEx0AkuSW40oaiRV8879028mMDwyMfprF7ZWdMBT
         541YGfqg2y9G88at8u8YLsqFAuDCqJOrKVROGmcPJku2fMWk81J3xqXfcndzfLWBRYll
         znUFkEEa9RJUAZW/FdmwG9tQWb/hx1UUUjheQ8bvQM1nXy0p7uH2m7O9XB/T6k9e2z9w
         0Guz9SiMuYZegqxmvYo2hIpzSf3DB77W5ttgoRObIICTI0YLxcCOLjXAuVAWoXZ7rq8W
         GgUYpocYIhmRZz/9sNffQD2YnDcH6biTIr2qdp+a3Cjtu+VmOshtGKxNRYCsPpNXWCWG
         iiFQ==
X-Gm-Message-State: AOAM533OY7CmiyyiHEw+fK/jy3Zdpv0R4EwX/1s4jAvOCrejSZuASi0q
        b33CEku73LJH9rNVq+NUtEc=
X-Google-Smtp-Source: ABdhPJzeI2u9+WlcH678zC5dDOu0NXdyStIttI3DBiEhP/SQzSB/+NYWnpcD0SwjUKk3iGC1c/D8bA==
X-Received: by 2002:a5e:a813:: with SMTP id c19mr902675ioa.32.1613243876114;
        Sat, 13 Feb 2021 11:17:56 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.33])
        by smtp.googlemail.com with ESMTPSA id e1sm6110289iod.17.2021.02.13.11.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 Feb 2021 11:17:55 -0800 (PST)
Subject: Re: [RFC PATCH 00/13] nexthop: Resilient next-hop groups
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Petr Machata <petrm@nvidia.com>, netdev@vger.kernel.org,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ido Schimmel <idosch@nvidia.com>
References: <cover.1612815057.git.petrm@nvidia.com>
 <e15bfcec-7d1f-baea-6a9d-7bcc77104d8e@gmail.com>
 <20210213191619.GA399200@shredder.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ece022f-ec32-ab38-d2cf-a699c17bbcc7@gmail.com>
Date:   Sat, 13 Feb 2021 12:17:54 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210213191619.GA399200@shredder.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/13/21 12:16 PM, Ido Schimmel wrote:
> On Sat, Feb 13, 2021 at 11:57:03AM -0700, David Ahern wrote:
>> On 2/8/21 1:42 PM, Petr Machata wrote:
>>> To illustrate the usage, consider the following commands:
>>>
>>>  # ip nexthop add id 1 via 192.0.2.2 dev dummy1
>>>  # ip nexthop add id 2 via 192.0.2.3 dev dummy1
>>>  # ip nexthop add id 10 group 1/2 type resilient \
>>> 	buckets 8 idle_timer 60 unbalanced_timer 300
>>>
>>> The last command creates a resilient next hop group. It will have 8
>>> buckets, each bucket will be considered idle when no traffic hits it for at
>>> least 60 seconds, and if the table remains out of balance for 300 seconds,
>>> it will be forcefully brought into balance. (If not present in netlink
>>> message, the idle timer defaults to 120 seconds, and there is no unbalanced
>>> timer, meaning the group may remain unbalanced indefinitely.)
>>
>> How did you come up with the default timer of 120 seconds?
> 
> It is the default in the Cumulus Linux implementation (deployed for
> several years already), so we figured it should be OK.
> 

Add that to the commit log.
