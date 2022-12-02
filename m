Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA696405CA
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 12:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233132AbiLBL1n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 06:27:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232399AbiLBL1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 06:27:40 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F14FE6C;
        Fri,  2 Dec 2022 03:27:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669980455; x=1701516455;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TaVF0ovdnM8vsPx2ZHC2B44LsBXT7ptcQLQEatPL9tk=;
  b=bVcoFVcNfrRymFh2dfVCbEnFOm1Mf/WFOajXHjVKnB/xaa+Us0Uzms2U
   sZMYUYEE8lDE5fSP4sT/Bb3TFpDvjmLXWJB6xr83EGcQOzwuUMFDYyvaR
   ACSDF5pS+HruzyWZVVUgUa/Jh/qTDg4nV13mTY+X9mOyZT2rNjWgUJgXS
   UQMuWRnx81kyjp7jmYJyy+J4k8N+RZrVdlmbAcvnGY7tRQ9I/XYK9VJN9
   /BZwfY2/4j+nZ89Uaxr6NnM504hUAx0uDJS60MI5OfI7gw1J2ReGMDOQj
   yam5mE1HCKRDyreA21CCnL3uQZxA7m8cNZ1VumEJLId6moGSGAcYULMtn
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="317794234"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="317794234"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2022 03:27:34 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10548"; a="638726061"
X-IronPort-AV: E=Sophos;i="5.96,212,1665471600"; 
   d="scan'208";a="638726061"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga007.jf.intel.com with ESMTP; 02 Dec 2022 03:27:34 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:34 -0800
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:33 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 2 Dec 2022 03:27:33 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 2 Dec 2022 03:27:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HB6YDMq8716ccFsFpncur0sjXsQXn1aMiKOntsO1wDXlLMtE2pjgMk7yC40suMroFrDEtvn9AaLhLcA1KxU2tshx5M4dqp7bGt9Ds/pMr1FPosyoj9dovcfC8UrMzhLkiXkcbkz/ClUUMseuh6eR1vonelcXELgV1N5e3JZaEuZ4/XNYsKxTfOdoB0VN++lErieFlcS5rOBpFFxy86tdmlgd8us+l0kyLQdwD2+fjkTYA3t+tZlmPieAf+cuIDon3T+kwGmGHm5Sybt2/tMTfUIOnjzMzsWdph1AFTQqXZNlxred229guDfSsgwDTLeJVjWv5lJcDTw1Al3qoMH1sw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MrAJH7UqmhHq44YZEf3kwM/7o9ZOYkJkOh1lZxZLHy4=;
 b=SMZZRdobBo+palpWTdqMmKryU1VD1IcpplmWhp7eofuRV88dhq7fisKAmxuI4TnSsU6BlEMTW9/nuRjnNURTEYnMDdrVK8QNcdFjasCV/Y9ItBykFgZqqT0HwCY8nu6+J3kcRNYvA1QSA5sI88MVdP4bwv0e+kxhtmGrjPcqvsbRsTJtm+kHPMXMI9Xht/68dGRfw77oO0dQXriTr2J6studzUKBWZg9VD+cn0IoPM2tq9M056tw3hQUDngssPx+HM6qwDfh+51qC9Z9ot1Uhd5Yg4b8QY0wJ0hr9eiIJ2YGumCc+tsb1SlxplcFvIIQ0SFl/L5zAJOpN9FbPW7UVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DS7PR11MB7806.namprd11.prod.outlook.com (2603:10b6:8:db::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.10; Fri, 2 Dec 2022 11:27:25 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 11:27:25 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        Vadim Fedorenko <vfedorenko@novek.ru>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oA=
Date:   Fri, 2 Dec 2022 11:27:24 +0000
Message-ID: <DM6PR11MB4657003794552DC98ACF31669B179@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221129213724.10119-1-vfedorenko@novek.ru>
 <Y4dNV14g7dzIQ3x7@nanopsycho>
In-Reply-To: <Y4dNV14g7dzIQ3x7@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DS7PR11MB7806:EE_
x-ms-office365-filtering-correlation-id: 1b7e74d4-cbf9-4c94-3eb7-08dad4582fbd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 18O4La/I+f79Qv5r9DRIvRqTsHZC1qq2tx/HczXfeT9jQs+5uWVVnwSWHogLKy60Nuk9cWXIkVsSUijFnuBOz+0Y8kpN8tUiV16PZ8Q3VoPTynY/guh5ygjEI7deSoBFtBpp8D2w35ZOzlqHhducb1jGwqf1xyq7XrqFQdFeAGHjCwbUm9XcQ423WJxbaK6vzkM7/VNpnlb+viHAwXSAbB+aMIxbM5FBEecWd0vTVVYaIV7qlulxOSPnwS6ScDNQzCV8u7BFxz5Yb8+njCezDknWFClsP60bPp4vmlTuN7lEp9ARv6Gj3Mmiz8unM3dcrPDTTPetCYUdNB3Cj2TbhejTQkeDxg5/uXh1/NRmtx992NjZwAUL/JzF9IkKdaZfifTS/wHCj7qx3GclRKXV1wP2npz3cL+irsIPSn2TSgCsPcjHBBOQS+jjG5lqehEcWf2nPluzHUmlkafW09cL3pssbnbKqozlWh+RBrT4Fyxr+zFv2zIKt5oxslvaZ/2bexJpYB1G2dYX9Evhv6Cxt/aEbHPh4+mZqn6ydbrrMNppYSC1frm7E3frcTFhkbHIH//yz22hbJ9ij/qlfXoGPWYh84VfoBQyxZtWe33I8/igSmXUT1bT8eCMx21FAtlyIA979FDKTdneTMoQkAhUULqGx2ew6hl8GeRxgTDMUbZ1Ebq7sAPWFmjgZS+Znit27OU4sa6Z1vWDsJcvvlM1YQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199015)(26005)(186003)(66446008)(71200400001)(6506007)(7696005)(8676002)(66476007)(64756008)(66556008)(66946007)(478600001)(4326008)(41300700001)(5660300002)(52536014)(8936002)(30864003)(83380400001)(2906002)(76116006)(122000001)(82960400001)(9686003)(316002)(86362001)(54906003)(110136005)(38100700002)(33656002)(55016003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?9kbDdv7gK96GIgNqWq5NIQrEHP9nFe8Kgsj3WVkquNZLdkGY3yKkaCtHW0Cz?=
 =?us-ascii?Q?fRvm2CYqgBjSGxEVe2p4PQm84qNORoWvdrN5L192NtbUoutei+5ktL3rEBmy?=
 =?us-ascii?Q?cPSGS8INy9Me5PBFXGNtJaXJuf8cbSyvwP1Y2qoasEgbgXTFuII67wnI71uL?=
 =?us-ascii?Q?OU80Cx8e1pOt7qycSZJyloMl7zPi97yAByLLra0EE0QtayWIy052ywR2XeQS?=
 =?us-ascii?Q?2NPukqLgIRGS0GltqguECgTyBh8kMHR69+7kaqXD48v7GhQaOGZ6M0rv/r+c?=
 =?us-ascii?Q?E+fA6MiTNFeAzshuXsWZbzfzer0M6XvsXCxd5TsKfMrWOgA/KrmZweCipwjn?=
 =?us-ascii?Q?+oOP6h0F4NQNyujIMDEvDoD2YDqe9JFfOIPexyqu4ela71lYOldkEQI2yyVl?=
 =?us-ascii?Q?reoTjdHl445yihTB9r1UYVGrjzFEWd5zTRlAoVw+Z19PVYS2mI9nIOYIZIR9?=
 =?us-ascii?Q?gcV4W+Em5NCND2rAw8blwChk3BVyDws+MqaBSxi14Uzz4y9BhcpOlqLHqHmi?=
 =?us-ascii?Q?6t6UZqjZ4CNkb+XbqIMOVs+C8Xz0do88x3Hef8rL1p6xnI/+2LScgpHcyZxA?=
 =?us-ascii?Q?wZkpF8LA58/b8ZlrAQ8WqfZTcwhiBlCQ/ms8z6HJSnzOiCGprNp0XodFPEOo?=
 =?us-ascii?Q?SAetf8nDFaxjiKj/Z8liQSywPjTSBWeboHgFVLIRMDTUYu8qMJBq/Ko/z6gn?=
 =?us-ascii?Q?bAIrWvacliZMkHjOv1qTakfp99B9o7eEGixd0DBznr1LCLjBmJT9HVKmAXQ9?=
 =?us-ascii?Q?MmN5+UTOwbVmYXqfLos5mKU0Ayh2vBUg2OpYPfWDRyLferlrVIpdOBGEfpu+?=
 =?us-ascii?Q?Lu5hjMHP9T17jAEU+5Zh/Jqxmt1iU69oCoQpJv6zEttZ2BLE+SpPPPaPVceK?=
 =?us-ascii?Q?mvzv76WDw4a7s8FBVp5phcDV+XR/F0J6Txy12UrQzXCAcfOoILydnsOGfWU6?=
 =?us-ascii?Q?PvmiISagjspEsXXpXClhMtIAUd2cEjVthO5xTjxGUY1A9YrCDzHwt98ZMJrG?=
 =?us-ascii?Q?b6MmBWOLcNqd7P48zUVv9I7o8QVaXwCKcYzEsxp12SZ/Y+elpVKzAGAasCvB?=
 =?us-ascii?Q?dcZWVeTXGWc7qxE32gNO5SVcMLmu+ElXo/rK1SseFUcV1ijm/aH8p5va9boM?=
 =?us-ascii?Q?ORZb28uRcDPj13E5PfwmUJZp+sbMJH57XKt+jER4aSF3UqenjGsg30fmUrsV?=
 =?us-ascii?Q?KeMShcdlfzPfUTakqMol7f7TV9nwc6QcCEX4As/9xlwgsxQgBGO/ZqJnc8+U?=
 =?us-ascii?Q?7HLijVPanhLPf/8QmymYAbNjV4rtg1Rsx0rh+CspcRMCnHHYp/AWaRyMcSEO?=
 =?us-ascii?Q?KrD/RusvrcrAnUHCYbjgTsHmKagIZdnw9bLYhKOtI7qBFClt7yBVBW9T7JLp?=
 =?us-ascii?Q?FK6bF7JUhYmvFIypqVui5tLs2wnRE3/+/ZI8jJekDezo5cN8JkginTqZIrDC?=
 =?us-ascii?Q?DPMApuD1vtrgbj10BPOq2OcgVJKQ6wlNlY1FEQa8zcPhdNJIlHNi5TzkG4n6?=
 =?us-ascii?Q?A+4cNSDj+GEGnX5hdUDXP3V/zRC32FSIM8HZpqI7JK4KELD0C/hryTs8o1Nq?=
 =?us-ascii?Q?OPvOC7nsP7qH5vtC6lfRNrfQIBDO/aA995j5/wcg6zgFBcVy9ugF3ZFxIiKj?=
 =?us-ascii?Q?mw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7e74d4-cbf9-4c94-3eb7-08dad4582fbd
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 11:27:24.9175
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: v+NLbiJx+2uUQaNdNivz6ycy6WtnsKHUBFqmD20wqxfKe6i7mzJoavYzA9t6p/v5W6b3Tdu3kG4TWVi60IxgzNFSdqkIsxpF7VKPfQzyd1U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7806
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Wednesday, November 30, 2022 1:32 PM
>
>Tue, Nov 29, 2022 at 10:37:20PM CET, vfedorenko@novek.ru wrote:
>>Implement common API for clock/DPLL configuration and status reporting.
>>The API utilises netlink interface as transport for commands and event
>>notifications. This API aim to extend current pin configuration and
>>make it flexible and easy to cover special configurations.
>
>Overall, I see a lot of issues on multiple levels. I will go over them in
>follow-up emails. So far, after couple of hours looking trought this, I
>have following general feelings/notes:

Hi Jiri,

As we have been participating in last version, feel obligated to answer to
the concerns.
=20
>
>1) Netlink interface looks much saner than in previous versions. I will
>   send couple of notes, mainly around events and object mixtures and
>   couple of bugs/redundancies. But overall, looks fineish.
>
>2) I don't like that concept of a shared pin, at all. It makes things
>   unnecessary complicated. Just have a pin created for dpll instance
>   and that's it. If another instance has the same pin, it should create
>   it as well. Keeps things separate and easy to model. Let the
>   hw/fw/driver figure out the implementation oddities.
>   Why exactly you keep pushing the shared pin idea? Perhaps I'm missing
>   something crucial.


