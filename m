Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70141564D8C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:13:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231585AbiGDGNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231187AbiGDGNW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:22 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F21AA65CA
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NU/cxAiJKT+NGFWB+hDnTmy1kSgLX7HSoZiWBcep68EsqyJInp4wqKpZvDbrrmPsI6hNjBGmCpZFXn8gum2xZQEKgiAnsl3z9Jkeduk+as7VMGZWox1SUIlvxObWEcDLMJhgIG9UdxiPp+KnGEp0XP4GLXagZE99WD3WFKguLERjMrGlp4R8/29mWwUw9CUgB2cPz913f9ct+HRy7Xp4pPBrlXHqAuzhJsN9HzYckUlarfI+fhCOPx9RUMaR4aI0d/BUHgsGLi9sFxmlFtKfVYsAKg5/EEuOehdXFhFpRqb1DlXowrDTZsDpNeQ+LMfAajVGJJXGsLumw8SHxM3iEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sOP+MEv7QudGVnx2zgl1cN5g+7RGsk7LnHSfngj92Bw=;
 b=Z+1gzGv54w+qYXTtB2jcSapmi2El5SmA63Ul9nBDDaSm2nHiV3zGwK9qzsUwqzI8hc/9hwm5PowyyAaZ1WBCHiNKYJ2FtyzKWSNNSNFY5AkN52sXL/fZvtq+oZcnHsP60hHUntjcN6BoAkpK1tVmeJuuV78cpiLh2Bp2ttbFw0sChPdRq6cYgOhPZMKXCn2KUl5XVxHv3zsl5zjDXswl1mXOdPe9NKPueOc0mn39FneDrB1qK58NtxHUX1wNfKSXQX42jrsZmzyMqSY1PrGSEXL1FODK9S3Lb6lBifPkBaZK9IX8c52IMdTI0mB+Y+6XncWVQNBt659g70nOFJy7Sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sOP+MEv7QudGVnx2zgl1cN5g+7RGsk7LnHSfngj92Bw=;
 b=phme6CDSOZZr1j6UrABe9NjH7XsI1UmFQVi7+RwURZbYyB/HH7eP17qqtUTmqSUYFHIv1VkIZP2KlAB82pGs6PK/nyvUvPi9CK90EGD6TLAlCMhA2VEmgcpj1K8MXXIpsXNr8lff82Hx9km6HW249grV0h98gwRlr1tnUdo0kxmmj5Lr6vJWRNcuXIKgKAiaR2Xg20gIcFmIELu456yovQz40vouqhkFyRtbDPsdtfW+aZFDpxR5a1nbCxONV6KDwlo7bxl8YJEBH/T/7wQFJm/GYlAmtwo2LJqET3/IzmzZBkJ/4P1W4PxDPpxlASzqEhqPIFuNMOxBGjS38573Uw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:13:16 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:16 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 05/13] mlxsw: spectrum_router: Do not configure VID for sub-port RIFs
Date:   Mon,  4 Jul 2022 09:11:31 +0300
Message-Id: <20220704061139.1208770-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0101CA0068.eurprd01.prod.exchangelabs.com
 (2603:10a6:800:1f::36) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 60571499-ee2d-43d8-4214-08da5d84486c
