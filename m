Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB096277BAC
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbgIXWhQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:37:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgIXWhQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 18:37:16 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6BC0C0613CE;
        Thu, 24 Sep 2020 15:37:15 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id k2so595650ybp.7;
        Thu, 24 Sep 2020 15:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=C7958Iwt9CKivq6jDR+8Fx4g7GXVwOojIzk/Fw3d1hc=;
        b=W9+BDWFNo34wr3LsaGzhhbc4OMtfHUUDllIV1NyXTwbqXtPm/7ft6/bn88crRKTz+f
         fwWS+0zTbTwz2+7pWORBtN2pWrbjL4URKnDyIbcMRVQ1Llv0yra1Lsm5TiMzy4aXkT5c
         xpWz5XSsoiQiKW6TrD7njbWdaahUP+ikM5WiL36yVENbjuzUPOIVZJFNNWbrqWGAv4ke
         IXb97gqYoJPn8TUT92CD/IWDwzivj3emZG/Ymn6CNDoG29OzzxCSea2iL+3lptKp91hZ
         bFfv14YxXRsch/KBwTi9B2N09y1usBBy2Uc1FmdIgJCb3AWh53lXDiL+DHf1e16G6Vdy
         gqhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=C7958Iwt9CKivq6jDR+8Fx4g7GXVwOojIzk/Fw3d1hc=;
        b=UKAmfhEpnwY1fb8eas9cOfMoz2JIwtJjXfiuzSY6CDy/VJkFBNeWLSIAMrLwsdhWXy
         D3X/adY+dvHRbUESe3R68pSJw805zg+GI0BBj65DqvPU13FYHIqoLspBexhhIPBQSM0o
         LoZEtDkBsnwY4B77szSucQW1ksWrq8ZwXmKHG6kBzMTsIwjSmKnq2t6CMLiGtjabk8o7
         DxD8aT2JBqBsS5YCtDN5pWCJ27klOIPvjlIFlyhYMy1dyWA/A7eWH9MknOQRhAgZfYeB
         P/f++XVm6E3mA5QUlCTOxgDp+ODMU7/bgTlSJeHuo0jJRkSvt3AEehS2HtZKC5zaTA5v
         QzwQ==
X-Gm-Message-State: AOAM532HA7/9WQHSOPKvqvYGRhtdOH+pfr3aYC6tS48S+5YTcXyhnF+S
        lWURA5puM1bfjuF5OsO22QK3AVOo+J+MTfZJeBs=
X-Google-Smtp-Source: ABdhPJz24hX9VjxGmi14V1mP26nQ2FeSzvwbOqX8UgGm67VnYceozOvi+bQ8C3/V/kjjIYm3DVcT4Gwsq8oKmTNxbos=
X-Received: by 2002:a25:730a:: with SMTP id o10mr1485970ybc.403.1600987035128;
 Thu, 24 Sep 2020 15:37:15 -0700 (PDT)
MIME-Version: 1.0
References: <160079991372.8301.10648588027560707258.stgit@toke.dk>
 <160079991808.8301.6462172487971110332.stgit@toke.dk> <20200924001439.qitbu5tmzz55ck4z@ast-mbp.dhcp.thefacebook.com>
 <874knn1bw4.fsf@toke.dk> <CAEf4BzaBvvZdgekg13T3e4uj5Q9Rf1RTFP__ZPsU-NMp2fVXxw@mail.gmail.com>
 <87zh5ec1gs.fsf@toke.dk> <CAEf4BzZxfzQabDCdmby1XMQV7qQ_C=rATWOb=cN-Q1rfxR+nVA@mail.gmail.com>
 <87r1qqbywe.fsf@toke.dk>
In-Reply-To: <87r1qqbywe.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 24 Sep 2020 15:37:04 -0700
Message-ID: <CAEf4Bza38tR1GvyLzzzzv6zT8B-_gM_jhTqK_c7+e1ciU3ZA1w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v8 04/11] bpf: move prog->aux->linked_prog and
 trampoline into bpf_link on attach
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
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

