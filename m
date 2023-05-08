Return-Path: <netdev+bounces-926-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 815A06FB65E
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 20:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 49547280C74
	for <lists+netdev@lfdr.de>; Mon,  8 May 2023 18:43:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 676EA10977;
	Mon,  8 May 2023 18:43:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BC81524E
	for <netdev@vger.kernel.org>; Mon,  8 May 2023 18:43:38 +0000 (UTC)
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFE859E8;
	Mon,  8 May 2023 11:43:34 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id d75a77b69052e-3ef35d44612so53994731cf.1;
        Mon, 08 May 2023 11:43:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683571413; x=1686163413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=2UzQiNfm6F693fNlkyZs8eRSlihgAocz7zYCdB/eyQg=;
        b=OBRskowUlanHVwjbRBW3VChc6Q8gWvBc2Y34J3nXb3Kx03wXi0ylavATFS07jeUtbk
         XDr85B+eRqs8dAptutJ7JzTa3veAfrGgN6G/0vlmBX02nLPCn8HeMToiZh+A6u1NW8Cf
         ttA3hyl7vgZeXUux+86EVXohf4WK2cyyxJotaPyMkQk7ESdB/cqx0TZLSX6Vx2BewHzP
         BPsZwtOQZRmvf6c0dtmEgszds3QXZcb5QL1pPEdT7He2gG0y1KeFclkPddjETvLQLzyU
         0dpDWQFohFMJffdN+Kmi+TGMsP8IVuhscVxc4hPpLo69YbgcGouO8Z34b8isFGYYltif
         GDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683571413; x=1686163413;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2UzQiNfm6F693fNlkyZs8eRSlihgAocz7zYCdB/eyQg=;
        b=k6KT42GPuIph77HUD4tIVIZWcojovB3ReF5hC6qtb6sdCkBYJZIC3MpZqa95F4XA+d
         HDzmIOy51au4+TtD02h/Ed2rZZi11CL2XzAk/0mlZpNs0Bntf88Au7l98XAztKz8tkD0
         poo3ZEs+F0vnccgtYO62vJ6hwXIsqsNgZjF5kEc8jVR/pBR7mrOBWPQoFjrixujM7+br
         UkKmCi95GfJktkq93C92qCSGJWKyl3V+Xghei9a+BjQt7h1LIKQ9qg2HCBc0noqTJ4Bs
         DqvPxjwZFEfcY2xYUBwzd6WMkCnP1E89Tk98mO67A5ASgPhhBkmMhm+4EdtjzmvqjuYS
         cjeQ==
X-Gm-Message-State: AC+VfDypTTCd/HnYdujzXxNHJLSMnLa1FkkUjy1LFlBMZFRuH4iS4hFy
	MPMC6rCYrOp0PLWr4oyg8GyUgMIjqac=
X-Google-Smtp-Source: ACHHUZ7Qsu3F0OpI4nsrU34NhHs1ifu6OoO1xuDeW7+1kbSpLXxVWbQL2iziPHA/PotC+tfskOrHAw==
X-Received: by 2002:ac8:5786:0:b0:3ec:489c:defb with SMTP id v6-20020ac85786000000b003ec489cdefbmr16366217qta.9.1683571413285;
        Mon, 08 May 2023 11:43:33 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v26-20020ac83d9a000000b003d3a34d2eb2sm3193988qtf.41.2023.05.08.11.43.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 11:43:32 -0700 (PDT)
From: Florian Fainelli <f.fainelli@gmail.com>
To: netdev@vger.kernel.org
Cc: Florian Fainelli <f.fainelli@gmail.com>,
	Doug Berger <opendmb@gmail.com>,
	Broadcom internal kernel review list <bcm-kernel-feedback-list@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Peter Geis <pgwipeout@gmail.com>,
	Frank <Frank.Sae@motor-comm.com>,
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 0/3] Support for Wake-on-LAN for Broadcom PHYs
Date: Mon,  8 May 2023 11:43:06 -0700
Message-Id: <20230508184309.1628108-1-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
	RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

This patch series adds support for Wake-on-LAN to the Broadcom PHY
driver. Specifically the BCM54210E/B50212E are capable of supporting
Wake-on-LAN using an external pin typically wired up to a system's GPIO.

These PHY operate a programmable Ethernet MAC destination address
comparator which will fire up an interrupt whenever a match is received.
Because of that, it was necessary to introduce patch #1 which allows the
PHY driver's ->suspend() routine to be called unconditionally. This is
necessary in our case because we need a hook point into the device
suspend/resume flow to enable the wake-up interrupt as late as possible.

Patch #2 adds support for the Broadcom PHY library and driver for
Wake-on-LAN proper with the WAKE_UCAST, WAKE_MCAST, WAKE_BCAST,
WAKE_MAGIC and WAKE_MAGICSECURE. Note that WAKE_FILTER is supportable,
however this will require further discussions and be submitted as a RFC
series later on.

Patch #3 updates the GENET driver to defer to the PHY for Wake-on-LAN if
the PHY supports it, thus allowing the MAC to be powered down to
conserve power.

Florian Fainelli (3):
  net: phy: Let drivers check Wake-on-LAN status
  net: phy: broadcom: Add support for Wake-on-LAN
  net: bcmgenet: Add support for PHY-based Wake-on-LAN

 .../ethernet/broadcom/genet/bcmgenet_wol.c    |  14 ++
 drivers/net/phy/aquantia_main.c               |   3 +
 drivers/net/phy/at803x.c                      |  10 +
 drivers/net/phy/bcm-phy-lib.c                 | 212 ++++++++++++++++++
 drivers/net/phy/bcm-phy-lib.h                 |   5 +
 drivers/net/phy/bcm7xxx.c                     |   3 +
 drivers/net/phy/broadcom.c                    | 128 ++++++++++-
 drivers/net/phy/dp83822.c                     |   2 +-
 drivers/net/phy/dp83867.c                     |   3 +
 drivers/net/phy/dp83tc811.c                   |   2 +-
 drivers/net/phy/marvell-88x2222.c             |   3 +
 drivers/net/phy/marvell.c                     |   3 +
 drivers/net/phy/marvell10g.c                  |   3 +
 drivers/net/phy/micrel.c                      |   3 +
 drivers/net/phy/microchip.c                   |   4 +-
 drivers/net/phy/motorcomm.c                   |   2 +-
 drivers/net/phy/phy-c45.c                     |   3 +
 drivers/net/phy/phy_device.c                  |   7 +-
 drivers/net/phy/realtek.c                     |   3 +
 include/linux/brcmphy.h                       |  55 +++++
 include/linux/phy.h                           |   3 +
 21 files changed, 460 insertions(+), 11 deletions(-)

-- 
2.34.1


