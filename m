Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 346E329E2C7
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 03:38:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391233AbgJ2CiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Oct 2020 22:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729588AbgJ2Cgi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Oct 2020 22:36:38 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21470C0613CF;
        Wed, 28 Oct 2020 19:36:38 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id o70so955518ybc.1;
        Wed, 28 Oct 2020 19:36:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TXhexRQYTJZaX12a+CEFo2ey4jNoNUVcsefrRM8fqb0=;
        b=morPS1rKmVmwcJZK82tUO/cgv+bWnRoUD5LCKu12VeiyBhwMyYiT/k2BdwrrcmjGhz
         +U/8lLskiF+AixIQCvnaIJwagnQfnsYSksvdg+sIBAqZibtRcx5sG3f8+qS5vURHY51j
         aQqoTCAtfVLBjuT4TFVf7uXd2TSEzMkNFCXFqaOza7rUkpK0eAJhIDCLLQE6+MjhOf7V
         qI4a/tjFFMZqcXlisvTW4ezQ2bPW0GHFDWuubqcYHZjG/NWcBrT1ysyFxjdo2SxVNA4J
         xvB+LG+6ZVnQztxOkr7CpWdPhI6eamK6eBMiFrDICMyHAGH+V4al5u3LjmSJ8Xopoa3R
         h0/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TXhexRQYTJZaX12a+CEFo2ey4jNoNUVcsefrRM8fqb0=;
        b=Gks9vYFqW9J4soza1oF2BTmk1fv36SCDLNDKZdVZDRXe3MaJa2Alzw3LAa92J1AojC
         fOrTe4z92m3/M8y1lWuwrvWn1TNJlupf20wVa0/j3hnC88TtjTLNzOf+OqE8u8I4vUIy
         jeh74DcJeUfDB4mx0EOECYmwqHkOsUxPRBAUpdsMWrTvexwEtafqVZUjUBFoLACBAoez
         ZJB108GHeuzfmRXm1WSid4nBqRrDx9V/s6c+G3NOviyxQ6AC376sewqvZO6ifxrHBZBl
         RX/wnXtVI0MPRUotpiAYcOIhhJNHEEPjV+65mdFmKuhDOtMV3dIRmqaB+fVPq+GzA0PY
         SDnA==
X-Gm-Message-State: AOAM5333VdCOPLAtylg8exLxV+zUSVweBvYacvmaw7US0hpo8vOZKiee
        3fypZebWN2Yr5KBYUiZq3cYphc72dTIbSUmk8hM=
X-Google-Smtp-Source: ABdhPJwtHZSw9Q6Sx8ODeo4QZeyM/3Jcz311so7MhMZni52xhelWxjqGEyNMkL1bEjcuiEGd92sshWoquuR8cYhkvvw=
X-Received: by 2002:a25:bdc7:: with SMTP id g7mr3207159ybk.260.1603938997408;
 Wed, 28 Oct 2020 19:36:37 -0700 (PDT)
MIME-Version: 1.0
References: <20201028200952.7869-1-dev@der-flo.net>
In-Reply-To: <20201028200952.7869-1-dev@der-flo.net>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 28 Oct 2020 19:36:26 -0700
Message-ID: <CAEf4BzZbtdgK-6y1cX6U2_sV9T6QHO=fAj2j0L_CtuqW0DZ1Rw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4] bpf: Lift hashtab key_size limit
To:     Florian Lehner <dev@der-flo.net>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 3:21 PM Florian Lehner <dev@der-flo.net> wrote:
>
> Currently key_size of hashtab is limited to MAX_BPF_STACK.
> As the key of hashtab can also be a value from a per cpu map it can be
> larger than MAX_BPF_STACK.
>
> The use-case for this patch originates to implement allow/disallow
> lists for files and file paths. The maximum length of file paths is
> defined by PATH_MAX with 4096 chars including nul.
> This limit exceeds MAX_BPF_STACK.
>
> Changelog:
>
> v4:
>  - Utilize BPF skeleton in tests
>  - Rebase
>
> v3:
>  - Rebase
>
> v2:
>  - Add a test for bpf side
>
> Signed-off-by: Florian Lehner <dev@der-flo.net>
> Acked-by: John Fastabend <john.fastabend@gmail.com>
> ---
>  kernel/bpf/hashtab.c                          | 16 ++-----
>  .../selftests/bpf/prog_tests/hash_large_key.c | 43 +++++++++++++++++
>  .../selftests/bpf/progs/test_hash_large_key.c | 46 +++++++++++++++++++
>  tools/testing/selftests/bpf/test_maps.c       |  3 +-
>  4 files changed, 96 insertions(+), 12 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/prog_tests/hash_large_key.c
>  create mode 100644 tools/testing/selftests/bpf/progs/test_hash_large_key.c
>
> diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
> index 1815e97d4c9c..fff7cd05b9e3 100644
> --- a/kernel/bpf/hashtab.c
> +++ b/kernel/bpf/hashtab.c
> @@ -390,17 +390,11 @@ static int htab_map_alloc_check(union bpf_attr *attr)
>             attr->value_size == 0)
>                 return -EINVAL;
>
> -       if (attr->key_size > MAX_BPF_STACK)
> -               /* eBPF programs initialize keys on stack, so they cannot be
> -                * larger than max stack size
> -                */
> -               return -E2BIG;
> -
> -       if (attr->value_size >= KMALLOC_MAX_SIZE -
> -           MAX_BPF_STACK - sizeof(struct htab_elem))
> -               /* if value_size is bigger, the user space won't be able to
> -                * access the elements via bpf syscall. This check also makes
> -                * sure that the elem_size doesn't overflow and it's
> +       if ((u64)(attr->key_size + attr->value_size) >= KMALLOC_MAX_SIZE -

this will add both as u32, then will cast overflown result to u64.
Instead just do:

if ((u64)attr->key_size + attr->value_size >= ....)

> +          sizeof(struct htab_elem))
> +               /* if key_size + value_size is bigger, the user space won't be
> +                * able to access the elements via bpf syscall. This check
> +                * also makes sure that the elem_size doesn't overflow and it's
>                  * kmalloc-able later in htab_map_update_elem()
>                  */
>                 return -E2BIG;

[...]

> +
> +SEC("raw_tracepoint/sys_enter")
> +int bpf_hash_large_key_test(void *ctx)
> +{
> +       int zero = 0, err = 1, value = 42;
> +       struct bigelement *key;
> +
> +       key = bpf_map_lookup_elem(&key_map, &zero);
> +       if (!key)
> +               goto err;
> +
> +       key->c = 1;
> +       if (bpf_map_update_elem(&hash_map, key, &value, BPF_ANY))
> +               goto err;
> +
> +       err = 0;
> +err:
> +       return err;

return value from raw_tracepoint doesn't really communicate error, you
might as well just return 0 always

> +}
> +
> diff --git a/tools/testing/selftests/bpf/test_maps.c b/tools/testing/selftests/bpf/test_maps.c
> index 0d92ebcb335d..0ad3e6305ff0 100644
> --- a/tools/testing/selftests/bpf/test_maps.c
> +++ b/tools/testing/selftests/bpf/test_maps.c
> @@ -1223,9 +1223,10 @@ static void test_map_in_map(void)
>
>  static void test_map_large(void)
>  {
> +
>         struct bigkey {
>                 int a;
> -               char b[116];
> +               char b[4096];
>                 long long c;
>         } key;
>         int fd, i, value;
> --
> 2.26.2
>
