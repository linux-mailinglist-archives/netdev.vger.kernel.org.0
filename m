Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF21B277A99
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 22:41:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIXUlF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 16:41:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726037AbgIXUlF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 16:41:05 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6689C0613CE;
        Thu, 24 Sep 2020 13:41:04 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id 133so382348ybg.11;
        Thu, 24 Sep 2020 13:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LuBsiJGWhXaa9Z1xegLqAKn7DmusjrmOo8BYb2r+KsQ=;
        b=JkXFn/ehP3D4eF5eH9ZNxvLZUrCTdM2JYXnwdIfYVfurU5+eiXFMhZdmG3hj/Fedri
         pxASktyl/kA4eFwhYYdlF1CW5UM7Tq2wY9yMWs0+YYYF/ZdDGGYmnAUjFi5vv2H3PxL8
         tRnf/C7kpN3UkBfic2hqvFfUW2dAEUOd/Nf1UsaSMakYRF0pnLnZfFePDY3/RpDcXgu1
         EO/g4ne/xTaH+FW+NmZvYGALskNkFeEinShaoVxlLglZy/4JcNoL3cIScuxJXLTFaX0q
         3lsBacaOXFp5LnoZXw0w8jNcNItlsVggvBkHUtiElrqSOlIn/uSSyouBlr4G5BQdmnFn
         dm6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LuBsiJGWhXaa9Z1xegLqAKn7DmusjrmOo8BYb2r+KsQ=;
        b=bvi1vtkKcGlJupiXTaYrbL5UFBX9p6FZXMC1HjgeCWve7aaMNVtlYWenxdKFhTae+h
         b8HBMOdsIgyj3CFiWtypXMHW7vwrqczg10d/T4wgOHyRm1ysaXokLgpCdTOLRtxFnaN/
         9vQCXRmuYdRWCkM4zRs/gwvGB+8tOwzAzF25FzRZgrsseCoK2p90Xziy5sDpPuuYluu/
         qG7xgXnXaQf9lxc/jeXEjal833BBYDztxwKcm+s28ujkJ2yJjJ1CoxGFx1AHnqDqQV9e
         cwoE5GX7j0mn+1vE962xx73sUdG5f+kKlVgvlbnStBF2Y6wweoUUmjqnfoAcq1i3QloE
         Ohww==
X-Gm-Message-State: AOAM531DmBRhMi0y7quG39iKKhMP4S2EBJ0AZpYrEQXNgM+wVXCnqAzS
        99U4lBTAf0OjF4LrSKEcIPpChVay9HFG6pnwvJ4=
X-Google-Smtp-Source: ABdhPJyDBUyTK99K4bkK5qk54JrmnuC6QX4fyZba8yrwdVZxKhRe9eWbLSn8nqnBUjAIGa8bbgEPuA2daDqln8tAzYY=
X-Received: by 2002:a25:2687:: with SMTP id m129mr804101ybm.425.1600980064144;
 Thu, 24 Sep 2020 13:41:04 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk> <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <874knn1bw4.fsf@toke.dk>
In-Reply-To: <874knn1bw4.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 13:40:53 -0700
Message-ID: <CAEf4BzaBvvZdgekg13T3e4uj5Q9Rf1RTFP__ZPsU-NMp2fVXxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 24, 2020 at 7:36 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
>
> > On Tue, Sep 22, 2020 at 08:38:38PM +0200, Toke H=C3=83=C6=92=C3=82=C2=
=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
> >> @@ -746,7 +748,9 @@ struct bpf_prog_aux {
> >>      u32 max_rdonly_access;
> >>      u32 max_rdwr_access;
> >>      const struct bpf_ctx_arg_aux *ctx_arg_info;
> >> -    struct bpf_prog *linked_prog;
> >
> > This change breaks bpf_preload and selftests test_bpffs.
> > There is really no excuse not to run the selftests.
>
> I did run the tests, and saw no more breakages after applying my patches
> than before. Which didn't catch this, because this is the current state
> of bpf-next selftests:
>
> # ./test_progs  | grep FAIL
> test_lookup_update:FAIL:map1_leak inner_map1 leaked!
> #10/1 lookup_update:FAIL
> #10 btf_map_in_map:FAIL

this failure suggests you are not running the latest kernel, btw


> configure_stack:FAIL:BPF load failed; run with -vv for more info
> #72 sk_assign:FAIL
> test_test_bpffs:FAIL:bpffs test  failed 255
> #96 test_bpffs:FAIL
> Summary: 113/844 PASSED, 14 SKIPPED, 4 FAILED
>
> The test_bpffs failure happens because the umh is missing from the
> .config; and when I tried to fix this I ended up with:

yeah, seems like selftests/bpf/config needs to be updated to mention
UMH-related config values:

CONFIG_BPF_PRELOAD=3Dy
CONFIG_BPF_PRELOAD_UMD=3Dm|y

with that test_bpffs shouldn't fail on master

>
> [..]
>   CC [M]  kernel/bpf/preload/bpf_preload_kern.o
>
> Auto-detecting system features:
> ...                        libelf: [ OFF ]
> ...                          zlib: [ OFF ]
> ...                           bpf: [ OFF ]
>
> No libelf found

might be worthwhile to look into why detection fails, might be
something with Makefiles or your environment

>
> ...which I just put down to random breakage, turned off the umh and
> continued on my way (ignoring the failed test). Until you wrote this I
> did not suspect this would be something I needed to pay attention to.
> Now that you did mention it, I'll obviously go investigate some more, my
> point is just that in this instance it's not accurate to assume I just
> didn't run the tests... :)

Don't just assume some tests are always broken. Either ask or
investigate on your own. Such cases do happen from time to time while
we wait for a fix in bpf to get merged into bpf-next or vice versa,
but it's rare. We now have two different CI systems running selftests
all the time, in addition to running them locally as well, so any
permanent test failure is very apparent and annoying, so we fix them
quickly. So, when in doubt - ask or fix.

>
> > I think I will just start marking patches as changes-requested when I s=
ee that
> > they break tests without replying and without reviewing.
> > Please respect reviewer's time.
>
> That is completely fine if the tests are working in the first place. And

They are and hopefully moving forward that would be your assumption.

> even when they're not (like in this case), pointing it out is fine, and
> I'll obviously go investigate. But please at least reply to the email,
> not all of us watch patchwork regularly.
>
> (I'll fix all your other comments and respin; thanks!)
>
> -Toke
>
