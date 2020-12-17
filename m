Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15E02DD053
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 12:29:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgLQL1V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 06:27:21 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:60264 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726354AbgLQL1U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 06:27:20 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHBLCk6020616;
        Thu, 17 Dec 2020 03:26:21 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=e6ye3Nu002YNSf5fJPBXX0wiF+lBNyuuDWXqeCBmcQc=;
 b=fUYD2nWBVFs2Yu822RYe3H3noFKPSM2/eGn4qXHyfQUE8L1THhqkes5yfme+zKhCP05T
 Pmo0e41ktckNH3Ppofo+yVW7Nj+laC/eByZrg+tvUlTlZEV5TslrvNRmhGaCu3sRdosg
 0n01pYeKB+obARhaOlGxG0LR1ZLJX5gzFggCRI/fe0jvLjhCBDIySZRXK+gbcM7EE3lQ
 2VmA97fkKVZfu+pE6zuxT5ziIp8WrFF4+mdLco+yHO9E1MZKnnaWYWBq7HS4kSadXjJ1
 AetYVaKqZem72N8qyzX68GW0Jj1N8j9J6ohIz5+q+MsHzrRtCrQpYqzSrEOBmImVCWib kg== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tfcht-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 03:26:21 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 03:26:19 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.173)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 17 Dec 2020 03:26:19 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CoHVj9fnddjWCQ/6LwRNXdapDX0kveYH4xT6mzLkwZnJgg8YP6fHYBQyM9NeerTrcL4/ff9n2YdfjIoxhj2GA39I7Ek07yycd8f7jXM37AY6pZdW+SdrKA/YxW5vOGF94LaXL4J4e7vkrdQnplQzDdPtyrAdeooBZce2uMwPWNImsA/R/BWYwBDHRilLbp2tg8FliU7ae4uuOP/ctHbK5ZOiIhC+FO03jevWEA49AkGmqMjECDaakymw/PjAWfk6r6YqCUMcm+T8P2iXUMISLK8RwBKT6c2yu6ioM+jdf5JE9+D0PnhuFtyKJwAtyd1HdQmgAB1CEyt3l0mq9HHDLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6ye3Nu002YNSf5fJPBXX0wiF+lBNyuuDWXqeCBmcQc=;
 b=GTfIoxINzpSsdvOgYWiWnR+HihcZYACNGLSKYfLkBffwNgy1I3GSP3qOHG84YDxrGHeQr3JGBWo1Nq9PR+Uv5oldKDDBnOVLZOV1eOeIphIQmnwM221kmU0tvG+U3oIz7reLy1a2azfphW4tIcEa0J9AEIxcRogAtAe30qjQE+CVKvV1BANavfuRJIBmqb2n/ilXAk4cKHSFLymYI8/V5H8L+yerd2SrzfOYPbv8bKVEHs/moTSKoMzTxNwxnACCSZxSW0XuaVMVQ6j3aS4iLDi7QPwS6HDRrdmDYympcRxfTbltZLQSuctOGwjlCyLLOIBqBPq7dUnRLXvTzdNMlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e6ye3Nu002YNSf5fJPBXX0wiF+lBNyuuDWXqeCBmcQc=;
 b=ZesocxgmCDEAodw16LfETrd22xp9W07Gmz7rWHKAx5SpD2Dkg+lgS4dgizyXgUCPjVOixYBLML+h2kV/Y4KSbWeEnnnwZa//xNxxKBGbqvQl9DgHfnie3kIMp821Bby3Dcr0HxX9mMSi0VPjq8RlSBe2Znqv2IadsbALPf71Gew=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3825.namprd18.prod.outlook.com (2603:10b6:5:352::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 17 Dec
 2020 11:26:18 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3676.025; Thu, 17 Dec 2020
 11:26:18 +0000
From:   Stefan Chulski <stefanc@marvell.com>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Marcin Wojtas <mw@semihalf.com>
CC:     netdev <netdev@vger.kernel.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Nadav Haklai <nadavh@marvell.com>,
        Yan Markman <ymarkman@marvell.com>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>
Subject: RE: [EXT] Re: [PATCH net v2 2/2] net: mvpp2: disable force link UP
 during port init procedure
Thread-Topic: [EXT] Re: [PATCH net v2 2/2] net: mvpp2: disable force link UP
 during port init procedure
Thread-Index: AQHW1FipsOUqv9u470iCoznSxc8YFqn7Hw+AgAAF74CAAACb4A==
Date:   Thu, 17 Dec 2020 11:26:17 +0000
Message-ID: <CO6PR18MB387388CE0DD757CFCB605AFEB0C40@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1608198007-10143-1-git-send-email-stefanc@marvell.com>
 <1608198007-10143-2-git-send-email-stefanc@marvell.com>
 <CAPv3WKcwT9F3w=Ua-ktE=eorp0a-HPvoF2U-CwsHVtFw6GKOzQ@mail.gmail.com>
 <20201217112203.GY1551@shell.armlinux.org.uk>
