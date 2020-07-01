Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB2BB210E1F
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 16:55:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731673AbgGAOzU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 10:55:20 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:55754 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731585AbgGAOzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 10:55:20 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.64])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DB176600F0;
        Wed,  1 Jul 2020 14:55:19 +0000 (UTC)
Received: from us4-mdac16-66.ut7.mdlocal (unknown [10.7.64.78])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D826C2009B;
        Wed,  1 Jul 2020 14:55:19 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.36])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6D8C622005C;
        Wed,  1 Jul 2020 14:55:19 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 1E45DB40079;
        Wed,  1 Jul 2020 14:55:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 15:55:14 +0100
From:   Edward Cree <ecree@solarflare.com>
Subject: [PATCH net-next 12/15] sfc_ef100: add EF100 to NIC-revision
 enumeration
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Message-ID: <f03e0e84-4c8f-8e1e-a0c4-d8454daf9813@solarflare.com>
Date:   Wed, 1 Jul 2020 15:55:10 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-0.494900-8.000000-10
X-TMASE-MatchedRID: 8TglN2+K1z9l82eUbi7RW/3HILfxLV/9eouvej40T4gd0WOKRkwsh1ym
        Rv3NQjsE9/Qn8y+r242bHAuQ1dUnuWJZXQNDzktSimHWEC28pk0isyg/lfGoZ2HvaPRV1qwn71g
        lv4D+EXCWkqk2IvguWuovpkXHOUFXTX7PJ/OU3vKDGx/OQ1GV8t0H8LFZNFG7CKFCmhdu5cXJhm
        TC+3IJa51k1NwAZIhd+wvRQLADvnpq+UTaTTc0ZCvOkKppMBS1GFyF0i22qGD9s0XxvvKHfGvmU
        9/IY5s1iveoINIusqxazAigVxdXeiNlTYIDFiQj+C4IK5rEYL08DQfgROz55Z6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.494900-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593615319-CsK0fh_2MizQ
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Also, condition on revision in ethtool drvinfo: if rev is EF100, then
 we must be the sfc_ef100 driver.  (We can't rely on KBUILD_MODNAME
 any more, because ethtool_common.o gets linked into both drivers.)

Signed-off-by: Edward Cree <ecree@solarflare.com>
---
 drivers/net/ethernet/sfc/ethtool_common.c | 5 ++++-
 drivers/net/ethernet/sfc/nic_common.h     | 1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index 37a4409e759e..926deb22ee67 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -104,7 +104,10 @@ void efx_ethtool_get_drvinfo(struct net_device *net_dev,
 {
 	struct efx_nic *efx = netdev_priv(net_dev);
 
-	strlcpy(info->driver, KBUILD_MODNAME, sizeof(info->driver));
+	if (efx->type->revision == EFX_REV_EF100)
+		strlcpy(info->driver, "sfc_ef100", sizeof(info->driver));
+	else
+		strlcpy(info->driver, "sfc", sizeof(info->driver));
 	strlcpy(info->version, EFX_DRIVER_VERSION, sizeof(info->version));
 	efx_mcdi_print_fwver(efx, info->fw_version,
 			     sizeof(info->fw_version));
diff --git a/drivers/net/ethernet/sfc/nic_common.h b/drivers/net/ethernet/sfc/nic_common.h
index 813f288ab3fe..e04b6817cde3 100644
--- a/drivers/net/ethernet/sfc/nic_common.h
+++ b/drivers/net/ethernet/sfc/nic_common.h
@@ -21,6 +21,7 @@ enum {
 	 */
 	EFX_REV_SIENA_A0 = 3,
 	EFX_REV_HUNT_A0 = 4,
+	EFX_REV_EF100 = 5,
 };
 
 static inline int efx_nic_rev(struct efx_nic *efx)

