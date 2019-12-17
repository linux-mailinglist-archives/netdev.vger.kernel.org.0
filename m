Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE5AB1224B5
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 07:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727545AbfLQGd1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 01:33:27 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:17914 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725856AbfLQGd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 01:33:27 -0500
Received: from pps.filterd (m0148460.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBH6UNQs032190;
        Mon, 16 Dec 2019 22:33:14 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=T2gJ8HvI6SDe3XCrIwZx+ZUNIZyHas5tlf+WracFoyU=;
 b=hDgUq56WyhN0Fy5GmQCeOFxtkE6goEapClQjk5I3+/AP98DUHaGsvoeBby3Tb+svNErA
 ji8cEQ5mGPtB0MutoVLW3RaXwOqph9oCObmiJ9MqI+6Upx5YkSu5xr/KuLRuXOFCtUJT
 0ioQPfI08OKemnuAEatubM+onoQoDLije+s= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wxcwy3ddb-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Mon, 16 Dec 2019 22:33:14 -0800
Received: from ash-exhub201.TheFacebook.com (2620:10d:c0a8:83::7) by
 ash-exhub104.TheFacebook.com (2620:10d:c0a8:82::d) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 16 Dec 2019 22:33:13 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.101) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 16 Dec 2019 22:33:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m1/3/+7DWoR4N3B5C7vioHdjPqolbem7FRvr/abvi0UYiflEMWJIGyRQdTEgZ6zpHK8Bklt+ntgCu50hgjAasnMKgUf/QOugO6hGgJEUVc9DIE1QNahIPL9UcDE+vR++jDVhuke3JUq5IOUko5pt/KD54TO/d6a5eobN0Ljknbze52Tq5uj9V/Syk6hAHsOI9wpkVxEHWkkpYTXdDAj5oATcWQ8gOiMkk4Oilvj6+Mwj+ppaJ+JGlMDTG0tA0lf6+AgY2q2OdaYJFBSHdfgTw+mCl4rf64ae7XixK6bgeA1z8YegttRWS7lA0uvuLsyRS6aOC8cZ11/NGVEU+2YynA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2gJ8HvI6SDe3XCrIwZx+ZUNIZyHas5tlf+WracFoyU=;
 b=ET8R+FixUkahwMhhN9cQ8BmDwuIZ1Nz04LEI41egxW0pCsjx6ehDiODYp4dLNdSyw8tPkuP/pBm6ZoeTUWi4aa9OgIxZeGrueJ5nL7XsJW0j5pDhx38n3y7BKrxFtLN9IHoePNPM+zvZm9JNst8ejgtwW7IeIHmrUdzoUPTGh4ioIzq/VxaKebNCrUr/JJK8+/P5jJKvqyvgZVUyOJjVhRB78xqenE7YZ1d3rbj1oN+zasHlUycbcGA/J5ejHDTtPnNARb8J/KhW19uLK+k9H3Tbfw7SCdSGIGAZcMBWF4Mb9wRKVEvIhREZZ8jKEJbA3a6QMnpjdwI7ca4hB9Yanw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2gJ8HvI6SDe3XCrIwZx+ZUNIZyHas5tlf+WracFoyU=;
 b=SzpZvQukIcORqmd5+mcJKt4JhvhiZs9v9LdGJOIB6cQjTwXoYwkWtoVkX+XRBfkqI817ItNgdjFCqcIF90obwsOQLh4fhsqRO2SDlaHxa4MlHw1jSbTbBD5DrW7KBftuyHpGptOmr05QnTX8yvTZAvR3fkFfd9zIzdjlLUFJFQQ=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1419.namprd15.prod.outlook.com (10.173.221.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.15; Tue, 17 Dec 2019 06:33:12 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 06:33:12 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Wenbo Zhang <ethercflow@gmail.com>
CC:     "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Thread-Topic: [PATCH bpf-next v12 1/2] bpf: add new helper get_file_path for
 mapping a file descriptor to a pathname
Thread-Index: AQHVsvxXzJN9aTKnK0ael6l0VjzbR6e7XQUAgAKC0QCAAAHiAA==
Date:   Tue, 17 Dec 2019 06:33:12 +0000
Message-ID: <fecf759e-2941-3920-82d5-45a556f4dd1d@fb.com>
References: <cover.1576381511.git.ethercflow@gmail.com>
 <0117d6e17ba8b3b1273e5a964f87a71c1b2d8741.1576381512.git.ethercflow@gmail.com>
 <e3ff90c1-6024-ec9f-061c-195e9def9c0c@fb.com>
 <CABtjQmZcbhcab0a7ksuggg3ZoDwM5s3ucjeA_baPTpAJQvKQLA@mail.gmail.com>
In-Reply-To: <CABtjQmZcbhcab0a7ksuggg3ZoDwM5s3ucjeA_baPTpAJQvKQLA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR13CA0035.namprd13.prod.outlook.com
 (2603:10b6:300:95::21) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::8f07]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c55328bd-71f0-4ba2-5af0-08d782bafd42
