Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 190A84C0B5F
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 06:07:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235134AbiBWFHZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 00:07:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiBWFHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 00:07:23 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8FB4AE20;
        Tue, 22 Feb 2022 21:06:56 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id v5-20020a17090ac90500b001bc40b548f9so1145954pjt.0;
        Tue, 22 Feb 2022 21:06:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dXB/BZU2jIX6178jXiFH79CpBPQscGLZdjPpVRnF/rI=;
        b=LPtftFYjXAXkq89fxc7EWk+qow80N+KdT2g+ENbvvlMAZ0fcMcDC+pFSAc54nl5xgI
         ybwefINOia7aTJ8ZODSXFo+zhi/9dTNTAOt8V+G+U9W1ddceIxx+xTwlY50Ao28I6VzX
         /bJW2iTSkQYPrUmxj9jNLxAKTwuKTzDX3dHTcCN0IfbibkV6dTmpo4WAjQ6eAWfAHslJ
         Jc6mpCRv8EqA64SkUrFJukBY9INW8oP7IOAaLewBjHL/uQiRx8O5tBewR1UGQGKUdAqb
         HsNzsSN9G3Dmc3FOaYwqluv+uv/WiAed13fk6jJk+VkbpoapFTFPm9CYyFkQy6AC7K2h
         q7ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dXB/BZU2jIX6178jXiFH79CpBPQscGLZdjPpVRnF/rI=;
        b=C9xPKUvAerGG9tCafXKkSu5mW2UVOQqhRGxEUTkMHFxyhwOsGIJtP/CQ92oXSYBZJ1
         sI5Dldx/m/IN4LD0CA4Gxm8ZxPqWB9vHEkvaAdNvNB7OPPu0FMVi7gnQazMDtg3OQdGY
         KQD7CS2zadPtp5TnFWjkJOpTlycvvBk2HiRWQ5G3QV1NJZCUf2eOIjVIN83lLmLrnJ6H
         /N/eLvJl2CCMj9i3mT/tkhd7TG4d/jHtu6BeSbk+rulfAAJ/F9nFDRj92FdAq+14hNVY
         aozZb4DIdrMDRiGTIa6KVARvYuqcQ2ZHaTwmYrqtXBYp2JkMpCJC3fGTBk5FMLeEgiPT
         pw5A==
X-Gm-Message-State: AOAM5314Ds9mjDd367tyIInEni7AWrJeaJI1gR9D/ntW+D9VaOzjN2q1
        v0feYsBAkHDwO7hXZSUzjFUOZCHEJdkYf8Pt9Uk=
X-Google-Smtp-Source: ABdhPJyzLh4+4RYsO/asZxweiS+3kfoIRqnlZul76oRf1gkmSfWthNYwOBxbmtme6e2PCA1VAzB94IAPZBwqLKwMQas=
X-Received: by 2002:a17:902:76c5:b0:14e:e325:9513 with SMTP id
 j5-20020a17090276c500b0014ee3259513mr26122389plt.55.1645592815604; Tue, 22
 Feb 2022 21:06:55 -0800 (PST)
MIME-Version: 1.0
References: <20220223013529.67335-1-zhuyan34@huawei.com>
In-Reply-To: <20220223013529.67335-1-zhuyan34@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 22 Feb 2022 21:06:44 -0800
Message-ID: <CAADnVQKmBoQEG1+nmrCg2ePVncn9rZJX9R4eucP9ULiY=xVGjQ@mail.gmail.com>
Subject: Re: [PATCH] bpf: move the bpf syscall sysctl table to its own module
To:     Yan Zhu <zhuyan34@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "Luis R. Rodriguez" <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Iurii Zaikin <yzaikin@google.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        zengweilin@huawei.com, liucheng32@huawei.com,
        Xiaoming Ni <nixiaoming@huawei.com>, xiechengliang1@huawei.com
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

On Tue, Feb 22, 2022 at 5:35 PM Yan Zhu <zhuyan34@huawei.com> wrote:
>
> Sysctl table is easier to read under its own module.

"own module"?
What are you talking about?
It's not "easier to read" and looks like a pointless churn.

> Signed-off-by: Yan Zhu <zhuyan34@huawei.com>
> ---
>  kernel/bpf/syscall.c | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sysctl.c      | 71 ----------------------------------------------
>  2 files changed, 80 insertions(+), 71 deletions(-)
