Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7A2B46E7FA
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 13:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232748AbhLIMHc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Dec 2021 07:07:32 -0500
Received: from mail-eopbgr60116.outbound.protection.outlook.com ([40.107.6.116]:51182
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229598AbhLIMHb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Dec 2021 07:07:31 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ohw88Oe5AoFh5m7FKWEnm+QuvZ8Nlc34l//LFnhnKTIsA9Iqvyiq+F5ugbQeC5EL6uQXND7EDTsDBK4DMevPIKKjmMgFbwgIVmDkECEhpno4+FlqZQyw+vPIlaC2KvPJvYgWjVmYgsCusSik6VTfTgpWQDy2xGNpuS3QB48mB1jWheG0CHWsHMRNW4UhHk2uf4DNg1bIgXxDbDr9nzHUYrvL7RC9KUj0W5l6hnc5eFYYHazJyCYmNjnYdee1BMvhh98YP7KWjPJxd3oYSrQ9+U/37fUOfTfQJhZr6AmRyVRqBLxl6X1AHTqh+sceeXL6i102lZpFePJ8hHi1SgkGKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nwMLfFyqQnSv0z0o8KJoNNzPoRxT/u/ByKIO6MQMuIk=;
 b=kkLJXmH5XIS7/0F6LNQP79AJrsJALkJ9g1DnR5qBvss5CEoEuhdZc4Mn8gSMIFspfXRt2VeGmGPoFt7wfDZmwe8UksWmqliS9nEP1bpybbFOPoQ2HZM75uVqonnkQmVwDI5aj0EAqYZzi7kAJjPVWJdLaI2QV9BfolYiXs0WQnYBKsc/S25lH75L4ernIZ/9odNyUaYFqgdhAZXREfMxwEK0XVib4ifwvWxMXZuTOuWm0f3Xzy35C4pSncgpnXtrR1i5TaPp06BvoBM3TC7r1iiHUytM9NA89UC+70L79zwd8ZnxOev+KEevj5Dzc+Kt6nUioR92rYaxhiQRtNNnJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eho.link; dmarc=pass action=none header.from=eho.link;
 dkim=pass header.d=eho.link; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eho.link; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nwMLfFyqQnSv0z0o8KJoNNzPoRxT/u/ByKIO6MQMuIk=;
 b=Ug0NDhE8jY+lOrBg09Ic+GSHqxbn4a7j3fqTfn4J5CY4ledI9/54JaaqSu1ZBjZkdp34mM387+3QLBByOzlXPjgji0cQIguvSshUgb7KXJX5ixLFJWB1v+uqbOqbYUZtCwWhdRvfBqaWV1neBYQBtlQ8aef4EpyHfvb0+ZjFT3r7ZUIS45n1MVr4qQauLtWhQGQO1CmtXsFehQXc1SrqqfaGdROSa8IdTHL+c53qLt6JRfSLio0LsvuYDdUaSezLRgLugqES/DXcKZuu9oUPHOJ+mGGDzXo7v/FNuAjraR2dQbgoQbuzQD1YPa00bcygDvv7yykeDGSEX1QqYgiM5g==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=eho.link;
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com (2603:10a6:10:26b::20)
 by DB6PR0602MB2774.eurprd06.prod.outlook.com (2603:10a6:4:99::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.21; Thu, 9 Dec
 2021 12:03:50 +0000
Received: from DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a]) by DB9PR06MB8058.eurprd06.prod.outlook.com
 ([fe80::4cbd:de68:6d34:9f5a%9]) with mapi id 15.20.4755.022; Thu, 9 Dec 2021
 12:03:50 +0000
