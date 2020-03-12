Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9431182676
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 02:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387552AbgCLBBm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 21:01:42 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:36593 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387480AbgCLBBm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 21:01:42 -0400
Received: by mail-pl1-f195.google.com with SMTP id g12so1927655plo.3
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 18:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gJO+EgRp9xjkvuCYX2PFs4u1o4XVT8ml4D13osg99kU=;
        b=YVkmwMQ3/gEUFyfHEytNLeAlYa2FPkgQJSIfAkF3mhONASN3wMOzIMlWiqRCbtHBSG
         wfhdEdUilBKTNrjFHg6gCL80M9HxC4JdLaSKQPWb8EzzCScREos5Nj/RlD1Tp+RgSZ/a
         qxpaYLyCwUBBkdGlw6pL59CaSSzZFcjIaAnv+I2cuEaZwZY1iPZJL2rivvvEZHxRX3Zn
         L2eoGTRHj3s3eT3lV3WG9pS7QRWaN9G0sTaWu+l6oL+y7TrOqxS4A00EJaX+7Wp/sJNG
         2MVXh01qKkjgERSKqF028DsE3icnR3nGE9Z5waiaAWixXe3k88TXNnD2RzkoLHX+ZszY
         dTjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gJO+EgRp9xjkvuCYX2PFs4u1o4XVT8ml4D13osg99kU=;
        b=qY0sQcZAUdiSeneJV5hmrd/SBCOLPilM/xe8U5Lycjq77t/x5w+cpQ6Tq3t8ZcF2/O
         9IDHqqpX2D4Wm+1PBf3QsKdQa8Ye6oa1yV4me63ksUXp53dLnfVimV2vj9dK/63nxEOB
         TH2UOKmamueRunnbQQWup2dfqSpDVxg3gkQUigr4kB2+5OafrRUGCTXM5yHamdOxeUOy
         jV8QJjrUwNCRJKgP8wbcK7q/k4nGd32NbZyM8On/TgjVEvh6PFOIrZkTUxbJOs1iMrJ6
         QQT19NcKWX+7crpIHtBVpehW/KzN9EBBtzD4Ee51xz+iQ082uP0XEm1krRGI8hm7hB4L
         hB6A==
X-Gm-Message-State: ANhLgQ1T2ctMWcthgawzdzVBaBSeRmjLZa+iSb2yOU2d8EkCco7jOILF
        zSbMDUWBHJYc1deFyplpIic=
X-Google-Smtp-Source: ADFU+vtTMs9gM92i5dFEjhZo+iN00B8hRNLIyWWZbxiqcIf1zKD41SWJwlRVviZjqbqCSKYh9DsqmA==
X-Received: by 2002:a17:902:a715:: with SMTP id w21mr5513515plq.244.1583974900786;
        Wed, 11 Mar 2020 18:01:40 -0700 (PDT)
Received: from [192.168.86.235] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id q187sm52148283pfq.185.2020.03.11.18.01.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Mar 2020 18:01:40 -0700 (PDT)
Subject: Re: [PATCH net-next v2 3/6] net: sched: RED: Introduce an ECN
 tail-dropping mode
To:     Petr Machata <petrm@mellanox.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
References: <20200311173356.38181-1-petrm@mellanox.com>
 <20200311173356.38181-4-petrm@mellanox.com>
 <2629782f-24e7-bf34-6251-ab0afe22ff03@gmail.com>
 <87imjaxv23.fsf@mellanox.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <7a7038ca-2f6f-30f6-e168-6a3510db0db7@gmail.com>
Date:   Wed, 11 Mar 2020 18:01:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <87imjaxv23.fsf@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/11/20 5:42 PM, Petr Machata wrote:
> 
> Eric Dumazet <eric.dumazet@gmail.com> writes:
> 
>> On 3/11/20 10:33 AM, Petr Machata wrote:
>>> When the RED Qdisc is currently configured to enable ECN, the RED algorithm
>>> is used to decide whether a certain SKB should be marked. If that SKB is
>>> not ECN-capable, it is early-dropped.
>>>
>>> It is also possible to keep all traffic in the queue, and just mark the
>>> ECN-capable subset of it, as appropriate under the RED algorithm. Some
>>> switches support this mode, and some installations make use of it.
>>>
>>> To that end, add a new RED flag, TC_RED_TAILDROP. When the Qdisc is
>>> configured with this flag, non-ECT traffic is enqueued (and tail-dropped
>>> when the queue size is exhausted) instead of being early-dropped.
>>>
>>
>> I find the naming of the feature very confusing.
>>
>> When enabling this new feature, we no longer drop packets
>> that could not be CE marked.
>> Tail drop is already in the packet scheduler, you want to disable it.
>>
>>
>> How this feature has been named elsewhere ???
>> (you mentioned in your cover letter :
>> "Some switches support this mode, and some installations make use of it.")
> 
> The two interfaces that I know about are Juniper and Cumulus. I don't
> know either from direct experience, but from the manual, Cumulus seems
> to allow enablement of either ECN on its own[0], or ECN with RED[1]. (Or
> RED on its own I presume, but I couldn't actually find that.)
> 
> In Juniper likewise, "on ECN-enabled queues, the switch [...] uses the
> tail-drop algorithm to drop non-ECN-capable packets during periods of
> congestion"[2]. You need to direct non-ECT traffic to a different queue
> and configure RED on that to get the RED+ECN behavior ala Linux.
> 
> So this is unlike the RED qdisc, where RED is implied, and needs to be
> turned off again by an anti-RED flag. The logic behind the chosen flag
> name is that the opposite of early dropping is tail dropping. Note that
> Juniper actually calls it that as well.
> 
> That said, I agree that from the perspective of the qdisc itself the
> name does not make sense. We can make it "nodrop", or "nored", or maybe
> "keep_non_ect"... I guess "nored" is closest to the desired effect.

Well, red algo is still used to decide if we attempt ECN marking, so "nodrop"
seems better to me :)

> 
> [0] https://docs.cumulusnetworks.com/cumulus-linux-40/Layer-1-and-Switch-Ports/Buffer-and-Queue-Management/
> [1] https://docs.cumulusnetworks.com/version/cumulus-linux-37/Network-Solutions/RDMA-over-Converged-Ethernet-RoCE/
> [2] https://www.juniper.net/documentation/en_US/junos/topics/concept/cos-qfx-series-tail-drop-understanding.html
> 
