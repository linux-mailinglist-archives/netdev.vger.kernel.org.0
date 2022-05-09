Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E546D52032A
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 19:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239461AbiEIRIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 13:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239571AbiEIRIO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 13:08:14 -0400
X-Greylist: delayed 60 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 09 May 2022 10:04:12 PDT
Received: from smtpcmd0757.aruba.it (smtpcmd0757.aruba.it [62.149.156.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6F2C72D570D
        for <netdev@vger.kernel.org>; Mon,  9 May 2022 10:04:12 -0700 (PDT)
Received: from localhost.localdomain ([213.215.163.55])
        by Aruba Outgoing Smtp  with ESMTPSA
        id o6mpnGRcmrvmbo6mpnCu9c; Mon, 09 May 2022 19:03:09 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=aruba.it; s=a1;
        t=1652115789; bh=LVsltK9iEcTGK7OSkzv3VRUP3DRRbW6AQt/m9+GMyVk=;
        h=From:To:Subject:Date:MIME-Version;
        b=g8iJ9JJXkLCycAh349eNyL//x1EZ4ypV7vmNaaTbBnEzpJtFNSoIU2vJ5sebw2Hg0
         kiPc1bVoRiIMfkRJeej3Rsy7yjMvEHctHqCPYYYolh7n/PNHwoiYELhe0AgZk37Fxj
         2+DZ1IN6eB7sKj72oxdQqMMA6oAWjZJob+4jJlrZBjXuigue8iLiL3Tr++4SVdJkE1
         XtFkShHxJpdSwLhDaqHDRpt3ukSDhmvrE5s3jgCDWvzoLMRXkxGsquTN6C6VTqFAFd
         SdXsFSVUEj3+8ekoRhuD0/eseRCAS3eibkRcLIID9FSJVjLVRzANNFJbHutksui0rx
         NWbCYv+NOIrqQ==
From:   Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
To:     Robin van der Gracht <robin@protonic.nl>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     kernel@pengutronix.de, linux-can@vger.kernel.org,
        Oleksij Rempel <linux@rempel-privat.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Jayat <maxime.jayat@mobile-devices.fr>,
        kbuild test robot <lkp@intel.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
Subject: [PATCH RESEND] can: j1939: do not wait 250ms if the same addr was already claimed
Date:   Mon,  9 May 2022 19:03:03 +0200
Message-Id: <20220509170303.29370-1-devid.filoni@egluetechnologies.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMAE-Envelope: MS4xfL3pMpetwi3Y3IAoKunxzsMB5CMuj+1LhO4mLMoLUaFmfbwFEG2Rv4e8f9BIDJC2Y4tMd+YwDb+VnqVfRAzX+jTIwP5Rfvwc3ENHeVCPfCoWW3KJz1ON
 4NZSj1W1woWxyQzHV6xmnGrt9L8SJiMKs4p32fLTapb/xnJG76SxsQ+2aTXLbbNH64B06SRxEW1bys+wEBrv75kPgHq6vdoV8psVYLhqdHrqbwPDZbOOs6BL
 x7N62RW1X4QvRGhJRBqG0o4wRRf6QG5EfZ5cdqi/07wWjoJMm6jNs4UwzvSxXmtGxecBC58k12zgRxnn44veiKL6Ij2ue48/IgtPhcz8WOtSY3z9W5Cb6QEq
 54PFEtWwo1nViD92AW4Ojx4wtFlQcjpjVxgLql2gNisVXh4QlI35QJBlzMuQ13QFqIfGUFxfxyvdj6tbR2awlVf7VkkX8zwohPknQLGpHCRC17vno3cTIvxE
 sbTitJCH3BXLd/OlLpPGP62T26BBRfpFMVPnlVNA1IQBw/fS9y95zLGBSWiwgIUnFaFLYN1s5PGrSjY6g2xRtZu3AW69vZBu1P/rzMYOtOJvh9+GMc7w60fx
 0JFp6nIqSwbgPrHhTCbLfYXhPc7u8L4Klm7BKdgBHPgJf6WIi1oTtS9+1iUp/6wEoQJhE4x8zpN5LBmlJNB5yg88HnjiyXrL57GnwYCiE9LzSg==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is not explicitly stated in SAE J1939-21 and some tools used for
ISO-11783 certification do not expect this wait.

Fixes: 9d71dd0 ("can: add support of SAE J1939 protocol")
Signed-off-by: Devid Antonio Filoni <devid.filoni@egluetechnologies.com>
---
 net/can/j1939/address-claim.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/can/j1939/address-claim.c b/net/can/j1939/address-claim.c
index f33c47327927..1d070c08edf1 100644
--- a/net/can/j1939/address-claim.c
+++ b/net/can/j1939/address-claim.c
@@ -165,6 +165,12 @@ static void j1939_ac_process(struct j1939_priv *priv, struct sk_buff *skb)
 	 * leaving this function.
 	 */
 	ecu = j1939_ecu_get_by_name_locked(priv, name);
+
+	if (ecu && ecu->addr == skcb->addr.sa) {
+		/* the address was already claimed with the same name, nothing to do */
+		goto out_ecu_put;
+	}
+
 	if (!ecu && j1939_address_is_unicast(skcb->addr.sa))
 		ecu = j1939_ecu_create_locked(priv, name);
 
-- 
2.25.1

