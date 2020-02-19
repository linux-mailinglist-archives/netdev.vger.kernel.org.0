Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DAC15164C42
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 18:41:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726691AbgBSRlO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 12:41:14 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:43099 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbgBSRlO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 12:41:14 -0500
Received: by mail-io1-f67.google.com with SMTP id n21so1457231ioo.10;
        Wed, 19 Feb 2020 09:41:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VY82pYYJua9Ksnhbvd7OFWKnQNJgdkem3Mb9sIjiYWc=;
        b=ifx2XoXwkpC4t9K+zmFZ5YIdZ5wz2NQL8xOBzv3ceFyvyo457ajDpu04OsJIFNKDWX
         6Ttgxs/aTti5ttMlBN/pBFyWpUd5TlXBsnR+PskPl2MImbqFDt1U8VngpyBlspcKEwze
         Iyc09GkFbePT7nSsV1ziBRTpZXvB2Imt+0fUoS+7r1tXhep29QuB47zX5xEhKlZCp2NI
         Xk+y+gmHSE4uZC3HcePs5K2xZjYvILN+i5J6i/1zTEyLXMbgi4B2X/kqvnDbsYuyJ94l
         x1zDEPECd3aJBY6MAn6XQIDrz9a7q0tBEISUtk0rsW6gqBCSNzMV/+I0Dn/uZA7d/0/P
         C8jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VY82pYYJua9Ksnhbvd7OFWKnQNJgdkem3Mb9sIjiYWc=;
        b=Ltmxy8BAZbPY5OB6a+kTzYAGEdufwclq92vgOWcfhUF+TLOH7upWsPQLdEBol4+Irb
         4DmIvbQFk2Q4qLb2DcPxmni5/ldP6YjTW/nY+QTbi54JvZ5tR8By7Y3Z0BNW+59K8SeJ
         v/dsxYGgYNy1SuF2jUI53ZtCUl+7GuQsbPW3AgPmvG+KAx+2aKQJ9kITuet//XlzCew6
         ybONrfls2o6YFsSeZXEnSwzL/uHb9IDAfHWHCUgoPrYVm3SEaQ+2YrE+R5MkS+dvaM59
         rMCYuPhO8upYfq1Rd7KqMBbdPq8jVcYvKhj6NVMJ4IpgncA0B/lTZ9OUJeh8rAQgeNPI
         Qz9g==
X-Gm-Message-State: APjAAAUs33DY3qIri5OM07vJohR6v/ieX/QCJbmEO8I6b8K/SYwIwi9m
        ZZLiI1NkK4yY8i4DVIN5UACY9zboCPgsorUUHIw=
X-Google-Smtp-Source: APXvYqw9W3W3FvWUJb4xKANnhTCx+Lc/SLNz/4P++xvc0B+qTEV9lI26m1pt0bU+2Ul63xXACD3pFKqPBf7Mx62dy5o=
X-Received: by 2002:a05:6638:a31:: with SMTP id 17mr21042238jao.15.1582134073270;
 Wed, 19 Feb 2020 09:41:13 -0800 (PST)
MIME-Version: 1.0
References: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial>
 <158194341424.104074.4927911845622583345.stgit@xdp-tutorial>
 <877e0jam7z.fsf@cloudflare.com> <CAEf4BzZ_H7_HVL0uDkxP2hvW7FC=9r_V4X2VzgB+uZMZcxP7aQ@mail.gmail.com>
 <94BE5B07-CFC8-426F-B993-28D01E46BAE5@redhat.com>
In-Reply-To: <94BE5B07-CFC8-426F-B993-28D01E46BAE5@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 19 Feb 2020 09:41:02 -0800
Message-ID: <CAEf4BzY3cwPvj9=wo_GJxN=1=5fJL1RuhjEfey3N09GOL0YYfw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] libbpf: Add support for dynamic program
 attach target
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
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

