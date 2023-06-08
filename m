Return-Path: <netdev+bounces-9097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C4AE07273CB
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 02:39:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 702B62815FC
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 00:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BE53F637;
	Thu,  8 Jun 2023 00:39:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28FC622
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 00:39:54 +0000 (UTC)
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AC0D2682
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 17:39:52 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id 6a1803df08f44-62606e67c0dso891796d6.2
        for <netdev@vger.kernel.org>; Wed, 07 Jun 2023 17:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686184791; x=1688776791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uTx3BpjebejifzfngoNrlbTBlfkivcsKVKIXVNKp5rM=;
        b=JE1jcXDfSEOvjt6aRXS7gYGwYy1fUzP8JFgGpUZVgH1+l0NffNw/vrnNMU9+zvJXXE
         X5E66xEABxynaLzdS+MNSSrYoUo6XecxW8d2urY9LENsXGYy1+vnNMKqL4HTKB63t5wJ
         rG2orjrPrkwVG4dMg/20uRPK08i6V37sshUm2qVDjwXmAGSCCOCledJfyFrElAzqLAIP
         BoitHqWd7JXANmyEzPUdQpmx/CsNSUgHQY5IQ4mnr3wD/mXiAGdqW80lxlWdkS+uBT8c
         8I9uhTdiFAMeueuoMQu5KFWeTS//fK+v928pht6GIaAX1gem266j1Fcl2Yzke054cIoT
         CrUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686184791; x=1688776791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uTx3BpjebejifzfngoNrlbTBlfkivcsKVKIXVNKp5rM=;
        b=UvNWMDFRsVVPHITZOA4f1MQW5UKXZeCJR3yXMn5Fz1ixbv8IYlHH2hj5f/2fVZyrT5
         vLiddqpoPYa2DMW59N6Fu4X/p9WwjVSbollI7zpINT30eXagj9woAVCD1qA2iFk9Z7Kv
         R5cOyg3vpElwuc0mXs+dBNGM/AeldpduIYyQJSghfItCpALbuJh2R/4LzgfuEQt0vAnQ
         3rPKtUozdjoz9aFw8uMD5lFK+FTquw0ddpK3ANWZxwvcs206QjjWJMfF2YmKn1/Ntb7V
         /ZLCpbEazsdae4QvNVKsvyu77rDYK0ARgS0KWz4srRgVjfZTZjOENQIvGTFBvNJgNYU3
         nSNg==
X-Gm-Message-State: AC+VfDxPSCJaRdLGXUhxtBF9TVpALAZXhyzbhP6X/DdiT5QUwRwMn0ia
	8GyEa28DES/QoD2xPtRrow==
X-Google-Smtp-Source: ACHHUZ4fGij+iE20gn0pvBPSymiE7Suwo7giivj0nf2XHGJ1Aq8rzf0Bz/i97RG07I+08GBSbPICDw==
X-Received: by 2002:a05:6214:dcc:b0:625:75dd:236d with SMTP id 12-20020a0562140dcc00b0062575dd236dmr18991qvt.23.1686184791481;
        Wed, 07 Jun 2023 17:39:51 -0700 (PDT)
Received: from C02FL77VMD6R.googleapis.com ([2600:1700:d860:12b0:7cbc:7b16:951c:eeaa])
        by smtp.gmail.com with ESMTPSA id y9-20020a0cf149000000b006262304b2fesm21210qvl.79.2023.06.07.17.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 17:39:51 -0700 (PDT)
Date: Wed, 7 Jun 2023 17:39:46 -0700
From: Peilin Ye <yepeilin.cs@gmail.com>
To: Vlad Buslov <vladbu@nvidia.com>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>, Jakub Kicinski <kuba@kernel.org>,
	Pedro Tammela <pctammela@mojatatu.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
	Cong Wang <xiyou.wangcong@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
	Peilin Ye <peilin.ye@bytedance.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Hillf Danton <hdanton@sina.com>, netdev@vger.kernel.org,
	Cong Wang <cong.wang@bytedance.com>
Subject: Re: [PATCH v5 net 6/6] net/sched: qdisc_destroy() old ingress and
 clsact Qdiscs before grafting
Message-ID: <ZIEjUobtdPCu648e@C02FL77VMD6R.googleapis.com>
References: <ZHE8P9Bi6FlKz4US@C02FL77VMD6R.googleapis.com>
 <20230526193324.41dfafc8@kernel.org>
 <ZHG+AR8qgpJ6/Zhx@C02FL77VMD6R.googleapis.com>
 <CAM0EoM=xLkAr5EF7bty+ETmZ3GXnmB9De3fYSCrQjKPb8qDy7Q@mail.gmail.com>
 <87jzwrxrz8.fsf@nvidia.com>
 <87fs7fxov6.fsf@nvidia.com>
 <ZHW9tMw5oCkratfs@C02FL77VMD6R.googleapis.com>
 <87bki2xb3d.fsf@nvidia.com>
 <ZHgXL+Bsm2M+ZMiM@C02FL77VMD6R.googleapis.com>
 <877csny9rd.fsf@nvidia.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877csny9rd.fsf@nvidia.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 01, 2023 at 09:20:39AM +0300, Vlad Buslov wrote:
