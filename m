Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 700235B0B6A
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 19:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbiIGRZo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 13:25:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiIGRZj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 13:25:39 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E9BA7754E;
        Wed,  7 Sep 2022 10:25:38 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id a15so11007200qko.4;
        Wed, 07 Sep 2022 10:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=cWon+Fvd+4B60TMyr3bnMFYMdsAD3pS2yqIjGTbwaT4=;
        b=VoaJy7o/RKdCCt2QujB8CI8PNsT+pZuxu1u+gLDtbyd8K/ALH+Yh28xtnuYiAm/qYB
         5Qrv89+Vz3YBDpnyZZNAJ5+EEDvF0ePDmxls7A1nj59vni+XsBuLDKZZRJuz/uZq42e1
         4rBiOQnc8Jf4N2CTOqu5ocVXwwei9YkcSLyhjEBaYhn09z/UoRIwmM4A4qZ7hL5WfB3I
         awkb1Rghoiwu9QA1hF7ty9wcIqqgOGlZcFHKDJD1Ccr9NSZF13wbcAbu4PQyBhIoGJHm
         CE1B3AHd0H372/RGPQuQiuugEozCbLqICnAbJC5Q5JuvBjw3qNAbm/m6IWVqNIjBtPvR
         pxqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=cWon+Fvd+4B60TMyr3bnMFYMdsAD3pS2yqIjGTbwaT4=;
        b=8DOg0ne3B6XpnfAZkrXv9YxgzyQ5yMhwgAC7gGY4L+10Y/CAPPFr+DQ7ruGXJC7XCi
         6j2WP5pL4JMu0dPqQ0BFbl37FoWDk4HL9NOtyHRzkdQMFDBca7+AH2mgCIUPyYkIsOYO
         f36HVJMbsAafwVfmtuiNl47OIbBgi3bWhVLUgaz9moYiHxwWs9U0ZZx16RH2kTEnp0NO
         DkrgmlguLtBvO0aZvlV8fGWEWDKgdDIqJF5dQ6I2XePcWtxxr1S1oL6v+hzJKsskmU68
         rKj9tylgd25KiW2zQYe10hPCSRWGQ+wYYMv2lQm/ZNJWCduTS8vzTMeLqhuFu61lh4hj
         bOdg==
X-Gm-Message-State: ACgBeo1ekpHyjSkSQa6ryWmqIw3m/0DmSiVOXJjyOgv6PPICh+WyzUqn
        XwNk1diho+hG4LCTb/TK7XH0vo+lR70=
X-Google-Smtp-Source: AA6agR66jJybsuExOf0X9daECGHdF9G6YjYlGuW1uAOynH/JcKaK/g9pXUnFmmFUmFPo51sHnnbavQ==
X-Received: by 2002:a05:620a:687:b0:6c8:c85a:6d63 with SMTP id f7-20020a05620a068700b006c8c85a6d63mr3543014qkh.82.1662571537239;
        Wed, 07 Sep 2022 10:25:37 -0700 (PDT)
Received: from localhost ([2600:1700:65a0:ab60:43a8:b047:37c3:33fe])
        by smtp.gmail.com with ESMTPSA id a26-20020a05620a103a00b006aee5df383csm13730465qkk.134.2022.09.07.10.25.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Sep 2022 10:25:36 -0700 (PDT)
Date:   Wed, 7 Sep 2022 10:25:35 -0700
From:   Cong Wang <xiyou.wangcong@gmail.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jhs@mojatatu.com,
        jiri@resnulli.us, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Subject: Re: [PATCH net-next,v2 00/22] refactor the walk and lookup hook
 functions in tc_action_ops
Message-ID: <YxjUDwJ9/KAblwM3@pop-os.localdomain>
References: <20220906121346.71578-1-shaozhengchao@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220906121346.71578-1-shaozhengchao@huawei.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 06, 2022 at 08:13:24PM +0800, Zhengchao Shao wrote:
> The implementation logic of the walk/lookup hook function in each action
> module is the same. Therefore, the two functions can be reconstructed.
> When registering tc_action_ops of each action module, the corresponding
> net_id is saved to tc_action_ops. In this way, the net_id of the
> corresponding module can be directly obtained in act_api without executing
> the specific walk and lookup hook functions. Then, generic functions can
> be added to replace the walk and lookup hook functions of each action
> module. Last, modify each action module in alphabetical order. 
> 
> Reserve the walk and lookup interfaces and delete them when they are no 
> longer used.
> 
> This patchset has been tested by using TDC, and I will add selftest in
> other patchset.
> 
> ---
> v1: save the net_id of each TC action module to the tc_action_ops structure
> ---
> 
> Zhengchao Shao (22):
>   net: sched: act: move global static variable net_id to tc_action_ops
>   net: sched: act_api: implement generic walker and search for tc action
>   net: sched: act_bpf: get rid of tcf_bpf_walker and tcf_bpf_search
>   net: sched: act_connmark: get rid of tcf_connmark_walker and
>     tcf_connmark_search
>   net: sched: act_csum: get rid of tcf_csum_walker and tcf_csum_search
>   net: sched: act_ct: get rid of tcf_ct_walker and tcf_ct_search
>   net: sched: act_ctinfo: get rid of tcf_ctinfo_walker and
>     tcf_ctinfo_search
>   net: sched: act_gact: get rid of tcf_gact_walker and tcf_gact_search
>   net: sched: act_gate: get rid of tcf_gate_walker and tcf_gate_search
>   net: sched: act_ife: get rid of tcf_ife_walker and tcf_ife_search
>   net: sched: act_ipt: get rid of tcf_ipt_walker/tcf_xt_walker and
>     tcf_ipt_search/tcf_xt_search
>   net: sched: act_mirred: get rid of tcf_mirred_walker and
>     tcf_mirred_search
>   net: sched: act_mpls: get rid of tcf_mpls_walker and tcf_mpls_search
>   net: sched: act_nat: get rid of tcf_nat_walker and tcf_nat_search
>   net: sched: act_pedit: get rid of tcf_pedit_walker and
>     tcf_pedit_search
>   net: sched: act_police: get rid of tcf_police_walker and
>     tcf_police_search
>   net: sched: act_sample: get rid of tcf_sample_walker and
>     tcf_sample_search
>   net: sched: act_simple: get rid of tcf_simp_walker and tcf_simp_search
>   net: sched: act_skbedit: get rid of tcf_skbedit_walker and
>     tcf_skbedit_search
>   net: sched: act_skbmod: get rid of tcf_skbmod_walker and
>     tcf_skbmod_search
>   net: sched: act_tunnel_key: get rid of tunnel_key_walker and
>     tunnel_key_search
>   net: sched: act_vlan: get rid of tcf_vlan_walker and tcf_vlan_search
> 

I think it is easier to review if you can fold those removal patches
into one, pretty much like your 2nd patch. They are just cleanup's
following a same pattern.

Thanks.
