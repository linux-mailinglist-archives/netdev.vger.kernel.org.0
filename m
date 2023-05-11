Return-Path: <netdev+bounces-1955-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 37F016FFB7D
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 22:53:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F3A0E1C21016
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 20:53:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CB238BA27;
	Thu, 11 May 2023 20:53:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E116FD3
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 20:53:27 +0000 (UTC)
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25A284EDA;
	Thu, 11 May 2023 13:53:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683838405; x=1715374405;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=9lMo8oANioN/5SgTvkhri2mYqm5jgLz6IUa80K+Tq2A=;
  b=MWC8gHd6jT/ztAZUOj4Icv8YVL0LaHDtXMDM/45JR0n8wCVSAhHnLGC3
   1sdCY+9rk80gwK1NWBQ5AgdmJq2epFGGQr9apdN00MMudBDw+halZEZ9N
   5N0w4LOpUzTbEI/y7l2qbwQCxtUyR1DKerv+iptStpQjHj4ST7pXqpAJk
   ueSj/d+WjFlulSECafywO/AbmEMkT09AK6jLGwDMQQc8a7jDkl5qGyrBA
   6C/pQ5C/m8+oFmS1PFMGLzdz1jBEc+ppu4nrIXwSI6ynem4QX1nmcOegs
   Iy5wgPu6gjFuuDJg50/8aHj1QYQOZc78UROPTO325eqiuXXtcY9QG6Umr
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="330993564"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="330993564"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 13:53:24 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="693973660"
X-IronPort-AV: E=Sophos;i="5.99,268,1677571200"; 
   d="scan'208";a="693973660"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 11 May 2023 13:53:24 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 11 May 2023 13:53:24 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 11 May 2023 13:53:24 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.169)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 11 May 2023 13:53:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fmjKKnPQJjWrwJXvqtPeRFNb8zDHgEI2H+7mDc1TCAVRx3DTPS+8ffFj1oS92kYzhHFTozKLsOA8ovH03IwgZbcUMJycWX7N0OzLh8uSVTlX6UkYTYZUaXYLh7HylgspHleAKkjsSjlCbPTHupyx2NnRNJfS1PDGl7eqIhexUTBl/uOcskbuLwuQzC7K55WNDib4sm7YE326q0C28yLvAJnt7yz119IrwN1cU7DbLWheYM7oZibaIq7qea50vtFvUdEBjnZJRwNM0i8B2+782wRiOOIORKsrs/Dm6ahgLA7OsIuxCp2dUes2AuweEDaxWcK1VbG1+SfHEwIQ0j9aPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yAqXLFnIfS0mHq+9cpvSvYpasKNakpPD4a62PDP/JAY=;
 b=gOZSAAktDAMAv0RVIbWAXl1qUgGdx9v1V50hmq+PueliiBHFC1F2AZOSfy9Kcg/vHCPnTQ/mt62EpmiCkbC1YwBjEU+E8BOw7H8OhRPbmj8Pk0PMgcBqB5y8ThDXRL4pqgSqI2aRJiM+djQW+mZ+dKljEEsPYcaZg0Piq/82dnBd07WWRc2u77QkgkdqXBEKnPcLcFJGfKDXIi1/A2Ewog+rsGGogndY77xJrCnImqQQfO1Wcov7vXaSN0+ybTTf+ozemwaeVC+JhCHNFpo6o7kqN8yn11oufL+nfN1F7UN6OEIftLvaz6dDbcmrgrEUj+Np2Di2iyol7/75xC/D8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH7PR11MB6932.namprd11.prod.outlook.com (2603:10b6:510:207::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.21; Thu, 11 May 2023 20:53:21 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::7887:a196:2b04:c96e%5]) with mapi id 15.20.6387.022; Thu, 11 May 2023
 20:53:20 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
CC: Vadim Fedorenko <vadfed@meta.com>, Jakub Kicinski <kuba@kernel.org>,
	Jonathan Lemon <jonathan.lemon@gmail.com>, Paolo Abeni <pabeni@redhat.com>,
	"Olech, Milena" <milena.olech@intel.com>, "Michalik, Michal"
	<michal.michalik@intel.com>, "linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>, Vadim Fedorenko
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Topic: [RFC PATCH v7 1/8] dpll: spec: Add Netlink spec in YAML
Thread-Index: AQHZeWdNus9yie+T1ke/i4FdVA4f5K9KDcsAgAGJJECACTd5gIAAnE7w
Date: Thu, 11 May 2023 20:53:19 +0000
Message-ID: <DM6PR11MB46577B2C09A1D3A8EFAAD4039B749@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230428002009.2948020-1-vadfed@meta.com>
 <20230428002009.2948020-2-vadfed@meta.com> <ZFOe1sMFtAOwSXuO@nanopsycho>
 <MN2PR11MB466446F5594B3D90C7927E719B749@MN2PR11MB4664.namprd11.prod.outlook.com>
 <ZFyj5c//3NV4en12@nanopsycho>
