Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF55A5FD25C
	for <lists+netdev@lfdr.de>; Thu, 13 Oct 2022 03:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229988AbiJMBNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Oct 2022 21:13:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiJMBMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Oct 2022 21:12:44 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C143859269
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 18:11:54 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id mz8-20020a0562142d0800b004b18a95b180so372941qvb.8
        for <netdev@vger.kernel.org>; Wed, 12 Oct 2022 18:11:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=2tlT0sKryIjjlYcEvRxXBonCj9sjgTZRO4xGVKaegZc=;
        b=aCC+5QU5Q6ql86BpxO4LEXx32nPTesKN2ifqvcP4ePLuU4LSDEC9aC5PcOyvEq0Tio
         lT95CTcSyY026VFVEPc6wa5F7zF2cYv2M5AG9//2M0Jv5R1mSTFLzZd3QK5pWtPWjvTQ
         7QdVXzB93hHMtr7jFlS7ez4Ze2Me5JUuBRa69ctkMF1i478rc2j4UC7ms1mvWEBNs3pT
         PgKUPt8lLz2rUP4Zf688haPjC7tU0IPluU6wxir/wOA2bL6EJo0hXIA49VJMvK3Q5WiC
         DkXwUroV44w0bjwTtglFGghxbDo7MVzZouxftAmhHGb/0j79QDmmff0E+hnfPrMPoZ40
         UAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2tlT0sKryIjjlYcEvRxXBonCj9sjgTZRO4xGVKaegZc=;
        b=RiHjnZssuB/m9zCCcA3J3KaofVi6S0iPlwpMmAZRfjcDy4tX8AZbyX+heNkwFaQL3G
         a+kKmGFEmy0GKEJfLKsgJamXmlk7UvkwdL0Oksm8BiIGcQtn9KCyQyuY62dVykVbPwfT
         /opDD5zdpi+u1b1LoIMl2RpW8Xi3SRZTZnaFZwN3bTggbSpGF82P2XPWfIznWZR3thvN
         Tgaj3uIFz8JorrIKo4PggNICxg0s1pm4y3FAHyX0nmrEr+vJAlABEOWvMWkz8VFQE1jA
         1cRecw+MnElG8r+Kr7ZKYo0gwX04iX68CRdowzj2Lddh91iiBm7oHA+petmi3MiYAQ5f
         eKgQ==
X-Gm-Message-State: ACrzQf2gr94F4klPaGFlxOe4O9obYIqWFcdP3CQ3SX/n+9Yz2gKEHpkM
        KhZ9AvcbpJVt0z3QtGb16mSN0oOgfA+/Qg==
X-Google-Smtp-Source: AMsMyM5X/Dl+9DA/7md7Osvy7DxGRQ4FWuzTQwkehXz6q6IsmTu6BxBQHm1VBP9Dh364YU9mjaQoHnsoVaMkVA==
X-Received: from shakeelb.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:262e])
 (user=shakeelb job=sendgmr) by 2002:a17:903:11c4:b0:178:634b:1485 with SMTP
 id q4-20020a17090311c400b00178634b1485mr31147763plh.142.1665622475078; Wed,
 12 Oct 2022 17:54:35 -0700 (PDT)
Date:   Thu, 13 Oct 2022 00:54:31 +0000
In-Reply-To: <20221012173825.45d6fbf2@kernel.org>
Mime-Version: 1.0
References: <20210817194003.2102381-1-weiwan@google.com> <20221012163300.795e7b86@kernel.org>
 <CALvZod5pKzcxWsLnjUwE9fUb=1S9MDLOHF950miF8x8CWtK5Bw@mail.gmail.com> <20221012173825.45d6fbf2@kernel.org>
Message-ID: <20221013005431.wzjurocrdoozykl7@google.com>
Subject: Re: [PATCH net-next] net-memcg: pass in gfp_t mask to mem_cgroup_charge_skmem()
From:   Shakeel Butt <shakeelb@google.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Wei Wang <weiwan@google.com>, Eric Dumazet <edumazet@google.com>,
        netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Roman Gushchin <roman.gushchin@linux.dev>
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 12, 2022 at 05:38:25PM -0700, Jakub Kicinski wrote:
> On Wed, 12 Oct 2022 17:17:38 -0700 Shakeel Butt wrote:
> > Did the revert of this patch fix the issue you are seeing? The reason
> > I am asking is because this patch should not change the behavior.
> > Actually someone else reported the similar issue for UDP RX at [1] and
> > they tested the revert as well. The revert did not fix the issue for
> > them.
> > 
> > Wei has a better explanation at [2] why this patch is not the cause
> > for these issues.
> 
> We're talking TCP here, to be clear. I haven't tested a revert, yet (not
> that easy to test with a real workload) but I'm relatively confident the
> change did introduce an "unforced" call, specifically this bit:
> 
> @@ -2728,10 +2728,12 @@ int __sk_mem_raise_allocated(struct sock *sk, int size, int amt, int kind)
>  {
>  	struct proto *prot = sk->sk_prot;
>  	long allocated = sk_memory_allocated_add(sk, amt);
> +	bool memcg_charge = mem_cgroup_sockets_enabled && sk->sk_memcg;
>  	bool charged = true;
>  
> -	if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
> -	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt)))
> +	if (memcg_charge &&
> +	    !(charged = mem_cgroup_charge_skmem(sk->sk_memcg, amt,
> +						gfp_memcg_charge())))
> 
> where gfp_memcg_charge() is GFP_NOWAIT in softirq.
> 
> The above gets called from (inverted stack):
>  tcp_data_queue()
>  tcp_try_rmem_schedule(sk, skb, skb->truesize)
>  tcp_try_rmem_schedule()
>  sk_rmem_schedule()
>  __sk_mem_schedule()
>  __sk_mem_raise_allocated()
> 
> Is my confidence unjustified? :)
> 

Let me add Wei's explanation inline which is protocol independent:

	__sk_mem_raise_allocated() BEFORE the above patch is:
	- mem_cgroup_charge_skmem() gets called:
	    - try_charge() with GFP_NOWAIT gets called and  failed
	    - try_charge() with __GFP_NOFAIL
	    - return false
	- goto suppress_allocation:
	    - mem_cgroup_uncharge_skmem() gets called
	- return 0 (which means failure)

	AFTER the above patch, what happens in __sk_mem_raise_allocated() is:
	- mem_cgroup_charge_skmem() gets called:
	    - try_charge() with GFP_NOWAIT gets called and failed
	    - return false
	- goto suppress_allocation:
	    - We no longer calls mem_cgroup_uncharge_skmem()
	- return 0

So, before the patch, the memcg code may force charges but it will
return false and make the networking code to uncharge memcg for
SK_MEM_RECV.
