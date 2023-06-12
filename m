Return-Path: <netdev+bounces-10237-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 09A2672D30A
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 23:16:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF0811C20B97
	for <lists+netdev@lfdr.de>; Mon, 12 Jun 2023 21:16:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FBAE22D47;
	Mon, 12 Jun 2023 21:16:17 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C9F8C8C1
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 21:16:17 +0000 (UTC)
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2079.outbound.protection.outlook.com [40.107.244.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1E14C23
	for <netdev@vger.kernel.org>; Mon, 12 Jun 2023 14:15:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LslPnE8O7CIryg5nE5Ypm5qGCCZNsGKNDZaXvOlIBVGZVBMZXZvln5T8iwM4qQwFQf/86xO9oy28pSKnXlreSZ4bpyEXKIyISlQMVNWRIR6BPZ53eVuEk9s9X3qgTneVO2dBt62BaJoRDVnN5Olrk20LblI/DMigU4xwc1G2p0aZm13wRm7A6QT743Lt6FvUZfyXwHr4Prf69JfN0ofoG1futpxNoXTATBzFDkjL6QnwabApgzxh7NlW3Oz4/EUR9uk4HQgvXdgPwYDagLUQDUX9qUUE60hqEw1FaymwyPTj3VSxchqydWN+Yt+OHAA+wst61iWgTr14yptY+5pfVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5PvU/sNtMyzXBqHY/rlAIRO2jNajjUo6PrekA5cpv6U=;
 b=VifSC4uAtshJX3vq42kWDElXAmoYDK+SmPc9tTpvsFTNEsjuJiL423l1gXHiGPk5ji2u4cFr1ILkuwaG3wSPqsnbwCejm45uRzwnvsHpV9iX3bRhg9emy4RtrXRUrsRJndZhAkKlFMnk/nHTFGWG8azRP9YAXavPpYRxi/3y23j2bQkSZR3OqV0XUH6qAmkP+XeoY9H/TZnm6vDJwgIEI100ZTd5aP1ms4V+7OUTTXj4KAkBbqfPch2fD6U/ONdH5g+NTmcdu/Bn1r5z18uI0pwp5F4SKIUm/J5ub538KKxIGijwpAoprbm7MaY8iQ0s7xfYV2JZVJzJj3JfZV13QA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PvU/sNtMyzXBqHY/rlAIRO2jNajjUo6PrekA5cpv6U=;
 b=lcbVyXkQ2gT0Td8vi4JDR109Qwy7aW8bcTQJTLhVUAqNoAddyAzokDhFamN+elRVUppCIA32/ggTFnoZMabkqE5hORpoguKudzL5F4mU+MHQPWz+HC3x7GsrpiuUMvfkSqqksinW+W1nsf9JvrT/Z4K5XgghFP1BacT4uyFtLd8Evf7ELFvMEGcdgjR9Q1jgFe+V0uqQEymIX1wMY6oMttU+fvjJhrUwt+2YseNq56DTbEJYTaGnwiJR+wXFaHw0ZqRJlz1wh+PcJZbMTlvGBUIIOb5vpLTSfDTzAzQlJ+Qom8PsZWwE+KJhONdHar0Ay9dypFHzYOcBCa6TnZFkWw==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
 by MW6PR12MB8733.namprd12.prod.outlook.com (2603:10b6:303:24c::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6477.29; Mon, 12 Jun
 2023 21:15:27 +0000
Received: from BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471]) by BYAPR12MB2743.namprd12.prod.outlook.com
 ([fe80::ecb0:2f8e:c4bf:b471%6]) with mapi id 15.20.6455.030; Mon, 12 Jun 2023
 21:15:27 +0000
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
	Rahul Rameshbabu <rrameshbabu@nvidia.com>
