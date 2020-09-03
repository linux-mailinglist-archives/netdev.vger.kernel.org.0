Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F159525CAFD
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 22:37:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729749AbgICUhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 16:37:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729729AbgICUg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 16:36:57 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26802C061244;
        Thu,  3 Sep 2020 13:36:57 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id q3so3054177ybp.7;
        Thu, 03 Sep 2020 13:36:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=2E7KS28zfC4tVsTRRkYzuj1mxceg9YfnccbGKN5EM2Y=;
        b=b8Z56R9vFCgocfa8RWukYzYWSYA3gtr6wje77Wssz6K+yjxqD8f20ntZRZheoOVV+v
         BDgrP0DtuIjNozxXUxj5gCg9caRvd/P+tM9finPeseB/BU1EGEVNuDDUCUhc6fRW0+nv
         ipw4HTaUQsw0mD/UVxhcoksGGtRHcfpjSL9gdBe9rLiF683BWUicBR0v5tH9ve/YOECY
         CRBkxBs6Drv3tPFtYRZzKysdE0NXzSFgndTRv8sHMiGEPIn/N3Hy6jz0Y1HBJtbaGfQs
         2tl62L8jQBmWUR4YbZ+pMBird4XhD+ApWBH/laeIzawJImWgckQ8geGawy72noVBmYN7
         2BYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2E7KS28zfC4tVsTRRkYzuj1mxceg9YfnccbGKN5EM2Y=;
        b=F3Yb6WkV5Ht9SqyzXYDGFKnBQWJmOR0w2OhERh83PfsCB56mSjQhLx2QkGDgs+WXC3
         a2hkwpVcjOPkGaUjadZhQYr4C3fNEejj6aYE9Q6y9j2tukXA2nqhDESGaMmNvGWfos5Q
         xrfipchqB7H7gS4A5t1xZGXfvvPcRMRXLvtMrgQocMWBzHIXorc8WS5FHm7bJDx2shJR
         nY1ooQk2T3yzTEYphbhLL6y5i+aezOKPRts4A5QG8u3FogP9zH0O9nLC+20Tl8+qbguP
         p5Etq+bgxM2HN5l67lGt9U1TXOCYQim/J4WOtGaF5bQpMswMuXJcsec0/+vnZqeEbHYH
         uI7w==
X-Gm-Message-State: AOAM532HTyYh5kJKbsH9b59IZpJLToqbSoV5DHMjudwzLqo5KjOCFBjC
        orA0XKfQruoENGPFoBBQILl6rgA7YPljT1itV5U=
X-Google-Smtp-Source: ABdhPJyDQfdxjra9IKhfUae9dPcHOGQ0OPr4g2ImIt6wfz0b1j2FGZbTmo+bBtcrYt4XI6l5mjIApkQYAlXK5G6M1C4=
X-Received: by 2002:a25:6885:: with SMTP id d127mr5150392ybc.27.1599165416443;
 Thu, 03 Sep 2020 13:36:56 -0700 (PDT)
MIME-Version: 1.0
References: <20200903200528.747884-1-haoluo@google.com>
In-Reply-To: <20200903200528.747884-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Sep 2020 13:36:45 -0700
Message-ID: <CAEf4Bza6e+x8Rqy7cBzMG0F0D5WCzE7xPRoAqJgSbfyqXxtT5A@mail.gmail.com>
Subject: Re: [PATCH] selftests/bpf: Fix check in global_data_init.
To:     Hao Luo <haoluo@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        KP Singh <kpsingh@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 3, 2020 at 1:06 PM Hao Luo <haoluo@google.com> wrote:
>
> The returned value of bpf_object__open_file() should be checked with
> libbpf_get_error() rather than NULL. This fix prevents test_progs from
> crash when test_global_data.o is not present.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---

thanks!

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/prog_tests/global_data_init.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/global_data_init.c b/tools/testing/selftests/bpf/prog_tests/global_data_init.c
> index 3bdaa5a40744..ee46b11f1f9a 100644
> --- a/tools/testing/selftests/bpf/prog_tests/global_data_init.c
> +++ b/tools/testing/selftests/bpf/prog_tests/global_data_init.c
> @@ -12,7 +12,8 @@ void test_global_data_init(void)
>         size_t sz;
>
>         obj = bpf_object__open_file(file, NULL);
> -       if (CHECK_FAIL(!obj))
> +       err = libbpf_get_error(obj);
> +       if (CHECK_FAIL(err))
>                 return;
>
>         map = bpf_object__find_map_by_name(obj, "test_glo.rodata");
> --
> 2.28.0.526.ge36021eeef-goog
>
