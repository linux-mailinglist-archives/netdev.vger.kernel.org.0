Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA4FBDF4F7
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 20:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729869AbfJUSTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 14:19:43 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:18020 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726819AbfJUSTn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 14:19:43 -0400
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9LIILcN020749;
        Mon, 21 Oct 2019 11:19:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=6TI17xhhMWkwtyuuddTnz9xioh0i34QJoMonvDVEl5Y=;
 b=k71Wrwx+ZC5aJGiRWSaWrUyDL49DL2Ma6IC1NVsglj64y9jrsxdC+0ZBvONaEz37dieF
 5OyMnnqxKZUicsw4tZqIy1ylXUR71Z6rw9tWicAWtJVrIsydaot+4rbXoLujZJiu/LIv
 OZA8jfsWKpm/iXlTnJi1lltI/vonutU0/fs= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vrj6hnknd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 21 Oct 2019 11:19:26 -0700
Received: from prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) by
 prn-hub05.TheFacebook.com (2620:10d:c081:35::129) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 21 Oct 2019 11:19:25 -0700
Received: from prn-hub01.TheFacebook.com (2620:10d:c081:35::125) by
 prn-mbx02.TheFacebook.com (2620:10d:c081:6::16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Mon, 21 Oct 2019 11:19:25 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Mon, 21 Oct 2019 11:19:25 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QlkAekgu645gRNU0gCfBkvWOzvYyrOAqGjNEprVwP/hwUE7goapve28vbdyM/Ml2PtQHGtnB/BPy7OMZaUU5TP2TAIgmqXyxUWuUPrVEHncH2eG9oh7F24/PiFZAFCwS4OPzglDoB/r6H3BIUMTvPoNcSg0Zl68C150dZLAlXpGFLXAzOHRNiVVu1OM4ujMcxVqOmzZrcJrr2azL4nb/0FxcOuyFegSbSZ03u/x8jwlLIoE7gU34Rn7HCWD2m4QUJ5BBhKXelePc8/CX1MSeCFgydL0297ptOXCHs23gygJF4HhUaF3WVdu2Ky8rmLj4ngdfEPxKpNpgW4FOau+BkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TI17xhhMWkwtyuuddTnz9xioh0i34QJoMonvDVEl5Y=;
 b=fLta+T83nddhKvTKrCD+VIUnbIM3QZGUqIRKD3xk9t++eU5wmVxEGPElua+eWPXQsJ/WYMtT60q6kZEMWMgMqeGtrB+jDmYXhsrFajR4V65nLz5BwuaJnYivzazX8fWFJUor/BxIzW0ZfiqsVExSMU07d4ZZ3sbgpv3uFjfudXLxTBP+bFK2G9cyQqmJLgAhYjvmxk9G8tMOJlxIiBiFDCHEssrGzGnkChwShBhdQqfulVdY034tDx3v3LHW4oKk+MNiKVQvplUgQEEf2A0TtOvgZ2YH8O8o/baRU7aD4rSrFLa3YhZhc4aQYs2X+iTkc8ibVk+aUg0f795zAU0Q4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6TI17xhhMWkwtyuuddTnz9xioh0i34QJoMonvDVEl5Y=;
 b=GuRwo1dTUd8o4pWZ8fHBr+2v/+UDZOcfUenqe6M1uRFkDWAkapA1crQbKv1bWf2hKZXJR5C5Rm2sdtJFkZCA6iBogk7eAQAY7yU1gYPqMMZ1q6Kuk4SZ9faPDtvN5uU0MwxDqdYffioM+P8FErQHGQRe6HOKaQ5nYU5yA173aWQ=
Received: from BYAPR15MB3384.namprd15.prod.outlook.com (20.179.60.27) by
 BYAPR15MB3062.namprd15.prod.outlook.com (20.178.238.212) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Mon, 21 Oct 2019 18:19:24 +0000
Received: from BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d]) by BYAPR15MB3384.namprd15.prod.outlook.com
 ([fe80::b92c:ebd2:58dc:6b8d%5]) with mapi id 15.20.2347.029; Mon, 21 Oct 2019
 18:19:24 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
CC:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: make LIBBPF_OPTS macro strictly a
 variable declaration
Thread-Topic: [PATCH bpf-next] libbpf: make LIBBPF_OPTS macro strictly a
 variable declaration
