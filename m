Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8142466288
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 01:50:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729151AbfGKXup (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 19:50:45 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:45757 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728532AbfGKXuo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 19:50:44 -0400
Received: by mail-qt1-f196.google.com with SMTP id x22so1415314qtp.12;
        Thu, 11 Jul 2019 16:50:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wuTNjs1AJzVSPfomxhglY+rjhXorfZWV3dSJ2jI2rn8=;
        b=lHNjCuU//O0PYvZcPHyNlgDrIP/JmdlwJkCURyOzv2OTxDzyJ5F9OV+LxvO1YgNcTd
         3badbLyWNUwSh/hhUC12gInEmr9Az7jKuOSEhOn7IqECEFnfXc4JM1WfAwQnLh8MJL4n
         SZ8QQ09G4hEI0DmHcXjFAfQEiMpEDmBsXcbjb/bzM7JLVxFD1FmR2pV27sIT58nkpW5H
         Fi6oSphodQTJK/sJ7oFnFp5HSsLlYI5cdGw9pIbmqzR5qBEtbohHoq8IlYgpfK8LnO/8
         ZFU8DUicggdmlWtcF3oCOz4Ebjv/m9NBB8Aysg0kOsLkr1L8QVUcrrmqY18WY/2JDdvl
         PVNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wuTNjs1AJzVSPfomxhglY+rjhXorfZWV3dSJ2jI2rn8=;
        b=V8q53Yql8cOg+8gk5+ppmG343Ns3oZh/U5EIQq5pk2oDf+lSWZkXP0eUmj189wWhma
         8B5em/ROhji2htFbel4DFxIROS1WqEoPT0zy4A6HNDHKgEY4hfAI2XWTtRgIoE8WrU9p
         /svIKoPoPej2Fwkzl1o9DNrS+uVvfOmWH3231pcCHzSb3cXTNyMOdFpJO0nT6VEm+xvB
         f7R76R7r8ZBkn9ze62OgCN6J9mMAlXQ/jBu9pdvjdaRVWRMr1ZfVu3zU9lPpXTGNwMYF
         H0Se9JmFfgcelT2+nGQ8azAvUvFd1I6Q7OwDJP+jhWiGdREj22gUnCUfwbFtHDHtqNKb
         Jk6g==
X-Gm-Message-State: APjAAAX0S4327S9hOdPhemzDVyTeTYS/7a2SMGqD7x3ctXtXTmbiQq0h
        nQw+hkhRL9PToC4GPDyvMot/9mTMtcB+F8XcydM=
X-Google-Smtp-Source: APXvYqxi5uC3T9mdtDBKrfzoMfUO2bPhfXojvxDD1+S09q+TEBQcHeoRdC3Rji4gs+Y+3hL1bahWQt+YEvRtNbQD8Y0=
X-Received: by 2002:ac8:2d56:: with SMTP id o22mr3917172qta.171.1562889043498;
 Thu, 11 Jul 2019 16:50:43 -0700 (PDT)
MIME-Version: 1.0
References: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
In-Reply-To: <1562837513-745-1-git-send-email-p.pisati@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 11 Jul 2019 16:50:32 -0700
Message-ID: <CAEf4BzbGLmuZ48vFUCrDW6VC7_YrkW_0NpgpgXNQEzF_dEqgnA@mail.gmail.com>
Subject: Re: [PATCH 0/2] Fold checksum at the end of bpf_csum_diff and fix
To:     Paolo Pisati <p.pisati@gmail.com>
Cc:     "--in-reply-to=" <20190710231439.GD32439@tassilo.jf.intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        "David S . Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Jiong Wang <jiong.wang@netronome.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 11, 2019 at 2:32 AM Paolo Pisati <p.pisati@gmail.com> wrote:
>
> From: Paolo Pisati <paolo.pisati@canonical.com>
>
> After applying patch 0001, all checksum implementations i could test (x86-64, arm64 and
> arm), now agree on the return value.
>
> Patch 0002 fix the expected return value for test #13: i did the calculation manually,
> and it correspond.
>
> Unfortunately, after applying patch 0001, other test cases now fail in
> test_verifier:
>
> $ sudo ./tools/testing/selftests/bpf/test_verifier
> ...
> #417/p helper access to variable memory: size = 0 allowed on NULL (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0
> #419/p helper access to variable memory: size = 0 allowed on != NULL stack pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0
> #423/p helper access to variable memory: size possible = 0 allowed on != NULL packet pointer (ARG_PTR_TO_MEM_OR_NULL) FAIL retval 65535 != 0

I'm not entirely sure this fix is correct, given these failures, to be honest.

Let's wait for someone who understands intended semantics for
bpf_csum_diff, before changing returned value so drastically.

But in any case, fixes for these test failures should be in your patch
series as well.


> ...
> Summary: 1500 PASSED, 0 SKIPPED, 3 FAILED
>
> And there are probably other fallouts in other selftests - someone familiar
> should take a look before applying these patches.
>
> Paolo Pisati (2):
>   bpf: bpf_csum_diff: fold the checksum before returning the
>     value
>   bpf, selftest: fix checksum value for test #13
>
>  net/core/filter.c                                   | 2 +-
>  tools/testing/selftests/bpf/verifier/array_access.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
>
> --
> 2.17.1
>
