Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90EFA55A309
	for <lists+netdev@lfdr.de>; Fri, 24 Jun 2022 22:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbiFXUvo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jun 2022 16:51:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiFXUvn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jun 2022 16:51:43 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93FA251330
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 13:51:42 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id m17-20020a170902d19100b0016a0e65a433so1806367plb.8
        for <netdev@vger.kernel.org>; Fri, 24 Jun 2022 13:51:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=e/ErN8VxVghbsrVmXyM/32O9sa9FPILwd78z3c5zUx4=;
        b=P2hH0z+sd2hBJk83/skvppQMZpLb46AZIX7tH2UFAVBnFf3BbEkAt7zwo5og3p0/wF
         IrkjLBDejuewktmbHxaFhoOOd+1OAv+W5DpbxMNoS+yOLlZv43J2dBOVsHYs1g5cCYYc
         xrLrtjfJGlo6jKxTDhYFDeEPis5bSWmXJ4JSULVnLQfcluB1FE9csR/RIpHf1hgkSe27
         LBYnVQtXGCATLtRfmJUOJlm/g2edWCkJTDAZeCYDN4tQk+ROF9zpUlWMJJ4BwJwokl/l
         VEvuRD5mjAwYtFYIZJBBMj4tq29uCCo9YYwWkOazwSl6myVsYSpp9MTkvT0m+Rq/Hr1e
         IZDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=e/ErN8VxVghbsrVmXyM/32O9sa9FPILwd78z3c5zUx4=;
        b=c/RqgdxAb8mSCMlWmhQtI/LWLj4pbz1mZY2yWMqg1XibZv4DYj81px7LF67ifise8U
         O7rpFI04F5xvRzyWmmssOFQKKC2S0oZvCEnTSb2T7CpOkzn+9r3yVPqfNTwhGjWWDDR5
         cVj+WPkKklYBq5RrUorNGG0MT8FoFxRkF5zgjujIDJqLKKFkFuOksIG1SPV3YNW0VKjH
         PEZpFECpUZchVjR+HCl+XEYBj2JHOhUJBJdGSG2mIPH6JzL1QWynj7SdNySYtU/jBHoS
         NtlHYfg+6AOpdbBupxurxFmcaJJlhNL3iVAr+fg6tcPgvyspmMGUGxQ4hQPONfFkT7tI
         mdHw==
X-Gm-Message-State: AJIora8KVUvrI3oGW0FwnbGABXlCXEJWGxvHl5aVnjcZFgtJXkDbQzI8
        OZZ4lEj5V1uZQhbyWMrhMKGr9gE=
X-Google-Smtp-Source: AGRyM1svMVfm0FJH3dQsxg+7/8JmDnVTU9cAq2u5M5SAoMqYfAtMB5Pw4bcaOd++TFXssUvDVa63Vao=
X-Received: from sdf.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:5935])
 (user=sdf job=sendgmr) by 2002:a17:903:41d2:b0:16a:2cca:4869 with SMTP id
 u18-20020a17090341d200b0016a2cca4869mr917447ple.13.1656103902114; Fri, 24 Jun
 2022 13:51:42 -0700 (PDT)
Date:   Fri, 24 Jun 2022 13:51:40 -0700
In-Reply-To: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
Message-Id: <YrYj3LPaHV7thgJW@google.com>
Mime-Version: 1.0
References: <20220602041028.95124-1-xiyou.wangcong@gmail.com>
Subject: Re: [RFC Patch v5 0/5] net_sched: introduce eBPF based Qdisc
From:   sdf@google.com
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Cong Wang <cong.wang@bytedance.com>,
        "Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?=" <toke@redhat.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/01, Cong Wang wrote:
> From: Cong Wang <cong.wang@bytedance.com>

> This *incomplete* patchset introduces a programmable Qdisc with eBPF.

> There are a few use cases:

> 1. Allow customizing Qdisc's in an easier way. So that people don't
>     have to write a complete Qdisc kernel module just to experiment
>     some new queuing theory.

> 2. Solve EDT's problem. EDT calcuates the "tokens" in clsact which
>     is before enqueue, it is impossible to adjust those "tokens" after
>     packets get dropped in enqueue. With eBPF Qdisc, it is easy to
>     be solved with a shared map between clsact and sch_bpf.

> 3. Replace qevents, as now the user gains much more control over the
>     skb and queues.

> 4. Provide a new way to reuse TC filters. Currently TC relies on filter
>     chain and block to reuse the TC filters, but they are too complicated
>     to understand. With eBPF helper bpf_skb_tc_classify(), we can invoke
>     TC filters on _any_ Qdisc (even on a different netdev) to do the
>     classification.

> 5. Potentially pave a way for ingress to queue packets, although
>     current implementation is still only for egress.

> 6. Possibly pave a way for handling TCP protocol in TC, as rbtree itself
>     is already used by TCP to handle TCP retransmission.

> The goal here is to make this Qdisc as programmable as possible,
> that is, to replace as many existing Qdisc's as we can, no matter
> in tree or out of tree. This is why I give up on PIFO which has
> serious limitations on the programmablity.

> Here is a summary of design decisions I made:

> 1. Avoid eBPF struct_ops, as it would be really hard to program
>     a Qdisc with this approach, literally all the struct Qdisc_ops
>     and struct Qdisc_class_ops are needed to implement. This is almost
>     as hard as programming a Qdisc kernel module.

> 2. Introduce skb map, which will allow other eBPF programs to store skb's
>     too.

>     a) As eBPF maps are not directly visible to the kernel, we have to
>     dump the stats via eBPF map API's instead of netlink.

>     b) The user-space is not allowed to read the entire packets, only  
> __sk_buff
>     itself is readable, because we don't have such a use case yet and it  
> would
>     require a different API to read the data, as map values have fixed  
> length.

>     c) Two eBPF helpers are introduced for skb map operations:
>     bpf_skb_map_push() and bpf_skb_map_pop(). Normal map update is
>     not allowed.

>     d) Multi-queue support is implemented via map-in-map, in a similar
>     push/pop fasion.

>     e) Use the netdevice notifier to reset the packets inside skb map upon
>     NETDEV_DOWN event.

> 3. Integrate with existing TC infra. For example, if the user doesn't want
>     to implement her own filters (e.g. a flow dissector), she should be  
> able
>     to re-use the existing TC filters. Another helper  
> bpf_skb_tc_classify() is
>     introduced for this purpose.

> Any high-level feedback is welcome. Please kindly do not review any coding
> details until RFC tag is removed.

> TODO:
> 1. actually test it

Can you try to implement some existing qdisc using your new mechanism?
For BPF-CC, Martin showcased how dctcp/cubic can be reimplemented;
I feel like this patch series (even rfc), should also have a good example
to show that bpf qdisc is on par and can be used to at least implement
existing policies. fq/fq_codel/cake are good candidates.
