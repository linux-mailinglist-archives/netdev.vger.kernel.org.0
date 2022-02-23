Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 320574C09C7
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 03:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233316AbiBWDAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 22:00:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237629AbiBWDAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 22:00:02 -0500
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B03B53E29
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 18:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1645585173;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PkeatfizrXQIJ99/tdPYpVW3OtCAmWZ3EhQ+jqvxDUM=;
        b=KQFGbucKLFSheGXOu8H1TydoOpSn6cDGgJvaMxqJOpvGpOCXtcd36ieeDqOfYlIh36fRNj
        Jzj4T47d2xQsnE2VOIiKNIWYKvWOmuEhr5tQUs/qf+jVH3gBhM2/bHsKhn4V1bg47ntGNn
        KO8Wxy1tQOjNMHcZZQrNBYlwJP4ffXc=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2050.outbound.protection.outlook.com [104.47.14.50]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-7-CtdbpbtAOk2iPBXiD_dBgw-1; Wed, 23 Feb 2022 03:59:32 +0100
X-MC-Unique: CtdbpbtAOk2iPBXiD_dBgw-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ndf2iJwmADvpSHKOca6KSWw9IkQH5id9ZuGiVWyAYqwoMAEv1V7oKLTZPtKrAxgbb42l0mWtwWoB65ubsicOchahrCVUdgNvRbOjxL06o+bM2oqajo52/aM5PgiJPJOFSQVuzgrpwDyssQMagrMd3BDEHHagjjqpC0V8/1f0087C8yKSC5+sLjJugPHowXSMiRrMHEg6frCLjVLZHwWuPjAXLIAwuW8tBywYZ1HVohyE2WMU0pgfcy2GGLes20M5svLFL7isxF+7g+QAz+vFCyu0ojm8gjNj8M6fAnDJ6kMrNFeaiq1vbr7PspDnXc4I9Ea2mgjjGLxnSObJgsPkiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V08zv6rkhHHKj34mR7Ygn/4fZ3xuwHPdv/RprAC6dWw=;
 b=I/dfgxmplyRw6XXtGC2DLtdbD6ZAHy79xVd5GpzOuKz+R0avrsLCZH4quQ8uLssQp1HirTjjVn+W91gVW5JE4ncMAezqp+67xfvXZuRn6PrL2CwmUYDKEGlU4hYI6EM7plHGn08tByclgNffhPs2ZkYygAjYxF9DHPbn2c81JvnH7XFMJpCTJO05tq/MsHjSvxOqkeJ26x/MHsVmOP8toA9aymT9U/YVFXlxvySvKX/6q72NtlbOW4cnXOylvQT03Ts072E+qybSROFztS0E2bPXeovF+1wLuPbryVKdte8IwSKLLsDinS6uFXz7nE3FMX3xUfyZtffroOyWHc8DsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by DB8PR04MB6362.eurprd04.prod.outlook.com (2603:10a6:10:106::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.22; Wed, 23 Feb
 2022 02:59:31 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::60de:f804:3830:f7c5%4]) with mapi id 15.20.4951.019; Wed, 23 Feb 2022
 02:59:31 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
CC:     Geliang Tang <geliang.tang@suse.com>, netdev@vger.kernel.org,
        mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next v2 1/3] mptcp: add fullmesh check for adding address
Date:   Wed, 23 Feb 2022 10:59:47 +0800
Message-ID: <295a693ecc4ec1c3c241db0999d97d8718b7d992.1645584573.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1645584573.git.geliang.tang@suse.com>
References: <cover.1645584573.git.geliang.tang@suse.com>
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: SG2P153CA0011.APCP153.PROD.OUTLOOK.COM (2603:1096::21) To
 HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eace7072-53ca-4842-b375-08d9f678836f
