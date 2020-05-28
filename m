Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741C91E695B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 20:31:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405857AbgE1Sbn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 14:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405798AbgE1Sbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 14:31:41 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8752CC08C5C6;
        Thu, 28 May 2020 11:31:41 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id j32so864011qte.10;
        Thu, 28 May 2020 11:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IT+YfidDEh3lkLxRoXW91Fv8QrVmqkWlnlBsq8swgno=;
        b=pQFYbuj0tHk6MsNX0qbukP8/Iwi71Eu4OhUxwzoLipj0jA4FbP9qbonwlHMY9r0nLC
         Ijf7GTuej2Ix4KFhalQf6BrKo2IhDN5jT4VNE+ByTrsKpdTzBzDImKH3jKSYYuWjkS27
         awTQWG1/1+eCv9iIsJ1s952huaBL6CJK/g1sD1pQ/GJVTfw19LfL0c6F1TxVzHEdHCf6
         nrDPicuXzLoXlyQLGvc4X1ODl2osR08+1brq4vggDFNz4jDVp4uzUIdV3inhi+CYavSW
         2PWgXBtezBWwDlGAxtdbwfkgKKTeaHm73ImefwevJtLOJZwOtCrGC8tcDmMaOPcsytmK
         oB7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IT+YfidDEh3lkLxRoXW91Fv8QrVmqkWlnlBsq8swgno=;
        b=sft7lIgjgm22pWLjVu74u435sqp1eX9XeUoXAUqRakXAHsprtN3phkrPc6MO1/QF02
         z7eiZ2HjP4Qn4Z7LAB5iAYD5po6mgHVrgydfrFw89uDfZCKTPHjnfcROUBctWuuf2Djt
         XClDckSHqJpKbsN/0MUq6jSVH/X8z6MhCsxd/stMitYH5yH57JawR0LLcAY/MFKVXZBA
         qJzXZmkEhvNQkYAAArGskGnyJJlFOxrNCZCdx7fXKR9lJEQmhNFf3+U8WxhHyZdWDLcw
         NJPOvuwQaNH643+5AXeloRAmtheRBUpYOI4Jp1RbH2nriar5nOWSNO2yvVLg/KQ8SNzN
         1XwQ==
X-Gm-Message-State: AOAM533XQxiFA1sp4YSpZ+w+u5cuQ2rPTdlv1NpPauwUhHDcAkAWjAzF
        jaHr+Pe94CM96pxBXeKrO1LyzrzXe6igUIenFnN040rD2d8=
X-Google-Smtp-Source: ABdhPJxRGA3CdrLBH5Kg0SBfJKf5/Wfsqw1IrHZATYGsSzsNK8ghrMXsZ0vYqimlKLZ7STIOnDGC1QZ3aqufLSM3aa4=
X-Received: by 2002:ac8:424b:: with SMTP id r11mr4563311qtm.171.1590690700762;
 Thu, 28 May 2020 11:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200527170840.1768178-1-jakub@cloudflare.com>
 <20200527170840.1768178-9-jakub@cloudflare.com> <CAEf4BzZEDArh8kL-mredwYb=GAOXEue=rGAjOaM0qGjj5RG6RA@mail.gmail.com>
 <87lflc2no9.fsf@cloudflare.com>
In-Reply-To: <87lflc2no9.fsf@cloudflare.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 May 2020 11:31:29 -0700
Message-ID: <CAEf4BzZ0qhdABJrG5mkeUM9je3FoJG3jTQ8oeFwT8JV7xS5+Qg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 8/8] selftests/bpf: Add tests for attaching
 bpf_link to netns
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        kernel-team@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 6:29 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Thu, May 28, 2020 at 08:08 AM CEST, Andrii Nakryiko wrote:
> > On Wed, May 27, 2020 at 12:16 PM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >>
> >> Extend the existing test case for flow dissector attaching to cover:
> >>
> >>  - link creation,
> >>  - link updates,
> >>  - link info querying,
> >>  - mixing links with direct prog attachment.
> >>
> >> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> >> ---
> >
> > You are not using bpf_program__attach_netns() at all. Would be nice to
> > actually use higher-level API here...
>
> That's true. I didn't exercise the high-level API. I can cover that.
>
> >
> > Also... what's up with people using CHECK_FAIL + perror instead of
> > CHECK? Is CHECK being avoided for some reason or people are just not
> > aware of it (which is strange, because CHECK was there before
> > CHECK_FAIL)?
>
> I can only speak for myself. Funnily enough I think I've switched from
> CHECK to CHECK_FAIL when I touched on BPF flow dissector last time [0].
>
> CHECK needs and "external" duration variable to be in scope, and so it
> was suggested to me that if I'm not measuring run-time with
> bpf_prog_test_run, CHECK_FAIL might be a better choice.

duration is unfortunate and historical, we can eventually fix that,
but it simply didn't feel worthwhile to me. I just do `static int
duration;` at the top of the test and forget about it.

>
> CHECK is also perhaps too verbose because it emits a log message on
> success (to report duration, I assume).

I actually find that CHECK emitting message regardless of success or
failure (in verbose mode or when test fails) helps a lot to narrow
down where exactly the failure happens (it's not always obvious from
error message). So unless we are talking about 100+ element loops, I'm
all for CHECK vebosity. Again, you'll see it only when something fails
or you run tests in verbose mode.

CHECK_FAIL is the worst in that case, because it makes me blind in
terms of tracking progress of test.

>
> You have a better overview of all the tests than me, but if I had the
> cycles I'd see if renaming CHECK to something more specific, for those
> test that actually track prog run time, can work.

I'd make CHECK not depend on duration instead, and convert existing
cases that do rely on duration to something like CHECK_TIMED.

>
> -jkbs
>
>
> [0] https://lore.kernel.org/bpf/87imov1y5m.fsf@cloudflare.com/
>
>
>
> >
> >>  .../bpf/prog_tests/flow_dissector_reattach.c  | 500 +++++++++++++++++-
> >>  1 file changed, 471 insertions(+), 29 deletions(-)
> >>
> >
> > [...]
