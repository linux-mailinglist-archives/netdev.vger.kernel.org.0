Return-Path: <netdev+bounces-12097-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5E67473615C
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 04:02:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 14C3D280F36
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 02:02:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 22F521360;
	Tue, 20 Jun 2023 02:02:50 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EE121119
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 02:02:49 +0000 (UTC)
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D20BD;
	Mon, 19 Jun 2023 19:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687226568; x=1718762568;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Pd8Q0H1mfFHacsQCQJbQ5kUsOZJoJ2ydW/qVLYI5OqM=;
  b=igS4wxOvkPuzUSYijjnWV7vjGdjV/paKB8kU/F2i0nnvfiBs0tDv5rhi
   DUx6RxNyD4tcrHqNL8E5BJ4daKb8zqxcTd0oaIvW7Ha566yCumSS/au6L
   G/fRHW/gWoTd7uYXh9b0TUcyQ4WkcEDBQHOk9lGZ7Klkrkr74/ksqXhJ2
   3M9cN/3ARzqeEPMCJUlwuZsLQ1LAVQIbVbAl+vSQs/40ATT2LUuwP/osF
   7/pDtyIOVOK38UzaGihI5TusPzd9wqZ7bX/1uNAW0lQh7p+BAtKRh3Qig
   yPdWNk6N0useIN2qa/VdBXbUEVGuAl1XI9RD0picRfE/uW9Gxe47d9mIF
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="423408112"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="423408112"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 19:02:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="713872145"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="713872145"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga002.jf.intel.com with ESMTP; 19 Jun 2023 19:02:47 -0700
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 19:02:46 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 19:02:46 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 19:02:46 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.103)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 19:02:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l2I1nio5XnXA/bKT7CFOerXyDXcJ+HAQreWzNaMpIXKFb+GO68gN4kMlw3qIW0jmCi7Dwh4Qkr39/NhcxKOX4ygZ37uPvxSoabOd+Bj6JcIUPxZgjYe8/K0qyyrUL+Y1SWwxaVQBr9kM9St+Suugl8wfO2vBbDA2FWsCKTv1ZJDsQbY/Qi7phKADYuDC7wcWFV5PZE9diYanbwm1/7wyt/Yq4U6hVFT750EggELoSDHTN8VBGL00BcTHrRcXfhifMkmTs3wEIfAAK2zBIVzX0TPxCeWCihZltvRTqMiprf/lPZsHPXDsx7E9a0FuHOfb2C4UAA0reniAe4lYH27+jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C9hN9+vqzWs5jch9yg/jJ3issKY+7TVbU3N+icnjoB0=;
 b=fEMH0fFkl6FBca/2HTPFASUouL2gkvin3lkEn7ucHyg0wuvc/3WsrNQBODe0gSkJhzuDPtINYG3tAcxCM1fRCjHu9xNDZvThoPBbSL/NMvFK8/bEjZ6V6lcsR0yZ+5f8ShikgCICj0Ck6lVMf+ENW19vT37tbCaMJmVkGlvH88dmn8GkJXf7P/Vlhj5I/K2kYW4T1qT8+iexRfKyTeV011jTZaiVlY9m3u1cYgKQIimycMf3hAZ8kM+FMz9W+ldY/KvIolae/XT+yuRqFi+bEgQvuGAOjIJ7D3kcqgJSEfJeEFiPkEttLgWC44388XR4+PT9OSgmgsCAs7GkLPgxCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by CH3PR11MB7721.namprd11.prod.outlook.com (2603:10b6:610:12b::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6500.35; Tue, 20 Jun
 2023 02:02:44 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::4f05:6b0b:dbc8:abbb%7]) with mapi id 15.20.6500.036; Tue, 20 Jun 2023
 02:02:44 +0000
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: Brett Creeley <brett.creeley@amd.com>, "kvm@vger.kernel.org"
	<kvm@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"alex.williamson@redhat.com" <alex.williamson@redhat.com>,
	"yishaih@nvidia.com" <yishaih@nvidia.com>,
	"shameerali.kolothum.thodi@huawei.com"
	<shameerali.kolothum.thodi@huawei.com>, "shannon.nelson@amd.com"
	<shannon.nelson@amd.com>
Subject: RE: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Topic: [PATCH v10 vfio 4/7] vfio/pds: Add VFIO live migration support
Thread-Index: AQHZlZ4kU3Fwl99xbECsoSBHo1JwW6+NFosQgAUWbwCAANnr4A==
Date: Tue, 20 Jun 2023 02:02:44 +0000
Message-ID: <BN9PR11MB5276DD9E2B791EE2C06046348C5CA@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20230602220318.15323-1-brett.creeley@amd.com>
 <20230602220318.15323-5-brett.creeley@amd.com>
 <BN9PR11MB5276511543775B852AD1C5A88C58A@BN9PR11MB5276.namprd11.prod.outlook.com>
 <ZJBONrx5LOgpTr1U@nvidia.com>
