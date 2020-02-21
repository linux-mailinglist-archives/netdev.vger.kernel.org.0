Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03958166E9D
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 05:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbgBUEpg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 23:45:36 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44778 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729562AbgBUEpg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 23:45:36 -0500
Received: by mail-qt1-f196.google.com with SMTP id j23so422426qtr.11;
        Thu, 20 Feb 2020 20:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cOC2Qs5I2qPD/IgXM+le/ERJtFRbaaMcedt+UhFwrJA=;
        b=YjKk1vR8ZINNoHE5CLQOWazFRyPB3oEUrK/Q32zkvfyUseCa34tty+WW3uIstDyqTa
         2V7WdTap/Sk4bv9O1LdUKTfSYowbLOaeCbFM4F0jwGUZImLOLo4m8cDYcKbXa78vIHwb
         PRCEep/vlzls0W0glImjDMwZWTuzfyl954xXuurYV05lZ2UdFHYjRbVuq3pKsgJRAhnR
         aXtk/iWqf3WAEDlqyhzHiBcwGiS9/BmgozKB276Q0/V+kXQAMYYRlsDBw84NV9/NgSuF
         6DmEzYKazCjmNcmw0I0AvkUVVpRaeoL4sqCAbwV45uev3w5c+s4ef3HWtufc1xsR6Gk4
         3uuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cOC2Qs5I2qPD/IgXM+le/ERJtFRbaaMcedt+UhFwrJA=;
        b=BaqABveJFsh3bxzhte9iIgtXWrLpBnILEwTrMtlcPxzrY02pVSv65jA1hrUvChupTg
         nRGMod3M3yzACjbz15P2+OHg5UzCZzm+JKqzUNQumsCYGErV4K0i+x6VH4dNn8LtZDFD
         yK5SxPpl9Ol9QvHAqTF824twqnMTSHaszx4+Bxpr9Wiqr1jORB6qsY1ytL7XQDAggOol
         BwXNlxZbrKKl614iWNHOaezBnKBYgjWkAcz2HJNH4DE/eyHWPHPKeOt6aqo7s73mmeb9
         AE+7r8O2bKqHu1EuD/rOMgu3jW+ZTlBSex/F5pOF1XN3BznRhHs1wPbWstzxcS9kZqS1
         OeZw==
X-Gm-Message-State: APjAAAUd4NEw8c3g8WEwOpQ3bJGaasC0PepojSb3wiXC6usS9RKcHiKW
        Ug6S0rJrIli00W8YTxPocrQW8jhozs5QBkcMrn0=
X-Google-Smtp-Source: APXvYqzcGrYL7a41EY2Rs+dmj8c6c4zUFbPH3J2QC7DQIwxIu5ZpwY5/hb2BVR0bZYM4o5HdVU2wKguapG12ijHStLs=
X-Received: by 2002:ac8:5457:: with SMTP id d23mr28484470qtq.93.1582260334136;
 Thu, 20 Feb 2020 20:45:34 -0800 (PST)
MIME-Version: 1.0
References: <20200220230546.769250-1-andriin@fb.com> <CAPhsuW60BM0JjTBLyE3mYea+W-5CFPouveMfEwkbMEwQUbNbZg@mail.gmail.com>
 <c7df7db0-0c47-37a5-0764-ee45864f7e55@fb.com> <51BC422F-DEC7-4CCC-974C-48A6B50022FB@fb.com>
In-Reply-To: <51BC422F-DEC7-4CCC-974C-48A6B50022FB@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 20 Feb 2020 20:45:23 -0800
Message-ID: <CAEf4BzbUuv2cnG_sKm-Ok2m4Jw6kC6ghMtccM8pc1i0YtO=h0Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix trampoline_count clean up logic
To:     Song Liu <songliubraving@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, Song Liu <song@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>, Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 20, 2020 at 8:31 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Feb 20, 2020, at 8:20 PM, Andrii Nakryiko <andriin@fb.com> wrote:
> >
> > On 2/20/20 6:06 PM, Song Liu wrote:
> >> On Thu, Feb 20, 2020 at 3:07 PM Andrii Nakryiko <andriin@fb.com> wrote:
> >>>
> >>> Libbpf's Travis CI tests caught this issue. Ensure bpf_link and bpf_object
> >>> clean up is performed correctly.
> >>>
> >>> Fixes: d633d57902a5 ("selftest/bpf: Add test for allowed trampolines count")
> >>> Cc: Jiri Olsa <jolsa@kernel.org>
> >>> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> >>> ---
> >>>  .../bpf/prog_tests/trampoline_count.c         | 25 +++++++++++++------
> >>>  1 file changed, 18 insertions(+), 7 deletions(-)
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> >>> index 1f6ccdaed1ac..781c8d11604b 100644
> >>> --- a/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> >>> +++ b/tools/testing/selftests/bpf/prog_tests/trampoline_count.c
> >>> @@ -55,31 +55,40 @@ void test_trampoline_count(void)
> >>>         /* attach 'allowed' 40 trampoline programs */
> >>>         for (i = 0; i < MAX_TRAMP_PROGS; i++) {
> >>>                 obj = bpf_object__open_file(object, NULL);
> >>> -               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj)))
> >>> +               if (CHECK(IS_ERR(obj), "obj_open_file", "err %ld\n", PTR_ERR(obj))) {
> >>> +                       obj = NULL;
> >> I think we don't need obj and link in cleanup? Did I miss anything?
> >
> > We do set obj below (line 87) after this loop, so need to clean it up as well. As for link, yeah, technically link doesn't have to be set to NULL, but I kind of did it for completeness without thinking too much.
>
> I meant "obj = NULL;" before "goto cleanup;", as we don't use obj in the
> cleanup path.
>
> Anyway, this is not a real issue.

Ah, I see what you are saying, we skip over that bpf_object__close()
call, right.

>
> Thanks,
> Song
>
