Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32041217FC3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 08:44:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbgGHGov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 02:44:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729794AbgGHGov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jul 2020 02:44:51 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11BDCC061755
        for <netdev@vger.kernel.org>; Tue,  7 Jul 2020 23:44:51 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id h16so14824433ilj.11
        for <netdev@vger.kernel.org>; Tue, 07 Jul 2020 23:44:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9kqWBaMefVTlEcS1n8EE12tWXnM1tMbGs9EizVGJu7M=;
        b=c5We1pmV5yKLEFj+CAo1NyFIvVOIU5PB0+BtpT74M44zZ52k40+VKh9khwZIX8l0VV
         DQsKDpJkCRVb0jM756+22IPx2ZeY241JX3Kynl2fErcEzhpoviFo23VqlSusI+zRhkhg
         v3KavVLj2Zu+xrwfNLc7IJ6dWGZdmwmvAsjpflkiqv8s4dUUAgV+QVcS9YnsmC3eXJbC
         z78O4wkTNHh05b/5LcnWhPyyaBUsKiR8JZrzVpchojyzsWmvC6aQX6FjqV3dynhX0IAq
         WTS7xssgVVi16w6Ep+DXkQN8HpDp5PGAar2xsxJqqV/bpanW52i3v7rqtyw/Y1F0SLLm
         X5uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9kqWBaMefVTlEcS1n8EE12tWXnM1tMbGs9EizVGJu7M=;
        b=nU4av7DIkWuPrT58SoYhEbjigoByUUhjDc4eISAhC+z1PCRM3K7wZCkATskK0R01P6
         8AOPiPBma+0C3Ctv2Hi4NNRkxtJOEtfVjcZKm74N0jj7iGyB1oqXR/PxVU35uY5ioe5M
         S88YpdYeJD+T8UByitWpjLIDpbl4lFIJuz71G1qudPqqlOjucM14AXSmkq12xGzwJiMu
         583k2T1gjm6xrgx769lcJq+tyv/dPKsaAeWnFFE2Z1Uia6LEQrAH5SIo4jkaoGO8TP+7
         lPNzNTEeSqFk7OrP7LAzLdnyFT01YmB5dG7slKdDqujOWAzYVZbNqX+TAvPugeOmObZN
         W70Q==
X-Gm-Message-State: AOAM531otjbRzd5nZ1iUL1dksLTOxs02fTe1k3cmi+MwxMhAXQUy6Yht
        Zp3/HnxfKP33fRY6GcS1eWsJAs2CA1KH56OxDAy8RwDu
X-Google-Smtp-Source: ABdhPJyPeUmy3dV1MBIBvdLOpjguYfT74XJ96HjyEyZLOHpMiny1VTLwycwJUGi6VJ77PzPr/mcJ/vn/ILDWxyj0Hns=
X-Received: by 2002:a92:b655:: with SMTP id s82mr41237244ili.268.1594190690290;
 Tue, 07 Jul 2020 23:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200626104610.21185-1-maximmi@mellanox.com>
In-Reply-To: <20200626104610.21185-1-maximmi@mellanox.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Tue, 7 Jul 2020 23:44:38 -0700
Message-ID: <CAM_iQpUSY2Oxy2umgM5-DwMg9Y9UXX-Gkf=O4StPJFVz-N7PzA@mail.gmail.com>
Subject: Re: [RFC PATCH] sch_htb: Hierarchical QoS hardware offload
To:     Maxim Mikityanskiy <maximmi@mellanox.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Dave Taht <dave.taht@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Rony Efraim <ronye@mellanox.com>,
        Eran Ben Elisha <eranbe@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:46 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
>
> HTB doesn't scale well because of contention on a single lock, and it
> also consumes CPU. Mellanox hardware supports hierarchical rate limiting
> that can be leveraged by offloading the functionality of HTB.

True, essentially because it has to enforce a global rate limit with
link sharing.

There is a proposal of adding a new lockless shaping qdisc, which
you can find in netdev list.

>
> Our solution addresses two problems of HTB:
>
> 1. Contention by flow classification. Currently the filters are attached
> to the HTB instance as follows:
>
>     # tc filter add dev eth0 parent 1:0 protocol ip flower dst_port 80
>     classid 1:10
>
> It's possible to move classification to clsact egress hook, which is
> thread-safe and lock-free:
>
>     # tc filter add dev eth0 egress protocol ip flower dst_port 80
>     action skbedit priority 1:10
>
> This way classification still happens in software, but the lock
> contention is eliminated, and it happens before selecting the TX queue,
> allowing the driver to translate the class to the corresponding hardware
> queue.
>
> Note that this is already compatible with non-offloaded HTB and doesn't
> require changes to the kernel nor iproute2.
>
> 2. Contention by handling packets. HTB is not multi-queue, it attaches
> to a whole net device, and handling of all packets takes the same lock.
> Our solution offloads the logic of HTB to the hardware and registers HTB
> as a multi-queue qdisc, similarly to how mq qdisc does, i.e. HTB is
> attached to the netdev, and each queue has its own qdisc. The control
> flow is performed by HTB, it replicates the hierarchy of classes in
> hardware by calling callbacks of the driver. Leaf classes are presented
> by hardware queues. The data path works as follows: a packet is
> classified by clsact, the driver selectes the hardware queue according
> to its class, and the packet is enqueued into this queue's qdisc.

Are you sure the HTB algorithm could still work even after you
kinda make each HTB class separated? I think they must still share
something when they borrow bandwidth from each other. This is why I
doubt you can simply add a ->attach() without touching the core
algorithm.

Thanks.
