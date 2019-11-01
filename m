Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 368F1EC295
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 13:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730571AbfKAMRi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 08:17:38 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35780 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730597AbfKAMRh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 08:17:37 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA1CA3Fd019176;
        Fri, 1 Nov 2019 05:17:36 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=BCOZUjy0R2+JIL4ds+u9imwe0QH7FVuY0jxK7H7MrEc=;
 b=Xt9Ts8bjbADljmPl0tUMIxY6BYntf0oY0xRzsE1kx5Y3B5njQD6kQw3evfWcIorPEfVx
 +HvWvIAobo6gG/Dzo76PX62laS8V9hbJ/XGfwBJLuRy8wqejaNFxUpBgGuwwMm4waTUm
 2w9XzN8KLxpqz6zpQP54lf0kyfHVQqqHxP9uC73QSVL5SfjGPislB9JLGW2bOTsSavD4
 X5bn5466dHhqSplXKhDHuiFz5ZYNZmRQRKK0sljoBg0GnB96W0Ts+1DWQw4UQ0D6QlOu
 v29RYWYmSZXjOjQI4DggFYnD0n/xcE+4T6y701GaNE4XYTQ5/yAohrMWdBOF+EDeN00+ wg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 2vyxhy4qc4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 01 Nov 2019 05:17:36 -0700
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1367.3; Fri, 1 Nov
 2019 05:17:34 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (104.47.37.59) by
 SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1367.3 via Frontend Transport; Fri, 1 Nov 2019 05:17:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HkzRigHgCVI+/zxt1VEBVpwBjPH+ZAbVCZLXlq6A/tFTBclQ+6K/CMwvQDYImHLu5KQ29vzDJnnpQO3KubCf47+pAyIRffDi+S1IjeUMfgITtixjLB+nNPAP6AoousymUwRJTlTQkfMY6kJfnAKRj5fXLk+A8VGXs9y9qbKFc/WZxZwekRN0/fP0HHtDMG1lw4SKZv0gilZXMWIm5rypSpxjWCNWAyUsx3oIoEM0TCbMbhlrGjDWrwUGUMjF5ZjUw4jYx+QFynk45xk/we4nemocuGJ/4G9Oxm2TevNusiWbp7iPN0cQEmT5PWPFIZ+x5XJR8NymuRoBfOwNCxx9Gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCOZUjy0R2+JIL4ds+u9imwe0QH7FVuY0jxK7H7MrEc=;
 b=V6L5toclAW1JHvLZY1yGe86jPNjUdCQDYeHTcYagUpu+xn+aCxtla0ulaQeqOXoRRc2n5Cjy4flRYe22iYW6x6eyRoqk1OOV1kQFHLUBDKaIKnSuwbGAuhSCMq1YnGM6HLtj5Wgz3YM8+AbeN1BA6ne9/Ok7s2ycDyNamr869Vj9uOJEYnTPG0uHgkEeyHTHmxfQKwojEPK9kG2ChHVhiRlbMdQH0h4372HAyV8MrG6rgUOHRI2a6G3tmNWY9iTRPDUxK7/F+xEUUBn+5m+KKNhNURgzqWJ+Q53E5pRfA9GJOdVCCdIZ0nSddl1/DliUt0bmDDdB56AgeZ83az2MPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector2-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BCOZUjy0R2+JIL4ds+u9imwe0QH7FVuY0jxK7H7MrEc=;
 b=nW3zHuvy5iNp9jmiInfF4wzhOhlrEkMUa6B5c5ptk0V2iv6KCvYt+42JXLYc/F/JWILoJYTXLS7/WZZCJiAmf/K/kByutCFdAcDUTEVL3Moan0ty5gmW9UzPmpNsNls8obUfw4pkJ1nFnEh3DMKsYQ2vryYbQeSey6tfLC8bCG4=
Received: from BL0PR18MB2275.namprd18.prod.outlook.com (52.132.30.141) by
 BL0PR18MB2306.namprd18.prod.outlook.com (52.132.30.153) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 1 Nov 2019 12:17:27 +0000
Received: from BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981]) by BL0PR18MB2275.namprd18.prod.outlook.com
 ([fe80::4152:b5a9:45c2:a981%3]) with mapi id 15.20.2387.028; Fri, 1 Nov 2019
 12:17:27 +0000
From:   Igor Russkikh <irusskikh@marvell.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH net-next 11/12] net: atlantic: implement UDP GSO offload
Thread-Topic: [PATCH net-next 11/12] net: atlantic: implement UDP GSO offload
Thread-Index: AQHVkK5TrID/dPWqnk6zS6twyvLpdA==
Date:   Fri, 1 Nov 2019 12:17:27 +0000
Message-ID: <e85100822a4656332c8aa208a2e98af3df12e325.1572610156.git.irusskikh@marvell.com>
References: <cover.1572610156.git.irusskikh@marvell.com>
In-Reply-To: <cover.1572610156.git.irusskikh@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0035.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::23) To BL0PR18MB2275.namprd18.prod.outlook.com
 (2603:10b6:207:44::13)
