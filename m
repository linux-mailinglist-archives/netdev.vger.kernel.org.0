Return-Path: <netdev+bounces-4806-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9387770E6FC
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:56:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D1581C20ADA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:56:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D125BA34;
	Tue, 23 May 2023 20:55:57 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A26A94E
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:55:57 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2068.outbound.protection.outlook.com [40.107.94.68])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F9F19D
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:55:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hO6rQp7dCUieaUm7YY8jCOoyzP843OVcivfPEeZXE5zFri8Dald/52A6Vgn3SdSeIaaw6F6FkE8w2seNRfOfuIVvo+QYigzhYrwmsPXYKxk7wVQLAbwl1HLABssW/k6kltJg4vL3b2URnxMvaMBCgOiisoolxD1fpiDV6R4F8EqOXpxIVIHrbKd35qXTW1L86AYpb3+qB3rHzVWk6yfcx+IcT68jPAUAh14OFbewLJhUK+HAvgIbgH8/k+PysktmII3zFnbl+DXpEopC/xEuu0ZQmLJyBKvaiE3iYadF8YXscsop7wSDdckgGXNNPJxxLswJNVCetVE2E+19Tzw6ZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9cBH7RXdP2Nj/rOyLXmsBba4KllMs3krtxyZ1Jx6uxY=;
 b=bqLZezjpyuYsepXNJGsFdog7qU19lZvdTP5u7I7j1u2suGfcStZVsyjkuYr7GTXGWx2DvdVjTxeIA2VGkJJBDM0SQQTC09f6V24ZuwNWlamzBwAxUL3GYW8TWBbNFtbI2Vi3wZl9KSBlAJ60W71J016h83kgXPaaHnG3v3dCmfcSCSyYniDw79GfzFcrkJMTDnY0nh430V4unDhAJt09QMyaT/6nmeLWdi/Opmz61OuSln1zfHQu9rmljkGWvSW4icfmNPy7tJnNGu4gL729PJaOBH5YVsVdHKj5kTT3fXvIX1vODYFTCbXECZYTr1pQ1dnkt6U+Ie5vKq5vdhij4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9cBH7RXdP2Nj/rOyLXmsBba4KllMs3krtxyZ1Jx6uxY=;
 b=eSf0Q4qbQ2fPH/uFor2fDVaQm2R6xzd1K4x868SRgfff3igFvjIheqrX22p443Yc+HiWR+hARdf54xy1LE6RuBXKf1sLMYH12iZ4s6MDZATTwN3eiJdEod/t+G2XIYP7uR43W6aDLhh5zrH1++Hc8/lb2pMAe4n0GGARq9RsGkRDAKdBJ4u4BoNzK87Vvzzv0CNLjF5SZK/3t4E1d2G58lIzb/5cddAgbRyPqn9eyKd0EYbeknUnLIexQt8WEb9VoAFEuzWWcFl26YrxUcNbCmirZi4Ag3yYWfoRhMMnwEd9ZF3/KOxZs4BmCIIBDDBssaMd9d3gK1dmseDHCk7z3Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 20:55:34 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:55:34 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Shuah Khan <shuah@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Maciek Machnikowski <maciek@machnikowski.net>
