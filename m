Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06133F6C22
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 01:19:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233610AbhHXXTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 19:19:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:32026 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229618AbhHXXTn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 19:19:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="214292665"
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="214292665"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 16:18:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,348,1620716400"; 
   d="scan'208";a="536039273"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga002.fm.intel.com with ESMTP; 24 Aug 2021 16:18:58 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 24 Aug 2021 16:18:57 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 24 Aug 2021 16:18:57 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 24 Aug 2021 16:18:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nv8X/wY1clcYrtzY+ywFIXixB6vbzhEp9SoiqDjrxKqympJFA1i4ylp50OCeHBQLcjtRP1ON5GUfqFcNTkm+VAxdh300jjUzcSFZQd2sXrt0HFydS+3WWDGYSmuQFcoF84ooS/7T36jR7yuCjK++1EpQrT5JGyIhNqE7G08jp6eXLCB88M/ZIYITa3RnpNCf6iEx4lZIdxYqBtntSCD9EOmW0GwFM3KcTK9OTA5MgBeVwY6fUQ5nVHeTShuL+rzcfrcDUFpdUTfvwyiT61w37yT8TSHcppa4DwYLOzRNf+tK7aDkI0bPMjp0u8lAY69gZAbH1MLMC+mjq6kHwAXF9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uejwr4ezLw+rl2z2VCLXtNffhD0jHLUz16sCX0Bohc=;
 b=iYzbvjGcFoBEk4fedmCYUEK3RlfM0G/eR5vXz7h8qDDv0XsQaOfC2+vj3c1a1ktTKWpNb1Z0jaMPjRTO50wUpFRV4bTNGucx8HscmoRmwC2E11LFHGR9kMBmzb02d2jfNPldm6GR5NzDzlPudEySfnsO/D1gmrg2XRvEcPrPu+C7sqBHg78ItlKctwrrbpthA9o2p7PA5+r7BtzhLXrFkaYiu4YSt9lsJ/wAXR0Ig4Au2GcX8iOGTNspuEMYs66Cg1n3loC4NGM+qmnKQKolFbUah/sd6AofMXWtbvlXmMYXLXRN+q5r2lm6gisOsezfJWG6WOsbRZKOXWog7d/wEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+uejwr4ezLw+rl2z2VCLXtNffhD0jHLUz16sCX0Bohc=;
 b=sBS9TwcuqDUqmJba0ge7/0LmaHZU9U3VnChNxLB28DGHKjYZ5T7KsVHhQHKoKG7PCVCjjwHP4ewhQ2rDNgYOXnAyfSKcG1PbGI5oPTYEFOKxzrzydfns1FnrerDQUNust7MqAvSoNy/STPdOPPy4f1VPakOrdkHLuJ/F7PfIv9w=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1406.namprd11.prod.outlook.com (2603:10b6:300:23::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 23:18:56 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::844a:8c75:cd50:c5b6]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::844a:8c75:cd50:c5b6%7]) with mapi id 15.20.4436.025; Tue, 24 Aug 2021
 23:18:56 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: RE: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Thread-Topic: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
 transceiver modules' power mode
