Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38A5777AA8
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 19:01:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387794AbfG0RBF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 13:01:05 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:29498 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387665AbfG0RBF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 13:01:05 -0400
Received: from pps.filterd (m0044008.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x6RGxWHa024100;
        Sat, 27 Jul 2019 10:00:44 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=PBjU7LPb7QxXfZceBJOo6LlYkDqLjuXqfuYpW3Mhgos=;
 b=HO/yVXW+2x69rqVul/HC2YgHGStb3kDk6hmQJgPY6FVPROH2ypu8uu0G/KejxP/mAqVE
 BkkXnUv7v/8B6Wx4qyD5ME3MfkGRPt2ziN06Lrou5uY1CIFTyYJ3G/SJxQ/fsY+i6bi3
 d5BDVUHa82lvDjfGOvHe8jmgamtZxielSOc= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2u0hwm9709-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 27 Jul 2019 10:00:44 -0700
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub06.TheFacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 10:00:43 -0700
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sat, 27 Jul 2019 10:00:43 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sat, 27 Jul 2019 10:00:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jx7nwHAZROqDcDWmfYSZHcSdQgZdDUTYFACrC0XOspKlJRPLnJwrbb2HXk+ikdDeO7hSYKGvaYrIzhhyg9VqPDf/jEdCqbnbXazAWYDfBYkyMX4lE0Gb9Hc2gvxDhr/yekHtCmSralgjmnJmXm35B8lCNJDKn+uepEyeQ6ZHc41jOLvzh1tlORE9jr98bkqi9l+C4iJTbstt373jjwU4GPrhrkCvhYVTCbfILSvL0VavPZso6U8LZxrVdzHQ89MyT5FPpepd0ttrc/1Tg5eRAXhmg38yarHTdgFT0nE4w1Syb2YaYfV8PdeMDkRdzXYE1HGfustMNu2xMHa+sUXOtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBjU7LPb7QxXfZceBJOo6LlYkDqLjuXqfuYpW3Mhgos=;
 b=BpEwhpFnby5a43nsL0LVofOcWDqxo1mxxvhZriB/7vp90DopUckF29kLpIboSo0GWZsX/2PS1xkra2WTmgOIrvtI5Xs+F+Hq4L7pFGYvYs0KOX6QviSV4O30TAa7ostAoNI/9irS2Tazb/d0xmxEytv1vNQqEtEuTia29QlrXjIN3zY/2YLoVjSgmATh+3XITQmI3n8xJzb20Gg1R33qt7jLV73C1tu3SruKXF5Ri/i6ciBDcjLIsre2eZozduAsUT5TfboK6+/NlWhtukSZrKABsIsczEUB7TEU1CTjtJwfHQDh9uqBGbL7UdjkldjgA3G1xsWFXiiHwk7DYJRl5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PBjU7LPb7QxXfZceBJOo6LlYkDqLjuXqfuYpW3Mhgos=;
 b=NFoHlUYTych0etLZoxvuKFed82zuZHLdKgY5Mb4QDH5WhyN91H+P2XA34hXdZdnIF/doXZJRgmV1uHZSv3zhLsmsvRAJLuovFOWadBXpjFy/7eOVKjUex47Fdx6k7Kj5QIBlpHBrT5F4nHW4JITuxk8BipmbmT9cWV/1OlxfPsg=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3368.namprd15.prod.outlook.com (20.179.58.215) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Sat, 27 Jul 2019 17:00:26 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::b964:e4e:5b14:fa7%6]) with mapi id 15.20.2115.005; Sat, 27 Jul 2019
 17:00:26 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "Yonghong Song" <yhs@fb.com>, Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Topic: [PATCH bpf-next 02/10] libbpf: implement BPF CO-RE offset
 relocation algorithm
Thread-Index: AQHVQlYa1je1qwey7kSYyWCuHJKqUabb+eAAgAIJpwCAALFaAA==
Date:   Sat, 27 Jul 2019 17:00:25 +0000
Message-ID: <957fff81-d845-ebc9-0e80-dbb1f1736b40@fb.com>
References: <20190724192742.1419254-1-andriin@fb.com>
 <20190724192742.1419254-3-andriin@fb.com>
 <20190725231831.7v7mswluomcymy2l@ast-mbp>
 <CAEf4BzZxPgAh4PGSWyD0tPOd1wh=DGZuSe1fzxc-Sgyk4D5vDg@mail.gmail.com>
