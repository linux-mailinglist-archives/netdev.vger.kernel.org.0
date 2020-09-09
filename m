Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 084C3263698
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 21:25:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgIITZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 15:25:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726184AbgIITZY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 15:25:24 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09B95C061573;
        Wed,  9 Sep 2020 12:25:23 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id x8so2510334ybm.3;
        Wed, 09 Sep 2020 12:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wyzDLyY4k3lhhyfUcNsRSImNxXW952jRT3/3oirpdp8=;
        b=TM7DA9epLanpngvVGbZFPdXIRr2/TtUBJnUyvgsuSAzL+pYjsj7a7GA9Y8KETTZvkH
         pHedXw06DeryyZ2pv92w4d7ombC/LHR8ZZ2Z4oqhXEQVizuOVpSljWT+8E7rmlBQk8Pv
         pAawv07y6MPZz9pZExcHE2juj7kETW2zBArmDIYvGNCpPRwhq3hbLIsqQgjwEYMwglHt
         8F56YI2d4/jXIrulxv+ZOkYtZKEMbaTRvyXEAN4sghc+OZ8YsZw2I8/8EEYkFkJ+9Kcq
         qfQ57sXtDbcoYVMg9xWXjjL1VrE6vT+atZK1znwQuz8BlYHqUloITefUZLzN80zaOV6N
         4NTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wyzDLyY4k3lhhyfUcNsRSImNxXW952jRT3/3oirpdp8=;
        b=M3Hc3D+qnGZ+xqTkTdUu0IFDFx7WNarDkuWWf7bVoha4lFriuNrfmeWbFjhrCR7EOP
         c/I73tC7dzkIc1KNgK6UxAObpN1WF51EV5+1Uro/dhJIHOwBtKZMG+6DDUFparUKognl
         s0bbxhJ+dVG/pJ8DKHZqHaI4spyQMvMbSH3iG5kzyF5ibOHSroUSR3f8X4u167Hh9a3S
         PDKQe6L7lCYNJBa0Z87Oza/q+zT2qCazHSKq6EKRkpkdCySuncqocGglLG044Bfyvxd/
         Ex17kLxQqVYzMdPCUEHQx7DrJi+xeB5pFA3SBlmpT1h3ipqoNZsdW0YfbPENqR+gTCHn
         MJTA==
X-Gm-Message-State: AOAM5328n5wMmROB94YiGskJ3OfwFYnY5tZocxv/Lm7kaQs5oHIfSg9T
        r41Lr9YwVk+6QwC3GQuPth/G+FwYkbqQN4OyGEYDSQI6
X-Google-Smtp-Source: ABdhPJx2KtzsBWY5wn69hGs8WLuWBDznLZ7l8uIwl8IK22usFMCdRvfQ3tkjw4Cw+wwyidzYTbZyUvVL4WKWiEYSC3w=
X-Received: by 2002:a25:c049:: with SMTP id c70mr8001739ybf.403.1599679522505;
 Wed, 09 Sep 2020 12:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20200907163634.27469-1-quentin@isovalent.com> <20200907163634.27469-2-quentin@isovalent.com>
 <CAEf4Bzb8QLVdjBY9hRCP7QdnqE-JwWqDn8hFytOL40S=Z+KW-w@mail.gmail.com>
 <b89b4bbd-a28e-4dde-b400-4d64fc391bfe@isovalent.com> <CAEf4Bzb0SdZBfDfd2ZBXOBgpneAc6mKFhzULj_Msd0MoNSG5ng@mail.gmail.com>
 <5a002828-c082-3cd7-9ee3-7d783cce2a2a@isovalent.com> <CAEf4BzZA3Zcf9imXVEQ_x0cTiC8JV8jXV-iaaQC+NP4mqt_V_Q@mail.gmail.com>
 <997410b6-7428-173c-8197-ac9eae036e34@isovalent.com>
