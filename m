Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 993C7234A58
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 19:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387625AbgGaRkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 13:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732973AbgGaRkL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jul 2020 13:40:11 -0400
Received: from mail-yb1-xb43.google.com (mail-yb1-xb43.google.com [IPv6:2607:f8b0:4864:20::b43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2FEC061574;
        Fri, 31 Jul 2020 10:40:11 -0700 (PDT)
Received: by mail-yb1-xb43.google.com with SMTP id n141so14432120ybf.3;
        Fri, 31 Jul 2020 10:40:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8b/Gz63jV8i64EIMR1/6c06BEPrGRFh8qZ4FbX6xqVM=;
        b=q/VIBgY9C17ORCh9W+8WpvzsHoG8oYEx1yoLr1as1o9Yb1UCL281l4mNZBXyrhngVj
         2ckW44YZGI+hkRV/tfZWvKssZJSSaxVJ0UWkzwQXxRwYLKAFtmxxA2qiOGClgQwE5LFB
         oF7WlDDwelHTWn8HaP7JXhS+D0/UJwqRwbfHqfG5YvN2sc5ZdRRULgczODklAR4m2AzH
         NjYjiorgCbPvGKS+RHp2bG5Xkod95B+wRR0Naedzrqu/AyP8QiPK1g7pBlbQsmelXQNd
         kBl5z3kBxwVC9F4LX9ERTevZrDrQM0P6FqiAAkBV9YxCQthZ5iV95mp28UqUfXVz5h+m
         ZeCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8b/Gz63jV8i64EIMR1/6c06BEPrGRFh8qZ4FbX6xqVM=;
        b=WtM+KHQefNz30OIvQLn8Atc3NInZTbGnLuDOoEQHsPZ4Vzsc1E6jnzuMV1f7JRRHLV
         2OH5sIOT6QWrZpRcHojEY8lRf1DLXUNgSX0Na0dceT6ylgZMJcuG6Yylvw31aGifFdXl
         CBH9kdE9mz7fIQ60+LbHsd9dGjKiaPVGcpmC3CKSx7otajTc2CQ27I/tagWtAlK3x8Ru
         0UnpYPd3kkspt5JfVLKRr/fpVqQYahlEFet/nb43JTMVYAQs4hYd0Sw5TSsxAIfeqJDQ
         hZ0e6Tfown70g6AWGtQWv18nvNRRIvnES16n14QLViJJiuPwKQiAaEUmVe8EBZBMLw/S
         uong==
X-Gm-Message-State: AOAM532hGz7Ft5Dntps7ZxAEWQSbJchhcRX3EokL0R8LnaWa2bYKQGQ6
        HV1RfmNdbVnp2eoFYxpz7PWZWRJyJTbGOaQOaaMUcQ==
X-Google-Smtp-Source: ABdhPJwamYK1UxXdpljizPP02TFzOiw9n7waFqGuNJ6Vl7seV4+7fMtMmSVDUDY6b7FI1OQZNLHANenTR54PAj30vYA=
X-Received: by 2002:a25:84cd:: with SMTP id x13mr7846369ybm.425.1596217210540;
 Fri, 31 Jul 2020 10:40:10 -0700 (PDT)
MIME-Version: 1.0
References: <20200731061600.18344-1-Jianlin.Lv@arm.com>
In-Reply-To: <20200731061600.18344-1-Jianlin.Lv@arm.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 31 Jul 2020 10:39:59 -0700
Message-ID: <CAEf4BzY9Kc=Q664Yas+YY=2os_sjx9_RVwdQOwW_-=tkPAe8BA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] bpf: fix compilation warning of selftests
To:     Jianlin Lv <Jianlin.Lv@arm.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Song.Zhu@arm.com,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 30, 2020 at 11:18 PM Jianlin Lv <Jianlin.Lv@arm.com> wrote:
>
> Clang compiler version: 12.0.0
> The following warning appears during the selftests/bpf compilation:
>
> prog_tests/send_signal.c:51:3: warning: ignoring return value of =E2=80=
=98write=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>    51 |   write(pipe_c2p[1], buf, 1);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~~
> prog_tests/send_signal.c:54:3: warning: ignoring return value of =E2=80=
=98read=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>    54 |   read(pipe_p2c[0], buf, 1);
>       |   ^~~~~~~~~~~~~~~~~~~~~~~~~
> ......
>
> prog_tests/stacktrace_build_id_nmi.c:13:2: warning: ignoring return value
> of =E2=80=98fscanf=E2=80=99,declared with attribute warn_unused_result [-=
Wunused-resul]
>    13 |  fscanf(f, "%llu", &sample_freq);
>       |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>
> test_tcpnotify_user.c:133:2: warning:ignoring return value of =E2=80=98sy=
stem=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>   133 |  system(test_script);
>       |  ^~~~~~~~~~~~~~~~~~~
> test_tcpnotify_user.c:138:2: warning:ignoring return value of =E2=80=98sy=
stem=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>   138 |  system(test_script);
>       |  ^~~~~~~~~~~~~~~~~~~
> test_tcpnotify_user.c:143:2: warning:ignoring return value of =E2=80=98sy=
stem=E2=80=99,
> declared with attribute warn_unused_result [-Wunused-result]
>   143 |  system(test_script);
>       |  ^~~~~~~~~~~~~~~~~~~
>
> Add code that fix compilation warning about ignoring return value and
> handles any errors; Check return value of library`s API make the code
> more secure.
>
> Signed-off-by: Jianlin Lv <Jianlin.Lv@arm.com>
> ---
>  .../selftests/bpf/prog_tests/send_signal.c    | 37 ++++++++++++++-----
>  .../bpf/prog_tests/stacktrace_build_id_nmi.c  |  3 +-
>  .../selftests/bpf/test_tcpnotify_user.c       | 15 ++++++--
>  3 files changed, 41 insertions(+), 14 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/send_signal.c b/tools=
/testing/selftests/bpf/prog_tests/send_signal.c
> index 504abb7bfb95..7a5272e4e810 100644
> --- a/tools/testing/selftests/bpf/prog_tests/send_signal.c
> +++ b/tools/testing/selftests/bpf/prog_tests/send_signal.c
> @@ -48,22 +48,31 @@ static void test_send_signal_common(struct perf_event=
_attr *attr,
>                 close(pipe_p2c[1]); /* close write */
>
>                 /* notify parent signal handler is installed */
> -               write(pipe_c2p[1], buf, 1);
> +               if (CHECK_FAIL(write(pipe_c2p[1], buf, 1) !=3D 1)) {
> +                       perror("Child: write pipe error");
> +                       goto close_out;
> +               }

Please don't use CHECK_FAIL. Using CHECK is better for many reasons,
but it will also be shorter here (while still recording failure):


CHECK(write(pipe_c2p[1], buf, 1) !=3D 1, "pipe_write", "err %d\n", -errno);


>
>                 /* make sure parent enabled bpf program to send_signal */
> -               read(pipe_p2c[0], buf, 1);
> +               if (CHECK_FAIL(read(pipe_p2c[0], buf, 1) !=3D 1)) {
> +                       perror("Child: read pipe error");
> +                       goto close_out;
> +               }
>

[...]
