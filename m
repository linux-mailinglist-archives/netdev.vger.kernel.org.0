Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BC42B7427
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 03:27:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgKRC0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 21:26:49 -0500
Received: from outbound-ip24a.ess.barracuda.com ([209.222.82.206]:43922 "EHLO
        outbound-ip24a.ess.barracuda.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725790AbgKRC0s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 21:26:48 -0500
X-Greylist: delayed 2027 seconds by postgrey-1.27 at vger.kernel.org; Tue, 17 Nov 2020 21:26:43 EST
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175]) by mx4.us-east-2a.ess.aws.cudaops.com (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO); Wed, 18 Nov 2020 02:26:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FbHPcPJYFYdWk3bBc7NEf0Bu92WOWPMKA/NmWAT9paU8/LWfIcKYSGAYgrWOaivnHXadxAN41cCPLWlDeOY0z4WYwTzIABfVK2Rp6aBjUPMTKXY2/BvCZHjcS9XL0uKFxBzigqdLTAXPBFW9hRa90Xry+Jgx5bNr6QHTSdadpguDr9AOCf6wMTznBofx5joxlRHHc5TvIY4Lu+mAzmjml6ulMIA1gDcNneVBBhgbWWA+t9N39uPMp1MLUKmbAslAkNYYpNbHAVFPW6sldAIdzktWY3Ftn6zScGhd9D86BFUxd0ElHh/wYR/UUydXiL16mZfFXJFXANBmFVu8dQEHpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjOJ3ixApKYLyF9IN1uNkX57EwqNGvppEguiOiB7e5M=;
 b=b1Ejz7zfoW3XyLuxZlFabrP2sgFLha4WBH9Qj6xsvgcd2NQ6bho5HESQr3fT2x02KRfW5oSBrHXLwDtEG+RlRJMciFaYtp/2CJfrhZXaO6/is5t80NztPRaosRfcOdtciVaCI3hV0YxFW5S036OB54LndwdPrto2qGGy6u3dV+zXhHSFBxQvfj0UIvVie2XoS3Wc93DX+w3rwQHuMjeyvFgKkxtS2eRBA3D1UJMdUoVats9C2fXNbwIAyZ4MK91rwJOeLfJLOIaxR1RuOMgscdgLkmutQUC1Z5HgBEMfH1Ejt4o9x53uUe6Nk2t77hv0/6o4R9UEihOhhKEYUE/e9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=digi.com; dmarc=pass action=none header.from=digi.com;
 dkim=pass header.d=digi.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=digi.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qjOJ3ixApKYLyF9IN1uNkX57EwqNGvppEguiOiB7e5M=;
 b=LMOkGeuhjxiR+OV9DR3QUbicCeQOAjKGhmJsFx/yPGpEajRZxkeQLOJZVUVCcnHCV6NSX1SlU9UaK2Mji4Ym92DZ24W5rdambDeR8i2BwvuXqddJIzyJu3hMHYozpmFswhHFEvV64szTE2Yj7iejWHII6Z9WIOkY6NKyo4UQvbY=
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 (2603:10b6:910:44::24) by CY4PR10MB1942.namprd10.prod.outlook.com
 (2603:10b6:903:122::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3564.28; Wed, 18 Nov
 2020 01:52:49 +0000
Received: from CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197]) by CY4PR1001MB2311.namprd10.prod.outlook.com
 ([fe80::a956:bdc0:5119:197%6]) with mapi id 15.20.3564.028; Wed, 18 Nov 2020
 01:52:49 +0000
