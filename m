Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C97E1B5454
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 07:43:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726796AbgDWFnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 01:43:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725854AbgDWFnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 01:43:39 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AC9C03C1AB;
        Wed, 22 Apr 2020 22:43:37 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id j14so3711656lfg.9;
        Wed, 22 Apr 2020 22:43:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=I2UvogU+zAttqM+UN7V1qh3mILPYKdcdnvM9RFKUig8=;
        b=heJ49tVZFRBACNLa5zBn5n2tYnQ5miAZgU4IeW89HuIYYGSZxxiC+4CdoqNUnj4nOL
         x2K43lna6E1GDIuB10cIdAmRAuYlPbSmhfBB1JJhdKbVs/Bz7/ooZqA7swc7J+X9UEa6
         5pazITw+HrqoS3jmUJW7B1hFbVBIorhBgkbxpq/uNWea8kwO1Pkrhv3Y4K0hAIMC8bbZ
         y+qycG0HPgTMNub/Rti1jBwZ6+8Imc6EnHv9pQJTTGKO2TBMMFM7xucC5OVcR9WsiALt
         0xsgCak/eQWxsOxR640EnUE0vcb/dB8Yn4fal6eupxHVj5Tm9SbKy8eMyuSXmv6lRPzR
         1IeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=I2UvogU+zAttqM+UN7V1qh3mILPYKdcdnvM9RFKUig8=;
        b=DW+r457U8Vs3uL1eb0zv1EjPKCQJUcsWlJzK46cpYe1FgVnAbGIf47BcJdBiR2rBhm
         klkCn627ivy1ikPkjUMInXmtc87kt5tSCOJUQpPFSB1VBNF8SRmnx00AZdx9PMzxzYFn
         JJ7yLTD0ZeQ8rYGoHvq8nexlPS1uycXp7oKIFqetnLuDL5b91dGah7wB4FKDkK/M1DrA
         w7h9+NwmoVvhciqrXEaqAoKw6ayC9EYK6ccD/Qz3jMK6wJ9+UfQBaWRc49FUiqsQqLcd
         kL9mtqQuQripKOir0zx7Fu95QVQ8QqPW8+nAlKVQ9R2oE4Te+ZfrQ461Yvjh1cXC7LtE
         sxtw==
X-Gm-Message-State: AGi0Pua/qVybykHDk4F5q1+EfvdpEc9CdPhAe5BkK9dyMlwQXMW+niJF
        Ag50zfjfFLm1CQlWbCjTuA/gIPjfSzYDfWeQfSA=
X-Google-Smtp-Source: APiQypIvvrxeH1I47KnX+fDdysX9+aRpyk3+HEQfUukT9P/xgPoPkCvGXe17BAS2eFbjM3JY0TcVCfasQ6TOqYIM1o4=
X-Received: by 2002:ac2:569b:: with SMTP id 27mr1312043lfr.134.1587620615984;
 Wed, 22 Apr 2020 22:43:35 -0700 (PDT)
MIME-Version: 1.0
References: <20200422093329.GI2659@kadam> <20200423033314.49205-1-maowenan@huawei.com>
 <20200423033314.49205-2-maowenan@huawei.com>
In-Reply-To: <20200423033314.49205-2-maowenan@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Apr 2020 22:43:24 -0700
Message-ID: <CAADnVQLfqLBzsjK0KddZM7WTL3unzWw+v18L0pw8HQnWsEVUzA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 1/2] bpf: Change error code when ops is NULL
To:     Mao Wenan <maowenan@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 8:31 PM Mao Wenan <maowenan@huawei.com> wrote:
>
> There is one error printed when use BPF_MAP_TYPE_SOCKMAP to create map:
> libbpf: failed to create map (name: 'sock_map'): Invalid argument(-22)
>
> This is because CONFIG_BPF_STREAM_PARSER is not set, and
> bpf_map_types[type] return invalid ops. It is not clear to show the
> cause of config missing with return code -EINVAL, so add pr_warn() and
> change error code to describe the reason.
>
> Signed-off-by: Mao Wenan <maowenan@huawei.com>
> ---
>  kernel/bpf/syscall.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index d85f37239540..7686778457c7 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -112,9 +112,10 @@ static struct bpf_map *find_and_alloc_map(union bpf_attr *attr)
>                 return ERR_PTR(-EINVAL);
>         type = array_index_nospec(type, ARRAY_SIZE(bpf_map_types));
>         ops = bpf_map_types[type];
> -       if (!ops)
> -               return ERR_PTR(-EINVAL);
> -
> +       if (!ops) {
> +               pr_warn("map type %d not supported or kernel config not opened\n", type);
> +               return ERR_PTR(-EOPNOTSUPP);
> +       }

I don't think users will like it when kernel spams dmesg.
If you need this level of verbosity please teach consumer of libbpf to
print them.
It's not a job of libbpf either.
