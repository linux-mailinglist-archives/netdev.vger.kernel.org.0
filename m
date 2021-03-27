Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028DC34B766
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 14:37:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230242AbhC0Ngj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Mar 2021 09:36:39 -0400
Received: from mail-eopbgr1310128.outbound.protection.outlook.com ([40.107.131.128]:40304
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229582AbhC0NgR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 27 Mar 2021 09:36:17 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jjuctOTdTW4bDsoeq60pHsuvCmwCBj8xlAr0UnkVisPVHY0ewyaldpMdq5JpCSXDsuYt+yQiX5o37Ej1YHxpEKsdCXRi/gkOC9g+vo/Y7+G1QBJa1945VQf07TfBy+r9oxQ4Bt1C7jf87SJfoDq/sgM3yKnPY0MTOm1v86LTpo9HsztX17KkDCuMYxQ66G1YmO9vokH6eiUa8tDSfkpIHi6A02S6/peUjJe4mZqklmNVLXKdhznUrPb3CHIF7se3e1lbBBQ4NclNW8qhQkrgOG+wJUzi+QfFVKlx1KRSMehi5TnsApDjB0ArRIbWv5M64usMWJqZRB3fsDc0wpBS0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sA3Q2RtktY19gJICSZX1D8OJ6QbmvZmlZkl+6XKAWO4=;
 b=MnG09G1mRn7oevujT6vvtMn8fKuJRlK63DBuLurHbkXwERZIc5eQgifruELPclb7lY1FDUbe1n0AqVQd1rye+XjOpQZN6XZRSQs+zX2rZYb8euXzGBJHQzf01KbOpZR2/JXjpF+F/O0olRTgP115xo2HqK+AXxosKwDo9ooYrDVEtparO+8+/bJqAEORZ4kFBQlv1mcQscCWNDHJ2EihTZ/8SxQnpvXzwgkgbY7C8qCCx6x8ymCKI+KeTLdySD3Mkl8Vm1/1YTOD1JAv854dEkk+OyhAz11T5uRM4DnBnEJ0YLghqijQaGU9Nb6SGsRRLpOF1H9+K/W8K7DzTPMt0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=zenithal.me; dmarc=pass action=none header.from=zenithal.me;
 dkim=pass header.d=zenithal.me; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zenithal.me;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sA3Q2RtktY19gJICSZX1D8OJ6QbmvZmlZkl+6XKAWO4=;
 b=ZFGt8GeFvRxAS0YUPsKeECeN+xF6IUjQFtIlG5Nzex0ldiSSnGYUyF+imQmNNKLfYlO+XnE6NFYVxCheaED2kl3IiJzLTmf1K1io9MlBhOVrYqe9Sg816o76FsKNVc7YKt1x4SFCYgmmAv+WskjDsRiOi+SQ/RPid4y9eG4bou8=
Authentication-Results: networkplumber.org; dkim=none (message not signed)
 header.d=none;networkplumber.org; dmarc=none action=none
 header.from=zenithal.me;
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com (2603:1096:203:3c::10)
 by HK0PR03MB3155.apcprd03.prod.outlook.com (2603:1096:203:45::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.19; Sat, 27 Mar
 2021 13:36:11 +0000
Received: from HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::8492:e28e:e777:6d05]) by HK0PR03MB3795.apcprd03.prod.outlook.com
 ([fe80::8492:e28e:e777:6d05%6]) with mapi id 15.20.3977.025; Sat, 27 Mar 2021
 13:36:11 +0000
