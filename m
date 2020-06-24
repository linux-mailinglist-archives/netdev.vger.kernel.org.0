Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DB2207BA4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405996AbgFXShM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 14:37:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405914AbgFXShM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 14:37:12 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A83AC0613ED
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 11:37:12 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id b25so85301ljp.6
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 11:37:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=TCdFezLAxuIFeRMQ9JhebSRAgIYY7N1hbNSIjffmr90=;
        b=cv8dIKhanHVtGIezLLmtlB9m7uyfYAAD7TKMppjLafXATdQ7GnhVTXxO162ZqitZFI
         x8EAzHhAnJ0F6VGQhukXvGxqFeRNzcxaCvyNLej60y2/ebtcRUU3umQpgm7pjhnzF3+d
         u6kclpquSYcnxqd5llUOrChNEG8Aa6DvViQSA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=TCdFezLAxuIFeRMQ9JhebSRAgIYY7N1hbNSIjffmr90=;
        b=is28LTGn0N1YdJIDAqv4Xn04Sg5jIFt6fVfhUwR1BXTjIltPkdqkDJQ9wjIIPyM0Vp
         O3uPwdyM7xIOItD8L1zPOGug7Iz2RzsA7pKW0QW5wvcq71TtAPF8K4yUNR79+n91QuuD
         Lxmf5JXfyVgGzugLvz6Q/HFqECE2QvQmy+O79CGqTZ1ldEBEstG8EI8L4nPkH92/2cq+
         X+NkDvRsMdPnWeDdDSJoUfmImzcK+B76rhdASVEyj/mh+diK1aXBOxVXE0Q1JGea9KB0
         6/QWcGl+X0snnZsof1PmsvS5DnP/m9YOdkjASRrcqre/PPS/5kMtZJbPHXbC5djtn0i/
         ABPA==
X-Gm-Message-State: AOAM532zDwrPDi29GwakBPWy3/zMNCZgMcRCM/Tao/EC2xFwR2WTsW4e
        fol3sZbOzGGm9fjnWqcQGWX6aAOHYuGbDQ==
X-Google-Smtp-Source: ABdhPJyc6BwO9sf2g1d19br23n3gpn66w55pQ73gwmjLaoyyLymofT6D3KZIhCZiKRlBobtphc7taA==
X-Received: by 2002:a2e:871a:: with SMTP id m26mr5700467lji.418.1593023830365;
        Wed, 24 Jun 2020 11:37:10 -0700 (PDT)
Received: from cloudflare.com ([2a02:a310:c262:aa00:b35e:8938:2c2a:ba8b])
        by smtp.gmail.com with ESMTPSA id r23sm4329188ljh.86.2020.06.24.11.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 11:37:09 -0700 (PDT)
