Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79B2B5BDACC
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 05:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229774AbiITDUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 23:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiITDU0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 23:20:26 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2119.outbound.protection.outlook.com [40.107.117.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513BD3D5AF;
        Mon, 19 Sep 2022 20:20:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LgKI4J7xl3VBLJ22TPn+YXGCrtg6zJpAlV9mn7fFh8f0foB2U1b1nsD4R2nJkplw9LBjwqi+UQ4ZTA/Texj6fRH5zuvjUd8QXgTTazlyU7QTr1QMbHJsHYOMVlK6CpDMwt0yM7gGuf2eZbvUUAZmI8yelVGdxapppuT3oMZisV7jW8JLyWN41p2J3YXEXwnNIVMHbmijKs3vODQsabwcjqgTcoyb59cWJc2doMIIRpcLP7p+x9u/oW1zRRC1MMVldcMJfhrCTEAFOXiOeo8nkeYHn+CCW/kJw/NvAa2eX798mCqbCo3UNk/k7SzaJufE87Dmo00rm8WmdAPMbnz2Ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=91M0ReM2l31WsiBdKmM0LmJwnOtzrq9jCl9j3Gf2SpA=;
 b=m1qDpmnenS5DrUMwel5Ylf+fX58+cUGPGl4NT8vA4vA4vX+d57hLjQqhLMwL8RKEAvZGp0WmRpzy+pTZYl5fqZt3OpLy8hjC+8yNPa/UPkRb5NJ9E/4BoYF31sS4UsjEAqJ3SBE8cegbhIhCLJ23oBJwIK0g2qbnamPS8mjGG89PFcZAdpYGZUob3Fj1KiB5J6ONP82ad9LVZguSfjvzrVCH8mt1qwTqfdb1WBK3sOHbCiFS1CAHw625z6Z7M5d4QqehnSvEE+nxEGcAn0zoMXYZreMar6UKlyoau7ulg3Ka/pVCTgSiTLzEEdT/fB7YGR9aEab+7NLm92CxksAc6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vivo.com; dmarc=pass action=none header.from=vivo.com;
 dkim=pass header.d=vivo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vivo.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=91M0ReM2l31WsiBdKmM0LmJwnOtzrq9jCl9j3Gf2SpA=;
 b=Ku2xc2J9rreVKhvaE3mZVWH2eZJ4zLDMYMm9OZInFPQcVweVVvYR2knatucKU21y4Z591oOtW09o+KX8wzjvmTFZlLogqcX4oRd3IouSe3en/s34Qo1ee25SNkwATIWI7EZporz9dO+BHAmr3eZ8pMp9Sk3wH6CehFAyFLp8zUCB3xaXslh4VgGo+jpbMZmMHO5XhEZAPubO8b0V0fo5KUltkK8eycNew6UTnHZHqXCzvrHrz2Bu7FrxiwzlQHkmYe/oW7aKB24+58pNRE83hS66tOe6MZRfv/XVtRzEFXJkYbesIwZPIUiY0etOVMcUxovrpBNA8ogujVJt5CVfZA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=vivo.com;
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com (2603:1096:400:26::14)
 by KL1PR0601MB5840.apcprd06.prod.outlook.com (2603:1096:820:9a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.14; Tue, 20 Sep
 2022 03:20:19 +0000
Received: from TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::f9ad:4efb:64f6:856b]) by TYZPR06MB4173.apcprd06.prod.outlook.com
 ([fe80::f9ad:4efb:64f6:856b%5]) with mapi id 15.20.5632.021; Tue, 20 Sep 2022
 03:20:19 +0000
