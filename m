Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89F33284D31
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 16:06:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727037AbgJFOGa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 10:06:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:33130 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbgJFODz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 10:03:55 -0400
Received: from mail.kernel.org (ip5f5ad5bd.dynamic.kabel-deutschland.de [95.90.213.189])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64ABF2176B;
        Tue,  6 Oct 2020 14:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601993034;
        bh=uyw81/CIQor1pw1d+F+O72/KMytUqBcsX5jPSTgoByE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07u6uLr4K2/jmMzuPigBhxJvEZBMCPMFCJjkl08Xe9JEkoi1TOE/YuLvDsFgqMhnE
         i2jDBa5Ov195yQcV72Sd4gyEbj3+20S3TVoMjQnxJo60szGTJwjYePAInrRI5DadeX
         rlL96RCb+a3byDHxtyujBnqNFuRhhTbYxpd9vpQo=
Received: from mchehab by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kPnZI-0019Fd-79; Tue, 06 Oct 2020 16:03:52 +0200
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
Subject: [PATCH v5 25/52] docs: net: ieee802154.rst: fix C expressions
Date:   Tue,  6 Oct 2020 16:03:22 +0200
Message-Id: <6ba1d137516e4a144a4fd398934d62b94d31446d.1601992016.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1601992016.git.mchehab+huawei@kernel.org>
References: <cover.1601992016.git.mchehab+huawei@kernel.org>
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

Acked-by: David S. Miller <davem@davemloft.net>
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

