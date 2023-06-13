Return-Path: <netdev+bounces-10295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DC30B72DA16
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 08:47:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 240FE1C20C25
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 06:47:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351801844;
	Tue, 13 Jun 2023 06:46:48 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A45B3C27
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 06:46:48 +0000 (UTC)
Received: from mail-ot1-x331.google.com (mail-ot1-x331.google.com [IPv6:2607:f8b0:4864:20::331])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 404BE10D5
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 23:46:46 -0700 (PDT)
Received: by mail-ot1-x331.google.com with SMTP id 46e09a7af769-6b160f3f384so3047344a34.3
        for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 23:46:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1686638805; x=1689230805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NHNXSDSAPdGJpNANCbsAPKFp2yaEgGD+KFXl6OMicdU=;
        b=N3xIpdGJflW3eOUqyzlLAk5abO21PLtlV9Mx6Umc9Y1/aUS6ZbK6xRXRwrBlCl8Hpt
         c4VFcfT/4bTwUNGcVg175+fbr1PAChggD6uVFx3lHagvhox0mUPosWozHs3j411OtiIg
         q1Z9LwzcFS02JAqJpGtU1gtlg9MoyXwZnR3qtAhSBZqlvB3neANc61YpQBDp8CqDL8LB
         zEmXHHS2jlaLBD/YUj1zWpzLM2mP/B13pd8pD5UXNt67O89fC37Inmaq9CEiTcuxvhdX
         fHhNFtYe96lllaquqJtuXVScNXSyTJXbWF6oVsGptmNDOdfS0LS+Pg89wOXHPW1dV3a+
         flmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686638805; x=1689230805;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NHNXSDSAPdGJpNANCbsAPKFp2yaEgGD+KFXl6OMicdU=;
        b=DRI4378tXofuPRVXeBLH/WoWXVVjxc5IlsaZ2sDBsq/Lo5jXuu1EqVcCx8v4beRNfZ
         V2LA+hghQQL7islxLEPzMp4pNxNsu2hE54FhKUYlHmfdIPI594Jry+Gy0b/Rt4CFnGj+
         jyqBCholHTMs0BL4m+C5NaO/Cf9RGQbaoO/wzRnbZjJWyAk4kKCvLpb5RZg4fXmHzM4c
         LeAvA/AeF7nw3E6tzKNSJMYuKEPF8QaE1AEV/owj/X2XrJbp+vV7ft6YPwfORj/vtKva
         xnUol1/65w19I1JvDnbgIl9gQQ3nskJJiwsQSFZ1EWRmswdjkQgxeKnjhf8CQ6kx7M61
         ybOQ==
X-Gm-Message-State: AC+VfDygsPe5zmybDqNNMerFtdarSggyHzPJNqRnlah0olU9/roKWlos
	Na0D5x7lCndVdDM++MDyxIZWJg==
X-Google-Smtp-Source: ACHHUZ5yWwpRuqEtXXDwbA/oYjDxwnLkcpw00/aVzdZTCGVeM5RWwjUvOUXKhz+EyFWvMpgm+Xdikw==
X-Received: by 2002:a05:6358:f1e:b0:129:94e6:7069 with SMTP id b30-20020a0563580f1e00b0012994e67069mr5181771rwj.0.1686638805446;
        Mon, 12 Jun 2023 23:46:45 -0700 (PDT)
Received: from [10.254.80.225] ([139.177.225.255])
        by smtp.gmail.com with ESMTPSA id 17-20020a630011000000b00542d7720a6fsm8736801pga.88.2023.06.12.23.46.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 23:46:44 -0700 (PDT)
Message-ID: <b879d810-132b-38ab-c13d-30fabdc8954a@bytedance.com>
Date: Tue, 13 Jun 2023 14:46:32 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.11.2
Subject: Re: Re: [RFC PATCH net-next] sock: Propose socket.urgent for sockmem
 isolation
Content-Language: en-US
To: Eric Dumazet <edumazet@google.com>
Cc: Tejun Heo <tj@kernel.org>, Christian Warloe <cwarloe@google.com>,
 Wei Wang <weiwan@google.com>, "David S. Miller" <davem@davemloft.net>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>,
 Yosry Ahmed <yosryahmed@google.com>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao
 <yuzhao@google.com>, Vasily Averin <vasily.averin@linux.dev>,
 Kuniyuki Iwashima <kuniyu@amazon.com>,
 Martin KaFai Lau <martin.lau@kernel.org>, Xin Long <lucien.xin@gmail.com>,
 Jason Xing <kernelxing@tencent.com>, Michal Hocko <mhocko@suse.com>,
 Alexei Starovoitov <ast@kernel.org>, open list
 <linux-kernel@vger.kernel.org>,
 "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <cgroups@vger.kernel.org>,
 "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)"
 <linux-mm@kvack.org>
References: <20230609082712.34889-1-wuyun.abel@bytedance.com>
 <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
From: Abel Wu <wuyun.abel@bytedance.com>
In-Reply-To: <CANn89i+Qqq5nV0oRLh_KEHRV6VmSbS5PsSvayVHBi52FbB=sKA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On 6/9/23 5:07 PM, Eric Dumazet wrote:
> On Fri, Jun 9, 2023 at 10:28 AM Abel Wu <wuyun.abel@bytedance.com> wrote:
>>
>> This is just a PoC patch intended to resume the discussion about
>> tcpmem isolation opened by Google in LPC'22 [1].
>>
>> We are facing the same problem that the global shared threshold can
>> cause isolation issues. Low priority jobs can hog TCP memory and
>> adversely impact higher priority jobs. What's worse is that these
>> low priority jobs usually have smaller cpu weights leading to poor
>> ability to consume rx data.
>>
>> To tackle this problem, an interface for non-root cgroup memory
>> controller named 'socket.urgent' is proposed. It determines whether
>> the sockets of this cgroup and its descendants can escape from the
>> constrains or not under global socket memory pressure.
>>
>> The 'urgent' semantics will not take effect under memcg pressure in
>> order to protect against worse memstalls, thus will be the same as
>> before without this patch.
>>
>> This proposal doesn't remove protocal's threshold as we found it
>> useful in restraining memory defragment. As aforementioned the low
>> priority jobs can hog lots of memory, which is unreclaimable and
>> unmovable, for some time due to small cpu weight.
>>
>> So in practice we allow high priority jobs with net-memcg accounting
>> enabled to escape the global constrains if the net-memcg itselt is
>> not under pressure. While for lower priority jobs, the budget will
>> be tightened as the memory usage of 'urgent' jobs increases. In this
>> way we can finally achieve:
>>
>>    - Important jobs won't be priority inversed by the background
>>      jobs in terms of socket memory pressure/limit.
>>
>>    - Global constrains are still effective, but only on non-urgent
>>      jobs, useful for admins on policy decision on defrag.
>>
>> Comments/Ideas are welcomed, thanks!
>>
> 
> This seems to go in a complete opposite direction than memcg promises.
> 
> Can we fix memcg, so that :
> 
> Each group can use the memory it was provisioned (this includes TCP buffers)

Yes, but might not be easy once memory gets over-committed (which is
common in modern data-centers). So as a tradeoff, we intend to put
harder constraint on memory allocation for low priority jobs. Or else
if every job can use its provisioned memory, than there will be more
memstalls blocking random jobs which could be the important ones.
Either way hurts performance, but the difference is whose performance
gets hurt.

Memory protection (memory.{min,low}) helps the important jobs less
affected by memstalls. But once low priority jobs use lots of kernel
memory like sockmem, the protection might become much less efficient.

> 
> Global tcp_memory can disappear (set tcp_mem to infinity)

