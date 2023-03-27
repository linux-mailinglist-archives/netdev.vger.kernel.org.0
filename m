Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D7B6CAD55
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 20:41:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232649AbjC0Slg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 14:41:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232251AbjC0Sl3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 14:41:29 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11olkn2044.outbound.protection.outlook.com [40.92.19.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D303ABD;
        Mon, 27 Mar 2023 11:41:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GqU1adcYY5Ipn4c0FMRnyqTcRj2cqI3f3H2TYyKtBWMGeB0Cx5X6qOBO2E1JvEFZXxakl3j/+i2Dlq5BqpuYPZrh4agV8uYyQfsmh9i1LwIXpftvX+SE+OaGA5m6UvwBfeSuoCnDgb4bvbHkJphHVG+wk16cp+IAbGZAj61juFmnzmEQ7ah6RmaR2+BXWjTib64UZjukHekaNyeKG0fwlacF7ZYrc0YGiwUcqGXNE30QfC4V6iJpT0TyzGCAaRqz6ls8vGj6koNMbt6u/T5J7w0kdxYpDa+XZGfFjGFp3MixBfW3qOZFDv0Hn4isULfHF4H/mKOzqBUCV/nMSw2lDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VN94TIvBkTZYlWPkYiS8BUYXQAGkWPuxb3SKaoeLVeI=;
 b=UCl6hl7askMdMDxgebkEzvzII3A4d2Csgijajz9Kj1xWtw/PPDOpcet+R534tRMdfQAHKgQLVnc6R05OaVogkpNHj71xHQvFvF//C+aCIYDw3xm1ETpRpakObOBQImn6MhYf2y78QxwEf9xCsU/IsP8u/w2O5Is9DB+skBRun8iKzgWVv33fBbuE3Uzk6LlyDD1VtLG0cwTiDBZq+9kCPXRTizLYteAOwc8TsTrrXjEFW8SRaDN/EdRmHy3LsBtbNumnfVQZwYtJmpMPhmphXXkL74fXnemhwngtXmDEeM4BYki+uxwZr1Ye6U1oK2lkio5q3aphEe5LH94h88cihQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VN94TIvBkTZYlWPkYiS8BUYXQAGkWPuxb3SKaoeLVeI=;
 b=mCMMcY04+cN0y/Dm5z23kV6Sq+0piXhheHI9UqcvX7CjF+yOSkZ4nahvSZu1CxtIaHJDh9cP5juiNAwXTc5DYKJB/bPFzAl7d8pfvJXJAWO3slzhb13OSWsxZrvA6mOwD9fXe4POmdmzLytG8c8jQ6AzSd/wayMlWq7V52ZTtEsXDNeAnIoe+7B9BoDDnPpPqgJd/O+oZ8eZhGOVERzhV/MOeoFyqMDGJHGhslvRgvIViVuOmMtbTk70TXSRug6fUEPEto8MAOLGF6EsZu9OTt3bvlErxuQuvwTmNmZbDnqhlVagUTLJ/5KfRPHC1ft9f9O1u2o6Ckm1OJmL3+2Hfw==
Received: from MW5PR03MB6932.namprd03.prod.outlook.com (2603:10b6:303:1cd::22)
 by BY5PR03MB5251.namprd03.prod.outlook.com (2603:10b6:a03:22b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6222.30; Mon, 27 Mar
 2023 18:40:13 +0000
Received: from MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f]) by MW5PR03MB6932.namprd03.prod.outlook.com
 ([fe80::191c:ca4e:23a0:274f%8]) with mapi id 15.20.6178.037; Mon, 27 Mar 2023
 18:40:13 +0000
From:   Min Li <lnimi@hotmail.com>
To:     richardcochran@gmail.com, lee@kernel.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH mfd v2 2/3] ptp: clockmatrix: fix wrong parameter passing order for idtcm_read/write
Date:   Mon, 27 Mar 2023 14:39:54 -0400
Message-ID: <MW5PR03MB6932D87AA9626A1F2196EBB7A08B9@MW5PR03MB6932.namprd03.prod.outlook.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230327183955.30239-1-lnimi@hotmail.com>
References: <20230327183955.30239-1-lnimi@hotmail.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-TMN:  [n7G8JKKI3D20wx/rT1wN/5nc2qiVvH9z]
X-ClientProxiedBy: YQBPR0101CA0092.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:4::25) To MW5PR03MB6932.namprd03.prod.outlook.com
 (2603:10b6:303:1cd::22)
