Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B1E3306382
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 19:46:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343980AbhA0Soy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 13:44:54 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:46282 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343862AbhA0Soe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jan 2021 13:44:34 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10RIa4bO012122;
        Wed, 27 Jan 2021 10:41:35 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=F1eV2FvHGB4u1s88A+EFQX1DzSSeC/haJ572f4eNCm8=;
 b=dgQo29jAen9mwmeC+y7pKGMG1SUEuierLnziMKsCs+5EUSxR77JYQwpGxR8Ugqx5rD60
 lWpD6Q9abEvfNyjEBVqMM8KuswS73cOSIZ6ZYFQEYHRwDknIpemoL3aEc5/RTTz51Fym
 9MJx4SpM6/2NIR7XdGXDB8PBH1q1Z1X1JW6p9InwrjINh6pTgTVDzofvX4fmj8phEwN5
 IKtadnw+ZjjEoTp6Uw5nrZobHSDLQ2Yj9asVZPzuDE8nEgLXedYM4lr7Kuw+6sRyoO3N
 NiXx9GQgpnZgy2JjycMDFknpKesK3UdExM5TEX61zpX7h0SDMr3aYki9rsLIG8SFmMyT SQ== 
Received: from dc5-exch02.marvell.com ([199.233.59.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 36b1xpj18h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 27 Jan 2021 10:41:35 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 10:41:33 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 27 Jan
 2021 10:41:33 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.46) by
 DC5-EXCH02.marvell.com (10.69.176.39) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 27 Jan 2021 10:41:33 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ko8+5FnW1dyUzJBBJfi0CApJ8xAaOwKuFhkH19n48kQqekn9jfAThI5zct40gTWR1i2ROzk4NE++5+l3SiH5wcgfVCgUOIcz6/hC5Y2M1sO+RpdMGwXl0MbaWZ3EAwyq9qggoQvx2V4AUC4FvXw/jFZis/sXpFSrzx3FInUEYwKUuptHBDCl3+oajv5cFMjqLhg0pehIjXbb/gbpHoYD6lhugef9b7qHtT+6+SpoHTH5JCavN2Zzy16sEZBrkqWxHUm+vpqkjxws3TW7RkJCE/aBsebxIUyxMWi3TgTX6lAGiQdhxNTFi8XdQ5a180cM51WHLOr7zxcMp6gKuQvMig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1eV2FvHGB4u1s88A+EFQX1DzSSeC/haJ572f4eNCm8=;
 b=FtXoDrNgEoxAJW9QsBhFoIAjmRC/RU6bBkHe0MGRaTz+4Zb3BtTtuuQW18XNTOw6V86oB308eBWRLdMOKhk6aQHJkV0sEL1D2350O0txLjk46gCbVP7x3zETnQDpjazfavAsn4FcmW03gHMuicLWhrXARrPa/Cbii+XHH4p0oRthFnBN+u6UEjDEXjLLrUtKRFjKelvOb0dfwW0dOwweygl/hPDaY5ZwfrFKr+ioQlIJfXSbfYOXgT+BW1BhPeJ5wwDOZ5FtX/7FoYHz47usluA5GAscVzoNX5VVwM6w4yT2DRgKWd6mxXHiffFfEBjZw7Kb3qWV9wwGlI8Xr7CRGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F1eV2FvHGB4u1s88A+EFQX1DzSSeC/haJ572f4eNCm8=;
 b=i0FP9SPQcZRdl2/o8L6DNwBse76vmvgRqx6EjVl4w/qiCE+8TPqMFV7xS7fjIUAPSQSyYH0GAC1m9Ujz+e9KXFfKCAgCb6t0aXtUrZXJyXch6Ng78/SC1UAJF4Ws6QKE5mELLf4KFLR2zWsjp4Amb2uXxXdmUKGGKrReZmTk0IY=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by MW2PR18MB2313.namprd18.prod.outlook.com (2603:10b6:907:8::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Wed, 27 Jan
 2021 18:41:32 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::c041:1c61:e57:349a%3]) with mapi id 15.20.3805.017; Wed, 27 Jan 2021
 18:41:32 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
CC:     Network Development <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Miller <davem@davemloft.net>,
        "Nadav Haklai" <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "mw@semihalf.com" <mw@semihalf.com>, Andrew Lunn <andrew@lunn.ch>,
        "rmk+kernel@armlinux.org.uk" <rmk+kernel@armlinux.org.uk>,
        Antoine Tenart <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH v4 net-next 10/19] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Thread-Topic: [EXT] Re: [PATCH v4 net-next 10/19] net: mvpp2: add FCA RXQ non
 occupied descriptor threshold
