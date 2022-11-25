Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 331D9638316
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 05:13:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiKYENJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 23:13:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiKYEM4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 23:12:56 -0500
Received: from mx0b-0064b401.pphosted.com (mx0b-0064b401.pphosted.com [205.220.178.238])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44E551EC4C;
        Thu, 24 Nov 2022 20:12:47 -0800 (PST)
Received: from pps.filterd (m0250812.ppops.net [127.0.0.1])
        by mx0a-0064b401.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AP3q2aY010685;
        Fri, 25 Nov 2022 04:12:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=windriver.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references :
 content-transfer-encoding : content-type : mime-version; s=PPS06212021;
 bh=ySYt00LTOuxV769VLZrg5lAWwzRQvNtK2CPAEBgI5mo=;
 b=Ml8bak0w7m9Wa27NcfYTO9XD0k9npTNUbLyd/19GnMp9/MeKdo/IntS6QeyuTBsUuMGq
 qWnC4VSMOfYCM7lJ785fNY2J6a/LWRRWHzab4Zv/El00dayFllZH4c1f03OlCTptWcPG
 M/LExdszV/0b4Rbt/wLX6HAo8UjGMM65twVsob2uXomsqeJT4jj+3zS0iC52kKxRX3ob
 3Wl4ME04r7d781llrQP5+Frsg3g//yBGs8FYTNjHS8+Ba6bnkWGE4cSn8EHdVBYN4sKO
 C6L8Lp/NPvZuXQWdPAnUOhh6D5H/COxTg6XKgx4+H8IWITP7fQpq4Vh35skjXsszREYT wA== 
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by mx0a-0064b401.pphosted.com (PPS) with ESMTPS id 3kxp48mq53-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 25 Nov 2022 04:12:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WlhfbHedQoqXJP/EbtE9Lcwb0GWHGg1ZQmZ2Rlil1Ak5UfCgHRODAYv3TzUuKYAcQvj25QrYxOG6hXa5Ep3CA4Uu8lpQ4gZ14DsTYe+d9wNthR4nMu2XZM0Wj4BJRKEeHrl3lgfQdBQPrsT2gJ8cb+vsIKiVX4mY+nPYdqiPy6u2ClnEjeW4oJv/l0D3RmbPEgst23FOZDH5/vev7qgPimTYc29k+HMBfX5iEcIz3963WiU13pyqHvQT16rATWkGixwaG1bigMLgDmAof2y9g7wgy1s/lyY0QnppdFq0G4t7Gfqocsxe2GJcqXet3bwGcuwG0Xrzhwj8rktAxJN/3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ySYt00LTOuxV769VLZrg5lAWwzRQvNtK2CPAEBgI5mo=;
 b=G3ADSfzksoEmBEX6luISSnAKDq3+doSwLaOQZQz2InEWHalx3RYArfv+v7u/nwTo9xWzf6iwPkhokf8qcHKrRykNk4WOLtc8Ubh7tSm8czZkH8pNfDlnr5cmLAW6q3LY6ooAswaAXRtGVQRrf32Stu/Xhq4avJ7mauWsybhpYZSrrPUqW0OXM+wCem07toC++i74VWJXizfPwvR3rhiraBpp6YoAAJbVxIzxC+4gT+DAK0phTaXmhbbVjRENqgPQ8LciLT0avZFVNd/fG392XRT4YUPVIbLvW2fsm3uKbHWfpNFzJi9JxMamhoxUoWsAPQ4CxfqaAV2aG6ZA2alfQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
Received: from MW5PR11MB5764.namprd11.prod.outlook.com (2603:10b6:303:197::8)
 by SN7PR11MB6849.namprd11.prod.outlook.com (2603:10b6:806:2a1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.18; Fri, 25 Nov
 2022 04:12:24 +0000
Received: from MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b]) by MW5PR11MB5764.namprd11.prod.outlook.com
 ([fe80::601c:88b4:f579:677b%3]) with mapi id 15.20.5857.018; Fri, 25 Nov 2022
 04:12:24 +0000
