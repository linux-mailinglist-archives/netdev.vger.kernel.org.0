Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8DEC2931E7
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 01:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgJSXXc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 19:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727308AbgJSXXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 19:23:31 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BDC2C0613CE;
        Mon, 19 Oct 2020 16:23:31 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id j30so2136857lfp.4;
        Mon, 19 Oct 2020 16:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jumSGnyK5m4rz5xYaRgLru4Mo/33UUYU9j3sle9Ju7Y=;
        b=COYfjNaU4KEckwcXDqg23ka++9UHxOOqqyG1xPi6oNFsAQKRa2vCH0OkB686KcyqzO
         fH6t/sBm2C64rzY4Xyww1mXCjtxjlSz7/WhaaWH4B9yrIdmwVPmpgEUQVZx6WkhyszZs
         vVxG0QJwMZLdNPPaeTwnwEgbrPcJXWo49qoxMAeL7xHME8lFE4HIWjev5QHETuiQkE0Y
         eF9xzsAYuUFHkfNb6ACigONqnUgcBx+Hs2SobnLRZSOiCDHS+ztPX+pPk8VryiaFWi3q
         HZbCzBiySWN0dCBMDy1MUXsRyobWqEFlHHF/nLVtp951TkqU55ue9wZgvhBfSKCVoM/y
         jSPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jumSGnyK5m4rz5xYaRgLru4Mo/33UUYU9j3sle9Ju7Y=;
        b=fb/ri3BRqdVqS3bgnVq/G/Hm6HcuYUTMKdxlxsbHwoxQXoHjqbomeziFnuhq9thysF
         MJy5TmuSYLcQvpD3TQDWuWfGsT52EMZAPkimHv6iAmDE4Ld+UP2w92w2H8V3pi6KmXyt
         Yj0EtoH5ciBiy9aGzy8PwYgEH3n9v1aaLWojonQPk/PlnjbGsGUJWZSzu9OaWfvZYtml
         DHsD/tr8+ucu+V1mJ6WSo9vtmerhLEw7egJJ6uqgBS5ADNBZ/IO4rZtNyKl+SELsbkVR
         a3Yhn7lGrN8OKALjq4TEdn9UUfRMrbb+UIi26yYdR7jameaYo/E1tQSTZaMPCMWr08Bv
         xKng==
X-Gm-Message-State: AOAM532SFfcMjaJhUZemZKiJL8mCFVUPoQXQLkYKyMek82LRiivhTWd3
        bkMYzLRKyOmYdf2Myt5WAUFAdg7xJY/br8pNHmg=
X-Google-Smtp-Source: ABdhPJwIQq8vdbyxmO5fkq5jS9Sd3Y6XMRCNqbwowXhxBvnxn3ifRY8jEISnoprVQwnngPSGB77y+H9iWyUi8af/nbw=
X-Received: by 2002:a19:c30a:: with SMTP id t10mr650430lff.196.1603149809619;
 Mon, 19 Oct 2020 16:23:29 -0700 (PDT)
MIME-Version: 1.0
References: <20201019194206.1050591-1-kafai@fb.com> <20201019194212.1050855-1-kafai@fb.com>
In-Reply-To: <20201019194212.1050855-1-kafai@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 19 Oct 2020 16:23:18 -0700
Message-ID: <CAADnVQJkpgY1aowy5UhZJyeKwAFQb=5W+4j-G8DJSqMLDM5DkA@mail.gmail.com>
Subject: Re: [PATCH bpf 1/3] bpf: Enforce id generation for all may-be-null
 register type
To:     Martin KaFai Lau <kafai@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Hao Luo <haoluo@google.com>, Kernel Team <kernel-team@fb.com>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 12:43 PM Martin KaFai Lau <kafai@fb.com> wrote:
>
> The commit af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
> introduces RET_PTR_TO_BTF_ID_OR_NULL and
> the commit eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
> introduces RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL.
> Note that for RET_PTR_TO_MEM_OR_BTF_ID_OR_NULL, the reg0->type
> could become PTR_TO_MEM_OR_NULL which is not covered by
> BPF_PROBE_MEM.
>
> The BPF_REG_0 will then hold a _OR_NULL pointer type. This _OR_NULL
> pointer type requires the bpf program to explicitly do a NULL check first.
> After NULL check, the verifier will mark all registers having
> the same reg->id as safe to use.  However, the reg->id
> is not set for those new _OR_NULL return types.  One of the ways
> that may be wrong is, checking NULL for one btf_id typed pointer will
> end up validating all other btf_id typed pointers because
> all of them have id == 0.  The later tests will exercise
> this path.
>
> To fix it and also avoid similar issue in the future, this patch
> moves the id generation logic out of each individual RET type
> test in check_helper_call().  Instead, it does one
> reg_type_may_be_null() test and then do the id generation
> if needed.
>
> This patch also adds a WARN_ON_ONCE in mark_ptr_or_null_reg()
> to catch future breakage.
>
> The _OR_NULL pointer usage in the bpf_iter_reg.ctx_arg_info is
> fine because it just happens that the existing id generation after
> check_ctx_access() has covered it.  It is also using the
> reg_type_may_be_null() to decide if id generation is needed or not.
>
> Fixes: af7ec1383361 ("bpf: Add bpf_skc_to_tcp6_sock() helper")
> Fixes: eaa6bcb71ef6 ("bpf: Introduce bpf_per_cpu_ptr()")
> Cc: Yonghong Song <yhs@fb.com>
> Cc: Hao Luo <haoluo@google.com>
> Signed-off-by: Martin KaFai Lau <kafai@fb.com>

Good catch. The fix makes sense to me. Applied.
