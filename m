Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00AFC8846F
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727414AbfHIVN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:13:57 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:7244 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726232AbfHIVN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 17:13:57 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x79L2u59031644;
        Fri, 9 Aug 2019 14:13:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=4Z6d5KIKeArS5BLaDE7ml+yDdsr31o2MwPa3vY22Ezo=;
 b=J4743ewikQ3/kEk0hwF+WwGfGljmfXZe1B6X5S6CRpbhmi9QINpZMH0nsxp3TV6YLN61
 BEfigzeAccreEtj/I5Fpq1VTqZPz2nAMa8IPCsA2QGXkJzh09ZWxY2rlqecbT50kBxfD
 Q70nnY+lc9b19DjRkiylgxcofN15M803AIc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u9enp0fej-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 09 Aug 2019 14:13:44 -0700
Received: from ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 9 Aug 2019 14:13:43 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 9 Aug 2019 14:13:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nYBs5MuceOWoJ4x1WOSgJyX/IOPT7oPzMb+Ujc8ioZ+rfIyEFeqs3HWbndnVIE4ehdm+lMjZhn1j4m0WwIw/aPqshLNjdYbgL4/UgBa0NgE6fAwLw3O40w95sK+QJEFlQvftUvFkqj0u7jCFY5oKGYijZMhhqQkp8UUkFNd3DjfXSBIzIjMGQIzQQOTGwxr60z4y75g6vzXfkpmdgS4EecqhBUIWeB1JT2OpVnQQOfv5wzK1x78qM/lXHaUOt2sr6iB0xYW6voP5+BQHAu9faOW81Gh2W+5QRKyKx0zEmsxpCoERIFsVHPWB1CIO9krp09wT+qv603hYyxXTaVb8Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Z6d5KIKeArS5BLaDE7ml+yDdsr31o2MwPa3vY22Ezo=;
 b=dqcbCrrf4ckJ0jUWYkURKvVY2LT/I1AjE722uh3gVik+v+NzbX2HqvYniB9WIh3e4TUxzoAFtUlJJCBNv4ljnB92NGLd7ojz4rqIpuzXreuPK+P+JV51zz8It+0kgNXyec3xMha3Hx+DnFMxacGcerExIHMkzLeD95gb75/Kx5+a+1cFEbbNUo2FpwCydyr3+AOjiQD1hpOta2qsBCm7WXGddG275u1iEcTAzyR5mupKCB8GlHQxG1EJ59M0w8IiH8EZOoex+j/7wbJt2vinE6FyzdhbDV7w4M6IZqfIYLY3tIBqUgJlzxhBc7nG74h7Zh4YZBlCk7bjXGLLljMbaw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4Z6d5KIKeArS5BLaDE7ml+yDdsr31o2MwPa3vY22Ezo=;
 b=Y+boKq6D0ZRna8GB2ze9v5EXoJQ9NKRi4dlnaSPONwdGFcu6/3dso7juwX/APGRMff+3CalRtFkBe81E1ZuCaSY9+jfg34WnJK6/snzSABpjyKQNJ8hH+pLstXoQixKbGi8g4hqNRUCsjBDJU8aPWHv6M/Zu3GHcwnmRUpsqUpY=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1806.namprd15.prod.outlook.com (10.174.255.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.18; Fri, 9 Aug 2019 21:13:42 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.020; Fri, 9 Aug 2019
 21:13:42 +0000
From:   Tao Ren <taoren@fb.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [Potential Spoof] Re: [PATCH net-next v6 3/3] net: phy: broadcom:
 add 1000Base-X support for BCM54616S
Thread-Topic: [Potential Spoof] Re: [PATCH net-next v6 3/3] net: phy:
 broadcom: add 1000Base-X support for BCM54616S
Thread-Index: AQHVTnXbR0omRCjy/0G0ZEtUvAlu56bzQySAgAAJTACAAAVGAA==
Date:   Fri, 9 Aug 2019 21:13:42 +0000
Message-ID: <8f0e172b-575c-dab8-b695-c33dfc78fa8f@fb.com>
References: <20190809054411.1015962-1-taoren@fb.com>
 <97cd059c-d98e-1392-c814-f3bd628e6366@gmail.com>
 <e556dd17-ef85-3c61-bc08-17db02d9a5dc@fb.com>
In-Reply-To: <e556dd17-ef85-3c61-bc08-17db02d9a5dc@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR2101CA0005.namprd21.prod.outlook.com
 (2603:10b6:302:1::18) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:f2f1]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bd87fd71-a179-4da0-d9d3-08d71d0e74a1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1806;
