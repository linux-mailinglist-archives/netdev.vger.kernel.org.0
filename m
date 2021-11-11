Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F28DF44D7AC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:57:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233605AbhKKOAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:00:02 -0500
Received: from mx0a-0064b401.pphosted.com ([205.220.166.238]:27164 "EHLO
        mx0a-0064b401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232883AbhKKOAB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 09:00:01 -0500
Received: from pps.filterd (m0250809.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1ABBgLEf005409;
        Thu, 11 Nov 2021 05:56:53 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=PPS06212021;
 bh=PhHL7vvYwXEfy2zdNVgDKVj+eB/yC0xjI2wBNzK5HGA=;
 b=QjZuREvFgb56iyfeV5sXHp/l/kzspzunkfrSbUWM/GWvi1za+Ybkz4CMHMu8ODNmPntk
 PIuLw66DwKnVRrMeRLtdI7AiP29/nvbT0dUy7YQ0PhRYLJepm2C15uUWatPIgOhfHXmb
 XohAJkZ+oARPkYS9Q8OjwQXD3TZGEmKYFSsi5ANKckaqYu8WRVdWrqNE7TRRfhki2ZNl
 NpSMizJ+xKFdSBm1E0Dddtw8Pw1QiVzt23Hhr/gDoyaWqmOlqD/5IDa7uaqPR0St01Zw
 Tja6gK4KDj7s4U0JcPvCTyvdkroOzNOdwF/fb7FzsLETs/22ZlL8mA1OJgkBadpVrwFI Pg== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2173.outbound.protection.outlook.com [104.47.59.173])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3c8dx9173g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Thu, 11 Nov 2021 05:56:52 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Op5u3rKRFqLz75+SAPUbzUnFniagY5sPY1oU/ytHY5aRAFm5Oh79UsM206FpYAPR/neSMnWcej0HGUyW5pJL5sc3nQG75bB5XF7zjKgfqL75i22l+2+lda1jU4KfuF+9M3+e7hBo9fg+iOOf0a84g9bSN9tTOMQE9DMxOvt974OXWgRFScmJXqXcDNzFBCSMMJn1oQDzbAcpQTAB4XHu+dXyyv6JI6gkqpDYPysEHc18IG14lpldUTRR96VX1dgd63g4JhQiLA97viM92YOXlewAokq4T9k7smyARHvqdB1b05Gf26jf6Kj9ZOFpUluvmHIJmp6B3NLtGtVNAofXWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=PhHL7vvYwXEfy2zdNVgDKVj+eB/yC0xjI2wBNzK5HGA=;
 b=MLF/czFVjNMHJXyPqvXgq0d6fmjZHKb4Xu35nr0yOYyW+L7ciZaUzK94BrJAbxty+Bh9dVXu9Wi1c9Jagy9OGfstbutSMNJpywyhiKLJQjnEzmR+5fT81mpzBbVXa36bdkUy4b02fAlLQM2ou4Y9D1GTs4Nv3E27IpElJeXoL1iHfbRMYHm8SHL30asjb+Jq4/p3JytA11cqco8jv/hlieUrI2w4cEsAht1JlQ96QR/ebxez/tsQgaUhu/AJzOBRh51W5N0jdDevhLKgfxBLyAGJIkTKjQhtgSym8JSyqzEYJ1nuvz7Cn8uE98wGaoyNIEjruMzOFcwyfaRnj8EVlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Authentication-Results: st.com; dkim=none (message not signed)
 header.d=none;st.com; dmarc=none action=none header.from=windriver.com;
Received: from PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24)
 by PH0PR11MB4885.namprd11.prod.outlook.com (2603:10b6:510:35::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.13; Thu, 11 Nov
 2021 13:56:50 +0000
Received: from PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a]) by PH0PR11MB5191.namprd11.prod.outlook.com
 ([fe80::a090:40db:80ae:f06a%9]) with mapi id 15.20.4669.019; Thu, 11 Nov 2021
 13:56:49 +0000
