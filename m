Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812016BB419
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 14:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbjCONNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 09:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbjCONNe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 09:13:34 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2057.outbound.protection.outlook.com [40.107.93.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBDA1259D
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 06:13:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T98RQsOEk5YT0+Svdl+MyFbkxQQWBlLFddkzclK5pSIaS8Vy29+ZDLG+dmyS4V+85OlzmkEwdJzdYRA9ZYoDyeCoHZafL6/6j8WDRoc38vevCIbrB9+nQMHdHuDDleZv2zvOFSDpStOI/GyuRoVvuRF4Ut0h/sYpg7vO1KbzyyXAplYraC2nmYvgaHqH0d/SKZRTYbwqAOGKU4NXYpK1HNL3N+0fOwQm39ypkMhnvS0ogIniRwkZISBzRf7OBJaotDcAuMQw7/7a0hzrUdjNPL0YNGUeca3srUwwjUZXEwXinf29FrqGDkAi/4O74dWGWivC0TZH60KyCN3dvvgJ9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hJJ00bKN9cowIfo0FJeRugC6GOlI4jNcAkx6Orpr6D4=;
 b=RS+qe961qRocSHlL1GuETlrr4+SIRQMWxo3OoXHgC/5XuakqkxucW5Oo9U/b4t2NLg4Rf/CBbnYMd6HHtlBTH3CXIemqq9y5JdjUYfQC3kH2vYMOtTTWX2ODfSehKm3jchg9kRrXMG3xtSk9iNDFRT0k0niKLOeD0n/k6obxyf9EmjqIspBOdjsmszJKQn/BTE599BoGh3Tozpp/1VlpzKGNuHQ+2hg5BqOvLlohvKhEl16jVHktBuWIXKAjp7OwkGytxz4/hlFNbas0lfC0iD3Oog34lTLTgVhzTs1aN4Sj+oQgMiu5mZa/F41VJtLNrAGJnnCD5NSVfSxNCAEKjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hJJ00bKN9cowIfo0FJeRugC6GOlI4jNcAkx6Orpr6D4=;
 b=AwQHL1Shv+A+QHVbkSjYznw8Z65Yi5ZVhMOiG2edZhU1EA4UZMWC5FJO0B9mgNBIGbu1UdYCOU68NV6UZVuoImMIgfmirdgEniIWbEA710cwImtseUZ61bnten49qgJOrZz9nk4DQDRjVV7v32dp1aYZPhOJaKOBFSutqdJcixXRe9+b5MZt5DFq9I15dAKobVlwy1hbrlmSmdjKf0XhKVIbm40Ol3mAUDrT1CI9Adi5Ql5QxfRfcd4nJR88LipKsRb8lBWF00w/E+R6En15t24LijSISUo2HYiN0qjQed5COdmvQXG8JJAx2wEfiAZoyPJX5GHlLQVLcAcsx6sHHA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by IA1PR12MB8555.namprd12.prod.outlook.com (2603:10b6:208:44f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.29; Wed, 15 Mar
 2023 13:13:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::d228:dfe5:a8a8:28b3%5]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 13:13:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        petrm@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 04/11] rtnetlink: bridge: mcast: Relax group address validation in common code
