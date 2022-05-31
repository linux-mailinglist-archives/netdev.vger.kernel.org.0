Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCB953997B
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 00:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348403AbiEaW1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 18:27:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233920AbiEaW1W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 18:27:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CD34ECDB;
        Tue, 31 May 2022 15:27:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7B37B81717;
        Tue, 31 May 2022 22:27:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C4BC385A9;
        Tue, 31 May 2022 22:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654036039;
        bh=OunOxBC+k7o9OrvxxcKFBRB8QFvQhoJy4jFX3affSqc=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=KfXNuKCCAZ4LjF9dMrnVueTKKeDR5zhqyFenJukPO33jgv1Z8XOrSPG2W6JUIIGrV
         ph5eV8gNlul/v48sKRAeXNYmHumGfCQp/EOJVdzeCmHIqocAKWGzNs1NYIR4dF76Y1
         tmVaWOYhc6bkmrATFNinJLA9SwmZc2pFSaP0YZda+b/38rNiw1EYHaFWtcPF8Nmy6D
         3IQJ4g1FaJbH3hVNdQpCX0uOqsDzZt8/tEHfYbuJ+ayR1zd1nBXm4mKbY5khBMtRWh
         qdD8Aorv3LfPB83OvRII9UREKv5UlxCeUBkqC+mKU36XU/lmsM3YSzTufvU372QeY5
         Dn6emA1k8DgJw==
Received: by mail-yw1-f180.google.com with SMTP id 00721157ae682-30c1b401711so196167b3.2;
        Tue, 31 May 2022 15:27:19 -0700 (PDT)
X-Gm-Message-State: AOAM530WYGRaCZkhb9iOvvxA26nr8f+5EVLBj2Wc+kScMAorifCfOj+w
        pvnSK2g0WUygHnL4uLMcg5rxJWSyZ5UtJABjucI=
X-Google-Smtp-Source: ABdhPJwPoH/v/n7U+49ZTqMuPuNF+FEX/vs3krbLN/3x2j+pXOLLkMzSaI1GKHunHaVHcD+/r/cny2JIyqSq2oNgRWU=
X-Received: by 2002:a81:4e48:0:b0:30c:6c6a:616d with SMTP id
 c69-20020a814e48000000b0030c6c6a616dmr11828673ywb.447.1654036038539; Tue, 31
 May 2022 15:27:18 -0700 (PDT)
MIME-Version: 1.0
References: <20220530062126.27808-1-lina.wang@mediatek.com>
In-Reply-To: <20220530062126.27808-1-lina.wang@mediatek.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 31 May 2022 15:27:07 -0700
X-Gmail-Original-Message-ID: <CAPhsuW57zs54sT9N-2mvUAA6HUQ6TOzh+zM0kN0vHzH+AszD5g@mail.gmail.com>
Message-ID: <CAPhsuW57zs54sT9N-2mvUAA6HUQ6TOzh+zM0kN0vHzH+AszD5g@mail.gmail.com>
Subject: Re: [PATCH] selftests net: fix bpf build error
To:     Lina Wang <lina.wang@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej enczykowski <maze@google.com>,
        Networking <netdev@vger.kernel.org>,
        linux-kselftest@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>, rong.a.chen@intel.com,
        kernel test robot <oliver.sang@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 29, 2022 at 11:28 PM Lina Wang <lina.wang@mediatek.com> wrote:
>
> bpf_helpers.h has been moved to tools/lib/bpf since 5.10, so add more
> incliding path.
nit:  including

>
> Fixes: edae34a3ed92 ("selftests net: add UDP GRO fraglist + bpf self-tests")
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Signed-off-by: Lina Wang <lina.wang@mediatek.com>

Acked-by: Song Liu <songliubraving@fb.com>


> ---
>  tools/testing/selftests/net/bpf/Makefile | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
> index f91bf14bbee7..070251986dbe 100644
> --- a/tools/testing/selftests/net/bpf/Makefile
> +++ b/tools/testing/selftests/net/bpf/Makefile
> @@ -2,6 +2,7 @@
>
>  CLANG ?= clang
>  CCINCLUDE += -I../../bpf
> +CCINCLUDE += -I../../../../lib
>  CCINCLUDE += -I../../../../../usr/include/
>
>  TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
> --
> 2.18.0
>
