Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFFC6E7C53
	for <lists+netdev@lfdr.de>; Wed, 19 Apr 2023 16:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbjDSOW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 10:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232601AbjDSOWK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 10:22:10 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2074.outbound.protection.outlook.com [40.107.94.74])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A02310E4
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 07:22:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hTfMKgSEYQkIct7VaYSJ158FDjYxIwun7GsMk//J2bQqJEeBv/wD+vPrLsGOUeshwxr2jDcYefg61uXqxhz+bJGJQxC2ihZuMMoItc2Tn6vt84b2GIKIDW+jeqzwIRyJyaZZdlm2chkMACel1YXsYMxdPg3mZIA+7a6UCKdDyTmgHdVPtNs3NHl4qSHv28o1o5V/shQtrMR0zWjejw3gJBnxmZz0VS04H8oyUCTuJruFezbKKe3yyr6LbupRZTBaGfLd5knTnkYNt830Y+h4eOJE/aIx0nAmspoo1IL8T7K12AKqNtwaun+7EwHo7eqBwkw81csGWzeKSdUvvYkNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=83+GWXbdaZMWc/+1wFHQk8OcLD1ewmDI/zCIYqyZNUY=;
 b=CeaJuAHojPXHvB7Fbv/E4KGkwMwPlHCy1klLf1yTdwAC0c81gbH4D4v3Wu8Nz09gtrIUoLodTaUup8B5TBcBLc9tqfrL+k5QUcQjMc/u2vw1Uj9iXmUVcoY8MgE9QvK+nVe7qPPC8x+Tv8r0s74TwUd0cXGYO06LcLvLk0ORAWgflqsWd5r3JeE7EYp/h4vj2puVEFq2tr5YbaqydLW6VVa+IuuxbpcCOXUDoGhuxzDBYM+63p5QK6PZN5xjCLcIvT2/S0RYC+cri+Ppo22KgAH6zH1RMF7atdVwN13SiSVl3KW+j8+8fB7eiZQi7UPovwHLhzhHSIWF1njL3qaKWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.117.161) smtp.rcpttodomain=davemloft.net smtp.mailfrom=nvidia.com;
 dmarc=pass (p=reject sp=reject pct=100) action=none header.from=nvidia.com;
 dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83+GWXbdaZMWc/+1wFHQk8OcLD1ewmDI/zCIYqyZNUY=;
 b=k+iXR+2ZhpymzQWDD6aIgRYro+eAHqCckFpFfZ+SYTCQ4fZmJ3D7Zb6mNV2uhuPzCEpkZA11Yizd9YJmh0ecrhtweMd7MOO5cyKIXdOuwkr/9h6nodgEshpil6ZI57atsCgbI6xs4/DJaLXlI5lkPpygRQp5P+VzKfSFd64GtSyq5bpG06Tt/haT45l5z8TzjQL0j2b/VLcBltFGsj4JTrp2Xjk2Icw74ptWRaZsRU3AducR7tQpf/1tk8tywGaMGFOVkLerS4MYjZeHJMucJW+pOvccbrGMpIYvICAdyLU8YDDkcTuOp5l3z+z4yHywhS94RX4FDonC9DHD15Zzcg==