Thread-Index: AQHXmOiflbVGXmdj2kG4CbJa8Uluk6uDSTWAgAABqsA=
Date:   Tue, 24 Aug 2021 23:18:56 +0000
Message-ID: <CO1PR11MB5089F1466B2072C6AD8614F1D6C59@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210824130344.1828076-1-idosch@idosch.org>
        <20210824130344.1828076-2-idosch@idosch.org>
 <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210824161231.5e281f1e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
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
x-ms-office365-filtering-correlation-id: cac03b2a-f6dc-45de-b53e-08d967558bb4
x-ms-traffictypediagnostic: MWHPR11MB1406:
x-microsoft-antispam-prvs: <MWHPR11MB1406F98ADC5A1274B679429DD6C59@MWHPR11MB1406.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gmVKlskScUBuReBA32YqXzHi3JLvsP2NeJfhkK0SkpEWruv8kG/x7MkjAt8wZeJJMus7lY//Tuur2pYSuo66/trrfyoe3eic9kscRgsI6xM1yVqkuPFw9VSzK1W/wTi8RGV7/XCe78H51AwV3wBFvb9KLpsrvQiYsRVgw3M7UEsWbv3Eu9AAI1G5MdQoFpryYdSO+0q3jTtwpN8wJLoFpFRHCb9P22D0T6+4ZxSCOC/8W/R4dNBDOXAiF9NsqVQljjSFCxufyA3acrzvGvHrH3WP+sqcVUqJvynOyy6yoPiNCxb3o9DlJIHAHw5JjfetFTREwRpcPNjF2kQiB5PVNeLBZZFLh6qRz70VOlvbQguElfNzx0Lz5RvgQmEsOXoGzYz+bTFj85Elr1JLmWZ7mqc096IgRfrYPXR6bAAPDH9nSbY69lRiw/h0xa7YN8exiTcKgzSMI6iH/pqi89GAr5sw0PKgOTbHbv+L2acNV1htDrhABGqAfa4qOpO23+3hMBxB/pqHImus8yf3ezZSkV8E9tBiKf4BQ7M6N0rc1MVfKCeSti64BYlCFHpZETWu6O2XuRTdBSscfOW/QzqJ/p79L4Qx+ey4qHe++i5K7d33HzCmIjBE35zTwlSdyDI6ma13YoqhngwogSAAhWpuNfwma+CtSg63fQpn0cCIhdpyXCyIGl2TWRmPJe/jV+qqNyq0XIt9/9N9B+htCo+z8w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(2906002)(186003)(53546011)(55016002)(71200400001)(6506007)(4326008)(7416002)(8676002)(9686003)(478600001)(8936002)(66556008)(83380400001)(7696005)(33656002)(86362001)(122000001)(38070700005)(316002)(66476007)(76116006)(26005)(66446008)(64756008)(66946007)(38100700002)(54906003)(52536014)(110136005)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?eT7iK+c8WFOyoO1QE5kJkjGPmX14flyKkKTKFSbWTepONqv1tjfZoI7vmEsd?=
 =?us-ascii?Q?iOS5QQ6a7FaJlC6X5SUpC1KkkHICv0xmIOHqzcciJWQaUo8/bQSutdr1YPB0?=
 =?us-ascii?Q?bngmTLW6RSY14pX0UDJxAxKxab7o4k/YMv1OwZ+5IJzzkFPldzIry0Te6u7U?=
 =?us-ascii?Q?gGMUVsy6Q6TSd/pimwk/05yGQo+HcuOf+5dLeL679/+e2IYiRS8IjiJ36xdp?=
 =?us-ascii?Q?053coEGvUPcyjOc9eHTlByoAkuYgUiGJSP3RoLgVQljVWYQMCXX/b7SMelUX?=
 =?us-ascii?Q?8k7PbgXscNUFo4WeS8ux1twoL2RHdyy9tAW14ayuDiMyI9gy/ygnWLho5YeK?=
 =?us-ascii?Q?GPzmzvapK9Av8BxXBmmQ7mUmxP3wMyofh9M6GxP7adhEl6c5bq+dFsl2F179?=
 =?us-ascii?Q?ZHh9P3g6NWLZRlcBAFxIUwbTEbDuiioZDTwdhVALAIEd6g+V1TKP6u20Jw/p?=
 =?us-ascii?Q?ZFcnxVkmKw+7cxBOuQ070oTNFbFMsaZm752oQ2wHZI7zh90X7QyxwyL1kFrA?=
 =?us-ascii?Q?DKUn2hTtvJS8cV8xkx64jpT1NwIwNX4uZSxVGFHT34/540/nymkNwIwAPwDs?=
 =?us-ascii?Q?oVGmPZUT6AOzSQrwI6VyHPVkikNaNONbjlWrhAfOVfLZEUI5r55jK+6u+4wF?=
 =?us-ascii?Q?pxYINqgo5jF7hM2ZChO8WgaRxJeRzaADWeuVjvsBizUPZ0fB9axV7Z5rIngg?=
 =?us-ascii?Q?+zLdKHySSPUAu5Vg7uzkS2bDaUqGOaTqMXJZhcz8Q3H9Z1deYDSz5lPOpj8E?=
 =?us-ascii?Q?3J8S9+9Z2AcgETxqssVt3TfhRrC+c2P1Oe0hXmxIwC5DgN6bZ5jxXOnyHdIK?=
 =?us-ascii?Q?v3Xhp6/PjGHPxGmOy3Psnvs13dicBKU5P3T3FziBOZdQrAjq+Kasn6cYP5z3?=
 =?us-ascii?Q?OvKbPhLfeaLT+Mk5QsTN1ftfPM/9G6NZAqdLs21bVuwjFAqOha5z6z4qFRVx?=
 =?us-ascii?Q?Cz4Kyw0+aIvM3hRHWrL3VjzQnt6rTlV2wmC/0kxu8UNGQyZJ65WRfk8ozXEm?=
 =?us-ascii?Q?7EGmD64sG7wgpqEMAm/I9/+Js0bKMalZiZNidtw8Io/bquWwGcwJbitksIxy?=
 =?us-ascii?Q?qwiyWQFlAenCYUhzr/z1s28EcaTFk12AGkYiZqh93DQ/o2UXmM63m5VOBrwF?=
 =?us-ascii?Q?V9QN8mLYHqxc/ZzomRFwpaJ8LyVC7M+Rj5ZEg7820N55LHDOZug/Q/66Mgdy?=
 =?us-ascii?Q?ZJjWWOsdnVW3wIBFI4tcMO1DHn+KKd6uWL4CvA0OfR8gFwBPBIhY/K7suqPJ?=
 =?us-ascii?Q?SealDjX7Asvn0Q5yrUsdONRz4HkGkTp6gF4yLyEIykLWTNakktGA0hWnqZ7B?=
 =?us-ascii?Q?X7Y=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cac03b2a-f6dc-45de-b53e-08d967558bb4
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2021 23:18:56.2058
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: i+pD+prUmBLQZEPMiA0KU7S7x0H0qfiPxdzj3/avpRlK9WWJH4+tgMYftJ0O5K3Z7eg9wXil7avRoHumFnh3MmXkjiWgDQ7K9G+PaYP5r9I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1406
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, August 24, 2021 4:13 PM
> To: Ido Schimmel <idosch@idosch.org>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; andrew@lunn.ch;
> mkubecek@suse.cz; pali@kernel.org; Keller, Jacob E <jacob.e.keller@intel.=
com>;
> jiri@nvidia.com; vadimp@nvidia.com; mlxsw@nvidia.com; Ido Schimmel
> <idosch@nvidia.com>
> Subject: Re: [RFC PATCH net-next v3 1/6] ethtool: Add ability to control
> transceiver modules' power mode
>=20
> On Tue, 24 Aug 2021 16:03:39 +0300 Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> >
> > Add a pair of new ethtool messages, 'ETHTOOL_MSG_MODULE_SET' and
> > 'ETHTOOL_MSG_MODULE_GET', that can be used to control transceiver
> > modules parameters and retrieve their status.
>=20
> Lgtm! A few "take it or leave it" nit picks below.
>=20
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
>=20
> > +The optional ``ETHTOOL_A_MODULE_POWER_MODE_POLICY`` attribute
> encodes the
> > +transceiver module power mode policy enforced by the host. The default
> policy
> > +is driver-dependent and can be queried using this attribute.
>=20
> Should we make a recommendation for those who don't have to worry about
> legacy behavior? Like:
>=20
>   The default policy is driver-dependent (but "auto" is the recommended
>   and generally assumed to be used for drivers no implementing this API).
>=20
> IMHO the "and can be queried using this attribute" part can be skipped.
>=20
> > +/**
> > + * struct ethtool_module_power_mode_params - module power mode
> parameters
> > + * @policy: The power mode policy enforced by the host for the plug-in
> module.
> > + * @mode: The operational power mode of the plug-in module. Should be
> filled by
> > + * device drivers on get operations.
>=20
> Indent continuation lines by one tab.
>=20
> > + * @mode_valid: Indicates the validity of the @mode field. Should be s=
et by
> > + * device drivers on get operations when a module is plugged-in.
>=20
> Should we make a firm decision on whether we want to use these kind of
> valid bits or choose invalid defaults? As you may guess my preference
> is the latter since that's what I usually do, that way drivers don't
> have to write two fields.
>=20
> Actually I think this may be the first "valid" in ethtool, I thought we
> already had one but I don't see it now..
>=20


coalesce settings have a valid mode don't they? Or at least an "accepted mo=
des"?

Thanks,
Jake

> > +struct ethtool_module_power_mode_params {
> > +	enum ethtool_module_power_mode_policy policy;
> > +	enum ethtool_module_power_mode mode;
> > +	u8 mode_valid:1;
> > +};
