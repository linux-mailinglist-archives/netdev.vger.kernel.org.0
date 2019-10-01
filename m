Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B40C43AE
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 00:19:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728806AbfJAWTX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 18:19:23 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:58650 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728254AbfJAWTV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 18:19:21 -0400
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x91MHHCE016723;
        Tue, 1 Oct 2019 15:18:21 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bGc+XPi5X31Qj3Mr0VCBdN7d1qsdtT9eH5xHPOxQhiQ=;
 b=SHYEfZAw4qKENtk43XlU3PvLact59qcqmhsdEOqipiRjk+RdcLlUDcN1OupM+YCQAGV1
 WKNu0egO7+gVawCgzpArjLzU2cJNTl1ecN8ECsaYDp/g53oxaLtwBOkrNPrAmkr+As8J
 SPlkXMq5NAxtt9oLtdimnWXi+vEykr+Iu8U= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by m0001303.ppops.net with ESMTP id 2vcde3gjxj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Tue, 01 Oct 2019 15:18:21 -0700
Received: from ash-exhub203.TheFacebook.com (2620:10d:c0a8:83::5) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 1 Oct 2019 15:18:20 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 1 Oct 2019 15:18:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O8XISdpJrJwR6Du27uj8cda5Gzfioo80axGOxDg9jsgO+ZyPeyHWcUom4d82iVhDdKq22r3tNNvT+kXdcOKcJ08CmVMnWF7ET5ssHYcGbnK5k2IhDmJX34rmPAAiR+wDUhAD5Fg6m/SCzfW7hQMR/lygaAK29QOPHOWhhYLS3f5783HRrnNTJ4wSFLfUQlvy3vOIdqkDU20v7L108c3JJN8SIGUDbcKJBdhfaB9TcrRW5KZJX/Ac4EhvGH1oO2AzV0wZ+Aqo+IB+1b5gZEqFxngDti4ACk0ggLJ5sYxZBq8O5xCKfAJzuxbud1b6SP7jeltG10K0POmqLo0N9tGSKg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGc+XPi5X31Qj3Mr0VCBdN7d1qsdtT9eH5xHPOxQhiQ=;
 b=IoUN/yIBCVL8UnHdSo7ejAd+sciGJFTkS1hHYca6FVKwmAhMh9pG2fHAAI0eoWYJ7eyBXdEwDY36CUsGIhXB8bIAzY+wB3izC1zPeXY21m4Ikj2lh85Qi3RByffiHwuLTojC8+zDpECbh3fYQk3TvUk0l/AxO3SNytq37i33CChNYETY7vTv/oh8af9fHD6wUhjsMg1XyVnhbyKESc1qBHbq9O+5eqHZzpgl1odHgkpAnCLfawIb9uV0lUuA299Xl1XxzdVpz1mcYZKFcdz4B1TsnmoUECqWuItYUXsWflLeDi7j2aYCGzfmDZR96VRZsnSekYTS1VfhXGsqDns0RA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bGc+XPi5X31Qj3Mr0VCBdN7d1qsdtT9eH5xHPOxQhiQ=;
 b=AlVipXjxtZ92/VzR2F+XtvVuKe6gNMUltaRIm+8zKTkyMNUoOTfFs0em9rt7ebH5oOYufJJvkhma/vw2Aazmp2XbQyBM0prcfg6wlg+cW/W6PSGTC9UDRwubpl5FpQyX+xEsC2adtxukagRzxihNYRrfUY31+TYenB+Wp6MH/CM=
Received: from BYAPR15MB2501.namprd15.prod.outlook.com (52.135.196.11) by
 BYAPR15MB2519.namprd15.prod.outlook.com (20.179.154.156) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2305.22; Tue, 1 Oct 2019 22:18:19 +0000
