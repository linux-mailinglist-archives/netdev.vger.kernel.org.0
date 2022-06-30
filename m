Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CABB8561502
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 10:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233319AbiF3IYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 04:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233811AbiF3IYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 04:24:10 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2058.outbound.protection.outlook.com [40.107.237.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 478F5DF8C
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 01:23:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HwiPpSw2a4MtanVLBUdRlfkH5nB5Mm06lm1wamzl57LeHJwP6O8plmgii0tszRZsp5OX1nz09wUD03YMHYRnQM5kbG1oC0tCN/IeiO4Dn9GJNkpTMByn/ySlP12cPEx+mkoNY1iuwHfdBYjo97mdEAQTeuLVB/eRKiqQnQgGu5ADZSkfwcrdOAg9kVbVYZb6C0L95oRCNdt53vIAKE259EVFtBPp/WIcJYg3NszDA0JGUHuAqaZB022MyFZPMCO0DPbwPelheRjBilAd9wcHM2wB/XLZ8JUEdr0oP57OtCWOin9UKYH/SJNokVIFpzSPH9xVYkg4TTKRnlbTWaQhUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Z0TKWZ0l3lFW0LzK0rTYNFE0qSVt71HLMupIioC7CCA=;
 b=aN7tVOJPpM/CfuscFcSQ60WEDasFwwAdMy0HHa9O3Lqh+74gVUOakA+wc3tFlVuBmpjGWkM5AT78ZAo/ZXqIgtVU0Di+XqWkrqR3bS9gH7wheZ6H7pJt652gV1AS+JyFkFAIXhD9SqeN1DcVsjXc/lQghiFhziGdDoiSA8oV271Ioydcf32heMd9ytpx5CXdNsQSvpyXbRPBOu/k20Y9wvsWp6Wf63YcAMoqaJN7jUYLrq/Y7b9WSzp9U9+SmlLanGZGrLoop4FrWfa/qoz3nxzgxmpOs9rq6xChN4D4VI7YK9obYb3ece1HqX94W8rqej6dG7Fj13meZNenvKvImQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z0TKWZ0l3lFW0LzK0rTYNFE0qSVt71HLMupIioC7CCA=;
 b=Gwjy/S6e/0XCzR2MQJHO0KnpP6HvZ0y6mOTB77iqoclds10OZ+z61sMpXY+iaxbbhvCItt/7LkEuakpjvL2yPDpqMdFiM89tSvT8X2KbEZYWogXg2tVL3/MLL2UtGIQQnQouhi8YF5hY3bFMuyvLwe4e8b1M2U/jhNd20ycL5Cp/v7N+dGskbLVUuEgyNXaauXQ7HpsJthSY1ZMN2SQJVk4/T50or3pO3ISeuDQs2skC+cn/GcbOsAiahhrDb+0ono/exst+FqBKoRUJrg3bo1O/M+HDvPOqSr4gjLH6967sAf/wZy0c+Mzhbwm9FmpL2dAvC2+sY2THCEOCXYMOSg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB2880.namprd12.prod.outlook.com (2603:10b6:208:106::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.17; Thu, 30 Jun
 2022 08:23:42 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5395.014; Thu, 30 Jun 2022
 08:23:42 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 04/13] mlxsw: spectrum_fid: Configure layer 3 egress VID classification
Date:   Thu, 30 Jun 2022 11:22:48 +0300
Message-Id: <20220630082257.903759-5-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630082257.903759-1-idosch@nvidia.com>
References: <20220630082257.903759-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR03CA0046.eurprd03.prod.outlook.com
 (2603:10a6:803:50::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e85ea4d-936a-41b7-6fe8-08da5a71d76a
X-MS-TrafficTypeDiagnostic: MN2PR12MB2880:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8EwxCNIlXzqLLo4b6AeAIhmDpOngFd7lUxTdFZnZ1i10mMsF7tsxggzEF4CgTSArZY8/NGCL8VA9nyAJFwh3JBU80/4hJpTDVuuEWbg9ZT3gKhoa3aiukNw/9n6pGkQ2b0a5w5HtPGM58hR4lFOyObrsdtlsTqPC7+tjogjjUfxkHXd/va5EJO6vty7sXBYySsKlOEWAk0a5QrqfgIEQiZEMX4l6zii0+1i2UDlqQ+5AEqdEDKQbjxGa5DE26231qFKBBeykktgXyIZ2AJ2sCYMswrQ8IXDsS+l/Oulfrm8bDxXO3EF2DmHwRhN4TeiaV2NjE8IRG0TkvglK7Up9QiFGtHGkoyVIxOxamU2qsTEa06TKiC/CrmVegL2yIkaEOdnz+4Gixe2ByD2VxczhghgYcb05fHgOgoNzMlpcXtlhVOAL8n/7rSV+6LVK/tagOtqroZPCVjqfNTKJVHSVhneUh5NekT9Icf5NswsjGZxNKrHoxcbVazcYCMQeXOQDd+vCthXTDBPHWHy0l4tu+f1QNOUTanrpExPbn5S1ILpyZ0YO5o6pfbksPCha16mqzfiNX10axj122pqQZvrjQiWQXT8iI52Kw3BrtOLvxpIo2gV1zgm0pvf2Js/TSTAHrYXsHkgd93fNOexPmwmBDA/H8KnAH677CxZLtghGYStaaEU9i60hhK6h9MIqz4cAzDdArks6qIXOEiQhmDsjoTkadV0ao5BM/uki0IldbzO7/SMU85cMwhcXqvcAQLXM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(86362001)(6486002)(1076003)(36756003)(8676002)(66556008)(66946007)(478600001)(4326008)(66476007)(8936002)(6916009)(186003)(316002)(5660300002)(38100700002)(6506007)(2906002)(6512007)(2616005)(83380400001)(26005)(41300700001)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/lY5Jo6FTjEp1csuedYL6y9jsXQ0nAp0GE5Hgqffx7+wU+cUyn1yHlgL3z/w?=
 =?us-ascii?Q?9i10P5lV6+f4eCunTPWos3Yg3M96d/wW/AloTrgGK76jcjeDkCoHRhfKRRl+?=
 =?us-ascii?Q?QTQRwnlZD4IsYMg7KyC60gZUOIqU7xHC9NtE2T7wP5Hu5ru1XuIoFzD8Eaw/?=
 =?us-ascii?Q?q+9ewE1USGQnavDdv47Qekyw+T61P6No+jEWazjLR4d5+/rFpoNzZ9fTkw3s?=
 =?us-ascii?Q?FGe3BexQqoXd4wvsAGgd3RCjT87OoHlHBe+2lgreXHMYG5s7f6VwOJNdch3k?=
 =?us-ascii?Q?qGSgjPjeOYKiti0ZeSiCoy1Ro89qz4hafTlsPdBWpHL1AAP8HvPUSBbphGFL?=
 =?us-ascii?Q?CsKwMIAQLiMKDHFTn6ofz0RHYo4XLOQyOk+kBUXXVBuLkedgRTcFVLMv+SIl?=
 =?us-ascii?Q?Ujg+CLhVVXZKZnMoLwQAMu3noxs6wt7EL7dQvlFB4/CvhvKQ8mqIoO6dgz+h?=
 =?us-ascii?Q?mGApHLdqfxYWe0AG0G50HZcqFNwUtb6PcLca3tRCnAtvCbA3t5iAWIwXN4eZ?=
 =?us-ascii?Q?aGCiZVnXnC2NsMhYWjnens6WAyOxfssM14Jy5v/lHGP/9sgbMQ9thADRJ6aV?=
 =?us-ascii?Q?rP4s2kxMhuMkwKJ7dIj/bcsfofCLTuvKpbwDgjjkhULxYqdxsuyl5M0nJ2AF?=
 =?us-ascii?Q?L2Jou9vodQSnjmPDyFpYGglkKf2JBjSb8ywf/+hW7it4gMM97O10VuE3qaRV?=
 =?us-ascii?Q?BR3ZJCgWGuETCu6IzZPhE0fCqbIBLS+kuyyk90w44t8M9bItAFqJBjqJyBhl?=
 =?us-ascii?Q?ltaXnAV5Yx++J7KD7jEyhV4XJSMlCtcaIIV2BhQJTyiagZDsSURcopWL9zxx?=
 =?us-ascii?Q?TXqhjwzSLsS4ncZfnY4T/V1BcyJoHC/8kbXY+xSnVBZp0vRXpanUnoh9P9b2?=
 =?us-ascii?Q?kvqWrCJPwkF+hWwys2AqVQYFZfRZEX5s6rxFhfwpBnqcCCafi9sC5ND6hsow?=
 =?us-ascii?Q?EXLQCfIFHPqIH/L7hM3O2G9f7jH/as45PXyMnrEQpYKfLv947JjBjm3sqjJE?=
 =?us-ascii?Q?p5sSZZoqc9ce9CE2hMVrwAIDt51rubUvdwWwZvZ7/6BFX1bXDYOlxvYDRCbg?=
 =?us-ascii?Q?NJ7yCrSsmSUzgz7tJEndV9GwHoE8C3Sipgz7RHL0Enw37/FP4VLPhAZO9KRf?=
 =?us-ascii?Q?ppby0vyz9L4tyBGaKFBFkVMt5hqYKBhbptetXfoPiyg1v01rGa89mZwHn7C8?=
 =?us-ascii?Q?PTvIi+lkOAAFsn02Jd/B2KppiGGHsROFPLdGf5labun8GGpNkfg1xUO7bO7Q?=
 =?us-ascii?Q?tgVJ3fa5g67957QA+1TRjG1wX/8eQ0LEI0mcAsIXantDaRmFcDlkth93ei8c?=
 =?us-ascii?Q?fNKwNWu+DhzEuwUv35YZ0C5/Sx62nfHPuRlrMaHOYVF3P0HEFfWDEsVEJz/8?=
 =?us-ascii?Q?XKBmBxW2lrZLO1Cb3laaJL4lXVrgyqEYxZ9k3PXblHvI4JtkrtIw6Iairmv0?=
 =?us-ascii?Q?CDJ2+yOfj0egr9nUdjkvA8Dv1usI6Mr4+bduzISkkon7R8TeE00GY11yobqX?=
 =?us-ascii?Q?SaEByc1NTDgNf3QBB75nofruT6sPHJPtdUkMroWM9X29Ub9NUJh6lPz5AB0/?=
 =?us-ascii?Q?LqoJ8XlgzZhXvRKEnvdbZSDxgyvXwndQbUOi6os4?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e85ea4d-936a-41b7-6fe8-08da5a71d76a
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Jun 2022 08:23:42.1195
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 61oKtMo3jfMMLtoGKFAyerZ4C1ohJK9Pl6Dcy/yNGkVEU6Df84dY92REFQNODk9wAsvPQAPCDbNwanX63SUmJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2880
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

After routing, the device always consults a table that determines the
packet's egress VID based on {egress RIF, egress local port}. In the
unified bridge model, it is up to software to maintain this table via REIV
register.

The table needs to be updated in the following flows:
1. When a RIF is set on a FID, need to iterate over the FID's {Port, VID}
   list and issue REIV write to map the {RIF, Port} to the given VID.
2. When a {Port, VID} is mapped to a FID and the FID already has a RIF,
   need to issue REIV write with a single record to map the {RIF, Port}
   to the given VID.

REIV register supports a simultaneous update of 256 ports, so use this
capability for the first flow.

Handle the two above mentioned flows.

Add mlxsw_sp_fid_evid_map() function to handle egress VID classification
for both unicast and multicast. Layer 2 multicast configuration is already
done in the driver, just move it to the new function.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 142 +++++++++++++++++-
 1 file changed, 137 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index a8fecf47eaf5..c6397f81c2d7 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -590,8 +590,82 @@ static void mlxsw_sp_fid_vid_to_fid_rif_unset(const struct mlxsw_sp_fid *fid)
 	}
 }
 
