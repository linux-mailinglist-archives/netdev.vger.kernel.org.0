Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F425665D88
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232518AbjAKOSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:18:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239328AbjAKOR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:17:58 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9520C777;
        Wed, 11 Jan 2023 06:17:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673446646; x=1704982646;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=1Ev+4GuVYUQxOGMiwnVMA3q55CkHuv6AXhgNFzz4LCI=;
  b=BzUgHI1fd9im/pv/pqf023ONINuS6ddBXKNMOjCXJJbWFUWLs96sodXd
   S425eA9Gn8qPjk2b8iPKLfCMj74YcOt4lYZCCzvaVGQlhv/RryRbu3Lsa
   UHoBfkSXUO7IPKEZbVB7Ub1s6nxZy4ziD9oKrYqi14ZGX7uzcwW9/h7BM
   L6wkrW3a1HjxaS3hngTersJVuEBO0HjQNJqCpXEgQbgbx9xNyqNQKe0xT
   db8UD/tGhZpHPrnlx0PRbEKRJghpLPgEOvlPVOCOT6e8dsVOmC5WfF3ga
   X5/iOCm9WCXvasZ9JwV825e5Hz6QmLv8lFZ+f/TLIDWCHRSouvwaMqRui
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="306937263"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="306937263"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2023 06:17:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10586"; a="765159795"
X-IronPort-AV: E=Sophos;i="5.96,317,1665471600"; 
   d="scan'208";a="765159795"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga002.fm.intel.com with ESMTP; 11 Jan 2023 06:17:02 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 06:17:01 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 11 Jan 2023 06:17:01 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 11 Jan 2023 06:17:01 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 11 Jan 2023 06:17:01 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4wS3gsm2v8T7qlkylbi9Q+XRkq0yl1hfKkyf7IUx7XdGoE61RHm1TMbNyL+ee2FvMa7cUNsbnmcaViv4iP5n9rcb1e5mcmPqDfij6BZDzkgmcPkb1Ycldy9vpeVu/Rbu7DTEAPEeDNIbBmoqeciaHsgBmDBv3JxVmDtaY0rDFVm9NRK/RXW7NQqTVz3GWy4XkKpEmiMRzOyESnuvwhsMhMu0bhwpdPd/B8FRtRgcbR90mm7xTx5EHFwyWubCFxCxibHVcx8OFXefYr9QI1NSBToxywCnWhHIn7stKUCmNHGwzPQ8ijAIFvkMWmDJn8+l0YkMqUCygvbhLqsgCIOPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Ev+4GuVYUQxOGMiwnVMA3q55CkHuv6AXhgNFzz4LCI=;
 b=URnL4qJAEW/Pglmq0xpfA0zUJxCCuH649kViXpymueEmQPYK/XqjYDyW4jo5DHWVwKmtPw2vBv/G9tLFnjVh4brXQgOK7FmRvc7hPSdPzMEXGari2DiH+TKSxMSU1dbMgcjvhKE2Okv+f1XGqn+TytoOk4mgX9th54l0g5VzTwET16taUUqkh2I9yLStZSvJO2Gtiz8vi6VsbAtwGEugBYl8LHZMkUhexOJDjjVySqcbZxOpmA6NIwQ0XP4qUlnbhHF8Iutwx+E+bKdc3wqjrYxJ/BqwmDWGy4tDZ8UtKLFAWo6U6A22SVkGhooPQ8i35x7AsAa9sDSoiUIzvKNvuw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DS7PR11MB6102.namprd11.prod.outlook.com (2603:10b6:8:85::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5986.18; Wed, 11 Jan 2023 14:16:59 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::5006:f262:3103:f080%8]) with mapi id 15.20.6002.013; Wed, 11 Jan 2023
 14:16:59 +0000
From:   "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To:     Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC:     Maciek Machnikowski <maciek@machnikowski.net>,
        'Vadim Fedorenko' <vfedorenko@novek.ru>,
        'Jonathan Lemon' <jonathan.lemon@gmail.com>,
        "'Paolo Abeni'" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>
