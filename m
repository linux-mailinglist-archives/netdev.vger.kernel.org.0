Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1A3360B3F
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 16:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbhDOOAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 10:00:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:32287 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232004AbhDOOAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Apr 2021 10:00:48 -0400
IronPort-SDR: 3e/S5CX5EXoTTFnqwojpm691OMUFqAjIFovtPjKEHD+qe6NzSRWeWHEg6DvGQDOmpM/4cafBKk
 +YHIOawfELEg==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="181979342"
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="181979342"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2021 07:00:18 -0700
IronPort-SDR: qvQyKxfOvlpcXB61A6Pst1RpEScS4jY3K9YdgMuar+AkFsi4WrpEMi8JaCWvM5/hw1Q/KsMNdc
 T2PN25yx3ubg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,225,1613462400"; 
   d="scan'208";a="418750792"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga008.fm.intel.com with ESMTP; 15 Apr 2021 07:00:18 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 15 Apr 2021 07:00:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 15 Apr 2021 07:00:17 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 15 Apr 2021 07:00:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9k6Jg6nnuy0Mo0GTWQW0akV8hhwsCFMeW9KzXUmU2sZkU7t/uxRfDgcLlZAaMcRaZZ7HU+VPHbbiVcmK97Hw+4Ht/GT8pNsTOS9liyHNnrglA8Qs6zT/JMxP6hQxXc5sxaCzxYuwc3nliiIvGRlVK4cvueDlbt2ooJgDmdIPQM5+X8jrxJKBA549RlmNmG/kE1yzVNZq5Rw6oKwcXeLZ5YXw0UNJ+zKHXBFcK0Q29kp0C/kRyFzgXHKDO+1/Kw5Rnwh3/kSQnp7Fo5YT60qNP1JMMkC3nOeIlTmSmKtVRfBJqlXwNVkYidXwXcCFnqF3YxUFo+3vdiLCUwTmgxlBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNyyXaD93Smp9goQxReRPj5PGkvSFzVQk7F7ZG+issM=;
 b=jRc6I4xg6hDtOrMJwDyjDSQ2XPfDxuQ/L2vkbs0plO7eu/wUpltg+aQlz5gaI3/8OibWW8NjeSK8hL0QwBB0ljyWYciHeB01uF/GXgFwVC1Xz8YrVzlxug5MY40BQB2A0fd6uAMDTATlO8Zwhzbhspo1jo+w45jkiHQMDpB26jsJT1Iqn4Ftek/FySvw2FK3iwy51yybyoz8RwOYnXB3Oim5kV75TKGVszal62bDC7RQpzFlGiFuqbJOFj8V1r9Kpnn8KmCi0mr5572coL5heTCbZegWNY2K+yXHpa2AgTzqVjX/3xgllbYC3BunElU37EwhCZWi0WJ8oo5nf3BqDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aNyyXaD93Smp9goQxReRPj5PGkvSFzVQk7F7ZG+issM=;
 b=FWGx9bo+RS8ZzneWHklGJYom/oFaOpegVN0YUkqVb8wmn7UBShtVG+KgIhwPpiJJMsIrbiW7xQzeuXUpfrUHzpKDqOAl4nAkawspbbjXmrhPuePmUA9nCSPmeC06phNmunB0BCDPzhRUPrNTTs9L02O2cpKyut/V3KJYL5jSIVM=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB3082.namprd11.prod.outlook.com (2603:10b6:5:6b::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4020.18; Thu, 15 Apr 2021 14:00:16 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::dcb3:eed0:98d1:c864%7]) with mapi id 15.20.4020.024; Thu, 15 Apr 2021
 14:00:16 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Linux Next Mailing List" <linux-next@vger.kernel.org>,
        Thierry Reding <treding@nvidia.com>
Subject: RE: linux-next: manual merge of the net-next tree with the net tree
Thread-Topic: linux-next: manual merge of the net-next tree with the net tree
Thread-Index: AQHXMZ186TF2W0t9ZUeEw4jlxfyX4qq1muKA
Date:   Thu, 15 Apr 2021 14:00:16 +0000
Message-ID: <DM6PR11MB2780C0D45E70297CC5CE5423CA4D9@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20210415121713.28af219a@canb.auug.org.au>
In-Reply-To: <20210415121713.28af219a@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
authentication-results: canb.auug.org.au; dkim=none (message not signed)
 header.d=none;canb.auug.org.au; dmarc=none action=none header.from=intel.com;
