Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4D265AFB4C
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 06:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229738AbiIGE1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 00:27:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiIGE1q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 00:27:46 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0293A8C005;
        Tue,  6 Sep 2022 21:27:46 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id kg20so870035ejc.12;
        Tue, 06 Sep 2022 21:27:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=DtQEUbHrZXRVSvv8X3cr2fMxJ2Hd5j5uiQKjuorqFRg=;
        b=gzHNKSTsW2UnOmGXJY/6xvJyQROkAckj3ZKV3yg1DqGwmgTFzW6PMygHfaZQLiNuOt
         kVugpkIJX00CPBFesY3tI1m2aaY/5bg70boDpR8kofVad4cMlOuwZnl88XbtarkZihJt
         5T96PjeDEQ5O8r93y8k//ubptfq4EEvg1XOMDP9Q77cZnKaOwphjakbfQMcBV2XD7m+S
         m9QWrt9TH9q/LymBBeMjwlfI8BcT8F097C/o1y5UDIXT5UZfH4lDlckrSK4fc794TH7P
         y3pWWCuBqqVVh85iC9V1ExxWJBDVtEXnat+FvYnv19bdH0h5TKwLxvey27XFEnmeMN+R
         o/tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=DtQEUbHrZXRVSvv8X3cr2fMxJ2Hd5j5uiQKjuorqFRg=;
        b=Cxd7Fp7mQMphWEQDxgBZLwfNPUciXbrRef2IpIcNLIgXW2Kw9iBOZ6NPllIzKn8Y6T
         SV/eWNL5XHsnNX/3U8ESHAVEUarMzDRV4GaUvCt5ON91ZxOgsS689hlncZsLF80ll/u5
         VDVEOlZuZdF/dcYJaTWRS1Bxj+Wh+borfLtrRcim6QaMQDPOF05KH0ZEt9kfWbcUr6Y1
         IBh7VecHi5nsS/6B8PuVSZ1wTdMMcOAceJXh7HC3wQemJGTsYzEKWgNzddsBEobE+vKw
         GlsgaQxYMEU9A/UAAvhdeFi5vQfG0qq8xPsKDzhbtewHPrGH/Pk3Fm9V+PUGQm4roe8u
         Hl6Q==
X-Gm-Message-State: ACgBeo2zKvQU4vdh3irYsuwQ+IPdZeqvqJTFT909bjin8JJcLAOB0B0h
        ecRKaU3YHJxGEx09S8dCXXmbNS7Wkya3h9T4gYw=
X-Google-Smtp-Source: AA6agR7lq7k88REO9qL4S+HSxpM4lCI9Je0lcsEPs5OD64RGY135DA0Cz2F1x9ZE+oZ6bdcaZ8WWLBHKuc2TgOo/vO4=
X-Received: by 2002:a17:907:2c74:b0:741:657a:89de with SMTP id
 ib20-20020a1709072c7400b00741657a89demr1047973ejc.58.1662524864401; Tue, 06
 Sep 2022 21:27:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1662383493.git.lorenzo@kernel.org> <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
In-Reply-To: <fa02d93153b99bc994215c1644a2c75a226e3c7d.1662383493.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Sep 2022 21:27:33 -0700
Message-ID: <CAADnVQJ4XtFpsEsPRC-cepfQvXr-hN7e_3L5SchieeGHH40_4A@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/4] net: netfilter: add bpf_ct_set_nat_info
 kfunc helper
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>
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

On Mon, Sep 5, 2022 at 6:14 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
> +int bpf_ct_set_nat_info(struct nf_conn___init *nfct__ref,
> +                       union nf_inet_addr *addr, __be16 *port,
> +                       enum nf_nat_manip_type manip)
> +{
...
> @@ -437,6 +483,7 @@ BTF_ID_FLAGS(func, bpf_ct_set_timeout, KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_ct_change_timeout, KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_ct_set_status, KF_TRUSTED_ARGS)
>  BTF_ID_FLAGS(func, bpf_ct_change_status, KF_TRUSTED_ARGS)
> +BTF_ID_FLAGS(func, bpf_ct_set_nat_info)
>  BTF_SET8_END(nf_ct_kfunc_set)

Instead of __ref and patch 1 and 2 it would be better to
change the meaning of "trusted_args".
In this case "addr" and "port" are just as "trusted".
They're not refcounted per verifier definition,
but they need to be "trusted" by the helper.
At the end the "trusted_args" flags would mean
"this helper can assume that all pointers can be safely
accessed without worrying about lifetime".
