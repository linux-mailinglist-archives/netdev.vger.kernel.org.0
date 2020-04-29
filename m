Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE5CA1BD4C3
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 08:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgD2Gkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 02:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgD2Gkm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 02:40:42 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB951C03C1AD;
        Tue, 28 Apr 2020 23:40:41 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id h124so926009qke.11;
        Tue, 28 Apr 2020 23:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L7obp+PNqVPPCZQThwJNHDeDSBKUPs9ERaTUcmz97ZU=;
        b=gF6bW45F9fpx55zrsxC3gM9fyW86mZsZU/P7/u2Gm92kt4K36vJ8lH/Og8cx4y46/e
         cbqUAf0zCuteCeCVqiN3ZyWn8xnSuq4+z1X767cE7Cq6NiO8ZR4BHKFDP2vEL0ZKpT5U
         NYA/iEme9wr94wEr8CjMkUVomNjBWZfM9pwTr/GfmUTMzJotRnflsrf/yU71fH8wemzv
         W6nrjQuyC5fkkE4j+KS7iG09uZE15IaFct9DbFiN4+nU1sg5bT4OR/fIB8nHdDgVb14T
         mFKObTygwKDCOUjxu5oSJaaV0eZidNcIG9Pn8nl+B0Vh+l5gbugPbrJSShjNFd7NRACg
         wooQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L7obp+PNqVPPCZQThwJNHDeDSBKUPs9ERaTUcmz97ZU=;
        b=cd4qmIpb3wVg/QLlLRXD55rSZNW/aaMFd8Bpy6rj9KFWtn0cQrtKtjiDsWp2V7pOVz
         AKvgur0zW7rbFNgmiFKsF7gBjo0z4PASREA2I3zVNlQ//T7z06aUuvfsVz4zsdhBZlOb
         AqPTYTinUMNM0zmeDIu5+WpMQ7HHX/f3yVt0cwn6eP3cuJOq3+j5bNdKoPYhk6oUrhdD
         uiWjeDs9pAG2v36Qq+23JKv1VdmPNnfMWGoSwSraLTRhRO+q/h8cvKujdTQziXx9YzK5
         9PYxA52/mZB9CKrLzSDsvvU8tJ8P9AoLGd8xWvGY1WnE9uKekVwx9/H8bNxN/zI6aTro
         +P4Q==
X-Gm-Message-State: AGi0PuaL2zscmR0ivjTgF7CvGIheAg1cj0jFOCKE2eqRgP8yp8QO3Fj/
        XnlCVbheF/sVxkF55lRFM92jTwvSCU3ugK0wTSc=
X-Google-Smtp-Source: APiQypJ+bLMIxQdbp3dV7tjlJc1CjnFDunjOH/5Y8g3Tt1fkfGBjBHIO+8qcZ/qNC3KhQi1ZTjr/I52NNhxzaXVIvt8=
X-Received: by 2002:ae9:eb8c:: with SMTP id b134mr31739256qkg.39.1588142441108;
 Tue, 28 Apr 2020 23:40:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200427201235.2994549-1-yhs@fb.com> <20200427201237.2994794-1-yhs@fb.com>
 <20200429003738.pv4flhdaxpg66wiv@kafai-mbp> <3df31c9a-2df7-d76a-5e54-b2cd48692883@fb.com>
 <a5255338-94e8-3f4b-518e-e7f7146f69f2@fb.com> <65a83b48-3965-5ae9-fafd-3e8836b03d2c@fb.com>
 <7f15274d-46dd-f43f-575e-26a40032f900@fb.com> <CAEf4BzaCVZem4O9eR9gBTO5c+PHy5zE8BdLD2Aa-PCLHC4ywRg@mail.gmail.com>
 <401b5bd2-dc43-4465-1232-34428a1b3e4e@fb.com> <f9a3590f-1fd3-2151-5b52-4e7ddc0da934@fb.com>
In-Reply-To: <f9a3590f-1fd3-2151-5b52-4e7ddc0da934@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Apr 2020 23:40:30 -0700
Message-ID: <CAEf4BzY1eycQ81h+nFKUhwAjCERAmAZhKXyHDAF2Sm4Gsb9UMw@mail.gmail.com>
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

On Tue, Apr 28, 2020 at 11:30 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 4/28/20 11:20 PM, Yonghong Song wrote:
> >
> >
> > On 4/28/20 11:08 PM, Andrii Nakryiko wrote:
> >> On Tue, Apr 28, 2020 at 10:10 PM Yonghong Song <yhs@fb.com> wrote:
> >>>
> >>>
> >>>
> >>> On 4/28/20 7:44 PM, Alexei Starovoitov wrote:
> >>>> On 4/28/20 6:15 PM, Yonghong Song wrote:
> >>>>>
> >>>>>
> >>>>> On 4/28/20 5:48 PM, Alexei Starovoitov wrote:
> >>>>>> On 4/28/20 5:37 PM, Martin KaFai Lau wrote:
> >>>>>>>> +    prog = bpf_iter_get_prog(seq, sizeof(struct
> >>>>>>>> bpf_iter_seq_map_info),
> >>>>>>>> +                 &meta.session_id, &meta.seq_num,
> >>>>>>>> +                 v == (void *)0);
> >>>>>>>   From looking at seq_file.c, when will show() be called with "v ==
> >>>>>>> NULL"?
> >>>>>>>
> >>>>>>
> >>>>>> that v == NULL here and the whole verifier change just to allow
> >>>>>> NULL...
> >>>>>> may be use seq_num as an indicator of the last elem instead?
> >>>>>> Like seq_num with upper bit set to indicate that it's last?
> >>>>>
> >>>>> We could. But then verifier won't have an easy way to verify that.
> >>>>> For example, the above is expected:
> >>>>>
> >>>>>        int prog(struct bpf_map *map, u64 seq_num) {
> >>>>>           if (seq_num >> 63)
> >>>>>             return 0;
> >>>>>           ... map->id ...
> >>>>>           ... map->user_cnt ...
> >>>>>        }
> >>>>>
> >>>>> But if user writes
> >>>>>
> >>>>>        int prog(struct bpf_map *map, u64 seq_num) {
> >>>>>            ... map->id ...
> >>>>>            ... map->user_cnt ...
> >>>>>        }
> >>>>>
> >>>>> verifier won't be easy to conclude inproper map pointer tracing
> >>>>> here and in the above map->id, map->user_cnt will cause
> >>>>> exceptions and they will silently get value 0.
> >>>>
> >>>> I mean always pass valid object pointer into the prog.
> >>>> In above case 'map' will always be valid.
> >>>> Consider prog that iterating all map elements.
> >>>> It's weird that the prog would always need to do
> >>>> if (map == 0)
> >>>>     goto out;
> >>>> even if it doesn't care about finding last.
> >>>> All progs would have to have such extra 'if'.
> >>>> If we always pass valid object than there is no need
> >>>> for such extra checks inside the prog.
> >>>> First and last element can be indicated via seq_num
> >>>> or via another flag or via helper call like is_this_last_elem()
> >>>> or something.
> >>>
> >>> Okay, I see what you mean now. Basically this means
> >>> seq_ops->next() should try to get/maintain next two elements,
> >>
> >> What about the case when there are no elements to iterate to begin
> >> with? In that case, we still need to call bpf_prog for (empty)
> >> post-aggregation, but we have no valid element... For bpf_map
> >> iteration we could have fake empty bpf_map that would be passed, but
> >> I'm not sure it's applicable for any time of object (e.g., having a
> >> fake task_struct is probably quite a bit more problematic?)...
> >
> > Oh, yes, thanks for reminding me of this. I put a call to
> > bpf_prog in seq_ops->stop() especially to handle no object
> > case. In that case, seq_ops->start() will return NULL,
> > seq_ops->next() won't be called, and then seq_ops->stop()
> > is called. My earlier attempt tries to hook with next()
> > and then find it not working in all cases.
>
> wait a sec. seq_ops->stop() is not the end.
> With lseek of seq_file it can be called multiple times.

We don't allow seeking on seq_file created from bpf_iter_link, so
there should be no lseek'ing?

> What's the point calling bpf prog with NULL then?

To know that iteration has ended, even if there were 0 elements to
iterate. 0, 1 or N doesn't matter, we might still need to do some
final actions (e.g., submit or print summary).
