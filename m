Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2948B6465DC
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 01:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229756AbiLHA2J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 19:28:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiLHA14 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 19:27:56 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD68D48;
        Wed,  7 Dec 2022 16:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1670459274; x=1701995274;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=DXR70pnQHRuHiO47+aPt25db/wpstnSUZr5SH6IyDQk=;
  b=a6cdh8yDMEiFMKbjhj4kNX7SAFBWGW7OhtMNM04hG8pRy18Q9Ur/tI4z
   G77VGV/sEp5WKZh7eUOyu6KhDlreN90HTKbW2D6kBZT0ucuxUS4Fn5I40
   4zT3YhqtCb+YZ6EfHUEf/1h4mNwIdO9yopSrhEGF76+ZJF10zJk0or33r
   +jJXH4sHtUFCVBwDSQdMTBIJ0rL7KU4hPvOqqJxpp1NDMOLARA7CeRyUA
   p8k/2787clBLACrJbsLndcLyW+DlK9hc/oi0FaHDzvnZ/odYK2wAlJcb0
   2FZjMIBnZXLVqK0wIp6u1/Pq1zvEFm6D9w+UNAMSh9TaNOrf5dYKUIm0O
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="300455351"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="300455351"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Dec 2022 16:27:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10554"; a="771291968"
X-IronPort-AV: E=Sophos;i="5.96,226,1665471600"; 
   d="scan'208";a="771291968"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga004.jf.intel.com with ESMTP; 07 Dec 2022 16:27:52 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 16:27:51 -0800
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 7 Dec 2022 16:27:51 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 7 Dec 2022 16:27:51 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 7 Dec 2022 16:27:50 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OPHhRRy0gC00PBOuEnNMC+Md+7Gs4KwcmMa8+6bUC+Ta77vyZ/KduXWIutuofPY5e9hA94itXuXTn9CuFjWwtdPlhUd1ttSWiJTEfLQKaQZf1WscWb8J/JOuxTf0HlucmtG4DN2eB/vcYbTqbzzblhG2O9kUYNA/UL4gimnTK29Tf5+Q8Of0SK0PMXKjua3z2Pg1Fve1503rOoYWb93qEmICSE6o2p4BKkzKCr2oR8Yy9JYBytauXqjBFBOHXlc9RYhNFlXXEP8QxC+jYbSi5MOJj+pXcLpBd0hThFnJKBb5YLKv4kUAE4MxOnMFJJyYmKxtHXGqEM5ArkoCfFO6CQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KEYRppkwKGQheBc1hTFG3wHklBk4fEeRpRrG68GrU+I=;
 b=m4Cw8Mh+f20W37KLGpVivvhVWFQH7nAMdCrhxS2J+iuucQBG2lM1wi/CCO11xkf8YdAuYLcqYqEDdbFc4a9ejwq/dsMqcnObI8laBeFSacVoGwTeilS/eerP20YBb9mEM3pTw8UdOKkkAPrzwmbs6xOlzIpjgYoJ1KDsklYdnA1otZnjs+mUoRuumgsJV8tm3sC+D9jM3YHBtXQy+z333nj+PFwAiP+I8UFskJOewiU2aDFa5pOkxoZHE9jHTAUrvdInEZdrNmULmuxYIb6pD/BDPMFpOMPl7yvax+4fflanaXSy9KOefte8qZuOmXBVsKlN/wmpR8pQztJnqLQA3Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH8PR11MB7070.namprd11.prod.outlook.com (2603:10b6:510:216::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Thu, 8 Dec
 2022 00:27:43 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%7]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 00:27:43 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Vadim Fedorenko <vfedorenko@novek.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAIYWlQ
Date:   Thu, 8 Dec 2022 00:27:42 +0000
Message-ID: <DM6PR11MB4657E9B921B67122DC884A529B1D9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
 <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
 <Y4oj1q3VtcQdzeb3@nanopsycho>
