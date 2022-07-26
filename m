Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3855580DDE
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 09:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237679AbiGZHgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 03:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238545AbiGZHgf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 03:36:35 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE3E12C10F;
        Tue, 26 Jul 2022 00:34:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1658820899; x=1690356899;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=yi3YJhpm2KHfJ0BB8ET3DA9cepiPQdg5Fvirg//m18s=;
  b=lqrISMkrdykbxk00NonCPFOBxslFRhDxFNECLu+OrzwCHLRzp9+mLMhd
   5EzJWwMGL2zFR6kK0TUrIPtdKLifGcbsMpbu8DybRelDZgvK9gLtrtlr2
   /i1rZBqPOCXxBTmrNHtaD//iTGhvP5dTNMLIOWSIyFCR71i/kEwPcmSuu
   CICFcqqm/MSFGXxt3VEtHWdnZQj+02UttGe7NKmv6K+zpj4JKCMdFM/Wi
   HxVuOD53QNV7/QoScKGZCOUSvA5QdD48f9+kopqqsszOK3QDbWKeT3TuU
   kN3SA9Ys8fuQSesCTFRvYoe3Q2ayUaBOs0e3giqnfU5fDuN3YTsK5g63Z
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10419"; a="267653793"
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="267653793"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jul 2022 00:34:59 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,193,1654585200"; 
   d="scan'208";a="927225054"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jul 2022 00:34:59 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 00:34:58 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Tue, 26 Jul 2022 00:34:58 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Tue, 26 Jul 2022 00:34:58 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.28; Tue, 26 Jul 2022 00:34:58 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=T2OH1dw2aP7ry8cb1pjWTnfhVIwb/j8dpYpTON/5xgB2smwwjjzWpKYOJY0DR/HbEJ6KCAYnjnnYz9+unN49f49XoNeXAE70dWM9WVUnGcVp3lDY3hBB8btcTDIpGulUUzezFQsYFj14wqAgzA6jtSQVQ15yAk9x7tKZqRig2MzbNfhN9gQXnpdaAuu7J45xqgfdl0BDmcR03Z9AE02Aj3J3TMmmohgtXjXHDWUZfXReR2Q3aMytWikY1eb+4vMDGecgRzQtMCxYcVokacQDcYxdQxHCTGk+XtHNsp8tL90griKTXqNF2jDTI5fETrht7EGd6onnndOo/EEGIgYRow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vx7UfyUj9DJmDwzxDoEf6Zgfn54odfy7FK/tqbC2ThA=;
 b=fyUVN/YMUTTtzjcl/ymEfpwwmqklmXdAO8dYADYOcN/m31CCVO+EE7uzLb3MowD3aRJF9qKBErgxFANBHmiyah/7qoTrKD7vL/AiHggdN2ALpS4/LaDD0PyUBe+XIoNEQf9vysHQyXCEEbrgkK9kl9yL196n/vXqONKzZtKnSGzlB+wh9Tw5nkp87f5M9nyYyiPFtxnn340JnNPDrJoHGUMZq4W+C3hwKjFJOffTy+sd4UBHFx0QL+D88D58D6xGptCPoJ8h4OBpN02Il3Wxq2faip9KYrTOmIqerRvVhCyqNaHbuINneVppX6FpLvsmJLAbEQ7+8vXwlj7yDeAnCQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by SN7PR11MB6558.namprd11.prod.outlook.com (2603:10b6:806:26e::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Tue, 26 Jul
 2022 07:34:55 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::8435:5a99:1e28:b38c%2]) with mapi id 15.20.5458.025; Tue, 26 Jul 2022
 07:34:55 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Jason Gunthorpe <jgg@nvidia.com>
CC:     Alex Williamson <alex.williamson@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Martins, Joao" <joao.m.martins@oracle.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>
Subject: RE: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Thread-Topic: [PATCH V2 vfio 06/11] vfio: Introduce the DMA logging feature
 support
Thread-Index: AQHYl1nR/iQPrmnWoU2t9zhNVHHxZK2EvT4AgAC1VYCAAKlDAIAADBGAgAJmxqCAADLPAIAGARcwgAB2vwCAARcQQA==
Date:   Tue, 26 Jul 2022 07:34:55 +0000
Message-ID: <BN9PR11MB52765A281BFF7C87523643BB8C949@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220714081251.240584-1-yishaih@nvidia.com>
 <20220714081251.240584-7-yishaih@nvidia.com>
 <20220718163024.143ec05a.alex.williamson@redhat.com>
 <8242cd07-0b65-e2b8-3797-3fe5623ec65d@nvidia.com>
 <20220719132514.7d21dfaf.alex.williamson@redhat.com>
 <20220719200825.GK4609@nvidia.com>
 <BN9PR11MB527610E578F01DC631F626A88C919@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220721115038.GX4609@nvidia.com>
 <BN9PR11MB5276924990601C5770C633198C959@BN9PR11MB5276.namprd11.prod.outlook.com>
 <20220725143706.GD3747@nvidia.com>
