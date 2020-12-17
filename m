Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D1A2DD7B9
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 19:15:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731651AbgLQSLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 13:11:49 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:44340 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1731629AbgLQSLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 13:11:41 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BHI5rZD028243;
        Thu, 17 Dec 2020 10:08:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=pfpt0220;
 bh=SUpCpGYyTvw/DqOgfizess5V/89d1Im5LOQa5lgu73c=;
 b=ABT7aJ6wqc/TC31gEnMpyJ4SeZRDQ4cSRhLll7/MpfevbWo/6Wl9QFS+BeCa2UADxz3e
 n96BnUzPjzeBJvZsOAEIsnR1ICTZ9SfD6iIZsKaCVuv8VcxM6+nruFAGmqDoELakVw4Q
 +W1LbJTjKIIDAmw97KcI9eR+APJFr0L0kQ6pNWm7a7sJtGmKZxmz/ncwrCPuUDd6qX1X
 /u5m5PordfWOCnxBPxfhkrdzWvZLijskpK+MFFUCbtd5Xs7+DPEtRZOzfrMq+CyQ44Ah
 ZoUZ2CAAIsIIjgfXgB+evQWum32NyJ6zxPZXy7dKgEl9yWcbtddRGPdVx4zG7QMbrmCZ AQ== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 35g4rp1fqq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 17 Dec 2020 10:08:49 -0800
Received: from SC-EXCH01.marvell.com (10.93.176.81) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 17 Dec
 2020 10:08:48 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by SC-EXCH01.marvell.com (10.93.176.81) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Thu, 17 Dec 2020 10:08:48 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XOhLHDisuYnswLrmBGqd5vZcNIJ2sitL7+nZ1g18MV0gljwjToMfDW6+qjGt/3Xs4lg6xnNoqBNexVuD5G6bKkSttExZu0xVN8WXy7dUyGMgBqi3K0+7hS6cGqwx/x76VJ0rrcInFejcqW4nI2giW8fYy2Vk7jCRv4RW4cuP81bSEywf+AO/Ux5/Y5MXYArHO29f2sY5BlgzRbx2xgvyuwzLKWYo595vNNh5RwJeVTaBOl7oeZEwWbxYreDcF8H8EYKUZPI0Jv8LaRWF7HDWPEx+xxb9EPfpiv3/BjWE7I5i9cazkI/vvNp7h/OCYQ4Sk2kSImryo5yon4zaDpKNZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUpCpGYyTvw/DqOgfizess5V/89d1Im5LOQa5lgu73c=;
 b=IEpMkhXrnKGREGm+l9N7BVnl0AIIMMpWvNb+OKkl0udcWPyQO4RjXQMmcTlMMt3KB/M1HEX33cWQzF31hPi/eqee3u4Y3TvF/xSvd4FXBc98W3F/Qzy7Ja9Om+6ujpIzt6aAGO4x8TaNU+8gtgVmPMngObekvd7N1mSVvLToiIbPTTRsmtKH+HXIwnrOIGyBZjTJjlPl6mj4KUagwb4+Zfd/cazyiz2En+wqCDHm4b6dQGyBQ6B6BsMy7/WCEZYKb8WpW6BzcpLVYKofnv9bbME7rfvJUW4I7XrUFQ1/4Jd5Y58pnwVo9YUWVPdWepFJ0W2+QFevPD6LdQtnuqxedw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SUpCpGYyTvw/DqOgfizess5V/89d1Im5LOQa5lgu73c=;
 b=OzhepYskIx9HjpbRWtrcQllfGsLQZiuYlEHIlLJdY1ojO5aI0lVRwemIg/03CYs7FAvTLs589i3NeVNJMWnSF7gUXZTLOlba40ct52nILj8YokJQ09dOo26I7lX+R1TmhTcuxldUtd2KPobfZ3iF+cvGGDjjF+vitQe4PwNtL7w=
Received: from CO6PR18MB3873.namprd18.prod.outlook.com (2603:10b6:5:350::23)
 by CO6PR18MB3907.namprd18.prod.outlook.com (2603:10b6:5:345::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3676.25; Thu, 17 Dec
 2020 18:08:44 +0000
Received: from CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b]) by CO6PR18MB3873.namprd18.prod.outlook.com
 ([fe80::ed55:e9b3:f86c:3e5b%7]) with mapi id 15.20.3676.025; Thu, 17 Dec 2020
 18:08:44 +0000
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
        "atenart@kernel.org" <atenart@kernel.org>
Subject: RE: [EXT] Re: [PATCH net] net: mvpp2: Add TCAM entry to drop flow
 control pause frames
Thread-Topic: [EXT] Re: [PATCH net] net: mvpp2: Add TCAM entry to drop flow
 control pause frames
