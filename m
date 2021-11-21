Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 053B04581B0
	for <lists+netdev@lfdr.de>; Sun, 21 Nov 2021 05:17:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237803AbhKUEUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Nov 2021 23:20:18 -0500
Received: from mx0a-002c1b01.pphosted.com ([148.163.151.68]:31068 "EHLO
        mx0a-002c1b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233724AbhKUEUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Nov 2021 23:20:16 -0500
Received: from pps.filterd (m0127839.ppops.net [127.0.0.1])
        by mx0a-002c1b01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 1AL1CFRn025567;
        Sat, 20 Nov 2021 20:16:31 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 mime-version; s=proofpoint20171006;
 bh=7the4YuqaTqthsl6PlkH3MeTnO1d9U2ImjiO5OY46Jw=;
 b=XdmDiKfO52zmTQOvKpT31s2x7dWM9xrsN4JXg12rir4RAAsbMPpSfD9mhcXzpr/47W6c
 9+a2ZC8rdGCO1OKFbiO6UHV1NqFoy3gLahAIVAUECciAVn3EsQihvwhYyAKY4e7ULbj0
 AHMgs+aymP+ET3+/QULhZmo9dfOFu0qLC1h0J7ob719cQzykPuIMzi6CIXAUJBBQnRVr
 NNOOqm0nPZ8NJkBdy+0FYuxv8XfCADIj9twSsHv6E4y5hfrunhivPKpCTb021Ajirst9
 9mdK5ltvyarIVqc5qxdh/ZvQNHdTKYiqBo3td+82lCaagLX/SS99fQsE9AIxHaQKJxmN XA== 
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by mx0a-002c1b01.pphosted.com (PPS) with ESMTPS id 3cf0yn0wpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Sat, 20 Nov 2021 20:16:31 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTxIsPb+6oEogPRA9znjnsIQzlFg6ZlH3Yljpf3iPOePWVOSmIG1fVt+MOZo/iOAQfITl/IaLuKgV00ymNC72f27Pn+G5yepKznjp7orzARzMXQkMbUIf/DAdgeN3Ap1h2Ba2lPt+0LToJrMTloJ+8ZOl1t07lTRE0qX151le85ueTqx5YWjN2ioCR2nG5f3R2T9thMCjsUKuGZoZVW1i4GbXm053YpGzo1I4aYplYcWnNSXT38tWN7f9KpcYg2blTzoiao1pd3VDU2tqGQix2kFI7xShCfrQmoPAIQhgWPX0W9oyHDHswjrxxn+149GBshWNJ8Z8Hf24va8h64NRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7the4YuqaTqthsl6PlkH3MeTnO1d9U2ImjiO5OY46Jw=;
 b=NbIh9YYCu4iYH+qzxLv30FVKplicVzJwKibhfhrLHA5e3mnuMJoP9J/+TPkwF5SzMiCRgv+VhwpLtARTeOFtI7QtAGslszLHTAfbxG29FEsWoZuEElezzFlAeMTeHVX22X9tSLkr6+tGfzkRZXX/1O47BebfzF4WkxBx4bQlHebXUee5EmGXSjiMT4JMzvoCorqMEP6X8LZBMcNYAJt8unq88xxYU98clXCYXhGe7034LSJk0f8fZBxrlAStBLyS6o0ZBQqL5yRzu1A1hY9iqrW1xCT09KZi+RlTaprGD82YsgC2thzEMqHskER/YRveA2KgU9QhJ6DkF0bPfCnMwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nutanix.com; dmarc=pass action=none header.from=nutanix.com;
 dkim=pass header.d=nutanix.com; arc=none
Received: from CH0PR02MB8041.namprd02.prod.outlook.com (2603:10b6:610:106::10)
 by CH2PR02MB6422.namprd02.prod.outlook.com (2603:10b6:610:a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.19; Sun, 21 Nov
 2021 04:16:29 +0000
Received: from CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::c549:4f6b:774b:d63b]) by CH0PR02MB8041.namprd02.prod.outlook.com
 ([fe80::c549:4f6b:774b:d63b%4]) with mapi id 15.20.4713.024; Sun, 21 Nov 2021
 04:16:29 +0000
From:   Eiichi Tsukata <eiichi.tsukata@nutanix.com>
To:     dhowells@redhat.com, marc.dionne@auristor.com, davem@davemloft.net,
        kuba@kernel.org, linux-afs@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Eiichi Tsukata <eiichi.tsukata@nutanix.com>
Subject: [PATCH net 2/2] rxrpc: Fix rxrpc_local leak in rxrpc_lookup_peer()
Date:   Sun, 21 Nov 2021 04:16:08 +0000
Message-Id: <20211121041608.133740-2-eiichi.tsukata@nutanix.com>
X-Mailer: git-send-email 2.9.3
In-Reply-To: <20211121041608.133740-1-eiichi.tsukata@nutanix.com>
References: <20211121041608.133740-1-eiichi.tsukata@nutanix.com>
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0130.namprd13.prod.outlook.com
 (2603:10b6:a03:2c6::15) To CH0PR02MB8041.namprd02.prod.outlook.com
 (2603:10b6:610:106::10)