From:   Emmanuel Deloget <emmanuel.deloget@eho.link>
To:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Emmanuel Deloget <emmanuel.deloget@eho.link>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v1 bpf 1/1] libbpf: don't force user-supplied ifname string to be of fixed size
Date:   Thu,  9 Dec 2021 13:03:27 +0100
Message-Id: <20211209120327.551952-1-emmanuel.deloget@eho.link>
X-Mailer: git-send-email 2.32.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MR1P264CA0132.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:501:51::7) To DB9PR06MB8058.eurprd06.prod.outlook.com
 (2603:10a6:10:26b::20)
MIME-Version: 1.0
Received: from edt-thinkpad.office.fr.ehocorp.admin (2a10:d780:2:104:f0f7:4b65:dc50:47a3) by MR1P264CA0132.FRAP264.PROD.OUTLOOK.COM (2603:10a6:501:51::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.20 via Frontend Transport; Thu, 9 Dec 2021 12:03:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3d116bd1-e80e-4388-9dd6-08d9bb0bf67e
X-MS-TrafficTypeDiagnostic: DB6PR0602MB2774:EE_
X-Microsoft-Antispam-PRVS: <DB6PR0602MB277487BD22DB9D4320687884FA709@DB6PR0602MB2774.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z7T+JFLguwQE4CPrtaCjHrnsUudgYrr3KP6NSEn/pjTgYjXYIT4+N3R3Rn6jR/QP+9AfS2Dj7wyOf5ydEBrKJIFtNQcmLp+C+vhcLSjKlzOJNGhV4ju+xKyacEmwTuDqYUR4eMB1xJOl1H5pTU5NLlXEVI7qS5XFtt2UaWL7LdYbBgTwdD5wYVnQWzHB672iyfEYLplHlZrlUy5PzEwgU7YVxm9JWyJ+QoiKrSgUR4J4Im+d19oli40tQhjDtPo1uZDobNChXg5KgbJHdhu7X8suDJzMkxxohxqfndpLY6/6jD5vvpRPBatJd4o7+cW5uDJ/aQMBhB71gl1oojJqGMPUDTDHMywKH35hHmhc5DZUhv2/ghIFznwTD+shQw+IbUlltYOanrOCHtYjVV10q3+F3BG/g3oDh5b4RTkDy7dzp0au0qgCnjUv4YkLpXHq6lfP+CKc6RFg48eDbjMuXXPVhw9Zw4HHTKgzS3FmNbJg2CBo1ed8IsIaPK2ax1cnnTMYQu4RqKvLpB91AGAVS4VuIy8mGk0FjLipapYGo61lmgFBRlvDT7zS9livEr49iB+TQSQkkI1ae+f5QjAZophDvy/9ARDAvanFhN125POMCJaMI20/VF1pbPp65veLB2EcLtDlv+6CnKzxDZR0iTkBhzJMgPDjSxMiKZigFxHMHg6Gyg991l35cED8pOyalxrxM5QaGgSMRUnxSuJp3w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR06MB8058.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39830400003)(346002)(136003)(366004)(396003)(4326008)(83380400001)(110136005)(6666004)(36756003)(2616005)(186003)(5660300002)(7416002)(6512007)(2906002)(316002)(6486002)(8936002)(6506007)(921005)(8676002)(38100700002)(66946007)(66476007)(66556008)(86362001)(508600001)(44832011)(1076003)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?DckJWghHJV5MqkM92XUfQfU32qGZVyDcg+ErnBSPvFb5BiFRJpuEptFhL0Hk?=
 =?us-ascii?Q?k7vemN0uakT43ScJiwil5oMNCaPOR+umrPFBNlZeEos155dWUjw7psr6p2fO?=
 =?us-ascii?Q?GQbdZTIrqcbTtw75iQBYnnj3bxEDunP408RxcDBrGq5m8i/Jh9X7rARfs0Lp?=
 =?us-ascii?Q?rPhQDB2Kk32bMZ4yKVUYOYnvDdrcEqtuRBXagCKB11Pl74dxMjl2Cc9AJlFN?=
 =?us-ascii?Q?fvBnLteWCcBaCNySTrrKVcR7LdUjilcwNUKc7ODgs1UOGBwRTf7jwo+LBy5G?=
 =?us-ascii?Q?1RjK2tCh+ETTDFhI3BS9jI8PKDYBOTOHJNIHW/CPVtOjTnP2jKxU3ni/M8Gk?=
 =?us-ascii?Q?XolWeoOhEJctb22vvT6pT8JfdnrJfS5mRgId4lAJ1V5BnWx0T7vghkE0OnWl?=
 =?us-ascii?Q?UvMhNKOppwcwuieru2JVvis038zII1c3pk12TUYrOC4KtsXqclAs5zTfeSyH?=
 =?us-ascii?Q?afwAe+xIRFsDA9YBeCA/AX+teemGBiahHHjqPmLkvVgYt0LCiBmZPFa2E1L3?=
 =?us-ascii?Q?d4g2gFZz9CiM6EcNxq/cdLk0VQT4/Wtn8DvK+jHmDJyKHUxQkFP9K7fFLP6a?=
 =?us-ascii?Q?+Fq0Eq1TGUOVprWKA+FOLB/3BhA/AyeOUBObqDcQQwWFziFM2qP4fEixSoKC?=
 =?us-ascii?Q?uI7zvtSueuVwbNsfhoGId7Xq3hU7CRj8gwisWxa5M/Cr8FonRYxhNLZ+y2CJ?=
 =?us-ascii?Q?LiZeQFw9T8HBhaxYpx2Y2oEJdTH8kN6Bo6DwiAlVXjB+60prPCDL+IJEH3yo?=
 =?us-ascii?Q?02bqyQY/582sFUkaN53GgkUSi/uBiSZpbXnOLajAbjTLlPF/s22zSfCSxeLI?=
 =?us-ascii?Q?FKMnBY8g1UfW6TLoN8YOXwsMHMqHsopnX3Q1wdZkUDZhhAvOZwCmAp0ZXlcY?=
 =?us-ascii?Q?wPSyiNQG/JQjbIi7aOTvotmVw/p/uJuEAkwAxmN//yEKcgUf6q9Q8eQuP2F7?=
 =?us-ascii?Q?bof7e3xpgdaZLIahVhocAhLNV7OdpJIYg3YJlyC/1chSbj0XdsOWhdkvlqA4?=
 =?us-ascii?Q?fd/k7udt4O8a1s2UCC9JG5OYqkb/k9MgzSAtksgWzI/Aj+3q3oSF4/hYKrby?=
 =?us-ascii?Q?hvauVNsulfg8qbV4qTHo7IaE/olwmDBuotVDR2xj7R/ApONhB89IL9asBM/5?=
 =?us-ascii?Q?PRgdxDWTn2lSd9nXPWgQt84wJcVcVzVU+eKsl8Efu+IWX1CRgRFJupI54AAH?=
 =?us-ascii?Q?3B4+sZ472dGEsrXfD8gM4QfXCUgsjeLWQLaPsbNX3ZHX6gGSxFq8bNTMFzzY?=
 =?us-ascii?Q?nG3MRZ/xLaNAAeKgdm7SpAZc4RQDDh61DnR6jMqpnKLESQ3lqAyoWf0xaT/O?=
 =?us-ascii?Q?7P/L9N2PzfXCJ/jYOO6CHS517V2y0Ty7dNt03dDTdavROkAidOZI+ofYAZQN?=
 =?us-ascii?Q?TzEoEXBJiNgZ68Fb4IFplZZ4kC44mZ92XcwFHgYvKdFOAslATKOQh8jvr6/H?=
 =?us-ascii?Q?UorEosAG1UiabmF2spSM6jVvoAxAU5fXKIPx27F08MCgqhokKIpbtg8iWK7b?=
 =?us-ascii?Q?2F5vy5APJSlRcNRbwcJ4jX3So2KHhkZ4bENC6HMSy0J0S0YiflY7jEXGEl/R?=
 =?us-ascii?Q?w/pla2XxC0EJfBpYZ/kesRNXZaiRM8SnuwlzcKc/L8sPLChs0FA/TEWcnxt7?=
 =?us-ascii?Q?Yc0wBLsS9g1oMcZcjPul2DHimAAMTbY6FkxHcpjz/h18N3n4d3HIBlOhDhSv?=
 =?us-ascii?Q?KT0B7kMhAZ2gmsA0bD0hM4luAniyyhcBvHcx6GWmiDw1VzqY7bTZWRN+zSOW?=
 =?us-ascii?Q?NNBHRxZTDg=3D=3D?=
