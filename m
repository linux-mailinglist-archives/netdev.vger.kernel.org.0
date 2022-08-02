Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 91F0F587AFD
	for <lists+netdev@lfdr.de>; Tue,  2 Aug 2022 12:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236552AbiHBKq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Aug 2022 06:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236615AbiHBKqv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Aug 2022 06:46:51 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEDBD1C90C;
        Tue,  2 Aug 2022 03:46:45 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id s11so5661506edd.13;
        Tue, 02 Aug 2022 03:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc;
        bh=wNgs28xMH7P4/J+xTsAzXIZ/DZk8ZXnVD1xPtOOGx20=;
        b=gMb9guQnlNxv2nBW81Awg+qz7xg4fC2pZ4hXvsUIRLA3UpnujXG5CWujpTmNRW8NG2
         nUl2D97j92jf5UJsM1HPCNyiJyQuQ32j9XPAaQ2x5iqP1DmWaXxPBX4B4JSyoFZMz8TW
         iBaxTR2Pzm8bCbZQx0XJcaH9i5MqjxuPqd0bduqhwZI+8sHnv8XDFeYx9oLX+SDJAYVA
         czbDRa7rpv5qDDx2Ri6LiKTiQmw5HOuUmcUaznGuPmYeylBvUNWfQIparhcxPwzrVgrh
         HvTT9WfDx8kh27R5EoOK6zOC/anVurAwBY3OAv7P87XRQ4dEiEkZR4cQzoCceEg7pEq1
         bPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-message-state:from:to:cc;
        bh=wNgs28xMH7P4/J+xTsAzXIZ/DZk8ZXnVD1xPtOOGx20=;
        b=nNFX/A0giZH6o39v5NcCH5vfs5+twoA6Bmd+SjKHiMSQdW2ru3CPYNFxs5I8SU5hhO
         y7984sTFi0uXHkkMRtJ5AzMfetXijy9L7i+3JKu/7zyvlH7e1eMalN1cZCqjWtzm/aFC
         jXC+MykVBl5gIR5BzaTlX3dIr9Sh7IzdgpIzz+8kNNIZ5EkRmSUNQmjskzgaVD5GhAiZ
         CoRTP4U3nt6twuos4OqMKt43jUui0kNPJygnOxXAoeuCgFBR3G6P5J8JOk31W05N1Q1x
         vPZzlfD58YqtjT0mDPjbSgK+y/8epKnixJ6h5vxY7UFji606y7g1PNyrjfCOIeAI4Ymv
         gZUA==
X-Gm-Message-State: AJIora/1zuNC+PzbA1yqTXFgFTem0AgIpBN1QDYz9bdqly0DECH/ji/A
        flByE/oGIo5xYvpFukEPhBI=
X-Google-Smtp-Source: AGRyM1svDMO+CdTJ5bAkviJbK3yVZQCsSYk79YJLI0KQSkoDd72FEj30ifZDlTb+/Rf7uK0rkW6anA==
X-Received: by 2002:a50:fc89:0:b0:43c:bf1e:165d with SMTP id f9-20020a50fc89000000b0043cbf1e165dmr19509348edq.161.1659437204127;
        Tue, 02 Aug 2022 03:46:44 -0700 (PDT)
Received: from krava ([83.240.61.12])
        by smtp.gmail.com with ESMTPSA id j8-20020aa7ca48000000b0043bbbaa323dsm8159064edt.0.2022.08.02.03.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 03:46:43 -0700 (PDT)
From:   Jiri Olsa <olsajiri@gmail.com>
X-Google-Original-From: Jiri Olsa <jolsa@kernel.org>
Date:   Tue, 2 Aug 2022 12:46:42 +0200
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
Subject: Re: [PATCH bpf-next v2 2/3] bpf: export crash_kexec() as destructive
 kfunc
Message-ID: <YukAkjqdAqr9x2Bs@krava>
References: <20220802091030.3742334-1-asavkov@redhat.com>
 <20220802091030.3742334-3-asavkov@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220802091030.3742334-3-asavkov@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 02, 2022 at 11:10:29AM +0200, Artem Savkov wrote:
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
> +	.owner = THIS_MODULE,
> +	.set   = &kexec_btf_ids,
> +};
> +
> +static int __init crash_kfunc_init(void)
> +{
> +	register_btf_kfunc_id_set(BPF_PROG_TYPE_TRACING, &kexec_kfunc_set);
> +	return 0;

should we do 'return register_btf_kfunc_id_set(...' in here?

jirka

> +}
> +
> +subsys_initcall(crash_kfunc_init);
> +#endif
> -- 
> 2.35.3
> 
