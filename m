Return-Path: <netdev+bounces-8094-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id AAC87722AC5
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 17:20:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 224F21C20C6A
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 15:20:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D961F957;
	Mon,  5 Jun 2023 15:20:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660021F948
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 15:20:14 +0000 (UTC)
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07141D2;
	Mon,  5 Jun 2023 08:20:12 -0700 (PDT)
Received: from arisu.mtl.collabora.ca (mtl.collabora.ca [66.171.169.34])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: detlev)
	by madras.collabora.co.uk (Postfix) with ESMTPSA id BCAD26600368;
	Mon,  5 Jun 2023 16:20:09 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1685978411;
	bh=Ye2OPJTrKVJ6tXJ7CFNhgEilyt6Zi31GJyG9LSEVmZY=;
	h=From:To:Cc:Subject:Date:From;
	b=Pe0WnA1vJCDPhX6P6HNWN4SRl5A7/ZytShvV/StDkqw46eGnVTXBp+SIpBNe2SDu/
	 7wyzcm38TOsUrz/Zy3tlZnq/5CkYTy5dDVvWIacHFRPzW9htiEUUZr9f+UD7+uSZ/9
	 4wd9KiaEHpFulI2tI6CbSLngCPy1nnEPFqRVq0awUne79rg+7Go3K8Q7jbeoMAv7ZH
	 kn/7GAmwZYAfUdHTo5dMEH+OsT5v0yAV2stDLDoO7U4FV1IZ7GVKmrC3QtLiWecXru
	 Ny1GWeQURhkjsxLP9aaRWzRgFXiAu6NYErAjEQ5GS2xL8dpDeagmGg0asDw30T/4O3
	 HGH69cvay9mQw==
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
Subject: net: phy: realtek: Support external PHY clock
Date: Mon,  5 Jun 2023 11:19:50 -0400
Message-Id: <20230605151953.48539-1-detlev.casanova@collabora.com>
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

Changes since v2:
 * Reword documentation commit message

Changes since v1:
 * Remove the clock name as it is not guaranteed to be identical across
   different PHYs
 * Disable/Enable the clock when suspending/resuming



