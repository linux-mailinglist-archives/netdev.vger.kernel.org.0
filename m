Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 690564C0CC8
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 07:50:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238470AbiBWGu4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 01:50:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238300AbiBWGuy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 01:50:54 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.111.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9A76E352
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 22:50:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645599025;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=czTWBunkqDmTRriLhyIwr+8oCa80d/cjHM2qiQeFaQ0=;
        b=g7g7zVp7TWgcgKq8X17MzAb8aXJguczUa+C6JbOXBZZIMZaDIKOvVfrl3gmoQ9WUZr0yht
        1fglP69hoT2BXOUFFRQAze/XxijdjDGW2SyTDHhfnSu4AMPb2F4pSL+4UeKfdiXu2CUJ18
        2SluKzHk+VoUkhAh9Dsp53xu+GXVU9E=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2056.outbound.protection.outlook.com [104.47.14.56]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-30-9Esq5DRtNoiE3WwxiJbFGA-1; Wed, 23 Feb 2022 07:50:24 +0100
X-MC-Unique: 9Esq5DRtNoiE3WwxiJbFGA-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N1RDpTyu8y6WiUtU0VNiuhaKJ32hFVNScla3XfLGYKTsC43gbzkJXH/UqeSP6dHHTBkW6Wm8JwTk9cuhIRhLZSEhdr0+qIHJrW7TCFMtBvxtd4gT3pBahU/fQXFdfEUEUE34TsjiEJ0APVR3zEBVMZ8sBZgYBd/24b1gQ/VG9/RZS0Bd8vimjSYwMhGWAxU+DNNhAFfM8qNCFIIR/BgSaZfFdraRIqekh2LzVVnlWKca3S2FoYGrAsigZUFESNT/fX+fq/HRtpvprQA54z7H8ObbQBkutwkdjlHuZNjfCVC0x3qfHcAoattO7keAuAqs0aAppFYfqQ/kHppRvrRpcg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ju2fSRW1SBCGia72GzaiR3aeymKl1j5uwTJNPBbH+GU=;
 b=EQworsiUHxDFx4DneNdygHVKlJQdgzxprouk56j3Zr689d2c48+0lU3VPuK1Wsg1i8xG43Y4gsaVnVWO3BkNcPWEek+yme7eYsJCFNeqINSEO4n9UGEdrInCaG/MXk3tdAJ9eNAVQ10G9X3CisX6wGyc0HOzlKVP2s9wWFonCBXei3CEkNisSXs13cW8Nii6H58doY+w6/AZCWzdoz5I0RuqFgUIRKFV623+lXAr1DkZAf+XeWd5sXfk5vlHDluWkSTDFNk4UGk1+/m+/bFEtGaYT7L50OdF/7gurOch3IYrXSWmlFPzontzKzBtPrtR5R89qjWIOXp2Oep6rw0yEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by HE1PR04MB3290.eurprd04.prod.outlook.com (2603:10a6:7:20::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.21; Wed, 23 Feb
 2022 06:50:23 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 06:50:23 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next v3 3/3] mptcp: add port support for setting flags
Date:   Wed, 23 Feb 2022 14:50:39 +0800
Message-ID: <18bb653925ebd903715096daa5e86a2e81c3dff3.1645598911.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1645598911.git.geliang.tang@suse.com>
References: <cover.1645598911.git.geliang.tang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK2PR0401CA0019.apcprd04.prod.outlook.com
 (2603:1096:202:2::29) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e1669484-e339-40ae-7804-08d9f698c3fb
