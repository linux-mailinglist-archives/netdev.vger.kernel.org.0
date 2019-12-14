Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3AD411F3F3
	for <lists+netdev@lfdr.de>; Sat, 14 Dec 2019 21:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726987AbfLNU2Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 15:28:25 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:1534 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726484AbfLNU2Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 15:28:25 -0500
Received: from pps.filterd (m0109333.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id xBEKS9Vr019781;
        Sat, 14 Dec 2019 12:28:09 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=j1upUzC43Q1Jjrc1ylYjrZBYorzDn/+DOF8r3XRjnIE=;
 b=pMaNpQscGul+59EUknVOG3E3nz0n6Rux3pUpPLY0UuHBS97PkSYRiggzc8aJeU5KZwzy
 oJgG+jxruC7yT4I4PXwrXyM4QDpeSPD1Plmhyzs9qu/0tzLKoqq0Eirf5fbwcu1VQS3v
 OKAD3sxOYhyvK10Zg4HX+iZZ1kpk9Iw96sc= 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com with ESMTP id 2wvvnf9fed-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT);
        Sat, 14 Dec 2019 12:28:09 -0800
Received: from ash-exhub202.TheFacebook.com (2620:10d:c0a8:83::6) by
 ash-exhub102.TheFacebook.com (2620:10d:c0a8:82::f) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Sat, 14 Dec 2019 12:27:37 -0800
Received: from NAM04-CO1-obe.outbound.protection.outlook.com (100.104.31.183)
 by o365-in.thefacebook.com (100.104.36.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Sat, 14 Dec 2019 12:27:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Afp8N20daC7r8VHUDf/pmo5kwezvA7UvI0/UfGsKgarPCtSzdIbACpOjzfsxGs55e1rVzIGMQbrwZtkqFiV3Q3DtXDFglhWNx3JjsqWJb9pzH4MoV0Zl29qTG4WCZn6L4cvJHn0oMCZSatfPMckfuNb2QM8DD1aFumMtBKETCXe4tFE6duusWVytVOZusf0yNHOImUqmOZoqNuKBARQ0JgBTnukwJ22EW1/RksE1ccKs4eGTtQmP9F/T31jc0miSk6rr33rgyehxp9a9a2FM16OjAXY6Gq34udGiIleZt8GG/h664+x7z+YsnsC9hONsu8DLaSW0e4Tf+e50VKUChQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1upUzC43Q1Jjrc1ylYjrZBYorzDn/+DOF8r3XRjnIE=;
 b=UCMHPrPn4pdopefrjQfc5FmvX0/7UiTfLkH+vT1sHCZGwyMSPlBdoFqGDXLBwPjLZbQXvUEk0+SwXDfRzAhgip4TxO1mbqbNpxGdBhcyaetvQWHm472tCOLo24ugcQCgXbYGewE4GdMGMDCXlDa+Ig2Wj4BySGF5+lNAru8VF3xDIaLPdQHQK+14T7gmtQ1cAbOrcoD5HeeAVRrZnX78A/H2fxdNMSwuOKwpy0wOzaoK4dE53jKrAwNrJoY5Kl0gM6nVQwdIRozmPHk9yuYVLW+4ZdTOgGaGd5iChWM7zmjJKbtcE8r6fN2DCI6md2XhcCD69M6yze9/JYTRWkDkFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=fb.com; dmarc=pass action=none header.from=fb.com; dkim=pass
 header.d=fb.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j1upUzC43Q1Jjrc1ylYjrZBYorzDn/+DOF8r3XRjnIE=;
 b=bG/cDw+VnX7znAt3zx40JB/HIV+4eenfecZxU2ujIoafYQpO5VvVAci6sgKVXtvKDQv2tAYq8RMOl6DYZRj/04482bGwIm/5CEm5ZSNTCdMz2MAMfEASnHawukXE0fMkGmjEbYwktgwk6103EM4sE0OAhUncPiwcX51jXQU5ryI=
Received: from DM5PR15MB1675.namprd15.prod.outlook.com (10.175.107.145) by
 DM5PR15MB1897.namprd15.prod.outlook.com (10.174.247.137) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.19; Sat, 14 Dec 2019 20:27:22 +0000
Received: from DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23]) by DM5PR15MB1675.namprd15.prod.outlook.com
 ([fe80::2844:b18d:c296:c23%8]) with mapi id 15.20.2538.019; Sat, 14 Dec 2019
 20:27:21 +0000
From:   Yonghong Song <yhs@fb.com>
To:     =?utf-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        "Andrii Nakryiko" <andriin@fb.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
CC:     "andrii.nakryiko@gmail.com" <andrii.nakryiko@gmail.com>,
        Kernel Team <Kernel-team@fb.com>
Subject: Re: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
Thread-Topic: [PATCH v4 bpf-next 2/4] libbpf: support libbpf-provided extern
 variables
Thread-Index: AQHVsn0Q6i6jBTftqU2D56m3YBiNJae6FMeA
Date:   Sat, 14 Dec 2019 20:27:21 +0000
Message-ID: <c5f3bc99-1e1d-f8cf-2bbe-5e86c61c64b6@fb.com>
References: <20191214014710.3449601-1-andriin@fb.com>
 <20191214014710.3449601-3-andriin@fb.com> <87a77vcbqt.fsf@toke.dk>
