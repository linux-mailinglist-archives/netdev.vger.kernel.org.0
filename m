Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B70E52B9EB6
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 00:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726724AbgKSXxL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 18:53:11 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:58092 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726449AbgKSXxL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 18:53:11 -0500
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105]) by mx6.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 23:52:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FTOBFlMjlfyPE3D0WZflCvO66v9cG/M7pf5Vm+rIT1XwYJHNzApgP3bM0un8qjnCTcPZk6j+MwyP5jPjMbPnhmrtY84auyQkKZP2mqnHo7ho+Hy2KpDa4T+0OnVaUJx9viT82qyILSo8OzLciW2bjsKYrGQs6MYjYNQDAXuqGeioAjZ3F5KSw7xfR8ag2lkZ2KvoW7qCr90mhEI7bzkhooNW98K3c5w2+LEyeRqikbznOOo92XNZPg04oKGJbBQgzYFCSXGTrW3TM27mjgo0M2XQZzOP2GcsB1cnBuSl5aGKPdxgyUVsnYZ57Xh6sqjvSPOM4qnYqN55Qg82ab7+EQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcWeT6uiq9dXdrw+K85E+sYkS2/D5EmDD+a17jr28r8=;
 b=ZYowpmb3IrZQCixTjFSEqUlnDxqqS4Kr1tO2VQ78Sl9UeKwFlXCDInoLhSvrB4GufvWjGXl9Hc16JJe9gJ1V0/FngtmvrppaYGNUT134Cq2VQ3ra9YvnsoNJUJLg6+2rLc8RaEDQaaRqG7afisyUSf565PtvYMkOf2vTULt936qTLA+iRt9oh42bWpp+I1L3Y1ITCAxvJ85vt+R3lCVLa/Y5nLqYJCMO5PKHOyKN74Y1NQQdFtxXdK5Awh/M/Xs01rElyD5gtbux5NnoQ6XxAypAVybPCmfdUr8icO5QNrYYCWWVjW5IzRWYUdcoo9duhCxJ3a1i3iMZxGkjjyEWsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tcWeT6uiq9dXdrw+K85E+sYkS2/D5EmDD+a17jr28r8=;
 b=GBCbc5hT2Vyj5DzUcJgjl9kaw6ynKD0BJaQ60CeEVDNDi5P7zakNZi/BHEyZCNGL+5YkoSqmyZGkKP1Nt1l2QHWVJ3agfKsebyhOicJnuw2pSFlm9ciQbwaVo3K2iY/L3vu+Ufcq/fwjc96Hi5lyoPdGjrn40/0Qd3kN7nQOhV0=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR1001MB2087.namprd10.prod.outlook.com
 (2603:10b6:910:47::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.22; Thu, 19 Nov
 2020 23:52:55 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 23:52:55 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH v4] aquantia: Remove the build_skb path
Thread-Topic: [PATCH v4] aquantia: Remove the build_skb path
Thread-Index: AQHWvs8ZM2n6oge2KEC89hbATIw5VQ==
Date:   Thu, 19 Nov 2020 23:52:55 +0000
Message-ID: <CY4PR1001MB2311844FE8390F00A3363DEEE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119222800.GJ15137@breakpoint.cc>
 <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>,<20201119225842.GK15137@breakpoint.cc>
