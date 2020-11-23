Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5732C17D0
	for <lists+netdev@lfdr.de>; Mon, 23 Nov 2020 22:43:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgKWVk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Nov 2020 16:40:59 -0500
Received: from outbound-ip23b.ess.barracuda.com ([209.222.82.220]:37766 "EHLO
        outbound-ip23b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727725AbgKWVk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Nov 2020 16:40:59 -0500
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2170.outbound.protection.outlook.com [104.47.55.170]) by mx11.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Mon, 23 Nov 2020 21:40:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ECEuhGELZyLEPERAc9h4LynLF2Y9tyMtr6UEHFKhDIq9/Zx8MRBP+lGUBW62PXsuuaBueK3lCmO9YL/wlZ6dZFqAlg8y8AYTnY6r5Lkq2tdelj0Q5nym6NF6urQNon6picEMHe7X4gZP2zN9zlpI1ARfs0eWMUhffS8OHf5IQTi6ANr/YrqP1yNRZBXHUOJYS60I9TzH1YovV0M1niEUlQIBLN9Te++uOCS017FHkbkTpbcXrBhqA5ceIJVv74NeiGRDaXZdTU3oYD1x1OTilvMeEaoRlg6LWIr9QD+f7kX0POpwhlxvS1J4oeduUIxoX9enjmo3Su+2yqIrXFROTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYF3O88g55LxntHOirtiAOBWijSUsa3ZDetwBaHJeOs=;
 b=PPIlocrdPIQdIo4MDfjTtLqzoUAtfM3HzR7wizURt2PUxglIDygEHDglgFZ1mEwuPrdsevZmB5wQQKhdrD2QG8gm0mQUDX6b69OJ8VklI7O3ivKONWI5uTnoCOejwHgLEpgyxDW+M9cWEdImnKNHMbkRrSPLdT9DBtrj/ZEaCJq08ZSKNAhzFj8qb3lji0YQ+DPnn7+9VMFmlvL6tns/TEaBvLPp12rxODjkGmYRiKTtIL13IODsVsb6F6WlsWA0liEKpZLheEFBYlvdo2IllztR33KYQVNsWAVAWithAiCdioQ0sqUnfIGwFN8hlHS4VQY1shBHowPhq438rW8EvQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yYF3O88g55LxntHOirtiAOBWijSUsa3ZDetwBaHJeOs=;
 b=YzwYS0lWPWSsJ2ez1vZqJ6qH5/MCcrh84vnL+JMVNes61l5eHU34aaWQlHDVx/I4OsJ8dPxCpyGFwu7DXm59HPH9EhFbyV7iOsVaXtqUFFOwzwpM+gGMMd5q+eyJDIPAB3U1ERQJKZHzzUa+q4bIAEpmTuPE2SFhB6UJ2TsmSHk=
Received: from MWHPR1001MB2318.namprd10.prod.outlook.com
 (2603:10b6:301:2f::24) by MWHPR10MB1567.namprd10.prod.outlook.com
 (2603:10b6:300:25::8) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.28; Mon, 23 Nov
 2020 21:40:43 +0000
Received: from MWHPR1001MB2318.namprd10.prod.outlook.com
 ([fe80::1c70:e1c:a083:b70d]) by MWHPR1001MB2318.namprd10.prod.outlook.com
 ([fe80::1c70:e1c:a083:b70d%6]) with mapi id 15.20.3589.029; Mon, 23 Nov 2020
 21:40:43 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Florian Westphal <fw@strlen.de>,
        Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH net v5] aquantia: Remove the build_skb path
Thread-Topic: [PATCH net v5] aquantia: Remove the build_skb path
Thread-Index: AQHWweFL/THwq3On1Euf1RGIAqKMLg==
Date:   Mon, 23 Nov 2020 21:40:43 +0000
Message-ID: <MWHPR1001MB23184F3EAFA413E0D1910EC9E8FC0@MWHPR1001MB2318.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119221510.GI15137@breakpoint.cc>
        <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119222800.GJ15137@breakpoint.cc>
        <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201119225842.GK15137@breakpoint.cc>
        <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
        <20201121132204.43f9c4fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201121132324.72d79e94@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CY4PR1001MB2311E9770EF466FB922CBB27E8FD0@CY4PR1001MB2311.namprd10.prod.outlook.com>,<20201123084243.423b23a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201123084243.423b23a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84f48b65-f342-4e02-d8bb-08d88ff86e38
