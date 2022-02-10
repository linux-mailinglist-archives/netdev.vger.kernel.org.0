Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EBA14B01EF
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231452AbiBJBVz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:21:55 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231311AbiBJBVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:21:45 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 532B91EC4E;
        Wed,  9 Feb 2022 17:21:47 -0800 (PST)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 219NcspC008865;
        Thu, 10 Feb 2022 00:28:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : content-type : mime-version;
 s=corp-2021-07-09; bh=stPv0YKi4Lqk4n+FINW3zxAvHjigjJIohALT9VxQ9MA=;
 b=ut60iFRn9Nj+J+REajf5dy2aCXWn+VRcjC0XeQUZlNZomKyr/JZjSfTeoGPRQeC1Q3dh
 QlCdPsut7rpQ0cdw5/h74okHbz/OCqL+3X5Y+tIIv0vdntOav4EzYNoihiMDWjSgk5qh
 2Kr+gHLCz5ZEY0nDEUjigLdMy6mrQp2anwvmvI5qqDVb8EufGdAqVU0su09KYGWvTBup
 tn8Jo8YIkZ4YjZFLbxwMOKaEvIanHF17HH+PmN1g52Ywz42dWgbGZdy46p3WqykK6/9O
 g9k1IL7X2rDy+vY6pt9cDw8PG6gyI1yFE1/PEKBi2jC76ur1GQo3lFHInbteqPND2YGe Ow== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e3fpgpd44-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 00:28:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21A0Fq4j108708;
        Thu, 10 Feb 2022 00:28:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 3e1ec3nwsv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Feb 2022 00:28:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chSr7ygSIC6fHUvPyGLL6s9tsqRIkHtZpEA6RJyBbaESB2d0OYd0Ho3FlaHNmZSTU0u+EM+fnCJIv9s/jgGIv5tFXWQWzP43CD5jBT4iGcLYhD0tMVl3WhRWd6tglUjdDCz05TM4MSuchpaL8XOxJnp1FlqUWjhbJwTEdmrmzIXscImnz2i5AYxW6dojuX98tJY5Z/5Ua4NDz8XhoTeZzwrUl8LDbSU0jPMswsZMb4uq1cz4XHtq7yIKo3kxeAv0Peh5oXfGauwP5ufJbVoBe2oSHbqJi2iLeUrdH0jd1BQ4n3NndhNdt1FKg0huAzmWF90VusHA10u0SX/PXYWhdg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=stPv0YKi4Lqk4n+FINW3zxAvHjigjJIohALT9VxQ9MA=;
 b=foSsMYnO6wmSqYAZpjyUpFDp6XjKzRKIiVtXSVgxCglpAE30F4Jpp6lGBKNGkXXecODfmxDN6rd1RUW/PIecv8PkF02obpLKI4OcDQ9Vf5Z9TsGYM1Q7FMnKo6YzKAnVzUFGg/RZNyg5KP4HjljEp0TV3jtlHvZPF+rGnCPEzxK8hiUzeQOvNqmD+wVX38Y5S6TkDGFXzgsGciAX6yYtCOtoADtPBDGfMCNY29uXKU2yI/OkMVU/LvJXeCB+JeK2AyuUN3VMy+Tk+Q2AjqY4i/yZcpO1+eobSzGVxRjzbxcXvwbgf+bbEtca3pYExd/tT45X5Y25CJDUeMUok3oFig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=stPv0YKi4Lqk4n+FINW3zxAvHjigjJIohALT9VxQ9MA=;
 b=WpKYELYszHOLMZikUeaOBpyFjrXElF9ykyVovpUCy500F2C4v2w11/VmDd7MI1hYctl+UjVRUQSXLCG1NOh/zDjdwxyr2xlrmkryFFvoAMHhj8g0GfXeWouPcmGX1372GeJAmvhkmBM462ZDxoKKjUY/AE+WjEf7PAIxTIUtlVQ=
