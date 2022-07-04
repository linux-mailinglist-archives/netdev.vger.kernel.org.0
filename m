Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 503C1564D96
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbiGDGNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232651AbiGDGNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:13:44 -0400
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2085.outbound.protection.outlook.com [40.107.101.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D32D5FD7
        for <netdev@vger.kernel.org>; Sun,  3 Jul 2022 23:13:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MGRbkxR5ThH1a9ZPoG1yfG1KIKe3h98sY1nZRYjcRYiPzxyJR+TYnpu6cwIUNIgBoMvkMzwh3BYANbfbygINfq33YNRo8tdGE4AqtVFhkFxA7F/5yuKIMU2KH7coYQTmiZcDsYwmO5UXKVplzsXGqTF9d4VNYuzEINdGb/Xq7feUg+3tTPWl4otlWaNt+xi4RQmeXMt5w6t0Ck+RVErH/6fPqMtqBeraLL5eTV02MqoJicntd41vPFWnZC7WNs2ln1WfgQ/qU64Ng2mOmLkOFpH4QRIPPZedujALdofuN22XjY1M3KdS3PBe59zd3TjdFzyZugrpMT2crBpCrVxwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TOwXqJW0n7SsBSlxcvTlq7dEZim05zdhXGXd+9u47bc=;
 b=j2+XRz0vUaA87bp+CUk/vR43Pp7t0GxTeFATrdvuynxfcgPCWrzN/QpMmPEJ/nlVVR/NBG1aoelyllmFHlZukmTBX6wOvtpBrCxJj8bTBK8cqJtpn0+/syrnZOXK9hUxnUTQojDwVEDFxYgFleU5HjBbeuluwdYg8SYqW1ZHgO+sAg6K/rRoNtQSbsmpdW6LHV4hvlpUanOj+D6rHYD2l0wWjRQVquLOs/2CA5LUk4+PQQpj7pvRw5NgUdhcs3iL9AdjVs6w2EDpi5eKdsjsZ12lHsZMY6lLPY5apyMGkKo5idRdFytqOKFl53A9k2kinEUjNGSV5GMM68vwVotgIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TOwXqJW0n7SsBSlxcvTlq7dEZim05zdhXGXd+9u47bc=;
 b=YK/vayR1V/BO6nqT72jlt/Hymut6HUflnvSTkzpACoC/1CvOzG/PeIPlaO5SB+Kpa5VLuI1X+yYnMrPdMaoG5vR5mcZhLNk0MLLzWuGg6pwom0h8icLBeWKZsOsw0OET7zhfw0sa6093fwLiVHlPNiumnxwjH5uT4RGRej0Co7Oudi7riTgQTG2Uk/p6/mYLcri6GVeOM8FgrlNDi9RQWj7hXBHov8fAGWMGhJwX8geM+WqawW6nftXZjNN4EbV204cuq48aCiR7SZvGhzJyrsbgNA33n+ksMg6xaCO0wVdwx9h+1/zri1o3NhQ7xWD41q9F03qGWLvycaMaHfpoBw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by CY4PR12MB1862.namprd12.prod.outlook.com (2603:10b6:903:121::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.19; Mon, 4 Jul
 2022 06:13:41 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%7]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:13:40 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next v2 08/13] mlxsw: Add new FID families for unified bridge model
Date:   Mon,  4 Jul 2022 09:11:34 +0300
Message-Id: <20220704061139.1208770-9-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220704061139.1208770-1-idosch@nvidia.com>
References: <20220704061139.1208770-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0054.eurprd03.prod.outlook.com
 (2603:10a6:803:50::25) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 85ae00d9-db5d-40a0-73c4-08da5d84571d
