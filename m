Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3AB2A3F42
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726058AbgKCItL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:49:11 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:58578 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgKCItK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:49:10 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173]) by mx5.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 03 Nov 2020 08:48:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gb6xELkbGN+hDX4h7o31oSn2qOohojYuUKddPqR60ngKyNuc29vwaCncH3P2PT9wYflEm8z/GH4R7CAgbFyYcdMu/eGapU9rHDLQEKv/1TZrtpMr9s2GuP3hURlG0BZvu9noRLB6a3O+7NTqDvsaZHLtiL/fDXCxjXWWbonsEk7mkstTysig9SGs/FEsRQRsse9tKIQLgO41uvNwOFKhhJFREfzQzosDmVw6+DdUMQQD1gzb+IseAXTqnKZDupVF3+dXKkNuAg65wke1Ipm4o9KjsQajByHBoZqBolGR5lAteR3fGzjP9DGv9iSZY4kQfLM43HTF3GBwGWE+moFaWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6JI7czF7jpXMbkxaVD8+NKO1o3Zy8dTWLMnBWPSbDY=;
 b=FQZoRF7AyAPsndTRdImXIhrR0GjxRm0y2upbFcRhl3/xQayiN7GD+TD8YM1RzIVqHrOTDnVWGev7M5VVhQ4dSiqZko0FUPCYvLbBkcsUjYJqd/ppPehCH0wVEcZVljcsRzek9EBwtVApH+8JwUT4zbbeK8L+8AkEjBFMetutb99YZQ/417JOf0zsCty3CQ+VlmGx0Rpf+YbZbOelHqncCXmexlj99AOz4yBjv8yL9bzfTxSq4n/Ze1Z/9RLzbbmf0Li7jdE++LjeTrII8M6ppfoyAgPgK1CBzSiLYq6MjRJOfCOIBC+eFaTYh4jj9+6eMZ+FRTLZOps21nvyE9kPCw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6JI7czF7jpXMbkxaVD8+NKO1o3Zy8dTWLMnBWPSbDY=;
 b=InlimMpm8YeqaKBHyaI3QBSrC3voY5dTfAmb0gAK1WWRCUcttUBQiE84FtubUm4/aEf9opEdAk78YlccPYM1zJeUKDXD+QCE+c3zRceaeENDX+zJUMZ2wjpfnx9Jg0YZ5F75vKowujs8Babkdh1DSm1aSURE4woCmc8vHP6U97Y=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB2883.namprd10.prod.outlook.com (2603:10b6:208:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 08:48:54 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 08:48:54 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [PATCH v8 0/4] Add support for mv88e6393x family of Marvell
Date:   Tue,  3 Nov 2020 18:48:27 +1000
Message-Id: <cover.1604388359.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201103031643.GJ1109407@lunn.ch>
References: <20201103031643.GJ1109407@lunn.ch>
Content-Type: text/plain
X-Originating-IP: [210.185.118.55]
X-ClientProxiedBy: SYBPR01CA0037.ausprd01.prod.outlook.com
 (2603:10c6:10:4::25) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (210.185.118.55) by SYBPR01CA0037.ausprd01.prod.outlook.com (2603:10c6:10:4::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 08:48:50 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f8f7e2dd-e221-4573-4f2b-08d87fd54b1e
X-MS-TrafficTypeDiagnostic: BL0PR10MB2883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB288304ADCE50E76D4740DCA495110@BL0PR10MB2883.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AAKzJvFG882BxrytUxH46PlTsI/sRs9Otb00k+lA6gwbeoSi4uY7UjUeuoHt0ynPzGOv7lUaE8LxegMs+1FuFtGLxVKmYad4Q67GcPULFeLonr2WXLPRH/WVW+zQ3OoWyWhiOfH22Q4XnQgwTT6hG9w2bkwcstW9eLSPvil+aJfq97Y/Tkc1C9+NjrjpDsYa5FhJywGobEC9PaSP3jUjYmGmu5u3JPfGP2aSUXXh7SNwEpjPavIc0KdL3xxmJl03zTZ3CNWlJfQ1E6ae/E2oY5/OeOGb4Xv27Vq+nfhy1EfDNPjQ3eyB7nrBYrPgdAX8ghL1LCDC5L+GPkBug2bZzVhQzD+XrOnvGjG9hYF9vdY06hQwH9DQ8vVL++gAmA/k
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39850400004)(376002)(396003)(66556008)(4326008)(6486002)(8936002)(52116002)(69590400008)(36756003)(6512007)(86362001)(186003)(66946007)(66476007)(26005)(6666004)(316002)(16526019)(83380400001)(478600001)(4744005)(6506007)(956004)(6916009)(2616005)(8676002)(5660300002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: sP/8nzLBQOM18mGp1i9DV9i1xJdlsiBImXRR97/TBLUYdqN2Roql3QY4y0q3D/0lQnvbeqdSdYb/h0DLT1Ea+J13l8u9FJj1eqEQoztLotPr+kmAlw8S6l6ok2rf9RNk/5V8R2rSxx/FmU27QANKvSBlhqUmX5HcDwJinXnSOs9m+LeoJvqFed31+a03xWnmds48bn7LXHlID0DaQm3tZ+0Xm+tKKHmbD9KvObzigCU+pPMWR/uo/PoMDFVbsdPiTAbxhDsT3M8XM8iMED7+vddMuo2pDozG6th2QTSQ0tnxSCh72ccn0bsBTyVaqyao06J1I8LIo8MJaeCuX3ZGlOXvOZsHpZdIYucB2sGVPlZp4NSYetuJsHd5mMGL+dcubXICxQPmDzcHRKmibjpDsvQM9tBDyTmXHoGcLfMbBCZyt4oX0RjdhO/iq/b7R8k/cUvijYmOgdRhWom73vh6CphHhh/svp6+zJ2JVHotlhHR3zcpds3CIbmVZXN5LJjEhIEJHWvbBwNCJ8QU0oxHrJn5GmEfTP7s3lSEQgj1mnViOafgvGZr2fVTEtZLGTiOLD/HNi8JYrpxL05UAn/p85gbLP4OEUj4PBEioSYUpJHQqUeSzAY2OgQQDuzVqB+G0PpTz/9r4xVY1TxbtB6QRw==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f8f7e2dd-e221-4573-4f2b-08d87fd54b1e
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 08:48:54.3470
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EESw9cq3o3TimN2kiFgTt05XMQGWOw3cFdOarDY42AYB5Dwe8CU215cU1tIbysQF3DESqpPBtKRtglsZakl89A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2883
X-BESS-ID: 1604393336-893009-3590-367206-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.58.173
X-BESS-Outbound-Spam-Score: 1.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227933 [from 
        cloudscan17-241.us-east-2b.ess.aws.cudaops.com]
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

Updated patchset with following changes.
- Add kerneldoc for 5GBASER phy interface
- Remove lane param initialization wherever is it not needed.

Pavana Sharma (4):
  dt-bindings: net: Add 5GBASER phy interface mode
  net: phy: Add 5GBASER interface mode
  net: dsa: mv88e6xxx: Change serdes lane parameter  from u8 type to int
  net: dsa: mv88e6xxx: Add support for mv88e6393x family  of Marvell

 .../bindings/net/ethernet-controller.yaml     |   2 +
 drivers/net/dsa/mv88e6xxx/chip.c              | 164 +++++++++-
 drivers/net/dsa/mv88e6xxx/chip.h              |  20 +-
 drivers/net/dsa/mv88e6xxx/global1.h           |   2 +
 drivers/net/dsa/mv88e6xxx/global2.h           |   8 +
 drivers/net/dsa/mv88e6xxx/port.c              | 240 +++++++++++++-
 drivers/net/dsa/mv88e6xxx/port.h              |  43 ++-
 drivers/net/dsa/mv88e6xxx/serdes.c            | 295 +++++++++++++++---
 drivers/net/dsa/mv88e6xxx/serdes.h            |  91 ++++--
 include/linux/phy.h                           |   5 +
 10 files changed, 781 insertions(+), 89 deletions(-)

-- 
2.17.1

