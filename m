Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A139858A246
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 22:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239634AbiHDUmJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 16:42:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235054AbiHDUmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 16:42:08 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEA26D573;
        Thu,  4 Aug 2022 13:42:06 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y13so1322118ejp.13;
        Thu, 04 Aug 2022 13:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=IRiMxNbXrc+JNPj6jAzlN/4D6lsjKm+nRyRjn4MsJWg=;
        b=abpFYpzUFF/Czb5Du5GtOLlV3sZXrSns2VbpUGYCJQ0JDibFZgdL/U37QcxRzO+GIH
         zOYFWFmt3AO8B1j8+4Q2BR08CQ8ll/ZZpN25qERHBiQEq+87H/Yx4bbnvpsN9zeZSLMA
         42eVHNvDQeupN/AGdCE4Af8GklFhOwF1S4/avRBNICFp25XGuKLs6ZSEQ6ss8JSLqcPl
         m2VXl2MQrFGzVaq6M7SomtIIY6REqOxgbRkNz7pvd9n+cNoJPGEF+1dXCn+H860ZqmsG
         FClTlAa9JR7jEGygdGx+e1yh5sLa8ewY0aVdYz0Ze7W8/qH2dJmbpotI+8fxmyAsnVqi
         R/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=IRiMxNbXrc+JNPj6jAzlN/4D6lsjKm+nRyRjn4MsJWg=;
        b=jvkynrh1FfV7SC6ubU09rKI1JFV94HdxZTiQ3yoJkloIB/lU0Wqg7ZxcosBOWcbqyH
         2Y2D1+7+QJbXFg5OFkAVQq5928Esu7TeklBJv3YpmXU3qleCtvgzLObsUC9U20BnzDJ2
         GIGrhU9fvC7teImtd8M0T2xTP9k5L7h36ucEpB4b0tJViMGcrYchyt2xsVTHFNDxtEzw
         rOX9u99YXRU8woRUX+YIf9gbwIjvX+iA3GhRlQH7S+gQr2TPUcWFgdj8jrgW4h84LInd
         FhbaSMKGI0TtQkePCmAKPX9kdoQU63BFQg5FpQkuxITvFFA9hTg/98TV4hw1uT3TO2D1
         UkZg==
X-Gm-Message-State: ACgBeo3nzzvFu0/svBnh1PilGxzgdsyDi5QWG3txpiiciaRAvMpn+IB4
        ib1Y183tOVxNGzUcvBqxXO60We0NfkUo3sM8Eq8=
X-Google-Smtp-Source: AA6agR7KlG2r253Z1TIYojaIng1yQJgrUt/kN+VBpDOWJ778Mq/+M/SMM69rh1+T+mQ0y7YkK3ZSiNWZgik8omsHzxM=
X-Received: by 2002:a17:907:971c:b0:72b:83d2:aa7a with SMTP id
 jg28-20020a170907971c00b0072b83d2aa7amr2629773ejc.633.1659645725255; Thu, 04
 Aug 2022 13:42:05 -0700 (PDT)
MIME-Version: 1.0
References: <20220802091030.3742334-1-asavkov@redhat.com> <20220802091030.3742334-3-asavkov@redhat.com>
In-Reply-To: <20220802091030.3742334-3-asavkov@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 4 Aug 2022 13:41:53 -0700
Message-ID: <CAADnVQL7GH0MBhjTHA2xWXVzkDgdzk4RS9qS+DJ1+t1T8NkYxA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: export crash_kexec() as destructive kfunc
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 2, 2022 at 2:10 AM Artem Savkov <asavkov@redhat.com> wrote:
>
> Allow properly marked bpf programs to call crash_kexec().
>
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  kernel/kexec_core.c | 21 +++++++++++++++++++++
>  1 file changed, 21 insertions(+)
>
> diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
> index 4d34c78334ce..9259ea3bd693 100644
> --- a/kernel/kexec_core.c
> +++ b/kernel/kexec_core.c
> @@ -39,6 +39,8 @@
>  #include <linux/hugetlb.h>
>  #include <linux/objtool.h>
>  #include <linux/kmsg_dump.h>
> +#include <linux/btf.h>
> +#include <linux/btf_ids.h>
>
>  #include <asm/page.h>
>  #include <asm/sections.h>
> @@ -1238,3 +1240,22 @@ void __weak arch_kexec_protect_crashkres(void)
>
>  void __weak arch_kexec_unprotect_crashkres(void)
>  {}
> +
> +#ifdef CONFIG_DEBUG_INFO_BTF_MODULES
> +BTF_SET8_START(kexec_btf_ids)
> +BTF_ID_FLAGS(func, crash_kexec, KF_DESTRUCTIVE)
> +BTF_SET8_END(kexec_btf_ids)
> +
> +static const struct btf_kfunc_id_set kexec_kfunc_set = {
> +       .owner = THIS_MODULE,
> +       .set   = &kexec_btf_ids,
> +};
> +
> +static int __init crash_kfunc_init(void)
> +{
> +       register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &kexec_kfunc_set);
> +       return 0;
> +}
> +
> +subsys_initcall(crash_kfunc_init);
> +#endif

It feels there will be a bunch of such boiler plate code
in different .c files in many places in the kernel
if we go with this approach.

Maybe we should do one call:
register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING
from kernel/bpf/helper.c
to register all tracing kfuncs ?

And gate
BTF_ID_FLAGS(func, crash_kexec, KF_DESTRUCTIVE)
with #ifdef CONFIG_KEXEC_CORE.

We have such a pattern in verifier.c already.
