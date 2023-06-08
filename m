Return-Path: <netdev+bounces-9332-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 39DE6728789
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 20:57:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 97D8D1C21026
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 18:57:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 129041DCBB;
	Thu,  8 Jun 2023 18:57:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 046C212B92
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 18:57:53 +0000 (UTC)
Received: from mail-oo1-xc35.google.com (mail-oo1-xc35.google.com [IPv6:2607:f8b0:4864:20::c35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A02712717
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 11:57:52 -0700 (PDT)
Received: by mail-oo1-xc35.google.com with SMTP id 006d021491bc7-55b38fc0c70so642319eaf.0
        for <netdev@vger.kernel.org>; Thu, 08 Jun 2023 11:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1686250672; x=1688842672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sOhMqhjw5pgo1DLFwbT1NxdLsERedd9NQ4vBoJhagXQ=;
        b=I885Q2BjWoCM/xdi9m0qbewwKaXmhHDxrKogZX9aC4+GBmjp7VGikVCh8WKBiBeyES
         Sa/+64LHGDyYuxZAiRgrNkJ16f7EVfxm7fy/u1oWhlOGtNNhBzZDaS0Ami6hjp97Bi/M
         z5o+ch7+bpOiCog7mF+kGbJoZQ5dSXk9z0AISMXz+MLf0GhLNR8bWDijaSXiUJE2Sv4Y
         Ykn90vUpy65hYTYzVQv+5ZmwyAl2nNbkr72WPslQsWk+MgntUqGD6y7HOeq2+LhXQenq
         XAFTjgztjTLvjTxhwEh9C8ZEny7BJRdDT62COM6zw1o9JyR7bU4EMsuiSuYk05yuwMXC
         n8Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686250672; x=1688842672;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sOhMqhjw5pgo1DLFwbT1NxdLsERedd9NQ4vBoJhagXQ=;
        b=bzEdsdvB8Tc2SdEDri3kq4QiGKozNvQHyEY7KDyEF3ljI5de/+/6ER26LR/+90AmcA
         qy90ftskqouD47og7vY2hnGbMOqNoeOvF0reTl/YhR9C0DH68mZVn1gumPrFsB+l+XzS
         HEXfUgY8CFn0sk6x0e3RP34wY7xeqsSCZmoZAmZ968spHLQsfGqW/U0PZLD/Znw66z1W
         clCPK5ukIEGKgZohAKJvORsmxVn2hIbseAFSvEnjkpNfdqgLFLN7PJcd0sHXzgPfvMsd
         Wshn1dns8OtFC7+U2prOxQ2AChO0DJAnvd5Hyh0xkWTtfGqS3LbOLSQMy7zDAL+1l6fA
         Sd7A==
X-Gm-Message-State: AC+VfDyt4AU9Hz0GD+RjlXAUxSWWSOpGdWy8+q6brTNEKCfrO4uA0UWg
	DtGW3ccQ89pDRmrvBG9xbc5j+4d5HfIy73sVbaqHBiMk0PgM9iwA2A==
X-Google-Smtp-Source: ACHHUZ5r48MqAG02vf5w1UQDeniWS4RiheX9JdGyxl11RzIt8axYQmCosdK24DnsbTB0pGlZlXQOW6mBMW5z3gB6Cf4=
X-Received: by 2002:a05:6808:b25:b0:394:4603:77f2 with SMTP id
 t5-20020a0568080b2500b00394460377f2mr9583454oij.2.1686250671974; Thu, 08 Jun
 2023 11:57:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230608135754.25044-1-dmastykin@astralinux.ru>
In-Reply-To: <20230608135754.25044-1-dmastykin@astralinux.ru>
From: Paul Moore <paul@paul-moore.com>
Date: Thu, 8 Jun 2023 14:57:41 -0400
Message-ID: <CAHC9VhSMe0sLNkWbNCswm67bGZAgp+xJjyD2EBcXvTxD_2kAwg@mail.gmail.com>
Subject: Re: [PATCH] netlabel: fix shift wrapping bug in netlbl_catmap_setlong()
To: Dmitry Mastykin <dmastykin@astralinux.ru>
Cc: netdev@vger.kernel.org, linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 8, 2023 at 9:58=E2=80=AFAM Dmitry Mastykin <dmastykin@astralinu=
x.ru> wrote:
>
> There is a shift wrapping bug in this code on 32-bit architectures.
> NETLBL_CATMAP_MAPTYPE is u64, bitmap is unsigned long.
> Every second 32-bit word of catmap becomes corrupted.
>
> Signed-off-by: Dmitry Mastykin <dmastykin@astralinux.ru>
> ---
>  net/netlabel/netlabel_kapi.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Thanks Dmitry.

Acked-by: Paul Moore <paul@paul-moore.com>

> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 54c083003947..27511c90a26f 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -857,7 +857,8 @@ int netlbl_catmap_setlong(struct netlbl_lsm_catmap **=
catmap,
>
>         offset -=3D iter->startbit;
>         idx =3D offset / NETLBL_CATMAP_MAPSIZE;
> -       iter->bitmap[idx] |=3D bitmap << (offset % NETLBL_CATMAP_MAPSIZE)=
;
> +       iter->bitmap[idx] |=3D (NETLBL_CATMAP_MAPTYPE)bitmap
> +                            << (offset % NETLBL_CATMAP_MAPSIZE);
>
>         return 0;
>  }
> --
> 2.30.2

--=20
paul-moore.com

