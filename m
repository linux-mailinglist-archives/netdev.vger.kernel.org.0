Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48A385A52E
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 21:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbfF1TfJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 15:35:09 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:37109 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726695AbfF1TfJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 15:35:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id y57so7643072qtk.4;
        Fri, 28 Jun 2019 12:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=r+fzXlSqCxAe0iNPLsVIFDsymcFZgv2YteU8of3ycKw=;
        b=pQ2MAI5PAnJk1dZs2IOwpjBBqllZFkgzu+susdwrPe1wqi+IWR9hEtRfpKoRY7I1hK
         jKdmVb4I8XvPWuk4tNiwR24lb86Fkx+S1S1CQjLu23PyQ3stsFmvHtYX2AKK4dXcDrSc
         rVQq8nwDifJk80godfKSdTQlGMM45rdJs5Cp1p7w8JbuTMWuNg2gWjpSDyj193be60kM
         sa2L2QAW4g7jiEg9yTmPB/Iy2Oh+K3AV3ro9DooW82Qc2W09lqAywmpmi03DvTHyoImA
         YAD9gyY+qdnqJ3OMkOFus23tMWUwpb4kgkA0c146GPqw+2DmY8xnEEThm5dKok4IxDEW
         HFzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=r+fzXlSqCxAe0iNPLsVIFDsymcFZgv2YteU8of3ycKw=;
        b=nb9c45N0twSd7ZTHPC4oCMP0piXA1IU0SeWvO/SqAWTebA7mbezhqV9J8oPzi2yjRy
         zrL0N1RLKsF9ukD/7DnguqhL9pSOkC3cbt8bVptBfoNzRz/T4/jqT83e1JLfyXAVFlBm
         A8ZZBBpm8UGgXgCPNqAiOF2uZ0UBSTEnVfzYQALUB9MIHdFQRpMIpMd3F4pPto0554F2
         Y/8QK41lp+ggFxKVqF0W4VkDqfA0rMksBEXct9GtOdLTn+kdPxhNMzLqbwOcZYQtXS5I
         zuuBEbkNFOHs7Rl8ds5TFNmnGYBaEzJgw6yN7z2QsFgNkgwSG/R2AgCRhxbRUFBtqUrg
         tZuw==
X-Gm-Message-State: APjAAAWKaCmq6Wb6G4iiL9Run7zhSZq4MtsagJUXWJu7c+pHsAroZctJ
        Dyu+xkGP6lFbYK7jUEpxWa+Bkvb4ymelkvvtpeA=
X-Google-Smtp-Source: APXvYqxq7yPW1gmz1r1tmA31v34JbZdnH3eRFnMJdJ2M+w+swdWBBeKYFLDJQU0imMe8ORE6PeSgzKVDls/DncO1KcI=
X-Received: by 2002:ac8:1af4:: with SMTP id h49mr9463948qtk.183.1561750508091;
 Fri, 28 Jun 2019 12:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190628055303.1249758-1-andriin@fb.com> <20190628055303.1249758-2-andriin@fb.com>
In-Reply-To: <20190628055303.1249758-2-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 12:34:57 -0700
Message-ID: <CAPhsuW7JUpoT-MFz7py12Vyj0Qm1zXDkN8Wq+KGM44tomrPipA@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 1/9] libbpf: make libbpf_strerror_r agnostic
 to sign of error
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Stanislav Fomichev <sdf@fomichev.me>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 10:53 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> It's often inconvenient to switch sign of error when passing it into
> libbpf_strerror_r. It's better for it to handle that automatically.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> Reviewed-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/lib/bpf/str_error.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/str_error.c b/tools/lib/bpf/str_error.c
> index 00e48ac5b806..b8064eedc177 100644
> --- a/tools/lib/bpf/str_error.c
> +++ b/tools/lib/bpf/str_error.c
> @@ -11,7 +11,7 @@
>   */
>  char *libbpf_strerror_r(int err, char *dst, int len)
>  {
> -       int ret = strerror_r(err, dst, len);
> +       int ret = strerror_r(err < 0 ? -err : err, dst, len);
>         if (ret)
>                 snprintf(dst, len, "ERROR: strerror_r(%d)=%d", err, ret);
>         return dst;
> --
> 2.17.1
>
