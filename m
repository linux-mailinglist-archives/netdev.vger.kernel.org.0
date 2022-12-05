Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A73656430BB
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 19:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbiLESqL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 13:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiLESqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 13:46:09 -0500
Received: from mail-ot1-x32f.google.com (mail-ot1-x32f.google.com [IPv6:2607:f8b0:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B84A2674
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 10:46:03 -0800 (PST)
Received: by mail-ot1-x32f.google.com with SMTP id db10-20020a0568306b0a00b0066d43e80118so7839988otb.1
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 10:46:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SCyTvExrTOMR8vyPdnVxaIT/SeRx746BjY+OUzgQuzE=;
        b=f7tC7qXbNlRPFyOdg5u88Q3oDPTlr0EhV6tmcJdFLGEAz5rLQfz/cuTQlOy4vDhcGB
         6lFuFzYF66GVWkKDdaxLBVvkcHPxloDna9td+kDSxcLPHQMgcIHWY16Z2GTph4RKMMBP
         jDDME/jWpSdvqI/Q9zr0a/nnhi/BRXT2Vxai2fHa1THbHLrXk3q2yXbcNM39Frc6g14C
         dnOyyRACLD85hdD8hvZpSaEJ9ktKkZ/FmPf5VeW91U96QCzG0uErQ0wPPo1o6NVIQijP
         +04SDAwti2OwXFqJpm1dVxHAL+NKBD5UOn7v6sDLjct3d9XiGUnyl+VhDcJt3QKgOfkQ
         xk3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SCyTvExrTOMR8vyPdnVxaIT/SeRx746BjY+OUzgQuzE=;
        b=dEW3E7kfNtNkA3ldPmHUUpmG2cPlVrSMj8G4EcTbdL/T2nEftw6BEDG4CkFRKKVmnr
         zUM3PlArGOWoefnTwm8Hsaem9ixZ+Swb/nC23V/akpemLjn6c9AZIFQRHPKCZSVJltxr
         1J6qsNKEu+uyTJNRkkMLg7w0qv8q8RdCa7B/3jfKA0NU6Oeh/XIsc5nxz6nrZoqPxCnc
         0Gtp87nN2Fz3ja/Zp+hf6mTV8XCw5fwhZVJrHJg/E9pxT0bNuUqlumbcAGA9VFbv9nKl
         H6uyRefQABE+bc0TPNPoOUlE+CYC76N0mitRa4P6qr44NYqJLUjKROQpzCTlbUj5pf6n
         LxaQ==
X-Gm-Message-State: ANoB5plZmYiHnZqGvARatAtkLn+/t/Jtzy3jMv8oV56ZoTJjg+o09uiw
        T6+9gl+gCG4iBUrAEUOGtkj2TA==
X-Google-Smtp-Source: AA0mqf6lfAnnalPe3SwjhYc6TKcflpX6e9rvMwM6gpzDJacmY0Rpw+XEXZlMXMP+dmoRndIpZul4EQ==
X-Received: by 2002:a05:6830:110:b0:66e:6609:de13 with SMTP id i16-20020a056830011000b0066e6609de13mr13732863otp.222.1670265962496;
        Mon, 05 Dec 2022 10:46:02 -0800 (PST)
Received: from ?IPV6:2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc? ([2804:14d:5c5e:4698:56de:4ea4:df4e:f7cc])
        by smtp.gmail.com with ESMTPSA id k60-20020a9d19c2000000b0066ca9001e68sm6470093otk.5.2022.12.05.10.45.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 10:46:02 -0800 (PST)
Message-ID: <1f403e4e-d790-7818-5728-2f79d7c1b051@mojatatu.com>
Date:   Mon, 5 Dec 2022 15:45:58 -0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3 2/4] net/sched: add retpoline wrapper for tc
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuniyu@amazon.com,
        Victor Nogueira <victor@mojatatu.com>
References: <20221205171520.1731689-1-pctammela@mojatatu.com>
 <20221205171520.1731689-3-pctammela@mojatatu.com>
 <CANn89iKdd74NMuJgzy+Hd22RNBuYVxyw9Tw4JOMY8nMVUhD8CA@mail.gmail.com>
From:   Pedro Tammela <pctammela@mojatatu.com>
In-Reply-To: <CANn89iKdd74NMuJgzy+Hd22RNBuYVxyw9Tw4JOMY8nMVUhD8CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 05/12/2022 14:23, Eric Dumazet wrote:
> On Mon, Dec 5, 2022 at 6:16 PM Pedro Tammela <pctammela@mojatatu.com> wrote:
>>
>> On kernels compiled with CONFIG_RETPOLINE and CONFIG_NET_TC_INDIRECT_WRAPPER,
>> optimize actions and filters that are compiled as built-ins into a direct call.
>> The calls are ordered according to relevance. Testing data shows that
>> the pps difference between first and last is between 0.5%-1.0%.
>>
>> On subsequent patches we expose the classifiers and actions functions
>> and wire up the wrapper into tc.
>>
>> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
>> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
>> Reviewed-by: Victor Nogueira <victor@mojatatu.com>
>> ---
>>   include/net/tc_wrapper.h | 226 +++++++++++++++++++++++++++++++++++++++
>>   net/sched/Kconfig        |  13 +++
>>   2 files changed, 239 insertions(+)
>>   create mode 100644 include/net/tc_wrapper.h
>>
>> diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
>> new file mode 100644
>> index 000000000000..3bdebbfdf9d2
>> --- /dev/null
>> +++ b/include/net/tc_wrapper.h
>> @@ -0,0 +1,226 @@
>> +/* SPDX-License-Identifier: GPL-2.0 */
>> +#ifndef __NET_TC_WRAPPER_H
>> +#define __NET_TC_WRAPPER_H
>> +
>> +#include <linux/indirect_call_wrapper.h>
>> +#include <net/pkt_cls.h>
>> +
>> +#if IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
>> +
>> +#define TC_INDIRECT_SCOPE
>> +
>> +/* TC Actions */
>> +#ifdef CONFIG_NET_CLS_ACT
>> +
>> +#define TC_INDIRECT_ACTION_DECLARE(fname)                              \
>> +       INDIRECT_CALLABLE_DECLARE(int fname(struct sk_buff *skb,       \
>> +                                           const struct tc_action *a, \
>> +                                           struct tcf_result *res))
>> +
>> +TC_INDIRECT_ACTION_DECLARE(tcf_bpf_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_connmark_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_csum_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ct_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ctinfo_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_gact_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_gate_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ife_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_ipt_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_mirred_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_mpls_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_nat_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_pedit_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_police_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_sample_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_simp_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_skbedit_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_skbmod_act);
>> +TC_INDIRECT_ACTION_DECLARE(tcf_vlan_act);
>> +TC_INDIRECT_ACTION_DECLARE(tunnel_key_act);
>> +
>> +static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
>> +                          struct tcf_result *res)
>> +{
> 
> Perhaps you could add a static key to enable this retpoline avoidance only
> on cpus without hardware support.  (IBRS enabled cpus would basically
> use a jump to
> directly go to the
> 
> return a->ops->act(skb, a, res);

Something like this you have in mind? Not tested, just compiled:

diff --git a/include/net/tc_wrapper.h b/include/net/tc_wrapper.h
index 3bdebbfdf9d2..8a74bcf4a2e0 100644
--- a/include/net/tc_wrapper.h
+++ b/include/net/tc_wrapper.h
@@ -2,13 +2,19 @@
  #ifndef __NET_TC_WRAPPER_H
  #define __NET_TC_WRAPPER_H

-#include <linux/indirect_call_wrapper.h>
  #include <net/pkt_cls.h>

-#if IS_ENABLED(CONFIG_NET_TC_INDIRECT_WRAPPER)
+#if IS_ENABLED(CONFIG_RETPOLINE)
+
+#include <asm/cpufeature.h>
+
+#include <linux/static_key.h>
+#include <linux/indirect_call_wrapper.h>

  #define TC_INDIRECT_SCOPE

+static DEFINE_STATIC_KEY_FALSE(tc_skip_wrapper);
+
  /* TC Actions */
  #ifdef CONFIG_NET_CLS_ACT

@@ -41,6 +47,9 @@ TC_INDIRECT_ACTION_DECLARE(tunnel_key_act);
  static inline int tc_act(struct sk_buff *skb, const struct tc_action *a,
                            struct tcf_result *res)
  {
+       if (static_branch_unlikely(&tc_skip_wrapper))
+               goto skip;
+
  #if IS_BUILTIN(CONFIG_NET_ACT_GACT)
         if (a->ops->act == tcf_gact_act)
                 return tcf_gact_act(skb, a, res);
@@ -122,6 +131,7 @@ static inline int tc_act(struct sk_buff *skb, const 
struct tc_action *a,
                 return tcf_sample_act(skb, a, res);
  #endif

+skip:
         return a->ops->act(skb, a, res);
  }

@@ -151,6 +161,9 @@ TC_INDIRECT_FILTER_DECLARE(u32_classify);
  static inline int tc_classify(struct sk_buff *skb, const struct 
tcf_proto *tp,
                                 struct tcf_result *res)
  {
+       if (static_branch_unlikely(&tc_skip_wrapper))
+               goto skip;
+
  #if IS_BUILTIN(CONFIG_NET_CLS_BPF)
         if (tp->classify == cls_bpf_classify)
                 return cls_bpf_classify(skb, tp, res);
@@ -200,9 +213,16 @@ static inline int tc_classify(struct sk_buff *skb, 
const struct tcf_proto *tp,
                 return tcindex_classify(skb, tp, res);
  #endif

+skip:
         return tp->classify(skb, tp, res);
  }

+static inline void tc_wrapper_init(void)
+{
+       if (boot_cpu_has(X86_FEATURE_IBRS))
+               static_branch_enable(&tc_skip_wrapper);
+}
+
  #endif /* CONFIG_NET_CLS */

  #else
@@ -221,6 +241,10 @@ static inline int tc_classify(struct sk_buff *skb, 
const struct tcf_proto *tp,
         return tp->classify(skb, tp, res);
  }

+static inline void tc_wrapper_init(void)
+{
+}
+
  #endif

  #endif /* __NET_TC_WRAPPER_H */
diff --git a/net/sched/Kconfig b/net/sched/Kconfig
index 9bc055f8013e..1e8ab4749c6c 100644
--- a/net/sched/Kconfig
+++ b/net/sched/Kconfig
@@ -1021,19 +1021,6 @@ config NET_TC_SKB_EXT

           Say N here if you won't be using tc<->ovs offload or tc 
chains offload.

-config NET_TC_INDIRECT_WRAPPER
-       bool "TC indirect call wrapper"
-       depends on NET_SCHED
-       depends on RETPOLINE
-
-       help
-         Say Y here to skip indirect calls in the TC datapath for known
-         builtin classifiers/actions under CONFIG_RETPOLINE kernels.
-
-         TC may run slower on CPUs with hardware based mitigations.
-
-         If unsure, say N.
-
  endif # NET_SCHED

  config NET_SCH_FIFO
diff --git a/net/sched/act_api.c b/net/sched/act_api.c
index 5b3c0ac495be..44d4b1e4e18e 100644
--- a/net/sched/act_api.c
+++ b/net/sched/act_api.c
@@ -2179,6 +2179,8 @@ static int __init tc_action_init(void)
         rtnl_register(PF_UNSPEC, RTM_GETACTION, tc_ctl_action, 
tc_dump_action,
                       0);

+       tc_wrapper_init();
+
         return 0;
  }

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 668130f08903..39b6f6331dee 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -3765,6 +3765,8 @@ static int __init tc_filter_init(void)
         rtnl_register(PF_UNSPEC, RTM_GETCHAIN, tc_ctl_chain,
                       tc_dump_chain, 0);

+       tc_wrapper_init();
+
         return 0;

  err_register_pernet_subsys:


