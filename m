Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7452ED2BF7
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbfJJOBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:01:33 -0400
Received: from mail-eopbgr780080.outbound.protection.outlook.com ([40.107.78.80]:63120
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726116AbfJJOB1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:01:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FpE2nrMc2aC9Oo8huFh8Gp85/lqp+ZAU2VwQht4joUaMo7jD8NaebXQhh+DJfRqglF2b0Y+rlmUSb+hyOPhFR+3YzcKt5Jq1y3eg1nJ2E11LtWB7gKeB+EkUNXeJGcRLjnQEzJbo5kG2142LsPQ2amBFODKyLyS9P50xyWmJAlGM4d5FmZAhq1e/WxT5yEyJfNOCbTikQQRP4NDo7AHfPFqE2MNi2qhj0WahcItveuc75K8bN0CHY0aySB/d5tD9g9+5vhYPXbN30wjExUR2OGnnKC25GHSNDewnGI2/jSJBWV4qRapChpwTytmOjphD4YV29s8U6grFO1128LnELA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LL9KZ4iwo4wqxi9uA0qslf/7N1J6UZdNb6DIi49UsgY=;
 b=NuAZPEWzLwIouYIaI3Y1e/FW8IaZVITpQH9UEaiOcAddjuBdFp22wmXV6AxvI77cBrNEMDIT6uViHagbd9Ai9CpSiCckZ0KoypudCzaJtOZYBvtTH0ZcLraWcL1x/GMiNd0rHIZqIxR6QJplNKzYFdfVMp2YrY8i62XuXiCKV+w4mvV7vdqy6sLmoApxm1feWFYxVhcSdv4Kf6Bb5mCYj9hORCxnfTGTgF7QDjFlPaO19OyYkqM+GljGhEPymhxqwSNht6OavmX9g75eJggUk7lTT/TCctskZ2SH+qNbLFw6af1U2KdT/w7/p1qpPtjb5veziv/PN8U5xelC9w5fhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LL9KZ4iwo4wqxi9uA0qslf/7N1J6UZdNb6DIi49UsgY=;
 b=s/hSQelr9aETvlAPn/O3LUsuQYC+VQPBeq7QyHYJp32H0/GaRs2MmPvykysqZ+t0H6/JP0QWpKhSX9ryyxbnnp1jp1yQ80Rje7mfbdpw+o1PoN3OWUAiTNkqNQ6YQdbZ/g7hm2W6shZSsWmOTXGuvwuUFEipC5FNltItA6V3Cdo=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3779.namprd11.prod.outlook.com (20.178.220.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 14:01:23 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 14:01:23 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 2/4] net: aquantia: when cleaning hw cache it should be
 toggled
Thread-Topic: [PATCH net 2/4] net: aquantia: when cleaning hw cache it should
 be toggled
Thread-Index: AQHVf3MzmcPhxCrvJ0aMSte0lVcgFQ==
Date:   Thu, 10 Oct 2019 14:01:23 +0000
Message-ID: <da3c2177c722c06e00b599b8bc69144beaefb973.1570708006.git.igor.russkikh@aquantia.com>
References: <cover.1570708006.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570708006.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0003.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::15)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d73d3cc7-6485-4254-66e6-08d74d8a5589
x-ms-traffictypediagnostic: BN8PR11MB3779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB377904D0A3093CCA56C95CDA98940@BN8PR11MB3779.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39850400004)(396003)(346002)(376002)(189003)(199004)(66556008)(26005)(446003)(64756008)(476003)(6916009)(8676002)(14454004)(81156014)(81166006)(1730700003)(4326008)(508600001)(36756003)(11346002)(2906002)(66946007)(186003)(66446008)(3846002)(66476007)(256004)(107886003)(2616005)(5660300002)(486006)(6116002)(6486002)(25786009)(305945005)(7736002)(316002)(6436002)(66066001)(52116002)(386003)(118296001)(99286004)(54906003)(5640700003)(6512007)(44832011)(50226002)(102836004)(71200400001)(71190400001)(2351001)(76176011)(6506007)(8936002)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3779;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZpS+OfN4VOaF43XTxftpwUulNdO0iZikqgafxJu600A2AwO4J4KPK7iMuUhL5R0tx7Ql5MBs5Ko4RKa6yC/On8ieJNSXVJTCgn6MqXkFK1Rm742zBz3MxcUXvE8A04MUTibdFjY6lAtPXCIyxYBh+tQzv6CF5WAiKG9iTfppDBtGVHlSBCBGma84RSIxhUrHeJktCGnGtvO2vm6FUV0moALSlQGdVGa+MPStJ3DipL6vcoiwK7An+BX39kz9HshxymfXitjGDF2YwHVN/z5lwP554O+K6uhqZSzM3Fw8TsA5sz38R/XflJ14pw6hgJ29KcpK0frObbpYDw0ZETAcmNaVpZJn4ZJXYdIh5gSETVv7es51KLSIapzcWiWs+52YgauLfvxS2+X2crfM4DRCcOeM48LoRu946BAtraL7nKU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d73d3cc7-6485-4254-66e6-08d74d8a5589
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 14:01:23.4237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r2nXhC5wIc12jVqfIm7XOEC4HQV46Rktg4+UvoAM5W+uwMA83yfENkMHjTErht9owj+eQOwwi8E77W8kuXoi4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From HW specification to correctly reset HW caches (this is a required
workaround when stopping the device), register bit should actually
be toggled.

