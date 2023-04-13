Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FE06E0ADD
	for <lists+netdev@lfdr.de>; Thu, 13 Apr 2023 11:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230110AbjDMJ7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 05:59:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229773AbjDMJ7O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 05:59:14 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2040.outbound.protection.outlook.com [40.107.96.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296B49027
        for <netdev@vger.kernel.org>; Thu, 13 Apr 2023 02:59:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L6Wee0VHtm8pUx5mVhb9kVGGY3iJFqbTNMBpaIyDI98Oed61TBQc1/MF8K8ZLgK4fr/yNvL8m2FXPEGvtKqWsyxOciobxzZw2t5hrYe2Gb3aiCQ1CJl9l7a3KRDmWgaQ4y7rbyNiQDs9ctMAh41FKvz/WSdO3ZvHVJwBpht3IoXJXxs4V9aE45jZlW8hh1u1jeuKXwB1Q2NnRFLxRGqYj2vbCK3r1KlIdQDxDjtMmFDbc7Q0OnIHARGKbBmOj0N8eHYGxSRVyXkb1mXRDM+AH0rXYv1NjJmJFMGi1Ur5tBBk17fFe+CFN9IzwttuMU/ZkhaQgXIwSaAMW5dNY9x96Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=skXPRlKWkSk3ULoRmhja+VCV6ct38IRkmTkeVzeQtt8=;
 b=caYeC0bgbcD4sZ1UbdiJgB5SxYutlZBFjdRKmlLyp6nH2UeX6gZsY360xF3Yf0mcnbkeuH08kKHIP77EMOKG57P/d6hya3s8KSecRq8RoI8oHYTC0c3LQtio/PR7hrAw94BcFRLQuIFEQTNLozq+d1Fnv/QWS6wXWeRPIpQfOxKb1l+W6cXq1aAyR8nCm3zIktas4k5CQwoNP3kvh+Yj1VOcSu/dSkVAeg07RJqIP2jcRHWf0zkFYsU+gk43jQWEHUAK/ZxNTRgFbNCVqCpBvP4W3C2uFKNCaLE/Zvk26jLU5uDONze+SK7HivTFa2nSV8wM3Uld5YQchdraS1b2nQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=skXPRlKWkSk3ULoRmhja+VCV6ct38IRkmTkeVzeQtt8=;
 b=R0yXcpkjnEReFt1dYor1NUAtw9ZLCs2ZgjoLqjAhpIPRCPoNje30yqY8MHLVdODnFJhjy6D+fhc+mQF70ZiH9sNFgi4LI2nK+X8ulfYEVU9soITkvLf7p8cqAq1C41ZdngPV6tOBILiC26VVPxBjXsBqcAoLfG8OJePcFxd/LaGB1ygVCyfamXXYBegy22/pjegjTrA+/acZYukX0KZMTtyf5nHyvRQtMogCxJ6q895NXEn56BTUir28OieZPxAKnTpFTQHDJCuaYC2tJK7HckjKemU8A22JjsR+MbLGnRDecWPJ2R02maYUuYgxw1Ol19eY4aAXMezisvXfd16+BA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MW6PR12MB7070.namprd12.prod.outlook.com (2603:10b6:303:238::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.38; Thu, 13 Apr
 2023 09:59:11 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6277.036; Thu, 13 Apr 2023
 09:59:11 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, razor@blackwall.org, roopa@nvidia.com,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 1/9] bridge: Reorder neighbor suppression check when flooding
Date:   Thu, 13 Apr 2023 12:58:22 +0300
Message-Id: <20230413095830.2182382-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230413095830.2182382-1-idosch@nvidia.com>
References: <20230413095830.2182382-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0109.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:33::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MW6PR12MB7070:EE_
X-MS-Office365-Filtering-Correlation-Id: d0439141-3f3b-4c40-946b-08db3c05bacd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gSj/wS5RE6lvz8AgQ5uiddfCCT5+Ry+ljNVJwFyeX/1Kcqk7o9ezMP47Rj4vENQSJ6g3gyRrhQMhXC9LC7segO5d1Lxba67m0JX8mLP71E6VulZAiCi45m+1fv5hAkKdnHr+n9QlpyWMqLxGn6nJiw+9mLMOidOU428bKf2IowBRnbKF/XBvye1U7s9tEhkNNXDffPkU9Ykl09OeViZJi1FjzxqA/SYOiZGl/PHxBq4S7+8gyA0TFdCB2HUYOmWl6XOxVHbOSTxkcsWg3JQJv4LsW7dS/jlxJTqpnh3wN8zFNM5E42Q94LrvZH7x5UEeTNPf4msvsdTecQv12SqGGTHYytcVtH2UQ4IJhPQcMe8TzWdl9c0LvS/W7pUOSpp6Uss6e0D7oM5oMy3Y7c1avhHp4Dnvuungvj+q6gR4Q5VvH2Nr2a6zO8797V26Hk/1eNsTosI9jkThjs8A1l7WVm4q+gRFFZFjN/OBM3mX+Pc5/3a3GPrm9YwW4/WymYKcO12EqW8sZHVSmfXmnIjbPPwQUVHYReGFcLUbU1W3RZtgdfwI+Omu1k32n1r8Co4N
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(346002)(376002)(136003)(396003)(451199021)(36756003)(2906002)(26005)(478600001)(8936002)(38100700002)(2616005)(6486002)(1076003)(6512007)(6506007)(83380400001)(186003)(5660300002)(86362001)(66476007)(4326008)(66946007)(8676002)(66556008)(316002)(107886003)(6666004)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/ztmXzd65vfFQ1A5QmXx3/+PFpyJCTSHU+dT8YPzB8xwOfs0PwxeuXSqwEtG?=
 =?us-ascii?Q?wUfWUQi4krLsYwEbIcX2BJ8eKQ0UPnquDSQoow1R75HY/F4HOvmgVWGPZ7kY?=
 =?us-ascii?Q?TFux0BmafmnvKtEKhmFn1DzmBck3htnWgYQ4LWqOsJ67NHxAHLGBHeuxzL9O?=
 =?us-ascii?Q?PJS3XmRh9hbo+HmKkIKzIjWgOqp2rRqmx9sVg13YR//yjlfkmC+qwOzN6d+F?=
 =?us-ascii?Q?1mgTMwXNXghWG3cL89HWEeAceQsxU0WlbulzREZ4a8z78Ftoc4J7NoyVunCH?=
 =?us-ascii?Q?vjBkbjVz39D9+heJjvZa+0LWr+GI3Qolylpj6X/vJ98PWBgR3c2uhYAiceQ+?=
 =?us-ascii?Q?4tjWAy52WjhOsyGm9hsIw6tB/X++D9FEcPUqNkOv9uaRKuuoMmTUbHKy80zx?=
 =?us-ascii?Q?W2TzayK+uJHuPAUU69AZJ8xP6E7eZUhKRuSQLmZNpNjP+S2GS3pXfX3I4H8c?=
 =?us-ascii?Q?Vrcfv0gs+SPV1Csx5MbnvvhPnDTUflY0JGmRgAWPKPQO8x2a9JQFCbUXyRyD?=
 =?us-ascii?Q?nVqtdSKxyAFQpSKBYbfV6jf77iH8MUOB4IupnNzVv/9NX0y07v/Lptmpm5z2?=
 =?us-ascii?Q?Uk/q9hLNyk3ycwdvlvZ1dCq8Y3eAcbuuRfQamYM1huyNeD2xJREM1NAbTVpv?=
 =?us-ascii?Q?66/VDvNiNyHVs07AG1L2lWQG9ctGu6+DkZdz2NwUgRKmw6KhwZV1Ug4j9xEo?=
 =?us-ascii?Q?uFfPy5zxeZ6C+6stLyjo228wEjtp5LAtvci/883JnF7iHvtRCc6K53P/g8ya?=
 =?us-ascii?Q?8uWfcVE1DokooPV02hLRvDtlqqsYOORPdidvG5pvcrOg6FaueIiL8TBVA4B8?=
 =?us-ascii?Q?2VhG4Zhg8tPTDvARTAolAY00zckcEqo07DtZ4iUR4aexkJIilj04GGUxA9nR?=
 =?us-ascii?Q?AYtlZVT+WAwrSiXh8lQfHwpxZp0hn6aXGEoVF4hO5Fp2ktynMKrVU+bX5tiC?=
 =?us-ascii?Q?tzVwH3+0kRU3Y618rW+XsRMFnvTtybJNHc4Mzp9numAPlkGV3YFxECaPGAv2?=
 =?us-ascii?Q?dQJhTlkXQob1CU7WiqDfqEpcNROG/kFIpUzufdBFpHA/Qg0JGO3fQb3N1mwZ?=
 =?us-ascii?Q?eWpYj9NvfxVVbQSIzBTaWiIKH6dnFXupXBWNwl2hv001jmGZGgl7REw2rchW?=
 =?us-ascii?Q?jXm+Fnj18UepM5TPiyMdfu5RMPoMr/Ie9NkYyL0AqPye0knmnsLJWZBBftby?=
 =?us-ascii?Q?b3pvIHCHKHg1k7+btFER2rrPMTR4mr9b93mbGPf89GxCF+OJZcCQckSkHby+?=
 =?us-ascii?Q?EufBd8zULyqzg4M7lUc/WgBwJx/RcnTjjnBajVaUU0mOfDE+Pcfipz0Qv0jB?=
 =?us-ascii?Q?CH2vplyLUvZuREvd5Hn5yYlb/cOgRMiOr155WJmUwLWoTRh8d0fd8CK3kHPy?=
 =?us-ascii?Q?StuPFU9TEa1Fvd/3n9MD8AyM9n1mBYGJxbp3vqu2b3MGxnFeDUhNslfwCtUd?=
 =?us-ascii?Q?t4lbKyfP0yLVOY16vpPlaOi9YXelQieLuHksFcxZ8kqgCcztL91zjF4TSWfk?=
 =?us-ascii?Q?VwfMOoAaYtWBZXi+twnJjANyw5pvRSRNWKnHilXdMICBIiXH9m9N/bB75Yh/?=
 =?us-ascii?Q?N9H5n15luHTOofkduYIxwhwL4AdSkm2h/x2HY+rD?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0439141-3f3b-4c40-946b-08db3c05bacd
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2023 09:59:11.0764
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +RsemPi9qeZSBlEyFa3HSXGh6snYQPAbUZn/HtsTuxZ6XquyJ0uHyrlLCYaeZ/Gw7xFA2Rx+qRBMn1jQhIPdcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB7070
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bridge does not flood ARP / NS packets for which a reply was sent to
bridge ports that have neighbor suppression enabled.

Subsequent patches are going to add per-{Port, VLAN} neighbor
suppression, which is going to make it more expensive to check whether
neighbor suppression is enabled since a VLAN lookup will be required.

Therefore, instead of unnecessarily performing this lookup for every
packet, only perform it for ARP / NS packets for which a reply was sent.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_forward.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_forward.c b/net/bridge/br_forward.c
index 02bb620d3b8d..0fe133fa214c 100644
--- a/net/bridge/br_forward.c
+++ b/net/bridge/br_forward.c
@@ -224,8 +224,8 @@ void br_flood(struct net_bridge *br, struct sk_buff *skb,
 		/* Do not flood to ports that enable proxy ARP */
 		if (p->flags & BR_PROXYARP)
 			continue;
-		if ((p->flags & (BR_PROXYARP_WIFI | BR_NEIGH_SUPPRESS)) &&
-		    BR_INPUT_SKB_CB(skb)->proxyarp_replied)
+		if (BR_INPUT_SKB_CB(skb)->proxyarp_replied &&
+		    (p->flags & (BR_PROXYARP_WIFI | BR_NEIGH_SUPPRESS)))
 			continue;
 
 		prev = maybe_deliver(prev, p, skb, local_orig);
-- 
2.37.3

