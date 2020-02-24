Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46B1116AD98
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 18:34:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727926AbgBXRe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 12:34:27 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25082 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727460AbgBXRe1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 12:34:27 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 01OHLZTM025065;
        Mon, 24 Feb 2020 09:34:13 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0818;
 bh=gLuFbaJSqwMCF86naoib5HYUPBsk2latskW2DojpH6w=;
 b=hTnHOIB9YzobUjVg++6nnYzeYbZjGYej9W4GiUa0X2R6CWkV6QTQViZDSNBH6W39ljAg
 GsaALHBG77+aqa5un1sj/wrOOs2VGZuUoJnVj3JDT/ULZ9LDUiPrwf1+0OZpscTO+QYp
 /YsAX9MZfgezOWPriCcDFgua5C3teJ66YS0GlhLJk9Ys9zZVYBRLlDyzDdGvhoWdQw+u
 zNdBz7figX2IpMf5gTkFCQH8L4x2A3xAiBt2+X0vOMB2mNjcxNnpIw92aPb2E4Ckfd9y
 QDNfI41BxbGt5fPiuUEcKFkD6FIouqm73RXsmnvLWSTdixul7LMbw1NaQkXD7TdcUa5X kw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 2yb2hv7xrn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 24 Feb 2020 09:34:13 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Feb
 2020 09:34:11 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 24 Feb
 2020 09:34:11 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.177)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Mon, 24 Feb 2020 09:34:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iSSd1DaeoHrcO4lKQWa3cgT/4OdqCjN4BENSBDHKz7JRLwB0kNpBdbp0GPT3yV72kxpDz3BwJM2S45UJFRJs/C8YEA3KUz/qqkHLtxQFoAdGPG+BZGi6/eNIjs9lTf0DP2/L0yXs3yGJWT3VWrQHsUW4uP8CzADqqD686SnWhKJMMbPsZqFPd6EinFve0uIAFRg8SC+e+lvEUX6BUqxLgTSGHedaqWLxMj1fD7slDUEJ+jRXIUxBS9phD6Po3CJsjYrPsLLbdX5CDKqKdXCcrMvXeXNRV6dvCfg6HOps/zxXrp0CHMzespYyIz1+MRK44GoPWIlrucuD5xbcY9NbgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLuFbaJSqwMCF86naoib5HYUPBsk2latskW2DojpH6w=;
 b=n0QRy6wXJnEZ5Akoda8MXoPUJJoH7NTgojjOlKl9eQtKv6BJOFxjgCutZSYBk1ghEDpm2w4KGkR1xvufl7WJ8tDF2+P8HbIvu8mt+MbVnPOGWAE1fjkbEozRsCboavBMjPnSykPUrYHLn0qNwb7TriSFxaxS2C/BXdL/Oyny1D20yPC0kMR8PQJ98+9aswXPuEpC4iswtwiui804t/Rlzb36YuqNYoDVcnu50YXOOa+dKmKMNJoR7wOEqZ4TBqwsk4qBHmYFGPhYHzfwBuHMGYuUrhYY54/wg7MWrC1nfKcHXR3FydxD+U/Nd+P9H6mI2BMTAFGqMArSy4m/R2sVhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gLuFbaJSqwMCF86naoib5HYUPBsk2latskW2DojpH6w=;
 b=MdSvnPV9FlGKu2AmW9X7yThxVrKhW4GW6U/5w/+ODRZGvyoWuMPSZI1/L7ee41aqUXQdTGTSswJpDwpAekdpnpU2QpXWBJ0Z8K53p1hD+XJJg4MgQFapThpEJZkdpvNvHumQIZm3ArJacRqRC68Smp+LNAFI4DjNrpLfKrWLYM4=
