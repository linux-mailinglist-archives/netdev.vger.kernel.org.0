Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7AB11277A7
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 09:57:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727258AbfLTI5V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 03:57:21 -0500
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:6024
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727164AbfLTI5V (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 03:57:21 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JkMQM6swAn+6Qmw9/pvhp0wIpJCz9lLMpqRjoWygB/cIN11s3KTeykEP5iQBBcfxBtKqlXq3aGd/ognQPDQDGKrkZac3j89uHjpkWr2xI0Cs4K8Aby2cawjzvNgK0QMkejAPm9M8byhTd8PfC2AeYzgyIjUYQhuFtnehMXllPXNGiWQdOZemmyO1RhZcVriz+cRsOusGJ0M3IsX+ry0s2w36XBPWHs7Dr/IUdxJk3vS7mc8kQtIwuQx/k9a3lBFfuvAtCx9ZR8OIXrFfIaUuzIqZB4mveFkuuNL1Y1ABly7Uu4dYm8s/vj8RCZPKSP8kMiig9ejab3Vv4JgCMOKTXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dvc+2z3f1d2YnIHf5PXpxa1mRPpFheqQ8eot7NzEjY8=;
 b=ITc9lz3GFaJUzu8fIM+R1GqmzmUPerNORKF6Qqt2fcNo8qJmg3gxGvcS7m4aWW/HS4JiVikMEEk8hc/8ErnVb40rPLFXKE3LqgR9i+HTR6PYAQEiz9rBcJhZJmcAqLU5XJ+2VvNb7Gw+QSme5cW4wq3ZoahE0XSA1bdGTRQaS6zousgSMOiCfrIBVyJ4flSG/BRZXNtLvHfql3mJZtDTqC+j+XL0OhFSpmb+ZPOcMWRdiX7mx4Bu6N+3B20fSL9XXRzQvoBCDoe6o+1a5IR+MW/CfGNCwS54Xop7W5CNMz4bRN1MVywpLksMdnqT3bxISW4HRbfKT5C2on4jgS7tFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Dvc+2z3f1d2YnIHf5PXpxa1mRPpFheqQ8eot7NzEjY8=;
 b=e7X8lPnvZKoXbOmRfzUGq1IIsgCGLCdaVSKG8WrOi2pIro8YyiNHNcln2He+hLS3Pw8QSbtIx075l002htygfPJFQmQqJ5NTl1D8ntWHlnEcnfUyLNBpq9bmqe1S2K0ExB8vzxgMTIX5qYzE3HIRLuwGEzLG3OPpR/PTQJRxORo=
Received: from CY4PR02CA0026.namprd02.prod.outlook.com (2603:10b6:903:117::12)
 by DM6PR02MB5178.namprd02.prod.outlook.com (2603:10b6:5:50::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.18; Fri, 20 Dec
 2019 08:57:15 +0000
Received: from CY1NAM02FT059.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e45::204) by CY4PR02CA0026.outlook.office365.com
 (2603:10b6:903:117::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2559.14 via Frontend
 Transport; Fri, 20 Dec 2019 08:57:15 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT059.mail.protection.outlook.com (10.152.74.211) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2559.14
 via Frontend Transport; Fri, 20 Dec 2019 08:57:15 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5x-0003Di-Tr; Fri, 20 Dec 2019 00:57:13 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5s-000100-5o; Fri, 20 Dec 2019 00:57:08 -0800
Received: from xsj-pvapsmtp01 (xsj-smtp1.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xBK8v7Rn010840;
        Fri, 20 Dec 2019 00:57:07 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1iiE5q-0000zg-Qm; Fri, 20 Dec 2019 00:57:07 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 07325103F29; Fri, 20 Dec 2019 14:27:05 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next v2 0/3] net: emaclite: support arm64 platform
Date:   Fri, 20 Dec 2019 14:26:57 +0530
Message-Id: <1576832220-9631-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--1.562-7.0-31-1
X-imss-scan-details: No--1.562-7.0-31-1;No--1.562-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(346002)(136003)(39860400002)(428003)(249900001)(199004)(189003)(36756003)(107886003)(450100002)(5660300002)(6266002)(6636002)(4326008)(81166006)(26005)(4744005)(8676002)(8936002)(42186006)(2906002)(70586007)(42882007)(70206006)(2616005)(336012)(356004)(81156014)(316002)(498600001)(6666004);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR02MB5178;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70ec4394-3c81-41e3-8633-08d7852a9c75
X-MS-TrafficTypeDiagnostic: DM6PR02MB5178:
X-Microsoft-Antispam-PRVS: <DM6PR02MB5178B4F8FEC996129937D3BAD52D0@DM6PR02MB5178.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-Forefront-PRVS: 025796F161
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +SbURcGkBVRRuJt0PCxrhvy297/AfjaTP+sWxaurQzCb0y7lPUEGs+CqTYmqr5fCcjjN3TEBeY+9KFphxI0VERAVzKTRsh19BDMyw4U6MOsrD6cTS16vobBde6sAoWH7aTOb8MubqWq9gUCxR0tKf5ZDZJ8xaL47oycMAwOene5CvsD8U9u5yJewzL3rbKFykWG+zydgExfCxcPTDTpk7NRPemZbwzMTd2alAL8vB7kfvh8z2haZi+Yl0CXI69/aHGP/0V7BoDa+wCrSt6PwmDx0S8JdcLcTFB+X2JUDwrq3v9t8nku7rYuxTl9qQrJD4UTHCo5SZN0fMA7GliVNZhBZbkWZ5TpYi//U7K189aUcMxQDc01w3XSgTBnsN5WlVdF/MnY2FFOTfn00TlWXvn6jErrp6Iac2RSATh1In/F7Aao/PI54KtedxVgor1p3
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Dec 2019 08:57:15.5001
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ec4394-3c81-41e3-8633-08d7852a9c75
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR02MB5178
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This patchset fixes the checkpatch warning reported in xilinx emaclite
driver. It also remove obsolete arch dependency in kconfig to support
aarch64 platform and fixes related gcc warnings.

Changes for v2:
- Modified description of reset_lock spinlock variable.

Michal Simek (1):
  net: emaclite: Fix arm64 compilation warnings

Radhey Shyam Pandey (2):
  net: emaclite: Fix coding style
  net: emaclite: In kconfig remove arch dependency

 drivers/net/ethernet/xilinx/Kconfig           |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 47 ++++++++++++---------------
 2 files changed, 22 insertions(+), 27 deletions(-)

-- 
2.7.4

