Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A367331D1F8
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 22:19:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230380AbhBPVS7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 16:18:59 -0500
Received: from mx0d-0054df01.pphosted.com ([67.231.150.19]:56944 "EHLO
        mx0d-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230326AbhBPVSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 16:18:50 -0500
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11GL6aZX010451;
        Tue, 16 Feb 2021 16:17:52 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2059.outbound.protection.outlook.com [104.47.61.59])
        by mx0c-0054df01.pphosted.com with ESMTP id 36pcj9gyqb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 16 Feb 2021 16:17:52 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SPxvL3QQchFiVOrrTgiXcELgz7v2hLdJ0lt90Uk60Mcwb34/z21FsVDgrdIlHZmiz4Q/TtYJgqy/XQ3SwYV5S+lL31Vx+6tFPoupSvPrSpYVKCoSqRpiNH95N7pd3/F2zeuyFiTzu64UPATaSAQ3gmuqpqyGTDzfN0zK4PV8t6keczmf5rwBJS1E0jbxWN0d6iUculSufR1LlvMFIlxIVV0W20D4ZCLio5i6Q9sim/n9rPB3Ap1ZL5fw/oG0zKSmQkHZ/V/Z6VjrrvI1p25ASvBlwMa1fOZGirHaMgHwg4stcmLH5QBTq10JCcNQBWdkOA8tbt7UcTXXZhpRObwu9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypNnzG6Xw807Gkr9mt3WfnasXzNuIdjZ5cG2g7BHr7w=;
 b=jivIIo4cEpcojcEHx/dDh9ztoO98w45CL2tN2UvNoqXfD7Bck8L6sBVFtf8j4P7QGeqlvXzdtLmuKogFvfqBAqJ4UEBiFO8F9/l6DKX9rMH3cAMeZKh6/4XQZDfkkLyXrZZ4CVn/HX2WxuZUeVVHJMiwNdmVMwurOGEkIHX8ty4pa4GnbrUMJ5H7k6y0buRoHEIKphvR2z7roSXYxe0AzYo+TzBZRaErVIs5txcCC/px8XgWwrXwoRXtCb1uV5AwIochgnONOlCQx0HhtaJuR7t62TnfF8c0iUNFSNBlFitm4F+fDRr11TuYg/zWTjfTIpcu7Q08q1dEzsMku1CEwg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ypNnzG6Xw807Gkr9mt3WfnasXzNuIdjZ5cG2g7BHr7w=;
 b=NlGKBlJfLt4QcllQ1Xj04RlXLhBZbGBYUhQGIm2Wf5jmTYxeG4v23k2rpXkJQKvihd2KOAgWgYsYDj9Iri9xbkHuu4hutNt+rIF1bwvIeAExaXR4pxk3oPh2QzF/72mfPrRVec5gbIGaVJAu4gaOZU14G9ZY4rSK1bwKoGBvZdY=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=calian.com;
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:f::20)
 by YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.39; Tue, 16 Feb
 2021 21:17:51 +0000
Received: from YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96]) by YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::3172:da27:cec8:e96%7]) with mapi id 15.20.3846.038; Tue, 16 Feb 2021
 21:17:51 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     f.fainelli@gmail.com, linux@armlinux.org.uk,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next v3 0/3] Broadcom PHY driver updates
