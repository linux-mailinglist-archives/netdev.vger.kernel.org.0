Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DBDE12D452
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 21:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727708AbfL3UN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Dec 2019 15:13:59 -0500
Received: from mail-eopbgr680109.outbound.protection.outlook.com ([40.107.68.109]:34285
        "EHLO NAM04-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727667AbfL3UN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Dec 2019 15:13:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EVTEwuYcsoWhobQDgZHGvuP1dFpJy+22Z3qEQG09DJsMYxJVsNTH+7fALrU+kkc15mEwX91NxRexV5IaWhqrKWlpodKAbEnLVhXt/ShSMwhSqviLt0uXeXuIurOmvLcKxE1nAVJUD7WGmFe8wMqYJaV89Z06OVijnjZLqQYz+EHk32/FGi+Wik1mqfeB+TF6b3QBvyHNBdicQFCAofdHvNq4D91eZjTTyX6/pzLGY009oPN/yaGoJpZD1BNaTHhsDnmIY3aoiSPsFvaq/x09WT79zGeu1trankcCKsHDKnCLzsASEFSGzhKq+WszWadY6a2suWLNo3pVQNZdBC8LCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgzFW3d4xFaTdzxuMn/y0TJwFzW6+RWghVCR3xZ3I/4=;
 b=k/WvPp98f5bYu7c6YcDDvlY4B5pS1qvNgcB09PHhCBYEOwLW/0ZAhhshv0LOEPQw/zyptKO8eIW0QArUftCFqGQ0ouIEFd+tMZVaitbNIvDPt/cXhOI9MWW6xv2K2Lz4sjkvb8PTkTIS1OzCfqP863J7vpzO84MUrE4mdfXvEABG4fx1oOoGHTkSvfKv/nkCoqESATZ33G0MPW7kBTkRWZODf6WIJ/eqCaYolLRu6fDwA70ji4JJ5sKL3vmKPVpQwKLmLG7qC2kNOrB6afzt2WIHnl53gXMv7wBh4no6fOZfutanqkPnt59iJ1DlMTrB7dUd+XMyEqvIXnyEunLyaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UgzFW3d4xFaTdzxuMn/y0TJwFzW6+RWghVCR3xZ3I/4=;
 b=TuYiaAptDM3S1kQoOHFykEqzVRT/KYxwG78V3It2pdfFfiiFF6XNCFdqLwwBNn/qMGQlXhHCGDeJfGRAuov1DJkJQa5awUY+JKbe/NwWD+9kcWG+DL1LzaNZFl2bQ1y3ZUVDzj2o9xaDYudK4wGyDF6Fo5OJQ3tZeiX0Dahzihc=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB0936.namprd21.prod.outlook.com (52.132.131.166) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.8; Mon, 30 Dec 2019 20:13:55 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Mon, 30 Dec 2019
 20:13:55 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2,net-next, 0/3] Add vmbus dev_num and enable netvsc async probing
Date:   Mon, 30 Dec 2019 12:13:31 -0800
Message-Id: <1577736814-21112-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34)
 To DM5PR2101MB0901.namprd21.prod.outlook.com (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by CO2PR07CA0066.namprd07.prod.outlook.com (2603:10b6:100::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2581.11 via Frontend Transport; Mon, 30 Dec 2019 20:13:54 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2ad1b826-c6f4-40ec-ff8e-08d78d64cb67
X-MS-TrafficTypeDiagnostic: DM5PR2101MB0936:|DM5PR2101MB0936:|DM5PR2101MB0936:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB0936F2D0C02E5698F9061214AC270@DM5PR2101MB0936.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2887;
X-Forefront-PRVS: 0267E514F9
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(396003)(376002)(366004)(189003)(199004)(5660300002)(52116002)(6506007)(66556008)(186003)(2616005)(956004)(6666004)(16526019)(4744005)(26005)(66946007)(66476007)(478600001)(2906002)(10290500003)(8936002)(36756003)(316002)(6512007)(8676002)(6486002)(4326008)(81166006)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB0936;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 721nPN76q1jge6wSCTze1ofIEHEtBY7wmVGXLj4nDNkZJkB0b6rjzmYlknHyw+mlzqYNQ3BCYM9fvV9eeXbu937vwC1dP5SCJuuAFv+E4z5oXB7R4qNvb37bmQyvTZ0PLhFmPXqMYM2PrDGXtKz/1/+ni3z71gTLxnJjgMHHChXtSR0hWoXSYO2574NlXQyxn3kqUjUDahq3gUFZ8Cz9kfMuMYQlCIbR5DHvyS2Eqbw2TA4/Cs0ruqSl4JocmRY9TkYCOd6hiiRCb0A6bndNq7sduYXY8twXf4lEHQE6JZvTA2nMcVmjeEtmrVphdsWlW6c6VnyQ8OCMqDDl81q9SKHG1khYlR9a3tZ2hkkZ4h5PJrF/WF+5m/lUDmGJRX96QwZ2ST1dMGQnPKb5kjGbkZQ0AoCmH8QbK9XJF1fNiYxaYsTAonVbWvEp07QalwjS
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ad1b826-c6f4-40ec-ff8e-08d78d64cb67
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Dec 2019 20:13:54.9608
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6d6Hz75D50qJQ6JnJ/H+vluiTK92w9f4DgRn6tth62QtC8YnTr3lKeS/RaOY7Dxymgzsa2zhni6qv4TlCa2U9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB0936
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dev_num for vmbus device based on channel offer sequence.
Use this number for nic naming, and enable async probing.

Haiyang Zhang (3):
  Drivers: hv: vmbus: Add a dev_num variable based on channel offer
    sequence
  Drivers: hv: vmbus: Add dev_num to sysfs
  hv_netvsc: Name NICs based on vmbus offer sequence and use async probe

 Documentation/ABI/stable/sysfs-bus-vmbus |  8 +++++++
 drivers/hv/channel_mgmt.c                | 38 ++++++++++++++++++++++++++++++--
 drivers/hv/vmbus_drv.c                   | 13 +++++++++++
 drivers/net/hyperv/netvsc_drv.c          | 18 ++++++++++++---
 include/linux/hyperv.h                   |  6 +++++
 5 files changed, 78 insertions(+), 5 deletions(-)

-- 
1.8.3.1