In-Reply-To: <Y4oj1q3VtcQdzeb3@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH8PR11MB7070:EE_
x-ms-office365-filtering-correlation-id: 41456575-2a76-4d5e-189e-08dad8b3057a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m4uZKd4fEvsmBRZ+ixl7t67hB2F4idyDJDx9dc6MOzjKc3c1feXWPDs9W12JbnRz4aUjzJ/AkS2YyhuLYWS4ca9HjGvLWXYl1KhlgrSonlOUC1y/ZUmhu4RXP93Di0IWGZnv8yhQzoxjZTEPLZZHt/pCm9YvIy+IOLYV0OD2VCi0IN1unRgXD9MCQVtZPGPhDrVuPnkzjjoyX/tKJciVNT/22kWzwyifkhDl0Xe+blyFPoyRo3Ol2BNKf7GneVji4DmiqyufyY+kp4ToK/+Aa34NQizLpy5VEe1jvziyUKgQ+UNYIalPJGNR5mp/lbG6p3X0MiRJ5BrFApfORuFsJINjvjhQHcrtQ2JZQmzpEpL4NpMlQvyziSm/3PGqRfp+Qt8WxjCbXerEVFHchfQPCX/fc61ug7lhHRXBNdl1qi4rsNmzKFJTgFRd2T/xBHerH1q1TxAao/tj88KUQMbn2QPAGzj8VUc/Wm7l5e/UmwobX+ZYrsIyekB14CDnZipt8qrd6IsuSaY80umXvQ+ADHK2SLt9WJz49e1nC/gkCs4xAwAHxo59Xe6ExD9ODIjLxiQ9tEy14nHsjBtx+jDYuOKJ7A5rOdf8pjOrv4T5X882/6K8wLpnLp2Vr2xsPzFgTTa0DzlHuRsYDz3ZJkXhLymavK0hd+GeGjgd5hADiMKJQjNTBms9VSyjhY8TzPlmg5J6iqvbUz7jqFzVjQWNMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(346002)(39860400002)(376002)(136003)(451199015)(66446008)(82960400001)(52536014)(41300700001)(38070700005)(38100700002)(122000001)(30864003)(478600001)(71200400001)(2906002)(83380400001)(86362001)(186003)(8676002)(55016003)(9686003)(5660300002)(6506007)(7696005)(26005)(8936002)(33656002)(66556008)(316002)(6916009)(66476007)(76116006)(66946007)(64756008)(54906003)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?g1Npg8YGv+EU9w3UoLVv2appraGP41/RW/CYHZ6bD4O/linhToyc/5sZbQVu?=
 =?us-ascii?Q?1G/NkUVGZTwGlSZCgfPWJpgQU9rDI/Q7AQ6EMa8OuZaNIwJVmfHX7dfiHT27?=
 =?us-ascii?Q?tK53B9mI61UUYVFR0Fyodx2I4DnvyYBfwUnZdxi/x/MzQ0mr/BbRVqZdlepj?=
 =?us-ascii?Q?ENaKZwkyp2j13+zlzREnRA/O3ktNivknd8FhBSWEDujTiK61QbYci8QJ5ECd?=
 =?us-ascii?Q?W2D0Fze15nXQVR+1eypewsymBVuJVxmUBGLcBDR2MiCJc1mE3YD213JMw5vx?=
 =?us-ascii?Q?innYwOToRx8x41jlDtTnUlLRtxpl6diR0jQhUwpTyEm0f94vp9c7LLhJM7q6?=
 =?us-ascii?Q?Ydot8HEgClv3DiWE6m3QBCqy9mvRKCs2vB5Oob6p7vFubocVgZXTrZCj8igp?=
 =?us-ascii?Q?FG9LXvG8reRPiPwb8L/2uHtVVTjZGQLSdZOTTGvQ2ZtL7GH9GaRcishlT3Dm?=
 =?us-ascii?Q?YLIU7JDbLU5wDHc7fuclmwnrA5oNZp2/D24UOtRzYVDTuNzBC3RInxVkWAg5?=
 =?us-ascii?Q?2A8VqSuXS6UR5eVjQ5WojAyhNkCBrGumQwlqhZ4A+OhBqX3fUSU/NGWCYZ3+?=
 =?us-ascii?Q?/oEghiz+uGVE9nxmUW1PGrwOoCUAacZZ2auzhXIiMDDELJ6O3F5wxJam/UI6?=
 =?us-ascii?Q?6CYRDURahT++miM7Typ58xSbQB4D6KcDJTrY1m1hnWZZhLnFI6JBftA3OdPZ?=
 =?us-ascii?Q?cWT2wcmZt2FYEBY0Lxsq1UUhHS+m5OoLHJC28B1Cn5sN5r9QCLLH4IpM+ruJ?=
 =?us-ascii?Q?QQ4w+ZykbIQE6UMmPXiGHXT9sSLJ+kUcoQnRN/2yas7KrQsaP0e76yQYC6jv?=
 =?us-ascii?Q?97vnO5gM6TvGmi6PiQyeQ8liTV70BvVHHXMAmz+5CvgH9UYEn3KUWcus4I+T?=
 =?us-ascii?Q?kaW93GlRwpfh50oDpduYkBJecQdovEAMDyAEI4rqXXgZVgwu27THB/k1oV0L?=
 =?us-ascii?Q?sIco9dTwgKIi/wxVyUBX4HbW0mzjm4yK7dGXmbTLUE/1dfA1xB2vBzSIEOuC?=
 =?us-ascii?Q?Nmjw8jVCobbJfB2SOXen8x/89x/QI2lE9fUr4J7HjBZm8xRnPleB10Y+hjv6?=
 =?us-ascii?Q?4cws67TwOurlIb/21Mts1mlQFWok9U2+WT5uAw+h712ZsXc7Mtx7CfxDULUT?=
 =?us-ascii?Q?K7uoagp9RWHyxsbVOyLsdwmgGRyo1lYxBARn9ukxbDKx/AkAun60AizOyR8/?=
 =?us-ascii?Q?k8+EVTedQ+n6yIQuPYa7W5tIgiy8/PqvjsmgvdKDLwMXGEo6elSDmTd9BGb0?=
 =?us-ascii?Q?vh4InMyYgAI0VaaGS5CemYP1J7DyCvX7bM5VHxkmJuYedegkiE8Kj/5gA9Ii?=
 =?us-ascii?Q?rcgHSrFVsO7I1OSPMHv9a8eS778I1Sj3Hch6WhB8vpx0H6hdUmDwpyV9/U3Q?=
 =?us-ascii?Q?JwGKnmSdq9VW31bDZI/lmSYiAzZRa0RAakZbsN6cqX++No6x2+HfNUDIRiBs?=
 =?us-ascii?Q?tvciH0876VUsHfDJZGVCLIOVzXAzRU2x/MjU7eJX3qBV0CXBW7DoHkejWJd9?=
 =?us-ascii?Q?VUHBUI+eYJ2gAUAGPFCyUD8yhGGwt/4/pR/TcANt3hYIyLu4hykxYvE51Fx0?=
 =?us-ascii?Q?hdnESOqcH39AJV5rMd+vCIZW7aYk/cbDzT+BW4TjBzIEk3eGTKPUM8FuMu6Z?=
 =?us-ascii?Q?wA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41456575-2a76-4d5e-189e-08dad8b3057a
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 00:27:42.8667
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1IDs/DuE/8omu3amrKjs0lKn64Qbf2GzOoRrujq2jWw1e8D2wcyxJDVQPGFhzhFOA5QbNkQk5/jPh7XFcoCl+7Wef7akoyBoNUDz+ozCz90=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB7070
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Friday, December 2, 2022 5:12 PM
>
>Fri, Dec 02, 2022 at 12:27:24PM CET, arkadiusz.kubalewski@intel.com wrote:
>>>From: Jiri Pirko <jiri@resnulli.us>
>>>Sent: Wednesday, November 30, 2022 1:32 PM
>>>
>>>Tue, Nov 29, 2022 at 10:37:20PM CET, vfedorenko@novek.ru wrote:
>>>>Implement common API for clock/DPLL configuration and status reporting.
>>>>The API utilises netlink interface as transport for commands and event
>>>>notifications. This API aim to extend current pin configuration and
>>>>make it flexible and easy to cover special configurations.
>>>
>>>Overall, I see a lot of issues on multiple levels. I will go over them i=
n
>>>follow-up emails. So far, after couple of hours looking trought this, I
>>>have following general feelings/notes:
>>
>>Hi Jiri,
>>
>>As we have been participating in last version, feel obligated to answer t=
o
>>the concerns.
>
>Cool.
>
>
>>
>>>
>>>1) Netlink interface looks much saner than in previous versions. I will
>>>   send couple of notes, mainly around events and object mixtures and
>>>   couple of bugs/redundancies. But overall, looks fineish.
>>>
>>>2) I don't like that concept of a shared pin, at all. It makes things
>>>   unnecessary complicated. Just have a pin created for dpll instance
>>>   and that's it. If another instance has the same pin, it should create
>>>   it as well. Keeps things separate and easy to model. Let the
>>>   hw/fw/driver figure out the implementation oddities.
>>>   Why exactly you keep pushing the shared pin idea? Perhaps I'm missing
>>>   something crucial.
>>
>>
>>If the user request change on pin#0 of dpll#0, the dpll#0 knows about the
>>change, it reacts accordingly, and notifies the user the something has
>changed.
>>Which is rather simple.
>>
>>Now, if the dpll#1 is using the same pin (pin#0 of dpll#0), the
>complicated
>>part starts. First we have to assume:
>>- it was initialized with the same description (as it should, to prevent
>>confusing the user)
>>- it was initialized with the same order (this is at least nice to have
>from
>>user POV, as pin indices are auto generated), and also in case of multipl=
e
>pins
>>being shared it would be best for the user to have exactly the same numbe=
r
>of
>>pins initialized, so they have same indices and initialization order
>doesn't
>>introduce additional confusion.
>>
>>Thus, one reason of shared pins was to prevent having this assumptions
>ever.
>>If the pin is shared, all dplls sharing a pin would have the same
>description
>>and pin index for a shared pin out of the box.
>>
>>Pin attribute changes
>>The change on dpll#0 pin#0 impacts also dpll#1 pin#0. Notification about
>the
>>change shall be also requested from the driver that handles dpll#1. In
>such
>>case the driver has to have some dpll monitoring/notifying mechanics,
>which at
>>first doesn't look very hard to do, but most likely only if both dplls ar=
e
>>initialized and managed by a single instance of a driver/firmware.
>>
>>If board has 2 dplls but each one is managed by its own firmware/driver
>>instance. User changes frequency of pin#0 signal, the driver of dpll#0
>must
>>also notify driver of dpll#1 that pin#0 frequency has changed, dpll#1
>reacts on
>>the change, notifies the user.
>
>Right.
>
>
>>But this is only doable with assumption, that the board is internally
>capable
>>of such internal board level communication, which in case of separated
>>firmwares handling multiple dplls might not be the case, or it would
>require
>>to have some other sw component feel that gap.
>
>Yep, you have the knowledge of sharing inside the driver, so you should
>do it there. For multiple instances, use in-driver notifier for example.
>