In-Reply-To: <87a77vcbqt.fsf@toke.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: CO2PR05CA0102.namprd05.prod.outlook.com
 (2603:10b6:104:1::28) To DM5PR15MB1675.namprd15.prod.outlook.com
 (2603:10b6:3:11f::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [2620:10d:c090:180::6b2d]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3b85843-9e4a-404f-f595-08d780d40572
x-ms-traffictypediagnostic: DM5PR15MB1897:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR15MB1897F9A6922ED8A6A0574B46D3570@DM5PR15MB1897.namprd15.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 025100C802
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(39860400002)(136003)(366004)(346002)(376002)(189003)(199004)(110136005)(31696002)(66446008)(64756008)(66556008)(31686004)(66476007)(316002)(66946007)(2616005)(8936002)(8676002)(6486002)(6512007)(81166006)(81156014)(86362001)(71200400001)(186003)(2906002)(54906003)(6506007)(53546011)(5660300002)(52116002)(36756003)(4744005)(4326008)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:DM5PR15MB1897;H:DM5PR15MB1675.namprd15.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: fb.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HJD9kYr9KxNloKbGJLwFKAVk3AzKfcQWEF5lcuEexR5mhKfnPdHYdiToDAcS6COEXXOsfxj+BBd0DLaj7FzBC1BkpV3XxOdGkMkswcrN7hGURxkeJ3f4Q2x9+8Eot8L+xW9PgxQJyfe8sl2W6SPq/lXcJ18nr6MI+gZhHiPTr8b7YPebMpQPq04D1FDdCM9Je6TS7i0Nz3yQC0b0N2U294NKitif3Sq32oGFAG/ohE4S1Sd+J56SeUdYCqUFzzPNBqZDKv8uoK00qQiGRx2Zz8uTWnnbrqjVpzqD7Cr+IOd5BdABMNBrXR7E5sOzGVHnU152KLWXLC5ofwDtGDvMUyL6wbadWYvJcVq7w6BJY4rOGwPtpk9v2QKSxx3VVwIsUiQ0DJ8pe145YqT4s+QRffSc4E+u8YpmFoE/IOmS1/icQbrDasgHiTx74+NnkVXI
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DE5C225290F4145AB269C89E2F0D34B@namprd15.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: a3b85843-9e4a-404f-f595-08d780d40572
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2019 20:27:21.5683
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ae927fe-1255-47a7-a2af-5f3a069daaa2
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IgSlJmtjxKhD9gjuogDICfAHVQcTcAoEx+mX3c0h8+ptZK9PmAcNc+RtDQlqsAlm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR15MB1897
X-OriginatorOrg: fb.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.95,18.0.572
 definitions=2019-12-14_05:2019-12-13,2019-12-14 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0 mlxscore=0
 bulkscore=0 adultscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 suspectscore=0 mlxlogscore=775 impostorscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-1912140156
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEyLzE0LzE5IDQ6NTAgQU0sIFRva2UgSMO4aWxhbmQtSsO4cmdlbnNlbiB3cm90ZToN
Cj4gWy4uLl0NCj4gDQo+PiArc3RhdGljIGJvb2wgc3ltX2lzX2V4dGVybihjb25zdCBHRWxmX1N5
bSAqc3ltKQ0KPj4gK3sNCj4+ICsJaW50IGJpbmQgPSBHRUxGX1NUX0JJTkQoc3ltLT5zdF9pbmZv
KTsNCj4+ICsJLyogZXh0ZXJucyBhcmUgc3ltYm9scyB3LyB0eXBlPU5PVFlQRSwgYmluZD1HTE9C
QUx8V0VBSywgc2VjdGlvbj1VTkQgKi8NCj4+ICsJcmV0dXJuIHN5bS0+c3Rfc2huZHggPT0gU0hO
X1VOREVGICYmDQo+PiArCSAgICAgICAoYmluZCA9PSBTVEJfR0xPQkFMIHx8IGJpbmQgPT0gU1RC
X1dFQUspICYmDQo+PiArCSAgICAgICBHRUxGX1NUX1RZUEUoc3ltLT5zdF9pbmZvKSA9PSBTVFRf
Tk9UWVBFOw0KPj4gK30NCj4gDQo+IFdpbGwgdGhpcyBhbHNvIG1hdGNoIGZ1bmN0aW9uIGRlY2xh
cmF0aW9ucyBtYXJrZWQgYXMgZXh0ZXJuPyBJJ3ZlDQoNClllcy4gVGhleSBhcmUgdHJlYXRlZCB0
aGUgc2FtZSBhcyBvdGhlciBleHRlcm4gdmFyaWFibGVzIGluIHN5bWJvbCB0YWJsZS4NCg0KPiBz
dGFydGVkIGxvb2tpbmcgaW50byBob3cgdG8gaGFuZGxlIHRoaXMgZm9yIHRoZSBzdGF0aWMvZHlu
YW1pYyBsaW5raW5nDQo+IHVzZSBjYXNlcyBhbmQgYW0gd29uZGVyaW5nIHdoZXRoZXIgaXQgbWFr
ZXMgc2Vuc2UgdG8gcHVsbCBpbiB0aGlzIHNlcmllcw0KPiBhbmQgYnVpbGQgb24gdGhhdD8NCj4g
DQo+IC1Ub2tlDQo+IA0K
