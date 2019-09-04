Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAAFA87F7
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 21:21:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730939AbfIDOAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 10:00:48 -0400
Received: from mail-eopbgr790049.outbound.protection.outlook.com ([40.107.79.49]:27575
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730906AbfIDOAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 10:00:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cop01YPNsNA8eNV5hmjiVKS8sVpMvW7dvKBRnGmQxdUdMkyfWxijvwSk/P3lce9zU+fefkq89mErNjqBXiIf0deN8rs2AZlOQIW5915fIqEq54YEK7qxFCvBuvIX0z9HRucWve5775s0p4mV3rldWCvD1r0hqm2SJ4qonEjv1vqRlCMlB9HJM5nNGgnMvv0B8WdEGyx8L5JPp2m3ml1yVCxI+QJnY3+aFBlopwdMnyStBE/52VMev9HaEFgtjYFf5Ey57FkPuYPRblTTHf3CdmMGIwSiKDuPdR75BiBPi2rdbfLxUpCFNq0/1OgTWRs5O47Ox6GE3umtw287KvPfug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbV0KiQXzhkjTQ9Cz5SKCJoDIfgb95NPUpA5Zl8XTIo=;
 b=apKRykCEi/UnhXKcg6yhgvMhlYuDpETIxVw7uqNZM2PBYMFEWGS+sArRg8KAwYhRYb3tn+IsI4o7xNI1lwuX0U+eTUmZTunf/REpZ5htM9u48S/cbL/6grf8Ktj3tstunFra/Oa5VdIKBv/dUw7sZUfC9nRJNocU5nXzkeYaz2Rq1bP8HojV97BFc8S/UVAFMvznuV+2OXTGKuT6I9yzPXBbQ/VxYKbumKmuZYPMoNj+s2tYE3ICsNtHiBmKQoe7GSvEvMBo/CzYqpEDOWNAioTEHgB2e9yd+sQ6W+yZkKqxUlhh9G47E6hFlejpb9XVQhtNJFb76m2QV7jO5HeitQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.100) smtp.rcpttodomain=gmail.com smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jbV0KiQXzhkjTQ9Cz5SKCJoDIfgb95NPUpA5Zl8XTIo=;
 b=DWoGDVP0uYDek1T0ETF5SEHPQXFYgPiygTjhpm/WWZbCkacXRA3l7b9San2Q68TVcauh5LqAuZi9o6ez1hElluIHFgEhvq/vJU3wgq/9f6vxBnnWPp3fMOTMZJ+2a6/gBqjGaafL95JVQEMuh/yuUkEB907eKW8zwBNvo0itO3Q=
Received: from MWHPR02CA0037.namprd02.prod.outlook.com (2603:10b6:301:60::26)
 by SN6PR02MB5262.namprd02.prod.outlook.com (2603:10b6:805:70::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2199.21; Wed, 4 Sep
 2019 14:00:44 +0000
Received: from BL2NAM02FT064.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e46::206) by MWHPR02CA0037.outlook.office365.com
 (2603:10b6:301:60::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.20.2241.14 via Frontend
 Transport; Wed, 4 Sep 2019 14:00:44 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.100)
 smtp.mailfrom=xilinx.com; gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.100 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.100; helo=xsj-pvapsmtpgw02;
Received: from xsj-pvapsmtpgw02 (149.199.60.100) by
 BL2NAM02FT064.mail.protection.outlook.com (10.152.77.119) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2220.16
 via Frontend Transport; Wed, 4 Sep 2019 14:00:43 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66]:54097 helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw02 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1i5Vpy-0000x0-K6; Wed, 04 Sep 2019 07:00:42 -0700
Received: from [127.0.0.1] (helo=localhost)
        by xsj-pvapsmtp01 with smtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1i5Vpt-0002TG-GD; Wed, 04 Sep 2019 07:00:37 -0700
Received: from xsj-pvapsmtp01 (mail.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x84E0PXH024453;
        Wed, 4 Sep 2019 07:00:26 -0700
Received: from [10.140.6.13] (helo=xhdharinik40.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <harini.katakam@xilinx.com>)
        id 1i5Vph-0002Ac-3i; Wed, 04 Sep 2019 07:00:25 -0700
From:   Harini Katakam <harini.katakam@xilinx.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net
Cc:     michal.simek@xilinx.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        harinikatakamlinux@gmail.com, harini.katakam@xilinx.com,
        radhey.shyam.pandey@xilinx.com
Subject: [PATCH v2 0/2] Fix GMII2RGMII private field
Date:   Wed,  4 Sep 2019 19:30:19 +0530
Message-Id: <1567605621-6818-1-git-send-email-harini.katakam@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-User-Approved-Sender: Yes;Yes
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.100;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(396003)(376002)(136003)(2980300002)(199004)(189003)(186003)(26005)(70206006)(356004)(486006)(336012)(6666004)(126002)(70586007)(107886003)(2616005)(476003)(4326008)(426003)(51416003)(316002)(44832011)(48376002)(50466002)(305945005)(478600001)(47776003)(2906002)(9786002)(8676002)(81166006)(106002)(7696005)(81156014)(5660300002)(36386004)(50226002)(36756003)(4744005)(16586007)(8936002)(42866002)(5001870100001);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB5262;H:xsj-pvapsmtpgw02;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-100.xilinx.com,xapps1.xilinx.com;A:1;MX:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0d153411-1981-44a9-ef12-08d731404735
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328);SRVR:SN6PR02MB5262;
X-MS-TrafficTypeDiagnostic: SN6PR02MB5262:
X-Microsoft-Antispam-PRVS: <SN6PR02MB5262131CA2193EFD4852BF28C9B80@SN6PR02MB5262.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0150F3F97D
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: 4NOLcwE3N/OP+ldJTEN2k3ygoQe4DsY4E8ZovyV4P8C7ffbaGFh/87Nrmz2OuhDtRQQ17hwHgDkIyL81DdVF3Rmh952txvC2FiLtl2rpso3Z5L1K/pir/RiSUnz/6R73VYnVD3EiKhPt36t/PceN1XkP0hzqeQSxU52yEl3rWyAv/z7ye/c5Fc8XO3oGhBWWCt2zN7FnHdDdq0nfvWFFDQz+AmWoY3gIyuGrX8T2gBEuHTO0Uwdg64c5sZXvLIWTxVKKQpsFU/Vw7JCRT+YBENf6W7v9HzzVbPf4lgErV+AvFxxuKwbznQb4ruL4WhwWyPgzVMnEsUnkAQR8wrdHe4Bmsl9pvpJGFmpBd34AbCdsNi2KBte3jCvGF7JjOWs+R+DwTYdLN8hGaXyGYQfiKC4HJUtQREIhzsXoNXuP7Rw=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Sep 2019 14:00:43.6858
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 0d153411-1981-44a9-ef12-08d731404735
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.100];Helo=[xsj-pvapsmtpgw02]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5262
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the usage of external phy's priv field by gmii2rgmii driver.

Based on net-next.

Harini Katakam (2):
  include: mdio: Add driver data helpers
  net: phy: gmii2rgmii: Dont use priv field in phy device

 drivers/net/phy/xilinx_gmii2rgmii.c |  4 ++--
 include/linux/mdio.h                | 11 +++++++++++
 2 files changed, 13 insertions(+), 2 deletions(-)

-- 
2.7.4

