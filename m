Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD3C32B9F3F
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 01:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgKTAZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 19:25:41 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:35676 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726324AbgKTAZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 19:25:40 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173]) by mx7.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Fri, 20 Nov 2020 00:25:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSgw8iAUXYPLEXplvfjne3854yJeBiipM0l64AQkOwyC/D616UX7S6luRt7bz+goypPhJzwoGBLZAICA8oM37BmvqP8Ggr+JWmjaxMOekoAEEKZFP3aFxRE0eTJ1G78jq8w6RW/Uj3qKFo6XDjMke4aR5Ki5eWOcMkUuUxD2UFfiyK5HYC/rOeo2lr1Nc9dEOBv+3hypviWUTtmk26lEsLge/aF8Wqd7Wll2HKkyqZABmIjCGbnCNmpVjhznzjSW4nG5EtQpzCTQvAfS1fBlQeBLagWoElH2kWzZSgQ4FeebeX01Mo/eIaGhyjG8+sL4Bs8se08JJi8HFet3ySVpZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=Xp06bCl1tQKqlQ1fDKJ38FzCKhe8kZnkmX3ZMeID6h3QhTYUzFq0PAGFDaOJ2x0qt4Qbo1BXcqdo/j1BpCPKffnvFA5EKqyFra2ENhVqoTj2vnQihjh00/ndtWl+0jyncDNOf4rabVQSYpT+N/9bMg8NUyYpojf7e8gbyOAjqYMqPTz+6CWvXIHx98Jy42DkzEmTzBW06BXf0aTaQeCbPwKmID7TchLjQ32hoKNjbH1IgmTo4KCDPQBFZrSf/dbuMd0p+KGubUj5A4+HgI1386pKs9JDuAlJe853kC72rJ2LSocDLylzuzJgEMmxIgRgGs7kGDsx9fDdFWgRTwux/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xZyIIcbULkqFuqRRVCOgfB002r4JFCtYt2FmxhjIbMk=;
 b=jkiETVOOj9guM2ZIqFtqCVXLLlozbUUJH1BGkg5VrsdENw+ee/lPs61p4AVIEyNOXrnEP7KwyeU3aTo7AjApPzDXGKe95iEe9zLgtYeuK0yOBYmJmSit/HsacFgGtsydC3kui/jL1/f4Wcfkk11pPtoFASA625IUroeoh8ZSPDs=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB3870.namprd10.prod.outlook.com (2603:10b6:208:182::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.25; Fri, 20 Nov
 2020 00:25:25 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%9]) with mapi id 15.20.3564.028; Fri, 20 Nov 2020
 00:25:25 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     lkp@intel.com
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        kbuild-all@lists.01.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com, robh+dt@kernel.org,
        devicetree@vger.kernel.org, vivien.didelot@gmail.com
