Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D959321BD90
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 21:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728072AbgGJTXZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 15:23:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726908AbgGJTXZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 15:23:25 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40FAC08C5DD
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 12:23:24 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id s9so7663803ljm.11
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 12:23:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=nnU0K5UPatH4R1U5BSkLlzHCSh1B4ICDzV4utjm4tn4=;
        b=bnWuXs/aFSo+pxESkZIHzFem3GhAcSHSSaz9Qoa1KtxjNIKQV3nS92SaE1iFWHhPZA
         B3+7gsGklHLc+KcjOqKEGUNo2UWXuMZUr0H8/XZmtEEWwCaPHy61ZxuwwoVSlqpGwI6P
         dMUjc81F2nacAP+AnCSXjesKQGq+icpKXB1eA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=nnU0K5UPatH4R1U5BSkLlzHCSh1B4ICDzV4utjm4tn4=;
        b=XL5G+EOv1RzDSqK8SKpSIPAvtXBVcyeN5fGHVTPaKMxQ56VSY9+8wmuEYKzpmhS6B9
         e6HBsytv44b6ec8bRySsSsiA+y6RaWf20w+sKPlDQnBhXPV9Zyur5iPNbMgPvmPRI846
         SrYnArYbtLeObytZhZo2q2VYBX8BuZyCALk4E29Pr4rLy1oKxwrFs2vqYlQIIBv9Gp5D
         19m2HV9JOArW+IqSXtXGQF1wV46dj/VAOm7i5pLKavd7YDfCH8UKzZoYhBaRZHQaQjdH
         oHHl82NCpRfNS6H/uLtfCa5wWrt86q8RANNB/gCpDzy7uHZpqN4sIYnBJmpbzomDw6AX
         YNqA==
X-Gm-Message-State: AOAM5308pXU2KLsIeg3+tFLVscfI7/eTcCCsJBchNeEPBUEGREkMxAjD
        oFFM9uiExyIKJJ6GOO/8TpmG/AXIzpzuzw==
X-Google-Smtp-Source: ABdhPJwwFXqjp8yRZiUP1+QcEdrOoY0xEnSz2RZUufFIX4G5B2DoVkWyZ2I2MLlJbutQVG51p0wnBw==
X-Received: by 2002:a2e:9b0f:: with SMTP id u15mr43623524lji.180.1594409003173;
        Fri, 10 Jul 2020 12:23:23 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id e10sm2174374ljb.118.2020.07.10.12.23.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 12:23:22 -0700 (PDT)
