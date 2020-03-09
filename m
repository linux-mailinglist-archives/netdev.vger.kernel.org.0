Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 878BA17E708
	for <lists+netdev@lfdr.de>; Mon,  9 Mar 2020 19:24:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbgCISYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 14:24:42 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58262 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727334AbgCISYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 14:24:41 -0400
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 029ILE4B027748;
        Mon, 9 Mar 2020 11:24:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=bq70oRw2t9nozAtZeqGqTgH8o2pi/uxwmkHk9FFuUtM=;
 b=cM8LrA3ZxMq5mOpK6qrdTgvRN0cHZFAxE/RJjTkdx/W1fBEfof/7AV9VTHgySLBOf1bw
 EYfED5Fwl1iKgG9RiZZbAHm83rKCbp3cdzteWpiaYwE1lelenZEKMRwWRCpKRFnFpxdH
 gAJXJqc1i3xWNXlvEO5UWyVEcJC9fN52giA= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2ymv6jp1m7-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 09 Mar 2020 11:24:24 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1847.3; Mon, 9 Mar 2020 11:24:23 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Uwtqfvuvwp8oRPQmOUEthJd90xJ1TXByNqfI9WUUi7cRcJcLgSzeo2tU5wnRHAjAzNlWut84FfQeQzzWi16wyC5WmB9qWZ3k3eLZChQR8LcHtxhennnCiOBGOwigjznWThs543x11jz42pGMyif+RN1NsmfTXEBpZKx+tr63t+V1arR/Ttyg7YMwBKgl6YmOsTCuD+7ihHQn0TtU6/Ij7t0tC8GxgBg2hhTEl4Gj6hmBspsPZq2Hw+6gLgOXCqrEgTEYGFyg8av7vOJ4NJ1wxkCdIzIbudtaUzgwdaNVeW8LiOO/0Gtqa8GeqgzBpUbCxtTsoPpkHVbqd31cOszgEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq70oRw2t9nozAtZeqGqTgH8o2pi/uxwmkHk9FFuUtM=;
 b=Sx44Ah8kwv4zgXQHUELVPv4HhQlTzUgIuYM5WiF69n5RdNkPcqw30WzTxifwEuoHkZ3ehmhIdYmmDtLoPBRfNbjrI13VypmCdEOQBOpaxL1X5/wMBos9hNCxrOtmvjXs/2frUeChvFYZlXcCoWgJETfSoq3VQA3y+1bvJTi8OdBhT7YehM6q5IJF7UbJeyOcc32UonOvlOfiI16m9UXgtmUN8zbc39Z0LJleYgzv5EtkqSPsmQERxlT/1MAxa+7aex0bP/CHysQyMrxDbas4skrsDzR456vuWKARgElYRgun5s9g1/cSvaVvkBeERHr+Ddkq4/YbnM5gc37bGbSvdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bq70oRw2t9nozAtZeqGqTgH8o2pi/uxwmkHk9FFuUtM=;
 b=DemXAYTSNMb7YYEWkC4g93S6s9iV9usY8KGtIkKVR3MkZ2LV9gPheBOx/aNR7iComIl9yCMz/iT7vOgoAPCb0jboKBPd4JAxOL/WVvzjnSV3l8dT97tAZNTwUl8XDxnKEDOc0Rpqo66te94sw9sOxeNdaLKnCLulRdXRFdi2B5k=
Received: from MW3PR15MB3882.namprd15.prod.outlook.com (2603:10b6:303:49::11)
 by MW3PR15MB3977.namprd15.prod.outlook.com (2603:10b6:303:4d::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2793.17; Mon, 9 Mar
 2020 18:24:22 +0000
Received: from MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5]) by MW3PR15MB3882.namprd15.prod.outlook.com
 ([fe80::c570:6c46:cc47:5ca5%5]) with mapi id 15.20.2793.013; Mon, 9 Mar 2020
 18:24:22 +0000
