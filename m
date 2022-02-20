Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 920944BCB62
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 01:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243189AbiBTAmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 19:42:33 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:47348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241815AbiBTAmc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 19:42:32 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 912373B2A7;
        Sat, 19 Feb 2022 16:42:12 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id q11so227229pln.11;
        Sat, 19 Feb 2022 16:42:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5OtJ38Qj62RwZLCcGiYfWZ1y0rTNTwoMvTBrQ3Gxr5w=;
        b=XxS8lrMoDbChrYMWm3EAZFCFYdrM3sNVQ44m49zvmn24lK8yNLzK9y9ZGo6KDvRVno
         wCULMmJoGKnd/XYAfDcK/srCGHtQS8Ohfz2OBnNnPtMify0v1NknHO/hCW+FrvMGm/4Y
         wgPGWP6ZM+B9zbr49Yj47v9AtfSTbDH7y59SJwFl4hPECJJYVmwySze4ajUeZ+jlCdsE
         f2TOlV3zvbgda6/8cqp89vrSTGrD7kn5iFuWTX6jWFyOY37mwYxbP1DBypx0tpqxkFy0
         f1QJeywHpJWnFS8u+xMHvC8I3ySdGTAHo3PjNlvuyEMbFo/I2xfe7aFC2/oTaVIVWlup
         5g+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5OtJ38Qj62RwZLCcGiYfWZ1y0rTNTwoMvTBrQ3Gxr5w=;
        b=vNLC1o4iyiyI3BUz5JfgvLC8O0cZu/rcMp2En+C8K00CuuOmhQV8y7YAejJvSbPXiW
         /mqOCShnITV0zFcW9b4by3dq79auyb9khVmjL96M0f0SzCqiYIl4Svnr+tVMsfyK57a6
         pzbEJ+kKeP9mJ741P4NVixCD5nYezubYpTRfGOD5rlW8KuYfuFoohKcGiyCsrRoAwXhf
         J8K7mHuvwSHY1P33wU2yuNncqKXZDd1u9HaU0D7O4SodEOldvBJ5VbhJH1kWBSpr03iv
         x7li2wh8Aekvejgc+FmAT0IoMGLQSuRITCJENH+bPwWyWV9W6Eyg57eTRU5KtQFt4POw
         GF6g==
X-Gm-Message-State: AOAM530KBgVK+2MswxVeZy0dwSYspcwW2cR1ejAG0JXoW0WbXRxhAYda
        fuebPKKI4J0JZbbMD/3/Tb1HUonJ18c=
X-Google-Smtp-Source: ABdhPJzcTkPAEsmyCfmVu0d+bTdOpxR0Mbo+4BDPq2xo/VhJD95gzBlDVCMgBTwIauaYsCzYYHnQTw==
X-Received: by 2002:a17:902:bf06:b0:14d:8c72:96c6 with SMTP id bi6-20020a170902bf0600b0014d8c7296c6mr13521454plb.156.1645317732034;
        Sat, 19 Feb 2022 16:42:12 -0800 (PST)
Received: from localhost ([2405:201:6014:d0c0:6243:316e:a9e1:adda])
        by smtp.gmail.com with ESMTPSA id y20sm7468979pfi.155.2022.02.19.16.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 19 Feb 2022 16:42:11 -0800 (PST)
Date:   Sun, 20 Feb 2022 06:12:09 +0530
From:   Kumar Kartikeya Dwivedi <memxor@gmail.com>
To:     Souptick Joarder <jrdr.linux@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH] bpf: Initialize ret to 0 inside btf_populate_kfunc_set()
Message-ID: <20220220004209.hlutexplxhvrmpi6@apollo.legion>
References: <20220219163915.125770-1-jrdr.linux@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220219163915.125770-1-jrdr.linux@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 19, 2022 at 10:09:15PM IST, Souptick Joarder wrote:
> From: "Souptick Joarder (HPE)" <jrdr.linux@gmail.com>
>
> Kernel test robot reported below error ->
>
> kernel/bpf/btf.c:6718 btf_populate_kfunc_set()
> error: uninitialized symbol 'ret'.
>
> Initialize ret to 0.
>
> Fixes: 	dee872e124e8 ("bpf: Populate kfunc BTF ID sets in struct btf")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Souptick Joarder (HPE) <jrdr.linux@gmail.com>
> ---

Thanks for the fix.

Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>

>  kernel/bpf/btf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 02d7014417a0..2c4c5dbe2abe 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -6706,7 +6706,7 @@ static int btf_populate_kfunc_set(struct btf *btf, enum btf_kfunc_hook hook,
>  				  const struct btf_kfunc_id_set *kset)
>  {
>  	bool vmlinux_set = !btf_is_module(btf);
> -	int type, ret;
> +	int type, ret = 0;
>
>  	for (type = 0; type < ARRAY_SIZE(kset->sets); type++) {
>  		if (!kset->sets[type])
> --
> 2.25.1
>

--
Kartikeya
