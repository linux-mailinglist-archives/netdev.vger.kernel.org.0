Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F629648F43
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 15:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229715AbiLJO5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Dec 2022 09:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbiLJO53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Dec 2022 09:57:29 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02on2059.outbound.protection.outlook.com [40.107.96.59])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 668851A20A
        for <netdev@vger.kernel.org>; Sat, 10 Dec 2022 06:57:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DZm4XWLSANY+J/ziVjATPpIShl+VUdHCpj+qsWuVnCpn9vunZ944cM1HUM5td1tKWlNIyP+bk/oO0G8pR5vHdtp1MFKG1XDpL+JlIJW2GNqkRCDM9+IMGrUCDOTD7s5+x6N9OdiWYJxMNzlP9iIYHNpeFbuyLuA9ZUuVfBr//uUTYlsBoJhJQZVp74klLiG4bpevqz8yJHBd6O9SmKgidJHz6Vm+h32eOLtYu2blljwaSXXyPFrNIjzOCnlJmC7ei6PRuQlVLn1UvlZPFFRkoLYNkjECq77LJl5DJl/vmhJn13bEOwtZHiUXTHhYjDrwUtNjzwH7hz8GNVPEQlVU8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yM03GIg1YwgxJFGyTUnV8Za9M+lBuhgfqRMZea9IeS0=;
 b=HmG5V7Bl2C5yxSD7lGXGzHJ75b2AuttSHBVHLwDP9WVj0GjJJ5w0fme2MQQDjdyd0Yc39NCR3gqebJfHASxV1ITojbsinqbe4MOWK7OC8LT1V/6X05MuXPbIiEoeUtr+LXo5LyYnnsHygEJmpch4zVHT2m07PdDtenc+OtdS9VWIDGv6hlSW1QRhrTG1fcq5vClO6Zhg//LryEGulr0BWjFGF3dXrP4B4IXGfBL7Yjx/kX0WETHMEcNXh2GTRsG85EU9nZByEYgY0xG7JEflT5xjnaO89drbDfiRZSaSCwy6hF/dMsLsAdp/iHPwz4BcyFOwraypHDonFYcP0zqbng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yM03GIg1YwgxJFGyTUnV8Za9M+lBuhgfqRMZea9IeS0=;
 b=bO3IVvPo1tzhUt/FeXK5cJ0gLp/9gfZbLH1u2sU3gC39X2BAUbGkiS1dRiWRReQ0Kqg+Y/7lRcaPjAuxPJFPyz3sm7jWTnKvMSg33M9n2aK9bs0UB8H3xyu73mWH1S5e+vrw8wvtIVXtXGAUFJz3fZOBm5My6NPaOWwcST8u48QiOTf9u5tQoLqAMA6MyuWxK41+9VpxVR5gc1QsnIlZgYciROV+0FBov89dFin7WD8zJe2b9+YUQlOj1VnMszVX0QgmG8AC2IWm8CkmMJ6K5dg8xGPNWcG0UOYMNawWTPoDiAP6nLE2hz/bA35vfu8J5pDbUfwB+8Gih8M7nwNFzg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by PH0PR12MB8128.namprd12.prod.outlook.com (2603:10b6:510:294::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Sat, 10 Dec
 2022 14:57:24 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::a600:9252:615:d31a%3]) with mapi id 15.20.5880.014; Sat, 10 Dec 2022
 14:57:24 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, roopa@nvidia.com, razor@blackwall.org,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 01/14] bridge: mcast: Do not derive entry type from its filter mode
Date:   Sat, 10 Dec 2022 16:56:20 +0200
Message-Id: <20221210145633.1328511-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221210145633.1328511-1-idosch@nvidia.com>
References: <20221210145633.1328511-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0066.eurprd03.prod.outlook.com
 (2603:10a6:803:50::37) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|PH0PR12MB8128:EE_
