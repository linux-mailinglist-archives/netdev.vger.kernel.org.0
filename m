Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE7C2EC081
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 16:39:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbhAFPi6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 10:38:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbhAFPi5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Jan 2021 10:38:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB7F12310D;
        Wed,  6 Jan 2021 15:38:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609947497;
        bh=TGNr7gH+AaWbcdsJKDVyoI/B5RwNkVFXV8lRxX0ZLpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TuHHBxS+NGu1TQes6Gt8O6+BCxub/TS9QrvqLkLPXpoh0VY+k2CWOMHLbRYIdoupe
         p6cDTs29o1bxf10n1uOBoVz1rMO6RitTZY8uT24TRORbgaKfj8afZiwEBgFUzCh+TV
         IJsgmTu6uH4POKNnFN94qhkDgqEosNgeaWP9jjhALcNz6/DEeTFUVZe1Lq4s+Q64QK
         8vjpkX5+HEzK3EYHAv2QpS8p3r54h40TQfVB6uWXGbL0QtjFAFuGiHl2G/CrPD8X3c
         ZOMKfSMnfnRq0Rg4/6PV+cNuoYHdEj+LvzSMxffhnaARhkLbI2mKBtzFGrg+wXD9pQ
         iMeYUjBCi8pmQ==
Received: by pali.im (Postfix)
        id D0ED544E; Wed,  6 Jan 2021 16:38:14 +0100 (CET)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Thomas Schreiber <tschreibe@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/3] net: sfp: add support for GPON RTL8672/RTL9601C and Ubiquiti U-Fiber
Date:   Wed,  6 Jan 2021 16:37:46 +0100
Message-Id: <20210106153749.6748-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201230154755.14746-1-pali@kernel.org>
References: <20201230154755.14746-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is second patch series which adds workaround for broken GPON SFP
modules based on Realtek RTL8672/RTL9601C chips with broken EEPROM
emulator.

PATCH 2/4 was dropped and replaced by specific UBNT quirk in modified
PATCH v2 3/3.

hwmon interface was for these SFP modules completely disabled as EEPROM
is totally broken and does not support reading 16bit values automically.

Pali Rohár (2):
  net: sfp: add workaround for Realtek RTL8672 and RTL9601C chips
  net: sfp: add mode quirk for GPON module Ubiquiti U-Fiber Instant

Russell King (1):
  net: sfp: assume that LOS is not implemented if both LOS normal and
    inverted is set

 drivers/net/phy/sfp-bus.c |  15 ++++
 drivers/net/phy/sfp.c     | 145 +++++++++++++++++++++++++-------------
 2 files changed, 110 insertions(+), 50 deletions(-)

-- 
2.20.1

