Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A86E394248
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 14:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236103AbhE1MGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 08:06:03 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.111.102]:25867 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233666AbhE1MF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 08:05:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1622203462;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=16lo1IsvGVqr9AbvTlh2HpIeWCqy7ImbHeZZu7vMPxM=;
        b=gH63Yy9XP0t2tJAii2D5n32bSmgq92QZPdlVo+Z3mwaaU49tW9KNSOhBXw/eSn2mWxxyiZ
        mE5F+pChlwXSp4edRL2kPLuhiJm9UkS+mhbHOPbCVdUMyRk3azxppBkLjalCSDHxHdIsFL
        5gR0aNHQv6DF7eCHsEHnon5eVqR4jLk=
Received: from EUR02-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur02lp2055.outbound.protection.outlook.com [104.47.5.55]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-14-ML_79f3WN_6rSxnbVLZjUQ-1; Fri, 28 May 2021 14:04:21 +0200
X-MC-Unique: ML_79f3WN_6rSxnbVLZjUQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NCQqbfTxGADRseNB8nBNw9Hedhm/KtySFlFDW6GBNnM4GOrkP+Wed70fVuGWpHl2Bz5T3rbE6L63oljqd0dn3+1jtjNU4r9DtCtGQgXgKPtTW0QwnZ+y/Ep/3ElRWtGWcWypT9TfPmpnC29WzhX2HNNcpFRd8qnclQt8Jr/jdITbGzv+5FZgzOoNMqFxAr18UJhMLotLYROTEhpnT4qfYrsJALbZCpzXUDkUq8+PQoAncBOl2lpOSTne0J6b98lm4WijtPpLVT/BsJEtDL98sCPhNotX3Npz2NKbIleoAmOI5jhhGb9Wng/L6pYzf72TLIlLP6dk9zHj+gONEqJF0g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7LefQYld3EmNE7aeof7DIjrxTMyKRMCp9e8rIiVj1bM=;
 b=BReIo4jVayQ8w/CaeO/nN1J27D0XR4TX/Hddafrmu5wowlRD0jFqR1EaKGKi3RhHFi+KSlcO2djBUJz4rtSXANeZ2dMTQxEkliGkpPqpCh+tvEty6fQgx5ZOV5xB19Xw6STsgF751NMUsisS9fW/WGGBaikvuN2XwIxIgspIA4yrUG7kvSUBD+hNP1wlCODaGzUbTtKXkO7kD0xpvIavvK1atTD7JVL1R3Ftm+z2o0c4nmVx3m7bivT5Qu724L2P5JbpCFJQsYDWB06oeKZgwEFVs/O0W4pGDKC09ARhiaiaUsgojUGVakkPcs9xnQVE9AVB36+agqipUGD8IPOToQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com (2603:10a6:208:128::18)
 by AM0PR04MB7059.eurprd04.prod.outlook.com (2603:10a6:208:192::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Fri, 28 May
 2021 12:04:20 +0000
Received: from AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d]) by AM0PR04MB5650.eurprd04.prod.outlook.com
 ([fe80::756a:86b8:8283:733d%6]) with mapi id 15.20.4173.020; Fri, 28 May 2021
 12:04:20 +0000
From:   Varad Gautam <varad.gautam@suse.com>
To:     linux-kernel@vger.kernel.org
CC:     varad.gautam@suse.com,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        netdev@vger.kernel.org, stable@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Florian Westphal <fw@strlen.de>
Subject: [PATCH] xfrm: policy: Read seqcount outside of rcu-read side in xfrm_policy_lookup_bytype
Date:   Fri, 28 May 2021 14:03:57 +0200
Message-ID: <20210528120357.29542-1-varad.gautam@suse.com>
X-Mailer: git-send-email 2.30.2
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain
X-Originating-IP: [95.90.93.32]
X-ClientProxiedBy: AM0PR10CA0080.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:15::33) To AM0PR04MB5650.eurprd04.prod.outlook.com
 (2603:10a6:208:128::18)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from xps13.suse.de (95.90.93.32) by AM0PR10CA0080.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20 via Frontend Transport; Fri, 28 May 2021 12:04:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 87e7b353-9976-47d0-d437-08d921d0b975
