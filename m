Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C2343160E9
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 09:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhBJIYs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 03:24:48 -0500
Received: from mga12.intel.com ([192.55.52.136]:46132 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233982AbhBJIYk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 03:24:40 -0500
IronPort-SDR: PAWB4nz7/8OI1/1zclw0NyvG/cAqUewnuv1kHHaI/5jS9rqb+wM2Ujy1rq/dWWF3iL0GTgsMnm
 HqO9FHT1ZSXQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9890"; a="161182330"
X-IronPort-AV: E=Sophos;i="5.81,167,1610438400"; 
   d="scan'208";a="161182330"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 00:23:52 -0800
IronPort-SDR: ZJoaGQ3OPJGZI4KWHnzCaReuJ0hINkTCg/nXgep0Csuj/WpVnWYzUxmgMJCeylO7ziWiorYwDU
 BBsoMHGU6VnA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,167,1610438400"; 
   d="scan'208";a="578347599"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga005.jf.intel.com with ESMTP; 10 Feb 2021 00:23:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Feb 2021 00:23:51 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Feb 2021 00:23:51 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 10 Feb 2021 00:23:51 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.54) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 10 Feb 2021 00:23:51 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UJ02JJTqQ7NjNIdMHYVuqv5GdZOozCw79r/DUoo6Fa/oTv2zVjSUigPOqW5thmJ2/Le/Qu5W5qLYHCLEi7888X+Ob0lmVZsAeXwC0Dr951q0umho1//DnM+bwuYwsPAd7HSjechNC6a4D+nrfurpqAktfGPtjmTTgMmvjiCXU40qJbD/4uf3Wz8HAKEUtQ9S6819Q/ZU9Wx+IBPaig+Aw8U0ic5mHh3swcIKe43YEGRZuLRlw3dw0xoZoLipPP1dv+8RHhWjUjY+Blbbj1ykSb0hi52neDZtftDvuY6ItZyL3jxkrXbIWGVRLY0sQkpXcp6sf1eeKozEIy5HF04TPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuxbGAk3sf39yobKmE87SbYixCU94WppUjpWkslSSik=;
 b=laSC/hOHJ92/LfJS3M7UFwjST+FF+zeUTn/YsX0X2T1A87A2MZtQxHUMqf0J1du5C12fYsVXnzNa3zdi5YYvmBCcb3FlePEBSV49M7mbN7lVBDq1JvRbPfRp7Q01e2Ram4XYruWWrsJxVgp/B5+U6vpm1nCWgig19owU/CrOZI6nAYAex9FnI6TfNogtfVGlHOUHuTGIDzcUJsRfFXr5zCH+HPpuEBIue8ZtTnJt4fkc/3kz3lRNep3nrZgG9zLEFdxeCZnRTDraE0SpT028+G2fhanKvCMAPj4AVMeSUtmWqkjfJ3gdCrfypUFNEG6D9alEJJHKzmt04eQdIxAM/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IuxbGAk3sf39yobKmE87SbYixCU94WppUjpWkslSSik=;
 b=K4ClpmMoNJt9D85BhY2vsZtkzlJ80hNgtluTfF2+ahU51vCp33QuKcfiL922oaC2Bxw+lvgmZxGSZQlN29Mno6emAgfjvMsGXXzoKnzl6EkBFfC/ubUqj5rsauqDNB0beXQ+1hw4oxosrRwX4JG3eqqt/SyGWuJ3kVuHYb2NJGg=
Received: from DM5PR11MB1705.namprd11.prod.outlook.com (2603:10b6:3:e::23) by
 DM6PR11MB2795.namprd11.prod.outlook.com (2603:10b6:5:bf::24) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3825.19; Wed, 10 Feb 2021 08:23:50 +0000
Received: from DM5PR11MB1705.namprd11.prod.outlook.com
 ([fe80::8da3:628:1df2:db]) by DM5PR11MB1705.namprd11.prod.outlook.com
 ([fe80::8da3:628:1df2:db%10]) with mapi id 15.20.3825.031; Wed, 10 Feb 2021
 08:23:49 +0000
From:   "Sokolowski, Jan" <jan.sokolowski@intel.com>
To:     Pierre Cheynier <p.cheynier@criteo.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Topic: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion failed
 at net/ipv4/udp_tunnel_nic.c
