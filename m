Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACC581204FE
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 13:09:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727548AbfLPMIm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 07:08:42 -0500
Received: from mail-dm6nam12on2076.outbound.protection.outlook.com ([40.107.243.76]:32352
        "EHLO NAM12-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727335AbfLPMIm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 07:08:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PFvGpNubNwSfsKcN129ybZtqc6s/bIOnos7gZHcFSwyYjFE2OPkb9XAfwPQyVX/dEMKgyVJ6XfnN9DqQp9u/YA6Hv9ZaGNvJ3ucfD3d9JLLN/jhucpGvIiA59Yth16REiMwdMEk8I5U/VMiPV9kg58pdpoacRrpOY9QgXrqQD+HPNtKt3F9JoymDrbIX9ZFVfNFOfFX+i6YyIQbf443OwStXZqxltsKV8lsAkaOTjZPUA8wV/Op3pbbzIwyh8lf7rUWFqw+orRU40VW560ETxKViY7SUjbDYvUlqLhwYwkv0LvBk4l+2WPjpnb274I843xSs9C6GeMac4Mo8+AwWIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THSOwZz+AjXm7AgygKqx0NIurkneReTIi34/h6fE9/k=;
 b=Mzux5/4nESmUCxYhv6WmL0GG0EsncJrqB2IXeAL+VzfqXJtYvldddP0WqoLsri0gg78RSnrJhPGoK81CJx8qkC92vBm+KRodOxJqq/XvUCiCUb1n3JEHgbLbtpecQTVbuuZk+jdqudAHLaDWVfnR9y/SQh687sgcFlOCrtaMuOdJt/PlhoGnGr75Z5b6PsgECntkwh5jO5lgOb84MrehlxIfzzCFQ31MAwfnbAB1Pa7RBN6sCjNZgsfwvKmbLe2A4xkuZuTz7PIRYAPl5Fnk5X5Od9aDm67UTK37LTAEL0LXssAiVm3BjtF6EqPqCSbzJmEtjaK1GVyPnyreZ/e8sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org
 smtp.mailfrom=xhdpunnaia40.localdomain; dmarc=none action=none
 header.from=xilinx.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=THSOwZz+AjXm7AgygKqx0NIurkneReTIi34/h6fE9/k=;
 b=fMuuuO7lWI0WTnE+0UDVVg8QW8NkDYjcev52MZe0eehYVuDO1xrgJv3FFRA4FlHc5/bIdIm5BMM1LL7tCghUAtBq+h257gvGKvn7sgrDEtcmXfNRiaApoTY/VPRboVGLyYCj/eFFztniD6IQdYjGEbFiNmFRLse0hZOsZWzKYmg=
Received: from CY4PR06CA0065.namprd06.prod.outlook.com (2603:10b6:903:13d::27)
 by SN6PR02MB5134.namprd02.prod.outlook.com (2603:10b6:805:74::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.15; Mon, 16 Dec
 2019 12:08:39 +0000
Received: from CY1NAM02FT053.eop-nam02.prod.protection.outlook.com
 (2603:10b6:903:13d:cafe::68) by CY4PR06CA0065.outlook.office365.com
 (2603:10b6:903:13d::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2538.16 via Frontend
 Transport; Mon, 16 Dec 2019 12:08:39 +0000
Authentication-Results: spf=none (sender IP is 149.199.60.83)
 smtp.mailfrom=xhdpunnaia40.localdomain; vger.kernel.org; dkim=none (message
 not signed) header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=xilinx.com;
Received-SPF: None (protection.outlook.com: xhdpunnaia40.localdomain does not
 designate permitted sender hosts)
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 CY1NAM02FT053.mail.protection.outlook.com (10.152.74.165) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2538.14
 via Frontend Transport; Mon, 16 Dec 2019 12:08:39 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAz-0001lA-F2; Mon, 16 Dec 2019 04:08:37 -0800
Received: from [127.0.0.1] (helo=xsj-smtp-dlp2.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAt-0000wd-KA; Mon, 16 Dec 2019 04:08:31 -0800
Received: from xsj-pvapsmtp01 (smtp-fallback.xilinx.com [149.199.38.66] (may be forged))
        by xsj-smtp-dlp2.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id xBGC8Ugu024876;
        Mon, 16 Dec 2019 04:08:30 -0800
Received: from [10.140.184.180] (helo=xhdpunnaia40.localdomain)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@xhdpunnaia40.localdomain>)
        id 1igpAs-0000wK-A7; Mon, 16 Dec 2019 04:08:30 -0800
Received: by xhdpunnaia40.localdomain (Postfix, from userid 13245)
        id 7FF7C1053CC; Mon, 16 Dec 2019 17:38:29 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, michal.simek@xilinx.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, git@xilinx.com,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next 0/3] net: emaclite: support arm64 platform
Date:   Mon, 16 Dec 2019 17:38:07 +0530
Message-Id: <1576498090-1277-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--1.472-7.0-31-1
X-imss-scan-details: No--1.472-7.0-31-1;No--1.472-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(346002)(136003)(396003)(428003)(249900001)(199004)(189003)(4326008)(336012)(6636002)(4744005)(5660300002)(450100002)(42882007)(356004)(2906002)(2616005)(6666004)(26005)(81166006)(81156014)(8676002)(498600001)(8936002)(36756003)(70206006)(42186006)(316002)(6266002)(70586007)(107886003)(42866002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB5134;H:xsj-pvapsmtpgw01;FPR:;SPF:None;LANG:en;PTR:unknown-60-83.xilinx.com;A:0;MX:0;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a2ef802b-dfdc-4cd4-86ed-08d78220af86
X-MS-TrafficTypeDiagnostic: SN6PR02MB5134:
X-Microsoft-Antispam-PRVS: <SN6PR02MB513428AE2220737778B784F1D5510@SN6PR02MB5134.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-Forefront-PRVS: 02530BD3AA
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kHTUQAiFGRXQG0SPRcCNaWSTB1sf3cBbPVQv50iSDMX9uyvEWYK1b0FwJYNPxUCYThArvjVymb8bCpO2v1LhjEY/n5r6kiFBfdNXv27UzAbw3/cfQ0qCv6VAUvM8TcGuTuRTs8/zn75VQfZu7SSPsEB9sIerhcKKWw4ZLz+0Zag6HdzdxBMdpV7jgzvgtiq+2T57dlsCFW7xOTm+MlaOxK7m115dZPkzNC7kMeZHD3PdnIvWEzx1EU9lM3ejG6PNcsBAipbNN0XDKjWshyfnZ+jjBkvMLHFBuh8ecePoXBUgWp+N7Ty8yL4oAgKeUxdpHfSdPTHX+pxEXI56cMY/eZj5YWe3zNFGzDfkRHbvwEjB8y4cwHXccxuJLN3BxxGlGMEj0XLjgxEfT7xJUFW5ThrwTR3NQtTMBnqg3DDIJHiB/RJAZk/zyLqMhNwcBzUW6v9Inwbj56S6Lptc46W78eNfz2yJGora/zpVG4WEBI4=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Dec 2019 12:08:39.0327
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: a2ef802b-dfdc-4cd4-86ed-08d78220af86
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5134
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

Michal Simek (1):
  net: emaclite: Fix arm64 compilation warnings

Radhey Shyam Pandey (2):
  net: emaclite: Fix coding style
  net: emaclite: In kconfig remove arch dependency

 drivers/net/ethernet/xilinx/Kconfig           |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c | 45 ++++++++++++---------------
 2 files changed, 21 insertions(+), 26 deletions(-)

-- 
2.7.4