X-MS-TrafficTypeDiagnostic: AM0PR04MB7059:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB705976B5D4B6FA2F3C629317E0229@AM0PR04MB7059.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 86/RKQczWSw9xCDvCeLm3DA4fzhK5C1JGkPG4hRZrZST98gFh/Ze+erKNF2eCk8tXOQezj3kWsxzjDFB2UnogHB/16G5bieMfwA9Tp2OHJI9HnU+8Oy2MhhqZmuNoY3HU2g0tx/1fZnlacvX5/MNR64dpH4jWmdizJbdx3uCyBuBrFf4X/BQsgrD61kjfTAk2nxNSLi8PZCtzOKffbWeqm2r1oV1PtMdr2J6v2YR3zretO84OPmgW2WrOdU6tSWRPm5glF+1EN3c7EzcOXof20NY8HnLOpbLPboArGm2ejpflIVb2s1BLwlYV93GNHx0rjQC0/eAu1cZVI2BQW3hdS2RBGP4d0E7tGBDYG1YImbkJqPXARgCWNo27OvtYju6kKfgmTiXeo6mJ3+0P06bWAJ8hIWmevMIUZLm0SLIzR+ytZJJgkHjrrO7RLaxqtCtMLlQ+bwVHiKmAkR36xvea2xqPRao1eBxI11JuGcDNTxFfRCEa40peoHFlY1cNnz+DTyDp5amF5BJlbar/FbBh0pFHuDM/1onpY3MsfToDwTjA6B/fiqMqn1PHKV3bF3sNPyUBMgoUfzMX4YG/ooDp/uHoCQxi9GBnbDPk16b9ZP3/MUNLyfVyxyLfJzTqTA0LSPngZQaFpOBytBJxbRwhg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5650.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(366004)(376002)(396003)(346002)(1076003)(478600001)(86362001)(38100700002)(38350700002)(26005)(6512007)(54906003)(36756003)(316002)(5660300002)(6486002)(52116002)(2906002)(956004)(2616005)(44832011)(6666004)(186003)(16526019)(6506007)(8936002)(66556008)(66946007)(66476007)(83380400001)(6916009)(4326008)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?w6O5X6Q5JVFCoaKLhaf6nqgUV0nfaKgx1xV6TNH5XRs/WQJqiqrSSnX4fc9M?=
 =?us-ascii?Q?gvUSRcmzCr+Ma3TJKV5MtdGPGHOEZN9EjUS3djoQ9HcRmCk3nngSehNZGnbp?=
 =?us-ascii?Q?g1S0EvMH3iYxCgBMYk2Z4nw/5bw6rodwjnNvpgaIMS0ZAHRYt/yt6qd9hvJB?=
 =?us-ascii?Q?AruatLyzsu8EITT2bJYs02omsaymnJ/NSFZPaRrp2nSiZDagmzdXbPjirwtj?=
 =?us-ascii?Q?Srv2mQqlw8HvtqHWHmRLhxcU+QvKzDWh+SS5ZLqC7JZJ0HyJwyOZu2xfx+w9?=
 =?us-ascii?Q?fTERXn1rWv1RRXrIO2L6pTxB7YwIEJ5dasxr8MIezFLMuQYOk6agMiNC+qIZ?=
 =?us-ascii?Q?2eIMtMhdjQgTIf7qhBs6IGxn3eJoeiak8sC0DZnFtK01HI7SrRxy737tv2YC?=
 =?us-ascii?Q?QIBooHn8UadqlJAdyxxkkVRHTVTeIAmNfvfnAhWhU8XDHtYImwkQa9wd1H9i?=
 =?us-ascii?Q?OtkzAKuamADl/ipWQnBMhMFFqrS3AARTupm5uieK/kTLgU9Vv/6zAUYvlgBz?=
 =?us-ascii?Q?JLpy5UkkhDvSv0ZQK/LdQBETHfY3fcEQKuNPl/5VslONnHI321HJtU2lU9v1?=
 =?us-ascii?Q?rhWb8DzOCapTPFTJnFnwqElYOwEROdFniK7Ic+uYW4iCVCurluO8mhedApv0?=
 =?us-ascii?Q?yu6TColfnqnlCrFgYztCkiOVriY+umrO+wtZUCvFxmoBA5H7jTQn/uS8Xc5C?=
 =?us-ascii?Q?5q2BKiMfW2UU2rgxTIiAG3HzXh5SDhwtNz6R9/yMXwkpE2UmX7HC0rcNUZbe?=
 =?us-ascii?Q?Xq/DlQEgi/1gwiDcfsLGfzi3tcxu23AQNXcfkcf9nYJ3D2Ei6GDqHUaLZZb2?=
 =?us-ascii?Q?cdhGDb/v5jH4Cs4mXyZ2Q71EqxZrAjo4uZZWg2Qa/fNKkLPO3E5xzyj6gtaW?=
 =?us-ascii?Q?0NdX/iJWgrFPTvlT3tkAWEnBu6Ms8a8M7fOXdNX1yY91p29PtO+sMpUfZEZq?=
 =?us-ascii?Q?OeDPZ9Orypl/dDRguLpZ97b0tHOLTpkukzGahriacB18UUPvJ4eGgH0o04Pi?=
 =?us-ascii?Q?9GhG8QUW1LgQoJNhIjsRyjkx+5eRlLgHO5cUoGgK067gBjX1hJsdaHBCh4HM?=
 =?us-ascii?Q?rw/DVnmivpm4jszmUgoayo8UGUDBjC615kEL/l8LcMNnSMXuXXlOik+FuyT6?=
 =?us-ascii?Q?duikWmHFBoWBuqEX6JdYPzRhiGo2jksZIG7IMc4aLSMw5Pb90YveQfY6n1IM?=
 =?us-ascii?Q?pn+MGqWA284yoCJYb9riubKeRCtg19+G55rUs21kDK0NBV+1chU73E6k0/YN?=
 =?us-ascii?Q?4pjVGZuClmP/b+Syjb66iTvoIuKhAm1TgrSQ8Wn/uitQ6UuYPV550Yv3NkFe?=
 =?us-ascii?Q?1p8AINntuBat5WPE5wtG8sMA?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 87e7b353-9976-47d0-d437-08d921d0b975
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5650.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 May 2021 12:04:19.9356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h9a1xSD+j/KlgHVWHTij673nU8MEGfzK0Lfs5YuTCUQwpBAx9Z/fi93ZHvkUN9P6eZDuW2YmOCjSc0mdZoGLhw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB7059
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

