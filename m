Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7062F1AEA1F
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 08:15:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgDRGO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 02:14:58 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:43838 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725782AbgDRGO5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 02:14:57 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 03I6Aoal032152;
        Fri, 17 Apr 2020 23:13:51 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=eYFKhHPLIT+V0ZDlOhBAu0MGsW4LtCTJ7bSDSh9abR0=;
 b=DMmDjZFM0dvk1hy1Llv1XkNefwMmvWBuLxT7Ck9PBnDJvb4owNmCA47r8wnW5mECgJf5
 u/9TwZklrQ2SAz9uZM2Swrwpo6jSZqBlRrXmIF3jY4VYrzw8EiYhSor6AIc49Slk/7ZB
 euqhyBtZ4rd7uAnKPdzoPENvPHKHz37nf4w= 
Received: from mail.thefacebook.com ([163.114.132.120])
        by mx0a-00082601.pphosted.com with ESMTP id 30fsjqgh4y-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 17 Apr 2020 23:13:51 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (100.104.98.9) by
 o365-in.thefacebook.com (100.104.94.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Fri, 17 Apr 2020 23:13:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cYZLlcJS7wXWG3iT1J+h5rIlLiLisSupkHp9fh0AaAuZo4RJBF029Sdz7vFu93I8uyYHDNQ4759vxMa/SvYIiSjmfsEFmZiZF9XVO1HV9ehjMzqXisbi5x7v37nyNWc2ay5m3kGAk3g6QMyoB2QYTCNzIFj6W1REuEO9WrPnb8nRznN/6ncL//2Jy6wWtk7DktY20xbivnf/0SlYhk3NnnI/4+maW8DX7lJRGugvGYO+U2fPbLZhzXRVUZJZv4CqUTnxpgt/N+hmbl+neT92yfT2x8P3ZZ2Jf5UBhNzvWTjPCPLtfn/jUyT0xMdHtjVKwOkjpSbfERnWJSXTwvBWHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYFKhHPLIT+V0ZDlOhBAu0MGsW4LtCTJ7bSDSh9abR0=;
 b=dg3cJ5saYT4ZvcbF1qdEpRNlca4DHuol4Z5wmfV8s1Gf8VP2gUeyGjJ2zVvGfJ0X4SRjf/Q00xt1Uvgk9c+VUsFR8TNtLhsMyAQkKu9f4BVWcDvXHwlFwDTKvPT2mECMce8IgBHXSyPz3uMPb6IUHJI7sndH2mH/RH16YMtZqKvpM2Y/arbiAvGojh1EaZe0CSm0jU6kFthe46rXIxQmQrPfYb6a/sC7N+M/xoSvhahhcWtmuFPvvbnhxsxB40lriDjIAKIywGxq9FewoJL86ZLOE0y9LkQF86A+iWFkr7N0O1iOa7Djamk+clVbuq1hPw0zEuFKzFv2muLfuUMFFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eYFKhHPLIT+V0ZDlOhBAu0MGsW4LtCTJ7bSDSh9abR0=;
 b=auxGnUgB6OkhQynNhyejC033YLndAdqzm4UKWTYv/J7owhru1GNP1S7TRbq5SBE0D42JFu0HlUww3zCyzT+9+lVpHZw7PWLZXyTf1PnQAZAYlQti0yOCIOsjtCOSn5Eztf50GPnJ0MTjII2Z5L8nVCLrfmwB8WA3WCoSUUYEEd8=
Received: from BYAPR15MB2999.namprd15.prod.outlook.com (2603:10b6:a03:fa::12)
 by BYAPR15MB2357.namprd15.prod.outlook.com (2603:10b6:a02:82::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.28; Sat, 18 Apr
 2020 06:13:49 +0000
Received: from BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2]) by BYAPR15MB2999.namprd15.prod.outlook.com
 ([fe80::bdf1:da56:867d:f8a2%7]) with mapi id 15.20.2921.027; Sat, 18 Apr 2020
 06:13:49 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Mao Wenan <maowenan@huawei.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH bpf-next v2] bpf: remove set but not used variable
 'dst_known'
Thread-Topic: [PATCH bpf-next v2] bpf: remove set but not used variable
 'dst_known'
Thread-Index: AQHWFSG2p4lcDbyWLku43qLEs5sPa6h+ZsgA
Date:   Sat, 18 Apr 2020 06:13:48 +0000
Message-ID: <C7067847-8EDB-49B5-8DDF-C8504BB82962@fb.com>
References: <8855e82a-88d0-8d1e-e5e0-47e781f9653c@huawei.com>
 <20200418013735.67882-1-maowenan@huawei.com>
