Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CC7F3093C9
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 10:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhA3Jzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 04:55:46 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:2092 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230236AbhA3Jz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 04:55:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10U9ofLe007785;
        Sat, 30 Jan 2021 01:54:43 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=2S+veMk2BQ9N9SJ04SEfdW2TKoK80ZLxgB+aRpMaSKw=;
 b=jFUSH9lQ43i06GCo8jLbgngYBcTZtkP2GrP65YSecAArzJv8l5UAWiBmfk6Mu/ofFye5
 oMc9iK94+nyZlAn5EMOKmcpxqYLGoFROBOTf5Ql7eTVPn3jUNHVd8dwRrL0waGawOTSV
 A+5MFfvwr7b2I+8UNvBdWdFRuQfPvY/mxYjOAor+SBziQEl11WujFd7B0TAtQXbBhZ35
 s/HVEouq2znIRn0aWa548Crl9cBKE6V98VtsZ0pdMrhMgTeJPG92A/te0KzYfs2Tl830
 DIs7ohZbJZIJVl8YoZakMdnOjI/pqy73brxyFRXGCzp1HgHdqjq8xK0t4tqUeXrW9TXU DA== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 36d0kd8bxp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jan 2021 01:54:42 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:54:40 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 01:54:40 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 30 Jan 2021 01:54:40 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ITCMmLsb9FDpl0SKgzEyZDp9gb1UKH82RvkKVtX91xjJhuDp5BvDEQyfpdHK55tP16lpjTcFpNmYNlmqhdUmuVGRwy4ycMZzG8DnaFS8UQl+N86EWhh5175zFntIt6CrRPdR+eCFplaDS175RwtsuwTmfKas7UL1XezdYUtVoL5AX2u7dc+eMX3f8zw2kSIZfP6/6zKyuHh0B/HQAOHaqJZg0aA9nkutw34mdrqg8VEx1g3bTAEYQnXoDYD8Sv6xYXP0G/0EhVL+fdWw8yFg0hXMCZPY/n1Cod3EZZbmaYGoAOoBbXp/ULSgIEaqGBnnNJ2kQb98heYtP1GF8Cn7nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2S+veMk2BQ9N9SJ04SEfdW2TKoK80ZLxgB+aRpMaSKw=;
 b=Rvk4YXGvGygrpogUoyqmstE+xJ5F4NUdehcLhoD2HNqzLc/dVHtLjIgPLFpsEoQdo4++vyPqCvzMEY04g8j7sOttEpSjtciggoj/4hn9mq3gnLiGXNTu0W/Gic+VQ5vsJxlUrRS4bzUBBsEbozwuBvkttzxdwOFiLqih/p54EU6062b7zy59Vsb9Fi0IA9KwsJrsdG3gxJQEt4rvUbn6SPXZtMkmEfNaq1faXvd/DDex7tPLTn9p3wnfRyxSpeKLvMPbelRl/4XhvS64H4YP3OZDQp04wIKuQadHiue3xmr6sLY9XdYO/02Zz8Soyi0NxamGjdIUi5qFLJz7kXn/2Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2S+veMk2BQ9N9SJ04SEfdW2TKoK80ZLxgB+aRpMaSKw=;
 b=dqawWcqtC+69jhDIMMv2ri351ARhh/R9i0EehBCncn1lyO3+EGZ2tLtdd4qfRL8X5jVtS9wSw2o+o79UrltRpeACf849N4ypsWgtuaYGsRyFJ3An1V8f5l8f/y8Vx0wsgfHc4PNa9GYTHl1OODn4zBtgLbzZYAlU83Ki8HWJv1g=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by CO6PR18MB4052.namprd18.prod.outlook.com (2603:10b6:5:34a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Sat, 30 Jan
 2021 09:54:39 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 09:54:39 +0000
From:   Hariprasad Kelam <hkelam@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>,
        Christina Jacob <cjacob@marvell.com>
Subject: Re: [Patch v2 net-next 4/7] octeontx2-af: Physical link configuration
 support
Thread-Topic: [Patch v2 net-next 4/7] octeontx2-af: Physical link
 configuration support
Thread-Index: Adb27clNk/4pkvf3QGiyGc3k/iMarQ==
Date:   Sat, 30 Jan 2021 09:54:39 +0000
Message-ID: <MWHPR18MB1421D57C85423CC571AB4F3ADEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.216.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ac41d5cd-8e23-4c83-1429-08d8c5050f79
x-ms-traffictypediagnostic: CO6PR18MB4052:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB405293CEDA4FBF59C8A94850DEB89@CO6PR18MB4052.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lE8IZF0/4VlLggcR8vlYetvZYkXegqKWF42WZ7o2yZMAYdgOuOB+j32wYcRMYZrBnXWeonjtdNntkMhp7qnoq0yiEvM4S9kr9sBFrzCPdp6M5nrcJd50sCQa6TsN3aOSYFB2AEJi9Y2lYUIaQbhkUzLUg3sqItj2tMm+UI6wVjMx5KqFiDMrb2mFEW64Ug/spztUm5A8cEi7b9gn8s0ZuE5w+Tv5OiPN7OtzlIHrvFr0c7RdE02ciTCwtCuQE/10Rbu83DA86uFc0UPtLDQidhOcy768VVfjLzVd2mkVdlNCaQTXGqSEjWeTG2IIFRxcHKOzhKshPBZyjow7vMmt5mj1LaDsAXRNtXK3PBiG7LE2CZzCPAU3QcqUJ7/0hfC4/GHICbpZR8S/OcPrnYb0TGuDXG4olJXh/w33m+ruXqbS8Nts8+KFSQWDdnvnWMfTzf9QqaoVqDAs4enCpLn/dKMVuMwPt9Pzslz9WGQTorX5Fqw/Ja7hKwpug8/XmPsDwR6Y/SOoJDCiMBIAVf1Wgg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(39860400002)(376002)(366004)(346002)(136003)(7696005)(52536014)(33656002)(8936002)(5660300002)(186003)(26005)(76116006)(66946007)(66476007)(66556008)(66446008)(6506007)(53546011)(55236004)(8676002)(64756008)(6916009)(4326008)(86362001)(71200400001)(83380400001)(55016002)(9686003)(107886003)(478600001)(54906003)(316002)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?WlpXWVR5TEt5ZjJHQVA4WFdsT1VXdFRsRnhxNFN1S1NCenE5VnRKcDFGZFZ0?=
 =?utf-8?B?a3NoTTNIWmpHTmt4YVlzNVJsbi9La1B0WHk1MmVRck43ZXN1b2Y0VkswK2x4?=
 =?utf-8?B?YzVuSVAwUExHbmNPOUNzeEtaQk94eWxSM01yNUFScVVIZ3VLdCtrZ05mcVh2?=
 =?utf-8?B?Q2JyWjFwMVg1aGcrZVJlelhYdk94WTNCYnJyUVdUTk9vcElRSXNvdzY2bUpH?=
 =?utf-8?B?M084VXJtN2g4cDN5NDVJU0xWODN5QUdlZURzVjlrT0xiSnQrclRYYk9PVHR6?=
 =?utf-8?B?aEdLeWNBK203b1pBUWZqOFI0aEJ2Vk5VSnVyUnp0Nm1sdGZDc1g5SUlPbitu?=
 =?utf-8?B?SEhva2FuVURydFVEZXRPY2FWNm5qdzBiY09kZlNqeWhzczYwZzYyMkJDbmF1?=
 =?utf-8?B?b3duS0lrNG1PL3NGbzBrOHlqYnBWQXFaNjlXMTNlRE1INndKQkNmYmVlcnUw?=
 =?utf-8?B?U1lnRkFxdFBZdkROK3E5Nks3cU1nQ1ZYUjN6bVVMMHhMUzFVWEFHUzcycjBS?=
 =?utf-8?B?TTR0OFM3amlMUEV0ZVZYQTk5eGRkTnZoZ3orN0hQbkQzSjlncldzTWNrS3Jv?=
 =?utf-8?B?akRnNUwvRmFTY0JCNGJ1WStodmtNMmlzMjY4QmVOZXRaMGM2cDFqRGNYNFVo?=
 =?utf-8?B?S3d1SU5NcndyVmpCdVFZSDJnMEozVXFwK2wyZFVrSWlSc2ExN1UyT2hvMkgz?=
 =?utf-8?B?bUN5cjF6MERlRGZJOVdHcVgyYitSYTVBWUg3T0RSVVluN1pHM1JHRFNYZkZT?=
 =?utf-8?B?UlNSWGtDcGMrZFYzMTM0MW5iWTIwL0tZeS94OUlQTUsxcnRWTForVTRKdmd0?=
 =?utf-8?B?cGUwVGRhT2lENG9hUEUrZ001cDdTODRkbkNocDh3N295Mm95VEVmOEhmQnlw?=
 =?utf-8?B?SE40eTJzNjBJSnFWUU9EbDVqQVA5b1V4Yy95ZnZhNEVUQ2N2Y0I2NDlUNDlT?=
 =?utf-8?B?cXVqSi9tRmNrQTc5L1h2bmVRUjhQTlZKK1RoSlRGNzd0UjRsSWNRWGhDTWhn?=
 =?utf-8?B?czZVRzYrcDVubHFFWVZ5TjZRY0ZORHhjN0V3TkttZU42RW5mRGJwT1dJUHRD?=
 =?utf-8?B?cGhuTWowMVBWM00yaFQrSUZWTSs3ZkhZZXVZZWt2emFxOVFnWHdjcjhJd01n?=
 =?utf-8?B?dFpaQzhDTmVZcHZMRnJibE11NHVacUgxVkJiZFhTNzlkZXdVeHFvejBJRCtu?=
 =?utf-8?B?cVZUVkFpTFlFcnMwZmY3NGltRnNsZi83T0lFY1JLNzQ0azBaMVd6MGU2aGha?=
 =?utf-8?B?TTMzRDZ2QUFRZEVkcklURkFYK3VPcXNmTXJOeFUvOW42UmRmK0pRRU5ndUJW?=
 =?utf-8?B?Y2pQRWZkZS82LzZTNU9sWHJ3Y2hoc0l3cnN5NXdkS2pPd3dmcUZzM2hXeGYv?=
 =?utf-8?B?R0ltRnFFdms0NmZyc1RGZzJ2UkY2c0VDOFpHcWtGU3ozNHhhWVlrZ0xSRlM4?=
 =?utf-8?Q?zkdl0/Pr?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ac41d5cd-8e23-4c83-1429-08d8c5050f79
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2021 09:54:39.5787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 76Kq+zGErqwTj6MAvnQ1mCF+w8YKn0cG4B4GmtV/8E1NpEdWH4A0/ffRzj6apcoetp3OA03j7/1Nfd1cJoWjXA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB4052
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-30_06:2021-01-29,2021-01-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQoNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBX
aWxsZW0gZGUgQnJ1aWpuIDx3aWxsZW1kZWJydWlqbi5rZXJuZWxAZ21haWwuY29tPg0KPiBTZW50
OiBUaHVyc2RheSwgSmFudWFyeSAyOCwgMjAyMSAyOjA0IEFNDQo+IFRvOiBIYXJpcHJhc2FkIEtl
bGFtIDxoa2VsYW1AbWFydmVsbC5jb20+DQo+IENjOiBOZXR3b3JrIERldmVsb3BtZW50IDxuZXRk
ZXZAdmdlci5rZXJuZWwub3JnPjsgTEtNTCA8bGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc+OyBEYXZpZCBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1Yg0KPiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgU3VuaWwgS292dnVyaSBHb3V0aGFtDQo+IDxzZ291dGhhbUBt
YXJ2ZWxsLmNvbT47IExpbnUgQ2hlcmlhbiA8bGNoZXJpYW5AbWFydmVsbC5jb20+Ow0KPiBHZWV0
aGFzb3dqYW55YSBBa3VsYSA8Z2FrdWxhQG1hcnZlbGwuY29tPjsgSmVyaW4gSmFjb2IgS29sbGFu
dWtrYXJhbg0KPiA8amVyaW5qQG1hcnZlbGwuY29tPjsgU3ViYmFyYXlhIFN1bmRlZXAgQmhhdHRh
IDxzYmhhdHRhQG1hcnZlbGwuY29tPjsNCj4gQ2hyaXN0aW5hIEphY29iIDxjamFjb2JAbWFydmVs
bC5jb20+DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUGF0Y2ggdjIgbmV0LW5leHQgNC83XSBvY3Rl
b250eDItYWY6IFBoeXNpY2FsIGxpbmsNCj4gY29uZmlndXJhdGlvbiBzdXBwb3J0DQo+IA0KPiBP
biBXZWQsIEphbiAyNywgMjAyMSBhdCA0OjAyIEFNIEhhcmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBt
YXJ2ZWxsLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBGcm9tOiBDaHJpc3RpbmEgSmFjb2IgPGNq
YWNvYkBtYXJ2ZWxsLmNvbT4NCj4gPg0KPiA+IENHWCBMTUFDLCB0aGUgcGh5c2ljYWwgaW50ZXJm
YWNlIHN1cHBvcnQgbGluayBjb25maWd1cmF0aW9uIHBhcmFtZXRlcnMNCj4gPiBsaWtlIHNwZWVk
LCBhdXRvIG5lZ290aWF0aW9uLCBkdXBsZXggIGV0Yy4gRmlybXdhcmUgc2F2ZXMgdGhlc2UgaW50
bw0KPiA+IG1lbW9yeSByZWdpb24gc2hhcmVkIGJldHdlZW4gZmlybXdhcmUgYW5kIHRoaXMgZHJp
dmVyLg0KPiA+DQo+ID4gVGhpcyBwYXRjaCBhZGRzIG1haWxib3ggaGFuZGxlciBzZXRfbGlua19t
b2RlLCBmd19kYXRhX2dldCB0bw0KPiA+IGNvbmZpZ3VyZSBhbmQgcmVhZCB0aGVzZSBwYXJhbWV0
ZXJzLg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQ2hyaXN0aW5hIEphY29iIDxjamFjb2JAbWFy
dmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogU3VuaWwgR291dGhhbSA8c2dvdXRoYW1AbWFy
dmVsbC5jb20+DQo+ID4gU2lnbmVkLW9mZi1ieTogSGFyaXByYXNhZCBLZWxhbSA8aGtlbGFtQG1h
cnZlbGwuY29tPg0KPiANCj4gPiAraW50IHJ2dV9tYm94X2hhbmRsZXJfY2d4X3NldF9saW5rX21v
ZGUoc3RydWN0IHJ2dSAqcnZ1LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHN0cnVjdCBjZ3hfc2V0X2xpbmtfbW9kZV9yZXEgKnJlcSwNCj4gPiArICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgY2d4X3NldF9saW5rX21vZGVfcnNw
DQo+ID4gKypyc3ApIHsNCj4gPiArICAgICAgIGludCBwZiA9IHJ2dV9nZXRfcGYocmVxLT5oZHIu
cGNpZnVuYyk7DQo+ID4gKyAgICAgICB1OCBjZ3hfaWR4LCBsbWFjOw0KPiA+ICsgICAgICAgdm9p
ZCAqY2d4ZDsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAoIWlzX2NneF9jb25maWdfcGVybWl0dGVk
KHJ2dSwgcmVxLT5oZHIucGNpZnVuYykpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRVBF
Uk07DQo+ID4gKw0KPiA+ICsgICAgICAgcnZ1X2dldF9jZ3hfbG1hY19pZChydnUtPnBmMmNneGxt
YWNfbWFwW3BmXSwgJmNneF9pZHgsICZsbWFjKTsNCj4gPiArICAgICAgIGNneGQgPSBydnVfY2d4
X3BkYXRhKGNneF9pZHgsIHJ2dSk7DQo+ID4gKyAgICAgICByc3AtPnN0YXR1cyA9ICBjZ3hfc2V0
X2xpbmtfbW9kZShjZ3hkLCByZXEtPmFyZ3MsIGNneF9pZHgsDQo+ID4gKyBsbWFjKTsNCj4gDQo+
IG5pdDogdHdvIHNwYWNlcyBhZnRlciBhc3NpZ25tZW50IG9wZXJhdG9yLg0KPiANCj4gb24gdGhl
IHBvaW50IG9mIG5vIG5ldyBpbmxpbmU6IGRvIGFsc28gY2hlY2sgdGhlIHN0YXR1cyBpbiBwYXRj
aHdvcmsuDQo+IHRoYXQgYWxzbyBmbGFncyBzdWNoIGlzc3Vlcy4NClRoYW5rcyBmb3IgdGhlIHJl
dmlldy4gV2lsbCBmaXggaW4gbmV4dCB2ZXJzaW9uLg0KDQpUaGFua3MsDQpIYXJpcHJhc2FkIGsN
Cg==
