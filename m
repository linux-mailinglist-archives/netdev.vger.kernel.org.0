Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E55D4409865
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 18:08:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345360AbhIMQJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 12:09:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:54921 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345570AbhIMQJL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 12:09:11 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10106"; a="285412936"
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="285412936"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Sep 2021 09:07:32 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,290,1624345200"; 
   d="scan'208";a="696790351"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 13 Sep 2021 09:07:31 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 09:07:30 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 13 Sep 2021 09:07:30 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 13 Sep 2021 09:07:30 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 13 Sep 2021 09:07:30 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SKZYPEjUEskL0yytfGOXM0lVKPQdmJZTihelT19fJ9ndR+DMP6b2ueItZkEnlx2kQS7GiMPAI18E3oZ6Dtdg4aqM4Njy23LVvnbvEHO0ripSdaou1AF+HRjbTbUlRRd7/JqInPrNp2hoK1JTPNtv/H4avrW+YmDWV4MhX6Nri1jl/EgQdMm2UuFsEuPKNWphMssyrZQEU/z/1qkgCj52Vc7ihWgbgo09+T8prMll4a19PDJ+LkKmlat2OY84fmEa54xZvwUEVd95X+MPLmaweQV2ZUc5qMVnfMP5f9tR5A1sTV1H1U14v434euoXskY2IkflUfgY7n5pbkAg0tVA2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Ndwxr8vjtWvOxR2lmmddAChfm/JWfhpajyoQRbqJ5Ro=;
 b=nP/xSdkPtJyxzNhfHi4E8hI6X4Kpd6+v9jXqLog28oRJ6zrtSj9ZytlOfFanfatF/2HZBrEc+JL9qqMPuIRHc3tQItRlAp5hK570zfX45g4/mnD7NcYLXHTtOaa5sIhrtMRNzFUTdU9+q/fNckprw6IbptJD6VaRx2F+ErQojnV6+0tbm37o/MLx0Q4H99zVaX7Wz0jfA+MGGwzxecoFs/23IXLrEAr47oE6ZrslAWM8KouLREhN2DOB8Z+xslb6qb+xqqL1/3n39Z9dDuw7m6+cUGYcUx1gJ6h7X7kUEkZ8W5jwGoPzV/g377tLiP4NGeBLKysiHGZYVBAuyyyT/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ndwxr8vjtWvOxR2lmmddAChfm/JWfhpajyoQRbqJ5Ro=;
 b=NIla59XKDWfB99dgo/lQ3GNfE4p28ufYEh1hdyL2vf7VPvd7tXMOyOQemOR3iGbBqwn3uYOQo46id8NcF5iopRGPIMJPU+d+vxdYA+8C/RPh/8WcfQnmvPAGS2SSdXwL0md4VSk3SofGT3/sHlOTIH4kLP7BGcDVwtNXn1g1JEA=
