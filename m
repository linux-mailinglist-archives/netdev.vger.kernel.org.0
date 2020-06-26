Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FD9C20BC49
	for <lists+netdev@lfdr.de>; Sat, 27 Jun 2020 00:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726008AbgFZWPw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 18:15:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725852AbgFZWPw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 18:15:52 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 468F4C03E979;
        Fri, 26 Jun 2020 15:15:52 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id o38so8665102qtf.6;
        Fri, 26 Jun 2020 15:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tvKAOhqSkH1kVxnAWsMOooM0tK/9pcmWBxtwkslUDWY=;
        b=iXSbgvSsrpHE8VacUnaenru4F7slMEtM0HZaPWGM59r0G8qHw11QqhXM0RjXdjsol6
         lv/1zlB4x8r2CEfiix03k53AGqsZZbSypbvyO9aE6ptvjS90pkpfCFk+DmaJ0Hsrqg6s
         YBEKG/weT6ntsYUtzS60k52v0BOQSycPfCqrdkl0tstKHqow2RmCU0SlI7jRcgVd0TqJ
         CWkypRYyckJP2fsuISJkLsvrTyVP6hnlaWscUUs4A9x+lQ6bfEBRzSvelpZxlVtc3B0u
         uwWu9fG2rm4XgupMBr2RblfGqTtubBAlIBBBU4N1VSQvoQUNK0fINJtR2C/M8ub1CPza
         3/vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tvKAOhqSkH1kVxnAWsMOooM0tK/9pcmWBxtwkslUDWY=;
        b=NZAD1BJ6g79zAUpHLeh7RKWP3yy4Zf3P06wjKpKRyXlouL022mSakvuvJ4YwDID/Xk
         HmsgO6te21MhEMA2D1Rzpthy5CC0WTt2KQU+ulGoKGhjJI/i+fW/rwM9gx0ThCa1ZIyJ
         znireZZtemtbE4Za5X9i4n/zKupTmriwcsZxDa42mhIu2hMXvuoImbwKUi8VT0cN+xUZ
         yes75IAkHizOlaNUWFCYO/siJ17SD5ojOYytglZnaLpSM2CyPzRH7iSIiOCWQPIojTwE
         iuXYw5U85pGCRM12EQ9tMArHznhEDlPH/aZGV+blx3GDp31ljXZpJv4/FtUZJqNnTlIG
         CDeQ==
X-Gm-Message-State: AOAM5319962nxDbzMZlB4P02Ng8M8mnT9ACGheXLO0+yUM7b/YJVkTAV
        ghGyyyMT59ecJKvrwD9NzlBdPhrUbkJq0gwA7g4=
X-Google-Smtp-Source: ABdhPJzsJj/tilxMC0Huj//M6MSqliTjJ59CWX7mmx0iG1P+YOSvTp7bMrOsLvYjGCb0etsRk4BnDDJruic1+tvzg78=
X-Received: by 2002:ac8:19c4:: with SMTP id s4mr800782qtk.117.1593209751465;
 Fri, 26 Jun 2020 15:15:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200625141357.910330-1-jakub@cloudflare.com> <20200625141357.910330-3-jakub@cloudflare.com>
 <CAEf4Bzar93mCMm5vgMiYu6_m2N=icv2Wgmy2ohuKoQr810Kk1w@mail.gmail.com>
 <87imfema7n.fsf@cloudflare.com> <CAEf4BzbW+xVRmxhmm35CbArzXTTaXJ_ByK2UKB3XCnvwhNE7xg@mail.gmail.com>
In-Reply-To: <CAEf4BzbW+xVRmxhmm35CbArzXTTaXJ_ByK2UKB3XCnvwhNE7xg@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 15:15:40 -0700
Message-ID: <CAEf4Bza+LMb+ewvsVasOJhv-KLvri-wHS64ndZmuYf7hD_Oo9Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 2/4] bpf, netns: Keep attached programs in bpf_prog_array
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 3:13 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Jun 26, 2020 at 2:45 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >
> > On Thu, Jun 25, 2020 at 10:50 PM CEST, Andrii Nakryiko wrote:
> > > On Thu, Jun 25, 2020 at 7:17 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> > >>
> > >> Prepare for having multi-prog attachments for new netns attach types by
> > >> storing programs to run in a bpf_prog_array, which is well suited for
> > >> iterating over programs and running them in sequence.
> > >>
> > >> After this change bpf(PROG_QUERY) may block to allocate memory in
> > >> bpf_prog_array_copy_to_user() for collected program IDs. This forces a
> > >> change in how we protect access to the attached program in the query
> > >> callback. Because bpf_prog_array_copy_to_user() can sleep, we switch from
> > >> an RCU read lock to holding a mutex that serializes updaters.
> > >>
> > >> Because we allow only one BPF flow_dissector program to be attached to
> > >> netns at all times, the bpf_prog_array pointed by net->bpf.run_array is
> > >> always either detached (null) or one element long.
> > >>
> > >> No functional changes intended.
> > >>
> > >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> > >> ---
> > >
> > > I wonder if instead of NULL prog_array, it's better to just use a
> > > dummy empty (but allocated) array. Might help eliminate some of the
> > > IFs, maybe even in the hot path.
> >
> > That was my initial approach, which I abandoned seeing that it leads to
> > replacing NULL prog_array checks in flow_dissector with
> > bpf_prog_array_is_empty() checks to determine which netns has a BPF
> > program attached. So no IFs gone there.
> >
> > While on the hot path, where we run the program, we probably would still
> > be left with an IF checking for empty prog_array to avoid building the
> > context if no progs will RUN.
> >
> > The checks I'm referring to are on attach path, in
> > flow_dissector_bpf_prog_attach_check(), and hot-path,
> > __skb_flow_dissect().
> >
>
> Fair enough.
>

Acked-by: Andrii Nakryiko <andriin@fb.com>
