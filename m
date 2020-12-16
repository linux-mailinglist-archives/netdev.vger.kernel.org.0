Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EDF2DC6D6
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732880AbgLPTC0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:02:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732879AbgLPTC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 14:02:26 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36636C061794
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:01:46 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id t22so7791225pfl.3
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 11:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9ddGkCNWtTIeQSywv7lsAYYycIoQU4MD1MMwg/RegB8=;
        b=DYHuRnwwgVgfksbdreiI/VKnExbJdjV9X+00MOTB21aqsxOxgbJs+cLgPkYShOP+nM
         eNjI+t3IhPXKRzs7zSU3Uh9eOI/hr5HVNaUOUQS/rDWYXIAuViJLoEoJwDARlNpVOdVK
         eZ5nPC0ndbn/IGB4Dfv1ez1bpRiZoASdh/tw48BWBOQgWmNPw5OfyoaUBl5QwJk5aJ70
         zog0XIERbRrr+WwU0GTWxwjNMfzvbALwf+jFcIp3Ue+sQz/COVH4KRuSxoVwqCb7ouHH
         WQezO+1Z8VmcSmypG/w5shmgBQBWJciW0KB/FtmR29mealwJgO9uioSsj3xAasSD2XFr
         clhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9ddGkCNWtTIeQSywv7lsAYYycIoQU4MD1MMwg/RegB8=;
        b=dhAhTf81nojL7bFN2o5G7EJZjLFIFM/gSCjarjo+eeFjwKf9u2FU6YlDjAwzIhMwW3
         +qjyacTzCWl4pPCDht+49aAyMapBqUaOnG8QWOncI7txh5NwhzNWXHPLl7g4Yz72RIFy
         MmVLdr+eErNn9yN63JCZGC6kCagdZU7uMqeUL/exVk1OW0ABpgQrULpYPTL8IUWHIO9B
         Flk05XxUWlenw3AlP3a8sxCHNnyLEIjjfPUdHzRtu7Lt14l6dqSmXHbgxXuu/KT2gdfz
         hpzF/h0M8tH1oiAGmTJJ1HWmcr36IHxMob8nzUBA9LKIEZ/GVWlEAPt0WCY4YsLKV6Gd
         8Tsw==
X-Gm-Message-State: AOAM531Zs3vGKWmdhlM477N6J0A4BSo9ap1Nwys02o15QQZ8W8uG2DIw
        +8EgdmQphxrf+NFmGQICF99h5EYuqvh/i/GI6Kc=
X-Google-Smtp-Source: ABdhPJxbL4YDO9QL94pnmvfKdDrhGC8HZ0HPPvLs3iRLHV8Ufdey87VAEDXjf/0LsIWXVoa4agb/tQZ8RYnl8BhASAo=
X-Received: by 2002:a63:5114:: with SMTP id f20mr32134925pgb.5.1608145305510;
 Wed, 16 Dec 2020 11:01:45 -0800 (PST)
MIME-Version: 1.0
References: <20201211152649.12123-1-maximmi@mellanox.com> <20201211152649.12123-3-maximmi@mellanox.com>
 <CAM_iQpUS_71R7wujqhUnF41dtVtNj=5kXcdAHea1euhESbeJrg@mail.gmail.com>
 <7f4b1039-b1be-b8a4-2659-a2b848120f67@nvidia.com> <CAM_iQpVrQAT2frpiVYj4eevSO4jFPY8v2moJdorCe3apF7p6mA@mail.gmail.com>
 <bee0d31e-bd3e-b96a-dd98-7b7bf5b087dc@nvidia.com>
In-Reply-To: <bee0d31e-bd3e-b96a-dd98-7b7bf5b087dc@nvidia.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 16 Dec 2020 11:01:34 -0800
Message-ID: <CAM_iQpW+vqXn6WV6DxBaC5EC0ciSBWtzvXCC57PcDrO2=mFEkg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/4] sch_htb: Hierarchical QoS hardware offload
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     Maxim Mikityanskiy <maximmi@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Tariq Toukan <tariqt@mellanox.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Yossi Kuperman <yossiku@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 14, 2020 at 12:30 PM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> On 2020-12-14 21:35, Cong Wang wrote:
> > On Mon, Dec 14, 2020 at 7:13 AM Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
> >>
> >> On 2020-12-11 21:16, Cong Wang wrote:
> >>> On Fri, Dec 11, 2020 at 7:26 AM Maxim Mikityanskiy <maximmi@mellanox.com> wrote:
> >>>>
> >>>> HTB doesn't scale well because of contention on a single lock, and it
> >>>> also consumes CPU. This patch adds support for offloading HTB to
> >>>> hardware that supports hierarchical rate limiting.
> >>>>
> >>>> This solution addresses two main problems of scaling HTB:
> >>>>
> >>>> 1. Contention by flow classification. Currently the filters are attached
> >>>> to the HTB instance as follows:
> >>>
> >>> I do not think this is the reason, tcf_classify() has been called with RCU
> >>> only on the ingress side for a rather long time. What contentions are you
> >>> talking about here?
> >>
> >> When one attaches filters to HTB, tcf_classify is called from
> >> htb_classify, which is called from htb_enqueue, which is called with the
> >> root spinlock of the qdisc taken.
> >
> > So it has nothing to do with tcf_classify() itself... :-/
> >
> > [...]
> >
> >>> And doesn't TBF already work with mq? I mean you can attach it as
> >>> a leaf to each mq so that the tree lock will not be shared either, but you'd
> >>> lose the benefits of a global rate limit too.
> >>
> >> Yes, I'd lose not only the global rate limit, but also multi-level
> >> hierarchical limits, which are all provided by this HTB offload - that's
> >> why TBF is not really a replacement for this feature.
> >
> > Interesting, please explain how your HTB offload still has a global rate
> > limit and borrowing across queues?
>
> Sure, I will explain that.
>
> > I simply can't see it, all I can see
> > is you offload HTB into each queue in ->attach(),
>
> In the non-offload mode, the same HTB instance would be attached to all
> queues. In the offload mode, HTB behaves like MQ: there is a root
> instance of HTB, but each queue gets a separate simple qdisc (pfifo).
> Only the root qdisc (HTB) gets offloaded, and when that happens, the NIC
> creates an object for the QoS root.

Please add this to your changelog.

And why is the offloaded root qdisc not visible to software? All you add to
root HTB are pointers of direct qdisc's and a boolean, this is what I meant
by "not reflected". I expect the hardware parameters/stats are exposed to
software too, but I can't find any.

>
> Then all configuration changes are sent to the driver, and it issues the
> corresponding firmware commands to replicate the whole hierarchy in the
> NIC. Leaf classes correspond to queue groups (in this implementation
> queue groups contain only one queue, but it can be extended), and inner
> classes correspond to entities called TSARs.
>
> The information about rate limits is stored inside TSARs and queue
> groups. Queues know what groups they belong to, and groups and TSARs
> know what TSAR is their parent. A queue is picked in ndo_select_queue by
> looking at the classification result of clsact. So, when a packet is put
> onto a queue, the NIC can track the whole hierarchy and do the HTB
> algorithm.

Glad to know hardware still keeps HTB as a hierarchy.

Please also add this either to source code as comments or in your
changelog, it is very important to understand what is done by hardware.

Thanks.
