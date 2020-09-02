Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D0C25B53A
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726355AbgIBURy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:17:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgIBURw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:17:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DAD9C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 13:17:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z1so743135wrt.3
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 13:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fPEFL7gFVrhQrryf5xKV+LQS/a3qR13kbUD3/f6S7vw=;
        b=KbYeJzz+kSttAWyicoItZNefAfvT6b0JW3qCBF2yA4Y/8CL5Zb/k13bD4v7PCMaRKs
         ekT3jIFa+QXRBDZIc+nfU6ChJq9ZFwhUop4SAwI+pnOvoDhmt24ZQNuoFTWuUbsF/Vu9
         1YwoW+hVnAWxm2+/NU4UKcm/t7TBuASqK8TSQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fPEFL7gFVrhQrryf5xKV+LQS/a3qR13kbUD3/f6S7vw=;
        b=QoPc8Y48S0MFqm43ELmO+mPwV+nvGun7BmmOPPufx6u+tpguy6yiKJ/xN+BNFoQLml
         0DpaigWPMEIneKx5btEydw0hfFjzM9OXp9He2KP14agtAFI4m3zoLTZXNchpayRD4PmY
         L5Vz03adbyEg/tFcsceGv60lgXf58aJparWWWHRcnnk2re26Er2o3oo52m6yznswh/ja
         eeMi2INO2x9zxQb+rZxyj3sKKqI3fTyCpS/e7xbM/dx0SVU1GK8fLL1O/WMpm6QqbALi
         8q7Aqk/cSEPmmz8UE8bo2aWIqvbcfwGIl0g7l3zmkCEjric7yAln8ZafZFKdioAN6xDv
         C47Q==
X-Gm-Message-State: AOAM5339PQpBNPQgBQFx3TYMzgW4ASREGtys/DGXGfItcBPuNjYqLqI8
        YS7gofcssCmrjlbxbOBS5nXlIQ==
X-Google-Smtp-Source: ABdhPJwfyWwAtePZZ1qHCfdNTS3HFCuFdv6Dv8fe4p8RrRusZo5lka9ML2akf4WbQkiWQyfAigBJRA==
X-Received: by 2002:adf:f492:: with SMTP id l18mr4182372wro.280.1599077869907;
        Wed, 02 Sep 2020 13:17:49 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id 124sm1049125wmd.31.2020.09.02.13.17.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 13:17:49 -0700 (PDT)
Subject: Re: [PATCH net-next v2 00/15] net: bridge: mcast: initial IGMPv3
 support (part 1)
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
 <20200902.125846.1328960907241014780.davem@davemloft.net>
 <16ed8f8a-2040-5546-5cea-09a8a5b0bd7b@cumulusnetworks.com>
Message-ID: <22c022da-4b1d-b0fe-b701-ce2163b3c3c0@cumulusnetworks.com>
Date:   Wed, 2 Sep 2020 23:17:46 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <16ed8f8a-2040-5546-5cea-09a8a5b0bd7b@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 11:08 PM, Nikolay Aleksandrov wrote:
> On 9/2/20 10:58 PM, David Miller wrote:
>> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> Date: Wed,  2 Sep 2020 14:25:14 +0300
>>
>>> Here're the sets that will come next (in order):
>>>   - Fast path patch-set which adds support for (S, G) mdb entries needed
>>>     for IGMPv3 forwarding, entry add source (kernel, user-space etc)
>>>     needed for IGMPv3 entry management, entry block mode needed for
>>>     IGMPv3 exclude mode. This set will also add iproute2 support for
>>>     manipulating and showing all the new state.
>>>   - Selftests patch-set which will verify all IGMPv3 state transitions
>>>     and forwarding
>>>   - Explicit host tracking patch-set, needed for proper fast leave and
>>>     with it fast leave will be enabled for IGMPv3
>>>
>>> Not implemented yet:
>>>   - Host IGMPv3 support (currently we handle only join/leave as before)
>>>   - Proper other querier source timer and value updates
>>>   - IGMPv3/v2 compat (I have a few rough patches for this one)
>>
>> What about ipv6 support?  The first thing I notice when reading these
>> patches is the source filter code only supports ipv4.
>>
> 
> Indeed, these are IGMPv3/IPv4 targeted. But MLDv2 should be relatively easy to
> add once we have all the set/state transitions as it uses the same.
> Adding both at once would be a much bigger change.
> 
> Once all the infra (with fast-path) for IGMPv3 is in, MLDv2 should be a much
> easier change, but I must admit given the amount of work this required I haven't
> yet looked into MLDv2 in details. The majority of the changes would be just switch
> protocol statements that take care of the IPv6 part.
> 
> I have also explicitly added the IPv4 checks right now to limit the dump code, otherwise
> we'd get for example group mode export for IPv6 entries which yet don't support it.
> 
> If you'd prefer I can remove the explicit IPv4 checks and leave the switch protocol check
> with ETH_P_IP only currently, but it wouldn't affect the end result much.

i. e. this doesn't exclude IPv6 or makes it worse for it, on the contrary the ops needed to
implement MLDv2 state transitions are in this set, they just need to be extended for v6.
The new br_ip src group field contains also a field for an IPv6 address.


