Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F022D29869E
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 06:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1769842AbgJZFxR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 01:53:17 -0400
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:39866 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1769799AbgJZFxQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 01:53:16 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168]) by mx1.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 26 Oct 2020 05:53:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b6wNwYofPv3j8I9CSGHYcyybqETRbfjM2c8Qy+7be68xsrcboXrH6DlXH4ibdZRsJkZr7alNvBKp3YFlOJyezxGwSLSSL/Ab7LCir3d2ZqCOPfsIET8iKW3efnHgDQJv43N8dEbwLYTrjWuWmLKWjmT0yNQn0KtQZo7DmZpID4u6+7JqLf+SYjGich3YuI4qy8WDGemJitxUIzclMxd4YKILI+AEaInGdpFDoX05f1BXO2zHV6aNcSCD893CtMGbI5LRypu7rTAJdVpGHIq2xO7q65ubTFxxaKjrVf1tdGaBw47rFGwjUjXimvDeqhDdWOGkghkSiivxg/CMYXAUIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpjVKuQYnloaHjSXJvpYGZJlpoyOMio7flg0IbAEUHI=;
 b=lIL/gD9FWiOCpODeAat5qCCRanDQqpTg0fymGMQ05SWvni/VT2EBVU+7HOpVa+NCbDMOH28Q6w5WuaqFjqJMP2pOqM4HMnYHtqUoy87cEhYLNy8T2ef0jQmdcVNkGpQ4TT5ViH0RQ8JSr9qbqS4dXmNNlMiW/HTdqJyp3tUk6IwEEPfQuXr+eH4DPfw6iIa0vb9lO8tKpkDAW9NUaB28QFGkSKSohtmH1f6Yobv041bGeERdTtTIyGHOVAiFri3gXQDQN+3YEjBkiY+JnV34LsZsX8GbnpW0Qw1QIJZdWbBE1qlWyInn5tLloAS7NhiPU0B0uRXrAxqaq9ofUucHlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZpjVKuQYnloaHjSXJvpYGZJlpoyOMio7flg0IbAEUHI=;
 b=gQvJOo1mpugaDGfhw+WUux2/ktWl6nr/L9ZouQNSyARi6CiFAFgUdI4EFna++iJs1bgBmGf/cB6S/xkKQGJDwje5iaIytzR1/vLoRWniZo0CuWBGIB7PbWqG/krBac7ANfzeYVIItR5cpjVyW0GbKXnaxZGgGlPTRrXxnFUhNSU=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4253.namprd10.prod.outlook.com (2603:10b6:208:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 26 Oct
 2020 05:53:01 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 05:53:01 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH v4 0/3] Add support for mv88e6393x family of Marvell.
