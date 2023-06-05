Return-Path: <netdev+bounces-7978-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BF021722512
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 14:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 24FFD2810FA
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 12:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E50F517AD1;
	Mon,  5 Jun 2023 12:00:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D29FA11C9B
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:00:17 +0000 (UTC)
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D169F115
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 05:00:13 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id 2adb3069b0e04-4f3b4ed6fdeso5800693e87.3
        for <netdev@vger.kernel.org>; Mon, 05 Jun 2023 05:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=flowbird.group; s=google; t=1685966412; x=1688558412;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=thzSH8V+nZGLdDe/+tQbOyX8rabWsuWIkl957hX7v7Q=;
        b=RUa4tbD/sPD6sWa3AdagabOEWCHU6V/CtzVoJOCo2sGOvsG30PMX7PLhTIGKOuTIyo
         XxfBAHXXoFGTlaYi6QUY80VJOnuhFraFASG7j75K79ZrkALR1xiI9JrtwKkuRsBveqXG
         /TuwuzgKu+ef1U+eBw3T0lcRpZ+taPBziEjLtXdV1gjigdL6zqg74hNLLv2H2PoQLVwz
         4ls2nwGepYtah2YXZhlgeAjQt/tGF7g5uBbZGFLXZZW/uGV1pUeyGngRkBFG6eZMRpPu
         4xuKACGw0ns/y+puCfW+ms/zrjfKCGg5BweaS2bJAggEyLa03T/UiK+qrQ6/hZtJHxGq
         ZSow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685966412; x=1688558412;
        h=cc:to:subject:message-id:date:from:reply-to:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=thzSH8V+nZGLdDe/+tQbOyX8rabWsuWIkl957hX7v7Q=;
        b=F/nvksWpsTPfjItADEyEPRxPzaecLca27tlKFx0L59r4re93U0I0Y6AFE9dXaxxdiR
         0IY7J0EjwxeaydmZpNtgV2+Fp1+2jX2lq2mWmOU8SsDFYEjvED1i6fxfr0sTKMit3/Ok
         5L0lFIabAlPmpHqwBtaGikU8NQU6OApU7D4r7rmHTzQRqv7pI1WKc/s88xRTcNFezi0Z
         XCmrdk1ghHcnsZi+82Ghtfrx9PhFin/Pv4z3M8n5p0sZGXWWJaiz60cjAV5o+QqA6FsG
         Yqv3mJrM6vFuyF0RIuHfK3wJADEr7KOzV1MoNVDiOY3wr2/9RWDz0GLSpHCeHW3AHYxJ
         q9Hw==
X-Gm-Message-State: AC+VfDzW/+YEKmwtEQd4W8GxpnwCMhEH7StpwZJh3eGXtaCWSkGtdBUb
	tNHkb7ZuRrs8DZFblt1e1aR3rzzRYBnMvLKDyTGalg==
X-Google-Smtp-Source: ACHHUZ7MSFXuPm9koNZLkoYBZda/IAEnTR32LE4oAkc+Uxi5KLrzWrxz8SP1xYmUtdUlzgzEDuPLfxFtyWlpO9O4NVg=
X-Received: by 2002:a2e:8746:0:b0:2ac:8486:e318 with SMTP id
 q6-20020a2e8746000000b002ac8486e318mr3802494ljj.35.1685966411960; Mon, 05 Jun
 2023 05:00:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <1675433281-6132-1-git-send-email-ganapathi.kondraju@silabs.com>
 <87lekj1jx2.fsf@kernel.org> <8eb3f1fc-0dee-3e5d-b309-e62349820be8@denx.de>
 <112376890.nniJfEyVGO@pc-42> <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
In-Reply-To: <dd9a86af-e41a-3450-5e52-6473561a3e18@denx.de>
Reply-To: martin.fuzzey@flowbird.group
From: "Fuzzey, Martin" <martin.fuzzey@flowbird.group>
Date: Mon, 5 Jun 2023 14:00:00 +0200
Message-ID: <CANh8Qzzzg775T87UvoTywj-ByuP4=_9KpHkCgP4TqZW5CBY=pg@mail.gmail.com>
Subject: Re: [PATCH v3] MAINTAINERS: Add new maintainers to Redpine driver
To: Marek Vasut <marex@denx.de>
Cc: =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>, 
	Kalle Valo <kvalo@kernel.org>, Ganapathi Kondraju <ganapathi.kondraju@silabs.com>, 
	linux-wireless@vger.kernel.org, Amitkumar Karwar <amitkarwar@gmail.com>, 
	Amol Hanwate <amol.hanwate@silabs.com>, Angus Ainslie <angus@akkea.ca>, 
	Jakub Kicinski <kuba@kernel.org>, Johannes Berg <johannes@sipsolutions.net>, 
	Martin Kepplinger <martink@posteo.de>, Narasimha Anumolu <narasimha.anumolu@silabs.com>, 
	Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>, 
	Shivanadam Gude <shivanadam.gude@silabs.com>, Siva Rebbagondla <siva8118@gmail.com>, 
	Srinivas Chappidi <srinivas.chappidi@silabs.com>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 5 Jun 2023 at 11:59, Marek Vasut <marex@denx.de> wrote:
> I have to admit, the aforementioned paragraph is quite disturbing,
> considering that this patch adds 6 maintainers, is already in V3, and so
> far it is not even clear to silabs how much effort it would be to
> maintain driver for their own hardware, worse, silabs didn't even check.
> What is the point of adding those maintainers then ?
>
Totally agree.

IMHO (very humble, I'm not a maintainer, just a guy who has submitted
and had merged a few patches to this driver) people shouldn't be added
to MAINTAINERS
*just* because they work for the company making the hardware and have
been assigned to do driver work for it.
Rather I think they should demonstrate, over a couple of development
cycles, their ability and availability, preferably both submitting
patches themselves and reviewing other patches.
(This is not in any way a judgement of the proposed maintainers as I
have seen nothing from them).

And starting with one or two people doing that part time would be a
way for Silabs to get a better idea of the effort needed.

> This driver is basically unusable and I am tempted to send a patch to
> move it to staging and possibly remove it altogether.
>
I do think this is a little harsh though. It certainly still has bugs
but I think it is usable, at least for some use cases.

>
> Multiple people tried to fix at least a couple of basic problems, so the
> driver can be used at all, but there is no documentation and getting
> support regarding anything from RSI is a total waste of time. Sadly, the
> only reference material I could find and work with is some downstream
> goo, which is released in enormous single-commit code dumps with +/-
> thousands of lines of changes and with zero explanation what each change
> means.
>
Yes absolutely and this is a huge problem for this type of driver.

For simpler hardware (like most I2C, SPI chips) anyone who has
reasonable knowledge of the Linux kernel and the hardware datasheet
can write a driver.
Here the hardware datasheet isn't enough you really need the firmware
interface documentation (which isn't available publicly) because
the actual *hardware* isn't that important from a driver perspective.
The driver is an interface between the Kernel 802.11 stack and the
*firmware*.

Actually I would rather have public interface documentation than
official maintainers working for the vendor (though both would be
great).

Martin