Received: from PH0PR11MB4966.namprd11.prod.outlook.com (2603:10b6:510:42::21)
 by PH0PR11MB4965.namprd11.prod.outlook.com (2603:10b6:510:34::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.18; Mon, 13 Sep
 2021 16:07:28 +0000
Received: from PH0PR11MB4966.namprd11.prod.outlook.com
 ([fe80::596b:9fa6:18d4:67e7]) by PH0PR11MB4966.namprd11.prod.outlook.com
 ([fe80::596b:9fa6:18d4:67e7%8]) with mapi id 15.20.4500.019; Mon, 13 Sep 2021
 16:07:28 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "yongxin.liu@windriver.com" <yongxin.liu@windriver.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Singhai, Anjali" <anjali.singhai@intel.com>,
        "Parikh, Neerav" <neerav.parikh@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [PATCH RESEND net] ice: Correctly deal with PFs that do not
 support RDMA
Thread-Topic: [PATCH RESEND net] ice: Correctly deal with PFs that do not
 support RDMA
Thread-Index: AQHXpcrM4iqti0YqkUWIoEY3yjGYRauc/j0AgAUkHYCAAAOgcA==
Date:   Mon, 13 Sep 2021 16:07:28 +0000
Message-ID: <PH0PR11MB49667F5B029D37D0E257A256DDD99@PH0PR11MB4966.namprd11.prod.outlook.com>
References: <20210909151223.572918-1-david.m.ertman@intel.com>
 <YTsjDsFbBggL2X/8@unreal> <4bc2664ac89844a79242339f5e971335@intel.com>
In-Reply-To: <4bc2664ac89844a79242339f5e971335@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.6.200.16
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9e652ce3-ab94-4892-6ad0-08d976d09583
x-ms-traffictypediagnostic: PH0PR11MB4965:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB496502D50FDF9F74E8AF62BFDDD99@PH0PR11MB4965.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f5xcthLnvtTtmpOwON5gZU0Qmfw+i/egjERGw3Z5PcH0PWtn/Zr8y9lgg9HUusNBfCSsTbtAmBlKsaBeImR6tIcHLzUxjRXa0w3hGCJfbn+dDsHF1kA3s4MHa7ikwonto0wl92of7n0DsAiUUkgI2GvUoouPvKAAmAqAUpDWYWK+gSde96j6jsMGMUsRqKnOaRrqzzmD99Nr+RMkhMY9ONVugYC9KD31tFg7ORcTktpRA6CrateAY+TtFr6wT8zICUu1HzWiIK1ibxEH2rGHvCDrMBFyC7iAExeFgTo+BgNsgZewJqAXINQMx30IZh2EP4BVEELkgMIDsRnzsJzS1cXVkPn72kf1ziQXDi2ds3LNFEPpGNHX3E5XYTIk5q6I+w5agphxNHRf65W0jgMf0vv3TMjA3Pp61bwhsE58ZlN47XPGUopN2ZbhWl3pE+MNBIgjcRJV4l1rv6o2q/X8zmd5n9M7LYdyLJtKLv6oVZgn7MsWJaKdczKSPoOGwb4cN98EELeG20jFPCrWWM5Y1O4C7hpkFboH6KlhNBi3iOFrlCTxDrO7rIUxKYXziHqCF53Ev/xpr1oToDoNh7Fvqkwh32FRP6jrEXm4faOqBb2q2WP5bVFjQ/CxOcekXVSbgGubFyHnbeVvz9z3ytMuO0gS5pHlYu7A/NZdskdemI0KRfmdmn7jbzinXl8xcnl7tYR13alhPvpM5FwQ9QvC/w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4966.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(136003)(346002)(366004)(376002)(83380400001)(38070700005)(66946007)(26005)(6506007)(86362001)(54906003)(110136005)(2906002)(66446008)(64756008)(71200400001)(53546011)(38100700002)(122000001)(76116006)(4326008)(316002)(5660300002)(66476007)(52536014)(9686003)(7696005)(478600001)(33656002)(8676002)(186003)(55016002)(8936002)(7416002)(66556008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?1pDvhQZfN59WopMZBuStIAwBRDNX4Oiic/FaMY0LgltoufopRfFZ23sHfmvQ?=
 =?us-ascii?Q?U0s9Mh/i/rpqPfCZq+hF+YT+brZZ0L1QGWsOFe89I0t689F/VpyA0E+K11on?=
 =?us-ascii?Q?fY771ERefB5XN5SwJ0SANzbnsXtxflxPIWDLsrePs5vaTfPN4MUXEuIMunlp?=
 =?us-ascii?Q?Pv6Qq5DWxNja5fz0lwRUL7CXBZRi3dSAJxr70ADhvIn2bnIh6d8PM41JyojI?=
 =?us-ascii?Q?1rRtLuVgcuaC8TACRc6jSxeOgFxOD+NeYJG0t2JIolhfjH2m5ImsXnOW/in3?=
 =?us-ascii?Q?ol7uBHmhd7TD7evvNbb0TqM0GVFujHeMOXbXyaaps6hTD16aG6PQwCAgffKt?=
 =?us-ascii?Q?csCkcq+TJRrZLL2VmSMp65jLG4MwfOQEdA7or7OboxzsL12fzPcIdOG8ewlW?=
 =?us-ascii?Q?f4LHs0WKyt0tbz7U3/zwAr4kJ+cBtWIM/GVF+faeDahzyiWb4Ze9BuV8O9vP?=
 =?us-ascii?Q?pJDc+pwpzGYhbEGV1Gcdr83r25xh1g8dTjKGa4+aYgTQ2pldsjBG1HBOqR5z?=
 =?us-ascii?Q?AAd9Jym+F6qP5ihIcyqUHIZsrhbHBuhIjLjTGoyIx7rpr/8ui4sOGIRc+nui?=
 =?us-ascii?Q?0xGiGICWLx6RiM28RmiV51wDpTE5mespRJuJbYwKIBJD0oaQZqGqBY8IFBno?=
 =?us-ascii?Q?2gRs/EtUG6lDBoDrXmq9K5h3ichq2CviP4Pkq27RRwlZ97ROk2+2VZ7gGymz?=
 =?us-ascii?Q?7doWCSS1aeIVps3F6eT//gNpGbXU4qqJ/rvG40jQTa30llqm+17xDG7SCuAm?=
 =?us-ascii?Q?okFgoLHscEC4zcG4QEVmWdSdCN4sZ0R436Ke6wknbjSBwjx94tKy+h5F+xrg?=
 =?us-ascii?Q?6tI/ABaaIJfI3LY0SATEEgZ+3N8CEbtJDFTbtB2B5ZkeipOX6tGiOZrMe9Et?=
 =?us-ascii?Q?xnVq31vOAS2LaGVU8mkJ5oLKzXbK7Hyps+5qeevlVRZ8QzurCxp50SPbspXF?=
 =?us-ascii?Q?cS9MIcnXje1lSs8XgpQC4/C7RSPqZAM5huADXubzUzeZGHsmiKD33n13iKcr?=
 =?us-ascii?Q?rZGlVg1S+QxXLKb66anBDuv/XM6zSPQZZsBVoIWD+7YQ6XvMvjMyTkMxM3SV?=
 =?us-ascii?Q?gwh76ADLhZNAzC3TZtsxp7pXFi1dY6b7+5poUj+aeB8GG3ecB3lFlpPqEgmu?=
 =?us-ascii?Q?q6LWygUDyk8IWGn0UwyLfcvYIQtXu5uG+tuQRwg/BxWeMOBkKuGDvYzXXBOa?=
 =?us-ascii?Q?BGNFjcp6aU+/3OC7dv+yLpSe29MPUr0K6JEKEFVUmKQZlpt1lrEIIl6CSlQZ?=
 =?us-ascii?Q?HifvB77zZ+Lv4byOFUeq7bFg1HBT8jY8isiD28WHhO1mqMIBzQbNIB5Z1NpF?=
 =?us-ascii?Q?yJU=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4966.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e652ce3-ab94-4892-6ad0-08d976d09583
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2021 16:07:28.1506
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MVTpi5dWyBBGu5uatYAsYXn8QGRGZnadGvrkuTRvrrjmd2ahIR7QWZn60VfnzOgO1fWV1HHdF6Ks/w00LVXqTY1kdgS6j8O+1nMmqxgTm8A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4965
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Saleem, Shiraz <shiraz.saleem@intel.com>
> Sent: Monday, September 13, 2021 8:50 AM
> To: Leon Romanovsky <leon@kernel.org>; Ertman, David M
> <david.m.ertman@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; yongxin.liu@windriver.com;
> Nguyen, Anthony L <anthony.l.nguyen@intel.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; intel-wired-lan@lists.osuosl.org; linux-
> rdma@vger.kernel.org; jgg@ziepe.ca; Williams, Dan J
> <dan.j.williams@intel.com>; Singhai, Anjali <anjali.singhai@intel.com>;
> Parikh, Neerav <neerav.parikh@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: RE: [PATCH RESEND net] ice: Correctly deal with PFs that do not
> support RDMA
>=20
> > Subject: Re: [PATCH RESEND net] ice: Correctly deal with PFs that do no=
t
> > support RDMA
> >
> > On Thu, Sep 09, 2021 at 08:12:23AM -0700, Dave Ertman wrote:
> > > There are two cases where the current PF does not support RDMA
> > > functionality.  The first is if the NVM loaded on the device is set t=
o
> > > not support RDMA (common_caps.rdma is false).  The second is if the
> > > kernel bonding driver has included the current PF in an active link
> > > aggregate.
> > >
> > > When the driver has determined that this PF does not support RDMA,
> > > then auxiliary devices should not be created on the auxiliary bus.
> >
> > This part is wrong, auxiliary devices should always be created, in your=
 case it
> will
> > be one eth device only without extra irdma device.
>=20
> It is worth considering having an eth aux device/driver but is it a hard-=
and-
> fast rule?
> In this case, the RDMA-capable PCI network device spawns an auxiliary
> device for RDMA
> and the core driver is a network driver.
>=20
> >
> > Your "bug" is that you mixed auxiliary bus devices with "regular" ones =
and
> created
> > eth device not as auxiliary one. This is why you are calling to
> auxiliary_device_init()
> > for RDMA only and fallback to non-auxiliary mode.
>=20
> It's a design choice on how you carve out function(s) off your PCI core d=
evice
> to be
> managed by auxiliary driver(s) and not a bug.
>=20
> Shiraz

Also, regardless of whether netdev functionality is carved out into an auxi=
liary device or not, this code would still be necessary.

We don't want to carve out an auxiliary device to support a functionality t=
hat the base PCI device does not support.  Not having
the RDMA auxiliary device for an auxiliary driver to bind to is how we diff=
erentiate between devices that support RDMA and those
that don't.

Thanks,
DaveE

