Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3822D35783A
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 01:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229739AbhDGXFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 19:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbhDGXFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 19:05:10 -0400
Received: from mail-yb1-xb2b.google.com (mail-yb1-xb2b.google.com [IPv6:2607:f8b0:4864:20::b2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E11DC061760;
        Wed,  7 Apr 2021 16:05:00 -0700 (PDT)
Received: by mail-yb1-xb2b.google.com with SMTP id l9so586531ybm.0;
        Wed, 07 Apr 2021 16:05:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Sqg66sn58LZtVTqUpPZYqAX3Du9q2k6vKUJa6Q9TW88=;
        b=DFx4Aqz9FyTOWKlb+LvrDu34fJHEkTtH3rQrt64iB9W9Y20sMItMMXsxWn+gS3qzzI
         GOrLKAZ3+0sTlHJNLQTCOZvoKvfwqyPocz1L88fMdx5u/ObhB6HlcjsHADs/KV46YFd+
         WzeqTKxwAtHXeNeVvLhIH8gghACmHzZHb6fZhdil3vFH9I2Y4MBvKTqeDbv58I0PAHLL
         68bkxkWXbzgzeGXfdffjynydF2xEqIv3bnDoOzHUFF0XyWBTJHd/+L1p2VRdJG++oTVJ
         L0CmoWiS067oh9gm21Ya8LJrFIbrsbWJkAwzYmeMIkf8LuRNvpd/N3jO5VfetO/BOZAM
         s45Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Sqg66sn58LZtVTqUpPZYqAX3Du9q2k6vKUJa6Q9TW88=;
        b=RCdHSlY3cMG50I9vRCUXhBjnp6e3Nwmy/VrJTEgEz0xU7cKa3EzQnQOUT2T0N4sXHh
         2O9mHf7ZhLV2dXG4lATeZBXf+tocrn5QR58S0KorkwvUYqP9RiUeyJf1qMwFyskBBcn/
         YAJxM+kZUAq4Yh/RuUZU4vxOfhn8v6SBY+7gnomusZGazFX1Orn+2s8IjToXicDXq35w
         cdUTZaIvquiA+dJ6pCt4BfB/PFSeAqJRRq1TD2L1GQ4IyhqxpdxVqG5OBoXG/WEDnvzm
         1pNWAImJC/t68MFYfSbUlL2sXlL9dGdvOonNQ0DdVHqkHOcuEXhKhB1DlJK2iYRz2KNQ
         qeTw==
X-Gm-Message-State: AOAM530hVRinJkgFPzAjbsNAPRP55yB70HrXafovOrjOZhI53gXmQc/i
        Bv3Vc3BlsgtMQQuynLVC2pjLhI9jcD7qRjS/PQqIAn1Qdbk=
X-Google-Smtp-Source: ABdhPJy5HpL97dObmXwifU4/RHL4htDVDXXRJwuKo2TQ+4TZkQFC4vxa8ugCCMjLNSUg3c+bBX/xMXp1SEdbuA/wDqA=
X-Received: by 2002:a05:6902:6a3:: with SMTP id j3mr7566067ybt.403.1617836699711;
 Wed, 07 Apr 2021 16:04:59 -0700 (PDT)
MIME-Version: 1.0
References: <20210406212913.970917-1-jolsa@kernel.org> <20210406212913.970917-6-jolsa@kernel.org>
In-Reply-To: <20210406212913.970917-6-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 7 Apr 2021 16:04:48 -0700
Message-ID: <CAEf4BzYnr=r-+iYaZ9yoTgRCs7h0mNo=rjg6S2OAYRkDdPniJA@mail.gmail.com>
Subject: Re: [PATCHv2 bpf-next 5/5] selftests/bpf: Test that module can't be
 unloaded with attached trampoline
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 7, 2021 at 4:22 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding test to verify that once we attach module's trampoline,
> the module can't be unloaded.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

To be fair, to test that you are actually testing what you think you
are testing, you'd have to prove that you *can* detach when no program
is attached to bpf_testmod ;) You'd also need kern_sync_rcu() to wait
for all the async clean up to complete inside the kernel. But that
doesn't interact with other tests well, so I think it's fine.

grumpily due to CHECK() usage (please do consider updating to ASSERT):

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  .../selftests/bpf/prog_tests/module_attach.c  | 23 +++++++++++++++++++
>  1 file changed, 23 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/module_attach.c b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> index 5bc53d53d86e..d180b8c28287 100644
> --- a/tools/testing/selftests/bpf/prog_tests/module_attach.c
> +++ b/tools/testing/selftests/bpf/prog_tests/module_attach.c
> @@ -45,12 +45,18 @@ static int trigger_module_test_write(int write_sz)
>         return 0;
>  }
>
> +static int delete_module(const char *name, int flags)
> +{
> +       return syscall(__NR_delete_module, name, flags);
> +}
> +
>  void test_module_attach(void)
>  {
>         const int READ_SZ = 456;
>         const int WRITE_SZ = 457;
>         struct test_module_attach* skel;
>         struct test_module_attach__bss *bss;
> +       struct bpf_link *link;
>         int err;
>
>         skel = test_module_attach__open();
> @@ -84,6 +90,23 @@ void test_module_attach(void)
>         ASSERT_EQ(bss->fexit_ret, -EIO, "fexit_tet");
>         ASSERT_EQ(bss->fmod_ret_read_sz, READ_SZ, "fmod_ret");
>
> +       test_module_attach__detach(skel);
> +
> +       /* attach fentry/fexit and make sure it get's module reference */
> +       link = bpf_program__attach(skel->progs.handle_fentry);
> +       if (CHECK(IS_ERR(link), "attach_fentry", "err: %ld\n", PTR_ERR(link)))
> +               goto cleanup;
> +
> +       ASSERT_ERR(delete_module("bpf_testmod", 0), "delete_module");
> +       bpf_link__destroy(link);
> +
> +       link = bpf_program__attach(skel->progs.handle_fexit);
> +       if (CHECK(IS_ERR(link), "attach_fexit", "err: %ld\n", PTR_ERR(link)))
> +               goto cleanup;
> +
> +       ASSERT_ERR(delete_module("bpf_testmod", 0), "delete_module");
> +       bpf_link__destroy(link);
> +
>  cleanup:
>         test_module_attach__destroy(skel);
>  }
> --
> 2.30.2
>
