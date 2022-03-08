Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6A44D0D83
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 02:30:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245329AbiCHBbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 20:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234504AbiCHBbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 20:31:49 -0500
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17C9ABCAE;
        Mon,  7 Mar 2022 17:30:54 -0800 (PST)
Received: by mail-io1-xd2e.google.com with SMTP id q11so4693525iod.6;
        Mon, 07 Mar 2022 17:30:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ftWOPeuHK1TC5pvYB+4M9RHPfIBUPNyVAd6l0pcXX2g=;
        b=SB89zb3PQDxATQT7Ea7gk5rnEsht5EXi+pPqXEmEf9kJrNhPomEZ9CqiBoUlDF+6op
         730uAYt4EH5iIqKa2FZEgP7OEzhy4gBo4qkVtODg7hTMZ1vIKMBDXaE/+Ctq5JdNRn4S
         T2iA/zbrcZde2HFIewe7M58Rovb6QqEzMLSx2JN9AbhG9MKnvItYXtkBEmBKwi8fKkym
         oh0SBWbnQIwGN4E3/PI8O9BByfDjEsL/7W+IcJ6thLoIXMoA1BWD+sLVhGd9F6UZyMgG
         d9p1+JGoabyNHXSUMeP3lvVsunJkuvk9G4UmwtHE5NSrI/7A8EuUuJEPcdmh6+FNNYDv
         AhGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ftWOPeuHK1TC5pvYB+4M9RHPfIBUPNyVAd6l0pcXX2g=;
        b=auIVW6jdkt3tuT9d7bOilG1WKvAhC7fQn4vpk8ESsxelEHXj9YG4UehvrnkAMk5k/5
         UE0RFN84Q7hNIocw+0RuDyP0MVA9RCG3SrdiHDm5NlRWEJ7+3NaYmaykW8yleYuKlg43
         8XU3QjZl+c25nSwOHrP6iJqWZ7VnMCdcpTOVGa0uN0rjqFgjIuRLqq9nGj+LfKs7xF+5
         X1chGmw+/a67Yyods6Glq1hvy3Fb7voDtjjrpqJRi98poyzTS5B+Z5nCUub6jdy4Ya9K
         ftXhoLcL5qU3tet51mgq5S0xNpM2+JbUy9iYNgeQf3Sb9MuMLE+gCaIgCRZlmJDgUmoV
         I1+w==
X-Gm-Message-State: AOAM533YLr0PoYrFs3Fe2MB2heKOC4OJsKtj0HaWuKFA5HpklobUPvWJ
        RKf+PuizpfEYetckmZ9ir2t4oM0z5FRK9wMI5u0=
X-Google-Smtp-Source: ABdhPJzreixvrFJjVqO1BfS+PqFe/E26XD9xYKeRWSVd1JR1X9w5MMjyFx+6SSMadxXZ97YEZLmzCqjpkUqo9FJJJq8=
X-Received: by 2002:a5d:948a:0:b0:645:b742:87c0 with SMTP id
 v10-20020a5d948a000000b00645b74287c0mr9000261ioj.79.1646703053408; Mon, 07
 Mar 2022 17:30:53 -0800 (PST)
MIME-Version: 1.0
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com> <20220304172852.274126-5-benjamin.tissoires@redhat.com>
In-Reply-To: <20220304172852.274126-5-benjamin.tissoires@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 7 Mar 2022 17:30:42 -0800
Message-ID: <CAEf4BzZa8sP4QzEgi4T4L1_tz9D8gNNvjeQt3J0hrV6kq8NfUQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 04/28] libbpf: add HID program type and API
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
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

On Fri, Mar 4, 2022 at 9:31 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> HID-bpf program type are needing a new SEC.
> To bind a hid-bpf program, we can rely on bpf_program__attach_fd()
> so export a new function to the API.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> changes in v2:
> - split the series by bpf/libbpf/hid/selftests and samples
> ---
>  tools/lib/bpf/libbpf.c   | 7 +++++++
>  tools/lib/bpf/libbpf.h   | 2 ++
>  tools/lib/bpf/libbpf.map | 1 +
>  3 files changed, 10 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
> index 81bf01d67671..356bbd3ad2c7 100644
> --- a/tools/lib/bpf/libbpf.c
> +++ b/tools/lib/bpf/libbpf.c
> @@ -8680,6 +8680,7 @@ static const struct bpf_sec_def section_defs[] = {
>         SEC_DEF("cgroup/setsockopt",    CGROUP_SOCKOPT, BPF_CGROUP_SETSOCKOPT, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
>         SEC_DEF("struct_ops+",          STRUCT_OPS, 0, SEC_NONE),
>         SEC_DEF("sk_lookup",            SK_LOOKUP, BPF_SK_LOOKUP, SEC_ATTACHABLE | SEC_SLOPPY_PFX),
> +       SEC_DEF("hid/device_event",     HID, BPF_HID_DEVICE_EVENT, SEC_ATTACHABLE_OPT | SEC_SLOPPY_PFX),

no SEC_SLOPPY_PFX for any new program type, please


>  };
>
>  #define MAX_TYPE_NAME_SIZE 32
> @@ -10659,6 +10660,12 @@ static struct bpf_link *attach_iter(const struct bpf_program *prog, long cookie)
>         return bpf_program__attach_iter(prog, NULL);
>  }
>
> +struct bpf_link *
> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd)
> +{
> +       return bpf_program__attach_fd(prog, hid_fd, 0, "hid");
> +}
> +
>  struct bpf_link *bpf_program__attach(const struct bpf_program *prog)
>  {
>         if (!prog->sec_def || !prog->sec_def->attach_fn)
> diff --git a/tools/lib/bpf/libbpf.h b/tools/lib/bpf/libbpf.h
> index c8d8daad212e..f677ac0a9ede 100644
> --- a/tools/lib/bpf/libbpf.h
> +++ b/tools/lib/bpf/libbpf.h
> @@ -529,6 +529,8 @@ struct bpf_iter_attach_opts {
>  LIBBPF_API struct bpf_link *
>  bpf_program__attach_iter(const struct bpf_program *prog,
>                          const struct bpf_iter_attach_opts *opts);
> +LIBBPF_API struct bpf_link *
> +bpf_program__attach_hid(const struct bpf_program *prog, int hid_fd);
>
>  /*
>   * Libbpf allows callers to adjust BPF programs before being loaded
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 47e70c9058d9..fdc6fa743953 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -424,6 +424,7 @@ LIBBPF_0.6.0 {
>  LIBBPF_0.7.0 {
>         global:
>                 bpf_btf_load;
> +               bpf_program__attach_hid;

should go into 0.8.0

>                 bpf_program__expected_attach_type;
>                 bpf_program__log_buf;
>                 bpf_program__log_level;
> --
> 2.35.1
>
