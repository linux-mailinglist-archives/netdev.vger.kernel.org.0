Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC2BC5A5D6
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 22:25:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727173AbfF1UZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 16:25:22 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46022 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727133AbfF1UZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 16:25:22 -0400
Received: by mail-qt1-f195.google.com with SMTP id j19so7768997qtr.12;
        Fri, 28 Jun 2019 13:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wHz+vlt0dg4TE0SoMKY2nvi/jTEhpe9cZ2qg617OR9w=;
        b=KEwccJEc3yp+dc8RFo7AOuV4ssOA9SE96USelSFIPugmnLJ1CJUkLoUb5OtcfZVY3N
         zSpz4qQcVYKQA848RXmFVT73uRGuMehV5OWk4LKi1g3Er+wlOsUTb0A6vtrMz4oZrnB3
         mnTDp4yizaroQKPJdgpCOTaDusceEppbHuqNN+P820hF+c6Rx/a6Oj5l4P9igSS04OsH
         VI5AfH52I4Ibiq4dJUiNcfv0VCwCsxG8s+Gqgq3f9Du6gXFurentCZYpc7Qu7B3U4969
         ovLSdvhLXZex78zmDdtWb5pjYMFSc+zzIOFDwYRz6eciEBLmzI1gm0jrzOnby4w2pjRX
         dhUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wHz+vlt0dg4TE0SoMKY2nvi/jTEhpe9cZ2qg617OR9w=;
        b=eHX8PSJbt8lqAICTE6sMDdD3rFRIfh/QxREEi/eAzDKNOiwRVyhrh9+ANBq/kD2fu3
         H+7unOopFIG1Z565WbrKPotCbkhGCMtLXISTWCkUFjbm8zaZQD9BD8vSDl+gvlCReWRa
         2H6H/Xr+L0rxo6/ipRzwzcC65MdoLz4peR0EbVbodYKPD6pSbbqMZpC+CKUnrVE3xw4A
         u51ZhwlqvMnjHpG5FzIxeOR1OEyaxEc3utj9QineBXq+6TqK0/KOABgIbhoH3BxPHY8d
         DQFC5M2Z4Ffu09BjW7p/Je6ImyQL5hPVUh1JZfGo3pDkK7mwAkbbtYfXLtz2CN8trIbd
         7T7Q==
X-Gm-Message-State: APjAAAWKKxcxB9OmskveE/B//BpOUtF1SQ0vPOlb2n1FIFxUAb09eWaS
        VqG5rsVzvxh8V6Dt70aMcsMf09xso5udJatqW/o=
X-Google-Smtp-Source: APXvYqy6UAjEn/3t4UpT1HSaVQUNVG5rgQbSO6eKf0pIpGRjdpoBaZdsDK7kA2R6yHZUNvITl0oFjLRJod5jj4aM4Fk=
X-Received: by 2002:a0c:9695:: with SMTP id a21mr10205815qvd.24.1561753520639;
 Fri, 28 Jun 2019 13:25:20 -0700 (PDT)