Thread-Index: AQHViDCxTp+frmkIDEq5xdIvZNPq7adlVpsAgAAFzICAAAtUAA==
Date:   Mon, 21 Oct 2019 18:19:23 +0000
Message-ID: <e0b21110-3a82-3477-a8e1-1f3e83cf18b3@fb.com>
References: <20191021165744.2116648-1-andriin@fb.com> <87r236ow51.fsf@toke.dk>
 <CAEf4BzYbowT5RT4p4hF2yn4v90qgH0u7AksK7GSXEGuFGEBWnA@mail.gmail.com>
In-Reply-To: <CAEf4BzYbowT5RT4p4hF2yn4v90qgH0u7AksK7GSXEGuFGEBWnA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MW2PR16CA0067.namprd16.prod.outlook.com
 (2603:10b6:907:1::44) To BYAPR15MB3384.namprd15.prod.outlook.com
 (2603:10b6:a03:112::27)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::3:b0db]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7a710e15-9b30-4244-1f05-08d756533335
x-ms-traffictypediagnostic: BYAPR15MB3062:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR15MB3062B527283F5A76089A6432D3690@BYAPR15MB3062.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0197AFBD92
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(376002)(396003)(346002)(39860400002)(366004)(189003)(199004)(486006)(6486002)(229853002)(4326008)(2616005)(6506007)(386003)(53546011)(446003)(99286004)(31686004)(52116002)(46003)(186003)(102836004)(476003)(76176011)(11346002)(6116002)(6246003)(8676002)(14454004)(305945005)(8936002)(6512007)(14444005)(256004)(81166006)(81156014)(316002)(7736002)(2906002)(478600001)(25786009)(110136005)(31696002)(6436002)(54906003)(71200400001)(66446008)(64756008)(66946007)(5660300002)(66476007)(66556008)(66574012)(86362001)(71190400001)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:BYAPR15MB3062;H:BYAPR15MB3384.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: en5LkFv59GsthL/3Lk7uopDQ1OpnDQn7Bgeh+CpUXonAcDm/nHlul3igOxdoOTy3a6l9YH+XKUfXetWeXX8F8cEDtSAd7Jnx2YFdPUBDaUJgbV4A87lfceZ3aBnhHSlSGotlTaCMjrpWgluAK0xN+58oLMK921CtViHd49shMW1KMHFXJGeknokK1XLAOrO6qtcsFlZD3T3l0lo4Uxw6vI+x4Eg/lgd9XBu/ZSOLUkQDi3thJpKGp6dhMjOc+tc8P7tYcIGKMYMT8IMwlk2YRWjC7wU+Mgro1XTrlzH22wrMjWjOFHVW8v4TD0aA574H2ttIj1HP52wy1Xce98afFtWjOcFGQSIXo1/zBjNPRSkmV01k5bqZ2nfdVo79lTI+RbHfVa4WxyNzDJPhHvV7j4WicYB7hKhkKjO3Y0CsNp2ufP4SKH4+5vEc9jQrpPVi
Content-Type: text/plain; charset="utf-8"
Content-ID: <6CEB8C8A1BDB8042A1D1755B7F99C82B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a710e15-9b30-4244-1f05-08d756533335
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Oct 2019 18:19:24.0406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JGdTumh6h1SuFufgC6ye+2nB5hSiBD1YMk3CxlmFY1Ik9gbr/jrpwaWVf1sApOfK
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR15MB3062
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-21_05:2019-10-21,2019-10-21 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 priorityscore=1501
 phishscore=0 malwarescore=0 clxscore=1015 bulkscore=0 mlxlogscore=999
 suspectscore=0 lowpriorityscore=0 mlxscore=0 spamscore=0 adultscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910210175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLzIxLzE5IDEwOjM4IEFNLCBBbmRyaWkgTmFrcnlpa28gd3JvdGU6DQo+IE9uIE1v
