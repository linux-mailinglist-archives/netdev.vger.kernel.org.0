Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 032AAF3653
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 18:55:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389656AbfKGRy6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 12:54:58 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:51586 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387473AbfKGRy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 12:54:57 -0500
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xA7HsXlP023518;
        Thu, 7 Nov 2019 09:54:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8MYWWLM2tRnLtp807ddEOHTm2qmQkiaAHswv6rFww8c=;
 b=G0SiRkWRJjMvXRGV4h33VUN0skfA5qvCzG/YJP59tbaSe0img6qFbs56kAOmtWket9qQ
 KnCL25EUYK6+iNioBopXdYgN7orKdQJ4hAAtQDUQcXxT2uB9SOk3b3g8yyJbw7yEk4sT
 yRLPdTwletmkOY0XTvqEaZVcOP8oIXhJdQg= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2w41w6pes8-12
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 07 Nov 2019 09:54:42 -0800
Received: from ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) by
 ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 09:54:39 -0800
Received: from ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) by
 ash-exopmbx201.TheFacebook.com (2620:10d:c0a8:83::8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Thu, 7 Nov 2019 09:54:39 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Thu, 7 Nov 2019 09:54:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f9ZKYQ689OjXcc2JC+WcpQopAcF1veCkIxPzp8VX3y///JCxNGp8Al/eMIoNfDJeuw105bIxDSFXE5egE0Y//zk1JHP5FJO6PxziAfgkdCKs/ar+KqirXN0ZQVjE6WK2GxGCf44uP32slKjGBbiLxiaadZMAEcVYLHBiSxVtb1l7FIv1eh09m28httA1W0RSkd+fmBQVLrgvfetjvfRjTZNmV1stSp0YiyGZg7jROpmcVJXWmHpi9u4CxQT/LR+f8sfjjVjw8g9/4Bm+uva2I/RiAOJPqXz1PQ5G2ozuM+O+eZbS00zokGTOGvt7LqyofcU4xMVvcLlCGIQc+HgPxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MYWWLM2tRnLtp807ddEOHTm2qmQkiaAHswv6rFww8c=;
 b=iQ3YmvuMfgGGiLR1u1QE0viMTtjrr+Q7U0HzEAmcnRjXQ1LxRkQgqFg9wXDH6ws+mKtmFk6x7o/Wvr/lPo4sJyCy10R5dJMgh/L3E+OyadTMfBOrJCJgA+N/AmWlVEhGv6NqiIZ5Fmz+hR5W7GBcshgdSzOhulXyS6Lc/RKolo6VRrYjIcn9SzFBdQACKyCuuGNSeUxOcOyIukDerz8NvA6Z7rYBcn1t3m/huoxHoqPE7Q+nO9DV4Mbm5J590+GOfgs8SGFlg2LV1Mth5TQRyf+KWM9YntUn0JmhwvaVJsHhAHULBIVVgWPDdxZ6tSLIyqu0391p8fHhZrtjNPssRw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8MYWWLM2tRnLtp807ddEOHTm2qmQkiaAHswv6rFww8c=;
 b=bp3eS+9SJGlosoFWGfWSKNvCvN1U+MxbrzXenXlOw+Nc9m2UMcOJUt4BbtLeSXdvUhvMy6Vj1imyKVvGHMySc6Yko8wuHcJwfGWbJ5CHBlas01KTChXqMj3+jir2NJ/hd/aV0hGddC3w/TT2gQWeTmiZkYH++Gft2RqhNUvI5bQ=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2360.namprd15.prod.outlook.com (52.135.192.142) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Thu, 7 Nov 2019 17:54:37 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::e864:c934:8b54:4a40%5]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 17:54:37 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Song Liu <songliubraving@fb.com>
