Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B084A427472
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 01:58:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243907AbhJIAAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 20:00:44 -0400
Received: from mga18.intel.com ([134.134.136.126]:8540 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243798AbhJIAAn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 20:00:43 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10131"; a="213560482"
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="213560482"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Oct 2021 16:58:47 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,358,1624345200"; 
   d="scan'208";a="440099273"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga006.jf.intel.com with ESMTP; 08 Oct 2021 16:58:47 -0700
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Fri, 8 Oct 2021 16:58:47 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Fri, 8 Oct 2021 16:58:47 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Fri, 8 Oct 2021 16:58:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nE4HWW09VKmvZCLyisYPSVbtnbfzKYgWJDC3LnWCQDCD8nBqPtBE0dTLYL+Zb5406+jpa4G+hEsQUBUiTPzgzXTJxwRRctFeqIsJfKeHeHjiMbQ6hX/UtyrJFKpecV+l/52Cq9wWt2JvvaN/AS9DQHeJxSDH5/LiXCrQ/fLYCwhPz7CBrn3m2znhacfv1eqZy4bSr/OLiPyihvG3Kg9lhRQ7/RYt2jwKLDg8Gc9pBxjRXiQI35nsACp76mRbdET1yoIIJXZg6feLG12E8VfqxKSlLS9Id4Jvy6/Yc1tv/gNyIlL2DpklmS3U5uerIdYGxbzbti+jV7wieXOLBFiUtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=WgcjNqKyT5BbctbMd4QaAh30QMv1O7IAnuP1idZnTTI=;
 b=cA49X7p1CD7bqHI/yAWVr7kGxMifk51CmQyDuI9Gexm4UX4rLXvRGkqsnH8EzTyDEVuULvoGs1h+ffYGSJvqVa08EW6q8HppYY7HE0E7NRQ27AMUUGopsZlX73NznSBiHhigRSjAUIBPy+X8Ox9gZV8pUJis6+pbRb447XNzFl1l+l/ECUNXLIXBblsfXa1z0WjWgeW5cxl0B04XsTgF9E+3bEmxpcHu2VacWdOmBzFHQdaxboBqJpLxtgI59t6vd73BymEyld+YQrzFg+9skZIx/ek2Uf+XM6qZD8upjjyDPvbYp4DGXU6OPkWTk1AUnE/tzqm5DjO/b1CRw/78yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WgcjNqKyT5BbctbMd4QaAh30QMv1O7IAnuP1idZnTTI=;
 b=U0PHkrPp2f+SxBlnNY+r7QXYOOBKr0RLr7P6ztM1SO3RpgNFs89IxVjk2Eg9lTws/COxZZPQnbolySsNQ/wTV7tnydtb8UFojVHhwHkOhCWavDxXiiwIVpHpSmDOweiJqmEtO5fYs1JkFvtPr/ujNZxnlT7V5Yqfd2S8B+wnViQ=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1838.namprd11.prod.outlook.com (2603:10b6:300:10c::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4566.22; Fri, 8 Oct
 2021 23:58:45 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::44fe:ee1:a30d:ecb8%9]) with mapi id 15.20.4587.024; Fri, 8 Oct 2021
 23:58:45 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [net-next 0/4] devlink: add dry run support for flash update
Thread-Topic: [net-next 0/4] devlink: add dry run support for flash update
Thread-Index: AQHXvDEgAtyYxjU5D0ijvkxpgH04qavJCiqAgABgN4CAADgc8IAADsAAgAALbUA=
Date:   Fri, 8 Oct 2021 23:58:45 +0000
Message-ID: <CO1PR11MB5089A8DC692F9FCB87530639D6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20211008104115.1327240-1-jacob.e.keller@intel.com>
        <YWA7keYHnhlHCkKT@nanopsycho>
        <20211008112159.4448a6c1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CO1PR11MB5089797DA5BA3D7EACE5DE8FD6B29@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20211008153536.65b04fc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211008153536.65b04fc9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f982de6b-359f-4942-7cd2-08d98ab7909c