Date:   Tue, 16 Feb 2021 15:17:18 -0600
Message-Id: <20210216211721.2884984-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.27.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [204.83.154.189]
X-ClientProxiedBy: DM3PR14CA0128.namprd14.prod.outlook.com
 (2603:10b6:0:53::12) To YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:f::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (204.83.154.189) by DM3PR14CA0128.namprd14.prod.outlook.com (2603:10b6:0:53::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.27 via Frontend Transport; Tue, 16 Feb 2021 21:17:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a89a8b7b-4257-4976-cf0c-08d8d2c05116
X-MS-TrafficTypeDiagnostic: YTXPR0101MB0879:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <YTXPR0101MB0879660CB2592F9F44D9549CEC879@YTXPR0101MB0879.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: y99p1XnEj1MNB0/wJIhBu9bJQqIzOsClNIwibFvWsumi1JhHZ+U6NByGeNFWBFxtVHNrQMKtnSNP6xbOSBalO/qEa/BkJEwJVv2nhGlxdN2iuIatKYz/l848Kn8WhWx5Y/JS31DRtcThjnb6jZnDb0MX1yOIeqx4xXUGTljhQopv07KSNlXnhiP76XANwf4kICjRftHrSgrWMjYjefg8aru+alxjO0NBIpLhUQlL4LWg1uEks4jpQnTC4FcgxkYcQmLfqvyZuxkNgwOKogxV1QrGmhtUlBhuzGuinkIKlSwxYWcXm5JgoAGm2MdguHUVaa3T0BoyUj0kgO7v6sWsVSfflVH3GGOQjI0rBQeyvV8dkxzvlX6w0XEhCPUaCb/YLOSxcYlnC7/8lTfW/JjYlPRlQZhHYbBUlDA1Uvv3Q8sBPZ5odR8ykRShNwN5k3tr+7BI1qFvc+EXOGharEOwjEl9mlJMT2X1olPEj+mjoailB1mSr+zuX3JNmyulf4jFIh6LzosFcE06QXzi+PLPAhKCzRD1a+oJQjnV0T0lj+KC2Un0e06VKarmr2t3LHzLcv0G9Z+A3TdGGy1xspuVYg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39850400004)(366004)(346002)(8936002)(8676002)(956004)(6486002)(66476007)(1076003)(66946007)(316002)(186003)(4326008)(6666004)(2616005)(6506007)(16526019)(36756003)(478600001)(5660300002)(69590400012)(52116002)(107886003)(83380400001)(66556008)(26005)(2906002)(44832011)(6512007)(15650500001)(86362001)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?ckEeprFew7MHrnS8Lsk1VPX+pCQEgA8wkJjXoZ07fEAI6OOk/+qHtSeaKzJI?=
 =?us-ascii?Q?IWrlPXwupZ1Dj3CZR5uK7isPwZDTBC4J9j6C4mOauvECeP2pcwd/RgMu+F7A?=
 =?us-ascii?Q?I4CXx9P3D9Jr7eIhPFYi1VpS4pHnU+iHfJu09Co1H50U6fXAE0v2W9cjFo95?=
 =?us-ascii?Q?brUAJf3y4sQLxGHV6P8EjzDb7A8I2qzwYki7kdun01oHIw0z224LpHGuBwqi?=
 =?us-ascii?Q?T/dPLjvYIzCyyh9+7mF+CUpu6zWUhaz7zCYqvgJonDPoW4Mrm/1FlRvy47n7?=
 =?us-ascii?Q?3CnfAV5pMJ04xV3kW2LtAU+M9GAByJsQ7LMBKuUJkafLpVRyEdPn33Gvb5Ao?=
 =?us-ascii?Q?1Y75+0zp1bnbfCHv1EcliFMu4MvzgHMaPhHeanUX2kppH6kQDlatNwQ9rkvZ?=
 =?us-ascii?Q?yyJ5xCA3U4QATd8dVf5vsLVfMtoEGA0//u5wzoMcdM1DTpiG0P4IyyU6ETuP?=
 =?us-ascii?Q?sPDPqiSkP0HylHX08dTGQnVWYgK2/+X/S+IZF/andcZQr7AeFVz0opKh8yGr?=
 =?us-ascii?Q?KptO37FqDh2DAJk7dwOU2tQiBi33QDMSoz1eFSWlR4ewfnQ0C32QwtEmbeWR?=
 =?us-ascii?Q?FeJ1Krmc0Q8nnm9QndLb28mYMoBdltrJB74TdTR8CskuMieWZ8Q4+K2bBgEJ?=
 =?us-ascii?Q?sSyN/8BKSqhOsPjZ9gvjaJP4mPDHM/O8vA+3cewvIVS5sJJoLfDo+x7FFihR?=
 =?us-ascii?Q?ytkhrLk7NgW2dhBXic8cx5TYw9TfOjdn2vgJ+SexJxxVRYF312komxl4kIM3?=
 =?us-ascii?Q?mSgFkm4Z/ew1bFhEuOsNc2ZEQIUlhFug4Bl5qIZEm3yxNO+ANKSupYdAEin7?=
 =?us-ascii?Q?Pp86afXoSRR8iQsv/5SGzN/bOj03XdU+XiZ5nSdDb/B2Xy5rJZMJuMWAc53g?=
 =?us-ascii?Q?JSkfyLqseq7eG3sUyKtCOH+M54u++dec2R968PNQo9GYil/n2WlAEYZ4Da3W?=
 =?us-ascii?Q?sM394SqUVayWbe8R2JP4TVSKmRwUIjn3GFKXe9kzkodREtGIJJi7cWlx0T2Z?=
 =?us-ascii?Q?4hVQPowF0KSo4ATEjKsHl3q/OJf19nathpSOMOWO/ocVC2zS1TDAmNkxXOnz?=
 =?us-ascii?Q?HZDOlZhCX6mbsLjBGslqHiqyR4Un2i1sNhKCT+GpxlAq/r3f8VA0qWbKd/tv?=
 =?us-ascii?Q?FfBsySMeVewdYY9d+ntVCM74VCCmMbAaEPaDkc/YHpVgZedYBFUkFrny50ix?=
 =?us-ascii?Q?0J3P3sB3I4fmzb0o7PBuUpHDBDme9xzfmcKTtFX2QeOzoa66Q599FoE1C4rJ?=
 =?us-ascii?Q?kwqKgQRG078QBmyI8Ztc/Pu9txWYEWM5o+OisQPUTHfsztdvTsyOWUJyFwRS?=
 =?us-ascii?Q?A34xvVBZr96/3/XYO1UE8fJi?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a89a8b7b-4257-4976-cf0c-08d8d2c05116
