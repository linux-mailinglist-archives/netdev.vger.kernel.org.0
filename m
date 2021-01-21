Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5092FF629
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 21:43:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727359AbhAUUmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 15:42:36 -0500
Received: from mail-eopbgr80124.outbound.protection.outlook.com ([40.107.8.124]:15589
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727437AbhAUUmK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Jan 2021 15:42:10 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WfyVFZG5TlHgwMf02bH26BJCJF4d+q3DDN6JfKOFPMgHkRDClz24SvvgDS7qA90Pq7jTohF8fXHgbPRdFa6XDLK02c3RvtL9Bkd83Vk2yYqm20gBXqYMJu1GMDZkdLlgdXxO6nvddCVBo/0LPPrryhHl7/ZIgqde16tQJJgke2xBztu7+XdV0b6aUlAc8ly7U97c+LUKW8zJCesvw6d3KZNIDPHPURmYGNJ4mfESMugHRs18sFFHZCHAcT7jctGQbBWuTSPMCRFbLqSBqdZNW19J3uGnkd9Jvnvs5IyI0ewbnirqI0HJz51WTiXZuimJR94bRGH7KdLjsB7ql1KYVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tm/NMkDv3SArjMTKWFhdftJI+QNms4IaevBmfXtim3A=;
 b=mWIg9QL3e9buPlBGPa1dMHgNRnRnShuKMasKDbAEA8jFK02XZlTErl7HZa+KVXLoOyhFmvljD6KlQSi6bKRR8/BF5XsY62lB/EbfZrZareF6SFERXXR2XbaTFZS+Uy9izn7xVSab5lYg2en/ZupBVvCiQdWwALFKLFrsWSgHdlkKgnnYY6kxRbSSb6RxGok2rR8vFebp0d5J/abpIr6xKF7XJL66S/EFpoKHvuu5XW9uVshIVR5omD3xreL9Sbva4BdmkaDiGgHjlNOjVqgAOQrdo1WJQkCKKUdKiYDIFHXnZXeY30nsfZEKBtuADPPDOzBcA5HYsXJ1up0rifLbZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Tm/NMkDv3SArjMTKWFhdftJI+QNms4IaevBmfXtim3A=;
 b=M10lqSyyx8rLbRqYW3RhSTc1MSZGBMkDa6f5zBR8MRS20loQ+1XfODLSORJoadnX38sJkzCVQNeqeo2zoAGw2ChisRLNABy+LZceIpJunNq8dhAh4DjV75OlfPso53VJcWDVl6VBnfouuMTYIYsGLsBQ2j0i5H2CzgUSKCazxmI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:15e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Thu, 21 Jan
 2021 20:40:47 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::9068:c899:48f:a8e3%6]) with mapi id 15.20.3763.014; Thu, 21 Jan 2021
 20:40:47 +0000
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
To:     netdev@vger.kernel.org
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: [PATCH net v2 0/2] fix and move definitions of MRP data structures
Date:   Thu, 21 Jan 2021 21:40:35 +0100
Message-Id: <20210121204037.61390-1-rasmus.villemoes@prevas.dk>
X-Mailer: git-send-email 2.23.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM6P195CA0047.EURP195.PROD.OUTLOOK.COM
 (2603:10a6:209:87::24) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from prevas-ravi.prevas.se (5.186.115.188) by AM6P195CA0047.EURP195.PROD.OUTLOOK.COM (2603:10a6:209:87::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.11 via Frontend Transport; Thu, 21 Jan 2021 20:40:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f04a5b6a-80ea-4f6b-bf92-08d8be4cd4ec
X-MS-TrafficTypeDiagnostic: AM0PR10MB3011:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR10MB3011D3DB8E24BCD66C7F21A993A10@AM0PR10MB3011.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:519;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dafNUSuGTGGE8YvqSEacXwJmH971ywAIWOxx3llImiW0/OaW6e08JjSqthH+QHGM39aKX7TqcD4k2+Yd9ikKUhpkOMhH4HMph+g8YnliIQX+7afbtBCkPsDdn+LlcJx3tBlx/VSHo6mNVST19x5Kxfej1wh6USmGJnJul6sxiaBMxK6GXWMXc/PHgDjfty4cU6+GNeAkT/I2kxgTHF9HqcpsMAsOEwdPie3wF2yh7lKksL5wElbrc1uzmEmzs/XWjUHzu9rHRKa9uQMlPXPvE6TN1JXMs4LMJUOxrAQf81kqttu/MAt/nAR8DBnL4M2dhieCzliD5nLywuEz0DAHbVUGuVaadqPIMldIHpdcPEaa3oj1nCda99Q0aTOQxdD4MKprNVXbZQKhQuZgfU4dXw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(376002)(136003)(396003)(39830400003)(346002)(478600001)(2616005)(52116002)(107886003)(6506007)(5660300002)(4744005)(6486002)(6666004)(44832011)(26005)(1076003)(86362001)(83380400001)(4326008)(186003)(316002)(66556008)(8936002)(6916009)(8676002)(66476007)(956004)(8976002)(6512007)(36756003)(66946007)(16526019)(54906003)(2906002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?71sxjBPKBRXDMKiyjKc6RBLtQOZzzgzBbgOlsZW7SfZKukMNkFUrO0KkIxcF?=
 =?us-ascii?Q?wPMDRC5jTNd92iobkeLBi/kz8jcAJXvjavqJJxfaKLBMsoG9XelLZ/ISU6WT?=
 =?us-ascii?Q?sdd2CU1+VkvCKL3FhitUoP9i3Be0hjKFzse5N/pk1ZznzkbkXUU3bAetszaQ?=
 =?us-ascii?Q?Ud7OOcEmmAdcN9lazaQAiV23jcVnU708T+y6iJpDPVvo11IxT28Y87DYlmiC?=
 =?us-ascii?Q?++NO8PQom23Kf3CC9k/XeSW/Gx54qMpuECuOOik8ooJtYOdSijluQhQITM0x?=
 =?us-ascii?Q?8kT2bF7sjwXfpKXQ77F79EfGkYWpjoLAWsSivqisPEz35vsNiKL22Mty4cHn?=
 =?us-ascii?Q?ZYxnWCrKFMxwRzr3R6pkEnwlfj+JUEYccXijB9RBO3Ys9XVZJxjKKynuEahW?=
 =?us-ascii?Q?K+wQM00ScgrmFIG+2QOwHlv7UR2vR4mgpZeqC1SVdV8djfVntiDKRBGontAG?=
 =?us-ascii?Q?1Xi1k24u+IRdBfxeai5Uj1EJsvY93ugt3AQ207qy/WaXph1wW7lQO1XTZPQt?=
 =?us-ascii?Q?5VzfFBRB47sgqvukEktp9vGEtVequljH0Ot1mpvGeZragq3lNJzrgQBq0AR0?=
 =?us-ascii?Q?ZZAQfBYx3Hp2nEJFbV4tjwBwt5joVma/nKGw3eRI+WSVnCUGwiqz8YUw+okW?=
 =?us-ascii?Q?Nix5xYpW2agcNPKCRS5IVdsAsoRmlhD5yPhofACeBIt6x9wmACjNcbX9Vx1w?=
 =?us-ascii?Q?ISfAdb1xByII6HbOdos9InX10ciO87R2L4RHKUkA6nZM+1CKb65LUf0XaL4i?=
 =?us-ascii?Q?k6VF/RVES9l/tOHMqqCd57+xfB1ZWPVU8FAXPuklSyan6JCWxU8PmWWjfa33?=
 =?us-ascii?Q?3Q4/o3KsjkFD2RRzHFyKrI0e8zKDPsCxUZlmfOGCkLWJ3YAYc468copwdfml?=
 =?us-ascii?Q?s2ftWH7HfCNsCRH8Z8BUr70DhrhF8P+h/SWWulcaBMagPdzNUzRftamlj4+S?=
 =?us-ascii?Q?Z5XaxsCf3BeORui8/smtv/mYkr3swemF1slfrg2MhWkIB/ey/VSEzm4JCL0V?=
 =?us-ascii?Q?KEvo?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: f04a5b6a-80ea-4f6b-bf92-08d8be4cd4ec
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2021 20:40:47.4201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ViWZ3CJxqZgM2WGoPVkU2C8p0Tlm3toVJjXL7AehU1Gm2Q0F5b+BIi526uw7p6OkwQA2Aijgp+PsWDCeNkQjv8pSCT8w0zusV9j4Cow2Xgk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3011
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

v2: update commit log of the patch to include comments on 32 bit
alignment; include second patch moving the structs out of uapi.

Rasmus Villemoes (2):
  net: mrp: fix definitions of MRP test packets
  net: mrp: move struct definitions out of uapi

 include/uapi/linux/mrp_bridge.h | 86 ---------------------------------
 net/bridge/br_private_mrp.h     | 29 +++++++++++
 2 files changed, 29 insertions(+), 86 deletions(-)

-- 
2.23.0