This can be done right now, if driver doesn't need built-in pin sharing or
doesn't want it, it doesn't have to use it.
It was designed this way for a reason, reason of reduced complexity of driv=
ers,
why should we want to increase complexity of multiple objects instead of ha=
ving
it in one place?

>
>>
>>For complex boards with multiple dplls/sync channels, multiple ports,
>>multiple firmware instances, it seems to be complicated to share a pin if
>>each driver would have own copy and should notify all the other about
>changes.
>>
>>To summarize, that is certainly true, shared pins idea complicates stuff
>>inside of dpll subsystem.
>>But at the same time it removes complexity from all the drivers which
>would use
>
>There are currently 3 drivers for dpll I know of. This in ptp_ocp and
>mlx5 there is no concept of sharing pins. You you are talking about a
>single driver.
>
>What I'm trying to say is, looking at the code, the pin sharing,
>references and locking makes things uncomfortably complex. You are so
>far the only driver to need this, do it internally. If in the future
>other driver appears, this code would be eventually pushed into dpll
>core. No impact on UAPI from what I see. Please keep things as simple as
>possible.
>

The part of interface for drivers is right now 17 functions in total, thus =
I
wouldn't call it complicated. References between dpll instances and pins, a=
re
other part of "increased" complexity, but I wouldn't either call it
over-complicated, besides it is part of dpll-core. Any interface shouldn't =
make
the user to look into the code. For users only documentation shall be impor=
tant.
If kernel module developer is able to read header and understand what he ne=
eds
to do for his hardware, whether he want to use shared pins or not, and what
impact would it have.

