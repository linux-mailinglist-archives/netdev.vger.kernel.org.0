Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3EC42B9D61
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:09:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbgKSWHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:07:18 -0500
Received: from outbound-ip24b.ess.barracuda.com ([209.222.82.221]:60668 "EHLO
        outbound-ip24b.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726390AbgKSWHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:07:17 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11lp2175.outbound.protection.outlook.com [104.47.56.175]) by mx6.us-east-2b.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 22:07:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KG3t9yU9luAVjYnPFNYpxv+gp/sm8tuCi7GAWrwi3KBnVJaAQvA1Tb+n2wpz3FhyIRA1v2ZG2OinDbVlwCtmnGmQGdtutmqQBfIdD3ZNZPqB4O7YJ+ir5Ie7zFvD4vbSs0XDnRNbhadUgz6ypHRmiVjF9uqxG61vqid9POy0LvBMAvvlP5Xco+UrypWSTBXqqFLh/Ai1aUhml2WqXKaCmm8gVbiihscYQN5wwtRH4j3b4D3MwUEUmD1+FACxZWXWw8iNij0nDyhO1HLugTfLSXLijgGmgEg0inw3OOrOe+LOYi0xbQCAtThvndGZBmzPias8L0/2fSxrbaQQOctpNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSyFSDxcPL3140NmyihV0XwZtkI0HuHWs96gzELUPns=;
 b=VeZ5aSx80w0PBJXftOqXT1YooxVcZOzHfZgXRrlCJSVGE0XCCNXln8ZlSeqCnPDyjREDhYyBfm3I8urZuaZFaR1ZOA6owKQnasCYixPrgb1WO//6rurNjxNPqwnYXl2yrgYkfYDSptB+w2ib+og162caZu0c/+8mgtRNo/eFVvOGEX9ajtJ4H6xYLQUSk3QbPHOnvak3Qr/naD7lm5std+9OgRN78pXQVhAUI/mNFqIcY3E+GI6V2HioA75hqz/rGlZIW3HBb7687TGMz22OBU1uWzJEMd200XdocdnF9a7KFkS/vkA7rbEkL+A6T/BrrDypfGh65ZL756twCU5Llg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bSyFSDxcPL3140NmyihV0XwZtkI0HuHWs96gzELUPns=;
 b=zehXVeAJE0/9OGb4b9R2mHTejw2GE4bVQYfbWrzBCso2QtP2edFYXOoqyBHH89y3EoI47Ow7llwtvW7dT7mPx2b00Qa6KZW1thfu6GCyzZq/m2/XGx2QhazJv6x8y8n8nI1lUF2SstiGe49xKfrDWwMhfr3Ux440uoWxhZWjGQ0=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR1001MB2088.namprd10.prod.outlook.com
 (2603:10b6:910:40::29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 22:07:02 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 22:07:02 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH v2] aquantia: Remove the build_skb path
