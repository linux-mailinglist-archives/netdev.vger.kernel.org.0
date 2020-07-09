Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E473621AA32
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 00:02:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgGIWCz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 18:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGIWCz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 18:02:55 -0400
Received: from mail-qv1-xf41.google.com (mail-qv1-xf41.google.com [IPv6:2607:f8b0:4864:20::f41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E3ADC08C5CE;
        Thu,  9 Jul 2020 15:02:55 -0700 (PDT)
Received: by mail-qv1-xf41.google.com with SMTP id t11so1702571qvk.1;
        Thu, 09 Jul 2020 15:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FDnaozeCAfWpPN4MEexwPtQBOW23sahtHt+Q4fuxN+A=;
        b=oSqTXfLibBWb3YOG+ypfkr42TfJn3scyOBJMuCtxMr+J0CwD8NM58LTTd9tfbg3jtG
         AOS5VzIQ9Gr1T/X4yHlivt6KaXRqXzMIU/wYZIbwtfcQkje3q3xms4X/3m0tQ9vuDMtf
         0d3Sq1KG080QkLdSmsbBUxRIRFpIWgkOxsCL0RjMrlSyiYt7Dzexb1sz1Rk4+1coHo8F
         GKrFQ+zSVtbicKHz8gYjdzmpR+N/sjEf/Rk8yYRyv9awDjyTLCyVY0Z4uiRqnMRsDiEA
         2iron12bUKSbRpz+RnsfYhCjy+iTMrx3DVv26YrFavSuoafKBLe7VJzQURKhcdfdB4vc
         1IFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FDnaozeCAfWpPN4MEexwPtQBOW23sahtHt+Q4fuxN+A=;
        b=VAepF0Tr3rUTkYPJxT4TtkW8jha/rj/fF3btr3MxZtZ9fTD/jY0KvRS9whcrk2V3CZ
         wcIY5lqEPWu+1cOAKSIlR0/VNAVbMJLPddA40ZeZAT5Pl4Hk90pwxC8eQDBa2BjrEbut
         7IOwGs5+9f4PtsaFRhsOVHyLCW0cEe7x2eTn5kGH4uXfNM6s6EgTtV5DKiXwfZx7BCnm
         VVF9hBlcRncCf0OQoPf9gskGOWlE6DDyGWrZIR9kVnbR4Y7Y3kzHAvcSHyNKCHWNBkLQ
         SvndCfzpmClHFQbz3R+yYyFsbq2SZ4WwKGNY6vMZZxucokIW4vbLxnRUnpbwRAqaoNHM
         cdVw==
X-Gm-Message-State: AOAM5339MBp+nbY73MpWelrpr2Km265A0drUeHZKzB2rfaRZHkkNRXle
        32joBpiCt34dOdF0nsgWE2bevHUa+2ZS5bvh05R+65Z0
X-Google-Smtp-Source: ABdhPJy/H0EMy+a03rwnOA3BqmFj87TaIURD6Y92haF48AawjNW0GQdWFNvAuDvyXKnwkM2zUIWdTJHvvIFLSnBRJ2Y=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr64146434qvb.196.1594332174278;
 Thu, 09 Jul 2020 15:02:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-2-jakub@cloudflare.com>
 <CAEf4Bzby9pxaaadTAfuvBER1UnaksS3ajpE6SB79L+g3j_YdAg@mail.gmail.com> <87k0zcam51.fsf@cloudflare.com>
In-Reply-To: <87k0zcam51.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 9 Jul 2020 15:02:43 -0700
Message-ID: <CAEf4BzYd=2=RiHXNkhQ+67QdGB+K2foHQsZVeCXGC6kkE4MjMQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 01/16] bpf, netns: Handle multiple link attachments
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 9, 2020 at 5:49 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, Jul 09, 2020 at 05:44 AM CEST, Andrii Nakryiko wrote:
> > On Thu, Jul 2, 2020 at 2:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Extend the BPF netns link callbacks to rebuild (grow/shrink) or update the
> >> prog_array at given position when link gets attached/updated/released.
> >>
> >> This let's us lift the limit of having just one link attached for the new
> >> attach type introduced by subsequent patch.
> >>
> >> No functional changes intended.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >>
> >> Notes:
> >>     v3:
> >>     - New in v3 to support multi-prog attachments. (Alexei)
> >>
> >>  include/linux/bpf.h        |  4 ++
> >>  kernel/bpf/core.c          | 22 ++++++++++
> >>  kernel/bpf/net_namespace.c | 88 +++++++++++++++++++++++++++++++++++---
> >>  3 files changed, 107 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> >> index 3d2ade703a35..26bc70533db0 100644
> >> --- a/include/linux/bpf.h
> >> +++ b/include/linux/bpf.h
> >> @@ -928,6 +928,10 @@ int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
> >>
> >>  void bpf_prog_array_delete_safe(struct bpf_prog_array *progs,
> >>                                 struct bpf_prog *old_prog);
> >> +void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
> >> +                                  unsigned int index);
> >> +void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
> >> +                             struct bpf_prog *prog);
> >>  int bpf_prog_array_copy_info(struct bpf_prog_array *array,
> >>                              u32 *prog_ids, u32 request_cnt,
> >>                              u32 *prog_cnt);
> >> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> >> index 9df4cc9a2907..d4b3b9ee6bf1 100644
> >> --- a/kernel/bpf/core.c
> >> +++ b/kernel/bpf/core.c
> >> @@ -1958,6 +1958,28 @@ void bpf_prog_array_delete_safe(struct bpf_prog_array *array,
> >>                 }
> >>  }
> >>
> >> +void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
> >> +                                  unsigned int index)
> >> +{
> >> +       bpf_prog_array_update_at(array, index, &dummy_bpf_prog.prog);
> >> +}
> >> +
> >> +void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
> >> +                             struct bpf_prog *prog)
> >
> > it's a good idea to mention it in a comment for both delete_safe_at
> > and update_at that slots with dummy entries are ignored.
>
> I agree. These two need doc comments. update_at doesn't event hint that
> this is not a regular update operation. Will add in v4.
>
> >
> > Also, given that index can be out of bounds, should these functions
> > actually return error if the slot is not found?
>
> That won't hurt. I mean, from bpf-netns PoV getting such an error would
> indicate that there is a bug in the code that manages prog_array. But
> perhaps other future users of this new prog_array API can benefit.
>
> >
> >> +{
> >> +       struct bpf_prog_array_item *item;
> >> +
> >> +       for (item = array->items; item->prog; item++) {
> >> +               if (item->prog == &dummy_bpf_prog.prog)
> >> +                       continue;
> >> +               if (!index) {
> >> +                       WRITE_ONCE(item->prog, prog);
> >> +                       break;
> >> +               }
> >> +               index--;
> >> +       }
> >> +}
> >> +
> >>  int bpf_prog_array_copy(struct bpf_prog_array *old_array,
> >>                         struct bpf_prog *exclude_prog,
> >>                         struct bpf_prog *include_prog,
> >> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
> >> index 247543380fa6..6011122c35b6 100644
> >> --- a/kernel/bpf/net_namespace.c
> >> +++ b/kernel/bpf/net_namespace.c
> >> @@ -36,11 +36,51 @@ static void netns_bpf_run_array_detach(struct net *net,
> >>         bpf_prog_array_free(run_array);
> >>  }
> >>
> >> +static unsigned int link_index(struct net *net,
> >> +                              enum netns_bpf_attach_type type,
> >> +                              struct bpf_netns_link *link)
> >> +{
> >> +       struct bpf_netns_link *pos;
> >> +       unsigned int i = 0;
> >> +
> >> +       list_for_each_entry(pos, &net->bpf.links[type], node) {
> >> +               if (pos == link)
> >> +                       return i;
> >> +               i++;
> >> +       }
> >> +       return UINT_MAX;
> >
> > Why not return a negative error, if the slot is not found? Feels a bit
> > unusual as far as error reporting goes.
>
> Returning uint played well with the consumer of link_index() return
> value, that is bpf_prog_array_update_at(). update at takes an index into
> the array, which must not be negative.

Yeah, it did, but it's also quite implicit. I think just doing
BUG_ON() for update_at or delete_at would be good enough there.

>
> But I don't have strong feelings toward it. Will switch to -ENOENT in
> v4.
>
> >
> >> +}
> >> +
> >
> > [...]