X-MS-TrafficTypeDiagnostic: CY4PR12MB1862:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 4ywfeBksAJUbk7ByehfKrEgBVxwFmRzX2EhJ8kKBxdQKLJxnf82x8BZOGixmSiLMqS62KaoZzkARKGcueAccXcvBYTmjfvQV4XOr8WrmFTXI3LowLexWjoBv+cEm3xdJ6YE7Y8cTw1xI4fwCRcPb/IR1szsefUPvD8cLWF4h4feNRTknlDvEAxE6D4rYBbeXk8i6PuLgDfsi+/qyTLwMgav6J1Xq3qFlViuijo+VKoE8OhDkPf9kpC8gpKKNT9EPi6elivyUjZ5pwBuDo6JSI/BtmsTDl5bTgak/FETOD11o09tGMALTE1ewK1+6sH+4PN8Pmas4KgIeVrqVidg9RiT+K74seuAFl0EbyCuj2q3+kDaeL4OEuURl6XSKZhXEjajvmApuZGeQUY5+7Oc+kDCgQjGNe3FNl3VyMXEuKKzCrUfZ9ihkz9HDhAgQaNlj5mISY2R4MZAtRF7teidA8/s9x13JYZavsoWUKhuoQZbofWmSrBrcQf59Z5bnaJtWXUYDKCKkOFheDnuxzLkh3Oivrnga5bMIbm/HZoxxHOqUJK7sx+YUCd4gqa/i6L7oW6ALiaslgLquecDuKNFBEkSAB9tWS34rgDE38BK2KWXAgnjWoZPJDO7ENmqnVqYFdJnFM1SzLGOtJF/TW9uXGd3ziwEOe/x3tbGozNapZy8SYtUcFKM7GmpUcvfu8zipDdwmTD8Rqc1/175miZoIfV2GYLjVbRtc8Tf0OcmuyK99HaaIVFfAo/xYGXS/zcykgoGb+A388cmwE2yicnSvsg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(396003)(346002)(2616005)(38100700002)(66946007)(4326008)(8676002)(66476007)(66556008)(478600001)(6486002)(316002)(6916009)(26005)(6512007)(86362001)(41300700001)(6506007)(6666004)(8936002)(83380400001)(36756003)(30864003)(2906002)(5660300002)(1076003)(107886003)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6RPNddd11GJcc+s/SAqXzQW4RE4/3S36LVe4uVU9PA59QvKAqESBJqblbczZ?=
 =?us-ascii?Q?fn90nnDMJRQpYP7YfKnGvm3lqZ293gaoe2+3wC74L8bumXTCTaMAWHSx87Pw?=
 =?us-ascii?Q?EXnJKUYb+LWBFUlZatXpZ345pCXyC+es/wgvTbkbniEKw+P0t7INk2s1xkbS?=
 =?us-ascii?Q?NjY4cuZFpn1shSAv7Ufgv2UGxhdzAuMO60WnacjL6pVTHfZ68kpFg76NEa4S?=
 =?us-ascii?Q?fze9mTtfZ4J2RQdVIognfzl9OoCyuDC1Ki7sO3f6F7jv3GyLJW29CqmRrNfu?=
 =?us-ascii?Q?t4GTpvCBIoW0ntqnr/nNoyJwwd+gGbVI85QanGw1PnDr7m0i7jqXytUscgo5?=
 =?us-ascii?Q?M5bjEPP06YomWX/2QXhUAJyC4Ow30mozup/mWIsi0aTuUukBodWz6soe2NSN?=
 =?us-ascii?Q?bPRQ13Yam06papGqD2hEqdzreHGmNktSDd2S9IkraVzE+6BZ9Qzp4qP4FG41?=
 =?us-ascii?Q?hHlqE4n/1ykOUT8s42mvoHnlitNm0Lq4SVDXGac4Wyfkxx11BLhl5OfRWFF7?=
 =?us-ascii?Q?HKKSgZhaTdI2jItaIznbFwqv4LAI7KznqkdaGMbudMkIsmCo8PeYikAdcQv2?=
 =?us-ascii?Q?GZs6Fb6kMNnj8aXee8sFsTVcKr6AP/j0ByrZ9rXs6F+mTvp5ZMoZcCu8jfrV?=
 =?us-ascii?Q?fEyg+YNmFXYdzZBhHzHxIA62pf02MmVagUkHluKNFlf1G6r9MO24aWMB7yUo?=
 =?us-ascii?Q?uuExJg1mrlKVlf7NX/c6MVv1KHQmDHsC8druoGODIEOmzXbSnrV6W3nU0twM?=
 =?us-ascii?Q?eHqZC1i/M9MhZW/RFqRAskwpVxUAZzFyzkdeE5ftDV+ZmOGA2/SyoGYsPqxJ?=
 =?us-ascii?Q?pwXBo8/voHSUEHv9ky4RFDQNUA209WhffXrEK/x7l6x14T5Rq/C1mWVFduWL?=
 =?us-ascii?Q?pSOzAQtZd/m7+LXWP6ypFfPFa4z3TYjx+b+UiePSh54P0qsyxMw91qwIrOgy?=
 =?us-ascii?Q?p9Ify+D+1c22h/i7yHrJYqXgeGk34wDF17NaOSIHy2oSwUkO2jV9khnghmtU?=
 =?us-ascii?Q?sKm/fWqD8BWIU8zadNZE9xsYe8sWnLSum75O8yc16Pyb9AblEkOGNW9dKT8t?=
 =?us-ascii?Q?Exfxvsqq9G2GNgNTI+YLbwLArehm0shHQWP6d49/ggWzJU4AsQ8kIVfRq2R8?=
 =?us-ascii?Q?msaxeIhNyZhiFIDgvZaGDZG0V9J1xfjXAUsKxEmdJdNIAyIV1VAUhZKcA0my?=
 =?us-ascii?Q?gXoA8+ZwdI0w60GUt/s+WTP/DDVvm7uS+Rk3fEhgoU2Efc7mOLMorOlh7/SU?=
 =?us-ascii?Q?XG/9rluOXD7eRJZsYX0EU5gLtxEJOMZyP82y1K+me+KrOKJytpy41tDw5A4G?=
 =?us-ascii?Q?AgethxsaEBRDteoHVw5XTGOuV08yXBM6/m9PyqDv56/pcaZUKVD1/AEbwdN1?=
 =?us-ascii?Q?j/z/aznn/Q2fWOaY1kAc1BSeF+kNI/jPrMQyXDb9D3ICkNp8qPnv+gT1Bqgs?=
 =?us-ascii?Q?Y28lGBJYPIgXU8VsUn+e3f73904e9beAEcTvSj9vPOMwJLP060YmbR17+/un?=
 =?us-ascii?Q?p6yMIGImV8NAkHNeVnoJ6XN5dNuutp/SHkQfXhTaIAcM4JldDp5xSrRZ/AvL?=
 =?us-ascii?Q?TMgxv7ANzmRpaSb+LOMjTgXRg9FdlTXygRJIFtdR?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 85ae00d9-db5d-40a0-73c4-08da5d84571d
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jul 2022 06:13:40.8409
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KTgYLfIDoiSRdUDUuOOQK6dWwLxjVbru3fkNwO7MXrnqYVxYSatRyls0auSxzCTay+q9+NBcH2eT5fwd/RNlsw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR12MB1862
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

