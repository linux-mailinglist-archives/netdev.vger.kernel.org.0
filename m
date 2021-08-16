Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B95003EDF55
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233320AbhHPVcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:32:55 -0400
Received: from mga18.intel.com ([134.134.136.126]:52471 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231316AbhHPVcy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 17:32:54 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10078"; a="203101071"
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="203101071"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2021 14:32:21 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,327,1620716400"; 
   d="scan'208";a="530769692"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 16 Aug 2021 14:32:20 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Mon, 16 Aug 2021 14:32:20 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Mon, 16 Aug 2021 14:32:20 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Mon, 16 Aug 2021 14:32:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iw2pREyALz5BbcxPKylwGemtaVFbbdITsna2cdfJDE3kKA7SHD3i/PM/4qubgCrQ/jwb8KQT9PJ8/6uZtJb3tjnIqceDrgf4eU7BOfg6vZps2U5QxFFFegedKqHr4aiCkvplofJOGiU4858vsKkZ39SEaWKYm5yl6HBVsS0ITlgHEBAvkti0WgVjfVNBxs0w9fX8H6ZEl5hyUh/QeqPMVP5+vTjkMg/RT+L1c13gWl8slyUSLzy5FlzIvtMR4O/mZ7gbbtmzDwn3ZIHgxlgDFd+139aBPvHAQqTqtxpnBm8+41Z76/Pq5RzMWmwML02/LjySLdZ4TrXEVcCKlxhQ8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9YNUhmnoCXHxlGL6msBPWnmZfJCoZDEav59DlavzZI=;
 b=Fh37wXhDpws5tTrBMmO0oR9sTeMvMMgvsvridf8oP4YLENm7tBqXozguNu3JGCj01YGsi22X43NhusZfdA6NFEq6MANhhvoJLrOm/rkmQD8rE1UZR4sN7vKK0/+9p7GqHVogAZvogr5agN/Fs3j6McGJ9d/7rdKgAclsSPfKGby2jKV17p31QFzXqTYoAVDJ4D64wbQwNZOwLSw+jVhuV8lzEZ8NwXBYnmrFyTlsiJj1kgyl6huS2Wr7g5Cg5pONleZGpXaHsuZw3YBaTyOyCcJmE18xYP0IsZsowbupx6kIAqYbpA85/a0M/t2MoBmlSKNhwehvijHYbtwlT9W/7A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L9YNUhmnoCXHxlGL6msBPWnmZfJCoZDEav59DlavzZI=;
 b=XUJihhtlLlUy499rA/pRGg33i7SmHjR8U0A4u9lzkwXPRKUrj2vEWcoCUbTJk7PlggClzgwClkv4OsY7Tc9tF4Q/dzm9EN4okn/9PmgR2xgz2nDa8eZPkP5kGThl87DucxIsO/nfNGBY26+tHMBrToIve0HQ17n5ZJR4yaRBIUY=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB0031.namprd11.prod.outlook.com (2603:10b6:301:69::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.21; Mon, 16 Aug
 2021 21:32:17 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.023; Mon, 16 Aug 2021
 21:32:17 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Leon Romanovsky <leon@kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        Shannon Nelson <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: RE: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Thread-Topic: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Thread-Index: AQHXkPLeq0W5yofhY0KH8k2ic9V3+Kt2SjGAgAABsoCAAAO0AIAAWqrw
Date:   Mon, 16 Aug 2021 21:32:17 +0000
Message-ID: <CO1PR11MB50895F0BA3FE20CD92D79CB6D6FD9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <cover.1628933864.git.leonro@nvidia.com>
        <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
        <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <YRqKCVbjTZaSrSy+@unreal>
 <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b25080d-e45a-4969-387e-08d960fd529f
x-ms-traffictypediagnostic: MWHPR11MB0031:
x-microsoft-antispam-prvs: <MWHPR11MB00313CD898DC23C0473F5D0ED6FD9@MWHPR11MB0031.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pbO+Qor+L30KKA+wuxdvtxzARfVdmhrZuqnGuBXyHHKbsmiriMF5OrUXz6z1oCLKYOxpVEkJV4/f4DQkMFcqWYYitV592nJW95DBEkqLaJ7AsiQvW0W4RnG9rdcWEgcfkhr4M24/ttAk30cHilo1asqkJdYo9rBbTiLwLPDtyLClhhs2YwL6PTWzzJpdRtJNyCBtdb9V1+gobkQm+O1zZUuVW3OO1wB6cdFdhMA/ZHf/VNME2DqmLUyFVZQs/XEC6J9EzMjynS5McS5grTquFbSHQ+LQLRrRmYkuJ1s/iUXPeZMKDt0tdx4db4j+eA4gTiSAf6EFQWj7qPmdPOs7SO9Sek0Bm9yj7ogAfQhqwrs+dhkOdClh3Hrj7rVusaotT9NhA/wdGKn2doO6bLfpX2X8zfOx2Hhe8Hu1yojOjlxtI/NIKzr+RQ+VIFru45BLodGJ9AhjyQ6mswR8+LgwbYsj+THnbw0Lct1BkVorD0dPZHk0wwIhTtPjaZbmSowVmYDIPAMSdrnoukzyd+PIO+xoLnsUZ44uMyJbQ1gO5yCDaHOXiZ4SnVsXwvqwREKTlpM4QnNUJXsHTLJf0EqpiWM+T9HSiQImtMOnUh1St04ZHqU5P2TaBINkFoWWdNmSG0T+W6dOOBAbOoUn6wYznOhEh3NYmAO2e51I/GNfuvMz8ytaCHwZAwQZOeBuvCEDGZMB12hxd9C9JrizkG6tvQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(376002)(366004)(39860400002)(316002)(66556008)(4326008)(53546011)(52536014)(8936002)(86362001)(33656002)(6506007)(478600001)(8676002)(9686003)(110136005)(26005)(71200400001)(66446008)(83380400001)(186003)(76116006)(66476007)(38100700002)(38070700005)(122000001)(55016002)(2906002)(66946007)(7696005)(5660300002)(54906003)(7416002)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ogDrB43eYj8jpWODBHgyyTFjStCTvut1ho6FwVembN4ifZsymIpSItTqNOw/?=
 =?us-ascii?Q?t3ovInmeW9l6hxUtfLpX1txO/cycEp0DrYJP3SgZwYAde2AMD6RlIpc+Utoz?=
 =?us-ascii?Q?ulsVV7G6TLlrfhbe9i6IqrNl43Sm4aTesZ4AaMmAfsFAap5bqdA2FsNEdTVK?=
 =?us-ascii?Q?mstbViRjPimq1qVfA10/6O3YeSqtqrgJRAHNxSYkL6A8pfcGi3eDQyUxch9J?=
 =?us-ascii?Q?AaehFf5LMnVeP2jwPv1prqCrsL1rpDwN5zQDMMKRkiGbPwZO28bxa2puQZm/?=
 =?us-ascii?Q?vw/GRywCl72xGqlPqxtea45FWm4VrpVPHR42GotCbuE3cfrcqmlueGYfkkmd?=
 =?us-ascii?Q?rGQxNwy7GfZLPpuQ9rUgLbXRPInLJ/Ywqz7MFj5fiIylSt3D7uCcZHJdd931?=
 =?us-ascii?Q?BDjF19PEvLBX2PNpGSIkt6/6S2Qrv+ECARmG3zoYnNJ67qdbe1u9l9kH3Qd0?=
 =?us-ascii?Q?TPlJrXqOfabZq8r4QbleANwx1FVZ6yQSbaIqW0QvoTKdejmqZZUFX9a+jBWX?=
 =?us-ascii?Q?Yp7cCX3OmsDhYs1bkAy5pZueox3JycjBI3RVYuoXFwosyRGIfaZ/RZUzgX7K?=
 =?us-ascii?Q?2p2OQabzwzLryEBGeA0+XmXHT7dydLRGhtH/Yune665L6l6oEzC16/nIbT9c?=
 =?us-ascii?Q?TLuX5wjW7/pCIMT6Dkwot2cpiyeje0NlbYr/URbdoHFUsjk8fa0pvifhzwCq?=
 =?us-ascii?Q?pCdnh2uNJ9oj2HtjY+c9w8nKjF6XLzessQp4GGKO/C9KGNYKTAXn09bhmc6e?=
 =?us-ascii?Q?onX0N/9Mjqp5I4SDakiuyrT5fBJKjVb96EMj7ATWNVov1Hj9xGDaNbflxNlA?=
 =?us-ascii?Q?YGHUxS0GZf2Pbhr4dIF0tzHp7RRFg8uYMPlhw1vVBUEynBz8ziDK7nZvFfCm?=
 =?us-ascii?Q?t9OArd+Kk3bC9Appb8DdgwYaXbxGR6QONK7ZzqA2bL9WU1GWxVZWjpaOLgib?=
 =?us-ascii?Q?5st8a5mFfE4pStMQTcsep0dgi5nw15A4qZoW7E8E0LLXfnXRrnIfBbQz2o7X?=
 =?us-ascii?Q?3+ZzxhFLmu+2yG6qgoNs1QnokLYiiGTJnibP0Us4Q2anjjYLqYECBRXJn9Tk?=
 =?us-ascii?Q?obYmAeMcY5fZ1ew456Nue2LvDIDb4gHzswicvrhCU4IYx8H6toXvgZzMpz0Y?=
 =?us-ascii?Q?FnAx6FQDWnGVgE5x4bO5wMvERfjioPrnOCklpVV8Ux3vWtdMMop8tZA+EGIS?=
 =?us-ascii?Q?X/9XTAjS5S8A5k8EowWAPJXfXFAgtU7fsJcVV2r/Py5ujftn+ZQT6I2c9mkt?=
 =?us-ascii?Q?WrcUkx8eheI5JNjne58YjGpnDRi9rjlXB2lqyaQzIDSgmpba/ViqcDq26Mnd?=
 =?us-ascii?Q?SDc=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b25080d-e45a-4969-387e-08d960fd529f
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Aug 2021 21:32:17.7251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yIGL7YtBdzlHE+Br9D7tPw4wSj+9JkK4pcmsS4CNWlaml6IQQRFDKw8dHP6AJ/Fe7VXp34e9FM2R+87PwFxpPrd7JAyCoRy7tcVyMQwOlnA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0031
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Monday, August 16, 2021 9:07 AM
> To: Leon Romanovsky <leon@kernel.org>
> Cc: David S . Miller <davem@davemloft.net>; Guangbin Huang
> <huangguangbin2@huawei.com>; Keller, Jacob E <jacob.e.keller@intel.com>; =
Jiri
> Pirko <jiri@nvidia.com>; linux-kernel@vger.kernel.org; netdev@vger.kernel=
.org;
> Salil Mehta <salil.mehta@huawei.com>; Shannon Nelson
> <snelson@pensando.io>; Yisen Zhuang <yisen.zhuang@huawei.com>; Yufeng
> Mo <moyufeng@huawei.com>
> Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
>=20
> On Mon, 16 Aug 2021 18:53:45 +0300 Leon Romanovsky wrote:
> > On Mon, Aug 16, 2021 at 08:47:41AM -0700, Jakub Kicinski wrote:
> > > On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:
> > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > >
> > > > The struct devlink itself is protected by internal lock and doesn't
> > > > need global lock during operation. That global lock is used to prot=
ect
> > > > addition/removal new devlink instances from the global list in use =
by
> > > > all devlink consumers in the system.
> > > >
> > > > The future conversion of linked list to be xarray will allow us to
> > > > actually delete that lock, but first we need to count all struct de=
vlink
> > > > users.
> > >
> > > Not a problem with this set but to state the obvious the global devli=
nk
> > > lock also protects from concurrent execution of all the ops which don=
't
> > > take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely kno=
w
> > > this but I thought I'd comment on an off chance it helps.
> >
> > The end goal will be something like that:
> > 1. Delete devlink lock
> > 2. Rely on xa_lock() while grabbing devlink instance (past devlink_try_=
get)
> > 3. Convert devlink->lock to be read/write lock to make sure that we can=
 run
> > get query in parallel.
> > 4. Open devlink netlink to parallel ops, ".parallel_ops =3D true".
>=20
> IIUC that'd mean setting eswitch mode would hold write lock on
> the dl instance. What locks does e.g. registering a dl port take
> then?

Also that I think we have some cases where we want to allow the driver to a=
llocate new devlink objects in response to adding a port, but still want to=
 block other global operations from running?
