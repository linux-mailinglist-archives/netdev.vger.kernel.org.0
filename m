Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5639E6093BD
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 15:47:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230206AbiJWNrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 09:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiJWNrF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 09:47:05 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC5535C975;
        Sun, 23 Oct 2022 06:47:03 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id u6so6367790plq.12;
        Sun, 23 Oct 2022 06:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3nHa8A+7PeIMg7RKdNLlRzsKGG0uAkGmk1JSJv06f7g=;
        b=f2Cppc+QfZk1KXVH6JcNRhs8g7DPxaW5ORqSgC5zYxTOJHX4Znuc/dXjM3N/q6m89d
         +waRzpUa3GYJ7QiIORnDN1J9gVB9Wyqd+F8iwhrsMrD49QrXT9JPTtqzNHUrHJKxgxAE
         1rzC5bcP8RTof1JSPL/cmRJlwYu3SfBGUeQ1YHbbwRZzRyUxUuOwhpckW9eKAoHAIvdX
         D+2N5eg78YTFFRWxrg+5O9RLcTYC5pXXlhVrMvYY9RxQ7rHdg0rifkQn85dPqe8Q+wya
         05lOONZSOoHJLN0FPL0XG/ja/EL2aF4P+Slx3vbLEAezGK4GczXjOgZ86AxFi1CVeti2
         naFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3nHa8A+7PeIMg7RKdNLlRzsKGG0uAkGmk1JSJv06f7g=;
        b=RPZnraBq4ya0kYouEsrjgRfldp3JmfcgIPsyzZiM33K2MzjNgLON9aYnxzGtia4VVU
         XKGDNKC2icNbCiLIWPwpj/AXLwPLGCSKm3ZluFVeDQF/Lopax53+yEhXUT56lakvDJ/p
         60cSox29Mz/9wys2Pk+PEwwyOe7oSfrGQi7ob5RX0o0kKe53VD/aSrQ8p/hFT12MIPvQ
         diPEf3YSjZRkeUJEw6XtGOaaQv5mlVuah4/KM9hXDE7yQNUVZFLiijwW1/hj0cFFr3iU
         DvRy1Uj5nl4ccvDOdLRfk0uGsazAT2ZzI//CN6XtCao7AjIgZEKhYzCnOZ+rNq4ZGDYD
         46Bg==
X-Gm-Message-State: ACrzQf3jX/v6hxj3AqDL6mJVfAYnmAFyIDnwVR2M3nQgeZWVWC33DfWX
        QoN5B3Hyow2kVg2kcyw1gfc=
X-Google-Smtp-Source: AMsMyM6NkjM2G8o7YZ+RxKeQn131uK3LWFYzUa0kiOACmGutmZsEEiSpVlcjBePs8fqT48DOK1KZRg==
X-Received: by 2002:a17:90b:4a8f:b0:20d:2f93:3bb with SMTP id lp15-20020a17090b4a8f00b0020d2f9303bbmr68543882pjb.149.1666532823495;
        Sun, 23 Oct 2022 06:47:03 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-1.three.co.id. [180.214.232.1])
        by smtp.gmail.com with ESMTPSA id v16-20020a1709028d9000b0016d5b7fb02esm17976494plo.60.2022.10.23.06.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Oct 2022 06:47:02 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
        id 3065A1005FC; Sun, 23 Oct 2022 20:47:00 +0700 (WIB)
Date:   Sun, 23 Oct 2022 20:47:00 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mptcp: fix repeated words in comments
Message-ID: <Y1VF1DBYePbkTk8x@debian.me>
References: <20221022070527.55960-1-wangjianli@cdjrlc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="M9jz/0j3xO1O4oqZ"
Content-Disposition: inline
In-Reply-To: <20221022070527.55960-1-wangjianli@cdjrlc.com>
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--M9jz/0j3xO1O4oqZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 22, 2022 at 03:05:27PM +0800, wangjianli wrote:
> Delete the redundant word 'the'.
>=20
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  net/mptcp/token.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/net/mptcp/token.c b/net/mptcp/token.c
> index f52ee7b26aed..b817c2564300 100644
> --- a/net/mptcp/token.c
> +++ b/net/mptcp/token.c
> @@ -287,7 +287,7 @@ EXPORT_SYMBOL_GPL(mptcp_token_get_sock);
>   * This function returns the first mptcp connection structure found insi=
de the
>   * token container starting from the specified position, or NULL.
>   *
> - * On successful iteration, the iterator is move to the next position an=
d the
> + * On successful iteration, the iterator is move to the next position and
>   * the acquires a reference to the returned socket.
>   */
>  struct mptcp_sock *mptcp_token_iter_next(const struct net *net, long *s_=
slot,

NAK!

Instead, slightly reword the comment above as "On successful iteration,
the iterator moves to the next position and acquires a reference to the
returned socket.".

Also, you and other @cdjrlc.com developers ignore reviews that request
changes to your patches. If you want to participate in kernel
development community, please don't just sending random patches without
any sort of reply.

I have pointed out this behavior either as part of my review or as reply
to reviews from other developers. I may write this as final warning before
I just say NAK without further ado to your future patches.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--M9jz/0j3xO1O4oqZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY1VF0AAKCRD2uYlJVVFO
o25EAQDIoaFBeuz0b5mrP55Nk6SpOrkxQQ0pTeEwTsUbrqbC2wD/UsccZMALgll3
5yvwmQtwwSeG2n05VcGxoklMaPFGDwQ=
=mQXI
-----END PGP SIGNATURE-----

--M9jz/0j3xO1O4oqZ--