x-ms-traffictypediagnostic: MWHPR11MB1838:
x-microsoft-antispam-prvs: <MWHPR11MB1838D1FDC98CE43CAA3A39D6D6B29@MWHPR11MB1838.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /mJDImlDhSgfYoTM3j7HLtbONeGBD8m0srPBISvBH1R/ZWqJGsR26xsN6H8fH9IGNuudxAciEkgb4q1b7o4gjQrsghx2xxN4T9cuN/yOXKi8HwenKvgWSX0IGaNDjtc8T+PDkh245rTBtJFyhdKYkkaf5rYwPRiwdYGWU2DnHf49u1V/f0m657q/Vza/8LthHrLkeRWFcB7wh4nCxBusDfpbE3V7a3gYzGRw0YJtTygDIq4KAKBs4K+7d5yqJC6e3bHoO0pD+lSfgWfGKG4UTn7r43zqUuGMGhZcN40fy2Ykjzf79Y/sRAu5q4MdLNB+xyhMSiRUhShEN9f3bv1gP0QHFqBh6CnHl81kgj+ha9RoMmPTaduOmslCB+aHa4yKA1ynBBZnbuUUXONK239yMyApm4N7/mTOTAXtEpqV/jNgnHm6V3ezOzHH+KoId4m0NT9K5UTaD1rLDX8IlTDjNkwQhy+NHC5SV9n8Wp5mV6O9NyaHkyTjzTnH0XrbfhQYgG+caDQ2+D54i+Y5Rul9VTF5L+1St2uQKJOqp0YH0HIz9e1vDVNSIYWmzVlNR9Yo4wWbWmkj1s+Vm2egnItWouWAmNpiLCWKyD6SHiT61SnGBY5Y0bBac4+ibwljNTyIj9t66BGg6BU1eN45fYdK2DyEIw65/X2Pd8y43MCtE1sRi8YRDu+7YoGsdMu3eYEOAzldAdlTp1UcSKKPitARGA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(5660300002)(33656002)(4326008)(6506007)(53546011)(71200400001)(122000001)(26005)(38100700002)(508600001)(186003)(52536014)(8676002)(66556008)(9686003)(66476007)(6916009)(66446008)(83380400001)(316002)(38070700005)(15650500001)(64756008)(2906002)(76116006)(54906003)(7696005)(8936002)(66946007)(86362001)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?QaKMfKMPFouV/7zSPZYAhgVfk8WvKpMbZnurNetAlKB8gaBsXtNKLMKphkyj?=
 =?us-ascii?Q?O/sa70BAmLSvcH1YPNDDhyTEGUSCzYsp5GxQIi77fbqUyQHPyU+Wk9+Rt82e?=
 =?us-ascii?Q?UA1ljwyFs8nX4n0sHT4On0TaXANMBbcfzla2OPZELaiYjCd2m8PZf07Fxwn5?=
 =?us-ascii?Q?K040fOXxDi8Rgx/qvfBk1GwWhvjdTvrHh9HnO4eY8h0PDG95a1zzjYeQLv2G?=
 =?us-ascii?Q?7qd+dZ4HLyTBPWgKN+UqT+WUUU1Uuxm3ltRuqDarFwz8OpJrQENbBwKdKE/7?=
 =?us-ascii?Q?CTKNnhqHrmnaGAipoztuaoc617MZvZgVJgdnvGLUp9mFZm9nmGV8bYmI09o0?=
 =?us-ascii?Q?2VYyitT79SiGjI1yk2i5NjSOg9SKZc9cXJWmdR8gSheMR565l4GzbJ5bAiBS?=
 =?us-ascii?Q?hLAlQjugarWs6Yi7SolJHXqJZBEcUE3kutYO1GSZFlP8fh3BT1mWP5IobqU+?=
 =?us-ascii?Q?TQZpfLaxkE8w1erzKLtrb2D2mGOrmnZtRHPTDaivrWlOc8n5WEUb6yzQnpbb?=
 =?us-ascii?Q?+RqI8YYBaK4B8KFetoNLEmqOaCPYoJZ6c/HsluuXjmegp+6N8rhNg5Gs52os?=
 =?us-ascii?Q?tRICw2CGFYH2bUhYOFO/nSoks4T+HoZ1ChADDX0J+ih5Ib/QTMTDwQ8oZSv3?=
 =?us-ascii?Q?3WJAbioORiqXkpIPtNOUgYO2gpR/S6pvsjFRmZpfRUFKEt6XuGwIoTdvwTqF?=
 =?us-ascii?Q?UNggHOh6IyHloGny6zDXTLbvbsjFcin/Z4zValN19xhabIybSpdEBCap3Vv5?=
 =?us-ascii?Q?CtQ94SxAMjSoLdjLAi36qrcGV5hD2qdBEscH1iFn2wezYsEoll163lR02tay?=
 =?us-ascii?Q?7SpV40oyKmV01ywsncfVQlbylEEUlkt4mqGYBTWvVRPbHt1YNU+BsFEwyd7P?=
 =?us-ascii?Q?fc4145DC3tUdJ8TLPFS7S6uKEnt6SkNBF+AZgvoiuQcoz25ncYUMy1w8uTe6?=
 =?us-ascii?Q?ycL5oms89NOqlQZ7AedCzhs417C4Cqo7R6cJnFTzkRa77Sw3yYgV/2fvOwYc?=
 =?us-ascii?Q?162lkpnMQF4b+h3Z0tOgfodAUpkkSgSAqawwC0GWIW7Ps3FNMnO2W3n5EX8F?=
 =?us-ascii?Q?cegPha6dMdR5oy5/TOLpYTYaXmGvEk4ZDc+dy8gT0vKWKaWxc+yhRI9+sGG5?=
 =?us-ascii?Q?ytwahHnQJ8A1kqh9LJnbTkHSCjUGrF9sn+x+GtAlKj4/KxXK/h2E5ZjNHQVM?=
 =?us-ascii?Q?8GDCGxL6bGGD8ycOZuaxwUng7hgFShT6Jen8RoxqLaIi3F0samkud4Ixm2oc?=
 =?us-ascii?Q?zr3/ODnatrZxGuqCifw++PDrdWTQXk9KrInDYpQcufc+8marhEnEMn6lc5gd?=
 =?us-ascii?Q?+Jntxg2hg09E/72CFUdM7UZt?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f982de6b-359f-4942-7cd2-08d98ab7909c
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2021 23:58:45.8035
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wI0STixBv3oazXQ7cgcM+BBMOGeoPXO8/r0IbigF0Mhnd7xlFcjHHWiKfpKjQSQAgnbmzgkjPiXoYKEhkbDpYC1cp/KNfqAlObdkJIEcE5Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1838
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, October 08, 2021 3:36 PM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org
> Subject: Re: [net-next 0/4] devlink: add dry run support for flash update
>=20
> On Fri, 8 Oct 2021 21:43:32 +0000 Keller, Jacob E wrote:
> > > > Hmm, old kernel vs. new-userspace, the requested dry-run, won't be
> > > > really dry run. I guess that user might be surprised in that case..=
.
> > >
> > > Would it be enough to do a policy dump in user space to check attr is
> > > recognized and add a warning that this is required next to the attr
> > > in the uAPI header?
> >
> > Doesn't the policy checks prevent any unknown attributes?
> > Or are unknown attributes silently ignored?
>=20
> Did you test it?
>=20
> DEVLINK_CMD_FLASH_UPDATE has GENL_DONT_VALIDATE_STRICT set.

Hmm. I did run into an issue while initially testing where DEVLINK_ATTR_DRY=
_RUN wasn't in the devlink_nla_policy table and it rejected the command wit=
h an unknown attribute. I had to add the attribute to the policy table to f=
ix this.

I'm double checking on a different kernel now with the new userspace to see=
 if I get the same behavior.

I'm not super familiar with the validation code or what GENL_DONT_VALIDATE_=
STRICT means...

Indeed.. I just did a search for GENL_DONT_VALIDATE_STRICT and the only use=
s I can find are ones which *set* the flag. Nothing ever checks it!!

I suspect it got removed at some point.. still digging into exact history t=
hough...
