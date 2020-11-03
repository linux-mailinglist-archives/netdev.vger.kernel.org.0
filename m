Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2FD2A3F46
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 09:50:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727742AbgKCIuG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 03:50:06 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:55970 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725968AbgKCIuG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 03:50:06 -0500
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (mail-bn3nam04lp2057.outbound.protection.outlook.com [104.47.46.57]) by mx4.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Tue, 03 Nov 2020 08:49:56 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T3PiVWl0YfxpDtNLOTqaQlOZzu4L+ps8mHNZC+leE7+RaLUsq8IYL3Ql5m5tXqJR0BdQIZcPqp0pcAqWt9vXslDPkVWPjBACqJLpTtB4+tm+yIzc9OMb3ir8pu0+xnIF3i4i542NC7DhNNxxoN9UTglthPZUiK24pLjqx3RV8GGWWxflmAduffL1HczJg3BJVi/eNQQrM6Ul76/8ppk0dLTAn94L9Lp9FXZNxJQnkeXseN2k3CqPj0hQjVWWROFH0N7POQGcNFshnoRItxZjq29szoos2lNMAW6dqfonNSPdPEAluZBLF76sPbXn66STHU8DYCGbRoCmQD7LqwCyIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzhu3HKrBF9WL7Cqr05yTjxR+KiotXQXs5GjHw4rN/g=;
 b=S8TCUKflaxL7ISTj7nrYBfqSTyCNgFxvQBaCbrreXmioY5PF0c/nrqGPYdFY1FdgrdilH94LFTTTV0bhBuVjgYSgy2k6EKOVoqVwMToGbIYQb8KyUlonimBEC4Sd66RZykhwq+qi/HjYbx/ChL5NOO9ZvwOkfZ3Ta/j7jRU+YckITnWj6TpFNLACa6XwkeJvVDiprq86iMhz6BIykBYaT2nnW8n1HoqTnXpXIVQm9/wkbNuvUYfAXlXoqJhL99if6hB6oBQ4h5wyIclnPzFwIqTBdpeo2s5/GrSDNJspRXZjkZkHsPchf1edrFMqlKTsvvWj6Z3UO+YXXJ1k84V+dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wzhu3HKrBF9WL7Cqr05yTjxR+KiotXQXs5GjHw4rN/g=;
 b=dnDTEQ8CKxsJ9xOSfzA8ZARCwunZ1M6F5k/93MtPp9k3EF0QfLc2HGEhL2oBl1YAxe0woxPymN3jk9LNc+cPQpaAtMR76MbQdxncuypmpzaZwKaTg3bdUQuI/+7+ntqBahJS4ezHRMmVYKi86o/vbRJLnu9hI5MIrE1VxItcT14=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by BL0PR10MB2883.namprd10.prod.outlook.com (2603:10b6:208:73::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.29; Tue, 3 Nov
 2020 08:49:55 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3499.030; Tue, 3 Nov 2020
 08:49:55 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     ashkan.boldaji@digi.com, davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, pavana.sharma@digi.com,
        vivien.didelot@gmail.com
Subject: [PATCH v8 2/4] net: phy: Add 5GBASER interface mode
Date:   Tue,  3 Nov 2020 18:49:34 +1000
Message-Id: <58dfbcf0ef968362eef44be8d03a4f3597a36be2.1604388359.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1604388359.git.pavana.sharma@digi.com>
References: <cover.1604388359.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [210.185.118.55]
X-ClientProxiedBy: SYCPR01CA0022.ausprd01.prod.outlook.com
 (2603:10c6:10:31::34) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (210.185.118.55) by SYCPR01CA0022.ausprd01.prod.outlook.com (2603:10c6:10:31::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Tue, 3 Nov 2020 08:49:51 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0ff55143-1b57-46f7-6f59-08d87fd56f8f
X-MS-TrafficTypeDiagnostic: BL0PR10MB2883:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BL0PR10MB288348EA17C1FA598886FAA095110@BL0PR10MB2883.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SuZyaJ/R4k+nUCEIcK2e6e+Ud1eyIJJT8KBXaDyLq6mhKVvCqUCUtY6a+I1hU6dX2a0Mr5KrexcnOvW5WzL+gh//2cPLgWUbF+nfZRiYoSDxUMxG1bu5nr0xl/P+1HND/Sno6axOgOmQ7EDnfryfVC9FIu7oP5b5bu3LCmC0r9+Yv8hm4/qHOcy0bcfiKCwVwaOJ3m76UtbFYonwLbaOCnMgQQTfWsW6QarVphh2h5rb4krvsn80iT8eN5YneCV5hmh2jGhdPs8unSJPLMd/UFZz7/9vsk3JUFjDvCBqUuy4Y99EAIj+eB0sMssSBeq8ttHHTCidkehfqlMkkekqM0YpkFSfg1bag6bGe7oAoPRJP1z+RtINS4ZuuEgihgTz
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(39850400004)(376002)(396003)(66556008)(4326008)(6486002)(8936002)(52116002)(69590400008)(36756003)(6512007)(86362001)(186003)(66946007)(66476007)(26005)(6666004)(316002)(16526019)(478600001)(6506007)(956004)(6916009)(2616005)(8676002)(5660300002)(2906002)(44832011);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: eRM0Swqzy8X6C+zz2EeFKG+t1y8/oQ/+dR1FkZuIN3w4DW5SufR+c1EDBFLlWJfJVnHxPkgxaaBrGjSb/l4tpitQHmfz7MTmzIBa1ubOUxwqUUQ1tDIBehMWP4WeJsWbHx2lhhQ79KREIGGTvAvBdNz33boIBtmf1lr5AHh69k7/cAcHs0Ug5cTe56asFD2HLaXXkqPr2K3cAixVyVob6MZ65DBSsFUc7gBS/T1RbJPvyQRiLio96NTHHr1rUjrqdscB1kubbWAY3mzdiylF2G6AWTOQKBsbHbi3XIh5/9VYwocrx/6VOP8NNtpu37cb3FbyYmtDnjLoMXPn0Zm/VXzeYP4XK9Mofnb3TQAOgd+rt3Q1WkmzpiBOzO5pvo+71Q7nF2QYMyGKUvldLFCL486E3c2nVryjfY3wLx+0pPuxrVkDUC0Ol9JsVedJxTEAbH080sXn/wFRO70lV92z32+pFAJ4Vkb5sZUK/9DDxcPsYc+taMypWMRpR9BGLYg7NMJBTMkiPvSxEkfwupqEzO8CkPMNPPRHgQ/jXYv0VSWRAL8g9dVU/wCOgSCXVOnxObS14QLi3tiFIyPt0z7feNt27NpAmvAXWp2mGx9wjl8gmrQp7pyrjCEI7b0Pea23/tqY2LSCPOxW5IQTp8PjYQ==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ff55143-1b57-46f7-6f59-08d87fd56f8f
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Nov 2020 08:49:55.4201
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0nur4SXqe6zTS9dFWYpR0wdl5khWeQf+nCkC4rYy2eJ25hJR0GYu+xyLx/U0b7PwNdo17bZYgLLWVVuE0EPYEA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR10MB2883
X-BESS-ID: 1604393396-893007-20360-58792-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.46.57
X-BESS-Outbound-Spam-Score: 1.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227933 [from 
        cloudscan14-57.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        1.20 SORTED_RECIPS          HEADER: Recipient list is sorted by address 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=1.20 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, SORTED_RECIPS, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index eb3cb1a98b45..71e280059ec5 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -106,6 +106,7 @@ extern const int phy_10gbit_features_array[1];
  * @PHY_INTERFACE_MODE_TRGMII: Turbo RGMII
  * @PHY_INTERFACE_MODE_1000BASEX: 1000 BaseX
  * @PHY_INTERFACE_MODE_2500BASEX: 2500 BaseX
+ * @PHY_INTERFACE_MODE_5GBASER: 5G BaseR
  * @PHY_INTERFACE_MODE_RXAUI: Reduced XAUI
  * @PHY_INTERFACE_MODE_XAUI: 10 Gigabit Attachment Unit Interface
  * @PHY_INTERFACE_MODE_10GBASER: 10G BaseR
@@ -137,6 +138,8 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	/* 5GBASE-R mode */
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -215,6 +218,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "1000base-x";
 	case PHY_INTERFACE_MODE_2500BASEX:
 		return "2500base-x";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_RXAUI:
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
-- 
2.17.1