Subject: [PATCH net-next v2 5/9] ptp: Add .getmaxphase callback to ptp_clock_info
Date: Tue, 23 May 2023 13:54:36 -0700
Message-Id: <20230523205440.326934-6-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0055.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::30) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 6116bd20-2bd8-432c-7384-08db5bd00d51
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	Z28mMMgQaGR/yOB2Dlg73XDSbyiX6Yg4z6ngiUDtd3sAQVP8OE7sWNs8bxliV04uPeId4iNt09JlLFsUgOTisjVp0ybkdT60Saml+AfGUN8I5i5bED8Ljy7bIgwPiJxuvryuXPVWNIgRwNPzIZNOU9ro3Jd/UgTXko2WzhKIPGDvRIB8H2NhQ9AXDAgBEMy8snh0lLsaPNqebBecAtzR8KaZw8bJ3SHJl7wEd7eeZLqQG+Z13vIqw1VosMJJKVgET7cwM1cWz7n3s8C3d6Hf9wvWtyeh5QPKzIU/cYnKUsgMBzPxniWTWWMSo96pm4xBwHhD/EcCb0vO4wgJn1xugwZ4KqWWaMw7ZTcQ3qY0+N5d4hbdfFuTVhCP67YPBsr/bJNt/xtYrpuL6kahQ+R6Biwqf/eGFFzeTPVDBjuEKGDB2UVie1xHxb7Bgi29Kwi1op2Hm7sgDuK7FQ80qwrDZ/5qJ0rMp76AvqCiP5M1gmSRjhq7KH+XS4AJuxMQbhH9iAkQZtOxYp8z1JShNsAHTFDVzMpBRCaI9MX/7Gztgeg9DvdfkESkzzBE6sTyF8LMQYLBkP0BcElHJeoXNJWPChQ2bD8xfvu6iA/T6J0YY1e/K3wCjASr04KzhQBm70gx
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(26005)(186003)(1076003)(6512007)(6506007)(2616005)(36756003)(83380400001)(2906002)(41300700001)(6486002)(316002)(54906003)(38100700002)(478600001)(66476007)(66946007)(66556008)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?UcygJd5eH9sbKR8hMawbtBzisJGHI+GmQXAl8Gs9KGsVORxDdUWSb1BcRw27?=
 =?us-ascii?Q?GWJkKhrdnFeW3ZkcMXgvc18yQ/yo7dT2JpfLK4epWMqxfEptQ1WNZrJxr4xU?=
 =?us-ascii?Q?nS2FTeYG+jAhk7zaxv/Mptu/qmXDaJuqlwsJ1VE+XTETlzneI8zn1h2Uahk5?=
 =?us-ascii?Q?AY9winnFlhbBNrF1ipDdg2A/1fwDM9CBexFLDlK8RmDKAncXbTGKgxG5ezAk?=
 =?us-ascii?Q?6OCR5QW2pIp3PWeftSqPTNzzWojPJb+A65MgfBv50+YltFDpjwoXT+ZoqvDl?=
 =?us-ascii?Q?0LPPYFi67UmYk4LXq6r206U5JfiVB612jKERCsNjPa3cMizYIi3943qs8q01?=
 =?us-ascii?Q?7G2TEwRBWYRy8h/qoe5qJJDJ+0AnkPSxnR7xyai6JnEew/sdBSpJTXUPVVse?=
 =?us-ascii?Q?GSF8//3sEuem/paZPqPIBlXKByMgwXhazyGxb16SrdEe8/CJqhDjS4giX7r5?=
 =?us-ascii?Q?23hSqSpgj1CIJd0mSEceiRSpDhQLn7Jn5SqzB6uMZuW81w2KMsllqeq+s/3L?=
 =?us-ascii?Q?VUjNGXOX2eiGabEO8iinVN+10U8X/U33tWbssZ72bMHKPtG09TcUYBDBOPTU?=
 =?us-ascii?Q?9UOk4Xq4/j8PqU7k/7KPFn4YGt8/rqeSxmQP1uWJGd6YmBWTRz8vRYr+eWFa?=
 =?us-ascii?Q?+MCU2lmgDZ8g7IKgw/EiZ+aaNyLwC54g8mqbnAfIA7+8rlfY6SyfzR/WiRqn?=
 =?us-ascii?Q?xoc70kwC/2NRdyRasNtmxiQkKIAd7u8pS5QN2Y3qjeIjI/ekN+267qS+RIOX?=
 =?us-ascii?Q?dP22PWUcnitadm7JFydLxNKT9/ZT0uIpMn8J5EaolP128CVcWPYrsu19bZgu?=
 =?us-ascii?Q?rvbuSo+nZpaSPybxfcM+BjYRnV8vcoEalGoFa+HGBGhAvDhi8DHUJFWeVu+7?=
 =?us-ascii?Q?oo9ENKqfUyjFYWRlcyjpEdgjOgx8Ny2rCCi5FcYa5a9WKSWQ2nJL4TsveV+5?=
 =?us-ascii?Q?oocyZZnQazi5ivEeWmD1DBTcEJ/iMfBFYUGMj0NalTZr3ug0vnvUNz8ewC+v?=
 =?us-ascii?Q?9VxojKFmHcmfUfORZg9j0OWrKujV/fVwiOllqmk/KcifK6ncXGksJ/fjh0sF?=
 =?us-ascii?Q?wM3H0Hr1/KXylrPNFBudZ1DQ24dDyMpnJM8EkbxlaZlvglay3LT6MPOVtT9Z?=
 =?us-ascii?Q?QtN5AKWALljHjF9s/ehNRWTwaBc1AaVvBEr1Zr6cZ2bRgUHzAd17klmkDcZr?=
 =?us-ascii?Q?HsjPBDweEsF4eoLbOUbVIM2dByryI0BtM7t1oIixwJxbza1X+SHxh5UqAEGV?=
 =?us-ascii?Q?NTjRyRIDWua9E2xfz3fEogPTwNVWWElB2PCpWxmVM6e0txy+CMNENluapWjj?=
 =?us-ascii?Q?ItPjjcbxMN3w2b3lhphTngQexUD5WgeeWhH9Nqb2rNIvZCUR1GPFR5VHzW+H?=
 =?us-ascii?Q?wWg1sAehv8abWT4N0ty78vpzRdz4UbpWi9niTP0t09rLn3cJzrwZvzSRNdkn?=
 =?us-ascii?Q?VEQuPOvMHwqmkGhyifYlKzOEswUwXG9UDEuzVrCUk7DBaewh3O8epxVZgfBj?=
 =?us-ascii?Q?W9JsPjFsajzlRvP1GR0JFtJyX1m8oUpaqy/+RB4yWIyZb7yX9gjCvkUxKevU?=
 =?us-ascii?Q?8MWvlCThLfYZtwjKY6mOvB+1o0l0PQ2dmhmAkMBOG08rpfi91SxUd7g3Mpmq?=
 =?us-ascii?Q?EQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6116bd20-2bd8-432c-7384-08db5bd00d51
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:55:34.4985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XraXLebJBk6rg91JPVFdDK+P9B4P2iYN4ojAp3h60u/rldfzTeKABYgcng5umQYen5uFMFHSABn34UYoSHFh9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Enables advertisement of the maximum offset supported by the phase control
functionality of PHCs. The callback is used to return an error if an offset
not supported by the PHC is used in ADJ_OFFSET. The ioctls
PTP_CLOCK_GETCAPS and PTP_CLOCK_GETCAPS2 now advertise the maximum offset a
PHC's phase control functionality is capable of supporting. Introduce new
sysfs node, max_phase_adjustment.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Maciek Machnikowski <maciek@machnikowski.net>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---