Thread-Index: AQHW+Uqdc/IE4u4j8EOiyAzwHoyhlapFDuGAgAFmtOCAABlmAIAAC0UAgAARnACAB1XUAIADFjow
Date:   Wed, 10 Feb 2021 08:23:49 +0000
Message-ID: <DM5PR11MB17055BD7528EFFBE73C7B61C998D9@DM5PR11MB1705.namprd11.prod.outlook.com>
References: <DB8PR04MB6460F61AE67E17CC9189D067EAB99@DB8PR04MB6460.eurprd04.prod.outlook.com>
        <20210129192750.7b2d8b25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DB8PR04MB6460DD3585CE95CB77A2B650EAB59@DB8PR04MB6460.eurprd04.prod.outlook.com>
        <20210202083035.3d54f97c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <DM5PR11MB1705DDAEC74CA8918438EBA599B49@DM5PR11MB1705.namprd11.prod.outlook.com>
        <DB8PR04MB646092D87F51C2ACD180841EEAB49@DB8PR04MB6460.eurprd04.prod.outlook.com>
        <DB8PR04MB6460398CFCE47ADD5EE773E1EAB49@DB8PR04MB6460.eurprd04.prod.outlook.com>,<20210203090842.22e5ccb4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <DB8PR04MB64608A64EA7B4ABAC3A15EE1EA8F9@DB8PR04MB6460.eurprd04.prod.outlook.com>
In-Reply-To: <DB8PR04MB64608A64EA7B4ABAC3A15EE1EA8F9@DB8PR04MB6460.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: criteo.com; dkim=none (message not signed)
 header.d=none;criteo.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [109.241.79.187]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 95913a28-c46b-4340-f2fa-08d8cd9d31ab