xfrm_policy_lookup_bytype loops on seqcount mutex xfrm_policy_hash_generati=
on
within an RCU read side critical section. Although ill advised, this is fin=
e if
the loop is bounded.

xfrm_policy_hash_generation wraps mutex hash_resize_mutex, which is used to
serialize writers (xfrm_hash_resize, xfrm_hash_rebuild). This is fine too.

On PREEMPT_RT=3Dy, the read_seqcount_begin call within xfrm_policy_lookup_b=
ytype
emits a mutex lock/unlock for hash_resize_mutex. Mutex locking is fine, sin=
ce
RCU read side critical sections are allowed to sleep with PREEMPT_RT.

xfrm_hash_resize can, however, block on synchronize_rcu while holding
hash_resize_mutex.

This leads to the following situation on PREEMPT_RT, where the writer is
blocked on RCU grace period expiry, while the reader is blocked on a lock h=
eld
by the writer:

Thead 1 (xfrm_hash_resize)	Thread 2 (xfrm_policy_lookup_bytype)

				rcu_read_lock();
mutex_lock(&hash_resize_mutex);
				read_seqcount_begin(&xfrm_policy_hash_generation);
				mutex_lock(&hash_resize_mutex); // block
xfrm_bydst_resize();
synchronize_rcu(); // block
		<RCU stalls in xfrm_policy_lookup_bytype>

Move the read_seqcount_begin call outside of the RCU read side critical sec=
tion,
and do an rcu_read_unlock/retry if we got stale data within the critical se=
ction.

On non-PREEMPT_RT, this shortens the time spent within RCU read side critic=
al
section in case the seqcount needs a retry, and avoids unbounded looping.

Fixes: a7c44247f70 ("xfrm: policy: make xfrm_policy_lookup_bytype lockless"=
)
Signed-off-by: Varad Gautam <varad.gautam@suse.com>
Cc: linux-rt-users <linux-rt-users@vger.kernel.org>
Cc: netdev@vger.kernel.org
Cc: stable@vger.kernel.org # v4.9
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Florian Westphal <fw@strlen.de>
---
 net/xfrm/xfrm_policy.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index ce500f847b99..e9d0df2a2ab1 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -2092,12 +2092,15 @@ static struct xfrm_policy *xfrm_policy_lookup_bytyp=
e(struct net *net, u8 type,
 	if (unlikely(!daddr || !saddr))
 		return NULL;
=20
-	rcu_read_lock();
  retry:
-	do {
-		sequence =3D read_seqcount_begin(&xfrm_policy_hash_generation);
-		chain =3D policy_hash_direct(net, daddr, saddr, family, dir);
-	} while (read_seqcount_retry(&xfrm_policy_hash_generation, sequence));
+	sequence =3D read_seqcount_begin(&xfrm_policy_hash_generation);
+	rcu_read_lock();
+
+	chain =3D policy_hash_direct(net, daddr, saddr, family, dir);
+	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
+		rcu_read_unlock();
+		goto retry;
+	}
=20
 	ret =3D NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
@@ -2128,11 +2131,15 @@ static struct xfrm_policy *xfrm_policy_lookup_bytyp=
e(struct net *net, u8 type,
 	}
=20
 skip_inexact:
-	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence))
+	if (read_seqcount_retry(&xfrm_policy_hash_generation, sequence)) {
+		rcu_read_unlock();
 		goto retry;
+	}
=20
-	if (ret && !xfrm_pol_hold_rcu(ret))
+	if (ret && !xfrm_pol_hold_rcu(ret)) {
+		rcu_read_unlock();
 		goto retry;
+	}
 fail:
 	rcu_read_unlock();
=20
--=20
2.26.2

