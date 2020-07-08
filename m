Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6132191B3
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726044AbgGHUnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:43:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:30030 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725848AbgGHUnQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:43:16 -0400
IronPort-SDR: TB9ICDrV90yqAf2Sflp/y/cX2uF8/9H+Y3EPFPT2CnYe3ucl7atYWjHItPtxqDB7wcabnWfEBf
 YKKx3ScbJK8A==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="145992836"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="145992836"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 13:43:14 -0700
IronPort-SDR: N9VelKUIt4lDZlpRtk51DDj869C7QCJ3S0+Tjm3fMFR533EmPTi9r/9kp7KyzMPt1oh0Wa90CP
 PP85vMbj06Mg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="323994678"
Received: from orsmsx105.amr.corp.intel.com ([10.22.225.132])
  by orsmga007.jf.intel.com with ESMTP; 08 Jul 2020 13:43:14 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX105.amr.corp.intel.com (10.22.225.132) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:43:14 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX111.amr.corp.intel.com (10.22.240.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:43:13 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.101)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 8 Jul 2020 13:43:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hcsDtauW135lKr1VoOfb3n856GhA07RGtgP0R8oUv8vIukBtdi711e0TbqaX298aXsDgaZJTVVhSlSf77dv1t8cM/x+NSpllsgaBu3CkNyRZ9pwAv8jrY2lsstD+yTlJ4+lUANp829op6MFXnU+Gzh31cYPcD6BZJ1yBb+LzbbKyanZ3nLCTpnFP3y7rzPBAi8gUpTkonAq3fuTMPRQZmycDN9ZPccTUlWkN956+SuWmeIiOjnCPMXT754oiTubdldYlEfjkgMJXfagfr1P6W6hREzz8xFS6uWENQdEl3NP/xwQYbyppmREI+0pI+1++ixQNC7RIK+Bw0tFteeXucg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCFuyC1oCCsCq98q5U6A2DY5O/t2bM5uLsAsjB4Sytk=;
 b=Kan8lhKawyTAHl36JID7A/ylJtLN97/hfgD9p2Mf4A8eTRf+Xgl3YK47uHvTKBb18K9XRfQzkAlO4TeEFiqVDYJIY8OiY6+bBWhpUj9laCbsa9BRcmP/MRhHmy+FbjOJ2iDLYU+Qq+iheqHCCRdco1vE+kaRge8UA60kbUcc2PRP9WSZY8jy+ooz49RhA1xzHHyokjF8bUhlFgrDgR9R8Cx9C+wP//DE+dxVBhR5DsNqP69zRI94wyOofFXJrCXq8ICxX7Lh8mCV50G+f3O3gl8iWhhFA7ELK2TfrAIVqOdGgYclDz9Ks9+F0zZSx+bUJ4+cABhe5NVJDr5GmSuMKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LCFuyC1oCCsCq98q5U6A2DY5O/t2bM5uLsAsjB4Sytk=;
 b=vWyweBmdkZsJi9MwMcn14TOq/y6NyQeNsx0LVKJ88N6xw+9CXu690D3XqILThVakz19VNODZfylJV5+LJGlkeyne9Jbi9ALpNeBaRtbIKpl4uth3e0OqaMXocooALThrFHRma6x+gBllprFiE+9H/1eK6XZkRc5TuZt1jzdxBqA=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN7PR11MB2594.namprd11.prod.outlook.com
 (2603:10b6:406:b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Wed, 8 Jul
 2020 20:43:11 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3%9]) with mapi id 15.20.3174.022; Wed, 8 Jul 2020
 20:43:11 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next 1/4] i40e, xsk: remove HW
 descriptor prefetch in AF_XDP path
Thread-Topic: [Intel-wired-lan] [PATCH net-next 1/4] i40e, xsk: remove HW
 descriptor prefetch in AF_XDP path
Thread-Index: AQHWUIbOtmh8T31Xd0+4XN8HGDRa9Kj+L5aw
Date:   Wed, 8 Jul 2020 20:43:11 +0000
Message-ID: <BN6PR1101MB214588623481B1F71061D8A68C670@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200702153730.575738-1-bjorn.topel@gmail.com>
 <20200702153730.575738-2-bjorn.topel@gmail.com>
