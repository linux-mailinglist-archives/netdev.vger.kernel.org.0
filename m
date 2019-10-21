Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04087DE177
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 02:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfJUAfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 20:35:02 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1936 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726576AbfJUAfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 20:35:02 -0400
Received: from pps.filterd (m0044012.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9L0U98n013814;
        Sun, 20 Oct 2019 17:35:00 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=5KVIrpshlF7cliYpZVJFJ+C/DSWE+cdN5cko/Vojatw=;
 b=hpdjmWFxAby09iv0i9dGtmSVBvz7xM77w7Ss/7qLd5xjY6fsfkXVuMQZ/vQQ1866tvwq
 Tta2dJtXvbH1PWNppW5Tut8DAss7ItBFEExY/L1tX9rom0pX7TNp9hlRpi0Jo9s5c+ER
 baccUxe1gA9cCjGuuWdukSn55QSuvZ1gFu8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vrj5dt2th-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 20 Oct 2019 17:34:59 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 20 Oct 2019 17:34:56 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 20 Oct 2019 17:34:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aZX/6LlUqmBZf4AL6hHJmhHeVG7qbmGgd6V7De55dAh9aCzXtN1Mak7C7DtxwnbeIr/BTKzWTD5ulbruMdb3N/MprGGRZ4ncQkJLI9h2mEG+p7eS7UQ1K/v++81yAkfTNjntNYa4ZZXLPgpmPbdfX/34iB2Jz34WJU/ra+H6zYzV38h4KRT3vvMhHBsdHholNSgVRzrCaifjs5uj6y/svpfRYujpWdRaedfo2UmNjgT0IacSig15zkXu4B0hkdRcti3tB5RhzEWj+MSbJLGG0XlqysC64rqV3GgNv0z8TqKfpLrGn0RHNcAY0vzKsjd9m71kZ0J8HJlw4qgboiYjHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KVIrpshlF7cliYpZVJFJ+C/DSWE+cdN5cko/Vojatw=;
 b=JVi7t6H3oDUc8HSPycfOmxQssmNp0vMDv0T7yW8kSqafXTYPlBvkic1z1PERiEIXuhSlf45sS4AB/1Xlw1NyFuM/3nHJqGv6vO+6eB5WHpfHp337mv4kTZSvX8vGZGoBI8GR3ylJv8qGKQ539XDOw80VDtjpf4t+zJbx6s7hYC+kYrdK7zXa7vi5akNjIiW/HMOXfpW5F5lbKirW7ai/IjVTcjL5zC5V3SBxRXPqG5bwo0EYkv32+KypbdRoQAnJsEM5uw+owr2iMgv82ug6A2PSxLLPcceleGxM63K+SJEPmcArVI17ydXokfqpseSDtosSG+w5ES85/p1giwWkbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5KVIrpshlF7cliYpZVJFJ+C/DSWE+cdN5cko/Vojatw=;
 b=N6v8iXc4wGXx4K+4EwngQ/6QRt/f0TUTwu6T9Yav0Z095POHY34rHxLSYs/UdXgCrqmGDVLjGioLPBbXhkngP2nbMlBPBBIf0tywpekxNzN+/tQhxWZieOXYlpIDSy5sLwsag6g16efyGiwUGIvr/K1FZApgRvoVM1OUL+2hcTs=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3256.namprd15.prod.outlook.com (20.179.59.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.17; Mon, 21 Oct 2019 00:34:55 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 00:34:55 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kernel-team@cloudflare.com" <kernel-team@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>
Subject: Re: [PATCH bpf-next v2] scripts/bpf: Print an error when known types
 list needs updating
Thread-Topic: [PATCH bpf-next v2] scripts/bpf: Print an error when known types
 list needs updating
Thread-Index: AQHVhzjaAX/sugXa5UOs6F5f+UUBH6dkQEAA
Date:   Mon, 21 Oct 2019 00:34:55 +0000
Message-ID: <0b94f736-17f1-6358-f661-33b6fb348532@fb.com>
References: <20191020112344.19395-1-jakub@cloudflare.com>
In-Reply-To: <20191020112344.19395-1-jakub@cloudflare.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:301:60::24) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::ee3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 49e26029-4c02-472d-6b18-08d755be7e36
x-ms-traffictypediagnostic: BYAPR15MB3256:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3256E880F19062666248B3DFD3690@BYAPR15MB3256.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:597;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(136003)(396003)(366004)(346002)(39860400002)(189003)(199004)(36756003)(6486002)(478600001)(256004)(316002)(4326008)(31686004)(2501003)(31696002)(229853002)(5660300002)(8676002)(102836004)(14444005)(6512007)(81166006)(81156014)(6436002)(52116002)(2906002)(99286004)(6116002)(110136005)(66446008)(66556008)(66946007)(66476007)(71200400001)(76176011)(86362001)(8936002)(6246003)(54906003)(71190400001)(25786009)(14454004)(2616005)(46003)(11346002)(446003)(476003)(386003)(6506007)(53546011)(305945005)(486006)(186003)(7736002)(64756008);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3256;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EZ/7X6h5MO9zqY8rV9KTC3NbH57m1DeqKiqq6hgiMwN25OZifnhsdNBV8sUnvJ9n3oyWC7NJ++BuU7OcpRBc10cjNwTF4u7ALfJgltGxolFK2iukSK1i1zZ4sb7DK6IMy7i7yZDRX1eSJ93FRQpRGhsSyxl3QHdk8SiWRikD62cFCxVoC7Xf335a4ar1Ufx0eNoc4kY9i2dKh7LiBm3ZQYz/29Dndzb1L8ZaKiLI29nEiic3chEfj91/OBv9qJ/0yUFPFb9LkS/z6cLx0TMsj6bE3WyH5efgULg9m/Y42be21LhWav2DbYqW73OScsEHm4PNh0TJ2aDp7jSR0oIcUbas3QSpuBYQhXK0N4+2i5K0kObaR7GCnUaHZX6W6Rsvy3U5Mn0mmFR5ttbil3KACjKud6yYrpncHvg0ww0vGelwyVij5OZtRmBHyt/fzYrh
Content-Type: text/plain; charset="utf-8"
Content-ID: <586BD5093CE9E1488DC6C2082DBBD2F8@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 49e26029-4c02-472d-6b18-08d755be7e36
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 00:34:55.0884
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: l+jr4galZK6JJIAyY2HGIe5sXSvSg5JrCN3fwixvhe7Whi+3nqi+/E4kFoMWcFAi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3256
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-20_06:2019-10-18,2019-10-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0 mlxscore=0
 clxscore=1011 mlxlogscore=999 impostorscore=0 adultscore=0 malwarescore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 spamscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-1908290000
 definitions=main-1910210002
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIwLzE5IDQ6MjMgQU0sIEpha3ViIFNpdG5pY2tpIHdyb3RlOg0KPiBEb24ndCBn
ZW5lcmF0ZSBhIGJyb2tlbiBicGZfaGVscGVyX2RlZnMuaCBoZWFkZXIgaWYgdGhlIGhlbHBlciBz
Y3JpcHQgbmVlZHMNCj4gdXBkYXRpbmcgYmVjYXVzZSBpdCBkb2Vzbid0IHJlY29nbml6ZSBhIG5l
d2x5IGFkZGVkIHR5cGUuIEluc3RlYWQgcHJpbnQgYW4NCj4gZXJyb3IgdGhhdCBleHBsYWlucyB3
aHkgdGhlIGJ1aWxkIGlzIGZhaWxpbmcsIGNsZWFuIHVwIHRoZSBwYXJ0aWFsbHkNCj4gZ2VuZXJh
dGVkIGhlYWRlciBhbmQgc3RvcC4NCj4gDQo+IHYxLT52MjoNCj4gLSBTd2l0Y2hlZCBmcm9tIHRl
bXBvcmFyeSBmaWxlIHRvIC5ERUxFVEVfT05fRVJST1IuDQo+IA0KPiBGaXhlczogNDU2YTUxM2Ji
NWQ0ICgic2NyaXB0cy9icGY6IEVtaXQgYW4gI2Vycm9yIGRpcmVjdGl2ZSBrbm93biB0eXBlcyBs
aXN0IG5lZWRzIHVwZGF0aW5nIikNCj4gU3VnZ2VzdGVkLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFu
ZHJpaW5AZmIuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBKYWt1YiBTaXRuaWNraSA8amFrdWJAY2xv
dWRmbGFyZS5jb20+DQoNCkFja2VkLWJ5OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+
IC0tLQ0KPiAgIHNjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5IHwgNCArKy0tDQo+ICAgdG9vbHMv
bGliL2JwZi9NYWtlZmlsZSAgICAgfCAzICsrKw0KPiAgIDIgZmlsZXMgY2hhbmdlZCwgNSBpbnNl
cnRpb25zKCspLCAyIGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL3NjcmlwdHMvYnBm
X2hlbHBlcnNfZG9jLnB5IGIvc2NyaXB0cy9icGZfaGVscGVyc19kb2MucHkNCj4gaW5kZXggMDgz
MDBiYzAyNGRhLi43NTQ4NTY5ZTgwNzYgMTAwNzU1DQo+IC0tLSBhL3NjcmlwdHMvYnBmX2hlbHBl
cnNfZG9jLnB5DQo+ICsrKyBiL3NjcmlwdHMvYnBmX2hlbHBlcnNfZG9jLnB5DQo+IEBAIC00ODgs
OCArNDg4LDggQEAgY2xhc3MgUHJpbnRlckhlbHBlcnMoUHJpbnRlcik6DQo+ICAgICAgICAgICAg
ICAgcmV0dXJuIHQNCj4gICAgICAgICAgIGlmIHQgaW4gc2VsZi5tYXBwZWRfdHlwZXM6DQo+ICAg
ICAgICAgICAgICAgcmV0dXJuIHNlbGYubWFwcGVkX3R5cGVzW3RdDQo+IC0gICAgICAgIHByaW50
KCIiKQ0KPiAtICAgICAgICBwcmludCgiI2Vycm9yIFwiVW5yZWNvZ25pemVkIHR5cGUgJyVzJywg
cGxlYXNlIGFkZCBpdCB0byBrbm93biB0eXBlcyFcIiIgJSB0KQ0KPiArICAgICAgICBwcmludCgi
VW5yZWNvZ25pemVkIHR5cGUgJyVzJywgcGxlYXNlIGFkZCBpdCB0byBrbm93biB0eXBlcyEiICUg
dCwNCj4gKyAgICAgICAgICAgICAgZmlsZT1zeXMuc3RkZXJyKQ0KPiAgICAgICAgICAgc3lzLmV4
aXQoMSkNCj4gICANCj4gICAgICAgc2Vlbl9oZWxwZXJzID0gc2V0KCkNCj4gZGlmZiAtLWdpdCBh
L3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUgYi90b29scy9saWIvYnBmL01ha2VmaWxlDQo+IGluZGV4
IDc1YjUzODU3N2MxNy4uNTRmZjgwZmFhOGRmIDEwMDY0NA0KPiAtLS0gYS90b29scy9saWIvYnBm
L01ha2VmaWxlDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYvTWFrZWZpbGUNCj4gQEAgLTI4NiwzICsy
ODYsNiBAQCB0YWdzOg0KPiAgICMgRGVjbGFyZSB0aGUgY29udGVudHMgb2YgdGhlIC5QSE9OWSB2
YXJpYWJsZSBhcyBwaG9ueS4gIFdlIGtlZXAgdGhhdA0KPiAgICMgaW5mb3JtYXRpb24gaW4gYSB2
YXJpYWJsZSBzbyB3ZSBjYW4gdXNlIGl0IGluIGlmX2NoYW5nZWQgYW5kIGZyaWVuZHMuDQo+ICAg
LlBIT05ZOiAkKFBIT05ZKQ0KPiArDQo+ICsjIERlbGV0ZSBwYXJ0aWFsbHkgdXBkYXRlZCAoY29y
cnVwdGVkKSBmaWxlcyBvbiBlcnJvcg0KPiArLkRFTEVURV9PTl9FUlJPUjoNCj4gDQo=
