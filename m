Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CF61F3BA1
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 23:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbfKGWmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 17:42:14 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:21914 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728055AbfKGWmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 17:42:11 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7MekHN002988;
        Thu, 7 Nov 2019 14:42:11 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=EShDkIMAPBcG4/eQ5ogqZs+FVPcfaQkwHuuXt2w0OhI=;
 b=A8WaU/VtlkxOatNNr7OSo/mjLQhsd3SVBli+pOUB2dH30tlYYVIPBPl7HjhIgiy/eYBM
 s7x/1qijvXLi3zmM+PlhM6rh4j8dlvtXoYYWttYIhWFb3bThl/MeoMoy/KHXAzQsVKSJ
 xelZELxKBG13dOGcEYT7zmWEvG29wvX6ivvskdMV2D3aODItHVoKYGxZAgLciQRVvjkw
 ndN/E513dJZUTltKOzwqc/vysLutE6EkItVqmn87yfP5fAn4aNMYxDyLAVFyVnLzkn6B
 LJeODKw9a24qJtGZdS7+ZVnPGT8IVs+4+6A/aYI5yHcfaxBcA5ErgINLzciynRJSxoIP Eg== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 2w41uwxrfm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 07 Nov 2019 14:42:10 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Thu, 7 Nov
 2019 14:42:10 -0800
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (104.47.33.53) by
 SC-EXCH04.marvell.com (10.93.176.84) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Thu, 7 Nov 2019 14:42:09 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K6cZMQEOhpqBBf5y7kq/JYlQVjN1ZHsYcc9wBSTvjn+v/EGTKLm8kAFpRp/4ZUq7qT/QZLXD05AOhZw7k7xmJp+ZZtkvBQnye/2Js57MmVYBLODf5xVdT6Zh1HK3Fkp6VBF/+C0L505Di76dWizz7YE7rR5e/GnDkD0hvoGEjfaUT8yT1IYk7xZZYHD47cnthrAWqMAk5AIz5CkoLKl26Yy9tMxlL8bdlbWvKRzsF95C4W8Jhi3lNp0+9sb/EK+e4vzTVxzDvN8sAd1YXQegUDGIQVTeenKHX/lmAh+u0jZ68ohNUrIrOSVnm9pwehPspvhQePkaBDw41maRx3SmZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EShDkIMAPBcG4/eQ5ogqZs+FVPcfaQkwHuuXt2w0OhI=;
 b=atiRmjrZFsoHSE9PicU7W8QeYu2QXiiQO7j4B2oNaGK42xysupGl9JVSMCSUzRqVGExTgFFfsjcKHLlEqdl1gji7eYmWJ27MWPxC650M2EaCt3UnpigD536RoTOIOYSf+8eaSn5GNSdKqHXrkDaddfILtD9yTTwFCHQ6FMdpoDY62IFYGdCEsjhoYFkYXAta37uscErykNrgWGAiK6P/74/i3ZQY1x+ywLCiIUvkv0CpWwQD6PXaJ+TSnkW9sx9WMhlaraR0RAFoA2I2umNDDGAuk2dYSEUy1iBD1yZsi/OD5LtU1Sx7MKdctTxcNBFkIZAdxsVGF2qHtYXlqtCRgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EShDkIMAPBcG4/eQ5ogqZs+FVPcfaQkwHuuXt2w0OhI=;
 b=scW60x9nRXbU5mWYCO1P3yEJfqsdkAo0ufvX4vhdP+3mA0vOT0zoejoo+EPF6ldgrwBLwcvfUZLSJHUp51naU6sdyyIs/p/vIyR9zMc/yLcUQQna3AOhUoewNEDNe/7mmFMVm/Xl03EpgrWOsXCWoaTK6ROhrPNaN2wKR/1K6dg=
Received: from DM5PR18MB1642.namprd18.prod.outlook.com (10.175.224.8) by
 DM5PR18MB2295.namprd18.prod.outlook.com (52.132.142.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Thu, 7 Nov 2019 22:42:06 +0000
Received: from DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15]) by DM5PR18MB1642.namprd18.prod.outlook.com
 ([fe80::d89:706b:cda0:5c15%10]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 22:42:06 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 11/12] net: atlantic: implement UDP GSO offload
Thread-Topic: [PATCH v2 net-next 11/12] net: atlantic: implement UDP GSO
 offload
Thread-Index: AQHVlbyUTOddqZfT7kOvjU5QsGzgGw==
Date:   Thu, 7 Nov 2019 22:42:06 +0000
Message-ID: <72bfbfd354f4736f0a5fb1573543eb7fe5f7a56e.1573158382.git.irusskikh@marvell.com>
References: <cover.1573158381.git.irusskikh@marvell.com>
In-Reply-To: <cover.1573158381.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2PR09CA0011.eurprd09.prod.outlook.com
 (2603:10a6:101:16::23) To DM5PR18MB1642.namprd18.prod.outlook.com
 (2603:10b6:3:14c::8)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da6c40dc-79ca-483d-bc3e-08d763d3b6d2
