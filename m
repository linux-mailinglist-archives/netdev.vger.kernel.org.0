Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76F3A1D418C
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 01:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726122AbgENXNe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 19:13:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726037AbgENXNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 19:13:33 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A49D3C061A0C;
        Thu, 14 May 2020 16:13:33 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id ee19so173714qvb.11;
        Thu, 14 May 2020 16:13:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XvKUF0pTtPnMHjw02Wv/qngoPWWmFajMK7ZV1JXKdkQ=;
        b=PCcdGqOBgA0PtmVNmMTkqmHLjM8jEY9sGWyy/Och/ucWd50R6NY/oNGIhnNuc10dqx
         xISKzwu4QgaTfk/lFFSQZvsLuTw0577sBjo17OqtrFAvMQNMiP/Bf2kp37Kcd+ESRNZQ
         nF3Y7dGRRh5Wgm7ThK60gJKRgZPw1lrkUFvNtT8hPSmzNBLLcnDk975+sZMJHQh7eYjv
         liFX05aqvBcszv+r87feiq1eBdwn/U3zQOkym/D4Qwm+h3xaAvciq7XMdG/KXgAqd24s
         l68Bk7KLGFNeEVdly44OrOkuRy+ZjNaq7jGsnfj2JFNDv+CVQObwkQRo188+rMaE8Drk
         x9iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XvKUF0pTtPnMHjw02Wv/qngoPWWmFajMK7ZV1JXKdkQ=;
        b=GZ+twd57qaG5VCdK3g5h+gQ6PRitrAJenpmtefwAF3/vxYIOf+MdBWEHw6ECiAVcVT
         L7HjI3jX0OpJvBwJbqZkD9LC/rH1ruO5BmSk0rQWvqwF+PVbRyoa9x5E4s434NgZfbhH
         oIwteOEN2/SPQd3iV1YHiqvqoItJOI1pCSHFZwxcf2dteVbcMXB0Ym4zR7spfIdG/rNu
         3iuN824jTdLHSw2x1TmD6/wQaNTdygckMmD5WMOK/87P4JyW/sCUY0uLfYcOxYpky0Kf
         whiQNMmefpkHWC5kRzhOB2evckiJAMYy04Bhj4Zfs78wzcjbeE/lo84YzqrVMxm9Y5Fr
         CeXw==
X-Gm-Message-State: AOAM532XpzXc4wzQX3S5sTutrAuZzHJ5561L/4L+bhEbIs84/hJkH6Ft
        YIJXxHVKTBWGMG+nroawhxbolH9+sUnizg1q92rofZaB
X-Google-Smtp-Source: ABdhPJy6Dwze8XD6ZbzihsqGlm4ceo/heW1l6wQt/GEnQ55nxodMOhPZ3Nad3Z0K7DUov2yQZ6eOKj56ii9xSqbKHOs=
X-Received: by 2002:a0c:a892:: with SMTP id x18mr821460qva.247.1589498012041;
 Thu, 14 May 2020 16:13:32 -0700 (PDT)
MIME-Version: 1.0
References: <alpine.LRH.2.21.2005121538120.22093@localhost>
In-Reply-To: <alpine.LRH.2.21.2005121538120.22093@localhost>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 14 May 2020 16:13:21 -0700
Message-ID: <CAEf4BzZypWtw=xuXRFCRhLxrkZRkGHTEQ=2RBQwL5ja3gMd=_Q@mail.gmail.com>
Subject: Re: bpf selftest execution issues
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 7:46 AM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> When running BPF tests I ran into some issues and couldn't get a clean
> set of results on the bpf-next master branch. Just wanted to check if anyone
> else is seeing any of these failures.
>
> 1. Timeouts. When running "make run_tests" in tools/testing/selftests/bpf,
> the kselftest runner uses an over-aggressive default timeout of 45 seconds
> for tests. For some tests which comprise a series of sub-tests, this
> is a bit too short. For example, I regularly see:
>
> not ok 30 selftests: bpf: test_tunnel.sh # TIMEOUT
>
> not ok 37 selftests: bpf: test_lwt_ip_encap.sh # TIMEOUT
>
> not ok 39 selftests: bpf: test_tc_tunnel.sh # TIMEOUT
>
> not ok 41 selftests: bpf: test_xdping.sh # TIMEOUT
>
> Theses tests all share the characteristic that they consist of a set of
> subtests, and while some sleeps could potentially be trimmed it seems
> like we may want to override the default timeout with a "settings" file
> to get more stable results. Picking magic numbers that work for everyone
> is problematic of course. timeout=0 (disable timeouts) is one answer I
> suppose.  Are others hitting this, or are you adding your own settings
> file with a timeout override, or perhaps invoking the tests in a way other
> than "make run_tests" in tools/testing/selftests/bpf?
>

