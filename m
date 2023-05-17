Return-Path: <netdev+bounces-3350-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E43AF70687B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:44:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CFB391C20DA9
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0805818B0E;
	Wed, 17 May 2023 12:44:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16F4211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:44:08 +0000 (UTC)
Received: from mail-yb1-xb34.google.com (mail-yb1-xb34.google.com [IPv6:2607:f8b0:4864:20::b34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D4A269F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:44:06 -0700 (PDT)
Received: by mail-yb1-xb34.google.com with SMTP id 3f1490d57ef6-ba8253f635cso943077276.0
        for <netdev@vger.kernel.org>; Wed, 17 May 2023 05:44:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1684327446; x=1686919446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gNevE736BEsxBU0FmwLJIhGqBiG7yoAC/t6/uUIBMdY=;
        b=FMlLS0aECYmfOvG19PTRQ4JzQVOPvgp3keEl4q4lBIcarONNex1FSS2aSSOrdLjxfE
         OYiPfSd3p8dfD1QItx7D8wl2cvYk/x1+YjFMYiLcupDwHagK7bMFjrihVjrw89h1isK/
         BL8m4dOesp9dOvFJIsPhRXwRJJZw0WXMjrRaZLCGs1aGyZghu3sRXCSFqAbHEbi4bEe9
         sb34beQApq2PcsJ82bacmFQQUt6j72BaQNjANrnbsGmWxQJeZKXoqvssjMl8KTkBxSm2
         hNmUL8hfNmz56/sTiGz6zGIXfLgQdcu9zLtf9Q3wfq58AlUNYHc4mTp5/+V36z6r3Z0n
         03CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684327446; x=1686919446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gNevE736BEsxBU0FmwLJIhGqBiG7yoAC/t6/uUIBMdY=;
        b=FqA9OFUjnaX/wn9D7STNU8wvfSJyKno9EN2Ajc3Wbn3m4Nbkxa/KNH7OK16gc3MeWM
         jsRt5icj7H1IZHfzU3BQ3xqOjvQjIlMZZJcVQKth9oIBVitwG8ETOWLTIzXLYVVrJLhZ
         DzzHqmmlaYw8mm+MdQ8LSUAlntk/WFugOp+qbc27aoSuU1uuExgN4UOl60MHlBydUMMK
         LL9kYTRFji3UOti4UyydySG/xs5eByNn3fSUGXG/3lkMfiaXHARX2hfz2Xfp3ETTsA49
         PdouKmODkErVBBBgXfavLNiLQwUEiycza3TVU9KHUPB2PIhoCK9c+Kkx2JvXLu0XaR9o
         YB5w==
X-Gm-Message-State: AC+VfDzTyfi9wvJRIFW7u96Ayzru6XYHpygdayAPTSveA8TZgueRXdIW
	kxQgNLzJ7u28Jqlcg3mL7n8yn2EM9MvtkGw60Dzw+g==
X-Google-Smtp-Source: ACHHUZ4prpZ1ZwoDxxoHkrbtIQ9L4j9bzrbZd//ns/O1W/Gj5TZTAbzyimVq3qT7URmcD+Feztnv9pZGkl2jlaxwl+I=
X-Received: by 2002:a25:1504:0:b0:ba7:382f:6380 with SMTP id
 4-20020a251504000000b00ba7382f6380mr12543280ybv.24.1684327445737; Wed, 17 May
 2023 05:44:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1684220962.git.mazziesaccount@gmail.com>
In-Reply-To: <cover.1684220962.git.mazziesaccount@gmail.com>
From: Linus Walleij <linus.walleij@linaro.org>
Date: Wed, 17 May 2023 14:43:54 +0200
Message-ID: <CACRpkdYPZWNTOW6c0q1+q64JRvxUXswQqm6j5N5KaAWO=sSUaQ@mail.gmail.com>
Subject: Re: [PATCH v4 0/7] fix fwnode_irq_get[_byname()] returnvalue
To: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>, 
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Daniel Scally <djrscally@gmail.com>, 
	Heikki Krogerus <heikki.krogerus@linux.intel.com>, 
	Sakari Ailus <sakari.ailus@linux.intel.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
	Lars-Peter Clausen <lars@metafoo.de>, Michael Hennerich <Michael.Hennerich@analog.com>, 
	Jonathan Cameron <jic23@kernel.org>, Andreas Klinger <ak@it-klinger.de>, Marcin Wojtas <mw@semihalf.com>, 
	Russell King <linux@armlinux.org.uk>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	=?UTF-8?Q?Jonathan_Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>, 
	Paul Cercueil <paul@crapouillou.net>, Wolfram Sang <wsa@kernel.org>, Akhil R <akhilrajeev@nvidia.com>, 
	linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-iio@vger.kernel.org, netdev@vger.kernel.org, openbmc@lists.ozlabs.org, 
	linux-gpio@vger.kernel.org, linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Tue, May 16, 2023 at 9:12=E2=80=AFAM Matti Vaittinen
<mazziesaccount@gmail.com> wrote:

> The fwnode_irq_get() and the fwnode_irq_get_byname() may have returned
> zero if mapping the IRQ fails. This contradicts the
> fwnode_irq_get_byname() documentation. Furthermore, returning zero or
> errno on error is unepected and can easily lead to problems
> like:

Also, zero is not really a valid IRQ, it means NO_IRQ:
https://lwn.net/Articles/470820/

I'll apply the pinctrl patches.

Yours,
Linus Walleij

