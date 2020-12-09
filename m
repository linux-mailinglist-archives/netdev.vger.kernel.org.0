Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA262D48DF
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 19:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732904AbgLISX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 13:23:58 -0500
Received: from mga06.intel.com ([134.134.136.31]:20119 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732477AbgLISX6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 13:23:58 -0500
IronPort-SDR: 5GYHRKP9YVokwYexyYhbZcMiWqdwe7f0Y4+WmMMG0arJh/jjMYt9VHA+h4o9Af06e6ORJhElxd
 9oAz1Fcm8XNw==
X-IronPort-AV: E=McAfee;i="6000,8403,9830"; a="235722209"
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="235722209"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Dec 2020 10:23:17 -0800
IronPort-SDR: zEBU5XcEeuv+suOTEKypmqlG1He3u9tJjcSze7cN25eU7xEyarCOotxuBt9afjTj0hWk0sbMjB
 i1Wi2agyis+A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.78,405,1599548400"; 
   d="scan'208";a="368353624"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 09 Dec 2020 10:23:17 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 9 Dec 2020 10:23:16 -0800
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 9 Dec 2020 10:23:16 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.100)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 9 Dec 2020 10:23:15 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zw0RCabwIsF3m9AstMIguocjfAMDPd2d4tc7Z4az2NnWWn/C0xg7poQsE80yFpUT8Wd8rjOYVzOOKhHDyh0f/rFb6RbLgppcZQkJC01cLC9UM9Q8xFiA7ftfFqYMERT7Cwz5iW5vKGcjf+s6koXlXK7A4rzbKK48WaU08FnzBXMLbZqVkH91Rhk21GdzT0qUGFfT3v4uNu7gInHEb6+h++nVe+jrzjw+cqSi2JIv9AEaE5SpMS/6Zj/JF0Dk0LMOZsnDbxK06XFl3iQaKOz3rdKLXbcZZIIz008903Dt9CL5kNsJiiPUz3nM8UakjanOHv2rowGcR+FQJi0SJsW1zw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C73dpqS6XP7ws+apz9Yn7Kj91RmtNYn9et/VbwGsrz0=;
 b=FAj0GFuurZYEv9LFc3cpyFBPp+9h3lnYnA4UWWEns1hJXx9MAKHXAeHIXfRqAIL3lRlKaix2WNhKJHA85oHWUOD6cc4eS4IfjJFXtkl/cNyqTLXaMlerENTH+P2sKyv+cT22TzBa/6ojV0z0mYo0/PdxBpgSdmQ0gNlMGEKyPeqKhhpI9nB2htVQAiqqJfzMv6oDIXNn+gXUdN2DHr3M1+sP4DqA271NW7/YzZkb3fnmSV3XTE6dpIW4mngnfvbtLTIThwprczbdLe2KaAmbiNuktDzayXobIY6Q48Tw04LeBGItCpD2UmcfAxz+VeJnYqapkANEdOuXibfoJJf+0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C73dpqS6XP7ws+apz9Yn7Kj91RmtNYn9et/VbwGsrz0=;
 b=K5s+EDFooeXC/+GoEUS0hmCezTLYaJT+7LTKCu6Khux6RiMyeXFdhaaSXiZqKiEpvp+bNsKZu0C1gK70tatrPZtF79l69HSaxWeenH6TqjmW6h3MxTcQxKQWTCFYotON6dYM37hkowKOSP0kD6j0gZRejRPmrK+Y33vCNaaltf8=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA0PR11MB4752.namprd11.prod.outlook.com (2603:10b6:806:99::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Wed, 9 Dec
 2020 18:23:14 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::5c92:dd20:ec58:76da%6]) with mapi id 15.20.3632.024; Wed, 9 Dec 2020
 18:23:14 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>
CC:     "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Cao, Chinh T" <chinh.t.cao@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Valiquette, Real" <real.valiquette@intel.com>,
        "Behera, BrijeshX" <brijeshx.behera@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Subject: Re: [net-next v3 05/15] ice: create flow profile
Thread-Topic: [net-next v3 05/15] ice: create flow profile
Thread-Index: AQHWugZDQ0KUjLzWCEaF3FhqdKPwsqnGvQ6AgAsNTYCAABK5gIAEjaeAgAAeq4CAFwldAIAAIdmAgAAyrQCAAAX0AIABT2yA
Date:   Wed, 9 Dec 2020 18:23:13 +0000
Message-ID: <7192efe4d27c93148b3205e65f37203c89170316.camel@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
         <20201113214429.2131951-6-anthony.l.nguyen@intel.com>
         <CAKgT0UeQ5q2M-uiR0-1G=30syPiO8S5OFHvDuN1XtQg5700hCg@mail.gmail.com>
         <fd0fc6f95f4c107d1aed18bf58239fda91879b26.camel@intel.com>
         <CAKgT0Uewo+Rr19EVf9br9zBPsyOUANGMSQ0kqNVAzOJ8cjWMdw@mail.gmail.com>
         <20201123152137.00003075@intel.com>
         <CAKgT0UcoYrfONNVrRcTydahgH8zqk=ans+w0RcdqugzRdodsWQ@mail.gmail.com>
         <4bd4d1e76cd74319ab54aa5ff63a1e3979c62887.camel@intel.com>
         <CAKgT0Uf+Q_dcx5Jj99XFVwf=AxbAWAD_r9PUAsbOCXdR46cMig@mail.gmail.com>
         <15a6887213b9ba894b113bb8aee834b992e0958a.camel@intel.com>
         <CAKgT0Ucxd5-gvEwWAdbL04ER2o++RX_oekUV3E0rYquEgFKj1w@mail.gmail.com>