X-MS-Office365-Filtering-Correlation-Id: 96cf8d56-a0ce-4b15-f474-08dadabed910
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j4VwQjf7jCQODP/VcFk4SBd8RId8/h0Flid4sVfZqxzI9PJap9GzwqXAcn+/2mHYl9jVjw3JIU1Q/j0uAouUXkPuOOmYcACJ+SoBMweD1vtlRL+eyOYnei4h/G0CA6JxfFx8DC+L5IpqY5I3lwpYpVm8BqFhig0tl1laknB9M/YeSTjfNKngVSiG6Lxky8xlmFws88UwPSDwaaZf+Sqw++MABV7DY6C+9V/bOBkbZKaUN7rVoD25uQTlpo/v33SOOP9x3JwZmhYjYr/ekIE4XAvxNxCybHBNKL+74I9VNPze/zbMuUlls1CBTUPN0tMHpfX0gpxA882UCIcJIixmDKDvG8lm/CCv2zc0D7FeBpCNarue4V4Noa5n8EjST1K4W+GF5V0fFEyTaqhgbc2eL+I4SSkgDoa+XVbxFEumyuKYX7I03y1Eynuii3u40ob0yugnI9vTkZmTBBs49kpuB8qhPolzRnJ0m29o89fljWv+yVVABhggo7SRvsIK6LufNs2FU99NzeJVvDQjheaC9YD4o744cQhTsDNgC1ansN6U/UEwiBRltUzJZlkZKpy+lITxxSqGCiZOme9VGlx+8/H/YHrSydHqxpI02C+OOqTnWLS8kSPYdlt530tD4Rsi+sn2pw6e7n24W2uxUeFmVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(396003)(366004)(136003)(376002)(346002)(451199015)(6512007)(186003)(26005)(478600001)(2616005)(1076003)(6486002)(6506007)(107886003)(6666004)(38100700002)(83380400001)(66946007)(66556008)(66476007)(8676002)(4326008)(41300700001)(316002)(2906002)(5660300002)(8936002)(86362001)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?GfYl8pWT1CVn9xRK923ewHAUBERFwEVFaIZ80BiSchA6JP1FChsOwbRbf+Xd?=
 =?us-ascii?Q?hRmwIrtZa6yoGmYIR6wJ+1cLNinM1W7N+FmpNgrYSUQ0re3I6cYuztR4QRmU?=
 =?us-ascii?Q?/q+TsItbiHtrkHgs2Az/LNwJJfBWINIcgzAYgghQQPsrwHhOwLZWn0UXnljR?=
 =?us-ascii?Q?/ec8gOTtRMJK0sz97Mi26E2ybbGOsAd6dpx0Z0p22ctDpkqSk9UCc6zFEU26?=
 =?us-ascii?Q?WhlYT47QIK9br8oFpBZ2aPxk37O0rfxUiPh4QLHD6roVjsmpO0OTZRtRWgcK?=
 =?us-ascii?Q?T0XJUo5Cb0RBKVJKzjaUW6kOAQ4ssxTPkjSJHCDut7wbGmDQWbgWRZWwqiIu?=
 =?us-ascii?Q?H+2d6n78LN+FXUyka/k6DzayI5MuwMXGVfgAos7uM1kimXRqKsEfB1SM+YxM?=
 =?us-ascii?Q?qmCeo7+bSbZzyGxi3G2Mk/BIGnpyOxOKpDZ9gfXRDlzrkHFNwRSBp5UxLFnf?=
 =?us-ascii?Q?DUaHPXdNhgveUij1qNkQ6mg1CsY1oOgY8fMbf7FQHghd+scNGzGEEOHnPVZP?=
 =?us-ascii?Q?sQARa1rUidyTVpWWIKgPZFi5cIjWPCUViaAzJZr/S+b7SuiLNWIaBfqnAyb3?=
 =?us-ascii?Q?rY8BMUWNevr6c24WjZRZYoBv+yRR3uY/MrgdAS3xSwr5y68Ml8ltDBQxJGzU?=
 =?us-ascii?Q?XwezNsDUV8m7gaEol9w+HrtAjOstn26PNro3VCo+NtKkOXcQAStb5zT5XV2N?=
 =?us-ascii?Q?mNyk7e7N0D+atmg+O+G6Jk/VVUsTN2YqGgI07RDQMtnAIW+RdM/q3copfoDu?=
 =?us-ascii?Q?B+228pHoH+Zz0NTR0GJFwaXv/eR8KaAKkk5aHiCmlHhS4julDL2FHnEmcloE?=
 =?us-ascii?Q?nFLPPSdz0v5dGKSulhPOBC+kU726zg6vvGFmP0Jj/++2Up036FOp1aWaMg3h?=
 =?us-ascii?Q?3KgzB/yOXbsNKnpHbq7dhKkiAEna0nVHt3hl0tBV05uTHB9wcxNKdKheyDNL?=
 =?us-ascii?Q?QFTUaAdxUKP+xC+jkm/uAWcPYWX70c1+7QqFk0HjcQAcad5AFrozpU+JcELp?=
 =?us-ascii?Q?OrF2c24e+rc/S5OHpjkeEz4e6c3nC70fG/Tx0XzP15T8H6o1oHyfzm2RHBbS?=
 =?us-ascii?Q?V9g0qZ3xGOp8+zG0kc0eY9HlgeKIOIgxb/nHYIm4ioeG/sVqIbZ/zLGZrFTe?=
 =?us-ascii?Q?8Yjk5fEIzOGrzG21t9kY5PA59pDPXx4//EJOmUCHkYQ44OjcZYdotx/eDPuW?=
 =?us-ascii?Q?Bg9lIEZhfmWiPiSaQpZ+nkIbjBPc/7CC5Kb9LzsYl3Tkl5zHJhYNZ8Iz3buX?=
 =?us-ascii?Q?FATBHYC99xQlHxXw/95fWfQlUp24M8Ddex8kpeEAWxIeYB6ylb3tLXS5pUQ8?=
 =?us-ascii?Q?ZAr5YMe0lxPjGdEHGw7I4u6VDA6hG84kG3qo+zpfjjwpBxe3G7WSn/mhtzwB?=
 =?us-ascii?Q?y8CG7iOdW0E/XXglwAvL+njsgR4xphkQz/M0jiYXTBtMLzVMpc/X/pboKM2k?=
 =?us-ascii?Q?X6EyJDqXICgPmZh4kYjfuW49y/W3cNYGi1vFi3WBBB0kiaLR8MfnijCbymjr?=
 =?us-ascii?Q?z0UtlxUHMCPo4sWj7etBwWUGvFRydZU9vTaufgQrKCrULhZ/yz/aAID++T3h?=
 =?us-ascii?Q?BFVkNbtdYmFpUsp7LVChE+bKZnvHHl1lG6ttLq/G?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96cf8d56-a0ce-4b15-f474-08dadabed910
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 14:57:24.7691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tEkSzelLXgWfp7IwtlEZ3wXOGQZfV353p7pD2gWHl07fIcOgV2pmmOWbeNZGv7GxKmyo+am6u9dUpWd5K0UBdg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8128
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, the filter mode (i.e., INCLUDE / EXCLUDE) of MDB entries
cannot be set from user space. Instead, it is set by the kernel
according to the entry type: (*, G) entries are treated as EXCLUDE and
(S, G) entries are treated as INCLUDE. This allows the kernel to derive
the entry type from its filter mode.

