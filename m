Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03DAF4B7ED1
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 04:50:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242220AbiBPDR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 22:17:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237453AbiBPDRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 22:17:55 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51DCFF94FE;
        Tue, 15 Feb 2022 19:17:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644981460; x=1676517460;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iHljoFHe5KrjjeCCFHLiF0DZrB1WVO55PLmk4gFiWeY=;
  b=UlCbsGRfJ7neO2WyipWELJdR3itVEwz2b84aeIUQvDdMD7OVtf3cWqrQ
   HjOCBNPXlRH4csryv4KbhvQgiqyiLNPsxzTRHO3DByZhlZ+vACqatjK0M
   6ireZxNvKO+mou656oQhATqdvptNL66kZr6SkHSzkhBHZlbZOl0kUBej4
   fGJEf0zCNpR2T5X0Yd3U2NBpF9bvULAXfXdDTnDyg5+V4kKTU+vN/BHeS
   4GrUfEjQYaVUw5Eh19aAFDnWXtw6+d0FINfaOTY3+nbBGmhqSweeMAcSm
   YMNO3uke4eCGmnt1ov6BRNSwKXQc/t44tLWKjh/K/oYyZHXl5SN/dx/Aw
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10259"; a="230476944"
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="230476944"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2022 19:17:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,371,1635231600"; 
   d="scan'208";a="544656499"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga008.jf.intel.com with ESMTP; 15 Feb 2022 19:17:39 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 15 Feb 2022 19:17:39 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 15 Feb 2022 19:17:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 15 Feb 2022 19:17:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hj3jOnUgKzhwYOPP4x6x85T0ZSly5Zds5tfbZAvaKmK2w9lAOUiWHsFoTopiRsJNntXTQnQ9Is8A37XUNzcNK3uvSnqciQmr6oPbkSaSqh18d96hvNesHsgs2+HTskHNornI3sEydKFonaadV69kXTu2+122SA88Et+gegbrYz0SAXglN4BkFijQ0e842VQYtVeYTjvXpkUwW0NqDpUg9J05ZJLfLu8ShOXSVJo7kQwg1Iz8LgFcbsnuNYi7Ztg11s99pGRb28OA22MNPFi2I4CDlOEHj36VRWxAL/jBkoFNW3rjAuC6w1lTK5m2FZ1+o9B01IuArnd2dk8ptcyH4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NPPrMPxKNDUHNxCGPvYBYmzfjjbBONApOT4vz0VI7V4=;
 b=Q//3bJG7UMv/8qOsbBa7tVuSOQct3wJuVlzght1Tmp+1y8XMfonLpEsuNj6iZAyuUwY+d63ttk95R5TILiIou/Xvbdrwujts9Lm1+3zxjGz1l/1FJqSt+l3SAcygYxZntf8WjiRoOMjq/VGXhNc/4ZxLNvc11uXrWMw83u+d2+euiEkRYNo8GdayKLG1lCkhHziv6vdlh26DzcafpVxFXV2efqLJPOodPad3bAAcI6RNObukzxuRBIfUxqgpyjpzegeYuJa4Dr30O1Tjwd/c7aIt9AyHsvYVkyqkA5StfUh/RmoMZ4ouz4u46lRp6m0OPtYFv/a54vtVsrR+g3vPRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM6PR11MB3372.namprd11.prod.outlook.com (2603:10b6:5:8::31) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4975.18; Wed, 16 Feb 2022 03:17:37 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 03:17:36 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V7 mlx5-next 08/15] vfio: Define device migration protocol
 v2
Thread-Topic: [PATCH V7 mlx5-next 08/15] vfio: Define device migration
 protocol v2
Thread-Index: AQHYHEd8WrQ75CuCwEmQ+4nXbJWyQ6yKWZwAgAAploCACfA7AIAAX2SAgAC4ipA=
Date:   Wed, 16 Feb 2022 03:17:36 +0000
Message-ID: <BN9PR11MB527610A23D8271F45F72C1728C359@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220207172216.206415-1-yishaih@nvidia.com>
 <20220207172216.206415-9-yishaih@nvidia.com>
 <20220208170754.01d05a1d.alex.williamson@redhat.com>
 <20220209023645.GN4160@nvidia.com>
 <BN9PR11MB5276BD03F292902A803FA0E58C349@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220215160419.GC1046125@nvidia.com>