Subject: RE: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Topic: [RFC PATCH v4 0/4] Create common DPLL/clock configuration API
Thread-Index: AQHZBDr1K1GsCJct2UayQH1vPDEq/65XZyGAgAMK4oCAAFcrAIAG+ucAgAC+YICAAJp7gIABOqIAgAEc44CAADKwAIAAJ6gAgASMcoCALA0RgIAB7ReAgADNAgCAAF4QcA==
Date:   Wed, 11 Jan 2023 14:16:59 +0000
Message-ID: <DM6PR11MB4657AC41BBF714A280B578D49BFC9@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20221206184740.28cb7627@kernel.org>
 <10bb01d90a45$77189060$6549b120$@gmail.com>
 <20221207152157.6185b52b@kernel.org>
 <6e252f6d-283e-7138-164f-092709bc1292@machnikowski.net>
 <Y5MW/7jpMUXAGFGX@nanopsycho>
 <a8f9792b-93f1-b0b7-2600-38ac3c0e3832@machnikowski.net>
 <20221209083104.2469ebd6@kernel.org> <Y5czl6HgY2GPKR4v@nanopsycho>
 <DM6PR11MB46571573010AB727E1BE99AE9BFE9@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230110120549.4d764609@kernel.org> <Y75xFlEDCThGtMDq@nanopsycho>
