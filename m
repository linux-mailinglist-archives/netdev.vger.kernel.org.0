Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B7929E62E
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:17:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729141AbgJ2IQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:16:49 -0400
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:52326 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725956AbgJ2IQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:16:41 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104]) by mx1.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 29 Oct 2020 08:16:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XZ/picoSSp4kdyQpCXkNQq5L2jRepm3hRzzCnP7qMISVXKf1/ymlueFSw89VG+9CJKeqd7rumUfRuG3WeZmG6F9FwaQuhQUzvUdmqMyZn/MEVK4ttKqhoqntmfzl2KkSHGKPI0vUH63RNkwa2cGJVwXLkD7q0ec4P6nYLiRF8+P5KFkhIHYEtwEXVPTtF/ZY4ozbyIw7coEr4u9i0F3LYkQTYgDXFNzI30puzhLjAG7Tj2hL8laSZl72Kv1f1t+pebEPqe85FBeKIQ9oTSMy85xjORguAoDlJGgzjE6lsEVMxploK2vUv0OwxAyBGUbpzhynT/85EFES7j/kfMVu+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=La5TrueI1/ZlJWK5joXiLhES6UnCnaD8Nw6CqyjTHIQ=;
 b=bjbBbuTho+slIcjubquQYTGzt+xLf+fqE764DNstK0XSWqp1TlEEC1Ljx5G57ZC7Ft45aNVZWZpoI91ZmUCmXyRg5ZT40RbXdUhF9BInznPocVW/q7nrjN4b/A+RSbbC1Xr0aRR6DjosQpebUrk0gfALm6uQOVK9Ydl6vxwTSzlgEZmJlbUrciA5Yw/X9K3n5PrN2mLd/AxEE+ydeRl09EF5sRU3i/W4EENFL++D7kmE7Ba7KNG7wdJmhoWYFPn+vv/B9kx4QIzXR6ZmUJoOozSL2CvPno8ub0Mzlvwf449Y3g/vXODZ+l6nkZy6m+NG/5rWNiNAVW9pT1OJ+07aEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=La5TrueI1/ZlJWK5joXiLhES6UnCnaD8Nw6CqyjTHIQ=;
 b=hBYcmDeV4cSILvuNAd7xPTMQiTU0O0DN8LXsWliXrMZjVXznkLYc7TclkfNxhadF0PHNwvuSnIweCTJ5LufGIH6AI9jAeYsQcuZ5OAPFNWpCAMmZBp3hC2TBp2C3oGd6q2hqsWNop3JB3amGgZiErJgazRl3retznjunW+h5Mrg=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4189.namprd10.prod.outlook.com (2603:10b6:208:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 05:41:11 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Thu, 29 Oct 2020
 05:41:10 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com,
        marek.behun@nic.cz, ashkan.boldaji@digi.com
Subject: [PATCH v6 0/4] Add support for mv88e6393x family of Marvell 
Date:   Thu, 29 Oct 2020 15:40:25 +1000
Message-Id: <cover.1603944740.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201028122115.GC933237@lunn.ch>
References: <20201028122115.GC933237@lunn.ch>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SY3PR01CA0125.ausprd01.prod.outlook.com
 (2603:10c6:0:1a::34) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SY3PR01CA0125.ausprd01.prod.outlook.com (2603:10c6:0:1a::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.19 via Frontend Transport; Thu, 29 Oct 2020 05:41:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1c0f15fe-666a-4b3a-0c85-08d87bcd3d89
X-MS-TrafficTypeDiagnostic: MN2PR10MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB418988A9C917F7754E4D4DF795140@MN2PR10MB4189.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SJrz0q5dtEVvFdoS+bkwkYp8k3jQpflF3cpTXtX4zuQ8dZTrXRLbLqJd28MlbKnT/O970GdnxeHYJUZC88PFsNSnY1mqWEcgpOQVV8Z0VE2R7ra8dNHVd3fPA0WmT/2HSHxr62QbbUai8NujtYjdA0aQqq9SoMVREX8Sc4iiIchD/Z6O9y3yKKNbWXBfJ7dGQmNeEBvQN53tBDxZp780yMPKhW4ohC9B8T4QTIo+5JUe1yX+R00UumHfREflaaf5x/afVKHZfAeoZXqwVHJmPyQ73A08CGOoOQcmqSTJy5u8jIj97oxcdOVYFx5Ra1CSx69BW8JK6tcsefQNPlmC3uyxP/OE5mOAGw57cMTzVH6pHm7yd9RRCLctLhpjMOIv
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(376002)(366004)(396003)(2616005)(956004)(69590400008)(8936002)(66476007)(6666004)(16526019)(66946007)(316002)(186003)(4743002)(2906002)(44832011)(8676002)(6916009)(107886003)(6486002)(36756003)(26005)(66556008)(5660300002)(86362001)(6506007)(4326008)(6512007)(52116002)(83380400001)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: G+cjRven3N/ACWKNenFs3/ekMtilOKjrBn6jQ75Xu+7BcYLKthdhtX7UdM581Ie9GEq67+GFCv7wnIYdv/l0JlGE8mQunl2A0bTdovhKvXZmI6a2X3BBzrxN1ABOuiaewv8tle4eJKjBydZC0NmqHK9PnVuaIaTVtXlFfdfV29p4JP2qvLojYDzC7Shpv3jSmjjq3aUURbXKvwkj8869afiJBLW5zJFN4Y7dMLCK6OC3sVs4HyZDM8bT2R4T90f1YPqnxqPgEsiFUksewqa0bZcQ3pG1WOKk+RH+8NH4EQXf4KvPU6j4vpLuUaiKCDrOiBvWMWsJAB8ENEcPFRnwwNUimtNSqHwHmEo2RPBnBVREfDqQnb8q2od9QLn0hgjXyfO/9MZeV1qyaxLlfoRY1IQAZCKmX2+n4BWrTzdJxrg2Oa5Yb+A1ffO8IxHCpK4ZlPe+ihlnqChvNdUFV9TXP1XbC3YFtH46U+BBDMVhQAVooNotN1jI0DUTwyJGUzVhdGZIah636d7zfFsFynrGpPWqrIiKPx6be/P9t9a7gMMU5c2gi9E3zEuJdlSVDxNbaDqWfIn57d67jA1URi/kbNpvspCfvqvAveDsWg6hA9xisW4neo1lJzkCQXKeQ0iZiuD5I6gW0gkhsfFVbzqQiA==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1c0f15fe-666a-4b3a-0c85-08d87bcd3d89
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 05:41:10.8568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CIH5nToElmmfiaZx7LFvPu7b866MZnVswjIhw+A6s/pcZQyCftOhN6VFsXV55E88gyVrA3OEAevhsapZdrHqeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4189
X-BESS-ID: 1603959389-893001-31478-248065-2
X-BESS-VER: 2019.3_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.58.104
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227845 [from 
        cloudscan20-221.us-east-2b.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND, MSGID_FROM_MTA_HEADER
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Updated patchset.

Split the patch to separate mv88e6393 changes from refactoring
serdes_get_lane.
Update Documentation before adding new mode.

> Is the 6191X part of the 6193 family? Not the 6390, like the 6191 is?
> Or do we have the 6191 in the wrong family?

>> +	MV88E6193X,

> You don't add any _ops structure for the 6193x. How is it different?
> Can you make your best guess at the ops structure. Also, what about
> the 6191X?

6393 Family lists 6191X, 6193X and 6393X products. Unlike 6390, the
6393X have 10G interconnect. 
I'm not sure on naming of 6191 and 6191X.
 
I am adding _ops for 6193X, mv88e6193x_ops which can be used for the
other two products unless any specific functionality differs.


Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface mode
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Add support for mv88e6393x family   of Marvell
  net: dsa: mv88e6xxx: Change serdes lane parameter  from u8 to int

 .../bindings/net/ethernet-controller.yaml     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 119 ++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 240 +++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  43 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 295 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h            |  89 ++++--
 include/linux/phy.h                           |   3 +
 10 files changed, 733 insertions(+), 88 deletions(-)

-- 
2.17.1

