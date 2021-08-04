Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9A23E09A9
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 22:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238592AbhHDUxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 16:53:41 -0400
Received: from mga12.intel.com ([192.55.52.136]:32655 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237474AbhHDUxd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 16:53:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10066"; a="193603685"
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="193603685"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Aug 2021 13:53:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,295,1620716400"; 
   d="scan'208";a="458758925"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga007.jf.intel.com with ESMTP; 04 Aug 2021 13:53:13 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Wed, 4 Aug 2021 13:53:12 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Wed, 4 Aug 2021 13:53:12 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.46) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Wed, 4 Aug 2021 13:53:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EoClzYE8Zhm+6pMyx8qJwRq+oQhG+x81rlmVG2jlJ3CL5FnZcs5JxLBJ3U5xD29STb2usDaCpphY5re6FLmQkUSst1qDL4mKZChwjCKPTo9GjO/thYgh+ijJeN0VEUo/6vXLJjaek7fFYSwT94SlxwKrrknNSK9hZSRhHV2EtgdbbE7wE8EYsGkpmXnDTRDYotsuwIFqtnPWhPLpAb24DflQ7YTh82eBi45CJ88r71riCWP5T+I7z32zk0K89xmni3UlGxzBnqiYD1g2H6Hwf+oYCafB7xEJXJ+yZaHUuQKxxDm3nZzEM0iTjWDSZiZUv7v4ROtx1Ypw8vOQ5kVmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6csrNdhVed0myjY05sUMdiHSbCRopzPGypJwZpL2XE=;
 b=GNh1HzywBEkj2Hz/k6AcnURxHIDEXiUT5aGzpOmufsWLHwHNbsj5DBBLmvPLtQgH/HfVSHT+/dvsAvQ/yqOFGHkk6iInMeLWoUM9Cg1WpFCjiAjpvdr5jfkaIBeEIIqdRJKSb+0RDEOjvDcvt8oXKbJh4ucaGxA5YWf1uObQe+KD3hRhnu2kfqZq+Pq9OgpBFxPnPVTwjv8HawFkxtm8I0xOTkNLSX5R7BaX9avbWe6581jmyf95ATJYgzcKmIJ2Rou4kAUrtkU+P1LPROJcaZwPbuWg7l8P4y2oQjpFQLLmErEhzR+Ef4h1ot07/NvItbHrdXnGML19m/xSb5DtDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J6csrNdhVed0myjY05sUMdiHSbCRopzPGypJwZpL2XE=;
 b=Pd6/4Y32k+zvn1ZJIfXdS8JwedM7LNCORwxOdWOAhOwLFFBTVOGzkt007cnGcJIW+3UbqbTC6bKRMWos2xzjK6YSl1u9UnwjEqxeJqxxrrSgwie21MiZPUEcqjAFSUCpzHwcqJVfT92GYSkFhhfxU5FbLvQMXDSRjXtTsPz4usQ=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1407.namprd11.prod.outlook.com (2603:10b6:300:26::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.26; Wed, 4 Aug
 2021 20:53:05 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::bd85:7a6a:a04c:af3a%5]) with mapi id 15.20.4373.027; Wed, 4 Aug 2021
 20:53:05 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Arnd Bergmann <arnd@kernel.org>
CC:     Nicolas Pitre <nico@fluxnic.net>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ertman, David M" <david.m.ertman@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Topic: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
 dependencies
Thread-Index: AQHXh68Y1owt0G/CUEakzTAdq+RvtqtgbT+AgAAzuICAADaFgIAAgzoAgACWAgCAAAU1AIAADOyAgABBaICAAZHC4A==
Date:   Wed, 4 Aug 2021 20:53:05 +0000
Message-ID: <CO1PR11MB5089005017FE714B8A37F9B0D6F19@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20210802145937.1155571-1-arnd@kernel.org>
 <20210802164907.GA9832@hoboy.vegasvil.org>
 <bd631e36-1701-b120-a9b0-8825d14cc694@intel.com>
 <20210802230921.GA13623@hoboy.vegasvil.org>
 <CAK8P3a2XjgbEkYs6R7Q3RCZMV7v90gu_v82RVfFVs-VtUzw+_w@mail.gmail.com>
 <20210803155556.GD32663@hoboy.vegasvil.org>
 <20210803161434.GE32663@hoboy.vegasvil.org>
 <CAK8P3a2Wt9gnO4Ts_4Jw1+qpBj8HQc50jU2szjmR8MmZL9wrgQ@mail.gmail.com>
 <20210803205455.GA3517@hoboy.vegasvil.org>
