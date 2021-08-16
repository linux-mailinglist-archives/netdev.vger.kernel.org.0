Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A1893ED241
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 12:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235837AbhHPKsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 06:48:54 -0400
Received: from mga05.intel.com ([192.55.52.43]:12972 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235841AbhHPKsy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 06:48:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10077"; a="301421602"
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="301421602"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 03:48:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,324,1620716400"; 
   d="scan'208";a="504848459"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 16 Aug 2021 03:48:22 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 03:48:21 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 03:48:21 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 03:48:21 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.170)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 03:48:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gq3vH46q/PNjmFsm/Y/dP0i3EKZ2jz7BXE4ZFiULGRN9TaNYNDMtRjehXij0Vdgurm0lyYYW9uMOcLVRWiSvv7WMzBCVbmSobZzFquFpnhEiGnn59lBuW0ShRlBnDElMjo+qm0Iv6Lp0VNraoXLQqbvze8jpkbix998DsL04MebTut31UYybfHbttfpegZfyCir0klcJ31jm90DmLryWSM7NkM+xLPBKsuFQCy9bRF15nQHnUbrCASBLyPpZceFEJ0ur4dNIJPHQqoHqNAWtSiWeCyeAIgP8EvjLZgGSrXbWWvd2We0p8/yyLXBSkbfiRZMWjkgb3zwmhJU74zIsxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BTzxvIhxQVL5Q12dU24953geElRMA4m+bKNJdu8iWc=;
 b=cFCdDIEBxELWJVFKteTPUwzxnlxxR8umGyY2Tjn0Vmbc/boOT4Nvbds/WajC564vlsQ835/xkKIrVYmsYzbKzsND1t+htt1Xl+VMpkbwU24yZNqUwJzfx3SqspkTdi++gBZAhV7dWLCOy0Glx0xOhQsIuKdClnMj9YcIdWqac4GGoeWJC+HoK8bw1fWriTlyw56n0Ph0cacsr3mpoZCNP87rm38y1XI1NeYZg9bntL0HoRGWSMKJQpKk+2qCZO/P/CZiY9UPSER0+RxlttiprOPMKb3kqD4YfG4LjXn6yzSlIWP6nrH9uQzY9OpwynD6eYrRMB4WqBO+AC5MoMiGiw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+BTzxvIhxQVL5Q12dU24953geElRMA4m+bKNJdu8iWc=;
 b=PZz5H4AH3xIPqOREGZvjFBFr0oF8SIVI3aBATuIkvD7fB/QJ/7SOoUOsnnPCtLPiQucrzlhya73Py3A8Fr/939U/WFilQHPMibDKuhK0ToeXnLZ/wUzor2RU4Oi0AY6KgHTMXGWfxuE+t2GpBl6CRotAFKsmSuujAZmB3fmJm7I=
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com (2603:10b6:a03:2d5::17)
 by SJ0PR11MB4799.namprd11.prod.outlook.com (2603:10b6:a03:2ae::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.14; Mon, 16 Aug
 2021 10:48:20 +0000
Received: from SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3dfb:de6c:94bf:8149]) by SJ0PR11MB5008.namprd11.prod.outlook.com
 ([fe80::3dfb:de6c:94bf:8149%5]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 10:48:20 +0000
From:   "Kumar, M Chetan" <m.chetan.kumar@intel.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Solomon Ucko <solly.ucko@gmail.com>
CC:     linuxwwan <linuxwwan@intel.com>,
        Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "security@kernel.org" <security@kernel.org>
Subject: RE: [PATCH net] net: iosm: Prevent underflow in ipc_chnl_cfg_get()
Thread-Topic: [PATCH net] net: iosm: Prevent underflow in ipc_chnl_cfg_get()
Thread-Index: AQHXkoDS6NsKJ0jV7EaTJiyZtib4wat174Mw
Date:   Mon, 16 Aug 2021 10:48:20 +0000
Message-ID: <SJ0PR11MB5008D7714F0D224A0778857ED7FD9@SJ0PR11MB5008.namprd11.prod.outlook.com>
References: <CANtMP6qvcE+u61+HUyEFNu15kQ02a1P5_mGRSHuyeCxkf4pQbA@mail.gmail.com>
 <20210816092610.GA26746@kili>
In-Reply-To: <20210816092610.GA26746@kili>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cee2f9d1-3ba0-4289-8420-08d960a35cc6
x-ms-traffictypediagnostic: SJ0PR11MB4799:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB4799E9169F53D8B5AAC38ABFD7FD9@SJ0PR11MB4799.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XlZN507fkivaQhYoF4Vg4iwKHCn0s6tglv7e8KAiVHkxeiogj8qrdKmU7NSpwICBOr02JgK2IodxLNDGv+2hBIQdfp+NXFQQxWJiCnPX62mzNg4DiQO/SYx0ZOCHmR2nbdn4lWHc6WvMGfSrv5HNk73093PKsi8OEuutMqhy8S1mqWPwfDabwaTubF7JeebOQMTd5oh1k3inTFmpWyIRY5sNbHRK+NhSsvkA4CgQCmY7FsbPLC2xYk5S/Vnlk5sgWYlvgjHbQH+j72oHZc36E7Z9oYyTGQ6FqmCTqY8taJRtm9ZERfnYSAX10i/m88aZDP2t3m5zpI+DAnyAjclpzDsQpz95HumLS2SGjYfO7+zS1rRowv+nszz6JWX3d1b8U8juyJRjSKAOoXEmuMN05ybdP7eUAu5Hxk1DF8LbK+P8rJQfNFj34Wv2iGOW8I2eN/a8xrdFTeXR4JfziD99MfhPj3BZBNP8F3bxUAqXitVwm4gJyZL3HzWTtKhe9r0wBqBOGK/OjtkSfluILHg8IX4wMi+a6ORLoImX3jkAJ0MxXzhfWoQhOV8kss1xVl6z+411r/8ka1jVabA0aLP7lxYhX58BQ1msPN3TIMN3Nd49cqnsVOo+UxD2kIBGdW+F8nx9BZLmGC4aepbfzyzem2J8abLD5bxrpKwlhQFIp5nzMMMcrUG6QozLlx2Bz8GpeZ3aN3ST+zpOEBowGRjAcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB5008.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(2906002)(86362001)(9686003)(52536014)(66476007)(55016002)(76116006)(66946007)(64756008)(4744005)(66556008)(38070700005)(478600001)(54906003)(110136005)(83380400001)(122000001)(8676002)(8936002)(186003)(38100700002)(71200400001)(6506007)(316002)(7696005)(5660300002)(4326008)(66446008)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?yyXi9XGZ/UE5uv6zrhqLS1n4gnDRmxXV5hNAqXK1+HfW12mZevE7MWN8Yx7H?=
 =?us-ascii?Q?2pgNYs6v/7ZVaiAjmvfWdRuO9vUI9T4bjMAVyZEDx5prNiHud/xpVwVbnBxZ?=
 =?us-ascii?Q?RunHdpsGBmDgwbdfnJioKdrKyuGXfwN4PTgp7WepHnksK1AhZ9t95R7IMVHK?=
 =?us-ascii?Q?1E4RAK0HPD0cnzFhP1myuQOsfCkrrrgBp50Z5g3AbjafmEZra63aRccAA6vr?=
 =?us-ascii?Q?41oO4rrEAhiAhkp9xVqZ2MdEp2NWvFDmrPS36g31I3knyrVGQ0UWKu/Z7zvt?=
 =?us-ascii?Q?eQAkq5QqphjJ2Q6tGH79wiiRWcf7vAsGu5cM3Y5DKjMXpJUgApWjM8utz2cn?=
 =?us-ascii?Q?U+GjFUAR3bbtmdcl9Xuum/QnqZOrrTjRt2Jb3mOOxrvtN1oWbuVqf4S3vaQ/?=
 =?us-ascii?Q?wWSAJ0q5y8EjNjiESgwP0yhK8GWYrjGCuxXhkSQmeX2R6dQj3ZF1FCDUw6s5?=
 =?us-ascii?Q?IbPHCbA5Pthzzm9IiwUQzwqte18Un2Ug2kA9VGCda2HSCC1XtIY4vNIqNmg6?=
 =?us-ascii?Q?IM45vVZhqvfkJGuoBbVwNKxzgGBIn9oAMkIn1RshS/ZWrjGwLlWGTzT4Tp9I?=
 =?us-ascii?Q?L4iYkcCfRBMZnAzEjVtz6Ls5sj6CKqoBa7ISHRe1/4c6cP40YDZQGNAB6Rd1?=
 =?us-ascii?Q?77S4uALB/HDUp90X6qwTPreDgWtB6PvohyH5yoqpZVM4rEETHkpIa6XhbDvP?=
 =?us-ascii?Q?yatDEdeawN2yxJccZJkATpKrH33a9tQQGRN7sPoykAXwnOiTlgotDqLI7n9C?=
 =?us-ascii?Q?QKmwLlZwnpVJ2GeaqgUC9t/zazz62pjiz92zd2/xuJ39mX1UfEhRgrkmGHd2?=
 =?us-ascii?Q?dkKmJm1d+5IlzugF3WiJpvF5+3rgM6Nu2faCB1hMKMRi8k7/3f5M828XIvfU?=
 =?us-ascii?Q?5kA0NTAyB1tjK8+5Stah1tY9dE50b+O810gl6a+J3rtEbZTMTCzDz9eAur4e?=
 =?us-ascii?Q?43625Ueba+hgYXPE+L2ER1oiDoJfJnvlAIc1tEJfaAMC1Bjpta8fVRlkWeog?=
 =?us-ascii?Q?hYTh1vK4KtZAlVp2RONaIwJcRFE73QbkzCpiBCJpScih5Y9TbQRPEdf9dMds?=
 =?us-ascii?Q?/4unzpAUYf8g9nnEDdKHV4pTO1rb4C3X7wdh3HeK5vs9ZtARCGihXKVGuLHs?=
 =?us-ascii?Q?c7gVoraW+cb5h0so3KtCAG7+SoC4xN28gZBM4odnaysF7fMWVelHgNXe2k//?=
 =?us-ascii?Q?TFEvoKozAQYIypUr+LOjWz0JA1iFXWHnSwV87FX4zkQxfH/bjwtRFHqAln+x?=
 =?us-ascii?Q?5fkjsM6ugEybz+fMFJEKXfvNBFSdyup04x1fiMSwMUMUz50o1cOQnVxJyVh5?=
 =?us-ascii?Q?XgPqitjCcFea7cFPnqOm7V2GG5L6W8sFMj7oEFw4x4OBWD6PmBInKhNRaE65?=
 =?us-ascii?Q?aHvueSmEKJpOo1vSy1jON+Clte5t?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB5008.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cee2f9d1-3ba0-4289-8420-08d960a35cc6
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 10:48:20.0582
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wrn4tIp5m/49Q2GTQl2WPV4eGzCLek4f7Z9RwAldRGBTJcUwDf52ZtWfKV4PDMJZf8NF6xoMyaOY8YJf5uLMUeCGqixJP3M16neMz2YeDRc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4799
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dan,

> +++ b/drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c
> @@ -64,10 +64,9 @@ static struct ipc_chnl_cfg modem_cfg[] =3D {
>=20
>  int ipc_chnl_cfg_get(struct ipc_chnl_cfg *chnl_cfg, int index)  {
> -	int array_size =3D ARRAY_SIZE(modem_cfg);
> -
> -	if (index >=3D array_size) {
> -		pr_err("index: %d and array_size %d", index, array_size);
> +	if (index >=3D ARRAY_SIZE(modem_cfg)) {
> +		pr_err("index: %d and array_size %lu", index,

array_size is removed so please change array_size in pr_err to array size (=
remove _).

Also change in pr_err array size format "%lu" is throwing warning [1] in 32=
bit env.

[1]
                 from ../drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c:6:
../drivers/net/wwan/iosm/iosm_ipc_chnl_cfg.c: In function 'ipc_chnl_cfg_get=
':
../include/linux/kern_levels.h:5:18: warning: format '%lu' expects argument=
 of type
 'long unsigned int', but argument 3 has type 'unsigned int' [-Wformat=3D]

Regards,
Chetan
