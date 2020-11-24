Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F1D22C2871
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:43:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388521AbgKXNla (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:41:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388391AbgKXNlU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 08:41:20 -0500
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D7DBC0613D6
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 05:41:20 -0800 (PST)
Received: by mail-qv1-xf41.google.com with SMTP id k3so3730198qvz.4
        for <netdev@vger.kernel.org>; Tue, 24 Nov 2020 05:41:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YoviBBFyANrwOg9lifdBVvXAimY5+Ia/96PbtU0D77E=;
        b=m6tdKQ5Zn1qYuqmNaDm5CWDzUaNwVBotbG0O/Ou7JGw/vhC6o2YsSdYFgMwu7dKtDQ
         WzMrTVFoNuavMTNQe6ShJ1utm7VEah7T9dbGZHPNaBZJjSgj738LC3ZVxNHvWCP0Czt3
         OVTqPL2H/+dC/EU/aNdT1gs3qltltFYyXpXLUDw9W9hCCDgUFZjUe9NNs/cbICqpTVll
         myvV+b7W3cwjZVHSRMXO8BDrZ4bLdjWesFrHS+vsyet+zud9AfgFqdsKJjXEk2DNjBqS
         6/VxmTwXGgv0dYXJEOrVkqWwg98Vd2SuPSpkZM118jBzg3k3Bz8L4uC2GwV60tXZtnjn
         uFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YoviBBFyANrwOg9lifdBVvXAimY5+Ia/96PbtU0D77E=;
        b=umTJ/c2YZVcJ66+d8gKCD3xs4oX9fJkwHoghZCgkkdKsr1qV+XOyFLEyYJIJihLOs+
         e2YkRUoc51ZmPlvdEqrfS4S2zqqoc+sVBmfjHexZDZ+Gs4pD4QJn2eIc1pRrwhbOsVbt
         i9WhvY2ixWUqwHpJCVnEaz8M1ZRnBSM++VM0vF/b367JlbI47XNNTsTvVJ2Ieh67CoVd
         gDXOasepmLdjxom88tDg8P7Ep7Qigku3j9Q0+C9MiKmWJhtM3161RrbtGy0grmgjNusI
         8YQlUTpjASrF/IvaQDI4imnA/EBi+NMPcyNHy9z10M/mQidTA0+KFLK7dz8wMR0XB5eC
         Y/Lw==
X-Gm-Message-State: AOAM530Odxiqk77MI99J5SrTH94B1Xl/vG22PUMTYMCZOSoVIoNvAPqt
        WNJsg2LJTqDzWs8oJOpAof7GddqrTrYLkg==
X-Google-Smtp-Source: ABdhPJxFppJkACzNTugUPNX5FlnuheE/l/Rd69oCQbFHegOT3XR8Y+eGlmA+RdxDJqhkbFi4NwOwCg==
X-Received: by 2002:a0c:b59a:: with SMTP id g26mr4674012qve.26.1606225279381;
        Tue, 24 Nov 2020 05:41:19 -0800 (PST)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id 5sm12642692qtp.55.2020.11.24.05.41.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2020 05:41:18 -0800 (PST)
Subject: Re: [PATCH iproute2-next v2] tc flower: use right ethertype in
 icmp/arp parsing
To:     Roi Dayan <roid@nvidia.com>, David Ahern <dsahern@gmail.com>,
        Zahari Doychev <zahari.doychev@linux.com>,
        netdev@vger.kernel.org
Cc:     simon.horman@netronome.com, jianbol@mellanox.com
References: <20201110075355.52075-1-zahari.doychev@linux.com>
 <c51abdae-6596-54ec-2b96-9b010c27cdb1@gmail.com>
 <3ae696c9-b4dd-a2e5-77d5-c572e98a4000@nvidia.com>
 <6bf5c24a-13bf-afbd-0b45-1488c09ecc56@nvidia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <7c8b77a9-f749-45ce-00d8-7695ac0f5855@mojatatu.com>
Date:   Tue, 24 Nov 2020 08:41:18 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <6bf5c24a-13bf-afbd-0b45-1488c09ecc56@nvidia.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-11-24 7:13 a.m., Roi Dayan wrote:
> 
> 
> On 2020-11-24 11:39 AM, Roi Dayan wrote:
>>
>>

[..]
>> Hi,
>>
>> I didn't debug yet but with this commit I am failing to add a tc
>> rule I always could before. also the error msg doesn't make sense.
>>
>> Example:
>>
>> # tc filter add dev enp8s0f0 protocol 802.1Q parent ffff: prio 1 flower\
>>   skip_hw dst_mac e4:11:22:11:4a:51 src_mac e4:11:22:11:4a:50\
>>   vlan_ethtype 0x800 vlan_id 100 vlan_prio 0 action vlan pop action\
>>   mirred egress redirect dev enp8s0f0_0
>>
>>
>> Can't set "vlan_id" if ethertype isn't 802.1Q or 802.1AD
>>
>>
>> I used protocol 802.1Q and vlan_ethtype 0x800.
>> am i missing something? the rule should look different now?
>>
>> Thanks,
>> Roi
> 
> 
> Hi,
> 
> I debugged this and it break vlan rules.
> The issue is from this part of the change
> 

We have a test for this in tdc. Maybe we should make it a rule to
run tdc tests on changes like these?

cheers,
jamal
