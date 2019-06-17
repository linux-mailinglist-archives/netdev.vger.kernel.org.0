Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD3A448D7E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 21:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728609AbfFQTGz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 15:06:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:41529 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726529AbfFQTGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 15:06:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id d17so7170930qtj.8;
        Mon, 17 Jun 2019 12:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZXzxDlFcs/KgzCLwIkEjkXbvSSYOGNCeCSskeDw5zQ=;
        b=MX8jmtBBRD1r8t07VtxB1VnMz7+UXMztQE5wkY5BCCTju4+Yr2cXWcBTpNCDZHCIS5
         3HvLYqVhmfP58yrFrsyqZ0Q43obKaEuTfRN8RTDqyx4iXhoxsEqM4nAAehJHcHrEzdy9
         BYN9ZfjrfhqZ4pCcWMplOcD5Q7NB3WFtwu8u8wxSbn8SOFA4gUymEA4YSra0amFmpCvn
         FW7bsyBcS3t4zuAocKi11YBmp4QXpqHekLDy8UopT4KTx2swZ3wnKtrXPmhYYstkU0w2
         HuqQQSrmIoOwt+nNj5OoWTVmlnuvSAZLoNAAo7kU0zegH6W02wtcbgVfoZSfr6C8UYwK
         cfFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZXzxDlFcs/KgzCLwIkEjkXbvSSYOGNCeCSskeDw5zQ=;
        b=lLcvebsMkw3ae28kjyd5UHtj55WF8NDPtHpEzD49LjcX5SY6JV79edxl9ACqaSC48K
         wHjB2N4nDNbbBO689QKpAJInxPBUCRZDrixRBBEkd5LS0Kdj+Kvy2HZGVhCYX/ebaBkW
         1oJD2kN8LOjw9LSbyZRA2yiAXgWFFMeHdQPxvwaW8rGMrPPlXt68kryA7ay/sUCC2lkK
         IYuC8d3YOSl+NP/cV3QYljYTz1ZAVvfmbTcZ1wUYt5IZ70ISAjftEp8jN7tsSaUOvC+J
         2hUq1NueRYhrTbEIIrwVn11ro4LRanQi3I6Jql5iF4DGRMhhwB1DXaOjQuVDoY6CG9ps
         4Naw==
X-Gm-Message-State: APjAAAWnAYdsv2kL4O/rNXmOqtarA8xUMWXTxFuuHUWbMH/voCH+EGTe
        qzftMfRTMtCIAd40rALsi/bSAV+o1N4XLXgBAEw=
X-Google-Smtp-Source: APXvYqzhcfNidc9xroCC1wW8Oldvz/95i4ihWAlvdk103r7uUzFT51cgx7TseXb2CtO40QGHDLrOIGOqKM8lYKoQ9i8=
X-Received: by 2002:ac8:2fb7:: with SMTP id l52mr71405503qta.93.1560798414376;
 Mon, 17 Jun 2019 12:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190615191225.2409862-1-ast@kernel.org> <CAEf4BzY_w-tTQFy_MfSvRwS4uDziNLRN+Jax4WXidP9R-s961w@mail.gmail.com>
 <70187096-9876-b004-0ccb-8293618f384f@fb.com>
In-Reply-To: <70187096-9876-b004-0ccb-8293618f384f@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 17 Jun 2019 12:06:42 -0700
Message-ID: <CAEf4BzZWAKrdcknFgBJWVczm3LpFHqcBcVv6ZunvHHcKk6eE8w@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/9] bpf: bounded loops and other features
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 17, 2019 at 11:58 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 6/17/19 9:39 AM, Andrii Nakryiko wrote:
> > On Sat, Jun 15, 2019 at 12:12 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >>
> >> v2->v3: fixed issues in backtracking pointed out by Andrii.
> >> The next step is to add a lot more tests for backtracking.
> >>
> >
> > Tests would be great, verifier complexity is at the level, where it's
> > very easy to miss issues.
> >
> > Was fuzzying approach ever discussed for BPF verifier? I.e., have a
> > fuzzer to generate both legal and illegal random small programs. Then
> > re-implement verifier as user-level program with straightforward
> > recursive exhaustive verification (so no state pruning logic, no
> > precise/coarse, etc, just register/stack state tracking) of all
> > possible branches. If kernel verifier's verdict differs from
> > user-level verifier's verdict - flag that as a test case and figure
> > out why they differ. Obviously that would work well only for small
> > programs, but that should be a good first step already.
> >
> > In addition, if this is done, that user-land verifier can be a HUGE
> > help to BPF application developers, as libbpf would (potentially) be
> > able to generate better error messages using it as well.
>
> In theory that sounds good, but doesn't work in practice.
> The kernel verifier keeps changing faster than user space can catch up.
> It's also relying on loaded maps and all sorts of callbacks that
> check context, allowed helpers, maps, combinations of them from all
> over the kernel.
> The last effort to build kernel verifier as-is into .o and link
> with kmalloc/map wrappers in user space was here:
> https://github.com/iovisor/bpf-fuzzer
> It was fuzzing the verifier and was able to find few minor bugs.
> But it quickly bit rotted.
>
> Folks brought up in the past the idea to collect user space
> verifiers from different kernels, so that user space tooling can
> check whether particular program will load on a set of kernels
> without need to run them in VMs.
> Even if such feature existed today it won't really solve this production
> headache, since all kernels prior to today will not be covered.
>
> I think syzbot is still generating bpf programs. iirc it found
> one bug in the past in the verifier core.
> I think the only way to make verifier more robust is to keep
> adding new test cases manually.
> Most interesting bugs we found by humans.
>
> Another approach to 'better error message' that was considered
> in the past was to teach llvm to recognize things that verifier
> will reject and let llvm warn on them.
> But it's also not practical. We had llvm error on calls.
> Then we added them to the verifier and had to change llvm.
> If we had llvm error on loops, now we'd need to change it.
> imo it's better to let llvm handle everything.

That all makes sense. Thanks for elaborate explanation!