From:   "Ramsay, Lincoln" <Lincoln.Ramsay@digi.com>
To:     Igor Russkikh <irusskikh@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [PATCH] aquantia: Reserve space when allocating an SKB
Thread-Topic: [PATCH] aquantia: Reserve space when allocating an SKB
Thread-Index: AQHWvUcksksVLDpkhU+MIoNHoOO3dA==
Date:   Wed, 18 Nov 2020 01:52:49 +0000
Message-ID: <CY4PR1001MB23118EE23F7F5196817B8B2EE8E10@CY4PR1001MB2311.namprd10.prod.outlook.com>
Accept-Language: en-AU, en-US
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=digi.com;
x-originating-ip: [158.140.192.185]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b89206dd-aba4-46ff-256e-08d88b64a792
x-ms-traffictypediagnostic: CY4PR10MB1942:
x-microsoft-antispam-prvs: <CY4PR10MB194211E627C1A370B817CAB9E8E10@CY4PR10MB1942.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:195;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QG9HCC2UremGzU6qylxYrl7QNkWxhQRZjQWammsn0ap8huvvCCnQQn1dMIoW+l1i/pGZVnOy1bCElwn0l2lQTbnOHQP59zLgMCbKCsZrkn48Wf68f4lDPJ2tVyW6lRGP1/wl6y2lW3QhUAiMXsV0kcsKtz3aQpMlxCC2VKvX9MeGQtwlWkMq+Q0ya42Oz1qe/4ji4QjS9OsEM0PW3pgXCpuzRDNmgh9IDYqAExfxJfbJzchB1qn23cq7onHDuOAqvdhee0OR8gLh3UoExgt1LnvPb6D+xnbewd6auEN1FmQYGBMhsi6ZC9tVA6roCbxfRJPYbjCoS7KXh9n4cKnbcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR1001MB2311.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39850400004)(136003)(346002)(376002)(66556008)(6506007)(55016002)(110136005)(2906002)(66476007)(52536014)(5660300002)(9686003)(33656002)(316002)(26005)(71200400001)(66446008)(64756008)(186003)(45080400002)(91956017)(478600001)(66946007)(83380400001)(76116006)(8936002)(8676002)(7696005)(4001150100001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: wCjCv5IKdRzMLIJo9sKx0UlBzdeMmYh8HmoFC2p4hniFrur2Txrk4XFz+Fto9B0ZubFUPQGppz/ywQshNuDB+xK9N5uQd9b7YZZKL4YP83YlJRzCBqxtjEAT/REXFxWdhknEsvsxcmUsaUszCwWJ9b6+y/yN18CXdMq9+FaSa4qdsgnlo/dU7EjN8z6UyL/a6V24pF6xrlHx0VUpL6thuFj0rvWqTWUwmSPSCjOTUBvOhrJo1VzpzSbANB0pwRGsfq3161HXJYS0SquADC9VB8bLIddg2mznmt8QzQ0zseiBgw9KYh86+cCA+HudjvDVwYMq6ON64ZHAMfjnKmCNs9qdgyA/63LcErI0ZouZsz2uwRP1CydrnVSwYVy8dZtYserF+qF8tDDX0jrwZKJWjPjWhMonvkw7B6dTH6LTMjk70v7ViCLSLDoXM/h38eo3v2y7GFys6i5K9aST3XygRY9sjyfZq15gWDC+KxvVMR4fghxAorDpoa4MEJDj9gjqjNnioylwsOWaigZfHP2lmDC98vOQqWugWOM0Gi2BdhQ60r5jnjUKp9NvlIZ3RL8Mk19oFgHZGmdAd6JjzTJiqPZ0pzLd96V/0IgINk6E6De6qofm1gEM4fZe/1R+QjS0fFx39UBiJdUZA7uqHLf/rz+a7/Cm/tI5FbQVrPw/uB6Gh6WAJQuq3DCKDqlT/f7Sfdf4tRGuWpu28gJ+g81WC+or75GD5p1DSMH0Jpb8r6ave/FK3zhO3qUnGtw1d7nZdCc4OO6RCpL14+YvqdYGKVNGfGCnf20qZ3fvlI4REKgJKS0mUivtXdeP5rHLjVoc9H00mQfPVu4rC5x0Eeo0vIyEGB+IPbzi4i6BvG1czZRpiX4o4ikH9vUWSZajFJLc5p60KNmccXDA73RLKXKmLQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: digi.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR1001MB2311.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b89206dd-aba4-46ff-256e-08d88b64a792
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2020 01:52:49.5479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: abb4cdb7-1b7e-483e-a143-7ebfd1184b9e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lafP/Fzce5I/m5lCzGwuP5xKpsixsc5NCo+/6yPumWea7bgXDbMnKT+x6ohR+L/Txy9UG22SGRngypNnVJrChQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1942
X-BESS-ID: 1605666402-893006-31823-22598-1
X-BESS-VER: 2019.1_20201117.2109
X-BESS-Apparent-Source-IP: 104.47.58.175
X-BESS-Outbound-Spam-Score: 0.00
X-BESS-Outbound-Spam-Report: Code version 3.2, rules version 3.2.2.228268 [from 
        cloudscan13-77.us-east-2a.ess.aws.cudaops.com]
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
It was observed that napi_alloc_skb and other ethernet drivers=0A=
reserve (NET_SKB_PAD + NET_IP_ALIGN) bytes in new SKBs. Do this=0A=
when calling build_skb as well.=0A=
=0A=
Signed-off-by: Lincoln Ramsay <lincoln.ramsay@opengear.com>=0A=
---=0A=
=0A=
We have an Aquantia 10G ethernet interface in one of our devices. While tes=
ting a new feature, we discovered a problem with it.=A0The problem only sho=
ws up in a very specific situation however.=0A=
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
=A0 =A0 if (WARN_ON_ONCE(skb_headroom(skb) < hh_alen)) {=0A=
=0A=
It seems that skb_headroom is only 14, when it is expected to be >=3D 16.=
=0A=
=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] ------------[ cut here ]-----------=
-=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] WARNING: CPU: 3 PID: 0 at include/n=
et/neighbour.h:493 ip6_finish_output2+0x538/0x580=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] Modules linked in: xt_addrtype xt_M=
ASQUERADE iptable_filter iptable_nat ip6table_raw ip6_tables xt_CT xt_tcpud=
p iptable_raw ip_tables nf_nat_tftp nft_nat nft_masq nft_objref nft_reject_=
inet nf_reject_ipv4 nf_reject_ipv6 nft_reject nft_chain_nat nf_nat xfrm_use=
r nf_conntrack_tftp nf_tables_set x_tables nft_ct nf_tables nfnetlink amd_s=
pirom_nor(O) spi_nor(O) mtd(O) atlantic nct5104_wdt(O) gpio_amd(O) nct7491(=
O) sch_fq_codel tun qmi_wwan usbnet mii qcserial usb_wwan qcaux nsh nf_conn=
track nf_defrag_ipv6 nf_defrag_ipv4 i2c_dev cdc_wdm br_netfilter bridge stp=
 llc [last unloaded: nft_reject]=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] CPU: 3 PID: 0 Comm: swapper/3 Taint=
