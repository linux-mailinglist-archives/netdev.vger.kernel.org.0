Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0744288A9
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 10:22:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbhJKIX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 04:23:59 -0400
Received: from mga11.intel.com ([192.55.52.93]:20184 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234989AbhJKIXf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 04:23:35 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10133"; a="224235106"
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="224235106"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Oct 2021 01:21:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,364,1624345200"; 
   d="scan'208";a="523733294"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by orsmga001.jf.intel.com with ESMTP; 11 Oct 2021 01:21:35 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 11 Oct 2021 01:21:34 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Mon, 11 Oct 2021 01:21:34 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Mon, 11 Oct 2021 01:21:34 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Mon, 11 Oct 2021 01:21:34 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Re37K4/cwvwyMS+xHqR9ilix+IbTc6VuaIO078VxiYrcsrc9WObjR8jUuV6Zpn8eh3LKb+updfr64boG7kjXE7o/2bV00rrkn6Eikrmw2U142Btx/KPEK5jr7pK7dewNh9ykNKPfxTcgNQu6mpK+daKAGYxHcHwNUkqisBj3dnrI7eHrw9gxeJJGr566lAdfAEcv8RuH5/cc8tZ51Eugprhf+lPLOHQZY/eoUau12CqG6hX/KmLh3qNH6yVku14l1uLYx9xZQhF18zZ13VS8aTgL6neGRjbnH8iCn4RmAwM+GIo/uosNHsIfuC/Ij8U2NmXLENSaMa3M0buBwnkRSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tvewCnAW4rUczFsiCHGUxxBltuYKX3xh7SkYcWEWAQk=;
 b=Yr8e19vOtrCCguZ30MmeoSOuomGoaRoyU8VKWU722MZLVVHMYDWjYmM/gymS5cgB2kFX4v//ZU4yJyVFewLplm4BNGGkBr2ZqI8TuNaGrsF3FVcrMk4YaZqGwuF/HeBXUO6Pt2+8PmQikFsOqsT2bxxN6SPA1m86X1KqiFOUMLGzu7ITlvadhPQxdOrIqJRnoJYJVhm7kmY9DkSoSKHJuD4miAEPzzgOsmeSdMLcnSfEQX9Ht0LZYQqSOHwNcMmBYBnX/SX9LHACM41sUEoDEsfnlfQU4fSPh+spvXfSkFh4s9o7yUeDE/2VLVxTViOkPnVABCmC4t5h+53kvmSopA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tvewCnAW4rUczFsiCHGUxxBltuYKX3xh7SkYcWEWAQk=;
 b=oF5n5lYFtnpJ7c/GMhL0vQKYuhyqNJrwTzFMaawTLGUV2gWzRZIvspBSjrWL43v6opFSAX16fnOkY5e107iqhNIc/HdWll93yek3ZUIZX93q5yPoF6wjbQJkzMxph9NOL5Mr8/5gtQmBEbdxq0HT8ohsjSw4Fc45iGkAgcuGgSg=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB0077.namprd11.prod.outlook.com (2603:10b6:301:61::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Mon, 11 Oct
 2021 08:21:33 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::982e:c29c:fe8a:5273]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::982e:c29c:fe8a:5273%6]) with mapi id 15.20.4587.026; Mon, 11 Oct 2021
 08:21:33 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>, Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next 0/4] devlink: add dry run support for flash update
Thread-Topic: [net-next 0/4] devlink: add dry run support for flash update
Thread-Index: AQHXvDEgAtyYxjU5D0ijvkxpgH04qavJCiqAgABgN4CABA0gcA==
Date:   Mon, 11 Oct 2021 08:21:33 +0000
Message-ID: <CO1PR11MB5089CD14E6293B8024202726D6B59@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
 <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0ffcf2db-1cf3-4f18-c36e-08d98c9022b4
