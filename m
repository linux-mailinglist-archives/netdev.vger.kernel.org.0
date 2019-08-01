Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A12B07D4BA
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 07:08:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727853AbfHAFIH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 01:08:07 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:27130 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726661AbfHAFIG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 01:08:06 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7154Zec026569;
        Wed, 31 Jul 2019 22:07:38 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=83IPjwvy3jiMbyilp3F0eHQYT5cvkVmcdpJxXBeceC4=;
 b=RAYzGJHB8jdiUvjZ4HMN7s6FYH/SmyYBJKeFIP7wKHSRz1Q/wlURHpNQCqWfDF+YySoT
 vV0GfAIxkovE9QBe2/gKy0uQllqW2qmvp0DoXrNZwghcWKibNYKrKBa5IRoKDMEnFKvX
 37rlaf94v9R+GV5vgRy6L/SlMlQmilX2p2w= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2u3ghx9qw4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 31 Jul 2019 22:07:38 -0700
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 31 Jul 2019 22:07:37 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 31 Jul 2019 22:07:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NAc9Sv6G015nIyS6OBDh6mTVUh5A7cgjj9TwPj3btGoIsmxJyy6g1DeMwwDeMovoNlbzpNdQxMN3vtyXjCQL5LUHLlkh3rb9fgGdlx0o6cmpAMqZCR1N9wRbIKzPFVD4BcDixfscMhDHgxuMVN2c52S83ormW1GZktLK9jeTWFtjgCafV2Fd0LwOMJvKADs5bYefCo2h8rB1/CeronrGHOcU3M8wQ7Q1gnJIOyQbmmtbugxIGx5XzdfkIxevJBgEJCjCYGoCIO9rhkXXya1iJNB21iwEtt6e/oX+X9X0bYuILCjdRKjwoHrZ6UiCFKvZPlTZB1owQCshriPW2mEEeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83IPjwvy3jiMbyilp3F0eHQYT5cvkVmcdpJxXBeceC4=;
 b=fZwTCNliLgeqUO7zdYx7Bm11HObQ/n6mBeiStYIIwuUTnvjkOOPd7YB0l9Ji7VtaIF6KVecGjFCEl+MbZhYDaeo32vOKehIHO64g13d3cHkeKlnxDI1fZo21rD9XaaXUsGdDr0fnVc0N1jnU71/WpX4UghBIThueOT+cvoegrRxZaxEBUWb4JoMl1Zs9xAny2kZ6Bz+hqf8a/ykVlf67PnksREuhNsY3IWwPORJR1sjyG7RVuXyAYnhDE7pS2vzZpn7hEBW72eHSelJdYCh8IT2iDXLTrLqIBXfvoFmqD/JHLFMadra9WexY1P6MDJmfwGg4uBtk1Dfo8Zk2tJzdEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=83IPjwvy3jiMbyilp3F0eHQYT5cvkVmcdpJxXBeceC4=;
 b=Eo6mejcwq4QeISZgJ+TlxhucHWBTm2tTvyh2CxXJuFAtqN7fRAOhjTZTkKhkbvFxeGWMW5s5orT7Syb1f7z4F17XSlnHNOeuKy7fRd9YtutuIaPr92oWQvk0yE5eVag6JSQ3hPGLNfHOVFTkxrB5w00sNSmGeQ8mgsN3SyXbvEU=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1149.namprd15.prod.outlook.com (10.175.3.9) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 05:07:22 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::c66:6d60:f6e5:773c%8]) with mapi id 15.20.2136.010; Thu, 1 Aug 2019
 05:07:22 +0000
From:   Tao Ren <taoren@fb.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Andrew Jeffery <andrew@aj.id.au>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Topic: [PATCH net-next 2/2] net: phy: broadcom: add 1000Base-X support
 for BCM54616S
Thread-Index: AQHVRm4oHxOo2s4k1kyYCsigpkISsabiYHeAgAA34ACAAFoWAIAA4hcAgAAfZwCAAAkVAIAABwmAgAA4N4CAAYTggA==
Date:   Thu, 1 Aug 2019 05:07:22 +0000
Message-ID: <c77d0ef4-4388-67cc-77a0-1c87baa82bd4@fb.com>
References: <20190730002549.86824-1-taoren@fb.com>
 <CA+h21hq1+E6-ScFx425hXwTPTZHTVZbBuAm7RROFZTBOFvD8vQ@mail.gmail.com>
 <3987251b-9679-dfbe-6e15-f991c2893bac@fb.com>
 <CA+h21ho1KOGS3WsNBHzfHkpSyE4k5HTE1tV9wUtnkZhjUZGeUw@mail.gmail.com>
 <e8f85ef3-1216-8efb-a54d-84426234fe82@fb.com>
 <20190731013636.GC25700@lunn.ch>
 <885e48dd-df5b-7f08-ef58-557fc2347fa6@fb.com> <20190731023417.GD9523@lunn.ch>
 <08f55ccc-7d2a-996b-770b-a0f035889196@fb.com>
In-Reply-To: <08f55ccc-7d2a-996b-770b-a0f035889196@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0040.namprd18.prod.outlook.com
 (2603:10b6:320:31::26) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:ed2b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 60e4b7e6-7962-42b4-8504-08d7163e227a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1149;
