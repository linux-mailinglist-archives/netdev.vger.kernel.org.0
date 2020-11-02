Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3512A24DC
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 07:44:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727992AbgKBGm4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 01:42:56 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:42536 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726684AbgKBGm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 01:42:56 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2053.outbound.protection.outlook.com [104.47.36.53]) by mx3.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 02 Nov 2020 06:42:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zb87ePVlIpRWGy1nmh64yytDeHEOrYR3rnT64TReTaACAdkwwrnmKwZFlmGYs4iMHg2lXTMw09hTvDGUcTcQXGsCD4IAJaEFNqSqeRSPYuc0bg6Paqo5lbLrygplvtx9YVoVq9/KRtKUV9ayvCglQeiDNUCAHgICT7okxkxFG3NrBLxmP6G3WvTqG0KsGdy/LdbnAsM4EwToZlmcH1qpSkYl7Yd5GFENuXA8nZW5U/7fwZAl/+nYRzrMWUxjmfWpInEtp8GSVKc1chVRHPRRXt96zx4vZHBU2QEWp3s/+p0QUoWV52uLrXqpn8CUAmW+Su/x760+K+ZuJP3Y7fjMUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUChzmfS6xQYjgYddkY6kdZu/v6TNfxYEJq48gUQhAY=;
 b=AUOi0uAC2yxLs/lF40qP5iYIWCK9X1jNwCenPGseAHsKUX02oD1S+GHywg5XqNkT707haQCTv/z/ULX7HgI+Xgz/ChcHhrUrvBpgRXT0Qai731u/UWDaev4aq2YodXGTpRYuIE5Gs/iDglaCehA99PkuFRkot9IWZ8p7LdifcYqZTyjRtKVaaVz6e72FhK8bXqDmUB9rOdTsKxOVmlVH3ZiwHU0wCcW5cgrb1WwXCVPQ/mv4jC/zbEVSYjOk9jChjZHyZPah/gbd6wqN5pMhT9Lq19ivJbT8on1jlnvfkgDnL5/Qzoz1FSFIFBRSjjoQ0JLHKflHyCgm9LJc/RFxYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUChzmfS6xQYjgYddkY6kdZu/v6TNfxYEJq48gUQhAY=;
 b=Fs0/5HuqITv+9hpKswssmYzVj2LEuQW1MPs1gqGzW0XpC9cIfIaQjTw7TC35aWtNtMapmf1tbxIZ5IyZBHZJMoBdV9q89uuzz8lugp54BV8KvfLlw+x5cA7rUwFvBUGCnWHWxpV+CaWq96T+csQwh9HR7dys/EPZLZjQr2SW5ZE=
Authentication-Results: nic.cz; dkim=none (message not signed)
 header.d=none;nic.cz; dmarc=none action=none header.from=digi.com;
Received: from MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21)
 by MN2PR10MB4253.namprd10.prod.outlook.com (2603:10b6:208:1d6::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.27; Mon, 2 Nov
 2020 06:42:38 +0000
Received: from MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32]) by MN2PR10MB4174.namprd10.prod.outlook.com
 ([fe80::b505:75ae:58c9:eb32%8]) with mapi id 15.20.3499.030; Mon, 2 Nov 2020
 06:42:38 +0000