x-originating-ip: [42.189.179.55]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31338fb4-fbfd-4a89-3792-08d90016cc2c
x-ms-traffictypediagnostic: DM6PR11MB3082:
x-microsoft-antispam-prvs: <DM6PR11MB308261E154FBBC001CD6EA74CA4D9@DM6PR11MB3082.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: DC2xjN1oZ6xY508UynfBrRUu9WWFSYxh6h7pRjPptcOeTZakYdaKFM2MiP7c1QS+fWUl54I/R2TJRfPIEzoGUUrwxJRmvkrAB3+PkyUCtaL0KPHkpBIRRY5gb10xWBxnLCHn6iDDey5Gv3LjrjrV0BNoiUu5qF/V9O8FsruHhgwk8skkhJKiZ5+tA6yIP+w3UhrCMloZ+1AeJd4G6asy1ynBiBZk8wghP3dHD2B7uDxU8IV4g+ooIdHaQzVc32ku1hTCY23s9DJAiUK/ljOl2IkO/illfLYFCHOjanKFUJYln5vwRf3DBVNuKb9FLuFckaFH9X1Q9OUBNmClmGSuIpIMubCRqW3in84KjFFWlHCoO/OJ61S46C22nkRVR00simp9uVD4m53FpVSLd9nqyphx7uInTX31cy6vM4upsTFxcjkqvQH+vgrHUCix9FovhRxxAabkKH1koDZOpBObMYfppExLJ1DZAs8UrzfK4HWGyCkeOrcEprW7v9TaFy0tFQL5kbkJ5wwRDxmNLCYvxLeFt/ojXpoUoeUq/PCzSZxBb7ixn320aAFhYD4vb43P+I96Kie4MANbQsDIviA3WXA5nj42tsbUptw4Bfy2JtaQZd8hjSBD4LX0RJEcFlJHK0+j8HJ+DCgpBDxeIX6zY1lmF+R+rKsWoTfTPZHpHI/sD+Nwfxu14+bZiZtlKn5X
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(136003)(376002)(4326008)(6506007)(966005)(9686003)(66476007)(66556008)(64756008)(66446008)(316002)(186003)(8676002)(76116006)(66946007)(86362001)(5660300002)(55016002)(26005)(478600001)(7696005)(8936002)(54906003)(52536014)(2906002)(122000001)(33656002)(38100700002)(71200400001)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?R1um6+1aUIxrJqD3qD0Lk2QR/BORu9rSaeGCpmFZ7btdUNJpyhkauR6cAvOz?=
 =?us-ascii?Q?eOOfN4d7PDhL8Frsx2RvPykD3bjWsfgJzn/vHfjyjNVBtsBKvMVcMsd5G3B+?=
 =?us-ascii?Q?ExGfabvXM6/RH0SfJa+D31FTxMD3kJKxkFmGMCR3aradv9v6kDIGxX3kdzs0?=
 =?us-ascii?Q?OgQTaZmGCSfx6u5bFtT5tIndZGXLv9AiKQW4szj2ZFme7bSzEnC9QWgbw6YC?=
 =?us-ascii?Q?WkyhNs8I64W15ByiTXSRSwpvqkzoylgptYDLFGx4gpAcoE7yhctZUt18RV6d?=
 =?us-ascii?Q?QXaJoyrbFKucOkGdHomgEjIkSJS2UbfV/HElnqJEBo/av0Kh3nu5bJqKo4JL?=
 =?us-ascii?Q?eiKXDpL96TTxiKV+bFeAnWOxKffiiX8KgOcrCtHBqjY/uQnxWlE0jfBCNjIX?=
 =?us-ascii?Q?jqYJPn423KXH3NSQscE6VGDBtmVufY8GILZJ0fsSEFJjir3BsvAXzAos45QF?=
 =?us-ascii?Q?JQwjGrPclfHvUklvKkbJR2h/aPk26DDvTwbyQ0R+rZ//McO4guzEk/y9dsOb?=
 =?us-ascii?Q?xQ1QJRWnN7hrbyBm4TW/Zzqwf4du9kJpR7AHCGFTAFWF0ZSck5fF8B3I2zzw?=
 =?us-ascii?Q?fqg4BcSt8mBpTuKYBfqNsr7eWDFq88yV9iuW/8W3UUZ8B/lbT6Ml2SYQkxTp?=
 =?us-ascii?Q?Y6OAtHhRlX7xBHEe9boPDU1kDKLga1he5MT5rfjJMQSMQ1TrhCyY8RNIJiqJ?=
 =?us-ascii?Q?MmhNWJYIZmbsVO1wbqxInBIN2ZNV1cgoCzxkJZIr1CHEa57wbgpYhH3A55qz?=
 =?us-ascii?Q?3amOanbnjpCQLm/0r9OUN8EWAU0EL1pv9iHqn3uDPoOZ6e2u6Y1rx8PDUZUK?=
 =?us-ascii?Q?rREmuBVHFnzXfHOjvW73QJPihDpC2B5NfqM6hrIw1wcmO6qNrUj+m9xjVjr/?=
 =?us-ascii?Q?AfsQNaf8FxvPY19cLRov7uui5i75ZhxwsceZ3bJoXZWvZs82/nkfMSwMJtWv?=
 =?us-ascii?Q?QFqQ9nHevvME//umlAxi84rluE2A+TrisQEGUcRqFeEl7C74lHtBUqBRSbHg?=
 =?us-ascii?Q?qJwsA+YmbPC0+o4Uf+D6tVUbKLfRjlWHDLv+cpiYJZg1bhmXj7UmnP4GPj5l?=
 =?us-ascii?Q?xMcCDLbMq2Acm+qJDdaj491u5kUJTEmt48W/GOrd62r6iX1jVpcRnYYmzBmf?=
 =?us-ascii?Q?7cRdKOYiDJqacrFsRP/NRnuQQr/4pfxeeaW0V88hnio4466W5df3793CWh3e?=
 =?us-ascii?Q?5K5mYY044og1ShuO6Eql8pLV5g8WBPhEtv2udS2e0qiQE5gnhIOLlQZtDfIB?=
 =?us-ascii?Q?P4D91htbvNot1fb7y33oFuint5CiOT0ABtJkAOquLyTGeY6AUE2PrPahTmHe?=
 =?us-ascii?Q?Jt8mqQEcB+3+vF6sXEF9L0pK?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31338fb4-fbfd-4a89-3792-08d90016cc2c
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2021 14:00:16.2677
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dLNwmf6z2f5nchAq1yRAiYesxI1+RrOtR2mAMGepcelcBVNhucjYdKqkxvi0Y0oaYgwlYMf7xsN1x5IWxYP4n6djANxzI6jF9+JXtdINLE8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3082
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>Hi all,
>
>Today's linux-next merge of the net-next tree got a conflict in:
>
>  drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
>
>between commit:
>
>  00423969d806 ("Revert "net: stmmac: re-init rx buffers when mac resume
>back"")
>
>from the net tree and commits:
>
>  bba2556efad6 ("net: stmmac: Enable RX via AF_XDP zero-copy")
>  de0b90e52a11 ("net: stmmac: rearrange RX and TX desc init into per-queue
>basis")
>
>from the net-next tree.
>
>I fixed it up (see below) and can carry the fix as necessary. This
>is now fixed as far as linux-next is concerned, but any non trivial
>conflicts should be mentioned to your upstream maintainer when your tree
>is submitted for merging.  You may also want to consider cooperating
>with the maintainer of the conflicting tree to minimise any particularly
>complex conflicts.

I check linux-next merge fix above and spotted an additional fix needed.
Please see below.=20


>+ /**
>+  * dma_recycle_rx_skbufs - recycle RX dma buffers
>+  * @priv: private structure
>+  * @queue: RX queue index
>+  */
>+ static void dma_recycle_rx_skbufs(struct stmmac_priv *priv, u32 queue)
>+ {
>+ 	struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
>+ 	int i;
>+
>+ 	for (i =3D 0; i < priv->dma_rx_size; i++) {
>+ 		struct stmmac_rx_buffer *buf =3D &rx_q->buf_pool[i];
>+
>+ 		if (buf->page) {
>+ 			page_pool_recycle_direct(rx_q->page_pool, buf-
>>page);
>+ 			buf->page =3D NULL;
>+ 		}
>+
>+ 		if (priv->sph && buf->sec_page) {
>+ 			page_pool_recycle_direct(rx_q->page_pool, buf-
>>sec_page);
>+ 			buf->sec_page =3D NULL;
>+ 		}
>+ 	}
>+ }

With https://git.kernel.org/netdev/net/c/00423969d806 that reverts
stmmac_reinit_rx_buffers(), then the above dma_recycle_rx_skbufs()
is no longer needed when net-next is sent for merge. =20


> -/**
> - * stmmac_reinit_rx_buffers - reinit the RX descriptor buffer.
> - * @priv: driver private structure
> - * Description: this function is called to re-allocate a receive buffer,=
 perform
> - * the DMA mapping and init the descriptor.
> - */
> -static void stmmac_reinit_rx_buffers(struct stmmac_priv *priv)
> -{
> -	u32 rx_count =3D priv->plat->rx_queues_to_use;
> -	u32 queue;
> -
> -	for (queue =3D 0; queue < rx_count; queue++) {
> -		struct stmmac_rx_queue *rx_q =3D &priv->rx_queue[queue];
> -
> -		if (rx_q->xsk_pool)
> -			dma_free_rx_xskbufs(priv, queue);

dma_recycle_rx_skbufs() is only called here.=20



