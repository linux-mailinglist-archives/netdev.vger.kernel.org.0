Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D04BA15995C
	for <lists+netdev@lfdr.de>; Tue, 11 Feb 2020 20:03:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729879AbgBKTDf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Feb 2020 14:03:35 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:39365 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729542AbgBKTDe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Feb 2020 14:03:34 -0500
Received: by mail-qt1-f193.google.com with SMTP id c5so8802812qtj.6;
        Tue, 11 Feb 2020 11:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9MvmwcqVniLpsEakuGLvwQkyfWaIncNOFXlu99UDQZU=;
        b=ImCNXH1/OQiJ6Yp1fH0YHRGub6GjWrqLdgpI0ROAGsNyUrUzVj3oNWWnzLs83mcJQO
         E0Lh6zpK0ztv3p0A7RN1OZw9bWmzWJ6yC2l32E0tRxS02n2ktsEBcW2RWumJbycQXL6H
         lh26Gm1ZT75wXDmrdGtStKtlCS2TctZgZyxdgbV9RejFslpLN2ZOUx9Eme4Eor2TV/8c
         7H0HSaUo9U5qMldBMYN0HKz1/y9dkWT6w4pjR7dsy7xdNDeraV3FjTVwSa5lrN1EqOy3
         0vMhwLPZrwVleXaQn1LjDPwydDl/CCCv/r0XPVovhlk73IFdLEfUgz5V1wXK+EPP3ocA
         eYoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9MvmwcqVniLpsEakuGLvwQkyfWaIncNOFXlu99UDQZU=;
        b=XB/luWO3FgX1EvdzsKghmRIy5jY943xpGP+Z94fDDGIl0ejzZCq1R0HEIjM5/xAGtI
         0btSHwluSkU7aDCftRX8J00Q5xX83OdCc7tHxdej3/hEu9haFJ3WGkB0grxLykrof5bd
         3wJVajwt6LtGA16rnv1M3E880iVNbgyt3RF9soNV1rNjntzXZ8oolJ8XcZ1YLS7hBRDc
         0VleWG1pzWna4uUP9II6sRkRzPROfMm7Brlyicii5yozIS7bCFz7IJl/veZHNVOoCjnF
         K/k1a0QxjYQf5LtzJs438wzYlPoAq7Whgsro3m3np9DL1FQ+zvrmBh3ZTVDJAlg4mtii
         qBpw==
X-Gm-Message-State: APjAAAVESBdY/FpQHAV4x/Dwd19/enmudNjMt6K+HIfT5JE3ZyHdTEtO
        eOwq5T2/Z20ZJSiSwIopR8BZk4OlcqNFDkU9XaU=
X-Google-Smtp-Source: APXvYqzs8eJxtNAq+53OhfBGwzTzgKyeUQKwsKhQhqaNFVOVn0+MN0uh87KUqioI0iWNccCRpg1FO5dtSG9kllphLJA=
X-Received: by 2002:ac8:1385:: with SMTP id h5mr3718358qtj.59.1581447813900;
 Tue, 11 Feb 2020 11:03:33 -0800 (PST)
MIME-Version: 1.0
References: <20200208154209.1797988-1-jolsa@kernel.org> <20200208154209.1797988-14-jolsa@kernel.org>
In-Reply-To: <20200208154209.1797988-14-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 11 Feb 2020 11:03:23 -0800
Message-ID: <CAEf4BzZM-pc4Yva8kKsuD6QjOY8bVCGUzDJCdoeZzVOTc2zV2A@mail.gmail.com>
Subject: Re: [PATCH 13/14] bpf: Add dispatchers to kallsyms
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Yonghong Song <yhs@fb.com>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 8, 2020 at 7:43 AM Jiri Olsa <jolsa@kernel.org> wrote:
>
> Adding dispatchers to kallsyms. It's displayed as
>   bpf_dispatcher_<NAME>
>
> where NAME is the name of dispatcher.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  include/linux/bpf.h     | 19 ++++++++++++-------
>  kernel/bpf/dispatcher.c |  6 ++++++
>  2 files changed, 18 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index b91bac10d3ea..837cdc093d2c 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -520,6 +520,7 @@ struct bpf_dispatcher {
>         int num_progs;
>         void *image;
>         u32 image_off;
> +       struct bpf_ksym ksym;
>  };
>
>  static __always_inline unsigned int bpf_dispatcher_nop_func(
> @@ -535,13 +536,17 @@ struct bpf_trampoline *bpf_trampoline_lookup(u64 ke=
y);
>  int bpf_trampoline_link_prog(struct bpf_prog *prog);
>  int bpf_trampoline_unlink_prog(struct bpf_prog *prog);
>  void bpf_trampoline_put(struct bpf_trampoline *tr);
> -#define BPF_DISPATCHER_INIT(name) {                    \
> -       .mutex =3D __MUTEX_INITIALIZER(name.mutex),       \
> -       .func =3D &name##_func,                           \
> -       .progs =3D {},                                    \
> -       .num_progs =3D 0,                                 \
> -       .image =3D NULL,                                  \
> -       .image_off =3D 0                                  \
> +#define BPF_DISPATCHER_INIT(_name) {                           \
> +       .mutex =3D __MUTEX_INITIALIZER(_name.mutex),              \
> +       .func =3D &_name##_func,                                  \
> +       .progs =3D {},                                            \
> +       .num_progs =3D 0,                                         \
> +       .image =3D NULL,                                          \
> +       .image_off =3D 0,                                         \
> +       .ksym =3D {                                               \
> +               .name =3D #_name,                                 \
> +               .lnode =3D LIST_HEAD_INIT(_name.ksym.lnode),      \
> +       },                                                      \
>  }
>
>  #define DEFINE_BPF_DISPATCHER(name)                                    \
> diff --git a/kernel/bpf/dispatcher.c b/kernel/bpf/dispatcher.c
> index b3e5b214fed8..8771d2cc5840 100644
> --- a/kernel/bpf/dispatcher.c
> +++ b/kernel/bpf/dispatcher.c
> @@ -152,6 +152,12 @@ void bpf_dispatcher_change_prog(struct bpf_dispatche=
r *d, struct bpf_prog *from,
>         if (!changed)
>                 goto out;
>
> +       if (!prev_num_progs)
> +               bpf_image_ksym_add(d->image, &d->ksym);
> +
> +       if (!d->num_progs)
> +               bpf_ksym_del(&d->ksym);
> +
>         bpf_dispatcher_update(d, prev_num_progs);

On slightly unrelated note: seems like bpf_dispatcher_update won't
propagate any lower-level errors back, which seems pretty bad as a
bunch of stuff can go wrong.

Bj=C3=B6rn, was it a conscious decision or this just slipped through the cr=
acks?

Jiri, reason I started looking at this was twofold:
1. you add/remove symbol before dispatcher is updated, which is
different order from BPF trampoline updates. I think updating symbols
after successful update makes more sense, no?
2. I was wondering if bpf_dispatcher_update() could return 0/1 (and <0
on error, of course), depending on whether dispatcher is present or
not. Though I'm not hard set on this.

>  out:
>         mutex_unlock(&d->mutex);
> --
> 2.24.1
>