x-ms-traffictypediagnostic: MWHPR10MB1567:
x-microsoft-antispam-prvs: <MWHPR10MB156715A1DA46DD6E85ADB519E8FC0@MWHPR10MB1567.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jrk7CLbJdBjLzHCzJ5dGRJs8nFBXK7nWQlImjWUNLo4x8OiOzD6CCjMo90+Q+3efm6u2brdR2r+MVqYRF7ajvmI6h8SCnWMza/GcXPLD+JoCMuudtB8d7+2uO+W01hG78JNlqplFzPjRagzAQfU/7dpJ2dsZP5wU0+OmL2Bsx+I6ByIMpAM2AKqo0tKU9ziLC/goGVazffqy8N96ybZ/Ns6q7hAlYiD0X0T1RlLu2QeTlihOXFTPquZ1aNgnx8xnL0Gy1GhBTlh6xY32k/ikLqf4u353LMctf43IZg6P8C5Aqmv3N+nKMrlOY7CzB5f3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2318.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(39850400004)(136003)(376002)(396003)(9686003)(8936002)(8676002)(52536014)(478600001)(91956017)(7696005)(76116006)(2906002)(55016002)(5660300002)(26005)(4326008)(64756008)(316002)(186003)(66946007)(66556008)(33656002)(6506007)(66446008)(71200400001)(86362001)(6916009)(54906003)(66476007)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: PW2/trJ5EDlXQydHkZuAmBZ1Mwd801yvOIQVeiW/Xb1QsKpMj6aJ68+39blwWaTDwoyl1gCfWjdyKTQKB01EkGVATbV0dekSlUAbgWwk1DR+Z3KLw5dcPziWP/beh5dn0Eomk5eL7cVh9i4x2DRGqKqcJq0OMtw750O12KkzVfYGRHfLnDDhUG+w9E+OuPACJLdUYwGBp+Lwnr8Br/18IY292062TzyMdM/jklUsNfJ27SMXlu03AxcrxA8t6x/89Rr85ifZYHjEiwSvXO0ByWePJTly/FWfRyj80Ra4SJgCpo0So53xQwHlY/PU2vdRLgxgrFP/36tEBYav0NAQ6Jp2uttRGNV96KSiPXNUNVSpa2TbFa+pOldsEEnuAp4Mhabm81HyQYl49etxrPr9S1eINJaK20zyFikC5Kur3UMcH9bClBq59/l1Gd/8vistrkBQr62bu/UxdPLs7ELdfslhrMkucvSbhpzPs5xFIpvXppKjrN/fccGAKqqG/tdCHAKwf9mLYzHksanIV7odxcvlA5ZYYLkN4JofCUnCl5GnEju2Y5w29lnS2b+0r1KXRfV88Ttmx9CRmry5/Dj+MFLC1nGRkL1m1QNyihKN3a4G/baGMYOJtsuavcGP8wuaGdNZepci9/ka/oZA6zvE6I0HlYhI7XmlNN6Gc2sdgkIXuA3cYa/0/c1p1QLCdrpLwNtkFqSCc5CRzK5WZGnPPCAUPNsGjHcyisJL9C7RWuF3mzXW2oqL+AGlmGxA3rQXP05hX9D0wOyrilwMw7oA9SX1eI8bL+Y8404ZhbRqE2xKFGA2N8qGYU5XF9zPBT6IruGmC7wK0GHVTFaw6ZT5Sp+3J2HJX3hcJCQysbDn+1hAyvYmerLo2MYWqp30ZZtBCGqGWZ854m8MlRtMTORqrw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2318.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84f48b65-f342-4e02-d8bb-08d88ff86e38
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2020 21:40:43.4876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IoEYINsg7pFOMPFyoy3ZP4gPFSouiDTyaPoWN7TUAjsxnHrncoBivLIAF8zkKIrdxgP7e0hdg8qkmLq2t9bxjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1567
X-BESS-ID: 1606167645-893021-26518-9378-1
X-BESS-VER: 2019.1_20201123.1851
X-BESS-Apparent-Source-IP: 104.47.55.170
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228395 [from 
        cloudscan12-84.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lincoln Ramsay <lincoln.ramsay@opengear.com>=0A=
=0A=
When performing IPv6 forwarding, there is an expectation that SKBs=0A=
will have some headroom. When forwarding a packet from the aquantia=0A=
driver, this does not always happen, triggering a kernel warning.=0A=
=0A=
aq_ring.c has this code (edited slightly for brevity):=0A=
=0A=
if (buff->is_eop && buff->len <=3D AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {=0A=
    skb =3D build_skb(aq_buf_vaddr(&buff->rxdata), AQ_CFG_RX_FRAME_MAX);=0A=
} else {=0A=
    skb =3D napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);=0A=
=0A=
There is a significant difference between the SKB produced by these=0A=
2 code paths. When napi_alloc_skb creates an SKB, there is a certain=0A=
amount of headroom reserved. However, this is not done in the=0A=
build_skb codepath.=0A=
=0A=
As the hardware buffer that build_skb is built around does not=0A=
handle the presence of the SKB header, this code path is being=0A=
removed and the napi_alloc_skb path will always be used. This code=0A=
path does have to copy the packet header into the SKB, but it adds=0A=
the packet data as a frag.=0A=
=0A=
Fixes: 018423e90bee ("net: ethernet: aquantia: Add ring support code")=0A=
Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>=0A=
---=0A=
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 126 ++++++++----------=0A=
 1 file changed, 52 insertions(+), 74 deletions(-)=0A=
=0A=
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c=0A=
index 4f913658eea4..24122ccda614 100644=0A=
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
@@ -413,85 +413,63 @@ int aq_ring_rx_clean(struct aq_ring_s *self,=0A=
 					      buff->rxdata.pg_off,=0A=
 					      buff->len, DMA_FROM_DEVICE);=0A=
 =0A=
-		/* for single fragment packets use build_skb() */=0A=
-		if (buff->is_eop &&=0A=
-		    buff->len <=3D AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {=0A=
-			skb =3D build_skb(aq_buf_vaddr(&buff->rxdata),=0A=
+		skb =3D napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);=0A=
+		if (unlikely(!skb)) {=0A=
+			u64_stats_update_begin(&self->stats.rx.syncp);=0A=
+			self->stats.rx.skb_alloc_fails++;=0A=
+			u64_stats_update_end(&self->stats.rx.syncp);=0A=
+			err =3D -ENOMEM;=0A=
+			goto err_exit;=0A=
+		}=0A=
+		if (is_ptp_ring)=0A=
+			buff->len -=3D=0A=
+				aq_ptp_extract_ts(self->aq_nic, skb,=0A=
+						  aq_buf_vaddr(&buff->rxdata),=0A=
+						  buff->len);=0A=
+=0A=
+		hdr_len =3D buff->len;=0A=
+		if (hdr_len > AQ_CFG_RX_HDR_SIZE)=0A=
+			hdr_len =3D eth_get_headlen(skb->dev,=0A=
+						  aq_buf_vaddr(&buff->rxdata),=0A=
+						  AQ_CFG_RX_HDR_SIZE);=0A=
+=0A=
+		memcpy(__skb_put(skb, hdr_len), aq_buf_vaddr(&buff->rxdata),=0A=
+		       ALIGN(hdr_len, sizeof(long)));=0A=
+=0A=
+		if (buff->len - hdr_len > 0) {=0A=
+			skb_add_rx_frag(skb, 0, buff->rxdata.page,=0A=
+					buff->rxdata.pg_off + hdr_len,=0A=
+					buff->len - hdr_len,=0A=
 					AQ_CFG_RX_FRAME_MAX);=0A=
-			if (unlikely(!skb)) {=0A=
-				u64_stats_update_begin(&self->stats.rx.syncp);=0A=
-				self->stats.rx.skb_alloc_fails++;=0A=
-				u64_stats_update_end(&self->stats.rx.syncp);=0A=
-				err =3D -ENOMEM;=0A=
-				goto err_exit;=0A=
-			}=0A=
-			if (is_ptp_ring)=0A=
-				buff->len -=3D=0A=
-					aq_ptp_extract_ts(self->aq_nic, skb,=0A=
-						aq_buf_vaddr(&buff->rxdata),=0A=
-						buff->len);=0A=
-			skb_put(skb, buff->len);=0A=
 			page_ref_inc(buff->rxdata.page);=0A=
-		} else {=0A=
-			skb =3D napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);=0A=
-			if (unlikely(!skb)) {=0A=
-				u64_stats_update_begin(&self->stats.rx.syncp);=0A=
-				self->stats.rx.skb_alloc_fails++;=0A=
-				u64_stats_update_end(&self->stats.rx.syncp);=0A=
-				err =3D -ENOMEM;=0A=
-				goto err_exit;=0A=
-			}=0A=
-			if (is_ptp_ring)=0A=
-				buff->len -=3D=0A=
-					aq_ptp_extract_ts(self->aq_nic, skb,=0A=
-						aq_buf_vaddr(&buff->rxdata),=0A=
-						buff->len);=0A=
-=0A=
-			hdr_len =3D buff->len;=0A=
-			if (hdr_len > AQ_CFG_RX_HDR_SIZE)=0A=
-				hdr_len =3D eth_get_headlen(skb->dev,=0A=
-							  aq_buf_vaddr(&buff->rxdata),=0A=
-							  AQ_CFG_RX_HDR_SIZE);=0A=
-=0A=
-			memcpy(__skb_put(skb, hdr_len), aq_buf_vaddr(&buff->rxdata),=0A=
-			       ALIGN(hdr_len, sizeof(long)));=0A=
-=0A=
-			if (buff->len - hdr_len > 0) {=0A=
-				skb_add_rx_frag(skb, 0, buff->rxdata.page,=0A=
-						buff->rxdata.pg_off + hdr_len,=0A=
-						buff->len - hdr_len,=0A=
-						AQ_CFG_RX_FRAME_MAX);=0A=
-				page_ref_inc(buff->rxdata.page);=0A=
-			}=0A=
+		}=0A=
 =0A=
-			if (!buff->is_eop) {=0A=
-				buff_ =3D buff;=0A=
-				i =3D 1U;=0A=
-				do {=0A=
-					next_ =3D buff_->next,=0A=
-					buff_ =3D &self->buff_ring[next_];=0A=
+		if (!buff->is_eop) {=0A=
+			buff_ =3D buff;=0A=
+			i =3D 1U;=0A=
+			do {=0A=
+				next_ =3D buff_->next;=0A=
+				buff_ =3D &self->buff_ring[next_];=0A=
 =0A=
-					dma_sync_single_range_for_cpu(=0A=
-							aq_nic_get_dev(self->aq_nic),=0A=
-							buff_->rxdata.daddr,=0A=
-							buff_->rxdata.pg_off,=0A=
-							buff_->len,=0A=
-							DMA_FROM_DEVICE);=0A=
-					skb_add_rx_frag(skb, i++,=0A=
-							buff_->rxdata.page,=0A=
-							buff_->rxdata.pg_off,=0A=
-							buff_->len,=0A=
-							AQ_CFG_RX_FRAME_MAX);=0A=
-					page_ref_inc(buff_->rxdata.page);=0A=
-					buff_->is_cleaned =3D 1;=0A=
-=0A=
-					buff->is_ip_cso &=3D buff_->is_ip_cso;=0A=
-					buff->is_udp_cso &=3D buff_->is_udp_cso;=0A=
-					buff->is_tcp_cso &=3D buff_->is_tcp_cso;=0A=
-					buff->is_cso_err |=3D buff_->is_cso_err;=0A=
+				dma_sync_single_range_for_cpu(aq_nic_get_dev(self->aq_nic),=0A=
+							      buff_->rxdata.daddr,=0A=
+							      buff_->rxdata.pg_off,=0A=
+							      buff_->len,=0A=
+							      DMA_FROM_DEVICE);=0A=
+				skb_add_rx_frag(skb, i++,=0A=
+						buff_->rxdata.page,=0A=
+						buff_->rxdata.pg_off,=0A=
+						buff_->len,=0A=
+						AQ_CFG_RX_FRAME_MAX);=0A=
+				page_ref_inc(buff_->rxdata.page);=0A=
+				buff_->is_cleaned =3D 1;=0A=
 =0A=
-				} while (!buff_->is_eop);=0A=
-			}=0A=
+				buff->is_ip_cso &=3D buff_->is_ip_cso;=0A=
+				buff->is_udp_cso &=3D buff_->is_udp_cso;=0A=
+				buff->is_tcp_cso &=3D buff_->is_tcp_cso;=0A=
+				buff->is_cso_err |=3D buff_->is_cso_err;=0A=
+=0A=
+			} while (!buff_->is_eop);=0A=
 		}=0A=
 =0A=
 		if (buff->is_vlan)=0A=
-- =0A=
2.17.1=0A=
=0A=
