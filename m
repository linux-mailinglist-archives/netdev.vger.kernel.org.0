Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A6A4AD115
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 06:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbiBHFck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 00:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347013AbiBHEq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:46:59 -0500
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2125.outbound.protection.outlook.com [40.107.244.125])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86963C0401DC;
        Mon,  7 Feb 2022 20:46:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k3TztukKWmqbWuD3nCBvuH80EyZGHs6xQ3TAF/KG1paGUxcbR+7GcFCuPZMDGhl6nSilGjqdvxruS6IBq5CQq8Frck+zHJtCRu5nElpg8Ibt4OioONw+oc0iVO5t7KrvgBkcsXuIPAhvFgwFN8+CrPQKyViMOTn2kuSanzESGt86RJ+YNjAsmUpoEh7KqgguWwvFaEoM6n1rFAfzutxm4D4T0XsqAqJ5YsfJ2GH1ycYTPHuA5Ez/Fybkua04uSsS1faDbsCpJNwPT36ITLzOR0ZICl7xl+ZLi16FbyNimTtvegdFGN0NLPU7I1z8Qf3/IWiR9rXCfJykIkYWA+rnog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u3Ozhtl3Vm4r+UsISOpZYHXfOOcE7BoKeT217UZplhA=;
 b=InsgP0sDgQOpUg558aSRFr34fkTXFbfhi88r4zBVSM6SJMhZDn9IfemsaAQa92eU9p8xFZKGBYzU1EW4VgbWEIzGCxXQdlLLdKdYHMRSMtegIhEBqcZoxKZ8/oic0a1RwDCJ9O89Og2o9dEo2h2WRVZjK065k7+Ti6ALhVjdyRTbsHanwFGhZ7jvpViHA8l+Od+ctyp2/sLmPHrLLaXSuO4ydzLs+0Fy+Dqf7gzwKPYdqBz89ft9vWTiAo/9FakHstFRga7k3MmAXuwjVuw2zI/qD3B25mjdF1/I4p4NWazNSKwV5Q075/9yYBUr7vbgytfxyKCmg3ERXm3KTQMh6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=inadvantage.onmicrosoft.com; s=selector2-inadvantage-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=u3Ozhtl3Vm4r+UsISOpZYHXfOOcE7BoKeT217UZplhA=;
 b=OtOPJDt4LPVO+jlwFF02OJRfVK0QUyC6POEsLb/htRqwWMDwrUyWQdwEmqVR7oSLJD9/C4HEhRiB241FPkUU4oy5C0mFzxDFw5cj+zrlmVTe4Cp2a4RL+SQyHu8/Bsfoeq/N09bLorsbWc0YdRF/7NcpqXvAxOR1J334Kc9JkB8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=in-advantage.com;
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37) by DM6PR10MB4394.namprd10.prod.outlook.com
 (2603:10b6:5:221::21) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4951.12; Tue, 8 Feb
 2022 04:46:54 +0000
Received: from MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f]) by MWHPR1001MB2351.namprd10.prod.outlook.com
 ([fe80::2d52:2a96:7e6c:460f%4]) with mapi id 15.20.4951.018; Tue, 8 Feb 2022
 04:46:54 +0000
From:   Colin Foster <colin.foster@in-advantage.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: [PATCH v5 net-next 0/3] use bulk reads for ocelot statistics
Date:   Mon,  7 Feb 2022 20:46:41 -0800
Message-Id: <20220208044644.359951-1-colin.foster@in-advantage.com>
X-Mailer: git-send-email 2.25.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: MWHPR17CA0090.namprd17.prod.outlook.com
 (2603:10b6:300:c2::28) To MWHPR1001MB2351.namprd10.prod.outlook.com
 (2603:10b6:301:35::37)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90887445-3aa7-4d9e-c971-08d9eabe07b4
