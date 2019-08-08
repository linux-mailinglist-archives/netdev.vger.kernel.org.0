Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA22A85DDC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 11:09:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731885AbfHHJJ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 05:09:27 -0400
Received: from mail-yw1-f67.google.com ([209.85.161.67]:42096 "EHLO
        mail-yw1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731274AbfHHJJ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 05:09:27 -0400
Received: by mail-yw1-f67.google.com with SMTP id z63so33734236ywz.9
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 02:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=30SazUA7Tq8vOLew/Q0ozPIJ6UITJfx6OSiQFokXt+o=;
        b=QoAMv3DejUjfnhb+6oRokGpixiiFkdSEwUMfIfWbE6OX7L2QqcKZDYpsVwpgwGt0Xk
         gznDPs2eCQSu+Ggc2KcoJCA0UdzunKgwi8hiTkLY+ZHSFkDOl1zUGU2gyauNO+35qNsp
         kOwUFaWA5dDE0XeEaTNpCZhgnTj2tFJ2LW3zQ8yymhoVryuAUaO6vk4vwuh8h+YQAoJi
         Owph5vWtqqGKlpcP8gxCftLVd4t68yaEHLI2r3anufZwM+CkEeaZRxVRjJcy6dqaTrRW
         n1JgFKH0jZOf0AvisfXH1BJw411XGuGYF7JGcYpFv4hjSmhazYegG1xn0LEBVT+LZNGq
         fPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=30SazUA7Tq8vOLew/Q0ozPIJ6UITJfx6OSiQFokXt+o=;
        b=J8H6LM1XGoq2v0S7tcn8Riz8tv6TNZVs1VcY8dAIXkdqaWz0Al4ytk+qobXq0pJTIf
         /4WW3k7dfSU/QKH829iXdamtdOAYG9OI09RwAC675w0hHFa+ocEEeXDcBAFbtcsHUV2H
         wwId2kDTrOZasZTXns3pacyfIBP1egfK3AyD4tmNjPLJw1mOmF+cK+ybsfVppyKQ7wKD
         juF1GccaRv/diCvUKrgOxcpm/b72XtKhB5T+moKorhzhX/0FmgKi2dRnu3IJqayFXSIv
         Zl0yVSdFIms/wHTjDjJfIO0fiGDrzrsVj+iGQY5Kc2BwyAsTr2ZJlMzwKKH0qmicnh3o
         mbMw==
X-Gm-Message-State: APjAAAURN0uBcV4DTzIT92dskAroUHVeIaMitUlglMw8vrr8NPMvr5IV
        6UPt17UhzEmZ2s2TqG7Y9S9tWQ==
X-Google-Smtp-Source: APXvYqydeeI1ncc96UjZdrxAXhHgXZE1BP0vhmCGoDri//M4yZCIqo84HVJCeE6X+NfJt2l/kTMFsg==
X-Received: by 2002:a81:3646:: with SMTP id d67mr9291114ywa.77.1565255366232;
        Thu, 08 Aug 2019 02:09:26 -0700 (PDT)
Received: from leoy-ThinkPad-X240s (li1322-146.members.linode.com. [45.79.223.146])
        by smtp.gmail.com with ESMTPSA id z9sm21277603ywj.84.2019.08.08.02.09.16
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 08 Aug 2019 02:09:25 -0700 (PDT)
Date:   Thu, 8 Aug 2019 17:09:13 +0800
From:   Leo Yan <leo.yan@linaro.org>
To:     Will Deacon <will@kernel.org>
Cc:     Russell King <linux@armlinux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-arch@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Masami Hiramatsu <mhiramat@kernel.org>
Subject: Re: [PATCH v2 0/3] arm/arm64: Add support for function error
 injection
Message-ID: <20190808090913.GD8313@leoy-ThinkPad-X240s>
References: <20190806100015.11256-1-leo.yan@linaro.org>
 <20190807160703.pe4jxak7hs7ptvde@willie-the-truck>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807160703.pe4jxak7hs7ptvde@willie-the-truck>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 07, 2019 at 05:07:03PM +0100, Will Deacon wrote:
> On Tue, Aug 06, 2019 at 06:00:12PM +0800, Leo Yan wrote:
> > This small patch set is to add support for function error injection;
> > this can be used to eanble more advanced debugging feature, e.g.
> > CONFIG_BPF_KPROBE_OVERRIDE.
> > 
> > The patch 01/03 is to consolidate the function definition which can be
> > suared cross architectures, patches 02,03/03 are used for enabling
> > function error injection on arm64 and arm architecture respectively.
> > 
> > I tested on arm64 platform Juno-r2 and one of my laptop with x86
> > architecture with below steps; I don't test for Arm architecture so
> > only pass compilation.
> 
> Thanks. I've queued the first two patches up here:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git/log/?h=for-next/error-injection

Thank you, Will.

Leo.
