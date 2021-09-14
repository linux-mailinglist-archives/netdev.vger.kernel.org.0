Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67B9240B366
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234856AbhINPq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:46:27 -0400
Received: from mail-eopbgr70048.outbound.protection.outlook.com ([40.107.7.48]:23269
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231966AbhINPq0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 Sep 2021 11:46:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nZSID1+9UpJKBXpIOrErt7OmqMXPEICqF/0x5suK8jyTWxKvA+26+2TRxnxjMAxFr+cyu8tMLfnPrxRXG4WKg+lK1hozIfD35EfrGUTlxdIJzOp1mlB1TSTVgxhR0gSeDkVRDdeuSJMSJZ1UjECXy2hsbFj8M+EiOIKKNhF+bB8LNgpMKIYut/S9Kh7hGRsjasOPAMUYuBzvJhmvYiyjNwEOAVQGrfXYIyS8+lgryEFL7vCblVx/JSdbQbc6Te1GlBV438fOkd082EdZSApnNKbJsBspjWL2x9igCK9wo+HAgwmfLtMWN4gCHqViAv/5ZoBKid/DUnPuxi0DnrumUQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=/BihZkTMgoFD5Q/59rohWam4PiPa6+LP2jbTJfb/6BM=;
 b=Hr2WuW9B2AtlBC7KHG0gIMZ66UihEYd/wA4T4YKuxpMEB1EIzZpf+wzQ0LwcA5a+a9km09O5OwYVCuTENdR5ucEyozG9u0R/ZNxXUzRx48ge7Zk5sGwtmcrACVQE5S7L7iuUcTTHfk6szM2N8hwh3b7TZ1/VaqxaHvz5Tm6tvToRP2irbAMkbDFVziV/dEwveaqBdPGlTNz7uNaeTPDCj3S1fx4BogmwBnxXnoq1AU91ADnd+td0kBteHED/Dk1jNbIP2HfOxi0I8KZDWx1h13KhSyakjHxg36PG9uURHPJCTEBIGU9q0fs00eMCzySGYlALlIxHFm6lwETzeeSIWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/BihZkTMgoFD5Q/59rohWam4PiPa6+LP2jbTJfb/6BM=;
 b=N4Jdcv3+7nfGOqrV7y4pHzrWL6KWVOTipbwPbhstjReyIgC6UkmxwDvfD7BqI9TD6/rlYDxU87y8fPG+sx1llmpMxEb8R/c93bG86TbQZXZuOvhK21pq9tZlOa4HvTrCMs43T0BBc8ZVJIh1LO7X/iokhndq8ESS4Y8z5SE5p6U=
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 (2603:10a6:200:4f::13) by AM0PR04MB4209.eurprd04.prod.outlook.com
 (2603:10a6:208:62::26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Tue, 14 Sep
 2021 15:45:06 +0000
Received: from AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::94a4:6e18:e865:ea28]) by AM4PR0401MB2308.eurprd04.prod.outlook.com
 ([fe80::94a4:6e18:e865:ea28%12]) with mapi id 15.20.4500.018; Tue, 14 Sep
 2021 15:45:06 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Jeremy Linton <jeremy.linton@arm.com>
CC:     Hamza Mahfooz <someguy@effective-light.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Robin Murphy <robin.murphy@arm.com>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Dan Williams <dan.j.williams@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Thread-Topic: DPAA2 triggers, [PATCH] dma debug: report -EEXIST errors in
 add_dma_entry
Thread-Index: AQHXpSuO4AOhY9kToEi8I4sPqFaslaujtKEA
Date:   Tue, 14 Sep 2021 15:45:06 +0000
Message-ID: <20210914154504.z6vqxuh3byqwgfzx@skbuf>
References: <20210518125443.34148-1-someguy@effective-light.com>
 <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
In-Reply-To: <fd67fbac-64bf-f0ea-01e1-5938ccfab9d0@arm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: arm.com; dkim=none (message not signed)
 header.d=none;arm.com; dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4dc55791-f771-42d1-04aa-08d97796a010