Received: from SN1PR18MB2222.namprd18.prod.outlook.com (2603:10b6:802:25::26)
 by SN1PR18MB2239.namprd18.prod.outlook.com (2603:10b6:802:2e::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.21; Mon, 24 Feb
 2020 17:34:09 +0000
Received: from SN1PR18MB2222.namprd18.prod.outlook.com
 ([fe80::650b:292:523a:b7c4]) by SN1PR18MB2222.namprd18.prod.outlook.com
 ([fe80::650b:292:523a:b7c4%4]) with mapi id 15.20.2750.021; Mon, 24 Feb 2020
 17:34:09 +0000
From:   Ariel Elior <aelior@marvell.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Sudarsana Reddy Kalluru <skalluru@marvell.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "it+linux-netdev@molgen.mpg.de" <it+linux-netdev@molgen.mpg.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [EXT] Re: bnx2x: Latest firmware requirement breaks no regression
 policy
Thread-Topic: [EXT] Re: bnx2x: Latest firmware requirement breaks no
 regression policy
Thread-Index: AQHV5wGCvUlGLJk7UUybWaBU9BXeqKgidnIAgAFYngCAAGbFwIAAmmyAgAXL9OA=
Date:   Mon, 24 Feb 2020 17:34:09 +0000
Message-ID: <SN1PR18MB22229FDE210EA1AA484FBD21C4EC0@SN1PR18MB2222.namprd18.prod.outlook.com>
References: <ffbcf99c-8274-eca1-5166-efc0828ca05b@molgen.mpg.de>
        <MN2PR18MB2528C681601B34D05100DF89D3100@MN2PR18MB2528.namprd18.prod.outlook.com>
        <8daadcd1-3ff2-2448-7957-827a71ae4d2e@molgen.mpg.de>
        <MN2PR18MB2528EC91E410FD1BE9FC3EF5D3130@MN2PR18MB2528.namprd18.prod.outlook.com>
        <DM5PR18MB221508B070C5C2DAE8ADB053C4130@DM5PR18MB2215.namprd18.prod.outlook.com>
 <20200220163739.0bc51e4c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200220163739.0bc51e4c@kicinski-fedora-PC1C0HJN>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.203.130.254]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 402cc5ca-8f3b-4be3-5f3f-08d7b94fc186