In-Reply-To: <20201217112203.GY1551@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: armlinux.org.uk; dkim=none (message not signed)
 header.d=none;armlinux.org.uk; dmarc=none action=none
 header.from=marvell.com;
x-originating-ip: [80.230.78.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7f281a5-47a5-44a5-b152-08d8a27e928a
x-ms-traffictypediagnostic: CO6PR18MB3825:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB382515BB28545F59C79CBE27B0C40@CO6PR18MB3825.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xSL4r5yV6VHCQYq34NF+6/l4OO5xUXmiC27511HPAUsv4aTHrgsDfRLjqx2a71OvhvGpxp+ulujPXy0hmYtsFG5lr8RSJgFoGyBonZAXFx4CbjzgMe8E7harOMmptpeEiTOM3eNJEdQcAbewRQEDC6iwkbD9hJyUTaKrEDcBHgUnwIgiNiI/6LCZqnGulclHfXmFC9ifGOazpAzHUL4/ESan3/vC0Fd3E12Y6p7DJLq/szR4gan6Io8cxCRb/cu0LDijAZlIxb0KswcLXLdsFynbhN6Hg1EitmRR0Q4qRT0ronwesgIQNb56Vnv4vk4xgIW/nO0UidZAi7m/Y2xyXw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(39860400002)(346002)(136003)(376002)(71200400001)(33656002)(4326008)(4744005)(64756008)(5660300002)(478600001)(2906002)(86362001)(66556008)(26005)(66946007)(66446008)(76116006)(55016002)(66476007)(7696005)(83380400001)(8936002)(316002)(186003)(9686003)(54906003)(6506007)(8676002)(52536014)(110136005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?ampQMWxDRVdNdysxaWtmWFREY0hneFZYSXc0NEp6dFFIaW1DYmMycVdaejEv?=
 =?utf-8?B?aGlJeXlrQ3FGNUQzb1ptbGcvdzJqbXNZN1NIS0IwTHVYWElHMjVJVDNmRHV4?=
 =?utf-8?B?UDhtK0xTemtiTThhVGRPVkdLMEdrb29lQ2E0dXBobEpQeUxmaE9INkZycnhE?=
 =?utf-8?B?S3I1NUlrWmVEZUFwbWE3UzdWMDZGUVBUckw1eVFFOFpVRTNBRitYTGphL2hZ?=
 =?utf-8?B?QWRJbFpWSlpIRnZuUitMcHFGeGErWHRqV1I5dElSZnBOc3FWcEVYOHlZTEdO?=
 =?utf-8?B?NFFKMTNpMXRLaGVNcklod1FuRVhpV3NxWVRpMjNEUWhkdG1FdSs5MmdxWWlI?=
 =?utf-8?B?Zkxsd3pqRUFhQmw1YkJWZ3VxL3BGb2ZFR1pwcGhjd1NHdkVJR3pkZndkVFBr?=
 =?utf-8?B?cGVRTlZaeENrS0lnV0pDazU1ajlKOEFJUVIvbkRSU0ZLekNDYXYxS2JON09H?=
 =?utf-8?B?Q2RhVGordlkrdkZnSjY5bTY5Vm1aRTR4ZytkcVlETVNjSlorZnV6MVFZbzF1?=
 =?utf-8?B?UEJPclB2d3hLQ0JXKy8wNTIxcFNrYThwVndNS1c0REd3VEF0NlJkeFYyaExY?=
 =?utf-8?B?WVlVbm5WYUVOL2V2THN4Y1FlMkFXK2paRTBQaSt4ODVkVkpteVlXNVEwTzU0?=
 =?utf-8?B?Mk9pR1Q2K3Z2NzZjMTZoVE8rMDd4V0tQZHNRRE9tanlsRkc4UjREblNVVUoy?=
 =?utf-8?B?UERSVGlmRVNMMzhhTEtTZHNnSDh4c0lvNG5ZczVrTGE2dnNnUWtBQVQxRW4r?=
 =?utf-8?B?TEM3akRTRU54OUsrMFdxblc4WWc1c1kzUnlQYmNRaUx0Q0RJZzREa1Q2TmNU?=
 =?utf-8?B?V1ZRZG1UeXBhQXVpcEZHRFo3SmJEWW42SUE1cFVJK3doQ2JDdEV1dC9VbEhl?=
 =?utf-8?B?R3FWaDFpTk92L25oVVZUbjc2U1pxV1NtRDk4ZkR2RzNvRGpXWTM3ZmU1UThD?=
 =?utf-8?B?QlV5bEFxZURUVkdwOVNnemdWNXdWNTREYzl4VzQvckRwcllkWHdTR1J3SVZt?=
 =?utf-8?B?ZmFObXg3eW9yTHJkeEVUeDVRM3BzdWZIZFNtNFo1UjVUckpJb0FrUzIvVHlz?=
 =?utf-8?B?clc4OTgzQk5SWFJLTERaQ1BhT2xkUEhwa21yYnp2a0p3Q3pwaFk5ME5SR0lr?=
 =?utf-8?B?eUhqcExXQXZqSEdvVnh6MGZvenh0TSs5MU5XbTRXZmRVSkh1d216QWY4MTJZ?=
 =?utf-8?B?YTAvRWxzTzdpZ1RMK1FEKytSKytjcFNXMzRPS1Zvc2NRemhpNTJERTJoVlVW?=
 =?utf-8?B?NzJ3cnZob1F4MG56M1ZaWDJzN2QvOXZwUXlaRmV5clVYTWlUV2lEUVZ3QnJ6?=
 =?utf-8?Q?1lPsaSxPP3y5Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7f281a5-47a5-44a5-b152-08d8a27e928a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 11:26:17.9981
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: looXiCv3GK16qPA4cMYp8PUOzA14yOfdZioZB8qU3Y5Hx24S1tVhfTu27RuK46cdWkjBxZex9QrhfvWchl/F1w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3825
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_07:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBPbiBUaHUsIERlYyAxNywgMjAyMCBhdCAxMjowMDo0OVBNICswMTAwLCBNYXJjaW4gV29qdGFz
IHdyb3RlOg0KPiA+IEhpIFN0ZWZhbiwNCj4gPg0KPiA+IGN6dy4sIDE3IGdydSAyMDIwIG8gMTA6
NDIgPHN0ZWZhbmNAbWFydmVsbC5jb20+IG5hcGlzYcWCKGEpOg0KPiA+ID4NCj4gPiA+IEZyb206
IFN0ZWZhbiBDaHVsc2tpIDxzdGVmYW5jQG1hcnZlbGwuY29tPg0KPiA+ID4NCj4gPiA+IEZvcmNl
IGxpbmsgVVAgY2FuIGJlIGVuYWJsZWQgYnkgYm9vdGxvYWRlciBkdXJpbmcgdGZ0cGJvb3QgYW5k
DQo+ID4gPiBicmVha3MgTkZTIHN1cHBvcnQuDQo+ID4gPiBGb3JjZSBsaW5rIFVQIGRpc2FibGVk
IGR1cmluZyBwb3J0IGluaXQgcHJvY2VkdXJlLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6
IFN0ZWZhbiBDaHVsc2tpIDxzdGVmYW5jQG1hcnZlbGwuY29tPg0KPiA+ID4gLS0tDQo+ID4NCj4g
PiBXaGF0IGFyZSB0aGUgdXBkYXRlcyBhZ2FpbnN0IHYxPyBQbGVhc2Ugbm90ZSB0aGVtIGluIHRo
aXMgcGxhY2UgZm9yDQo+ID4gaW5kaXZpZHVhbCBwYXRjaGVzIGFuZCBsaXN0IGFsbCBpbiB0aGUg
Y292ZXIgbGV0dGVyIChpbiBjYXNlIHNlbmRpbmcgYQ0KPiA+IGdyb3VwIG9mIHBhdGNoZXMpLg0K
PiANCj4gSXQgc2VlbXMgdGhlIG9ubHkgcmVhc29uIHRoaXMgaGFzIGJlZW4gcmVzZW50IGlzIGJl
Y2F1c2UgaXQncw0KPiAoaW5jb3JyZWN0bHkpIHBhcnQgb2YgYSBzZXJpZXMgdGhhdCBpbnZvbHZl
ZCBhIGNoYW5nZSB0byBwYXRjaCAxIChhZGRpbmcgdGhlDQo+IEZpeGVzOiB0YWcpLg0KPiANCj4g
QXMgdGhpcyBpcyBhIHN0YW5kLWFsb25lIGZpeCwgaXQgc2hvdWxkbid0IGJlIHBhcnQgb2YgYSBz
ZXJpZXMgdW5sZXNzIHRoZXJlIHJlYWxseSBpcw0KPiBzb21lIGtpbmQgb2YgZGVwZW5kZW5jeSB3
aXRoIHRoZSBvdGhlciBwYXRjaChlcykgb2YgdGhhdCBzZXJpZXMuDQoNCkkgd291bGQgcmVwb3N0
IHRoaXMgdHdvIHBhdGNoZXMgc2VwYXJhdGVseS4NCg0KUmVnYXJkcywNClN0ZWZhbi4NCg==
