Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67C457D8AA
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 04:36:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230470AbiGVCgA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 22:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiGVCf7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 22:35:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F20361B782
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:35:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id d7-20020a17090a564700b001f209736b89so7033413pji.0
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 19:35:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Z67rwdWITu7pyaklNgDuQ75guAU4ThP5Jz0p41pjvRo=;
        b=lKr/LO+zkqgGs5eecZ3tYIDYqkxuGtKYbck76i7eiP+yUIpJlCFElm3Wvouq3d7Nne
         EBZX4kLuf5Ld0TfiVkpesiZp+3a20WWB5IVpi75iJ1Tx97uC41iOS6jtqnAu++rlnVlc
         61fpXwbfGf+1Dln0F7lbNfBWcUrhmIEKZSR+K1Z4Vv4IS7bfb6nhijbdiGXU1FhV9gUF
         TpdSZNfzAfUKjHU2NgKOqQ/n9eQ8ZWCDZSa/7FZPhb2IxeDHNGj5S3Cs1VkotRTT3crL
         90AjI+hpiTOEC24D2lpN6lju4hojB4QQDoSxRfVaeRPfv7SE4noCrmYEvQuhv5JKHRnY
         YXgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z67rwdWITu7pyaklNgDuQ75guAU4ThP5Jz0p41pjvRo=;
        b=CxhMg9Qe7KZFOp9qdpPKXcOe3lgO6lsK5S5D3wqsJ7JmvsjrV7BYeW1IfdiMQCMPol
         tKdPNjUFrqKaS42HvtdOS0jG5Ot2/OrluMkCytn4vTc0Uial+AoMo+oZj2fSqJ0u+Ate
         WC4Sy6N8exLFyG4VLOUPLdF1SRZFTilwuA2LGTJRkNK7lH5jlFZkG7jVNp+P5mY74YVI
         peZYk76iPSbTtx0bs8xJ0hSKguAPRArIWm7Njk25dk0Ibqo5fk6+WvX64NbesXucsMTl
         hPC8i6zRuVl83+0ui0cUjD6TcA587sXDOajH1sYyZJv/i7HbIEMC2/CrhQzigQAD9yHJ
         OkPA==
X-Gm-Message-State: AJIora/bMMicVRmujInG8Vqh16sMXi5//S83jOucYvjERKGt/dfr8SwB
        FjfgPRIOLmxU/iTmLOqMoZ8=
X-Google-Smtp-Source: AGRyM1sArR9Dfn8k4eKeH4HkeZkCRyalozidx4zXMaMYIuzPkbm+GiAOFlqX0Xpm33/NxIeDRRpwNg==
X-Received: by 2002:a17:90b:2252:b0:1f2:2e7:fb45 with SMTP id hk18-20020a17090b225200b001f202e7fb45mr1542778pjb.17.1658457358331;
        Thu, 21 Jul 2022 19:35:58 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id t18-20020a170902d15200b0016c304612a0sm2355584plt.292.2022.07.21.19.35.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jul 2022 19:35:57 -0700 (PDT)
Date:   Fri, 22 Jul 2022 10:35:52 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: mld: do not use system_wq in the mld
Message-ID: <YtoNCKyTPNPotFhp@Laptop-X1>
References: <20220721120316.17070-1-ap420073@gmail.com>
 <CANn89iJjc+jcyWZS1L+EfSkZYRaeVSmUHAkLKAFDRN4bCOcVyg@mail.gmail.com>
 <ea287ba8-89d6-8175-0ebb-3269328a79b4@gmail.com>
 <CANn89iL=sLeDpPfM8OKbDc7L95p+exPynZNz+tUBUve7eA42Eg@mail.gmail.com>
 <6b4db767-3fbd-66df-79c4-f0d78b27b9ee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6b4db767-3fbd-66df-79c4-f0d78b27b9ee@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 22, 2022 at 04:01:13AM +0900, Taehee Yoo wrote:
