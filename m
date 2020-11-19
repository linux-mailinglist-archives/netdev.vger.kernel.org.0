Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5BEC2B9DB3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 23:38:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgKSWfA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 17:35:00 -0500
Received: from outbound-ip23a.ess.barracuda.com ([209.222.82.205]:41602 "EHLO
        outbound-ip23a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726440AbgKSWfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Nov 2020 17:35:00 -0500
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105]) by mx11.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Thu, 19 Nov 2020 22:34:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j1ewx6EWjQhZ8QSk5DvSibpEheAv7IdO4g9g4pRDzhJ4eM+YTUU3Xec/wX6rRu88IrNwuwBkc6WVnNCxM9JQEhZyfhyM5GkUajTxkEtA0eFj3y1KTHPK/ukF1Fa/1ynyFRlASXhPINMmqVazdSYnTjLxHyrhlVlJEAQ+facLR5WMXMJudHBWBLOTyeeaUBg6nyF+SsSDKQXuG+VpD7qa31IXFIY72yNTk8Di2xw5heQ5SQBsQq0gEwTTII+i5OmEQ/bo6lCfBB05QUi//zjXAWN4cZNl0RUrJXGtFkDuvOm8apYo7NvMmTUVnELgc3G2IkwVWnimza3tpOLfW18WLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxPte5o3+8BBVumoYFgJcU6qUfcSWJg3YCTEbiA6iGo=;
 b=PW88eFZS09ksxMTNF1+cgk7spCeTb29DM7lvpDmXhRpa6fVck9DdieDs2WaGwQF1rMDurKxJhSMMUSydW7VdKV+5Uom5ngzbUCa7UA25XuvTOY/+TQgtkQ0ylQe9QbIVo/hUPXg5AIaNMqURcUumdCfmm19OUCKUMiLiMMmxLhPckDMLA9pn3rzYAM0NlH4lVPmRUbxfjJYBO7DHSkAmdvS0aZkAJRTTU+od2ipTJGGpDrn8kDMwXi85f+maD2o7PbAJgic8xEQyHoaMTo5FLZGygGtsfERKOZNVq5ZQw9AlfWdzY3j+TAEiNTxWy+lSY68u30zjYZnaBNqOMvydAA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HxPte5o3+8BBVumoYFgJcU6qUfcSWJg3YCTEbiA6iGo=;
 b=HUAr6ziOtbZ4hDx6MRPG1i/i8VQsNoaLHsYfiLIMeVTKQPyzgKYWRGWWv71KsGIS/9y2/AuHyWQ/rP3lHIfrZOvypNTnO31BX0lMmCTHDAkrVPUtDLoqREcvUYZDvf8zg2mazO12sCj6kTcFXfX8v8rd3HSeraCmjy+1RKI2QsM=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR10MB1605.namprd10.prod.outlook.com
 (2603:10b6:910:7::19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Thu, 19 Nov
 2020 22:34:48 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.033; Thu, 19 Nov 2020
 22:34:48 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Florian Westphal <fw@strlen.de>
CC:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dmitry Bogdanov <dbogdanov@marvell.com>
Subject: [PATCH v3] aquantia: Remove the build_skb path
Thread-Topic: [PATCH v3] aquantia: Remove the build_skb path
Thread-Index: AQHWvsQwAHVz25yaOUSGLD5tslvlZQ==
Date:   Thu, 19 Nov 2020 22:34:48 +0000
Message-ID: <CY4PR1001MB231116E9371FBA2B8636C23DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
References: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <2b392026-c077-2871-3492-eb5ddd582422@marvell.com>
 <CY4PR1001MB2311C0DA2840AFC20AE6AEB5E8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB231125B16A35324A79270373E8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311E1B5D8E2700C92E7BE2DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <CY4PR1001MB2311F01C543420E5F89C0F4DE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>
 <20201119221510.GI15137@breakpoint.cc>
 <CY4PR1001MB23113312D5E0633823F6F75EE8E00@CY4PR1001MB2311.namprd10.prod.outlook.com>,<20201119222800.GJ15137@breakpoint.cc>
In-Reply-To: <20201119222800.GJ15137@breakpoint.cc>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 08cd9fb6-ff4c-4fa6-865e-08d88cdb5293
x-ms-traffictypediagnostic: CY4PR10MB1605:
x-microsoft-antispam-prvs: <CY4PR10MB16053A2422A67F79DC4CC328E8E00@CY4PR10MB1605.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:843;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n2dvA2L5FQyRrbEn2d75JZ9nPjQxibRF7Etdp8WjU4YPjaa/9EItmpNabGGrJXWx1/6rj+3b8q/ajegWIOeT0VpLP0lXL7+DBoF0i46dXzrt/FZxs18tye6fNqhWiqkBQsqcqGiggfKRMn9ZmJl5o2C4uYSKGI1pjblPsl/r2obJjxxwp024pIlICRR2xf83FMQoK8qqtP0PEXAHzA6cyf9+vVsl4yQdMUCIHuQj5hfHSqyFW4aefgHvdTp3i4mjbUPcXLX1aIwJyxfy895l/24Vf04oPZM/x6t82W4bt4e7q7hKi6d0jSi9BoGOGiZmST1/0Xr7JCEnIvXBav/V/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(366004)(396003)(136003)(39850400004)(186003)(7696005)(316002)(478600001)(83380400001)(66556008)(4001150100001)(66946007)(52536014)(45080400002)(64756008)(54906003)(66446008)(66476007)(4326008)(5660300002)(8676002)(9686003)(86362001)(6506007)(76116006)(8936002)(55016002)(26005)(6916009)(91956017)(2906002)(71200400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: oz0OMjDBckZhi2dAhb1ZyJGJ6kNA1rBrd9EigcY4MeSN38Lgqogcr3YjSfAR4UJjXftlqkNlYj8WqKXRO2xgZECMQDIs9Flne8BAIY88KS3CJ71tgkA8quuIlLapUpMFPJUzzn+kOZamQzhVdygaKbAHoXGXpcF9jN2N+uXKOlWENPxaPoZ0hQpfQy4IOvO80xPrdgcOTIkF7fhFNOXIbTAOI4UcSKladaZHrryN9nlqbHXjh5xPB5wYmfDF+7prt5o3cr9wtnKf/DoVCMs3Irj6KK8JKgNJYy10QUJnZK79am/wA7lqct4shRwHknbUvCAJJn6gSjxBmtHI1p8kVZ8eCQOdSS3Al27UHHhvPSuBSYloNqaMFr2GvpL/DyL8drUr+3C4DX7JMR+BpBang5+iQqNTcPgE9I2jMsx+7Ng7/oxLLHYOKVayJuwLHaysK0MEhMUG7gM5Mkszs13EzLMMWveIAjsH63+7vOtztBKuX9hVSIrd66+l4t7SC00d/IPFLvSwP/X8hI8DIFEc+yUXftJPaF1W+F1T8zT6NQ++EdvFDTCoZTduObReiebILh9Y0TLgEV/6Fqw3TE2PyoO+/gKDCNpwktgaYVX7D5Tbpxpmi2amk8HN5M4kmUCK2tUpXL8O0cBRED1teW8oTMjgy9zFf9HNqbfmfj1HrWeOFVKny7Fvr1CG4SRMm4tR8LfCyfNnZzFrdtJ8UZGqFhFzzrhHO/CBdc25bCNozZkVKZLljec3O1Lbbcr8UejyYijYz5eD7xRuB0ApJOSl9WZdlLzI+6POLUkmjXFhLobXt+PdeoRRRyeWugYiB1Bmn3j3uL2sor/T1c58iGqDFUE4UPPqW99KG7ytBgWS7eJeJp++fjXfX2oUCtrnYx8d/vg/ZExnMWO4BXsSzB7HpA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08cd9fb6-ff4c-4fa6-865e-08d88cdb5293
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Nov 2020 22:34:48.3341
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5KkQOzmP3kWx0jl8a08z5kHKaIvfpcNzuEq+qW54N/tlViJpadIVI3PwrZZv9mbfHosx5GQlDytv+dcw39ihg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1605
X-BESS-ID: 1605825289-893020-10234-16747-1
X-BESS-VER: 2019.1_20201119.1803
X-BESS-Apparent-Source-IP: 104.47.70.105
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228306 [from 
        cloudscan11-229.us-east-2a.ess.aws.cudaops.com]
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
The build_skb path fails to allow for an SKB header, but the hardware=0A=
buffer it is built around won't allow for this anyway. Just always use the=
=0A=
slower codepath that copies memory into an allocated SKB.=0A=
=0A=
Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>=0A=
---=0A=
=0A=
We have an Aquantia 10G ethernet interface in one of our devices. While tes=
ting a new feature, we discovered a problem with it. The problem only shows=
 up in a very specific situation however.=0A=
=0A=
We are using firewalld as a frontend to nftables.=0A=
It sets up port forwarding (eg. incoming port 5022 -> other_machine:22).=0A=
We also use masquerading on the outgoing packet, although I'm not sure this=
 is relevant to the issue.=0A=
IPv4 works fine, IPv6 is a problem.=0A=
The bug is triggered by trying to hit this forwarded port (ssh -p 5022 addr=
). It is 100% reproducible.=0A=
=0A=
The problem is that we get a kernel warning. It is triggered by this line i=
n neighbour.h:=0A=
    if (WARN_ON_ONCE(skb_headroom(skb) < hh_alen)) {=0A=
=0A=
It seems that skb_headroom is only 14, when it is expected to be >=3D 16.=
=0A=
=0A=
2020-10-19 21:24:24 DEBUG   [console] ------------[ cut here ]------------=
=0A=
2020-10-19 21:24:24 DEBUG   [console] WARNING: CPU: 3 PID: 0 at include/net=
/neighbour.h:493 ip6_finish_output2+0x538/0x580=0A=
2020-10-19 21:24:24 DEBUG   [console] Modules linked in: xt_addrtype xt_MAS=
QUERADE iptable_filter iptable_nat ip6table_raw ip6_tables xt_CT xt_tcpudp =
iptable_raw ip_tables nf_nat_tftp nft_nat nft_masq nft_objref nft_reject_in=
et nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_chain_nat nf_nat xfrm_user =
nf_conntrack_tftp nf_tables_set x_tables nft_ct nf_tables nfnetlink amd_spi=
rom_nor(O) spi_nor(O) mtd(O) atlantic nct5104_wdt(O) gpio_amd(O) nct7491(O)=
 sch_fq_codel tun qmi_wwan usbnet mii qcserial usb_wwan qcaux nsh nf_conntr=
ack nf_defrag_ipv6 nf_defrag_ipv4 i2c_dev cdc_wdm br_netfilter bridge stp l=
lc [last unloaded: nft_reject]=0A=
2020-10-19 21:24:24 DEBUG   [console] CPU: 3 PID: 0 Comm: swapper/3 Tainted=
: G           O      5.4.65-og #1=0A=
2020-10-19 21:24:24 DEBUG   [console] RIP: 0010:ip6_finish_output2+0x538/0x=
580=0A=
2020-10-19 21:24:24 DEBUG   [console] Code: 87 e9 fc ff ff 44 89 fa 48 89 7=
4 24 20 48 29 d7 e8 2d 4f 0c 00 48 8b 74 24 20 e9 cf fc ff ff 41 bf 10 00 0=
0 00 e9 c4 fc ff ff <0f> 0b 4c 89 ef 41 bc 01 00 00 00 e8 d8 89 f0 ff e9 ee=
 fc ff ff e8=0A=
2020-10-19 21:24:24 DEBUG   [console] RSP: 0018:ffffac2040114ab0 EFLAGS: 00=
010212=0A=
2020-10-19 21:24:24 DEBUG   [console] RAX: ffff9c041a0bf00e RBX: 0000000000=
00000e RCX: ffff9c041a0bf00e=0A=
2020-10-19 21:24:24 DEBUG   [console] RDX: 000000000000000e RSI: ffff9c03dd=
f606c8 RDI: 0000000000000000=0A=
2020-10-19 21:24:24 DEBUG   [console] RBP: ffffac2040114b38 R08: 00000000f2=
000000 R09: 0000000002ec5955=0A=
2020-10-19 21:24:24 DEBUG   [console] R10: ffff9c041e57a440 R11: 0000000000=
00000a R12: ffff9c03ddf60600=0A=
2020-10-19 21:24:24 DEBUG   [console] R13: ffff9c03dcf24800 R14: 0000000000=
000000 R15: 0000000000000010=0A=
2020-10-19 21:24:24 DEBUG   [console] FS:  0000000000000000(0000) GS:ffff9c=
0426b80000(0000) knlGS:0000000000000000=0A=
2020-10-19 21:24:24 DEBUG   [console] CS:  0010 DS: 0000 ES: 0000 CR0: 0000=
000080050033=0A=
2020-10-19 21:24:24 DEBUG   [console] CR2: 0000000000a0b4d8 CR3: 0000000222=
054000 CR4: 00000000000406e0=0A=
2020-10-19 21:24:24 DEBUG   [console] Call Trace:=0A=
2020-10-19 21:24:24 DEBUG   [console]  <IRQ>=0A=
2020-10-19 21:24:24 DEBUG   [console]  ? ipv6_confirm+0x85/0xf0 [nf_conntra=
ck]=0A=
2020-10-19 21:24:24 DEBUG   [console]  ip6_output+0x67/0x130=0A=
2020-10-19 21:24:24 DEBUG   [console]  ? __ip6_finish_output+0x110/0x110=0A=
2020-10-19 21:24:24 DEBUG   [console]  ip6_forward+0x582/0x920=0A=
2020-10-19 21:24:24 DEBUG   [console]  ? ip6_frag_init+0x40/0x40=0A=
2020-10-19 21:24:24 DEBUG   [console]  ip6_sublist_rcv_finish+0x33/0x50=0A=
2020-10-19 21:24:24 DEBUG   [console]  ip6_sublist_rcv+0x212/0x240=0A=
2020-10-19 21:24:24 DEBUG   [console]  ? ip6_rcv_finish_core.isra.0+0xc0/0x=
c0=0A=
2020-10-19 21:24:24 DEBUG   [console]  ipv6_list_rcv+0x116/0x140=0A=
2020-10-19 21:24:24 DEBUG   [console]  __netif_receive_skb_list_core+0x1b1/=
0x260=0A=
2020-10-19 21:24:24 DEBUG   [console]  netif_receive_skb_list_internal+0x1b=
a/0x2d0=0A=
2020-10-19 21:24:24 DEBUG   [console]  ? napi_gro_receive+0x50/0x90=0A=
2020-10-19 21:24:24 DEBUG   [console]  gro_normal_list.part.0+0x14/0x30=0A=
2020-10-19 21:24:24 DEBUG   [console]  napi_complete_done+0x81/0x100=0A=
2020-10-19 21:24:24 DEBUG   [console]  aq_vec_poll+0x166/0x190 [atlantic]=
=0A=
2020-10-19 21:24:24 DEBUG   [console]  net_rx_action+0x12b/0x2f0=0A=
2020-10-19 21:24:24 DEBUG   [console]  __do_softirq+0xd1/0x213=0A=
2020-10-19 21:24:24 DEBUG   [console]  irq_exit+0xc8/0xd0=0A=
2020-10-19 21:24:24 DEBUG   [console]  do_IRQ+0x48/0xd0=0A=
2020-10-19 21:24:24 DEBUG   [console]  common_interrupt+0xf/0xf=0A=
2020-10-19 21:24:24 DEBUG   [console]  </IRQ>=0A=
2020-10-19 21:24:24 DEBUG   [console] ---[ end trace c1cba758301d342f ]---=
=0A=
=0A=
After much hunting and debugging, I think I have figured out the issue here=
.=0A=
=0A=
aq_ring.c has this code (edited slightly for brevity):=0A=
=0A=
if (buff->is_eop && buff->len <=3D AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {=0A=
    skb =3D build_skb(aq_buf_vaddr(&buff->rxdata), AQ_CFG_RX_FRAME_MAX);=0A=
    skb_put(skb, buff->len);=0A=
} else {=0A=
    skb =3D napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);=0A=
=0A=
There is a significant difference between the SKB produced by these 2 code =
paths. When napi_alloc_skb creates an SKB, there is a certain amount of hea=
droom reserved. The same pattern appears to be used in all of the other eth=
ernet drivers I have looked at. However, this is not done in the build_skb =
codepath.=0A=
=0A=
I believe that this is the ultimate cause of the warning we are seeing.=0A=
=0A=
My original proposed patch followed a pattern used in the igb driver. Some =
extra space in the buffer was used to hold the SKB headroom. However, this =
is problematic because the hardware doesn't understand this and it may over=
write data. This patch removes the build_skb path entirely, avoiding the is=
sue. It was tested as a patch against Linux 5.8.=0A=
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