Subsequent patches will allow user space to set the filter mode of (*,
G) entries, making the current assumption incorrect.

As a preparation, remove the current assumption and instead determine
the entry type from its key, which is a more direct way.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
---
 net/bridge/br_mdb.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/bridge/br_mdb.c b/net/bridge/br_mdb.c
index ae7d93c08880..2b6921dbdc02 100644
--- a/net/bridge/br_mdb.c
+++ b/net/bridge/br_mdb.c
@@ -857,17 +857,14 @@ static int br_mdb_add_group(const struct br_mdb_config *cfg,
 	 * added to it for proper replication
 	 */
 	if (br_multicast_should_handle_mode(brmctx, group.proto)) {
-		switch (filter_mode) {
-		case MCAST_EXCLUDE:
-			br_multicast_star_g_handle_mode(p, MCAST_EXCLUDE);
-			break;
-		case MCAST_INCLUDE:
+		if (br_multicast_is_star_g(&group)) {
+			br_multicast_star_g_handle_mode(p, filter_mode);
+		} else {
 			star_group = p->key.addr;
 			memset(&star_group.src, 0, sizeof(star_group.src));
 			star_mp = br_mdb_ip_get(br, &star_group);
 			if (star_mp)
 				br_multicast_sg_add_exclude_ports(star_mp, p);
-			break;
 		}
 	}
 
-- 
2.37.3

