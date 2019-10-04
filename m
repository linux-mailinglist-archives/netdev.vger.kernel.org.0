Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2718DCC3D5
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 21:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbfJDT5Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 15:57:16 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:16908 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729079AbfJDT5Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 15:57:16 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x94JoYVJ014188;
        Fri, 4 Oct 2019 12:56:14 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=XHZ5J2gffM78lHbHJkeEuckp2/KCaRCGYJ5KnasUCJY=;
 b=a5SqP2v3i2SG4rpCSKqiVUd3hSwUWjxDqA1osj4ASxo6Nw41r/AWechAvgXTqKpyZOjQ
 Ic6X9ZOjq9NZIU/sTBfk/s+sBbmla2MtDTTaaLz6SD0oEEuwTZDsTXyocPKDLRh55+Il
 mNm0XJLhVOMR+dFDqissY5146wz0gJtb+cI= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2vdjyypnsj-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 04 Oct 2019 12:56:14 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 4 Oct 2019 12:56:06 -0700
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 4 Oct 2019 12:56:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WARELyY9UraqRuGuomT4O/XhEjl/whGAMTqo69c8o7KgCgHk4xarKDlY8cP5xqLoYVJwGI+u+6/0fuoZVdjOzCvEJs4KtKtf9TwvxpBM08fRTkzqtenpzUGOXZX7Bqp15Hg6TpVVBFAqMq2KQtsun4q0k0Tgw1+wStNfICg/JxTvjOI27nAVybbdimnoezqZwLrbWy355xKjx26MlfeMRC5xhyvK2qFDOtLQDQATw7odrrssUj4HX16payjYJQeB5zArjd+ekBL4j0ASatV9C3Sdpbih/nJ6YVi8/Um2k+WuRACmZUi2utr+Kjw474d8SU+crAj5TSBVS//Q6mxfjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHZ5J2gffM78lHbHJkeEuckp2/KCaRCGYJ5KnasUCJY=;
 b=FUbXvbdOXBAS6GhDHA9MNCwO94iE8HkuiB3qnOGFpRqH9LCJV6lt94cxFvSHx47vg2pKrCKPN9JlzA4jrwq2ukDTPJAVPhOesxU9XP2y/zJNz2rK4R3yjQOdLt6D82RdlGLuQ60VmnPJ9OmOpWTS2lVhWGW8tnJuib7g4hQy/K39dBm5LqQU4FLt6li+Yf7gSWc8AsMwZiV3yzwyatQZ6R3O7/UDjLEx2CqAUa/1gE6e+2fVOBGeBi2li0r+bq9cjb5NIkZ/6BYZnE3pHKa6B4pDw5jgdnFTrsjjEmTE0QZ1in4ZAY0Gbda+rcxKPQm2ZH+oNi8Cz9ZxlBtNSsV/qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XHZ5J2gffM78lHbHJkeEuckp2/KCaRCGYJ5KnasUCJY=;
 b=dZtmbQPzA0LzyG6xkXC6eSRdYG/4k3iCwMJMckTiirdpDhWTcYjGGSIWbvXyALQDxn0jED3BuhRnKUjh9x67M+BDHeQw68S5zAMh9+k7EkETdeWWRyU9nJdLQsM667YIToA2biEhi2m2Gh23a9CK1pR1lrXo0EhCN0TJzllifbY=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB3367.namprd15.prod.outlook.com (20.179.56.220) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.18; Fri, 4 Oct 2019 19:56:04 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2305.023; Fri, 4 Oct 2019
 19:56:04 +0000
From:   Alexei Starovoitov <ast@fb.com>
To:     Steven Rostedt <rostedt@goodmis.org>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
CC:     Kees Cook <keescook@chromium.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Andy Lutomirski <luto@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "LSM List" <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: trace_printk issue. Was: [PATCH bpf-next] bpf, capabilities:
 introduce CAP_BPF
Thread-Topic: trace_printk issue. Was: [PATCH bpf-next] bpf, capabilities:
 introduce CAP_BPF
Thread-Index: AQHVXRmQqSOzyqrm4ECmsLsG3CKso6cPnGwAgAAaLYCAAAXUgIAAP7UAgAAYzoCAARgsgIAAHuKAgAA4VQCAMGzZgIACzy2AgABy1ACAAVzMAIAAAg8AgAAIL4CAATZYgIAAX5qAgAEiEwCAAAZ2AIAByJmA
Date:   Fri, 4 Oct 2019 19:56:04 +0000
Message-ID: <36f0efac-d6b6-9439-d4c6-361d84cb3429@fb.com>
References: <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home> <201909301129.5A1129C@keescook>
 <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
 <20191001181052.43c9fabb@gandalf.local.home>
 <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
 <20191001184731.0ec98c7a@gandalf.local.home>
 <a98725c6-a7db-1d9f-7033-5ecd96438c8d@fb.com>
 <20191002190027.4e204ea8@gandalf.local.home>
 <20191003161838.7lz746aa2lzl7qi4@ast-mbp.dhcp.thefacebook.com>
 <20191003124148.4b94a720@gandalf.local.home>
