Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7805188E86
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 21:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgCQUD7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 16:03:59 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:46787 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgCQUD7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Mar 2020 16:03:59 -0400
Received: by mail-qk1-f195.google.com with SMTP id f28so34783349qkk.13;
        Tue, 17 Mar 2020 13:03:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Zx3EtYonl5o+zpGVd/1slPMp/OAfnRTAC4fDaQ5M7/Y=;
        b=s7bwL2M5dAHqZLXki2O2ITsiVnCeobonhaGQZynD0+xkylDR2KfVnIObZxTr9tmn/Q
         wmfJoGasWwk+w9zHHxTffFxu+SNWek95CJ1rDVPYZjlBxMVl/dMNHdzIUuj7ZnfVFAGF
         IAxqqEztuwKhfEZjCXu9xzRQ52t3D1tcrv5HZdwDgN8zhQbnB3We30EHnfH/moPxvt73
         r0fYYaAsGkqnz20lYQlIrNysgAQP/wXEBSitnDjVk/fBy83jMKIymtBwSieSv9SN7gk6
         1eJvrhd5vRd4nozYPssud2tzmfTMQi9B3tV1RzNjUimf772WhiBt3blKCeF2L308WwhP
         95ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Zx3EtYonl5o+zpGVd/1slPMp/OAfnRTAC4fDaQ5M7/Y=;
        b=ZsV2kQ014d0j6+qHY4AwCvk0VrA3NqWbbefekO9Wtu4MK9B+VqnolcjCCar/D1T/n2
         bfzKwRqj+coY9VczYIb5rONjf+WYpXItlVBAwudZ12hxUaCv++zVASLCYEdXtepDwU7l
         8IFWRKizoTdD0EdxwGfWk/16a5akjJicnq5VWQzvIYUU6WbexIWznXRQtsg9XO3M88uh
         yrgLx16B9tTT4LhK6LQMswyLouYwgP0rsFNnd0puWOZ+8C3qhXAX1Yc4wZtusz0VRgU1
         uNs9IhaTM+JSXEbR8R8HVmKbhfjM93YLejLH/OWmrKIIaJ9oxyFiFq6C93HgsDiDEPyn
         fHvQ==
X-Gm-Message-State: ANhLgQ2/jDQuuaBAIlQSKSm3Qxv4MGh0+OcT6zV1UvjYKmASr6QxchKK
        SY8dul7jXP8mQHekxUYqFTXEhTlKN/Tw1KdA3fU=
X-Google-Smtp-Source: ADFU+vvtz+CF3Buk1Io9Jy3rGlbwEfEsI5sKW+kBE9ByZg2SfndUopLxpOP3GhEiInUPuccDySn2V2k7wiZYrRnUwtM=
X-Received: by 2002:a37:992:: with SMTP id 140mr685035qkj.36.1584475437852;
 Tue, 17 Mar 2020 13:03:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200316005559.2952646-1-kafai@fb.com> <20200316005605.2953117-1-kafai@fb.com>
In-Reply-To: <20200316005605.2953117-1-kafai@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 17 Mar 2020 13:03:46 -0700
Message-ID: <CAEf4BzYFn85O=cZ=5VPeNiJMogrpyKdX47LdNgPyaK6WayRkVA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/4] bpftool: Print the enum's name instead of value
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Mar 15, 2020 at 5:56 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> This patch prints the enum's name if there is one found in
> the array of btf_enum.
>
> The commit 9eea98497951 ("bpf: fix BTF verification of enums")
> has details about an enum could have any power-of-2 size (up to 8 bytes).
> This patch also takes this chance to accommodate these non 4 byte
> enums.
>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  tools/bpf/bpftool/btf_dumper.c | 35 +++++++++++++++++++++++++++++++---
>  1 file changed, 32 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/btf_dumper.c b/tools/bpf/bpftool/btf_dumper.c
> index 01cc52b834fa..57bd6c0fafc9 100644
> --- a/tools/bpf/bpftool/btf_dumper.c
> +++ b/tools/bpf/bpftool/btf_dumper.c
> @@ -43,9 +43,38 @@ static int btf_dumper_modifier(const struct btf_dumper *d, __u32 type_id,
>         return btf_dumper_do_type(d, actual_type_id, bit_offset, data);
>  }
>
> -static void btf_dumper_enum(const void *data, json_writer_t *jw)
> +static void btf_dumper_enum(const struct btf_dumper *d,
> +                           const struct btf_type *t,
> +                           const void *data)
>  {
> -       jsonw_printf(jw, "%d", *(int *)data);
> +       const struct btf_enum *enums = btf_enum(t);
> +       __s64 value;
> +       __u16 i;
> +
> +       switch (t->size) {
> +       case 8:
> +               value = *(__s64 *)data;
> +               break;
> +       case 4:
> +               value = *(__s32 *)data;
> +               break;
> +       case 2:
> +               value = *(__s16 *)data;
> +               break;
> +       default:
> +               value = *(__s8 *)data;
> +       }

I'm scared of catch-all defaults like this. Let's do `case 1: `
explicitly and error out on anything else here?

> +
> +       for (i = 0; i < btf_vlen(t); i++) {
> +               if (value == enums[i].val) {
> +                       jsonw_string(d->jw,
> +                                    btf__name_by_offset(d->btf,
> +                                                        enums[i].name_off));
> +                       return;
> +               }
> +       }
> +
> +       jsonw_int(d->jw, value);
>  }
>
>  static int btf_dumper_array(const struct btf_dumper *d, __u32 type_id,
> @@ -366,7 +395,7 @@ static int btf_dumper_do_type(const struct btf_dumper *d, __u32 type_id,
>         case BTF_KIND_ARRAY:
>                 return btf_dumper_array(d, type_id, data);
>         case BTF_KIND_ENUM:
> -               btf_dumper_enum(data, d->jw);
> +               btf_dumper_enum(d, t, data);
>                 return 0;
>         case BTF_KIND_PTR:
>                 btf_dumper_ptr(data, d->jw, d->is_plain_text);
> --
> 2.17.1
>