In the unified bridge model, mlxsw will no longer emulate 802.1Q FIDs
using 802.1D FIDs. The new FID table will look as follows:

     +---------------+
     | 802.1q FIDs   | 4K entries
     | [1..4094]     |
     +---------------+
     | 802.1d FIDs   | 1K entries
     | [4095..5118]  |
     +---------------+
     | Dummy FIDs    | 1 entry
     | [5119..5119]  |
     +---------------+
     | rFIDs         | 11K entries
     | [5120..16383] |
     +---------------+

In order to make the change easier to review, four new temporary FID
families will be added (e.g., MLXSW_SP_FID_TYPE_8021D_UB) and will not
be registered with the FID core until mlxsw is flipped to use the unified
bridge model.

Add .1d, rfid and dummy FID families for unified bridge, the next patch
will add .1q family separately as it requires more changes.

The following changes are required:
1. Add 'smpe_index_valid' field to 'struct mlxsw_sp_fid_family' and set
   SFMR.smpe accordingly. SMPE index is reserved for rFIDs, as their
   flooding is handled by firmware, and always reserved in Spectrum-1,
   as it is configured as part of PGT table.

2. Add 'ubridge' field to 'struct mlxsw_sp_fid_family'. This field will
   be removed later, use it in mlxsw_sp_fid_family_{register,unregister}()
   to skip the registration / unregistration of the new families when the
   legacy model is used.

