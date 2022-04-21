Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CCAB50A49C
	for <lists+netdev@lfdr.de>; Thu, 21 Apr 2022 17:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1390272AbiDUPtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 11:49:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbiDUPtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 11:49:23 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052361AF2A;
        Thu, 21 Apr 2022 08:46:34 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 23LF5ROH024754;
        Thu, 21 Apr 2022 15:46:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=1Xu/QFJwpxzGBIoZ/F68kHy4Sr1CuJ6hOGsiXD4JBLg=;
 b=DIw33KTfUCFkVafA4ougXQrmaQp6jlpsO/3U5865753GS322uMoq/wNycJ4nnr+qzGI4
 RxKqra8hJPVeQcTY0ogwzlWoxZmTzmS5uhF8MBu2Bkhc0Q3+QqS7Nfsc/FARix0mEIGw
 C1nQCJSAwmo01OxGjGs8YajO5iFFNUJ0XZQnC+RI2UeQBdW4dFwfWQKV8zHZQ95Z01ME
 iTyDewfm2ZA59j5ArdwVBceMNOesHBt4kX9ENzB0jIN2B/uO0WmnwOECXQZd/a0aVK2y
 iCjyjAl7AORa6x77sW7w1EjbI708SBMpSEgMD/M2Bq8cmaq3m7Npv6tSL4HZAtMVV63P Mg== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ffnp9m3fu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:46:28 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23LFb23a039368;
        Thu, 21 Apr 2022 15:46:26 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3ffm89dk51-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 21 Apr 2022 15:46:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=c133nq8na+TmAO0YQjra24zE1cerYes8OOR5DQIdqs7U2+hDmHl0H/tdntVwWUBoaYtNY4IodWB9ni5kT/2Cuker3mmMhDIXrueSnAkd4iPsdRiFFGJK8oghIFxRcOOuYyMUp7HBSOLXSLS72E+SuArc3pFi0PKUU9Sf/uFDRKIqrW52WzrFrx+lknxRjyqj4tx0/hyq73PrNVNxjV/uuopgsZNGPOWBQfHk5KidS6qFbLZytlOng7klN8OMFhHxU9McN/bdJVEKt/cY45JbrsEeYtymxcqtbN5H4SRzDSIdaN59RfjdbYSiSI7+/oxcFSi/qvoDC5mvkKMdErU0+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Xu/QFJwpxzGBIoZ/F68kHy4Sr1CuJ6hOGsiXD4JBLg=;
 b=agK6++Hcd2zHJL4Vhsi13hAUdpI28huZHolFn4s2//OFjeJ8EIJ69SZHAiNPCgGwxgUyfvY7uMlfmM1NCfNTHt9Pelv7qyI1GjvJe4LByIBxUqO0eIH6CXBUcxG4AnWNYWlLT0+7h8L+koH+ZqY3fYHI3lg/u+zIt+a2FLml7vKd9dBDwl6+LdqtHOObr/cQpmpzkONkAoXz9NH/OW6DP6oXkfiImPy9OmTOEp8fUfSHyRS8UAmoBbQbPJNwclKcRBAGD/1lgLuuo5FqgExEcdOZvUfPDE2QSrOkXwG3WcMb+Tjau/9nVaKN9RHOLo4vj7A9qYonSn1tWh7zmmDAcw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1Xu/QFJwpxzGBIoZ/F68kHy4Sr1CuJ6hOGsiXD4JBLg=;
 b=C9SKTB5HZLlZmCN/POTvWSq4c6eNby/NPPwe6DkTfSFUTxvO9bhV2K/Eb1wPy7XZsFeB17kF7XfrNZyvtAvz3/cuRY5hYIoUI3QQaOjWk48pgDm89CORnD4nq8Kvm6fev95QYd1/SpUa95SxBvTLsGdohZ3S5sxlR6/uKknB1l4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by BN0PR10MB5351.namprd10.prod.outlook.com
 (2603:10b6:408:127::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Thu, 21 Apr
 2022 15:46:24 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::b5d5:7b39:ca2d:1b87%5]) with mapi id 15.20.5164.025; Thu, 21 Apr 2022
 15:46:24 +0000
