Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 125F760C96D
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 12:07:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232217AbiJYKH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 06:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232218AbiJYKHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 06:07:17 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2075.outbound.protection.outlook.com [40.107.237.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE0C613B515
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:01:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O+c9Sv6L+iTIPI9G1xVtF8CxWRxtdmyUHnWBXeFVbO3BmQoxKXDTKWd6/TNK8O6XuEi/N61JiLhKTl4xz0oT9nHrhgDnddBY1IwzOCxQmSo0YpCtGFCdEdyI2P118wW+gid+5uvIg+lbOBN61OPRboCrH8C+cD3diWURunhjCPv9PN9U1nqPednFa+CzOX5dKa5UWlGBzSH2PMFuVtJE9wt8HS0nIy9HQtEBACIrflSCkdsazcxGKhWoEdir/jfWrlVfUFByIoR+5Fd/IVhp9tutfukmItMdiUjYsdt5pWwgVhq448g8sV28zIY+6ku6B5uz5mHcrcqnciQlSm2rgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Aq1915Q7YYjDKKWn/Core1xUyC2d9LHv/zrbbXnTQmc=;
 b=og7myMCmp1R9Q+uXulwhvcp5qPDQ5RYbo0vB2wEBGkteSSdB6pWGzjdqrxNLo33mIA+dP/2NWhNqzoNeKs2RJfFA6rZnYxQv78zSez5ZWMFv1+PmKVMYs/f4zD8uAAXySf6lXh7ubATZBBcswkPyZIfYoh8m7rdElcComFHTR8jYONa3cH+9paPfEew46ZgArUdYF2i9jVVcFwJrHw022FN0CuMGYejApDO7icIurX3gxvLLU/1X3P6J1/892n0aG+2fc5EAOTp8NxNZ60RrU9qsiyq9V904bp3IjlLQqVJtT/dAx0du29yRSuHH+VKLhEoNQCPetMYdRntc1/KNJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Aq1915Q7YYjDKKWn/Core1xUyC2d9LHv/zrbbXnTQmc=;
 b=AWs1WuNkk+e1epMuOM/DAwQe5x2LY2VqJKxva/YsZUgcwPFmmDGoY0xSwNoi5w3D4NfFAbzMHbPKQrU9e/UOpHfSimt6tNJqHu9UJzRQg2dGPVs2sETuwv5NVoGemReMgT9vI0Ff27oCwRODRoxcoz/JVEZa7X5ipAMUDS3RgpC3KXGO86QFvJ0avcjoSqLjkxhD1OSLf86DH+0FRGbyIT+HMpzlYJJAZs6m3HsrNU0f0lZQ0w35rYeEBuMcca2jI9POCjnLyzkLEoATgqkr1rVgJEmO/Hy7WNMx5cgvhDnmF7uzuE13Jqk7Bz8OScJdSRideT74f1dg8GgU2D8HOQ==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CY5PR12MB6179.namprd12.prod.outlook.com (2603:10b6:930:24::22)
 by BL0PR12MB4929.namprd12.prod.outlook.com (2603:10b6:208:1c4::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.28; Tue, 25 Oct
 2022 10:01:08 +0000
Received: from CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e]) by CY5PR12MB6179.namprd12.prod.outlook.com
 ([fe80::4ff2:d93e:d200:227e%7]) with mapi id 15.20.5746.028; Tue, 25 Oct 2022
 10:01:08 +0000
From:   Ido Schimmel <idosch@nvidia.com>
To:     netdev@vger.kernel.org, bridge@lists.linux-foundation.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, jiri@nvidia.com, petrm@nvidia.com,
        ivecera@redhat.com, roopa@nvidia.com, razor@blackwall.org,
        netdev@kapio-technology.com, vladimir.oltean@nxp.com,
        mlxsw@nvidia.com, Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 03/16] bridge: switchdev: Let device drivers determine FDB offload indication
Date:   Tue, 25 Oct 2022 13:00:11 +0300
Message-Id: <20221025100024.1287157-4-idosch@nvidia.com>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221025100024.1287157-1-idosch@nvidia.com>
References: <20221025100024.1287157-1-idosch@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: VI1P194CA0007.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:800:be::17) To CY5PR12MB6179.namprd12.prod.outlook.com
 (2603:10b6:930:24::22)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY5PR12MB6179:EE_|BL0PR12MB4929:EE_
