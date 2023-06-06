Return-Path: <netdev+bounces-8313-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 51F137238EA
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 09:24:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B9F0A1C20E6C
	for <lists+netdev@lfdr.de>; Tue,  6 Jun 2023 07:24:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 892326139;
	Tue,  6 Jun 2023 07:24:51 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1335697
	for <netdev@vger.kernel.org>; Tue,  6 Jun 2023 07:24:51 +0000 (UTC)
Received: from mail-4318.protonmail.ch (mail-4318.protonmail.ch [185.70.43.18])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E90EC;
	Tue,  6 Jun 2023 00:24:49 -0700 (PDT)
Date: Tue, 06 Jun 2023 07:24:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1686036287; x=1686295487;
	bh=ev8Fcx4uRSKBT0UZ+/9daeSWpL6Mf5xGj3ULdK8RFiY=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HBpp+eLvDZ4VqGk0hW66/ImSZZVzxoqc0y9X9pn/zllzxcKBeZ4pcRVc8ibKsDUcU
	 So9Nvov/Lp7tDXg/gFLx/97hPHUdW4KXFK9BXhA0YlcLNZfeFse1VvDANNY8CxYbq5
	 hfyipSt1gfPHb5qLkObggAXc+OjFHcU9E1UVgKvnos7cmqqIVtiZ57l7MJWd5jxIuU
	 eFsAKMaEQAu4ksgEZVxAl3hU2EiOZ+uLtWaEzwzhPDZCTRKXKlDbJKStoHgKpeeZsv
	 uYbrTQaGzmilWxbvRgBRDvyzSh0TO+yBkGz+F8VQ9/7zZlceZdxmDtePa3UFMDD8p/
	 gKb07+xRfRKOA==
To: linux-kernel@vger.kernel.org
From: Raymond Hackley <raymondhackley@protonmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Michael Walle <michael@walle.cc>, =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Jeremy Kerr <jk@codeconstruct.com.au>, Raymond Hackley <raymondhackley@protonmail.com>, netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH 0/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Message-ID: <20230606071824.144990-1-raymondhackley@protonmail.com>
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
	SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PN547/553, QN310/330 chips on some devices require a pad supply voltage
(PVDD). Otherwise, the NFC won't power up.

Implement support for pad supply voltage pvdd-supply that is enabled by
the nxp-nci driver so that the regulator gets enabled when needed.


