Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FC2752356D
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 16:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244674AbiEKOZ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 10:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244660AbiEKOZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 10:25:45 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2101.outbound.protection.outlook.com [40.107.114.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A075E9B;
        Wed, 11 May 2022 07:25:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkHbLy6hSYmDvcfcu/LH+91HmqHSyUiDrwEexN10Wmjl1BFsQFkuzVfRMonnpOfe8c/+azYW7GpNd1OSfLnc9ooUg9iN80VXjhRUQzGfAol88rQmm3htAMdEh4rCHyoUI5uu32nCXiv9/6UI5F0u5tzUhzvR6CmD5eRNCYoEcthTeVsgokkQY8+D9+CyTzS6wjFTYGxC5tex+LR+EyOoANrUmWGm76NzFh/BNcEauVA51RhNCB2AGNIaJgP+nVphmJESxVy7MXn0Ye1M0JcVMvzgc7hmAKYbfdnBXmtkaejscUiT2heEPY39lCTR5UgJORVVZRsZjFbBp6K1Tw4/gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0YWEn41LK6IgDcRT84tlqkHUgJFOtdqr46aFsWge7Ow=;
 b=f6+/x8TCDKJbEIMSsQMaLu8kBU40ZcT66l29Ts6TvDlwHdwWZiMUNIRkrhjjjRQL/qqBg25tBUAe9X6OzIlpCYyPCh5DpBrsh+QDENRfcuuZwACCmDg9XWjUsgcU7+aT3eR9RpBH44y9uczJeE5iCwVyH3wV9kpsyqmnmvc6gc/F5hmhMam3jlgpMEmKYCH43o6CWne0i6WgsRyzIQr3sWXawwsegRN/jMmpYbV5SX+oktjIpD0eWTWWsGF+WhYKL03j67gXUjDpkgd/B5NAAc0u+9RECWtcC0C4zuqfqs7ndoJp8p6EBw/y9TYAuRWlCUk93tXSK7Ogpi2h8CJ2yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0YWEn41LK6IgDcRT84tlqkHUgJFOtdqr46aFsWge7Ow=;
 b=nJZkfUWeP8bfi3zRzw96WeXIqNa4+KnnX/tY5bV3zKQumuCGJwehC9/dM8KXzfp8OWHjlvIJyLRBzELp50C5yiWy5XdlDqjRa7wK5lPmxx4faeZLK0dQV6NWE+CChQuU4mA1r6Cs8BZp5zs5PMqJY7TbFp0GeR81Ix9P8jkynj8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by OS3PR01MB9545.jpnprd01.prod.outlook.com (2603:1096:604:1ca::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.21; Wed, 11 May
 2022 14:25:39 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::a07c:4b38:65f3:6663%9]) with mapi id 15.20.5250.013; Wed, 11 May 2022
 14:25:38 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic change
Date:   Wed, 11 May 2022 10:25:14 -0400
Message-Id: <1652279114-25939-3-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
References: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
Content-Type: text/plain
X-ClientProxiedBy: BN9PR03CA0203.namprd03.prod.outlook.com
 (2603:10b6:408:f9::28) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 462001d4-4fb7-4805-3311-08da335a1f04
