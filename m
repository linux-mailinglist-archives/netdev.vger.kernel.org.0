Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71286696DC2
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 20:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232364AbjBNTX0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 14:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjBNTXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 14:23:25 -0500
Received: from out-14.mta0.migadu.com (out-14.mta0.migadu.com [IPv6:2001:41d0:1004:224b::e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792DB2BF3F
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:23:10 -0800 (PST)
Message-ID: <78481d57-4710-aa06-0ff7-fee075458aae@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1676402587;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kpftc87W23vT1+W4TU4Q53NONXxNtzCbpVHA7c1mifU=;
        b=Nyp/2uwKHZ1JjmabvG+8DiATaGHt8flGjZGZMBOWHVECUovbEAxg4m0TKi6/51HL51qHNK
        J9XRW5kGgwVOu7Wj+yGDTQ5Arm3kerSdgkemPCgftKlXufmHRNoEqQC+ulfBliKsdUBfHT
        IPWgF9MsToWDIq/36a+lC4jqfr+xDXQ=
Date:   Tue, 14 Feb 2023 11:22:58 -0800
MIME-Version: 1.0
Subject: Re: [PATCH bpf] selftests/bpf: enable mptcp before testing
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Matthieu Baerts <matthieu.baerts@tessares.net>,
        netdev@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
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
        Davide Caratti <dcaratti@redhat.com>
References: <20230210093205.1378597-1-liuhangbin@gmail.com>
 <6f0a72ee-ec30-8c97-0285-6c53db3d4477@tessares.net>
 <Y+m4KufriYKd39ot@Laptop-X1>
 <19a6a29d-85f3-b8d7-c9d9-3c97a625bd13@tessares.net>
 <Y+r78ZUqIsvaWjQG@Laptop-X1>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <Y+r78ZUqIsvaWjQG@Laptop-X1>
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

On 2/13/23 7:11 PM, Hangbin Liu wrote:
> On Mon, Feb 13, 2023 at 05:28:19PM +0100, Matthieu Baerts wrote:
>> But again, I'm not totally against that, I'm just saying that if these
>> tests are executed in dedicated netns, this modification is not needed
>> when using a vanilla kernel ;-)
>>
>> Except if I misunderstood and these tests are not executed in dedicated
>> netns?
> 
> I tried on my test machine, it looks the test is executed in init netns.

The new test is needed to run under its own netns whenever possible. The 
existing mptcp test should be changed to run in its own netns also. Then 
changing any pernet sysctl (eg. mptcp.enabled) is a less concern to other tests. 
You can take a look at how other tests doing it (eg. decap_sanity.c).