x-ms-traffictypediagnostic: DM5PR18MB2295:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR18MB229523A88EB1E50C433AC81BB7780@DM5PR18MB2295.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:262;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(346002)(366004)(39860400002)(136003)(396003)(376002)(189003)(199004)(64756008)(76176011)(7736002)(99286004)(316002)(66066001)(54906003)(2351001)(52116002)(5640700003)(2501003)(8676002)(25786009)(118296001)(8936002)(305945005)(81166006)(81156014)(1730700003)(6486002)(478600001)(71200400001)(71190400001)(6436002)(50226002)(6916009)(66476007)(6116002)(6512007)(14454004)(2616005)(476003)(256004)(486006)(186003)(3846002)(102836004)(11346002)(107886003)(36756003)(66946007)(26005)(2906002)(66446008)(86362001)(66556008)(4326008)(386003)(6506007)(5660300002)(446003)(14444005);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR18MB2295;H:DM5PR18MB1642.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BWtpP9X3PPs7t3yNOG7/riQ5C5xK5SFzR7k52z3eun9gayhlFYqZYBS7iIcgvn8UZVnTXWocizfJRMTLrjiJLV/9ozlKAl+nOk9WABDHWgejUbRPEcZ9dRRSv7h+pzKVgaF1XeSuRO/GIsw+nhv7Gef0i73OpL+A9Ni4UvjTpBUtDKr3dNtLhfxGbeoEsz4pj8FiugSO+Gc7Le0gQrV0TzHjQZpn/RfDLH4gGgdHgjODeAyFgt7h11M1SYciZFm9XvOm5sADsQAb/LOU6vImbziOCxCWAktSYsGHZZi55n6+/Kg/pGCDfVqb0GEjzhVcz+nJm0V7JRXwACftLA6S0y6U+J39i+iOVM/CZEs/cGJE524ptqR5ePQyWotmmEZuEgQINvNNes6s2q0UqkcITABKrJiwFeMOTpc8x981BBPDipPBgy8YpzuTEJZ8VqfN
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: da6c40dc-79ca-483d-bc3e-08d763d3b6d2
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 22:42:06.7191
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7sIv9EDqXS1tE8NZehp4jWmdr8X9tv4JfKqESqbMYWzAXrSswXa1XNUfbzolKDU/HF3M82pZWokcLS10M1MEAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR18MB2295
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_07:2019-11-07,2019-11-07 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

atlantic hardware does support UDP hardware segmentation offload.
This allows user to specify one large contiguous buffer with data
which then will be split automagically into multiple UDP packets
of specified size.

Bulk sending of large UDP streams lowers CPU usage and increases
bandwidth.

We did estimations both with udpgso_bench_tx test tool and with modified
iperf3 measurement tool (4 streams, multithread, 200b packet size)
over AQC<->AQC 10G link. Flow control is disabled to prevent RX side
impact on measurements.

No UDP GSO:
	iperf3 -c 10.0.1.2 -u -b0 -l 200 -P4 --multithread
UDP GSO:
	iperf3 -c 10.0.1.2 -u -b0 -l 12600 --udp-lso 200 -P4 --multithread

Mode          CPU   iperf speed    Line speed   Packets per second
-------------------------------------------------------------
NO UDP GSO    350%   3.07 Gbps      3.8 Gbps     1,919,419
SW UDP GSO    200%   5.55 Gbps      6.4 Gbps     3,286,144
HW UDP GSO    90%    6.80 Gbps      8.4 Gbps     4,273,117

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 .../device_drivers/aquantia/atlantic.txt      | 15 ++++++
 .../net/ethernet/aquantia/atlantic/aq_nic.c   | 52 ++++++++++---------
 .../net/ethernet/aquantia/atlantic/aq_ring.h  |  7 +--
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c      |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      | 11 ++--
 5 files changed, 55 insertions(+), 32 deletions(-)

diff --git a/Documentation/networking/device_drivers/aquantia/atlantic.txt =
b/Documentation/networking/device_drivers/aquantia/atlantic.txt
index ef3d8c749d4c..d614250e37d5 100644
--- a/Documentation/networking/device_drivers/aquantia/atlantic.txt
+++ b/Documentation/networking/device_drivers/aquantia/atlantic.txt
@@ -325,6 +325,21 @@ Supported ethtool options
  Example:
  ethtool -N eth0 flow-type udp4 action 0 loc 32