In-Reply-To: <ZJBONrx5LOgpTr1U@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN9PR11MB5276:EE_|CH3PR11MB7721:EE_
x-ms-office365-filtering-correlation-id: fe47ff54-6db4-4c39-9fcf-08db71326ff6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Yge7DEZqjfKpitMJq33Ss3//C8Xt4AKp3l8d3fLAY6X1h8Q4NKAbjkhOzt4+VmUWgOeVfVe5pNc8W1v3s6IaPlFJdu9aepEgwDkxVYdUxuqPQFRQhxLkFB006/W7pGGxKCTZYCAfDwAJ2xnpZe2mtEX5nPlpXgOoX28lnF2MrTTT6vfM8TW0Akfo7FujRRbBOgqLtbg8uCrh5STuzb+v73bJd7YVi7TEz6Cu7sOa5OluhI6P4omTgW/5en4nlfJlfAynyckeU7vSWtTpcxvm2J1hJtgIbG6fOaPreSLiCka+tn1RX6izHjliyxzYb2aiT/2aAzmtI1WOK4nVd2YYy6ZzwAimktA+xXYRXlRTZ6fnnChLQo9rirB66DZkCWYH+DwgzxwlRiv0XT7mIjyBv4LnxFOaQ7f43PiF6DsvXGrRYa42l4uz0C7wQhta1Y+vDrmxD3cFp7wqzkWHpDiMzj31j5t3IaTJDc2bZklTa9IpY7dxPTO7syySpeI1nz0IBnrfH1GUeGhbm2qDYAaKvgy4vSwaE0RQYmO1iY4W4EHdRy04VeeU889WvIKFg09NX0aV6/6bcxJIg1SjoWRiVA+cojcu/pA1DALNjbvZFAlnHftMNLFh+MJolEcpSLvc
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(39860400002)(396003)(376002)(366004)(136003)(451199021)(478600001)(52536014)(5660300002)(4326008)(6916009)(66946007)(76116006)(66556008)(64756008)(66446008)(66476007)(2906002)(54906003)(41300700001)(316002)(7696005)(71200400001)(8676002)(8936002)(6506007)(186003)(26005)(9686003)(83380400001)(66899021)(122000001)(55016003)(38100700002)(82960400001)(33656002)(86362001)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ulflq38q/Feplq1gjQ1BU+5BTg2+6Kx4xxKOo7PXtQs0OL04g/+6/CqPI4Ss?=
 =?us-ascii?Q?V1rklz1H6zraRZcmWK3gDpJ9eRQ4BLqb6dZCJnDJ5SmWQa8z45UJAfTlCVm+?=
 =?us-ascii?Q?6YjbFW5U0nZatjGCrK8+kUKbVsvuimrzJYQjuSBBspp0Kz+DzT5bq3ScxG79?=
 =?us-ascii?Q?5ZtAdg/SHgSIGXLGO23uP1L8S3ErHDyeG5Wf8RrvEihQTNr+OCczcE1LzmjI?=
 =?us-ascii?Q?IKmZaVGyiiLaMjJLEt+dLq+wv9TfuOu+nPR40eScN5PF0mRnlyQEQ6SMY+jV?=
 =?us-ascii?Q?LNVMjRaZNL/7a9VUSLatCUcEhR2uSHMNF3I88VtI87aEAiOdPluvc6Y7Ev32?=
 =?us-ascii?Q?fo6IIRQ/hHGfPjSG3YCegLLnZPEbQkzQtrQ5hCfe9aezNDQyHoYLSHI0H51Z?=
 =?us-ascii?Q?0+FXSVzIV6ZPnzvIQjqrPXZgUARYUT28QALMrs3DFDJE2JEWrzhUPUWbQH6q?=
 =?us-ascii?Q?p3RqwIv0hGb6ooETABhOhzdGUQDl48VgUnRIYioiMM5RAkaigiU3zpehZGCy?=
 =?us-ascii?Q?TUmNM3buJ0cEphnUpVym2lHASvCvo7P5kuSl3PbA8QgQ1e4/F6szpjlzWFxn?=
 =?us-ascii?Q?9XWmCoHozI5bvVx2tty7er46MPZL/0t+o/lZgSzlfBU6CNEPQfnnKW5rLCIc?=
 =?us-ascii?Q?l4tc89wC/qY1YbBtKKUs4mIn/BgtI1dfIpcAWz5Dn6Z3q5PMljK/ihyVg56p?=
 =?us-ascii?Q?Fg2LsbCTX2E+ofbxbht6RA4QULfgndJKjcxohC0jLThK6RAE+TIu4Am7e9a1?=
 =?us-ascii?Q?Gyqg7s2aCMLhCZewFjpscqlwT0QOJJcjZVs/2aukSFQQX1QAHS12Q+BnfG22?=
 =?us-ascii?Q?4luPcvT/3PlMbz/fF6RuBUcs4HG90WaZVbHZ+f+V4Cn/+DKqWJvK0MPTRENl?=
 =?us-ascii?Q?r7xdvL9I4XcWAUNzxA/kOzcufXtLsywVK3la+HeXDxJGs0IWGxQDXZRv85f6?=
 =?us-ascii?Q?zgA11ucaHBKUpEY3AApME2Avt77FLaJJOg9ejdjAxrQdZd0j0IeUJevqGiwh?=
 =?us-ascii?Q?pCUeWSn/0I5ycR4p3r/cZls0gChemMkPmwPmPzmUSiewrS5fSZorBOPb0i/W?=
 =?us-ascii?Q?boJCi2OcgqW2pjQCo4/HjRLkCzEdL/xHwJ7lPfsEeesJYGH1BUAKjFB/vJHM?=
 =?us-ascii?Q?Kd9NCOAsRQ++6WpIgB9BZ9j6izQ2dsYBO0zoJV76ZBHHH2fhghbLKjM47jHt?=
 =?us-ascii?Q?xz/6R09fBy5xMb/yd+1Azo8h/i8tgP2c6AtY2+w0Xi/OKgfZgzSLXe8ihwLh?=
 =?us-ascii?Q?ymtfBn5BDEylzBKo051U2bc1IXCsal075uaEx81KlKy5npL/1fuoNwTBNrUw?=
 =?us-ascii?Q?aQlZePfp8kdge77u7Jd6ChNXedVAO0Z2F5Mu7j5+XPFVPZx4kjq0q6uMhsXi?=
 =?us-ascii?Q?q1HKTFljY42mj5MD2glsUxDhZgz/co7yE7DLeqkhc2ueXZDCY3B3fjj44HJE?=
 =?us-ascii?Q?gNBuGb7qijyLTRLY9VwtXS4tA2cqZx1wXFvYwaOcG7VnLxG8HKRpesIs1PNS?=
 =?us-ascii?Q?cL6rSHic/ZVmttIh6hffIgGGOCyy/uu+lqFJb1n/ryZDXp0I751qZYEPTSFV?=
 =?us-ascii?Q?iSWqa60n/tbadbv2ojPYSXFl9JHEFWVxZ4Z7i2wa?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fe47ff54-6db4-4c39-9fcf-08db71326ff6
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jun 2023 02:02:44.3452
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OP55CldnrbRB+IDaTTJEDMjfpB2wd5U/8vHyzizvgKWcp4NI3qmncqCFALxB/JiqJozrh6DlxBechfmQ4YwRKg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR11MB7721
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, June 19, 2023 8:47 PM
>=20
> On Fri, Jun 16, 2023 at 08:06:21AM +0000, Tian, Kevin wrote:
>=20
> > Ideally the VMM has an estimation how long a VM can be paused based on
> > SLA, to-be-migrated state size, available network bandwidth, etc. and t=
hat
> > hint should be passed to the kernel so any state transition which may
> violate
> > that expectation can fail quickly to break the migration process and pu=
t the
> > VM back to the running state.
> >
> > Jason/Shameer, is there similar concern in mlx/hisilicon drivers?
>=20
> It is handled through the vfio_device_feature_mig_data_size mechanism..

