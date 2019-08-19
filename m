Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 159BB951A4
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 01:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728618AbfHSXX7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 19:23:59 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58578 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728469AbfHSXX6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 19:23:58 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.27/8.16.0.27) with SMTP id x7JNNXiB032379;
        Mon, 19 Aug 2019 16:23:33 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=OKG8vNM2tSTwkUQGaBn/4MRNM3a+r6UoCIZz6BM61rM=;
 b=iJoskbEo799s+3HiXvc+JO9wHI2qVRDywDklTsjaoBL6cUprK/hroEvudWJ6zyaphtX4
 UvyMRTPfV8PhPjW6LN2ltSdQtI+3XfomkMxsqPLu5O7WwpBbr1wKcpD5i22GTnZEaOv6
 lhnJakv81ZY5s0mi7banxZeNAaxyZBTiGHw= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 2ufypy9j0c-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 19 Aug 2019 16:23:33 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 19 Aug 2019 16:22:47 -0700
Received: from NAM03-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 19 Aug 2019 16:22:47 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j8Y5Vd7LU5vxMcmv6tw7vttzM1ENG7WJvtBgCod2YdPAkEbb5CQ5X4fLsYzXc0gE51SGJkN8nk+XmbPes2neqiq1DIVI1OE5XkKUBzpEF6u/hV99YAyRTm0lyc7q5uzpDNUleXOCKUxJ+y7n3E0cPFOfs3amweYoOpj8ZCT78I4j7UEDjS1dwEFMGLs4LXOCSgvr5tAdYVdrzk+62CHxbrOPflBluhwdIOZ/4GZLK3Z1pZ9v4wvhuJwBaMiilV4GkrRLV7qpBFkKMSaHzzd2e3uRvqC3x1sTYoghqNXc4aQv2HJ5UdMDo5RkzG4Y9nsKkvl/vBgDR4vcaWxfdtlPJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKG8vNM2tSTwkUQGaBn/4MRNM3a+r6UoCIZz6BM61rM=;
 b=CXLdC9JwyILb7vrLRcFQfJKN8qRfzfXcynG5drnxp3GMeRJhIgfynd73rl5SO8eHIazTlhIycNT3RzAIlI1/srTYEFPu+Ay4Dyq/CcI3Y6CsmYYZ893eOX/DsyZZBQ/a3x/WJ0kt8Hu4hBehvVkINljeiRtZEPZ6QukPhuHXvskNowdaQByFbm4Q7fBBQCqjJ5ds1VwGkgcZUzDs6F5a4Z+XRtnoxL7RNrZwd4D+eJHmBiUoJFQHqqjgzh60C44a9ngGtr2m9s7mWhCv7DZUaNRIjfFGl0NRFfttjf8+mddqawQuNXjTVy9kpoK1fuzybtBi01mnU2NB0Kc046jEeA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OKG8vNM2tSTwkUQGaBn/4MRNM3a+r6UoCIZz6BM61rM=;
 b=dO8AChuSA1/5EmBkmsC+Itm0VObtmh3LLXzEo6K9tHKGZf657afalKTdtH9ZOz4Ox5jbXco8vPXlFk4sJAj4TM+Uor29B0icYPxDOGCmPUdAKpA6yd7kCS4IKvdipmUtO4usAo4w2UnvoGs7uR7khDCKnr++TKGF9TIK+Vmyoxs=
Received: from MWHPR15MB1216.namprd15.prod.outlook.com (10.175.2.17) by
 MWHPR15MB1229.namprd15.prod.outlook.com (10.175.7.150) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.18; Mon, 19 Aug 2019 23:22:46 +0000
Received: from MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc]) by MWHPR15MB1216.namprd15.prod.outlook.com
 ([fe80::2971:619a:860e:b6cc%2]) with mapi id 15.20.2178.018; Mon, 19 Aug 2019
 23:22:46 +0000
From:   Tao Ren <taoren@fb.com>
To:     =?utf-8?B?UmVuw6kgdmFuIERvcnN0?= <opensource@vdorst.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Arun Parameswaran <arun.parameswaran@broadcom.com>,
        Justin Chen <justinpopo6@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>
