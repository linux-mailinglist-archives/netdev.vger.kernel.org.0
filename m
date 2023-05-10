Return-Path: <netdev+bounces-1576-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 3F80F6FE5DB
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 22:58:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35DF71C20E0E
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 20:58:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0580A21CE8;
	Wed, 10 May 2023 20:58:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DB7168AE
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 20:58:22 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2070.outbound.protection.outlook.com [40.107.244.70])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC484D2E4
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 13:57:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BnU8+VRAF642h+QiYoywGvSBxyOjtgbDySd3jN+Njvy/gKkHxan2UpxPXckOIvlBBnQE9Qe51JE1JGMR29tQVB2f5mQPuakvDJrygvaj2yzS0RyxN4yPB2K12Hh3+JCmpy6ni8WPw+4+AEMAeeSJwAcTvgNAaB9M1OrzNrEcBF8G4E5R8lsPpTa9fgpqdYiJOWzSEHkecQKQse/M2PlQGTmWCN6Ea858Vw62zF0vTSE5j7CRERhz2fkjJWuewErjLAw4HYodLeF5MaaGATcX4AMzkN7YugbrhLunBKzSe5orXd3zPkRa8yqbb5ooDyeOV+HVO+aehwjuyHIa0vPXzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4jHwVe855LScPL5il18j5QZtpIY8Y+h5VFoPaFhiKhI=;
 b=bZuRBTuXvmrYTx84AZXynSabHqYXHiEveQTM0NiSZQ8cntvIyU24y5xucGA0azyqWKJo2c3YV9PDYSOAACQoCv50kPbZMrvTsUvTEgB6N8IealTcf7TjHstF1S5X8YzGZoaLrqKrPFCLWX5cgdSkcZENYOo/Q55v3izdm3cjVvBmn/CYt9vq+LQ1A+HDoZaap+ukYRm09MQZnXTI9SenAu4K1lw0pzzaQ3RJNUOlOzcbEJ0ArKw3X46wkQ3Y3JV5mQMyHJdrTPKOXtxd8Yxq4MYIiYP0Yq8IL7CLLNGuGCmaCFTxCVh/Hx2LIJIbkJG7R1rNJwbcEJ2FxbI7sxYtXw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4jHwVe855LScPL5il18j5QZtpIY8Y+h5VFoPaFhiKhI=;
 b=JrVfchdfNMvtEX4MSGdqJI7FksKuRmxlUyNcQPJQg/8iTvu9TDWELA+UuozvDkLHSXUwqjZUjFPVWokG57KnZ9gBu6gareNKHeLaMqaI3yLqzlEzWOdP/u4bVRUDqrSoVFf+if3aGJQzhNpW8sTnh/s5Tr2Wr8j0dEo0yBRJ4glCzG+q7SLt2fJ8O+rmXNkKf7/igj+cYz+ICKlkgmqE9igfmQFpljb3t+gy6MWDjmPImwojC6rZRZ5wn0x3AD9PNsniYwv0JbB4lhpIQygSU3UU5Stu8EnJkePRgLUaiu0vVB35AFsZf7sM/VavQEoGR7a9Bj9bRsLGLb6ZMXY6ww==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW5PR12MB5624.namprd12.prod.outlook.com (2603:10b6:303:19d::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.18; Wed, 10 May
 2023 20:53:56 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::de5a:9000:2d2f:a861%7]) with mapi id 15.20.6363.033; Wed, 10 May 2023
 20:53:56 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: Saeed Mahameed <saeed@kernel.org>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>,
	Jacob Keller <jacob.e.keller@intel.com>
Subject: [PATCH net-next 5/9] ptp: Add .getmaxphase callback to ptp_clock_info
Date: Wed, 10 May 2023 13:53:02 -0700
Message-Id: <20230510205306.136766-6-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230510205306.136766-1-rrameshbabu@nvidia.com>
References: <20230510205306.136766-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY3PR05CA0052.namprd05.prod.outlook.com
 (2603:10b6:a03:39b::27) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW5PR12MB5624:EE_
