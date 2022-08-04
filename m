Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBE87589E22
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 17:04:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234444AbiHDPEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 11:04:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiHDPEp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 11:04:45 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01olkn2067.outbound.protection.outlook.com [40.92.99.67])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C62E552FF0;
        Thu,  4 Aug 2022 08:04:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oO7+kCsvcy4gDF1anSWRJy8FEDKlqmlc0gY1vXPBCCaL13XKr73frdHAjt7j5qYDzi+4xf4nhCGInQ/OSbklFGbI76tVCqi4I+ZjxqsoRir9pVujABI6oFEMQAahtoOdPgaoBb4goRwkB2Z3rYHr83jYPVaaD6CnffvK2D00YRdgz/ZgQFkMOT9UhnMMhXiSV2cenHWQb72p8w1di2g4ZTkEzGhpMNU6cnWOZnW4lOfcycfN4RLl6uYKW2+0seXJD9v6KQG7HaKtJrHLMIR+0nZF4duvAf0xvnQSp/zDWUQefRPjqiZ85PHMqVWSr/2SEtku3iEp83idCsKRfZSRjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a/X3rthsPIHRD77yehnVR4ijqNZB2L4qBc1woC2ltOI=;
 b=OR+p7I/M/lOCSDrSajWJWniinQ2jY6Txmj7lmjh0avrJIDLGcwIZ6KFGQtBH0yuorbsEe8sBsvvELgjjw14XPf3xs5y1S+MYtfiyGDYBBzAOeeSjPvNpTq7FJnnVGETB960QU9hDJkNPKAjPYTzFlMXj1G9zmgQLknSwQVHi5MhuQW7fBoP/GPP+qSzyBywd3qc32cucn5C7TXgYaRv3lvjOqXJ7LVRda1NrqF9btQHSJanhFN4s1yxi13Kky3od1H4N6P4DakI9FwF0BL3vBXlTbvtXa+9q6N0YeT8gJB5x6T1djgaWn738rZIqO/Axe0zgZsWo44kiSFtUHc2haw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a/X3rthsPIHRD77yehnVR4ijqNZB2L4qBc1woC2ltOI=;
 b=gZIyLofVTVvGdofCp9/oKG6Ewc55STyScHPWNtK8O7jmD6bKvFeXUk1800R5PknTwjrTfSqvIx2ONkEJ4dYlf07zsFVeKUW3IFi6cWnmXOD7RGsCR+7t0woL8kl/lrBlDszSxvEDel8cUU7iS1MXtLRCLAk4r+SyoBa5PUJZ0osQAhuZzOQE3k4e3SidzDbYirat9yZ6QjKejAiXCpRL49pisv4DIgqEKyhpr+jczpB7Bc2O96nzZk78wUvW18qkShTIqfSyVeqEA5qWohPxrCNm6pMPJQ+pyxmT7MRw2EiUyzuWxtx7wfxy8l/ADmey9wRBbIRAACrWewgHc1lLcg==
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:11a::9)
 by OSYP286MB0197.JPNP286.PROD.OUTLOOK.COM (2603:1096:604:93::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.16; Thu, 4 Aug
 2022 15:04:41 +0000
Received: from OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::4518:830:6e3:1024]) by OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 ([fe80::4518:830:6e3:1024%9]) with mapi id 15.20.5504.014; Thu, 4 Aug 2022
 15:04:41 +0000
From:   gfree.wind@outlook.com
To:     martin.lau@linux.dev, daniel@iogearbox.net,
        john.fastabend@gmail.com, song@kernel.org, yhs@fb.com,
        kpsingh@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     gfree.wind@outlook.com, Gao Feng <gfree.wind@gmail.com>
Subject: [PATCH net] net: bpf: Use the protocol's set_rcvlowat behavior if there is one
Date:   Thu,  4 Aug 2022 23:04:21 +0800
Message-ID: <OSZP286MB140479B6DBDB0F13651A55F9959F9@OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [CDx+wSEa7sK9tGLHJG6/A4V2JWTWp8rF]
X-ClientProxiedBy: TY2PR01CA0008.jpnprd01.prod.outlook.com
 (2603:1096:404:a::20) To OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
 (2603:1096:604:11a::9)
