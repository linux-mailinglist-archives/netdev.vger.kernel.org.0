Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 564125227D1
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 01:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiEJXvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 19:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238645AbiEJXvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 19:51:08 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD42F366B8
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 16:51:06 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id be20so539998edb.12
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 16:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s7uQP88rm2fFVrAVhakdMnaytPLChwV+spwEqxpvxKE=;
        b=Wvb2Yr5ntSMikIY6rsVTXCZINVsgnvf5OHdXaS5WophjI51WFvB8FsxEaYv1RdGkSy
         ORGLa02GFQN4jWiwyp35UkGxqCVY8hbh1eV9xU7ToJNJzjVWjhEYOqjgamybrHXG8cWb
         TwhAiglLuZCkojR6K6YA46HDyLB6G+PqIX51A=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s7uQP88rm2fFVrAVhakdMnaytPLChwV+spwEqxpvxKE=;
        b=MdKT/BhanABdbs6yACudT84+3zuNOPtFy5+WR+v4eBhzbo6jvCXM7frMg7dKSKT29a
         xSmgz779RUqEiDBdRZULk21NjSlzEON8qSYMpbf/U4Gngz7HQBYeFv4VNU6P5TWTidYF
         lCa6Q0Alfnml7zCz6D0vLjytHV/KK06H5HbEZi3A2AvOH817daoC2ph3iSOdaq/z8scJ
         sgg6eZZc3QwvyCs7pIFRUK/wkrXfocMU2LHLttoSVJvAbvSyZ+nXo43cJpYPsOfSJ43f
         hxc2t43g1vUrks/nngn/b2hXthtgIFvxpOCQ0JxRX5EBtBZJ537FlW98PH8KqiOmA2F1
         Nvyg==
X-Gm-Message-State: AOAM533UCpnzz2jwu3AUSRSJVQzbLgURefthOxCR1fGGy+Guts1s2d43
        WY4IuGqgenS1ZIekQGznOoRzLEgT816VgjgzDPc=
X-Google-Smtp-Source: ABdhPJztD0mzLuuU2JtTw+WUWwXzkbk2Gxpqezb9D/9l3Pzbh/fu/gduE3iJgx/5dcD84NWx5raS9w==
X-Received: by 2002:a05:6402:350f:b0:428:43a1:647d with SMTP id b15-20020a056402350f00b0042843a1647dmr25906845edd.62.1652226665218;
        Tue, 10 May 2022 16:51:05 -0700 (PDT)
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com. [209.85.128.45])
        by smtp.gmail.com with ESMTPSA id b15-20020a170906660f00b006f39ffe23fdsm305624ejp.0.2022.05.10.16.51.03
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 May 2022 16:51:04 -0700 (PDT)
Received: by mail-wm1-f45.google.com with SMTP id bd25-20020a05600c1f1900b0039485220e16so2013262wmb.0
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 16:51:03 -0700 (PDT)
X-Received: by 2002:a1c:4c06:0:b0:394:65c4:bd03 with SMTP id
 z6-20020a1c4c06000000b0039465c4bd03mr2167400wmf.8.1652226663399; Tue, 10 May
 2022 16:51:03 -0700 (PDT)
MIME-Version: 1.0
References: <20220510082351-mutt-send-email-mst@kernel.org>
 <CAHk-=wjPR+bj7P1O=MAQWXp0Mx2hHuNQ1acn6gS+mRo_kbo5Lg@mail.gmail.com> <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
In-Reply-To: <YnrxTMVRtDnGA/EK@dev-arch.thelio-3990X>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 10 May 2022 16:50:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
Message-ID: <CAHk-=wgAk3NEJ2PHtb0jXzCUOGytiHLq=rzjkFKfpiuH-SROgA@mail.gmail.com>
Subject: Re: [GIT PULL] virtio: last minute fixup
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        Netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        mie@igel.co.jp
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 10, 2022 at 4:12 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> For what it's worth, as someone who is frequently tracking down and
> reporting issues, a link to the mailing list post in the commit message
> makes it much easier to get these reports into the right hands, as the
> original posting is going to have all relevant parties in one location
> and it will usually have all the context necessary to triage the
> problem.

Honestly, I think such a thing would be trivial to automate with
something like just a patch-id lookup, rather than a "Link:".

And such a lookup model ("where was this patch posted") would work for
<i>any</i> patch (and often also find previous unmodified versions of
it when it has been posted multiple times).

I suspect that most of the building blocks of such automation
effectively already exists, since I think the lore infrastructure
already integrates with patchwork, and patchwork already has a "look
up by patch id".

Wouldn't it be cool if you had some webby interface to just go from
commit SHA1 to patch ID to a lore.kernel.org lookup of where said
patch was done?

Of course, I personally tend to just search by the commit contents
instead, which works just about as well. If the first line of the
commit isn't very unique, add a "f:author" to the search.

IOW, I really don't find much value in the "Link to original
submission", because that thing is *already* trivial to find, and the
lore search is actually better in many ways (it also tends to find
people *reporting* that commit, which is often what you really want -
the reason you're doing the search is that there's something going on
with it).

My argument here really is that "find where this commit was posted" is

 (a) not generally the most interesting thing

 (b) doesn't even need that "Link:" line.

but what *is* interesting, and where the "Link:" line is very useful,
is finding where the original problem that *caused* that patch to be
posted in the first place.

Yes, obviously you can find that original problem by searching too if
the commit message has enough other information.

For example, if there is an oops quoted in the commit message, I have
personally searched for parts of that kind of information to find the
original report and discussion.

So that whole "searching is often an option" is true for pretty much
_any_ Link:, but I think that for the whole "original submission" it's
so mindless and can be automated that it really doesn't add much real
value at all.

                Linus
