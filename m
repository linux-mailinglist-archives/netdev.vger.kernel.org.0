Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8173380178
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 21:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406449AbfHBT6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 15:58:12 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:25266 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2392328AbfHBT6L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 15:58:11 -0400
Received: from pps.filterd (m0001255.ppops.net [127.0.0.1])
        by mx0b-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x72Juhtg026052;
        Fri, 2 Aug 2019 12:57:43 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=jjgsWUqJQk50fE0qDlCkHVrNV+FD7TzkEKyO4ABoK94=;
 b=o0tm7gr/wbc5tLw9s0R3LJBPqG8dGTYrJwNC3PxqxBRGd41f/vp2Q+SGdtFQjIIx/ERU
 d0eUfSMALnOmQ35UzK+R4om/417GQL/09HYoj8WNGYhZHBUew06Er7WSOBK7eDfczLXY
 G60tr0TU338qSWubSyBhjpDO+z158x89E3c= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0b-00082601.pphosted.com with ESMTP id 2u4s4q0knq-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 02 Aug 2019 12:57:43 -0700
Received: from ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) by
 ash-exhub101.TheFacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 2 Aug 2019 12:57:43 -0700
Received: from NAM05-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.172) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 2 Aug 2019 12:57:43 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XIeBHe7UdvYhGmhi34VUGdnGBSdxDvU8JZI4e6eybmMGGzmXeLwsjlugwZl+KhaS4mRNuBtZi1TxcpMsNpXM+BlJRb0P8eHg6qotKoXcPcjSNihy2jGyiopZHMSpEZ0LnK6Ii08Y8jKRXjqqTDnufCaLK3fzFhRGxdU6dAtn6LBld5Ha3KnsI1sBqzMDJ1hg0K60gyxSSUY5wNQEN0O/GHiFLtM3gk0ztMUk2m1mflBWv12H3Ga1WmOovHcpfME/4O2EQuvJzJeg8AJpOeN3iZjNgCWXdFjd+JYRCoHSaUt8Ro3MlZ2SHLnYivH+TKyFuIKl6k+uoB/sDi8l8Mlr6A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjgsWUqJQk50fE0qDlCkHVrNV+FD7TzkEKyO4ABoK94=;
 b=HS9Hw0TPo5owNv2Eag2hTQL9cx5ewdP1euMDaHmuDIEOsnggI4wFN6TP1MFiIuWVJgbptZSNetMdCs9gFn1nNlBZUTIjoChNG9YcrwHwKMPyowD9JWts4C4D2/dLMbx5cRv/8ciyieoi2g9qGmC+IC9D/Wdr3rpykv2l+uiOh6EahdiUd2SDdf+YbBXsbR6gJC7OBZayxG5h/ns3WYU09MGddMe2iq9uIt+/Q5RqObTd8+nBD5Ip7GCssJ6bpe+0iR/dRQFlsjHvwges5lWE2VqYKbfRQkoYoFalnXx/XYi63kIBaBDE2uEOBn/chrcDQ5DkrZzI88M91lnxxTG5Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=fb.com;dmarc=pass action=none header.from=fb.com;dkim=pass
 header.d=fb.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jjgsWUqJQk50fE0qDlCkHVrNV+FD7TzkEKyO4ABoK94=;
 b=Y6VOTCGKxcOAd6nfwOi/pDRTk4GYq/49cfz5t8quktR/ZrgusuRfXFtSILFHOJC6uJ2xxDJiz8LRoiy4hMZDS9rqk7sSNGu1yv11hCjbCZ2ffxsf5245EK3xkpUnEWv2ZqojFgRN1fpNeRof51CTg4yni7ePXAhCKRKt9RnssZg=
