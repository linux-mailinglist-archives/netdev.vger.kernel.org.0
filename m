Return-Path: <netdev+bounces-2540-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72BD9702676
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:53:29 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1ED27281155
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:53:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A7C98488;
	Mon, 15 May 2023 07:53:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB151FB1
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:53:26 +0000 (UTC)
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93DBBD;
	Mon, 15 May 2023 00:53:22 -0700 (PDT)
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-55b7630a736so182997097b3.1;
        Mon, 15 May 2023 00:53:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684137201; x=1686729201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JERc9IUVRqk4tjUXjqhcThAzcCzz7kZRH46NjyT79tk=;
        b=J0jOv9zyW1RRGzumstQ9oZxx/XrZ9L92v0FUPhoAovtAzR9uTv4G188MHN0/R81C74
         +594LUWc+RvPoZjGlimRMRT933F7CsMwgbUhJaPkZitx8h+1YuNebeSxISZyOuz3rGAQ
         mtyvK3tzBAH0h3xBuvIoq8on+jPv6i/dRjlMBf/BjNaVZ0g0WhGxHIpAc7cb/EP7pXxF
         JAhwySJ/8lGQk3W7+wvWxQXnolVqA4yGMMDXMFYlywZHDPyB7P3rTeE/ZFD2dFGzWWuW
         1USzq0KcGzUaL4xZLWKV7Axrbi3Oq6KBZ43xJS+Qsgd62XeFdfvhyCqRu99/oPxyO9nr
         RSCw==
X-Gm-Message-State: AC+VfDxYVoYBLqbP4FhMvHvwkdjVyjKRSuJraQ6hheACspMcIALklOXN
	iUkqGJ8HKWZ9eh0BSDLtUqv3vhyLBizCag==
X-Google-Smtp-Source: ACHHUZ6JkJIYJSySCOHbRo+xuKvYtW5Wp+tO6UebIeOS2ZeO5CMe2qeAMYTskOKwrZfPJkj3lMyRfA==
X-Received: by 2002:a0d:d705:0:b0:55a:792:8c20 with SMTP id z5-20020a0dd705000000b0055a07928c20mr31296750ywd.6.1684137201624;
        Mon, 15 May 2023 00:53:21 -0700 (PDT)
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com. [209.85.128.179])
        by smtp.gmail.com with ESMTPSA id l65-20020a0dfb44000000b005461671a79csm4813655ywf.138.2023.05.15.00.53.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 00:53:21 -0700 (PDT)
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-55a76ed088aso182863377b3.2;
        Mon, 15 May 2023 00:53:20 -0700 (PDT)
X-Received: by 2002:a0d:e808:0:b0:55a:4ff4:f97d with SMTP id
 r8-20020a0de808000000b0055a4ff4f97dmr31597295ywe.48.1684137200429; Mon, 15
 May 2023 00:53:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230512212725.143824-1-u.kleine-koenig@pengutronix.de> <20230512212725.143824-14-u.kleine-koenig@pengutronix.de>
In-Reply-To: <20230512212725.143824-14-u.kleine-koenig@pengutronix.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Mon, 15 May 2023 09:53:09 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVAy2RKkAesNi1PDJmzWUTQqViho7zGOmZr0ooGD+je_g@mail.gmail.com>
Message-ID: <CAMuHMdVAy2RKkAesNi1PDJmzWUTQqViho7zGOmZr0ooGD+je_g@mail.gmail.com>
Subject: Re: [PATCH 13/19] can: rcar: Convert to platform remove callback
 returning void
To: u.kleine-koenig@pengutronix.de
Cc: Wolfgang Grandegger <wg@grandegger.com>, Marc Kleine-Budde <mkl@pengutronix.de>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>, Oliver Hartkopp <socketcan@hartkopp.net>, 
	Geert Uytterhoeven <geert+renesas@glider.be>, Biju Das <biju.das.jz@bp.renesas.com>, 
	Simon Horman <simon.horman@corigine.com>, 
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>, linux-can@vger.kernel.org, 
	netdev@vger.kernel.org, kernel@pengutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Fri, May 12, 2023 at 11:27=E2=80=AFPM Uwe Kleine-K=C3=B6nig
<u.kleine-koenig@pengutronix.de> wrote:
> The .remove() callback for a platform driver returns an int which makes
> many driver authors wrongly assume it's possible to do error handling by
> returning an error code. However the value returned is ignored (apart fro=
m
> emitting a warning) and this typically results in resource leaks. To impr=
ove
> here there is a quest to make the remove callback return void. In the fir=
st
> step of this quest all drivers are converted to .remove_new() which alrea=
dy
> returns void. Eventually after all drivers are converted, .remove_new() i=
s
> renamed to .remove().
>
> Trivially convert this driver from always returning zero in the remove

these drivers

> callback to the void returning variant.
>
> Signed-off-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds

