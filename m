Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB0553B8694
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 17:56:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236015AbhF3P6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Jun 2021 11:58:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:3993 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236001AbhF3P6i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Jun 2021 11:58:38 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10031"; a="230015625"
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="230015625"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Jun 2021 08:55:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,312,1616482800"; 
   d="scan'208";a="408838598"
Received: from fmsmsx606.amr.corp.intel.com ([10.18.126.86])
  by orsmga003.jf.intel.com with ESMTP; 30 Jun 2021 08:55:22 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 30 Jun 2021 08:55:22 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 30 Jun 2021 08:55:21 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 30 Jun 2021 08:55:21 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 30 Jun 2021 08:55:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6FftglaW2McP3qj4fM3O5FIMX5ll0iNXSCvm+WFoQiJBbdKkVHHOFbOV7BrS2mvlBryjT1x3gE9aVcaEJJhbmnVGy90ydemkImmIanP6uR+6MJ0FkW0VrEPXKYEu7VFyZp9NC9rVdPKk0cM5uCAyaCLHsWatOa/nnnsjEteuiZf4EmVA0Z/QrlLTBIGjZN3DqaPnDBS7KFuxBKtAf7TZ2VlIjxQqIafLw70+WU7hB0ZSxMjq0YoBLimFY3zu3TNGWNnyfNGzQeef80wn1hFI7SRmJJoX6Ad4XK8C6/daLueRW/JXBBhZ8gfio9xiQP3Zi5VRgCZTTw+BrUUbFGsqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lljGpV9tiNUxSTiam5QhQA6TacUzb0ybzztyqDc9Jeo=;
 b=C5tQTWRDRPVtBRVar67c7LsQEMlWHjoCqMneMUy6JR2+K7QrxFNdMYtMXnjM7rj6SjAscWAHZmCJvzOE5DL1m8v2/c77gCA5JSHCYU7ofHxtodClJ3E0KPMw57jLASo+rPF8mpaTCM8O6oA489OnIOz/tO54Nq/BmhH/nO/hWZ9bEseszik9AgUivatx0baG6fBw6GnPzpSNYWyz5I6Z6Mnt2twgU9IIfp2E2ypJ49LyJoKJIE9riOdhbT0jZ2Xp+Ght1N/NVFk0MGH+jHdxqiSUuN6SwVO9TjVgSFDQVbTfF2RiUyTsG8avcguGs15DKJ1sTZt1bAzApaxVUymbeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lljGpV9tiNUxSTiam5QhQA6TacUzb0ybzztyqDc9Jeo=;
 b=LRDQe4NNGyXKVIJ/qNWZVEOq1Q/GAJlx1GE1+ntX1W+Ez+5UAnKs4cuiHBSt8jQ2KQ/zR+5FCkMB28We4H3Ot8yb/nJ+KK3P3t2hWOauQ/d4quqaetrq84hO0qTzHrMpwiMP7IaSur7K3ltsSYver/kVt8yGHnd/mQFnSEHz/Jw=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5141.namprd11.prod.outlook.com (2603:10b6:510:3c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.18; Wed, 30 Jun
 2021 15:55:03 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::3037:7b6a:c881:c590]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::3037:7b6a:c881:c590%2]) with mapi id 15.20.4287.022; Wed, 30 Jun 2021
 15:55:03 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>
Subject: RE: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Thread-Topic: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
Thread-Index: AQHXbE3rwAA/rl8+FEW7ayQ8uvuGcqsqEq0AgAANjwCAAY+QgIAAPb2AgAC2SYCAABG8wA==
Date:   Wed, 30 Jun 2021 15:55:03 +0000
Message-ID: <PH0PR11MB495167E58F24332D30517809EA019@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210628184611.3024919-1-jonathan.lemon@gmail.com>
 <20210628233056.GA766@hoboy.vegasvil.org>
 <20210629001928.yhiql2dngstkpadb@bsd-mbp.dhcp.thefacebook.com>
 <20210630000933.GA21533@hoboy.vegasvil.org>
 <20210630035031.ulgiwewccgiz3rsv@bsd-mbp.dhcp.thefacebook.com>
 <20210630144257.GA30627@hoboy.vegasvil.org>
In-Reply-To: <20210630144257.GA30627@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [83.8.190.227]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fcc26839-cb75-445e-dd59-08d93bdf6ccf
x-ms-traffictypediagnostic: PH0PR11MB5141:
x-microsoft-antispam-prvs: <PH0PR11MB5141274954DB21F5C791E7A6EA019@PH0PR11MB5141.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: l5it+LVR6kfc0Cc4LfrlXHw7B4YRZdJh/L/UXsquHzAqO4+N5SKKOWsvNfmaddPOV/58tfhf8y4Apwy5m8v6evS5Sxvm7JR3oOUPlyzDu4U/M65p5cjG5wkINbt5zKRMNKMYVYwGdJhlR5zJZCMG8pben13F29DCz13496cpiyM1g6syrbTLJCnz95h4nY2IMhmSpY3g62oSzi84sBcoFArT3DbQGkHjplY9SImNsn1u0ktlsaGXOLtY28oOwIdBVWK//2Js9nk/OFmANaGd638nzt/6cw4JjQe31Lx44jopW3fGUkQCUCsFmjOSVRpQhS0lH8vl6VimutqQCbIcvYRP9BV2bZ9rk5t1MaGXWgtmST3oVFSj+/1dXcwLv2e1QL/afgfLjsah7miG6a2Yhl1q5bOZ7cwP8JtLapiuSIh4pDdpw2K6JYHzNjawjCpzs5HRhn51l3r0Ur27UsGj3iivwMx3TW+q7rdJFC/wsIRqAiSb/dqIrInQf5u0wKVI8wgnK82lbyPjCujuP8imAZWHhhtWSr/KndC8t3748aQ6+zLlc7cfWl2NhzICZ22Lxctl/O5axONBbGBKc/JQNulUf+D/2A5hwriTm/kwcnk5zamXQiPKpeEIjNMXbfKjwDQYf06ynCRlxkaTJKjkXQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(498600001)(76116006)(7696005)(66476007)(52536014)(110136005)(5660300002)(6506007)(66946007)(53546011)(2906002)(54906003)(122000001)(66556008)(66446008)(64756008)(38100700002)(186003)(4326008)(8936002)(55016002)(9686003)(33656002)(86362001)(71200400001)(8676002)(83380400001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?N8/JNgqnyOt1wQe7e8ElzMDObVgfhtfCCqNBdwSxjbcIMf0lBwVjsrAJsH38?=
 =?us-ascii?Q?GodY2D4D3EYrzTr4HNUkU3DvBARXxvi6IMClwCX3RS4ag75WH6gbc/lzbbCR?=
 =?us-ascii?Q?VQdoEfak7y5pE0CUZG3PdMDurzk0IjmkSwVt46Y5CPiGmbnLELFJeXjw/kWy?=
 =?us-ascii?Q?NOHBsRlvytKp9TZ68IoiEb49E7uBfZnIsHgaac+rfx+35Hmp8W3rlV4pGeHY?=
 =?us-ascii?Q?O0EdTxLW+BgyEQ8qaiJk0Pd+yl8A8joPezkD7hdqTpNe7cA450McUa8I1JvQ?=
 =?us-ascii?Q?EP2PvtFEtaW4sQfNGm71Tq07GMDuX9/dleB+nSJ7q5AElKmcTskahKGqGnBd?=
 =?us-ascii?Q?UDWMfWReOAzOFM/OS8XfKDEj7AC7IqoKK32IICgWHJ5X9sJxH6+a12mmSji9?=
 =?us-ascii?Q?U/NTooGhkW/V6epcuw8Bk9u9rkBZLKsRcl/ws7bqifsvU0ryyE1J+R2qIhLd?=
 =?us-ascii?Q?SCKNIC9kRNeSdHW/uvgbwF6sHeS2mxdXnPEcElEWl9sBlMAqD6N1Xs0tN7UY?=
 =?us-ascii?Q?fQc/LUM1yVB1JrXzDp16s6rmVSwifHVUF0o8xmbK7qP2zte+pbCKDO617Mh2?=
 =?us-ascii?Q?zRSzdBEZtcAAdTJRU1/DFdWB2gSN3izJGPdG2zWFeg8Hwh4mBIiJ2hF0MbTq?=
 =?us-ascii?Q?UXtvdb5kC1hhsDa71gbOzope2rsMRzU75ODXhtEa0dnwdAywLuIu2JQTg6F4?=
 =?us-ascii?Q?wgX5EmrNiooWJBczBAr+zY1i105k0cH7tTwkK+Mil8wjoZoWnLD0DH0NqtSp?=
 =?us-ascii?Q?k8dOBvvVqaU4NrYQ1C/T7xhZ+we32ok+Aub3xORqOKV8PMJqIDDqYhbjl27A?=
 =?us-ascii?Q?XmK3kkDIhK05XJuUXBttOOD0kY/deDDyXXC9+kTJ7FeM+r2byIopZyb5Zsal?=
 =?us-ascii?Q?TktCuA0TtWFU2W5mkt4ZhAeHYVT+376VOThZqvACsGFnX0Guje6h0TLFKo2P?=
 =?us-ascii?Q?CTQRY6mVSMGH4TsY5dyzIwEQ8Kx5fj5RWX7EwsCOhBxBCtlH8LFW4jkbg+mX?=
 =?us-ascii?Q?RZCXZPIG3aCZLN08RIPThLqd59cH1QoH5w0btZB3CqhYb6kKOGKdfk0n/yce?=
 =?us-ascii?Q?oPAGjLM0xBaB6kIECsuz5i6NQgviuaSgm4/f1up5JKIi89QrYl5frx+j0vph?=
 =?us-ascii?Q?Q2wiP55OL1TdasEzxnGJyAr+rlSRYupjmkRRjCnG8m0zT+9tocw8LO8VbJbf?=
 =?us-ascii?Q?WaLBsxGMycy4jWQbZBaC3cKKcRQowUmWyUv/R/yf8YGhrB2JtKsjy07C8DM7?=
 =?us-ascii?Q?4MNym1LZcWJTRIYwsig6F05s63Emhkixsx5iIYW0fzJdV8hTahL1NbAfc9G7?=
 =?us-ascii?Q?J/iSMfqAR3HIedRJk/JG5IRV?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fcc26839-cb75-445e-dd59-08d93bdf6ccf
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2021 15:55:03.8405
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NDRUIX4TfJuCKrpF5HQgnZPjSOSKivgNZSNqoVK6XpSkwYRaUcOJ/MHjnxd8iiA/8ezjNCSOfga3zC9P9imBMPgOyP+U6X2ueIeabAgSUoc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5141
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Wednesday, June 30, 2021 4:43 PM
> To: Jonathan Lemon <jonathan.lemon@gmail.com>
> Cc: netdev@vger.kernel.org; kernel-team@fb.com
> Subject: Re: [PATCH] ptp: Add PTP_CLOCK_EXTTSUSR internal ptp_event
>=20
> On Tue, Jun 29, 2021 at 08:50:31PM -0700, Jonathan Lemon wrote:
> > The PHC should be sync'd to the PPS coming from the GPS signal.
> > However, the GPS may be in holdover, so the actual counter comes from
> > an atomic oscillator.  As the oscillator may be ever so slightly out
> > of sync with the GPS (or drifts with temperature), so we need to
> > measure the phase difference between the two and steer the oscillator
> > slightly.
> >
> > The phase comparision between the two signals is done in HW with a
> > phasemeter, for precise comparisons.  The actual phase
> > steering/adjustment is done through adjphase().
>=20
> So you don't need the time stamp itself, just the phase offset, right?
>=20
> > What's missing is the ability to report the phase difference to user
> > space so the adjustment can be performed.
>=20
> So let's create an interface for that reporting.
>=20
> > Since these events are channel specific, I don't see why this is
> > problematic.  The code blocks in question from my upcoming patch
> > (dependent on this) is:
>=20
> The long standing policy is not to add new features that don't have users=
.  It
> would certainly help me in review if I could see the entire patch series.=
  Also,
> I wonder what the user space code looks like.
>=20
> > I'm not seeing why this is controversial.
>=20
> It is about getting the right interface.  The external time stamp interfa=
ce is
> generic and all-purpose, and so I question whether your extension makes
> sense.

You can use different channel index in the struct ptp_clock_event to receiv=
e=20
them from more than one source. Then just calculate the difference between=
=20
the 1PPS from channel 0 and channel 1. Wouldn't that be sufficient?

Regards
Maciek

