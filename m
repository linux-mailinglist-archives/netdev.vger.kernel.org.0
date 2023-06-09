Return-Path: <netdev+bounces-9583-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 503E4729E3A
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:23:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9214C1C210C7
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB56418C34;
	Fri,  9 Jun 2023 15:22:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD1218C23
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:22:50 +0000 (UTC)
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56F7535A3
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 08:22:44 -0700 (PDT)
Received: by mail-il1-x133.google.com with SMTP id e9e14a558f8ab-33d928a268eso281465ab.0
        for <netdev@vger.kernel.org>; Fri, 09 Jun 2023 08:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1686324163; x=1688916163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LndHU9TZE+sLOlp/4AKTvI8fOjhkCuJM52IaMJQHndI=;
        b=OXcGuIPowAMyMxyFMfftHe2Ooc1FGKdouvbE/9K2WysGKMkycw5fYDtWJsHs6G4a0x
         iMZz4MkUiDFGX+NNpbdPJXGe1r1VJltRQl8NprSsYCW4azX/QfKzY0q0UTgZ5CIhMIsr
         +My+NECPh4sgNjdNC4L8dXkj662C5aZAGSHaQnjLvBJyxfqDloP4iam9U//a1fMjGp20
         TlfnMTRktQfVEbmDPF+nA+a/9AyEiuF92NQJSWRpcTasxkmpDJo6CNhItxxB1IkCXeFR
         yda8HQe+QpabCYiVbtOs9z5aZef0oilcHu8KalvLv+u4dNmBgYo0sMue/RJ6vVzA3me0
         FzaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686324163; x=1688916163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LndHU9TZE+sLOlp/4AKTvI8fOjhkCuJM52IaMJQHndI=;
        b=LEXykGd3uNUjDWY5juolthk+NXWPJr/38XZHvh/5gd6t7PLqHHUC6cuvJvQh3oaGIq
         qNE+KUZvjG8nkw7PGKEAtqlkEzyXKKq2R27unzbVKw3tyyyAbQsePI5xhE9nPA9CUYBH
         Lbzj95LIU8zekcQho7If7FNhzbOIzZiWs69Kz8j9679bmcSanzGfzrLaaRGie/EJd9Sh
         78xtvXk/anjSSNUxePnTtOigPnsVydSGqp0LNv9pn346vyzVBBqOLmvP+EPLoStiH+vL
         hsGnTXijCrPAfIGgGbFhjnZP0ZkhSKw8e6Toro6CnfjShiJ38S1eM0xZxDdGCsRzsBhb
         rd5Q==
X-Gm-Message-State: AC+VfDzCAwMywVS9PmA1L61bvm9OPjIPWljuX0lxKGeOMiWYvSGmS+/q
	3npxOa9l8PNkC1rltXecHOODJiKDm/eY0RsBEhfblQ==
X-Google-Smtp-Source: ACHHUZ6ygfA461qbrquQvQw3MhijkKyjkjbjWvKV4PayeVKYJeRQB1hUOegGZV23zMlGXoVKbIvFy8xKYkFXi+rPEhA=
X-Received: by 2002:a92:ca0a:0:b0:338:1993:1194 with SMTP id
 j10-20020a92ca0a000000b0033819931194mr335428ils.2.1686324163299; Fri, 09 Jun
 2023 08:22:43 -0700 (PDT)
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
	autolearn=unavailable autolearn_force=no version=3.4.6
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

