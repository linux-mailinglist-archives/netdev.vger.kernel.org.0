Return-Path: <netdev+bounces-4802-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A8B9170E6E2
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 22:55:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 723D21C20A9F
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 20:55:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8BDF68F67;
	Tue, 23 May 2023 20:55:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9DAA958
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 20:55:14 +0000 (UTC)
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2059.outbound.protection.outlook.com [40.107.94.59])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465FCE5
	for <netdev@vger.kernel.org>; Tue, 23 May 2023 13:55:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nmizB8PzprMtwQek5lsFJicpQaxypozt7F9Ok4ODuStt9o1D0bxgJ80GB0HvBI+g8GYQmraTf01E2eOKMlOaZHl6bkziDv/1y9DKP6L7MBAr5SZGuNhaWfKEF4+msYr2h8AFASyhL8TkvowSp0HM0q0OXIUWmVMdfOXz731Iq0366VJnsxy2fhxAuetRLHM7jh8890ArvQHaUSl2RLPJkE42dzz4fidIXw8ww1LEZduwNoZPZ6QhqUMMzT3DVqy1hDwkeOe3LqQO4C7J/69BTOgv13o54smaGiu5UyfFbtpJMcJPDwobI7wxVA8VyZGZc74e4a6nis7oCUNC0QuGYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nuW+8GDzhKm+uvzXEiSt8SjmiMeH5IZgtMXefVoz6zw=;
 b=fG6yGqvTi9QbfbW8aCzalvN24ipUcUFNhTUuxnHiqn6XM/RBGrciBEnyxd+sI9P8YTCt0YhHa5P8HfanQu54HcJd9o2wS6zKyUbaaA6WBflsNiBFQFbbftiApQBJYoWhlK7+UljYP7LAX9YW4J3kklHHxNlPT3kyPBOJ+3xs5eIJBnYNgUpn5eBq2NJundJZZcqCWJsByEJIm7QK+bDz+fRt0A/0zm0x7R9TsaOURgnMkq1tZetjSBKigqwuUXJINp+BoLpcx4UR6UEW6boXHn08nL33xitlcHk2t299HQd9tinxIe77eYhXqNvCD6ucHQ1nO8iuHQnQjd+dKSyt6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nuW+8GDzhKm+uvzXEiSt8SjmiMeH5IZgtMXefVoz6zw=;
 b=nOABk86ahpThi4OWjqT531bBN4j5qgrqclLL8l35vUZ8dQ2Xkk7RySqZfYt/yxzxqC3NgdN7CmY+SJv641NyjI25/rpwTk1nC11ZaPrh6Eydb0eAXPpfyPRBx0CqB6Mn2wt5iwlrGVzyBP5bbv4MBa+8j9+Rzb14o0vTd3U+Tata5EyKTOYBbXUcqqQ31v9IVpPqgiSuOP+YiuUsEtEv0bdUaqpOunxL/5jdMwA+++HgCQxY3mm1G9MQaTR7Zyyk3jdmiZaSfvRXR3SvlbtB49eUQBX24TU2XqX1/c5+BU/v8pwzCB1s4CHYS8mjgOSiPLv4t/zST+rWukInibmNBA==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by DM6PR12MB4337.namprd12.prod.outlook.com (2603:10b6:5:2a9::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.29; Tue, 23 May
 2023 20:55:06 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::f3d4:f48a:1bfc:dbf1%5]) with mapi id 15.20.6411.019; Tue, 23 May 2023
 20:55:06 +0000
