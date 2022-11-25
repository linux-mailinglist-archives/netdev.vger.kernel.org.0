Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E822638EBF
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 18:05:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbiKYRFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 12:05:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiKYRE7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 12:04:59 -0500
Received: from smtpcmd04132.aruba.it (smtpcmd04132.aruba.it [62.149.158.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 29A92450AB
        for <netdev@vger.kernel.org>; Fri, 25 Nov 2022 09:04:55 -0800 (PST)
Received: from localhost.localdomain ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id yc8CoJAAQ1Dzayc8Copz80; Fri, 25 Nov 2022 18:04:53 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1669395893; bh=Ruox3c8DuEPJyscLBAL5O8SkKZpRA5XxQK1g0luVTkQ=;
        h=From:To:Subject:Date:MIME-Version;
        b=Ro4Ea+xpHqfA0dz24jIbsTkYxUVyD+w3Pmg4SX6YzTxFEfAsY5Lnwo+6H7vfceWte
         n6+v5isRP9k63pNfDiQZl0ZYuPCqi8fE7B8ci7sYtrNwY6sR4n7aLTsSyJHKMl4c9q
         6YFBDhvX12N16ij05FNNyoKwV4X3NUuYtE7xyY7mjThftuKdQw2F6m9DZVdzqdqHtJ
         5bLjRQkr/Y+etMxcHgVMrFCnoUHpncSFL9NYWys1s+Z2iR+T0s7CPmOfnJ746X3Fby
         F26ySHYSFSig/d2fMiSvjpQoboMlDmRmuUxgl2A97dlt8X2Xruf50EOgmDKpCD2Eqf
         i5kTSk0bxknZg==
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <linux@rempel-privat.de>
Cc:     kernel@pengutronix.de, Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Subject: [PATCH v2] can: j1939: do not wait 250 ms if the same addr was already claimed
Date:   Fri, 25 Nov 2022 18:04:18 +0100
Message-Id: <20221125170418.34575-1-devid.filoni@egluetechnologies.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221124051611.GA7870@pengutronix.de>
References: <20221124051611.GA7870@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfFEaFPauQmK2803lOGjEUc87ul6NLMLbpjRcBHK2EHDv229v8Ags4nY/0EvXEnGKIRnHH2HzaXQJHDwYJEmVPHUCkO9dRM8khSYpc/8sRjq6+XWA2WRy
 Nf5W6YiAc3OCVoTyWxPnCs6laxucqmMxr5lrrydZA8FFtZP052vFafFKeiKYnNzwohI8FWI851TBX1+98QlMX3cUac4TRY0iO6PAq6gUjH486PpdDbq4GJzr
 WEomIMaWSaRtb6uryMExxlzfqIb8Ky6WVZNz/9TaiY1iy4BcCs40MAj+wV3nwz1LC8k6V/SqJCZxaBGQk2JyQIo93Jhgklj1IDNGgmMzg3mM231JR8IcRyhJ
 GQXrFVa0CkqrvcHUU5XcF1Ie+z9D5VRSMxi64j1Oi60BLa7uhHr/XXwLvKbk6VlwkRIVaer6+X4Z1Gx1kspn78rPS3h/a081mZhGOuuMo0QGLFLT12AeWZEB
 i6X1UeFw3ZcmvyVnG7RHwPhZussE4Rd7+Gs3bcFHHpzaKwB8yj+CgipB869umUNHaOE+U29NtjZqXAb/7SDkR1irTX6K1pSHGKW6L402wD5NxtqWRiOFsAS7
 y1Wt9i9gkYXlAVJvOGrbzpBusPgccACOlPYUPIzk8E3DdA==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The ISO 11783-5 standard, in "4.5.2 - Address claim requirements", states:
  d) No CF shall begin, or resume, transmission on the network until 250
     ms after it has successfully claimed an address except when
     responding to a request for address-claimed.

But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
prioritization" show that the CF begins the transmission after 250 ms
from the first AC (address-claimed) message even if it sends another AC
message during that time window to resolve the address contention with
another CF.

As stated in "4.4.2.3 - Address-claimed message":
  In order to successfully claim an address, the CF sending an address
  claimed message shall not receive a contending claim from another CF
  for at least 250 ms.

As stated in "4.4.3.2 - NAME management (NM) message":
  1) A commanding CF can
     d) request that a CF with a specified NAME transmit the address-
        claimed message with its current NAME.
  2) A target CF shall
     d) send an address-claimed message in response to a request for a
        matching NAME

Taking the above arguments into account, the 250 ms wait is requested
only during network initialization.

Do not restart the timer on AC message if both the NAME and the address
match and so if the address has already been claimed (timer has expired)
or the AC message has been sent to resolve the contention with another
CF (timer is still running).

Signed-off-by: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
---
 v1 -> v2: Added ISO 11783-5 standard references

 net/can/j1939/address-claim.c | 40 +++++++++++++++++++++++++++++++++++
 1 file changed, 40 insertions(+)

diff --git a/net/can/j1939/address-claim.c b/net/can/j1939/address-claim.c
index f33c47327927..ca4ad6cdd5cb 100644
--- a/net/can/j1939/address-claim.c
+++ b/net/can/j1939/address-claim.c
@@ -165,6 +165,46 @@ static void j1939_ac_process(struct j1939_priv *priv, struct sk_buff *skb)
 	 * leaving this function.
 	 */
 	ecu = j1939_ecu_get_by_name_locked(priv, name);
+
+	if (ecu && ecu->addr == skcb->addr.sa) {
+		/* The ISO 11783-5 standard, in "4.5.2 - Address claim
+		 * requirements", states:
+		 *   d) No CF shall begin, or resume, transmission on the
+		 *      network until 250 ms after it has successfully claimed
+		 *      an address except when responding to a request for
+		 *      address-claimed.
+		 *
+		 * But "Figure 6" and "Figure 7" in "4.5.4.2 - Address-claim
+		 * prioritization" show that the CF begins the transmission
+		 * after 250 ms from the first AC (address-claimed) message
+		 * even if it sends another AC message during that time window
+		 * to resolve the address contention with another CF.
+		 *
+		 * As stated in "4.4.2.3 - Address-claimed message":
+		 *   In order to successfully claim an address, the CF sending
+		 *   an address claimed message shall not receive a contending
+		 *   claim from another CF for at least 250 ms.
+		 *
+		 * As stated in "4.4.3.2 - NAME management (NM) message":
+		 *   1) A commanding CF can
+		 *      d) request that a CF with a specified NAME transmit
+		 *         the address-claimed message with its current NAME.
+		 *   2) A target CF shall
+		 *      d) send an address-claimed message in response to a
+		 *         request for a matching NAME
+		 *
+		 * Taking the above arguments into account, the 250 ms wait is
+		 * requested only during network initialization.
+		 *
+		 * Do not restart the timer on AC message if both the NAME and
+		 * the address match and so if the address has already been
+		 * claimed (timer has expired) or the AC message has been sent
+		 * to resolve the contention with another CF (timer is still
+		 * running).
+		 */
+		goto out_ecu_put;
+	}
+
 	if (!ecu && j1939_address_is_unicast(skcb->addr.sa))
 		ecu = j1939_ecu_create_locked(priv, name);
 
-- 
2.34.1

