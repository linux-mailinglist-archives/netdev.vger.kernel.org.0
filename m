Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7430F1A9432
	for <lists+netdev@lfdr.de>; Wed, 15 Apr 2020 09:26:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393674AbgDOHZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Apr 2020 03:25:52 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50862 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2393666AbgDOHYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Apr 2020 03:24:11 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 03F7JcSM032030;
        Wed, 15 Apr 2020 00:23:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=J7TaB5vagR4jLlR65xt6qo1UL50Z0IdhpExPg7JYQBM=;
 b=KT6hcGvwqv2uihIRuB8SQZDGXXXyIDL7oFKiTduVXlMuLaMw2TlV1y+16K5IxWbkd5Rp
 UxCPfaQ2bu0YsqyCGXskDr0dBsU7ZWnHriuPObMkchBlptrEauocGyXamITaLOsD6bPg
 IAl1qHZr/ZRFWESUv5BjpCNTA0ZFxh03i00= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0089730.ppops.net with ESMTP id 30dn85k4cw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Wed, 15 Apr 2020 00:23:03 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Wed, 15 Apr 2020 00:23:03 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yx/oGt68jaNIqPnyipClaRx7ORNOhWxwdjtZUP3B2GWExjHxmweHr/6bGTz+QgUoKOvSllt/O96GyJKRu8VuOHSXrYMuePFI153kcH/axG11ETz9xjj1r2LamEeUxN6bSz3wIwS4VKaKApfBbtlMTvRNdExmDkc3Fv97SkiwmkOkjO6GJqC6lR/qbNK46/0s6ws+oHCKLj/pczMYxrmG3/Dl34s//B/RUJfMZMCQZ4RdtWt7Z33Qqh05/coVwdr1zgKAIqPeWFBLAl7pd2axS1GZgCGwZGs5geBwVMJJTLu1X+/Lr87vJ+e5XRrUayqzndcQi89bG+aMFbC162IPUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7TaB5vagR4jLlR65xt6qo1UL50Z0IdhpExPg7JYQBM=;
 b=F3Bubt/vePvf7+Eqdqaz7dL9FIkewiMs9Ng7B5DUtvo09N0BlllH+HheLZUQMb8Kyldh/nz9UfhfJ0EVPnKatc+yL9btUX8Jingk8tyJxxZ9IPy9l1wdMyHC/SLpM1DuCenJF14tJaf4VbdHfWUJaVWammbxIYhvO7NEB9Z0uabBWDPe9TI0gtMwGnd2QFPZa6Wao6py2Xi2YkRFTHGlj6HMRFpUk+SclMCI0QhXLR4//ZRNoj0lve9nQlJorbiyAWJHo17LEPyFzK+y7m06gfrUsZ6T2td1hydedMVBOj9UcmBOvV3cw+GyzXTNVRDVsUYRBT9yizwIutQejTVBLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J7TaB5vagR4jLlR65xt6qo1UL50Z0IdhpExPg7JYQBM=;
 b=GNfrtgy3nnawCoxq0JNlPYve8i6G3PC08TIsDGpy6B7tdmdl5hWEFMyM7/L6MU+evJVrpCogtNcpHkzPpzZrJwxu1eAQxd13GNyJ+51nd99tRb03SGmjG1udOFazWfstsQqeDnzQXejRHQrSp4ZNunO4CMoPpdxpLLqZhaFdqr4=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB3207.namprd15.prod.outlook.com (2603:10b6:a03:101::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.26; Wed, 15 Apr
 2020 07:23:02 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2900.028; Wed, 15 Apr 2020
 07:23:02 +0000
From:   Song Liu <songliubraving@fb.com>
To:     maowenan <maowenan@huawei.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH -next] bpf: remove set but not used variable 'dst_known'
Thread-Topic: [PATCH -next] bpf: remove set but not used variable 'dst_known'
Thread-Index: AQHWEYedD4qyQaRcJ0KQTxqzapbMNqh5LnoAgAA7NwCAAGCjgA==
Date:   Wed, 15 Apr 2020 07:23:02 +0000
Message-ID: <F68FB33A-1B98-45C1-8056-457EFA52F84F@fb.com>
References: <20200413113703.194287-1-maowenan@huawei.com>
 <C75FACD4-8549-4AD1-BDE6-1F5B47095E4C@fb.com>
 <2b2e0060-ef9b-5541-1108-e28464b47f0a@huawei.com>