x-ms-traffictypediagnostic: AM0PR04MB4209:
x-microsoft-antispam-prvs: <AM0PR04MB4209875ECF6E3E658AC26427E0DA9@AM0PR04MB4209.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0KjU1oty1CcF5+r5QXaLwSlV2OAziIFRBVjIOBgTADoA8XK4UJCQMqoe4CgZh0sO83GbGe87/kGDI3uLLj7+tf0kmW4m8jBG+KZ+2t5v2mTwYPFQX70J3/P47j6Ip/W7s2KQ7maWGW64rdH7wS5FLflEUb4nXkXLt0hNzBjGiw8alaN9ndSsKdVO1NJxHXlWUsuC2+jTUAsQBqt+AaTJN5kggpEv8SGfDpuGaHrfuWdWP3sr/xoV7TNoxRI8Jcr2p9y+cLUCgbpzsTOur4rYTLku5XWD89w1I+njIyG7m395MQNmTxO8O+NA9UzloZhkBVKK/aBOCU+1rXctyEgqKuo5IiMjGF3aljKZ6B8TCBWDw7IxUamGmZaMuDHrht6RjlR7De5pfLJcvOQ08yDRIO176l0IJnbq6nNvL38zTuJz5CRuZXhnp9ldSQasRNdHHnlMsl8UZZS4Airjq7FytBvfdC72BDlP/TXMeqy8fuxRjX6OcBf58dm0AwLugm6vybNccM6lzXSY5Xd5z15h7szOGF4ecZQbd1MIUjYmCISUoniFqo2HagbKucEDNZ8IZh6F1obL4N7dro1I3C4KmhANCfZSi9kL5kwzqGfRhyJLNEl7p1pc+RiCwwtLD52++ZkEfTufiM050xYK90xqx+92coyCcVv5w9GIzzTwaqdyzTxGVe0iUgNUiZqneP6m/V5VVvGRPQKJxS5GaTfjcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM4PR0401MB2308.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(7916004)(4636009)(376002)(346002)(39860400002)(366004)(136003)(396003)(6486002)(9686003)(6512007)(66946007)(66476007)(64756008)(8676002)(53546011)(6506007)(8936002)(54906003)(316002)(478600001)(6916009)(38070700005)(44832011)(66556008)(83380400001)(66446008)(5660300002)(4326008)(86362001)(76116006)(71200400001)(122000001)(33716001)(38100700002)(26005)(186003)(2906002)(1076003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?hWpvh5FDNE/Rebn6ZXJdWZWw9C6nttRMJuuBlqiuQcScumZxy3ingjupYZ?=
 =?iso-8859-1?Q?iielugoIaSc/3hE+21KzuwShn2e2l/aOx1xJ99vsQgYJksvJhTaCwqsm1K?=
 =?iso-8859-1?Q?0yrEN1mQ55GcsKusMPbRga5P1wQlhkm/pmpR6qORiiC1SPP5ncj8EjBEs8?=
 =?iso-8859-1?Q?fNcZLOt+4POJ2ZkrHnYKomEqqz2mIPKOlt0umv3r2iC9RK7QUWxKC7K4zN?=
 =?iso-8859-1?Q?+3qRZ+CoxSo+nYVMItfoC9aKnfX89JUeNOF/rEzHiFLR7bXgyazLdmG4sz?=
 =?iso-8859-1?Q?MRLNVAvWCxOlrzhd91S0VDreeQ7+wkRJ3328vOpQYGYqjNIR3qvuu4f2JE?=
 =?iso-8859-1?Q?EcpKLa1BDbuvgnQhgMBxH8QZeuGH30xQAO5/SStOn8d+AFGOn2Wh1Q7vra?=
 =?iso-8859-1?Q?hDV26QjxZtCniZzwgiM+s+hvkZsD+BZWGRsKWKW8WoAt4FmgTS3/RLNgzY?=
 =?iso-8859-1?Q?+8hMtCQuIvd/Uc8HeNEk9pclpr+4oDg6IjY36qjhcyQuIJ43xwknRnZt5D?=
 =?iso-8859-1?Q?mSdJi5LLz7D06tx7jTDXjkGna/CAjzMgfZEQ0miCkX8aQzjILBeIGx+wdU?=
 =?iso-8859-1?Q?rMb7fJXdFHIg5z9Uj5LtL88avjxcPhBwprVpkb+/ZIQSPU1JvZ+RnDAt7d?=
 =?iso-8859-1?Q?d8DVbwbTwPZZhRE1I9E3+r4xVujqCqLoSfLUpTseKSsiftM5aHsvrSMz7G?=
 =?iso-8859-1?Q?oM/flpMQ8p6Qr08K5JORd7Qc4FRq102O4Wd+y8LxJrynU4Pdt1onyWfFwW?=
 =?iso-8859-1?Q?sJdCo+YWLpQNIVrmFaBq6hiAiz++3Z9Fzs2k+5VPEp1P7LyjRqeQSk/m+2?=
 =?iso-8859-1?Q?SN+13y/0DG+WvY4ecW+7dyD9wltJhQFTpvKNyws9EpMrHiChQ1eOd/w1rQ?=
 =?iso-8859-1?Q?sNoqPe1AJgtJj6vJ8Kr9WE3oKknEUhXr9r4rjqPqE0krdrPQCg1wgOTA+Y?=
 =?iso-8859-1?Q?pu4QPQUm/at5w8/5NToPg6DvIj0GsMobh3IhHrKxkoSLEnhXorRjH0MgV7?=
 =?iso-8859-1?Q?heen6mBf6oBJxXRor0tZYfLoZvTY29lpd4Ey2P/L9uJnXbfJzEDIYHSMDA?=
 =?iso-8859-1?Q?1Bqf61smDyzPpPS4tk+FoKQgY5IGJ+a0LOZ2pzUeT7/JJlAGkbfO2DV0F8?=
 =?iso-8859-1?Q?tszoaHniYfJ2ho5XrLulb1NjEat2IwHjoM4ozT2/anr+reTy0tzDFf4pSh?=
 =?iso-8859-1?Q?IlhzkObq5hnUdgtUluId5y2o3TKkYCTNSf+gxtMmIG4V4qhVISjcuxkrwY?=
 =?iso-8859-1?Q?xcQlz66zW3GF/g3k282JxpekRN+9x4kDRXzFUWz2FU07MKlzuD753PYSjb?=
 =?iso-8859-1?Q?3qX8pIofxrHd0wXT9r7Fp1e8cJbRvACg0loNc4SASklc+Yp8PfDNCZCRAt?=
 =?iso-8859-1?Q?PyjZiVO69g?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="iso-8859-1"
Content-ID: <69110C2E0B60B24CA11DF8A1AECDC8AC@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM4PR0401MB2308.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4dc55791-f771-42d1-04aa-08d97796a010
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Sep 2021 15:45:06.2810
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pyxYqPXW7HU4XOnOksdncDJRLybHaIgfy9qWUQd/vq5dPTyJaUO+Wv1XCFITtVvbcptVcY0u2eNY8v6BS/VjAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4209
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 08, 2021 at 10:33:26PM -0500, Jeremy Linton wrote:
> +DPAA2, netdev maintainers
> Hi,
>=20
> On 5/18/21 7:54 AM, Hamza Mahfooz wrote:
> > Since, overlapping mappings are not supported by the DMA API we should
> > report an error if active_cacheline_insert returns -EEXIST.
>=20
> It seems this patch found a victim. I was trying to run iperf3 on a
> honeycomb (5.14.0, fedora 35) and the console is blasting this error mess=
age
> at 100% cpu. So, I changed it to a WARN_ONCE() to get the call trace, whi=
ch
> is attached below.
>=20
>=20
> [  151.839693] cacheline tracking EEXIST, overlapping mappings aren't
> supported
> ...
> [  151.924397] Hardware name: SolidRun Ltd. SolidRun CEX7 Platform, BIOS
> EDK II Aug  9 2021
> [  151.932481] pstate: 40400005 (nZcv daif +PAN -UAO -TCO BTYPE=3D--)
> [  151.938483] pc : add_dma_entry+0x218/0x240
> [  151.942575] lr : add_dma_entry+0x218/0x240
> [  151.946666] sp : ffff8000101e2f20
> [  151.949975] x29: ffff8000101e2f20 x28: ffffaf317ac85000 x27:
> ffff3d0366ecb3a0
> [  151.957116] x26: 0000040000000000 x25: 0000000000000001 x24:
> ffffaf317bbe8908
> [  151.964257] x23: 0000000000000001 x22: ffffaf317bbe8810 x21:
> 0000000000000000
> [  151.971397] x20: 0000000082e48000 x19: ffffaf317be6e000 x18:
> ffffffffffffffff
> [  151.978537] x17: 646574726f707075 x16: 732074276e657261 x15:
> ffff8000901e2c2f
> [  151.985676] x14: 0000000000000000 x13: 0000000000000000 x12:
> 0000000000000000
> [  151.992816] x11: ffffaf317bb4c4c0 x10: 00000000ffffe000 x9 :
> ffffaf3179708060
> [  151.999956] x8 : 00000000ffffdfff x7 : ffffaf317bb4c4c0 x6 :
> 0000000000000001
> [  152.007096] x5 : ffff3d0a9af66e30 x4 : 0000000000000000 x3 :
> 0000000000000027
> [  152.014236] x2 : 0000000000000023 x1 : ffff3d0360aac000 x0 :
> 0000000000000040
> [  152.021376] Call trace:
> [  152.023816]  add_dma_entry+0x218/0x240
> [  152.027561]  debug_dma_map_sg+0x118/0x17c
> [  152.031566]  dma_map_sg_attrs+0x70/0xb0
> [  152.035397]  dpaa2_eth_build_sg_fd+0xac/0x2f0 [fsl_dpaa2_eth]
> [  152.041150]  __dpaa2_eth_tx+0x3ec/0x570 [fsl_dpaa2_eth]
> [  152.046377]  dpaa2_eth_tx+0x74/0x110 [fsl_dpaa2_eth]
> [  152.051342]  dev_hard_start_xmit+0xe8/0x1a4
> [  152.055523]  sch_direct_xmit+0x8c/0x1e0
> [  152.059355]  __dev_xmit_skb+0x484/0x6a0
> [  152.063186]  __dev_queue_xmit+0x380/0x744
> [  152.067190]  dev_queue_xmit+0x20/0x2c
> [  152.070848]  neigh_hh_output+0xb4/0x130
> [  152.074679]  ip_finish_output2+0x494/0x8f0
> [  152.078770]  __ip_finish_output+0x12c/0x230
> [  152.082948]  ip_finish_output+0x40/0xe0
> [  152.086778]  ip_output+0xe4/0x2d4
> [  152.090088]  __ip_queue_xmit+0x1b4/0x5c0
> [  152.094006]  ip_queue_xmit+0x20/0x30
> [  152.097576]  __tcp_transmit_skb+0x3b8/0x7b4
> [  152.101755]  tcp_write_xmit+0x350/0x8e0
> [  152.105586]  __tcp_push_pending_frames+0x48/0x110
> [  152.110286]  tcp_rcv_established+0x338/0x690
> [  152.114550]  tcp_v4_do_rcv+0x1c0/0x29c
> [  152.118294]  tcp_v4_rcv+0xd14/0xe3c
> [  152.121777]  ip_protocol_deliver_rcu+0x88/0x340
> [  152.126302]  ip_local_deliver_finish+0xc0/0x184
> [  152.130827]  ip_local_deliver+0x7c/0x23c
> [  152.134744]  ip_rcv_finish+0xb4/0x100
> [  152.138400]  ip_rcv+0x54/0x210
> [  152.141449]  deliver_skb+0x74/0xdc
> [  152.144846]  __netif_receive_skb_core.constprop.0+0x250/0x81c
> [  152.150588]  __netif_receive_skb_list_core+0x94/0x264
> [  152.155635]  netif_receive_skb_list_internal+0x1d0/0x3bc
> [  152.160942]  netif_receive_skb_list+0x38/0x70
> [  152.165295]  dpaa2_eth_poll+0x168/0x350 [fsl_dpaa2_eth]
> [  152.170521]  __napi_poll.constprop.0+0x40/0x19c
> [  152.175047]  net_rx_action+0x2c4/0x360
> [  152.178792]  __do_softirq+0x1b0/0x394
> [  152.182450]  run_ksoftirqd+0x68/0xa0
> [  152.186023]  smpboot_thread_fn+0x13c/0x270
> [  152.190115]  kthread+0x138/0x140
>

I got some time to look at this and I am not sure if it's an actual
problem or not.

First of all, I added some more debug prints when any overlapping
happens so that I can actually see the entries.

[  245.927020] fsl_dpaa2_eth dpni.3: scather-gather idx 0 P=3D20a7320000 N=
=3D20a7320 D=3D20a7320000 L=3D30 DMA_BIDIRECTIONAL dma map error check not =
applicable=B7
[  245.927048] fsl_dpaa2_eth dpni.3: scather-gather idx 1 P=3D20a7320030 N=
=3D20a7320 D=3D20a7320030 L=3D5a8 DMA_BIDIRECTIONAL dma map error check not=
 applicable
[  245.927062] DMA-API: cacheline tracking EEXIST, overlapping mappings are=
n't supported

The first line is the dump of the dma_debug_entry which is already present
in the radix tree and the second one is the entry which just triggered
the EEXIST.

As we can see, they are not actually overlapping, at least from my
understanding. The first one starts at 0x20a7320000 with a size 0x30
and the second one at 0x20a7320030.

I wanted to see where these mappings are originating so I added some
traces around the dma_[un]map_single, dma_[un]map_sg operations in
dpaa2-eth.

I can see the following:
 - There are two S/G skbs being sent one after another (no cleanup of
   the Tx confirmation is done between, so not kfree or dma_unmap is
   happening).
 - Skb#1 has 3 frags and skb#2 just 2 frags.
 - The skb#1 3rd frag will get into the same cacheline as the skb#2 2nd fra=
g.

skb#1:

  245.926981:       dpaa2_eth:dpaa2_dma_map_sg: [eth4] scl=3D0x0xffff4cf3ac=
188200 num_sg=3D3
  245.926984: dpaa2_eth:dpaa2_dma_map_sg_entry: [eth4] size=3D0x42 dma_addr=
=3D0x20b66e58fe
  245.926987: dpaa2_eth:dpaa2_dma_map_sg_entry: [eth4] size=3D0x578 dma_add=
r=3D0x20ab9c7a88
  245.926989: dpaa2_eth:dpaa2_dma_map_sg_entry: [eth4] size=3D0x30 dma_addr=
=3D0x20a7320000
                                                                           =
     ^
                                                                           =
     |
                                                                           =
     |
      This skb frag will land in the same cacheline number with the 2nd fra=
g from skb#2.


skb#2:

  245.934933:       dpaa2_eth:dpaa2_dma_map_sg: [eth4] scl=3D0x0xffff4cf3ac=
188300 num_sg=3D2
  245.934936: dpaa2_eth:dpaa2_dma_map_sg_entry: [eth4] size=3D0x42 dma_addr=
=3D0x20b66e60fe
  245.934939: dpaa2_eth:dpaa2_dma_map_sg_entry: [eth4] size=3D0x5a8 dma_add=
r=3D0x20a7320030
                                                                           =
     ^
                                                                           =
     |

These frags are allocated by the stack, transformed into a scatterlist
by skb_to_sgvec and then DMA mapped with dma_map_sg. It was not the
dpaa2-eth's decision to use two fragments from the same page (that will
also end un in the same cacheline) in two different in-flight skbs.

Is this behavior normal?

Ioana