X-MS-TrafficTypeDiagnostic: DM6PR12MB3068:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: MlTeourzbW1QcLoB9tNXq00rMJoiSOxn1nj4wKUPGfACmwnsrZV21RJEB/edF0tLFwBm0xlXHN2GcJUbb3nxrbzddjdAgLUagh09Q9MjtH9HqJSvleGwRpyNAuBF6SnOHvntf8MGhy+JITtIb0esFxg4j8klVU/tVO/75MCfn/gWsW+pXRcYJSUetXHZ++uROwcM/a8ojBeFHYYsCHqvzonCKfsOJXDKk+SlN52dsUIkeD+H4B+0jsJGxkmsAbjTlTPbstgrfTxCOlzs7t0ZPiM245J7EZqMwlqi5g8U1g0JcFiRvjce4jxy+qdmbiwpDx+U2TMZ30tpIpMX7RR++YCjraidlQvUCwOOsybPr3cNtDyrBbJCc7XZjpFYCfCzZSuGCBjuZ8iCX9ez+j8J/Aw3luYqby4gvPTTOT+7HKM3gxCw3Y94oGZfLUPI5Vqhr4ASiRylK2RGlOd/+9SOWh3IjQv2WvU/tr65R1QSyxtRIx7Ks0wxBWewduWrWP5WtAmMkNsLxqzsOVP8pTPyJkyC/yMN8cNpYAIMtO2LHnV/iPjhvXS5Q8sttE2One2VQi86+crn9wI0vb9MWryQBm75CHAVaharHjv0GG1wF4HUCOGPTpBRyovoHQTx3j/trK8DXQmWw+pyrq4suotTTlO151zSJxIhyXGJClP8/xuqR+gUYdQ4iFEa+77A61sIG0Zq0VBI2JTVhby9dL69jfIilgPiWiw3wRcNgvpaHF2ccvWAF9tIvtmmPQGD40jQ0GmrJaIqbSpiTN2VBFksxg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(366004)(346002)(39860400002)(6666004)(6506007)(6512007)(4326008)(2616005)(8676002)(66946007)(26005)(66476007)(66556008)(6486002)(6916009)(86362001)(41300700001)(316002)(38100700002)(186003)(1076003)(107886003)(66574015)(83380400001)(478600001)(2906002)(8936002)(5660300002)(36756003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?KlvQIyNWidaFxidivBs3ZHoQAdnhhChhf7ExWpmbSlhZZNEwy6XbC3oMum4a?=
 =?us-ascii?Q?Xsh/xMQAqrkIcdR4H+FwgQP4CO27iNT2RxZv0h05i0WD3lp9uFmxI5M57XIq?=
 =?us-ascii?Q?v6Fb8PzcKqMSl260A+SObS6vrfJNG/aBIj0HwdvH2tMEr7isYmqF9Xps6BMy?=
 =?us-ascii?Q?YFYJBsHQBxqdD9Y3U4qYfozmIRqKc6QApwpFwKOp8rjbg4FxUlgSL/TYQhEr?=
 =?us-ascii?Q?TBe0kzY4IbIeZrWch+gFOmwxVi/1q/ag2RqyS0OKGxr+P/faB8KCFfMk8pBZ?=
 =?us-ascii?Q?2auujIJblMXwjU0daQAoznbNW2cm+QnO2ZtY0tAeffV2aXqeLeqnb2PW9GoK?=
 =?us-ascii?Q?+g4kvENyjdezIbcy+Yy8CMNsae4vHw8g0uch+2SzrZvM3hvBnRUdDJKuSVvd?=
 =?us-ascii?Q?mV5ceehXytvNK5vCQrShcTwHT+bPsdS/K11PO8KEKeSZCphHIu9z4rBThd4y?=
 =?us-ascii?Q?y3/8S7tU15DBLInmlf8vl6wHZyUxkMoEjI6lnef6wwS/K3nymWoPZ3+E83fn?=
 =?us-ascii?Q?1nW0ZOV6BESJ9htp9p3AbWWhqKjc45qC6LFui1S/lIgqPDd0polwTkmSpV9O?=
 =?us-ascii?Q?gA5DS229y98WmcRY/6cPkEFz8N6M38JYo5OctniBSKSmvFu7doSYwNDePH9t?=
 =?us-ascii?Q?4sNpVId1bwv3u1xqTatzCFeGaWO8B/6fKEmr/xfu1t+QCG4SLBE5ULmr7thB?=
 =?us-ascii?Q?gudvk0T/0QnbLQvViXFGZgxYDdQAJUcfzAVUaDO9fWnDljr6xb2mNwbmUzwl?=
 =?us-ascii?Q?ZVU2FgTrLJKSU3bYSVSFNxofPukhM1vW0SrhpoGrcfcnkoaEfk2ghSwPqcPI?=
 =?us-ascii?Q?fXsqwi00XuMQsiyIFBA3mn2MqOnzLtuiQGeqklDpdepQBqy7SW3dH57fQ/dY?=
 =?us-ascii?Q?zwWIePQTJS6/w0yHSShJx7pRSi/OnoTSKgZOXHg9gPbVx6Tn12k/0hq99/Wt?=
 =?us-ascii?Q?S1+N2P7e4DSPLttF+4162jtdUNdakJP7JPjleEreTtoXP+ZeZlglkVZoLRrd?=
 =?us-ascii?Q?VJp3+X9qI73W2uw2KkMmsJ6gzt9TzqpZ7Nkt8byIGtcMYvQVSOaiwoiXX+Op?=
 =?us-ascii?Q?BWoqPcTBzHy5/ZIR03CGU0GI+fNQCxkV6Zt04UipeguYbH0VSXXChyTLH52s?=
 =?us-ascii?Q?WzNkAAlQ7m/G2NNc44KutwpGwanVAnRJ/sA972tSG61hEbKalan2ihPKElQ3?=
 =?us-ascii?Q?XCDgN6s4ps+QCmOXfAR1BfAf71ifyAvbb4QWAeW6dbbCJdVmdU+NYNwooKvM?=
 =?us-ascii?Q?pvIfEDFsMHpq24CrDxF3mL0t44gfAG4vWg7xT6SXUkUyjOnOST7u5kVWf1Xn?=
 =?us-ascii?Q?Hja0VHzv9FbG0TKdODVizPs7GIXLGHFEJ1CZvyB9RY0Fp8MfXQkakdLCo2RN?=
 =?us-ascii?Q?3gfeXuoKmZQUvxqhlxSy2BLebdqgKhz7SXK5c3l2b4+xBA1wFEzesi/2p5cn?=
 =?us-ascii?Q?pg7742mDd2sMvbMoVLk8xWKlc9wXbIjesr4N/7ykGwebUePLIZAcwOIRe1AT?=
 =?us-ascii?Q?fkuMqj+lGd7kjwqbr6ZaJVBLnKx97Gl1MhKBAeR2/0TV4gDf6+V8pGOkaunH?=
 =?us-ascii?Q?PgZaeOeDAnsgKZucMF0vk86n+G1B35FrQaE12Th5?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60571499-ee2d-43d8-4214-08da5d84486c
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:16.0666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wmPsuCTTAiHTZg77mHX2btMeGqQBeGa+xfTJdsdiOkdE8f9L1hfKSO+EoLzWhME28ALfhRhvr3HAETcDVtsq0g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The field 'vid' in RITR is reserved when unified bridge model is used
and the RIF's type is sub-port RIF. Instead, ingress VID is configured via
SVFA and egress VID is configured via REIV.

Set 'vid' to zero in RITR register for sub-port RIF when unified bridge
model is used.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index 4a34138985bf..fe3ae524f340 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -9325,7 +9325,7 @@ static int mlxsw_sp_rif_subport_op(struct mlxsw_sp_rif *rif, bool enable)
 	mlxsw_reg_ritr_sp_if_pack(ritr_pl, rif_subport->lag,
 				  rif_subport->lag ? rif_subport->lag_id :
 						     rif_subport->system_port,
-				  rif_subport->vid);
+				  mlxsw_sp->ubridge ? 0 : rif_subport->vid);
 
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(ritr), ritr_pl);
 }
-- 
2.36.1