MIME-Version: 1.0
References: <20190628011233.63680-1-sdf@google.com>
In-Reply-To: <20190628011233.63680-1-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Fri, 28 Jun 2019 13:25:09 -0700
Message-ID: <CAPhsuW4eroS+aPLVBsMi03E4FMfLEFtSCmmYcD4r8FKR6oBYXQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: fix -Wstrict-aliasing in test_sockopt_sk.c
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 6:14 PM Stanislav Fomichev <sdf@google.com> wrote:
>
> Let's use union with u8[4] and u32 members for sockopt buffer,
> that should fix any possible aliasing issues.
>
> test_sockopt_sk.c: In function =E2=80=98getsetsockopt=E2=80=99:
> test_sockopt_sk.c:115:2: warning: dereferencing type-punned pointer will =
break strict-aliasing rules [-Wstrict-aliasing]
>   if (*(__u32 *)buf !=3D 0x55AA*2) {
>   ^~
> test_sockopt_sk.c:116:3: warning: dereferencing type-punned pointer will =
break strict-aliasing rules [-Wstrict-aliasing]
>    log_err("Unexpected getsockopt(SO_SNDBUF) 0x%x !=3D 0x55AA*2",
>    ^~~~~~~
>
> Fixes: 8a027dc0d8f5 ("selftests/bpf: add sockopt test that exercises sk h=
elpers")
> Reported-by: Alexei Starovoitov <ast@kernel.org>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/testing/selftests/bpf/test_sockopt_sk.c | 51 +++++++++----------
>  1 file changed, 24 insertions(+), 27 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/test_sockopt_sk.c b/tools/testin=
g/selftests/bpf/test_sockopt_sk.c
> index 12e79ed075ce..036b652e5ca9 100644
> --- a/tools/testing/selftests/bpf/test_sockopt_sk.c
> +++ b/tools/testing/selftests/bpf/test_sockopt_sk.c
> @@ -22,7 +22,10 @@
>  static int getsetsockopt(void)
>  {
>         int fd, err;
> -       char buf[4] =3D {};
> +       union {
> +               char u8[4];
> +               __u32 u32;
> +       } buf =3D {};
>         socklen_t optlen;
>
>         fd =3D socket(AF_INET, SOCK_STREAM, 0);
> @@ -33,31 +36,31 @@ static int getsetsockopt(void)
>
>         /* IP_TOS - BPF bypass */
>
> -       buf[0] =3D 0x08;
> -       err =3D setsockopt(fd, SOL_IP, IP_TOS, buf, 1);
> +       buf.u8[0] =3D 0x08;
> +       err =3D setsockopt(fd, SOL_IP, IP_TOS, &buf, 1);
>         if (err) {
>                 log_err("Failed to call setsockopt(IP_TOS)");
>                 goto err;
>         }
>
> -       buf[0] =3D 0x00;
> +       buf.u8[0] =3D 0x00;
>         optlen =3D 1;
> -       err =3D getsockopt(fd, SOL_IP, IP_TOS, buf, &optlen);
> +       err =3D getsockopt(fd, SOL_IP, IP_TOS, &buf, &optlen);
>         if (err) {
>                 log_err("Failed to call getsockopt(IP_TOS)");
>                 goto err;
>         }
>
> -       if (buf[0] !=3D 0x08) {
> +       if (buf.u8[0] !=3D 0x08) {
>                 log_err("Unexpected getsockopt(IP_TOS) buf[0] 0x%02x !=3D=
 0x08",
> -                       buf[0]);
> +                       buf.u8[0]);
>                 goto err;
>         }
>
>         /* IP_TTL - EPERM */
>
> -       buf[0] =3D 1;
> -       err =3D setsockopt(fd, SOL_IP, IP_TTL, buf, 1);
> +       buf.u8[0] =3D 1;
> +       err =3D setsockopt(fd, SOL_IP, IP_TTL, &buf, 1);
>         if (!err || errno !=3D EPERM) {
>                 log_err("Unexpected success from setsockopt(IP_TTL)");
>                 goto err;
> @@ -65,16 +68,16 @@ static int getsetsockopt(void)
>
>         /* SOL_CUSTOM - handled by BPF */
>
> -       buf[0] =3D 0x01;
> -       err =3D setsockopt(fd, SOL_CUSTOM, 0, buf, 1);
> +       buf.u8[0] =3D 0x01;
> +       err =3D setsockopt(fd, SOL_CUSTOM, 0, &buf, 1);
>         if (err) {
>                 log_err("Failed to call setsockopt");
>                 goto err;
>         }
>
> -       buf[0] =3D 0x00;
> +       buf.u32 =3D 0x00;
>         optlen =3D 4;
> -       err =3D getsockopt(fd, SOL_CUSTOM, 0, buf, &optlen);
> +       err =3D getsockopt(fd, SOL_CUSTOM, 0, &buf, &optlen);
>         if (err) {
>                 log_err("Failed to call getsockopt");
>                 goto err;
> @@ -84,37 +87,31 @@ static int getsetsockopt(void)
>                 log_err("Unexpected optlen %d !=3D 1", optlen);
>                 goto err;
>         }
> -       if (buf[0] !=3D 0x01) {
> -               log_err("Unexpected buf[0] 0x%02x !=3D 0x01", buf[0]);
> +       if (buf.u8[0] !=3D 0x01) {
> +               log_err("Unexpected buf[0] 0x%02x !=3D 0x01", buf.u8[0]);
>                 goto err;
>         }
>
>         /* SO_SNDBUF is overwritten */
>
> -       buf[0] =3D 0x01;
> -       buf[1] =3D 0x01;
> -       buf[2] =3D 0x01;
> -       buf[3] =3D 0x01;
> -       err =3D setsockopt(fd, SOL_SOCKET, SO_SNDBUF, buf, 4);
> +       buf.u32 =3D 0x01010101;
> +       err =3D setsockopt(fd, SOL_SOCKET, SO_SNDBUF, &buf, 4);
>         if (err) {
>                 log_err("Failed to call setsockopt(SO_SNDBUF)");
>                 goto err;
>         }
>
> -       buf[0] =3D 0x00;
> -       buf[1] =3D 0x00;
> -       buf[2] =3D 0x00;
> -       buf[3] =3D 0x00;
> +       buf.u32 =3D 0x00;
>         optlen =3D 4;
> -       err =3D getsockopt(fd, SOL_SOCKET, SO_SNDBUF, buf, &optlen);
> +       err =3D getsockopt(fd, SOL_SOCKET, SO_SNDBUF, &buf, &optlen);
>         if (err) {
>                 log_err("Failed to call getsockopt(SO_SNDBUF)");
>                 goto err;
>         }
>
> -       if (*(__u32 *)buf !=3D 0x55AA*2) {
> +       if (buf.u32 !=3D 0x55AA*2) {
>                 log_err("Unexpected getsockopt(SO_SNDBUF) 0x%x !=3D 0x55A=
A*2",
> -                       *(__u32 *)buf);
> +                       buf.u32);
>                 goto err;
>         }
>
> --
> 2.22.0.410.gd8fdbe21b5-goog
>