3. Indexes - the start and end indexes of each FID family will need to be
   changed according to the above diagram.

4. Add flood tables for unified bridge model, use 'fid_offset' as table
   type, as in the new model the access to flood tables will be using
   'fid_offset' calculation.

5. FID family operation changes:
   a. rFID supposed to be created using SFMR, as it is not created by
      firmware using unified bridge model.
   b. port_vid_map() should perform SVFA for rFID, as the mapping is not
      created by firmware using unified bridge model.
   c. flood_index() is not aligned to the new model, as this function will
      be removed later.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlxsw/reg.h     |   5 +-
 .../net/ethernet/mellanox/mlxsw/spectrum.h    |   4 +
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 187 +++++++++++++++++-
 3 files changed, 189 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/reg.h b/drivers/net/ethernet/mellanox/mlxsw/reg.h
index 520b990054eb..17ce28e65464 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/reg.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/reg.h
@@ -1969,7 +1969,8 @@ MLXSW_ITEM32(reg, sfmr, smpe, 0x28, 0, 16);
 static inline void mlxsw_reg_sfmr_pack(char *payload,
 				       enum mlxsw_reg_sfmr_op op, u16 fid,
 				       u16 fid_offset, bool flood_rsp,
-				       enum mlxsw_reg_bridge_type bridge_type)
+				       enum mlxsw_reg_bridge_type bridge_type,
+				       bool smpe_valid, u16 smpe)
 {
 	MLXSW_REG_ZERO(sfmr, payload);
 	mlxsw_reg_sfmr_op_set(payload, op);
@@ -1979,6 +1980,8 @@ static inline void mlxsw_reg_sfmr_pack(char *payload,
 	mlxsw_reg_sfmr_vv_set(payload, false);
 	mlxsw_reg_sfmr_flood_rsp_set(payload, flood_rsp);
 	mlxsw_reg_sfmr_flood_bridge_type_set(payload, bridge_type);
+	mlxsw_reg_sfmr_smpe_valid_set(payload, smpe_valid);
+	mlxsw_reg_sfmr_smpe_set(payload, smpe);
 }
 
 /* SPVMLR - Switch Port VLAN MAC Learning Register
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index c67bc562b13e..701aea8f3872 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -106,6 +106,10 @@ enum mlxsw_sp_fid_type {
 	MLXSW_SP_FID_TYPE_8021D,
 	MLXSW_SP_FID_TYPE_RFID,
 	MLXSW_SP_FID_TYPE_DUMMY,
+	MLXSW_SP_FID_TYPE_8021Q_UB,
+	MLXSW_SP_FID_TYPE_8021D_UB,
+	MLXSW_SP_FID_TYPE_RFID_UB,
+	MLXSW_SP_FID_TYPE_DUMMY_UB,
 	MLXSW_SP_FID_TYPE_MAX,
 };
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index c6397f81c2d7..9dca74bbabb4 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -111,6 +111,8 @@ struct mlxsw_sp_fid_family {
 	bool flood_rsp;
 	enum mlxsw_reg_bridge_type bridge_type;
 	u16 pgt_base;
+	bool smpe_index_valid;
+	bool ubridge;
 };
 
 static const int mlxsw_sp_sfgc_uc_packet_types[MLXSW_REG_SFGC_TYPE_MAX] = {
@@ -448,15 +450,20 @@ static int mlxsw_sp_fid_op(const struct mlxsw_sp_fid *fid, bool valid)
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
+	bool smpe_valid = false;
 	bool flood_rsp = false;
+	u16 smpe = 0;
 
 	if (mlxsw_sp->ubridge) {
 		flood_rsp = fid->fid_family->flood_rsp;
 		bridge_type = fid->fid_family->bridge_type;
+		smpe_valid = fid->fid_family->smpe_index_valid;
+		smpe = smpe_valid ? fid->fid_index : 0;
 	}
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, mlxsw_sp_sfmr_op(valid), fid->fid_index,
-			    fid->fid_offset, flood_rsp, bridge_type);
+			    fid->fid_offset, flood_rsp, bridge_type, smpe_valid,
+			    smpe);
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(sfmr), sfmr_pl);
 }
 
@@ -466,16 +473,20 @@ static int mlxsw_sp_fid_edit_op(const struct mlxsw_sp_fid *fid,
 	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	enum mlxsw_reg_bridge_type bridge_type = 0;
 	char sfmr_pl[MLXSW_REG_SFMR_LEN];
+	bool smpe_valid = false;
 	bool flood_rsp = false;
+	u16 smpe = 0;
 
 	if (mlxsw_sp->ubridge) {
 		flood_rsp = fid->fid_family->flood_rsp;
 		bridge_type = fid->fid_family->bridge_type;
+		smpe_valid = fid->fid_family->smpe_index_valid;
+		smpe = smpe_valid ? fid->fid_index : 0;
 	}
 
 	mlxsw_reg_sfmr_pack(sfmr_pl, MLXSW_REG_SFMR_OP_CREATE_FID,
 			    fid->fid_index, fid->fid_offset, flood_rsp,
-			    bridge_type);
+			    bridge_type, smpe_valid, smpe);
 	mlxsw_reg_sfmr_vv_set(sfmr_pl, fid->vni_valid);
 	mlxsw_reg_sfmr_vni_set(sfmr_pl, be32_to_cpu(fid->vni));
 	mlxsw_reg_sfmr_vtfp_set(sfmr_pl, fid->nve_flood_index_valid);
@@ -772,10 +783,15 @@ mlxsw_sp_fid_8021d_fid(const struct mlxsw_sp_fid *fid)
 
 static void mlxsw_sp_fid_8021d_setup(struct mlxsw_sp_fid *fid, const void *arg)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
 	int br_ifindex = *(int *) arg;
 
 	mlxsw_sp_fid_8021d_fid(fid)->br_ifindex = br_ifindex;
-	fid->fid_offset = 0;
+
+	if (mlxsw_sp->ubridge)
+		fid->fid_offset = fid->fid_index - fid->fid_family->start_index;
+	else
+		fid->fid_offset = 0;
 }
 
 static int mlxsw_sp_fid_8021d_configure(struct mlxsw_sp_fid *fid)
@@ -1079,6 +1095,7 @@ static const struct mlxsw_sp_fid_ops mlxsw_sp_fid_8021d_ops = {
 };
 
 #define MLXSW_SP_FID_8021Q_MAX (VLAN_N_VID - 2)
+#define MLXSW_SP_FID_RFID_UB_MAX (11 * 1024)
 #define MLXSW_SP_FID_8021Q_PGT_BASE 0
 #define MLXSW_SP_FID_8021D_PGT_BASE (3 * MLXSW_SP_FID_8021Q_MAX)
 
@@ -1100,6 +1117,24 @@ static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_flood_tables[] = {
 	},
 };
 
+static const struct mlxsw_sp_flood_table mlxsw_sp_fid_8021d_ub_flood_tables[] = {
+	{
+		.packet_type	= MLXSW_SP_FLOOD_TYPE_UC,
+		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
+		.table_index	= 0,
+	},
+	{
+		.packet_type	= MLXSW_SP_FLOOD_TYPE_MC,
+		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
+		.table_index	= 1,
+	},
+	{
+		.packet_type	= MLXSW_SP_FLOOD_TYPE_BC,
+		.table_type	= MLXSW_REG_SFGC_TABLE_TYPE_FID_OFFSET,
+		.table_index	= 2,
+	},
+};
+
 /* Range and flood configuration must match mlxsw_config_profile */
 static const struct mlxsw_sp_fid_family mlxsw_sp_fid_8021d_family = {
 	.type			= MLXSW_SP_FID_TYPE_8021D,
@@ -1171,12 +1206,23 @@ static void mlxsw_sp_fid_rfid_setup(struct mlxsw_sp_fid *fid, const void *arg)
 
 static int mlxsw_sp_fid_rfid_configure(struct mlxsw_sp_fid *fid)
 {
-	/* rFIDs are allocated by the device during init */
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+
+	/* rFIDs are allocated by the device during init using legacy
+	 * bridge model.
+	 */
+	if (mlxsw_sp->ubridge)
+		return mlxsw_sp_fid_op(fid, true);
+
 	return 0;
 }
 
 static void mlxsw_sp_fid_rfid_deconfigure(struct mlxsw_sp_fid *fid)
 {
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+
+	if (mlxsw_sp->ubridge)
+		mlxsw_sp_fid_op(fid, false);
 }
 
 static int mlxsw_sp_fid_rfid_index_alloc(struct mlxsw_sp_fid *fid,
@@ -1210,9 +1256,27 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 	if (err)
 		return err;
 
-	/* We only need to transition the port to virtual mode since
-	 * {Port, VID} => FID is done by the firmware upon RIF creation.
+	/* Using legacy bridge model, we only need to transition the port to
+	 * virtual mode since {Port, VID} => FID is done by the firmware upon
+	 * RIF creation. Using unified bridge model, we need to map
+	 * {Port, VID} => FID and map egress VID.
 	 */
+	if (mlxsw_sp->ubridge) {
+		err = __mlxsw_sp_fid_port_vid_map(fid,
+						  mlxsw_sp_port->local_port,
+						  vid, true);
+		if (err)
+			goto err_port_vid_map;
+
+		if (fid->rif) {
+			err = mlxsw_sp_fid_erif_eport_to_vid_map_one(fid,
+								     local_port,
+								     vid, true);
+			if (err)
+				goto err_erif_eport_to_vid_map_one;
+		}
+	}
+
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port]++ == 0) {
 		err = mlxsw_sp_port_vp_mode_trans(mlxsw_sp_port);
 		if (err)
@@ -1223,6 +1287,14 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 
 err_port_vp_mode_trans:
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+	if (mlxsw_sp->ubridge && fid->rif)
+		mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port, vid,
+						       false);
+err_erif_eport_to_vid_map_one:
+	if (mlxsw_sp->ubridge)
+		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
+					    false);
+err_port_vid_map:
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	return err;
 }
