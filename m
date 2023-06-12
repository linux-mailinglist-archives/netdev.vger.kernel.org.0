Return-Path: <netdev+bounces-10238-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9537372D30D
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:16:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4AF402810A8
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:16:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3025222D48;
	Mon, 12 Jun 2023 21:16:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D534C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:16:24 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED30F4EC1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:16:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jwJQH9NPaTx8bkZyFYLCeHbjw4EHjbJlU6AjbAP59DjQu1wRssNOTtaKVFVRp44zxJn3nb45HoktWAeMsC2vJi/srM13aRWEjEwNYI2XekBMOXW0ahzOxKJNPtSqYbQBkxonX58cZCUXLmy13yVq7lBxkbJ30OQ9VqGoA+WYtBdLy1tRdfPhxapIi9aIr/DwBiVB5XAlKwPRV3fWyW3qMkSABGWenWAPQdtIjSwGzWCcMk6qsn59y/KzZ+cvW+TJGuHaQmjc6pzYz1J0sO2RKi4DeuV+haVvPOgtwFaN7+0o3uS/P2fHracYfFWHj5PAcKBtaMElzR/ulSEjcA6ujw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7HbNzwUZZkiJJ+8wtBIAoSRv1QC701ryCKWwQa8JQEE=;
 b=WWSFKN212SFFJjt2FOMOFDCAozFBZZ9zmhNO8poZr5Aqd0k1UpHtxz77kni8miXUuZHiDI5Lv1nu66IGteIdz3gnD8glW4+uyLwL5YcGnb9PN68AoIBPR/iqzmKN6CqefXPnYEYlHiaD0ra1+FnREiuj3KV+i39ah2u+hrmTgHEdsMAR1mUpKTpTC+bQmSL5U4HrCHDz58bnqlFOEOBBbwEEuMT2nVsHHz4v7JtrGyP7Eoe7QOAC6AS/zaN8A2EEoLD0KuFu8BDsrM9zCZFFGB0NTwuL5TWlqPBiflo3tSZKgonnP4rw56LxgZP6vtYpEqRq2apSlnY1X55zXq/oag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7HbNzwUZZkiJJ+8wtBIAoSRv1QC701ryCKWwQa8JQEE=;
 b=gs33he5IPtKUvVFjY13v6sgz5FqTvPFgDMcATeG7CQwCcsctFrfvg0+U5kVOPvJ75fccjgDmV8SYEBms/Q8fi5xnVyYUirvEyko4dqsib9DU1H0kI80R5ic2kIdkUv6cmvr/+u6f7H9jGNNvPbtXZU9Df+ANzpirFBNo+hNc4vo9GH3fsxAgeNgPnp14pzThpZumaMvazrqdeFf9I5bhVU+6sQV+LlSS3+AANcGxDr2hZOgTlbqPmYIQ7b+GSYR+rYqQisIjXZAmIkDt2OxP19TIohe2tbjAltE9gsI8CtMNmivI0BE7Xfe3bElkmYD7XqteEECwky60pOFyv4+rig==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by CY8PR12MB8316.namprd12.prod.outlook.com (2603:10b6:930:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.44; Mon, 12 Jun
 2023 21:16:01 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:16:00 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Gal Pressman <gal@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Shuah Khan <shuah@kernel.org>,
	Maciek Machnikowski <maciek@machnikowski.net>
Subject: [PATCH v3 5/9] ptp: Add .getmaxphase callback to ptp_clock_info
Date: Mon, 12 Jun 2023 14:14:56 -0700
Message-Id: <20230612211500.309075-6-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0004.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::17) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|CY8PR12MB8316:EE_
X-MS-Office365-Filtering-Correlation-Id: 00300aee-2fba-482c-9fa8-08db6b8a3744
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	C228oZ7r942PDBVwMxLTg3WyCxlLKoKAol8HOR/BaqXSsXoHz6ItWd0x90/wcfi3/CAYA7MU6f6Ze9IECaFVxnRUH/6E7V3gLORmRLE9YI2OfrSN3qBQ7dCk+0XlWCvS4RB2oK5xMiWVQZEWYbA3UJdg23jiX8uKQHTzJQq8pkGdKrUDJDQjNdv74mTDGyc3b/xfVk+r+WRQEIZaWbRBXcpRstm1cTiRYeHAYSGN1eej9JKOSs8Bmpc5p3SycZR3Kue8lR/X7BeRrNFiUjP2/nduD9JUji8mcEGDgjR8bC9MlufWxbjanhGoIFoG3gZzBwMXTQw0QoK+yOvJ4+ZbNbHhHvDRyUjSBbK1xYq1Q4Z8REtpP8u8arg8Gl0Jl2qiqDdhT79sNLwly9OQHu9YKQHPmNuANj5pkybB6Zm8VuRpcfa+9zZMTvjSGFl+GkuOXP7Sdp8+XTbOAVzNx+V46qkkW/Cw1UGO0rwzXB6WXmI0TTi5MeIVoHaWlOxE7Y/TBk+gdA7G0NEjg41BMiZyat5k+646JJtcWwmEtl8uDcMXg1PLLRkkgxzqzN++IYwSjv0Ns1Del7xHfwX26zXZc5NDn5xZ9VcRQ9qII0GfXekY0fpV0FAGlTKzS0Xf21+8
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(451199021)(6486002)(6666004)(36756003)(83380400001)(38100700002)(2616005)(86362001)(6506007)(6512007)(1076003)(26005)(186003)(6916009)(2906002)(5660300002)(54906003)(8676002)(8936002)(316002)(41300700001)(4326008)(66946007)(66556008)(66476007)(478600001)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GfpJwoxAz0dFzcuU4hgh1kRV6kj0r1C474fBlIllbd3SwT/6o3qt+sUdgIMK?=
 =?us-ascii?Q?TW+e9MEumy95oGQS4CLf44L9CH4jeRuSOWCf0vU+BkR3buoP6ilpPW1iTkUj?=
 =?us-ascii?Q?wwuLJvkkcdmRR5Wr0xTsmMPK1u5LXmhhXEfCDPH43O7PLjIrNBFiLTIqmJdC?=
 =?us-ascii?Q?Q9YmMF7VuIOuytT57kZEVm1nLgphtdHKQtiUBT0W6rWwinh1tmTQXDoQ+t/1?=
 =?us-ascii?Q?/exKKXeaSY4hmHf5NGiW8AIfN2ArzyX3zYpsnHdsIooe4ockouEvKcCm6NJM?=
 =?us-ascii?Q?KRGat3LWt7x+mr1CY2vhAALLU/GTxsTgdXOhgjwE1URmnxHKvoWUvtolQVZ4?=
 =?us-ascii?Q?a60JIAPuldXsaXoztnUNrp/N2PgW9KEHjDFGCHig8BYRjGT8ZzGNFINyztHH?=
 =?us-ascii?Q?M4qPtFtWKNGi5ZhKSlMoosnzSdjaGqTere+wHI6g0Slk0Jqg2IliGynMIqJq?=
 =?us-ascii?Q?ZqHOY1e0eGYYLZsqggDkBf0bpziuuJC4XTTDV75Pf+HzvB+K3gnEl9uxImuB?=
 =?us-ascii?Q?BnMe3dEq2vLfbv6LcZiLFJi1s6A29Uj+tvf7T5hTxBi2hghusikqRrXHeOVZ?=
 =?us-ascii?Q?RnLBQLrKv4GKaVAOwP9kEZOGcqV0Ul5Xg0G8pEgXPbcQusyHZhPZ/dCIZQqm?=
 =?us-ascii?Q?GG/ZnGuxKG4XMe56WJrmSPoT3D1YFgTiapnchcYkxGjUFXzTLRztRtyqRtDB?=
 =?us-ascii?Q?Y4orLEbCGibXceJ2Isg5ZYFE8ZHX9wkX+BrjM7ZuP3fMjFwMBaA4vf2nEVl0?=
 =?us-ascii?Q?GEwy12LIt9J/Liuu13Nidy0KDBvn+R+CPK697yqJtEmfIC5ilfywBVGLsOBI?=
 =?us-ascii?Q?gOxDnB0Dztu24GE5ReLsvQNWXNStWRFGl5lTQU3JxesBmdH3omFZv12mdcsX?=
 =?us-ascii?Q?gpGEb2lgh/2t2m5CjW9n4dvYfj/aGJ2ExO0Hx8uthm+bu3pj1aALZAoB0Bxg?=
 =?us-ascii?Q?W4KQ+Uko468MQbpiTbNmQAUwYVR9XQaiK3mmbJCMd6eVJu6eSBQ2BogB+uN7?=
 =?us-ascii?Q?niRMH+nYXuaVX38+c6Y2uht9XoTeIeiIN2QxeXWKh6g7eT3XSQLVAtgf4n0S?=
 =?us-ascii?Q?7Az7fGuUHG60sgHEqiHiIJABqVcwT96edoj2hHZxBcGv0Sy94bTCbEM5S+oL?=
 =?us-ascii?Q?27F6vqFLJSj3zI58WMMhDK9C5H2F1Vm0iMQrZGgTYUorTTaAmMSEcu7Aubg9?=
 =?us-ascii?Q?OrLuBbSL1MK1DPMOVBs9br6QvEewogaNbPP1xoF4uXPuaMEgy7En0D9wwvm+?=
 =?us-ascii?Q?r3SbZ6ykHrjxdw7IblLPOCrA3v0F1M1oEcL7oTa4Tlr+hLl1UOz/zo7EpVnr?=
 =?us-ascii?Q?lyDZaXgl9uZqF20XyBkdnURaLeJxjHK+m1Ce6tpHnCoZjEYM0WlDqawsq8DZ?=
 =?us-ascii?Q?AFxFKowFc2WixAxK8r9dconjqUOR6m13307bhe4O0byuY7Y1U6hiS2wBcnbi?=
 =?us-ascii?Q?o7NJJ4g2IvBMBG+3M31H0cNpFzu4sRDfNDsxqPEUpRX/0I5hgn9PGCJt/gDg?=
 =?us-ascii?Q?ksh7OlhrDEtqAvrzRNiafF5j3FuY4WCEpuPfSPTx57X8KL12R+zQY+48GULK?=
 =?us-ascii?Q?aSN/QlYr5KyRzfwTFWgeyv/g0PKljEwWMoE+DCx73vEPDybznNJ2IOdVKy8o?=
 =?us-ascii?Q?iw=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 00300aee-2fba-482c-9fa8-08db6b8a3744
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:15:58.1601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sOP+ZAugpFfN1r/HDQrJfMeQ+S/fUWWbEXsvpt2ByHrkS5PCcFe3eYE6G2q0di1FOFTZSM2rH40Hogz/Yl1R7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB8316
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
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
Acked-by: Richard Cochran <richardcochran@gmail.com>
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
2.40.1