X-MS-Office365-Filtering-Correlation-Id: bc8dac8f-656e-4ad1-0f70-08dab66fd62e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PSBaBYudFdKbVRAmZeGak/M5eoXbbEp+7k3RtEV7uglshKDhQLtBmiYasnQeUZxJ8BJj/tXPXR221xeBJNKT6TFfJWBqtCga7wERl5Sh/jCM26aQUBa4nPRRUGAxMGLW8CSM7tQ4OugYICbKQHRV8MwWMZFnSX250TlIVjIpEfmfQQOtHnDC7hp/HgvCf97FLeb5qDr0VQZnbJoxUGjaPeA7XnWh9RuXN1C38UySkxvBGYPIGd3glcsRwco988tK9SDiKrBwfdhhtiK5NowColvuRuQRy4B20bvHuMmG8/aNZ4JUF3yWTPfSAOeK5f49v2ctgmmD0ImyrTmMRjbJa7RGy3JrjEsvQGZUWUHTsYc0HW92DpuPaF0Vrd5BEurL6q4fiJNf2hMkN4ke8Azj6LLHUyBctbVsP2n1UDyJV67y1wqjvYqpzzmakEbcrJ4uPjfFOhXRYeHr1jnx8PHIJYFEmx9vXdVQ/HN/X1gFwpyH7w8n1sIDlweP4IKXf1DXIGoTBS4bkKlf/iyCtRLSpluQK9/140rfihsRrRZ+xBHUW1/qs+BmzlTYa4gC2K/QYwGnwqiyOirfcSnWJcIpZQuf9r5O5EuEwYaDhMUhl4KtUDM0TQoK/4mF1wwImnsen3GkomvEcKbSlvpMYWWNGBSJSnt6yRS6I6cNf0hGVswDUgGK7HCVYSII2RKSO5E3yp2LPjKJ1DHAJnIEgciQ1A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY5PR12MB6179.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(136003)(346002)(451199015)(86362001)(36756003)(38100700002)(2906002)(5660300002)(8936002)(7416002)(83380400001)(1076003)(107886003)(6666004)(26005)(6512007)(2616005)(186003)(6506007)(478600001)(8676002)(66476007)(41300700001)(66946007)(66556008)(316002)(6486002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QGFfNlDmSsJXrPKOJolAMwWTsmEFDhBrvGnBJ3oPu5WkraDLGoE3KHulVNZz?=
 =?us-ascii?Q?k8TOuxsYyZ94R4nzPIQa6Mey2Irjtt2xFyPCyRo+sDehETj/JidRHpnVrg3W?=
 =?us-ascii?Q?qNzgiQJZ+PvgjhpZdCMUgTeJU3baBe1GgdazZLKVMaOn2cVxh41x3twkaQf/?=
 =?us-ascii?Q?xe8NTkafPDamCR5dqfVBWuIlwcTIronIObRFqOrXV6nDyqb1w0yd9PZTXOwf?=
 =?us-ascii?Q?Ty/Ahuvay+4MalXvglBStsE6eeD4nN/H2Zkq/Bg0V2oqc9IFwPqfWHTfwW2x?=
 =?us-ascii?Q?j8k2NAJ+MWl83QDrOVwfmjhfmbIaQzOLWs+xf5hlM0g/Loy9b8/uj7XKR8+a?=
 =?us-ascii?Q?li/eG1ynWKxqms2wxsTybgodcv6fDyQVlTmnM4qrZgeX/svUk49C+4+W/tDN?=
 =?us-ascii?Q?0odmTm7dPx+ydKsMAbJqQtRPofIMl3nLoerR8HLxzP+SPqfsIrBFJ0THRLSQ?=
 =?us-ascii?Q?PQe2OqnnpQIAYtVVPVufC77FoQ5D9dASpStQE/8yxYmFwQZG3BWJh0vEbS/n?=
 =?us-ascii?Q?CdySB7y8/yrAZufdACFOPMhOt9p4LyUV4l+aoMB/thJ9VXq4uancMJ2WrSYc?=
 =?us-ascii?Q?+sX/COedFKJpyl22adr9f8co4ae9ArLiXtAiFV/5elIqVbRZB5rNdTJ/UmG1?=
 =?us-ascii?Q?SIJFd+tyubB1ggO74L+zV9yEFlBDRM83bIZFSa1bv8P5P7pK+LvHNDoJezeC?=
 =?us-ascii?Q?ZsCy2bafqLwCGjYid8MFgeGn3BOJPyk9wwBO5E4jUgTsI5lG+aNm+5aHxJAz?=
 =?us-ascii?Q?Pe7qxWASRfmDNRLTSdVwsIs+GH8cpRTu5bjlCr0Bb3UKdy3L8ePPH4av5qlw?=
 =?us-ascii?Q?UNB0mxGWeoLuxO6CKmd2fTrStndAeQ0aMx9mirIx481edOx/nVeRgn4GJF0g?=
 =?us-ascii?Q?f9kBb+quXE5i3t3aqMdTTNn7nd1K46r8Qe+8+M5fYB2frQehu/4XqbToZVKJ?=
 =?us-ascii?Q?XtWiyET0G+mwRb13E7HEot3puPCFbRWhP1BwjPKSq68KtwCKPHRbKwWsXNBY?=
 =?us-ascii?Q?OCBhO626FvL+brAmMpzdkcUpPmwdqwX6zQiBYEGOM4hx6QH0P+Ign7EV1RMl?=
 =?us-ascii?Q?5fBqoBfWGfDSqHl173yc0TXGwLfkQQBow35btACbGkTeBeVdlpaJZbFDdUfI?=
 =?us-ascii?Q?nGLh+XJ6y91S8d4Mztl7EA8GMiM08jtseEHWuo4YAJfNuo2Ch08TwL1yOCJI?=
 =?us-ascii?Q?1Q4C2c1IoQh6uffjBGcZ69P6X0feJ4QDROGKAmQEcKOyribOz/7uO5JK1tdp?=
 =?us-ascii?Q?Y491jpxhFmk/K23MCCRbsiriOtCFRMyxT0JFYSNZM76j4JiOwbhFtZ4SmXdB?=
 =?us-ascii?Q?h87bQ9Chqd2tMN+JpbUgUIRuYtU6vi3pRpn5/rXza+9XqQg59iD2xebhkii9?=
 =?us-ascii?Q?WskPDjD/3QoxBrCI8KH0bVBOvRy8+y4AIvHFUWtyBTCc2In0ymaWottM3srd?=
 =?us-ascii?Q?vUJi6bHFKmNqxPnl1KrFMCvgcuPCxRvUky13aP0kE6fQopSBJSqfdl3139AM?=
 =?us-ascii?Q?l/D13IT33cubm6SvCnXv1fW1bcv0Ml+f/AkRqcKLtS8wy6xYgkAbCzRk079z?=
 =?us-ascii?Q?BicBReB8nTzVde/e7Iz/MJxc1rWL12dAx2baKXd2?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc8dac8f-656e-4ad1-0f70-08dab66fd62e
X-MS-Exchange-CrossTenant-AuthSource: CY5PR12MB6179.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Oct 2022 10:01:08.0282
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +nDoOV3VJNVDOB4I0iI4GYwSS+Jtw+AevwijI49vVnnE2ImVCoPC/1f0t6+xdssJbKur7z58+iL98rYGaWmt9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR12MB4929
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Currently, FDB entries that are notified to the bridge via
'SWITCHDEV_FDB_ADD_TO_BRIDGE' are always marked as offloaded. With MAB
enabled, this will no longer be universally true. Device drivers will
report locked FDB entries to the bridge to let it know that the
corresponding hosts required authorization, but it does not mean that
these entries are necessarily programmed in the underlying hardware.

Solve this by determining the offload indication based of the
'offloaded' bit in the FDB notification.

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---

Notes:
    Needs auditing to see which device drivers are not setting this bit.

 net/bridge/br.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/bridge/br.c b/net/bridge/br.c
index 96e91d69a9a8..145999b8c355 100644
--- a/net/bridge/br.c
+++ b/net/bridge/br.c
@@ -172,7 +172,7 @@ static int br_switchdev_event(struct notifier_block *unused,
 			break;
 		}
 		br_fdb_offloaded_set(br, p, fdb_info->addr,
-				     fdb_info->vid, true);
+				     fdb_info->vid, fdb_info->offloaded);
 		break;
 	case SWITCHDEV_FDB_DEL_TO_BRIDGE:
 		fdb_info = ptr;
-- 
2.37.3

