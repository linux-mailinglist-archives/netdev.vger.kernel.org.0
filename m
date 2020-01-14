Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A25A13B5B3
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 00:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728862AbgANXMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 18:12:45 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55874 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728650AbgANXMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 18:12:44 -0500
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00EN9mLr012568;
        Tue, 14 Jan 2020 15:12:24 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IFeIlD8K297p2lsJBuTumYrQd9tpGGHovVSgCtVWNe8=;
 b=ADZ/ZgXzk4kKrXbJSqIoP2HCRlnLveQqkfu8tYvG7IkUsHHWJ9B+mkKYk11ys101ffmv
 OCMmzh4t1Zt5zB99bmPx0QZRL9N3oBMkE6BvLd9D5cNiAyqB+A37FvGW3FcHgl8txXAb
 t32VkGKRTkl2lnZQXt6WdKdGNKzU4QrOecY= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 2xhd7r3911-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 14 Jan 2020 15:12:23 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.199) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Tue, 14 Jan 2020 15:12:23 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M5ONdQTKfpKKK+3eFTg8tqmZ/NFAayBfapwrQiuR3JIuJDEdtrpO6zaLP0Ynyzcpi/Q837cTyVfaixxe0OOPHmcz+o131xvFGy30yxP62qPmxQgIV2oe2R+iE6eYh4CrSYF7KkjWwTuf38ZO/d3/yLF3i4hCYeKE/BVTIJQtoO4EOPH2vIwVi5vkvTUTnXGvl/pN5oDHrl2UGvOKUohKXGV/X0H9fsoVcco8RamiEBiGc+KUWoNegnnyhU31d21+U+JVeScX/YRkJpYLVIjbuHd4+diz8qNIirZ/xfqEMvM4PY9ItwDu9ZLW/2Vklxa4EnxEGip8G9LBzZBlw9Iaew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFeIlD8K297p2lsJBuTumYrQd9tpGGHovVSgCtVWNe8=;
 b=jJwpAeAy/2n8bQ0WOUHZRwtxaySzYP53fObBtNRb00zag83qF60LaOyt9DOYBrgbIPbuyUBtAu0OGX2uEcqZnvgYeK/awJmICr7SMygfzcjdhXYJ0ggbNvbihqKEmEy0Z0Dzo55mW8HR009mLICkpc5oDWUB2U1a5js+RwPqs3GLkN3lTb3u8mRtgN4UYcvik/WSOW7Ntinj1gRnfk8WTGVXrTzqjMSF8kSwV3u/Ixc/ex7KGKiXX6YRfKce+DCrxz/8KTal3qSijkWvYB8G1mL4+MH607qW6ClmziaeCNRIFCDIxfABhQgWXxe9/W+t2S1ml9Dc85s3CalYZLPa0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFeIlD8K297p2lsJBuTumYrQd9tpGGHovVSgCtVWNe8=;
 b=B+S3MiinWWJ55V54Z3HUIzF7Fh6iGnakUzp8s5cTQN6prt2kZaLBFLkg7RaEbkWF5HOgJl7jY2HLbqcLecVg/OTJbNvEX5XoNIovWv0hAbaqJtJAz16P3tE7/3EPqprlP2C9ngiPwFHG0PRX2plFoiXFyF/Tiy52XaiCGxRlfLk=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1418.namprd15.prod.outlook.com (10.173.225.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.11; Tue, 14 Jan 2020 23:12:22 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::1cbf:c518:3a4d:291b%11]) with mapi id 15.20.2623.017; Tue, 14 Jan
 2020 23:12:22 +0000
Received: from macbook-pro-52.dhcp.thefacebook.com (2620:10d:c090:200::2:b667) by CO1PR15CA0046.namprd15.prod.outlook.com (2603:10b6:101:1f::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Tue, 14 Jan 2020 23:12:21 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Brian Vazquez <brianvv@google.com>,
        Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "Daniel Borkmann" <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
CC:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Petar Penkov <ppenkov@google.com>,
        Willem de Bruijn <willemb@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/9] add bpf batch ops to process more than 1
 elem
Thread-Topic: [PATCH v4 bpf-next 0/9] add bpf batch ops to process more than 1
 elem
Thread-Index: AQHVyvoxpnm7UFFFaUOgplDKH6wgXqfqyi6A
Date:   Tue, 14 Jan 2020 23:12:22 +0000
Message-ID: <d554cbd3-3225-6238-3b78-552f0e813ce9@fb.com>
References: <20200114164614.47029-1-brianvv@google.com>
In-Reply-To: <20200114164614.47029-1-brianvv@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO1PR15CA0046.namprd15.prod.outlook.com
 (2603:10b6:101:1f::14) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:b667]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: db8a3998-637c-4c46-d1cd-08d7994735d7
