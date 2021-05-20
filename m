Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8558138B82D
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 22:15:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240294AbhETUQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 16:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236875AbhETUQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 16:16:17 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFFBAC061761;
        Thu, 20 May 2021 13:14:54 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id q15so12622302pgg.12;
        Thu, 20 May 2021 13:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dqil3DTTWK1NFkYRmJGxLtYQ+tRhLYOkuvENExchVCU=;
        b=BG/ExiPZauWc5PA4xRcgOMEDYT8ckD2TbrnN4wadoFODxOUaIc9VbdekfiUU1kcQve
         7FHnsQDWqWpEoSD7FjPwCMeReSaXpgc5zlbF3mI8fXVIi1YAsgcvYjifG+o1sASY3wvp
         Rqwgb2c6MKFiP/KPBwUTOV4zo9u8fE4qFlpmu0s9kLHwJ/F03YLdWCGY1pAkHXH1N3We
         9GkcjT249CsL3WXgUlUqTjBDzImYJ00VpdIcfs/4kkHrh+hsjY3/tr202Tlh6OORj4aU
         ACqQtQ6omyxZICE6qXFwx7oRyqABUok1g4TpQomzMzlArYcKncB8NOIvko/DpeBoCsWu
         SLBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dqil3DTTWK1NFkYRmJGxLtYQ+tRhLYOkuvENExchVCU=;
        b=L+USPSOc16Xp/zsP2r6wTBx4z10Boa6LXJMbbZsRZLFI7CLHVlfupdQRzray9y8BfA
         4NKpoF8JZrlOH1jx4mdnDLxqsunex/TH0FOsbaqwr6Nq+dWoNwyi0F/djixL+S7gkHWi
         7Z1alMwnJLvSOInZRIO+KUeQq1amNBbgsgfRMPz3ZfDyDyVKxZWyMqv0DhrBQV4BuBCw
         p0ZR6MuTgjjJM4pXPPW/j5jHyzNzr1Lsan+Hlbvktx0JgOngNpW3awvGDAJZq6m8MUrC
         5zUl/mEq6UG7ddyOJ9ZY8l5wD6fi2MOM0j/GSJI02l7DefxBLxhUADCxpvibsr36qLyr
         6Lig==
X-Gm-Message-State: AOAM531gDoVuBy1YWLbtE5cdoXqkab55szSdnxK7yCjbkKvQbBuoo9SF
        IRe6f6Jh6+zYxkppNvd5W9FUWvVIgwOKEfgYm5C1oPyoIqHl8g==
X-Google-Smtp-Source: ABdhPJyGTKGt3JjI+V0n+s5Cx3tII7Kk7EwxQ2dFHMZc+/uSkJ7/l2spS4Ib3bOrWOpUnYxWVax5SGzXpHa66rqK3N8=
X-Received: by 2002:aa7:8f37:0:b029:2db:551f:ed8e with SMTP id
 y23-20020aa78f370000b02902db551fed8emr6074289pfr.43.1621541694345; Thu, 20
 May 2021 13:14:54 -0700 (PDT)
MIME-Version: 1.0
References: <20210517022322.50501-1-xiyou.wangcong@gmail.com>
 <60a3525d188d9_18a5f208f5@john-XPS-13-9370.notmuch> <CAM_iQpVCfGEA+TOfWvXYxJ1kk9z_thdbvRmZHxhWpuBMx9x2zg@mail.gmail.com>
 <60a41be5629ab_10e7720815@john-XPS-13-9370.notmuch> <CAM_iQpXkYsf=LF=g4aKLmas_9jHNqXGy-P2gi3R4eb65+ktz4A@mail.gmail.com>
 <60a561b63598a_22c462082f@john-XPS-13-9370.notmuch> <CAM_iQpV=XPW08hS3UyakLxPZrujS_HV-BB9bRbnZ1m+vWQytcQ@mail.gmail.com>
 <60a58913d51e2_2aaa72084c@john-XPS-13-9370.notmuch> <CAM_iQpU5HEB_=+ih7_4FKqdkXJ4eYuw_ej5BTOdRK8wFVa7jig@mail.gmail.com>
 <60a69f9f1610_4ea08208a3@john-XPS-13-9370.notmuch>
