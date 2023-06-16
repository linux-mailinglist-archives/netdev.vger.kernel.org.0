Return-Path: <netdev+bounces-11515-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F14C9733663
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 18:46:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EF68A1C20EC5
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 16:46:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B28D119514;
	Fri, 16 Jun 2023 16:46:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A59B413AC9
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 16:46:01 +0000 (UTC)
Received: from esa2.hc3370-68.iphmx.com (esa2.hc3370-68.iphmx.com [216.71.145.153])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B8C02D6A
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 09:45:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1686933958;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=pou4VuS9zWrPPMiI4fKiGBol/cfeNfFn+dgNIIVDK+E=;
  b=RzSxft3lQQKx+VYYA3rBUHQOHOlLY5OAq93kTfSG/7C0vi3X7HhDafrK
   G7xSZQBVneBSYxjNp2BV4EvICzBbyOLpnlKNme4at6Ia6OiwBt52RycTT
   yh3V2cEq/eSeL1cbB/WjaFI8JaJdJzrNADokJV/vUHT8kaiTy4q+V+3f7
   g=;
Authentication-Results: esa2.hc3370-68.iphmx.com; dkim=none (message not signed) header.i=none
X-SBRS: 4.0
X-MesageID: 112978946
X-Ironport-Server: esa2.hc3370-68.iphmx.com
X-Remote-IP: 162.221.156.123
X-Policy: $RELAYED
IronPort-Data: A9a23:bd55SKJC671YplkPFE+RXJUlxSXFcZb7ZxGr2PjKsXjdYENShmMGy
 zdNDzrUb/+JMTP9fNp2Po7l9BwDsZ/Qy4BrTgJlqX01Q3x08seUXt7xwmUcnc+xBpaaEB84t
 ZV2hv3odp1coqr0/0/1WlTZhSAgk/rOHvykU7Ss1hlZHWdMUD0mhQ9oh9k3i4tphcnRKw6Ws
 Jb5rta31GWNglaYCUpKrfrbwP9TlK6q4mhA4AVgPasjUGL2zBH5MrpOfcldEFOgKmVkNrbSb
 /rOyri/4lTY838FYj9yuu+mGqGiaue60Tmm0hK6aYD76vRxjnVaPpIAHOgdcS9qZwChxLid/
 jnvWauYEm/FNoWU8AgUvoIx/ytWZcWq85efSZSzXFD6I+QrvBIAzt03ZHzaM7H09c5QQlwSq
 d4jBQpOQRyTouGp346FDbZz05FLwMnDZOvzu1llxDDdS/0nXYrCU+PB4towMDUY354UW6yEP
 oxANGQpNU6bC/FMEg5/5JYWhuCznT/7ejJVsk2coa4f6GnP1g1hlrPqNbI5f/TTHJ8EwRbJ+
 jyuE2LRB0swPc6ikjW86nuqtPDPsjr7ZtocPejtnhJtqALKnTFCYPEMbnO9rOW1h1CWRd1SM
 QoX9zAooKx081akJvH0XRyk5n2EtwYVQdZdO+cg7wiBwa3RpQ2eAwAsVSRAaNU8r88/AzYjz
 VaXlsvgGTpmmLePTnuR/bCR6zi1PEA9NmgHYyYYTU0G5MX+uqk5lBXGQt1kFei+ididMT353
 T2PhCQ3mbgWickFy+O98Eyvqz+gu53AXAMpzgrQWW2h40VyY4vNT4+141Hz7vtaKoudCF6bs
 xAsg8GU4eYPJYuAmCyEXKMGG7TB2hqeGGSC2xg1RcBnrmnzvSf5Jui8/Q2SOm9OcftYJR3ST
 XWQlg9BwZxMI0eUKvBoNtfZ59sR8UTwKTj0fqmKPoQfOcAoLlPvEDJGPhDJgT20+KQ4ueRmY
 MrAL57xZZoPIf4/pAdaUdvxxlPCKsoW4WrIDa72wB28uVZ1TC7EEOxVWLdigw1Q0U9lnOk22
 4wFXydy408DONASmwGOmWLpEXgELGIgGbf9oNFNe+iIL2JOQT9xVa+Mm+97JNI0wsy5c9skG
 FnnAie0L3Kl3xX6xfiiMCg/ONsDo74hxZ7EAcDcFQnxgCVyCWpexKwea4E2bdEaGB9LlJZJo
 w0+U5zYWJxnE22XkwnxmLGh9OSOgjz331PRV8dkCRBjF6Ndq/vhoI65Llqzr3hUVUJad6IW+
 tWd6+8SerJbLywKMSocQKvHI4+Z1ZTFpN9PYg==
IronPort-HdrOrdr: A9a23:/7DNN6oRXLAKqKbeMEz+Et4aV5oReYIsimQD101hICG9JPbo8P
 xG+85rtiMc6QxwZJhOo7u90cW7K080lqQV3WByB9iftVLdyQ+VxehZhOPfKlvbdhEWndQy6U
 4PScRD4HKbNykdsS5XijPIcerJYbO8gcWVuds=
X-Talos-CUID: 9a23:ZZer/G81lCvSOayGtPCVv2lXJ5x5UEbw9jT/L1+dCnl2dIPSFkDFrQ==
X-Talos-MUID: 9a23:NnpSEwnLwT6jGFGRqvBidnpnbu1h8Zn1B3kVmJM0pMmrLCxOYzm02WE=
X-IronPort-AV: E=Sophos;i="6.00,248,1681185600"; 
   d="scan'208";a="112978946"
From: Ross Lagerwall <ross.lagerwall@citrix.com>
To: <netdev@vger.kernel.org>
CC: Ajit Khaparde <ajit.khaparde@broadcom.com>, Sriharsha Basavapatna
	<sriharsha.basavapatna@broadcom.com>, Somnath Kotur
	<somnath.kotur@broadcom.com>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Ross Lagerwall <ross.lagerwall@citrix.com>
Subject: [PATCH] be2net: Extend xmit workaround to BE3 chip
Date: Fri, 16 Jun 2023 17:45:49 +0100
Message-ID: <20230616164549.2863037-1-ross.lagerwall@citrix.com>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

We have seen a bug where the NIC incorrectly changes the length in the
IP header of a padded packet to include the padding bytes. The driver
already has a workaround for this so do the workaround for this NIC too.
This resolves the issue.

The NIC in question identifies itself as follows:

[    8.828494] be2net 0000:02:00.0: FW version is 10.7.110.31
[    8.834759] be2net 0000:02:00.0: Emulex OneConnect(be3): PF FLEX10 port 1

02:00.0 Ethernet controller: Emulex Corporation OneConnect 10Gb NIC (be3) (rev 01)

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 7e408bcc88de..0defd519ba62 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -1135,8 +1135,8 @@ static struct sk_buff *be_lancer_xmit_workarounds(struct be_adapter *adapter,
 	eth_hdr_len = ntohs(skb->protocol) == ETH_P_8021Q ?
 						VLAN_ETH_HLEN : ETH_HLEN;
 	if (skb->len <= 60 &&
-	    (lancer_chip(adapter) || skb_vlan_tag_present(skb)) &&
-	    is_ipv4_pkt(skb)) {
+	    (lancer_chip(adapter) || BE3_chip(adapter) ||
+	     skb_vlan_tag_present(skb)) && is_ipv4_pkt(skb)) {
 		ip = (struct iphdr *)ip_hdr(skb);
 		pskb_trim(skb, eth_hdr_len + ntohs(ip->tot_len));
 	}
-- 
2.31.1


