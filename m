Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D85AB4A3380
	for <lists+netdev@lfdr.de>; Sun, 30 Jan 2022 04:24:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346550AbiA3DYf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jan 2022 22:24:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233631AbiA3DYe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jan 2022 22:24:34 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89745C061714;
        Sat, 29 Jan 2022 19:24:34 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id x11so9601131plg.6;
        Sat, 29 Jan 2022 19:24:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9FFTPRo1ckhhB49b7ONOxUt8kngEsKVIvbF1sVTmt/4=;
        b=U89GNBjeWygL7EqhNjqrhmmPiksJpQDJKXhXK6hODoZQQJAZiELHz5SsAYNKRMnqsQ
         4m22UVupd733icWt2/FVKrL89JZpVwnfjhMSDes/sfNJbEb5yTEhEp5RDRJgsztIgPWT
         F5xx9rNvc1LPAo2Hfs6c5AdJnMn3vFb3iLZpCTrdTIcYSKEJrHZ0ziCB79MeBztqmXz4
         QBOXq1iRat58ipcdw1pUcFdJbAFMJYtVdGd8c9T8WQwAv7q3RM3RzYj5oMrj359afWLh
         kGLPaDG99xCEslQgubgLLniKmTjdAbQyHF8EQ7q6Y5e4gxeKsiQgytxMM91yGpZV4aGn
         ubbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9FFTPRo1ckhhB49b7ONOxUt8kngEsKVIvbF1sVTmt/4=;
        b=0LWp3xAUbtMdIM8899fm2DrinoL6bsfkJvoDaaWBwqasRrJllBmGDclmUDmKVJ0LYt
         RMwhCygIiQf4UIrz/hgHruyvRGA1l4IvNU3alRXpnUlA8CX6yyTsL12aYPQHXqa8Uc6f
         1N+NYaKAvTfXw3YiknPJmiuKQdry/+tv8l2mngMjyJmgdsgW/6Qg1J7D9p9ufMkF3PUr
         5szmDbzsCdTEWJatHpe8Ej71Fqr52hKiTg9fkm4mz4MgI4J7Z3JG0bP+1kcMpG573Ide
         0zlUmwGRxQaHB2AGINir2mGy9Gp7zTQ7wTnA5xTnMQAgOPVWFJvN60JGucrNNaJzOuMY
         u/1g==
X-Gm-Message-State: AOAM533FvHgp0bw7klG8CTj0PaDmdYLzmu1CMitWlWw8tAYWsO1H70fr
        7evFu+YVKeFsEmplwFGyYvqfUDg1G0hwiEOcS30=
X-Google-Smtp-Source: ABdhPJww7iq0LVImSpVjIhrRV3uTdPmM26QE4/u/LWzFds87ER0EpkxN5SOIDtsWpLZSNQSMsXUbX4bmU2Kj6x4sGik=
X-Received: by 2002:a17:902:b682:: with SMTP id c2mr14899085pls.126.1643513073847;
 Sat, 29 Jan 2022 19:24:33 -0800 (PST)
MIME-Version: 1.0
References: <20220130030352.2710479-1-hefengqing@huawei.com>
In-Reply-To: <20220130030352.2710479-1-hefengqing@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 29 Jan 2022 19:24:22 -0800
Message-ID: <CAADnVQLsom4MQq2oonzfCqrHbhfg9y7YMPCk6Wg6r4bp3Su03g@mail.gmail.com>
Subject: Re: [bpf-next] bpf: Add CAP_NET_ADMIN for sk_lookup program type
To:     He Fengqing <hefengqing@huawei.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Marek Majkowski <marek@cloudflare.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 29, 2022 at 6:16 PM He Fengqing <hefengqing@huawei.com> wrote:
>
> SK_LOOKUP program type was introduced in commit e9ddbb7707ff
> ("bpf: Introduce SK_LOOKUP program type with a dedicated attach point"),
> but the commit did not add SK_LOOKUP program type in net admin prog type.
> I think SK_LOOKUP program type should need CAP_NET_ADMIN, so add SK_LOOKUP
> program type in net_admin_prog_type.

I'm afraid it's too late to change.

Jakub, Marek, wdyt?


> Fixes: e9ddbb7707ff ("bpf: Introduce SK_LOOKUP program type with a dedicated attach point")
>
> Signed-off-by: He Fengqing <hefengqing@huawei.com>
> ---
>  kernel/bpf/syscall.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 9befb1123770..2a8a4a5266fb 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2163,6 +2163,7 @@ static bool is_net_admin_prog_type(enum bpf_prog_type prog_type)
>         case BPF_PROG_TYPE_SK_MSG:
>         case BPF_PROG_TYPE_LIRC_MODE2:
>         case BPF_PROG_TYPE_FLOW_DISSECTOR:
> +       case BPF_PROG_TYPE_SK_LOOKUP:
>         case BPF_PROG_TYPE_CGROUP_DEVICE:
>         case BPF_PROG_TYPE_CGROUP_SOCK:
>         case BPF_PROG_TYPE_CGROUP_SOCK_ADDR:
> --
> 2.25.1
>
