Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1712B1747
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 09:37:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgKMIhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 03:37:18 -0500
Received: from mail-eopbgr1310079.outbound.protection.outlook.com ([40.107.131.79]:24034
        "EHLO APC01-SG2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725866AbgKMIhS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 03:37:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fz6ezEsxUMc7C44oYjhqszn2MSvkkm6wieUALGco5DsxL7976qEUlThL/vyLyjjrRKmZBSWZu++QgmkwS6NupK6AbSuWYaxOOw4UKfR7EJkTuwIhMKq6ZYRGGI/2+jqw9+GBEkje/ysvT2S9BHoa9RCB42gKyghmz685pAgK4mJ49LTiNO24DzGdMARrSWRYHdSlM5AEQx1YRvKYesFBm2kUh7IZVMnjukBrfz380cn13RHVHgdL95JLsYR7mlWALQYdVOiPO+id3PC/TIfHvLDx94c5cLzUo9r5S3ssMRtigDrNAgSGRh1Oo0cSgRg6p3RRdB+r7XaqIrK/oyehGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWTV8dlJrkEVq2oDWDSL+Cpzhddm15jnQ66Ll/BTECc=;
 b=VPfmWt/K4wf9alhNqasG4veRgxPgrOLD6YsbUXKWlFgN9GIDd55VkW+J8JIarcCklyxILa5N57VAHAdK8TnJkKkoJlhvcYEIA3kgFXU0PxWE8Qk3b3l9iqvhlHBFkn/X9HWifYv3QFeCYku5c/hH/k58Nvu9deGSfyHLFOAxtxgv4fA6SPMRYcoFuCH1CQQ6XQFhWoM/WSFyq2RzrSMgoNNwKOgimSE4esLgPWJl6toWawhuFOY1HmnqbNAjJKr+E9oAZi6qImIfm2AdEbMeXJt6Om0Kpy+aJlZqvrYcRPKeQgp41dtmwCqgh11Mpx8R18zKydvpI4V8p7RtJiI9PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=quectel.com; dmarc=pass action=none header.from=quectel.com;
 dkim=pass header.d=quectel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quectel.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YWTV8dlJrkEVq2oDWDSL+Cpzhddm15jnQ66Ll/BTECc=;
 b=WLvD/6CMTc7Kf/eZwRqSbnhDIhRgHvrUTMfb5ASI7JVnLqcyI1nZ+rZasCCyQO/xPpX0Fo7BE4nPYO/wyZJ8Duvc3+30L8uClqSIE7Q4fI2kcKT9eD9BqnJg8QwhYgJW8XdODAPsYMv9xTFKsPUvGWK7P7DLNLiP0Xvol+qt3vY=
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com (2603:1096:202:3e::14)
 by HK0PR06MB3010.apcprd06.prod.outlook.com (2603:1096:203:90::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3541.22; Fri, 13 Nov
 2020 08:37:10 +0000
Received: from HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::94f:c55a:f9c8:22f4]) by HK2PR06MB3507.apcprd06.prod.outlook.com
 ([fe80::94f:c55a:f9c8:22f4%5]) with mapi id 15.20.3541.025; Fri, 13 Nov 2020
 08:37:10 +0000
From:   =?utf-8?B?Q2FybCBZaW4o5q635byg5oiQKQ==?= <carl.yin@quectel.com>
To:     Kristian Evensen <kristian.evensen@gmail.com>,
        Daniele Palmas <dnlplm@gmail.com>
CC:     =?utf-8?B?QmrDuHJuIE1vcms=?= <bjorn@mork.no>,
        Paul Gildea <paul.gildea@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>
Subject: =?utf-8?B?562U5aSNOiBbUEFUQ0ggbmV0LW5leHQgMS8xXSBuZXQ6IHVzYjogcW1pX3d3?=
 =?utf-8?B?YW46IGFkZCBkZWZhdWx0IHJ4X3VyYl9zaXpl?=
Thread-Topic: [PATCH net-next 1/1] net: usb: qmi_wwan: add default rx_urb_size
Thread-Index: AQHWhom0yoQF//qW/E+nUHr9aPCUA6m4izkAgAyrDwCAANxOAIAAB6Uw
Date:   Fri, 13 Nov 2020 08:37:09 +0000
Message-ID: <HK2PR06MB35071489A05CEBF9C5FADD1C86E60@HK2PR06MB3507.apcprd06.prod.outlook.com>
References: <e724ce7621dcb8bd412edb5d30bfb1e8@sslemail.net>
 <CAKfDRXjcOCvfTx0o6Hxdd4ytkNfJuxY97Wk2QnYvUCY8nzT7Sg@mail.gmail.com>
