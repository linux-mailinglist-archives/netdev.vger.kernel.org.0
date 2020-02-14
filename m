Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00CD515F053
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388754AbgBNRyD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:54:03 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:38448 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388618AbgBNRyC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 12:54:02 -0500
Received: by mail-qk1-f194.google.com with SMTP id z19so10014826qkj.5;
        Fri, 14 Feb 2020 09:54:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WvhILt6tPP0OHZxfssLr4mmrk5pWCDDsreMb5sB47qY=;
        b=Eyayccx+zpI5bL9Frh1yHdrZJVcFjRIXP0Y0bH4ogC+QDO/eTm50hcbEg4swRS9Civ
         wiZ4KpRP+/lR1qA4RC8ehof2MYPsNHNHGeNYdK59Z1UQQa5H2v4HviD3bEziXo7TbVhT
         lcK6P4YwBylg2oYzMkEbP9u6bD8KjB3zUxgAbT648CPSUlQtkhpilUhsGiQrYeS9kRf2
         D8c38YLzx3HzjVIo07j4ffa8WCfHkJokBEPasltmJiT2zFMvF9KcwFajVe1zGD+TG4yu
         PArXeVsgJfFrWdjhkE2miN7gQ+Rg+kSotCkW4tR+YVp/TBCiD8/xP+TNK9nvj9hvHB9c
         P8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WvhILt6tPP0OHZxfssLr4mmrk5pWCDDsreMb5sB47qY=;
        b=XIr+zxIzHS6LOpAoSLy1BbzDctiJViY2Sz3MJ/xhyBeBnQs2ZDqQb/K27d2JBi9/UH
         8xt9QMMO1Fiu3ltt5oYLV1moWNvIcVT0aLM8MWCo97YbgIB08gqpBa+/lG7tqe1sP8cb
         N1qTtDlmF04CfjnVtyVbgb8VITpXok4NPSUSA+Bj2XcI+H4CVUCo2rw6C1nQLeVgWOsX
         eguwrBP/kjB4eUj7KrMsJbq+YuRyVhpCeYbtQ8o4Cm9gskAs69SwDpV2FyOaEoUL8ukS
         tHzvIvm658+5KivsLznlfnaqRdqVvUnUhF85f0TCS4e+CZ7ijwlXBuXuugsew1nXz5Mm
         ItvQ==
X-Gm-Message-State: APjAAAXFlY6DC89QXABiGmAGI1BbdD8RCsCbENm+4/roNFB3QdMKW/Tc
        vHcj02R8ippQmZHGROvXqRJiPnJwQPJ9TmOEz0I=
X-Google-Smtp-Source: APXvYqzChKM6+5lq4rI8BD0xaZHNjRCCBF0bQsBaYoIj+aKqYbgMQdMUlt2TezVAcgNTvCA3Sfrb2bxha5o8Jj1LnmA=
X-Received: by 2002:a37:2744:: with SMTP id n65mr3715809qkn.92.1581702841141;
 Fri, 14 Feb 2020 09:54:01 -0800 (PST)
MIME-Version: 1.0
References: <158160616195.80320.5636088335810242866.stgit@xdp-tutorial>
 <CAEf4Bzb59yjEMzs=n7pmbCB-L6RfmGDQiOwDFBoh54aSps4Vsg@mail.gmail.com> <E8D7E3C9-A0C8-4AFC-A7AE-BB6123E687C8@redhat.com>
