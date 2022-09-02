Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FB675AB36B
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236644AbiIBO1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:27:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237270AbiIBO0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:26:44 -0400
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B687B110D9B
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:53:56 -0700 (PDT)
Received: by mail-ot1-x336.google.com with SMTP id 92-20020a9d0be5000000b0063946111607so1463850oth.10
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 06:53:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=TRNEPv/fVZBL+J+K0gbUvPbd/wP8B+12JIvN/V7uTcU=;
        b=JJEiY1nRuKPAHexQSBWa1G1+D1zLBXZhFgMaAb2sUdoGvIO/vi/5FZjf3cbuXhRuS2
         UCd9crNd+fUPxT9Fi7I5uObbhL0ex1QkxUU9j4jxgfQiBVy2PaiKUvTB8sXRu9fFVAah
         KYM7x34v7hcl+UNTbsGMMKlRHV6XMoOvcb2TZQoY8bOAxvWLeI1qeyQgMq8zgOMAaF6b
         PJe80p9cyT6qYpurA6bBVX9NENNzT/0xn0CRy3P8K3yed0vYzDunlyEfxOh5r2PDPQVM
         kVGFJ5mDJrgi755A+/6bpL+HDjZYfesebLyl9SLaz24zvcnbRvbh+mKy9sapsSxqkoFV
         IMJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=TRNEPv/fVZBL+J+K0gbUvPbd/wP8B+12JIvN/V7uTcU=;
        b=nOD2KBXual3VMwTNrkABQtkTuqtZOuNPq1ZMXmkmKLmFH89RTZBbPKNBYA+7hVUDYK
         bQClVzf81kwbXf8I5qRS0XCHhw1bKdmMSTGJL5/JWqzo2f3QUZzptv+igrdf2kCqcjqt
         kMW8cP0PROT1JnOSHmbbSUQ7b/YeHabVtRQ428J1FUSetPYmZBsFvbGBVBi4yGYKOUfx
         KTuwiL61kiGZy9ftQSAEKOLWoD/s7dov0q84wCfN8kKyuFRsk5SWj0oT7Z3fMPAcO+Tt
         MEsC4bIfLWUBnDX7XZrh1rO9x9P9l8y8NGrpurOAqfQY+jZeG3uwKRKYcgRU2ZAjU0p4
         0LCw==
X-Gm-Message-State: ACgBeo3ouXNchg5d6E1huDjIoLyjZZ05LWKdytRz1nZ6kgVjQzcjNgho
        rQIFMDJ1VGcg2/EglvujmFdX+XZaRAQdNIU0H6oR9w==
X-Google-Smtp-Source: AA6agR6zb53YPcXo5kDN/63AZ67C60d0NARcZzDg39E8JP0pQszvgj2ovZPGPXkptzTrSV8v0tYkxi9MEbsv38BvS44=
X-Received: by 2002:a05:6830:2a17:b0:636:f7fc:98bb with SMTP id
 y23-20020a0568302a1700b00636f7fc98bbmr14890114otu.223.1662126833447; Fri, 02
 Sep 2022 06:53:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220902112446.29858-1-shaozhengchao@huawei.com> <20220902112446.29858-2-shaozhengchao@huawei.com>
In-Reply-To: <20220902112446.29858-2-shaozhengchao@huawei.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Fri, 2 Sep 2022 09:53:42 -0400
Message-ID: <CAM0EoMnxxA5y2W22aMXF+QRqckbkGm9eJoEnu-CaKhgWMM7kdA@mail.gmail.com>
Subject: Re: [PATCH net-next 01/22] net: sched: act_api: implement generic
 walker and search for tc action
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, ast@kernel.org, andrii@kernel.org,
        song@kernel.org, yhs@fb.com, kpsingh@kernel.org, sdf@google.com,
        haoluo@google.com, jolsa@kernel.org, weiyongjun1@huawei.com,
        yuehaibing@huawei.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 2, 2022 at 7:22 AM Zhengchao Shao <shaozhengchao@huawei.com> wrote:
>
> Being able to get tc_action_net by using net_id stored in tc_action_ops
> and execute the generic walk/search function, add __tcf_generic_walker()
> and __tcf_idr_search() helpers.
>

These are nice cleanups.
Can you please run all tdc tests for all changes you are making to
the tc subsystem? Maybe do a kindness and add more tests.

Just small  opinions below. Otherwise you can add my ACK.

> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  include/net/act_api.h |  1 +
>  net/sched/act_api.c   | 48 +++++++++++++++++++++++++++++++++++++------
>  2 files changed, 43 insertions(+), 6 deletions(-)
>
> diff --git a/include/net/act_api.h b/include/net/act_api.h
> index 9cf6870b526e..a79d6e58519e 100644
\

> @@ -926,7 +945,8 @@ int tcf_register_action(struct tc_action_ops *act,
>         struct tc_action_ops *a;
>         int ret;
>
> -       if (!act->act || !act->dump || !act->init || !act->walk || !act->lookup)
> +       if (!act->act || !act->dump || !act->init ||
> +           (!act->net_id && (!act->walk || !act->lookup)))

I can understand net_id, but why && (!act->walk || !act->lookup) ?
Assumedly they are now optional, no?


> +       if (ops->walk) {
> +               err = ops->walk(net, skb, &dcb, RTM_DELACTION, ops, extack);
> +       } else {
> +               err = __tcf_generic_walker(net, skb, &dcb, RTM_DELACTION, ops, extack);
> +       }

Bikeshed mod: those braces.

cheers,
jamal
