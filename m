Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32FDC50B38B
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 11:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1445799AbiDVJGi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 05:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359739AbiDVJGh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 05:06:37 -0400
Received: from CHE01-GV0-obe.outbound.protection.outlook.com (mail-gv0che01on2128.outbound.protection.outlook.com [40.107.23.128])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6605371F;
        Fri, 22 Apr 2022 02:03:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKZgY0Fsb+4s/cW+SHjpj5+qoDAei6xCK/eNCWbNRUXIrnMDs0ajOxVLqz+XKgkqS03mxQw5EBy9ujN+y+mg1Oh0CDynVFfLhJSRkZKobjE7poA3fUeYNB8q41LgK6p4aa+L4SNASOGCi72R5yaZyB0kxD0WIcie/1adwXDdNDkM1Q2w00/lhtuLg2gImT9ayWx95f08oN3gY9uFgKRqEiKlfjfa5eurtMcy0o2lYMecYesjdLyH6jFzemrzFYl49l7RKsedV+nCfVAQsXyclERpVhk0o8Bh+CIq6EpdkMcIHbNMbD1yPxdsjSr7TrmqAvGJpP4C3UxNisgNnADJKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=BOPB+Sky8Jjbb/qkjFKrN8DKf7+ZC+t1VwcmgtnnDrg=;
 b=K1pGXTAxMwA7IHDu1QmuE60/tWx5yv3iKkuKsgv80XdVQIU2RemVdm8pD8V39yNg4TPYBpXRSaiKcvKXyWlt/xWDzaj9Uebyfn8Sb8AOOU6KPnR3rPpE4VA4hXLB6PCQjEmfQirPL7ZeKqUAdbE2T0bssJKYzIepMabGPYD4ldK2d+t1geWLzktdqbwTMq2d46IJUWH82hfIq3sGG61dJLPryZ51tqqbVHLa/F4CQC9naJLiCCWyeEc6oLHgLvPOhTi1OKcwrM+bxEFpkrkeQyRnxUsXSECG++3Gwklexc0pKRNAxnNu6ozGKqWQJH6q1texp1gvBv3GBfqulQKhYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=toradex.com; dmarc=pass action=none header.from=toradex.com;
 dkim=pass header.d=toradex.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=toradex.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BOPB+Sky8Jjbb/qkjFKrN8DKf7+ZC+t1VwcmgtnnDrg=;
 b=AneKh+zcGjIpBfEo2ooDxbhi9P/kw9RhjklDxnXjOIZVotsUa3yYAYiVlpHljgtUDuoozel4Qe/+0o8cZ9GR1GdndgdWI74006lzn/JujjdSgWrXO/iowFYvuh6Xs4xT55+8kqBkMJ50FZrbh8LHFd6qjdTu6ocntA5T3ZSh8Sk=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=toradex.com;
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM (2603:10a6:710:57::6) by
 ZR0P278MB0393.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:34::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5186.14; Fri, 22 Apr 2022 09:03:41 +0000
Received: from GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165]) by GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 ([fe80::d03a:14ba:bd9a:e165%7]) with mapi id 15.20.5186.015; Fri, 22 Apr 2022
 09:03:41 +0000
From:   Andrejs Cainikovs <andrejs.cainikovs@toradex.com>
To:     linux-wireless@vger.kernel.org,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>
Cc:     Andrejs Cainikovs <andrejs.cainikovs@toradex.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Brian Norris <briannorris@chromium.org>,
        =?UTF-8?q?Jonas=20Dre=C3=9Fler?= <verdre@v0yd.nl>,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Francesco Dolcini <francesco.dolcini@toradex.com>,
        netdev@vger.kernel.org