Received: from BN0PR04CA0159.namprd04.prod.outlook.com (2603:10b6:408:eb::14)
 by CY8PR12MB7099.namprd12.prod.outlook.com (2603:10b6:930:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.20; Wed, 19 Apr
 2023 14:22:06 +0000
Received: from BN8NAM11FT089.eop-nam11.prod.protection.outlook.com
 (2603:10b6:408:eb:cafe::b7) by BN0PR04CA0159.outlook.office365.com
 (2603:10b6:408:eb::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.22 via Frontend
 Transport; Wed, 19 Apr 2023 14:22:05 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.117.161)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.117.161 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.117.161; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.117.161) by
 BN8NAM11FT089.mail.protection.outlook.com (10.13.176.105) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6319.23 via Frontend Transport; Wed, 19 Apr 2023 14:22:05 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by mail.nvidia.com
 (10.129.200.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.5; Wed, 19 Apr 2023
 07:21:50 -0700
Received: from rnnvmail204.nvidia.com (10.129.68.6) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.37; Wed, 19 Apr
 2023 07:21:50 -0700
Received: from vdi.nvidia.com (10.127.8.9) by mail.nvidia.com (10.129.68.6)
 with Microsoft SMTP Server id 15.2.986.37 via Frontend Transport; Wed, 19 Apr
 2023 07:21:48 -0700
From:   Emeel Hakim <ehakim@nvidia.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, <leon@kernel.org>,
        Emeel Hakim <ehakim@nvidia.com>
Subject: [PATCH net-next v7 5/5] macsec: Don't rely solely on the dst MAC address to identify destination MACsec device
Date:   Wed, 19 Apr 2023 17:21:26 +0300
Message-ID: <20230419142126.9788-6-ehakim@nvidia.com>
X-Mailer: git-send-email 2.21.3
In-Reply-To: <20230419142126.9788-1-ehakim@nvidia.com>
References: <20230419142126.9788-1-ehakim@nvidia.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8NAM11FT089:EE_|CY8PR12MB7099:EE_
X-MS-Office365-Filtering-Correlation-Id: fa0a9f25-a11c-4c5d-08a6-08db40e173a5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: EpUpw5eE7Mo68s0CsBNCnMPV1H16KLudX3P4neHvvynBGO2YQRIqVLh4eVlvwjFF4tbx7xktXJpiJWusK01wDsAMUnK5fWigfNGP31GBQQIpWugitDDSx3GKdFbDckl1FTJZmivW7l8n4mVj9X3KhLC2Na7NNsZofgANMuoKJvYqHtPNS4q6CxnbE4Q0qicNYz7TrsPgopuDHYz3c0bGDpxrIWHKMwX7b9GD3hvAhPvz/K9ku5QHZz/6qJq/N4o9U+AbjZy9ucskvY6mA8V2JiIi5qcCcikBtNY1nt4HCVWEXrLcKh2rGyAyyaJlh/M96UDmmv+BWsvRqtqsmNneU2ORq9ZWUeUb9jGwV20FPUkK7CvKZByjBMJD4gCAqv+5xxv6M0dggtG/+b+8qPTd265yU3SRt2tyA8zCPq+OU5oFBjJoI/M5XZD68hdkio0WLrACd0BXGyoaLOUyDoE+7KdAuXU6KUGB6NaHqurNM6RkUF0LrYpzXVwc1HuwETi+TR76K0LeWmtx4kMIPzhxjiTOwrfxNiEHNX21T17dLiXWjpmcDxDO5THaK/MjC7vI4VE/f3D0cI8wJyiiXgcFIItDJNYT/3lMPfDHaMYHHRGbizuGXWGc9u0fguPNGemQEUuSp42/KVR4FYm8uozOjts8eSHCmlAn2LKyq4aXLIgMehx1a9ztvuYCyBMtFnBhQ4LlKaZY4k7RzyISRNhMMw3BmXJaMak0Zeo0I2jW4XtWaMN6IPLa+rRuCb30Yu8mSC36lusTKKi3XXfcskSdWn6cGEnpakaQyj/PJiXsPmU=
X-Forefront-Antispam-Report: CIP:216.228.117.161;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc6edge2.nvidia.com;CAT:NONE;SFS:(13230028)(4636009)(136003)(346002)(39860400002)(396003)(376002)(451199021)(36840700001)(46966006)(40470700004)(40480700001)(40460700003)(316002)(4326008)(70206006)(70586007)(478600001)(41300700001)(110136005)(54906003)(82740400003)(8676002)(8936002)(5660300002)(356005)(7636003)(186003)(47076005)(36860700001)(336012)(426003)(83380400001)(2616005)(7696005)(34070700002)(6666004)(1076003)(107886003)(26005)(86362001)(82310400005)(36756003)(2906002);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Apr 2023 14:22:05.3040
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: fa0a9f25-a11c-4c5d-08a6-08db40e173a5
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.117.161];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: BN8NAM11FT089.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7099
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Offloading device drivers will mark offloaded MACsec SKBs with the
corresponding SCI in the skb_metadata_dst so the macsec rx handler will
know to which interface to divert those skbs, in case of a marked skb
and a mismatch on the dst MAC address, divert the skb to the macsec
net_device where the macsec rx_handler will be called to consider cases
where relying solely on the dst MAC address is insufficient.

One such instance is when using MACsec with a VLAN as an inner
header, where the packet structure is ETHERNET | SECTAG | VLAN.
In such a scenario, the dst MAC address in the ethernet header
will correspond to the VLAN MAC address, resulting in a mismatch.

Signed-off-by: Emeel Hakim <ehakim@nvidia.com>
---
 drivers/net/macsec.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 25616247d7a5..3427993f94f7 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1021,8 +1021,12 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
-			if (md_dst && md_dst->type == METADATA_MACSEC &&
-			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
+			struct macsec_rx_sc *rx_sc = NULL;
+
+			if (md_dst && md_dst->type == METADATA_MACSEC)
+				rx_sc = find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci);
+
+			if (md_dst && md_dst->type == METADATA_MACSEC && !rx_sc)
 				continue;
 
 			if (ether_addr_equal_64bits(hdr->h_dest,
@@ -1047,7 +1051,13 @@ static enum rx_handler_result handle_not_macsec(struct sk_buff *skb)
 					nskb->pkt_type = PACKET_MULTICAST;
 
 				__netif_rx(nskb);
+			} else if (rx_sc || ndev->flags & IFF_PROMISC) {
+				skb->dev = ndev;
+				skb->pkt_type = PACKET_HOST;
+				ret = RX_HANDLER_ANOTHER;
+				goto out;
 			}
+
 			continue;
 		}
 
-- 
2.21.3

