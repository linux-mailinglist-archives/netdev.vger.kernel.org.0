Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D66627E974
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 15:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730302AbgI3NZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 09:25:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730220AbgI3NZW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 09:25:22 -0400
Received: from mail.kernel.org (unknown [95.90.213.196])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B53AD2311C;
        Wed, 30 Sep 2020 13:25:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601472320;
        bh=ZDLNrLw5usA2pRQXUV5z1zXZD8nGC4DJ0soSPMQzB6Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHB2rbHzhCh8LIjJVk4J1stOylM/JoWtfGPMzAG75xJJvT1yw98YGHl5A+nl0POPI
         MMBTN8tMSKHQe6p9TmrNFPt8H1Wy4oFQFV97YgXkIZxtWlLwSuSDrPZDy4Ci4wxASD
         ju7flT1IjxgeipU4WVyIz/V+rcME2pozmjRcbttA=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kNc6g-001XJy-QL; Wed, 30 Sep 2020 15:25:18 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexander Aring <alex.aring@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-kernel@vger.kernel.org, linux-wpan@vger.kernel.org,
        netdev@vger.kernel.org
Subject: [PATCH v4 25/52] docs: net: ieee802154.rst: fix C expressions
Date:   Wed, 30 Sep 2020 15:24:48 +0200
Message-Id: <e1ef9c58d2aa10e3487dab6798706f48029d7dee.1601467849.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601467849.git.mchehab+huawei@kernel.org>
References: <cover.1601467849.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are some warnings produced with Sphinx 3.x:

	Documentation/networking/ieee802154.rst:29: WARNING: Error in declarator or parameters
	Invalid C declaration: Expecting "(" in parameters. [error at 7]
	  int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
	  -------^
	Documentation/networking/ieee802154.rst:134: WARNING: Invalid C declaration: Expected end of definition. [error at 81]
	  void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi):
	  ---------------------------------------------------------------------------------^
	Documentation/networking/ieee802154.rst:139: WARNING: Invalid C declaration: Expected end of definition. [error at 95]
	  void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb, bool ifs_handling):
	  -----------------------------------------------------------------------------------------------^
	Documentation/networking/ieee802154.rst:158: WARNING: Invalid C declaration: Expected end of definition. [error at 35]
	  int start(struct ieee802154_hw *hw):
	  -----------------------------------^
	Documentation/networking/ieee802154.rst:162: WARNING: Invalid C declaration: Expected end of definition. [error at 35]
	  void stop(struct ieee802154_hw *hw):
	  -----------------------------------^
	Documentation/networking/ieee802154.rst:166: WARNING: Invalid C declaration: Expected end of definition. [error at 61]
	  int xmit_async(struct ieee802154_hw *hw, struct sk_buff *skb):
	  -------------------------------------------------------------^
	Documentation/networking/ieee802154.rst:171: WARNING: Invalid C declaration: Expected end of definition. [error at 43]
	  int ed(struct ieee802154_hw *hw, u8 *level):
	  -------------------------------------------^
	Documentation/networking/ieee802154.rst:176: WARNING: Invalid C declaration: Expected end of definition. [error at 62]
	  int set_channel(struct ieee802154_hw *hw, u8 page, u8 channel):
	  --------------------------------------------------------------^

Caused by some bad c:function: prototypes. Fix them.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 Documentation/networking/ieee802154.rst | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/ieee802154.rst b/Documentation/networking/ieee802154.rst
index 6f4bf8447a21..f27856d77c8b 100644
--- a/Documentation/networking/ieee802154.rst
+++ b/Documentation/networking/ieee802154.rst
@@ -26,7 +26,9 @@ The stack is composed of three main parts:
 Socket API
 ==========
 
-.. c:function:: int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
+::
+
+    int sd = socket(PF_IEEE802154, SOCK_DGRAM, 0);
 
 The address family, socket addresses etc. are defined in the
 include/net/af_ieee802154.h header or in the special header
@@ -131,12 +133,12 @@ Register PHY in the system.
 
 Freeing registered PHY.
 
-.. c:function:: void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi):
+.. c:function:: void ieee802154_rx_irqsafe(struct ieee802154_hw *hw, struct sk_buff *skb, u8 lqi)
 
 Telling 802.15.4 module there is a new received frame in the skb with
 the RF Link Quality Indicator (LQI) from the hardware device.
 
-.. c:function:: void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb, bool ifs_handling):
+.. c:function:: void ieee802154_xmit_complete(struct ieee802154_hw *hw, struct sk_buff *skb, bool ifs_handling)
 
 Telling 802.15.4 module the frame in the skb is or going to be
 transmitted through the hardware device
@@ -155,25 +157,25 @@ operations structure at least::
         ...
    };
 
-.. c:function:: int start(struct ieee802154_hw *hw):
+.. c:function:: int start(struct ieee802154_hw *hw)
 
 Handler that 802.15.4 module calls for the hardware device initialization.
 
-.. c:function:: void stop(struct ieee802154_hw *hw):
+.. c:function:: void stop(struct ieee802154_hw *hw)
 
 Handler that 802.15.4 module calls for the hardware device cleanup.
 
-.. c:function:: int xmit_async(struct ieee802154_hw *hw, struct sk_buff *skb):
+.. c:function:: int xmit_async(struct ieee802154_hw *hw, struct sk_buff *skb)
 
 Handler that 802.15.4 module calls for each frame in the skb going to be
 transmitted through the hardware device.
 
-.. c:function:: int ed(struct ieee802154_hw *hw, u8 *level):
+.. c:function:: int ed(struct ieee802154_hw *hw, u8 *level)
 
 Handler that 802.15.4 module calls for Energy Detection from the hardware
 device.
 
-.. c:function:: int set_channel(struct ieee802154_hw *hw, u8 page, u8 channel):
+.. c:function:: int set_channel(struct ieee802154_hw *hw, u8 page, u8 channel)
 
 Set radio for listening on specific channel of the hardware device.
 
-- 
2.26.2

