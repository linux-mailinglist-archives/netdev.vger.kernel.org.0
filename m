Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0522B9D45
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726334AbgKSWBd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:01:33 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:50702 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726154AbgKSWBc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:01:32 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106]) by mx6.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 22:01:22 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T8bwgm0d28dI5b+zTlyWjAO54Qc95LdI5LQR2ZGTX16ocWeiShClrOsg0SmvogAIIw2nDyS6EKtPnxzJk6XEZLYnxYDw5PvQicqg59ahgITl18RX1XGrfgfzkvmsRR8t7vFn5YHp9JXIFBH+6L1QAolEFvHxlY5cEB4Nn/jMYdmkgkBrfIbsT/ovFt+4RZCLt5Rb+BHAm6+aNcspdBd8qaK4fnikt3a1BXFHNobBEgA+6vmc+v2ULNKj7mcEwJlyokxUJwpZldHb2beK+sLD8fDK9GLQjTvOK6kdwJYnknLEOhfWumnisVtN/gPlHbU72m5cUsYvheAalJ50JbGEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjRgySdq9eDI1ttICg88/SyLu/oUtjeDqk6MfY8OJv0=;
 b=jl39moGxpNtpC4aMik2Oc+E52xL1+hXxXYXMoSm4NzHP+2awHaKpCYfPlgbN7rr47TbKrakn56/55SYNB+jX9WAjP9GA/IxZokHxeON7KXoNAiQVp+5mrV8LCScKNjUfxibkYdsJzdQzeNGzg7vxREnm4lzI4rOmLK/hDKSolqL7kUq1zEGCEIO2t6BDq5AbZrdrGUOn/zgkNML2rsrQWqxDzq/P09KAsTbDzFKid2v5WhaX/FmAjDXnjFXHfmH3v+krnBkbhbMQvwY0RxdEvLrgV7IUfLfVO7SJOLNg9GUeCe47OX7twSWSY3Sue76yGvJQrGdiJAztqWs9EvB9qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjRgySdq9eDI1ttICg88/SyLu/oUtjeDqk6MfY8OJv0=;
 b=jiidD2CJQN4Lb0LhUu1vxLGCgFnUfIdwBYAIVJFk3y5GULLFllbwS+jm3IEYcHDJHfY6//J6duSEXuHsqpKI91/r16C8vRZoh5eTHwwTDqkr27KG6m2f2o0iWmds0JEnsnNM5hXNUlwSi66NdONQd8glPPQF6AP20gZv8CoTiNU=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR10MB1478.namprd10.prod.outlook.com
 (2603:10b6:903:2a::20) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 22:01:21 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 22:01:21 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH] aquantia: Remove the build_skb path