If the user request change on pin#0 of dpll#0, the dpll#0 knows about the
change, it reacts accordingly, and notifies the user the something has chan=
ged.
Which is rather simple.

Now, if the dpll#1 is using the same pin (pin#0 of dpll#0), the complicated
part starts. First we have to assume:
- it was initialized with the same description (as it should, to prevent
confusing the user)
- it was initialized with the same order (this is at least nice to have fro=
m
user POV, as pin indices are auto generated), and also in case of multiple =
pins
being shared it would be best for the user to have exactly the same number =
of
pins initialized, so they have same indices and initialization order doesn'=
t
introduce additional confusion.

Thus, one reason of shared pins was to prevent having this assumptions ever=
.
If the pin is shared, all dplls sharing a pin would have the same descripti=
on
and pin index for a shared pin out of the box.

Pin attribute changes
The change on dpll#0 pin#0 impacts also dpll#1 pin#0. Notification about th=
e
change shall be also requested from the driver that handles dpll#1. In such
case the driver has to have some dpll monitoring/notifying mechanics, which=
 at
first doesn't look very hard to do, but most likely only if both dplls are
initialized and managed by a single instance of a driver/firmware.

If board has 2 dplls but each one is managed by its own firmware/driver
instance. User changes frequency of pin#0 signal, the driver of dpll#0 must
also notify driver of dpll#1 that pin#0 frequency has changed, dpll#1 react=
s on
the change, notifies the user.
But this is only doable with assumption, that the board is internally capab=
le
of such internal board level communication, which in case of separated
firmwares handling multiple dplls might not be the case, or it would requir=
e
to have some other sw component feel that gap.