X-MS-Exchange-CrossTenant-AuthSource: YT1PR01MB3546.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Feb 2021 21:17:51.1536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DZuoa+5e64AinwWav80N0XYuEinbz+vREA0wwkN1m9gLzTWtkYFgbkqtNQ0LyzqQzgFHSTbvHI0bmiwN6MYdAnWjUB5GWaUfOHOlggUPvSw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB0879
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.761
 definitions=2021-02-16_12:2021-02-16,2021-02-16 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 adultscore=0 mlxlogscore=805 spamscore=0 suspectscore=0 bulkscore=0
 impostorscore=0 clxscore=1015 phishscore=0 mlxscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102160172
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updates to the Broadcom PHY driver related to use with copper SFP modules.

Changed since v2:
-Create flag for PHY on SFP module and use that rather than accessing
 attached_dev directly in PHY driver

Changed since v1:
-Reversed conditional to reduce indentation
-Added missing setting of MII_BCM54XX_AUXCTL_MISC_WREN in
 MII_BCM54XX_AUXCTL_SHDWSEL_MISC register

Robert Hancock (3):
  net: phy: broadcom: Set proper 1000BaseX/SGMII interface mode for
    BCM54616S
  net: phy: Add is_on_sfp_module flag and phy_on_sfp helper
  net: phy: broadcom: Do not modify LED configuration for SFP module
    PHYs

 drivers/net/phy/broadcom.c   | 108 ++++++++++++++++++++++++++++-------
 drivers/net/phy/phy_device.c |   2 +
 include/linux/brcmphy.h      |   4 ++
 include/linux/phy.h          |  11 ++++
 4 files changed, 104 insertions(+), 21 deletions(-)

-- 
2.27.0