Date:   Wed, 15 Mar 2023 15:11:48 +0200
Message-Id: <20230315131155.4071175-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20230315131155.4071175-1-idosch@nvidia.com>
References: <20230315131155.4071175-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0902CA0028.eurprd09.prod.outlook.com
 (2603:10a6:802:1::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|IA1PR12MB8555:EE_
X-MS-Office365-Filtering-Correlation-Id: eb33587c-cd39-4a92-ac55-08db25570ef2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: h8btuNSfpd43alpbOqjSCrkKrSQj83wirGawafqEbbJdCrDmg9qh6CZhhyUN+L25wE1KxObaRFjWfVWbY9mFVx+gumar+/71yxuSDtwMa6yly7z5ouIigcgGtVHndnkc84BJwh+7wvit4oVw7tnTMHJaBmOjkbYHF9H4U8afILgKKuZOKiFXcJG3J8zUsqa4XwHbUUa147Nbj4yuNViqfN0sZ80DU9qc7RuC1B4bqbNqz7cb7Zl8VRPV3I1viH3uyUA/L2fhXTeGZ8qXL63DNXEDA+B9cgbIDWBYgzjLrZujEhb+yS+fcT0NzSfkIMDxshOPbtQCm3leM/XEl/oDyUeYDk52z63DO0ywAWmL0RxGz6rYXJn0YHI7QKkVX1pCjfkJMYQLIop+Wm7A9nKH2lGQHWaMlBmVd9LGeGDIplEjzUzHYZMkZw1VBcxKsdlPRtGnoq6xBfSw1C0g1fFYAMDv+lEWtxNWbhH3omiAmpoFv4Q6f/zKda/TRjCKAXvfSXJXRkaJ2OZm6oCFqNSSgVaj+M/c2vN4QslUBvYeWLmnKjFrbpjcKzN7CMkn1ImqDiYxTIQ1LSsphjM6y/Hb+6R1ARFDSfrHXa+Mq2GbC5Y9oDaGtDqSoyke2wG5HxiKYfKmzrkx28sEO+v/i02WBK4BFaa/pOcQw685q3lro2eoswBCXoxw1wkS/AZWbD0A
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(346002)(39860400002)(376002)(366004)(136003)(451199018)(8936002)(5660300002)(41300700001)(2906002)(38100700002)(86362001)(36756003)(478600001)(8676002)(66476007)(66946007)(66556008)(966005)(6486002)(107886003)(6666004)(4326008)(316002)(6512007)(26005)(6506007)(186003)(2616005)(83380400001)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?pabvZFdmel7Cx6v+io0HkP0jSRzqOl9YSWS+O5sOL0fPln1TVK5YpPrDLy7n?=
 =?us-ascii?Q?2nYmUB71lsLXOQMUzQ49FYUsGG+M5UeukTTGTmBYxmf2ErLAJoniq7UKmy8m?=
 =?us-ascii?Q?QJgP7Spv0bgh7DquQn7QiB0JRWpeTNSmwRwPUBbfkYvZPNSnb+hQUnxZoNLP?=
 =?us-ascii?Q?GsG8bHEP50TL2yRy3QdDMoUqqVRDDNTfgca1cpc28ks+q+IIHeZ9EQrAcbam?=
 =?us-ascii?Q?BnQQsaESKB0RjP8aP7GQIM+D4HbPQNqRRuRIsgUt0hC4UdUrERfsgawFDekm?=
 =?us-ascii?Q?dVMbKYz7YR5qDf/GkO/fW2lnFc08vKLGW1DXhVhQ8tp6SxEgyoRnXvd0u1yr?=
 =?us-ascii?Q?UBv/tcN3rtSgMDEp/pQDHh8nRUbdJCA+T7UwB2dYBmeqXr3NnSJt+rL/IhFp?=
 =?us-ascii?Q?gqdvPT0DmAglz9cMpexhmsNLmcUrijzRgwJnCnUWKkQLJ4a63fLZGRDOLKr8?=
 =?us-ascii?Q?aJF2T4aCDhXHNMAxgtNQkeZMZ+4+qIqZtugE2i20uG+EyNgPzAXXG/R0DoQW?=
 =?us-ascii?Q?f+lEoXSG3aGH1mZtlEYe4jrfh00oOpGVtIaIqZDi6DYElkz7waH3dN5DTgkW?=
 =?us-ascii?Q?efinjpV1yIxcCjO1RlETXjkWzqoXVCNkK5n4LFm5zI6Azemh8E4H67GGveBx?=
 =?us-ascii?Q?6jvDYcvOsNXUWVtzscNEJ2235UlI0U5GCLaASW6fhLCfWTKyiJjC5uD0akTM?=
 =?us-ascii?Q?wTVjArURx2SH22+pK8XNC0ykmTiUwI24fLPd0AOnnllcTCZeuSgH6qsreHPl?=
 =?us-ascii?Q?wdUXxi9k/FkKa47kQDSCLeOvoHSgLd1L/xk8KGtAasHi+T+GaBgGuzK4PEGi?=
 =?us-ascii?Q?usKuCTn66Xqegp9pqO1TGBsfrQOxYt+N1wcjDO/GJNUyVdCpQsqfa90PIOjN?=
 =?us-ascii?Q?Tk7rSJKg8deFzDkXX4slW36XuLb5mk4kEvVqXCteGHjnsBlj9KEBSloF51pJ?=
 =?us-ascii?Q?Y0b6a3sMvOufBKR+MXFWoNGbpqQwWLxZ8sefPGQA71lLNN0kiDRfYfyJZIek?=
 =?us-ascii?Q?oSm4tR/bGDwtJu5EplPzjhaFqMXbhSh7OLTWMrLY0Up4Vw44uUnqKKFF6keu?=
 =?us-ascii?Q?DEj9+5e74uTfzxZnpxUsEsuUX2MdDvvNxn9dSSuIICxHzSerhbNb4khXy7tG?=
 =?us-ascii?Q?S94sUZ3uEEnqBobLVkZDI//Axq/XXXriJ1hClctWIclu3/YP5E/ug6WrE92x?=
 =?us-ascii?Q?07RYaAS8FBzZeyd1xWvHfnbY/snxaviownRKKW7R8ZQeeannghSu7//e+SOk?=
 =?us-ascii?Q?eNtfqOhAzbjclU6xrHocIOdqVKrVop+TZlRhL6cKv+bcdSY63r3BYswgsqO8?=
 =?us-ascii?Q?eOftzS8YlpROL5C2sJtip9NGsBLXJ+GXbRxvFWz3e+itu7Rd+LE6YcmoJ2dr?=
 =?us-ascii?Q?W8d8akLgGhUQCPS07BoMSpRYNQwzzOQNEVyPTZ1wvxOyUfipaPt+8YQURPKP?=
 =?us-ascii?Q?jblqyAJLjlStg0aLsIKeP7tkBH/omFjNwL09QDgTiuc+jwNL4fdJ/hi2GP4y?=
 =?us-ascii?Q?foYhIcJbv9cBhyhgrRU+fd6BCaV9lUJ6b7L0/T2yA6tZOxC7d2cgEp0NUYZT?=
 =?us-ascii?Q?9Wdb3lvczLTdHeSl36UHgPLw9kwCIy/Zynn1GfS6?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb33587c-cd39-4a92-ac55-08db25570ef2
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 13:13:24.7630
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GAqj+P2lT4BPAdRdMjSmXZgatFdQmFZAEfKHK2xNVpjB1EsOi3+8fRJUMcmTH8NLiJ3twwskcL3UT4SeMhbc+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR12MB8555
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the upcoming VXLAN MDB implementation, the 0.0.0.0 and :: MDB entries
will act as catchall entries for unregistered IP multicast traffic in a
similar fashion to the 00:00:00:00:00:00 VXLAN FDB entry that is used to
transmit BUM traffic.

In deployments where inter-subnet multicast forwarding is used, not all
the VTEPs in a tenant domain are members in all the broadcast domains.
It is therefore advantageous to transmit BULL (broadcast, unknown
unicast and link-local multicast) and unregistered IP multicast traffic
on different tunnels. If the same tunnel was used, a VTEP only
interested in IP multicast traffic would also pull all the BULL traffic
and drop it as it is not a member in the originating broadcast domain
[1].

Prepare for this change by allowing the 0.0.0.0 group address in the
common rtnetlink MDB code and forbid it in the bridge driver. A similar
change is not needed for IPv6 because the common code only validates
that the group address is not the all-nodes address.

[1] https://datatracker.ietf.org/doc/html/draft-ietf-bess-evpn-irb-mcast#section-2.6

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c  | 6 ++++++
 net/core/rtnetlink.c | 5 +++--
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index 76636c61db21..7305f5f8215c 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -1246,6 +1246,12 @@ static int br_mdb_config_init(struct br_mdb_config *cfg, struct net_device *dev,
 		}
 	}
 
