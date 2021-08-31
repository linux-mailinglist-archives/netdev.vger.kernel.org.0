Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8403FC4FD
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 11:53:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240691AbhHaJaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 05:30:25 -0400
Received: from mga07.intel.com ([134.134.136.100]:37257 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240547AbhHaJaV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 05:30:21 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10092"; a="282151506"
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="282151506"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2021 02:29:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,366,1620716400"; 
   d="scan'208";a="689843533"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga005.fm.intel.com with ESMTP; 31 Aug 2021 02:29:24 -0700
Received: from orsmsx603.amr.corp.intel.com (10.22.229.16) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 31 Aug 2021 02:29:24 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 31 Aug 2021 02:29:24 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 31 Aug 2021 02:29:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGK4wIb8swI+4Tn8jhPzOaEA/dLaA9pYuxtK0+xVBwlgIFQZNXUcbJxXlUHhqnnsDUKogzqKKxbWOjjP82puISvhFs3bKexf/TLDK0U+o3yMlriGvXL3iIzhaSRgs8yxWsk5gUIc9xWTPc5l/LfmoIm4eq7Q7iq0NXqcDh4I7o0wjQge1xpvwGsIvQwSTKCRs/ImZ7P+o7LaYeGhZYHee/dYvqHeXFMCmODjZFFmNG69AL6Jhd3GgKBKkRdJLs5FcGbUFvPY/IB02A74uV1vJ4r2vS+eZvGZ5x5u9W8DmUrudfh/jLXSmDI4qu2u4zeNoTs2Mqj+PNhnpjbTWG1xBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjrE77+B3f6/SbRBIcCXl6EcBH14Shvf+UnA/ecslSE=;
 b=k6PxKsbhmtceVle7CDAiUM8bT/mdpY0YXAAAkrYUCglFzsZnKhhY0NrBEmVFwyXrKIQi7B8t4IeMDSqR5oHqjBV8Aa0KIuowm6QFekllFbG1sL9jLrEMWuawn+cTHPiuxT5T9Dp/qb7rOeIMN/Xscqxz03QOFa4tY0++oAApYoE7SUNAazvZPZcRhGcIBpKDRrOmPTNX0Qh21jWUvP1/ZG3C99Lj7P4T46Ku5bcRe255WiAaQohmLvL30/lXNPTverX9t7ubZD5+fRMWFafpdDeFBDTP8CmsCfWAEg+7XNREbVTQ3uxz9qWWH8U5mQ9FNJAoJAl7tflFanJ1TE7UyA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LjrE77+B3f6/SbRBIcCXl6EcBH14Shvf+UnA/ecslSE=;
 b=WtnVqATX5NxgtX27UEX0/x3Tr7zITEpYWhOL83i4xupAGgItzqxuc8Ny0x0+sNWa1GPg/AUHdFmAzfed5frMH+FYHDNPwPRyxdb5EypSskDr1APvJdLFJQhYm+Di9+FhDF+Eh/y+myYXVOVBLllDq3+zyhEx4/a/qJ1tLK6Kxis=
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com (2603:10b6:a03:2ae::24)
 by BYAPR11MB3271.namprd11.prod.outlook.com (2603:10b6:a03:7b::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4457.24; Tue, 31 Aug
 2021 09:29:22 +0000
Received: from SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062]) by SJ0PR11MB4958.namprd11.prod.outlook.com
 ([fe80::7865:f66:4ed9:5062%7]) with mapi id 15.20.4373.031; Tue, 31 Aug 2021
 09:29:22 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Richard Cochran <richardcochran@gmail.com>
CC:     "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "nikolay@nvidia.com" <nikolay@nvidia.com>,
        "cong.wang@bytedance.com" <cong.wang@bytedance.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "Bross, Kevin" <kevin.bross@intel.com>,
        "Stanton, Kevin B" <kevin.b.stanton@intel.com>,
        Ahmad Byagowi <abyagowi@fb.com>
Subject: RE: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Topic: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL state
Thread-Index: AQHXkrpDE4/97678+kqD5jc+QEB2qKt2zoSAgACcQzCAAhWPgIAAVWdwgAEkIgCAAAB9kIABl9IAgAAdxFCAD/BQAIAAzDmA
Date:   Tue, 31 Aug 2021 09:29:22 +0000
Message-ID: <SJ0PR11MB4958827821D5CFBC897E43B3EACC9@SJ0PR11MB4958.namprd11.prod.outlook.com>
References: <20210816160717.31285-1-arkadiusz.kubalewski@intel.com>
 <20210816160717.31285-2-arkadiusz.kubalewski@intel.com>
 <20210816235400.GA24680@hoboy.vegasvil.org>
 <PH0PR11MB4951762ECB04D90D634E905DEAFE9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210818170259.GD9992@hoboy.vegasvil.org>
 <PH0PR11MB495162EC9116F197D79589F5EAFF9@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210819153414.GC26242@hoboy.vegasvil.org>
 <PH0PR11MB4951F51CBA231DFD65806CDAEAC09@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210820155538.GB9604@hoboy.vegasvil.org>
 <PH0PR11MB49518ED9AAF8B543FD8324B9EAC19@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210830210610.GB26230@hoboy.vegasvil.org>
