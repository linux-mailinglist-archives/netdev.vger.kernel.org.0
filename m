Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B96333BA3
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:59:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfFCW7N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:59:13 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:51928 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726025AbfFCW7N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:59:13 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x53MsNZq002029;
        Mon, 3 Jun 2019 15:58:23 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=8WcOpp74X8zfixZNPEl/xpvkqmkWd5QCBGPPFOrruQ0=;
 b=CKhNwItwD/rH33gD9xaipYrqP+F8PouDLiFwz21Pc+LirKrdj8TghRw3xAavEQHbeMEK
 Lttrx6aTsieqUGmqjDPIyCHgWNBCPuTupu4l5R16myJBjz+zLn+02f8v2t4ZfIjS/zvz
 zGENvL04AZ5OCmgLlwqCiiKctx5ZBzuq7X8= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2swbg0093p-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 03 Jun 2019 15:58:23 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub02.TheFacebook.com (2620:10d:c081:35::126) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 3 Jun 2019 15:58:22 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 3 Jun 2019 15:58:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8WcOpp74X8zfixZNPEl/xpvkqmkWd5QCBGPPFOrruQ0=;
 b=rzpSVAWf/S6/wZuiviRtl7ge3CaHDnNVv8IvmNzUuPDJoLGO7fA/uvz1xxEApNUFB4A7CHXCf4/VfwuYkrzE2ZsQ2inAkHVcu8lC3vopM82gYdh8OuMCak7NAwjMxfbHIEwRfZxANRY+SzlJSlWpoeXe2aviwNqsJeLf3Ixm7+c=
Received: from MWHPR15MB1262.namprd15.prod.outlook.com (10.175.3.141) by
 MWHPR15MB1839.namprd15.prod.outlook.com (10.174.255.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Mon, 3 Jun 2019 22:58:20 +0000
Received: from MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc]) by MWHPR15MB1262.namprd15.prod.outlook.com
 ([fe80::80df:7291:9855:e8bc%8]) with mapi id 15.20.1943.018; Mon, 3 Jun 2019
 22:58:20 +0000
From:   Matt Mullins <mmullins@fb.com>
To:     "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Hall <hall@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
Thread-Topic: [PATCH bpf v2] bpf: preallocate a perf_sample_data per event fd
Thread-Index: AQHVGAF59w/lvxC2rk6cErnZnaX1kaaJ6uwAgAADyACAAKCpAA==
Date:   Mon, 3 Jun 2019 22:58:20 +0000
Message-ID: <05626702394f7b95273ab19fef30461677779333.camel@fb.com>
References: <20190531223735.4998-1-mmullins@fb.com>
         <6c6a4d47-796a-20e2-eb12-503a00d1fa0b@iogearbox.net>
         <68841715-4d5b-6ad1-5241-4e7199dd63da@iogearbox.net>
