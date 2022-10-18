Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6402602B48
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229983AbiJRMId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:08:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230350AbiJRMIA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:08:00 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2049.outbound.protection.outlook.com [40.107.95.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0870387689
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jxmrwyrBrCtRPipGiw69OYRLm47DkT3mbnzfEb+wefpp21TOtoMbL0BP+igFvgolwFfNb46PggeCjSDeV3JwO1bSeBlLaphtJXTeb3QsWLOMoaJIkqhzhS8/WuNslfpCadr/fYEMFFmAxyWhXshnEHz44iwd3ECWC32C/pMqwzNm0Fok+OZ7LlsRvdMs2qJHLZgJnSsHWJ5Uzpci2UOFlbwHx4b15pUxZ9APn3epWMg0URalZwSQO6NUgtOKocfBi1Esql2gR0OZOz2YYOPm415FZ1jEru9yhQ8U+M6y49VklXutV49X2UsKep8f3mHy/vpE9QQ53ibyNOaWz0+i/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7o9ezan9THZ2nqmsakEOs6aUVh9SWZaggXZkhPHfGwA=;
 b=OVZQrRhbeB2fmmeG+hQx6IQs1Us03U+09imVnpLO9g8NTYXYimgRsVk00nRibHt/VluiRjwHg//FnRgguKjgTfTUI8xzL7d939bi3hRRAi1RhkjB1VEEZsEf8JlIMH5f8oUSPMPxqIYWqpnXqbDOzZvzdrS705JscfXTE0wH9C5foLdYftUN5IKn1buRbMi3xNHbfZPobsmA3qJNlTJxzlHOYSaRBo98YBCNqtQf8Qu44jSbYOFlVZmiPRXpaAwANBQV65miEETQNKcxyRgZvD6VoYNpa8gZLvKH51kDbobSQdEYlJyk1f6NoAX2re1+47GquTTHr7XB4aiwveU+2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7o9ezan9THZ2nqmsakEOs6aUVh9SWZaggXZkhPHfGwA=;
 b=HCJfQmzN0dHq0rFUuGmHZSvqNQi28ESBMpTp/aqBRYN+0JXbSgjDcpgI8q/kg8u8HjlthJkBJym9gDN+r2hFrY0Lc8u8a16tv8YOz4TLbcUmCTEImpcrd5+fjhSbYLwrHySh9KXNmPEqtOHp1O7RVbTEVo+4x7CUFnxUnaqPSMLBQEMCuQaUGqgrq4SGRZ7KOQeUhSk6KbInQMEOO8dIf55iXHQt8qztYQTYRB00ydjXjq55xJdKyk9q9NC7qD3bsfOVy3+Ko1L7BBo9tZwtIp4nRIhq6BajxWCJ8YYTckn070pbhR6DRT6tAlnS4JlPCZS5JdDb9bZqm8AZwIWSsg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 12:06:46 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:06:46 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 14/19] bridge: mcast: Add a flag for user installed source entries
