Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C9E2284E8F
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 17:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgJFPDO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 11:03:14 -0400
Received: from mail-eopbgr10044.outbound.protection.outlook.com ([40.107.1.44]:60288
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725902AbgJFPDN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Oct 2020 11:03:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZaTUBJnfkvSMQoFL8z/WkZ/lIRVtSUx0YKhGB6u52G6xt5vwtt0hi8KBmm5QvvIdWhUKKJVOBztfODQn1zbSfyfUo8aqMic9Iwdzzs3kFDaFIfiY9Kf6Eoe/SX4AdHgjc1H3vAisOGYopVAyBX5z9jHozuuH6Nm//3WRMmSL5aEPuGo27q5NNphH/mC5I2lGWlg8/uXEYOS9QBYAjs5WGEm0toykrPTFxkxeYRzpIfxni750lUHAebgsv4y58NsawNjBHy23szyJ3TAslbaEaDCKwHXIO//65OwYPYoqA1pmmOgH2JanQd79uOz8RFTekucahzwvQHwvbymLJrr9JQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGbFl34Bqw5mq2beIk1OGSC/++ZkJ7XLltr1COw5MoU=;
 b=dm8L3N4qHOtVF1ZchFNCFY1Yvv0Q6+/qYQiJwxFbM0IIEhvgfM3wwSOjgm+CzPb1i4Y7APwkd2tOQeRgrPxBZDxw+i8WXi0SGEMQMDDzyn+VH3G+AVreT8t90Sts+4DY+EQojtIG+qCQPYa6W72g8eytYmAxrcs7rAUy0wHao/k3QjhFfVnfdyBUrwYkXemhor5BL6gSpybVFSoTYQ1Pg+uxiJw7HYdqPJB4hZsrsYQEv/wuEIHBuuKr9KN5vafPqPm8I7j/RMgoCWuSwLxgWu4LzE8vZx6R1K33jg8bLZ/PNHs1E+82uYsNa6pdCejl7P941WgI4TqwHMB3AbXIvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fGbFl34Bqw5mq2beIk1OGSC/++ZkJ7XLltr1COw5MoU=;
 b=ZFTRg+mKZFNnR1XaPqPrwCsGsQCAKtxDfWD/FAzrWJzZLJauDsWWtMJz/9LxCmQbOyqD6ksOZ9f2LWl6J00qWzaB2NdbMzVeMciAMQJA30wteRTg6zqSXKY8X3mSLmjhHYg0TXzDq+PD3rWQxkvEomPP3UDWDC92Hnwp68RUvtc=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=nxp.com;
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com (2603:10a6:803:e7::13)
 by VI1PR0402MB3710.eurprd04.prod.outlook.com (2603:10a6:803:25::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.32; Tue, 6 Oct
 2020 15:03:09 +0000
Received: from VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d]) by VI1PR04MB5696.eurprd04.prod.outlook.com
 ([fe80::983b:73a7:cc93:e63d%3]) with mapi id 15.20.3433.044; Tue, 6 Oct 2020
 15:03:09 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     davem@davemloft.net
Cc:     alexandre.belloni@bootlin.com, netdev@vger.kernel.org,
        UNGLinuxDriver@microchip.com,
        Divya Koppera <Divya.Koppera@microchip.com>