ed: G =A0 =A0 =A0 =A0 =A0 O =A0 =A0 =A05.4.65-og #1=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] RIP: 0010:ip6_finish_output2+0x538/=
0x580=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] Code: 87 e9 fc ff ff 44 89 fa 48 89=
 74 24 20 48 29 d7 e8 2d 4f 0c 00 48 8b 74 24 20 e9 cf fc ff ff 41 bf 10 00=
 00 00 e9 c4 fc ff ff <0f> 0b 4c 89 ef 41 bc 01 00 00 00 e8 d8 89 f0 ff e9 =
ee fc ff ff e8=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] RSP: 0018:ffffac2040114ab0 EFLAGS: =
00010212=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] RAX: ffff9c041a0bf00e RBX: 00000000=
0000000e RCX: ffff9c041a0bf00e=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] RDX: 000000000000000e RSI: ffff9c03=
ddf606c8 RDI: 0000000000000000=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] RBP: ffffac2040114b38 R08: 00000000=
f2000000 R09: 0000000002ec5955=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] R10: ffff9c041e57a440 R11: 00000000=
0000000a R12: ffff9c03ddf60600=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] R13: ffff9c03dcf24800 R14: 00000000=
00000000 R15: 0000000000000010=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] FS: =A00000000000000000(0000) GS:ff=
ff9c0426b80000(0000) knlGS:0000000000000000=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] CS: =A00010 DS: 0000 ES: 0000 CR0: =
0000000080050033=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] CR2: 0000000000a0b4d8 CR3: 00000002=
22054000 CR4: 00000000000406e0=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] Call Trace:=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0<IRQ>=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0? ipv6_confirm+0x85/0xf0 [nf_con=
ntrack]=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0ip6_output+0x67/0x130=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0? __ip6_finish_output+0x110/0x11=
0=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0ip6_forward+0x582/0x920=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0? ip6_frag_init+0x40/0x40=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0ip6_sublist_rcv_finish+0x33/0x50=
=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0ip6_sublist_rcv+0x212/0x240=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0? ip6_rcv_finish_core.isra.0+0xc=
0/0xc0=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0ipv6_list_rcv+0x116/0x140=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0__netif_receive_skb_list_core+0x=
1b1/0x260=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0netif_receive_skb_list_internal+=
0x1ba/0x2d0=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0? napi_gro_receive+0x50/0x90=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0gro_normal_list.part.0+0x14/0x30=
=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0napi_complete_done+0x81/0x100=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0aq_vec_poll+0x166/0x190 [atlanti=
c]=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0net_rx_action+0x12b/0x2f0=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0__do_softirq+0xd1/0x213=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0irq_exit+0xc8/0xd0=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0do_IRQ+0x48/0xd0=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0common_interrupt+0xf/0xf=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] =A0</IRQ>=0A=
2020-10-19 21:24:24 DEBUG =A0 [console] ---[ end trace c1cba758301d342f ]--=
-=0A=
=0A=
After much hunting and debugging, I think I have figured out the issue here=
.=0A=
=0A=
aq_ring.c has this code (edited slightly for brevity):=0A=
=0A=
if (buff->is_eop &&=A0buff->len <=3D AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {=
=0A=
=A0 =A0 skb =3D build_skb(aq_buf_vaddr(&buff->rxdata),=A0AQ_CFG_RX_FRAME_MA=
X);=0A=
=A0 =A0 skb_put(skb, buff->len);=0A=
} else {=0A=
=A0 =A0 skb =3D napi_alloc_skb(napi, AQ_CFG_RX_HDR_SIZE);=0A=
=0A=
There is a significant difference between the SKB produced by these 2 code =
paths. When napi_alloc_skb creates an SKB, there is a certain amount of hea=
droom reserved. The same pattern appears to be used in all of the other eth=
ernet drivers I have looked at. However, this is not done in the build_skb =
codepath.=0A=
=0A=
I believe that this is the ultimate cause of the warning we are seeing.=0A=
=0A=
I have created a patch to create some headroom in the SKB. The logic is ins=
pired by the igb driver. This was originally developed against Linux 5.4, t=
hen migrated to Linux 5.8. It has been tested on our product against both v=
ersions. The patch below was migrated to Linux master (some context changed=
, but otherwise it applied cleanly).=0A=
=0A=
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c b/drivers/net=
/ethernet/aquantia/atlantic/aq_ring.c=0A=
index 4f913658eea4..57150e3d3257 100644=0A=
--- a/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_ring.c=0A=
@@ -16,6 +16,8 @@=0A=
 #include <linux/netdevice.h>=0A=
 #include <linux/etherdevice.h>=0A=
=0A=
+#define AQ_SKB_PAD	(NET_SKB_PAD + NET_IP_ALIGN)=0A=
+=0A=
 static inline void aq_free_rxpage(struct aq_rxpage *rxpage, struct device =
*dev)=0A=
 {=0A=
 	unsigned int len =3D PAGE_SIZE << rxpage->order;=0A=
@@ -47,7 +49,7 @@ static int aq_get_rxpage(struct aq_rxpage *rxpage, unsign=
ed int order,=0A=
 	rxpage->page =3D page;=0A=
 	rxpage->daddr =3D daddr;=0A=
 	rxpage->order =3D order;=0A=
-	rxpage->pg_off =3D 0;=0A=
+	rxpage->pg_off =3D AQ_SKB_PAD;=0A=
=0A=
 	return 0;=0A=
=0A=
@@ -67,8 +69,8 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct =
aq_ring_buff_s *rxbuf,=0A=
 		/* One means ring is the only user and can reuse */=0A=
 		if (page_ref_count(rxbuf->rxdata.page) > 1) {=0A=
 			/* Try reuse buffer */=0A=
-			rxbuf->rxdata.pg_off +=3D AQ_CFG_RX_FRAME_MAX;=0A=
-			if (rxbuf->rxdata.pg_off + AQ_CFG_RX_FRAME_MAX <=3D=0A=
+			rxbuf->rxdata.pg_off +=3D AQ_CFG_RX_FRAME_MAX + AQ_SKB_PAD;=0A=
+			if (rxbuf->rxdata.pg_off + AQ_CFG_RX_FRAME_MAX + AQ_SKB_PAD <=3D=0A=
 				(PAGE_SIZE << order)) {=0A=
 				u64_stats_update_begin(&self->stats.rx.syncp);=0A=
 				self->stats.rx.pg_flips++;=0A=
@@ -84,7 +86,7 @@ static int aq_get_rxpages(struct aq_ring_s *self, struct =
aq_ring_buff_s *rxbuf,=0A=
 				u64_stats_update_end(&self->stats.rx.syncp);=0A=
 			}=0A=
 		} else {=0A=
-			rxbuf->rxdata.pg_off =3D 0;=0A=
+			rxbuf->rxdata.pg_off =3D AQ_SKB_PAD;=0A=
 			u64_stats_update_begin(&self->stats.rx.syncp);=0A=
 			self->stats.rx.pg_reuses++;=0A=
 			u64_stats_update_end(&self->stats.rx.syncp);=0A=
@@ -416,8 +418,8 @@ int aq_ring_rx_clean(struct aq_ring_s *self,=0A=
 		/* for single fragment packets use build_skb() */=0A=
 		if (buff->is_eop &&=0A=
 		    buff->len <=3D AQ_CFG_RX_FRAME_MAX - AQ_SKB_ALIGN) {=0A=
-			skb =3D build_skb(aq_buf_vaddr(&buff->rxdata),=0A=
-					AQ_CFG_RX_FRAME_MAX);=0A=
+			skb =3D build_skb(aq_buf_vaddr(&buff->rxdata) - AQ_SKB_PAD,=0A=
+					AQ_CFG_RX_FRAME_MAX + AQ_SKB_PAD);=0A=
 			if (unlikely(!skb)) {=0A=
 				u64_stats_update_begin(&self->stats.rx.syncp);=0A=
 				self->stats.rx.skb_alloc_fails++;=0A=
@@ -425,6 +427,7 @@ int aq_ring_rx_clean(struct aq_ring_s *self,=0A=
 				err =3D -ENOMEM;=0A=
 				goto err_exit;=0A=
 			}=0A=
+			skb_reserve(skb, AQ_SKB_PAD);=0A=
 			if (is_ptp_ring)=0A=
 				buff->len -=3D=0A=
 					aq_ptp_extract_ts(self->aq_nic, skb,=0A=
--=0A=
2.17.1=0A=
=0A=
