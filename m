Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F398115AECF
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 18:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728721AbgBLRfi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 12:35:38 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:38269 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727054AbgBLRfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 12:35:38 -0500
Received: by mail-qk1-f196.google.com with SMTP id z19so2848110qkj.5;
        Wed, 12 Feb 2020 09:35:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=CKkGpoO+ysjqkDcZA5L0YW2I59cXAqKlitpPLAEdWkU=;
        b=mZNifsagAIy6pFmC2egoUJWEt1kQs+fbhpbdvlb/AXaeI9yHRFIudYI+czQfwUVPl5
         ZuI8lCvF7PYaplNSuKj5ibHGf7YhtJO04lw9IekM5/ux2HuxvZmUb31y8bLQMm9IIG8B
         HBp3vA8lxNS0HR4ZRuVV7pZdyGHsOC+y/tBC3G+SnW6K+Uexxgbmi0My6G0WQ8U5+bkL
         fMpsoGe89Qv9qqhpISMNcrzb4/V248Sbdhi9Vf8tpBLsIJO443SWNkRPq5NApUjiUgPG
         6V2rskG8G8EOO6iryyjygJALrUiV2uuJNvhGX76SZrm0e4kbkD4XNESjBjbtc40JayuG
         gjOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=CKkGpoO+ysjqkDcZA5L0YW2I59cXAqKlitpPLAEdWkU=;
        b=Gwx5YRmhtIM2GfyCc8wNgr+zsdEzq1wBJOQEvJceU55lWHpO9QDpXMRu2zKzYgpAMt
         q5sSAn3Ae9EEb4tB1lSfRvRVrH+RORPFjE3spBXRM/Ql3dv+WN4mqE68GZyyA8BVmUN2
         ReIRVgG1BaIxVwl5kQP+QNfFztLp+7cv8krJ3V9MyfQ/pa9aVvY7oA4k3IFLGSnGojsm
         UawEHXcOw3kQcB0XpWhBkCsDgInQJSd+cmJ3J+T9Xob3UEBHqpjoVA9GGwb3ga6FKLyg
         7Ijsqhm0DcnbNzOWWFmEAekJLItbQfulSWZVvZOj1JJIN0SD5zHresqYdh2Un82VsasJ
         TiEw==
X-Gm-Message-State: APjAAAXwlw1V3oH/EFU0eOjGBw6T4cNrAKEZfvBBmHQkfQH7bIIbIuBc
        w4HJkubfp7wDD/x+qOGVL4Wumr7/5AKy9bv2p44=
X-Google-Smtp-Source: APXvYqyN5a7S619wq0BCygKKLWBa1bp5M3cGfXJBbquHGRvedD8Zb7R8kC6P4Z4sYIpgWwLykSbFTLfHoNy05tI2xKY=
X-Received: by 2002:a37:a685:: with SMTP id p127mr12471046qke.449.1581528937470;
 Wed, 12 Feb 2020 09:35:37 -0800 (PST)
MIME-Version: 1.0
References: <158151067149.71757.2222114135650741733.stgit@xdp-tutorial> <874kvwhs6u.fsf@toke.dk>
In-Reply-To: <874kvwhs6u.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 12 Feb 2020 09:35:26 -0800
Message-ID: <CAEf4BzYn3pVhqzj8PwRWxjWSJ16CS9d60zFtsS=OuA5ydPyp2Q@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Add support for dynamic program attach target
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Eelco Chaudron <echaudro@redhat.com>, bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 5:05 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Eelco Chaudron <echaudro@redhat.com> writes:
>
> > Currently when you want to attach a trace program to a bpf program
> > the section name needs to match the tracepoint/function semantics.
> >
> > However the addition of the bpf_program__set_attach_target() API
> > allows you to specify the tracepoint/function dynamically.
> >
> > The call flow would look something like this:
> >
> >   xdp_fd =3D bpf_prog_get_fd_by_id(id);
> >   trace_obj =3D bpf_object__open_file("func.o", NULL);
> >   prog =3D bpf_object__find_program_by_title(trace_obj,
> >                                            "fentry/myfunc");
> >   bpf_program__set_attach_target(prog, xdp_fd,
> >                                  "fentry/xdpfilt_blk_all");
>
> I think it would be better to have the attach type as a separate arg
> instead of encoding it in the function name. I.e., rather:
>
>    bpf_program__set_attach_target(prog, xdp_fd,
>                                   "xdpfilt_blk_all", BPF_TRACE_FENTRY);

I agree about not specifying section name prefix (e.g., fentry/). But
disagree that expected attach type (BPF_TRACE_FENTRY) should be part
of this API. We already have bpf_program__set_expected_attach_type()
API, no need to duplicate it here.

>
> -Toke
>
