Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E583277B9B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 00:25:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726685AbgIXWZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 18:25:52 -0400
Received: from mga07.intel.com ([134.134.136.100]:34770 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726239AbgIXWZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Sep 2020 18:25:52 -0400
IronPort-SDR: bp+MMK5vOxHoIjnhZ64lAw+2oF1NAX7BsUy2v4IF3FbhJlKO/JtL7g4L9d+rX/JT3ZE4SzCg8R
 WtCL3k/gpfZA==
X-IronPort-AV: E=McAfee;i="6000,8403,9754"; a="225506463"
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="225506463"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Sep 2020 15:25:50 -0700
IronPort-SDR: yVzTD6RnuerYGGG6tMwy5JuFcUFbGtdv2VtC9RKqmb1ypB8bPWc65Q0DG4yQEm7Gy10k5nH36C
 Vi7lnOAabZgw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,299,1596524400"; 
   d="scan'208";a="348011840"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 24 Sep 2020 15:25:50 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Sep 2020 15:25:50 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 24 Sep 2020 15:25:49 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 24 Sep 2020 15:25:49 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.177)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Thu, 24 Sep 2020 15:25:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fprtVAYb7+xkWk3pvGLdaR6s8ZDfuTvC2yAaVTy34iZNTlr7tY4A6jJ1eQikLNOHfzWoC3ukZZaHY2+Niifz6ILx6kGj2MhVrbedMKz3TPtUusmICgpJmvX+w51bcPQdDAoXHRfbm06CUqnFfJgHKZChlv+zcPXhJXvoGo34bpfjElmRNXM2F7ChwTeYQXUXcIoLG3ue13GyECjVD0m2ojQ+xkNyIsfMv7aEvd4bajdMjLEAQ/isRepa8zvcXZ8sMv4JSnhZ6W661doVnCM9aSPhwA55xGW46gACYmlHAKBxmX84hVNrTA9ekRaQ/13rVWPstUeXq5yrF5xucpuS9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkNf4mS2ESGXnU0w2ss6/AGQKLHCJ0B8lcn9PNg7f1w=;
 b=F4IG32vRLxu1hx7fZwX+VxhxoiQv6rWY+aTBa3UM5jEm5UyK1utHYLXvcCVQMyLLkmQmdZEWi6y5pydHsCZYGCe0nb6ft3EhpZq4SiIGxEySBCvTXqeC0VjGKairywRzyu/uetBn9DKvjoV+sgrMDegiZMQyKP9DeXrr7aLJ22tm2O3VkcziOm+9XXIZQ6YuX33rnikryAEcnH4JxNdfhk4oeaILJqtOLt8iujoqW8if7TjgW+85MHswFaKs2o/QsmgQlcAD6mxpbTUQLNHTYqZhwvyMkgKGP3mmHacykTUiFD5uZrDkPaZS/5Oe3rbGc22so0YeQ9LlDB0RU5enDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PkNf4mS2ESGXnU0w2ss6/AGQKLHCJ0B8lcn9PNg7f1w=;
 b=gn9DpCVmxrScoO/CE7Gc2MDI/VGcc2IxKgKdJ6JxG3/ELlOrBIHkX2lEndY4j7Cr9rDDUCfU5NuG9rLHMj30EsFrYiKPSD/dtIWebyawxAtKGV8x+cAQAHXQvX2GgGUy+dkO04JrAJcOfg8sjXEbnT/gXj1MNNGezQy3GLsWk6E=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB3518.namprd11.prod.outlook.com (2603:10b6:805:da::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Thu, 24 Sep
 2020 22:25:46 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e%7]) with mapi id 15.20.3412.021; Thu, 24 Sep 2020
 22:25:46 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>,
        "Brown, Aaron F" <aaron.f.brown@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a
 test for shared UDP tunnel info tables
Thread-Topic: [Intel-wired-lan] [PATCH net-next v1 4/7] selftests: net: add a
 test for shared UDP tunnel info tables
