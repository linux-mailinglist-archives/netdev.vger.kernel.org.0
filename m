Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 200D93D3CF0
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 17:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235795AbhGWPOY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 11:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235796AbhGWPON (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 11:14:13 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAAD0C061575;
        Fri, 23 Jul 2021 08:54:44 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id k65so2960654yba.13;
        Fri, 23 Jul 2021 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ju/B2HenKORYoXITNR9EZG98UjeDf3i93fjAOU3sJWI=;
        b=D52BfguKCAbmlldWH8RLszuxDym1CVOSEo2xYr+Rm3gcCg2OOdbw4XowjhRSrZJRoa
         /chtuzLyfzrYtVutb2d6/H9GcpFHjKhjPitfKzzY0hjWx1gs6SfMDs0SkErkWydYO0MX
         so4L0JdI3vt9GQRZuxXwBFX2Ji8btsq+85yPXt5oppYCsINSPS1TQlTDnyUz3VEUp/y1
         JxXyCmURX1JodWrpVp8pHOsi7edE9yp+HwKKTiQgEBORak/S8WD+4ij0OBkm58vqr7Oo
         xZGL5Fm1D1cTSAfjemu7YV5K2rnw0fAWtKgOxDHSGN1HNmw/eD8i9i+VCE5ROzqGdGGY
         yJ5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ju/B2HenKORYoXITNR9EZG98UjeDf3i93fjAOU3sJWI=;
        b=eVq6TLzC4UM9t4BoFXlwB9zMLwslUvAleI4XNwJHL+5DE0xCMaLzRcHFFStqN1yNNo
         ArxvY8eH5Y46T/14AbRqBvqE8MEHhRCcEFnWBWJxaY/2MFc4PPuWIhs6caH2BuTKjYfD
         ksuDE7eHwu2yyIZWe28O72XYR2wcA5lG2TR/oWKOO0ooNjnjgYwm/Zb6/dBYLhCHVWb6
         f1+azi7dBnGT6SQn42IX1AiG27EZ+tTuZDlmsvSgNLsUBxPgP/k0EfVF78jxPgpVdmas
         tzQnwl/1beSYhLgtmRbuW01t39axQUwf+EyjUA3gkRH8rwC2VTQQBGiJ5D0lfm8jYgKf
         1LQA==
X-Gm-Message-State: AOAM531gkmNjYqp7oEsYmYpVw6srV81jiM3L6FRBXgJv7iu4L+utov9+
        FwUnQGMwTk8WO5be8ia/4D83LO6keMQ6yvm5u4k=
X-Google-Smtp-Source: ABdhPJx2dgVzeViGJbQUaH5bDCjEqywhytUdNHAGSdhFL2483rx8zKidXpkrqP1caW8z6OxKXarqkUaQPFxlEtC9hkI=
X-Received: by 2002:a25:b203:: with SMTP id i3mr7229599ybj.260.1627055683949;
 Fri, 23 Jul 2021 08:54:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210721153808.6902-1-quentin@isovalent.com> <20210721153808.6902-3-quentin@isovalent.com>
 <CAEf4BzZqEZLt0_qgmniY-hqgEg7q0ur0Z5U0r8KFTwSz=2StSg@mail.gmail.com> <88d3cd19-5985-ad73-5f23-4f6f7d1b1be2@isovalent.com>
In-Reply-To: <88d3cd19-5985-ad73-5f23-4f6f7d1b1be2@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 23 Jul 2021 08:54:32 -0700
Message-ID: <CAEf4BzY4jVKN=3CdaLU1WOekGbT915dweNx0R4KMrW8U7E20cw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/5] libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 2:31 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2021-07-22 17:39 UTC-0700 ~ Andrii Nakryiko <andrii.nakryiko@gmail.com>
> > On Wed, Jul 21, 2021 at 8:38 AM Quentin Monnet <quentin@isovalent.com> wrote:
> >>
> >> Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
> >> better indicate what the function does. Change the new function so that,
> >> instead of requiring a pointer to the pointer to update and returning
> >> with an error code, it takes a single argument (the id of the BTF
> >> object) and returns the corresponding pointer. This is more in line with
> >> the existing constructors.
> >>
> >> The other tools calling the deprecated btf__get_from_id() function will
> >> be updated in a future commit.
> >>
> >> References:
> >>
> >> - https://github.com/libbpf/libbpf/issues/278
> >> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
> >>
> >> v2:
> >> - Instead of a simple renaming, change the new function to make it
> >>   return the pointer to the btf struct.
> >> - API v0.5.0 instead of v0.6.0.
> >
> > We generally keep such version changes to cover letters. It keeps each
> > individual commit clean and collects full history in the cover letter
> > which becomes a body of merge commit when the whole patch set is
> > applied. For next revision please consolidate the history in the cover
> > letter. Thanks!
>
> OK will do.
> I've seen other folks detailing the changes on individual patches, and
> done so in the past, although it's true the current trend is to have it
> in the cover letter (and I understand the motivation).
>
> >
> >>
> >> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> >> Acked-by: John Fastabend <john.fastabend@gmail.com>
> >> ---
> >>  tools/lib/bpf/btf.c      | 25 +++++++++++++++++--------
> >>  tools/lib/bpf/btf.h      |  1 +
> >>  tools/lib/bpf/libbpf.c   |  5 +++--
> >>  tools/lib/bpf/libbpf.map |  1 +
> >>  4 files changed, 22 insertions(+), 10 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> >> index 7e0de560490e..6654bdee7ad7 100644
> >> --- a/tools/lib/bpf/btf.c
> >> +++ b/tools/lib/bpf/btf.c
> >> @@ -1383,21 +1383,30 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
> >>         return btf;
> >>  }
> >>
> >> +struct btf *btf__load_from_kernel_by_id(__u32 id)
> >> +{
> >> +       struct btf *btf;
> >> +       int btf_fd;
> >> +
> >> +       btf_fd = bpf_btf_get_fd_by_id(id);
> >> +       if (btf_fd < 0)
> >> +               return ERR_PTR(-errno);
> >
> > please use libbpf_err_ptr() for consistency, see
> > bpf_object__open_mem() for an example
>
> I can do that, but I'll need to uncouple btf__get_from_id() from the new
> function. If it calls btf__load_from_kernel_by_id() and
> LIBBPF_STRICT_CLEAN_PTRS is set, it would change its return value.

No it won't, if libbpf_get_error() is used right after the API call.
With CLEAN_PTRS the result pointer is NULL but actual error is passed
through errno. libbpf_get_error() knows about this and extracts error
from errno if passed NULL pointer. With returning ERR_PTR(-errno) from
btf__load_from_kernel_by_id() you are breaking CLEAN_PTRS guarantees.

>
> >
> >> +
> >> +       btf = btf_get_from_fd(btf_fd, NULL);
> >> +       close(btf_fd);
> >> +
> >> +       return libbpf_ptr(btf);
> >> +}
> >> +
> >>  int btf__get_from_id(__u32 id, struct btf **btf)
> >>  {
> >>         struct btf *res;
> >> -       int err, btf_fd;
> >> +       int err;
> >>
> >>         *btf = NULL;
> >> -       btf_fd = bpf_btf_get_fd_by_id(id);
> >> -       if (btf_fd < 0)
> >> -               return libbpf_err(-errno);
> >> -
> >> -       res = btf_get_from_fd(btf_fd, NULL);
> >> +       res = btf__load_from_kernel_by_id(id);
> >>         err = libbpf_get_error(res);
> >>
> >> -       close(btf_fd);
> >> -
> >>         if (err)
> >>                 return libbpf_err(err);
> >>
> >> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> >> index fd8a21d936ef..3db9446bc133 100644
> >> --- a/tools/lib/bpf/btf.h
> >> +++ b/tools/lib/bpf/btf.h
> >> @@ -68,6 +68,7 @@ LIBBPF_API const void *btf__get_raw_data(const struct btf *btf, __u32 *size);
> >>  LIBBPF_API const char *btf__name_by_offset(const struct btf *btf, __u32 offset);
> >>  LIBBPF_API const char *btf__str_by_offset(const struct btf *btf, __u32 offset);
> >>  LIBBPF_API int btf__get_from_id(__u32 id, struct btf **btf);
> >> +LIBBPF_API struct btf *btf__load_from_kernel_by_id(__u32 id);
> >
> > let's move this definition to after btf__parse() to keep all
> > "constructors" together (we can move btf__get_from_id() there for
> > completeness as well, I suppose).
>
> I thought about that but wasn't sure, OK will do.

Ok, thanks.

>
> >
> >>  LIBBPF_API int btf__get_map_kv_tids(const struct btf *btf, const char *map_name,
> >>                                     __u32 expected_key_size,
> >>                                     __u32 expected_value_size,
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 242e97892043..eff005b1eba1 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -9576,8 +9576,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
> >>  {
> >>         struct bpf_prog_info_linear *info_linear;
> >>         struct bpf_prog_info *info;
> >> -       struct btf *btf = NULL;
> >>         int err = -EINVAL;
> >> +       struct btf *btf;
> >>
> >>         info_linear = bpf_program__get_prog_info_linear(attach_prog_fd, 0);
> >>         err = libbpf_get_error(info_linear);
> >> @@ -9591,7 +9591,8 @@ static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
> >>                 pr_warn("The target program doesn't have BTF\n");
> >>                 goto out;
> >>         }
> >> -       if (btf__get_from_id(info->btf_id, &btf)) {
> >> +       btf = btf__load_from_kernel_by_id(info->btf_id);
> >> +       if (libbpf_get_error(btf)) {
> >
> > there seems to be a bug in existing code and you are keeping it. On
> > error err will be 0. Let's fix it. Same for above if (!info->btf_id),
> > please fix that as well while you are at it.
>
> Oh right, I saw that err was initialised at -EINVAL and did not notice
> it was changed for the info_linear. I'll address it.

cool, thanks