In-Reply-To: <20210803205455.GA3517@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e0f9a0bd-0197-4af9-568e-08d95789db7b
x-ms-traffictypediagnostic: MWHPR11MB1407:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB14072B6B8FCFF8937BFD1035D6F19@MWHPR11MB1407.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ynXPzQnvLjc3civNV+CgQC0//TpUMQVtMtovm78dfEPiK2L6B7VrSdKl0BIBPPLglxqMaWmyfoTlL02gFYCXQQjWKY/41Fw4WSOirGAhPvH2aX7V7ied7E5nFilIXkBN6AGxfuN6l+fFjyapTxnvIY+P2zQ+NSldyMqpTN3T7ehR0yX9A1p3iAlM4rNq2LQ9OiyxsdS83kXMW60W4eziNPWOyhKnqwsLXmx9TTqD3sB+yYsHJunhWSqM9e9TyDUp1IO8mAX0Yc6zMqzcqTQwkH9/nOLkaWcBldJp6iopZB/5QQTcja164NiWfPNN9E6MMCytclVRQLNzcuAoD5F9WdttDAiBvkpWYr6JRG8l6bANEwr790RKhghctHb5Xo0Dw96coRk+WbwaRpuaetBpkYwjxSAwWRqjjqlFbpwLr2s+L3gSQ24P6ZODlq2OsbEukC56qT/G5J7QzBdSml7NGhdaELRboh1Wz5sNkoXb51T1R17T/aEuRv2CRXKYzMSitbaHH5AXe7M8VYVpSRIfyIiW+A3Ayuc9GFxXvzPxKvwz/qFWVwp0NADCIzNq9K76YBeIwk4Hnc1W+BzhbetlBM/mVp8wL0HU/hMPWS7LrBnOFGDa6sD3XRDruLVB+FOXLxeWKp++omMN/A1w+IChi6g+ek41NDtGFbo9Ey7mHj7uPSOVxKUbn5DQ9RYfs5ERXKxsZrMhItXn6gQGE+qiFg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(366004)(136003)(39860400002)(396003)(83380400001)(110136005)(2906002)(9686003)(86362001)(76116006)(26005)(38070700005)(71200400001)(7696005)(478600001)(54906003)(316002)(66946007)(7416002)(33656002)(53546011)(186003)(38100700002)(64756008)(66476007)(66556008)(122000001)(55016002)(6506007)(5660300002)(66446008)(4326008)(8676002)(8936002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9ew3QM1TPZrlmgiiw6OCIEgzu3JQOfXkA+nZhY3Tc+Q9gzfURrUIYsYBzqnt?=
 =?us-ascii?Q?NnyxijvS6cznewKJzScQuxuja2PJBR7qUiiFSY8TJ5ZeEd1XgL7Y3Cjt6duv?=
 =?us-ascii?Q?g5I9SNbZ7rNP7ZA1Kpm5/YSkYCPeL0ZNe4CRXHEnFae1U4nw42XYD0R6fhnC?=
 =?us-ascii?Q?2WNMTYiYsvr/i0Pd9rMZ/CipZxDFqlgQ6wui4liSAwPFEc1g+Hr+pAKBMzFb?=
 =?us-ascii?Q?/XY7vVafU71t3myUuNvWFCNg86pSE3nYiLjDqIfZR85QSZEM6441irGlmKhJ?=
 =?us-ascii?Q?5T+rqEYeLPdz13sedkdnGet/p83loB2SFi3/H8izsVKOHc+6k5njI7hz7tEr?=
 =?us-ascii?Q?irSyvaHKHle52y2zbyWxBCdgmBfqXoigE7iyCFlJIHU1uX4gWa1buzxbiHqX?=
 =?us-ascii?Q?4DtG1g76WmcZ2WB0PYndtniOPSzURGfipNVHJyj31+MWauW6/sOyAG3jEsPQ?=
 =?us-ascii?Q?eXWMn75a7QJ2LBPfOb604ll8i0U/4duZESfDcCPnmyqakj7r48JbH0ZPMAMp?=
 =?us-ascii?Q?2+oaWY+Agny++6CT+rEfskm27JoeIo0AWMKEum39zvEf7KpUEfLdpmiZPcTQ?=
 =?us-ascii?Q?mCi4Q/5uJLitbaWoKDAXEYTsjemRcWr86ZllwhjBsjQ7ZGNmwOrQv+kijqXT?=
 =?us-ascii?Q?30dlslzFsIwUwTZIYPguPKVlCn95RtfPWCO7eXsmvqxoPpIfbpRGv7tbRpJn?=
 =?us-ascii?Q?d8yW4B4sz00f18Qu+lXyt6Cs35BHI2iR2RHlNz+5d0s+SjCtNbVDQhs8s+rQ?=
 =?us-ascii?Q?cRMES1D88gQt38K1/ZkY7hoFi6+H2M7+QjG3vEjX0m0pvgTjGnQ5HEoGejIc?=
 =?us-ascii?Q?5qHiqbM0TINhgbrMm7Sh6sx7cFUdWisAoSVGItnoGQJDFDwnz9AI4AMtQPVM?=
 =?us-ascii?Q?wS1lHXEVxVRq5sz3VdgxfOP2Pv4ulDcDJvi7e6aWKVGPSXUkrN1zxu89Kvif?=
 =?us-ascii?Q?DwRSj0VvzS6FXbXPS+hijfavmTHhkseT49uBD3QOTFB8ewJIN08M4CPlNTp7?=
 =?us-ascii?Q?e76rVCoNxuGe1TBEqd0ol0AA/WYXlA1iJdr7nPM5PhErXy3Mdf3svDUHRrsv?=
 =?us-ascii?Q?Ritm8eznuI26UGjZMei40PT2XQhmkFO6t6L4vcw4SvnPo+BZa1yxN9xwYJQ+?=
 =?us-ascii?Q?cP+Kld+pMn/zJ+ZQ9EIyJblLa7lzPLdgQ5btIoZmAVhp7+6CO4Tp1UmrVmet?=
 =?us-ascii?Q?AmYrpAhjfARWkjiuNsbVluw57mIKSX/mxjR0MHqJwhQi4BrQ9djtnzzW8Rv2?=
 =?us-ascii?Q?1JHLS92jYDWRyFqf8tEOhF1gCRaoiw4s84Yd8qsVsc7eqG/4vPV27KZXTwI7?=
 =?us-ascii?Q?0PE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e0f9a0bd-0197-4af9-568e-08d95789db7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Aug 2021 20:53:05.1496
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 28nPTEC+A/R1e79oHa6GCnahOzTAu/AcfA5JlSTRX/0WLS0/seoL7KIaSUqKR2BHXun8N60OLQ+YIDYg+3oL5qcrVSU0b8P/wYKFITQz4vU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1407
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Tuesday, August 03, 2021 1:55 PM
> To: Arnd Bergmann <arnd@kernel.org>
> Cc: Nicolas Pitre <nico@fluxnic.net>; Keller, Jacob E <jacob.e.keller@int=
el.com>;
> Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>; Jaku=
b
> Kicinski <kuba@kernel.org>; Arnd Bergmann <arnd@arndb.de>; Kurt
> Kanzenbach <kurt@linutronix.de>; Saleem, Shiraz <shiraz.saleem@intel.com>=
;
> Ertman, David M <david.m.ertman@intel.com>; intel-wired-lan@lists.osuosl.=
org;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next v2] ethernet/intel: fix PTP_1588_CLOCK
> dependencies
>=20
>=20
> On Tue, Aug 03, 2021 at 07:00:49PM +0200, Arnd Bergmann wrote:
>=20
> > If you turn all those 'select' lines into 'depends on', this will work,=
 but it's
> > not actually much different from what I'm suggesting.
>=20
> "depends" instead of "select" works for me.  I just want it simple and cl=
ear.
>=20
> > Maybe we can do it
> > in two steps: first fix the build failure by replacing all the 'imply'
> > statements
> > with the correct dependencies, and then you send a patch on top that
> > turns PPS and PTP_1588_CLOCK into bool options.
>=20
> Sounds good.
>=20
> Thanks,
> Richard

Works for me too.

Thanks,
Jake
