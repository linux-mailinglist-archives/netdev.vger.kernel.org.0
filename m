Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0D54B6012
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 02:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233071AbiBOBkv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 20:40:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233069AbiBOBku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 20:40:50 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 792871405CA
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 17:40:41 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id u18so29694004edt.6
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 17:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rEQoVPyMmsRDyE0PszMkbxsM6NrcnAhf0ize2qxB0rE=;
        b=dJKwsSOVvMsPFM2lGk4HhjM3IL5G4ndgoPdhuY7OD0kNXGbmOGTTfz4Uvv9zDCWq8A
         FdaKRLWeuceSEARzhkqJJgYKbBa5MqaDiQO4ZKnGh3BoL1ZWYTB/WoFhSu40YuJor/Ee
         2bUqnW1myTad7gKaHmMC+XfzHkHK8EmeQnzpIWayQuIXqIHxs/oKgLrLz/JL1+AJsxrx
         3YVSv80gYKAgBzehG2hq+sOxgheishDnqk3dys5QvXRsBTJrEtKohs/h1zm2bXVSjieh
         P+SWJu1lqoyP8eRH9zgY3en66gD7SHpv+fT7CkEEhH3haXHpuuZPp6Jt3QZsCcSHNvu0
         8KKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rEQoVPyMmsRDyE0PszMkbxsM6NrcnAhf0ize2qxB0rE=;
        b=HDL+ZU6B7M6oYMOE8yMDOE7MdQpmJte3Z05NQVDJiEQhs/8a1qP7EIsT/OtYXvaHca
         tK78PoXmO2HBSIrnoJbZnN/aFKn+YjDYUNRK29VyCR4ULSgmWmuu6TeFrQj5cNE9Kwd5
         qN05EqjHFy65U2CGluMsx04FU2T/DU8SZYEkSokx57++7aVS2Z9HcPXE0LuhJC6ZDZEE
         kjdC3hew/Ygj4UNMYKILNiqFlBsfAagRHTLBggrwMhFkx3iB5s+tgR390ylsxBtFCwg4
         XXyy+Bulh90KkU0xcUdqcn1BPD/PdmVIoD0O7L29lO+yAeqMaHuX3wthz4VMxUjCfRsG
         OLSw==
X-Gm-Message-State: AOAM5307CFfI/bqa/gbp0Sf616ckHjeUTJ428oSk97sJLLtQpnwhjw/i
        d0mkiojKJ5gq1qYq8UT+q1IEEknkUzMwnGcdsG8=
X-Google-Smtp-Source: ABdhPJzm+aHIgVn5ofGRph/hWGPFLO0WfhRT6vsnPzimAeuomsPUXXITYM6lc9n8e+zghi6pAhpq6TOibcqfwnMczlU=
X-Received: by 2002:aa7:c1c5:: with SMTP id d5mr1611042edp.231.1644889239925;
 Mon, 14 Feb 2022 17:40:39 -0800 (PST)
MIME-Version: 1.0
References: <20220126143206.23023-1-xiangxia.m.yue@gmail.com>
 <20220126143206.23023-3-xiangxia.m.yue@gmail.com> <0b486c4e-0af5-d142-44e5-ed81aa0b98c2@mojatatu.com>
In-Reply-To: <0b486c4e-0af5-d142-44e5-ed81aa0b98c2@mojatatu.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 15 Feb 2022 09:40:03 +0800
Message-ID: <CAMDZJNVB4FDgv+xrTw2cZisEy2VNn1Dv9RodEhEAsd5H6qwkRA@mail.gmail.com>
Subject: Re: [net-next v8 2/2] net: sched: support hash/classid/cpuid
 selecting tx queue
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 15, 2022 at 8:22 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2022-01-26 09:32, xiangxia.m.yue@gmail.com wrote:
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch allows user to select queue_mapping, range
> > from A to B. And user can use skbhash, cgroup classid
> > and cpuid to select Tx queues. Then we can load balance
> > packets from A to B queue. The range is an unsigned 16bit
> > value in decimal format.
> >
> > $ tc filter ... action skbedit queue_mapping skbhash A B
> >
> > "skbedit queue_mapping QUEUE_MAPPING" (from "man 8 tc-skbedit")
> > is enhanced with flags:
> > * SKBEDIT_F_TXQ_SKBHASH
> > * SKBEDIT_F_TXQ_CLASSID
> > * SKBEDIT_F_TXQ_CPUID
> >
> > Use skb->hash, cgroup classid, or cpuid to distribute packets.
> > Then same range of tx queues can be shared for different flows,
> > cgroups, or CPUs in a variety of scenarios.
> >
> > For example, F1 may share range R1 with F2. The best way to do
> > that is to set flag to SKBEDIT_F_TXQ_HASH, using skb->hash to
> > share the queues. If cgroup C1 want to share the R1 with cgroup
> > C2 .. Cn, use the SKBEDIT_F_TXQ_CLASSID. Of course, in some other
> > scenario, C1 use R1, while Cn can use the Rn.
> >
>
> So while i dont agree that ebpf is the solution for reasons i mentioned
> earlier - after looking at the details think iam confused by this change
> and maybe i didnt fully understand the use case.
>
> What is the driver that would work  with this?
> You said earlier packets are coming out of some pods and then heading to
> the wire and you are looking to balance and isolate between bulk and
> latency  sensitive traffic - how are any of these metadatum useful for
> that? skb->priority seems more natural for that.
Hi
I try to explain. there are two tx-queue range, e.g. A(Q0-Qn), B(Qn+1-Qm).
A is used for latency sensitive traffic. B is used for bulk sensitive
traffic. A may be shared by Pods/Containers which key is
high throughput. B may be shared by Pods/Containers which key is low
latency. So we can do the balance in range A for latency sensitive
traffic.
So we can use the skb->hash or CPUID or classid to classify the
packets in range A or B. The balance policies are used for different
use case.
For skb->hash, the packets from Pods/Containers will share the range.
Should to know that one Pod/Container may use the multi TCP/UDP flows.
That flows share the tx queue range.
For CPUID, while Pod/Container use the multi flows, pod pinned on one
CPU will use one tx-queue in range A or B.
For CLASSID, the Pod may contain the multi containters.

skb->priority may be used by applications. we can't require
application developer to change them.


>
> cheers,
> jamal
>
>


-- 
Best regards, Tonghao
