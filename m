Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175A45573BE
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 09:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbiFWHT2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 03:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiFWHT1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 03:19:27 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA9B845503
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 00:19:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D9UVYHoUnEL7iqeWBFW/SuTHSOftBQrvYUbJXLGxxJhGKtNdI5NmlmnGWjGomKHWlnBiiON/5YX3raiUUnNSNFpirI5Lp6CmsBiUG7FRweSZluLrsEmJJpa9iRr99EIU2zLiXpNznuXc2aWetVG3Hl2KU3ZRnsqpV231tjjhWGI6auIAjmKeWgqTSwtuD6m8y/rzZw09MA6tVC52dgPeuF+7hZr+V4jeHuU3MdBTliER6qW+1CEkzF8ung0gs0gtkHEVPBULdgziG1W8XjOEyh5pjdUKygMl33nGcFWyjX/FLqZ1Du28jWm9JLTEWqXuDQkjsGHGV5ep1bnw9wbImQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iWeqBtvOwrxti5FEL9PIKlJ52iSIQmh6ygGe7wsZoik=;
 b=TKLQUeVt78T8q+32uVaZQrvHuyEFG34Ld18gKGSXcUmy4JxgHmbJlmbGChexBOLtnTuHK4DDpd2qRxfeE9vf6bURv8InPu4JvmV4P0OPcR7PCrWQuuct7Rm4rQXNq7ZatEgGzMIg2ymF+2BAN8kVOkGMjyOAT0CLKp+KcaOguzz5kzwTrtCcOcq0DXFwbiLwtq067bLrAjhM6vOoF7+Hc8zdbV3w7i0M0sL1JX/dkU9IVvUDFWQlSs5E2MIDCO1lEa8NfPKw16U70qcF8FHdk6zDVlVohHdRudPbSN0fBdCsOQA4Goky5TLpC3GlWlmLtf1EYbtlt8S7Ix7Zpehgpw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iWeqBtvOwrxti5FEL9PIKlJ52iSIQmh6ygGe7wsZoik=;
 b=quMPouggZaTQi0yTwDxrTbVDtOYrMvvYAHk7Lng1iQnDh188zM4ssg3zwwbExZEP7nl0f6Dm6aB7Oh9sov2XPceyCLhIrIuNJvJIZiJPzQpP54D8PVMmOQxaRYM+nNsoP54BW4NqoqEJvC5tAtgkSuTX6hWiFQiDpDWeP1gTpJ0f8I0u9JRO5LQqPO8PZuFTGSIM83yM5TQf5kHaaZaWwEwuB+NOOnxhg6PEUZ1pHlWvtXYC4CEDGavp/Btbn//BhJx5puPIcTMxI+UTXQ/ln2bwxdX46BwAf3XufPyML3V45VHTeu0NWIIBkP1CeXyxYhLAR0ggSO5zDMEreCRClg==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from IA1PR12MB6163.namprd12.prod.outlook.com (2603:10b6:208:3e9::22)
 by DM5PR12MB2518.namprd12.prod.outlook.com (2603:10b6:4:b0::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.20; Thu, 23 Jun
 2022 07:19:24 +0000
Received: from IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf]) by IA1PR12MB6163.namprd12.prod.outlook.com
 ([fe80::6da4:ce53:39ae:8dbf%7]) with mapi id 15.20.5353.018; Thu, 23 Jun 2022
 07:19:23 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 1/8] mlxsw: spectrum_fid: Maintain {port, VID}->FID mappings