Received: from BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0]) by BYAPR15MB2501.namprd15.prod.outlook.com
 ([fe80::c13d:be57:b216:bfa0%5]) with mapi id 15.20.2305.022; Tue, 1 Oct 2019
 22:18:19 +0000
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
Subject: Re: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Thread-Topic: [PATCH bpf-next] bpf, capabilities: introduce CAP_BPF
Thread-Index: AQHVXRmQqSOzyqrm4ECmsLsG3CKso6cPnGwAgAAaLYCAAAXUgIAAP7UAgAAYzoCAARgsgIAAHuKAgAA4VQCAMGzZgIACzy2AgABy1ACAAVzMAIAAAg8A
Date:   Tue, 1 Oct 2019 22:18:18 +0000
Message-ID: <6e8b910c-a739-857d-4867-395bd369bc6a@fb.com>
References: <CALCETrV8iJv9+Ai11_1_r6MapPhhwt9hjxi=6EoixytabTScqg@mail.gmail.com>
 <20190828003447.htgzsxs5oevn3eys@ast-mbp.dhcp.thefacebook.com>
 <CALCETrVbPPPr=BdPAx=tJKxD3oLXP4OVSgCYrB_E4vb6idELow@mail.gmail.com>
 <20190828044340.zeha3k3cmmxgfqj7@ast-mbp.dhcp.thefacebook.com>
 <CALCETrW1o+Lazi2Ng6b9JN6jeJffgdW9f3HvqYhNo4TpHRXW=g@mail.gmail.com>
 <20190828225512.q6qbvkdiqih2iewk@ast-mbp.dhcp.thefacebook.com>
 <DA52992F-4862-4945-8482-FE619A04C753@amacapital.net>
 <20190829040721.ef6rumbaunkavyrr@ast-mbp.dhcp.thefacebook.com>
 <20190928193727.1769e90c@oasis.local.home> <201909301129.5A1129C@keescook>
 <20191001012226.vwpe56won5r7gbrz@ast-mbp.dhcp.thefacebook.com>
 <20191001181052.43c9fabb@gandalf.local.home>
In-Reply-To: <20191001181052.43c9fabb@gandalf.local.home>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0070.namprd14.prod.outlook.com
 (2603:10b6:300:81::32) To BYAPR15MB2501.namprd15.prod.outlook.com
 (2603:10b6:a02:88::11)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::9a5b]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f382686a-442f-43e8-9387-08d746bd432c
