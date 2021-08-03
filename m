Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C7353DE9D9
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 11:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235168AbhHCJlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 05:41:31 -0400
Received: from mail-bn8nam11on2112.outbound.protection.outlook.com ([40.107.236.112]:9697
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S235198AbhHCJlW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 05:41:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L9DSnpDpo9Rq6wScgCWEhG9r5IlAbsQbz+iBu/5++GdUbEnJIv5DcXquIE5lpoWrx2/xGi9q67ABx2r+eFudSZsBFGrp+sQlwqdTrVnMQXLJcOMKl1MBD/Jehn4a9PslsIrKqRv4BRjjR23zHnJwtJxfmLMQF0jTsRdKhRNDvMeXtamyCMSyJ1KyCF1EUtF4Z8iuneIkbaxmfYciQxnB4nprZApWjvGLFBHv/pb9akIQroeX2i6bqHNDCHN8UF3ekUjbB+Nd8SZ8qDaWrxrm0R+u4I6cKqfU009UFCfPyzTjhUcTiRWF7zdUv2ZQDlqxU6zKYa36+JwtFTJvh5UsSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAPaVgK7tNQJByjuAdRHX+oSF/DlFhYwBOZBx1GQkdw=;
 b=dtaQ830lJjIuQZ9ni3B8biwtq1QI/dHYFaW1argLnDkexyCBXnr5Qo8pu675VzjbHQBKgNi/Ogfwhd/7oHAGAPnsZIRFD2p89Zt2DxCJe82GWdbyIU5QFmTIwr7j3hdOckKBRMZGSaGySAH9nQYMBP6W3rnbfi97jq9TrxdLUylbmJIwUXXS7sjWCYwkPDtfZMklY4xFgbsIkjXDws8XT4F41xxYtbz+4XYn5lAkwCBVlqPvI0788xCXwX9wqgqmrVYVZ3ojbv6rBcr49Z9Csy6TZAR0ZoVaSq9GVVSweLmqcoUJOAdV2+TDtZvibiILAUy3bPxlUBIrjr60PA8mdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=corigine.com; dmarc=pass action=none header.from=corigine.com;
 dkim=pass header.d=corigine.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=corigine.onmicrosoft.com; s=selector2-corigine-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hAPaVgK7tNQJByjuAdRHX+oSF/DlFhYwBOZBx1GQkdw=;
 b=jFwDaVkhiTgUVhIGYxoOtlqzgnhEkJDqqClMLpmUBx8Tau28qU8tcfEPfkundo2CkvfYfsW9U+a8cx6HGqumFz7N1KdRaeVZMZP2aYQRVcOVydiI9FVFrLaFcfTyjzjB9hq1w6RiPqnQypZoma8OCUh0GhS/BvbCu0W892UHwbQ=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=corigine.com;
Received: from PH0PR13MB4842.namprd13.prod.outlook.com (2603:10b6:510:78::6)
 by PH0PR13MB4988.namprd13.prod.outlook.com (2603:10b6:510:94::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.6; Tue, 3 Aug
 2021 09:40:38 +0000
Received: from PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3]) by PH0PR13MB4842.namprd13.prod.outlook.com
 ([fe80::cd1:e3ba:77fd:f4f3%9]) with mapi id 15.20.4373.023; Tue, 3 Aug 2021
 09:40:38 +0000
From:   Simon Horman <simon.horman@corigine.com>
To:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Bijie Xu <bijie.xu@corigine.com>,
        Simon Horman <simon.horman@corigine.com>
