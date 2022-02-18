Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07F9D4BBC2C
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 16:27:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237006AbiBRP2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 10:28:08 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiBRP2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 10:28:08 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2B92253BD6;
        Fri, 18 Feb 2022 07:27:51 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21IF6erp001040;
        Fri, 18 Feb 2022 15:27:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : content-type : mime-version; s=corp-2021-07-09;
 bh=gkGCjJOhebfvFcEnFsGKOWf1Wya0jV1GJdYtI2ZK2QA=;
 b=xtYyqFKqzAdZmEFSbfkD9wzbpAz80Y8lLMSEnL0JiVHyxkblMivUExWf/eUyLjJqCp1Q
 9OtjihF1jYQUIAGRqOcxJqpltXqUelUjGfF4cGCHfSprROY7GjduPetVMnzx8Gjl9g1Q
 JQsu7AJvcD6zf7G1Rlpi/pv1drD6fJR2+znD91eyF5S5kT6HfV4VhzEJpLz3pgzohLk3
 C/vbXeTjAI3i1T4YmkVU5yvWvGTceH7LWQ7FM9VhrFRkpdRR32ziTZ4Sclql7DUnWvNt
 1JXTxLCyMAmtOIiBYGpBnUzUd7HBaCs4XEhL3RIgAaFjqOSEUtXlm729WQyGF6SqBpSI iw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3e8n3e1vy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 15:27:46 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21IFAH6S120877;
        Fri, 18 Feb 2022 15:27:45 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3020.oracle.com with ESMTP id 3e8nvvg5wm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Feb 2022 15:27:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JocFXdNaBCQ+p67xELU/U3DjPYGsuDEaqn9Byv01nVTF5y662XhTYocyiBuj1QneBs4BKax9XJNQuLyusS2etsLy70qwbIXN7xUPbNoHHsPrQDDbh7/AUM85yx13O7lzvys+fQFUSb6xpKNwx6TKVLJgBpzTSTOvOSIz06425DTHGqeYUP64uG894wBW7LTH3qoDyZZgd50BaXcwr9tRfBm6PLmLzk16VARZftao2eK1AOF6nFf3MV5bf6nmVes4KhJPBdS1VVuINHaRNQHa7Z+xqwdrO5YNZbhDAiIJiljOhzsWYNoTrOCN6JYpKBz+lQ+YWBu9Q7Dcp6CBMt//Fw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gkGCjJOhebfvFcEnFsGKOWf1Wya0jV1GJdYtI2ZK2QA=;
 b=ew9Dm8tvJDNyIEYD5och7igolydk4wT4GZdIQ9qvgot4Q9qHAnhhhltQwoTC1AxgKOyA9XqPgtzeKZrP6I39/tpMeJ181qLQh22Ct4fqy8nTHK6X1eXxieMlRd/l0Gmba2LdMCCoNcb/AqY0PyNRrixrm/I+oRp6ToYb3/bt6QyNzwK82z0XFp+7qy6YYx2aBg+XuNVrS8V7kZD4MO3g8/DQF9B7VTOxJMSki38HAEsb2Kz8i1PwPBNaFkkRhTZ1aqFliVu9IltLtk/IlSbMLBrbmsdDGabSUWSUqXFt9aiHZcsTcckPd8nLgQI4nkptYWYvIErArOZtsVdJMuQ6XQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gkGCjJOhebfvFcEnFsGKOWf1Wya0jV1GJdYtI2ZK2QA=;
 b=Qa+NsdLJsOmnMnv8EnEQJUaD3ZvSL9WeLeNDJv05xFSG02WZOfFxU3j8sAMPbKyTntJKn3uInrepm1j6cjUW1wKk0tzxMuDkypT6U5+VNF7CaJwmaq6F28vJ8jMkr9bUiwQ4NVVn9ZxH/wNaDWe2HruCvwWpGOFQQWfhzzvshT8=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CH2PR10MB4136.namprd10.prod.outlook.com
 (2603:10b6:610:7f::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Fri, 18 Feb
 2022 15:27:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::2c3d:92b5:42b3:c1c5%3]) with mapi id 15.20.4975.019; Fri, 18 Feb 2022
 15:27:42 +0000
