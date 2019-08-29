Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9092BA112E
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 07:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727733AbfH2Foi convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 29 Aug 2019 01:44:38 -0400
Received: from m4a0039g.houston.softwaregrp.com ([15.124.2.85]:37979 "EHLO
        m4a0039g.houston.softwaregrp.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725776AbfH2Foi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 01:44:38 -0400
Received: FROM m4a0039g.houston.softwaregrp.com (15.120.17.147) BY m4a0039g.houston.softwaregrp.com WITH ESMTP;
 Thu, 29 Aug 2019 05:42:36 +0000
Received: from M4W0334.microfocus.com (2002:f78:1192::f78:1192) by
 M4W0335.microfocus.com (2002:f78:1193::f78:1193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10; Thu, 29 Aug 2019 05:39:39 +0000
Received: from NAM03-CO1-obe.outbound.protection.outlook.com (15.124.8.11) by
 M4W0334.microfocus.com (15.120.17.146) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1591.10 via Frontend Transport; Thu, 29 Aug 2019 05:39:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CkkiOwVvIbbeqBFui/RlUSY+Kfz67HCLGXuLOUsLsdgR/xNpXdUVNsL3udC8twI03+yfOlZP4x/1BWFwMbHswOnIgVCnYuPM2Agp8uvd0HCkPhSDuNxSJT2OqPGweZNcsdmFMIFOujW+I+fZ5YjyFTn91ZJ1G19vzZ/aSG4h0LAJg2RaeYOCe6rPh5ro3QsK+E2vmJbL2PC+cbG6cMNyXT5/fRxkmWCw/aW2mBi+tdjFwfO+1wyjkvlbKJvDZO2updyDq+QlWU6bHuwtXkT/U9NImURN5UWAKIWZt8ofslFslmFbLCecvPbibUOw77OT9kBXY7PjRppcfzpq02Ny+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=py0K8cXHxLdrhbop1JQwjEpG81F0t0l8HH03/3q+Rsw=;
 b=Dwn2G2WH/4tPYIc5dNaVfCR3FpYkXIWS152lkmmDgGUbK4DP/cHo36fFFAclivkZQhfvlskU3FJr/ZHL5kSqpfVu/5tZ3gOzx4rBHsshKfjo4oAEhXmyUmI/6y+BjyPSgxZfDjBlSaQcj2H1XSjAu6W0ssWEgZ1AmmKp8Kxq85+L5oaQGe28CneZbYX8cRWlrEhMFII8naKSELUZUx/joQSiv1AUWVX5kGwC/eKbbaqoYk65EprJDDZj2FPa+NHchXhxWS/E7bou65QZ7i0cgROMYF3oF7e1LvWrIKeUBPHDaVReKb3gx/BU1FwyPKkMFcOFBY4qn2vveeWM3CjhGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Received: from BY5PR18MB3187.namprd18.prod.outlook.com (10.255.139.221) by
 BY5PR18MB3187.namprd18.prod.outlook.com (10.255.139.221) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Thu, 29 Aug 2019 05:39:28 +0000
Received: from BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac]) by BY5PR18MB3187.namprd18.prod.outlook.com
 ([fe80::103a:94a8:b58d:3eac%4]) with mapi id 15.20.2199.021; Thu, 29 Aug 2019
 05:39:28 +0000
From:   Firo Yang <firo.yang@suse.com>
To:     "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>,
        "alexander.h.duyck@linux.intel.com" 
        <alexander.h.duyck@linux.intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Firo Yang <firo.yang@suse.com>