Thread-Index: AQHW1JxlwXLEIxkdcU++NNXfEca0sKn7lBiAgAABHNA=
Date:   Thu, 17 Dec 2020 18:08:44 +0000
Message-ID: <CO6PR18MB3873C8C0343C16552BB65699B0C40@CO6PR18MB3873.namprd18.prod.outlook.com>
References: <1608227106-21394-1-git-send-email-stefanc@marvell.com>
 <160822809533.1452357.10722693725960219998@kwain.local>
In-Reply-To: <160822809533.1452357.10722693725960219998@kwain.local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [80.230.78.138]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 609d7690-6280-4244-88d4-08d8a2b6cada
x-ms-traffictypediagnostic: CO6PR18MB3907:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO6PR18MB3907006A4BE81535ABAC5953B0C40@CO6PR18MB3907.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9lWtT1VqZgMvMxNjewbk6a3SHRCElHCQMXbSyoPYY5Xj7UaU81pnapVS3MGALXkbPIWaLD6c8FbJSPPnwWFbsKhZZdG6WgnAkAwNQ8ic2jpLCSihb406wv7DUvCEU77PhDUfN49ZyeI7JhN5LB6Az6hEKsNzYfu2N0eykH0uRKE7LUWbtInFUITupHslmHG999J9WsT0C4GiPYeqt52abtjAVE+3+kvlnRTsggeXCeZfqvQSWfa9av0lOr0AInGdN9OXN39Eif0SFxMSxiirDyCMJc+x4riBRXZ4tzXXNXg/739Xz8xkg/YpelrSnsAj1fkxOiTIKtXji5+V2DNrosc0QSOYz9hIckRzbXQ7JDroQd6dvTdgev2zrW0TFWHpXRD6L4oBel3KWA2dEtWkKw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR18MB3873.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(346002)(366004)(376002)(39860400002)(136003)(66476007)(66556008)(8936002)(66446008)(54906003)(71200400001)(64756008)(8676002)(110136005)(186003)(7696005)(316002)(76116006)(52536014)(26005)(2906002)(7416002)(478600001)(4326008)(33656002)(86362001)(55016002)(5660300002)(9686003)(66946007)(6506007)(4001150100001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?VWxPYzlOZDEyN2dTUlVubXdVVk1lL1VlazR3NlF6SFJPbVFLQnZ4Z1dlQldL?=
 =?utf-8?B?RERGUzBBSWxQbjBVKzV1OUsvZHRUYklteldhczAwMmsySXM2dUEweEQ5Qk5q?=
 =?utf-8?B?TWdrSGxJbGZabXVVZkRjREdRdlNFYW8vRFo0RmxBaDJwTHJIRm1maytGU3dm?=
 =?utf-8?B?bG9pbXdpWWxQbXR1Nm9ZMXlmeTRtaldaZGVZZk5KTE1HT3JMY2RpQTFkVkdR?=
 =?utf-8?B?UkdCU1ljNFVnR0ZzNDJZSTZuak9xL2kzb001eGRSQ2kzaUR0Kzgrc2tsUWs2?=
 =?utf-8?B?UVpMdzN2TVI4anU5cW9iMVIyYzQvYm5HRS9PWUtrM1QxVEJ3dENBMDlHSXk4?=
 =?utf-8?B?aWM2N25vUzYrcTZxYjVRLy9oRnMxMXhPZGtpSktqZy9qQm00UElpNDk4REpn?=
 =?utf-8?B?YS9YOHBobW9iU1BYWEEwMStGUi9FYlRPVDQxc0Z5b0p1aGpENUgrcmthMHV1?=
 =?utf-8?B?UGl3dW1FQVE4RFZyTkxaUWJpVHJkT1F0U2VYL2tyOVM0QXNaV29Ha1ZiZG1j?=
 =?utf-8?B?N0t0NTg4S1JDbVNXN01UakQ2MFZmQkVOL2RhMjU1clcvL1RMUXBPVzRSUGRY?=
 =?utf-8?B?U3ZaU0duVWFOckRLQXNxaGFETEYwTmtuTWJpQThFWSt2VmZSYjlScmJzYytR?=
 =?utf-8?B?WUJpVmk3N0xaZnBFZTZ3TTFuMis3OHA2N0xkczkyWnA4YjZJYUFvVDRHL3gy?=
 =?utf-8?B?ektaZVhBR2ZLc3RWV3VrSWZjMFhTb3J3aDdlWndtYkQwQkpOMW9TWE1mVm54?=
 =?utf-8?B?SUg4QjhVa3J1T0Q0NnlSWWloY0ZkU29CakhjOXMySXFlV1RSTTQ2clRyUDhw?=
 =?utf-8?B?a3ArOW9MSlRTeWJKMGxjanRiQlNrM3hyaTdjazZ5OUZ6TVpIUFRubHB0ZVdo?=
 =?utf-8?B?QkNqUHJZR2Z4STJXRnpUUEtzOXQyRU9ZREVwd0JEbUhtSFY3bEFUS2duM3hn?=
 =?utf-8?B?V2h4eGg3MmxFc2c2MlJHZTVDc2tjRWpEczdDbjlQTEI0U0lvQWJud0lWTElM?=
 =?utf-8?B?Y3F4YnJrSGpoeGpkTGhrRzRaSm9GdjF6TmVpMUsvTGpBRjFvc3VPdGdCZEVV?=
 =?utf-8?B?Zkt1RG1MMmlMS1RNanVrU3pPa3BHVzdsYkFjS1Y4LzRtemxud1lYbG0yWU1n?=
 =?utf-8?B?VGFnM2tJMFYweTVydVQyWVJQaCs3TFBWWHY2ZUJObk9JY2taS2FySUlSQThU?=
 =?utf-8?B?RWZzeVVZaTA4MGZhTHhYeThVZjVzZWtPVkljSEpYN1JXeHN0VVY0VXdOWjIz?=
 =?utf-8?B?TWVSOW82aGZSRFhYNHU3b2tiKzhyTk12U25IMDdqRmxQK1NkeUNtN1cvL2VV?=
 =?utf-8?Q?c/0RXzEN4EmKg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR18MB3873.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 609d7690-6280-4244-88d4-08d8a2b6cada
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 18:08:44.3534
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vddcyvAz4CLHFP2Cq37ifHpde6X2N9spljpyfwZMmnQ8+cftcyLF04EcILGHDEtfbIXZ414Xy94Kv0TpKD4uWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR18MB3907
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_13:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBRdW90aW5nIHN0ZWZhbmNAbWFydmVsbC5jb20gKDIwMjAtMTItMTcgMTg6NDU6MDYpDQo+ID4g
RnJvbTogU3RlZmFuIENodWxza2kgPHN0ZWZhbmNAbWFydmVsbC5jb20+DQo+ID4NCj4gPiBJc3N1
ZToNCj4gPiBGbG93IGNvbnRyb2wgZnJhbWUgdXNlZCB0byBwYXVzZSBHb1AoTUFDKSB3YXMgZGVs
aXZlcmVkIHRvIHRoZSBDUFUgYW5kDQo+ID4gY3JlYXRlZCBhIGxvYWQgb24gdGhlIENQVS4gU2lu
Y2UgWE9GRi9YT04gZnJhbWVzIGFyZSB1c2VkIG9ubHkgYnkgTUFDLA0KPiA+IHRoZXNlIGZyYW1l
cyBzaG91bGQgYmUgZHJvcHBlZCBpbnNpZGUgTUFDLg0KPiA+DQo+ID4gRml4Og0KPiA+IEFjY29y
ZGluZyB0byA4MDIuMy0yMDEyIC0gSUVFRSBTdGFuZGFyZCBmb3IgRXRoZXJuZXQgcGF1c2UgZnJh
bWUgaGFzDQo+ID4gdW5pcXVlIGRlc3RpbmF0aW9uIE1BQyBhZGRyZXNzIDAxLTgwLUMyLTAwLTAw
LTAxLg0KPiA+IEFkZCBUQ0FNIHBhcnNlciBlbnRyeSB0byB0cmFjayBhbmQgZHJvcCBwYXVzZSBm
cmFtZXMgYnkgZGVzdGluYXRpb24gTUFDLg0KPiA+DQo+ID4gRml4ZXM6IGRiOWQ3ZDM2ZWVjYyAo
Im5ldDogbXZwcDI6IFNwbGl0IHRoZSBQUHYyIGRyaXZlciB0byBhIGRlZGljYXRlZA0KPiA+IGRp
cmVjdG9yeSIpDQo+IA0KPiBTYW1lIGhlcmUsIHlvdSBzaG91bGQgZ28gZnVydGhlciBpbiB0aGUg
Z2l0IGhpc3RvcnkuDQo+IA0KPiBBbHNvLCB3YXMgdGhhdCBpbnRyb2R1Y2VkIHdoZW4gdGhlIFRD
QU0gc3VwcG9ydCBsYW5kZWQgaW4gKG92ZXJyaWRpbmcgaXRzDQo+IGRlZmF1bHQgY29uZmlndXJh
dGlvbj8pPyBPciBpcyB0aGF0IHRoZSBiZWhhdmlvdXIgc2luY2UgdGhlIGJlZ2lubmluZz8gSSdt
DQo+IGFza2luZyBiZWNhdXNlIHdoaWxlIHRoaXMgY291bGQgdmVyeSBiZSBhIGZpeCwgaXQgY291
bGQgYWxzbyBmYWxsIGluIHRoZQ0KPiBpbXByb3ZlbWVudHMgY2F0ZWdvcnkuDQoNCkkgYmVsaWV2
ZSB0aGlzIGJlaGF2aW9yIHNpbmNlIHRoZSBiZWdpbm5pbmcgb2YgdGhlIGRyaXZlci4NCkkgd291
bGQgcmVwb3N0IHRoaXMgd2l0aCBmaXhlcyB0YWcgd2l0aCBwYXRjaCB0aGF0IGludHJvZHVjZWQg
dGhpcyBkcml2ZXIuDQoNClJlZ2FyZHMuDQoNCg0K
