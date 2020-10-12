Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18C2928BE0B
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 18:32:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403803AbgJLQbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 12:31:44 -0400
Received: from mga07.intel.com ([134.134.136.100]:34308 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390683AbgJLQbo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Oct 2020 12:31:44 -0400
IronPort-SDR: R/ulgo55n2f8tRUMLiOKAroCwzgDKUTdsSPSlh8g53XNk+gPuwjLAARTCHK/GogxypqisxhSc8
 jNYkQZ1wlgjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9772"; a="229947119"
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="229947119"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:31:43 -0700
IronPort-SDR: 8BWmHqsWyhFo41WQEk2THkGNJcR9/UKBPvScNDzlhZMR/aeyA0keSOLXcieqW6zmjCw6A9KbNE
 Lced9MwKZn/g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,367,1596524400"; 
   d="scan'208";a="345909361"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga008.jf.intel.com with ESMTP; 12 Oct 2020 09:31:41 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 09:31:41 -0700
Received: from fmsmsx606.amr.corp.intel.com (10.18.126.86) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 12 Oct 2020 09:31:40 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx606.amr.corp.intel.com (10.18.126.86) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 12 Oct 2020 09:31:40 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 12 Oct 2020 09:31:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gf5/BRuJsofp5biI8Ei8A37awycA20UVeUApgqM/ABx4Yzd+PoByHnBjNsl4Oc8SXHRgznSnm9exQG3xpyPPt+9zacXJQk2WcFNSKu+pb+3dBLduJS/+2RTG35PaLI+FrW5g3LCqdPIi8U1pJwa5NHW+Ywgl/LEP6mj+VfN50dWvEVMMQxOs1l1SJ+ubN5B3u0HQ8w+5WB+TiLMk5mhlyuTCQkWwFJZGscxL3SAziRDj2V2tWSp4BQdDSC5jESFbWtOTZiL4p/SvLRBpc6vUngoomtBEXluoaQ3n9UlunGH0Hqme+a8x2aKOfwINrlJ+/0s6dguED78ZYu5vwNGohg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKb2gvd1ENBiarzQydWr2VJdYBWigYI4oJQy23voDYw=;
 b=PtrFIo+r8w8PlJY1vkuMyolq5KwKApbW2yvEk71vXlAArMahJFr3X3Y6ssSNU3tVJD6hHjM7pqCmX8AWDhoVKYsWe2IB3sQfgwGp22D9D/+z1LL826rz+0FCFVwwAQuyEOzXwdfyhGKuMj/tAr9qDpcaF+pnXSDt9Y/HKwJQ4R2IzHZzf87Pt72fdsqtdJekVUi2JPxdNIuU9L6ErMJ4IP5OPmHgt9BmsA75mcfxO8+sDHQ2swpWUFd5YaSaSQai24QWMGqGWqZEHskbu751pZr8O+v51aDFClW3YhPxpB4aE+91QJ+kkpJq+xz09ZOw4XNgetiBhOBTHraLZrJurw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dKb2gvd1ENBiarzQydWr2VJdYBWigYI4oJQy23voDYw=;
 b=jt+PMKLo5ZA9Ex0RZfOa/+LeJUmx/8pZW/PYRddOucnVNjuAP1KHOU0OF0SyhjOncCMzqjKqNt3VvI0yMFoC/9u1oYv8pLeiLB1FFDpWI3HP7i4ox0Mx+hip2aOxIZoJ5NC8Ou9Ov7YRBAEXRwIfdtk4objLlA3uo5HsJbSTxls=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4843.namprd11.prod.outlook.com (2603:10b6:806:fb::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.30; Mon, 12 Oct
 2020 16:31:37 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e%7]) with mapi id 15.20.3455.030; Mon, 12 Oct 2020
 16:31:37 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "Gawin, JaroslawX" <jaroslawx.gawin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrewx.bowers@intel.com" <andrewx.bowers@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [net-next 1/3] i40e: Allow changing FEC settings on X722 if
 supported by FW
Thread-Topic: [net-next 1/3] i40e: Allow changing FEC settings on X722 if
 supported by FW
Thread-Index: AQHWnP8n2DqkTyifzUuYSdeJ7O3Q9amP8BIAgARAPQA=
Date:   Mon, 12 Oct 2020 16:31:37 +0000
Message-ID: <76ff76cf5daa54c74e79bea7da9a7ccb8778322c.camel@intel.com>
References: <20201007231050.1438704-1-anthony.l.nguyen@intel.com>
         <20201007231050.1438704-2-anthony.l.nguyen@intel.com>
         <20201009163638.6d4c76bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201009163638.6d4c76bd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 715c3365-690e-4137-9d1b-08d86ecc4a84
