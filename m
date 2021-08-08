Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4DD3E3C73
	for <lists+netdev@lfdr.de>; Sun,  8 Aug 2021 21:08:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbhHHTI4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 Aug 2021 15:08:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbhHHTI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 Aug 2021 15:08:56 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018D7C061760
        for <netdev@vger.kernel.org>; Sun,  8 Aug 2021 12:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=khXPKSkNoUsQSwBadPWBGTyq4Rkr53mWJ4WPs9p2pZk=; b=bdHiRQTihCIu6IRMZGO1eRbM0Q
        iuzDtsYNhtDAXQk9hTUXCxXLQ5M6i7Dna1ZZH5fzPLvW/nBQci8ib7Eu4GtY5i9kAMxmZPPIYCV1T
        j6G8EbRHD+H7Sxj9GV2n98qtmYbCIa7J6e9IuuriN29bOJBtnU0v1ktgyh4dqJsZVC820OTfQLLgS
        uUSHikHaSFps61ISiyp0y7oZUGq8UjUE1xxQdLQA5rTDFG0FdPo/obaYvoRctosx+a64eUFIXqJsY
        YI0O0FPXWW4L0wvcpjwB4nWpH4IT2CQkpkIHHxmDFua1sy3ex2wlThGm2YmcbT2YBDPzFhBA9a4up
        u71Szesw==;
Received: from [2601:1c0:6280:3f0:e65e:37ff:febd:ee53] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mCo9z-00GHOT-MH; Sun, 08 Aug 2021 19:08:35 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Pravin B Shelar <pshelar@ovn.org>, dev@openvswitch.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH] net: openvswitch: fix kernel-doc warnings in flow.c
Date:   Sun,  8 Aug 2021 12:08:34 -0700
Message-Id: <20210808190834.23362-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Repair kernel-doc notation in a few places to make it conform to
the expected format.

Fixes the following kernel-doc warnings:

flow.c:296: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
 * Parse vlan tag from vlan header.
flow.c:296: warning: missing initial short description on line:
 * Parse vlan tag from vlan header.
flow.c:537: warning: No description found for return value of 'key_extract_l3l4'
flow.c:769: warning: No description found for return value of 'key_extract'

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Pravin B Shelar <pshelar@ovn.org>
Cc: dev@openvswitch.org
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
---
 net/openvswitch/flow.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- linux-next-20210806.orig/net/openvswitch/flow.c
+++ linux-next-20210806/net/openvswitch/flow.c
@@ -293,14 +293,14 @@ static bool icmp6hdr_ok(struct sk_buff *
 }
 
 /**
- * Parse vlan tag from vlan header.
+ * parse_vlan_tag - Parse vlan tag from vlan header.
  * @skb: skb containing frame to parse
  * @key_vh: pointer to parsed vlan tag
  * @untag_vlan: should the vlan header be removed from the frame
  *
- * Returns ERROR on memory error.
- * Returns 0 if it encounters a non-vlan or incomplete packet.
- * Returns 1 after successfully parsing vlan tag.
+ * Return: ERROR on memory error.
+ * %0 if it encounters a non-vlan or incomplete packet.
+ * %1 after successfully parsing vlan tag.
  */
 static int parse_vlan_tag(struct sk_buff *skb, struct vlan_head *key_vh,
 			  bool untag_vlan)
@@ -532,6 +532,7 @@ static int parse_nsh(struct sk_buff *skb
  *       L3 header
  * @key: output flow key
  *
+ * Return: %0 if successful, otherwise a negative errno value.
  */
 static int key_extract_l3l4(struct sk_buff *skb, struct sw_flow_key *key)
 {
@@ -748,8 +749,6 @@ static int key_extract_l3l4(struct sk_bu
  *
  * The caller must ensure that skb->len >= ETH_HLEN.
  *
- * Returns 0 if successful, otherwise a negative errno value.
- *
  * Initializes @skb header fields as follows:
  *
  *    - skb->mac_header: the L2 header.
@@ -764,6 +763,8 @@ static int key_extract_l3l4(struct sk_bu
  *
  *    - skb->protocol: the type of the data starting at skb->network_header.
  *      Equals to key->eth.type.
+ *
+ * Return: %0 if successful, otherwise a negative errno value.
  */
 static int key_extract(struct sk_buff *skb, struct sw_flow_key *key)
 {
