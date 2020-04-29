Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18661BD46A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgD2GIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:08:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726274AbgD2GIj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:08:39 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4B01C03C1AD;
        Tue, 28 Apr 2020 23:08:38 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e17so947590qtp.7;
        Tue, 28 Apr 2020 23:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZVRbCtzs6vAQeXIXG4o5EPkwkL3aXEQu07SH9I3Ud5I=;
        b=qJfB9jiNPDKYPrTm6u9oEk5v5eEwhc9Nz+A31FClyM5nJoiukHUkAPxO8FjbHIQ2z0
         ZpFIXI6FScXecUPrh5l5DcRbqP01auqM7X/0qUD/gJdfiJ2FoA2nzV4QmraLih+G3E9O
         gkyTc14FZl9xrcsfwpmAvM+D2Cr0OzMYIlDthLMRjJris3pd9AlkqXvjPMFMYUzXMWNu
         Ub2A3vYetrQg6kUo082nju/7m9zLybXyqD939OyowhSXZBOr7rDem+hOT43HNPLtrKKB
         SbGgwfFdCuhLfhtCZQDoBvhkc3aP/uB5+rKTYiT+nbhkSdSihN0vPkzkcvitiZ0EyML4
         v3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZVRbCtzs6vAQeXIXG4o5EPkwkL3aXEQu07SH9I3Ud5I=;
        b=fBKNXekIvJlnzG43FAUrz7RqosmCn56S57WZth1HH34JEih8BVwRnMlIj+ctZMFwtj
         B6EUTWWvlHx0Pvh5necA9yNf5SRFWxNHJjlNAeyQMNkK/vIyOS2snrHj8smhETkqLocW
         Rn6j+nY5x1Yamr7zjgmBrkzwih9ZNocSaopihXK28ViD53oNNfmx9pJ/uCucLWls8f0G
         CrXr4nCYaudeKRMzkyhg7NFQDcDQKgHLiYs2cv1DFnA7ndYX7esjGf1wuWhA/Ll8lTlD
         kU85GSWrdKdM7g88UOkjXuOa95ImYYTpOPnO1t/DrvB4XvTW+H8g2ig6u7KNbm/xa1b2
         8DYg==
X-Gm-Message-State: AGi0PuY3pG+xIN/rb4q+Z7dFtFkq92EENiqXr0FflYcCbc764lIYNEEZ
        +SqIpG1x4z3m4vkOdFTWjNNNl34V37mL7PRrcs8=
X-Google-Smtp-Source: APiQypICWcTnsrEMXwJ4I3jcHLxWSiiKCqa+s/vK7cQYeWB3VW2agteB9p2LBlbAnEpcD3JLUkjuEOFQifCNwbwNjAI=
X-Received: by 2002:aed:2e24:: with SMTP id j33mr32361826qtd.117.1588140518100;
 Tue, 28 Apr 2020 23:08:38 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp> <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com> <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com>
In-Reply-To: <7f15274d-46dd-f43f-575e-26a40032f900@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 23:08:27 -0700
Message-ID: <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v1 03/19] bpf: add bpf_map iterator
To:     Yonghong Song <yhs@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
>
>
>
> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
> > On 4/28/20 6:15 PM, Yonghong Song wrote:
> >>
> >>
> >> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
> >>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
> >>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
> >>>>> bpf_iter_seq_map_info),
> >>>>> +                 &meta.session_id, &meta.seq_num,
> >>>>> +                 v == (void *)0);
> >>>>  From looking at seq_file.c, when will show() be called with "v ==
> >>>> NULL"?
> >>>>
> >>>
> >>> that v == NULL here and the whole verifier change just to allow NULL...
> >>> may be use seq_num as an indicator of the last elem instead?
> >>> Like seq_num with upper bit set to indicate that it's last?
> >>
> >> We could. But then verifier won't have an easy way to verify that.
> >> For example, the above is expected:
> >>
> >>       int prog(struct bpf_map *map, u64 seq_num) {
> >>          if (seq_num >> 63)
> >>            return 0;
> >>          ... map->id ...
> >>          ... map->user_cnt ...
> >>       }
> >>
> >> But if user writes
> >>
> >>       int prog(struct bpf_map *map, u64 seq_num) {
> >>           ... map->id ...
> >>           ... map->user_cnt ...
> >>       }
> >>
> >> verifier won't be easy to conclude inproper map pointer tracing
> >> here and in the above map->id, map->user_cnt will cause
> >> exceptions and they will silently get value 0.
> >
> > I mean always pass valid object pointer into the prog.
> > In above case 'map' will always be valid.
> > Consider prog that iterating all map elements.
> > It's weird that the prog would always need to do
> > if (map == 0)
> >    goto out;
> > even if it doesn't care about finding last.
> > All progs would have to have such extra 'if'.
> > If we always pass valid object than there is no need
> > for such extra checks inside the prog.
> > First and last element can be indicated via seq_num
> > or via another flag or via helper call like is_this_last_elem()
> > or something.
>
> Okay, I see what you mean now. Basically this means
> seq_ops->next() should try to get/maintain next two elements,

What about the case when there are no elements to iterate to begin
with? In that case, we still need to call bpf_prog for (empty)
post-aggregation, but we have no valid element... For bpf_map
iteration we could have fake empty bpf_map that would be passed, but
I'm not sure it's applicable for any time of object (e.g., having a
fake task_struct is probably quite a bit more problematic?)...

> otherwise, we won't know whether the one in seq_ops->show()
> is the last or not. We could do it in newly implemented
> iterator bpf_map/task/task_file. Let me check how I could
> make existing seq_ops (ipv6_route/netlink) works with
> minimum changes.
