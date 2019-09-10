Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3574AF2D8
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 00:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbfIJWPG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 18:15:06 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53692 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725957AbfIJWPG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 18:15:06 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8AMDjLg022869;
        Tue, 10 Sep 2019 15:14:02 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=R3Q/kyCnpTZjMXGzS0ESKtYC9Iz3hyn8lQ2bfGuGMa8=;
 b=VMDDgOAVyrxVQYMBmYX9R11SUWwOWKCKinW/0VjmFzJdvpJ1T0mC23RdG9c6gcg9Zc4N
 muY7yKosfutO7nQnEb5YCIYbGZO4/r5N2DY/h8AesXI1xZBY5DOw/4vVOA7UjmvIU/Xo
 GufIWqe+HKdXjclQbZZHYTcQ5+fJWZvuNlQ= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2uwx9mnw97-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 10 Sep 2019 15:14:02 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 10 Sep 2019 15:14:00 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 15:14:00 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bJ/sz8NHeXLUQ0TSakjSzCxdLtVRR2wCFLQlhhVx2NRToPyY3GDyE7TLm4n4M2GOT/6iQpjR+yw1RrhjdhIoDiMAMOyZ+PBCTe31CJpcS1iLIfUQ2pev5VgGJ6D92cWuTVT7C58C/czzLQgPtkhnr5dX0LnqkuRemUKGOzvMe382tOaNhTYRdDDKoQaxDR55pWhCMsW9hsfSaeAyEG0eR8sgyJ2g2DRbdPhGgtlxH/2Kqeal6/jRP1nsAfVg492uhdCtl1gK5ir0Tw/cS6VIr4YdwObXoZYTj8iWyn1tqBtoURciw1jC6y+BXQxsx/+pxLsNmRuBrmzMiF+SRnQ1Jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3Q/kyCnpTZjMXGzS0ESKtYC9Iz3hyn8lQ2bfGuGMa8=;
 b=mf0kFeMSgmRKHTNvrRqQucNt/wY9UxE3s9Sbf0YzCLNtFC9/lrihRG2oyDE7gJBwy01aoZkb6Frgq3cFhiT+UuLSvvVtWcfckH/g8NyKNf02mCzvi7B2bWzrqPPswWIEXHwVAU6MvlpIaFd4pOyXrWpW3O4vvxItgxLOcSRA+ru8Es3jxQlkS9iYRUNS5DLK5RRwA+yQ20LxCiSl4DpGXDdKqEfgH9i5cgsNbO+BrG6W7BS4VIwYHQSvWN5yJSZc0KXDJTrz1Zc+P7NgTTrrRYQiFKI9asCcz2IrRLwfyCaSkoZ3kTs3x6giNdzIyIP9MJ7aCM1d6CuGVXwLrCuN5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R3Q/kyCnpTZjMXGzS0ESKtYC9Iz3hyn8lQ2bfGuGMa8=;
 b=S/ndRT9UYinBASE6/5t3yaxYqtCsJJHqgmCYrWehOLkkMAJHXJjtz7xyEq24MNSNHi+MoVhcRfEb6zJ1nFfVdaPkEQ7LyF+g1VjleQOgesJHWpYKv2T3FCgrqgvTW2TZNidn5thXaOTynrZXuBIPJ5GAnAZGtyHSp8O3dn0V/os=
Received: from CY4PR15MB1269.namprd15.prod.outlook.com (10.172.177.11) by
 CY4PR15MB1304.namprd15.prod.outlook.com (10.172.181.135) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.19; Tue, 10 Sep 2019 22:13:59 +0000
