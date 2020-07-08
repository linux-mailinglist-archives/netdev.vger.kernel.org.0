Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D61FD2191B9
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgGHUny (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:43:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:8070 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgGHUnx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:43:53 -0400
IronPort-SDR: EZ/1FuCx63w72yYWUUCsPvvdN6vU0R+PAs0lUPxy9SmZEHuCnbf8CZjaE5LoFk0j7napi4vCC1
 541uXF2o3f1A==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="136133178"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="136133178"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 13:43:53 -0700
IronPort-SDR: j/9+uAStGxve1gvc6ro3wu9oblC2LfhwgtLfiXdFnEzrzeAveku7+j+UhZP5w5TPbb+YnlQ7HO
 3PQMCKdtLDUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="323994786"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga007.jf.intel.com with ESMTP; 08 Jul 2020 13:43:53 -0700
Received: from orsmsx163.amr.corp.intel.com (10.22.240.88) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:43:52 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX163.amr.corp.intel.com (10.22.240.88) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:43:52 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:43:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AuizZEP3XuNcKga5tDFJk5RVV6Ed9tRuW09WUoJZ/fpYVem1BBbgaZYd1XmTjVdL1V+LAzywqU3VJ9UWjeDjmN0VEFdG5PJ70BENeeTb50cAWZUVhR2ZD2EvsD5XPIatumux67esqTaZHjC7C1DvUA3qTpq/WMlyQ2tzMYEuksmY53DzfkgHujgLoY30cgznfT3oeigdVAGwusC6yw1AhucrSr+cTZUO/QY57oP2mSHeuBjtQXUXkQxPtiwJV5ojO5nwElggJJytwayqMLsdJKY08EOgknZhVqGHR/y9YdUxTau0MBF2pe0DIkP8As2hLdgsIYKhPKYAPDCG8zgl3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+Y7IAUuKTh09OqTYUqeKze/QD4MyWN6U33nRWldzsE=;
 b=W3jNZt0bngOnvYbpRkL9D3I/mpQs+k5IpaJsGZfSko5OC8u5WaTux6QOYePDXKXQipxJo5Q8koPtnwP1Q9ZiXqt/ppCDD9hPGJGV90/ts6JAISYJdTG4s+n2iAhgg+BxZxUEiACgl/VPR0QYNTP2EjODTOJQp1MFjwj3VngLRNgfuYjRzvxKKWSz9zgwRtA3YtSdiYbj+2Y0LW3cgSIeRvK1MHANpu3pTk69q9RaI3VWCwdfAUTCbYVm3/Xf/4HfC0VJuVR4fRgLT9O7c7HXoCEc18C44TqAdK7HwsoagkKtFWQbxxDkSba+Mj/CvEeQsS/5QS38TGhbgddU8iZAIA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A+Y7IAUuKTh09OqTYUqeKze/QD4MyWN6U33nRWldzsE=;
 b=eXONJSgd2Gryb+cgD/j+htYPzEcVinHFVyH3uwVmCduChszbIJNQNTwUXeeyq7KEw/azf5bbx1R1aoh7fRXCrxxAx9kOPyWPRDCtlXJQ/07sPiQ/ergCta9TfMOB5gwUuv95Y8YjfGTVzNtYeuVQiCke5r2quEa5aK2m0ABW2W8=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN7PR11MB2594.namprd11.prod.outlook.com
 (2603:10b6:406:b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Wed, 8 Jul
 2020 20:43:50 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3%9]) with mapi id 15.20.3174.022; Wed, 8 Jul 2020
 20:43:50 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next 2/4] i40e: use 16B HW
 descriptors instead of 32B
Thread-Topic: [Intel-wired-lan] [PATCH net-next 2/4] i40e: use 16B HW
 descriptors instead of 32B
Thread-Index: AQHWUIbKUcigJieNlUGrYmG0WQFVTqj+L8Qw
Date:   Wed, 8 Jul 2020 20:43:50 +0000
Message-ID: <BN6PR1101MB2145C9D8E5348A0B38B332F48C670@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200702153730.575738-1-bjorn.topel@gmail.com>
 <20200702153730.575738-3-bjorn.topel@gmail.com>