References: <20200702092416.11961-1-jakub@cloudflare.com> <20200702092416.11961-2-jakub@cloudflare.com> <CAEf4Bzby9pxaaadTAfuvBER1UnaksS3ajpE6SB79L+g3j_YdAg@mail.gmail.com> <87k0zcam51.fsf@cloudflare.com> <CAEf4BzYd=2=RiHXNkhQ+67QdGB+K2foHQsZVeCXGC6kkE4MjMQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH bpf-next v3 01/16] bpf, netns: Handle multiple link attachments
In-reply-to: <CAEf4BzYd=2=RiHXNkhQ+67QdGB+K2foHQsZVeCXGC6kkE4MjMQ@mail.gmail.com>
Date:   Fri, 10 Jul 2020 21:23:21 +0200
Message-ID: <87a7079nti.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 12:02 AM CEST, Andrii Nakryiko wrote:
> On Thu, Jul 9, 2020 at 5:49 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Thu, Jul 09, 2020 at 05:44 AM CEST, Andrii Nakryiko wrote:
>> > On Thu, Jul 2, 2020 at 2:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >>
>> >> Extend the BPF netns link callbacks to rebuild (grow/shrink) or update the
>> >> prog_array at given position when link gets attached/updated/released.
>> >>
>> >> This let's us lift the limit of having just one link attached for the new
>> >> attach type introduced by subsequent patch.
>> >>
>> >> No functional changes intended.
>> >>
>> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> ---
>> >>
>> >> Notes:
>> >>     v3:
>> >>     - New in v3 to support multi-prog attachments. (Alexei)
>> >>
>> >>  include/linux/bpf.h        |  4 ++
>> >>  kernel/bpf/core.c          | 22 ++++++++++
>> >>  kernel/bpf/net_namespace.c | 88 +++++++++++++++++++++++++++++++++++---
>> >>  3 files changed, 107 insertions(+), 7 deletions(-)
>> >>
>> >> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
>> >> index 3d2ade703a35..26bc70533db0 100644
>> >> --- a/include/linux/bpf.h
>> >> +++ b/include/linux/bpf.h
>> >> @@ -928,6 +928,10 @@ int bpf_prog_array_copy_to_user(struct bpf_prog_array *progs,
>> >>
>> >>  void bpf_prog_array_delete_safe(struct bpf_prog_array *progs,
>> >>                                 struct bpf_prog *old_prog);
>> >> +void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
>> >> +                                  unsigned int index);
>> >> +void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
>> >> +                             struct bpf_prog *prog);
>> >>  int bpf_prog_array_copy_info(struct bpf_prog_array *array,
>> >>                              u32 *prog_ids, u32 request_cnt,
>> >>                              u32 *prog_cnt);
>> >> diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
>> >> index 9df4cc9a2907..d4b3b9ee6bf1 100644
>> >> --- a/kernel/bpf/core.c
>> >> +++ b/kernel/bpf/core.c
>> >> @@ -1958,6 +1958,28 @@ void bpf_prog_array_delete_safe(struct bpf_prog_array *array,
>> >>                 }
>> >>  }
>> >>
>> >> +void bpf_prog_array_delete_safe_at(struct bpf_prog_array *array,
>> >> +                                  unsigned int index)
>> >> +{
>> >> +       bpf_prog_array_update_at(array, index, &dummy_bpf_prog.prog);
>> >> +}
>> >> +
>> >> +void bpf_prog_array_update_at(struct bpf_prog_array *array, unsigned int index,
>> >> +                             struct bpf_prog *prog)
>> >
>> > it's a good idea to mention it in a comment for both delete_safe_at
>> > and update_at that slots with dummy entries are ignored.
>>
>> I agree. These two need doc comments. update_at doesn't event hint that
>> this is not a regular update operation. Will add in v4.
>>
>> >
>> > Also, given that index can be out of bounds, should these functions
>> > actually return error if the slot is not found?
>>
>> That won't hurt. I mean, from bpf-netns PoV getting such an error would
>> indicate that there is a bug in the code that manages prog_array. But
>> perhaps other future users of this new prog_array API can benefit.
>>
>> >
>> >> +{
>> >> +       struct bpf_prog_array_item *item;
>> >> +
>> >> +       for (item = array->items; item->prog; item++) {
>> >> +               if (item->prog == &dummy_bpf_prog.prog)
>> >> +                       continue;
>> >> +               if (!index) {
>> >> +                       WRITE_ONCE(item->prog, prog);
>> >> +                       break;
>> >> +               }
>> >> +               index--;
>> >> +       }
>> >> +}
>> >> +
>> >>  int bpf_prog_array_copy(struct bpf_prog_array *old_array,
>> >>                         struct bpf_prog *exclude_prog,
>> >>                         struct bpf_prog *include_prog,
>> >> diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
>> >> index 247543380fa6..6011122c35b6 100644
>> >> --- a/kernel/bpf/net_namespace.c
>> >> +++ b/kernel/bpf/net_namespace.c
>> >> @@ -36,11 +36,51 @@ static void netns_bpf_run_array_detach(struct net *net,
>> >>         bpf_prog_array_free(run_array);
>> >>  }
>> >>
>> >> +static unsigned int link_index(struct net *net,
>> >> +                              enum netns_bpf_attach_type type,
>> >> +                              struct bpf_netns_link *link)
>> >> +{
>> >> +       struct bpf_netns_link *pos;
>> >> +       unsigned int i = 0;
>> >> +
>> >> +       list_for_each_entry(pos, &net->bpf.links[type], node) {
>> >> +               if (pos == link)
>> >> +                       return i;
>> >> +               i++;
>> >> +       }
>> >> +       return UINT_MAX;
>> >
>> > Why not return a negative error, if the slot is not found? Feels a bit
>> > unusual as far as error reporting goes.
>>
>> Returning uint played well with the consumer of link_index() return
>> value, that is bpf_prog_array_update_at(). update at takes an index into
>> the array, which must not be negative.
>
> Yeah, it did, but it's also quite implicit. I think just doing
> BUG_ON() for update_at or delete_at would be good enough there.

BUG_ON got deprecated [0], but I will WARN.

[0] https://www.kernel.org/doc/html/latest/process/deprecated.html#bug-and-bug-on

[...]