In-Reply-To: <20220215160419.GC1046125@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a24e10cd-f80d-4cb6-228b-08d9f0fae1c1
x-ms-traffictypediagnostic: DM6PR11MB3372:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM6PR11MB337278E8B8B44E15A45C5B5B8C359@DM6PR11MB3372.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uxD95CVhBqW7qLgPHRH1J3UdbYXAQQf4fwIAFX9erJgFRt8MQyJmKEgRzq+TMJn7Zyc6Nz/ryvRr5fRIP1QzhuMEe59jSpNK5TwfIXl4a8ljXsfa0HW+xN4VDBDXq+bXdQUnv8462DRq4iKU6+R46WazlcxzUDqbmPxek6POzewmIzILB06DWbvUIfndwMbvLeQafoTK7aHy0CyAc6HgDuIaagDh9vOzEaOrJCnEOWdc8D2lU8t4D2OEaIlv1ucH+Lz0VDwjn9Zkz2PBUnEX+1PkhSSqEHGu3uponUfEFkLh/LaZa6gLPUfnC5xKsZW7+Kkk9jJ53uXrVLyisqDMrTQWl3QI5iSORj84psaiN6nOrhz54gAEo1jjOeBIualm22hoDGY173Is+qAaF9SNIw24Yr8xim/1YSbLWLCua59F4LWGBvO/jRnnsistwFsXuXSUXfOTMsViINVbpO1nbE31TSrKjQJSJkBYR/8vZ9f49kqR7zt5/7eljm7zUzWhNZPexiXfC8g8i+twW6GuWBjHdAhILzp3dj6K8vll7nRLdhtOblYsJ1a3/CK8W1K7Fv3PfHrOlr7p00arCvr5R99Ndp3e6DkxPIfNMmYeUoUZMDWRTDvtZhjEG/5C3+pbYdOvJAGSVkpMLF4oEqLSTG74P5F2cY8qWlzUCPl7oEI2zVypx5Wm3iZM28Rw3NYsKTn0N6u0WzNueVf7CORZ6w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(55016003)(38070700005)(5660300002)(33656002)(66946007)(186003)(8936002)(52536014)(7416002)(2906002)(76116006)(66476007)(26005)(66556008)(66446008)(4326008)(8676002)(122000001)(82960400001)(64756008)(38100700002)(508600001)(316002)(54906003)(6916009)(9686003)(7696005)(6506007)(83380400001)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?j7jUbRiQTrf3/2Db3+L2pQ8z96A1JU0j5ODfedRg22+0uq2/9t0nTjVYVLMo?=
 =?us-ascii?Q?UepBIVxX7epo5JBRdJjTBwx1kM5Xp9AkEz+cNsVLhCooIJDjewiSDVpVjpxs?=
 =?us-ascii?Q?Neue4doDeBcniCt1Nc+jhRb7EQvaTJLEUHiDNIUrQxvb7vP/+95WwJa60PsW?=
 =?us-ascii?Q?oTKV6yxBufExtrzQ8Q4IGrEMn6bZnpEt/fdNNKXDw6kUOOVs8+9rZQEsQaVQ?=
 =?us-ascii?Q?y4iPRlCMbU5eXnbjsBAdELQFLtmMGN9I6cqo1HMpZakmKw6WA3WLqLgvc7dI?=
 =?us-ascii?Q?InqIUqqtf3RYFuPntXH1vQ/B118PNCU7P534EVrMTVun1p8KDMFJ2mwhtM16?=
 =?us-ascii?Q?K+1Yk40jl53rJ6nZtlGC3CrATvgeNQhqx9hXZaYjmbXzM19OwvaTctA+0V7x?=
 =?us-ascii?Q?Y7aa86wx4JaDeVvSXBmscoegqJ8sCAoWfBn9eNJ/FnmIg1jz9qL7sTZKgLGF?=
 =?us-ascii?Q?hEKhwaPUIbAc/+92v7Srgp/JGi9TqYllhbLqWJsTJo1qPWqtCdqMen0wJQ7u?=
 =?us-ascii?Q?PGS3jKtO1w7nePUOfeH6inUGzD8IoGCs9Ok/MLhm/Cp59FoaLrKxiWk+uMRQ?=
 =?us-ascii?Q?GISYK08SwX1VTD3nOBd3JcTCk/b0C4xWD7nbForSfND2pzmn6aYmg4vU5pEJ?=
 =?us-ascii?Q?nG2CymR+cBVs8g9W+I4BUt3Eedzqza8eG8UnI4SCwm6pwUxIfqroeXHn6kpn?=
 =?us-ascii?Q?Wy/qO9wyBqyVXFK9ywvi+XmJeRmFQAvrsUa5IZrySSjQCYdnrrX/Qy+awZkj?=
 =?us-ascii?Q?mNBs0nCWcOVePx5Hyf2deCHiCadzBYu4ItBEz/yy50BbNvLnc2CuccX2lbRK?=
 =?us-ascii?Q?WkgY+872lWnV1Xn4OKFtUE0iVpWNwzRH8fGMIkn6qpNKdBbWRIEQncn7BIiG?=
 =?us-ascii?Q?5LDznCOvFrMkYj7umk+DJG7TgsgT/ZYPmL7GgA8NkC829Jw/LNRlOR7E5593?=
 =?us-ascii?Q?jnT0CkATkBZXMcXIXypbn2agS6FF6hX0rZV0JlPAxONDiUU8l7p9LiwJ73d0?=
 =?us-ascii?Q?XmlLMCwVwr9Rvdtne9QFQ5Y8BM2V0UpB4X7eieTix/cfKj8bmne45OeyY3op?=
 =?us-ascii?Q?dDHAE2G7qJuh1QwBfaxh3oO6KGXLXJ92DAWgykn1sv630pOGvIX3OmnMuK6a?=
 =?us-ascii?Q?t80T+/y96C5wOfj5q4I8b0vj57WupZOPercGu/9z80DwOvTbvF/TT1W7op0t?=
 =?us-ascii?Q?8afj5MQvKnb5jiAfCIUd9FVhxbba2lZZH1nvbqc5Q9cDT0LqjM4e2/lRr3jH?=
 =?us-ascii?Q?NMQiwU8YwT1b0vuE1S68s3uWJzwQQJQNC8MbLc00MD6KEUyPxyZeiw8pb9uE?=
 =?us-ascii?Q?KSKGyxEUsbAsDguQ+fXVCkqNAEqYIGXgnvNLZXq6MffduzkV9Zs2Fspzlerg?=
 =?us-ascii?Q?ZIdZMWJpHfnSbAs0HibC/rirkpOtKwwi7MJ/dagzJc7dq+VSvhTgjjWbmEgq?=
 =?us-ascii?Q?2D5xa7YjMDsc7gq1hAnsoqqWfcM23iWBD0yXOZGMJn9vFXvyRjhqT+WIUInR?=
 =?us-ascii?Q?XOccVrf3KdUd0ImZXZwLiLTpS0ihVcQmLfU0r5HyR9camxpgMS8u59jEBAmu?=
 =?us-ascii?Q?KUQyIbq5xSZL04wLjjQoguMytJm/6SGLr3dlE6eeeHL91mo5nMoOi69gKlzM?=
 =?us-ascii?Q?lx/ANvxI6xPHHyUwRTvHZn0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a24e10cd-f80d-4cb6-228b-08d9f0fae1c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 03:17:36.8251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hZc9kHd2g+KuPk32kV1+zYwoQyvxuEI0m0mLREkUjdrwsbCsXgDtmwLAz+UEsIsT7hxDIDg83Ph32FuJCays+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3372
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Wednesday, February 16, 2022 12:04 AM
>=20
> On Tue, Feb 15, 2022 at 10:41:56AM +0000, Tian, Kevin wrote:
> > > From: Jason Gunthorpe <jgg@nvidia.com>
> > > Sent: Wednesday, February 9, 2022 10:37 AM
> > >
> > > > >  /* -------- API for Type1 VFIO IOMMU -------- */
> > > > >
> > > > >  /**
> > > >
> > > > Otherwise, I'm still not sure how userspace handles the fact that i=
t
> > > > can't know how much data will be read from the device and how
> important
> > > > that is.  There's no replacement of that feature from the v1 protoc=
ol
> > > > here.
> > >
> > > I'm not sure this was part of the v1 protocol either. Yes it had a
> > > pending_bytes, but I don't think it was actually expected to be 100%
> > > accurate. Computing this value accurately is potentially quite
> > > expensive, I would prefer we not enforce this on an implementation
> > > without a reason, and qemu currently doesn't make use of it.
> > >
> > > The ioctl from the precopy patch is probably the best approach, I
> > > think it would be fine to allow that for stop copy as well, but also
> > > don't see a usage right now.
> > >
> > > It is not something that needs decision now, it is very easy to detec=
t
> > > if an ioctl is supported on the data_fd at runtime to add new things
> > > here when needed.
> > >
> >
> > Another interesting thing (not an immediate concern on this series)
> > is how to handle devices which may have long time (e.g. due to
> > draining outstanding requests, even w/o vPRI) to enter the STOP
> > state. that time is not as deterministic as pending bytes thus cannot
> > be reported back to the user before the operation is actually done.
>=20
> Well, it is not deterministic at all..
>=20
> I suppose you have to do as Alex says and try to estimate how much
> time the stop phase of migration will take and grant only the
> remaining time from the SLA to the guest to finish its PRI flushing,

Let's separate it from PRI stuff thus no guest operation.

It's a simple story that vCPUs have been stopped and Qemu requests
state transition from RUNNING to STOP on a device which needs
migration driver to drain outstanding requests before being stopped.

those requests don't rely on vCPUs but still take time to complete
(thus may break SLA) and are invisible to migration driver (directly
submitted by the guest thus cannot be estimated). So the only means=20
is for user to wait on a fd with a timeout (based on whatever SLA) and
if expires then aborts migration (may retry later).

I'm not sure whether we want to leverage the new arc for vPRI or
just allow changing the STOP behavior to return a eventfd for an=20
async transition.

Thanks
Kevin
