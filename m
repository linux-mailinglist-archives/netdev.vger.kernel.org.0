Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F881634BC
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 22:21:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgBRVV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 16:21:26 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:38696 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726352AbgBRVVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 16:21:25 -0500
Received: by mail-qk1-f193.google.com with SMTP id z19so21019787qkj.5;
        Tue, 18 Feb 2020 13:21:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LQ64KB+SxWlk5T/EEiMuvPiP3uK4I4XFfLmMHv+k+HY=;
        b=u985Z+2gGIfpFk5yThwq9eaffQ5n6cRW5bSOj3+0ZOKArM0N4SY+x/eaMONdaOP7vA
         9SW16DKzaJJwXuFC7hKrb0fIQZjeMnO0kqXSJDLQRSL2gfaIspWdhnV5GWso9vMOxaU3
         8dUZbadEd2JLh5xet3+EiwWIWuwxgDAYu+z8DWov5EjFC/Zd98gdDc1DueLGHd8m7hu+
         Xl0rk+8N02eZ/P4XQ+Kyn9IWZQZxJNzbgZtQbtOAsThZXhZjcrMefK8z9tE5/9gEPegb
         ilGjBpYq0wkEt60SXq9DuxgJMrHIpr9c3rvOp4FNzCgtP0mgXtZG8TRqU3z8yVD30LJb
         KNRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LQ64KB+SxWlk5T/EEiMuvPiP3uK4I4XFfLmMHv+k+HY=;
        b=k/jJNXm8Goj4WEbbPD0Sbjhxu8vJqKpZUAHZWpQeiUQziwOi3KT/aTTJd9AshzHomw
         /7cS/jvjg67oZy/YnOVpC3HS6o3K3z0wT1kpd09WvocNhhJfqWNKzzRPmHwxPRHYrvld
         81fgrirOC8WNBxawOy+ntUBtJvYm9s0X2VgzyDUn93Vo4qyRCF9P9ksywKbx3DZKGWJ7
         WviwxvqVv3pGtnb4fjD81EEW5n4/Sv+jzM1aOm/0YBJvgdLjMeKrEciRcDqv/qa/Q9Yr
         4PN63j6rOfV9F30JUawXBAjuWR6U6wOsJXoHDrfi+tylyHmcxrbMUCmH1KZ3e0zxXroJ
         3leQ==
X-Gm-Message-State: APjAAAWDqVsHD7p697kW2t/HOpY5kd2H3kdEEOS1kNjMBVWodrVG4UWJ
        emLx0Z6qgxsDMXgbb8oVNFa+4Rtk2yPAmwx6ysc=
X-Google-Smtp-Source: APXvYqxEVKW5Haaca66zUDYRxgJ6rbLd++np5oICLEiSRfqGn4JvovnZv/+h1alVg7OztBotwFYamMmqZ/e0KpnMXJ8=
X-Received: by 2002:a37:2744:: with SMTP id n65mr20620739qkn.92.1582060884775;
 Tue, 18 Feb 2020 13:21:24 -0800 (PST)
MIME-Version: 1.0
References: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial> <158194342478.104074.6851588870108514192.stgit@xdp-tutorial>
In-Reply-To: <158194342478.104074.6851588870108514192.stgit@xdp-tutorial>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 18 Feb 2020 13:21:14 -0800
Message-ID: <CAEf4BzYx2ZccrAu8JC=UxeHamk4dHKVa2jH4P=Hr7VzMwUphJQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 3/3] selftests/bpf: update xdp_bpf2bpf test to
 use new set_attach_target API
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     bpf <bpf@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 17, 2020 at 5:03 AM Eelco Chaudron <echaudro@redhat.com> wrote:
>
> Use the new bpf_program__set_attach_target() API in the xdp_bpf2bpf
> selftest so it can be referenced as an example on how to use it.
>
>

nit: extra empty line?

> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> ---
>  .../testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c |   16 +++++++++++++-=
--
>  .../testing/selftests/bpf/progs/test_xdp_bpf2bpf.c |    4 ++--
>  2 files changed, 15 insertions(+), 5 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> index 6b56bdc73ebc..513fdbf02b81 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_bpf2bpf.c
> @@ -14,7 +14,7 @@ void test_xdp_bpf2bpf(void)
>         struct test_xdp *pkt_skel =3D NULL;
>         struct test_xdp_bpf2bpf *ftrace_skel =3D NULL;
>         struct vip key4 =3D {.protocol =3D 6, .family =3D AF_INET};
> -       DECLARE_LIBBPF_OPTS(bpf_object_open_opts, opts);
> +       struct bpf_program *prog;
>
>         /* Load XDP program to introspect */
>         pkt_skel =3D test_xdp__open_and_load();
> @@ -27,11 +27,21 @@ void test_xdp_bpf2bpf(void)
>         bpf_map_update_elem(map_fd, &key4, &value4, 0);
>
>         /* Load trace program */
> -       opts.attach_prog_fd =3D pkt_fd,
> -       ftrace_skel =3D test_xdp_bpf2bpf__open_opts(&opts);
> +       ftrace_skel =3D test_xdp_bpf2bpf__open();
>         if (CHECK(!ftrace_skel, "__open", "ftrace skeleton failed\n"))
>                 goto out;
>
> +       /* Demonstrate the bpf_program__set_attach_target() API rather th=
an
> +        * the load with options, i.e. opts.attach_prog_fd.
> +        */
> +       prog =3D *ftrace_skel->skeleton->progs[0].prog;

it took me a while to understand what's going on here... :) You are
not supposed to peek into ftrace_skel->skeleton, it's an "internal"
object that's passed into libbpf.

It's better to write it as a nice and short:

prog =3D ftrace_skel->progs.trace_on_entry;

> +       bpf_program__set_expected_attach_type(prog, BPF_TRACE_FENTRY);
> +       bpf_program__set_attach_target(prog, pkt_fd, "_xdp_tx_iptunnel");
> +
> +       prog =3D *ftrace_skel->skeleton->progs[1].prog;

same as above: ftrace_skel->progs.trace_on_exit

> +       bpf_program__set_expected_attach_type(prog, BPF_TRACE_FEXIT);
> +       bpf_program__set_attach_target(prog, pkt_fd, "_xdp_tx_iptunnel");
> +
>         err =3D test_xdp_bpf2bpf__load(ftrace_skel);
>         if (CHECK(err, "__load", "ftrace skeleton failed\n"))
>                 goto out;
> diff --git a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c b/tools=
/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> index cb8a04ab7a78..b840fc9e3ed5 100644
> --- a/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> +++ b/tools/testing/selftests/bpf/progs/test_xdp_bpf2bpf.c
> @@ -28,7 +28,7 @@ struct xdp_buff {
>  } __attribute__((preserve_access_index));
>
>  __u64 test_result_fentry =3D 0;
> -SEC("fentry/_xdp_tx_iptunnel")
> +SEC("fentry/FUNC")
>  int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
>  {
>         test_result_fentry =3D xdp->rxq->dev->ifindex;
> @@ -36,7 +36,7 @@ int BPF_PROG(trace_on_entry, struct xdp_buff *xdp)
>  }
>
>  __u64 test_result_fexit =3D 0;
> -SEC("fexit/_xdp_tx_iptunnel")
> +SEC("fexit/FUNC")
>  int BPF_PROG(trace_on_exit, struct xdp_buff *xdp, int ret)
>  {
>         test_result_fexit =3D ret;
>
