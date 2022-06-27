Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9AA155CA05
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 14:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230432AbiF0HHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 03:07:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiF0HHg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 03:07:36 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2040.outbound.protection.outlook.com [40.107.94.40])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F5E05F56
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 00:07:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XChaQLQz9CqvLrTPXvgEPz9RXvSGbjY6NmPSn4y0FbfGEsSL9vc6J/CybZAUTMcnzWpKVZODmR1vIM4/oIiECv+y0QaNSW51f26x94thZDN3E6WoWqZZ7emS/KqEUAwf05j8cnDSLXKZ9+e6SIcANGrqJ5lVfFeZm4G4sgKiMp72p0E5kUCF/YWWs8cPvr7tojyqs+/nHiOZrCxCram2FK3bT9uHN6xywacyE0WYENMXQYWdF/nqeOCnYh1GVXZv1YhhkVTCnBiQNWBqng22rB2jRKHnDur3hEG+ZChskEpyvaeyqmH6vvQDuSV5SJvtlMyl3B31Fi/yz5r0Ocy8Nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NTOJqNv642XUSoSY5/MgmUaNvMCxSsenelHkxf99hfs=;
 b=FMFVCQtL89iC1ka7MMJkjcUGe7A/miNjHVbxtz7q0ZC0Erb+s324krTBTb7a/xg3IGLzMDz6dCho2dZcKbLbeN2aIiCYutIs8uGT+E7OJynpY4Z5ixHC8TgKen8hwPAfFA3UBvFGSVKYFG3As3TWCB3hLiVBaJnof3L7wz+xh25DWNCWtMt75ZTq/LKkSk6IR9lV5aidZ/tMwd2lXREI3+mCW93xO2cRuJx9j1IU5fQ6RAnv10tg42cTXGFb5smehKtTD1yhWzD+L2AwKUODQm5IkZlISYWBGa/7WVplms6UNE31+Rw+pmMbhfKnbnB6U8RwQhaDS4/SnADfwHzsjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NTOJqNv642XUSoSY5/MgmUaNvMCxSsenelHkxf99hfs=;
 b=B4nVITYhecZxAddpoVH/kKFdN/hfz1m0ivRdPVr/DGbswaSB+KcGUEonSYNB2dPT+274X3u9A34SYwOief7FufQYi98aZ0Yp0kNCRAFVEgP85agRIqBg1CbYVdmghe/JQAZuFCUecqWpRxDvc4MccJnUeiTo6ROOqNARbzXR2LcJgqX8r37NT5qoqrrtTIKA4OtaMJhpgXvVgpCR6hohExjoLktWLOy7Fv5AuNzMwpJxuKPjqE8aiLkOetGQpjAU3S1vwa8n8ImX65dR9S/gWnZaJHWhzDZ6nHjVsClcHy///kWcyr/ebKDpmGBYYdsR17LY6SzNCZCECzg9Na7WMw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by SJ0PR12MB5439.namprd12.prod.outlook.com (2603:10b6:a03:3ae::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.15; Mon, 27 Jun
 2022 07:07:34 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::611c:e609:d343:aa34%5]) with mapi id 15.20.5373.018; Mon, 27 Jun 2022
 07:07:34 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, petrm@nvidia.com, amcohen@nvidia.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [PATCH net-next 06/13] mlxsw: spectrum_fid: Configure egress VID classification for multicast
