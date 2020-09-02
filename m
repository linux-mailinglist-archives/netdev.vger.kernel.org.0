Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7218125B517
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 22:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727019AbgIBUIv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 16:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726994AbgIBUIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 16:08:48 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E11C2C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 13:08:46 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id e16so724346wrm.2
        for <netdev@vger.kernel.org>; Wed, 02 Sep 2020 13:08:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=NOYrVgGI+B1Pc9ZOUVrhpgVGv95zQQBnLxcl/fTdh8k=;
        b=Ao3a5eYyzc0n+ykdiUDd9E659Nu5dgyuGmM6ecfVu3GVxJizcn5Pi+wnkW6O+Xs0Ti
         +AvTHSy0nRcBZMJsw7OdJKisLM78gYg1lY0Fvapb0r4+g+XYvMIAUI46XFInQ3KPXuSP
         WGVOUEamU878YETLWNW+dN2hLAfH/6aR5SBPQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NOYrVgGI+B1Pc9ZOUVrhpgVGv95zQQBnLxcl/fTdh8k=;
        b=sxV9se7owOlXD/5KUfxluh/pMcJlCdIIc2Z35wdAbmPhMY4D0f5jNxI6bq/8RM6GRn
         J93lEwYvQnvMrxPGnTE02SA9h/cRzClBBPLW4qc/nqZuvOzaAiHaegMZu4ifK/By5MZO
         BwyxAzgMLzXGuyMC0199GpVUcL6i8IghfhpisQ1ByVguefh5PLsxjlQTi1YFZSoNYz3D
         tKm0C4TEgq2eoWokptOAeWh1BsCo08qoyN1r/zNtZ0NtlgCNb4f5iB6k5iFKWi+Qe2Km
         XbwyxgUAaUuBwbeDl14Q9txl8C6wfKGlCMMzG/IvYg8IjiuL82MIZEC26Jdvf4tJ//bw
         jIEw==
X-Gm-Message-State: AOAM53174TdTyjtWJYM+M0segMbtalTAmEHviFDZbsaGK2+iLjMuMOQs
        9uWVS38O3bVQKi+c1xzO0GqUOw==
X-Google-Smtp-Source: ABdhPJyB6p3LLReZ9PE7qrNsVpMPImcyZxudbohNePE0M6AO5CTRJXZ4sfAz+5CmvXHFTUyAj627Yg==
X-Received: by 2002:adf:e583:: with SMTP id l3mr8576753wrm.72.1599077323559;
        Wed, 02 Sep 2020 13:08:43 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id c6sm1154210wrr.15.2020.09.02.13.08.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Sep 2020 13:08:42 -0700 (PDT)
Subject: Re: [PATCH net-next v2 00/15] net: bridge: mcast: initial IGMPv3
 support (part 1)
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, roopa@nvidia.com,
        bridge@lists.linux-foundation.org
References: <20200902112529.1570040-1-nikolay@cumulusnetworks.com>
 <20200902.125846.1328960907241014780.davem@davemloft.net>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <16ed8f8a-2040-5546-5cea-09a8a5b0bd7b@cumulusnetworks.com>
Date:   Wed, 2 Sep 2020 23:08:40 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200902.125846.1328960907241014780.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/2/20 10:58 PM, David Miller wrote:
> From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Date: Wed,  2 Sep 2020 14:25:14 +0300
> 
>> Here're the sets that will come next (in order):
>>   - Fast path patch-set which adds support for (S, G) mdb entries needed
>>     for IGMPv3 forwarding, entry add source (kernel, user-space etc)
>>     needed for IGMPv3 entry management, entry block mode needed for
>>     IGMPv3 exclude mode. This set will also add iproute2 support for
>>     manipulating and showing all the new state.
>>   - Selftests patch-set which will verify all IGMPv3 state transitions
>>     and forwarding
>>   - Explicit host tracking patch-set, needed for proper fast leave and
>>     with it fast leave will be enabled for IGMPv3
>>
>> Not implemented yet:
>>   - Host IGMPv3 support (currently we handle only join/leave as before)
>>   - Proper other querier source timer and value updates
>>   - IGMPv3/v2 compat (I have a few rough patches for this one)
> 
> What about ipv6 support?  The first thing I notice when reading these
> patches is the source filter code only supports ipv4.
> 

Indeed, these are IGMPv3/IPv4 targeted. But MLDv2 should be relatively easy to
add once we have all the set/state transitions as it uses the same.
Adding both at once would be a much bigger change.

Once all the infra (with fast-path) for IGMPv3 is in, MLDv2 should be a much
easier change, but I must admit given the amount of work this required I haven't
yet looked into MLDv2 in details. The majority of the changes would be just switch
protocol statements that take care of the IPv6 part.

I have also explicitly added the IPv4 checks right now to limit the dump code, otherwise
we'd get for example group mode export for IPv6 entries which yet don't support it.

If you'd prefer I can remove the explicit IPv4 checks and leave the switch protocol check
with ETH_P_IP only currently, but it wouldn't affect the end result much.