@@ -1237,6 +1309,15 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 1)
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+
+	if (mlxsw_sp->ubridge) {
+		if (fid->rif)
+			mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port,
+							       vid, false);
+		__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid,
+					    false);
+	}
+
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 }
 
@@ -1356,11 +1437,95 @@ static const struct mlxsw_sp_fid_family mlxsw_sp_fid_dummy_family = {
 	.ops			= &mlxsw_sp_fid_dummy_ops,
 };
 
+/* There are 4K-2 802.1Q FIDs */
+#define MLXSW_SP_FID_8021Q_UB_START	1 /* FID 0 is reserved. */
+#define MLXSW_SP_FID_8021Q_UB_END	(MLXSW_SP_FID_8021Q_UB_START + \
+					 MLXSW_SP_FID_8021Q_MAX - 1)
+
+/* There are 1K 802.1D FIDs */
+#define MLXSW_SP_FID_8021D_UB_START	(MLXSW_SP_FID_8021Q_UB_END + 1)
+#define MLXSW_SP_FID_8021D_UB_END	(MLXSW_SP_FID_8021D_UB_START + \
+					 MLXSW_SP_FID_8021D_MAX - 1)
+
+/* There is one dummy FID */
+#define MLXSW_SP_FID_DUMMY_UB		(MLXSW_SP_FID_8021D_UB_END + 1)
+
+/* There are 11K rFIDs */
+#define MLXSW_SP_RFID_UB_START		(MLXSW_SP_FID_DUMMY_UB + 1)
+#define MLXSW_SP_RFID_UB_END		(MLXSW_SP_RFID_UB_START + \
+					 MLXSW_SP_FID_RFID_UB_MAX - 1)
+
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_8021d_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
+	.start_index		= MLXSW_SP_FID_8021D_UB_START,
+	.end_index		= MLXSW_SP_FID_8021D_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
+	.ops			= &mlxsw_sp_fid_8021d_ops,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
+	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp1_fid_dummy_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_DUMMY_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid),
+	.start_index		= MLXSW_SP_FID_DUMMY_UB,
+	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.ops			= &mlxsw_sp_fid_dummy_ops,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp_fid_rfid_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_RFID_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid),
+	.start_index		= MLXSW_SP_RFID_UB_START,
+	.end_index		= MLXSW_SP_RFID_UB_END,
+	.rif_type		= MLXSW_SP_RIF_TYPE_SUBPORT,
+	.ops			= &mlxsw_sp_fid_rfid_ops,
+	.flood_rsp              = true,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
+};
+
 const struct mlxsw_sp_fid_family *mlxsw_sp1_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_8021Q]	= &mlxsw_sp_fid_8021q_emu_family,
 	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