Date:   Mon, 27 Jun 2022 10:06:14 +0300
Message-Id: <20220627070621.648499-7-idosch@nvidia.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627070621.648499-1-idosch@nvidia.com>
References: <20220627070621.648499-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0220.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:33a::18) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b38d663d-b12d-4c8d-09ab-08da580bb5ba
X-MS-TrafficTypeDiagnostic: SJ0PR12MB5439:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9nAXXigQRVYQW8zJsUMoV4K/nWIX6Jt+M2qYslzR1HkUHGld60HomUaMDa38gLuw/w7Rukiw/Iu/ch5nTfEjebL+cwNA6c4bxfcytcTw5VDJcPxBPT6JoB59cD7cRKJeUSqjwMP5Ie8CMhyX8bg5/W/lsenqlUrdti/LyioTzFa3xQzM8RQZvYbq8p6Dz1fVvYxQIm6KviEio5tZWQFjwWqsy+1W1+YgTEZ+IikEQuJLrSLMZqfZa6NvL4GcyHy9CIVmgdmoEhbDCgDEmeBWe2rVqkRtm8LeklUKR6+xCGhQwIjpNlCOJROiPmGyIsAlMIH9hKYPv7BTKoAwljlqgsZqZCZMvrRl1zluu8Ew13rF52pNQVQTdkiQBSchldu7grWpE2gDMk0oOoiLd5X6EdG6Lg/7bcCTmCE9+S+chI6XicSmygqXKJXgtnrzSEdWnUZ+sMoJtCsPcrRE413OWbIE5iU9i/2G83UFGQ5vALusU9a03EI8ieVTdvllnQq/1Q5ECoJKXRY9rg7TkiPDlkI4WUSM7Dxm6ysUUAhlL8ZdbyVZJbaHlNmcclsAbsdXDX9jo5PVpBHZps9Pe7JbuQZURfYBwyJrgE39rqesUV2pXE2ObRYH2/0inu2OYvPOkJRN+D5mh8CMCAvOYJaV+SRzhSeIM5aVku1TmEz4S+wC036+wK2YeQulyaQEsFgCtNTz7i2pPX/x+83lIJ27n5/YZeu+brGLZHiEOsDyEVQbBGKNPCs+sGCZd2FrE2ov
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(376002)(346002)(136003)(39860400002)(366004)(6512007)(2616005)(36756003)(6666004)(6916009)(66556008)(316002)(107886003)(1076003)(186003)(66946007)(41300700001)(6506007)(2906002)(38100700002)(66476007)(6486002)(8936002)(478600001)(4326008)(86362001)(8676002)(83380400001)(26005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?8ECiRPKwUx0aCczjPWC/ijeY1O0xE4iJ5/keVoBuBv+rzseVUMmeZESuQJRa?=
 =?us-ascii?Q?zcFByu3a92ZnJXex6QX+shTNuTXgOUf7hSJbEvRaB5ljjz0khL7SfXncWC06?=
 =?us-ascii?Q?XX82zpLGO4U9lDztyY+qkZQmCAjKUFbBIdq7simWqEYvibqvpvkG0jcceJ60?=
 =?us-ascii?Q?UCHhm5diY5zd7RXGpi/jfKlKZ+wPfo7aaKiRaN0YU0/jW8lUtPHo+XgKSRNl?=
 =?us-ascii?Q?XavYLTD5F/57nd+SGn+NVbqZ1Lm0ySWgZ1Vr5zki9wS2Pt+N3OsFylXOlvNw?=
 =?us-ascii?Q?QjjimS+w8Os1NUIFm4iBOgcPfV5mVQvNtg43YhXOxgqlddI+QI8QFs3e89B/?=
 =?us-ascii?Q?SbnV6+aYbWUP0zaxefbrBFcQ0yblOG5jAoaI3XZSs+8THLaykYCExjVY+CoL?=
 =?us-ascii?Q?L8KwheUOdY5rE7F828snMh6vFaVM4NSZv3iwbyjAQ2dpSoZA6As63BMVUsq7?=
 =?us-ascii?Q?g07ahFnd0od+ftbiT2uuJm5IsP2UE0/1cdXQrHiQidCTL+sij/Dy/wUpblc8?=
 =?us-ascii?Q?QUJqcgU0WnN1P3BfAu0kfBljryT4zLIJFrsfdv4oXamYO9GJWIixNS1js1Tt?=
 =?us-ascii?Q?6yaXCd46rJmE5F4p8Lk/k94yqSC12xGH1Xu1+PfpuxIEbDWSbVTaSJsSeFQa?=
 =?us-ascii?Q?pgS3cz+rr3Cf0prh5UIy6sae3W/9xPy380ypyuuJl0ZSll6GjNzPrVB5hENK?=
 =?us-ascii?Q?TtIkfPmEKgZrud9eoyPUUIxyhjFvD8w2QjqN5Ptmn68QUCKxWJFPZEssvE7R?=
 =?us-ascii?Q?zg2pZ+cMKNoTBDe447ovwmoXVug/1XmL7sJu8DQBh8cKg/w1mtNZqUCGTOQT?=
 =?us-ascii?Q?wSjfnA5OLo7bfCRY44w2uxrAx1DB7vEINipQpYAO8pofWa9jJcuTQ6IPnu4j?=
 =?us-ascii?Q?Q7Qx8zZG3lwbcrInXwKr3C8uNaHlg033Z+08brkG2demCDfoRlLElSZgoZ6D?=
 =?us-ascii?Q?kzN9TAd1/VZPJqjutt0+bH3PsmnlB7Z2UyIidT1kCeICN6IzM93D4XaQEzbM?=
 =?us-ascii?Q?tD0L/UX73iPspbrO5H5zuKVQCqO1qT/xelQqO5y7LozhcAcUI1avC5z9Vl9/?=
 =?us-ascii?Q?R3DNRQh6gkd4/bk+tpVYrYtLmgKNTJxWoC30GPI906POqQbR+1K/B+bRimvV?=
 =?us-ascii?Q?nCIVB7uFU+XxosVqVa90M2o44aDyZQyeXWTCgIArYF3NMlSD2EiM0Gkg/XQS?=
 =?us-ascii?Q?Xd4d42cnyaUXATw1IcoMxTRu9fsn/cQ99M1WUVbK2TI62dXftxrKk5Ek7tFq?=
 =?us-ascii?Q?pQanoW52xtzkfK30aHXwXG/tmNFsN99uZKIlXfI8USakM1t/0M6JLUwzk7Kf?=
 =?us-ascii?Q?mc7+D1XXvx249X3+jct3zkUtkc8O6RtNtMM/nlorVBkmEmB26c7Q1ekbY5ho?=
 =?us-ascii?Q?g3K3ew29aIwT4KlTsZv9OwC15/qD7l/rp2VYMYbb2CIt/bOdrs3vvuOdhKRa?=
 =?us-ascii?Q?KY9tTFTObQB4uMJbh5byGjomVllpnKK+9lQfXUmDALE3ytN/mDOcCnqs80Lp?=
 =?us-ascii?Q?N9nz5s7leu/uOGBVEQN5Iv+r24sl/lMF7Zp8kxKQVOVWcaq4dCyq+6tbj8WZ?=
 =?us-ascii?Q?M/+Fr9XnO5NxxWZEYThOBbQ7AZn6ZPyUioXKP+RG?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b38d663d-b12d-4c8d-09ab-08da580bb5ba
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jun 2022 07:07:34.6536
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WPbTnkI4Kj5SUvXCN2FQBJ494DH623vzx2wOwqviZmHcK9piJuDwcC2suW3BlZIy763Fjy3IaaSKMAg8QO/qRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5439
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

The device includes two main tables to support layer 2 multicast (i.e.,
MDB and flooding). These are the PGT (Port Group Table) table and the MPE
(Multicast Port Egress) table.
- PGT is {MID -> (bitmap of local_port, SPME index)}
- MPE is {(Local port, SMPE index) -> eVID}

In the legacy model, software did not interact with MPE table as it was
completely hidden in firmware. In the new model, software needs to
populate the table itself in order to map from {Local port, SMPE} to an
egress VID. This is done using the SMPE register.

Configure SMPE register when a {Local port, VID} are mapped/unmapped to a
802.1d and 802.1q emulated FIDs. The MPE table is not relevant for rFIDs as
firmware handles their flooding.

Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_fid.c    | 23 +++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
index 3335d744f870..a82612a894eb 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_fid.c
@@ -622,6 +622,18 @@ mlxsw_sp_fid_port_vid_list_del(struct mlxsw_sp_fid *fid, u16 local_port,
 	}
 }
 
