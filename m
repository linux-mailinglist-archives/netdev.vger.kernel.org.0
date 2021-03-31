Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517BE34F69F
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 04:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231743AbhCaC2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 22:28:41 -0400
Received: from mail-mw2nam10on2082.outbound.protection.outlook.com ([40.107.94.82]:6080
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232518AbhCaC2g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 22:28:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hI4CwAlJQRjsZL+uyKtRXPgUy+E/w25sokkQiKrUuzQzIsaFy+jPfdDVudpxZlZn7J7T90jPlAWmZErk9N3gOHAvK7rwOe8ZI3VL6ZPa7Bm2EbVtzS3OyjiW06WisnGHmik4nDBtr5WNZ511Cg7bHRLR041/0ZXLtGY/hmfRYDHO6+uxuFa1F1Bt+IWJe3cEQ+H4f8QKllkLczn9iqh8HKnjY7PbwhnLfCYPHgbQODzXiYYpZPlU3yFxbc0GPfKXC9HJfowjDNVfWHuatpXNCyDGfzB9rcMm/J8nevFFnJaUuA4t1CWyww+pU5VJ1cbrvalx/86KMWb+gTHwDSNR+Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs7FGchpQRg1bKuneaCQ/iQXJvOvIXjd39JEmUCelyk=;
 b=XVJentPq/m7ZqJb5AKVUcK0MuPprZL8sP7p0WDtXbiMQhllgCWSzUa+7Qh6mBIvsWCjvHuNm/sSsVva2Jbs73M4asgfAz4rB3W8POgbmmr9jeuyGBCIGlMfCslGeYD2HSjYtMKLIc8sYg+/JR/DKyCGWA+4QRyAJhE7EETGt5RWok2lAwaKRu8av3PeVJT5DPJBayCEE/ZxtgDzcc8y2jddQaFcgHjniK58kiqNAj0SUW+2PATp4ocEzMBm2C0+IcgMVWm4VT6eZnPmAFHS4Dop7Z897rFfdXPYAe+/DHfqeqIpqsVVY+BZc3LHCGE4svd/1IJFwWTTIekSYAskINg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Zs7FGchpQRg1bKuneaCQ/iQXJvOvIXjd39JEmUCelyk=;
 b=KfKLZA9FmTkIkOkPMEUvGRPUBJxZqbP6A4E5Yk8XFO4q/VSu+9Uf5X1kkdYcgWLFw6OYqyX9d5Zugxek8//yQm2oJtddvBo2Fw8EExiFDJhs5ChhLr+GlGbsL18Bp3jVauJ++IyvWxGrFRUmXTpw8mXpf38lYDwEFjxkK37FCH4=
Received: from PH0PR11MB5175.namprd11.prod.outlook.com (2603:10b6:510:3d::8)
 by PH0PR11MB5080.namprd11.prod.outlook.com (2603:10b6:510:3f::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27; Wed, 31 Mar
 2021 02:28:34 +0000
Received: from PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f]) by PH0PR11MB5175.namprd11.prod.outlook.com
 ([fe80::9429:4c5e:12c5:b88f%7]) with mapi id 15.20.3977.033; Wed, 31 Mar 2021
 02:28:34 +0000
From:   "Liu, Yongxin" <Yongxin.Liu@windriver.com>
To:     "brett.creeley@intel.com" <brett.creeley@intel.com>,
        "madhu.chittim@intel.com" <madhu.chittim@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Topic: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from
 suspend
