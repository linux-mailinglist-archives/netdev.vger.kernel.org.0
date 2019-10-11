Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68E25D49BE
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 23:16:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfJKVO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 17:14:56 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:5204 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbfJKVOz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Oct 2019 17:14:55 -0400
Received: from pps.filterd (m0109331.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id x9BL8j7n016539;
        Fri, 11 Oct 2019 14:14:22 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=IFn4vmePmf/Plz/Hy/XLFMosUaWVw6L384FFbzqhcHE=;
 b=kjIck9Rr04frdCSPEZJrBLca5gWReScGdPW6OQZceBsVhiVASslswyAWCTvvESPpQ1NB
 FV5rCunYb+5+etgBBksmX4KrbXWI184fUZpFF3pqt5GGdkvfi5LSmogGm8xMMyu8HzE8
 Xe/gjtKR2hCcPKYkVDBc8kUwamhs8m/1k/0= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by mx0a-00082601.pphosted.com with ESMTP id 2vjwwg955f-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Fri, 11 Oct 2019 14:14:22 -0700
Received: from prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 14:14:21 -0700
Received: from prn-hub05.TheFacebook.com (2620:10d:c081:35::129) by
 prn-mbx05.TheFacebook.com (2620:10d:c081:6::19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Fri, 11 Oct 2019 14:14:21 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.29) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Fri, 11 Oct 2019 14:14:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ow1bPUtllIDGTjSfgxwKe8jircm7HD3Af4Z+XsFsF6XKsH7ylQ7b3TI1thHmkQTvXWPYMWu5W1hfoK5I0z/l0IKf6GfyRqqNvIyicXDPtBcfpSs0kvChO+VobrQXZHOJindYuYgNPgWbxOi7kjw+GeZAq9LkXzR0qkO2y2D/LxpFvso1fyZ7NH79AKoGmoBG6+kV5PAI5VZeQncVJ7RxzYOYh3QNoZQIHVwE0KQ3MwccRbhDqU0HSDBzDgnpC4SQsLQnxNzb8azO0ImOADM6sCKOesYgwYgRBDXFZpRzAxtM2pw08bmJm1+AFc3vniatNx9T1kPY19S7oPhRVTS4zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFn4vmePmf/Plz/Hy/XLFMosUaWVw6L384FFbzqhcHE=;
 b=IyGVMFNaShWJENzJYkQgaXdfXkUbFyE0J4InfIOC9pcW3kdFtylGaTOURHrt42xiFAt3eOTE8ZX47pzt4f8pIJ7xJVHe+XzqY2RB2H8gia8G6Y2j+eYENIrYO2+2HKCL/jrFeyyrbecZp4wFkcVdbvFqX+fMQUDy9LyJ2pGPB0nNTyyuhY/vqvWMwCwA3vKslUoEblQubWHjdqOPVXAAoLKgHFDp+3TcwJyIO4eQvzpkouuzI3UdnEb+kkMz06BJftz52CW/5LLqDwcvh7UdhZwt06VYuCY92bTCDKATJPTMqBKJdrsSPmAwXYh8DDh6oIAJLYKgtxTVwO8gnVZhaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IFn4vmePmf/Plz/Hy/XLFMosUaWVw6L384FFbzqhcHE=;
 b=jJ3RB+E4jbSlG5+E//9Zb6LIOgTwKq0MdI+IMwzZR9TxCeiZ8m7f1WAuzpxuadgp+bpHs/YUvPkjsOBsZQtBTyR53EXatmdtBJTRmQPI2med291fAY7vjfDFXTLbnL/h5cozQnamuUlff17zXOCQP5AnUsiN4yCp5d+KnnZvjFI=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.151.24) by
 MW2PR1501MB1979.namprd15.prod.outlook.com (52.132.149.155) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Fri, 11 Oct 2019 21:14:20 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::e93d:6d35:c16d:2927]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::e93d:6d35:c16d:2927%3]) with mapi id 15.20.2327.025; Fri, 11 Oct 2019
 21:14:19 +0000
