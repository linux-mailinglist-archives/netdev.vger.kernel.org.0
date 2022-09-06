Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B2F5AF6EA
	for <lists+netdev@lfdr.de>; Tue,  6 Sep 2022 23:37:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiIFVhK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Sep 2022 17:37:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbiIFVhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Sep 2022 17:37:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1789E2D1;
        Tue,  6 Sep 2022 14:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90A1BB81A4F;
        Tue,  6 Sep 2022 21:37:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24317C433C1;
        Tue,  6 Sep 2022 21:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662500225;
        bh=vwK6RdaFY762tJiRgbnouER58jZq2nGr+V9lFAf/bSU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ddOeATtFk5xo9vM0LUqv+fLrErIsFlz2z2GY+ENj9zwfy0S7ZbuqEp/TmkLFtEiWC
         9h6d3eaQQc2NUQVelvegWxbBCMztUxhTJQ1Y/8eZ3maVsVgk7ixWXEmMXKN1/yu7XO
         y01+O6xRyKf/atij2cCBd8hq+W8uCsEpIvDui+WR0mra2DOUc7NRSIGBWiqI92IbYB
         xZBgQZniDH5D4Pelr1dVOr5mXPFAavge8nBZVUEPfbOcFZt7vqsKW788lIgeU+rZa2
         IeQyNr+V5Od6cTc5MkWqVlLwtwBbfhwML7qu6gq+ZasgXCs++5T4OHGYy1K26WzOWV
         8j2hLNPjZNnYg==
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-1278624b7c4so13230940fac.5;
        Tue, 06 Sep 2022 14:37:05 -0700 (PDT)
X-Gm-Message-State: ACgBeo18ULyUzvQs9RNmQoLljtDvs9aJYv1MCVAoIoymraQiiwey0B8A
        pzWct6CJMA/nfOqo3yBqzV6d+V9MhAMIqawEvDo=
X-Google-Smtp-Source: AA6agR5ChQlvHJ0b03v8jKNgSuCFhptyi1QcPljJMhinNAfeX/DA3UxlvQanFdWM4bEyNU1UmGmL6LoMnPJUKxX1kO4=
X-Received: by 2002:a05:6870:3127:b0:11c:8c2c:9015 with SMTP id
 v39-20020a056870312700b0011c8c2c9015mr12340159oaa.31.1662500224336; Tue, 06
 Sep 2022 14:37:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
In-Reply-To: <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
From:   Song Liu <song@kernel.org>
Date:   Tue, 6 Sep 2022 14:36:53 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5P=K7463Ka0CGxFD0BGChrEffbeO6UqReDtr80osDJLg@mail.gmail.com>
Message-ID: <CAPhsuW5P=K7463Ka0CGxFD0BGChrEffbeO6UqReDtr80osDJLg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, pablo@netfilter.org,
        fw@strlen.de, netfilter-devel@vger.kernel.org,
        lorenzo.bianconi@redhat.com,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 5, 2022 at 6:15 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Introduce bpf_ct_set_nat_info kfunc helper in order to set source and
> destination nat addresses/ports in a new allocated ct entry not inserted
> in the connection tracking table yet.
>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
>  net/netfilter/nf_conntrack_bpf.c | 49 +++++++++++++++++++++++++++++++-
>  1 file changed, 48 insertions(+), 1 deletion(-)
>
> diff --git a/net/netfilter/nf_conntrack_bpf.c b/net/netfilter/nf_conntrack_bpf.c
> index 1cd87b28c9b0..85b8c7ee00af 100644
> --- a/net/netfilter/nf_conntrack_bpf.c
> +++ b/net/netfilter/nf_conntrack_bpf.c
> @@ -14,6 +14,7 @@
>  #include <net/netfilter/nf_conntrack.h>
>  #include <net/netfilter/nf_conntrack_bpf.h>
>  #include <net/netfilter/nf_conntrack_core.h>
> +#include <net/netfilter/nf_nat.h>
>
>  /* bpf_ct_opts - Options for CT lookup helpers
>   *
> @@ -134,7 +135,6 @@ __bpf_nf_ct_alloc_entry(struct net *net, struct bpf_sock_tuple *bpf_tuple,
>
>         memset(&ct->proto, 0, sizeof(ct->proto));
>         __nf_ct_set_timeout(ct, timeout * HZ);
> -       ct->status |= IPS_CONFIRMED;
>
>  out:
>         if (opts->netns_id >= 0)
> @@ -339,6 +339,7 @@ struct nf_conn *bpf_ct_insert_entry(struct nf_conn___init *nfct_i)
>         struct nf_conn *nfct = (struct nf_conn *)nfct_i;
>         int err;
>
> +       nfct->status |= IPS_CONFIRMED;
>         err = nf_conntrack_hash_check_insert(nfct);
>         if (err < 0) {
>                 nf_conntrack_free(nfct);
> @@ -424,6 +425,51 @@ int bpf_ct_change_status(struct nf_conn *nfct, u32 status)
>         return nf_ct_change_status_common(nfct, status);
>  }

Why do we need the above two changes in this patch?

Thanks,
Song
