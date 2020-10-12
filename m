Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D3528BF12
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 19:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404106AbgJLRfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 13:35:19 -0400
Received: from mga12.intel.com ([192.55.52.136]:55567 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389562AbgJLRfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 13:35:19 -0400
IronPort-SDR: RV7J9grb/JrUkBWv2laOmbGDEGNizoZC+Zlvhijyk6D/Koa7PHnT0ZHzxCsvuiNpxCDghUtMjO
 k4LEoe0x59CQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="145096800"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="145096800"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 10:35:17 -0700
IronPort-SDR: DOlezl2kJxZUvEeowcSZnVz92O60VwB/kWbtBluKKrYHpmwF72WeqOXUwk75IT4CIOhYqc13jQ
 F/fGgsI6af4Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="350823569"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga002.fm.intel.com with ESMTP; 12 Oct 2020 10:35:18 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 10:35:17 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 10:35:17 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 10:35:17 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 10:35:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OH95f3CIOr6ays19FMPtO3pQFWwYQBNPKwyvn94ZPtdj9PTuJI8hjqFTrcrAk8TgSpBDXGN2ppGLCOrSMK+ILkRF7CxGJW1d9vxJxdV44CSl9SM1ff80TxuEmIcDgFhkjcOVgm330BD//xCodmKEABXnpaewp630mkSg0xphMoEGyVzCtazxebEXlM8owfMdcvqZaE1TnrhNTsok6TuRUMrCWTLpJ40xm/+9tWlFGrZJI0znv6IizNhKWllL3yyNHu0tE8w78Y78fV59p/rr81c57fX/gDdd5inT+Cv9wdwjaHMw9FiilhoMhOy+uYylSQK8+xbLdjDjBUinyWw4FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OXOeDR6EEHLCncaUYiZ2ceegTFOZC/jDMbFuBD5cpU=;
 b=NjfttWnfcwa/d3tJRDyqEeEDzP5faVdSbovL4Y8hv3vvuHTmTg8Y5Uyoto0yXxGauatWhuw54F8XPsKXQASu9/1qRhatpQ1jiaIJuda98xDTzOQySFpm69iYvm2Lph+L27BCRGmii26jgk0T/lu1HFaMCejUTpdvLY1tc+tqo3IrA7PlAw0XCNlyjpFKKYApGDgoVWiJRkZ1zfwH1Od5aXJ3az/vIPRvETGd3RKuKBFAKkPScnwk1XEShAOaTnKno1O7LJB21pNakvvrqSuWbjtrv2CD2koeY4inyJd+2AWRk67wj6kkejVLa8daaeAbQH67qg1a7LNS8DgYUHj1gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0OXOeDR6EEHLCncaUYiZ2ceegTFOZC/jDMbFuBD5cpU=;
 b=hSKY82AgNmQAqIjjUq7sCWmQp5+/i8z+HiG70yalvU2lHlGcU94otn6HHFG6w8jJiDFim2YuDmRa8ctE1s8zMnSQaA7TFpBCrdpBOD5Fbocy8L079FzH3IYtnySn9cJOVMXiStvYX/ixfIHgErNlhuNzzZUfeY9609lnjNKcOTU=
Received: from DM6PR11MB2890.namprd11.prod.outlook.com (2603:10b6:5:63::20) by
 DM6PR11MB4628.namprd11.prod.outlook.com (2603:10b6:5:28f::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3455.21; Mon, 12 Oct 2020 17:35:11 +0000
Received: from DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::2472:44fe:8b1d:4c6c]) by DM6PR11MB2890.namprd11.prod.outlook.com
 ([fe80::2472:44fe:8b1d:4c6c%5]) with mapi id 15.20.3455.029; Mon, 12 Oct 2020
 17:35:11 +0000