Subject: Re: [PATCH net-next v7 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Topic: [PATCH net-next v7 2/3] net: phy: add support for clause 37
 auto-negotiation
Thread-Index: AQHVUJ5sDC2N3IVmSU23JGeEcwfh/acCoVoAgACFYACAAAIKAA==
Date:   Mon, 19 Aug 2019 23:22:46 +0000
Message-ID: <bddec4ff-6077-ab9b-7f7e-000e661ecbed@fb.com>
References: <20190811234010.3673592-1-taoren@fb.com>
 <3af5d897-7f97-a223-2d7b-56e09b83dcb5@fb.com>
 <20190819231526.Horde.8CjxfcGbCnfBNA-nXmq1PJt@www.vdorst.com>
In-Reply-To: <20190819231526.Horde.8CjxfcGbCnfBNA-nXmq1PJt@www.vdorst.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0008.namprd14.prod.outlook.com
 (2603:10b6:300:ae::18) To MWHPR15MB1216.namprd15.prod.outlook.com
 (2603:10b6:320:22::17)
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:cf6e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d426c55c-9062-48dd-fa5a-08d724fc24d0
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR15MB1229;
x-ms-traffictypediagnostic: MWHPR15MB1229:
x-microsoft-antispam-prvs: <MWHPR15MB1229CA736E6FE29A932A9C75B2A80@MWHPR15MB1229.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 0134AD334F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(136003)(39860400002)(376002)(346002)(199004)(189003)(229853002)(102836004)(14444005)(66446008)(64756008)(66556008)(256004)(66476007)(66946007)(6246003)(6486002)(53936002)(58126008)(54906003)(65956001)(65806001)(6116002)(71190400001)(71200400001)(52116002)(99286004)(305945005)(7736002)(5660300002)(36756003)(76176011)(316002)(31686004)(486006)(7416002)(25786009)(8936002)(446003)(2906002)(186003)(46003)(6512007)(65826007)(11346002)(86362001)(6916009)(6436002)(31696002)(53546011)(6506007)(386003)(4326008)(2616005)(8676002)(476003)(81166006)(81156014)(14454004)(478600001)(64126003);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1229;H:MWHPR15MB1216.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: r4kLBF/UK5wsc0FU+Z/IGRsOtznoNEcHkN+GnXYFMIP92jd9uZiCSP88qcCz69Q50p+U6GhMqrPgygvcSyjZYvPbeugiNsOhvyosAJKF8xUeZWo6441IQd7IAExdORp2zmb9UO1VplUFQPG0nEwpb5KYGHfkd+DKNJGoQltC/Tbuvvh7+ruJquVH5HPBWV464UC8/ZH2yCJR5fixxPmyM7bwwHQYO2Na6hf+7Jga1Yr0Zpqz2nI/nQ9TurlXQii4WNfe3rPI/TB9j3q/kiPcquxlvqJH6kXuaeBdGJLRg0P7isfuvUFV3givpKwILHdkXcc054uOb3jZ4cuMNY5Hz5Aq/r1bSDNzoyDGts3QMdtaP/k5FNee++4ZnnHxLfV6qlwgZB7YMtGGd/h9uE29jVMQjvCJnHtXSkY5ksNxlq0=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <3982435C23D3BB4F915D2D6EE5830EFB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d426c55c-9062-48dd-fa5a-08d724fc24d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2019 23:22:46.6657
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /hYvnnqipH0vVxr5t4H6j/v8LBOzFcwSLMeb7iPLOxRqgp4n7AsysESJAaadpkWx
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1229
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-19_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908190230
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xOS8xOSA0OjE1IFBNLCBSZW7DqSB2YW4gRG9yc3Qgd3JvdGU6DQo+IEhpIFRhbywNCj4g
DQo+IFF1b3RpbmcgVGFvIFJlbiA8dGFvcmVuQGZiLmNvbT46DQo+IA0KPj4gT24gOC8xMS8xOSA0
OjQwIFBNLCBUYW8gUmVuIHdyb3RlOg0KPj4+IEZyb206IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3
ZWl0MUBnbWFpbC5jb20+DQo+Pj4NCj4+PiBUaGlzIHBhdGNoIGFkZHMgc3VwcG9ydCBmb3IgY2xh
dXNlIDM3IDEwMDBCYXNlLVggYXV0by1uZWdvdGlhdGlvbi4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYt
Ynk6IEhlaW5lciBLYWxsd2VpdCA8aGthbGx3ZWl0MUBnbWFpbC5jb20+DQo+Pj4gU2lnbmVkLW9m
Zi1ieTogVGFvIFJlbiA8dGFvcmVuQGZiLmNvbT4NCj4+DQo+PiBBIGtpbmQgcmVtaW5kZXI6IGNv
dWxkIHNvbWVvbmUgaGVscCB0byByZXZpZXcgdGhlIHBhdGNoIHdoZW4geW91IGhhdmUgYmFuZHdp
ZHRoPw0KPj4NCj4gDQo+IEZXSVc6IEkgaGF2ZSBhIHNpbWlsYXIgc2V0dXAgd2l0aCBteSBkZXZp
Y2UuIE1BQyAtPiBQSFkgLT4gU0ZQIGNhZ2UuDQo+IFBIWSBpcyBhIFF1YWxjb21tIGF0ODAzMSBh
bmQgaXMgdXNlZCBhcyBhIFJHTUlJLXRvLVNlckRlcyBjb252ZXJ0ZXIuDQo+IFNlckRlcyBvbmx5
IHN1cHBvcnQgMTAwQmFzZS1GWCBhbmQgMTAwMEJhc2UtWCBpbiB0aGlzIGNvbnZlcnRlciBtb2Rl
Lg0KPiBQSFkgYWxzbyBzdXBwb3J0cyBhIFJKNDUgcG9ydCBidXQgdGhhdCBpcyBub3Qgd2lyZWQg
b24gbXkgZGV2aWNlLg0KPiANCj4gSSBjb252ZXJ0ZWQgWzBdIGF0ODAzeCBkcml2ZXIgdG8gbWFr
ZSB1c2Ugb2YgdGhlIFBIWUxJTksgQVBJIGZvciBTRlAgY2FnZSBhbmQNCj4gYWxzbyBvZiB0aGVz
ZSBuZXcgYzM3IGZ1bmN0aW9ucy4NCj4gDQo+IEluIGF1dG9uZWcgb24gYW5kIG9mZiwgaXQgZGV0
ZWN0cyB0aGUgbGluayBhbmQgY2FuIHBpbmcgYSBob3N0IG9uIHRoZSBuZXR3b3JrLg0KPiBUZXN0
ZWQgd2l0aCAxZ2JpdCBCaURpIG9wdGljYWwoMTAwMEJhc2UtWCkgYW5kIFJKNDUgbW9kdWxlKFNH
TUlJKS4NCj4gQm90aCB3b3JrIGFuZCBib3RoIGRldmljZXMgZGV0ZWN0cyB1bnBsdWcgYW5kIHBs
dWctaW4gb2YgdGhlIGNhYmxlLg0KPiANCj4gb3V0cHV0IG9mIGV0aHRvb2w6DQo+IA0KPiBBdXRv
bmVnIG9uDQo+IFNldHRpbmdzIGZvciBsYW41Og0KPiDCoMKgwqDCoMKgwqDCoCBTdXBwb3J0ZWQg
cG9ydHM6IFsgVFAgTUlJIF0NCj4gwqDCoMKgwqDCoMKgwqAgU3VwcG9ydGVkIGxpbmsgbW9kZXM6
wqDCoCAxMDBiYXNlVC9IYWxmIDEwMGJhc2VUL0Z1bGwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTAwMGJhc2VUL0Z1bGwN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgMTAwMGJhc2VYL0Z1bGwNCj4gwqDCoMKgwqDCoMKgwqAgU3VwcG9ydGVkIHBhdXNl
IGZyYW1lIHVzZTogU3ltbWV0cmljIFJlY2VpdmUtb25seQ0KPiDCoMKgwqDCoMKgwqDCoCBTdXBw
b3J0cyBhdXRvLW5lZ290aWF0aW9uOiBZZXMNCj4gwqDCoMKgwqDCoMKgwqAgU3VwcG9ydGVkIEZF
QyBtb2RlczogTm90IHJlcG9ydGVkDQo+IMKgwqDCoMKgwqDCoMKgIEFkdmVydGlzZWQgbGluayBt
b2RlczrCoCAxMDBiYXNlVC9IYWxmIDEwMGJhc2VUL0Z1bGwNCj4gwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTAwMGJhc2VUL0Z1
bGwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqAgMTAwMGJhc2VYL0Z1bGwNCj4gwqDCoMKgwqDCoMKgwqAgQWR2ZXJ0aXNlZCBw
YXVzZSBmcmFtZSB1c2U6IFN5bW1ldHJpYyBSZWNlaXZlLW9ubHkNCj4gwqDCoMKgwqDCoMKgwqAg
QWR2ZXJ0aXNlZCBhdXRvLW5lZ290aWF0aW9uOiBZZXMNCj4gwqDCoMKgwqDCoMKgwqAgQWR2ZXJ0
aXNlZCBGRUMgbW9kZXM6IE5vdCByZXBvcnRlZA0KPiDCoMKgwqDCoMKgwqDCoCBMaW5rIHBhcnRu
ZXIgYWR2ZXJ0aXNlZCBsaW5rIG1vZGVzOsKgIDEwMDBiYXNlWC9GdWxsDQo+IMKgwqDCoMKgwqDC
oMKgIExpbmsgcGFydG5lciBhZHZlcnRpc2VkIHBhdXNlIGZyYW1lIHVzZTogU3ltbWV0cmljIFJl
Y2VpdmUtb25seQ0KPiDCoMKgwqDCoMKgwqDCoCBMaW5rIHBhcnRuZXIgYWR2ZXJ0aXNlZCBhdXRv
LW5lZ290aWF0aW9uOiBZZXMNCj4gwqDCoMKgwqDCoMKgwqAgTGluayBwYXJ0bmVyIGFkdmVydGlz
ZWQgRkVDIG1vZGVzOiBOb3QgcmVwb3J0ZWQNCj4gwqDCoMKgwqDCoMKgwqAgU3BlZWQ6IDEwMDBN
Yi9zDQo+IMKgwqDCoMKgwqDCoMKgIER1cGxleDogRnVsbA0KPiDCoMKgwqDCoMKgwqDCoCBQb3J0
OiBNSUkNCj4gwqDCoMKgwqDCoMKgwqAgUEhZQUQ6IDcNCj4gwqDCoMKgwqDCoMKgwqAgVHJhbnNj
ZWl2ZXI6IGludGVybmFsDQo+IMKgwqDCoMKgwqDCoMKgIEF1dG8tbmVnb3RpYXRpb246IG9uDQo+
IMKgwqDCoMKgwqDCoMKgIFN1cHBvcnRzIFdha2Utb246IGcNCj4gwqDCoMKgwqDCoMKgwqAgV2Fr
ZS1vbjogZA0KPiDCoMKgwqDCoMKgwqDCoCBMaW5rIGRldGVjdGVkOiB5ZXMNCj4gDQo+IEF1dG9u
ZWcgb2ZmDQo+IFNldHRpbmdzIGZvciBsYW41Og0KPiDCoMKgwqDCoMKgwqDCoCBTdXBwb3J0ZWQg
cG9ydHM6IFsgVFAgTUlJIF0NCj4gwqDCoMKgwqDCoMKgwqAgU3VwcG9ydGVkIGxpbmsgbW9kZXM6
wqDCoCAxMDBiYXNlVC9IYWxmIDEwMGJhc2VUL0Z1bGwNCj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgMTAwMGJhc2VUL0Z1bGwN
Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgMTAwMGJhc2VYL0Z1bGwNCj4gwqDCoMKgwqDCoMKgwqAgU3VwcG9ydGVkIHBhdXNl
IGZyYW1lIHVzZTogU3ltbWV0cmljIFJlY2VpdmUtb25seQ0KPiDCoMKgwqDCoMKgwqDCoCBTdXBw
b3J0cyBhdXRvLW5lZ290aWF0aW9uOiBZZXMNCj4gwqDCoMKgwqDCoMKgwqAgU3VwcG9ydGVkIEZF
QyBtb2RlczogTm90IHJlcG9ydGVkDQo+IMKgwqDCoMKgwqDCoMKgIEFkdmVydGlzZWQgbGluayBt
b2RlczrCoCAxMDAwYmFzZVQvRnVsbA0KPiDCoMKgwqDCoMKgwqDCoCBBZHZlcnRpc2VkIHBhdXNl
IGZyYW1lIHVzZTogU3ltbWV0cmljIFJlY2VpdmUtb25seQ0KPiDCoMKgwqDCoMKgwqDCoCBBZHZl
cnRpc2VkIGF1dG8tbmVnb3RpYXRpb246IE5vDQo+IMKgwqDCoMKgwqDCoMKgIEFkdmVydGlzZWQg
RkVDIG1vZGVzOiBOb3QgcmVwb3J0ZWQNCj4gwqDCoMKgwqDCoMKgwqAgU3BlZWQ6IDEwMDBNYi9z
DQo+IMKgwqDCoMKgwqDCoMKgIER1cGxleDogRnVsbA0KPiDCoMKgwqDCoMKgwqDCoCBQb3J0OiBN
SUkNCj4gwqDCoMKgwqDCoMKgwqAgUEhZQUQ6IDcNCj4gwqDCoMKgwqDCoMKgwqAgVHJhbnNjZWl2
ZXI6IGludGVybmFsDQo+IMKgwqDCoMKgwqDCoMKgIEF1dG8tbmVnb3RpYXRpb246IG9mZg0KPiDC
oMKgwqDCoMKgwqDCoCBTdXBwb3J0cyBXYWtlLW9uOiBnDQo+IMKgwqDCoMKgwqDCoMKgIFdha2Ut
b246IGQNCj4gwqDCoMKgwqDCoMKgwqAgTGluayBkZXRlY3RlZDogeWVzDQo+IA0KPiBUZXN0ZWQt
Ynk6IFJlbsOpIHZhbiBEb3JzdCA8b3BlbnNvdXJjZUB2ZG9yc3QuY29tPg0KPiANCj4gR3JlYXRz
LA0KPiANCj4gUmVuw6kNCg0KR3JlYXQuIFRoYW5rIHlvdSBmb3IgdGhlIHRlc3RpbmcsIFJlbsOp
Lg0KDQoNCkNoZWVycywNCg0KVGFvDQo=