Received: from CY4PR15MB1479.namprd15.prod.outlook.com (10.172.162.17) by
 CY4PR15MB1254.namprd15.prod.outlook.com (10.172.180.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Fri, 2 Aug 2019 19:57:41 +0000
Received: from CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::79a3:6a7a:1014:a5e4]) by CY4PR15MB1479.namprd15.prod.outlook.com
 ([fe80::79a3:6a7a:1014:a5e4%8]) with mapi id 15.20.2115.005; Fri, 2 Aug 2019
 19:57:41 +0000
From:   Andrii Nakryiko <andriin@fb.com>
To:     Stanislav Fomichev <sdf@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: test_progs: switch to
 open_memstream
Thread-Topic: [PATCH bpf-next 1/3] selftests/bpf: test_progs: switch to
 open_memstream
Thread-Index: AQHVSVYlCW3wMTV4wUeGCxWhoReI5qboRmUA
Date:   Fri, 2 Aug 2019 19:57:40 +0000
Message-ID: <80957794-de90-b09b-89ef-6094d6357d9e@fb.com>
References: <20190802171710.11456-1-sdf@google.com>
 <20190802171710.11456-2-sdf@google.com>
In-Reply-To: <20190802171710.11456-2-sdf@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR14CA0023.namprd14.prod.outlook.com
 (2603:10b6:300:ae::33) To CY4PR15MB1479.namprd15.prod.outlook.com
 (2603:10b6:903:100::17)
