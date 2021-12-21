Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AE847C12D
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 15:08:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbhLUOIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 09:08:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:45515 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232757AbhLUOIW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 09:08:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640095702; x=1671631702;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=zVq2836bZ4r2TZKne6f/Yh8Nsn1TuyFEVp/4LJgcNIk=;
  b=goiCNuuSI1ZeN5TzQ3UqyYhA8k3l/dgEGHFDfJyznfmS3U71ggpD85Xd
   3/61iWK6zGLyl1MaVHY4vroimt4ONbMi62BitHK3I9byxz88n4Sh3fv5R
   JkavYH+2Kq07/Bvic5ILilOiPSyw9NaURykQiIqAeXZHrhblG/m1FZJ4l
   IxFaZ6xBg0nn9ftAoV59C6yskF+ZZ5tZ4h8BL1O1URvlNWTdNB2EeIL7V
   Sgqxc+L2nLIe9asjhlSrhegwL3fPPau3YtJ6R/1ZdVTcxoqj0gr21HbLr
   GyMgoQ4/10Js1UCGBCrOe93Chkpvfd22U3bNz3spBNAVJNP+g+TjqlGTn
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10204"; a="264590058"
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="264590058"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 06:07:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,223,1635231600"; 
   d="scan'208";a="570219441"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 21 Dec 2021 06:07:37 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 06:07:36 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 06:07:36 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 06:07:36 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 06:07:35 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DEKZlmVoV/e9HxUEiaK7noBOfWZ9Ty7M+S4MaT7kEL9k6n+AksXEcdsCswvXqU3daoHcBpkBLlzNKMYH/qKS3uapYxKNQC/HscF8+mfdymAo1ezB0I8buAD5+km3Om9RUqT538F2awH6u3eXSu8Ny5PYltcWJ/StFYDFZE/5/OHu/JqZDYipSK4vTxA2e/+HE0RDUs97MNk9odpbsLuDToBjmFTI2jkaOJSBqmI5uzcfb1j+eGcz3WMmIuOfhqTWJwwOnHKkS+Q6OxExEttkFlB20+ZnZGDQrupRAYdu15I6k/Cv/f9Rmk1gXbmUqGun4nwIsZYFwSgVUWnH8Ro7lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=u2x96buaEwAYsLoSIop+BXZ5mjFgLLFjEBtqRP3dgLk=;
 b=oJ4ePQyZ9W9sXgxxRiTURegcfPPjhTSdkp09XVcido5KEB/H8Kpf/I5MsMljlPeyVUmbx8/Y1M9Ax5bSFb3srpn9G9+PPv51259UKabZc5O2aV1tcxvedRppKfeVBFJL81lxHoPf6/Tc2+Zu2hlIX0ACv+EXJdUhLBn2MXOgz0l6cvWLLzSJXZOuN0aDXgabOURcLNul1L1RtbnoCh6GlDJmyHUHhF01tiU68UiYpZvaq0Hzs0AAHIvcvCRm57U7Dcpu7L7gur9ayNum4IWbe3MXoP0t3UhvlxmxqWWe3x+wlmaA9sRoujAi5OtMyO3KvTwlQY1AcHZwobCSpvcszA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5170.namprd11.prod.outlook.com (2603:10b6:303:95::10)
 by MWHPR11MB1264.namprd11.prod.outlook.com (2603:10b6:300:27::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.14; Tue, 21 Dec
 2021 14:07:34 +0000
Received: from CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b]) by CO1PR11MB5170.namprd11.prod.outlook.com
 ([fe80::4c2a:62a1:d6e5:b67b%6]) with mapi id 15.20.4801.022; Tue, 21 Dec 2021
 14:07:34 +0000
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
Subject: RE: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Thread-Topic: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
Thread-Index: AQHX9jdp8zCLYq9nh0Woi5QXeJNDCaw8pP6AgABWVuA=
Date:   Tue, 21 Dec 2021 14:07:34 +0000
Message-ID: <CO1PR11MB517051A15C941DC81831BEE8D97C9@CO1PR11MB5170.namprd11.prod.outlook.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-18-mike.ximing.chen@intel.com>
 <YcGW26h6wf3f3hDl@kroah.com>
