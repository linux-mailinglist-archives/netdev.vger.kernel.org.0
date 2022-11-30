Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D089663DF9C
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 19:49:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiK3Ss7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 13:48:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231429AbiK3Sst (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 13:48:49 -0500
Received: from out2.migadu.com (out2.migadu.com [188.165.223.204])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80BF8178BE;
        Wed, 30 Nov 2022 10:48:44 -0800 (PST)
Message-ID: <6d5eb0b9-4021-011e-5b27-8d84493bd125@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1669834123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=t1tooYTdyVQ0x/b8Y8OKkpw1+D/IMLlho7GbSBMhrLU=;
        b=u1n8L8ryLmLB/FbmDWLpC+n1lYwW9mAgYVRKAbyN8uu2ibLCqJ82obsLXTWWZs68bn+oB9
        CXD52NVrO7OFk/IwwHVDiRxvRxwJ2OjQi4VuhXhUl4DnS7N4rMSii2Xi65DRS4jjkWdOby
        I3Gs/AtDbv6nhz18YwBd6dL5Hw0ekjs=
Date:   Wed, 30 Nov 2022 10:48:34 -0800
MIME-Version: 1.0
Subject: Re: [PATCH ipsec-next,v2 3/3] selftests/bpf: add xfrm_info tests
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        andrii@kernel.org, daniel@iogearbox.net, nicolas.dichtel@6wind.com,
        razor@blackwall.org, mykolal@fb.com, ast@kernel.org,
        song@kernel.org, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, sdf@google.com, haoluo@google.com,
        jolsa@kernel.org, shuah@kernel.org
References: <20221129132018.985887-1-eyal.birger@gmail.com>
 <20221129132018.985887-4-eyal.birger@gmail.com>
 <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
In-Reply-To: <ba1a8717-7d9a-9a78-d80a-ad95bb902085@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/30/22 10:41 AM, Martin KaFai Lau wrote:
>> +static int probe_iproute2(void)
>> +{
>> +    if (SYS_NOFAIL("ip link add type xfrm help 2>&1 | "
>> +               "grep external > /dev/null")) {
>> +        fprintf(stdout, "%s:SKIP: iproute2 with xfrm external support needed 
>> for this test\n", __func__);
> 
> Unfortunately, the BPF CI iproute2 does not have this support also :(
> I am worry it will just stay SKIP for some time and rot.  Can you try to 
> directly use netlink here?

To be clear, I meant directly use netlink only for the xfrm link creation

> 
> https://github.com/kernel-patches/bpf/actions/runs/3578467213/jobs/6019370754#step:6:6395