x-ms-traffictypediagnostic: DM5PR15MB1418:
x-microsoft-antispam-prvs: <DM5PR15MB1418FCF7D5582FA7398AA2E1D3340@DM5PR15MB1418.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 028256169F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(39860400002)(136003)(396003)(376002)(366004)(346002)(199004)(189003)(478600001)(53546011)(6506007)(4326008)(2906002)(16526019)(52116002)(81156014)(66556008)(66946007)(5660300002)(8676002)(6486002)(186003)(66446008)(966005)(6512007)(81166006)(64756008)(66476007)(71200400001)(110136005)(86362001)(54906003)(316002)(31686004)(8936002)(36756003)(31696002)(7416002)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1418;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dpf9uZ+8PIfvCBPSLLXUvf2mjnc00MQlwJsBCc3nhuQUNckcwtfTGfZFzr6/trWAbYaprTjJLuf2UE/Qo6KMBzrvnwrh8z3YBrzbZ335DhqkOU43H11qEEp4OLmjBasrzpAhti9KWBCWfPiO1jcZtYYU7H6bbkhQ4HWLURNh69U1kIS6qN3fKiZ3eaq/wkU4nMBzM/t6MGDPfhYraepwfgto16vqqMWHX7zg+5EHKVBqptC94AGw9kgQm1veOaVBueJbv9mYR9WBGYSrCBTXghfIMfc+eDNY405EuSOV/kwCq3NdGnm3bMvAr6uES1XWeCop4YMNeX4PLuXJa8l8ps9ZjjEF862MVuwTqZVOgtz5USs9//+5Rw8DopBpB18DNh7HEbi7aIE0rzQVxZiWtuLMesCuvgbpnYaVInxS3BWeYfBoEwXxadAAvgCTFLlWPhFv2npARlfa/sFNQRZHTGpE/104/YyMWuXtP6aYeIc=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <CC20277BECBFA3488308AE09732644A2@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: db8a3998-637c-4c46-d1cd-08d7994735d7
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jan 2020 23:12:22.3457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1YBx1Gzaioq42HEm5KtR5ZijTwDjHF1Ao10y0wIEKGExIsP69uf0Z4w94DZOORXQ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1418
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-14_06:2020-01-14,2020-01-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 suspectscore=0
 impostorscore=0 adultscore=0 malwarescore=0 mlxscore=0 phishscore=0
 spamscore=0 mlxlogscore=936 lowpriorityscore=0 clxscore=1015 bulkscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001140179
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMTQvMjAgODo0NiBBTSwgQnJpYW4gVmF6cXVleiB3cm90ZToNCj4gVGhpcyBwYXRj
aCBzZXJpZXMgaW50cm9kdWNlIGJhdGNoIG9wcyB0aGF0IGNhbiBiZSBhZGRlZCB0byBicGYgbWFw
cyB0bw0KPiBsb29rdXAvbG9va3VwX2FuZF9kZWxldGUvdXBkYXRlL2RlbGV0ZSBtb3JlIHRoYW4g
MSBlbGVtZW50IGF0IHRoZSB0aW1lLA0KPiB0aGlzIGlzIHNwZWNpYWxseSB1c2VmdWwgd2hlbiBz
eXNjYWxsIG92ZXJoZWFkIGlzIGEgcHJvYmxlbSBhbmQgaW4gY2FzZQ0KPiBvZiBobWFwIGl0IHdp
bGwgcHJvdmlkZSBhIHJlbGlhYmxlIHdheSBvZiB0cmF2ZXJzaW5nIHRoZW0uDQo+IA0KPiBUaGUg
aW1wbGVtZW50YXRpb24gaW5jbHVlcyBhIGdlbmVyaWMgYXBwcm9hY2ggdGhhdCBjb3VsZCBwb3Rl
bnRpYWxseSBiZQ0KPiB1c2VkIGJ5IGFueSBicGYgbWFwIGFuZCBhZGRzIGl0IHRvIGFycmF5bWFw
LCBpdCBhbHNvIGluY2x1ZGVzIHRoZSBzcGVjaWZpYw0KPiBpbXBsZW1lbnRhdGlvbiBvZiBoYXNo
bWFwcyB3aGljaCBhcmUgdHJhdmVyc2VkIHVzaW5nIGJ1Y2tldHMgaW5zdGVhZA0KPiBvZiBrZXlz
Lg0KPiANCj4gVGhlIGJwZiBzeXNjYWxsIHN1YmNvbW1hbmRzIGludHJvZHVjZWQgYXJlOg0KPiAN
Cj4gICAgQlBGX01BUF9MT09LVVBfQkFUQ0gNCj4gICAgQlBGX01BUF9MT09LVVBfQU5EX0RFTEVU
RV9CQVRDSA0KPiAgICBCUEZfTUFQX1VQREFURV9CQVRDSA0KPiAgICBCUEZfTUFQX0RFTEVURV9C
QVRDSA0KPiANCj4gVGhlIFVBUEkgYXR0cmlidXRlIGlzOg0KPiANCj4gICAgc3RydWN0IHsgLyog
c3RydWN0IHVzZWQgYnkgQlBGX01BUF8qX0JBVENIIGNvbW1hbmRzICovDQo+ICAgICAgICAgICBf
X2FsaWduZWRfdTY0ICAgaW5fYmF0Y2g7ICAgICAgIC8qIHN0YXJ0IGJhdGNoLA0KPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBOVUxMIHRvIHN0YXJ0IGZyb20g
YmVnaW5uaW5nDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAq
Lw0KPiAgICAgICAgICAgX19hbGlnbmVkX3U2NCAgIG91dF9iYXRjaDsgICAgICAvKiBvdXRwdXQ6
IG5leHQgc3RhcnQgYmF0Y2ggKi8NCj4gICAgICAgICAgIF9fYWxpZ25lZF91NjQgICBrZXlzOw0K
PiAgICAgICAgICAgX19hbGlnbmVkX3U2NCAgIHZhbHVlczsNCj4gICAgICAgICAgIF9fdTMyICAg
ICAgICAgICBjb3VudDsgICAgICAgICAgLyogaW5wdXQvb3V0cHV0Og0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKiBpbnB1dDogIyBvZiBrZXkvdmFsdWUNCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogZWxlbWVudHMNCj4g
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICogb3V0cHV0OiAjIG9m
IGZpbGxlZCBlbGVtZW50cw0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgKi8NCj4gICAgICAgICAgIF9fdTMyICAgICAgICAgICBtYXBfZmQ7DQo+ICAgICAgICAg
ICBfX3U2NCAgICAgICAgICAgZWxlbV9mbGFnczsNCj4gICAgICAgICAgIF9fdTY0ICAgICAgICAg
ICBmbGFnczsNCj4gICAgfSBiYXRjaDsNCj4gDQo+IA0KPiBpbl9iYXRjaCBhbmQgb3V0X2JhdGNo
IGFyZSBvbmx5IHVzZWQgZm9yIGxvb2t1cCBhbmQgbG9va3VwX2FuZF9kZWxldGUgc2luY2UNCj4g
dGhvc2UgYXJlIHRoZSBvbmx5IHR3byBvcGVyYXRpb25zIHRoYXQgYXR0ZW1wdCB0byB0cmF2ZXJz
ZSB0aGUgbWFwLg0KPiANCj4gdXBkYXRlL2RlbGV0ZSBiYXRjaCBvcHMgc2hvdWxkIHByb3ZpZGUg
dGhlIGtleXMvdmFsdWVzIHRoYXQgdXNlciB3YW50cw0KPiB0byBtb2RpZnkuDQo+IA0KPiBIZXJl
IGFyZSB0aGUgcHJldmlvdXMgZGlzY3Vzc2lvbnMgb24gdGhlIGJhdGNoIHByb2Nlc3Npbmc6DQo+
ICAgLSBodHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvMjAxOTA3MjQxNjU4MDMuODc0NzAtMS1i
cmlhbnZ2QGdvb2dsZS5jb20vDQo+ICAgLSBodHRwczovL2xvcmUua2VybmVsLm9yZy9icGYvMjAx
OTA4MjkwNjQ1MDIuMjc1MDMwMy0xLXloc0BmYi5jb20vDQo+ICAgLSBodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9icGYvMjAxOTA5MDYyMjU0MzQuMzYzNTQyMS0xLXloc0BmYi5jb20vDQo+IA0KPiBD
aGFuZ2Vsb2cgc2ludmUgdjM6DQo+ICAgLSBEbyBub3QgdXNlIGNvcHlfdG9fdXNlciBpbnNpZGUg
YXRvbWljIHJlZ2lvbiAoWW9uZ2hvbmcgU29uZykNCj4gICAtIFVzZSBfb3B0cyBhcHByb2FjaCBv
biBsaWJicGYgQVBJcyAoQW5kcmlpIE5ha3J5aWtvKQ0KPiAgIC0gRHJvcCBnZW5lcmljX21hcF9s
b29rdXBfYW5kX2RlbGV0ZV9iYXRjaCBzdXBwb3J0DQo+ICAgLSBGcmVlIG1hbGxvYy1lZCBtZW1v
cnkgaW4gdGVzdHMgKFlvbmdob25nIFNvbmcpDQo+ICAgLSBSZXZlcnNlIGNocmlzdG1hcyB0cmVl
IChZb25naG9uZyBTb25nKQ0KPiAgIC0gQWRkIGFja2VkIGxhYmVscw0KDQpUaGFua3MgZm9yIHRo
ZSBuZXcgcmV2aXNpb24hIE92ZXJhbGwgbG9va3MgZ29vZC4gT25seSBoYXZlIGEgZmV3IG1pbm9y
DQpjb21tZW50cy4gQWxzbyB0ZXN0ZWQgaW4gbXkgZW52aXJvbm1lbnQgYW5kIGV2ZXJ5dGhpbmcg
d29ya3MgYXMgZXhwZWN0ZWQuDQo=
