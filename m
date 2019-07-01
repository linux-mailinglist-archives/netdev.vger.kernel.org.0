Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6EEC5C24D
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 19:51:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730041AbfGARvW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 13:51:22 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30588 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727270AbfGARvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 13:51:22 -0400
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x61Hn15m016019;
        Mon, 1 Jul 2019 10:50:59 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8pYH+cts7tmfLcLJQ/BO2JDEecB3J2SfxCXteEWryLI=;
 b=clnWk60seB0thea5Y8bRm3+D3y32WibFJZzRi5BsvIMsDjfrMlbkm14gNQ9m2dPiInrE
 ZyFAdDEQWeEqxxsESZ4yEboltrMiecIeWzBmGOwlPP9wjHaOFYGMHsAj/1suJLn+QSSr
 G4YPzkALEw7fxEizApQziwwJCYpVG+RmelI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2tfjqkh193-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 01 Jul 2019 10:50:59 -0700
Received: from ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) by
 ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jul 2019 10:50:55 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exopmbx101.TheFacebook.com (2620:10d:c0a8:82::b) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 1 Jul 2019 10:50:55 -0700
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 1 Jul 2019 10:50:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8pYH+cts7tmfLcLJQ/BO2JDEecB3J2SfxCXteEWryLI=;
 b=AM269Y1tzNSus4EjlI6E6GQYr/SFO2B/m3jTFutw2Ob+s2ii3vM3CKWssfyr2zweUUeQ7R2Q8dKt0e/lEmseWZihaOJALvguJJ3z351IEartGcCeWRbxWVOJCDMotxMo/OoOuAGZFpf/MCCT+MLTSmfei8q+rnYn24/1uytHt18=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB3190.namprd15.prod.outlook.com (20.179.56.92) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.18; Mon, 1 Jul 2019 17:50:54 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::850b:bed:29d5:ae79%7]) with mapi id 15.20.2032.019; Mon, 1 Jul 2019
 17:50:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "Andrii Nakryiko" <andriin@fb.com>
Subject: Re: [PATCH bpf-next v3 3/3] selftests/bpf: add verifier tests for
 wide stores
Thread-Topic: [PATCH bpf-next v3 3/3] selftests/bpf: add verifier tests for
 wide stores
Thread-Index: AQHVMDPdAvF/IzTYrkmBVQBYiCC78qa2CqIA
Date:   Mon, 1 Jul 2019 17:50:54 +0000
Message-ID: <92b96eed-885f-6127-3f42-4810b4b30397@fb.com>
References: <20190701173841.32249-1-sdf@google.com>
 <20190701173841.32249-4-sdf@google.com>
In-Reply-To: <20190701173841.32249-4-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR06CA0062.namprd06.prod.outlook.com
 (2603:10b6:104:3::20) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:fe3a]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 1edd448d-d921-4458-48eb-08d6fe4ca9b6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3190;
x-ms-traffictypediagnostic: BYAPR15MB3190:
x-microsoft-antispam-prvs: <BYAPR15MB3190E57635853C31B1954FEAD3F90@BYAPR15MB3190.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:203;
x-forefront-prvs: 00851CA28B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(39860400002)(136003)(376002)(396003)(366004)(199004)(189003)(73956011)(99286004)(316002)(110136005)(6116002)(7736002)(305945005)(81156014)(8676002)(102836004)(66946007)(2501003)(81166006)(52116002)(54906003)(76176011)(476003)(14454004)(256004)(46003)(86362001)(8936002)(64756008)(66556008)(486006)(11346002)(31696002)(66476007)(2201001)(2616005)(5660300002)(6506007)(386003)(186003)(53546011)(446003)(478600001)(6246003)(71190400001)(71200400001)(31686004)(229853002)(25786009)(68736007)(4326008)(6512007)(2906002)(53936002)(6436002)(36756003)(66446008)(4744005)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3190;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Ev6I+YVJ5XWWxAsiCqsq2gDtLa6ifRhZ6EOF6H9Ju5Rt7z2ouJ/QeCG4Mv1A+Am8i3k2FQtR8Uuo3uNmx420bFJA97jbuk+djyP0hPR24k7VqkZJWInNHGn1rXksryqq3ToMQs5Bsr1qVByoIDoYTNlR5U2vPpYHq/X3rT5AP79foVsfBkUrPTkfx9SQfogLHpy5wUodnzobq03aWYCsBbPNg1vlr+pyA5ZasD5vCgIrA5cajNOhoHUI/uGFTcAjdYuJMWfZWaT+gS9CgXJiJdeHuQldeAieb/OqeOmOZsWrz2EmVDVsxAxpHEDgNsiTuGXfnJLDL4/hWjRedc+sOhAgdg6Sqoqf/5XKsr9SZCnjMkz9bGMCqb+qH7716mqFhrGJwFzGRhKPVR+cpP0m8zYt+ua5EcMUv2ZqDTzeqbI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <713A2537D8348841861D64E290F293F3@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 1edd448d-d921-4458-48eb-08d6fe4ca9b6
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2019 17:50:54.0377
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3190
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-01_10:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=739 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1907010210
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMS8xOSAxMDozOCBBTSwgU3RhbmlzbGF2IEZvbWljaGV2IHdyb3RlOg0KPiBNYWtl
IHN1cmUgdGhhdCB3aWRlIHN0b3JlcyBhcmUgYWxsb3dlZCBhdCBwcm9wZXIgKGFsaWduZWQpIGFk
ZHJlc3Nlcy4NCj4gTm90ZSB0aGF0IHVzZXJfaXA2IGlzIG5hdHVyYWxseSBhbGlnbmVkIG9uIDgt
Ynl0ZSBib3VuZGFyeSwgc28NCj4gY29ycmVjdCBhZGRyZXNzZXMgYXJlIHVzZXJfaXA2WzBdIGFu
ZCB1c2VyX2lwNlsyXS4gbXNnX3NyY19pcDYgaXMsDQo+IGhvd2V2ZXIsIGFsaWduZWQgb24gYSA0
LWJ5dGUgYm9uZGFyeSwgc28gb25seSBtc2dfc3JjX2lwNlsxXQ0KPiBjYW4gYmUgd2lkZS1zdG9y
ZWQuDQo+IA0KPiBDYzogQW5kcmlpIE5ha3J5aWtvIDxhbmRyaWluQGZiLmNvbT4NCj4gQ2M6IFlv
bmdob25nIFNvbmcgPHloc0BmYi5jb20+DQo+IEFja2VkLWJ5OiBBbmRyaWkgTmFrcnlpa28gPGFu
ZHJpaW5AZmIuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBTdGFuaXNsYXYgRm9taWNoZXYgPHNkZkBn
b29nbGUuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZiLmNvbT4NCg0K
