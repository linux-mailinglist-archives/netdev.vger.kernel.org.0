Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F9F3093FE
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 11:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231722AbhA3KGZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 05:06:25 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25196 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S231828AbhA3KGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 Jan 2021 05:06:01 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10UA1smd011750;
        Sat, 30 Jan 2021 02:05:15 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=wPGnR6pMCE4/rfiMh5APsx4rbrSH4dV5dF63WurCiQM=;
 b=eX6Dk2NE5EqAby/VLTZXkq0slzGc02Mj2rkIlXuFNSJmDhnG2Zx+ch34kNVvQUBt7aD7
 UMv1bHjWVrWLGOaerbqCCpPs3R4ZyN3bZQdrkh8AEOh5o6WvvXiw+OVjJkJVXpg0c/Eu
 rk4VjLokMizETQZvHQwewqJw1NnCEalZrvoH8MW9s64u1/nDukrLdny5ZgEwnINJe1Ct
 Sfwt4C4CHqwOojjgnjkzgdNgDlXrdB8YgXaZLFWsaeakkBo9HJKWhg1Z+Ifxce55ZZqu
 NXUXdDLMnHMdc+j90rZ56MiK5SabYgR7jnGwCpJwNLTqVzepur8vkMcEtMhHUzKo9ci4 zQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 36d0rsgbrr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 30 Jan 2021 02:05:15 -0800
Received: from SC-EXCH04.marvell.com (10.93.176.84) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 02:05:14 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH04.marvell.com
 (10.93.176.84) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sat, 30 Jan
 2021 02:05:13 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Sat, 30 Jan 2021 02:05:14 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qm6XUPfsmQJbdir1Tl5hRXHOTsqGKxGWJI81GkL31GK0WlM87IAVzbDyJms8ncHa3tjJosaxzvM9k4Otz1XACQnS4iXb1ld3+2pk3Zc8wNKQB+9C2a5wyh0Tg0vtZy1OUsRYL2VQdHLTTui+dlOrKZdCFLgKre50T/j4uEIF8157wTQF5nye7C3BuW4EYt5BV0U/pj+YpDKL8kfUkJrv6zfP4Uv7j5giBFXvxsuR+FBLEQnqGEvvRugQfXDt9hBBWUiV+oVVv+4SDL8xKyKO4dQ298ceyHwFrtNVG/cTfzIklNBLe4jutSDCVz2gBoF7vA/r9RSlG3G77mn2sTWcHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPGnR6pMCE4/rfiMh5APsx4rbrSH4dV5dF63WurCiQM=;
 b=KT0XRntyYJpCk+ZcHWvOvAmW0kAbe60xArRGWpCg9YpBlGhwynkjmIioBQvljbkx1IZBe1gjpd0E5hYTUSs13/gH3TinN3RJNs2h4piJjM5f5Xp7gyJE/VBMA4LMDFyzP5qMbxh9U6jDV30pQPsGJh5X+AKXnyIGgTWaFeo2O5J6r0jdd6WatG8PE3lUJ65BosnJgPsVLjI5EDsvSmORWez7bP4gGVMsfRZ/rpTh8lLDX0UH3IlTe7IyVQWhV8BGOFjKKcfDludr5e0+J95KpkIXj+k6i07JpMG4t2k3P0bSyUgUhVcUrLrbDKdpAvWxqCgsthwTdeBrAmL7bMAr/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wPGnR6pMCE4/rfiMh5APsx4rbrSH4dV5dF63WurCiQM=;
 b=j2UeMsDvBcNTNnoC3opLBL6LXVmgZlFbA57sLKvVuvg2WN+XI0bMQp3RD8EyDzp9DCMqGyNTXEGjn2VQamrvR48XJWyQGZ7t6gbM8CQRcgH9v7glN/o1POGQitBnRZXK45xwSOLmMsORWcKUsaXeQjzI5lhNI8ca+jqig9QsAEQ=