Received: from CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b]) by CY4PR15MB1269.namprd15.prod.outlook.com
 ([fe80::38b1:336:13e6:b02b%7]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 22:13:59 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        YueHaibing <yuehaibing@huawei.com>, Andrew Lunn <andrew@lunn.ch>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        "Mauro Carvalho Chehab" <mchehab+samsung@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     "openbmc @ lists . ozlabs . org" <openbmc@lists.ozlabs.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        Sai Dasari <sdasari@fb.com>
Subject: Re: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Topic: [PATCH] ftgmac100: Disable HW checksum generation on AST2500
Thread-Index: AQHVaCL3HHZ/0IxjZ0GB2KAMVKzdAqcld28A//+NBwA=
Date:   Tue, 10 Sep 2019 22:13:59 +0000
Message-ID: <CB5E42DA-E357-49F5-9060-C1C0C6921624@fb.com>
References: <20190910213734.3112330-1-vijaykhemka@fb.com>
 <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
In-Reply-To: <bd5eab2e-6ba6-9e27-54d4-d9534da9d5f7@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::2:1b73]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4ea1f637-6d71-47a8-37f9-08d7363c2df5
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1304;
x-ms-traffictypediagnostic: CY4PR15MB1304:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR15MB13047D3244EF9264F7D8E288DDB60@CY4PR15MB1304.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3826;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(376002)(136003)(366004)(189003)(199004)(2501003)(6436002)(186003)(102836004)(7736002)(14454004)(2906002)(5660300002)(8676002)(256004)(14444005)(91956017)(76116006)(6486002)(6116002)(7416002)(76176011)(86362001)(8936002)(33656002)(229853002)(64756008)(66476007)(66446008)(66556008)(66946007)(6246003)(53546011)(6512007)(99286004)(11346002)(53936002)(6506007)(81156014)(81166006)(476003)(2616005)(25786009)(316002)(446003)(4326008)(478600001)(46003)(305945005)(36756003)(54906003)(2201001)(110136005)(71200400001)(71190400001)(486006)(921003)(1121003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1304;H:CY4PR15MB1269.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: uFa9THhDLjaGtgnnDfIc81bw/wTVMhcEO2z7TxjMlHLZIGEJpVKrvpjfmgG6u/rDuh+IOy54xriTo67wvVvzdORLfQF9fHBTbjHIC3f/4M39ukLrooc5Pv4dUR/7QP1Y2vBQfYrIfkIsyKIb8TaS8E6LE/U7DlYzvZ5gexWEoqIN03p3qxo9ojZbAebZUrp1DrPhgPFuxc0cesZNGa1XiyTRjtb7zdv6Jok0CZS5bt/lWHaO2t4O7E+FH1i+/sEfhHvO6ZWQ/WKvdE7gZ/Vk3qeCKKOIrq0/CQ1NMMtbFhnoUIpgz9NAt4z9t7CMIjdpt2zB2JnbO9DSvVKsZRbtEYL3Skz+YROdOSw9b6Xdz31ZlDJSOqS61dUOEtalOsxY5jZ8VTsaLP2naQg2Q++scljnl1w8hA54ISgD40IDMiw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DB3744203F00AD458889CDF535E8525B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ea1f637-6d71-47a8-37f9-08d7363c2df5
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 22:13:59.1558
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /WQJBDn+8rC4bKPnbQDfDC5/9lD0s8iLHxBr/05eHKTawCz+x4b2auTAKBFzW6RjXiVXvPVKREnK9V/2fno2qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1304
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_12:2019-09-10,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 priorityscore=1501 bulkscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 impostorscore=0 malwarescore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1906280000 definitions=main-1909100208
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCu+7v09uIDkvMTAvMTksIDM6MDUgUE0sICJGbG9yaWFuIEZhaW5lbGxpIiA8Zi5mYWluZWxs
aUBnbWFpbC5jb20+IHdyb3RlOg0KDQogICAgT24gOS8xMC8xOSAyOjM3IFBNLCBWaWpheSBLaGVt
a2Egd3JvdGU6DQogICAgPiBIVyBjaGVja3N1bSBnZW5lcmF0aW9uIGlzIG5vdCB3b3JraW5nIGZv
ciBBU1QyNTAwLCBzcGVjaWFsbHkgd2l0aCBJUFY2DQogICAgPiBvdmVyIE5DU0kuIEFsbCBUQ1Ag
cGFja2V0cyB3aXRoIElQdjYgZ2V0IGRyb3BwZWQuIEJ5IGRpc2FibGluZyB0aGlzDQogICAgPiBp
dCB3b3JrcyBwZXJmZWN0bHkgZmluZSB3aXRoIElQVjYuDQogICAgPiANCiAgICA+IFZlcmlmaWVk
IHdpdGggSVBWNiBlbmFibGVkIGFuZCBjYW4gZG8gc3NoLg0KICAgIA0KICAgIEhvdyBhYm91dCBJ
UHY0LCBkbyB0aGVzZSBwYWNrZXRzIGhhdmUgcHJvYmxlbT8gSWYgbm90LCBjYW4geW91IGNvbnRp
bnVlDQogICAgYWR2ZXJ0aXNpbmcgTkVUSUZfRl9JUF9DU1VNIGJ1dCB0YWtlIG91dCBORVRJRl9G
X0lQVjZfQ1NVTT8NCg0KWWVzIElQdjQgd29ya3MuIExldCBtZSB0ZXN0IHdpdGggeW91ciBzdWdn
ZXN0aW9uIGFuZCB3aWxsIHVwZGF0ZSBwYXRjaC4NCiAgICANCiAgICA+IA0KICAgID4gU2lnbmVk
LW9mZi1ieTogVmlqYXkgS2hlbWthIDx2aWpheWtoZW1rYUBmYi5jb20+DQogICAgPiAtLS0NCiAg
ICA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jIHwgNSArKystLQ0K
ICAgID4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQog
ICAgPiANCiAgICA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0
Z21hYzEwMC5jIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAg
ID4gaW5kZXggMDMwZmVkNjUzOTNlLi41OTFjOTcyNTAwMmIgMTAwNjQ0DQogICAgPiAtLS0gYS9k
cml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgPiArKysgYi9kcml2
ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5L2Z0Z21hYzEwMC5jDQogICAgPiBAQCAtMTgzOSw4ICsx
ODM5LDkgQEAgc3RhdGljIGludCBmdGdtYWMxMDBfcHJvYmUoc3RydWN0IHBsYXRmb3JtX2Rldmlj
ZSAqcGRldikNCiAgICA+ICAJaWYgKHByaXYtPnVzZV9uY3NpKQ0KICAgID4gIAkJbmV0ZGV2LT5o
d19mZWF0dXJlcyB8PSBORVRJRl9GX0hXX1ZMQU5fQ1RBR19GSUxURVI7DQogICAgPiAgDQogICAg
PiAtCS8qIEFTVDI0MDAgIGRvZXNuJ3QgaGF2ZSB3b3JraW5nIEhXIGNoZWNrc3VtIGdlbmVyYXRp
b24gKi8NCiAgICA+IC0JaWYgKG5wICYmIChvZl9kZXZpY2VfaXNfY29tcGF0aWJsZShucCwgImFz
cGVlZCxhc3QyNDAwLW1hYyIpKSkNCiAgICA+ICsJLyogQVNUMjQwMCAgYW5kIEFTVDI1MDAgZG9l
c24ndCBoYXZlIHdvcmtpbmcgSFcgY2hlY2tzdW0gZ2VuZXJhdGlvbiAqLw0KICAgID4gKwlpZiAo
bnAgJiYgKG9mX2RldmljZV9pc19jb21wYXRpYmxlKG5wLCAiYXNwZWVkLGFzdDI0MDAtbWFjIikg
fHwNCiAgICA+ICsJCSAgIG9mX2RldmljZV9pc19jb21wYXRpYmxlKG5wLCAiYXNwZWVkLGFzdDI1
MDAtbWFjIikpKQ0KICAgID4gIAkJbmV0ZGV2LT5od19mZWF0dXJlcyAmPSB+TkVUSUZfRl9IV19D
U1VNOw0KICAgID4gIAlpZiAobnAgJiYgb2ZfZ2V0X3Byb3BlcnR5KG5wLCAibm8taHctY2hlY2tz
dW0iLCBOVUxMKSkNCiAgICA+ICAJCW5ldGRldi0+aHdfZmVhdHVyZXMgJj0gfihORVRJRl9GX0hX
X0NTVU0gfCBORVRJRl9GX1JYQ1NVTSk7DQogICAgPiANCiAgICANCiAgICANCiAgICAtLSANCiAg
ICBGbG9yaWFuDQogICAgDQoNCg==