X-Microsoft-Original-Message-ID: <20230327183955.30239-2-lnimi@hotmail.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR03MB6932:EE_|BY5PR03MB5251:EE_
X-MS-Office365-Filtering-Correlation-Id: c2d66f12-207f-4fb3-3517-08db2ef2b364
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zvSPxzmXmZyJEOCSvVQZbUcavRiOrlK+VwrA1y3diWD573VSOymqwctquswmzqkgHkqlvlxuEQ6fKY9WPereKCIh1rYwKuH9f2tfA8sUasQNjuRG32Vy+uBZaUrb42MaNfqLI/gtQnvUh4Wp60pA6tDEunlvIkyjuT64CY7BBYCFNu54UpvZG4kaNJxxLihmZJQb9Sl/7iZFb1hCZZRFi63Hf0YDr5lnzzWI63Iuenu9WEGvm0HEik8i33kl6IbbbfmqLUhiS39C40To3YRwsAGeM1cpwSRz5viOjVi74aohKIEnLqXH36xTvI3vPG42LV6pYG8h/n1wVVdyZ9zYWU82RD19qIGHDfapPXiKzO2GshZvb0pnZiVyjjB6ydzVhwE3vk920yS2BcqGqxwq9/NWCNFM3xTV1SD+VhuzDQTurLbsqyhahKKsTQdaRyuMgTUVlOao4P/DDM3W5j0dhjOnLCwJ+1zqsyXYk1DezD0h9Ay/MVVU0XIDM5Q00Dw1XCxUu3cSwopkGJ0fJVjkMFSfAXIvrjs6B/WQFxbhxzV6zNf5y4m6/RiUc8IuEdvf
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?zajadUjUKgPXTutxrNSDRstCuYpjvgnQjA96cRPHA7HW0Yo4S8KQrlWyKz0U?=
 =?us-ascii?Q?CuMVjfmSGlAIa82XT09bX0BHbpJBckuo6D8z+WwpyqhEuVmzfiMWUrvmK+1O?=
 =?us-ascii?Q?Rz05arvafGCzX6ECX7+mXSbK1MiqtRMLsRwXb48X6W4GXeHkOdeu1Rb12eL7?=
 =?us-ascii?Q?8qANMib5f/0V/DatdgQJ4l/SRYJiuKd+48MPKZnYR772J9HBLmfxLEC2s/YR?=
 =?us-ascii?Q?+Rigo5Y/XK1d0Gr9zfEWc3HT3u1o2dmlksyuamPylyNCfNXOrN5E0gu05k01?=
 =?us-ascii?Q?NSxcHBRUUJ4Ap49e22gXdtmbH6kTjLawuiyde2nH11C5oSH5ksBQ4ZJcEXaI?=
 =?us-ascii?Q?fp0PODOkpm1rz3xdZJqe0uWyVRJh7rKqABCv3Ia8Y7NQpuuJdDxLkXtvJypg?=
 =?us-ascii?Q?/dkATI/H7mk+Vz4McfaKPuqC+GWlDINyIG/d13Lf7K6jyE1p/DHjJtkGIjcw?=
 =?us-ascii?Q?laAJ/0iYvTscSg4s6cuA2ietIwtZmspZdgDh0jhvxTsXhqYQ5t8yPo3yzW5x?=
 =?us-ascii?Q?lbPviCdrjuXblMO7JlMmh52+SRn1RMhz1X0p4MqNJCQA+KagHX1GabYLojt1?=
 =?us-ascii?Q?jpwSGmcMOkLtAob6MWKx3vCgopAjBM/RR8sOL6p/wUBWJyb2RJgoRe+JfGwu?=
 =?us-ascii?Q?4xdLSBTI88aTlJJm4rnd5S1/nF9dGlGddcjcYEwyDTBdqAE0b07mAE+oP8G9?=
 =?us-ascii?Q?gbYsirwzf0SKhpqtcM6HvyWZbhkfbxz5meHWKOhky5RFGEt3suRs9wFkApEo?=
 =?us-ascii?Q?gPKnByHwR9hXQmxx6yyE/45wTF2zYKo8WeT4rlJxO2gUtkBvUfE49OxvWPXM?=
 =?us-ascii?Q?UIGO2v9Sc6p2xGHyp6Dx86OQmoSNzI/9u2TKodz+cJAkruYdwAlO5jfAjutt?=
 =?us-ascii?Q?BuJEPBvPcRrehR4D1YJF05u0V02SqGB8s04uS82rL9kVX9+9gsYqvK+WgJU1?=
 =?us-ascii?Q?uY7r7I3jp02IsQBtqPood/brj/zFUbD0xOK5tO2u4+9IlyZkeETCWzLeOM7e?=
 =?us-ascii?Q?aHrb1Ekga6qrM5WeGx3oR2IreMIy8SXTgH0fbM3gYMWvrwPZcr4/8V2SInaB?=
 =?us-ascii?Q?rcImhIMBP5E01oh3UvMIp8UqtJo+IQLOJ1ijzVpsBhz7Sn4QE4raFFYSdGkD?=
 =?us-ascii?Q?luFy3cB6i31b2Opjn7qsSH8BZrZPIX0H2LOnTrMnlc0inJDCDRBX+MzJmdhE?=
 =?us-ascii?Q?IzM/Yog43+SS7TNDT/kGnLw/gIgGj39gQRGhEQ=3D=3D?=