x-ms-traffictypediagnostic: MWHPR15MB1149:
x-microsoft-antispam-prvs: <MWHPR15MB11494B2695A2C5FAB6E5D14CB2DE0@MWHPR15MB1149.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(366004)(346002)(396003)(376002)(136003)(199004)(189003)(478600001)(446003)(64126003)(256004)(486006)(11346002)(14444005)(6246003)(476003)(5660300002)(71200400001)(386003)(53936002)(4326008)(14454004)(316002)(229853002)(25786009)(64756008)(71190400001)(66476007)(46003)(54906003)(58126008)(2616005)(66556008)(6116002)(66946007)(2906002)(6512007)(6486002)(6436002)(68736007)(7736002)(31686004)(36756003)(99286004)(31696002)(186003)(52116002)(65806001)(6916009)(65826007)(8936002)(86362001)(102836004)(53546011)(8676002)(7416002)(76176011)(6506007)(81156014)(81166006)(65956001)(66446008)(305945005);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1149;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: GGcKO7Ma77kUmclVL6CFHsF/9UI0qwqlNIh8wgfujjf9+0RF+fNDHKAUwvFCJJorv22kcu7GBSeYPLmZ8eGL3/jXVCS7QGhH+vzBcl40Uil6+m5wHWST9Uiu8Tpx7ZGsqZn4Q1x4Jt+xjLr8Tfte9VMxpzFrHVXH6qgJxoFdw6lsyLxKqGUsNBkLor42NpTRTKBSTwiRFWvHK/ucu/90AeXYzmkTxZO/ooXrmXbf/ObaF8rMFH4mkDbLKAIyKGKTu6N0fiJE3uhNJNPwcCvqDhf9CKkfYyJY1FqEIIi+Yloqvv0JctUVAkkxEHDru2uJTFM4wxShMo3alvlUVsc83ZL4bYuUjUIecHDeaYs3PXgDITYTx5QSOyRmR0SevJng5cVGtS2Ux8ADt2ybBFn54ckyahQK3yzQiilOn45Ls4Q=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F528CA85575E514D958D7D91927E4978@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 60e4b7e6-7962-42b4-8504-08d7163e227a
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 05:07:22.2486
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: taoren@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1149
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-01_03:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908010048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSAxMDo1NSBQTSwgVGFvIFJlbiB3cm90ZToNCj4gT24gNy8zMC8xOSA3OjM0IFBN
LCBBbmRyZXcgTHVubiB3cm90ZToNCj4+PiBIaSBBbmRyZXcsDQo+Pj4NCj4+PiBUaGUgQkNNNTQ2
MTZTIFBIWSBvbiBteSBtYWNoaW5lIGlzIGNvbm5lY3RlZCB0byBhIEJDTTUzOTYgc3dpdGNoIGNo
aXAgb3ZlciBiYWNrcGxhbmUgKDEwMDBCYXNlLUtYKS4NCj4+DQo+PiBBaCwgdGhhdCBpcyBkaWZm
ZXJlbnQuIFNvIHRoZSBib2FyZCBpcyB1c2luZyBpdCBmb3IgUkdNSUkgdG8gMTAwMEJhc2UtS1g/
DQo+Pg0KPj4gcGh5LW1vZGUgaXMgYWJvdXQgdGhlIE1BQy1QSFkgbGluay4gU28gaW4gdGhpcyBj
YXNlIFJHTUlJLg0KPiANCj4gWWVzLiBJdCdzIFJHTUlJIHRvIDEwMDBCYXNlLUtYLg0KPiANCj4+
IFRoZXJlIGlzIG5vIERUIHdheSB0byBjb25maWd1cmUgdGhlIFBIWS1Td2l0Y2ggbGluay4gSG93
ZXZlciwgaXQNCj4+IHNvdW5kcyBsaWtlIHlvdSBoYXZlIHRoZSBQSFkgc3RyYXBwZWQgc28gaXQg
aXMgZG9pbmcgMTAwMEJhc2VYIG9uIHRoZQ0KPj4gUEhZLVN3aXRjaCBsaW5rLiBTbyBkbyB5b3Ug
YWN0dWFsbHkgbmVlZCB0byBjb25maWd1cmUgdGhpcz8NCj4gDQo+IFRoZSBQSFkgaXMgc3RyYXBw
ZWQgaW4gUkdNSUktRmliZXIgTW9kZSAodGhlIHRlcm0gdXNlZCBpbiBkYXRhc2hlZXQpLCBidXQg
YmVzaWRlcyAxMDAwQmFzZVgsIDEwMEJhc2UtRlggaXMgYWxzbyBzdXBwb3J0ZWQgaW4gdGhpcyBt
b2RlLg0KPiBUaGUgZGF0YXNoZWV0IGRvZXNuJ3Qgc2F5IHdoaWNoIGxpbmsgdHlwZSAoMTAwMEJh
c2VYIG9yIDEwMEJhc2UtRlgpIGlzIGFjdGl2ZSBhZnRlciByZXNldCBhbmQgSSBjYW5ub3QgZmlu
ZCBhIHdheSB0byBhdXRvLWRldGVjdCB0aGUgbGluayB0eXBlLCBlaXRoZXIuDQoNCkkgZm91bmQg
Yml0IDAgb2YgMTAwLUZYIGNvbnRyb2wgcmVnaXN0ZXIgY2FuIGJlIHVzZWQgdG8gZGV0ZWN0IFBI
WS1zd2l0Y2ggbGluayB0eXBlIChtZWFucyBEVCBpcyBub3QgbmVlZGVkKS4gV2lsbCBydW4gbW9y
ZSB0ZXN0aW5nIGFuZCBzZW5kIG91dCB2MiBwYXRjaCBzb29uLiBUaGFuayB5b3UgYWxsIGZvciB0
aGUgaW5wdXQgYW5kIGhlbHAuDQoNCg0KQ2hlZXJzLA0KDQpUYW8NCg==