For complex boards with multiple dplls/sync channels, multiple ports,
multiple firmware instances, it seems to be complicated to share a pin if
each driver would have own copy and should notify all the other about chang=
es.

To summarize, that is certainly true, shared pins idea complicates stuff
inside of dpll subsystem.
But at the same time it removes complexity from all the drivers which would=
 use
it and is easier for the userspace due to common identification of pins.
This solution scales up without any additional complexity in the driver,
and without any need for internal per-board communication channels.

Not sure if this is good or bad, but with current version, both approaches =
are
possible, so it pretty much depending on the driver to initialize dplls wit=
h
separated pin objects as you have suggested (and take its complexity into
driver) or just share them.

>
>3) I don't like the concept of muxed pins and hierarchies of pins. Why
>   does user care? If pin is muxed, the rest of the pins related to this
>   one should be in state disabled/disconnected. The user only cares
>   about to see which pins are related to each other. It can be easily
>   exposed by "muxid" like this:
>   pin 1
>   pin 2
>   pin 3 muxid 100
>   pin 4 muxid 100
>   pin 5 muxid 101
>   pin 6 muxid 101
>   In this example pins 3,4 and 5,6 are muxed, therefore the user knows
>   if he connects one, the other one gets disconnected (or will have to
>   disconnect the first one explicitly first).
>

