Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC0EF57E441
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 18:20:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235603AbiGVQUx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 12:20:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbiGVQUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 12:20:52 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E217F87228;
        Fri, 22 Jul 2022 09:20:50 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id z22so6452218edd.6;
        Fri, 22 Jul 2022 09:20:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVC7VH4dan2A6lIJvHCy/zypzAUG5xpdNLmt95eeeH0=;
        b=Q1d+Pjppof/gqv0B7nIuyeAH00eiJSaKutpIB2CZ/+EK1FONt/1ST2s+gYIOMqs5lq
         e99rqflAaCuYMucMnb2LavMYUkIVzd6Knm4mvn35pGM2uEUuYLEv39lYAyTR/KCF1J3k
         K0nDSsL6/7nfcBMeecaXQzhaKdyGxEiYlPV1fwl0AUBYXYlrPIenQBNO7NzotEo0oJmk
         7mon5tTLOnFSLAsHYRgueRTjmir9uSaFCNWhNNooiw6lmV/fl/C8fKqfqVWk/96FX0Bl
         N5qbgF983FkNt1YzwmVUZt+2BLjjvZHBZ+BE77IemHcvDwkVawmzkDdKJDp9PqVaOZpl
         EamQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVC7VH4dan2A6lIJvHCy/zypzAUG5xpdNLmt95eeeH0=;
        b=sUCpPLRuDP5MQY7xj0RSdYxnAY0qViZMBg4yhuBuK4Bq2hOVlNpYlJl0La3fZ+xLo6
         xx27lXFKE/AeykTMjO9B+Szy1I/8bMMjHGUOVEEzy4bx3LPe8kIjpZ9d0PKp9on65jwl
         GXjxouDtrVMjLDD1iwtn5SF8d7eAp5yG1ToO0ZoVpZtqUJMLAbeCy/4onDKZy3ieS/Fs
         TuC/zg4dsZLbQZTuyLnO0zSmIh1bkgykl/wB3OQoYsStH4aJY96S8IepwfLbCUCxc7fH
         GGTMoEze/55etiw9eA9dq3bSa9RioBv/+iTwmSQlxKfxw2nFZU7vdwajvVNdrDkjAldq
         MLwg==
X-Gm-Message-State: AJIora+r15rm/yLo9U3YO+165WA+QR/hyhWaS30DNCy2YVuzoth2xjT4
        7Pr8mGJWGNN1vecWEtsRWoGaACXXvlzLOajYu9g=
X-Google-Smtp-Source: AGRyM1v8tX9AlPjaUUQNq6sWzJYaGf5FllTis+XOUgeI5WKLL4UcG0LqykqgOOfxD5pSj/RLtAmDFMoEaYztTEZfog8=
X-Received: by 2002:a05:6402:350c:b0:43a:e25f:d73 with SMTP id
 b12-20020a056402350c00b0043ae25f0d73mr680596edd.66.1658506849261; Fri, 22 Jul
 2022 09:20:49 -0700 (PDT)
MIME-Version: 1.0
References: <20220722021313.3150035-1-yosryahmed@google.com> <20220722021313.3150035-2-yosryahmed@google.com>
In-Reply-To: <20220722021313.3150035-2-yosryahmed@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 22 Jul 2022 09:20:38 -0700
Message-ID: <CAADnVQ+c7uuVXukguvy9x2HjM9K8rj6LOa_QJ_n+MVB-bOx3uQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/8] btf: Add a new kfunc set which allows to
 mark a function to be sleepable
To:     Yosry Ahmed <yosryahmed@google.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Hao Luo <haoluo@google.com>, Tejun Heo <tj@kernel.org>,
        Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shuah Khan <shuah@kernel.org>,
        Michal Hocko <mhocko@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
        Roman Gushchin <roman.gushchin@linux.dev>,
        David Rientjes <rientjes@google.com>,
        Stanislav Fomichev <sdf@google.com>,
        Greg Thelen <gthelen@google.com>,
        Shakeel Butt <shakeelb@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 7:13 PM Yosry Ahmed <yosryahmed@google.com> wrote:
>
> From: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> This allows to declare a kfunc as sleepable and prevents its use in
> a non sleepable program.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> ---
>  include/linux/btf.h |  2 ++
>  kernel/bpf/btf.c    | 13 +++++++++++--
>  2 files changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/btf.h b/include/linux/btf.h
> index 1bfed7fa0428..6e7517573d9e 100644
> --- a/include/linux/btf.h
> +++ b/include/linux/btf.h
> @@ -18,6 +18,7 @@ enum btf_kfunc_type {
>         BTF_KFUNC_TYPE_RELEASE,
>         BTF_KFUNC_TYPE_RET_NULL,
>         BTF_KFUNC_TYPE_KPTR_ACQUIRE,
> +       BTF_KFUNC_TYPE_SLEEPABLE,
>         BTF_KFUNC_TYPE_MAX,
>  };

This patch needs refactoring using the new BTF_ID_FLAGS scheme.
When you do that please update the Documentation/bpf/kfuncs.rst as well.

Thanks!
