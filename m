Return-Path: <netdev+bounces-9657-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 434C872A224
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 20:27:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 931991C21113
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:27:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89B5421078;
	Fri,  9 Jun 2023 18:27:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7C01993B
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 18:27:18 +0000 (UTC)
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B3C35A3;
	Fri,  9 Jun 2023 11:27:17 -0700 (PDT)
Date: Fri, 09 Jun 2023 18:27:02 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1686335232; x=1686594432;
	bh=ZWzcN/Tm7VxGdb18LHyy/4I9RAaaMI8KoDWSNbJZYMw=;
	h=Date:To:From:Cc:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=EjjRfdrTEJRXwRqzh0tudvMQ2Tm7muCk6nBtud2Il6HJPAUSaYsPMzLyqfXQyioRr
	 sZ7TUTl6fw/WvfZOg6um4ZLvf8LLonlThUbAU2Fv3dvZbzH6VX1/N1yDxgsBir8FIK
	 qFsfDFcmZy9+P0/DSNiKWprGyMuVfj6eudrTHZH1eejzZ8lLPaXB9xEdKpvbes6Z5G
	 C7UGRwUwHKPMBJ1IbGLX9kkjfnW8f8OdtZR72TWA5Ug5i/cA+Rj4Yo3TOR5bzIad6x
	 B56Xicuzj+VwMbs/ozILsb1jNo8LN75H9F/PZobH1gwbG1FIzklEbIr1HC2Xy9w5cz
	 Q9bcVZF52/NjA==
To: linux-kernel@vger.kernel.org
From: Raymond Hackley <raymondhackley@protonmail.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>, Michael Walle <michael@walle.cc>, =?utf-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>, Jeremy Kerr <jk@codeconstruct.com.au>, Raymond Hackley <raymondhackley@protonmail.com>, netdev@vger.kernel.org, devicetree@vger.kernel.org
Subject: [PATCH v3 0/2] NFC: nxp-nci: Add pad supply voltage pvdd-supply
Message-ID: <20230609182639.85034-1-raymondhackley@protonmail.com>
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

v3: Fix weird wrapping and drop another unnecessary nxp_nci_i2c_poweroff()
v2: Use dev_err_probe() and drop unnecessary nxp_nci_i2c_poweroff()

PN547/553, QN310/330 chips on some devices require a pad supply voltage
(PVDD). Otherwise, the NFC won't power up.

Implement support for pad supply voltage pvdd-supply that is enabled by
the nxp-nci driver so that the regulator gets enabled when needed.


