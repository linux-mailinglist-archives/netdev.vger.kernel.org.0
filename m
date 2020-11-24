Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB532C33A6
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 23:04:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388264AbgKXWDR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 17:03:17 -0500
Received: from mail-eopbgr30065.outbound.protection.outlook.com ([40.107.3.65]:60928
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388297AbgKXWDP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 17:03:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AUpOi0GEFMMsIxLn8dbmKGPR54x99oL0hyR2HExttBth8W70UrVSC3Pai4N/xWEARjRDNJLI2768uc7QrCcQomdBbntzG6UNZJTGcdWAHA8kvY+gwr/MpB21SKXurZOY9p3nLjpa8L3JOl9WkOW421leROb96Sujl3x76KFn42Y5b0UQE/u7Wz3So6Qwou3lcvRTS8h0cqy48BakoDj3snhNtBLYNouwIsc61ZU4lSFka3N8Y2ElFzsJTjVXU4D+EWDn33ARIsG7gqnDEog+vjDs9rtIpD7Ft38guqItkStIVeR9wKgxCo8j1hmvz0rZGB6IlQ2x/79r7Z1j/nrKlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izB1d+qlATKBSioTv3dGz43qLW3YwyngYEz0KbqnJ50=;
 b=JWwkr21OsjptlsbuhXcyzLJny0uazmbYuHXCINYLv+W3C2MrJq7RvoxPL1qj9T+Y1ao7LNkFf0Teqf4d/s72s5v11QcPxmeDJ8lS36zZvFZp07aM9WYn6bmMvWuu1Nq48fnEAgrQBoLKfLjhjpgZVlchsVz7lJbLsUGDo4iVT0vkgxZD73+AKhZDfSMj5/FZQo/Pmiwwb3wXNqn+ke51RAjRWY6NRMjVna+Cqz32MQKjD6sYAIzIF+pXpLujOuIyNGm+nk6KeaDaFWPyweEz+48G7yhBZAVwR6APcdbZfPMk3TTPo7Zaq5UFhQgF69RYClm0G7scFjo5HJ2M54sCog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=izB1d+qlATKBSioTv3dGz43qLW3YwyngYEz0KbqnJ50=;
 b=EUezaS8rbtv+/2kI6gjxlDKYCGzXI664Xa4Eff7sbp73A6fhBkTKhOMNaVNW0MxQO0GZcsyuXBqzuJxUc6ym72JJrQHuqjVEiABcKSrKULCXYRmKBJ7x0XpMNok83t1/SxlvTE7ktT6+f4uyU0efUu1tvMaPkByR0U/sF6BpTm8=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VE1PR04MB7343.eurprd04.prod.outlook.com (2603:10a6:800:1a2::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 24 Nov
 2020 22:03:11 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::2dd6:8dc:2da7:ad84%5]) with mapi id 15.20.3589.030; Tue, 24 Nov 2020
 22:03:11 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Po Liu <po.liu@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Subject: [PATCH v3 net] enetc: Let the hardware auto-advance the taprio base-time of 0
