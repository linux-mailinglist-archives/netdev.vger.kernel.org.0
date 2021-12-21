Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 472F347C125
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:05:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238331AbhLUOFk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:05:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:3914 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235358AbhLUOFk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:05:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640095540; x=1671631540;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3c3RKIElv4/iZC7wLuellRpNUyG2sJEF1V5fMsTCyaE=;
  b=B0XW6qGLzkRxIXqYXp+I66SiARKbLqg0R2SFCynslRgdGQxUNI5D+xmR
   uZmW5UWl2ZdMM60bxisM7Quo+hsmn5X2gFbduJ7I9gBt4E+SXfAo7XSHm
   6QX4pRuaDdD+u84pMzD3rOwpEbBRqLVBDCMBypd4yGraXlP5oGVUkyfP5
   wNP5fkTDol/+KyWgR7BacGvvxqf90cQOyDcqZ7MkN/VXRPpIWiekNTGN3
   44vaYCFFaQf2mJrimfAMusUYvGGIMVmlHo9jquFqk09SZi6UUpkrNnoSa
   po5VIeQTaEOnRWlwSiBmH+uKAv7gxJTRMY1aarpxThn8EJhGj/PU+1XaU
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="221074825"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="221074825"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:05:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="521738049"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga007.fm.intel.com with ESMTP; 21 Dec 2021 06:05:39 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 06:05:39 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 06:05:39 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 06:05:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zq5tVQTAogB2yKkI+8g1sbh7Ek1h0jh7lTuEKWzduge1xGf/zMp0Hwrxp0NLf/N5EQsBtsy4JYkF7z8NFaEBMVLv4O1RKJkFS6zQd9xpUh8Au6Cthm4F6W+9wB0nPUNaBnkhsVpPwHQy3D9e5Oq/cuGa3AlKE6wITQvkf+AOcXSwbPZq8wluGDK1HI2IqvYH4IR44uCbBcqn2rvyk7xmWiEtydqZbrwA56dI0EYRbA5qO7Fpk290GLp3/eROtQv89EcGCdH9fLY5mRvNgRja+aNsvfOIr5pYyDnLSQT8MOwBfnkWZ9hKWCo2AKoYJTWb+8sikJPnjz4VZWbjNN0DRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=f9egA1hOlobJB1xNPJQU4X45XGCU2KHRWnSlXUnnJSI=;
 b=BsTb7oI+J22ASOmbwWEr0SLBMb/FrIwLw6ujE+CJaB4+WnPyzEINm/7ALXSyHHMTGyUZjqEJu9JtpTg1MbW10d/iyY/atqOsQ83+Te62VPmPXNsXCkqHhXQhq0kdo5zsWJLbBeiYky6HfowOEW76qAMjC3LwxODSG9B1TWiQ5kIvmDezb5u0PL0uNVU8C4R0Xd6OWUpzPV/ROcht8pFTYIoZVJNm7GJnvefD+Swskt9LQ+TbR5qq1imCLAEGkKYkMxR05lBZzAuvvgUBxkPBQPcgeErJL4OhzXMXPwV1zdkN4Qf6QVY4q8bp0iSeS5aGVbgKJIZJzqPiJHiy3yltaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR11MB1261.namprd11.prod.outlook.com (2603:10b6:300:28::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 14:05:37 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%6]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 14:05:37 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Topic: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Thread-Index: AQHX9jcKOP1y1O92CEC3pIeygh1pI6w8h6kAgABzECA=
Date:   Tue, 21 Dec 2021 14:05:37 +0000
Message-ID: <CO1PR11MB5170297D70E7AF1EF0BD80B7D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
 <YcF+QIHKgNLJOxUh@kroah.com>
