Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0163F1773
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 12:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238340AbhHSKqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 06:46:16 -0400
Received: from dispatch1-eu1.ppe-hosted.com ([185.132.181.8]:36128 "EHLO
        dispatch1-eu1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237005AbhHSKqP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 06:46:15 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-am5eur02lp2053.outbound.protection.outlook.com [104.47.4.53])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-eu1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A4DFA4006C;
        Thu, 19 Aug 2021 10:45:37 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D/BY66tRII0eziQsgM0/EhzxdljVZigKZjij0RjKN85xObE48WEM4PHDe7KNISJBRBOuSiM3EBTVCfqdOMoMU95ImUKGL4VLMKDNCwg4jUW1FA4muhVRLkKrk5AAeaPF7ZPJlMonDKOLQOjvt60qboNTq79WkvGRoX8sfv6sXQvUWr7hHN/K/QdeT5Hpxxfna/zxBfFqPPnpDVY2waa5f75Vu8CSMIZzytdnvkfnqKjN3hbNsN9JFIdv2Ls8upTh/j3WxxeX3CU4dhd27QesGccWbaz1e9yl6zOgfQwHE18vCGgOpXNUfUvDaodS7+IE16vA/8543bHIGTLEGzfLWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njGGPwlVjCfII5EijpeyahLpK+eVQRJr9MjvFVk4vYs=;
 b=Y8OyGqi/tha72VMR/juMSmmsczl+chXW+TFE6ySHiM/Uege9be0dDmbjW+T1F2LrmfwyXtLww3gNx7e3lPVMprVdBxYXyauduMYQDHjSVpPqjTQDqdtTnNrxi4NlaDYMJGrcHCRi2meanazgVx2rJ/m7i/AeX32sHmk5OB1rZncNbOSPFjtiTqcKp7dRe0CxTI+1DYF2UxVX0wbzvfwUwCJxalskHJ3JJKKuidQzCl1FLj3AhLu1EcHB7KSVgrz/TkIHPgdIEkF0WW5qypqFoCO2KzJKfPD9QiWO5YANhnJ9Jv+S8ARn5r10cLS/b6XZCUbYAtFdKSLtJnFPxw5iyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=drivenets.com; dmarc=pass action=none
 header.from=drivenets.com; dkim=pass header.d=drivenets.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=drivenets.onmicrosoft.com; s=selector2-drivenets-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=njGGPwlVjCfII5EijpeyahLpK+eVQRJr9MjvFVk4vYs=;
 b=MomC+JXkRnc3Zlduh7cCr39f7owHd6C4wicaKmTHKZu7j8UEKgNTL5r9eL2Mkk0tPUJcElXV/qmLXjoXSQ+07BmSmtgzmtOJKaEihh35Ow1aK20B0XfyuGmOXMJGB0JCDgk9MYWt03KGg3BVPhscV5bFOChwJMeCMU/L1gQo5bw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=drivenets.com;
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com (2603:10a6:803:7a::23)
 by VI1PR08MB2941.eurprd08.prod.outlook.com (2603:10a6:802:1d::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.22; Thu, 19 Aug
 2021 10:45:35 +0000
Received: from VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b]) by VI1PR08MB3518.eurprd08.prod.outlook.com
 ([fe80::cdfb:774a:b053:7b%6]) with mapi id 15.20.4436.019; Thu, 19 Aug 2021
 10:45:35 +0000