Thread-Index: AQHXHIszik+p+ak4pEmcm07CmaDEcaqdcTsQ
Date:   Wed, 31 Mar 2021 02:28:34 +0000
Message-ID: <PH0PR11MB5175BAF6F45C7F862CD0A33DE57C9@PH0PR11MB5175.namprd11.prod.outlook.com>
References: <20210319064038.15315-1-yongxin.liu@windriver.com>
In-Reply-To: <20210319064038.15315-1-yongxin.liu@windriver.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4530f583-61d3-43d5-dddc-08d8f3ecaec9
x-ms-traffictypediagnostic: PH0PR11MB5080:
x-microsoft-antispam-prvs: <PH0PR11MB5080CEC88BD7B91462A4F148E57C9@PH0PR11MB5080.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: k+n74AIVJ7xd72+TmbvR+iT/fZzjMTh98DjKpJrhMZr0r2Dw/ooIgVwf/9Zx8gGrOfrNqzLl4Tb7gDM6ftXBmKDnXkpnta45rZFtNLpv1pFSxaaAat2fpnNONX7EZrnQCDhfbipfcxcMr51+KD2sUah+yaa/zE0DXC8j0hfRgjFfojt9bNfrVfN357eYzwUH4+NVz1V584vwQDosp9ipt3KXaUdA6nh/9QqCcho62odnAZ4pePjlqlqxPpWaK4lHiXpvQ+qQmh2csjiTV2QAr6YG7GkYgwxQ1UAGAX8lEMu7Vw3sz7RiPCt8wcNFuuEAE4a3K8U7HV7kgfjM2eKwpyrFrAihM2NjTkoh0u3oxTOWyLiuECgOaoe2MgqJMN8V7QnlZPLQxoB9TFkfbmcbKC3tlimX5ADIXintEIxhyKbkmRPMgD6idkg1QfvEeK9QmZeBzOz1LwTWx7kuanUlzLucIOUor1F/GGc2ZFqEKXL5eJXxkuLrLKvh8dB4Zc++HWMQmUotjuI56ZlXkF/5nk4VPxVfrtKtow3YY9wxkP5krVFNanerezT/JEvghRPXxIxPq4hUyFb9xPjTO274n7J4LoN+iXfILt4A21Nb8hHW0wxUkLNBoV4RTS77AFS6YaJKGBUGkXhpgxT0Ex7crnfUH2CjXC9O4DiStsB+m4s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5175.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(376002)(39850400004)(396003)(366004)(52536014)(7696005)(5660300002)(9686003)(26005)(38100700001)(4326008)(83380400001)(66476007)(186003)(55016002)(71200400001)(6506007)(33656002)(110136005)(76116006)(66946007)(66446008)(66556008)(86362001)(478600001)(64756008)(8676002)(316002)(8936002)(53546011)(15650500001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?0kRwca9O+g0gL1ZUUersLwxvxDfmCNBw/PwVMtLiMDkt+MkjqmXCQo+4N00U?=
 =?us-ascii?Q?jwJ1AnItp79QTEFFvgFL+3izYmw0xyP3gr2ISf/zkYWr3saRhKDg380scqsy?=
 =?us-ascii?Q?UNMbft9P6vaVIU/Oa7bvyBcMkr9iaFzFZVO/kyOaxW4a/K8bYEAl3qkkAS/r?=
 =?us-ascii?Q?X/0mL7u6O1rSdDLIy1eV8nG5BRGWEbdaQ4XztX40xue9IZR6HveMciXna7IA?=
 =?us-ascii?Q?cGGykg2dl0+hIjoFb5uME+HWSua1Ox3OPb4JzYtdQNd2AY5JcAugiV8rtsPc?=
 =?us-ascii?Q?dlKwMqJUCa+Jqr1HC04+gJ42JPiKsef9pBFWLpOpr6bRzCKPXTiXwRsUJH82?=
 =?us-ascii?Q?v1iYAxfGVYAbnIZtxiXne3HiBLgq2q7b1sGM+1ZFBV4xDpLA0pX2OV4hjeP6?=
 =?us-ascii?Q?XKGwDdcO/CumjKLah+RdmlYYp+xzL5L6Yc8cPhEXvSFhYfrnRnJrITtmNEuN?=
 =?us-ascii?Q?ZPDp8MuRNhFuVtH3yU9LhAcYfgXHHRUT7koggCWOikbSv8Yv+9gfToHsqRAU?=
 =?us-ascii?Q?MJmwhiiixgu0IOk6OIg7mDpK3g2JUOBa6jGO023wYb4u05VrB1AV0TPhLqnv?=
 =?us-ascii?Q?SIyVvYJfsBxLQ52OWzJU4CrzcA3W9VSgwjrV4jZsjKhHtw0F8YE333rdD+sw?=
 =?us-ascii?Q?ydBr7iM8jcqezC0YdDhro7GkNwxsUzMeyeMv2O5T4o50CQw3SGrrj37Htsnr?=
 =?us-ascii?Q?fXfbvqRZBV0LMHKOIPOVLuEotMRwoWcufNzceAbVDnOg8xmAvAl5YFvBS53o?=
 =?us-ascii?Q?5NTTlIHkyB6obSuRKr6gcyuhOKbqRtfyBMRLgiEe9l0tZRyOY7VYqq6qZEne?=
 =?us-ascii?Q?97tSbKNMmfoofoLTVCHvf3xOpBnDTkqfw0eXVuWVlJKQjq9YY33SG24uVbNG?=
 =?us-ascii?Q?mZwGZEZsYI3cIeG6CXvIXbqAcCM58AP6/YDDMeoqEA9MgtBkEUdHmZ2t+wLf?=
 =?us-ascii?Q?eHvsVO4pFSUokRyuteApC4Uw2ENXrhRZdRhfcmnOfGY9rihfdhMSUQEM5Vnb?=
 =?us-ascii?Q?itX+jSDlM6uTCxyL8SOP1bDxrbvc3cwj/aVBWH0EEphIIGyOAe496aD/cbkv?=
 =?us-ascii?Q?MZiPJWp/t+UQLBNXoPoCJzdX1tFFKMe0lshTjqcE3iFrTEGj+Uc/dynHsug+?=
 =?us-ascii?Q?NAWK/Ny2ptKI+jGH9wD12Ds2nlijC0Uwfl8iPAO+e0dW6pUlgY0zMNHfFbsb?=
 =?us-ascii?Q?QFSJuJ69NK9fh9GUjjoBwCEbkujnvJfA9JI1CdA5y5Nvi3oQ264ftj+X+ta2?=
 =?us-ascii?Q?zRYM6JkadJp0nZz7tWcMrtV4NQFPxxZiwdR9C9Nnz9c8Xt8+uqPw7O8zmurD?=
 =?us-ascii?Q?+xM=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5175.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4530f583-61d3-43d5-dddc-08d8f3ecaec9
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2021 02:28:34.1429
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1/2nYWagALkQIPJu7x03nstX5rhKxNT7fjz5XzH5oi8O6/smuL7Gk7AlT2gA3m46OoRg6DE9JLjthKndhkUKNp3gNhWrnVhfHA7EV4t/Hqc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5080
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Brett,

Could you please help to review this V2?


Thanks,
Yongxin

> -----Original Message-----
> From: Liu, Yongxin <yongxin.liu@windriver.com>
> Sent: Friday, March 19, 2021 14:44
> To: brett.creeley@intel.com; madhu.chittim@intel.com;
> anthony.l.nguyen@intel.com; andrewx.bowers@intel.com;
> jeffrey.t.kirsher@intel.com
> Cc: netdev@vger.kernel.org
> Subject: [PATCH V2 net] ice: fix memory leak of aRFS after resuming from
> suspend
>=20
> In ice_suspend(), ice_clear_interrupt_scheme() is called, and then
> irq_free_descs() will be eventually called to free irq and its descriptor=
.
>=20
> In ice_resume(), ice_init_interrupt_scheme() is called to allocate new
> irqs.
> However, in ice_rebuild_arfs(), struct irq_glue and struct cpu_rmap maybe
> cannot be freed, if the irqs that released in ice_suspend() were
> reassigned to other devices, which makes irq descriptor's affinity_notify
> lost.
>=20
> So call ice_free_cpu_rx_rmap() before ice_clear_interrupt_scheme(), which
> can make sure all irq_glue and cpu_rmap can be correctly released before
> corresponding irq and descriptor are released.
>=20
> Fix the following memory leak.
>=20
> unreferenced object 0xffff95bd951afc00 (size 512):
>   comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
>   hex dump (first 32 bytes):
>     18 00 00 00 18 00 18 00 70 fc 1a 95 bd 95 ff ff  ........p.......
>     00 00 ff ff 01 00 ff ff 02 00 ff ff 03 00 ff ff  ................
>   backtrace:
>     [<0000000072e4b914>] __kmalloc+0x336/0x540
>     [<0000000054642a87>] alloc_cpu_rmap+0x3b/0xb0
>     [<00000000f220deec>] ice_set_cpu_rx_rmap+0x6a/0x110 [ice]
>     [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
>     [<00000000d692edba>] local_pci_probe+0x47/0xa0
>     [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
>     [<00000000555a9e4a>] process_one_work+0x1dd/0x410
>     [<000000002c4b414a>] worker_thread+0x221/0x3f0
>     [<00000000bb2b556b>] kthread+0x14c/0x170
>     [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30 unreferenced object
> 0xffff95bd81b0a2a0 (size 96):
>   comm "kworker/0:1", pid 134, jiffies 4294684283 (age 13051.958s)
>   hex dump (first 32 bytes):
>     38 00 00 00 01 00 00 00 e0 ff ff ff 0f 00 00 00  8...............
>     b0 a2 b0 81 bd 95 ff ff b0 a2 b0 81 bd 95 ff ff  ................
>   backtrace:
>     [<00000000582dd5c5>] kmem_cache_alloc_trace+0x31f/0x4c0
>     [<000000002659850d>] irq_cpu_rmap_add+0x25/0xe0
>     [<00000000495a3055>] ice_set_cpu_rx_rmap+0xb4/0x110 [ice]
>     [<000000002370a632>] ice_probe+0x941/0x1180 [ice]
>     [<00000000d692edba>] local_pci_probe+0x47/0xa0
>     [<00000000503934f0>] work_for_cpu_fn+0x1a/0x30
>     [<00000000555a9e4a>] process_one_work+0x1dd/0x410
>     [<000000002c4b414a>] worker_thread+0x221/0x3f0
>     [<00000000bb2b556b>] kthread+0x14c/0x170
>     [<00000000ad2cf1cd>] ret_from_fork+0x1f/0x30
>=20
> Signed-off-by: Yongxin Liu <yongxin.liu@windriver.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/net/ethernet/intel/ice/ice_main.c
> b/drivers/net/ethernet/intel/ice/ice_main.c
> index 2c23c8f468a5..9c2d567a2534 100644
> --- a/drivers/net/ethernet/intel/ice/ice_main.c
> +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> @@ -4568,6 +4568,7 @@ static int __maybe_unused ice_suspend(struct device
> *dev)
>  			continue;
>  		ice_vsi_free_q_vectors(pf->vsi[v]);
>  	}
> +	ice_free_cpu_rx_rmap(ice_get_main_vsi(pf));
>  	ice_clear_interrupt_scheme(pf);
>=20
>  	pci_save_state(pdev);
> --
> 2.14.5

