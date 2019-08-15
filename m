Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80FAF8F777
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 01:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387650AbfHOXNh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Aug 2019 19:13:37 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50694 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387644AbfHOXNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Aug 2019 19:13:37 -0400
Received: from pps.filterd (m0109332.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x7FN9FDS014676;
        Thu, 15 Aug 2019 16:13:20 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : subject :
 date : message-id : references : in-reply-to : content-type : content-id :
 content-transfer-encoding : mime-version; s=facebook;
 bh=EeWkzqmBRRWy8s6rJOY3oNipAYwwInhQf1Xvlg41MQk=;
 b=Mh8kGy3fP4Bzv1ylzOOC0hrDAyhcN1ZO6vi7r/suGe+Msi6dwLLnLVOsFVTSLwKYgnil
 48MafQaMdk7TqK8UHX9G6Sh/rHqp68ANAZyodYDn8mpkxpXQFzk8eFk2CSmHcLJlr/dM
 FoxQPJIqbEmkJiKKzjAIO4N1VJS+8U8fCEM= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2udej30ruk-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 15 Aug 2019 16:13:20 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 15 Aug 2019 16:13:05 -0700
Received: from prn-hub04.TheFacebook.com (2620:10d:c081:35::128) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Thu, 15 Aug 2019 16:13:05 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.28) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Thu, 15 Aug 2019 16:13:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ltxAjGDsH4EREYN/yPtHa5CnMTKjSegQkunfEpXP2h8wF8SSWtDzHYPPCW8+f1lNyBguzeyRxMoZ6rijK5jZwdZsikLVxRS/NjrT+rgC8ir7j5eCzmp2I4QYbKly6xtPpaxlLIRPcs3V5EUZAE48Xo9Crtjlp8pHxnUH0xJK9G3rSyr8kbubZ1PlT+TRJEvVoL47i0LlR0xtZIpdOrVklcXcvOg682fBMLJolrgKDm1eYTzMbJF8Lz2zw8OeZaIncZQSE4nqHk9pllG50/PHhQrHrORnKac+eXIXmDgdnU0KwtnLVYI9K1qYunEVGcDDAG+S17w2d5kfCeCSvOd2jA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeWkzqmBRRWy8s6rJOY3oNipAYwwInhQf1Xvlg41MQk=;
 b=Hv+cPcCluLoXaRh7mzNDkQjuv9IHimLliKrYJ5IzwOrlwfDYvZd5PamNY14e8daL31LbpdksDUhT/kXWT4Zjkma1YB6WftH0EahD/Bsi5oevqr+rwQpKSjN20CBIGTySGNYX00Wnjev26r6v4X0f1JYch8IytOPLCqRm6dU08QP4y4Pccv3J/nwAhBhWZH/6xlqq+p3ACtXJHeeR1bmTmqgtwbzYlHCBoG0LapfqGTUdTjkbMPTEdOLzgE8eNTho9/U2IVJo3V03VYuhPWb3kzNhZB3ftKaFdOsObgkAtFNKFjDcekFzh8igb288PrJVpkdLu3GnxFWnq+AYzugiig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EeWkzqmBRRWy8s6rJOY3oNipAYwwInhQf1Xvlg41MQk=;
 b=KHg+TwJ2q34cBEAxkko98yWCZvgBj4k9yNQwazdyLSWrVyBuVumtnc9F9pXjOXhc2TTBU4z3oNjaqiPSw+WpdO+zEe2BQfdfztqlgiHUqP4NtP2KGW6c27EFx02fJ68FWEurNCjWE7+gBJWTlDdVjGNDsbr2NLJQyAELmEvqD3A=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1437.namprd15.prod.outlook.com (10.173.234.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.23; Thu, 15 Aug 2019 23:13:03 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2157.022; Thu, 15 Aug 2019
 23:13:03 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Topic: [PATCH net-next v7 3/3] net: phy: broadcom: add 1000Base-X
 support for BCM54616S
Thread-Index: AQHVUJ5qOj7KTUEtsUuopmpFoA8EiKb83LkA
Date:   Thu, 15 Aug 2019 23:13:03 +0000
Message-ID: <fee3faa1-2de1-b480-983e-07f4587f2f79@fb.com>
References: <20190811234016.3674056-1-taoren@fb.com>
In-Reply-To: <20190811234016.3674056-1-taoren@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR07CA0024.namprd07.prod.outlook.com
 (2603:10b6:a02:bc::37) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:70f6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60111c4e-3034-4aa3-2a4e-08d721d61f93
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1437;
x-ms-traffictypediagnostic: MWHPR15MB1437:
x-microsoft-antispam-prvs: <MWHPR15MB14377ED94AB76C468A3683B4B2AC0@MWHPR15MB1437.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01304918F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(39860400002)(366004)(376002)(136003)(199004)(189003)(110136005)(31696002)(66556008)(58126008)(6116002)(7736002)(305945005)(2201001)(8676002)(76176011)(316002)(81166006)(53546011)(386003)(52116002)(102836004)(2906002)(99286004)(6506007)(81156014)(31686004)(5660300002)(36756003)(64126003)(71200400001)(46003)(14454004)(478600001)(64756008)(2616005)(486006)(6436002)(66946007)(2501003)(476003)(65956001)(256004)(11346002)(86362001)(66476007)(7416002)(14444005)(6486002)(25786009)(446003)(65826007)(229853002)(186003)(65806001)(6512007)(8936002)(6246003)(66446008)(53936002)(71190400001)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1437;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: piMMOYy9ojrYzlMi5S5cUiP63KkeQfUqZxDyFgxdtQX7iIIbhwllbrsT5/n60c0yFMFwENWBJsEqTPW/dSuoTv6AsYjDOkt8GXzfoGhV8t0txjysv1bkyzZa27KHMWh4WgUa3+5kXLNgLxM+xpIRukB0wi86haQ3bVViD3jfEWy1QvJfLt54WL59dmkCslUYYTmojohUqe9Vbot6j8G47WA/rnHAXS30G9OAPVcr4BuASjm5+k+gJtaOFckWw9dLKV24cSejXrB0rKtJhr+qYc1wUOGWg6spZ3pH+sy5/lWltrfAWYDaYmzlB9tMxnwVM3I5FI4pl48yGtT2VjhVRBRf1DRtsNdX0qey4OYI6OMgRO839d9cP8I4RsYVqFug9EMreVQImqa4mLSkRFalDHqNygyKS4/7mmxUpzx1S/0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <46202A550F31F24185028B50E666AC29@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 60111c4e-3034-4aa3-2a4e-08d721d61f93
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Aug 2019 23:13:03.6099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2iNNKYaIOrY1pdTLb2RYndk/+Vo29bFPN6Uy2yzvdhxvkljd0ZXQCpTm1H/ABuT8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1437
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-15_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=788 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908150221
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3IC8gRmxvcmlhbiAvIEhlaW5lciAvIFZsYWRpbWlyLA0KDQpBbnkgZnVydGhlciBz
dWdnZXN0aW9ucyBvbiB0aGUgcGF0Y2ggc2VyaWVzPw0KDQoNClRoYW5rcywNCg0KVGFvDQoNCk9u
IDgvMTEvMTkgNDo0MCBQTSwgVGFvIFJlbiB3cm90ZToNCj4gVGhlIEJDTTU0NjE2UyBQSFkgY2Fu
bm90IHdvcmsgcHJvcGVybHkgaW4gUkdNSUktPjEwMDBCYXNlLVggbW9kZSwgbWFpbmx5DQo+IGJl
Y2F1c2UgZ2VucGh5IGZ1bmN0aW9ucyBhcmUgZGVzaWduZWQgZm9yIGNvcHBlciBsaW5rcywgYW5k
IDEwMDBCYXNlLVgNCj4gKGNsYXVzZSAzNykgYXV0byBuZWdvdGlhdGlvbiBuZWVkcyB0byBiZSBo
YW5kbGVkIGRpZmZlcmVudGx5Lg0KPiANCj4gVGhpcyBwYXRjaCBlbmFibGVzIDEwMDBCYXNlLVgg
c3VwcG9ydCBmb3IgQkNNNTQ2MTZTIGJ5IGN1c3RvbWl6aW5nIDMNCj4gZHJpdmVyIGNhbGxiYWNr
cywgYW5kIGl0J3MgdmVyaWZpZWQgdG8gYmUgd29ya2luZyBvbiBGYWNlYm9vayBDTU0gQk1DDQo+
IHBsYXRmb3JtIChSR01JSS0+MTAwMEJhc2UtS1gpOg0KPiANCj4gICAtIHByb2JlOiBwcm9iZSBj
YWxsYmFjayBkZXRlY3RzIFBIWSdzIG9wZXJhdGlvbiBtb2RlIGJhc2VkIG9uDQo+ICAgICBJTlRF
UkZfU0VMWzE6MF0gcGlucyBhbmQgMTAwMFgvMTAwRlggc2VsZWN0aW9uIGJpdCBpbiBTZXJERVMg
MTAwLUZYDQo+ICAgICBDb250cm9sIHJlZ2lzdGVyLg0KPiANCj4gICAtIGNvbmZpZ19hbmVnOiBj
YWxscyBnZW5waHlfYzM3X2NvbmZpZ19hbmVnIHdoZW4gdGhlIFBIWSBpcyBydW5uaW5nIGluDQo+
ICAgICAxMDAwQmFzZS1YIG1vZGU7IG90aGVyd2lzZSwgZ2VucGh5X2NvbmZpZ19hbmVnIHdpbGwg
YmUgY2FsbGVkLg0KPiANCj4gICAtIHJlYWRfc3RhdHVzOiBjYWxscyBnZW5waHlfYzM3X3JlYWRf
c3RhdHVzIHdoZW4gdGhlIFBIWSBpcyBydW5uaW5nIGluDQo+ICAgICAxMDAwQmFzZS1YIG1vZGU7
IG90aGVyd2lzZSwgZ2VucGh5X3JlYWRfc3RhdHVzIHdpbGwgYmUgY2FsbGVkLg0KPiANCj4gTm90
ZTogQkNNNTQ2MTZTIFBIWSBjYW4gYWxzbyBiZSBjb25maWd1cmVkIGluIFJHTUlJLT4xMDBCYXNl
LUZYIG1vZGUsIGFuZA0KPiAxMDBCYXNlLUZYIHN1cHBvcnQgaXMgbm90IGF2YWlsYWJsZSBhcyBv
ZiBub3cuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBUYW8gUmVuIDx0YW9yZW5AZmIuY29tPg0KPiAt
LS0NCj4gIENoYW5nZXMgaW4gdjc6DQo+ICAgLSBBZGQgY29tbWVudCAiQkNNNTQ2MTZTIDEwMEJh
c2UtRlggaXMgbm90IHN1cHBvcnRlZCIuDQo+ICBDaGFuZ2VzIGluIHY2Og0KPiAgIC0gbm90aGlu
ZyBjaGFuZ2VkLg0KPiAgQ2hhbmdlcyBpbiB2NToNCj4gICAtIGluY2x1ZGUgSGVpbmVyJ3MgcGF0
Y2ggIm5ldDogcGh5OiBhZGQgc3VwcG9ydCBmb3IgY2xhdXNlIDM3DQo+ICAgICBhdXRvLW5lZ290
aWF0aW9uIiBpbnRvIHRoZSBzZXJpZXMuDQo+ICAgLSB1c2UgZ2VucGh5X2MzN19jb25maWdfYW5l
ZyBhbmQgZ2VucGh5X2MzN19yZWFkX3N0YXR1cyBpbiBCQ001NDYxNlMNCj4gICAgIFBIWSBkcml2
ZXIncyBjYWxsYmFjayB3aGVuIHRoZSBQSFkgaXMgcnVubmluZyBpbiAxMDAwQmFzZS1YIG1vZGUu
DQo+ICBDaGFuZ2VzIGluIHY0Og0KPiAgIC0gYWRkIGJjbTU0NjE2c19jb25maWdfYW5lZ18xMDAw
YngoKSB0byBkZWFsIHdpdGggYXV0byBuZWdvdGlhdGlvbiBpbg0KPiAgICAgMTAwMEJhc2UtWCBt
b2RlLg0KPiAgQ2hhbmdlcyBpbiB2MzoNCj4gICAtIHJlbmFtZSBiY201NDgyX3JlYWRfc3RhdHVz
IHRvIGJjbTU0eHhfcmVhZF9zdGF0dXMgc28gdGhlIGNhbGxiYWNrIGNhbg0KPiAgICAgYmUgc2hh
cmVkIGJ5IEJDTTU0ODIgYW5kIEJDTTU0NjE2Uy4NCj4gIENoYW5nZXMgaW4gdjI6DQo+ICAgLSBB
dXRvLWRldGVjdCBQSFkgb3BlcmF0aW9uIG1vZGUgaW5zdGVhZCBvZiBwYXNzaW5nIERUIG5vZGUu
DQo+ICAgLSBtb3ZlIFBIWSBtb2RlIGF1dG8tZGV0ZWN0IGxvZ2ljIGZyb20gY29uZmlnX2luaXQg
dG8gcHJvYmUgY2FsbGJhY2suDQo+ICAgLSBvbmx5IHNldCBzcGVlZCAobm90IGluY2x1ZGluZyBk
dXBsZXgpIGluIHJlYWRfc3RhdHVzIGNhbGxiYWNrLg0KPiAgIC0gdXBkYXRlIHBhdGNoIGRlc2Ny
aXB0aW9uIHdpdGggbW9yZSBiYWNrZ3JvdW5kIHRvIGF2b2lkIGNvbmZ1c2lvbi4NCj4gICAtIHBh
dGNoICMxIGluIHRoZSBzZXJpZXMgKCJuZXQ6IHBoeTogYnJvYWRjb206IHNldCBmZWF0dXJlcyBl
eHBsaWNpdGx5DQo+ICAgICBmb3IgQkNNNTQ2MTYiKSBpcyBkcm9wcGVkLg0KPiANCj4gIGRyaXZl
cnMvbmV0L3BoeS9icm9hZGNvbS5jIHwgNTcgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKystLS0NCj4gIGluY2x1ZGUvbGludXgvYnJjbXBoeS5oICAgIHwgMTAgKysrKystLQ0KPiAg
MiBmaWxlcyBjaGFuZ2VkLCA2MSBpbnNlcnRpb25zKCspLCA2IGRlbGV0aW9ucygtKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jIGIvZHJpdmVycy9uZXQvcGh5
L2Jyb2FkY29tLmMNCj4gaW5kZXggOTM3ZDAwNTllOGFjLi41ZmQ5MjkzNTEzZDggMTAwNjQ0DQo+
IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9icm9hZGNvbS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L3Bo
eS9icm9hZGNvbS5jDQo+IEBAIC0zODMsOSArMzgzLDkgQEAgc3RhdGljIGludCBiY201NDgyX2Nv
bmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICAJCS8qDQo+ICAJCSAqIFNl
bGVjdCAxMDAwQkFTRS1YIHJlZ2lzdGVyIHNldCAocHJpbWFyeSBTZXJEZXMpDQo+ICAJCSAqLw0K
PiAtCQlyZWcgPSBiY21fcGh5X3JlYWRfc2hhZG93KHBoeWRldiwgQkNNNTQ4Ml9TSERfTU9ERSk7
DQo+IC0JCWJjbV9waHlfd3JpdGVfc2hhZG93KHBoeWRldiwgQkNNNTQ4Ml9TSERfTU9ERSwNCj4g
LQkJCQkgICAgIHJlZyB8IEJDTTU0ODJfU0hEX01PREVfMTAwMEJYKTsNCj4gKwkJcmVnID0gYmNt
X3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01PREUpOw0KPiArCQliY21fcGh5
X3dyaXRlX3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01PREUsDQo+ICsJCQkJICAgICByZWcg
fCBCQ001NFhYX1NIRF9NT0RFXzEwMDBCWCk7DQo+ICANCj4gIAkJLyoNCj4gIAkJICogTEVEMT1B
Q1RJVklUWUxFRCwgTEVEMz1MSU5LU1BEWzJdDQo+IEBAIC00NTEsMTIgKzQ1MSw0NyBAQCBzdGF0
aWMgaW50IGJjbTU0ODFfY29uZmlnX2FuZWcoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4g
IAlyZXR1cm4gcmV0Ow0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgaW50IGJjbTU0NjE2c19wcm9iZShz
dHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiArew0KPiArCWludCB2YWwsIGludGZfc2VsOw0K
PiArDQo+ICsJdmFsID0gYmNtX3BoeV9yZWFkX3NoYWRvdyhwaHlkZXYsIEJDTTU0WFhfU0hEX01P
REUpOw0KPiArCWlmICh2YWwgPCAwKQ0KPiArCQlyZXR1cm4gdmFsOw0KPiArDQo+ICsJLyogVGhl
IFBIWSBpcyBzdHJhcHBlZCBpbiBSR01JSS1maWJlciBtb2RlIHdoZW4gSU5URVJGX1NFTFsxOjBd
DQo+ICsJICogaXMgMDFiLCBhbmQgdGhlIGxpbmsgYmV0d2VlbiBQSFkgYW5kIGl0cyBsaW5rIHBh
cnRuZXIgY2FuIGJlDQo+ICsJICogZWl0aGVyIDEwMDBCYXNlLVggb3IgMTAwQmFzZS1GWC4NCj4g
KwkgKiBSR01JSS0xMDAwQmFzZS1YIGlzIHByb3Blcmx5IHN1cHBvcnRlZCwgYnV0IFJHTUlJLTEw
MEJhc2UtRlgNCj4gKwkgKiBzdXBwb3J0IGlzIHN0aWxsIG1pc3NpbmcgYXMgb2Ygbm93Lg0KPiAr
CSAqLw0KPiArCWludGZfc2VsID0gKHZhbCAmIEJDTTU0WFhfU0hEX0lOVEZfU0VMX01BU0spID4+
IDE7DQo+ICsJaWYgKGludGZfc2VsID09IDEpIHsNCj4gKwkJdmFsID0gYmNtX3BoeV9yZWFkX3No
YWRvdyhwaHlkZXYsIEJDTTU0NjE2U19TSERfMTAwRlhfQ1RSTCk7DQo+ICsJCWlmICh2YWwgPCAw
KQ0KPiArCQkJcmV0dXJuIHZhbDsNCj4gKw0KPiArCQkvKiBCaXQgMCBvZiB0aGUgU2VyRGVzIDEw
MC1GWCBDb250cm9sIHJlZ2lzdGVyLCB3aGVuIHNldA0KPiArCQkgKiB0byAxLCBzZXRzIHRoZSBN
SUkvUkdNSUkgLT4gMTAwQkFTRS1GWCBjb25maWd1cmF0aW9uLg0KPiArCQkgKiBXaGVuIHRoaXMg
Yml0IGlzIHNldCB0byAwLCBpdCBzZXRzIHRoZSBHTUlJL1JHTUlJIC0+DQo+ICsJCSAqIDEwMDBC
QVNFLVggY29uZmlndXJhdGlvbi4NCj4gKwkJICovDQo+ICsJCWlmICghKHZhbCAmIEJDTTU0NjE2
U18xMDBGWF9NT0RFKSkNCj4gKwkJCXBoeWRldi0+ZGV2X2ZsYWdzIHw9IFBIWV9CQ01fRkxBR1Nf
TU9ERV8xMDAwQlg7DQo+ICsJfQ0KPiArDQo+ICsJcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gIHN0
YXRpYyBpbnQgYmNtNTQ2MTZzX2NvbmZpZ19hbmVnKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYp
DQo+ICB7DQo+ICAJaW50IHJldDsNCj4gIA0KPiAgCS8qIEFuZWcgZmlyc2x5LiAqLw0KPiAtCXJl
dCA9IGdlbnBoeV9jb25maWdfYW5lZyhwaHlkZXYpOw0KPiArCWlmIChwaHlkZXYtPmRldl9mbGFn
cyAmIFBIWV9CQ01fRkxBR1NfTU9ERV8xMDAwQlgpDQo+ICsJCXJldCA9IGdlbnBoeV9jMzdfY29u
ZmlnX2FuZWcocGh5ZGV2KTsNCj4gKwllbHNlDQo+ICsJCXJldCA9IGdlbnBoeV9jb25maWdfYW5l
ZyhwaHlkZXYpOw0KPiAgDQo+ICAJLyogVGhlbiB3ZSBjYW4gc2V0IHVwIHRoZSBkZWxheS4gKi8N
Cj4gIAliY201NHh4X2NvbmZpZ19jbG9ja19kZWxheShwaHlkZXYpOw0KPiBAQCAtNDY0LDYgKzQ5
OSwxOCBAQCBzdGF0aWMgaW50IGJjbTU0NjE2c19jb25maWdfYW5lZyhzdHJ1Y3QgcGh5X2Rldmlj
ZSAqcGh5ZGV2KQ0KPiAgCXJldHVybiByZXQ7DQo+ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQgYmNt
NTQ2MTZzX3JlYWRfc3RhdHVzKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICt7DQo+ICsJ
aW50IGVycjsNCj4gKw0KPiArCWlmIChwaHlkZXYtPmRldl9mbGFncyAmIFBIWV9CQ01fRkxBR1Nf
TU9ERV8xMDAwQlgpDQo+ICsJCWVyciA9IGdlbnBoeV9jMzdfcmVhZF9zdGF0dXMocGh5ZGV2KTsN
Cj4gKwllbHNlDQo+ICsJCWVyciA9IGdlbnBoeV9yZWFkX3N0YXR1cyhwaHlkZXYpOw0KPiArDQo+
ICsJcmV0dXJuIGVycjsNCj4gK30NCj4gKw0KPiAgc3RhdGljIGludCBicmNtX3BoeV9zZXRiaXRz
KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYsIGludCByZWcsIGludCBzZXQpDQo+ICB7DQo+ICAJ
aW50IHZhbDsNCj4gQEAgLTY1NSw2ICs3MDIsOCBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIg
YnJvYWRjb21fZHJpdmVyc1tdID0gew0KPiAgCS5jb25maWdfYW5lZwk9IGJjbTU0NjE2c19jb25m
aWdfYW5lZywNCj4gIAkuYWNrX2ludGVycnVwdAk9IGJjbV9waHlfYWNrX2ludHIsDQo+ICAJLmNv
bmZpZ19pbnRyCT0gYmNtX3BoeV9jb25maWdfaW50ciwNCj4gKwkucmVhZF9zdGF0dXMJPSBiY201
NDYxNnNfcmVhZF9zdGF0dXMsDQo+ICsJLnByb2JlCQk9IGJjbTU0NjE2c19wcm9iZSwNCj4gIH0s
IHsNCj4gIAkucGh5X2lkCQk9IFBIWV9JRF9CQ001NDY0LA0KPiAgCS5waHlfaWRfbWFzawk9IDB4
ZmZmZmZmZjAsDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2JyY21waHkuaCBiL2luY2x1
ZGUvbGludXgvYnJjbXBoeS5oDQo+IGluZGV4IDZkYjJkOWE2ZTUwMy4uYjQ3NWU3ZjIwZDI4IDEw
MDY0NA0KPiAtLS0gYS9pbmNsdWRlL2xpbnV4L2JyY21waHkuaA0KPiArKysgYi9pbmNsdWRlL2xp
bnV4L2JyY21waHkuaA0KPiBAQCAtMjAwLDkgKzIwMCwxNSBAQA0KPiAgI2RlZmluZSBCQ001NDgy
X1NIRF9TU0QJCTB4MTQJLyogMTAxMDA6IFNlY29uZGFyeSBTZXJEZXMgY29udHJvbCAqLw0KPiAg
I2RlZmluZSBCQ001NDgyX1NIRF9TU0RfTEVETQkweDAwMDgJLyogU1NEIExFRCBNb2RlIGVuYWJs
ZSAqLw0KPiAgI2RlZmluZSBCQ001NDgyX1NIRF9TU0RfRU4JMHgwMDAxCS8qIFNTRCBlbmFibGUg
Ki8NCj4gLSNkZWZpbmUgQkNNNTQ4Ml9TSERfTU9ERQkweDFmCS8qIDExMTExOiBNb2RlIENvbnRy
b2wgUmVnaXN0ZXIgKi8NCj4gLSNkZWZpbmUgQkNNNTQ4Ml9TSERfTU9ERV8xMDAwQlgJMHgwMDAx
CS8qIEVuYWJsZSAxMDAwQkFTRS1YIHJlZ2lzdGVycyAqLw0KPiAgDQo+ICsvKiAxMDAxMTogU2Vy
RGVzIDEwMC1GWCBDb250cm9sIFJlZ2lzdGVyICovDQo+ICsjZGVmaW5lIEJDTTU0NjE2U19TSERf
MTAwRlhfQ1RSTAkweDEzDQo+ICsjZGVmaW5lCUJDTTU0NjE2U18xMDBGWF9NT0RFCQlCSVQoMCkJ
LyogMTAwLUZYIFNlckRlcyBFbmFibGUgKi8NCj4gKw0KPiArLyogMTExMTE6IE1vZGUgQ29udHJv
bCBSZWdpc3RlciAqLw0KPiArI2RlZmluZSBCQ001NFhYX1NIRF9NT0RFCQkweDFmDQo+ICsjZGVm
aW5lIEJDTTU0WFhfU0hEX0lOVEZfU0VMX01BU0sJR0VOTUFTSygyLCAxKQkvKiBJTlRFUkZfU0VM
WzE6MF0gKi8NCj4gKyNkZWZpbmUgQkNNNTRYWF9TSERfTU9ERV8xMDAwQlgJCUJJVCgwKQkvKiBF
bmFibGUgMTAwMC1YIHJlZ2lzdGVycyAqLw0KPiAgDQo+ICAvKg0KPiAgICogRVhQQU5TSU9OIFNI
QURPVyBBQ0NFU1MgUkVHSVNURVJTLiAgKFBIWSBSRUcgMHgxNSwgMHgxNiwgYW5kIDB4MTcpDQo+
IA0K