Date:   Thu, 23 Jun 2022 10:17:30 +0300
Message-Id: <20220623071737.318238-2-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623071737.318238-1-idosch@nvidia.com>
References: <20220623071737.318238-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR0501CA0018.eurprd05.prod.outlook.com
 (2603:10a6:800:92::28) To IA1PR12MB6163.namprd12.prod.outlook.com
 (2603:10b6:208:3e9::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f7432f8f-d5cd-4852-0596-08da54e8b28a
X-MS-TrafficTypeDiagnostic: DM5PR12MB2518:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB251817B87667915B70BA1682B2B59@DM5PR12MB2518.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yR3FYHjrq+xtuxsS8VgBlxnkhwl6HRzl6rVwlSv5HzEIp0zEEIyEVjMFkS8CvjTDfY62rk67fJWc0q0ASt018ZYKdTQWvzJPMdI4UboF3TOr6IJ/IW9xMXjsPNRYX2nGsI7OMOybbOZSffG2fuZTNVJ08vXO+YUZ7BOs42FKRn4b0SzqvFnGF7TnwgXs7GiMQwzWeIqlpzTkVrUjQ/9+3tYxtHv6GzeOZNKKIn9OmeOI1f41BnjxbxTmrdDhWFAZ1iHYeQz1mi/8J61UUf+mwsSlhpd3IIri4XwFWWzlC2mcpT0Z3B25XG6BQ/mv8AtxTzNEw3X6Zbmqz9ugiMtnrteEr7RLBb+SmiaulWJpYWmDqUEduFkvtPE4q5ZvZoyZlvV1jMrWk/Q2e3NV/KaHc5BH63LdxQguU6PGKiDTjHtiMH7f7wHckm/djVm+DdJ0U4HsNmAYTO0vC8mozKXp6lhj+mJ1R+0KRg4SpevCyRuGG5hEMPJaRrayOwb0NX4bwqQuszVGtkKOfFtTVDr3Uf8ViqDLGRtQQgvurbLCpGA5+m7J7Pg4hrguuc94DE83B9Zz/3v34Pal+5+Gn9I/tZxQ9N3gqWMcQnGP1OwK712GGIB6dXWZE+904q0NTI/1ObNtX7jF03o2RsQs1edQWSpab/VRJSkoquAE5lE90QEjx73DaAjbxnK9OBJLZ+p3YnUfRyzcOhINHe6LjcaHew==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6163.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(39860400002)(346002)(376002)(366004)(136003)(4326008)(8936002)(66476007)(8676002)(86362001)(1076003)(6666004)(6506007)(66556008)(6512007)(66946007)(107886003)(186003)(6916009)(83380400001)(2616005)(5660300002)(36756003)(41300700001)(38100700002)(26005)(316002)(6486002)(478600001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?Kk/zO6MeQ4YcQAk8bQ4cPfr8fMkBq4kMEjevcsus0EVPUJ0hoz3e+0OXxjY2?=
 =?us-ascii?Q?VNQSp5D+JKCMkK4ILxvViVw4sZfaagxUjvLgAlv1/sEqMvzNX2Ywu7nIVbRv?=
 =?us-ascii?Q?zGS5WaJq4qTkYcoDKv+HmgIrYldalvhHvRMAlZNa74H9FmLcQTFc91xDF286?=
 =?us-ascii?Q?g/bBxDkdyuEAkpV3ff0OCRAyn/3C+74qcXwlnQBXrX65cTd/clA72+njdcDb?=
 =?us-ascii?Q?rXIYs8a9BT6Dmn4DjHfNULy+pl5g8BjdF1GOGRWaXiiB+n6Xly1CKY9OLkOa?=
 =?us-ascii?Q?deY3VPqyfTUbxPswgX1INJf07Oaav7YE4F2xtPkyh1+DE++vX+7wiEZA9J1n?=
 =?us-ascii?Q?S7EBGbyX4MTglg5wxQ7UsnFysNvzP0dSEBVQNEFgV2Yu/fV1N7x1t1Gvudce?=
 =?us-ascii?Q?tmOCjJ5htkg0pOQ40KSaNgR0/gQI/SEtvp5TflZllmakYD/FAxq0ElOQcvhh?=
 =?us-ascii?Q?gYHa4niupC6H4xWQAY9kNNfHzaNfTEKxV+yN43ao9b2hxb16mARJD6KB8sH+?=
 =?us-ascii?Q?EkF91tLsOgfeGZp0rX197ipB+ljBunpXkVUf4pPvTUU5EG74DFq6ptETk8/i?=
 =?us-ascii?Q?qzxa3VlrlmeFa42gNsYNIr9d8mpXuAp7uKwRdbJkJQk+10ps/2vo+/B0uaap?=
 =?us-ascii?Q?jnjXAWiOtbcLZqkE8+VQn1jZNoiVwz9VZn9nU6KMv1UH6Lsap5FNvi5vaSdh?=
 =?us-ascii?Q?Q+HDEnBiBgLM6xaCK6mqKq4zAHKpVpqNFR5vp/pm9x5qWc78CXMN8wFoFmb6?=
 =?us-ascii?Q?wfZgMwzJTRl48dgZYu57w6iJ5wvAPc/33hrjQHrc6qn/Md5mapRYGYPnc+kO?=
 =?us-ascii?Q?kXrG9cnmTWEWm4yyCWrqxtDLHL/vyRbNyk+r7V0PcSfRwS/s8N/oocEPh48d?=
 =?us-ascii?Q?YjCnnK/BXlXm8+17bVJBYHXf7nLHkJwYFLptasqZKN1RSuZnNelnhHTLbnnG?=
 =?us-ascii?Q?+GO7R2COJkDFjFejDwnnqNG6uUM5B37CiqRii6yljNEWR2zBqnWNt+THC4Oc?=
 =?us-ascii?Q?3KP6ZpzNU/4nT5Rm+nD+Guec7wCIWH/oJg5IZv77I+NHwMglafR5RTbyfq6+?=
 =?us-ascii?Q?NdhfUHrIL207gzWlcjkYotYDP3xAA1py3f23DHiV2PNHZzD43fMNiV+deCqg?=
 =?us-ascii?Q?rtDSc+j7QGrgDslg7xrCJj+5d1820M1LI4NB0WKKp4A5N+zkkeIO1FvSHujF?=
 =?us-ascii?Q?eGjfdjwXz8+uG78XiWR/NCjYFyeeU8DtstvNuH1O3X1sUYenPrOUnJYNgAhS?=
 =?us-ascii?Q?uRkh62oF2MVYYI636UMI06S3N/m5rxW8bq+ogfItzDwQtpae8NwZ4iBM2uJS?=
 =?us-ascii?Q?s01gqiqG/NuKKXEOYjl1LU+9kRYr61TZGKJBh+d72Jsm+H3Q3Nz2zRRfhX/d?=
 =?us-ascii?Q?bfT0le3E23Gq5Qwdt06kncHu/3N6I9HwFDnb/pKhdbZC2AUFUh0cbhO1zgsn?=
 =?us-ascii?Q?Q8smMUK+b1JbExChbYboFL+ITuNTAxwwRnNjtiJ5QUzyvq3KifXLU6siCMs6?=
 =?us-ascii?Q?zz+cKRPWqXYz3pSRruQ8cY7g8ctpECf3uNfWJMVqu2bf7LpwvCUcudwqM1dq?=
 =?us-ascii?Q?qxpyJ9cicbYaIwtzOGNXZnr4ic2m10Zro5x+wYDXBGU22Gur+zEIqbbh5c0c?=
 =?us-ascii?Q?NmGdV8i2lD0H7YYTLJhcTSQfs3I6TlEIsOHkDeE9laPz5crwTWEc4/SM1Hy+?=
 =?us-ascii?Q?2puqjci2OwmwzTh9dDPJn0k2kwlAwsQVMsCCmecQwDVPKA7G86It+e7YiCPP?=
 =?us-ascii?Q?Y+PaPssuDg=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f7432f8f-d5cd-4852-0596-08da54e8b28a
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6163.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:19:23.1975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: e9HWDp2xw2jfAEOreQ7Utd0mtncA1cPEyHgYr4/Zvq/+Qvz9x2gTUk2XQ0kAG49GxCtoE3LEdosGkamDxVixFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB2518
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

In the unified bridge model, FID classification mappings (e.g., {Port,
VID}->FID) and layer 3 egress VID classification mappings (i.e., {eRIF,
ePort}->VID) will need to be updated when a RIF is configured on top of
a FID. This requires the driver to be aware of all the {Port, VID} pairs
mapped to a FID.

To that end, extend the FID structure with a linked list of {Port, VID}
pairs. Add an entry to the list when a {Port, VID} is mapped to a FID
and remove it upon unmap.

Keep the list sorted by local port as it will be useful for {eRIF,
ePort}->VID mappings via REIV register in the future.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 63 +++++++++++++++++++
 1 file changed, 63 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 69c6576931b5..18a96db3ba29 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -22,6 +22,12 @@ struct mlxsw_sp_fid_core {
 	unsigned int *port_fid_mappings;
 };
 
+struct mlxsw_sp_fid_port_vid {
+	struct list_head list;
+	u16 local_port;
+	u16 vid;
+};
+
 struct mlxsw_sp_fid {
 	struct list_head list;
 	struct mlxsw_sp_rif *rif;
@@ -38,6 +44,7 @@ struct mlxsw_sp_fid {
 	int nve_ifindex;
 	u8 vni_valid:1,
 	   nve_flood_index_valid:1;
+	struct list_head port_vid_list; /* Ordered by local port. */
 };
 
 struct mlxsw_sp_fid_8021q {
@@ -567,6 +574,44 @@ static void mlxsw_sp_port_vlan_mode_trans(struct mlxsw_sp_port *mlxsw_sp_port)
 	}
 }
 
+static int
+mlxsw_sp_fid_port_vid_list_add(struct mlxsw_sp_fid *fid, u16 local_port,
+			       u16 vid)
+{
+	struct mlxsw_sp_fid_port_vid *port_vid, *tmp_port_vid;
+
+	port_vid = kzalloc(sizeof(*port_vid), GFP_KERNEL);
+	if (!port_vid)
+		return -ENOMEM;
+
+	port_vid->local_port = local_port;
+	port_vid->vid = vid;
+
+	list_for_each_entry(tmp_port_vid, &fid->port_vid_list, list) {
+		if (tmp_port_vid->local_port > local_port)
+			break;
+	}
+
+	list_add_tail(&port_vid->list, &tmp_port_vid->list);
+	return 0;
+}
+
+static void
+mlxsw_sp_fid_port_vid_list_del(struct mlxsw_sp_fid *fid, u16 local_port,
+			       u16 vid)
+{
+	struct mlxsw_sp_fid_port_vid *port_vid, *tmp;
+
+	list_for_each_entry_safe(port_vid, tmp, &fid->port_vid_list, list) {
+		if (port_vid->local_port != local_port || port_vid->vid != vid)
+			continue;
+
+		list_del(&port_vid->list);
+		kfree(port_vid);
+		return;
+	}
+}
+
 static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 					   struct mlxsw_sp_port *mlxsw_sp_port,
 					   u16 vid)
@@ -580,6 +625,11 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	if (err)
 		return err;
 
+	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
+					     vid);
+	if (err)
+		goto err_port_vid_list_add;
+
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port]++ == 0) {
 		err = mlxsw_sp_port_vp_mode_trans(mlxsw_sp_port);
 		if (err)
@@ -590,6 +640,8 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 
 err_port_vp_mode_trans:
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
+err_port_vid_list_add:
 	__mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
 				    mlxsw_sp_port->local_port, vid, false);
 	return err;