I just run each test binary individually...

> 2. Missing CONFIG variables in tools/testing/selftests/bpf/config. As I
> understand it the toplevel config file is supposed to specify config vars
> needed to run the associated tests.  I noticed a few absences:
>
> Should CONFIG_IPV6_SEG6_BPF be in tools/testing/selftests/bpf/config?
> Without it the helper bpf_lwt_seg6_adjust_srh is not compiled in so
> loading test_seg6_loop.o fails:
>
> # libbpf: load bpf program failed: Invalid argument
> # libbpf: -- BEGIN DUMP LOG ---
> # libbpf:
> # unknown func bpf_lwt_seg6_adjust_srh#75
> # verification time 48 usec
> # stack depth 88
> # processed 90 insns (limit 1000000) max_states_per_insn 0 total_states 6
> peak_states 6 mark_read 3
> #
> # libbpf: -- END LOG --
> # libbpf: failed to load program 'lwt_seg6local'
> # libbpf: failed to load object 'test_seg6_loop.o'
> # test_bpf_verif_scale:FAIL:110
> # #5/21 test_seg6_loop.o:FAIL
> # #5 bpf_verif_scale:FAIL
>
> Same question for CONFIG_LIRC for test_lirc* tests; I'm seeing:
>
> # grep: /sys/class/rc/rc0/lirc*/uevent: No such file or directory
> # Usage: ./test_lirc_mode2_user /dev/lircN /dev/input/eventM
> # ^[[0;31mFAIL: lirc_mode2^[[0m
>
> ...which I suspect would be fixed by having CONFIG_LIRC.
>

Yep, probably, please send a patch.


> 3. libbpf: XXX is not found in vmlinux BTF
>
> A few different cases here across a bunch of tests:
>

[...]

> # libbpf: hrtimer_nanosleep is not found in vmlinux BTF
>
> The strange thing is I'm running with the latest LLVM/clang
> from llvm-project.git, installed libbpf/bpftool from the kernel
> build, specified CONFIG_DEBUG_INFO_BTF etc and built BTF with pahole 1.16.
> Here's an example failure for fentry_test:
>
> ./test_progs -vvv -t fentry_test

[...]

> libbpf: found data map 0 (fentry_t.bss, sec 16, off 0) for insn 16
> libbpf: loading kernel BTF '/sys/kernel/btf/vmlinux': 0
> libbpf: map 'fentry_t.bss': created successfully, fd=4
> libbpf: bpf_fentry_test1 is not found in vmlinux BTF
> libbpf: failed to load object 'fentry_test'
> libbpf: failed to load BPF skeleton 'fentry_test': -2
> test_fentry_test:FAIL:fentry_skel_load fentry skeleton failed
> #19 fentry_test:FAIL
> Summary: 0/0 PASSED, 0 SKIPPED, 1 FAILED
>
> What's odd is that symbols are being found when loading via
> bpf_load_xattr(); the common thread in the above seems to be BPF
> skeleton-based open+load. Is there anything else I should check
> to further debug this?

Did you check if /sys/kernel/btf/vmlinux really contains those functions?

bpftool btf dump file /sys/kernel/btf/vmlinux | grep bpf_fentry_test1

It clearly loaded BTF successfully, so I suspect BTF doesn't have
FUNCs? Which might mean that your pahole v1.16 is not the one used
during kernel BTF generation? Can you try to validate that?

>
> 4. Some of the tests rely on /dev/tcp - support for it seems to only
> be in  newer bash; tests which spawn nc servers and wait on data
> transfers via /dev/tcp hang as a result (timeouts don't seem to
> kill things either). Would it be reasonable to have tests fall back to
> using nc where possible if /dev/tcp is not present, or perhaps
> fail early?

no opinion on this, maybe folks dealing with networking more can
suggest something.

>
> Apologies if I've missed any discussion of any of the above. Thanks!
>
> Alan