X-MS-TrafficTypeDiagnostic: HE1PR04MB3290:EE_
X-Microsoft-Antispam-PRVS: <HE1PR04MB32908630E14B602A1150CF99F83C9@HE1PR04MB3290.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tcYJspK39mWf+QhOjvhnr07hIDvi0LKWzcHbl6BR7yXm02twBEMavZLJhrk8wxKzvevPufbbCji49y4UefH+647a3kYUj46ymKF73wuzof8jqqIPhpWacySXoGdH2YAFgQ2SzXIeEOWjWR7hbNUOSMLy+gJG+T14lZBBQAnZdQatYZInu5gKyY8GyNXfiPzYKUs+ggKtp2zZOATShlBKz4XvcF+FMKBXAcTgOo+UXRFnu08aE0j9uaDBiHnQOlrU0N+FEg6OYXXtpXLNU5NgY0+y1EC4UYlUPmaoCv1sjUSigR/79fv0xqfpbxU2HDIfO7ymYddRs7+EbQ3EQj/e7ZVfynal/qlrB3PZQM3Ns9ZIhvV0n7JDqmTaK9m27rvaRD8/kIO7gsrhXIdRAILLyC9fOFiEc44Qrwb7wdw5Mk6aTqiNRzYGqCG2zil8ZjGikLgaO05tm1qLbdj3GylBDtMCnwncE+AwSHr3iCG+2NzYgD50XQvgymcpygWMvY4fULK7WbZOkbr0r4FlyiBP8EyMNIfZeddsw97rneWyokFAD57oIOTBFT3Mp18m+cxS93CC3Y1OjnKcSqTLo9WpftlpsExm+PS7WQiTNhNPPPbxn56j814XlJzAHYZ9ao84O2yfbuifXtcexL97sLQDPA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(8676002)(66556008)(44832011)(66476007)(66946007)(38100700002)(86362001)(4326008)(5660300002)(8936002)(2906002)(36756003)(6512007)(83380400001)(110136005)(186003)(26005)(2616005)(6486002)(508600001)(6506007)(54906003)(55236004)(6666004)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?efVwhImxXGIiUnCUBc+2sMnpalH+2On3p7lHrm9LbhavjviZ8VsIInTdj6XT?=
 =?us-ascii?Q?jG4iG7Xomc3yAJoPnIZq+jjBcetkmsvKvSpzE6T0ftYgrOOd1pZcKn4GwAs9?=
 =?us-ascii?Q?EbjIqknE+TeRpeJAZZJbj/2cLnZMA1WKBGxOlQgcTfZMbIT+ghONsTCXT3rw?=
 =?us-ascii?Q?rvTdwFQwVG6uxfgH9P56/A1o85znsF4KK8pruNQETG6kElqiQcJ5dO8y40aA?=
 =?us-ascii?Q?lcLlmMVHAHArAZZ0ObW/ikeVQqjB2nvEdXWAe+tx3IGLRp/74hBm55CuIIDI?=
 =?us-ascii?Q?1Z6m7IbM5nkxAgiYpvcwZjsIfFZsU+Yom6ChcsO2WgatHO/ryuDDc/Ss/MSt?=
 =?us-ascii?Q?iBHS5H3iohShvAkT8+RsRYRSzb3dugZM3iTovBW15s569Fsrn/iTrwX41eDP?=
 =?us-ascii?Q?kCJpnwphaBWjhJR122w0C0Xud+dlVcc/84r/EBLMsLyr/DdE6u9eWh39bSQD?=
 =?us-ascii?Q?FxJZ41ST/i0przv0Ke3xjrOuvLtHuR0sFufrAUq693L2Ru1w0nMER+4KxOTG?=
 =?us-ascii?Q?yPg4fkknhh+0QhrZJrqKJm1w+LOnVRl5LcgFFLHy778o1ClfwgNhKxcS/J34?=
 =?us-ascii?Q?b2IgP3iAdR7/GCd+xJD1ZObHTHCqJ1YHeYXWx79aMZhUZQrAsPJD5bmjFdns?=
 =?us-ascii?Q?+7wfCPQah2uaQpp3kXlx9JBVlYQiVHOgrGYVpwLEFOiiJNb6bHFZLsPonZRt?=
 =?us-ascii?Q?0bDEfChHtY6Tb4mcCymP+TQZ9fkzqUIKIy9iVDiHtoRHfVoPTa/xvcUwtVIE?=
 =?us-ascii?Q?ClFmCs1F0DAsERq3DN2pzJHpO7wnX1U5CbAXLLWozsNIMTsUBnNG/MjJ7Gxs?=
 =?us-ascii?Q?tP1faH1fiJHT03PF4C867xNd0sykl29lKEB5/ofR3dkTwyASGY7hiGL4IdwT?=
 =?us-ascii?Q?kOYbHDLmy9vAUtq9gAIiufP+9PPcrl9S7OVTwO33X+4YSQHY81U5DZ/ptmCo?=
 =?us-ascii?Q?b/yXWeSKtDE23RRLrPVzhghnP6DaaSlL+S0sLDhCEJ6dwU/JRIWaTflVH/KU?=
 =?us-ascii?Q?hONKfJhQJXes6xcMbQ1A2G8JPkUbjKSFLKke68lGavw+uxwgN+YILL/lap4H?=
 =?us-ascii?Q?51lS+cPq3f2eqbeLDaHFqgmTaIpIX7z5fcZ8rq60ZqMiHDqm6Ny368C91nsG?=
 =?us-ascii?Q?AlcHobOGykXTWNMnuAvDaMQNrfLyeOiktWCfZWlj/nmh3TMt0KgNP/ZHr85/?=
 =?us-ascii?Q?Xb4og4e6oT2MuRms6L6fxtGpYIqBDYVyZuUohiKVGhSUY68/bZ00kFhTaa8N?=
 =?us-ascii?Q?HWx/czUXRn/D8GcgrwYlq54SPbeLzC2owOLmp2EPoL9Lhpy+xIdlyS366XJA?=
 =?us-ascii?Q?VYFBQ6k2KjLjE4nhyP7MCPWZbJa1cIKoPlt/2Nec8d9QB/LZ/W9ZSnOmgEcH?=
 =?us-ascii?Q?ieDhlMlM8mxwvYBwPjBZSGV/8Xd0G4SXNMGkkgWTVgRgjKoFU9xb2xGv4d21?=
 =?us-ascii?Q?FbQ+YxOn3IVvir9cTbiwevtH1SHAQExrRiA5b3QWu1Fv1ZcRN/fmFoBB8kYB?=
 =?us-ascii?Q?B5OCBem2l7PwQ/sl0UhrCElKl4KGUyX8Lryoj6YuTTFp/ZnYI0zGvN90L4i6?=
 =?us-ascii?Q?oTWYa5j9BGBhbZMtC5iuVCBfabombInbLGOaSVTuTfYtL0XpvSI/VAHh/Otj?=
 =?us-ascii?Q?BzECuCvIFiMj4ITh926rcSY=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e1669484-e339-40ae-7804-08d9f698c3fb
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 06:50:23.3916
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Wm+6iIfxi/E7lfEQiSxfWNzBRyYC466rhOeF2v/LiLOipK7ejSR1v1Gd7h6mLySe7VmNPRizhJA6Qxon6eWx0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR04MB3290
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch updated the port keyword check for the setting flags, allow
to use the port keyword with the non-signal flags. Don't allow to use
the port keyword with the id number.

