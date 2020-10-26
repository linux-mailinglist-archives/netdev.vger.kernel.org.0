Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8FC32986AD
	for <lists+netdev@lfdr.de>; Mon, 26 Oct 2020 07:00:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770126AbgJZF6r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 01:58:47 -0400
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:34602 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1770119AbgJZF6r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 01:58:47 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105]) by mx5.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 26 Oct 2020 05:58:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=URkEKEHTWqCMLq3f49sUv9Z1JfzySo73KbhDJc9UCWSfGfygWNBBTf1C3ton3wAnnS2dbpaNQXAHkzqdsJgV+GJT2MqiCnj+Pbi24lj6WkOQZpMjx76cY6MZEx/AXlsPnqFZF+ud/vM40xNj0cwfgYRs5kUto4hsxTI1iPgOtu332sk3lv8BXi1oLcVrdqR62tN3pZonLSnZthH5zUYwodrSjCMn0NfT35s4eH1TzyuS2Pj5f5nbDWE9+qyLAmx72TLKu9RNyx7jSGSjMgZPWnQyk8jr4LHDVgkUR1sTYz9ELYiyRuigZGxUtUR/TdBKFCxS05bx5BYBnM9ynz5DIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoQsKjQyTS0CZwmTjJM/6mrLSGowSeSrvYHtsgUV+WY=;
 b=khQmQRk6PTUslCQCkVFKpm4xs4XdEzMe6xT5sYAPHdbKEN3JtNJ8X19mKlQ9uh8oMSYGBi48LhWI2fgkIRZkIsIDJcs/x8ATDMa3t0CymMXz2bclbrxWSmFUfFW2RYxu+D6IpOX33xdwdpgiPBJ/xOXZtuSvF0QwpqTjw0zC00BbHEyHnm67T57nRcnSgea/8i/wtSR+OxCxOHkd9/IcV2reHaeZhWL3LNd40WjVLI+nFeTWAoKKWPq+x05cPXBU4dixpfEx88zhOupH+6B53HUwiL/gTU4RoyJHNAtpgwPvLgWg6g/+oZ0FxpUJf1bo9QwZW0G5iBBUohkvK7bg9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WoQsKjQyTS0CZwmTjJM/6mrLSGowSeSrvYHtsgUV+WY=;
 b=CbaTyJ0NVkl8noaiOaf3h6abKMaXbyHk6OT/tzlIG6oTLD2MFK5zGylOSl+x37gY2NMmAJypISXwXqyBl+pMWZKB1fGuKduEXi/7dUYW2Igm8aU1stebmjNjLqQu4UjdFKwNVc098JpYsgg0R/WLx7WZzafa005Fu0ptvMedlH0=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4253.namprd10.prod.outlook.com (2603:10b6:208:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3477.21; Mon, 26 Oct
 2020 05:58:38 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3477.028; Mon, 26 Oct 2020
 05:58:38 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     andrew@lunn.ch
Cc:     davem@davemloft.net, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH v4 2/3] Add phy interface for 5GBASER mode
Date:   Mon, 26 Oct 2020 15:58:11 +1000
Message-Id: <156717e3151d58bd51aef7b0e491ae5c63c07938.1603690202.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1603690201.git.pavana.sharma@digi.com>
References: <cover.1603690201.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [58.84.104.89]
X-ClientProxiedBy: SY3PR01CA0114.ausprd01.prod.outlook.com
 (2603:10c6:0:1a::23) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (58.84.104.89) by SY3PR01CA0114.ausprd01.prod.outlook.com (2603:10c6:0:1a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 26 Oct 2020 05:58:35 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b6be3807-1a8d-4b5a-fbe7-08d879742ed1
X-MS-TrafficTypeDiagnostic: MN2PR10MB4253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4253B2AA7B58A9CCDA76218495190@MN2PR10MB4253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FnF3zAh2tr2R6jN8d+SogzGGoNWpLGu1R6y7X0odcHDA6Nbhd9cHspPZwm2uj3RjHwn1P1JuaEJ95TqAvoNfVPZRID4MVYbJMSwjtdrqx5Oy3rdEoTRi/03kAfrGWomxbCPvJ2VvhYuwarHqtqTTXz+nb2TI6Q2kZ3/WxfGS+ohwJzTN8qiIWJnLGF46mUWbnbQ5Aqdr6SQ6XYa1dtgPh1Nl0t857fcoIQQNcQx0FJ7opjcPwTsaKF9GS2oFNRNrh96HAk78rUzeafDT1LZwBHs7ycvcVhd2KWkBR/w4S7j77/Q8wFATpmyIuJBNyiqe87+0tHpDkPZiTwBn/7r4fpM+5aPBaUjcJnqJ6e2KXb92Jvk+Pvz7J7u3CLjupCAb
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(39840400004)(396003)(366004)(4326008)(16526019)(66476007)(2616005)(86362001)(26005)(36756003)(956004)(52116002)(316002)(6512007)(69590400008)(2906002)(8936002)(186003)(6506007)(478600001)(4744005)(44832011)(5660300002)(8676002)(66556008)(6916009)(6486002)(66946007)(6666004);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: AZScTecvPIQTdT+59VuvibgBuEtYk00uc/k8EXKCMzSFdq6Pv837iV4SIS74EKIeJSgsAPX8ygNePIDyHtyfbcO9UJZ+sIeMh+iYBqKp24MAH3XBjs8YH0pzkNIcjrC2yZo19kCbgBC36uv/ytDkCcDQNF+Ktf030c6EbTbxDZ7c8onzE1dutFCvX/0Gz9iz0PB34zv7zfGB7e9XZusgJX+4D3nkV6t1BPZsBokZvipL+HNEyPVis4oCjntYcO9XZ0nNfpVSoHwujF6pEzwYMP9gmFh/2iApQO+edLrGjkeDg9sJPZgBBwmXJCGxVeMgrUepigH25vUVucsua128FQ1cEj4ujYz6PAwFZ+Hu+c+RfJCQ5ph3V7E9wlLGRM/DrG5RpExcMY5qjkpEvnk7hV2krUAm1HbUeGgiKcgGGkTHe3Dzm1tcJp55i44UHhW8byUmr+Hz0hvAiexBM8uF+V2uaNrzpQHm1pOyFNQQ68cfdj+Iuq2/+jzvxKTR1DpjVukdEuLO4oAold4EU79Zxz4qcszVqKjBacfWeh1pFNICYBPS+aYZ1R4A+N+Zj4N3UCjuPGqS/4PWrQRmljRFfcGLUJJENhEh0BFgXaMO0ci/KP2fzwYBsUlzid0LorYCChYdmZAfmAxZyybU5KX0yA==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b6be3807-1a8d-4b5a-fbe7-08d879742ed1
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Oct 2020 05:58:38.5389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: zE5nx6y4UKXUguZ/IqX+rVnttGs6KLmEPz++u28JlM8DGLeqROBMXsOa/FPIFbxWaAVEOjZvIG1pVnSUaVMy0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4253
X-BESS-ID: 1603691919-893008-20244-325328-1
X-BESS-VER: 2019.1_20201021.2259
X-BESS-Apparent-Source-IP: 104.47.70.105
X-BESS-Outbound-Spam-Score: 1.20
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227798 [from 
        cloudscan8-55.us-east-2a.ess.aws.cudaops.com]
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

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea..9de7c57cfd38 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -107,6 +107,7 @@ typedef enum {
 	PHY_INTERFACE_MODE_2500BASEX,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
+	PHY_INTERFACE_MODE_5GBASER,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
 	PHY_INTERFACE_MODE_10GBASER,
 	PHY_INTERFACE_MODE_USXGMII,
@@ -187,6 +188,8 @@ static inline const char *phy_modes(phy_interface_t interface)
 		return "rxaui";
 	case PHY_INTERFACE_MODE_XAUI:
 		return "xaui";
+	case PHY_INTERFACE_MODE_5GBASER:
+		return "5gbase-r";
 	case PHY_INTERFACE_MODE_10GBASER:
 		return "10gbase-r";
 	case PHY_INTERFACE_MODE_USXGMII:
-- 
2.17.1

