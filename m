Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B9B427326
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 23:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243460AbhJHVoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 17:44:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:24892 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231714AbhJHVoX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 17:44:23 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10131"; a="249962158"
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="249962158"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 14:42:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="440065661"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by orsmga006.jf.intel.com with ESMTP; 08 Oct 2021 14:42:23 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 8 Oct 2021 14:42:23 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 8 Oct 2021 14:42:23 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 8 Oct 2021 14:42:23 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.174)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 8 Oct 2021 14:42:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IgsPsUwq5lTn75sDsXr5LkV/0suVCSa4ctTz59+ONyAOdY9t0mJroZ8nKCiBgh7nK5cq16+M/94R4nh5WaXKE39sgOwnFLE7BoXG7TNokiaNOqAk4owO+osPCFhyj7wSWtBMIW7ch+H2tScitXgPD/8S/YbZGPjA4f1VkQ6o0L+62O3N28R4/d5uLgzvgSkxx74CHsM8GrSnL1RsScD2H6arKpUfWltTHginhXXVlMI48Qr1FdlZ5CUbgmX1B64/KrlPWUaDKTcSLjFbQsDieJPIJdfR3py5B8q8WU9Bt9MEsd2JyFug+O2G5VyoWOXmWgjrIbIfo7rv+rC+MnMVIA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CmKSqxuAV7qPnWOJtl041mzFI21qdhaBPPo2saVIy3s=;
 b=Fia3iGX1koBHAuhFM1j9zBXeKp5E9MHKTtgvHRt7QiYEa41QDautAgdH8FgMK6Ap0IHH/ip12HCjzH7ncZxTbkTGySeaixi1AWmvCdsPRehbkf3N2xNJSd1R1fbl5ghRNhbK1Lkby8yPv9FZc3XBAgvsih79d6LHZZqaqOY7p6JVxvTH1t9bAOwJjUwMnAzZfQDhBECv/I1lj4dfIyng7qWgkJW0k6UwiXBhO0HJllQ7XkO+VC7n7KY2jfARtynAG2c7+p8RCZK4t4kpyIutQLl0EIEgCN+/zxOHnY/HOikxf32Y5mPMVQuCqEZuxG6/9XcIsq1Bflq35jqxOrKu9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CmKSqxuAV7qPnWOJtl041mzFI21qdhaBPPo2saVIy3s=;
 b=qIzdan/rn/aH9ocR7o4alyE3FO/Eax84Wo2PASRT6mloThcjoH+GlWBGwhUj4eztDugJWODEyL7LE0VEDn66xtiXNciKTyrz15O4vRPYTQwBQKHGcMn50Pj+NAq7HUPMHjNxLvYBfyojQkTgVLC/LiuZqNfXxrGYT7yAfc8V7is=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW5PR11MB5859.namprd11.prod.outlook.com (2603:10b6:303:19e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.18; Fri, 8 Oct
 2021 21:42:22 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8%9]) with mapi id 15.20.4587.024; Fri, 8 Oct 2021
 21:42:22 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>
Subject: RE: [net-next 0/4] devlink: add dry run support for flash update
Thread-Topic: [net-next 0/4] devlink: add dry run support for flash update
Thread-Index: AQHXvDEgAtyYxjU5D0ijvkxpgH04qavJCiqAgACYFxA=
Date:   Fri, 8 Oct 2021 21:42:22 +0000
Message-ID: <CO1PR11MB508937D3C470E0B39F7C0B3ED6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
 <YWA7keYHnhlHCkKT@nanopsycho>
