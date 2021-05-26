Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7509A391D6C
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 18:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233731AbhEZRAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 13:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233648AbhEZRAY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 May 2021 13:00:24 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97DDDC061574;
        Wed, 26 May 2021 09:58:52 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m124so1439140pgm.13;
        Wed, 26 May 2021 09:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=d5rp5SOuLl+5dILz1M7zNvluf2P8aTjhSkLOoouqQXQ=;
        b=ogTScCN4fcplu2773rGdeflhiWqZihKuTJEqvZjA/EUORJuNUYhSEZVCmkLDx26BBe
         QhgkwciduAl1l4bNWYLogs31CQ+emHQP/UHuK0Ivz8YtI/RkvL3vyRlWf6qISa6WFx/j
         EG5LU9nQrxpUZW7ii4mMKjuYTrvbFt2+PYovcNtpGx3F5hED66tVE9JEsmefrL4S8bG0
         splkOrqKcAgpsqSUInlXP+K/81OKXIqG+b8ojO1Fh57CgsQHc8Nz4Wr3qAaL7X39kkO6
         nzKO9esKI9yoZhAHjphNjbfcEWEGSrdWknTGH91h3PCg28nfcfJ9RixBJSBP82i68lvR
         cAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=d5rp5SOuLl+5dILz1M7zNvluf2P8aTjhSkLOoouqQXQ=;
        b=MtrZp9VjxjEfQvJ8QknoXvekkL63dkOPz1wmvAwQfJ4oKCdTjoV8MNWjBepWZzuDTJ
         uNwIirh0VNvlsdo9uKu/91HRWhlju9oLRkzqpheUetbLLo2fbdIwGj9KBVLAM7ybJWWo
         s2lfhEkWw7YJpBF3fJCcgAVkAWDQgtlR8wki4aLu6wCYmRl7W4SPAPFEJlPpV9DTcjeH
         ve1393Frv6ezhe2AzarrXQHnZgnRfdRudc9c8mIJDID21c3Pr49h+WW3QipbT63Jl60I
         tFQ759z/xr9gh9PtyfZMzACd92EnIxqVQ1CwXPI8qhbhcvjOBoXweeA9VWTfM2gB3I6W
         rkBw==
X-Gm-Message-State: AOAM533mFSLP6KNPI+qh9j7DG0QbfkWsTORlZetnpJUtx4oLoy7B5cb4
        pIQ4SMgfJHYXa47yuzXzlBk9zrYA2J0=
X-Google-Smtp-Source: ABdhPJyLDgGiTholRvJ1jWb5WYgLHXkDPBXQDNSej2uG+bcJf0ASJZH3f2d/8xUARFoiKq97zQytaA==
X-Received: by 2002:a05:6a00:1742:b029:2cc:b1b0:731c with SMTP id j2-20020a056a001742b02902ccb1b0731cmr36232581pfc.15.1622048332025;
        Wed, 26 May 2021 09:58:52 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:fc12])
        by smtp.gmail.com with ESMTPSA id f16sm7598906pju.12.2021.05.26.09.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 09:58:51 -0700 (PDT)
Date:   Wed, 26 May 2021 09:58:47 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-team <kernel-team@fb.com>,
        Pedro Tammela <pctammela@gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
Message-ID: <20210526165847.g4z5anq6ync47z4t@ast-mbp.dhcp.thefacebook.com>
References: <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <bcbf76c3-34d4-d550-1648-02eda587ccd7@mojatatu.com>
 <CAADnVQLWj-=B2TfJp7HEsiUY3rqmd6-YMDAGdyL6RgZ=_b2CXg@mail.gmail.com>
 <27dae780-b66b-4ee9-cff1-a3257e42070e@mojatatu.com>
 <CAADnVQJq37Xi2bHBG5L+DmMq6dJvFUCE3tt+uC-oAKX3WxcCQg@mail.gmail.com>
 <2dfc5180-40df-ae4c-7146-d64130be9ad4@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2dfc5180-40df-ae4c-7146-d64130be9ad4@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 11:34:04AM -0400, Jamal Hadi Salim wrote:
> On 2021-05-25 6:08 p.m., Alexei Starovoitov wrote:
> > On Tue, May 25, 2021 at 2:09 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
> > > 
> 
> > > This is certainly a useful feature (for other reasons as well).
> > > Does this include create/update/delete issued from user space?
> > 
> > Right. Any kind of update/delete and create is a subset of update.
> > The lookup is not included (yet or may be ever) since it doesn't
> > have deterministic start/end points.
> > The prog can do a lookup and update values in place while
> > holding on the element until prog execution ends.
> > 
> > While update/delete have precise points in hash/lru/lpm maps.
> > Array is a different story.
> > 
> 
> Didnt follow why this wouldnt work in the same way for Array?

array doesn't have delete.

> One interesting concept i see come out of this is emulating
> netlink-like event generation towards user space i.e a user
> space app listening to changes to a map.

Folks do it already via ringbuf events. No need for update/delete
callback to implement such notifications.

> > > 
> > > The challenge we have in this case is LRU makes the decision
> > > which entry to victimize. We do have some entries we want to
> > > keep longer - even if they are not seeing a lot of activity.
> > 
> > Right. That's certainly an argument to make LRU eviction
> > logic programmable.
> > John/Joe/Daniel proposed it as a concept long ago.
> > Design ideas are in demand to make further progress here :)
> > 
> 
> would like to hear what the proposed ideas are.
> I see this as a tricky problem to solve - you can make LRU
> programmable to allow the variety of LRU replacement algos out
> there but not all encompansing for custom or other types of algos.
> The problem remains that LRU is very specific to evicting
> entries that are least used. I can imagine that if i wanted to
> do a LIFO aging for example then it can be done with some acrobatics
> as an overlay on top of LRU with all sorts of tweaking.
> It is sort of fitting a square peg into a round hole - you can do
> it, but why the torture when you have a flexible architecture.

Using GC to solve 'hash table is running out of memory' problem is
exactly the square peg.
Timers is absolutely wrong way to address memory pressure.

> We need to provide the mechanisms (I dont see a disagreement on
> need for timers at least).

It's an explicit non-goal for timer api to be used as GC for conntrack.
You'll be able to use it as such, but when it fails to scale
(as it's going to happen with any timer implementation) don't blame
infrastructure for that.

> > > 
> > > What happens when both ingress and egress are ejected?
> > 
> > What is 'ejected'? Like a CD? ;)
> 
> I was going to use other verbs to describe this; but
> may have sounded obscene ;->

Please use standard terminology. The topic is difficult enough
to understand without inventing new words.

> > The kernel can choose to do different things with the timer here.
> > One option is to cancel the outstanding timers and unload
> > .text where the timer callback lives
> >
> > Another option is to let the timer stay armed and auto unload
> > .text of bpf function when it finishes executing.
> >
> > If timer callback decides to re-arm itself it can continue
> > executing indefinitely.
> > This patch is doing the latter.
> > There could be a combination of both options.
> > All options have their pros/cons.
> 
> A reasonable approach is to let the policy be defined
> from user space. I may want the timer to keep polling
> a map that is not being updated until the next program
> restarts and starts updating it.
> I thought Cong's approach with timerids/maps was a good
> way to achieve control.

No, it's not a policy, and no, it doesn't belong to user space,
and no, Cong's approach has nothing to do with this design choice.
