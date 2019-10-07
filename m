Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEE87CD9E4
	for <lists+netdev@lfdr.de>; Mon,  7 Oct 2019 02:26:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbfJGA0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 20:26:45 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:39966 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726266AbfJGA0o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 20:26:44 -0400
Received: from pps.filterd (m0089730.ppops.net [127.0.0.1])
        by m0089730.ppops.net (8.16.0.42/8.16.0.42) with SMTP id x970OZN7032350;
        Sun, 6 Oct 2019 17:26:13 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=p0k1SEZrh8LTRgoRABDMCSNdlTvDiUdXaaFaLB/IS9s=;
 b=FoADFgBgSdt1VjwA4B7zP7p/Gnz6xuSt7tvfNy4BlFLcePamy1DlQxSRIg+FxfoI7D1j
 Hj956ZJQjqaJ0Dti+Flyr/q4ulM9vTEZMyw1kj5NzEGVPfUngsu4q4A8my9AfUYDg+T5
 y1mDiUP6TF5AoOwrDIiVO8ijqY/ARxLKo2s= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0089730.ppops.net with ESMTP id 2vepp1p3m5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 06 Oct 2019 17:26:13 -0700
Received: from prn-hub02.TheFacebook.com (2620:10d:c081:35::126) by
 prn-hub03.TheFacebook.com (2620:10d:c081:35::127) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Sun, 6 Oct 2019 17:26:11 -0700
Received: from NAM01-BN3-obe.outbound.protection.outlook.com (192.168.54.28)
 by o365-in.thefacebook.com (192.168.16.26) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.1.1713.5
 via Frontend Transport; Sun, 6 Oct 2019 17:26:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QV6pNcVLI6QNd8I8DsS7pzT5ImO0n3+HJTJ0moPNtlKh+R2l1NE3hd0XPPN+b8ymrg0EoAwAjGc2RvOYw6MvfxNE/ST0Hk4Xg+KWKCStRcc+5E9NBn32Y0gdbCBgtZjtWHrF6h2S2ruSnXFMO9gGFZLwQJ8gS0r5yRqPrKW/pIa0/u4rFwy3XobwHeV4ogqxBF5LUDbsn7WtZ9AQqkx1xkqnL4zCvXg5kiIdGLCz2QcupMcdO1zJXZftwhqQ+lKW20+bZm0THL6kx0dv+uF+IHnVO5A0tN3XdDa/JICZd9OY/c75GCvaLUUpRML36KLahSwGktfnPpuGI+PmJxccbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0k1SEZrh8LTRgoRABDMCSNdlTvDiUdXaaFaLB/IS9s=;
 b=Mtb6EsHsmsLo/zCgea39ogcMjhEC47UrShYepuTS4sUqFjlsYoh6P6h+VSegwb4rWWpb5pq3b+C2AqMaV5LmFUDl5Bxk1v54jLvGMT9Ga5chLyPjbgCSW4Pb5zOE004JuxBT7LZqedUn4z9HkiwLmM2KaC8/Tyy2POSpo/aBWynn4yESp5AN4RdoAMG9R8LsY5kTFQ0lt3suXOt/3oeLc2mMZ6e4GmNAzZHJToip2m4gQmc2EfE5p4acyos4y5iaCdiMhauELJUWUroKiWY4iOD90o//mNIFR57CQQS7s7CsAl6VIjshVcS0nzcFE8PAf2FbVzhs7OZ5Y+GPzDG+uA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p0k1SEZrh8LTRgoRABDMCSNdlTvDiUdXaaFaLB/IS9s=;
 b=I1iRGZRby/7p9N/f4/9Y2TvgviaEYS4CbR3K/d8vWwxUd1wUqagC+7qrUkScbhkYmrwC4M0CLEAc0QWK3zbCwQw0natxWU+YXkGcHeYlACle8OgolcgxIoUChTNeNCKAfryw0jRr9Gl/OjEIPa/HuM+6MH3eyAxFm0DBNWlqVGo=
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com (52.132.151.24) by
 MW2PR1501MB2170.namprd15.prod.outlook.com (52.132.150.154) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Mon, 7 Oct 2019 00:25:53 +0000
Received: from MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::e93d:6d35:c16d:2927]) by MW2PR1501MB2059.namprd15.prod.outlook.com
 ([fe80::e93d:6d35:c16d:2927%3]) with mapi id 15.20.2327.023; Mon, 7 Oct 2019
 00:25:52 +0000
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
Thread-Index: AQHVUUC6mSeRtrJxpEmiNjup7x1PAKcGJtMAgAJfWYCAAG7xgIAEG0SAgAIlyQCAAQdFgIA0IB+AgAnWI4A=
Date:   Mon, 7 Oct 2019 00:25:51 +0000
Message-ID: <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
References: <20190813122420.GB9349@krava>
 <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
 <FA139BA4-59E5-43C7-8E72-C7B2FC1C449E@fb.com>
 <A770810D-591E-4292-AEFA-563724B6D6CB@fb.com> <20190821210906.GA31031@krava>
 <20190823092253.GA20775@krava> <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava> <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava> <20190930111305.GE602@krava>