In-Reply-To: <20210830210610.GB26230@hoboy.vegasvil.org>
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
x-ms-office365-filtering-correlation-id: e4d3bbbf-a086-4012-9969-08d96c61d146
x-ms-traffictypediagnostic: BYAPR11MB3271:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3271837617464958B28491F7EACC9@BYAPR11MB3271.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fyV951Kog0MGomLpWzLyA9Rnh1lzKoeh5Q4y3UaNVWFQ3VgxY6mZWhA781vRs5fR/kp7xfVHUW2jZwJ2MpwdpisaVpOYDpBjF0lzEODzJeTsYiA3ZfXsDtm6irMLH/StQEyfRAQSMzcpFbOLBepVsc64wPz6Gg4PU0Wot+wYTZoYCxuy+l8thpCFxhos65/AO46H6YLWoBVUgfq/w3ZokU3hAzncYjdtHPvtRGEcSzfMhpF/N0E59NY2vQDO0ifUFcPkwtVFZqM94zaYtWoL5HBuBe9jqnp5rovfOeEjQls7gBDLF9L/di8IQtg/zgEQhfFS3DBbrgZR2MD7Fp/F1cga6YsB5dSLmOSb/uffnA9YKgfXXaM5MalbGVTRjeiL1JANgiiSIw+mqE8Xz32RrqBBaRv9wOFahbe5qhmE29NdbO8xD5V0JH6zU5ofnrbZFJZ89C4nhzD7KGaKJexBpXeiaLmZkRXPNgwk0uEQcJPdG1u75lzV7V73GMkpNNjqXq8aupPgADj9JV1ceicc8bVR0R6l95+x50DrrJIUw6mzSTFxaSlY3Bhw9Wvl0gODM1lsiQhftYEgdFg4jI83bSjOWgbQXSbjEPTVrYUwkRBBOEw9wMOecKDbDSCvmQ6WCrsel2FgAnoV6Unb43b1Jli/XKvVZyJ5s8iMWV80RxzYtqjEEmLC+JyqPU+cvot5UqP0SGFWZndLLgoCXaw6gQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR11MB4958.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(346002)(376002)(366004)(396003)(8936002)(52536014)(4326008)(7416002)(6916009)(66446008)(71200400001)(66476007)(9686003)(33656002)(2906002)(83380400001)(186003)(26005)(316002)(66556008)(38070700005)(86362001)(8676002)(38100700002)(54906003)(5660300002)(122000001)(6506007)(7696005)(53546011)(66946007)(55016002)(478600001)(64756008)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?VrUZcIPEPmwkmzbqapchx1rQQK+1LnATgYSeeSiiuzUPCtm5SE0j/3TnlK6Y?=
 =?us-ascii?Q?AfKrIHv43WQIpKR84KpnN24IS3jN1TEqkBblttMAVL3QyE6lQW7S/R8Kuqy7?=
 =?us-ascii?Q?PyJZasYfkH7+doQ2MIyXi6DrY6clzTY56/BBcH71HjO0Ok619xEAFeV2Ns/v?=
 =?us-ascii?Q?7c8WG8BJ66PYLib57aDsIlFoaoVrYpgT/pQx+tu+8Lnz8lBa5+XwR8LZ6htP?=
 =?us-ascii?Q?1Kop267eQXtwL0pWacWlK6pREIEqefNXJAOTpyzPpNxhn5x/kXbW2qr1LPU6?=
 =?us-ascii?Q?cEDJySOeDXT0XQCI4XPoHMsG9zWo6b+N4xCaf/1G0u9g3us4DoxFRWUh5Qa/?=
 =?us-ascii?Q?cVPg7SgjiG2I2dufozq2M290Q/+wpE5v7L+4ia5g0DrUJiXeZDya9RJMA4+k?=
 =?us-ascii?Q?7TGhKuEbw0vUATY/eJj6JYJcH3IGmOeIvGALJ/QcmO4bIGNQ1QQLB4ERi1ZL?=
 =?us-ascii?Q?8qwxon3i7jR/lTaMTIQwaap9/KRM2BIWrHEYa9c+dKniOQ/a+BeDZ7PxcElR?=
 =?us-ascii?Q?+RMNeLdqd5ki4eRL4+gBB0VQNbiYC3/w/eBNNMW0gZtPAprcfUU8YYCwWnHq?=
 =?us-ascii?Q?NatZB/RBlj6+4qP5Ak9OcM/EXnrlT/Gx8X+tUe9RJFwpWHJOXHoGG9CSOp3w?=
 =?us-ascii?Q?CWih0VCHWqZM6F/VUoI90rSMs/ZWD9XzBj+Ty/7qxLfQen0ARAMDLtrph/sk?=
 =?us-ascii?Q?dN1MxyZ0zpsGWkvUsyiAy12YHdcZmjJUKbpEgwHmhahD34KzuHFxCCj8QAXn?=
 =?us-ascii?Q?K/jdkAzmmEVp5bHmH/QPSKf8W566F5rnbekQNFGBGeq6vs7KGJecxtnck4xB?=
 =?us-ascii?Q?K//viArF/kU0z9YTOG+i9jHZPQI0IjoSSgHPWJWxGayIr65T6AelaDr6eB5E?=
 =?us-ascii?Q?hgJ9sBeBy36Udm+fCegMv+iz3ZbAVkxgRVb7YuH/wpy0eYNcfzSCkE0WiL3D?=
 =?us-ascii?Q?A5QEVZoANMTRsmRNqndpnJ85SC5ocY3RyOU2H+nu8VWmCqIRQZB2u2NqUf7b?=
 =?us-ascii?Q?UBe/bgPtsTCLtUFozOdgOYd+xcKbfwFcap5UhpkMeHQTMlQ4vY4IZSnw5h7W?=
 =?us-ascii?Q?q+PJn4nIIIDWZEETDI67N7fv9BZjUwQFAN2lAhiOB2hRQ5OyzWe9hdgY6BoU?=
 =?us-ascii?Q?25Cva67F/PibKabj9JXK+RcXqIBYeaEEOmRjEnUEykEKGOBHHhcQVfLktBy0?=
 =?us-ascii?Q?xnGshTj/4pD2veVzwHQuPMhex3y34sYOobINW0PYP6+I+olr76mydopZLnzY?=
 =?us-ascii?Q?rxNu6/zFEVX4HEdeTvH6Zu36uuHLi6arIhsK8uiyT3K/9AxjeiR3CJbaO45Z?=
 =?us-ascii?Q?xqA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR11MB4958.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e4d3bbbf-a086-4012-9969-08d96c61d146
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Aug 2021 09:29:22.5859
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q309ij15vUoBWLdTv0Om2qErxJpSeRFvgBIo+v5C0wi2GRcX9KG4SFOVyBQC9lmuvwSzioe549n6qCkvH3VzR6brz+5EdKtw+0J6BLhE7+I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3271
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Richard Cochran <richardcochran@gmail.com>
> Sent: Monday, August 30, 2021 11:06 PM
> To: Machnikowski, Maciej <maciej.machnikowski@intel.com>
> Subject: Re: [RFC net-next 1/7] ptp: Add interface for acquiring DPLL sta=
te
>=20
> On Fri, Aug 20, 2021 at 06:30:02PM +0000, Machnikowski, Maciej wrote:
>=20
> > So to be able to control SyncE we need 2 interfaces:
> > - Interface to enable the recovered clock output at the given pin
> > - interface to monitor the DPLL to see if the clock that we got is vali=
d, or
> not.
> >
> > If it comes to ESMC (G.8264) messages, SyncE itself can run in 2 modes
> (slides 29/30 will give you more details):
> > - QL-Disabled - with no ESMC messages - it base on the local informatio=
n
> from the PLL to make all decisions
> > - QL-Enabled - that adds ESMC and quality message transfer between the
> nodes.
>=20
> How do you get the QL codes from this?
>=20
> +enum if_eec_state {
> +       IF_EEC_STATE_INVALID =3D 0,
> +       IF_EEC_STATE_FREERUN,
> +       IF_EEC_STATE_LOCKACQ,
> +       IF_EEC_STATE_LOCKREC,
> +       IF_EEC_STATE_LOCKED,
> +       IF_EEC_STATE_HOLDOVER,
> +       IF_EEC_STATE_OPEN_LOOP,
> +       __IF_EEC_STATE_MAX,
> +};

This structure is for monitoring the lock state - or in other words - quali=
ty=20
of incoming sync signal.=20

The Locked state here means that the frequency used for transmitting the=20
data is syntonized with the input one. If something goes wrong, like the=20
frequency you recover from the link goes beyond the specified range or=20
the external signal is lost, the QL level will change accordingly.

The application layer running on top of this API needs to get the proper
QL level from the config file (just like the clockClass in PTP) and broadca=
st
it when the state is locked and switch to QL-DNU when you get out of=20
the lock state and expire preset hw-dependent holdover clock.

Also, if you are syntonizing to the SyncE clock you need to wait with
passing along QL-levels until the state reported by the EEC changes
to LOCKED.

Regards
Maciek

