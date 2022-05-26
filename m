Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA386534B1F
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:03:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346581AbiEZIDo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239259AbiEZIDZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:03:25 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF8870920;
        Thu, 26 May 2022 01:03:22 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24Q6TG08007426;
        Thu, 26 May 2022 08:02:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=1sJ6X7uO5m6IacAPkuONUTwebCSQBHc9s3lxi75iwoo=;
 b=xbpQxLcxb79JwruAsyqWyBL9YuXtgJFqtATwKU1bOTyQBnTKF2mAC/vSadJEyOqTeO5t
 TUdCvq1fTTUOuHCvp7h71ZurepIp5uoOcMvmKqBiPpEugISJbg7T4RNbf22e+zoYgFNc
 z+n4PM0JhF2MX5qLG0+lErBMzQYnNfNHlr8yIGIJk/fxrShmfEAJWoBeKsZ2sY+NA6K9
 sFiJqJMos/fQ4vK/wGrLwE8cIT2uYk5Ie+u8b7awnGcfewWKp4Ml4e9zJCz0tYIfg53X
 rjJCUIszoaUha3Bh2g9GPTwcEtJwhS3ub68mf95Um+yqvKxnKLokCd/BSg/BpCRfJEPx Dg== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g93t9v5f6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 08:02:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24Q7uWOj000907;
        Thu, 26 May 2022 08:02:58 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3g93x1arg6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 26 May 2022 08:02:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIUnROBXq6Saf7SPwo359SkwF1QvEFTwecpTFDYpsHiHz+HnSmzaSliQgTxuNpIyWXdLj7UmbeYUXUhlo+xzOuyGuWNGmZfroXIdyhoqHxmJmcyVj3RlXkekuJ2cctC3iAz6kHxNdkw/AY2qtqwowrzluAs/rD4hpxbL6+QJwQOp/S4rnIrdivnToEPW6mR0HG0B6uoyEygEM6OLekGTNSbHACa24SRnfje6LlXCMD0jA3NVOTme6/HnKER8pts5Sa1WtwbGXBHIjnLtwpuVCaxLU1EFtAM1cDTTb0Kfq7V0UNEH5h6W5gRWPvF4KrH3YVonKxj3SWMGpFeiHcLJ6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1sJ6X7uO5m6IacAPkuONUTwebCSQBHc9s3lxi75iwoo=;
 b=VLUnY4VkzUhdrwe1+rKcyp8m66kTIVkOzZIeP0rWib6d7DuqZij6XUBeJfVkU6jSNR5OtEZ07+lBSYFPBDGw9LxAoPRj9WyFIVXLV75JIuUyTofElNqBXqCrmDcerlpzxfFMzZBE1Z1qtVo7R9ix1UMXra4RQY+qhzjHDCABiBb0fZ9TNGGPumJhpLRdzzR/abWeFs+dynKW0JzAmsGwApumZ+m/vvrlaGORo8DXL2UfXSuM7BtT9wswRn9ONpZifOZwLvpJ8iwrPZhj50GrzHeaLetayRCxZshnY9YeIb11tKCrSTWRNkaFgOOUFPJQOkijpYKAwC4NU89B7N6Ygg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1sJ6X7uO5m6IacAPkuONUTwebCSQBHc9s3lxi75iwoo=;
 b=jmlOnMIQjWYDDVWWcBo4L6hxqDT7RanhsugQiFHTznpd25AXTwy9yMJd2Vft9Qg2MpYaOfoqyBxVgGRW+Re/EyBd/n3CR+n1OzX9bN22/VIgOx2zXRnbMrmwLwF87dJ0MdlRMKuagLAWr44IDSpW5CZCRJuk2nTTwwbt9jjXUZ4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SN6PR10MB3439.namprd10.prod.outlook.com
 (2603:10b6:805:ce::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.17; Thu, 26 May
 2022 08:02:55 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::86f:81ba:9951:5a7e%2]) with mapi id 15.20.5273.023; Thu, 26 May 2022
 08:02:55 +0000
Date:   Thu, 26 May 2022 11:02:42 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Felix Fietkau <nbd@nbd.name>,
        Nelson Chang <nelson.chang@mediatek.com>
Cc:     John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net] net: ethernet: mtk_eth_soc: out of bounds read in
 mtk_hwlro_get_fdir_entry()
