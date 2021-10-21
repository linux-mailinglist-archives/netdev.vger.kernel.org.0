Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9878A436B3B
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 21:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231433AbhJUTWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 15:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbhJUTWe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 15:22:34 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1162C061764;
        Thu, 21 Oct 2021 12:20:18 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id w10so1795083ilc.13;
        Thu, 21 Oct 2021 12:20:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Ob6H1ykreSRVW4TXvYrmzVih/217w7gwlTikzGgDb44=;
        b=X53tP0lzMYljdJlhTTerkQmn276rM/sjQbOBwHw3Xo38jqyMNGY/YRomPD2eVp0/Er
         HJJ51mo1s2eS0ooOhdQv2tIb+Nf8Kgw33CHwJpepMB7v7193LECO3NtwB9+v6V8EM/70
         H11n5C5nqBy6gtx1tOB9PO5w1DedoTJuzXBljoWNOqixAe2lNwQZnmoEf++iYgeKA6dU
         TbcJ4SVs5sJ9J43zSVwiSXYVjBiOd8HV/As7DBU0aZbegiNgQL9ICKW3xl9LdQ1vs5lz
         JjqX1/SInQxqLYD9/fzuKuRRwmwDPDtQTDfoytR6rkFcRENIy8u6ErbK/FiuvRQwLCAo
         sQPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Ob6H1ykreSRVW4TXvYrmzVih/217w7gwlTikzGgDb44=;
        b=TjLIxrzpDBbhjtf3dBzuVaqZKbgAe+z+uOrnu/7EgX7RHy4xqV37cRGUOsr1R05Bag
         o14CuzTC0XHcHmBajWebcQWyhvmti0STqIDw3XtrCLaWhv2XS8QwN5a6HQLLTrNx6iKh
         IqFLR3c+QuKJ9iL0u/HEsnLVBXsWwO7GrJgwj6nmPqraWJAtYik92l1iCiVlGWUysP9p
         3rnGVEq7tar5MMENiRuu6iDCNJvtGB+nIDAAcQ3MBP1r1JHdtDc7Cac/uJG1OsFc4mst
         jrKSQswfw1YaSRMwwBUU6fRA8CVvU/19hfDd9eS9NSqaUq4ltrR5zo/5uyjpoFYYsf3x
         myrg==
X-Gm-Message-State: AOAM530PTg9gCfCb05DIaqAoBnzYmPoarXqx4x3DNMLaQ52ivEb8u8O8
        Pb932dldHBrTScC6SvBl75g=
X-Google-Smtp-Source: ABdhPJxXZ+23n0NJwoQY1KSQbJoUJ0XPc3f7FR3drCUNY0jtMPZfGpt+8TYhhyjIueqvh0tJ90tP3g==
X-Received: by 2002:a92:dd06:: with SMTP id n6mr5142964ilm.87.1634844018195;
        Thu, 21 Oct 2021 12:20:18 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id o1sm3118462ilj.41.2021.10.21.12.20.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 12:20:17 -0700 (PDT)
Date:   Thu, 21 Oct 2021 12:20:10 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jiri Olsa <jolsa@redhat.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>
Message-ID: <6171bd6a9598_663a7208e4@john-XPS-13-9370.notmuch>
In-Reply-To: <20211021114132.8196-1-jolsa@kernel.org>
References: <20211021114132.8196-1-jolsa@kernel.org>
Subject: RE: [PATCH bpf-next 0/3] selftests/bpf: Fixes for perf_buffer test
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiri Olsa wrote:
> hi,
> sending fixes for perf_buffer test on systems
> with offline cpus.
> 
> v2:
>   - resend due to delivery issues, no changes
> 
> thanks,
> jirka
> 
> 
> ---
> Jiri Olsa (3):
>       selftests/bpf: Fix perf_buffer test on system with offline cpus
>       selftests/bpf: Fix possible/online index mismatch in perf_buffer test
>       selftests/bpf: Use nanosleep tracepoint in perf buffer test
> 
>  tools/testing/selftests/bpf/prog_tests/perf_buffer.c | 17 +++++++++--------
>  tools/testing/selftests/bpf/progs/test_perf_buffer.c |  2 +-
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 

For the series.

Acked-by: John Fastabend <john.fastabend@gmail.com>
