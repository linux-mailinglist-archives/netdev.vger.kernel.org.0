Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 053907B483
	for <lists+netdev@lfdr.de>; Tue, 30 Jul 2019 22:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728460AbfG3UtY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jul 2019 16:49:24 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64976 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725913AbfG3UtY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jul 2019 16:49:24 -0400
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6UKmEaX031116;
        Tue, 30 Jul 2019 13:49:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=W3YzZMzSy/3wdeq3v+cbnRE7Q95plGtLGfxlb9Zom80=;
 b=Cyspwx9X9OuozNmg8UXE2CBUMP/jIF5w539Z6NAo8e56E1cUO4Jhu8brefx7enxz7kjS
 03KRCaAVIyEf0d+7s4JQcekB2Obkz9VsIlbi9Z5mKLuFQ5c6kv6Vl1u/hzypS12KbIP0
 eY57z/+Ft3vNylPphgR6sTok2ACaquWVbvk= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2u2ty50j09-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 30 Jul 2019 13:49:12 -0700
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub103.TheFacebook.com (2620:10d:c0a8:82::c) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 30 Jul 2019 13:49:10 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 30 Jul 2019 13:49:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QUMLCscPMMHhn6OhN+N6Jn3TBnGLC+TM7lO7nS5dOebwBEwFFF0iqBQ2SpEQJeGSMhrQQ6w1OuS4khureXIMjUV4jnZ4Q/Di/TGtKg2DUDWjq5678UvITs/AKkUQxdr9GyhU/iyd3O01iAUIjLLl9bCAcDxPiFL3vuUxqdOiSBN7x0vhW6IzpkW0atyjstgnziBWVV08k3pBXrw3hpw/XpcG4elUFAcLrIKnGNJJOm4BYTzsHtgHtwMU8SEpzcimozsx/84SdlZY0Bod7YNTTKMX6Hz+QXqy5LbKKdBRvROXnUpGBGTz+TaT5/IuzvWyYwwY7DW5rp3ZhnzhYBSAWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3YzZMzSy/3wdeq3v+cbnRE7Q95plGtLGfxlb9Zom80=;
 b=P9bofGJq8h+r/Tigr4JCuATQUdUr0/xrBlwdgK4zNEErNvnm9p2kSvwP6bv/pV1eGvSnLw5jlx1s/nG3KXAzv4HZ97Jc80LKqnvd83tCgpXDbNsuyvvGdzGbND7reFUsM4EZr2S+5pXZzKI9tGY+ac0dVhqkI7wKl4xh3RqlSQiIRCIkMPnBqDM/nlcj96qbo+Gn1fKK+4rlOEvvnpje2bf1GfwYQX+djS9Mjrvxf+ozcjv5MT9lez12fGuMNA5bn++VQ9TbtEDdwfJ5QIHW4LwpzRyGKZfvVLzVBhcvSnBXIhQsAb8yMogCfG3V9TKqZgIlVx0XHrrP8F4d3WnTWw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=W3YzZMzSy/3wdeq3v+cbnRE7Q95plGtLGfxlb9Zom80=;
 b=HIeQJSwfKU/vtiUJa7StuOn+EFWTJPgTTsj/sgul734KThCwv08oZ2ydC0Xsaeg778YU1uUEpn7Z/Vi3L/+jrNq8/Z395rRl/CgEvLJkY5wMybLZTTfzGg2mIPLJefM1jrplpVejlY1zuxTkNDm3sFZcZpRIBJuninfHJ1DS6YI=
Received: from CY4PR15MB1463.namprd15.prod.outlook.com (10.172.159.10) by
 CY4PR15MB1688.namprd15.prod.outlook.com (10.175.121.17) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Tue, 30 Jul 2019 20:49:09 +0000
Received: from CY4PR15MB1463.namprd15.prod.outlook.com
 ([fe80::84cb:3f:7d6a:40a8]) by CY4PR15MB1463.namprd15.prod.outlook.com
 ([fe80::84cb:3f:7d6a:40a8%8]) with mapi id 15.20.2115.005; Tue, 30 Jul 2019
 20:49:09 +0000
From:   Jens Axboe <axboe@fb.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>,
        "willy@infradead.org" <willy@infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     Kernel Team <Kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to
 bio_vec
Thread-Topic: [PATCH v2 0/3 net-next] Finish conversion of skb_frag_t to
 bio_vec
