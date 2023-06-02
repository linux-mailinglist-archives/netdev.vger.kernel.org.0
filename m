Return-Path: <netdev+bounces-7326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BC3CD71FAF2
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 09:27:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D0E222815E5
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:27:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA5B26FC1;
	Fri,  2 Jun 2023 07:27:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B1163CC
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 07:27:19 +0000 (UTC)
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7323F13D
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 00:27:18 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-565cfe4ece7so17947687b3.2
        for <netdev@vger.kernel.org>; Fri, 02 Jun 2023 00:27:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685690837; x=1688282837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5iKrlwDoHpe9gRi661od6BlAYjq4eVKNFoJJmd4gjjg=;
        b=DXv6Bz2K+iTxmhrVVgRWeYD001IAxxIlBIJFqn0/Roz5mgayh481V94B02RQ8E1gge
         tnUi6MtwSJOtYyWP9GUpoXzWngnMEXtqw8VWh8WXksCgc/ewiowsIGqDKz4B/KWD69Fs
         kShaW4Ydzj6uLYR65wsHA1+VDpLWHUSIlOSeNio9njhthyD1yK7Rt3GLsxdTmEdopMq9
         aU2vuf6soagLbuBcyJp/Dc2KiUyPklr9NOG9kHrjbt5dUoZ6zEQCWqwVx5wkDeDApJIq
         DR+Xh0J/gzp0YWFOPk0Hs4rm4BT6bp+7ZruSabE5OLzgPKy1YwUc9/Jy/Y6Wq0KLqEpq
         YsXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685690837; x=1688282837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5iKrlwDoHpe9gRi661od6BlAYjq4eVKNFoJJmd4gjjg=;
        b=BGtrLl4w92/Hz6wzyy1CEscINYWaA/7970EUk7a79XUH3LlUlCoueW+TQmB2wy2RYP
         P3nnWEMuJgchsAowp0I/DMhMNI0luwVhG9rH4fw3tNAA/mgfy6s3Fj7dg/400QQGBFJj
         mH5Pm0Gby9awLtd7vqzxuuCXw6OYcsrm+EaexB872kPD2hfbw8hLq3glFy3InMOYRdbQ
         ABDN+Pq4IN6QqRRFcoAVxJUEp3DGgcHHjPZebzNn26rYnv7U+FuJVQCNS96Pdvq+QIat
         ksHSjmTysoMoyTE3no03j7Vqmufi3gQPAirZANo50/jRXbdkRQHk2WdnTltTHbAVsiTd
         asiw==
X-Gm-Message-State: AC+VfDyHi15//Ly0CoxnhQylBmaL5VOp1IEJ8RbnKaR9dQj4wFBAzqOt
	igx8VJofg/1uuIUWR8UzZJJ2gZ7BDLIm1qM3OxYt3Q==
X-Google-Smtp-Source: ACHHUZ5NEpY+OKVNq/RYBBHyUzUo0UwSgMvKCroP0Pf7nDQZt2Walm3Nsa9jSpnuykrAT20vk31ZaapaPjB/RR/M8x4=
X-Received: by 2002:a0d:d843:0:b0:561:e724:eb3 with SMTP id
 a64-20020a0dd843000000b00561e7240eb3mr11111373ywe.17.1685690837614; Fri, 02
 Jun 2023 00:27:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230424123522.18302-1-nikita.shubin@maquefel.me> <20230601054549.10843-2-nikita.shubin@maquefel.me>
In-Reply-To: <20230601054549.10843-2-nikita.shubin@maquefel.me>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Fri, 2 Jun 2023 09:27:06 +0200
Message-ID: <CACRpkdY6VzYfGPUHed6rmNx8KbzWgVsz=G7wwCx1MkZ5pBxLaA@mail.gmail.com>
Subject: Re: [PATCH v1 20/43] net: cirrus: add DT support for Cirrus EP93xx
To: Nikita Shubin <nikita.shubin@maquefel.me>
Cc: Alexander Sverdlin <alexander.sverdlin@gmail.com>, Arnd Bergmann <arnd@arndb.de>, 
	Hartley Sweeten <hsweeten@visionengravers.com>, Russell King <linux@armlinux.org.uk>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Michael Peters <mpeters@embeddedts.com>, Kris Bahnsen <kris@embeddedts.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Thu, Jun 1, 2023 at 7:45=E2=80=AFAM Nikita Shubin <nikita.shubin@maquefe=
l.me> wrote:

> - find register range from the device tree
> - get "copy_addr" from the device tree
> - get phy_id from the device tree
>
> Signed-off-by: Nikita Shubin <nikita.shubin@maquefel.me>

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Looking really good.

Yours,
Linus Walleij

