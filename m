Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81A2D6D5ECC
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234722AbjDDLQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbjDDLQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:16:15 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4651C1BE2;
        Tue,  4 Apr 2023 04:16:14 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id ew6so128975585edb.7;
        Tue, 04 Apr 2023 04:16:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680606973;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a93jlFBEn37wnN+TcvU+K1AUTd72n1q82Rp2YlCTV3Q=;
        b=UyIkfrOmB7rJCwWoTVRwQQD9qhL2RcE3FbLY5o+pvNKiqfTCRdmL+TaH24hsQTY+ic
         /KodZsrgfNJPO93oHf67gUhdgVUgngVo1d/CxmFL4gU8qGrmHmcXfNtxCmkoESC7oU4H
         xVRn2djQO0j39P1cxFDg/84Ef4keE0k/wYGBgDm39dTMyYDywBQ7CZwLW3tYQpzmf9en
         yzJBz53R7NLVRYZN0nUvYPtv8HufFKZ1q+CcU/XYS/94AVd8BdW87AWvSyQJYmEisaat
         mKHEYQ0ytW8SuPd6GQOlgZ+GnQX/viQ6V/e83g9YIbapJakUswthgweaQ2og+JRWrT0X
         GaKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680606973;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=a93jlFBEn37wnN+TcvU+K1AUTd72n1q82Rp2YlCTV3Q=;
        b=pyZXAHZLn06pcdeaeyNWU0H6Y0dbct0/J9N4fsrgaDV8k+kzIHQB5TRO8bBTf52g77
         7r+WC2GE+KIkQwMtdgrR1z9pZsvPWNlsey9vjgzeITkQsbe78u8KAVStxB8pLwzf3mhV
         icWioX3HPbnjPscmW+AucfbKGKDO8xZimJwRkOL1YTJJbQmJMWVfdTiWUxDLC/qINNOD
         b5OUhGFEhxu1tUige8hzHkjcTeDx9x7uGpNGkwaxJYY1jelnIUBDDzruiOk27SjGtbrW
         InzFlXmoE6vdjeqZW4PtrSB+gtirGPLIVfrYevEzQlpyjNGlj+xszs7duQESrRdFn5RN
         oAAA==
X-Gm-Message-State: AAQBX9eje7YBCKXnFrlceDgbZWeZpZjrsbJnI1ooem1IwjN/sobpdmZk
        sgm+jsiNfIgvwNuWB3UT9l8=
X-Google-Smtp-Source: AKy350YX2rjJgE8ohoVGUGgdqkT4aMdrcxdH+2xwiWoRgZ0Iqukk70bnmVt/ZEgV6aKvJBaBqME0gg==
X-Received: by 2002:a17:907:170a:b0:8dd:5710:a017 with SMTP id le10-20020a170907170a00b008dd5710a017mr1740550ejc.4.1680606972817;
        Tue, 04 Apr 2023 04:16:12 -0700 (PDT)
Received: from orome (p200300e41f1c0800f22f74fffe1f3a53.dip0.t-ipconnect.de. [2003:e4:1f1c:800:f22f:74ff:fe1f:3a53])
        by smtp.gmail.com with ESMTPSA id f24-20020a170906825800b008bc8ad41646sm5815788ejx.157.2023.04.04.04.16.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 04:16:12 -0700 (PDT)
Date:   Tue, 4 Apr 2023 13:16:10 +0200
From:   Thierry Reding <thierry.reding@gmail.com>
To:     Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next 11/11] net: stmmac: dwmac-tegra: Convert to
 platform remove callback returning void
Message-ID: <ZCwG-iyu43vKoFGu@orome>
References: <20230402143025.2524443-1-u.kleine-koenig@pengutronix.de>
 <20230402143025.2524443-12-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="OpE5E+f+NrCfJbvo"
Content-Disposition: inline
In-Reply-To: <20230402143025.2524443-12-u.kleine-koenig@pengutronix.de>
User-Agent: Mutt/2.2.10 (2023-03-25)
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--OpE5E+f+NrCfJbvo
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 02, 2023 at 04:30:25PM +0200, Uwe Kleine-K=C3=B6nig wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is (mostly) ignored
> and this typically results in resource leaks. To improve here there is a
> quest to make the remove callback return void. In the first step of this
> quest all drivers are converted to .remove_new() which already returns
> void.
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> ---
>  drivers/net/ethernet/stmicro/stmmac/dwmac-tegra.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Acked-by: Thierry Reding <treding@nvidia.com>

--OpE5E+f+NrCfJbvo
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEiOrDCAFJzPfAjcif3SOs138+s6EFAmQsBvoACgkQ3SOs138+
s6EduRAAv3uNT9SNrysZJ44HOk63A5CQb1xTEVAacJguS9BsNgRfH79RGsaT9jWp
axQPQQcoyqH9pSmJLUdXyknDjQ0V2fLjCm7FlMTpPn+WGarF6FEBy2F/0Q7B30d/
LIb1zYnuwNfW6rCWzZo/cTK/Neck8+zC7TQRbAg5PMrNGZadZf/wEpg+tBY4lL+X
Dcrs4n+fD89x1VSEynqBIg3AyMFGsh1iWNQ9Icn7Hi9PUe2PiyUJmqmEPEwp6xEu
qD3AwrN0jX+exBIn4BxojVms2alChLZvTDVzxWM2l217ANgALCWf/MQlBcGhuPpl
j3wqdKpbRUcrg/B0BeFSQ1Fy2rrOnUbnexngxHsqG4voE6BZrXTicUjPH4pzOp7d
KvEtXVVMmo5n3mXMI8PBUsJl3k3YQnMEo+Bu1JHf9q8EYrOmDLXkkopP/BmTXrN3
WswMR7BcGyC1rkMJ6pmnAp0qvEd8E5BK5NM6I6npvs0qaqw6rzYLNylMQkAwLpgK
lVNsi8Gl/XSFtJwADUurLKiZCy/nkNXWh7O080/EZlKPkhEnvWemUndATh29ClmP
DI7BbFaLtnb73mTtfuBozbIiFsZMnu4KfCls72hS1zYrFJ9FahXTSE6ny1InV86T
UMNUYLR2MpLbYdqCJ07gm/3no/ErA/L4IRmzAWPMOLPu2gg869U=
=/3Yh
-----END PGP SIGNATURE-----

--OpE5E+f+NrCfJbvo--
