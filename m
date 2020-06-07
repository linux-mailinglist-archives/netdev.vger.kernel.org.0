Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 695EE1F0C40
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 17:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbgFGPAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 11:00:50 -0400
Received: from mail-am6eur05on2089.outbound.protection.outlook.com ([40.107.22.89]:48904
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726788AbgFGPAp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 7 Jun 2020 11:00:45 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bfKZtA07VFF8U4lvCs/lSxpqT9QU9INkeAsnGkIzWLQRQTU/5ORYA3JD2HUUpJhclktrgTKR9f6OFM6FKPyjPIFEDkgkDGnOZO3qAIuedsi8qyuiyRQCSqRExNdfWL8ADTfUXWzGnnbbh1kn2zR25VgbBQ8AZo2Q+RNAMOxGif+SUntuTFoNpXPBYKCZMe2KFwSxThGzJk0uDKxJhfLyIHTsv7voMyxJnZOyZHY/md8x1QJwMBeeugQUtzhteQqNHh9M2IETzgy9vGSusW9xGMNaHTAkz3po/BIGkgF71drVczMxE28oHr+BG+miw3YykkCWisIcZHyx8V7aluIMqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2UMiDVDdko7IYOLowdGl/kRXNyTFr+69nQTr/lNXrs=;
 b=VlD0sdg19iw/PlVxwr2K/UXtUqBLVuvaHuRvDFSBH2gpQOW3EC78uyzuJW9KeZoRG54ndtrmyjlRyxNfVr6RA/ZrshFy/skJaVSjOLFmh0wWkuIJ7hmfLlnZMFz0Vuktj+xV/AnuaasCMlCvhOTzMhumgLrRmsXCFONPxlq7x/iZvIHFBUnEZ6tiAtdOv1zmjoNaVt4f9/lhBd4av0XR7liqp95KB1KwCqJg2CBAUsfoLZ4JxDJu1KqhNTiYKyi5O68lp1xJqAjTtZTi9wJwg6wmEyPccjHCVhCl0/DmlgQzifEubGSg1avwmsO34cpHb016wontN4TywYuIRm3J/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2UMiDVDdko7IYOLowdGl/kRXNyTFr+69nQTr/lNXrs=;
 b=sm/MLYcowNdmFaPwJuILAHiiiiMWDgxs9mVtzFmpL1z0NjYZ19vuDtwhZX6yS+urqBsttAcvr70fy1L8R6qndCCy7ltYt5A6pTEHFnIVZsGEd6lzBscIow8xgyOkWVApSQDbxL7WdIg85X8qM5Lmjk7TPol7DmjSZ7+7KaUbOGw=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB4003.eurprd05.prod.outlook.com
 (2603:10a6:208:2::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.23; Sun, 7 Jun
 2020 15:00:22 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3066.023; Sun, 7 Jun 2020
 15:00:22 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com, amitc@mellanox.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch, f.fainelli@gmail.com,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: [RFC PATCH net-next 07/10] mlxsw: spectrum_ethtool: Add link extended state
Date:   Sun,  7 Jun 2020 17:59:42 +0300
Message-Id: <20200607145945.30559-8-amitc@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200607145945.30559-1-amitc@mellanox.com>
References: <20200607145945.30559-1-amitc@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:17c::25) To AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-155.mtr.labs.mlnx (37.142.13.130) by AM0PR10CA0015.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:17c::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3066.18 via Frontend Transport; Sun, 7 Jun 2020 15:00:20 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 80b36cdb-7e4e-4bd0-c336-08d80af3808d
X-MS-TrafficTypeDiagnostic: AM0PR0502MB4003:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB400339E7A025A376DBCBB3CDD7840@AM0PR0502MB4003.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 04270EF89C
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VvqrHlC1BcQqMambWuNNo3rD/UdlZr1nWuSfSCFudvH+JuHzcxOqZjDumhhfE+3bHk7Jurx7o37RXlKanAr6Mbxsru658/iu7vJyfzlBhpvtDLQ1muV+yz4Ec/W3ss+pUGPH6ZwfDe/usVqxbORwx56q34QD2xfqeibC3X2XRQ1XtGoKfAfWExRDXuEyaN+NnizqEKzPvqRCPiEG+IeaXDqxWw+/Vmo+kCsiiboMcTioNbTjhGylhk+RToKPOwYpQQ+xvdBH9OZaF5hovHLMJV1OiUDnPoAPy5G7QJ0Ex1FzJpuucaJa9ZOAzuT3fELu
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(366004)(346002)(136003)(39860400002)(66476007)(66946007)(66556008)(1076003)(186003)(8936002)(16526019)(26005)(52116002)(478600001)(6506007)(36756003)(2906002)(6666004)(7416002)(5660300002)(8676002)(4326008)(83380400001)(6486002)(316002)(86362001)(6916009)(2616005)(956004)(6512007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 2/1rRiheNn6XZ63ZugGeqjYWupGInBX5FqxeE68aBL17eONLwCOMCD9PYn5vqwD80ZvgRqdZLEprskAIaFqeRovCmjg0gb41BC6okCvOCs96emWsx0e8Rj69PBQ75Khyf3w9MlDLI1Y6E2QhlCclVvYe6e5U4KVCkFT/kmuLsVw6GdDRqaHVs+jot5hq0UaMxzlOSW/RjQF8Y39lJaVxaInqenSPdp7cpqKaC0bwizfN91TWw+Q2xoytjQvsJWWUhLyjhFEqgw+i6ImUNUjOCRZiZnKFCSIavSMpbMXZrnADGQ1Df97qsBoS7/BKS4mbl+3dJnyoxcSBxZmDylu5uKDruHHdSpvILyqW37dwrI/5IeIsdITa+yvBNMufqVdkgGV7LPQ4xnKXhqkmbb0scGCSInb7N46e+b93h9cTxW7ws6hQw6zVWyhtlk5BDYZdZn9T5i3FbfK5GMmyJoAysA9dQvoq954qB7D1hvfhUho=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 80b36cdb-7e4e-4bd0-c336-08d80af3808d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Jun 2020 15:00:22.5808
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: dUavifxkBUGZ0oHo7uh6qYkhIhP9P3Vh8HikBBE6/2R3mEF6kbUt7VBcHhXijwBnScp4Wh8a+lBiBtCXAr0kmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB4003
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Implement .get_down_ext_state() as part of ethtool_ops.
Query link down reason from PDDR register and convert it to ethtool
ext_state.

In case that more information than common ext_state is provided,
fill ext_substate also with the appropriate value.

Signed-off-by: Amit Cohen <amitc@mellanox.com>
Reviewed-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 .../mellanox/mlxsw/spectrum_ethtool.c         | 142 ++++++++++++++++++
 1 file changed, 142 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
index 04e1db604c69..ca0bfd07aab6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ethtool.c
@@ -26,6 +26,147 @@ static void mlxsw_sp_port_get_drvinfo(struct net_device *dev,
 		sizeof(drvinfo->bus_info));
 }
 
+struct mlxsw_sp_ethtool_ext_state_opcode_mapping {
+	u32 status_opcode;
+	enum ethtool_ext_state ext_state;
+	int ext_substate;
+};
+
+static const struct mlxsw_sp_ethtool_ext_state_opcode_mapping
+mlxsw_sp_ext_state_opcode_map[] = {
+	{2, ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED},
+	{3, ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED},
+	{4, ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_AN_NEXT_PAGE_EXCHANGE_FAILED},
+	{36, ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED_FORCE_MODE},
+	{38, ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_AN_FEC_MISMATCH_DURING_OVERRIDE},
+	{39, ETHTOOL_EXT_STATE_AUTONEG_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_AN_NO_HCD},
+
+	{5, ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED},
+	{6, ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_INHIBIT_TIMEOUT},
+	{7, ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_LT_KR_LINK_PARTNER_DID_NOT_SET_RECEIVER_READY},
+	{8, ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE, 0},
+	{14, ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE,
+		ETHTOOL_EXT_SUBSTATE_LT_REMOTE_FAULT},
+
+	{9, ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK},
+	{10, ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_AM_LOCK},
+	{11, ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_EXT_SUBSTATE_LLM_PCS_DID_NOT_GET_ALIGN_STATUS},
+	{12, ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_EXT_SUBSTATE_LLM_FC_FEC_IS_NOT_LOCKED},
+	{13, ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH,
+		ETHTOOL_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED},
+
+	{15, ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY, 0},
+	{17, ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS},
+	{42, ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY,
+		ETHTOOL_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE},
+
+	{1024, ETHTOOL_EXT_STATE_NO_CABLE, 0},
+
+	{16, ETHTOOL_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_EXT_SUBSTATE_UNSUPPORTED_CABLE},
+	{20, ETHTOOL_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_EXT_SUBSTATE_UNSUPPORTED_CABLE},
+	{29, ETHTOOL_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_EXT_SUBSTATE_UNSUPPORTED_CABLE},
+	{1025, ETHTOOL_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_EXT_SUBSTATE_UNSUPPORTED_CABLE},
+	{1029, ETHTOOL_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_EXT_SUBSTATE_UNSUPPORTED_CABLE},
+	{1031, ETHTOOL_EXT_STATE_CABLE_ISSUE,
+		ETHTOOL_EXT_SUBSTATE_SHORTED_CABLE},
+
+	{1027, ETHTOOL_EXT_STATE_EEPROM_ISSUE, 0},
+
+	{23, ETHTOOL_EXT_STATE_CALIBRATION_FAILURE, 0},
+
+	{1032, ETHTOOL_EXT_STATE_POWER_BUDGET_EXCEEDED, 0},
+
+	{1030, ETHTOOL_EXT_STATE_OVERHEAT, 0},
+};
+
+static void
+mlxsw_sp_port_set_ext_state(struct mlxsw_sp_ethtool_ext_state_opcode_mapping ext_state_mapping,
+			    struct ethtool_ext_state_info *ext_state_info)
+{
+	switch (ext_state_mapping.ext_state) {
+	case ETHTOOL_EXT_STATE_AUTONEG_FAILURE:
+		ext_state_info->autoneg =
+			ext_state_mapping.ext_substate;
+		break;
+	case ETHTOOL_EXT_STATE_LINK_TRAINING_FAILURE:
+		ext_state_info->link_training =
+			ext_state_mapping.ext_substate;
+		break;
+	case ETHTOOL_EXT_STATE_LINK_LOGICAL_MISMATCH:
+		ext_state_info->link_logical_mismatch =
+			ext_state_mapping.ext_substate;
+		break;
+	case ETHTOOL_EXT_STATE_BAD_SIGNAL_INTEGRITY:
+		ext_state_info->bad_signal_integrity =
+			ext_state_mapping.ext_substate;
+		break;
+	case ETHTOOL_EXT_STATE_CABLE_ISSUE:
+		ext_state_info->cable_issue =
+			ext_state_mapping.ext_substate;
+		break;
+	default:
+		break;
+	}
+
+	ext_state_info->ext_state = ext_state_mapping.ext_state;
+}
+
+static int
+mlxsw_sp_port_get_ext_state(struct net_device *dev,
+			    struct ethtool_ext_state_info *ext_state_info)
+{
+	struct mlxsw_sp_ethtool_ext_state_opcode_mapping ext_state_mapping;
+	struct mlxsw_sp_port *mlxsw_sp_port = netdev_priv(dev);
+	char pddr_pl[MLXSW_REG_PDDR_LEN];
+	int opcode, err, i;
+	u32 status_opcode;
+
+	mlxsw_reg_pddr_pack(pddr_pl, mlxsw_sp_port->local_port,
+			    MLXSW_REG_PDDR_PAGE_SELECT_TROUBLESHOOTING_INFO);
+
+	opcode = MLXSW_REG_PDDR_TRBLSH_GROUP_OPCODE_MONITOR;
+	mlxsw_reg_pddr_trblsh_group_opcode_set(pddr_pl, opcode);
+
+	err = mlxsw_reg_query(mlxsw_sp_port->mlxsw_sp->core, MLXSW_REG(pddr),
+			      pddr_pl);
+	if (err)
+		return err;
+
+	status_opcode = mlxsw_reg_pddr_trblsh_status_opcode_get(pddr_pl);
+	if (!status_opcode)
+		return -ENODATA;
+
+	for (i = 0; i < ARRAY_SIZE(mlxsw_sp_ext_state_opcode_map); i++) {
+		ext_state_mapping = mlxsw_sp_ext_state_opcode_map[i];
+		if (ext_state_mapping.status_opcode == status_opcode) {
+			mlxsw_sp_port_set_ext_state(ext_state_mapping,
+						    ext_state_info);
+			return 0;
+		}
+	}
+
+	return -ENODATA;
+}
+
 static void mlxsw_sp_port_get_pauseparam(struct net_device *dev,
 					 struct ethtool_pauseparam *pause)
 {
@@ -827,6 +968,7 @@ mlxsw_sp_get_ts_info(struct net_device *netdev, struct ethtool_ts_info *info)
 const struct ethtool_ops mlxsw_sp_port_ethtool_ops = {
 	.get_drvinfo		= mlxsw_sp_port_get_drvinfo,
 	.get_link		= ethtool_op_get_link,
+	.get_ext_state		= mlxsw_sp_port_get_ext_state,
 	.get_pauseparam		= mlxsw_sp_port_get_pauseparam,
 	.set_pauseparam		= mlxsw_sp_port_set_pauseparam,
 	.get_strings		= mlxsw_sp_port_get_strings,
-- 
2.20.1