> 
> 
> On 7/22/22 03:34, Eric Dumazet wrote:
> > On Thu, Jul 21, 2022 at 7:53 PM Taehee Yoo <ap420073@gmail.com> wrote:
> >>
> >> Hi Eric,
> >> Thank you so much for your review!
> >>
> >
> > ...
> >
> >> I think your assumption is right.
> >> I tested the below scenario, which occurs the real issue.
> >> THREAD0                            THREAD1
> >> mld_report_work()
> >>                                      spin_lock_bh()
> >>                                      if (!mod_delayed_work()) <-- queued
> >>                                              in6_dev_hold();
> >>                                      spin_unlock_bh()
> >> spin_lock_bh()
> >> schedule_delayed_work() <-- return false, already queued by THREAD1
> >> spin_unlock_bh()
> >> return;
> >> //no in6_dev_put() regardless return value of schedule_delayed_work().
> >>
> >> In order to check, I added printk like below.
> >>           if (++cnt >= MLD_MAX_QUEUE) {
> >>
> >>                   rework = true;
> >>
> >>                   if (!schedule_delayed_work(&idev->mc_report_work, 0))
> >>                           printk("[TEST]%s %u \n", __func__, __LINE__);
> >>                   break;
> >>
> >>
> >> If the TEST log message is printed, work is already queued by other
> logic.
> >> So, it indicates a reference count is leaked.
> >> The result is that I can see log messages only when the reference count
> >> leak occurs.
> >> So, although I tested it only for 1 hour, I'm sure that this bug comes
> >> from missing check a return value of schedule_delayed_work().
> >>
> >> As you said, this changelog is not correct.
> >> system_wq and mld_wq are not related to this issue.
> >>
> >> I would like to send a v2 patch after some more tests.
> >> The v2 patch will change the commit message.
> >
> > Can you describe what kind of tests you are running ?
> > Was it a syzbot report ?
> 
> I found this bug while testing another syzbot report.
> (https://syzkaller.appspot.com/bug?id=ed41eaa4367b421d37aab5dee25e3f4c91ceae93)
> And I can't find the same case in the syzbot reports list.
> 
> I just use some command lines and many kernel debug options such as
> kmemleak, kasan, lockdep, and others.
> 

Hi Taehee,

I got a similar issue with yours after Eric's 2d3916f31891
("ipv6: fix skb drops in igmp6_event_query() and igmp6_event_report()").
I use force_mld_version=1 and adding a lot of IPv6 address to generate the
mld reports flood. Here is my reproducer:

[root@bootp-73-131-221 ~]# cat mld.sh
#!/bin/sh

ip netns add ns1
ip netns add ns2
ip netns exec ns1 sysctl -w net.ipv6.conf.all.force_mld_version=1
ip netns exec ns2 sysctl -w net.ipv6.conf.all.force_mld_version=1

ip -n ns1 link add veth0 type veth peer name veth0 netns ns2
ip -n ns1 link set veth0 up
ip -n ns2 link set veth0 up

for i in `seq 50`; do
        for j in `seq 100`; do
                ip -n ns1 addr add 2021:${i}::${j}/64 dev veth0
                ip -n ns2 addr add 2022:${i}::${j}/64 dev veth0
        done
done
modprobe -r veth
ip -a netns del

After `modprobe -r veth` we will the the ref leaker error:
[ 1382.683371] unregister_netdevice: waiting for veth0 to become free. Usage count = 2 
[ 1392.931397] unregister_netdevice: waiting for veth0 to become free. Usage count = 2 
[ 1402.939234] unregister_netdevice: waiting for veth0 to become free. Usage count = 2 
[ 1413.179296] unregister_netdevice: waiting for veth0 to become free. Usage count = 2 

I tried to debug the reason but didn't have much clue. Maybe this reproducer
could help you.

Thanks
Hangbin
