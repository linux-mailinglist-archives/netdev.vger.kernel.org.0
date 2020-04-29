Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5CD1BE72F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbgD2TTb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:19:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2TTb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:19:31 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1D3CC03C1AE;
        Wed, 29 Apr 2020 12:19:30 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id s9so523319qkm.6;
        Wed, 29 Apr 2020 12:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rb3422ttOBij7J0YT2NSxuRhR/fHI39v4dvdBi0OV1s=;
        b=Vvop9MxV8AWQr49mXgnPXNG9N5XPe9zm9yt9/E8Z7nYikfdb/abS4uJVZNXwPyhFBh
         vJRxPueKma1bbfACTXSP2Hz/Tq/ngCs6hSzGDzYjGZHOqrOcgDoMZAO3dzQswVnaLZsI
         j70rXbgZpejGxzaiWw2MrpPTlt1zxVxJY09scrQ8seM/zrJc4l3l3SFMMKVVh4/LwUQh
         ihc3MpLbvhlbHm+nUlbslWzeG32pNcfbi6ANTpDJNHdNdt3vUz6DcgEcqkxr6iLMXE+G
         Rd32sT+bEbYX+egYDKlraocxJX0DZoRw/Ej3nSBLH9nkeWXZj0Q1EMLAomrnkVP8d23g
         QdGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rb3422ttOBij7J0YT2NSxuRhR/fHI39v4dvdBi0OV1s=;
        b=Ugtb++8c7PneEwgm/SfNMgAU4sYZFTSKuPNr1t/AGJI4XXgPwryEMiOYdtlvRicYa1
         +rUjruycYTMcPrlYV/U9xQITgux8DxFwkFZbAsFPjAsWP9THwKLas4e3WMIAoMMx7vpZ
         82Mij50dBjlf5tUquW6C4jLEdjSF2+FpPJnyPbOrZQdVWMW0Ht7NdnPaELvJz+Lfj35Q
         cokVtay+mEP0bvweO71kLNLQzCDEZKGTFSx4vtJB9zerBKUSmhRTZOtClnl+1TxcWIMq
         I0UmW6pm6+L4iasyBoWzAvMrx7By0kvCXUBZo+ZrgnLvhqd26yK6xMy+rz3p9OVSidpk
         lRpA==
X-Gm-Message-State: AGi0PubGWdmmhCmPOFfLWtBPXiliCYPp2z0+etPAQDdVcS9C1Tr8gngJ
        vB9xQSXcA6GWLoe1PCeZoeXlKfpAN64MpTTcbPMsDdNx
X-Google-Smtp-Source: APiQypJfnHqKbOOHR+A7LJKPJTZ3CvIqgbAyw7K1tUi5zpKtYzsgguC1ADUwDQMQSs4ZwhhNL82cgFxvHhNLylxYsWE=
X-Received: by 2002:a37:6587:: with SMTP id z129mr36016548qkb.437.1588187969914;
 Wed, 29 Apr 2020 12:19:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp> <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com> <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com> <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
 <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com> <f9a3590f-1fd3-2151-5b52-4e7ddc0da934@fb.com>
 <CAEf4BzY1eycQ81h+nFKUhwAjCERAmAZhKXyHDAF2Sm4Gsb9UMw@mail.gmail.com>
 <b070519a-0956-01bb-35d9-3ced12e0cd11@fb.com> <2be3cd4a-cf55-2eeb-c33b-a25135defceb@fb.com>
