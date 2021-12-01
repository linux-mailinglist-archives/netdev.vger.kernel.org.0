Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD1DE46542F
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 18:43:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231466AbhLARq7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 12:46:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351987AbhLARqH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 12:46:07 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CC8C061574;
        Wed,  1 Dec 2021 09:42:45 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id r130so25335612pfc.1;
        Wed, 01 Dec 2021 09:42:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iWH/ar/+00VtjVI5Hnr6356lMajui9iWQYljePwod8U=;
        b=dDCmcVxBj39SYfgYQzquqEjVqLfUU2pDNVFM0Jj0xTPM9Tc34rLnQIK/khA8EXWUoF
         Zr4R49Hddf2tkGfrwz9zfXlZQUZTEYGkq9PbcDoqjrOV08vk0QwoJJV64gKsUtLVn/7U
         RwHyEXz8hiF62h9iLnRbLQYaimmAOUHiZVFOjj9xKf/TCAaSEbM8v4nik8Z42BZd7kWJ
         aUtc7XZpaqbmjQuiVYCcNsrZbuvJMR42NlA85SqW754r5toucokM4Q2wjnS2mMfJDV7j
         6OBoNsW263VsCZPSK0dF0XO+Ez2XCk1toWiaOquq7xlU7ZW4zWLOK3YB7HQAQzYL+dm6
         Y2CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iWH/ar/+00VtjVI5Hnr6356lMajui9iWQYljePwod8U=;
        b=UQmfyLsTT0SYCR9rQvYshRGu958n/oxQzZwoG1EuwZ5LzAjZkAt95lyO4esfB21Byq
         lj09tmHfPTrN8L73zSex7Mrg+j3ux+DmCCAtlm19HTNCPFY7cauF8erjuZJqpDnKYtoD
         5h7GSHW4NUMUSGP7BugalPn7G0aWDwl4S8fjvQkG7iL50YlojFl8D0e6OqrxbxpKr3PB
         ztW75bnJTJBtrwLO+4ppUrjv2YCLwfg9Y7tP7h73pHLaDJFMGR6tUHGwaHk1UoaAoP8P
         Lw4vjFCuuLSNuTaVzvpirnDLoTgqzvQdRrdmSUvaF9JwRADGj9R/AOEpDZbA4q+WMreh
         Cu9g==
X-Gm-Message-State: AOAM5300WfqkZl7O5Y06h/6q8mdJm6Gko+rnA9WAIXkylo+eDp1sL8w6
        L3nwOqqQdVceeMKQ1KeYUSNA9up9E9c8SsNNHDA=
X-Google-Smtp-Source: ABdhPJxW0thgchLSff5CTydhX6Xw98SHpr474V21SLRykJYU4Is7MykndNsE5eDL5iCG7XnDTctWCpSfopLDoQ1U6q4=
X-Received: by 2002:a63:ce54:: with SMTP id r20mr5718071pgi.95.1638380565422;
 Wed, 01 Dec 2021 09:42:45 -0800 (PST)
MIME-Version: 1.0
References: <20211201073458.2731595-1-houtao1@huawei.com> <20211201073458.2731595-3-houtao1@huawei.com>
In-Reply-To: <20211201073458.2731595-3-houtao1@huawei.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 1 Dec 2021 09:42:34 -0800
Message-ID: <CAADnVQ+LDW+K_3czmiTcU4CtONxM+eTkyuwwra5hGTqAXTCcZw@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 2/2] bpf: disallow BPF_LOG_KERNEL log level
 for bpf(BPF_BTF_LOAD)
To:     Hou Tao <houtao1@huawei.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 30, 2021 at 11:19 PM Hou Tao <houtao1@huawei.com> wrote:
>
> BPF_LOG_KERNEL is only used internally, so disallow bpf_btf_load()
> to set log level as BPF_LOG_KERNEL. The same checking has already
> been done in bpf_check(), so factor out a helper to check the
> validity of log attributes and use it in both places.
>
> Fixes: 8580ac9404f6 ("bpf: Process in-kernel BTF")
> Signed-off-by: Hou Tao <houtao1@huawei.com>
> Acked-by: Yonghong Song <yhs@fb.com>
> Acked-by: Martin KaFai Lau <kafai@fb.com>
> ---
>  include/linux/bpf_verifier.h | 7 +++++++
>  kernel/bpf/btf.c             | 3 +--
>  kernel/bpf/verifier.c        | 6 +++---
>  3 files changed, 11 insertions(+), 5 deletions(-)
>
> diff --git a/include/linux/bpf_verifier.h b/include/linux/bpf_verifier.h
> index c8a78e830fca..a3d17601a5a7 100644
> --- a/include/linux/bpf_verifier.h
> +++ b/include/linux/bpf_verifier.h
> @@ -396,6 +396,13 @@ static inline bool bpf_verifier_log_needed(const struct bpf_verifier_log *log)
>                  log->level == BPF_LOG_KERNEL);
>  }
>
> +static inline bool
> +bpf_verifier_log_attr_valid(const struct bpf_verifier_log *log, u32 max_total)
> +{
> +       return log->len_total >= 128 && log->len_total <= max_total &&
> +              log->level && log->ubuf && !(log->level & ~BPF_LOG_MASK);
> +}
> +
>  #define BPF_MAX_SUBPROGS 256
>
>  struct bpf_subprog_info {
> diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
> index 6b9d23be1e99..308c345cd811 100644
> --- a/kernel/bpf/btf.c
> +++ b/kernel/bpf/btf.c
> @@ -4472,8 +4472,7 @@ static struct btf *btf_parse(bpfptr_t btf_data, u32 btf_data_size,
>                 log->len_total = log_size;
>
>                 /* log attributes have to be sane */
> -               if (log->len_total < 128 || log->len_total > UINT_MAX >> 8 ||
> -                   !log->level || !log->ubuf) {
> +               if (!bpf_verifier_log_attr_valid(log, UINT_MAX >> 8)) {
>                         err = -EINVAL;
>                         goto errout;
>                 }
> diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
> index 722aea00d44e..f128e6799cb5 100644
> --- a/kernel/bpf/verifier.c
> +++ b/kernel/bpf/verifier.c
> @@ -13969,11 +13969,11 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr, bpfptr_t uattr)
>                 log->ubuf = (char __user *) (unsigned long) attr->log_buf;
>                 log->len_total = attr->log_size;
>
> -               ret = -EINVAL;
>                 /* log attributes have to be sane */
> -               if (log->len_total < 128 || log->len_total > UINT_MAX >> 2 ||
> -                   !log->level || !log->ubuf || log->level & ~BPF_LOG_MASK)
> +               if (!bpf_verifier_log_attr_valid(log, UINT_MAX >> 2)) {
> +                       ret = -EINVAL;

It's actually quite bad that we have this discrepancy in limits.
I've already sent a patch to make them the same.
It was a pain to debug.
https://lore.kernel.org/bpf/20211124060209.493-7-alexei.starovoitov@gmail.com/
"
Otherwise tools that progressively increase log size and use the same log
for BTF loading and program loading will be hitting hard to debug EINVAL.
"