Subject: [PATCH v4 1/1] ixgbe: sync the first fragment unconditionally
Thread-Topic: [PATCH v4 1/1] ixgbe: sync the first fragment unconditionally
Thread-Index: AQHVXiwgNp3Dtk3oZkGnHJ439UUA4A==
Date:   Thu, 29 Aug 2019 05:39:28 +0000
Message-ID: <20190829053837.17947-1-firo.yang@suse.com>
Accept-Language: en-US, en-GB, zh-CN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: SG2PR02CA0044.apcprd02.prod.outlook.com
 (2603:1096:3:18::32) To BY5PR18MB3187.namprd18.prod.outlook.com
 (2603:10b6:a03:196::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=firo.yang@suse.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.16.4
x-originating-ip: [45.122.156.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17965df8-551e-4374-7499-08d72c434261
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BY5PR18MB3187;
x-ms-traffictypediagnostic: BY5PR18MB3187:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB318775E853B997C3186E664188A20@BY5PR18MB3187.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 0144B30E41
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(136003)(396003)(346002)(366004)(39860400002)(376002)(189003)(199004)(6486002)(6436002)(81156014)(81166006)(8936002)(8676002)(305945005)(26005)(7736002)(14454004)(102836004)(66066001)(107886003)(54906003)(25786009)(386003)(478600001)(6506007)(4326008)(6116002)(3846002)(36756003)(256004)(186003)(2616005)(86362001)(476003)(110136005)(6512007)(52116002)(316002)(50226002)(66446008)(64756008)(66556008)(2501003)(66946007)(99286004)(1076003)(66476007)(2906002)(71200400001)(71190400001)(14444005)(5660300002)(53936002)(44832011)(486006);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR18MB3187;H:BY5PR18MB3187.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: suse.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: NP2MPmly5d050HaxvQQlX5WfPlW4l4rAbF5CaHrgfUi2Www3sCoDbs+blgtT2Mq+E6q50AZBIEzPh/bxUllj7LCJJy3qZSL7ug5e/3q1KUvmebXdCCExSKXKY/OXlwUFGxHOysgAvTUUp4JU+S+iQFFIB7rsJWFkKgJs6JT0r6kTQf1FhhIkWJA+txLgQVv9zubhcEhWnaxyHxa0oNF/R1YcUije+qHqnYarxavY5B35J8CoSEUdwM09sLIQL5k1/ZnIiwMqjnzxunumypOAmynOHY1DTszO6T4FH08n9pBEy3yDXCXZMnZe/cZ51eFRciMo+fmyHmC1jwPwZ9iw6q/Ym6I7OOpsbAC669XjnlnZRn2sU5G5Zr04gT0yAet5+GxCPwxKlNzGjzs9v2BDkqZVumCXhpkEbJHugu6rUz0=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 17965df8-551e-4374-7499-08d72c434261
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2019 05:39:28.7366
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 856b813c-16e5-49a5-85ec-6f081e13b527
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6yK9I/FblPwiMWx0INMrq4BvMcqJ0whgGpE5T53Aa0VtiSSqksC1Q441HkL0DBLWaKDb2EC2pejFNQZ4Jt6dsQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3187
X-OriginatorOrg: suse.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In Xen environment, if Xen-swiotlb is enabled, ixgbe driver
could possibly allocate a page, DMA memory buffer, for the first
fragment which is not suitable for Xen-swiotlb to do DMA operations.
Xen-swiotlb have to internally allocate another page for doing DMA
operations. This mechanism requires syncing the data from the internal
page to the page which ixgbe sends to upper network stack. However,
since commit f3213d932173 ("ixgbe: Update driver to make use of DMA
attributes in Rx path"), the unmap operation is performed with
DMA_ATTR_SKIP_CPU_SYNC. As a result, the sync is not performed.
Since the sync isn't performed, the upper network stack could receive
a incomplete network packet. By incomplete, it means the data from
skb->head to skb->end is invalid. So we have to copy the data from
the internal xen-swiotlb page to the page which ixgbe sends to
upper network stack through the sync operation.

More details from Alexander Duyck:
Specifically since we are mapping the frame with
DMA_ATTR_SKIP_CPU_SYNC we have to unmap with that as well. As a result
a sync is not performed on an unmap and must be done manually as we
skipped it for the first frag. As such we need to always sync before
possibly performing a page unmap operation.

Fixes: f3213d932173 ("ixgbe: Update driver to make use of DMA attributes in Rx path")
Reviewed-by: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Signed-off-by: Firo Yang <firo.yang@suse.com>
---
Change since v3:
 * Fixed "wrapped Fixes: tag", noted by Jakub Kicinski <jakub.kicinski@netronome.com>

Changes since v2:
 * Added details on the problem caused by skipping the sync.
 * Added more explanation from Alexander Duyck.

Changes since v1:
 * Imporved the patch description.
 * Added Reviewed-by: and Fixes: as suggested by Alexander Duyck.
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
index 7882148abb43..4e8d5890a227 100644
--- a/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
+++ b/drivers/net/ethernet/intel/ixgbe/ixgbe_main.c
@@ -1825,13 +1825,7 @@ static void ixgbe_pull_tail(struct ixgbe_ring *rx_ring,
 static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 				struct sk_buff *skb)
 {
-	/* if the page was released unmap it, else just sync our portion */
-	if (unlikely(IXGBE_CB(skb)->page_released)) {
-		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
-				     ixgbe_rx_pg_size(rx_ring),
-				     DMA_FROM_DEVICE,
-				     IXGBE_RX_DMA_ATTR);
-	} else if (ring_uses_build_skb(rx_ring)) {
+	if (ring_uses_build_skb(rx_ring)) {
 		unsigned long offset = (unsigned long)(skb->data) & ~PAGE_MASK;
 
 		dma_sync_single_range_for_cpu(rx_ring->dev,
@@ -1848,6 +1842,14 @@ static void ixgbe_dma_sync_frag(struct ixgbe_ring *rx_ring,
 					      skb_frag_size(frag),
 					      DMA_FROM_DEVICE);
 	}
+
+	/* If the page was released, just unmap it. */
+	if (unlikely(IXGBE_CB(skb)->page_released)) {
+		dma_unmap_page_attrs(rx_ring->dev, IXGBE_CB(skb)->dma,
+				     ixgbe_rx_pg_size(rx_ring),
+				     DMA_FROM_DEVICE,
+				     IXGBE_RX_DMA_ATTR);
+	}
 }
 
 /**
-- 
2.16.4

