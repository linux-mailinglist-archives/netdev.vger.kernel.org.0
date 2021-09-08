Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F05714035DE
	for <lists+netdev@lfdr.de>; Wed,  8 Sep 2021 10:03:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348088AbhIHIEw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Sep 2021 04:04:52 -0400
Received: from mga09.intel.com ([134.134.136.24]:32076 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346759AbhIHIEu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Sep 2021 04:04:50 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10100"; a="220444765"
X-IronPort-AV: E=Sophos;i="5.85,277,1624345200"; 
   d="scan'208";a="220444765"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2021 01:03:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,277,1624345200"; 
   d="scan'208";a="503455350"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga008.fm.intel.com with ESMTP; 08 Sep 2021 01:03:37 -0700
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 8 Sep 2021 01:03:37 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Wed, 8 Sep 2021 01:03:36 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Wed, 8 Sep 2021 01:03:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Wed, 8 Sep 2021 01:03:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oAy20Nm+LFSG9Yr2T+vD6/SOWR/B6Nq3eqJXgu0ULEOl3v2rGl5hKDOewlQhg5//Nuk6o2c/+aFRXIuxydeWu4CYOBGQoK4DrhCD36R/4EYCAjDa5Vua3BTfVKTe64N6H7nuk4Ck53Cbrf811zITbJf2Nw75B1h4l3DHhs8HsBgoC7HEYdsZUPJ5rNsqfrew7zFq5ziJcWJ4+MgnbXJvAJildhzknohHicVy6CdLdNu9czGaV7OYBc+rHK4mNzFY7Dtra+X0RwZTBs01Wi9+Lj7kT9Nwoc7e26rv2KrtwOBdPX5QSvuG1s2zYsTxDbL43hpnyMF5A+iJGjRP97NmDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=OzRYeMuTQ6oN7UiGLe2MDFLfKLgXRBKGQ1AlFmAlBjY=;
 b=Z54TOkHX6pU8li3gpaBpfMy01QpuX97h2Wy4QQW+Rmoyyp27O9UtMgh3DXyQV2T+r74JPukYwb36NZUVo/JXj3HqM+CFf3xf9QF80O0S5Y02ocXLUxSNqePmRBxIW5ED8dN+a/+7QNcd9Jr96mMaBzJlhHFQI8piSD5HhprLyO/24UisDTNRJc4SZ8COVwvx35Tn3g+yHXdXy/aNP6yVTg9xxcB466nA34RVUapUbW+Fx/NZSOcVzDekaoC0h9pmjJPqdLKGJHGmq4eHziaiCtszjFh3QFqLvwPBG+tPvWFSWKMm6vjWssujdcK5PunxiU9DFcZ31SXl+MToPSle4g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzRYeMuTQ6oN7UiGLe2MDFLfKLgXRBKGQ1AlFmAlBjY=;
 b=xvcgY976ul3pEQdzN5xHn/PlQj8QABhQcM0jyTPix1EtIB9uK61GrH0R9upwMHRWruiJhQCr3e0F3iohY8bCJPt4a+D8YV7N4E/pII3V8Y8MaMP6lv+ae66G+zng5COj07elXRV7veRjkjI/JERQKTpi7YAcMeZsLt0A7KuEjPY=
Received: from PH0PR11MB4951.namprd11.prod.outlook.com (2603:10b6:510:43::5)
 by PH0PR11MB5143.namprd11.prod.outlook.com (2603:10b6:510:3f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.22; Wed, 8 Sep
 2021 08:03:35 +0000
Received: from PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221]) by PH0PR11MB4951.namprd11.prod.outlook.com
 ([fe80::58cd:3e24:745c:e221%7]) with mapi id 15.20.4415.029; Wed, 8 Sep 2021
 08:03:35 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "Andrew Lunn" <andrew@lunn.ch>, Michal Kubecek <mkubecek@suse.cz>,
        Saeed Mahameed <saeed@kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Subject: RE: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Topic: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE message
 to get SyncE status
