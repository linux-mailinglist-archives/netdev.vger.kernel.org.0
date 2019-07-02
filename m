Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E85C5D5D6
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 20:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbfGBSCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 14:02:35 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58476 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726329AbfGBSCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 14:02:35 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x62HxhB0003514;
        Tue, 2 Jul 2019 11:02:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=+Vg2Yh2J1ZGinZT8yQE7E/mukByk0uWukoIEU4ycctA=;
 b=W5rLnZOPZL70xXJpSwdNnkb9TcVWrsLf6cyOJXFBBkgJyEJ1FOCivAXlm481Fz4Jcgj4
 r5qF0PTA1B6v5IaJ+nTq4PDoqPmr+Z0hqM5NZL5HRHHYiVXsQOn+iytDLQOOSYI1HsIP
 DW4eMk++w7ddXansqMHJw+bwfSw1FFpNIo4= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2tgafggf0v-11
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Tue, 02 Jul 2019 11:02:11 -0700
Received: from prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 2 Jul 2019 11:02:02 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-mbx03.TheFacebook.com (2620:10d:c081:6::17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 2 Jul 2019 11:02:02 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Tue, 2 Jul 2019 11:02:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=testarcselector01; d=microsoft.com; cv=none;
 b=mi2GnipSfBctOfL+ycTRjKDto8J7bIFalq8A797qf5wK1P71YVrUm4UystUtirApfWVvY3xF6cB+M8LxfwHd+ius5pBCGq2erb7AAdQJN0+40l3LyKZggE5KFQf+fQxb0OjA5tUX4IjKhs8CJF5bsJv30eDx9agYdc8/hoL969k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=testarcselector01;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Vg2Yh2J1ZGinZT8yQE7E/mukByk0uWukoIEU4ycctA=;
 b=B2acCyWbyAz4bswhoEDL0qJ+ZIJusxRkYIUWi/kTve3+F6niUs8/uuxOK0pobblAI7NcXKL5Ua0TNvR8Ne4DQBahrTXZ9QuUNapBTREKdd7i4ptAGohHAakyfnaHFIStPxRr6NHsDCdQvVx/30NqbWR5R+I24U8g7AxqLLCf5Qo=
ARC-Authentication-Results: i=1; test.office365.com
 1;spf=none;dmarc=none;dkim=none;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Vg2Yh2J1ZGinZT8yQE7E/mukByk0uWukoIEU4ycctA=;
 b=uISEslFl4zbpGX+V7f4A6D53+H28JgJus6hucnau5KnGROPRyEJATC6MGaQW2iff3Pqrrr3mjBFZVW9R8+qgacNO1T8CsYQQBtkmNjkDPaoKDDdKU26oNlTFvRtckubW3DJ8Geuf5+nbk7HjmGiCEPN0EJNeDGJtmZ+wYTcW4QI=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2374.namprd15.prod.outlook.com (52.135.198.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 2 Jul 2019 18:02:00 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Tue, 2 Jul 2019
 18:02:00 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Markus Elfring <Markus.Elfring@web.de>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>
CC:     LKML <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH] bpf: Replace a seq_printf() call by seq_puts() in
 btf_enum_seq_show()
Thread-Topic: [PATCH] bpf: Replace a seq_printf() call by seq_puts() in
 btf_enum_seq_show()
Thread-Index: AQHVMPl8laQbH2CXxE6eDmS1GxA+Oaa3noUA
Date:   Tue, 2 Jul 2019 18:02:00 +0000
Message-ID: <6e3b1745-f5f7-7b0b-4bde-309c081bcd03@fb.com>
References: <93898abe-9a7d-0c64-0856-094b62e07ba2@web.de>
In-Reply-To: <93898abe-9a7d-0c64-0856-094b62e07ba2@web.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0126.namprd04.prod.outlook.com
 (2603:10b6:104:7::28) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:8eae]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cb3337b5-110d-4efd-2eca-08d6ff176153
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2374;
x-ms-traffictypediagnostic: BYAPR15MB2374:
x-microsoft-antispam-prvs: <BYAPR15MB237454BCF63DC546ACAB9A14D3F80@BYAPR15MB2374.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1775;
x-forefront-prvs: 008663486A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(396003)(39860400002)(376002)(346002)(189003)(199004)(81156014)(8676002)(53936002)(73956011)(66446008)(81166006)(54906003)(64756008)(66556008)(52116002)(68736007)(110136005)(7736002)(14454004)(8936002)(71200400001)(71190400001)(66476007)(6636002)(66946007)(256004)(6512007)(36756003)(6486002)(386003)(6436002)(31686004)(76176011)(102836004)(478600001)(53546011)(316002)(99286004)(2906002)(6506007)(476003)(6116002)(446003)(305945005)(486006)(186003)(86362001)(31696002)(5660300002)(4744005)(11346002)(2616005)(25786009)(46003)(6246003)(2201001)(2501003)(4326008)(229853002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2374;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DKKWf82aQrBidhxQ98lP9UPznBSwefFxfDhEu9I2ojARFN5kRuuZ2vFiZhdpuBhRaO2rqbDQd04cenuEKVDgfvXYs4BfmvC4FIBRQCTzrbzOORTHhc2ssWtXGapLhKJ2fnX6stY8qhCghFWvbjUv0sSKMeFWDKbQHLBg9/wMji7Gr/HQ/BN0Bmq7pcK+TlUnN/LfW8fCwba4qivJttGfW8TgOc2kliV2iNaIlyQoe/hP6IztOTdC5GZ9oa1SrbFNAM3klBjDOXBlDDt8B/lf+Yq72UbAWhEP8XosR/iv0Ms3UwqSaM8MfTvCr65Le91cucXJ26lbNZH0ZmOyQndtbwntT2psrhX8VLOU5miwCYSAllriAdMoNj2inXMlez7rMWd7d5P1iOkAGPpVDLMJ0FNr9LE1lcbzEdBXQLlJzEo=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DF4580F4FD5C2348B038F98E84B50EA9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cb3337b5-110d-4efd-2eca-08d6ff176153
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jul 2019 18:02:00.5084
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2374
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-02_09:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=947 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907020198
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMi8xOSAxMDoxMyBBTSwgTWFya3VzIEVsZnJpbmcgd3JvdGU6DQo+IEZyb206IE1h
cmt1cyBFbGZyaW5nIDxlbGZyaW5nQHVzZXJzLnNvdXJjZWZvcmdlLm5ldD4NCj4gRGF0ZTogVHVl
LCAyIEp1bCAyMDE5IDE5OjA0OjA4ICswMjAwDQo+IA0KPiBBIHN0cmluZyB3aGljaCBkaWQgbm90
IGNvbnRhaW4gYSBkYXRhIGZvcm1hdCBzcGVjaWZpY2F0aW9uIHNob3VsZCBiZSBwdXQNCj4gaW50
byBhIHNlcXVlbmNlLiBUaHVzIHVzZSB0aGUgY29ycmVzcG9uZGluZyBmdW5jdGlvbiDigJxzZXFf
cHV0c+KAnS4NCj4gDQo+IFRoaXMgaXNzdWUgd2FzIGRldGVjdGVkIGJ5IHVzaW5nIHRoZSBDb2Nj
aW5lbGxlIHNvZnR3YXJlLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogTWFya3VzIEVsZnJpbmcgPGVs
ZnJpbmdAdXNlcnMuc291cmNlZm9yZ2UubmV0Pg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8
eWhzQGZiLmNvbT4NCg0KPiAtLS0NCj4gICBrZXJuZWwvYnBmL2J0Zi5jIHwgNSArKy0tLQ0KPiAg
IDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEva2VybmVsL2JwZi9idGYuYyBiL2tlcm5lbC9icGYvYnRmLmMNCj4gaW5kZXgg
NTQ2ZWJlZTM5ZTJhLi42NzlhMTk5NjhmMjkgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvYnRm
LmMNCj4gKysrIGIva2VybmVsL2JwZi9idGYuYw0KPiBAQCAtMjQyNiw5ICsyNDI2LDggQEAgc3Rh
dGljIHZvaWQgYnRmX2VudW1fc2VxX3Nob3coY29uc3Qgc3RydWN0IGJ0ZiAqYnRmLCBjb25zdCBz
dHJ1Y3QgYnRmX3R5cGUgKnQsDQo+IA0KPiAgIAlmb3IgKGkgPSAwOyBpIDwgbnJfZW51bXM7IGkr
Kykgew0KPiAgIAkJaWYgKHYgPT0gZW51bXNbaV0udmFsKSB7DQo+IC0JCQlzZXFfcHJpbnRmKG0s
ICIlcyIsDQo+IC0JCQkJICAgX19idGZfbmFtZV9ieV9vZmZzZXQoYnRmLA0KPiAtCQkJCQkJCWVu
dW1zW2ldLm5hbWVfb2ZmKSk7DQo+ICsJCQlzZXFfcHV0cyhtLA0KPiArCQkJCSBfX2J0Zl9uYW1l
X2J5X29mZnNldChidGYsIGVudW1zW2ldLm5hbWVfb2ZmKSk7DQo+ICAgCQkJcmV0dXJuOw0KPiAg
IAkJfQ0KPiAgIAl9DQo+IC0tDQo+IDIuMjIuMA0KPiANCg==
