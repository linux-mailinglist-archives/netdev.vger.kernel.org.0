Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9F8D3F0AE8
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 20:14:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbhHRSOw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 14:14:52 -0400
Received: from mga04.intel.com ([192.55.52.120]:53409 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229448AbhHRSOv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 14:14:51 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="214547790"
X-IronPort-AV: E=Sophos;i="5.84,332,1620716400"; 
   d="scan'208";a="214547790"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 11:14:16 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,332,1620716400"; 
   d="scan'208";a="471626894"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 18 Aug 2021 11:14:15 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 18 Aug 2021 11:14:15 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 18 Aug 2021 11:14:14 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 18 Aug 2021 11:14:14 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 18 Aug 2021 11:14:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZRPbIXr9OodKFqCSQFUa+VYYZAaXNmeP4CFaxesDJKqi/aMDbfOP5yIXCKnedlwoSHT2QQLWSpWnX5Zu3psrVe3KBpJJAr2KqTypOrw0mpqqNGWnPhzZkqK5SbYXAUDhbY1SfmzaPZgT3Ishk4VaD1zuUNVprMKLeBYgEPf8Iol6LgngDajK7HQLBWcy0yJH/9XS8MhkRmmHv2/yzgrBv48iKmKRnbzd1VIBvVI2twV/twxg9XeW4U8Jg6P+1hoQ9xIi3ewLvTq1bpE+6fG4smb2n4edMXMxc1kzxyDae+kk0yNsGRvr6iDtf6Iw1ZQGyBGfMw8a4wTw+fJIxka2fA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOgpDm0LMsXEafOOyfze253fElOLP6Nb8cAWi3htuQc=;
 b=G7kkQDoWOSM5nbo6lRHkAxbZwuFBHfnecKJBhOV9sGfCfhBfmj29S98Gmop3pbT7DAxgWAudyPmG0P3oGtSlDPqOhSDH5O1DwsWhiPTVlYr+3SS5KRF7bIa8qfic4zNLr745iuLnPpC2hFhARh3o4SVOxH2yKO5JvZzYL5Qp8imeVCFWGAUATnBId0Je2wSGdjzFm9z+uSoHwSh1rjs3irlLUeBcG9xVlD4UVc2YU4JwyUGzfCZ7Q28Meu409ioOsrXdKbgWz/8C7WhYMKKUmKJlorhteerTZzr0nBn5QAeZHPffXawYFOljUJH8V1ueF3qunfW9S4Hwh2/8bXsMmg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YOgpDm0LMsXEafOOyfze253fElOLP6Nb8cAWi3htuQc=;
 b=ie3I+yYOtwGvjAQbTsX6XHiLHoN2aT6YqwZhaCWzHPTO2GgZltPdoSVBUE4XLz0TqEsVDTEIFKCCXwxpu8AFle6ranQ0Ytzyg3WmiUYn5cpv9xgl5YX+JWWkwY/B5pQBjpeQUwTwZYds3Rg1uYUNt1DkekHrJeiFe7k6GNeEN58=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR1101MB2078.namprd11.prod.outlook.com (2603:10b6:301:4e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 18:14:13 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 18:14:13 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
CC:     "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [RFC net-next 1/7] ptp: Add interface for
 acquiring DPLL state
Thread-Topic: [Intel-wired-lan] [RFC net-next 1/7] ptp: Add interface for
 acquiring DPLL state
Thread-Index: AQHXkrpGZc2YC9udeU2jnSf+yoigt6t2zoSAgACkO4CAAg2XgIAAEo7A
Date:   Wed, 18 Aug 2021 18:14:13 +0000
Message-ID: <CO1PR11MB5089A30F5681B860B3F9F96CD6FF9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
In-Reply-To: <20210818170259.GD9992@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4654f27e-5da5-463f-48eb-08d96273fbf5
x-ms-traffictypediagnostic: MWHPR1101MB2078:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB20781A38D8522E5381E011EDD6FF9@MWHPR1101MB2078.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0jN8c7bQW3qmleI4Chb3qrARoTEe8XWxwtnwiXEtwqs63tGCanH8TSkM45wsUSUJYpWm9CwMstwojLjRTHF3uvUtiUUisEPWHnm6a1ZSk4vi4kKatvV34wR03BRcnBQiyUlJNar4ZbB4ESiixdM4eu4jfIGHbobYqCWYSWfV7v8+jbHKIvvLUbz7diRfQEjm0KrWNls6/jAVOAFvv6IJPWov/w5wmWsFe6OhSxEEqKf1F4AYvngdLNAuHI9RjNUR2gbyIPywaxd1aOvPq4zGRpWo+FWnrtNShP53kwGPoCDjUQzcI3iTS6uMoRPDtDl0NjlQtENWUTTCv85nN9BJ0VmekGrL65Bw2Q8o0uB3Srpsf5gFnJwXeGHu7ihVoFQfpNnf7zDE0Q981nA04IROvqUjxt009AqWcUwIM9564nTH51NiMqlk9byzU/qNPrEdTwcEjmsD9nmF9Gc9Kxof6hStUydbZPdYNj8Vsh8FJVSNdAKYNVv/qUGTgXxu+M11Hs7gTl3gvJI7o0x9rBDfV7v/HmcUwXhof4wqImIMawzW/F2sU/cchdU+OVjsIt/my6H9Xv9sR25mAhoWkTcQiC0hdYea10yV1S9b9/hHFXUrYb02sRqzkhX1XAMTYm1GfMtWdKh1NrYIByTC5SX2OwdG9deOvfQ1qFWxmgBYkannfU2qbAgvuqIkSxu0UTnC0BB7bjKNd3iraKpBtCpoZw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(33656002)(66556008)(9686003)(53546011)(52536014)(6506007)(86362001)(55016002)(71200400001)(7696005)(186003)(66946007)(66446008)(66476007)(26005)(76116006)(38070700005)(7416002)(5660300002)(2906002)(122000001)(6636002)(4326008)(508600001)(110136005)(54906003)(38100700002)(83380400001)(316002)(8936002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9EfpiMGPVX28X8TWSQrU0OLpKcKd4SnO31t4NPWFAZGiLxnSXM2QG/Pg4+KV?=
 =?us-ascii?Q?1SfejKGnkELh7PAZ+uXjTEwxz4JIyI6e9qUNHe37++2UaU0EwVmBpTvrqVF9?=
 =?us-ascii?Q?q+3QkFdOo+ZpJX0FdESXulwJWYcClaaVa3nh5bO1/s25wEAAo/ayqyeaAA5M?=
 =?us-ascii?Q?v4Ez/kpY9bqpxPbQr4LkA9G5UZWSnuazOL0vmdu7gMs1SimO19zfmIQ/9e8Q?=
 =?us-ascii?Q?pdjatEUbgdw0n8BkLEF9vO9wRO4zNOuJTHAOTh9LOPrKjJlphmBI3qZRnGWY?=
 =?us-ascii?Q?Vvdj/O809rUXRL0lfcxWta5JNGq9d5hhYpT4CJgl7Y8bwbv7b1DW4D1/IbZA?=
 =?us-ascii?Q?9koif8FCwYsLHJBF0+wuJwejvbgpli6dMC39GaDgifqwLL2DSxoV/WwyIU0P?=
 =?us-ascii?Q?MSOZr7OsHXUWEM2lbsXxEZ+JFhN/GekFakGDpUgdcS9dn34e2zs3SHy9f7Ru?=
 =?us-ascii?Q?pAW5QdidhcggbqGnmz/853kXxIOpnCdGyKpbXWF6Hz/MWhghMrDzKNaBq7Kl?=
 =?us-ascii?Q?UW2VMeYy8rlkAjHzs35pXyewJgJa3xIxMUYZ9QRoguPHSghHQPChPUzf+sAL?=
 =?us-ascii?Q?ggsEhqjoJwx4eczwzqSK9IhPKNDrCQiYHVdodWfWA29nhr6w2p60wCSi5Naw?=
 =?us-ascii?Q?CEtXPhy2U8eJhL9W7p+PDNLJhCseH9OX8Y281fJg6TYJBro9uB88cASWW0+W?=
 =?us-ascii?Q?pJCtBU89PU0Sf2xEoawIrHCh3DCGkXcYRSEf1nFYPYgEzUVCO4dH05CHLgxf?=
 =?us-ascii?Q?IDzlFB8gkz9EZlCubTpYKSZKJ2sZDPORBCe6HGel9uSvkLP6XMfhvshXg9ha?=
 =?us-ascii?Q?dcPi/IUK24KhRT+9iScHNsX3En1kKSRjjjbL+tgnioSsB1J5S5aL6skFR/Fj?=
 =?us-ascii?Q?iriMly5dE5xUH75c6elIa7ZoVsrQ5ZtsZGsBlgE8oeixwmSkZBbl77jXoba/?=
 =?us-ascii?Q?/E/be5nW7+riRhuch1tlOBjTEf/9DXUvnH7DJo5I4YaD4HuT+yrymCgtFGIg?=
 =?us-ascii?Q?A/NrWbBU054eGeN41DDmrMTD39sAMBIQGAJgtAIzUJpz7DUHHpI6LKpvSdtb?=
 =?us-ascii?Q?qX2ODpqYQLSF6nYc4wk3SQhEA5PC1oNO7Y17rgYl77axO0zeaqM+QvAwNi9K?=
 =?us-ascii?Q?KMOiSxT0LLAMmxEhsCBHZR6U5FD4QEeTC6TbuCgUvlTd4DUuxNVR7WKzMe/a?=
 =?us-ascii?Q?CMNfd01zm7QvRwNR1uvqV1dT3bBkU33n4gdtkhmXqr83FlVuLhSkxE5kc1jU?=
 =?us-ascii?Q?Rm1MYS+3Z7DJYm3SAWcFCjjJdvcMGEul+04RjnS3q79Z5Omm8GIMSpWBmgYW?=
 =?us-ascii?Q?qYc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4654f27e-5da5-463f-48eb-08d96273fbf5
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 18:14:13.7154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Cp9Q0pnSB5SvM3+kttKexG17UP7ViprhPd2PtP8MonF1vwf1dcVJnoCfcbp1P6BlprP7D3HtpDQfuzHrfcunE9NbgpgbkZzXByXnby+/vOU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2078
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Richard Cochran
> Sent: Wednesday, August 18, 2021 10:03 AM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: cong.wang@bytedance.com; arnd@arndb.de; gustavoars@kernel.org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org;
> colin.king@canonical.com; intel-wired-lan@lists.osuosl.org; nikolay@nvidi=
a.com;
> linux-kselftest@vger.kernel.org; kuba@kernel.org; shuah@kernel.org;
> davem@davemloft.net
> Subject: Re: [Intel-wired-lan] [RFC net-next 1/7] ptp: Add interface for =
acquiring
> DPLL state
>=20
> On Tue, Aug 17, 2021 at 09:41:49AM +0000, Machnikowski, Maciej wrote:
>=20
> > The logic behind adding the DPLL state to the PTP subsystem is that Syn=
cE DPLL
> on Network adapters, in most cases, drive the PTP timer.
>=20
> So what?  The logic in the HW has nothing to do with the proper user
> space interfaces.  For example, we have SO_TIMESTAMPING and PHC as
> separate APIs, even though HW devices often implement both.
>=20
> > Having access to it in the PTP subsystem is beneficial, as Telco
> > standards, like G.8275.1/2, require a different behavior depending
> > on the SyncE availability and state.
>=20
> Right, but this does say anything about the API.
>=20
> > Multiport adapters use a single PLL to drive all ports. If we add
> > the PLL interface to the PTP device - a tool that would implement
> > support for Telco standards would have a single source of
> > information about the presence and state of physical sync.
>=20
> Not really.  Nothing guarantees a sane mapping from MAC to PHC.  In
> many systems, there a many of each.
>=20

Well, I think the point of placing it in the PTP subsystem is that there is=
 a sane mapping between PHC <-> DPLL. There's only one DPLL for the PHC.

Thanks,
Jake