Received: from MWHPR18MB1421.namprd18.prod.outlook.com (2603:10b6:320:2a::23)
 by CO6PR18MB3795.namprd18.prod.outlook.com (2603:10b6:5:349::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16; Sat, 30 Jan
 2021 10:05:12 +0000
Received: from MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d]) by MWHPR18MB1421.namprd18.prod.outlook.com
 ([fe80::25eb:fce2:fba7:327d%4]) with mapi id 15.20.3805.022; Sat, 30 Jan 2021
 10:05:12 +0000
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
Subject: Re: [Patch v2 net-next 3/7] octeontx2-pf: ethtool fec mode support
Thread-Topic: [Patch v2 net-next 3/7] octeontx2-pf: ethtool fec mode support
Thread-Index: Adb27qg3bA6xoR/WRZqYSx6H0aPO/g==
Date:   Sat, 30 Jan 2021 10:05:12 +0000
Message-ID: <MWHPR18MB14219441C77FF415879C5773DEB89@MWHPR18MB1421.namprd18.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [117.201.216.226]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bcde92ab-1712-4532-9f9a-08d8c506886d
x-ms-traffictypediagnostic: CO6PR18MB3795:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB37957076F7BDFD9DE16F27A7DEB89@CO6PR18MB3795.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uZ292iBVnkCFj6qI0p0BLgs097x6k3sNpZEjBIJER/VE6FCtTUX1XUSZbliNFsUQLWur2ER0lnoUPICFOKjS+R3htzwK3naGgAn+5H7IavMYpuqj1hiPmlBKlMk5oSD61rojXuPwzolzZcsFsYsaxPRjdeiULzJq6201SOqLz+URC80t1f/vXNCyW+bhSMgQQJlC/1hi8XtVJZ1ffdnKshiEkcS4ZbleV8raDQcFVZjBnBx/sowSN5l2GNieE02+ebMz5tUKXXrv2CW6enPwUrCaShzwSDHG1uGENOJv4+4V9cjOJ4969xIe1rw51DVJRKlBOxgCVG1uv1BmWOtwmBSG0W/d+g5qsYIQ39B4rYQvZjVc29VIZURjNbr7KFbzuBMNdanafW4T05jJRtTSX7RX9M/8rmd4pkimWClzE1eGrY1yZHkDNAV+Lo9w36s3SbeswuN4urCq5l492a5NL1+NCTiCytvPIG5lKDHSBcib8oNg3J5ugjgRI49CMXcj0s1z1mMP60Ntt4m0dZA+4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR18MB1421.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(136003)(396003)(366004)(39860400002)(376002)(5660300002)(54906003)(66476007)(55016002)(478600001)(52536014)(6916009)(316002)(8936002)(26005)(4326008)(2906002)(86362001)(71200400001)(6506007)(53546011)(107886003)(55236004)(33656002)(66446008)(66556008)(186003)(64756008)(9686003)(7696005)(66946007)(76116006)(83380400001)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eXBzbW5VYkQrbHdpb1Erd1JyMFZaTURBYTRTT3FucEt4L1A1Sm9VSXMvQy9t?=
 =?utf-8?B?ei83RC90cEhER05BWkxNWEh1Y043Ri9WZ1BHWHEyRlF5eUM2QTVlNzZtejdH?=
 =?utf-8?B?cWxlNmZqN1BMcFJRVEJDYzd6YzgvWDRlVVFraGJtTDNndEpyRE9RYzBFZ1ZG?=
 =?utf-8?B?K2ZKUXpZUW5JOWpnczJTT2lTVlkzNFpNS2RKSnV4U2RxQjNDT3A1Syt5NlZq?=
 =?utf-8?B?Z3FadThPK2g1S2JLelIvN3Q0cWlObmpSUU42NnN1QW8wRitvVE01TFo3TUdD?=
 =?utf-8?B?SS9sUnQ5TjRqSWNQV0w0cE1CSzRLRGphclczd01TT2ZaMUdmYm9yQmQ3NDVG?=
 =?utf-8?B?Q2E1a2tkZlNkUnBOblFvQmxibHdVQk1haE54MWdlMnZhaHpyN01TU3M2QVhM?=
 =?utf-8?B?eVZiL1FPNzlXWWNWaHZmdGU5OWZFSTMzUnRlREI4T0dwTWxkcVpMbVUyS2Rp?=
 =?utf-8?B?OWNPNVZSVm9zQkpPT1VBVTZoamVuTjFxdUNBcm15ZUUySEl0K016WVhsNDJ1?=
 =?utf-8?B?a1BqWmJ0Q1dYc3FSV3NKWmRKQXdnSjR5c29oWUg3eFJ6Q0hha3E3UUdDd2tD?=
 =?utf-8?B?Q1RyUHdHNTlsYXByUDFlUE8zd0xISUVzZHVuUkhJNUFWUGNPczllMEU1WDlR?=
 =?utf-8?B?WlhCbjY4VjQ2aUdzUDlzY0RNOFB1dzhnRVdEanZLRnExbEI5aWdBOGNYWmg3?=
 =?utf-8?B?QWZGNHpWMkJCREJOSDZJTXE3K1J3eXpDcTk1WEF6NkJrN1pxQ2MzQ1NVM3Bi?=
 =?utf-8?B?SkV4OE84cUI5dlowL2hIeFE5bGhYS1JjQTlTaC90cGk0RERDQlhJTEJLalFW?=
 =?utf-8?B?OHRTdU5HRE5RRm9DejVZY3ZxWUV6Qjlpa01JaEIyc3AxdWxSZm45NkNXM3pQ?=
 =?utf-8?B?WHJCNnpHVXNqc1R1STJnK3pMOW5YMkJ2c2Mza3UwYXpMYWxqTnBBcTVkeTNU?=
 =?utf-8?B?MVlzUWxSN0Y0Y0o3T2tkbzIzYTF2SGloVGxKeHFxRitFODRuSE5hcXlPV1h5?=
 =?utf-8?B?OStYa3pFcDVVS0pqSXR0OCttR2hSdXRVVG5IZmNzRjFhZDhudnZNK2w0RmlV?=
 =?utf-8?B?N1NRUVJHMjI2U2FjWksrYWcvekNqYitOd040Tm50STcvVTExNGFsbWVISU5I?=
 =?utf-8?B?UWVOeUt0ZWNOK1pEY21pRWk4TldGdWFNNkIvUzZOazI0KzVmV1NNYlVHaUJJ?=
 =?utf-8?B?RGNHMUlPZjlCWklCV1A4VnMxZU8vbWl5TlJBdUxtZnlKT0phZGllTkgrR3Nr?=
 =?utf-8?B?MlBQY0p0ZmgrVWJNY2xUM2ZDNzJMZ2tOU0VCWmJ1eGhvU0pqYWtDM3JwMVBK?=
 =?utf-8?B?L0Vqb3ZRWHZQT1lpVlMydXBoR240VHZGVlF6S21iekVpUzNKYnhMNUM1UVhP?=
 =?utf-8?B?aytRUFF5MEI1VmcvV3ZnMUFyTzlOZG9QdytDbVJuLy82SVFWYnNOVllvRGI4?=
 =?utf-8?Q?MkfDBaIU?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR18MB1421.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bcde92ab-1712-4532-9f9a-08d8c506886d
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jan 2021 10:05:12.0337
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dQqZLJOVLjnKkqKN1JwWTDKrzlntbNjeywT/ujlsXFoBDRarA4KOYntATgg0+ORimV7AOQq83Z34ba4kICKiOg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3795
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-01-30_08:2021-01-29,2021-01-30 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgV2lsbGVtLA0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFdpbGxl
bSBkZSBCcnVpam4gPHdpbGxlbWRlYnJ1aWpuLmtlcm5lbEBnbWFpbC5jb20+DQo+IFNlbnQ6IFRo
dXJzZGF5LCBKYW51YXJ5IDI4LCAyMDIxIDI6MDEgQU0NCj4gVG86IEhhcmlwcmFzYWQgS2VsYW0g
PGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gQ2M6IE5ldHdvcmsgRGV2ZWxvcG1lbnQgPG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmc+OyBMS01MIDxsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZz47
IERhdmlkIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+IEtpY2luc2tpIDxr
dWJhQGtlcm5lbC5vcmc+OyBTdW5pbCBLb3Z2dXJpIEdvdXRoYW0NCj4gPHNnb3V0aGFtQG1hcnZl
bGwuY29tPjsgTGludSBDaGVyaWFuIDxsY2hlcmlhbkBtYXJ2ZWxsLmNvbT47DQo+IEdlZXRoYXNv
d2phbnlhIEFrdWxhIDxnYWt1bGFAbWFydmVsbC5jb20+OyBKZXJpbiBKYWNvYiBLb2xsYW51a2th
cmFuDQo+IDxqZXJpbmpAbWFydmVsbC5jb20+OyBTdWJiYXJheWEgU3VuZGVlcCBCaGF0dGEgPHNi
aGF0dGFAbWFydmVsbC5jb20+Ow0KPiBDaHJpc3RpbmEgSmFjb2IgPGNqYWNvYkBtYXJ2ZWxsLmNv
bT4NCj4gU3ViamVjdDogW0VYVF0gUmU6IFtQYXRjaCB2MiBuZXQtbmV4dCAzLzddIG9jdGVvbnR4
Mi1wZjogZXRodG9vbCBmZWMgbW9kZQ0KPiBzdXBwb3J0DQo+IA0KPiBFeHRlcm5hbCBFbWFpbA0K
PiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBPbiBXZWQsIEphbiAyNywgMjAyMSBhdCA0OjAzIEFNIEhh
cmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gd3JvdGU6DQo+ID4NCj4gPiBG
cm9tOiBDaHJpc3RpbmEgSmFjb2IgPGNqYWNvYkBtYXJ2ZWxsLmNvbT4NCj4gPg0KPiA+IEFkZCBl
dGh0b29sIHN1cHBvcnQgdG8gY29uZmlndXJlIGZlYyBtb2RlcyBiYXNlci9ycyBhbmQgc3VwcG9y
dCB0bw0KPiA+IGZlY3RoIEZFQyBzdGF0cyBmcm9tIENHWCBhcyB3ZWxsIFBIWS4NCj4gPg0KPiA+
IENvbmZpZ3VyZSBmZWMgbW9kZQ0KPiA+ICAgICAgICAgLSBldGh0b29sIC0tc2V0LWZlYyBldGgw
IGVuY29kaW5nIHJzL2Jhc2VyL29mZi9hdXRvIFF1ZXJ5IGZlYw0KPiA+IG1vZGUNCj4gPiAgICAg
ICAgIC0gZXRodG9vbCAtLXNob3ctZmVjIGV0aDANCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IENo
cmlzdGluYSBKYWNvYiA8Y2phY29iQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFN1
bmlsIEdvdXRoYW0gPHNnb3V0aGFtQG1hcnZlbGwuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IEhh
cmlwcmFzYWQgS2VsYW0gPGhrZWxhbUBtYXJ2ZWxsLmNvbT4NCj4gPiAtLS0NCj4gPiAgLi4uL2V0
aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL25pYy9vdHgyX2NvbW1vbi5jICAgfCAgMjMgKysrDQo+
ID4gIC4uLi9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9uaWMvb3R4Ml9jb21tb24uaCAgIHwg
ICA2ICsNCj4gPiAgLi4uL2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL25pYy9vdHgyX2V0aHRv
b2wuYyAgfCAxODENCj4gKysrKysrKysrKysrKysrKysrKystDQo+ID4gIC4uLi9uZXQvZXRoZXJu
ZXQvbWFydmVsbC9vY3Rlb250eDIvbmljL290eDJfcGYuYyAgIHwgICAzICsNCj4gPiAgNCBmaWxl
cyBjaGFuZ2VkLCAyMTEgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0KPiA+IGRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxsL29jdGVvbnR4Mi9uaWMvb3R4
Ml9jb21tb24uYw0KPiA+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIv
bmljL290eDJfY29tbW9uLmMNCj4gPiBpbmRleCBiZGZhMmUyLi5mN2U1NDUwIDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvb2N0ZW9udHgyL25pYy9vdHgyX2Nv
bW1vbi5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIv
bmljL290eDJfY29tbW9uLmMNCj4gPiBAQCAtNjAsNiArNjAsMjIgQEAgdm9pZCBvdHgyX3VwZGF0
ZV9sbWFjX3N0YXRzKHN0cnVjdCBvdHgyX25pYyAqcGZ2ZikNCj4gPiAgICAgICAgIG11dGV4X3Vu
bG9jaygmcGZ2Zi0+bWJveC5sb2NrKTsgIH0NCj4gPg0KPiA+ICt2b2lkIG90eDJfdXBkYXRlX2xt
YWNfZmVjX3N0YXRzKHN0cnVjdCBvdHgyX25pYyAqcGZ2Zikgew0KPiA+ICsgICAgICAgc3RydWN0
IG1zZ19yZXEgKnJlcTsNCj4gPiArDQo+ID4gKyAgICAgICBpZiAoIW5ldGlmX3J1bm5pbmcocGZ2
Zi0+bmV0ZGV2KSkNCj4gPiArICAgICAgICAgICAgICAgcmV0dXJuOw0KPiA+ICsgICAgICAgbXV0
ZXhfbG9jaygmcGZ2Zi0+bWJveC5sb2NrKTsNCj4gPiArICAgICAgIHJlcSA9IG90eDJfbWJveF9h
bGxvY19tc2dfY2d4X2ZlY19zdGF0cygmcGZ2Zi0+bWJveCk7DQo+ID4gKyAgICAgICBpZiAoIXJl
cSkgew0KPiA+ICsgICAgICAgICAgICAgICBtdXRleF91bmxvY2soJnBmdmYtPm1ib3gubG9jayk7
DQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybjsNCj4gPiArICAgICAgIH0NCj4gPiArICAgICAg
IG90eDJfc3luY19tYm94X21zZygmcGZ2Zi0+bWJveCk7DQo+IA0KPiBQZXJoYXBzIHNpbXBsZXIg
dG8gaGF2ZSBhIHNpbmdsZSBleGl0IGZyb20gdGhlIGNyaXRpY2FsIHNlY3Rpb246DQo+IA0KQWdy
ZWVkIHdpbGwgZml4IHRoaXMgaW4gbmV4dCB2ZXJzaW9uLg0KDQo+ICAgaWYgKHJlcSkNCj4gICAg
IG90eDJfdXBkYXRlX2xtYWNfZmVjX3N0YXRzDQo+IA0KPiA+ICsgICAgICAgbXV0ZXhfdW5sb2Nr
KCZwZnZmLT5tYm94LmxvY2spOyB9DQo+IA0KPiBBbHNvLCBzaG91bGQgdGhpcyBmdW5jdGlvbiBy
ZXR1cm4gYW4gZXJyb3Igb24gZmFpbHVyZT8gVGhlIGNhbGxlciByZXR1cm5zIGVycm9ycw0KPiBp
biBvdGhlciBjYXNlcy4NCg0KQ2FsbGVyIG9mIHRoaXMgZnVuY3Rpb24gb3R4Ml9nZXRfc3NldF9j
b3VudCAuIFdoZXJlIGRyaXZlciBzdXBwb3NlIHRvIHJldHVybiBudW1iZXIgb2Ygc3RhdHMuIA0K
VGhpcyBmdW5jdGlvbiBpcyBqdXN0IHRvIHVwZGF0ZSBsb2NhbCBuZXRkZXYgY291bnRlcnMgZmVj
X2NvcnJfYmxrcy8gZmVjX3VuY29ycl9ibGtzLiBTbyBmYWlsdXJlDQpPZiB0aGlzIGZ1bmN0aW9u
IHNob3VsZCBub3QgZWZmZWN0Lg0KDQpUaGFua3MsDQpIYXJpcHJhc2FkIGsNCg==
