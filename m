Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 09BA611A77A
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 10:39:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728605AbfLKJi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 04:38:58 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39089 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728104AbfLKJi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 04:38:58 -0500
Received: by mail-wr1-f65.google.com with SMTP id y11so23220516wrt.6
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 01:38:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vpAB2VunJi/hr5WJdoV5Gbgby6kk23SzTl+e0ymIH3E=;
        b=PGeyFwB2stSmWA6Y07SK58oUwxsuOdFywJjIQOqKUtnN/Vgv26e5IJt3bLoso0HWAl
         umL3nzIIcaCU3opZL0eacrNCQVS557vvz6S98jpxkp8k9Z97a4rjzLpuTZ2rnCXaoAuX
         1krLvgrF1UFYXT6XpcrwcJXi7bDBwaPvAtsarvKYxc8YLV/tVicv9Wxsp/Rcsl9RYnMn
         wdCg+wBrSfVU1o9dRhXb0kDBm9VJwATzO9KwGewATTyZDaBsTzVzpQAfIN4cgNjb558c
         4Be2mIqIest13/lbhIEbYh2b3ca8dQJeqoiAuViGyuCj/kYIxCASXw8QQijYiLT/C+F9
         d4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vpAB2VunJi/hr5WJdoV5Gbgby6kk23SzTl+e0ymIH3E=;
        b=pirbf5+7Ul/0wVcHbQx2lD1adqxJXk214hkLhOT1Lx1uHpfE64jF9OKeWsSoVST2Th
         jEksFBfo7/dwO9waZt7SqlJ4lPgChlqtDjwzhUrYX6OMU3ZC1jbvqcl33Mw6cP7d9aNv
         q6FutFKWHsDdbD+ONL8MrPak82EcX4FIr08buwd+cw2X6gcmgX5RZgudAlpAM1juI4Zs
         WDXBbYNNKbQejnD4k+qJIkpTZqip2TyHy/gXQc1KCWSVhXr2zbjCcvPGrDIrKUZLKks2
         xa5Qr9rqU8z2tVdEVh1Y0JRnY+EI3DN7Wf5KCJNg5WEtDmCT+FLHNGuM1wc888xoobCs
         W0tg==
X-Gm-Message-State: APjAAAU7DI5jQKGNlkPE+cfhaiXO1bcVei5IIHeOo2K4y6Y7kUCthT51
        M0IlX7fHG26Rol6mZtrn6mKFxIxrLCIFnOy/UbiwGw==
X-Google-Smtp-Source: APXvYqzS9NV895DIXOWDSxsk8Dt5Yb3kvVGBjEhZUimO4Ao8HcRX1tAJFyvLkxzffrJ9VDtoRG82u/OcFftgIXiBkLs=
X-Received: by 2002:a5d:6652:: with SMTP id f18mr2765986wrw.246.1576057136102;
 Wed, 11 Dec 2019 01:38:56 -0800 (PST)
MIME-Version: 1.0
References: <20191211102455.7b55218e@canb.auug.org.au> <20191211092640.107621-1-Jason@zx2c4.com>
In-Reply-To: <20191211092640.107621-1-Jason@zx2c4.com>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Wed, 11 Dec 2019 09:38:54 +0000
Message-ID: <CAKv+Gu80vONMAuv=2OpSOuZHvVv22quRxeNtbxnSkFBz_DvfbQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] crypto: arm/curve25519 - add arch-specific key
 generation function
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "<netdev@vger.kernel.org>" <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 at 10:27, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Somehow this was forgotten when Zinc was being split into oddly shaped
> pieces, resulting in linker errors.

Zinc has no historical significance here, so it doesn't make sense to
keep referring to it in the commit logs.

> The x86_64 glue has a specific key
> generation implementation, but the Arm one does not. However, it can
> still receive the NEON speedups by calling the ordinary DH function
> using the base point.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

With the first sentence dropped,

Acked-by: Ard Biesheuvel <ardb@kernel.org>

> ---
>  arch/arm/crypto/curve25519-glue.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/arch/arm/crypto/curve25519-glue.c b/arch/arm/crypto/curve25519-glue.c
> index f3f42cf3b893..776ae07e0469 100644
> --- a/arch/arm/crypto/curve25519-glue.c
> +++ b/arch/arm/crypto/curve25519-glue.c
> @@ -38,6 +38,13 @@ void curve25519_arch(u8 out[CURVE25519_KEY_SIZE],
>  }
>  EXPORT_SYMBOL(curve25519_arch);
>
> +void curve25519_base_arch(u8 pub[CURVE25519_KEY_SIZE],
> +                         const u8 secret[CURVE25519_KEY_SIZE])
> +{
> +       return curve25519_arch(pub, secret, curve25519_base_point);
> +}
> +EXPORT_SYMBOL(curve25519_base_arch);
> +
>  static int curve25519_set_secret(struct crypto_kpp *tfm, const void *buf,
>                                  unsigned int len)
>  {
> --
> 2.24.0
>
