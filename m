Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB1B3FFA8A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346181AbhICGqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:46:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:33112 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232218AbhICGqk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:46:40 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="219048288"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="219048288"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 23:45:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="462066973"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 02 Sep 2021 23:45:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:45:36 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 23:45:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 23:45:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QBJWXmv1+1PgZDF1mSwyqZIymbDPN/UP7KEp3dttBkal5YGXxfjt6gneLcGuqb45KbNpnaimMvKo+Y9/kanRHC0SA9EQjXq/2Qby7GAI2vzncty9zSkI3C4PAxEboNQo4FIbDO2s5ZNcP5FqMKRyRK+5lLKPTqIQaiyE29o1Pirs0hWeeb/7QOJ7+MVGr820db6CHUK+1v7KIzMJLuOe/zWHOtbiY+O7aYstfy8KTnStV6IUAnrqKKeFvtmTGjyFLvTlxI0NP/CUhUgA6ct8Ba+5aIxAaZyMwtem09foOl3HgZRBfKTDf2QdW6EUQXUb1ug81O8o2/eU/s3UWFaraA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irZoJ4FEuvS7z/WP6x7ewIsg/UGv3crVU7QInMKejjA=;
 b=D0f4ousr7v3bAP2dxHUzWCc5b6Hh23xDZ5zCo4JFSWXx2oU6YQFXKDXpuegJY/BzFg9npye6x0YE4pYIQgCWVfA8KSPYhlOfplhfgLVuLQ9iSgcoXnu1GFG8XbsjGQNpXzROId/yaZJf6hEZ761aXER3JvpTSjzrpZoGNFGFr/jzwzF43VUtYjOcA/lwEq/GuzYP0sX1mnana2o/M3MuUH0LE7XetnMKUqgTHa/WGSlKm59t2h4UPOdeBxT7WXdvrU1mylb2UBAhtvh4AxrU1ICAE53IZCIxT9M2s4T8eBnEKWlQgH/r+Sg4hmuZP+Ad6yUEnc7HBYhxhVIoEg3Cug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=irZoJ4FEuvS7z/WP6x7ewIsg/UGv3crVU7QInMKejjA=;
 b=gfg5rW+EgWnvAqARsABzyFMlA0xsWinAvSB07vQcncDuUY/Ucj10UjcVd5UdIqt8FVSNeR9yMWRJjQbnE3J31BDcwhhW1qOLuNoZ6LSh214UT0u5H0kmVfLZXst+q1fA/B+32CU+3WELRL5fKe/Wbqxaffoira23xcJUG/xkyLA=
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by PH0PR11MB5029.namprd11.prod.outlook.com (2603:10b6:510:30::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.23; Fri, 3 Sep
 2021 06:45:30 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885%3]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 06:45:30 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "joamaki@gmail.com" <joamaki@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 6/9] ice: propagate
 xdp_ring onto rx_ring
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 6/9] ice: propagate
 xdp_ring onto rx_ring
