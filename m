Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3219A2DD4A5
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 16:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728689AbgLQPyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 10:54:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgLQPyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 10:54:18 -0500
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A09FC061794
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 07:53:38 -0800 (PST)
Received: by mail-io1-xd2b.google.com with SMTP id z136so27963081iof.3
        for <netdev@vger.kernel.org>; Thu, 17 Dec 2020 07:53:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1tS/TPZAajsb6a4c9RGCrJLAfHltUkaFmVEdRYEivFw=;
        b=SB3dU4WyB1PXusFJSVHyaDGab5FNdkiftmzo1JGqFGpxCsRHPYqHdndiCTPIfpyAoA
         dZavB6mNbbXhvbdmY/9ftV0QOmkMdFayEvq7NSre/oLvfElDLFyZmo7ETmkSiCnjkKSo
         hqEegmshqqPRw0FO9cwVBmlXxQvHe5n6xV5a0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1tS/TPZAajsb6a4c9RGCrJLAfHltUkaFmVEdRYEivFw=;
        b=QggZB+m+JNvI7Yeu8JcItvkTlRad7GZ6IYFoVF/twIwJrL0TcBzZ85fH50Ut1xUV0q
         lKjnXgQ/zeTYSMk8wjPmSl5TK4RlyOheIltteRfUOi2pwveAuFg1dQQ08uQlpRMoXk75
         HqYsc/MFSjef0n5/zoxzHwFJYn4pkwlZK2wB/Np8MgPhIWe5gPUqGNT08Hvnf3pjA8YO
         Nv7bLYMzBELxGhVqfF4UsfWuvML25BNXIhxrTMFtMfetTUMx9pYsoZuSLQAuaR12G+FD
         SSdjt9wsFt65BGVNi6BwoGKWjtk0QKRD5dD5niM8Hw36e8uLDlOsyjFcRTnq1wwF7fhi
         3CNA==
X-Gm-Message-State: AOAM530oNaI/rdmDvxZA2FWTAOFe4wgdJ3i1AtDOiAqdd2kC+SKyaylP
        iP4t7emTl8pia8kkM4XBTMIx3A==
X-Google-Smtp-Source: ABdhPJwFKs72LIIAoNy8AlcxOBj2qkgjalhkB41+xRe9ghJ6Iq6ypq8oDxfJBkTODIta16gtRk8+Tg==
X-Received: by 2002:a05:6638:83:: with SMTP id v3mr47713212jao.106.1608220417790;
        Thu, 17 Dec 2020 07:53:37 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id j65sm3551569ilg.53.2020.12.17.07.53.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Dec 2020 07:53:37 -0800 (PST)
Subject: Re: [PATCH] selftests: Skip BPF seftests by default
To:     Mark Brown <broonie@kernel.org>,
        Seth Forshee <seth.forshee@canonical.com>
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
        Kevin Hilman <khilman@baylibre.com>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20201210185233.28091-1-broonie@kernel.org>
 <X9qExiKXPVmk3BJI@ubuntu-x1> <20201217130735.GA4708@sirena.org.uk>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <94010653-0cb3-d804-7410-a571480d6db2@linuxfoundation.org>
Date:   Thu, 17 Dec 2020 08:53:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201217130735.GA4708@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/17/20 6:07 AM, Mark Brown wrote:
> On Wed, Dec 16, 2020 at 04:05:58PM -0600, Seth Forshee wrote:
>> On Thu, Dec 10, 2020 at 06:52:33PM +0000, Mark Brown wrote:
> 
>>> as part of the wider kselftest build by specifying SKIP_TARGETS,
>>> including setting an empty SKIP_TARGETS to build everything.  They can
>>> also continue to build the BPF selftests individually in cases where
>>> they are specifically focused on BPF.
> 
>> Why not just remove the line which adds bpf to TARGETS? This has the
>> same effect, but doesn't require an emtpy SKIP_TARGETS to run them. We
>> have testing scripts which use 'make TARGETS=bpf ...' which will have to
>> be updated, and I doubt we are the only ones.
> 

I would prefer leaving bpf in the main Makefile TARGETS. This will be
useful to users that have their systems setup for bpf builds.

>> I also feel like this creates confusing semantics around SKIP_TARGETS.
>> If I don't supply a value then I don't get the bpf selftests, but then
>> if I try to use SKIP_TARGETS to skip some other test suddenly I do get
>> them. That's counterintuitive.
> 
> That's what I did first, it's also messy just differently.  If you
> don't add bpf to TARGETS then if you do what's needed to get it building
> it becomes inconvenient to run it as part of running everything else at
> the top level since you need to enumerate all the targets.  It felt like
> skipping is what we're actually doing here and it seems like those
> actively working with BPF will be used to having to update things in
> their environment.  People who start using SKIP_TARGETS are *probably*
> going to find out about it from the Makefile anyway so will see the
> default that's there.
> 
> Fundamentally having such demanding build dependencies is always going
> to result in some kind of mess, it's just where we push it.
> 
>> I also wanted to point out that the net/test_bpf.sh selftest requires
>> having the test_bpf module from the bpf selftest build. So when the bpf
>> selftests aren't built this test is guaranteed to fail. Though it would
>> be nice if the net selftests didn't require building the bpf self tests
>> in order to pass.
> 
> Right, that's a separate issue - the net tests should really skip that
> if they don't have BPF, as we do for other runtime detectable
> dependencies.  It's nowhere near as severe as failing to build though.
> 

Correct. This has to be handled as a run-time dependency check and skip
instead of fail.

thanks,
-- Shuah
