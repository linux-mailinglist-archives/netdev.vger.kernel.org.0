Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 456BD29E619
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 09:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728275AbgJ2IPB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 04:15:01 -0400
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:60610 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727124AbgJ2IO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Oct 2020 04:14:58 -0400
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (mail-dm6nam08lp2042.outbound.protection.outlook.com [104.47.73.42]) by mx2.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 29 Oct 2020 08:14:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lDx97F7hZrSi/dzUyqkO+OkIeeBdr1XBk6feEjqyTIS8KxXDNbmMwhkEYREmnnkYrEI1tjY4kCoJSqae0W+9vX0Iv5AQLzJvTQSKQ3WFiy9Hp/cPEGF6zIpzus8NGbZKbK/Ul8LTrcTe7MRVkDPn1Cde+/lza3Ypa8MXJhn8ru2s1x4f6QRsCHLMenqrs5WoeZJLHDs68M3nHogoDn0I8jbKPTo+pW3Was/qRX4LT3iSN5zSD/EvsO+HZQknNDd72V6BR0O4X8vxZNPVknBiSMeEgXrAzs+PsaCblYKwxWJy15s3MXvNk+omg1KHRlg1DErC0Hqa/LkC0h4HSsh6YQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVeJPFnY66ukP2RQoBED8DfZLVWxBlrS8N01PAgmsec=;
 b=EoGtBTEQ9lEt6ERZZHmDFAopqeRVJwYINODvaPSGO5JQ5PaBNLG6/HhM2WcaPf2/ZUS+y5/HFZE86Cvt4L5AMgt5KQatmv0gNyRjlPk0LPmF/o0NLLGE50nFaKTw4DBxKEuzhALwSmiemZq1neMDH7WXwk9MyDKZdn+f7ACWXLzdZkP8Pcb3x8uErJ+J07b+qYcpQseRV6qW9kqhyrDdujRfyJqDbPefFEsNhiJIYZ2eFq5dIVl4B9eEKagfxAm2I2OncbetY/oVIiZMtsLJEdeRrUo4gUHh/IVsQlI6n6xNS6VJsQ1L0A5FHjuCbYlCiC4JGnYVL3+l9g4aAxkkVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vVeJPFnY66ukP2RQoBED8DfZLVWxBlrS8N01PAgmsec=;
 b=ruLCFPTzJ3CxH9XBCl2APEwKyAxfq1n4vG+etG9jtTHtAqtUaDODBZJKelihNrm755WLuKC0mGuVeqnLpUS3ouK1w/hrN9K7dNRIUWL3ZJRKXB6kCNr8PNKSab1+4EYaoqecsaHRwp78SHuXrokjr2JcrBYNAdQz1TivMVUz5/s=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4189.namprd10.prod.outlook.com (2603:10b6:208:1de::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18; Thu, 29 Oct
 2020 05:41:53 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Thu, 29 Oct 2020
 05:41:53 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com,
        marek.behun@nic.cz, ashkan.boldaji@digi.com
Subject: [PATCH v6 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Date:   Thu, 29 Oct 2020 15:41:21 +1000
Message-Id: <a90452e4fe7c6064026edc8377debd456f54137d.1603944740.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1603944740.git.pavana.sharma@digi.com>
References: <cover.1603944740.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SYXPR01CA0102.ausprd01.prod.outlook.com
 (2603:10c6:0:2d::11) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SYXPR01CA0102.ausprd01.prod.outlook.com (2603:10c6:0:2d::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Thu, 29 Oct 2020 05:41:48 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3dd2d05f-2b62-4588-e41b-08d87bcd56be
X-MS-TrafficTypeDiagnostic: MN2PR10MB4189:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB418958B4A417A56DF7EFA53395140@MN2PR10MB4189.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vPmOb1JOZgGndLlnBwWIhIMQz0MwJp/gjDMbvUE6p7tA2p5jVupIdP/+d5lDKg53LpPLkVogmF2wyk3thFeS1noXFXY3kfbrX7wO4yuRFZoekYwIFs99AyDyM+GOd1OT0UhfN5LzuPAY6VJmWQbqnFU3KcW0DifsJ4EdqSEAGN6cw991nxxBeE6AcOFHEY5GBOsvJWerB7LMc0xM4U8cDxiR5BlU0m4+ROmwmLE38wm33hY3akwFlSa765/Fu/luKBdgnvw+cSSXFsHvrpBlkClE5jiwl4ZcgqhQuS3cU4emnGj1atB/582G+088prcQPF/8FjmC4eTvXgOOKIjNMoW1lxhRevaPpLVdYaoIdGN9hCF9UG2h7r+lhKEYzmxn
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39850400004)(136003)(376002)(366004)(396003)(2616005)(956004)(69590400008)(8936002)(66476007)(6666004)(16526019)(66946007)(316002)(186003)(2906002)(4744005)(44832011)(8676002)(6916009)(107886003)(6486002)(36756003)(26005)(66556008)(5660300002)(86362001)(6506007)(4326008)(6512007)(52116002)(478600001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: SGk8SFFz/aLjEni3LwXGhbmIapnGteG5XLO+xp5KNuPDHnZHLeeVB26mFtgHAzRvukUsRLL1ulBsybaFa460mk6JuPWPyK6OCZhON1L6EMCUOq3H3EEoCC6kjzC+EQGBcX0KQm8OsF6RL6gYi4b3vLP7mhF/Yl0zSxosj+Po+K/gbTwfT0tsTEningAUNqRsS51qsHyH9yf+T1LZ5e6YwlMwTENuAeBVp1kQQS5oGS8MSxzlbQ2U4luZG+tG9VgrFD36geUyU8TT70mCn9Me3M10TelgdPZvBGanOsHg/iL5dp+09fpdfHRRqjmTweN+nXhT9ipEFqnsrahWe5a1bB3gURyp0lfUOW/Vg8vLQr+ZEzDh8N0GfQY1fy1uIx9ywRGJdd7RkUug5Ubs4CxPe8+DD8rtqtU47GfrkoX9wixUh7hNDq5qpuZurXHTc4M7EDGZqzrBbxSuEheqx6qr+mgAK/CzNt1pMvNk4mfXFQfMQ7hsipy51PpYBkweyRqsHLann0QDiZlqRUYOLSbCvLfimvIEVpP250RESkyR677o7LdvUd78mHfkONUHgd1pds+FBYM/yLEheVsaiG8ISkpz/6xgyi4kJ2zusmi0UtW8VlOZ8zp0Byvb1CHTr+k4SJNnog7IyE8K4+10q3iTzQ==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dd2d05f-2b62-4588-e41b-08d87bcd56be
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Oct 2020 05:41:53.0571
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N3EbwhgmaV7eNEDiOMtDWPH46L6n1km4IqKCoNBwaniVv2k5LgsZo1pS6jLYGWNDuNnw6xaRA8Bj/Og4ie2ERg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4189
X-BESS-ID: 1603959296-893003-5193-246828-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.73.42
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227845 [from 
        cloudscan16-168.us-east-2b.ess.aws.cudaops.com]
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