x-ms-traffictypediagnostic: MWHPR15MB1806:
x-microsoft-antispam-prvs: <MWHPR15MB180684D229D8F3CED1A3301CB2D60@MWHPR15MB1806.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01244308DF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(346002)(376002)(199004)(189003)(446003)(6486002)(256004)(66446008)(11346002)(110136005)(36756003)(316002)(53936002)(186003)(99286004)(2906002)(71190400001)(31696002)(86362001)(2201001)(71200400001)(6246003)(64756008)(66476007)(14444005)(14454004)(66556008)(66946007)(478600001)(52116002)(65956001)(53546011)(5660300002)(476003)(65826007)(102836004)(386003)(6506007)(65806001)(486006)(2501003)(6116002)(76176011)(81156014)(2616005)(25786009)(81166006)(8936002)(229853002)(6512007)(31686004)(7416002)(64126003)(58126008)(7736002)(6436002)(46003)(305945005)(8676002)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1806;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uulIP/gOKx93SJVuF1yPj3zZAJietVlBnZbiHLUrEe+drtAFBoO25XsjIv7YU6TvpYs3/UdoXRuZdvWpSgYyjSUDuKFUk8TlfMImJP+4OzYJI77LLnj9VI0lV5RguATq423Kpb+v+bFdH7lDuyAYteAHGJ+BKXCLNq0+fS8bYT+2CtR89RSDynoWI9B05sqKBSdMOA0Ltj4SWIVgcJHiQfthE4rM0dxX5mSudPdlLRk+qf/SuUiZGTnRTdFBt3sNW0ZYlhuegjq3RNhgrAWe5CGBWZNBaJ0s64fHht1XMjZaVGovL8rO+RsLL8QTY8a4i8UfOaL1edMN3ldrG3S5+Ipb8bf4Aq8UhKLryau3YLB+pDxLvWhjjZg/gJVDtd+quqMug14su2Pu7gqfja6Q5pO9bIGtXlZeYNeYzUpWb3c=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDF41FFE4A1A3440A4F9D6D35CE35EA6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bd87fd71-a179-4da0-d9d3-08d71d0e74a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Aug 2019 21:13:42.1645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: O6HycVSBLPA+C5r9Ud9g4/6ysJ0n8GLSOa1lLsPUSMGv4PDD/fYIdXTyVTVU0IPB
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1806
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-09_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908090206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC85LzE5IDE6NTQgUE0sIFRhbyBSZW4gd3JvdGU6DQo+IEhpIEhlaW5lciwNCj4gDQo+IE9u
IDgvOS8xOSAxOjIxIFBNLCBIZWluZXIgS2FsbHdlaXQgd3JvdGU6DQo+PiBPbiAwOS4wOC4yMDE5
IDA3OjQ0LCBUYW8gUmVuIHdyb3RlOg0KPj4+IFRoZSBCQ001NDYxNlMgUEhZIGNhbm5vdCB3b3Jr
IHByb3Blcmx5IGluIFJHTUlJLT4xMDAwQmFzZS1LWCBtb2RlIChmb3INCj4+PiBleGFtcGxlLCBv
biBGYWNlYm9vayBDTU0gQk1DIHBsYXRmb3JtKSwgbWFpbmx5IGJlY2F1c2UgZ2VucGh5IGZ1bmN0
aW9ucw0KPj4+IGFyZSBkZXNpZ25lZCBmb3IgY29wcGVyIGxpbmtzLCBhbmQgMTAwMEJhc2UtWCAo
Y2xhdXNlIDM3KSBhdXRvIG5lZ290aWF0aW9uDQo+Pj4gbmVlZHMgdG8gYmUgaGFuZGxlZCBkaWZm
ZXJlbnRseS4NCj4+Pg0KPj4+IFRoaXMgcGF0Y2ggZW5hYmxlcyAxMDAwQmFzZS1YIHN1cHBvcnQg
Zm9yIEJDTTU0NjE2UyBieSBjdXN0b21pemluZyAzDQo+Pj4gZHJpdmVyIGNhbGxiYWNrczoNCj4+
Pg0KPj4+ICAgLSBwcm9iZTogcHJvYmUgY2FsbGJhY2sgZGV0ZWN0cyBQSFkncyBvcGVyYXRpb24g
bW9kZSBiYXNlZCBvbg0KPj4+ICAgICBJTlRFUkZfU0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAw
Rlggc2VsZWN0aW9uIGJpdCBpbiBTZXJERVMgMTAwLUZYDQo+Pj4gICAgIENvbnRyb2wgcmVnaXN0
ZXIuDQo+Pj4NCj4+PiAgIC0gY29uZmlnX2FuZWc6IGNhbGxzIGdlbnBoeV9jMzdfY29uZmlnX2Fu
ZWcgd2hlbiB0aGUgUEhZIGlzIHJ1bm5pbmcgaW4NCj4+PiAgICAgMTAwMEJhc2UtWCBtb2RlOyBv
dGhlcndpc2UsIGdlbnBoeV9jb25maWdfYW5lZyB3aWxsIGJlIGNhbGxlZC4NCj4+Pg0KPj4+ICAg
LSByZWFkX3N0YXR1czogY2FsbHMgZ2VucGh5X2MzN19yZWFkX3N0YXR1cyB3aGVuIHRoZSBQSFkg
aXMgcnVubmluZyBpbg0KPj4+ICAgICAxMDAwQmFzZS1YIG1vZGU7IG90aGVyd2lzZSwgZ2VucGh5
X3JlYWRfc3RhdHVzIHdpbGwgYmUgY2FsbGVkLg0KPj4+DQo+Pj4gU2lnbmVkLW9mZi1ieTogVGFv
IFJlbiA8dGFvcmVuQGZiLmNvbT4NCj4+PiAtLS0NCj4+PiAgQ2hhbmdlcyBpbiB2NjoNCj4+PiAg
IC0gbm90aGluZyBjaGFuZ2VkLg0KPj4+ICBDaGFuZ2VzIGluIHY1Og0KPj4+ICAgLSBpbmNsdWRl
IEhlaW5lcidzIHBhdGNoICJuZXQ6IHBoeTogYWRkIHN1cHBvcnQgZm9yIGNsYXVzZSAzNw0KPj4+
ICAgICBhdXRvLW5lZ290aWF0aW9uIiBpbnRvIHRoZSBzZXJpZXMuDQo+Pj4gICAtIHVzZSBnZW5w
aHlfYzM3X2NvbmZpZ19hbmVnIGFuZCBnZW5waHlfYzM3X3JlYWRfc3RhdHVzIGluIEJDTTU0NjE2
Uw0KPj4+ICAgICBQSFkgZHJpdmVyJ3MgY2FsbGJhY2sgd2hlbiB0aGUgUEhZIGlzIHJ1bm5pbmcg
aW4gMTAwMEJhc2UtWCBtb2RlLg0KPj4+ICBDaGFuZ2VzIGluIHY0Og0KPj4+ICAgLSBhZGQgYmNt
NTQ2MTZzX2NvbmZpZ19hbmVnXzEwMDBieCgpIHRvIGRlYWwgd2l0aCBhdXRvIG5lZ290aWF0aW9u
IGluDQo+Pj4gICAgIDEwMDBCYXNlLVggbW9kZS4NCj4+PiAgQ2hhbmdlcyBpbiB2MzoNCj4+PiAg
IC0gcmVuYW1lIGJjbTU0ODJfcmVhZF9zdGF0dXMgdG8gYmNtNTR4eF9yZWFkX3N0YXR1cyBzbyB0
aGUgY2FsbGJhY2sgY2FuDQo+Pj4gICAgIGJlIHNoYXJlZCBieSBCQ001NDgyIGFuZCBCQ001NDYx
NlMuDQo+Pj4gIENoYW5nZXMgaW4gdjI6DQo+Pj4gICAtIEF1dG8tZGV0ZWN0IFBIWSBvcGVyYXRp
b24gbW9kZSBpbnN0ZWFkIG9mIHBhc3NpbmcgRFQgbm9kZS4NCj4+PiAgIC0gbW92ZSBQSFkgbW9k
ZSBhdXRvLWRldGVjdCBsb2dpYyBmcm9tIGNvbmZpZ19pbml0IHRvIHByb2JlIGNhbGxiYWNrLg0K
Pj4+ICAgLSBvbmx5IHNldCBzcGVlZCAobm90IGluY2x1ZGluZyBkdXBsZXgpIGluIHJlYWRfc3Rh
dHVzIGNhbGxiYWNrLg0KPj4+ICAgLSB1cGRhdGUgcGF0Y2ggZGVzY3JpcHRpb24gd2l0aCBtb3Jl
IGJhY2tncm91bmQgdG8gYXZvaWQgY29uZnVzaW9uLg0KPj4+ICAgLSBwYXRjaCAjMSBpbiB0aGUg
c2VyaWVzICgibmV0OiBwaHk6IGJyb2FkY29tOiBzZXQgZmVhdHVyZXMgZXhwbGljaXRseQ0KPj4+
ICAgICBmb3IgQkNNNTQ2MTYiKSBpcyBkcm9wcGVkOiB0aGUgZml4IHNob3VsZCBnbyB0byBnZXRf
ZmVhdHVyZXMgY2FsbGJhY2sNCj4+PiAgICAgd2hpY2ggbWF5IHBvdGVudGlhbGx5IGRlcGVuZCBv
biB0aGlzIHBhdGNoLg0KPj4+DQo+Pj4gIGRyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jIHwgNTQg
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0NCj4+PiAgaW5jbHVkZS9saW51
eC9icmNtcGh5LmggICAgfCAxMCArKysrKy0tDQo+Pj4gIDIgZmlsZXMgY2hhbmdlZCwgNTggaW5z
ZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkNCj4+Pg0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L25ldC9waHkvYnJvYWRjb20uYyBiL2RyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jDQo+Pj4gaW5k
ZXggOTM3ZDAwNTllOGFjLi5mYmQ3NmEzMWMxNDIgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9u
ZXQvcGh5L2Jyb2FkY29tLmMNCj4+PiArKysgYi9kcml2ZXJzL25ldC9waHkvYnJvYWRjb20uYw0K
Pj4+IEBAIC0zODMsOSArMzgzLDkgQEAgc3RhdGljIGludCBiY201NDgyX2NvbmZpZ19pbml0KHN0
cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+Pj4gIAkJLyoNCj4+PiAgCQkgKiBTZWxlY3QgMTAw
MEJBU0UtWCByZWdpc3RlciBzZXQgKHByaW1hcnkgU2VyRGVzKQ0KPj4+ICAJCSAqLw0KPj4+IC0J
CXJlZyA9IGJjbV9waHlfcmVhZF9zaGFkb3cocGh5ZGV2LCBCQ001NDgyX1NIRF9NT0RFKTsNCj4+
PiAtCQliY21fcGh5X3dyaXRlX3NoYWRvdyhwaHlkZXYsIEJDTTU0ODJfU0hEX01PREUsDQo+Pj4g
LQkJCQkgICAgIHJlZyB8IEJDTTU0ODJfU0hEX01PREVfMTAwMEJYKTsNCj4+PiArCQlyZWcgPSBi
Y21fcGh5X3JlYWRfc2hhZG93KHBoeWRldiwgQkNNNTRYWF9TSERfTU9ERSk7DQo+Pj4gKwkJYmNt
X3BoeV93cml0ZV9zaGFkb3cocGh5ZGV2LCBCQ001NFhYX1NIRF9NT0RFLA0KPj4+ICsJCQkJICAg
ICByZWcgfCBCQ001NFhYX1NIRF9NT0RFXzEwMDBCWCk7DQo+Pj4gIA0KPj4+ICAJCS8qDQo+Pj4g
IAkJICogTEVEMT1BQ1RJVklUWUxFRCwgTEVEMz1MSU5LU1BEWzJdDQo+Pj4gQEAgLTQ1MSwxMiAr
NDUxLDQ0IEBAIHN0YXRpYyBpbnQgYmNtNTQ4MV9jb25maWdfYW5lZyhzdHJ1Y3QgcGh5X2Rldmlj
ZSAqcGh5ZGV2KQ0KPj4+ICAJcmV0dXJuIHJldDsNCj4+PiAgfQ0KPj4+ICANCj4+PiArc3RhdGlj
IGludCBiY201NDYxNnNfcHJvYmUoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+PiArew0K
Pj4+ICsJaW50IHZhbCwgaW50Zl9zZWw7DQo+Pj4gKw0KPj4+ICsJdmFsID0gYmNtX3BoeV9yZWFk
X3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01PREUpOw0KPj4+ICsJaWYgKHZhbCA8IDApDQo+
Pj4gKwkJcmV0dXJuIHZhbDsNCj4+PiArDQo+Pj4gKwkvKiBUaGUgUEhZIGlzIHN0cmFwcGVkIGlu
IFJHTUlJIHRvIGZpYmVyIG1vZGUgd2hlbiBJTlRFUkZfU0VMWzE6MF0NCj4+PiArCSAqIGlzIDAx
Yi4NCj4+PiArCSAqLw0KPj4+ICsJaW50Zl9zZWwgPSAodmFsICYgQkNNNTRYWF9TSERfSU5URl9T
RUxfTUFTSykgPj4gMTsNCj4+PiArCWlmIChpbnRmX3NlbCA9PSAxKSB7DQo+Pj4gKwkJdmFsID0g
YmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0NjE2U19TSERfMTAwRlhfQ1RSTCk7DQo+
Pj4gKwkJaWYgKHZhbCA8IDApDQo+Pj4gKwkJCXJldHVybiB2YWw7DQo+Pj4gKw0KPj4+ICsJCS8q
IEJpdCAwIG9mIHRoZSBTZXJEZXMgMTAwLUZYIENvbnRyb2wgcmVnaXN0ZXIsIHdoZW4gc2V0DQo+
Pj4gKwkJICogdG8gMSwgc2V0cyB0aGUgTUlJL1JHTUlJIC0+IDEwMEJBU0UtRlggY29uZmlndXJh
dGlvbi4NCj4+PiArCQkgKiBXaGVuIHRoaXMgYml0IGlzIHNldCB0byAwLCBpdCBzZXRzIHRoZSBH
TUlJL1JHTUlJIC0+DQo+Pj4gKwkJICogMTAwMEJBU0UtWCBjb25maWd1cmF0aW9uLg0KPj4+ICsJ
CSAqLw0KPj4+ICsJCWlmICghKHZhbCAmIEJDTTU0NjE2U18xMDBGWF9NT0RFKSkNCj4+PiArCQkJ
cGh5ZGV2LT5kZXZfZmxhZ3MgfD0gUEhZX0JDTV9GTEFHU19NT0RFXzEwMDBCWDsNCj4+PiArCX0N
Cj4+PiArDQo+Pj4gKwlyZXR1cm4gMDsNCj4+PiArfQ0KPj4+ICsNCj4+PiAgc3RhdGljIGludCBi
Y201NDYxNnNfY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4+PiAgew0K
Pj4+ICAJaW50IHJldDsNCj4+PiAgDQo+Pj4gIAkvKiBBbmVnIGZpcnNseS4gKi8NCj4+PiAtCXJl
dCA9IGdlbnBoeV9jb25maWdfYW5lZyhwaHlkZXYpOw0KPj4+ICsJaWYgKHBoeWRldi0+ZGV2X2Zs
YWdzICYgUEhZX0JDTV9GTEFHU19NT0RFXzEwMDBCWCkNCj4+PiArCQlyZXQgPSBnZW5waHlfYzM3
X2NvbmZpZ19hbmVnKHBoeWRldik7DQo+Pj4gKwllbHNlDQo+Pj4gKwkJcmV0ID0gZ2VucGh5X2Nv
bmZpZ19hbmVnKHBoeWRldik7DQo+Pj4gIA0KPj4NCj4+IEknbSBqdXN0IHdvbmRlcmluZyB3aGV0
aGVyIGl0IG5lZWRzIHRvIGJlIGNvbnNpZGVyZWQgdGhhdCAxMDBiYXNlLUZYDQo+PiBkb2Vzbid0
IHN1cHBvcnQgYXV0by1uZWdvdGlhdGlvbi4gSSBzdXBwb3NlIEJNU1IgcmVwb3J0cyBhbmVnIGFz
DQo+PiBzdXBwb3J0ZWQsIHRoZXJlZm9yZSBwaHlsaWIgd2lsbCB1c2UgYW5lZyBwZXIgZGVmYXVs
dC4NCj4+IE5vdCBzdXJlIHdobyBjb3VsZCBzZXQgMTAwQmFzZS1GWCBtb2RlIHdoZW4sIGJ1dCBt
YXliZSBhdCB0aGF0IHBsYWNlDQo+PiBhbHNvIHBoeWRldi0+YXV0b25lZyBuZWVkcyB0byBiZSBj
bGVhcmVkLiBEaWQgeW91IHRlc3QgMTAwQmFzZS1GWCBtb2RlPw0KPiANCj4gSSdtIGRvdWJ0aW5n
IGlmIDEwMEJhc2UtRlggd29ya3MuIEJlc2lkZXMgYXV0by1uZWdvdGlhdGlvbiwgMTAwQmFzZS1G
WCBDb250cm9sL1N0YXR1cyByZWdpc3RlcnMgYXJlIGRlZmluZWQgaW4gc2hhZG93IHJlZ2lzdGVy
IGluc3RlYWQgb2YgTUlJX0JNQ1IgYW5kIE1JSV9CTVNSLg0KPiANCj4gVW5mb3J0dW5hdGVseSBJ
IGRvbid0IGhhdmUgZW52aXJvbm1lbnQgdG8gdGVzdCAxMDBCYXNlLUZYIGFuZCB0aGF0J3Mgd2h5
IEkgb25seSBtYWtlIGNoYW5nZXMgd2hlbiB0aGUgUEhZIGlzIHdvcmtpbmcgaW4gMTAwMFggbW9k
ZS4NCg0KSSBjYW4gcHJlcGFyZSBhIHBhdGNoIGZvciAxMDBCYXNlLUZYIGJhc2VkIG9uIG15IHVu
ZGVyc3RhbmRpbmcgb2YgYmNtNTQ2MTZzIGRhdGFzaGVldCwgYnV0IHRoZSBwYXRjaCB3b3VsZCBi
ZSBqdXN0IGNvbXBpbGUtdGVzdGVkIA0KDQoNClRoYW5rcywNCg0KVGFvDQo=