Currently DPLLA_PIN_PARENT_IDX is doing the same thing as you described, it
groups MUXed pins, the parent pin index here was most straightforward to me=
,
as in case of DPLL_MODE_AUTOMATIC, where dpll auto-selects highest priority
available signal. The priority can be only assigned to the pins directly
connected to the dpll. The rest of pins (which would have present
attribute DPLLA_PIN_PARENT_IDX) are the ones that require manual selection
even if DPLL_MODE_AUTOMATIC is enabled.

Enabling a particular pin and sub-pin in DPLL_MODE_AUTOMATIC requires from =
user
to select proper priority on on a dpll-level MUX-pin and manually select on=
e of
the sub-pins. =20
On the other hand for DPLL_MODE_FORCED, this might be also beneficial, as t=
he
user could select a directly connected pin and muxed pin with two separated
commands, which could be handled in separated driver instances (if HW desig=
n
requires such approach) or either it can be handled just by one select call
for the pin connected directly and handled entirely in the one driver insta=
nce.

>4) I don't like the "attr" indirection. It makes things very tangled. It
>   comes from the concepts of classes and objects and takes it to
>   extreme. Not really something we are commonly used to in kernel.
>   Also, it brings no value from what I can see, only makes things very
>   hard to read and follow.
>

Yet again, true, I haven't find anything similar in the kernel, it was more
like a try to find out a way to have a single structure with all the stuff =
that
is passed between netlink/core/driver parts. Came up with this, and to be
honest it suits pretty well, those are well defined containers. They store
attributes that either user or driver have set, with ability to obtain a va=
lid
value only if it was set. Thus whoever reads a struct, knows which of those
attributes were actually set.
As you said, seems a bit revolutionary, but IMHO it simplifies stuff, and
basically it is value and validity bit, which I believe is rather common in=
 the
