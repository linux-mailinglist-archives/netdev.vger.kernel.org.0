Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94DCD453427
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 15:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234000AbhKPO3j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 09:29:39 -0500
Received: from mga01.intel.com ([192.55.52.88]:29809 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237435AbhKPO32 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 09:29:28 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10169"; a="257457504"
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="257457504"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Nov 2021 06:26:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,239,1631602800"; 
   d="scan'208";a="472336168"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga002.jf.intel.com with ESMTP; 16 Nov 2021 06:26:29 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 06:26:29 -0800
Received: from orsmsx605.amr.corp.intel.com (10.22.229.18) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 16 Nov 2021 06:26:28 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 16 Nov 2021 06:26:28 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 16 Nov 2021 06:26:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DOH1o9CxjeOYOMjVeITKyAFbh8wZEiXnUf8balFkaq0H3gTrGhtpc8VwWRp1vHgjWV/r0E4sUm2ZrcMb+SncBz1/7Lh63ykkesSCqO8lYqkbck7JgHYZfcjnBMx7ckoEWBHN2q11uuoLtbhsXr8KVRODCpYJvfJhgMhz9sysExkrGU+N/Yigl6ReQfbyPccSeqtaWSI/YPzigWhHX163jlqQu657fHCS+RigE5hW++DFac4yoDDBHNRU44ipFph4rBdq0PEkd6ME8x7P1fFxFJ7nqxnVcJ1u4DL9w5kaMy4J/1C57XwN2Oracuqw1A7IDE64WEu7xNed4dZAYedRmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wQeMTKFhaVvrN2KUZCkO9GZ4nDmK0rUSTuA1kINU/vs=;
 b=MfLTTAyXLHQ6hT1M5bIaTrF9c0sIP76jEGhK/y8a4haRrPGFBzcpdgCD+tJH7Emj++patoJ5EKxQ9CQOtlTMxb33/lR5smYOlrKfvClMYgVAxsA8IJZsi7DF1iKiJ9cSpIPVxCGS6hoLdOUCzR0Gis5M+jpl1BrPdf34YTCPyP/2ajLolRoOiZMmlvmwnmz/JLzCh9PfXwmV940tk+3qNw+swxPex7428XExHtFNJcW9jwoyA3AjhKo3OpszEYlNnSRbhsUBWx6papSxwYlSnV4jYcdxo+UULSd/KO6MadRWt3zXg//pQUZ9xk2/j6cOPFvyEtiTH0yqf9hwDul9TQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wQeMTKFhaVvrN2KUZCkO9GZ4nDmK0rUSTuA1kINU/vs=;
 b=dehwxYORpBmMUzDN1Kt4/iwOh8U0bqg4ZMCTEIGiaY/OJJx2j/dvwLObgA4EC7QOfUhyWSgOPQpzpI79DvXvLAUwKWzp95ESx4Rl3AfU9LqRhEYy9bjMkGQ98G9UdNDzGvvIpDBnYfmkWhulyb5f9V5JpTnqIu8xmgOdYhZvKdg=
Received: from MW5PR11MB5812.namprd11.prod.outlook.com (2603:10b6:303:193::14)
 by CO1PR11MB4788.namprd11.prod.outlook.com (2603:10b6:303:97::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4690.16; Tue, 16 Nov
 2021 14:26:27 +0000
Received: from MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9]) by MW5PR11MB5812.namprd11.prod.outlook.com
 ([fe80::1127:5635:26df:eca9%7]) with mapi id 15.20.4690.027; Tue, 16 Nov 2021
 14:26:27 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Petr Machata <petrm@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "idosch@idosch.org" <idosch@idosch.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>
Subject: RE: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Topic: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
 interfaces
