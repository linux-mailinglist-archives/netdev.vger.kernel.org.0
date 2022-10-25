Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A6A260C97C
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiJYKJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbiJYKIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:08:22 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA89412AFF
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C+XlKFEfzjTG19u+9lyHcDBNlTiO2pdCrTEwLEQkHYcJHCsh0HdTlK/KKrTpBNOVee7toZRhaf2DulMsWnUdgkwplgq2288XM39tCA6w83AqnkEGrHevjQ44+KtA5VlmQK//pwxZPWj5djzi17KhbEmDpnBDXW51W/G1ukgvesstuf+EeWlmlwVmaLi79NAoESzD2oGdNFs5N1k8OwP9OeKDzrEXIeQ+GXvmzhFSN70mYae4e8vDlq9MB+BDN6lMjlWTcuUwkUXK7JmBCi2DigbYEmnomuq/M79azrVJD3jFjr7GQAqBiJvQAAm35FM/v8oNEq7nBatjai6PiqMHpA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y0HNreRujqnIhRStpYyJNFXkwgCdOuuXEmSmG0x12Sc=;
 b=e00ONZpRzYWA32oMkpq++hMDUMT2d8Df4VI/6R1CEZ5vDC1hKazjqMX03R8XMR5wQguWXRtCKZI1onanecnDz29xS1ZCe/Pz3vncEDxfighrkYXK1NxauXfg4lI0k6Qo0ZayCqEp1f42Sezcpr1OPKnD3ouWBrIJSbq7DszXXLvs8ldoupJdGGSEZaIOE0DoA83Rovy97sTKdmzCA/xJd/wLyVfdULoa+jOEEglePQQUAR8aFx189AQRw1EZeRySufEd0HlFwuQM0qyHiHHn3w6V028YIlqNRdtsXEfSOGt1B5n4MdNN8oGyGZ9zb56yZiyask0I8lj97wPlQ+LxXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y0HNreRujqnIhRStpYyJNFXkwgCdOuuXEmSmG0x12Sc=;
 b=hh1BpaZijgRGFGwG6am4tlh3cHzAYbcCHR2fEbg6mgRkJmMZMH1KOT+m5qno2Fq/8YjMzknRYhR8hL2wrgNo3jrMtbTam4innUb76EAqxWywncndg5u9WBY9rPcY50Shrd/wIHmksXkOx2vbj+2j9VHFCIXoQjG4f4vCdNjJdAvwo1tH/VZRHgSUBEgbpIg8FVdFX9Lmw2ExmhLF3cQYJH2yDPH4egRupzt7EFOck5RH3K7iaGTJyyr2+JcCVy4nO1I1oW8sOwBDw6Q9xWA9h01WXLPjsN01fwZ6tTQ0+TpWsNFqy/PnjBYNT07DDUJXrUgTc8YBx/gkdVOR1aB4KQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:50 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:50 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 09/16] mlxsw: spectrum_switchdev: Prepare for locked FDB notifications
