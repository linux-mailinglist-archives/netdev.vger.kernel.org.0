Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332663FAD2F
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 18:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235755AbhH2Qny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 12:43:54 -0400
Received: from mga03.intel.com ([134.134.136.65]:32673 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229557AbhH2Qnw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 12:43:52 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10091"; a="218207559"
X-IronPort-AV: E=Sophos;i="5.84,361,1620716400"; 
   d="scan'208";a="218207559"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2021 09:43:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,361,1620716400"; 
   d="scan'208";a="518488644"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 29 Aug 2021 09:43:00 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 29 Aug 2021 09:42:59 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 29 Aug 2021 09:42:59 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Sun, 29 Aug 2021 09:42:59 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.171)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sun, 29 Aug 2021 09:42:59 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FlzxsdoZMOOj72Tfc3eSHLifPCK9HkZ4xT8qGE1Kg+Vpb+t34ntK49aYeHhLbXFZif8LW6kaTe2Vl4YV32qWzyrcTcnXYjDsJ7HlI4k2HIGYnWzc9KuIu/EBK9XMnnMB3Td8KSnSFQmUhqh8skVbefPvKaK7S6SWZDVgZmybSXIlAtoz4zCpsl3swo8QAuaw0YudSEezwCYJF5c2AC4CSJAkEJU9XU07+maUqOaRFstm7avzk3ZV6Ct7FdoqqA2kDSxCICvSd3VZsjWAMspxh0TODUNH9QvUYzbFacOYNF9LQKRouITbMS/3J/lZ4jWT2ekMcJsBt55TqxkGx6AJSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+YfHHckcn08OH5tN6t0/MoX3DWP/yx+1CwX1utR09g=;
 b=DZPJUD+Liah4mt6ObCa01rA62taQMOY1vSUs9CSBBjkioNcrNCSgyP+7PKYigMbkG75+sw9zBaaUq/0fmdAOGEo6A9C0lsfqKWJ285kAgmkiiPOuVrN5Pw7hHeipyyPwjUlfXTu1LY+Rpge5Ud4+YKnZsdFQwIOKbBrVTI/O5J9D40MRhLOl+S92JxURF/AefiS4TD1jr1/oWOEuUNbm/yrtBlPLlFfYCtblPUaj0ygMRZSY81UMZ6SPYEodp8GxdxWMZiA7jJ8U43RnXcGJp4uOVwWxPbs49TEntPdi4OV0U5rsAYTnzox+h5Pvu41inPyf90f/jXsFcCUr9zv/Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=M+YfHHckcn08OH5tN6t0/MoX3DWP/yx+1CwX1utR09g=;
 b=nDAW/BtOUF1ZwEECADqlAi6rtE/3Cak7mcWDq4BR+Vo5rNNNlo1HgOCoQ5M4Yr43ga+aidUAtV6eQP/QZTkBbTa06Bu0ic5BA7fwunKj9Sgx6t7kKNHyx9TsxToEQhlq2oYRP7FomqZ4nJgA0PzfEAxp9Di5ro/LMaiz2kIK4wc=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5046.namprd11.prod.outlook.com (2603:10b6:510:3b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.17; Sun, 29 Aug
 2021 16:42:55 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.019; Sun, 29 Aug 2021
 16:42:55 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Topic: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
 message to get SyncE status
Thread-Index: AQHXnK7K1rkxJTKXbUG0z9L1S2fbo6uKlpWAgAANa/A=
Date:   Sun, 29 Aug 2021 16:42:55 +0000
Message-ID: <PH0PR11MB495126A63998DABA5B5DE184EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210829080512.3573627-1-maciej.machnikowski@intel.com>
 <20210829080512.3573627-2-maciej.machnikowski@intel.com>
 <20210829151017.GA6016@hoboy.vegasvil.org>
In-Reply-To: <20210829151017.GA6016@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 24a3da1c-e2b9-499f-babf-08d96b0c0d5c
x-ms-traffictypediagnostic: PH0PR11MB5046:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB504642E1DDEC3324EB3EB6ABEACA9@PH0PR11MB5046.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0BqMAcs2lnRUhOa7Fb+SanAT8ycenuyqlTFqRpic6TJMMqAxYAFEVnR5EcK7hdYELn+zCcI079ers5Z5hnz18SbKAnsvTDrIBAgXzvI78FCKpss174c0MjBuLABSkbeGPR7midRnl2vjS5qpkBn6ZCJ7x35YbjWNJ99JkwfGHvOHPaESVH01RvMyqptPTYLT8weT0hqJZiV3dKXxxATv14QJktVp0msqWPo2yfJZW/yD4DEwTD4i4+LVK1u/WzdKWKEkpWmIx7slLb2EBvErIPRWHehWB0oSeCsWQiaTPeDb/YMq0PNRp6SZversgDCMEehkD841ZDx7LEOdts6o6KnAlaHyS8hZeidsS6DyAptz31Rp6kx+wHk3AnoxojlwpGzqJQQoU6xYxdy85ctJSP1X1BTLGBolLjRIbx2q0GTOZxLqoxUKTPL60fuapPCWunchDsbUsZhdOLcmosSijpxBA0ekz1BrmyL0jmohl5LHjdacvwhQDVoWYEUiVZH2BffIKgFojfmWhQiNYiUW042eKsTTo+TWMO8IoUGzM08YUE8K2dujI33IQIrIC7c/nlSqtqglA4nTNJaCA+UOpwESJ4tzhqueURMYPUg5T4QbjBSWIoWzF4kxKe+49ENNIRI1WLh+6pal3InU99MYeYCp+2m3qdvrrg3M8DlvMgqi614pIasCy610zj6Ftq8mXK7pXAESJ3NIS4km6EGLjw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(9686003)(86362001)(26005)(6916009)(7696005)(122000001)(4326008)(33656002)(71200400001)(54906003)(83380400001)(186003)(38100700002)(6506007)(8676002)(8936002)(53546011)(2906002)(316002)(38070700005)(64756008)(52536014)(15650500001)(55016002)(66946007)(66476007)(508600001)(66556008)(66446008)(76116006)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G2JqYDRWQk8OCnRAHR/Wht0/4Pd9zUQDmDFa9HaYcZkHSMeUGxIXNhXr2maL?=
 =?us-ascii?Q?F44WfjuqIN6BIEuD9CjLxdKynjKepOuc5XqkaKVV/F6gpTG3KsXWBla7rGGD?=
 =?us-ascii?Q?UvqMXoDd1wQdZZKowyBVXcRehi150UY0V/dyNNZFmqAQA9Rvg7SmEFcYhAfj?=
 =?us-ascii?Q?HAVsxfUbEL+sPBIb/ij4CmFXXmrEeUZTCb/ku4Ss3m62/rUKV7X6/gYC7C+F?=
 =?us-ascii?Q?XImaK4GmawJs9xydlQXLbe8tyJCgya1Gos3KPWumMzCEefPH8+b3mWp9Lk/N?=
 =?us-ascii?Q?uQ+8sJnS5Phxs1plk93yXcBCIZcqpdn40RFqc+1dPMqFu5xq1uPTugqXj+wE?=
 =?us-ascii?Q?aOLcQ8YIfhdOBRq/TbHkT1gkwExyYhNuOhbsyZsUlgnEgqoLGiaZb6WjONIc?=
 =?us-ascii?Q?TzFJ3b8Q88dS5Pj3UFCJgGRFFEUVkgyq1sZu1rx2rC8QQUs/+gyanlefhClK?=
 =?us-ascii?Q?YO/N/hij/lO1U+8FUqyXxpER9bPL5qzjMHSt1evUvcszZx9hcRTNVmfsQZFB?=
 =?us-ascii?Q?WwbNf/5ClEEBQcEGF6ZY9BI+RoJvXV4dok4wW6HOXgffUs6ae/EyS8uYpANA?=
 =?us-ascii?Q?UrI3lwodDFLop4Vcy0z5WxvLWpK+vkr77hbNDz07ZDI18WTHWD8HYrYHk38h?=
 =?us-ascii?Q?D1FTG8kra8VuqFTLv8XoYfQ8mo2iixckJXISzUwwI5Hjgys0HelKmhWK6S9H?=
 =?us-ascii?Q?Sl8ht/oXiE9Rgl15PW3bAyig/3+GTxwnZ8SWPwpN5mSK8Hek8aTlpg56seWv?=
 =?us-ascii?Q?9ZSsNOhEur+QzYS4dBz621b7Bz7kXG5aAIbgh9EZ6ZkhCdnuVJL9awbVv5QZ?=
 =?us-ascii?Q?hChIqURr065CP8bKPacIbCNtjvCR9KMrSHhewkzH55MtQMB7gemttuMfDbvr?=
 =?us-ascii?Q?0Lv66g+1D+p4sZ3djsM3KgVXIV4+uRSUFqOgM9nXvN0LWohR3HX7AbGHe1DQ?=
 =?us-ascii?Q?PM5wy/aYP+Tk2WEQqAc01rQhmv/4+IegM/2OZXsPAUJ+KLX5ci54b0Rz0bNN?=
 =?us-ascii?Q?bIP8PjyACgHCJwcuwjq6fMP3xoVygy0zdE9qJUISn8FY01gTL4CIyjUg5vwo?=
 =?us-ascii?Q?0lN6VMZfU22qzHSnMmPGFOdHbXpqnsc6F9No0+gLQ5ISs8Cs3ezSY2A2FCPo?=
 =?us-ascii?Q?CqIBOeLkO4i4x6uMKLLnULUCHDE8WdkhiLnbiwcqqTZylIUbuUS577FK1duw?=
 =?us-ascii?Q?MS/KLXOik9spSGHz/2HOdECKzj37AujZGj8KqFYXW5EOFu/0ia/t8CI9FF9F?=
 =?us-ascii?Q?o+ddgreh01SXSZgGlStqM7NJz6nRdD2mCahJ7UzcSGt1PZv1kCvAnyU+Glm9?=
 =?us-ascii?Q?llQ=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 24a3da1c-e2b9-499f-babf-08d96b0c0d5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2021 16:42:55.6710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0fZOfTDlIJkdnOaoT3uIkZlvsbZepfaxrBZrkGn3ps2DFQIRWkXMUm9kZeG3Lovbh1PFs5EsM9Q0HW4u8reYQxqs1Tix4XXT5XDbEaKDX3w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5046
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Sunday, August 29, 2021 5:10 PM
> Subject: Re: [RFC v2 net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
> message to get SyncE status
>=20
> On Sun, Aug 29, 2021 at 10:05:11AM +0200, Maciej Machnikowski wrote:
> >
> > This patch is SyncE-oriented. Future implementation can add additional
> > functionality for reading different DPLL states using the same structur=
e.
>=20
> I would call this more "ice oriented" than SyncE oriented.  I'm not sure =
there is
> even such a thing as "SyncE DPLL".  Does that term come from 802.3?  To m=
y
> understanding, that is one just way of implementing it that works on supe=
r-
> Gigabit speed devices.
>=20
Hi,
This interface is ITU-T G.8264 SyncE-oriented. It is meant to monitor the s=
tate
of Ethernet Equipment Clock.

ITU-T G.8264 recommendation defines Synchronous Ethernet equipment
as a device  equipped with a system clock (e.g., a synchronous Ethernet
equipment clock). SyncE interfaces are able to extract the received clock
and pass it to a system clock.

Please take a look at the 10.2 Operation modes of the G.8264 and at the Fig=
ure A.1
which depicts the EEC. This interface is to report the status of the EEC.

If you prefer EEC over DPLL I'm fine with the name change. I think it will =
be less confusing.

> I have nothing against exposing the DPLL if you need to, however I'd like=
 to have
> an interface that support plain Gigabit as well.  This could be done in a=
 generic
> way by offering Control Register 9 as described in 802.3.

This part of Gigabit interface is a different part of SyncE device. It cont=
rols Master/Slave
operation of auto-negotiation.=20
You would use it in slave mode if you want your EEC to tune to the frequenc=
y recovered
from network and to master if you use external source for your EEC and want=
 to send it
as a reference for another devices. The decision can be made based on the E=
EC state
read by the interface proposed in this RFC.

This is a functionality that belongs to a different interface mentioned in =
the next steps.

Regards
Maciek