In-Reply-To: <20200418013735.67882-1-maowenan@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:46e2]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0c1654b-3de3-4ccb-c60f-08d7e35fa8dd
x-ms-traffictypediagnostic: BYAPR15MB2357:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB23575A02AD720FBF10381078B3D60@BYAPR15MB2357.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:913;
x-forefront-prvs: 0377802854
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR15MB2999.namprd15.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10019020)(366004)(136003)(39860400002)(396003)(376002)(346002)(66946007)(76116006)(66556008)(53546011)(54906003)(316002)(8676002)(66446008)(36756003)(6512007)(6506007)(91956017)(71200400001)(6486002)(2616005)(2906002)(64756008)(66476007)(186003)(6916009)(86362001)(5660300002)(4326008)(33656002)(8936002)(478600001)(81156014);DIR:OUT;SFP:1102;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fxU55p0Z9/KV6YAkCiQFD2B5qyiAQ+tTgFeSual+oQoBjJ2LHgQfsbsc1vVQg1wy9nnWvKHZBUOCn1nydaxzY90oL8OKSSIy/rzqAVY95w/YdtfvSJ6xDbMmLjUD08cFApIeT8khoOGHLnkQOV+EhJLCbU65D4PasgXMWesjeXf77CIoCH9+F6FzX1qLGGd7LKWHyu+htaQRMRF4yuQuCT8+k+blq3nH4ScHuN+nTBi/vZ3lKCIybXLx1B0blwcqkA4NsM31EgzHbOyB634HwSajYFcrVkMUV0Q4Y9Ip+3de8Gg2Tjls6RaXeJ3oIUhuWiO4A69KurKT+yWnpAQGdnYLRQoKxz1HL5ejzZ2dpcXtqzJ97dRk9WLTdUCW23BkfjkciU7o1uSuWAeKz5LlLepydKifiZejJc9GhGA36b+j252ZpjP+nhfFlH7ALKZQ
x-ms-exchange-antispam-messagedata: rn02U2NrnwOjJBfLVJCum91Tj2wV46V+xxKC9Yv1+9sMbBRaVKcDiDygaJUdkKNvxU95snI3NXLjdfxByzpEk48rJBbmFlDtew+dWFXtIw0dqLORjoetIICUdl3+LphphH53u0dQIqkIxeJJjqFrHv7wT164l+FuvZk1tcA+zdrKW4rOUU34XbOpMqMfke6iidHrXwxeZUopQhpVEW5LgEW8d61g2wMGxextNXVE+xTX7mKBszzGbbHjZf7aDgHZd08BnI9rWuOJfAaQWaBAr+D5zuBZMSIHKFjMtl8t48ZewXnEqe4lE9KI+FwTSC2KEyjG9cY3V1lDa8fnqu9o47zQTrtQ3T4EwmjP6GJag9oTtfu3VWk87nsZnT2efs9Kja0TX1h9be6BkcL5Ak3SNPY63sQHDtKryqBiFfJIIqWtJqflab7/6AQ5izBcWD+BH7BqxylFi8IT95dHBoM3VA+7Fl7JY7pJalweFReEJoKE28IhA0QNK7029632Hjv0xB1wg4Kgulcx2y1wHSnq8cY7ObNKfKJSGgNm9Tkre2Kr08ytQnbjGnOYfdTqopTA2FV6OjD2NKEMYBJ3/WfbXKpexkiqmWiqipu7MqyaE6hIhesEnbpLoyaLOCxV1CiqpRQx/VmeRmvbHd6+HUbBtLPXfC3qeJorL2NdAgI6zWMPwPFNt2R02LwGa4ZnpKhU91Z0JsJ87ypXmT63V0iGwthEKrVLPXCEw7vhWW+SvpTw2TAIeClgw4hnhz/k6gGVRCQPSOJf4AMFlvGBBVyG+rRdz4nx2UiBy2d3XxkRcsiNzDsW5J9HNh13hgA6BUxR9s/qAeVnhrfAoQK5cxwptA==
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF70C97E4DCF6D4C854C39FDA3688A10@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c0c1654b-3de3-4ccb-c60f-08d7e35fa8dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Apr 2020 06:13:48.8180
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PUkQIa6btqRztOtgqpdsDijE+gVfwbMvAOVDKdEmoUIRX+z0uDL/8bl8qPAZh1kQ/tAkSXhR1wrsa51tX+V8IQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2357
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.676
 definitions=2020-04-18_01:2020-04-17,2020-04-18 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 bulkscore=0
 malwarescore=0 priorityscore=1501 mlxlogscore=999 suspectscore=0
 lowpriorityscore=0 mlxscore=0 clxscore=1015 impostorscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2003020000 definitions=main-2004180048
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gQXByIDE3LCAyMDIwLCBhdCA2OjM3IFBNLCBNYW8gV2VuYW4gPG1hb3dlbmFuQGh1
YXdlaS5jb20+IHdyb3RlOg0KPiANCj4gRml4ZXMgZ2NjICctV3VudXNlZC1idXQtc2V0LXZhcmlh
YmxlJyB3YXJuaW5nOg0KPiANCj4ga2VybmVsL2JwZi92ZXJpZmllci5jOjU2MDM6MTg6IHdhcm5p
bmc6IHZhcmlhYmxlIOKAmGRzdF9rbm93buKAmQ0KPiBzZXQgYnV0IG5vdCB1c2VkIFstV3VudXNl
ZC1idXQtc2V0LXZhcmlhYmxlXSwgZGVsZXRlIHRoaXMNCj4gdmFyaWFibGUuDQo+IA0KPiBTaWdu
ZWQtb2ZmLWJ5OiBNYW8gV2VuYW4gPG1hb3dlbmFuQGh1YXdlaS5jb20+DQoNCkFja2VkLWJ5OiBT
b25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KDQpXaXRoIG9uZSBuaXQgYmVsb3cuIA0K
DQo+IC0tLQ0KPiB2MjogcmVtb3ZlIGZpeGVzIHRhZyBpbiBjb21taXQgbG9nLiANCj4ga2VybmVs
L2JwZi92ZXJpZmllci5jIHwgNCArLS0tDQo+IDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigr
KSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9rZXJuZWwvYnBmL3ZlcmlmaWVy
LmMgYi9rZXJuZWwvYnBmL3ZlcmlmaWVyLmMNCj4gaW5kZXggMDRjNjYzMGNjMThmLi5jOWY1MDk2
OWE2ODkgMTAwNjQ0DQo+IC0tLSBhL2tlcm5lbC9icGYvdmVyaWZpZXIuYw0KPiArKysgYi9rZXJu
ZWwvYnBmL3ZlcmlmaWVyLmMNCj4gQEAgLTU2MDAsNyArNTYwMCw3IEBAIHN0YXRpYyBpbnQgYWRq
dXN0X3NjYWxhcl9taW5fbWF4X3ZhbHMoc3RydWN0IGJwZl92ZXJpZmllcl9lbnYgKmVudiwNCj4g
ew0KPiAJc3RydWN0IGJwZl9yZWdfc3RhdGUgKnJlZ3MgPSBjdXJfcmVncyhlbnYpOw0KPiAJdTgg
b3Bjb2RlID0gQlBGX09QKGluc24tPmNvZGUpOw0KPiAtCWJvb2wgc3JjX2tub3duLCBkc3Rfa25v
d247DQo+ICsJYm9vbCBzcmNfa25vd247DQoNClRoaXMgaXMgbm90IGEgaGFyZCBydWxlLCBidXQg
d2UgcHJlZmVyIHRvIGtlZXAgdmFyaWFibGUgZGVmaW5pdGlvbiBpbiANCiJyZXZlcnNlIENocmlz
dG1hcyB0cmVlIiBvcmRlci4gU2luY2Ugd2UgYXJlIG9uIHRoaXMgZnVuY3Rpb24sIGxldCdzIA0K
cmVvcmRlciB0aGVzZSBkZWZpbml0aW9ucyB0byBzb21ldGhpbmcgbGlrZToNCg0KICAgICAgICB1
NjQgaW5zbl9iaXRuZXNzID0gKEJQRl9DTEFTUyhpbnNuLT5jb2RlKSA9PSBCUEZfQUxVNjQpID8g
NjQgOiAzMjsNCiAgICAgICAgc3RydWN0IGJwZl9yZWdfc3RhdGUgKnJlZ3MgPSBjdXJfcmVncyhl
bnYpOw0KICAgICAgICB1OCBvcGNvZGUgPSBCUEZfT1AoaW5zbi0+Y29kZSk7DQogICAgICAgIHUz
MiBkc3QgPSBpbnNuLT5kc3RfcmVnOw0KICAgICAgICBzNjQgc21pbl92YWwsIHNtYXhfdmFsOw0K
ICAgICAgICB1NjQgdW1pbl92YWwsIHVtYXhfdmFsOw0KICAgICAgICBib29sIHNyY19rbm93bjsN
CiAgICAgICAgaW50IHJldDsNCg0KDQo=
