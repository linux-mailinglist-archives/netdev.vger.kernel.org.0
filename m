Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0DB025A275
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 02:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726312AbgIBAwf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 20:52:35 -0400
Received: from mga04.intel.com ([192.55.52.120]:4208 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgIBAwe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 20:52:34 -0400
IronPort-SDR: kTmXBF3BEoadklpK5VqWp0bk/GOZ5tSfGut4dGElNnGQqf9456PUwisda+bnhggGJlrUNNWufW
 IWcVObQ1Hbdg==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="154696254"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="154696254"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2020 17:52:28 -0700
IronPort-SDR: RSOU/dw0QqA1VTa+w2Z7KuPxsLNNXEY5frGETkWrV3o1Csy3ih4mH+tI35D8dgBEJUvnOcR8Im
 vWgKGo433PUA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="283565384"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga008.fm.intel.com with ESMTP; 01 Sep 2020 17:52:28 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Sep 2020 17:52:27 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Sep 2020 17:52:13 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Sep 2020 17:52:13 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 1 Sep 2020 17:52:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ax91XkS5G+PxQJ2G+aflbrUEU20nOzlsMe7cT7HVH2YgDzTa1N572EEwJEQmlL29QxS3JCC5SYbtGlBB6hyYyLA5Mbvtw5xSf5iGGENSkv99wrLqrMU9CKpRwZgAaSwXvt6wHDTBHRHuDE5jfz8kFbm82Go6m0rHZHv1eQJzTfWHF7CaQKZK7STFVr8BlGxAepzsOdzGObYjwsIDTmcLDq0ycoCNBFdUNWoupFP73cUay4b9cJxF3Ab1wp5orR0Y2+WZUU92Tc5lchgjLJeFB/bNiPqhj96eqLUFaLYioVHN4pYyQb0mKlYCmqZXKLSDWyJdqItDAePaYwmn2cTdAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFrx5oFipYT+9QNIoPEtmrK5HLBJMEKkVvx7y3oD5BM=;
 b=LdX/N40LTkHYBhzpgeso8WNZAisujGaxPBz6330DfGHbXRegrYGyHG1ezGgP9mEmnrdAtbzQU3tjEym3Uf9LiqK5HjJy7MqYnkvU1x0r7G0ZCmzJjrfqaYZMlNiNipq7ZUqtf3MSb2tYsKZZKAqMQABIfPLZrOo7aNLMsvH9+H7V7b8fDuB9f/ao9hQ+IbGc4HEuTQQoveoiTZKhP8HUXAeisellmkFnQHx1wQKL3YbwK4PmjN4uvBfp2BAhNGgUw9pa8w+uTmJZtdzbae4Za3NaRyHvZkH8J6SB+A68QL3olkQ058arBkup35BSdUEnWyFaBq8WaPjIjVbPHmZIPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mFrx5oFipYT+9QNIoPEtmrK5HLBJMEKkVvx7y3oD5BM=;
 b=Fvvipn05SpkGWNu35AU81YMrlp6JYT6mj6Sa+/ZsOg10fTacYkx0RNkAHPQqVSQY28SbDdPj9ja2Ym9JMkxSdEZ/XzZUj5Zl7dxaUF7VKVXosJc0TRhswuhsqYI2M5NJoQ/yz7byG9/w7YuR5oIv64DFwAzkp3qHT9k64cbUY4g=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4746.namprd11.prod.outlook.com (2603:10b6:303:5f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.19; Wed, 2 Sep
 2020 00:52:10 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::a43e:b4a1:3c31:aecd%9]) with mapi id 15.20.3326.025; Wed, 2 Sep 2020
 00:52:10 +0000
From:   "Ramamurthy, Harshitha" <harshitha.ramamurthy@intel.com>
To:     David Ahern <dsahern@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Duyck, Alexander H" <alexander.h.duyck@intel.com>,
        "Herbert, Tom" <tom.herbert@intel.com>
