Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E77C61E1E8
	for <lists+netdev@lfdr.de>; Sun,  6 Nov 2022 12:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiKFLkt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 06:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229841AbiKFLkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 06:40:47 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2067.outbound.protection.outlook.com [40.107.237.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE956DF59
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 03:40:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVwp//8pORHjEPpMrM6eKrXG4qQdR6VD2vLn8XaWXYl04ri/f9LskB71araesoM5MLLzAf0LVVKm/YjYv7vetTu1QZqaXGzYdypoaGH0ykzAMoUbmbvTYRUzBI7jkbi5zoxH4cqtgVTvFPyjL6AorR+kO48t7Dg1RwRhJDxM5XrreysobVokHah7iYWUDGBqmaOTFgLWeTYhGtzYYUYigrRv/C9CQ+G4HeujWXeB4wloI1cv2LkvqksBq6diZhcDpSSFrEi3FUb/fXB1rKRiHAq08Etxav5d88P6rEW/reQfn9pLckmdZB1+nu6f9emXQOzjE5xgrLSP54WtMJGKiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ijXTo0LAYlncHwy+G9i6zpZy+irrCAqoBDfQhlexvIE=;
 b=NdNSK8NagA1pFQXG0mSVyQAdVR4aKw3P/2q0Car2nFsZlAfEB5mi3Etcm6k3TCDZrtrcxzXa3ju3Rj3XGW5XvHhj/YzRR63LeSQkj1LyZcieiAGVmI6hsm9hJSA95PRA3lSRc3CHziBnk2w/vFMBt+bMj4AJ5yLlXeXSq4TjiWzeSkvyIfFLkhiEVsCGORGWqBo4vUwomjVVLEkhPrFivOkcn7LN4yGz1Hccgyt5p/Ch7T4dBG+akp8bYSgXU7V8dUxz33GAbeGMpbLoH6m2yyDh/0cFUdEOryCgtRSWcUlQukrz/ZeioHIrzQCvYM05XQevKMT4gXYaODrTOMIBeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ijXTo0LAYlncHwy+G9i6zpZy+irrCAqoBDfQhlexvIE=;
 b=r3ZUOoi7Irt9Rqo/5exbQcI1EZ67Dpb71YKdx13SUtfvL8WzT0ClQ61ZMNu42ye+TjnP1VPovWFDnea1lMVa55k3GsFs5SuXqOMmGYVofRDX6d90Xbp4oQESC3qZLftq0CU7zvN/4ot+7CRj1gvtVISO3fz6Bdk9FuKfxGSIVxfx5n4NEySfWys6xCYWX5KVXj6gGazbciWdZWlttVmdY+tB8uFLFWHnnSqPko7XdjEn7FOo8eBCGeRsUhO1XnFWaVAUK3e+zHqhDjPlTesF+AFvM+AJbOBmn0Yn7jK+XJhURM1XIRXfyCww2OAWpm95Vtdv5GU2D8CIjoy+bvkK2w==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM4PR12MB5867.namprd12.prod.outlook.com (2603:10b6:8:66::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Sun, 6 Nov
 2022 11:40:44 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::3409:6c36:1a7f:846e%4]) with mapi id 15.20.5791.025; Sun, 6 Nov 2022
 11:40:44 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, dsahern@gmail.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH iproute2-next 3/4] bridge: link: Add MAC Authentication Bypass (MAB) support
Date:   Sun,  6 Nov 2022 13:39:56 +0200
Message-Id: <20221106113957.2725173-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221106113957.2725173-1-idosch@nvidia.com>
References: <20221106113957.2725173-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0901CA0085.eurprd09.prod.outlook.com
 (2603:10a6:800:7e::11) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|DM4PR12MB5867:EE_