+
+	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp1_fid_8021d_ub_family,
+	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp1_fid_dummy_ub_family,
+	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_8021d_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_8021D_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid_8021d),
+	.start_index		= MLXSW_SP_FID_8021D_UB_START,
+	.end_index		= MLXSW_SP_FID_8021D_UB_END,
+	.flood_tables		= mlxsw_sp_fid_8021d_ub_flood_tables,
+	.nr_flood_tables	= ARRAY_SIZE(mlxsw_sp_fid_8021d_ub_flood_tables),
+	.rif_type		= MLXSW_SP_RIF_TYPE_FID,
+	.ops			= &mlxsw_sp_fid_8021d_ops,
+	.bridge_type            = MLXSW_REG_BRIDGE_TYPE_1,
+	.pgt_base		= MLXSW_SP_FID_8021D_PGT_BASE,
+	.smpe_index_valid       = true,
+	.ubridge		= true,
+};
+
+static const struct mlxsw_sp_fid_family mlxsw_sp2_fid_dummy_ub_family = {
+	.type			= MLXSW_SP_FID_TYPE_DUMMY_UB,
+	.fid_size		= sizeof(struct mlxsw_sp_fid),
+	.start_index		= MLXSW_SP_FID_DUMMY_UB,
+	.end_index		= MLXSW_SP_FID_DUMMY_UB,
+	.ops			= &mlxsw_sp_fid_dummy_ops,
+	.smpe_index_valid       = false,
+	.ubridge		= true,
 };
 
 const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