In-Reply-To: <CAKfDRXjcOCvfTx0o6Hxdd4ytkNfJuxY97Wk2QnYvUCY8nzT7Sg@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=quectel.com;
x-originating-ip: [203.93.254.84]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 17baa40b-2c74-40de-05e8-08d887af4fc2
x-ms-traffictypediagnostic: HK0PR06MB3010:
x-microsoft-antispam-prvs: <HK0PR06MB3010E477AE8AA4478E41BDF586E60@HK0PR06MB3010.apcprd06.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9QJSVgGvAkljA9rsSnGykAmeLWgwzoAVcrKE7+ebQ8Z/f4VJEs0ky2Osj07tZWJTKkcb9pk/gsOATjvXKzm01/3TzB06FEOJqOhtqhzg2HlmPOu730YN9HR5+2RcqvWY0YiHm4RuBSDEXf5KaFH/47CYPzGGZgF8hcyjitp8r9hnJXXsaZnCfV2LFLx6lZhK2LmI0U+nsCUVwhaLc4OLZXELKK/jOWZNO0m1Uy8yheC7xJ1kQMlxaS1g28id+C5gSLI8SsT4j9dFa3YNEZgLqHokyAJxEDjAXuuaN1tfOhaVQGB0HRFCsh6L5Z4Ow0ieYrXSEG7dxMaiEsNmn7/eDQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK2PR06MB3507.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(136003)(39860400002)(7696005)(54906003)(66476007)(5660300002)(478600001)(85182001)(9686003)(66946007)(186003)(224303003)(2906002)(55016002)(71200400001)(66556008)(316002)(4326008)(66446008)(64756008)(52536014)(53546011)(83380400001)(6506007)(76116006)(33656002)(26005)(86362001)(110136005)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: /qeEtBtqfNVrfOoC6h28S413Lzrm50Y4MK6q9vzVVmnPl6J7cNI0iIAwk+Kk+/eazQ5KG1XgF/fxwz5gavWJtuunpE4a/vOHI50E1BrBVcTNMfbdm+jFcnmsEscAXSZY4VfEjzbQ/g9S9Ja9MOp36MhKbvpKcuzC0IiGdcVOHeoLEUzAWWdeKJaqojN4XgpCHtBfwRMBImYuUHpUwtRUtFceLA+sNvzlW2pz3rRQ1tDFtb8GoGyo9ZqFW9XAsAIiz5VvXRHp4FkVZzA39654hEs/AGPo5x2a2Z7EZEvGaBtVyd85zwuKwkiRE4JHkQilSCnkdPqCTg4dWVAeCT+Fl77x3RmDHfTxmAMqxIf2lFqQvJq1Pol5fLBBRXpLUaGqOXb90pgfaw7rRzQWbfbFNCHRNY7eJn1tC+/oTvtmhGX9CrH8yVWCu25+s1iczARbuS9w/IRlikr/VQG1rq7bxyvVoGJjzbnNsz5jaqTgzm5SiS2as02QrDG54v20ta5cR5WmLMOjrmpXOiCVsXpxopfle+PbMgVABhHongJ/5xty86AAMWTLwxkZDJYQ36vDAXtlkxwidKB2MZBqbQAlPhQB+kV7WRLOkLp63ABOGzHJaYu59xdV+hALPXi5yFGAUEaksGFvrhoK2kWMIC6ZKb2UAw6MYBAB4jsqbwYVSXYJs2PK9xezHpq0T9fbn3FxvpnmhSntYiXCTZ6a/CgJr26KSN0UdMjZunxd0vEqt2OSAIGsTH+haa57W5il1J05OvwUaJ9ERBXmCTJ1hLOWLBDl6EuTSpTj4/vFI8qka3BxJC2LI3wZjsmP4SMzNqJvBG0elDTltAnCesS+Q93sFT+p8k80lSea3WW5jhFGCAvkLqb8ZpGDqGUxwrz8dfifM1oa6j2+pGmETlzXFxY0tQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: quectel.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK2PR06MB3507.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17baa40b-2c74-40de-05e8-08d887af4fc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Nov 2020 08:37:09.8408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7730d043-e129-480c-b1ba-e5b6a9f476aa
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HY0/75xlfon/NYf/P1VvA2YJ1fIhyKWdImJBMY3GK5Xd4Ss2JjZIy62zYe33tWyPayqcYlXaAP8uM7vChedmqA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0PR06MB3010
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgS3Jpc3RpYW4sDQoJRm9yIG9wZW53cnQgZGV2aWNlLCB0aGUgJyBQZXJmb3JtYW5jZSBib3R0
bGVuZWNrICcgdXN1YWxseSBpcyBOQVQsIG5vdCB1c2JuZXQuDQoJQXMgSSByZW1lbWJlcjogTVQ3
NjIxIGhhdmUgZHVhbCBjb3JlLCBhbmQgc3VwcG9ydCBIYXJkd2FyZSBhY2NlbGVyYXRpb24gb2Yg
J05BVCcuDQoNCglJdCBzZWVtcyByODE1MiBpcyBhIHB1cmUgRXRoZXJuZXQgY2FyZCwgZG9lcyBp
dCBjYW4gdXNlIHRoZSAnIEhhcmR3YXJlIGFjY2VsZXJhdGlvbiAnDQogDQoJQW5kIGRvIHlvdSB1
c2UgJ21wc3RhdCAtUCBBTEwgMicgdG8gbW9uaXRvciBlYWNoIGNvcmUncyBsb2FkaW5nPw0KCUdl
bmVyYWxseSBVU0IgaW50ZXJydXB0IG9jY3VycyBhdCBjcHUwLCBhbmQgdGhlICdOQVQnIGlzIGFs
c28gb24gY3B1MC4NCglZb3UgY2FuIHRyeSB0byB1c2UgImVjaG8gMiA+IC9zeXMvY2xhc3MvbmV0
L3d3YW4wLyAvcXVldWVzL3J4LTAvcnBzX2NwdXMgIiB0byBtb3ZlIE5BVCB0byBjcHUxLg0KDQoJ
WDU1IG1heCBzdXBwb3J0IDMxS0IsIHRoZXJlIGFyZSBiZW5lZml0IGZyb20gMTZLQiAtPiAzMUtC
Lg0KCU1heWJlIHlvdXIgWDU1J3MgRlcgdmVyc2lvbiBpcyBvbGQsIG9ubHkgZ2VuZXJhdGVzIDE2
S0IgZGF0YS4NCglBbmQgVVJCIHNpemUgaXMgMzJLQiwgYnV0IFg1NSBvbmx5IG91dHB1dCAxNktC
LCBzbyBtYXliZSB0aGVyZSBhcmUgbm90IGVub3VnaCBudW1iZXIgb2YgVVJCcz8NCg0KDQpPbiBO
b3ZlbWJlciAxMywgMjAyMCAzOjM3LCBLcmlzdGlhbiBFdmVuc2VuIHdyb3RlOg0KDQo+IEhpIERh
bmllbGUsDQo+IA0KPiBPbiBUaHUsIE5vdiAxMiwgMjAyMCBhdCA3OjI5IFBNIERhbmllbGUgUGFs
bWFzIDxkbmxwbG1AZ21haWwuY29tPiB3cm90ZToNCj4gPiB0aGFua3MgZm9yIHRlc3RpbmcuIFN0
aWxsIHRoaW5raW5nIGl0IGNvdWxkIGJlIGJldHRlciB0byBkaWZmZXJlbnRpYXRlDQo+ID4gYmV0
d2VlbiByYXctaXAgYW5kIHFtYXAsIGJ1dCBub3QgeWV0IGFibGUgdG8gZmluZCB0aGUgdGltZSB0
byBwZXJmb3JtDQo+ID4gc29tZSB0ZXN0cyBvbiBteSBvd24uDQo+IA0KPiBJIGFncmVlIHRoYXQg
c2VwYXJhdGluZyBiZXR3ZWVuIHFtYXAgYW5kIG5vbi1xbWFwIHdvdWxkIGJlIG5pY2UuDQo+IEhv
d2V2ZXIsIHdpdGggbXkgbW9kdWxlcyBJIGhhdmUgbm90IG5vdGljZWQgYW55IGlzc3VlcyB3aGVu
IHVzaW5nIDMyS0IgYXMgdGhlDQo+IFVSQiBzaXplLiBTdGlsbCwgdGhlIHJlc3VsdHMgc2hvdyB0
aGF0IHRoZXJlIGlzIG5vIGdhaW4gaW4gaW5jcmVhc2luZyB0aGUgYWdncmVnYXRpb24NCj4gc2l6
ZSBmcm9tIDE2IHRvIDMyS0IuIENhcHR1cmluZyB0cmFmZmljIGZyb20gdGhlIG1vZGVtIHJldmVh
bHMgdGhhdCB0aGUNCj4gaGFyZHdhcmUgc3RpbGwgb25seSBnZW5lcmF0ZXMgMTZLQiBVUkJzIChl
dmVuIGluIGhpZ2gtc3BlZWQgbmV0d29ya3MpLiBJIGFsc28NCj4gc2VlIHRoYXQgZm9yIGV4YW1w
bGUgdGhlDQo+IHI4MTUyIGRyaXZlciB1c2VzIGEgc3RhdGljIFVSQiBzaXplIG9mIDE2Mzg0Lg0K
PiANCj4gPiBJcyB0aGUgZG9uZ2xlIGRyaXZlciBiYXNlZCBvbiB1c2JuZXQ/IEJlc2lkZXMgdGhl
IGFnZ3JlZ2F0ZWQgZGF0YWdyYW0NCj4gPiBzaXplLCBkaWQgeW91IGFsc28gdHJ5IGRpZmZlcmVu
dCBkYXRhZ3JhbSBtYXggbnVtYmVycz8NCj4gDQo+IFRoZSBkb25nbGUgZHJpdmVyIGlzIG5vdCBi
YXNlZCBvbiB1c2JuZXQsIGl0IGlzIHI4MTUyLiBJIHRyaWVkIHRvIGluY3JlYXNlIHRoZQ0KPiBt
YXhpbXVtIGRhdGFncmFtcyBmcm9tIDMyIHRvIDY0IChhcyB3ZWxsIGFzIHNvbWUgb3RoZXIgdmFs
dWVzKSwgYnV0IGl0IGhhZCBubw0KPiBlZmZlY3Qgb24gdGhlIHBlcmZyb3JtYW5jZS4NCj4gDQo+
ID4gVGhlIG9ubHkgYWR2aWNlIEkgY2FuIGdpdmUgeW91IGlzIHRvIGNoZWNrIGlmIG90aGVyIGRy
aXZlcnMgYXJlDQo+ID4gcGVyZm9ybWluZyBiZXR0ZXIsIGUuZy4gZGlkIHlvdSB0cnkgdGhlIE1C
SU0gY29tcG9zaXRpb24/IG5vdCBzdXJlIGl0DQo+ID4gd2lsbCBtYWtlIG11Y2ggZGlmZmVyZW5j
ZSwgc2luY2UgaXQncyBiYXNlZCBvbiB1c2JuZXQsIGJ1dCBjb3VsZCBiZQ0KPiA+IHdvcnRoIHRy
eWluZy4NCj4gDQo+IEkgdHJpZWQgdG8gdXNlIE1CSU0sIGJ1dCB0aGUgcGVyZm9ybWFuY2Ugd2Fz
IHRoZSBzYW1lIGFzIHdpdGggUU1JLiBJIHdpbGwgdGFrZSBhDQo+IGxvb2sgYXQgcjgxNTIgYW5k
IGV4cGVyaW1lbnQgd2l0aCBpbXBsZW1lbnRpbmcgc29tZSBvZiB0aGUgZGlmZmVyZW5jZXMgaW4N
Cj4gdXNibmV0L3FtaV93d2FuLiBJIHNlZSBmb3IgZXhhbXBsZSB0aGF0IHI4MTUyIHVzZXMgTkFQ
SSwgd2hpY2ggd2hpbGUgbm90IGENCj4gcGVyZmVjdCBmaXQgZm9yIFVTQiBjb3VsZCBiZSB3b3J0
aCBhIHRyeS4NCj4gQmFzZWQgb24gc29tZSBkaXNjdXNzaW9ucyBJIGZvdW5kIG9uIHRoZSBtYWls
aW5nIGxpc3QgZnJvbSAyMDExLCBpbXBsZW1lbnRpbmcNCj4gTkFQSSBpbiB1c2JuZXQgY291bGQg
YmUgd29ydGh3aGlsZS4NCj4gDQo+IFRoYW5rcyBmb3IgdGhlIHJlcGx5IQ0KPiANCj4gQlIsDQo+
IEtyaXN0aWFuDQo=
