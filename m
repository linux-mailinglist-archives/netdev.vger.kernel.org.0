Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647234C8DDE
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 15:36:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235313AbiCAOh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 09:37:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234969AbiCAOh2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 09:37:28 -0500
Received: from AUS01-SY4-obe.outbound.protection.outlook.com (mail-sy4aus01olkn2162.outbound.protection.outlook.com [40.92.62.162])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D24CA147D;
        Tue,  1 Mar 2022 06:36:47 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jCyUmwavYzNCCVUTRQZj2glPFAsvHyVizT2TDMUXU60yMckbtsT2O9mxGsx3LUtFv8BuJ/E/l7grkAMEDzAsjZVNUWhViMnQU92PC2iZTUWAPZGhfj1hHipRuqS0FDxdYNk8+nRmJ9hFTieqRUajr7uSjHAZfv+D/I5zb1LOtj7YZ0lJMRWJ53XzKIIvfzLgUv/tirGjL/pabggG12WOYzJTb8xC8ODAzZ7UYTam47teKra7wU7Ay9hYZNpQf0hG0fzsrhDj8OH534oC23ShbQYEiJvoLJGj8RbKsTxcYyKEcPmNAXAT5fTtx+uuJQZwwUJiB6NK5HOpCCbOcpLKIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=unQjfd55W5pWsGPF0DgIfnyK6p+y/uD8/BZU9Pp4uQE=;
 b=O9SCUAZgzaPbCl0VUGfxqlsDGUBPJ8asznkmiwrcsqu+ZwtyO/AH/7MROGhIXqFqqlAdm2KSqSdelU/DjLRCAIdhLZuleTULb39L4UPPFCdM560zJom5jUvrjeugakivQecI83jlNmgeK0C06y+suABKy3QkJ+uiEnQP/kvoS0UnbwrpxFH5UryU99DyWhckSfXe/x2C1C1FgBIFfen7Avyl5GmE5ERVURc/gYB9PCnvkCJH19ypr1T3ooydqTcb/0GYb12gLxqg66A/LgjoS6evdQQROU/xp5VOop5AycaTXq9Gl4MNiBMvtPOAijgZEfIoF6INwJWWSCQzXQZIKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=unQjfd55W5pWsGPF0DgIfnyK6p+y/uD8/BZU9Pp4uQE=;
 b=RHOagGtZtzYMVHCi96dO7qDqRZv1pNieKqTpyWJQG5yccsWKC9RshD4NbRHsIuYAB3+DvrSFWRcxttCFQ/JXToMHTq8/RUBDyxjtvjgGONHKVSWxtr64/qROlshe5kkoVIYB6+rUH4PJOVWJx76n7FiMlmM5eKF8AFAUFWza+AEZSHbehRIFursHMsNssyUrYuWJd35lNpTVZY83rFwahhj9rPatWeNCzBGnBwmPuD9WaK853htH6hHoarKdGvuvIFbatEvrn3qRfuydBoAfvfKhq9kPUEMrtmnvHvu1IwcXtWl2YVwDCs2ZJvPsfWT5QDtN9MRCBzlc9XWRVUN5pg==