Thread-Index: AQHXlPQCcJB1pEsVgUmgaqOd0nZ3wKuR9D3w
Date:   Fri, 3 Sep 2021 06:45:30 +0000
Message-ID: <PH0PR11MB51440C7E16476F0583A279B7E2CF9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-7-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-7-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 92b10b6e-6d18-4812-d4c8-08d96ea66c3c
x-ms-traffictypediagnostic: PH0PR11MB5029:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB502985BC932C62539E37465EE2CF9@PH0PR11MB5029.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BAQq4kuY2/eVSFks+BP/xUUuKCvs34/Hg+5bR6khhjRgsBl0cw2xwC5jv7GO7n8umbEPFTAwtHFnleSGiGadZnhUArYwSoHPbpy1VZ7Gd4inCcacrTuEwPyYl7CAM4IEn7kNFQYzfdieLXHjRKflYu4vvPkzTu5lYF55bHRNK8iXdbbk6v5MRLRp5JTpSzn7a9KQAuVy77KtToMRgwymrMTZvxN2VF/KOMH1TiCLCs7fTemYbWh0ExmYq0wDVZ+jwTZiyI1wg4hrl7gHe5n0/8dF2zavHyoTVaRRawtzJqoCOMp0FJiF7OTA/kTc5PnPcGeHJbIV6IWrnvKuQzmuVs+rl8nazULs6UWrcYrE7eqn1jiGyeBDxmn8mb43kpiW49/8r9qT/Qb5KyU+LpZECuYQXRRdJJwFD828v36NgTwNIx/I6ts6r8+MQgBkapPnacvWS2ueXVTvN8oLw5cbhdzB08n+qaZP0nkJf+Lg/OX7poLL5YAAFrWEwN9IlX/omWgqoZMiGgVfzNPPgNZ2C4yWoNNU4y6G0CutEJ+MqsbFmU8/YFgaRg5Uhe2Oexd6K1vON136KlPJOkGYkVY3d9VetfdNh1uwcSmGEmUSfuExHrakHuYIwO9HCBYmjtZxrC3jpg1B8mWkwUxPK+tj7m0MkdMK0GOOTe6WoY2gsVXcMKjjGksRcBqi8m18PeE2ynabhlbf+v/linQwrZPvS4bA+xdYos0VYTs7i0jp3ZhNovHN9qLASNaOtT5o/jPoEDDUWK3YOn+zDDCCbFOU6kd9h15CNakhogyBjSMw8Ig=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(8676002)(316002)(2906002)(110136005)(186003)(7696005)(66476007)(76116006)(86362001)(4326008)(66946007)(5660300002)(66446008)(66556008)(64756008)(8936002)(508600001)(38070700005)(53546011)(38100700002)(55016002)(122000001)(26005)(966005)(107886003)(71200400001)(6506007)(9686003)(54906003)(83380400001)(52536014)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?vL+DhkVSMMLknM1317h3CV31JK6FOC7NMOspv4rCwd+mZvfk7pbMFgIqkRXZ?=
 =?us-ascii?Q?G0MFF0KtqKutgkObQSr70cgrWyKri33O/CNl7sukqBsiIXSZGmu65LxMliW2?=
 =?us-ascii?Q?w6JrHLncK4ZWR6VDSQEeKgAnTPKC6G3Sx63zNCIH/XZoK4SgTytDIi0VZOW1?=
 =?us-ascii?Q?r55nOOwHY/tD0QL+Jmvw3LSFPA/bnnxeQbWr7SMikdAh9E1IYXPz32xp9Ecp?=
 =?us-ascii?Q?JyR0SI7n9wpip/gWl+vdG1+wOYShvzLDq8oyUZ8W/5oZVbBhZKuTgPPSQnl8?=
 =?us-ascii?Q?AJjFReGLZnFM/i7qvHcz2vjNwtjHK+lMdie4fNEEpP7aYRISD4vO6WOWkACv?=
 =?us-ascii?Q?HziCs5tKIoegrHNdftpUlahkor0puBifQaX+F761UXF/JMH7uTUdoUjZXOn1?=
 =?us-ascii?Q?83itIojNL3d6o903ReJYxYkIM4NUx2ukDWtDDuK2254OPVjNLJfY9BaR6Gb4?=
 =?us-ascii?Q?Ue5W0DSKw+BZ/MVmcZXfsPMJ4MmwQnxfl3H7u33SUEFEeJKsa6GWJx7ZX1jr?=
 =?us-ascii?Q?cY2RVe/qRnwk5cSc6E7kHnG7+5C6gi8Ppk0J0JvgoEbZoGcEDj7TAM2TmL+7?=
 =?us-ascii?Q?0d7MrT0v6lTXgx2Sb8JKS2MAxzVdTvNwKrHntlrlqFu1l1HBaMtCQF0Cuxl8?=
 =?us-ascii?Q?6wVn9QkHFxVf2jo0lknqVYxE+CgUkjG4s7FVahucD8Mgl+DPJjrHOwSarHUH?=
 =?us-ascii?Q?q/c49MLsgGXcM0f9Nkkefo/YcmUXtmd6W5ax5GwhR7EqxQv4557Q0+3zyO6K?=
 =?us-ascii?Q?OZxfvdLeV5gegqiQWTRcqWbTfzU3qcai4scZE7DfrCpmpG0WnNAcsG/U236o?=
 =?us-ascii?Q?e/UmnxfFcCKO1M8IFYUM6MIFbtwqfF+Yyx0XDC9iceT+iWEO+GtUGRsEg4uy?=
 =?us-ascii?Q?ewl86PBuO30vZLUMHYTadBDlzqlxKVJGrVekcXzZYjvMtVsKn451jaFFy+rj?=
 =?us-ascii?Q?4WpsCKKRf31bZ7NqxQ9Bto8EWkmvGEq0HEmprCWk2W+O1hqZOsp5ndE+89YX?=
 =?us-ascii?Q?usDLssHQxIfGWJLdZ4PbG/qt4QVpgwjOYpJb7/TzW51ld+KzJ1kyWBVloY51?=
 =?us-ascii?Q?wW0W+sjgl3Iux59Y4XzyBadDhDKirqJOXvRhsbDRwSj6BVKsUcnzETibLs1h?=
 =?us-ascii?Q?G9GBJIEOA5yerJL7rX3LvqVRhve9Zj5Q+kqhfcBCYsK6M83UGbGVQT1TNn7Y?=
 =?us-ascii?Q?WGC/w57JcmClZhtoX2PJp2UltDzyqtoxi/Svd1ou+93msnQfCxP9Zpe6EkZI?=
 =?us-ascii?Q?gPn2CeE7GmSL5bSzmYGHc1ysT/Zz9eHA83lCv02y8Lcub2iRZxil7xxIJxfV?=
 =?us-ascii?Q?XY8wyr5b9FYab0gSF474bdlq?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92b10b6e-6d18-4812-d4c8-08d96ea66c3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 06:45:30.8332
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sWeb7dqyzdtcQo2Mb5LCgf9b9Tb/KPNfnXavB4KJ/iCSAC/SJxmI+qo9U1sH15U/SaTED7ei6S7h4SxkZYAtIlTa5hyVHyXYl92Z0/Cuv6U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5029
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org; kuba@kernel.or=
g;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 6/9] ice: propagate xdp_r=
ing onto
> rx_ring
>=20
> With rings being split, it is now convenient to introduce a pointer to XD=
P ring within
> the Rx ring. For XDP_TX workloads this means that xdp_rings array access =
will be
> skipped, which was executed per each processed frame.
>=20
> Also, read the XDP prog once per NAPI and if prog is present, set up the =
local
> xdp_ring pointer. Reading prog a single time was discussed in [1] with so=
me
> concern raised by Toke around dispatcher handling and having the need for=
 going
> through the RCU grace period in the ndo_bpf driver callback, but ice curr=
ently is
> torning down NAPI instances regardless of the prog presence on VSI.
>=20
> Although the pointer to XDP ring introduced to Rx ring makes things a lot
> slimmer/simpler, I still feel that single prog read per NAPI lifetime is =
beneficial.
>=20
> Further patch that will introduce the fallback path will also get a profi=
t from that as
> xdp_ring pointer will be set during the XDP rings setup.
>=20
> [1]: https://lore.kernel.org/bpf/87k0oseo6e.fsf@toke.dk/
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c     |  3 +++
>  drivers/net/ethernet/intel/ice/ice_txrx.c     | 23 +++++++++--------
>  drivers/net/ethernet/intel/ice/ice_txrx.h     |  1 +
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 10 +++-----
> drivers/net/ethernet/intel/ice/ice_txrx_lib.h |  2 +-
>  drivers/net/ethernet/intel/ice/ice_xsk.c      | 25 +++++++++++--------
>  6 files changed, 35 insertions(+), 29 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
