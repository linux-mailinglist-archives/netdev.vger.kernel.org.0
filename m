Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E03643E887
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 20:36:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbhJ1SjI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 14:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230293AbhJ1SjH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Oct 2021 14:39:07 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A2FC061570;
        Thu, 28 Oct 2021 11:36:40 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id y3so6575572ybf.2;
        Thu, 28 Oct 2021 11:36:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lri9AX1VH1jItY9Oibi5NyPCDvFeCYHvU+3LAfa1abI=;
        b=f/9nNiZI2daTtSKn3AWlb2zHbAV/WmTqZnVPjjX/7k+x7SIe2defZYpQq6Prl8HYDK
         P+yrfKpRxq8D91zrDqT8EMpPILUWC2Dfa/ycTCYMMjzf5oVA917Hx6U8C7GY/YAA7Bhi
         r6YhqJwa5XgzJqrBEoji3Ik+Aex9Hmb/8DGfdsIL6fV87pEZhx6zP06QQliEL5tZNPEB
         +OKu1yv8GDtcv5yZVMESkvHCUxy4b/OGzoFP9deK5BrvZg0/LvmIxTw7UqNIOd8bfM5V
         ZKWb7AH0FG7ywRWSJQMlcyVxk6yzKQBSFRP5KwPZEnH/fE4CSn8kA+KdCw7wtAWgZ3O0
         R0IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lri9AX1VH1jItY9Oibi5NyPCDvFeCYHvU+3LAfa1abI=;
        b=N3mBrMqkQ6xD1yFGoupoEl3STM7jGgcAq7MqFIMOwQldV3msVbGusX3Wsr/6LulAXs
         jY0CT3q4u5f81iARQSu/su3scudZ5f9RH8x8fM/ur2lkMz49Gr/3TeCIfdv2veVVqzT4
         HxLDG98QEW5kCvV22JBqbifpOSKWz07eM1gw7xFE5jf4OWBJ3M0aUV4tSs1UHkCnOzDo
         nhmC0w/VhsSJ66prG99G1mN7LaQ+6HRFwOjs9rRemrdlGga5mvLY/IZmGYRSQVnthFY6
         QMOqkQDkVcM+LtJxjfZ2dEGwvfPGGyUhYkX4EH0gyFag1lDJPa5Crp3dqf7KIlZmhGtf
         Ho4g==
X-Gm-Message-State: AOAM532UpxBBSBWOIoy8vRf3DltMoZd3RDvtnALPR5EKde6/hP0QMNfx
        Fo2WjVrah9vhVZPLi21aPVCyVZ2jcwoNxn15g1o=
X-Google-Smtp-Source: ABdhPJyYf4XFAuiBXswba+b1b//02i+KVA71x8FErqaLRg2tx7oSGYuH+AMFrlOSb4fTRZDGSkq1eCRmvSqg67kwtfA=
X-Received: by 2002:a25:cc4c:: with SMTP id l73mr3855884ybf.114.1635446199454;
 Thu, 28 Oct 2021 11:36:39 -0700 (PDT)
MIME-Version: 1.0
References: <20211027203727.208847-1-mauricio@kinvolk.io> <20211027203727.208847-2-mauricio@kinvolk.io>
In-Reply-To: <20211027203727.208847-2-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 28 Oct 2021 11:36:28 -0700
Message-ID: <CAEf4BzZ2xxSSaLuvV=uLa0trom8_RPx8XR=KxeP5WF+2z3DMBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] libbpf: Implement btf__save_to_file()
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Rafael David Tinoco <rafaeldtinoco@gmail.com>,
        Rafael David Tinoco <rafael.tinoco@aquasec.com>,
        Lorenzo Fontana <lorenzo.fontana@elastic.co>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 27, 2021 at 1:37 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io>=
 wrote:
>
> Implement helper function to save the contents of a BTF object to a
> file.
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> Signed-off-by: Rafael David Tinoco <rafael.tinoco@aquasec.com>
> Signed-off-by: Lorenzo Fontana <lorenzo.fontana@elastic.co>
> ---
>  tools/lib/bpf/btf.c      | 22 ++++++++++++++++++++++
>  tools/lib/bpf/btf.h      |  2 ++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 25 insertions(+)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 0c628c33e23b..087035574dba 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -4773,3 +4773,25 @@ int btf_ext_visit_str_offs(struct btf_ext *btf_ext=
, str_off_visit_fn visit, void
>
>         return 0;
>  }
> +
> +int btf__save_to_file(struct btf *btf, const char *path)

given we have its loading counterpart as btf__parse_raw(), let's call
this one btf__save_raw()?

> +{
> +       const void *data;
> +       __u32 data_sz;
> +       FILE *file;
> +
> +       data =3D btf_get_raw_data(btf, &data_sz, btf->swapped_endian);

use btf__raw_data() instead? no need to think about btf->swapped_endian her=
e

> +       if (!data)
> +               return -ENOMEM;

please use libbpf_err() helper for returning errors, see other use cases

> +
> +       file =3D fopen(path, "wb");
> +       if (!file)
> +               return -errno;
> +
> +       if (fwrite(data, 1, data_sz, file) !=3D data_sz) {
> +               fclose(file);
> +               return -EIO;

why not propagating original errno? make sure you save it before
fclose(), though


> +       }
> +
> +       return fclose(file);

hm... I'd just do fclose(file) separately and return 0 (because
success). If file closing fails, there isn't anything that can be done
(but it also shouldn't fail in any normal situation).

> +}
> diff --git a/tools/lib/bpf/btf.h b/tools/lib/bpf/btf.h
> index bc005ba3ceec..300ad498c615 100644
> --- a/tools/lib/bpf/btf.h
> +++ b/tools/lib/bpf/btf.h
> @@ -114,6 +114,8 @@ LIBBPF_API struct btf *btf__parse_elf_split(const cha=
r *path, struct btf *base_b
>  LIBBPF_API struct btf *btf__parse_raw(const char *path);
>  LIBBPF_API struct btf *btf__parse_raw_split(const char *path, struct btf=
 *base_btf);
>
> +LIBBPF_API int btf__save_to_file(struct btf *btf, const char *path);

const struct btf? btf__raw_data() (even though it internally modifies
btf) accepts `const struct btf*`, because this is conceptually
read-only operation

> +
>  LIBBPF_API struct btf *btf__load_vmlinux_btf(void);
>  LIBBPF_API struct btf *btf__load_module_btf(const char *module_name, str=
uct btf *vmlinux_btf);
>  LIBBPF_API struct btf *libbpf_find_kernel_btf(void);
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 15239c05659c..0e9bed7c9b9e 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -399,4 +399,5 @@ LIBBPF_0.6.0 {
>                 btf__add_decl_tag;
>                 btf__raw_data;
>                 btf__type_cnt;
> +               btf__save_to_file;
>  } LIBBPF_0.5.0;
> --
> 2.25.1
>
