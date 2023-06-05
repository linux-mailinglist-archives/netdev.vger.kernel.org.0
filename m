Return-Path: <netdev+bounces-8102-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F33AF722B65
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:40:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 740B21C2095A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:40:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11B6A209B7;
	Mon,  5 Jun 2023 15:40:18 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06DBE1F93A
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:40:17 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 968F9130;
	Mon,  5 Jun 2023 08:40:13 -0700 (PDT)
Received: from arisu.mtl.collabora.ca (mtl.collabora.ca [66.171.169.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id AA0EE660036A;
	Mon,  5 Jun 2023 16:40:10 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685979612;
	bh=GZl6ZhnAnG6jIOD1vjYTq8i9dEDF+bhtGx3LOe6W+Ig=;
	h=From:To:Cc:Subject:Date:From;
	b=OP6jCf1A4MiKSEjBCv4IlmWs4/fnvnKlEkWD25RfUnm/z9zLKiX6tNXclcoXhI3iE
	 tDLBCCd5Q3EtlLWz40vBpznWg4QDsYmqblZxAbNnt7pUI/Ayd1q7gEYo+e96X1OMyH
	 YsnGE3TRRxevmjIwvXcP764f/faXLUov1z4EmSitCGW6GVOlgFcsufB2U8sxCGcZF5
	 dVfOYix7Va4lCkbobfXeg9CDg9zVIW81wS/cGJ3J7B1XRe+k4088Hke7PZczpJdQeW
	 oElIltkn0u5ZxVN0p3QzjVfhP9kKwMt9w7SsPxN1VAnNGJG0vVy/uezDgwvTsBkqKT
	 KEDWRdKeu36Gg==
From: Detlev Casanova <detlev.casanova@collabora.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Rob Herring <robh+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Florian Fainelli <f.fainelli@gmail.com>,
	netdev@vger.kernel.org,
	devicetree@vger.kernel.org
Subject: [PATCH v4 0/3] net: phy: realtek: Support external PHY clock
Date: Mon,  5 Jun 2023 11:40:07 -0400
Message-Id: <20230605154010.49611-1-detlev.casanova@collabora.com>
X-Mailer: git-send-email 2.39.3
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Some PHYs can use an external clock that must be enabled before
communicating with them.

Changes since v3:
 * Do not call genphy_suspend if WoL is enabled.
Changes since v2:
 * Reword documentation commit message
Changes since v1:
 * Remove the clock name as it is not guaranteed to be identical across
   different PHYs
 * Disable/Enable the clock when suspending/resuming