In-Reply-To: <20200702153730.575738-2-bjorn.topel@gmail.com>
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
x-ms-office365-filtering-correlation-id: 50d1ac56-8d32-4335-0497-08d8237f8798
x-ms-traffictypediagnostic: BN7PR11MB2594:
x-microsoft-antispam-prvs: <BN7PR11MB2594F91632150A7AD07B2A3E8C670@BN7PR11MB2594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1824;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TRQD8U83m8vSL1QtoCam1xNNd2VpI+mRS9qPs8Rv9vhIqJL3+9A/w+orvk+lsqoKF0Bh1rTYyKHwtIQzBUOl+FmJR5ZXqFTGosA8L0aFXUBbTnNZj2BiaY8cP6j0wm/bLTE8NJPnqqPzrAwyDUEAonRnSrTRJ3P27Wr2XbgwkcVzA7V/4Yu7dzgx70B1MzEbka1PfMxpnDZ0n4hc8IeIJSY0zqosN4TWM8htocgoD9TU1urN00BAkzFEaiL/Bizp5bUMY/Gx8s2Trq3X6ZSly+2dc4zbb7PGS0GrkZyFn2/VAn7B3jpWvze8YccNqdGh
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(478600001)(33656002)(4744005)(186003)(54906003)(316002)(4326008)(6916009)(71200400001)(9686003)(55016002)(7696005)(64756008)(8936002)(2906002)(66476007)(76116006)(66556008)(8676002)(66946007)(52536014)(53546011)(86362001)(6506007)(26005)(5660300002)(83380400001)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: X1z2TD1JsYf9bKMXSOLDP5Lc/7jmyI5tF5QH4rn1TIDA2CvVzIr+mZE12EtB0/wbue8mMOw0UM8fu3IfDr/aY6pxYWUqxl6szyHC85+nY3mma3KDgW1F7XBaQm9+6XINEte+Y0uztXsRSPbYTAFxDHhsoZiEREdOi4tRKKMFMJWDzfMSDOM68uBX3/yB5aJyJPghlt0FsTnGA5AD6qQgok7eSpG7xpmmd8jeaLC/JEoMFmbqkcKEuPO4jM7bL7C/oCM71c49B4vGoItq5yQ05BNSX675sdfZOokCJseVr3sNspQi0nx7vWwGX7cqKzWKJK/3ubG2s21w33jE/SkbSLusI6/Wlmu5CR+y01dF3eBxk9P5ZDFqd0db1w/vTn32ehdI4wkqb3kWX7cUCvity1HcKDxryzDBmxrtB8MdFZvsrxwb5VdfUbEOw1lfOVkPnHdrd6FqTnCrez+PcTMhC3gAtK0YC71VsD5wljeGeFI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50d1ac56-8d32-4335-0497-08d8237f8798
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 20:43:11.3041
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ELQ33r0LXI9gfl1WUOa4jjdrNe746nAhE+nNrecrCjFd+xJ7a9CouIDbPQCVNWqvc9lW5ZKi1uGy0hIwt1Pjt4KgLlsarV6MgXalguyNjcM=
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
U3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIG5ldC1uZXh0IDEvNF0gaTQwZSwgeHNr
OiByZW1vdmUgSFcNCj4gZGVzY3JpcHRvciBwcmVmZXRjaCBpbiBBRl9YRFAgcGF0aA0KPiANCj4g
RnJvbTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiANCj4gVGhlIHNv
ZnR3YXJlIHByZWZldGNoaW5nIG9mIEhXIGRlc2NyaXB0b3JzIGhhcyBhIG5lZ2F0aXZlIGltcGFj
dCBvbiB0aGUNCj4gcGVyZm9ybWFuY2UuIFRoZXJlZm9yZSwgaXQgaXMgbm93IHJlbW92ZWQuDQo+
IA0KPiBQZXJmb3JtYW5jZSBmb3IgdGhlIHJ4X2Ryb3AgYmVuY2htYXJrIGluY3JlYXNlZCB3aXRo
IDIlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogQmrDtnJuIFTDtnBlbCA8Ympvcm4udG9wZWxAaW50
ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2k0MGUvaTQwZV90
eHJ4LmMgICAgICAgIHwgMTMgKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaTQwZS9pNDBlX3R4cnhfY29tbW9uLmggfCAxMyAtLS0tLS0tLS0tLS0tDQo+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pNDBlL2k0MGVfeHNrLmMgICAgICAgICB8IDEyICsrKysr
KysrKysrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCAyNSBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlv
bnMoLSkNCg0KDQpUZXN0ZWQtYnk6IEFuZHJldyBCb3dlcnMgPGFuZHJld3guYm93ZXJzQGludGVs
LmNvbT4NCg0KDQo=