Thus real question is, if it is easy enough to use both parts.
I would say the kernel module part is easy to understand even by looking at
the function names and their arguments. Proper documentation would clear
anything that is still not clear.

Netlink part is also moving in a right direction.

>
>>it and is easier for the userspace due to common identification of pins.
>
>By identification, you mean "description" right? I see no problem of 2
>instances have the same pin "description"/label.
>

"description"/label and index as they are the same pin. Index is auto-gener=
ated
and depends on initialization order, this makes unnecessary dependency.

>
>>This solution scales up without any additional complexity in the driver,
>>and without any need for internal per-board communication channels.
>>
>>Not sure if this is good or bad, but with current version, both approache=
s
>are
>>possible, so it pretty much depending on the driver to initialize dplls
>with
>>separated pin objects as you have suggested (and take its complexity into
>>driver) or just share them.
>>
>>>
>>>3) I don't like the concept of muxed pins and hierarchies of pins. Why
>>>   does user care? If pin is muxed, the rest of the pins related to this
>>>   one should be in state disabled/disconnected. The user only cares
>>>   about to see which pins are related to each other. It can be easily
>>>   exposed by "muxid" like this:
>>>   pin 1
>>>   pin 2
>>>   pin 3 muxid 100
>>>   pin 4 muxid 100
>>>   pin 5 muxid 101
>>>   pin 6 muxid 101
>>>   In this example pins 3,4 and 5,6 are muxed, therefore the user knows
>>>   if he connects one, the other one gets disconnected (or will have to
>>>   disconnect the first one explicitly first).
>>>
>>
>>Currently DPLLA_PIN_PARENT_IDX is doing the same thing as you described,
>it
>>groups MUXed pins, the parent pin index here was most straightforward to
>me,
>
>There is a big difference if we model flat list of pins with a set of
>attributes for each, comparing to a tree of pins, some acting as leaf,
>node and root. Do we really need such complexicity? What value does it
>bring to the user to expose this?
>