Date:   Fri, 18 Feb 2022 18:27:30 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Joseph CHAMG <josright123@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH net-next] net: dm9051: Fix use after free in dm9051_loop_tx()
Message-ID: <20220218152730.GA4299@kili>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: ZR0P278CA0117.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:20::14) To MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2907ff3f-7501-4902-f04b-08d9f2f3349b
X-MS-TrafficTypeDiagnostic: CH2PR10MB4136:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB41363CBD14F67AA0148BE7478E379@CH2PR10MB4136.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:346;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PJmeVhVNYhqo0Xz6JcWwngq/ZTCYP4hGfxneIAYG61EXm0b5/axclK+whrsQhVVYfuogNz/N3VkP5mdizikRmEX7UlsJ5ZQsKNPVAUcJKQFocqp7Haay+QpADeKO7Kin4u4Rm/Wf5cgpzax1j0YALtp8uT8aJn34tSZVgXg4Ubgr30D/VvdhCe6Pi6alawO8ZoZNgfUDXqBzsJvrkFO368hjDuckrnWceUbSWj3rPD43CDMN8oqQs2JEfl0tDBD/6/Ve6lTLN/noWKFnTe9+gOqFsFvavkkYGX+zM+Wmeug5S+mRGqV7ZN4uXqIC+fQDCudl8NNScG2lsFeBrbgkNL7Fdi9Zzebp27h7I7J0WBE60sdAGPNo7DJkA53cctIL7vBrJ7xOJ7XSV40w0BwsGCL33LAMSmfFa7p5jeyZcQ1QXUwmVumxRLkzxDrz9TEHT/Io2crK1cK3x5c/uAJ26GFaY7x2CZzXxUxjRjXWVwwYSCmTgevoXJDa2/EUg9ezEiFN61Zu2WFG1LrNstZ7Qlo6+VehNE4JWcbJIuLP2tjX3u/zltyTn0JdwnjuiM/MH4PYRw9QDyh0ThhigmmDgJ1Vr1gTqMx5Ew6h2BQxeCeAZhpVTl8cBRxh7SszW4A+CZI7CE8ENcMKspLrs790JHVqR8sSucZ0/HYwIxWsLKhinA7G2xSHQo9WxAytO1mm4bmzgdI/hji5CW1AEruT4Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(366004)(110136005)(44832011)(38350700002)(38100700002)(33716001)(4744005)(83380400001)(66946007)(26005)(186003)(6486002)(6512007)(66556008)(508600001)(1076003)(66476007)(9686003)(8936002)(6666004)(2906002)(5660300002)(33656002)(52116002)(316002)(4326008)(86362001)(6506007)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S0Ur+zuIj8kxkkEgTV/JlEwT0NjYfdfDs4/mv/bZnKjIpExZs6iCStAV9xZ/?=
 =?us-ascii?Q?33sQS8u6+Tc9plocEbl4YtjXCqolmC4TaRW8l+yxYL88aSchx+/a/SsOLEcJ?=
 =?us-ascii?Q?s+yjZE/UJ7isMsfS2Pw+do/bZ9ia8pAXORP8sptyyky+0m2zMelaR9CCDOgj?=
 =?us-ascii?Q?Sz/CXgxwBpEMwGXycLOSnXX4BKlrWteH3zNwBnH6r3Sa2twa7yI8xnWrxvwQ?=
 =?us-ascii?Q?B/7vcErUmzwbh82Oi1iEVjYXWbBW7z3YchFXHnxtZRAc0Xkos3MSSnCZs1ME?=
 =?us-ascii?Q?HOfflqRsDpfWau2bYZ2WLLPEThyzXdZTpr2i05dhIqNwn61NL2J01HeXAS34?=
 =?us-ascii?Q?VyCjFNIAcraPSbYGE002gxrl4R0Tf2ue7FSWYPlAiLSfe+aABojvYypQOwrq?=
 =?us-ascii?Q?m8jKHq27fCaIY8oWA2jVNIGmhshjuiD2U3t8gMDmrai2dw/Yl92qEvSas//E?=
 =?us-ascii?Q?N9dx2KLsZ3rKmDmuw8SPDOxsdybMObMmnkE3fD+iq9C2EkFlrcA+NUjHCnK0?=
 =?us-ascii?Q?ZzsmJNIIwn6rVRuhfUHL1wygj3O1FJZGFTU2YFK0HwT9bCbrNhrKFUho/5JK?=
 =?us-ascii?Q?u35dPl71FjHm1qC8C5y1ESquzZZEsOTmWXXW8SsRDEk2xTHyKXk1NFO9VpiN?=
 =?us-ascii?Q?Oz2eawmO7eQdycdbDmUM+Nq1GZmioP0vp4vvfW9b7565FXs1kfj7OT6cRd9f?=
 =?us-ascii?Q?yuxFBf+Fefei/4+ATK9NEpRljGcZguW56uGilnAr63rD64PmaF+/0jOrRLwf?=
 =?us-ascii?Q?f7wRBrRKXT75Ea3h3JRYn0uCbAYMH4IIfFnc+MKDqEYmhlruJY9gxlwTHA6R?=
 =?us-ascii?Q?zLDo2qor+Nkt/s/wvoJKSQiAfr3FwGZAz0ECJaKH2toZswCarNyK0RfAzE5P?=
 =?us-ascii?Q?FxT5DhWaGOKxxFU6xepxMjrXgW1TJWp6t36H0d03zC1lbU18QDaUbohPyQQz?=
 =?us-ascii?Q?RtzLsAfiRFLs0Uo6oQB3NfIPikzPmEaxHTl//aFAUaqJYXF/mlIRQV6RWMjK?=
 =?us-ascii?Q?Tugv4igvZQetfCq9G8a5WqKhD36qg5RKOQTP3YSiaPOFGvu7SUpBsQQ2o9kJ?=
 =?us-ascii?Q?tVeZabCbd+T/AsULMabkO+0lSOYIjvYlmp6DBtrdEidAG1cTC8NIJEpjKrh/?=
 =?us-ascii?Q?xnNPBV7yfigl34A7RMtastDZLMYAWSK/ntceHgO5xS9CJlXb4F1Of7prF1Gs?=
 =?us-ascii?Q?kDkUk2eLQ2+be3STg7FqIApUPp8kG+tCd+jX1RQQ6HOSfsi/fKZbjhV5X75g?=
 =?us-ascii?Q?DeYPoHuQ4nw2/I389odm4fuoHZiLXCv+Zb0+q/3qH9Z904dSbP+T0w3kyaU/?=
 =?us-ascii?Q?cG6jo2ntmuhAKSsWO4eJtZAhv2UOpvMfSi8NYA9OA1Uo0vq1lXaCdQBgKsul?=
 =?us-ascii?Q?5uTfjdJcn32Hq33DuZubrX/VEl12HtMXQ/PHQDgLRn7g9O9Udryf/TsaS5yu?=
 =?us-ascii?Q?Xdn3SMyt9cdw/+E192M/8/LhtxDpWKTQa/Tb+PzLusAXsNjH/w5jAb8/hc1+?=
 =?us-ascii?Q?CwkXxRwEnlqGWktts9JElC7mCCNNb2xnJVEI13jGofBnyqyI3NxHTEOxRczx?=
 =?us-ascii?Q?w3nVLMYGfjfxHz/rHtWwT5sVj1IEOpE3mkx+xWYdZlwDtTnIiF4siZPW0Vn6?=
 =?us-ascii?Q?fsd3yvVXlZZGyYyNauIjFEet3GB5Qg4tUrVvIz9AvZlh+14PUgJfzoPp9pey?=
 =?us-ascii?Q?VeYvIw=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2907ff3f-7501-4902-f04b-08d9f2f3349b
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 15:27:42.6057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zIjeyGs+q+sCoGIyT/wWIi6fGS4uAfBDnTLUdvY7hkiN9quTN4KeGGjLyOk9E/ofX1uHzpGB5zlEBqvOXyarK+UqImJVhCj4cgqMCyuq7f8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4136
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10261 signatures=677564
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 malwarescore=0 mlxscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2201110000 definitions=main-2202180099
X-Proofpoint-ORIG-GUID: o5LvPIj7SF5ZB6bBN02DDThio3_wpeIS
X-Proofpoint-GUID: o5LvPIj7SF5ZB6bBN02DDThio3_wpeIS
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This code dereferences "skb" after calling dev_kfree_skb().

Fixes: 2dc95a4d30ed ("net: Add dm9051 driver")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
 drivers/net/ethernet/davicom/dm9051.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/davicom/dm9051.c b/drivers/net/ethernet/davicom/dm9051.c
index a63d17e669a0..f6b5d2becf5e 100644
--- a/drivers/net/ethernet/davicom/dm9051.c
+++ b/drivers/net/ethernet/davicom/dm9051.c
@@ -850,13 +850,13 @@ static int dm9051_loop_tx(struct board_info *db)
 		if (skb) {
 			ntx++;
 			ret = dm9051_single_tx(db, skb->data, skb->len);
+			ndev->stats.tx_bytes += skb->len;
+			ndev->stats.tx_packets++;
 			dev_kfree_skb(skb);
 			if (ret < 0) {
 				db->bc.tx_err_counter++;
 				return 0;
 			}
-			ndev->stats.tx_bytes += skb->len;
-			ndev->stats.tx_packets++;
 		}
 
 		if (netif_queue_stopped(ndev) &&
-- 
2.20.1