In-Reply-To: <YcGW26h6wf3f3hDl@kroah.com>
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
x-ms-office365-filtering-correlation-id: 935221d8-02a8-4e8f-d124-08d9c48b3c7a
x-ms-traffictypediagnostic: MWHPR11MB1264:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-microsoft-antispam-prvs: <MWHPR11MB12645B74B2A4713CD8AFD9FED97C9@MWHPR11MB1264.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3173;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0XsSzrXVdl4Ur4IoxJqrK6gmJ6EFWprCvNaM4L+WMZQD8o7ZExtZ3csGSsdE+oYKoNfFU7wdqe/uv+JU5Ln7nVID/BlJ4AURGm1ATMEI6AwvtBBLrZyYCc68/rCzfsYTEYm3n8n8000in4eHV53fc+h0mBlTUtVmmoDKhCHJUpCce7aXYJ13K0UZOQFMaJljKxApMuZuSLIztRtsDOTYLTiGT20xfFtRYU/N0h3Hgbs1ZgrI70lzqRl6a9i/WGIFXIov3IIgdnsWNCJo5xBpQv5NysT13x2MJUdrMIZN6z+v1qp1CqnVRNt6NPzcmvy1BqqT9yioUdO/FGXIxuDM4sSnVTXz6g/StHCiHoBpA4tNganiZXOr2ubYMwRPQL0x52y5ojUz30MiKoKoWal2/zeYGmjzlfionf4gKs5u+rcbgmT2wmd+/on/JM5KfBGdlnOGOJzrbnvzHiLFiy5l2VvYfoBvZ7epooPIyl+bWSDf31v3ttitLKIYFcRNEHCp/9M8Hd/44xM9SdpJ3X8ZslTS5C6AhoE4g4lDeUzSDwvRVoxhim/NRxKpoMdbjY83qE/Y9j8nVwb4ie/OUNNgioVku0jstFz+/cued7IKUzvRpvVN6l+NBwQ8C3mWo0zMTNI8aapPPyrxJcA5pq3WCKa4KpYYz8LeenC0+yasUmef2+dVJqygpMmS9v8QoRx9qD7ts5zPGKq3Pj4JmMjkkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5170.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(33656002)(76116006)(8676002)(52536014)(316002)(71200400001)(5660300002)(64756008)(66946007)(66476007)(66556008)(66446008)(26005)(8936002)(6916009)(83380400001)(9686003)(38070700005)(7696005)(6506007)(122000001)(53546011)(4744005)(186003)(82960400001)(508600001)(86362001)(54906003)(2906002)(38100700002)(55016003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?BQF0PQnfh+QHYtCods5W82G346hhHa4ARsoprufNfAizuMlntKYx9EuAn2ga?=
 =?us-ascii?Q?q7tgvv7RzD9wtV79kx1Mlq76kAg1BQ1v3ONW/bVNj1RH48KromAs6Hb9nkIs?=
 =?us-ascii?Q?wfkrtN77eCgl4PhnLLooJbf/yQqC8mQeTWI8eoS+5b1K45ArmMn1XPdYWNxg?=
 =?us-ascii?Q?xHr7hIU/7uD2PyaW1GPF34jSaj6EgVBXKt4OAYQEerC2aio9puqoCTAn18vu?=
 =?us-ascii?Q?J+7hG6U2Rbv51D57RUWyLEwi+G6rD1i3y0P250ZQH/tE5EELIEciGwemwl3R?=
 =?us-ascii?Q?6aecONx2wGgkfBQhr+WPVSj4o8lapKQTwB0zlco/SE4wf8AFQ/MLRgYm0NI8?=
 =?us-ascii?Q?X6/44rqXDZR+Nhe00r8jK9jciSVye5P7hm/c1BQ1V2iCUL5Vgl46i4cOtgj8?=
 =?us-ascii?Q?SvDp0bor6lDbtGEBh03GMUIHJ4cV6AmhDgqcMCIPN+MgSQrA8e5HMuWxfzLd?=
 =?us-ascii?Q?U9KuxuvNOGc40OnCP5cfHZD3Vgo9c4v9k3U6EMKo2Py9MZ8J0UG/ZBEDAjTU?=
 =?us-ascii?Q?6NdOlNRQkrse5XSZHPPVHDHpagiIUzTYDkEEluszFZmVW8LHhTKzDfeGbMIi?=
 =?us-ascii?Q?SWxdWR4yhDI6WAroCntGj66TTsMzbvDPlUYqUDR2kH3AdIZeq2QmvPgVIi2o?=
 =?us-ascii?Q?02wsgsctB7cPYPckVTXYg+OWfV7Xzv151Aba6y+RFjdlHkkX6XuIt59Ie6Mu?=
 =?us-ascii?Q?piJ4tSy9Q/1rruTYU/4GVJfYt70MAS1X0z2ToyXgH/2GifeIg0G/Ph4tFQV1?=
 =?us-ascii?Q?G7FCFgoOuruTXhbV8GD3xFG5haeh47JebL/LZ7hPcd+fdkm1sh5RqQQHUAKD?=
 =?us-ascii?Q?B0FOoJ/rHgOphYizD4syXAO5QEwcMDzgmFEkpqKVLlnt5DJw94IkukxHtQrm?=
 =?us-ascii?Q?02JZpWyHGr78OYQuYVeLg6yiWDZbXgP6gbBJMG82X4PDD1VS05Z/2ZXKpCJz?=
 =?us-ascii?Q?BdmhYQqTti3IIDb7L00y0hkLfDSDlVwC2bNzLaVc2NYjQ23/Wel+PP0FEDfO?=
 =?us-ascii?Q?iBABUGEaYUaLp8IaHtYlWqoQLKmzGVWQw/TtdR1k42Uao4XOWmFB6+0hNjl1?=
 =?us-ascii?Q?hQ0QkT+QJHqZRY9YZsTy0QCxlzX7eFK/ZYGPganhuT1ujVaOGP8cT9/k6iTY?=
 =?us-ascii?Q?HIpneqQ2El2/VHINhe6avg0vAYNi0ZQSF5pjPZqjd0ICOn3t8xEDaUkXRvSY?=
 =?us-ascii?Q?W0pXvEnxvzQYwZ6mzzaTuIIYRy4O+TsAaO2qdypbc84MDG786IfJsH7T/UaK?=
 =?us-ascii?Q?4tQHaWPnaxfkNAl4e2y1m6+1pSqEOXJAwXTKxPJi19EsFExOvIX3964OFsgo?=
 =?us-ascii?Q?IPUCWFfjJJ9AOeJV5aToxNtRfb1LVijLJOvksKKrR/ZJMKWPxTNujFkf6xXy?=
 =?us-ascii?Q?/2WRa9E2O1TtMxzbTkk0Cqx0mgKOzECoZPXdoGEbgEAmxRFuHEKosvxKOLGz?=
 =?us-ascii?Q?V/aWYlB1Hrraia9BUjlxauFj5qwqKcKVVaY9v4fENwshZBvEtDYk7VQ6LgL8?=
 =?us-ascii?Q?jwnvMOn2qEobojoydCVFNAGDB/6KZUk7hMDtv1NrU+qKDbU3vvRaGquY//+R?=
 =?us-ascii?Q?NoT39HMhGSU0/3aZyhXL9v9U3McQJ4eSPuqJOvFM+LM2NQGW/QebDXyYeUJC?=
 =?us-ascii?Q?RcREUtR0TmMSs5T9QbyQGYYBStqYplOn8VzsoIQjp03bzmiuUryjOsoYQWrq?=
 =?us-ascii?Q?4ERhsA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5170.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 935221d8-02a8-4e8f-d124-08d9c48b3c7a
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Dec 2021 14:07:34.2770
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wVsDb5mKVVoEQcVqCALNcHPKmzzxM9VhLCK4fsS+UgsGoBYi8YNlxBKh0OuKS5MgvjZzrZ3uiq/W8v0mJdmWO1uj1lz/1oxbiSIkqMcdRTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1264
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Greg KH <gregkh@linuxfoundation.org>
> Sent: Tuesday, December 21, 2021 3:57 AM
> To: Chen, Mike Ximing <mike.ximing.chen@intel.com>
> Cc: linux-kernel@vger.kernel.org; arnd@arndb.de; Williams, Dan J <dan.j.w=
illiams@intel.com>; pierre-
> louis.bossart@linux.intel.com; netdev@vger.kernel.org; davem@davemloft.ne=
t; kuba@kernel.org
> Subject: Re: [RFC PATCH v12 17/17] dlb: add basic sysfs interfaces
>=20
> On Tue, Dec 21, 2021 at 12:50:47AM -0600, Mike Ximing Chen wrote:
> > +Date:		Oct 15, 2021
> > +KernelVersion:	5.15
>=20
> 5.15 and that date was  long time ago :(

Will use latest one in the future submissions.
Thanks
Mike