In-Reply-To: <20191003124148.4b94a720@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0056.namprd08.prod.outlook.com
 (2603:10b6:300:c0::30) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::1:2b76]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 894ea12c-c37b-44f6-9603-08d74904e3a1
x-ms-traffictypediagnostic: BYAPR15MB3367:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB33671606A6C1CFFFC1789BDFD79E0@BYAPR15MB3367.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 018093A9B5
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(136003)(366004)(39860400002)(376002)(199004)(189003)(14454004)(25786009)(478600001)(86362001)(316002)(53546011)(229853002)(6436002)(6246003)(6116002)(5660300002)(6512007)(36756003)(256004)(81166006)(81156014)(8676002)(8936002)(2906002)(6486002)(6506007)(31686004)(305945005)(99286004)(52116002)(186003)(46003)(66946007)(64756008)(110136005)(4326008)(66476007)(66556008)(7736002)(66446008)(7416002)(31696002)(54906003)(71190400001)(486006)(14444005)(71200400001)(446003)(11346002)(2616005)(476003)(76176011)(386003)(102836004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3367;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uOP36EN9IbAlaesXbwl7Yaqy4HVPBAjmwOnkh8NI2FHLEP/t8MQhQToEPL+mEabjINMAaT9oq44o9ANdh9tNeGGEZFmjXdLK85LQRNus29l30/9SIbE9yCRgYJl3BxhLsdPYWXPxnYA5Aks/ocW+uhkz1ljIP/JthlsO/EvF93ktJq1BVdFuIr4Kkfr/EpRRypEHKqECxYPU/HfRaf2xFztYBNVcbK/hMIQcYnOsNSrNG00uFxSEdnhd3MaEPoqLm6FxR0B8RCahw6YAkOD3IZkTCgcBwoV6jMnwaXtdpplK01XIsvhdYiJA2Gfr29UxhBlNyKlqIT2YPUBgoYdCoPlX2EgIXVNt20APOz5adhJlEgT9g93xcOH9b9WfN/5td0t42dAR9b5+KweR2enXXkZOUcb9LOXWjCrNImwYWyI=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7F8F31F328B1684A9E3CD6F78B415287@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 894ea12c-c37b-44f6-9603-08d74904e3a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2019 19:56:04.6867
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vcOFDCx9IPJnZvPWqNOYI3HmMbOm/relCEsahnOw+l08EgF2AMwVrACKd//olrWG
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3367
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-04_12:2019-10-03,2019-10-04 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=999
 impostorscore=0 mlxscore=0 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 bulkscore=0 suspectscore=0
 malwarescore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910040163
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMy8xOSA5OjQxIEFNLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToNCj4gT24gVGh1LCAzIE9j
dCAyMDE5IDA5OjE4OjQwIC0wNzAwDQo+IEFsZXhlaSBTdGFyb3ZvaXRvdiA8YWxleGVpLnN0YXJv
dm9pdG92QGdtYWlsLmNvbT4gd3JvdGU6DQo+IA0KPj4gSSB0aGluayBkcm9wcGluZyBsYXN0IGV2
ZW50cyBpcyBqdXN0IGFzIGJhZC4gSXMgdGhlcmUgYSBtb2RlIHRvIG92ZXJ3cml0ZSBvbGQNCj4+
IGFuZCBrZWVwIHRoZSBsYXN0IE4gKGxpa2UgcGVyZiBkb2VzKSA/DQo+IA0KPiBXZWxsLCBpdCBk
cm9wcyBpdCBieSBwYWdlcy4gVGh1cyB5b3Ugc2hvdWxkIGFsd2F5cyBoYXZlIHRoZSBsYXN0IHBh
Z2UNCj4gb2YgZXZlbnRzLg0KPiANCj4+IFBldGVyIFd1IGJyb3VnaHQgdGhpcyBpc3N1ZSB0byBt
eSBhdHRlbnRpb24gaW4NCj4+IGNvbW1pdCA1NWMzM2RmYmViODMgKCJicGY6IGNsYXJpZnkgd2hl
biBicGZfdHJhY2VfcHJpbnRrIGRpc2NhcmRzIGxpbmVzIikuDQo+PiBBbmQgbGF0ZXIgc2VudCBz
aW1pbGFyIGRvYyBmaXggdG8gZnRyYWNlLnJzdC4NCj4gDQo+IEl0IHdhcyBkb2N1bWVudGVkIHRo
ZXJlLCBoZSBqdXN0IGVsYWJvcmF0ZWQgb24gaXQgbW9yZToNCj4gDQo+ICAgICAgICAgIFRoaXMg
ZmlsZSBob2xkcyB0aGUgb3V0cHV0IG9mIHRoZSB0cmFjZSBpbiBhIGh1bWFuDQo+ICAgICAgICAg
IHJlYWRhYmxlIGZvcm1hdCAoZGVzY3JpYmVkIGJlbG93KS4gTm90ZSwgdHJhY2luZyBpcyB0ZW1w
b3JhcmlseQ0KPiAtICAgICAgIGRpc2FibGVkIHdoaWxlIHRoaXMgZmlsZSBpcyBiZWluZyByZWFk
IChvcGVuZWQpLg0KPiArICAgICAgIGRpc2FibGVkIHdoZW4gdGhlIGZpbGUgaXMgb3BlbiBmb3Ig
cmVhZGluZy4gT25jZSBhbGwgcmVhZGVycw0KPiArICAgICAgIGFyZSBjbG9zZWQsIHRyYWNpbmcg
aXMgcmUtZW5hYmxlZC4NCj4gDQo+IA0KPj4gVG8gYmUgaG9uZXN0IGlmIEkga25ldyBvZiB0aGlz
IHRyYWNlX3ByaW50ayBxdWlyayBJIHdvdWxkIG5vdCBoYXZlIHBpY2tlZCBpdA0KPj4gYXMgYSBk
ZWJ1Z2dpbmcgbWVjaGFuaXNtIGZvciBicGYuDQo+PiBJIHVyZ2UgeW91IHRvIGZpeCBpdC4NCj4g
DQo+IEl0J3Mgbm90IGEgdHJpdmlhbCBmaXggYnkgZmFyLg0KPiANCj4gTm90ZSwgdHJ5aW5nIHRv
IHJlYWQgdGhlIHRyYWNlIGZpbGUgd2l0aG91dCBkaXNhYmxpbmcgdGhlIHdyaXRlcyB0byBpdCwN
Cj4gd2lsbCBtb3N0IGxpa2VseSBtYWtlIHJlYWRpbmcgaXQgd2hlbiBmdW5jdGlvbiB0cmFjaW5n
IGVuYWJsZWQgdG90YWxseQ0KPiBnYXJiYWdlLCBhcyB0aGUgYnVmZmVyIHdpbGwgbW9zdCBsaWtl
bHkgYmUgZmlsbGVkIGZvciBldmVyeSByZWFkIGV2ZW50Lg0KPiBUaGF0IGlzLCBlYWNoIHJlYWQg
ZXZlbnQgd2lsbCBub3QgYmUgcmVsYXRlZCB0byB0aGUgbmV4dCBldmVudCB0aGF0IGlzDQo+IHJl
YWQsIG1ha2luZyBpdCB2ZXJ5IGNvbmZ1c2luZy4NCj4gDQo+IEFsdGhvdWdoLCBJIG1heSBiZSBh
YmxlIHRvIG1ha2UgaXQgd29yayBwZXIgcGFnZS4gVGhhdCB3YXkgeW91IGdldCBhdA0KPiBsZWFz
dCBhIHBhZ2Ugd29ydGggb2YgZXZlbnRzLg0KDQpUaGF0IHNvdW5kcyBtdWNoIGJldHRlci4gQXMg
bG9uZyBhcyB0cmFjZV9wcmludGsoKSBkb2Vzbid0IGRpc2FwcGVhcg0KaW50byB0aGUgdm9pZCwg
aXQncyBnb29kLg0KDQpCdXQgdGhlIHBhcnQgSSdtIG5vdCBnZXR0aW5nIGlzIHdoeSB0cmFjZV9w
cmludGsoKSBoYXMNCmlmICh0cmFjaW5nX2Rpc2FibGVkKSBnb3RvIG91dDsNCg0KSXQncyBhIGNv
bmN1cnJlbnQgcmluZyBidWZmZXIuIE9uZSBjcHUgY2FuIHdyaXRlIGludG8gaXQgd2hpbGUNCmFu
b3RoZXIgcmVhZGluZy4gV2hhdCBpcyB0aGUgcG9pbnQgZGlzYWJsaW5nIHRyYWNlX3ByaW50ayBp
biBwYXJ0aWN1bGFyPw0KRWFjaCBfX2J1ZmZlcl91bmxvY2tfY29tbWl0IGlzIGFuIGF0b21pYyBy
aW5nIGJ1ZmZlciB1cGRhdGUsDQpzbyByZWFkIGZyb20gdHJhY2Ugd2lsbCBlaXRoZXIgc2VlIGl0
IGFzIGEgd2hvbGUgb3Igd29uJ3Qgc2VlIGl0Lg0KJ3RyYWNlX3BpcGUnIGNsZWFybHkgd29ya3Mg
ZmluZS4gV2h5ICd0cmFjZScgaXMgYW55IGRpZmZlcmVudD8NCkp1c3Qga2VlcCB0cmFjaW5nIGVu
YWJsZWQgYW5kIGtlZXAgcmVhZGluZyBpdCB1bnRpbCB0aGUgZW5kIG9mIGN1cnJlbnQNCnJpbmcg
YnVmZmVyLiBXaGV0aGVyIG9wZW4oKSBkZXRlcm1pbmVzIGN1cnJlbnQgb3IgaXQgcmVhZHMgdW50
aWwgbmV4dD0wDQppcyBhbiBpbXBsZW1lbnRhdGlvbiBkZXRhaWwuDQo=