In-Reply-To: <CAKgT0Ucxd5-gvEwWAdbL04ER2o++RX_oekUV3E0rYquEgFKj1w@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 601f4803-62f9-4458-5603-08d89c6f7e0b
x-ms-traffictypediagnostic: SA0PR11MB4752:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4752DD5EA44EA623D267F9FAC6CC0@SA0PR11MB4752.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4eG9rTf9yz5kXyYhUudIyZUM2gB03lpMzakpR7sZINnAsD5X9nXBwh7k7iZUacpIVBDQjpMbzSniCmRlQ2dENsMQvrgUFRzFeSLlybnWLMwe6r+6MKuD0H2n66S3rY/n2kp0X2s9vWfbPuYdS0WnopdfDsUkgrxO9sczS7mi9ZfQv4NzOsn+dhraomxZh1kiatuKRKn2WZvs3PZwo323gCG1GMdoH+PJfo5bJXSFh0/70inpc+Q6P2OZbaR7bKjbONBgNXg6Dr6EJ0nWOxCsr+QaqpfO49RwbquyQKnaZSEddb/oEfWyTVJaUUh5LaDP0ogGHd5MrFqLv62jBfjTpKauU+p6SlWrhsquOUxlVXrbHFV6pdtE9UJLki/yWLRS
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(366004)(376002)(36756003)(6486002)(4326008)(186003)(71200400001)(83380400001)(5660300002)(66446008)(2906002)(6916009)(54906003)(76116006)(2616005)(66556008)(91956017)(8936002)(4001150100001)(53546011)(86362001)(6512007)(8676002)(6506007)(66476007)(508600001)(26005)(64756008)(66946007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?akhaZ3FLTFVXRnVBM2JEUitXalRCTTk1aG5VcTRGWlV2bWIvRXdlbXlOeWJG?=
 =?utf-8?B?cGs1TDloSlV3QllRYzFucUxtbEk3Yy9MNXBXa2NxQTN2MWdXd0pnSkEranlr?=
 =?utf-8?B?NWZTcmtmL3QrSjJrZUlpUzhWbGFlUGE1UGkwdHY0NTltVU1SOTVNMVdJUWhw?=
 =?utf-8?B?NWlnT005SW5VbnFzbTNWc3dmTzNVQ3QxQnByRVZ1bFphenpMUkNkUlpPMWRn?=
 =?utf-8?B?RkJUaXpGT1hKTUt4VkFoK0doQ1k2eTNpYm5zdzl4VUdieVhJbkpvL0FLcEEr?=
 =?utf-8?B?cmNhUS9FMldWZnVTdU9BRFVvNmo4Y3c0ekhUSjRqZTFKZXZIM3R4ZncrYVcv?=
 =?utf-8?B?S1lMWnVxOGpaWlBVSzV4c240a0gyN3NOOUFTQW9QTkorTWpKTTc1UERXRnRm?=
 =?utf-8?B?OXZYc05kYktuNFhNMTFTUStWQWdKUWhJWkUraHhwNzk2VklqTVQ0QTBMUW4v?=
 =?utf-8?B?dC90NWN4eEtDMHhMVlZ5MUUvbjRyOCs1NjRrQWc1ZDg4ZDdUTDd6L0NObnpW?=
 =?utf-8?B?RkpmRHg3WmRWcHRHUGZlU2E3V0k1MFM4SlZ3ak1ZSG9IeUEwZFZ5MFhwNjVM?=
 =?utf-8?B?NHJyd2dGdVVZbXI2dUUxZUp0R1JvLzF0enM1Smd6eUN5R0RuV09LV0Fvc2ZR?=
 =?utf-8?B?L2ZKWXp5aVBPbWxxSW1sU0NnOHkzQ0E0QnZPdERSaUcwSGJHT3UreUl2Zm9T?=
 =?utf-8?B?WHErcDFBcXhQVk5TTVVpTXVrQlZKODlSSDJKZWxKaXZ4cG9aY0JJQmtjb2hq?=
 =?utf-8?B?c0duWFdlY3VWYjFSblJ1a210cWFkZVNVOVVoYVpLSU1OYTJ3eC9lY3k3aXQ4?=
 =?utf-8?B?YVdZeWhNNmpud09tOUQxRVUyazZiRE45MWdDUUp0QnJ3QVJIRnFqMm9LbFdG?=
 =?utf-8?B?Ymp0a0RjMU5hRmhNanI0SFZYbEdVamhCQ1FQL3U3dEtxTVRpeTUrN2JJMG4x?=
 =?utf-8?B?NkMyTnJHTzVJUmZ5ZldudXJsRWhKcm4vOUdISjBnSWtJa09iWHhpZ1BLL01C?=
 =?utf-8?B?YzBMWUdFMmVzdERyVHNTTkp5akpuUFk4dC9tc3p5aHlqR1pMaHpna1hxUEsr?=
 =?utf-8?B?NWhROFdIQ0lwM1dRcVdlQ1BKSVdmVXhHM1YvNTlqNTZUZ2R3OE9GY01Vay9K?=
 =?utf-8?B?SkZoT1hocjVZUjNZZ0U1R3BtWXJaMDBFM0hNbzl2L3VsOGRUV2YrTWl3Tldi?=
 =?utf-8?B?c1o4U3pRUHNZS1ZlUDE3MWhJYWRodkxINEk0SklrNFFiVDhLeGQ1alM5bjZh?=
 =?utf-8?B?NC9DQWNTSzhDcEYvYjhDazIvRUtTZVN4V2s1eGJST2MzYWxDOXVSZnNreWlS?=
 =?utf-8?Q?jyDuvogBR6WaqEDMa17woP15mO6syZ90l4?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6D5850CBBF49A44F87C625CC831A4BA2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 601f4803-62f9-4458-5603-08d89c6f7e0b
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2020 18:23:14.1381
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MElkleJJdjjisqlwt0PRCuAO+FeAmz0H4UJxKS5tdk3InZsBUVWFahig68Ng8ZRDatMH+/fg8Dx7WrN59X1p0nkGDXz9Ospo8Xl05SFWlQw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4752
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTEyLTA4IGF0IDE0OjIyIC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6
DQo+IE9uIFR1ZSwgRGVjIDgsIDIwMjAgYXQgMjowMSBQTSBOZ3V5ZW4sIEFudGhvbnkgTA0KPiA8
YW50aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IE9uIFR1ZSwgMjAy
MC0xMi0wOCBhdCAxMTowMCAtMDgwMCwgQWxleGFuZGVyIER1eWNrIHdyb3RlOg0KPiA+ID4gT24g
VHVlLCBEZWMgOCwgMjAyMCBhdCA4OjU4IEFNIE5ndXllbiwgQW50aG9ueSBMDQo+ID4gPiA8YW50
aG9ueS5sLm5ndXllbkBpbnRlbC5jb20+IHdyb3RlOg0KPiA+ID4gPiANCj4gPiA+ID4gT24gTW9u
LCAyMDIwLTExLTIzIGF0IDE3OjExIC0wODAwLCBBbGV4YW5kZXIgRHV5Y2sgd3JvdGU6DQo+ID4g
PiA+ID4gT24gTW9uLCBOb3YgMjMsIDIwMjAgYXQgMzoyMSBQTSBKZXNzZSBCcmFuZGVidXJnDQo+
ID4gPiA+ID4gPGplc3NlLmJyYW5kZWJ1cmdAaW50ZWwuY29tPiB3cm90ZToNCj4gPiA+ID4gPiA+
IA0KPiA+ID4gPiA+ID4gQWxleGFuZGVyIER1eWNrIHdyb3RlOg0KPiA+ID4gPiA+ID4gDQo+ID4g
PiA+ID4gPiA+ID4gPiBJJ20gbm90IHN1cmUgdGhpcyBsb2dpYyBpcyBjb3JyZWN0LiBDYW4gdGhl
IGZsb3cNCj4gPiA+ID4gPiA+ID4gPiA+IGRpcmVjdG9yDQo+ID4gPiA+ID4gPiA+ID4gPiBydWxl
cw0KPiA+ID4gPiA+ID4gPiA+ID4gaGFuZGxlDQo+ID4gPiA+ID4gPiA+ID4gPiBhIGZpZWxkIHRo
YXQgaXMgcmVtb3ZlZD8gTGFzdCBJIGtuZXcgaXQgY291bGRuJ3QuIElmDQo+ID4gPiA+ID4gPiA+
ID4gPiB0aGF0DQo+ID4gPiA+ID4gPiA+ID4gPiBpcw0KPiA+ID4gPiA+ID4gPiA+ID4gdGhlIGNh
c2UNCj4gPiA+ID4gPiA+ID4gPiA+IHlvdSBzaG91bGQgYmUgdXNpbmcgQUNMIGZvciBhbnkgY2Fz
ZSBpbiB3aGljaCBhIGZ1bGwNCj4gPiA+ID4gPiA+ID4gPiA+IG1hc2sNCj4gPiA+ID4gPiA+ID4g
PiA+IGlzDQo+ID4gPiA+ID4gPiA+ID4gPiBub3QNCj4gPiA+ID4gPiA+ID4gPiA+IHByb3ZpZGVk
LiBTbyBpbiB5b3VyIHRlc3RzIGJlbG93IHlvdSBjb3VsZCBwcm9iYWJseQ0KPiA+ID4gPiA+ID4g
PiA+ID4gZHJvcA0KPiA+ID4gPiA+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gPiA+ID4gPiBjaGVj
aw0KPiA+ID4gPiA+ID4gPiA+ID4gZm9yDQo+ID4gPiA+ID4gPiA+ID4gPiB6ZXJvIGFzIEkgZG9u
J3QgdGhpbmsgdGhhdCBpcyBhIHZhbGlkIGNhc2UgaW4gd2hpY2gNCj4gPiA+ID4gPiA+ID4gPiA+
IGZsb3cNCj4gPiA+ID4gPiA+ID4gPiA+IGRpcmVjdG9yDQo+ID4gPiA+ID4gPiA+ID4gPiB3b3Vs
ZCB3b3JrLg0KPiA+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
PiA+ID4gSSdtIG5vdCBzdXJlIHdoYXQgeW91IG1lYW50IGJ5IGEgZmllbGQgdGhhdCBpcyByZW1v
dmVkLA0KPiA+ID4gPiA+ID4gPiA+IGJ1dA0KPiA+ID4gPiA+ID4gPiA+IEZsb3cNCj4gPiA+ID4g
PiA+ID4gPiBEaXJlY3RvciBjYW4gaGFuZGxlIHJlZHVjZWQgaW5wdXQgc2V0cy4gRmxvdyBEaXJl
Y3Rvcg0KPiA+ID4gPiA+ID4gPiA+IGlzDQo+ID4gPiA+ID4gPiA+ID4gYWJsZQ0KPiA+ID4gPiA+
ID4gPiA+IHRvIGhhbmRsZQ0KPiA+ID4gPiA+ID4gPiA+IDAgbWFzaywgZnVsbCBtYXNrLCBhbmQg
bGVzcyB0aGFuIDQgdHVwbGVzLiBBQ0wgaXMNCj4gPiA+ID4gPiA+ID4gPiBuZWVkZWQvdXNlZA0K
PiA+ID4gPiA+ID4gPiA+IG9ubHkgd2hlbg0KPiA+ID4gPiA+ID4gPiA+IGEgcGFydGlhbCBtYXNr
IHJ1bGUgaXMgcmVxdWVzdGVkLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4gU28gaGlz
dG9yaWNhbGx5IHNwZWFraW5nIHdpdGggZmxvdyBkaXJlY3RvciB5b3UgYXJlIG9ubHkNCj4gPiA+
ID4gPiA+ID4gYWxsb3dlZA0KPiA+ID4gPiA+ID4gPiBvbmUNCj4gPiA+ID4gPiA+ID4gbWFzayBi
ZWNhdXNlIGl0IGRldGVybWluZXMgdGhlIGlucHV0cyB1c2VkIHRvIGdlbmVyYXRlDQo+ID4gPiA+
ID4gPiA+IHRoZQ0KPiA+ID4gPiA+ID4gPiBoYXNoDQo+ID4gPiA+ID4gPiA+IHRoYXQNCj4gPiA+
ID4gPiA+ID4gaWRlbnRpZmllcyB0aGUgZmxvdy4gU28geW91IGFyZSBvbmx5IGFsbG93ZWQgb25l
IG1hc2sgZm9yDQo+ID4gPiA+ID4gPiA+IGFsbA0KPiA+ID4gPiA+ID4gPiBmbG93cw0KPiA+ID4g
PiA+ID4gPiBiZWNhdXNlIGNoYW5naW5nIHRob3NlIGlucHV0cyB3b3VsZCBicmVhayB0aGUgaGFz
aA0KPiA+ID4gPiA+ID4gPiBtYXBwaW5nLg0KPiA+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+ID4g
Tm9ybWFsbHkgdGhpcyBlbmRzIHVwIG1lYW5pbmcgdGhhdCB5b3UgaGF2ZSB0byBkbyBsaWtlDQo+
ID4gPiA+ID4gPiA+IHdoYXQNCj4gPiA+ID4gPiA+ID4gd2UNCj4gPiA+ID4gPiA+ID4gZGlkIGlu
DQo+ID4gPiA+ID4gPiA+IGl4Z2JlIGFuZCBkaXNhYmxlIEFUUiBhbmQgb25seSBhbGxvdyBvbmUg
bWFzayBmb3IgYWxsDQo+ID4gPiA+ID4gPiA+IGlucHV0cy4NCj4gPiA+ID4gPiA+ID4gSQ0KPiA+
ID4gPiA+ID4gPiBiZWxpZXZlIGZvciBpNDBlIHRoZXkgcmVxdWlyZWQgdGhhdCB5b3UgYWx3YXlz
IHVzZSBhIGZ1bGwNCj4gPiA+ID4gPiA+ID4gNA0KPiA+ID4gPiA+ID4gPiB0dXBsZS4gSQ0KPiA+
ID4gPiA+ID4gPiBkaWRuJ3Qgc2VlIHNvbWV0aGluZyBsaWtlIHRoYXQgaGVyZS4gQXMgc3VjaCB5
b3UgbWF5IHdhbnQNCj4gPiA+ID4gPiA+ID4gdG8NCj4gPiA+ID4gPiA+ID4gZG91YmxlDQo+ID4g
PiA+ID4gPiA+IGNoZWNrIHRoYXQgeW91IGNhbiBoYXZlIGEgbWl4IG9mIGZsb3cgZGlyZWN0b3Ig
cnVsZXMgdGhhdA0KPiA+ID4gPiA+ID4gPiBhcmUNCj4gPiA+ID4gPiA+ID4gdXNpbmcgMQ0KPiA+
ID4gPiA+ID4gPiB0dXBsZSwgMiB0dXBsZXMsIDMgdHVwbGVzLCBhbmQgNCB0dXBsZXMgYXMgbGFz
dCBJIGtuZXcNCj4gPiA+ID4gPiA+ID4geW91DQo+ID4gPiA+ID4gPiA+IGNvdWxkbid0Lg0KPiA+
ID4gPiA+ID4gPiBCYXNpY2FsbHkgaWYgeW91IGhhZCBmaWVsZHMgaW5jbHVkZWQgdGhleSBoYWQg
dG8gYmUNCj4gPiA+ID4gPiA+ID4gaW5jbHVkZWQNCj4gPiA+ID4gPiA+ID4gZm9yDQo+ID4gPiA+
ID4gPiA+IGFsbA0KPiA+ID4gPiA+ID4gPiB0aGUgcnVsZXMgb24gdGhlIHBvcnQgb3IgZGV2aWNl
IGRlcGVuZGluZyBvbiBob3cgdGhlDQo+ID4gPiA+ID4gPiA+IHRhYmxlcw0KPiA+ID4gPiA+ID4g
PiBhcmUNCj4gPiA+ID4gPiA+ID4gc2V0DQo+ID4gPiA+ID4gPiA+IHVwLg0KPiA+ID4gPiA+ID4g
DQo+ID4gPiA+ID4gPiBUaGUgaWNlIGRyaXZlciBoYXJkd2FyZSBpcyBxdWl0ZSBhIGJpdCBtb3Jl
IGNhcGFibGUgdGhhbg0KPiA+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gPiBpeGdiZQ0KPiA+ID4g
PiA+ID4gb3INCj4gPiA+ID4gPiA+IGk0MGUgaGFyZHdhcmUsIGFuZCB1c2VzIGEgbGltaXRlZCBz
ZXQgb2YgQUNMIHJ1bGVzIHRvDQo+ID4gPiA+ID4gPiBzdXBwb3J0DQo+ID4gPiA+ID4gPiBkaWZm
ZXJlbnQNCj4gPiA+ID4gPiA+IHNldHMgb2YgbWFza3MuIFdlIGhhdmUgc29tZSBsaW1pdHMgb24g
dGhlIG51bWJlciBvZiBtYXNrcw0KPiA+ID4gPiA+ID4gYW5kDQo+ID4gPiA+ID4gPiB0aGUNCj4g
PiA+ID4gPiA+IG51bWJlciBvZiBmaWVsZHMgdGhhdCB3ZSBjYW4gc2ltdWx0YW5lb3VzbHkgc3Vw
cG9ydCwgYnV0IEkNCj4gPiA+ID4gPiA+IHRoaW5rDQo+ID4gPiA+ID4gPiB0aGF0IGlzIHByZXR0
eSBub3JtYWwgZm9yIGxpbWl0ZWQgaGFyZHdhcmUgcmVzb3VyY2VzLg0KPiA+ID4gPiA+ID4gDQo+
ID4gPiA+ID4gPiBMZXQncyBqdXN0IHNheSB0aGF0IGlmIHRoZSBjb2RlIGRvZXNuJ3Qgd29yayBv
biBhbiBFODEwDQo+ID4gPiA+ID4gPiBjYXJkDQo+ID4gPiA+ID4gPiB0aGVuDQo+ID4gPiA+ID4g
PiB3ZQ0KPiA+ID4gPiA+ID4gbWVzc2VkIHVwIGFuZCB3ZSdsbCBoYXZlIHRvIGZpeCBpdC4gOi0p
DQo+ID4gPiA+ID4gPiANCj4gPiA+ID4gPiA+IFRoYW5rcyBmb3IgdGhlIHJldmlldyEgSG9wZSB0
aGlzIGhlbHBzLi4uDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gSSBnYXRoZXIgYWxsIHRoYXQuIFRo
ZSBpc3N1ZSB3YXMgdGhlIGNvZGUgaW4NCj4gPiA+ID4gPiBpY2VfaXNfYWNsX2ZpbHRlcigpLg0K
PiA+ID4gPiA+IEJhc2ljYWxseSBpZiB3ZSBzdGFydCBkcm9wcGluZyBmaWVsZHMgaXQgd2lsbCBu
b3QgdHJpZ2dlciB0aGUNCj4gPiA+ID4gPiBydWxlIHRvDQo+ID4gPiA+ID4gYmUgY29uc2lkZXJl
ZCBhbiBBQ0wgcnVsZSBpZiB0aGUgZmllbGQgaXMgY29tcGxldGVseSBkcm9wcGVkLg0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IFNvIGZvciBleGFtcGxlIEkgY291bGQgZGVmaW5lIDQgcnVsZXMsIG9u
ZSB0aGF0IGlnbm9yZXMgdGhlDQo+ID4gPiA+ID4gSVB2NA0KPiA+ID4gPiA+IHNvdXJjZSwgb25l
IHRoYXQgaWdub3JlcyB0aGUgSVB2NCBkZXN0aW5hdGlvbiwgb25lIHRoYXQNCj4gPiA+ID4gPiBp
Z25vcmVzDQo+ID4gPiA+ID4gdGhlDQo+ID4gPiA+ID4gVENQIHNvdXJjZSBwb3J0LCBhbmQgb25l
IHRoYXQgaWdub3JlcyB0aGUgVENQIGRlc3RpbmF0aW9uDQo+ID4gPiA+ID4gcG9ydC4NCj4gPiA+
ID4gDQo+ID4gPiA+IFdlIGhhdmUgdGhlIGxpbWl0YXRpb24gdGhhdCB5b3UgY2FuIHVzZSBvbmUg
aW5wdXQgc2V0IGF0IGEgdGltZQ0KPiA+ID4gPiBzbw0KPiA+ID4gPiBhbnkNCj4gPiA+ID4gb2Yg
dGhlc2UgcnVsZXMgY291bGQgYmUgY3JlYXRlZCBidXQgdGhleSBjb3VsZG4ndCBleGlzdA0KPiA+
ID4gPiBjb25jdXJyZW50bHkuDQo+ID4gPiANCj4gPiA+IE5vLCBJIGdldCB0aGF0LiBUaGUgcXVl
c3Rpb24gSSBoYXZlIGlzIHdoYXQgaGFwcGVucyBpZiB5b3UgdHJ5IHRvDQo+ID4gPiBpbnB1dCBh
IHNlY29uZCBpbnB1dCBzZXQuIFdpdGggaXhnYmUgd2UgdHJpZ2dlcmVkIGFuIGVycm9yIGZvcg0K
PiA+ID4gdHJ5aW5nDQo+ID4gPiB0byBjaGFuZ2UgaW5wdXQgc2V0cy4gSSdtIHdvbmRlcmluZyBp
ZiB5b3UgdHJpZ2dlciBhbiBlcnJvciBvbg0KPiA+ID4gYWRkaW5nDQo+ID4gPiBhIGRpZmZlcmVu
dCBpbnB1dCBzZXQgb3IgaWYgeW91IGp1c3QgaW52YWxpZGF0ZSB0aGUgZXhpc3RpbmcNCj4gPiA+
IHJ1bGVzLg0KPiA+ID4gDQo+ID4gPiA+ID4gV2l0aA0KPiA+ID4gPiA+IHRoZSBjdXJyZW50IGNv
ZGUgYWxsIDQgb2YgdGhvc2UgcnVsZXMgd291bGQgYmUgY29uc2lkZXJlZCB0bw0KPiA+ID4gPiA+
IGJlDQo+ID4gPiA+ID4gbm9uLUFDTCBydWxlcyBiZWNhdXNlIHRoZSBtYXNrIGlzIDAgYW5kIG5v
dCBwYXJ0aWFsLg0KPiA+ID4gPiANCj4gPiA+ID4gQ29ycmVjdC4gSSBkaWQgdGhpcyB0byB0ZXN0
IEZsb3cgRGlyZWN0b3I6DQo+ID4gPiA+IA0KPiA+ID4gPiAnZXRodG9vbCAtTiBlbnM4MDFmMCBm
bG93LXR5cGUgdGNwNCBzcmMtaXAgMTkyLjE2OC4wLjEwIGRzdC1pcA0KPiA+ID4gPiAxOTIuMTY4
LjAuMjAgc3JjLXBvcnQgODUwMCBhY3Rpb24gMTAnIGFuZCBzZW50IHRyYWZmaWMgbWF0Y2hpbmcN
Cj4gPiA+ID4gdGhpcy4NCj4gPiA+ID4gVHJhZmZpYyBjb3JyZWN0bHkgd2VudCB0byBxdWV1ZSAx
MC4NCj4gPiA+IA0KPiA+ID4gU28gYSBiZXR0ZXIgcXVlc3Rpb24gaGVyZSBpcyB3aGF0IGhhcHBl
bnMgaWYgeW91IGRvIGEgcnVsZSB3aXRoDQo+ID4gPiBzcmMtcG9ydCA4NTAwLCBhbmQgYSBzZWNv
bmQgcnVsZSB3aXRoIGRzdC1wb3J0IDg1MDA/IERvZXMgdGhlDQo+ID4gPiBzZWNvbmQNCj4gPiA+
IHJ1bGUgZmFpbCBvciBkb2VzIGl0IGludmFsaWRhdGUgdGhlIGZpcnN0LiBJZiBpdCBpbnZhbGlk
YXRlcyB0aGUNCj4gPiA+IGZpcnN0DQo+ID4gPiB0aGVuIHRoYXQgd291bGQgYmUgYSBidWcuDQo+
ID4gDQo+ID4gVGhlIHNlY29uZCBydWxlIGZhaWxzIGFuZCBhIG1lc3NhZ2UgaXMgb3V0cHV0IHRv
IGRtZXNnLg0KPiA+IA0KPiA+IGV0aHRvb2wgLU4gZW5zODAxZjAgZmxvdy10eXBlIHRjcDQgc3Jj
LWlwIDE5Mi4xNjguMC4xMCBkc3QtaXANCj4gPiAxOTIuMTY4LjAuMjAgZHN0LXBvcnQgODUwMCBh
Y3Rpb24gMTANCj4gPiBybWdyOiBDYW5ub3QgaW5zZXJ0IFJYIGNsYXNzIHJ1bGU6IE9wZXJhdGlv
biBub3Qgc3VwcG9ydGVkDQo+IA0KPiBVZ2guIEkgcmVhbGx5IGRvbid0IGxpa2UgdGhlIGNob2lj
ZSB0byB1c2UgRU9QTk9UU1VQUCBhcyB0aGUgcmV0dXJuDQo+IHZhbHVlIGZvciBhIG1hc2sgY2Fz
ZS4gSXQgcmVhbGx5IHNob3VsZCBoYXZlIGJlZW4gc29tZXRoaW5nIGxpa2UgYW4NCj4gRUJVU1kg
b3IgRUlOVkFMIHNpbmNlIHlvdSBhcmUgdHJ5aW5nIHRvIG92ZXJ3cml0ZSBhbiBhbHJlYWR5IHdy
aXR0ZW4NCj4gbWFzayBzbyB5b3UgY2FuIGNoYW5nZSB0aGUgZmllbGQgY29uZmlndXJhdGlvbi4N
Cj4gDQo+ID4gZG1lc2c6DQo+ID4gaWNlIDAwMDA6ODE6MDAuMDogRmFpbGVkIHRvIGFkZCBmaWx0
ZXIuICBGbG93IGRpcmVjdG9yIGZpbHRlcnMgb24NCj4gPiBlYWNoDQo+ID4gcG9ydCBtdXN0IGhh
dmUgdGhlIHNhbWUgaW5wdXQgc2V0Lg0KPiANCj4gT2theSwgc28gdGhpcyBpcyB0aGUgYmVoYXZp
b3IgeW91IHNlZSB3aXRoIEZsb3cgRGlyZWN0b3IuIElmIHlvdQ0KPiBkb24ndA0KPiBhcHBseSBh
IHBhcnRpYWwgbWFzayBpdCBmYWlscyB0byBhZGQgdGhlIHNlY29uZCBydWxlLg0KPiANCj4gPiA+
ID4gPiBJZiBJIGRvIHRoZSBzYW1lDQo+ID4gPiA+ID4gdGhpbmcgYW5kIGlnbm9yZSBhbGwgYnV0
IG9uZSBiaXQgdGhlbiB0aGV5IGFyZSBhbGwgQUNMIHJ1bGVzLg0KPiA+ID4gPiANCj4gPiA+ID4g
QWxzbyBjb3JyZWN0LiBJIGRpZCBhcyBmb2xsb3dzOg0KPiA+ID4gPiANCj4gPiA+ID4gJ2V0aHRv
b2wgLU4gZW5zODAxZjAgZmxvdy10eXBlIHRjcDQgc3JjLWlwIDE5Mi4xNjguMC4xMCBkc3QtaXAN
Cj4gPiA+ID4gMTkyLjE2OC4wLjIwIHNyYy1wb3J0IDkwMDAgbSAweDEgYWN0aW9uIDE1Jw0KPiA+
ID4gPiANCj4gPiA+ID4gU2VuZGluZyB0cmFmZmljIHRvIHBvcnQgOTAwMCBhbmQgOTAwMDEsIHRy
YWZmaWMgd2VudCB0byBxdWV1ZQ0KPiA+ID4gPiAxNQ0KPiA+ID4gPiBTZW5kaW5nIHRyYWZmaWMg
dG8gcG9ydCA4MDAwIGFuZCA5MDAwMiwgdHJhZmZpYyB3ZW50IHRvIG90aGVyDQo+ID4gPiA+IHF1
ZXVlcw0KPiA+ID4gDQo+ID4gPiBUaGUgdGVzdCBoZXJlIGlzIHRvIHNldC11cCB0d28gcnVsZXMg
YW5kIHZlcmlmeSBlYWNoIG9mIHRoZW0gYW5kDQo+ID4gPiBvbmUNCj4gPiA+IGNhc2UgdGhhdCBm
YWlscyBib3RoLiBTYW1lIHRoaW5nIGZvciB0aGUgdGVzdCBhYm92ZS4gQmFzaWNhbGx5IHdlDQo+
ID4gPiBzaG91bGQgYmUgYWJsZSB0byBwcm9ncmFtIG11bHRpcGxlIEFDTCBydWxlcyB3aXRoIGRp
ZmZlcmVudCBtYXNrcw0KPiA+ID4gYW5kDQo+ID4gPiB0aGF0IHNob3VsZG4ndCBiZSBhbiBpc3N1
ZSB1cCB0byBzb21lIGxpbWl0IEkgd291bGQgaW1hZ2luZS4gU2FtZQ0KPiA+ID4gdGhpbmcgZm9y
IGZsb3cgZGlyZWN0b3IgcnVsZXMuIEFmdGVyIHRoZSBmaXJzdCB5b3Ugc2hvdWxkIG5vdCBiZQ0K
PiA+ID4gYWJsZQ0KPiA+ID4gdG8gcHJvdmlkZSBhIGZsb3cgZGlyZWN0b3IgcnVsZSB3aXRoIGEg
ZGlmZmVyZW50IGlucHV0IG1hc2suDQo+ID4gDQo+ID4gSSBkaWQgdGhpczoNCj4gPiANCj4gPiBl
dGh0b29sIC1OIGVuczgwMWYwIGZsb3ctdHlwZSB0Y3A0IHNyYy1pcCAxOTIuMTY4LjAuMTAgZHN0
LWlwDQo+ID4gMTkyLjE2OC4wLjIwIHNyYy1wb3J0IDkwMDAgbSAweDEgYWN0aW9uIDE1DQo+ID4g
ZXRodG9vbCAtTiBlbnM4MDFmMCBmbG93LXR5cGUgdGNwNCBzcmMtaXAgMTkyLjE2OC4wLjEwIGRz
dC1pcA0KPiA+IDE5Mi4xNjguMC4yMCBzcmMtcG9ydCA4MDAwIG0gMHgyIGFjdGlvbiAyMA0KPiA+
IA0KPiA+IFNlbmRpbmcgdHJhZmZpYyB0byBwb3J0IDkwMDAgYW5kIDkwMDEgZ29lcyB0byBxdWV1
ZSAxNQ0KPiA+IFNlbmRpbmcgdHJhZmZpYyB0byBwb3J0IDgwMDAgYW5kIDgwMDIgZ29lcyB0byBx
dWV1ZSAyMA0KPiA+IFNlbmRpbmcgdHJhZmZpYyB0byBwb3J0IDgwMDEgYW5kIDg1MDAgZ29lcyB0
byBuZWl0aGVyIG9mIHRoZSBxdWV1ZXMNCj4gDQo+IERvaW5nIHRoZSBzYW1lIHRoaW5nIHdpdGgg
YSBtYXNrIHdvcmtzLiBJIGNvdWxkIGFkZCBzcmMtcG9ydCB3aXRoIGENCj4gbWFzayBpbiBvbmUg
cnVsZSwgYW5kIEkgY291bGQgYWRkIGRzdC1wb3J0IHdpdGggYSBtYXNrIGluIGFub3RoZXIuDQo+
IENhbg0KPiB5b3Ugc2VlIHRoZSBpbmNvbnNpc3RlbmN5IGhlcmU/DQoNClRoYW5rcyBmb3IgdGhl
IHJldmlld3MgQWxleC4gSSBzZWUgeW91ciBwb2ludC4gSSdtIGdvaW5nIHRvIGRyb3AgdGhlDQpB
Q0wgcGF0Y2hlcyBmcm9tIHRoaXMgc2VyaWVzIGFuZCBzZW5kIHRoZSBvdGhlciBwYXRjaGVzIHdo
aWxlIHdlIGxvb2sNCmludG8gdGhpcy4gDQoNCi1Ub255DQo=
