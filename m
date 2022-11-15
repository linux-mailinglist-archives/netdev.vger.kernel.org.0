Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9592F6294AA
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 10:45:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiKOJpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 04:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237119AbiKOJpX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 04:45:23 -0500
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F6B101D2;
        Tue, 15 Nov 2022 01:45:22 -0800 (PST)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AF9XLoA002200;
        Tue, 15 Nov 2022 04:44:58 -0500
Received: from nwd2mta3.analog.com ([137.71.173.56])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3kuuqhv5w8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 15 Nov 2022 04:44:57 -0500
Received: from ASHBMBX9.ad.analog.com (ASHBMBX9.ad.analog.com [10.64.17.10])
        by nwd2mta3.analog.com (8.14.7/8.14.7) with ESMTP id 2AF9iup1041297
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 15 Nov 2022 04:44:56 -0500
Received: from ASHBCASHYB4.ad.analog.com (10.64.17.132) by
 ASHBMBX9.ad.analog.com (10.64.17.10) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Tue, 15 Nov 2022 04:44:55 -0500
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB4.ad.analog.com (10.64.17.132) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Tue, 15 Nov 2022 04:44:55 -0500
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Tue, 15 Nov 2022 04:44:55 -0500
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.160])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 2AF9iatT023257;
        Tue, 15 Nov 2022 04:44:38 -0500
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <steve.glendinning@shawell.net>,
        <UNGLinuxDriver@microchip.com>, <andre.edich@microchip.com>,
        <linux-usb@vger.kernel.org>
Subject: [net v2 0/1] net: usb: smsc95xx: fix external PHY reset
Date:   Tue, 15 Nov 2022 13:44:33 +0200
Message-ID: <20221115114434.9991-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: LS6EtJn5ATURK72BSOcYumpvAnU-d_Wq
X-Proofpoint-GUID: LS6EtJn5ATURK72BSOcYumpvAnU-d_Wq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-15_04,2022-11-15_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=896
 impostorscore=0 lowpriorityscore=0 suspectscore=0 bulkscore=0 spamscore=0
 phishscore=0 adultscore=0 priorityscore=1501 malwarescore=0 clxscore=1015
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211150067
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

An external PHY needs settling time after power up or reset.
In the bind() function an mdio bus is registered. If at this point
the external PHY is still initialising, no valid PHY ID will be
read and on phy_find_first() the bind() function will fail.

If an external PHY is present, wait the maximum time specified
in 802.3 45.2.7.1.1.

Alexandru Tachici (1):
  net: usb: smsc95xx: fix external PHY reset

Changelog v1 -> v2:
  - fixed typo in commit message
  - added reset() callback to the mii_bus
  - moved fsleep() call to smsc95xx_mdiobus_reset()
  - moved is_internal_phy bool in struct smsc95xx_priv
  - added an explicit PHY_RST_ command to PM_CTRL in smsc95xx_mdiobus_reset()

 drivers/net/usb/smsc95xx.c | 46 ++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 4 deletions(-)

-- 
2.34.1

