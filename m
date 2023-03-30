Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFB66CF9A0
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 05:39:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229448AbjC3Dju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 23:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjC3Djt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 23:39:49 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA4A4C23
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:39:47 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id e13so7785753ioc.0
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 20:39:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680147587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JtHEWvZ1OLeuYz3L3Ymhr61bZoUI6uzaxFvfnnOq5nU=;
        b=fD4yMz9iCRz5Ep5RwfztP95vV7oPcDqzL4mfi4eX6uAnjkGF8K1suz7Zs+a+iwA8Uo
         URptfUMkwTjDHnKGpW+EZ4cV4nAAJ5sCVwHBaekcKseihbEfRPDPeRQ7NiQ4vJ8rECbd
         ktsZZfJPEJ+RSBJvXcVJR7DJ97qGXFIK3plZg70AWx2dc7hgmOzPEh8Bpb3n2hkJAOtZ
         unG/xHxUf+gNbDaqpoOQtxn49cvx7/SXCEZgj2JC2Ap0/RThDA8GYRHGsMBMN9/8hbHI
         GYXMdn1Y6z/OM0g1735nI72DgUc/EA0/w79U2iFl7230pwfYu6mqc3TZMMpuF3tqIU0f
         5EVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680147587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JtHEWvZ1OLeuYz3L3Ymhr61bZoUI6uzaxFvfnnOq5nU=;
        b=mDZOrnXpp6cQKyPjS5TdKpSNGI1tpl05zqmzST+FUXBCtl0eodUF/nbhm7pPb5QD8E
         PtAIPtcMNDzQyECfQJFE3c1GnAoDi3yQu9a3gbDjJG+D2nN0h+gBRWn4DAqQydfjoMRr
         s8ofgWHsx9UwSzDH+Q+Iu1I2f3oe3hLpMsVH1jpaibMXmhtxIoRAKsTitRJq4mSTyjHx
         xlL4l6ueZKouhQwn+wF0jgS1aff25A5Gdz22CppN+6Yow3dlqMX1Oc/HPJBfJATJFJUE
         2893+NaSJC7pkitBe2sPxUUR9t+3Shfe7paYuZPU1q1CFzdv411jxC2H4wnuial9pan2
         4rTw==
X-Gm-Message-State: AO0yUKWDVzo4rZ+8aOWLugi7zxO4iiEDf8S648ph/8WnWVpX6VhGjAGx
        BGEN5pa6fkmvmaiw35j8DY7zEc6H0N4io5I/hoAPZQ==
X-Google-Smtp-Source: AK7set9/FD+wXR8ltWF8nzjyjDabDw65IAelkdYZSMDBx/A18LO8wjS8jEw/rwCFwMtxelBTKMDChBEvfkH3asQa5/4=
X-Received: by 2002:a02:2943:0:b0:3ec:dc1f:12a8 with SMTP id
 p64-20020a022943000000b003ecdc1f12a8mr8523772jap.2.1680147586715; Wed, 29 Mar
 2023 20:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230328235021.1048163-1-edumazet@google.com> <20230329200403.095be0f7@kernel.org>
 <CANn89iKtD8xiedfvDEWOPQAPeqwDM0HxWqMYgk7C9Ar_gTcGOA@mail.gmail.com>
In-Reply-To: <CANn89iKtD8xiedfvDEWOPQAPeqwDM0HxWqMYgk7C9Ar_gTcGOA@mail.gmail.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Thu, 30 Mar 2023 05:39:35 +0200
Message-ID: <CANn89iKxuKs8muPAe+6jCjYdvoYa=39uXVKoCpKpOVRUFtqt7w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] net: rps/rfs improvements
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Jason Xing <kernelxing@tencent.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-15.7 required=5.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 30, 2023 at 5:15=E2=80=AFAM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Thu, Mar 30, 2023 at 5:04=E2=80=AFAM Jakub Kicinski <kuba@kernel.org> =
wrote:
> >
> > On Tue, 28 Mar 2023 23:50:17 +0000 Eric Dumazet wrote:
> > > Overall, in an intensive RPC workload, with 32 TX/RX queues with RFS
> > > I was able to observe a ~10% reduction of NET_RX_SOFTIRQ
> > > invocations.
> >
> > small clarification on the testing:
> >
> > invocations =3D=3D calls to net_rx_action()
> > or
> > invocations =3D=3D calls to __raise_softirq_irqoff(NET_RX_SOFTIRQ)
>
> This was from "grep NET_RX /proc/softirqs" (more exactly a tool
> parsing /proc/softirqs)
>
> So it should match the number of calls to net_rx_action(), but I can
> double check if you want.
>
> (I had a simple hack to enable/disable the optimizations with a hijacked =
sysctl)

Trace of real debug session, because numbers ;)
Old platform with two Intel(R) Xeon(R) Gold 6268L CPU @ 2.80GHz  (96
threads total)

600 tcp_rr flows

iroa23:/home/edumazet# cat /proc/sys/net/core/netdev_max_backlog
1000
iroa23:/home/edumazet# ./interrupts
hrtimer:99518 cal:2421783 timer:1034 sched:80505 rcu:7661 rps:2390765
net_tx:43 net_rx:3344637 eth1-rx:295134 eth1-tx:558933 eth1:854074
^C
iroa23:/home/edumazet# echo 1001 >/proc/sys/net/core/netdev_max_backlog
iroa23:/home/edumazet# ./interrupts
hrtimer:99545 cal:2358993 timer:1086 sched:77806 rcu:10928 rps:2419052
net_tx:21 net_rx:3016301 eth1-rx:294612 eth1-tx:560331 eth1:855083
^C

echo "(3344637 - 3016301)/3344637" | bc -ql
.09816790282473105452

-> ~10 % decrease.