X-MS-TrafficTypeDiagnostic: DB8PR04MB6362:EE_
X-Microsoft-Antispam-PRVS: <DB8PR04MB63624944E07E48C31658566EF83C9@DB8PR04MB6362.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: twX50DNqW/5vrkSwPrG702QZPMkA2SDPGpIsMxV/v4UBTrVePd1Fzw4SuJKsv2EH13WUsatGIp8FxabegUEq8kSvC1LbCMFGVc3g9o8cen1518OqOYkrLaCNYOrSxKRtA7XmYuOqEzKwBerH4Bt9RMSlNJLIsobNZ5RdF02x0R+940l3iXpoA8W5RN6wD8QfAgXrWMf1lvIJtR3g+Gnt9YsvtnCw9pi/VlLFvn009SasHQMInAup4nbi3camTRG0LUolZzUJ+mWN1KSkzEpbvP2WCI6vBblEd5U+5whc1lMssY7D5oyvAdapRxxy0mRBKrW0o85OfeOgS7G/wp3m3hpoBTKnO5N6gh69z5qQQXzlVZxsN+nwR0ORuiV/REyumeqVJCR8zVYBblscPHmq0RzJ3wBgzuXpSTC3fklA5YF0bBen6FxtHxCR1ZmNxOMDbuMIFCT8gd4pgZ0OEhpC9yQkDe01WaUemgPFFeWIqimc2Y0MKRZ96fQfZbGfdIgNQ6GgDJnlPYYc1AFjlmT/OL71JrhMvjpdVPER0UG9OeqAy3BEcKRI3P+l4vKvQZCvfPvQZPH/HZwSRIeZvYXcIbLvNB0bHOpmfmj1MfPCYZV8E5yiiHr4H+4OTzL8bTqXy/7Bex4MKVbZmToT23aEpg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(186003)(26005)(2616005)(36756003)(44832011)(4744005)(6512007)(6506007)(55236004)(110136005)(86362001)(8676002)(54906003)(4326008)(38100700002)(316002)(5660300002)(6666004)(66946007)(6486002)(66476007)(66556008)(8936002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?LJGr24j3Zy0z5paP68z3/3MnPklLU2PxTPjywA5zeqQuvL0wj4ATzyrtgHD1?=
 =?us-ascii?Q?6XKAtPBpEN1IMpgBUoL54cDXR7ysgYjwm3ZapgkAFy8B6nRNAYotXz2ya48p?=
 =?us-ascii?Q?5TrVvjqDBL45R4jZfius6eTt3Vl8V+MTC0DG80jqxXNZxHAxxAY2Fo1mFdc9?=
 =?us-ascii?Q?pdFuRitQ2Q1QQ9IEscUiQNBzhU7CAzcv71E9Q1RGeo3jWonCfq4Irxf/tAiG?=
 =?us-ascii?Q?v9lDHuRHLCUiVyef6VAjXyJgBSVP1mADXrMXtlqty2AuEantaKeBjlyn2LrL?=
 =?us-ascii?Q?nHEroMxhJ1osTDbfFFgSCujTkkwTd0icy8gMWzROz+hl4QAtETohMleSUjtB?=
 =?us-ascii?Q?XisQ7DNmGG8HkKRlzgvPv/g/fqc05NWb7Z5pBsHE/xBS/8IcT+QwLi7eWjm8?=
 =?us-ascii?Q?oneLc345u98rBbp6LeQQOA6MQv8w8YWLbDlfSoGudQLVU+lelJM1pG+Nvo8e?=
 =?us-ascii?Q?BMyYA0rz3NPumKVAH9ZEys/p7M8czqf8Gnec0jTFXG3vvCNf95g4/xTdQlW1?=
 =?us-ascii?Q?jCGiAglKuL8RCZ6XyWDG4p3dk583T6+mfoaTAbtrjULnFm4Auia5WPxCG70q?=
 =?us-ascii?Q?v90mX0DVBsw3pfGomU6DbdJx/HhFHwYFviXM6m8UOJYpLAgXb3m79Ferb5A7?=
 =?us-ascii?Q?F7zgfmyb98ghg7bLWvp7AtoHSO/NoWVq/V2D02R95YePoJYgwkm6328gr+0B?=
 =?us-ascii?Q?YgL885Fiydr4nuSlOP8zs/QNyeVS2ZJHAkIN9tI3tncPo/dYZC0tmptH9rLO?=
 =?us-ascii?Q?JTUyKBn5ROUyiNA2/5liBRSWO8wuH/AMz5ArnNuppNByO2Tme5uGU+ZHvPSX?=
 =?us-ascii?Q?aYJKZ6uOCIu6imR1dF6koEsaZ1DXdAHb1lIiJPnDGYC2MNrrUlyoz6a+IYKY?=
 =?us-ascii?Q?d/9rLUXNZRiRAfWVfyxzPZLdNJcpCwVWC70tVuNHDK01o3dmPQGQ9irZdD1n?=
 =?us-ascii?Q?NYiGHXD2Dy9e1gzYooyvg1dw1yqEh/NI3seg1saz06NTm9KpTJ044pOI5KeD?=
 =?us-ascii?Q?G8aS6dvrz+LSZ30byfDBzv8y3ZP1UMAozHks0nzXkI3XOopTf6tweyeA/1eI?=
 =?us-ascii?Q?DIRDpkgRnEOFGs5cpKoyoRUGiok1dU0hyclIT5Jep6+o2pUN6vdbOIv4cS+2?=
 =?us-ascii?Q?dsTugsCrdpZ2HG/iVocwu4lLyTxBTpU4Yl/2Gt9TdhUfbCjXPRWvzU3gVdkM?=
 =?us-ascii?Q?12XpBJUYn/Gys23MoXX+0b3Y9r/WlfVv3q4x8VvBvs9joIQMdcgB/tqakBaW?=
 =?us-ascii?Q?jWTuMAj2FhQSZxCv1V+t2x8dIGLiJPbC5Zm0v/z6t2bblHiv4XaxK4mO3bKN?=
 =?us-ascii?Q?HMkGo/t39AIzG6SoS6RJnUJ13qzl8Em1v10ON752h2WcMsqnaZXEFk67ZT4W?=
 =?us-ascii?Q?ChXg28hOtROPARFYKqtszh9AOtjdqLMOiMg5s0QXgnbIUuw5AhNSDxzu261y?=
 =?us-ascii?Q?aLyLiGLJixuNENKaW1OdwlAtRhMY5Ack3B0ZfBM0BBlBxDrGu0izi8+pMN/w?=
 =?us-ascii?Q?6QBGiHfDAaCi/D3fmylq5BB4kagu+3vDlILzsmfav8DLFzUmVAtLfziydYM7?=
 =?us-ascii?Q?iPgaRrDTpD1U2POPPWotCpffzPeoQhNG05zdQ3nGjYj9iEQ9yeXMoLO3wPnE?=
 =?us-ascii?Q?tyZfxLKvJiqT+WMaa9y9oSU=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eace7072-53ca-4842-b375-08d9f678836f
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 02:59:31.2373
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jJoQJ4dGtGored/ogDSNan9ePI35SoVasw5Gn0HevNQEyMPs7uTNmzv7hcVpPk8269TICAKbqMeWi2m2SFWkyw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB6362
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The fullmesh flag mustn't be used with the signal flag when adding an
address. Commands like this should be treated as invalid commands:

 ip mptcp endpoint add 10.0.2.1 signal fullmesh

This patch added the necessary flags check for this case.

Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
Signed-off-by: Geliang Tang <geliang.tang@suse.com>
---
 ip/ipmptcp.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index eef7c6f4..0b744720 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -116,6 +116,11 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 	ll_init_map(&rth);
 	while (argc > 0) {
 		if (get_flags(*argv, &flags) =3D=3D 0) {
+			if (adding &&
+			    (flags & MPTCP_PM_ADDR_FLAG_SIGNAL) &&
+			    (flags & MPTCP_PM_ADDR_FLAG_FULLMESH))
+				invarg("invalid flags\n", *argv);
+
 			/* allow changing the 'backup' flag only */
 			if (cmd =3D=3D MPTCP_PM_CMD_SET_FLAGS &&
 			    (flags & ~MPTCP_PM_ADDR_FLAG_BACKUP))
--=20
2.34.1

