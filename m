Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D976595C7D
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 14:58:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233022AbiHPM5k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 08:57:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbiHPM5L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 08:57:11 -0400
X-Greylist: delayed 9449 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Aug 2022 05:56:55 PDT
Received: from ma1-aaemail-dr-lapp03.apple.com (ma1-aaemail-dr-lapp03.apple.com [17.171.2.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCC977FE7E;
        Tue, 16 Aug 2022 05:56:55 -0700 (PDT)
Received: from pps.filterd (ma1-aaemail-dr-lapp03.apple.com [127.0.0.1])
        by ma1-aaemail-dr-lapp03.apple.com (8.16.0.42/8.16.0.42) with SMTP id 27G78EXY029011;
        Tue, 16 Aug 2022 00:30:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=apple.com; h=from : content-type :
 content-transfer-encoding : mime-version : subject : message-id : date :
 cc : to; s=20180706; bh=kfbzQQ7kGHkA4s318UX6eWWGRUIQVHhzwyFKp7LGS68=;
 b=XZeg04JzopgRnEAKr7LLyI+eN6PYFiHToju2YKjMu2mDdG/88pgM03OoneTXOXgAnQBk
 RChDtQFXRFE5iO64sTW1gaAgy/KnTeWDj5ZU5zcj1EbV0kaLpxgAIo6NkGVk4+p97agU
 05ZvLx4HLPMZjhZDWy6nexqkl8HUYswFeC0Bmq9B73IKrdv6XhHVkKpF8TSgyOMSO10H
 pVxHr8ADaD2zmy3U5KSY6bv5Nuq2FpvsHfFTqlahWQp/S5mT/4stUI6aBQ8HBfmwJFMA
 yGZ4PaAZIPCVZ+zZpskfPiIMcE9VoOVReKPNnouw/DBgVylBTko5QnlRc2CQd6wNnTTv 9w== 
Received: from sg-mailsvcp-mta-lapp01.asia.apple.com (sg-mailsvcp-mta-lapp01.asia.apple.com [17.84.67.69])
        by ma1-aaemail-dr-lapp03.apple.com with ESMTP id 3hxaxuvjxj-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO);
        Tue, 16 Aug 2022 00:30:13 -0700
Received: from sg-mailsvcp-mmp-lapp02.asia.apple.com
 (sg-mailsvcp-mmp-lapp02.asia.apple.com [17.84.71.202])
 by sg-mailsvcp-mta-lapp01.asia.apple.com
 (Oracle Communications Messaging Server 8.1.0.18.20220407 64bit (built Apr  7
 2022))
 with ESMTPS id <0RGP00XWR66BOX00@sg-mailsvcp-mta-lapp01.asia.apple.com>; Tue,
 16 Aug 2022 15:30:12 +0800 (+08)
Received: from process_milters-daemon.sg-mailsvcp-mmp-lapp02.asia.apple.com by
 sg-mailsvcp-mmp-lapp02.asia.apple.com
 (Oracle Communications Messaging Server 8.1.0.18.20220407 64bit (built Apr  7
 2022)) id <0RGP00N0060RHF00@sg-mailsvcp-mmp-lapp02.asia.apple.com>; Tue,
 16 Aug 2022 15:30:11 +0800 (+08)
X-Va-A: 
X-Va-T-CD: 52f47d0d3a734aeac067923cd2934936
X-Va-E-CD: a2066982c29c3a93c49ac808e2b7df0d
X-Va-R-CD: 4618f2fbb1637c7babb5c70608677672
X-Va-CD: 0
X-Va-ID: 069cf63d-aaa0-4466-8a02-a5953dc52aa2
X-V-A:  
X-V-T-CD: 52f47d0d3a734aeac067923cd2934936
X-V-E-CD: a2066982c29c3a93c49ac808e2b7df0d
X-V-R-CD: 4618f2fbb1637c7babb5c70608677672
X-V-CD: 0
X-V-ID: d7370bab-5838-4c3e-91a5-e97aaaa09440
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-08-16_06:2022-08-16,2022-08-16 signatures=0
Received: from smtpclient.apple (unknown [10.106.132.175])
 by sg-mailsvcp-mmp-lapp02.asia.apple.com
 (Oracle Communications Messaging Server 8.1.0.18.20220407 64bit (built Apr  7
 2022))
 with ESMTPSA id <0RGP00S2Y6679P00@sg-mailsvcp-mmp-lapp02.asia.apple.com>; Tue,
 16 Aug 2022 15:30:11 +0800 (+08)
From:   Vee Khee Wong <veekhee@apple.com>
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: quoted-printable
MIME-version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: [net-next 1/1] stmmac: intel: remove unused 'has_crossts' flag
Message-id: <4C6D4699-3BC3-4F31-86E2-B5CD7410CC0A@apple.com>
Date:   Tue, 16 Aug 2022 15:30:07 +0800
Cc:     tee.min.tan@linux.intel.com, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.883
 definitions=2022-08-16_06:2022-08-16,2022-08-16 signatures=0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


The 'has_crossts' flag was not used anywhere in the stmmac driver,
removing it from both header file and dwmac-intel driver.

Signed-off-by: Wong Vee Khee <veekhee@apple.com>
---
drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c | 1 -
include/linux/stmmac.h                            | 1 -
2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c =
b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
index 52f9ed8db9c9..1d96ca96009b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-intel.c
@@ -610,7 +610,6 @@ static int intel_mgbe_common_data(struct pci_dev =
*pdev,
	plat->int_snapshot_num =3D AUX_SNAPSHOT1;
	plat->ext_snapshot_num =3D AUX_SNAPSHOT0;

-	plat->has_crossts =3D true;
	plat->crosststamp =3D intel_crosststamp;
	plat->int_snapshot_en =3D 0;

diff --git a/include/linux/stmmac.h b/include/linux/stmmac.h
index 8df475db88c0..fb2e88614f5d 100644
--- a/include/linux/stmmac.h
+++ b/include/linux/stmmac.h
@@ -257,7 +257,6 @@ struct plat_stmmacenet_data {
	u8 vlan_fail_q;
	unsigned int eee_usecs_rate;
	struct pci_dev *pdev;
-	bool has_crossts;
	int int_snapshot_num;
	int ext_snapshot_num;
	bool int_snapshot_en;
--=20
2.32.1 (Apple Git-133)

