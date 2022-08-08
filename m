Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1B0E58C836
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 14:15:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbiHHMPP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 08:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232482AbiHHMPO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 08:15:14 -0400
Received: from mail-io1-xd41.google.com (mail-io1-xd41.google.com [IPv6:2607:f8b0:4864:20::d41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3597C224;
        Mon,  8 Aug 2022 05:15:12 -0700 (PDT)
Received: by mail-io1-xd41.google.com with SMTP id v185so6890713ioe.11;
        Mon, 08 Aug 2022 05:15:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=2YSzkQhiCchQXC4uTAyjm5H8d8wMrxgvSk96QeBJ5DI=;
        b=IIl/mHz9vy/gmAJl9cQKsBcA+W/Ola5CnvIUopRWAFcdUx8auOg1YxQiy4H7/VkjBr
         a+8iUm0hIpXzG34eaK/RfevXAXR7CvWUIUiMoOLRPp6UVuglMPCelVvy/kebFSzWRHaz
         pQQI3wdZbMnYgnc5TqUiN6a9zqNN11F+aSeqBS62wljctbppB2y8lhJ8pbzkVv7/S/fw
         iPZgKyxSYwzNIEsqgHZxy0FOXvh4QUCjcdCl6a+A2l+f2tR+yt8Zzm1iG6HXjgPZSvv6
         KW1jAOlmszeCHQNGzwAr1Ds5vprgABhaZog3fxOo6/NCiW0IeRVMaB191XMLuchbQ6J/
         BuKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=2YSzkQhiCchQXC4uTAyjm5H8d8wMrxgvSk96QeBJ5DI=;
        b=08/PuBEsE9J2OhslvG0EaV/1ZIhbk+LoV7KvUcLud3dnmURHQOOUSbcHwAHpyKT5jV
         1O7IvrTX59PKsfreMBAIbGInI1hbibcxYpADrCSH3tdPDzxUdRKixPq8xz6xD5PCa3ct
         yawXacqwysCKluL76wcwfzWAb6Nm+mt/LeWR9wCydMOo54EGlXOzouxQFTFtfol7o7U2
         y5lDYWyJsS5TWjeXux4bokYuOWFbVRPS7nLa4drx7WsPTtr3Yo+9hRS6Wu4loYEhJmUu
         l7xIYa+x75889VwQzHUH4p0lM1pj668VwGhJWhquhNp8NjcVYHWozxLG3Rb/kJw9qktO
         8tDA==
X-Gm-Message-State: ACgBeo3vFw+6Ii+XAYSjZl/5NcMdEW20GBZJ1LqsU0uFcO/w6Y/Uja90
        u/98J7ADSWijUrZNfkeYmdt+OwgroCS92HbHzC+Z8RD+
X-Google-Smtp-Source: AA6agR7J0UAM7xQChOLJtBq8rRGZRheEQu4MZidweMAk9sk5n1bHHfjpl5mVYdexgjqzykLhsz9nFgYJ1f3uNKB2cqM=
X-Received: by 2002:a5d:9da5:0:b0:684:a92a:5855 with SMTP id
 ay37-20020a5d9da5000000b00684a92a5855mr2008657iob.18.1659960911526; Mon, 08
 Aug 2022 05:15:11 -0700 (PDT)
MIME-Version: 1.0
References: <20220808094623.387348-1-asavkov@redhat.com> <20220808094623.387348-2-asavkov@redhat.com>
In-Reply-To: <20220808094623.387348-2-asavkov@redhat.com>
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
Date:   Mon, 8 Aug 2022 14:14:33 +0200
Message-ID: <CAP01T76dELOx8p_iky_Py_VcqDbQtaL-4d=zrFiCbFhMdVEmNA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] bpf: add destructive kfunc flag
To:     Artem Savkov <asavkov@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Daniel Vacek <dvacek@redhat.com>,
        Jiri Olsa <olsajiri@gmail.com>, Song Liu <song@kernel.org>,
        Daniel Xu <dxu@dxuuu.xyz>
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

On Mon, 8 Aug 2022 at 11:48, Artem Savkov <asavkov@redhat.com> wrote:
>
> Add KF_DESTRUCTIVE flag for destructive functions. Functions with this
> flag set will require CAP_SYS_BOOT capabilities.
>
> Signed-off-by: Artem Savkov <asavkov@redhat.com>
> ---
>  include/linux/btf.h   | 1 +
>  kernel/bpf/verifier.c | 5 +++++
>  2 files changed, 6 insertions(+)
>
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index cdb376d53238..51a0961c84e3 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -49,6 +49,7 @@
>   * for this case.
>   */
>  #define KF_TRUSTED_ARGS (1 << 4) /* kfunc only takes trusted pointer arguments */
> +#define KF_DESTRUCTIVE  (1 << 5) /* kfunc performs destructive actions */
>

Please also document this flag in Documentation/bpf/kfuncs.rst.

And maybe instead of KF_DESTRUCTIVE, it might be more apt to call this
KF_CAP_SYS_BOOT. While it is true you had a destructive flag for
programs being loaded earlier, so there was a mapping between the two
UAPI and kfunc flags, what it has boiled down to is that this flag
just requires CAP_SYS_BOOT (in addition to other capabilities) during
load. So that name might express the intent a bit better. We might
soon have similar flags encoding requirements of other capabilities on
load.

The flag rename is just a suggestion, up to you.

>  struct btf;
>  struct btf_member;
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 096fdac70165..e52ca1631d3f 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -7584,6 +7584,11 @@ static int check_kfunc_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
>                         func_name);
>                 return -EACCES;
>         }
> +       if (*kfunc_flags & KF_DESTRUCTIVE && !capable(CAP_SYS_BOOT)) {
> +               verbose(env, "destructive kfunc calls require CAP_SYS_BOOT capabilities\n");
> +               return -EACCES;
> +       }
> +
>         acq = *kfunc_flags & KF_ACQUIRE;
>
>         /* Check the arguments */
> --
> 2.37.1
>
