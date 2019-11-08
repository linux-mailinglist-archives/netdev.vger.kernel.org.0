Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80115F57F0
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732607AbfKHTwz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:52:55 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:60490 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732223AbfKHTwz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:52:55 -0500
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id xA8Jnd2Y032443;
        Fri, 8 Nov 2019 11:52:38 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=ouK8xzF5EoDLexa6gmU8g3CElfAcm2z2igwj3Alewwc=;
 b=P3PPNuZkNLR/QP+59UibWUirocalmocXmIRudCYT2oBPwEANQsPkTrMXhjWcJn0klYcs
 GBuZVz4hfCSUMuZtARNiI4kSpCmt/f91BQt6IVqxb1nsU7340Agmmde5qXCHcsyr1BNL
 2zp8tjrAnVEHAFC7hXAKGdKWyjIrUAB/ft0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2w5ckcgu4h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 08 Nov 2019 11:52:38 -0800
Received: from prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) by
 prn-hub04.TheFacebook.com (2620:10d:c081:35::128) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 11:52:37 -0800
Received: from prn-hub03.TheFacebook.com (2620:10d:c081:35::127) by
 prn-mbx04.TheFacebook.com (2620:10d:c081:6::18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 8 Nov 2019 11:52:37 -0800
Received: from NAM01-SN1-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.27) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 8 Nov 2019 11:52:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XRiJVW1lTBMJnYj1LWkIBi9KZff0QAdD0pwWJUCaKUS8TmKsy+CCg71MaySvuN2rvtD5kytzyWrfaGLWBsYMsaFXuJKZvmpKjv6wRIL2vFVkhmMRHWRJVNNBczixwA8DihdYo0HoriyQOKZNDLIspc3uEDC3RL6vRDeIzqNllHAhiwD5/qmlWRSAC3owTGpDJJmJfKN4aISY3pRGRDdE9kSRpWJ7VW3hG13Qa1fLL5KtNjGA62NAmY6XiFb25efFwCzxPK6+HeKe64fYRYoxF3MMVeKOCItLtcPtBdI3B7NmvFVKPY15smKmjwhOTw8WLvhNdAPNVX4O43kvBNNOQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouK8xzF5EoDLexa6gmU8g3CElfAcm2z2igwj3Alewwc=;
 b=lVot/8hRM9sc9/lDK+e2fO9pwYQNjSBZwySXtKNQOofLSXZWV3yif7Y8qWepYcODb+QLOgv6AuzfsymZpg1ZEigfb0d99gKHwQ8rIYIkSd0gR27fuopf+WSeDoAkxHlKnyszfAK6L6C6WBvSIeRTdGKUSajOSo3mzTHSkADGBZTXtzPnbdNHkruloILr8qcNEwI0Kr4d/sLrgFa2hU969zcgfP+T73byb/HcqHOrMzz/YAko8G/Cg2TKIW3hmu6JM7UQbKk4KXsPgT0GUmaPwvpBoXaEHnVbk5D7xZe9nOZiIL/3uSqHlig3BZTVXzsSCXlEwTzKQWHd3S/DzdqbBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ouK8xzF5EoDLexa6gmU8g3CElfAcm2z2igwj3Alewwc=;
 b=GRVU/TDx09TUJpd5ImTB7BKrO5hS/+J7Evz66IbIuP4i9LMVpxedVudJiccjlCi4scMTZmLDKn4573tKQBrmff/CCBZQcJRjXQPmoPcX130nZfVt0h6n/fO6/Fcnezyhj3ZeIagbDI7ZcwncWNdGFUeA/v63c86f3xjsxeGpSpA=
Received: from MWHPR15MB1165.namprd15.prod.outlook.com (10.175.3.22) by
 MWHPR15MB1679.namprd15.prod.outlook.com (10.175.141.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.20; Fri, 8 Nov 2019 19:52:35 +0000
Received: from MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5]) by MWHPR15MB1165.namprd15.prod.outlook.com
 ([fe80::fdc8:5546:bace:15f5%5]) with mapi id 15.20.2430.020; Fri, 8 Nov 2019
 19:52:35 +0000
From:   Song Liu <songliubraving@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, Martin Lau <kafai@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: Re: [PATCH bpf-next 5/6] libbpf: Add bpf_get_link_xdp_info() function
 to get more XDP information
Thread-Topic: [PATCH bpf-next 5/6] libbpf: Add bpf_get_link_xdp_info()
 function to get more XDP information
Thread-Index: AQHVlYu+xjaRuxcrc0Ob4Gl3/9JTUKeBsQqA
Date:   Fri, 8 Nov 2019 19:52:35 +0000
Message-ID: <3C1D7121-8D90-4F30-964D-D684CAC3FFEA@fb.com>
References: <157314553801.693412.15522462897300280861.stgit@toke.dk>
 <157314554370.693412.2312326138964108684.stgit@toke.dk>
