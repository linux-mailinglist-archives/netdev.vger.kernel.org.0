Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 687B32DC8B9
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 23:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbgLPWGp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 17:06:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:60266 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730131AbgLPWGo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Dec 2020 17:06:44 -0500
Received: from mail-ot1-f72.google.com ([209.85.210.72])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <seth.forshee@canonical.com>)
        id 1kpevp-0005JR-Co
        for netdev@vger.kernel.org; Wed, 16 Dec 2020 22:06:01 +0000
Received: by mail-ot1-f72.google.com with SMTP id 8so7958218otq.19
        for <netdev@vger.kernel.org>; Wed, 16 Dec 2020 14:06:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fGvoLcc7ZCHu79Q6fApxlF0Se+MpASUkI3Get7rgw7g=;
        b=CjuwnGGv7WOP2bjqDZrYMxqKITavCL6IYw/pmVLrVtAL5/BHqf3RtqmPwiAEmAE7m4
         i/eEpSHHtvEHIOGlbVGcSfmPmddJgCFyBlczJqnmJ5xDUxx0IM865vZGYM7FOv2xVj7t
         jqKqVNiryASKlL9Nda7cHQzx4xrsnHkD3QYE5eHZg67QCMEP17qzftCANWCR+1Uqlb75
         +MQC9Wm9+vjGJLzGeFO2hYH3EPwtkk5FkclEKc5InJCD5flMOTSB4zONA8Ckoo4YohcP
         1cdwZYsvV2ipI6bcVlZBPvT5gqtqTX3bw0EmxCsIk1Z85J/B+57ktIwnew/QDkAvfOOQ
         GGtg==
X-Gm-Message-State: AOAM531Rn9FuDejjzMdYerXBs5HL5mNMsE/Fn3/JHkr3nOffYLecPC7t
        1p31LBjWGsQA6hzrfXCLUerrRA3fSQNB3aREXQBEeARMbsxOukha+9/0ZZSPK8C1UXRyL/14DmV
        aQZU19pGXDMZ8ZTriuDZVAIUKp/C/wv23Bg==
X-Received: by 2002:a9d:4588:: with SMTP id x8mr27874556ote.169.1608156360258;
        Wed, 16 Dec 2020 14:06:00 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwTj61vXgGhhnYgkOcQnHPGC/0/gTwApoGoxpWCunInbnH1FUNz6+hq5Ccq0G4yHGBmslW7JA==
X-Received: by 2002:a9d:4588:: with SMTP id x8mr27874534ote.169.1608156360008;
        Wed, 16 Dec 2020 14:06:00 -0800 (PST)
Received: from localhost ([2605:a601:ac0f:820:8f6:4890:1c98:9813])
        by smtp.gmail.com with ESMTPSA id m10sm725721oig.27.2020.12.16.14.05.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Dec 2020 14:05:59 -0800 (PST)
Date:   Wed, 16 Dec 2020 16:05:58 -0600
From:   Seth Forshee <seth.forshee@canonical.com>
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
Message-ID: <X9qExiKXPVmk3BJI@ubuntu-x1>
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

Why not just remove the line which adds bpf to TARGETS? This has the
same effect, but doesn't require an emtpy SKIP_TARGETS to run them. We
have testing scripts which use 'make TARGETS=bpf ...' which will have to
be updated, and I doubt we are the only ones.

I also feel like this creates confusing semantics around SKIP_TARGETS.
If I don't supply a value then I don't get the bpf selftests, but then
if I try to use SKIP_TARGETS to skip some other test suddenly I do get
them. That's counterintuitive.

I also wanted to point out that the net/test_bpf.sh selftest requires
having the test_bpf module from the bpf selftest build. So when the bpf
selftests aren't built this test is guaranteed to fail. Though it would
be nice if the net selftests didn't require building the bpf self tests
in order to pass.

Thanks,
Seth

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
>  ifneq ($(SKIP_TARGETS),)
>  	TMP := $(filter-out $(SKIP_TARGETS), $(TARGETS))
>  	override TARGETS := $(TMP)
> -- 
> 2.20.1
> 