Thread-Index: AQHWX8dIyTC1OJpR7UuWkn2gfn3JT6lv7B4AgAQU/gCABMKfgA==
Date:   Thu, 24 Sep 2020 22:25:46 +0000
Message-ID: <808d485e3d63a2e10f1fba75c0cac968d8f844aa.camel@intel.com>
References: <20200722012716.2814777-1-kuba@kernel.org>
         <20200722012716.2814777-5-kuba@kernel.org>
         <SN6PR11MB2896F5ACC5A59F7F330183FFBC3C0@SN6PR11MB2896.namprd11.prod.outlook.com>
         <20200921144408.19624164@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200921144408.19624164@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1672bb73-8fa4-41d3-9296-08d860d8c892
x-ms-traffictypediagnostic: SN6PR11MB3518:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB351820CA611F106F0E9E9EEAC6390@SN6PR11MB3518.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sFSsr8mytXmXAC7U8UkdFPsJdbT7ks5Xli97Bd3lchXuCjPHfp7dJ1u8g4kOypfvWlRywEb0fOE2shxRNEr9WFv30ugMK0M3taI6RJZAp7jDMKLsx9FsuYdt15TwjBhQTbr9kiv2U60E8kC2Kx/kbL+hX9rVsAqRcTiAdWM0sTbWPyDsXb7CIkKWd8m5yuEJRdH9Dorwhwp350QnMn5Kb0I6WxRiXNNbON++b/3pekZQq31HY1eg1DIG8/l/KjpoN8RAKRwADA1lA5RJ6cYTgtDu4AtWZ8v1R5YZ/KivsdXYzGSlzSkyYg2Q5NyG2c5WP7ZUEAREc3ho3hzQg5iLEIik/82nCKDcdQ49wdT56FdBcRryG4tSJZ83jPRfrtvA
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(376002)(39860400002)(76116006)(2616005)(2906002)(6512007)(71200400001)(6636002)(8676002)(6486002)(8936002)(54906003)(4326008)(110136005)(6506007)(66946007)(478600001)(66446008)(64756008)(91956017)(66556008)(66476007)(186003)(26005)(36756003)(86362001)(5660300002)(53546011)(316002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: xDXH4cDq/6jtRxlfCtAO/+zV0I7sIbeASqGWIM92d0P35uWDk5PZBKkkfMrCCclqHljT9nlRnPY5d43oM1Dl4+Ex4A4qb7oUFIfiZZ6nKVPkAOLenAeJqvMs6SVWEG26Fh64SF0jXFE2kVy28xqIXh5NqMZO4ODtZxX4fcid1Pf0/2d2WaDOqkyw+N0hfbTuXYxFyR7oKDtP1wwPT+/qVq2VQvSdurTHVwBECcNBkjhueGKvbVrMPLIuduckWnY6JwXdOryVLN0+m48wS48LAu647+NIX3BjvXTXe+PH0G2BFhHQxf2oMbwRSILHRQWtdn+j+ocO0fLJiYdpbPK3CXcASap8wRMYi+FIhx3vF0YrHP+E5f442CG9CXtnPJq5kOE5jOsOY5y4BR5iEibcerzLQW7sOJV/EJnBEMPP5kuLSiM88bVMPqwgznADNU08kg131LTCTSsPiXw2v+Q46LK0MFar1F1CrwmMIKQWJwKWgWclzW6UrcT4atl+VDxVxb2Wlq8TIxH7jow+7Ip+a5WJdoCAmVkHpCnqpKG9NOerU2/c2fkOpd4kfbSyFdCAsR4cltN8p9EzEzyTSPTPgbIlvIP+jK9D+ILZg+EVEEt4H2T5Yycdm6yd1NtpR68c+7WVfhDi8n18oErwd0CxTQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <13E02808B9C5364794BF7EEB07BCC59F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1672bb73-8fa4-41d3-9296-08d860d8c892
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Sep 2020 22:25:46.6117
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WwNmCT5FBs0FoL32kJRV08BB/AISHK6ao5HwTWiLLRJV2VfdpO9NjAvUB7KC3VRLLPOdgiVRLffRf87+2r8597dAJtUa5h5f0wxSCF/uBYE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3518
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIwLTA5LTIxIGF0IDE0OjQ0IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gU2F0LCAxOSBTZXAgMjAyMCAwNzoyMzo1OCArMDAwMCBCcm93biwgQWFyb24gRiB3cm90
ZToNCj4gPiA+IEZyb206IEludGVsLXdpcmVkLWxhbiA8aW50ZWwtd2lyZWQtbGFuLWJvdW5jZXNA
b3N1b3NsLm9yZz4gT24NCj4gPiA+IEJlaGFsZiBPZiBKYWt1Yg0KPiA+ID4gS2ljaW5za2kNCj4g
PiA+IFNlbnQ6IFR1ZXNkYXksIEp1bHkgMjEsIDIwMjAgNjoyNyBQTQ0KPiA+ID4gVG86IGRhdmVt
QGRhdmVtbG9mdC5uZXQNCj4gPiA+IENjOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBpbnRlbC13
aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZzsNCj4gPiA+IEpha3ViIEtpY2luc2tpDQo+ID4gPiA8
a3ViYUBrZXJuZWwub3JnPg0KPiA+ID4gU3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENI
IG5ldC1uZXh0IHYxIDQvN10gc2VsZnRlc3RzOg0KPiA+ID4gbmV0OiBhZGQgYSB0ZXN0IGZvcg0K
PiA+ID4gc2hhcmVkIFVEUCB0dW5uZWwgaW5mbyB0YWJsZXMNCj4gPiA+IA0KPiA+ID4gQWRkIGEg
dGVzdCBydW4gb2YgY2hlY2tzIHZhbGlkYXRpbmcgdGhlIHNoYXJlZCBVRFAgdHVubmVsIHBvcnQN
Cj4gPiA+IHRhYmxlcyBmdW5jdGlvbiBhcyB3ZSBleHBlY3QuDQo+ID4gPiANCj4gPiA+IFNpZ25l
ZC1vZmYtYnk6IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+DQo+ID4gPiAtLS0NCj4g
PiA+ICAuLi4vZHJpdmVycy9uZXQvbmV0ZGV2c2ltL3VkcF90dW5uZWxfbmljLnNoICAgfCAxMDkN
Cj4gPiA+ICsrKysrKysrKysrKysrKysrKw0KPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAxMDkgaW5z
ZXJ0aW9ucygrKQ0KPiA+ID4gICANCj4gPiANCj4gPiBJIHJhbiBpbnRvIHR3byB0aGluZ3Mgd2hp
bGUgcnVubmluZyB0aGlzIHNjcmlwdC4NCj4gPiAxLiBUaGUgc2NyaXB0IGFzIGl0IGV4aXN0cyBp
biB0aGUgZ2l0IHRyZWUgKEplZmYgS2lyc2hlcnMgbmV4dC0NCj4gPiBxdWV1ZSkgaXMgbm90IGV4
ZWN1dGFibGUuICBJIGRvbid0IGtub3cgaWYgdGhhdCdzIGEgcGF0Y2ggaXNzdWUgb3INCj4gPiB0
cmFuc2xhdGlvbiBpbnRvIHRoZSB0cmVlLiAgRWFzeSBlbm91Z2ggdG8gZ2V0IGFyb3VuZCwgYnV0
IHNob3VsZA0KPiA+IHByb2JhYmx5IGJlIGV4ZWN1dGFibGUgdG8gc3RhcnQuDQo+IA0KPiBBaCwg
Z29vZCBjYXRjaCwgdGhhbmtzISBQbGVhc2UgYWRqdXN0IGluIHlvdXIgdHJlZSBvciBJIGNhbiBz
ZW5kIGENCj4gZm9sbG93IHVwIHdpdGggb3RoZXIgcGF0Y2hlcyBJIHN0aWxsIGhhdmUgcXVldWVk
Lg0KDQpIaSBKYWt1YiwNCg0KSXQnZCBiZSBncmVhdCBpZiB5b3UgY291bGQgYWRqdXN0IGFuZCBy
ZXNlbmQgdGhlIHNlcmllcy4gQXMgd2UncmUgc3RpbGwNCndvcmtpbmcgdGhyb3VnaCBvdXIgZW1h
aWwgc2VydmVyIGlzc3VlLCBJIGRvbid0IGtub3cgaWYgZXZlcnl0aGluZw0Kd291bGQgbWFrZSBp
dCBoZXJlLg0KDQpUaGFua3MsDQpUb255DQo=