In-Reply-To: <60a69f9f1610_4ea08208a3@john-XPS-13-9370.notmuch>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Thu, 20 May 2021 13:14:43 -0700
Message-ID: <CAM_iQpWxJrXhdxyhO6O+h1d9dz=4BBk8i-EYrVG6v8ix_0gCnQ@mail.gmail.com>
Subject: Re: [Patch bpf] udp: fix a memory leak in udp_read_sock()
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 10:43 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Cong Wang wrote:
> > On Wed, May 19, 2021 at 2:54 PM John Fastabend <john.fastabend@gmail.com> wrote:
> > >
> > > Cong Wang wrote:
> > > > On Wed, May 19, 2021 at 12:06 PM John Fastabend
> > > > <john.fastabend@gmail.com> wrote:
> > > > >
> > > > > Cong Wang wrote:
> > > > > > On Tue, May 18, 2021 at 12:56 PM John Fastabend
> > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > >
> > > > > > > Cong Wang wrote:
> > > > > > > > On Mon, May 17, 2021 at 10:36 PM John Fastabend
> > > > > > > > <john.fastabend@gmail.com> wrote:
> > > > > > > > >
> > > > > > > > > Cong Wang wrote:
> > > > > > > > > > From: Cong Wang <cong.wang@bytedance.com>
> > > > > > > > > >
> > > > > > > > > > sk_psock_verdict_recv() clones the skb and uses the clone
> > > > > > > > > > afterward, so udp_read_sock() should free the original skb after
> > > > > > > > > > done using it.
> > > > > > > > >
> > > > > > > > > The clone only happens if sk_psock_verdict_recv() returns >0.
> > > > > > > >
> > > > > > > > Sure, in case of error, no one uses the original skb either,
> > > > > > > > so still need to free it.
> > > > > > >
> > > > > > > But the data is going to be dropped then. I'm questioning if this
> > > > > > > is the best we can do or not. Its simplest sure, but could we
> > > > > > > do a bit more work and peek those skbs or requeue them? Otherwise
> > > > > > > if you cross memory limits for a bit your likely to drop these
> > > > > > > unnecessarily.
> > > > > >
> > > > > > What are the benefits of not dropping it? When sockmap takes
> > > > > > over sk->sk_data_ready() it should have total control over the skb's
> > > > > > in the receive queue. Otherwise user-space recvmsg() would race
> > > > > > with sockmap when they try to read the first skb at the same time,
> > > > > > therefore potentially user-space could get duplicated data (one via
> > > > > > recvmsg(), one via sockmap). I don't see any benefits but races here.
> > > > >
> > > > > The benefit of _not_ dropping it is the packet gets to the receiver
> > > > > side. We've spent a bit of effort to get a packet across the network,
> > > > > received on the stack, and then we drop it at the last point is not
> > > > > so friendly.
> > > >
> > > > Well, at least udp_recvmsg() could drop packets too in various
> > > > scenarios, for example, a copy error. So, I do not think sockmap
> > > > is special.
> > >
> > > OK I am at least convinced now that dropping packets is OK and likely
> > > a useful performance/complexity compromise.
> > >
> > > But, at this point we wont have any visibility into these drops correct?
> > > Looks like the pattern in UDP stack to handle this is to increment
> > > sk_drops and UDP_MIB_INERRORS. How about we do that here as well?
> >
> > We are not dropping the packet, the packet is cloned and deliver to
> > user-space via sk_psock_verdict_recv(), thus, we are simply leaking
> > the original skb, regardless of any error. Maybe udp_read_sock()
> > should check desc->error, but it has nothing to do with this path which
> > only aims to address a memory leak. A separate patch is need to check
> > desc->error, if really needed.
> >
> > Thanks.
>
> "We are not dropping the packet" you'll need to be more explicit on
> how this path is not dropping the skb,

You know it is cloned, don't you? So if we clone an skb and deliver
the clone then free the original, what is dropped here? Absolutely
nothing.

By "drop", we clearly mean nothing is delivered. Or do you have
any different definition of "drop"?

>
>   udp_read_sock()
>     skb = skb_recv_udp()
>      __skb_recv_udp()
>        __skb_try_recv_from_queue()
>         __skb_unlink()              // skb is off the queue
>     used = recv_actor()
>       sk_psock_verdict_recv()

Why do you intentionally ignore the fact the skb is cloned
and the clone is delivered??

>         return 0;
>     if (used <= 0) {
>       kfree(skb)         // skb is unlink'd and kfree'd

Why do you ignore the other kfree_skb() I added in this patch?
Which is clearly on the non-error path. This is why I said the
skb needs to be freed _regardless_ of error or not. You just
keep ignoring it.


>       break;
>     return 0
>
> So if in the error case the skb is unlink'd from the queue and
> kfree'd where is it still existing, how do we get it back? It
> sure looks dropped to me. Yes, the kfree() is needed to not
> leak it, but I'm saying we don't want to drop packets silently.

See above, you clearly ignored the other kfree_skb() which is
on non-error path.

> The convention in UDP space looks to be inc sk->sk_drop and inc
> the MIB. When we have to debug this on deployed systems and
> packets silently get dropped its going to cause lots of pain so
> lets be sure we get the counters correct.

Sure, let me quote what I already said:
" A separate patch is need to check desc->error, if really needed."

This patch, as its subject tells, aims to address a memory leak, not
to address error counters. BTW, TCP does not increase error
counters either, yet another reason it deserves a separate patch
to address both.

Thanks.
