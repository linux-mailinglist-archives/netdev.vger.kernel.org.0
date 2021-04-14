Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5289735FDAE
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 00:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231978AbhDNWTK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 18:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231810AbhDNWTF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 18:19:05 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 859ABC061574;
        Wed, 14 Apr 2021 15:18:43 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id v72so3161203ybe.11;
        Wed, 14 Apr 2021 15:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wYH10MbmWkC6SLfT4Lj8aUbTLV+tTgRo3/HUb5Du50M=;
        b=K4u4UuFmcaz4JoZ6hEXXAahwXPSKVKeLdgF+4mMUIM1h4Hs4gJ8NaecF8gmpk8RM58
         qOaKydKW88Eyn1Vk1PQmOIXXFNFOiZPQ7RkG+lPbTSB38QsXD6Cy2aqouoQU3eL0T7rY
         oazGP8ONdOV4GIvNcrw6nBcnRTxrnmywvbkwmUP2vJ8C7zYhbq+suUhPsT1bn58KQQhm
         +bINRNgEqSeoODr0hPg7odF7ja+5sEgWxEo/Nvqfeb/ycUdpKMYONyfKPtff+Ap66SNI
         SCb4EuKRnRx8+4Bf7UXHRGDFw+MPRCaGe3KOyTSdXD+YNsjFdDTxXOC+2HTQzVuuUkW6
         VoiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wYH10MbmWkC6SLfT4Lj8aUbTLV+tTgRo3/HUb5Du50M=;
        b=X6oCRlKh07UpjgAEZv8iR4cWXTrHrMHahMtvRcj9nwo/+su6MaEMvEawPUqpZ1oPtW
         QSm39gFefEHZStcHVmd3Xfp7FyoOk/i2mOcMWzftqmthCCAZ7+xxyLK40ufFs3JQBFt8
         oSbHneNIPqAle0K8uOUYp9tT3UAxn8um4CukoSuDbD0b4bVQcBndBfI/mSnMw3e3h42K
         hs+N6sqxt/B3WIHjQMN48X3EyuY74yAO+CCjRP1HDYyNaoVMpnrxkouMAg5u9c+1JBMC
         Epg/3BaqE6ecdgGfkv+ohkmQBW/5s5Sismdqsksdkacsgp3pd1+8K6t2D0yvpbSX+LXG
         XN0g==
X-Gm-Message-State: AOAM532rRp9bS5WGbwg0B3NEDqDMfFazXpfgqfe8wK5utOgOE01/pOme
        61h1OxK050+DDwnVbA2UgmfWTznqMRnn8ha3nTo=
X-Google-Smtp-Source: ABdhPJx14zKg1Wr4e/0JQl4CrjIv3oDs0T9piXSUZ9E/yIcSuyDJnXpzOAipaz35SGpEf6aqBOi6Ueq50DZjrPR0y24=
X-Received: by 2002:a25:9942:: with SMTP id n2mr291642ybo.230.1618438722876;
 Wed, 14 Apr 2021 15:18:42 -0700 (PDT)
MIME-Version: 1.0
References: <20210412162502.1417018-1-jolsa@kernel.org> <20210412162502.1417018-3-jolsa@kernel.org>
 <CAEf4Bza6OXC4aVuxVGnn-DOANuFbnuJ++=q8fFpD-f48kb7_pw@mail.gmail.com> <YHbKexxx+jyMeVnM@krava>
In-Reply-To: <YHbKexxx+jyMeVnM@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 14 Apr 2021 15:18:32 -0700
Message-ID: <CAEf4Bzb4TnKXtaEiGVuOUHTuj++OMVHuNSxUraJhzj4jGkOZJg@mail.gmail.com>
Subject: Re: [PATCHv4 bpf-next 2/5] selftests/bpf: Add re-attach test to fentry_test
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Julia Lawall <julia.lawall@inria.fr>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 14, 2021 at 3:57 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Tue, Apr 13, 2021 at 02:54:10PM -0700, Andrii Nakryiko wrote:
>
> SNIP
>
> > >         __u32 duration = 0, retval;
> > > +       struct bpf_link *link;
> > >         __u64 *result;
> > >
> > > -       fentry_skel = fentry_test__open_and_load();
> > > -       if (CHECK(!fentry_skel, "fentry_skel_load", "fentry skeleton failed\n"))
> > > -               goto cleanup;
> > > -
> > >         err = fentry_test__attach(fentry_skel);
> > > -       if (CHECK(err, "fentry_attach", "fentry attach failed: %d\n", err))
> > > -               goto cleanup;
> > > +       if (!ASSERT_OK(err, "fentry_attach"))
> > > +               return err;
> > > +
> > > +       /* Check that already linked program can't be attached again. */
> > > +       link = bpf_program__attach(fentry_skel->progs.test1);
> > > +       if (!ASSERT_ERR_PTR(link, "fentry_attach_link"))
> > > +               return -1;
> > >
> > >         prog_fd = bpf_program__fd(fentry_skel->progs.test1);
> > >         err = bpf_prog_test_run(prog_fd, 1, NULL, 0,
> > >                                 NULL, NULL, &retval, &duration);
> > > -       CHECK(err || retval, "test_run",
> > > -             "err %d errno %d retval %d duration %d\n",
> > > -             err, errno, retval, duration);
> > > +       ASSERT_OK(err || retval, "test_run");
> >
> > this is quite misleading, even if will result in a correct check. Toke
> > did this in his patch set:
> >
> > ASSERT_OK(err, ...);
> > ASSERT_EQ(retval, 0, ...);
> >
> > It is a better and more straightforward way to validate the checks
> > instead of relying on (err || retval) -> bool (true) -> int (1) -> !=
> > 0 chain.
>
> ok, makes sense
>
> SNIP
>
> > > +void test_fentry_test(void)
> > > +{
> > > +       struct fentry_test *fentry_skel = NULL;
> > > +       int err;
> > > +
> > > +       fentry_skel = fentry_test__open_and_load();
> > > +       if (!ASSERT_OK_PTR(fentry_skel, "fentry_skel_load"))
> > > +               goto cleanup;
> > > +
> > > +       err = fentry_test(fentry_skel);
> > > +       if (!ASSERT_OK(err, "fentry_first_attach"))
> > > +               goto cleanup;
> > > +
> > > +       err = fentry_test(fentry_skel);
> > > +       ASSERT_OK(err, "fentry_second_attach");
> > > +
> > >  cleanup:
> > >         fentry_test__destroy(fentry_skel);
> > >  }
> > > diff --git a/tools/testing/selftests/bpf/test_progs.h b/tools/testing/selftests/bpf/test_progs.h
> > > index e87c8546230e..ee7e3b45182a 100644
> > > --- a/tools/testing/selftests/bpf/test_progs.h
> > > +++ b/tools/testing/selftests/bpf/test_progs.h
> > > @@ -210,7 +210,7 @@ extern int test__join_cgroup(const char *path);
> > >  #define ASSERT_ERR_PTR(ptr, name) ({                                   \
> > >         static int duration = 0;                                        \
> > >         const void *___res = (ptr);                                     \
> > > -       bool ___ok = IS_ERR(___res)                                     \
> > > +       bool ___ok = IS_ERR(___res);                                    \
> >
> > heh, it probably deserves a separate patch with Fixes tag...
>
> va bene

Where would I learn some Italian if not on bpf@vger :)

>
> jirka
>