In-Reply-To: <YcF+QIHKgNLJOxUh@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 077a72e9-499e-44ec-6b91-08d9c48af717
x-ms-traffictypediagnostic: MWHPR11MB1261:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR11MB1261094B5F3C1BC75137B5F7D97C9@MWHPR11MB1261.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oX5fhtPphtVTyrn+sjQeQlLfPppa0dKEgYOlkrGvlyeMMTmQOP9OxJrPGPyOPhskflykrt+1COqZp+2Uq9OPQK6wOwOo/MgADO5szZ8Rbc1OhkHD6mEXMtR45r4wdU/cS0hi4IfTe4mNxjldOY8IWQArsrvpDqgTINYQanG7FBP7RMt0zEbwqsr8LaYU3AU4wGrhGy5Z0BHvP4HorSBxtZu8gNTi13sIVd3qsv3/hkvfy8Mn64r2yUwuRQ2Ed1aMPeoh8vmiYvTXKJs5UTFcNy2Dc0EMqsynvRZ4b58s2Y1vp+ASZxUCEF1QMbzSPOCRCbRIm3IwFHyXZT1a3uatlTSl1WwR5uBvEdJlBroUwvlO/NFRGBYY0UvIfJUoCnGFBtIacxNnEuF2fowImWAhCFqjeoCI7poGVJSP/rnOWcVfGAM8Zf7hctrLmSdFmbzuDYlCTLzK1THkf5t0MPYBvBfDSl7xH7qw7jUcB6hucu/z71XuUnRL7fhCdeZiwKWJlCCtsykBXAh4c7V686gbpsWKYRcxaWVHjx7fYpbm6hogZjzufhlSuaoz5ZYIzBc28o0/T58hrGxkXqvL7tT1b7zEZEQ7OkSZ5l2p73UKRP7WlQ5ffTTRDhY5YJgFNxnchvJsyyYQeuDXFSBphOnBu9+sDTmtkPRfFR5dL0SW2gIwS24Dagi6dpEyzygmWA9To5qRAh4KO3zzfp3b/QE7VQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(7696005)(38070700005)(8676002)(8936002)(86362001)(38100700002)(82960400001)(71200400001)(52536014)(508600001)(6916009)(122000001)(9686003)(55016003)(316002)(33656002)(6506007)(66446008)(83380400001)(64756008)(4744005)(66556008)(76116006)(66946007)(66476007)(2906002)(5660300002)(186003)(53546011)(54906003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?6m85nn8/yGwbP1LjUItQpeInfrE6+2vgNlBP9p1o/RD7Jxog21cHhhQQkivI?=
 =?us-ascii?Q?KcB+TF+y+T6n9apcF+AhS0BdT18KRv0c2raTFqGeciDBadtHHufDCka1CrjO?=
 =?us-ascii?Q?yNs1fbos/42ar4W69vvGsuE3+0jPmNpHsxWuj0JAAvY72jKovVL80hmsY/Gv?=
 =?us-ascii?Q?Bu0c7+Oob+LgcDxDkuoXaLd+YgDsmILgpvpj6wRkDDCNdBykBZUFOJrXeWOW?=
 =?us-ascii?Q?X7y2+bHn/Wj9roWoMbyWf/zCsfNv4QLu5UCcAN6V+Kuh1HMEczFhioZ279Mn?=
 =?us-ascii?Q?2nAOv4EaWvFnL98WqzueUWKV54fmEphm27Kg7YmuTBZXBgCDzeJNIaJ5rJ2c?=
 =?us-ascii?Q?cmucWU86tk54kpHPv3jIL99Acdvci+ZXbLDBgrVIfLQrjjQ8Q1WGL9M979Yr?=
 =?us-ascii?Q?MJ61oGr/YA6dGJlouYFGCqu7hcnyeE2JHo+dKwujFwyQjE6bJjPv6rMJVroD?=
 =?us-ascii?Q?yWN5PT2zUvqfUrSBTXwQS3zK98HpEKwRZDGP5s/BCH1qV0xsSZChUfpm4vr7?=
 =?us-ascii?Q?1iumxaYm+lglBsa2bnG4u6tCQ1OB/JVLXYHV3J3e1BnBPWBgfMsKZ3DmKZUA?=
 =?us-ascii?Q?2D76MfOtJw9HdLViAz5E3uTdNvE/8/2sDiAQ4EWTQF7m5BUaXyFQVrGnuc9V?=
 =?us-ascii?Q?P9vswhBp6HVu2ofHvVnF1fA1Pmlztq+IiZk8UN7b4f51uOmR6gDTtAoFmnvp?=
 =?us-ascii?Q?iW6LhnUPWFArBUfjh9AcQKrQZ3Ca/OxYZf3/gNIPL9QJQtrOq1XD3oZATJFS?=
 =?us-ascii?Q?oofhQJEg4Q1FbWhWt/v94Nd2HkO70nnCJROByYeFSQ9a30Dk16EZDEKELAlx?=
 =?us-ascii?Q?/EhrX2CdTaaXGapCDskgFERNB+l2FKAN1Qip8xjd+3aFXpk08R+judGHvNdj?=
 =?us-ascii?Q?DXkxydBlwceuKZRgmNevs/iDZWu55C6cCYfSYuiN3IqGO2Q6C4q3WD6umHeU?=
 =?us-ascii?Q?9U9t1zNWKgV9QWNpp/wGxGK73CyHIlfSfoQqZjCRHa9Jy3W7U95/IQavxunz?=
 =?us-ascii?Q?okoM01xIX+/PEtJR7BUh+YpuDWzgqyFC0cW3PxOtb98H1YbH1YrYFzXUq1K6?=
 =?us-ascii?Q?da3OImwlciK7RapZyCxeYHiTD8f0eyZsd6eDQiPwrElS/avHWYFXpnP8iCno?=
 =?us-ascii?Q?JipR3fj/GLy1i93wDtbs4HthRLihLGNwS7wYJpiZ4m3/rmS6e+41uGkXmlrc?=
 =?us-ascii?Q?hbQQbEJyAKeyqPZKZ54BNhSoZQz2Z80zsUQN8AuthVaGJ0MnoKEBb70UQ8MW?=
 =?us-ascii?Q?JIItTLASuCo480ZE+oSP3/IFQwYI8adzGLD6DUYp0OMrCRBq6fKjje1riruA?=
 =?us-ascii?Q?R43v/fB/mbCuas6tPp5bv8AlzWVjCJeYgxLfCRObbl87GBvYttaWThbcCVnb?=
 =?us-ascii?Q?MS3ZM1GGHhV20plIgrL1G5lespvi/aNlK9p1xC+z6kr90qEZ86P4Eu+gDtK3?=
 =?us-ascii?Q?5y1wcISZwnkWugYxHVrXcsLYA8UzgyNoARE7N2geWqclHn7M/lPeO0pB5ZU9?=
 =?us-ascii?Q?tLJC5xAJRVUjelWKsg3iY5BAhN8UMODnHcL+gzuGpvFuvldLqP7LLZvJDyTS?=
 =?us-ascii?Q?+2DjBxt9F/koPzO9cnvFpVzfp+HVIdbQRW+DTPf0z/ixzZxBeCCJEzuQ2uQe?=
 =?us-ascii?Q?lkCOs+kgHIKULoSW1AtSEzrbJJPJlWS8+LddfR6mArrNz7WkMLWagcLGykWX?=
 =?us-ascii?Q?8FXTpQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 077a72e9-499e-44ec-6b91-08d9c48af717
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 14:05:37.8469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Xr4cm5JNHsFGhUJUEC4rPszRgA85osm4bMLYnc8T6bTxQmoY5upwXge7nNcKlqe1umv2NxlmJn3pcHjDG2QEIHmo36l1aNLjcTHe3eQi1Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1261
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, December 21, 2021 2:12 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; Williams, Dan J <dan.j.w=
illiams@intel.com>; pierre-
> louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.ne=
t; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
>=20
> On Tue, Dec 21, 2021 at 12:50:31AM -0600, Mike Ximing Chen wrote:
> > +/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */
>=20
> So you did not touch this at all in 2021?  And it had a copyrightable cha=
nged added to it for every year,
> inclusive, from 2016-2020?
>=20
> Please run this past your lawyers on how to do this properly.
>=20
> greg k-h

Thanks for pointing it out. I will fix this.

Mike