Thread-Index: AQHXoNimVzUXkjuVtUCdGyBU/1Tj8auS4GqAgARwniCAAApOgIAAAHuggABqPwCAAH2kEIAAa06AgAADpCCAAE4LAIAAxVmQ
Date:   Wed, 8 Sep 2021 08:03:35 +0000
Message-ID: <PH0PR11MB495169997552152891A69B57EAD49@PH0PR11MB4951.namprd11.prod.outlook.com>
References: <20210903151436.529478-1-maciej.machnikowski@intel.com>
        <20210903151436.529478-2-maciej.machnikowski@intel.com>
        <20210903151425.0bea0ce7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB4951623918C9BA8769C10E50EAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906113925.1ce63ac7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49511F2017F48BBAAB2A065CEAD29@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210906180124.33ff49ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB495152B03F32A5A17EDB2F6CEAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
        <20210907075509.0b3cb353@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <PH0PR11MB49512C265E090FC8741D8510EAD39@PH0PR11MB4951.namprd11.prod.outlook.com>
 <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210907124730.33852895@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2dd6e67c-ec32-4dd7-4ae7-08d9729f28c3
x-ms-traffictypediagnostic: PH0PR11MB5143:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB514340143C70769C2824C349EAD49@PH0PR11MB5143.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ren7haNukiQurbhL9siUKvxQgNiGhSn9r925Bm/h1j7hmSTMNgAHc5dB1xi/YlHK0HLsV9Ga45wVVnYBuXfv2nF95IcJxjvh1RYwNcTZHkfzN03s3jC2T+6ksawg2Osw0PFqByeZlH7XC1z/xnk5cwf/pTn1LmBLtlMQWsFAvgCfLVzizNxV/C17VXfnRNKrAgyjK1Oz3EPeeZgMzhdjfZa5tQu4q1hxQCi74FKD5P2sHIY0znfiFW3zaq3F7Llpoqo/I8Z0RwFOYFVfdLXaxeCK+L3VTbvTiOLu3GQlmfwhL1qkFVm7bo3ols6ic1DZJC/AsOFwQNIzDVNKD92CX3UfMdrXYvIq6j++DXQmSgBn8dN5t2ezJRwJn+ac6SFrsc72tlGoyRjVNlEZ9hKr7fV6LR8OXW/7lhP3kqH0xJGbXLGgeD0W4/QykZ43ZcdMFPXZZsM+bOl0n+U6C10odoyHWOdjv0fsbKGNvR9FuuRi9TBV7RzU/8NedYWm7kdwtHo+ZlQJj4c++2Ei464u3daQlbjROIo9HXoxtxJIFZhZRbJ0A6DugIT4CHtjpbP0M6JG2xYwj/x3BL/vAcUJj15YV1C6Kap6wSdiFtC2eykcBoIE6tX6xJPv7zkKY2hAdp+vDVvPwsyRmfFi9Z5O1W4zE/0U1cdqM4xp0TlBLc9BrmfL3JJRIkLIXkwItwFG4dcIo8+98Og9DyB5UMWooWVq3iU91Wz74GH0Kc8X1s9LcXMvC4n5q1P2rnvlSrOo2qGNBicLA4etkWkG9vaTvzfPjlDdx2O4JexOglH/bFU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB4951.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(186003)(66946007)(2906002)(55016002)(66446008)(64756008)(66556008)(76116006)(4326008)(71200400001)(8936002)(66476007)(966005)(38100700002)(53546011)(9686003)(7696005)(52536014)(6506007)(86362001)(7416002)(83380400001)(122000001)(508600001)(5660300002)(33656002)(8676002)(316002)(38070700005)(6916009)(54906003)(15650500001)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bT09ehGMeuVqZcVg+JJSUxBuAqEE0r81iVU8ICaoRryThGgUuqI28q4gaus1?=
 =?us-ascii?Q?bPwTpgNDr+0mAoWbIomlf7B01UTCICnMG0tM/3KYx+Jei2I6T351KyjZzaSR?=
 =?us-ascii?Q?sw0NGdDu+F/GpySqrcGMl01YjlTCEZeq3UXwOTAxPwg69gbygzlyREWVHfjS?=
 =?us-ascii?Q?5Ov4aMaX1wVZ8HofdoLwOsrSpk5fcgv41pQXomZsO9dzwzNT1BV4pcg07Q+d?=
 =?us-ascii?Q?zQ09uQ/1Y0rwBS591oxaqFdrRNSitwH15SZa6Fu71VEhikPDC+6fHSKw1u5w?=
 =?us-ascii?Q?Vnu0RiMA8kCDyYQNgsSVTf2AJhr0W5hlj+1hRzlZieVd5ndMtGPaB1asgLxA?=
 =?us-ascii?Q?5W1VOGDUvmFC48Ajq1cqPJUVe9S5UcVDOZRzMN7vWUMq/LHy2rk+V+ZEQSF7?=
 =?us-ascii?Q?1zQJehQQQbD6GgNKTSMT9rQijGZUkg6ksT9bnFypO51iEdXBVL8POTQyEZcK?=
 =?us-ascii?Q?tr7MGSZ4QFKnTnkxwe5a76iLQlUxXJ5gq31hIdCx1u5UwWmEUoBcbsOxkuyw?=
 =?us-ascii?Q?NzjOShaOrBOunVd8IDNQb6wcB7yASUbROeH2duhgnQrcGLOVLSgpnDHaR0lE?=
 =?us-ascii?Q?o03Q8mrSt/W9+UMmAHm1TRGOe3woDA/haS5vibRTjqYE+mBO1mOvvG1Rx0jd?=
 =?us-ascii?Q?MM8mkx7QGrQml6D0D1ygggKm5OALjwHGgdVoa6Mf3t+GqvqmXmRIH9Xynfe3?=
 =?us-ascii?Q?8LgIXsK61aCuwDPgz1RQhMpWeF4Z2UNqTfvAmgLV1vKff30vsNxcqZZkAONS?=
 =?us-ascii?Q?pHDuBxnk2uAkzf81q1WD5LUpapuBs78nOMFW3yLOt8sQVOCnKEoa0ouOZOMn?=
 =?us-ascii?Q?/4mVPdmHIoVtFtfDPSnKKlOilRlmSGzdsxy2r4trHG26KiNtxRLBNfjiL7qB?=
 =?us-ascii?Q?G0pdQyTyymPJ89yxdNAXtkV0WF/MdeDMoLGdsj/qTrSpn73VUEpvpOOOmlhy?=
 =?us-ascii?Q?ip1wRkn8o3DYQNly1GeC0SPC/uyACQxDieTtPTVLMFjkj+zjypWMJTxaPG0L?=
 =?us-ascii?Q?zvdXSxLoedAjO+F+8ctChdHyf80SBaMWWYjCtiU3TsZGsBvPodrQO+RrJCeI?=
 =?us-ascii?Q?AzpdY72oJ/O/DEjmSTFpIriLQUuXXzQGXCGzwNbBMmtyF5Mdkv8DtiSHsDd2?=
 =?us-ascii?Q?vo0rzb5bmZ9KxuG5LeiXgIRyQ/hS9Z5yACCfJ0Ru53TPbwdhtHvhTLp/j8b9?=
 =?us-ascii?Q?uSsKijQdamKPrqhwP94+YbB8KZ5TaS3jBsIqAqqoce4TcjkPKxROwwsOOQA3?=
 =?us-ascii?Q?0THrU+Y47K3EOVBrfniTFmYIR++0TuLeFmBdFYrC7wKVxBDqjMYLsQ5Ob2La?=
 =?us-ascii?Q?gp4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB4951.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dd6e67c-ec32-4dd7-4ae7-08d9729f28c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 08:03:35.7097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Dk8UMy1RbpiQ7M4xRu9fNel+e/1GBvQsrL9J21GRQMXbo/zKriNt1sLjAUx1blkpr/oy69Da6T40SuXDAuuq83N4Gw+BFKoclIirrvQKGOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5143
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Tuesday, September 7, 2021 9:48 PM
> Subject: Re: [PATCH net-next 1/2] rtnetlink: Add new RTM_GETEECSTATE
> message to get SyncE status
>=20
> On Tue, 7 Sep 2021 15:47:05 +0000 Machnikowski, Maciej wrote:
> > > > It can be either in FW or in Linux - depending on the deployment.
> > > > We try to define the API that would enable Linux to manage that.
> > >
> > > We should implement the API for Linux to manage things from the get
> go.
> >
> > Yep! Yet let's go one step at a time. I believe once we have the basics=
 (EEC
> > monitoring and recovered clock configuration) we'll be able to implemen=
t
> > a basic functionality - and add bells and whistles later on, as there a=
re more
> > capabilities that we could support in SW.
>=20
> The set API may shape how the get API looks. We need a minimal viable
> API where the whole control part of it is not "firmware or proprietary
> tools take care of that".
>=20
> Do you have public docs on how the whole solution works?

