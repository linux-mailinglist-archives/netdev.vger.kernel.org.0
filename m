Return-Path: <netdev+bounces-2330-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 36C477014A8
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 08:37:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4C3811C21215
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 06:37:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CA947E1;
	Sat, 13 May 2023 06:37:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E91FEC7
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 06:37:04 +0000 (UTC)
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECC252D5A;
	Fri, 12 May 2023 23:37:00 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id 4fb4d7f45d1cf-50bd37ca954so95813909a12.0;
        Fri, 12 May 2023 23:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683959819; x=1686551819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uYFpbAhkvFBTjOnXoqutGtIEzJiI9XzWLyx/evSFRPs=;
        b=ZDwCPoKhDsaMVA4DZ28mz5uv7DdK9kqQIbuBPI5TTiGMn6p3f3usZotGU5qDDyqaIO
         ng0xO05Jd8LrdLvSkwQmRU5TPujOB8sxvBgIChoecRAcX/QSO3XWNN+IpRT6bh0q5+w+
         oXPKoIceDsgbWl7iPXcwMMQmvGmssj06/bnklDRL/wzCfK+TDuYK0AvSKhdS94L+yoKt
         iCpNIqfNeWQswOkoXX/ssGY4HoTRvjwmv7hine31YNafEsenfklnoLWuBIr95nLHmUJM
         dIx72fBXWOWigU1QSfejbLAJK0W0nwit3wMb6Cc63bAa5qnjrkDN0DY0EUw7f+b1EpkV
         Cx4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683959819; x=1686551819;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uYFpbAhkvFBTjOnXoqutGtIEzJiI9XzWLyx/evSFRPs=;
        b=KEBmzf4Q/UxFPZfZubLGGg9QeIvmVgelYg+NUAsRwz+ewWsPS9o5WctQdOX11BLiQ5
         PpPC20AeWuam7sb0VxLXza/NbB9zL0qyq2hYMX6UoZlNqhMjhMgXx2yqNCOXhyQXlyPX
         2Uph0+2ecal04NFupUhWycv9IjP7GocW610xi8VElom3V7anhp4XFWC6Lt/OEQR53Xo8
         akydQ/2i7MMuaUd7bpytBbk1HxclmXngcXA7NzhHB6z3DAIWQxswm6dwsF1CFo1D+8HM
         2rQY7wWj+wr4OgAxXiVuXUiUBNIyXr8fbIqSD22a8A+7oFKLOWpVwNxfiHQlv/BLfVvK
         oPtA==
X-Gm-Message-State: AC+VfDxrQEESEx6fgoBGiIw2OnV86FEZFuHyE8Xly1m9fevzWMHai7/M
	qakHgsUaglqGDLUzRElhpDndSGPK478=
X-Google-Smtp-Source: ACHHUZ6U/3VzZBDjJhchWHFsH0R1I/SSBEmKisnb8+MCxNQXGXdvu+WFC+oPYObLvSAMQjHue5mW8g==
X-Received: by 2002:a17:907:6e11:b0:96a:2210:7dd8 with SMTP id sd17-20020a1709076e1100b0096a22107dd8mr10416560ejc.38.1683959819039;
        Fri, 12 May 2023 23:36:59 -0700 (PDT)
Received: from jernej-laptop.localnet (89-212-118-115.static.t-2.net. [89.212.118.115])
        by smtp.gmail.com with ESMTPSA id d4-20020a170907272400b00965e9b435dfsm6425131ejl.65.2023.05.12.23.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 May 2023 23:36:58 -0700 (PDT)
From: Jernej =?utf-8?B?xaBrcmFiZWM=?= <jernej.skrabec@gmail.com>
To: Wolfgang Grandegger <wg@grandegger.com>,
 Marc Kleine-Budde <mkl@pengutronix.de>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Chen-Yu Tsai <wens@csie.org>, Samuel Holland <samuel@sholland.org>,
 Uwe =?ISO-8859-1?Q?Kleine=2DK=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-sunxi@lists.linux.dev,
 kernel@pengutronix.de
Subject:
 Re: [PATCH 17/19] can: sun4i_can: Convert to platform remove callback
 returning void
Date: Sat, 13 May 2023 08:36:57 +0200
Message-ID: <5672483.DvuYhMxLoT@jernej-laptop>
In-Reply-To: <20230512212725.143824-18-u.kleine-koenig@pengutronix.de>
References:
 <20230512212725.143824-1-u.kleine-koenig@pengutronix.de>
 <20230512212725.143824-18-u.kleine-koenig@pengutronix.de>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="iso-8859-1"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Dne petek, 12. maj 2023 ob 23:27:23 CEST je Uwe Kleine-K=F6nig napisal(a):
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart from
> emitting a warning) and this typically results in resource leaks. To impr=
ove
> here there is a quest to make the remove callback return void. In the fir=
st
> step of this quest all drivers are converted to .remove_new() which alrea=
dy
> returns void. Eventually after all drivers are converted, .remove_new() is
> renamed to .remove().
>=20
> Trivially convert this driver from always returning zero in the remove
> callback to the void returning variant.
>=20
> Signed-off-by: Uwe Kleine-K=F6nig <u.kleine-koenig@pengutronix.de>

Acked-by: Jernej Skrabec <jernej.skrabec@gmail.com>

Best regards,
Jernej



