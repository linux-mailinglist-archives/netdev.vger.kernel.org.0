Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50038143474
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 00:32:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgATXb7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 18:31:59 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:26698 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbgATXb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 18:31:59 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00KNSmm7020011;
        Mon, 20 Jan 2020 15:31:44 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=b/qG4iq3EPrGMhrEH2/1eK1XtTqybgOCqRB1w04yr0Y=;
 b=d9z9avYJDV7Y4h8G/C73Je31q67Cki2MN5pFjjyYb18AsBhWwTMB5JwKOitEbEMNb59z
 sBIXoRYrGHQ0c6FoEolGqG3jn9veNft01BbehLhtuicB2TyQTSfxxeX+OZDUjzjI6T1u
 iEs+G5/kOobvPjKOW6Scrl5+4ESqShKrwiA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xmjm0eb1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 20 Jan 2020 15:31:44 -0800
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Mon, 20 Jan 2020 15:31:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N9f9399ucKdxsmOxlO4Z7Zn5/JA3WI6pafbwV/8ccyyk5tdJPpiljmn7vxRE5CqlTUzRTm7ks6Hh52Ev9jtJ1PkvOw7soDv8NoxFIySSBDx6o+Bsg+aVnld5+BPCyCzXGyVSDJgVjgFvtlf3U1yqsbiZYoqBxXjUbI6wbYBWcAjYI7uNFlBbunuVJWn3DZ1NfgUTQxTCZo7aLnKurnQ4RxttaMbrqgAoSrPgw6tVkXhBNSWEM/ab6a/eXBS+L4dJHMyc0ffuve7bIkxvmPyQ1lsMI1VKorntA132XVJikmu73uU4zgsgpAbeKyZgbIFKRqlyxYptmEl6qDtbrmRnTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/qG4iq3EPrGMhrEH2/1eK1XtTqybgOCqRB1w04yr0Y=;
 b=djSxco7wFqgFU/xNcORa9o6KlSadX6u0ba8cDMU9F2pYNMXRTNuiFLVSrV4jKysL7FbwPVEl1zxiFeNPVIGnY+wSJR/uZhYUAjfu1siRB9U0ov1CExweaotWCKR81Rg8P4NXU8sQZCPUtZE1ql8wHHKnVs7d9a+NchSo6DJixfxyErk/RLjEPpdmjExvsgxsNMMmF8EEzPS2pJ3XXFyehSd+wsyBowmB3PDQ+RH8+7Lvu6r7PRF2100TZUntX4fJxSTkYw2WgScnfdf58ZjCrvRJv/WA8p/VUhMuStHlxMPbHga36QqQ2Q5oh1W9/ohsGckNScVX/TsDh7nzkWedog==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b/qG4iq3EPrGMhrEH2/1eK1XtTqybgOCqRB1w04yr0Y=;
 b=k41cVAOSnvBLnlaAU8mXLZLv1pkonmOfBr3dFuLWPECWxxst8XK+ZR4CHQ0+8tWxXLj45k0rsZ1QZcTpZyhC52VGzzqEy2qbtW7FkMJqiuH+71+5SBeteH0LOkTDGQHZP7hORXrwUtk0T6EsPko3+KVzJW8Ycm1D78v0itBy2xc=
