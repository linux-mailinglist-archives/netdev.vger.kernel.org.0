Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456A02A5C8D
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 03:02:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730295AbgKDCCC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 21:02:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbgKDCCB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 21:02:01 -0500
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390ABC061A4D;
        Tue,  3 Nov 2020 18:02:01 -0800 (PST)
Received: by mail-lj1-x242.google.com with SMTP id 23so21197352ljv.7;
        Tue, 03 Nov 2020 18:02:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1yma48dKdVqmnkXLz5g2oI67rjVrKBZ1uT18L9ol4Oc=;
        b=PbM7IZtGgExU1E+sfiBrXCgBgFz0IsOVO7yxw5umMeMyOzuzetUrnFSUunZmFWDvsm
         vBRscaMP1RMo44oGsraE9+mFBNMqh3tW9Ajj0HY9EfiWx6KCoeBQEUUJJdlVVzNXKM3t
         l/HxTQbcL1U9AbiZ+noLkU9gfbYgEB7ZHEYnuAgM7rEsmUuRu+NwqQMiOAwx2yAd4RZL
         bKgLEjxlQMdUq3CNvexnbBT+ckeU5WMyzFllEeZh0TiwlFSsJIU8uvaDgiERp8RlDXSE
         CH0+uYj4WyAyStDnV/O64qsFuRlUpWEa0ul3HGATqKLlYxcNnKi7smq9SkXSs09PCuXQ
         2ijw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=1yma48dKdVqmnkXLz5g2oI67rjVrKBZ1uT18L9ol4Oc=;
        b=YlieGrfl0ZXa1QGIVcViOROQYHXZ7Z/D58ngjyzB+OeXwmizqCm8YGYZsKV2kB9Nlb
         dolTwqeuuTLEhae9ahiSYpWu3HF5x6OSwix2g+O7Ke6ZLbAOFf0FG5G+iTNeuAAakmnP
         P+HYsEB1jUNqDHfqob8+EsuF7X2oWD72FN/9KXkoms0h+lYOfmMYWoAPfvpBGz5BJ32M
         Ggst/GJxb3tTpVLaW86GEttCHMtwzdMpYJ/mx07xuuC63y7pBtv2UUq/ydPgf32Z+YUX
         khfLjgF3dka8TJU4ZZAo8SzerDaj2Ex/aIhSPDt/Nl94t5dsdU+RnJC3FUCyatifpZij
         H25Q==
X-Gm-Message-State: AOAM533Pc9ig04ehMCgIN2RVIy6UY3fqyD5NlNE1NR9qJ6BSzQDUJ9Dh
        r7Mbj5jnHaz5dnGpn+XU2837AqVCsuFwPm5Y09U=
X-Google-Smtp-Source: ABdhPJytKk7ZsPbcpOT6wb7zbD1nk0SmukE0zS45OO5Quezt5ar2yXGDCJILGu0huvHvorMc2s1+tHpPXjP15lmn98I=
X-Received: by 2002:a05:651c:1205:: with SMTP id i5mr4012730lja.283.1604455319699;
 Tue, 03 Nov 2020 18:01:59 -0800 (PST)
MIME-Version: 1.0
References: <160443914296.1086697.4231574770375103169.stgit@localhost.localdomain>
 <20201104002014.tohvmzsxr2hhxjkt@kafai-mbp.dhcp.thefacebook.com>
In-Reply-To: <20201104002014.tohvmzsxr2hhxjkt@kafai-mbp.dhcp.thefacebook.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 3 Nov 2020 18:01:48 -0800
Message-ID: <CAADnVQ+dApEP-6qJzKiEJNbdh4QgBfAJN5oOjVfKwDr4iHRtUQ@mail.gmail.com>
Subject: Re: [bpf-next PATCH v3 0/5] selftests/bpf: Migrate test_tcpbpf_user
 to be a part of test_progs framework
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     Alexander Duyck <alexander.duyck@gmail.com>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Lawrence Brakmo <brakmo@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        alexanderduyck@fb.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 3, 2020 at 4:20 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> On Tue, Nov 03, 2020 at 01:34:40PM -0800, Alexander Duyck wrote:
> > Move the test functionality from test_tcpbpf_user into the test_progs
> > framework so that it will be run any time the test_progs framework is run.
> > This will help to prevent future test escapes as the individual tests, such
> > as test_tcpbpf_user, are less likely to be run by developers and CI
> > tests.
> >
> > As a part of moving it over the series goes through and updates the code to
> > make use of the existing APIs included in the test_progs framework. This is
> > meant to simplify and streamline the test code and avoid duplication of
> > effort.
> >
> > v2: Dropped test_tcpbpf_user from .gitignore
> >     Replaced CHECK_FAIL calls with CHECK calls
> >     Minimized changes in patch 1 when moving the file
> >     Updated stg mail command line to display renames in submission
> >     Added shutdown logic to end of run_test function to guarantee close
> >     Added patch that replaces the two maps with use of global variables
> > v3: Left err at -1 while we are performing send/recv calls w/ data
> >     Drop extra labels from test_tcpbpf_user in favor of keeping err label
> >     Dropped redundant zero init for tcpbpf_globals result and key
> >     Dropped replacing of "printf(" with "fprintf(stderr, "
> >     Fixed error in use of ASSERT_OK_PTR which was skipping of run_test
> >     Replaced "{ 0 }" with "{}" in init of global in test_tcpbpf_kern.c
> >     Added "Acked-by" from Martin KaiFai Lau and Andrii Nakryiko
> Acked-by: Martin KaFai Lau <kafai@fb.com>

Applied. Thanks