+	if (cfg->entry->addr.proto == htons(ETH_P_IP) &&
+	    ipv4_is_zeronet(cfg->entry->addr.u.ip4)) {
+		NL_SET_ERR_MSG_MOD(extack, "IPv4 entry group address 0.0.0.0 is not allowed");
+		return -EINVAL;
+	}
+
 	if (tb[MDBA_SET_ENTRY_ATTRS])
 		return br_mdb_config_attrs_init(tb[MDBA_SET_ENTRY_ATTRS], cfg,
 						extack);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index f347d9fa78c7..b7b1661d0d56 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6152,8 +6152,9 @@ static int rtnl_validate_mdb_entry(const struct nlattr *attr,
 	}
 
 	if (entry->addr.proto == htons(ETH_P_IP)) {
-		if (!ipv4_is_multicast(entry->addr.u.ip4)) {
-			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast");
+		if (!ipv4_is_multicast(entry->addr.u.ip4) &&
+		    !ipv4_is_zeronet(entry->addr.u.ip4)) {
+			NL_SET_ERR_MSG(extack, "IPv4 entry group address is not multicast or 0.0.0.0");
 			return -EINVAL;
 		}
 		if (ipv4_is_local_multicast(entry->addr.u.ip4)) {
-- 
2.37.3

