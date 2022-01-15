Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7520A48F454
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 03:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiAOCK6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jan 2022 21:10:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiAOCK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jan 2022 21:10:58 -0500
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7EABC061574;
        Fri, 14 Jan 2022 18:10:57 -0800 (PST)
Received: by mail-io1-xd34.google.com with SMTP id f24so8637826ioc.0;
        Fri, 14 Jan 2022 18:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=j9b3nPt8M/XjkXGOjmyFfOm+8a2zXOyA/KqtALUW8XY=;
        b=BwNgrEL4tQi6lDzblBLSDPYI9jSvUQwmtFoXBDVnDn8gvNgxbir3YIfwVujomkKHVi
         P7A4FQcUd6tze4pMkE8Y9paQElKWA2aonkVWAUapcy1bfdMYRAGfNQmmMbiEIoE5CEhD
         37KJtyEM83BV5R3eAPImOs4t1rVQ5pgFfoBQvb5EJpz79exEckSbtoDXBqhqh8vDP9Pb
         /4lCgDfKvFrmb4+scVM1Yb8S5ktH9suq4Pic6dceTMcyjdsliF1SA2HrZn3QdiElNdGY
         kRpq0AoXDjhZY/f38OlryTTl3SGv5xHcTgfeQNMJU3KoSfBPrVUX7loeU5JphLJJFh8c
         fRaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=j9b3nPt8M/XjkXGOjmyFfOm+8a2zXOyA/KqtALUW8XY=;
        b=gk4x3jTmaXlatiTl/l+PFS9V/rekkmtxwy0dUD/i0KnnfsZCwIW9vPH5V6GKqeXmLz
         JzHLaDm65janjzVc6qQ2Dqx2m9A/9DhJZve1uM6/S7cRAT6wTT9TtGuNi4l8VXBZQ+BQ
         cqcAsPGZjXbfeA+8SsuFjMeZ9+VuxfjAUiHxBnhNUsuMYZMA/lIMPUgCdlQG3lmx+Btp
         8sVDtR5GZ95lw4b+fSq4s6t0PdITrVcnmJ8IhBl75oxlCPwA96ioEMBFdegB3YWgr39f
         IJJdT1xOCMNwLJd1/WbTYYHLrqARS8UFatusE4mv8zpZIWwF8uVbS8ld15kBx2TagAks
         q2VA==
X-Gm-Message-State: AOAM5305pqbETdjJT+3FqG74e1EeKg8GHwy4J5WKLXCRLN0z3mbdzccR
        8pnAvBgeMn0LQbQzSmtS5Q+HoFbtOmApKesSwZDC9KQVFH0Qlw==
X-Google-Smtp-Source: ABdhPJwxW1e7X+SvM1CmykPTaDGxjL0TUW+sn3fWgO217ueXioja37rGDZ7TmHmqMFQ2+VQ6XapZEwVRwsC2dvhQ9eE=
X-Received: by 2002:a02:ca03:: with SMTP id i3mr5110193jak.234.1642212657292;
 Fri, 14 Jan 2022 18:10:57 -0800 (PST)
MIME-Version: 1.0
References: <20220112142709.102423-1-mauricio@kinvolk.io> <20220112142709.102423-5-mauricio@kinvolk.io>
In-Reply-To: <20220112142709.102423-5-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 14 Jan 2022 18:10:46 -0800
Message-ID: <CAEf4BzZN39SM85zuOV+6gP1KK0fdvUGVxL3THpzRNWTOi7KCxw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 4/8] bpftool: Implement btf_save_raw()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>,
        Leonardo Di Donato <leonardo.didonato@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 12, 2022 at 6:27 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> Helper function to save a BTF object to a file.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> Signed-off-by: Leonardo Di Donato <leonardo.didonato@elastic.co>
> ---
>  tools/bpf/bpftool/gen.c | 30 ++++++++++++++++++++++++++++++
>  1 file changed, 30 insertions(+)
>

See suggestions, but either way:

Acked-by: Andrii Nakryiko <andrii@kernel.org>


> diff --git a/tools/bpf/bpftool/gen.c b/tools/bpf/bpftool/gen.c
> index cdeb1047d79d..5a74fb68dc84 100644
> --- a/tools/bpf/bpftool/gen.c
> +++ b/tools/bpf/bpftool/gen.c
> @@ -1096,6 +1096,36 @@ static int do_help(int argc, char **argv)
>         return 0;
>  }
>
> +static int btf_save_raw(const struct btf *btf, const char *path)
> +{
> +       const void *data;
> +       FILE *f =3D NULL;
> +       __u32 data_sz;
> +       int err =3D 0;
> +
> +       data =3D btf__raw_data(btf, &data_sz);
> +       if (!data) {
> +               err =3D -ENOMEM;
> +               goto out;
> +       }

can do just return -ENOMEM instead of goto

> +
> +       f =3D fopen(path, "wb");
> +       if (!f) {
> +               err =3D -errno;
> +               goto out;
> +       }
> +
> +       if (fwrite(data, 1, data_sz, f) !=3D data_sz) {
> +               err =3D -errno;
> +               goto out;
> +       }
> +
> +out:
> +       if (f)

with early return above, no need for if (f) check

> +               fclose(f);
> +       return err;
> +}
> +
>  /* Create BTF file for a set of BPF objects */
>  static int btfgen(const char *src_btf, const char *dst_btf, const char *=
objspaths[])
>  {
> --
> 2.25.1
>