From:   Julia Kartseva <hex@fb.com>
To:     Jiri Olsa <jolsa@redhat.com>
CC:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>
Subject: Re: libbpf distro packaging
Thread-Topic: libbpf distro packaging
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAKcGJtMAgAJfWYCAAG7xgIAEG0SAgAIlyQCAAQdFgIA0IB+AgAnWI4CAAoD4AIAFJS2A
Date:   Fri, 11 Oct 2019 21:14:19 +0000
Message-ID: <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
References: <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com> <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava> <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava> <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava> <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com> <20191008073958.GA10009@krava>
In-Reply-To: <20191008073958.GA10009@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:200::89f4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c4d8cbb3-87be-4fd5-2788-08d74e8ffb51
x-ms-traffictypediagnostic: MW2PR1501MB1979:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB197988E6D7222864D705FC30C4970@MW2PR1501MB1979.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(396003)(136003)(346002)(39860400002)(376002)(51444003)(199004)(189003)(66556008)(7736002)(66476007)(76116006)(33656002)(76176011)(4326008)(102836004)(25786009)(66946007)(66446008)(6486002)(2906002)(305945005)(81156014)(81166006)(8676002)(64756008)(36756003)(478600001)(966005)(71200400001)(71190400001)(229853002)(6116002)(8936002)(14454004)(256004)(11346002)(316002)(446003)(6506007)(6916009)(2616005)(4744005)(46003)(6246003)(5660300002)(86362001)(476003)(99286004)(7116003)(3480700005)(486006)(6306002)(6512007)(6436002)(54906003)(186003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB1979;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 57ZytSHR3NtZSrkiK+sIR7PhgREt7bgpOuq5DZKONSlouCDyyj5ycjnpanjk2UNmzuem+TLWow+5s3tD2OFQhH29O2iy4ypKpNN+Fxl21sZi0o6Y6cqS3472ZuvVzbLkxaEeo/JpL9SvXPKdvzdl2qpXVkp+2yfmmixO4p6fR0uks4NXadbqDzwmQdSP5+IC48FsQKWMr8rDDVIzXMXhyMefLA3OK37o75P4muGgnr0PaPkDz0HVDDdazsnsg6kxNIztkFBi5y6o4uSdWQKrIDDID63tnxE4FIERVoYVICHrhbpnIPsDL3+SF3M+KIXFj2w9DqSpzG09qFpixHwfxoSAo6QOlW3OFrwbE9fZN8m2eFurMCh6cXhepjizhMzY+SeO+fifxOBoFdFGG9E3RVRFL/EL7nfv8xM5t0iDU7Gc4x/kedo9uuIW6UJBiBZqNCvmDNG+urAs2XIkGqt+vQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <FA6708783A7D7E409F390333E077389A@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: c4d8cbb3-87be-4fd5-2788-08d74e8ffb51
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 21:14:19.7723
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S+i/fPFNn6pV3E43GWHTxbKeHoI8/O5IC/4sEyd0SVsEcL/xEiF0SJC+aUWeHcta
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB1979
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-11_11:2019-10-10,2019-10-11 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 mlxlogscore=928
 suspectscore=0 clxscore=1015 lowpriorityscore=0 malwarescore=0
 adultscore=0 phishscore=0 spamscore=0 priorityscore=1501 mlxscore=0
 bulkscore=0 impostorscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-1908290000 definitions=main-1910110172
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlyaSwNCg0Kc3lzdGVtZCBmb2xrcyBwdWJsaXNoZWQgbGliYnBmIENlbnRPUyA3IHBhY2th
Z2UgaW4gc3lzdGVtZCBjb3JwIHJlcG86IFsxXSwNCnNvIGd1ZXNzIHRoYXQgcHJvdmVzIHRoYXQg
ZGVwcyBmcm9tIG90aGVyIHJlcG8gYXJlIGZpbmUuDQoNClJlYnVpbGQgaXMgZmFpcmx5IHNpbXBs
ZTogWzJdDQoNClsxXSBodHRwczovL2NvcHIuZmVkb3JhaW5mcmFjbG91ZC5vcmcvY29wcnMvbXJj
MG1tYW5kL3N5c3RlbWQtY2VudG9zLWNpL2J1aWxkLzEwNTM2OTQvDQpbMl0gaHR0cHM6Ly9naXRo
dWIuY29tL3N5c3RlbWQvc3lzdGVtZC9wdWxsLzEzNzQ0I2lzc3VlY29tbWVudC01NDExNjgwNzYN
Cg0K77u/T24gMTAvOC8xOSwgMTI6NDAgQU0sICJKaXJpIE9sc2EiIDxqb2xzYUByZWRoYXQuY29t
PiB3cm90ZToNCj4NCj4gT24gTW9uLCBPY3QgMDcsIDIwMTkgYXQgMTI6MjU6NTFBTSArMDAwMCwg
SnVsaWEgS2FydHNldmEgd3JvdGU6DQo+ID4gDQo+ID4gSSB3b25kZXIgd2hhdCBhcmUgdGhlIHN0
ZXBzIHRvIG1ha2UgbGliYnBmIGF2YWlsYWJsZSBmb3IgQ2VudE9TIHs3fDh9IGFzIHdlbGw/DQo+
ID4gT25lIChsaWtlbHkgdGhlIHF1aWNrZXN0KSB3YXkgdG8gZG8gdGhhdCBpcyB0byBwdWJsaXNo
IGl0IHRvIEZlZG9yYSdzIEVQRUwgWzFdLg0KPiA+IA0KPiA+IEkgaGF2ZSBhIGxpdHRsZSBjb25j
ZXJuIGFib3V0IGRlcGVuZGVuY2llcywgbmFtZWx5IGVsZnV0aWxzLWxpYmVsZi1kZXZlbCBhbmQg
DQo+ID4gZWxmdXRpbHMtZGV2ZWwgYXJlIHNvdXJjZWQgZGlyZWN0bHkgYnkgQ2VudE9TIHJlcG9z
LCBlLmcuIFsyXSwgbm90IHN1cmUgaWYgDQo+ID4gZGVwZW5kZW5jaWVzIGZyb20gYW5vdGhlciBy
ZXBvIGFyZSBmaW5lLg0KPiA+IA0KPiA+IFRob3VnaHRzPyBUaGFua3MhDQo+DQo+IEkgdGhpbmsg
dGhhdCBzaG91bGQgYmUgb2ssIEknbGwgYXNrIGFyb3VuZCBhbmQgbGV0IHlvdSBrbm93DQo+DQo+
IGppcmthDQoNCg==