Subject: [PATCH v2 0/2] mwifiex: Select firmware based on strapping
Date:   Fri, 22 Apr 2022 11:03:11 +0200
Message-Id: <20220422090313.125857-1-andrejs.cainikovs@toradex.com>
X-Mailer: git-send-email 2.25.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: ZR0P278CA0151.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::12) To GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:57::6)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0dbe66be-4fe4-46ad-710a-08da243efefe
X-MS-TrafficTypeDiagnostic: ZR0P278MB0393:EE_
X-Microsoft-Antispam-PRVS: <ZR0P278MB03931BFB33333F0D988C45C7E2F79@ZR0P278MB0393.CHEP278.PROD.OUTLOOK.COM>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yF52XmLJ80Z4RiPG7zzE4KaVDw9pRT0mitqoOu9yX4zbHHwAkWvOS665Ffv4qaB3VRdWyZJSsoFstkVB5o35YpOaId97sfuKxoBDPstzp+O+CI04MO3iGFVrIeHhSUqbXUL2+EeyY67W1gAe1Q/m95HpWNZyfbE9QVSuHc/lT/DG69ni8motebJBdsJo6wUbQ9yfwIewA26984Pm0ikdehKlkSJQI+F+GTu1GVAYDO3Hj1icZ7NpGQbbkOwoIqqW0Olp/TB/hjG0EQXaxWCb8LyN/IQ10TvsVLscmoVu0miWoYD8Xgqfo7ZDWadwPSdW/lC3hE0I2pj0zRB361s8s3Xno2phWLX7T33r4pSw0gD03T1011VLpLbqELiNbnJ46duOIeGH+oNnAWlCDN1SgAcPlhFLGdUNXvApuq136DZzg/9iih1nNjERNunWdDHYfzWKTJeXL/udcWJFrRPPKaYIhtxXzR3DiJv9bh03A4sJ1e+RYJnXtjVdY+iFwMVh1uFzQ92Jd3lnVuKe/BEA7dAZzxG50E6NUOwZCNIAofT7OwkuxK1whGXhluISSWp7hzJzYkY7trsdMIWsbzR3JfWoEQIkuFjK1Mor7TnGwc6D2T5rXnI1KHeIDVEeBUssSxn0DgMfu4MTqgfcIUvsezAIoFgJedl4ZBrMXpYROq8njp1rnrs6hORhCmOXYWFdNuSa4gXNgqPg+a/L+Hro/w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(396003)(39850400004)(136003)(346002)(376002)(6506007)(2616005)(6512007)(86362001)(316002)(6666004)(44832011)(2906002)(5660300002)(4744005)(7416002)(54906003)(26005)(1076003)(8936002)(110136005)(38100700002)(186003)(52116002)(508600001)(38350700002)(6486002)(36756003)(8676002)(4326008)(66476007)(66556008)(66946007)(83380400001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z2ltZHVjMFRMMFZXVlBGRnhzY0NIZEpoOFRibzB0Q1BwMlN4andPb1I1UUMv?=
 =?utf-8?B?N2NkdGlmMTYwem4zWXlwb2RVeVlmek84SUFHeEZVWlJyRDM2YnljSCtSVXNI?=
 =?utf-8?B?eWkyc0FDWE5jTzVyTUtPRVBMenl0MFFLRFJCTnFYZXJra3pacXVVV1B6TXFy?=
 =?utf-8?B?VFo3VEJSektVVGlCRVZMUytRV3A4cTJwQXRmRjRQTFFBSTc0VE5FR1FQUHM4?=
 =?utf-8?B?SzMxNmJIbmJIRVFNSEZjcVF3Q01uUzB3bFEzNGcyQjB5V3VmU095OHRLY3V5?=
 =?utf-8?B?c0p5MEorZDZucnNma0k0di9IN2FhRWNNVmtJc0lmR1A1ZXY1dVRzYVlXZzN4?=
 =?utf-8?B?TFBBemhzbExodjBaQjN1bG83ZTNOdTRuWEpyT0hsaEZDVEFwMWtUYzdUai9Z?=
 =?utf-8?B?OGMzYmEyeG9LTkJxOFNoUmljSmoxMEl3K0J3OEhKN1oybU9FSWZ0dGZob1lL?=
 =?utf-8?B?YUd3VFp3NDNmREZJLzdQd1VNZDVwak1YazlKUWRXUUdaT2tlVE9RNkJyU2lo?=
 =?utf-8?B?c3krcWNXbnhtbm9nZEZzV1J2QXByOXlBYnNTbitrWUdzajVLdERXY2h5OTBz?=
 =?utf-8?B?NFFSVW84MUg4TjRSNWU4M3pXMmhBR1oybG5LVERkMUJZSzlNUDZsVjdXT3B0?=
 =?utf-8?B?OTVhUDZpZXJmdTNjeVBGdGR2ZXNNWVZUYkNkWmxUWjd4Wm13WXUvUVBPcGZn?=
 =?utf-8?B?RVk1Tm9NNHNmSVpEWDE1K0NmVkthd0EybkIwSHhZYnNVRldlekZaZVh3MnJz?=
 =?utf-8?B?cVNrOEJwSGg2eEdFTjFJVnR6U3QxR2Rab2pkcUJCUWpjQ2lKMWg0R3NxRURN?=
 =?utf-8?B?SlRwWkVZZmRlRElTcnV2Q3JCdGJ0UkllM0YyN2NneDFNVzNEVTE4SDdnTnRK?=
 =?utf-8?B?SXA0OWZlN1RmRllIanJKY0NpcVBpNVprL3ZGWE1DQ1ByRklsVkVpSFNtNitp?=
 =?utf-8?B?RndOVTYxY3I4WEFuV3R3TWV4QWhzNG5QR3piNU9rQVNETzZrdlYvRVFLZVVn?=
 =?utf-8?B?RmtIbm5UcG45K0ZxMUFIT3F4NGlBQWRFM3N6akc2YXZDYW15NHZBVGZQekln?=
 =?utf-8?B?YjVmNVBLeFJqS0ZpNTJQYUJtVDZ0MXpIbVNmQ01EdlNKNmdTTXBzREFFa3BS?=
 =?utf-8?B?WlZZd1RnMG1mdk5wZUppeWFENDlkYnR4L0FNQmM5UytNN0NJUXVaRFAvMnZE?=
 =?utf-8?B?aE5IaTQvT000djVYemNueHpWOFBOWTRLS2pwNy9GQnhsNHlRU1dGVUkwU2Mr?=
 =?utf-8?B?ZFFHQzlmWk1MMnJFdElRQ0VpT2ZYVm82UmVQSERjc0JsaWY1T1paRzVDRThX?=
 =?utf-8?B?M2ZySFZsbkF0Mm9CQ0xoYmJrQmtxZS9ORzAzOTNoUFd6Q1p5TjR5VG0xNkov?=
 =?utf-8?B?VWtBQnlySWVRTFRYRkNQRzU4TW1QUytJdlVlTklUbHVvZFFxWDBEOXk3aWJR?=
 =?utf-8?B?ZG5wbHBFRm1Hbzd3VDJJeTFFakxGQVlScVM2eU1yRFlMejRhbTVpb2VmZHl2?=
 =?utf-8?B?OFF0TlZ4RHV0MzlBQkdIOHd1cHVDdjVJcDd0Q1hmM0JudlU4cWxEemJJQ204?=
 =?utf-8?B?NmQ1NURxdFFQZFNBQVJJd2FmZ2FaWEF0MmNBbVVYVTBNV21rN2RFb3d3ZmIx?=
 =?utf-8?B?MDBkSVhOTUpHbkxHRjNHNHMyWWZkR3pqdTJCekczKzR3TVBVWi9vUGFQR1lH?=
 =?utf-8?B?QVV0dVVraWhpL2ZTcWZqUFZ5ZXExdWxyNnNXWGs2bFlENFAxTFN2T3hwcldt?=
 =?utf-8?B?RWZ1T2hSdnBHbk9QOGh4dU9DNHQ3MXpINzcyNDExcW82a2IzQVJiclhPWFRj?=
 =?utf-8?B?czVzYkN3UmI0S1dkUEYrWGJnc3U4OVhXUTFzbkV6RTY5SU5KUCtJM3hDNlNj?=
 =?utf-8?B?RVBiMWFmT3pMaHdPK3B0aDAzcmhrU2Q0azF1OWhWdVNRY1RFUkNPOUgyRzFp?=
 =?utf-8?B?R0Ywb1hJZmRlYjE0eGllTFBUY0t0dmI2SzFVaDJyZFRCQTlUdWRjb2E5MENw?=
 =?utf-8?B?azRVKzdndDZSeU9VQU1JOHBJSXJ0anBuMVIvc2lZbW9jL0l1S0xDZzhaWkhD?=
 =?utf-8?B?eXU4ZVF5RVdiOW9Zd0k0dDlNdmdKeXllMkFFeGllUHJEZVl4WjNHZEF6TTRa?=
 =?utf-8?B?d1ovN05VMDJ4dXZrOVJUTlM5L0hsWVprVVNLTlNEd08rV1djY0t5Ymc4dHRa?=
 =?utf-8?B?bVp5MXBYa3B2Rnd2ZysvNWZhSjVUWFZLYlJNTW9UMWdtenRFSmR4ZzBaTE9R?=
 =?utf-8?B?TS85YWdRUkFJMkJwSURpUFR1MVp3SEh3Z1Q4ZHYzYzdCZ05qbkJFOE9IQUYv?=
 =?utf-8?B?VG5UbnZ2a1lYcW4rUlU4eEx6VXQyUFBqWCtJQ2pFZzRqZWxSUitNUHBQeW1S?=
 =?utf-8?Q?Qd0L9/iZYk0Lf6h9XurqwQYXh+xIbovhN8+Y7?=
X-OriginatorOrg: toradex.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0dbe66be-4fe4-46ad-710a-08da243efefe
X-MS-Exchange-CrossTenant-AuthSource: GVAP278MB0929.CHEP278.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Apr 2022 09:03:41.1944
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d9995866-0d9b-4251-8315-093f062abab4
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rZpqmucRHhJryVM2n3w0/JMULVgxTDoHWur1qhbkscGg6lC2yjf3UsnFAVWuoeSNyrFdcsPk/jzpwGponYQ4JinDoeb/sqxnQj8lQMVZAFA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ZR0P278MB0393
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set introduces a way to automatically select appropriate
firmware depending of the host connection method.

Andrejs Cainikovs (2):
  mwifiex: Select firmware based on strapping
  mwifiex: Add SD8997 SDIO-UART firmware

 drivers/net/wireless/marvell/mwifiex/sdio.c | 23 ++++++++++++++++++++-
 drivers/net/wireless/marvell/mwifiex/sdio.h |  6 ++++++
 2 files changed, 28 insertions(+), 1 deletion(-)

-- 
2.25.1