Date:   Mon, 26 Oct 2020 15:52:26 +1000
Message-Id: <cover.1603690201.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201017193044.GO456889@lunn.ch>
References: <20201017193044.GO456889@lunn.ch>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SYBPR01CA0210.ausprd01.prod.outlook.com
 (2603:10c6:10:16::30) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SYBPR01CA0210.ausprd01.prod.outlook.com (2603:10c6:10:16::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 05:52:57 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d8d3c39d-9ce8-442f-98b4-08d8797365e1
X-MS-TrafficTypeDiagnostic: MN2PR10MB4253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4253C039CB8596BC8A904DDE95190@MN2PR10MB4253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Gti8ZgltnYExN4fVa0fiXNOm1hpl9eyiz5RV5ttrY1wLvGfhTI9Vh38Wd7d6jqrgr1s3J/8qNLGuj9EbhLbrjyFvVN8+f+wRLHShkSABN0sCZiCGcIKQWfw/9jMj1lw8LYFO8bfCwYZ4vCEXXoQaAzUSwRu/0mM6g7Ea8gOQMIkfTkTJKuKi4vRhcgtvphZ/ly816a6WXHFrbX+uTBwxpm6N+AI8q5JwJi8p0b3m0SOLeEdGs43dFaB72yAzkvKWNnCYFYAzbROTuuu8vQhj7fuctNr5SugXDG6uKve24sSFbsnF/TyN9+7lRCaCCBClxX0DoCQDqAxF3dlfRL9Qiu2UHorROpBMKQ0o7JICbVmKy1ea8k6AWUqBUaQBmMYa
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39840400004)(396003)(366004)(4326008)(16526019)(66476007)(2616005)(86362001)(26005)(36756003)(956004)(52116002)(316002)(83380400001)(6512007)(69590400008)(2906002)(8936002)(186003)(6506007)(478600001)(44832011)(5660300002)(8676002)(66556008)(6916009)(6486002)(66946007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: qU5C8zlu9eAFJaMpM6nGXhKRpmTZ8bfrHb7qLMr68BQYg64RePSxTHliX0VGzfKXmQjwp6nWcRzgfIIbQhH6QJnWGwRipLDKVTavRR5K59RB5nDnsmuDTOzshxq8aq0B43fGnyUqJ6KYmTbydDHwUQj3IFxM1odY5BsdpooDVUXznalog686aOtJR4ckufk7ERy7kka3dZMOimvMq3vL1xrRBpAEo3uBCMZpUJ4g8M898V/mRPTvImac1BSNDwEuR/S8BRNcJQ4izD/xIzinwJ86txYhFoKVefwgFBL1oft/wZnlonOl4lT5P5ZcxNKW/GIuhQ9lPr2fdCASKAu/8SksydD2ktYHw2uoFLhfvaeMlkCAnQ3cFhIVOKiVhBrLR0smapadD3Sgs/dB2Mb4+RIjF+/7uOAeQieLGos3p5fQqYeKeVDgr7ooe0pYndVoIqjxzSHPDYBnHg2A2cKazXYRoiMJ9bhVxfXKLWTnqKNw12cYB87B/dP09xny/BxZdTDtWTAXq1muHm5zNzav40zxhdj8EWQokT+CJF7eh/ufuBlmCw2Kmf9GBu/EL6n1VdKzjMRy9FKMeLrNeShA8EZku0Q8JfvW/aWyKYdYhPBQDeHxt20x7kRtO7yA9aJmbvjS9XNWOkGFgNxHDRNw2Q==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8d3c39d-9ce8-442f-98b4-08d8797365e1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 05:53:01.5356
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GbBX9/okAhPAMLm11j7PBGO+3gzKg6rLbJ7Nzp9GfMPKjMFo+leDJpA7d2xoKQNYrv/1hevhHIxtzBVY3sDv8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4253
X-BESS-ID: 1603691582-893001-11835-332947-1
X-BESS-VER: 2019.3_20201021.2124
X-BESS-Apparent-Source-IP: 104.47.58.168
X-BESS-Outbound-Spam-Score: 1.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227797 [from 
        cloudscan8-55.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        1.20 SORTED_RECIPS          HEADER: Recipient list is sorted by address 
X-BESS-Outbound-Spam-Status: SCORE=1.20 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER, SORTED_RECIPS
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for the review.
Following is the updated patchset.

The 6393X family has MV88E6191X, MV88E6193X and MV88E6393X products listed in 
Gigabit Ethernet and Gigabit 10G+ Ethernet categories. There are no 6393 devices 
(without X) but there is 6191 device (without X)from a different family.
The product id is listed with the 'X' in the name so I prefer to retain the 
product name 6393X in the driver whereas we can define the family name as
'MV88E6XXX_FAMILY_6393' without 'X'.

The patchset adds support for modes 5GBASE-R, 10GBASE-R and USXGMII on 
ports 0, 9 and 10.

Tested on MV88E6193X device.

Pavana

Pavana Sharma (3):
  Add support for mv88e6393x family of Marvell.
  Add phy interface for 5GBASER mode
  Change serdes lane parameter from u8 type to int.

 drivers/net/dsa/mv88e6xxx/chip.c    | 119 +++++++++--
 drivers/net/dsa/mv88e6xxx/chip.h    |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h |   8 +
 drivers/net/dsa/mv88e6xxx/port.c    | 239 +++++++++++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h    |  40 +++-
 drivers/net/dsa/mv88e6xxx/serdes.c  | 297 ++++++++++++++++++++++++----
 drivers/net/dsa/mv88e6xxx/serdes.h  |  89 ++++++---
 include/linux/phy.h                 |   3 +
 9 files changed, 730 insertions(+), 87 deletions(-)

-- 
2.17.1

