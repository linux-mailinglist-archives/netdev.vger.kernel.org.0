Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2072DE5420
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 21:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726414AbfJYTLk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 15:11:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:32698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725811AbfJYTLj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 15:11:39 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9PJAYxI008602;
        Fri, 25 Oct 2019 12:11:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ixPHeucQRcIVsxhzploSBJRXghgFftytSMNEKRKxGFI=;
 b=hJZ3D6oya2nRihlV/Fdf38bcOP2OY8N+uCUrYWNgoudyTQaS5J7dMQYb1j+XE/e/9Xjx
 bl/EV5G3kFBLkLOBLFyeNZ+MX1EzlAkvWKRW/4hox8YSLT6BomIHHsp+PRcWjIwHBTuB
 z6AH9yBsFYasbFnvQNlEHg6mme3ywTfBof8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vv228smrp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 25 Oct 2019 12:11:23 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 25 Oct 2019 12:11:22 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 25 Oct 2019 12:11:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hGlyEQJtPa5r9nJeFOI6mbzxq5ZemSH2gVPGBxD8WFxQ9RlIlykBaCemf0Vzvn00UTplvIywJN1qQqAcmgSURO/J6WuEPpnDz/pU+7gI49PTk85vpqL9iwzTUfs8zhfRu2c2qeEZwvJ7LinuX/qLOifx09qYrO2uQuAn58YeLfNjanRsxbLgLAUILkZWI80V/1mdmVe7B87Vg0Q6XsYcm6sasUpEqId99Y3RKEtHEPQLjy0yBBEey1y2mWtyYlrZTEDkwCFN9atmLioWZDl80eebRGFlvxs+4/tLxtOrAAkQ8cuy9XG7IuKT983uRWgsrDnPYsKGI9ZcfViLnGxV8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixPHeucQRcIVsxhzploSBJRXghgFftytSMNEKRKxGFI=;
 b=ijDiSjWSYooD+X2050KrXvHB6chwv375d3gVvO6MT7ZraeAkKIx5mKEVsu9r6xL1gKJAR2PiCsfAY0TAI0XFxohwgtXcUTnI/5mboLayRZqiKZPBGVlXbCC9soqkSwob2gFjPDMCF7uJxY0Opthm/HNLcZ9PFh8NXKFG7KA3xbSTqdIUVjchxfPP9W0f3ja3FnUGVofZfNRudFL/xJByQqG9v03zSpMnG0DRkQA3vOV3LAI/ZztObJgzLxuKVShUL3pM/uqznOlLs7bHSfyFGk3dr13vgZkJI0H9vy+4oA9D8IdkMs9EadH7s7Rmy0bWDS+wm6X8ItjVa19MQHFUUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ixPHeucQRcIVsxhzploSBJRXghgFftytSMNEKRKxGFI=;
 b=enutPeY5QKsavHp7vEudbcr8geyXlPIMmVQlu1E3p0epguVdWB1ujd9KQs5vEJk5Frl2SQegGENm39pOQGjf0BYgeepTZ4u0vHu69/ym3kxe7VOhCde850fOHd48hgq89VuDMmQ8QUTT3UDIbnDOB3M68WLdglcUKX3J8t7spEs=
Received: from BY5PR15MB3636.namprd15.prod.outlook.com (52.133.252.91) by
 BY5PR15MB3730.namprd15.prod.outlook.com (10.255.245.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Fri, 25 Oct 2019 19:11:21 +0000
Received: from BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c]) by BY5PR15MB3636.namprd15.prod.outlook.com
 ([fe80::7887:4f9c:70df:285c%4]) with mapi id 15.20.2387.021; Fri, 25 Oct 2019
 19:11:21 +0000
From:   Vijay Khemka <vijaykhemka@fb.com>
To:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "openbmc@lists.ozlabs.org" <openbmc@lists.ozlabs.org>,
        Joel Stanley <joel@jms.id.au>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>
Subject: Re: [PATCH] net: ethernet: ftgmac100: Fix DMA coherency issue with SW
 checksum
Thread-Topic: [PATCH] net: ethernet: ftgmac100: Fix DMA coherency issue with
 SW checksum