From: Rahul Rameshbabu <rrameshbabu@nvidia.com>
To: netdev@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Gal Pressman <gal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeed@kernel.org>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH net-next v2 1/9] ptp: Clarify ptp_clock_info .adjphase expects an internal servo to be used
Date: Tue, 23 May 2023 13:54:32 -0700
Message-Id: <20230523205440.326934-2-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.38.4
In-Reply-To: <20230523205440.326934-1-rrameshbabu@nvidia.com>
References: <20230523205440.326934-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0060.namprd08.prod.outlook.com
 (2603:10b6:a03:117::37) To BYAPR12MB2743.namprd12.prod.outlook.com
 (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|DM6PR12MB4337:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b856ce6-3ec6-4f2a-5d88-08db5bcffcb4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	RsuDI0s9rpmnpCsBzhEQwrbqfmU0Wn1Ueg1wwENh8q5WlojF42RzYqrdjLiNnTE0XFMyE2oV/kBdAdFTpl3qnqIDhMJ/dYUywX2G5QG3YmFrFq1G+47wLWf6/13nfgX3JRqxKByBwOM8CroU3lBozvZz0rD5OY7pz40wXUGFF1VYaAiAMjYYdqTIeveIOgIQISxtBv+lQ1MZiQI7uqC0FRzzBaPr0tROLPDL4sC0IRpOVwodJt431QObs3iX+H2pn12+LRHqFVkqpBB1mGyv/IiEVJuysrMNZvwFa0KqVQaS6wWSkkjgBaaojicGFgOD1coknQVFW/Uacl2eGSqG63ixe6J+yWSLf56xp/0QSN/CvQVrzaipCMz/of5dHBHIo3/qHZzJcbHGFG5DTVuAE5YTrMqB2vsLO0zK/f9tHUH88JRaoNi8Y6JpFHTUyHJASBe2vHK+R8HPHlFQQJYETzSt8hT45hXsISFOS0vuG0idzqazmeKFA15BzBK66uBgIseJiAsjZx0dRK/ePJ5ruUAbmdGeZ2pQPc/y8kl4wA+jC0o7CjsY32POJVsUnR9PLMTPhljpjvJMQWQwi/jPD5Mcqyf364mNQWnvdUzYxZ5ORUC7lmwJCN0moCsTmWAl
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(376002)(366004)(396003)(136003)(39860400002)(451199021)(26005)(186003)(1076003)(6512007)(6506007)(2616005)(36756003)(83380400001)(2906002)(41300700001)(6486002)(316002)(54906003)(6666004)(38100700002)(478600001)(66476007)(66946007)(66556008)(6916009)(4326008)(86362001)(8936002)(8676002)(5660300002)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?1Nkz0c8rCHK9iavRvSqeF/0jLb+qRkud0mzmh+JIy/TBi/Cq+PX6I1/0HEsP?=
 =?us-ascii?Q?W+M+nECU9wIBDXBlsgPY6/nbfkhxMcRGIj9rZ5tP6EHpt0TueRN23oUJX601?=
 =?us-ascii?Q?UKeVi+c4PN/uJRTnNuXQu19YM+xM18sqEqVRWk1L/olvvRPJqv2EoHfGYHK5?=
 =?us-ascii?Q?acPJWlCH7TbN0i6j4PSzMFfThMRBdxfwO+vSCmCBNMRxRMUQS5bNroLwvhN3?=
 =?us-ascii?Q?/k51Ghx7THE9vi8zCFqhn88Ipw6oe+xMnyZ7PVeKgGGVEIulb88HUHtoF2Kn?=
 =?us-ascii?Q?pkeL8iMjiwuZ7MzbPvr1Zi6rNPyad9FoKJhwPSFJiqckwey2eTuOzZFVQype?=
 =?us-ascii?Q?AYVzcIOtx0VLCmYi/ewysWgranCiT1xZMdua5nZSb9vSEA9eZ7lD+M7jJtFk?=
 =?us-ascii?Q?8ZpQwNtpOGOh5tjMQXwn/zlufQnyGV6YxRJOhWlvUDtHOu6q9u7UzsNvbu8b?=
 =?us-ascii?Q?QlC2GaGxs2G7xoFya4JbP4JMwGNW2aZTZ0ooQIUCJXUMOrf9k9nfZmehH02j?=
 =?us-ascii?Q?FBhSZ/UwB0vmxVBzS8WBdAQc6JIOdpxEjRz+26HlnynF4htAOAHAyPG/Veh5?=
 =?us-ascii?Q?9AYOkE0zkJHeaGyAZakBMk5FxWgKYjze2BZ8KP1aPHjeqPpHGOm9hKpMKnJS?=
 =?us-ascii?Q?pGjo2YyNu0qjHT+RBeIFzcGQdQ+fxhFrNIGgsk5oqVugLFm7VEAc9DMDN0xW?=
 =?us-ascii?Q?eCwphSLnrQdqbbLPGVdt3amDLWZ6NfQB7fuEl4y3PA1eeuIEdCWq43A8Y9vx?=
 =?us-ascii?Q?RRMmMSgCu5pALhiCvV79/CuoSqMdB+bJa0erBQs5IMB/oqOQXiOEPlDlIT/f?=
 =?us-ascii?Q?Z7e0lo0ebJot+ieoFhHu1S3oYtMZ+wvwTDUJUsI90mUcB4wPQhQsl/Mh6jZY?=
 =?us-ascii?Q?GuSsFb8ErssbNLi1DaC1Yaw/lsYLbFYDQ6L7bv5OCuQULHdgJUFJ40pUCStr?=
 =?us-ascii?Q?o9aPujUvC0uZPdl+meM5PvFPO2HEWE6MBE54ucJ3TPgspY9ROe81U1kbnXV3?=
 =?us-ascii?Q?oOleOKThqLOVfy1Yzz15TX45MnCJxvWKb/qbt0fh8XkASLRLNFxmL+EMslrM?=
 =?us-ascii?Q?NVLU8zJweq+ZZ+T8ti2jBlCqiffnPW15ZVivTIEex7SD9+MCFN8S/Z20Ku7D?=
 =?us-ascii?Q?vC03fE1lVJ3fwuvfrCaKtxepi1PSXK/RBvrwuFD33z7PZya56pg4yEnd+5vs?=
 =?us-ascii?Q?RQ7FYMRguquKWaIddef9cEEOubEapfY61M5OWYB2GCGHrYHm2baOQuC3aRyw?=
 =?us-ascii?Q?5oakdDfYdoHggkFwglFODdfQizXgDU586LJipO7haeFdgXhDwM8jPHwjbBDN?=
 =?us-ascii?Q?YXJ7WT0xpU1sCQ/V33HehXCPkYZGZxDtwjZY9N5ugMzSVecVj3/3eCNDhfvm?=
 =?us-ascii?Q?adtIAf1AaTbyAYkg23DmNu+37fuixNC3JufqpKk0ZB+xEQWGziu+ls8PqWpO?=
 =?us-ascii?Q?oPsslpfGZujB66zXTzAJt7cGnZUTIFOn90npsYtJeBdDTzSSGzaq9Fb8g0+/?=
 =?us-ascii?Q?ySQQv+2yGvROL2ytR6dojT3mS+iPIPjtjMzYh/glOp0MGEHKmi0GVJCBuvLQ?=
 =?us-ascii?Q?Ot0VCT81SKGedhqzYvGT8heXEujpOa34+YrpjmZAFrdpEsRgdDQTyai4URuS?=
 =?us-ascii?Q?MQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b856ce6-3ec6-4f2a-5d88-08db5bcffcb4
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 May 2023 20:55:06.1057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: goCMKcSjoImaaMBwFUzZHRxz6v1fdabBM+MUSN5MVqbNZVlVgj7J0OAvaERYqzo/++OAStUSDZGRAyn9+Ixsww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB4337
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

.adjphase expects a PHC to use an internal servo algorithm to correct the
provided phase offset target in the callback. Implementation of the
internal servo algorithm are defined by the individual devices.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
---

Notes:
    Changes:
    
      v2->v1:
        * Removes arbitrary rule that the PHC servo must restore the frequency
          to the value used in the last .adjfine call if any other PHC operation
          is used after a .adjphase operation.

 Documentation/driver-api/ptp.rst | 16 ++++++++++++++++
 include/linux/ptp_clock_kernel.h |  6 ++++--
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/Documentation/driver-api/ptp.rst b/Documentation/driver-api/ptp.rst
index 664838ae7776..4552a1f20488 100644
--- a/Documentation/driver-api/ptp.rst
+++ b/Documentation/driver-api/ptp.rst
@@ -73,6 +73,22 @@ Writing clock drivers
    class driver, since the lock may also be needed by the clock
    driver's interrupt service routine.
 
+PTP hardware clock requirements for '.adjphase'
+-----------------------------------------------
+
+   The 'struct ptp_clock_info' interface has a '.adjphase' function.
+   This function has a set of requirements from the PHC in order to be
+   implemented.
+
+     * The PHC implements a servo algorithm internally that is used to
+       correct the offset passed in the '.adjphase' call.
+     * When other PTP adjustment functions are called, the PHC servo
+       algorithm is disabled.
+
+   **NOTE:** '.adjphase' is not a simple time adjustment functionality
+   that 'jumps' the PHC clock time based on the provided offset. It
+   should correct the offset provided using an internal algorithm.
+
 Supported hardware
 ==================
 
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
index fdffa6a98d79..f8e8443a8b35 100644
--- a/include/linux/ptp_clock_kernel.h
+++ b/include/linux/ptp_clock_kernel.h
@@ -77,8 +77,10 @@ struct ptp_system_timestamp {
  *            nominal frequency in parts per million, but with a
  *            16 bit binary fractional field.
  *
- * @adjphase:  Adjusts the phase offset of the hardware clock.
- *             parameter delta: Desired change in nanoseconds.
+ * @adjphase:  Indicates that the PHC should use an internal servo
+ *             algorithm to correct the provided phase offset.
+ *             parameter delta: PHC servo phase adjustment target
+ *                              in nanoseconds.
  *
  * @adjtime:  Shifts the time of the hardware clock.
  *            parameter delta: Desired change in nanoseconds.
-- 
2.38.4


