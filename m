Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 282C34CE05B
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 23:44:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230031AbiCDWoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 17:44:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230019AbiCDWo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 17:44:27 -0500
Received: from mx0d-0054df01.pphosted.com (mx0d-0054df01.pphosted.com [67.231.150.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D0EC21E01
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 14:43:38 -0800 (PST)
Received: from pps.filterd (m0209000.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 224Me5r0015540;
        Fri, 4 Mar 2022 17:43:02 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2050.outbound.protection.outlook.com [104.47.61.50])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3ek4hy8n9m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 04 Mar 2022 17:43:01 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EBY5zvhFryYt3I1Fw2j7C3VA/wt/9gdZKgyxBn1yZnGVDN2Zv/mPspf5c9L7NgUIrfttLvbw+JJGtIqB5li05pNU08sJ38yq/kh8z82S8HpZPIcMf7YAfg111KvzbeMRdy0L0RoMHKOd1f0QEqs/GGgwo13jNbHx+M1k7M2sppXyxZcsLDP287NVdGmIBb6Ir23o4RFfR6TeTdde/Q1GaX3yVZTZA8o74NS5ntnFu2jjYZKch66t8RrPYp5I6TaYJHf7o297snyqQpKAV4uN8kwq2Fj+dUOzS0NehG2rMzzCiSX+fDe8JM+Eht8+7YRPkUWY+dXBAsDh3A1pSS5XiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3+LqW8j74mTu0U4MsUuTAZZwTNqq00We0jOr4Yrndgw=;
 b=mWDchu5/rPQWNzWmvft9ICKW5xknt1jizScRmlPfLcLoIs9hzqHg1cMYQYfWtrZP3Zrl8q4uqQ7cp6IZK3rmUdDzEiK7HvTOMdoKSvCRKwujVEew0q1SP3rfInC3hgJwtFzwatilkG4Xtd8U5OIZwgkUuoRS06evOBU3K6Jnys/by7mdd5lMzfGxHMW4UPlt01Jv4cPvS97VC05XVXZJbxsCpxpL2g/WPu1ULfPg0VynmhfJubBPS7eDLGzR2dihO9s5VCZc3Y7cDrS4i+I5O74H2m61IavI4YM5rHCZDJzGgZSA2KXPy+OWRUp+hykB6nQLJskk1/ntjfz23Snh0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3+LqW8j74mTu0U4MsUuTAZZwTNqq00We0jOr4Yrndgw=;
 b=NeK0wKNaK0MXKo2HcHr608CEwC8wKze5R4Tf5U7q9Wu3GynJAKkMpsURbVdU/ocWAohuBK+lRFjDw7ZWzkzFS0184pbZx6Vnv6apKbjlqCLEyrnhlql1Qg2OOTxbiDHNpjJDoThJnM4OXC0bhC8VziGig617ezV53hkWyavlZJA=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01:4b::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5038.14; Fri, 4 Mar
 2022 22:43:00 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::e8a8:1158:905f:8230%7]) with mapi id 15.20.5038.017; Fri, 4 Mar 2022
 22:43:00 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     netdev@vger.kernel.org
Cc:     radhey.shyam.pandey@xilinx.com, davem@davemloft.net,
        kuba@kernel.org, michal.simek@xilinx.com, linux@armlinux.org.uk,
        ariane.keller@tik.ee.ethz.ch, daniel@iogearbox.net,
        Robert Hancock <robert.hancock@calian.com>
Subject: [PATCH net-next 0/7] NAPI/GRO support for axienet driver
Date:   Fri,  4 Mar 2022 16:41:58 -0600
Message-Id: <20220304224205.3198029-1-robert.hancock@calian.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: CH0PR13CA0005.namprd13.prod.outlook.com
 (2603:10b6:610:b1::10) To YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:6a::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d36ca7e5-84d6-48c8-f1f8-08d9fe3055e9
