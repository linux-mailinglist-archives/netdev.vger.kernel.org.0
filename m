Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3C93293B91
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 14:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405915AbgJTM3W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 08:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405874AbgJTM3W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 08:29:22 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7094CC061755
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 05:29:22 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id e6so1012111qtw.10
        for <netdev@vger.kernel.org>; Tue, 20 Oct 2020 05:29:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ZvPHT0dEDtbGHIRbQmpkcXqoCgsnP5j09cUfmOrFSpw=;
        b=gOQ343BSHVfrjmJ87ooSyrFgphgcVkznuZR12A4T31CrTagGid3qutBi1+HhBjKdpd
         qA2RrP7IyJixDMBRD1bvozVpiv9oJ6jicoTSLKxo2g0PsQ4TKzAoRHEs0LxvdzYqx2mC
         SYxZTNvqO7jWCeeORFEKHFyIiaaljMFKbV3d0ms+/8xQrcDIEW66QSGFPyhRd3klFvJW
         PfRxLu4Af/a/6W7YNH5GGwLhsOjGYfE93KVTjA2A6Oy2AKXHXWfwKtQoUXXupXhHrBHj
         +8h/etXffw9zU3jyLyGIgqXT7BB+9emmv77RsdJlm5gBQAAk/52DvSJbNJjlZplnd+xS
         XZqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZvPHT0dEDtbGHIRbQmpkcXqoCgsnP5j09cUfmOrFSpw=;
        b=Yyva0WS7+kr4L/uPSCXPRtXGKOgZ8OmOgFMBoiwQREt1cYb6RC4Wv86qLL8nsV0Gj/
         kLQsQ7pPFss1OPcLD3E6Nr1zwDmGc4cYZ0jVHH3Qh1ySQqSLkEZjIz7pzR3i3kZkeCUj
         wn36cGjp6lbAlQCI//JORsKMiBGI3CtVhNWLdD9vJI6Ktit9XGd0stcYJKbJqRZu1FZf
         mI2yarIOc/rxx7g4dkUU3VX8xQnTGUpJAwNI51zRoN8/YXkmUWG7smAKWvwurrkMdOR3
         fChEwn38CyONY7m/C4teqibY756XjbLEHUrxLxZ6EEttnyobnE7HeHFk5OuGZH5k/jKf
         zLog==
X-Gm-Message-State: AOAM531vsohVooKm4BWmcxOTjNWJXU9+fArHE5TZMJSg2YglTc01nqnu
        WiSw+DMVVlsr5U4mEj9BIybrFw==
X-Google-Smtp-Source: ABdhPJx1qid+RQKHetibelZa9xxg/hsvg3JvUF8SkFViBzZ5aI5gZKnUXfjhjggfI4qWPXU9TAqsEQ==
X-Received: by 2002:a05:622a:1d4:: with SMTP id t20mr2177666qtw.173.1603196961601;
        Tue, 20 Oct 2020 05:29:21 -0700 (PDT)
Received: from [192.168.2.28] (bras-base-kntaon1617w-grc-10-184-147-165-106.dsl.bell.ca. [184.147.165.106])
        by smtp.googlemail.com with ESMTPSA id m25sm669041qki.105.2020.10.20.05.29.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2020 05:29:20 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v3 2/2] tc: implement support for terse dump
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     Vlad Buslov <vladbu@nvidia.com>, dsahern@gmail.com,
        stephen@networkplumber.org, netdev@vger.kernel.org,
        davem@davemloft.net, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        ivecera@redhat.com, Vlad Buslov <vladbu@mellanox.com>
References: <20201016144205.21787-1-vladbu@nvidia.com>
 <20201016144205.21787-3-vladbu@nvidia.com>
 <0bb6f625-c987-03d7-7225-eee03345168e@mojatatu.com>
 <87a6wm15rz.fsf@buslov.dev>
 <ac25fd12-0ba9-47c2-25d7-7a6c01e94115@mojatatu.com>
 <877drn20h3.fsf@buslov.dev>
 <b8138715-8fd7-cbef-d220-76bdb8c52ba5@mojatatu.com>
 <87362a1byb.fsf@buslov.dev>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Message-ID: <5c79152f-1532-141a-b1d3-729fdd798b3f@mojatatu.com>
Date:   Tue, 20 Oct 2020 08:29:19 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <87362a1byb.fsf@buslov.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-10-19 11:18 a.m., Vlad Buslov wrote:
> 
> On Mon 19 Oct 2020 at 16:48, Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>> On 2020-10-18 8:16 a.m., Vlad Buslov wrote:

[..]

>> That could be a good thing, no? you get to see the action name with the
>> error. Its really not a big deal if you decide to do a->terse_print()
>> instead.
> 
> Maybe. Just saying that this change would also change user-visible
> iproute2 behavior.
> 

You are right(for the non-terse output). tbh, not sure if it is a big
deal given it happens only for the error case (where scripts look
for exit codes typically); having said that:
a ->terse_print() would be ok

> It is not a trivial change. To get this data we need to call
> tc_action_ops->dump() which puts bunch of other unrelated info in
> TCA_OPTIONS nested attr. This hurts both dump size and runtime
> performance. Even if we add another argument to dump "terse dump, print
> only index", index is still part of larger options structure which
> includes at least following fields:
> 
> #define tc_gen \
> 	__u32                 index; \
> 	__u32                 capab; \
> 	int                   action; \
> 	int                   refcnt; \
> 	int                   bindcnt
>


index is the _only_ important field for analytics purposes in that list.
i.e if i know the index i can correlate stats with one or more
filters (whether shared or not).
My worry is you have a very specific use case for your hardware or
maybe it is ovs - where counters are uniquely tied to filters and
there is no sharing. And possibly maybe only one counter can be tied
to a filter (was not sure if you could handle more than one action
in the terse from looking at the code).
Our assumptions so far had no such constraints.
Maybe a new TERSE_OPTIONS TLV, and then add an extra flag
to indicate interest in the tlv? Peharps store the stats in it as well.

> This wouldn't be much of a terse dump anymore. What prevents user that
> needs all action info from calling regular dump? It is not like terse
> dump substitutes it or somehow makes it harder to use.

Both scaling and correctness are important. You have the cookie
in the terse dump, thats a lot of data.
In our case we totally bypass filters to reduce the amount of data
crossing to user space (tc action ls). Theres still a lot of data
crossing which we could trim with a terse dump. All we are interested
in are stats. Another alternative is perhaps to introduce the index for
the direct dump.

cheers,
jamal