X-MS-Office365-Filtering-Correlation-Id: 856aea98-7e31-4191-4607-08dabfebbd3c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KW0uavfAslkaYswiAyOjwnD97VXdw9mmvIIXhZqmfdUqmdiWp399Tqb94HZkAEuev/IVFppAmAh0MZR+IqUWjDH76wjPiG25ymjvmHy2GfalKqQpOwnYn9rMyeruFFZ75DPFi9LtLM4SXdZEzE7pFwRJb5sbn63zsYi3vRbno1XAaIzMWKLPEgT9V0ow5i5Y85e6tqbTKgF72RfSxmN2ffIpF82y7pSoCKiyjXPDR8WsQOQznV1PRgGdToCd/hHgTFA3aloqQsMg9KNi7kUS6jPlOSimZpGddtbysD/Hkb8/PYF5+RxDMFQRGOo4qLkBvvdGiZLfYS1zm0vjqNKOgeqcxrjqLAGawR/D+FhePUaQKji0DUFQDwtfjhInH7+Qyled9z2cO2erSky2np9iYyLTzb2SkHws5BPKttk//LN/6N+RT2v6eI+ydKXv8x5et1b+LfC9G8v2SjCs9qNHlOJjoujzU/Q5SThSGFZjibSGD13ehq0WriikjGEdtAYVL1Vg0qMM76JNzlY7UAAccIembbPxQwfH9Hx5HyKj56uIcAtxksFT7/ZrsaY2f4DDDMEFasN3+cveQxb+fYywWgBecYBafX+cmuz6L1eG4hDs/lQyLMniKbDn+jcntDkpUpzvRnZOhLMv+3Tcy8UaFHK1FYGWIoFw4FMVoEWfhysxZTL5jIQyEmezAQkH4/H2k+nDFwzuDU2niZGTs3oLLA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(451199015)(26005)(41300700001)(6512007)(6916009)(2616005)(38100700002)(107886003)(36756003)(6666004)(6506007)(4326008)(8676002)(86362001)(66476007)(2906002)(66946007)(66556008)(83380400001)(316002)(186003)(1076003)(6486002)(8936002)(478600001)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FkwYwm+Wkr7ZVg2OOa1NTVzHgdbQUV2kq0/hrb92I3TvqgiBeQhTuWn2U1PG?=
 =?us-ascii?Q?D6mwyHrEkkmaZij2TfPoNg1VQ8raRuqAVwWmxNDdofvtIRRa+PhbSuh6hBYb?=
 =?us-ascii?Q?sEFMxB77k4mm71jxZVS3fDflZmrjESQ93CkkwvODkvAVr7gFdeiseUHGA4fK?=
 =?us-ascii?Q?0LRbPEx2MVmezTDYDPuwF+laAtbM60mHS45UQ4wAissHCcxNhLAS6T7CXh07?=
 =?us-ascii?Q?hawXxPp9YkPEvBNAwJOFKrstzNxiz/az9H2DCS/GDg6t0E3+VbRt/7LeHzkI?=
 =?us-ascii?Q?2n1/yUXQDO+nMf/ivVrSruTydk8Ky2O1sSk9sxUhQykKsBrK+FG62m+HUw8H?=
 =?us-ascii?Q?V2Uxq8I870vN0JeKC2WkE/fRIRdoyHwEUWxUeG6ZJPs22UgATSRnaXjn6owh?=
 =?us-ascii?Q?hq7ybMGc16viEjs+moMIOOCD5M/fpocMlWrmUTE5toCypKDsQiOakHwRsAj1?=
 =?us-ascii?Q?noZ4a+bAagqa5qw7TaKTMBXswi3tLrTgP1P0OkEAuPqPTka3QDQd1N8U9lvb?=
 =?us-ascii?Q?3jApi7Uz5Pxj6r2ane8raw6DlQvYMNpaxa1g/MR/k84MY8oMyI+GMnqJYPcF?=
 =?us-ascii?Q?GZks5ecRk/utjUOdv60GIFOKMlnpxcd3rETM4dltLLNiT+Pr7MN5dQH7CJBG?=
 =?us-ascii?Q?lKC9yXLmbUFAgP32EnoalbehyiYpn1A5h9q1mtCM+O2SK9zfW1WwKik20/z7?=
 =?us-ascii?Q?FDNfAX8wRb8XXuiFNCGS/oRBR9LARgbP+ZnvVkEGZNtd9sf6SzkZxWdzO24C?=
 =?us-ascii?Q?y1AVom3xj2xbAPqz12na2dpdMQYNyqRvkT8PcZzZ5IPJABhUwJslqQ7uawKN?=
 =?us-ascii?Q?r7lRIQK8lVx+T+LHvg9cAoPGhhItrI0hbM55WTvCptsSntbv/DcobodEKQWR?=
 =?us-ascii?Q?zrtd/kFLz0RRTpwHWGSMq+UlrtrxXnl2IFo7T7ZbltU2/trcn9oFjZM0U6VU?=
 =?us-ascii?Q?hGbFQQ8OmmO+Mr96+KnEoutJEOYIWNitaX69WPqH1OC6VnifYpC2ck1LqeDd?=
 =?us-ascii?Q?v2u0YYdNiXoeqHYPTgTsrxPHXuqR32dcPttbBap2y/o2ZfktUcM3MR78Mkcl?=
 =?us-ascii?Q?FyYyRZh5pn0Dq7SNPYtBdzfrFL9f6tb+FjEwnoX+F0nWrcTP45B7PyDXwBrW?=
 =?us-ascii?Q?ux2t1GmYh6I/uUEuG0xWjSs+VmBJuwAuckXoyi5f6HoXSNSRcBFdyFwrZSf7?=
 =?us-ascii?Q?GO89dX2HcPY7pxRuUtBUWuGmzYaHFAg0Ip4+X1ewRHFrPJ4QQAcjcq3jl1Hl?=
 =?us-ascii?Q?NZivl4HHygriZ9fZP7pvRy3j4pHOXVgNgxCECdxVdohf5O4BBYDqn4Y3IG42?=
 =?us-ascii?Q?Q8kwUEsJkYqRISbj2OwwXhtClqB9dWdKxN/bxSmeItFjjAAN4GAyBA6CIVPS?=
 =?us-ascii?Q?e0vgm9XYUgFA9MamkphwA/sSxERooWFBW+1lZUZI+0pQG6XC+UXDlZdTQldi?=
 =?us-ascii?Q?c8birRqK8dtoJdX/Y+tU+EnGPlIesM0yF4yLY3O+hgVOKvKaXYXLcer9wRKE?=
 =?us-ascii?Q?Hx17meKu+o8cO1pKDXckO3bn17EYbFS1p1fgHEaQMh/obqtRugp0cjifgE0c?=
 =?us-ascii?Q?d42ZHrDZtUG6zGELjA9cGBGnc+nqLCK73JGsgaxh?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 856aea98-7e31-4191-4607-08dabfebbd3c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Nov 2022 11:40:44.1921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0QhOxX0xIqTQD5ZO45ckaev+MA0CaOW+4rHNpNkAbk2bLEnSCVtHkKvbFmlxWpALGtaUJfwyoUpKzIQcZomqkw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5867
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hans Schultz <netdev@kapio-technology.com>