x-ms-traffictypediagnostic: DM5PR15MB1419:
x-microsoft-antispam-prvs: <DM5PR15MB1419B0D9C0776CB9E3E3B2A0D3500@DM5PR15MB1419.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(346002)(396003)(376002)(136003)(39860400002)(366004)(189003)(199004)(71200400001)(2906002)(5660300002)(86362001)(53546011)(186003)(2616005)(478600001)(31686004)(31696002)(54906003)(52116002)(6916009)(8676002)(8936002)(81166006)(81156014)(6486002)(6506007)(66446008)(36756003)(6512007)(4326008)(316002)(66476007)(64756008)(66946007)(66556008);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1419;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Pc4CDJbiShM2sTFnrOrFmuXc3Tqeg6PTpMu+yTSjnN1nvqODwJV/KQkbbluSq7IyvsmgdqAaW0MDqfNlGEkTYfNLGSwE3sUskVSyvabeH4C0E5QLwb06g7xWTRDi+e6Tw1Ac4iZPupv7oVgMv7n1M1ClJe3WRhjYWiTPA6xbhzylY5jqVvEPcwoqbc+mPXche7DasEjKEZER47qh5qtD7QRgqduN0ExBer4sfqHBMrb4vAXMyKmU3ajhdj4lFpoGxwlVrPgzNB/VgVtjh/4FH1kQTFsKHQ98bVtckWyYdxAESwBgClhNitLKp81WzQnZfE6I3kTCOSMfaw+4wHQnaiL9XpJSv3ZteCXlhACmNxOULVTF20fhiCJZUwAOBJtm9A3qImMC/14lU4eprCXD6JLa2NNkc/2YccgpNUncWaoP8p23u0XtjiCDIqK0nm/L
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <41E12A535DA67C4A8FC4B0525FAA06A1@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c55328bd-71f0-4ba2-5af0-08d782bafd42
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 06:33:12.2376
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IvvkWLCoUUxwBkoH+TlLpj63LCDc5ME16tgNg5eYMxzSA6LBlEo/7/dIQpq2RVzM
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1419
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-17_01:2019-12-16,2019-12-16 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 impostorscore=0
 clxscore=1015 adultscore=0 bulkscore=0 mlxlogscore=867 phishscore=0
 suspectscore=0 priorityscore=1501 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1910280000 definitions=main-1912170056
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE2LzE5IDEwOjI2IFBNLCBXZW5ibyBaaGFuZyB3cm90ZToNCj4+PiArICogICAg
ICAgICAgIC0gYSByZWd1bGFyIGZ1bGwgcGF0aCAoaW5jbHVkZSBtb3VudGFibGUgZnMgZWc6IC9w
cm9jLCAvc3lzKQ0KPj4+ICsgKiAgICAgICAgICAgLSBhIHJlZ3VsYXIgZnVsbCBwYXRoIHdpdGgg
IihkZWxldGVkKSIgYXQgdGhlIGVuZC4NCj4gDQo+PiBMZXQgdXMgc2F5IHdpdGggIiAoZGVsZXRl
ZCkiIGlzIGFwcGVuZGVkIHRvIGJlIGNvbnNpc3RlbnQgd2l0aCBjb21tZW50cw0KPj4gaW4gZF9w
YXRoKCkgYW5kIGlzIG1vcmUgY2xlYXIgdG8gdXNlciB3aGF0IHRoZSBmb3JtYXQgd2lsbCBsb29r
cyBsaWtlLg0KPiANCj4gVGhhbmsgeW91LCBJJ2xsIGZpeCB0aGlzLg0KPiANCj4+PiArICAgICBy
ZXQgPSBzdHJsZW4ocCk7DQo+Pj4gKyAgICAgbWVtbW92ZShkc3QsIHAsIHJldCk7DQo+Pj4gKyAg
ICAgZHN0W3JldCsrXSA9ICdcMCc7DQo+IA0KPj4gbml0OiB5b3UgY291bGQgZG8gbWVtbW92ZShk
c3QsIHAsIHJldCArIDEpPw0KPiANCj4gSSBkaWQgd2l0aCBgZHN0W3JldCsrXT0nXDAnO2AgIHRv
IHJldHVybiB2YWx1ZSBsZW5ndGggaW5jbHVkaW5nDQo+IHRyYWlsaW5nICdcMCcuIGFzIHlvdSBt
ZW50aW9uZWQgYmVsb3c6DQo+IA0KPj4+ICsgICAgIGZwdXQoZik7DQo+Pj4gKyAgICAgcmV0dXJu
IHJldDsNCj4gDQo+PiBUaGUgZGVzY3JpcHRpb24gc2F5cyB0aGUgcmV0dXJuIHZhbHVlIGxlbmd0
aCBpbmNsdWRpbmcgdHJhaWxpbmcgJ1wwJy4NCj4+IFRoZSBhYm92ZSAncmV0JyBkb2VzIG5vdCBp
bmNsdWRlIHRyYWlsaW5nICdcMCcuDQo+IA0KPiBJdCBzZWVtcyBgW3JldCsrXWAgbm90IHZlcnkg
Y2xlYXIgdG8gcmVhZCBhbmQgJ1wwJyBjYW4gYmUgZG9uZSBieQ0KPiBgbWVtbW92ZWAuIEkgdGhp
bmsgSSdsbCByZWZhY3RvciB0bw0KPiANCj4gYGBgDQo+IHJldCA9IHN0cmxlbihwKSArIDE7DQo+
IG1lbW1vdmUoZHN0LCBwLCByZXQpOw0KPiBmcHV0KGYpOw0KPiByZXR1cm4gcmV0Ow0KPiBgYGAN
Cj4gDQo+IElzIHRoaXMgYmV0dGVyPw0KDQpBaCwgSSBtaXNzZWQgcmV0KysgaW4gZHN0W3JldCsr
XS4gSW5kZWVkIHRoZSBhYm92ZSBjb2RlIGlzIGJldHRlci4NCg==