Subject: [PATCH net-next] net: mscc: ocelot: add missing VCAP ES0 and IS1 regmaps for VSC7514
Date:   Tue,  6 Oct 2020 18:02:48 +0300
Message-Id: <20201006150248.1911469-1-vladimir.oltean@nxp.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [188.26.229.171]
X-ClientProxiedBy: AM0PR02CA0028.eurprd02.prod.outlook.com
 (2603:10a6:208:3e::41) To VI1PR04MB5696.eurprd04.prod.outlook.com
 (2603:10a6:803:e7::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (188.26.229.171) by AM0PR02CA0028.eurprd02.prod.outlook.com (2603:10a6:208:3e::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.36 via Frontend Transport; Tue, 6 Oct 2020 15:03:08 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7993270b-0bc1-47ac-6241-08d86a08efb2
X-MS-TrafficTypeDiagnostic: VI1PR0402MB3710:
X-Microsoft-Antispam-PRVS: <VI1PR0402MB37105E75357DE55EB6C87858E00D0@VI1PR0402MB3710.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PUHxj962LHlsl+8lE0X25RNq1VGmIWdTt6LIp7j5U7oQRBQuXVJw77W7J097OLAVH1pZMns7Pu5lJlyUYLCWf5IBFCLEak6bZafIkSlp5Vd5uE5On9a6DVxm0sDrfyMagDhw1/4y8W1b3QuEhc0d1YvDw4GEay55mYEx2C13Jz2UgH1KcPzKYYqlTVCeKxGxaDfz+b1eX+Cnkk7Q5S7rjTDnZSdgoRWAhqK/FZMeIEZ1Sw9jpjpsWO0H4ObOe7oSgoFGpRianaN9GpfnXafMAgjtVBNi8jo7AdYQPdco1FXHBgQAK8Ye7PgjCtU+i/mogcHS3IHFyiBDTN/+pPOwzbXdNP57hiB61ZH8/KCnmM6Bb3L3vp73MUiM13GrZ6bA
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5696.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(346002)(366004)(396003)(136003)(4326008)(52116002)(186003)(6486002)(6666004)(1076003)(956004)(6506007)(36756003)(69590400008)(6512007)(26005)(16526019)(478600001)(6916009)(316002)(5660300002)(66556008)(2616005)(2906002)(66476007)(86362001)(8676002)(66946007)(8936002)(44832011);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ggYA1uj2NSIJG07MYivtD9JZWuxRAP7ZunOFcfogE9DwiB0smQN+PejLmGGdm/I5EEOyx7eDdssjErXvvphHTJ4g6Q94c40P3HfTD7GXykC7+qLwbHZks/eG+UylIO1Zs1ehrK4eBbCFPi8U3D5j+TUHJVba0p1RhJ3+yXk8CUGxl/BrgW0L2HapJ70pbblCkRUMA7Wvi32IHjE0CoeAMXJpx1ah3buXL0R+YOX+HZd5CyMvDOSyzvO5sWotfsaMvRB+zjdT0o4BjHSuEW62Ja1ULVtR1/CWLhMpIMOD6RxXBPIKFgEynha8jQkjBBGRmzCTp5A1quYFH6/sR5n+tIIYycfEaj4anNEuqAihsau26D3bL5YgLGASTp4TICgVQBk5VQGK/N6UdZryZZUmMiUJsrMucvAJOEXMNBvs9n/yQAZH33vg+wzvX6Jq6lsDkpizjoSoVJr3hk4Q5My9xfWV2iSh8b8iF9i4VmvtJzrXTlfgvYkTxr62ZaHe5P3sR2BcLSFjlsGBSxgq5GHR4uml/IiPu4ldIjH1tydwUz0TTuBRfeTlwcaB92PyuZHDoHI0uBDiCphPCp/zjKM1lcVVXwNL49QhKbd+lRT09xjSFzQIuusXq2owVYU47B+Av5wZo6xWmZu29fUHrHLsLw==
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7993270b-0bc1-47ac-6241-08d86a08efb2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5696.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Oct 2020 15:03:09.0041
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bbBc4s8Xq2fwxE8I4bpgsh+0gJmomPDzW5uf0bLyABea/cjBqTj669mSmU8/s9As0e7EQVq5jKZTwKCNBKR6Xw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3710
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Without these definitions, the driver will crash in:
mscc_ocelot_probe
-> ocelot_init
   -> ocelot_vcap_init
     -> __ocelot_target_read_ix

I missed this because I did not have the VSC7514 hardware to test, only
the VSC9959 and VSC9953, and the probing part is different.

Fixes: e3aea296d86f ("net: mscc: ocelot: add definitions for VCAP ES0 keys, actions and target")
Fixes: a61e365d7c18 ("net: mscc: ocelot: add definitions for VCAP IS1 keys, actions and target")
Reported-by: Divya Koppera <Divya.Koppera@microchip.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mscc/ocelot_vsc7514.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot_vsc7514.c b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
index ef350f34fb95..aee76730a736 100644
--- a/drivers/net/ethernet/mscc/ocelot_vsc7514.c
+++ b/drivers/net/ethernet/mscc/ocelot_vsc7514.c
@@ -320,6 +320,8 @@ static const u32 *ocelot_regmap[TARGET_MAX] = {
 	[QSYS] = ocelot_qsys_regmap,
 	[REW] = ocelot_rew_regmap,
 	[SYS] = ocelot_sys_regmap,
+	[S0] = ocelot_vcap_regmap,
+	[S1] = ocelot_vcap_regmap,
 	[S2] = ocelot_vcap_regmap,
 	[PTP] = ocelot_ptp_regmap,
 	[DEV_GMII] = ocelot_dev_gmii_regmap,
-- 
2.25.1

