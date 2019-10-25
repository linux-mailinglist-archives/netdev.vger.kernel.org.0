Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C03FAE4220
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 05:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388477AbfJYDjg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 23:39:36 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:40110 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727145AbfJYDjg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 23:39:36 -0400
Received: by mail-qt1-f194.google.com with SMTP id o49so1245107qta.7;
        Thu, 24 Oct 2019 20:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cd4TOVbvPNZYn1igZctkezc1pztol2h8rYUeMEkk5eY=;
        b=NrUZ3isi0OKlyLOrM+bkB67cPUAFOTqokLi4n1X8o2n0wIZPzcsgixV1Peog3ITT4L
         P6L2AeT/RdtSWnoRf0HKqi8uZBa3zmyiNMl8cCZjvYNoYGy3I3enNuc84nPuOBu8ytWQ
         cvlsVxujTgFmQB5NTc/bRKrbhRhEkknf6a0zlkmV8aH6M7+jGc5H1Oe+80o4jVtXSx+E
         mblZHzowY9NeECWhHfKI7vbgH0zIKthgl1gbXtvMTVGf6khqfNfv5NZAHXASmui/9c19
         tAhH836dU+tOQA+Xb+biCgXNzb4oUM0kKjy+aXLhHcokh6II98iJHMjJvu5ZeYdOH94B
         kSFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cd4TOVbvPNZYn1igZctkezc1pztol2h8rYUeMEkk5eY=;
        b=TejdSdERgNyPCzL47b1PSzQJHJ2dGGJ8VF7QzHTlmNHEVrJohR+Zp9GpNiAlfVYEny
         CCDnovgyEZ6aTqdx7/U9f7zOmy7KvT2DZzTLfsA+oIE638LWKNb5KB2q+vZXcNksmrqN
         ZM+b2w1PDnMl1fiwzkc05HfQc1U+j4ASnSbbRh7bLMfdmQXQzTXUluF3c6I2iiMyieET
         T/xXLn9czT87fP6rg5+qXVathk7BqfgCZJkfX6uNtZ8Zp/zUXgB6MA8GU9T+uxADfx09
         zdeJaypgV0MsvRJr9xpvwOeUR+xCtw+LVOqwC/GikrIK7FeSo9QMxcSPM5qgjNWWDm2L
         mWBg==
X-Gm-Message-State: APjAAAVTGpvDtfozuazWDWDpSYE9PKHWMsomVGIQqOdHVpByozieB9pW
        UZ0g56Wt3+n4oMM87WKcYqxeBDxiirODXdTl5LY=
X-Google-Smtp-Source: APXvYqxRXF2fNyWevku302i8H0rWb1y4GmLGm3DZj281dHyZZUabqge5PWK6zGE8wU3bTxFg6cpY6PDWk26NnTWqzoA=
X-Received: by 2002:a05:6214:16c5:: with SMTP id d5mr1192917qvz.247.1571974775162;
 Thu, 24 Oct 2019 20:39:35 -0700 (PDT)
MIME-Version: 1.0
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
 <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
 <20191022072023.GA31343@pc-66.home> <CAEf4BzbBoE=mVyxS9OHNn6eSvfEMgbcqiBh2b=nVmhWiLGEBNQ@mail.gmail.com>
 <5db1f389aa6f2_5c282ada047205c012@john-XPS-13-9370.notmuch>
In-Reply-To: <5db1f389aa6f2_5c282ada047205c012@john-XPS-13-9370.notmuch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Oct 2019 20:39:23 -0700
Message-ID: <CAEf4BzZ2SrR0CBhbXo64bwWuBq-=JDS6p6=KRaLtH1bCGBwa3w@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 11:55 AM John Fastabend
<john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > On Tue, Oct 22, 2019 at 12:20 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > >
> > > On Mon, Oct 21, 2019 at 10:07:59PM -0700, John Fastabend wrote:
> > > > Andrii Nakryiko wrote:
> > > > > On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > > >
> > > > > > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > > > > > kprobes programs on older kernels.
> > > > >
> > > > > My main concern with this is that this code is born bit-rotten,
> > > > > because selftests are never testing the legacy code path. How did you
> > > > > think about testing this and ensuring that this keeps working going
> > > > > forward?
> > > >
> > > > Well we use it, but I see your point and actually I even broke the retprobe
> > > > piece hastily fixing merge conflicts in this patch. When I ran tests on it
> > > > I missed running retprobe tests on the set of kernels that would hit that
> > > > code.
> > >
> > > If it also gets explicitly exposed as bpf_program__attach_legacy_kprobe() or
> > > such, it should be easy to add BPF selftests for that API to address the test
> > > coverage concern. Generally more selftests for exposed libbpf APIs is good to
> > > have anyway.
> > >
> >
> > Agree about tests. Disagree about more APIs, especially that the only
> > difference will be which underlying kernel machinery they are using to
> > set everything up. We should ideally avoid exposing that to users.
>
> Maybe a build flag to build with only the older style supported for testing?
> Then we could build, test in selftests at least. Be clear the flag is only
> for testing and can not be relied upon.

Build flag will necessitate another "flavor" of test_progs just to
test this. That seems like an overkill.

How about this approach:

$ cat silent-features.c
#include <stdio.h>

int __attribute__((weak)) __bpf_internal__force_legacy_kprobe;

int main() {
        if (__bpf_internal__force_legacy_kprobe)
                printf("LEGACY MODE!\n");
        else
                printf("FANCY NEW MODE!\n");
        return 0;
}
$ cat silent-features-testing.c
int __bpf_internal__force_legacy_kprobe = 1;
$ cc -g -O2 silent-features.c -o silent-features && ./silent-features
FANCY NEW MODE!
$ cc -g -O2 silent-features.c silent-features-testing.c -o
silent-features && ./silent-features
LEGACY MODE!

This seems like an extensible mechanism without introducing any new
public APIs or knobs, and we can control that in runtime. Some good
naming convention to emphasize this is only for testing and internal
needs, and I think it should be fine.

>
> >
> > > Cheers,
> > > Daniel
