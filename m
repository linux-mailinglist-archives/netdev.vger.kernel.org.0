Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE7020BA53
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 22:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725823AbgFZUau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 16:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFZUau (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 16:30:50 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0387EC03E979;
        Fri, 26 Jun 2020 13:30:49 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id h18so5085619qvl.3;
        Fri, 26 Jun 2020 13:30:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SzI/eacQi/LQ5SgxAlxQs++koYpDXi72nDz9UV627E8=;
        b=Jp4pf9CgkrizudMeUpWzBnK30NjpMwdZa7WIw13EvaVErmg80QD1KIlZNeNjngPHh6
         kSqpAKwR/RYDrc2aYDI9ORGFtirbiRoiL7Qt0yeiV78Owp0OS/jXYrZevpagSgzrUwiY
         m2UFQtf7pXskzqD6qjlOaKDrQXgoS+d6pa1lI6tCNhGkPtwj4n2/cDPCUS4CCjZbmlpz
         //inN5FXeOWlJ1Q67hol5Fdj9ar2fSBuHdw4DfKYdSxwLnE/hhqJ12N6bUPcFdouPCh2
         A03W+DFBByB93POil9liVHqTTVVjaNBk38SC/oJF7h+qZ1YfIPPKwDyyPzpDtJqjohI3
         2UgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SzI/eacQi/LQ5SgxAlxQs++koYpDXi72nDz9UV627E8=;
        b=hT2St+e2nOk64Jxp0FtfhZqiR309KiQpnt3Il60kT7XWl465HgfYIsD29F1BFM99cw
         oxh5eTmeF2vsnhcAtvyDVrSzUbDwIAcyIIklgr5bWMCyhUL2Z8MikLQeinLgF58AtEu+
         cJ/byLsWt9piHfAGezuVZHVZYoJNkRMPHo7I21/HsgfvyDzXatxPLwj19qVg9yxx1J6Q
         dTkLsDDFXEhDYi+mdzGb4TAvg/oKldMG7LLwfptbx7ZXwYzjopd2wRE3GK+h3eWuo0nr
         O0kSkKC+h1zJ59ov0FRuptnHCcpQFfTsJ365FPG9H8i+K73aFsRoCc+L2EILwethW8gk
         2KLw==
X-Gm-Message-State: AOAM532skVzq39RX3S5Gur1doYpkL8bXmkrwqh0VEERkaQKZj8FNVB7v
        x2TQhJWNl229+8ySECd/xjYPOB3h3NDbK8aRuyg=
X-Google-Smtp-Source: ABdhPJzDDkF1vJJNUAqWqRcgtTXf9OpjYF2TT4JtzuRr6V+PYbTkw7i2mtjCPyTAzdyvwjJHZysUh4sQ3RtSkhVi1Jk=
X-Received: by 2002:a05:6214:bce:: with SMTP id ff14mr4923236qvb.196.1593203449165;
 Fri, 26 Jun 2020 13:30:49 -0700 (PDT)
MIME-Version: 1.0
References: <20200626081720.5546-1-danieltimlee@gmail.com> <20200626081720.5546-3-danieltimlee@gmail.com>
In-Reply-To: <20200626081720.5546-3-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 13:30:38 -0700
Message-ID: <CAEf4BzbGk2xSGAkLEXKSg3NhrL28o+cmW9jTq2=EhggJEYT=5Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] samples: bpf: refactor BPF map in map test with libbpf
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 26, 2020 at 1:18 AM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> From commit 646f02ffdd49 ("libbpf: Add BTF-defined map-in-map
> support"), a way to define internal map in BTF-defined map has been
> added.
>
> Instead of using previous 'inner_map_idx' definition, the structure to
> be used for the inner map can be directly defined using array directive.
>
>     __array(values, struct inner_map)
>
> This commit refactors map in map test program with libbpf by explicitly
> defining inner map with BTF-defined format.
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---

Thanks for the clean up, looks good except that prog NULL check.

It also seems like this is the last use of bpf_map_def_legacy, do you
mind removing it as well?


>  samples/bpf/Makefile               |  2 +-
>  samples/bpf/test_map_in_map_kern.c | 85 +++++++++++++++---------------
>  samples/bpf/test_map_in_map_user.c | 53 +++++++++++++++++--
>  3 files changed, 91 insertions(+), 49 deletions(-)
>

[...]

>
>         snprintf(filename, sizeof(filename), "%s_kern.o", argv[0]);
> +       obj = bpf_object__open_file(filename, NULL);
> +       if (libbpf_get_error(obj)) {

this is right, but...

> +               fprintf(stderr, "ERROR: opening BPF object file failed\n");
> +               return 0;
> +       }
>
> -       if (load_bpf_file(filename)) {
> -               printf("%s", bpf_log_buf);
> -               return 1;
> +       prog = bpf_object__find_program_by_name(obj, "trace_sys_connect");
> +       if (libbpf_get_error(prog)) {

this is wrong. Just NULL check. libbpf APIs are not very consistent
with what they return, unfortunately.

> +               printf("finding a prog in obj file failed\n");
> +               goto cleanup;
> +       }
> +

[...]