Date:   Thu, 21 Apr 2022 18:46:13 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: lan966x: fix a couple off by one bugs
Message-ID: <YmF8RTClhMXPVPgh@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0177.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:45::11) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e27f058d-2ac3-4bfa-928c-08da23ae171c
X-MS-TrafficTypeDiagnostic: BN0PR10MB5351:EE_
X-Microsoft-Antispam-PRVS: <BN0PR10MB53512C53DC174BFFDACEC4368EF49@BN0PR10MB5351.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5xC3JHPQPs4oo2LpjD504mHo2K/5/E55yB86szFM+1vqIWfaEW/yvjmVOAxHW9vfobZCvfWDKBmVOhat8NsQu8r7F5WCyoYoZMHSg+YatllPAigHoNCCvbAqe2zhVs2F+ru2ERTLofCTQ7QjfNlGSs4EHkGQ1iZN33x5JHOoK2TsV1QNUnDQKr/yMlZQTrlJGjJPhApYhiLFTI6raUf34JrVbDkOXl/p8KaM3tB4f2IfOSO3CSwLMrrmIOmQaZY66KVbgwJwhBm5N5NxJhGSO4K05n+Sj0MZ1iCfdYGc9E61RlDKy/sMM2crCeYxkilxllS05drvbGrUWgVLzt1d8qDw9FwCYp4l8uJJd3wdhnB7RdMH3MfVnQpHvaMXxrM36chKgLTehlM33tfF3akbkO/4D1zbHHNNxgLUqUVDW9PgmTy4s4/wfzPpTL0xSDgbexAQ0P0dMjop38UuE/9OMfvG0pH1SMCjPTLC5I9g5eKxtM/nkkzwHKSvAJ3ZhIXsA371d/Y7exCazqnBhunaGeo8Wu0g7rg/Oq+J0SgSeVeR5nlp8ARwz+7pLFt3vjDW6fnVpSfVznMUOyu58S/kvpOdMYLGCbka+7r3rEFVXE/b3P5POfrgoyERElPrkv11dzwvoSQWN7nIGrwAZoCtt3QdzUAqXSEt8ro9vBkfOzK+K3OkQRdsvrv5XR1Rr+/xJ++6nu+Sa86Ko8+N5B4Eqw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66556008)(44832011)(52116002)(26005)(8936002)(83380400001)(8676002)(4326008)(66476007)(6666004)(2906002)(33716001)(66946007)(9686003)(6506007)(6512007)(186003)(5660300002)(508600001)(6486002)(38100700002)(38350700002)(316002)(54906003)(6916009)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Ud6iriQVYOCZwbq7vQWyHklyilimkeJAU11vnkmfgjCJ/0Klll9yze1D+4cz?=
 =?us-ascii?Q?ojjD2hOFrqoAnz4ilce/UzIbZ1og+AWisVJdIutn4QdIjQqhvl2tHxHj/1bF?=
 =?us-ascii?Q?Z8OPzhRevloZeiPFVLkoPILwusSBxvw5MLxGgmLXU/qtSTXu4b7oWBJspzpu?=
 =?us-ascii?Q?v3qTwkg2jVPSLsczkvAIyUgK9Ntm2PF6Yjla2QScAC82x1YzXlTV3ODz9MtU?=
 =?us-ascii?Q?Mpwnqs9vpMhxhOt//2pj/868v3vZCDgNtPBhwc3s5BYLjLoxgUJi4tnWpbIg?=
 =?us-ascii?Q?imBSgphlCHv2Ky3jlKwcLvpfniupHZ9mAFccu2D63H+pmO4KWNCXwIcseZGp?=
 =?us-ascii?Q?GfnXrQYwCMH2r3tLhbtcD81vzUxYe8HKwo8tLSe00qDexQYipQAI8F4JsaDW?=
 =?us-ascii?Q?au4JhO1nQFYj3wyt+mtco0CfBqOczWhdHhWhZ/BoT7AyBp2oeYkADPrQQLjI?=
 =?us-ascii?Q?98wsBcnknCFNRRmOuyw7uUmDijDjx1HdAATYZ7Jy+iue0MNpO20k0ZqRFajk?=
 =?us-ascii?Q?x7/VnDen/6cDtFKxdPDuRrnrk1K7GbPlaD/OvAiEo8qt0v6DKL+3axQMNEux?=
 =?us-ascii?Q?h6elxN+KXvd5JivGKmqaVouBmRJf7ZLuApS40vLaFvfhcL8etyumHAR5Ngnk?=
 =?us-ascii?Q?eaJZ2nWGpOiKeVl4eLAyeR/EYdV8IdU2H+XNeltZrG6l0hyvPESMzHeePTS1?=
 =?us-ascii?Q?fd3TALv/nyz/gDM0CTWUM2sSUZhIyXd7VFVKWFZNojaomBcUFNiAaJ/8Q0b9?=
 =?us-ascii?Q?X/syYhsuprrJBfX+aW+x5tFCmdF02B11xOk7ZzQat/QDkPkTV63PkbsNrUY3?=
 =?us-ascii?Q?m30fS4erFNzoMMPLrFaSv+tX0fvSHXzGSyqGzkjXfbfqh8JV2SOlFscst0vL?=
 =?us-ascii?Q?kEb5hTic+E8ZWLloJInx9uKZKY5LMwiFuvxgKaW+ToRc5O+9aVRCF6rD0fRK?=
 =?us-ascii?Q?oLzfViuE/s2bdWsEPO4v30ztyPs16wTt7gRXxyqkRNsOBE1u1I4PANWehJXn?=
 =?us-ascii?Q?K2s+KSjB9O6uDTqswQcx+4d+y75ic5rmW+79w5Ig1Po5BHDc9wxXNX4cdFnE?=
 =?us-ascii?Q?s4Nvlycnx429vqpFz8QEzLDAuHN9NfxnP4XrHoEU3nofRqx+k2GMsz4bTuv3?=
 =?us-ascii?Q?6ORhrfE01jar+IxmHW2jnXMFigCqkuqm3HnGNWqH9ITyioCNEg+gY8+HvWXu?=
 =?us-ascii?Q?Il+t7u0OImdd6JDX7rBNcMZxIuUzSRqiLFM9jiMFSQSLNkhr41topLjDMhM2?=
 =?us-ascii?Q?TS5CyA+Ks6Rcw17zkFcHJozXXT6plWTnAY08Z37qofemhJcOrtBJui1jkSsc?=
 =?us-ascii?Q?NylY1ga/J3jwVn9v18AZj8RHKxRklAaAtY4isCxELuRIGO2jmbR1svIB4nYz?=
 =?us-ascii?Q?dMxaGJLKDR29suNffXECDThOgw20H61FRp9dQrnEsNvnUKOUQB8nWSHSBhT6?=
 =?us-ascii?Q?Wg/HeoC+Ygn8TImEwzLNAA2MZ4OWnhCT6TC+f+RzVQMuvAN6h4oDgUgQ5H/7?=
 =?us-ascii?Q?L7miiVZCv94r0dB1yKaeOqSmBtjY5FREEIO/yrGPqiowO0BdGS5yM1tPytYX?=
 =?us-ascii?Q?MHcFJYhi7dJsigfT3CL7pQo9PDNnhxlTYzVa8RufCCX+ak6Co4GJpqsOaYpw?=
 =?us-ascii?Q?GeZwFsLoks4Kic03dGn1SHAF+lSGtndGrSCxd7rbm9mtiNFa3T/VdjbsNUwj?=
 =?us-ascii?Q?7KlY7X1a8lIPYXTOU6JnaG3HmxDNUVVsr15jBVCwnsLv9RQTisG20vbq4tJO?=
 =?us-ascii?Q?T9pHBzchD26WsAe5O1cDKt3rJQDPtc0=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e27f058d-2ac3-4bfa-928c-08da23ae171c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Apr 2022 15:46:24.8188
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZarHkArK89/cZ0kjXmrIWIlJd+ei/erNees/ZA+Wm2rgYGAZZKUdOKMfkt7qK2B9wvd+z3roR9KzEoYjlenyiC7lJnapcIUmlFywvQBjK70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB5351
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-21_02:2022-04-21,2022-04-21 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=999 phishscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204210084
X-Proofpoint-ORIG-GUID: D63m9ftU6Ovow71UMs35M1JGZ2CthpnA
X-Proofpoint-GUID: D63m9ftU6Ovow71UMs35M1JGZ2CthpnA
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The lan966x->ports[] array has lan966x->num_phys_ports elements.  These
are assigned in lan966x_probe().  That means the > comparison should be
changed to >=.

The first off by one check is harmless but the second one could lead to
an out of bounds access and a crash.

Fixes: 5ccd66e01cbe ("net: lan966x: add support for interrupts from analyzer")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_mac.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
index 2679111ef669..005e56ea5da1 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_mac.c
@@ -346,7 +346,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 			lan966x_mac_process_raw_entry(&raw_entries[column],
 						      mac, &vid, &dest_idx);
-			if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+			if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
 				continue;
 
 			/* If the entry in SW is found, then there is nothing
@@ -393,7 +393,7 @@ static void lan966x_mac_irq_process(struct lan966x *lan966x, u32 row,
 
 		lan966x_mac_process_raw_entry(&raw_entries[column],
 					      mac, &vid, &dest_idx);
-		if (WARN_ON(dest_idx > lan966x->num_phys_ports))
+		if (WARN_ON(dest_idx >= lan966x->num_phys_ports))
 			continue;
 
 		mac_entry = lan966x_mac_alloc_entry(mac, vid, dest_idx);
-- 
2.20.1

