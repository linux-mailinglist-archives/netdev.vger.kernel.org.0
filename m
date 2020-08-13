Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84CA243D9A
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 18:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgHMQlf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 12:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726131AbgHMQle (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 12:41:34 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C75AC061757;
        Thu, 13 Aug 2020 09:41:34 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id m200so3636740ybf.10;
        Thu, 13 Aug 2020 09:41:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O4j5LGUZoilwCdIR9TDlKvANydsNzZHA+kE29mYGsok=;
        b=BQMzHJPQJGhRB2WLWU84RirKE2KAHQj7eDgMGhPzMeNTaQB0LbuNAA/iIqEsF7+ADB
         5WclfLmreC+p/d1JeNeCmZI5IkK8FW5y2rIfmriER3P+DerBATfnPkRzNugIXbflzuRg
         MOnjJrhO942cBf+VaDSowBitY2CjrZ2i/CsIjCDYF3EWInlwQwPgeB8+ep8VjMH+7cc9
         ZZjZ0OgAbTntpT3ID5c4yOda6UHHg3INEqAlBT37ffXTHkTzaIphlFLwRTIYjnCxxfnC
         B+Tcc7YFt4TiV6GD92agz8OCR9Vv3xnoBIGFT8JBIji+mN9SJqlIKkYqdFRs/Ot//YEO
         2tdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O4j5LGUZoilwCdIR9TDlKvANydsNzZHA+kE29mYGsok=;
        b=O+4gyDPcQLGMATAvOTFz2cjurGGLWmoZ91Mu1X8j+yY+K7DoCehE5o9y+4AxNELS8X
         RRKz/+Y3vXI/n0nVJQv1rlWy3iv8xxIX43RJsGXJ0+/FC8VQ36IQJzuz0UvSwJ7IQbJ1
         aNyg8sCFeQ6Epxlzd4AnBFBtZ+EeIpWKLtpo1eX7kyFasRg1DgCp2x7VT8X28ujNEe4V
         i/Eq/9G/RnUOLRPLTjeAAQ4CzTeDLf77JIDqGLAoE2UNXtDTkf2sjU+/PUy8OAw9odjb
         OOmjWJ53l1o0AQYhYvZ5AaG0TEdouyd/g7YlcEZjbjaJQesPuymSF40HzcwLIhYv6Prj
         VJ7w==
X-Gm-Message-State: AOAM531/csB9wlzDbwfOCP/7n/kJymlxTHLD7jWGzwFUQmG6hl5arS0X
        yQdbwG1wh2kcRPPWzrXX2j+vi6SRparl15WJbHk=
X-Google-Smtp-Source: ABdhPJyRHxOnBNAnIeyl9GVjW9xrrD+l1Y7jicEiPbOvWXpD+cCwh+9xvIFxoHgsATGpTUmKa2tn0EJShWRiJyOhZO8=
X-Received: by 2002:a5b:44d:: with SMTP id s13mr8003267ybp.403.1597336893434;
 Thu, 13 Aug 2020 09:41:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200813142905.160381-1-toke@redhat.com>
In-Reply-To: <20200813142905.160381-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 13 Aug 2020 09:41:22 -0700
Message-ID: <CAEf4BzZ6yM_QWu0x4b51NAVzN6-EAoQN4ff4BNiof5CJ5ukhpg@mail.gmail.com>
Subject: Re: [PATCH bpf] libbpf: Prevent overriding errno when logging errors
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 13, 2020 at 7:29 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Turns out there were a few more instances where libbpf didn't save the
> errno before writing an error message, causing errno to be overridden by
> the printf() return and the error disappearing if logging is enabled.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/lib/bpf/libbpf.c | 12 +++++++-----
>  1 file changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 0a06124f7999..fd256440e233 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -3478,10 +3478,11 @@ bpf_object__probe_global_data(struct bpf_object *=
obj)
>
>         map =3D bpf_create_map_xattr(&map_attr);
>         if (map < 0) {
> -               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
> +               ret =3D -errno;
> +               cp =3D libbpf_strerror_r(-ret, errmsg, sizeof(errmsg));

fyi, libbpf_strerror_r() is smart enough to work with both negative
and positive error numbers (it basically takes abs(err)), so no need
to ensure it's positive here and below.

>                 pr_warn("Error in %s():%s(%d). Couldn't create simple arr=
ay map.\n",
> -                       __func__, cp, errno);
> -               return -errno;
> +                       __func__, cp, -ret);
> +               return ret;
>         }
>
>         insns[0].imm =3D map;
> @@ -6012,9 +6013,10 @@ int bpf_program__pin_instance(struct bpf_program *=
prog, const char *path,
>         }
>
>         if (bpf_obj_pin(prog->instances.fds[instance], path)) {
> -               cp =3D libbpf_strerror_r(errno, errmsg, sizeof(errmsg));
> +               err =3D -errno;
> +               cp =3D libbpf_strerror_r(-err, errmsg, sizeof(errmsg));
>                 pr_warn("failed to pin program: %s\n", cp);
> -               return -errno;
> +               return err;
>         }
>         pr_debug("pinned program '%s'\n", path);
>
> --
> 2.28.0
>