In-Reply-To: <YWA7keYHnhlHCkKT@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e33f94d6-f4b3-41d1-7f1f-08d98aa482b6
x-ms-traffictypediagnostic: MW5PR11MB5859:
x-microsoft-antispam-prvs: <MW5PR11MB5859BD8602ACC62AEC32162BD6B29@MW5PR11MB5859.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xV4pl5GIqdGR1eEcT/Bpa5AbubuG96MD9kJ3m5YAEoZYNJ35C4gczqoi8W/bCujXtlX0r7D2SgWjR0bFfi9SqS49dK35tiVbi3PTJont/kC1RWP6/jMJz0AKf0Tm81CignUI7nLS4/Mt0u5y6a1ZBcT7kZG8wY+LyfPBOVrN1sS5rZyqzMJfd2MGTQncegZxnCpPMZLyq9K7g8nSXcv6USVvlWAfewlv2b+177xHGJUuezSzyRMfkkjMC94mGok6c6tw+zuMgDvrLHjFAl89DhYCDpbczfWJDGABCTlT4DgZeWjbki6BoWD5x/vNmTRFvPGsOG8eDKC2ginX2aWMc+z2jXo2RUg2DxIislU3VLZDNyVGwnIKx9y/XyDSwE7FrB+a9LRf5qsRBDaiNvLWwaNVWAgCOZAwzOJ1ZSSdZX0Fox3TYSi3Z214e09BY5NEU01nzHxk5hexDZJhMAFRxN33sYyx40AL5I1IIWWFpiAJ2SamR/7/NQjTZ7PkN7xR9gJ6rGxuw2z1HnCZoDiVUCGuHmKngxq6sZnLq+akzkpp3mD6TGVmK85DS951SdhT2Hwy7OrcKsUKnFprMejii11a5uoDzYW+6s4Kz0/HhcaSzAjPzBPD3Q9eDKuQY5mwH+vd/lgRnRyA9L2OlHsMCjOBbPAfjwOQ06uMNurrrtmMyiyQc4VMwSXCd8VtQXRpZMxnGHXzTQ4BJjFEyujkNpgbKv+YRlEDL9rs1TjT2/KI+wp96wfQ6kWa+4ysTgBdwLPuW67qhR0dS8KV3budvpbsKCeJmeuzkTDaYMlgwNo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(2906002)(66946007)(71200400001)(38100700002)(33656002)(316002)(54906003)(64756008)(66556008)(76116006)(66476007)(122000001)(55016002)(52536014)(9686003)(66446008)(83380400001)(26005)(86362001)(53546011)(6506007)(5660300002)(508600001)(6916009)(38070700005)(8936002)(4326008)(15650500001)(186003)(8676002)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8me8US8LOYcz3Tm8VyaH4ge2txHwmEjj8ee8NZ9Mtj758gyN8OMnEUXmjmxO?=
 =?us-ascii?Q?51eSNl108couOUa/g64fbzUN3MYC2gMpbo75rX+geAhB3+apUN2aGyDauHdO?=
 =?us-ascii?Q?EJOC6MpPENo3PVatD6vQrOtDa3hfWm7mtZTbF5H47esHMni0zzivMoH20b3f?=
 =?us-ascii?Q?PWbIymET43XTpMYwRu7vfiZIFNIDM9FCmjit9ukaAy6H5pIWNoUkyWeUneME?=
 =?us-ascii?Q?QhRrW2znIlq15NCT/wEqdcyrJFICDlU9IJjkvhDsyE68pj3a7gBcjBjPwrWQ?=
 =?us-ascii?Q?PVRVl/rnn+ODN2TmRCdNR+kBytuYPEP1C2vPUCqkTx+o9xNRiYVN4a5D3KUc?=
 =?us-ascii?Q?/vElRH2UMC9KCGuCKDYK8l4+eo6xxsz34s3KLFUhRWnXOV24enjQvvFaTiyh?=
 =?us-ascii?Q?l2aW1GM6hBptTma7WATPUcrQ9qKpwp0Fa0EISQNknjD7ghAeOv01dl73wyz0?=
 =?us-ascii?Q?txjozEXeiozV/6NZfKzS3wbgLhen2xJUW2WvpjFwhwR7KfBQ6NLEkADmDu6G?=
 =?us-ascii?Q?D1Z/w+qMJWZ1qgCipro27Pz7ACmlpm03fA5XT3apIKswx6kd6OVjQjDyomqJ?=
 =?us-ascii?Q?ed+CSgmyA3HKALVqfn/1RIJRJ6gz+/RmDpIdOpN0EvWxjvwP4+EliN86JbFJ?=
 =?us-ascii?Q?RYns08LnG5V+IV1OJW+8ewBJZS8Dk8zobpBoy1kEArF7S9UXiKIGd6sLRJxA?=
 =?us-ascii?Q?8/b+5/t+UNwFD16gjLAQFTsJgJBuv5Iu2ygOV/O5yYLxMZ3RhJ8ESBj6qNOP?=
 =?us-ascii?Q?WTj4jwQXbYzy0hRA1K5Twk/lB12esOnN8u0uUxC94L/7pPdj6xTc+c4pPdRK?=
 =?us-ascii?Q?VXxegVmzN/I/8GyzEt16NGKh9OycLsGeWzXPPAp94wXHEX1GJw/rdbTVb+lO?=
 =?us-ascii?Q?1egMLYx28qxU5sNWn+gG+cyf0tzmM4r1FrFqW9zEZg1anxj7+wttzP+iWRRT?=
 =?us-ascii?Q?bT/DWmCYc7iYRcYovzufLbC3zzIqz9wMc6qyDC6R/XqIqf7IZ1eQ7I8Y3csx?=
 =?us-ascii?Q?BGsffKm/yBMEISyUVAEX/kGOCTcDECqQgj0k8qnxKSkmjwACzf/j7nCfVjAp?=
 =?us-ascii?Q?YBCUG7V2iHqC16uA1ZV4LMT/el9dpSiw+ZyaCLvM8z8nvxCC2bHwgcjDkG62?=
 =?us-ascii?Q?spYVIf0uzQOUZ5CVHZwlE87cepqngTfpHoFB3Y0mBzZrLxRTSKWhAAnM004N?=
 =?us-ascii?Q?szIHU48k+2nvvrk5Tg+5OLPlpqixhTh8reGgOFI9pI8SE8q/ucdmgyAvl719?=
 =?us-ascii?Q?FuejGE6i3XuvZxgeqYj+QszCoBBMUakF/iRGvkOKGXOEHpM+IUQpTfR260BA?=
 =?us-ascii?Q?nyd1Ivf7Tet0VsAqrScc54pi?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e33f94d6-f4b3-41d1-7f1f-08d98aa482b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 21:42:22.0639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ciSxxUb9kOhylMyO43LWch4LEQGR/iUKIHjWEHvk9usm3MtuPlRdZlGtMeXcqOzldl8E4psP3KMRYeBcuH9vhjVcpj1IVtR2nDzU27MXSKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR11MB5859
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Friday, October 08, 2021 5:38 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: netdev@vger.kernel.org; Jakub Kicinski <kubakici@wp.pl>
> Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
>=20
> Fri, Oct 08, 2021 at 12:41:11PM CEST, jacob.e.keller@intel.com wrote:
> >This is an implementation of a previous idea I had discussed on the list=
 at
> >https://lore.kernel.org/netdev/51a6e7a33c7d40889c80bf37159f210e@intel.co
> m/
> >
> >The idea is to allow user space to query whether a given destructive dev=
link
> >command would work without actually performing any actions. This is
> commonly
> >referred to as a "dry run", and is intended to give tools and system
> >administrators the ability to test things like flash image validity, or
> >whether a given option is valid without having to risk performing the up=
date
> >when not sufficiently ready.
> >
> >The intention is that all "destructive" commands can be updated to suppo=
rt
> >the new DEVLINK_ATTR_DRY_RUN, although this series only implements it fo=
r
> >flash update.
> >
> >I expect we would want to support this for commands such as reload as we=
ll
> >as other commands which perform some action with no interface to check s=
tate
> >before hand.
> >
> >I tried to implement the DRY_RUN checks along with useful extended ACK
> >messages so that even if a driver does not support DRY_RUN, some useful
> >information can be retrieved. (i.e. the stack indicates that flash updat=
e is
> >supported and will validate the other attributes first before rejecting =
the
> >command due to inability to fully validate the run within the driver).
>=20
> Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
> really dry run. I guess that user might be surprised in that case...
>=20

old kernel should reject the command with an invalid attribute entirely, no=
?

Thanks,
Jake