x-ms-traffictypediagnostic: SN1PR18MB2239:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN1PR18MB22395BA453FF47BC71ECAA76C4EC0@SN1PR18MB2239.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 032334F434
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(376002)(346002)(39860400002)(136003)(189003)(199004)(26005)(54906003)(66476007)(6916009)(55016002)(66946007)(33656002)(66446008)(7696005)(64756008)(86362001)(76116006)(52536014)(8936002)(66556008)(9686003)(8676002)(186003)(4326008)(2906002)(5660300002)(53546011)(316002)(478600001)(966005)(71200400001)(81156014)(81166006)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:SN1PR18MB2239;H:SN1PR18MB2222.namprd18.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: marvell.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LPjEYPUvbh0UsJJ4gUOVPbKayxOaJ3hEu5Nzi0RBM3gN4SL2adckd8yxf+z+e+97b3/cCYQvPmBVbTXVCvx0lcouR/r0gmoYS1DeHkiVMEtpYWvz9AIW9TDVLM1VnV+e4jo/L7eGPoRhQ05q42DuttVlteA63n30cMKxFqnNosTWChkKB1eKR+u9JWVnP11W9Dame0ImQQZOzpU6VezKGXBd4245GogpiFurdNgK0gHW5Q84W16QuKZZ/zIGYQGRFS0TZ4MvlvDhMx+zEeqZW9HLfL69Q95DRUBtKzlg4OVseIK3vrjzsC+9nl8A+1BA7MmwXOaXoxvf5ES6oztGtLhAdfuIorJV9segxWDCxsZ5nvYH/K+0ILkHHdiFTDtCRTt06N3S9ivHZ/Y88WiRbIffvDSLjky9yGDTRayxnnLACkJfCwzYoM8G2PPydZ3unj03GHLOBYa4rep53FLrJye3sn7GrPsouoOhWRRje/9aI+tyMzXgpa54t9WIQF9xCscGi6X9eqZYzfUKmXXB2g==
x-ms-exchange-antispam-messagedata: KtN4qxnmRWd9ALeLvJNdyZ/oCUfH3BIri+DBXN+2XGpboXLRH//AXmN5ONtWejFdoU1TuY7PWPpqbJEIOeJWwcQksUpOkAtSi84s8AqPf0tm1hw1jd2gxj7YB33y/mC4RdyeM3fWg4AoCOBbuOLmGw==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 402cc5ca-8f3b-4be3-5f3f-08d7b94fc186
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2020 17:34:09.5359
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8y/VvS1W6C2ApIBWDXqC3m7Q/2wU1Q/GTBnqICvE2A6Y8e7c+laCXPnEbpNBm/OSWekvKbtzeSmsd4Rj9FrAUQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN1PR18MB2239
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-02-24_07:2020-02-21,2020-02-24 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogRnJpZGF5LCBGZWJydWFyeSAyMSwgMjAyMCAyOjM4
IEFNDQo+IFRvOiBBcmllbCBFbGlvciA8YWVsaW9yQG1hcnZlbGwuY29tPg0KPiBDYzogU3VkYXJz
YW5hIFJlZGR5IEthbGx1cnUgPHNrYWxsdXJ1QG1hcnZlbGwuY29tPjsgUGF1bCBNZW56ZWwNCj4g
PHBtZW56ZWxAbW9sZ2VuLm1wZy5kZT47IEdSLWV2ZXJlc3QtbGludXgtbDIgPEdSLWV2ZXJlc3Qt
bGludXgtDQo+IGwyQG1hcnZlbGwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgTEtNTCA8
bGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc+OyBpdCtsaW51eC1uZXRkZXZAbW9sZ2Vu
Lm1wZy5kZTsgRGF2aWQgUy4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KPiBTdWJq
ZWN0OiBSZTogW0VYVF0gUmU6IGJueDJ4OiBMYXRlc3QgZmlybXdhcmUgcmVxdWlyZW1lbnQgYnJl
YWtzIG5vIHJlZ3Jlc3Npb24NCj4gcG9saWN5DQo+IA0KPiBPbiBUaHUsIDIwIEZlYiAyMDIwIDE1
OjQwOjM3ICswMDAwIEFyaWVsIEVsaW9yIHdyb3RlOg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNz
YWdlLS0tLS0NCj4gPiA+IEZyb206IFN1ZGFyc2FuYSBSZWRkeSBLYWxsdXJ1IDxza2FsbHVydUBt
YXJ2ZWxsLmNvbT4NCj4gPiA+IFNlbnQ6IFRodXJzZGF5LCBGZWJydWFyeSAyMCwgMjAyMCAxMTox
NyBBTQ0KPiA+ID4gVG86IFBhdWwgTWVuemVsIDxwbWVuemVsQG1vbGdlbi5tcGcuZGU+OyBBcmll
bCBFbGlvcg0KPiA+ID4gPGFlbGlvckBtYXJ2ZWxsLmNvbT47IEdSLWV2ZXJlc3QtbGludXgtbDIg
PEdSLWV2ZXJlc3QtbGludXgtDQo+ID4gPiBsMkBtYXJ2ZWxsLmNvbT4NCj4gPiA+IENjOiBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOyBMS01MIDxsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnPjsN
Cj4gPiA+IGl0K2xpbnV4LSBuZXRkZXZAbW9sZ2VuLm1wZy5kZTsgRGF2aWQgUy4gTWlsbGVyDQo+
ID4gPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD4NCj4gPiA+IFN1YmplY3Q6IFJFOiBbRVhUXSBSZTog
Ym54Mng6IExhdGVzdCBmaXJtd2FyZSByZXF1aXJlbWVudCBicmVha3Mgbm8NCj4gPiA+IHJlZ3Jl
c3Npb24gcG9saWN5DQo+ID4gPg0KPiA+ID4gSGkgUGF1bCwNCj4gPiA+ICAgICBCbngyeCBkcml2
ZXIgYW5kIHRoZSBzdG9ybSBGVyBhcmUgdGlnaHRseSBjb3VwbGVkLCBhbmQgdGhlIGluZm8NCj4g
PiA+IGlzIGV4Y2hhbmdlZCBiZXR3ZWVuIHRoZW0gdmlhIHNobWVtIChpLmUuLCBjb21tb24gc3Ry
dWN0dXJlcyB3aGljaA0KPiA+ID4gbWlnaHQgY2hhbmdlIGJldHdlZW4gdGhlIHJlbGVhc2VzKS4g
QWxzbywgRlcgcHJvdmlkZXMgc29tZSBvZmZzZXQNCj4gPiA+IGFkZHJlc3NlcyB0byB0aGUgZHJp
dmVyIHdoaWNoIGNvdWxkIGNoYW5nZSBiZXR3ZWVuIHRoZSBGVyByZWxlYXNlcywNCj4gZm9sbG93
aW5nIGlzIG9uZSBzdWNoIGNvbW1pdCwNCj4gPiA+DQo+ID4gPiBodHRwczovL3VybGRlZmVuc2Uu
cHJvb2Zwb2ludC5jb20vdjIvdXJsP3U9aHR0cHMtM0FfX3d3dy5zcGluaWNzLm5ldA0KPiA+ID4N
Cj4gX2xpc3RzX25ldGRldl9tc2c2MDk4ODkuaHRtbCZkPUR3SUZhUSZjPW5LaldlYzJiNlIwbU95
UGF6N3h0ZlEmcj1jDQo+IFdCDQo+ID4gPg0KPiBnTklGVWlmWlJ4MnhoeXBkY2FZcmZJc01HdDkz
TnhQMXI4R1F0QzBzJm09VzRwRVpTWW1FR3l2YmFrcXRzWWNFNw0KPiBPYUsNCj4gPiA+DQo+IHZq
YUV2bFdqU0ZmVVVPYzY1QSZzPUE3VWloS3VrakhsRkwxNloxTUZmOXpZMEJJdFJnYkRTQXp3cTQ4
UGttdlkmZQ0KPiA9DQo+ID4gPiBIZW5jZSBpdCdzIG5vdCB2ZXJ5IHN0cmFpZ2h0IGZvcndhcmQg
dG8gcHJvdmlkZSB0aGUgYmFja3dhcmQNCj4gPiA+IGNvbXBhdGliaWxpdHkgaS5lLiwgbmV3ZXIg
KHVwZGF0ZWQpIGtlcm5lbCBkcml2ZXIgd2l0aCB0aGUgb2xkZXIgRlcuDQo+ID4gPiBDdXJyZW50
bHkgd2UgZG9u4oCZdCBoYXZlIHBsYW5zIHRvIGltcGxlbWVudCB0aGUgbmV3IG1vZGVsIG1lbnRp
b25lZA0KPiBiZWxvdy4NCj4gPiA+DQo+ID4gSGksDQo+ID4gVGhlcmUgYXJlIGFkZGl0aW9uYWwg
cmVhc29ucyB3aHkgYmFja3dhcmRzL2ZvcndhcmRzIGNvbXBhdGliaWxpdHkNCj4gPiBjb25zaWRl
cmF0aW9ucyBhcmUgbm90IGFwcGxpY2FibGUgaGVyZS4gVGhpcyBGdyBpcyBub3QgbnZyYW0gYmFz
ZWQsDQo+ID4gYW5kIGRvZXMgbm90IHJlc2lkZSBpbiB0aGUgZGV2aWNlLiBJdCBpcyBwcm9ncmFt
ZWQgdG8gdGhlIGRldmljZSBvbg0KPiA+IGV2ZXJ5IGRyaXZlciBsb2FkLiBUaGUgZHJpdmVyIHdp
bGwgbmV2ZXIgZmFjZSBhIGRldmljZSAiYWxyZWFkeQ0KPiA+IGluaXRpYWxpemVkIiB3aXRoIGEg
dmVyc2lvbiBvZiBGVyBpdCBpcyBub3QgZmFtaWxpYXIgd2l0aC4NCj4gDQo+IEhvdyBkbyB5b3Ug
ZGVhbCB3aXRoIFZGcz8NCj4gDQo+ID4gVGhlIGRldmljZSBhbHNvIGhhcyB0cmFkaXRpb25hbCBt
YW5hZ2VtZW50IEZXIGluIG52cmFtIGluIHRoZSBkZXZpY2UNCj4gPiB3aXRoIHdoaWNoIHdlIGhh
dmUgYSBiYWNrd2FyZHMgYW5kIGZvcndhcmRzIGNvbXBhdGliaWxpdHkgbWVjaGFuaXNtLA0KPiA+
IHdoaWNoIHdvcmtzIGp1c3QgZmluZS4NCj4gPiBCdXQgdGhlIEZXIHVuZGVyIGRpc2N1c3Npb24g
aXMgZmFzdHBhdGggRncsIHVzZWQgdG8gY3JhZnQgZXZlcnkgcGFja2V0DQo+ID4gZ29pbmcgb3V0
IG9mIHRoZSBkZXZpY2UgYW5kIGFuYWx5emUgYW5kIHBsYWNlIGV2ZXJ5IHBhY2tldCBjb21pbmcg
aW50byB0aGUNCj4gZGV2aWNlLg0KPiA+IFN1cHBvcnRpbmcgbXVsdGlwbGUgdmVyc2lvbnMgb2Yg
Rlcgd291bGQgYmUgdGFudGFtb3VudCB0byBpbXBsZW1lbnRpbmcNCj4gPiBkb3plbnMgb2YgdmVy
c2lvbnMgb2Ygc3RhcnRfeG1pdCBhbmQgbmFwaV9wb2xsIGluIHRoZSBkcml2ZXIgKG5vdCB0bw0K
PiA+IG1lbnRpb24gbXVsdGlwbGUgZmFzdHBhdGggaGFuZGxlcyBvZiBhbGwgdGhlIG9mZmxvYWRz
IHRoZSBkZXZpY2UNCj4gPiBzdXBwb3J0cywgcm9jZSwgaXNjc2ksIGZjb2UgYW5kIGl3YXJwLCBh
cyBhbGwgb2YgdGhlc2UgYXJlIG9mZmxvYWRlZCBieSB0aGUgRlcpLg0KPiA+IFRoZSBlbnRpcmUg
ZGV2aWNlIGluaXRpYWxpemF0aW9uIHNlcXVlbmNlIGFsc28gY2hhbmdlcyBzaWduaWZpY2FudGx5
DQo+ID4gZnJvbSBvbmUgRlcgdmVyc2lvbiB0byB0aGUgTmV4dC4gQWxsIG9mIHRoZXNlIGRpZmZl
cmVuY2VzIGFyZQ0KPiA+IGFic3RyYWN0ZWQgYXdheSBpbiB0aGUgRlcgZmlsZSwgd2hpY2ggaW5j
bHVkZXMgdGhlIGluaXQgc2VxdWVuY2UgYW5kDQo+ID4gdGhlIGNvbXBpbGVkIEZXLiBUaGUgYW1v
dW50IG9mIGNoYW5nZXMgcmVxdWlyZWQgaW4gZHJpdmVyIGFyZSB2ZXJ5DQo+ID4gc2lnbmlmaWNh
bnQgd2hlbiBtb3ZpbmcgZnJvbSBvbmUgdmVyc2lvbiB0byB0aGUgbmV4dC4gVHJ5aW5nIHRvIGtl
ZXANCj4gPiBhbGwgdGhvc2UgdmVyc2lvbnMgYWxpdmUgY29uY3VycmVudGx5IHdvdWxkIGNhdXNl
IHRoaXMgYWxyZWFkeSB2ZXJ5IGxhcmdlDQo+IGRyaXZlciB0byBiZSAyMHggbGFyZ2VyLg0KPiAN
Cj4gQWxsIHlvdXIgcG9pbnRzIGFyZSBkaXNwcm92ZWQgYnkgYWxsIHRoZSBkZXZpY2VzIHdoaWNo
IGhhdmUgZHJpdmVycyB1cHN0cmVhbQ0KPiBhbmQgZG9uJ3QgYnJlYWsgYmFja3dhcmQgY29tcGF0
aWJpbGl0eSBvbiBldmVyeSByZWxlYXNlLg0KTm90ZSB0aGF0IHdlIGFyZSB0YWxraW5nIGFib3V0
IGNvbXBhdGliaWxpdHkgd2l0aCBhIGZpbGUgb24gdGhlIGRpc2ssIG5vdCB3aXRoDQp0aGUgRlcg
aW4gdGhlIGRldmljZS4gSSBkb24ndCB0aGluayBhbnkgb2YgdGhlIG90aGVyIGRyaXZlcnMgaGF2
ZSBmYXN0cGF0aA0KRlcgd2hpY2ggbmVlZHMgdG8gYmUgcHJvZ3JhbW1lZCB0byB0aGUgZGV2aWNl
IG9uIGV2ZXJ5IGRyaXZlciBsb2FkLiBBcw0Kbm90ZWQsIHRoaXMgaXMgbm90IEZXIHRoYXQgcmVz
aWRlcyBpbiBmbGFzaC4gSXQgaGFzIHRvIGJlIHJlcHJvZ3JhbW1lZCBvbg0KZHJpdmVyIGxvYWQu
IE5vdGUgdGhhdCB3ZSBkbyBhbHdheXMgbWFrZSBzdXJlIHRvIGhhdmUgdGhlIG5ldyBGVyBmaWxl
DQphY2NlcHRlZCBpbiB0aGUgTGludXggRlcgdHJlZSBiZWZvcmUgd2Ugc2VuZCB0byBEYXZlIHRo
ZSBzZXJpZXMgZm9yIG1ha2luZw0KdXNlIG9mIGl0LiBBbmQgdGhlIGRyaXZlciBkb2VzIGRldGVj
dCB0aGF0IHRoZSBGVyBmaWxlIGlzIG5vdCBhdmFpbGFibGUgYW5kDQpmYWlscyB0aGUgbG9hZCBm
bG93IGdyYWNlZnVsbHkuDQoNCkkgdGhpbmsgdGhpcyBib2lscyBkb3duIHRvIGEgc2ltcGxlIHF1
ZXN0aW9uOiBJcyB0aGUgdXNlIGNhc2Ugb2YgdXBncmFkaW5nDQp0aGUga2VybmVsIHdpdGhvdXQg
cHVsbGluZyB0aGUgRlcgdHJlZSBhIGxlZ2l0aW1hdGUgb25lPyBJZiBzbywgSSB0aGluayB0aGUN
CnNvbHV0aW9uIHdlIGNhbiBvZmZlciBpcyB0byBjcmVhdGUgYW4gLmggZmlsZSB3aXRoIHRoZSBy
ZXF1aXJlZCBpbml0IHNlcXVlbmNlDQooRlcgYW4gYWxsKSBhbmQgaGF2ZSB0aGUgZHJpdmVyIGNv
bXBpbGUgd2l0aCBpdCwgc28gaXQgY2FuIGFsd2F5cyBpbml0aWFsaXplDQp0aGUgZGV2aWNlLiBU
aGlzIGlzIGhvdyB0aGlzIGRldmljZSBpcyBpbml0aWFsaXplZCBpbiBPU2VzIHdoaWNoIGRvbid0
IHN1cHBvcnQNCmR5bmFtaWMgRlcgbG9hZC4gVGhpcyBpcyBub3QgZGlmZmljdWx0IHRvIGRvIGFu
ZCB3b3VsZCBzb2x2ZSB0aGUgcHJvYmxlbQ0KeW91IGFyZSBmYWNpbmcgKEZXIGZpbGUgbm90IGF2
YWlsYWJsZSBvbiBkaXNrKSBidXQgd291bGQgYWxzbyBtZWFuIHRoYXQgdGhlDQpjb21waWxlZCBk
cml2ZXIgc2l6ZSB3b3VsZCBiZSBtdWNoIGxhcmdlci4gSXMgdGhhdCBkZXNpcmFibGU/DQoNCkFz
IGFuIGFzaWRlLCBwbGVhc2Ugbm90ZSB0aGF0IHRoaXMgbW9kZWwgaXMgaW1wbGVtZW50ZWQgcWVk
ZSBmb3IgYSBmZXcNCnllYXJzIGFuZCBpbiBibngyeCBmb3IgbWFueSB5ZWFycywgYW5kIEkgZGlk
IG5vdCBnZXQgdGhpcyBjb21wbGFpbnQgeWV0Lg0KDQo+IA0KPiA+IFdlIGRvbid0IGhhdmUgYSBt
ZXRob2Qgb2Yga2VlcGluZyB0aGUgZGV2aWNlIG9wZXJhdGlvbmFsIGlmIHRoZSBrZXJuZWwNCj4g
PiB3YXMgdXBncmFkZWQgYnV0IGZpcm13YXJlIHRyZWUgd2FzIG5vdCB1cGRhdGVkLiBUaGUgYmVz
dCB0aGF0IGNhbiBiZQ0KPiA+IGRvbmUgaXMgcmVwb3J0IHRoZSBwcm9ibGVtLCB3aGljaCBpcyB3
aGF0IHdlIGRvLg0K