that is only for estimation of copied data.

IMHO the stop time when the VM is paused includes both the time of
stopping the device and the time of migrating the VM state.

For a software-emulated device the time of stopping the device is negligibl=
e.

But certainly for assigned device the worst-case hard-coded 5s timeout as
done in this patch will kill whatever reasonable 'VM dead time' SLA (usuall=
y
in milliseconds) which CSPs try to meet purely based on the size of copied
data.

Wouldn't a user-specified stop-device timeout be required to at least allow
breaking migration early according to the desired SLA?

>=20
> > > +	if (cur =3D=3D VFIO_DEVICE_STATE_RUNNING_P2P && next =3D=3D
> > > VFIO_DEVICE_STATE_STOP)
> > > +		return NULL;
> >
> > I'm not sure whether P2P is actually supported here. By definition
> > P2P means the device is stopped but still responds to p2p request
> > from other devices. If you look at mlx example it uses different
> > cmds between RUNNING->RUNNING_P2P and RUNNING_P2P->STOP.
> >
> > But in your case seems you simply move what is required in STOP
> > into P2P. Probably you can just remove the support of P2P like
> > hisilicon does.
>=20
> We want new devices to get their architecture right, they need to
> support P2P. Didn't we talk about this already and Brett was going to
> fix it?
>=20

Looks it's not fixed since RUNNING_P2P->STOP is a nop in this patch.

