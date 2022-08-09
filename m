Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E1A458DD76
	for <lists+netdev@lfdr.de>; Tue,  9 Aug 2022 19:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244626AbiHIRtD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Aug 2022 13:49:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233963AbiHIRtC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Aug 2022 13:49:02 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B3F3237D2;
        Tue,  9 Aug 2022 10:49:01 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id a7so23547319ejp.2;
        Tue, 09 Aug 2022 10:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FrHzlixcS1FrSu9iA6VWLEjUzH4K4SCNdB82J7P9I/I=;
        b=OSubONaK/J343gxVF4lFuOplXjLk5hLPnbz1r0dnlzwS0KIHNtaTcs/DhUzBCip1GC
         cDq6EciZP0ICzJSoSQ+pJBkd2AB+pPu7V+n5FSXm2gWA19KAvkGNytIPUzfl/Ny6vxyh
         QYt8UDX1zBmxqJl6SAV/1AsE6jFFHSwy7quxRGKkAFEvc3NGJIk15W/uB4cu69X6beWG
         x/PRTBPNC1udHeBhJ7a+4rC+JlxLiJYjJm48QV2S5qz3gyZffjMdBRY8yZbmTCpFB0D5
         1dJjfvFMY3IpsCm00oOkkc4eny6//rNj7GjVm732f750sxr18hIOVFF8F5JlMo3ydMz1
         aWQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FrHzlixcS1FrSu9iA6VWLEjUzH4K4SCNdB82J7P9I/I=;
        b=MtcAzIrsgIr46Z/0t5IVKlof+pSBTfJdcQLybhLctHWieIE/wTrMpji11ZDtNWqzVY
         os1DMbrDMN9LfrkPeeC/96urnfQEGwzdsC88TGGvyN7KxNbYc9ek7h4+323rvLfrNjB+
         GGvnHLmnsAZ9PQLNBNz63TYAbZT+nQnpXtteCWDlhJengIBf3dZG7okqP1Njkdg3l7x0
         T1ICPBbvZEAuJvogtI1t8yy/qrMuMbouwi4il+vxEqNX0EO756BXfLJIDzqBxUChUJQg
         hXXiDf8tIQ6CWK7SDXxcW1AgRU5fMAvifderzbfZCYromfyB4huRBIJG3xeINTxP6cHU
         orLQ==
X-Gm-Message-State: ACgBeo0D8kA+iju7aC3mcVpMUVtYjRsagNwL8I1YWvWrD6UlQYHI9l+R
        nJtfi0WAuP2MoYhpqcMidT9i7+WCntiXbHW19ZI=
X-Google-Smtp-Source: AA6agR5Y+K1O7OP168yNU1SaAfCHyiXzxJw8I+spUd0Mqp3fh+qgK5QKAu1yxh0w8txty31WvQIbYU7BOGvwYmhjeY4=
X-Received: by 2002:a17:907:7b94:b0:731:1b11:c241 with SMTP id
 ne20-20020a1709077b9400b007311b11c241mr12654037ejc.676.1660067339882; Tue, 09
 Aug 2022 10:48:59 -0700 (PDT)
MIME-Version: 1.0
References: <20220809105317.436682-1-asavkov@redhat.com> <20220809105317.436682-3-asavkov@redhat.com>
In-Reply-To: <20220809105317.436682-3-asavkov@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 9 Aug 2022 10:48:48 -0700
Message-ID: <CAADnVQKgOR0L0thz6HbkL1x7mwc4eSRHftwsrzE9AxufyGBYZg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/3] bpf: export crash_kexec() as destructive kfunc
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Tue, Aug 9, 2022 at 3:53 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> Allow properly marked bpf programs to call crash_kexec().
>
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  kernel/bpf/helpers.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
> index 1f961f9982d2..103dbddff41f 100644
> --- a/kernel/bpf/helpers.c
> +++ b/kernel/bpf/helpers.c
> @@ -1711,3 +1711,24 @@ bpf_base_func_proto(enum bpf_func_id func_id)
>                 return NULL;
>         }
>  }
> +
> +BTF_SET8_START(tracing_btf_ids)
> +#ifdef CONFIG_KEXEC_CORE
> +BTF_ID_FLAGS(func, crash_kexec, KF_DESTRUCTIVE)
> +#endif
> +BTF_SET8_END(tracing_btf_ids)
> +
> +static const struct btf_kfunc_id_set tracing_kfunc_set = {
> +       .owner = THIS_MODULE,
> +       .set   = &tracing_btf_ids,
> +};
> +
> +static int __init kfunc_init(void)
> +{
> +       if (register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &tracing_kfunc_set))
> +               pr_warn("failed to register kfunc id set for BPF_PROG_TYPE_TRACING\n");

Please drop pr_warn. We don't have it in all other
places where we do registration.
