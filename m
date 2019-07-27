Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C267877C11
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 23:29:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726317AbfG0V3q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 17:29:46 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:38094 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725280AbfG0V3p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 17:29:45 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RLTPYE003405;
        Sat, 27 Jul 2019 14:29:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jhnPY8pdl4ybkNmpePitc4nS4oHQVpAQLEdjwzNk7MI=;
 b=iIdGo9o2Lv2O+TjibbioT3JE4H0XLlsyMcE2pAogwJmORnJx1LI4oDP+RMn3EvCoNVfS
 hQHfLOFWMBsMtV15/s8Ru93dNYK/NZuDktFfbgd1ncvBw3zbggE9QJwQtvHtpIndbWMy
 1M+sh2KFKJsKIZXI7/FJFg6cbCFhFX7Og9o= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0me8sdeg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 27 Jul 2019 14:29:25 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 14:29:24 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 14:29:23 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 14:29:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+z1Onft4H7aJvNq5h3e07rkBDxZFl1Ay9h2L+X/tEZaveP7aAf70IT182gHLZ7Ns1+N/D0u3aj0u7OSc41di1v3zkt52HwFc078ESH0UEU+eWguX9UiHKSAtlxl1G7ja3CpIGx8DQLYOSb/oJZoZvxaerhTObGwEpit3iAy0vlsKGWaX8z0/ihLOwO6xJ/2bIWDQurevH182C0KnqQv2CX3+AE+JNvMUoNdrTotTbNiDiACJ8MWjJH+b3PHF5cNYEJAmdqSUsAJ3+nPsC2/OQL0cmtbxFgwBXAnEZqIXHBeD0lnboNwrWwQ1s/BOlPvRbg9CHJr5FG9wLomqjGRRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhnPY8pdl4ybkNmpePitc4nS4oHQVpAQLEdjwzNk7MI=;
 b=VGNeLB72kSBBMQe0gEjQxeq8g5uEpohOWo34AQEuy1NTR+iPB2/Fprjj93AOHytHTScIdMoAPRF58eMO+F1Mtp3AH4FP7DgldRH4WwDNGGzKZoaPeB9tMEsJdfYgrGtcDvSP+N36Xg84ZnxbaeRHgTpTnTJH/2mo2nuSCbe2hJtVcZcbkCfG4LhMaNyIdRQC4biT1b3aFXcHlJ3UPvU/5iqiKDcSQRclUDRLXGCPx9XP9XfFwy1Znx1/QRaE5Vl7lw+FjpQxX4ib+OJmjzhJGhfxxfeD9M5DQnFK0r5EB5/Wm4vExdvoYGnWJY5MssTX7UfnG2vSBnsd7iOP8iywvA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jhnPY8pdl4ybkNmpePitc4nS4oHQVpAQLEdjwzNk7MI=;
 b=LHvuk768VWq38mOtT4zpvWM+YSmGL7tcL+2FbP4D38sl50nln1eLfGX8vOp3ulOCabZG8/WK/X/x+2lbM4BO8mZ6QV8taPPai1kiDf5YADzrwmje2isFWVlGPzokCWbfBGzTTPOerMhgPjbvUOoCItWyK1n0N7NV/BGjxlEZrcE=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.59.17) by
 BYAPR15MB2982.namprd15.prod.outlook.com (20.178.237.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Sat, 27 Jul 2019 21:29:22 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::e499:ecba:ec04:abac%5]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 21:29:22 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@fb.com>
CC:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Topic: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Index: AQHVQlYa0t1TSjCdfUKSp0AtzbuVHabb+eAAgAIJpwCAALFegIAAF4oAgAAzlYA=
Date:   Sat, 27 Jul 2019 21:29:22 +0000
Message-ID: <363f7363-7031-3160-9f5f-583a1662fe25@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-3-andriin@fb.com>
 <20190725231831.7v7mswluomcymy2l@ast-mbp>
 <CAEf4BzZxPgAh4PGSWyD0tPOd1wh=DGZuSe1fzxc-Sgyk4D5vDg@mail.gmail.com>
 <957fff81-d845-ebc9-0e80-dbb1f1736b40@fb.com>
 <CAEf4Bzbt4+mT8GfQG4xMj4tCnWd2ZqJiY3r8cwOankFFQo8wWA@mail.gmail.com>
