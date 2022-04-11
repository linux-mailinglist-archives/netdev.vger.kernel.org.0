Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17EDF4FBF84
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347459AbiDKOuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347466AbiDKOuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:50:06 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2069.outbound.protection.outlook.com [40.107.236.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA4FA220D9
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:47:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hfkM77AbNTE90mBMfcAqsXd/VJdOq6HEkvKKCx2K0YEY3vfCdpxfYEPrMjipwWZemoCddaiaO5si0gyrBhmHlzdqFZPYtTODnk5LcGAiClB+4qxZ+X8RQ1Hw38wssdRUKOGCOe9pqnRtYwbRUwoEhpHidmKIzSaynHWQmF1kftL7urRDpHhd+qQLka5Nq5lFDaLGkubLRQ1z+omd9XJpp1MPvK2lPpT+J0oyqcaVfFOCEibfI7SPXszx8s9hWHnTntiF1FF9d+kryx8pPhW6dB6NfIt861KQvgQBSe/dUo3MIAZNYjbvy4zIMNKp2tOdonwVP70vIuMkYlFNuCNfQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+UGBRcISK/88/VtYeF35MUxqaqRhpzODdfCR+b6cmVo=;
 b=FCVzmdU5HRJU6mSDcKPQdzABQOO5ImN5/zkbEN1RrMVQjBpzvT4tSlcQ2o2njtHU8/2AN64RBuXjo3JRKcmak+i3Cg/0vSlLkHLqSI3L7TzfyqTPtlN4e/gXhsAqoBje5i91n+rAh4FBJKaFRmRMTSJs8Gu3Zb+zhMvl6eqHfqLsWrsG2eOFB90Yqw/R0BB8gFDqZ+x+BUIzxMihHUS6RZHEgOQrrFXIvHt8uv1jczGQ03jBT/msTu4ovUQPcpr4LQfCTobUPwUVCXpyjOCgzUcWkT2JcwKAzufIKQpyt6sw+513WZECeTBQrO30l/9c+gsvvOA3tiRHSwF/h9Kbcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+UGBRcISK/88/VtYeF35MUxqaqRhpzODdfCR+b6cmVo=;
 b=RzLgdtOyyriZb+Pb+lVTByAb2GSxVCzNI2DzpacNrP21yUB7n4r8X8JZJk7lMKkDnjCSMD1aq2s1OTZkjjOm5A+awNzxxkI2e/s+ng8lUWjBYRi7l6JGsCLE34M5lq+LB/jOdpHtqL06p6/zwG+vPIsIGld8kCE2nvT/jhM+iNNpaq7+Ga0QLw/8y/98vMdq5cmip1X0zK0jofLrLDeuyfAbv3cdY4C+YydjEvK3xa4cxsWFGzC+NKRsdGM9FtAjKWuF1SzOwbQrdgg2T45tIIKTw8IOzaqYfcP/7GBXUA2CMCcPSSvD6WnKkZiFwTdZ3XWbJTgj1XOBZyiWISUREw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by CY4PR12MB1430.namprd12.prod.outlook.com (2603:10b6:903:3e::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:47:50 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:47:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 4/8] mlxsw: reg: Extend MCION register with new slot number field
Date:   Mon, 11 Apr 2022 17:46:53 +0300
Message-Id: <20220411144657.2655752-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0033.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:61::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc924e39-6685-4601-91d0-08da1bca4022
X-MS-TrafficTypeDiagnostic: CY4PR12MB1430:EE_
X-Microsoft-Antispam-PRVS: <CY4PR12MB14303C0B1DF5D9189B578DA4B2EA9@CY4PR12MB1430.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VcWpLRQQpHA1BJiazNEE2EGgm0SyNbyrmgNTbUDPybSgkjUwCvhZzLrtY6zhdmCavmBjOPMq5q05h+lQax5nT/Vrf6lkm1NegihzHZ44TUs11yOFV/s2dZs0y+O3jGsTCIsOU36RMKVxTF1pDVxgNx+KvPU8mN9v8p51X14s70iqK2AtkXfw46/7F5U3LYsvXseNtS5NeqCnVb7lV3gIW48IjufshIOMAmq2g4IryWzxpJWY1dHFMZsIJXL3M0U2Yqe2sMxvZcDwp84ESLlJBT/ZOkfAqEZDbjlQ/Kk8awy0bmRHpPDjUqB60juu84EsZzzUTuHR/ty0mKvn1wOOWJ3bPE3cij/HCosWcXvngYcvykRYtV5bAsQgpiv5DISjZEmXolDPyX2q1H42JWTjea4aqTJSvwItVxArvGq8jlYqYbBdQSpB+c4xLGzTtZIqLdZCaTRgxPkpA32Pn77konzccORQM5yyeiIR/GbyD58HAYQ+aN/Kdrazi5Tef3WakrJGfI0XEvp7tYvNhSBw7wvDTel1JBBTaBp3lSiE6V6Ce2///9lbXiiIRV0uz19YEVotLfXPVor2fnFpr11NqURZS7kzfVIo2R4RT9aJBbNz50RRNsAknECRftcSWNluxGHhGR50FA11g/KbfAxpVA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(5660300002)(8936002)(66946007)(66556008)(6486002)(66476007)(107886003)(6512007)(2616005)(1076003)(186003)(26005)(6506007)(36756003)(38100700002)(2906002)(83380400001)(86362001)(4326008)(8676002)(6916009)(316002)(508600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?k5PkcFYvtMIu51mkJmAfyU8x+JX9irWlXPBK3tFntE46zEavwWvT4MipdviP?=
 =?us-ascii?Q?Mjl3yKseRTXsTPgN+e9uCFi7xBo+fssGjjBYP05KAl5HzpD0b8V/P/I/R6X8?=
 =?us-ascii?Q?14tSGC4jX5ECL1Hv8SfKpUUsyyjVpt3QwUzsl82KBo9jN9WczXpWHPqi8GCG?=
 =?us-ascii?Q?tPw6ZcM+99wgmk2u4jV8meSIt80oDYQVvhMiQtN1NXt1IOkH+7uworv2EtxC?=
 =?us-ascii?Q?9oQssiMM7s5gYnGdEKtaiZx38BEODfN/zidmWVemvTcZxhQu3LTEdEDPZ/nj?=
 =?us-ascii?Q?tuYjkie8JO76wjDH8zQob4VzyqHsWgZ1cHyEyayqITFmR/bI6+ioRz0cHc0j?=
 =?us-ascii?Q?lokpsUmpW6GkZ/os+PPWFEMNB1fxAM9PWgWIBKHH1AnUXAPwwXkbiIDxC1Nz?=
 =?us-ascii?Q?Z8JDUKqE0WV+v0/JXtj7NNhNIwvOay/SuqGP2YFNFzCqHnXDQSQ0MR7mxbz1?=
 =?us-ascii?Q?oussOjJb7vU5cJc2D//d2dCAQ8KRaM09g/KYNgmu1Jyn2PDwbm49DjT2Zpr5?=
 =?us-ascii?Q?nhPPbyuEokNikd47N8vrKKIJMLqmHRW8y5l2c+s/5UNdAzSvrLSd5UkTN+Nk?=
 =?us-ascii?Q?+aw9/GPi32u1H8HSgk5QdaOMivKcvTaMWNugX7QxlK174XFnhdfh1Yzq3NqX?=
 =?us-ascii?Q?mEj/RJGbDxQVrNQRwDdlPFuam/FmZ2wnwGyLUIi+Q1q5FuJyY+TFOdZ7eTA2?=
 =?us-ascii?Q?cxHlOnZe1X/Rv5HS5kjyjbbt5wOPpodBpXBmlaOHszwkqBT7xcvGWEapO0EZ?=
 =?us-ascii?Q?gZhIFSlOZtjyMliCkBh6TaF5cAX3iarg1UHxS9kdRct6xdY1k28hgcKbCw0i?=
 =?us-ascii?Q?uKBZ9YCzadqGMNmyRoMdNxmBKnyy7gQjlAnhq2eAZRPxrsJCGOR9+I8yXego?=
 =?us-ascii?Q?qws1/ylvlYRPLXoww8cJqwk4t4L/uvdX6zB6myMpUsjq1eD9jm49fG5ZpE56?=
 =?us-ascii?Q?HnwxD1t3CxyMsvG/8qT4lPRU0yiNRVsScJTZvTmm7oGkM6jfwUDf+SyykUus?=
 =?us-ascii?Q?xJwLqULoHSaJeWiQBCxCRp4WOpop/FVZzLk0gT4EAWDXgct+jWaN4AiJKqRO?=
 =?us-ascii?Q?BAyHrsKsYA06FyMlw0AOWyl6tcDo6Hfi/3YKXE+VDwLUtk50gAjW0duKu1CY?=
 =?us-ascii?Q?yr6Pidbdb+QpuIcZnmiVC9rx6JAHGEf5yNE0haA7OuAUI7Dr1yzj6IteUoZL?=
 =?us-ascii?Q?ALkho3GcYsrFehIl3gkaCSic/Iepuibtbo0nUhlgQ2NFig0Ver4b5EZYlva4?=
 =?us-ascii?Q?/Ppd8w6iH0VxdGioTYqdnRe+QbxfcbyNJfZfWQsKHgqOlNTegp3Q5aJs1dKe?=
 =?us-ascii?Q?djQInqwrka4GLrFpp9BOSHv0m5yZXVOrYJq9PHahddxm8VJiA5tMnZ4zeP2e?=
 =?us-ascii?Q?BdJm7BCHTbVBgQCgE9byOAK7fOI4w4uwGiwp+fWRXC0huiDvytZSjhtDonWn?=
 =?us-ascii?Q?VLL+kzqhTELwwQI1bOZ4bIS0D+bnoVr/qrXTDM1tw6XJaKNKxGFmL4gsKiJv?=
 =?us-ascii?Q?Pxhuy+NwEKXpTufRpPKtMBYPXZ91pAiRD6rv9yKcCBbRrMIBIlfZNKJAbsUG?=
 =?us-ascii?Q?Q/IVul+Do0SOVKtRU2QiosX+C0H5cv7m/lU93x8yrngrEeJHRR1IGPWXEKUa?=
 =?us-ascii?Q?dnbe2aA95ZXw6JgjSWPKusFC02/rWTFtX8W4P65AIbYmA5u3TkdAPLWViJi3?=
 =?us-ascii?Q?1G6o8gvUlkr13+LV3HRB9jbJ96MGHrOufz9+b/Kj5Pf3/EEfGGcsMFq5BNZC?=
 =?us-ascii?Q?I4GG8X0CUg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc924e39-6685-4601-91d0-08da1bca4022
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:47:50.0479
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qjlh1dz8RJ3Rkd5eZIq+cywwWUAsiZVMQu76ljlO8jdv12lH9mdl4UVNTEUC/0BHFrCX2mXjcToayE/w+azYpQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1430
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

Extend MCION (Management Cable IO and Notifications Register) with new
field specifying the slot number. The purpose of this field is to
support access to MCION register for query cage transceiver on modular
system.

For non-modular systems the 'module' number uniquely identifies the
transceiver location. For modular systems the transceivers are
identified by two indexes:
- 'slot_index', specifying the slot number, where line card is located;
- 'module', specifying cage transceiver within the line card.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/core_env.c | 2 +-
 drivers/net/ethernet/mellanox/mlxsw/reg.h      | 9 ++++++++-
 2 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core_env.c b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
index eff9ced260ea..602f0738deab 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -520,7 +520,7 @@ mlxsw_env_get_module_power_mode(struct mlxsw_core *mlxsw_core, u8 module,
 
 	params->policy = mlxsw_env->module_info[module].power_mode_policy;
 
-	mlxsw_reg_mcion_pack(mcion_pl, module);
+	mlxsw_reg_mcion_pack(mcion_pl, 0, module);
 	err = mlxsw_reg_query(mlxsw_core, MLXSW_REG(mcion), mcion_pl);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "Failed to retrieve module's power mode");
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 57eb6980bf8c..3695f8c7d143 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -10521,6 +10521,12 @@ MLXSW_REG_DEFINE(mcion, MLXSW_REG_MCION_ID, MLXSW_REG_MCION_LEN);
  */
 MLXSW_ITEM32(reg, mcion, module, 0x00, 16, 8);
 
+/* reg_mcion_slot_index
+ * Slot index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, mcion, slot_index, 0x00, 12, 4);
+
 enum {
 	MLXSW_REG_MCION_MODULE_STATUS_BITS_PRESENT_MASK = BIT(0),
 	MLXSW_REG_MCION_MODULE_STATUS_BITS_LOW_POWER_MASK = BIT(8),
@@ -10532,9 +10538,10 @@ enum {
  */
 MLXSW_ITEM32(reg, mcion, module_status_bits, 0x04, 0, 16);
 
-static inline void mlxsw_reg_mcion_pack(char *payload, u8 module)
+static inline void mlxsw_reg_mcion_pack(char *payload, u8 slot_index, u8 module)
 {
 	MLXSW_REG_ZERO(mcion, payload);
+	mlxsw_reg_mcion_slot_index_set(payload, slot_index);
 	mlxsw_reg_mcion_module_set(payload, module);
 }
 
-- 
2.33.1