The best reference would be my netdev 0x15 tutorial:
https://netdevconf.info/0x15/session.html?Introduction-to-time-synchronizat=
ion-over-Ethernet
The SyncE API considerations starts ~54:00, but basically we need API for:
- Controlling the lane to pin mapping for clock recovery
- Check the EEC/DPLL state and see what's the source of reference frequency
(in more advanced deployments)
- control additional input and output pins (GNSS input, external inputs, re=
covered
  frequency reference)
=20
> > > > The DPLL will operate on pins, so it will have a pin connected from=
 the
> > > > MAC/PHY that will have the recovered clock, but the recovered clock
> > > > can be enabled from any port/lane. That information is kept in the
> > > > MAC/PHY and the DPLL side will not be aware who it belongs to.
> > >
> > > So the clock outputs are muxed to a single pin at the Ethernet IP
> > > level, in your design. I wonder if this is the common implementation
> > > and therefore if it's safe to bake that into the API. Input from othe=
r
> > > vendors would be great...
> >
> > I believe this is the state-of-art: here's the Broadcom public one
> > https://docs.broadcom.com/doc/1211168567832, I believe Marvel
> > has similar solution. But would also be happy to hear others.
>=20
> Interesting. That reveals the need for also marking the backup
> (/secondary) clock.

