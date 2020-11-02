Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCB7B2A24DA
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727973AbgKBGmF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:42:05 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:40948 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727306AbgKBGmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 01:42:05 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2100.outbound.protection.outlook.com [104.47.55.100]) by mx5.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 02 Nov 2020 06:41:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyvcbGv0xSNiLejXh+NSIGYWh6nQvANbxDTul31GSHyDXCcmEBfztHCOxVovZOGnc28a0Xle/rDz+Iy4J+xfEPD/q7bx31B+CFXaSOPBfKNrktDmcDGbilFOxD0BUfeiN6M0xiJUDk48e7oLYLosIKeL8AuKn73T4f40B6kABwgeMsZS3pKapvEN70NzKqOh0Jy0IiZPAlRx5rg8E8Nl80CDnBFkorSZImnVtveEpShwv4teiBC1UsOVonn/K/r341MUYhVEMCF9sDcTb3ESW6qnrC8tXx63l05bfrng8hk5BdrCn8RnOr5qrA6D6q/1czTK8UChsMeQ/cGPwbIhzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EphZS14ZK4eC+vCnXdfF6JazXYZxMaihbBuPHtuA4Lw=;
 b=UnNWj/fO81ZF9rfSlqucWQj9okZXeJQ1eYw4yCGvElPLT+kXPDqh94e/fQW2WWNVqs3ROJUdNmwmYfBqAicksbhjzRU34rO5FJ2bEmqXhJThHakQY/+WBNSh3lFZjDEkqDGXp8cqwJjaX6S+onHjqsGZ6kTySL2xzENn5kxB+/TgYxnY/8/4TtchfY68O6CUosHEvO7cT02AYD/ZgXrGZSWf9mRhD0MCbbY/tKxdu6Tu0SqcezTad/Mj2H9rybOeJIuBMO8dq3zgebO5IQBV5Ziwuif7DhYHYul1d8F3uHqLt0XNru0KxCLLzeWC4pMkLoZoD/5m20AxHO/Z+1vWYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EphZS14ZK4eC+vCnXdfF6JazXYZxMaihbBuPHtuA4Lw=;
 b=cNgX4K5AD2o/uhkNafCvCImH7gj3wUbRWhs/4fquk8GoP+iUxECrPMpBxK0pS/i/+iB9UQkWGDUBVnsL0sFwoZal523BixPNNuw+RxzjGjfgLvCLVHZT9/9BWbedN1YGXpc6FVhV/Xz/MCtoEWp7sggFtKRnxRrG9dNECUauTYw=
Authentication-Results: nic.cz; dkim=none (message not signed)
 header.d=none;nic.cz; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB3934.namprd10.prod.outlook.com (2603:10b6:208:183::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Mon, 2 Nov
 2020 06:41:52 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 06:41:52 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     marek.behun@nic.cz
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH v7 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Mon,  2 Nov 2020 16:41:29 +1000
Message-Id: <9cce0829ce8b2d9a92ecc0c8a1c6901cd1d079a6.1604298276.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1604298276.git.pavana.sharma@digi.com>
References: <cover.1604298276.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [210.185.118.55]
X-ClientProxiedBy: SYXPR01CA0147.ausprd01.prod.outlook.com
 (2603:10c6:0:30::32) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (210.185.118.55) by SYXPR01CA0147.ausprd01.prod.outlook.com (2603:10c6:0:30::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 06:41:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 72ee6da1-fffb-4096-d52f-08d87efa6190
X-MS-TrafficTypeDiagnostic: MN2PR10MB3934:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB3934603DCEC758D832B3B07395100@MN2PR10MB3934.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iFMruDSGnErwX22R4pEhpVK4k5JZ6KKrRCrGYjcfooeDrMrBhNY0lhE4FbjkLnh4OJyJbVfDIjBwplpSdau5z4f4ozd0DoA1DL9GWRaGHaPHcN2BSvR25LgNiW8A94u+h4k4C4l/9cAFyuY0XWUqR+dpTewr1S7kZgExHa1zm5NbArCoRXqw+zT3vQH7FGjfxs/AyL13MQ7Jy1bZ8Ykqn17kz5Wq5v+DYs1Pd5w7G4dQWs5LI+nWhr2wClxLojL/UcFR91353XSHlsX3kldSw7JAceHiw5K0eH73toCK9BMREptpByz2o9rwMEuqLttSVkO5gFHh4PUMMFfJZTZ1iQajxLdixEOPk8c9gS/+5Do4YunBc7c87faTkHqbDkiT
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39840400004)(376002)(396003)(136003)(366004)(346002)(66946007)(6512007)(5660300002)(6666004)(2906002)(66476007)(66556008)(316002)(478600001)(4744005)(69590400008)(956004)(6506007)(6916009)(2616005)(16526019)(186003)(44832011)(86362001)(6486002)(8936002)(36756003)(26005)(8676002)(4326008)(52116002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: f+MjCo+SSTXnuMaojY12yTu74sf5jmBQ2i5LCrjYGXIJHRdiTwA/NbFsepBL7XreIqPQHB3T4XQ3mX3VG5XW+EwMlfUaYBtSMrccnWbJ1k5X8+S7XsO22D7ZECWWlopndo7v+MylWUURle3wjj47/8LjUp90OZkyvdhZR9qehdMY8shj+2XFdBxk7qiL7mupOCU8fLAjoq10/ibMkM2t5pg8YyEdGYorp7xJjpU+lh4M7XNk6yDMy5iuDbRAxZGehGKGbeMMRmGahVD8z+K5n0433g0P/0v9CE9f1McTIKafpC/LkqlwI9MFucbDmMQQf/3Bj23x6xv/UsSEXM4JnBpXPeh6bzuU6ITG4mLRGB1cRskdJxEeNkDZ7GppEGHQ51MfZVyG1OnPJr5VRB4IxVSNRqajaXYW6fpfLtPecspAS6QN9zHpZ19yLa0XTNEJ4fWLko4X56YRDrlPp7YvCdMo33ErmYF6TDQn6HyMDM7KcD+VQztXaXRCeAn9zTB5K3SP6DD+uj5/+w84joIiNMjdScCfgGT4HI6cmr1km97VBs010WAmWKSRjWkSHRXApb/nJmGDlbeMjYvrp0ars6+TCKfkPVB+qhBJYI5CY/+udtWMAGkHw8SU1anQOjsKF1neZkHbvhy6hcQVq9bMIw==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 72ee6da1-fffb-4096-d52f-08d87efa6190
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 06:41:52.0643
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9HCiDOO3GWluzI5ojzUlRqnV6TTGMMSpylOkB8hfB7kvtEZLWIu9wNXRYGTk5LMy0wb0oSFGFq2D1tiboVirAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB3934
X-BESS-ID: 1604299312-893008-31468-575878-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.55.100
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227908 [from 
        cloudscan21-164.us-east-2b.ess.aws.cudaops.com]
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
index fa2baca8c726..701ea18f811d 100644
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

