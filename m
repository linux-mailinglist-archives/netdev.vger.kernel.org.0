Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680D9532C81
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 16:45:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbiEXOp1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 10:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234550AbiEXOpS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 10:45:18 -0400
Received: from JPN01-OS0-obe.outbound.protection.outlook.com (mail-os0jpn01on2108.outbound.protection.outlook.com [40.107.113.108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19FBB6D841;
        Tue, 24 May 2022 07:45:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dz1ruLL+cw397yvZBDI3FoKljuLD7A6nZK6JZm32B0nctlAvGapMYqsug3sweUhp1/bjX/lwGb3CO/lEJK6hyBA6OMjzdRH8Z+9ZnrfwZS0FXjdqAPn3W69Fln4Ae8mj0omozsL3uh1XgMSxII4S1nIf45dLHbCERn8oKq3gyTRm1b7rWTFX/XW+L5bbLyOYjLu3wnxYfATtfGcuUM1vR4BlpPX7w1E9tNCMWxX2K7ipdCBf6qBjBwsslb6SdqvWn6p/ruURTAFGN3bsszQwjjHzO/KkllsiXxZ8Kya21DgX2qeQjRqoK4ICZmX/XxCq6VKvS/OxJM/teKYseKC1Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqWEZUa1Ggwnqcw3vv6Idn46+T8th3T9rr1WoRcJwnY=;
 b=iWcobRCIujwBbtiG3km9I07uHJpXfBSFrPowr2EUiM/oUG3sdl0CK2APf03mDYcozyKBatCH1ujvpJzfrG5TqztCWY/UZtV/6VxB/Ht4Q+PngxplWCE5ILGtfPq3z94SScgCxM5CPcJMb6ejplOh78fRasILJ/VQEbdPwO/I46tz1EHPDcLngqnI8rMeJEttDjfX2TXG/X3YAPN4VyaCjBVmFTbmwSPo707lRuTRphiAa2b8wtmhfvthnkk+wkiNXwxJrUEsSWTgIKm9LbpeKqoKA4WSFkXFtr96O/ovJHeU6l1mxUdVFy7qXhBGNze9R7UVtT42xtNHxpDT9tanCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqWEZUa1Ggwnqcw3vv6Idn46+T8th3T9rr1WoRcJwnY=;
 b=mHvqEDxe9BdITwaeZIwwlh3uSebvxOyV0+rRtn8593Bd57/Etu6WmYp5lX/6lPPHrESfeldokkZCn7DkdTB3LiRGOoy+EtjAEQGiDP4stHUUjSi7YM/r6rBRXKNgx5Aaovj6QJKacqHKPx5YOuaY+mud/PiMDjwdQXx1LrigX7k=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com (2603:1096:604:101::7)
 by TY2PR01MB2042.jpnprd01.prod.outlook.com (2603:1096:404:12::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.19; Tue, 24 May
 2022 14:45:14 +0000
Received: from OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::89f3:ab98:2ab5:7dae]) by OS3PR01MB6593.jpnprd01.prod.outlook.com
 ([fe80::89f3:ab98:2ab5:7dae%7]) with mapi id 15.20.5273.023; Tue, 24 May 2022
 14:45:14 +0000
From:   Min Li <min.li.xe@renesas.com>
To:     richardcochran@gmail.com, lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: [PATCH net v2] ptp: ptp_clockmatrix: fix is_single_shot
Date:   Tue, 24 May 2022 10:45:01 -0400
Message-Id: <1653403501-12621-1-git-send-email-min.li.xe@renesas.com>
X-Mailer: git-send-email 2.7.4
Content-Type: text/plain
X-ClientProxiedBy: BN1PR13CA0028.namprd13.prod.outlook.com
 (2603:10b6:408:e2::33) To OS3PR01MB6593.jpnprd01.prod.outlook.com
 (2603:1096:604:101::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aa0ecbc1-bc30-4842-2885-08da3d94030c
X-MS-TrafficTypeDiagnostic: TY2PR01MB2042:EE_
X-Microsoft-Antispam-PRVS: <TY2PR01MB20428800FF2AA7906730EC1ABAD79@TY2PR01MB2042.jpnprd01.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: xSMIpEbHgoPTCpXT/MPNhHvXkQRuFZPMoC1WuaDPZCoFHeyglHUXdg4XgeiWoXi/iaKYpI9JBmmarcPTk6zat/FjW3xOneB5MIpQFPiwRu7HNrNkBgAu4C/n+UWMgj08xJ215UcZg4e4QXo5VPO1ItQ7tNVkLtUqjmxWqXNIhNk3IPEPucfzMcHVuMLt5Wujt17al7ZcduUUkFFQrjdBDpLZU6REb1y2wPHjeyd5aHSUhcO0+li99gad0j01hSxsnhQMvHinKuFZplEGKgWV6LlBrPWfw5pR+TH5pXS8MXlOtPbw6PT/qg07gyfwfSIrnct0VpPsaOC1/zntaoyfLhIdPmkf4nnzwDZWlutuSqcdp3hcDZ5kiW+QqoEqiMImhgn8IszFA5qKApikiUjI+VYdzE+PAtRzMCOa/05B2IS2HbPLastQaMf84eMc1TE8J068Xxw5Ae7Gcq7tPc/sbSUzB+49JkAJq48TJnb6/l5MqMDeFPlGE4zRT8JouPq4h6W7eHLEkeXSMKMTl7H4OmKzURz4/Rpn8oPYnHr3x5dY7+6Q0cS4hxsnyODs+yLfH2KAYwyx7dIxaiwrcW1vt29F2xpaatx22+/GTfjBG5B/ChsIuujZD/qmYl/l0HzLPWxNj6x/tigQbv9TNckbrkKK/ckYf1F+79RTH1fzVaD17XtkhzDhCa5WRryKkU4FQEGUqV3Rzd0EqZHI8Qyocw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS3PR01MB6593.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(4326008)(86362001)(4744005)(5660300002)(83380400001)(186003)(38350700002)(508600001)(107886003)(8936002)(38100700002)(6486002)(316002)(2616005)(36756003)(52116002)(66476007)(66556008)(66946007)(26005)(6666004)(6512007)(6506007)(8676002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?0yUkZUKga1UACL9NmGV0h/gyWzFb1cGvGLlcCf3KwSvbdRQk2oxMBrjpGi0c?=
 =?us-ascii?Q?pN0310Fa03nms7XJhmzt64WNB5Z1mIsTuUBoh5Fg/29dm3dDq61GJXN5+If4?=
 =?us-ascii?Q?soemg4mlwdNq+1EI1qPfJlhWJ4F/MNbKOu7UGvJdvKRcRK1SHhaXvIIz0Jb0?=
 =?us-ascii?Q?ZjKyYayIW093PDnSJnm27x65kIRDFRdW5QlISLUMb2khBYAX4aF8LZQaaN2s?=
 =?us-ascii?Q?qfQMAs+A7n9U8Iz5LRg1AypEhfB8SgArOAPwt5c+RdMd37KEAYIucWp3fdHm?=
 =?us-ascii?Q?vrSlcOxEk057pnKIAtzOFtBsxTrFgktuF/nel7QTAGVz9Mb/G6xSITBTFEPX?=
 =?us-ascii?Q?mQNrbljh8dSiCBmKoZFODCHCwp0zFkat+Vr0uPtq8dLIy1j76m4kKvZJjk5Y?=
 =?us-ascii?Q?1e62xXJe5QlzAZ998DVssY2KM4phRANi45lVQwzXhMqCF+AjhyUaMljRZMzq?=
 =?us-ascii?Q?K8rd7WJORQ+kWjGRozSU1TpafNcL8kcPtyK6l4v4ydTIoB1XG0eB3OmUEPY3?=
 =?us-ascii?Q?WKix1VW2nCMa3fTIMVsEKllC1kOhvHdv046aa0onFM6j+bYVm5utWTXGlp6a?=
 =?us-ascii?Q?v0JgjoWwLX0d7CVcbXvZIPcTIxB/Hs+95HjprXJnAKHfgJmYLk5K70E6dedC?=
 =?us-ascii?Q?ONLwNZlHFeFwUb/WTyToscMaSIJ1juj027ZPBFpH7oZh5HCZiVGy6gR/t3ol?=
 =?us-ascii?Q?Df6dLGEtSZJhN9TmEy5RsUBEaEyyOG9ILaLzZP+HWTvDnOVP00IdJXGUngtO?=
 =?us-ascii?Q?JEJJbgfI6rB3I2/V1imBqzbz55QiqVBivQyQh+yU5FDkKSdr9hmhnrbVk7mk?=
 =?us-ascii?Q?m/YV6CBh6+HEn62t4tPhZ7DjQ61qbjVvgE+IK/gQuj8uBtSzGDMyc/ipA0dr?=
 =?us-ascii?Q?ExoU5mjEbJImPz0s4VfTG/5lVPUez4rgkRyvVbxcHsU8xSuP/6YGQEZM7XL8?=
 =?us-ascii?Q?tVX7hCncXeVel8Bp/QghU0+svyNwZ3IDzyqaDZamTKgbufyBcn9x0lejWpRj?=
 =?us-ascii?Q?uAPAsSCWeQrsAe6XUCHV9WlhI1a29qDrNslNxDVMmBcr1kQOwER9ug6OAeCc?=
 =?us-ascii?Q?3PlNxv17FZbH2rz/+cv3FpaibAIYuXXYHGdD5oNM0A7vneiom+34gFy5ulDG?=
 =?us-ascii?Q?DX/W6Qi/hbP152iBu8YV9t/Y5rm92mpofMVfyHKycVFJel2SpQIh995R0prA?=
 =?us-ascii?Q?RGCiLcfHqer8rl2O4InFDQdqExfPegPbqKt1DTJxJ0+pH/2ljOGMehDFoWMD?=
 =?us-ascii?Q?1/i0yM70IrpSB6NjWLROMW5xQs41CaYrc9FWgnqzWnzhjQTMoe4MdQbvOhB3?=
 =?us-ascii?Q?HlbZmcJ+1gI1W5XbiCTdvkgvpQlsfT7yVar3Rk3udc9BiLGLK/RNbVQd1fWn?=
 =?us-ascii?Q?49Rl7qEnKgP8UUpzP2A/Hw01qRnJtQ54vOx3VoEB4RmQtwGluWCIrr+60Ik5?=
 =?us-ascii?Q?tw4g0c14+eI4trdmf7rzolkQrkyKtnjhyfPMbGD07Wwh5miSwBmVixvZCm0t?=
 =?us-ascii?Q?VGZFZMZjK6JV2NFKU915ZHLc0EPsBgvxSMn0vHlIUMtQ7Kr/iscaiaFIgAiY?=
 =?us-ascii?Q?QmHFqb5ypVt8tbdqJsQdD4VCZ37WHXODkpDAYL1w5Dpae6NhCmgp6vdkyH8l?=
 =?us-ascii?Q?DKW6oyV1jSBCiRM8Ggk/zMaICv3CYIDRXFlobvSZCbVSYMyyogMuHFE3BGY0?=
 =?us-ascii?Q?ykE6Wrc3Ml4dpkM3ikvLCKpWIkqs2kJySqykZoeAsuUm+FRL00ohaleU7AEO?=
 =?us-ascii?Q?/i75AldnZJViFlCd53w02TF4SuzsrdM=3D?=
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa0ecbc1-bc30-4842-2885-08da3d94030c
X-MS-Exchange-CrossTenant-AuthSource: OS3PR01MB6593.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 May 2022 14:45:14.6146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iTUz2srqQ81tHP0haR8mJGIGuME0kOF2r8pm+sW1XelBSzIjYQi12BVJho6aCedtM9q1SZPMCC1Qos0+4M8I7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB2042
X-Spam-Status: No, score=0.9 required=5.0 tests=AC_FROM_MANY_DOTS,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

is_single_shot should return false for the power_of_2 mask

Fixes: b95fcd0e776f ("ptp: ptp_clockmatrix: Add PTP_CLK_REQ_EXTTS support")
Signed-off-by: Min Li <min.li.xe@renesas.com>
---
-Add Fixes tag

 drivers/ptp/ptp_clockmatrix.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_clockmatrix.c b/drivers/ptp/ptp_clockmatrix.c
index cb258e1..c9d451b 100644
--- a/drivers/ptp/ptp_clockmatrix.c
+++ b/drivers/ptp/ptp_clockmatrix.c
@@ -267,7 +267,7 @@ static int arm_tod_read_trig_sel_refclk(struct idtcm_channel *channel, u8 ref)
 static bool is_single_shot(u8 mask)
 {
 	/* Treat single bit ToD masks as continuous trigger */
-	return mask <= 8 && is_power_of_2(mask);
+	return !(mask <= 8 && is_power_of_2(mask));
 }
 
 static int idtcm_extts_enable(struct idtcm_channel *channel,
-- 
2.7.4