That's optional, but useful. And here's where we need a feedback
on which port/lane is currently used, as the switch may be automatic

> Have you seen any docs on how systems with discreet PHY ASICs mux
> the clocks?

Yes - unfortunately they are not public :(

=20
> > > Also do I understand correctly that the output of the Ethernet IP
> > > is just the raw Rx clock once receiver is locked and the DPLL which
> > > enum if_synce_state refers to is in the time IP, that DPLL could be
> > > driven by GNSS etc?
> >
> > Ethernet IP/PHY usually outputs a divided clock signal (since it's
> > easier to route) derived from the RX clock.
> > The DPLL connectivity is vendor-specific, as you can use it to connect
> > some external signals, but you can as well just care about relying
> > the SyncE clock and only allow recovering it and passing along
> > the QL info when your EEC is locked. That's why I backed up from
> > a full DPLL implementation in favor of a more generic EEC clock.
>=20
> What is an ECC clock? To me the PLL state in the Ethernet port is the
> state of the recovered clock. enum if_eec_state has values like
> holdover which seem to be more applicable to the "system wide" PLL.

EEC is Ethernet Equipment Clock. In most cases this will be a DPLL, but tha=
t's
not mandatory and I believe it may be different is switches where
you only need to drive all ports TX from a single frequency source. In this
case the DPLL can be embedded in the multiport PHY,
=20
> Let me ask this - if one port is training the link and the other one has
> the lock and is the source - what state will be reported for each port?

In this case the port that has the lock source will report the lock and=20
the EEC_SRC_PORT flag. The port that trains the link will show the
lock without the flag and once it completes the training sequence it will
use the EEC's frequency to transmit the data so that the next hop is able
to synchronize its EEC to the incoming RX frequency

> > The Time IP is again relative and vendor-specific. If SyncE is deployed
> > alongside PTP it will most likely be tightly coupled, but if you only
> > care about having a frequency source - it's not mandatory and it can be
> > as well in the PHY IP.
>=20
> I would not think having just the freq is very useful.

This depends on the deployment. There are couple popular frequencies
Most popular are 2,048 kHz, 10 MHz and 64 kHz. There are many=20
deployments that only require frequency sync without the phase
and/or time. I.e. if you deploy frequency division duplex you only need the
frequency reference, and the higher frequency you have - the faster you can
lock to it.
=20
> > Also I think I will strip the reported states to the bare minimum defin=
ed
> > in the ITU-T G.781 instead of reusing the states that were already defi=
ned
> > for a specific DPLL.
> >
> > > > This is the right thinking. The DPLL can also have different extern=
al
> sources,
> > > > like the GNSS, and can also drive different output clocks. But for =
the
> most
> > > > basic SyncE implementation, which only runs on a recovered clock, w=
e
> won't
> > > > need the DPLL subsystem.
> > >
> > > The GNSS pulse would come in over an external pin, tho, right? Your
> > > earlier version of the patchset had GNSS as an enum value, how would
> > > the driver / FW know that a given pin means GNSS?
> >
> > The GNSS 1PPS will more likely go directly to the "full" DPLL.
> > The pin topology can be derived from FW or any vendor-specific way of
> mapping
> > pins to their sources. And, in "worst" case can just be hardcoded for a
> specific
> > device.