In-Reply-To: <997410b6-7428-173c-8197-ac9eae036e34@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 12:25:11 -0700
Message-ID: <CAEf4BzYcG-893GAo_NeTKYBwpFFwi9joccasMH-AvSSeb07Xgw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] tools: bpftool: clean up function to dump
 map entry
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 9:59 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> On 09/09/2020 17:46, Andrii Nakryiko wrote:
> > On Wed, Sep 9, 2020 at 9:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> On 09/09/2020 17:30, Andrii Nakryiko wrote:
> >>> On Wed, Sep 9, 2020 at 1:19 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>>>
> >>>> On 09/09/2020 04:25, Andrii Nakryiko wrote:
> >>>>> On Mon, Sep 7, 2020 at 9:36 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>>>>>
> >>>>>> The function used to dump a map entry in bpftool is a bit difficult to
> >>>>>> follow, as a consequence to earlier refactorings. There is a variable
> >>>>>> ("num_elems") which does not appear to be necessary, and the error
> >>>>>> handling would look cleaner if moved to its own function. Let's clean it
> >>>>>> up. No functional change.
> >>>>>>
> >>>>>> v2:
> >>>>>> - v1 was erroneously removing the check on fd maps in an attempt to get
> >>>>>>   support for outer map dumps. This is already working. Instead, v2
> >>>>>>   focuses on cleaning up the dump_map_elem() function, to avoid
> >>>>>>   similar confusion in the future.
> >>>>>>
> >>>>>> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >>>>>> ---
> >>>>>>  tools/bpf/bpftool/map.c | 101 +++++++++++++++++++++-------------------
> >>>>>>  1 file changed, 52 insertions(+), 49 deletions(-)
> >>>>>>
> >>>>>> diff --git a/tools/bpf/bpftool/map.c b/tools/bpf/bpftool/map.c
> >>>>>> index bc0071228f88..c8159cb4fb1e 100644
> >>>>>> --- a/tools/bpf/bpftool/map.c
> >>>>>> +++ b/tools/bpf/bpftool/map.c
> >>>>>> @@ -213,8 +213,9 @@ static void print_entry_json(struct bpf_map_info *info, unsigned char *key,
> >>>>>>         jsonw_end_object(json_wtr);
> >>>>>>  }
> >>>>>>
> >>>>>> -static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> >>>>>> -                             const char *error_msg)
> >>>>>> +static void
> >>>>>> +print_entry_error_msg(struct bpf_map_info *info, unsigned char *key,
> >>>>>> +                     const char *error_msg)
> >>>>>>  {
> >>>>>>         int msg_size = strlen(error_msg);
> >>>>>>         bool single_line, break_names;
> >>>>>> @@ -232,6 +233,40 @@ static void print_entry_error(struct bpf_map_info *info, unsigned char *key,
> >>>>>>         printf("\n");
> >>>>>>  }
> >>>>>>
> >>>>>> +static void
> >>>>>> +print_entry_error(struct bpf_map_info *map_info, void *key, int lookup_errno)
> >>>>>> +{
> >>>>>> +       /* For prog_array maps or arrays of maps, failure to lookup the value
> >>>>>> +        * means there is no entry for that key. Do not print an error message
> >>>>>> +        * in that case.
> >>>>>> +        */
> >>>>>
> >>>>> this is the case when error is ENOENT, all the other ones should be
> >>>>> treated the same, no?
> >>>>
> >>>> Do you mean all map types should be treated the same? If so, I can
> >>>> remove the check below, as in v1. Or do you mean there is a missing
> >>>> check on the error value? In which case I can extend this check to
> >>>> verify we have ENOENT.
> >>>
> >>> The former, probably. I don't see how map-in-map is different for
> >>> lookups and why it needs special handling.
> >>
> >> I didn't find a particular reason in the logs. My guess is that they may
> >> be more likely to have "empty" entries than other types, and that it
> >> might be more difficult to spot the existing entries in the middle of a
> >> list of "<no entry>" messages.
> >>
> >> But I agree, let's get rid of this special case and have the same output
> >> for all types. I'll respin.
> >
> > Oh, wait, I think what I had in mind is to special case ENOENT for
> > map-in-map and just skip those. So yeah, sorry, there is still a bit
> > of a special handling, but **only** for -ENOENT. When I was replying I
> > forgot bpftool emits "<no entry>" for each -ENOENT by default.
>
> So do you prefer me to extend the check with errno == -ENOENT? Or shall
> I remove it entirely and just have the "<no entry>" messages like for
> the other map types?

Extend with -ENOENT check.

>
> Quentin