From:   Lahav Schlesinger <lschlesinger@drivenets.com>
To:     netdev@vger.kernel.org
Cc:     dsahern@kernel.org
Subject: [PATCH] ip: Support filter links/neighs with no master
Date:   Thu, 19 Aug 2021 10:45:22 +0000
Message-Id: <20210819104522.6429-1-lschlesinger@drivenets.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR2P264CA0165.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:1::28) To VI1PR08MB3518.eurprd08.prod.outlook.com
 (2603:10a6:803:7a::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ubuntu2004.localdomain (199.203.244.232) by MR2P264CA0165.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Thu, 19 Aug 2021 10:45:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2b7f9703-6691-4ee4-d0c1-08d962fe79d2
X-MS-TrafficTypeDiagnostic: VI1PR08MB2941:
X-Microsoft-Antispam-PRVS: <VI1PR08MB2941DBAD7766B4CE7FA58F1BCCC09@VI1PR08MB2941.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +1cuPHDTyUfbLjpdIhuGFpKTfOJlL3G7Y19FUWcuw/GGOien5NjHIbPOYBzxeb8jWDLBo1gyWKcVHyi+Z99Leh5K/o13AckOQQYYjW48f9rcNcn4x6xoZjRFCzZ9xyJBeLJoATLc7KZXQ3c5VUXH5xHRkOLPBUzniYhGLSiQyjp7SmIHkysN88uAXLQfd/TDWjfmNFf5MCSdjkyB6QMp7d65b8jJNKtS/KD7/y7iW469H5Q7SJV3yGqelgGCDq2wf46QhrJCd2loHqjgC34jF7U8XNPctdPbvIYu8/jUqz0lX/ooIUoaRCQ2GYX+7YucZznAT6phF0MAptT7HhAHJ4rvQDRWGGCXsu7VcVfl2Xg4rRKCmcyMareBp4LyUZKzIvotbB2Sr6kq6RUCm50zzEe9p6AqvYvthGc2fj8/sIMsBFIhMNF0yF0DtvegbKZLKLYDrZrOWslMuFHAo1KPwIkO5hEOsPTUL1AvZANf+6YOqx9+uoEyX29ZgdGaXiWO4w4cU+sj0YqJS9fIn2G5SbhBF732cqsUcgjZnmxV5QUAlsQymxaxVVZk+Uci3XiLm2mUzv3XKUFN20Vfw1AqoRxHgpFsf88V9T1ZyRvoJcu2mDFOTVtc2z+Dc+hT2+2XHkklYT7oheV7VhD6E0VI7mtb25ZKKkaAJRk9SkFJWxi7WYxnbwFvus/HrfsSy5/i
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR08MB3518.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(366004)(376002)(136003)(39830400003)(186003)(86362001)(478600001)(6486002)(8936002)(1076003)(2906002)(66574015)(66946007)(5660300002)(2616005)(36756003)(6666004)(66556008)(83380400001)(38100700002)(38350700002)(316002)(8676002)(26005)(6512007)(52116002)(4326008)(6506007)(956004)(6916009)(66476007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?yQZMClYuxnZOn02AV1XYHCQTkK/QZPcrRelVXhb6Ik3BGw+Io0AGI3kFDHtq?=
 =?us-ascii?Q?U8ta0LLoCp1k/ZV5wr/qW8p9Vk9ZOBzVtN6F38zxrAUzgOO2VA+pQerOukXS?=
 =?us-ascii?Q?HR5Lr7P6Mfp8sXPRSvrw6QPMAp1gc7i+S9ZuD7z8R0GUe9EcClWF7zN/G4oO?=
 =?us-ascii?Q?VUBw9J+mQ3Gg/QCnksgC/zcqcTfd71UponUqT+rRWzec7ezoZl9gBA4IbXqI?=
 =?us-ascii?Q?/W+9nT2yClV1fcU6Tv5d/bNEExS6yEdVR3L1Bs18CvdrtQDOwfxagIVFIW14?=
 =?us-ascii?Q?qVcaJidTUaBXcNFRifvTM7RolX/dOlFi/aKQyxoBki28Ty3fb11msOchzG+j?=
 =?us-ascii?Q?JoN2GzGi12VX9jhTQLFCqHWbgNWXxgS4gb98c8756/Rsm8tbNk0TDmTY9tDJ?=
 =?us-ascii?Q?1ezDfe7xxm9t3RvWgfOaOpN9fFBpxd/folCW/dNGF1oY5F3/v1dWkLFI2xjD?=
 =?us-ascii?Q?0bevDO5vkGB9fe98rVmrAU+UejVbVjX1VFB4GibH+FoJGtbw3JZpPZCCoQz1?=
 =?us-ascii?Q?hRxnmPJ5JIQFHtVBRn3oZKapZ5SA836lgqN+m6pwpwsEaOvOvzxutYu55sOf?=
 =?us-ascii?Q?9M3zjIKW+Hw2v94YRRq8fC1B9QQaO6H+p/jxjaMLYvXjr7hR5/JwoB03iGyL?=
 =?us-ascii?Q?3UPUEWN3YAw7qDonaBCCZd9mlI77VvU9TuC5gtSFV09Bmohk17t9oxcBIwd/?=
 =?us-ascii?Q?Ybol2gbWNzjNVKpxDSq8W9omBmrymwZfbZvhMhlDp2xNHEunPpGxWWNq4Dye?=
 =?us-ascii?Q?8p8iM3K2hPG8MSgA9G44uuXFfjbspX3+6SVCUZvuiFQJSKD5a7XnRYKvKBtq?=
 =?us-ascii?Q?VzlJXUFYqaJUUCfq1tMVLHUEWSHli+z/maVMQ/Wl2I5BYgSZpstfoeoiPfbO?=
 =?us-ascii?Q?LoEDmLCeBY+Xr5rCWjHuytQ6udwH5FX3Y5nJG1HIQXrZb4MgQWouyBjvirqa?=
 =?us-ascii?Q?nHmNQIX54QLlffk/ladPUNKzEayqyOE3/1q/EynuYVb/Z53F/+1TzYlvfWxg?=
 =?us-ascii?Q?mMAvHUlAA2Vldk+vy5leu8Dl0d5zO5GUY6m+KHsw3kSSkjMTUF9wd7u01uqC?=
 =?us-ascii?Q?rhcyUNFLg1TmyRsoOoyUg1+d9kRg3c1KR024aF1+micEZrCaDCnnezhzSSEU?=
 =?us-ascii?Q?2DxFuv1zNnvzL1NI6rPTqnQ5PlmHWNg2Y2cWvNivIc5PnVx5YSw1+0ftZpCD?=
 =?us-ascii?Q?MA0Gfn1wuuoyLl+0qqEs+XMilLfc8khdraPP4OZQbzYRjBNmOGSzSHQubufY?=
 =?us-ascii?Q?LQ+eCCRg3bTYSyQaYktkzRu1IpEVb1ODlnc76O+yYKDkc1r4MZAPHKKbOgkU?=
 =?us-ascii?Q?s8GKXmyKqHAiFLoKMDW5g/Su?=
X-OriginatorOrg: drivenets.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7f9703-6691-4ee4-d0c1-08d962fe79d2
X-MS-Exchange-CrossTenant-AuthSource: VI1PR08MB3518.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2021 10:45:35.6749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 662f82da-cf45-4bdf-b295-33b083f5d229
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fZLXvIeFXNuFHb8SLsm0TpkhokUIMPyYnxQDWLXd0ux6ZLYYPXJGWmFs4gn+BGJa/0wDqe+N0LFEPKEgYR6PPiBDtb/i+ljZYyZosgXoweg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR08MB2941
X-MDID: 1629369938-pNP5C-13Mi_w
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit d3432bf10f17 ("net: Support filtering interfaces on no master")
in the kernel added support for filtering interfaces/neighbours that
have no master interface.

This patch completes it and adds this support to iproute2:
1. ip link show nomaster
2. ip address show nomaster
3. ip neighbour {show | flush} nomaster

Signed-off-by: Lahav Schlesinger <lschlesinger@drivenets.com>
---
 ip/ipaddress.c           | 4 +++-
 ip/iplink.c              | 2 +-
 ip/ipneigh.c             | 4 +++-
 man/man8/ip-address.8.in | 7 ++++++-
 man/man8/ip-link.8.in    | 7 ++++++-
 man/man8/ip-neighbour.8  | 7 ++++++-
 6 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/ip/ipaddress.c b/ip/ipaddress.c
index 85534aaf..a5b683f5 100644
--- a/ip/ipaddress.c
+++ b/ip/ipaddress.c
@@ -61,7 +61,7 @@ static void usage(void)
 		"                            [ to PREFIX ] [ FLAG-LIST ] [ label LABEL ] [up]\n"
 		"       ip address [ show [ dev IFNAME ] [ scope SCOPE-ID ] [ master DEVICE ]\n"
 		"                         [ type TYPE ] [ to PREFIX ] [ FLAG-LIST ]\n"
-		"                         [ label LABEL ] [up] [ vrf NAME ] ]\n"
+		"                         [ label LABEL ] [up] [ vrf NAME ] [ nomaster ] ]\n"
 		"       ip address {showdump|restore}\n"
 		"IFADDR := PREFIX | ADDR peer PREFIX\n"
 		"          [ broadcast ADDR ] [ anycast ADDR ]\n"
@@ -2123,6 +2123,8 @@ static int ipaddr_list_flush_or_save(int argc, char **argv, int action)
 			if (!name_is_vrf(*argv))
 				invarg("Not a valid VRF name\n", *argv);
 			filter.master = ifindex;
+		} else if (strcmp(*argv, "nomaster") == 0) {
+			filter.master = -1;
 		} else if (strcmp(*argv, "type") == 0) {
 			int soff;
 
diff --git a/ip/iplink.c b/ip/iplink.c
index 18b2ea25..f017f1f3 100644
--- a/ip/iplink.c
+++ b/ip/iplink.c
@@ -119,7 +119,7 @@ void iplink_usage(void)
 		"		[ protodown_reason PREASON { on | off } ]\n"
 		"		[ gso_max_size BYTES ] | [ gso_max_segs PACKETS ]\n"
 		"\n"
-		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE]\n"
+		"	ip link show [ DEVICE | group GROUP ] [up] [master DEV] [vrf NAME] [type TYPE] [nomaster]\n"
 		"\n"
 		"	ip link xstats type TYPE [ ARGS ]\n"
 		"\n"
diff --git a/ip/ipneigh.c b/ip/ipneigh.c
index 95bde520..b4a2f6df 100644
--- a/ip/ipneigh.c
+++ b/ip/ipneigh.c
@@ -54,7 +54,7 @@ static void usage(void)
 		"		[ dev DEV ] [ router ] [ extern_learn ] [ protocol PROTO ]\n"
 		"\n"
 		"	ip neigh { show | flush } [ proxy ] [ to PREFIX ] [ dev DEV ] [ nud STATE ]\n"
-		"				  [ vrf NAME ]\n"
+		"				  [ vrf NAME ] [ nomaster ]\n"
 		"	ip neigh get { ADDR | proxy ADDR } dev DEV\n"
 		"\n"
 		"STATE := { delay | failed | incomplete | noarp | none |\n"
@@ -536,6 +536,8 @@ static int do_show_or_flush(int argc, char **argv, int flush)
 			if (!name_is_vrf(*argv))
 				invarg("Not a valid VRF name\n", *argv);
 			filter.master = ifindex;
+		} else if (strcmp(*argv, "nomaster") == 0) {
+			filter.master = -1;
 		} else if (strcmp(*argv, "unused") == 0) {
 			filter.unused_only = 1;
 		} else if (strcmp(*argv, "nud") == 0) {
diff --git a/man/man8/ip-address.8.in b/man/man8/ip-address.8.in
index fe773c91..65f67e06 100644
--- a/man/man8/ip-address.8.in
+++ b/man/man8/ip-address.8.in
@@ -49,7 +49,8 @@ ip-address \- protocol address management
 .IR TYPE " ] [ "
 .B vrf
 .IR NAME " ] [ "
-.BR up " ] ]"
+.BR up " ] ["
+.BR nomaster " ] ]"
 
 .ti -8
 .BR "ip address" " { " showdump " | " restore " }"
@@ -340,6 +341,10 @@ output.
 .B up
 only list running interfaces.
 
+.TP
+.B nomaster
+only list interfaces with no master.
+
 .TP
 .BR dynamic " and " permanent
 (IPv6 only) only list addresses installed due to stateless
diff --git a/man/man8/ip-link.8.in b/man/man8/ip-link.8.in
index 572bed87..e749f23d 100644
--- a/man/man8/ip-link.8.in
+++ b/man/man8/ip-link.8.in
@@ -179,7 +179,8 @@ ip-link \- network device configuration
 .B type
 .IR ETYPE " ] ["
 .B vrf
-.IR NAME " ]"
+.IR NAME " ] ["
+.BR nomaster " ]"
 
 .ti -8
 .B ip link xstats
@@ -2528,6 +2529,10 @@ interface list by comparing it with the relevant attribute in case the kernel
 didn't filter already. Therefore any string is accepted, but may lead to empty
 output.
 
+.TP
+.B nomaster
+only show devices with no master
+
 .SS  ip link xstats - display extended statistics
 
 .TP
diff --git a/man/man8/ip-neighbour.8 b/man/man8/ip-neighbour.8
index a27f9ef8..02862964 100644
--- a/man/man8/ip-neighbour.8
+++ b/man/man8/ip-neighbour.8
@@ -35,7 +35,8 @@ ip-neighbour \- neighbour/arp tables management.
 .B  nud
 .IR STATE " ] [ "
 .B  vrf
-.IR NAME " ] "
+.IR NAME " ] ["
+.BR nomaster " ]"
 
 .ti -8
 .B ip neigh get
@@ -191,6 +192,10 @@ only list the neighbours attached to this device.
 .BI vrf " NAME"
 only list the neighbours for given VRF.
 
+.TP
+.BI nomaster
+only list neighbours attached to an interface with no master.
+
 .TP
 .BI proxy
 list neighbour proxies.
-- 
2.25.1

