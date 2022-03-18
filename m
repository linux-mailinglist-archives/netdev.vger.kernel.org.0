Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55C0B4DE2E0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 21:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235587AbiCRUwq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 16:52:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240855AbiCRUwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 16:52:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F18A1162A7;
        Fri, 18 Mar 2022 13:51:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE6D160C0D;
        Fri, 18 Mar 2022 20:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54A3AC36AED;
        Fri, 18 Mar 2022 20:51:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647636682;
        bh=+NTtQb4p/kuYp+V4YKsTlmDKNgCo9xfxoasrL2qS+WY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=tonB/N6VpNML0FUXFIKgIKd93Z5sx16IMrid6XS6lXScCx2xUCYRh0S1UuBQqlV2Y
         oY41QgJ7IFIrwtacaKQc4nJhNSNdWrMLQxo7QvLF1eQTQnb+uz4vWb5h6sc5t8m7Sp
         af1CcPyBDGjTHzRBm4lwxyp8oVzUXZpzLHMyYy1lugCwssW+kvcwrMBIYZ/2tLFBel
         JzqqR7QPYVHNjoIMUKNPpTvZdVHHdGyQHO7bWM90aOmV/GMxihSn2mtqnjBG2ONCLb
         LIr8k00tW1RAXdaBkGtpAyKFeYI/EGo6ZDJtg9BqdWiMTO8gvZ0K5sdhp00M48m2vw
         5omyPQKseaRyg==
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-2e592e700acso103521077b3.5;
        Fri, 18 Mar 2022 13:51:22 -0700 (PDT)
X-Gm-Message-State: AOAM531+bGI9tQW83Lb+tIN1Aru13n7QzqbDquVgX9eaMAiiAgQOgfWF
        akXZuqfZlZ6qp51mpRETNeij3UDanLkLCU6cg2o=
X-Google-Smtp-Source: ABdhPJwqtnRnTFFnk3TYLZfrYxozXwxl87N3c9z2yIcAQ06zIU0vK1q7PNEiwS2VQmPFT1dCp+b1UnzwpaaFwtVbYVQ=
X-Received: by 2002:a81:79d5:0:b0:2e5:9d33:82ab with SMTP id
 u204-20020a8179d5000000b002e59d3382abmr13272599ywc.460.1647636681268; Fri, 18
 Mar 2022 13:51:21 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-4-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-4-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 13:51:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5+2h9S_xnAY104frBpqhKYQk2wqc3Cp1fucNsHXwvVNQ@mail.gmail.com>
Message-ID: <CAPhsuW5+2h9S_xnAY104frBpqhKYQk2wqc3Cp1fucNsHXwvVNQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 03/17] bpf/verifier: prevent non GPL programs
 to be loaded against HID
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
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 9:16 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> This is just to hammer the obvious because I suspect you can not already
> load a bpf HID program which is not GPL because all of the useful
> functions are GPL only.
>
> Anyway, this ensures that users are not tempted to bypass this requirement
> and will allow us to ship tested BPF programs in the kernel without having
> to aorry about the license.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>

Acked-by: Song Liu <songliubraving@fb.com>


>
> ---
>
> no changes in v3
>
> new in v2:
>  - Note: I placed this statement in check_attach_btf_id() to be local to
>    other similar checks (regarding LSM), however, I have no idea if this
>    is the correct place. Please shout at me if it isn't.
> ---
>  include/linux/bpf-hid.h |  8 ++++++++
>  kernel/bpf/hid.c        | 12 ++++++++++++
>  kernel/bpf/verifier.c   |  7 +++++++
>  3 files changed, 27 insertions(+)
>
> diff --git a/include/linux/bpf-hid.h b/include/linux/bpf-hid.h
> index 9c8dbd389995..7f596554fe8c 100644
> --- a/include/linux/bpf-hid.h
> +++ b/include/linux/bpf-hid.h
> @@ -2,6 +2,7 @@
>  #ifndef _BPF_HID_H
>  #define _BPF_HID_H
>
> +#include <linux/bpf_verifier.h>
>  #include <linux/mutex.h>
>  #include <uapi/linux/bpf.h>
>  #include <uapi/linux/bpf_hid.h>
> @@ -69,6 +70,8 @@ int bpf_hid_prog_query(const union bpf_attr *attr,
>                        union bpf_attr __user *uattr);
>  int bpf_hid_link_create(const union bpf_attr *attr,
>                         struct bpf_prog *prog);
> +int bpf_hid_verify_prog(struct bpf_verifier_log *vlog,
> +                       const struct bpf_prog *prog);
>  #else
>  static inline int bpf_hid_prog_query(const union bpf_attr *attr,
>                                      union bpf_attr __user *uattr)
> @@ -81,6 +84,11 @@ static inline int bpf_hid_link_create(const union bpf_attr *attr,
>  {
>         return -EOPNOTSUPP;
>  }
> +static inline int bpf_hid_verify_prog(struct bpf_verifier_log *vlog,
> +                                     const struct bpf_prog *prog)
> +{
> +       return -EOPNOTSUPP;
> +}
>  #endif
>
>  static inline bool bpf_hid_link_empty(struct bpf_hid *bpf,
> diff --git a/kernel/bpf/hid.c b/kernel/bpf/hid.c
> index c21dc05f6207..2dfeaaa8a83f 100644
> --- a/kernel/bpf/hid.c
> +++ b/kernel/bpf/hid.c
> @@ -34,6 +34,18 @@ void bpf_hid_set_hooks(struct bpf_hid_hooks *hooks)
>  }
>  EXPORT_SYMBOL_GPL(bpf_hid_set_hooks);
>
> +int bpf_hid_verify_prog(struct bpf_verifier_log *vlog,
> +                       const struct bpf_prog *prog)
> +{
> +       if (!prog->gpl_compatible) {
> +               bpf_log(vlog,
> +                       "HID programs must have a GPL compatible license\n");
> +               return -EINVAL;
> +       }
> +
> +       return 0;
> +}
> +
>  BPF_CALL_3(bpf_hid_get_data, struct hid_bpf_ctx_kern*, ctx, u64, offset, u64, size)
>  {
>         if (!size)
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index cf92f9c01556..da06d633fb8d 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -21,6 +21,7 @@
>  #include <linux/perf_event.h>
>  #include <linux/ctype.h>
>  #include <linux/error-injection.h>
> +#include <linux/bpf-hid.h>
>  #include <linux/bpf_lsm.h>
>  #include <linux/btf_ids.h>
>
> @@ -14272,6 +14273,12 @@ static int check_attach_btf_id(struct bpf_verifier_env *env)
>         if (prog->type == BPF_PROG_TYPE_STRUCT_OPS)
>                 return check_struct_ops_btf_id(env);
>
> +       if (prog->type == BPF_PROG_TYPE_HID) {
> +               ret = bpf_hid_verify_prog(&env->log, prog);
> +               if (ret < 0)
> +                       return ret;
> +       }
> +
>         if (prog->type != BPF_PROG_TYPE_TRACING &&
>             prog->type != BPF_PROG_TYPE_LSM &&
>             prog->type != BPF_PROG_TYPE_EXT)
> --
> 2.35.1
>