Thread-Index: AQHVit6c66EdjV5oI0is+zg9ZLMyJKdrROEA
Date:   Fri, 25 Oct 2019 19:11:21 +0000
Message-ID: <672FAA6F-5DA7-4AA7-A049-96DF82CEEA18@fb.com>
References: <572a7d510ace5e5a5ba41c4774d330133291c82a.camel@kernel.crashing.org>
In-Reply-To: <572a7d510ace5e5a5ba41c4774d330133291c82a.camel@kernel.crashing.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::1:a02c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9c774634-8443-4056-6a1d-08d7597f1ef2
x-ms-traffictypediagnostic: BY5PR15MB3730:
x-microsoft-antispam-prvs: <BY5PR15MB37307AACDD3047E108D77E08DD650@BY5PR15MB3730.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:644;
x-forefront-prvs: 02015246A9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(376002)(366004)(396003)(346002)(189003)(199004)(256004)(99286004)(14444005)(478600001)(8676002)(305945005)(81156014)(81166006)(7736002)(6116002)(66556008)(91956017)(186003)(11346002)(2906002)(66476007)(2616005)(486006)(476003)(64756008)(66446008)(66946007)(46003)(446003)(76116006)(6512007)(76176011)(33656002)(102836004)(6506007)(6246003)(36756003)(6486002)(14454004)(71190400001)(71200400001)(25786009)(54906003)(110136005)(86362001)(4326008)(229853002)(316002)(5660300002)(6436002)(8936002);DIR:OUT;SFP:1102;SCL:1;SRVR:BY5PR15MB3730;H:BY5PR15MB3636.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fZOcvYlrA4OFXJS1BReVQf9UCJuZ6zS1t0dCtoi2LHOQraWoDqAZoTsXWYMmD5fEly75p96BXWvcymnFYfedpRSnIyf/9UhIo/ssmb3ZlBmih+PSz+bKdfWrD+x5I32UXA4qSZO68g2jU95iEkypTtERx3s8EcgqmIZvZMalFAZHysmVNWdFgPHOaJKW3TVb/EjqvYXkIiEGMsvpyZAGlGNES2kAtamw76cuqnQhGOp75GjdS7D4JPi2oEPGnjCb/xKZP7TedUpb2N5LHHVELrZf7ytZqLOVKazyMcVUzFWSKZ5oOR4hBL7t6K3kkNof0CnpPkNIR2/EpZV+HqBXeRQXvnvFfuP8IvBsOhJZJjOA3ptbUWk2+a/COsUn8q4HC2UXGQb51F00y/yV8z5c6elGbdGo1O+gnUjzDCVrBYxi4hmtKgt3qe1EvPbc3V8d
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <49B366D14C875646BD4F08CFAC54D4E8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9c774634-8443-4056-6a1d-08d7597f1ef2
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Oct 2019 19:11:21.0386
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p5qG5MX0oeaHB3FLSzx34RBLaNgrCtC1tpbxGqMbzT3JZ+HCPt7w0SHpijSjwyj2z1NS4wbL8DLqcE4Tz41jww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR15MB3730
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-25_09:2019-10-25,2019-10-25 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 clxscore=1015 mlxlogscore=998 phishscore=0 malwarescore=0 bulkscore=0
 spamscore=0 mlxscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910250173
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TG9va3MgZ29vZCB0byBtZS4gQW5kIEkgaGF2ZSB0ZXN0ZWQgaXQuIEl0IHdvcmtzIHBlcmZlY3Rs
eSBmaW5lLg0KDQpSZXZpZXdlZC1ieTogVmlqYXkgS2hlbWthIDx2aWpheWtoZW1rYUBmYi5jb20+
DQpUZXN0ZWQtYnk6IFZpamF5IEtoZW1rYSA8dmlqYXlraGVta2FAZmIuY29tPg0KDQrvu79PbiAx
MC8yNC8xOSwgNzo0NyBQTSwgIkJlbmphbWluIEhlcnJlbnNjaG1pZHQiIDxiZW5oQGtlcm5lbC5j
cmFzaGluZy5vcmc+IHdyb3RlOg0KDQogICAgV2UgYXJlIGNhbGxpbmcgdGhlIGNoZWNrc3VtIGhl
bHBlciBhZnRlciB0aGUgZG1hX21hcF9zaW5nbGUoKQ0KICAgIGNhbGwgdG8gbWFwIHRoZSBwYWNr
ZXQuIFRoaXMgaXMgaW5jb3JyZWN0IGFzIHRoZSBjaGVja3N1bW1pbmcNCiAgICBjb2RlIHdpbGwg
dG91Y2ggdGhlIHBhY2tldCBmcm9tIHRoZSBDUFUuIFRoaXMgbWVhbnMgdGhlIGNhY2hlDQogICAg
d29uJ3QgYmUgcHJvcGVybHkgZmx1c2hlcyAob3IgdGhlIGJvdW5jZSBidWZmZXJpbmcgd2lsbCBs
ZWF2ZQ0KICAgIHVzIHdpdGggdGhlIHVubW9kaWZpZWQgcGFja2V0IHRvIERNQSkuDQogICAgDQog
ICAgVGhpcyBtb3ZlcyB0aGUgY2FsY3VsYXRpb24gb2YgdGhlIGNoZWNrc3VtICYgdmxhbiB0YWdz
IHRvDQogICAgYmVmb3JlIHRoZSBETUEgbWFwcGluZy4NCiAgICANCiAgICBUaGlzIGFsc28gaGFz
IHRoZSBzaWRlIGVmZmVjdCBvZiBmaXhpbmcgYW5vdGhlciBidWc6IElmIHRoZQ0KICAgIGNoZWNr
c3VtIGhlbHBlciBmYWlscywgd2UgZ290byAiZHJvcCIgdG8gZHJvcCB0aGUgcGFja2V0LCB3aGlj
aA0KICAgIHdpbGwgbm90IHVubWFwIHRoZSBETUEgbWFwcGluZy4NCiAgICANCiAgICBTaWduZWQt
b2ZmLWJ5OiBCZW5qYW1pbiBIZXJyZW5zY2htaWR0IDxiZW5oQGtlcm5lbC5jcmFzaGluZy5vcmc+
DQogICAgRml4ZXM6IDA1NjkwZDYzM2YzMCBmdGdtYWMxMDA6IFVwZ3JhZGUgdG8gTkVUSUZfRl9I
V19DU1VNDQogICAgQ0M6IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcgW3Y0LjEyK10NCiAgICAtLS0N
CiAgICAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYyB8IDI1ICsrKysr
KysrKysrKy0tLS0tLS0tLS0tLQ0KICAgICAxIGZpbGUgY2hhbmdlZCwgMTIgaW5zZXJ0aW9ucygr
KSwgMTMgZGVsZXRpb25zKC0pDQogICAgDQogICAgZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0
aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mYXJhZGF5
L2Z0Z21hYzEwMC5jDQogICAgaW5kZXggOWI3YWY5NGE0MGJiLi45NmU5NTY1ZjFlMDggMTAwNjQ0
DQogICAgLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZmFyYWRheS9mdGdtYWMxMDAuYw0KICAg
ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZhcmFkYXkvZnRnbWFjMTAwLmMNCiAgICBAQCAt
NzI3LDYgKzcyNywxOCBAQCBzdGF0aWMgbmV0ZGV2X3R4X3QgZnRnbWFjMTAwX2hhcmRfc3RhcnRf
eG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0KICAgICAJICovDQogICAgIAluZnJhZ3MgPSBza2Jf
c2hpbmZvKHNrYiktPm5yX2ZyYWdzOw0KICAgICANCiAgICArCS8qIFNldHVwIEhXIGNoZWNrc3Vt
bWluZyAqLw0KICAgICsJY3N1bV92bGFuID0gMDsNCiAgICArCWlmIChza2ItPmlwX3N1bW1lZCA9
PSBDSEVDS1NVTV9QQVJUSUFMICYmDQogICAgKwkgICAgIWZ0Z21hYzEwMF9wcmVwX3R4X2NzdW0o
c2tiLCAmY3N1bV92bGFuKSkNCiAgICArCQlnb3RvIGRyb3A7DQogICAgKw0KICAgICsJLyogQWRk
IFZMQU4gdGFnICovDQogICAgKwlpZiAoc2tiX3ZsYW5fdGFnX3ByZXNlbnQoc2tiKSkgew0KICAg
ICsJCWNzdW1fdmxhbiB8PSBGVEdNQUMxMDBfVFhERVMxX0lOU19WTEFOVEFHOw0KICAgICsJCWNz
dW1fdmxhbiB8PSBza2Jfdmxhbl90YWdfZ2V0KHNrYikgJiAweGZmZmY7DQogICAgKwl9DQogICAg
Kw0KICAgICAJLyogR2V0IGhlYWRlciBsZW4gKi8NCiAgICAgCWxlbiA9IHNrYl9oZWFkbGVuKHNr
Yik7DQogICAgIA0KICAgIEBAIC03NTMsMTkgKzc2NSw2IEBAIHN0YXRpYyBuZXRkZXZfdHhfdCBm
dGdtYWMxMDBfaGFyZF9zdGFydF94bWl0KHN0cnVjdCBza19idWZmICpza2IsDQogICAgIAlpZiAo
bmZyYWdzID09IDApDQogICAgIAkJZl9jdGxfc3RhdCB8PSBGVEdNQUMxMDBfVFhERVMwX0xUUzsN
CiAgICAgCXR4ZGVzLT50eGRlczMgPSBjcHVfdG9fbGUzMihtYXApOw0KICAgIC0NCiAgICAtCS8q
IFNldHVwIEhXIGNoZWNrc3VtbWluZyAqLw0KICAgIC0JY3N1bV92bGFuID0gMDsNCiAgICAtCWlm
IChza2ItPmlwX3N1bW1lZCA9PSBDSEVDS1NVTV9QQVJUSUFMICYmDQogICAgLQkgICAgIWZ0Z21h
YzEwMF9wcmVwX3R4X2NzdW0oc2tiLCAmY3N1bV92bGFuKSkNCiAgICAtCQlnb3RvIGRyb3A7DQog
ICAgLQ0KICAgIC0JLyogQWRkIFZMQU4gdGFnICovDQogICAgLQlpZiAoc2tiX3ZsYW5fdGFnX3By
ZXNlbnQoc2tiKSkgew0KICAgIC0JCWNzdW1fdmxhbiB8PSBGVEdNQUMxMDBfVFhERVMxX0lOU19W
TEFOVEFHOw0KICAgIC0JCWNzdW1fdmxhbiB8PSBza2Jfdmxhbl90YWdfZ2V0KHNrYikgJiAweGZm
ZmY7DQogICAgLQl9DQogICAgLQ0KICAgICAJdHhkZXMtPnR4ZGVzMSA9IGNwdV90b19sZTMyKGNz
dW1fdmxhbik7DQogICAgIA0KICAgICAJLyogTmV4dCBkZXNjcmlwdG9yICovDQogICAgDQogICAg
DQogICAgDQoNCg==