In-Reply-To: <2b2e0060-ef9b-5541-1108-e28464b47f0a@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:9d3e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ce916dea-7c7a-4936-c4df-08d7e10dd53e
x-ms-traffictypediagnostic: BYAPR15MB3207:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3207CF7CCC4CFF3DC9AEB5F6B3DB0@BYAPR15MB3207.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:1079;
x-forefront-prvs: 0374433C81
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(39860400002)(396003)(376002)(346002)(366004)(136003)(6506007)(2616005)(8936002)(71200400001)(8676002)(81156014)(6486002)(53546011)(186003)(86362001)(478600001)(4744005)(64756008)(6512007)(6916009)(66556008)(66476007)(91956017)(54906003)(316002)(5660300002)(36756003)(4326008)(33656002)(66446008)(66946007)(76116006)(2906002);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YWByupRWF4kGojZXlQhX6ivhMK+M8f2WwjBKqXdH5bSbmxUVd3R3A6SPhRL72oxp69vEO8ZiPU8aZk/k3pVMLEbesYjmR4yoOJ3gZYBBJAJaLxeK/yTQAL9b9UB8spbKKXT26V4RmLFQFh82JUJX18uWbn2/WGGErIF5DFFJ09YNcOM6r2lE73qJBhYkhQXxkTZ1+s8UKSGsJYTDOO1ofczwtHdNJ3mjcmCEJmv0fCKGWqYCS/lBkR64apWQNt96hPLYvY+AMb39Ci5BBzLUUKI8w7P74ppoSvHlxytDCaZPrF/WtgAxGK9ALdZMln3nqnvBbBMC08BhAOgV+irWG9GR8rnbDa/LUTggRXjZNhBUZ5LQV78fPxD1gmdCXcb/FyFc1OTGISy4AASoz/++yJH4GqolEH3Pp6eVbcDjErTQW+ipSbPLopF0HzHvFEQO
x-ms-exchange-antispam-messagedata: pA9OQXPB5JQxenlF2JA/OQ5VX1yz+oIcEJEZi/5r3g8wIVlHyzCAd5Dv13LNHELzCCnjFH0AuyqqoruoGbNmD3q8I2xET8r0KrigrFQYr4DBqJB4uSpibkQWvR4kMc2TfOBiHj9UdJMurTMe9TT0zKf2rAqhadivxvzpEnVX4VdE5eOI7T88WWUEAV5KHT+W
Content-Type: text/plain; charset="utf-8"
Content-ID: <2A092136805AC6468CE9721CECDD0999@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ce916dea-7c7a-4936-c4df-08d7e10dd53e
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Apr 2020 07:23:02.2750
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nN2MF/Te28mxpmTmIaGYIV/CB5DcR1ciwfGQ6gqtJ7czYFz4I+5cQa6BU+bk18oc9IxmtcRfkqm4H7IblX5Rtw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3207
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-15_01:2020-04-14,2020-04-15 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 mlxscore=0 malwarescore=0
 suspectscore=0 spamscore=0 impostorscore=0 adultscore=0 clxscore=1011
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004150056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXByIDE0LCAyMDIwLCBhdCA2OjM3IFBNLCBtYW93ZW5hbiA8bWFvd2VuYW5AaHVh
d2VpLmNvbT4gd3JvdGU6DQo+IA0KPiBPbiAyMDIwLzQvMTUgNjowNSwgU29uZyBMaXUgd3JvdGU6
DQo+PiANCj4+IA0KPj4+IE9uIEFwciAxMywgMjAyMCwgYXQgNDozNyBBTSwgTWFvIFdlbmFuIDxt
YW93ZW5hbkBodWF3ZWkuY29tPiB3cm90ZToNCj4+PiANCj4+PiBGaXhlcyBnY2MgJy1XdW51c2Vk
LWJ1dC1zZXQtdmFyaWFibGUnIHdhcm5pbmc6DQo+Pj4gDQo+Pj4ga2VybmVsL2JwZi92ZXJpZmll
ci5jOjU2MDM6MTg6IHdhcm5pbmc6IHZhcmlhYmxlIOKAmGRzdF9rbm93buKAmQ0KPj4+IHNldCBi
dXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+Pj4gDQo+Pj4gSXQgaXMg
bm90IHVzZWQgc2luY2UgY29tbWl0IGYxMTc0Zjc3YjUwYyAoImJwZi92ZXJpZmllcjoNCj4+PiBy
ZXdvcmsgdmFsdWUgdHJhY2tpbmciKQ0KPj4gDQo+PiBUaGUgZml4IG1ha2VzIHNlbnNlLiBCdXQg
SSB0aGluayBmMTE3NGY3N2I1MGMgaW50cm9kdWNlZCBkc3Rfa25vd24sIA0KPj4gc28gdGhpcyBz
dGF0ZW1lbnQgaXMgbm90IGFjY3VyYXRlLiANCj4+IA0KPiB0aGFua3MgZm9yIHJldmlldywgeWVz
LCBmMTE3NGY3N2I1MGMgaW50cm9kdWNlZCBkc3Rfa25vd24sIGFuZCBiZWxvdyBjb21taXQNCj4g
ZG9lc24ndCBkZWZlcmVuY2UgdmFyaWFibGUgZHN0X2tub3duLiBTbyBJIHNlbmQgdjIgbGF0ZXI/
DQo+IDNmNTBmMTMyZDg0MCAoImJwZjogVmVyaWZpZXIsIGRvIGV4cGxpY2l0IEFMVTMyIGJvdW5k
cyB0cmFja2luZyIpDQoNCkkgZG9uJ3QgdGhpbmsgd2UgbmVlZCB0byBiYWNrIHBvcnQgdGhpcyB0
byBzdGFibGUuIFNvIGl0IGlzIE9LIG5vdCB0byANCmluY2x1ZGUgRml4ZXMgdGFnLiBXZSBjYW4g
anVzdCByZW1vdmUgdGhpcyBzdGF0ZW1lbnQgaW4gdGhlIGNvbW1pdCBsb2cuDQoNCmJwZi1uZXh0
IGlzIG5vdCBvcGVuIHlldC4gUGxlYXNlIHNlbmQgdjIgd2hlbiBicGYtbmV4dCBpcyBvcGVuLiAN
Cg0KVGhhbmtzLA0KU29uZw0KDQo=