From:   Yihao Han <hanyihao@vivo.com>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Yihao Han <hanyihao@vivo.com>
Subject: [PATCH] Bluetooth: MGMT: fix zalloc-simple.cocci warnings
Date:   Mon, 19 Sep 2022 20:19:58 -0700
Message-Id: <20220920031958.3092-1-hanyihao@vivo.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-ClientProxiedBy: SI2P153CA0013.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:140::12) To TYZPR06MB4173.apcprd06.prod.outlook.com
 (2603:1096:400:26::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: TYZPR06MB4173:EE_|KL1PR0601MB5840:EE_
X-MS-Office365-Filtering-Correlation-Id: 967890e6-c4ac-4d0b-5a2b-08da9ab70bbe
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zPROat4HecDdzP1v3MQijqAB4+GwrGuK9HyegbreYPKUxKHhG706PHttCzzAX/mj0hZXavgoq5Gb2T1pr5Vc0YQIOQz5qSUW+A/XMIybNqxdYq1QxBBoLx1aSIPMKSSd/jAwMVeCV4Dry7/xZgTsNMbfCxQ4rvuziBiYKwm4/uc++hY3qfki29wykxsP8C72imvxx+knP7LQX++VUYccvxNFZEvSISoYlXsmMwQXp+dYymn6yA31RWlE5qslLZvt50L9sdy3GB5r1qHqHX0gN0H9RYfrapT9GgnfZnQ8Ad72naw1JQexNK1UkJFm5g6ER3m7Y9l/VCIfy0b0zz7ifGV6HUhnI1mqJbhN4/Lbl7pFwU07cs7bbx6Mmm6YyZo6NC1Pr/lsYUP3UDFPkan0zhe+2l8BjqAsdgne8iowR3tqr2CP8soUsDlCLYIFJh8nA9Hadfy/O9xrFgjmIk0S6vb+uz5sXg7n0G3icJBvkj9OBYOWGUJ15cWjP0mSkvHCslarlpJxfMNAzuCsHt7kLORa+2RL4fvl4bU77WZE1gKHOF4S2aE4sBbOwEZWRgrZrQ73hN6LE8u9y/Tsen0CEnv24IByHTLjdLLIvPy4VIUOmHZZiU8G1cLvisWEN8ISxFqvxAMwHBPNvlfyQkLcWNPaCaymV7J74LxaRZejOL4KDrD4Jw21KcFa6Dj8GJ6945jRRfnrjSpdo+ZJCeCUXOmCllHiY+u8fmXuaV0rn8b/xZByizolik2jqrt0bRuXkbd1+T0OZ272VG41dl03QoST/ef8ubmst7kPEHfypcs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR06MB4173.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(136003)(346002)(451199015)(38100700002)(66556008)(2906002)(38350700002)(921005)(107886003)(316002)(86362001)(6666004)(26005)(6512007)(6506007)(52116002)(4326008)(8676002)(66476007)(66946007)(41300700001)(478600001)(4744005)(83380400001)(6486002)(2616005)(110136005)(186003)(1076003)(8936002)(7416002)(36756003)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Up4Zd3KfZF4TcyOak/sHYo3A9q1/xVaLud/jE5otIKODf8/yF4gTd/ZkBv64?=
 =?us-ascii?Q?/xbMPOIIDflTFOt6iAB0vg71c8uT9kSvw65eoU6005qKuJ7BdJqTxYuc1xyM?=
 =?us-ascii?Q?IhwVp5jiOMlz/VgSSn8u9BR1rk6Ph8VxgUbilqWTT3v1J6EK7I/AnUY+e4tL?=
 =?us-ascii?Q?O/zRgqIBZaaLu+ySQBFHz9MPf1n078gH5/zAdO0TXCpwbZyPLyfJu4qj3k3i?=
 =?us-ascii?Q?ATO7M7/0eXlZ9zRrTbWH87CrffmwkIzdRjcjoFANqaJfPoQjYX62gdfxORVK?=
 =?us-ascii?Q?J+ooa2lPxUIixHaZNTMUBP/u8ZaPSBMB55nueJ+WqkbFpPmL/+UcFvNsp7S5?=
 =?us-ascii?Q?a3KlJG191xuwSNMJjEyvqv8FPlFpkoesZ3X7EymuwufqILltlh2WqWRqI5gw?=
 =?us-ascii?Q?49urB+RVmI3Hd5uFYRFgNo3IOk0r3rzFeVlrkPL3Kvwj37XOKG1vSoQCWPFh?=
 =?us-ascii?Q?c1TbyHBb044kGJxG1OaF/E60RdEYWsE/bjPrfQQsToH2t/GbX+2rxpnOIM9y?=
 =?us-ascii?Q?/G667H9Z1UX+uTpUitjucNZP3UzTQR1Zn/QLH6Od3G4czFdzRdXA1feYtayB?=
 =?us-ascii?Q?MgckQUeYzhngNONfA3jM1go6N/F6BmiQRAZ4+dF2JwDN6q1gknsS/mOMBeyC?=
 =?us-ascii?Q?JJ4cTx117PAJx/VwTvEKMzJEtxUFpCH4JCxTQrj+bhVmsL2tWlKo4a9PA9oT?=
 =?us-ascii?Q?t1UhpgFB4U8L5hjHnoe7S+L4jzHYLnM6OOaeUbsuXPslxYOIoRn9S+qdGFpZ?=
 =?us-ascii?Q?cLG7/TG8WoJd3o5KEqqpRIR3dYOCEYHjWH5IpF1O6rdGW525ZmqzPi2eyurI?=
 =?us-ascii?Q?gEnGwGsOGP/haM50rv4TviO6JLYHYhK/8WALBbDKIEEBw1PSpRPnpaWbeLYA?=
 =?us-ascii?Q?z6yY4KmnMBc1pBakyhw3OoNyjzWeM5fg4yNmypgQs6NSLMCL33oGJ0IRCWTD?=
 =?us-ascii?Q?WbZZ0Ol6akQ+HxjxmlX+1Y2Plr6MQS4lip2+peV/0A+x0e1joWmNsrBlJj8M?=
 =?us-ascii?Q?wwyGZienGNbo55I7IzGJdrIoaClrZ/MHEGuYyuDem2710+DcE7vp+KHyzr9z?=
 =?us-ascii?Q?q/o9VXR0BLUVCCSfzZUnLQJUqHLJqen5+QhAoF4q1GhSSgdmfLtrb5NDj3/2?=
 =?us-ascii?Q?sqFVpSSi2GZS2EankFHhGUyHCtQUY8alls6KwZ26DblCgpYAzhD3Xetw6po0?=
 =?us-ascii?Q?YMCMv90Z72ZWyw1vB1hPnbW1Yd6WjpUKq7PW+a7Xh1/LH5UqyKUUqM0sjo8X?=
 =?us-ascii?Q?7q3LlD1BXLSJCrZR+BteQTV4lNtArOugpliW943d390wuxEbtaZgWlAeV5SO?=
 =?us-ascii?Q?K0dTfoS46Mkwz8i80JBnV+e+qzb1xP5LYOkjVC/fQAlh6EuFoJ4OklH7STXw?=
 =?us-ascii?Q?canvUdZdzAODGeIRP02naLRemxU182fE+05WXb66JoqOZeXjtcfaQXliXNJ6?=
 =?us-ascii?Q?KqMXgwm3CX86zyRgB3vchKEPHsL7my4vCia09mHlOHbMfM8Yqzx2yWcW7clZ?=
 =?us-ascii?Q?U2RREn26IHArK1LRUfZyiWVv6a2UAeG7UlpedVGwAxUj8guSmyejR4Qx/wST?=
 =?us-ascii?Q?OYLCkdTMdhiUo/+Q3xKetMG8St2gKK9r0WSg6M/e?=
X-OriginatorOrg: vivo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 967890e6-c4ac-4d0b-5a2b-08da9ab70bbe
X-MS-Exchange-CrossTenant-AuthSource: TYZPR06MB4173.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Sep 2022 03:20:19.4781
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 923e42dc-48d5-4cbe-b582-1a797a6412ed
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 2qzEE4nPo8ExPwfPf0ls8o/7NXmJefJJ1TF2+Oxpy9vPBNTlccEr8El2ZgAOnRIeYh3khs2t3M1CE3lPpWrYgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KL1PR0601MB5840
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use zeroing allocator rather than allocator followed by memset with 0

Generated by: scripts/coccinelle/api/alloc/zalloc-simple.cocci

Signed-off-by: Yihao Han <hanyihao@vivo.com>
---
 net/bluetooth/mgmt.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/net/bluetooth/mgmt.c b/net/bluetooth/mgmt.c
index b9b64030a7b0..a92e7e485feb 100644
--- a/net/bluetooth/mgmt.c
+++ b/net/bluetooth/mgmt.c
@@ -4397,12 +4397,10 @@ static int read_exp_features_info(struct sock *sk, struct hci_dev *hdev,
 
 	/* Enough space for 7 features */
 	len = sizeof(*rp) + (sizeof(rp->features[0]) * 7);
-	rp = kmalloc(len, GFP_KERNEL);
+	rp = kzalloc(len, GFP_KERNEL);
 	if (!rp)
 		return -ENOMEM;
 
-	memset(rp, 0, len);
-
 #ifdef CONFIG_BT_FEATURE_DEBUG
 	if (!hdev) {
 		flags = bt_dbg_get() ? BIT(0) : 0;
-- 
2.17.1

