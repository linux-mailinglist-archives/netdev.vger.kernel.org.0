Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6045C4FBF86
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 16:48:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347467AbiDKOuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 10:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236322AbiDKOuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 10:50:16 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2041.outbound.protection.outlook.com [40.107.93.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480C9220FB
        for <netdev@vger.kernel.org>; Mon, 11 Apr 2022 07:47:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nAx9ILg39+d3i1EwrSTm6jWDLew+vTyggQFZnBdHFCH/T0j4KIJNlfwPj+Bbvut6oSw2kIy3k0w6dk9AkVJwdIAmeuYwkEXoTO0oKoee3I/eOnVDTmBAHY9BTbNOHS1jhOOdkX+xnFQD5qXi/HsdsncwyJ2SYeyMdbeFhom4uaKc7aJfcAy7sGHdO+VHCt1pX07jeIC2OvD8pHbqI1exmEXD+tc8aVE/4ebA1QJXuuQeptl/zZBtOfA/JBAW+iXKkKdMWo2QNeN1STBdJbOL5yP4TFZaYbQZ0LqO4EoeUF1BcztrjswMH4IdjjqZ1CEdKafanxNNpl6eTDekvjaQFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z50KUPdZj8dKXFDe45c8yVVeBI30TWn0af3vIPAsVF4=;
 b=mYREAr+Ix0iKifkrJLMZMAZORorRBWlc1cMzIoNgW+IEPXiZHBhpUNgrvC5Hq7mxWp7yjsn1pUZ/HqJOqzWp/ElqPAcntCIZnClAqzURjj/H1Gqd8zWlDab7U+5Tpe3MB9DtfCIzl/skZASalxpmD4TuSYXXbcFXmKdR5HMrc842S/YzKrINC4tIjKNZM6aEl71o8DceXT0R5qSS9/EDcdF4bUm/r49t4mlz7/FuoONEZN1FgDKVBbTbGnEaJwwGfT41dHWRzXP7R4J/jZ6Ch3+efOWqs/C3KSUnPTEzrahMqMWs+wp7uzbL70VN/2P7U/CXTCZvZhqBH+fr8bgmVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z50KUPdZj8dKXFDe45c8yVVeBI30TWn0af3vIPAsVF4=;
 b=rrBU2IHd/0YFhiaX/DChJON5ydXXqTpRcmVPdWTVlSWg2edwgw9ZC2XjpYRT1s/zr017cOj5H8aMRs7wlp3pF1NTyBST7PZeNL27NUB7LwJXo/n9lBUHr3tbTDNatNnDQCa86DAktvDPqETo1966xW0iyWb/k5H2Od36PFsShiROjtlgA7o88h4LdDTjDX9LtvlC2QsmBkucnCgfT0nB2RQqnepcZ44YeGSLveCajocTIvpoPpORV6NQuvXFct9BuHzWf2f4vJF7z/kpPtlHWhPT9rRhaFj8Ah+FEKaCObk7jgCV/ArBEy3s1h936zyKI8rNE4VuOz6ndmT3ZpV+Og==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by PH0PR12MB5484.namprd12.prod.outlook.com (2603:10b6:510:eb::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 14:47:55 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::6131:18cc:19ae:2402%5]) with mapi id 15.20.5144.029; Mon, 11 Apr 2022
 14:47:55 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        petrm@nvidia.com, jiri@nvidia.com, vadimp@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 5/8] mlxsw: reg: Extend PMMP register with new slot number field
