Return-Path: <netdev+bounces-10206-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1221572CDD5
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 20:23:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B7D4828110E
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 18:23:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7322D22624;
	Mon, 12 Jun 2023 18:23:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6897421CE1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 18:23:21 +0000 (UTC)
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12824EC;
	Mon, 12 Jun 2023 11:23:20 -0700 (PDT)
Received: by mail-lj1-x231.google.com with SMTP id 38308e7fff4ca-2b1a7e31dcaso55121271fa.2;
        Mon, 12 Jun 2023 11:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686594198; x=1689186198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fi7DZObmpxIKmE75DEGH66N1cjPuHUykTIHuF+M6PWY=;
        b=l0P0pVkWWaVD0QyJH6BNQSYoXa6yYhsNyLKwobP02ljoI6/t8kqRqZ+DaIhWbyNyxp
         nlCV65vwNkkTN+yuIDsEblCbwQ9t9W3BVUX76zuL+TM6fXXz8UVVybzriQfAnj243JB5
         P1k4okBtC/HJN0VqkiTntBB2VUED9PoPQQlTa+InAWnvHfPDmcY7eO/1N9yHmzaKhPBq
         Vco8+wBXrSOtPi0EZ4rBVI83iB5x2fxl8/ZYsRql/jGs/EMLat3ojq5vL3GrFohuCuDJ
         ErS8DzcnbL2TNo3IJhlyPY3bkDZHkwdHLsHp+X35NHGqZySAbSGhdJ23BmQ4SSM4WnmL
         VkCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686594198; x=1689186198;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Fi7DZObmpxIKmE75DEGH66N1cjPuHUykTIHuF+M6PWY=;
        b=l3LPgBX/M/RDf9bVKmp88ZAevgx8ovxoj5U+oq3UYLIZpm0YiLn/G11b3P/iWCxOOj
         Inz0CP98zbNPDSuQNG4Z5tZlX3J8CIFy1tKqPc/HKu22haVK30llk/QfFwnlV5p0QCdM
         GZE7upw+4D+JmAadQz5whIWfPXiCykZINTbSVc7D1aHodomhym9Ba8Qwi/FymdD5gimK
         2PCIINBJpEmGNZ5gh1j338HDgKoHlESuEzV9RD+OOBGxwOI0Q3CEr1r1By01JOSiDxbU
         vTYRxgJXMtIxNaW308Od3Cz7X/INzruoINGinT8618maPST3Tj3Cc8iFDekhNwSChX24
         fyYQ==
X-Gm-Message-State: AC+VfDzd+SiegqZFWaLTpmb/iImYy56eMiu7ib8CV7TYdnzBBc8BBK1w
	x5fQE5Wt0rVgDb0zFMNCMvEb1+4D7mlW5tE/B6s=
X-Google-Smtp-Source: ACHHUZ486uvk9Krh2TcyuQ5OEWd5eLkyRBL7R0/ZbqVj7fwvk4ON8mbAVa1d2QNjRdZ8AWkJwRd1Sv+wIhOUI/5DePI=
X-Received: by 2002:a2e:a165:0:b0:2ae:e214:482f with SMTP id
 u5-20020a2ea165000000b002aee214482fmr3361021ljl.52.1686594198050; Mon, 12 Jun
 2023 11:23:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230609141812.297521-1-alexis.lothore@bootlin.com>
 <20230609141812.297521-3-alexis.lothore@bootlin.com> <d196f8c7-19f7-4a7c-9024-e97001c21b90@lunn.ch>
 <dbec77de-ee34-e281-3dd4-2332116a0910@bootlin.com> <176f073a-b5ab-4d8a-8850-fcd8eff65aa7@lunn.ch>
 <bb799b06-8ca8-8a29-3873-af09c859ae88@bootlin.com> <CA+sq2CcG4pQDLcw+fTkcEfTZv6zPY3pcGCKeOy8owiaRF2HELA@mail.gmail.com>
 <20230612094321.vjvj3jnyw7bcnjmw@skbuf>
In-Reply-To: <20230612094321.vjvj3jnyw7bcnjmw@skbuf>
From: Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date: Mon, 12 Jun 2023 23:53:06 +0530
Message-ID: <CA+sq2CdkfuMWE4jf0QEQc4w-2Nb45nER64BV8EbSroJcYi=__Q@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: dsa: mv88e6xxx: implement egress tbf
 qdisc for 6393x family
To: Vladimir Oltean <olteanv@gmail.com>
Cc: =?UTF-8?Q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>, 
	Andrew Lunn <andrew@lunn.ch>, Florian Fainelli <f.fainelli@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, Thomas Petazzoni <thomas.petazzoni@bootlin.com>, paul.arola@telus.com, 
	scott.roberts@telus.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, Jun 12, 2023 at 3:13=E2=80=AFPM Vladimir Oltean <olteanv@gmail.com>=
 wrote:
>
> Hi Sunil,
>
> On Mon, Jun 12, 2023 at 12:04:56PM +0530, Sunil Kovvuri wrote:
> > For setting up simple per-port ratelimit, instead of TBF isn't "egress
> > matchall" suitable here ?
>
> "matchall" is a filter. What would be the associated action for a
> port-level shaper?

As Alexis mentioned I was referring to "matchall + policer".

Thanks,
Sunil.