X-MS-TrafficTypeDiagnostic: OS3PR01MB9545:EE_
X-Microsoft-Antispam-PRVS: <OS3PR01MB95453FEC37663E7F2169D359BAC89@OS3PR01MB9545.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9b/m8H4PQp8ekJwH94fetiYgXDjF1WEK/Iu3WYl63J3ofjTHbYJDkZew1YPGFUI1XnK+bHj8GiXHHZNyOUi1vkaEdmSi3GtXq2WpTZcNeleQsWyUJvLij8iCuGd4ST/nYQtKvWGP/W0B9rbbSeFjTbY5jP+e6gzJ0uerlwjg5CDNvJcy0/VTmfA3OEJH1T87jCqyOQC7FfyOBe1IHdgzEEFTEzEbqtscFYNXI8zi2YnCeO3EqRda97gT064gMKaWRiEuZgqzgAqZ4g5aQnPf1J8/lTOKFVx+8LumbAajZSvflW2m+hlO+Wggsdm0B57WHQ8Vra15fbVctr9AZPjnOp4dzRiU8U/OSx8RZmmJ0C61zRYXT7CKrMBVpuVBdXKMvVr2+mH0xm0UIehDq3KiSaWB6mTSeR9qAuV4A9H60SGwkgqj4b3CLdHgK5GZ4CUQ79A0XdTCkPON1MjFF7iTIc9v241fC4dJHZWbOUVL4Uua3YZ5KHH3fgR8EPrF63iSPprlRJ5wlD/zJDyp9WYlTjVs/Yf5LaS4feLrzVqY5HrqY2ab07JJUUm/yZt+tPRVH3XNZAtPys0T3E0Q1L3G9/nAlQgzk/6UiKx/x89KDpy3cvTq2XBw5eJPEwyTD+D0XgKfcpi52PkPwbINKTTxtDXtE9h/j2/Tqd46u9mNRQGLs/awYqhx7BDePpCPM3ipzyJk59qC0QhnSxAGORC8Nw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(2616005)(6506007)(6512007)(107886003)(26005)(4326008)(8676002)(38100700002)(66556008)(66476007)(66946007)(186003)(36756003)(316002)(6486002)(86362001)(6666004)(38350700002)(83380400001)(52116002)(508600001)(8936002)(5660300002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S+dUWDIRaHrlzyGHz6YMHQPduK2+oUZ8Uhmfkq1aPf2usLOMKtbTkt2OO105?=
 =?us-ascii?Q?WArA667aFd62wJ3GYU3HA156ldiyqK+jiLAzCT+3v29R9oCnIrS/Qoi2FxiA?=
 =?us-ascii?Q?LRlBHnsV3waFqr8QAL7Xewr+38V/g9yiE89JP3YfmET3vUxMX8w1NweKYBKf?=
 =?us-ascii?Q?moLZfJcmiQxptr1niHZj5u6w5lN6sQS03PNP3FYvdiG8zxai1SXithpHd9cu?=
 =?us-ascii?Q?Sgjkt5iH0IpFECLityr6Ee6Lg1kDl71u0CKvjMckbbSmMGnn1b4ykjuIvkJb?=
 =?us-ascii?Q?K/lkDUmYJVNMOQJovuPRrQQaLq9NoZSXv5UfwN9Dem6FpicTbxqbP/ozEoHn?=
 =?us-ascii?Q?To6DbXD3UEr8B/eUXMzAjSWMFBEi31w9It5sfAo/jEbWR+tGiRS71Pjz+yRU?=
 =?us-ascii?Q?nUdNJi+OynOvJQxaecryk5wYrJ8eor7ylVK5YaVoAPT1+ScCbNAy/2APamFi?=
 =?us-ascii?Q?pqsFgZPQ0sqZd1nRlPEHUyiH+JgFl94rhWcsNQIwfwP5dgrWns1xHgYCmo0w?=
 =?us-ascii?Q?OMOr4uHW7et7N/Cfx926wsdSQUVW1hto6gG8ZVhcD7WMA4oimvFlbeHyNUsm?=
 =?us-ascii?Q?7At/x3VVWS7wHAuwu0tr1SVFrdD3rLspCFVD4X9DANPJFEFAvQ1Jr4znFE7X?=
 =?us-ascii?Q?COPtAZlP0V7nzPtGrKwbe4vDppZK1Oani8Df9BvF0eYK/wuMAvzKG76ZVViI?=
 =?us-ascii?Q?T8BFp0a3m9aNSmSQniEFkMfX1iFk/Q6gnCyVuRF+STf35rTD6v+koTSd87N8?=
 =?us-ascii?Q?8caJUo9lQYp93r+hl7ydtYmTPRxoaMTm7Y+6yPe7KqNAoWxPIakREU18cgfj?=
 =?us-ascii?Q?bilSIkkDwYzXYWYVkjBxpgMSb7ZQ67mglrVt4TY55QFUWY38EEVNTWrjKzPX?=
 =?us-ascii?Q?8avf9SAs/U3wrS3Gneqz1gCowDQtyQSUnCdqtdeGhq2jsKx9yYNf/2pY25oe?=
 =?us-ascii?Q?aXorS0NqHR49WNAbDxv24cRwEeTOijfh4hzUpjdwRlNg5W6g5MhIt1bhPb9e?=
 =?us-ascii?Q?onqZVbvEu0baacHh1VLgYPo4ThaAyFvlCODAFPDmijvtgMizXIc7B+amwOyJ?=
 =?us-ascii?Q?w/Dugr+2445yeTANWYU79a0UBhNkFYwQpdm4rp0wvS2ExHpQqS+C/xpv8mC8?=
 =?us-ascii?Q?N5gMegmSe66op+Wr/Rp4CpHA4Jz6RZlQbFCTStigRMTsjXRt9CfZkjZj6wCm?=
 =?us-ascii?Q?E2C1PvIeUQl22skBtZPj7HTSCJMJ9RcFL4LqRKSLPsl/qveVBbmAI4Wk19gI?=
 =?us-ascii?Q?SDuAwe3liaBTd9O2eMc6r7GbB1MtjHhqQRUelh6WUjEW+eDQEAESSdW5BbrV?=
 =?us-ascii?Q?p9CSfmDA3v1l80I1Dkxs9lq2zCcRMXazCXGV3zw0XosH4HOmf+Q7TYJejl56?=
 =?us-ascii?Q?ZvPhjY5YeDG0zMkuXFs65ITAcnKUET+eTiS9RH9QgqdwiaAqDfR57IkahaWK?=
 =?us-ascii?Q?4u+bz9Uh/S42hUgldffQJfOBKI/Su7mcmh5bgMXo057obJ0RSiXPIJ856lvy?=
 =?us-ascii?Q?Ob12Ciy9hw0bDaJxItja1hTtp3WEJuNsTnlX9p58RiKmZ8rs9Uy8EUdMAzyB?=
 =?us-ascii?Q?qBTu8ypmb7g35C2msvtKujaNNbvbL/f9R0gEUHIgqYKjLUekQ7jZEYGy0AfO?=
 =?us-ascii?Q?ImYnDYh3X0XOYcd4BcRgQZqews2vuM1rHCtjpNoMyrJyjo81FwjenEPIj0e7?=
 =?us-ascii?Q?F4AIDbQgU16oHoVtcJ0mIhEeny+0Rcq2rAB0hdxC/X46ppntu2/C3JM4CSFE?=
 =?us-ascii?Q?7L1dQND+ffpBxdLQfa89Uz5gs+S9UFM=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 462001d4-4fb7-4805-3311-08da335a1f04
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2022 14:25:38.8975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULQU00eg4wLJUpfOVfwYYhjmCxDA2u+CEEgvzo9p0P9d30mhDSGjeOHOsVYAnOLEmjSkdhZ1qQgE1fWLAmhYlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB9545
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

suggested by Jakub Kicinski

Signed-off-by: Min Li <min.li.xe@renesas.com>
---
 drivers/ptp/ptp_clockmatrix.c | 69 +++++++++++++------------------------------
 1 file changed, 20 insertions(+), 49 deletions(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index ea87487..4461635 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -261,17 +261,13 @@ static int arm_tod_read_trig_sel_refclk(struct idtcm_channel *channel, u8 ref)
 
 	if (err)
 		dev_err(idtcm->dev, "%s: err = %d", __func__, err);
-
 	return err;
 }
 
 static bool is_single_shot(u8 mask)
 {
 	/* Treat single bit ToD masks as continuous trigger */
-	if ((mask == 1) || (mask == 2) || (mask == 4) || (mask == 8))
-		return false;
-	else
-		return true;
+	return mask <= 8 && is_power_of_2(mask);
 }
 
 static int idtcm_extts_enable(struct idtcm_channel *channel,
@@ -418,13 +414,10 @@ static int _idtcm_gettime_triggered(struct idtcm_channel *channel,
 
 	err = idtcm_read(idtcm, channel->tod_read_secondary,
 			 TOD_READ_SECONDARY_BASE, buf, sizeof(buf));
-
 	if (err)
 		return err;
 
-	err = char_array_to_timespec(buf, sizeof(buf), ts);
-
-	return err;
+	return char_array_to_timespec(buf, sizeof(buf), ts);
 }
 
 static int _idtcm_gettime(struct idtcm_channel *channel,
@@ -456,9 +449,7 @@ static int _idtcm_gettime(struct idtcm_channel *channel,
 	if (err)
 		return err;
 
-	err = char_array_to_timespec(buf, sizeof(buf), ts);
-
-	return err;
+	return char_array_to_timespec(buf, sizeof(buf), ts);
 }
 
 static int idtcm_extts_check_channel(struct idtcm *idtcm, u8 todn)
@@ -500,13 +491,10 @@ static int _idtcm_gettime_immediate(struct idtcm_channel *channel,
 
 	err = idtcm_write(idtcm, channel->tod_read_primary,
 			  tod_read_cmd, &val, sizeof(val));
-
 	if (err)
 		return err;
 
-	err = _idtcm_gettime(channel, ts, 10);
-
-	return err;
+	return _idtcm_gettime(channel, ts, 10);
 }
 
 static int _sync_pll_output(struct idtcm *idtcm,
@@ -631,9 +619,7 @@ static int _sync_pll_output(struct idtcm *idtcm,
 
 	/* Place master sync out of reset */
 	val &= ~(SYNCTRL1_MASTER_SYNC_RST);
-	err = idtcm_write(idtcm, 0, sync_ctrl1, &val, sizeof(val));
-
-	return err;
+	return idtcm_write(idtcm, 0, sync_ctrl1, &val, sizeof(val));
 }
 
 static int idtcm_sync_pps_output(struct idtcm_channel *channel)
@@ -917,7 +903,6 @@ static int _idtcm_settime(struct idtcm_channel *channel,
 static int idtcm_set_phase_pull_in_offset(struct idtcm_channel *channel,
 					  s32 offset_ns)
 {
-	int err;
 	int i;
 	struct idtcm *idtcm = channel->idtcm;
 	u8 buf[4];
@@ -927,16 +912,13 @@ static int idtcm_set_phase_pull_in_offset(struct idtcm_channel *channel,
 		offset_ns >>= 8;
 	}
 
-	err = idtcm_write(idtcm, channel->dpll_phase_pull_in, PULL_IN_OFFSET,
-			  buf, sizeof(buf));
-
-	return err;
+	return idtcm_write(idtcm, channel->dpll_phase_pull_in, PULL_IN_OFFSET,
+			   buf, sizeof(buf));
 }
 
 static int idtcm_set_phase_pull_in_slope_limit(struct idtcm_channel *channel,
 					       u32 max_ffo_ppb)
 {
-	int err;
 	u8 i;
 	struct idtcm *idtcm = channel->idtcm;
 	u8 buf[3];
@@ -949,10 +931,8 @@ static int idtcm_set_phase_pull_in_slope_limit(struct idtcm_channel *channel,
 		max_ffo_ppb >>= 8;
 	}
 
-	err = idtcm_write(idtcm, channel->dpll_phase_pull_in,
-			  PULL_IN_SLOPE_LIMIT, buf, sizeof(buf));
-
-	return err;
+	return idtcm_write(idtcm, channel->dpll_phase_pull_in,
+			   PULL_IN_SLOPE_LIMIT, buf, sizeof(buf));
 }
 
 static int idtcm_start_phase_pull_in(struct idtcm_channel *channel)
@@ -991,9 +971,7 @@ static int do_phase_pull_in_fw(struct idtcm_channel *channel,
 	if (err)
 		return err;
 
-	err = idtcm_start_phase_pull_in(channel);
-
-	return err;
+	return idtcm_start_phase_pull_in(channel);
 }
 
 static int set_tod_write_overhead(struct idtcm_channel *channel)
@@ -1417,10 +1395,9 @@ static int idtcm_set_pll_mode(struct idtcm_channel *channel,
 
 	dpll_mode |= (mode << PLL_MODE_SHIFT);
 
-	err = idtcm_write(idtcm, channel->dpll_n,
-			  IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_MODE),
-			  &dpll_mode, sizeof(dpll_mode));
-	return err;
+	return idtcm_write(idtcm, channel->dpll_n,
+			   IDTCM_FW_REG(idtcm->fw_ver, V520, DPLL_MODE),
+			   &dpll_mode, sizeof(dpll_mode));
 }
 
 static int idtcm_get_manual_reference(struct idtcm_channel *channel,
@@ -1460,11 +1437,9 @@ static int idtcm_set_manual_reference(struct idtcm_channel *channel,
 
 	dpll_manu_ref_cfg |= (ref << MANUAL_REFERENCE_SHIFT);
 
-	err = idtcm_write(idtcm, channel->dpll_ctrl_n,
-			  DPLL_CTRL_DPLL_MANU_REF_CFG,
-			  &dpll_manu_ref_cfg, sizeof(dpll_manu_ref_cfg));
-
-	return err;
+	return idtcm_write(idtcm, channel->dpll_ctrl_n,
+			   DPLL_CTRL_DPLL_MANU_REF_CFG,
+			   &dpll_manu_ref_cfg, sizeof(dpll_manu_ref_cfg));
 }
 
 static int configure_dpll_mode_write_frequency(struct idtcm_channel *channel)
@@ -1746,10 +1721,8 @@ static int _idtcm_adjphase(struct idtcm_channel *channel, s32 delta_ns)
 		phase_50ps >>= 8;
 	}
 
-	err = idtcm_write(idtcm, channel->dpll_phase, DPLL_WR_PHASE,
-			  buf, sizeof(buf));
-
-	return err;
+	return idtcm_write(idtcm, channel->dpll_phase, DPLL_WR_PHASE,
+			   buf, sizeof(buf));
 }
 
 static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
@@ -1790,10 +1763,8 @@ static int _idtcm_adjfine(struct idtcm_channel *channel, long scaled_ppm)
 		fcw >>= 8;
 	}
 
-	err = idtcm_write(idtcm, channel->dpll_freq, DPLL_WR_FREQ,
-			  buf, sizeof(buf));
-
-	return err;
+	return idtcm_write(idtcm, channel->dpll_freq, DPLL_WR_FREQ,
+			   buf, sizeof(buf));
 }
 
 static int idtcm_gettime(struct ptp_clock_info *ptp, struct timespec64 *ts)
-- 
2.7.4