x-mailer: git-send-email 2.17.1
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e4c495fd-9893-49e1-2135-08d75ec57577
x-ms-traffictypediagnostic: BL0PR18MB2306:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BL0PR18MB230672DA088DF1BFEC849213B7620@BL0PR18MB2306.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:262;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(1496009)(4636009)(136003)(396003)(376002)(346002)(39860400002)(366004)(199004)(189003)(81156014)(186003)(25786009)(102836004)(14444005)(52116002)(6916009)(256004)(76176011)(6506007)(66066001)(36756003)(386003)(66556008)(66476007)(2351001)(66446008)(486006)(26005)(64756008)(476003)(66946007)(2501003)(478600001)(99286004)(3846002)(11346002)(5660300002)(71200400001)(107886003)(71190400001)(50226002)(2906002)(8936002)(86362001)(118296001)(2616005)(81166006)(316002)(446003)(6486002)(54906003)(7736002)(6116002)(14454004)(305945005)(6512007)(8676002)(6436002)(5640700003)(1730700003)(4326008);DIR:OUT;SFP:1101;SCL:1;SRVR:BL0PR18MB2306;H:BL0PR18MB2275.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cFIEbK9IVSeq81susyIXpTCWHlrZjUB9c5nQBh4n+uxhiitzSBq27L8c68f7HvVJHo8oiptqFWCgcf8Ffh4MIggejaA7kWQPa1NzLttiW3VikT07IBFTjYlRgCWtpuGA3uEIYMfuJT14Jb2zNggXTNg2DBJGOZPO6OrQPynBI25W7i4yasdSvG30F0+KIGKZyMdEgyh3etBnYgr7ies5565KM2ieQrA4SSfWXXTZkSPE2fSp4sqlDNeOeLOLI4kyeZqmg4rfwOoij7cMvGk5ZynUQyvBaj9t9swwQw/781oxJHSivZriQxVdgEwCcoIEmQLTpHboRXjnJp2wdIIBiJmHr46oYYXJcnP0vKaxwY3U1FtMdHWw89MgUbcnoh26BceMssO9ml9PW56lWoJ7UKkUa8Iz8GZ30U865IC7z4O85/PDTqb36UemymiP5Dcd
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e4c495fd-9893-49e1-2135-08d75ec57577
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 12:17:27.0833
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q4W0gfD7esNYjG9jcF/IctQpqrKcgG76w0HPQ+rxTfNwz2pHFaTXtxLYbknmvPbr3wNv+ElFAEbg/5MlwHIsXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR18MB2306
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-11-01_04:2019-10-30,2019-11-01 signatures=0
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
 .../device_drivers/aquantia/atlantic.txt         | 15 +++++++++++++++
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  | 16 +++++++++++++---
 drivers/net/ethernet/aquantia/atlantic/aq_ring.h |  7 ++++---
 .../aquantia/atlantic/hw_atl/hw_atl_a0.c         |  2 +-
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c         | 11 +++++++----
 5 files changed, 40 insertions(+), 11 deletions(-)

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
index 7ad8eb535d28..742ee5fe003e 100644
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
@@ -484,11 +485,19 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, st=
ruct sk_buff *skb,
=20
 	if (unlikely(skb_is_gso(skb))) {
 		dx_buff->mss =3D skb_shinfo(skb)->gso_size;
-		dx_buff->is_gso =3D 1U;
+		if (ip_hdr(skb)->protocol =3D=3D IPPROTO_TCP) {
+			dx_buff->is_gso_tcp =3D 1U;
+			dx_buff->len_l4 =3D tcp_hdrlen(skb);
+		} else if (ip_hdr(skb)->protocol =3D=3D IPPROTO_UDP) {
+			dx_buff->is_gso_udp =3D 1U;
+			dx_buff->len_l4 =3D sizeof(struct udphdr);
+			/* UDP GSO Hardware does not replace packet length. */
+			udp_hdr(skb)->len =3D htons(dx_buff->mss +
+						  dx_buff->len_l4);
+		}
 		dx_buff->len_pkt =3D skb->len;
 		dx_buff->len_l2 =3D ETH_HLEN;
 		dx_buff->len_l3 =3D ip_hdrlen(skb);
-		dx_buff->len_l4 =3D tcp_hdrlen(skb);
 		dx_buff->eop_index =3D 0xffffU;
 		dx_buff->is_ipv6 =3D
 			(ip_hdr(skb)->version =3D=3D 6) ? 1U : 0U;
@@ -597,7 +606,8 @@ unsigned int aq_nic_map_skb(struct aq_nic_s *self, stru=
ct sk_buff *skb,
 	     --ret, dx =3D aq_ring_next_dx(ring, dx)) {
 		dx_buff =3D &ring->buff_ring[dx];
=20
-		if (!dx_buff->is_gso && !dx_buff->is_vlan && dx_buff->pa) {
+		if (!(dx_buff->is_gso_tcp | dx_buff->is_gso_udp) &&
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
index e4de258a5c19..2a8f84064701 100644
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
@@ -531,8 +533,9 @@ static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *se=
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
@@ -552,7 +555,7 @@ static int hw_atl_b0_hw_ring_tx_xmit(struct aq_hw_s *se=
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