Date:   Tue, 25 Oct 2022 13:00:17 +0300
Message-Id: <20221025100024.1287157-10-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR06CA0127.eurprd06.prod.outlook.com
 (2603:10a6:803:a0::20) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: b6b7d88e-9fab-4e59-b6e6-08dab66fefc1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: KfI6CBsdn9+h7N6qEk3r4oJZE4XerE1Qt/k+YR/eLYWlFglSH79mxSBVqJDVQHgPhFj0rApeObPEthx28h6ZRuXmod/VeGEIPdWW1S0dUPX8V1GZwVjnNGE/pS+nkgkBEhYUJfELr8p9dMakfJUlY1ndtBi1X95ImF1TK7HPKOkrv7Wv4awZz8W244IwFO6G+Tc2HTHi/YO7BU+ajCsbZmTqY0zb67brEoHmygdW+4iH05i63A+nugk4LOLDl7woFn1g4ZxFcizQSMTp7Cgb07A72dMmfm65+LbGHjDO4bnMVJXvUTmzx3nIFyHR/AASV3PYRQA3MB7y8WrS7DKWQ/C8XMjr9yxLdmk3DI0jHrk+VoA4fBYf+MkvTMFfl6ftmzwO9sbw5YRoOenRFriK296vfXRuHR/xWfQwZNIQo7XhAnojIN20SvLO4x+lSRDmSfMgDT86FOdHfCPKoaWG5h2MuL/h/54MrvpVxY1w7qqpASg8dFFy3CSVxld27ZPKbtQYRqiYiz6Em8Gk1M9ckgYnAzqsTCu0dpXdJRUEshp30X/HJJ1uRlgtywtOJtVlKgCOEGWG3iexBv6zxDq25ZzH5SticN/Tgkzt+lg6kv0wFAZ+eIWhHuc+FoAlFcgkIhHlZZu3evRyqDKVf6ezhNJY+JUj1ix1xKz4Dhpn0YZ/ukKwFrnmtRPOOIT/sxDa/8fULLxggh8cSWQkFGrL9g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(6666004)(107886003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?InTCaV9oBaNuOFD+/6aw9r5ita+uk9ZIYkbGhMFANFqF/ta+Pq3/18zTjmt/?=
 =?us-ascii?Q?aimhm2rTGBxrBioA3l0OPuvddXZhiBFbMlavhCXUBeLjumem9KRCNWduoDcq?=
 =?us-ascii?Q?vfSGkXyROTALtp/aINTuu0rey5wv6/aSTDzOKF0YxS8ZBcLyC/yQLinQS353?=
 =?us-ascii?Q?32hokqjhPWyXgNoIAHnD8n5JglyAFFW0SBV1QFCwzDoa91gP+RF2n8Aa9xoV?=
 =?us-ascii?Q?POPynqHVcb+EwEjgi+Y2v8Br0S7HAhE16Rc6igN2KxJsNm90ydQ0pr555p4s?=
 =?us-ascii?Q?y9KQ47QZu756x6mLBGK+bW2OX2/wrgOFOMWQpXnvpG6BhQWVp8IOXW3Ksfr2?=
 =?us-ascii?Q?7ax+4svb+vGdxOJ7ppzFeL3kbV6tglETd7MUv7CyvhKsjXeBwQL5ulHE06nN?=
 =?us-ascii?Q?H4vr2EX86GDf3n8NRqiVbUlC0qwj4TVrMoXmubNdTUeLp2zDQNAvIKewhwwP?=
 =?us-ascii?Q?SZyS0ebCQ3Pj9ch0ZZKm9SvL8Q1hThpa63Y8BagOl+0FlAjvsr4nI3bWHgad?=
 =?us-ascii?Q?0B3WK9g5+STlL0cAhkm+7SStCYNI82jxLUX14rmCAASQNc6jC0b3lJn5nGgy?=
 =?us-ascii?Q?kSDl00UUzUX7jia9QgRFUjamzG9iKl55wyNceBKjfHcyyiyByrUNLdlpU/4o?=
 =?us-ascii?Q?njuV27yJ90OhIMgec8LEN5YNpSCIUGnr6OPfbaMJHHcV8H4QoKgu4IhvSQew?=
 =?us-ascii?Q?sZXiM/Wt3Cl4NoWCOWFX/1oudqGqJbhvSJk6vIk9X3CNRuo2HBX1rO0kL4f6?=
 =?us-ascii?Q?eTuatfVNWMaVfBhNZJk5w6eeLhBOS5gzw5woEKyV7dRxzn/0AptbKdi5y3jJ?=
 =?us-ascii?Q?lD6swTtFXwqlbYyk5vRay/Oq6u3ozFCWQwppI1fEtuMkviP1N5anMEd1Hlvg?=
 =?us-ascii?Q?tXGYxtPipaS8WbdTSwKRa5wvgGG+f4nasTCOAWULrImJhW2BxE4kqkgxD8Yl?=
 =?us-ascii?Q?2K9Qy6fvH9GCTWtjjLLyQV0MP7ZV/ddaheP8byAjLS1KrvTkfhGj+8hU2PBw?=
 =?us-ascii?Q?0vQFu1CGp63PHgXR9B6NDm7GU1K0J1xPRgl4AqIMcpqBUIJSd6gVVp84Btap?=
 =?us-ascii?Q?X0/R5MPE3TgP+AppYxpgVb0mrN1Rw4GW632V32w3ggtSst04zXW6WNGupsHf?=
 =?us-ascii?Q?Y0rGSTbbb5Fe6v1JvGpVlOysPl1udkAhSeJ5FydFCb9t8LXlqJ2OfVLguRyz?=
 =?us-ascii?Q?ddercBpGeSj8mrZ/tuEuaieFTurQdn0YCF/M3wLaoiQJ7CA0J6MNBhedyHis?=
 =?us-ascii?Q?Lta3AU1lMM02s1n++u9AT29IZvy2CVsceDSBs4YrOf2K99iIHsiCk5FZbEzh?=
 =?us-ascii?Q?FxqEP2mlpuK7/FNzCwPbBq7i7xTHwj9ACMelfRcMJ6ox73X97JHvtMLmYF0L?=
 =?us-ascii?Q?sujhtSHCpsjQbfF/jorOuaKfKQ30DHZReUjCn+ZX/UoHBN/9zPf7NBPID1X0?=
 =?us-ascii?Q?8yT9K7h3HJNKAKy3/Ce2UBtLmkVt/1f4USgW/BMZV1bjwXGaL9PxqT2YWM5B?=
 =?us-ascii?Q?hRW1oN71sqQlqNqu/dz0x/H8lvAcWTV3bZXsZ4xb29aVlgBsq+BQFg510BIC?=
 =?us-ascii?Q?75ECVMEaIzKnwcLGT6znNPqcIc+XK5y82Vudv8Vt?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6b7d88e-9fab-4e59-b6e6-08dab66fefc1
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:50.7515
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YdkTGBZ9B+0BMOuixsLIdwqTRBqkvDm+5LvYIWKjUPq+oThzN8kO8DldMlkBMgQf12DtWXITo3zRgEkXeJIn5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB4270
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Subsequent patches will need to report locked FDB entries to the bridge
driver. Prepare for that by adding a 'locked' argument to
mlxsw_sp_fdb_call_notifiers() according to which the 'locked' bit is set
in the FDB notification info. For now, always pass 'false'.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../mellanox/mlxsw/spectrum_switchdev.c       | 21 ++++++++++++-------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 4efccd942fb8..0fbefa43f9b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2888,13 +2888,14 @@ static void mlxsw_sp_fdb_nve_call_notifiers(struct net_device *dev,
 static void
 mlxsw_sp_fdb_call_notifiers(enum switchdev_notifier_type type,
 			    const char *mac, u16 vid,
-			    struct net_device *dev, bool offloaded)
+			    struct net_device *dev, bool offloaded, bool locked)
 {
 	struct switchdev_notifier_fdb_info info = {};
 
 	info.addr = mac;
 	info.vid = vid;
 	info.offloaded = offloaded;
+	info.locked = locked;
 	call_switchdev_notifiers(type, dev, &info.info, NULL);
 }
 
@@ -2952,7 +2953,8 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	if (!do_notification)
 		return;
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE : SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding,
+				    false);
 
 	return;
 
