Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917B64F5407
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 06:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379643AbiDFEWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 00:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850378AbiDFCwO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 22:52:14 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66054181149;
        Tue,  5 Apr 2022 16:52:16 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id e22so1074856ioe.11;
        Tue, 05 Apr 2022 16:52:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pHXomKH7znoD3NKtjCedrAePGvj1PU34oOzV9waUrWE=;
        b=qP2Je91cC5X9wuYLjZp8TH9PNetiSDkDUC4K9LVY0XsP70Z0P360X7QBCcp544wpWn
         uj80MoZx+E/whCCVsJBl7bHFLs4zX9YT1v0DtGIo2TXQVILm6wSdrAYbxEVLaPSpMPRG
         SIKIBtv9TFPsCcXbNOHKCqINnfCryFkkOuEUG17CZIPI7EC5N++bXiQLtbGUwI3G1ktC
         B4WGJJrB9L4fEuvWaEKUmpTr1MxaOMVrexGTVXwlaRX188e8xQqjFFpGQ/W7Qw+DtTJ8
         44qAfRFH+M9VBi0NFgLYpeT8wWfgUW7inCLoeNUEeDAjzmUxiUZdp/P9BBnkLKTi4zUx
         rLGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pHXomKH7znoD3NKtjCedrAePGvj1PU34oOzV9waUrWE=;
        b=jdmo3pXGSLArTYozWH56R61Sa9Vm8CKn635zT3jwKfS6G9VwiGq4bMj1JGW9CWrIOC
         zgZE0A9nu4gni9LSjQ04SWMPAmBsI/0DMPKKQASMPPCisp5MjyHQ3OVKnXvS+lqqBhS+
         IrIYLQVlyQjkeQ4lU7+8XZ69SKvya7elwuXCydLM6ftV8DChQHldjiNBt0U9hOzzTghu
         zgzsrQ11B6JFK79XWsA7ObyiiZ9KImBdGY/V8b5H7bePn8uc3LvbObG+OH182xmkd5GF
         x+uP2goSxS/RGteWy1y61OHLobZTJLr6OzQySzcsXDJkaS7ybD0Hb2RqDeoxLXNZRB9T
         nwPA==
X-Gm-Message-State: AOAM533CEvHxR5iN4a6VcaGJ1GLQ7vWPtbG4Rz4rjPUfl+VRlZB4EMAP
        bG9KOKVZeuBjyzxtK3lQd+zE4KQgH8bLN7SuFRw=
X-Google-Smtp-Source: ABdhPJw6QDEx6357RD8/tWoPiOfZM+DJ9CdKHEhzqAWEeOUPTScS2FluYFnoR+Xgdc6Cy4lLB2keEra95hY1Z8CnTU4=
X-Received: by 2002:a05:6638:772:b0:319:e4eb:adb with SMTP id
 y18-20020a056638077200b00319e4eb0adbmr3287706jad.237.1649202733374; Tue, 05
 Apr 2022 16:52:13 -0700 (PDT)
MIME-Version: 1.0
References: <20220405163728.56471-1-ytcoode@gmail.com>
In-Reply-To: <20220405163728.56471-1-ytcoode@gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 5 Apr 2022 16:52:02 -0700
Message-ID: <CAEf4BzZLw-QeXgb1HRR-b3D5NqQRs_iqOFcZmokvmf6rXTy-iw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Remove redundant checks in get_stack_print_output()
To:     Yuntao Wang <ytcoode@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 5, 2022 at 9:39 AM Yuntao Wang <ytcoode@gmail.com> wrote:
>
> The checks preceding CHECK macro are redundant, remove them.
>
> Signed-off-by: Yuntao Wang <ytcoode@gmail.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> index 16048978a1ef..5f2ab720dabd 100644
> --- a/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> +++ b/tools/testing/selftests/bpf/prog_tests/get_stack_raw_tp.c
> @@ -76,10 +76,8 @@ static void get_stack_print_output(void *ctx, int cpu, void *data, __u32 size)
>                         good_user_stack = true;
>         }
>
> -       if (!good_kern_stack)
> -           CHECK(!good_kern_stack, "kern_stack", "corrupted kernel stack\n");
> -       if (!good_user_stack)
> -           CHECK(!good_user_stack, "user_stack", "corrupted user stack\n");
> +       CHECK(!good_kern_stack, "kern_stack", "corrupted kernel stack\n");
> +       CHECK(!good_user_stack, "user_stack", "corrupted user stack\n");

I suspect it was to avoid super long verbose logs, as each CHECK()
emits one line into output and here we might be getting a lot of
samples. So let's keep it as is. But for the future let's try getting
rid of CHECK()s as much as possible in favor of ASSERT_xxx(). Thanks.

>  }
>
>  void test_get_stack_raw_tp(void)
> --
> 2.35.1
>