Thread-Index: AQHVRuTI2uZuTGFjC0y0p/cGUGkqgKbjoqWA
Date:   Tue, 30 Jul 2019 20:49:09 +0000
Message-ID: <1d34658b-a807-44ae-756a-d55dead27f94@fb.com>
References: <20190730144034.444022-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190730144034.444022-1-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR05CA0082.namprd05.prod.outlook.com
 (2603:10b6:a03:e0::23) To CY4PR15MB1463.namprd15.prod.outlook.com
 (2603:10b6:903:fa::10)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2600:380:4b3e:9885:c95c:2c40:8ebb:9ac6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1448c65f-5407-422c-5df8-08d7152f5ed3
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1688;
x-ms-traffictypediagnostic: CY4PR15MB1688:
x-microsoft-antispam-prvs: <CY4PR15MB1688163BCD8901393B890BD1C0DC0@CY4PR15MB1688.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1332;
x-forefront-prvs: 0114FF88F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(346002)(136003)(396003)(39860400002)(376002)(189003)(199004)(256004)(71190400001)(54906003)(316002)(53936002)(31686004)(6512007)(305945005)(6116002)(7736002)(110136005)(81156014)(81166006)(2201001)(2906002)(8676002)(25786009)(36756003)(68736007)(6246003)(66446008)(6486002)(66556008)(6506007)(64756008)(102836004)(76176011)(386003)(86362001)(66946007)(478600001)(66476007)(52116002)(14454004)(8936002)(2501003)(4326008)(99286004)(476003)(53546011)(2616005)(31696002)(486006)(71200400001)(5660300002)(4744005)(446003)(229853002)(11346002)(6436002)(46003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1688;H:CY4PR15MB1463.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ReqtfJ2mEKQ3jVc/9puVFIX0KHhtHrAjtJyQWRlaGwABOtAuZjMO8VXgx7hBiqxZoveC70xcIjt3RSE6V49WPfogHR6S9xcpvV7W8e0eaCE058yJczqDX6AIfIUHy82E4PlgWvIsXc6tuc3EzPatQkI3DWR77oTw1ad5dLUEXMAhTHJ4Z9KdkSk+PYUixbiderk/K7Cj62mfj/RwnjGsRGRpw3mnPVfZyYOPut97K6cOLEwkz7uyKu1qxiZDcBJZXQh++gp2/ttj9/feSqjgN3r1FCkC7nYmF6XYVEDckG6ceeRWVBhDwGme8v7lPBOj12xKysaHHhr9aFgUk2EiCy/C2AYHXPrQKEJs/LzVpn87xlT5oKqisiy+drxOUxRboSN/z+HUIwZE/BWyiCG0IvN/wyu1tr59Pe+HSqqqpsQ=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D53B01F6413DD1448353792E06B6136A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1448c65f-5407-422c-5df8-08d7152f5ed3
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jul 2019 20:49:09.6600
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: axboe@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1688
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-30_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907300210
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8zMC8xOSA4OjQwIEFNLCBKb25hdGhhbiBMZW1vbiB3cm90ZToNCj4gVGhlIHJlY2VudCBj
b252ZXJzaW9uIG9mIHNrYl9mcmFnX3QgdG8gYmlvX3ZlYyBkaWQgbm90IGluY2x1ZGUNCj4gc2ti
X2ZyYWcncyBwYWdlX29mZnNldC4gIEFkZCBhY2Nlc3NvciBmdW5jdGlvbnMgZm9yIHRoaXMgZmll
bGQsDQo+IHV0aWxpemUgdGhlbSwgYW5kIHJlbW92ZSB0aGUgdW5pb24sIHJlc3RvcmluZyB0aGUg
b3JpZ2luYWwgc3RydWN0dXJlLg0KDQpZb3UgY2FuIGFkZDoNCg0KUmV2aWV3ZWQtYnk6IEplbnMg
QXhib2UgPGF4Ym9lQGtlcm5lbC5kaz4NCg0KUHJldHR5IGFwcGFsbGVkIHRvIHNlZSB0aGlzIGFi
b21pbmF0aW9uOg0KDQpuZXQ6IENvbnZlcnQgc2tiX2ZyYWdfdCB0byBiaW9fdmVjDQoNClRoZXJl
IGFyZSBhIGxvdCBvZiB1c2VycyBvZiBmcmFnLT5wYWdlX29mZnNldCwgc28gdXNlIGEgdW5pb24N
CnRvIGF2b2lkIGNvbnZlcnRpbmcgdGhvc2UgdXNlcnMgdG9kYXkuDQoNClNpZ25lZC1vZmYtYnk6
IE1hdHRoZXcgV2lsY294IChPcmFjbGUpIDx3aWxseUBpbmZyYWRlYWQub3JnPg0KU2lnbmVkLW9m
Zi1ieTogRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KDQpzaG93IHVwIGlu
IHRoZSBuZXQgdHJlZSB3aXRob3V0IGV2ZW4gaGF2aW5nIGJlZW4gcG9zdGVkIG9uIGENCmJsb2Nr
IGxpc3QuLi4NCg0KQXQgbGVhc3QgdGhpcyBraWxscyB0aGlzIHVnbHkgdGhpbmcuDQoNCi0tIA0K
SmVucyBBeGJvZQ0KDQo=
