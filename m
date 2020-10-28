Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7AD29CD37
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgJ1Bir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:47 -0400
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:55640 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1833081AbgJ1AJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Oct 2020 20:09:45 -0400
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177]) by mx5.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 28 Oct 2020 00:09:37 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E+Ix+4YTH/Y/s2ftVqENwa2Ef5Z4jI28CLWIZn2dKfkmtCWDgfYswL25KLJaGoyq+hlFliXNO/L30bTnnUoli37jdniIiVgxtcV1LzKoo6whdEYvZQx41dVF5dnvXoGYLVelaEcRjAceruocdQH9GJxEPyZoXdqspoNoj/uelQc/HgYxnNt8DNPPpHBe5gfOYVe2MbcC4es2m/fL3rS51ulJ6I9t/ES2TwvlR0DPDvVd+dY0taAGDc3kReGhCYcY2aQVwpHfNIahxF0O/tvajl4BV72GMotwsqKFYdqMHMvMeG3XgkdwJpmbbSPK8qYXKehf9Uk/gtlXKx9JNl8e+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVeJPFnY66ukP2RQoBED8DfZLVWxBlrS8N01PAgmsec=;
 b=We4yBoV7FCPqk99FpS9iLE8Czy21UDlmdl+KpyLlaS+7fjWqJw+nDcbb217E6YJcYTCJ7OfEPNXnPhBKSUhWwUqBGGFN2NIxSVXZmjGl4sHG5ARf6111ceYFx96RNtjcNNBTqLDC4QAa6lEhK2ffgLl5aT9geFoKG24MmJLGdzykD4L8New33GYJ5XdCxXsk1oNmioBiIHrCbftclrTYi82jxIVK6hFMsvj8MD0DHjV7xFrNoxCMvgSrPuMaEmy6Lxc2xsRxrnxa9e9Z/+p1Qu2LMVP5x/k+sTr4o0Ri+0gro7AS89ROb2HuZdElOKppG7n/QO9rC0HwVLYFX/YsoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVeJPFnY66ukP2RQoBED8DfZLVWxBlrS8N01PAgmsec=;
 b=svJm89UqtHMUV369jpqbn7ZHPSo7K94Shm2mmJUb6dnqetpwalsHBo+Pya1x3jFKOd29VEg4LI5H64uoadgYveI7UDznE3NML2Sc80Lc+ImrEGCTbz/jdoVxWqvzkoIEm/YtlbsPHj7qWzhNIDD7vNer1E7/FQJcXgeLyg2BLMQ=
Authentication-Results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB2819.namprd10.prod.outlook.com (2603:10b6:208:74::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Wed, 28 Oct
 2020 00:09:36 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Wed, 28 Oct 2020
 00:09:36 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     f.fainelli@gmail.com
Cc:     andrew@lunn.ch, davem@davemloft.net, gregkh@linuxfoundation.org,
        kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [PATCH v5 2/3] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Wed, 28 Oct 2020 10:09:12 +1000
Message-Id: <555c152c26952102a76f8ee40261b68c24c67ef2.1603837679.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1603837678.git.pavana.sharma@digi.com>
References: <cover.1603837678.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SYXPR01CA0139.ausprd01.prod.outlook.com
 (2603:10c6:0:30::24) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SYXPR01CA0139.ausprd01.prod.outlook.com (2603:10c6:0:30::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Wed, 28 Oct 2020 00:09:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56cd229c-e318-44ad-db16-08d87ad5c148
X-MS-TrafficTypeDiagnostic: BL0PR10MB2819:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB281914082421818967C72B1F95170@BL0PR10MB2819.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Yp1LIPcRb6pFD/a8QTLL2UPoJ4plAR9w0x6b4fH1AH+XEqTi8pDLQthyTKxxoekcG6Qg2ZBg+LzakLWxwqby09qBL+AajC45ZmN1u4NedS96ark1k5d6O+hzJPKrWw/Wb6kvOy3CcbbLYzjgkm6WuaVsujIE0dnsQHalxAPhR2xWKc3flmEXUJxiqLWKb5W9smfnnyB9NUIQd3/nn1ZwyMiH29l5YNkcucDhYf2rdwwm+1gnpBHZQFTa7VIVcPqZKnFSZX4WNOYXwF8ypO1OLcUJgdWLSHU1gggwruJxN+yCyy7OXeInCnbfB4rsCyZg3/Xl82Mu/gXA4dDuJ/bDbaCvxFxOLo21d5DBafhaiEcHtNoOXQFgoY4rh2ujlY3f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(136003)(39850400004)(376002)(346002)(366004)(52116002)(4326008)(6512007)(6666004)(6486002)(2906002)(478600001)(44832011)(956004)(316002)(86362001)(36756003)(6916009)(66556008)(8676002)(66476007)(66946007)(8936002)(69590400008)(2616005)(5660300002)(4744005)(26005)(16526019)(6506007)(186003);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: LxP5t6VNNN3m9eMEnU137Z1yk+oEyfghoyOjYEGoYceJImzoCpyOUNbXPv3jKzTujBt01cSYRcG/jNlZg94BS3Sf3eXxwD25tpoTPiUw4mI6soU/2Nrg56LruXY4lp+f7xNgitHr+MJqRU5F8GAo+nDeTNxOwe9ww6Wi7z50VB8BOadtrHUSiHYYgPicJdQni9GHSRvizXYnQubo7tToMWoex7RVwqzFsqEKF/A9I3ujEJ8uL1eNIJ571/NzGJBhkhzPg9srrOtLsk7I+Gvq6FL3kncFhEsQ7pd/XdP8sGRA3eVBkTgY/y66l8BIy+uRt+Ke4BJzHX3SipX7jonxdyYFeRj6iGH/CZ4w9Fb9D+2hTssqOyCbi+ilIAXnJSNWSeFcVarVEFxWXdhtfslDNN+CzBuHVjArVjSm/cIiV9wUuch8Ur5my3QqAL7tz+JII0kyW1GxIHbSdw6vyC0O7gyfLbgoBJ3UDxM0JDU6cx9VMp56ElppYAvD5VmYf1LDDkYs8uMQWeLHv0FJA8HWfeZzl6yio2ekmVRezViOjIKj4tyuzO8cCVZPkmQLDPZKlW34gT1ynfZgfIkEOfGTM45S1C+roeox/GVId2OONIpLkbL6zoiNNZ92MvYM13mMjVxnu9kzE/ds/73wIzqbuQ==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56cd229c-e318-44ad-db16-08d87ad5c148
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Oct 2020 00:09:36.6716
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Z6HekfO0j9zkpv8TTRsh1MXbNu2lAPeDCeYkNLhbEHYjxHRfZbin49tu2mhJRKRh0VyQ0vigaYzpXQu6mLLxTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2819
X-BESS-ID: 1603843777-893008-31473-113584-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.56.177
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227828 [from 
        cloudscan18-232.us-east-2b.ess.aws.cudaops.com]
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

Add 5GBASE-R phy interface mode supported by mv88e6393
family.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fa2baca8c726..068c16fd27dc 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -92,6 +92,8 @@ properties:
       - rxaui
       - xaui
 
+      # 5GBASE-R
+      - 5gbase-r
       # 10GBASE-KR, XFI, SFI
       - 10gbase-kr
       - usxgmii
-- 
2.17.1