It was previosly always just set. Due to the way driver stops HW this
never actually caused any issues, but it still may, so cleaning this up.

Fixes: 7a1bb49461b1 ("net: aquantia: fix potential IOMMU fault after driver=
 unbind")
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 16 ++++++++++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_llh.c     | 17 +++++++++++++++--
 .../aquantia/atlantic/hw_atl/hw_atl_llh.h     |  7 +++++--
 .../atlantic/hw_atl/hw_atl_llh_internal.h     | 19 +++++++++++++++++++
 4 files changed, 53 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 30f7fc4c97ff..3459fadb7ddd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -968,14 +968,26 @@ static int hw_atl_b0_hw_interrupt_moderation_set(stru=
ct aq_hw_s *self)
=20
 static int hw_atl_b0_hw_stop(struct aq_hw_s *self)
 {
+	int err;
+	u32 val;
+
 	hw_atl_b0_hw_irq_disable(self, HW_ATL_B0_INT_MASK);
=20
 	/* Invalidate Descriptor Cache to prevent writing to the cached
 	 * descriptors and to the data pointer of those descriptors
 	 */
-	hw_atl_rdm_rx_dma_desc_cache_init_set(self, 1);
+	hw_atl_rdm_rx_dma_desc_cache_init_tgl(self);
=20
-	return aq_hw_err_from_flags(self);
+	err =3D aq_hw_err_from_flags(self);
+
+	if (err)
+		goto err_exit;
+
+	readx_poll_timeout_atomic(hw_atl_rdm_rx_dma_desc_cache_init_done_get,
+				  self, val, val =3D=3D 1, 1000U, 10000U);
+
+err_exit:
+	return err;
 }
=20
 static int hw_atl_b0_hw_ring_tx_stop(struct aq_hw_s *self,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
index 1149812ae463..6f340695e6bd 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.c
@@ -606,12 +606,25 @@ void hw_atl_rpb_rx_flow_ctl_mode_set(struct aq_hw_s *=
aq_hw, u32 rx_flow_ctl_mode
 			    HW_ATL_RPB_RX_FC_MODE_SHIFT, rx_flow_ctl_mode);
 }
=20
-void hw_atl_rdm_rx_dma_desc_cache_init_set(struct aq_hw_s *aq_hw, u32 init=
)
+void hw_atl_rdm_rx_dma_desc_cache_init_tgl(struct aq_hw_s *aq_hw)
 {
+	u32 val;
+
+	val =3D aq_hw_read_reg_bit(aq_hw, HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_ADR,
+				 HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_MSK,
+				 HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_SHIFT);
+
 	aq_hw_write_reg_bit(aq_hw, HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_ADR,
 			    HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_MSK,
 			    HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_SHIFT,
-			    init);
+			    val ^ 1);
+}
+
+u32 hw_atl_rdm_rx_dma_desc_cache_init_done_get(struct aq_hw_s *aq_hw)
+{
+	return aq_hw_read_reg_bit(aq_hw, RDM_RX_DMA_DESC_CACHE_INIT_DONE_ADR,
+				  RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSK,
+				  RDM_RX_DMA_DESC_CACHE_INIT_DONE_SHIFT);
 }
=20
 void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_hw_s *aq_hw,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h b/d=
rivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
index 0c37abbabca5..c3ee278c3747 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh.h
@@ -313,8 +313,11 @@ void hw_atl_rpb_rx_pkt_buff_size_per_tc_set(struct aq_=
hw_s *aq_hw,
 					    u32 rx_pkt_buff_size_per_tc,
 					    u32 buffer);
=20
-/* set rdm rx dma descriptor cache init */
-void hw_atl_rdm_rx_dma_desc_cache_init_set(struct aq_hw_s *aq_hw, u32 init=
);
+/* toggle rdm rx dma descriptor cache init */
+void hw_atl_rdm_rx_dma_desc_cache_init_tgl(struct aq_hw_s *aq_hw);
+
+/* get rdm rx dma descriptor cache init done */
+u32 hw_atl_rdm_rx_dma_desc_cache_init_done_get(struct aq_hw_s *aq_hw);
=20
 /* set rx xoff enable (per tc) */
 void hw_atl_rpb_rx_xoff_en_per_tc_set(struct aq_hw_s *aq_hw, u32 rx_xoff_e=
n_per_tc,
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_inter=
nal.h b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
index c3febcdfa92e..35887ad89025 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_llh_internal.h
@@ -318,6 +318,25 @@
 /* default value of bitfield rdm_desc_init_i */
 #define HW_ATL_RDM_RX_DMA_DESC_CACHE_INIT_DEFAULT 0x0
=20
+/* rdm_desc_init_done_i bitfield definitions
+ * preprocessor definitions for the bitfield rdm_desc_init_done_i.
+ * port=3D"pif_rdm_desc_init_done_i"
+ */
+
+/* register address for bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_ADR 0x00005a10
+/* bitmask for bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSK 0x00000001U
+/* inverted bitmask for bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_MSKN 0xfffffffe
+/* lower bit position of bitfield  rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_SHIFT 0U
+/* width of bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_WIDTH 1
+/* default value of bitfield rdm_desc_init_done_i */
+#define RDM_RX_DMA_DESC_CACHE_INIT_DONE_DEFAULT 0x0
+
+
 /* rx int_desc_wrb_en bitfield definitions
  * preprocessor definitions for the bitfield "int_desc_wrb_en".
  * port=3D"pif_rdm_int_desc_wrb_en_i"
--=20
2.17.1