Date:   Tue, 18 Oct 2022 15:04:15 +0300
Message-Id: <20221018120420.561846-15-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR04CA0122.eurprd04.prod.outlook.com
 (2603:10a6:803:f0::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a39440f-d762-4950-32f2-08dab1013a8e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OCVm5M2jhA0GgD9B5E5Cwe/gNdDOEUa3maFJqE8V/NLkj+wCYzJf4TeoaozTwR1Je4g8S6XMuSINwYg52peXxBnYGOCHVoKFhDk0Tn0ug5ScvccM7TnSyuO/iE+8xM+OI+Wqo09RnGcdn3PFl6vy4Iy2NtO1m7db+bvI5r1Z8XgkGyZ/2kCi4rDz2qGXgK6GHtWtGI7ejtHHxsfZJQo0X72V0aAaqMN+0muBOwHrt8ympo2B5bDBmg9M+9cExGSSzwj6jSESI4ktzYnyNfVSb9+XsBXi/vdgwLWct+7q1o57UeqotZm1VsyS1G7TKphfdIibRUd3aS7CY0j6mShs/JEgiTUqu4wzdOKnsFZFL9Wwxt6rpLHrHYJCQecPCIFUht6VuDlgItbD3c2K0HoFINFiABVwl6RMPzXIv3TQdpH9zMlaJnyg+jxwy6VLY5Le8FQMACPJEqgT5iiZkwLBYdmXqr5VSl0DmbA6dpbkf2VsjguibuvuY84/oZXRxYPshWCOrF1cahc0qp2l0S1LgtS++jbfEe1CgKfIYFCsKVbPhML07ifBncO5E1AEgaGEeAwjP/nnmQnOKX4NuI1606P+DQjJX+xujgiH3W5Wa6VoV3/cKu7f/1dsrwVp5OEYDUjjX4ZnxbTPQbjaAhocC/YjfrZLREal27+ZS3/msGODDoK2FEqRnWG6WiC0ifIpM2G3sn7vH+ckENxiTqmGNg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(36756003)(2906002)(8936002)(86362001)(4326008)(5660300002)(107886003)(6512007)(6666004)(26005)(41300700001)(186003)(2616005)(1076003)(478600001)(8676002)(6486002)(66946007)(83380400001)(66476007)(66556008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?xwiW5blfEW6jyUOh+cKPyF5TL5clmvYH3KtGQAWlK7iDlu52ZxpK9rgd8vvE?=
 =?us-ascii?Q?m1UnOIPgUAcF7rn0GuwPvl+4mSjUnMumnzmH1sHPlVqNkjxrWuXzavxMsH7E?=
 =?us-ascii?Q?GTYszL5++oUrSpSy88hXcEzKoduGrpzKcChVgKqc9p3bzLyysDHT4sIeX5kt?=
 =?us-ascii?Q?E7dwg4Q/7ZnHDBNP/HXzpddoR/cNg8/E3VLx/FiSmfTOA/Bqvt0Glwf0hWxP?=
 =?us-ascii?Q?mWnBhjDUf320tfVU9kYWYFOuaB+tcokLOAL9Q2NYkDyDpBjJTzQdKKb5gJO2?=
 =?us-ascii?Q?E9ykGhBkInKZAIB6stdNUY1JDWULFeA8l7DGY64g/BlmbIsC8QpuXaK6X9Hi?=
 =?us-ascii?Q?9avjURxNJytyeqDwXRNDz6TXLaHQCoI7rFtEyUzZRF/FWnA4N1+pcsMQf/g1?=
 =?us-ascii?Q?YMze6CSdhmJa1MpdCWAmOIgiFHk8NCTG9lNp6FdVR9k4Tnhwyh/rsn8CfW0E?=
 =?us-ascii?Q?SMNyT+aXG2uM2BxTQjq7s5K3yB/xNns9QBc2LEWZSfjYyWvkdGET3tWKcO0D?=
 =?us-ascii?Q?jJRjuSJwg4zjJJl3WcDTzWSQOx9jPsGIg/FwBgvakG2QfDSji6kbSPz7fQwr?=
 =?us-ascii?Q?37RnLTs9P1ZN3iTc/okOeMF/Zp44kl3eMKqanltbmXhVfh+4tbCryvj92aym?=
 =?us-ascii?Q?jzEYA4igtg5tnQVz+W01c/BgJ3fXCVUUxT02hokmJAk/nGVAJOV9b12CpXUF?=
 =?us-ascii?Q?P/nnKbXfs9KzXQdqVP0M9Inj3himokB/f/+GEMgwIQDJ18C2qw/dwbu+0Sm+?=
 =?us-ascii?Q?HYYgE52FfJ5X2Tiim5QpRwAIoQMETcg0cRUQanvonmaGWnT+DEEiDtKtmTcb?=
 =?us-ascii?Q?bqGrTjfjn1eqBIS8STdJUbewozIhs06FILhl9DInYgx/UIz3GsVXAyetsHyn?=
 =?us-ascii?Q?FZqDWefk6H/9YlJ093JlJttTKRoROkY38vbDmpBQDCxpg1GfIpwQsJ1sNui7?=
 =?us-ascii?Q?gKL+49FB/mFJtnmDdZfatjcSeq/0RDNy+dfvkfxN81BH0bM/8C7o7zIdsQ5u?=
 =?us-ascii?Q?ZSNZtpb5kGLHsvqmFIHyyVgb5iPA+DcuZU4MpjPRTxzEHYzgtYDZHYE+P5A9?=
 =?us-ascii?Q?10uU6okFKg0IK2ck3lNRkfKGBonkBmVurlUcRncSRraTKFkgXT2b06MvpX+e?=
 =?us-ascii?Q?Zccf5EJ87pL4Qc8fbYPLM1jk34nSiHRkpK3KQGr/ECGOjr3wddJRjjk+sRPi?=
 =?us-ascii?Q?bqWT1TfapQ5MaVDqApybUCEOIn5IFTZwYvfwtSV75cOw2ABXrhb0H1tnmzal?=
 =?us-ascii?Q?AIq3lHOJZge4hzk5PK4BFJ200/b309k+r8C4WAT71kMceJgyLvq3i9oljvl4?=
 =?us-ascii?Q?TyWQBCcR0qKhvP0Npg0K8dat9JKajOot4R4dAVPA0prUzJJRQkqjdnmllxmv?=
 =?us-ascii?Q?GvM/MW3pmhqvIP7D4IgFvHAZa3KFwpWEhsHJULuZUkw5ae5g7rVTvOSyllW5?=
 =?us-ascii?Q?0ij/gE4ifC5yFXBcmxORx/vZXfp27iddPYLLNNQhp0Ec1kDZeLtRgkPFcLyM?=
 =?us-ascii?Q?usTVdB6fEzdcHWsL5kSamLgNtsFPS5q+fqTM+YCoRXoHe4CUnFEFSMRdWguF?=
 =?us-ascii?Q?q4c7NOLfC3MjzQVCiWmySQKmU8K3CDLUOVu6ySbt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a39440f-d762-4950-32f2-08dab1013a8e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:06:46.4171
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: bAAIQxScQLsDlK+Rz8iUQ4JdRK7IUNfBnUB/5Kfh3efl96h10LMQkxEZax7T1gUIxh67XYyZF0Uc/OR37IEvJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB6696
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are a few places where the bridge driver differentiates between
(S, G) entries installed by the kernel (in response to Membership
Reports) and those installed by user space. One of them is when deleting
an (S, G) entry corresponding to a source entry that is being deleted.

While user space cannot currently add a source entry to a (*, G), it can
add an (S, G) entry that later corresponds to a source entry created by
the reception of a Membership Report. If this source entry is later
deleted because its source timer expired or because the (*, G) entry is
being deleted, the bridge driver will not delete the corresponding (S,
G) entry if it was added by user space as permanent.

This is going to be a problem when the ability to install a (*, G) with
a source list is exposed to user space. In this case, when user space
installs the (*, G) as permanent, then all the (S, G) entries
corresponding to its source list will also be installed as permanent.
When user space deletes the (*, G), all the source entries will be
deleted and the expectation is that the corresponding (S, G) entries
will be deleted as well.

Solve this by introducing a new source entry flag denoting that the
entry was installed by user space. When the entry is deleted, delete the
corresponding (S, G) entry even if it was installed by user space as
permanent, as the flag tells us that it was installed in response to the
source entry being created.

The flag will be set in a subsequent patch where source entries are
created in response to user requests.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 net/bridge/br_multicast.c | 3 ++-
 net/bridge/br_private.h   | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_multicast.c b/net/bridge/br_multicast.c
index 14f72d11f4a2..5d2dd114c54c 100644
--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -552,7 +552,8 @@ static void br_multicast_fwd_src_remove(struct net_bridge_group_src *src,
 			continue;
 
 		if (p->rt_protocol != RTPROT_KERNEL &&
-		    (p->flags & MDB_PG_FLAGS_PERMANENT))
+		    (p->flags & MDB_PG_FLAGS_PERMANENT) &&
+		    !(src->flags & BR_SGRP_F_USER_ADDED))
 			break;
 
 		if (fastleave)
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 2aa453ea04f9..6879d2e1128f 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -299,6 +299,7 @@ struct net_bridge_fdb_flush_desc {
 #define BR_SGRP_F_DELETE	BIT(0)
 #define BR_SGRP_F_SEND		BIT(1)
 #define BR_SGRP_F_INSTALLED	BIT(2)
+#define BR_SGRP_F_USER_ADDED	BIT(3)
 
 struct net_bridge_mcast_gc {
 	struct hlist_node		gc_node;
-- 
2.37.3

