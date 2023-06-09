Return-Path: <netdev+bounces-9711-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB25D72A502
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:52:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 247701C21021
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:52:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A0CBB1E50D;
	Fri,  9 Jun 2023 20:52:54 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9264D408D4
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:52:54 +0000 (UTC)
Received: from mail-40132.protonmail.ch (mail-40132.protonmail.ch [185.70.40.132])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBC0330F9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 13:52:52 -0700 (PDT)
Date: Fri, 09 Jun 2023 20:52:47 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1686343970; x=1686603170;
	bh=He8yZMV2kI8DEJFeHkiOpD6I4kpbWyGVezca/gfNczU=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=ZnXS7fHEsgjdPBDSqfMRmtKVAKvHqYiJOovmcJinFKhD+Qe881bRtyJ2yx9rGl4xE
	 doy99lYaqjtNQzsyll1qciZtgHDfIeL7o6kyxtrqMyjSmePiPK8eX7D9pMCD9C8XEc
	 kIhuGElfd4EK025NFCweSwgmW7XvbZQ6tbHsKG9RL9WZGJrvct9yfMb7poq0s0P//t
	 piYx408ZmpvOYIuRSqLwHKRNyCwD9Iazhfu3o3zYK/zHZpItX+IdI+xZrm3514rsCY
	 OgWOFzqr3O0YpzbMPVA9j8FqUH+jDH7oF8fJ8GAfNEyd2WIqhq41nhK1uhZQbjlLpQ
	 XbmLZDaGv2Kbg==
To: broonie@kernel.org
From: Raymond Hackley <raymondhackley@protonmail.com>
Cc: davem@davemloft.net, devicetree@vger.kernel.org, edumazet@google.com, jk@codeconstruct.com.au, krzysztof.kozlowski@linaro.org, kuba@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org, michael@walle.cc, netdev@vger.kernel.org, pabeni@redhat.com, raymondhackley@protonmail.com, robh+dt@kernel.org, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH v2 2/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Message-ID: <20230609205227.105306-1-raymondhackley@protonmail.com>
In-Reply-To: <a3d2dd4f-38ce-40ca-9085-893f808f817b@sirena.org.uk>
References: <20230609154033.3511-1-raymondhackley@protonmail.com> <20230609154200.3620-1-raymondhackley@protonmail.com> <e2bb439c-9b72-991b-00f6-0b5e7602efd9@linaro.org> <20230609173935.84424-1-raymondhackley@protonmail.com> <7ad5d027-9b15-f59e-aa76-17e498cb7aba@linaro.org> <a3d2dd4f-38ce-40ca-9085-893f808f817b@sirena.org.uk>
Feedback-ID: 49437091:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,SPF_HELO_PASS,
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Mark,

On Friday, June 9th, 2023 at 7:34 PM, Mark Brown <broonie@kernel.org> wrote=
:
=20
> Specifically your driver should only ever call regulator_disable() to
> balance out regulator_enable() calls it made itself and it should know
> how many of those it has done. regulator_is_enabled() should only ever
> be used during probe if for some reason it is important to figure out if
> the device is already powered for startup, this should be very unusual.
> If something else enabled the regualtor then whatever did that needs to
> undo those enables, not another driver.

Thnak you for explanation. I should drop regulator_is_enabled() here since
it's misused.

Regards,
Raymond


