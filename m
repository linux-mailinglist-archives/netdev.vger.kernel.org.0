Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C052DD6B8
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:03:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729601AbgLQSBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:01:19 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:11366 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727388AbgLQSBS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:01:18 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHHnjpv001606;
        Thu, 17 Dec 2020 09:58:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=Ny96ejtpIe4woFLcLlHhJlnd+d9LXkaJJcmsDEHPxKc=;
 b=dXWmHzLgSgYcFED54EYo1i1cv8tB7cCJwr+gVK5JMcRlJW28SE68phPlYBexGf/fBtY2
 x7Mtiev6BB+FWMRWZRmuvCqNeI7AFx7yHBKguHI5tlLO+8dpHZDtcK76jZ4e/sPi1p8s
 Iv4/tunxAIfXYyZDZqRTjGiIvDC4p8jQ9eEQkwbEGVb/OgQ/tyQaX2HwHPTKt1bB52Vg
 bOWRY0T1W8obkN49emruxYNyx2OcCMsX45kcwMlIgsW+jrEN239bcu4J3ATpIx+bADhb
 QZmwu/hOchcvbjxvm5Yl3G1P4JFqTOCXUMOUmZoY7RINNRJJKON3fWCQKG4pKoVxO4mo Zg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0a-0016f401.pphosted.com with ESMTP id 35g4rp1dk6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 09:58:18 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 09:58:16 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.170)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 17 Dec 2020 09:58:16 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TlkVl1FNb1+sUSIQ1Lqhr/LlVCeoiSpcUzhAjdl413UFsTFXrCZmjqgPgjJtKZDaRPv8L3AusaYDMA4+x27PNwQoRFQL80WDZ1E6x703yfBgIDd9ibDE9T+c3z45FFC/aHaeGpTPdQaM4UN8ZMWMPTEcr3vFprCvFEIZ06qpKhBJ8jU/PfzhbsgCgPNJA5Byp2gFN87+ARp9WB+7hHXRq2J37UqKOVzJyEI8kLj28xo31FLYg9denhodfYLf4sj3BwNiRDweA0rVZX+ajoMApSKWy6cd2ygcVDuXSE2Zz9rCiiOQtt95mpyrg+TsZHZs/WXgHTKtpfeV50QcUGu/fQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny96ejtpIe4woFLcLlHhJlnd+d9LXkaJJcmsDEHPxKc=;
 b=WO4YjhCWZjowA4rvu/gV953hKLCG48fYE8NopJVhWIWXpoiHfHCX40QVVUzvxWY8oHxA7swQqkcILKTIaquN+3MoleYVJfFkUeMdrBjWRZk9K2G6RI/5GvjSqhg+x/ngiRzw7Fd4uucB4hCE44Cy9+6HfiwLb2tfZZVkut1lw2xqrjI0LLVJsHp7WydVVUyiCZnzOw1CQCgB++9YNnVTNPSCnVEAzjES10/Fjx1RGUqpWTusnof7nzgjXFM1OWo8pgV1mD/noc4ziYDPZ1TA+2ugwMC73WdCYN4zlSj+g95m1HZ/LR1IrzVyDLZvps1z7mB8zEbV4p4rbvt96dCySQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny96ejtpIe4woFLcLlHhJlnd+d9LXkaJJcmsDEHPxKc=;
 b=gD2UJiqj3L177h1x2aF7MD7v+BGXk4seNBwaiGYmNI47E5YqINdB/ZsJZi4cRJTf2Qs332lhtnr9frJbowGsCi86fpmXY8stVKdOdFvQbN1Erq7Pn4X3ySd9cL+rDMGkoHcQCeQjcJZHUvQkM8FDnfqS6GN/S0xHkmaO2aGMwNc=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MWHPR18MB1407.namprd18.prod.outlook.com (2603:10b6:320:28::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.13; Thu, 17 Dec
 2020 17:58:15 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3676.025; Thu, 17 Dec 2020
 17:58:15 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Antoine Tenart <atenart@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "thomas.petazzoni@bootlin.com" <thomas.petazzoni@bootlin.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        Liron Himi <lironh@marvell.com>
Subject: RE: [EXT] Re: [PATCH net] net: mvpp2: prs: fix PPPoE with ipv6 packet
 parse
Thread-Topic: [EXT] Re: [PATCH net] net: mvpp2: prs: fix PPPoE with ipv6
 packet parse
Thread-Index: AQHW1JlZ20FjR2Ngt0Ocb1HQ+yZ3+6n7kacAgAAAYzA=
Date:   Thu, 17 Dec 2020 17:58:15 +0000
Message-ID: <CO6PR18MB3873527521A32529CF0A554DB0C40@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1608225791-13127-1-git-send-email-stefanc@marvell.com>
 <160822756622.3138.4566292085941876073@kwain.local>
In-Reply-To: <160822756622.3138.4566292085941876073@kwain.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.78.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 843a274e-5dd7-4194-48d2-08d8a2b553fc
x-ms-traffictypediagnostic: MWHPR18MB1407:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR18MB14075C1470F34FD5C5623B66B0C40@MWHPR18MB1407.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1850;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BLdaSGepi5XVzpA5kc/xamglAvlJcoKKcHke142YzK4HL66f4g19wJSagVk++fTyHY4kmQ1p8ybkCiuDYJDqRRiS62LlY6q3IIxRs+WeaD5OM/Ru0RpGZSL1MkNA2/S22UME7Ndii+mOeupz3h5ynsVYGYZeL1LQ45mRIKlSvvvMCfFZ62mIvu0Oau16h56/A1KxubWvrk8fZRKgCe28Hph6SyxQF2TJ9Ghi8PodCQULQl7VzdJoO0zuQpxMRAAGI/wFObwJlA9Gyw+v04L/3Z/MjauvbbCieDuUFnw3JSzTmE5kHayanutupKjoW4Xxo00vyyl8qys6YqAz5HqBMA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(376002)(136003)(346002)(39860400002)(66476007)(33656002)(6506007)(76116006)(54906003)(107886003)(8936002)(66946007)(478600001)(26005)(4326008)(55016002)(9686003)(316002)(52536014)(5660300002)(2906002)(186003)(71200400001)(66556008)(4001150100001)(86362001)(7696005)(8676002)(110136005)(66446008)(7416002)(64756008)(4744005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cGxKY0JwM1VwQWdDcEdWNW5rZkJhUVNpWHFLdFFNamFrSEhmamZhajRuTzM0?=
 =?utf-8?B?NVlxbnFTZWRiWFJ2SGdMMnNCN0p2MCtnY3JER2Z6ODRFZ0JWelkwTTBGQXdS?=
 =?utf-8?B?eVhjUWRBK0tDYTZFZmk0M3VBdTBseW03YlpUNWM5V2tRNjNQWDJlMUV4Y3g4?=
 =?utf-8?B?ZWxrSDhDa2xybTd5NTNlMG1xK3dGSUxQZmIyTU54TFNsYVZCMWpvOHFvVFVK?=
 =?utf-8?B?WjM3NnBiNjI3MW80R2JUazJhT2ovU1g1OERzcjVYZEtOUXp6V2FBTkJhZ3Mx?=
 =?utf-8?B?S2s3ckhvdTVoWWhsYnp0Ym9NQjhoNm5RNGR5djFWWDFUcEt1V3IzV1NvUTEw?=
 =?utf-8?B?c1Nhb1VXdVUvN0locDJHbHY4Z3Rud1pBVFR1bGZUcmMxN3gyTTB6NldEcUFs?=
 =?utf-8?B?WEllaktoKy9CeWZZczRaL3hRdjZTWDZzRjVFVlA2ZnRYR3VTK09FQXJzMGZJ?=
 =?utf-8?B?Mnd4SlROZW1LZ0RNVkJ1cFFBV2hCRkxYMm9yME9hZTk4alFQa0szQndyTTZT?=
 =?utf-8?B?L0YvMmlmcWJaL1FucjgrWnRlTnNXTGVGTzlnRWhIVTlDSitkWHRBMjc5dFBi?=
 =?utf-8?B?K2FXZjBJZUVQN0tQaTdlRVBuUXFOM0F5MlYwU0ZJZ3B4a0FGSXl5K0dPYTZ5?=
 =?utf-8?B?UGpvVjZ6cUV1Zy82b3RIbG1YTURzdnd6N0R1YVpCeEk2UFk0cUNWWTNrWVQ2?=
 =?utf-8?B?Q0VlMEN1dUFOZTZBNDRpMEkrSE1wUjJnK1BzY2lSZ0NoZUVrdWd6NVpsSURP?=
 =?utf-8?B?MExiREU1T1JaZW42bjNlY3kraDA1a1RzM2tTalQyYmoxV29QNUo3QjFOYyt0?=
 =?utf-8?B?elI1VEppOWhZSDNIb0M3N2s4UFVDQ0ZkZ1pYOVpUeTM1bWMySm00RmNZbjRq?=
 =?utf-8?B?WTRjbG91ODVEdk0vUStvTWowNkpsYitUcnpVSnlKMmlCRFdmbXJ5NUFRNG1z?=
 =?utf-8?B?UCs0VldxbUQ0b1A3ekUraW9CMWlYSUhwVmlIMmFhZjJHZ2VwN2hPL3IyZEk0?=
 =?utf-8?B?NlZya2k1WHdTYkJCOUZhT3JYclRBOEN5VVpoNVQ2R2k3bDAzNGZBTVVmcTlU?=
 =?utf-8?B?c1FYTGxjTGRsUFBIZUpBVm5wcjhJY2YxQ1dlaVdhZFd2Rjl6QTVsY3VCUFhH?=
 =?utf-8?B?YW1ubUg5cU1JY3ZEbjdMQWEwaXRidHRUaGZndjRKWGVhd3FRUmcrRXhrOWFt?=
 =?utf-8?B?b3BhWTdva3krbnFrUVVHRUxqRXJpMUZFQkRKQkkwRDFaYnZqajVnblhiLzhw?=
 =?utf-8?B?MjVwUzNoSktNTzM0ankzWEhUODcyMHpFWSsxWmZPN0hOa1RoUTZkRlorRHVD?=
 =?utf-8?Q?5riktFj9RaAOY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 843a274e-5dd7-4194-48d2-08d8a2b553fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 17:58:15.3374
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: rTQRrIrapUNFEWZApvYNrhYoHUiKcAVUBxlHp051xhKQgEdUtgCML+TdXyYRXjmjsSUFtogmGX6WfSFmPEY8bA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR18MB1407
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_13:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBFeHRlcm5hbCBFbWFpbA0KPiANCj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KPiBIaSBTdGVmYW4sDQo+IA0K
PiBRdW90aW5nIHN0ZWZhbmNAbWFydmVsbC5jb20gKDIwMjAtMTItMTcgMTg6MjM6MTEpDQo+ID4g
RnJvbTogU3RlZmFuIENodWxza2kgPHN0ZWZhbmNAbWFydmVsbC5jb20+DQo+ID4NCj4gPiBDdXJy
ZW50IFBQUG9FK0lQdjYgZW50cnkgaXMganVtcGluZyB0byAnbmV4dC1oZHInDQo+ID4gZmllbGQg
YW5kIG5vdCB0byAnRElQJyBmaWVsZCBhcyBkb25lIGZvciBJUHY0Lg0KPiA+DQo+ID4gRml4ZXM6
IGRiOWQ3ZDM2ZWVjYyAoIm5ldDogbXZwcDI6IFNwbGl0IHRoZSBQUHYyIGRyaXZlciB0byBhIGRl
ZGljYXRlZA0KPiA+IGRpcmVjdG9yeSIpDQo+IA0KPiBUaGF0J3Mgbm90IHRoZSBjb21taXQgaW50
cm9kdWNpbmcgdGhlIGlzc3VlLiBZb3UgY2FuIHVzZSBgZ2l0IGxvZyAtLWZvbGxvd2AgdG8gZ28N
Cj4gZnVydGhlciBiYWNrIChvciBkaXJlY3RseSBwb2ludGluZyB0byB0aGUgb2xkIG12cHAyLmMg
ZmlsZSkuDQo+IA0KPiBUaGFua3MhDQo+IEFudG9pbmUNCg0KT2suIFByb2JhYmx5IHRoaXMgaXNz
dWUgZXhpc3Qgc2luY2UgbXZwcDIuYyBkcml2ZXIgd2VyZSBwdXNoZWQgdG8gbWFpbmxpbmUuIA0K
DQpUaGFua3MsDQpTdGVmYW4uDQo=
