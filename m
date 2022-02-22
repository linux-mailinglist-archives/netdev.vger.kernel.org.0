Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC8974BFFF6
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 18:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiBVRSK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Feb 2022 12:18:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiBVRSK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Feb 2022 12:18:10 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2045.outbound.protection.outlook.com [40.107.244.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F35E10CF03
        for <netdev@vger.kernel.org>; Tue, 22 Feb 2022 09:17:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NgMgPpZya72vOE2RfrVs1/LLoLaBV331bJ+Mf25gQJR94N+qjc8TuO049pDuRStnfcGrlQy2ZSBX4G4MqrDt7PtN11r6sgeRzC5/55CxOXRQ4obTUT/3yfhalD4lEhC3YNAjUP2/0JkJ2Wxzc5HjcvQqvJhZJTazWtNLtXgmJnEg5kHYExen7Gfw5cSdzTy11SvbhePifLbLvck0XfskMdQNMjXI19hb+INILUHmQ5JQq/iaxlzg+8NK25gnfGBh+T/e2qvTQX2LfQDD15xywLjZUpuVYpQqFcbjHYxNqH/vpUN33+0+9rhEqAWPt2pADEpmwlHbHbCG0EXDWttI5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=s13cF1kgJtxUaLY2ciGFS74SIhfwgSCm5rYAVT885SQ=;
 b=muRj9XzpSsav9TFyKDeSZ9JBOUZuyKW9nzBHgxlQV25k6SG9gJqa3dc/Q5p8TxSl+E8/z2a9ddnZdFQKnde/QxzcODIBbLSJhnDagQXiufS2q/ULckCjKmD+v5jKd91s0o2wZqBJzE0puXroS/OVZVJjK22ndgrWG4Cfw8tEzfx44VYbfg0gWipjbJd4+vDkC50HYz9Znqt4hwvQhp5wIrwdno8eH/3gkfgszkWGtz4UGKywgsHcqpSv5a96/SZqBgeIlys1f1hvXAjKqRghJsIm5Aab9bSztDjw410lpvza6HVE+U4Qd362vxnq/fvhqFMYt3g1UitVaALnRRxhfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s13cF1kgJtxUaLY2ciGFS74SIhfwgSCm5rYAVT885SQ=;
 b=Vz2utmDg7gSKoWdL4pToHkAGCJ0q8W4LbiHtFzWB2TnKvtuK8WrazVptrFzKAw1zKPXekDmn1DMETD13PpZfRLh1SsMsa5c4HtP9GkF2rB1oKDa5i13odbT7cf6q/APVyvtblOtGl9eGvw7Ql4JJIRdCRsP5yuzQZZDZGXa8hIHdEjy7TVcccQyLOzy/YL0MITf6JkUKyI7tgl9Lrh71TF8bE81zwqKeT4SQhMALJTy2LCJ+nVbxLb+VTN7xvtPw9enbDT4aspwWhteZUD79weItCid6obo6jPTMElHFdpBVncihQh2+o0z+hGdLKTYTBYGsV1FPfu1/ldXGnttttQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12)
 by DM4PR12MB5214.namprd12.prod.outlook.com (2603:10b6:5:395::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.17; Tue, 22 Feb
 2022 17:17:43 +0000
Received: from DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581]) by DM6PR12MB4337.namprd12.prod.outlook.com
 ([fe80::95a1:8c7f:10ef:2581%7]) with mapi id 15.20.5017.022; Tue, 22 Feb 2022
 17:17:43 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, petrm@nvidia.com,
        jiri@nvidia.com, danieller@nvidia.com, vadimp@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH net-next 02/12] mlxsw: spectrum_span: Ignore VLAN entries not used by the bridge in mirroring