In-Reply-To: <157314554370.693412.2312326138964108684.stgit@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3601.0.10)
x-originating-ip: [2620:10d:c090:200::b292]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 359d30c5-e29e-45d0-5e6a-08d7648533c6
x-ms-traffictypediagnostic: MWHPR15MB1679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR15MB16791DC10ED60EA5EA20D247B37B0@MWHPR15MB1679.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(376002)(136003)(396003)(39860400002)(346002)(189003)(199004)(66476007)(66446008)(86362001)(6486002)(476003)(229853002)(446003)(81166006)(256004)(5024004)(6436002)(8676002)(2616005)(36756003)(50226002)(81156014)(8936002)(33656002)(14454004)(2906002)(54906003)(486006)(11346002)(6916009)(6512007)(14444005)(5660300002)(99286004)(186003)(46003)(76116006)(6506007)(76176011)(64756008)(66556008)(66574012)(66946007)(7736002)(53546011)(316002)(25786009)(6246003)(71200400001)(6116002)(305945005)(4326008)(102836004)(71190400001)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1679;H:MWHPR15MB1165.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c3yB3THd8v2uti3G71SPGf/iPrCzNcaY2Iz73WZxUxs3m62eJFBjAzt27YrsClPLeUsy66ZSiJ0vCDnKcgh3a54Q3K3oiN9On0SM3E5wAQwMto6doumwH2uCrcN1X/yBL41cQFOGOgzCbKfiAOfEO/lhWuuUJATCUOhZponO7yqlryDNrNvpbC80B30KPxrlZrIyUf7l9o6Lu6kcS7ED0dI5pS/A25wBkoNdQw9Ws4o5VT28Kg/aMUwNTkEN6tE9DrsphJ9R3GQKdhk9CpNRkA92PpTCwU/Up50iO9/K8jqcwPV4ul1SBhc2mEw7ehj3nT1y1VJVE7F4lEf6imXvFlB1+pdSMUzsW4C8SZdxvJOp9XNSN9cRv+5c5XVpaGBRRBnIy5thRmS5JN42dDgFaGUeaQnqZO21HBfq76iCItDqS9yuSaK7MATfcV1f2ldD
Content-Type: text/plain; charset="utf-8"
Content-ID: <A915FE2D1214ED4DBF985B7B3EDCAD48@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 359d30c5-e29e-45d0-5e6a-08d7648533c6
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 19:52:35.6761
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WvodrQ0GqHHKkkvfZWZZf2sGsG1a1eFZyMvNBVJAsBbFr+sxqyzFyIgdRDzKbiK5ERoZCkIYRjq9DKdCFi7S6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1679
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-11-08_07:2019-11-08,2019-11-08 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 lowpriorityscore=0 clxscore=1015
 mlxlogscore=938 impostorscore=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1911080192
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTm92IDcsIDIwMTksIGF0IDg6NTIgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNl
biA8dG9rZUByZWRoYXQuY29tPiB3cm90ZToNCj4gDQo+IEZyb206IFRva2UgSMO4aWxhbmQtSsO4
cmdlbnNlbiA8dG9rZUByZWRoYXQuY29tPg0KPiANCj4gQ3VycmVudGx5LCBsaWJicGYgb25seSBw
cm92aWRlcyBhIGZ1bmN0aW9uIHRvIGdldCBhIHNpbmdsZSBJRCBmb3IgdGhlIFhEUA0KPiBwcm9n
cmFtIGF0dGFjaGVkIHRvIHRoZSBpbnRlcmZhY2UuIEhvd2V2ZXIsIGl0IGNhbiBiZSB1c2VmdWwg
dG8gZ2V0IHRoZQ0KPiBmdWxsIHNldCBvZiBwcm9ncmFtIElEcyBhdHRhY2hlZCwgYWxvbmcgd2l0
aCB0aGUgYXR0YWNobWVudCBtb2RlLCBpbiBvbmUNCj4gZ28uIEFkZCBhIG5ldyBnZXR0ZXIgZnVu
Y3Rpb24gdG8gc3VwcG9ydCB0aGlzLCB1c2luZyBhbiBleHRlbmRpYmxlDQo+IHN0cnVjdHVyZSB0
byBjYXJyeSB0aGUgaW5mb3JtYXRpb24uIEV4cHJlc3MgdGhlIG9sZCBicGZfZ2V0X2xpbmtfaWQo
KQ0KPiBmdW5jdGlvbiBpbiB0ZXJtcyBvZiB0aGUgbmV3IGZ1bmN0aW9uLg0KPiANCj4gU2lnbmVk
LW9mZi1ieTogVG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+DQo+IC0t
LQ0KPiB0b29scy9saWIvYnBmL2xpYmJwZi5oICAgfCAgIDEwICsrKysrKw0KPiB0b29scy9saWIv
YnBmL2xpYmJwZi5tYXAgfCAgICAxICsNCj4gdG9vbHMvbGliL2JwZi9uZXRsaW5rLmMgIHwgICA3
OCArKysrKysrKysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tDQo+IDMgZmls
ZXMgY2hhbmdlZCwgNjIgaW5zZXJ0aW9ucygrKSwgMjcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuaCBiL3Rvb2xzL2xpYi9icGYvbGliYnBmLmgN
Cj4gaW5kZXggNmRkYzA0MTkzMzdiLi5mMDk0N2NjOTQ5ZDIgMTAwNjQ0DQo+IC0tLSBhL3Rvb2xz
L2xpYi9icGYvbGliYnBmLmgNCj4gKysrIGIvdG9vbHMvbGliL2JwZi9saWJicGYuaA0KPiBAQCAt
NDI3LDggKzQyNywxOCBAQCBMSUJCUEZfQVBJIGludCBicGZfcHJvZ19sb2FkX3hhdHRyKGNvbnN0
IHN0cnVjdCBicGZfcHJvZ19sb2FkX2F0dHIgKmF0dHIsDQo+IExJQkJQRl9BUEkgaW50IGJwZl9w
cm9nX2xvYWQoY29uc3QgY2hhciAqZmlsZSwgZW51bSBicGZfcHJvZ190eXBlIHR5cGUsDQo+IAkJ
CSAgICAgc3RydWN0IGJwZl9vYmplY3QgKipwb2JqLCBpbnQgKnByb2dfZmQpOw0KPiANCj4gK3N0
cnVjdCB4ZHBfbGlua19pbmZvIHsNCj4gKwlfX3UzMiBwcm9nX2lkOw0KPiArCV9fdTMyIGRydl9w
cm9nX2lkOw0KPiArCV9fdTMyIGh3X3Byb2dfaWQ7DQo+ICsJX191MzIgc2tiX3Byb2dfaWQ7DQo+
ICsJX191OCBhdHRhY2hfbW9kZTsNCj4gK307DQo+ICsNCj4gTElCQlBGX0FQSSBpbnQgYnBmX3Nl
dF9saW5rX3hkcF9mZChpbnQgaWZpbmRleCwgaW50IGZkLCBfX3UzMiBmbGFncyk7DQo+IExJQkJQ
Rl9BUEkgaW50IGJwZl9nZXRfbGlua194ZHBfaWQoaW50IGlmaW5kZXgsIF9fdTMyICpwcm9nX2lk
LCBfX3UzMiBmbGFncyk7DQo+ICtMSUJCUEZfQVBJIGludCBicGZfZ2V0X2xpbmtfeGRwX2luZm8o
aW50IGlmaW5kZXgsIHN0cnVjdCB4ZHBfbGlua19pbmZvICppbmZvLA0KPiArCQkJCSAgICAgc2l6
ZV90IGluZm9fc2l6ZSwgX191MzIgZmxhZ3MpOw0KPiANCj4gc3RydWN0IHBlcmZfYnVmZmVyOw0K
PiANCj4gZGlmZiAtLWdpdCBhL3Rvb2xzL2xpYi9icGYvbGliYnBmLm1hcCBiL3Rvb2xzL2xpYi9i
cGYvbGliYnBmLm1hcA0KPiBpbmRleCA4NjE3M2NiYjE1OWQuLjQ1ZjIyOWFmMjc2NiAxMDA2NDQN
Cj4gLS0tIGEvdG9vbHMvbGliL2JwZi9saWJicGYubWFwDQo+ICsrKyBiL3Rvb2xzL2xpYi9icGYv
bGliYnBmLm1hcA0KPiBAQCAtMjAyLDQgKzIwMiw1IEBAIExJQkJQRl8wLjAuNiB7DQo+IAkJYnBm
X3Byb2dyYW1fX2dldF90eXBlOw0KPiAJCWJwZl9wcm9ncmFtX19pc190cmFjaW5nOw0KPiAJCWJw
Zl9wcm9ncmFtX19zZXRfdHJhY2luZzsNCj4gKwkJYnBmX2dldF9saW5rX3hkcF9pbmZvOw0KDQpQ
bGVhc2Uga2VlcCB0aGVzZSBlbnRyaWVzIGluIGFscGhhYmV0aWMgb3JkZXIuIA0KDQpKdXN0IGZv
dW5kIEkgYWRkZWQgbW9zdCBvdXQtb2Ytb3JkZXIgZW50cmllcy4gOigNCg0KT3RoZXIgdGhhbiB0
aGlzDQoNCkFja2VkLWJ5OiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KDQo=