Add MAB support in bridge(8) and ip(8), allowing these utilities to
enable / disable MAB and display its current status.

Signed-off-by: Hans Schultz <netdev@kapio-technology.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    Changes made by me:
    * Reword commit message.
    * Reword man page.
    * Use strcmp() instead of matches().

 bridge/link.c            | 13 +++++++++++++
 ip/iplink_bridge_slave.c |  9 +++++++++
 man/man8/bridge.8        | 16 ++++++++++++++++
 man/man8/ip-link.8.in    | 18 ++++++++++++++++++
 4 files changed, 56 insertions(+)

diff --git a/bridge/link.c b/bridge/link.c
index fef3a9ef22fb..337731dff26b 100644
--- a/bridge/link.c
+++ b/bridge/link.c
@@ -184,6 +184,9 @@ static void print_protinfo(FILE *fp, struct rtattr *attr)
 		if (prtb[IFLA_BRPORT_LOCKED])
 			print_on_off(PRINT_ANY, "locked", "locked %s ",
 				     rta_getattr_u8(prtb[IFLA_BRPORT_LOCKED]));
+		if (prtb[IFLA_BRPORT_MAB])
+			print_on_off(PRINT_ANY, "mab", "mab %s ",
+				     rta_getattr_u8(prtb[IFLA_BRPORT_MAB]));
 	} else
 		print_stp_state(rta_getattr_u8(attr));
 }
