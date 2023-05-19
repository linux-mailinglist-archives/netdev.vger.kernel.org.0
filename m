Return-Path: <netdev+bounces-3851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C0BC870923A
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:54:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 006C7281A20
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:54:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 043945694;
	Fri, 19 May 2023 08:54:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427BD2114
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:54:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD99AC4339C;
	Fri, 19 May 2023 08:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684486464;
	bh=l6xWlNTW11M1IArH9XbVsO0LuYjgvFrPFdvjgT2fKsY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=TLL7EZD00J0qHP0WIImFoaeP9iS7POWP+jnrXXMOVsvPZf7p0pLPOZmZditjFFg31
	 hQ44JGMc+sINjBZQV4JnhcqiHZ/mQYoX/q3UD8LQ3fL7avD2osNo6ikbeO+dTVqI8U
	 SLLneongeou+VquX03U5xk32P8IGa+mc28lW+KBpgGF+YcNep+zjvA092liO93u4Po
	 Mr+Hg/2V7r/LSvvS51mmeCcObriQgn7bfCwvJml8+elLZMzpPHkT4iYPgk0FkGLQ/W
	 H2027cYo7hdUiOwfaUuO0jp4YfS9qDFtQWfaHB6t7GSPEli7Z/CzCLg1UuRwwtw8K9
	 mD5z70YGlVj8g==
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-4f2676d62a2so3346163e87.0;
        Fri, 19 May 2023 01:54:24 -0700 (PDT)
X-Gm-Message-State: AC+VfDwz/1er401cIoV6TLsg0UmhbYPE5TCnAfnokzh6bDmWjvQM2ck7
	teEQdq8n/96UESDwnjrg6kSqQteCAOlkqzB54JM=
X-Google-Smtp-Source: ACHHUZ7SvdXKZpS/i9iOaPcFYPkRcxW6aWBrXA6Y7mN4OZu24KBaz9xljJ2ps4rcZZOJmt7v9Wu5xjt2j2ikxrgIIvk=
X-Received: by 2002:ac2:43a4:0:b0:4f2:7b65:baeb with SMTP id
 t4-20020ac243a4000000b004f27b65baebmr455104lfl.53.1684486462868; Fri, 19 May
 2023 01:54:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ZGcyuyjJwZhdYS/G@gondor.apana.org.au> <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
In-Reply-To: <E1pzvTZ-00AnMQ-5M@formenos.hmeau.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 19 May 2023 10:54:11 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGwS03zUBTGb7jmk1-6r+=a-HH+A-S9ZFTYRyJSzN0Xcg@mail.gmail.com>
Message-ID: <CAMj1kXGwS03zUBTGb7jmk1-6r+=a-HH+A-S9ZFTYRyJSzN0Xcg@mail.gmail.com>
Subject: Re: [PATCH 3/3] crypto: cmac - Add support for cloning
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Dmitry Safonov <dima@arista.com>, 
	Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, linux-kernel@vger.kernel.org, 
	David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Jakub Kicinski <kuba@kernel.org>, 
	"David S. Miller" <davem@davemloft.net>, Andy Lutomirski <luto@amacapital.net>, 
	Bob Gilligan <gilligan@arista.com>, Dan Carpenter <error27@gmail.com>, 
	David Laight <David.Laight@aculab.com>, Dmitry Safonov <0x7f454c46@gmail.com>, 
	Eric Biggers <ebiggers@kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, 
	Francesco Ruggeri <fruggeri05@gmail.com>, Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>, 
	Ivan Delalande <colona@arista.com>, Leonard Crestez <cdleonard@gmail.com>, 
	Salam Noureddine <noureddine@arista.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Herbert,

On Fri, 19 May 2023 at 10:29, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Allow hmac to be cloned.  The underlying cipher needs to support
> cloning by not having a cra_init function (all implementations of
> aes that do not require a fallback can be cloned).
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Does this imply that the cmac-aes-ce and cmac-aes-neon implementations
for arm64 need a similar treatment?

> ---
>
>  crypto/cmac.c |   18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>
> diff --git a/crypto/cmac.c b/crypto/cmac.c
> index bcc6f19a4f64..fce6b0f58e88 100644
> --- a/crypto/cmac.c
> +++ b/crypto/cmac.c
> @@ -213,7 +213,22 @@ static int cmac_init_tfm(struct crypto_shash *tfm)
>         ctx->child = cipher;
>
>         return 0;
> -};
> +}
> +
> +static int cmac_clone_tfm(struct crypto_shash *tfm, struct crypto_shash *otfm)
> +{
> +       struct cmac_tfm_ctx *octx = crypto_shash_ctx(otfm);
> +       struct cmac_tfm_ctx *ctx = crypto_shash_ctx(tfm);
> +       struct crypto_cipher *cipher;
> +
> +       cipher = crypto_clone_cipher(octx->child);
> +       if (IS_ERR(cipher))
> +               return PTR_ERR(cipher);
> +
> +       ctx->child = cipher;
> +
> +       return 0;
> +}
>
>  static void cmac_exit_tfm(struct crypto_shash *tfm)
>  {
> @@ -280,6 +295,7 @@ static int cmac_create(struct crypto_template *tmpl, struct rtattr **tb)
>         inst->alg.final = crypto_cmac_digest_final;
>         inst->alg.setkey = crypto_cmac_digest_setkey;
>         inst->alg.init_tfm = cmac_init_tfm;
> +       inst->alg.clone_tfm = cmac_clone_tfm;
>         inst->alg.exit_tfm = cmac_exit_tfm;
>
>         inst->free = shash_free_singlespawn_instance;

