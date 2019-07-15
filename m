Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E67669BC9
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 21:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731494AbfGOT5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 15:57:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:64236 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729525AbfGOT5f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 15:57:35 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6FJroVi008097;
        Mon, 15 Jul 2019 12:57:07 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jK1e0mlyJa4cPRS3oOMC/AM2oQWoS4UuxXcIV+PIIvk=;
 b=Z/sCZarN/Bb2Y/iAYcW+4mjjVelvxMKAJl54jtDuScNKHTynop+eoqeCyGuSl4AQtcbr
 mQJ5tJBMf9ZkzvaQe8zzJ9VYFpcZqSqmseRfYoPhu/M0vYEGmzGnL7/hOX9xoc0IammG
 WG1edZpZZQl6W/G+sGtVlXnYiNUfEcSbuAI= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2trt2jsfp7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 15 Jul 2019 12:57:07 -0700
Received: from prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 15 Jul 2019 12:57:06 -0700
Received: from prn-hub06.TheFacebook.com (2620:10d:c081:35::130) by
 prn-mbx06.TheFacebook.com (2620:10d:c081:6::20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 15 Jul 2019 12:57:06 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.30) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 15 Jul 2019 12:57:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hgOcDo8vOsMlTGPv+F0HW0YjbWHZRxIt9oMRi+NRjUaZ7y171TQvKwPLk7OB8Rmp7lyfGsKUMSb9SHC9zfRXbl4UCI2YIrSTzeWvtGB177Z7s0ibGl2hPYSEpUeywwSrHUfRCokdFpbdmJm5SHjpv2GAkEPhm9HeRKArdCmwFc8z4mNu8ocP2outYeMtne/bLe6qSEV1r18k5Gq0XxPkU/5J+Dw+6K2OUTneiWTm0Eq9CnHZVQFp9hp4iDKHa7bd+Eq1B9S6Lj3ZLf7iA1bX8G953T8nUFi9oZwOrdtE+KtyWPCeXrxfqXjdUah4+SnYWP68vRJApgDsUbr6bw0yDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK1e0mlyJa4cPRS3oOMC/AM2oQWoS4UuxXcIV+PIIvk=;
 b=hp2qwGT+5j4kV7N274dlBQxQt+/Xpl2sOcb6m13s9rGh+1E8aM6+lygOFwZ550reyIQk4yMDBCk2lBszGHS5QjGXV4BjG760zNAZQC1GTe32eGE0QwH8KxMSh18VVum69w9cjcKy+G7O2wj3Ir3zyk/a4TU3/Sn7qmWbyW3xq43VOwquVb7TNLMjauzf02rM9X4fpoVxTNDtCYlTJc0lhmKh6mtEaAYGFbcJIDWFElY1JTOrXG12jkNsFbmwcf42MMFjv9f9hIsC8LAuJ5zhOqHUmLBgrkEggW9BWdaMR52o9KGVmsX8uumcaeMfinhwkEmxq9/hRVQo/yNjgncYrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jK1e0mlyJa4cPRS3oOMC/AM2oQWoS4UuxXcIV+PIIvk=;
 b=AOY9PXW5WvX3PiCGdYQ1ZJ43s4i8H8/tu/g1lEKiTZx7rQw8IA+n9po+weSTwg117wwGPiw7ii+kZKdIXzRnQfBMOMJ0h8H32bYtKWDsBLnBlYWwiYZCtlr0Ldgv+qpEvquj0Sy1gnxsn0h77Zmc+gNb/BRP4R5zOQL+oovJMbY=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3288.namprd15.prod.outlook.com (20.179.57.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2073.14; Mon, 15 Jul 2019 19:57:04 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2073.012; Mon, 15 Jul 2019
 19:57:04 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH bpf 0/5] bpf: allow wide (u64) aligned loads for some
 fields of bpf_sock_addr
Thread-Topic: [PATCH bpf 0/5] bpf: allow wide (u64) aligned loads for some
 fields of bpf_sock_addr