If the one doesn't need to use muxed pins, everything is simple, as you hav=
e
described. In fact in the example you have given, only benefit I can see fr=
om
muxid is that user knows which pins would get disconnected when one of the =
mux
group pins is selected. But do user really needs that knowledge? If one pin
was selected why should he look on the other pins?

Anyway I see your point, but this is not only about identifying a muxed pin=
s,
it is more about identifying connections between them because of hardware
capabilities they can bring, and utilization of such capabilities.
Please take a look on a comment below.

>
>>as in case of DPLL_MODE_AUTOMATIC, where dpll auto-selects highest
>priority
>>available signal. The priority can be only assigned to the pins directly
>>connected to the dpll. The rest of pins (which would have present
>>attribute DPLLA_PIN_PARENT_IDX) are the ones that require manual selectio=
n
>>even if DPLL_MODE_AUTOMATIC is enabled.
>>
>>Enabling a particular pin and sub-pin in DPLL_MODE_AUTOMATIC requires fro=
m
>user
>>to select proper priority on on a dpll-level MUX-pin and manually select
>one of
>>the sub-pins.
>>On the other hand for DPLL_MODE_FORCED, this might be also beneficial, as
>the
>>user could select a directly connected pin and muxed pin with two
>separated
>>commands, which could be handled in separated driver instances (if HW
>design
>>requires such approach) or either it can be handled just by one select
>call
>>for the pin connected directly and handled entirely in the one driver
>instance.
>
>Talk netlink please. What are the actual commands with cmds used to
>select the source and select a mux pin? You are talking about 2 types of
>selections:
>1) Source select
>   - this is as you described either auto/forces (manual) mode,
>   according to some prio, dpll select the best source
>2) Pin select in a mux
>   - here the pin could be source or output
>
>But again, from the user perspective, why does he have to distinguish
>these? Extending my example:
>
>   pin 1 source
>   pin 2 output
>   pin 3 muxid 100 source
>   pin 4 muxid 100 source
>   pin 5 muxid 101 source
>   pin 6 muxid 101 source
>   pin 7 output
>
>User now can set individial prios for sources:
>
>dpll x pin 1 set prio 10
>etc
>The result would be:
>
>   pin 1 source prio 10
>   pin 2 output
>   pin 3 muxid 100 source prio 8
>   pin 4 muxid 100 source prio 20
>   pin 5 muxid 101 source prio 50
>   pin 6 muxid 101 source prio 60
>   pin 7 output
>
>Now when auto is enabled, the pin 3 is selected. Why would user need to
>manually select between 3 and 4? This is should be abstracted out by the
>driver.

Yes, this could be abstracted in the driver, but we are talking here about
different things. We need automatic hardware-supported selection of a pin,
not automatic software-supported selection, where driver (part of software
stack) is doing autoselection.