Date:   Mon, 11 Apr 2022 17:46:54 +0300
Message-Id: <20220411144657.2655752-6-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220411144657.2655752-1-idosch@nvidia.com>
References: <20220411144657.2655752-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO2P265CA0081.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:8::21) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1ec03cea-3449-4023-50b2-08da1bca437c
X-MS-TrafficTypeDiagnostic: PH0PR12MB5484:EE_
X-Microsoft-Antispam-PRVS: <PH0PR12MB54845D92F61A3626E5518CE2B2EA9@PH0PR12MB5484.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z7inXGJo+FIz4Hoq5YItmkNGRleNvkhqItd9/CXJUTkWNM5CY4HgKn2l/VxDeZXW2JPUef/3z6PZmPuwPbKaErimWNgIDRIicRbUiHiFZZ0Fx05slhOOsxeHln+8zJmH+xXbJ30/aD1rzdkyq86tFx/YG9R6UnZ4L3oPwnD+s28OQq2MUjdfEfi7MlVBX6LtaNE6M2zExf+berPAPw78M0my6UeUUazztlu6h6aTMbuWTj6wDvZNlKYSBpqO8ZUWx37dRe0Ymbtex+g0MoeQ3CQFU94iL9ihoYTQS0VZTfleE6r2+99o3Ce711G1XUf2EMGb2YCWYAAO0m967b8JPkB8WA7Gw8I24TMkPYTOXzDj4YCH0S3dX9YFM2DYnToTK2GOQNjJiMxJFzebGtvTjxQoFFIW0hYd2d4MxZnbDsWVdMT/TI0JPFdu8AoBEuYfm+xbW7c9WjMlybnmmA9xlu3/XiqMj6NGKFl0JsP0RSwMetYJVxH1v2Xzzf/8I3Fvju3qu1x9W1IdhW4YAa22y8C+rs4y4dKj0HBpTpfHGwwkDd0sFHjs3XLoJy+TJxo/A3A2T4HrLJx+ARlXt8WLHef9Myi6Rhovbg/0cgTOiz8r3OhGjqdSlIYVKX86sNNzyoYFWmCBFo5PsCYV3bqr5A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(2616005)(186003)(6486002)(6916009)(107886003)(36756003)(83380400001)(4326008)(8676002)(66946007)(66556008)(8936002)(38100700002)(86362001)(66476007)(6512007)(5660300002)(316002)(1076003)(6506007)(26005)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?JcSPWkB1U2q22WTZHZGRqODjVqc8CXRnNqJVRrGqBciz6HJDKq29s60y84xu?=
 =?us-ascii?Q?XfEdMuwqwGelZBBjncVAnzjaBxL+UHhlcbam/AE6pi7qUsOS2xvAcsv6jXr6?=
 =?us-ascii?Q?A5kmhGslueaVZa2/hy2Kz8XZYZzsKX08fdfyhjhwnSzhuiNRaGyB2QigcxhB?=
 =?us-ascii?Q?pK/k1bWdupu/tedzZvdyj1eR1FOVhcjUJel61UaoLVPmo9Q2EBrLihip5UV2?=
 =?us-ascii?Q?wsTw9q9prmm4HlSYbOShyQHuvMxNgWe+Ke0mfzZxFL2EOHZ1fk7ilDBbSBYa?=
 =?us-ascii?Q?EsR44nNBBuQ18yJY3o2dESytQd453TenO9FireH5VbbTPy67LTja7qtKkVtJ?=
 =?us-ascii?Q?N2f/rtNEdoeevKSDUweBSYdSEh48y8DnIwMW+rznnxlKVGR2j1Lzr1AwgL/H?=
 =?us-ascii?Q?OLG3X/aGRYD2yrFlYEOFs/nF8ygNUKhEtSIlMSech1dCL/ZuZZbiEfmrrzCd?=
 =?us-ascii?Q?HjuZFviXAV1TT3g1GQUfofcvaqJC69fhHHQF5hCgwbkxQXuJwMTeemzgXQyg?=
 =?us-ascii?Q?cRqLV9jK4MwHJ3muXR65lI/mx7V2Dc7fUN7wW4lQJdNsoMXUzDJ/gqc4DqbC?=
 =?us-ascii?Q?JcBZP3ksOgOXpciHWiRIpKVx6TSfPTg7kRYzGFrfFplU4VAi3KqnlI55Qsd3?=
 =?us-ascii?Q?ykcMsFiNl0c2Fo2oZonJo3LbMByzbj1JUhd0a1hDBce0kDqhq2Xba13eY/6s?=
 =?us-ascii?Q?0Fms8LaVvFkOBH9catpi0ePslcaYoeCY7HEIf/aEYTLoYx4ffcQZ2QB8+k7t?=
 =?us-ascii?Q?O3sA+u4Id+K2LIbtz3WpS8hXZV8qkvWrInI/2Qya8ERf1/mNM4//sCZTB5Q0?=
 =?us-ascii?Q?b43CEn/jOjvIS2zafq/z5I5zOMxSL3re7YpSNG31SefhHwpiOtg9pyDVNq53?=
 =?us-ascii?Q?jMW1DXZqKoo+Z6zPhdGqQU6t4i9nz4xQcTcGR0STcnD3cFeA16ubHPrXSQWe?=
 =?us-ascii?Q?dXLSyufwoUvCY4BLfU1GWghRr9yV1tG3Sak4viy5rUagA9n+CpAn59rBGVhk?=
 =?us-ascii?Q?rUCJtCjWxz04GyQl43OBBOCJMVuQDBI1WA3/7Ahhdy1QRFdfLUbPdvKMl31h?=
 =?us-ascii?Q?spfR2MKsstoPRkYC/XxLKTWnUu2xerecVCXJbklEe7dv4j8CGmeYyAHszYQ5?=
 =?us-ascii?Q?jh2/fZ7YOOdzfA5vjBhYfAEAHlNcfczU6XSohaj4X6u9GqQ22HgzcNmFA/Ra?=
 =?us-ascii?Q?D6IJRAijMZUbXgkl/FSRe/PXK5al3JccpVXv+5SHZcvRzFImxwhOFbSrt+pH?=
 =?us-ascii?Q?4ECGd/z0fWfQ0hZfRD7zSpb3r97+lbrohxYc8rsleKxklOjKTfYKHC22lvqc?=
 =?us-ascii?Q?O9NFZzQgAIcm+ukTioqCXc7Ixq6RL9GaK9jGq4HTaJ1h17PSLBPNAH9Z7GCs?=
 =?us-ascii?Q?jUxx7yjD9DS/cK5uYkrNvatx0GEj1s0+Vtkpjc0mvb4B/DMKcCmLCSNRqlrM?=
 =?us-ascii?Q?jUzB+2o3R7a2gNkbrRWtmsQvljH1r1q9QRszcy7h94YRcM61uGcwG2TYWpMa?=
 =?us-ascii?Q?ggy037NW5dfHa7edRsLNMLaJ07W7A/zvG2zGeFLSEFd1eFIRk8++cjL+oxQW?=
 =?us-ascii?Q?ELpJLWdX5Y4/qrLqmpUFXw5/Rog2xJzXGbn8VDlNwhJnNBsRDJ1bPeqGImqj?=
 =?us-ascii?Q?euUTU9CIsIizQjvbS/BrqgDztpT6faAbsonUfmpLrwAhJkIeo+xGiGDJkuBo?=
 =?us-ascii?Q?cuphI6L5/atHyRJgl8Dj39LnW4UjDQWOSBD3E63dAEi++fMqzreotoBpdb07?=
 =?us-ascii?Q?B+SZDVNnFg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1ec03cea-3449-4023-50b2-08da1bca437c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 14:47:55.6691
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: lkK94vRzQ7XdvxE51hUk1/pk1yLGjFXx6xeaSAz5c83ASGq96VGaXZQSqk4VYC5G3EhjDqMaxI3J0KMHF4FZmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB5484
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

