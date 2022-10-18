Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5EE2602B4B
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 14:08:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbiJRMIw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 08:08:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbiJRMIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 08:08:31 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2088.outbound.protection.outlook.com [40.107.212.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F143BCBB5
        for <netdev@vger.kernel.org>; Tue, 18 Oct 2022 05:08:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GVOBqeygWvJJYdHOQ59iWL1RpzSvFePueJRDxy6YwXdkAXf8Jrjgdn74yzKx6mIpw8KWe1FdU3P5zUX0MvwzVAanLivmvh84EG3eG8DeEEDNpRuDwvGlLqVMlu0gtuGVEV+2JkrGMp6VNVXUu8V53DaV7BYM8Mi+TCEkgAdQ6sgsNI6Sj+5OFNgZhbPHQOqMxuyPhzMvOwRVpz3kDnL06VCAYolsk+PVkW2FOZ3rhNz6D152NkRBHRB7hU0kbbvSZkb8DCOAMtiNm1PcTe+t5Qr2oVwrMYmD/AYVyaeXnPZnHfhUjohOhiVIXnyK65JWgkfPnrFiVYEZOw56QUhJdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lWd4gmYMWTJNIY6UR/Q82q/yeeGIVgy1sy8lW2yc3Gk=;
 b=bp3pC2ppmlH6s2LbMTIhBb0tkHmvKY3BbjeL6iKX8bZ/WTpP+xN/lLj4qtL4emZcX4WY+VCvfMEdYiU57lKRXV60F4Ty5DU1r2GrV8JvMPjljn7mi7qYxAyJDtkUk62uqL66YmM6klyjKXGTF0LogCCIuG73u0Px+RMAxwal2e/eawV98iU4J2VstQ91ToU5nHunRYp/y2+cXJwjBPPkOMYJLRe14IWAQsF0uHh9SrBXszHJeJMyphlLpHPA7yBLjoPl+xz3jq/qGNzBkan2r9rPlXSAUnbGnpDiVM8cpotzcnIpmTrssqLHAQkuae5ynXaxJggHAIiyFkCwy7F96Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lWd4gmYMWTJNIY6UR/Q82q/yeeGIVgy1sy8lW2yc3Gk=;
 b=HVYKLkMk5iNUQ11YWiNzWzf/W86DTqjoAZ4NqdO1LLQl/V4eT/rIGuFmgu88oy4XvzBD9im+Z4pVovsDRRO3OR6XYGPt9sVy3tYetqjr7FgFX98WxNqKJrB2q33vQ1ShRtdueP1a78NnjvPWMGvxQosL2GbVA0cgua/18Ns8BkGnbhN+uXtQaezYhrysIy+rjWVIFxDbmQ+nl7KKsRMGyR87jj73n5ENhZyvUKjXH88q2dE0iC94Al595YtCcPT54P/Tlju2a8RAAiXuBrvD3pw/YezKen1ZYE5lfwdmsNKS4KNpu2B9dT3Z7Uw6q3cMbiuhKdqifAbsFqEdspqtjA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH7PR12MB6696.namprd12.prod.outlook.com (2603:10b6:510:1b3::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Tue, 18 Oct
 2022 12:07:19 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5723.033; Tue, 18 Oct 2022
 12:07:19 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 18/19] bridge: mcast: Allow user space to specify MDB entry routing protocol
Date:   Tue, 18 Oct 2022 15:04:19 +0300
Message-Id: <20221018120420.561846-19-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221018120420.561846-1-idosch@nvidia.com>
References: <20221018120420.561846-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0157.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH7PR12MB6696:EE_
X-MS-Office365-Filtering-Correlation-Id: 15d13cb5-420d-49f2-a3f5-08dab1014e08
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ba91FNS4nS2AbyC3enC0mOo+P6RGjM+VYMjfcV3+8ygknZNmM+Im7HkhQlSQvyveYWLON879sPYzncsHVndaXyOWa6oyGiLJoTtgiSpz1/EP5MBj529bJJG4eHdbmfmfJz83bNrgpp5s4YaRwfTltr0dXSFpRs2vLppNlMVIc+/eDZ1kBb6HE/cqS1xiM0rE8s85V0B0AWwIZeshgYUwQysORQ5H0FYBfWET+Idiw+V0/w2c6GnHojCXPF/rdhobuDi7vm/TL6+OSImBEdzZsPCAO34Z37pb0UqtSWYIbChSteRo/XHr3Yr2WoGdrAZ8EiPK3gsSwys1a6l64gprmNWpmUPzfzlCWw0YXYIDi+59lGHTUzL/U97BDBJvxrz3XYp3MRBo6OEGcm6ehvcAJRPsv4PCZF/axeE53YX9nnepABERmaJpceBI2gG6i4W2yvolIU+xeV7KhMRDHsIj51aYuh0w2h12lFjWNgnTGSIsJmnIPDUlcRAeQX4Kkm43kfqLDVvNcAmHDykxsJawYwX6CP+WOoHygFvv8nhcOtllI/2kWC/UU8n4d1eYtsChBNVRRuieSt9yY3g5SEYAGZP78z7MhDheMMzvsweq1+samuSA5sbRMRt6HTA3ljguscJo7pXQqEMNaB6c1b5j5NGUZ2bDnkKycOE1e7m7i76hng0xLcUYoe0aPw+sO85ZVqGkaMkARy1Eroc7es9c+A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(39860400002)(396003)(136003)(366004)(376002)(451199015)(6506007)(36756003)(2906002)(8936002)(86362001)(4326008)(5660300002)(107886003)(6512007)(26005)(41300700001)(186003)(2616005)(1076003)(478600001)(8676002)(6486002)(66946007)(83380400001)(66476007)(66556008)(38100700002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?5bmyy7g4sj+WU0vIEh5N1JqMTS8IZak/IS6yygZgDqLDhNN/aOhor5SNPhnU?=
 =?us-ascii?Q?iDukXnlznnyKkqfhtsPMzyG5R7bW9f6zrH3kaOKtnuwMAP9/jKOt08Gg6iBz?=
 =?us-ascii?Q?wHErHZS3Cn0JBow5VueH73CUGDGqAHq/I0vJPqm9hC2fZ3+wnySMV2BaVKUl?=
 =?us-ascii?Q?/cUeYSo9aZ55N6uoj3MMbovQZ1JNtaSOVIDZd8tX5tlYABEFmienhKhedfbP?=
 =?us-ascii?Q?ow+wwsjwoURtw4xSRtINupzLkZyZ80WTsVyBAIR6DWdwHM/uYQnspTxjOgER?=
 =?us-ascii?Q?v1huBqYi2AylkDKkE+z2d8e3o03Ivoev9VWXeyP1szGfGqzlb6XYclbg0iv7?=
 =?us-ascii?Q?GcYjOIs5uEXx+Fc7xhQWsEeW1Q+6h5o6jGkF4Skmj5lm2RoPEYTCfyJVYB87?=
 =?us-ascii?Q?OgNPbZ/5G7A2XXnSzLQjanNcTnj3QO/iK+w4hieUUx7a7I9K8FM8zSqoJBF/?=
 =?us-ascii?Q?hxZH860jp+j7agA682S1cdH/+n7HRSwwUcLF27N19bnotJotJ+bUCBoL1v2U?=
 =?us-ascii?Q?2PVT+gdXroXXe8CoJW04z5EOwwnudHeXHlukwanmBl5KsOUx9PQZ/JALradc?=
 =?us-ascii?Q?AW59SE3ZnCAgE3N4LS4o+vYNNbE16j2Q5bSM5/fxGxwPgCQFrfx/ujMPS59U?=
 =?us-ascii?Q?1WTz+pA2gP73O1SNqdXfHinx73+v+mnm4VmF5147IVEqHnXj9XW91BnIjVFe?=
 =?us-ascii?Q?bB/s+cKN/XkwTvNWJLw5rIxMsom6Bgf//GAXSLIByXnLAMj7pne+bnuoER41?=
 =?us-ascii?Q?VWaWI4cIhrENbs4S8mWbkFvm13LxgrHiyxY9ldy1Y74NWAHjUBkEUt/NPIPW?=
 =?us-ascii?Q?IWXxczHSMKvtV/WgJsxRqmDQKjODjoYKb6Jh33ddp/FKFvQ9uP52tFXPl5Ma?=
 =?us-ascii?Q?HpQETUUYkhNK0ARz5mY5/VFWlW2WZmJ4GAT/8bg4IIUGuWn4QQBpiW1jo9fT?=
 =?us-ascii?Q?H6QDjvcizrVxz0q63kXxLgAJ43ur5ijm1DLWEXtYVlkGpwycXw0CIM3fY4Pt?=
 =?us-ascii?Q?sigAfhQpThBDzUaRlz5O/VR7y790rYdVhjwiPbeM+HWHHvqiquc2jgzPo9+c?=
 =?us-ascii?Q?YA+AZ2qcemk20e9JRsV7jZUidf4GxpbBKB56fFG83ip6wnYY5YN7NFN1KWui?=
 =?us-ascii?Q?O+nzBKAK0DKS+4pN6NVc5DwYf/J6ZEDL19OCqAjJDkP4+e2mvV9xepLNpcJ7?=
 =?us-ascii?Q?9vCp19s4q/0AKELvliOqc6WW+pFLY3LX9dsKAhgj2akZi4UJbIusBLEq2E/p?=
 =?us-ascii?Q?BJH6e4s/3uJyB7h5Zwgu78vwwHwNuT+0Tp6qbIQR565dCqPNuyNsjqur3bOB?=
 =?us-ascii?Q?wFvDBCeqr5adbJ3Gre8LtoMnN8T2XyQbf406osKozvi3t/Lta5BqISa0DVPh?=
 =?us-ascii?Q?oaccZt3aHH2V9IYW0Q2QA9qclBXkyvctLEG+OXMUH3YKKC1FoP0ZG5ENqczB?=
 =?us-ascii?Q?xNOymhIzp6LpPfrDrX0740aWL2ZMUMzOLZ2w/i8RHJuflmCfKzDbapbjThxv?=
 =?us-ascii?Q?/rXBvzIlo7yoNEMlk9uh/OZFDijt+EF6sab+2EY3tETLU3ZsQvDizn0k5Y9A?=
 =?us-ascii?Q?BYx+7/pLDBcwWHYKOxHj8/gx+0RNECbiFiQEBW99?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15d13cb5-420d-49f2-a3f5-08dab1014e08
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Oct 2022 12:07:18.9556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: RAt4TfohF66J6f+fSGrU8elb1N/Hr5/maTxk5cjePorN3hS0B8KIVGF+S8EtQGk//ZQMpdsRe3/nX9nPZ5D9Fw==
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

Add the 'MDBE_ATTR_RTPORT' attribute to allow user space to specify the
routing protocol of the MDB port group entry. Enforce a minimum value of
'RTPROT_STATIC' to prevent user space from using protocol values that
should only be set by the kernel (e.g., 'RTPROT_KERNEL'). Maintain
backward compatibility by defaulting to 'RTPROT_STATIC'.

The protocol is already visible to user space in RTM_NEWMDB responses
and notifications via the 'MDBA_MDB_EATTR_RTPROT' attribute.

The routing protocol allows a routing daemon to distinguish between
entries configured by it and those configured by the administrator. Once
MDB flush is supported, the protocol can be used as a criterion
according to which the flush is performed.

Examples:

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto kernel
 Error: integer out of range.

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 permanent proto static

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent proto zebra

 # bridge mdb add dev br0 port dummy10 grp 239.1.1.2 permanent source_list 198.51.100.1,198.51.100.2 filter_mode include proto 250

 # bridge -d mdb show
 dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.2 permanent filter_mode include proto 250
 dev br0 port dummy10 grp 239.1.1.2 src 198.51.100.1 permanent filter_mode include proto 250
 dev br0 port dummy10 grp 239.1.1.2 permanent filter_mode include source_list 198.51.100.2/0.00,198.51.100.1/0.00 proto 250
 dev br0 port dummy10 grp 239.1.1.1 src 192.0.2.1 permanent filter_mode include proto zebra
 dev br0 port dummy10 grp 239.1.1.1 permanent filter_mode exclude proto static

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 include/uapi/linux/if_bridge.h |  1 +
 net/bridge/br_mdb.c            | 10 ++++++++--
 net/bridge/br_private.h        |  1 +
 3 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/if_bridge.h b/include/uapi/linux/if_bridge.h
index 0d9fe73fc48c..d9de241d90f9 100644
--- a/include/uapi/linux/if_bridge.h
+++ b/include/uapi/linux/if_bridge.h
@@ -725,6 +725,7 @@ enum {
 	MDBE_ATTR_SOURCE,
 	MDBE_ATTR_SRC_LIST,
 	MDBE_ATTR_GROUP_MODE,
+	MDBE_ATTR_RTPROT,
 	__MDBE_ATTR_MAX,
 };
 #define MDBE_ATTR_MAX (__MDBE_ATTR_MAX - 1)
diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 909b0fb49a0c..7ee6d383ad07 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -682,6 +682,7 @@ static const struct nla_policy br_mdbe_attrs_pol[MDBE_ATTR_MAX + 1] = {
 	[MDBE_ATTR_GROUP_MODE] = NLA_POLICY_RANGE(NLA_U8, MCAST_EXCLUDE,
 						  MCAST_INCLUDE),
 	[MDBE_ATTR_SRC_LIST] = NLA_POLICY_NESTED(br_mdbe_src_list_pol),
+	[MDBE_ATTR_RTPROT] = NLA_POLICY_MIN(NLA_U8, RTPROT_STATIC),
 };
 
 static bool is_valid_mdb_entry(struct br_mdb_entry *entry,
@@ -823,7 +824,7 @@ static int br_mdb_add_group_sg(struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					MCAST_INCLUDE, RTPROT_STATIC);
+					MCAST_INCLUDE, cfg->rt_protocol);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (S, G) port group");
 		return -ENOMEM;
@@ -882,6 +883,7 @@ static int br_mdb_add_group_src_fwd(struct br_mdb_config *cfg,
 	sg_cfg.group = sg_ip;
 	sg_cfg.src_entry = true;
 	sg_cfg.filter_mode = MCAST_INCLUDE;
+	sg_cfg.rt_protocol = cfg->rt_protocol;
 	return br_mdb_add_group_sg(&sg_cfg, sgmp, brmctx, flags, extack);
 }
 
@@ -983,7 +985,7 @@ static int br_mdb_add_group_star_g(struct br_mdb_config *cfg,
 	}
 
 	p = br_multicast_new_port_group(cfg->p, &cfg->group, *pp, flags, NULL,
-					cfg->filter_mode, RTPROT_STATIC);
+					cfg->filter_mode, cfg->rt_protocol);
 	if (unlikely(!p)) {
 		NL_SET_ERR_MSG_MOD(extack, "Couldn't allocate new (*, G) port group");
 		return -ENOMEM;
@@ -1191,6 +1193,9 @@ static int br_mdb_config_attrs_init(struct nlattr *set_attrs,
 		return -EINVAL;
 	}
 
+	if (mdb_attrs[MDBE_ATTR_RTPROT])
+		cfg->rt_protocol = nla_get_u8(mdb_attrs[MDBE_ATTR_RTPROT]);
+
 	return 0;
 }
 
@@ -1216,6 +1221,7 @@ static int br_mdb_config_init(struct net *net, struct sk_buff *skb,
 	memset(cfg, 0, sizeof(*cfg));
 	cfg->filter_mode = MCAST_EXCLUDE;
 	INIT_LIST_HEAD(&cfg->src_list);
+	cfg->rt_protocol = RTPROT_STATIC;
 
 	bpm = nlmsg_data(nlh);
 	if (!bpm->ifindex) {
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 0189fce6f3b7..73f0e98de33b 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -105,6 +105,7 @@ struct br_mdb_config {
 	struct br_ip			group;
 	bool				src_entry;
 	u8				filter_mode;
+	u8				rt_protocol;
 	struct list_head		src_list;
 };
 #endif
-- 
2.37.3

