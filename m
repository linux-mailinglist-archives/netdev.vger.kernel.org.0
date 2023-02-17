Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314BA69A5E5
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 08:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjBQHEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 02:04:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjBQHEn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 02:04:43 -0500
Received: from out-86.mta0.migadu.com (out-86.mta0.migadu.com [IPv6:2001:41d0:1004:224b::56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D116A54
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 23:04:41 -0800 (PST)
Message-ID: <7aa20a67-962a-d60b-9f2d-6e22bb710c1f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676617479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2OJMrzGR3XfwM6mtowcuMfhKXX90XMNBdcjbjPxrOek=;
        b=h+zRXVHxwQZNC2LVMd8MlteM4hyQKwQHdEN82kXM46uMzstaPTZiVBkWMYO/OI4tB3Jtrw
        EAokTLqVDcZ4g4+OprLqerF96eQ5KYkLruFe1N9LEKN6oYx7IZ107daCYBXlSkU2DONnEV
        HSjJp4xWv8PILzzBm+EMAKBPoeiJOOA=
Date:   Thu, 16 Feb 2023 23:04:33 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
Content-Language: en-US
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Mykola Lysenko <mykolal@fb.com>,
        Felix Maurer <fmaurer@redhat.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
 <Y+m4KufriYKd39ot@Laptop-X1>
 <19a6a29d-85f3-b8d7-c9d9-3c97a625bd13@tessares.net>
 <Y+r78ZUqIsvaWjQG@Laptop-X1> <78481d57-4710-aa06-0ff7-fee075458aae@linux.dev>
 <Y+xU8i7BCwXJuqlw@Laptop-X1>
 <a7331a33-fc1f-f74b-4df6-df9483c81125@tessares.net>
 <Y+3lwZChsI0Trok8@Laptop-X1>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <Y+3lwZChsI0Trok8@Laptop-X1>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/16/23 12:13 AM, Hangbin Liu wrote:
> On Wed, Feb 15, 2023 at 10:58:20AM +0100, Matthieu Baerts wrote:
>> Hi Hangbin, Martin,
>>
>> Thank you both for your replies!
>>
>> Yes, that would be good to have this test running in a dedicated NS.
>>
>> Then mptcp.enabled can be forced using write_sysctl() or SYS("sysctl (...)".
>>
> 
> Hi Matt, Martin,
> 
> I tried to set make mptcp test in netns, like decap_sanity.c does. But I got
> error when delete the netns. e.g.
> 
> # ./test_progs -t mptcp
> Cannot remove namespace file "/var/run/netns/mptcp_ns": Device or resource busy

Could you try to create and delete netns after test__join_cgroup()?