X-OriginatorOrg: eho.link
X-MS-Exchange-CrossTenant-Network-Message-Id: 3d116bd1-e80e-4388-9dd6-08d9bb0bf67e
X-MS-Exchange-CrossTenant-AuthSource: DB9PR06MB8058.eurprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2021 12:03:50.5417
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 924d502f-ff7e-4272-8fa5-f920518a3f4c
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pSh9nvs6RUwT7LJ/JoV0Eni97YZEWpaZUsZ1Pntnjt5EPIg4Hqs79cz70qT3U+G0CmbmOCd+/0UXkB3A6WdmT/RmKAp9QSsiWd6zJ0YR6po=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0602MB2774
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When calling either xsk_socket__create_shared() or xsk_socket__create()
the user supplies a const char *ifname which is implicitely supposed to
be a pointer to the start of a char[IFNAMSIZ] array. The internal
function xsk_create_ctx() then blindly copy IFNAMSIZ bytes from this
string into the xsk context.

This is counter-intuitive and error-prone.

For example,

        int r = xsk_socket__create(..., "eth0", ...)

may result in an invalid object because of the blind copy. The "eth0"
string might be followed by random data from the ro data section,
resulting in ctx->ifname being filled with the correct interface name
then a bunch and invalid bytes.

The same kind of issue arises when the ifname string is located on the
stack:

        char ifname[] = "eth0";
        int r = xsk_socket__create(..., ifname, ...);

