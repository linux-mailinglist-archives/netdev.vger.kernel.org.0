Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC279659270
	for <lists+netdev@lfdr.de>; Thu, 29 Dec 2022 23:26:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiL2W0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Dec 2022 17:26:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbiL2W0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Dec 2022 17:26:14 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC6688FCD;
        Thu, 29 Dec 2022 14:26:12 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id m18so47804656eji.5;
        Thu, 29 Dec 2022 14:26:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bPQ4CG/cVtxFs2x9LIO1J6ozySqDuqSy18Lu83XUFok=;
        b=dDXj1t1d4H+9520aMzYAjhSu3HpvSWrOw9i3YsG77Ph0uWCmub0yAAHfAtabx16jRF
         ptW6mlNkLWUwrjmeuupzd7Tolhkx5ULqDTlo771on4bXUw/Y3e9/07YTKZ7WFjvZmWNm
         7+FbHlKA2mJ59dGzRrwNqZFIXTS/ICLiM/0AN5ELguVSFfQDalVhN/fZi//ZbzceCWf4
         83ZMVslHmrZpR9tWrco700yfUi23vP9LrRZyebzrJ4FK/36tDYmyM7FPQ967waAjniVW
         yfDYurl20ChaiTwgE7RSSboBlNNmu1YFK1UUxq8NckyO1Inu7dpLsX+NXO4JtJfbvT1y
         sQNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bPQ4CG/cVtxFs2x9LIO1J6ozySqDuqSy18Lu83XUFok=;
        b=hM01SJF2+aQgylN11A8gOO9+YEgTZFL7HeI4XGs8NxbJ7fHLe7sooni9244Lt9oWXF
         ou8JAm2U/C96eZ0aHOejPv9Fj7f5VUfEKIix14Rw2qVkGkekNQ9/3iywFNnebblrYiVf
         Dnuuyj/k7xZEsnm8eILWqhXQ0v+OxvDFr4yPyK8RpEB5+cg64USZ394CysWRNxbfbTZG
         sfVJODFXWWv/HQ10RKKmFNyNwCwDhyhKoDz4XMcdfMR0ZxkpQE7flrW22Z4ZO1cd9ATd
         eI3MWMuL93UhKBAE9YmxXTu5++vsdybH9F/lIjVEnxG6wgIJSSbjtNEUK/x0Er+768C/
         Ufug==
X-Gm-Message-State: AFqh2kpib2RoJPrbGMllOEQltTczKj5P7GmwocVvKrCEAX9Ge8hxSP+I
        3RCow302PZ7WAva/JbNZllI7Xbg5vWLL86YgkRc=
X-Google-Smtp-Source: AMrXdXu/EquhD4z9LM92sj8iy7+bh/KYt7nhA0v8xq9TRp4mwb5XHRqKgooe+OGRLhhvtHZZ864MZGMJcx2kKjNXhbI=
X-Received: by 2002:a17:906:2ccc:b0:7f3:3b2:314f with SMTP id
 r12-20020a1709062ccc00b007f303b2314fmr2336906ejr.115.1672352771512; Thu, 29
 Dec 2022 14:26:11 -0800 (PST)
MIME-Version: 1.0
References: <20221224071527.2292-1-danieltimlee@gmail.com> <20221224071527.2292-7-danieltimlee@gmail.com>
In-Reply-To: <20221224071527.2292-7-danieltimlee@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 29 Dec 2022 14:25:59 -0800
Message-ID: <CAEf4BzYiFwFj5tLoi7j0wg1-KtyHTCsNOVtbXaR1JTzoH1LHyA@mail.gmail.com>
Subject: Re: [bpf-next v3 6/6] libbpf: fix invalid return address register in s390
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        bpf@vger.kernel.org, netdev@vger.kernel.org
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

On Fri, Dec 23, 2022 at 11:15 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> There is currently an invalid register mapping in the s390 return
> address register. As the manual[1] states, the return address can be
> found at r14. In bpf_tracing.h, the s390 registers were named
> gprs(general purpose registers). This commit fixes the problem by
> correcting the mistyped mapping.
>
> [1]: https://uclibc.org/docs/psABI-s390x.pdf#page=14
>
> Fixes: 3cc31d794097 ("libbpf: Normalize PT_REGS_xxx() macro definitions")
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
>  tools/lib/bpf/bpf_tracing.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/lib/bpf/bpf_tracing.h b/tools/lib/bpf/bpf_tracing.h
> index 2972dc25ff72..9c1b1689068d 100644
> --- a/tools/lib/bpf/bpf_tracing.h
> +++ b/tools/lib/bpf/bpf_tracing.h
> @@ -137,7 +137,7 @@ struct pt_regs___s390 {
>  #define __PT_PARM3_REG gprs[4]
>  #define __PT_PARM4_REG gprs[5]
>  #define __PT_PARM5_REG gprs[6]
> -#define __PT_RET_REG grps[14]
> +#define __PT_RET_REG gprs[14]

oh, wow, what a typo. Thanks for fixing this! Applied patch set to bpf-next.

>  #define __PT_FP_REG gprs[11]   /* Works only with CONFIG_FRAME_POINTER */
>  #define __PT_RC_REG gprs[2]
>  #define __PT_SP_REG gprs[15]
> --
> 2.34.1
>