From:   Xiaolei Wang <xiaolei.wang@windriver.com>
To:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [v2][PATCH 1/1] net: phy: Add link between phy dev and mac dev
Date:   Fri, 25 Nov 2022 12:12:06 +0800
Message-Id: <20221125041206.1883833-2-xiaolei.wang@windriver.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
References: <20221125041206.1883833-1-xiaolei.wang@windriver.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SL2P216CA0099.KORP216.PROD.OUTLOOK.COM
 (2603:1096:101:3::14) To MW5PR11MB5764.namprd11.prod.outlook.com
 (2603:10b6:303:197::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MW5PR11MB5764:EE_|SN7PR11MB6849:EE_
X-MS-Office365-Filtering-Correlation-Id: 3babd2dc-3a57-4c47-b00d-08dace9b41a4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PUXdxfL+HiB971gVP8+rcWg46NdKWSV6U0KBy4lllOI87S/2vBElSxk3B/zweOnpwi9c5oyqBo0C2WNBdDeX/jl/bRTRJOwS1x0wHhjLZEqGLYHEGvZxatdf+ovbn16b+NJGDBn2PBe9My7+qwJYnS/jzyDB/Y+SlXnbBErwPHO6MzBSwFA/9Dq0OLKoMDpoZ9/jQEWW+Qn4TVQiSVqCZp045w/ncspVF8cab12oxQPa7G/Zrga9pUvZCtJdUpeb7Qrbu749SKUZIQ9gJoa/t+v2i4SuBE27/aBbU/5Lr+QRlU9a5/OoKR2CX62T0nZsPfZxzqtOIAkOLPtc+3SrmDHAjj8Tt8gW05PkpMkdupI2dsAymkS4y5ZSPIACmi4q23o8CBg6h50FFLNi5nP2wC2scxBTvgygs8upU7/i6UHUawMBeZZBaksdCHoiLU+iEfPmTWwZeZFR2wH15Hb2aZpYpzVvO2S7sRJlOFVZcqCP3rP6KNzvCugHk9gzLXS3MpP+faL2501OdDyLkAC0S5aDT9eJcHTC+L8LWQk3C+53JikTlp33zd8+/KNM92vwcK2gHyqkjvaPr4HDIhVk/rFJv+cLK/dE5M9XqZTtq3YLVRayuIk75wnRjd0uTl5tkkW+1AaSNICDvGakXuKX6BItj5Btd+whrCa7EPs8gvk7glBpMyOuFjwj8m0D8QST
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(396003)(376002)(39850400004)(366004)(136003)(451199015)(83380400001)(86362001)(6506007)(52116002)(6666004)(45080400002)(6486002)(38350700002)(36756003)(186003)(6512007)(2616005)(41300700001)(38100700002)(1076003)(5660300002)(8936002)(26005)(44832011)(66476007)(66946007)(4326008)(66556008)(8676002)(2906002)(316002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?G/oEwz1vHZDqVknR/8xkaHquhgOBP+Mwy/BY73wk428I6zEqh9btQ8L7LAB6?=
 =?us-ascii?Q?nSdv9kQ9J1FX3hNpxnghKGgBFYWi8bx4ya28q4OfvgmzRkqMEEP8CshVvRJH?=
 =?us-ascii?Q?Bdb4Ri8GZrbWCOfE21HhzGsGJhr94ym6+v1mnhxrLjiXiQWaI8pA1ms5ha0t?=
 =?us-ascii?Q?dI/NEHiwLNpyVWG1p/EIMJcLqKGwgB3Pz+ZQHMd6cflpVPFhG6hC/TvLF32N?=
 =?us-ascii?Q?SfJr5dHwbDXrYM3Nlh3SgTj7wDDG6WQTvwICF0gQdlWUCBe6eZWCkdWHff/E?=
 =?us-ascii?Q?ZExpVm/Tf1iVChYlb8GnNMNCgJuEQDILsv23xFKnIadVuhN9TyeQe1kQ6SC9?=
 =?us-ascii?Q?V3X3dYhg+ne+R+AGi6cUZ1Q+dosTbI69lP3HCXTsnopsZaKhX5nZGXLljeNL?=
 =?us-ascii?Q?eDnmEc+P4FCizyUBZLCWqWTcocrd9YoXSyzgVhkYh7PfkL08nqdIUvIhZnLf?=
 =?us-ascii?Q?6XZGwIjiavxfZDOkAzZAS+FBIn36oXWBJ3cCanR4a2GaUersYZa6T0gBkH/6?=
 =?us-ascii?Q?8mzu0zFun2xIoHCVTYD1V7jxW5KxX4AOKkNd8ompnKAOdPLgmFElvgnCKN1s?=
 =?us-ascii?Q?szT45wQHAKfEY+tPSqumaMZsXGd0bA+0wNi00Xx0F/f6AzA25bUxdXKlM2gP?=
 =?us-ascii?Q?3uVgQZk9ATB+rLlNlhsy98AMFwBVHRmBBLz62Q4B6QjSYf9SBlytEF6cmmLk?=
 =?us-ascii?Q?C9zzBCI6SFsipWd1CLJiyW3fxEcH/WVPulcQCVW+Eo9YLibxzROsHKkpYLMl?=
 =?us-ascii?Q?k4wlbAuAENkGar2C6ZZOBVQhhNxl1vBGoL6/SU9olTpcvSArsorJwpZ5DJ7V?=
 =?us-ascii?Q?BDRDSIGZSQ9/lNQ9kvZbRP5O0oSoTtld9qG9aa5XgV62EyylCxxlFKrz2F8j?=
 =?us-ascii?Q?MPp3h2bO3NwgsAmKVJ1I+edosP1ZISxnW4G3UKeIxz1uImkLx/YadZhGAPSc?=
 =?us-ascii?Q?QPUW4jmnAo51YtMZCh8Qzm6oFkg1XkX/+G2HEO7mcGHvyY9iIV/+xYwsxrlQ?=
 =?us-ascii?Q?YfuaLqUWwMs/HMbYT3V+ElOeuzjOPicvwmi+dlP7JvWDaQTmLRkqUCqF2FL5?=
 =?us-ascii?Q?uBfUeiUicktJyQZzjI7gP2zyGxGlDwzV/0IzIhT/o7cV3KVD7PkhIDttCMXJ?=
 =?us-ascii?Q?4mPFgV9xFsMsXurvTjAaRjxLMVoC10tPvpDB1rZXi3C5ZnFQByCFTapX8EsE?=
 =?us-ascii?Q?RVUE7N3nPnMk7BK7yWPPJaf+ffwo2VqvAvVpU2K/94nl0I/R1+9QhDANJi7s?=
 =?us-ascii?Q?J2pWKbD5QUfF6XGeVMPEUrRcXZVODypeeNFOdZ2+xZPd8qDdd94v4KLJuLPS?=
 =?us-ascii?Q?bXr/rI7WVgQffmw48a3xmiaU8HAZTBX6r+GFS2EsQ0QFAox2Wr4hfNNnEWJz?=
 =?us-ascii?Q?BXPAXStGe8YThaGFnreHDqBZhxxiLu1D8UGRb9PIzW8GddNe6q4rbrVzEUZb?=
 =?us-ascii?Q?rqYxkdORLI4IuamRPWZ0yCfVhuE9i1xw7rFF5wjkdau9NtdAo7G8WkyIjSt2?=
 =?us-ascii?Q?leb7ev+pHam8GQIdPxOMHN+raWZOVXcnidyzDOnhrwWyJ63c/o8T2+9A7MeX?=
 =?us-ascii?Q?8DgAO11F1lBF/LzDixudQm5c4FgvfLr7mQ/1V9T6ylzfsssghMk8prBdfPOU?=
 =?us-ascii?Q?Aw=3D=3D?=
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3babd2dc-3a57-4c47-b00d-08dace9b41a4
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Nov 2022 04:12:24.5567
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zqe446LRa1fJlHjIZcWmV5Qteo1OJkHt+H4uZySKTfCK6oFi2sswJomTrPNWU2rc+Eg6Cmmdn0t5hN9itAOnv+tvkgtdCzwDvJUVZTDouRM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6849
X-Proofpoint-GUID: AjfSafSKMmIgebuv3fr8kFkzEbU0koFl
X-Proofpoint-ORIG-GUID: AjfSafSKMmIgebuv3fr8kFkzEbU0koFl
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-24_14,2022-11-24_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=344
 lowpriorityscore=0 spamscore=0 mlxscore=0 impostorscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2211250029
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If the external phy used by current mac interface is
managed by another mac interface, it means that this
network port cannot work independently, especially
when the system suspend and resume, the following
trace may appear, so we should create a device link
between phy dev and mac dev.

  WARNING: CPU: 0 PID: 24 at drivers/net/phy/phy.c:983 phy_error+0x20/0x68
  Modules linked in:
  CPU: 0 PID: 24 Comm: kworker/0:2 Not tainted 6.1.0-rc3-00011-g5aaef24b5c6d-dirty #34
  Hardware name: Freescale i.MX6 SoloX (Device Tree)
  Workqueue: events_power_efficient phy_state_machine
  unwind_backtrace from show_stack+0x10/0x14
  show_stack from dump_stack_lvl+0x68/0x90
  dump_stack_lvl from __warn+0xb4/0x24c
  __warn from warn_slowpath_fmt+0x5c/0xd8
  warn_slowpath_fmt from phy_error+0x20/0x68
  phy_error from phy_state_machine+0x22c/0x23c
  phy_state_machine from process_one_work+0x288/0x744
  process_one_work from worker_thread+0x3c/0x500
  worker_thread from kthread+0xf0/0x114
  kthread from ret_from_fork+0x14/0x28
  Exception stack(0xf0951fb0 to 0xf0951ff8)

Signed-off-by: Xiaolei Wang <xiaolei.wang@windriver.com>
---
 drivers/net/phy/phy_device.c | 12 ++++++++++++
 include/linux/phy.h          |  2 ++
 2 files changed, 14 insertions(+)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 57849ac0384e..ca6d12f37066 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -1511,6 +1511,15 @@ int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
 	phy_resume(phydev);
 	phy_led_triggers_register(phydev);
 
+	/**
+	 * If the external phy used by current mac interface is managed by
+	 * another mac interface, so we should create a device link between
+	 * phy dev and mac dev.
+	 */
+	if (phydev->mdio.bus->parent && dev->dev.parent != phydev->mdio.bus->parent)
+		phydev->devlink = device_link_add(dev->dev.parent, &phydev->mdio.dev,
+						  DL_FLAG_PM_RUNTIME | DL_FLAG_STATELESS);
+
 	return err;
 
 error:
@@ -1748,6 +1757,9 @@ void phy_detach(struct phy_device *phydev)
 	struct module *ndev_owner = NULL;
 	struct mii_bus *bus;
 
+	if (phydev->devlink)
+		device_link_del(phydev->devlink);
+
 	if (phydev->sysfs_links) {
 		if (dev)
 			sysfs_remove_link(&dev->dev.kobj, "phydev");
diff --git a/include/linux/phy.h b/include/linux/phy.h
index ddf66198f751..f7f8b909fed0 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -617,6 +617,8 @@ struct phy_device {
 	/* And management functions */
 	struct phy_driver *drv;
 
+	struct device_link *devlink;
+
 	u32 phy_id;
 
 	struct phy_c45_device_ids c45_ids;
-- 
2.25.1

