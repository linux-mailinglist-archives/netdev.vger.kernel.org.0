Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C31044AA3A0
	for <lists+netdev@lfdr.de>; Fri,  4 Feb 2022 23:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356182AbiBDWzd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Feb 2022 17:55:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353208AbiBDWz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Feb 2022 17:55:28 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1264C061354;
        Fri,  4 Feb 2022 14:55:27 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id a17so1096392iln.11;
        Fri, 04 Feb 2022 14:55:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FfyvWXugls19n5QGes78MZc5as0hWnBXVAGvk5Nfgac=;
        b=RAw6c2Q5Dcui3AOnZZXhD036N058VYR4lElHs8GEQ2WVqJwnpQ4ura/NvpCNhasI/4
         VPvVLLixzQslxcyvMIdyLey3JKyO/fqZBNyEuLQkpb2f8XJnck5l5QEPbozHi8hKtmAU
         TI1hm2oCaZFeJWJcGNa2M7v1wdPkrzZba5rsx16SEPv8t3yppKnDwF6N1UdwJn+6qEOS
         FwbIqUAqCC/tU5xvFtwqpg/ah7Ev9JfTynKYQA2yD5lCPQ/AuQ9kJURvaIp8c0s4zjmR
         2sZhCvVTwirtBa8Lf+A3V+xBD1TdjshfB72NMSMtZG6yFPzcaq03P+Reip2bxjrEYpVS
         WuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FfyvWXugls19n5QGes78MZc5as0hWnBXVAGvk5Nfgac=;
        b=02X1jW+J2YmVHwC2ZKy4igdsD/NInTdll9McsGjqqQo3fRqUAwP3CKWx1LJpz4vx5t
         bUF1ZMlv+nltNbJyH2ZhN/PfxB71WlhnhhlO0rofyeZxJS01z1/S0q7aAtTlUODLDU/J
         ybICB1W6wkoPBxk2vmBQIl+n/+QbHVoQVJsNxxK1p6R3Og2ttHMnhBSVxbjhRYwT1UbD
         1Zhpv3rUBW9BDBsQWBLNto1zEp7P32CGiXAL68kVWp3fHROzSCTPRYlm4uWbtWf9Ca+s
         367HgMuyuws8YdJ+z9UYFb9GpwTr4t4bpfUwE6O/YQkJm4xsMmAmCGETgjmEEMwBOJwA
         29pw==
X-Gm-Message-State: AOAM5325ENNBCF97BLnwx9gcXnFBDDaXtDbsZ69yT2J0zEV5LSXcaRyy
        bcpSjFaSUGLc+T9DCn1N19LNzqEfZsVIXiCu9gc=
X-Google-Smtp-Source: ABdhPJw2BR6dDe0s58mpo+4e5DIOgMQCUhwb321n86gjOy67FDR7BcJbpzMfqu1zyCVDP6135mQpymsdgAHXJvnAA8c=
X-Received: by 2002:a05:6e02:1b81:: with SMTP id h1mr675396ili.239.1644015327125;
 Fri, 04 Feb 2022 14:55:27 -0800 (PST)
MIME-Version: 1.0
References: <20220204220435.301896-1-mauricio@kinvolk.io>
In-Reply-To: <20220204220435.301896-1-mauricio@kinvolk.io>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 4 Feb 2022 14:55:16 -0800
Message-ID: <CAEf4Bza+vB-rJD9NNphsU8UbiD06JH9wLzDvX5ZCKnLALSPNpw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: Fix strict mode calculation
To:     =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauricio@kinvolk.io>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Quentin Monnet <quentin@isovalent.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 4, 2022 at 2:05 PM Mauricio V=C3=A1squez <mauricio@kinvolk.io> =
wrote:
>
> The correct formula to get all possible values is
> ((__LIBBPF_STRICT_LAST - 1) * 2 - 1) as stated in
> libbpf_set_strict_mode().
>
> Fixes: 93b8952d223a ("libbpf: deprecate legacy BPF map definitions")
>
> Signed-off-by: Mauricio V=C3=A1squez <mauricio@kinvolk.io>
> ---
>  tools/bpf/bpftool/main.c                     |  6 +++++-
>  tools/testing/selftests/bpf/prog_tests/btf.c | 10 ++++++++--

please split changes to bpftool and separately selftests/bpf (and in
v2 you'll have a separate libbpf patch as well).

>  2 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 9d01fa9de033..c5b27e41d1e9 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -483,8 +483,12 @@ int main(int argc, char **argv)
>                 /* Allow legacy map definitions for skeleton generation.
>                  * It will still be rejected if users use LIBBPF_STRICT_A=
LL
>                  * mode for loading generated skeleton.
> +                *
> +                * __LIBBPF_STRICT_LAST is the last power-of-2 value used=
 + 1, so to
> +                * get all possible values we compensate last +1, and the=
n (2*x - 1)
> +                * to get the bit mask
>                  */
> -               mode =3D (__LIBBPF_STRICT_LAST - 1) & ~LIBBPF_STRICT_MAP_=
DEFINITIONS;
> +               mode =3D ((__LIBBPF_STRICT_LAST - 1) * 2 - 1) & ~LIBBPF_S=
TRICT_MAP_DEFINITIONS;
>                 ret =3D libbpf_set_strict_mode(mode);
>                 if (ret)
>                         p_err("failed to enable libbpf strict mode: %d", =
ret);
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing=
/selftests/bpf/prog_tests/btf.c
> index 14f9b6136794..90d5cd4f504c 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -4533,6 +4533,7 @@ static void do_test_file(unsigned int test_num)
>         struct btf_ext *btf_ext =3D NULL;
>         struct bpf_prog_info info =3D {};
>         struct bpf_object *obj =3D NULL;
> +       enum libbpf_strict_mode mode;
>         struct bpf_func_info *finfo;
>         struct bpf_program *prog;
>         __u32 info_len, rec_size;
> @@ -4560,8 +4561,13 @@ static void do_test_file(unsigned int test_num)
>         has_btf_ext =3D btf_ext !=3D NULL;
>         btf_ext__free(btf_ext);
>
> -       /* temporary disable LIBBPF_STRICT_MAP_DEFINITIONS to test legacy=
 maps */
> -       libbpf_set_strict_mode((__LIBBPF_STRICT_LAST - 1) & ~LIBBPF_STRIC=
T_MAP_DEFINITIONS);
> +       /* temporary disable LIBBPF_STRICT_MAP_DEFINITIONS to test legacy=
 maps
> +        * __LIBBPF_STRICT_LAST is the last power-of-2 value used + 1, so=
 to
> +        * get all possible values we compensate last +1, and then (2*x -=
 1)
> +        * to get the bit mask
> +        */
> +       mode =3D ((__LIBBPF_STRICT_LAST - 1) * 2 - 1) & ~LIBBPF_STRICT_MA=
P_DEFINITIONS
> +       libbpf_set_strict_mode(mode);
>         obj =3D bpf_object__open(test->file);
>         err =3D libbpf_get_error(obj);
>         if (CHECK(err, "obj: %d", err))
> --
> 2.25.1
>