@@ -283,6 +286,7 @@ static void usage(void)
 		"                               [ vlan_tunnel {on | off} ]\n"
 		"                               [ isolated {on | off} ]\n"
 		"                               [ locked {on | off} ]\n"
+		"                               [ mab {on | off} ]\n"
 		"                               [ hwmode {vepa | veb} ]\n"
 		"                               [ backup_port DEVICE ] [ nobackup_port ]\n"
 		"                               [ self ] [ master ]\n"
@@ -314,6 +318,7 @@ static int brlink_modify(int argc, char **argv)
 	__s8 bcast_flood = -1;
 	__s8 mcast_to_unicast = -1;
 	__s8 locked = -1;
+	__s8 macauth = -1;
 	__s8 isolated = -1;
 	__s8 hairpin = -1;
 	__s8 bpdu_guard = -1;
@@ -439,6 +444,11 @@ static int brlink_modify(int argc, char **argv)
 			locked = parse_on_off("locked", *argv, &ret);
 			if (ret)
 				return ret;
+		} else if (strcmp(*argv, "mab") == 0) {
+			NEXT_ARG();
+			macauth = parse_on_off("mab", *argv, &ret);
+			if (ret)
+				return ret;
 		} else if (strcmp(*argv, "backup_port") == 0) {
 			NEXT_ARG();
 			backup_port_idx = ll_name_to_index(*argv);
@@ -522,6 +532,9 @@ static int brlink_modify(int argc, char **argv)
 	if (locked >= 0)
 		addattr8(&req.n, sizeof(req), IFLA_BRPORT_LOCKED, locked);
 
+	if (macauth >= 0)
+		addattr8(&req.n, sizeof(req), IFLA_BRPORT_MAB, macauth);
+
 	if (backup_port_idx != -1)
 		addattr32(&req.n, sizeof(req), IFLA_BRPORT_BACKUP_PORT,
 			  backup_port_idx);
diff --git a/ip/iplink_bridge_slave.c b/ip/iplink_bridge_slave.c
index 98d172134847..ca4b264e64e7 100644
--- a/ip/iplink_bridge_slave.c
+++ b/ip/iplink_bridge_slave.c
@@ -44,6 +44,7 @@ static void print_explain(FILE *f)
 		"			[ vlan_tunnel {on | off} ]\n"
 		"			[ isolated {on | off} ]\n"
 		"			[ locked {on | off} ]\n"
+		"                       [ mab {on | off} ]\n"
 		"			[ backup_port DEVICE ] [ nobackup_port ]\n"
 	);
 }