X-MS-TrafficTypeDiagnostic: YQBPR0101MB6540:EE_
X-Microsoft-Antispam-PRVS: <YQBPR0101MB6540E876891FF12400396D3EEC059@YQBPR0101MB6540.CANPRD01.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OtXtz0kYfdvcBtF77Ak71PiDo1INrzcmaf9E910ZCPhI3cqwyoFFNg4qoEwYCwLU3eB7iPAEbik794hO87FuWCSWTwBP0YQ5UzLCvHGmstWbvEkMpANo9ys9hHkoI9/fXjs4j8eMg3MrZHErY6fuApR31Rr1EBnrg7VwGDMs5Vy2lPBPTbWr52Pz+E3qzyNzPYVN+D0jg3cYaW8glwVOYd5g4nVweCy7vGptZFA7UdCeXzmaSqp8G6TWFPDDTFrv14pkPnxzK4ZiiMRYSrLWvnpr/vIziGEMhe/mk14NEZoS2ZOLvrIOzGlq4RqFKKwFyoYEN/hoZs7htNZ+y8pAIQRUfyhJOBLmKQZRK94+uTh/oFLz5IRPBQjooYegrwUhnMoe41rbNOgLXDOsLray9XKuVLukMGP5Xn4WyeUw+fTsCmpNV9/d9NvIruyTsiJ5wv2phbTz/AaNN/jR/ekoiHtGkZLChMvxd7tTQ69DegVBjZlwzkAdAYSNK/HoVR+M5YD9oRnWLy4kN4DsuqPCB0wVEdOqQavwOGFHXZtfcJmRKYJU9EFdiA+2Mlevp+dZOl9hvtHNd4CyLXFaZnFQjXIYZGOJ10nE3u9htuuC33pGHKgGXCXB8iIlzP7kJ98y9ILi4wwhnX5iGU43SQK32bWfEovL6WnUjNFVt3bKwZV68xAkSs6XNW9UwSw5zi2GPx608O9OZQxHko1R4kkNsw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(26005)(186003)(316002)(2616005)(4744005)(44832011)(36756003)(1076003)(6512007)(8936002)(107886003)(8676002)(66556008)(6506007)(66946007)(2906002)(5660300002)(66476007)(52116002)(4326008)(86362001)(38100700002)(508600001)(6916009)(83380400001)(6486002)(38350700002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LUA3pmF0CuXJC2pFa2rhkKnhtXEtic7YAwOFkvrpz2gRAMuyk08JE3Hu3h9t?=
 =?us-ascii?Q?h4SVPMD5okk4XtbLt3rm0SL4ReD9/8FbJdnJTovt4tcvshiVVZCcX/GZbIXy?=
 =?us-ascii?Q?ZDj3mvUlv7bZR1Ep5pcz7wKvmSSLVYeofrePhi5JbNd5gp2A4PP97tvmw64T?=
 =?us-ascii?Q?EiKhI7UPoNwGs6bNI//mKTX0ANfDFfdgUxpo0DUhYa4k6oCatkmVHYyPtY+e?=
 =?us-ascii?Q?SwKEtJtN84BNqqsgACYQbCAR+XfKQO0ECdNfwviPFVKq9SO5CsinGe6tUnSA?=
 =?us-ascii?Q?wHtYMtELYXc5AIUL0ZQM1DGXKQcfFCUB8jxttlwTdnf9ycdSLKaCm6R/fbFc?=
 =?us-ascii?Q?IWQg8xGNRzJDoaAUy5WwuMNS1g1jToUVXf3nPP0yEN1LRjWO43ej/Oh8ZxkC?=
 =?us-ascii?Q?Lty+qwxquQxfBFSYLBpp4lo7TZ7FEs9FyQJLm/pwJ2xtl/400542Mnwxe98k?=
 =?us-ascii?Q?gJ9q56jNoI6vM3Yfqt5AuBr9zqtMV0AYCewZpGrc2tPCgW9ajqW0UGWF5Tyd?=
 =?us-ascii?Q?QwHOCu4jHxjtxOPIxGxwt1t8eHfGXwuPsOKFxPG/nsQJdhKknFW7QYXEFr5L?=
 =?us-ascii?Q?m/LB0URqlOmDI9JQ3gw2dSoJ4ubiMM9zIGQHEe+DLH/HO6K7glHJU4Ewtpfl?=
 =?us-ascii?Q?+G/6FGsx2syIZo8sYeCTxX0y5aug4Z6coZUK6Edh2dpGoyewrqXYrdGvVBlv?=
 =?us-ascii?Q?iIIG2OdP3xxdfUw2JP7yH1/t1jrR/toNL3/9XRjyqXkJOVXOaNqdLSN9UkIv?=
 =?us-ascii?Q?ZE6qPb2C5ZpjHtC/g1p45Vb3SnwVlSoLhiN4hxQPyD0S3CUl0i4Cd2G6q6xC?=
 =?us-ascii?Q?Zb2k6u6un1fjWKHojxth0qKefMgD4LeYsZCazbjw0zsn7bSS/o7Ua646N3SZ?=
 =?us-ascii?Q?eF1mXn1U4FRE3zXvYiuraeAU02fznj58foMTFO6WC0Y6r3DaE02m9gmFXMXl?=
 =?us-ascii?Q?SwCxc4vHqXJtwIy8Dmf0LsjAyQxSy59tZi0kPrSnWnqoYa/MrbvLDwi7ULww?=
 =?us-ascii?Q?Z9y2Wz5ntY+lv5QhXmre71CpIWR9QHOveiZhSxSAYySNkQNv5k+URgoxD2ik?=
 =?us-ascii?Q?APvAR2IOEkRAtpAZQlIraCNtEyc/WgW/EhcZXWye/h+vbUJmknnFSMspFlym?=
 =?us-ascii?Q?Si+ewTm2HE3S0XiTQbjb/wf1ogBZlYEFbtHH2mhenYPEskEggg0PJj6B9ZAW?=
 =?us-ascii?Q?TFj6+Bp0VG7ET7DqSKv/QmDrRY277JYMz4K21p2PDu20P7XDMZDdM6yLLxU+?=
 =?us-ascii?Q?KUt2adQjTatJPenE1u1vxZGz6YpQ+gns0By6nB86vGxsl16shM94nmlQ3cMm?=
 =?us-ascii?Q?JGC9fj+yC0HPBJes8W0MpxmAV2rNmypAU7kpO70iSKKA/LZ3JcaTJdFGpEBi?=
 =?us-ascii?Q?dSsJz2wkwTEMO8r0P4r5d6LI6wA6HVIy+oz4Z4Tbf0w8rCIFicWzUQISiATi?=
 =?us-ascii?Q?8Cs6hJIHBR7K92oN1Tc+yXYhkPGH5U3w6iG9AgtkL4nJmCopuLqxg57Afrlg?=
 =?us-ascii?Q?1ePmPTpN5MkwiOjgkMtRVLzISJg9YK0fs4s+GJrFNQmqdDg1yeu9GQOezZQF?=
 =?us-ascii?Q?RPm8lAvEdXcWiIm5+jx6fC7ASiQ582iEvN8z4jnQlF2duP390hH7tbkDpd6K?=
 =?us-ascii?Q?aWjZU13XWDGmdLpKrvqpsfvVr7Udlfka/fCF95QOXbnm0Y4id0r3uexwHZpA?=
 =?us-ascii?Q?VlMD8A=3D=3D?=
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d36ca7e5-84d6-48c8-f1f8-08d9fe3055e9
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2022 22:43:00.4322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +fTJrQOz4ZZyosX2In+I7jydduEd2xfp9I46SPN33ANguNHIIT3lGMoVXW5kY5CFuPcUvUxhVrlYHokeOTF6guNduQPHR6UCGVBxf1iDoLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQBPR0101MB6540
X-Proofpoint-ORIG-GUID: N1XJmF__XoEFlMZ2GAD_8OseywOXCwpA
X-Proofpoint-GUID: N1XJmF__XoEFlMZ2GAD_8OseywOXCwpA
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.64.514
 definitions=2022-03-04_09,2022-03-04_01,2022-02-23_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 malwarescore=0 impostorscore=0 clxscore=1011
 priorityscore=1501 adultscore=0 mlxlogscore=584 phishscore=0
 suspectscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203040112
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add support for NAPI and GRO receive in the Xilinx AXI Ethernet driver,
and some other related cleanups.

Robert Hancock (7):
  net: axienet: fix RX ring refill allocation failure handling
  net: axienet: Clean up device used for DMA calls
  net: axienet: Clean up DMA start/stop and error handling
  net: axienet: don't set IRQ timer when IRQ delay not used
  net: axienet: implement NAPI and GRO receive
  net: axienet: reduce default RX interrupt threshold to 1
  net: axienet: add coalesce timer ethtool configuration

 drivers/net/ethernet/xilinx/xilinx_axienet.h  |  16 +-
 .../net/ethernet/xilinx/xilinx_axienet_main.c | 495 +++++++++---------
 2 files changed, 262 insertions(+), 249 deletions(-)

-- 
2.31.1