x-ms-traffictypediagnostic: MWHPR11MB0077:
x-microsoft-antispam-prvs: <MWHPR11MB00778ED456C5101B4BAFA90CD6B59@MWHPR11MB0077.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: T+IG07edspfLs6s5r5RuoNPQ02c8z7ok4RIETp5l1EElXdOp5hpZ8qKMuyS80lUcXibmeDQuMnfCxLMtgS+cekfwDwTAbVB65vt/oKenR5GY0Gf0NweMpmNCJ5Ds8zToT0rI6iOw0i52NAV77DNxPEchfmFvX856k7NGzwTaQ3dSh/nu7gcR/hfOvED6a923kD2sZga+Hh442KttQk8lo8d+oMjEW+5D0MQ0SY3tMBJl/qyd9S2MjbgC+KeAR8GXcXugXQ/Cwe5w8FI0kSCGLgoYK41WtR0JAWZvrv9VuNl8bQjm9wx7Y9lhN1rugagLPSo0ANfOKK7Z86NeEPDrr+0cd/HaQrs9zFUdvvH3ZHKmpGoH5HhY+w3Pa2FWU95YSM2gJhRGDHzdyTKyjkT3HkfWXOFhGofCgfRKwey2FoFrLn1J1c7lqrYoapdqn2PNJ3R+zo1+UXWzMvnhzDzXZTYwBG/QliDsY/WBZ5egDcAWXHvChi9w8oDI05wC06xkT2clJl6I+yRTH48CcKarrTipWS58LYXBfXNLNd0gDneM/w5wrFXHE/VULNXaXYGR+CcLBCb43IclvIaY2lveI0fELobz/56G3NqdhDRwtfS6rlukSgKJrSI1qAZOQtHLiVluefKGp61JUFWf4BT+Eg12gYHMdzRuhIJrIvOjhzZeBKgdjmqAZo9dqv6cKIB3RlLyjv3IWBBs43R5SRqRoCKC4J0GH87UWO2LrFXYjFv2Yv/McN3xRg0K0WclIKPDrfFQoSKlroxyxrpMtaiyQyyZrZ4xqnrGc7UeFYGCwtw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(76116006)(66946007)(66556008)(64756008)(66446008)(66476007)(52536014)(2906002)(5660300002)(71200400001)(122000001)(4326008)(38100700002)(8676002)(508600001)(110136005)(38070700005)(83380400001)(316002)(186003)(26005)(33656002)(8936002)(55016002)(7696005)(9686003)(53546011)(6506007)(86362001)(15650500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?M/Lg4UFcvNi0dpsDXlp8fGkuAkeBP9tBDiftZeOzUpGuLJ2ICESTW07u5HVc?=
 =?us-ascii?Q?6ToHqHu7TB7yKG34pyWTu6ZE2gUYQJAXr4JDkwlLIjuP5zjT/BWVgNmb44Y9?=
 =?us-ascii?Q?cRYT/3Hw3sBg4ASSTwm5m15ZXjQY9tGtz+oI51WfjEGsoA2QTR5JCD4cntR5?=
 =?us-ascii?Q?JQKpLTZg/3E2v0/FbANZ9mUuDVbqUPS19dSsZPnoa5HIz5VViGa7Ax+OrAot?=
 =?us-ascii?Q?Q3iYxCVmBYEmDxBYA4d5lbSz/5ktthof6fMVzu7fb4aRvB1cBXbMItGYl0R4?=
 =?us-ascii?Q?1nMJ+Yu9Db/sKkbENCJoEhtzCtzxyaAqIdgiMe5Brbzt3BzklgGV0xR3tGyM?=
 =?us-ascii?Q?sW8PboS6IFtoDDxZqayw/ml5kHAzYHEzjm1gCRkZVk7OchE3TH8K3CplCLsF?=
 =?us-ascii?Q?fBEKx9/5NAhaU9q+xNj+9iWYzww/lDZzW5e1X05KQx6eRqeKgBO4ULZ5jhCl?=
 =?us-ascii?Q?ZuCJ8fm+Pcn95mTuXZD3OgNwwqNfqs5NZT+KpSHeaQXr7E4ayG4En+OvJAnX?=
 =?us-ascii?Q?Toq4iVNMlzQX2nK2UFLAutmC9YWofXVX1z5ZsXg3/ZLQXCBuqx1igw+I6OVm?=
 =?us-ascii?Q?4qUucyV0DXHfuwXH8sw6tNN9uW6Sp7vSSfkLrsq8gtf9U5ifrFnScS/z9p7H?=
 =?us-ascii?Q?I/K+X+n1/cD7VUFs5VF3F3OWWZVZFdhCWq1G67MDPFV93ZZ2DvyfgCr1YuRY?=
 =?us-ascii?Q?j48o8dR3tTgZUF9W7NhhIPsRXKTuXDdKBTrmZ2rcHWCxpzsFfKmIje+CZS6+?=
 =?us-ascii?Q?69V00MLLcyq3OhqkNwWvWCfhWTx4wEp/VTilzEWtjvPzKUxAqFyAp/QsW3bt?=
 =?us-ascii?Q?8un5gXkfK9tvB8gUI9qhDnpsWw0sOW1YvNjD9TfUY4dww7P1Wj7zUwlz/WwG?=
 =?us-ascii?Q?WZYuhk3Ii78W2f/8bi3iBUAqy0KpiKsRVEBOgBF8nlGuihdoTyCXscn+Bv7g?=
 =?us-ascii?Q?sA3XSqoatnND2xmBoepxxzoj3hkQ1FHKJW/r+cYpBSIqhtjBtlBc0pHYkhvt?=
 =?us-ascii?Q?VuxooogxwVidcJXp80vUwwYVSLKUd6pqA4y7/0SM6h44kX/BtU4NtbuwNOKu?=
 =?us-ascii?Q?w+GJLn8st247TVeGDukhtdbko/jw/S3qCHQJHul8kt6J999D4BWE8j5NeduZ?=
 =?us-ascii?Q?AD6Dn17RjzW87umq0RLioZgeiH+hdKXmZbUttk6BDnJ2KCOHTAKuC01z7F7K?=
 =?us-ascii?Q?oUxXNuj+VddwDGXTGM7Yp6wU1BbaR1R50YbIlclflGcAIBztuIkdpaZuDh2t?=
 =?us-ascii?Q?mUV1qf1jJSdKowz4yXEQrN0PONwoWkX3cyYNQlCLkvG9ADECw2Os5ih2YfAZ?=
 =?us-ascii?Q?uzk=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ffcf2db-1cf3-4f18-c36e-08d98c9022b4
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2021 08:21:33.4589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x1jwaOs8/B29I1RwI7O4gaNAXRsc8SbDC5sTphu+Y/cGhHuFLhSA5OJ4iYXOCmgceQYG0oonC9vYbOvcVQItIGc/DMgiRfCEWLElzHR81TQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0077
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, October 08, 2021 11:22 AM
> To: Jiri Pirko <jiri@resnulli.us>
> Cc: Keller, Jacob E <jacob.e.keller@intel.com>; netdev@vger.kernel.org
> Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
>=20
> On Fri, 8 Oct 2021 14:37:37 +0200 Jiri Pirko wrote:
> > Fri, Oct 08, 2021 at 12:41:11PM CEST, jacob.e.keller@intel.com wrote:
> > >This is an implementation of a previous idea I had discussed on the li=
st at
> >
> >https://lore.kernel.org/netdev/51a6e7a33c7d40889c80bf37159f210e@intel.co
> m/
> > >
> > >The idea is to allow user space to query whether a given destructive d=
evlink
> > >command would work without actually performing any actions. This is
> commonly
> > >referred to as a "dry run", and is intended to give tools and system
> > >administrators the ability to test things like flash image validity, o=
r
> > >whether a given option is valid without having to risk performing the =
update
> > >when not sufficiently ready.
> > >
> > >The intention is that all "destructive" commands can be updated to sup=
port
> > >the new DEVLINK_ATTR_DRY_RUN, although this series only implements it =
for
> > >flash update.
> > >
> > >I expect we would want to support this for commands such as reload as =
well
> > >as other commands which perform some action with no interface to check
> state
> > >before hand.
> > >
> > >I tried to implement the DRY_RUN checks along with useful extended ACK
> > >messages so that even if a driver does not support DRY_RUN, some usefu=
l
> > >information can be retrieved. (i.e. the stack indicates that flash upd=
ate is
> > >supported and will validate the other attributes first before rejectin=
g the
> > >command due to inability to fully validate the run within the driver).
> >
> > Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
> > really dry run. I guess that user might be surprised in that case...
>=20
> Would it be enough to do a policy dump in user space to check attr is
> recognized and add a warning that this is required next to the attr
> in the uAPI header?

I'd be more in favor of converting either this specific op (or devlink as a=
 whole) to strict checking. I think that most of the devlink commands and o=
ps would function better if unknown behaviors were rejected rather than ign=
ored.

If we prefer to avoid that due to historically not being strict, I'm ok wit=
h a userspace check. It does complicate the userspace a bit more, but I agr=
ee that especially for dry_run we don't want it accidentally updating when =
a dry run was expected.

There is some maintenance cost to switching to strict checking but I think =
it's pretty minimal because the strict checking simply prevents the unknown=
 attributes from being ignored.

I'm happy to go either direction if we get consensus on this thread though.

Thanks,
Jake
