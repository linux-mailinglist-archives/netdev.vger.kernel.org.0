Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E32B14901F
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 22:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727233AbgAXV3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 16:29:18 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:22892 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725747AbgAXV3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 16:29:18 -0500
Received: from pps.filterd (m0109334.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 00OLNf4U029505;
        Fri, 24 Jan 2020 13:29:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=NnnhwtDFKYYdsTrgckuhQkL+DnWqSc8bnxrpNuQ+axo=;
 b=E398gRUnAULgH1hKRkVbr3Q4pStCbqwgTPiZk59eTPpPmRfBIoWanrs5KZoiA/9BXYp3
 ZLDNQTCv5vbisbJpp6fFOI/9u5ZTURdy7E6CNZhKNQAGTn08EPC4cwy3ASOw93Of3qR5
 Hr6BlmhPie0Y/cFLD/n9Y4rPHLz2tLBCjP8= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2xr62rrqy9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Fri, 24 Jan 2020 13:29:05 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.35.175) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1779.2; Fri, 24 Jan 2020 13:29:04 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M3X3pr3MBAQk+V/Bl5VIf1h4OLzFJI3/0is13JVOntqkTLpLVNiHyyt357uJl0VwPrQ9Ml/XLUehjheYJPGXKTIMXEp6ffwcoehddUd341felXdra2/E1Ngh08rUlolb94nw3FEvKZLhCFOa33+7k1Da7sIvBTQsQUHoGIPmxsYujVB0oQQ7zTRINSHF+u/rBVqgc08VSr3bxNFHXQFtPE1ZUh5v4SNQHVaxmJgQV/G4Tg+mGxjpN2I8BYyXIbdZo5cRXlP/vhHeA3QgbGBjJnde9jhFuN1WmbPHVT6ZYeGy+SoWw/HOmCWkFpWjkOEgHOKrDbqK8EeK/aLWgqZaQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnnhwtDFKYYdsTrgckuhQkL+DnWqSc8bnxrpNuQ+axo=;
 b=MvfV+IOWfQi4v2dJrF8Ie4nR28LlJWKBnE8eafJZJcnPnpRp5LU7FjjMGggCnvRKyTzBnIsLJmbjYQl53Jdv+Hu/i6/zMqCiJ/IsAZAwikvXX4EE+gwZcr7C+EBdNZpFoL2O3kiF65UwlGHrw7fondX35VlkBVGSYiBaFlNpxRRdJ7eqNA3rRZUeqCc5BAepxyRMPQIQYpTx6P2AVEdI0zJiRWOd4KgB6CjahH63aeDY3rTR3xkc3rAfBQGWaiDzuMkw68fVX2g45MGcW4dSbsetgHRJQtUgKaufkgmlukdQBESbzAAK4jGgmZBH1/0qfjHprER8HGUuGzmqAGOkEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NnnhwtDFKYYdsTrgckuhQkL+DnWqSc8bnxrpNuQ+axo=;
 b=Fsun2XVuSJBsL/P6WLr6uI/OPd+oEW70NBYa/xqzW5nr/e+qil2r+mC//cWBTeA1Udk/omGxL8rrXdZwq9jNmK0A+W2Oh85iPVitaJuo51UfKxGuSve0RLEGBa3ThdPV0CaSk9NsGiNT8griFI4CC8912xzhcfOIM9CEziBSXn0=
Received: from DM6PR15MB3001.namprd15.prod.outlook.com (20.178.231.16) by
 DM6PR15MB2857.namprd15.prod.outlook.com (20.178.229.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2644.18; Fri, 24 Jan 2020 21:28:55 +0000
Received: from DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2]) by DM6PR15MB3001.namprd15.prod.outlook.com
 ([fe80::1d74:b392:183e:c8c2%6]) with mapi id 15.20.2644.028; Fri, 24 Jan 2020
 21:28:55 +0000
Received: from MacBook-Pro-52.local (2620:10d:c090:200::bdf3) by MWHPR08CA0039.namprd08.prod.outlook.com (2603:10b6:300:c0::13) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Fri, 24 Jan 2020 21:28:54 +0000
From:   Yonghong Song <yhs@fb.com>
To:     Andrii Nakryiko <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        William Smith <williampsmith@fb.com>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH bpf-next] libbpf: fix realloc usage in bpf_core_find_cands
Thread-Topic: [PATCH bpf-next] libbpf: fix realloc usage in
 bpf_core_find_cands
