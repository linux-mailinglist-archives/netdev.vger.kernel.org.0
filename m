Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 890A353D306
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 22:59:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349375AbiFCU7T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 16:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343709AbiFCU7Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 16:59:16 -0400
Received: from mail-lj1-x230.google.com (mail-lj1-x230.google.com [IPv6:2a00:1450:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A3BE3525A;
        Fri,  3 Jun 2022 13:59:15 -0700 (PDT)
Received: by mail-lj1-x230.google.com with SMTP id m25so6344005lji.11;
        Fri, 03 Jun 2022 13:59:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VG18wTnR8sVhdBQaPjEWxn+wEw8AOfc4wd3Cmh+GZuM=;
        b=FFU1mT2FIn9Dusqyo01GRwvphdcK00uhcFOyVS9PmC9Tm/49InMSdgsB9GA5i9ABep
         talMa2tAb5zxit99YUg0J0eBIrkJPyZA8KrKdcJBx55+kWybEGi3b8boKUstTrGW7034
         wcDnZ0BuvGa8agdEcsuVmKveULmzX7PtaGRgZGtfHoLmTT5hQBI8ho210OZCjHKiYL11
         nLc71suBzFFE7xcODufzYerMaNdmkjtgDJ5siQyhR2fc6rbrWcZk4oSYd9NBPIEUcQ3t
         89+Yf8R7DGSRcIP6kd5r0mlFm4b76klqRZPMGRtymmNVy3vS2gZVoZkX7yjtHOhI4q0S
         KplQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VG18wTnR8sVhdBQaPjEWxn+wEw8AOfc4wd3Cmh+GZuM=;
        b=myF4XNNBdHsJ0GtlA+dRK4ypasr4LQ9titQZMHOYTLb1kppJNJfzddqx6GNGhsmdk+
         BxDYc09m5ywkIe/m1l+LDYPNUSJLG5pO+sAOwobPKM65L4SRq9yXCGrG/e1hho+JPyeg
         FqWU3kjXIzftca2+qwEQk9ntk2QKeUyAGrnZQBNE+ydkd9FBmYcxX6MqWdz3rT2kmsTw
         EotVn3t8vFKbY0hBql5YGV7Ic397UO5MmydcKhOBJ1v+JG/oPc0jMmv0c81h27GmRejw
         eP7ZW103P9KMc2j7bCxJai+mUY1JB4EL6NiZyLbr3bPcGn2D3UoQNlpVtaXqVjvBkRdY
         n6dQ==
X-Gm-Message-State: AOAM533nwQVDepxVVgVc5VhMvbbP9Sk5ev4cczmQqiPZBVHr22sJNxDK
        T89CoBxL8IlcTlI7EtuIbdCaelcP1l4Nb534oo/UqQTD
X-Google-Smtp-Source: ABdhPJwMWF6oDaeLNuqHfpKKuEOUwD5FH1cVSpirnvEWAVs2cLIU795UyObrT+XRMtCRAmKXPbV553GPARsdeft9WKY=
X-Received: by 2002:a2e:bd13:0:b0:246:1ff8:6da1 with SMTP id
 n19-20020a2ebd13000000b002461ff86da1mr44955810ljq.219.1654289953352; Fri, 03
 Jun 2022 13:59:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220602143748.673971-1-roberto.sassu@huawei.com> <20220602143748.673971-3-roberto.sassu@huawei.com>
In-Reply-To: <20220602143748.673971-3-roberto.sassu@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 13:59:02 -0700
Message-ID: <CAEf4BzavaF=y+n360oYQ7L_r1G4bfV_8gsaX-9EkNjp4=9VxYA@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] libbpf: Introduce bpf_obj_get_flags()
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 2, 2022 at 7:38 AM Roberto Sassu <roberto.sassu@huawei.com> wrote:
>
> Introduce the bpf_obj_get_flags() function, so that it is possible to
> specify the needed permissions for obtaining a file descriptor from a
> pinned object.
>
> Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> ---
>  tools/lib/bpf/bpf.c      | 8 +++++++-
>  tools/lib/bpf/bpf.h      | 1 +
>  tools/lib/bpf/libbpf.map | 1 +
>  3 files changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf.c b/tools/lib/bpf/bpf.c
> index 33bac2006043..a5fc40f6ce13 100644
> --- a/tools/lib/bpf/bpf.c
> +++ b/tools/lib/bpf/bpf.c
> @@ -670,18 +670,24 @@ int bpf_obj_pin(int fd, const char *pathname)
>         return libbpf_err_errno(ret);
>  }
>
> -int bpf_obj_get(const char *pathname)
> +int bpf_obj_get_flags(const char *pathname, __u32 flags)

same note about bpf_obj_get_opts() instead


>  {
>         union bpf_attr attr;
>         int fd;
>
>         memset(&attr, 0, sizeof(attr));
>         attr.pathname = ptr_to_u64((void *)pathname);
> +       attr.file_flags = flags;
>
>         fd = sys_bpf_fd(BPF_OBJ_GET, &attr, sizeof(attr));
>         return libbpf_err_errno(fd);
>  }
>
> +int bpf_obj_get(const char *pathname)
> +{
> +       return bpf_obj_get_flags(pathname, 0);
> +}
> +
>  int bpf_prog_attach(int prog_fd, int target_fd, enum bpf_attach_type type,
>                     unsigned int flags)
>  {
> diff --git a/tools/lib/bpf/bpf.h b/tools/lib/bpf/bpf.h
> index 20e4c852362d..6d0ceb2e90c4 100644
> --- a/tools/lib/bpf/bpf.h
> +++ b/tools/lib/bpf/bpf.h
> @@ -339,6 +339,7 @@ LIBBPF_API int bpf_map_update_batch(int fd, const void *keys, const void *values
>                                     const struct bpf_map_batch_opts *opts);
>
>  LIBBPF_API int bpf_obj_pin(int fd, const char *pathname);
> +LIBBPF_API int bpf_obj_get_flags(const char *pathname, __u32 flags);
>  LIBBPF_API int bpf_obj_get(const char *pathname);
>
>  struct bpf_prog_attach_opts {
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 019278e66836..6c3ace12b27b 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -467,6 +467,7 @@ LIBBPF_1.0.0 {
>                 libbpf_bpf_map_type_str;
>                 libbpf_bpf_prog_type_str;
>                 bpf_map_get_fd_by_id_flags;
> +               bpf_obj_get_flags;
>
>         local: *;
>  };
> --
> 2.25.1
>