Thread-Index: AQHW9KHKRTr9gNuU/E+NGMKVxzHzZ6o7vLQAgAAPqcA=
Date:   Wed, 27 Jan 2021 18:41:32 +0000
Message-ID: <CO6PR18MB3873573FA21D4B82A32948B3B0BB9@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1611747815-1934-1-git-send-email-stefanc@marvell.com>
 <1611747815-1934-11-git-send-email-stefanc@marvell.com>
 <CAF=yD-Lohx+1DRijK5=qgTj0uctBkS-Loh20zrMF7_Ditb2+pQ@mail.gmail.com>
In-Reply-To: <CAF=yD-Lohx+1DRijK5=qgTj0uctBkS-Loh20zrMF7_Ditb2+pQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.11.87]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d26294b7-2a38-4fa7-f80c-08d8c2f32acf
x-ms-traffictypediagnostic: MW2PR18MB2313:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW2PR18MB2313F354F6EDBE7EEE2A53E3B0BB9@MW2PR18MB2313.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hF//4l9fHTvVT56N2WTnH4fdMLvPlflOGVHDYpbpo5PDyXWjCkL4WSQTCtho6wsA4D/z3tpdA5OzsFBhEutlmzJ21jVK/8/6hk01teYdJIxpMBDXyqgJEyQxr7joBrCIdC4TDahpi5sAdmuuWZFrg3si9NVzsuqkAztolzO9CAQUufcjgRBU09qyE5bmfr31+u5iCTpBqY45gaLlcXpMdVzbMPsmhGsVuZcG/oGmmaqeb/xCsjwY3GJ3y3ooIUUtBWAsvnqhiZyOvKhkpvxo0O03Wlk7mSXcqw7/k1AndyMnZnvHjpn98x8+KuJWgmCObLSMPU864Cc+qQzXdbE/t/Yu/uesrLA6HPMFXTiSbSqIP4K5wt5DJEzV9qNhfJIVzv5Jy/Zccvymba/jpUS2fkDQQ66u0y4yC9z1CQwmuS2RqH+D23MM0TKa/cBMeW1UGakDEjtBN30BtwMfj+ZDRRULdFMSr9E8ozuNXtC0R6ndPxGXQekq46gyYnqpHkF3maYracSaG0aIQL8E7BjT0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(39860400002)(346002)(136003)(5660300002)(6916009)(33656002)(52536014)(8936002)(7416002)(8676002)(7696005)(54906003)(83380400001)(26005)(6506007)(316002)(66446008)(71200400001)(186003)(4326008)(76116006)(9686003)(55016002)(64756008)(66556008)(2906002)(66476007)(66946007)(478600001)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VWV5Qm5oVGoyY0NIUmZaa3NZTWg2cjIvcTYreDBQQTJ4SVVjbFRNYnRnQjdj?=
 =?utf-8?B?ZTRZT3IxdTAxWEMwT1VEc1RlNk1UTkt5RUNwWHUyS24yOHN1WTZuZ0tlL1Bj?=
 =?utf-8?B?UEM0dytmUElQbHBaQzhJL1EwNEFpdFNQTTdEK0JiVm41bDhMWE42UGU4ZWRr?=
 =?utf-8?B?bFNFSjJnc0NtTEVTaGpyMTMrcjhhRlVMUmJ3QXhDMXkxNVNucWRLc0s2dWx3?=
 =?utf-8?B?ZytFWWZyci92cnB3K29zaHQreHM3YzRlZTIva0dsS0g5dmgrVXFiTG1TV2Rs?=
 =?utf-8?B?Vkg5MTdrMGtIYVIwYXQveXBRenFKZFFtSy83eUw1RnFiWHAzSlBlOVhKaG5l?=
 =?utf-8?B?d3VPbUtZMGVwY0l1S0twS1BuK3F4WHFZbVVIOFNrS0FhTC9OeEJhN09zMWIw?=
 =?utf-8?B?eC9HeGt1YnlPQ1R1TDh4RG9rbDhxZWJWcVM4d3YrZmY5REVQWS9mNld5dFZI?=
 =?utf-8?B?TWJDYlc4M09zbDZuN0J1M3FwejlxSDVHLy9xOUFsWllVKzNxNHcycXpnaTMz?=
 =?utf-8?B?eG1mZkN3WmR2a2I0L0RVUCtHaDBDMWpsV25tV3hhM0ZLcHBNd1NFeURud053?=
 =?utf-8?B?UVBTa1FLQXRCTXRXV0hGeFZ5a1R1YXhXYlpKbG91M1NzVlRFclRaSGZwSzFU?=
 =?utf-8?B?QmFIcUNDSEdNTnJxcW1KV2NjQ0VIQUM5YWVOcmpCeUdVSkJ4K3hEZ01tUUh3?=
 =?utf-8?B?ellkWGxBb0FqdUhFR1lNZG5ORHlpMGFzdXh1Qk5ZQkQxeEZEUzUwTGM3V1RZ?=
 =?utf-8?B?WTJLZ1BpVE40MWZMT3FsUXNIblZXU3Nad1NUM25oc2dKTnF1YlB0R1F6Tk9F?=
 =?utf-8?B?YjEreEJxVG84dnFrVzd1RzRsWFRLaVArWlNubHRWSjJDMHlxMjhqdnNsS1VN?=
 =?utf-8?B?akNhL1ovN0p2dXB4bmxWTUVDVEdwNEN1Z3ZWY01ONkowL1dqejJNM2Z3cmxB?=
 =?utf-8?B?eUFUNmRLcHpSMlZKZHBDc0JLMmE2QUFpT0Rxa2h3dXVVSXVOdVFLNFZDTmVS?=
 =?utf-8?B?czB1czVpeDdBWmNoL0t6dnZaUGJqRkJvSlNxZ1M4bUFtdExGaHNhK1ZPZE50?=
 =?utf-8?B?dzcwazEvMFplcXgzcXE4Zkt2akZzQ3M1bnhaZC9VNEdNaEx2akhQU1hJdjFp?=
 =?utf-8?B?QS84WFlycDhSdk1OZEErU2N6Q1FSelNJUGxOM0FXNHRYYzVpdit2dmkzVDEw?=
 =?utf-8?B?VEpZemh6YUplU1pXZ2MyemU1M0pablhVeTZVMnNoNU5RUGRIbmNYZ1J6eVVZ?=
 =?utf-8?B?T3lUMDA4b3NYbnM1RUJKUER5YStLaXd3NXYwOTlMc2hKeGcxcGF1SU1kSks1?=
 =?utf-8?B?TlNCM0Q5cmVFdUlvSysvRnRrVkl0cTFTbkZ0eUxraHlSaWNhQW5KSSsvRzBy?=
 =?utf-8?B?MjByZlJXdGt5SEViVk4rOXRLS3JMUUVBZ2MrMEduRGUwWmQwQmRVY0hrQ1Vs?=
 =?utf-8?Q?v/5TQ7na?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d26294b7-2a38-4fa7-f80c-08d8c2f32acf
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jan 2021 18:41:32.3113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Yy3MOuC9/2dZDdCWZO5nQ8Nw6YEJi4XZ9KKSEGd1PICQ72Gq9rD2fwjS3ZtRtWMxCQFrSnoGAcEXzDsqvzEgvg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW2PR18MB2313
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-27_06:2021-01-27,2021-01-27 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQogPg0KPiA+IEZyb206IFN0ZWZhbiBDaHVsc2tpIDxzdGVmYW5jQG1hcnZlbGwuY29tPg0KPiA+
DQo+ID4gUlhRIG5vbiBvY2N1cGllZCBkZXNjcmlwdG9yIHRocmVzaG9sZCB3b3VsZCBiZSB1c2Vk
IGJ5IEZsb3cgQ29udHJvbA0KPiA+IEZpcm13YXJlIGZlYXR1cmUgdG8gbW92ZSB0byB0aGUgWE9G
RiBtb2RlLg0KPiA+IFJYUSBub24gb2NjdXBpZWQgdGhyZXNob2xkIHdvdWxkIGNoYW5nZSBpbnRl
cnJ1cHQgY2F1c2UgdGhhdCBwb2xsZWQgYnkNCj4gPiBDTTMgRmlybXdhcmUuDQo+ID4gQWN0dWFs
IG5vbiBvY2N1cGllZCBpbnRlcnJ1cHQgbWFza2VkIGFuZCB3b24ndCB0cmlnZ2VyIGludGVycnVw
dC4NCj4gDQo+IERvZXMgdGhpcyBtZWFuIHRoYXQgdGhpcyBjaGFuZ2UgZW5hYmxlcyBhIGZlYXR1
cmUsIGJ1dCBpdCBpcyB1bnVzZWQgZHVlIHRvIGENCj4gbWFza2VkIGludGVycnVwdD8NCg0KRmly
bXdhcmUgcG9sbCBSWFEgbm9uIG9jY3VwaWVkIGNhdXNlIHJlZ2lzdGVyIHRvIGluZGljYXRlIGlm
IG51bWJlciBvZiByZWdpc3RlcnMgYmVsbG93IHRocmVzaG9sZC4NCldlIGRvIG5vdCB0cmlnZ2Vy
IGFueSBpbnRlcnJ1cHQsIGp1c3QgcG9sbCB0aGlzIGJpdCBpbiBDTTMuIFNvIHRoaXMgY2F1c2Ug
YWx3YXlzIG1hc2tlZC4NCg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogU3RlZmFuIENodWxza2kg
PHN0ZWZhbmNAbWFydmVsbC5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L2V0aGVybmV0
L21hcnZlbGwvbXZwcDIvbXZwcDIuaCAgICAgIHwgIDMgKysNCj4gPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMl9tYWluLmMgfCA0Ng0KPiA+ICsrKysrKysrKysrKysr
KysrLS0tDQo+ID4gIDIgZmlsZXMgY2hhbmdlZCwgNDIgaW5zZXJ0aW9ucygrKSwgNyBkZWxldGlv
bnMoLSkNCj4gPg0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9tYXJ2ZWxs
L212cHAyL212cHAyLmgNCj4gPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZlbGwvbXZwcDIv
bXZwcDIuaA0KPiA+IGluZGV4IDczZjA4N2MuLjlkODk5M2YgMTAwNjQ0DQo+ID4gLS0tIGEvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMi5oDQo+ID4gKysrIGIvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWFydmVsbC9tdnBwMi9tdnBwMi5oDQo+ID4gQEAgLTI5NSw2ICsyOTUs
OCBAQA0KPiA+ICAjZGVmaW5lICAgICBNVlBQMl9QT05fQ0FVU0VfVFhQX09DQ1VQX0RFU0NfQUxM
X01BU0sNCj4gMHgzZmMwMDAwMA0KPiA+ICAjZGVmaW5lICAgICBNVlBQMl9QT05fQ0FVU0VfTUlT
Q19TVU1fTUFTSyAgICAgICAgICAgICAgQklUKDMxKQ0KPiA+ICAjZGVmaW5lIE1WUFAyX0lTUl9N
SVNDX0NBVVNFX1JFRyAgICAgICAgICAgICAgIDB4NTViMA0KPiA+ICsjZGVmaW5lIE1WUFAyX0lT
Ul9SWF9FUlJfQ0FVU0VfUkVHKHBvcnQpICAgICAgICgweDU1MjAgKyA0ICogKHBvcnQpKQ0KPiA+
ICsjZGVmaW5lICAgICAgICAgICAgTVZQUDJfSVNSX1JYX0VSUl9DQVVTRV9OT05PQ0NfTUFTSyAg
MHgwMGZmDQo+IA0KPiBUaGUgaW5kZW50YXRpb24gaW4gdGhpcyBmaWxlIGlzIGluY29uc2lzdGVu
dC4gSGVyZSBldmVuIGJldHdlZW4gdGhlIHR3byBuZXdseQ0KPiBpbnRyb2R1Y2VkIGxpbmVzLg0K
DQpPaywgSSB3b3VsZCBmaXggdGhpcy4NCg0KPiA+ICAgICAgICAgLyogSWYgdGhlIHRocmVhZCBp
c24ndCB1c2VkLCBkb24ndCBkbyBhbnl0aGluZyAqLw0KPiA+IC0gICAgICAgaWYgKHNtcF9wcm9j
ZXNzb3JfaWQoKSA+IHBvcnQtPnByaXYtPm50aHJlYWRzKQ0KPiA+ICsgICAgICAgaWYgKGNwdSA+
PSBwb3J0LT5wcml2LT5udGhyZWFkcykNCj4gPiAgICAgICAgICAgICAgICAgcmV0dXJuOw0KPiAN
Cj4gSGVyZSBhbmQgYmVsb3csIHRoZSBjaGFuZ2UgZnJvbSBncmVhdGVyIHRoYW4gdG8gZ3JlYXRl
ciB0aGFuIGlzIHJlYWxseSBhDQo+IChzdGFuZGFsb25lKSBmaXg/DQoNCk9rLCBJIHdvdWxkIG1v
dmUgdGhpcyB0byBzZXBhcmF0ZSBwYXRjaC4NCg0KPiA+ICsvKiBSb3V0aW5lIHNldCB0aGUgbnVt
YmVyIG9mIG5vbi1vY2N1cGllZCBkZXNjcmlwdG9ycyB0aHJlc2hvbGQgdGhhdA0KPiA+ICtjaGFu
Z2UNCj4gPiArICogaW50ZXJydXB0IGVycm9yIGNhdXNlIHBvbGxlZCBieSBGVyBGbG93IENvbnRy
b2wgICovDQo+IA0KPiBuaXQ6IG5vIG5lZWQgZm9yICJSb3V0aW5lIi4gQWxzbywgZG9lcyAiY2hh
bmdlIC4uIGNhdXNlIiBtZWFuICJ0aGF0IHRyaWdnZXJzDQo+IGFuIGludGVycnVwdCI/DQoNCk9r
Lg0KDQpUaGFua3MsDQpTdGVmYW4uDQo=