In-Reply-To: <20220725143706.GD3747@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e321fdc9-7af5-4852-29b8-08da6ed955fb
x-ms-traffictypediagnostic: SN7PR11MB6558:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fKYAwq6rgQbKeOS/LRbgtI+XM4S1ak6vcKTNQUEJFwPHBWx2DBkKLqPmwR0NZcnVwVZ77JROQMizsMkFRan/T9YPoZp3SFcK3E92J0vIolk687EmQz7B3UcPsFM0bruSfKDjxp9QZX/lxMoR26uzK9tHgD1XPxCvEhozu+8YQmcCod4ay1ur5R/+V5gN14V7F1b99IY/iX/Fv42ThPkBELh0ptpv689/hXGNpzxETdE4/HqYsygAKNOFAJrp6WVHa5kFgMsEMCCjcwiNJWjzLXnjqbg3CFaIlk9tLPrDzGq3f83+FuGxzUNK/QHFFfOY7oGiXTtoMP1TSaLOrtCk2q3Qqk8JM+JmbcsKsicfydDarrL6qUEs9DAZswNg+WAqzo+XypYCsXgcc+/HVtFeVk32EpeJ0l2MdDCeLLTwiEqrVHrQ8K0FZT8Uk/FCjhkrX/N+TdZFL10AtgBda9rp8/vcdEC/qNuX7hfgU4gWBhJ6wTrWNIru0vSYe7utQ0xK4RMouVU0mDSwY6QKmpKKbQZ//doNhM89SRJIo1bt88JOWxCRmdik1q2gy8LCdYka2zM4JpD3CMIjUVe6EXg2RT3va1WpcZKQ8OP1u6uhlls1OyenMusjc0By/gTBHdx53qz7ITt2jJH7kKZQVGBzRE4otXZWB3DdHSZV+s02T2BwPhDXk7Kdwiea0mOH/gFrb2xYpIz32XXYFEcOgABC5g5pMptblfMdVVtJswdH8XIcecQIakQ1Ay3Z3K3AmtOyEeFfYVl6/urkxM8vKIJbvzT+dweYJaU9OQNp+7AK3CFwOTmAXWH4cVMTloAvRs3O
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(376002)(366004)(346002)(396003)(136003)(316002)(122000001)(38100700002)(186003)(54906003)(6916009)(64756008)(8676002)(4326008)(2906002)(66476007)(66446008)(66556008)(66946007)(76116006)(7696005)(6506007)(9686003)(82960400001)(8936002)(38070700005)(52536014)(55016003)(5660300002)(71200400001)(86362001)(41300700001)(33656002)(478600001)(26005)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zN3q0DwrbDDwdAQr/z3d/8iRGHbAq2Ra62QzaoHto+OSb8mfsPRwEp2TSOUg?=
 =?us-ascii?Q?vM2p0SZdrJJCy6AUpOuTSDm8HaIHFZ1Bvm+YSOrfRJ+Vc5iPpRaUMamS1znc?=
 =?us-ascii?Q?+0iLxoushu7rX5GRvJqQIQ8/UPtIQVveky+cuv9iU43Gg+MGVTO2AmFfJEbp?=
 =?us-ascii?Q?ByIxN2Wbz3Univ4KAVR0CmMKN7kc99gulbQVB1FdHWg5U1yzicpCBXUAMGdP?=
 =?us-ascii?Q?xJEPR0Kb6zmIG6tzZWIHdlrtj9iTH7MYrxrt4AUe2oGhbIq8J6HRm1FxiHJf?=
 =?us-ascii?Q?MhfZ+gooLHZgNy0PJOkE0v4xucGhceqQsjJGl4kT1xkEfbPlxwUg8Xi4wdjO?=
 =?us-ascii?Q?DWEU/jnQDi2y7+FPOj7HzY50SVSqETx3yLbXcTQ45b6d0Xai9z2+o0/jEAda?=
 =?us-ascii?Q?lvKxoZ5tiYPy6k7zFUF2NCZ5aQiRhdU+Ru2NP28Sbcs6OGCm1v6ByquzFMhu?=
 =?us-ascii?Q?ol5XIAHuVjJ/Y3d5Kg9p7W+HDlHKQ900w4TayONP+S2965ZPk/nwIoPaqwNX?=
 =?us-ascii?Q?i1F5KNYIbS6mxf/s39qB4iVuUo8E7tljChw0K7MvFHtzqAiwFJN0VYgQSTus?=
 =?us-ascii?Q?DlOv61DduqV081noqpprncR/3UY2tX6g+yFG0GkBai6GHUdadptbTQFyBusB?=
 =?us-ascii?Q?jPhgwrjYJnB5Xvxli9ilBfSSdQ7LrTW1ZFnEKsKtMPNLW3M6wu0dSALeyFuu?=
 =?us-ascii?Q?DYSlNbwwAmYMtoJCXmUBlpeNOn9G4HE8SNkd9C1aLf6V+M+hvDfJ8Qf7jArU?=
 =?us-ascii?Q?fjME066BbJycmqnNyrJdm6mfBhAHqHLS9OaG4ylRNCB61oliBpQAJxlI2u84?=
 =?us-ascii?Q?pCVGQhPfvFs6C/LbegZT0jKKGA6Rb79O5QF7TKT26OjfjoEMyceU1LUYSNHF?=
 =?us-ascii?Q?kEvhdPHXMBL0p/pso7fJ0F3gKekiP4A1fvBTbu4bnfyV+gZwrzeQAUTxuQo1?=
 =?us-ascii?Q?FkQx2npPpFJdM5QR4iibM36i8QC3g5ZCXjPDJJ5Q4h/7ViMtmPppCfgTVKmV?=
 =?us-ascii?Q?10/O2eKhDW+s61T7agsAKP9sH1bBEyGDYm5xsjRW+efj7y7Y37Vd/35rFBkr?=
 =?us-ascii?Q?wnrVWAW3uwy2eKsC6Scav5FZlCNtffrEnuh0Xr1wctBTSvyrBjgO782zecKq?=
 =?us-ascii?Q?mHiJrTPn8KnkqYM3tNG6cq7Dhjk4atAtnPTjEaVPqo3mXGS5n8Y2t6044nMp?=
 =?us-ascii?Q?tVG5bU9xd0tVnQlneqAcDnkxBNW0wuWrUuE2SXnA22os0+PejCrSMLkQCrss?=
 =?us-ascii?Q?1UwKl7PcBc9dKtKXWNbF4yig021BkwFo8JM8A/+rCDSTU337LFhNtjJJxLkn?=
 =?us-ascii?Q?8t4ee7YBlPHjCr0SY+xNYpEweKlZo0dGkUFHMDTCm6s1uQNsQaBhGxA7TtiL?=
 =?us-ascii?Q?3De3XNyc0awQxq5kO4nE6YtX7MiMoroG7y6t5b3P/2C9d5+MXRp77UypkV/r?=
 =?us-ascii?Q?nFMLEqb31N5Y4wwpYsrTt8TExIgk/Q1RRFG/OIZWZIyCqSxTnj6XwbXi15d6?=
 =?us-ascii?Q?vzWdi1zCdSbTb4EmHqum5HnKoqBdg08dtWXsvQF/+H6bDvyOXfQf5Nr0Imdw?=
 =?us-ascii?Q?9RoYZSK0D1H8cuV95a8MAiDD/Wf21p0KmCNHOBb9?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e321fdc9-7af5-4852-29b8-08da6ed955fb
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 07:34:55.5672
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9+j9sBuYRSJQRyh+zO/N7wvQWaj6aGm1iT3G3QflhpT/ZPXa/h5tminAbxqZU45LQBtNFNtNXIOivzLuZ9NxlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6558
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Jason Gunthorpe <jgg@nvidia.com>
> Sent: Monday, July 25, 2022 10:37 PM
>=20
> On Mon, Jul 25, 2022 at 07:38:52AM +0000, Tian, Kevin wrote:
>=20
> > > Yes. qemu has to select a static aperture at start.
> > >
> > >  The entire aperture is best, if that fails
> > >
> > >  A smaller aperture and hope the guest doesn't use the whole space, i=
f
> > >  that fails,
> > >
> > >  The entire guest physical map and hope the guest is in PT mode
> >
> > That sounds a bit hacky... does it instead suggest that an interface
> > for reporting the supported ranges on a tracker could be helpful once
> > trying the entire aperture fails?
>=20
> It is the "try and fail" approach. It gives the driver the most
> flexability in processing the ranges to try and make them work. If we
> attempt to describe all the device constraints that might exist we
> will be here forever.

Usually the caller of a 'try and fail' interface knows exactly what to
be tried and then call the interface to see whether the callee can
meet its requirement.

Now above turns out to be a 'guess and fail' approach with which
the caller doesn't know exactly what should be tried. In this case
even if the attempt succeeds it's a question how helpful it is.

But I can see why a reporting mechanism doesn't fit well with
your example below. In the worst case probably the user has to
decide between using vIOMMU vs. vfio DMA logging if a simple
policy of using the entire aperture doesn't work...

>=20
> Eg the driver might be able to do the entire aperture, but it has to
> use 2M pages or something.
>=20