X-MS-TrafficTypeDiagnostic: DM6PR10MB4394:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB4394B9EDCEDB25812C11CAEBA42D9@DM6PR10MB4394.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:489;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: wLR5ZJlHGo9FVZugRzTBWinzKj1qa18yYKMYtBYqmb+cYQFYX3PYv3mqfRjV5t6WaBWCddGpSxaZwpMztWhcj5uFzfJh0+6WT1DJ6I3k36GeN3VorusC1YPZO6l+wRoLRH8I/qd2H7+G1z9vbSq8FAZUVpO16/9EROQx3UaFEzvSKFH+lQ8syj9HNljb+pDp9JtvXuN00h6RkQ0ldfwsxU4E6h/Cv2pMNpYihnMyy3LSao2tNBnmB2fhK7Iwy9Zh+9RY5UhO+CWARG6eVngvfiXqlg8Whp/10T92b2YkebX7LlINBYosA8VP9U6s7iavx6nCko/CT1qPT7ldB5gmNchVG2I1zzUFHiUU8k9A+nZzF3Boa5B6thSJaLTmPuzr+FxcLopvasmFLsJEahVDlX7BULRQ40nQ0sca8cqp+l3aNQE4Yuqedg66VTrIdyIfIA4Z78W296JCptSQLUa4FOEkI/Wzm45ZGBmZozyOhZaS9qoUAH0vFOyyqnuJsN0snHNeHe6KdUkyn0yf9DeYJKaOLPuJbPJlYslFOnCztBESjJFRQ7lswps57K0Y7go/GhfT1Qo3bitGOyg51+eyJ2goVOCT2kCO5D1dYTjjHS2Fr6Bko2JTT/WBpMKuTohsZn0F/78aGMNrqrTeUXRxde/EQlVJGJ/8F1Z5cEJjJid79/8+yDdan5wmcqHK0YMOi2GQnDfVDbRdC49G2ySK/g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2351.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(346002)(396003)(376002)(39830400003)(42606007)(136003)(366004)(52116002)(1076003)(186003)(6486002)(6506007)(508600001)(86362001)(26005)(36756003)(2616005)(6666004)(6512007)(54906003)(83380400001)(5660300002)(66946007)(8936002)(2906002)(4326008)(66556008)(8676002)(66476007)(38350700002)(44832011)(38100700002)(316002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?QxnwwKl5bfgpExOpxdI4CnrQ+2VmrS1Ksttn/ISn7FEHHVQpuFiL8NJRTViV?=
 =?us-ascii?Q?1ayoSMJQ9KDkbk76vRa+zFNzMQQDsurUVX2AI23jB9/IAP9v4BirmlxrQngA?=
 =?us-ascii?Q?7w2Zlo2K3Ao+2KP1qz+aUBV814NKs0uxEVeMWKC3DTxlHrMWWoJ28NBaaTiO?=
 =?us-ascii?Q?gO07CUFAU6At2RUZsXuAzCCiCjTDnQPQ0DmgaWyfEJif9WxK6c+4BN+3eCkF?=
 =?us-ascii?Q?Vjv58qoLLnfGH91F/28z1k42w9mqq3zHRI8m7TSuJOiuIkzZXvQ+zDZGmFLK?=
 =?us-ascii?Q?NYSytRdcYsFonesw6Fxp72I4Yr3nDBrRpnZ2vhlY2iNP+fSsqNAMifYpb9yI?=
 =?us-ascii?Q?hEovlRa8pg1w/7R/tFhgOwwT2YkWqT9pkxYV7QMfBWc/ZQagogjK/QL7o3j7?=
 =?us-ascii?Q?E0h+nCYED4tMKOVmGcH5YSY3Rpaw3lI8xz6sw5BDheJwWakf+Zq1Ars6EE98?=
 =?us-ascii?Q?toPtLDTkL/54aNdCW4+JD5Ppu8KHbe4Ti1AognUedRYHAIX1jX5o1un6yXG1?=
 =?us-ascii?Q?rryBl356z2v64AegG+t33yK0ASGmzGY/3XLZ6V/2DzMhZe2JCj9s7y4/i6AB?=
 =?us-ascii?Q?ry/TUhBloidmGIpHL0q9+AmDgn+zgdggnXZg6dSf6S2s8nb8R+MqwdT7p3q9?=
 =?us-ascii?Q?vlurvh1AL4RnqSunB7imfwLGH2knFKpoKOhvqput8uHmr2/T5R5LnxWzmMwV?=
 =?us-ascii?Q?+fJ/km/M2MqcOwgSTXfoS9yPnbvia1UGls+QBDCrgy3/hpmWFQ6nCg0p/Nai?=
 =?us-ascii?Q?4aIjjlz+9Xgi7vbA2m6GL7hwKozJRGooqPMOcwvznxHe+U+uhjHRZVZFyrUm?=
 =?us-ascii?Q?ASuJOxfXZC5FKIH/cYf0kme5HS4pG5gYWHSVmBrtzWUZNOjTHA7xZyxcCK/V?=
 =?us-ascii?Q?g6vw/2B8Qvbi/nUcP/QTMJXP7mny6Fw/ztHGqkP9xRlvD+eAqWa5fZsKPPMY?=
 =?us-ascii?Q?CSb8j67gs52bdlHAGYZeu/N+EyjFkjxoBKG1CsfUR64xZt6UwJPKhOD157WG?=
 =?us-ascii?Q?RfipNfLY9emylf3FzKLytAKc0QmnqNG7djSjHwHg2RggrSQP9pwW5wz+oZEb?=
 =?us-ascii?Q?3qIx6RzNc5vIv5sudF6yms9lAbIfTVZIDoYN5aQckpsZKZ4QSlUA7C2Okymv?=
 =?us-ascii?Q?etsaV+KAaHxgendwCaSwYK07EKXAM/dZzjy3NYPvOUJ3jLDydqtN2XlTJz9z?=
 =?us-ascii?Q?IeF7+Nud/DHujN0oLKu4m+Gvn72ghdXT2uWgxqwTVqwnTczsuwpwdm+T9HbM?=
 =?us-ascii?Q?Qu+lN9HWGj3fizekMnHkafEIPGxgshg2A3FA0BfCcY4e55ZkIFAP6KzrWWpQ?=
 =?us-ascii?Q?enQa9zMrIVeY84d0fH9W21SS0bPH1IZFY8TVYnwdG5y3ZbbRZ8Jm3aIOe+G+?=
 =?us-ascii?Q?RBVb8xVLCU8ZSlRdYom1bHQ3r6zHrw9pUNWFswuqLwtZzZWyT1cG5K2LcEh1?=
 =?us-ascii?Q?s6AK1iQnjLW7LPuLxjk0d6zzBUg6Q0qi/7R66s133ePKFAB+OCxd1tKwFk6s?=
 =?us-ascii?Q?61ZCq5C2D/N+TnGv+T16KlMUcSZUtWC3Y9BeMkoanUXXdn9j8jNv0JJ+UtX+?=
 =?us-ascii?Q?ioQvIAitgYfcvIbdrQtGuzMkqetbPIVBtX5C5uhQTN46K6Fd/OaIx1L0Ie5l?=
 =?us-ascii?Q?sD4R4ykWPw6tsm9avktQMOWx2BcJqpiD/Zz7KsTkmcUzQVnc5+YlsY3Sf15T?=
 =?us-ascii?Q?Kzm136NCNy4TZT5L3nsfJDh127I=3D?=
X-OriginatorOrg: in-advantage.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90887445-3aa7-4d9e-c971-08d9eabe07b4
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2351.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Feb 2022 04:46:54.5641
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 48e842ca-fbd8-4633-a79d-0c955a7d3aae
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: wG2UcfLjTxZZm64N+Yx3eOla42+7hZFwdCplaCbJX2pTWpTs+gUQTb2dHsNUsBfoIKvNjTmwBMwcf/C+4wKIfZsHKrWFi1e8AcAt7pJBb5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB4394
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ocelot loops over memory regions to gather stats on different ports.
These regions are mostly continuous, and are ordered. This patch set
uses that information to break the stats reads into regions that can get
read in bulk.

The motiviation is for general cleanup, but also for SPI. Performing two
back-to-back reads on a SPI bus require toggling the CS line, holding,
re-toggling the CS line, sending 3 address bytes, sending N padding
bytes, then actually performing the read. Bulk reads could reduce almost
all of that overhead, but require that the reads are performed via
regmap_bulk_read.

v1 > v2: reword commit messages
v2 > v3: correctly mark this for net-next when sending
v3 > v4: calloc array instead of zalloc per review
v4 > v5:
    Apply CR suggestions for whitespace
    Fix calloc / zalloc mixup
    Properly destroy workqueues
    Add third commit to split long macros


Colin Foster (3):
  net: ocelot: align macros for consistency
  net: mscc: ocelot: add ability to perform bulk reads
  net: mscc: ocelot: use bulk reads for stats

 drivers/net/ethernet/mscc/ocelot.c    | 78 ++++++++++++++++++++++-----
 drivers/net/ethernet/mscc/ocelot_io.c | 13 +++++
 include/soc/mscc/ocelot.h             | 57 ++++++++++++++------
 3 files changed, 120 insertions(+), 28 deletions(-)

-- 
2.25.1