Received: from SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM (2603:10c6:10:16c::18)
 by ME3P282MB3902.AUSP282.PROD.OUTLOOK.COM (2603:10c6:220:1b6::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.23; Tue, 1 Mar
 2022 14:36:42 +0000
Received: from SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
 ([fe80::6855:2b32:afdf:7cd0]) by SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
 ([fe80::6855:2b32:afdf:7cd0%4]) with mapi id 15.20.5017.027; Tue, 1 Mar 2022
 14:36:42 +0000
From:   Tao Chen <chentao3@hotmail.com>
To:     edumazet@google.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tao Chen <chentao3@hotmail.com>
Subject: [PATCH v2] tcp: Remove the unused api
Date:   Tue,  1 Mar 2022 06:35:42 -0800
Message-ID: <SYZP282MB33317DEE1253B37C0F57231E86029@SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain
X-TMN:  [p3W4J5laGABtap5dHIyIC8Ycxg0qNWaW]
X-ClientProxiedBy: HK0PR01CA0064.apcprd01.prod.exchangelabs.com
 (2603:1096:203:a6::28) To SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
 (2603:10c6:10:16c::18)
X-Microsoft-Original-Message-ID: <20220301143542.36116-1-chentao3@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6a0c7126-5c33-484e-9402-08d9fb90e510
X-MS-Exchange-SLBlob-MailProps: vJxI5U0j4N5GrV8Xh0i7CpMlcr4Gx/E4OfmnlGp3SnDbzWkZqlcaAxVBWPa2n+kKBPFuCmGJQp+lhMN6n8T58i5FzYBihO8S2UG7nBMlaSWakKUfbJwaDyFeBqCz7dRdi+TS8Wft93utIGiRzWkVM7Qy4aiFFukDNdQSfBUqZiIfT2EX3Zy0qx3SLSLfa3CcvqMr9ooI7y6Oa2CgebBq1iU9lCuePf+R6V/HR+eP8yw+1t22XKXE7wdsZ92ZOgJ4W85gOD9chjTuMpSYqx94tTMqa5zQ6KoQlNuEoQ2esIILFhFYl7XuYmPmflCb3GfkU8EhXsc8QKf0MuYkgnI2XlNUan3De48929CbtF9mG3QC4TA0rFt8JR43LHH2c1KkpuEDDeIWU31BsCQ0FF/3aKu2KHtLUWnII793YWmyH27xmd8epCV4cUbTOOhPQXwYqlAsm2ceYWS7qyVNYfd7CjzjTZR0FtagW9AeqytIDy8uzYA9HZEDpHfh4b6AGFH4MMmhH2XNesWTKg8d/hbkMpzOMx8ZcNt2kX1P9+wLpuPGgwyJLpfC4h0rjWNoJTQ8O3v3OjhaOdthwip3jjFSbL5K4wUc31u30SEDMA/e38saULSmJsySM3w/f/OygrLU8DSZ/2gczzxDHwgvkA4ylHV4gKwPoSNzkyXDK7TiW9BTX5rWYtCPBJ0/YOGAJpK7AtTdtWB65nvqHJi3M//dW5z+D8XYkyQr
X-MS-TrafficTypeDiagnostic: ME3P282MB3902:EE_
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: arbrvoktAy4B70Yii5JmGaO++QzeAl8IY1qFkUz7bwq+4s9bJrKTskomH2f4ml6gJtE8BkWF6DMy+meQ6O7zYCHdSh4wZjizny0KrZ+4RIsTTMRr/MFSr/BDgJUdLUfcMSAWov05Jh0RewYlN40ug7gsHyl9dyE0VxER+9CcenvOmOxsEcYz1yEnBqPy56nOG5j5/vfaOJfGvtri47s+TFj8BsuZdu44vfgl/3TO+0PLJUb2X898I6707XyBBHWpnYOD5jIk7On1/HVT3hSF/FV8+WWEH2CqMx3AJ5MCMbueDsIJ6U7iEFZWkDEI5IRT4Z40ks65MFFl+a+MvCD0VeCDIBJqIIL+Uhn0PUVwSjSGO1EFjbRMs+sIKY04QAfU8Ldb5KBj6tLxQVfZFurVAqQlE4NUKG8qsz+6t0bkplRK5AohV77FJKRHt6/4rP8UphtLGNQRXjDdV6QgvaZubD508cGE560Zl+j8YHF8cLL13D+zGd4H7xmrHXl+QV57AQnsoIJ69BtRcUBLjKQXiwbJmHBXprrNHaI4RcCCHa0jC/xBM/TFz+ZD2aGKilW1Td1rxSIn23Pcj/JLY3r0nA==
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WkT914R3YStYJp//d0Bbmr1izrA3LC3smOqhwSDs1Ds0tcLylS2D33ZlVYE3?=
 =?us-ascii?Q?f6YE2mWk77mCIn4GfCJ9Dz+9CeALRhW/YTcbWNGddV6r3R+60qN8JsGJIl4o?=
 =?us-ascii?Q?UK1oGBDo5+ot93+AOqq52SsndDnwYs+Elb8yWToE1KSTI9pf1k/2qYacWQKu?=
 =?us-ascii?Q?dWMfLz/dXMxCQc43E1IbIfbndiyGyFo1+cnm/STIbiniWhpJoTM+Q9xGgnTC?=
 =?us-ascii?Q?+dQuSUO7xiFCt1jQQ4x85KIw6aH0VWBMOCLNAKyRGpz74wL7HRlJtmkS0HMB?=
 =?us-ascii?Q?fiXIOUlXGTdvaf4XofmV3ZRU/4UpwXv3M3oK+gcKDV49sLm/R3/mzjIfhAXi?=
 =?us-ascii?Q?8CSV3/gcOztrq5x6szMYwxMA9q8hxFOMaap0OrZtzq+w5WFe8e1D4gYJ5tx5?=
 =?us-ascii?Q?yUA1TGRhYQmPznGONKxqgRENuNXHjqaJGg0nzpOnonH5l/4pQolwVUlS2UXe?=
 =?us-ascii?Q?X4SPiXAl0d1M/T6AHxIzwT+utqLxVKInzrAC72hXb8Ed4GwX+djjZZzXxWAl?=
 =?us-ascii?Q?LV+5sNpr1NSI4unFDk0g5/8+pHEfoiDqZV9JDjZD2EUzVSPo8PxzAcppzKqL?=
 =?us-ascii?Q?l072iHd2tSfDZUfCVu5tQ9h7ar959UHYH29Vp6yjJelhvVdehwUfzLsB1IBG?=
 =?us-ascii?Q?oBfZ3OlWRVCvN8TO4u4zxDwQFc9xxC/C4xSZ2zKDN+D0mZIDSd/dvchkbdmG?=
 =?us-ascii?Q?xt2F6S2AU2ZS72MtntvbZhe00djRnmSM/whBZZCkyc4PpCuvpvDCFXn0Clpt?=
 =?us-ascii?Q?7Spm8qdMN4Bzk0dPoQdRr2xvxwaSmnAVqHMNDHbaZLkaWmsgmBlvOsftkTWN?=
 =?us-ascii?Q?bBKbP3Omcsu9TegFPFRgFtOrs8eGcCisJNmEtteFDx1rjt8pkX5/IzCdcaD8?=
 =?us-ascii?Q?sbSlLjpSzdTwguumuINJUoePrSMmgE8penbaGUzPHjAlYe4XICWGVljPYw0D?=
 =?us-ascii?Q?KPhPmOGObRwlxNfy34k9CQ=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-746f3.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: 6a0c7126-5c33-484e-9402-08d9fb90e510
X-MS-Exchange-CrossTenant-AuthSource: SYZP282MB3331.AUSP282.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Mar 2022 14:36:42.8290
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: ME3P282MB3902
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Last tcp_write_queue_head() use was removed in commit
114f39feab36 ("tcp: restore autocorking"), so remove it.

Signed-off-by: Tao Chen <chentao3@hotmail.com>
---
 include/net/tcp.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index b9fc978fb2ca..a4cebb7f6f9b 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -1817,11 +1817,6 @@ static inline struct sk_buff *tcp_rtx_queue_tail(const struct sock *sk)
 	return skb_rb_last(&sk->tcp_rtx_queue);
 }
 
-static inline struct sk_buff *tcp_write_queue_head(const struct sock *sk)
-{
-	return skb_peek(&sk->sk_write_queue);
-}
-
 static inline struct sk_buff *tcp_write_queue_tail(const struct sock *sk)
 {
 	return skb_peek_tail(&sk->sk_write_queue);
-- 
2.17.1

