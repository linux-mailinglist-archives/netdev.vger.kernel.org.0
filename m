Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99E43288F02
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 18:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389778AbgJIQfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 12:35:41 -0400
Received: from mga09.intel.com ([134.134.136.24]:12229 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388719AbgJIQfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 12:35:40 -0400
IronPort-SDR: 4uAyPpGuGnhQO0ooVVoK50SrSVTJJbepWCYz5dYjsh+IjRxDiIyT5/RlbXBsFd0x89RaO+lI6Q
 OnZue84ux/Aw==
X-IronPort-AV: E=McAfee;i="6000,8403,9769"; a="165620806"
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="165620806"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2020 09:35:39 -0700
IronPort-SDR: WZ/uj99NQ8+QJQgqhwTEqDSVnxiKR/vVkzBJ3qkFandR4kHHeaq4KaOW6POj4rhcA4bQ/rt45/
 jpWwO5LW9w3A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,355,1596524400"; 
   d="scan'208";a="343900811"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 09 Oct 2020 09:35:38 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 9 Oct 2020 09:35:38 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 9 Oct 2020 09:35:37 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 9 Oct 2020 09:35:37 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Fri, 9 Oct 2020 09:35:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Njv9NdaEZZ7atWucB8ZDdix6Q+5iuifmg/xDoddysari4D95s3ZPurHyAHGjKsD6R83wxatLreHuPkjBUqYHE22+Mt3ZoXbfMW5HJRLDsVNSwWUGW8h1yTyXbxbxK8HpfnQTSQbtx7PviEvTJZgXt3sXxWRyqhzcYWhtupjAtCN8gU4z40xcjuJykxGimW0wta5+JH/y6wYzdrg2NhV+cYk1CAT2Pxy07l/cm8bhz1OI+wd6wsUVLYxaUIaXOpwA6fjngC/OxUv7RwlT6daD8qqhKiPu5omPCIi9S2zNPdAdS0mUxCDIvohvl8wptihRdlqBWFwCDklifcJRpNCp6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kjRJamqhVQ9GZIg022go9ANMrzsfoCmM7XSH/lj7/Y=;
 b=lbZQ9Vhu1grh1OxYHW8DuZNgqK6sm4vrUG+igiVRJ5Fhz4++TLQZAUie4POoDYXiYAUIF0HWan4AYjWwzv4X5nP1EPVXby/irkHMYLPsT+TO/qOVIvnqafhXF8ZU43wAb5qa3QOQcQUuBHwvfnYSdCFyZ1QrF0UhMhqqpR1ZS6cD109Upu2Zng0HHVfw3lcI8htgylkNtrPicFAnuWD11+UlvRRrQ2UaY2FL5TkQ1z5X1EQrISQrCAvfm8ZRSp/ZXxkls+IJR+fCFPAdJwnRHCT6HaRZUHx90Px1GjfvgfKTJRYb+Dxb6xnO0YACCaajQR5HHYC3AvwGzlkq/57DeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7kjRJamqhVQ9GZIg022go9ANMrzsfoCmM7XSH/lj7/Y=;
 b=xHGkekS1jWb8iF6yOhaFIaKihgYZUeR7ElY6kIrnhws79UVniTdc9ANcthx3WiJy/hN9DZY7Gl4SSQTRcJ0nvBUVYArYUTWA/e7Q+8KVnozcEpWqo7Axt8xRQnmVsv+vgzaYY4vT/kkLVvMKyc9uaoYS/gI1TsEIQBg401wWz7Q=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB5067.namprd11.prod.outlook.com (2603:10b6:806:111::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3433.34; Fri, 9 Oct
 2020 16:35:35 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::acc4:9465:7e88:506e%7]) with mapi id 15.20.3455.024; Fri, 9 Oct 2020
 16:35:35 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "shipujin.t@gmail.com" <shipujin.t@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