Received: from PH0PR10MB4472.namprd10.prod.outlook.com (2603:10b6:510:30::13)
 by SN6PR10MB2701.namprd10.prod.outlook.com (2603:10b6:805:45::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Thu, 10 Feb
 2022 00:28:46 +0000
Received: from PH0PR10MB4472.namprd10.prod.outlook.com
 ([fe80::94eb:56d8:7cd8:ca76]) by PH0PR10MB4472.namprd10.prod.outlook.com
 ([fe80::94eb:56d8:7cd8:ca76%5]) with mapi id 15.20.4951.019; Thu, 10 Feb 2022
 00:28:46 +0000
From:   Victor Erminpour <victor.erminpour@oracle.com>
To:     davem@davemloft.net
Cc:     victor.erminpour@oracle.com, kuba@kernel.org, bpoirier@nvidia.com,
        l4stpr0gr4m@gmail.com, jiapeng.chong@linux.alibaba.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        trivial@kernel.org
Subject: [PATCH] net: mpls: Fix GCC 12 warning
Date:   Wed,  9 Feb 2022 16:28:38 -0800
Message-Id: <1644452918-576-1-git-send-email-victor.erminpour@oracle.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0026.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::39) To PH0PR10MB4472.namprd10.prod.outlook.com
 (2603:10b6:510:30::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 118e9d32-29fa-49a5-a802-08d9ec2c4c64
X-MS-TrafficTypeDiagnostic: SN6PR10MB2701:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB2701BD283208A2DAC07E187DFD2F9@SN6PR10MB2701.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:605;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xmW8I/2N43vLqw5UAbPHV1n552KuBNdIkUeE5HscSyfzpwJGIxbXYiX7XqX//KVdMgWhZnY8FgiPSq5YDlRrGqtsQggnp+uANvBXaRXI742NbfmAqGjFbeRgWeRv9LT9lOaAKnAOC/0iLz2cGAdSNHYe+xUCA4YuJzXY/fI02mphzXyxU4WuVMl66LrMCeteY9/NAFd9PNVhrLUsivRrx29HKUcbLzHT+nKcBHAVfYmtZyREtcMlOux2kqeRFG+mVMSjDTBoH0c7FDlCwW4kW+JAOu0vZ41ok7bGPBLC4txfQMMh7cDafKnGrZdq2gtRe4mFvdbZfQOH2+cg9s691Qfp3Gf/rQHm2vNHSlzrYFUax4LtFAtSS91rdUxdOUMJkTc36spL5+5gLOgvt9M2P4d10IVQ2LgugyH/CzGN7NKXXoEyd4Aq9TZ/JxxpYzetICnxsftxkH4Imc6Hjz4s68sWoiG1+Mjg9DPTBr/C7iefmaiDRCUmSLN8p1T69nNy4SNHTglts2bHyQA08hiYMXO+ccUZZdY8UNKuEsANPnatGKjaohbPiAUfNjT32S/icGwj2wjXwAqOD0CNoEdolxGG2X5C8rVEQuCrWzt5BWPn+Z5h0tvQekVIf5bXQ4SDNXYMEocFXNMa28Boi+RtyRqhlXuiWC5Qy24SGC73mSDgZrnyArJ6rk8UctCsd161KmVCKVy9CoEK7nBH81mDWQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4472.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(83380400001)(8676002)(38350700002)(186003)(4326008)(8936002)(26005)(316002)(5660300002)(6916009)(66476007)(66556008)(66946007)(36756003)(6666004)(6486002)(6512007)(52116002)(6506007)(44832011)(2616005)(508600001)(38100700002)(2906002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?HHAjB5MVbGtdTAYEyNVNVG7vOommo3ZGpOcsvvA0Ta3M++fSeJmmsSjIjtTX?=
 =?us-ascii?Q?hpXow0SP6tZ2NwFwSI8kVJ/UDZRjJEiECtnDSVPwAFUukfiIvFOzhSchhKos?=
 =?us-ascii?Q?5BBsSkxBzp76HbgZv8sMRQunHaQSPqeTGi4v5UsrxA01zgrHXpuDnkNhmCyM?=
 =?us-ascii?Q?I/ZUyn75sOV/ovmXyrJhUE5WUXrcWv2U/+JHPDFSQvG3dmXyXHBNx6x5PZfO?=
 =?us-ascii?Q?5P+u/JJxNIkRYKMBaLtkBDoN85hUq2DVpyoQWsGIs2HDtPdDOSJMSsF8B+Lu?=
 =?us-ascii?Q?Qrbcufsrz1bioj4blZGSTp8inOWxkOBce6M7Ga74sIVFqW7w/BqzIcK9NEY6?=
 =?us-ascii?Q?BeDowyGwoV2YjTprgA+BNkxC82XT6o2/Kxb2kbAWvHWKRYZ+0lcQCPv0uYEL?=
 =?us-ascii?Q?LMVTyKalU303P+gH3a9lEk8myai5KZxT46b3faz1hw8XvMnISY3OtLtOfatw?=
 =?us-ascii?Q?zKo0iHe1u7Wo2fsZXyt3c46Am4hYfH5Ydpju7cdp2qZOsCe5G/HznOkQ63BY?=
 =?us-ascii?Q?RaCB3CJac0AAcs0WVRx1GY6+Ihc+0pIpMvDpD4FktQuTQmkRnvNZkesoZg+S?=
 =?us-ascii?Q?iAXu5dep5ZYAycamv8suWU7A+WOvyctejHMFB2WNWK7Crn57VSirAiRKLEWX?=
 =?us-ascii?Q?MsKprtnwp0I5eMM/W5j1n5iTnmtyJ5CwJSlXWCFlQyVNlimQ/UzDl16qdooG?=
 =?us-ascii?Q?9kYp+bcURDf5pZ/V/efv8jl9/0gpPXikXSsvxCIUTHc59SONvzfs2PtPrXOe?=
 =?us-ascii?Q?VXDOWr3JjAmeVKm3Zx5MepLMGuvuTjusDJ+F/VBD9RMMCCLO1Fd9om7yKfqg?=
 =?us-ascii?Q?DlI4fNw23rr+8ZDMME14lBS2U2cHZZQBJHxcBQ6qzoFkAC92lxq0bcqwXtQy?=
 =?us-ascii?Q?X9lCIzjphGoDUt/l3V7sb1Trl3X92WHzAogZlkrddmytJ4g6Ii2fMbcjhYw8?=
 =?us-ascii?Q?+tcjGcpY5lSJhuwy1nbr17SdOvZF+G8uQUjsB52otWW+TX6C13HcI15LJZiA?=
 =?us-ascii?Q?JHbZnIxvvOviWCRD6lABINRiLjzUSZsAsX1AVckq+ddxPnAyctDj+9IWDwRP?=
 =?us-ascii?Q?5GYTVvPWofCE/VeqABiutc4pXr4EcUn48wFQ/0I2TSfNzjIfYCCpPpFNWKqi?=
 =?us-ascii?Q?diiYoQrNY8JscXQK4R0w4YwXLso7CG5EzVPUq2+Mcez+pZ6FclX2Z6PLqHY2?=
 =?us-ascii?Q?UrTbqMC42k2N34iuywR6Ng+YI5DK53b1h/xUrROgrHLcEAqkLBUbHiKmS8aW?=
 =?us-ascii?Q?XNE4MjxSvdHjJwlC0A3SfOhb7JgARtv3pN5dWNuhoAICHJMkLWXEHRHWHCGY?=
 =?us-ascii?Q?PRq/kH4HFrDTAbUuI4tHshGoSxZJOPROEFotJEydO15B6NeZHxzSecoU+Vg2?=
 =?us-ascii?Q?KRYHek/IsaH+7JjXizJhTTGFzt8SGJdBTknu+Ue9idZGyKJE+56f9ft/nYjV?=
 =?us-ascii?Q?a0oefeU4ihTdmHH4DiMdC6+ZWxmwd8xzYygTiR97oUCvgsdR3nb+pb3IVZpf?=
 =?us-ascii?Q?6L3KZIR+hDLGHcNMUA9OejIDlOVsNLxy6Gh/GiubEbNcS2cYKYQ6Q9BXigES?=
 =?us-ascii?Q?jDM3xdi3vdppaNstKmCnOKNACFucDvHtErdwINYZxmaOSANms3wEAJ71Cz36?=
 =?us-ascii?Q?5xMh4WpqBaBq4U8sgpgVDZYBgesFrPO1iuR5zqKSPPqAp62x2DpdNQD3f96c?=
 =?us-ascii?Q?+YsUaQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 118e9d32-29fa-49a5-a802-08d9ec2c4c64
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4472.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2022 00:28:46.4004
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pi60mDKbNtG+4WEqVPLjcbjT8jF0SBzZZqJ4KoD+laHXVrM3VwuPA6/nGfSiLuLgVE1TNEhOiZbpPalwVhGXSdyqcZdUxFEcDOSRe74i8Ec=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2701
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10253 signatures=673431
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 adultscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202100000
X-Proofpoint-GUID: hwIxjDIYBqpZT3Ya9XdRCRjTbwrafDUJ
X-Proofpoint-ORIG-GUID: hwIxjDIYBqpZT3Ya9XdRCRjTbwrafDUJ
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When building with automatic stack variable initialization, GCC 12
complains about variables defined outside of switch case statements.
Move the variable outside the switch, which silences the warning:

./net/mpls/af_mpls.c:1624:21: error: statement will never be executed [-Werror=switch-unreachable]
  1624 |                 int err;
       |                     ^~~

Signed-off-by: Victor Erminpour <victor.erminpour@oracle.com>
---
 net/mpls/af_mpls.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 48f75a56f4ae..d6fdc5782d33 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1607,6 +1607,7 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 	struct net_device *dev = netdev_notifier_info_to_dev(ptr);
 	struct mpls_dev *mdev;
 	unsigned int flags;
+	int err;
 
 	if (event == NETDEV_REGISTER) {
 		mdev = mpls_add_dev(dev);
@@ -1621,7 +1622,6 @@ static int mpls_dev_notify(struct notifier_block *this, unsigned long event,
 		return NOTIFY_OK;
 
 	switch (event) {
-		int err;
 
 	case NETDEV_DOWN:
 		err = mpls_ifdown(dev, event);
