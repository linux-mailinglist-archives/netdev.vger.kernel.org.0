Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 111934ACEE1
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 03:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345851AbiBHCZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 21:25:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237161AbiBHCZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 21:25:03 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D5C4C061355;
        Mon,  7 Feb 2022 18:25:02 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id v74so16327533pfc.1;
        Mon, 07 Feb 2022 18:25:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3G8YOrqUzsTlTI15DjqXBpfXvuVK4sljmpP/LCYK0/c=;
        b=GKp8kmConophuOANe8xofD+H2P2IqqDnxQizstMBgT0mr/zpm60aXgXA8V1i5SAeqL
         dIDZrsbqoR9AefzAXd6Hp66IXV/+TwMoBRhU4Su3Cw9CQK7XdIxe1QP4BWXYX9PiyAw2
         g7C6F6iH+vjdF6LYsV+ZoSnczw9obqXHFMltm9okJCQd0RLUwPJEYhdWz5uxOxIpQ4km
         pG+WqJ9o9JQIGj3C3ihPSvLodMFu5B8GvMnoknE6gywFFKsXbCemNGNrAWPxSfytb3Gd
         Zmqy9+6XTT7rR/dFbOwkvOsyaK5UtiDqpeB3EXVV7PyrpSEVhI1Zi++4lSxMsT0NcV46
         sRWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3G8YOrqUzsTlTI15DjqXBpfXvuVK4sljmpP/LCYK0/c=;
        b=FoL2cjFufeBwFi7RI9MhOwW511LR6qo1J0CfItAG+jRWxoDo3X5td+t45ALZNBVnPC
         CR9ppPaK7cU3gYP79j78POxNdHllZECwgIzBm/fcLsfm37bYTa/licbq564h4k5Yi3yV
         Wu3bfHKonCLq+f0/5PrRVZ70nw2yFRFAxWuaavULKIcFfqtCDTQwGvy9IXpb5fdsGt+B
         hGRH88Zcwa03m4vmzy7vbLLjYqacAYtHNRbEQx3dsITq2OoY5NrBp3qhDJNMALU3UVyQ
         SspPY+/EGaw+FN0qC5yEtYz0AMmPNw9+TCe70D+pK65iSEEnA/UJzNxIh+SEed3WcUYD
         huwQ==
X-Gm-Message-State: AOAM533rbQfl+h1Nt8Fk+oytMi/0rQGQmZai3ddVyzrqxTWzTAyXd2nq
        oDIi4Mncp6GbGUGIUi1hKGWIECpYV28=
X-Google-Smtp-Source: ABdhPJy8CYGVawYIbkv74vc6JHLYnnU8a072YR+KP4Up6fIjNVfCZYvscLQgDmFdi4FGxqNp/9kzRw==
X-Received: by 2002:a05:6a00:1a50:: with SMTP id h16mr2254023pfv.74.1644287101863;
        Mon, 07 Feb 2022 18:25:01 -0800 (PST)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:b5e4])
        by smtp.gmail.com with ESMTPSA id t24sm13588334pfg.92.2022.02.07.18.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 18:25:01 -0800 (PST)
Date:   Mon, 7 Feb 2022 18:24:59 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, kernel-team@fb.com, peterz@infradead.org,
        x86@kernel.org, iii@linux.ibm.com, Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v9 bpf-next 9/9] bpf, x86_64: use
 bpf_jit_binary_pack_alloc
Message-ID: <20220208022459.ufooz7cjbk6u3k6o@ast-mbp.dhcp.thefacebook.com>
References: <20220204185742.271030-1-song@kernel.org>
 <20220204185742.271030-10-song@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220204185742.271030-10-song@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 10:57:42AM -0800, Song Liu wrote:
>  	if (image) {
>  		if (!prog->is_func || extra_pass) {
> +			/*
> +			 * bpf_jit_binary_pack_finalize fails in two scenarios:
> +			 *   1) header is not pointing to proper module memory;
> +			 *   2) the arch doesn't support bpf_arch_text_copy().
> +			 *
> +			 * Both cases are serious bugs that we should not continue.
> +			 */
> +			BUG_ON(bpf_jit_binary_pack_finalize(prog, header, rw_header));
>  			bpf_tail_call_direct_fixup(prog);
> -			bpf_jit_binary_lock_ro(header);

BUG_ON is discouraged.
It should only be used when the kernel absolutely cannot continue.
Here ro/rw_headers will be freed. We can WARN and goto out_addrs without drama.
Please send a follow up.

The rest looks great. Applied to bpf-next.