On Thu, Sep 24, 2020 at 3:20 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Thu, Sep 24, 2020 at 2:24 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
> >>
> >> > On Thu, Sep 24, 2020 at 7:36 AM Toke H=C3=B8iland-J=C3=B8rgensen <to=
ke@redhat.com> wrote:
> >> >>
> >> >> Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >> >>
> >> >> > On Tue, Sep 22, 2020 at 08:38:38PM +0200, Toke H=C3=83=C6=92=C3=
=82=C2=B8iland-J=C3=83=C6=92=C3=82=C2=B8rgensen wrote:
> >> >> >> @@ -746,7 +748,9 @@ struct bpf_prog_aux {
> >> >> >>      u32 max_rdonly_access;
> >> >> >>      u32 max_rdwr_access;
> >> >> >>      const struct bpf_ctx_arg_aux *ctx_arg_info;
> >> >> >> -    struct bpf_prog *linked_prog;
> >> >> >
> >> >> > This change breaks bpf_preload and selftests test_bpffs.
> >> >> > There is really no excuse not to run the selftests.
> >> >>
> >> >> I did run the tests, and saw no more breakages after applying my pa=
tches
> >> >> than before. Which didn't catch this, because this is the current s=
tate
> >> >> of bpf-next selftests:
> >> >>
> >> >> # ./test_progs  | grep FAIL
> >> >> test_lookup_update:FAIL:map1_leak inner_map1 leaked!
> >> >> #10/1 lookup_update:FAIL
> >> >> #10 btf_map_in_map:FAIL
> >> >
> >> > this failure suggests you are not running the latest kernel, btw
> >>
> >> I did see that discussion (about the reverted patch), and figured that
> >> was the case. So I did a 'git pull' just before testing, and still got
> >> this.
> >>
> >> $ git describe HEAD
> >> v5.9-rc3-2681-g182bf3f3ddb6
> >>
> >> so any other ideas? :)
> >
> > That memory leak was fixed in 1d4e1eab456e ("bpf: Fix map leak in
> > HASH_OF_MAPS map") at the end of July. So while your git repo might be
> > checked out on a recent enough commit, could it be that the kernel
> > that you are running is not what you think you are running?
>
> Nah, I'm running these in a one-shot virtual machine with virtme-run.
>
> > I specifically built kernel from the same commit and double-checked:
> >
> > [vmuser@archvm bpf]$ uname -r
> > 5.9.0-rc6-01779-g182bf3f3ddb6
> > [vmuser@archvm bpf]$ sudo ./test_progs -t map_in_map
> > #10/1 lookup_update:OK
> > #10/2 diff_size:OK
> > #10 btf_map_in_map:OK
> > Summary: 1/2 PASSED, 0 SKIPPED, 0 FAILED
>
> Trying the same, while manually entering the VM:
>
> [root@(none) bpf]# uname -r
> 5.9.0-rc6-02685-g64363ff12e8f

I don't see 64363ff12e8f sha in my repo, so I still don't know what
commit your kernel is built off of. But I believe that you have the
latest kernel, you'll just need to debug this on your own, though,
because this test was never flaky for me, I can't repro the failure.

> [root@(none) bpf]# ./test_progs -t map_in_map
> test_lookup_update:PASS:skel_open 0 nsec
> test_lookup_update:PASS:skel_attach 0 nsec
> test_lookup_update:PASS:inner1 0 nsec
> test_lookup_update:PASS:inner2 0 nsec
> test_lookup_update:PASS:inner1 0 nsec
> test_lookup_update:PASS:inner2 0 nsec
> test_lookup_update:PASS:map1_id 0 nsec
> test_lookup_update:PASS:map2_id 0 nsec
> kern_sync_rcu:PASS:inner_map_create 0 nsec
> kern_sync_rcu:PASS:outer_map_create 0 nsec
> kern_sync_rcu:PASS:outer_map_update 0 nsec
> test_lookup_update:PASS:sync_rcu 0 nsec
> kern_sync_rcu:PASS:inner_map_create 0 nsec
> kern_sync_rcu:PASS:outer_map_create 0 nsec
> kern_sync_rcu:PASS:outer_map_update 0 nsec
> test_lookup_update:PASS:sync_rcu 0 nsec

try adding sleep(few seconds, enough for RCU grace period to pass)
here and see if that helps

if not, please printk() around to see why the inner_map1 wasn't freed

> test_lookup_update:FAIL:map1_leak inner_map1 leaked!
> #10/1 lookup_update:FAIL
> #10/2 diff_size:OK
> #10 btf_map_in_map:FAIL
> Summary: 0/1 PASSED, 0 SKIPPED, 2 FAILED
>
>
> >> >> configure_stack:FAIL:BPF load failed; run with -vv for more info
> >> >> #72 sk_assign:FAIL
> >>
> >> (and what about this one, now that I'm asking?)
> >
> > Did you run with -vv? Jakub Sitnicki (cc'd) might probably help, if
> > you provide a bit more details.
>
> No, I didn't, silly me. Turned out that was also just a missing config
> option - thanks! :)

ok, cool

>
> >> One thing that would be really useful would be to have a 'reference
> >> config' or something like that. Missing config options are a common
> >> reason for test failures (as we have just seen above), and it's not
> >> always obvious which option is missing for each test. Even something
> >> like grepping .config for BPF doesn't catch everything. If you already
> >> have a CI running, just pointing to that config would be a good start
> >> (especially if it has history). In an ideal world I think it would be
> >> great if each test could detect whether the kernel has the right confi=
g
> >> set for its features and abort with a clear error message if it isn't.=
..
> >
> > so tools/testing/selftests/bpf/config is intended to list all the
> > config values necessary, but given we don't update them often we
> > forget to update them when selftests requiring extra kernel config are
> > added, unfortunately.
>
> Ah, that's useful! I wonder how difficult it would be to turn this into
> a 'make bpfconfig' top-level make target (similar to 'make defconfig')?
>
> That way, it could be run automatically, and we would also catch
> anything missing?

no idea, might be worth trying

>
> > As for CI's config, check [0], that's what we use to build kernels.
> > Kernel config is intentionally pretty minimal and is running in a
> > single-user mode in pretty stripped down environment, so might not
> > work as is for full-blown VM. But you can still take a look.
> >
> >   [0] https://github.com/libbpf/libbpf/blob/master/travis-ci/vmtest/con=
figs/latest.config
>
> Well that's how I'm running my own tests (as mentioned above), so that
> might be useful, actually! I'll go take a look, thanks :)

glad I could help

>
> -Toke
>
