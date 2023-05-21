Return-Path: <netdev+bounces-4126-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8EF0A70AFC0
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 21:07:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2404B1C2092C
	for <lists+netdev@lfdr.de>; Sun, 21 May 2023 19:07:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 241FE8F61;
	Sun, 21 May 2023 19:07:15 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156E51FA6
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 19:07:14 +0000 (UTC)
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [217.70.183.201])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1527BC6
	for <netdev@vger.kernel.org>; Sun, 21 May 2023 12:07:11 -0700 (PDT)
Received: from booty (unknown [77.244.183.192])
	(Authenticated sender: luca.ceresoli@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 2DDA31BF203;
	Sun, 21 May 2023 19:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1684696030;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mqyYznHTfVAhewCJVUdQ7VMdWhJFx5h/F1J6byiPzxU=;
	b=XoyOiCOUmhnZv/6HRhy4XGviAntNAWiJYf8oUDbiaJUGQ5EariEKLJ1n4k9Brpnzd48Ijp
	GNqdLN4xjdr0/WRTPOgXI9oTERZ8/oLllxkT7sPSTcaqt6EjwLv+rxYtwyECJtFwbwGjCS
	oxPd4RLXJygvSjzhX+S1+cMIFX977XZr4GL0AIG+Lp/5Y9cCvlcog5A4YeKMv9JUEru7L2
	BDFtXR7a5YuhFx844OsR9HUkbnvPtUrVuc7gDFtFCFL4NRA6Cer/8e4shLQlhBwd4RVrsA
	UsauFbjOrLe8o7Gw5jBjEvc6K6sb+akSG4a98/qesiHNBSkiDxjC78i1HGaLqg==
Date: Sun, 21 May 2023 21:07:04 +0200
From: Luca Ceresoli <luca.ceresoli@bootlin.com>
To: Uwe =?UTF-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Vladimir Oltean
 <olteanv@gmail.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Corey Minyard <cminyard@mvista.com>, Peter Senna Tschudin
 <peter.senna@gmail.com>, Kang Chen <void0red@gmail.com>, "David S. Miller"
 <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Shang XiaoJing
 <shangxiaojing@huawei.com>, Rob Herring <robh@kernel.org>, Michael Walle
 <michael@walle.cc>, Benjamin Mugnier <benjamin.mugnier@foss.st.com>, Marek
 =?UTF-8?Q?Beh=C3=BAn?= <kabel@kernel.org>, Petr Machata <petrm@nvidia.com>,
 Hans Verkuil <hverkuil-cisco@xs4all.nl>, Jonathan Cameron
 <Jonathan.Cameron@huawei.com>, Jean Delvare <jdelvare@suse.de>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Jeremy Kerr
 <jk@codeconstruct.com.au>, Sebastian Reichel
 <sebastian.reichel@collabora.com>, Adrien Grassein
 <adrien.grassein@gmail.com>, Javier Martinez Canillas <javierm@redhat.com>,
 netdev@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH net-next] nfc: Switch i2c drivers back to use .probe()
Message-ID: <20230521210704.19cda179@booty>
In-Reply-To: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
References: <20230520172104.359597-1-u.kleine-koenig@pengutronix.de>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
	RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Sat, 20 May 2023 19:21:04 +0200
Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de> wrote:

> After commit b8a1a4cd5a98 ("i2c: Provide a temporary .probe_new()
> call-back type"), all drivers being converted to .probe_new() and then
> 03c835f498b5 ("i2c: Switch .probe() to not take an id parameter")
> convert back to (the new) .probe() to be able to eventually drop
> .probe_new() from struct i2c_driver.
>=20
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>

--=20
Luca Ceresoli, Bootlin
Embedded Linux and Kernel engineering
https://bootlin.com