Subject: [PATCH net-next 1/2] net: flow_offload: correct comments mismatch with code
Date:   Tue,  3 Aug 2021 11:40:18 +0200
Message-Id: <20210803094019.17291-2-simon.horman@corigine.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210803094019.17291-1-simon.horman@corigine.com>
References: <20210803094019.17291-1-simon.horman@corigine.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR08CA0009.eurprd08.prod.outlook.com
 (2603:10a6:208:d2::22) To PH0PR13MB4842.namprd13.prod.outlook.com
 (2603:10b6:510:78::6)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from madeliefje.horms.nl (2001:982:7ed1:403:201:8eff:fe22:8fea) by AM0PR08CA0009.eurprd08.prod.outlook.com (2603:10a6:208:d2::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.18 via Frontend Transport; Tue, 3 Aug 2021 09:40:36 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 898678d1-8b61-40ae-27f4-08d95662bff0
X-MS-TrafficTypeDiagnostic: PH0PR13MB4988:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR13MB49882DC8C2D6ED72112F5959E8F09@PH0PR13MB4988.namprd13.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:883;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /J6faLin9wuV6Vde5xZPwcQStdbYlv1lHzFnaAscfIfqrLhf8LFgbdB55GKYsaLdElnTMDJI+J3rgijboFSoaL16aq3s9SJyO046BMnfaW/7ow23FGfaQkg1Qkv+8qYsBU/vZ3nwv6iDsBmbjgVUHOernZAJN5UzkFqQGRfABHpOgG2qhGBhJZGbcNaSjbpDjsYg7XNvRHqc2ahalPLsb0fxsQd68v4sTLYBTCslstHOn+r0HZmaXPvu3vbBpUhkjvhGNE6FpuVoFKbnvIFRCllT0/veKgLF0q/GRLH2rrBL+Cf1nHpdNa5W2zDYZ/AV9osvDCe64/XiyutCRkvWsJP9Tl1ATNT0/YkooA/Uts9o3eWLJo3e9Rtx4sp5WBFodRsdMzhnuhMAl26a7tW2Feu7q2XkULSJR42uAa61GQrJ0tnCZpbUIPXyiR3eYbOnjAXUqyfWM0OMC0OvE432fwHSKvKQim2Q/YdleIOToqmj4XLZaV8nQoCbSZAdaziQjEHPIWpXBXnHAogNlkw79KH2lhMMLYifHrZ2XmT42hr6qWnNKAdR3QsTCOh5rqgZ/SXJEHdPoItJweWO8K4rO0t9jp4VDUY+BsF9kxBpZLPrZJA3jWapiW1EbrgTZ//AMaUVsESUFeI3AHDZj/pEEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR13MB4842.namprd13.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(366004)(346002)(396003)(136003)(110136005)(2616005)(86362001)(2906002)(316002)(8936002)(6666004)(6506007)(4326008)(44832011)(54906003)(52116002)(83380400001)(107886003)(508600001)(8676002)(66476007)(38100700002)(1076003)(66946007)(6512007)(6486002)(5660300002)(36756003)(4744005)(186003)(66556008);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?RSV95M/XIFWzFH21sQPAXozLW0sBLuE4LpB55N7SFhhSR3C2dSzvnkiwOPSW?=
 =?us-ascii?Q?NlQuVCIbZB/ku/4A+zbcTTslzM0cWmMIfWe1dSwU4eOrPJ8MzbRv+2OgBeLC?=
 =?us-ascii?Q?432n5QVif2QKSYUYlh6g3/ty0Ln2Wvmt7JSf4Ag03ufrA/tHOYTyHe93y/Zh?=
 =?us-ascii?Q?N/shy3sgHSXsArwNIGB7tbJ/6FmyFN56P34S5/yfwYOKPGxrhp/L7hNR5Rnb?=
 =?us-ascii?Q?5llbXoA3Br5hQRsfKy/eMGc1g5eZK6dmehCUlz9Kpnjmr1W4qyhEX76um1Og?=
 =?us-ascii?Q?CCGShKsPkAjleQpDeqK3D0Jj5ZYpPbCLcz9nn/PghzL1ox0io0UnZ4QjBhIg?=
 =?us-ascii?Q?F7mUT7o4pWcrSX/1TgEMp+oFUAS3pxWzF6iY43sCLHqWDky/WlR/YxmUxZGH?=
 =?us-ascii?Q?YqPiDR18KU6Z9ukjMxE/LbnAi+8U5W/3bd0R90P9TMx083Tn5WizqCjhH1nC?=
 =?us-ascii?Q?4YYkDwR80+pz1U/x+q37vSeMYTuCC+MKNAhYZpYAh2lprDRvJhVW7VBqlqIo?=
 =?us-ascii?Q?jeBZHXSocmJfZqAmXtC0sw1WQZH+VxibG1FmMHQ2m2VDGqkYwJSsm4zX0tFH?=
 =?us-ascii?Q?kKKCRr4EVMguAJDDRX2W8YAP5TVWlrbnO+uD6UprRVIbHKY4VExwdxeCWbwJ?=
 =?us-ascii?Q?XvdXPE5BkeKOnkK6wJQJnbiAVAreoptAzvF4efgtwMcn3hEnwCzKJ7kaPPg8?=
 =?us-ascii?Q?PErZ29O5NnPu9AucMjTf8q82IDPt4h+u3cujYQ6/hHagAuIcwQFi+WzfRt8S?=
 =?us-ascii?Q?m1BMpnqye55Y5Dg+8M0jOz3mAcK6MVEYNj4R5bHInU4LslOXXI2PnKO0Iqlz?=
 =?us-ascii?Q?rtG/+pfevGtQPn5IN3VrW3J5rVZVtaYpWhdXRNKnFA3zwGqm6PXW2JXmZFjb?=
 =?us-ascii?Q?86Hc1NMgoSDWt9+2i3+F59zWWUREkPK0XugWrVDK390Nb5PtsbMtr/CBiqSO?=
 =?us-ascii?Q?SAXvmKfVCOx9KLAeq/W1VgRZR5wTJa/RaT7Yt820pLH6+ku0NjsTv4/hmUpc?=
 =?us-ascii?Q?t0188r29Z2hvgaxPCFRXCF3Qan/gBYJJcwywokVjLEtpEpJ6KcWssAbsp4ka?=
 =?us-ascii?Q?kfujCAZXkxRWCBLDZcoL5sZbF/LRyWB4GaYBdhKvVrtEMYcTnIIa2KRfjonj?=
 =?us-ascii?Q?w5RGwLB/IYEkjlXBev6CC4eWGWebggxLljwR5QtNOOQDSCiRuTH4o6+YOdg9?=
 =?us-ascii?Q?0/+eT9W+qjf9L/mpuNnl9MW7eHwzX3KDtz3znNwlTwJVhsBcEJticQM13FIl?=
 =?us-ascii?Q?9zvD37BIli2KvUtsOEC6LlxKqP/bzK2wBXBOLKccSW7PMgEdfGMMXj9I9izF?=
 =?us-ascii?Q?uIdQc2XgPZsB2OsZlxzlPPs7xgr+qv9S/bBfIKCqIVET1kB7UzbCOm01UY9P?=
 =?us-ascii?Q?VyFbAJyR6ljUBmoC0RHUr0ovV+E3?=
X-OriginatorOrg: corigine.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 898678d1-8b61-40ae-27f4-08d95662bff0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR13MB4842.namprd13.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Aug 2021 09:40:37.9643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: fe128f2c-073b-4c20-818e-7246a585940c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: LggEX93SUAyKSa8G9MzrKm7JYZz+YNF7b4MMlyC1/b+UMgIDjUVgXJf/9a1mWs5PbvGWyAhR8hP2vRLQNZMozk2KqHqnBH0dIuobOmtxnIc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR13MB4988
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bijie Xu <bijie.xu@corigine.com>

Correct mismatch between the name of flow_offload_has_one_action()
and its kdoc entry.

Found using ./scripts/kernel-doc -Werror -none include/net/flow_offload.h

Signed-off-by: Bijie Xu <bijie.xu@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
---
 include/net/flow_offload.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 69c9eabf8325..f3c2841566a0 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -293,7 +293,7 @@ static inline bool flow_action_has_entries(const struct flow_action *action)
 }
 
 /**
- * flow_action_has_one_action() - check if exactly one action is present
+ * flow_offload_has_one_action() - check if exactly one action is present
  * @action: tc filter flow offload action
  *
  * Returns true if exactly one action is present.
-- 
2.20.1

