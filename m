Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72E57FE82F
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 23:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfKOWmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Nov 2019 17:42:36 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:35166 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbfKOWmg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Nov 2019 17:42:36 -0500
Received: by mail-qt1-f196.google.com with SMTP id n4so12543133qte.2;
        Fri, 15 Nov 2019 14:42:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1Ljh/C9bOl+iw6pSFvN3eoLNKQmG6h31Yeu6UPqkFhQ=;
        b=qTyktsT4cDpAQOuWRvAREFnO06PUl5P+DdqgZm+lxHqH05GZI2qSuxSrvvBPdanQoL
         URI+YXs/LLv+nK0GkRAFNzSNYbBipDq1Hbt08kTHPTpcA92Cc+UaxSaCLIhPHQ7OMKc8
         Cw9eqqoYH3rVjwSYxFU8rW3d0rClYqPQLkNu7UdD1JjEgK56fhBbOE9PXYG/ndHyBjlG
         SlseIWTzGRdJ94MYa95c+aTBf0b3yDAZK2UO8zs72iuNvX+5QraLP7zU/s2aHpPoq8Xo
         omyqG8D30tKykT7YpnQxkY4kIdYAzSkJpRaDsAdaR20562wr39KFzy83C/L9crO+tD95
         4P8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1Ljh/C9bOl+iw6pSFvN3eoLNKQmG6h31Yeu6UPqkFhQ=;
        b=KCXSHrrhbBy0vlgA1/EWPksFHv9GWnMMnlcb7QcKDYSpTmqU9TanBN4/bJoFfJz3dN
         hz3Z9xF3Q96rubq1ug3ZOENRDF+45Nb35JfeqNRDZ7lGHO3MY0zLbBL1RjonlWOAB255
         YWRtzsGRdsPckjtgdqYEekAw1rEVTiljbF1yhSijBIroqRBUV+omvVop64btVIwRhB5N
         LGjXcyOE76U3uWTLzF7VxJNlSKJsjqnjX2IQAPU3mlCYyV2GTuN2fXRV9PULe9czrrJv
         IVG/UDgrGLbtr+c+ZlCZqEccp4Dp8Q0VG8F7uNxMLosPYoQI2WhYfSVhsoxG0tCEXzWi
         R02Q==
X-Gm-Message-State: APjAAAWyyhsUAIIOBIW/0hkVaumR0Grcf3FNgUpulytqv3XvTLUUU/Ec
        Cz/Q6Z1+KeutjfHtDBeyNwDbrKKsHkwjQgqQzz0=
X-Google-Smtp-Source: APXvYqxS8GFDbUqv8q+wlxQKq2ZdR4dc8Hypo7Wdr47XR6xakaez1owd4zmlDuenxRAj580QV3D41WsgWMccHfyOOeQ=
X-Received: by 2002:ac8:199d:: with SMTP id u29mr15886076qtj.93.1573857754983;
 Fri, 15 Nov 2019 14:42:34 -0800 (PST)
MIME-Version: 1.0
References: <20191107212023.171208-1-brianvv@google.com> <20191107212023.171208-3-brianvv@google.com>
In-Reply-To: <20191107212023.171208-3-brianvv@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 15 Nov 2019 14:42:24 -0800
Message-ID: <CAEf4Bzbn6J79+_wK2+JtQaGRiiM9hCGyOsuE9DeSqa9ngemTWw@mail.gmail.com>
Subject: Re: [RFC bpf-next 2/3] tools/bpf: test bpf_map_lookup_and_delete_batch()
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>, Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 7, 2019 at 1:23 PM Brian Vazquez <brianvv@google.com> wrote:
>
> From: Yonghong Song <yhs@fb.com>
>
> Added four libbpf API functions to support map batch operations:
>   . int bpf_map_delete_batch( ... )
>   . int bpf_map_lookup_batch( ... )
>   . int bpf_map_lookup_and_delete_batch( ... )
>   . int bpf_map_update_batch( ... )
>
> Tested bpf_map_lookup_and_delete_batch() and bpf_map_update_batch()
> functionality.
>   $ ./test_maps
>   ...
>   test_map_lookup_and_delete_batch:PASS
>   ...
>
> Note that I clumped uapi header sync patch, libbpf patch
> and tests patch together considering this is a RFC patch.
> Will do proper formating once it is out of RFC stage.
>
> Signed-off-by: Yonghong Song <yhs@fb.com>
> ---

[...]

>
> +       struct { /* struct used by BPF_MAP_*_BATCH commands */
> +               __u64           batch;  /* input/output:
> +                                        * input: start batch,
> +                                        *        0 to start from beginning.
> +                                        * output: next start batch,
> +                                        *         0 to end batching.
> +                                        */
> +               __aligned_u64   keys;
> +               __aligned_u64   values;
> +               __u32           count;  /* input/output:
> +                                        * input: # of elements keys/values.
> +                                        * output: # of filled elements.
> +                                        */
> +               __u32           map_fd;
> +               __u64           elem_flags;
> +               __u64           flags;
> +       } batch;
> +

Describe what elem_flags and flags are here?

[...]

> +LIBBPF_API int bpf_map_delete_batch(int fd, __u64 *batch, __u32 *count,
> +                                   __u64 elem_flags, __u64 flags);
> +LIBBPF_API int bpf_map_lookup_batch(int fd, __u64 *batch, void *keys,
> +                                   void *values, __u32 *count,
> +                                   __u64 elem_flags, __u64 flags);
> +LIBBPF_API int bpf_map_lookup_and_delete_batch(int fd, __u64 *batch,
> +                                              void *keys, void *values,
> +                                              __u32 *count, __u64 elem_flags,
> +                                              __u64 flags);
> +LIBBPF_API int bpf_map_update_batch(int fd, void *keys, void *values,
> +                                   __u32 *count, __u64 elem_flags,
> +                                   __u64 flags);

Should we start using the same approach as with bpf_object__open_file
(see LIBBPF_OPTS), so that we can keep adding extra fields without
breaking ABI? The gist is: use function arguments for mandatory fields
(as of right now, at least), and put all the optional fields into a
xxx_opts struct, which can be NULL. Please see
bpf_object__open_{file,mem} for details.

> +
>  LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
>  LIBBPF_API int bpf_obj_get(const char *pathname);
>  LIBBPF_API int bpf_prog_attach(int prog_fd, int attachable_fd,
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 86173cbb159d3..0529a770a04eb 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -189,6 +189,10 @@ LIBBPF_0.0.4 {
>  LIBBPF_0.0.5 {
>         global:
>                 bpf_btf_get_next_id;
> +               bpf_map_delete_batch;
> +               bpf_map_lookup_and_delete_batch;
> +               bpf_map_lookup_batch;
> +               bpf_map_update_batch;
>  } LIBBPF_0.0.4;

This should be in 0.0.6 section now.

>

[...]