Message-ID: <Yo80IuC/PRv7vF5m@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
X-ClientProxiedBy: ZR0P278CA0067.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:21::18) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 607d8a1f-0002-4aa9-1ff2-08da3eee236c
X-MS-TrafficTypeDiagnostic: SN6PR10MB3439:EE_
X-Microsoft-Antispam-PRVS: <SN6PR10MB34399D37203F737B19D478F98ED99@SN6PR10MB3439.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4Vlf0H1VDgt6Y6ci22sZoy3GrHQ43K9SwqKm7KH42iyHWTcc/ZKDRDruUD+z4N6xFlpEVzfrG6Lpdfjc2gxUm16fdFB3mapGYVEDH37J0XeTJgj2AOTjxPqXlAxeWgFNFmIebfALpNbyFuKouNVOMXlonLwGAUEvfmduYiZyQGQm2poUPjlmObXoW70ho+xBD7svCN1ENHwZZEzum25bZK3f56K0+ZtYtwSuhWukbSlmiWveKPgzNJyrHzZ4bGetiV5BUE4uU4shSxdh9qqtmtfcbk9e4iZNejXq+KISnrJzxRuqjxU413Xk9SDufcNM6uKjYqtP5DotN/feJQtnHC746NylTgxje+3dTnG9YhqIVi9dpvTY0J5mvkuZRtgNMobC410r7JhVMokpif73v0WPwy/XqQtw2FDBKSjK8OFXWTOXb46Clg6gxNC5lQ79G01S05njaGfFDPqaXH824csqcwViJvWvim9l8i4bDXkVo4GkUhgNOyColdX3G90JoTWiPywMIElCPJeQ6Ib9Vm9TL/+IdZIjQqhLcIpdIINgpQYXR1drCg2XTQRSWWitTdoNWnYdvtgdTey1X8XONKMKI9nSgA8NMC8x/sGjoBZLANiT3Fnmn36EGtCoMKetmoU0x0eNHtYimVOJ1RiY4qBJdloi1TMovFZ/eF2xwNCR/epUSun4FRcBWUpw+OowSRy6fuCkc7PIpGpGgwds8Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(66946007)(4326008)(8676002)(9686003)(6512007)(316002)(26005)(66556008)(8936002)(66476007)(186003)(86362001)(6506007)(33716001)(6486002)(508600001)(2906002)(6666004)(38100700002)(110136005)(38350700002)(44832011)(52116002)(7416002)(54906003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?j0gBunbXYgqW4sNWKGk2iYMPHAE4gvHdOn72R8DfevFJzaxc6rV9V5J4i/oX?=
 =?us-ascii?Q?P1JqIy+R8TOEfxp9AKGT2kGSWh1CcLQmlsC8CxAO4LY437QM6+Vbl4Elu4T4?=
 =?us-ascii?Q?Eup9irBhnMDIwdtBITzEH/fNgWYN1CoHOdaH7+3XbP/g/ugZawAw4l4ksFeL?=
 =?us-ascii?Q?ykiT/3l5gMOzIyG05+f2hZeJkBryEJDWTxmvNfswcjX0KcONgzcSU2xTr6Xz?=
 =?us-ascii?Q?9EXAmvRKYVHgw30bldA/iNTXxiFsXapCXCceYz5N1LSoQWAboXzG8kSP+q1J?=
 =?us-ascii?Q?eK75ITNmrxl05sH+OCUSaHg42UENJ/U+HCEv8XP/emG0k5aEyeLk+T0Sv3ZA?=
 =?us-ascii?Q?ted48bP3vwbdQ4vT23qPTMwPGATqylWdoz//HVsXWfsmSgL6C6uC0NB153XY?=
 =?us-ascii?Q?D1I9igtWaTUJrV0l0wowJo8gClyEVGg5T5gI9NARzJJeNamk87sGeeMN3qIo?=
 =?us-ascii?Q?Etp/dzrOI9vJbg9SePIOof8zh/jvB5hVWO4X6Roqbhk1Enindn+vHKG4BXR2?=
 =?us-ascii?Q?cpJ6ydWtCYxLZQO4Ao0p9zmTje31NbAfmyv55JenP3QWE3qss990+wzZJgO0?=
 =?us-ascii?Q?7spvjHWbTeMgdfDC3XK6fZ92KSb/YjogJopterGrO47W7KAJy+XpmVSznD0K?=
 =?us-ascii?Q?nARlLtpxkpyfqLSJB5eExb0X+7L5Ob0+mFB6i+qELe45kqJJAHYY4G6w5wVC?=
 =?us-ascii?Q?flkEZ59WTltrgdPB2rcVicmhGeiWosWgEm07/akIn/KxRGSgqTkQFCaDqtD0?=
 =?us-ascii?Q?5rCRME4zUT13Hz61hl692H6TBtciTFs9MgjOFpt1P1jsi3NOgkvc3SrATbXE?=
 =?us-ascii?Q?oNXXOYwM/2ER7wejPDi+nywggt/NxJzJ8CcvKkPMxuDFe7zBv9sCjjk3XYnN?=
 =?us-ascii?Q?3WMYpCXqVJgszGUIwmdie2AwP3Gw841EZrltpRcd/sUsf4jTCAC/DDKVVNoE?=
 =?us-ascii?Q?5jhnOiOIpUeWPLoMAuOzEXiX88nW0tPrtH0S2ylB/13ZlDEix6K/cmbSjBMu?=
 =?us-ascii?Q?CDO/QR8WJAw0nKSdnWZ2ymJIYlb8Zvaqc8XMuG4sOX2C30HreCyfdjD92e8j?=
 =?us-ascii?Q?HduQTrk9Y20LCFv+jWAiOLMn9iDYlIEsBZJ6IhH+aeoBFqu9D709W7MDqCCf?=
 =?us-ascii?Q?3H7+tfSTGG6to7Q9quVvnqrtFpBHuu0+YIP5i2wmeNu+jXgYahWRfydg4Da/?=
 =?us-ascii?Q?6s96QaCCIk7yh88YdN9/4UEVdK2ceg4WuSje8NPO9rpVSSiPvwlD5jrTv1nk?=
 =?us-ascii?Q?ElFjRWb7z/AdD+vM8PQ8nzYvjT7mcOlZhNlbOMNI0B233DNPsWweb8ZO1YVR?=
 =?us-ascii?Q?j5TdKfGWDJ0quqYuscr43YEu7/Z3UvcR2HFIn/xLvBTKZA8Ggg30P91LJxZd?=
 =?us-ascii?Q?RoOZx3+HlQjtyA5jcfiQEHvyUuGRLouAwv8JZoVnykBqqa/GLEYksqrPkN+A?=
 =?us-ascii?Q?k5BC3NwArYBuCsmT9M4IonLhrkguZPEboOLeH7CVfWxnyf79ACe8CMIlKW1H?=
 =?us-ascii?Q?X/JlQnj/4pHRAhsx7bvpEPRufxMYnB0mzahdX0vAnSI7ER9IrVSmlpSku6Af?=
 =?us-ascii?Q?ZN3YNEWB4+r4N2X4TnyAxNXLMG2emHE2HZ106Ai5gHxAaAP6oUt3aAo28+9Q?=
 =?us-ascii?Q?wdLjPHgtRmdPKUe/9WDgTyQIcvx/2ttJ59QUugi1RY1txhjxhHwNvntrB7vs?=
 =?us-ascii?Q?9lBF8mm1PyAqJ4esCO2wnltrs788HQwlowva1ibNEL2AYXyeFAaTjHP4QS0Y?=
 =?us-ascii?Q?Q7a7Ge461mGdcafm83hjHxvBhn7dFx8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 607d8a1f-0002-4aa9-1ff2-08da3eee236c
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2022 08:02:55.1429
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vRnFVVD9zLelfke9NnJF+YwndR3nBVOHRK+iXMVY4dv+A0KaSnlqMyY4wv34gmgH456i4Kr1zzzcpYaOzJzdaq5qBF8H/ERujgLw/Fr6ZSU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB3439
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-26_02:2022-05-25,2022-05-26 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=999
 spamscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2205260039
X-Proofpoint-ORIG-GUID: Jc5F7Y6J1I0XF_yW5h3bBR_9JI9cUXKg
X-Proofpoint-GUID: Jc5F7Y6J1I0XF_yW5h3bBR_9JI9cUXKg
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The "fsp->location" variable comes from user via ethtool_get_rxnfc().
Check that it is valid to prevent an out of bounds read.

Fixes: 7aab747e5563 ("net: ethernet: mediatek: add ethtool functions to configure RX flows of HW LRO")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index a9d4fd8945bb..b3b3c079a0fa 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -2212,6 +2212,9 @@ static int mtk_hwlro_get_fdir_entry(struct net_device *dev,
 	struct ethtool_rx_flow_spec *fsp =
 		(struct ethtool_rx_flow_spec *)&cmd->fs;
 
+	if (fsp->location >= ARRAY_SIZE(mac->hwlro_ip))
+		return -EINVAL;
+
 	/* only tcp dst ipv4 is meaningful, others are meaningless */
 	fsp->flow_type = TCP_V4_FLOW;
 	fsp->h_u.tcp_ip4_spec.ip4dst = ntohl(mac->hwlro_ip[fsp->location]);
-- 
2.35.1