Notes:
    Changes:
    
      v2->v1:
        * Removes a macro introduced in v1 for adding PTP sysfs device
          attribute nodes using a callback for populating the data.

 drivers/ptp/ptp_chardev.c             |  5 ++++-
 drivers/ptp/ptp_clock.c               |  4 ++++
 drivers/ptp/ptp_sysfs.c               | 12 ++++++++++++
 include/linux/ptp_clock_kernel.h      |  5 +++++
 include/uapi/linux/ptp_clock.h        |  3 ++-
 tools/testing/selftests/ptp/testptp.c |  6 ++++--
 6 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
index af3bc65c4595..362bf756e6b7 100644
--- a/drivers/ptp/ptp_chardev.c
+++ b/drivers/ptp/ptp_chardev.c
@@ -136,7 +136,10 @@ long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
 		caps.pps = ptp->info->pps;
 		caps.n_pins = ptp->info->n_pins;
 		caps.cross_timestamping = ptp->info->getcrosststamp != NULL;
-		caps.adjust_phase = ptp->info->adjphase != NULL;
+		caps.adjust_phase = ptp->info->adjphase != NULL &&
+				    ptp->info->getmaxphase != NULL;
+		if (caps.adjust_phase)
+			caps.max_phase_adj = ptp->info->getmaxphase(ptp->info);
 		if (copy_to_user((void __user *)arg, &caps, sizeof(caps)))
 			err = -EFAULT;
 		break;
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 790f9250b381..80f74e38c2da 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -135,11 +135,15 @@ static int ptp_clock_adjtime(struct posix_clock *pc, struct __kernel_timex *tx)
 		ptp->dialed_frequency = tx->freq;
 	} else if (tx->modes & ADJ_OFFSET) {
 		if (ops->adjphase) {
+			s32 max_phase_adj = ops->getmaxphase(ops);
 			s32 offset = tx->offset;
 
 			if (!(tx->modes & ADJ_NANO))
 				offset *= NSEC_PER_USEC;
 
+			if (offset > max_phase_adj || offset < -max_phase_adj)
+				return -ERANGE;
+
 			err = ops->adjphase(ops, offset);
 		}
 	} else if (tx->modes == 0) {
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index f30b0a439470..77219cdcd683 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -18,6 +18,17 @@ static ssize_t clock_name_show(struct device *dev,
 }
 static DEVICE_ATTR_RO(clock_name);
 
+static ssize_t max_phase_adjustment_show(struct device *dev,
+					 struct device_attribute *attr,
+					 char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+
+	return snprintf(page, PAGE_SIZE - 1, "%d\n",
+			ptp->info->getmaxphase(ptp->info));
+}
+static DEVICE_ATTR_RO(max_phase_adjustment);
+
 #define PTP_SHOW_INT(name, var)						\
 static ssize_t var##_show(struct device *dev,				\
 			   struct device_attribute *attr, char *page)	\
