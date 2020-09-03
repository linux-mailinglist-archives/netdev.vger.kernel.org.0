Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBE1C25C8F9
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 20:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729169AbgICSvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Sep 2020 14:51:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727065AbgICSu7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Sep 2020 14:50:59 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A333C061244;
        Thu,  3 Sep 2020 11:50:59 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id s92so2892077ybi.2;
        Thu, 03 Sep 2020 11:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nWryz7cGGb7smK7ck6NRR7lmXazI3vI4tRYw7MpNE7I=;
        b=h/H7emTHFm18MSYwIfWOY6up73kGriPotxpPDxxIzGFezb9s6u95yUSAQks1hjPic5
         B7TGckUvsRrE54bjV/NjPRrfRjOhcj3KEqh3A0xxpc6o+MI7Xiq2cODAVYtDVoWPbsVx
         xjEH/BWoqyncQIBs1bPC7PWP08kWzJRk3NCGuL/F3bhPWjzEE4OvMzOaI2AR1p+Dg9Na
         IUuDSWOUf14qqYxIeFPnFy8/pj1BU+5xhAwDYUD/NIF/fPznUZdEGqonlbq/l1gtznpp
         5Wi3oFIyeCTrkjGAG7EXbkieMz9buryVEu7+MTWRx8wXaI6SS41pvEv0gBPLnOgGw5r9
         AQLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nWryz7cGGb7smK7ck6NRR7lmXazI3vI4tRYw7MpNE7I=;
        b=akuZ6nxiKiFj+vmtzLoXUvUbpVrv31iIgt9TKsDpdIbmZbCMIf1pKkaAFzhdBY3JHs
         SAu/YgkIe6vuTb++j/S/cUPTE30wQmX6eucgB4gnv1m9lAdbEYxaNa0aEAR7SfzvoPAP
         EqBEMcFarpr+uD9Y432eknXqBK9ZClWPHsT2pr1sLbmtIKrJfM1S4nuSxWBYeR2pAKGc
         vOeEEVq9LfV0k9QuOadFsk1/+UnXeXY//2jBoo9V+mtwMYydv4b5ahzrv/q94T8gRq1K
         +MGO5FyX1ti6rbiT3X0NGJsVgY//M27IAbO7qWdW9cCrRGrXwsimDpgRxsyHMf9jP3pc
         7vwQ==
X-Gm-Message-State: AOAM531dHL1DATZys+B6xZCVLBtZyuz3e0V41T6M9j8Jrp1+nCgDdd1a
        9cVFUJ9isLY2jlQfnhNR1a4rjWGXPPDgl0jEamU=
X-Google-Smtp-Source: ABdhPJzVM75wh06e8DGWvnQkqVJVD+7FKGtI/z06+zY+k49x0SU7qeHDl937ds5X2ENJGxl1zXe6tAF+e5RCOxxtBqc=
X-Received: by 2002:a25:824a:: with SMTP id d10mr4891758ybn.260.1599159057296;
 Thu, 03 Sep 2020 11:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200903180121.662887-1-haoluo@google.com>
In-Reply-To: <20200903180121.662887-1-haoluo@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 3 Sep 2020 11:50:46 -0700
Message-ID: <CAEf4BzYtr6Tki8viGt0KBAwH5FF0don+j3Td86m0Kg95kUEAhw@mail.gmail.com>
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

On Thu, Sep 3, 2020 at 11:02 AM Hao Luo <haoluo@google.com> wrote:
>
> The returned value of bpf_object__open_file() should be checked with
> IS_ERR() rather than NULL. This fix makes test_progs not crash when
> test_global_data.o is not present.
>
> Signed-off-by: Hao Luo <haoluo@google.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/global_data_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/global_data_init.c b/tools/testing/selftests/bpf/prog_tests/global_data_init.c
> index 3bdaa5a40744..1ece86d5c519 100644
> --- a/tools/testing/selftests/bpf/prog_tests/global_data_init.c
> +++ b/tools/testing/selftests/bpf/prog_tests/global_data_init.c
> @@ -12,7 +12,7 @@ void test_global_data_init(void)
>         size_t sz;
>
>         obj = bpf_object__open_file(file, NULL);
> -       if (CHECK_FAIL(!obj))
> +       if (CHECK_FAIL(IS_ERR(obj)))

Can you please use libbpf_get_error(obj) instead to set a good example
or not relying on kernel internal macros?

>                 return;
>
>         map = bpf_object__find_map_by_name(obj, "test_glo.rodata");
> --
> 2.28.0.402.g5ffc5be6b7-goog
>