Subject: RE: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
Thread-Topic: [PATCH bpf-next] bpf: add bpf_get_xdp_hash helper function
Thread-Index: AQHWf8zo5S5nD8q420OtCeyQ23Z/hqlSoWiAgAHi1PA=
Date:   Wed, 2 Sep 2020 00:52:09 +0000
Message-ID: <MW3PR11MB45220F94F1E303CEC0F6C19C852F0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200831192506.28896-1-harshitha.ramamurthy@intel.com>
 <04856bca-0952-4dd7-3313-a13be6b2e95a@gmail.com>
In-Reply-To: <04856bca-0952-4dd7-3313-a13be6b2e95a@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYzVmMTJkYzgtM2MyMC00N2JhLWIyZTctZDk4MDQ1NzdjNmYwIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoieTJOR3U2WEZoMHVQcEJrTVJZaEFsMW5xXC9nbVZMY1I4d0FzR3FvOWJQZW5nNWxVNlVnM3prT2RXcThcL0NFK0M0In0=
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-ctpclassification: CTP_NT
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [71.63.191.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 675faf31-beec-4f9a-e2e6-08d84eda6c61
x-ms-traffictypediagnostic: MW3PR11MB4746:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4746AF43795B80E40D09A4B2852F0@MW3PR11MB4746.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1KWelUmGCXtH+39F2tC5QrA3RoqOMP/i7x6gvBrkBJCdFA0NQHLhA/lZzYh8Og8H3+Ly3FGUzvfJNFnzTF1Vrv/n9P+0vwo9MptzGzqFWa77CHlE9w08rEzzRTiX4zyPmEmeW2pgetXY1xJzdPhClPppfe+lasAbJgpjd10bAWVPIzOWWoTahw8uQbf3qfYQLIiHkAZbJWR7+3ij6CNdtI5zmZKTsUw9V65OghMcrJxire0DTrH3OZVyF19gXun4xiVQt3V+3M9btY43tsuxyZzpiYr4f7gqoGu4o/5Gc1a9j1LtVRjeNkQduCMv3PvK4jHLfGKQz9kt+UuM0T7Wig==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(136003)(376002)(366004)(396003)(346002)(66446008)(26005)(107886003)(33656002)(6506007)(66946007)(186003)(83380400001)(64756008)(66556008)(53546011)(76116006)(86362001)(55016002)(4326008)(66476007)(5660300002)(478600001)(8676002)(7696005)(52536014)(2906002)(110136005)(54906003)(316002)(71200400001)(9686003)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: npFntKnvTG6qPFWiky3Z5fcwsJq41jIDy26Iwm9PHq5DxfIkMnbpdcdXJour84CHuACMOEAJ0R9K4UoeMJJIky4bSSXpvOM53bW7GvWy0q7J2hl0ctQ+z2ZwcKvG/8elsBmVXSVwwX0JLIBOvna8CuUvUiTJlujqFxyy28J0I95muTLVs5azOySYBlw6DkOZIOuMrgOAxCNiO4lwqA+LyWO+xbu0EXRv7BlSAejb+MaIOUgbryM1D0iycAboP2CBhTQCf+SMQ0b8JblobKyPCe6XXBcbccYXEe4v+Uik9j3BQsMcqkVxtsmPtnzfgCZ7hzzQDbhEi8UE7NOClvzfWRle12/Jxjbyg9Oua+L/3dBRzayEcilDvlupQr/AcGxA0ObkUKG+heOGEIN9YWBaESxad3Ahuz+eLF/Mp9FNttV/kzvRHYIYd9gwYiaLB8YfzAYfiga2AEJsK9Nrk1VrLfVPW4hrgIv7BGOhoZ1+iVvGTiyjb3ADOvIf0yv303Nq6J2vUgCcsHDrn6DKO6C2PpYWsEILbDNkePMJ8DWDjkSGyT1/lUUE5ibIyC51Z/+H4B1zIMbXrbzTkj2kbRIUxG5rWExcfElbuzP6xYAX6mJbfxWWcu2OT2SzWXBPn3Mq8BSJ+0KxQWbtuwlO/gnWhw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675faf31-beec-4f9a-e2e6-08d84eda6c61
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 00:52:09.9792
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: XpizdaPuhKBCRp6Dq9xMW9U5AIrUhpbPnJnMFpNIDtZi3fwNMFL6eDU4BVU/1QjUmUv9i5bWOud4H6Zwa7P4/n8JXsfHYLWatTVVUbJtELg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4746
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBicGYtb3duZXJAdmdlci5rZXJuZWwub3JnIDxicGYtb3duZXJAdmdlci5rZXJuZWwu
b3JnPiBPbiBCZWhhbGYNCj4gT2YgRGF2aWQgQWhlcm4NCj4gU2VudDogTW9uZGF5LCBBdWd1c3Qg
MzEsIDIwMjAgMTI6NTQgUE0NCj4gVG86IFJhbWFtdXJ0aHksIEhhcnNoaXRoYSA8aGFyc2hpdGhh
LnJhbWFtdXJ0aHlAaW50ZWwuY29tPjsNCj4gYnBmQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZn
ZXIua2VybmVsLm9yZzsgYXN0QGtlcm5lbC5vcmc7DQo+IGRhbmllbEBpb2dlYXJib3gubmV0OyBk
YXZlbUBkYXZlbWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmcNCj4gQ2M6IER1eWNrLCBBbGV4YW5k
ZXIgSCA8YWxleGFuZGVyLmguZHV5Y2tAaW50ZWwuY29tPjsgSGVyYmVydCwgVG9tDQo+IDx0b20u
aGVyYmVydEBpbnRlbC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggYnBmLW5leHRdIGJwZjog
YWRkIGJwZl9nZXRfeGRwX2hhc2ggaGVscGVyIGZ1bmN0aW9uDQo+IA0KPiBPbiA4LzMxLzIwIDE6
MjUgUE0sIEhhcnNoaXRoYSBSYW1hbXVydGh5IHdyb3RlOg0KPiA+IGRpZmYgLS1naXQgYS9pbmNs
dWRlL3VhcGkvbGludXgvYnBmLmggYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmggaW5kZXgNCj4g
PiBhNjEzNzUwZDU1MTUuLmJmZmU5M2I1MjZlNyAxMDA2NDQNCj4gPiAtLS0gYS9pbmNsdWRlL3Vh
cGkvbGludXgvYnBmLmgNCj4gPiArKysgYi9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gPiBA
QCAtMzU3Niw2ICszNTc2LDE0IEBAIHVuaW9uIGJwZl9hdHRyIHsNCj4gPiAgICogCQl0aGUgZGF0
YSBpbiAqZHN0Ki4gVGhpcyBpcyBhIHdyYXBwZXIgb2YgY29weV9mcm9tX3VzZXIoKS4NCj4gPiAg
ICogCVJldHVybg0KPiA+ICAgKiAJCTAgb24gc3VjY2Vzcywgb3IgYSBuZWdhdGl2ZSBlcnJvciBp
biBjYXNlIG9mIGZhaWx1cmUuDQo+ID4gKyAqDQo+ID4gKyAqIHUzMiBicGZfZ2V0X3hkcF9oYXNo
KHN0cnVjdCB4ZHBfYnVmZiAqeGRwX21kKQ0KPiANCj4gSSB0aG91Z2h0IHRoZXJlIHdhcyBhIGNo
YW5nZSByZWNlbnRseSBtYWtpbmcgdGhlIHVhcGkgcmVmZXJlbmNlIHhkcF9tZDsNCj4geGRwX2J1
ZmYgaXMgbm90IGV4cG9ydGVkIGFzIHBhcnQgb2YgdGhlIHVhcGkuDQoNCk5vdCBzdXJlIHdoYXQg
eW91IG1lYW4gLSBvdGhlciB4ZHAgcmVsYXRlZCBoZWxwZXIgZnVuY3Rpb25zIHN0aWxsIHVzZSB4
ZHBfYnVmZiBhcyBhbiBhcmd1bWVudC4gQ291bGQgeW91IHBvaW50IG1lIHRvIGFuIGV4YW1wbGUg
b2Ygd2hhdCB5b3UgYXJlIHJlZmVycmluZyB0bz8NCg0KPiANCj4gDQo+ID4gKyAqCURlc2NyaXB0
aW9uDQo+ID4gKyAqCQlSZXR1cm4gdGhlIGhhc2ggZm9yIHRoZSB4ZHAgY29udGV4dCBwYXNzZWQu
IFRoaXMgZnVuY3Rpb24NCj4gPiArICoJCWNhbGxzIHNrYl9mbG93X2Rpc3NlY3QgaW4gbm9uLXNr
YiBtb2RlIHRvIGNhbGN1bGF0ZSB0aGUNCj4gPiArICoJCWhhc2ggZm9yIHRoZSBwYWNrZXQuDQo+
ID4gKyAqCVJldHVybg0KPiA+ICsgKgkJVGhlIDMyLWJpdCBoYXNoLg0KPiA+ICAgKi8NCj4gPiAg
I2RlZmluZSBfX0JQRl9GVU5DX01BUFBFUihGTikJCVwNCj4gPiAgCUZOKHVuc3BlYyksCQkJXA0K
PiA+IEBAIC0zNzI3LDYgKzM3MzUsNyBAQCB1bmlvbiBicGZfYXR0ciB7DQo+ID4gIAlGTihpbm9k
ZV9zdG9yYWdlX2RlbGV0ZSksCVwNCj4gPiAgCUZOKGRfcGF0aCksCQkJXA0KPiA+ICAJRk4oY29w
eV9mcm9tX3VzZXIpLAkJXA0KPiA+ICsJRk4oZ2V0X3hkcF9oYXNoKSwJCVwNCj4gPiAgCS8qICov
DQo+ID4NCj4gPiAgLyogaW50ZWdlciB2YWx1ZSBpbiAnaW1tJyBmaWVsZCBvZiBCUEZfQ0FMTCBp
bnN0cnVjdGlvbiBzZWxlY3RzIHdoaWNoDQo+ID4gaGVscGVyIGRpZmYgLS1naXQgYS9uZXQvY29y
ZS9maWx0ZXIuYyBiL25ldC9jb3JlL2ZpbHRlci5jIGluZGV4DQo+ID4gNDdlZWY5YTBiZTZhLi5j
ZmI1YTZhZWE2YzMgMTAwNjQ0DQo+ID4gLS0tIGEvbmV0L2NvcmUvZmlsdGVyLmMNCj4gPiArKysg
Yi9uZXQvY29yZS9maWx0ZXIuYw0KPiA+IEBAIC0zNzY1LDYgKzM3NjUsMzMgQEAgc3RhdGljIGNv
bnN0IHN0cnVjdCBicGZfZnVuY19wcm90bw0KPiBicGZfeGRwX3JlZGlyZWN0X21hcF9wcm90byA9
IHsNCj4gPiAgCS5hcmczX3R5cGUgICAgICA9IEFSR19BTllUSElORywNCj4gPiAgfTsNCj4gPg0K
PiA+ICtCUEZfQ0FMTF8xKGJwZl9nZXRfeGRwX2hhc2gsIHN0cnVjdCB4ZHBfYnVmZiAqLCB4ZHAp
IHsNCj4gPiArCXZvaWQgKmRhdGFfZW5kID0geGRwLT5kYXRhX2VuZDsNCj4gPiArCXN0cnVjdCBl
dGhoZHIgKmV0aCA9IHhkcC0+ZGF0YTsNCj4gPiArCXZvaWQgKmRhdGEgPSB4ZHAtPmRhdGE7DQo+
ID4gKwlzdHJ1Y3QgZmxvd19rZXlzIGtleXM7DQo+ID4gKwl1MzIgcmV0ID0gMDsNCj4gPiArCWlu
dCBsZW47DQo+ID4gKw0KPiA+ICsJbGVuID0gZGF0YV9lbmQgLSBkYXRhOw0KPiA+ICsJaWYgKGxl
biA8PSAwKQ0KPiA+ICsJCXJldHVybiByZXQ7DQo+IA0KPiB5b3Ugc2hvdWxkIHZlcmlmeSBsZW4g
Y292ZXJzIHRoZSBldGhlcm5ldCBoZWFkZXIuIExvb2tpbmcgYXQNCj4gX19za2JfZmxvd19kaXNz
ZWN0IHVzZSBvZiBobGVuIHByZXN1bWVzIGl0IGV4aXN0cy4NCg0KWWVzLCAgSSB3aWxsIG1ha2Ug
c3VyZSB0byByZXR1cm4gaWYgbGVuIDwgc2l6ZW9mKHN0cnVjdCBldGhoZHIpDQoNCj4gDQo+ID4g
KwltZW1zZXQoJmtleXMsIDAsIHNpemVvZihrZXlzKSk7DQo+ID4gKwlfX3NrYl9mbG93X2Rpc3Nl
Y3QoZGV2X25ldCh4ZHAtPnJ4cS0+ZGV2KSwgTlVMTCwNCj4gJmZsb3dfa2V5c19kaXNzZWN0b3Is
DQo+ID4gKwkJCSAgICZrZXlzLCBkYXRhLCBldGgtPmhfcHJvdG8sIHNpemVvZigqZXRoKSwgbGVu
LA0KPiA+ICsJCQkgICBGTE9XX0RJU1NFQ1RPUl9GX1NUT1BfQVRfRkxPV19MQUJFTCk7DQo+IA0K
PiBCeSBTVE9QX0FUX0ZMT1dfTEFCRUwgSSB0YWtlIGl0IHlvdSB3YW50IHRoaXMgdG8gYmUgYW4g
TDMgaGFzaC4gV2h5IG5vdA0KPiBhZGQgYSBmbGFncyBhcmd1bWVudCB0byB0aGUgaGVscGVyIGFu
ZCBsZXQgdGhlIGhhc2ggYmUgTDMgb3IgTDQ/DQoNCkkgd3JvdGUgdGhpcyBleGFjdGx5IGhvdyBz
a2JfZ2V0X2hhc2ggY2FsbHMgc2tiX2Zsb3dfZGlzc2VjdCAtIHdpdGggdGhlIHNhbWUgZmxhZyBT
VE9QX0FUX0ZMT1dfTEFCRUwuICBTbyBpdCBzaG91bGQgYWxyZWFkeSBjb3ZlciBMMyBhbmQgTDQg
aGFzaCwgcmlnaHQ/IEZyb20gd2hhdCBJIHVuZGVyc3RhbmQgU1RPUF9BVF9GTE9XX0xBQkVMIGZs
YWcgaXMgdXNlZCB0byBvbmx5IHN0b3AgcGFyc2luZyB3aGVuIGEgZmxvdyBsYWJlbCBpcyBzZWVu
IGluIGlwdjYgcGFja2V0cy4gDQoNCj4gDQo+IA0KPiB5b3Ugc2hvdWxkIGFkZCB0ZXN0IGNhc2Vz
IGFuZCBoYXZlIHRoZW0gY292ZXIgdGhlIHBlcm11dGF0aW9ucyAtIGUuZy4sIHZsYW4sDQo+IFEt
aW4tUSwgaXB2NCwgaXB2Niwgbm9uLUlQIHBhY2tldCBmb3IgTDMgaGFzaCBhbmQgdGhlbiB1ZHAs
IHRjcCBmb3IgTDQgaGFzaC4NCg0KU3VyZSwgSSB3aWxsIGFkZCB0ZXN0IGNhc2VzIHVzaW5nIHRo
aXMgaGVscGVyIGZ1bmN0aW9uLg0KDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjayENCkhhcnNoaXRo
YQ0KDQo=
