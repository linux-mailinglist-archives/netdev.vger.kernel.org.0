Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B81463FAA17
	for <lists+netdev@lfdr.de>; Sun, 29 Aug 2021 10:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234802AbhH2IUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Aug 2021 04:20:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:2748 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232155AbhH2IUs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Aug 2021 04:20:48 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10090"; a="218151546"
X-IronPort-AV: E=Sophos;i="5.84,361,1620716400"; 
   d="scan'208";a="218151546"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Aug 2021 01:19:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,361,1620716400"; 
   d="scan'208";a="445422431"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 29 Aug 2021 01:19:56 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 29 Aug 2021 01:19:56 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Sun, 29 Aug 2021 01:19:55 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Sun, 29 Aug 2021 01:19:55 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.44) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Sun, 29 Aug 2021 01:19:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=obWafYgBmZK8uV8y2/uKP/UVnhE1eCEGXxgVbwh+PWD9XqaYq4LmieQU4M7isvxwpEA3LTI0WDzay+bHbE4c6WJt1MthfFQGF2snpqVeGCYp4AfDfX54pAvre0IDp11rhqVIaAIxUcCcT1dHHns4Xj2xf8v2P4ZO6U918rkV6p4GdR2l7ap5pc58cQrw8oG5TRkbj8xdD13jgc0ubtBzxcQAsJJ3RKC/LrFJ0ClMX9B71ansjlVZGXyKfJrCzaq+KwStqz/h9OS0TexDNtGKk14Y/dqx1U0+wzzvFgpgpltsb3c9sWSgklrfqxiCj6DNQRVEQtvcjQAcaWs/7h5OjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYyiFEgxq9nhU5rV24H+Cp3sIb0wtv5fdd9MNnzdQYA=;
 b=BynbFuU3DGgRXLOqAYHtSp6rqq0EVps5EQxkIGCbuk7WxaQfIDU5DwC0AfJ1Gg1vSoDcW4ZKztdbRVPAQLf8/xq56XOxgcrAxkFjWoaVOsVnbdlUY+mT/fTZEUhRJftGkULAlxSAA9peYu35RS2uPUl2LkKc5hldBPGjAzFMIJe4VWXTvehxtZY47PsdPN3rG0uJc9B+L2GtsdGRSQxlSCWEYpSlBou9Vb59V2mW2rFWM/w7xIXifctzjxI7684E3Qq/GeyZzm5QdiktzoIuBMRPBuKyQV1pS3noPLEQCCTcmIvq6vwy7DQPXqQutQkrNg++J8bJ6NpmDRNSmH6pEg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DYyiFEgxq9nhU5rV24H+Cp3sIb0wtv5fdd9MNnzdQYA=;
 b=Y8/sCTGLUc4J90KLoLUo28qtLBQzo4IXEfBalAt8fj1wycBSooa/g7E1XVsplrDfomjeED87H5YfstQxZddAdHBxma5ElPdkXj0hW8YXamR7oAu+2Aa7Fs65kDhQBg4FQZzrCYMjLmgQCsQRWhE6+6OtbK6JBO6ppWipJJQILIM=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5077.namprd11.prod.outlook.com (2603:10b6:510:3b::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Sun, 29 Aug
 2021 08:19:55 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.019; Sun, 29 Aug 2021
 08:19:54 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>
Subject: RE: [RFC net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE message
 to get SyncE status
Thread-Topic: [RFC net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE message
 to get SyncE status
Thread-Index: AQHXnFOlNiJqrlgpHEi9FSqEd11DO6uJdkmAgACtSBA=
Date:   Sun, 29 Aug 2021 08:19:54 +0000
Message-ID: <PH0PR11MB49514899CD7CE514E792CE40EACA9@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210828211248.3337476-1-maciej.machnikowski@intel.com>
 <20210828211248.3337476-2-maciej.machnikowski@intel.com>
 <YSqw6aJRrWbxRaas@lunn.ch>
In-Reply-To: <YSqw6aJRrWbxRaas@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4714004a-868a-4973-5aec-08d96ac5c832
x-ms-traffictypediagnostic: PH0PR11MB5077:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB5077E110C63240D21643761CEACA9@PH0PR11MB5077.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ro0wz8+y+Ge+yR+y/KNzoxYVweiw1qDJIqzgkJxhneKKJz8WIvfTOmh23YKIVINw/BL0KpZEkHq4j440mbIPgd6d0bgyQjJQKDCOR8M/TJhmILdRzSaq2dw+TJLYm/8C9Ow/e2jdKJ6MtFKLLXspSJpoZ/dvUTWjkw2gNjcRD757dZ6Bxa9jf3DcmJ+ThxIwwrlMT3VVA1YPNyV6ethjHX3JyAJQtnW/cFtDOO2I/lWpW6LsBTagT0YySmOYDo4iwQtdx9Ct2pZ1RPAVYvzFNb9j1SuSnP0Dxi2ymBpyol98vF1o1zlmpXz9hl4ak8OMmmj5EbE3vq+8H9fnzr5stgchUYyAImQ9k09AQvpLNxoAXNFN5gu5g2Snvo3T3QNW6fDKFUzNh5qD8aY63H0IzvvTOSJBw6oaldD2JC4OVD+EnGBNZMo03UCzRBbtB5hL89sfZHYfhab6CkT9kC2xEqMKpgotfkDYnquYvzlI4/9XgPotI/9EwLvIA1AMYHq07S/XYLS6mN87b1OmQzp6LmTcz0PAcsBE3ddMCz/aizMyR0ig4Y08wEKwUP1VmCLicCSe/0Vuy1jaaHszs29VI35AQk3J9MetGtD8u6rA+haNH+0j6qPcbizyMiukCzjICgMQvpC7zvcvtEP8ud6kH/EBEtT91GiShPtW3gg62yEtOB458PR87/rx+jFCRSea/GjZJxkI5cTLnKn30eVpMw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(39860400002)(346002)(376002)(9686003)(7696005)(33656002)(4326008)(86362001)(186003)(26005)(6916009)(55016002)(66476007)(53546011)(76116006)(54906003)(66556008)(6506007)(71200400001)(478600001)(64756008)(8936002)(66446008)(2906002)(52536014)(15650500001)(38070700005)(83380400001)(38100700002)(122000001)(316002)(8676002)(5660300002)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G31NZ2kcvBbhM1wick61ys3nMIZdFbbqcyNePE7N6l+zaI5yDs+/oHvmU60o?=
 =?us-ascii?Q?maTTsuR1IfddvFQSy2fkPKniBMm/UtQbAV0C9bCdswnWyQcqeyI04uwyCdSK?=
 =?us-ascii?Q?Su/kJjEpgAWrAR3OETkqs0mpxgyXA+nwVJx1S7NWxlLuowUzNF35OQcYxdbg?=
 =?us-ascii?Q?7nFq0DYJ2zDesJ3Jf+cZSWRIRlEeabWv2dZDziGC1cQek7A3HXgRKIhqf8rI?=
 =?us-ascii?Q?tRQS9GoSDyrqX2npe7i+tfVa4erDux88AFIU3/b068zUBgXYda1V830b55yc?=
 =?us-ascii?Q?8xNYDUqSFY7Bsl3Gxcaub2XP7r7ic7u9ja+iA7JczBSS8M9Oxt8DZP6zPua+?=
 =?us-ascii?Q?0p1LMyYeDdYp6Uh1/tOcOlwd0mT4awS9T/z1jnAjxw8b+3/8Mr++pojnLqah?=
 =?us-ascii?Q?xH8ewoNPp8VhAR9Jrs+gohCwGnlAFYX+p9SW6UpIe1RzgCz8EzWjvBzKOtbz?=
 =?us-ascii?Q?shlnCGBsfubfvH88+ov2B0x9RT/ySNqTRkYrOcT1DcfL1+7azRcXSfKXQkML?=
 =?us-ascii?Q?fkjYlT8KbK18gCwY94ZGIV0WdI5pgSCBejsY2/SyS5Ibg4fkbBNXMqL3NpHU?=
 =?us-ascii?Q?WP+ySnAEsXaNqk722oBwv+32pRmL8vRupcG8f2P1SpnGgcsXdirtbxZUN95k?=
 =?us-ascii?Q?Dgjq7B4F0WkedoBgMI8P4CjNv5TJSWXRgDMC7XHPoCe1viIxFkIjxueWX5cj?=
 =?us-ascii?Q?Dscxo9z20/KqX7RYCJrh2I/frHmp5FDwvjMTiFDfFKGNP3HoVOfVaxv03+Jk?=
 =?us-ascii?Q?xyeMmdOW/bIrjtdvdV4wQ4Nn3mnapoRikMfLGO/hBFvc/RmYDowNkIGcl6Qt?=
 =?us-ascii?Q?eNK8q2TBWHQ0bqMO9qh+21tGCNG4LZSA63IWkPefALCAtj7j6Lu/fnTy0x8s?=
 =?us-ascii?Q?GelbAXOOU92ESOH92he5dVf5CiwI35y2zWsIVzAbh9R8BrZIAC+5QtEIH66c?=
 =?us-ascii?Q?5uxQcU51siMM723qVWSaKOKZm6mWaDE+UimLMEfnz6yZBCVGpypNFPhSJop4?=
 =?us-ascii?Q?wvV58k6za9RRzeLOYMECaUy2tOJq/+fjKTRcLsDaQ6Z0POOPVnRF7dseBq7G?=
 =?us-ascii?Q?RfISYZw9UST+hCEYAsQN5VeIFzAEdgpWRv9ET+AqAzqF5muek594C+DOMKgb?=
 =?us-ascii?Q?DNJfxGQo3i5eA8kDdyq1i38szGawOiGuS+ez90w6UdqL7k3RdnT3rj7E5lyj?=
 =?us-ascii?Q?eNkYAeLQ88fK8+NX937A6Z9gJqTgehSYnuimqwkmNi9RhpHRZn5DDyL/QSeV?=
 =?us-ascii?Q?e7ObNP/mJXasD7jR+jr7hXJ0pMhNOf5kTisPFPKWPqy81bXj1UIv8yqYuptZ?=
 =?us-ascii?Q?V0g=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4714004a-868a-4973-5aec-08d96ac5c832
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2021 08:19:54.8534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rNgVZsFlI3eDZgffXV4Eo0eqDvTe9FF3FRN2gNfz52ANctx+X8IUy7VHoyE6ew+3t0eZrfjdbdEnNdb7aPl19nwiph8xmkR/rt4HcOvUTKw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5077
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Andrew Lunn <andrew@lunn.ch>
> Sent: Saturday, August 28, 2021 11:56 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Cc: netdev@vger.kernel.org; intel-wired-lan@lists.osuosl.org;
> richardcochran@gmail.com; abyagowi@fb.com; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; davem@davemloft.net; kuba@kernel.org;
> linux-kselftest@vger.kernel.org
> Subject: Re: [RFC net-next 1/2] rtnetlink: Add new RTM_GETSYNCESTATE
> message to get SyncE status
>=20
> On Sat, Aug 28, 2021 at 11:12:47PM +0200, Maciej Machnikowski wrote:
> > This patch adds the new RTM_GETSYNCESTATE message to query the
> status
> > of SyncE syntonization on the device.
>=20
> Hi Maciej
>=20
> You use syntonization a few times. Is this a miss spelling for synchronis=
ation,
> or a SyncE terms?

Hi! Thanks for your comments!

Syntonization is a specific term for frequency synchronization.


> >
> >  struct prefixmsg {
> > @@ -569,7 +572,7 @@ struct prefixmsg {
> >  	unsigned char	prefix_pad3;
> >  };
> >
> > -enum
> > +enum
> >  {
> >  	PREFIX_UNSPEC,
> >  	PREFIX_ADDRESS,
>=20
> You appear to have a number of white space changes here. Please put them
> into a separate patch, or drop them.

Will fix and resubmit along with the fix for issues found by the robot

Thanks!
Maciek

>=20
>      Andrew