In-Reply-To: <2be3cd4a-cf55-2eeb-c33b-a25135defceb@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 29 Apr 2020 12:19:18 -0700
Message-ID: <CAEf4BzZgZ7h_asHNGk_34vJv_yvLtWGcTGwdTO4fgLPySaG-Eg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 8:34 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 4/28/20 11:44 PM, Yonghong Song wrote:
> >
> >
> > On 4/28/20 11:40 PM, Andrii Nakryiko wrote:
> >> On Tue, Apr 28, 2020 at 11:30 PM Alexei Starovoitov <ast@fb.com> wrote:
> >>>
> >>> On 4/28/20 11:20 PM, Yonghong Song wrote:
> >>>>
> >>>>
> >>>> On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
> >>>>> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
> >>>>>>
> >>>>>>
> >>>>>>
> >>>>>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
> >>>>>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
> >>>>>>>>
> >>>>>>>>
> >>>>>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
> >>>>>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
> >>>>>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
> >>>>>>>>>>> bpf_iter_seq_map_info),
> >>>>>>>>>>> +                 &meta.session_id, &meta.seq_num,
> >>>>>>>>>>> +                 v == (void *)0);
> >>>>>>>>>>    From looking at seq_file.c, when will show() be called with
> >>>>>>>>>> "v ==
> >>>>>>>>>> NULL"?
> >>>>>>>>>>
> >>>>>>>>>
> >>>>>>>>> that v == NULL here and the whole verifier change just to allow
> >>>>>>>>> NULL...
> >>>>>>>>> may be use seq_num as an indicator of the last elem instead?
> >>>>>>>>> Like seq_num with upper bit set to indicate that it's last?
> >>>>>>>>
> >>>>>>>> We could. But then verifier won't have an easy way to verify that.
> >>>>>>>> For example, the above is expected:
> >>>>>>>>
> >>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
> >>>>>>>>            if (seq_num >> 63)
> >>>>>>>>              return 0;
> >>>>>>>>            ... map->id ...
> >>>>>>>>            ... map->user_cnt ...
> >>>>>>>>         }
> >>>>>>>>
> >>>>>>>> But if user writes
> >>>>>>>>
> >>>>>>>>         int prog(struct bpf_map *map, u64 seq_num) {
> >>>>>>>>             ... map->id ...
> >>>>>>>>             ... map->user_cnt ...
> >>>>>>>>         }
> >>>>>>>>
> >>>>>>>> verifier won't be easy to conclude inproper map pointer tracing
> >>>>>>>> here and in the above map->id, map->user_cnt will cause
> >>>>>>>> exceptions and they will silently get value 0.
> >>>>>>>
> >>>>>>> I mean always pass valid object pointer into the prog.
> >>>>>>> In above case 'map' will always be valid.
> >>>>>>> Consider prog that iterating all map elements.
> >>>>>>> It's weird that the prog would always need to do
> >>>>>>> if (map == 0)
> >>>>>>>      goto out;
> >>>>>>> even if it doesn't care about finding last.
> >>>>>>> All progs would have to have such extra 'if'.
> >>>>>>> If we always pass valid object than there is no need
> >>>>>>> for such extra checks inside the prog.
> >>>>>>> First and last element can be indicated via seq_num
> >>>>>>> or via another flag or via helper call like is_this_last_elem()
> >>>>>>> or something.
> >>>>>>
> >>>>>> Okay, I see what you mean now. Basically this means
> >>>>>> seq_ops->next() should try to get/maintain next two elements,
> >>>>>
> >>>>> What about the case when there are no elements to iterate to begin
> >>>>> with? In that case, we still need to call bpf_prog for (empty)
> >>>>> post-aggregation, but we have no valid element... For bpf_map
> >>>>> iteration we could have fake empty bpf_map that would be passed, but
> >>>>> I'm not sure it's applicable for any time of object (e.g., having a
> >>>>> fake task_struct is probably quite a bit more problematic?)...
> >>>>
> >>>> Oh, yes, thanks for reminding me of this. I put a call to
> >>>> bpf_prog in seq_ops->stop() especially to handle no object
> >>>> case. In that case, seq_ops->start() will return NULL,
> >>>> seq_ops->next() won't be called, and then seq_ops->stop()
> >>>> is called. My earlier attempt tries to hook with next()
> >>>> and then find it not working in all cases.
> >>>
> >>> wait a sec. seq_ops->stop() is not the end.
> >>> With lseek of seq_file it can be called multiple times.
> >
> > Yes, I have taken care of this. when the object is NULL,
> > bpf program will be called. When the object is NULL again,
> > it won't be called. The private data remembers it has
> > been called with NULL.
>
> Even without lseek stop() will be called multiple times.
> If I read seq_file.c correctly it will be called before
> every copy_to_user(). Which means that for a lot of text
> (or if read() is done with small buffer) there will be
> plenty of start,show,show,stop sequences.


Right start/stop can be called multiple times, but seems like there
are clear indicators of beginning of iteration and end of iteration:
- start() with seq_num == 0 is start of iteration (can be called
multiple times, if first element overflows buffer);
- stop() with p == NULL is end of iteration (seems like can be called
multiple times as well, if user keeps read()'ing after iteration
completed).

There is another problem with stop(), though. If BPF program will
attempt to output anything during stop(), that output will be just
discarded. Not great. Especially if that output overflows and we need
to re-allocate buffer.

We are trying to use seq_file just to reuse 140 lines of code in
seq_read(), which is no magic, just a simple double buffer and retry
piece of logic. We don't need lseek and traverse, we don't need all
the escaping stuff. I think bpf_iter implementation would be much
simpler if bpf_iter had better control over iteration. Then this whole
"end of iteration" behavior would be crystal clear. Should we maybe
reconsider again?

I understand we want to re-use networking iteration code, but we can
still do that with custom implementation of seq_read, because we are
still using struct seq_file and follow its semantics. The change would
be to allow stop(NULL) (or any stop() call for that matter) to perform
output (and handle retry and buffer re-allocation). Or, alternatively,
coupled with seq_operations intercept proposal in patch #7 discussion,
we can add extra method (e.g., finish()) that would be called after
all elements are traversed and will allow to emit extra stuff. We can
do that (implement finish()) in seq_read, as well, if that's going to
fly ok with seq_file maintainers, of course.
