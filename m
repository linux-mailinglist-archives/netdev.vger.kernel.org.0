Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 445C853D316
	for <lists+netdev@lfdr.de>; Fri,  3 Jun 2022 23:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348264AbiFCVFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jun 2022 17:05:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231235AbiFCVFY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Jun 2022 17:05:24 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61A8F1D0EE;
        Fri,  3 Jun 2022 14:05:22 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id l30so14446573lfj.3;
        Fri, 03 Jun 2022 14:05:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rdCC350CRfTnlMVl9hZPunLr7i2db8KX60dDtm/jhb4=;
        b=dtlC/kgJuVZ3CpEdyshW/IR+2qIgLu09prKB5QevJec1hXcL9NpbvvzgNZ71mOaAiZ
         PftpokKOYCrGeork8uYNkaZozFeRadECDkdIa16Jn4C/UQtALgI6m446ReodOYVPs+Kk
         Kejoro6Tj3+9RBJ/zDzt6A1+Co7sMDJnAiH3pOJ5YsamY4dDsQYB5nte2cBU8u0S7/GB
         u4AYa+ZGfS/5XzGXrNdKIn0k1wBWzELkZRwu2sJ+63YdiywR+SyoxwBfilufmJboPU+o
         caid2AT5hUUlS8YLSUyMINY4lZO28FEotMfq4nVHXqBuFNUVmpLr3MWsHN55PMWHTMAV
         /M7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rdCC350CRfTnlMVl9hZPunLr7i2db8KX60dDtm/jhb4=;
        b=RfDLVmuozmgPtcBS05wywyXpL/qDYL5EJqGUX3HFQ/Y+k9sW9m2THQyrYIS7QspLe/
         gmbJHQgbTpLtXaH8/458ZsTfXynWFe3IKHSQ3zgeaeIHdfMN2wd/TsxQaoTTPzPRq9p7
         PkZjuVjW3OaYg31+7x+sNqPdaXbfkoWjWVpTMbgt9pRwrWeav6djonF9DEh7My4GXx4Y
         8wKy07q1oNpEK/sqPz4+RlwxA/geV6e7UfnYKDZp4a2fmv426zXmp+nANPYRS0PdTwRy
         c54DgeYjpvz151q3rISSBhhjqQR7Lj7aIf1PCGy9xWNCBR9itmqkameO3B6o9gHCUKoT
         5ijw==
X-Gm-Message-State: AOAM532QXQCakQ/sLN2urSOFmYTz6co0IGzgc0uwN3q9ejASQZwtnaJv
        fHXY3IxD1NFJMWKkA3H9Iq0QOsGlaxhZ0fZx2Bs=
X-Google-Smtp-Source: ABdhPJxQRsoWD2DZFdgj6bMc6YwCRCjL0tBk07f4Tytq4xquHn/ejDy48a4Wxbt7fLch3VWacC+ZwogYEJcokg0BPXo=
X-Received: by 2002:a05:6512:2625:b0:478:5a51:7fe3 with SMTP id
 bt37-20020a056512262500b004785a517fe3mr7697698lfb.158.1654290320714; Fri, 03
 Jun 2022 14:05:20 -0700 (PDT)
MIME-Version: 1.0
References: <20220530092815.1112406-1-pulehui@huawei.com> <20220530092815.1112406-7-pulehui@huawei.com>
In-Reply-To: <20220530092815.1112406-7-pulehui@huawei.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 3 Jun 2022 14:05:09 -0700
Message-ID: <CAEf4Bza4RT=KFhr9ev29967dyT0eF_+6ZRqK35beUvnA_NbcqQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 6/6] selftests/bpf: Remove the casting about
 jited_ksyms and jited_linfo
To:     Pu Lehui <pulehui@huawei.com>
Cc:     bpf <bpf@vger.kernel.org>, linux-riscv@lists.infradead.org,
        Networking <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Luke Nelson <luke.r.nels@gmail.com>,
        Xi Wang <xi.wang@gmail.com>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>
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

On Mon, May 30, 2022 at 1:58 AM Pu Lehui <pulehui@huawei.com> wrote:
>
> We have unified data extension operation of jited_ksyms and jited_linfo
> into zero extension, so there's no need to cast u64 memory address to
> long data type.
>
> Signed-off-by: Pu Lehui <pulehui@huawei.com>
> ---
>  tools/testing/selftests/bpf/prog_tests/btf.c | 14 +++++++-------
>  1 file changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/btf.c b/tools/testing/selftests/bpf/prog_tests/btf.c
> index e6612f2bd0cf..65bdc4aa0a63 100644
> --- a/tools/testing/selftests/bpf/prog_tests/btf.c
> +++ b/tools/testing/selftests/bpf/prog_tests/btf.c
> @@ -6599,8 +6599,8 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>         }
>
>         if (CHECK(jited_linfo[0] != jited_ksyms[0],
> -                 "jited_linfo[0]:%lx != jited_ksyms[0]:%lx",
> -                 (long)(jited_linfo[0]), (long)(jited_ksyms[0]))) {
> +                 "jited_linfo[0]:%llx != jited_ksyms[0]:%llx",
> +                 jited_linfo[0], jited_ksyms[0])) {

__u64 is not always printed with %lld, on some platforms it is
actually %ld, so to avoid compiler warnings we just cast them to long
long or unsigned long long (and then %lld or %llu is fine). So please
update this part here and below.

>                 err = -1;
>                 goto done;
>         }
> @@ -6618,16 +6618,16 @@ static int test_get_linfo(const struct prog_info_raw_test *test,
>                 }
>
>                 if (CHECK(jited_linfo[i] <= jited_linfo[i - 1],
> -                         "jited_linfo[%u]:%lx <= jited_linfo[%u]:%lx",
> -                         i, (long)jited_linfo[i],
> -                         i - 1, (long)(jited_linfo[i - 1]))) {
> +                         "jited_linfo[%u]:%llx <= jited_linfo[%u]:%llx",
> +                         i, jited_linfo[i],
> +                         i - 1, jited_linfo[i - 1])) {
>                         err = -1;
>                         goto done;
>                 }
>
>                 if (CHECK(jited_linfo[i] - cur_func_ksyms > cur_func_len,
> -                         "jited_linfo[%u]:%lx - %lx > %u",
> -                         i, (long)jited_linfo[i], (long)cur_func_ksyms,
> +                         "jited_linfo[%u]:%llx - %llx > %u",
> +                         i, jited_linfo[i], cur_func_ksyms,
>                           cur_func_len)) {
>                         err = -1;
>                         goto done;
> --
> 2.25.1
>
