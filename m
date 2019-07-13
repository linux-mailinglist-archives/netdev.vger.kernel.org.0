Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13ADC67A9D
	for <lists+netdev@lfdr.de>; Sat, 13 Jul 2019 16:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbfGMOfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 10:35:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:40575 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727504AbfGMOfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 10:35:33 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 6B7FB2129D;
        Sat, 13 Jul 2019 10:35:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 13 Jul 2019 10:35:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bernat.ch; h=
        from:to:cc:subject:date:message-id:mime-version
        :content-transfer-encoding; s=fm3; bh=ZVFEohZV4kTIyFKmxQGCn3SeSS
        OgcfzSSdaIez6G2K0=; b=JC4q0Kt1Ub9MRP5W9H5F26/dAylvGe/EVk5yXKwVvv
        Ia/GiECAcXzY3PPK+op8bIRgGCItFE6N+TCm4aHEqAcfxJvox0NIlQss6UgxHQNF
        6qCDULx1uE8DmNHdRKBvlL11bNtDp8OvzBEqaHTDRWiy4NV9HU56p3zdJf9yGyDW
        fAiRBmLQd+3UkfRQdO7VWTwRU2qKvPeBhhIay/lFRLT5SRuXRA1dBxDY3hkww89c
        wHEKa6vH3iFn36L6+90+Vid3N0KUgLj7QIQX4j9Hzp4/1OGdj2wwM9YCtJKdOIif
        OmhUZthNFdTCkLnNntKOSbExmNDDhP5Zy4ineHixdSUg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :message-id:mime-version:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ZVFEohZV4kTIyFKmx
        QGCn3SeSSOgcfzSSdaIez6G2K0=; b=r3W4NJ8xGPGnIIoE/g6/7rqu42qrBS7IG
        iIC8WEqWdEK35bxqEiW+soGd3SPHHLRbkqG+s0x00Cu5y5kIuOal3dlP8yxiXVIP
        pcZH5m7uUrLQ8aemqYMTVLEtG/qkzcxN4SUdnIwf3qmVkIiYcLNiCbBcuZWYKbKl
        CwiBevzy04H8f+dBlFP8UULa7XEkUZwK5vpPiNkbeLUkoimfU9BgDDFKWGvp16We
        /XeBrOfnW1qdnk94r29vfWO44uo6EEp3Wr9fHf2MzuQHXTpTWnONy9rq7YEMgYSe
        jFQcCt0zlBHqOoztbqZKJ2z6Wze32LgpdIVTd6SjnzTsRJKxtWBnw==
X-ME-Sender: <xms:MuwpXX-Xj4rwWQZr9VqBBRahuKHxDGZzfopNjZEYaCZmSKYA_XHJ6g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrhedvgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefhvffufffkofgggfestdekredtredttdenucfhrhhomhepgghinhgtvghnthcu
    uegvrhhnrghtuceovhhinhgtvghnthessggvrhhnrghtrdgthheqnecukfhppeekhedrud
    dukedrfeekrdejfeenucfrrghrrghmpehmrghilhhfrhhomhepsggvrhhnrghtsehluhhf
    fhihrdgtgienucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:MuwpXUTBRBzx4dRCKid43FF5bVqHKPW3ohMQXn-SIm6qGlkMR77HrQ>
    <xmx:MuwpXd6QO0oYiey-YWhVKOkCKpVbcm7F6dgg82iYqpSRGNWysNvYeA>
    <xmx:MuwpXdpudlhDwXJ_Phj7uRHVAUfz-QF8H9rTMQcDtTZa8Xt8he5Jkw>
    <xmx:M-wpXZF5fyx1T7ldUR1Tj9uK76mRQPFsKu29NMgvMQxvYvftpx8aNg>
Received: from zoro.luffy.cx (unknown [85.118.38.73])
        by mail.messagingengine.com (Postfix) with ESMTPA id 623A5380075;
        Sat, 13 Jul 2019 10:35:30 -0400 (EDT)
Received: by zoro.luffy.cx (Postfix, from userid 1000)
        id 42DBAD8C; Sat, 13 Jul 2019 16:35:29 +0200 (CEST)
From:   Vincent Bernat <vincent@bernat.ch>
To:     David Miller <davem@davemloft.net>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, netdev@vger.kernel.org
Cc:     Vincent Bernat <vincent@bernat.ch>
Subject: [net-next] bonding: add documentation for peer_notif_delay
Date:   Sat, 13 Jul 2019 16:35:27 +0200
Message-Id: <20190713143527.27562-1-vincent@bernat.ch>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ability to tweak the interval between peer notifications has been
added in 07a4ddec3ce9 ("bonding: add an option to specify a delay
between peer notifications") but the documentation was not updated.

Signed-off-by: Vincent Bernat <vincent@bernat.ch>
---
 Documentation/networking/bonding.txt | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/bonding.txt b/Documentation/networking/bonding.txt
index d3e5dd26db12..e3abfbd32f71 100644
--- a/Documentation/networking/bonding.txt
+++ b/Documentation/networking/bonding.txt
@@ -706,9 +706,9 @@ num_unsol_na
 	unsolicited IPv6 Neighbor Advertisements) to be issued after a
 	failover event.  As soon as the link is up on the new slave
 	(possibly immediately) a peer notification is sent on the
-	bonding device and each VLAN sub-device.  This is repeated at
-	each link monitor interval (arp_interval or miimon, whichever
-	is active) if the number is greater than 1.
+	bonding device and each VLAN sub-device. This is repeated at
+	the rate specified by peer_notif_delay if the number is
+	greater than 1.
 
 	The valid range is 0 - 255; the default value is 1.  These options
 	affect only the active-backup mode.  These options were added for
@@ -727,6 +727,16 @@ packets_per_slave
 	The valid range is 0 - 65535; the default value is 1. This option
 	has effect only in balance-rr mode.
 
+peer_notif_delay
+
+        Specify the delay, in milliseconds, between each peer
+        notification (gratuitous ARP and unsolicited IPv6 Neighbor
+        Advertisement) when they are issued after a failover event.
+        This delay should be a multiple of the link monitor interval
+        (arp_interval or miimon, whichever is active). The default
+        value is 0 which means to match the value of the link monitor
+        interval.
+
 primary
 
 	A string (eth0, eth2, etc) specifying which slave is the
-- 
2.22.0