CC:     Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
Thread-Topic: [PATCH v2 bpf-next 02/17] bpf: Add bpf_arch_text_poke() helper
Thread-Index: AQHVlS7DbHhPP6g7dEW8w7I0rHiiDKd/9O2AgAAIcICAAAEagA==
Date:   Thu, 7 Nov 2019 17:54:37 +0000
Message-ID: <71d8650d-10a3-af18-dd3d-3e8d63d48bbd@fb.com>
References: <20191107054644.1285697-1-ast@kernel.org>
 <20191107054644.1285697-3-ast@kernel.org>
 <EE50EB7D-8FB0-4D37-A3F1-3439981A6141@fb.com>
 <CAADnVQJsnVmTNxj1QbEbHCsvyvL348R08cZ6ChZK8EGnpc2BfQ@mail.gmail.com>
In-Reply-To: <CAADnVQJsnVmTNxj1QbEbHCsvyvL348R08cZ6ChZK8EGnpc2BfQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR15CA0043.namprd15.prod.outlook.com
 (2603:10b6:300:ad::29) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::2:d046]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ddd40d56-4e75-4132-e182-08d763ab8e5f
x-ms-traffictypediagnostic: BYAPR15MB2360:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB236037FBF396F1B2D4C5C115D7780@BYAPR15MB2360.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:419;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(39860400002)(376002)(346002)(199004)(189003)(25786009)(6486002)(14454004)(66446008)(99286004)(229853002)(66946007)(66556008)(64756008)(66476007)(110136005)(31686004)(6512007)(486006)(2616005)(11346002)(476003)(478600001)(256004)(14444005)(316002)(46003)(446003)(31696002)(36756003)(4326008)(6246003)(8676002)(102836004)(386003)(6506007)(53546011)(81166006)(5660300002)(8936002)(186003)(81156014)(76176011)(52116002)(2906002)(6636002)(6436002)(71190400001)(7736002)(305945005)(86362001)(6116002)(71200400001)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2360;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: MUSuvtbU0Sp5YuGLHs75Kbq5g85PTcNtpOYZd4zNhiHon+yNuSWHXY3XiKm9A76Ln+mt8Gg5aJOs6RQGlFO2ugiz4xjVoMmQMyWmq9KM1qpX6jk7gAKIcfHBFchwbL0UvlvPXFydfCQUayU4woc1u05wgyJ4nUbdZwD6kgrFIhQNWMfrmDpbIKMtAB2+6XWpCaHt6LUXGoHrdZGUDnEQkPPZt1dEJbHVG5kC0gdUcl6kEOoZxFkDLg/3ibhB+XsA6ojYUu27/ih3QROLYwtBNNF20v8EMY5bX/CjR2bqQd4MHzyR0rtz6zBNwepe0m8ngYXf7w0OCUmjpHf2avztRSpHzLJ146kmmFb4CHdEpbxbxSPNMbMpjRsCGNqqT4uaXTi9LB5apPxZmhn6xu42aWcaCWS2S0Dnbns1W40TTq+aqbUw/eBD4dPe8ISkNpg6
Content-Type: text/plain; charset="utf-8"
Content-ID: <765B2C379CD905489CA8E9E62C627E23@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: ddd40d56-4e75-4132-e182-08d763ab8e5f
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 17:54:37.6479
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Bncxlkn3pjs4+Yoj1EbxYoqJqVbstLxH/rkWbB7t+TRBjVE12lDW/Ygwm8W5gfLi
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2360
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-07_05:2019-11-07,2019-11-07 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0
 lowpriorityscore=0 phishscore=0 mlxscore=0 adultscore=0 clxscore=1015
 mlxlogscore=999 suspectscore=0 impostorscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1911070167
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvNy8xOSA5OjUwIEFNLCBBbGV4ZWkgU3Rhcm92b2l0b3Ygd3JvdGU6DQo+IE9uIFRodSwg
Tm92IDcsIDIwMTkgYXQgOToyMCBBTSBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPiB3
cm90ZToNCj4+DQo+Pg0KPj4NCj4+PiBPbiBOb3YgNiwgMjAxOSwgYXQgOTo0NiBQTSwgQWxleGVp
IFN0YXJvdm9pdG92IDxhc3RAa2VybmVsLm9yZz4gd3JvdGU6DQo+Pj4NCj4+PiBBZGQgYnBmX2Fy
Y2hfdGV4dF9wb2tlKCkgaGVscGVyIHRoYXQgaXMgdXNlZCBieSBCUEYgdHJhbXBvbGluZSBsb2dp
YyB0byBwYXRjaA0KPj4+IG5vcHMvY2FsbHMgaW4ga2VybmVsIHRleHQgaW50byBjYWxscyBpbnRv
IEJQRiB0cmFtcG9saW5lIGFuZCB0byBwYXRjaA0KPj4+IGNhbGxzL25vcHMgaW5zaWRlIEJQRiBw
cm9ncmFtcyB0b28uDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBBbGV4ZWkgU3Rhcm92b2l0b3Yg
PGFzdEBrZXJuZWwub3JnPg0KPj4+IC0tLQ0KPj4+IGFyY2gveDg2L25ldC9icGZfaml0X2NvbXAu
YyB8IDUxICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiBpbmNsdWRl
L2xpbnV4L2JwZi5oICAgICAgICAgfCAgOCArKysrKysNCj4+PiBrZXJuZWwvYnBmL2NvcmUuYyAg
ICAgICAgICAgfCAgNiArKysrKw0KPj4+IDMgZmlsZXMgY2hhbmdlZCwgNjUgaW5zZXJ0aW9ucygr
KQ0KPj4+DQo+Pj4gZGlmZiAtLWdpdCBhL2FyY2gveDg2L25ldC9icGZfaml0X2NvbXAuYyBiL2Fy
Y2gveDg2L25ldC9icGZfaml0X2NvbXAuYw0KPj4+IGluZGV4IDAzOTliMWY4M2MyMy4uODYzMWQz
YmQ2MzdmIDEwMDY0NA0KPj4+IC0tLSBhL2FyY2gveDg2L25ldC9icGZfaml0X2NvbXAuYw0KPj4+
ICsrKyBiL2FyY2gveDg2L25ldC9icGZfaml0X2NvbXAuYw0KPj4+IEBAIC05LDkgKzksMTEgQEAN
Cj4+PiAjaW5jbHVkZSA8bGludXgvZmlsdGVyLmg+DQo+Pj4gI2luY2x1ZGUgPGxpbnV4L2lmX3Zs
YW4uaD4NCj4+PiAjaW5jbHVkZSA8bGludXgvYnBmLmg+DQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9t
ZW1vcnkuaD4NCj4+PiAjaW5jbHVkZSA8YXNtL2V4dGFibGUuaD4NCj4+PiAjaW5jbHVkZSA8YXNt
L3NldF9tZW1vcnkuaD4NCj4+PiAjaW5jbHVkZSA8YXNtL25vc3BlYy1icmFuY2guaD4NCj4+PiAr
I2luY2x1ZGUgPGFzbS90ZXh0LXBhdGNoaW5nLmg+DQo+Pj4NCj4+PiBzdGF0aWMgdTggKmVtaXRf
Y29kZSh1OCAqcHRyLCB1MzIgYnl0ZXMsIHVuc2lnbmVkIGludCBsZW4pDQo+Pj4gew0KPj4+IEBA
IC00ODcsNiArNDg5LDU1IEBAIHN0YXRpYyBpbnQgZW1pdF9jYWxsKHU4ICoqcHByb2csIHZvaWQg
KmZ1bmMsIHZvaWQgKmlwKQ0KPj4+ICAgICAgICByZXR1cm4gMDsNCj4+PiB9DQo+Pj4NCj4+PiAr
aW50IGJwZl9hcmNoX3RleHRfcG9rZSh2b2lkICppcCwgZW51bSBicGZfdGV4dF9wb2tlX3R5cGUg
dCwNCj4+PiArICAgICAgICAgICAgICAgICAgICB2b2lkICpvbGRfYWRkciwgdm9pZCAqbmV3X2Fk
ZHIpDQo+Pj4gK3sNCj4+PiArICAgICB1OCBvbGRfaW5zbltOT1BfQVRPTUlDNV0gPSB7fTsNCj4+
PiArICAgICB1OCBuZXdfaW5zbltOT1BfQVRPTUlDNV0gPSB7fTsNCj4+PiArICAgICB1OCAqcHJv
ZzsNCj4+PiArICAgICBpbnQgcmV0Ow0KPj4+ICsNCj4+PiArICAgICBpZiAoIWlzX2tlcm5lbF90
ZXh0KChsb25nKWlwKSkNCj4+PiArICAgICAgICAgICAgIC8qIEJQRiB0cmFtcG9saW5lIGluIG1v
ZHVsZXMgaXMgbm90IHN1cHBvcnRlZCAqLw0KPj4+ICsgICAgICAgICAgICAgcmV0dXJuIC1FSU5W
QUw7DQo+Pj4gKw0KPj4+ICsgICAgIGlmIChvbGRfYWRkcikgew0KPj4+ICsgICAgICAgICAgICAg
cHJvZyA9IG9sZF9pbnNuOw0KPj4+ICsgICAgICAgICAgICAgcmV0ID0gZW1pdF9jYWxsKCZwcm9n
LCBvbGRfYWRkciwgKHZvaWQgKilpcCk7DQo+Pj4gKyAgICAgICAgICAgICBpZiAocmV0KQ0KPj4+
ICsgICAgICAgICAgICAgICAgICAgICByZXR1cm4gcmV0Ow0KPj4+ICsgICAgIH0NCj4+PiArICAg
ICBpZiAob2xkX2FkZHIpIHsNCj4+ICAgICAgICAgICAgICAgICAgXiBzaG91bGQgYmUgbmV3X2Fk
ZHI/DQo+Pj4gKyAgICAgICAgICAgICBwcm9nID0gbmV3X2luc247DQo+Pj4gKyAgICAgICAgICAg
ICByZXQgPSBlbWl0X2NhbGwoJnByb2csIG9sZF9hZGRyLCAodm9pZCAqKWlwKTsNCj4+ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXl5eIGFuZCBoZXJlPw0KPj4+ICsg
ICAgICAgICAgICAgaWYgKHJldCkNCj4+PiArICAgICAgICAgICAgICAgICAgICAgcmV0dXJuIHJl
dDsNCj4+PiArICAgICB9DQo+Pj4gKyAgICAgcmV0ID0gLUVCVVNZOw0KPj4+ICsgICAgIG11dGV4
X2xvY2soJnRleHRfbXV0ZXgpOw0KPj4+ICsgICAgIHN3aXRjaCAodCkgew0KPj4+ICsgICAgIGNh
c2UgQlBGX01PRF9OT1BfVE9fQ0FMTDoNCj4+PiArICAgICAgICAgICAgIGlmIChtZW1jbXAoaXAs
IGlkZWFsX25vcHMsIDUpKQ0KPj4NCj4+IE1heWJlIHVzZSBYODZfQ0FMTF9TSVpFIGluc3RlYWQg
b2YgNT8gQW5kIHRoZSBmaXZlIG1vcmUgIjUiIGJlbG93Pw0KPiANCj4gb2hoLiB5ZXMuIG9mIGNv
dXJzZS4gSSBoYWQgaXQgZml4ZWQuDQo+IE5PUF9BVE9NSUM1IGFib3ZlIGlzIGluY29ycmVjdCBh
cyB3ZWxsLiBJIGhhZCBpdCBmaXhlZCB0b28uDQo+IExvb2tzIGxpa2UgSSd2ZSBsb3N0IGFub3Ro
ZXIgc3F1YXNoIGNvbW1pdCBsYXN0IG5pZ2h0Lg0KPiBTb3JyeSBhYm91dCB0aGF0Lg0KDQpBcmdo
LiBOb3cgSSBzZWUgd2hhdCBoYXBwZW5lZC4NCkkgc3F1YXNoZWQgaXQgaW50byBwYXRjaCAzIGlu
c3RlYWQgb2YgcGF0Y2ggMi4gc29ycnkuDQo=