Subject: [PATCH v3 1/9] ptp: Clarify ptp_clock_info .adjphase expects an internal servo to be used
Date: Mon, 12 Jun 2023 14:14:52 -0700
Message-Id: <20230612211500.309075-2-rrameshbabu@nvidia.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230612211500.309075-1-rrameshbabu@nvidia.com>
References: <20230612211500.309075-1-rrameshbabu@nvidia.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR01CA0004.prod.exchangelabs.com (2603:10b6:a02:80::17)
 To BYAPR12MB2743.namprd12.prod.outlook.com (2603:10b6:a03:61::28)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BYAPR12MB2743:EE_|MW6PR12MB8733:EE_
X-MS-Office365-Filtering-Correlation-Id: ed3a1de6-0886-4fa5-a18f-08db6b8a2533
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info:
	mQi7d9WynrUBSXrOTwQsxtdsCmOMXKyrT0XQJIUH0/jg7gNs29T8NEhhZv9Ys1O9j01GoHbEAjt/HZWo7kxjzMqyQrRFVZ8Of3e9qyct3NrmrOE5ceYA9pt/h+7BzK0AT75lEA3IEo0w67A5gtwRB3E9iI1r59KwAL++uIiW2FcoL7hzNzN090qIxVpbRaWSW5ko4n0vsGnaOb4nPFIY9812AA1JqoFss+qADjPOQ962Najw5NMMkweim6JRHwWC3XOi5RZwBkrhOghk7B+BfZAKOLXS02/RnXWwMLXvfJrFwqFyaVp+aRdFq3VKVy4ZsHP5SGAQvMMumzCFdeQwYq0WV5ul6YMLXCupN/YUDxaFaVwLcJtINqsS9hj3xbA0VR69UQ4twSVIsaw03QA9l6eFQxoy8VI3Nuyqoixbt41ZEeflRFnO0dz8oY3cz9NepA6XlUY5RjVPnrum1/qh2HUCrIbytWWgb8M9ZE75Y+aforc9hT/702uwSu1fnqQlMtndrnSoW3cHp2M8xH3OCbdYxO5AFm1Wx3HxeEKnXsxzApHLu6hae5kJ5wdjakqv7Yx3cuby1QZc5pFyMAl32hYpxtUDrCA9OiCw+CUUEzvZrV+ipKy/Oc/E0FvShNPD
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR12MB2743.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(451199021)(6916009)(4326008)(66946007)(66476007)(66556008)(36756003)(186003)(478600001)(54906003)(2616005)(2906002)(8676002)(316002)(41300700001)(107886003)(86362001)(6486002)(6666004)(6506007)(1076003)(8936002)(83380400001)(5660300002)(26005)(38100700002)(6512007)(142923001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?zMd2p2QEUhVA8VL8gfv/GX0Tr8wdmonJbK/GZkvAuP/HKu7AC10HgThGnhWn?=
 =?us-ascii?Q?AOeWlWgKTEx2C1J+OmHhgEVIO/HBX0T2iU8J3ZTlJ+cgagVns/9JXIfk+LLY?=
 =?us-ascii?Q?ibzSIXajZi1Hyfg4hzNnW7rLJhSWUyiJSwEelEVgjHWhCuRguaOsPPHUzDK7?=
 =?us-ascii?Q?WOB5OONujAmJ8GXP8Qrn325jZuU3o/2VOk25ymUU4E7sheAo3KSLRkEDUrkW?=
 =?us-ascii?Q?iJ3zlCTPxjBEPu8R+SV0muhWRl7T6Q6yMiNEfi5QYWhHlbcULX212wjnM215?=
 =?us-ascii?Q?/e0OSIagVYwTsRblNTsWWk4MVvuh9a5D8o2cJQakKrK0ATGdxMWiHY6SJ0I0?=
 =?us-ascii?Q?vdvysk/CsIKtwJfB9CuLPsLgXWP7Wosrt48GU21jfX6O2ikL7in8IfrfC0Jq?=
 =?us-ascii?Q?cQZIqYCnJ60IbGviwUcJbZRfcQjuE6I/O3rOG8SIwv9YlWwJcc8iL7qogcox?=
 =?us-ascii?Q?1LsLM3QkmooTDz3DO4lRboWpsGWpEsHoWo+6W8l0kTTUcwEZVx7BwoX7r9BN?=
 =?us-ascii?Q?ZbEvsQKxV60b24pRc1F3AgRPqu/OoysPDc8IIklTxh1nAGSvxFA+vDLxDTh4?=
 =?us-ascii?Q?JBsZeBpKapcN3VZRBKQFX7B5Q00aXo6AIY3mgzmpHvLPFwOElSpGjoMkBZtx?=
 =?us-ascii?Q?Mo73GK4MS54qxDoCQ09sjn4Wefg3RnvaMYlvl+qKEmLTw69MM6OdeP7UikuV?=
 =?us-ascii?Q?gWguoC32v0XmjAY+BkOJNjqeemTl1HFgTvYmbwxSbQ1PFkR2P9uwOaZ+On5x?=
 =?us-ascii?Q?GWdTWaFB/LHZ7k0xUJjfBdTOeaT77XTN8SrQ/Wg3QwPh/Ufn8perqrdGzi0G?=
 =?us-ascii?Q?RWgNrluMdHiBFbZKcGhCfkq51OgvLXu8nkRBpU+l+pQ2NMjU2imA7VzUdmBS?=
 =?us-ascii?Q?tnsNF3tZPFBbjhas/BcWdqP0J7SW/srB6nFIrj7of0beiyHqoTt3ZB89SgYd?=
 =?us-ascii?Q?Rzc/oWmu6e7bbHEA6I4iEhbWOadpsMYdzaV/Ekl8+V/Fu2awDBm9xXwh66W/?=
 =?us-ascii?Q?ygEVj79QOpGyVdd1+GIeWljv7NDL8otPjkStdkv2X1NOWkY5szjHl79sb51M?=
 =?us-ascii?Q?l6iMshP6CrHXzyMV146RRIaU2K8G9JVypnjKOfUz/O8WtAMr3SWYhd8HcBzr?=
 =?us-ascii?Q?5TRGmmudzFN4qPNbh54/GbddaU1U1Ie1WUknKrUF9gfenmNObSZhHw6AkmOR?=
 =?us-ascii?Q?W2bHoEDXKlLKvxnHCGQKc3jIfTKTywLP4XnlHlgH30zgaq8Dv8TNyKX8Yl3v?=
 =?us-ascii?Q?9Ri9/i6DlJrk2Ckddc4MpFTanGNxRQFRN9t9pmdgonz3/S2zxJR/uxtKMy7M?=
 =?us-ascii?Q?QVvDloUELkNkdVUIJdl4sk8uRfZiHDPJ0e1Gmp8pkjyOSw2FmvoSMlZg6T+t?=
 =?us-ascii?Q?ymOt/r0IiWfTq47UBCv/5/pGTgwD2E+7vRjnbSF+p861FBBQn9xiDHfsDxMu?=
 =?us-ascii?Q?5NRi2bDmANJr9+kHpnf/lvIOGorMOfhzAC+6Cc7pmclNx1Eifm9bJqI8i3to?=
 =?us-ascii?Q?qsvva6FuWLsCRaHZ+XN+uMWNbenxpcO2WxshZCedJvB+kNDEpgwiVaz9fAMJ?=
 =?us-ascii?Q?Mml616NdEVb2nVILRkwBZdvTktpxyGZbJQzdwiUAqu13zN2oeSIsP3y/aM05?=
 =?us-ascii?Q?UQ=3D=3D?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed3a1de6-0886-4fa5-a18f-08db6b8a2533
X-MS-Exchange-CrossTenant-AuthSource: BYAPR12MB2743.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jun 2023 21:15:27.8160
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5KZ67IQCW5pvH0Cd6ork2v5kfq612fJ7rCRLPLjzxj8m4Eb5dq+BVrA6xzuWIuCQ2Tt3KWFq7BbTwz8u7k/4fw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR12MB8733
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

.adjphase expects a PHC to use an internal servo algorithm to correct the
provided phase offset target in the callback. Implementation of the
internal servo algorithm are defined by the individual devices.

Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Acked-by: Richard Cochran <richardcochran@gmail.com>
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
2.40.1