In-Reply-To: <20200702153730.575738-3-bjorn.topel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dfe880aa-ef8e-41fb-fff6-08d8237f9eca
x-ms-traffictypediagnostic: BN7PR11MB2594:
x-microsoft-antispam-prvs: <BN7PR11MB25946953642ED7E5E006C7928C670@BN7PR11MB2594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:172;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: julG+OTYVAidNNRk36oygBLMTq3Eim0sKUpPtxaABwgzyETczoftP3I5+iiK4b3jNQ+eIOTJH1uy6k7SZf1Y17D68ffqJi51Y3ypVwnoKUg/QnPNXvo2x+Ned66kQzeHRVPBI3JNNQ5gk5jA/MHRlLS6Dcs+rIjnJQsDcQVZa8RHSmfffxrrZFSnWo5LF1XXX+7R+9O88M1O08rl+hHw+7POEffRkvuWUnfVddI8b3ai1+EuPajHYm67iAhnGjnRmbqHGF+twz9k9BsULVOamSFXlmPP83jOGRpUvvHTlLdymHRB6rRRZF0zBIHHF9F9
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(478600001)(33656002)(186003)(54906003)(316002)(4326008)(6916009)(71200400001)(9686003)(55016002)(7696005)(64756008)(8936002)(2906002)(66476007)(76116006)(66556008)(8676002)(66946007)(52536014)(53546011)(86362001)(6506007)(26005)(5660300002)(83380400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: FDAJNkXoyC56pc8oLISTJyUVYkRimWiozdx5jR1t+zQaDx/uWjamSBQoVSy3sRtLgFPT4JvDifjG6pVi8tSf1qPlX1m6yElotoNxILcAGdy37aFr5/+Sx5l3XQ5jM0Cf9NXhKbbI3lkpDhNznNkDV/Aw/NQxh0Gp+GnY0M3SYmjyDTP5Mg6BvWl6LeyqMO9ZG8DhkpJ4DMWS5o3IRdoF8JBbsuvLLXPBJNkKphID6RoYeM7M0SmmIEL04LxL18ee996kEEAuw3Di5duCAF7EYvyJRVJ9mqqgLuUdkeTiRpZU/zlFyQvrtGvYFz4MoZ451czs+rSLkZLgGtUfZeDcdzoIlPVikqPD5Qy89SLBqIh71767NTpqx5Winlj09NomT1d3pesEVLX3imptJ3WmbobUdP/eVy59PL70E6eyReohiQHYc1uvecKfn7QzLKLA3RiQjiIU45Z2UrsH24lNj54+ibcfwfpU5kmHFyJWhJc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dfe880aa-ef8e-41fb-fff6-08d8237f9eca
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 20:43:50.3818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: z4iulk4+uhs6fTKn72fa+ubO4ZdrmDn6zpBqls+btG/3GM6xt1NeUlf4RxGWSnKlAJsR+3BVJe41ePnNjtFqTYYDT6SCUF4z60mgwXufyqM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGlu
dGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5vcmc+IE9uIEJlaGFsZiBPZg0KPiBCasO2cm4g
VMO2cGVsDQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDIsIDIwMjAgODozNyBBTQ0KPiBUbzogaW50
ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IFRvcGVsLCBCam9ybg0KPiA8Ympvcm4udG9wZWxAaW50
ZWwuY29tPjsgS2FybHNzb24sIE1hZ251cyA8bWFnbnVzLmthcmxzc29uQGludGVsLmNvbT4NCj4g
U3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIG5ldC1uZXh0IDIvNF0gaTQwZTogdXNl
IDE2QiBIVyBkZXNjcmlwdG9ycw0KPiBpbnN0ZWFkIG9mIDMyQg0KPiANCj4gRnJvbTogQmrDtnJu
IFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiANCj4gVGhlIGk0MGUgTklDIHN1cHBv
cnRzIHR3byBmbGF2b3JzIG9mIEhXIGRlc2NyaXB0b3JzLCAxNiBhbmQgMzIgYnl0ZS4gVGhlDQo+
IGxhdHRlciBoYXMsIG9idmlvdXNseSwgcm9vbSBmb3IgbW9yZSBvZmZsb2FkaW5nIGluZm9ybWF0
aW9uLiBIb3dldmVyLCB0aGUNCj4gb25seSBmaWVsZHMgb2YgdGhlIDMyQiBIVyBkZXNjcmlwdG9y
IHRoYXQgaXMgYmVpbmcgdXNlZCBieSB0aGUgZHJpdmVyLCBpcyBhbHNvDQo+IGF2YWlsYWJsZSBp
biB0aGUgMTZCIGRlc2NyaXB0b3IuDQo+IA0KPiBJbiBvdGhlciB3b3JkczsgUmVhZGluZyBhbmQg
d3JpdGluZyAzMiBieXRlcyBpbnN0ZWFkIG9mIDE2IGJ5dGUgaXMgYSB3YXN0ZSBvZg0KPiBidXMg
YmFuZHdpZHRoLg0KPiANCj4gVGhpcyBjb21taXQgc3RhcnRzIHVzaW5nIDE2IGJ5dGUgZGVzY3Jp
cHRvcnMgaW5zdGVhZCBvZiAzMiBieXRlIGRlc2NyaXB0b3JzLg0KPiANCj4gRm9yIEFGX1hEUCB0
aGUgcnhfZHJvcCBiZW5jaG1hcmsgd2FzIGltcHJvdmVkIGJ5IDIlLg0KPiANCj4gU2lnbmVkLW9m
Zi1ieTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZS5oICAgICAgICAgfCAgMiArLQ0KPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX2RlYnVnZnMuYyB8IDEwICsrKyst
LS0tLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV9tYWluLmMgICAg
fCAgNCArKy0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfdHJhY2Uu
aCAgIHwgIDYgKysrLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVf
dHhyeC5jICAgIHwgIDYgKysrLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBl
L2k0MGVfdHhyeC5oICAgIHwgIDIgKy0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0
MGUvaTQwZV90eXBlLmggICAgfCAgNSArKysrLQ0KPiAgNyBmaWxlcyBjaGFuZ2VkLCAxOCBpbnNl
cnRpb25zKCspLCAxNyBkZWxldGlvbnMoLSkNCg0KVGVzdGVkLWJ5OiBBbmRyZXcgQm93ZXJzIDxh
bmRyZXd4LmJvd2Vyc0BpbnRlbC5jb20+DQoNCg0K