Thread-Index: AQHX1iqaoGL4JrqyH0+WzcbffTt8mqv+RxWAgAYf5ACAAa2eAIAAJTzg
Date:   Tue, 16 Nov 2021 14:26:27 +0000
Message-ID: <MW5PR11MB5812CBDF240A6D08E76655C1EA999@MW5PR11MB5812.namprd11.prod.outlook.com>
References: <20211110114448.2792314-1-maciej.machnikowski@intel.com>
 <20211110114448.2792314-7-maciej.machnikowski@intel.com>
 <87tugic17a.fsf@nvidia.com>
 <MW5PR11MB5812E733ED2BB621A3249CD5EA989@MW5PR11MB5812.namprd11.prod.outlook.com>
 <87fsrwtj05.fsf@nvidia.com>
In-Reply-To: <87fsrwtj05.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f1fa411-7a47-4095-846d-08d9a90d1368
x-ms-traffictypediagnostic: CO1PR11MB4788:
x-microsoft-antispam-prvs: <CO1PR11MB4788B01095AAD24C3A56051DEA999@CO1PR11MB4788.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RCnII2xPYhqWupoJ6ekJSx9FYoUOkHQGdOBg0oWFkMz6UT0y8ucIsElmvzpdIIb+BNPxp3LcL2PCRQTbnQ0LjbgGVzi2Y02+/L7KEHV9faeVoVE1JwBtibUrDI7zQYfnvtlZviQsMwZE/KV/4/g1+sqSGYALlaGpiwMPZXEaCviDEAJFUvf09+n39g3TUmiG/uTR1Oi8auXItSPiiFcUELYI1ETpp3qS8nqH2Cw1wMfgdE+ysW38S+vDdBZkkPrxBq0+mPIFZNTbGhhPwcnTus8UcD6ntxQbTbSrG8h3HR9NhOfmmPKph+SHPYljh53v7QaOWrLEx5SvyCM28f3O09f+viBtr3IXmq1JrbqqR0cc+O5Ob+bx9eCUULGavV1OeMsO5h3lVX4Mb9vKdjtQZ7oNT063qPGf9gvFK/hQe48BZVYHxsobqwSQ1xKcVtYbvfKfQBhjrEUQN9yEMdam4EwkpIb4Hz3k96yDM0JgBl3NHe38u0vn4gcsKe7BsqlsWebM09GkldMJ7hdVPdMN4Jo+Y5ILtilGUn0+LM+u7pIJwIrZzhfzovy0VPTBQAXa/t89eWzAbyNezZfQBpEhYrErNPbPZIb1FqGFyTwwPlCM3UxxbTOG9ilLCdiV1tjmiR88rR5iWHiLpTfjdQfX2qfsbjXqTKkH8GyFw+SfSdHk4ziY4XagnBIyx5h5ZX4ydBMa9K8Ss7n+4e9H3sk07Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5812.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(508600001)(82960400001)(7416002)(66946007)(8936002)(8676002)(55016002)(66476007)(38100700002)(122000001)(66556008)(52536014)(7696005)(6506007)(76116006)(53546011)(71200400001)(2906002)(64756008)(5660300002)(186003)(38070700005)(26005)(86362001)(6916009)(66446008)(9686003)(316002)(83380400001)(54906003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oHuGFXUWJjXrjh9JRyRuURSTqr7tVeC2gW2abg9hBg9hSEVgcImKDh+xBJqS?=
 =?us-ascii?Q?nAxK1Z9WebXijTHr4N8mN8DoN4YL3iCARe3Z26TPEdxb/3FgbMcGKZ41e2SJ?=
 =?us-ascii?Q?yLLKc1rPv+1oVbDqSyZWeCz+nVLJ54eySvsPzZZ/P2RJiX9RWUCu2gV50Yxf?=
 =?us-ascii?Q?xIT0rru7V5BiTY1y65c9rIQ1bjVl662MIstk+H3xWjDLmLmT2ZHoLl1ghBLN?=
 =?us-ascii?Q?hYx21C5/vI9euezO8DTxYAxFCTlRdkmhmgkVZimDjNGOt8uDDZnfjhc8GTnE?=
 =?us-ascii?Q?mrDTXJQEiNMLIN5JuwJYS3rn/i8uibVl+/uwait1etY/ZyLi3mtHCeDuXwwb?=
 =?us-ascii?Q?wJrdBFzV95NGeQaNlwDmiTzIFwd6sq2mN+9CBUMc4+8BcvjHg+BQdTH6RI8E?=
 =?us-ascii?Q?04neBSdLO936qyP3Z4vFRorLUhfDgcv+hL2kpHOSEn7QyrS9nyyk40rjB6J+?=
 =?us-ascii?Q?3pJ3730VfQ5u6wxgqvcnGT4APynSnk9d+Ha3+Xke9upb6rIox5YBGtt41dqC?=
 =?us-ascii?Q?V/JaswDulunnyZN5Q2zg5p5UXyU0JeFpbGwZDqCsRABLiZfcKVmlr1tUGk8/?=
 =?us-ascii?Q?tVH9Hm/aREyAgqQodu7dYpxB6XZ2Zusg9PAj/uiY/cxBbayCYub3lLs0yl96?=
 =?us-ascii?Q?Eewmz5twX3Exmtjs2vKXY3MSKQXNIMU8J7/FlL1tknYk2NCTw0Jy/fHidf5d?=
 =?us-ascii?Q?9zjTcMPgdB654VC5Eh7F2pKzvmANor9Dez+kNkphddL92LmdhxUqUc7URwt+?=
 =?us-ascii?Q?Q75WG9gcSG2RDK5siceU9ubCleW6Bt9Kwi9CjN7NLNGvQt8piDG+aCverGp/?=
 =?us-ascii?Q?36y+PhcneiIMjHEl5Mu4KxYyYg0corw5URYKW+JOJrekqoz8+jaNeBRDUe0b?=
 =?us-ascii?Q?NSQjFPWL1zNzZA0S7xG+2wPHvGxvX58jtRXDb2ZQ/wyNcmihkAzMireLA/1Q?=
 =?us-ascii?Q?6uPwQrvn6eBjH8koOObNCjhfYYEnJt2g23t8Aqc81xRXaxtki2qWPgu9Rw38?=
 =?us-ascii?Q?b7T/MEmDz222xtE9slXwERp5px5wfNbYQ+pj9g3ZDr0kTZjNrEFxseOWuITy?=
 =?us-ascii?Q?bPLj8DM7k0SvltXC3KzAW/NBzxtZkAxbWvkC3wYKvRc+j08x3tWhJxMz+81G?=
 =?us-ascii?Q?vEb2x8z0aQdDnQPaFLIJoEmIJGfEyk3zAK7lFpJf5yAw5V9RVOTFEkFjHw2Q?=
 =?us-ascii?Q?/mVVUB/Qjlr5SIZlrjJr5rNKd6HIvEVKtSQbFI6Sa4XAuCgVYOt+NHnuaVM5?=
 =?us-ascii?Q?CugqO5PWCKVA4+6NEIOXLQxCe++qECuTqF7SaO3PwC9wMM0usB/lT/9sU4op?=
 =?us-ascii?Q?4c7+YenDSMpDi33p7KSiKyNzNKHmR3DvML73Keha++lNo1RMseY3/21FT5Y/?=
 =?us-ascii?Q?Bv00cYbhrCyNpexboQVo8bjTgAr1ddCm+G3931QvowPxiJoE5RlKq5I6g6iL?=
 =?us-ascii?Q?40jZb9WkHC5UIteZOaXETb/huweaXJQwwuVr1EnmOgpLPUEqROQoLUiDBA9D?=
 =?us-ascii?Q?/eBARqo+riUIu6nfIZQ8ikPPmuQnNBra/4DYhikpTA8pLSe/hkI2g5out6n3?=
 =?us-ascii?Q?zzNX1J/QaUaXSFwvHEabHWmaCTO/AznvESDZE206kAQnSSvNB7kjzi9s+Fa3?=
 =?us-ascii?Q?j+3/UDQFITk9Q2i1p5pm7Xa+76PkrD47n1uVWkaTBj28lrHfwaX1n28TdQYc?=
 =?us-ascii?Q?oOl8Cw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5812.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f1fa411-7a47-4095-846d-08d9a90d1368
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Nov 2021 14:26:27.3567
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9/6rbxYg9sYrVkzWthunMlqC1NV8U8bu6+Q6fPe+wTZ2VolMAC3lOZfAjg+4LZrp9ikeFRJRxARMK62b5nH9fIXChdXgTtCQzi8dfkFgvRo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4788
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Petr Machata <petrm@nvidia.com>
> Sent: Tuesday, November 16, 2021 12:53 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [PATCH v3 net-next 6/6] docs: net: Add description of SyncE
> interfaces
>=20
>=20
> Machnikowski, Maciej <maciej.machnikowski@intel.com> writes:
>=20
> >> - Reporting pins through the netdevices that use them allows for
> >>   configurations that are likely invalid, like disjoint "frequency
> >>   bridges".
> >
> > Not sure if I understand that comment. In target application a given
> > netdev will receive an ESMC message containing the quality of the
> > clock that it has on the receive side. The upper layer software will
> > see QL_PRC on one port and QL_EEC on other and will need to enable
> > clock output from the port that received QL_PRC, as it's the higher clo=
ck
> > class. Once the EEC reports Locked state all other ports that are trace=
able
> > to a given EEC (either using the DPLL subsystem, or the config file)
> > will start reporting QL_PRC to downstream devices.
>=20
> I think I had the reading of the UAPI wrong. So RTM_SETRCLKSTATE means,
> take the clock recovered from ifindex, and send it to pins that I have
> marked with the ENA flag.
>=20
> But that still does not work well for multi-port devices. I can set it
> up to forward frequency from swp1 to swp2 and swp3, from swp4 to swp5
> and swp6, etc. But in reality I only have one underlying DPLL and can't
> support this. So yeah, obviously, I bounce it in the driver. It also
> means that when I want to switch tracking from swp1 to swp2, I first
> need to unset all the swp1 pins (64 messages or whaveter) and then set
> it up at swp2 (64 more messages). As a user I still don't know which of
> my ports share DPLL. It's just not a great interface for multi-port
> devices.

This will only be done on init - after everything is configured - you will =
not
really need to check anything there.

> Having this stuff at a dedicated DPLL object would make the issue go
> away completely. A driver then instantiates one DPLL, sets it up with
> RCLK pins and TX pins. The DPLL can be configured with which pin to take
> the frequency from, and which subset of pins to forward it to. There are
> as many DPLL objects as there are DPLL circuits in the system.
>
> This works for simple port devices as well as switches, as well as
> non-networked devices.
>=20
> The in-driver LOC overhead is a couple of _init / _fini calls and an ops
> structure that the DPLL subsystem uses to talk to the driver. Everything
> else remains the same.

That won't work - a single recovered clock may be physically connected
to more than one DPLL device and a single DPLL device may be used for
more than one MAC chip at the same time - we shouldn't mix subsystems=20
as recovered clocks belong to PHY/MAC layer.

Also in that case the DPLL would need to track the relation between
all netdev ports upstream - which will be nightmare to keep track of
when ports reset/get removed or added.

Also the netdev is the one that will receive the packet containing quality
so the userspace app will know which netdev received it and not which
DPLL pin it should configure. I think this approach will make everything
more complex (unless I'm missing something).

> >> - It's not clear what enabling several pins means, and it's not clear
> >>   whether this genericity is not going to be an issue in the future wh=
en
> >>   we know what enabling more pins means.
> >
> > It means that the recovered frequency will appear on 2 or more physical
> > pins of the package.
>=20
> Yes, agreed now.
