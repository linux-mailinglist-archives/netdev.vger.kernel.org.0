Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21A31D41A3
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728546AbfJKNpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:45:25 -0400
Received: from mail-eopbgr740048.outbound.protection.outlook.com ([40.107.74.48]:39328
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728232AbfJKNpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:45:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ps/diwjnsafwr7J7oV5yn54JmkWhyu4Jt1kaAUEPeL/d9bRh3IYH8vsA5yLuuPuI/ZEVO3KmGNlCasUzwLAlm8B3fwv7+js7b41DAeBnQ2QMioCxNTQFVAej5I0CFR07UHlZaFqXl08ZlwlsPDiaThCpd9fNatGkYGE7ivWSRBIrR9x+cqXnri8xZAPsm2V/1Od+N6oZ8FDX0yul2oKeHGHC16IA0wJWPS9rtbFqJSheYxbsa1QkW/DmhhlS6Z2mb+iq+AVqyXli5uT1dNChTpVd9rBGRmgZaKN3CbSGSix0yIxCsGPR30BPV4wphMhB3HCqz+DdpluNP/C/1pOjUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LL9KZ4iwo4wqxi9uA0qslf/7N1J6UZdNb6DIi49UsgY=;
 b=Z2BhWtgXvEXO+VHAMe3MuiBeL5OUysXlVr4ZQG7F6s/nd0Jxq3Qykvu5NaxrYMVasZwcKBSxEwY7EM7wUiQ6bOqB4LxB4/ZtNO32LicAatmCkOVjm5ibxsEh1bNNaYuDQW8r+FOXA0KbWpDPXnFOEs1QmHjZkOIy9fLVdM/YfQCMTJYQjGp3ZmbIf/qNy3/ns/PAcc4Ty3x0neAIBJmCzi3EQ5OBom9ypkIHwZ7NfgfOUXesLOL9hv8VFx7D05j5v9acFt2mXyt4qgx19hLzll7fKNaU0MsL3BUtNp45kO2MIDOK3o/oYxDcqxCANtw/aTVJdRzTp0gOSJltmhD/Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LL9KZ4iwo4wqxi9uA0qslf/7N1J6UZdNb6DIi49UsgY=;
 b=ndKhCXDF9NyKS52ivibACdiA3PsjbLw27yTHEG4APZm9BlKPvQY41KVG1z/AJbEdrwgPUbIRFa6pU/MJ/EtLIn0YpHirvv9vEQU39eQvkGzKQT+0+O4Y/DgkbD1YYOOcW7kFq6aTgFFwfx0YxLsgE8+6J2XwusWJvCswnqWGm74=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Fri, 11 Oct 2019 13:45:21 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 13:45:21 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v2 net 2/4] net: aquantia: when cleaning hw cache it should be
 toggled
Thread-Topic: [PATCH v2 net 2/4] net: aquantia: when cleaning hw cache it
 should be toggled
Thread-Index: AQHVgDof48Tbq5/7JkCldRfrcGfLJA==
Date:   Fri, 11 Oct 2019 13:45:20 +0000
Message-ID: <d89180cd7ddf6981310179108b37a8d15c44c02f.1570787323.git.igor.russkikh@aquantia.com>
References: <cover.1570787323.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570787323.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0005.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::17)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4e640aa7-d986-4f31-e589-08d74e514230
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3587671AE81AE3A27BD6FF1098970@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1169;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39850400004)(136003)(346002)(396003)(189003)(199004)(6916009)(66446008)(14454004)(76176011)(36756003)(64756008)(99286004)(118296001)(66476007)(446003)(11346002)(486006)(2351001)(52116002)(476003)(66946007)(66556008)(2501003)(305945005)(6506007)(44832011)(7736002)(386003)(5660300002)(86362001)(2616005)(66066001)(102836004)(26005)(508600001)(8676002)(81156014)(107886003)(316002)(71190400001)(81166006)(54906003)(1730700003)(4326008)(3846002)(6116002)(71200400001)(2906002)(256004)(6486002)(5640700003)(50226002)(25786009)(6436002)(6512007)(186003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J/QaOSLTSIaXgx2hcsZFf3rnGDg594JFMpKDyBSFH+E9/e+NrWtTsXfd3vz5vI/UWRluzdyjiGAyUyRVuyTKA1jC3WtQTbJ5j65SblLjnwyymO4Cn+cpJu4FrEelEhVylLrd6GzYjvbQsEFpGjky2GVXMAdx/Y6FpstXjDdCDxhaSi2FfCzVnJcfjtO0UAmEWhu2kH4NQj7zNVTTYenuSYPUcgVMAbf0LVKfNS9Nunf5CEeJZbTS0D5nmItH7YJjX/SITQf0598Af39eSjtNkm07Rp66AvgnX7jrc3dXW1segUQmli3iB0LK5HQql1PXDu+6frCazulk3rfeKksp5+8O6Ebx0wOjLiQFYZ2dDRbp3Co9nEhleuSz2/Z0e1F2Wne+F7LRG0AkMSQIFT2GU3lffjyauts6l+eXyBQupxE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e640aa7-d986-4f31-e589-08d74e514230
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 13:45:20.8651
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XrUo9TuoAjdhnXY3GP7mxHUPtRzJGPOwQiBTo+Cff3AYQweXCPzSRK6nlJVargXNPrXYRHu8TZDoqZWAih3Yvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
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

