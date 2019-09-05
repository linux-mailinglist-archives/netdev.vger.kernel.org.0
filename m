Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0327AA395
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 14:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388100AbfIEM4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 08:56:25 -0400
Received: from mail-eopbgr810043.outbound.protection.outlook.com ([40.107.81.43]:45792
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731008AbfIEM4Z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 08:56:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ksdwq0jvy5Jwff4s1/w9wI6XXGnFBJtqyf8W4G1e7PSSMu5NzzXL2AR25DKuCYtStemNKwRgjSJ/waqyRj26Jmg5sAE0Ul7UyXBCen7PdoQOuSR7Pcp9ZxQVLEo734UD9gSBmSDrlEGu8cBE2w8HTi/WRJbyEOwtS9b2hYS7L2v+Y4KXLBf1N211KFzLDjfjwfR648lKziRFkn4PIkayhqokFi1DAtflEZ7BJOjwnObjKXgRhlyv75SfyvrZ2lrGa89Nk121WSpDgVsmn+0FCXi2Zcd85LYLVXAdscQRGUSYxOqMV833bDfjSvJeNQCWUgYszklilboqMDnWDLfVTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpyOa6gJlaIKt0fDzsXiEVewzTZs3poezB1NCiyBiso=;
 b=OHYAa6RDoaTeU4r+wMXOECORQ2mcHH8W8NTx+e0HTth1hwzsCn1wdgMxHRAUnU/Z1Y/0ccC766CyuNxSGFChm3NeITP789IVyVIsMeJW22QAOkRpwYlEFpYqR3G917Xi3PDncTypQWuvYdOFMGwkpr/fC7MPH63DgW8fyuZigGCSU5Ec8rc2JioOnEltoOjoGQZQepsmf/kIqNt7DUYVV4sROjfiZClbjV5hmjkYTosmeW/0z4DUoh9e2aynXtHN1pl7AfwjNbuIhIzwpNQs8GV9RmuWC5Xp/sD+QbSIfgiXWmplqM7DGy/GQFh21mr42H0AKFr2w1oi/s1Vl0OzGg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 149.199.60.83) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=xilinx.com;
 dmarc=bestguesspass action=none header.from=xilinx.com; dkim=none (message
 not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector2-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SpyOa6gJlaIKt0fDzsXiEVewzTZs3poezB1NCiyBiso=;
 b=GSi1d+a56AKwgZxXxV7+7Ugb0eX5Tb/ySU+K47QONrI8Ms8Ij8S+j7JunYbKr7p3VMaVqpBNYWgPoKs9W1/0+3U6up8QQX8RvlhK8d/FmMJsWCRSzDVu0N2keOzFUy95MrzypIPIxa5MtrBN5f6s4uPcuEzjMGAXdyTCPHeRGx8=
Received: from MWHPR0201CA0034.namprd02.prod.outlook.com
 (2603:10b6:301:74::47) by SN6PR02MB5261.namprd02.prod.outlook.com
 (2603:10b6:805:70::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2220.18; Thu, 5 Sep
 2019 12:56:19 +0000
Received: from SN1NAM02FT016.eop-nam02.prod.protection.outlook.com
 (2a01:111:f400:7e44::206) by MWHPR0201CA0034.outlook.office365.com
 (2603:10b6:301:74::47) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2241.15 via Frontend
 Transport; Thu, 5 Sep 2019 12:56:18 +0000
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=xilinx.com; vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=bestguesspass action=none
 header.from=xilinx.com;
Received-SPF: Pass (protection.outlook.com: domain of xilinx.com designates
 149.199.60.83 as permitted sender) receiver=protection.outlook.com;
 client-ip=149.199.60.83; helo=xsj-pvapsmtpgw01;
Received: from xsj-pvapsmtpgw01 (149.199.60.83) by
 SN1NAM02FT016.mail.protection.outlook.com (10.152.72.113) with Microsoft SMTP
 Server (version=TLS1_0, cipher=TLS_RSA_WITH_AES_256_CBC_SHA) id 15.20.2241.14
 via Frontend Transport; Thu, 5 Sep 2019 12:56:17 +0000
Received: from unknown-38-66.xilinx.com ([149.199.38.66] helo=xsj-pvapsmtp01)
        by xsj-pvapsmtpgw01 with esmtp (Exim 4.63)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1i5rJB-0001hh-Dy; Thu, 05 Sep 2019 05:56:17 -0700
Received: from [127.0.0.1] (helo=xsj-smtp-dlp1.xlnx.xilinx.com)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radhey.shyam.pandey@xilinx.com>)
        id 1i5rJ6-00034q-8z; Thu, 05 Sep 2019 05:56:12 -0700
Received: from xsj-pvapsmtp01 (mailhub.xilinx.com [149.199.38.66])
        by xsj-smtp-dlp1.xlnx.xilinx.com (8.13.8/8.13.1) with ESMTP id x85CuBcM022841;
        Thu, 5 Sep 2019 05:56:11 -0700
Received: from [10.140.184.180] (helo=ubuntu)
        by xsj-pvapsmtp01 with esmtp (Exim 4.63)
        (envelope-from <radheys@ubuntu>)
        id 1i5rJ4-00034e-Vb; Thu, 05 Sep 2019 05:56:11 -0700
Received: by ubuntu (Postfix, from userid 13245)
        id 228A0101052; Thu,  5 Sep 2019 18:26:09 +0530 (IST)
From:   Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     michal.simek@xilinx.com, anirudha.sarangi@xilinx.com,
        john.linn@xilinx.com, mchehab+samsung@kernel.org,
        gregkh@linuxfoundation.org, nicolas.ferre@microchip.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Subject: [PATCH net-next] MAINTAINERS: add myself as maintainer for xilinx axiethernet driver
Date:   Thu,  5 Sep 2019 18:26:08 +0530
Message-Id: <1567688168-20607-1-git-send-email-radhey.shyam.pandey@xilinx.com>
X-Mailer: git-send-email 2.7.4
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-8.2.0.1013-23620.005
X-TM-AS-Result: No--7.274-7.0-31-1
X-imss-scan-details: No--7.274-7.0-31-1;No--7.274-5.0-31-1
X-TM-AS-User-Approved-Sender: No;No
X-TM-AS-Result-Xfilter: Match text exemption rules:No
X-EOPAttributedMessage: 0
X-MS-Office365-Filtering-HT: Tenant
X-Forefront-Antispam-Report: CIP:149.199.60.83;IPV:NLI;CTRY:US;EFV:NLI;SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(136003)(376002)(2980300002)(189003)(199004)(70206006)(8936002)(47776003)(103686004)(70586007)(50226002)(305945005)(81156014)(81166006)(14444005)(50466002)(478600001)(4326008)(48376002)(5660300002)(356004)(8676002)(36756003)(186003)(106002)(2906002)(426003)(26005)(16586007)(316002)(42186006)(126002)(476003)(336012)(107886003)(6266002)(486006)(51416003)(52956003)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR02MB5261;H:xsj-pvapsmtpgw01;FPR:;SPF:Pass;LANG:en;PTR:unknown-60-83.xilinx.com;MX:1;A:1;
MIME-Version: 1.0
Content-Type: text/plain
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5ede6d9b-4231-4a15-499f-08d732007178
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(4709080)(1401327)(4618075)(2017052603328);SRVR:SN6PR02MB5261;
X-MS-TrafficTypeDiagnostic: SN6PR02MB5261:
X-Microsoft-Antispam-PRVS: <SN6PR02MB526178C7D645C6F0B47E924DC7BB0@SN6PR02MB5261.namprd02.prod.outlook.com>
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-Forefront-PRVS: 015114592F
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam-Message-Info: K5f8Ay9YJXQn44Yc9HPtzuy2ZsvQGiZk7FgAgdjYXNQQT+yj9zHrO6F7Vx7PApk+Puupkl+MU3SW09wmD8byFUC2hD+DDdCLehxoGNxLs2km1Y9bIKFBy2gOcNvPjAc3cQi4sJ3CRwGeYIP1TwVp0GrGn98ankU0Q7f+55WTSgO+A//i3rPJGO//+D/fbxSo2e+CgBU/px7diW3xEeiUswR57Yar10CrVXYPMz3mbIRmRJer1IhJMJw3D9tASVjeA+1ZqILMeZJlGsJ0ah1v/GMtxsEePqQKm9bSzoSqIvpVID+Mu4g95u/FaMlIeNw6skekN4vgIQZQIZIuM5ZAiRng9xENYw/8suz3TfDjae8aO8+V2K7lb0QuBUbq8Bqdx7Y4KigBDhEh9LQCAjEv202vPxW+mANLFXm5OOVdaSA=
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Sep 2019 12:56:17.8069
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 5ede6d9b-4231-4a15-499f-08d732007178
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83];Helo=[xsj-pvapsmtpgw01]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR02MB5261
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am maintaining xilinx axiethernet driver in xilinx tree and would like
to maintain it in the mainline kernel as well. Hence adding myself as a
maintainer. Also Anirudha and John has moved to new roles, so based on
request removing them from the maintainer list.

Signed-off-by: Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
Acked-by: John Linn <john.linn@xilinx.com>
Acked-by: Michal Simek <michal.simek@xilinx.com>
---
I am resending this patch as earlier version didn't go through mailing
list due to some config restriction on the external email addresses.
Also adding Michal's acked-by tag.
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 84bb347..16fc09d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17732,8 +17732,7 @@ F:	include/uapi/linux/dqblk_xfs.h
 F:	include/uapi/linux/fsmap.h
 
 XILINX AXI ETHERNET DRIVER
-M:	Anirudha Sarangi <anirudh@xilinx.com>
-M:	John Linn <John.Linn@xilinx.com>
+M:	Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
 S:	Maintained
 F:	drivers/net/ethernet/xilinx/xilinx_axienet*
 
-- 
2.7.4

