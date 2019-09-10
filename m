Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A19A0AE4CC
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 09:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390939AbfIJHog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 03:44:36 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:38066 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390921AbfIJHog (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Sep 2019 03:44:36 -0400
Received: from pps.filterd (m0148461.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x8A7hIgm026752;
        Tue, 10 Sep 2019 00:43:24 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=k5Fj9jPD3m2iFJqOBUHxk14jv70B05h9TwIMGWNJvlI=;
 b=ebf+wu2ikeMvuB61Yr0yr5O6pOUunt7vauNdBUobVoOK6MMlYdwfy3AvPOvjbMdT644b
 nk9BNWV11jMAlywUtQOBgMka2/LWMqBOPx3fDXPvDQ1I7Fj6QLiJwgiX1LLTmxA5K/p2
 Vw9jX7wZ7S3oH2FFTtiApyE50sZeJeoEHCA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2uwrsbbpjy-6
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 10 Sep 2019 00:43:24 -0700
Received: from ash-exhub204.TheFacebook.com (2620:10d:c0a8:83::4) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 10 Sep 2019 00:43:05 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 10 Sep 2019 00:43:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gZ0lPSIbLLqICA5UDJz+0yy5UnKNYWaZ+xI5YaCvWlG0V1nl74G43p+f/lqFRAT2tSFUhJIB/UtB5hb5Z4TYADeW8yzJOS3dgTvL/6FSdu1AccpY7yih+TX1HCy1g19SHapHGy0ACDhj4qV1NVaCh+IvCdEeFJV3uprQuLM+nHsvRWZ+Q0QAcux0DQLHbPNK7pxuZdLj1S83SBM0wcT0v1XWqYcNIamW4+lXUxFcpBbki7QQmyulCaVFy5MAL3QFdHIXwqsJAjkTHb99R30iQ0FRwZ58ydWMtdXNOydtujg1ZbKE02XgeEbCd+GUyoTgnrznovrHFo2eK+qECR5saw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5Fj9jPD3m2iFJqOBUHxk14jv70B05h9TwIMGWNJvlI=;
 b=mrNMqu+OBXG6QgLJm9K82UagtrH8ZSB9/IFyQctmd9SuRtg9FmM/BqdZT1NUa9jGft04w76g4Hr/YDuvR25tOffw9z69xDFopCdGldLY5bYrq1zJ5JjvbIUARPjRbySzw0pJXBXzkXB5+Xwya+CPzjxfDCQs2ijdzWhKIbbQORr3mxZP1BEbTi8Zj4+4+eSvHGnIjr4R5MKCLqf1ygwsPEG5Ssr1o+DNlwAD+MHEqVfmjhR6Vw2/IRQf9PbbSfWKzNekeCI3TvwHkrPHPiIE62WGFJpBIIUQ4kVoMmYncxNunuTKl1Qjzg9VDY1906Uhj1zfcB1aA7tapfXd25h/yA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k5Fj9jPD3m2iFJqOBUHxk14jv70B05h9TwIMGWNJvlI=;
 b=R4twqrKsOVamqGKXoT5yIzJqoRUKLbntYNt42lHMfnVRsD5aH34TNryZ3AIYf3EeDX4dXcZUmLf0WXGMmzETUdUo2UNQkzsrjuH7/ddyrJeGDA0XubbIBbAVxrNWA/M+PUVA4jBX0dN5FXjOgZ9/0cMyWmEOdduVeyJFDrKlckg=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB2408.namprd15.prod.outlook.com (52.135.198.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Tue, 10 Sep 2019 07:43:04 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::95ab:61a0:29f4:e07e%6]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 07:43:04 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Alan Maguire <alan.maguire@oracle.com>
CC:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "quentin.monnet@netronome.com" <quentin.monnet@netronome.com>,
        Andrey Ignatov <rdna@fb.com>,
        "joe@wand.net.nz" <joe@wand.net.nz>,
        "acme@redhat.com" <acme@redhat.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        "alexey.budankov@linux.intel.com" <alexey.budankov@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "namhyung@kernel.org" <namhyung@kernel.org>,
        "sdf@google.com" <sdf@google.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "peter@lekensteyn.nl" <peter@lekensteyn.nl>,
        "ivan@cloudflare.com" <ivan@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "bhole_prashant_q7@lab.ntt.co.jp" <bhole_prashant_q7@lab.ntt.co.jp>,
        "david.calavera@gmail.com" <david.calavera@gmail.com>,
        "danieltimlee@gmail.com" <danieltimlee@gmail.com>,
        Takshak Chahande <ctakshak@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "jbenc@redhat.com" <jbenc@redhat.com>
Subject: Re: [RFC bpf-next 2/7] bpf: extend bpf_pcap support to tracing
 programs
Thread-Topic: [RFC bpf-next 2/7] bpf: extend bpf_pcap support to tracing
 programs
Thread-Index: AQHVZcUc6/vdinG1MEa+i1XJ6GmfZ6ciWzeAgAGUGoCAAJvLgA==
Date:   Tue, 10 Sep 2019 07:43:04 +0000
Message-ID: <cc514705-9974-9328-b66e-b57cfa61d417@fb.com>
References: <1567892444-16344-1-git-send-email-alan.maguire@oracle.com>
 <1567892444-16344-3-git-send-email-alan.maguire@oracle.com>
 <89305ec8-7e03-3cd0-4e39-c3760dd3477b@fb.com>
 <alpine.LRH.2.20.1909092236490.10757@dhcp-10-175-172-139.vpn.oracle.com>
In-Reply-To: <alpine.LRH.2.20.1909092236490.10757@dhcp-10-175-172-139.vpn.oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0038.namprd02.prod.outlook.com
 (2603:10b6:a03:54::15) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::4636]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 133e508b-3fea-4b7d-4c76-08d735c28355
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BYAPR15MB2408;
x-ms-traffictypediagnostic: BYAPR15MB2408:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB24088FC46859DF99BA1EDC42D3B60@BYAPR15MB2408.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(39860400002)(376002)(136003)(366004)(199004)(51914003)(189003)(99286004)(76176011)(66946007)(14454004)(6512007)(71200400001)(6436002)(7416002)(6916009)(81156014)(81166006)(6116002)(8936002)(305945005)(86362001)(4326008)(486006)(256004)(478600001)(7736002)(2906002)(66446008)(64756008)(66556008)(66476007)(229853002)(6246003)(186003)(476003)(25786009)(2616005)(446003)(11346002)(53546011)(5024004)(14444005)(52116002)(46003)(53936002)(5660300002)(386003)(8676002)(6506007)(6486002)(31686004)(102836004)(54906003)(316002)(71190400001)(36756003)(31696002);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2408;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: DUW5VrHK1gKjf5B6Jt82cUw5NSBZ13XDGBpwjNm9YrocM4rNWB0R0qOg+bTqfaP8gS13CY4bCchjVezs0ytlcYPk3jbPbFk/PHxA3chO0dhdXoqecVN4WD9SAyvUwKjyhz1lPpID73gtHc02qVfNYZBr4qL4Yx8gplZZpPNN3qdSP8pa2trNJA7Zs8lqSwPzJElWpHrIjRlFcOInsLlesovhoyO1gF0lMG5mwjqhVTn4aUCoXPuBs/HjJlHx/vK/vLQ3k/LyZav5/82yWfkl4+yvOSjJfcFLB/gNuctDpIDPSy0O20E48v4ylP1qItL1Xi32SFNY4j+te2HDhhGdRi3nwjlNpoHGJfDkLgxyUx30UjXnzhtak6dhPP10EHvWKvlTRQccLElDaEUYxiIGNdHWfyh+B6TLO8Lem8qZ748=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D482D794378A87499182351EEDD146D4@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 133e508b-3fea-4b7d-4c76-08d735c28355
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 07:43:04.5713
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KmSx9CHx2Trv9ycytxoOjbtDbaxoge4qLUN/xAcB0kwEHtYoverm9z6WbnRdYGyu
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2408
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.70,1.0.8
 definitions=2019-09-10_06:2019-09-09,2019-09-10 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 mlxlogscore=999 priorityscore=1501 bulkscore=0 spamscore=0
 lowpriorityscore=0 adultscore=0 phishscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 clxscore=1011 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1906280000 definitions=main-1909100076
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDkvOS8xOSAxMToyNSBQTSwgQWxhbiBNYWd1aXJlIHdyb3RlOg0KPiBPbiBTdW4sIDgg
U2VwIDIwMTksIFlvbmdob25nIFNvbmcgd3JvdGU6DQo+ICAgDQo+PiBGb3IgbmV0IHNpZGUgYnBm
X3BlcmZfZXZlbnRfb3V0cHV0LCB3ZSBoYXZlDQo+PiBzdGF0aWMgdW5zaWduZWQgbG9uZyBicGZf
c2tiX2NvcHkodm9pZCAqZHN0X2J1ZmYsIGNvbnN0IHZvaWQgKnNrYiwNCj4+ICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHVuc2lnbmVkIGxvbmcgb2ZmLCB1bnNpZ25lZCBsb25n
IGxlbikNCj4+IHsNCj4+ICAgICAgICAgICB2b2lkICpwdHIgPSBza2JfaGVhZGVyX3BvaW50ZXIo
c2tiLCBvZmYsIGxlbiwgZHN0X2J1ZmYpOw0KPj4NCj4+ICAgICAgICAgICBpZiAodW5saWtlbHko
IXB0cikpDQo+PiAgICAgICAgICAgICAgICAgICByZXR1cm4gbGVuOw0KPj4gICAgICAgICAgIGlm
IChwdHIgIT0gZHN0X2J1ZmYpDQo+PiAgICAgICAgICAgICAgICAgICBtZW1jcHkoZHN0X2J1ZmYs
IHB0ciwgbGVuKTsNCj4+DQo+PiAgICAgICAgICAgcmV0dXJuIDA7DQo+PiB9DQo+Pg0KPj4gQlBG
X0NBTExfNShicGZfc2tiX2V2ZW50X291dHB1dCwgc3RydWN0IHNrX2J1ZmYgKiwgc2tiLCBzdHJ1
Y3QgYnBmX21hcA0KPj4gKiwgbWFwLA0KPj4gICAgICAgICAgICAgIHU2NCwgZmxhZ3MsIHZvaWQg
KiwgbWV0YSwgdTY0LCBtZXRhX3NpemUpDQo+PiB7DQo+PiAgICAgICAgICAgdTY0IHNrYl9zaXpl
ID0gKGZsYWdzICYgQlBGX0ZfQ1RYTEVOX01BU0spID4+IDMyOw0KPj4NCj4+ICAgICAgICAgICBp
ZiAodW5saWtlbHkoZmxhZ3MgJiB+KEJQRl9GX0NUWExFTl9NQVNLIHwgQlBGX0ZfSU5ERVhfTUFT
SykpKQ0KPj4gICAgICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5WQUw7DQo+PiAgICAgICAgICAg
aWYgKHVubGlrZWx5KHNrYl9zaXplID4gc2tiLT5sZW4pKQ0KPj4gICAgICAgICAgICAgICAgICAg
cmV0dXJuIC1FRkFVTFQ7DQo+Pg0KPj4gICAgICAgICAgIHJldHVybiBicGZfZXZlbnRfb3V0cHV0
KG1hcCwgZmxhZ3MsIG1ldGEsIG1ldGFfc2l6ZSwgc2tiLCBza2Jfc2l6ZSwNCj4+ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBicGZfc2tiX2NvcHkpOw0KPj4gfQ0KPj4NCj4+IEl0
IGRvZXMgbm90IHJlYWxseSBjb25zaWRlciBvdXRwdXQgYWxsIHRoZSBmcmFncy4NCj4+IEkgdW5k
ZXJzdGFuZCB0aGF0IHRvIGdldCB0cnVseSBhbGwgcGFja2V0IGRhdGEsIGZyYWdzIHNob3VsZCBi
ZQ0KPj4gY29uc2lkZXJlZCwgYnV0IHNlZW1zIHdlIGRpZCBub3QgZG8gaXQgYmVmb3JlPyBJIGFt
IHdvbmRlcmluZw0KPj4gd2hldGhlciB3ZSBuZWVkIHRvIGRvIGhlcmUuDQo+IA0KPiBUaGFua3Mg
Zm9yIHRoZSBmZWVkYmFjayEgSW4gZXhwZXJpbWVudGluZyB3aXRoIHBhY2tldCBjYXB0dXJlLA0K
PiBteSBvcmlnaW5hbCBob3BlIHdhcyB0byBrZWVwIHRoaW5ncyBzaW1wbGUgYW5kIGF2b2lkIGZy
YWdtZW50IHBhcnNpbmcNCj4gaWYgcG9zc2libGUuIEhvd2V2ZXIgaWYgc2NhdHRlci1nYXRoZXIg
aXMgZW5hYmxlZCBmb3IgdGhlIG5ldHdvcmtpbmcNCj4gZGV2aWNlLCBvciBpbmRlZWQgaWYgaXQn
cyBydW5uaW5nIGluIGEgVk0gaXQgdHVybnMgb3V0IGEgbG90IG9mIHRoZQ0KPiBpbnRlcmVzdGlu
ZyBwYWNrZXQgZGF0YSBlbmRzIHVwIGluIHRoZSBmcmFnbWVudHMgb24gdHJhbnNtaXQgKHNzaA0K
PiBoZWFkZXJzLCBodHRwIGhlYWRlcnMgZXRjKS4gIFNvIEkgdGhpbmsgaXQgd291bGQgYmUgd29y
dGggY29uc2lkZXJpbmcNCj4gYWRkaW5nIHN1cHBvcnQgZm9yIGZyYWdtZW50IHRyYXZlcnNhbC4g
IEl0J3Mgbm90IG5lZWRlZCBhcyBtdWNoDQo+IGluIHRoZSBza2IgcHJvZ3JhbSBjYXNlIC0gd2Ug
Y2FuIGFsd2F5cyBwdWxsdXAgdGhlIHNrYiAtIGJ1dCBpbg0KPiB0aGUgdHJhY2luZyBzaXR1YXRp
b24gd2UgcHJvYmFibHkgd291bGRuJ3Qgd2FudCB0byBkbyBzb21ldGhpbmcNCj4gdGhhdCBpbnZh
c2l2ZSBpbiB0cmFjaW5nIGNvbnRleHQuDQoNCkFncmVlIHRoYXQgaW4gdHJhY2luZyBjb250ZXh0
LCB3ZSBzaG91bGQgYXZvaWQgcHVzaC9wdWxsIHNrYi4gSXQgaXMNCmluZGVlZCBpbnZhc2l2ZS4N
Cg0KPiANCj4gRnJhZ21lbnQgdHJhdmVyc2FsIG1pZ2h0IGJlIHdvcnRoIGJyZWFraW5nIG91dCBh
cyBhIHNlcGFyYXRlIHBhdGNoc2V0LA0KPiBwZXJoYXBzIHRyaWdnZXJlZCBieSBhIHNwZWNpZmlj
IGZsYWcgdG8gYnBmX3NrYl9ldmVudF9vdXRwdXQ/DQoNClRoaXMgY2FuIGJlIGRvbmUgZm9yIGJw
Zl9za2JfZXZlbnRfb3V0cHV0IGFzIHRoZSBjb250ZXh0IGlzIGEgc2tfYnVmZi4NCkFuZCB5b3Ug
Y2FuIGp1c3QgZm9sbG93IHRoZSBmcmFncyB0byBjb3B5IHRoZSB3aG9sZSB0aGluZyB3aXRob3V0
DQpicGZfcHJvYmVfcmVhZCgpLg0KDQo+IA0KPiBGZWVkYmFjayBmcm9tIGZvbGtzIGF0IExpbnV4
IFBsdW1iZXJzIChJIGhvcGUgSSdtIHN1bW1hcml6aW5nIGNvcnJlY3RseSkNCj4gc2VlbWVkIHRv
IGFncmVlIHdpdGggd2hhdCB5b3UgbWVudGlvbmVkIFdSVCB0aGUgZmlyc3QgcGF0Y2ggaW4gdGhp
cw0KPiBzZXJpZXMuICBUaGUgZ2lzdCB3YXMgd2UgcHJvYmFibHkgZG9uJ3Qgd2FudCB0byBmb3Jj
ZSB0aGUgbWV0YWRhdGEgdG8gYmUgYQ0KPiBzcGVjaWZpYyBwYWNrZXQgY2FwdHVyZSB0eXBlOyB3
ZSdkIHJhdGhlciB1c2UgdGhlIGV4aXN0aW5nIHBlcmYgZXZlbnQNCj4gbWVjaGFuaXNtcyBhbmQg
aWYgd2UgYXJlIGluZGVlZCBkb2luZyBwYWNrZXQgY2FwdHVyZSwgc2ltcGx5IHNwZWNpZnkgdGhh
dA0KPiBkYXRhIGluIHRoZSBwcm9ncmFtIGFzIG1ldGFkYXRhLg0KDQpBZ3JlZSwgeW91IGNhbiBo
YXZlIHdoYXRldmVyIG1ldGFkYXRhIHlvdSBoYXZlIGZvciBicGZfcGVyZl9ldmVudF9vdXRwdXQu
DQoNCj4gDQo+IEknZCBiZSBoYXBweSB3aXRoIHRoYXQgYXBwcm9hY2ggbXlzZWxmIGlmIEkgY291
bGQgY2FwdHVyZSBza2INCj4gZnJhZ21lbnRzIGluIHRyYWNpbmcgcHJvZ3JhbXMgLSBiZWluZyBh
YmxlIHRvIGRvIHRoYXQgd291bGQgZ2l2ZQ0KPiBlcXVpdmFsZW50IGZ1bmN0aW9uYWxpdHkgdG8g
d2hhdCBJIHByb3Bvc2VkIGJ1dCB3aXRob3V0IGhhdmluZyBhIHBhY2tldA0KPiBjYXB0dXJlLXNw
ZWNpZmljIGhlbHBlci4NCg0KVGhhdCB3b24ndCB3b3JrIGZvciB0cmFjaW5nIHByb2dyYW0uIEZ1
bGwgb2YgYnBmX3Byb2JlX3JlYWQoKQ0KaW4gdHJhY2luZyB2ZXJzaW9uIG9mIHBhY2tldCBjb3B5
aW5nIGlzIG5vdCBuaWNlIGVpdGhlci4NCg0KV2UgbWF5IHN0aWxsIG5lZWQgYSBkaWZmZXJlbnQg
aGVscGVyIGZvciB0cmFjaW5nIHByb2dyYW1zLg0KDQpJIHRoaW5rIHdlIG5lZWQgc29tZXRoaW5n
IGxpa2UgYmVsb3c6DQogICAtIHZtbGludXggQlRGIGF0IC9zeXMva2VybmVsL2J0Zi9rZXJuZWws
IGlzIGxvYWRlZCBpbnRvIGtlcm5lbC4NCiAgICAgKC9zeXMva2VybmVsL2J0Zi9rZXJuZWwgaXMg
dGhlIHNvdXJjZSBvZiB0cnV0aCkNCiAgIC0gRm9yIGEgdHJhY2luZyBicGYgcHJvZ3JhbSwgaWYg
dGhhdCBmdW5jdGlvbiBldmVudHVhbGx5DQogICAgIGNvcHkgIGhlbHBlcg0KICAgICAgICAgYnBm
X3NrYl9ldmVudF9vdXRwdXQoLi4uLCBza2IsIC4uLikNCiAgICAgdGhlIHZlcmlmaWVyIG5lZWRz
IHRvIHZlcmlmeSBza2IgaXMgaW5kZWVkIGEgdmFsaWQgc2tiDQogICAgIGJ5IHRyYWNpbmcgYmFj
ayB0byBvbmUgb2YgcGFyYW1ldGVycy4NCg0KICAgICBIZXJlLCBJIHVzZSBza2IgYXMgYW4gZXhh
bXBsZSwgbWF5YmUgaXQgY2FuIGJlIGV4dGVuZGVkDQogICAgIHRvIG90aGVyIGRhdGEgc3RydWN0
dXJlcyBhcyB3ZWxsLg0KDQpXaXRoIHRoaXMgYXBwcm9hY2gsIHlvdSBjYW4gcmV1c2Ugc29tZSBv
ZiBmdW5jdGlvbnMgZnJvbQ0KdHJhY2luZyBzaWRlIHRvIGRlYWwgd2l0aCBmcmFnIGNvcHlpbmcg
YW5kIG5vIGJwZl9wcm9iZV9yZWFkKCkNCmlzIG5lZWRlZC4NCg0KSGVyZSwgSSB1c2Ugc2tiIGFz
IGFuIGV4YW1wbGUsIG1heWJlIGl0IGNhbiBiZSBleHRlbmRlZA0KdG8gb3RoZXIgZGF0YSBzdHJ1
Y3R1cmVzIGFzIHdlbGwgaWYgbmVlZGVkLg0KDQo+Pg0KPj4gSWYgd2UgaW5kZWVkIGRvIG5vdCBu
ZWVkIHRvIGhhbmRsZSBmcmFncyBoZXJlLCBJIHRoaW5rIG1heWJlDQo+PiBicGZfcHJvYmVfcmVh
ZCgpIGluIGV4aXN0aW5nIGJwZiBrcHJvYmUgZnVuY3Rpb24gc2hvdWxkIGJlDQo+PiBlbm91Z2gs
IHdlIGRvIG5vdCBuZWVkIHRoaXMgaGVscGVyPw0KPj4NCj4gDQo+IENlcnRhaW5seSBmb3IgbWFu
eSB1c2UgY2FzZXMsIHRoYXQgd2lsbCBnZXQgeW91IG1vc3Qgb2Ygd2hhdCB5b3UgbmVlZCAtDQo+
IHBhcnRpY3VsYXJseSBpZiB5b3UncmUganVzdCBsb29raW5nIGF0IEwyIHRvIEw0IGRhdGEuIEZv
ciBmdWxsIHBhY2tldA0KPiBjYXB0dXJlIGhvd2V2ZXIgSSB0aGluayB3ZSBtYXkgbmVlZCB0byB0
aGluayBhYm91dCBmcmFnbWVudCB0cmF2ZXJzYWwuDQo+IA0KPj4+ICsNCj4+PiArLyogRGVyaXZl
IHByb3RvY29sIGZvciBzb21lIG9mIHRoZSBlYXNpZXIgY2FzZXMuICBGb3IgdHJhY2luZywgYSBw
cm9iZSBwb2ludA0KPj4+ICsgKiBtYXkgYmUgZGVhbGluZyB3aXRoIHBhY2tldHMgaW4gdmFyaW91
cyBzdGF0ZXMuIENvbW1vbiBjYXNlcyBhcmUgSVANCj4+PiArICogcGFja2V0cyBwcmlvciB0byBh
ZGRpbmcgTUFDIGhlYWRlciAoX1BDQVBfVFlQRV9JUCkgYW5kIGEgZnVsbCBwYWNrZXQNCj4+PiAr
ICogKF9QQ0FQX1RZUEVfRVRIKS4gIEZvciBvdGhlciBjYXNlcyB0aGUgY2FsbGVyIG11c3Qgc3Bl
Y2lmeSB0aGUNCj4+PiArICogcHJvdG9jb2wgdGhleSBleHBlY3QuICBPdGhlciBoZXVyaXN0aWNz
IGZvciBwYWNrZXQgaWRlbnRpZmljYXRpb24NCj4+PiArICogc2hvdWxkIGJlIGFkZGVkIGhlcmUg
YXMgbmVlZGVkLCBzaW5jZSBkZXRlcm1pbmluZyB0aGUgcGFja2V0IHR5cGUNCj4+PiArICogZW5z
dXJlcyB3ZSBkbyBub3QgY2FwdHVyZSBwYWNrZXRzIHRoYXQgZmFpbCB0byBtYXRjaCB0aGUgZGVz
aXJlZA0KPj4+ICsgKiBwY2FwIHR5cGUgaW4gQlBGX0ZfUENBUF9TVFJJQ1RfVFlQRSBtb2RlLg0K
Pj4+ICsgKi8NCj4+PiArc3RhdGljIGlubGluZSBpbnQgYnBmX3NrYl9wcm90b2NvbF9nZXQoc3Ry
dWN0IHNrX2J1ZmYgKnNrYikNCj4+PiArew0KPj4+ICsJc3dpdGNoIChodG9ucyhza2ItPnByb3Rv
Y29sKSkgew0KPj4+ICsJY2FzZSBFVEhfUF9JUDoNCj4+PiArCWNhc2UgRVRIX1BfSVBWNjoNCj4+
PiArCQlpZiAoc2tiX25ldHdvcmtfaGVhZGVyKHNrYikgPT0gc2tiLT5kYXRhKQ0KPj4+ICsJCQly
ZXR1cm4gQlBGX1BDQVBfVFlQRV9JUDsNCj4+PiArCQllbHNlDQo+Pj4gKwkJCXJldHVybiBCUEZf
UENBUF9UWVBFX0VUSDsNCj4+PiArCWRlZmF1bHQ6DQo+Pj4gKwkJcmV0dXJuIEJQRl9QQ0FQX1RZ
UEVfVU5TRVQ7DQo+Pj4gKwl9DQo+Pj4gK30NCj4+PiArDQo+Pj4gK0JQRl9DQUxMXzUoYnBmX3Ry
YWNlX3BjYXAsIHZvaWQgKiwgZGF0YSwgdTMyLCBzaXplLCBzdHJ1Y3QgYnBmX21hcCAqLCBtYXAs
DQo+Pj4gKwkgICBpbnQsIHByb3RvY29sX3dhbnRlZCwgdTY0LCBmbGFncykNCj4+DQo+PiBVcCB0
byBub3csIGZvciBoZWxwZXJzLCB2ZXJpZmllciBoYXMgYSB3YXkgdG8gdmVyaWZpZXIgaXQgaXMg
dXNlZA0KPj4gcHJvcGVybHkgcmVnYXJkaW5nIHRvIHRoZSBjb250ZXh0LiBGb3IgZXhhbXBsZSwg
Zm9yIHhkcCB2ZXJzaW9uDQo+PiBwZXJmX2V2ZW50X291dHB1dCwgdGhlIGhlbHAgcHJvdG90eXBl
LA0KPj4gICAgIEJQRl9DQUxMXzUoYnBmX3hkcF9ldmVudF9vdXRwdXQsIHN0cnVjdCB4ZHBfYnVm
ZiAqLCB4ZHAsIHN0cnVjdA0KPj4gYnBmX21hcCAqLCBtYXAsDQo+PiAgICAgICAgICAgICAgdTY0
LCBmbGFncywgdm9pZCAqLCBtZXRhLCB1NjQsIG1ldGFfc2l6ZSkNCj4+IHRoZSB2ZXJpZmllciBp
cyBhYmxlIHRvIGd1YXJhbnRlZSB0aGF0IHRoZSBmaXJzdCBwYXJhbWV0ZXINCj4+IGhhcyBjb3Jy
ZWN0IHR5cGUgeGRwX2J1ZmYsIG5vdCBzb21ldGhpbmcgZnJvbSB0eXBlIGNhc3QuDQo+PiAgICAg
LmFyZzFfdHlwZSAgICAgID0gQVJHX1BUUl9UT19DVFgsDQo+Pg0KPj4gVGhpcyBoZWxwZXIsIGlu
IHRoZSBiZWxvdyB3ZSBoYXZlDQo+PiAgICAgLmFyZzFfdHlwZQk9IEFSR19BTllUSElORywNCj4+
DQo+PiBTbyBpdCBpcyBub3QgcmVhbGx5IGVuZm9yY2VkLiBCcmluZ2luZyBCVEYgY2FuIGhlbHAs
IGJ1dCB0eXBlDQo+PiBuYW1lIG1hdGNoaW5nIHR5cGljYWxseSBiYWQuDQo+Pg0KPj4NCj4gT25l
IHRoaW5nIHdlIHdlcmUgZGlzY3Vzc2luZyAtIGFuZCBJIHRoaW5rIHRoaXMgaXMgc2ltaWxhciB0
byB3aGF0DQo+IHlvdSdyZSBzdWdnZXN0aW5nIC0gaXMgdG8gaW52ZXN0aWdhdGUgaWYgdGhlcmUg
bWlnaHQgYmUgYSB3YXkgdG8NCj4gbGV2ZXJhZ2UgQlRGIHRvIHByb3ZpZGUgYWRkaXRpb25hbCBn
dWFyYW50ZWVzIHRoYXQgdGhlIHRyYWNpbmcNCj4gZGF0YSB3ZSBhcmUgaGFuZGxpbmcgaXMgaW5k
ZWVkIGFuIHNrYi4gIFNwZWNpZmljYWxseSBpZiB3ZQ0KPiB0cmFjZSBhIGtwcm9iZSBmdW5jdGlv
biBhcmd1bWVudCBvciBhIHRyYWNlcG9pbnQgZnVuY3Rpb24sIGFuZA0KPiBpZiB3ZSBoYWQgdGhh
dCBndWFyYW50ZWUsIHdlIGNvdWxkIHBlcmhhcHMgaW52b2tlIHRoZSBza2Itc3R5bGUNCj4gcGVy
ZiBldmVudCBvdXRwdXQgZnVuY3Rpb24gKHRyYWNlIGJvdGggdGhlIHNrYiBkYXRhIGFuZCB0aGUg
bWV0YWRhdGEpLg0KPiBUaGUgY2hhbGxlbmdlIHdvdWxkIGJlIGhvdyB0byBkbyB0aGF0IHR5cGUt
YmFzZWQgbWF0Y2hpbmc7IHdlJ2QNCj4gbmVlZCB0aGUgZnVuY3Rpb24gYXJndW1lbnQgaW5mb3Jt
YXRpb24gZnJvbSBCVEYgX2FuZF8gbmVlZCB0bw0KPiBzb21laG93IGFzc29jaWF0ZSBpdCBhdCBw
cm9iZSBhdHRhY2ggdGltZS4NCj4gDQo+IFRoYW5rcyBhZ2FpbiBmb3IgbG9va2luZyBhdCB0aGUg
Y29kZSENCj4gDQo+IEFsYW4NCj4gDQo=
