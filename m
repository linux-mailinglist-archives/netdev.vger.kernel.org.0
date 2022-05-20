Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425C952F5BB
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 00:35:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353924AbiETWfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 18:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353916AbiETWfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 18:35:51 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15E712AD7;
        Fri, 20 May 2022 15:35:50 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id m20so17991354ejj.10;
        Fri, 20 May 2022 15:35:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f6mQZ2563VnlVljlnpofq/t3QXLtb3EyEH3JMTBfeGQ=;
        b=iotslgJFN236L7y2ZEavwT9L/z3aaIolNpPkRq9eT0tCpVAmHk6q6NvyoYWHc5kj56
         pNpYh2ztZsQUSXvHi17wV89W2v9sVRutHctsdO7gQK5OEN3KyCC4qZ9WvTWVkjbu5Ad+
         Iwc2B9CXMS0ZV/HzN6nItNIA7a7CxaGKuz6WYpiKIBxVIgh5q/7aWmR6quJ/2hqMpTj/
         Q02LDA1TLMrHq6z98BQ7ffP+cL7pZkkvtNybtEe1Ua2i1GyA9L31REPnRqdeyAn2fi13
         o5sP6/JCkuA5NwtHon4qECwnzaVPpxKZHQ46QiSfnAlu7dlfw77kDYxQtSQMM/knHpyO
         1w7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f6mQZ2563VnlVljlnpofq/t3QXLtb3EyEH3JMTBfeGQ=;
        b=sxmEXzLOvtBCscOR8owM+cxfRBT6MvTzX1mWwapjGZe+BaTH9iL9E0l5LdBudchHrz
         16dfnjQcbBbMh25bKREqCzzrG7b3GkpCPOTES4ny0/1Zvkam5yAxzEL/mkNQ555Xkmlk
         2E5I+DEbOvlO3WHD8sqie+FwPUmDjOEThlPOvmyupcLbTa/yofHoeWrH15l+HXvk+T7z
         bynHOZQYbO90a88Px9dfraSWijfCntV0ZKZmYlstz2SiAatHOhipv1Nyy3PVQNz0lWSc
         XaIyHj1vn2agwkMm/3TgtZsU6/84FD4J3PG2rb9t3+7DzLS7FEfCD13X5rzYF5DuQVZl
         sg+w==
X-Gm-Message-State: AOAM532KEXWeg/s4xrJa2n8cwJwZs0Fmt71yPRSWH0ulBidvFVrXnk/m
        1DVdbS5gWP/qy6V4vPH2gS+QLZBLlDVAwxQL86A=
X-Google-Smtp-Source: ABdhPJxXYuqnkxBLmgyHT7uOpLrSg1TsNNjRa83aVTBxZgCYJar2Sya0THdKD+e0CrIp7bOv8zRAWZBD6oVe7rmb68E=
X-Received: by 2002:a17:907:3da1:b0:6fe:ae46:997d with SMTP id
 he33-20020a1709073da100b006feae46997dmr4317372ejc.633.1653086149126; Fri, 20
 May 2022 15:35:49 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1652982525.git.esyr@redhat.com>
In-Reply-To: <cover.1652982525.git.esyr@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 20 May 2022 15:35:36 -0700
Message-ID: <CAADnVQLVoUMwuJa=dzCModQC1K9sqi2+w_AdSk+uK+ynkpdaQQ@mail.gmail.com>
Subject: Re: [PATCH bpf v4 0/3] Fix kprobe_multi interface issues for 5.18
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Jiri Olsa <jolsa@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
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

On Thu, May 19, 2022 at 11:14 AM Eugene Syromiatnikov <esyr@redhat.com> wrote:
>
> Hello.
>
> While [1] seems to require additional work[2] due to changes
> in the interface (and it has already been re-targeted for bpf-next),
> I would like to ask to consider the following three patches, that fix
> possible out-of-bounds write, properly disable the interface
> for 32-bit compat user space, and prepare the libbpf interface change,
> for the 5.18 release.  Thank you.

5.19 is imminent. All fixes should go into bpf-next and backported later.
