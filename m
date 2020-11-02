Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 550392A24D6
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgKBGk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:40:56 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:38182 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727306AbgKBGk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 01:40:56 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108]) by mx5.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 02 Nov 2020 06:40:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=I64O4e5FBYOc3f4fAh8i5kWYH5iw0pNEFgRfCwb57LLI59Oeag1c8k9kE8btF7w8L4i8zQiFcYpXCnuSFHZIJJOs50mgEmhRk5pCf9TX3z+saUrpdRgPZ0egPT/2P3ei1SjB9QOe+Tv+gxDHN3txcJOo87mtFbJhSQn4v3i02lMMKJcLbsNQWyc1f4g4kad2I9NNMk54t8uA5TTw460aOIhWIjzI5WaD1LRv2fEq0RbVNps+fncErA1MI4uSnAgy1pvk+OLNu5EWgSV82npFIyQ9RouNsvTn0hyuVEkR8DkR6lnaB7IbKXSiGPRuwXtCKxSV522I7NG2OMIvxS+7Fg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f26jOl85TmfPM0igWcoN7WgYujveV1KAhrU5rpni9uo=;
 b=DQyjhMwdLeVGS7aa4PNHrCEJNyppvrBIEXs2MMpB7xkI/qDF2UIEQ8ztOusrq2j07Ojzccg3MAQUXNW4cNIfE8BtDNYDh2727QPbNbBV8ULcXkUbUwReHM7ALmHy6NXfTzGO/6U0fP/HxbRW1rbE4vOWeU1T8m8BNb+2CO/mzKDmLEy/2oQJ77eq+n/MpEKaitdj7E7mk4bCK4gzBy7KYLaWTSSOgoGEMksmS71s+9mIG4dmmxrn7l0phODKdy8l8wSds0IB3k0KVAmlQh1Bj3rhqeGg5b4fleHqTbB12SgjsB29fhCCP0aBzoJsdUS93Sk2D4pSkAr4McMoAdaIKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=f26jOl85TmfPM0igWcoN7WgYujveV1KAhrU5rpni9uo=;
 b=jgEAAyxAH1Zg5bkqk5FBY2pr0pv0Yk1mHNBSCtQ/IXcn0ful6dN2EF/J0tLF/mwJdDxqcqKID6YtFyMtgpb0UBoGfV9p4WbTGOgaay342RZyKxEOiFUNlH4oMY9f2vkR1OVaGMMyTUE/tU7ZigsCgBNfQI3nDpcc/BiFM58IuUs=
Authentication-Results: nic.cz; dkim=none (message not signed)
 header.d=none;nic.cz; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB3934.namprd10.prod.outlook.com (2603:10b6:208:183::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Mon, 2 Nov
 2020 06:40:39 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 06:40:39 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     marek.behun@nic.cz
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH v7 0/4] Add support for mv88e6393x family of Marvell
Date:   Mon,  2 Nov 2020 16:40:02 +1000
Message-Id: <cover.1604298276.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201029073123.77ba965b@nic.cz>
References: <20201029073123.77ba965b@nic.cz>
Content-Type: text/plain
X-Originating-IP: [210.185.118.55]
X-ClientProxiedBy: SY2PR01CA0023.ausprd01.prod.outlook.com
 (2603:10c6:1:14::35) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (210.185.118.55) by SY2PR01CA0023.ausprd01.prod.outlook.com (2603:10c6:1:14::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 06:40:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2cdd1d2-361b-4063-39c1-08d87efa3633
X-MS-TrafficTypeDiagnostic: MN2PR10MB3934:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3934A31FCC08A3F715F84F9495100@MN2PR10MB3934.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CR9slJqSTNMUchj35tnkN8xooYI9dq8/OlhIVOchuNYhwG0ytCjikKlbJlF+hUcuWBXRjGrSPJ/Xt1la6iMvHLSSQtuIWuqCKoMDeI8Bh78yw7NB3TU8tEYdpKSnhX3hkmbLynVdqqusfl/1WiHXA9kbzps3DzROej5+vnw3XMp/B/TYs496O9veK+14ULgRdUa2ARYP+9j37MCLW0At9WTfB33ehFGyQfiqvjV0CwBN2Hf94yrfHMmkW4vj87bd5ZaXs6hiOqy/ALTkJgYQsQk7qd2C/LD/gqJnro8qZdQUOcmg17Kz8I29G9ZkIkv494/R1LD6NI1SKpJnwLLUn83MkgLKmiYNRPaBf+Tkm8O29ke70qDSbynwNgIdM7eJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(376002)(396003)(136003)(366004)(346002)(66946007)(6512007)(5660300002)(83380400001)(6666004)(2906002)(66476007)(66556008)(316002)(478600001)(4744005)(69590400008)(956004)(6506007)(6916009)(2616005)(16526019)(186003)(44832011)(86362001)(6486002)(8936002)(36756003)(26005)(8676002)(4326008)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: yNnr+Kh0dpWUs4EpRKKLRnQMZAiilU1dV2hGishhRRX2YP1Y0GsXLxSTJFM4Mh6h0g7gLeYOkYs6qrgoHsHdDW3tQ6ccIaVFiahErmeMm+FQv6YtX6VYyroh3SJyU3gJMmSqnDUgwrzPa0BBN1lGGYd9AXH++Cq5+y+D94H6C1G2KGoKcXr3LSSLy53/9PVIPhAWWcFee3xjOwwc607K0JyoioWl/49Euu+2LCZGnq4nL0/GB258AbH3nZariArTy2taPyK1cTp2syXeXm7YT+Lqq8mlUVBoAiR+4SabGO39pIKEuyLUEgU+AqMMPsmKCHNkPvYl9d4Ya4LpBoxbg0DntIKt8JkiMbi6AqxblIEB0uD9I2//VTSK36hl+ekq2uP4WeOuZvuY0IEfOhyYHi6+giiHTwNSBeUbbdWZS782M/un+GMfPIus6AV368QhkUFJuUOdGRHwSxYQs5lo9h+qAxv4JOZl3ApOMwBwtCVXV2JCg9rIXD/Q/lhgxtnKTPp45m98H66ezMVnx1DTe6WCPfGVtDARGKuzCXXpuCwTnOgbklIlVbE+J+KxxDdB8+0CUY0Vrk6STleg7sNbdYbGpn4mKJsrdO5mnH78e/V3nf0yIUNfQ83jOz0BfBzbawWro0gZM2Us+dZ+lOSDIg==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2cdd1d2-361b-4063-39c1-08d87efa3633
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 06:40:39.3317
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t7bCFTmG+98mTixn4TRcV29yxqhrnZdGsaRJVXOIUejj9mjtYzuo51wOWxTIA+f2R7nUbUlk8kjZ1iUCKNdsDA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3934
X-BESS-ID: 1604299240-893008-24846-261626-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.55.108
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227908 [from 
        cloudscan21-213.us-east-2b.ess.aws.cudaops.com]
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

Thanks for the review.
Here's updated patchset.

Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface mode
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Change serdes lane parameter  from u8 type to int
  net: dsa: mv88e6xxx: Add support for mv88e6393x family of Marvell

 .../bindings/net/ethernet-controller.yaml     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 164 +++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 240 +++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  43 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 299 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h            |  91 ++++--
 include/linux/phy.h                           |   4 +
 10 files changed, 782 insertions(+), 91 deletions(-)

-- 
2.17.1