In-Reply-To: <CAEf4Bzbt4+mT8GfQG4xMj4tCnWd2ZqJiY3r8cwOankFFQo8wWA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR04CA0088.namprd04.prod.outlook.com
 (2603:10b6:104:6::14) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:10e::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:bc10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6dffdebd-f377-467e-eaa3-08d712d97dac
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2982;
x-ms-traffictypediagnostic: BYAPR15MB2982:
x-microsoft-antispam-prvs: <BYAPR15MB298270F24CC228F00902976DD3C30@BYAPR15MB2982.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:580;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(396003)(39860400002)(346002)(189003)(199004)(31686004)(66446008)(64756008)(66476007)(66556008)(8936002)(66946007)(86362001)(6436002)(6636002)(7736002)(305945005)(229853002)(6486002)(71200400001)(71190400001)(31696002)(14454004)(6246003)(53936002)(446003)(2616005)(476003)(68736007)(6506007)(46003)(36756003)(4326008)(25786009)(53546011)(11346002)(186003)(2906002)(102836004)(54906003)(110136005)(5660300002)(76176011)(81166006)(81156014)(478600001)(256004)(52116002)(8676002)(6116002)(486006)(316002)(6512007)(386003)(99286004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2982;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: F92qjnoIHp4WUZ9wAn1QV+OkL6ljap6G/bIBnSpzcJEOO0HT42//uD7PXm21a561AnDSp734qpTXmcjN3jATUHhNVDw4JYmjYeRIEXUd2FRwY1pHnj4LDlivrwzAV+L9FVU+pB+teNIlGbG7mLLcTp8vW7gyTeC/Bc26yVGSwbQ9UHtc2X9ZM1ZZ8g0de+peSIRIqbmHlqMWuFxChikfbWIa1F+qypodno1CZmivUpc/tgoUUHgMdhU7yrepub/YkuBQFAehDS1AF3x7Pym8z8K3GVIt5DBv4gOsgasvBCoGR4NCI4zQ+hZ0Ut4RANku9yEQ7Tk1sA3Z0yNEivS1G/5gQ9hB9h9QgA6tKZG9dZ+mESjYerSkFeGGwVTAKfxKRUuHjT/TRG9dfjYxklu2JzAaQQjyfPL4VugmO+p17B4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DCB72BFAEA1A004D99A55A1EF65EF37E@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 6dffdebd-f377-467e-eaa3-08d712d97dac
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 21:29:22.5130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yhs@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2982
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_16:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270268
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDcvMjcvMTkgMTE6MjQgQU0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gT24gU2F0
LCBKdWwgMjcsIDIwMTkgYXQgMTA6MDAgQU0gQWxleGVpIFN0YXJvdm9pdG92IDxhc3RAZmIuY29t
PiB3cm90ZToNCj4+DQo+PiBPbiA3LzI2LzE5IDExOjI1IFBNLCBBbmRyaWkgTmFrcnlpa28gd3Jv
dGU6DQo+Pj4+PiArICAgICB9IGVsc2UgaWYgKGNsYXNzID09IEJQRl9TVCAmJiBCUEZfTU9ERShp
bnNuLT5jb2RlKSA9PSBCUEZfTUVNKSB7DQo+Pj4+PiArICAgICAgICAgICAgIGlmIChpbnNuLT5p
bW0gIT0gb3JpZ19vZmYpDQo+Pj4+PiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5W
QUw7DQo+Pj4+PiArICAgICAgICAgICAgIGluc24tPmltbSA9IG5ld19vZmY7DQo+Pj4+PiArICAg
ICAgICAgICAgIHByX2RlYnVnKCJwcm9nICclcyc6IHBhdGNoZWQgaW5zbiAjJWQgKFNUIHwgTUVN
KSBpbW0gJWQgLT4gJWRcbiIsDQo+Pj4+PiArICAgICAgICAgICAgICAgICAgICAgIGJwZl9wcm9n
cmFtX190aXRsZShwcm9nLCBmYWxzZSksDQo+Pj4+PiArICAgICAgICAgICAgICAgICAgICAgIGlu
c25faWR4LCBvcmlnX29mZiwgbmV3X29mZik7DQo+Pj4+IEknbSBwcmV0dHkgc3VyZSBsbHZtIHdh
cyBub3QgY2FwYWJsZSBvZiBlbWl0dGluZyBCUEZfU1QgaW5zbi4NCj4+Pj4gV2hlbiBkaWQgdGhh
dCBjaGFuZ2U/DQo+Pj4gSSBqdXN0IGxvb2tlZCBhdCBwb3NzaWJsZSBpbnN0cnVjdGlvbnMgdGhh
dCBjb3VsZCBoYXZlIDMyLWJpdA0KPj4+IGltbWVkaWF0ZSB2YWx1ZS4gVGhpcyBpcyBgKihyWCkg
PSBvZmZzZXRvZihzdHJ1Y3QgcywgZmllbGQpYCwgd2hpY2ggSQ0KPj4+IHRob3VnaCBpcyBjb25j
ZWl2YWJsZS4gRG8geW91IHRoaW5rIEkgc2hvdWxkIGRyb3AgaXQ/DQo+Pg0KPj4gSnVzdCB0cnlp
bmcgdG8gcG9pbnQgb3V0IHRoYXQgc2luY2UgaXQncyBub3QgZW1pdHRlZCBieSBsbHZtDQo+PiB0
aGlzIGNvZGUgaXMgbGlrZWx5IHVudGVzdGVkID8NCj4+IE9yIHlvdSd2ZSBjcmVhdGVkIGEgYnBm
IGFzbSB0ZXN0IGZvciB0aGlzPw0KPiANCj4gDQo+IFllYWgsIGl0J3MgdW50ZXN0ZWQgcmlnaHQg
bm93LiBMZXQgbWUgdHJ5IHRvIGNvbWUgdXAgd2l0aCBMTFZNDQo+IGFzc2VtYmx5ICsgcmVsb2Nh
dGlvbiAobm90IHlldCBzdXJlIGhvdy93aGV0aGVyIGJ1aWx0aW4gd29ya3Mgd2l0aA0KPiBpbmxp
bmUgYXNzZW1ibHkpLCBpZiB0aGF0IHdvcmtzIG91dCwgSSdsbCBsZWF2ZSB0aGlzLCBpZiBub3Qs
IEknbGwNCj4gZHJvcCBCUEZfU1R8QlBGX01FTSBwYXJ0Lg0KDQpGWUkuIFRoZSBsbHZtIGRvZXMg
bm90IGhhdmUgYXNzZW1ibHkgY29kZSBmb3JtYXQgZm9yIEJQRl9TVCBpbnN0cnVjdGlvbnMgDQph
cyBpdCBkb2VzIG5vdCBnZW5lcmF0ZSBjb2RlIGZvciBpdC4gU28gaW5saW5lIGFzbSB0aHJvdWdo
IGxsdm0gd29uJ3QgDQp3b3JrLiBsbHZtIGRpc2Fzc2VlbWJsZXIgd29uJ3QgYmUgYWJsZSB0byBk
ZWNvZGUgQlBGX1NUIGVpdGhlci4NCg0KPj4NCj4+DQo=