In-Reply-To: <E8D7E3C9-A0C8-4AFC-A7AE-BB6123E687C8@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Feb 2020 09:53:50 -0800
Message-ID: <CAEf4Bzb5weXyNxnmsNDZkFANk4YH6OU+OoRb5H4KKWjoUvvMnQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] libbpf: Add support for dynamic program
 attach target
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 13, 2020 at 11:34 PM Eelco Chaudron <echaudro@redhat.com> wrote=
:
>
>
>
> On 13 Feb 2020, at 18:42, Andrii Nakryiko wrote:
>
> > On Thu, Feb 13, 2020 at 7:05 AM Eelco Chaudron <echaudro@redhat.com>
> > wrote:
> >>
> >> Currently when you want to attach a trace program to a bpf program
> >> the section name needs to match the tracepoint/function semantics.
> >>
> >> However the addition of the bpf_program__set_attach_target() API
> >> allows you to specify the tracepoint/function dynamically.
> >>
> >> The call flow would look something like this:
> >>
> >>   xdp_fd =3D bpf_prog_get_fd_by_id(id);
> >>   trace_obj =3D bpf_object__open_file("func.o", NULL);
> >>   prog =3D bpf_object__find_program_by_title(trace_obj,
> >>                                            "fentry/myfunc");
> >>   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
> >>   bpf_program__set_attach_target(prog, xdp_fd,
> >>                                  "xdpfilt_blk_all");
> >>   bpf_object__load(trace_obj)
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> ---
> >
> > API-wise this looks good, thanks! Please address feedback below and
> > re-submit once bpf-next opens. Can you please also convert one of
> > existing selftests using open_opts's attach_prog_fd to use this API
> > instead to have a demonstration there?
>
> Yes will update the one I added for bfp2bpf testing=E2=80=A6
>
> >> v1 -> v2: Remove requirement for attach type name in API
> >>
> >>  tools/lib/bpf/libbpf.c   |   33 +++++++++++++++++++++++++++++++--
> >>  tools/lib/bpf/libbpf.h   |    4 ++++
> >>  tools/lib/bpf/libbpf.map |    1 +
> >>  3 files changed, 36 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >> index 514b1a524abb..9b8cab995580 100644
> >> --- a/tools/lib/bpf/libbpf.c
> >> +++ b/tools/lib/bpf/libbpf.c
> >> @@ -4939,8 +4939,8 @@ int bpf_program__load(struct bpf_program *prog,
> >> char *license, __u32 kern_ver)
> >>  {
> >>         int err =3D 0, fd, i, btf_id;
> >>
> >> -       if (prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
> >> -           prog->type =3D=3D BPF_PROG_TYPE_EXT) {
> >> +       if ((prog->type =3D=3D BPF_PROG_TYPE_TRACING ||
> >> +            prog->type =3D=3D BPF_PROG_TYPE_EXT) &&
> >> !prog->attach_btf_id) {
> >>                 btf_id =3D libbpf_find_attach_btf_id(prog);
> >>                 if (btf_id <=3D 0)
> >>                         return btf_id;
> >> @@ -8132,6 +8132,35 @@ void bpf_program__bpil_offs_to_addr(struct
> >> bpf_prog_info_linear *info_linear)
> >>         }
> >>  }
> >>
> >> +int bpf_program__set_attach_target(struct bpf_program *prog,
> >> +                                  int attach_prog_fd,
> >> +                                  const char *attach_func_name)
> >> +{
> >> +       int btf_id;
> >> +
> >> +       if (!prog || attach_prog_fd < 0 || !attach_func_name)
> >> +               return -EINVAL;
> >> +
> >> +       if (attach_prog_fd)
> >> +               btf_id =3D libbpf_find_prog_btf_id(attach_func_name,
> >> +                                                attach_prog_fd);
> >> +       else
> >> +               btf_id =3D
> >> __find_vmlinux_btf_id(prog->obj->btf_vmlinux,
> >> +                                              attach_func_name,
> >> +
> >> prog->expected_attach_type);
> >> +
> >> +       if (btf_id <=3D 0) {
> >> +               if (!attach_prog_fd)
> >> +                       pr_warn("%s is not found in vmlinux BTF\n",
> >> +                               attach_func_name);
> >
> > libbpf_find_attach_btf_id's error reporting is misleading (it always
> > reports as if error happened with vmlinux BTF, even if attach_prog_fd
> > 0). Could you please fix that and add better error reporting here
> > for attach_prog_fd>0 case here?
> >
>
> I did not add log messages for the btf_id > 0 case as they are covered
> in the libbpf_find_prog_btf_id() function. Please let me know if this is
> not enough.

I see... libbpf_find_attach_btf_id is still wrong, so maybe let's move
this warning into __find_vmlinux_btf_id for more symmetrical (with
libbpf_find_prog_btf_id) error reporting?

>
> >> +               return btf_id;
> >> +       }
> >> +
> >> +       prog->attach_btf_id =3D btf_id;
> >> +       prog->attach_prog_fd =3D attach_prog_fd;
> >> +       return 0;
> >> +}
> >> +
> >>  int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
> >>  {
> >>         int err =3D 0, n, len, start, end =3D -1;
> >> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> >> index 3fe12c9d1f92..02fc58a21a7f 100644
> >> --- a/tools/lib/bpf/libbpf.h
> >> +++ b/tools/lib/bpf/libbpf.h
> >> @@ -334,6 +334,10 @@ LIBBPF_API void
> >>  bpf_program__set_expected_attach_type(struct bpf_program *prog,
> >>                                       enum bpf_attach_type type);
> >>
> >> +LIBBPF_API int
> >> +bpf_program__set_attach_target(struct bpf_program *prog, int
> >> attach_prog_fd,
> >> +                              const char *attach_func_name);
> >> +
> >>  LIBBPF_API bool bpf_program__is_socket_filter(const struct
> >> bpf_program *prog);
> >>  LIBBPF_API bool bpf_program__is_tracepoint(const struct bpf_program
> >> *prog);
> >>  LIBBPF_API bool bpf_program__is_raw_tracepoint(const struct
> >> bpf_program *prog);
> >> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> >> index b035122142bb..8aba5438a3f0 100644
> >> --- a/tools/lib/bpf/libbpf.map
> >> +++ b/tools/lib/bpf/libbpf.map
> >> @@ -230,6 +230,7 @@ LIBBPF_0.0.7 {
> >>                 bpf_program__name;
> >>                 bpf_program__is_extension;
> >>                 bpf_program__is_struct_ops;
> >> +               bpf_program__set_attach_target;
> >
> > This will have to go into LIBBPF_0.0.8 once bpf-next opens. Please
> > rebase and re-send then.
>
> Will do=E2=80=A6
>
> >>                 bpf_program__set_extension;
> >>                 bpf_program__set_struct_ops;
> >>                 btf__align_of;
> >>
>