Thread-Topic: [PATCH] aquantia: Remove the build_skb path
Thread-Index: AQHWvr+D9OUe7+XJI0yBaR2s4ZL4BQ==
Date:   Thu, 19 Nov 2020 22:01:21 +0000
Message-ID: <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>,<2b392026-c077-2871-3492-eb5ddd582422@marvell.com>,<CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>,<CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
In-Reply-To: <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1fadea22-f843-4a66-46ab-08d88cd6a67e
x-ms-traffictypediagnostic: CY4PR10MB1478:
x-microsoft-antispam-prvs: <CY4PR10MB14787AEE4DD45604445A9C8AE8E00@CY4PR10MB1478.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O9gM6K+AtbE2z1DsvrXIa5f4o754aloDS3Do4yIQpas8Y11yWR6FTIp1I4q8bYXs6ZUGq6DXTam+grCakOnPRrpGtePjf6AAApRPdaaIyrMJQdboBi6FikAKawFGbQYT3RXDRViGzXZ5vdfxEIxDNl8z3qrjczvDGskzan+vjU2GkWJSHigS5zvB+uruyy4RTKjnCreYo4xquce3W09i6lCdCKHAe6SkzTchJWd/n2RUPefuHLwdBg1ckG4zVKK6mvek3GQRQer/iS7LKC5rcrbB79qyB8Fy1/zv0eYFZ4PoNqGgrX4rD0FqC8AONDrg
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39850400004)(376002)(366004)(346002)(136003)(396003)(6506007)(76116006)(66946007)(66556008)(64756008)(8676002)(66446008)(83380400001)(86362001)(5660300002)(52536014)(71200400001)(33656002)(316002)(66476007)(91956017)(110136005)(2906002)(8936002)(55016002)(478600001)(186003)(2940100002)(26005)(7696005)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: HfNiMVwvkh+4jXNL7j3FaILAv0JK4wfLu5Yu0la3jo70XL7kgM0nRWVjVZpdkzzJo6n4n8gl9uqPI5qst7AhJXRhDFZYrBMZzUAjsALUSxW9uV09lKwDokGCmV2KuH0VHKlcJB9aVIV78jW40C16Fs+tHua+f7pmXSsoQf0ewDlM0gN7y09t6QfueQnE35O2C4jAl9L8LKCrDcDQ+n9xTnmmhIFr87kCJ0xLp8NZc7OAGxpZHO+1tjSBDB+sfjWQ9O15k2nJLrJ25mxrcws1aGUKpaMwDW26acDd8z6MktW4g/v3ewDce8hMzjIbNCkt6S5Mrz4u8eGqcQKocJlbW7cicQVDY7Zg2mLI+DLCdRaJHnkG40EFDaYkel4Rm6lrKFTscQfS0V6gh1M0Hnpr6vluJe+w/IMQQgcD+gdRGHPmL8AUA3McPUGd5ryhLy94hATa36t+Q8y9fvo/8f+cOW7kl+LpbiU7QHxCM6YWPA0/EKD5CrIHmoxoEO9deKrhXV5DBQXxMypyGp7bS215DV3XIDxE/dRicUtXaYLy24MJgEHXyW0m1xn3N4Xoc0J7xbAbbz0qzuPlvWuOLzSR3o2nkmBWbJClNuRw0tzyhcyJlM9RL/xEewY7suhndlVu8RkzKqyFNkSUN+9CEJ3Aj7jLcJX7kRHbZkfCIoTERqBv7T1oPaS/F5nRL3FrGSTT5Dyy6ECqMyDuSW+TFzAmLdHh38eSJDPFdh/SloEdNYKx8eOEKhoJODSGcEzjwcd85iZs+rB8V3WzsXohGYna7hTiuax6KR1piZjOkqCgflo4mIbLErZTRY2dK0cy74u9q3jSOjyfc2xofjdMh80MDGs1ArSTXvYmoaY9lsnrdSVlWKwB7SgVtjweJ217FC5AN/B7Lv2QcNnrRGUJFErMWw==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fadea22-f843-4a66-46ab-08d88cd6a67e
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 22:01:21.6029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yvDns8rNRV5WZsqjXCiAzgIHgCfooIh4YDwUo9lFY1RYdVlSXdt1/TfAJIVZp0CDXOub627YLq9f1IRNCjbOHA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1478
X-BESS-ID: 1605823282-893010-4404-14451-1
X-BESS-VER: 2019.1_20201119.1803
X-BESS-Apparent-Source-IP: 104.47.55.106
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228306 [from 
        cloudscan17-107.us-east-2b.ess.aws.cudaops.com]
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
 .../net/ethernet/aquantia/atlantic/aq_ring.c  | 118 ++++++++----------=0A=
 1 file changed, 50 insertions(+), 68 deletions(-)=0A=
=0A=
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c=0A=
index 68fdb3994088..74f6f41b57e9 100644=0A=
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
@@ -385,79 +385,61 @@ int aq_ring_rx_clean(struct aq_ring_s *self,=0A=
 					      buff->rxdata.pg_off,=0A=
 					      buff->len, DMA_FROM_DEVICE);=0A=
 =0A=
-		/* for single fragment packets use build_skb() */=0A=
-		if (buff->is_eop &&=0A=
-		    buff->len <=3D AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {=0A=
-			skb =3D build_skb(aq_buf_vaddr(&buff->rxdata),=0A=
+		skb =3D napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);=0A=
+		if (unlikely(!skb)) {=0A=
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
