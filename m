Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4942FE374
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 08:08:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726456AbhAUHDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 02:03:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727135AbhAUHC1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 02:02:27 -0500
Received: from mail-yb1-xb30.google.com (mail-yb1-xb30.google.com [IPv6:2607:f8b0:4864:20::b30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20356C0613C1;
        Wed, 20 Jan 2021 23:01:47 -0800 (PST)
Received: by mail-yb1-xb30.google.com with SMTP id i141so1129234yba.0;
        Wed, 20 Jan 2021 23:01:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Q4Mx5AhqDtoCmA+H1AN8MmUPrDLatjJc96dmb4/mqdU=;
        b=YqtszlM8OrX8lq4+B4r2zEPr+sdzPb8JO2JCf1DdzlmcdPO76slbYAHH5b9NHdJawj
         fjXyRvfETJ78Ne6F/iX5mtpXrvoMBuPt4Iqywvjza+MbDFGzVAozGNRhIKEm1MryfxgZ
         Wyom8WBYQOya2QElN39nyGxyQqdvsX1cA7XB1+3S3PldvYY/XlAVG0naGmCky2RU1jTG
         ecWKHaGwfZGCea9yfHkf02kxYLr8utpwwJ6O6/txkmfuKnmBu1v1umY46k5tmR9VPp61
         y0iZ/cPb2pV8unb2ffMl/B5yKLs4revbtEyS6y8fO6H1Pm/wGMttwrlyXOiv7cwmYjz3
         ZKrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Q4Mx5AhqDtoCmA+H1AN8MmUPrDLatjJc96dmb4/mqdU=;
        b=DHGgKCV73AscCvCtwQXlR4NsLrMD+i0+R4yohXOd+4UvCgIStJz+au22CTJ7/38EdB
         6W7f4F9Js5WhAnEUeSBJD6z/EPyyLt1YMOQEo7I+OOgFBbJiiG1dkha7jJUuaRA4UdE6
         pShcNBG3tqnCQ1ejWyZspwDzKrWjXimghaFH7SnlB0G3TmA9L+l7TrKhZOfD4YMxATjS
         WZ13VCz+oMxhHeYz/qlR9JP2qvge6Zm9pz2d2lE7uN3DRYm02+7OQcdV+//DFPaW3MjE
         Ac0uwNw/sWv1LXfuBU1vl5kdhMn0FuzYidehpoT1de1BL66H/nJHeFYHA33MB39eJDef
         XeTA==
X-Gm-Message-State: AOAM532p7+ma4Z0VZxC7rEILeWbKdTIbmk+q0a+w2nA1yieUSlB9NK7z
        V/r9dJni1UZlk44Vve7M9GpHITwa2P3EaknJGSg=
X-Google-Smtp-Source: ABdhPJwEe9iKqTMPnxebf9ou14kmF7GajEuAXPiW/CJvlrSlSK1JYQH43V2gg18GOTEzOd9zMBKVoiE6EkUM1T0rnJM=
X-Received: by 2002:a25:d6d0:: with SMTP id n199mr18534077ybg.27.1611212506452;
 Wed, 20 Jan 2021 23:01:46 -0800 (PST)
MIME-Version: 1.0
References: <1610921764-7526-1-git-send-email-alan.maguire@oracle.com> <1610921764-7526-5-git-send-email-alan.maguire@oracle.com>
In-Reply-To: <1610921764-7526-5-git-send-email-alan.maguire@oracle.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Jan 2021 23:01:35 -0800
Message-ID: <CAEf4BzZdO+tJ+L4uJysrPa=PzM2nEbTT-Xnu1MGQUdhbwzpVXw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/4] selftests/bpf: add dump type data tests
 to btf dump tests
To:     Alan Maguire <alan.maguire@oracle.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, Martin Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, morbo@google.com,
        Shuah Khan <shuah@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 17, 2021 at 2:21 PM Alan Maguire <alan.maguire@oracle.com> wrote:
>
> Test various type data dumping operations by comparing expected
> format with the dumped string; an snprintf-style printf function
> is used to record the string dumped.
>
> Signed-off-by: Alan Maguire <alan.maguire@oracle.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf_dump.c | 233 ++++++++++++++++++++++
>  1 file changed, 233 insertions(+)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf_dump.c b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> index c60091e..262561f4 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf_dump.c
> @@ -232,6 +232,237 @@ void test_btf_dump_incremental(void)
>         btf__free(btf);
>  }
>
> +#define STRSIZE                                2048
> +#define        EXPECTED_STRSIZE                256
> +
> +void btf_dump_snprintf(void *ctx, const char *fmt, va_list args)
> +{
> +       char *s = ctx, new[STRSIZE];
> +
> +       vsnprintf(new, STRSIZE, fmt, args);
> +       strncat(s, new, STRSIZE);
> +       vfprintf(ctx, fmt, args);
> +}
> +
> +/* skip "enum "/"struct " prefixes */
> +#define SKIP_PREFIX(_typestr, _prefix)                                 \
> +       do {                                                            \
> +               if (strstr(_typestr, _prefix) == _typestr)              \

why not strncmp?

> +                       _typestr += strlen(_prefix) + 1;                \
> +       } while (0)
> +
> +int btf_dump_data(struct btf *btf, struct btf_dump *d,
> +                 char *ptrtype, __u64 flags, void *ptr,
> +                 char *str, char *expectedval)
> +{
> +       struct btf_dump_emit_type_data_opts opts = { 0 };
> +       int ret = 0, cmp;
> +       __s32 type_id;
> +
> +       opts.sz = sizeof(opts);
> +       opts.compact = true;

Please use DECLARE_LIBBPF_OPTS(), check other examples in selftests

> +       if (flags & BTF_F_NONAME)
> +               opts.noname = true;
> +       if (flags & BTF_F_ZERO)
> +               opts.zero = true;
> +       SKIP_PREFIX(ptrtype, "enum");
> +       SKIP_PREFIX(ptrtype, "struct");
> +       SKIP_PREFIX(ptrtype, "union");
> +       type_id = btf__find_by_name(btf, ptrtype);
> +       if (CHECK(type_id <= 0, "find type id",
> +                 "no '%s' in BTF: %d\n", ptrtype, type_id)) {
> +               ret = -ENOENT;
> +               goto err;
> +       }
> +       str[0] = '\0';
> +       ret = btf_dump__emit_type_data(d, type_id, &opts, ptr);
> +       if (CHECK(ret < 0, "btf_dump__emit_type_data",
> +                 "failed: %d\n", ret))
> +               goto err;
> +
> +       cmp = strncmp(str, expectedval, EXPECTED_STRSIZE);
> +       if (CHECK(cmp, "ensure expected/actual match",
> +                 "'%s' does not match expected '%s': %d\n",
> +                 str, expectedval, cmp))
> +               ret = -EFAULT;
> +
> +err:
> +       if (ret)
> +               btf_dump__free(d);
> +       return ret;
> +}
> +
> +#define TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _flags, _expected, ...)        \
> +       do {                                                            \
> +               char _expectedval[EXPECTED_STRSIZE] = _expected;        \
> +               char __ptrtype[64] = #_type;                            \
> +               char *_ptrtype = (char *)__ptrtype;                     \
> +               static _type _ptrdata = __VA_ARGS__;                    \
> +               void *_ptr = &_ptrdata;                                 \
> +                                                                       \
> +               if (btf_dump_data(_b, _d, _ptrtype, _flags, _ptr,       \
> +                                 _str, _expectedval))                  \
> +                       return;                                         \
> +       } while (0)
> +
> +/* Use where expected data string matches its stringified declaration */
> +#define TEST_BTF_DUMP_DATA_C(_b, _d, _str, _type, _opts, ...)          \
> +       TEST_BTF_DUMP_DATA(_b, _d, _str, _type, _opts,                  \
> +                          "(" #_type ")" #__VA_ARGS__, __VA_ARGS__)
> +
> +void test_btf_dump_data(void)
> +{
> +       struct btf *btf = libbpf_find_kernel_btf();
> +       char str[STRSIZE];
> +       struct btf_dump_opts opts = { .ctx = str };
> +       struct btf_dump *d;
> +
> +       if (CHECK(!btf, "get kernel BTF", "no kernel BTF found"))
> +               return;
> +

use libbpf_get_error(), btf won't be NULL on error

> +       d = btf_dump__new(btf, NULL, &opts, btf_dump_snprintf);
> +
> +       if (CHECK(!d, "new dump", "could not create BTF dump"))

same, d won't be NULL on error

> +               return;
> +
> +       /* Verify type display for various types. */
> +

[...]