Date:   Sat, 27 Mar 2021 21:36:07 +0800
From:   Hongren Zheng <i@zenithal.me>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] iptoken: Add doc on the conditions of iptoken
Message-ID: <YF80x4bBaXpS4s/W@Sun>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Operating-System: Linux Sun 5.10.19-1-lts 
X-Mailer: Mutt 2.0.6 (98f8cb83) (2021-03-06)
X-Originating-IP: [2402:f000:6:6009::11]
X-ClientProxiedBy: HK0PR03CA0104.apcprd03.prod.outlook.com
 (2603:1096:203:b0::20) To HK0PR03MB3795.apcprd03.prod.outlook.com
 (2603:1096:203:3c::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost (2402:f000:6:6009::11) by HK0PR03CA0104.apcprd03.prod.outlook.com (2603:1096:203:b0::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25 via Frontend Transport; Sat, 27 Mar 2021 13:36:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d3e3be83-1a5b-4f7b-7d60-08d8f1254882
X-MS-TrafficTypeDiagnostic: HK0PR03MB3155:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HK0PR03MB3155DC467134DBF2DB612E9FBC609@HK0PR03MB3155.apcprd03.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:935;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7KcuIk0kDvDdhwSfPgQan0SlqhpXadYaDrcKfh474Mm6MdLdTUk0D09x/Zyh03lM+LXF47QlKgFwkr7QeaF23EhHNbCNnDohlc7NghG2i/ahubBlw6rnEh7UcDDp/wyPUb5VcQBwQgLgIczdMWYcsVMxoX04V545g86h+NNf0QZmpgGKD6WF7C41lB5hF4IqvoQoLqWIJiqgdo72n/2P+jQXHpaqsPlq8YZmfaMsxkcHWSTLt7ia1Ed1yFuxS3gBulDvaX10UhpjQRdzbITUpfa5dKyU3fCWnqm9AEsNeXuFoWx/CtdwMcJn4CknWmaaaNkJnt5opP5LGgZzLHoo1crXfLbxlYgdZKnMH+38RLzuzzvbUhs0JmXVPx+k31omyxWOUF9ydhHszUopd1C96dY5nfLzV8ydNhqyHwJGb60JEFlzrY18ukxcYbfyCwmdcgk6eeQHHswJdewH/qGCr8lJMf5tMq/RcSO6n8GD2m4spS6iNc5RvKn4jsVWE2+AW0y1tX2EQsks+Q5gKU+ezhzityVwAIBAhhQ8DkpzoKYbs/nv7smCV/Z0QguExlfp56cULAcgkywJ6WdT15R3XZCDsVUtGZYiHUzDDRyCUlBLY0FK9XlAAENVaWUCQRKV8yhJX7R/K7HC0su+nM8o0v94S7SYNqMUkhme2XXtbwI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR03MB3795.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(346002)(396003)(136003)(376002)(366004)(39830400003)(66574015)(86362001)(16526019)(2906002)(52116002)(66556008)(66946007)(66476007)(83380400001)(478600001)(33716001)(110136005)(186003)(4326008)(316002)(38100700001)(5660300002)(8936002)(6666004)(6486002)(6496006)(9686003)(786003)(8676002)(49092004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?hRLohLEdlCUXIoDgQzwyAtfS3mWz5b6ZqCp0nTi85nWMwKIQHZUmQ37zfzcY?=
 =?us-ascii?Q?8RJ9H79wdRHOYkQ8dBZ2YytQ3S05lX6Yo8vvOAwAVMng+Dn8c6ynaFZf6wmV?=
 =?us-ascii?Q?LGggdAg8vPsysZEpEyDJzOlNq5EhAru6ju2xEOtHNJ1RzWSYn/GHwC9XhLNT?=
 =?us-ascii?Q?2UyJBo+4bZ3N4Z8FfPIHq5lk6laCQkmFVxhAf7OjAc9s/bQ50dc+68UPw3SJ?=
 =?us-ascii?Q?sHCKxKNoAn5a79UJJk1L9/4xc/GVh9vThyIz1bwunrNHwGp1znoVLG54ZfTk?=
 =?us-ascii?Q?PKgesBdHmySqj9VC9SVWk490d3Jw3560ebv7FHXwEi5xisL8xLxK0IUXLsrA?=
 =?us-ascii?Q?qEIvxvzcaX7HrwJK2yGKC1aP/LzvfPVvOYpW87Dw1W7qyhxPQkTnzhE2u0DZ?=
 =?us-ascii?Q?juDvE8/M5NjCtHuiDb5W2QIVZqT6IYd7Bz4Ty2oauIvJ64p1X1jSteKMKW0z?=
 =?us-ascii?Q?6wgNRU4UTg0AQ0Gq5pcvPlmKLgQClpAn1mdTU8Pto+keUd6D9GCWmXVcrN2h?=
 =?us-ascii?Q?Pzi6oroZXcTpibOV9RaCmOt/cPRtOJSs73u75Cg6geuvmgL7PXm9Wonr4bLp?=
 =?us-ascii?Q?o12Vz/zlLxH+o0LjwdAuTMUnqhsCS4rFHoVn0P6rg6uT9L3NkT4mtDVHZMLF?=
 =?us-ascii?Q?gAadNIPpsxgckKA4L1qIFJlq6LcCIvtZU3AcdOST+vruQk9MJgCuyOfnVfRi?=
 =?us-ascii?Q?lXKRI3sP84iA2z0VpEbAGFRaA3NL3e9T7aMRlpilAh1HIlxre4xsKS5vcaBR?=
 =?us-ascii?Q?0/uwt5ChciiYVizfr44N+/cNW7GRbilpqUI2+EiChV1Y6cMKth9cC0IYWPvj?=
 =?us-ascii?Q?2JnI0ztxw/8xTtRABkLK7d0EeaKlBrvO2O4YYCebEhE3lTidSVVCIjP7nxPf?=
 =?us-ascii?Q?aYqqyB/+j6vEtE2ZNTBvXWawIGhv3GAa/G0H0K0+aOB4cbGDPIlBvcMtuXmK?=
 =?us-ascii?Q?nb2y4XmTPwJoW3t94K+EnCBWVoM4hOjKfoHHohrsOTABFwEbVt3fpDQ/kG6u?=
 =?us-ascii?Q?Z4aDG84SrjV3Hb9yzOeRfPw7rhvGOP1m8lKYLSalEc4SVBebPybrIp4dfI1n?=
 =?us-ascii?Q?N9FOnugCjvTlLAKApWHE2s+Rj6R6VaB0+aLXGMs+iuReAAomiqzxPKQU3Ewl?=
 =?us-ascii?Q?USFQ8bqGmCB1moLAy8xtLhbtJG6e76+uM56WRmH1clEREd9xRhQX6zOmmYAn?=
 =?us-ascii?Q?NE6WdVLQbV926vMovzj3owvARaV+SA+YDfh3hN53rJ5vPII1Vyx+jfNv1AK7?=
 =?us-ascii?Q?Lwg7cUuN7b55uyZaMBHzJndGbc0qIPIjofng2V+fES0HNHL9s5g9cQyM+hit?=
 =?us-ascii?Q?TKq1mdc2KUcftQrlY5nZLlX7HnQ29tLRhqsa2fzzuAKSTg=3D=3D?=
X-OriginatorOrg: zenithal.me
X-MS-Exchange-CrossTenant-Network-Message-Id: d3e3be83-1a5b-4f7b-7d60-08d8f1254882
X-MS-Exchange-CrossTenant-AuthSource: HK0PR03MB3795.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2021 13:36:10.9158
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 436d481c-43b1-4418-8d7f-84c1e4887cf0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fPwu45DmIHa2bOOP1CRhW0XRfhiB627KyTjnvRyX4itpzqqnIzFxsxuSidda2fAY
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR03MB3155
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

`ip token set suffix dev interface' may be unsuccessful
with only the error 'RTNETLINK answers: Invalid argument'
prompted. For users this is mysterious and hard to debug.
Hence a more user-friendly prompt is added.

This commit adds doc for conditions for setting the token and
making the token take effect. For the former one, conditions
in the function 'inet6_set_iftoken' of 'net/ipv6/addrconf.c'
of the Linux kernel code is documented.

For the latter one, conditions in the function 'addrconf_prefix_rcv'
of 'net/ipv6/addrconf.c' of the Linux kernel code is docuemnted.

Signed-off-by: Hongren Zheng <i@zenithal.me>
---
 ip/iptoken.c        |  4 +++-
 man/man8/ip-token.8 | 24 ++++++++++++++++++++++++
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/ip/iptoken.c b/ip/iptoken.c
index 9f356890..d56fd68d 100644
--- a/ip/iptoken.c
+++ b/ip/iptoken.c
@@ -177,8 +177,10 @@ static int iptoken_set(int argc, char **argv, bool delete)
 	addattr_nest_end(&req.n, afs6);
 	addattr_nest_end(&req.n, afs);
 
-	if (rtnl_talk(&rth, &req.n, NULL) < 0)
+	if (rtnl_talk(&rth, &req.n, NULL) < 0) {
+		fprintf(stderr, "Conditions not met: 'man ip-token' for more info\n");
 		return -2;
+	}
 
 	return 0;
 }
diff --git a/man/man8/ip-token.8 b/man/man8/ip-token.8
index 6505b8c5..ac64eb66 100644
--- a/man/man8/ip-token.8
+++ b/man/man8/ip-token.8
@@ -67,6 +67,30 @@ must be left out.
 list all tokenized interface identifiers for the networking interfaces from
 the kernel.
 
+.SH "NOTES"
+Several conditions should be met before setting the token for an interface.
+.RS
+.IP A
+\- The interface is not a loopback device.
+.IP B
+\- The interface does not have NOARP flag.
+.IP C
+\- The interface accepts router advertisement (RA). To be more specific,
+net.ipv6.conf.interface.accept_ra=1,
+and when net.ipv6.conf.interface.forwarding=1,
+net.ipv6.conf.interface.accept_ra=2.
+.RE
+
+For the token to take effect, several conditions should be met.
+.RS
+.IP A
+\- The interface has autoconf flag turned on. To be more specific, net.ipv6.conf.interface.autoconf=1
+.IP B
+\- The router advertisement (RA) has autonomous address-configuration flag turned on.
+.IP C
+\- The length of the prefix in the router advertisement (RA) is 64.
+.RE
+
 .SH SEE ALSO
 .br
 .BR ip (8)
-- 
2.31.0