=20
+ UDP GSO hardware offload
+ ---------------------------------
+ UDP GSO allows to boost UDP tx rates by offloading UDP headers allocation
+ into hardware. A special userspace socket option is required for this,
+ could be validated with /kernel/tools/testing/selftests/net/
+
+    udpgso_bench_tx -u -4 -D 10.0.1.1 -s 6300 -S 100
+
+ Will cause sending out of 100 byte sized UDP packets formed from single
+ 6300 bytes user buffer.
+
+ UDP GSO is configured by:
+
+    ethtool -K eth0 tx-udp-segmentation on
+
  Private flags (testing)
  ---------------------------------
=20
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/=
ethernet/aquantia/atlantic/aq_nic.c
index 7ad8eb535d28..a17a4da7bc15 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -309,6 +309,7 @@ void aq_nic_ndev_init(struct aq_nic_s *self)
 	self->ndev->vlan_features |=3D NETIF_F_HW_CSUM | NETIF_F_RXCSUM |
 				     NETIF_F_RXHASH | NETIF_F_SG |
 				     NETIF_F_LRO | NETIF_F_TSO;
+	self->ndev->gso_partial_features =3D NETIF_F_GSO_UDP_L4;
 	self->ndev->priv_flags =3D aq_hw_caps->hw_priv_flags;
 	self->ndev->priv_flags |=3D IFF_LIVE_ADDR_CHANGE;