References: <20200623103459.697774-1-jakub@cloudflare.com> <20200623103459.697774-3-jakub@cloudflare.com> <87o8p8mlfx.fsf@cloudflare.com> <CAEf4BzYZLTYmLcaSrrXptD8fOX3O9TdT2yQcbbGZiaqt6s3k4g@mail.gmail.com> <87lfkcmiw0.fsf@cloudflare.com> <CAEf4BzZYjPL+TmqFfuEFgzm+qUh_T2zHsRZjq-BE+LMu+25=ZQ@mail.gmail.com>
User-agent: mu4e 1.1.0; emacs 26.3
From:   Jakub Sitnicki <jakub@cloudflare.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com, Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf, netns: Keep attached programs in bpf_prog_array
In-reply-to: <CAEf4BzZYjPL+TmqFfuEFgzm+qUh_T2zHsRZjq-BE+LMu+25=ZQ@mail.gmail.com>
Date:   Wed, 24 Jun 2020 20:37:04 +0200
Message-ID: <87k0zwmhtb.fsf@cloudflare.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 24, 2020 at 08:24 PM CEST, Andrii Nakryiko wrote:
> On Wed, Jun 24, 2020 at 11:16 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>>
>> On Wed, Jun 24, 2020 at 07:47 PM CEST, Andrii Nakryiko wrote:
>> > On Wed, Jun 24, 2020 at 10:19 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>> >>
>> >> On Tue, Jun 23, 2020 at 12:34 PM CEST, Jakub Sitnicki wrote:
>> >> > Prepare for having multi-prog attachments for new netns attach types by
>> >> > storing programs to run in a bpf_prog_array, which is well suited for
>> >> > iterating over programs and running them in sequence.
>> >> >
>> >> > Because bpf_prog_array is dynamically resized, after this change a
>> >> > potentially blocking memory allocation in bpf(PROG_QUERY) callback can
>> >> > happen, in order to collect program IDs before copying the values to
>> >> > user-space supplied buffer. This forces us to adapt how we protect access
>> >> > to the attached program in the callback. As bpf_prog_array_copy_to_user()
>> >> > helper can sleep, we switch from an RCU read lock to holding a mutex that
>> >> > serializes updaters.
>> >> >
>> >> > To handle bpf(PROG_ATTACH) scenario when we are replacing an already
>> >> > attached program, we introduce a new bpf_prog_array helper called
>> >> > bpf_prog_array_replace_item that will exchange the old program with a new
>> >> > one. bpf-cgroup does away with such helper by computing an index into the
>> >> > array from a program position in an external list of attached
>> >> > programs/links. Such approach fails when a dummy prog is left in the array
>> >> > after a memory allocation failure on link release, but is necessary in
>> >> > bpf-cgroup case because the same BPF program can be present in the array
>> >> > multiple times due to inheritance, and attachment cannot be reliably
>> >> > identified by bpf_prog pointer comparison.
>> >> >
>> >> > No functional changes intended.
>> >> >
>> >> > Acked-by: Andrii Nakryiko <andriin@fb.com>
>> >> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
>> >> > ---
>> >> >  include/linux/bpf.h        |   3 +
>> >> >  include/net/netns/bpf.h    |   5 +-
>> >> >  kernel/bpf/core.c          |  20 ++++--
>> >> >  kernel/bpf/net_namespace.c | 137 +++++++++++++++++++++++++++----------
>> >> >  net/core/flow_dissector.c  |  21 +++---
>> >> >  5 files changed, 132 insertions(+), 54 deletions(-)
>> >> >
>> >>
>> >> [...]
>> >>
>> >> > diff --git a/kernel/bpf/net_namespace.c b/kernel/bpf/net_namespace.c
>> >> > index b951dab2687f..593523a22168 100644
>> >> > --- a/kernel/bpf/net_namespace.c
>> >> > +++ b/kernel/bpf/net_namespace.c
>> >>
>> >> [...]
>> >>
>> >> > @@ -93,8 +108,16 @@ static int bpf_netns_link_update_prog(struct bpf_link *link,
>> >> >               goto out_unlock;
>> >> >       }
>> >> >
>> >> > +     run_array = rcu_dereference_protected(net->bpf.run_array[type],
>> >> > +                                           lockdep_is_held(&netns_bpf_mutex));
>> >> > +     if (run_array)
>> >> > +             ret = bpf_prog_array_replace_item(run_array, link->prog, new_prog);
>> >>
>> >> Thinking about this some more, link update should fail with -EINVAL if
>> >> new_prog already exists in run_array. Same as PROG_ATTACH fails with
>> >> -EINVAL when trying to attach the same prog for the second time.
>> >>
>> >> Otherwise, LINK_UPDATE can lead to having same BPF prog present multiple
>> >> times in the prog_array, once attaching more than one prog gets enabled.
>> >>
>> >> Then we would we end up with the same challenge as bpf-cgroup, that is
>> >> how to find the program index into the prog_array in presence of
>> >> dummy_prog's.
>> >
>> > If you attach 5 different links having the same bpf_prog, it should be
>> > allowed and all five bpf_progs should be attached and called 5 times.
>> > They are independent links, that's the main thing. What specific BPF
>> > program is attached by the link (or later updated to) shouldn't be of
>> > any concern here (relative to other attached links/programs).
>> >
>> > Attaching the same *link* twice shouldn't be allowed, though.
>>
>> Thanks for clarifying. I need to change the approach then:
>>
>>  1) find the prog index into prog_array by iterating the list of links,
>>  2) adjust the index for any dummy progs in prog_array below the index.
>>
>> That might work for bpf-cgroup too.
>>
>
> I thought that's what bpf-cgroup already does... Except right now
> there could be no dummy progs, but if we do non-failing detachment,
> there might be. Then hierarchies can get out of sync and we need to
> handle that nicely. It's not super straightforward, that's why I said
> that it's a nice challenge to consider :)

Now I get it... bpf-cgroup doesn't use bpf_prog_array_delete_safe(). I
was confusing it with what I saw in bpf_trace all along.

> But here we don't have hierarchy, it's a happy place to be in :)

It feels like there are some war stories to tell about bpf-cgroup.

>> The only other alternative I can think of it to copy the prog array to
>> filter out dummy_progs, before replacing the prog on link update.
>
> Probably over-complication. I'd filter dummy progs only on new link
> attachment or detachment. Update can be kept very simple.

OK, I know what I need to do.

[...]
