Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5D6048F7B7
	for <lists+netdev@lfdr.de>; Sat, 15 Jan 2022 17:05:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233045AbiAOQE6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jan 2022 11:04:58 -0500
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:25121 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229732AbiAOQE5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jan 2022 11:04:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1642262696;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=HF94irPsAfD3550vcKsl/Cbz9fZQiXo/0HVTjj3cBz4=;
        b=cnOesD0ZWOnSw6Xw0n4TuBYCFzBAE+7zyAai0/I6fmNxAX/X/giRyOpjKHgrE5oy5Ypm6X
        JFCesrtyPzbwEJWs9XUMBdfYlWArP2ByAYCK9oJ3KK8RNnORGEeaQJQmP4yGtb4GdVcelN
        t7oJMM2hxx19T8Ecq9w+ZNQS9/jIeo8=
Received: from EUR04-VI1-obe.outbound.protection.outlook.com
 (mail-vi1eur04lp2055.outbound.protection.outlook.com [104.47.14.55]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-29-LG3yT0CHNb2_4iz7ocJtWQ-1; Sat, 15 Jan 2022 17:04:54 +0100
X-MC-Unique: LG3yT0CHNb2_4iz7ocJtWQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZoH4cEhJp1HFEat+shA+Mzh5L77V9W1mp/4EIrNsI/o9fUkB/O7SIieO9yaWSSOrXOFCshh49/MrqOlGK1J26b01ENUdspUbOYWpCF6L4EeA36l8xRUK2e2av2qzyoFYItyTfrAyoAUVCzPleYDKGJKhfxWpGP4BolRilcQT4W/MO8HAISWoI+MnxvgedpgRWamBqKgYm0q5z2Wbem8ajPRErj6Hk1mGHVsWP3JxN33vQKFlKt/wxQvolgoAGg+796QjfmOHOGMsOgH5uvK3MQNPO2w/3RzQIzBvXBVp5x0ta1eOpF6Jv2ptppS4JBRtgAyILvC82RVsJWbqMhK6Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b7Oblv+zbINGrtYu2MhQknCK8e1az9/jg8DcGKxTFoQ=;
 b=LPLg6YFguIxEZWnVec4qF9/vSnbVSLqNHdqeHXO9eQyvu3WPUcAy1LQkr0H0p8kOYkRa9PlQi88TFjFXKLp3HVLDSRqb0Dts1aRJsMR/SCZTYwIbIrejxs2YnLmgvmwWn26Z+amk17BhCwyA0GddhlcJGhJstDkZGvE3SOY261EDEYjH05a3JKATrp1kzAt15ajRkmFwj4OcaiYHslcJHcsq+Pt7tzIpOYNE5Lf6NTJ0LYFylBs01VdBtA+WCVG7n2BMHd/x8chhvLchcxfTAUVgdYKCDa7mBLZgEETZh7p9vUlTmSZLqpnIuQUCunO6JL59GpC97wdRmTEF9E62Sw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com (2603:10a6:7:83::14)
 by AM9PR04MB8588.eurprd04.prod.outlook.com (2603:10a6:20b:43b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Sat, 15 Jan
 2022 16:04:53 +0000
Received: from HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::3837:57a2:45dc:e879]) by HE1PR0402MB3497.eurprd04.prod.outlook.com
 ([fe80::3837:57a2:45dc:e879%3]) with mapi id 15.20.4888.012; Sat, 15 Jan 2022
 16:04:53 +0000
From:   Geliang Tang <geliang.tang@suse.com>
To:     netdev@vger.kernel.org
CC:     Geliang Tang <geliang.tang@suse.com>,
        David Ahern <dsahern@kernel.org>, mptcp@lists.linux.dev,
        Mat Martineau <mathew.j.martineau@linux.intel.com>
