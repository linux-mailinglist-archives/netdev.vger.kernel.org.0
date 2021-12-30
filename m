Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C3C481978
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 06:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229501AbhL3FDj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 00:03:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhL3FDj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 00:03:39 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31168C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 21:03:38 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id x15so93845436edv.1
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 21:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hwqA8cPWyBVn+1YUkFmp0d2Lkm/BQRblt3VwtqTqauo=;
        b=obWO5OXGBpIP0zmGQTxjIPm2lGJp2SDg3OqFtaiJ491xn6Z5yS3tiJ1dFvFVminH3d
         fsVjgNOOhmr/0ey/qXXD5X7BWW6s2+xvvPCORRSdGb2992zT/UCJaHeT9DJmvxLbTHeV
         QC1tUTxb8y18JFRyEUte7rU/VvFWi2/BXSoZYAFXtOASI0sNd+TM79taFk36VBlg/ULi
         YoM89gwPl75u06eyaWh8V0wAbE0uyqsE2L3lRC4dZIl0+xUClL9yzzsykKSbibX1l5Q4
         1oecZkET+PM3qNJLgus2oNDINqCc+TVoAD3Ym1Ciue/U87yiKP/z89S5CR3fGFE/Mc+q
         qrdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hwqA8cPWyBVn+1YUkFmp0d2Lkm/BQRblt3VwtqTqauo=;
        b=q3Bq+dCCwVyGu1FqVc0E1S/yAM2TejFqbJzXPU+DmAA7cGSib3Fxy747wkLgboaeCm
         /UQeIz4NNBH3dUtqmSaWyHdakeAiNJu4aOtZTS4sJeP/k7YAwVOmjM8KdVobtBNM7hTp
         4AdSjnwo9iqXkORjFzsnXF5+iT9A6+3SwRzz6vmY8cBb0oIvOkA4IPuwNrr/R+FBliX3
         eMVtZVDsTEtnCfIBIDByA6pA6yGnITTXse8lLCPBw/H4Tvlgkt09dEO6/bXeJFc8ZYXg
         A5LNrBQ5SRqOSK3VYJCFRjROk3QKQrFM0UtKnOPK4TVCFMDRtKJ3n6Bwl1+b7Ak9Fa4Q
         ksZQ==
X-Gm-Message-State: AOAM531R9BaitnRjX1wr8TQiOimloEnIOV8NHYUPFeU7rY+0jjpEgcdT
        yPkhkK44WbInFbyDtHRorg1sQK27gvO4DzUgzv4=
X-Google-Smtp-Source: ABdhPJwWPX3+NxTNwXIr5kGrFYVM5IuMgR3RQd/2TvQ+YEjGM5++W3uBDLFZXf6fX2iP6GYc41qOBv48JS7GkF2Is54=
X-Received: by 2002:a17:906:c108:: with SMTP id do8mr22660582ejc.251.1640840615905;
 Wed, 29 Dec 2021 21:03:35 -0800 (PST)
MIME-Version: 1.0
References: <20211220123839.54664-1-xiangxia.m.yue@gmail.com>
 <20211220123839.54664-2-xiangxia.m.yue@gmail.com> <87k0fn2pht.fsf@intel.com>
In-Reply-To: <87k0fn2pht.fsf@intel.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Thu, 30 Dec 2021 13:02:59 +0800
Message-ID: <CAMDZJNX=gEL0z13QA65Aw11Cp5Mik4HLtMLZUYO0-mppuKsuyg@mail.gmail.com>
Subject: Re: [net-next v5 1/2] net: sched: use queue_mapping to pick tx queue
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
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
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 3:14 AM Vinicius Costa Gomes
<vinicius.gomes@intel.com> wrote:
>
> xiangxia.m.yue@gmail.com writes:
>
> > From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> >
> > This patch fixes issue:
> > * If we install tc filters with act_skbedit in clsact hook.
> >   It doesn't work, because netdev_core_pick_tx() overwrites
> >   queue_mapping.
> >
> >   $ tc filter ... action skbedit queue_mapping 1
> >
> > And this patch is useful:
> > * We can use FQ + EDT to implement efficient policies. Tx queues
> >   are picked by xps, ndo_select_queue of netdev driver, or skb hash
> >   in netdev_core_pick_tx(). In fact, the netdev driver, and skb
> >   hash are _not_ under control. xps uses the CPUs map to select Tx
> >   queues, but we can't figure out which task_struct of pod/containter
> >   running on this cpu in most case. We can use clsact filters to classify
> >   one pod/container traffic to one Tx queue. Why ?
> >
> >   In containter networking environment, there are two kinds of pod/
> >   containter/net-namespace. One kind (e.g. P1, P2), the high throughput
> >   is key in these applications. But avoid running out of network resource,
> >   the outbound traffic of these pods is limited, using or sharing one
> >   dedicated Tx queues assigned HTB/TBF/FQ Qdisc. Other kind of pods
> >   (e.g. Pn), the low latency of data access is key. And the traffic is not
> >   limited. Pods use or share other dedicated Tx queues assigned FIFO Qdisc.
> >   This choice provides two benefits. First, contention on the HTB/FQ Qdisc
> >   lock is significantly reduced since fewer CPUs contend for the same queue.
> >   More importantly, Qdisc contention can be eliminated completely if each
> >   CPU has its own FIFO Qdisc for the second kind of pods.
> >
> >   There must be a mechanism in place to support classifying traffic based on
> >   pods/container to different Tx queues. Note that clsact is outside of Qdisc
> >   while Qdisc can run a classifier to select a sub-queue under the
> >   lock.
>
> One alternative, I don't know if it would work for you, it to use the
> net_prio cgroup + mqprio.
>
> Something like this:
>
> * create the cgroup
>   $ mkdir -p /sys/fs/cgroup/net_prio/<CGROUP_NAME>
> * assign priorities to the cgroup (per interface)
>   $ echo "<IFACE> <PRIO>" >> /sys/fs/cgroup/net_prio/<CGROUP_NAME>/net_prio.ifpriomap"
> * use the cgroup in applications that do not set SO_PRIORITY
Yes, I think this is key. In k8s, we can not control the priority of
applications in Pod. and I think 2/2 patch
can provide more mechanisms to select queues from a range.
If possible, you can help me review it.
https://patchwork.kernel.org/project/netdevbpf/patch/20211224164926.80733-3-xiangxia.m.yue@gmail.com/
>   $ cgexec -g net_prio:<CGROUP_NAME> <application>
> * configure mqprio
>   $ tc qdisc replace dev $IFACE parent root handle 100 mqprio \
>       num_tc 3 \
>       map 2 2 1 0 2 2 2 2 2 2 2 2 2 2 2 2 \
>       queues 1@0 1@1 2@2 \
>       hw 0
>
> This would map all traffic with SO_PRIORITY 3 to TX queue 0, for example.
> But I agree that skbedit's queue_mapping not working is unexpected and
> should be fixed.
>
>
> Cheers,
> --
> Vinicius



-- 
Best regards, Tonghao
