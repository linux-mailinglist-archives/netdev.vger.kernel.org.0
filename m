Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 805B4B2769
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 23:42:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389794AbfIMVls (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 17:41:48 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1306 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727985AbfIMVlr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Sep 2019 17:41:47 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8DLe6j0002930;
        Fri, 13 Sep 2019 14:41:28 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XjmsHRvZUNZfJ6ZjZm+R1kSx4l6eicHcBcQ29QZ6HZw=;
 b=nLzpNKjXf3jEBX9eCbdpaxEtbJnljc1lAd8FLY3FlUYglcFsl02MyjVODzdWLpS/cSC7
 o5CwLWxKmod7GPnXBDz54eHcPzOzChGWPHBLTadI97HoV1elrIdzDdcOUby5mm7sK1kG
 dAVgO/lgVR21UC2SxAgBIQDtcE/ma8VBxfE= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2v0k5980ke-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 13 Sep 2019 14:41:28 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub01.TheFacebook.com (2620:10d:c081:35::125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 13 Sep 2019 14:41:26 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 13 Sep 2019 14:41:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OeRX2CqCo9m+FvUqlymV5VvveEtp+oRZjIYmTjDgi4mfgp5pDrtgU/y7DQQej/LsUQNkuy8UjSo1haYnPWzcYa2dIkfCiIn11EEzTV3toc6yAJ2EwMb1FWJA/4EnZEJsycUUdbXtHy+RT9LfzPhY6igOS2lP+Vb/kNVUqv1Mgq3N0/L9ZP+rRBt+f6L7qdS8c54tEDyOM3OyXmNG5qTU8yaZakI/FcGFWbmvoJvahhpCebyj9G6Q2M8TfNaTdy2heLGEhyN7+OIozbuDUuBAzc9mFZi3Vkn+uDOvgrRRY1t+YjWKwpy3ioCImjtfz5w8OdpwOlkDLVR+c9Kz0fVfPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjmsHRvZUNZfJ6ZjZm+R1kSx4l6eicHcBcQ29QZ6HZw=;
 b=oOm9zaX2HIiLq31wfJJTXHqZNYZ/BWV5ecHN8MSXrs+/361EpZflK7WGtXvujhmq1OYshnoyPY012B1QdGH0ALxAx4urtv4cmpu/S9Qx5Zki0z8DwOhPYBYzmJuY44GAN+GN15gB08cfjusnKtdPSPm0OqKsV1/1AelBE1W23aTWBChvPnSObnjwxWWv2kiDUm8KJryV9o2+JzaWT2RUtZWMFrIyhOut8iUInuQ0LzYiHK51MWyB5ssaRAkizPg/0FxJzAt8rKpgbfqVrf7nkLimkZCoYvOx1+OlYrgXQnJAm6PdTkpkKt9dRKNhOtgbqAaOhlFV025rS6Ps+QsaUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XjmsHRvZUNZfJ6ZjZm+R1kSx4l6eicHcBcQ29QZ6HZw=;
 b=f4/Ojiust9MxcKkLrrn/9uaB7RsG61Ecwbp4O2ElD9HE9KC0ivlKG8dy/72hHkUSZKa00VzlA64y483cIK5UMya5bgY/ahNMsBDytq+5XmSNLeuzFwRfm/7+yoxBEZUpdxqOhUexI5utCbVUs9eCefRi+ysjaCgpi5ig3i4y+wo=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3351.namprd15.prod.outlook.com (20.179.58.157) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2263.15; Fri, 13 Sep 2019 21:41:25 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2263.021; Fri, 13 Sep 2019
 21:41:25 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "clang-built-linux@googlegroups.com" 
        <clang-built-linux@googlegroups.com>
Subject: Re: [PATCH bpf-next 08/11] samples: bpf: makefile: base progs build
 on makefile.progs
Thread-Topic: [PATCH bpf-next 08/11] samples: bpf: makefile: base progs build
 on makefile.progs
Thread-Index: AQHVZ8PznGyUAwk23kqpi7ed59o4GacqKG+A
Date:   Fri, 13 Sep 2019 21:41:25 +0000
Message-ID: <dd4cd83f-7e35-ad07-8a53-d34c13c074a5@fb.com>
References: <20190910103830.20794-1-ivan.khoronzhuk@linaro.org>
 <20190910103830.20794-9-ivan.khoronzhuk@linaro.org>
In-Reply-To: <20190910103830.20794-9-ivan.khoronzhuk@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR06CA0030.namprd06.prod.outlook.com
 (2603:10b6:301:39::43) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::ec5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccbeac9b-4051-4e8a-8f6a-08d738932082
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3351;
x-ms-traffictypediagnostic: BYAPR15MB3351:
x-microsoft-antispam-prvs: <BYAPR15MB3351548CE1073B1A1B1D960CD3B30@BYAPR15MB3351.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:632;
x-forefront-prvs: 0159AC2B97
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(6436002)(102836004)(6506007)(386003)(5660300002)(5024004)(316002)(446003)(99286004)(46003)(53546011)(2501003)(256004)(11346002)(52116002)(14444005)(25786009)(31686004)(14454004)(6246003)(86362001)(31696002)(76176011)(110136005)(7736002)(71190400001)(71200400001)(305945005)(2201001)(54906003)(66574012)(7416002)(4326008)(486006)(2906002)(66446008)(66556008)(2616005)(476003)(53936002)(81156014)(8936002)(36756003)(81166006)(6486002)(66476007)(64756008)(6116002)(229853002)(478600001)(186003)(8676002)(66946007)(6512007);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3351;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 3ZdB8rS4rNonS+U4r2jg4a+1NX5IhNwaqu1weoD0Ea3LyRywafwLb7cvbj2qnKqWx7GZDqA9M12ado2SqQBqWZ4Yn5GWKaEKV8uhV4XTZYSSLE3hd9KxZH6PaDRbpl8wZPWxI59nqkb+LSo7pCYwDivYKWDgeJ6HeXOChkHfklWhUOXyCE784k+oHp531JlavNxDEU+u7Ln3O/DShsqlAviC64rAVwvr+7FW9oSDUqmi/AhnoEmSIRUdshrh0euchl78CFirbytBeRWI7OxMwqa6J1yCF/vfgkZfme8lAW/t/+EbxYy2MDUOqWGrF5jtM2/0oLEd0jgts/w1YY69vK0Fz5x/77AdsJiWmYGen00gPoffwYY0zNApwyWl2vsgRiwiSXGY8U4j9ulfjO32xwUBkS9kxQ7/As+JbrgQako=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <A835652B442A6E43ADB95B84E08460AF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ccbeac9b-4051-4e8a-8f6a-08d738932082
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2019 21:41:25.4998
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SedmU6vP2UmcVPEeJd1pIDViBB5q6GMKtUQPa5SATxn5QCA/TX6ETmHvfeW7hU8B
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3351
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-13_10:2019-09-11,2019-09-13 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 malwarescore=0 spamscore=0 lowpriorityscore=0 clxscore=1015 mlxscore=0
 bulkscore=0 suspectscore=0 impostorscore=0 priorityscore=1501
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1909130215
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvMTAvMTkgMTE6MzggQU0sIEl2YW4gS2hvcm9uemh1ayB3cm90ZToNCj4gVGhlIG1h
aW4gcmVhc29uIGZvciB0aGF0IC0gSE9TVENDIGFuZCBDQyBoYXZlIGRpZmZlcmVudCBhaW1zLg0K
PiBJdCB3YXMgdGVzdGVkIGZvciBhcm0gY3Jvc3MgY29tcGlsYXRpb24sIGJhc2VkIG9uIGxpbmFy
byB0b29sY2hhaW4sDQo+IGJ1dCBzaG91bGQgd29yayBmb3Igb3RoZXJzLg0KPiANCj4gSW4gb3Jk
ZXIgdG8gc3BsaXQgY3Jvc3MgY29tcGlsYXRpb24gKENDKSB3aXRoIGhvc3QgYnVpbGQgKEhPU1RD
QyksDQo+IGxldHMgYmFzZSBicGYgc2FtcGxlcyBvbiBNYWtlZmlsZS5wcm9ncy4gSXQgYWxsb3dz
IHRvIGNyb3NzLWNvbXBpbGUNCj4gc2FtcGxlcy9icGYgcHJvZ3Mgd2l0aCBDQyB3aGlsZSBhdXhp
YWxyeSB0b29scyBydW5uaW5nIG9uIGhvc3QgYnVpbHQNCj4gd2l0aCBIT1NUQ0MuDQoNCkkgZ290
IGEgY29tcGlsYXRpb24gZmFpbHVyZSB3aXRoIHRoZSBmb2xsb3dpbmcgZXJyb3INCg0KJCBtYWtl
IHNhbXBsZXMvYnBmLw0KICAgLi4uDQogICBMRCAgc2FtcGxlcy9icGYvaGJtDQogICBDQyAgICAg
IHNhbXBsZXMvYnBmL3N5c2NhbGxfbnJzLnMNCmdjYzogZXJyb3I6IC1wZyBhbmQgLWZvbWl0LWZy
YW1lLXBvaW50ZXIgYXJlIGluY29tcGF0aWJsZQ0KbWFrZVsyXTogKioqIFtzYW1wbGVzL2JwZi9z
eXNjYWxsX25ycy5zXSBFcnJvciAxDQptYWtlWzFdOiAqKiogW3NhbXBsZXMvYnBmL10gRXJyb3Ig
Mg0KbWFrZTogKioqIFtzdWItbWFrZV0gRXJyb3IgMg0KDQpDb3VsZCB5b3UgdGFrZSBhIGxvb2s/
DQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEl2YW4gS2hvcm9uemh1ayA8aXZhbi5raG9yb256aHVr
QGxpbmFyby5vcmc+DQo+IC0tLQ0KPiAgIHNhbXBsZXMvYnBmL01ha2VmaWxlIHwgMTM4ICsrKysr
KysrKysrKysrKysrKysrKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgNzMgaW5zZXJ0aW9ucygrKSwgNjUgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
c2FtcGxlcy9icGYvTWFrZWZpbGUgYi9zYW1wbGVzL2JwZi9NYWtlZmlsZQ0KPiBpbmRleCBmNWRi
ZjNkMGM1ZjMuLjYyNWE3MWYyZTlkMiAxMDA2NDQNCj4gLS0tIGEvc2FtcGxlcy9icGYvTWFrZWZp
bGUNCj4gKysrIGIvc2FtcGxlcy9icGYvTWFrZWZpbGUNCj4gQEAgLTQsNTUgKzQsNTMgQEAgQlBG
X1NBTVBMRVNfUEFUSCA/PSAkKGFic3BhdGggJChzcmN0cmVlKS8kKHNyYykpDQo+ICAgVE9PTFNf
UEFUSCA6PSAkKEJQRl9TQU1QTEVTX1BBVEgpLy4uLy4uL3Rvb2xzDQo+ICAgDQo+ICAgIyBMaXN0
IG9mIHByb2dyYW1zIHRvIGJ1aWxkDQo+IC1ob3N0cHJvZ3MteSA6PSB0ZXN0X2xydV9kaXN0DQo+
IC1ob3N0cHJvZ3MteSArPSBzb2NrX2V4YW1wbGUNCj4gLWhvc3Rwcm9ncy15ICs9IGZkc19leGFt
cGxlDQo+IC1ob3N0cHJvZ3MteSArPSBzb2NrZXgxDQo+IC1ob3N0cHJvZ3MteSArPSBzb2NrZXgy
DQo+IC1ob3N0cHJvZ3MteSArPSBzb2NrZXgzDQo+IC1ob3N0cHJvZ3MteSArPSB0cmFjZXgxDQo+
IC1ob3N0cHJvZ3MteSArPSB0cmFjZXgyDQo+IC1ob3N0cHJvZ3MteSArPSB0cmFjZXgzDQo+IC1o
b3N0cHJvZ3MteSArPSB0cmFjZXg0DQo+IC1ob3N0cHJvZ3MteSArPSB0cmFjZXg1DQo+IC1ob3N0
cHJvZ3MteSArPSB0cmFjZXg2DQo+IC1ob3N0cHJvZ3MteSArPSB0cmFjZXg3DQo+IC1ob3N0cHJv
Z3MteSArPSB0ZXN0X3Byb2JlX3dyaXRlX3VzZXINCj4gLWhvc3Rwcm9ncy15ICs9IHRyYWNlX291
dHB1dA0KPiAtaG9zdHByb2dzLXkgKz0gbGF0aGlzdA0KPiAtaG9zdHByb2dzLXkgKz0gb2Zmd2Fr
ZXRpbWUNCj4gLWhvc3Rwcm9ncy15ICs9IHNwaW50ZXN0DQo+IC1ob3N0cHJvZ3MteSArPSBtYXBf
cGVyZl90ZXN0DQo+IC1ob3N0cHJvZ3MteSArPSB0ZXN0X292ZXJoZWFkDQo+IC1ob3N0cHJvZ3Mt
eSArPSB0ZXN0X2NncnAyX2FycmF5X3Bpbg0KPiAtaG9zdHByb2dzLXkgKz0gdGVzdF9jZ3JwMl9h
dHRhY2gNCj4gLWhvc3Rwcm9ncy15ICs9IHRlc3RfY2dycDJfc29jaw0KPiAtaG9zdHByb2dzLXkg
Kz0gdGVzdF9jZ3JwMl9zb2NrMg0KPiAtaG9zdHByb2dzLXkgKz0geGRwMQ0KPiAtaG9zdHByb2dz
LXkgKz0geGRwMg0KPiAtaG9zdHByb2dzLXkgKz0geGRwX3JvdXRlcl9pcHY0DQo+IC1ob3N0cHJv
Z3MteSArPSB0ZXN0X2N1cnJlbnRfdGFza191bmRlcl9jZ3JvdXANCj4gLWhvc3Rwcm9ncy15ICs9
IHRyYWNlX2V2ZW50DQo+IC1ob3N0cHJvZ3MteSArPSBzYW1wbGVpcA0KPiAtaG9zdHByb2dzLXkg
Kz0gdGNfbDJfcmVkaXJlY3QNCj4gLWhvc3Rwcm9ncy15ICs9IGx3dF9sZW5faGlzdA0KPiAtaG9z
dHByb2dzLXkgKz0geGRwX3R4X2lwdHVubmVsDQo+IC1ob3N0cHJvZ3MteSArPSB0ZXN0X21hcF9p
bl9tYXANCj4gLWhvc3Rwcm9ncy15ICs9IHBlcl9zb2NrZXRfc3RhdHNfZXhhbXBsZQ0KPiAtaG9z
dHByb2dzLXkgKz0geGRwX3JlZGlyZWN0DQo+IC1ob3N0cHJvZ3MteSArPSB4ZHBfcmVkaXJlY3Rf
bWFwDQo+IC1ob3N0cHJvZ3MteSArPSB4ZHBfcmVkaXJlY3RfY3B1DQo+IC1ob3N0cHJvZ3MteSAr
PSB4ZHBfbW9uaXRvcg0KPiAtaG9zdHByb2dzLXkgKz0geGRwX3J4cV9pbmZvDQo+IC1ob3N0cHJv
Z3MteSArPSBzeXNjYWxsX3RwDQo+IC1ob3N0cHJvZ3MteSArPSBjcHVzdGF0DQo+IC1ob3N0cHJv
Z3MteSArPSB4ZHBfYWRqdXN0X3RhaWwNCj4gLWhvc3Rwcm9ncy15ICs9IHhkcHNvY2sNCj4gLWhv
c3Rwcm9ncy15ICs9IHhkcF9md2QNCj4gLWhvc3Rwcm9ncy15ICs9IHRhc2tfZmRfcXVlcnkNCj4g
LWhvc3Rwcm9ncy15ICs9IHhkcF9zYW1wbGVfcGt0cw0KPiAtaG9zdHByb2dzLXkgKz0gaWJ1bWFk
DQo+IC1ob3N0cHJvZ3MteSArPSBoYm0NCj4gK3Byb2dzLXkgOj0gdGVzdF9scnVfZGlzdA0KPiAr
cHJvZ3MteSArPSBzb2NrX2V4YW1wbGUNCj4gK3Byb2dzLXkgKz0gZmRzX2V4YW1wbGUNCj4gK3By
b2dzLXkgKz0gc29ja2V4MQ0KPiArcHJvZ3MteSArPSBzb2NrZXgyDQo+ICtwcm9ncy15ICs9IHNv
Y2tleDMNCj4gK3Byb2dzLXkgKz0gdHJhY2V4MQ0KPiArcHJvZ3MteSArPSB0cmFjZXgyDQo+ICtw
cm9ncy15ICs9IHRyYWNleDMNCj4gK3Byb2dzLXkgKz0gdHJhY2V4NA0KPiArcHJvZ3MteSArPSB0
cmFjZXg1DQo+ICtwcm9ncy15ICs9IHRyYWNleDYNCj4gK3Byb2dzLXkgKz0gdHJhY2V4Nw0KPiAr
cHJvZ3MteSArPSB0ZXN0X3Byb2JlX3dyaXRlX3VzZXINCj4gK3Byb2dzLXkgKz0gdHJhY2Vfb3V0
cHV0DQo+ICtwcm9ncy15ICs9IGxhdGhpc3QNCj4gK3Byb2dzLXkgKz0gb2Zmd2FrZXRpbWUNCj4g
K3Byb2dzLXkgKz0gc3BpbnRlc3QNCj4gK3Byb2dzLXkgKz0gbWFwX3BlcmZfdGVzdA0KPiArcHJv
Z3MteSArPSB0ZXN0X292ZXJoZWFkDQo+ICtwcm9ncy15ICs9IHRlc3RfY2dycDJfYXJyYXlfcGlu
DQo+ICtwcm9ncy15ICs9IHRlc3RfY2dycDJfYXR0YWNoDQo+ICtwcm9ncy15ICs9IHRlc3RfY2dy
cDJfc29jaw0KPiArcHJvZ3MteSArPSB0ZXN0X2NncnAyX3NvY2syDQo+ICtwcm9ncy15ICs9IHhk
cDENCj4gK3Byb2dzLXkgKz0geGRwMg0KPiArcHJvZ3MteSArPSB4ZHBfcm91dGVyX2lwdjQNCj4g
K3Byb2dzLXkgKz0gdGVzdF9jdXJyZW50X3Rhc2tfdW5kZXJfY2dyb3VwDQo+ICtwcm9ncy15ICs9
IHRyYWNlX2V2ZW50DQo+ICtwcm9ncy15ICs9IHNhbXBsZWlwDQo+ICtwcm9ncy15ICs9IHRjX2wy
X3JlZGlyZWN0DQo+ICtwcm9ncy15ICs9IGx3dF9sZW5faGlzdA0KPiArcHJvZ3MteSArPSB4ZHBf
dHhfaXB0dW5uZWwNCj4gK3Byb2dzLXkgKz0gdGVzdF9tYXBfaW5fbWFwDQo+ICtwcm9ncy15ICs9
IHhkcF9yZWRpcmVjdF9tYXANCj4gK3Byb2dzLXkgKz0geGRwX3JlZGlyZWN0X2NwdQ0KPiArcHJv
Z3MteSArPSB4ZHBfbW9uaXRvcg0KPiArcHJvZ3MteSArPSB4ZHBfcnhxX2luZm8NCj4gK3Byb2dz
LXkgKz0gc3lzY2FsbF90cA0KPiArcHJvZ3MteSArPSBjcHVzdGF0DQo+ICtwcm9ncy15ICs9IHhk
cF9hZGp1c3RfdGFpbA0KPiArcHJvZ3MteSArPSB4ZHBzb2NrDQo+ICtwcm9ncy15ICs9IHhkcF9m
d2QNCj4gK3Byb2dzLXkgKz0gdGFza19mZF9xdWVyeQ0KPiArcHJvZ3MteSArPSB4ZHBfc2FtcGxl
X3BrdHMNCj4gK3Byb2dzLXkgKz0gaWJ1bWFkDQo+ICtwcm9ncy15ICs9IGhibQ0KPiAgIA0KPiAg
ICMgTGliYnBmIGRlcGVuZGVuY2llcw0KPiAgIExJQkJQRiA9ICQoVE9PTFNfUEFUSCkvbGliL2Jw
Zi9saWJicGYuYQ0KPiBAQCAtMTExLDcgKzEwOSw3IEBAIGlidW1hZC1vYmpzIDo9IGJwZl9sb2Fk
Lm8gaWJ1bWFkX3VzZXIubyAkKFRSQUNFX0hFTFBFUlMpDQo+ICAgaGJtLW9ianMgOj0gYnBmX2xv
YWQubyBoYm0ubyAkKENHUk9VUF9IRUxQRVJTKQ0KPiAgIA0KPiAgICMgVGVsbCBrYnVpbGQgdG8g
YWx3YXlzIGJ1aWxkIHRoZSBwcm9ncmFtcw0KPiAtYWx3YXlzIDo9ICQoaG9zdHByb2dzLXkpDQo+
ICthbHdheXMgOj0gJChwcm9ncy15KQ0KPiAgIGFsd2F5cyArPSBzb2NrZXgxX2tlcm4ubw0KPiAg
IGFsd2F5cyArPSBzb2NrZXgyX2tlcm4ubw0KPiAgIGFsd2F5cyArPSBzb2NrZXgzX2tlcm4ubw0K
PiBAQCAtMTcwLDIxICsxNjgsNiBAQCBhbHdheXMgKz0gaWJ1bWFkX2tlcm4ubw0KPiAgIGFsd2F5
cyArPSBoYm1fb3V0X2tlcm4ubw0KPiAgIGFsd2F5cyArPSBoYm1fZWR0X2tlcm4ubw0KPiAgIA0K
PiAtS0JVSUxEX0hPU1RDRkxBR1MgKz0gLUkkKG9ianRyZWUpL3Vzci9pbmNsdWRlDQo+IC1LQlVJ
TERfSE9TVENGTEFHUyArPSAtSSQoc3JjdHJlZSkvdG9vbHMvbGliL2JwZi8NCj4gLUtCVUlMRF9I
T1NUQ0ZMQUdTICs9IC1JJChzcmN0cmVlKS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvDQo+
IC1LQlVJTERfSE9TVENGTEFHUyArPSAtSSQoc3JjdHJlZSkvdG9vbHMvbGliLyAtSSQoc3JjdHJl
ZSkvdG9vbHMvaW5jbHVkZQ0KPiAtS0JVSUxEX0hPU1RDRkxBR1MgKz0gLUkkKHNyY3RyZWUpL3Rv
b2xzL3BlcmYNCj4gLQ0KPiAtSE9TVENGTEFHU19icGZfbG9hZC5vICs9IC1Xbm8tdW51c2VkLXZh
cmlhYmxlDQo+IC0NCj4gLUtCVUlMRF9IT1NUTERMSUJTCQkrPSAkKExJQkJQRikgLWxlbGYNCj4g
LUhPU1RMRExJQlNfdHJhY2V4NAkJKz0gLWxydA0KPiAtSE9TVExETElCU190cmFjZV9vdXRwdXQJ
Kz0gLWxydA0KPiAtSE9TVExETElCU19tYXBfcGVyZl90ZXN0CSs9IC1scnQNCj4gLUhPU1RMRExJ
QlNfdGVzdF9vdmVyaGVhZAkrPSAtbHJ0DQo+IC1IT1NUTERMSUJTX3hkcHNvY2sJCSs9IC1wdGhy
ZWFkDQo+IC0NCj4gICAjIFN0cmlwIGFsbCBleHBldCAtRCBvcHRpb25zIG5lZWRlZCB0byBoYW5k
bGUgbGludXggaGVhZGVycw0KPiAgICMgZm9yIGFybSBpdCdzIF9fTElOVVhfQVJNX0FSQ0hfXyBh
bmQgcG90ZW50aWFsbHkgb3RoZXJzIGZvcmsgdmFycw0KPiAgIERfT1BUSU9OUyA9ICQoc2hlbGwg
ZWNobyAiJChLQlVJTERfQ0ZMQUdTKSAiIHwgc2VkICdzL1tbOmJsYW5rOl1dL1xuL2cnIHwgXA0K
PiBAQCAtMTk0LDYgKzE3NywyOSBAQCBpZmVxICgkKEFSQ0gpLCBhcm0pDQo+ICAgQ0xBTkdfRVhU
UkFfQ0ZMQUdTIDo9ICQoRF9PUFRJT05TKQ0KPiAgIGVuZGlmDQo+ICAgDQo+ICtjY2ZsYWdzLXkg
Kz0gLUkkKG9ianRyZWUpL3Vzci9pbmNsdWRlDQo+ICtjY2ZsYWdzLXkgKz0gLUkkKHNyY3RyZWUp
L3Rvb2xzL2xpYi9icGYvDQo+ICtjY2ZsYWdzLXkgKz0gLUkkKHNyY3RyZWUpL3Rvb2xzL3Rlc3Rp
bmcvc2VsZnRlc3RzL2JwZi8NCj4gK2NjZmxhZ3MteSArPSAtSSQoc3JjdHJlZSkvdG9vbHMvbGli
Lw0KPiArY2NmbGFncy15ICs9IC1JJChzcmN0cmVlKS90b29scy9pbmNsdWRlDQo+ICtjY2ZsYWdz
LXkgKz0gLUkkKHNyY3RyZWUpL3Rvb2xzL3BlcmYNCj4gK2NjZmxhZ3MteSArPSAkKERfT1BUSU9O
UykNCj4gK2NjZmxhZ3MteSArPSAtV2FsbA0KPiArY2NmbGFncy15ICs9IC1mb21pdC1mcmFtZS1w
b2ludGVyDQo+ICtjY2ZsYWdzLXkgKz0gLVdtaXNzaW5nLXByb3RvdHlwZXMNCj4gK2NjZmxhZ3Mt
eSArPSAtV3N0cmljdC1wcm90b3R5cGVzDQo+ICsNCj4gK1BST0dTX0NGTEFHUyA6PSAkKGNjZmxh
Z3MteSkNCj4gKw0KPiArUFJPR0NGTEFHU19icGZfbG9hZC5vICs9IC1Xbm8tdW51c2VkLXZhcmlh
YmxlDQo+ICsNCj4gK1BST0dTX0xETElCUwkJCTo9ICQoTElCQlBGKSAtbGVsZg0KPiArUFJPR0xE
TElCU190cmFjZXg0CQkrPSAtbHJ0DQo+ICtQUk9HTERMSUJTX3RyYWNlX291dHB1dAkJKz0gLWxy
dA0KPiArUFJPR0xETElCU19tYXBfcGVyZl90ZXN0CSs9IC1scnQNCj4gK1BST0dMRExJQlNfdGVz
dF9vdmVyaGVhZAkrPSAtbHJ0DQo+ICtQUk9HTERMSUJTX3hkcHNvY2sJCSs9IC1wdGhyZWFkDQo+
ICsNCj4gICAjIEFsbG93cyBwb2ludGluZyBMTEMvQ0xBTkcgdG8gYSBMTFZNIGJhY2tlbmQgd2l0
aCBicGYgc3VwcG9ydCwgcmVkZWZpbmUgb24gY21kbGluZToNCj4gICAjICBtYWtlIHNhbXBsZXMv
YnBmLyBMTEM9fi9naXQvbGx2bS9idWlsZC9iaW4vbGxjIENMQU5HPX4vZ2l0L2xsdm0vYnVpbGQv
YmluL2NsYW5nDQo+ICAgTExDID89IGxsYw0KPiBAQCAtMjg0LDYgKzI5MCw4IEBAICQob2JqKS9o
Ym1fb3V0X2tlcm4ubzogJChzcmMpL2hibS5oICQoc3JjKS9oYm1fa2Vybi5oDQo+ICAgJChvYmop
L2hibS5vOiAkKHNyYykvaGJtLmgNCj4gICAkKG9iaikvaGJtX2VkdF9rZXJuLm86ICQoc3JjKS9o
Ym0uaCAkKHNyYykvaGJtX2tlcm4uaA0KPiAgIA0KPiArLWluY2x1ZGUgJChCUEZfU0FNUExFU19Q
QVRIKS9NYWtlZmlsZS5wcm9nDQo+ICsNCj4gICAjIGFzbS9zeXNyZWcuaCAtIGlubGluZSBhc3Nl
bWJseSB1c2VkIGJ5IGl0IGlzIGluY29tcGF0aWJsZSB3aXRoIGxsdm0uDQo+ICAgIyBCdXQsIHRo
ZXJlIGlzIG5vIGVhc3kgd2F5IHRvIGZpeCBpdCwgc28ganVzdCBleGNsdWRlIGl0IHNpbmNlIGl0
IGlzDQo+ICAgIyB1c2VsZXNzIGZvciBCUEYgc2FtcGxlcy4NCj4gDQo=
