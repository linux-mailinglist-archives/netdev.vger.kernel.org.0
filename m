Return-Path: <netdev+bounces-9582-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1EAEE729E36
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:22:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 711B1281950
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:22:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CB618C0E;
	Fri,  9 Jun 2023 15:22:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E1E256D
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:22:37 +0000 (UTC)
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12D533588
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:22:36 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id 4fb4d7f45d1cf-514ad92d1e3so17106a12.1
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:22:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686324154; x=1688916154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LndHU9TZE+sLOlp/4AKTvI8fOjhkCuJM52IaMJQHndI=;
        b=07qRtzQG+Tsvvzi5HEhoiboXyuVtA02suBpxxirncDOSn/xPDKqF8ZrT3jMczHvjv1
         se5boK9vRJtyGv5o1cpSfTU59vyiupbcJO0l6CoAyloeF6ncK+NyAHoNndRdpVcfws9D
         APFrboI8CHnGxMBfKk8TUbWaU1pL8ubgKjzoIu9zfRxbZUpEaRMpBhpR1HgUbAzwPnbj
         6KunaR1HMwHZzxo0RQGIStmuRF+zec5lT+BEahQE47LXRFXL/oyV8KtW51X9qVWpSlD6
         MHSjnIzU+EC7NSeVcNkeGOl6cjpx3dfbD84scJgXya1MCPUPkc3Jxy4Jr3cdqBticF0J
         2imA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686324154; x=1688916154;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LndHU9TZE+sLOlp/4AKTvI8fOjhkCuJM52IaMJQHndI=;
        b=RfFNLU+vLtCNF5htyI6lzc5lJwfu6puLxckZYDY8hiqxxxZ/1cfL8u7BCOVbI1OdRd
         FHyCCq4bpYS89wh7hdJf6MdwLxh6nd6IriRMA5MUCdVV/a+XJHx09PWw2s99qalA6lUN
         sM+yS/nJ0xAM3eD/MdCH/Uc+tym+jk746wTV7UwjjROtE+ILoawCngbBDfoSTM5L3ZnF
         xf4CyhMr/wCuqdWgITMnB0RbaZBKJqouMHtvqTnSOLu5haOsXdRftkPgutW7gWeHIhY5
         l4C6NtQeuHqYZUS9vd09lJUcPkXnlm86Y1ttKhH/elQMAI4G2X2jFSan76tiieZn0AUV
         yjZA==
X-Gm-Message-State: AC+VfDxgZzL519w9p7Q76rrLDeipF/WRjlk+PfOcB1IkG+T/noVSI73g
	0U/+sB20+e+/DwLpxGIeejih/2kEK/FaY8LqT4L0bUwe6LeyRmY2aEoZeQ==
X-Google-Smtp-Source: ACHHUZ5FPuTATdyvLQNc7KXlz8wvc7an0CnEdGGadE+qiTokd/vaUrQMSXJoANze8p4BuGYwVUJ0TiSAxx+BS6ePtFk=
X-Received: by 2002:a50:8753:0:b0:502:2af:7b1d with SMTP id
 19-20020a508753000000b0050202af7b1dmr308532edv.3.1686324154321; Fri, 09 Jun
 2023 08:22:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609151332.263152-1-pctammela@mojatatu.com> <20230609151332.263152-2-pctammela@mojatatu.com>
In-Reply-To: <20230609151332.263152-2-pctammela@mojatatu.com>
From: Eric Dumazet <edumazet@google.com>
Date: Fri, 9 Jun 2023 17:22:02 +0200
Message-ID: <CANn89iJxMq2he840QNGm_pH2ta4+KSxN7jYKh4Yb0182cXnq8g@mail.gmail.com>
Subject: Re: [RFC PATCH net-next 1/4] rhashtable: add length helper for
 rhashtable and rhltable
To: Pedro Tammela <pctammela@mojatatu.com>
Cc: netdev@vger.kernel.org, tgraf@suug.ch, herbert@gondor.apana.org.au, 
	davem@davemloft.net, dsahern@kernel.org, kuba@kernel.org, pabeni@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, Jun 9, 2023 at 5:13=E2=80=AFPM Pedro Tammela <pctammela@mojatatu.co=
m> wrote:
>
> Instead of having users open code the rhashtable length like:
>    atomic_read(&ht->nelems)
>
> Provide a helper for both flavours of rhashtables.
>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
> ---
>  include/linux/rhashtable.h | 16 ++++++++++++++++
>  1 file changed, 16 insertions(+)
>
> diff --git a/include/linux/rhashtable.h b/include/linux/rhashtable.h
> index 5b5357c0bd8c..aac803491916 100644
> --- a/include/linux/rhashtable.h
> +++ b/include/linux/rhashtable.h
> @@ -1283,4 +1283,20 @@ static inline void rhltable_destroy(struct rhltabl=
e *hlt)
>         return rhltable_free_and_destroy(hlt, NULL, NULL);
>  }
>
> +/**
> + * rhashtable_len - hash table length
> + * @ht: the hash table
> + *
> + * Returns the number of elements in the hash table
> + */
> +static inline int rhashtable_len(struct rhashtable *ht)
> +{
> +       return atomic_read(&ht->nelems);
> +}
> +
> +static inline int rhltable_len(struct rhltable *hlt)
> +{
> +       return rhashtable_len(&hlt->ht);
> +}
> +

If we want/need these, please add 'const' qualifiers to both

static inline int rhltable_len(const struct rhltable *hlt)
...