kernel, this differs only with the fact it is encapsulated. No direct acces=
s to
the fields of structure is available for the users.
Most probably there are some things that could be improved with it, but in
general it is very easy to use and understand how it works.
What could be improved:
- naming scheme as function names are a bit long right now, although mostly
still fits the line-char limits, thus not that problematic
- bit mask values are capable of storing 32 bits and bit(0) is always used =
as
unspec, which ends up with 31 values available for the enums so if by any
chance one of the attribute enums would go over 32 it could be an issue.
=20
It is especially useful for multiple values passed with the same netlink
attribute id. I.e. please take a look at dpll_msg_add_pin_types_supported(.=
.)
function.

>   Please keep things direct and simple:
>   * If some option could be changed for a pin or dpll, just have an
>     op that is directly called from netlink handler to change it.
>     There should be clear set of ops for configuration of pin and
>     dpll object. This "attr" indirection make this totally invisible.

In last review you have asked to have rather only set and get ops defined
with a single attribute struct. This is exactly that, altough encapsulated.

>   * If some attribute is const during dpll or pin lifetime, have it
>     passed during dpll or pin creation.
>
>

Only driver knows which attributes are const and which are not, this shall
be also part of driver implementation.
As I understand all the fields present in (dpll/dpll_pin)_attr, used in get=
/set
ops, could be altered in run-time depending on HW design.

Thanks,
Arkadiusz

>
>>
>>v3 -> v4:
>> * redesign framework to make pins dynamically allocated (Arkadiusz)
>> * implement shared pins (Arkadiusz)
>>v2 -> v3:
>> * implement source select mode (Arkadiusz)
>> * add documentation
>> * implementation improvements (Jakub)
>>v1 -> v2:
>> * implement returning supported input/output types
>> * ptp_ocp: follow suggestions from Jonathan
>> * add linux-clk mailing list
>>v0 -> v1:
>> * fix code style and errors
>> * add linux-arm mailing list
>>
>>
>>Arkadiusz Kubalewski (1):
>>  dpll: add dpll_attr/dpll_pin_attr helper classes
>>
>>Vadim Fedorenko (3):
>>  dpll: Add DPLL framework base functions
>>  dpll: documentation on DPLL subsystem interface
>>  ptp_ocp: implement DPLL ops
>>
>> Documentation/networking/dpll.rst  | 271 ++++++++
>> Documentation/networking/index.rst |   1 +
>> MAINTAINERS                        |   8 +
>> drivers/Kconfig                    |   2 +
>> drivers/Makefile                   |   1 +
>> drivers/dpll/Kconfig               |   7 +
>> drivers/dpll/Makefile              |  11 +
>> drivers/dpll/dpll_attr.c           | 278 +++++++++
>> drivers/dpll/dpll_core.c           | 760 +++++++++++++++++++++++
>> drivers/dpll/dpll_core.h           | 176 ++++++
>> drivers/dpll/dpll_netlink.c        | 963 +++++++++++++++++++++++++++++
>> drivers/dpll/dpll_netlink.h        |  24 +
>> drivers/dpll/dpll_pin_attr.c       | 456 ++++++++++++++
>> drivers/ptp/Kconfig                |   1 +
>> drivers/ptp/ptp_ocp.c              | 123 ++--
>> include/linux/dpll.h               | 261 ++++++++
>> include/linux/dpll_attr.h          | 433 +++++++++++++
>> include/uapi/linux/dpll.h          | 263 ++++++++
>> 18 files changed, 4002 insertions(+), 37 deletions(-) create mode
>> 100644 Documentation/networking/dpll.rst create mode 100644
>> drivers/dpll/Kconfig create mode 100644 drivers/dpll/Makefile create
>> mode 100644 drivers/dpll/dpll_attr.c create mode 100644
>> drivers/dpll/dpll_core.c create mode 100644 drivers/dpll/dpll_core.h
>> create mode 100644 drivers/dpll/dpll_netlink.c create mode 100644
>> drivers/dpll/dpll_netlink.h create mode 100644
>> drivers/dpll/dpll_pin_attr.c create mode 100644 include/linux/dpll.h
>> create mode 100644 include/linux/dpll_attr.h create mode 100644
>> include/uapi/linux/dpll.h
>>
>>--
>>2.27.0
>>