x-ms-traffictypediagnostic: BYAPR15MB2519:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB251990DE23017AF850DBF124D79D0@BYAPR15MB2519.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0177904E6B
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(6116002)(53546011)(36756003)(305945005)(229853002)(46003)(386003)(6506007)(99286004)(31696002)(476003)(8676002)(8936002)(7416002)(186003)(6486002)(2616005)(486006)(86362001)(81166006)(81156014)(6436002)(7736002)(76176011)(52116002)(446003)(11346002)(2906002)(256004)(478600001)(110136005)(66446008)(66476007)(14444005)(66556008)(4326008)(25786009)(64756008)(316002)(5660300002)(6246003)(54906003)(71190400001)(66946007)(6512007)(31686004)(71200400001)(102836004)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB2519;H:BYAPR15MB2501.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r3MvNC+W3zGn3tPwq1U+ceXOCgalpL8z4dgPTPGCZkGRU49ljTcnobGmikvS6UN5wa7+8F3FanHH4l/72kYxylQOdN6IdMeOU0wUQGeQk6Q8GG6bvuvb6dtj22Mb7CZKG4cwPEdBvy4QgS1JBZKHyHJMcOjlfXQISF2aM8gklTvvkmcZ3sWgNxHf494t4AbZpZM7Ro5MfxDUfe2NKqQitTo1BgSsPkwgueLRR0X8NvI+FbqUxecLNdkt7oMUq9FSt5bgHuI5pUMMOrTTWK6a3zKv58v8pWfKMmWtgyYuymLG1DANOHkYSP3Ac85/TtTPD4Omw3FGtvVc5ASckuQt56yXqaCXYzxN5XybC3oZoqjVOPCylGVAoiWVprXAnz+ylqhZNgbwGW3RXuosWHunwv2FR7R9hyuDinwgVQs+6mY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAB5DFA59163744E82DF87EC84BC2EBC@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: f382686a-442f-43e8-9387-08d746bd432c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Oct 2019 22:18:18.8721
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KCvOvXKCh1JSaIQdQ/TsdNDoEO4F2fWdWa7WJmVt33DY/uY3o/Mc3BPtnuTHvq63
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB2519
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-01_10:2019-10-01,2019-10-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 impostorscore=0
 bulkscore=0 mlxlogscore=986 clxscore=1011 suspectscore=0 malwarescore=0
 adultscore=0 spamscore=0 lowpriorityscore=0 mlxscore=0 priorityscore=1501
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910010186
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMS8xOSAzOjEwIFBNLCBTdGV2ZW4gUm9zdGVkdCB3cm90ZToNCj4gT24gTW9uLCAzMCBT
ZXAgMjAxOSAxODoyMjoyOCAtMDcwMA0KPiBBbGV4ZWkgU3Rhcm92b2l0b3YgPGFsZXhlaS5zdGFy
b3ZvaXRvdkBnbWFpbC5jb20+IHdyb3RlOg0KPiANCj4+IHRyYWNlZnMgaXMgYSBmaWxlIHN5c3Rl
bSwgc28gY2xlYXJseSBmaWxlIGJhc2VkIGFjbHMgYXJlIG11Y2ggYmV0dGVyIGZpdA0KPj4gZm9y
IGFsbCB0cmFjZWZzIG9wZXJhdGlvbnMuDQo+PiBCdXQgdGhhdCBpcyBub3QgdGhlIGNhc2UgZm9y
IGZ0cmFjZSBvdmVyYWxsLg0KPj4gYnBmX3RyYWNlX3ByaW50aygpIGNhbGxzIHRyYWNlX3ByaW50
aygpIHRoYXQgZHVtcHMgaW50byB0cmFjZSBwaXBlLg0KPj4gVGVjaG5pY2FsbHkgaXQncyBmdHJh
Y2Ugb3BlcmF0aW9uLCBidXQgaXQgY2Fubm90IGJlIGNvbnRyb2xsZWQgYnkgdHJhY2Vmcw0KPj4g
YW5kIGJ5IGZpbGUgcGVybWlzc2lvbnMuIFRoYXQncyB0aGUgbW90aXZhdGlvbiB0byBndWFyZCBi
cGZfdHJhY2VfcHJpbnRrKCkNCj4+IHVzYWdlIGZyb20gYnBmIHByb2dyYW0gd2l0aCBDQVBfVFJB
Q0lORy4NCj4gDQo+IEJUVywgSSdkIHJhdGhlciBoYXZlIGJwZiB1c2UgYW4gZXZlbnQgdGhhdCBy
ZWNvcmRzIGEgc3RyaW5nIHRoYW4gdXNpbmcNCj4gdHJhY2UgcHJpbnRrIGl0c2VsZi4NCj4gDQo+
IFBlcmhhcHMgc29tZXRoaW5nIGxpa2UgImJwZl9wcmludCIgZXZlbnQ/IFRoYXQgY291bGQgYmUg
ZGVmaW5lZCBsaWtlOg0KPiANCj4gVFJBQ0VfRVZFTlQoYnBmX3ByaW50LA0KPiAJVFBfUFJPVE8o
Y29uc3QgY2hhciAqbXNnKSwNCj4gCVRQX0FSR1MobXNnKSwNCj4gCVRQX1NUUlVDVF9fZW50cnko
DQo+IAkJX19zdHJpbmcobXNnLCBtc2cpDQo+IAkpLA0KPiAJVFBfZmFzdF9hc3NpZ24oDQo+IAkJ
X19hc3NpZ25fc3RyKG1zZywgbXNnKQ0KPiAJKSwNCj4gCVRQX3ByaW50aygibXNnPSVzIiwgX19n
ZXRfc3RyKG1zZykpDQo+ICk7DQo+IA0KPiBBbmQgdGhlbiB5b3UgY2FuIGp1c3QgZm9ybWF0IHRo
ZSBzdHJpbmcgZnJvbSB0aGUgYnBmX3RyYWNlX3ByaW50aygpDQo+IGludG8gbXNnLCBhbmQgdGhl
biBoYXZlOg0KPiANCj4gCXRyYWNlX2JwZl9wcmludChtc2cpOw0KDQpJdCdzIGFuIGludGVyZXN0
aW5nIGlkZWEsIGJ1dCBJIGRvbid0IHRoaW5rIGl0IGNhbiB3b3JrLg0KUGxlYXNlIHNlZSBicGZf
dHJhY2VfcHJpbnRrIGltcGxlbWVudGF0aW9uIGluIGtlcm5lbC90cmFjZS9icGZfdHJhY2UuYw0K
SXQncyBhIGxvdCBtb3JlIHRoYW4gc3RyaW5nIHByaW50aW5nLg0KDQo+IFRoZSB1c2VyIGNvdWxk
IHRoZW4ganVzdCBlbmFibGUgdGhlIHRyYWNlIGV2ZW50IGZyb20gdGhlIGZpbGUgc3lzdGVtLiBJ
DQo+IGNvdWxkIGFsc28gd29yayBvbiBtYWtpbmcgaW5zdGFuY2VzIHdvcmsgbGlrZSAvdG1wIGRv
ZXMgKHdpdGggdGhlDQo+IHN0aWNreSBiaXQpIGluIGNyZWF0aW9uLiBUaGF0IHdheSBwZW9wbGUg
d2l0aCB3cml0ZSBhY2Nlc3MgdG8gdGhlDQo+IGluc3RhbmNlcyBkaXJlY3RvcnksIGNhbiBtYWtl
IHRoZWlyIG93biBidWZmZXJzIHRoYXQgdGhleSBjYW4gdXNlIChhbmQNCj4gb3RoZXJzIGNhbid0
IGFjY2VzcykuDQoNCldlIHRyaWVkIGluc3RhbmNlcyBpbiBiY2MgaW4gdGhlIHBhc3QgYW5kIGV2
ZW50dWFsbHkgcmVtb3ZlZCBhbGwgdGhlIA0Kc3VwcG9ydC4gVGhlIG92ZXJoZWFkIG9mIGluc3Rh
bmNlcyBpcyB0b28gaGlnaCB0byBiZSB1c2FibGUuDQoNCj4gDQo+IA0KPj4NCj4+IEJvdGggJ3Ry
YWNlJyBhbmQgJ3RyYWNlX3BpcGUnIGhhdmUgcXVpcmt5IHNpZGUgZWZmZWN0cy4NCj4+IExpa2Ug
b3BlbmluZyAndHJhY2UnIGZpbGUgd2lsbCBtYWtlIGFsbCBwYXJhbGxlbCB0cmFjZV9wcmludGso
KSB0byBiZSBpZ25vcmVkLg0KPj4gV2hpbGUgcmVhZGluZyAndHJhY2VfcGlwZScgZmlsZSB3aWxs
IGNsZWFyIGl0Lg0KPj4gVGhlIHBvaW50IHRoYXQgdHJhZGl0aW9uYWwgJ3JlYWQnIGFuZCAnd3Jp
dGUnIEFDTHMgZG9uJ3QgbWFwIGFzLWlzDQo+PiB0byB0cmFjZWZzLCBzbyBJIHdvdWxkIGJlIGNh
cmVmdWwgY2F0ZWdvcml6aW5nIHRoaW5ncyBpbnRvDQo+PiBjb25maWRlbnRpYWxpdHkgdnMgaW50
ZWdyaXR5IG9ubHkgYmFzZWQgb24gYWNjZXNzIHR5cGUuDQo+IA0KPiBXaGF0IGV4YWN0bHkgaXMg
dGhlIGJwZl90cmFjZV9wcmludGsoKSB1c2VkIGZvcj8gSSBtYXkgaGF2ZSBvdGhlciBpZGVhcw0K
PiB0aGF0IGNhbiBoZWxwLg0KDQpJdCdzIGRlYnVnZ2luZyBvZiBicGYgcHJvZ3JhbXMuIFNhbWUg
aXMgd2hhdCBwcmludGsoKSBpcyB1c2VkIGZvcg0KYnkga2VybmVsIGRldmVsb3BlcnMuDQoNCg==
