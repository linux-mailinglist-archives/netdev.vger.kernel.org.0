Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7A042D6622
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 20:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393321AbgLJTME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Dec 2020 14:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389324AbgLJTLr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Dec 2020 14:11:47 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60D25C061794;
        Thu, 10 Dec 2020 11:11:07 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 4so3267777plk.5;
        Thu, 10 Dec 2020 11:11:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ixjBTL8ik2zV5HfQ8pkfcH2s6ihYaw94epz6NA5THr0=;
        b=NIkbINsBVQU/Ej6aaIkPokyGq2YzoaR4uWZQYPc8e9TfWPLJXiCkDXmG1oVhqRdEQn
         U0wyjTEk/+B1O5c+KK0z9tDg5/Wx1h2IghT1goipV8egomZck1mc31cpKtGDoADLNh+c
         n6/x6V5LHuy0sC3jhJOumec2GJPXQxsyVTu7uGUVS/Uy7jOmP4Q5jXCFZ0ERSSVVP/YI
         Z+y9JHFj3ro7G/gwaLVv8ZTpWPP2yfyGzlFfbLq5XiKWZyaf6jg22Ki3XTmlrycVA166
         4nTgIYlvGi0w8I8yFSHqWrUlMGPv8m8jJXPRGnCT2YSR5kzo0UZRVciA/zUX5AkkltPy
         xZaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ixjBTL8ik2zV5HfQ8pkfcH2s6ihYaw94epz6NA5THr0=;
        b=bwZ8hEKoUJkiwAI3J1EhfUBQKKMqFoV1FxiYYyVfW2XpV0KhSfU3fpRJzR7CFtynd6
         3cyvKjuwIymH45wFv0OQQNkod9PLsMUloWGAG+jm1tO9VbzJ7k8bbcNpdvp+yJi3bFAF
         0kgi5w64UYDRmoRxiVTTrWMQdXFWw8BYV+lPa7VF6e85v38TzTVbH894yHaE8xironAs
         Kkmlij/8LjVWs9Rw3v53cz04h8wcsxgD1G0qjSNFqDiZnI9a/JekwEnUAcrEtsaceAhM
         WtydM6vErHRP1AXtzx6UoD9HyWVVBvmp7SLHjt6MP3ifDfwODMUlbVcXIl7wg4lwXKzp
         IKhg==
X-Gm-Message-State: AOAM531uTc9VqIhpB67z1ymtXWEIMzLCX60DlTgjdsWWNAA9dd1u8wpQ
        CA8M/tDpPMO/9FG1JoT7oJY=
X-Google-Smtp-Source: ABdhPJxFGYpgWWb6Gi6heTy285YUjxFfSn9MdVqlYCtJiVWIsDKZjhEaDltE0LRUkUNU3eQWEwGzDw==
X-Received: by 2002:a17:902:6b48:b029:d8:e603:75fb with SMTP id g8-20020a1709026b48b02900d8e60375fbmr7770525plt.6.1607627466851;
        Thu, 10 Dec 2020 11:11:06 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:400::5:2a7e])
        by smtp.gmail.com with ESMTPSA id z27sm7068050pfq.70.2020.12.10.11.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 11:11:06 -0800 (PST)
Date:   Thu, 10 Dec 2020 11:11:03 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Mark Brown <broonie@kernel.org>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Daniel Diaz <daniel.diaz@linaro.org>,
        Veronika Kabatova <vkabatov@redhat.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Kevin Hilman <khilman@baylibre.com>
Subject: Re: [PATCH] selftests: Skip BPF seftests by default
Message-ID: <20201210191103.kfrna27kv3xwnshr@ast-mbp>
References: <20201210185233.28091-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201210185233.28091-1-broonie@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 10, 2020 at 06:52:33PM +0000, Mark Brown wrote:
> The BPF selftests have build time dependencies on cutting edge versions
> of tools in the BPF ecosystem including LLVM which are more involved
> to satisfy than more typical requirements like installing a package from
> your distribution.  This causes issues for users looking at kselftest in
> as a whole who find that a default build of kselftest fails and that
> resolving this is time consuming and adds administrative overhead.  The
> fast pace of BPF development and the need for a full BPF stack to do
> substantial development or validation work on the code mean that people
> working directly on it don't see a reasonable way to keep supporting
> older environments without causing problems with the usability of the
> BPF tests in BPF development so these requirements are unlikely to be
> relaxed in the immediate future.
> 
> There is already support for skipping targets so in order to reduce the
> barrier to entry for people interested in kselftest as a whole let's use
> that to skip the BPF tests by default when people work with the top
> level kselftest build system.  Users can still build the BPF selftests
> as part of the wider kselftest build by specifying SKIP_TARGETS,
> including setting an empty SKIP_TARGETS to build everything.  They can
> also continue to build the BPF selftests individually in cases where
> they are specifically focused on BPF.
> 
> This isn't ideal since it means people will need to take special steps
> to build the BPF tests but the dependencies mean that realistically this
> is already the case to some extent and it makes it easier for people to
> pick up and work with the other selftests which is hopefully a net win.
> 
> Signed-off-by: Mark Brown <broonie@kernel.org>
> ---
>  tools/testing/selftests/Makefile | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
> index afbab4aeef3c..8a917cb4426a 100644
> --- a/tools/testing/selftests/Makefile
> +++ b/tools/testing/selftests/Makefile
> @@ -77,8 +77,10 @@ TARGETS += zram
>  TARGETS_HOTPLUG = cpu-hotplug
>  TARGETS_HOTPLUG += memory-hotplug
>  
> -# User can optionally provide a TARGETS skiplist.
> -SKIP_TARGETS ?=
> +# User can optionally provide a TARGETS skiplist.  By default we skip
> +# BPF since it has cutting edge build time dependencies which require
> +# more effort to install.
> +SKIP_TARGETS ?= bpf

I'm fine with this, but I'd rather make an obvious second step right away
and move selftests/bpf into a different directory.
