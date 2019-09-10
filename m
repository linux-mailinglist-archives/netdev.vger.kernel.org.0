Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81000AEA03
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 14:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbfIJMIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 08:08:07 -0400
Received: from mx0b-00128a01.pphosted.com ([148.163.139.77]:40966 "EHLO
        mx0b-00128a01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726060AbfIJMIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 08:08:06 -0400
Received: from pps.filterd (m0167090.ppops.net [127.0.0.1])
        by mx0b-00128a01.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8ABwJhJ009084;
        Tue, 10 Sep 2019 08:07:54 -0400
Received: from nam02-bl2-obe.outbound.protection.outlook.com (mail-bl2nam02lp2056.outbound.protection.outlook.com [104.47.38.56])
        by mx0b-00128a01.pphosted.com with ESMTP id 2uv967jq5n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 10 Sep 2019 08:07:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kkhho13uyng0qOb52P/d0GD0hFtbUJ+E63DZOKVPT5C8/IHlIRw/n9Pp1qLbQol9Yh1vdRQZYxrcKmZrV1RxT80m2cskXUORGh/3twCLZFt7jv1+vVLE1MBEyNDaN+RDCh5hrspoEEVPwYsujmQudRTNbqStyr6vDrhi9Lz1B6Bl59jMm3UZYF/mpwl5HgMuCl+Z1kk1iczyB3kCqU0vEbtnkhNT4UH/fsWdUA8YGqC2nYjN1DSFutR+P+uxBR9AHYohB0MQ+EOdcntnVJKskIHYkn+POfPvV2ZDAFgdfTEj3l+3aFIMfWTDYxy4nJ8ccRtZUMmwlyfrjiAcFB/BSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzblVY6ZyNx6EL03YlFydhvKPnXa7T2rIcInPcatTls=;
 b=fxRVR/pkeDxvBYnK/R9GcBzqNsmuTtXtCDCXLsM5YCRC9E0DERb8ea2TSQpJcGgvldNbUgt9NBOyVfTPF4VUAjXeHiPE5R/w9JUpTVLGUSwh1UQEHW2N7zXcboQ/YBuRU1Lzdxy0EDqie4An6unkkeyBPaFzn0Jn1A8fizTD1POMXyYIWWUdXsGF9rnV0tnhDbpmbU0pJ9PfdCkupIZ9ay8Ke+uxuMHqCalMU8pJH9Kd99z7AwDfZ5RpTKnNayAwkVdylPc5U3Y0d+zcPRZD67WdGRU+1PLDtq593xXqzEQOi5mQp7mwtjupV95OGcjEYnWRRwvHWnSAnLCbYzHiZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=analog.com; dmarc=pass action=none header.from=analog.com;
 dkim=pass header.d=analog.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=analog.onmicrosoft.com; s=selector2-analog-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SzblVY6ZyNx6EL03YlFydhvKPnXa7T2rIcInPcatTls=;
 b=ueonR/wN2QtCVIl7IhLo7ycL/c762j89sOkNK+gBn6QguCYbzE25jfvk/BhCv7idnh2Ez2SWo7Df//N9vJnbHHkRB2XkiguwYRHMuBAf5sXan/JZ9zd53EkHUbIpI9ovPcqTi0q8QLPvDxy1OQ6xQtl2g6pYLiSFDslIVHKXurg=
Received: from CH2PR03MB5192.namprd03.prod.outlook.com (20.180.12.152) by
 CH2PR03MB5205.namprd03.prod.outlook.com (20.180.15.74) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.15; Tue, 10 Sep 2019 12:07:53 +0000
Received: from CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b]) by CH2PR03MB5192.namprd03.prod.outlook.com
 ([fe80::344d:7f50:49a3:db1b%3]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 12:07:53 +0000
From:   "Ardelean, Alexandru" <alexandru.Ardelean@analog.com>
To:     "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>
Subject: Re: [PATCH v3 1/2] ethtool: implement Energy Detect Powerdown support
 via phy-tunable
Thread-Topic: [PATCH v3 1/2] ethtool: implement Energy Detect Powerdown
 support via phy-tunable
Thread-Index: AQHVZxBaBQL3EPMRaE2wlpmgsbkWfackjWwAgAB3ewA=
Date:   Tue, 10 Sep 2019 12:07:53 +0000
Message-ID: <98aef502750727f94fb0603f3bf5e4634eaa0561.camel@analog.com>
References: <20190909131251.3634-1-alexandru.ardelean@analog.com>
         <20190909131251.3634-2-alexandru.ardelean@analog.com>
         <20190910080014.GC24779@unicorn.suse.cz>
In-Reply-To: <20190910080014.GC24779@unicorn.suse.cz>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.71.226.54]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1ef53fc-8723-43d7-2fc9-08d735e7822c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:CH2PR03MB5205;
x-ms-traffictypediagnostic: CH2PR03MB5205:
x-microsoft-antispam-prvs: <CH2PR03MB5205CFEA9AF75571CAD293FEF9B60@CH2PR03MB5205.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(396003)(346002)(39860400002)(366004)(136003)(199004)(189003)(66476007)(66556008)(76116006)(6246003)(6486002)(102836004)(186003)(99286004)(14454004)(66446008)(86362001)(6506007)(6116002)(446003)(2906002)(53936002)(76176011)(11346002)(478600001)(3846002)(6436002)(110136005)(476003)(486006)(25786009)(54906003)(316002)(2616005)(7416002)(7736002)(305945005)(66066001)(91956017)(8676002)(229853002)(26005)(5660300002)(81166006)(81156014)(4326008)(8936002)(64756008)(6512007)(2501003)(36756003)(14444005)(71190400001)(256004)(118296001)(71200400001)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:CH2PR03MB5205;H:CH2PR03MB5192.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: analog.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: af/5GoDbbbAGqRzlgRzIkspA2Hi7aTAwRrAFVzzLDNqPOczTr3Hb+Xgw6Pf3chhog8TZcITS+PV+w7IpfLmpp6Y9OVAugEEHrypsy7rM8ZLb0/BLJyieUdS2qIg8SoRM+q6sT+faU1TmG6b6h8KbAtXKx31emx7i9HTylKQTwrjruf26b/B4PT/PEpa+GWEloZbvJD3/YgC/3L1P5LJDzKckSWtDgLzlSZ0dvJ6MdFqJnySxs1yrqlUXS5rGSjSITDITQgC5J8EtNUvs/jXM04pKdexFOS/OL+88yl+9Z1lvrmjbr3B6BTshZ0IOUl2gDnJaHyTjRAcxjwty9iMVlOsXvB7cPNFXMsP20b+/4w4WnAtyO4nYmLTS7NBQH6g7NjVOJECQ2om1Ed6oYudvMsFkCsFk+9NGLHywWm1KOgs=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <186FD882CC375343BB98BC5D9718F1D9@namprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: analog.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1ef53fc-8723-43d7-2fc9-08d735e7822c
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 12:07:53.2474
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: eaa689b4-8f87-40e0-9c6f-7228de4d754a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 80tvKaUko0Bt6m3PBANlVQyEVUYZ9M8OmKPWo55LzYBJkKyuVFIKEYfzos/Ehxipzet6h02W1ncLiaVcNhLAQHN/FW6NfYigp5PYuE7F8us=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR03MB5205
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_07:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 suspectscore=0 bulkscore=0 clxscore=1011 mlxscore=0 phishscore=0
 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909100120
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA5LTEwIGF0IDEwOjAwICswMjAwLCBNaWNoYWwgS3ViZWNlayB3cm90ZToN
Cj4gW0V4dGVybmFsXQ0KPiANCj4gT24gTW9uLCBTZXAgMDksIDIwMTkgYXQgMDQ6MTI6NTBQTSAr
MDMwMCwgQWxleGFuZHJ1IEFyZGVsZWFuIHdyb3RlOg0KPiA+IFRoZSBgcGh5X3R1bmFibGVfaWRg
IGhhcyBiZWVuIG5hbWVkIGBFVEhUT09MX1BIWV9FRFBEYCBzaW5jZSBpdCBsb29rcyBsaWtlDQo+
ID4gdGhpcyBmZWF0dXJlIGlzIGNvbW1vbiBhY3Jvc3Mgb3RoZXIgUEhZcyAobGlrZSBFRUUpLCBh
bmQgZGVmaW5pbmcNCj4gPiBgRVRIVE9PTF9QSFlfRU5FUkdZX0RFVEVDVF9QT1dFUl9ET1dOYCBz
ZWVtcyB0b28gbG9uZy4NCj4gPiANCj4gPiBUaGUgd2F5IEVEUEQgd29ya3MsIGlzIHRoYXQgdGhl
IFJYIGJsb2NrIGlzIHB1dCB0byBhIGxvd2VyIHBvd2VyIG1vZGUsDQo+ID4gZXhjZXB0IGZvciBs
aW5rLXB1bHNlIGRldGVjdGlvbiBjaXJjdWl0cy4gVGhlIFRYIGJsb2NrIGlzIGFsc28gcHV0IHRv
IGxvdw0KPiA+IHBvd2VyIG1vZGUsIGJ1dCB0aGUgUEhZIHdha2VzLXVwIHBlcmlvZGljYWxseSB0
byBzZW5kIGxpbmsgcHVsc2VzLCB0byBhdm9pZA0KPiA+IGxvY2stdXBzIGluIGNhc2UgdGhlIG90
aGVyIHNpZGUgaXMgYWxzbyBpbiBFRFBEIG1vZGUuDQo+ID4gDQo+ID4gQ3VycmVudGx5LCB0aGVy
ZSBhcmUgMiBQSFkgZHJpdmVycyB0aGF0IGxvb2sgbGlrZSB0aGV5IGNvdWxkIHVzZSB0aGlzIG5l
dw0KPiA+IFBIWSB0dW5hYmxlIGZlYXR1cmU6IHRoZSBgYWRpbmAgJiYgYG1pY3JlbGAgUEhZcy4N
Cj4gPiANCj4gPiBUaGUgQURJTidzIGRhdGFzaGVldCBtZW50aW9ucyB0aGF0IFRYIHB1bHNlcyBh
cmUgYXQgaW50ZXJ2YWxzIG9mIDEgc2Vjb25kDQo+ID4gZGVmYXVsdCBlYWNoLCBhbmQgdGhleSBj
YW4gYmUgZGlzYWJsZWQuIEZvciB0aGUgTWljcmVsIEtTWjkwMzEgUEhZLCB0aGUNCj4gPiBkYXRh
c2hlZXQgZG9lcyBub3QgbWVudGlvbiB3aGV0aGVyIHRoZXkgY2FuIGJlIGRpc2FibGVkLCBidXQg
bWVudGlvbnMgdGhhdA0KPiA+IHRoZXkgY2FuIG1vZGlmaWVkLg0KPiA+IA0KPiA+IFRoZSB3YXkg
dGhpcyBjaGFuZ2UgaXMgc3RydWN0dXJlZCwgaXMgc2ltaWxhciB0byB0aGUgUEhZIHR1bmFibGUg
ZG93bnNoaWZ0DQo+ID4gY29udHJvbDoNCj4gPiAqIGEgYEVUSFRPT0xfUEhZX0VEUERfREZMVF9U
WF9JTlRFUlZBTGAgdmFsdWUgaXMgZXhwb3NlZCB0byBjb3ZlciBhIGRlZmF1bHQNCj4gPiAgIFRY
IGludGVydmFsOyBzb21lIFBIWXMgY291bGQgc3BlY2lmeSBhIGNlcnRhaW4gdmFsdWUgdGhhdCBt
YWtlcyBzZW5zZQ0KPiA+ICogYEVUSFRPT0xfUEhZX0VEUERfTk9fVFhgIHdvdWxkIGRpc2FibGUg
VFggd2hlbiBFRFBEIGlzIGVuYWJsZWQNCj4gPiAqIGBFVEhUT09MX1BIWV9FRFBEX0RJU0FCTEVg
IHdpbGwgZGlzYWJsZSBFRFBEDQo+ID4gDQo+ID4gVGhpcyBzaG91bGQgYWxsb3cgUEhZcyB0bzoN
Cj4gPiAqIGVuYWJsZSBFRFBEIGFuZCBub3QgZW5hYmxlIFRYIHB1bHNlcyAoaW50ZXJ2YWwgd291
bGQgYmUgMCkNCj4gPiAqIGVuYWJsZSBFRFBEIGFuZCBjb25maWd1cmUgVFggcHVsc2UgaW50ZXJ2
YWw7IG5vdGUgdGhhdCBUWCBpbnRlcnZhbCB1bml0cw0KPiA+ICAgd291bGQgYmUgUEhZIHNwZWNp
ZmljOyB3ZSBjb3VsZCBjb25zaWRlciBgc2Vjb25kc2AgYXMgdW5pdHMsIGJ1dCBpdCBjb3VsZA0K
PiA+ICAgaGFwcGVuIHRoYXQgc29tZSBQSFlzIHdvdWxkIGJlIHByZWZlciBtaWxsaXNlY29uZHMg
YXMgYSB1bml0Ow0KPiA+ICAgYSBtYXhpbXVtIG9mIDY1NTMzIHVuaXRzIHNob3VsZCBiZSBzdWZm
aWNpZW50DQo+IA0KPiBTb3JyeSBmb3IgbWlzc2luZyB0aGUgZGlzY3Vzc2lvbiBvbiBwcmV2aW91
cyB2ZXJzaW9uIGJ1dCBJIGRvbid0IHJlYWxseQ0KPiBsaWtlIHRoZSBpZGVhIG9mIGxlYXZpbmcg
dGhlIGNob2ljZSBvZiB1bml0cyB0byBQSFkuIEJvdGggZm9yIG1hbnVhbA0KPiBzZXR0aW5nIGFu
ZCBzeXN0ZW0gY29uZmlndXJhdGlvbiwgaXQgd291bGQgYmUgSU1ITyBtdWNoIG1vcmUgY29udmVu
aWVudA0KPiB0byBoYXZlIHRoZSBpbnRlcnByZXRhdGlvbiB1bml2ZXJzYWwgZm9yIGFsbCBOSUNz
Lg0KPiANCg0KSSB3YXMgYWxzbyBhIGJpdCB1bmNlcnRhaW4vdW5kZWNpZGVkIGhlcmUgYWJvdXQg
bGV0dGluZyBQSFlzIGRlY2lkZSB1bml0cy4NCkFuZCBJIGFsc28gd2Fzbid0IHN1cmUgd2hhdCB0
byBwcm9wb3NlLg0KTm90IHByb3Bvc2luZyBhIHVuaXQgbm93LCB3b3VsZCBoYXZlIGFsbG93ZWQg
dXMgdG8gZGVjaWRlIGxhdGVyIGJhc2VkIG9uIHdoYXQgUEhZcyBpbXBsZW1lbnQgKGdlbmVyYWxs
eSkgaW4gdGhlIGZ1dHVyZS4NCkkga25vdyB0aGF0IG1heSBtYWtlIG1lIGxvb2sgYSBiaXQgbGF6
eSBbZm9yIG5vdCBwcm9wb3NpbmcgdW5pdHMgaW4gZXRodG9vbF0sIGJ1dCB0YmggaXQncyBtb3Jl
IG9mIGxhY2stb2YtZXhwZXJpZW5jZQ0Kd2l0aCBldGh0b29sIChvciB0aGVzZSBBUElzKSBldm9s
dmUgb3ZlciB0aW1lLg0KDQo+IFNlY29uZHMgYXMgdW5pdHMgc2VlbSB0b28gY29hcnNlIGFuZCBt
YXhpbXVtIG9mIH4xOCBob3VycyB3YXkgdG9vIGJpZy4NCj4gTWlsbGlzZWNvbmRzIHdvdWxkIGJl
IG1vcmUgcHJhY3RpY2FsIGZyb20gZ3JhbnVsYXJpdHkgcG9pbnQgb2YgdmlldywNCj4gd291bGQg
bWF4aW11bSBvZiB+NjUgc2Vjb25kcyBiZSBzdWZmaWNpZW50Pw0KDQpJIHRoaW5rIDY1IHNlY29u
ZHMgaXMgbW9yZSB0aGFuIGVub3VnaC4NCkkgZmVlbCB0aGF0LCBpZiB5b3UgcGx1Zy1pbiBhbiBl
dGggY2FibGUgYW5kIGRvbid0IGhhdmUgYSBsaW5rIGluIGEgbWludXRlLCB0aGVuIGl0J3Mgbm90
IGdyZWF0IChubyBtYXR0ZXIgaG93IG11Y2ggb2YgYQ0KcG93ZXItc2F2ZXIgeW91IGFyZSkuDQoN
CkFjdHVhbGx5LCB2b2ljaW5nIG91dCB0aGVzZSB1bml0cyBtYWtlcyBpdCBzaW1wbGVyIGZvciBh
IGRlY2lzaW9uIHRvIGdvIGluIGZhdm9yIGZvciBtaWxsaXNlY29uZHMuDQpTbzogdGhhbmsgeW91
IDopDQoNCkFsZXgNCg0KPiANCj4gTWljaGFsIEt1YmVjZWsNCj4gDQo+ID4gKiBkaXNhYmxlIEVE
UEQNCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBBbGV4YW5kcnUgQXJkZWxlYW4gPGFsZXhhbmRy
dS5hcmRlbGVhbkBhbmFsb2cuY29tPg0K