Extend PMMP (Port Module Memory Map Properties Register) with new
field specifying the slot number. The purpose of this field is to
enable overriding the cable/module memory map advertisement.

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
index 602f0738deab..8cee3e317a5b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core_env.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core_env.c
@@ -563,7 +563,7 @@ static int mlxsw_env_module_low_power_set(struct mlxsw_core *mlxsw_core,
 	u16 eeprom_override_mask, eeprom_override;
 	char pmmp_pl[MLXSW_REG_PMMP_LEN];
 
-	mlxsw_reg_pmmp_pack(pmmp_pl, module);
+	mlxsw_reg_pmmp_pack(pmmp_pl, 0, module);
 	mlxsw_reg_pmmp_sticky_set(pmmp_pl, true);
 	/* Mask all the bits except low power mode. */
 	eeprom_override_mask = ~MLXSW_REG_PMMP_EEPROM_OVERRIDE_LOW_POWER_MASK;
diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 3695f8c7d143..5bf8ad32cb8e 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -5984,6 +5984,12 @@ MLXSW_REG_DEFINE(pmmp, MLXSW_REG_PMMP_ID, MLXSW_REG_PMMP_LEN);
  */
 MLXSW_ITEM32(reg, pmmp, module, 0x00, 16, 8);
 
+/* reg_pmmp_slot_index
+ * Slot index.
+ * Access: Index
+ */
+MLXSW_ITEM32(reg, pmmp, slot_index, 0x00, 24, 4);
+
 /* reg_pmmp_sticky
  * When set, will keep eeprom_override values after plug-out event.
  * Access: OP
@@ -6011,9 +6017,10 @@ enum {
  */
 MLXSW_ITEM32(reg, pmmp, eeprom_override, 0x04, 0, 16);
 
-static inline void mlxsw_reg_pmmp_pack(char *payload, u8 module)
+static inline void mlxsw_reg_pmmp_pack(char *payload, u8 slot_index, u8 module)
 {
 	MLXSW_REG_ZERO(pmmp, payload);
+	mlxsw_reg_pmmp_slot_index_set(payload, slot_index);
 	mlxsw_reg_pmmp_module_set(payload, module);
 }
 
-- 
2.33.1