In-Reply-To: <CAEf4BzZxPgAh4PGSWyD0tPOd1wh=DGZuSe1fzxc-Sgyk4D5vDg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR18CA0042.namprd18.prod.outlook.com
 (2603:10b6:320:31::28) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::1:a57e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dbf735fd-0a5f-4aec-0cfa-08d712b3eb9a
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB3368;
x-ms-traffictypediagnostic: BYAPR15MB3368:
x-microsoft-antispam-prvs: <BYAPR15MB3368E088179EDF437625A6DED7C30@BYAPR15MB3368.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:962;
x-forefront-prvs: 01110342A5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(39860400002)(346002)(376002)(136003)(396003)(199004)(189003)(6512007)(6436002)(86362001)(54906003)(316002)(110136005)(14454004)(478600001)(36756003)(66946007)(46003)(53936002)(4744005)(66556008)(7736002)(6486002)(2906002)(66476007)(31696002)(229853002)(71200400001)(71190400001)(64756008)(66446008)(5660300002)(4326008)(8676002)(81166006)(6116002)(81156014)(186003)(102836004)(6506007)(53546011)(386003)(6246003)(8936002)(76176011)(99286004)(486006)(31686004)(476003)(2616005)(446003)(11346002)(52116002)(68736007)(305945005)(25786009)(256004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3368;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: exvOJsxO1PJyY0jFZ4zaYu7/9mHDMafxDt7KJoW8a9Lq7F7bwc/32ki4JeGrjGlNez8AMFhPNE6URA1TBE5O5ZisDqDKcY7JzpDEt2z197G4jAKuouVouYbRjtUr5CAbNNtf5R7u59p2dsvv2bUu0cg1sLvfHQrJHrsTVyDFfaJS7XPpZj3sNsc0om8k1Ij6AE2x15d7TxLPjPx0x/v2bFX6yYT1j1BJN0j0ghBqbdR5kGaDXnciKVdY9geFYFOzpPUoDzNX5MSX34sSiXUmkx0W8rQsrCxwCgH1+XJYhxyENW7n5SOmN2/1QoFHFwRys4SxkHFMexRYzwQXneeaPxgmPiAQFzMl0l0h9g15xzXyQ0NH0yql3yi8tMNNLXe3h/kUszWX6zMfhRv9CW6CXl5zdvFx6B8IMzClyDvWMSc=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDBE4C8B84572B41B5E853779210CAA6@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: dbf735fd-0a5f-4aec-0cfa-08d712b3eb9a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jul 2019 17:00:26.0120
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ast@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3368
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-07-27_13:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1907270214
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNy8yNi8xOSAxMToyNSBQTSwgQW5kcmlpIE5ha3J5aWtvIHdyb3RlOg0KPj4+ICsgICAgIH0g
ZWxzZSBpZiAoY2xhc3MgPT0gQlBGX1NUICYmIEJQRl9NT0RFKGluc24tPmNvZGUpID09IEJQRl9N
RU0pIHsNCj4+PiArICAgICAgICAgICAgIGlmIChpbnNuLT5pbW0gIT0gb3JpZ19vZmYpDQo+Pj4g
KyAgICAgICAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPj4+ICsgICAgICAgICAgICAg
aW5zbi0+aW1tID0gbmV3X29mZjsNCj4+PiArICAgICAgICAgICAgIHByX2RlYnVnKCJwcm9nICcl
cyc6IHBhdGNoZWQgaW5zbiAjJWQgKFNUIHwgTUVNKSBpbW0gJWQgLT4gJWRcbiIsDQo+Pj4gKyAg
ICAgICAgICAgICAgICAgICAgICBicGZfcHJvZ3JhbV9fdGl0bGUocHJvZywgZmFsc2UpLA0KPj4+
ICsgICAgICAgICAgICAgICAgICAgICAgaW5zbl9pZHgsIG9yaWdfb2ZmLCBuZXdfb2ZmKTsNCj4+
IEknbSBwcmV0dHkgc3VyZSBsbHZtIHdhcyBub3QgY2FwYWJsZSBvZiBlbWl0dGluZyBCUEZfU1Qg
aW5zbi4NCj4+IFdoZW4gZGlkIHRoYXQgY2hhbmdlPw0KPiBJIGp1c3QgbG9va2VkIGF0IHBvc3Np
YmxlIGluc3RydWN0aW9ucyB0aGF0IGNvdWxkIGhhdmUgMzItYml0DQo+IGltbWVkaWF0ZSB2YWx1
ZS4gVGhpcyBpcyBgKihyWCkgPSBvZmZzZXRvZihzdHJ1Y3QgcywgZmllbGQpYCwgd2hpY2ggSQ0K
PiB0aG91Z2ggaXMgY29uY2VpdmFibGUuIERvIHlvdSB0aGluayBJIHNob3VsZCBkcm9wIGl0Pw0K
DQpKdXN0IHRyeWluZyB0byBwb2ludCBvdXQgdGhhdCBzaW5jZSBpdCdzIG5vdCBlbWl0dGVkIGJ5
IGxsdm0NCnRoaXMgY29kZSBpcyBsaWtlbHkgdW50ZXN0ZWQgPw0KT3IgeW91J3ZlIGNyZWF0ZWQg
YSBicGYgYXNtIHRlc3QgZm9yIHRoaXM/DQoNCg0K