X-Microsoft-Original-Message-ID: <20220804150421.213824-1-gfree.wind@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2a543786-755b-49b9-fb9c-08da762aa814
X-MS-Exchange-SLBlob-MailProps: 1y/rb3p5sI4cbPNBR8KWu+ipHEq71m3CkCwdcG+Jp+OBZvpxbXGRKHvfZVDRxpIyEyG6cmRFjNSRgHX5Hkmlc0Hpt8kQX7LkM5eWAyM0TOYqYyZhI1RdfImbZsNMB0dh1J0D4KZF0Ew6xMRrW7nV/MZy2fMht//WNRmGQf/9JIVSqqfihxe9win0FpGRmU3GgjmIhqdVJbsrOvbUyUFBQi61ZJvRwPjx0BjS3jHA7cGWx3AXPtFw6MkYW8MAuBhqrioc5EmCGfkCMo+wvV6MlPriEVt0ZYwtHGbUsO1t6CwbIOKRMKH4aw9wxwvRxPg0uaPI8krjMNVVdK7XOuuqwQQvt5ZyqH0bDHj65EaAy5qXu/89n8MAG2f88dWLC8uGCzgjhFoKv1Ji4YwBwVFQuvgJyOOw+HZIAEiqnrlwKl563Xa8gt4bRL8nNKvH/4lYlPHbS1OXAKekn5HIArUM8q2nqDrbtC4zdnJzy/xtJBUkhWOaimSFwRpw9624kyn16XxZ0ujV+xsIwfcjpdtGPcVU/gHhNLUoDpr6cWwW39UqpaYOUrdpFBokvcdRgHYSxW6vSM9DtKW3NsdxY0fmDNigZByxCe/BnlWECFFttoC0Bvblz4fhFiZnJ1Hhl+zUtuh/B8HIcCxkZzThGJILnHu5gY7+ZjHGLYrNMpXZKFHR479xff1IGgrRmnwkeTKG57nV5G5/CUsp96VUwrfQOO84EK8llEGh8H+59bhgScU=
X-MS-TrafficTypeDiagnostic: OSYP286MB0197:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5JbXs0gOVGJz/3uwHVn3pWK7y3q2XHW0YX5lY07LOLUnJF6G4E0d1urcvwKmr2vjvQDpT9H/023iRWOXjPQkCgQ0OT9wlpIRPRCKpr48iHbVQqW95Xv+OmSOCMHf6O41nB1oeGuAf8oVnupLHW04w5W5w106JbCikKNRIDEjPGWQmCGY+XdALrjfkdv+8Nz98yP9jofQY9ftf1Pv6qmgSrzCvRBowkg5gD3ktwi4k/bU9AJq4R75fZXfPHOaWTGUMrmfKtd5x52/MUE7bUjj7+gdMZFJIbw7EU468nH1emYEEBbMTeimu/6ibDGmlDJTjc4ZreuoWDn381wyPpJggWisjHw8nAztawEcV8bt1sLnQ6Sr/c3R43dsMGp0IcZQS9UrJATGdIxDoCqeR6XEvTz8hs8wJHBSeqcRsCAmjhnK3gJoqnH+PKb48ZClAJ3IpJ8UEYiVV9yGBkNtb/sMBPZnHCB5s/x1ohWwQaIvnN2fr6Uz/0XK82GxXPkvRRJJB53ssgxTNcz5f/aFQ4FBl1uOmtDu3NGuHYzjlffYTtsvTBlSrZymgLl6iOHzI/QL8wq9tGnh2x2teZfQUMAo3jM3o5ytPm4tNkGlapTbRv+Qsg/EUNYHxEcUecEDQqs5Aj93tqFk9Zk39YIV3sLsw==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?qsI3cfx6mIWbHqrL+gj6dgHiMYTAc7beCW87sWj7y2elN8L88yJ/Z4VTc9V/?=
 =?us-ascii?Q?7dEgs83RPJaA++/1bm8EW1FB6cS3/6ny0WeCPhjEoH915BOISO/yOBFXxE/1?=
 =?us-ascii?Q?F87A9gdTiqysDVMpIAanmGavgf5uTa+LkgdNxVoh+fisjodq2tjP9jQzorh7?=
 =?us-ascii?Q?l3Uev+NnK8QjghGXK4YtE+nsktHNDmjjfT+gZAGVVVs61TzRDTn1qfpmhb33?=
 =?us-ascii?Q?IgoCbjmiuwON9cUENjteWpF4I02+NtyamlesOCIE7wkeIcdInyqQab3VSeBk?=
 =?us-ascii?Q?1ECkmUkUNItgslvBTHTcKJfjJD7vXHxVQXHbU8uEU6De8/fjMkLzg+bfY34F?=
 =?us-ascii?Q?W2R0pYz2T779yuqw8B215xrWRrcSK34THhVowUsTaqPwdXcTnKAxob8dU4cn?=
 =?us-ascii?Q?bzV8bmK7dl1o0DXy9oKB/hZ/sIvcy4gXVPaaiiu3CViF5fA22EhC+n+G5VpW?=
 =?us-ascii?Q?gsnQRoTaFvujFR96TKBNPOHXT9twPb8DnOu6Zp7OAgHxZSvXvMJrKpjp3WvM?=
 =?us-ascii?Q?RLpp67iN9bsUdffs5Aj0i5ZWz/pz78hs0zd0L9BU2vI/Sw0NMGIwhRBHZ6Ye?=
 =?us-ascii?Q?Q7y3IA8w+ntPH/IvWKuE96xUS7zsCD1xonjwiiRQnD+sR3OBhp8ypotdUshl?=
 =?us-ascii?Q?ZDdOAX3yoVLox4RhM7D4unNcvuwT/QdTlDXYGk/tRwCh+pj9DubhCHnSNJrq?=
 =?us-ascii?Q?fvTgVA3v5xUywN+cYMbilErAlI4IUH/vhHSLPFKOgmZavomZDyV1QNcWk0Eq?=
 =?us-ascii?Q?wt3uCrng1tFpQ7pu2PyFQxFRIMJUGCjZ8K2adZJC3gnDor4cvHJwoOV8/L5d?=
 =?us-ascii?Q?XvH1LPqbULEstMfaiU7y2O/4/npEz/SN5CRdLumw4eNfvjosb9jIjyX5leby?=
 =?us-ascii?Q?poqGQ/BjKlLZ2L/hssaqXorSXT6o2wy5YKjuCzTLwnT1mb07uDwMenw7JIwc?=
 =?us-ascii?Q?E0QERBh0g2P8Gi+3XJRl2hdswbQkEXwnJ2ZswhB2Hk9qNVNpJdTrK4M7sCD+?=
 =?us-ascii?Q?/usU4jDkDLQgfCa/T4QzcZfzdfID7XmXUQ/0P3rI/IuRp2AzuTKSnmDJbbU/?=
 =?us-ascii?Q?EVLEoxDrDFIT7OQssbVKYrDX2OV3CH+mXawn9YpTpkYgsPmZO4bAm64kCGqw?=
 =?us-ascii?Q?WgHmUObyRttQqKia4unkF88y+V0hhPU37GyrGOWaSHRaDyrnkg3PPKovVzYr?=
 =?us-ascii?Q?YHAq1Z32KjaIRgvgORXxbSfGy+7beQfnJfFwbur3350IvHYLnM2uKaDhOlr/?=
 =?us-ascii?Q?xCUWrELTN4hls2/kbXetx1hRgAMuRUARSCmyx0fMLw=3D=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2a543786-755b-49b9-fb9c-08da762aa814
X-MS-Exchange-CrossTenant-AuthSource: OSZP286MB1404.JPNP286.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2022 15:04:41.0292
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSYP286MB0197
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Gao Feng <gfree.wind@gmail.com>

The commit d1361840f8c5 ("tcp: fix SO_RCVLOWAT and RCVBUF autotuning")
add one new (struct proto_ops)->set_rcvlowat method so that a protocol
can override the default setsockopt(SO_RCVLOWAT) behavior.

The prior bpf codes don't check and invoke the protos's set_rcvlowat,
now correct it.

Signed-off-by: Gao Feng <gfree.wind@gmail.com>
---
 net/core/filter.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 7950f7520765..beb6209897ab 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -5064,7 +5064,10 @@ static int _bpf_setsockopt(struct sock *sk, int level, int optname,
 		case SO_RCVLOWAT:
 			if (val < 0)
 				val = INT_MAX;
-			WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
+			if (sk->sk_socket && sk->sk_socket->ops->set_rcvlowat)
+				ret = sk->sk_socket->ops->set_rcvlowat(sk, val);
+			else
+				WRITE_ONCE(sk->sk_rcvlowat, val ? : 1);
 			break;
 		case SO_MARK:
 			if (sk->sk_mark != val) {
-- 
2.25.1

