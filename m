Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC7A12DC00
	for <lists+netdev@lfdr.de>; Tue, 31 Dec 2019 23:14:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbfLaWO3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Dec 2019 17:14:29 -0500
Received: from mail-bn7nam10on2133.outbound.protection.outlook.com ([40.107.92.133]:6706
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727054AbfLaWO2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Dec 2019 17:14:28 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Sq5aJtawhNlVYfJnzYbUeC107HWPtScjPKUCAYCcLMcbu3cwn6JwCRLHcNeBeCeqF3DpMqayT9h096UFurHn54mzwBL13fNOp/IFtUhGCk8edDR6DQ/n44RiklC2z+OI4ffv8SPPJJ+1RzyiY/kMkmzbj++3WoDkEIfEsIuhtp/UHb5rrDMd6FXZj+qtzc0Jb18XvFpA3x31/ouNBQGN4WXTWpDzZhhuPwI4TheLm9E8H5bKCSri0aKiEZrNFA6/5qEHNVahVPAQeXwra41i02WX9Xsd8yLRAO2LP0WIMbR83gdSwQ59NhtY8XEgy6e3EMInWoZQ57howcgjyT4f/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpMEBuCOnClorLvXgI4+sFTHckYa7/rn1JIAb8MQ8dQ=;
 b=hvbcUwt7CPmp36oys4eVguhzpE8G64/Vgh3mZzHl0MNiojrVVQf3NeANhsVVsehYtVHXEJgluyJbWcCTJIda/CJuhU9tlUzEWgZkhaX4zNrUWXCQAY1Dh0sxDd3xeY29pmfen8WIRANv9a6AIspFrA+uT0p0AOOjr16aFOyR4H5VoN7Ix5xHODz9JwguwTWrByU16z+xCPA8vQzQMV2kedUYkBnGzgWp9Tqk8SvAY2NXRhnKYlbIisxwCEEjYxFoBNCzlWkf5Hu5d87PSXAXKgU6Uwzhg1WttqVseWnqwtGysWfdZEjUN5prVoxHhHBD4xqngiZwv1t+UvwqQ02cFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LpMEBuCOnClorLvXgI4+sFTHckYa7/rn1JIAb8MQ8dQ=;
 b=gnQJ+vE6w5icFVbYO+B4CfRzzZPb+TjlSH+zkffDmfU+4GC3wA9st5KQamtOKbagTSX/Ok7xIHwAkaLqWSZwKSyN+ZLTUP54Mfr2NWF44h7nlltiv7VK0rNvJDcki0cCvu/I4tZJ6EkAZ2+9xxA0bP8BjYEKhHX6fkdZsJ9aKHk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=lkmlhyz@microsoft.com; 
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com (52.132.132.158) by
 DM5PR2101MB1014.namprd21.prod.outlook.com (52.132.133.36) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.6; Tue, 31 Dec 2019 22:14:25 +0000
Received: from DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91]) by DM5PR2101MB0901.namprd21.prod.outlook.com
 ([fe80::6009:72e0:9d02:2f91%9]) with mapi id 15.20.2623.000; Tue, 31 Dec 2019
 22:14:25 +0000
From:   Haiyang Zhang <haiyangz@microsoft.com>
To:     sashal@kernel.org, linux-hyperv@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     haiyangz@microsoft.com, kys@microsoft.com, sthemmin@microsoft.com,
        olaf@aepfle.de, vkuznets@redhat.com, davem@davemloft.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH V3,net-next, 0/3] Add vmbus dev_num and allow netvsc probe options
Date:   Tue, 31 Dec 2019 14:13:31 -0800
Message-Id: <1577830414-119508-1-git-send-email-haiyangz@microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: MWHPR17CA0086.namprd17.prod.outlook.com
 (2603:10b6:300:c2::24) To DM5PR2101MB0901.namprd21.prod.outlook.com
 (2603:10b6:4:a7::30)
MIME-Version: 1.0
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (13.77.154.182) by MWHPR17CA0086.namprd17.prod.outlook.com (2603:10b6:300:c2::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Tue, 31 Dec 2019 22:14:24 +0000
X-Mailer: git-send-email 1.8.3.1
X-Originating-IP: [13.77.154.182]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: a5b45bf7-9887-4b9a-77bd-08d78e3ecb4d
X-MS-TrafficTypeDiagnostic: DM5PR2101MB1014:|DM5PR2101MB1014:|DM5PR2101MB1014:
X-MS-Exchange-Transport-Forked: True
X-LD-Processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
X-Microsoft-Antispam-PRVS: <DM5PR2101MB1014663AE84A4F8F36C2A9FAAC260@DM5PR2101MB1014.namprd21.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-Forefront-PRVS: 0268246AE7
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(366004)(346002)(396003)(39860400002)(376002)(136003)(199004)(189003)(6512007)(4326008)(36756003)(6486002)(66556008)(66476007)(4744005)(66946007)(10290500003)(6666004)(8676002)(16526019)(5660300002)(186003)(956004)(6506007)(8936002)(26005)(2906002)(2616005)(81156014)(478600001)(81166006)(52116002)(316002);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR2101MB1014;H:DM5PR2101MB0901.namprd21.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: microsoft.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tHrDCQTxAzto/UEuq/TgDzFUvFoqYtb1W8qmrsVdOx9WWmklcIGlsty33AtjmYUFNmEEglkkwWE+v/nb2G14W9RAMscywbn7Zhzb173LQyq6bwYqu6sB0XY9vqg9qV2OkPAm7rzPYTBbxSLQcGic7SixuVSpQCX75m4u6BEpOqRAyMbd1i6LWgk0kYn2ZKaFvDfBp7hGHQOSSvbzVDVQ4ZlDzuKwv5VF3iBk287pdHl3wf887h81ZQjEqHLxmzVYEt+FLWV8HVu4B3y38kHb9vc+STGNGOIa1gseklyh0veRkQ4/EJf0475Pczgd/GjCNcFma/ajsbAYwzxIFmbU8LsWcyjtLK4HvKaD21CCLvNh8S7f5xEbRWzivrIfE1iHV/+iOudvBSggHIE4/7ArnXvTbPgk8WPG+CmVrKAUe0orPkR+7skEuiykdfY8moEl
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b45bf7-9887-4b9a-77bd-08d78e3ecb4d
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Dec 2019 22:14:25.3048
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uejf7PG9uUWorrVe9uEDg+SVmCfhGeIo7hNu8zOdKsu4kDNdtlbt7V9LJ9qOA9/HCQ+CAC2uEoPEwRbcbatFMQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR2101MB1014
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add dev_num for vmbus device based on channel offer sequence.
User programs can use this number for nic naming.
Async probing option is allowed for netvsc. Sync probing is still
the default.

Haiyang Zhang (3):
  Drivers: hv: vmbus: Add a dev_num variable based on channel offer sequence
  Drivers: hv: vmbus: Add dev_num to sysfs
  hv_netvsc: Set probe_type to PROBE_DEFAULT_STRATEGY

 Documentation/ABI/stable/sysfs-bus-vmbus |  8 ++++++
 drivers/hv/channel_mgmt.c                | 46 ++++++++++++++++++++++++++++++--
 drivers/hv/vmbus_drv.c                   | 13 +++++++++
 drivers/net/hyperv/netvsc_drv.c          |  2 +-
 include/linux/hyperv.h                   |  6 +++++
 5 files changed, 72 insertions(+), 3 deletions(-)

-- 
1.8.3.1