@@ -605,6 +657,7 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 1)
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	__mlxsw_sp_fid_port_vid_map(mlxsw_sp, fid->fid_index,
 				    mlxsw_sp_port->local_port, vid, false);
 }
@@ -792,6 +845,11 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 	u16 local_port = mlxsw_sp_port->local_port;
 	int err;
 
+	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
+					     vid);
+	if (err)
+		return err;
+
 	/* We only need to transition the port to virtual mode since
 	 * {Port, VID} => FID is done by the firmware upon RIF creation.
 	 */
@@ -805,6 +863,7 @@ static int mlxsw_sp_fid_rfid_port_vid_map(struct mlxsw_sp_fid *fid,
 
 err_port_vp_mode_trans:
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 	return err;
 }
 
@@ -818,6 +877,7 @@ mlxsw_sp_fid_rfid_port_vid_unmap(struct mlxsw_sp_fid *fid,
 	if (mlxsw_sp->fid_core->port_fid_mappings[local_port] == 1)
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
+	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 }
 
 static int mlxsw_sp_fid_rfid_vni_set(struct mlxsw_sp_fid *fid, __be32 vni)
@@ -982,6 +1042,8 @@ static struct mlxsw_sp_fid *mlxsw_sp_fid_get(struct mlxsw_sp *mlxsw_sp,
 	fid = kzalloc(fid_family->fid_size, GFP_KERNEL);
 	if (!fid)
 		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&fid->port_vid_list);
 	fid->fid_family = fid_family;
 
 	err = fid->fid_family->ops->index_alloc(fid, arg, &fid_index);
@@ -1029,6 +1091,7 @@ void mlxsw_sp_fid_put(struct mlxsw_sp_fid *fid)
 	fid->fid_family->ops->deconfigure(fid);
 	__clear_bit(fid->fid_index - fid_family->start_index,
 		    fid_family->fids_bitmap);
+	WARN_ON_ONCE(!list_empty(&fid->port_vid_list));
 	kfree(fid);
 }
 
-- 
2.36.1

