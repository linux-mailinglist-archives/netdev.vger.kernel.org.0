Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1805B245918
	for <lists+netdev@lfdr.de>; Sun, 16 Aug 2020 20:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726708AbgHPS7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Aug 2020 14:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725873AbgHPS7k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Aug 2020 14:59:40 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D53AAC061786
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:59:39 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id f12so5096976ils.6
        for <netdev@vger.kernel.org>; Sun, 16 Aug 2020 11:59:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kM1eCp5tQ6QIpIRFFN2DfvbOHEmxmweCAbBk0AfZjgQ=;
        b=hEVSCEgRL/Hi9NF0vCapKcH7qKOHQhuHOOcqU2RhVLT8N0KaU6t8unuKIttb/gCw4J
         V8MJApasUoUDyUC4eGqd0lhwwWma37nTHsF6m31QnQHidVFQXW6YLLLwZIWZqxy0sDoN
         e5L37gkbvHYi5lRFLrFCyKhLoJAZ1F2eNaswOYl3pusRiKZ2c/nXli+/I4qMpwr9TY/S
         P/Bp8qiURRYe2cIJiCIHP2iSlaJfUFlxbVDJ0qNLFNcNhDrXzvzleH3BO8xWDl1chtty
         JoqGhxe7680RPoEIU3xgegwdLxthEUQqy0az1cO1Sq6fTVz53HgXY2yYE2IPm05eetnZ
         bwOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kM1eCp5tQ6QIpIRFFN2DfvbOHEmxmweCAbBk0AfZjgQ=;
        b=UpJmL1XIuneavMpCFLhDl69SQcjbhJvrseBUm4Nbb6dzRfkDl1OOiT/cYaDRhXxQ3r
         wCxpxImE8xWwTkrHVKsgXbweE++rZlwWzW3p+3AHnEg6jJWeS53Cqv2muL4I4jS2arn2
         kydh3Z2Vt1WU3W4SbjH5k7vRyOj4V84JhTv4K6JtIG1lfanv7Wb1+PYhREH+2L8Vpzvk
         Fg9COgwGJi+6HBlUf1ZAveATDWlBUV97az/WmRemVqnaEwoDfXJKuR0t9xElmeuYF5Qz
         8/mzShaWm31aRZAR9PMNt7CRVVz/lFXxcQ2Y4vV5fcgGLkWHToB9PogaIy1YM7Ufyefn
         FCTw==
X-Gm-Message-State: AOAM5328Dkl3xcfwdYvlIr+igvESFMKBjwXp3sdZjflMnHNAQkXP8pjo
        hYMXb/TktWLMXvMVjR6Q190CHBeVXt6mJkQXm0rupRbUMBG1XQ==
X-Google-Smtp-Source: ABdhPJwedmckK7gZwxMSjw0sS9pq6lvgC6vLqMYNBHujJTO2tqfjR2ajZFKw3502s0qSAJR+Eccq2fltBygXwR7TfL8=
X-Received: by 2002:a92:9145:: with SMTP id t66mr60801ild.305.1597604379003;
 Sun, 16 Aug 2020 11:59:39 -0700 (PDT)
MIME-Version: 1.0
References: <20200807222816.18026-1-jhs@emojatatu.com> <CAM_iQpU6j2TVOu2uYFcFWhBdMj_nu1TuLWfnR3O+2F2CPG+Wzw@mail.gmail.com>
 <3ee54212-7830-8b07-4eed-a0ddc5adecab@mojatatu.com> <CAM_iQpU6KE4O6L1qAB5MjJGsc-zeQwx6x3HjgmevExaHntMyzA@mail.gmail.com>
 <64844778-a3d5-7552-df45-bf663d6498b6@mojatatu.com>
In-Reply-To: <64844778-a3d5-7552-df45-bf663d6498b6@mojatatu.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Sun, 16 Aug 2020 11:59:27 -0700
Message-ID: <CAM_iQpVBs--KBGe4ZDtUJ0-FsofMOkfnUY=bWJjE0_dFYmv5SA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/1] net/sched: Introduce skb hash classifier
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     David Miller <davem@davemloft.net>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@resnulli.us>,
        Ariel Levkovich <lariel@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 5:52 AM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> The _main_ requirement is to scale to a large number of filters
> (a million is a good handwave number). Scale means
> 1) fast datapath lookup time + 2) fast insertion/deletion/get/dump
> from control/user space.
> fwmark is good at all these goals today for #2. It is good for #1 for
> maybe 1K rules (limitation is the 256 buckets, constrained by rcu
> trickery). Then you start having collisions in a bucket and your
> lookup requires long linked list walks.
>
> Generally something like a hash table with sufficient number of buckets
> will work out ok.
> There maybe other approaches (IDR in the kernel looks interesting,
> but i didnt look closely).
>
> So to the implementation issue:
> Major issue is removing ambiguity while at the same time trying
> to get good performance.
>
> Lets say we decided to classify skbmark and skbhash at this point.
> For a hash table, one simple approach is to set
> lookupkey = hash<<32|mark
>
> the key is used as input to the hash algo to find the bucket.
>
> There are two outstanding challenges in my mind:
>
> 1)  To use the policy like you describe above
> as an example:
>
> $TC filter add dev $DEV1 parent ffff: protocol ip prio 3 handle 1
> skb hash Y flowid 1:12 action ok
>
> and say you receive a packet with both skb->hash and skb->mark set
> Then there is ambiguity
>
> How do you know whether to use hash or mark or both
> for that specific key?

Hmm, you can just unconditionally pass skb->hash and skb->mark,
no? Something like:

if (filter_parameter_has_hash) {
    match skb->hash with cls->param_hash
}

if (filter_parameter_has_mark) {
    match skb->mark with cls->param_mark
}

fw_classify() uses skb->mark unconditionally anyway, without checking
whether it is set or not first.

But if filters were put in a global hashtable, the above would be
much harder to implement.


> You can probably do some trick but I cant think of a cheap way to
> achieve this goal. Of course this issue doesnt exist if you have
> separate classifiers.
>
> 2) If you decide tomorrow to add tcindex/prio etc, you will have to
> rework this as well.
>
> #2 is not as a big deal as #1.

Well, I think #2 is more serious than #1, if we have to use a hashtable.
(If we don't have to, then it would be much easier to extend, of course.)

THanks.
