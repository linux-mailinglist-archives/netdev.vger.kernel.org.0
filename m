Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36079390BEF
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 00:08:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhEYWJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 18:09:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231259AbhEYWJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 18:09:49 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCFF4C061574;
        Tue, 25 May 2021 15:08:17 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id a4so25368078ljd.5;
        Tue, 25 May 2021 15:08:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NFQ49N6qTWmXXrGPw3/fc7Xbi2xYT9elSH2AHt3mXAw=;
        b=H+cp/bw/YxtakzZMG6Ghq9Ktkx83KHZBHBHLvdBv3AQTWf5ykBRurlCtp9XSsaXXy8
         7Op2zkWjK5nz5/ndtQZW02C+9H2ljPxpOTNaUYjMyIObRmHKfCoKT1MUhmoLRNpqgBd/
         W1MVaN++7gY1fjly7sE3LRCkYHMcEWiGkg367xtMGg3a1X70yezLBnyiw2NfaQ9cd0cx
         gfr7DmX/stTvlHjA/VPRmzsnfvav0tEfpzZK1g7lMHRzhwOTU9sCIAVdZZ4pf2yaulzb
         rFS0zokDQMmhtceJjCPmrC7+rYaSTZURKPYt94XcaN6HMNop8CkCInj3t28X1NIWjh3C
         wkZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NFQ49N6qTWmXXrGPw3/fc7Xbi2xYT9elSH2AHt3mXAw=;
        b=Rqn51tMjBppuoypqggChrVKNTO1h8Mm6ypox/NUlNG5+6DGtscewXrBInqsFZ/4iGB
         L3/lv4dUU+JbOXJzJJ846jhtYhEKHrRJiVvKwVBcaQ1MRG75quYMBw7he/TP77TJJg+0
         djVsB38KS7dwuVBTmFqCRpO4liZ4VfSMm1QAy/isjfNYYOSj4YIAg51l5tXB3+6bqt7s
         Mna5japrV5dWf/e9zHxlP1+MOWzmgfcK7rLCSuWv4dKoJ5TgTjTLQfNjay7rzQVXFNkL
         IgvhK9Cae0rBtFftmtrwPUnosuwQWJ8DoSmx9Ed4/J81ViNpUe11StGmE1iI64xQsmGU
         pISA==
X-Gm-Message-State: AOAM531XiZh8yQZD8GwJD9VqWky6MKbcHjyymbFBwxmD5mAHD5ZZq7OU
        lKODsCFmGjDS9C/JVdsXsi+/MMlPDB1NLyLxonI=
X-Google-Smtp-Source: ABdhPJycoM/bsQGaHQtbch9Vg1YSBr4FtbzK4fbCSBnD/XBUHiKCq+xf69aTxLh4A/pxBe9kb5z7pwOkrNhX82nOLP8=
X-Received: by 2002:a2e:b610:: with SMTP id r16mr21718411ljn.486.1621980496071;
 Tue, 25 May 2021 15:08:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210520185550.13688-1-alexei.starovoitov@gmail.com>
 <CAM_iQpWDgVTCnP3xC3=z7WCH05oDUuqxrw2OjjUC69rjSQG0qQ@mail.gmail.com>
 <CAADnVQ+V5o31-h-A+eNsHvHgOJrVfP4wVbyb+jL2J=-ionV0TA@mail.gmail.com>
 <CAM_iQpU-Cvpf-+9R0ZdZY+5Dv+stfodrH0MhvSgryv_tGiX7pA@mail.gmail.com>
 <CAM_iQpVYBNkjDeo+2CzD-qMnR4-2uW+QdMSf_7ohwr0NjgipaQ@mail.gmail.com>
 <CAADnVQJUHydpLwtj9hRWWNGx3bPbdk-+cQiSe3MDFQpwkKmkSw@mail.gmail.com>
 <bcbf76c3-34d4-d550-1648-02eda587ccd7@mojatatu.com> <CAADnVQLWj-=B2TfJp7HEsiUY3rqmd6-YMDAGdyL6RgZ=_b2CXg@mail.gmail.com>
 <27dae780-b66b-4ee9-cff1-a3257e42070e@mojatatu.com>
In-Reply-To: <27dae780-b66b-4ee9-cff1-a3257e42070e@mojatatu.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 25 May 2021 15:08:04 -0700
Message-ID: <CAADnVQJq37Xi2bHBG5L+DmMq6dJvFUCE3tt+uC-oAKX3WxcCQg@mail.gmail.com>
Subject: Re: [RFC PATCH bpf-next] bpf: Introduce bpf_timer
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
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 25, 2021 at 2:09 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> On 2021-05-25 3:57 p.m., Alexei Starovoitov wrote:
> > On Tue, May 25, 2021 at 12:35 PM Jamal Hadi Salim <jhs@mojatatu.com> wrote:
>
> [..]
> > The outcome of the last bpf office hours was a general agreement
> > that we need new hooks in map update/delete operations
> > (including auto-delete by LRU) that will trigger a bpf subprog.
>
> This is certainly a useful feature (for other reasons as well).
> Does this include create/update/delete issued from user space?

Right. Any kind of update/delete and create is a subset of update.
The lookup is not included (yet or may be ever) since it doesn't
have deterministic start/end points.
The prog can do a lookup and update values in place while
holding on the element until prog execution ends.

While update/delete have precise points in hash/lru/lpm maps.
Array is a different story.

> > It might look very similar to the timer callback that is part of this patch,
> > but instead of being called by the timer the LRU logic will call it.
> > This way the subprog can transfer the data stored in the
> > about-to-be-deleted map element into some other map or pass
> > to user space via ringbuf or do any other logic.
> >
>
> The challenge we have in this case is LRU makes the decision
> which entry to victimize. We do have some entries we want to
> keep longer - even if they are not seeing a lot of activity.

Right. That's certainly an argument to make LRU eviction
logic programmable.
John/Joe/Daniel proposed it as a concept long ago.
Design ideas are in demand to make further progress here :)

> You could just notify user space to re-add the entry but then
> you have sync challenges.
> The timers do provide us a way to implement custom GC.

My point is that time is always going to be a heuristic that will
break under certain traffic conditions.
I recommend to focus development effort on creating
building blocks that are truly great instead of reimplementing
old ideas in bpf with all of their shortcomings.

> So a question (which may have already been discussed),
> assuming the following setup:
> - 2 programs a) Ingress b) egress
> - sharing a conntrack map which and said map pinned.
> - a timer prog (with a map with just timers;
>     even a single timer would be enough in some cases).
>
> ingress and egress do std stuff like create/update
> timer prog does the deletes. For simplicity sake assume
> we just have one timer that does a foreach and iterates
> all entries.
>
> What happens when both ingress and egress are ejected?

What is 'ejected'? Like a CD? ;)
I think you mean 'detached' ?
and then, I assume, the user space doesn't hold to prog FD?
The kernel can choose to do different things with the timer here.
One option is to cancel the outstanding timers and unload
.text where the timer callback lives.
Another option is to let the timer stay armed and auto unload
.text of bpf function when it finishes executing.
If timer callback decides to re-arm itself it can continue
executing indefinitely.
This patch is doing the latter.
There could be a combination of both options.
All options have their pros/cons.