From:   Meng Li <Meng.Li@windriver.com>
To:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, kuba@kernel.org,
        mcoquelin.stm32@gmail.com
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        meng.li@windriver.com
Subject: [PATCH] net: stmmac: socfpga: add runtime suspend/resume callback for stratix10 platform
Date:   Thu, 11 Nov 2021 21:56:30 +0800
Message-Id: <20211111135630.24996-1-Meng.Li@windriver.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: HK2PR04CA0084.apcprd04.prod.outlook.com
 (2603:1096:202:15::28) To PH0PR11MB5191.namprd11.prod.outlook.com
 (2603:10b6:510:3e::24)
MIME-Version: 1.0
Received: from pek-mli1-d2.wrs.com (60.247.85.82) by HK2PR04CA0084.apcprd04.prod.outlook.com (2603:1096:202:15::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.11 via Frontend Transport; Thu, 11 Nov 2021 13:56:46 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3a09fcd7-dad1-41f5-44ef-08d9a51b1b73
X-MS-TrafficTypeDiagnostic: PH0PR11MB4885:
X-Microsoft-Antispam-PRVS: <PH0PR11MB4885F22BFFD176B623CD2AA8F1949@PH0PR11MB4885.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:419;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mJEhpGfz69vnMT51iRrgpXCrub52kao6fNYOxI4DZ3gFZE1r4tgvOKWKqIW/sjnTM42pnB+W4nbRz95bqNwJdatLJZIHlgn+4rOR3kFke1RRyQHA44JvvwARpq2hK0dJ0+XVBv2jxkxQ7Xm5JarAHpKXvILKDTku23SD4PH/1agmjKGdBolyO1+42dWLKbCmakrZ+j91T+NYJcpa4L9MgXH2EUUlG+rJTxcxJYKHaSLv9EP+picJ7p6dZxeaG+Na/JXpSDDiI2GkgVG5yBxlWv0kx6YkgaLP+bhhDtooS+dgFf2V1um7npAL24Mou8cRUJH4N5PyG73NTotUb+QEnO3QMI8qmJ2MWe107NdjlmJemLt/Pzx5K4oc79N7BN/acfel/eX5USw38TbONF8693auEVELuwqnH2JAry9UTuCrecvThNu7/a6KXQITGhO6iI0lJZiCAlzy9d8/zbh10jk9oaUHZ6GzdI9qAMXhCdFZVTnVe9OHEWwXO9UHBpMymSe1vwmmEP50kYhoW2THKO57Hi6AeGa7SdHhecqhsbXlNdE+52BSkKj/WDk4wxWZfxfhrx80GCGSIN58xN/tLdDTmCIF9C2SUYCl9G4WGtCziz7yM/RaIFm1CmZdla8AGkIBDIGBq9wMgC+QKxvIwoY4vXHBWp3uXBSfl7bMhM2dMeM03B8uDkaoIxvUbZahQwUyphNcPfczxFXTjIqW1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5191.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6666004)(66556008)(2616005)(8936002)(38100700002)(956004)(8676002)(38350700002)(508600001)(66946007)(7416002)(26005)(2906002)(107886003)(316002)(36756003)(86362001)(1076003)(83380400001)(5660300002)(15650500001)(6506007)(6512007)(186003)(6486002)(52116002)(4326008)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2VVR1hXai9FWm5idEZLcTJLTUV6cnVHNzBibFBSQTdrOER3NHRGNUlDWWF1?=
 =?utf-8?B?aCtVSXJMZlNrNGpiamhIRkpuWFJ1bUphVVpvaS9xVzI0NVJlbmhWTW9hNHls?=
 =?utf-8?B?QWM1Q3U0UElRK3BYZklmN2VmeFY3TnpQbjllZXRHbk1KZlFWODVOaFBnL3p2?=
 =?utf-8?B?ZFYyQ2luZFFYSjBhYnUwVlU3eUh2Tk5QcWxZa1owRHJFZGdzM2JpYVpGdlJn?=
 =?utf-8?B?cElYRlcxdllicDR1aVFCbzREUTNzWHNZUlFhN01OZ21lTVhvVktnaXFkekxZ?=
 =?utf-8?B?eHB3RUR6WndZL3ZHbzNUUEZ6c1VNTG14MHVzQnFHc0txZnlTNXpJN204ZjRO?=
 =?utf-8?B?Zi9zZEdEQTQrL3RQY0xxUXlRYTBZbkFiM2l2a2xtZ1Q2VGtRV1JYa01TVDJJ?=
 =?utf-8?B?bi9salZYQWVNN0R2dFozZGtxQkFRMDBTVlIwcldTZFJaWWRJMWhVYWg2amgx?=
 =?utf-8?B?eXAxVGRYamprWExld0R6b3NicjllbjRGVzVEbzVWeWJtYXRramhtQ3h2WTVC?=
 =?utf-8?B?UERMNklCQU56Wm1uSHlBVWs2UGVNTkp2VGg5bXBGcHFXSGE2SURiU0tXZ20x?=
 =?utf-8?B?RVhZZmlxditBYUtDMlhCNDAzRDlPZmNLclJxblI0QWhoMmhZN0VHNnFDVjFN?=
 =?utf-8?B?NXlhbnA1UDM0bVFkOHFrY2dySlQ5NVBnL21DdTRGa1NEQUcwSWVqd2VWaW8v?=
 =?utf-8?B?a3FlMUgwb2NRVmk0dHZ4NVFhcU1yS0VlcXpHU0JLQXRINkdHU3dSLzR3c3Bx?=
 =?utf-8?B?QUc2UUFBVnM5NmdNRmxBclhpbGF5bnZxMnNtUGtjemZ5c2VHZ2g3bEI2MDBM?=
 =?utf-8?B?UWxKay9hTldMeFRMWWhUMnFqRERMaXlkSEphWGJBd25JZFRjOEg0SWFEZjll?=
 =?utf-8?B?VXlYRnArMHNvbTV4Q1FLVzRjcmszVE5HV2QrdkFJT2M1UXdhRWh6UnFTMGFh?=
 =?utf-8?B?VldRNi9XeXJUdGJ0M29OUkFlQ2NrR3F6WVlVVnBGUW44WHZoZnBqZFl3YzJz?=
 =?utf-8?B?cDVRWFViM2hSakNWUVpTbjNTT2svU3pKTTl3Sm0vcmhJdEpzeHR0QzJ3QnF3?=
 =?utf-8?B?eWNIYVJDK2tSNW1vUTJRMm5jVy83Q2VIRkh3cFpxd1Z3K2hJaS9pdWpBV3R4?=
 =?utf-8?B?aC9yUlkwYS9LUGVOWHgzb0h4VG85NVU5RmE0L0YxNmV4L1I3UVNDSHJ0OXd6?=
 =?utf-8?B?M3FtZS9EYTNTV25rczdSSmNoRFlwNk44QkRWMEtKeDE0OHRkRndULzVlUDlJ?=
 =?utf-8?B?dGhBTk5XcDJneTduK0ZKUzB1bXNsUjdqNFlCcmxqY05OZ1NMSXhMRDhYN1Ar?=
 =?utf-8?B?anl1Z25FQTUrVEkwZnJQOFVKOGV3VzErYTg4WWZPRk1uSlFKTUZadlZxT3dV?=
 =?utf-8?B?YnFTZUZqY2F4RFhKempqZytVWEErWFB1bmdCYVZLeXhEVWZodWhIWHU2dDh4?=
 =?utf-8?B?WGZWYXZVWFBaT2NLL0d3bUFxU0FrcGpVYVVUSG15S2NiaFh1QlU4enI2QWFT?=
 =?utf-8?B?K2xKU1BWRFArLzJKQm9vYjdERnpKcDhQM210b0EycERHUWxnc3Vyb0p3UVds?=
 =?utf-8?B?ODV0SUNBeDhySE5hT1NyTXJyRm02WjJZTGxIbjc2cWhxcUtiVkNUbUk5ZSth?=
 =?utf-8?B?RkF5K2tZZWR3d0VnOTZERFFWWFRTbUdYaTF6ZjFIeTBTNjY4ZjhBV1dOa3Z5?=
 =?utf-8?B?RWVKQmdjZkJBSm15QVVDYkpwcm1jM0w1ZVBLMkxPZUZicjBvZWR1djNCNHVR?=
 =?utf-8?B?K2RxWlNTUHRPVTNqRHZTbDA3dFIzbGpmSG1OazhqU0lWRFFLMmJSTVZSL0Vl?=
 =?utf-8?B?ZzVWQ0JldERoWHlaUy9NejBTRnB0NDlOV1RSYVVFcUdIVlBpSlZkWEhBV09k?=
 =?utf-8?B?bU1zbkNrbGJ3RWVyS0JTdWRxMkc1RXhUcjJJYXZBUmlJWXhTRy9SWmppOHNY?=
 =?utf-8?B?N3UrWnBJR1k0Z1JnL3JITmxYRHVEa2FHL3F4U0pKRFZtSGsveG1DR3UzRWpa?=
 =?utf-8?B?dXMwQnJ3azJSbnpWSk9FNy8vS0tTNXJYTjA2d25HK2Z2eUhmNGlmUjV0YWZs?=
 =?utf-8?B?TWdXZ1h5N1B6SnU0SWg4dzJPYzdwNHpyNVFPZzVaZnVtdXM3dXRRZ3VMSWpl?=
 =?utf-8?B?SEtWZisrWCszVm9aQndDUnJLR1pzNkdaNjBGbWtlaE00RTN6RWh3V2Z6cnJx?=
 =?utf-8?Q?w2oUlR34PbB5jrTJEK9FD/8=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3a09fcd7-dad1-41f5-44ef-08d9a51b1b73
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5191.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2021 13:56:49.6927
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mosdEMTffUJWyH6mxi2SFQZtqrLb0/0Fka6LB1sGlpru1DP4Mbd4lWxHNKCy8cSyB1FQoDP50sOVxU1Wvhu7Pw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4885
X-Proofpoint-ORIG-GUID: BouA2YSPualeU-ins77kz0mcLa_sgRQS
X-Proofpoint-GUID: BouA2YSPualeU-ins77kz0mcLa_sgRQS
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-11_04,2021-11-11_01,2020-04-07_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 malwarescore=0
 lowpriorityscore=0 mlxlogscore=999 priorityscore=1501 mlxscore=0
 clxscore=1011 impostorscore=0 phishscore=0 adultscore=0 bulkscore=0
 spamscore=0 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2111110081
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Meng Li <meng.li@windriver.com>