On Wed, Feb 19, 2020 at 3:06 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
>
>
> On 18 Feb 2020, at 22:24, Andrii Nakryiko wrote:
>
> > On Tue, Feb 18, 2020 at 8:34 AM Jakub Sitnicki <jakub@cloudflare.com>
> > wrote:
> >>
> >> Hey Eelco,
> >>
> >> On Mon, Feb 17, 2020 at 12:43 PM GMT, Eelco Chaudron wrote:
> >>> Currently when you want to attach a trace program to a bpf program
> >>> the section name needs to match the tracepoint/function semantics.
> >>>
> >>> However the addition of the bpf_program__set_attach_target() API
> >>> allows you to specify the tracepoint/function dynamically.
> >>>
> >>> The call flow would look something like this:
> >>>
> >>>   xdp_fd =3D bpf_prog_get_fd_by_id(id);
> >>>   trace_obj =3D bpf_object__open_file("func.o", NULL);
> >>>   prog =3D bpf_object__find_program_by_title(trace_obj,
> >>>                                            "fentry/myfunc");
> >>>   bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
> >>>   bpf_program__set_attach_target(prog, xdp_fd,
> >>>                                  "xdpfilt_blk_all");
> >>>   bpf_object__load(trace_obj)
> >>>
> >>> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >>> ---
> >>>  tools/lib/bpf/libbpf.c   |   34 ++++++++++++++++++++++++++++++----
> >>>  tools/lib/bpf/libbpf.h   |    4 ++++
> >>>  tools/lib/bpf/libbpf.map |    2 ++
> >>>  3 files changed, 36 insertions(+), 4 deletions(-)
> >>>
> >>> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> >>> index 514b1a524abb..0c25d78fb5d8 100644
> >>> --- a/tools/lib/bpf/libbpf.c
> >>> +++ b/tools/lib/bpf/libbpf.c
> >>
> >> [...]
> >>
> >>> @@ -8132,6 +8133,31 @@ void bpf_program__bpil_offs_to_addr(struct
> >>> bpf_prog_info_linear *info_linear)
> >>>       }
> >>>  }
> >>>
> >>> +int bpf_program__set_attach_target(struct bpf_program *prog,
> >>> +                                int attach_prog_fd,
> >>> +                                const char *attach_func_name)
> >>> +{
> >>> +     int btf_id;
> >>> +
> >>> +     if (!prog || attach_prog_fd < 0 || !attach_func_name)
> >>> +             return -EINVAL;
> >>> +
> >>> +     if (attach_prog_fd)
> >>> +             btf_id =3D libbpf_find_prog_btf_id(attach_func_name,
> >>> +                                              attach_prog_fd);
> >>> +     else
> >>> +             btf_id =3D __find_vmlinux_btf_id(prog->obj->btf_vmlinux=
,
> >>> +                                            attach_func_name,
> >>> +
> >>> prog->expected_attach_type);
> >>> +
> >>> +     if (btf_id <=3D 0)
> >>> +             return btf_id;
> >>
> >> Looks like we can get 0 as return value on both error and success
> >> (below)?  Is that intentional?
> >
> > Neither libbpf_find_prog_btf_id nor __find_vmlinux_btf_id are going to
> > return 0 on failure. But I do agree that if (btf_id < 0) check would
> > be better here.
>
> Is see in theory btf__find_by_name_kind() could return 0:
>
>         if (kind =3D=3D BTF_KIND_UNKN || !strcmp(type_name, "void"))
>                 return 0;
>
> But for our case, this will not happen and is invalid, so what about
> just to make sure its future proof?:
>
>    if (btf_id <=3D 0)
>          return btf_id ? btf_id : -ENOENT;

I don't see how void can be the right attach type, so I'd keep it
simple: if (btf_id < 0) return btf_id.
If it so happens that 0 is returned, it will fail at attach time anyways.

>
>
> > With that minor nit:
> >
> > Acked-by: Andrii Nakryiko <andriin@fb.com>
> >
> >>
> >>> +
> >>> +     prog->attach_btf_id =3D btf_id;
> >>> +     prog->attach_prog_fd =3D attach_prog_fd;
> >>> +     return 0;
> >>> +}
> >>> +
> >>>  int parse_cpu_mask_str(const char *s, bool **mask, int *mask_sz)
> >>>  {
> >>>       int err =3D 0, n, len, start, end =3D -1;
> >>
> >> [...]
>
