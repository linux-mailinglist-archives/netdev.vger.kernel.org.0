Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2678221BF75
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 23:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgGJV5P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 17:57:15 -0400
Received: from mail-db8eur05on2045.outbound.protection.outlook.com ([40.107.20.45]:6078
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726628AbgGJV5O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jul 2020 17:57:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cD7pxJXe9WGSax+t/SkQVkmdpEfzXSfHE5vyG5G0MYHEvl9AqpSiXXPv7sJfp6obHWNb76f7pdIZTjYd9wG3RsiwZwo1cNcxGVZtQ+huVFzaB0MffXJ1TbOmcgE47IqsUb3ZEGhakGcvrF2D4hGMPxQRFOvwsoOoIKnHpei0PPa1rvYcBQpRP9CvGzSMtPg9CASCvcyxVa6j78RQ7iWRfigylPTtwyA5BH07ht8nJ0LGO3mw7mSZLXnkgQ86i+IZ1ddofJC74niO1UM8RGY72/NY5RbJ6ikk3n34Yt1A4Cv1wtpLbqwkMqXR5lrW/Gw5Ad9PJCiYTxSXuqDwevk2bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8skRD4IWV3YKNR6ygm3d/MElVEsdbsHuDMPvwtqCxo=;
 b=dFxxHPnO2uqjGRBfMV6hGI+E50nVd7LWcgEngdXqc4s35M6w9EaG/HsIEu/R4djyhW6GQyt/3zxrf/ui25pO4kJNJARFePVl/DffdXlfX6ivVNeocAFfCmQ1yHoIqbCLU/ucisRikbwvBrFDSDl4yvUJZld6yCiOf7QR2+JuYDoJ8wzb8HU/UBLwU1LtdrMMRFos2PUoBbsIAgo5Orp3gQuJL4VeBLz/mAENdGSBimrruWQA2I0WFYVsy3PJtFj+ecH3SYc632RkqTroRKrXCbn8CVKEml0sCsCBb+tZdl+tPj5K2h/8V8QD+wZ/Sgwzt2pp9AFu4gjB15Ou3NDAdA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R8skRD4IWV3YKNR6ygm3d/MElVEsdbsHuDMPvwtqCxo=;
 b=SuzAw0U8peajsQw6i8xJHsD7kxVJvT2tgRpFinywI68ml8L0BePxnRc+ClwEaco2j8/jemzgZU3MBZwDcVCShjwUoWtLVQjjjWH3qL8My0wQBZtVO7JRtwSJipM8Bs3NYKgIBxxCAL+WwyU80xAUAX14oV1ILQb2o3Aei42SKCg=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB3354.eurprd05.prod.outlook.com (2603:10a6:7:35::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3174.20; Fri, 10 Jul 2020 21:56:58 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::78f6:fb7a:ea76:c2d6%7]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 21:56:58 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>, davem@davemloft.net,
        kuba@kernel.org, jiri@mellanox.com, petrm@mellanox.com,
        mlxsw@mellanox.com, michael.chan@broadcom.com, saeedm@mellanox.com,
        leon@kernel.org, kadlec@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next v2 08/13] mlxsw: spectrum_flow: Convert a goto to a return
Date:   Sat, 11 Jul 2020 00:55:10 +0300
Message-Id: <e89f0df0af44c4a1499083d09c2ad305c90a0d64.1594416408.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM3PR07CA0116.eurprd07.prod.outlook.com
 (2603:10a6:207:7::26) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by AM3PR07CA0116.eurprd07.prod.outlook.com (2603:10a6:207:7::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.8 via Frontend Transport; Fri, 10 Jul 2020 21:56:56 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 47407752-d2ae-4089-9c39-08d8251c2af7
X-MS-TrafficTypeDiagnostic: HE1PR05MB3354:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB3354D1D58886A3C9506C08D6DB650@HE1PR05MB3354.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:901;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QsGciY79njgARm+urqWNNjzRzenvVhwinfLy++ICH3EPX5mqnpKKEm858Edeut9WCIZY5woBc1tr8fX11T96W8TKVA5ie9aLXITuP6blTGDHVFEAVFXlw62t9rX5C9b+FmClR/WS7ZdaUEr9A6sqY3jpcPc7BqM0DzPdf7Yz/Kt1zlPPzDhUfJqugi2yoziOpVEXg7ac78twZPnhEp7tDrcJqnsc1fUIBuyCGB+03dugj2VSsl/apMVbZpqTxkmsLAa10UJhgzwPtvRj9NkTApC/GcPX6l41upJKCxnsfxma0wanGsbLdw/Yz2V/SHzx
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(956004)(86362001)(2906002)(6916009)(5660300002)(2616005)(83380400001)(54906003)(7416002)(6512007)(8676002)(107886003)(26005)(52116002)(6506007)(36756003)(66556008)(66476007)(316002)(8936002)(4326008)(478600001)(16526019)(6486002)(6666004)(186003)(66946007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 6lZWuoJKiiaMk7PyoSHZlFlO24OKXNZIC8EIygZSSV7DyGIBi7TJORSC+3CE3EJ6AMAdnqBJRL5lZCD32oeLuElaplRaCsahbNhR1xTytsAherhMcdOuqVpicNSjKTIvPORAL4Ug76cLhtVsE8sfS6byDX0OTUV2vP+D+W1l05B0NGoANLXFVclQM7O5fAr0d142VF2DccuFnYMYVoQPfgOC7BfbcaFtHO3oKK8UjSNwAr2U5YGnTq2lDZ5UXRmgxAkin9BTnaIRdTI2YzKVXgRQpQhIhK5Jfctwu9rAgEo5PKi5SAJdpRWCvHTYqYQzr91MOsF9zfeg/S/d8dGlu+WN1elUBIYQuGSLgTQh5Asg4bOTO++zNFPR7EhxyOPsSfZ8OHZdy0BZophwiwVW5ibuFQ/g8OMox0OANvqNnfZV4HCLAF4LmJVZJU6G+j0KiBeSAXMh+VnldxAkd1L+9Me/IQ/2o01VnAO6DS0ww/k=
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47407752-d2ae-4089-9c39-08d8251c2af7
X-MS-Exchange-CrossTenant-AuthSource: HE1PR05MB4746.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 21:56:58.5796
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZqD/NEPZ+yOMfT2KhhzqN5/worB5pFdLb53cppoweZxDpytgIOJT8Yc31OyGFcWN4Vin59UlzMMkop8dTSFROg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3354
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

No clean-up is performed at the target label of this goto. Convert it to a
direct return.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@mellanox.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
index 47b66f347ff1..421581a85cd6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flow.c
@@ -219,8 +219,7 @@ static int mlxsw_sp_setup_tc_block_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 					       mlxsw_sp_tc_block_release);
 		if (IS_ERR(block_cb)) {
 			mlxsw_sp_flow_block_destroy(flow_block);
-			err = PTR_ERR(block_cb);
-			goto err_cb_register;
+			return PTR_ERR(block_cb);
 		}
 		register_block = true;
 	} else {
@@ -247,7 +246,6 @@ static int mlxsw_sp_setup_tc_block_bind(struct mlxsw_sp_port *mlxsw_sp_port,
 err_block_bind:
 	if (!flow_block_cb_decref(block_cb))
 		flow_block_cb_free(block_cb);
-err_cb_register:
 	return err;
 }
 
-- 
2.20.1