@@ -3015,7 +3017,8 @@ static void mlxsw_sp_fdb_notify_mac_lag_process(struct mlxsw_sp *mlxsw_sp,
 	if (!do_notification)
 		return;
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE : SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, bridge_port->dev, adding,
+				    false);
 
 	return;
 
@@ -3122,7 +3125,7 @@ static void mlxsw_sp_fdb_notify_mac_uc_tunnel_process(struct mlxsw_sp *mlxsw_sp,
 
 	type = adding ? SWITCHDEV_FDB_ADD_TO_BRIDGE :
 			SWITCHDEV_FDB_DEL_TO_BRIDGE;
-	mlxsw_sp_fdb_call_notifiers(type, mac, vid, nve_dev, adding);
+	mlxsw_sp_fdb_call_notifiers(type, mac, vid, nve_dev, adding, false);
 
 	mlxsw_sp_fid_put(fid);
 
@@ -3264,7 +3267,7 @@ mlxsw_sp_switchdev_bridge_vxlan_fdb_event(struct mlxsw_sp *mlxsw_sp,
 					 &vxlan_fdb_info.info, NULL);
 		mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
 					    vxlan_fdb_info.eth_addr,
-					    fdb_info->vid, dev, true);
+					    fdb_info->vid, dev, true, false);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		err = mlxsw_sp_port_fdb_tunnel_uc_op(mlxsw_sp,
@@ -3359,7 +3362,7 @@ static void mlxsw_sp_switchdev_bridge_fdb_event_work(struct work_struct *work)
 			break;
 		mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
 					    fdb_info->addr,
-					    fdb_info->vid, dev, true);
+					    fdb_info->vid, dev, true, false);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_DEVICE:
 		fdb_info = &switchdev_work->fdb_info;
@@ -3443,7 +3446,8 @@ mlxsw_sp_switchdev_vxlan_fdb_add(struct mlxsw_sp *mlxsw_sp,
 	call_switchdev_notifiers(SWITCHDEV_VXLAN_FDB_OFFLOADED, dev,
 				 &vxlan_fdb_info->info, NULL);
 	mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				    vxlan_fdb_info->eth_addr, vid, dev, true);
+				    vxlan_fdb_info->eth_addr, vid, dev, true,
+				    false);
 
 	mlxsw_sp_fid_put(fid);
 
@@ -3493,7 +3497,8 @@ mlxsw_sp_switchdev_vxlan_fdb_del(struct mlxsw_sp *mlxsw_sp,
 				       false, false);
 	vid = bridge_device->ops->fid_vid(bridge_device, fid);
 	mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_OFFLOADED,
-				    vxlan_fdb_info->eth_addr, vid, dev, false);
+				    vxlan_fdb_info->eth_addr, vid, dev, false,
+				    false);
 
 	mlxsw_sp_fid_put(fid);
 }
-- 
2.37.3