In-Reply-To: <20201119225842.GK15137@breakpoint.cc>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d2c004b5-1ec5-4436-f782-08d88ce63c4f
x-ms-traffictypediagnostic: CY4PR1001MB2087:
x-microsoft-antispam-prvs: <CY4PR1001MB2087507B6AE4A7357A48AAB8E8E00@CY4PR1001MB2087.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M06sX9dAqKvsLUW9KAQ2KpEZ6z2GVR7seeUCvgE2i4UwHazoeMwknNkwzInn2iKuM7kZhLg/3A2Z6DIUDD0732G9C/6IFeIAYoXO5zfhb4LGBTy+vXfg7s6gsKAOyiU6VJVbKgFEhV6tO6J2u26REO2wtqolYGieHKnteLTP/Zk9oe2AfP4RN1P0UHhVJwh2mXVMgA7Araqk/+qLbkELZ88qUPLakwU7So8Ectp9W1STVE6fUTL7S48cDcAwQnPQKoWxtkaZjRMtB+YASKgMtI2TJHhAkb6ydPIrzWMpKvmg42FuDhyFayHT2Iz3G5fC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(39850400004)(366004)(136003)(396003)(6916009)(66476007)(186003)(66946007)(64756008)(9686003)(76116006)(26005)(91956017)(52536014)(66446008)(86362001)(55016002)(2906002)(7696005)(5660300002)(478600001)(66556008)(83380400001)(6506007)(4326008)(54906003)(8936002)(33656002)(316002)(8676002)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OSaKtAh4TFQ0j2SYgR5/WKON/FZYkFCTLJfb00dEERJgLvlfTcAJtb2ybKrSptGzEvxZC3GjKwvhqrC7Br90dVdUtjwf1+kEPGo1hVcp3NBp9u2kMxLlk2tsyng+neCNN9d9EnpefkX6pMoO22+x/c4VrhlZBd8CjW9nMsyH/3pyplvMUvEvJLoTRKOCHWu6RgKVI100JGcjeQex0lrFAVwVl9pzZJxx9hHm6UKpLOHHmXK7zmjhyDDXpVP6BPJ/RyooigYKHS6egXfYAE7JO2TCgTB6XPPvKV+2smISU0LNuwQd7/P6vrFRCBK51PiNkk1pMIQxTSvpV8izjkXxFMmbcZzQSxJU+gbU+4yv0kCXJqHzdpXMdemUh0EaYIlgIw6KFl3R2+WaaUrd/j6bNQITQL3RC300Anijt+G5cSuvRRtvWqMZukhjt/gpVI63+RCOf0Wuz5HcK9EP+sc7UU0HZcPEy/DHz9ZSerTGvqM10yjCMySnbzkdZLJ4WrHAaR4y0auSZLFdXzW1kf2KpyBtkfKW9V+qlA6EnQxvXONdHhKypvVC9U7bMSOp2f0JpcZuEnijZogPyYUdjPYD0aI7NxBjlmnFRgkpa9axNDrUtgB2jqThHWVRKCHph1hpcDpBxoIkoVgzo++fcTqlthThhWVuK1Xm5q+Z3un8sg8S1qDPHMayUhSQhWmoeSyd/8oPnPnXTEg1Wd5u0hA3q0IZGBdb5etbO7SUhEbN/VcOsgegSsoXKCCzJc/7RHXLBQCnJdLe+srebggzZ/gr9ZfC32QNPF/LBFrAQ+cj+Rp9t4z37HT3qJ6RT7przM7FJc66NtWVtLv1SX60UzDcCjLYqr/bJMxLxiImJW+DOsyMn4JwqXSd3logiVmT1EP3ohucLSEYJ2wVoRB0UdAcYg==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2c004b5-1ec5-4436-f782-08d88ce63c4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 23:52:55.4236
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SRigNZ2hYPgL7npLT4aUWfaD9I6zmol4iPGUbgzt0E977L5q05g4JAMfAJbMfTeb8Sgz+/njen5iNqu4z8pwjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1001MB2087
X-BESS-ID: 1605829976-893010-28038-126-1
X-BESS-VER: 2019.1_20201119.2339
X-BESS-Apparent-Source-IP: 104.47.58.105
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228306 [from 
        cloudscan14-191.us-east-2a.ess.aws.cudaops.com]
        Rule breakdown below
         pts rule name              description
        ---- ---------------------- --------------------------------
        0.00 BSF_BESS_OUTBOUND      META: BESS Outbound 
X-BESS-Outbound-Spam-Status: SCORE=0.00 using account:ESS112744 scores of KILL_LEVEL=7.0 tests=BSF_BESS_OUTBOUND
X-BESS-BRTS-Status: 1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

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
Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>=0A=
---=0A=
=0A=
> For build_skb path to work the buffer scheme would need to be changed=0A=
> to reserve headroom, so yes, I think that the proposed patch is the=0A=
> most convenient solution.=0A=
=0A=
I don't know about benefits/feasibility, but I did wonder if (in the event =
that the "fast path" is possible), the dma_mapping could use an offset? The=
 page would include the skb header but the dma mapping would not. If that w=
as done though, only 1 RX frame would fit into the page (at least on my sys=
tem, where the RX frame seems to be 2k and the page is 4k). Also, there's a=
 possibility to set the "order" variable, so that multiple pages are create=
d at once and I'm not sure if this would work in that case.=0A=
=0A=
> This only copies the initial part and then the rest is added as a frag.=
=0A=
=0A=
Oh yeah. That's not as bad as I had thought then :)=0A=
=0A=
I wonder though... if the "fast path" is possible, could the whole packet (=
including header) be added as a frag, avoiding the header copy? Or is that =
not how SKBs work?=0A=
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