Date:   Wed, 25 Nov 2020 00:02:59 +0200
Message-Id: <20201124220259.3027991-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.25.2.120]
X-ClientProxiedBy: AM0PR10CA0086.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::39) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.25.2.120) by AM0PR10CA0086.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Tue, 24 Nov 2020 22:03:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 84588f06-78f5-42a8-98bf-08d890c4bbc0
X-MS-TrafficTypeDiagnostic: VE1PR04MB7343:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VE1PR04MB734372070623589B26BF03FEE0FB0@VE1PR04MB7343.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5NOSygDFJkwHYRmTax7i8VH+Dedg8mplzGv1vsxyLBU3G1+iks/MAWTnFmRrtbZaOt75KVg2PovF/QB5+pH5wqY0GRTmW/eLXLJpE7Tsm+S1v8cw8jx8B0JOq770e8552AfTahJIcrIEUTUWx87VWzoDezOraVVYyxXwIvlhC38PJdhampmHpwedacqIC6kDvxZBP0QVRtWaRG5KIORK/mtee0oP6Woe+aiTD88UzWuJCFRkndwXzGAmnCzhcy/0EniAVg8W+LqHNAuMoPZyiHxf3GgablGAGd9MuRWALciytXNqKBli79I00v8cRyn391O49TrGOJmX+a+r4NM5zRfBuC7RrwknsqfA1C2sxys1W3dc0y9S/wHd3ncaD4uq
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(396003)(346002)(376002)(39850400004)(66476007)(6666004)(1076003)(44832011)(26005)(6486002)(2906002)(16526019)(6512007)(316002)(52116002)(6506007)(478600001)(186003)(36756003)(110136005)(69590400008)(8936002)(2616005)(4326008)(6636002)(86362001)(8676002)(83380400001)(5660300002)(66946007)(66556008)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: TxY0GkalxMfOCcrYWNNBzjDG2QknLUY3xzEfXwY88bgg3b7UXlP4qwTPyBdAFLAZWu57CLVbU7Z9Z8O1YB2+f5zx9Od8pAR82oXiXJrtr/hhlnvH/a+x5sWOJjKTaM5pXT2HWf+xoqaDN3M6qRuKMgdtPiskhsIw7WjQHXU2rxp/zEB7wcb1WtUD025rWZqBvV3h3hZ3ty7Fsv3SHhpYD6d8oIe2RPm/efTYo4aJWOHj3A60LaD9usYs+bjhDNGUwnqeaA4hAxBHaMxNliu7Eeey7IQtu2GUa//QTAv8AbNPUc2a/TzIJIrSjs5UZVy0HNMPr5elb2cDtlW19f0ZwEKHXW/sKA5c6QdxYDDj9x/VWek2sn1WrXaVnC15zoeHJgmAxiRCrSNVf6c/WB5/SZyPnyUYL8O9QocLduv0muhO9WINX54M3DiqjZHEP2O6/e2Vtbthq8NyOuHuRO/raSEVzsChbvZxMf7nKmYq/cpFp7w/iYbdSnfhUqXKYm924/0zB2yel3jHr0V5awJF7x2fbF4q5ZsdDybOBzRIsN1byhS91IhFmdEr3LFyV0w0QQbNuohJlNZsdBfgaGhA7RmlWxvAe7LE1IO1sXBi82rZx9dKUGNIgkSG5L8N5BfTIiWbC+pIzdON4uekBmEDXGHVyH5zx+Hy+QGw1O4nOminXhDj42bo8Hzz/j/F3WGvzoMHLYT/TR9Ogv5+GAFus4PVs/UjS9m4uprC3YdyA40cEAubJUvaEJaoym0OrK9AZtttEgnVsyitQ6dk9wm5c35aDHODdLxYjmk5CRdjUYLh2oL/FBxSGaOljDEf8YLO5vxdlUgaFBj0Q9ilgA8TjgXV3FdeX200xhESE4dGHwCLsaprb5oSW5NNfmsIuaYQgEmkPTvhvl7SXvQsxBmmNg==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84588f06-78f5-42a8-98bf-08d890c4bbc0
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2020 22:03:11.2465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NdGj6AHuanFa69J9LjnvFBv/9xSn3jFOn1V3/cB2JeXKILZ7t2GUjJbT3FycGgITWkD93hqLF0UvdUBX7wSLxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB7343
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tc-taprio base time indicates the beginning of the tc-taprio
schedule, which is cyclic by definition (where the length of the cycle
in nanoseconds is called the cycle time). The base time is a 64-bit PTP
time in the TAI domain.

Logically, the base-time should be a future time. But that imposes some
restrictions to user space, which has to retrieve the current PTP time
from the NIC first, then calculate a base time that will still be larger
than the base time by the time the kernel driver programs this value
into the hardware. Actually ensuring that the programmed base time is in
the future is still a problem even if the kernel alone deals with this.

Luckily, the enetc hardware already advances a base-time that is in the
past into a congruent time in the immediate future, according to the
same formula that can be found in the software implementation of taprio
(in taprio_get_start_time):

	/* Schedule the start time for the beginning of the next
	 * cycle.
	 */
	n = div64_s64(ktime_sub_ns(now, base), cycle);
	*start = ktime_add_ns(base, (n + 1) * cycle);

There's only one problem: the driver doesn't let the hardware do that.
It interferes with the base-time passed from user space, by special-casing
the situation when the base-time is zero, and replaces that with the
current PTP time. This changes the intended effective base-time of the
schedule, which will in the end have a different phase offset than if
the base-time of 0.000000000 was to be advanced by an integer multiple
of the cycle-time.

Fixes: 34c6adf1977b ("enetc: Configure the Time-Aware Scheduler via tc-taprio offload")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
Changes in v3:
- Removed an obsolete phrase from commit message.

Changes in v2:
- Now letting the hardware completely deal with advancing base times in
  the past.

 drivers/net/ethernet/freescale/enetc/enetc_qos.c | 14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index aeb21dc48099..a9aee219fb58 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -92,18 +92,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_config->atc = 0xff;
 	gcl_config->acl_len = cpu_to_le16(gcl_len);
 
-	if (!admin_conf->base_time) {
-		gcl_data->btl =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR0));
-		gcl_data->bth =
-			cpu_to_le32(enetc_rd(&priv->si->hw, ENETC_SICTR1));
-	} else {
-		gcl_data->btl =
-			cpu_to_le32(lower_32_bits(admin_conf->base_time));
-		gcl_data->bth =
-			cpu_to_le32(upper_32_bits(admin_conf->base_time));
-	}
-
+	gcl_data->btl = cpu_to_le32(lower_32_bits(admin_conf->base_time));
+	gcl_data->bth = cpu_to_le32(upper_32_bits(admin_conf->base_time));
 	gcl_data->ct = cpu_to_le32(admin_conf->cycle_time);
 	gcl_data->cte = cpu_to_le32(admin_conf->cycle_time_extension);
 
-- 
2.25.1

