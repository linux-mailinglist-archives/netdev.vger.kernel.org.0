Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70D2C604E64
	for <lists+netdev@lfdr.de>; Wed, 19 Oct 2022 19:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiJSRQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Oct 2022 13:16:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiJSRQK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Oct 2022 13:16:10 -0400
Received: from mx0a-00128a01.pphosted.com (mx0a-00128a01.pphosted.com [148.163.135.77])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD87183E1C;
        Wed, 19 Oct 2022 10:16:07 -0700 (PDT)
Received: from pps.filterd (m0167089.ppops.net [127.0.0.1])
        by mx0a-00128a01.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29JGSdNK006987;
        Wed, 19 Oct 2022 13:13:50 -0400
Received: from nwd2mta4.analog.com ([137.71.173.58])
        by mx0a-00128a01.pphosted.com (PPS) with ESMTPS id 3k7ss6gsgv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 19 Oct 2022 13:13:49 -0400
Received: from ASHBMBX8.ad.analog.com (ASHBMBX8.ad.analog.com [10.64.17.5])
        by nwd2mta4.analog.com (8.14.7/8.14.7) with ESMTP id 29JHDbvD029363
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Oct 2022 13:13:37 -0400
Received: from ASHBCASHYB5.ad.analog.com (10.64.17.133) by
 ASHBMBX8.ad.analog.com (10.64.17.5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Wed, 19 Oct 2022 13:13:36 -0400
Received: from ASHBMBX9.ad.analog.com (10.64.17.10) by
 ASHBCASHYB5.ad.analog.com (10.64.17.133) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.14; Wed, 19 Oct 2022 13:13:36 -0400
Received: from zeus.spd.analog.com (10.66.68.11) by ashbmbx9.ad.analog.com
 (10.64.17.10) with Microsoft SMTP Server id 15.2.986.14 via Frontend
 Transport; Wed, 19 Oct 2022 13:13:36 -0400
Received: from tachici-Precision-5530.ad.analog.com ([10.48.65.157])
        by zeus.spd.analog.com (8.15.1/8.15.1) with ESMTP id 29JHDISI014873;
        Wed, 19 Oct 2022 13:13:20 -0400
From:   Alexandru Tachici <alexandru.tachici@analog.com>
To:     <linux-kernel@vger.kernel.org>
CC:     <andrew@lunn.ch>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <robh+dt@kernel.org>
Subject: [net-next 1/2] net: ethernet: adi: adin1110: add reset GPIO
Date:   Wed, 19 Oct 2022 20:13:13 +0300
Message-ID: <20221019171314.86325-1-alexandru.tachici@analog.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-ADIRuleOP-NewSCL: Rule Triggered
X-Proofpoint-ORIG-GUID: VqMy5pJ_8tI3mKl5EaW37fYiwCZvlZNw
X-Proofpoint-GUID: VqMy5pJ_8tI3mKl5EaW37fYiwCZvlZNw
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-19_10,2022-10-19_04,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 adultscore=0 mlxscore=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 spamscore=0 phishscore=0
 suspectscore=0 clxscore=1011 malwarescore=0 priorityscore=1501
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2210190098
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an optional GPIO to be used for a hardware reset of the IC.

Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
---
 drivers/net/ethernet/adi/adin1110.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/drivers/net/ethernet/adi/adin1110.c b/drivers/net/ethernet/adi/adin1110.c
index 78ded19dd8c1..3e090ff9b966 100644
--- a/drivers/net/ethernet/adi/adin1110.c
+++ b/drivers/net/ethernet/adi/adin1110.c
@@ -1082,9 +1082,30 @@ static void adin1110_adjust_link(struct net_device *dev)
  */
 static int adin1110_check_spi(struct adin1110_priv *priv)
 {
+	struct gpio_desc *reset_gpio;
 	int ret;
 	u32 val;
 
+	reset_gpio = devm_gpiod_get_optional(&priv->spidev->dev, "reset",
+					     GPIOD_OUT_LOW);
+	if (reset_gpio) {
+		/* MISO pin is used for internal configuration, can't have
+		 * anyone else disturbing the SDO line.
+		 */
+		spi_bus_lock(priv->spidev->controller);
+
+		gpiod_set_value(reset_gpio, 1);
+		fsleep(10000);
+		gpiod_set_value(reset_gpio, 0);
+
+		/* Need to wait 90 ms before interacting with
+		 * the MAC after a HW reset.
+		 */
+		fsleep(90000);
+
+		spi_bus_unlock(priv->spidev->controller);
+	}
+
 	ret = adin1110_read_reg(priv, ADIN1110_PHY_ID, &val);
 	if (ret < 0)
 		return ret;
-- 
2.34.1