@@ -1368,6 +1533,10 @@ const struct mlxsw_sp_fid_family *mlxsw_sp2_fid_family_arr[] = {
 	[MLXSW_SP_FID_TYPE_8021D]	= &mlxsw_sp_fid_8021d_family,
 	[MLXSW_SP_FID_TYPE_RFID]	= &mlxsw_sp_fid_rfid_family,
 	[MLXSW_SP_FID_TYPE_DUMMY]	= &mlxsw_sp_fid_dummy_family,
+
+	[MLXSW_SP_FID_TYPE_8021D_UB]	= &mlxsw_sp2_fid_8021d_ub_family,
+	[MLXSW_SP_FID_TYPE_DUMMY_UB]	= &mlxsw_sp2_fid_dummy_ub_family,
+	[MLXSW_SP_FID_TYPE_RFID_UB]	= &mlxsw_sp_fid_rfid_ub_family,
 };
 
 static struct mlxsw_sp_fid *mlxsw_sp_fid_lookup(struct mlxsw_sp *mlxsw_sp,
@@ -1676,6 +1845,9 @@ int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp)
 	}
 
 	for (i = 0; i < MLXSW_SP_FID_TYPE_MAX; i++) {
+		if (mlxsw_sp->ubridge != mlxsw_sp->fid_family_arr[i]->ubridge)
+			continue;
+
 		err = mlxsw_sp_fid_family_register(mlxsw_sp,
 						   mlxsw_sp->fid_family_arr[i]);
 
@@ -1690,6 +1862,9 @@ int mlxsw_sp_fids_init(struct mlxsw_sp *mlxsw_sp)
 		struct mlxsw_sp_fid_family *fid_family;
 
 		fid_family = fid_core->fid_family_arr[i];
+		if (mlxsw_sp->ubridge != fid_family->ubridge)
+			continue;
+
 		mlxsw_sp_fid_family_unregister(mlxsw_sp, fid_family);
 	}
 	kfree(fid_core->port_fid_mappings);
-- 
2.36.1

