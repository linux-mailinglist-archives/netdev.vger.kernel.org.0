Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8861686EAE
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 20:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231681AbjBATKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 14:10:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231552AbjBATKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 14:10:43 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C5296468F
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 11:10:42 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id 7so13242099pga.1
        for <netdev@vger.kernel.org>; Wed, 01 Feb 2023 11:10:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6ilVhJc0KLaqYnWcVF2XM/01kZ5HMNBRjsvcGb6cfig=;
        b=Vof8VT7+R99GRr4Zp5nO/gYx5VOCsXms2LfF7NNN6i2WZzpvDV7nHXdawp3ox3qAD2
         C18J8JBT6tiMZnIMZ22WNgEs5WNRbsEFppuwWfH2jKbc6MkmGt1bXmsV+J3W+ItUTjMu
         ZM9jqgc5kiJ3iirH0HXxLAfdlaEJyF4iFprmXWJCRy+q6XMID1ajLiuwgDIwNpmEL3uY
         /qW17kORqcUfBKZ4jE3DmaxowVnAjwy1/KjFGO0rsatoo7NWCMwT/Jxlgn0Oyly11l/v
         C2n2+yjXplD0wLBnqWa4Hzr07cCazfJp9w1x182/mEcdDdQ8s2MoGUYs+s9IchQaJRkY
         2B7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6ilVhJc0KLaqYnWcVF2XM/01kZ5HMNBRjsvcGb6cfig=;
        b=WBzip1X7RDsYxIfJdEjuksvV/31h6aqL5SoNWChZxigKl/FhO9vD/kn5xt7uQXz/Vs
         y3QzGo3l5JqB8NbwrUmlWOCXkbJ4hkr46wvlmbxuxCZcKooy+yx8aySbmIz1bs5eng42
         jWVnxFaJEu//496jTxSGJMEQNUIh8TM7kGHarvWvsi4tD57dIw3OmN7O8lppeKqzI98e
         +1a9HCCVMypL0GPAldbho5Nm2YHXtov9Bs2By/uI4iOEnzbf1/diJ+Ggb9QxHmZqxQtx
         CsK/4fbFol7mwrPn4a15F8K2zHc9HBcB5oUWEtm0aKiiDPBwoH3ZaXS1nBa5ZewsyFm4
         XgCQ==
X-Gm-Message-State: AO0yUKW0/Iimnivk9TzawoP7IGDTIaOjTDNwx/Ratp4577hbCkGoKN24
        6pFs7kvyPOaoBRowy+9f9C0Xow2hrBhl9vPJ/aIgxA==
X-Google-Smtp-Source: AK7set8goKUSoGkjWGVqXqgWWcQEZYI0hUhX1EATDo3o3SV+MZjzebVUz/ZYkOyZlmBkTPVDaGW9HGFtC9aOKQKhoTc=
X-Received: by 2002:aa7:94b9:0:b0:593:1253:2ff5 with SMTP id
 a25-20020aa794b9000000b0059312532ff5mr802084pfl.14.1675278641256; Wed, 01 Feb
 2023 11:10:41 -0800 (PST)
MIME-Version: 1.0
References: <167527517464.938135.13750760520577765269.stgit@firesoul>
In-Reply-To: <167527517464.938135.13750760520577765269.stgit@firesoul>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 1 Feb 2023 11:10:29 -0800
Message-ID: <CAKH8qBt3XjsvhJfmkEpFxTOVPYNdLnrBOHZ9ekLM30hq6y4GEA@mail.gmail.com>
Subject: Re: [PATCH bpf-next V1] selftests/bpf: fix unmap bug in prog_tests/xdp_metadata.c
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, martin.lau@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        martin.lau@linux.dev, song@kernel.org, yhs@fb.com,
        john.fastabend@gmail.com, dsahern@gmail.com, willemb@google.com,
        void@manifault.com, kuba@kernel.org, xdp-hints@xdp-project.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 1, 2023 at 10:13 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> The function close_xsk() unmap via munmap() the wrong memory pointer.
>
> The call xsk_umem__delete(xsk->umem) have already freed xsk->umem.
> Thus the call to munmap(xsk->umem, UMEM_SIZE) will have unpredictable
> behavior that can lead to Segmentation fault elsewhere, as man page
> explain subsequent references to these pages will generate SIGSEGV.
>
> Fixes: e2a46d54d7a1 ("selftests/bpf: Verify xdp_metadata xdp->af_xdp path")
> Reported-by: Martin KaFai Lau <martin.lau@kernel.org>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Good catch, thank you!

Acked-by: Stanislav Fomichev <sdf@google.com>

> ---
>  .../selftests/bpf/prog_tests/xdp_metadata.c        |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
> index e033d48288c0..241909d71c7e 100644
> --- a/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
> +++ b/tools/testing/selftests/bpf/prog_tests/xdp_metadata.c
> @@ -121,7 +121,7 @@ static void close_xsk(struct xsk *xsk)
>                 xsk_umem__delete(xsk->umem);
>         if (xsk->socket)
>                 xsk_socket__delete(xsk->socket);
> -       munmap(xsk->umem, UMEM_SIZE);
> +       munmap(xsk->umem_area, UMEM_SIZE);
>  }
>
>  static void ip_csum(struct iphdr *iph)
>
>