In-Reply-To: <ZFyj5c//3NV4en12@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH7PR11MB6932:EE_
x-ms-office365-filtering-correlation-id: bbeba1fa-b989-4026-159a-08db5261c09e
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: re5UcDe0A8rO8mpzaImyhl/9ViBZmP3g0Ao5DXcUbiml/wbYDeICI7GavjSFJQPTYX/ngqmbT7S+eqwZp1YUZ7SxmZGp2VtS93yEX3fhnaRgMguPoLU8Hu6Ea0FEQWt3VMrbSQPAAgSQV+OSyCcFS8DEJV2cc47NBCgXwqBPOSCOyapCOcm+DSNFxQzaMVd9OC8/eeLiyq3Ky782bxU2Q0JxkK5ty5dCqxqP3QhGHmKu4+7ZxctzFOC66Im481hC+P24QpVf5Zylml0jCvAcgFwiNC2UlWPOvWW7f5JRLaQrbN4Ct3ntX4BXCqNu8KaZT6ADk7o2BRX9SXyi6r2r/jPp0S8VrCF92dZ3qc1zXErueOvpDaT59gj68CdzXFXp6Cf1d5uqflMPpwV6Nox7eikXStoEdfEOZDAIlvqOE/33Pr5gIUoNGHUD0rPb31wy5OR0h8942IHvCdZJrHKiX26GACdnH2NEmt3VH0ZMq9sozqvNn7LL9fl1s8xduDN2/JaokfQEh97UdoGsvC6lVY5rv4iHq3J5SRttwOPiAf+BcgQpwtGq7L5X61xmZ2/RIuLvLV46MDsOF3eUPRLZRvvcHSr2id9Qxfc39g3NGKb+ZejoLdbLJY9yEqegfTWk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(376002)(396003)(136003)(39860400002)(451199021)(6916009)(5660300002)(41300700001)(52536014)(66946007)(76116006)(4326008)(316002)(66446008)(64756008)(66556008)(66476007)(8676002)(7416002)(8936002)(478600001)(54906003)(86362001)(2906002)(55016003)(38100700002)(83380400001)(7696005)(6506007)(9686003)(71200400001)(38070700005)(82960400001)(186003)(33656002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9wq88oW5w6/htSzusGiggaYOZ1CIpGidztCP/Ve18oKnbNsy8vDtGs3Yqe7C?=
 =?us-ascii?Q?xRX5UhYWsSEGNhtAuR2zz7/PPT3uOtf44puxPJHfCIBegVOtZJ8Wub3HaCgH?=
 =?us-ascii?Q?U11ZMLStNfCsAvDOqJfDYW/OtprG8Ap8D4v89QSEBQHZXPuIPEB3NSatNFxF?=
 =?us-ascii?Q?KMtlFp522Nrai9quCrlFkWkzTYrA6l0qixrmCyTCoq8xfAAeg1ztnhRKlQiY?=
 =?us-ascii?Q?0f9V/HvLBpZMxBaACcQDpu5nwzl2MLpginT61Hm1MzQGrXp00sbtrENLDGa7?=
 =?us-ascii?Q?i6AQHtQRH1MAQ5y1gGip5NDaBqPEK3Z5jVf0YNzILg/SvrG6uzGvw+ruEEtZ?=
 =?us-ascii?Q?Q5r/NjHnhLyiewJZSyJn/jcKlliPpxrBqf4jPOwsQ9ib/KVCgy3CB5ejrVfk?=
 =?us-ascii?Q?FT++OWYWQAFK6JOu0QQjysqiEv7SD2bLlxot2sfKn87Cd9cWE2PwsH7YE4zx?=
 =?us-ascii?Q?hXrVFbMGswvoi2Yu059HWuGLS1ewN3yYgZj95Zl36kzjVHmnG+42uL/wdaOK?=
 =?us-ascii?Q?/vpK5DlSAF18JckjyoZJ6TNAx3thkJtKHAgjVfEhCHIBnZ2ntKPnmH79lK2c?=
 =?us-ascii?Q?HCjXKCMgDYtMCWKIJTf8S6Bw6JnqlxeyMYRagUFH2Yf6BJfELwmb92AZmBt8?=
 =?us-ascii?Q?n/ewqg2RH3eL+iMOLQFbxXeGhHYSwsqocqXgZL7n/UrQGc+fmPm54Q02zR4l?=
 =?us-ascii?Q?+SLZGcMrBx7EsatjGEQ+l31bwCE9jlXy78q5m8RIoQEJvE+QrRHctVbDYVAu?=
 =?us-ascii?Q?HvHHbuu6jsRZZZFxLQag++Q7RECeMzY5uK+fKDBu9q5jpfXPpJRbJfgGEZnq?=
 =?us-ascii?Q?R+I3s14+2Gh8orwGf1ISaaDXFdHiwAz22VMYi/KXDGr5Oh1Yi/nrWBcirTIT?=
 =?us-ascii?Q?tFz4waNmbTq3zH+nz1w6lIyROOp9kzcyDWRblAXSbICZS0jkma6laKXp+cjG?=
 =?us-ascii?Q?2dLZ0GPwJ9aY5PFEorndXhHTa8U2F8ZQhG4Tmk2EVfhxTCg64Hg02ZQJq5fp?=
 =?us-ascii?Q?m9KIRZVTQsHU+93Ji98j5C2MB5M60erdGhpW/80ZcMhTBbTXljDM97MSK7Ln?=
 =?us-ascii?Q?IjzYbkihtoIiKX3n51Rlqh3BKHKMo+k4a1gKbXAnMazrYbLQp5+dwBzOo4FL?=
 =?us-ascii?Q?kl3FppjZm5XyXtIwUujzoHXM1VJNxSyg2o9pbBqojXPBlifVAKg8ItXOhbOA?=
 =?us-ascii?Q?4iBwdSDLkCgAJYRv2EqXHhdTPiOG4AHjYfI1nAfv7q+f17ARrPPrYeBUHFWG?=
 =?us-ascii?Q?l12SJabbZZK44Ojsc6yonnkpKFBi3k2GqR7d2RujHxB0YrOYyijaxUFkZZf0?=
 =?us-ascii?Q?dnKLm04/VZBLYEzxgk4jAbfFkLtFjOYzxjVygqrS8YSZ/N3ZG4N1J0VAtL1T?=
 =?us-ascii?Q?E6soj1iCblVfotP16RtjpkAH+qE35HZ8V9M5rIJqb5wfoKphn3hEYTcASaHE?=
 =?us-ascii?Q?nVGIyROkjoRbMZAadg1galhepLRiZq+ynuc29g/HjD3TcIormBGZNS5Ctw/G?=
 =?us-ascii?Q?K3BxSHAUMoorfHCJxafSxZGSITNW9RXpk3gJOudn7y8Dqc2dU27F9Ua64d2x?=
 =?us-ascii?Q?nQPC8LErslPruULkAMw7w1AJYjSAj1EADTRGfKI3?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bbeba1fa-b989-4026-159a-08db5261c09e
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2023 20:53:19.9352
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RLQUF3xNsrPCa/CA0HdAThcNQ0SQGBNSS9pX7cF8wCysPVNJGPwY7P/aqDnfdKKgf0v+MTrkD69X4eUdJwFZxkwpLhP9tcl7RoCE4YLjLck=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6932
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, May 11, 2023 10:14 AM
>
>Thu, May 11, 2023 at 09:38:04AM CEST, arkadiusz.kubalewski@intel.com wrote=
:

[...]

>>>>+      -
>>>>+        name: holdover
>>>>+        doc: |
>>>>+          dpll is in holdover state - lost a valid lock or was forced =
by
>>>>+          selecting DPLL_MODE_HOLDOVER mode
>>>
>>>Is it needed to mention the holdover mode. It's slightly confusing,
>>>because user might understand that the lock-status is always "holdover"
>>>in case of "holdover" mode. But it could be "unlocked", can't it?
>>>Perhaps I don't understand the flows there correctly :/
>>>
>>
>>Yes, it could be unlocked even when user requests the 'holdover' mode,
>i.e.
>>when the dpll was not locked to a valid source before requesting the mode=
.
>>Improved the docs:
>>        name: holdover
>>        doc: |
>>          dpll is in holdover state - lost a valid lock or was forced
>>          by selecting DPLL_MODE_HOLDOVER mode (latter possible only
>>          when dpll lock-state was already DPLL_LOCK_STATUS_LOCKED,
>>	  if it was not, the dpll's lock-status will remain
>>          DPLL_LOCK_STATUS_UNLOCKED even if user requests
>>          DPLL_MODE_HOLDOVER)
>>Is that better?
>
>See my comment to this in the other branch of this thread.
>

Sure, gonna reply there.

[...]

>>>>+      -
>>>>+        name: int-oscillator
>>>>+        doc: device internal oscillator
>>>
>>>Is this somehow related to the mode "nco" (Numerically Controlled
>>>Oscillator)?
>>>
>>
>>Yes.
>
>How? Why do we need to expose it as a pin then?
>

Sorry, I messed up something with that answer..
It is not related to NCO (as NCO uses SYSTEM CLOCK to produce frequency).

It is a type of a pin which source or output is somehow internal. I.e.
our dpll's can syntonize to the 1 PPS clock signal produced by network chip=
.
As for other use-cases it could serve as way of having one or more oscillat=
ors
on board connected to input pins.

[...]

>>>>+    type: enum
>>>>+    name: event
>>>>+    doc: events of dpll generic netlink family
>>>>+    entries:
>>>>+      -
>>>>+        name: unspec
>>>>+        doc: invalid event type
>>>>+      -
>>>>+        name: device-create
>>>>+        doc: dpll device created
>>>>+      -
>>>>+        name: device-delete
>>>>+        doc: dpll device deleted
>>>>+      -
>>>>+        name: device-change
>>>
>>>Please have a separate create/delete/change values for pins.
>>>
>>
>>Makes sense, but details, pin creation doesn't occur from uAPI perspectiv=
e,
>>as the pins itself are not visible to the user. They are visible after th=
ey
>>are registered with a device, thus we would have to do something like:
>>- pin-register
>>- pin-unregister
>>- pin-change
>>
>>Does it make sense?
>
>From perspective of user, it is "creation/new" or "deletion/del".
>Object appears of dissapears in UAPI, no matter how this is implemented
>in kernel. If you call it register/unregister, that exposes unnecessary
>internal kernel notation.
>
>No strong feeling though if you insist on register/unregister, it just
>sounds odd and funny.
>
>Anyway, one way or another, be in-sync naming wise with device events.
>

Sure going in sync with device event names seems best option, will fix as
suggested:
- pin-create
- pin-delete
- pin-change

>
>
>>
>>>
>>>>+        doc: |
>>>>+          attribute of dpll device or pin changed, reason is to be
>found
>>>>with
>>>>+          an attribute type (DPLL_A_*) received with the event
>>>>+
>>>>+
>>>>+attribute-sets:
>>>>+  -
>>>>+    name: dpll
>>>>+    enum-name: dplla
>>>>+    attributes:
>>>>+      -
>>>>+        name: device
>>>>+        type: nest
>>>>+        value: 1
>>>
>>>Why not 0?
>>>
>>
>>Sorry I don't recall what exact technical reasons are behind it, but all
>>netlink attributes I have found have 0 value attribute unused/unspec.
>
>I don't see why that is needed, I may be missing something though.
>Up to you.
>

Will leave it as is, if no other comments.

[...]

>>>>+      attribute-set: dpll
>>>>+      flags: [ admin-perm ]
>>>
>>>I may be missing something, but why do you enforce adming perm for
>>>get/dump cmds?
>>>
>>
>>Yes, security reasons, we don't want regular users to spam-query the driv=
er
>>ops. Also explained in docs:
>>All netlink commands require ``GENL_ADMIN_PERM``. This is to prevent
>>any spamming/D.o.S. from unauthorized userspace applications.
>
>Hmm, I wonder why other read cmds usually don't need this. In fact,
>is there some read netlink cmd in kernel now which needs it?
>

Seems drivers/net/team/team.c uses it for get, but anyway this is a "least
privilege" security principle, if regular user cannot do anything with that
information, there is no point on providing it.

>
>>
>>>
>>>>+
>>>>+      do:
>>>>+        pre: dpll-pre-doit
>>>>+        post: dpll-post-doit
>>>>+        request:
>>>>+          attributes:
>>>>+            - id
>>>>+            - bus-name
>>>>+            - dev-name
>>>>+        reply:
>>>>+          attributes:
>>>>+            - device
>>>>+
>>>>+      dump:
>>>>+        pre: dpll-pre-dumpit
>>>>+        post: dpll-post-dumpit
>>>>+        reply:
>>>>+          attributes:
>>>>+            - device
>>>
>>>I might be missing something, but this means "device" netdev attribute
>>>DPLL_A_DEVICE, right? If yes, that is incorrect and you should list all
>>>the device attrs.
>>>
>>
>>Actually this means that attributes expected in response to this command =
are
>>from `device` subset.
>>But I see your point, will make `device` subset only for pin's nested
>>attributes, and here will list device attributes.
>
>Yes, that is my point. The fix you describes sounds fine.
>
>

Thank you!
Arkadiusz

[...]

