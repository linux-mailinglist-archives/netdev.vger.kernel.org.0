Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E81C60C97B
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231562AbiJYKJb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:09:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232062AbiJYKIZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:08:25 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2078.outbound.protection.outlook.com [40.107.244.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319D74E403
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:02:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEsVoOuax0RgDLNkrxoASSCSP1EYlTasPGLN3Wk8a5ZPq26du1z01ugSHYvP+slg9W5l87VNWo95d27ttp1OdI49BF7mZmT9bD/ZYfG4cq5T//KnwiBocx02kLuvenMtPsMJG4XtHpGxaH9bfurSyEhphlV1mGop8IufbJHXpF3HkyyZo1txtwYLrZk4Fj6Fo/p+QB7Ed4bdXZdfU9aEI4ClZpKHwaIIxmnUXTi9nsadug4z8Fgd9B1mtz09o2XSaHe4s9RhwwwaYX+MziiyA8whY7pEHI8Ov8HB3EFX+IVaj+D26YeazwMkJEWc96AKsXF+lSDmFTvv+Ybjojh4cg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8vUwHrhQnDNyFzSYYG3UuSgScLhX5KZRJthFwFuyojU=;
 b=MtofI+zvqVNF9BdEP8wNOxHEjKGESIZvlIr/HPyYTLrHZaGBGlm5rllaRLBTSP7ce11JF2rYL0//wNyUjLV1zh5Y+GKG3lhbxseQXpI12mX9M+geSXBTwa4Y6MvpZrZj8ydq4VrUs27b5staGp/01iRDwjSqaL0baQJkySRvyo0IjZBGGAuvpvOBIDMtE2v6/zegLwrALOhCIajBIG5yqFlLd4bPbe9g6h8Ng5IC11heot87f/JymV2+/H10Juj9wYxq6b3IuR5cz6VSBkIlEV3dwFwxb+dEQ0e8ZJmILgq33Bg6cR8riE5HnIMIO2hjSIWuRpBxBm1kWk/df6QaHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8vUwHrhQnDNyFzSYYG3UuSgScLhX5KZRJthFwFuyojU=;
 b=SDiqFrdtdtTF5X8iUsB5FgJg7pm64zCiv2w3UhJvkzoQPUSy43pa8ZRLrx1mBYSJ+0mCE6vT78U+RUKwka6AAyr/1K/ty2JebYUI3todZjVbRxyO6ZG8gA97LqUVBVTOtD+8t0Yx93H4EYTjt0W3JjhWAhlkP/WJQ6q7Gnp0p4dPOcj9N4O/ZKhOlib2zHzaOBCf9kKDQJ1QsV5IPykp++GQS31DyuzYQqQX8wsTzP7002XDjCKYLgqlvXCwmml1U1KahHSk8wP+GJ/+EvPnsVRMwEhggKDTRdbv9hPS6VE1CdkbrsVAyqAdXrcWCqxoFjBiuEAsGwzd8wl9Inh0sQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by MN2PR12MB4270.namprd12.prod.outlook.com (2603:10b6:208:1d9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:58 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:58 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 10/16] mlxsw: spectrum_switchdev: Add support for locked FDB notifications
Date:   Tue, 25 Oct 2022 13:00:18 +0300
Message-Id: <20221025100024.1287157-11-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1PR08CA0158.eurprd08.prod.outlook.com
 (2603:10a6:800:d1::12) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|MN2PR12MB4270:EE_
X-MS-Office365-Filtering-Correlation-Id: 4cbb523e-aef0-4167-faf6-08dab66ff40e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I0iVLBy99CxrVUJAh5wVQ1CwKEFM8/xHrqLb1QN85NCGBHn/9ImCmXVR09XP01tEhADwmpxYU3O0obu4exDWL+d+VEC9vBnWLcmTYVk6WuZBaJ2ZqhpLXNR4u/tIRe0eiWpQizY+0GN8d9VHTwTOkYAmWiwr+pOnoTFwlDB//9duGgFLoSUmcm8PzRdTTValQgRl4EFIDLyYEaDF2okK76CSo7XGY1EFvUSDoqGLjSn8wQRuJypwd7yH1VcvxjQ/IzQIFxJRlB5F4oi51SfmDGbN63LQNkQYVC/s+b1ot0xoayaLldEzzE8B4IUFjaywEQRHXjJqGZbrFAx0aTUyDzbnodRgZ+xOGnumSct5iGi2W9xmEkG2+Q9kuiVuzkyMmF6Ve74ZJAhVccqf6kIJfCGPHHOzYuMe31F32OXD2rgrxMXo9FBX07iIuq8wnKRbcFecvtpI8XIPGzzqg4jMV6NzsGYRUixX1U6xzY6WJ60E54qdOG9zlQwlQQpRPbP6LDnuNI9AmfaJXrDNXz3JMH2NiAyvNFcxy+ijBcYkY9d0QlhCAJsRUFJyO3Kx7D7udFeEu7pKryozhvBy2/Yr8Gec6y8V7QjSRM2aXoSJ7Idbd/+xX62GpZqZqsdOZUp6L5dz01sSjGJPbb030fh2EJV6obJyF5/WE7XDJGL3ggAc60qAmxFESs7HOWkKMVzmYzcXi0QtyFnpwmrM7dZ7og==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(366004)(136003)(39860400002)(376002)(451199015)(36756003)(5660300002)(66476007)(66556008)(66946007)(7416002)(38100700002)(8936002)(83380400001)(86362001)(316002)(186003)(2616005)(1076003)(26005)(6512007)(6486002)(478600001)(2906002)(8676002)(41300700001)(4326008)(6506007)(6666004)(107886003)(15650500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?/vUAIyqkNskz4+Oc9qNVZHxMwJFCMIcchxWUicLIRlCKN917eVlb24KoiPz3?=
 =?us-ascii?Q?sG0WYDG0wMFhE00XBgmwLzNxgqNQonkRSv9+tCOp7gOcF2mPNSLpjhE1TdHK?=
 =?us-ascii?Q?Dmqd+axzkiQqu6T5RETAssgwQG+ZUlh7EXP18BCmTwVy3QznjQbXiVt/PDZN?=
 =?us-ascii?Q?sF//zm1VbHRbJNJg3GFjChHoO8XWn38vqauzmvt9EJQxLZ8dBz/80qBczBOk?=
 =?us-ascii?Q?CFjyysbqWbiMd3OX9bb1EeHS5kTNjNhgL2Lg6Sjwul51GAK03eqMFfzWECNm?=
 =?us-ascii?Q?5fWX9upBF2gmYKW4axBM44nffGRiJu1yIHYSypLy0ME5onQnr+bzBOqUho7y?=
 =?us-ascii?Q?EtDjNbBw3ayD88BNi03LBpbPoAVA/S2fx/ru53jsvfx4qI1DVDrqz8lBxxtk?=
 =?us-ascii?Q?JzI3xf+eCqUDWb5sDvxL3qZrrlQS4L5rK6XUb61kexPAjd7cvyK4xpcqYa1Y?=
 =?us-ascii?Q?Euf8jD4ECqetinyBBPQM71HWJF7TU5Hb8NyYgMkitMUcMcjMHlla6ReFreWK?=
 =?us-ascii?Q?bCjLgbB0MaBP1yR6YW4LTi84ASvrNQJPwAdvQ5Zh8dFqmN06VzkHfaHEfcnY?=
 =?us-ascii?Q?x3/NKJcrIBz11tC0NWAQnd96MvsotX1FThgdM8NvqOmkYOkV/ezyrGD1saNg?=
 =?us-ascii?Q?aNJEXc+Z8+vdO7owYvf52KUJvy0L3bKwXoP3AuQcaHCQcDa72/i3cqn+2I3L?=
 =?us-ascii?Q?SX3CcZCtwl0Ch2l3cwmjgSFwNbV2Kzkt5WAi+F72bFYjQf0mh9b/ShctniA2?=
 =?us-ascii?Q?kRgqa+VP8PICEshJsDsyBHVG8V+omV3xe/L4WSy/vNrOX0NA6Kn7KyZyw5co?=
 =?us-ascii?Q?CYt52ursOssCUVcAujFqzWeRkaZYkR5pX/huaK6LU9gy/yps5DIRCwP+c7NB?=
 =?us-ascii?Q?A984aF9vCIkJ6oP9K+teM8lnbT/bN9RbaUjdpeabTN6Al77DnIc0zsTmx9JD?=
 =?us-ascii?Q?vaOihujViRWExqeyCebQDNIm8U6pMLO2j14xYa1NbJtXh1d77rPT/P+4yauJ?=
 =?us-ascii?Q?7c3XsXaXJ2pOeEZViVXQBClLCy+79cfqxyb58l/OAMvvYTguiNGDh7vNGF5y?=
 =?us-ascii?Q?KzMPk2SznQfaHmkNOHzaEC4OoKh9bJlEmyKHjztUz3a8Mir6WJhIZIzcZmQ+?=
 =?us-ascii?Q?eedK1E+R+AoGyQqIAdYYdlwWdjEQtVtgwtrDBI7KNO4cKIRX/DZeq0ImbPYD?=
 =?us-ascii?Q?QcRW7vjCsmEgT5UJ4OBh46W5G4PWu9xnm8G1FjrXYCIO1C29Hg557f1Ead6M?=
 =?us-ascii?Q?sH5M9qX/JZMH/kg55bqHXiR/ejFx+2EtQiAf/ryCMFiv2uqqkjCboydEGBkE?=
 =?us-ascii?Q?VzoPL1ckXPK0MTYA3AQNWPutqlCdaiCQy7+PrcIumFrBdyjkl3pDbGZQIvuk?=
 =?us-ascii?Q?48lhyFsbHVZ4ItwEL2GQr0o1XB6bdCB+LlZhxwQfwXcNQNX/S9VEtFLoSTGl?=
 =?us-ascii?Q?o4oMx8MqUBmaXd93QoKuS2YI38ZI8QuNKjLeAXWX/uNLuhpKj5AdOp9IfgWC?=
 =?us-ascii?Q?bMiaq+8FYcgku88sfmTP075qqKTwFhVVcmlmYDxkVRIjk78u6L3wcCniFv2Z?=
 =?us-ascii?Q?Y5He67oI7HKWKzfo64TPrzC03TcPPDnpWjIszCn1?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cbb523e-aef0-4167-faf6-08dab66ff40e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:58.0000
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: u6CdYujBRRC3yLBoAkFYzCNvDpILldUuXKV31DqY2u1d/elkHsLdN1sEsvM+aqLiOobIUz1cShemtP5lCNW+PA==
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

In Spectrum, learning happens in parallel to the security checks.
Therefore, regardless of the result of the security checks, a learning
notification will be generated by the device and polled later on by the
driver.

Currently, the driver reacts to learning notifications by programming
corresponding FDB entries to the device. When a port is locked (i.e.,
has security checks enabled), this can no longer happen, as otherwise
any host will blindly gain authorization.

Instead, notify the learned entry as a locked entry to the bridge driver
that will in turn notify it to user space, in case MAB is enabled. User
space can then decide to authorize the host by clearing the "locked"
flag, which will cause the entry to be programmed to the device.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../net/ethernet/mellanox/mlxsw/spectrum_switchdev.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
index 0fbefa43f9b1..f336be77019f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_switchdev.c
@@ -2942,6 +2942,12 @@ static void mlxsw_sp_fdb_notify_mac_process(struct mlxsw_sp *mlxsw_sp,
 	vid = bridge_device->vlan_enabled ? mlxsw_sp_port_vlan->vid : 0;
 	evid = mlxsw_sp_port_vlan->vid;
 
+	if (adding && mlxsw_sp_port->security) {
+		mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, mac,
+					    vid, bridge_port->dev, false, true);
+		return;
+	}
+
 do_fdb_op:
 	err = mlxsw_sp_port_fdb_uc_op(mlxsw_sp, local_port, mac, fid, evid,
 				      adding, true);
@@ -3006,6 +3012,12 @@ static void mlxsw_sp_fdb_notify_mac_lag_process(struct mlxsw_sp *mlxsw_sp,
 	vid = bridge_device->vlan_enabled ? mlxsw_sp_port_vlan->vid : 0;
 	lag_vid = mlxsw_sp_port_vlan->vid;
 
+	if (adding && mlxsw_sp_port->security) {
+		mlxsw_sp_fdb_call_notifiers(SWITCHDEV_FDB_ADD_TO_BRIDGE, mac,
+					    vid, bridge_port->dev, false, true);
+		return;
+	}
+
 do_fdb_op:
 	err = mlxsw_sp_port_fdb_uc_lag_op(mlxsw_sp, lag_id, mac, fid, lag_vid,
 					  adding, true);
-- 
2.37.3