In-Reply-To: <Y75xFlEDCThGtMDq@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DS7PR11MB6102:EE_
x-ms-office365-filtering-correlation-id: ee356a2f-9d0f-46a7-6829-08daf3de80c6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2hTErMwbjWvWJirzbd99S2cKRmuR6XrVIJZRT3ZfSPn+cn1Phiw3P41Ap7Gt6zs3/nRSlXN3rqp8U5Jp/mVBXwDzg71p9fzQqJVQbwx23czxMTjc+rpYWc/8A0zQsDrc70tdvi1SAiIuJ5sW8IoFirA7b0PMdGb+qS23IlzgHTJsSTm7Hm6TTV6/NL4rMPMq/KVPUQQa3UIKE8cR2iWil6mqNXYU+7IJwITt5UZnVF35cO+/cOOiUfrv3rkj+stp5ZACQlzLCKvX0a96Saka5COWBiHndAeGYT5BlAMWAcT3rtUrTtoU98lHi716WdPLwIe1qOJCHn51X9ZiB9J/JHQuf+Pyx2F/Ry4I30a0yLcgCEnVuugkuEDbPqIn0q2m6G2m9ZuFjFg3SalEHAzOHhtb801iP53apW29T7MeyBSoMRqEn2Lzwv8lsNEwM5S7x6a6fPR7B4nmMclDL7GIM/KvEFmSX+uhNyW83C486cM/NW4NmsFcOJAyM6iIoHIisz7YEbD2agWvv6t/GuE4OBYN1SY3hjOGK0BYAq+jDWv5A9whRmGJjy3TvOuosSqiFQ/YEMC+9gqnQVxGBknzaQNmYIYbKq6TIQW8wsM/C06ZU0ju7S9aUue8ofPag85b+T1OkWtE2yXvfivUiGsaqHo1v1wZwsoSjsFd+4Kj1fs7n7trW+kvhBK04yuT07mMqN4XO3hPj1BwCdoMskbRqB+pt+EofGTyVMHtrc2vi/A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(39860400002)(366004)(396003)(376002)(346002)(451199015)(6506007)(38070700005)(71200400001)(186003)(26005)(9686003)(7696005)(86362001)(5660300002)(54906003)(316002)(2906002)(110136005)(478600001)(33656002)(82960400001)(8676002)(66476007)(4326008)(66446008)(64756008)(66946007)(76116006)(38100700002)(66556008)(41300700001)(8936002)(52536014)(83380400001)(55016003)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?D+WMHsRsVphpLCOuqQvUipL8ewwTZ0NbelBvQKYbn8GsxEdH82zCysf1/eVM?=
 =?us-ascii?Q?YE2yEKqrovI2hmRaLhoaFCuhOj6ap06dym+dpgdJemtGyp0aCjem/AJvG4eC?=
 =?us-ascii?Q?Cub772hH3nvXdZjPHuEt8Ghy9SwWb0w0+f/v2UnD3NkleytWtcO2HGBO9/jv?=
 =?us-ascii?Q?Vh/LWkClIiq2rGrIXEO3JznvDYdQYR9xx8VXv0aHJgthc2Tiw9ozuZF+nFF1?=
 =?us-ascii?Q?SU1z+JPPQQ9D8L4yIqRICcGAiRP/B5Z8+6VMf6isWzbcexyATofZGbqIAlmM?=
 =?us-ascii?Q?xWKf77I69d6g0ei0zmv7PvVId4Wrfw1KnHY5d5OSPJrXF2lpbHM7Mvt+dD0z?=
 =?us-ascii?Q?GoxMxVmKPw4KuOvPefM6ujnJGMuaeCt6OHCI00I/2vaj6ElhQSrZHPeM1vpi?=
 =?us-ascii?Q?MEocjvfBeaqsfcCzT+81wrH8tgEQ3c3bERee1k8U1oxKhqU5yDYDRUt8pWHV?=
 =?us-ascii?Q?2MCG8PyD7W2iwb7oqNSmejSrWVvUoHh9O1r8F16z3DJ5kNNSogcFh2upHPuH?=
 =?us-ascii?Q?lw3HCQd0qdI27WtpI4a68/zFxGS6Oy7LOtUmF8Ns3pBMmQ7PP7ACeAxUFUg2?=
 =?us-ascii?Q?pT9KY1S1N8FQkkAhKCxsMoLnKLU8mZ1lb/UbEUgNlZiCUc4oVBOFjd36WEJx?=
 =?us-ascii?Q?BD0RSfcl59+49HO4JlZ9f8yQizI7x3BwxN2k6nmJWOlTOKvnt10dbhD4LDAu?=
 =?us-ascii?Q?eo4TjH+TlJQmStG5nDU//oZKw7QpkkiekTdmXhK53pJ4tui95D0rGAVrUZHE?=
 =?us-ascii?Q?+CRcOesSP9BxBVNQ8WOfbkkebCWnByj2NhGkPpwSLWCaHB1LdPJR0tC0PgS9?=
 =?us-ascii?Q?cF/QF8u0YYXcB5JeKC4jKcGHOcpfY0wwQEbaH/id9p/bFn5hS8zAzKPlP5e2?=
 =?us-ascii?Q?N8JJSrUSFxGYQk91hG9wdBjNAp1uXxtLSbMk2CKXKwr/DuOuKjvOLb/Oe3Lm?=
 =?us-ascii?Q?REv7g03FT5HcEhSb4XuVDu2wN5k+EuquuoTsmFEeo/8Ehx8yvxno3W3gVJin?=
 =?us-ascii?Q?U9jnR5080cR3nO90pJDULcMvFi/Z3iL4XHzGMyEufsaZ1+NYh0ut8KEe9yMl?=
 =?us-ascii?Q?3opbiJYJRoLgfuBBYSvaGNrRSUJoj/doyjQslvqURUKBiGWphBWveB2yCxio?=
 =?us-ascii?Q?Ysh4jaObJK5LUyKnePwf6YGuSOsZocOYbQp5mI3Ka/PuYU0SqUxeoP8lD9Q0?=
 =?us-ascii?Q?XCoMX65BcUhwYfX5CyFshw9E+hFdluUFpu0LUZeumreMAYOQ/dnUjaOTTyjR?=
 =?us-ascii?Q?Mr28GG9pCvwPmUnnrTI+TUmpuxU5+XR88Ds4d9TBsYFqV5f0eaYuN4NqKkxd?=
 =?us-ascii?Q?GKYGtNA+uJ5MsJ30NAnfECK128zKhdEYXb/67UfDWaUXAPd+iizoIh/LIVi9?=
 =?us-ascii?Q?I5LasNg8hstgv3aGCuK2zybSwvlHdv+rEo36F2+aWIu3JQWHLQNM4h8GzgR4?=
 =?us-ascii?Q?0YDaFEfnYVpivOoQb+kn6vyHaKqzgp/gvVg7WkdcYxY7tbCNe3SXIPnh+tBg?=
 =?us-ascii?Q?sFbwtRskyek+HjI/knhwmyjwbRaaMFML8U+raTrh4egBKix774al3/gmDGXw?=
 =?us-ascii?Q?qXPSiNQ1piHD3c23qMGYQ6Kzj5f0Mbl7DS7FJdDwR92YJKa3cKeyo2OK4Ozd?=
 =?us-ascii?Q?ug=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee356a2f-9d0f-46a7-6829-08daf3de80c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 14:16:59.4809
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8KXQS5TuYwuWbavIrFGjbVcAZCEEUyrID+vft5q0EmKSIsA1yvHtw56xCBHCY0U8VjUutaU2ZyPw0MAyytt+DTPBfku3afOvo2sQ7YhoaWw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB6102
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
>Sent: Wednesday, January 11, 2023 9:20 AM
>
>Tue, Jan 10, 2023 at 09:05:49PM CET, kuba@kernel.org wrote:
>>On Mon, 9 Jan 2023 14:43:01 +0000 Kubalewski, Arkadiusz wrote:
>>> This is a simplified network switch board example.
>>> It has 2 synchronization channels, where each channel:
>>> - provides clk to 8 PHYs driven by separated MAC chips,
>>> - controls 2 DPLLs.
>>>
>>> Basically only given FW has control over its PHYs, so also a control
>over it's
>>> MUX inputs.
>>> All external sources are shared between the channels.
>>>
>>> This is why we believe it is not best idea to enclose multiple DPLLs
>with one
>>> object:
>>> - sources are shared even if DPLLs are not a single synchronizer chip,
>>> - control over specific MUX type input shall be controllable from
>different
>>> driver/firmware instances.
>>>
>>> As we know the proposal of having multiple DPLLs in one object was a tr=
y
>to
>>> simplify currently implemented shared pins. We fully support idea of
>having
>>> interfaces as simple as possible, but at the same time they shall be
>flexible
>>> enough to serve many use cases.
>>
>>I must be missing context from other discussions but what is this
>>proposal trying to solve? Well implemented shared pins is all we need.
>
>There is an entity containing the pins. The synchronizer chip. One
>synchronizer chip contains 1-n DPLLs. The source pins are connected
>to each DPLL (usually). What we missed in the original model was the
>synchronizer entity. If we have it, we don't need any notion of somehow
>floating pins as independent entities being attached to one or many
>DPLL refcounted, etc. The synchronizer device holds them in
>straightforward way.
>
>Example of a synchronizer chip:
>https://www.renesas.com/us/en/products/clocks-timing/jitter-attenuators-
>frequency-translation/8a34044-multichannel-dpll-dco-four-eight-
>channels#overview

Not really, as explained above, multiple separated synchronizer chips can b=
e
connected to the same external sources.
This is why I wrote this email, to better explain need for references betwe=
en
DPLLs and shared pins.
Synchronizer chip object with multiple DPLLs would have sense if the pins w=
ould
only belong to that single chip, but this is not true.
As the pins are shared between multiple DPLLs (both inside 1 integrated cir=
cuit
and between multiple integrated circuits), all of them shall have current s=
tate
of the source or output.
Pins still need to be shared same as they would be inside of one synchroniz=
er
chip.

BR,
Arkadiusz