Subject: Re: [PATCH] net: intel: ice: Use uintptr_t for casting data
Thread-Topic: [PATCH] net: intel: ice: Use uintptr_t for casting data
Thread-Index: AQHWngQkSlu/iO+FDUuuiDnkMIwO46mPeGMA
Date:   Fri, 9 Oct 2020 16:35:35 +0000
Message-ID: <0e4c5d21c237afb5feb297b10d63550a15868ded.camel@intel.com>
References: <20201009061827.1279-1-shipujin.t@gmail.com>
In-Reply-To: <20201009061827.1279-1-shipujin.t@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a482c573-ad9a-4d4e-8934-08d86c7158ef
x-ms-traffictypediagnostic: SA2PR11MB5067:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB5067D16614029E867AADC081C6080@SA2PR11MB5067.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UkkC2JTWbgp0WIdDSJ3SFuXIHLz3Mrn7s7UwjnMbw215p+GW1homdfQgXQdMDLj6rWHYfVrzmw/uSjIFhaFxwQ9c32E+rDte57r1B+4q1iQZkDMjZUM7MnKzhVyvSI7a/dihzLKmlsFflKgNviduZpxra2kTbi5cm3f4X5Cab3TFU4GbhllDZJrgdmpmA5uoy7N0vdSe/Hdm+zbQVm1SVgAd2f+5l327PCWNk1NcU1wUomEsaKDQUsPDA+wa23m3r1D8+fOOO8vAhjA7TY5/oQ8q808G0rGVCuxgoEHcSC8mxU+WgCL2/WX8N0MMj4wl52DHhsfG6VI/3DakTsTVwbytbIHpYik21TJ7W4IthvrHrcDh7xtVpiGKxaOJ64wyOt6OyCtCYFS/6BV3UwFtg4M1+0d8gj1RQUp090lXX2Ctwqop1RwmO9RNXn5T8Hx8YOBz08Dcx736FaXbO5ZdGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(136003)(376002)(396003)(366004)(83380400001)(478600001)(6512007)(8936002)(2906002)(66946007)(8676002)(4326008)(71200400001)(54906003)(91956017)(2616005)(966005)(110136005)(36756003)(5660300002)(83080400001)(6506007)(66476007)(66446008)(186003)(66556008)(76116006)(6486002)(86362001)(316002)(26005)(64756008)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: k8+LB7KoJVxYgz+O5pr8Ir0CENLB9h6UWssOirVBVRrIQ9ruZ/WtcqC+SeHaOkNJn3aljseIbc0AczEnJanRYO+kE+fi2xw/Ol48uAx3VFGGlPe3wUWGiHRFeEitiUu0ypx41aee+PrbrKDHx02TZrlcaenyT12ai4ClNdjYPrmELwZtRRwEf00kPiW9NT2Q0UirI/CS5wYy56F/JUEg4Jw6CpIQeZJr/Hej26pvrObEMPX8fwK7479xm118eTvi5Eqfy82X+76G0enqO5Yo9eNE51+PgZN7y+og3bdVLKO/AT/VBcj8MY2/AX2ldgCcGgTp8IXL1nx0VZm0DAvhxYlGXfQUwp3kgelB5IODiOiFBbgQuZy71aX9u+AIRq61XLgvB+0XdJAUKv5hbF0QqfzrE1vJ5g/jQuHUExnENgIMyNfap9YFji7K5PksXCqnNmuhoQRVpqNZ6rDYaGrUZ7sQDQpX559PGjVfCD+Ekj666BKkAotgUCD+Xb+3g/rk8JSEfMaqTBFlSWYSavrG/KlYdp4MwZLaCvUub+tSUGrn2zZTMshnzdnZmneM4ykTnjQA9QXQCbxWs3/+/WG0cy149lm3oK906cXI//bnRUwLfdxs6gu/ElkT8NbYS64np/oEHm81bOU8yCFY4uh3ug==
Content-Type: text/plain; charset="utf-8"
Content-ID: <232174A861983B4EA397A07FDBFC3185@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a482c573-ad9a-4d4e-8934-08d86c7158ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Oct 2020 16:35:35.0863
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aoeAwYnUJkCIG5upPwPArb+ExTmaiFqhZvYXpscf0OlUqVEtEj5CmQAjR3/XbmPSGeuUkC+iRvVkSZGE0NQeG+g0gMvkDTv0lShVW53voBM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5067
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEwLTA5IGF0IDE0OjE4ICswODAwLCBQdWppbiBTaGkgd3JvdGU6DQo+IEZp
eCB1cCBhIGNvbXBpbGVyIGVycm9yIG9uIDY0Yml0IGFyY2hpdGVjdHVyZXMgd2hlcmUgcG9pbnRl
cnMuDQo+IA0KPiBJbiBmaWxlIGluY2x1ZGVkIGZyb20NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQv
aW50ZWwvaWNlL2ljZV9mbGV4X3BpcGUuYzo2OjA6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2ljZS9pY2VfZmxleF9waXBlLmM6IEluIGZ1bmN0aW9uDQo+ICdpY2VfZnJlZV9mbG93X3By
b2ZzJzoNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9mbG93Lmg6MTk3OjMz
OiB3YXJuaW5nOiBjYXN0IGZyb20NCj4gcG9pbnRlciB0byBpbnRlZ2VyIG9mIGRpZmZlcmVudCBz
aXplIFstV3BvaW50ZXItdG8taW50LWNhc3RdDQo+ICAjZGVmaW5lIElDRV9GTE9XX0VOVFJZX0hO
REwoZSkgKCh1NjQpZSkNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXg0KPiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2ZsZXhfcGlwZS5jOjI4ODI6OTogbm90
ZTogaW4NCj4gZXhwYW5zaW9uIG9mIG1hY3JvICdJQ0VfRkxPV19FTlRSWV9ITkRMJw0KPiAgICAg
ICAgICBJQ0VfRkxPV19FTlRSWV9ITkRMKGUpKTsNCj4gICAgICAgICAgXg0KPiBJbiBmaWxlIGlu
Y2x1ZGVkIGZyb20gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9mbG93LmM6NTow
Og0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2Zsb3cuYzogSW4gZnVuY3Rp
b24NCj4gJ2ljZV9mbG93X2FkZF9lbnRyeSc6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVs
L2ljZS9pY2VfZmxvdy5oOjE5NzozMzogd2FybmluZzogY2FzdCBmcm9tDQo+IHBvaW50ZXIgdG8g
aW50ZWdlciBvZiBkaWZmZXJlbnQgc2l6ZSBbLVdwb2ludGVyLXRvLWludC1jYXN0XQ0KPiAgI2Rl
ZmluZSBJQ0VfRkxPV19FTlRSWV9ITkRMKGUpICgodTY0KWUpDQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIF4NCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9m
bG93LmM6OTQ2OjEzOiBub3RlOiBpbiBleHBhbnNpb24NCj4gb2YgbWFjcm8gJ0lDRV9GTE9XX0VO
VFJZX0hOREwnDQo+ICAgKmVudHJ5X2ggPSBJQ0VfRkxPV19FTlRSWV9ITkRMKGUpOw0KPiAgICAg
ICAgICAgICAgXg0KPiANCj4gMiB3YXJuaW5ncyBnZW5lcmF0ZWQNCj4gDQo+IFNpZ25lZC1vZmYt
Ynk6IFB1amluIFNoaSA8c2hpcHVqaW4udEBnbWFpbC5jb20+DQoNClRoYW5rcyBmb3IgdGhlIHBh
dGNoIFB1amluLCBob3dldmVyLCBCaXh1YW4gQ3VpIGhhcyBhbHJlYWR5IHN1Ym1pdHRlZCBhDQpw
YXRjaCB0byByZXNvbHZlIHRoaXMgaXNzdWUgWzFdLg0KDQpbMV0gDQpodHRwczovL3BhdGNod29y
ay5vemxhYnMub3JnL3Byb2plY3QvaW50ZWwtd2lyZWQtbGFuL3BhdGNoLzg1ZGNlYTQ4LThiODIt
ZDgwNi0wMDI2LWU2YjM3MWU2YTA5MkBodWF3ZWkuY29tLw0KDQpUaGFua3MsDQpUb255DQo=