Received: from MN2PR15MB3630.namprd15.prod.outlook.com (52.132.174.216) by
 MN2PR15MB3246.namprd15.prod.outlook.com (20.178.255.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.24; Mon, 20 Jan 2020 23:31:29 +0000
Received: from MN2PR15MB3630.namprd15.prod.outlook.com
 ([fe80::f043:c81c:e3ee:fa21]) by MN2PR15MB3630.namprd15.prod.outlook.com
 ([fe80::f043:c81c:e3ee:fa21%5]) with mapi id 15.20.2644.027; Mon, 20 Jan 2020
 23:31:29 +0000
Received: from [IPv6:2620:10d:c081:1131::1401] (2620:10d:c090:180::a4eb) by MWHPR19CA0049.namprd19.prod.outlook.com (2603:10b6:300:94::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Mon, 20 Jan 2020 23:31:27 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
CC:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/3] bpf: Introduce dynamic program extensions
Thread-Topic: [PATCH bpf-next 1/3] bpf: Introduce dynamic program extensions
Thread-Index: AQHVzZM7qqsFm8x3k06/ihDJ+N275qf0LWqAgAAK5AA=
Date:   Mon, 20 Jan 2020 23:31:28 +0000
Message-ID: <9b204165-1d32-0e0d-ce19-10acaa45f9ed@fb.com>
References: <20200118000657.2135859-1-ast@kernel.org>
 <20200118000657.2135859-2-ast@kernel.org>
 <CAEf4BzZyOqgkFvuzJw7Rd007mL6_VCYHXb=uaFa2UgzQQOm1Dg@mail.gmail.com>
In-Reply-To: <CAEf4BzZyOqgkFvuzJw7Rd007mL6_VCYHXb=uaFa2UgzQQOm1Dg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR19CA0049.namprd19.prod.outlook.com
 (2603:10b6:300:94::11) To MN2PR15MB3630.namprd15.prod.outlook.com
 (2603:10b6:208:180::24)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::a4eb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d6b48458-3dcc-4419-e7e3-08d79e00dfc2
x-ms-traffictypediagnostic: MN2PR15MB3246:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR15MB32463F144AA223206A3AE307D7320@MN2PR15MB3246.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0288CD37D9
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(346002)(376002)(136003)(396003)(366004)(189003)(199004)(6486002)(86362001)(316002)(53546011)(64756008)(478600001)(66476007)(31696002)(66946007)(66556008)(52116002)(66446008)(186003)(71200400001)(5660300002)(2906002)(16526019)(110136005)(36756003)(4326008)(54906003)(2616005)(81156014)(8676002)(8936002)(81166006)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:MN2PR15MB3246;H:MN2PR15MB3630.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7TlY+mdLi3IlGw6RIh+ql6j3+f8eHQGmcEzO1ZqJIwqSY+gl546NxMroPHMKlR7ssoaZ6vdzNLMEDrAdFhYfKL90719zg8hrh1oS9UUxOr49RISEMR9D93yjLgQphcSwha7hnZq+/PKnjLWZ5eqHlYCQzTPRWOU2th4vTOKxlN3bUzz+HTJvn9NqCw3gRWjaxxVfgq0hWxayAALsJ29cTMOuBQ76OM2F0dloWzrfYPnFDp/c2JFe5psGTAb30WII/aYP+nO06He1buRxh+StOblgEcQSp6iEnlLSOZJrf3EfDBNwqd5PDfPEq3q1Yba+gQ546U4QDNLMlvvZo17xoHNXWUjyHiLtYlNNMGTuSoPKA276VUprbMmLUC6+b4+slagPNLflRir2HmzwH+aQSG2o8wEXClC2Io8lKg92Xd8TJhx2CX5Wh2vlBnQHyDjG
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F4EABF8A886F848A06578B426CE4AEF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d6b48458-3dcc-4419-e7e3-08d79e00dfc2
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2020 23:31:28.9684
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sYwJfB5XJKJvgFtvHi9iWOH2iBaUa80GoCT3xL6pe8fuJ7io1OcMH1JbFN3fXLS9
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR15MB3246
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-20_10:2020-01-20,2020-01-20 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 lowpriorityscore=0
 suspectscore=0 adultscore=0 impostorscore=0 mlxscore=0 priorityscore=1501
 bulkscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 clxscore=1015
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001200198
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMS8yMC8yMCAyOjUyIFBNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+PiArICAgICAgIH0N
Cj4+ICsgICAgICAgaWYgKHRyLT5leHRlbnNpb25fcHJvZykgew0KPj4gKyAgICAgICAgICAgICAg
IC8qIGNhbm5vdCBhdHRhY2ggZmVudHJ5L2ZleGl0IGlmIGV4dGVuc2lvbiBwcm9nIGlzIGF0dGFj
aGVkICovDQo+PiArICAgICAgICAgICAgICAgZXJyID0gLUVCVVNZOw0KPj4gKyAgICAgICAgICAg
ICAgIGdvdG8gb3V0Ow0KPj4gKyAgICAgICB9DQo+IG1vdmUgdGhpcyBjaGVjayBiZWZvcmUgQlBG
X1RSQU1QX1JFUExBQ0UgY2hlY2sgYW5kIGNoZWNrIGFkZGl0b25hbGx5DQo+IGZvciBmZW50cnkr
ZmV4aXQgZm9yIEJQRl9UUkFNUF9SRVBMQUNFPyBOb3RoaW5nIGNhbiByZXBsYWNlDQo+IGV4dGVu
c2lvbl9wcm9nLCByaWdodD8NCg0KbWFrZXMgc2Vuc2UuIGZpeGVkLg0KDQo+PiArICAgICAgICAg
ICAgICAgaWYgKHRndF9wcm9nLT50eXBlID09IEJQRl9QUk9HX1RZUEVfVFJBQ0lORyAmJg0KPj4g
KyAgICAgICAgICAgICAgICAgICB0Z3RfcHJvZy0+ZXhwZWN0ZWRfYXR0YWNoX3R5cGUgIT0gQlBG
X1RSQUNFX1JBV19UUCAmJg0KPiBpZiB0aGUgaW50ZW50IGlzIHRvIHByZXZlbnQgZXh0ZW5kaW5n
IEZFTlRSWS9GRVhJVCwgd2h5IG5vdCBjaGVja2luZw0KPiBleHBsaWNpdGx5IGZvciB0aG9zZSB0
d28gaW5zdGVhZCBvZiBtYWtpbmcgYXNzdW1wdGlvbiB0aGF0DQo+IGV4cGVjdGVkX2F0dGFjaF90
eXBlIGNhbiBiZSBvbmx5IG9uZSBvZiBSQVdfVFAvRkVOVFJZL0ZFWElULCB0aGlzIGNhbg0KPiBl
YXNpbHkgY2hhbmdlIGluIHRoZSBmdXR1cmUuIEJlc2lkZXMsIGRpcmVjdCBGRU5UUlkvRkVYSVQg
Y29tcGFyaXNvbg0KPiBpcyBtb3JlIHNlbGYtZG9jdW1lbnRpbmcgYXMgd2VsbC4NCg0Kc3VyZS4g
Zml4ZWQgYXMgd2VsbC4NCg0KPj4gICAgICAgICAgICAgICAgICB9DQo+PiArICAgICAgICAgICAg
ICAgaWYgKHByb2dfZXh0ZW5zaW9uICYmDQo+PiArICAgICAgICAgICAgICAgICAgIGJ0Zl9jaGVj
a190eXBlX21hdGNoKGVudiwgcHJvZywgYnRmLCB0KSkNCj4gdGhpcyByZWFkcyBzbyB3ZWlyZC4u
LiBidGZfY2hlY2tfdHlwZV9tYXRjaCAoYW5kDQo+IGJ0Zl9jaGVja19mdW5jX3R5cGVfbWF0Y2gg
YXMgd2VsbCkgYXJlIGJvb2xlYW4gZnVuY3Rpb25zIChpLmUuLCBlaXRoZXINCj4gbWF0Y2hlcyBv
ciBub3QsIG9yIHNvbWUgZXJyb3IpLCB3aHkgbm90IHVzaW5nIGEgY29udmVudGlvbmFsDQo+IGJv
b2xlYW4rZXJyb3IgcmV0dXJuIGNvbnZlbnRpb246IDAgLSBmYWxzZSwgMSAtIHRydWUsIDwwIC0g
ZXJyb3INCj4gKGJ1Zyk/DQoNCkkgY2Fubm90IGFncmVlIGhlcmUuIFN1Y2ggcmV0dXJuIGNvbnZl
bnRpb24gd2lsbCBiZSB2ZXJ5IG9kZC4NClRoZSBvbmUgSSBwaWNrZWQgaXMgY29uc2lzdGVudCB3
aXRoIG90aGVyIHBsYWNlcy4NCg==