biwgT2N0IDIxLCAyMDE5IGF0IDEwOjE4IEFNIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiA8dG9r
ZUByZWRoYXQuY29tPiB3cm90ZToNCj4+DQo+PiBBbmRyaWkgTmFrcnlpa28gPGFuZHJpaW5AZmIu
Y29tPiB3cml0ZXM6DQo+Pg0KPj4+IExJQkJQRl9PUFRTIGlzIGltcGxlbWVudGVkIGFzIGEgbWl4
IG9mIGZpZWxkIGRlY2xhcmF0aW9uIGFuZCBtZW1zZXQNCj4+PiArIGFzc2lnbm1lbnQuIFRoaXMg
bWFrZXMgaXQgbmVpdGhlciB2YXJpYWJsZSBkZWNsYXJhdGlvbiBub3IgcHVyZWx5DQo+Pj4gc3Rh
dGVtZW50cywgd2hpY2ggaXMgYSBwcm9ibGVtLCBiZWNhdXNlIHlvdSBjYW4ndCBtaXggaXQgd2l0
aCBlaXRoZXINCj4+PiBvdGhlciB2YXJpYWJsZSBkZWNsYXJhdGlvbnMgbm9yIG90aGVyIGZ1bmN0
aW9uIHN0YXRlbWVudHMsIGJlY2F1c2UgQzkwDQo+Pj4gY29tcGlsZXIgbW9kZSBlbWl0cyB3YXJu
aW5nIG9uIG1peGluZyBhbGwgdGhhdCB0b2dldGhlci4NCj4+Pg0KPj4+IFRoaXMgcGF0Y2ggY2hh
bmdlcyBMSUJCUEZfT1BUUyBpbnRvIGEgc3RyaWN0bHkgZGVjbGFyYXRpb24gb2YgdmFyaWFibGUN
Cj4+PiBhbmQgc29sdmVzIHRoaXMgcHJvYmxlbSwgYXMgY2FuIGJlIHNlZW4gaW4gY2FzZSBvZiBi
cGZ0b29sLCB3aGljaA0KPj4+IHByZXZpb3VzbHkgd291bGQgZW1pdCBjb21waWxlciB3YXJuaW5n
LCBpZiBkb25lIHRoaXMgd2F5IChMSUJCUEZfT1BUUyBhcw0KPj4+IHBhcnQgb2YgZnVuY3Rpb24g
dmFyaWFibGVzIGRlY2xhcmF0aW9uIGJsb2NrKS4NCj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IEFu
ZHJpaSBOYWtyeWlrbyA8YW5kcmlpbkBmYi5jb20+DQo+Pj4gLS0tDQo+IA0KPiBbLi4uXQ0KPiAN
Cj4+PiBkaWZmIC0tZ2l0IGEvdG9vbHMvbGliL2JwZi9saWJicGYuaCBiL3Rvb2xzL2xpYi9icGYv
bGliYnBmLmgNCj4+PiBpbmRleCAwZmRmMDg2YmViYTcuLmJmMTA1ZTllODY2ZiAxMDA2NDQNCj4+
PiAtLS0gYS90b29scy9saWIvYnBmL2xpYmJwZi5oDQo+Pj4gKysrIGIvdG9vbHMvbGliL2JwZi9s
aWJicGYuaA0KPj4+IEBAIC03NywxMiArNzcsMTMgQEAgc3RydWN0IGJwZl9vYmplY3Rfb3Blbl9h
dHRyIHsNCj4+PiAgICAqIGJ5dGVzLCBidXQgdGhhdCdzIHRoZSBiZXN0IHdheSBJJ3ZlIGZvdW5k
IGFuZCBpdCBzZWVtcyB0byB3b3JrIGluIHByYWN0aWNlLg0KPj4+ICAgICovDQo+Pj4gICAjZGVm
aW5lIExJQkJQRl9PUFRTKFRZUEUsIE5BTUUsIC4uLikgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgXA0KPj4+IC0gICAgIHN0cnVjdCBUWVBFIE5BTUU7ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPj4+IC0gICAgIG1lbXNldCgm
TkFNRSwgMCwgc2l6ZW9mKHN0cnVjdCBUWVBFKSk7ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgXA0KPj4+IC0gICAgIE5BTUUgPSAoc3RydWN0IFRZUEUpIHsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPj4+IC0gICAgICAgICAgICAgLnN6ID0gc2l6
ZW9mKHN0cnVjdCBUWVBFKSwgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXA0KPj4+
IC0gICAgICAgICAgICAgX19WQV9BUkdTX18gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgXA0KPj4+IC0gICAgIH0NCj4+PiArICAgICBzdHJ1Y3QgVFlQRSBO
QU1FID0gKHsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwN
Cj4+PiArICAgICAgICAgICAgIG1lbXNldCgmTkFNRSwgMCwgc2l6ZW9mKHN0cnVjdCBUWVBFKSk7
ICAgICAgICAgICAgICAgICAgICAgIFwNCj4+PiArICAgICAgICAgICAgIChzdHJ1Y3QgVFlQRSkg
eyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4+PiArICAg
ICAgICAgICAgICAgICAgICAgLnN6ID0gc2l6ZW9mKHN0cnVjdCBUWVBFKSwgICAgICAgICAgICAg
ICAgICAgICAgICAgIFwNCg0KVGhpcyAoeyBzdGF0ZW1lbnRzOyAuLi47IHZhbHVlOyB9KSBpcyB1
c2VkIGJ5IGJjYyByZXdyaXRlciBhcyB3ZWxsLg0KDQo+Pg0KPj4gV2FpdCwgeW91IGNhbiBzdGlj
ayBhcmJpdHJhcnkgY29kZSBpbnNpZGUgYSB2YXJpYWJsZSBpbml0aWFsaXNhdGlvbg0KPj4gYmxv
Y2sgbGlrZSB0aGlzPyBIb3cgZG9lcyB0aGF0IHdvcms/IElzIGV2ZXJ5dGhpbmcgYmVmb3JlIHRo
ZSAoc3RydWN0DQo+PiB0eXBlKSBqdXN0IGlnbm9yZWQgKGFuZCBpcyB0aGF0IGEgY2FzdCk/DQo+
IA0KPiBXZWxsLCB5b3UgZGVmaW5pdGVseSBjYW4gc3RpbGwgYXJiaXRyYXJ5IGNvZGUgaW50byBh
ICh7IH0pIGV4cHJlc3Npb24NCj4gYmxvY2ssIHRoYXQncyBub3QgdGhhdCBzdXJwcmlzaW5nLg0K
PiBUaGUgc3VycHJpc2luZyBiaXQgdGhhdCBJIGRpc2NvdmVyZWQganVzdCByZWNlbnRseSB3YXMg
dGhhdCBzdHVmZiBsaWtlDQo+IHRoaXMgY29tcGlsZXMgYW5kIHdvcmtzIGNvcnJlY3RseSwgdHJ5
IGl0Og0KPiANCj4gICAgICAgICAgdm9pZCAqeCA9ICZ4Ow0KPiAgICAgICAgICBwcmludGYoIiVs
eCA9PSAlbHhcbiIsIHgsICZ4KTsNCg0KJ3ZvaWQgKngnIGp1c3QgdGFrZXMgdGhlIGFkZHJlc3Mg
b2YgdGhlICd4JyBpbiB0aGUgY3VycmVudCBzY29wZS4NCkl0IG1heSBsb29rcyBsaWtlIGEgdXNl
IGJlZm9yZSBkZWZpbmUuIGJ1dCBpdCBhY3R1YWxseSB3b3Jrcy4NCg0KTEdUTS4NCkFja2VkLWJ5
OiBZb25naG9uZyBTb25nIDx5aHNAZmIuY29tPg0KDQo+IA0KPiBTbyBJJ20gdXNpbmcgdGhlIGZh
Y3QgdGhhdCB2YXJpYWJsZSBhZGRyZXNzIGlzIGF2YWlsYWJsZSBpbnNpZGUNCj4gdmFyaWFibGUg
aW5pdGlhbGl6YXRpb24gYmxvY2suDQo+IA0KPiBCZXlvbmQgdGhhdCwgaXQncyBqdXN0IGEgZmFu
Y3ksIGJ1dCBzdGFuZGFyZCAoc3RydWN0IGJsYSl7IC4uLg0KPiBpbml0aWFsaXplciBsaXN0IC4u
Ln0gc3ludGF4IChpdCdzIG5vdCBhIHN0cnVjdCBpbml0aWFsaXplciBzeW50YXgsDQo+IG1pbmQg
eW91LCBpdCdzIGEgc3RydWN0IGFzc2lnbm1lbnQgZnJvbSBzdHJ1Y3QgbGl0ZXJhbCkuIEZhbmN5
IGZvcg0KPiBzdXJlLCBidXQgaXQgd29ya3MgYW5kIHNvbHZlcyBwcm9ibGVtcyBJIG1lbnRpb25l
ZCBpbiBjb21taXQNCj4gZGVzY3JpcHRpb24uDQo+IA0KPj4NCj4+IC1Ub2tlDQo+Pg0K
