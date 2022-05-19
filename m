Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C729252CC42
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 08:53:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233532AbiESGxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 02:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiESGxq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 02:53:46 -0400
X-Greylist: delayed 155062 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 18 May 2022 23:53:42 PDT
Received: from dvalin.narfation.org (dvalin.narfation.org [213.160.73.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305D5B82FC;
        Wed, 18 May 2022 23:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1652943219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=9I1ByNdBJU9iQW2DNhg/h5E5pbMnvG3nYpxZmRsX1DI=;
        b=wAVbfJ9XHqBzaF1USTjDN8fFEHpmvhojnDKQrPLoaC/U7KjBFQgG48Y16OEilW9jxf4QQM
        3m+xNw0Rv2tSye2yWiCQJhf2LBp12OR6Hd6xJgKRAbyMq5gfqSSQ6GjZgiOQqd/7bpw1bn
        qGHYXPI902jap7A3AeQFOMAcf4zFdDg=
From:   Sven Eckelmann <sven@narfation.org>
To:     davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: ifdefy the wireless pointers in struct net_device
Date:   Thu, 19 May 2022 08:53:37 +0200
Message-ID: <9613306.YnBLfnAi8y@ripper>
In-Reply-To: <20220518181807.2030747-1-kuba@kernel.org>
References: <20220518181807.2030747-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart4659350.0FORYR1UfH"; micalg="pgp-sha512"; protocol="application/pgp-signature"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--nextPart4659350.0FORYR1UfH
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"; protected-headers="v1"
From: Sven Eckelmann <sven@narfation.org>
To: davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com, Jakub Kicinski <kuba@kernel.org>, Stefan Schmidt <stefan@datenfreihafen.org>, johannes@sipsolutions.net, alex.aring@gmail.com, mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc, linux-wireless@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: ifdefy the wireless pointers in struct net_device
Date: Thu, 19 May 2022 08:53:37 +0200
Message-ID: <9613306.YnBLfnAi8y@ripper>
In-Reply-To: <20220518181807.2030747-1-kuba@kernel.org>
References: <20220518181807.2030747-1-kuba@kernel.org>

On Wednesday, 18 May 2022 20:18:07 CEST Jakub Kicinski wrote:
> diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
> index 83fb51b6e299..b8f8da7ee3de 100644
> --- a/net/batman-adv/hard-interface.c
> +++ b/net/batman-adv/hard-interface.c
> @@ -307,9 +307,11 @@ static bool batadv_is_cfg80211_netdev(struct net_device *net_device)
>         if (!net_device)
>                 return false;
>  
> +#if IS_ENABLED(CONFIG_CFG80211)
>         /* cfg80211 drivers have to set ieee80211_ptr */
>         if (net_device->ieee80211_ptr)
>                 return true;
> +#endif
>  
>         return false;
>  }

Acked-by: Sven Eckelmann <sven@narfation.org>
--nextPart4659350.0FORYR1UfH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAmKF6XEACgkQXYcKB8Em
e0b7JxAAvG4arhZjsM0vWxljExgbu0ArtAZG6my2XE6gczf1v1+DLcCnyLf2U8ps
NmpPpt5wPXmZpKJMEvr+v/mm3U3m1nDjPxV/44aEvVh9APsIuB7qAfipT2hFaJiG
0LijjxQZAUK+2NU3j4MQbSSLe/oJ4Ia6+sU6YjAU42C2TAJIGyJwyX5GMlS4dvjc
B6sOGjaprfERSSPiN4ztpHveRPv+3tzUfl65Pui7qrYLetthCGx7dyqgrjBaXA92
hB2/tJeAQTOa/hhhTPbZl3hzAH9WuypZB6zne6YoaJ4QIAmQqjoZf1rU+MY+WxhY
2KtvuRSPeRtPx6uk01vVw65+GGBKEYrGY5hfXvtV4FKYsHXMHJheaTRogcyb99/a
2XT/azMwSducaSjZ4xjOs9frLw5zJLiVUZDfrYxEcZq4NwaGn8WM1RFMbmnfE8I9
3pbe2V3Q7CNlLJ1C1S7n1bp2F93B/aEpPnHPt6VzgYeRNA3oztjnHnsTUSlnKo1/
hvuT61DAhlY3Pb4ucm5/3gymx/IfdBaxKEBYQcn+GGsXAltwmR4a2g7GW9ChrHB7
Mc3skEknhyNAgoEV5ZDcpuqoInx2E0baAxSwM8jQxCY5Xg07MvtE/DYUII1n0USM
YtEw+QZGXYNU+aaZVj3JygdOIoPz9UUzMGrkNahxuMKGIjTgDDc=
=DM23
-----END PGP SIGNATURE-----

--nextPart4659350.0FORYR1UfH--