x-ms-traffictypediagnostic: SA2PR11MB4843:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB48437251151E60210EEE537BC6070@SA2PR11MB4843.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: o6V2WUYiObTOuOVgCBk+fQ4c1HJWQZdOJswJDPziwqtMpHi4OtfRaddP9nKWc4Wz9FibfZWD0/pKiIMbki2gyXhVMZjq8an5d/HAjtOQlA6JBBVNLCyyuOKb5X+7QIDTgMHPhyztToDGrn700f9wotFdEBDDgwe17A0Faw0iEDtsa8C148wEjtyyvnk8AC/UDMkQJUsZWFojCZWF/kxuDRJBu8O/EfRUEOhc/RBtr014Y/MhYtJ7RlAJiOrJlp4bpcYiBJpKEpbLKzhyGL6DQL12QXF5KMbYSYjftFjNxwQ/U+H8IEd/sBdA7p/nd12alyoDF6G/hiWpa4J9pNztL6SjtnBLIz/qG+2yMm8doFBPeTS7wm/xmpJIS/8/GHY6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(376002)(39860400002)(136003)(366004)(66446008)(64756008)(71200400001)(66556008)(6512007)(91956017)(26005)(6486002)(76116006)(4744005)(6506007)(8936002)(86362001)(66946007)(8676002)(66476007)(316002)(83380400001)(186003)(5660300002)(54906003)(478600001)(4326008)(36756003)(2906002)(6916009)(2616005)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: h55xRk/dticB4PHtIvrFx/fCSxDsBcj1Q7+oTEb2wgGzrP2W9dBb3SQYH02uYA2+qo09rFxubc8Vsi4JW949ShTuxISSoGFnwApIJslr3LqqMkevrBfnQhbuRHaDDNDcZXLw5x+GfXaJkiA4VzZAmPy/fdcfqsDguuHMtGSxrpoEGvW/ueywqzrQ8EKLa3oNeo5oJzCNxnT+6+k67X8KQNmMpVMX34YyTt1oK9MJ8VuQIXSTydNptuFr6qU5o4L6MfBwl6vibgTrw/KI8SwAVCUSDH1Q0yLtVSXR0hx1fBbnyrm8s7pW+9LFkMSrdAsaCOi9EfSSD56lDEPd7HRQul/eUjaIGt0g81KySkhw12BISFdJTPaKOxSSjjqhp5y4TSOjXeRrAtZ35RA2nN61ioiCg4TAW6KeLdmt165CQvaJaRJ1cOIAiOyL/5WFIx2znP2rLO/uRwXvrDV8OQGlDYcW7MBrZHgFn2hBcyZDi8ZFCEqx8LQXunAdERFu2JG2EYOoKUlhM2WA0U70ZeTcMqV7o7D5S1zVyvNZMTEeCieCkLKBJYAOoSVH2xWSBvnr5v0R5p6cctH2xcXvgD7HlZZsuTzxxVTug04hTs9mRWlNPdV0rztEAhz35Om0DeAFU0YLNFOLOELyEOePi1ZAEA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <4264799595C4BA4CA7BBCA50D4582CA9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715c3365-690e-4137-9d1b-08d86ecc4a84
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Oct 2020 16:31:37.4424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vlKeRWyQ9qGLj0Ptok03+YpHH2lqqfOYgpo5DfwAf3oAnu4JHWzzcPZ9uo7klLVfuHqqDUeUcXbbKDfGXIQj9lC3oK3M8w3rLpQ1EBVXDYI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4843
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE2OjM2IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAgNyBPY3QgMjAyMCAxNjoxMDo0OCAtMDcwMCBUb255IE5ndXllbiB3cm90ZToN
Cj4gPiArCWlmIChody0+bWFjLnR5cGUgPT0gSTQwRV9NQUNfWDcyMiAmJg0KPiA+ICsJICAgICEo
aHctPmZsYWdzICYgSTQwRV9IV19GTEFHX1g3MjJfRkVDX1JFUVVFU1RfQ0FQQUJMRSkpIHsNCj4g
PiArCQluZXRkZXZfZXJyKG5ldGRldiwgIlNldHRpbmcgRkVDIGVuY29kaW5nIG5vdCBzdXBwb3J0
ZWQNCj4gPiBieSBmaXJtd2FyZS4gUGxlYXNlIHVwZGF0ZSB0aGUgTlZNIGltYWdlLlxuIik7DQo+
ID4gKwkJcmV0dXJuIC1FSU5WQUw7DQo+IA0KPiBFT1BOT1RTVVBQLCBzaW5jZSBubyBGRUMgc2V0
dGluZ3MgYXJlIHN1cHBvcnRlZCBieSB0aGUgZGV2aWNlIA0KPiBhdCB0aGUgdGltZSBvZiByZXF1
ZXN0Lg0KDQpJJ2xsIGdldCB0aGlzIGNoYW5nZWQuDQoNClRoYW5rcywNClRvbnkNCg==
