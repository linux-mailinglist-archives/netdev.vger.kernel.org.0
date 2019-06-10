Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 460A03BFB8
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 01:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390470AbfFJXKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 19:10:20 -0400
Received: from alln-iport-7.cisco.com ([173.37.142.94]:55029 "EHLO
        alln-iport-7.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390340AbfFJXKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 19:10:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=3810; q=dns/txt; s=iport;
  t=1560208218; x=1561417818;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DZLsbOKAVLjj1Jm2n9ElkNmM8I+9nxbN1p9u6ao0tLY=;
  b=TibBlMU1E5pdnsKB8naiqUUaoVPGn5OagAwt0H81jOXIKvUxCTDh7KXk
   q4Or6qdg1A7wwokVUqGyyH1MU68HCZPZLePM/8vB3utRc0ARlnAIN6dn/
   3voyEcdxwamTL7/ql5t7uEWn20x8WH5t4Ua10WheVkcnaT+vf6wMCLNLj
   c=;
IronPort-PHdr: =?us-ascii?q?9a23=3AR0/77B3vrYCNLJR3smDT+zVfbzU7u7jyIg8e44?=
 =?us-ascii?q?YmjLQLaKm44pD+JxKGt+51ggrPWoPWo7JfhuzavrqoeFRI4I3J8RVgOIdJSw?=
 =?us-ascii?q?dDjMwXmwI6B8vQBlPyNvfmZjYSF8VZX1gj9Ha+YgBY?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A0B1AADx4v5c/4YNJK1mHAEBAQQBAQc?=
 =?us-ascii?q?EAQGBUgYBAQsBgT0pJwOBPyAECyiEFYNHA45fgleDR5NrgS6BJANUCQEBAQw?=
 =?us-ascii?q?BAS0CAQGEQAIXgl0jNQgOAQMBAQQBAQIBBG0cAQuFSgEBAQQSEQQNDAEBNwE?=
 =?us-ascii?q?PAgEIFAEDAgImAgICMBUQAgQOBSKEawMdAQKdZQKBOIhfcX4zgnkBAQWFCRi?=
 =?us-ascii?q?CDwmBDCgBi1wXgUA/g241PoREF4JzgliLWgEKgkOaGWoJAoIPk0IblxuNE5Y?=
 =?us-ascii?q?6AgQCBAUCDgEBBYFQATaBWHAVgyeCDwwXgQIBB4JDilNygSmOWAEB?=
X-IronPort-AV: E=Sophos;i="5.63,577,1557187200"; 
   d="scan'208";a="282294543"
Received: from alln-core-12.cisco.com ([173.36.13.134])
  by alln-iport-7.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 10 Jun 2019 23:10:03 +0000
Received: from XCH-RCD-001.cisco.com (xch-rcd-001.cisco.com [173.37.102.11])
        by alln-core-12.cisco.com (8.15.2/8.15.2) with ESMTPS id x5ANA1FO006508
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Mon, 10 Jun 2019 23:10:02 GMT
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by XCH-RCD-001.cisco.com
 (173.37.102.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 10 Jun
 2019 18:10:01 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xhs-rtp-002.cisco.com
 (64.101.210.229) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 10 Jun
 2019 19:09:59 -0400
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 10 Jun 2019 19:09:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DZLsbOKAVLjj1Jm2n9ElkNmM8I+9nxbN1p9u6ao0tLY=;
 b=OEi109ORUqA+Bn6Y2UTzkRMwAfCLBb/75DnRxZHs8ElEqKBYNiucC2ekD4YUBFcDMR85eaZRf+XggTkmu/fWac0Siuxs5bdiQyCEJQ3XcQ1rEbrXbni04XKz05UswsC3S/4LZuHHfp8PA55/BhMeuuFSC6NFhQENx1UQqqJ0z6U=
Received: from DM6PR11MB3227.namprd11.prod.outlook.com (20.176.120.87) by
 DM6PR11MB2556.namprd11.prod.outlook.com (20.176.99.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Mon, 10 Jun 2019 23:09:59 +0000
Received: from DM6PR11MB3227.namprd11.prod.outlook.com
 ([fe80::14b7:2000:43b3:ebe]) by DM6PR11MB3227.namprd11.prod.outlook.com
 ([fe80::14b7:2000:43b3:ebe%7]) with mapi id 15.20.1965.017; Mon, 10 Jun 2019
 23:09:59 +0000
From:   "Govindarajulu Varadarajan (gvaradar)" <gvaradar@cisco.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "Christian Benvenuti (benve)" <benve@cisco.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net] net: handle 802.1P vlan 0 packets properly
Thread-Topic: [PATCH net] net: handle 802.1P vlan 0 packets properly
Thread-Index: AQHVH9KGjvdN5thDnkGlwxFUVtYzKqaVZygAgAAcuIA=
Date:   Mon, 10 Jun 2019 23:09:58 +0000
Message-ID: <441e5d91c8dd70d533dc6ed7ae0f4a9777360874.camel@cisco.com>
References: <20190610142702.2698-1-gvaradar@cisco.com>
         <20190610.142810.138225058759413106.davem@davemloft.net>
In-Reply-To: <20190610.142810.138225058759413106.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=gvaradar@cisco.com; 
x-originating-ip: [2001:420:282:1330:83d4:ed27:e6fb:d9b2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7af7066a-9eb2-4efa-28de-08d6edf8c286
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:DM6PR11MB2556;
x-ms-traffictypediagnostic: DM6PR11MB2556:
x-microsoft-antispam-prvs: <DM6PR11MB255694109DD48B27964468F7D4130@DM6PR11MB2556.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0064B3273C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(396003)(366004)(39860400002)(376002)(199004)(189003)(4326008)(6916009)(6116002)(2351001)(86362001)(486006)(2616005)(476003)(6436002)(446003)(316002)(54906003)(5660300002)(25786009)(11346002)(5640700003)(68736007)(6512007)(46003)(71200400001)(71190400001)(229853002)(76116006)(53936002)(118296001)(8676002)(305945005)(7736002)(58126008)(73956011)(2906002)(2501003)(6486002)(64756008)(66556008)(36756003)(14454004)(66946007)(66446008)(76176011)(102836004)(66476007)(99286004)(6246003)(81166006)(81156014)(478600001)(91956017)(1730700003)(256004)(186003)(8936002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB2556;H:DM6PR11MB3227.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: cisco.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: yArzn12OYgv5SkUUYUEbQFTwBjS92Ib3v9/vQBld8Y6/XOJ1Osoi5DV33ZjLdWmtHtRwZJm5oc/cFtFPqYVj/iTd7BiwcZAFvxSl7Ps4ruURRrkqdM5ziFqU7eP6lRb7cmk4vR2oas3AtufiPWZKGYFhdqDV900SzW4s+7jvR4N6hK8JgYiBoYjm4znPPnoC9uuNIzm5dTl9qaIHlIz010pc/G7jCMAyZUQ8KTzIkb6nSzPxLqMiMnVAklpOZMS7mcIhdhpNHJb/bikM0YtvjX5ZE+bGLSFbSFvGchwNgMplcZBjvOZJqBbU6bRpjm8pUG1H947AePsAJoHLWwPhaDmhevZX5oDrGkN8InahG4eTcVjaH8j+qlZLbBgxJtWqzRqO/jnwqOFKXHz6Whlva+B0MptmBfbGf6ZRHPFYYvo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FB07B10128639B4F9D04D393747CD3AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7af7066a-9eb2-4efa-28de-08d6edf8c286
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jun 2019 23:09:58.9119
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gvaradar@cisco.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB2556
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.11, xch-rcd-001.cisco.com
X-Outbound-Node: alln-core-12.cisco.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTEwIGF0IDE0OjI4IC0wNzAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IEdvdmluZGFyYWp1bHUgVmFyYWRhcmFqYW4gPGd2YXJhZGFyQGNpc2NvLmNvbT4NCj4g
RGF0ZTogTW9uLCAxMCBKdW4gMjAxOSAwNzoyNzowMiAtMDcwMA0KPiANCj4gPiBXaGVuIHN0YWNr
IHJlY2VpdmVzIHBrdDogWzgwMi4xUCB2bGFuIDBdWzgwMi4xQUQgdmxhbiAxMDBdW0lQdjRdLA0K
PiA+IHZsYW5fZG9fcmVjZWl2ZSgpIHJldHVybnMgZmFsc2UgaWYgaXQgZG9lcyBub3QgZmluZCB2
bGFuX2Rldi4gTGF0ZXINCj4gPiBfX25ldGlmX3JlY2VpdmVfc2tiX2NvcmUoKSBmYWlscyB0byBm
aW5kIHBhY2tldCB0eXBlIGhhbmRsZXIgZm9yDQo+ID4gc2tiLT5wcm90b2NvbCA4MDEuMUFEIGFu
ZCBkcm9wcyB0aGUgcGFja2V0Lg0KPiA+IA0KPiA+IDgwMS4xUCBoZWFkZXIgd2l0aCB2bGFuIGlk
IDAgc2hvdWxkIGJlIGhhbmRsZWQgYXMgdW50YWdnZWQgcGFja2V0cy4NCj4gPiBUaGlzIHBhdGNo
IGZpeGVzIGl0IGJ5IGNoZWNraW5nIGlmIHZsYW5faWQgaXMgMCBhbmQgcHJvY2Vzc2VzIG5leHQg
dmxhbg0KPiA+IGhlYWRlci4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBHb3ZpbmRhcmFqdWx1
IFZhcmFkYXJhamFuIDxndmFyYWRhckBjaXNjby5jb20+DQo+IA0KPiBVbmRlciBMaW51eCB3ZSBh
YnNvbHV0ZWx5IGRvIG5vdCBkZWNhcHN1bGF0ZSB0aGUgVkxBTiBwcm90b2NvbCB1bmxlc3MNCj4g
YSBWTEFOIGRldmljZSBpcyBjb25maWd1cmVkIG9uIHRoYXQgaW50ZXJmYWNlLg0KDQpDYW4geW91
IGNsYXJpZnkgb24gaWYgODAyLjFQIGhlYWRlciAod2l0aCB2bGFuIGlkIDApIG5vdCBzdXBwb3J0
ZWQgd2l0aCBpbm5lcg0KODAyLjFRIG9yIDgwMi4xQUQgaGVhZGVyPw0KDQpXZSBhbHJlYWR5IGRl
Y2Fwc3VsYXRlIHZsYW4gMCBoZWFkZXIgKDgwMi4xUCkgZm9yIGFsbCBvdGhlciBpbm5lciBwcm90
b2NvbHMgaWYNCnZsYW4gMCBkZXZpY2UgaXMgbm90IHByZXNlbnQuDQoNCkZvciBleGFtcGxlOiBw
a3QgLSBbODAyLjFQIHZsYW4gMF1bSVB2NF0NCg0KSW4gX19uZXRpZl9yZWNlaXZlX3NrYl9jb3Jl
KCk6DQoNCglpZiAodmxhbl9kb19yZWNlaXZlKCZza2IpKQ0KCQlnb3RvIGFub3RoZXJfcm91bmQ7
DQoNCnZsYW5fZG9fcmVjZWl2ZSgpIHJldHVybnMgZmFsc2Ugc2luY2UgaXQgZGlkIG5vdCBmaW5k
IFZMQU4gMCBkZXZpY2UuDQoNCkxhdGVyLCB3ZSBkZWNhcHN1bGF0ZSB2bGFuIDAgaGVhZGVyICg4
MDIuMVApIGhlcmU6DQoNCiAgICAgICAgaWYgKHVubGlrZWx5KHNrYl92bGFuX3RhZ19wcmVzZW50
KHNrYikpKSB7DQogICAgICAgICAgICAgICAgaWYgKHNrYl92bGFuX3RhZ19nZXRfaWQoc2tiKSkJ
Ly9GYWxzZSwgYmVjYXVzZSB2bGFuIGlkIGlzIDANCiAgICAgICAgICAgICAgICAgICAgICAgIHNr
Yi0+cGt0X3R5cGUgPSBQQUNLRVRfT1RIRVJIT1NUOw0KICAgICAgICAgICAgICAgIC8qIE5vdGU6
IHdlIG1pZ2h0IGluIHRoZSBmdXR1cmUgdXNlIHByaW8gYml0cw0KICAgICAgICAgICAgICAgICAq
IGFuZCBzZXQgc2tiLT5wcmlvcml0eSBsaWtlIGluIHZsYW5fZG9fcmVjZWl2ZSgpDQogICAgICAg
ICAgICAgICAgICogRm9yIHRoZSB0aW1lIGJlaW5nLCBqdXN0IGlnbm9yZSBQcmlvcml0eSBDb2Rl
IFBvaW50DQogICAgICAgICAgICAgICAgICovDQogICAgICAgICAgICAgICAgX192bGFuX2h3YWNj
ZWxfY2xlYXJfdGFnKHNrYik7DQogICAgICAgIH0NCg0KVGhlbiB3ZSBkZWxpdmVyIHBhY2tldCB0
byBwYWNrZXQgdHlwZSBoYW5kbGVyIChJUHY0KSBoZXJlOg0KDQogICAgICAgIC8qIGRlbGl2ZXIg
b25seSBleGFjdCBtYXRjaCB3aGVuIGluZGljYXRlZCAqLw0KICAgICAgICBpZiAobGlrZWx5KCFk
ZWxpdmVyX2V4YWN0KSkgew0KICAgICAgICAgICAgICAgIGRlbGl2ZXJfcHR5cGVfbGlzdF9za2Io
c2tiLCAmcHRfcHJldiwgb3JpZ19kZXYsIHR5cGUsDQogICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAmcHR5cGVfYmFzZVtudG9ocyh0eXBlKSAmDQogICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBQVFlQRV9IQVNIX01BU0tdKTsNCiAg
ICAgICAgfQ0KDQogICAgICAgIGRlbGl2ZXJfcHR5cGVfbGlzdF9za2Ioc2tiLCAmcHRfcHJldiwg
b3JpZ19kZXYsIHR5cGUsDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgJm9yaWdfZGV2
LT5wdHlwZV9zcGVjaWZpYyk7DQoNClRoaXMgZG9lcyBub3Qgd29yayBpZiBza2ItPnByb3RvY29s
IChpbm5lcikgaXMgODAyLjFRIG9yIDgwMi4xQUQuIFNpbmNlIHRoZXkgZG8NCm5vdCBoYXZlIHBh
Y2tldCB0eXBlIGhhbmRsZXIsIHBrdCBpcyBkcm9wcGVkLg0KDQpEZWZhdWx0IGNvbmZpZ3VyYXRp
b24gb2Ygb3VyIGhhcmR3YXJlIGlzIHRvIHByaW9yaXR5IHRhZyBhbGwgcGFja2V0cy4gSU1PIDgw
Mi4xUA0KaGVhZGVyIHdpdGggKHZsYW4gaWQgMCkgc2hvdWxkIGJlIHRyZWF0ZWQgYXMgcHJpb3Jp
dHkgdGFnZ2VkIHBhY2tldHMsIGFuZCBub3QgYXMNCmEgdmxhbiB0YWdnZWQgcGFja2V0Lg0KDQpB
bHRlcm5hdGl2ZSBpcywgZW5pYyBkcml2ZXIgbm90IHNldHRpbmcgc2tiLT52bGFuX3RjaSBpZiB2
bGFuX2lkIGlzIDAuIElNTyBkcml2ZXINCnNob3VsZCBmb3J3YXJkIHBrdCBhcyBpdCBzZWVzIG9u
IHdpcmUuIEFuZCBzdGFjayBzaG91bGQgaGFuZGxlIHRoZSBoZWFkZXJzDQpwcm9wZXJseS4NCg0K
SXMgdGhlcmUgYW55IG90aGVyIHdheSB0byBzb2x2ZSB0aGUgcHJvYmxlbT8NCg==