user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.2
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::e445]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3022e020-eef2-47b9-5f50-08d71783ace9
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:CY4PR15MB1254;
x-ms-traffictypediagnostic: CY4PR15MB1254:
x-microsoft-antispam-prvs: <CY4PR15MB12546132C44FDDFA652354D6C6D90@CY4PR15MB1254.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:660;
x-forefront-prvs: 011787B9DD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(346002)(366004)(376002)(189003)(199004)(446003)(53546011)(65826007)(53936002)(76176011)(66476007)(6512007)(66946007)(64756008)(110136005)(31686004)(66446008)(5660300002)(6486002)(6436002)(8676002)(58126008)(2201001)(25786009)(229853002)(65806001)(81166006)(81156014)(7736002)(4326008)(64126003)(66556008)(52116002)(6506007)(31696002)(71200400001)(6246003)(54906003)(11346002)(68736007)(2501003)(386003)(476003)(14454004)(65956001)(8936002)(256004)(186003)(71190400001)(316002)(46003)(305945005)(486006)(102836004)(478600001)(14444005)(2616005)(6116002)(99286004)(86362001)(2906002)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:CY4PR15MB1254;H:CY4PR15MB1479.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: rvfWR2aH+XXrDspfaDMcuf5OWJS1BCrj0pKRrvfVIPzOtAKbzycSZNrAWYHrt9j0P82pu7FBMA+Ikmzo0DVQegHcqVJySrC2ZMVZ7/4DhLuSX9op7G62wHFYHTn62W9zKou3cLtco7c7T5D9ISlWCTqfdT4sMopiLpLgwJx9JHqVCkHjnBWKlLSxm2/4/wJ9VZWctCVqaGOiZ9AtF1tLZqnZwXN5DzI9xi454VGKUWoDGZfb+vS9+rDcpmL2xulBcXO0VPmFBbHicAZDHGuQqlS9No5GGTH01uTFO2+2j1TQhughcvJkwtIwlZdKnHzVCkj2Fn5/1GI+xg9EKIcd3IEX2tRw9bw7WqXGOQHfLlm9byElt44K6WFKMUGc8+QVWcNjI0M/u/BZ0BZj5YZ0td5lrZbf/AY/0siBsz1ncOg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DFA3AFF764DDF546AE1B3FE61AC61C28@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3022e020-eef2-47b9-5f50-08d71783ace9
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Aug 2019 19:57:40.7843
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: andriin@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR15MB1254
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-08-02_08:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1906280000 definitions=main-1908020211
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8yLzE5IDEwOjE3IEFNLCBTdGFuaXNsYXYgRm9taWNoZXYgd3JvdGU6DQo+IFVzZSBvcGVu
X21lbXN0cmVhbSB0byBvdmVycmlkZSBzdGRvdXQgZHVyaW5nIHRlc3QgZXhlY3V0aW9uLg0KPiBU
aGUgY29weSBvZiB0aGUgb3JpZ2luYWwgc3Rkb3V0IGlzIGhlbGQgaW4gZW52LnN0ZG91dCBhbmQg
dXNlZA0KPiB0byBwcmludCBzdWJ0ZXN0IGluZm8gYW5kIGR1bXAgZmFpbGVkIGxvZy4NCg0KSSBy
ZWFsbHkgbGlrZSB0aGUgaWRlYS4gSSBkaWRuJ3Qga25vdyBhYm91dCBvcGVuX21lbXN0cmVhbSwg
aXQncyBhd2Vzb21lLiBUaGFua3MhDQoNCj4NCj4gdGVzdF97dix9cHJpbnRmIGFyZSBub3cgc2lt
cGxlIHdyYXBwZXJzIGFyb3VuZCBzdGRvdXQgYW5kIHdpbGwgYmUNCj4gcmVtb3ZlZCBpbiB0aGUg
bmV4dCBwYXRjaC4NCj4NCj4gQ2M6IEFuZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+
IFNpZ25lZC1vZmYtYnk6IFN0YW5pc2xhdiBGb21pY2hldiA8c2RmQGdvb2dsZS5jb20+DQo+IC0t
LQ0KPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3RfcHJvZ3MuYyB8IDEwMCArKysr
KysrKysrLS0tLS0tLS0tLS0tLQ0KPiAgdG9vbHMvdGVzdGluZy9zZWxmdGVzdHMvYnBmL3Rlc3Rf
cHJvZ3MuaCB8ICAgMiArLQ0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA0NiBpbnNlcnRpb25zKCspLCA1
NiBkZWxldGlvbnMoLSkNCj4NCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3Rz
L2JwZi90ZXN0X3Byb2dzLmMgYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9n
cy5jDQo+IGluZGV4IGRiMDAxOTZjODMxNS4uMDBkMTU2NWQwMWEzIDEwMDY0NA0KPiAtLS0gYS90
b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9ncy5jDQo+ICsrKyBiL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3Byb2dzLmMNCj4gQEAgLTQwLDE0ICs0MCwyMiBAQCBz
dGF0aWMgYm9vbCBzaG91bGRfcnVuKHN0cnVjdCB0ZXN0X3NlbGVjdG9yICpzZWwsIGludCBudW0s
IGNvbnN0IGNoYXIgKm5hbWUpDQo+ICANCj4gIHN0YXRpYyB2b2lkIGR1bXBfdGVzdF9sb2coY29u
c3Qgc3RydWN0IHByb2dfdGVzdF9kZWYgKnRlc3QsIGJvb2wgZmFpbGVkKQ0KPiAgew0KPiAtCWlm
IChlbnYudmVyYm9zZSB8fCB0ZXN0LT5mb3JjZV9sb2cgfHwgZmFpbGVkKSB7DQo+IC0JCWlmIChl
bnYubG9nX2NudCkgew0KPiAtCQkJZnByaW50ZihzdGRvdXQsICIlcyIsIGVudi5sb2dfYnVmKTsN
Cj4gLQkJCWlmIChlbnYubG9nX2J1ZltlbnYubG9nX2NudCAtIDFdICE9ICdcbicpDQo+IC0JCQkJ
ZnByaW50ZihzdGRvdXQsICJcbiIpOw0KPiArCWlmIChzdGRvdXQgPT0gZW52LnN0ZG91dCkNCj4g
KwkJcmV0dXJuOw0KPiArDQo+ICsJZmZsdXNoKHN0ZG91dCk7IC8qIGV4cG9ydHMgZW52LmxvZ19i
dWYgJiBlbnYubG9nX2NhcCAqLw0KPiArDQo+ICsJaWYgKGVudi5sb2dfY2FwICYmIChlbnYudmVy
Ym9zZSB8fCB0ZXN0LT5mb3JjZV9sb2cgfHwgZmFpbGVkKSkgew0KPiArCQlpbnQgbGVuID0gc3Ry
bGVuKGVudi5sb2dfYnVmKTsNCg0KZW52LmxvZ19jYXAgaXMgbm90IHJlYWxseSBhIGNhcGFjaXR5
LCBpdCdzIGFjdHVhbCBudW1iZXIgb2YgYnl0ZXMgKHdpdGhvdXQgdGVybWluYXRpbmcgemVybyks
IHNvIHRoZXJlIGlzIG5vIG5lZWQgdG8gZG8gc3RybGVuIGFuZCBpdCdzIHByb2JhYmx5IGJldHRl
ciB0byByZW5hbWUgZW52LmxvZ19jYXAgaW50byBlbnYubG9nX2NudC4NCg0KDQo+ICsNCj4gKwkJ
aWYgKGxlbikgew0KPiArCQkJZnByaW50ZihlbnYuc3Rkb3V0LCAiJXMiLCBlbnYubG9nX2J1Zik7
DQo+ICsJCQlpZiAoZW52LmxvZ19idWZbbGVuIC0gMV0gIT0gJ1xuJykNCj4gKwkJCQlmcHJpbnRm
KGVudi5zdGRvdXQsICJcbiIpOw0KPiArDQo+ICsJCQlmc2Vla28oc3Rkb3V0LCAwLCBTRUVLX1NF
VCk7DQpTYW1lIGJ1ZyBhcyBJIGFscmVhZHkgZml4ZWQgd2l0aCBlbnYubG9nX2NudCA9IDAgYmVp
bmcgaW5zaWRlIHRoaXMgaWYuIFlvdSB3YW50IHRvIGRvIHNlZWsgYWx3YXlzLCBub3QganVzdCB3
aGVuIHlvdSBwcmludCBvdXRwdXQgbG9nLg0KPiAgLyogcmV3aW5kICovDQo+ICAJCX0NCj4gIAl9
DQo+IC0JZW52LmxvZ19jbnQgPSAwOw0KPiAgfQ0KPiAgDQo+ICB2b2lkIHRlc3RfX2VuZF9zdWJ0
ZXN0KCkNCj4gQEAgLTYyLDcgKzcwLDcgQEAgdm9pZCB0ZXN0X19lbmRfc3VidGVzdCgpDQo+ICAN
Cj4gIAlkdW1wX3Rlc3RfbG9nKHRlc3QsIHN1Yl9lcnJvcl9jbnQpOw0KPiAgDQo+IC0JcHJpbnRm
KCIjJWQvJWQgJXM6JXNcbiIsDQo+ICsJZnByaW50ZihlbnYuc3Rkb3V0LCAiIyVkLyVkICVzOiVz
XG4iLA0KPiAgCSAgICAgICB0ZXN0LT50ZXN0X251bSwgdGVzdC0+c3VidGVzdF9udW0sDQo+ICAJ
ICAgICAgIHRlc3QtPnN1YnRlc3RfbmFtZSwgc3ViX2Vycm9yX2NudCA/ICJGQUlMIiA6ICJPSyIp
Ow0KPiAgfQ0KPiBAQCAtMTAwLDUzICsxMDgsNyBAQCB2b2lkIHRlc3RfX2ZvcmNlX2xvZygpIHsN
Cj4gIA0KPiAgdm9pZCB0ZXN0X192cHJpbnRmKGNvbnN0IGNoYXIgKmZtdCwgdmFfbGlzdCBhcmdz
KQ0KPiAgew0KPiAtCXNpemVfdCByZW1fc3o7DQo+IC0JaW50IHJldCA9IDA7DQo+IC0NCj4gLQlp
ZiAoZW52LnZlcmJvc2UgfHwgKGVudi50ZXN0ICYmIGVudi50ZXN0LT5mb3JjZV9sb2cpKSB7DQo+
IC0JCXZmcHJpbnRmKHN0ZGVyciwgZm10LCBhcmdzKTsNCj4gLQkJcmV0dXJuOw0KPiAtCX0NCj4g
LQ0KPiAtdHJ5X2FnYWluOg0KPiAtCXJlbV9zeiA9IGVudi5sb2dfY2FwIC0gZW52LmxvZ19jbnQ7
DQo+IC0JaWYgKHJlbV9zeikgew0KPiAtCQl2YV9saXN0IGFwOw0KPiAtDQo+IC0JCXZhX2NvcHko
YXAsIGFyZ3MpOw0KPiAtCQkvKiB3ZSByZXNlcnZlZCBleHRyYSBieXRlIGZvciBcMCBhdCB0aGUg
ZW5kICovDQo+IC0JCXJldCA9IHZzbnByaW50ZihlbnYubG9nX2J1ZiArIGVudi5sb2dfY250LCBy
ZW1fc3ogKyAxLCBmbXQsIGFwKTsNCj4gLQkJdmFfZW5kKGFwKTsNCj4gLQ0KPiAtCQlpZiAocmV0
IDwgMCkgew0KPiAtCQkJZW52LmxvZ19idWZbZW52LmxvZ19jbnRdID0gJ1wwJzsNCj4gLQkJCWZw
cmludGYoc3RkZXJyLCAiZmFpbGVkIHRvIGxvZyB3LyBmbXQgJyVzJ1xuIiwgZm10KTsNCj4gLQkJ
CXJldHVybjsNCj4gLQkJfQ0KPiAtCX0NCj4gLQ0KPiAtCWlmICghcmVtX3N6IHx8IHJldCA+IHJl
bV9zeikgew0KPiAtCQlzaXplX3QgbmV3X3N6ID0gZW52LmxvZ19jYXAgKiAzIC8gMjsNCj4gLQkJ
Y2hhciAqbmV3X2J1ZjsNCj4gLQ0KPiAtCQlpZiAobmV3X3N6IDwgNDA5NikNCj4gLQkJCW5ld19z
eiA9IDQwOTY7DQo+IC0JCWlmIChuZXdfc3ogPCByZXQgKyBlbnYubG9nX2NudCkNCj4gLQkJCW5l
d19zeiA9IHJldCArIGVudi5sb2dfY250Ow0KPiAtDQo+IC0JCS8qICsxIGZvciBndWFyYW50ZWVk
IHNwYWNlIGZvciB0ZXJtaW5hdGluZyBcMCAqLw0KPiAtCQluZXdfYnVmID0gcmVhbGxvYyhlbnYu
bG9nX2J1ZiwgbmV3X3N6ICsgMSk7DQo+IC0JCWlmICghbmV3X2J1Zikgew0KPiAtCQkJZnByaW50
ZihzdGRlcnIsICJmYWlsZWQgdG8gcmVhbGxvYyBsb2cgYnVmZmVyOiAlZFxuIiwNCj4gLQkJCQll
cnJubyk7DQo+IC0JCQlyZXR1cm47DQo+IC0JCX0NCj4gLQkJZW52LmxvZ19idWYgPSBuZXdfYnVm
Ow0KPiAtCQllbnYubG9nX2NhcCA9IG5ld19zejsNCj4gLQkJZ290byB0cnlfYWdhaW47DQo+IC0J
fQ0KPiAtDQo+IC0JZW52LmxvZ19jbnQgKz0gcmV0Ow0KPiArCXZwcmludGYoZm10LCBhcmdzKTsN
Cj4gIH0NCj4gIA0KPiAgdm9pZCB0ZXN0X19wcmludGYoY29uc3QgY2hhciAqZm10LCAuLi4pDQo+
IEBAIC00NzcsNiArNDM5LDMyIEBAIHN0YXRpYyBlcnJvcl90IHBhcnNlX2FyZyhpbnQga2V5LCBj
aGFyICphcmcsIHN0cnVjdCBhcmdwX3N0YXRlICpzdGF0ZSkNCj4gIAlyZXR1cm4gMDsNCj4gIH0N
Cj4gIA0KPiArc3RhdGljIHZvaWQgc3Rkb3V0X2hpamFjayh2b2lkKQ0KPiArew0KPiArCWlmIChl
bnYudmVyYm9zZSB8fCAoZW52LnRlc3QgJiYgZW52LnRlc3QtPmZvcmNlX2xvZykpIHsNCj4gKwkJ
Lyogbm90aGluZyB0byBkbywgb3V0cHV0IHRvIHN0ZG91dCBieSBkZWZhdWx0ICovDQo+ICsJCXJl
dHVybjsNCj4gKwl9DQo+ICsNCj4gKwkvKiBzdGRvdXQgLT4gYnVmZmVyICovDQo+ICsJZmZsdXNo
KHN0ZG91dCk7DQo+ICsJc3Rkb3V0ID0gb3Blbl9tZW1zdHJlYW0oJmVudi5sb2dfYnVmLCAmZW52
LmxvZ19jYXApOw0KQ2hlY2sgZXJyb3JzIGFuZCByZXN0b3JlIG9yaWdpbmFsIHN0ZG91dCBpZiBz
b21ldGhpbmcgd2VudCB3cm9uZz8gKEFuZCBlbWl0IHNvbWUgd2FybmluZyB0byBzdGRlcnIpLg0K
PiArfQ0KPiArDQo+ICtzdGF0aWMgdm9pZCBzdGRvdXRfcmVzdG9yZSh2b2lkKQ0KPiArew0KPiAr
CWlmIChzdGRvdXQgPT0gZW52LnN0ZG91dCkNCj4gKwkJcmV0dXJuOw0KPiArDQo+ICsJZmNsb3Nl
KHN0ZG91dCk7DQo+ICsJZnJlZShlbnYubG9nX2J1Zik7DQo+ICsNCj4gKwllbnYubG9nX2J1ZiA9
IE5VTEw7DQo+ICsJZW52LmxvZ19jYXAgPSAwOw0KPiArDQo+ICsJc3Rkb3V0ID0gZW52LnN0ZG91
dDsNCj4gK30NCj4gKw0KPiAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiphcmd2KQ0KPiAgew0K
PiAgCXN0YXRpYyBjb25zdCBzdHJ1Y3QgYXJncCBhcmdwID0gew0KPiBAQCAtNDk1LDYgKzQ4Myw3
IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikNCj4gIAlzcmFuZCh0aW1lKE5VTEwp
KTsNCj4gIA0KPiAgCWVudi5qaXRfZW5hYmxlZCA9IGlzX2ppdF9lbmFibGVkKCk7DQo+ICsJZW52
LnN0ZG91dCA9IHN0ZG91dDsNCj4gIA0KPiAgCWZvciAoaSA9IDA7IGkgPCBwcm9nX3Rlc3RfY250
OyBpKyspIHsNCj4gIAkJc3RydWN0IHByb2dfdGVzdF9kZWYgKnRlc3QgPSAmcHJvZ190ZXN0X2Rl
ZnNbaV07DQo+IEBAIC01MDgsNiArNDk3LDcgQEAgaW50IG1haW4oaW50IGFyZ2MsIGNoYXIgKiph
cmd2KQ0KPiAgCQkJCXRlc3QtPnRlc3RfbnVtLCB0ZXN0LT50ZXN0X25hbWUpKQ0KPiAgCQkJY29u
dGludWU7DQo+ICANCj4gKwkJc3Rkb3V0X2hpamFjaygpOw0KV2h5IGRvIHlvdSBkbyB0aGlzIGZv
ciBldmVyeSB0ZXN0PyBKdXN0IGRvIG9uY2UgYmVmb3JlIGFsbCB0aGUgdGVzdHMgYW5kIHJlc3Rv
cmUgYWZ0ZXI/DQo+ICAJCXRlc3QtPnJ1bl90ZXN0KCk7DQo+ICAJCS8qIGVuc3VyZSBsYXN0IHN1
Yi10ZXN0IGlzIGZpbmFsaXplZCBwcm9wZXJseSAqLw0KPiAgCQlpZiAodGVzdC0+c3VidGVzdF9u
YW1lKQ0KPiBAQCAtNTIyLDYgKzUxMiw3IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJn
dikNCj4gIAkJCWVudi5zdWNjX2NudCsrOw0KPiAgDQo+ICAJCWR1bXBfdGVzdF9sb2codGVzdCwg
dGVzdC0+ZXJyb3JfY250KTsNCj4gKwkJc3Rkb3V0X3Jlc3RvcmUoKTsNCj4gIA0KPiAgCQlwcmlu
dGYoIiMlZCAlczolc1xuIiwgdGVzdC0+dGVzdF9udW0sIHRlc3QtPnRlc3RfbmFtZSwNCj4gIAkJ
ICAgICAgIHRlc3QtPmVycm9yX2NudCA/ICJGQUlMIiA6ICJPSyIpOw0KPiBAQCAtNTI5LDcgKzUy
MCw2IEBAIGludCBtYWluKGludCBhcmdjLCBjaGFyICoqYXJndikNCj4gIAlwcmludGYoIlN1bW1h
cnk6ICVkLyVkIFBBU1NFRCwgJWQgRkFJTEVEXG4iLA0KPiAgCSAgICAgICBlbnYuc3VjY19jbnQs
IGVudi5zdWJfc3VjY19jbnQsIGVudi5mYWlsX2NudCk7DQo+ICANCj4gLQlmcmVlKGVudi5sb2df
YnVmKTsNCj4gIAlmcmVlKGVudi50ZXN0X3NlbGVjdG9yLm51bV9zZXQpOw0KPiAgCWZyZWUoZW52
LnN1YnRlc3Rfc2VsZWN0b3IubnVtX3NldCk7DQo+ICANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL3Rl
c3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3Byb2dzLmggYi90b29scy90ZXN0aW5nL3NlbGZ0ZXN0
cy9icGYvdGVzdF9wcm9ncy5oDQo+IGluZGV4IGFmZDE0OTYyNDU2Zi4uOWZkODkwNzg0OTRmIDEw
MDY0NA0KPiAtLS0gYS90b29scy90ZXN0aW5nL3NlbGZ0ZXN0cy9icGYvdGVzdF9wcm9ncy5oDQo+
ICsrKyBiL3Rvb2xzL3Rlc3Rpbmcvc2VsZnRlc3RzL2JwZi90ZXN0X3Byb2dzLmgNCj4gQEAgLTU2
LDggKzU2LDggQEAgc3RydWN0IHRlc3RfZW52IHsNCj4gIAlib29sIGppdF9lbmFibGVkOw0KPiAg
DQo+ICAJc3RydWN0IHByb2dfdGVzdF9kZWYgKnRlc3Q7DQo+ICsJRklMRSAqc3Rkb3V0Ow0KPiAg
CWNoYXIgKmxvZ19idWY7DQo+IC0Jc2l6ZV90IGxvZ19jbnQ7DQo+ICAJc2l6ZV90IGxvZ19jYXA7
DQpTbyBpdCdzIGFjdHVhbGx5IGxvZ19jbnQgdGhhdCdzIGFzc2lnbmVkIG9uIGZmbHVzaCBmb3Ig
bWVtc3RyZWFtLCBhY2NvcmRpbmcgdG8gbWFuIHBhZ2UsIHNvIHByb2JhYmx5IGtlZXAgbG9nX2Nu
dCwgZGVsZXRlIGxvZ19jYXAuDQo+ICANCj4gIAlpbnQgc3VjY19jbnQ7IC8qIHN1Y2Nlc3NmdWwg
dGVzdHMgKi8NCg==