=20
@@ -472,11 +473,18 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, st=
ruct sk_buff *skb,
 {
 	unsigned int nr_frags =3D skb_shinfo(skb)->nr_frags;
 	struct aq_ring_buff_s *first =3D NULL;
+	u8 ipver =3D ip_hdr(skb)->version;
 	struct aq_ring_buff_s *dx_buff;
 	bool need_context_tag =3D false;
 	unsigned int frag_count =3D 0U;
 	unsigned int ret =3D 0U;
 	unsigned int dx;
+	u8 l4proto =3D 0;
+
+	if (ipver =3D=3D 4)
+		l4proto =3D ip_hdr(skb)->protocol;
+	else if (ipver =3D=3D 6)
+		l4proto =3D ipv6_hdr(skb)->nexthdr;
=20
 	dx =3D ring->sw_tail;
 	dx_buff =3D &ring->buff_ring[dx];
@@ -484,14 +492,24 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, st=
ruct sk_buff *skb,
=20
 	if (unlikely(skb_is_gso(skb))) {
 		dx_buff->mss =3D skb_shinfo(skb)->gso_size;
-		dx_buff->is_gso =3D 1U;
+		if (l4proto =3D=3D IPPROTO_TCP) {
+			dx_buff->is_gso_tcp =3D 1U;
+			dx_buff->len_l4 =3D tcp_hdrlen(skb);
+		} else if (l4proto =3D=3D IPPROTO_UDP) {
+			dx_buff->is_gso_udp =3D 1U;
+			dx_buff->len_l4 =3D sizeof(struct udphdr);
+			/* UDP GSO Hardware does not replace packet length. */
+			udp_hdr(skb)->len =3D htons(dx_buff->mss +
+						  dx_buff->len_l4);
+		} else {
+			WARN_ONCE(true, "Bad GSO mode");
+			goto exit;
+		}
 		dx_buff->len_pkt =3D skb->len;
 		dx_buff->len_l2 =3D ETH_HLEN;
-		dx_buff->len_l3 =3D ip_hdrlen(skb);
-		dx_buff->len_l4 =3D tcp_hdrlen(skb);
+		dx_buff->len_l3 =3D skb_network_header_len(skb);
 		dx_buff->eop_index =3D 0xffffU;
-		dx_buff->is_ipv6 =3D
-			(ip_hdr(skb)->version =3D=3D 6) ? 1U : 0U;
+		dx_buff->is_ipv6 =3D (ipver =3D=3D 6);
 		need_context_tag =3D true;
 	}
=20
@@ -525,24 +543,9 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, str=
uct sk_buff *skb,
 	++ret;
=20
 	if (skb->ip_summed =3D=3D CHECKSUM_PARTIAL) {
-		dx_buff->is_ip_cso =3D (htons(ETH_P_IP) =3D=3D skb->protocol) ?
-			1U : 0U;
-
-		if (ip_hdr(skb)->version =3D=3D 4) {
-			dx_buff->is_tcp_cso =3D
-				(ip_hdr(skb)->protocol =3D=3D IPPROTO_TCP) ?
-					1U : 0U;
-			dx_buff->is_udp_cso =3D
-				(ip_hdr(skb)->protocol =3D=3D IPPROTO_UDP) ?
-					1U : 0U;
-		} else if (ip_hdr(skb)->version =3D=3D 6) {
-			dx_buff->is_tcp_cso =3D
-				(ipv6_hdr(skb)->nexthdr =3D=3D NEXTHDR_TCP) ?
-					1U : 0U;
-			dx_buff->is_udp_cso =3D
-				(ipv6_hdr(skb)->nexthdr =3D=3D NEXTHDR_UDP) ?
-					1U : 0U;
-		}
+		dx_buff->is_ip_cso =3D (htons(ETH_P_IP) =3D=3D skb->protocol);
+		dx_buff->is_tcp_cso =3D (l4proto =3D=3D IPPROTO_TCP);
+		dx_buff->is_udp_cso =3D (l4proto =3D=3D IPPROTO_UDP);
 	}
=20
 	for (; nr_frags--; ++frag_count) {
@@ -597,7 +600,8 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, stru=
ct sk_buff *skb,
 	     --ret, dx =3D aq_ring_next_dx(ring, dx)) {
 		dx_buff =3D &ring->buff_ring[dx];
=20
-		if (!dx_buff->is_gso && !dx_buff->is_vlan && dx_buff->pa) {
+		if (!(dx_buff->is_gso_tcp || dx_buff->is_gso_udp) &&
+		    !dx_buff->is_vlan && dx_buff->pa) {
 			if (unlikely(dx_buff->is_sop)) {
 				dma_unmap_single(aq_nic_get_dev(self),
 						 dx_buff->pa,
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.h
index be3702a4dcc9..991e4d31b094 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.h
@@ -65,19 +65,20 @@ struct __packed aq_ring_buff_s {
 	};
 	union {
 		struct {
-			u16 len;
+			u32 len:16;
 			u32 is_ip_cso:1;
 			u32 is_udp_cso:1;
 			u32 is_tcp_cso:1;
 			u32 is_cso_err:1;
 			u32 is_sop:1;
 			u32 is_eop:1;
-			u32 is_gso:1;
+			u32 is_gso_tcp:1;
+			u32 is_gso_udp:1;
 			u32 is_mapped:1;
 			u32 is_cleaned:1;
 			u32 is_error:1;
 			u32 is_vlan:1;
-			u32 rsvd3:5;
+			u32 rsvd3:4;
 			u16 eop_index;
 			u16 rsvd4;
 		};
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
index 03b62d7d9f1a..9b1062b8af64 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_a0.c
@@ -454,7 +454,7 @@ static int hw_atl_a0_hw_ring_tx_xmit(struct aq_hw_s *se=
lf,
=20
 		buff =3D &ring->buff_ring[ring->sw_tail];
=20
-		if (buff->is_gso) {
+		if (buff->is_gso_tcp) {
 			txd->ctl |=3D (buff->len_l3 << 31) |
 				(buff->len_l2 << 24) |
 				HW_ATL_A0_TXD_CTL_CMD_TCP |
diff --git a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c b/dr=
ivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
index 57b357eadd51..51db38038cbc 100644
--- a/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
+++ b/drivers/net/ethernet/aquantia/atlantic/hw_atl/hw_atl_b0.c
@@ -43,7 +43,9 @@
 			NETIF_F_NTUPLE |  \
 			NETIF_F_HW_VLAN_CTAG_FILTER | \
 			NETIF_F_HW_VLAN_CTAG_RX |     \
-			NETIF_F_HW_VLAN_CTAG_TX,      \
+			NETIF_F_HW_VLAN_CTAG_TX |     \
+			NETIF_F_GSO_UDP_L4      |     \
+			NETIF_F_GSO_PARTIAL,          \
 	.hw_priv_flags =3D IFF_UNICAST_FLT, \
 	.flow_control =3D true,		  \
 	.mtu =3D HW_ATL_B0_MTU_JUMBO,	  \
@@ -533,8 +535,9 @@ static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *se=
lf,
=20
 		buff =3D &ring->buff_ring[ring->sw_tail];
=20
-		if (buff->is_gso) {
-			txd->ctl |=3D HW_ATL_B0_TXD_CTL_CMD_TCP;
+		if (buff->is_gso_tcp || buff->is_gso_udp) {
+			if (buff->is_gso_tcp)
+				txd->ctl |=3D HW_ATL_B0_TXD_CTL_CMD_TCP;
 			txd->ctl |=3D HW_ATL_B0_TXD_CTL_DESC_TYPE_TXC;
 			txd->ctl |=3D (buff->len_l3 << 31) |
 				    (buff->len_l2 << 24);
@@ -554,7 +557,7 @@ static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *se=
lf,
 			txd->ctl |=3D buff->vlan_tx_tag << 4;
 			is_vlan =3D true;
 		}
-		if (!buff->is_gso && !buff->is_vlan) {
+		if (!buff->is_gso_tcp && !buff->is_gso_udp && !buff->is_vlan) {
 			buff_pa_len =3D buff->len;
=20
 			txd->buf_addr =3D buff->pa;
--=20
2.17.1

