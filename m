Return-Path: <netdev+bounces-9587-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 686DB729ED0
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 17:41:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6DC1F1C210DA
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 15:41:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EA7719539;
	Fri,  9 Jun 2023 15:41:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EDFB17757
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 15:41:20 +0000 (UTC)
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0CE030FD;
	Fri,  9 Jun 2023 08:41:19 -0700 (PDT)
Date: Fri, 09 Jun 2023 15:41:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1686325275; x=1686584475;
	bh=MtQCFhQTmoGLEq+XUTxl6fTfKwin0Ngq2howogrI7cE=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HrYGRFg8A5pYNrkpxitLJs4kuowlxq7RSm/uAp8FcxhBoNvHrVAxJassm7zMwN2uT
	 NW1ZBv0jcAgOw30rXPB8ND3a3B5EUi8i95hWzpbyBLyc6QJunl5g36NgeuAGIRlwAx
	 ezMfwf1h0XDq+ev+TKMbvlinMUrMd26skq5QoE5o8W8fRbgoOVVxN0ZgmI1gfTee1I
	 g1iE2Vl1vKVzjZWuZUl4wxFbyxpyuH/e8cGWqFKmwA2n5DOIA4ys714Pr8d7VtASD3
	 mA3PqJTVQ+lADiwQpmRZu+yyUUbuuiJyjKaHo5TYqGcHa/Y4k/fkdtSuolStvdVrP9
	 MNGpaHX1D56Pg==
To: linux-kernel@vger.kernel.org
From: Raymond Hackley <raymondhackley@protonmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Michael Walle <michael@walle.cc>, =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Jeremy Kerr <jk@codeconstruct.com.au>, Raymond Hackley <raymondhackley@protonmail.com>, netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v2 0/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Message-ID: <20230609154033.3511-1-raymondhackley@protonmail.com>
Feedback-ID: 49437091:user:proton
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

v2: Use dev_err_probe() and drop unnecessary nxp_nci_i2c_poweroff()

PN547/553, QN310/330 chips on some devices require a pad supply voltage
(PVDD). Otherwise, the NFC won't power up.

Implement support for pad supply voltage pvdd-supply that is enabled by
the nxp-nci driver so that the regulator gets enabled when needed.