Subject: [PATCH iproute2-next v2] mptcp: add id check for deleting address
Date:   Sun, 16 Jan 2022 00:04:33 +0800
Message-ID: <59ec6f5ba44972ef5e7e400f5333852084ff0087.1642262155.git.geliang.tang@suse.com>
X-Mailer: git-send-email 2.31.1
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-ClientProxiedBy: HK0PR01CA0062.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::26) To HE1PR0402MB3497.eurprd04.prod.outlook.com
 (2603:10a6:7:83::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 83b19ec8-acb3-4481-4bde-08d9d840c442
X-MS-TrafficTypeDiagnostic: AM9PR04MB8588:EE_
X-Microsoft-Antispam-PRVS: <AM9PR04MB8588E09BC1A2D9B82059BF77F8559@AM9PR04MB8588.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4+8s8f5EWC8fai6Oyk3SRjGsOuKzWR/NKGRn2Ce/KCXY9ypQ3ghT7Uc3gARNDDi9IrmfbSwlenkLxadCAHeGlbX2Bi/OtquuRTxiZq3aG63PrzCFxcKQ83y+6eronjLBChl9JOKABqkbgQ1TcxijNBgRX153qWLWz8OEq4TKU4N/fyF9KV3Ce5GPhObc231HNwnvg1ayqG9XEGoVagbgKmIyXkwU/ZfIZhBBKOBRGacuZNgo0z7hX7WMTWHCHLjG3iypCyf0/lhiX1rN02KTPlQebFId/usEmJ7pRaO/DBItZXH03MAx9ZVWtj1DNpyMPM+y8VlIGxaHSa9EJr+84O7vD1sdvvD4dcgPNyoWISYiN2rms2xM75vQ9RaU8KHLc362EjqH11S3iPPTdTKlP38WX8O089ZpIPcPE5s0xrOvlJUs64D01il4buO6qgk+Sy+ScEFYBps5BUikdbLI06E/1rQbkdgQ2PZQOnqrEPZVcw8r+jljcBc2uI8rq1eGhp2+iSp8iKwBjQnhQ5cEtKmUNHMqaft8+Iqwpl0G/ior6fxK9bwsrOWZDDxVIKl6kIyg3GJDrC/S9TR0azol6Lr2+YRq2V55R9AJRIhE/BYx2IHyNCNZmWuAgZvsowk4M6Dau/MDOCQ20pw5sk1Ohg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB3497.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(8676002)(8936002)(83380400001)(2906002)(38100700002)(36756003)(5660300002)(6666004)(186003)(508600001)(316002)(2616005)(6916009)(44832011)(86362001)(66946007)(66476007)(66556008)(6486002)(6506007)(6512007)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EkDx26XZsbydCti8fgDWSbExYFPgZseHAfUitv6DXJqxUE6ibwb+y8E9QSzy?=
 =?us-ascii?Q?22OV+u0bGDp8Z/AZ9Cpw8X0IJVzWJmMOXZm2gPGNJ1tSSiJAQMO8r35yQPwx?=
 =?us-ascii?Q?qDaUa4fxicctyULU24HDKXyFmoJHCVn9cRCkjEawC2j3wjyuKVZOxDoK6TAd?=
 =?us-ascii?Q?2WQi4AfVa2Ioqs4jFHEzemNCvZK7yntwDJ+8wZZteXrtfgmaYgR+HJMQdLBV?=
 =?us-ascii?Q?DOZO7FAzob8ngYixPiTIu2XOCc5LDO6BTl21ULSfKPqQW7WrEVB8WjJm+6NJ?=
 =?us-ascii?Q?Xfh8Ux+J/F2VmP80MEPtrU8xAy1VuiEZIWwzxE8gCew6vJMVTGmv7T4NwyFk?=
 =?us-ascii?Q?IVp6wbCHjnzm0d44ed8wowQMtkmISP5nCyeDGxwav8e5UFhqgPdAcmm69y5i?=
 =?us-ascii?Q?GYmErDH/X79QNOtE9dOO7DdQiortcZt2eKuexRVfNttyr7A2qtKQZVsCkXUg?=
 =?us-ascii?Q?CBKQX4oPOBK0F5IzlD9p8bpZZENCRL1c2nOV715/RZ2QwlK0QrYPS9ZzG426?=
 =?us-ascii?Q?X9flWCyw7kM/O30aIYidiXM2ZvNe3ga6m/0U1uBBuuLPR0Av8QjcLrDhkr9E?=
 =?us-ascii?Q?dDk9+jT70oGa8S54Yjm0F62Bzu0OQgyqeEKoALbW0NpuB9dqgMESOvV8ec8y?=
 =?us-ascii?Q?/bUr0zUeUxOD4jOnG28QVVLKNNPSMnGwPxrK4KQFzok6KTse7XqqVdcGTu9v?=
 =?us-ascii?Q?+nk5kGvTHHALKZI7Un6FtLO1uVp00I6cw4BlUSM/mFTMbdWJNEut3kWA3Vk9?=
 =?us-ascii?Q?j+U6T3yuuUQQAL7DZuE6MLECdTr0+dfef7rx/8gs21AIF5e36IeB/5z5ZlEf?=
 =?us-ascii?Q?E6N52OBAadVJrVrDAGiiwG+u7pWiZ6E/vIGKW4+ixiRRFpzLIK7dCy8kYJmC?=
 =?us-ascii?Q?E2TW9oEqU73jyHobw3hhRIw96vXDfiu+mKnyauImpJPnP/3y4hmBrCeL2wZa?=
 =?us-ascii?Q?RlTsOqglIqC5S9EKzHo2BqS0u5mRPdVUDY+9d12xDuvM4TEGzcHY6wENquyu?=
 =?us-ascii?Q?SOWq79IW+/CXx0hHGNUKBECDle6brwoQsNAaUax/YzYbYEjQM85hWADpTall?=
 =?us-ascii?Q?UJSX26XMDn4duAhW4uuA1+2nx6GtCX10O4p8Ip89aVguCcv2ZFhuAJPVolty?=
 =?us-ascii?Q?QJrniEDvIvGpZgsN3jwkrl38Zkw7bbnKY0RyNCXuEZLWRGHKk1daTnqIB1bS?=
 =?us-ascii?Q?Tb2cGPUnCfqNItqakg76qzRkUfRbGTEP+trs0s7G+wWl02p50UQmlNHSsiwW?=
 =?us-ascii?Q?5hGKwdKUYFwOSK9cZNRrbBi+XyXiHD3oPmoLciftad5A/1/a7QPaHNUaJLpk?=
 =?us-ascii?Q?5MVkN8SLVe2sCcfYHv+n+wCU9pQHonuVPAjrll52+7FOGVeZARSB6F3l8ylS?=
 =?us-ascii?Q?GplDTmeS3AeuFiPRKZtIDzwAClrEyuaufaXO+fy2+rIvX1+5zih7WN+oIB0i?=
 =?us-ascii?Q?ijqAEVk/2NLf7q5GAQ352Rgyj1q8ZKfrg4NoiabN9MR48d527bDklSARySq/?=
 =?us-ascii?Q?aIyv/RWKMSWPqmgnYgfEhXdqql0nwk6d3SD/I2jxyNIbz2ybwERquDskIIKm?=
 =?us-ascii?Q?WbG81uK8meDthmwynChq6A7lOGj7p/M9C31ttvLcXMQzvjTKw593HICGatGD?=
 =?us-ascii?Q?hciVQN9Ockk0VIV19T62fMzyF1EbdMhlwiUoe9sECzxMpuAhOwc/0Ah9GfRt?=
 =?us-ascii?Q?Lkuc0cxxLtdyfOm3oCFWMriA3qM=3D?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83b19ec8-acb3-4481-4bde-08d9d840c442
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB3497.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2022 16:04:53.3540
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: S08MCNDOhIMyYzGiohWpATZYg6z2qYWegNWEu4dzS8cE0+iEl8GxI4EGLXrZzMFocp1xOBoi6oRJ+4UR8CxEyg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB8588
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch added the id check for deleting address in mptcp_parse_opt().
The ADDRESS argument is invalid for the non-zero id address, only needed
for the id 0 address.

 # ip mptcp endpoint delete id 1
 # ip mptcp endpoint delete id 0 10.0.1.1

Signed-off-by: Geliang Tang <geliang.tang@suse.com>
Acked-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
---
 v2:
 - drop the Closes tag. This patch isn't a bug fix, no Fixes tag needed.
 - add brackets on the 'if () { .. }'.
---
 ip/ipmptcp.c        | 11 +++++++++--
 man/man8/ip-mptcp.8 | 16 +++++++++++++++-
 2 files changed, 24 insertions(+), 3 deletions(-)

diff --git a/ip/ipmptcp.c b/ip/ipmptcp.c
index e7150138..eef7c6f4 100644
--- a/ip/ipmptcp.c
+++ b/ip/ipmptcp.c
@@ -24,7 +24,7 @@ static void usage(void)
 	fprintf(stderr,
 		"Usage:	ip mptcp endpoint add ADDRESS [ dev NAME ] [ id ID ]\n"
 		"				      [ port NR ] [ FLAG-LIST ]\n"
-		"	ip mptcp endpoint delete id ID\n"
+		"	ip mptcp endpoint delete id ID [ ADDRESS ]\n"
 		"	ip mptcp endpoint change id ID [ backup | nobackup ]\n"
 		"	ip mptcp endpoint show [ id ID ]\n"
 		"	ip mptcp endpoint flush\n"
@@ -103,6 +103,7 @@ static int get_flags(const char *arg, __u32 *flags)
 static int mptcp_parse_opt(int argc, char **argv, struct nlmsghdr *n, int =
cmd)
 {
 	bool adding =3D cmd =3D=3D MPTCP_PM_CMD_ADD_ADDR;
+	bool deling =3D cmd =3D=3D MPTCP_PM_CMD_DEL_ADDR;
 	struct rtattr *attr_addr;
 	bool addr_set =3D false;
 	inet_prefix address;
@@ -156,8 +157,14 @@ static int mptcp_parse_opt(int argc, char **argv, stru=
ct nlmsghdr *n, int cmd)
 	if (!addr_set && adding)
 		missarg("ADDRESS");
=20
-	if (!id_set && !adding)
+	if (!id_set && deling) {
 		missarg("ID");
+	} else if (id_set && deling) {
+		if (id && addr_set)
+			invarg("invalid for non-zero id address\n", "ADDRESS");
+		else if (!id && !addr_set)
+			invarg("address is needed for deleting id 0 address\n", "ID");
+	}
=20
 	if (port && !(flags & MPTCP_PM_ADDR_FLAG_SIGNAL))
 		invarg("flags must have signal when using port", "port");
diff --git a/man/man8/ip-mptcp.8 b/man/man8/ip-mptcp.8
index 0e6e1532..0e789225 100644
--- a/man/man8/ip-mptcp.8
+++ b/man/man8/ip-mptcp.8
@@ -31,8 +31,11 @@ ip-mptcp \- MPTCP path manager configuration
 .RB "] "
=20
 .ti -8
-.BR "ip mptcp endpoint del id "
+.BR "ip mptcp endpoint delete id "
 .I ID
+.RB "[ "
+.I IFADDR
+.RB "] "
=20
 .ti -8
 .BR "ip mptcp endpoint change id "
@@ -107,6 +110,16 @@ ip mptcp endpoint show	get existing MPTCP endpoint
 ip mptcp endpoint flush	flush all existing MPTCP endpoints
 .TE
=20
+.TP
+.IR IFADDR
+An IPv4 or IPv6 address. When used with the
+.B delete id
+operation, an
+.B IFADDR
+is only included when the
+.B ID
+is 0.
+
 .TP
 .IR PORT
 When a port number is specified, incoming MPTCP subflows for already
@@ -114,6 +127,7 @@ established MPTCP sockets will be accepted on the speci=
fied port, regardless
 the original listener port accepting the first MPTCP subflow and/or
 this peer being actually on the client side.
=20
+.TP
 .IR ID
 is a unique numeric identifier for the given endpoint
=20
--=20
2.31.1