If dpll is capable of hw-autoselection, the priorities are configured in th=
e
hardware, not in the driver. This interface is a proxy between user and dpl=
l.
The one could use it as you have described by implementing auto-selection
in SW, but those are two different modes, actually we could introduce modes
like: DPLL_MODE_HW_AUTOMATIC and DPLL_MODE_SW_AUTOMATIC, to clear things up=
.
Although, IMHO, DPLL_MODE_SW_AUTOMATIC wouldn't really differ from current
behavior of DPLL_MODE_FORCED, where the userspace is explicitly selecting a
source, and the only difference would be that selection comes from driver
instead of userspace tool. Thus in the end it would just increase complexit=
y
of a driver (instead of bringing any benefits).

>
>Only issues I see when pins are output. User would have to somehow
>select one of the pins in the mux (perhaps another dpll cmd). But the
>mux pin instance does not help with anything there...
>
>
>
>>
>>>4) I don't like the "attr" indirection. It makes things very tangled. It
>>>   comes from the concepts of classes and objects and takes it to
>>>   extreme. Not really something we are commonly used to in kernel.
>>>   Also, it brings no value from what I can see, only makes things very
>>>   hard to read and follow.
>>>
>>
>>Yet again, true, I haven't find anything similar in the kernel, it was
>more
>>like a try to find out a way to have a single structure with all the stuf=
f
>that
>>is passed between netlink/core/driver parts. Came up with this, and to be
>>honest it suits pretty well, those are well defined containers. They stor=
e
>>attributes that either user or driver have set, with ability to obtain a
>valid
>>value only if it was set. Thus whoever reads a struct, knows which of
>those
>>attributes were actually set.
>
>Sorry for being blunt here, but when I saw the code I remembered my days
>as a student where they forced us to do similar things Java :)
>There you tend to make things contained, everything is a class, getters,
>setters and whatnot. In kernel, this is overkill.
>
>I'm not saying it's functionally wrong. What I say is that it is
>completely unnecessary. I see no advantage, by having this indirection.
>I see only disadvantages. It makes code harder to read and follow.
>What I suggest, again, is to make things nice and simple. Set of ops
>that the driver implements for dpll commands or parts of commands,
>as we are used to in the rest of the kernel.
>

No problem, I think we will get rid of it, see comment below.

>
>>As you said, seems a bit revolutionary, but IMHO it simplifies stuff, and
>>basically it is value and validity bit, which I believe is rather common
>in the
>>kernel, this differs only with the fact it is encapsulated. No direct
>access to
>>the fields of structure is available for the users.
>
>I don't see any reason for any validity bits whan you just do it using
>driver-implemented ops.
>
>
>>Most probably there are some things that could be improved with it, but i=
n
>>general it is very easy to use and understand how it works.
>>What could be improved:
>>- naming scheme as function names are a bit long right now, although
>mostly
>>still fits the line-char limits, thus not that problematic
>>- bit mask values are capable of storing 32 bits and bit(0) is always use=
d
>as
>>unspec, which ends up with 31 values available for the enums so if by any
>>chance one of the attribute enums would go over 32 it could be an issue.
>>
>>It is especially useful for multiple values passed with the same netlink
>>attribute id. I.e. please take a look at
>dpll_msg_add_pin_types_supported(..)
>>function.
>>
>>>   Please keep things direct and simple:
>>>   * If some option could be changed for a pin or dpll, just have an
>>>     op that is directly called from netlink handler to change it.
>>>     There should be clear set of ops for configuration of pin and
>>>     dpll object. This "attr" indirection make this totally invisible.
>>
>>In last review you have asked to have rather only set and get ops defined
>>with a single attribute struct. This is exactly that, altough
>encapsulated.
>
>For objects, yes. Pass a struct you directly read/write if the amount of
>function args would be bigger then say 4. The whole encapsulation is not
>good for anything.

If there is one set/get for whole object, then a writer of a struct (netlin=
k
or driver) has to have possibility to indicate which parts of the struct we=
re
actually set, so a reader can do things that were requested.

But I agree this is probably not any better to the "ops per attribute" appr=
oach
we have had before, thus I think we shall get back to this approach and rem=
ove
dpll_attr/dpll_pin_attr entirely.