X-OriginatorOrg: sct-15-20-4755-11-msonline-outlook-685f7.templateTenant
X-MS-Exchange-CrossTenant-Network-Message-Id: c2d66f12-207f-4fb3-3517-08db2ef2b364
X-MS-Exchange-CrossTenant-AuthSource: MW5PR03MB6932.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2023 18:40:13.4110
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR03MB5251
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Min Li <min.li.xe@renesas.com>

The involved addresses are module instead of regaddr offset

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index c9d451bf89e2..afc36ffdd093 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -576,21 +576,21 @@ static int _sync_pll_output(struct idtcm *idtcm,
 
 	/* PLL5 can have OUT8 as second additional output. */
 	if (pll == 5 && qn_plus_1 != 0) {
-		err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
+		err = idtcm_read(idtcm, HW_Q8_CTRL_SPARE, 0,
 				 &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp &= ~(Q9_TO_Q8_SYNC_TRIG);
 
-		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp |= Q9_TO_Q8_SYNC_TRIG;
 
-		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
@@ -598,21 +598,21 @@ static int _sync_pll_output(struct idtcm *idtcm,
 
 	/* PLL6 can have OUT11 as second additional output. */
 	if (pll == 6 && qn_plus_1 != 0) {
-		err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
+		err = idtcm_read(idtcm, HW_Q11_CTRL_SPARE, 0,
 				 &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp &= ~(Q10_TO_Q11_SYNC_TRIG);
 
-		err = idtcm_write(idtcm, 0, HW_Q11_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q11_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
 
 		temp |= Q10_TO_Q11_SYNC_TRIG;
 
-		err = idtcm_write(idtcm, 0, HW_Q11_CTRL_SPARE,
+		err = idtcm_write(idtcm, HW_Q11_CTRL_SPARE, 0,
 				  &temp, sizeof(temp));
 		if (err)
 			return err;
@@ -637,7 +637,7 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	u8 temp;
 	u16 output_mask = channel->output_mask;
 
-	err = idtcm_read(idtcm, 0, HW_Q8_CTRL_SPARE,
+	err = idtcm_read(idtcm, HW_Q8_CTRL_SPARE, 0,
 			 &temp, sizeof(temp));
 	if (err)
 		return err;
@@ -646,7 +646,7 @@ static int idtcm_sync_pps_output(struct idtcm_channel *channel)
 	    Q9_TO_Q8_FANOUT_AND_CLOCK_SYNC_ENABLE_MASK)
 		out8_mux = 1;
 
-	err = idtcm_read(idtcm, 0, HW_Q11_CTRL_SPARE,
+	err = idtcm_read(idtcm, HW_Q11_CTRL_SPARE, 0,
 			 &temp, sizeof(temp));
 	if (err)
 		return err;
-- 
2.39.2