MIME-Version: 1.0
Received: from eiichi-tsukata.ubvm.nutanix.com (192.146.154.244) by SJ0PR13CA0130.namprd13.prod.outlook.com (2603:10b6:a03:2c6::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4734.13 via Frontend Transport; Sun, 21 Nov 2021 04:16:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 30509a60-edf7-49d8-4c51-08d9aca5b16c
X-MS-TrafficTypeDiagnostic: CH2PR02MB6422:
X-Microsoft-Antispam-PRVS: <CH2PR02MB64220C68FEAAF55905BEC692809E9@CH2PR02MB6422.namprd02.prod.outlook.com>
x-proofpoint-crosstenant: true
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kWCuqSU8uExFP2rP0Xuy9+KpfQnTQHW0v8RT2PLudzEX24ILxAa5mHRtswfZGnwWWfy15Nq2YMoGeEb7kKcihPh2qkCQKqNqJnhG+Dp4ZewcexcbXNZn6CwDndNB+XVakcXmo91FvqA/u2JHTeyPLW/c0qBs/Zb+wA7JDY6ttKXOr2yQKtOTSZL0EOISLl1gAgRIkTttxckwnslrCwGD8SPnzTC3k5NSmBXloIvjgFtb0XcHfzBfDuK2pp2Spu5H+nfMus/ZPeRVL6CZBhXGBDwUy7auQlNFrTk+y/V22xLbf0yWVw2JxdgVwPUE3hOcbKaPmCQy2SfLVShMOue6ios5A6R2Ntz2zUDOYX8gYpzs///SifeJ4BeoXAcqilPrsG7bFNlDk99jrSubSbfxsoXxmpOv5gWoeGiy3tj77hJWPvE6KCiBXXUPDw87rPnevuKcK0Xw8deX9BOvRk1V/EKY0OoAiDsK0j9x441ewc3DL8z2R0VLxiVjm8VBv7TOJxmxijU0tKHvNvYjWDJyfRL/z0yYRmlSe6hIRsrnSZqUI6c4aUWmF4sIEJdEB/uHUCD1iK1yS6qE9Bqdmwf0l166FvpzDJrXjHanneyKq33ycGIZjvr4tsXHqMV4ywhnSj+TEpvkCWuHs61p2oa00i/uhigvfIuFLPvXYg8nhmp0rl5X9jBHqgQVdYOmi5pK5sZUHq8UYNsoeIYUY1iW/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR02MB8041.namprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(83380400001)(6666004)(956004)(8676002)(66476007)(4744005)(44832011)(66946007)(52116002)(38100700002)(6486002)(107886003)(66556008)(7696005)(26005)(2616005)(1076003)(5660300002)(186003)(508600001)(36756003)(38350700002)(86362001)(316002)(2906002)(8936002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?EsqCCCnJx28jJKHw2IOiF7G3622coIc71tczvLKqWtXAIqsT3Toazk414NhW?=
 =?us-ascii?Q?vabxe2kfkciJcJlVmHEkLbIHWoXVHRBLFBWCgn/F4MXJCPa+3Gd28N8/Urlp?=
 =?us-ascii?Q?2qw+vY9vGhyTTMgj8Nnr2TSIV/abGmo8nDgvsCyMIJ4jpQmyUD5xE0XN9DXD?=
 =?us-ascii?Q?l3vsfNxIY/GJUoT7bQrcBVzOl2sNBgFDs7VQv9ZmHivTWP1ylUnbyhrrB/nf?=
 =?us-ascii?Q?5CJdKbziXQYbltxvyuTs4JlzqL/0fC2JSxu98jZsh1QuWIBQtRnvQK1BFPxD?=
 =?us-ascii?Q?0gOgtMYXzzpBmTq+hkPzB4sfS1h1AOAK7o+lM/xsrB8FBkhq94ZedGybYy23?=
 =?us-ascii?Q?wlHsYIVV1XOPyoCan7lv1HfinDqESO7aA7OjGpkyBR2phof4ujcBPFc8pxan?=
 =?us-ascii?Q?gC8yjIJcvvkarK2r8IGSU1fbleFpO5j31X41smxo1UPn7J6yL7fZdKSJNXaX?=
 =?us-ascii?Q?bEdv/pdSs3PJ6bFzeN8r3fz96RshjT6STray85U9TbD/5to1UUJIBYwcrIlz?=
 =?us-ascii?Q?G9ubHAJbJNuSZSTK/tt3+D8jPI2hM1SJ4NgIUFvRu3wnlJ75vC7XPVoD0jC2?=
 =?us-ascii?Q?Uz4srtgm+COhNEqAAhZu9eM+8cpoLFjgJQ/OP6/7EdM0bbEnswC+bBUUk07v?=
 =?us-ascii?Q?TcrWFd3U1mvp3xjkpNRAxqzsTpvBQpD0RYVGsMRGw+CD7EYCoheE4UIknuBp?=
 =?us-ascii?Q?YVzlFwXIJiLMYGSyxCU2mQo5M7m43UshYVmStaqUgx0EGV5GdEK9pgkFcxgT?=
 =?us-ascii?Q?uZVHA7AyOKfQXuUEwCx+TigFC3qBrSV11AETr3xasJvcP+Cgi0QnEuH2fHNN?=
 =?us-ascii?Q?5CZOJzlZq2t4Ivj6Irw0ZJ5ElX9SjcyFbbfpB76C67rW8/KDCuoeOn3ikuO6?=
 =?us-ascii?Q?Q0E+9a/fRttAzfuo4BoUqTNWMN8lFU+pFfZOorzke+B8AOTHmvTtMIWGeNZb?=
 =?us-ascii?Q?3m8wq3BQATXzlWnmTqT13v2T+NrBnM18/mWE+kOgqRjOAajeBqXnPtjieky0?=
 =?us-ascii?Q?STFYXPm8BX/5o8ZkEpfjvV8sPpUoK5ewkYWL+Fcoi41IzscIKjnK6kgLWXNJ?=
 =?us-ascii?Q?ATnT/jnli2GRgKjvdmFXMLdNVKOifvcB57agR3wk49ixBt/IHtA36bFP6uWt?=
 =?us-ascii?Q?swZppHwsk8tXSLhAH4ATKPD2OwIML0XXd5QB1NNa44U/HUdEUaQaorDLt24a?=
 =?us-ascii?Q?7/n+yI11aOhlEfcZtrofK8+SnLNTWTc6NcYZffR0cHDeTiIwVDvN7dcCHji8?=
 =?us-ascii?Q?Qx5K7qEFKspIEnuOMHxyYyZ2OmY3BtPYeZ3u+fRD/QFNMY+Uu+B+zXhm31uC?=
 =?us-ascii?Q?uk5R7dxqc9RnI34YPOCPl4VBUbT9Q8O0+u1IQlOi3/NASFFZiGvcglmImwPR?=
 =?us-ascii?Q?ijBEVr19gMavBSG+8+BtMKH440oQ+pHC/mMVFhOrr8I5OZY9pN8NmtVTxZCK?=
 =?us-ascii?Q?zP05dxILIgIV/Ky6ji5alr/8j7+38Dw+IU+8yAai6wM8T6jgbjKOIxlCiN3m?=
 =?us-ascii?Q?u84Mo3ELLR6IxXWT7mKDDTQdB4o+ahYBqF+jt9A4xT2fHnKmZs8ekFB1WyZT?=
 =?us-ascii?Q?0F5GnQ8WNeWEzCXkllyU1cx3zRL6QqAvVZ5p/6Kw3keJhE6Y8ShXtJcQbu0i?=
 =?us-ascii?Q?S83F8KVgBES2ErFpCHJaKvCjzJgRi+zUgufMaSelzOl40UhsxlPX/VYSniXL?=
 =?us-ascii?Q?TT8be4rqBz6o4UkHhDYt3tmthTg=3D?=
X-OriginatorOrg: nutanix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30509a60-edf7-49d8-4c51-08d9aca5b16c
X-MS-Exchange-CrossTenant-AuthSource: CH0PR02MB8041.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2021 04:16:29.8440
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: bb047546-786f-4de1-bd75-24e5b6f79043
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3LkN7SNMdil/H0WvURHikA312gl0V5jcD5FgRudu7YCnRUZ6iooQuXFtt+pjY507iilTPwKsRRALCnbXybZChOa+lcqV7gOin+f/CIBYXrw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR02MB6422
X-Proofpoint-ORIG-GUID: EN87NZlyleD9YfOtND8GxMFQ9KjyWii2
X-Proofpoint-GUID: EN87NZlyleD9YfOtND8GxMFQ9KjyWii2
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.0.607.475
 definitions=2021-11-21_02,2021-11-17_01,2020-04-07_01
X-Proofpoint-Spam-Reason: safe
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Need to call rxrpc_put_local() for peer candidate before kfree() as it
holds a ref to rxrpc_local.

Fixes: 9ebeddef58c4 ("rxrpc: rxrpc_peer needs to hold a ref on the rxrpc_local record")
Signed-off-by: Eiichi Tsukata <eiichi.tsukata@nutanix.com>
---
 net/rxrpc/peer_object.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index 68396d052052..431b62bc1da2 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -364,10 +364,12 @@ struct rxrpc_peer *rxrpc_lookup_peer(struct rxrpc_sock *rx,
 
 		spin_unlock_bh(&rxnet->peer_hash_lock);
 
-		if (peer)
+		if (peer) {
+			rxrpc_put_local(candidate->local);
 			kfree(candidate);
-		else
+		} else {
 			peer = candidate;
+		}
 	}
 
 	_net("PEER %d {%pISp}", peer->debug_id, &peer->srx.transport);
-- 
2.33.1