From:   Song Liu <songliubraving@fb.com>
To:     Quentin Monnet <quentin@isovalent.com>
CC:     Jiri Olsa <jolsa@redhat.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Kernel Team <Kernel-team@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "arnaldo.melo@gmail.com" <arnaldo.melo@gmail.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Thread-Topic: [PATCH v4 bpf-next 0/4] bpftool: introduce prog profile
Thread-Index: AQHV8k/ID7Brhxz/CkyCD9Xa6Igk7Kg4y9qAgAAaOACAAAmkAIAAA6WAgAAC5QCAB5+KAIAABX8A
Date:   Mon, 9 Mar 2020 18:24:22 +0000
Message-ID: <37D64185-5E90-49B4-A6EA-D5E77ACF9D1F@fb.com>
References: <20200304180710.2677695-1-songliubraving@fb.com>
 <20200304190807.GA168640@krava> <20200304204158.GD168640@krava>
 <C7C4E8E1-9176-48DC-8089-D4AEDE86E720@fb.com> <20200304212931.GE168640@krava>
 <4C0824FE-37CB-4660-BAE0-0EAE8F6BF8A0@fb.com>
 <4d3b2e44-48bd-ece2-a1c7-16b7950bc472@isovalent.com>
In-Reply-To: <4d3b2e44-48bd-ece2-a1c7-16b7950bc472@isovalent.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.60.0.2.5)
x-originating-ip: [2620:10d:c090:400::5:8d2e]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b388267a-79f4-43ae-e370-08d7c457173d
x-ms-traffictypediagnostic: MW3PR15MB3977:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR15MB397763E2A252E4F791463647B3FE0@MW3PR15MB3977.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:2449;
x-forefront-prvs: 0337AFFE9A
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(376002)(396003)(346002)(39860400002)(366004)(136003)(189003)(199004)(5660300002)(478600001)(316002)(71200400001)(33656002)(53546011)(66446008)(6512007)(64756008)(76116006)(66476007)(86362001)(66556008)(6506007)(66946007)(2616005)(54906003)(2906002)(966005)(6916009)(186003)(4326008)(6486002)(36756003)(81166006)(8676002)(8936002)(81156014);DIR:OUT;SFP:1102;SCL:1;SRVR:MW3PR15MB3977;H:MW3PR15MB3882.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: RydJ/ujYZw4ngYxOxHn5RGYoG1qRYnWYWY/2oHegIABazc0ps+YCdNFfJqYvWUTLOTq20jOqMaqpXIYMXWG+uPOJF3JG14VqOJRt1M8W6mBjcGgfLoDqcnOUwW7kqKhNarrPJDK0o2xxJ/Rjb1Rb361LAsjk1BOfVq7+f2iA/zGiIFE2EJ69COXpcDw9yKEWC4EV4hg9ZH2z9ZHBUO5gZIH5/3pIBniz1XhJKP+1FihlbhxzoAmscSnkOtdMY55L9mYoyyUXAw7g4jZOgyU1SUj0jECAjsDC4YKIiltjDkYoasPY9/u+yi+hjg3znGkrzGafcNcTrey9GtnYi4dROXNl8q4zBAxot0B+spWch+tF5QxlTsqLi3PmyzwhCw2I/12TmrL9ZJJGPFTabLsOyjnsIK0qtd1JBDjYxE07uQQGQyeaaPsgsEKtCCv88073ZI6V4uIHeXrcCInX15QCJyb6yuEfoyk0O6v01SBnaeusia5Jzj8lxv1YAXcTqHTs5h5q7VeBWKtBDO/arTeWZQ==
x-ms-exchange-antispam-messagedata: f4y697TwVeygvxoF0i30my+i8TOpzOLRTS/3HhARITqV9jFx4sOQMVPwSNDzP+BUiknoAwUleuZtoleEPCYO3I1QYMWMUFuX0e5m5symGKfsTNeA8yQJ/vGUs+DokGu5FkKyq+eB3+XvkfRWvdGaCUGPuxcFuHE7tWsJa2skngRePx707g8RTjZFqf6dyaC6
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D29343A604EC249A447F86F01B2C1D9@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: b388267a-79f4-43ae-e370-08d7c457173d
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2020 18:24:22.6349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IzorUPDFxxqlKU6O7MMp8COmMamAXjry5DNTx7llQhAaYFbYmPycZQY0nkbKbTeSsx4bo0UTZQ+nD74E56SiIw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR15MB3977
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-03-09_06:2020-03-09,2020-03-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 bulkscore=0 phishscore=0
 impostorscore=0 spamscore=0 suspectscore=0 malwarescore=0
 priorityscore=1501 adultscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 clxscore=1015 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2001150001 definitions=main-2003090112
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gTWFyIDksIDIwMjAsIGF0IDExOjA0IEFNLCBRdWVudGluIE1vbm5ldCA8cXVlbnRp
bkBpc292YWxlbnQuY29tPiB3cm90ZToNCj4gDQo+IDIwMjAtMDMtMDQgMjE6MzkgVVRDKzAwMDAg
fiBTb25nIExpdSA8c29uZ2xpdWJyYXZpbmdAZmIuY29tPg0KPj4gDQo+PiANCj4+PiBPbiBNYXIg
NCwgMjAyMCwgYXQgMToyOSBQTSwgSmlyaSBPbHNhIDxqb2xzYUByZWRoYXQuY29tPiB3cm90ZToN
Cj4+PiANCj4+PiBPbiBXZWQsIE1hciAwNCwgMjAyMCBhdCAwOToxNjoyOVBNICswMDAwLCBTb25n
IExpdSB3cm90ZToNCj4+Pj4gDQo+Pj4+IA0KPj4+Pj4gT24gTWFyIDQsIDIwMjAsIGF0IDEyOjQx
IFBNLCBKaXJpIE9sc2EgPGpvbHNhQHJlZGhhdC5jb20+IHdyb3RlOg0KPj4+Pj4gDQo+Pj4+PiBP
biBXZWQsIE1hciAwNCwgMjAyMCBhdCAwODowODowN1BNICswMTAwLCBKaXJpIE9sc2Egd3JvdGU6
DQo+Pj4+Pj4gT24gV2VkLCBNYXIgMDQsIDIwMjAgYXQgMTA6MDc6MDZBTSAtMDgwMCwgU29uZyBM
aXUgd3JvdGU6DQo+Pj4+Pj4+IFRoaXMgc2V0IGludHJvZHVjZXMgYnBmdG9vbCBwcm9nIHByb2Zp
bGUgY29tbWFuZCwgd2hpY2ggdXNlcyBoYXJkd2FyZQ0KPj4+Pj4+PiBjb3VudGVycyB0byBwcm9m
aWxlIEJQRiBwcm9ncmFtcy4NCj4+Pj4+Pj4gDQo+Pj4+Pj4+IFRoaXMgY29tbWFuZCBhdHRhY2hl
cyBmZW50cnkvZmV4aXQgcHJvZ3JhbXMgdG8gYSB0YXJnZXQgcHJvZ3JhbS4gVGhlc2UgdHdvDQo+
Pj4+Pj4+IHByb2dyYW1zIHJlYWQgaGFyZHdhcmUgY291bnRlcnMgYmVmb3JlIGFuZCBhZnRlciB0
aGUgdGFyZ2V0IHByb2dyYW0gYW5kDQo+Pj4+Pj4+IGNhbGN1bGF0ZSB0aGUgZGlmZmVyZW5jZS4N
Cj4+Pj4+Pj4gDQo+Pj4+Pj4+IENoYW5nZXMgdjMgPT4gdjQ6DQo+Pj4+Pj4+IDEuIFNpbXBsaWZ5
IGVyciBoYW5kbGluZyBpbiBwcm9maWxlX29wZW5fcGVyZl9ldmVudHMoKSAoUXVlbnRpbik7DQo+
Pj4+Pj4+IDIuIFJlbW92ZSByZWR1bmRhbnQgcF9lcnIoKSAoUXVlbnRpbik7DQo+Pj4+Pj4+IDMu
IFJlcGxhY2UgdGFiIHdpdGggc3BhY2UgaW4gYmFzaC1jb21wbGV0aW9uOyAoUXVlbnRpbik7DQo+
Pj4+Pj4+IDQuIEZpeCB0eXBvIF9icGZ0b29sX2dldF9tYXBfbmFtZXMgPT4gX2JwZnRvb2xfZ2V0
X3Byb2dfbmFtZXMgKFF1ZW50aW4pLg0KPj4+Pj4+IA0KPj4+Pj4+IGh1bSwgSSdtIGdldHRpbmc6
DQo+Pj4+Pj4gDQo+Pj4+Pj4gCVtqb2xzYUBkZWxsLXI0NDAtMDEgYnBmdG9vbF0kIHB3ZA0KPj4+
Pj4+IAkvaG9tZS9qb2xzYS9saW51eC1wZXJmL3Rvb2xzL2JwZi9icGZ0b29sDQo+Pj4+Pj4gCVtq
b2xzYUBkZWxsLXI0NDAtMDEgYnBmdG9vbF0kIG1ha2UNCj4+Pj4+PiAJLi4uDQo+Pj4+Pj4gCW1h
a2VbMV06IExlYXZpbmcgZGlyZWN0b3J5ICcvaG9tZS9qb2xzYS9saW51eC1wZXJmL3Rvb2xzL2xp
Yi9icGYnDQo+Pj4+Pj4gCSAgTElOSyAgICAgX2JwZnRvb2wNCj4+Pj4+PiAJbWFrZTogKioqIE5v
IHJ1bGUgdG8gbWFrZSB0YXJnZXQgJ3NrZWxldG9uL3Byb2ZpbGVyLmJwZi5jJywgbmVlZGVkIGJ5
ICdza2VsZXRvbi9wcm9maWxlci5icGYubycuICBTdG9wLg0KPj4+Pj4gDQo+Pj4+PiBvaywgSSBo
YWQgdG8gYXBwbHkgeW91ciBwYXRjaGVzIGJ5IGhhbmQsIGJlY2F1c2UgJ2dpdCBhbScgcmVmdXNl
ZCB0bw0KPj4+Pj4gZHVlIHRvIGZ1enouLiBzbyBzb21lIG9mIHlvdSBuZXcgZmlsZXMgZGlkIG5v
dCBtYWtlIGl0IHRvIG15IHRyZWUgOy0pDQo+Pj4+PiANCj4+Pj4+IGFueXdheSBJIGhpdCBhbm90
aGVyIGVycm9yIG5vdzoNCj4+Pj4+IA0KPj4+Pj4gCSAgQ0MgICAgICAgcHJvZy5vDQo+Pj4+PiAJ
SW4gZmlsZSBpbmNsdWRlZCBmcm9tIHByb2cuYzoxNTUzOg0KPj4+Pj4gCXByb2ZpbGVyLnNrZWwu
aDogSW4gZnVuY3Rpb24g4oCYcHJvZmlsZXJfYnBmX19jcmVhdGVfc2tlbGV0b27igJk6DQo+Pj4+
PiAJcHJvZmlsZXIuc2tlbC5oOjEzNjozNTogZXJyb3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbi
gJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4+Pj4+IAkgIDEzNiB8ICBzLT5t
YXBzWzRdLm1tYXBlZCA9ICh2b2lkICoqKSZvYmotPnJvZGF0YTsNCj4+Pj4+IAkgICAgICB8ICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefg0KPj4+Pj4gCXByb2cuYzogSW4gZnVu
Y3Rpb24g4oCYcHJvZmlsZV9yZWFkX3ZhbHVlc+KAmToNCj4+Pj4+IAlwcm9nLmM6MTY1MDoyOTog
ZXJyb3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbigJkgaGFzIG5vIG1lbWJlciBuYW1lZCDigJhy
b2RhdGHigJkNCj4+Pj4+IAkgMTY1MCB8ICBfX3UzMiBtLCBjcHUsIG51bV9jcHUgPSBvYmotPnJv
ZGF0YS0+bnVtX2NwdTsNCj4+Pj4+IA0KPj4+Pj4gSSdsbCB0cnkgdG8gZmlndXJlIGl0IG91dC4u
IG1pZ2h0IGJlIGVycm9yIG9uIG15IGVuZA0KPj4+Pj4gDQo+Pj4+PiBkbyB5b3UgaGF2ZSBnaXQg
cmVwbyB3aXRoIHRoZXNlIGNoYW5nZXM/DQo+Pj4+IA0KPj4+PiBJIHB1c2hlZCBpdCB0byANCj4+
Pj4gDQo+Pj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9saW51eC9rZXJuZWwvZ2l0
L3NvbmcvbGludXguZ2l0L3RyZWUvP2g9YnBmLXBlci1wcm9nLXN0YXRzDQo+Pj4gDQo+Pj4gc3Rp
bGwgdGhlIHNhbWU6DQo+Pj4gDQo+Pj4gCVtqb2xzYUBkZWxsLXI0NDAtMDEgYnBmdG9vbF0kIGdp
dCBzaG93IC0tb25lbGluZSBIRUFEIHwgaGVhZCAtMQ0KPj4+IAk3YmJkYTVjY2EwMGEgYnBmdG9v
bDogZml4IHR5cG8gaW4gYmFzaC1jb21wbGV0aW9uDQo+Pj4gCVtqb2xzYUBkZWxsLXI0NDAtMDEg
YnBmdG9vbF0kIG1ha2UgDQo+Pj4gCW1ha2VbMV06IEVudGVyaW5nIGRpcmVjdG9yeSAnL2hvbWUv
am9sc2EvbGludXgtcGVyZi90b29scy9saWIvYnBmJw0KPj4+IAltYWtlWzFdOiBMZWF2aW5nIGRp
cmVjdG9yeSAnL2hvbWUvam9sc2EvbGludXgtcGVyZi90b29scy9saWIvYnBmJw0KPj4+IAkgIEND
ICAgICAgIHByb2cubw0KPj4+IAlJbiBmaWxlIGluY2x1ZGVkIGZyb20gcHJvZy5jOjE1NTM6DQo+
Pj4gCXByb2ZpbGVyLnNrZWwuaDogSW4gZnVuY3Rpb24g4oCYcHJvZmlsZXJfYnBmX19jcmVhdGVf
c2tlbGV0b27igJk6DQo+Pj4gCXByb2ZpbGVyLnNrZWwuaDoxMzY6MzU6IGVycm9yOiDigJhzdHJ1
Y3QgcHJvZmlsZXJfYnBm4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCYcm9kYXRh4oCZDQo+Pj4g
CSAgMTM2IHwgIHMtPm1hcHNbNF0ubW1hcGVkID0gKHZvaWQgKiopJm9iai0+cm9kYXRhOw0KPj4+
IAkgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBefg0KPj4+IAlwcm9n
LmM6IEluIGZ1bmN0aW9uIOKAmHByb2ZpbGVfcmVhZF92YWx1ZXPigJk6DQo+Pj4gCXByb2cuYzox
NjUwOjI5OiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVyX2JwZuKAmSBoYXMgbm8gbWVtYmVyIG5h
bWVkIOKAmHJvZGF0YeKAmQ0KPj4+IAkgMTY1MCB8ICBfX3UzMiBtLCBjcHUsIG51bV9jcHUgPSBv
YmotPnJvZGF0YS0+bnVtX2NwdTsNCj4+PiAJICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgXn4NCj4+PiAJcHJvZy5jOiBJbiBmdW5jdGlvbiDigJhwcm9maWxlX29wZW5fcGVyZl9l
dmVudHPigJk6DQo+Pj4gCXByb2cuYzoxODEwOjE5OiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVy
X2JwZuKAmSBoYXMgbm8gbWVtYmVyIG5hbWVkIOKAmHJvZGF0YeKAmQ0KPj4+IAkgMTgxMCB8ICAg
c2l6ZW9mKGludCksIG9iai0+cm9kYXRhLT5udW1fY3B1ICogb2JqLT5yb2RhdGEtPm51bV9tZXRy
aWMpOw0KPj4+IAkgICAgICB8ICAgICAgICAgICAgICAgICAgIF5+DQo+Pj4gCXByb2cuYzoxODEw
OjQyOiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVyX2JwZuKAmSBoYXMgbm8gbWVtYmVyIG5hbWVk
IOKAmHJvZGF0YeKAmQ0KPj4+IAkgMTgxMCB8ICAgc2l6ZW9mKGludCksIG9iai0+cm9kYXRhLT5u
dW1fY3B1ICogb2JqLT5yb2RhdGEtPm51bV9tZXRyaWMpOw0KPj4+IAkgICAgICB8ICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXn4NCj4+PiAJcHJvZy5jOjE4MjU6MjY6
IGVycm9yOiDigJhzdHJ1Y3QgcHJvZmlsZXJfYnBm4oCZIGhhcyBubyBtZW1iZXIgbmFtZWQg4oCY
cm9kYXRh4oCZDQo+Pj4gCSAxODI1IHwgICBmb3IgKGNwdSA9IDA7IGNwdSA8IG9iai0+cm9kYXRh
LT5udW1fY3B1OyBjcHUrKykgew0KPj4+IAkgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAg
ICBefg0KPj4+IAlwcm9nLmM6IEluIGZ1bmN0aW9uIOKAmGRvX3Byb2ZpbGXigJk6DQo+Pj4gCXBy
b2cuYzoxOTA0OjEzOiBlcnJvcjog4oCYc3RydWN0IHByb2ZpbGVyX2JwZuKAmSBoYXMgbm8gbWVt
YmVyIG5hbWVkIOKAmHJvZGF0YeKAmQ0KPj4+IAkgMTkwNCB8ICBwcm9maWxlX29iai0+cm9kYXRh
LT5udW1fY3B1ID0gbnVtX2NwdTsNCj4+PiAJICAgICAgfCAgICAgICAgICAgICBefg0KPj4+IAlw
cm9nLmM6MTkwNToxMzogZXJyb3I6IOKAmHN0cnVjdCBwcm9maWxlcl9icGbigJkgaGFzIG5vIG1l
bWJlciBuYW1lZCDigJhyb2RhdGHigJkNCj4+PiAJIDE5MDUgfCAgcHJvZmlsZV9vYmotPnJvZGF0
YS0+bnVtX21ldHJpYyA9IG51bV9tZXRyaWM7DQo+Pj4gCSAgICAgIHwgICAgICAgICAgICAgXn4N
Cj4+PiAJbWFrZTogKioqIFtNYWtlZmlsZToxMjk6IHByb2cub10gRXJyb3IgMQ0KPj4gDQo+PiBJ
IGd1ZXNzIHlvdSBuZWVkIGEgbmV3ZXIgdmVyc2lvbiBvZiBjbGFuZyB0aGF0IHN1cHBvcnRzIGds
b2JhbCBkYXRhIGluIEJQRiBwcm9ncmFtcy4gDQo+PiANCj4+IFRoYW5rcywNCj4+IFNvbmcNCj4+
IA0KPiANCj4gVGhpbmtpbmcgYWJvdXQgdGhpcyByZXF1aXJlbWVudCBhZ2Fpbi4uLiBEbyB5b3Ug
dGhpbmsgaXQgd291bGQgYmUgd29ydGgNCj4gYWRkaW5nIChhcyBhIGZvbGxvdy11cCkgYSBmZWF0
dXJlIGNoZWNrIG9uIHRoZSBhdmFpbGFiaWxpdHkgb2YgY2xhbmcNCj4gd2l0aCBnbG9iYWwgZGF0
YSBzdXBwb3J0IHRvIGJwZnRvb2wncyBNYWtlZmlsZT8gU28gdGhhdCB3ZSBjb3VsZCBjb21waWxl
DQo+IG91dCBwcm9ncmFtIHByb2ZpbGluZyBpZiBjbGFuZyBpcyBub3QgcHJlc2VudCBvciBkb2Vz
IG5vdCBzdXBwb3J0IGl0Lg0KPiBKdXN0IGxpa2UgbGliYmZkIHN1cHBvcnQgaXMgb3B0aW9uYWwg
YWxyZWFkeS4NCj4gDQo+IEknbSBhc2tpbmcgbW9zdGx5IGJlY2F1c2UgYSBudW1iZXIgb2YgZGlz
dHJpYnV0aW9ucyBub3cgcGFja2FnZSBicGZ0b29sLA0KPiBhbmQgZS5nLiBVYnVudHUgYnVpbGRz
IGl0IGZyb20ga2VybmVsIHNvdXJjZSB3aGVuIGNyZWF0aW5nIGl0cw0KPiBsaW51eC1pbWFnZXMg
YW5kIGxpbnV4LXRvb2xzLSogcGFja2FnZXMuIEFuZCBJIGFtIHByZXR0eSBzdXJlIHRoZSBidWls
ZA0KPiBlbnZpcm9ubWVudCBkb2VzIG5vdCBoYXZlIGxhdGVzdCBjbGFuZy9MTFZNLCBidXQgaXQg
d291bGQgYmUgZ3JlYXQgdG8NCj4gcmVtYWluIGFibGUgdG8gYnVpbGQgYnBmdG9vbC4NCg0KWWVh
aCwgSSB0aGluayBpdCBpcyBhIGdvb2QgaWRlYS4gU29tZSBtb3JlIE1ha2VmaWxlIGZ1bi4gOykN
Cg0KVGhhbmtzLA0KU29uZw0KDQo=
