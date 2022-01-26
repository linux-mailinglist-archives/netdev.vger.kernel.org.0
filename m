Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B3D549C6C4
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 10:46:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232146AbiAZJqV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 04:46:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232073AbiAZJqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 04:46:21 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA1E5C061744
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 01:46:20 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id o12so18499011lfg.12
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 01:46:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LpTaU2Ptr8MQ/wN++pzUGfYSFa+pffVDK7J691el+xI=;
        b=yMvK6vPPbGBnuLsvGBBDXyTE2AbQ4G1HcCUAjxDkxfT8BG+8bRZBDWCRIzxqaIVOCO
         NYBVPjfpPcFa+ZCUk6/uuRfnFi0AV2lJzlHLSCzXCLqFJaaZME0SIO5SgQcitMs4E23r
         ciPEfJVik7FUyYExCFSqmXAgN0+y+ecIexyG4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LpTaU2Ptr8MQ/wN++pzUGfYSFa+pffVDK7J691el+xI=;
        b=5KGbI/5Y2bMzr8aiXSHVv6jRNEKjlrauRL7VihSg0yH0Pd0Bzi9ZXrJS/Y4RFn6P+J
         j76QVX+FXZuoZcUrS1pYHhOnnJTIc68nS6dorTqEUFOSm2IBf2tEZMWAdC40Alw35QLt
         4rpwY5btxgM/fQmewXkwE5Vfhj6ROeCYGzqQryUxzBAuNl5NMBOw134fKRQaLKWf50ie
         jmlPEYrydrRyfIDz1PeBNV8bFJ8GA65PToA8DrQeDTO8H3CrIF6eHSUbtDmkf7Ei/YPJ
         YmLdOXRWi7hLIm84wS9mOYR/0pPb/s8AYXPpkNYVypMJ/H5WYqb34SJW/CB0obk1HT6c
         GC/w==
X-Gm-Message-State: AOAM533NobRBbFNHMoe7wlEgQeujJoRJV4QvtTamxm/XiambFCoVpORV
        b4qPH4etXkhRyXDhIHeVItjsJIZuN+HmStlRqQubAw==
X-Google-Smtp-Source: ABdhPJyJUeBUcRbKBBc5OZhT3CTkWd+leTIulW72WHw2OORXwCdM8BcPQZqWcWkYa2JBBQ1HO7kLz8pv/jPLIi1IO5k=
X-Received: by 2002:a05:6512:3086:: with SMTP id z6mr4373391lfd.102.1643190379153;
 Wed, 26 Jan 2022 01:46:19 -0800 (PST)
MIME-Version: 1.0
References: <20220124151146.376446-1-maximmi@nvidia.com> <20220124151146.376446-2-maximmi@nvidia.com>
In-Reply-To: <20220124151146.376446-2-maximmi@nvidia.com>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Wed, 26 Jan 2022 09:46:08 +0000
Message-ID: <CACAyw98mbtZSH3yddaptKb4Qi7Grxzt80ihqiHA3qw9n4XwVjg@mail.gmail.com>
Subject: Re: [PATCH bpf v2 1/4] bpf: Use ipv6_only_sock in bpf_tcp_gen_syncookie
To:     Maxim Mikityanskiy <maximmi@nvidia.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Tariq Toukan <tariqt@nvidia.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Petar Penkov <ppenkov@google.com>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 at 15:13, Maxim Mikityanskiy <maximmi@nvidia.com> wrote:
>
> Instead of querying the sk_ipv6only field directly, use the dedicated
> ipv6_only_sock helper.
>
> Fixes: 70d66244317e ("bpf: add bpf_tcp_gen_syncookie helper")
> Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Reviewed-by: Tariq Toukan <tariqt@nvidia.com>

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