From:   Pavana Sharma <pavana.sharma@digi.com>
To:     marek.behun@nic.cz
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pavana.sharma@digi.com, vivien.didelot@gmail.com
Subject: [PATCH v7 2/4] net: phy: Add 5GBASER interface mode
Date:   Mon,  2 Nov 2020 16:42:06 +1000
Message-Id: <ee2ecb0560b9e7a2a567b69b5de40f39344c8ffe.1604298276.git.pavana.sharma@digi.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <cover.1604298276.git.pavana.sharma@digi.com>
References: <cover.1604298276.git.pavana.sharma@digi.com>
Content-Type: text/plain
X-Originating-IP: [210.185.118.55]
X-ClientProxiedBy: SYXPR01CA0111.ausprd01.prod.outlook.com
 (2603:10c6:0:2d::20) To MN2PR10MB4174.namprd10.prod.outlook.com
 (2603:10b6:208:1dd::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from localhost.localdomain (210.185.118.55) by SYXPR01CA0111.ausprd01.prod.outlook.com (2603:10c6:0:2d::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3499.18 via Frontend Transport; Mon, 2 Nov 2020 06:42:34 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 57ac45df-2dd5-4eb4-9ffa-08d87efa7d2a
X-MS-TrafficTypeDiagnostic: MN2PR10MB4253:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR10MB4253E76F865CF02913D3F40895100@MN2PR10MB4253.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:296;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hO1fVC9dAfmnlXAGfu1UFQ45znNfek8ZfO2ZgvIEI+CimYZm853eQskKec1sjr11wRN8Z4bbVtvUv823+p+wLloPzY0ldKUksY7VfsgeStK9IKxvofF0dkbxro5sLqOrMGeZBqp6Y7XPs3jM9T6sssFRqac7ihP+DCteDuFYfU6UPZjR+XAbMatNgjeOBR4jcZhDpjHSBT/O5i4ot3ENesKvIHugGmmm9RoGQj6dHcUh5oyjqbSTyORq53eITMJlaZUyCoNHMpGxQsYfqICu6q00+VeNKkDG9zmetePOet+R5DiW3dsjLwX1kV0yHVNw/kwLEPLE+Dg2oag8bvY1QRVwUB5mdz737o7ydh982VFoLOVMGiMwxncwhw5Pj9NW
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR10MB4174.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39840400004)(366004)(136003)(346002)(376002)(6512007)(52116002)(8676002)(956004)(8936002)(69590400008)(2616005)(6666004)(6486002)(316002)(186003)(16526019)(66476007)(26005)(478600001)(66946007)(66556008)(2906002)(4326008)(6506007)(44832011)(5660300002)(36756003)(6916009)(4744005)(86362001);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: u1iYSgZKu5wJoQkjwvRu6VRawE2kmv5TqwG94ZnbgZ659NKe+a1kof24ZiaMdhTjF99KHgR4+PmEUzISHqJMk0Il44Npo7DTF5kyGWDsxJbZR5RZUP35D5cnp6TZaFOO92usM5NVpGfG79XrT20+gruAw6pQIgu+4fR6tk+UuUkk+JPjpawPSdzL68F41LfdQHeiXJyTuoa8FsChB2U6ERpoL5wDf80jUaYSdhAXiHfaTiBb2UWgCMJLTsTt2MRoH6t1cFOAAnpi8R9CBTgnBJJp0VtYsPdU2yZP9F8deox5hIomra0YkjtyrQMK0z+tLN8iW3Ddcak8sCG0AXTZAnLieCP2Q3a08NgbdesO8YNMy/2VuYUwApaTGxINO1fWZTNZAoTVKa/fjbsV3IQOOwuK/8hqd6yPByTjlOj3cvX9O1IIMHJH85+qZb5IyywhQ8tUcJ0+U3wlz7Hpfkgv5vj6/SZBM1c3TLN15xadD8H1IBjcWn/yThSwOnmQqHp+9tzWFrZ7XbPSUq431g4WiKxdrKdetqlgGHnt39ANosMV8jCSDB9QniNtDiqNPYZeSntxJFrh0g+DsopRxEVSXluU7P4uTEL0CnCQ3F/y/KZXVDCttJpn4BZDFw37gzmR1UmarIiDe1FTp0bYdfDdog==
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 57ac45df-2dd5-4eb4-9ffa-08d87efa7d2a
X-MS-Exchange-CrossTenant-AuthSource: MN2PR10MB4174.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Nov 2020 06:42:38.3846
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7aUBFoaf1AKKKgYGOwtrHRQYDs7WS/OLZsrbU+/FvpYHaXxK8vrEQTVJgVy86fJttbTyZU2EABz3fjHnrmIPBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4253
X-BESS-ID: 1604299360-893004-1564-166034-1
X-BESS-VER: 2019.1_20201026.1928
X-BESS-Apparent-Source-IP: 104.47.36.53
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.227908 [from 
        cloudscan8-29.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 MSGID_FROM_MTA_HEADER  META: Message-Id was added by a relay 
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=MSGID_FROM_MTA_HEADER, BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add 5GBASE-R phy interface mode

Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>
---
 include/linux/phy.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/include/linux/phy.h b/include/linux/phy.h
index 3a09d2bf69ea..977b94a44e15 100644
--- a/include/linux/phy.h
+++ b/include/linux/phy.h
@@ -105,6 +105,8 @@ typedef enum {
 	PHY_INTERFACE_MODE_TRGMII,
 	PHY_INTERFACE_MODE_1000BASEX,
 	PHY_INTERFACE_MODE_2500BASEX,
+	/* 5GBASE-R mode */
+	PHY_INTERFACE_MODE_5GBASER,
 	PHY_INTERFACE_MODE_RXAUI,
 	PHY_INTERFACE_MODE_XAUI,
 	/* 10GBASE-R, XFI, SFI - single lane 10G Serdes */
@@ -183,6 +185,8 @@ static inline const char *phy_modes(phy_interface_t interface)
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