In-Reply-To: <20190930111305.GE602@krava>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2620:10d:c090:180::70e3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e9b42912-6d7b-4231-09a1-08d74abce982
x-ms-traffictypediagnostic: MW2PR1501MB2170:
x-ms-exchange-purlcount: 2
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR1501MB217002FDA8A6D79E1BD692CCC49B0@MW2PR1501MB2170.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 01834E39B7
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(376002)(346002)(396003)(39850400004)(189003)(199004)(966005)(3480700005)(86362001)(6486002)(478600001)(11346002)(6436002)(476003)(46003)(6916009)(14444005)(76176011)(229853002)(6512007)(256004)(7116003)(186003)(102836004)(99286004)(6246003)(4326008)(305945005)(5660300002)(6306002)(81166006)(14454004)(81156014)(4744005)(486006)(446003)(71200400001)(8936002)(71190400001)(8676002)(2616005)(66476007)(66556008)(64756008)(66446008)(33656002)(66946007)(6116002)(36756003)(76116006)(53546011)(6506007)(7736002)(25786009)(316002)(2906002)(54906003);DIR:OUT;SFP:1102;SCL:1;SRVR:MW2PR1501MB2170;H:MW2PR1501MB2059.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QrRVeAhGz/i9v9wGpfE7FGYFqG576dLhSRrOAaZqpe4an0VysTe2+q8q7YFfO1/+A0XXn/v4M7kHYAZ9Jb1mTeQ1khrxZy+RKe6UWf1D1hz5XLCcRSF8SjaDhqNMiqn1ylK9STrCpbu0WofQdOBKfnZg8F66Sc39uFpXTl1v/v8O+Mtb+Zq3S079aGxKwPeObiikYvbdjSmqXhaNrtoETHqo5gthlwB+nfrdtxXfzEcTQozgolvkPE6fqURg7nwyi6cFcoqJhSRgXV1s7l0gL6aYF7Qf92GYsDzzcKhen7asMUv0QtUg2GOpvUATQcF96OzSVoKVCWzLZzZ8+RWz5MjsUNTxhsBZnLfBBPmOYYl8ZCka5sBkb6QTJW6gwBnhI85Efm+4ZZ7Wka+hpvRfjoOjIvSxBRG0EGAQ/XEYeb2dAuDPQ/Ir/kvpbF7Cg5kn4fkeVOnnCit9UZqRwzeI6w==
Content-Type: text/plain; charset="utf-8"
Content-ID: <EAFB409806004940AF6D7FDC248ABEBF@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e9b42912-6d7b-4231-09a1-08d74abce982
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2019 00:25:52.6043
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: HOxfHcEyBSIBiWdJ5NNqJbYxJRdthQCd72CSmrbjA9ZRRdL/qJj5W28HrUHHjMjl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR1501MB2170
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,1.0.8
 definitions=2019-10-06_08:2019-10-03,2019-10-06 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 clxscore=1015 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=829
 lowpriorityscore=0 spamscore=0 mlxscore=0 phishscore=0 impostorscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1908290000 definitions=main-1910070003
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8zMC8xOSwgNDoxMyBBTSwgIkppcmkgT2xzYSIgPGpvbHNhQHJlZGhhdC5jb20+IHdyb3Rl
Og0KDQo+IGhleWEsDQo+IEZZSSB3ZSBnb3QgaXQgdGhyb3VnaC4uIHRoZXJlJ3MgbGliYnBmLTAu
MC4zIGF2YWlsYWJsZSBvbiBmZWRvcmEgMzAvMzEvMzINCj4gSSdsbCB1cGRhdGUgdG8gMC4wLjUg
dmVyc2lvbiBhcyBzb29uIGFzIHRoZXJlJ3MgdGhlIHYwLjAuNSB0YWcgYXZhaWxhYmxlDQo+DQo+
IGppcmthDQoNCkhpIEppcmksDQoNCkkgd29uZGVyIHdoYXQgYXJlIHRoZSBzdGVwcyB0byBtYWtl
IGxpYmJwZiBhdmFpbGFibGUgZm9yIENlbnRPUyB7N3w4fSBhcyB3ZWxsPw0KT25lIChsaWtlbHkg
dGhlIHF1aWNrZXN0KSB3YXkgdG8gZG8gdGhhdCBpcyB0byBwdWJsaXNoIGl0IHRvIEZlZG9yYSdz
IEVQRUwgWzFdLg0KDQpJIGhhdmUgYSBsaXR0bGUgY29uY2VybiBhYm91dCBkZXBlbmRlbmNpZXMs
IG5hbWVseSBlbGZ1dGlscy1saWJlbGYtZGV2ZWwgYW5kIA0KZWxmdXRpbHMtZGV2ZWwgYXJlIHNv
dXJjZWQgZGlyZWN0bHkgYnkgQ2VudE9TIHJlcG9zLCBlLmcuIFsyXSwgbm90IHN1cmUgaWYgDQpk
ZXBlbmRlbmNpZXMgZnJvbSBhbm90aGVyIHJlcG8gYXJlIGZpbmUuDQoNClRob3VnaHRzPyBUaGFu
a3MhDQoNClsxXSBodHRwczovL2ZlZG9yYXByb2plY3Qub3JnL3dpa2kvRVBFTA0KWzJdIGh0dHA6
Ly9taXJyb3IuY2VudG9zLm9yZy9jZW50b3MvNy9vcy94ODZfNjQvUGFja2FnZXMvDQoNCg==