X-MS-Office365-Filtering-Correlation-Id: f6c3ac7d-6048-4957-896c-08db5198abc9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	UHVxVmds5z1iQ+PxLZoHkWPT8QZP9DLBfKJKEWkh+2sFt4AoFGQjF3InNrRLvYHqKgnaWOBsAr5Nd05LxMQx19JVwI4DFCY7addbvQ4m+t6Y2dqfJtgaVumjUKfOLijIZRJHNAHFWjNAk2+GDNYwnP37s5I9aU5IPP0vz3nlhfzPJsD1/cMWXVWc1rGdHciNp3raU7Ph48tUE5+84pBI7arnU9gTvJQXytudEpfv7jmvlJ4qkMV/0GFgfUp/5kEM/VDYXM0mICijTG91l8B0YLZoY/N2FKuQpCql7BaSteT2bWmHiNWg9WJ/JT/wXQFHdzMDAgQYXwaMpqBiq6ccW87iCcZIKOz5+6xnX2WUVtv707ee/y4/sPhDXiEBlpBZ4Md7+WUvAD861MSOV1sfvowuw8G5n89jKTfSu/7bJZe5Z/0Czu50TcsynnD1tjSq6cTZ1onN+LAgekwFvAn2OAhk7yizDoesoQy60mlziOx82Ow/MFa4LVjrjO468HF2xwbwg2ZmYyMQPkYfv/C3OicLLD5znZeES6K1TzAdqW4f/r93Xenx2UqBnyhaaSWxRhccvebh2toQu3EAqBqbGuTrQocfSfqOggLiE/PDhJ4CTwYoQIMTTPbczw+CL+Tm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(39860400002)(366004)(396003)(376002)(451199021)(86362001)(5660300002)(41300700001)(4326008)(6666004)(38100700002)(316002)(6486002)(6506007)(6512007)(26005)(1076003)(478600001)(54906003)(36756003)(2906002)(8936002)(8676002)(186003)(83380400001)(66946007)(6916009)(66476007)(66556008)(2616005)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?VYih3nYRC59WhgbF/jIbvM6XcsJebN4AULoLIuRlAGQh0LJXoNFf6vRMRw7k?=
 =?us-ascii?Q?mTWwtA/Ons471AjKZzjXvMQL/wDiCK44KvGAaESWXfr4tEffRq8zZGljB5VY?=
 =?us-ascii?Q?ZVOVJdLXxDBNO6CI22JBwNLTKzMuCrxXzIdj4pRBhAiPub+WtLRcCJzOVvom?=
 =?us-ascii?Q?Mnup6NdiUPiK6iYEr2ZdXB4Htcfg65L2FD3yedO9y+JC2oJX36n8k2elKoJZ?=
 =?us-ascii?Q?1efJmNpzt8KBRe24NuWIDYUGQsKg/kBOQkGBEo8wcab0bIJSkMMdM6Fi8AlV?=
 =?us-ascii?Q?XVkfpWVNkdCBUbNwGEbsNw0cA880EYqgDVj272kYXSnBp4tVFOFNLehxxx9I?=
 =?us-ascii?Q?0zTo8bUAXGiXeFIypX50JPW1Mp7ojTVUQhzDBqOZbh9LkgGDdJVsurni23lt?=
 =?us-ascii?Q?CHmrDSgf2jLBUvk71ilh/E+sWks5Jdbf4ovK34uY0HFsnFWs7ut2HLDjOfKS?=
 =?us-ascii?Q?wIHwZQH/BTG/3hbvGoUbZ0zWuPScB7RM7nM/UfLdCCag6JdwvGD+34BmyuI7?=
 =?us-ascii?Q?dCu88RKHfkWlxOqW2kP3bIb1+Uo358fLu8/ta/LjXiLsf6CSBbSwUaW9QUmv?=
 =?us-ascii?Q?8SjFAC9zmlR1BagYhUmp2zzSs6ynzWO+9lOU3QCHpzSxILNqoX3NtzIkrpsI?=
 =?us-ascii?Q?6rMQ1xmWmZP0uxX0WJDzTqEPPusULUTCD9euhkheqAkaH8/GmkP/Euuy4dm0?=
 =?us-ascii?Q?ppWmagK3lT9I0L2/Ouz7deNdqQIHCw6pQ8vzzU8lTz0ZCA4Zix71+xvEZXjy?=
 =?us-ascii?Q?ViDE7XvUkA2MBJhuFN1q6SQorDuiNvXn8qGHP1g/zSHGmOHzyNuBD0azahzs?=
 =?us-ascii?Q?crZGxPUkrPxrP9L+hvgKurooYvaeYQxHvk+f2nY5R1vHemLW5iMxYkjcIiuQ?=
 =?us-ascii?Q?JvD6DmCf2zI9PeLWDii2UImJyMjuAEk0kIUv3+RYBLps2WZDOaBgfBByCDcW?=
 =?us-ascii?Q?2hbaqka6d2ON6UDjHUlhoJYgDvkBOnEZ88Pz5lZYkKWyc5WYjF3irS+e9iSM?=
 =?us-ascii?Q?kjpr8QlzjE5Wgix7dk6ZCvFBgkg5AAU1uhvybi+F8A3DTkZjEU30W7Hd1FkN?=
 =?us-ascii?Q?BVimPrtGT2/nAqVQs8mMaf3TuqOjcITpT8cph//XIzikcj28qnqRO2NJmIhI?=
 =?us-ascii?Q?PtieGPjpgbpHqSwetDBvNH7D5wuV0tQnlKBHZnickzz2H0PZ/Wpj3pwJ5/N6?=
 =?us-ascii?Q?/scNgr0tsrVfxAG76BlQlj8gpLPnQIoR3adVPfmtRI7rCWcgvHYfMMQJeaT2?=
 =?us-ascii?Q?/4kcMtuQExQLsOKYn0eX8WJ4wtZSJo5sRrV0h6B/QjeAHCktIklUz0y2ud4Y?=
 =?us-ascii?Q?beSTSw9jLJlxOkyylutOIS9MBWOSL5yvFmGzfJWVV8SN95uxYmuJlzAYwT4w?=
 =?us-ascii?Q?GrfDgKZIytSY/TrI4Yoz96AufNYkuMMvhsKBXAy5aOCAVEr5K6K/fhJIiYOt?=
 =?us-ascii?Q?69H4B8jsly5XeHpegamWYtQU8vgL6zbkF7I4rS7yHY1bpZTwjzoEZ9f7h3EK?=
 =?us-ascii?Q?h8sK7VXqhEHOhCNOguu+eP6Za4zaywbkUY42wmjF3SYiHl9CYtgyGH86gZoh?=
 =?us-ascii?Q?seUXMmgRKfS3vykiIIJo3ee2ufB/hl9PmhiBxqrwDds1gzrTiRQIuFXic/3h?=
 =?us-ascii?Q?/A=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f6c3ac7d-6048-4957-896c-08db5198abc9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 May 2023 20:53:56.3990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /EjAfTobtk6s7BqMF0itNeOGxnFsCTnDZoLN6O2QP8TUfQErPzHArOFiz0KGpCA64Qv5tN8ZLkBFYLZ7kWFv+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR12MB5624
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
index f30b0a439470..62a5fafcd407 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -27,7 +27,18 @@ static ssize_t var##_show(struct device *dev,				\
 }									\
 static DEVICE_ATTR(name, 0444, var##_show, NULL);
 
+#define PTP_SHOW_CB_INT(name, cb)					\
+static ssize_t cb##_show(struct device *dev,				\
+			  struct device_attribute *attr, char *page)	\
+{									\
+	struct ptp_clock *ptp = dev_get_drvdata(dev);			\
+	return snprintf(page, PAGE_SIZE-1, "%d\n",			\
+			ptp->info->cb(ptp->info));			\
+}									\
+static DEVICE_ATTR(name, 0444, cb##_show, NULL);
+
 PTP_SHOW_INT(max_adjustment, max_adj);
+PTP_SHOW_CB_INT(max_phase_adjustment, getmaxphase);
 PTP_SHOW_INT(n_alarms, n_alarm);
 PTP_SHOW_INT(n_external_timestamps, n_ext_ts);
 PTP_SHOW_INT(n_periodic_outputs, n_per_out);
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