x-ms-traffictypediagnostic: DM6PR11MB2795:
x-microsoft-antispam-prvs: <DM6PR11MB279569E142821912191A832C998D9@DM6PR11MB2795.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:389;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MSJ4ZEd7dQ+wY2pBqkAKByYPtrCvv/7tF4qbXT4g5uUn3lgmglqtmiUlPB8bUlvnx6q+pURwYnOHTpFNPtYXQ9nE/vNHjVzXBwLGkLlsXsFHW9Z4UHfPGj+xqBvq4JqFUvdj6KHUugjGHbgJT1dImwSw+nleWHBtptTcMdIzFhJySuzGr1As535hn7kI+sVT4UUmrRzGHsN64+hkVbRqBYBnDObwA1QU6vN6KLZPRPRfR8OqPPv2hoJWxaifH/INJ/xw/S4C6sVH+UmA3EHumYvfZAUo085ahAqiKAErTqXYxwW7TvqnF5GspH9ZoD/bK0yaqnswv7zPrXNhw2baQFlR8WWGdUYFhIAaPfmbAswHN79abDKo7OxaXYTg9BZvVwdOHniSpO7weiXnAk6IGej1nGL1SMfKYlmc/mPZpspwgAo0UmpiY4jn9DvIG/4VOc3V2eUhtUE4v+Lq39h0EReylGNvQAxOfXOeiqsmO4Cj/ZseJM/Dkn1Sn55XWzgJ58xKcQS70L/s9kxHFVarYw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB1705.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(376002)(136003)(396003)(366004)(39850400004)(71200400001)(4326008)(2906002)(8676002)(66476007)(110136005)(66446008)(64756008)(66556008)(54906003)(52536014)(6506007)(53546011)(33656002)(83380400001)(76116006)(4744005)(86362001)(478600001)(7696005)(5660300002)(26005)(8936002)(66946007)(9686003)(316002)(55016002)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?F/PsovxkXRlv/uHKaPQI464wFWPYh9NbBO5NVZTkJxO5OkpHdTgPrM/XZeNt?=
 =?us-ascii?Q?PdHRyuaP3mB6PoGlNQcnpjakokmOdkEBma7G0kmQCVajmyg3XEsyjeQg1mbR?=
 =?us-ascii?Q?WPzDwgrW0CW0KgKoNQ1LpygNcJbKaEkNa511cCvJHol98n4MtXXPPB8F7IdD?=
 =?us-ascii?Q?jMI6XdF5cBgT8w4uv+7wjeiR77h+3odva5xk02UrpIfWgfLCy3H2P0GdSMg8?=
 =?us-ascii?Q?5mQiYFa9EvAgb4DgK+PfgKMoHmt0Rzkds3F2UwbOBZTDkY/Geqkg+Bi0UqsC?=
 =?us-ascii?Q?KZJjBVJS+V3YHZQGpQl4t1ehESPdzrstWd6uDvw9QaCPx1Jv2Npa8NNHiSI+?=
 =?us-ascii?Q?nzvi4NtLh1T5Iq3UpdEz2AXROpneCEDN1wKS++jsYQ/xln5pMysV9HFbUk6A?=
 =?us-ascii?Q?aF8KBeQdVZA45JhaVADWrCBl+wEHMxxsU7DxevzqH9+e6zjquSDP4KePBaNv?=
 =?us-ascii?Q?eL71at4sC0pbgf+IMZMmJCvT5TfgSTH5eWT/rPlbGwlSgk2jfcdglMIZlKGR?=
 =?us-ascii?Q?MLskNsI6l2oS3AUmMbVlFyPOefXg2Z06xNqwCn/z0txjYyOwCoBJFYm2w1WH?=
 =?us-ascii?Q?yKC223SwnlVDauUplOoZOvhKhy9vf7/NXuva5HLseN5w27ymR6Az7OHC0zNn?=
 =?us-ascii?Q?Hd5Qx2KSt3exbQ/uPfhrEX24J4UOdZmV0ZmeL4gGCTeH1Z9Swl2vNiF7CeNP?=
 =?us-ascii?Q?GVftObgDIYW199dxnfsRWlooPNdkSy/My7ed7gOKHSG42PsM7T5tkh9AKCkM?=
 =?us-ascii?Q?7/DIRiOYMyt+V/mn94oa/HAEbKP6N2KzlwbxTwmJSa3RmL1wcpHXc5oj5eNp?=
 =?us-ascii?Q?sePFI//MwiwCSDL2L57CCsoRb3wYMIag+5AIqr8cj3lOEiTwzNLzqjuGyqUp?=
 =?us-ascii?Q?5vdMsIjIjHJ16/ticriNAFHRP4+z/YcKuurKDk2XIbjobFVNNWfhVp1Qrixs?=
 =?us-ascii?Q?6WVoNQLZ16r//OlG10Wyn5NgAWB41ECV/hrhl63e2IYpTmtGmdGSzK+s7nY8?=
 =?us-ascii?Q?yzNlsKhkUiaknv3hdbz21U1W/HAVg8PTjLlTsL9dkU/I018D84v2C91XfS9R?=
 =?us-ascii?Q?n+E9Xh/1MNxE8s+TM7qyj7t3xWAzqSNSvdiNsGVsKHE9KpN5FtnBWWW98uhH?=
 =?us-ascii?Q?tKwqOpHZHxtp6sRigx5R5bBuqxFpSjdrV2/a+eQLrJu390LOmyQEWUgYXJBn?=
 =?us-ascii?Q?n3wWVfAdQuYUQ9uoIyJOa3PMwpuYvssfYns4cvQ4HBdPAu4cbZfEVurmcrWm?=
 =?us-ascii?Q?7Uokrs8xL9WYcdoxQLcoQcGzWVHmD3ToenzHrRxv3HItenXrPP2KcVMJ0MQt?=
 =?us-ascii?Q?NNLQvXQ6ufRI732wKLfQ1nLA?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB1705.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 95913a28-c46b-4340-f2fa-08d8cd9d31ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 08:23:49.9117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iDac3Wj60s4Ke8VGIIT8pZpNJ8FgDqe4NSpt257uLRAd/LTWcFbTuTU+hevQGw+3nZG4qzxl1ZnlDQpnGHEopGVmb1cRfCrkkqOVX9N+n7k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2795
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Issue has been reproduced and is under investigation, once we get more info=
rmation/potential fixes, we'll contact you again.

Jan

-----Original Message-----
From: Pierre Cheynier <p.cheynier@criteo.com>=20
Sent: Monday, February 8, 2021 10:10 AM
To: Jakub Kicinski <kuba@kernel.org>; Sokolowski, Jan <jan.sokolowski@intel=
.com>
Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org
Subject: RE: [Intel-wired-lan] [5.10] i40e/udp_tunnel: RTNL: assertion fail=
ed at net/ipv4/udp_tunnel_nic.c


On Wed, 3 Feb 2021 18:08:31 +0100 Jakub Kicinski wrote:
> Yup! I'm pretty sure it's my conversion. The full commit quote upstream:
>=20
> 40a98cb6f01f ("i40e: convert to new udp_tunnel infrastructure")
>=20
> It should trigger if you have vxlan module loaded (or built in)
> and then reload or re-probe i40e.
>=20
> Let us know if you can't repro it should pop up pretty reliably.

Not sure if this is under investigation on Intel side, I can help to test p=
atches
or provide more info if needed.

--
Pierre