>
>
>>
>>>   * If some attribute is const during dpll or pin lifetime, have it
>>>     passed during dpll or pin creation.
>>>
>>>
>>
>>Only driver knows which attributes are const and which are not, this shal=
l
>
>Nonono. This is semantics defined by the subsystem. The pin
>label/description for example. That is const, cannot be set by the user.

True, it is const and it is passed on pin init.

>The type of the pin (synce/gnss/ext) is const, cannot be set by the user.

It can, as input/source can change, thus the same way, type of pin could be
managed by some hardware fuses/switches/etc.=20

>This you have to clearly specify when you define driver API.
>This const attrs should be passed during pin creation/registration.
>
>Talking about dpll instance itself, the clock_id, clock_quality, these
>should be also const attrs.
>

Actually, clock_quality can also vary on runtime (i.e. ext/synce). We canno=
t
determine what Quality Level signal user has connected to the SMA or was
received from the network. Only gnss/oscilattor could have const depending
on used HW. But generally it shall not be const.

Thanks,
Arkadiusz

>
>
>>be also part of driver implementation.
>>As I understand all the fields present in (dpll/dpll_pin)_attr, used in
>get/set
>>ops, could be altered in run-time depending on HW design.
>>
>>Thanks,
>>Arkadiusz
>>
>>>
>>>>
>>>>v3 -> v4:
>>>> * redesign framework to make pins dynamically allocated (Arkadiusz)
>>>> * implement shared pins (Arkadiusz)
>>>>v2 -> v3:
>>>> * implement source select mode (Arkadiusz)
>>>> * add documentation
>>>> * implementation improvements (Jakub)
>>>>v1 -> v2:
>>>> * implement returning supported input/output types
>>>> * ptp_ocp: follow suggestions from Jonathan
>>>> * add linux-clk mailing list
>>>>v0 -> v1:
>>>> * fix code style and errors
>>>> * add linux-arm mailing list
>>>>
>>>>
>>>>Arkadiusz Kubalewski (1):
>>>>  dpll: add dpll_attr/dpll_pin_attr helper classes
>>>>
>>>>Vadim Fedorenko (3):
>>>>  dpll: Add DPLL framework base functions
>>>>  dpll: documentation on DPLL subsystem interface
>>>>  ptp_ocp: implement DPLL ops
>>>>
>>>> Documentation/networking/dpll.rst  | 271 ++++++++
>>>> Documentation/networking/index.rst |   1 +
>>>> MAINTAINERS                        |   8 +
>>>> drivers/Kconfig                    |   2 +
>>>> drivers/Makefile                   |   1 +
>>>> drivers/dpll/Kconfig               |   7 +
>>>> drivers/dpll/Makefile              |  11 +
>>>> drivers/dpll/dpll_attr.c           | 278 +++++++++
>>>> drivers/dpll/dpll_core.c           | 760 +++++++++++++++++++++++
>>>> drivers/dpll/dpll_core.h           | 176 ++++++
>>>> drivers/dpll/dpll_netlink.c        | 963 +++++++++++++++++++++++++++++
>>>> drivers/dpll/dpll_netlink.h        |  24 +
>>>> drivers/dpll/dpll_pin_attr.c       | 456 ++++++++++++++
>>>> drivers/ptp/Kconfig                |   1 +
>>>> drivers/ptp/ptp_ocp.c              | 123 ++--
>>>> include/linux/dpll.h               | 261 ++++++++
>>>> include/linux/dpll_attr.h          | 433 +++++++++++++
>>>> include/uapi/linux/dpll.h          | 263 ++++++++
>>>> 18 files changed, 4002 insertions(+), 37 deletions(-) create mode
>>>> 100644 Documentation/networking/dpll.rst create mode 100644
>>>> drivers/dpll/Kconfig create mode 100644 drivers/dpll/Makefile create
>>>> mode 100644 drivers/dpll/dpll_attr.c create mode 100644
>>>> drivers/dpll/dpll_core.c create mode 100644 drivers/dpll/dpll_core.h
>>>> create mode 100644 drivers/dpll/dpll_netlink.c create mode 100644
>>>> drivers/dpll/dpll_netlink.h create mode 100644
>>>> drivers/dpll/dpll_pin_attr.c create mode 100644 include/linux/dpll.h
>>>> create mode 100644 include/linux/dpll_attr.h create mode 100644
>>>> include/uapi/linux/dpll.h
>>>>
>>>>--
>>>>2.27.0
>>>>
