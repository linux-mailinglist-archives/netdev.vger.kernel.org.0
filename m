Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5C762698
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:49:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388793AbfGHQtA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:49:00 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22610 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728973AbfGHQtA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:49:00 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x68GeKpx022343;
        Mon, 8 Jul 2019 09:47:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=h4iDdfTVrBzetMLHmewXBhzEqZfUAZwVari2rbuzxhw=;
 b=HyjIhXlTxAO7I3ttOyCJIrRgeZafc3PR+Va9MtqidP1yIstTwDA25eCS80j8EXWt8OBo
 mdmgbyBdSMx4kDNQmmKAj8o93FdDKykARhImwV7ie5oGpUeNCvK8/GL0sfJ7meSuV4tX
 EBQ8llI6OzW6XgTfU8trZ9ZVZH1xEKqQFw4= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tm94dg52p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 08 Jul 2019 09:47:54 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 8 Jul 2019 09:47:53 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 8 Jul 2019 09:47:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=h4iDdfTVrBzetMLHmewXBhzEqZfUAZwVari2rbuzxhw=;
 b=Eugw6QyAiP1kmBj2dZLLMGD8pKTNNjyr56nh2kd/de3BU1ycVipXfH2I+I/8zIrEyOS5sFPOl1qfY7V+695bTQ8ow4e7CvjE2l9GKk4+mjqd80I2wT8l1zHGC2Gub5E8LKTtOnqBUcXUc4qxuk+clXH2GFNYTaHIKrnzLQKHkGk=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2552.namprd15.prod.outlook.com (20.179.155.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2052.18; Mon, 8 Jul 2019 16:47:52 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2052.020; Mon, 8 Jul 2019
 16:47:52 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Daniel Borkmann" <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jesper Dangaard Brouer" <brouer@redhat.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Subject: Re: [PATCH bpf-next v3 4/6] tools/include/uapi: Add devmap_hash BPF
 map type
Thread-Topic: [PATCH bpf-next v3 4/6] tools/include/uapi: Add devmap_hash BPF
 map type
Thread-Index: AQHVNXu9PpsNN2vickmSwIbCKgsKe6bA7saA
Date:   Mon, 8 Jul 2019 16:47:52 +0000
Message-ID: <5b69de10-489d-9061-232c-45d7c75cf785@fb.com>
References: <156258334704.1664.15289699152225647059.stgit@alrua-x1>
 <156258334740.1664.18295003114988159871.stgit@alrua-x1>
In-Reply-To: <156258334740.1664.18295003114988159871.stgit@alrua-x1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BN6PR18CA0005.namprd18.prod.outlook.com
 (2603:10b6:404:121::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:7bd2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6605b25-5dac-4dc4-7082-08d703c40466
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2552;
x-ms-traffictypediagnostic: BYAPR15MB2552:
x-microsoft-antispam-prvs: <BYAPR15MB255228FB085A94548B5E4B94D3F60@BYAPR15MB2552.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1923;
x-forefront-prvs: 00922518D8
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(366004)(376002)(39860400002)(136003)(346002)(199004)(189003)(68736007)(66574012)(66476007)(66556008)(64756008)(6512007)(66446008)(486006)(316002)(86362001)(31696002)(71200400001)(71190400001)(5660300002)(4744005)(66946007)(73956011)(256004)(14444005)(2616005)(110136005)(54906003)(81156014)(476003)(6116002)(6506007)(14454004)(81166006)(6436002)(25786009)(99286004)(8936002)(305945005)(11346002)(7736002)(446003)(478600001)(31686004)(8676002)(6486002)(386003)(46003)(52116002)(229853002)(4326008)(76176011)(53936002)(53546011)(102836004)(6246003)(36756003)(2906002)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2552;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: N/1XjLPwa3JXfIrmR9hTzfWYGAwNQ9IDv/YtTm8fylihsn5aB5H+APssZiMR5WATWTrd5zoClVlIy1CLI6R2a+taAKoAUK9fSEzRuvOBMWXgaSAnOoAXyJj/n9TS845yoZ/HMW6nOwsR5zl34jM+fDXgIphBTRbrEUfPsMdHbPl1cTcGOhPk0mlUbvqDhXyxBfPo70zLTCz43mOlVjizkYYgsnBS4DrdVR1obGE33lDStIIRhL7n1bmk1ya99ukDqqz/SwQoLl5CjI6VzGltDWaECC6PTgtQB5Ig9hhlZRVCyHQRlX1SOY7BPeiJfs5M4JjojKFCC/4aF/RpKnJFKukM88wBF6SHCDmH4v+NANja6N3vdLvCCx9t+k86cKFmkzbZ3zX1uoyPK7Lgtvr0JKqEAnFZ5c9+mjppIvnacbs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CC542F83B2ED34E98D4086351F92583@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d6605b25-5dac-4dc4-7082-08d703c40466
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2019 16:47:52.0479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2552
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-08_05:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907080206
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvOC8xOSAzOjU1IEFNLCBUb2tlIEjDuGlsYW5kLUrDuHJnZW5zZW4gd3JvdGU6DQo+
IEZyb206IFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiANCj4g
VGhpcyBhZGRzIHRoZSBkZXZtYXBfaGFzaCBCUEYgbWFwIHR5cGUgdG8gdGhlIHVhcGkgaGVhZGVy
cyBpbiB0b29scy8uDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBUb2tlIEjDuGlsYW5kLUrDuHJnZW5z
ZW4gPHRva2VAcmVkaGF0LmNvbT4NCg0KQWNrZWQtYnk6IFlvbmdob25nIFNvbmcgPHloc0BmYi5j
b20+DQoNCj4gLS0tDQo+ICAgdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIHwgICAgMSAr
DQo+ICAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspDQo+IA0KPiBkaWZmIC0tZ2l0IGEv
dG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4L2JwZi5oIGIvdG9vbHMvaW5jbHVkZS91YXBpL2xpbnV4
L2JwZi5oDQo+IGluZGV4IGNlY2Y0MmM4NzFkNC4uOGFmYWEwYTE5YzY3IDEwMDY0NA0KPiAtLS0g
YS90b29scy9pbmNsdWRlL3VhcGkvbGludXgvYnBmLmgNCj4gKysrIGIvdG9vbHMvaW5jbHVkZS91
YXBpL2xpbnV4L2JwZi5oDQo+IEBAIC0xMzQsNiArMTM0LDcgQEAgZW51bSBicGZfbWFwX3R5cGUg
ew0KPiAgIAlCUEZfTUFQX1RZUEVfUVVFVUUsDQo+ICAgCUJQRl9NQVBfVFlQRV9TVEFDSywNCj4g
ICAJQlBGX01BUF9UWVBFX1NLX1NUT1JBR0UsDQo+ICsJQlBGX01BUF9UWVBFX0RFVk1BUF9IQVNI
LA0KPiAgIH07DQo+ICAgDQo+ICAgLyogTm90ZSB0aGF0IHRyYWNpbmcgcmVsYXRlZCBwcm9ncmFt
cyBzdWNoIGFzDQo+IA0K