Date:   Tue, 22 Feb 2022 19:16:53 +0200
Message-Id: <20220222171703.499645-3-idosch@nvidia.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20220222171703.499645-1-idosch@nvidia.com>
References: <20220222171703.499645-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P190CA0010.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:802:2b::23) To DM6PR12MB4337.namprd12.prod.outlook.com
 (2603:10b6:5:2a9::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1aeca05f-7240-4dfc-33c5-08d9f6273cc2
X-MS-TrafficTypeDiagnostic: DM4PR12MB5214:EE_
X-Microsoft-Antispam-PRVS: <DM4PR12MB52144C4509B64122D47A602DB23B9@DM4PR12MB5214.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1StfS6PQr1Adf6zlPLm9rO85dVT6mDx29GmgVVXifLn2LJGnVNxvH1mLT5Lpmx+hwfWOL0Pn9tU5TrugGIaCci2nLZcoHddiHFAGqO1HFuGyoC2GAsvSlbwVRiJrLSsY3DMc2Pmp2QX5ngsemVBUmeVAokkYgOaMgZElgCRRVeHJKTCKxYsUzpFDZdQyOPbwFyu88p3INi9juevp8lLKsKRvJESlugNyP+wun+bkhwj/4uAK9hiieiRh+IFbrjsaR5ykQJrRJtvnvnGnjQAAG48IPeNF986ccpz6qRV/RzYtLFTK2RDLeCpHds9IjSgNIvqBJatBLImy9oh00iOpGVyhuzSv3kEojkBsJUHEMOJwItDYuqL6/6jR6zXo6vd9Pf5mbrheHRwLw1X6yPRAG9OgKXIUyT7OILCzmBnTY44MZuLElx6jwR4loDnfMvTLOfA7KM2k/ZslTr89E1RCdqoMnl7rMCrlnb3D2bUMskgJybeZIWqXs26EZcFYsfg3sb6dbRD/7lMhlT4h1lC8eCl46LQopQcaYtKtWYbPiBdg2c5XWYPN4lqpzhVXJ8lj+jISPAkS1T7+gcvD9OfIqyuZPrHdR2Y61pl6PRZa0YpuKD8fZwiC2/qO6FIjncuk/a22OJyKGLlAFGOZZs+Idg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4337.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(83380400001)(54906003)(6916009)(316002)(66556008)(2906002)(2616005)(5660300002)(1076003)(8676002)(66476007)(6506007)(36756003)(6512007)(6486002)(508600001)(38100700002)(8936002)(66946007)(86362001)(26005)(4326008)(186003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?3YdSQl0mcX2DR1wBMCyaaa6FPEN3JtVeMTYGdnuP8OuZI7EysFUTP79D7u41?=
 =?us-ascii?Q?S7nBw5ayG8Cnz5nvcfsDiSC6Y4T8uk72yBGXbMRB7LMx6aE8FYppS8hxy477?=
 =?us-ascii?Q?w/UTx5mPXaA7wFQyi8LZJDnWc53G9k8ci2yxz3lVVBSTjluCJcUpZ8kkVvr1?=
 =?us-ascii?Q?NG3L252TZ0osFEQ1AmVOm/+tWHFJFA7djochWpHdNS2Ndwcnv0rBqX4n8V35?=
 =?us-ascii?Q?o2uxZ8BKi+wVBNBzO5mPxdU2A+Fs51mDgOAJm+qBaN/kXGfVECuBeLCu9KdW?=
 =?us-ascii?Q?Yo6fRxp0apjmLMH4icRdjpTozxQeBaWF71w1imcy6qiifbk49EMD+4XTz13o?=
 =?us-ascii?Q?Sozy7tz4TYT9mR3A0ZTdH8qPO1H/Xx6iOfRYEUzm9JMEmjitIOQQQ6ZyJpwm?=
 =?us-ascii?Q?ivy7FE/QwcT7wiaVJoqATVhIc4/8fEHdxlVUk1fNT4cbYrG4Dsff7w89FFWB?=
 =?us-ascii?Q?rTvhsgGnQe3dXpZjd7Dvr9ADipz0j8HHP9engq3ZvdQ3JIWwGgvN2jJppYj3?=
 =?us-ascii?Q?lHg5CgDrPMuyEv+qN7UUcs48tm8m3pUL3vLgYpiGtO0BBmf0uq0mROQpvmnT?=
 =?us-ascii?Q?CUAB4U90acyluthaZOfNSFrkwU4hRJVGMh9npFNDLN3vIs1cYRswwpTitUQw?=
 =?us-ascii?Q?xogG1DzlSC9E5fsxGLMuDjn150S84NMMmGkbxpo6KxVCJimIvBruwlJiIJDy?=
 =?us-ascii?Q?QS+VAL18HqsVLqtDAyRG1KFHp1XXdSz0c77VM2CkafaC21xMi36+JnKsn1dM?=
 =?us-ascii?Q?dsFWWWVW3Tfz0/pug7DvAi1xbgFkGu59nWQdlskEtm4rNwatNYfJ3H/f9c1S?=
 =?us-ascii?Q?2KGiNX0IwDyhRmLEQC1icUKjsVwQGeP8DzMtemJVqwr9Fy2OZ6ucoat1Zv48?=
 =?us-ascii?Q?7PiilxlgfnsNq5hgkVxnc1HgzRsxLgLUpHttMQ8u2ruwRJQ6hHYUQUViM3Hw?=
 =?us-ascii?Q?3MOGmsDoEnbzdkmkScIH3NM0Lw/S5aOt/Yj4oyakA4GyUhxq/0kBnf2l3cmz?=
 =?us-ascii?Q?1IqIzb6PJytOL6ztuegtYMy8k8uB5PZTUGe1GADDfkr1coSqNEuUwHFenE3c?=
 =?us-ascii?Q?rfWYJ/TCnn6i1NACR6QndSSD7ZkBGXE7mV7TXmfkWnuaEON3HPHkpOEFwvP6?=
 =?us-ascii?Q?Da5uwVXd2MxCXCOzg4a1i66Q0kT/AnVFtoOcF5IUKmV5jrZ9FGCLYZE5foCE?=
 =?us-ascii?Q?yHBsYx5nVbcoRbgl2M+5xTKl33ncWSR6iI1Ih/eDg8wBOMf1ce0OSKUHaw4a?=
 =?us-ascii?Q?oY+RnTbtZl2ZwVVcz3ZHB3pe7bgwvxFQ3if/j6JEKS4NZV/dObxLsPQcttPI?=
 =?us-ascii?Q?eXMHYJjD3VZc8H/9nHFw4nQdzDxD6tV2vrxQEvThlRXvhLsJ940AHi6izVTD?=
 =?us-ascii?Q?k9FcQld8ANVCuLeZ51sVin8sWcl9H89cluQO/o3TP+UFpTHANFwS+Q9bAx2G?=
 =?us-ascii?Q?4hK+eDKgPDhOnjRQzPrvuzRbKobExtSCkPI8dXRBjUcg21ffIwqcUtdHg9Ne?=
 =?us-ascii?Q?OXxJGIXRzi7e8VJnT/vM1XXvSkPaHiaEJFPvsdcd8TUqIcUyjPQM8UeRUvvY?=
 =?us-ascii?Q?TkMhqWr4TVsgeP3I62jmHO+BnXzL6If0gbwYXQJ6XsjFo1oWZpzVvwfEAGit?=
 =?us-ascii?Q?B8zU4bbbyTu7iAJJfendV0k=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1aeca05f-7240-4dfc-33c5-08d9f6273cc2
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4337.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Feb 2022 17:17:43.4559
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xyMBHVv7KgzJojixYUAd9s29EquG75B33lgRXl6N/iELsFkpFE0NNBX5CDv8WqkGQFFXg/iInetCfEm02ERz1Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5214
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Only VLAN entries installed on the bridge device itself should be
considered when checking whether a packet with a specific VLAN can be
mirrored via a bridge device. VLAN entries only used to keep context
(i.e., entries with 'BRIDGE_VLAN_INFO_BRENTRY' unset) should be ignored.

Fix this by preventing mirroring when the VLAN entry does not have the
'BRIDGE_VLAN_INFO_BRENTRY' flag set.

Fixes: ddaff5047003 ("mlxsw: spectrum: remove guards against !BRIDGE_VLAN_INFO_BRENTRY")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
---
Cc: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index 5459490c7790..b73466470f75 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -269,7 +269,8 @@ mlxsw_sp_span_entry_bridge_8021q(const struct net_device *br_dev,
 
 	if (!vid && WARN_ON(br_vlan_get_pvid(br_dev, &vid)))
 		return NULL;
-	if (!vid || br_vlan_get_info(br_dev, vid, &vinfo))
+	if (!vid || br_vlan_get_info(br_dev, vid, &vinfo) ||
+	    !(vinfo.flags & BRIDGE_VLAN_INFO_BRENTRY))
 		return NULL;
 
 	edev = br_fdb_find_port(br_dev, dmac, vid);
-- 
2.33.1