@@ -309,6 +320,7 @@ static struct attribute *ptp_attrs[] = {
 	&dev_attr_clock_name.attr,
 
 	&dev_attr_max_adjustment.attr,
+	&dev_attr_max_phase_adjustment.attr,
 	&dev_attr_n_alarms.attr,
 	&dev_attr_n_external_timestamps.attr,
 	&dev_attr_n_periodic_outputs.attr,
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index f8e8443a8b35..1ef4e0f9bd2a 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -82,6 +82,10 @@ struct ptp_system_timestamp {
  *             parameter delta: PHC servo phase adjustment target
  *                              in nanoseconds.
  *
+ * @getmaxphase:  Advertises maximum offset that can be provided
+ *                to the hardware clock's phase control functionality
+ *                through adjphase.
+ *
  * @adjtime:  Shifts the time of the hardware clock.
  *            parameter delta: Desired change in nanoseconds.
  *
@@ -171,6 +175,7 @@ struct ptp_clock_info {
 	struct ptp_pin_desc *pin_config;
 	int (*adjfine)(struct ptp_clock_info *ptp, long scaled_ppm);
 	int (*adjphase)(struct ptp_clock_info *ptp, s32 phase);
+	s32 (*getmaxphase)(struct ptp_clock_info *ptp);
 	int (*adjtime)(struct ptp_clock_info *ptp, s64 delta);
 	int (*gettime64)(struct ptp_clock_info *ptp, struct timespec64 *ts);
 	int (*gettimex64)(struct ptp_clock_info *ptp, struct timespec64 *ts,
diff --git a/include/uapi/linux/ptp_clock.h b/include/uapi/linux/ptp_clock.h
index 1d108d597f66..05cc35fc94ac 100644
--- a/include/uapi/linux/ptp_clock.h
+++ b/include/uapi/linux/ptp_clock.h
@@ -95,7 +95,8 @@ struct ptp_clock_caps {
 	int cross_timestamping;
 	/* Whether the clock supports adjust phase */
 	int adjust_phase;
-	int rsv[12];   /* Reserved for future use. */
+	int max_phase_adj; /* Maximum phase adjustment in nanoseconds. */
+	int rsv[11];       /* Reserved for future use. */
 };
 
 struct ptp_extts_request {
diff --git a/tools/testing/selftests/ptp/testptp.c b/tools/testing/selftests/ptp/testptp.c
index ae23ef51f198..a162a3e15c29 100644
--- a/tools/testing/selftests/ptp/testptp.c
+++ b/tools/testing/selftests/ptp/testptp.c
@@ -292,7 +292,8 @@ int main(int argc, char *argv[])
 			       "  %d pulse per second\n"
 			       "  %d programmable pins\n"
 			       "  %d cross timestamping\n"
-			       "  %d adjust_phase\n",
+			       "  %d adjust_phase\n"
+			       "  %d maximum phase adjustment (ns)\n",
 			       caps.max_adj,
 			       caps.n_alarm,
 			       caps.n_ext_ts,
@@ -300,7 +301,8 @@ int main(int argc, char *argv[])
 			       caps.pps,
 			       caps.n_pins,
 			       caps.cross_timestamping,
-			       caps.adjust_phase);
+			       caps.adjust_phase,
+			       caps.max_phase_adj);
 		}
 	}
 
-- 
2.38.4