From:   "Brown, Aaron F" <aaron.f.brown@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] e100: switch from 'pci_' to 'dma_' API
Thread-Topic: [Intel-wired-lan] [PATCH] e100: switch from 'pci_' to 'dma_' API
Thread-Index: AQHWXPpxrra0mqGDF0COOiJ1GQSDz6mUwFtg
Date:   Mon, 12 Oct 2020 17:35:10 +0000
Message-ID: <DM6PR11MB289001E5538E536F0CB60A1FBC070@DM6PR11MB2890.namprd11.prod.outlook.com>
References: <20200718115546.358240-1-christophe.jaillet@wanadoo.fr>
In-Reply-To: <20200718115546.358240-1-christophe.jaillet@wanadoo.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=intel.com;
x-originating-ip: [97.120.179.168]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 89829427-73f1-4e01-697e-08d86ed52ba6
x-ms-traffictypediagnostic: DM6PR11MB4628:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB462891B071AED320AAA549C7BC070@DM6PR11MB4628.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nsQU1QGzD6WkQ1a3hlqsiw/YB/NgLWwCzvJLp5pAI+M39eteucEJU9LlRP+OXIIhW9+demIsXLt/XGmEpua+NdOG3/mq/t1zxN8P9s8JqzdIw3/kQ1SKokq73+3bi/LBdIEEwt94ZidYnD+XJYaOimrQqnQK9bRlAZWGogdcTEhs2Vez1uAevV+xR+BhkwexcQkTx4qBt07725cy4ee1gbOoc7OymS8l3h8HlZKQvIl2ZwEvMvUaLem5qk3NcOyLl/aX4+h/Ru70dMRZwMQ0psUaGXhmvYHKRPCEYHgPBvorsYIxB4lXtZRzYJlYwjgCHe/X4dOPeBO1p0x6JMJSslPMCiQVBE/E+wTsf2Tf9KQs8kaVsEcPVR9IordHh7hrz4U7OTRSIa6BDue0PgalcBx9Qep6R1vPttpD00tLymk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2890.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(396003)(136003)(39860400002)(346002)(376002)(5660300002)(8676002)(966005)(9686003)(8936002)(4326008)(110136005)(86362001)(52536014)(478600001)(66946007)(66446008)(2906002)(55016002)(6636002)(64756008)(66556008)(316002)(54906003)(76116006)(66476007)(53546011)(186003)(71200400001)(33656002)(83380400001)(7696005)(26005)(6506007)(6606295002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: qZ7qstZpw2KVJcP16yPv2ff67xcdd9fcE/je66oN067p4yduLMFZmVjIxCKf6UWt9zrOy4ZQoyVXPojdqCEwqtuNJ9m1pxxb5Wgzdx+SnjU9mY2PWBbZEqDCi7meDC5bSGsdl9uxC0TEsBmNdNFpLnwiFZTZBXK2eWjGnpR/d+AwZqfLkxIz51rpoafJdd2sRfm/M+UPW3RitUxtTnh6wTyqS6tEEJMmRQUEqiTCnh4sDI5LswQPkSR0+3zwkugBJK69mt3cPJ1p/vDUWL9Vjpvu36Irc+Xh4EkybXryxQWD/am+1I6ZDqzbTB2jxNRrcQRhU2lvEcBqEGtsPGRJtKHu4jAMz8sr961J4p6zcxVJgxrb+F3W87XLuwE4OWKlUgx/PNhRmHuKEVrmkF2nsmz3UzACK6+dtl4guQnIp+xm3wy58Q+m5oJx8kS7Zp+1omoI88bXun//qHieU2dlRh92MLTLTBmAVKFCfYDCA+0Mq7Ah27nIliiJCrmdGGpUKemlZGYKO2iHpaPzGuV9+jeXfWbBQp/O615tYclBmIcmL9CXI60PeLzUn8CVfBEteJHZlsHIxFrdhHKeemYUSZ24ClcizKvbRTLP7tzYTw+v/JAt3jF//ShPxx1G2SCvnvTTj29/fja2JQcavLvqxg==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2890.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 89829427-73f1-4e01-697e-08d86ed52ba6
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 17:35:11.0531
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: G5SCO1wz6JHkr1M4A7Sga6Wp80xRc6VpDZwCNN1f12z3h8q6Rq1/1n6wPAc/k8z4J09eAxVYKwxwecPd+VhwzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4628
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Saturday, July 18, 2020 4:56 AM
> To: kuba@kernel.org; davem@davemloft.net; Kirsher, Jeffrey T
> <jeffrey.t.kirsher@intel.com>
> Cc: netdev@vger.kernel.org; kernel-janitors@vger.kernel.org; Christophe
> JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-lan@lists.osuosl.org=
;
> linux-kernel@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] e100: switch from 'pci_' to 'dma_' API
>=20
> The wrappers in include/linux/pci-dma-compat.h should go away.
>=20
> The patch has been generated with the coccinelle script below and has bee=
n
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
>=20
> When memory is allocated in 'e100_alloc()', GFP_KERNEL can be used becaus=
e
> it is only called from the probe function and no lock is acquired.
>=20
>=20
> @@
> @@
> -    PCI_DMA_BIDIRECTIONAL
> +    DMA_BIDIRECTIONAL
>=20
> @@
> @@
> -    PCI_DMA_TODEVICE
> +    DMA_TO_DEVICE
>=20
> @@
> @@
> -    PCI_DMA_FROMDEVICE
> +    DMA_FROM_DEVICE
>=20
> @@
> @@
> -    PCI_DMA_NONE
> +    DMA_NONE
>=20
> @@
> expression e1, e2, e3;
> @@
> -    pci_alloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
>=20
> @@
> expression e1, e2, e3;
> @@
> -    pci_zalloc_consistent(e1, e2, e3)
> +    dma_alloc_coherent(&e1->dev, e2, e3, GFP_)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_free_consistent(e1, e2, e3, e4)
> +    dma_free_coherent(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_single(e1, e2, e3, e4)
> +    dma_map_single(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_single(e1, e2, e3, e4)
> +    dma_unmap_single(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4, e5;
> @@
> -    pci_map_page(e1, e2, e3, e4, e5)
> +    dma_map_page(&e1->dev, e2, e3, e4, e5)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_page(e1, e2, e3, e4)
> +    dma_unmap_page(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_map_sg(e1, e2, e3, e4)
> +    dma_map_sg(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_unmap_sg(e1, e2, e3, e4)
> +    dma_unmap_sg(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_cpu(e1, e2, e3, e4)
> +    dma_sync_single_for_cpu(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_single_for_device(e1, e2, e3, e4)
> +    dma_sync_single_for_device(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_cpu(e1, e2, e3, e4)
> +    dma_sync_sg_for_cpu(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2, e3, e4;
> @@
> -    pci_dma_sync_sg_for_device(e1, e2, e3, e4)
> +    dma_sync_sg_for_device(&e1->dev, e2, e3, e4)
>=20
> @@
> expression e1, e2;
> @@
> -    pci_dma_mapping_error(e1, e2)
> +    dma_mapping_error(&e1->dev, e2)
>=20
> @@
> expression e1, e2;
> @@
> -    pci_set_dma_mask(e1, e2)
> +    dma_set_mask(&e1->dev, e2)
>=20
> @@
> expression e1, e2;
> @@
> -    pci_set_consistent_dma_mask(e1, e2)
> +    dma_set_coherent_mask(&e1->dev, e2)
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
> If needed, see post from Christoph Hellwig on the kernel-janitors ML:
>    https://marc.info/?l=3Dkernel-janitors&m=3D158745678307186&w=3D4
> ---
>  drivers/net/ethernet/intel/e100.c | 92 ++++++++++++++++---------------
>  1 file changed, 49 insertions(+), 43 deletions(-)
>=20
And I finally managed to get a couple functional e100 adapters up and runni=
ng again.
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
