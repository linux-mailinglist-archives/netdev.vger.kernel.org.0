Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C44E2CEF58
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 01:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfJGXBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Oct 2019 19:01:03 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:35598 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729440AbfJGXBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Oct 2019 19:01:03 -0400
Received: by mail-qk1-f193.google.com with SMTP id w2so14449296qkf.2;
        Mon, 07 Oct 2019 16:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xTjqa5qn/Atk0L8cd3no/IgH0dWjaMBMqyCTniSMesY=;
        b=kCoeQHUfUXBiU/Uung7W4E5ddCLcsU2A/hqEt4UM6/4Hqy7e7THIPJNXLvp3YeRGwI
         SIH3f+pRanRbyJYmnVJ5Rx09PnMzkXjEvuqfizYNfavApV0EyV/35+gp61gQojCTyptN
         adKiDzZ611w202Lzs9aHhEr5VoTamXmvPNWgm/ABrbCEdDBVrbDTP5pGrkaEWZuf6mB2
         4hXmhMClvrB0kVQyRGfRxXOuIH6qTuTqwL4jYjRA/1nptc+3f7jpQnGz/upTBrbDxFfe
         6TcM+LfaXD40/A1Z9K6DubESbtA6+LLlyA2cvJfux0duFVETIM1A/Sxwe7LhGxvQrjcY
         UGtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xTjqa5qn/Atk0L8cd3no/IgH0dWjaMBMqyCTniSMesY=;
        b=h760IHnYqXtj5umMCS8DuW1vLeFBDxTdK1zmnGxeuyLTLllDKIHKWRPo5No2XcTea9
         DFl0OCosZKnF/l9K2RqmXxoSIvNPXgX0ZhBAli8xrEYhlDK2JZIqsBS2y7SBJN1k9YKz
         zoWtJhhN9VCzYrchQ9omJjQ5ntktzVLubBB39C8oqUCFYJwuJDuG34vtg3Uvbuu29Bum
         feAM4tuJDVrmbJoYyKD9NY743/leaJ5GnFh6Eia7r8D7qc5joKpJ2QeIuFcyUcK8eAmp
         pl6XKmjmpUHu3SCOz/4lQFtNUqTdZFzvyswkqGLfmS0OQfun/icZBj5DPlxUoejofZft
         I1sA==
X-Gm-Message-State: APjAAAVCVDg5vPl5Ev3dRCwBw+mg4qlIV6TdyvDI0DXn5wW7W4j2yxlG
        fbHlSiHmeaVvzejv9adfSu/qKmdej5eUui1sS4I=
X-Google-Smtp-Source: APXvYqyb4hGra7pKCWcM590s2dTWwkXzN5V+gp1jzP+aXurHF2YycVQzLHrTNHFf6jQi57jVs8NFA0QD/SjDkeR4ihw=
X-Received: by 2002:ae9:eb93:: with SMTP id b141mr26807911qkg.36.1570489260765;
 Mon, 07 Oct 2019 16:01:00 -0700 (PDT)
MIME-Version: 1.0
References: <20191007212237.1704211-1-andriin@fb.com> <20191007214650.GC2096@mini-arch>
 <CAEf4Bzba7S=hUkxTvL3Y+QYxAxZ-am5w-mzk8Aks7csx-g0FPA@mail.gmail.com>
In-Reply-To: <CAEf4Bzba7S=hUkxTvL3Y+QYxAxZ-am5w-mzk8Aks7csx-g0FPA@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Oct 2019 16:00:49 -0700
Message-ID: <CAEf4BzYh4pN3FPYHRMRwAUFEK0E+wXqLSqjZE3FZEmyhzCwuig@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpftool: fix bpftool build by switching to bpf_object__open_file()
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Stanislav Fomichev <sdf@google.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- Andrii

On Mon, Oct 7, 2019 at 2:50 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Mon, Oct 7, 2019 at 2:46 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> >
> > On 10/07, Andrii Nakryiko wrote:
> > > As part of libbpf in 5e61f2707029 ("libbpf: stop enforcing kern_version,
> > > populate it for users") non-LIBBPF_API __bpf_object__open_xattr() API
> > > was removed from libbpf.h header. This broke bpftool, which relied on
> > > that function. This patch fixes the build by switching to newly added
> > > bpf_object__open_file() which provides the same capabilities, but is
> > > official and future-proof API.
> > >
> > > Fixes: 5e61f2707029 ("libbpf: stop enforcing kern_version, populate it for users")
> > > Reported-by: Stanislav Fomichev <sdf@google.com>
> > > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > > ---
> > >  tools/bpf/bpftool/main.c |  4 ++--
> > >  tools/bpf/bpftool/main.h |  2 +-
> > >  tools/bpf/bpftool/prog.c | 22 ++++++++++++----------
> > >  3 files changed, 15 insertions(+), 13 deletions(-)
> > >

[...]

> > > --- a/tools/bpf/bpftool/prog.c
> > > +++ b/tools/bpf/bpftool/prog.c
> > > @@ -1092,9 +1092,7 @@ static int do_run(int argc, char **argv)
> > >  static int load_with_options(int argc, char **argv, bool first_prog_only)
> > >  {
> > >       struct bpf_object_load_attr load_attr = { 0 };
> > > -     struct bpf_object_open_attr open_attr = {
> > > -             .prog_type = BPF_PROG_TYPE_UNSPEC,
> > > -     };
> > > +     enum bpf_prog_type prog_type = BPF_PROG_TYPE_UNSPEC;
> > >       enum bpf_attach_type expected_attach_type;
> > >       struct map_replace *map_replace = NULL;

[...]

> > >
> > >       bpf_object__for_each_program(pos, obj) {
> > > -             enum bpf_prog_type prog_type = open_attr.prog_type;
> > > +             enum bpf_prog_type prog_type = prog_type;
> > Are you sure it works that way?
>
> Oh, I did this pretty mechanically, didn't notice I'm shadowing. In
> either case I'd like to avoid shadowing, so I'll rename one of them,
> good catch!
>
> >
> > $ cat tmp.c
> > #include <stdio.h>
> >
> > int main()
> > {
> >         int x = 1;
> >         printf("outer x=%d\n", x);
> >
> >         {
> >                 int x = x;

It's amazing `int x = x;` is compiled successfully when there is no x
in outer scope. And it's also amazing that it's doing the wrong thing
when there is a shadowed variable in outer scope. I can't imagine the
case where this will be a meaningful behavior...

> >                 printf("inner x=%d\n", x);
> >         }
> >
> >         return 0;
> > }
> >
> > $ gcc tmp.c && ./a.out
> > outer x=1
> > inner x=0
> >
> > Other than that:
> > Reviewed-by: Stanislav Fomichev <sdf@google.com>
> >
> > >
> > > -             if (open_attr.prog_type == BPF_PROG_TYPE_UNSPEC) {
> > > +             if (prog_type == BPF_PROG_TYPE_UNSPEC) {
> > >                       const char *sec_name = bpf_program__title(pos, false);
> > >
> > >                       err = libbpf_prog_type_by_name(sec_name, &prog_type,
> > > --
> > > 2.17.1
> > >