+static int
+mlxsw_sp_fid_mpe_table_map(const struct mlxsw_sp_fid *fid, u16 local_port,
+			   u16 vid, bool valid)
+{
+	struct mlxsw_sp *mlxsw_sp = fid->fid_family->mlxsw_sp;
+	char smpe_pl[MLXSW_REG_SMPE_LEN];
+
+	mlxsw_reg_smpe_pack(smpe_pl, local_port, fid->fid_index,
+			    valid ? vid : 0);
+	return mlxsw_reg_write(mlxsw_sp->core, MLXSW_REG(smpe), smpe_pl);
+}
+
 static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 					   struct mlxsw_sp_port *mlxsw_sp_port,
 					   u16 vid)
@@ -635,6 +647,12 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	if (err)
 		return err;
 
+	if (fid->fid_family->mlxsw_sp->ubridge) {
+		err = mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, true);
+		if (err)
+			goto err_mpe_table_map;
+	}
+
 	err = mlxsw_sp_fid_port_vid_list_add(fid, mlxsw_sp_port->local_port,
 					     vid);
 	if (err)
@@ -652,6 +670,9 @@ static int mlxsw_sp_fid_8021d_port_vid_map(struct mlxsw_sp_fid *fid,
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
 err_port_vid_list_add:
+	if (fid->fid_family->mlxsw_sp->ubridge)
+		mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, false);
+err_mpe_table_map:
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 	return err;
 }
@@ -667,6 +688,8 @@ mlxsw_sp_fid_8021d_port_vid_unmap(struct mlxsw_sp_fid *fid,
 		mlxsw_sp_port_vlan_mode_trans(mlxsw_sp_port);
 	mlxsw_sp->fid_core->port_fid_mappings[local_port]--;
 	mlxsw_sp_fid_port_vid_list_del(fid, mlxsw_sp_port->local_port, vid);
+	if (fid->fid_family->mlxsw_sp->ubridge)
+		mlxsw_sp_fid_mpe_table_map(fid, local_port, vid, false);
 	__mlxsw_sp_fid_port_vid_map(fid, mlxsw_sp_port->local_port, vid, false);
 }
 
-- 
2.36.1