+static int mlxsw_sp_fid_reiv_handle(struct mlxsw_sp_fid *fid, u16 rif_index,
+				    bool valid, u8 port_page)
+{
+	u16 local_port_end = (port_page + 1) * MLXSW_REG_REIV_REC_MAX_COUNT - 1;
+	u16 local_port_start = port_page * MLXSW_REG_REIV_REC_MAX_COUNT;
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	struct mlxsw_sp_fid_port_vid *port_vid;
+	u8 rec_num, entries_num = 0;
+	char *reiv_pl;
+	int err;
+
+	reiv_pl = kmalloc(MLXSW_REG_REIV_LEN, GFP_KERNEL);
+	if (!reiv_pl)
+		return -ENOMEM;
+
+	mlxsw_reg_reiv_pack(reiv_pl, port_page, rif_index);
+
+	list_for_each_entry(port_vid, &fid->port_vid_list, list) {
+		/* port_vid_list is sorted by local_port. */
+		if (port_vid->local_port < local_port_start)
+			continue;
+
+		if (port_vid->local_port > local_port_end)
+			break;
+
+		rec_num = port_vid->local_port % MLXSW_REG_REIV_REC_MAX_COUNT;
+		mlxsw_reg_reiv_rec_update_set(reiv_pl, rec_num, true);
+		mlxsw_reg_reiv_rec_evid_set(reiv_pl, rec_num,
+					    valid ? port_vid->vid : 0);
+		entries_num++;
+	}
+
+	if (!entries_num) {
+		kfree(reiv_pl);
+		return 0;
+	}
+
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(reiv), reiv_pl);
+	if (err)
+		goto err_reg_write;
+
+	kfree(reiv_pl);
+	return 0;
+
+err_reg_write:
+	kfree(reiv_pl);
+	return err;
+}
+
+static int mlxsw_sp_fid_erif_eport_to_vid_map(struct mlxsw_sp_fid *fid,
+					      u16 rif_index, bool valid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	u8 num_port_pages;
+	int err, i;
+
+	num_port_pages = mlxsw_core_max_ports(mlxsw_sp->core) /
+			 MLXSW_REG_REIV_REC_MAX_COUNT + 1;
+
+	for (i = 0; i < num_port_pages; i++) {
+		err = mlxsw_sp_fid_reiv_handle(fid, rif_index, valid, i);
+		if (err)
+			goto err_reiv_handle;
+	}
+
+	return 0;
+
+err_reiv_handle:
+	for (; i >= 0; i--)
+		mlxsw_sp_fid_reiv_handle(fid, rif_index, !valid, i);
+	return err;
+}
+
 int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
 {
+	u16 rif_index = mlxsw_sp_rif_index(rif);
 	int err;
 
 	if (!fid->fid_family->mlxsw_sp->ubridge) {
@@ -611,9 +685,15 @@ int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
 	if (err)
 		goto err_vid_to_fid_rif_set;
 
+	err = mlxsw_sp_fid_erif_eport_to_vid_map(fid, rif_index, true);
+	if (err)
+		goto err_erif_eport_to_vid_map;
+
 	fid->rif = rif;
 	return 0;
 
+err_erif_eport_to_vid_map:
+	mlxsw_sp_fid_vid_to_fid_rif_unset(fid);
 err_vid_to_fid_rif_set:
 	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
 err_vni_to_fid_rif_update:
@@ -623,6 +703,8 @@ int mlxsw_sp_fid_rif_set(struct mlxsw_sp_fid *fid, struct mlxsw_sp_rif *rif)
 
 void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
 {
+	u16 rif_index;
+
 	if (!fid->fid_family->mlxsw_sp->ubridge) {
 		fid->rif = NULL;
 		return;
@@ -631,7 +713,10 @@ void mlxsw_sp_fid_rif_unset(struct mlxsw_sp_fid *fid)
 	if (!fid->rif)
 		return;
 
+	rif_index = mlxsw_sp_rif_index(fid->rif);
 	fid->rif = NULL;
+
+	mlxsw_sp_fid_erif_eport_to_vid_map(fid, rif_index, false);
 	mlxsw_sp_fid_vid_to_fid_rif_unset(fid);
 	mlxsw_sp_fid_vni_to_fid_rif_update(fid, NULL);
 	mlxsw_sp_fid_to_fid_rif_update(fid, NULL);
@@ -844,6 +929,53 @@ mlxsw_sp_fid_mpe_table_map(const struct mlxsw_sp_fid *fid, u16 local_port,
 	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smpe), smpe_pl);
 }
 
+static int
+mlxsw_sp_fid_erif_eport_to_vid_map_one(const struct mlxsw_sp_fid *fid,
+				       u16 local_port, u16 vid, bool valid)
+{
+	u8 port_page = local_port / MLXSW_REG_REIV_REC_MAX_COUNT;
+	u8 rec_num = local_port % MLXSW_REG_REIV_REC_MAX_COUNT;
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	u16 rif_index = mlxsw_sp_rif_index(fid->rif);
+	char *reiv_pl;
+	int err;
+
+	reiv_pl = kmalloc(MLXSW_REG_REIV_LEN, GFP_KERNEL);
+	if (!reiv_pl)
+		return -ENOMEM;
+
+	mlxsw_reg_reiv_pack(reiv_pl, port_page, rif_index);
+	mlxsw_reg_reiv_rec_update_set(reiv_pl, rec_num, true);
+	mlxsw_reg_reiv_rec_evid_set(reiv_pl, rec_num, valid ? vid : 0);
+	err = mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(reiv), reiv_pl);
+	kfree(reiv_pl);
+	return err;
+}
+
+static int mlxsw_sp_fid_evid_map(const struct mlxsw_sp_fid *fid, u16 local_port,
+				 u16 vid, bool valid)
+{
+	int err;
+
+	err = mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, valid);
+	if (err)
+		return err;
+
+	if (!fid->rif)
+		return 0;
+
+	err = mlxsw_sp_fid_erif_eport_to_vid_map_one(fid, local_port, vid,
+						     valid);
+	if (err)
+		goto err_erif_eport_to_vid_map_one;
+
+	return 0;
+
+err_erif_eport_to_vid_map_one:
+	mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, !valid);
+	return err;
+}
+
 static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 					   struct mlxsw_sp_port *mlxsw_sp_port,
 					   u16 vid)
@@ -858,9 +990,9 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 		return err;
 
 	if (fid->fid_family->mlxsw_sp->ubridge) {
-		err = mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, true);
+		err = mlxsw_sp_fid_evid_map(fid, local_port, vid, true);
 		if (err)
-			goto err_mpe_table_map;
+			goto err_fid_evid_map;
 	}
 
 	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
@@ -881,8 +1013,8 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 err_port_vid_list_add:
 	if (fid->fid_family->mlxsw_sp->ubridge)
-		mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, false);
-err_mpe_table_map:
+		mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
+err_fid_evid_map:
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 	return err;
 }
@@ -899,7 +1031,7 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	if (fid->fid_family->mlxsw_sp->ubridge)
-		mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, false);
+		mlxsw_sp_fid_evid_map(fid, local_port, vid, false);
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 }
 
-- 
2.36.1