In-Reply-To: <68841715-4d5b-6ad1-5241-4e7199dd63da@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.1 
x-originating-ip: [2620:10d:c090:200::2:6bd5]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d672b6fe-9186-468a-2fb6-08d6e876f936
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:MWHPR15MB1839;
x-ms-traffictypediagnostic: MWHPR15MB1839:
x-microsoft-antispam-prvs: <MWHPR15MB183943A3DE10FA0E4010C0A9B0140@MWHPR15MB1839.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0057EE387C
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(346002)(39860400002)(376002)(366004)(396003)(51444003)(189003)(199004)(446003)(66476007)(66556008)(64756008)(66446008)(76116006)(46003)(73956011)(81166006)(6246003)(81156014)(102836004)(8676002)(50226002)(6486002)(118296001)(66946007)(229853002)(76176011)(86362001)(14454004)(2501003)(2201001)(71190400001)(71200400001)(186003)(478600001)(99286004)(256004)(14444005)(5024004)(53546011)(6506007)(53936002)(6116002)(2616005)(6436002)(486006)(476003)(316002)(4326008)(110136005)(25786009)(5660300002)(8936002)(11346002)(305945005)(36756003)(68736007)(54906003)(7736002)(2906002)(6512007)(99106002);DIR:OUT;SFP:1102;SCL:1;SRVR:MWHPR15MB1839;H:MWHPR15MB1262.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: ig4tZbYEK4RngD4QwJX+cwnLR3uN/2NPpvuA8tPFN/Uof3NvHOjqKo1cxqU3Ifg3ST+3bR86HObnChA0q5vVUBvTOhsBs7B0p0XqToNiaGWKg78fE1QA6vObQgnCBxmYdF3XyS8MwHbms9zPCoDiBQuS+RsXLl69r6yyDR2oWKWmDfCrNSTaD1R2HE++TXsRjo1taXQCI1w4jK/azl0jLvN60T2qgqUSkTd29pwFMqDWEbrHmpeO77hiWwp7+JK2d9K2DFtVI4I/PuIbKMTcISmQvDdVIFWYi9C/bDgD7iF4XZY6IHTnzT2E5FGUvV72T+oae70UNZk+rQOMxodmiYvPjDT/YRPA7nARXgsJVtclcUA1gSy1DO2XSQobIgQwNgcEOzhvGG1YyTC3ANIedt6qC3ZEsMNhCw6yAIFMKho=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C6AF67AF5CEC5D4FBBA8E194EF363257@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: d672b6fe-9186-468a-2fb6-08d6e876f936
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2019 22:58:20.2495
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mmullins@fb.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR15MB1839
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-03_18:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030154
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA2LTAzIGF0IDE1OjIyICswMjAwLCBEYW5pZWwgQm9ya21hbm4gd3JvdGU6
DQo+IE9uIDA2LzAzLzIwMTkgMDM6MDggUE0sIERhbmllbCBCb3JrbWFubiB3cm90ZToNCj4gPiBP
biAwNi8wMS8yMDE5IDEyOjM3IEFNLCBNYXR0IE11bGxpbnMgd3JvdGU6DQo+ID4gPiBJdCBpcyBw
b3NzaWJsZSB0aGF0IGEgQlBGIHByb2dyYW0gY2FuIGJlIGNhbGxlZCB3aGlsZSBhbm90aGVyIEJQ
Rg0KPiA+ID4gcHJvZ3JhbSBpcyBleGVjdXRpbmcgYnBmX3BlcmZfZXZlbnRfb3V0cHV0LiAgVGhp
cyBoYXMgYmVlbiBvYnNlcnZlZCB3aXRoDQo+ID4gPiBJL08gY29tcGxldGlvbiBvY2N1cnJpbmcg
YXMgYSByZXN1bHQgb2YgYW4gaW50ZXJydXB0Og0KPiA+ID4gDQo+ID4gPiAJYnBmX3Byb2dfMjQ3
ZmQxMzQxY2RkYWVhNF90cmFjZV9yZXFfZW5kKzB4OGQ3LzB4MTAwMA0KPiA+ID4gCT8gdHJhY2Vf
Y2FsbF9icGYrMHg4Mi8weDEwMA0KPiA+ID4gCT8gc2NoX2RpcmVjdF94bWl0KzB4ZTIvMHgyMzAN
Cj4gPiA+IAk/IGJsa19tcV9lbmRfcmVxdWVzdCsweDEvMHgxMDANCj4gPiA+IAk/IGJsa19tcV9l
bmRfcmVxdWVzdCsweDUvMHgxMDANCj4gPiA+IAk/IGtwcm9iZV9wZXJmX2Z1bmMrMHgxOWIvMHgy
NDANCj4gPiA+IAk/IF9fcWRpc2NfcnVuKzB4ODYvMHg1MjANCj4gPiA+IAk/IGJsa19tcV9lbmRf
cmVxdWVzdCsweDEvMHgxMDANCj4gPiA+IAk/IGJsa19tcV9lbmRfcmVxdWVzdCsweDUvMHgxMDAN
Cj4gPiA+IAk/IGtwcm9iZV9mdHJhY2VfaGFuZGxlcisweDkwLzB4ZjANCj4gPiA+IAk/IGZ0cmFj
ZV9vcHNfYXNzaXN0X2Z1bmMrMHg2ZS8weGUwDQo+ID4gPiAJPyBpcDZfaW5wdXRfZmluaXNoKzB4
YmYvMHg0NjANCj4gPiA+IAk/IDB4ZmZmZmZmZmZhMDFlODBiZg0KPiA+ID4gCT8gbmJkX2RiZ19m
bGFnc19zaG93KzB4YzAvMHhjMCBbbmJkXQ0KPiA+ID4gCT8gYmxrZGV2X2lzc3VlX3plcm9vdXQr
MHgyMDAvMHgyMDANCj4gPiA+IAk/IGJsa19tcV9lbmRfcmVxdWVzdCsweDEvMHgxMDANCj4gPiA+
IAk/IGJsa19tcV9lbmRfcmVxdWVzdCsweDUvMHgxMDANCj4gPiA+IAk/IGZsdXNoX3NtcF9jYWxs
X2Z1bmN0aW9uX3F1ZXVlKzB4NmMvMHhlMA0KPiA+ID4gCT8gc21wX2NhbGxfZnVuY3Rpb25fc2lu
Z2xlX2ludGVycnVwdCsweDMyLzB4YzANCj4gPiA+IAk/IGNhbGxfZnVuY3Rpb25fc2luZ2xlX2lu
dGVycnVwdCsweGYvMHgyMA0KPiA+ID4gCT8gY2FsbF9mdW5jdGlvbl9zaW5nbGVfaW50ZXJydXB0
KzB4YS8weDIwDQo+ID4gPiAJPyBzd2lvdGxiX21hcF9wYWdlKzB4MTQwLzB4MTQwDQo+ID4gPiAJ
PyByZWZjb3VudF9zdWJfYW5kX3Rlc3QrMHgxYS8weDUwDQo+ID4gPiAJPyB0Y3Bfd2ZyZWUrMHgy
MC8weGYwDQo+ID4gPiAJPyBza2JfcmVsZWFzZV9oZWFkX3N0YXRlKzB4NjIvMHhjMA0KPiA+ID4g
CT8gc2tiX3JlbGVhc2VfYWxsKzB4ZS8weDMwDQo+ID4gPiAJPyBuYXBpX2NvbnN1bWVfc2tiKzB4
YjUvMHgxMDANCj4gPiA+IAk/IG1seDVlX3BvbGxfdHhfY3ErMHgxZGYvMHg0ZTANCj4gPiA+IAk/
IG1seDVlX3BvbGxfdHhfY3ErMHgzOGMvMHg0ZTANCj4gPiA+IAk/IG1seDVlX25hcGlfcG9sbCsw
eDU4LzB4YzMwDQo+ID4gPiAJPyBtbHg1ZV9uYXBpX3BvbGwrMHgyMzIvMHhjMzANCj4gPiA+IAk/
IG5ldF9yeF9hY3Rpb24rMHgxMjgvMHgzNDANCj4gPiA+IAk/IF9fZG9fc29mdGlycSsweGQ0LzB4
MmFkDQo+ID4gPiAJPyBpcnFfZXhpdCsweGE1LzB4YjANCj4gPiA+IAk/IGRvX0lSUSsweDdkLzB4
YzANCj4gPiA+IAk/IGNvbW1vbl9pbnRlcnJ1cHQrMHhmLzB4Zg0KPiA+ID4gCTwvSVJRPg0KPiA+
ID4gCT8gX19yYl9mcmVlX2F1eCsweGYwLzB4ZjANCj4gPiA+IAk/IHBlcmZfb3V0cHV0X3NhbXBs
ZSsweDI4LzB4N2IwDQo+ID4gPiAJPyBwZXJmX3ByZXBhcmVfc2FtcGxlKzB4NTQvMHg0YTANCj4g
PiA+IAk/IHBlcmZfZXZlbnRfb3V0cHV0KzB4NDMvMHg2MA0KPiA+ID4gCT8gYnBmX3BlcmZfZXZl
bnRfb3V0cHV0X3Jhd190cCsweDE1Zi8weDE4MA0KPiA+ID4gCT8gYmxrX21xX3N0YXJ0X3JlcXVl
c3QrMHgxLzB4MTIwDQo+ID4gPiAJPyBicGZfcHJvZ180MTFhNjRhNzA2ZmM2MDQ0X3Nob3VsZF90
cmFjZSsweGFkNC8weDEwMDANCj4gPiA+IAk/IGJwZl90cmFjZV9ydW4zKzB4MmMvMHg4MA0KPiA+
ID4gCT8gbmJkX3NlbmRfY21kKzB4NGMyLzB4NjkwIFtuYmRdDQo+ID4gPiANCj4gPiA+IFRoaXMg
YWxzbyBjYW5ub3QgYmUgYWxsZXZpYXRlZCBieSBmdXJ0aGVyIHNwbGl0dGluZyB0aGUgcGVyLWNw
dQ0KPiA+ID4gcGVyZl9zYW1wbGVfZGF0YSBzdHJ1Y3RzIChhcyBpbiBjb21taXQgMjgzY2E1MjZh
OWJkICgiYnBmOiBmaXgNCj4gPiA+IGNvcnJ1cHRpb24gb24gY29uY3VycmVudCBwZXJmX2V2ZW50
X291dHB1dCBjYWxscyIpKSwgYXMgYSByYXdfdHAgY291bGQNCj4gPiA+IGJlIGF0dGFjaGVkIHRv
IHRoZSBibG9jazpibG9ja19ycV9jb21wbGV0ZSB0cmFjZXBvaW50IGFuZCBleGVjdXRlIGR1cmlu
Zw0KPiA+ID4gYW5vdGhlciByYXdfdHAuICBJbnN0ZWFkLCBrZWVwIGEgcHJlLWFsbG9jYXRlZCBw
ZXJmX3NhbXBsZV9kYXRhDQo+ID4gPiBzdHJ1Y3R1cmUgcGVyIHBlcmZfZXZlbnRfYXJyYXkgZWxl
bWVudCBhbmQgZmFpbCBhIGJwZl9wZXJmX2V2ZW50X291dHB1dA0KPiA+ID4gaWYgdGhhdCBlbGVt
ZW50IGlzIGNvbmN1cnJlbnRseSBiZWluZyB1c2VkLg0KPiA+ID4gDQo+ID4gPiBGaXhlczogMjBi
OWQ3YWM0ODUyICgiYnBmOiBhdm9pZCBleGNlc3NpdmUgc3RhY2sgdXNhZ2UgZm9yIHBlcmZfc2Ft
cGxlX2RhdGEiKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTWF0dCBNdWxsaW5zIDxtbXVsbGluc0Bm
Yi5jb20+DQo+ID4gDQo+ID4gWW91IGRvIG5vdCBlbGFib3JhdGUgd2h5IGlzIHRoaXMgbmVlZGVk
IGZvciBhbGwgdGhlIG5ldHdvcmtpbmcgcHJvZ3JhbXMgdGhhdA0KPiA+IHVzZSB0aGlzIGZ1bmN0
aW9uYWxpdHkuIFRoZSBicGZfbWlzY19zZCBzaG91bGQgdGhlcmVmb3JlIGJlIGtlcHQgYXMtaXMu
IFRoZXJlDQo+ID4gY2Fubm90IGJlIG5lc3RlZCBvY2N1cnJlbmNlcyB0aGVyZSAoeGRwLCB0YyBp
bmdyZXNzL2VncmVzcykuIFBsZWFzZSBleHBsYWluIHdoeQ0KPiA+IG5vbi10cmFjaW5nIHNob3Vs
ZCBiZSBhZmZlY3RlZCBoZXJlLi4uDQoNCklmIHRoZXNlIGFyZSBpbnZhcmlhYmx5IG5vbi1uZXN0
ZWQsIEkgY2FuIGVhc2lseSBrZWVwIGJwZl9taXNjX3NkIHdoZW4NCkkgcmVzdWJtaXQuICBUaGVy
ZSB3YXMgbm8gdGVjaG5pY2FsIHJlYXNvbiBvdGhlciB0aGFuIGtlZXBpbmcgdGhlIHR3bw0KY29k
ZXBhdGhzIGFzIHNpbWlsYXIgYXMgcG9zc2libGUuDQoNCldoYXQgcmVzb3VyY2UgZ2l2ZXMgeW91
IHdvcnJ5IGFib3V0IGRvaW5nIHRoaXMgZm9yIHRoZSBuZXR3b3JraW5nDQpjb2RlcGF0aD8NCg0K
PiBBc2lkZSBmcm9tIHRoYXQgaXQncyBhbHNvIHJlYWxseSBiYWQgdG8gbWlzcyBldmVudHMgbGlr
ZSB0aGlzIGFzIGV4cG9ydGluZw0KPiB0aHJvdWdoIHJiIGlzIGNyaXRpY2FsLiBXaHkgY2FuJ3Qg
eW91IGhhdmUgYSBwZXItQ1BVIGNvdW50ZXIgdGhhdCBzZWxlY3RzIGENCj4gc2FtcGxlIGRhdGEg
Y29udGV4dCBiYXNlZCBvbiBuZXN0aW5nIGxldmVsIGluIHRyYWNpbmc/IChJIGRvbid0IHNlZSBh
IGRpc2N1c3Npb24NCj4gb2YgdGhpcyBpbiB5b3VyIGNvbW1pdCBtZXNzYWdlLikNCg0KVGhpcyBj
aGFuZ2Ugd291bGQgb25seSBkcm9wIG1lc3NhZ2VzIGlmIHRoZSBzYW1lIHBlcmZfZXZlbnQgaXMN
CmF0dGVtcHRlZCB0byBiZSB1c2VkIHJlY3Vyc2l2ZWx5IChpLmUuIHRoZSBzYW1lIENQVSBvbiB0
aGUgc2FtZQ0KUEVSRl9FVkVOVF9BUlJBWSBtYXAsIGFzIEkgaGF2ZW4ndCBvYnNlcnZlZCBhbnl0
aGluZyB1c2UgaW5kZXggIT0NCkJQRl9GX0NVUlJFTlRfQ1BVIGluIHRlc3RpbmcpLg0KDQpJJ2xs
IHRyeSB0byBhY2NvbXBsaXNoIHRoZSBzYW1lIHdpdGggYSBwZXJjcHUgbmVzdGluZyBsZXZlbCBh
bmQNCmFsbG9jYXRpbmcgMiBvciAzIHBlcmZfc2FtcGxlX2RhdGEgcGVyIGNwdS4gIEkgdGhpbmsg
dGhhdCdsbCBzb2x2ZSB0aGUNCnNhbWUgcHJvYmxlbSAtLSBhIGxvY2FsIHBhdGNoIGtlZXBpbmcg
dHJhY2sgb2YgdGhlIG5lc3RpbmcgbGV2ZWwgaXMgaG93DQpJIGdvdCB0aGUgYWJvdmUgc3RhY2sg
dHJhY2UsIHRvby4NCg==
