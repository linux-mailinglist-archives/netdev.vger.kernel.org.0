Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FE5B3F0A8D
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 19:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbhHRRux (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 13:50:53 -0400
Received: from mga09.intel.com ([134.134.136.24]:55106 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229703AbhHRRuw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Aug 2021 13:50:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="216385595"
X-IronPort-AV: E=Sophos;i="5.84,332,1620716400"; 
   d="scan'208";a="216385595"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2021 10:50:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,332,1620716400"; 
   d="scan'208";a="449853743"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga007.fm.intel.com with ESMTP; 18 Aug 2021 10:50:13 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 18 Aug 2021 10:50:12 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 18 Aug 2021 10:50:12 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 18 Aug 2021 10:50:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kmp0kQpWj1Sl18vJOTgmTnAe8Hgs0W2G19KGzWV33MgnlX52owH0UjFqSO8BiuR4h1QYGEkkvgzPD0RhPZTx2hOAildvzx7SjVuPfDzUdk/7dtWPOOwlRNSclOgol5Manv2a8UJOD1Hk91bk4kyzzk2J7CHIiya+zLhGLZneDO6d/bHevu/aJyEva8f/7TKeBnpT38i21k4kNn5XKkDry81tkxjbE1zdlI7wxWSU6JZcEKa5afASX+cExf9mZrAi2IkdTqy5ofnkW+psmWc6rILIcRs/z3htvjrtWrAh3sH85GofxSM/cy/OvGmIrn4QIETBBGfkOKdIMEg6VCLJzA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EMhW90XsCCuFD5/aYJvOrFgO4eMSOpaXNEhwE2z/4g=;
 b=HedkLgyEpT2+7MT97MFtSIYCMLlE0QO3cGb67NYZRaJvCD746Pck/q+JAtJ478e/cUxv8f+BMjjRa14FzDaTS3oNYWErXYJhRCmlZ/Ho+eljb4tRtfXz716jdIIf21OE0+tqlvViovVnAFo7WKXm4n8mu0hW/2knyr5ACh7kGeefvPh8/qkrsK9ud8Icugusrj/bxo7TGjfC/G3J4hIMVEqeXgCSWWjj99nkizc2XUZpeOZZqUTmReaeJdhHE7j6ykv023jcXZpcbfJ8tzeANXJZCH4Sy+euTY5u0Y1GZG11Fenp5Z3JtDDroku5HthnsTpVxTX/hEkDB/6Nammgcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8EMhW90XsCCuFD5/aYJvOrFgO4eMSOpaXNEhwE2z/4g=;
 b=H+NTwpo7BMlFsTcMmnVlrrj4l5fhDAZmwHX3MNQRi0PyO5fUKQ4behvSOkPnNEFNX4jsIh8INFNztl8rMpJoSlTV37PhPnP+Ml3EL009H3fCaE4xSvhgnCbwkVE+VKBu1fDzg4QOEWmaCcwY/kj1C59vFkiLI6xrsqlyenJ2OJY=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4747.namprd11.prod.outlook.com (2603:10b6:303:2f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.18; Wed, 18 Aug
 2021 17:50:11 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%4]) with mapi id 15.20.4415.024; Wed, 18 Aug 2021
 17:50:11 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Jiri Pirko <jiri@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Salil Mehta <salil.mehta@huawei.com>,
        "Shannon Nelson" <snelson@pensando.io>,
        Yisen Zhuang <yisen.zhuang@huawei.com>,
        Yufeng Mo <moyufeng@huawei.com>
Subject: RE: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Thread-Topic: [PATCH net-next 3/6] devlink: Count struct devlink consumers
Thread-Index: AQHXkPLeq0W5yofhY0KH8k2ic9V3+Kt2SjGAgAABsoCAAAO0AIAAWqrwgAJFW4CAAKBNQA==
Date:   Wed, 18 Aug 2021 17:50:11 +0000
Message-ID: <CO1PR11MB5089A7B1E36B763F075E09FFD6FF9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <cover.1628933864.git.leonro@nvidia.com>
 <d4d59d801f4521e562c9ecf2d8767077aaefb456.1628933864.git.leonro@nvidia.com>
 <20210816084741.1dd1c415@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRqKCVbjTZaSrSy+@unreal>
 <20210816090700.313a54ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CO1PR11MB50895F0BA3FE20CD92D79CB6D6FD9@CO1PR11MB5089.namprd11.prod.outlook.com>
 <YRzA3zCKCgAtprwc@unreal>
In-Reply-To: <YRzA3zCKCgAtprwc@unreal>
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
x-ms-office365-filtering-correlation-id: ed1ef734-c945-441b-3755-08d96270a051
x-ms-traffictypediagnostic: MW3PR11MB4747:
x-microsoft-antispam-prvs: <MW3PR11MB474709D1606A160806BB163FD6FF9@MW3PR11MB4747.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LulVVvqmqGlCRJ8uxQDwRxtfpb5n93P5VDDCgtTENKykk7FvSyw1TqmR0AWKiozFmkOr2nRXNnSsRZDi3iLOPpP04MI29MIegrl6ybPhnErag2ZEj2HV5di5B6167Ua2+RzvS37LW6UJbS08HCgbMtKBXJfEMlxwp/VtnD7vjhmckW4KyZTZ3OhLGG0Hdf7JePARQkPAyk41INxYcKXiyfFkjDseBksZSb/YLxtwjUcZ+vi932HnBC/0nL8ahXFXVXggHEcxo8WfOH3pqpP93hxB6Z4Ffgs13CXTd6AXQf22ummjaufBTZq3Eb2tz3WVT5k/savvPL8WTNcFglR31VZIn5he8engVV6r3FjzzA4Ccpy5vrYBoU2gq03XbO/6C32U2tpGTrOnvTbpDIqzklIZNRN99KwNdM3xktsnYp1kE1qFUGqp5QpTdjyr4PLP08KU4+C0PV9gPBTY9e//iAQ7/k4xYoFcn/RYFZmq1IPVnFo5TtEX1qcCh2q/7DP+9D8IEIFa619jbmi/k5D0/26zGVSZDnPltbXCnL9w7AxtQKTVENzNevwoCly+8GVOYXS3uSvooTDo7nxhAlwP9hFtxrcPldkmJh9yASK+8nHwXQMDvBnq9NeUSSvk4pMsYD0Be9gISaiA9VAwRSX6I0zmnCgFkoRLP792QVsepdAJ877+msZEaD1iKB6jdO2DzzgwlUdifAGrjf8pl2sCyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(39860400002)(396003)(376002)(136003)(2906002)(122000001)(6506007)(8676002)(86362001)(38100700002)(38070700005)(8936002)(7416002)(83380400001)(478600001)(7696005)(4326008)(66446008)(26005)(71200400001)(66946007)(66556008)(55016002)(5660300002)(316002)(6916009)(52536014)(53546011)(33656002)(76116006)(54906003)(64756008)(186003)(66476007)(9686003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?AwqRLLbYZKKtfEMQl7eMN4Px/O+Qr8K4k/cvSqLQavTEq20YWtUq6WzwrphJ?=
 =?us-ascii?Q?wf8VmMHdJClVUekTN5n3giwLXuaXhcCQU7GBdTYU1osHh0VewDTV0WyM1SRi?=
 =?us-ascii?Q?0DzfiD91imYuL2DT2y5oGBPeLysQUCynGG5Kbed+ssrK4v1PJSyrYhe0Ugdj?=
 =?us-ascii?Q?se32Sh5N44XQU7fme2mWMc7pCZTwVnofjaPEPZETWUK29ZDSfM/PF9V5oMpA?=
 =?us-ascii?Q?laDx5Q8QCm1zuDKz0d8IoIftZy4QocGCdcc/AmbUu3Lm9L7tm/eCC6z6eJj5?=
 =?us-ascii?Q?6Z4qFjCJ6zzxORqEYvZSH146/9JsKOUbrzFznuga0t251d4W49rFP1FqfH9Z?=
 =?us-ascii?Q?HKIy4U1/41CkrPlZSNJhDJaa0eyLbech4tl1sNUx8aXdPuoinRmwvGHsegcy?=
 =?us-ascii?Q?6lfAZ4Twrh6dRYmkGrQ6NRa/OGWGUnA61oHL6n27easKix8a4lAkncft8DHb?=
 =?us-ascii?Q?jJSCMrpY/0+LBOvfQYxk+z4HtrrpThMkywAXBQ+dP4Kx2XdCv12bKR5058O1?=
 =?us-ascii?Q?WHzWB62JBqzp0VToABTW8ca6JEYUnlsALr4U0L5Q+P+FGNDDq7uZY8ZfwTgn?=
 =?us-ascii?Q?EM61wSKVCGHjuWMB14a6Ou+VzxDl8RzR8YMAlmeUBJXsiiGFj9ir9pYOrFOp?=
 =?us-ascii?Q?xB16/gjXduMVs6tqG19drSpbWHZWwnKgcy8r8DJgn+8yoAu6gPu+4L9XCIYR?=
 =?us-ascii?Q?SImTyEwzvV59lCvLn1ohlSwtLkFobe7bowE6+YhIwpZ21PRz777rn3MDoPn8?=
 =?us-ascii?Q?y55b5vzveX2zrfpLuMU5h8gkgI9mLttniz+NuAaJVHNW5Efac8XDI3hbDqPy?=
 =?us-ascii?Q?YouUVqydkxI4/UF35SZYQRMszEdn1VPoDLtdzgY8CrES/lx61Kk84DxY3+SB?=
 =?us-ascii?Q?vVAmPdM4YpyLdvCp+lLd/5dpSR2qxApU/GdjkEJ3uuimf6RBNmiFYTmVKjOa?=
 =?us-ascii?Q?j+ztTI1HmMS5/oRwXFvYreVLXsi+U98r9hnQ/3F6o8O5bcEs/H/Vpc6eXCb3?=
 =?us-ascii?Q?WcHmXhTH+V36bkJmSVit1+J9+0VeBFwPIMY3c/Hkr94LivP2Lpu57+0TZ8bH?=
 =?us-ascii?Q?ljx/zq3s9foJL+DRyv+0ZnAoTJjc/sSTqglW6UGa8IEM8vgI9XZVogLAz1wQ?=
 =?us-ascii?Q?ttKozDfAFr+7vgjYf8vspfx13Bhfbjz8UV3WGFNnHjaPqetmwgV8ceZFVXjx?=
 =?us-ascii?Q?d+JCTWd2DjPw6VLzw7iGDm6wBUzco9L4Sn77kqflYEQsZJmpJ4g8/w5eZTBk?=
 =?us-ascii?Q?/g4lM3Lp5kDjSEIn0vb8MEfIYCavvIhXN8aVRvYgHRNpXujbqYX3faW3+iKr?=
 =?us-ascii?Q?5Xs=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed1ef734-c945-441b-3755-08d96270a051
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2021 17:50:11.3877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aHSSbglDY8jIZCAyDIm0WJ8owO8LqzzteeAqxgXuAQagc3mf9cZL70m4UJ3kp8U/hlXelF6CuT3Wfjs3FOIACXUJBKldiuST57TiUNE3j64=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4747
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Wednesday, August 18, 2021 1:12 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; David S . Miller <davem@davemloft.n=
et>;
> Guangbin Huang <huangguangbin2@huawei.com>; Jiri Pirko <jiri@nvidia.com>;
> linux-kernel@vger.kernel.org; netdev@vger.kernel.org; Salil Mehta
> <salil.mehta@huawei.com>; Shannon Nelson <snelson@pensando.io>; Yisen
> Zhuang <yisen.zhuang@huawei.com>; Yufeng Mo <moyufeng@huawei.com>
> Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consumers
>=20
> On Mon, Aug 16, 2021 at 09:32:17PM +0000, Keller, Jacob E wrote:
> >
> >
> > > -----Original Message-----
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Monday, August 16, 2021 9:07 AM
> > > To: Leon Romanovsky <leon@kernel.org>
> > > Cc: David S . Miller <davem@davemloft.net>; Guangbin Huang
> > > <huangguangbin2@huawei.com>; Keller, Jacob E <jacob.e.keller@intel.co=
m>;
> Jiri
> > > Pirko <jiri@nvidia.com>; linux-kernel@vger.kernel.org;
> netdev@vger.kernel.org;
> > > Salil Mehta <salil.mehta@huawei.com>; Shannon Nelson
> > > <snelson@pensando.io>; Yisen Zhuang <yisen.zhuang@huawei.com>; Yufeng
> > > Mo <moyufeng@huawei.com>
> > > Subject: Re: [PATCH net-next 3/6] devlink: Count struct devlink consu=
mers
> > >
> > > On Mon, 16 Aug 2021 18:53:45 +0300 Leon Romanovsky wrote:
> > > > On Mon, Aug 16, 2021 at 08:47:41AM -0700, Jakub Kicinski wrote:
> > > > > On Sat, 14 Aug 2021 12:57:28 +0300 Leon Romanovsky wrote:
> > > > > > From: Leon Romanovsky <leonro@nvidia.com>
> > > > > >
> > > > > > The struct devlink itself is protected by internal lock and doe=
sn't
> > > > > > need global lock during operation. That global lock is used to =
protect
> > > > > > addition/removal new devlink instances from the global list in =
use by
> > > > > > all devlink consumers in the system.
> > > > > >
> > > > > > The future conversion of linked list to be xarray will allow us=
 to
> > > > > > actually delete that lock, but first we need to count all struc=
t devlink
> > > > > > users.
> > > > >
> > > > > Not a problem with this set but to state the obvious the global d=
evlink
> > > > > lock also protects from concurrent execution of all the ops which=
 don't
> > > > > take the instance lock (DEVLINK_NL_FLAG_NO_LOCK). You most likely
> know
> > > > > this but I thought I'd comment on an off chance it helps.
> > > >
> > > > The end goal will be something like that:
> > > > 1. Delete devlink lock
> > > > 2. Rely on xa_lock() while grabbing devlink instance (past devlink_=
try_get)
> > > > 3. Convert devlink->lock to be read/write lock to make sure that we=
 can run
> > > > get query in parallel.
> > > > 4. Open devlink netlink to parallel ops, ".parallel_ops =3D true".
> > >
> > > IIUC that'd mean setting eswitch mode would hold write lock on
> > > the dl instance. What locks does e.g. registering a dl port take
> > > then?
> >
> > Also that I think we have some cases where we want to allow the driver =
to
> allocate new devlink objects in response to adding a port, but still want=
 to block
> other global operations from running?
>=20
> I don't see the flow where operations on devlink_A should block devlink_B=
.
> Only in such flows we will need global lock like we have now - devlink->l=
ock.
> In all other flows, write lock of devlink instance will protect from
> parallel execution.
>=20
> Thanks


But how do we handle what is essentially recursion?

If we add a port on the devlink A:

userspace sends PORT_ADD for devlink A
driver responds by creating a port
adding a port causes driver to add a region, or other devlink object

In the current design, if I understand correctly, we hold the global lock b=
ut *not* the instance lock. We can't hold the instance lock while adding po=
rt without breaking a bunch of drivers that add many devlink objects in res=
ponse to port creation.. because they'll deadlock when going to add the sub=
 objects.

But if we don't hold the global lock, then in theory another userspace prog=
ram could attempt to do something inbetween PORT_ADD starting and finishing=
 which might not be desirable.  (Remember, we had to drop the instance lock=
 otherwise drivers get stuck when trying to add many subobjects)

Thanks,
Jake