@@ -288,6 +289,10 @@ static void bridge_slave_print_opt(struct link_util *lu, FILE *f,
 		print_on_off(PRINT_ANY, "locked", "locked %s ",
 			     rta_getattr_u8(tb[IFLA_BRPORT_LOCKED]));
 
+	if (tb[IFLA_BRPORT_MAB])
+		print_on_off(PRINT_ANY, "mab", "mab %s ",
+			     rta_getattr_u8(tb[IFLA_BRPORT_MAB]));
+
 	if (tb[IFLA_BRPORT_BACKUP_PORT]) {
 		int backup_p = rta_getattr_u32(tb[IFLA_BRPORT_BACKUP_PORT]);
 
@@ -411,6 +416,10 @@ static int bridge_slave_parse_opt(struct link_util *lu, int argc, char **argv,
 			NEXT_ARG();
 			bridge_slave_parse_on_off("locked", *argv, n,
 						  IFLA_BRPORT_LOCKED);
+		} else if (strcmp(*argv, "mab") == 0) {
+			NEXT_ARG();
+			bridge_slave_parse_on_off("mab", *argv, n,
+						  IFLA_BRPORT_MAB);
 		} else if (matches(*argv, "backup_port") == 0) {
 			int ifindex;
 
diff --git a/man/man8/bridge.8 b/man/man8/bridge.8
index d4df772ea3b2..1888f707b6d2 100644
--- a/man/man8/bridge.8
+++ b/man/man8/bridge.8
@@ -54,6 +54,7 @@ bridge \- show / manipulate bridge addresses and devices
 .BR vlan_tunnel " { " on " | " off " } ] [ "
 .BR isolated " { " on " | " off " } ] [ "
 .BR locked " { " on " | " off " } ] [ "
+.BR mab " { " on " | " off " } ] [ "
 .B backup_port
 .IR  DEVICE " ] ["
 .BR nobackup_port " ] [ "
@@ -580,6 +581,21 @@ The common use is that hosts are allowed access through authentication
 with the IEEE 802.1X protocol or based on whitelists or like setups.
 By default this flag is off.
 
+.TP
+.BR "mab on " or " mab off "
+Controls whether MAC Authentication Bypass (MAB) is enabled on the port or not.
+MAB can only be enabled on a locked port that has learning enabled. When
+enabled, FDB entries are learned from received traffic and have the "locked"
+FDB flag set. The flag can only be set by the kernel and it indicates that the
+FDB entry cannot be used to authenticate the corresponding host. User space can
+decide to authenticate the host by replacing the FDB entry and clearing the
+"locked" FDB flag. Locked FDB entries can roam to unlocked (authorized) ports
+in which case the "locked" flag is cleared. FDB entries cannot roam to locked
+ports regardless of MAB being enabled or not. Therefore, locked FDB entries are
+only created if an FDB entry with the given {MAC, VID} does not already exist.
+This behavior prevents unauthenticated hosts from disrupting traffic destined
+to already authenticated hosts. Locked FDB entries act like regular dynamic
+entries with respect to forwarding and aging. By default this flag is off.
 
 .TP
 .BI backup_port " DEVICE"
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 88ad9d7baab7..314c07d0fb1f 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -2471,6 +2471,9 @@ the following additional arguments are supported:
 .BR isolated " { " on " | " off " }"
 ] [
 .BR locked " { " on " | " off " }"
+] [
+.BR mab " { " on " | " off " }"
+] [
 .BR backup_port " DEVICE"
 ] [
 .BR nobackup_port " ]"
@@ -2577,6 +2580,21 @@ default this flag is off.
 behind the port cannot communicate through the port unless a FDB entry
 representing the host is in the FDB. By default this flag is off.
 
+.BR mab " { " on " | " off " }"
+- controls whether MAC Authentication Bypass (MAB) is enabled on the port or
+not.  MAB can only be enabled on a locked port that has learning enabled. When
+enabled, FDB entries are learned from received traffic and have the "locked"
+FDB flag set. The flag can only be set by the kernel and it indicates that the
+FDB entry cannot be used to authenticate the corresponding host. User space can
+decide to authenticate the host by replacing the FDB entry and clearing the
+"locked" FDB flag. Locked FDB entries can roam to unlocked (authorized) ports
+in which case the "locked" flag is cleared. FDB entries cannot roam to locked
+ports regardless of MAB being enabled or not. Therefore, locked FDB entries are
+only created if an FDB entry with the given {MAC, VID} does not already exist.
+This behavior prevents unauthenticated hosts from disrupting traffic destined
+to already authenticated hosts. Locked FDB entries act like regular dynamic
+entries with respect to forwarding and aging. By default this flag is off.
+
 .BI backup_port " DEVICE"
 - if the port loses carrier all traffic will be redirected to the
 configured backup port
-- 
2.37.3