Thread-Index: AQHV0v1HZm9bNnoDcEu5M3+eHyP+Mw==
Date:   Fri, 24 Jan 2020 21:28:55 +0000
Message-ID: <7fdde53d-2d49-7e04-c2e6-51e4285b994e@fb.com>
References: <20200124201847.212528-1-andriin@fb.com>
In-Reply-To: <20200124201847.212528-1-andriin@fb.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MWHPR08CA0039.namprd08.prod.outlook.com
 (2603:10b6:300:c0::13) To DM6PR15MB3001.namprd15.prod.outlook.com
 (2603:10b6:5:13c::16)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:200::bdf3]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 32444638-4b87-4411-cfef-08d7a1146a40
x-ms-traffictypediagnostic: DM6PR15MB2857:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR15MB2857AB543BE9E069A914DBDFD30E0@DM6PR15MB2857.namprd15.prod.outlook.com>
x-fb-source: Internal
x-ms-oob-tlc-oobclassifiers: OLM:331;
x-forefront-prvs: 02929ECF07
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(346002)(366004)(136003)(376002)(189003)(199004)(2906002)(4744005)(86362001)(66946007)(16526019)(54906003)(66556008)(110136005)(66476007)(66446008)(64756008)(316002)(31696002)(5660300002)(71200400001)(52116002)(8936002)(6506007)(478600001)(81166006)(6636002)(81156014)(53546011)(6512007)(4326008)(6486002)(186003)(8676002)(2616005)(31686004)(36756003);DIR:OUT;SFP:1102;SCL:1;SRVR:DM6PR15MB2857;H:DM6PR15MB3001.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0NCZMOilfyYfQGtu0WoXzOAq49RqKJ6jFwjarV9dikeYnw1qY6w874hJoSR2tNhNgjwq/TTlwvcSH2+PupUcoVBtgDFbf3HHP6W3+si/r52BHLUjiUccRli9mmOxo3IoDJK0x5+Nzlj3NijqLbKFxgK4ZiLdp0nTXBNhEsHXGFzJbnWo4XqB0I9F+U9bRhh/OeUeFdaFmANUp/7m4s6f8ne53mAz+r31DnyKFYGZ6jIhcPlOItq6Rgk098LTq7JpxAzqAjOf5LnjgKeK1uWZ/K9JKVuGXBedeweilPr9V8nUGZ4ox9SxhjzHfuVebmHOOQN94FUUDF3gUnsvVm/yKKoiulhIT62Wavd80cG13f4rIJbSSXckwYm6zez9Ush/g14DJSJDTjgAg6ArHK/1qBAbqrXOSuAJtoQf3PUZ9D5h2Ha5TtflLBkNVdKbrcyR
Content-Type: text/plain; charset="utf-8"
Content-ID: <9EA99DDC0124F1419ADB2B367757E6EB@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 32444638-4b87-4411-cfef-08d7a1146a40
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jan 2020 21:28:55.2403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NePcZvjANpyEKu9+YyesAPZfmXSoUf+wak0Fae/8AkwdqAZj3ZKFEQEX8NrxTwPP
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR15MB2857
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-24_07:2020-01-24,2020-01-24 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 malwarescore=0
 spamscore=0 impostorscore=0 mlxlogscore=766 bulkscore=0 priorityscore=1501
 phishscore=0 lowpriorityscore=0 mlxscore=0 adultscore=0 clxscore=1015
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1911200001 definitions=main-2001240175
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEvMjQvMjAgMTI6MTggUE0sIEFuZHJpaSBOYWtyeWlrbyB3cm90ZToNCj4gRml4IGJ1
ZyByZXF1ZXN0aW5nIGludmFsaWQgc2l6ZSBvZiByZWFsbG9jYXRlZCBhcnJheSB3aGVuIGNvbnN0
cnVjdGluZyBDTy1SRQ0KPiByZWxvY2F0aW9uIGNhbmRpZGF0ZSBsaXN0LiBUaGlzIGNhbiBjYXVz
ZSBwcm9ibGVtcyBpZiB0aGVyZSBhcmUgbWFueSBwb3RlbnRpYWwNCj4gY2FuZGlkYXRlcyBhbmQg
YSB2ZXJ5IGZpbmUtZ3JhaW5lZCBtZW1vcnkgYWxsb2NhdG9yIGJ1Y2tldCBzaXplcyBhcmUgdXNl
ZC4NCj4gDQo+IEZpeGVzOiBkZGM3YzMwNDI2MTQgKCJsaWJicGY6IGltcGxlbWVudCBCUEYgQ08t
UkUgb2Zmc2V0IHJlbG9jYXRpb24gYWxnb3JpdGhtIikNCj4gUmVwb3J0ZWQtYnk6IFdpbGxpYW0g
U21pdGggPHdpbGxpYW1wc21pdGhAZmIuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBBbmRyaWkgTmFr
cnlpa28gPGFuZHJpaW5AZmIuY29tPg0KDQpBY2tlZC1ieTogWW9uZ2hvbmcgU29uZyA8eWhzQGZi
LmNvbT4NCg==
