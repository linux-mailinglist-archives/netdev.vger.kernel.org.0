Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 384FC22F88D
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 20:57:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727871AbgG0S51 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 14:57:27 -0400
Received: from mail-eopbgr1300114.outbound.protection.outlook.com ([40.107.130.114]:16312
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727783AbgG0S50 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jul 2020 14:57:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BQkmsOH1aeqgNCF0oLtBp/PJaLCYvQVCMrvra2s/wYiNGqiCo2X9IyibzTpPYHVKtoWJ8c0rikP0/n8Sc/w+1FxA1s7HTrl1n14Tgv97wynadEWxz56H1/18pOIFYXMh1g31RlDdaK1yzAn1831rZmMQp/zgEV68C4rvLl192GU4IKwN9AEzyz60oBq3L/ezb1MS2pzI9/f27qo6nGg37bcQnV0HnPI2TGUk3yiUGq3W5rEduel/9oQbIBs64Jr4aUcSD/hY82tC8M3ZB8QydeYC/xOyqIFH/4z8dBBnWpZiFlXCoS28sBu7FFuOne6dLxAyGcm+cDsNak6nmNStXg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Idy8DmPEkFed9mW9j8b2KFNswr3xZPu7CwDH12SRd4=;
 b=Qn2FhPODkP1J6jjVwPk4aTUOuKFMye2/xJ9GREWx43U9b7v8gx7F6GL2JRkqzPZOrVIutT/rkhNA7IEJSoYYEL6uOmDbCxpVDRFD3UEn6C9hD9BLKq4vrniCyW7eZP1zsTEm3uqs01TA7yOQTXH8pP+AesethOQjvPy89e8eWPbP0mmCq6ICt7lBQWcp/AiDqQcYA1/5VqQpvkS75TgtNoVNucSypPM7hQNfQuSCoI8QOp/6G69Ms5mqwjgyLUhiO4Fy9FQ8IsiW5twuAC+qSimCAdxW1QwytmzqmBP+vP5O3icYu0n+wObL/72X3s3NGG5lGEJ8Ng7XGgJGy/YFVg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6Idy8DmPEkFed9mW9j8b2KFNswr3xZPu7CwDH12SRd4=;
 b=hp4/9xFzWp7zB0aqkxKMCLjlvInJtJAvXdkie+TpgGTcBozkqQvek5mV0yTzaystkxMPQXcAlxk1BpMftYdYKU5xm/x7RsYVfzGARcYRiggjiGfvHNzP4PYUPMon+1AefWeovy6GKZFsI/CyN7ihPk0EikY7bb3UEaZW2y67OOE=
Received: from KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM (2603:1096:820:10::19)
 by KU1P153MB0134.APCP153.PROD.OUTLOOK.COM (2603:1096:802:1a::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.1; Mon, 27 Jul
 2020 18:57:17 +0000
Received: from KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
 ([fe80::819:688c:f8fe:114d]) by KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
 ([fe80::819:688c:f8fe:114d%9]) with mapi id 15.20.3239.015; Mon, 27 Jul 2020
 18:57:17 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Eric Dumazet <edumazet@google.com>
CC:     Greg KH <greg@kroah.com>, Al Viro <viro@zeniv.linux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>,
        Joseph Salisbury <Joseph.Salisbury@microsoft.com>,
        Michael Kelley <mikelley@microsoft.com>
Subject: RE: UDP data corruption in v4.4
Thread-Topic: UDP data corruption in v4.4
Thread-Index: AdZiJnBIPDXmVtR1R7+R+22vR2xKPAAIjTAAAH8LFZAAACSNAAAAZz+Q
Date:   Mon, 27 Jul 2020 18:57:17 +0000
Message-ID: <KL1P15301MB0280926949A1180B671CA516BF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
References: <KL1P15301MB028018F5C84C618BF7628045BF740@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
 <20200725055840.GD1047853@kroah.com>
 <KL1P15301MB02800FAB6F40F03FD4349E0ABF720@KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM>
 <CANn89i+JPamwsU-22oBTU-8HC+e6oxtQU+QgiO=-S1ZmrkGvtg@mail.gmail.com>
In-Reply-To: <CANn89i+JPamwsU-22oBTU-8HC+e6oxtQU+QgiO=-S1ZmrkGvtg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-07-27T18:57:14Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=b2fc323c-13c8-410f-8f9f-8c716ca17a6a;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0
authentication-results: google.com; dkim=none (message not signed)
 header.d=none;google.com; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:9dd4:7c1:bb91:342a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d9740b98-40f5-496a-cfef-08d8325ee261
x-ms-traffictypediagnostic: KU1P153MB0134:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <KU1P153MB0134AE98568D19C9192301FCBF720@KU1P153MB0134.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: acXXR5Vtk936ytRNPJyNqqwoylWATGlqbH5UCYWlQuMV1tWXZlW8hmaK+NeF5i69WWJni2aMCQB9cQwY9uJYeCtmBNjPukGoF/1d6fza7ful7TOM2Mgz0BWl010pxcPfbhFpj1Wek/kkfvHru7Uv7Oh0oRuJ9mLUmkS2GSZqSuwHtGL7Gdm5U9n1cQXine9X+pYBn82QLEKYRp555Q0WfPGYW/uQ37zOf9/3gzTGnL0ADtpVZcIUHNcD6yTblNPZ3SkI7AL/a74cqz3Pb9jNoHPdOykhjD3jG8mP07Mh0hds589L7Ot8j8PG9lyVjnZ049YDviyvWx/ejI/00ZIyuw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39860400002)(136003)(376002)(346002)(396003)(366004)(107886003)(6916009)(53546011)(10290500003)(6506007)(33656002)(4326008)(8990500004)(83380400001)(9686003)(66446008)(64756008)(66476007)(55016002)(66556008)(7696005)(76116006)(66946007)(8676002)(71200400001)(2906002)(82950400001)(82960400001)(54906003)(478600001)(5660300002)(186003)(86362001)(52536014)(316002)(8936002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: 4jnm4Xlz3DWBD4mSlLfDslYVBa+SVfRGBd8TzpiNUHdO9tvWi69J1KcrHQJwdq8S33SY4DDZuQA6YcsZpdaJyG8iJs2QXBe4F8uGysN6CR3yOs5vyPNdktI2F5VDGPUjwa5nLZiKgyCZzI/q+ZfE0dIRehTzuFcddfrIcWtMjJVXZ+kmSYacTntqRlHJcu1DfMrIPY8Y8hYqrsd9m5h5ayhZngmZthgklzqErjlltzzrHKBkkntnUGOJaOPmIvaPlBMjdVp0NWCs6opw6yFQ3BMkyVHqikIoM+rteuM9NBZHloVNh1qEBatIvKfqwTAKGq8RwnbZIOElZClqYJ/cdZ2jr4FGTV64bRpNHw1P5mWcNVLrGhL3XewdQoDRJlst3RYD9zgtKzbg3ylNttP6NWMkpqWH9bmWA/CpaQQGxL7HnKgWs1JKRxsxLpqeFLoTPbHxaRl+Q1XV5Q45YAyjoWw0XMIZYG3BTS1/WDtmEgxDziHo8gV18cJPTWDLKIdZUDpscgpvHd2cBdjXrc/AqBmQ1mqzSdyRw9I0VvGw6wNhIHittdDj8GHZMlqFAVRcK14YqhKmJTbl2jEmF8E5gw7LEZ9rR1nO4t39EzXoua3zZs7Q9HwC3Rsld0LU/V+VZ0mwG6GNeoe6yUBu64VfBOuQpLtsgAuu2L/+vZGqaXsLugLhf6QHncymNYiVKFEtbEvNuJ2sovASOMptwSbFEg==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: KL1P15301MB0280.APCP153.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d9740b98-40f5-496a-cfef-08d8325ee261
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2020 18:57:17.4703
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UgaCX5KuyqJyqCtdN/fDwXBoZjXIv7wiF6AQLeQdtVkC6Q3HDMgTL1kZmnv6Vcw7IGbNSgfiOB0dMPCUBmSbIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: KU1P153MB0134
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+DQo+IFNlbnQ6IE1vbmRh
eSwgSnVseSAyNywgMjAyMCAxMTo0MCBBTQ0KPiBUbzogRGV4dWFuIEN1aSA8ZGVjdWlAbWljcm9z
b2Z0LmNvbT4NCj4gDQo+IE9uIE1vbiwgSnVsIDI3LCAyMDIwIGF0IDExOjM4IEFNIERleHVhbiBD
dWkgPGRlY3VpQG1pY3Jvc29mdC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiBGcm9tOiBHcmVnIEtI
IDxncmVnQGtyb2FoLmNvbT4NCj4gPiA+IFNlbnQ6IEZyaWRheSwgSnVseSAyNCwgMjAyMCAxMDo1
OSBQTQ0KPiA+ID4gPiBbLi4uXQ0KPiA+ID4gPiBFcmljIER1bWF6ZXQgbWFkZSBhbiBhbHRlcm5h
dGl2ZSB0aGF0IHBlcmZvcm1zIHRoZSBjc3VtIHZhbGlkYXRpb24NCj4gZWFybGllcjoNCj4gPiA+
ID4NCj4gPiA+ID4gLS0tIGEvbmV0L2lwdjQvdWRwLmMNCj4gPiA+ID4gKysrIGIvbmV0L2lwdjQv
dWRwLmMNCj4gPiA+ID4gQEAgLTE1ODksOCArMTU4OSw3IEBAIGludCB1ZHBfcXVldWVfcmN2X3Nr
YihzdHJ1Y3Qgc29jayAqc2ssIHN0cnVjdA0KPiA+ID4gPiBza19idWZmICpza2IpDQo+ID4gPiA+
ICAgICAgICAgICAgICAgICB9DQo+ID4gPiA+ICAgICAgICAgfQ0KPiA+ID4gPg0KPiA+ID4gPiAt
ICAgICAgIGlmIChyY3VfYWNjZXNzX3BvaW50ZXIoc2stPnNrX2ZpbHRlcikgJiYNCj4gPiA+ID4g
LSAgICAgICAgICAgdWRwX2xpYl9jaGVja3N1bV9jb21wbGV0ZShza2IpKQ0KPiA+ID4gPiArICAg
ICAgIGlmICh1ZHBfbGliX2NoZWNrc3VtX2NvbXBsZXRlKHNrYikpDQo+ID4gPiA+ICAgICAgICAg
ICAgICAgICBnb3RvIGNzdW1fZXJyb3I7DQo+ID4gPiA+DQo+ID4gPiA+ICAgICAgICAgaWYgKHNr
X3JjdnF1ZXVlc19mdWxsKHNrLCBzay0+c2tfcmN2YnVmKSkgew0KPiA+ID4gPg0KPiA+ID4gPiBJ
IHBlcnNvbmFsbHkgbGlrZSBFcmljJ3MgZml4IGFuZCBJTUhPIHdlJ2QgYmV0dGVyIGhhdmUgaXQg
aW4gdjQuNCByYXRoZXIgdGhhbg0KPiA+ID4gPiB0cnlpbmcgdG8gYmFja3BvcnQgMzI3ODY4MjEy
MzgxLg0KPiA+ID4NCj4gPiA+IERvZXMgRXJpYydzIGZpeCB3b3JrIHdpdGggeW91ciB0ZXN0aW5n
Pw0KPiA+DQo+ID4gWWVzLCBpdCB3b3JrZWQgaW4gbXkgdGVzdGluZyBvdmVybmlnaHQuDQo+ID4N
Cj4gPiA+IElmIHNvLCBncmVhdCwgY2FuIHlvdSB0dXJuIGl0DQo+ID4gPiBpbnRvIHNvbWV0aGlu
ZyBJIGNhbiBhcHBseSB0byB0aGUgNC40Lnkgc3RhYmxlIHRyZWUgYW5kIHNlbmQgaXQgdG8NCj4g
PiA+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc/DQo+ID4gPg0KPiA+ID4gZ3JlZyBrLWgNCj4gPg0K
PiA+IFdpbGwgZG8gc2hvcnRseS4NCj4gPg0KPiANCj4gSnVzdCBhcyBhIHJlbWluZGVyLCBwbGVh
c2UgYWxzbyBhZGQgdGhlIElQdjYgcGFydC4NCj4gDQo+IGRpZmYgLS1naXQgYS9uZXQvaXB2Ni91
ZHAuYyBiL25ldC9pcHY2L3VkcC5jDQo+IGluZGV4DQo+IGE4ZDc0ZjQ0MDU2YTY4MWVmOTA1N2M0
YzRhYmIzNDAxNjEyMGI0NGYuLjEzNzEzZTBlNTc3OWI3NWRlOTc1ZmFhZQ0KPiBiNDUxMWJlZjQw
ZTA5N2RjDQo+IDEwMDY0NA0KPiAtLS0gYS9uZXQvaXB2Ni91ZHAuYw0KPiArKysgYi9uZXQvaXB2
Ni91ZHAuYw0KPiBAQCAtNjYxLDggKzY2MSw3IEBAIHN0YXRpYyBpbnQgdWRwdjZfcXVldWVfcmN2
X29uZV9za2Ioc3RydWN0IHNvY2sNCj4gKnNrLCBzdHJ1Y3Qgc2tfYnVmZiAqc2tiKQ0KPiAgICAg
ICAgIH0NCj4gDQo+ICAgICAgICAgcHJlZmV0Y2goJnNrLT5za19ybWVtX2FsbG9jKTsNCj4gLSAg
ICAgICBpZiAocmN1X2FjY2Vzc19wb2ludGVyKHNrLT5za19maWx0ZXIpICYmDQo+IC0gICAgICAg
ICAgIHVkcF9saWJfY2hlY2tzdW1fY29tcGxldGUoc2tiKSkNCj4gKyAgICAgICBpZiAodWRwX2xp
Yl9jaGVja3N1bV9jb21wbGV0ZShza2IpKQ0KPiAgICAgICAgICAgICAgICAgZ290byBjc3VtX2Vy
cm9yOw0KPiANCj4gICAgICAgICBpZiAoc2tfZmlsdGVyX3RyaW1fY2FwKHNrLCBza2IsIHNpemVv
ZihzdHJ1Y3QgdWRwaGRyKSkpDQoNCk9oLCB5ZXMhIDotKSBUaGFuayB5b3UhDQoNCkVyaWMsIEkn
bGwgYWRkIHlvdXIgU2lnbmVkLW9mZi1ieSBhbmQgbWluZS4gUGxlYXNlIGxldCBtZSBrbm93IGlu
IGNhc2UNCnRoaXMgaXMgbm90IG9rLg0KDQpJJ2xsIGRvIGEgbGl0dGxlIG1vcmUgdGVzdGluZyB3
aXRoIHRoZSBwYXRjaCBhbmQgSSBwbGFuIHRvIHBvc3QgdGhlIHBhdGNoDQp0byBzdGFibGVAdmdl
ci5rZXJuZWwub3JnIGFuZCBuZXRkZXZAdmdlci5rZXJuZWwub3JnIHRoaXMgYWZ0ZXJub29uLA0K
aS5lLiBpbiAzfjQgaG91cnMgb3Igc28uIA0KDQpUaGFua3MsDQotLSBEZXh1YW4NCg==