With this patch, we can use setting flags in two forms, using the address
and port number directly or the id number of the address:

 ip mptcp endpoint change id 1 fullmesh
 ip mptcp endpoint change 10.0.2.1 fullmesh
 ip mptcp endpoint change 10.0.2.1 port 10100 fullmesh

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
---
 ip/ipmptcp.c        |  7 +++++--
 man/man8/ip-mptcp.8 | 11 +++++++----
 2 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index c7b63761..0033f329 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -25,7 +25,7 @@ static void usage(void)
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
 		"				      [ port NR ] [ FLAG-LIST ]\n"
 		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
-		"	ip mptcp endpoint change id ID CHANGE-OPT\n"
+		"	ip mptcp endpoint change [ id ID ] [ ADDRESS ] [ port NR ] CHANGE-OPT\=
n"
 		"	ip mptcp endpoint show [ id ID ]\n"
 		"	ip mptcp endpoint flush\n"
 		"	ip mptcp limits set [ subflows NR ] [ add_addr_accepted NR ]\n"
@@ -175,9 +175,12 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 			invarg("address is needed for deleting id 0 address\n", "ID");
 	}
=20
-	if (port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
+	if (adding && port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 		invarg("flags must have signal when using port", "port");
=20
+	if (setting && id_set && port)
+		invarg("port can't be used with id", "port");
+
 	attr_addr =3D addattr_nest(n, MPTCP_BUFLEN,
 				 MPTCP_PM_ATTR_ADDR | NLA_F_NESTED);
 	if (id_set)
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index bddbff3c..72762f49 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -38,11 +38,14 @@ ip-mptcp \- MPTCP path manager configuration
 .RB "] "
=20
 .ti -8
-.BR "ip mptcp endpoint change id "
+.BR "ip mptcp endpoint change "
+.RB "[ " id
 .I ID
-.RB "[ "
-.I CHANGE-OPT
-.RB "] "
+.RB "] [ "
+.IR IFADDR
+.RB "] [ " port
+.IR PORT " ]"
+.RB "CHANGE-OPT"
=20
 .ti -8
 .BR "ip mptcp endpoint show "
--=20
2.34.1

