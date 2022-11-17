Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A84B662E953
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 00:06:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240102AbiKQXGW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 18:06:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233780AbiKQXGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 18:06:21 -0500
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6600643879;
        Thu, 17 Nov 2022 15:06:20 -0800 (PST)
Received: by mail-ej1-x62c.google.com with SMTP id bj12so8798570ejb.13;
        Thu, 17 Nov 2022 15:06:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2Ed0+bfYsRNlvqARbT6xXhs+QuNpor558xnQBQtSYK8=;
        b=jM0qm4hdhipKNqN9VnScAwus0QHMy28F8Y0VZAsZQb1mw+a0eab/Cye+eeZyWTErzP
         9FkpXWRz1RfOJACXn/TemNR9aDxJsDQcU9ch9br14xfHLBYPs3g/ZWwLqlTkAAjgtUot
         8IoQKvsvznTW6UHx7Bdgq21DDoDCIOs/1rGUDL7IWxcDP2+3WwHK+jZlLF7E60Io6qMm
         bbmTEbOPCOu7WtFXI3vQVyaQq1pS3+Lz2vkXyAj6fFpCvU97eMTz3lrQSTypw2eutvUS
         mXyAlsWx+xxOU9HKg0p/Q/AN6lGUea/2Pqn+ySUkso1kBgUW44q7BJuglLTxryG71t8L
         H0Hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Ed0+bfYsRNlvqARbT6xXhs+QuNpor558xnQBQtSYK8=;
        b=j/Cyk9JPbi1fV+dBQCyAnmHBJf1uVbzIVIeexsKK+hIAy2/sBymvkVd1peTbtzAvAl
         YqKbyZbS0MAFh7xiV+4gStRZwsA8LM34wl0UEXQlOFbJV7ms8n2/frJPPdTVVh0BO5d7
         MTF95c0kzqI7zYQ5VNsZUeUJ+zBEvB2fgIqpzo3O0D7+Xk5X2Ifm7EslHDAoOJeTTUqB
         mzukGVK6QQtjjOLJ8D/obAxEKbYEXrFlwwdh5Bx7b9giIgxckt9ETrDLTtVfESuTmxkT
         FPVwZFsxTUyXOU83TqlnT0vZ4AdoSbDo5eVsOAPTRfqwhiqoaUlKHw0jj4S4YHJk/KV1
         AV7g==
X-Gm-Message-State: ANoB5plKSuLNGbgsDInZ7WbjxxdzvNJD4H18T3yQ+kNRKtuquLMNgIfH
        sKdk1k32DrmYI26cPZ8NxKDL5bdCtrkkyFt+n0NHVJGmbQE=
X-Google-Smtp-Source: AA0mqf5IUNtmcENQg/Rf++aZY7ulltZwsSdRLeU4wMRyKuUlTEKSBOx4z0huZZquxWeIpmT3lp+ribWYuJYrGdKI5aU=
X-Received: by 2002:a17:906:e289:b0:7ae:c460:c65f with SMTP id
 gg9-20020a170906e28900b007aec460c65fmr3859468ejb.226.1668726378811; Thu, 17
 Nov 2022 15:06:18 -0800 (PST)
MIME-Version: 1.0
References: <20221114203431.302655-1-andrea.righi@canonical.com>
In-Reply-To: <20221114203431.302655-1-andrea.righi@canonical.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 17 Nov 2022 15:06:06 -0800
Message-ID: <CAEf4Bzbt2pWCdKX2quszFDxm9yYXvP+yPfMyVN_Gm87xi7yzrQ@mail.gmail.com>
Subject: Re: [PATCH] selftests net: additional fix for kselftest net build error
To:     Andrea Righi <andrea.righi@canonical.com>
Cc:     Shuah Khan <shuah@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
        Coleman Dietsch <dietschc@csp.edu>,
        Lina Wang <lina.wang@mediatek.com>,
        Kamal Mostafa <kamal@canonical.com>,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
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

On Mon, Nov 14, 2022 at 12:39 PM Andrea Righi
<andrea.righi@canonical.com> wrote:
>
> We need to make sure that bpf_helpers.h is properly generated when
> building the net kselftest, otherwise we get this build error:
>
>  $ make -C tools/testing/selftests/net
>  ...
>  bpf/nat6to4.c:43:10: fatal error: 'bpf/bpf_helpers.h' file not found
>           ^~~~~~~~~~~~~~~~~~~
>  1 error generated.
>
> Fix by adding a make dependency on tools/lib/bpf/bpf_helper_defs.h.
>
> Moreover, re-add the include that was initially added by commit
> cf67838c4422 ("selftests net: fix bpf build error"), otherwise we won't
> be able to properly include bpf_helpers.h.
>
> Fixes: 7b92aa9e6135 ("selftests net: fix kselftest net fatal error")
> Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> ---
>  tools/testing/selftests/net/bpf/Makefile | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/net/bpf/Makefile b/tools/testing/selftests/net/bpf/Makefile
> index 8ccaf8732eb2..cc6579e154eb 100644
> --- a/tools/testing/selftests/net/bpf/Makefile
> +++ b/tools/testing/selftests/net/bpf/Makefile
> @@ -2,11 +2,15 @@
>
>  CLANG ?= clang
>  CCINCLUDE += -I../../bpf
> +CCINCLUDE += -I../../../lib
>  CCINCLUDE += -I../../../../lib
>  CCINCLUDE += -I../../../../../usr/include/
>
> +bpf_helper_defs.h:
> +       @make OUTPUT=./ -C $(OUTPUT)/../../../../tools/lib/bpf bpf_helper_defs.h
> +
>  TEST_CUSTOM_PROGS = $(OUTPUT)/bpf/nat6to4.o
> -all: $(TEST_CUSTOM_PROGS)
> +all: bpf_helper_defs.h $(TEST_CUSTOM_PROGS)

it would be better to call libbpf's install_headers target instead to
generate and install API headers only

>
>  $(OUTPUT)/%.o: %.c
>         $(CLANG) -O2 -target bpf -c $< $(CCINCLUDE) -o $@
> --
> 2.37.2
>