Or comes from the command line

        const char *ifname = argv[n];
        int r = xsk_socket__create(..., ifname, ...);

In both case we'll fill ctx->ifname with random data from the stack.

In practice, we saw that this issue caused various small errors which,
in then end, prevented us to setup a valid xsk context that would have
allowed us to capture packets on our interfaces. We fixed this issue in
our code by forcing our char ifname[] to be of size IFNAMSIZ but that felt
weird and unnecessary.

Fixes: 2f6324a3937f8 (libbpf: Support shared umems between queues and devices)
Signed-off-by: Emmanuel Deloget <emmanuel.deloget@eho.link>
---
 tools/lib/bpf/xsk.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/lib/bpf/xsk.c b/tools/lib/bpf/xsk.c
index 81f8fbc85e70..8dda80bcefcc 100644
--- a/tools/lib/bpf/xsk.c
+++ b/tools/lib/bpf/xsk.c
@@ -944,6 +944,7 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 {
 	struct xsk_ctx *ctx;
 	int err;
+	size_t ifnamlen;
 
 	ctx = calloc(1, sizeof(*ctx));
 	if (!ctx)
@@ -965,8 +966,10 @@ static struct xsk_ctx *xsk_create_ctx(struct xsk_socket *xsk,
 	ctx->refcount = 1;
 	ctx->umem = umem;
 	ctx->queue_id = queue_id;
-	memcpy(ctx->ifname, ifname, IFNAMSIZ - 1);
-	ctx->ifname[IFNAMSIZ - 1] = '\0';
+
+	ifnamlen = strnlen(ifname, IFNAMSIZ);
+	memcpy(ctx->ifname, ifname, ifnamlen);
+	ctx->ifname[IFNAMSIZ - 1] = 0;
 
 	ctx->fill = fill;
 	ctx->comp = comp;
-- 
2.32.0