Subject: [PATCH v10 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Fri, 20 Nov 2020 10:25:01 +1000
Message-Id: <e4c8097e78a3277a7ac90d6a4899b110657b13bc.1605830552.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1605830552.git.pavana.sharma@digi.com>
References: <cover.1605830552.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [14.200.39.236]
X-ClientProxiedBy: SYCPR01CA0009.ausprd01.prod.outlook.com
 (2603:10c6:10:31::21) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (14.200.39.236) by SYCPR01CA0009.ausprd01.prod.outlook.com (2603:10c6:10:31::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20 via Frontend Transport; Fri, 20 Nov 2020 00:25:19 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a1a68dcb-fa87-4ac8-679b-08d88ceac644
X-MS-TrafficTypeDiagnostic: MN2PR10MB3870:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3870FC0241A2621EE8ABB88595FF0@MN2PR10MB3870.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RfLcK+HmSE3PgLSwbUMp5+NnlpSbmrDYoRdlwK28CAlAiIlc2qvw3Suh4XXZR+9QNm2v1mdpRJQNc80qAqQ9uUP8XMxa9TLBDqQ9uCTq4FNUDK2Xyq4vItKdLYRvx+d0VG3ZupJKdsiqmZe5N646ROmWtqjVsMZle0XPK6qs1Km8smGZkywq9BPpOZgUPkTIWnRkY49Ip54tzZ6WAVarjvf0RSgGdplpT6eCVimlAaCfAlZMaxdwjt4+e7szt9ROqEcvTkqNcEbr7UEywCvSnsfdzTXMF70IGmqaoy5/xaTj/UqrHZfuwSKffYd/qhRpeo1HY3TCd071KFt9xVJbe8L4CVdDajst05JXQ2pUp0ecOEt3pkn61eMrz1j721qj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(346002)(396003)(366004)(376002)(136003)(8936002)(956004)(4744005)(478600001)(316002)(86362001)(2616005)(7416002)(36756003)(6666004)(4326008)(6486002)(44832011)(2906002)(6512007)(69590400008)(6506007)(186003)(6916009)(5660300002)(26005)(8676002)(66556008)(66476007)(52116002)(16526019)(66946007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: jtlYI/m7FbDThNMSErDM56OFeQSq6sEr9pzkfOXaxDzJhYLKn46nu/pRbRsDyQBevXTixR2Dz6eX2ClldzM0z4l1lXbG2UpYmvAs03gC2x04TS9f9GcrwaUJUIE5jp0qLqLSaUkAcQkz5oLOsqWDbMA/dLKV5Ark8oE2WtJ9NaUsPDaMnzaBFmXylzol+NlJfxpdc5dHiz5W5vSUITCAUAhtg7TNQatL172ubMjSUpbee/RvDcUFf5mJdXioPhVDZE8FbMT7UWM/dPJer4bkWieEqZmjGg4BlaXxqDpaWlK5pHaQryspEhymeIz0D1NLQbrv4PV5ELQlPvDPGWtXsxE7qsitXe0+2FRgZz7zVbquS2ND3Uycogd5YtGB6O0Ru2QevnefHYUFdfoKnVSLUDoYeiW5M65CJugKpH/wEMR0K1xWiKLIDdzmys9A3VF7lyL4ej+z434WtwKOVc60MMuUi30y0r2xpP1r8dDGhYOaKIb68tS4DkV87770nGak1m5Ij/rHiE2/V50PptwvE8COw8KxXvsR8juVcocBSlHvNnPLuMtst74tFoNr2J1ixrAGrOWJhhZ3SI8LxmfIhbxgf0r+rJjApQzAd7fkhUGreWYjmtn8AxIk2+HbVnzm4l+Y0Mk0BHOx4mJc3PL0lBebd6SMcxrRNlPA6oEBM0Rb0grYWfUhNzkREsyhchVvhx/wM1N9dIxr54ZqjzJKBb0AZov6K2DcBpX51ycnR92JVU7hzlzf2Nx0OniFOU0pv/+MKr25kCkF54aMBWVk/o559KcOASbX5ViJazzKhUP7LYylcwF8BEwhPBSgsnKd0Jn3CNUMxDgEfknCAzMCQiKiNpSJapnG1e2ViMC8AKYVx2WpfNBKVSIaoDFyDEy6YpGcyiLnU2PMaytif2TcOA==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1a68dcb-fa87-4ac8-679b-08d88ceac644
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Nov 2020 00:25:25.3127
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G4H1uz5omMrOGs3De+iyDL08RH886pV2QLuRCaj00m/GWZbri9GvhExz+B6AiRNacJLe60zqK5gsPUoZj6wXYw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3870
X-BESS-ID: 1605831926-893013-21606-631-1
X-BESS-VER: 2019.1_20201120.0004
X-BESS-Apparent-Source-IP: 104.47.55.173
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228307 [from 
        cloudscan15-37.us-east-2a.ess.aws.cudaops.com]
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

Add 5gbase-r PHY interface mode.

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 Documentation/devicetree/bindings/net/ethernet-controller.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
index fdf709817218..aa6ae7851de9 100644
--- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
+++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
@@ -89,6 +89,8 @@ properties:
       - trgmii
       - 1000base-x
       - 2500base-x
+      # 5GBASE-R
+      - 5gbase-r
       - rxaui
       - xaui
 
-- 
2.17.1

