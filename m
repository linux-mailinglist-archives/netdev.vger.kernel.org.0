Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0082A2B1B0C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 13:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgKMMZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 07:25:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgKMMZC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 07:25:02 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B2E1C0617A6
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 04:25:01 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id oq3so13116293ejb.7
        for <netdev@vger.kernel.org>; Fri, 13 Nov 2020 04:25:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=49p0EnMEE9ULp6RJvcOQnpqAXD/aUtdl46fmyb4bTSU=;
        b=nO19WHU9K3WItec+KVPJVHUqvwtTzRt+j/mXcIiYgkmvXhlRTvIvFkZ+Sta+7UNx7D
         JZIfSYkuu8HqGUpd/U/FDCl+tPgU/Ob8v+ihVpSnvh6bL35FM3CZTNCkT/d6TOaUww/5
         wwhF5rCMGRgFiLeL3Mb5jNXGEe0mF8NXok7ojTV5tMNzIJ2Bx4u5qrem56iYy8pEQg+/
         JwlN1Omd31B05HH2t608K+ryyPeYCTudWl8MC/YrhbKjV7DTjoRFQvXxCisziceK0Pqo
         5U4wEUgv0yT7OGhG28I9Dh3GYWebxOgcxYEbMX7XMVki2U9q0z/t40kSD6oS99psbbbU
         2WoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=49p0EnMEE9ULp6RJvcOQnpqAXD/aUtdl46fmyb4bTSU=;
        b=cidiSNUlz8N0nPuGpEWTlw7Ixzut12QmQA1m6gTBze+0nUwPRrOuUkJH253UD3aewK
         OqTkQPs19iRtgbw/ZvLpSDZF1RKL5s/1FjLdTKIjOl3+hdrObTdw5TChqzaAs0r87Ja4
         gnyg0W2YIncJfu96M6/CYgOKsx7HlfiwX4COcrUgf9OkHHVVfBIqMnSoIewQy0fgEiT6
         CPwhVdpt7eNS1ViJhe2/KX9vBiiPT5KXRWMKU/ygfIaSA4JZ5Oa0hCSVWLD+GSRqRlx4
         /J7bqQNKYezs71hwul5I2SFuSYFxtn2xApzCAayrzcVJ/qoU8usFIA6fiXhh76+gqVdT
         TRLQ==
X-Gm-Message-State: AOAM533imVyF3uBcCOV4HmYLwvAUbyBTrDLxVSi4amv7w98a6LOhHsLq
        2235O1F6Tt5DO+TWSc0rokO4+g==
X-Google-Smtp-Source: ABdhPJwq1S/7g8AUo4BVeZ5WDLRYa9p01thBZjKrjBXbTHHThI0S2zQXwN7XtuLcdpvWQdEycjya6g==
X-Received: by 2002:a17:906:d9dd:: with SMTP id qk29mr1695474ejb.487.1605270300119;
        Fri, 13 Nov 2020 04:25:00 -0800 (PST)
Received: from myrica ([2001:1715:4e26:a7e0:116c:c27a:3e7f:5eaf])
        by smtp.gmail.com with ESMTPSA id n1sm3818181edt.66.2020.11.13.04.24.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2020 04:24:59 -0800 (PST)
Date:   Fri, 13 Nov 2020 13:24:40 +0100
From:   Jean-Philippe Brucker <jean-philippe@linaro.org>
To:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Tom Herbert <tom@herbertland.com>,
        Anders Roxell <anders.roxell@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: csum_partial() on different archs (selftest/bpf)
Message-ID: <20201113122440.GA2164@myrica>
References: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNiQbOcqCLxFUP2FMm5QrLXUUaj852Fxe3hn_2JNiucn6g@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Nov 13, 2020 at 11:36:08AM +0100, Björn Töpel wrote:
> I was running the selftest/bpf on riscv, and had a closer look at one
> of the failing cases:
> 
>   #14/p valid read map access into a read-only array 2 FAIL retval
> 65507 != -29 (run 1/1)
> 
> The test does a csum_partial() call via a BPF helper. riscv uses the
> generic implementation. arm64 uses the generic csum_partial() and fail
> in the same way [1].

It's worse than that, because arm64, parisc, alpha and others implement
do_csum(), called by the generic csum_partial(), and those all return a
16-bit value.

It would be good to firstly formalize the size of the value returned by
the bpf_csum_diff() helper, because it's not clear from the doc (and the
helper returns a s64).

Then homogenizing the csum_partial() implementations is difficult. One way
forward, without having to immediately rewrite all arch-specific
implementations, would be to replace csum_partial() and do_csum() with
csum_partial_32(), csum_partial_16(), do_csum_32() and do_csum_16(). That
way we can use a generic implementation of the 32-bit variant if the
arch-specific implementation is 16-bit.

Thanks,
Jean

> arm (32-bit) has a arch specfic implementation,
> and fail in another way (FAIL retval 131042 != -29) [2].
> 
> I mimicked the test case in a userland program, comparing the generic
> csum_partial() to the x86 implementation [3], and the generic and x86
> implementation does yield a different result.
> 
> x86     :    -29 : 0xffffffe3
> generic :  65507 : 0x0000ffe3
> arm     : 131042 : 0x0001ffe2
> 
> Who is correct? :-) It would be nice to get rid of this failed case...
> 
> 
> Thanks,
> Björn
> 
> 
> [1] https://qa-reports.linaro.org/lkft/linux-next-master/build/next-20201112/testrun/3430401/suite/kselftest/test/bpf.test_verifier/log
> [2] https://qa-reports.linaro.org/lkft/linux-mainline-master/build/v5.10-rc3-207-g585e5b17b92d/testrun/3432361/suite/kselftest/test/bpf.test_verifier/log
> [3] https://gist.github.com/bjoto/dc22d593aa3ac63c2c90632de5ed82e0