> >> >> If livelock with concurrent filters insertion is an issue, then it can
> >> >> be remedied by setting a new Qdisc->flags bit
> >> >> "DELETED-REJECT-NEW-FILTERS" and checking for it together with
> >> >> QDISC_CLASS_OPS_DOIT_UNLOCKED in order to force any concurrent filter
> >> >> insertion coming after the flag is set to synchronize on rtnl lock.
> >> >
> >> > Thanks for the suggestion!  I'll try this approach.
> >> >
> >> > Currently QDISC_CLASS_OPS_DOIT_UNLOCKED is checked after taking a refcnt of
> >> > the "being-deleted" Qdisc.  I'll try forcing "late" requests (that arrive
> >> > later than Qdisc is flagged as being-deleted) sync on RTNL lock without
> >> > (before) taking the Qdisc refcnt (otherwise I think Task 1 will replay for
> >> > even longer?).
> >> 
> >> Yeah, I see what you mean. Looking at the code __tcf_qdisc_find()
> >> already returns -EINVAL when q->refcnt is zero, so maybe returning
> >> -EINVAL from that function when "DELETED-REJECT-NEW-FILTERS" flags is
> >> set is also fine? Would be much easier to implement as opposed to moving
> >> rtnl_lock there.
> >
> > I implemented [1] this suggestion and tested the livelock issue in QEMU (-m
> > 16G, CONFIG_NR_CPUS=8).  I tried deleting the ingress Qdisc (let's call it
> > "request A") while it has a lot of ongoing filter requests, and here's the
> > result:
> >
> >                         #1         #2         #3         #4
> >   ----------------------------------------------------------
> >    a. refcnt            89         93        230        571
> >    b. replayed     167,568    196,450    336,291    878,027
> >    c. time real   0m2.478s   0m2.746s   0m3.693s   0m9.461s
> >            user   0m0.000s   0m0.000s   0m0.000s   0m0.000s
> >             sys   0m0.623s   0m0.681s   0m1.119s   0m2.770s
> >
> >    a. is the Qdisc refcnt when A calls qdisc_graft() for the first time;
> >    b. is the number of times A has been replayed;
> >    c. is the time(1) output for A.
> >
> > a. and b. are collected from printk() output.  This is better than before,
> > but A could still be replayed for hundreds of thousands of times and hang
> > for a few seconds.
> 
> I don't get where does few seconds waiting time come from. I'm probably
> missing something obvious here, but the waiting time should be the
> maximum filter op latency of new/get/del filter request that is already
> in-flight (i.e. already passed qdisc_is_destroying() check) and it
> should take several orders of magnitude less time.

Yeah I agree, here's what I did:

In Terminal 1 I keep adding filters to eth1 in a naive and unrealistic
loop:

  $ echo "1 1 32" > /sys/bus/netdevsim/new_device
  $ tc qdisc add dev eth1 ingress
  $ for (( i=1; i<=3000; i++ ))
  > do
  > tc filter add dev eth1 ingress proto all flower src_mac 00:11:22:33:44:55 action pass > /dev/null 2>&1 &
  > done

When the loop is running, I delete the Qdisc in Terminal 2:

  $ time tc qdisc delete dev eth1 ingress

Which took seconds on average.  However, if I specify a unique "prio" when
adding filters in that loop, e.g.:

  $ for (( i=1; i<=3000; i++ ))
  > do
  > tc filter add dev eth1 ingress proto all prio $i flower src_mac 00:11:22:33:44:55 action pass > /dev/null 2>&1 &
  > done				     ^^^^^^^

Then deleting the Qdisc in Terminal 2 becomes a lot faster:

  real  0m0.712s
  user  0m0.000s
  sys   0m0.152s 

In fact it's so fast that I couldn't even make qdisc->refcnt > 1, so I did
yet another test [1], which looks a lot better.

When I didn't specify "prio", sometimes that
rhashtable_lookup_insert_fast() call in fl_ht_insert_unique() returns
-EEXIST.  Is it because that concurrent add-filter requests auto-allocated
the same "prio" number, so they collided with each other?  Do you think
this is related to why it's slow?

Thanks,
Peilin Ye

[1] In a beefier QEMU setup (64 cores, -m 128G), I started 64 tc instances
in -batch mode that keeps adding a unique filter (with "prio" and "handle"
specified) then deletes it.  Again, when they are running I delete the
ingress Qdisc, and here's the result:

                         #1         #2         #3         #4
   ----------------------------------------------------------
    a. refcnt            64         63         64         64
    b. replayed         169      5,630        887      3,442
    c. time real   0m0.171s   0m0.147s   0m0.186s   0m0.111s
            user   0m0.000s   0m0.009s   0m0.001s   0m0.000s
             sys   0m0.112s   0m0.108s   0m0.115s   0m0.104s