According to upstream commit 5ec55823438e("net: stmmac:
add clocks management for gmac driver "), it improve clocks
management for stmmac driver. So, it is necessary to implement
the runtime callback in dwmac-socfpga driver because it doesn’t
use the common stmmac_pltfr_pm_ops instance. Otherwise, clocks
are not disabled when system enters suspend status.

Signed-off-by: Meng Li <Meng.Li@windriver.com>
---
 .../ethernet/stmicro/stmmac/dwmac-socfpga.c   | 24 +++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
index 85208128f135..93abde467de4 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac-socfpga.c
@@ -485,8 +485,28 @@ static int socfpga_dwmac_resume(struct device *dev)
 }
 #endif /* CONFIG_PM_SLEEP */
 
-static SIMPLE_DEV_PM_OPS(socfpga_dwmac_pm_ops, stmmac_suspend,
-					       socfpga_dwmac_resume);
+static int __maybe_unused socfpga_dwmac_runtime_suspend(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	stmmac_bus_clks_config(priv, false);
+
+	return 0;
+}
+
+static int __maybe_unused socfpga_dwmac_runtime_resume(struct device *dev)
+{
+	struct net_device *ndev = dev_get_drvdata(dev);
+	struct stmmac_priv *priv = netdev_priv(ndev);
+
+	return stmmac_bus_clks_config(priv, true);
+}
+
+const struct dev_pm_ops socfpga_dwmac_pm_ops = {
+	SET_SYSTEM_SLEEP_PM_OPS(stmmac_suspend, socfpga_dwmac_resume)
+	SET_RUNTIME_PM_OPS(socfpga_dwmac_runtime_suspend, socfpga_dwmac_runtime_resume, NULL)
+};
 
 static const struct socfpga_dwmac_ops socfpga_gen5_ops = {
 	.set_phy_mode = socfpga_gen5_set_phy_mode,
-- 
2.17.1