Thread-Topic: [PATCH v2] aquantia: Remove the build_skb path
Thread-Index: AQHWvsBOsAmPkY/rTESqMk0pvOgIGQ==
Date:   Thu, 19 Nov 2020 22:07:01 +0000
Message-ID: <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>,<2b392026-c077-2871-3492-eb5ddd582422@marvell.com>,<CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>,<CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>,<CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
In-Reply-To: <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e83dc536-bbfa-4795-239a-08d88cd7717b
x-ms-traffictypediagnostic: CY4PR1001MB2088:
x-microsoft-antispam-prvs: <CY4PR1001MB2088179DD9B52B733C3C8531E8E00@CY4PR1001MB2088.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o5GhUiTA32/JgHl17jGqE0hOMAr5Qa0ySVeqhV0e6MJ4YiTEzA2A1NtLMAFp1umIrWO++NSD4SSU12U1B8xU38u9EyNcqhyYZjAEK+HblpesU4R9J3HuyNRUtLr0Y8Vvo7fsfDyxlJI7R+j/wP6zgeedmsk/6iAIKogAzFrBTfY+3zUb+kzUbgGHWIojeWm3RL2CdKygvBlgJBi4+BbqLGwA3uOknyyPm2FmCOZ5j/OE3/tsqQiZxpAC28x2Qd3zb9lXU+eLPGhKxxK8mmJxFpTdqhGjyY7rW733J905fRSEJhi0HnMV4HdLANkKq7cp
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(39850400004)(346002)(366004)(136003)(186003)(316002)(9686003)(2906002)(55016002)(6506007)(71200400001)(33656002)(7696005)(110136005)(5660300002)(52536014)(8676002)(8936002)(26005)(66556008)(64756008)(66446008)(66476007)(76116006)(66946007)(91956017)(478600001)(86362001)(83380400001)(2940100002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: Jktb7oSIFtZcGdC0HVs7gbsxo8aOb91pNAroUZiqoylEFY8X23Ljjh7EoE6s5RXzlyd/EEwlL1fBOKqM89J84krF7Dvh/8wTpoH81Ma+6oAVpZSJuZhfsEFU9r2KmXAhTa9gD4269Nb2Ev/170AgTh2/E4I1h5+qirXzkjO1gVqY3zmIWzqoJJ2FFIYU12teIdqlK86rW9iHTfXj+RVe1AL45Ym0uLEI/7Jlu94izs/DCC3vSJHjEBSMfKtI5wnn+uxARs+OdZOWj/1RDQAXJ/tmcZ/vNm7XS+LWuWUv6V6XLp8yUzdARtI1rWwdoP1wzMviMNhbqfZoN6cx9+Gj0pFao5Bxo4uBT/oiFO2v2d7Vd21vLj9bTT+ooB8zAbVkGuf9g13gO51MtTGQ70SKMEPHx1n+GYhX0CzNRenJHy9zr0JXxxCusCuSfLJ3zwCnXwy0Iek6IOpEndsFHTUPYSWhnfuJbrSuPTMwT2nVhl1wZ+JK4txQH4NGxGRQZyDvLBrXuRJ/pblF9gaO11hrCZkxLqanxRZlX6f1cWJU+2pZQresHYv6tgtkRGRqqZ2NEupgMKGvSRKLQTeDkZRJpmPLQWN5aCWRoezyQdXlAyM80f5NZrXHPjUmprzD6ennvKSEGsFnh+ggfxqsvVWsjo0ZyOg46C2EniqJ0USXWesot478Z6i9BOcvqLnRPKh0cxzsmTB3Vro4XgMrJkM7B5aUH8C6LO54424w7wVDJ05zNOF4Cbh2nNxwG72qIV2AxGQLWQFoNw+WIWbBe5y9c6y87sE4yhGN/lqwBORJLvnbRJaekaMJfm5sh/yA5t3YEv8ugkY8sCiI/XM403UCwzddoJIi2aW9TDHaYYydYvYl+A9CCY2WUY+o1VQ+2GkJu/m5muBXNjVfg70x8F+F+A==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83dc536-bbfa-4795-239a-08d88cd7717b
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 22:07:01.7540
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WMVuQrhfmr0HSbeK/UXPmW6hXfb3D4mtiWNW/otVEpalJLH1IgIf2VlSbk/f5ZH45ycH3eFSSGTr9NgimWQnMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2088
X-BESS-ID: 1605823627-893011-1329-14597-1
X-BESS-VER: 2019.1_20201119.1803
X-BESS-Apparent-Source-IP: 104.47.56.175
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228306 [from 
        cloudscan9-177.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The build_skb path fails to allow for an SKB header, but the hardware=0A=
buffer it is built around won't allow for this anyway.=0A=
=0A=
Just always use the slower codepath that copies memory into an=0A=
allocated SKB.=0A=
=0A=
Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>=0A=
---=0A=
=0A=
This patch is against the master branch rather than the 5.8 branch.=0A=
=0A=
=0A=
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 127 ++++++++----------=0A=
 1 file changed, 53 insertions(+), 74 deletions(-)=0A=
=0A=
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c=0A=
index 4f913658eea4..425e8e5afec7 100644=0A=
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
@@ -413,85 +413,64 @@ int aq_ring_rx_clean(struct aq_ring_s *self,=0A=
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
+					aq_buf_vaddr(&buff->rxdata),=0A=
+					buff->len);=0A=
+=0A=
+		hdr_len =3D buff->len;=0A=
+		if (hdr_len > AQ_CFG_RX_HDR_SIZE)=0A=
+			hdr_len =3D eth_get_headlen(skb->dev,=0A=
+							aq_buf_vaddr(&buff->rxdata),=0A=
+							AQ_CFG_RX_HDR_SIZE);=0A=
+=0A=
+		memcpy(__skb_put(skb, hdr_len), aq_buf_vaddr(&buff->rxdata),=0A=
+			ALIGN(hdr_len, sizeof(long)));=0A=
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
+				next_ =3D buff_->next,=0A=
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
+				dma_sync_single_range_for_cpu(=0A=
+						aq_nic_get_dev(self->aq_nic),=0A=
+						buff_->rxdata.daddr,=0A=
+						buff_->rxdata.pg_off,=0A=
+						buff_->len,=0A=
+						DMA_FROM_DEVICE);=0A=
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