Thread-Index: AQHVOyv3HdliqjN0s0W/5qKpE1wG3qbMGJaA
Date:   Mon, 15 Jul 2019 19:57:04 +0000
Message-ID: <8a8995ec-f211-0e01-cd3c-972a8d237c5f@fb.com>
References: <20190715163956.204061-1-sdf@google.com>
In-Reply-To: <20190715163956.204061-1-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR1701CA0010.namprd17.prod.outlook.com
 (2603:10b6:301:14::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:4fac]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9015b3eb-629c-4f68-c2c0-08d7095e9bc1
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3288;
x-ms-traffictypediagnostic: BYAPR15MB3288:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <BYAPR15MB328810B43B325F62BC9A12EDD3CF0@BYAPR15MB3288.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 00997889E7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(366004)(376002)(136003)(39860400002)(396003)(199004)(189003)(6116002)(11346002)(2616005)(476003)(486006)(2201001)(229853002)(2906002)(256004)(14444005)(6306002)(8676002)(76176011)(6512007)(316002)(6506007)(53546011)(81166006)(68736007)(386003)(6246003)(478600001)(52116002)(31686004)(8936002)(4326008)(81156014)(99286004)(102836004)(966005)(46003)(53936002)(446003)(25786009)(6436002)(66446008)(110136005)(54906003)(6486002)(36756003)(64756008)(66946007)(66476007)(66556008)(31696002)(14454004)(305945005)(71200400001)(2501003)(7736002)(71190400001)(5660300002)(86362001)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3288;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: zJR2VHcAoqNGbMA4Pdt7vXRki9itD6MmrFAMEIIVLKE4sfhmTqmWUxy/6+QMc9PKlgWempKFCTzLRzRKRurwXfBu59ZahTXeSakw6oTaSRzeffZsfC6QsArYhhDyFa+8c9x7anWZ57fPKzY+zbpiJW2hkOy5R3rqOHMawiY/ciUOHSqrlzKWBR74WpFj++JRivI3utLVFmKPWiDyl+AVIg1/sUMIVbgL1/x+CahB0p6Z87GfPd9X+7CGD1N2hwZK2i2Y13Of8m2toaQ4KKIF772SIjnFlOHCZ2YorYozj10jcwX88JVSvWDxaQxi5s1tfN4c7yOIZ5lA3fK0X3V4ICf0rdCNQQ2ciHL9g6RLFvQCfjBU97TTewpczZLVz3QVx9MQRS+xw7z8Bn5nN5nO2Yxgst1uM7F4s+RYLBb0oYw=
Content-Type: text/plain; charset="utf-8"
Content-ID: <381881E2624E834CB88B25B42288EEB1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 9015b3eb-629c-4f68-c2c0-08d7095e9bc1
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2019 19:57:04.3625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3288
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-15_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907150227
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMTUvMTkgOTozOSBBTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBXaGVu
IGZpeGluZyBzZWxmdGVzdHMgYnkgYWRkaW5nIHN1cHBvcnQgZm9yIHdpZGUgc3RvcmVzLCBZb25n
aG9uZw0KPiByZXBvcnRlZCB0aGF0IGhlIGhhZCBzZWVuIHNvbWUgZXhhbXBsZXMgd2hlcmUgY2xh
bmcgZ2VuZXJhdGVzDQo+IHNpbmdsZSB1NjQgbG9hZHMgZm9yIHR3byBhZGphY2VudCB1MzJzIGFz
IHdlbGw6DQo+IGh0dHA6Ly9sb3JlLmtlcm5lbC5vcmcvbmV0ZGV2L2E2NmM5MzdmLTk0YzAtZWFm
OC01YjM3LTg1ODdkNjZjMGM2MkBmYi5jb20NCj4gDQo+IExldCdzIHN1cHBvcnQgYWxpZ25lZCB1
NjQgcmVhZHMgZm9yIHNvbWUgYnBmX3NvY2tfYWRkciBmaWVsZHMNCj4gYXMgd2VsbC4NCj4gDQo+
IChUaGlzIGNhbiBwcm9iYWJseSB3YWl0IGZvciBicGYtbmV4dCwgSSdsbCBkZWZlciB0byBZb3Vu
aG9uZyBhbmQgdGhlDQo+IG1haW50YWluZXJzLikNCj4gDQo+IENjOiBZb25naG9uZyBTb25nIDx5
aHNAZmIuY29tPg0KPiANCj4gU3RhbmlzbGF2IEZvbWljaGV2ICg1KToNCj4gICAgYnBmOiByZW5h
bWUgYnBmX2N0eF93aWRlX3N0b3JlX29rIHRvIGJwZl9jdHhfd2lkZV9hY2Nlc3Nfb2sNCj4gICAg
YnBmOiBhbGxvdyB3aWRlIGFsaWduZWQgbG9hZHMgZm9yIGJwZl9zb2NrX2FkZHIgdXNlcl9pcDYg
YW5kDQo+ICAgICAgbXNnX3NyY19pcDYNCj4gICAgc2VsZnRlc3RzL2JwZjogcmVuYW1lIHZlcmlm
aWVyL3dpZGVfc3RvcmUuYyB0byB2ZXJpZmllci93aWRlX2FjY2Vzcy5jDQo+ICAgIHNlbGZ0ZXN0
cy9icGY6IGFkZCBzZWxmdGVzdHMgZm9yIHdpZGUgbG9hZHMNCj4gICAgYnBmOiBzeW5jIGJwZi5o
IHRvIHRvb2xzLw0KDQpUaGFua3MgZm9yIGZpeGluZy4gTWF5YmUgZ2V0dGluZyBpbnRvIGJwZiBp
cyBiZXR0ZXIgYXMgdGhpcyBpbmRlZWQNCmEgcG90ZW50aWFsIGlzc3VlPyBJIGRvIG5vdCBoYXZl
IHN0cm9uZyBmZWVsaW5nIGVpdGhlciBhcyB0aGUNCmlzc3VlIGNhbiBiZSBlYXNpbHkgd29ya2Fy
b3VuZGVkIHdpdGggInZvbGF0aWxlIiB0cmlja3MuDQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25n
IDx5aHNAZmIuY29tPg0KDQo+IA0KPiAgIGluY2x1ZGUvbGludXgvZmlsdGVyLmggICAgICAgICAg
ICAgICAgICAgICAgICB8ICAyICstDQo+ICAgaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oICAgICAg
ICAgICAgICAgICAgICAgIHwgIDQgKy0NCj4gICBuZXQvY29yZS9maWx0ZXIuYyAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgfCAyNCArKysrLS0NCj4gICB0b29scy9pbmNsdWRlL3VhcGkvbGlu
dXgvYnBmLmggICAgICAgICAgICAgICAgfCAgNCArLQ0KPiAgIC4uLi9zZWxmdGVzdHMvYnBmL3Zl
cmlmaWVyL3dpZGVfYWNjZXNzLmMgICAgICB8IDczICsrKysrKysrKysrKysrKysrKysNCj4gICAu
Li4vc2VsZnRlc3RzL2JwZi92ZXJpZmllci93aWRlX3N0b3JlLmMgICAgICAgfCAzNiAtLS0tLS0t
LS0NCj4gICA2IGZpbGVzIGNoYW5nZWQsIDk1IGluc2VydGlvbnMoKyksIDQ4IGRlbGV0aW9ucygt
KQ0KPiAgIGNyZWF0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdmVy
aWZpZXIvd2lkZV9hY2Nlc3MuYw0KPiAgIGRlbGV0ZSBtb2RlIDEwMDY0NCB0b29scy90ZXN0aW5n
L3NlbGZ0ZXN0cy9icGYvdmVyaWZpZXIvd2lkZV9zdG9yZS5jDQo+IA0K
