Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 077F72DCC0C
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 06:26:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727095AbgLQFZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 00:25:28 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:43530 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726293AbgLQFZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 00:25:28 -0500
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 0BH5LPQS012781;
        Wed, 16 Dec 2020 21:24:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=pfpt0220; bh=7PyzHMHmUm5Pt8YL06e1RQilku9hasQcpdldVlB6m2U=;
 b=MiPH+4eo09SGBgNjqjK6/EpBaoKHfB7NjAFC3M9WrAHHHUIGdd3YMoKMX6CCmfquuVg8
 cmAa89YRs5ATWovvhoPoLZ+kEMCy1IciFz/uy5SMYA1pO/EdewFUgwlaG08mCMEuT9xH
 jwLcBHRbzK9ko6fSnrJ+ULUkMvwFaO8NxsxlS98NegixIa4kIM7/xfhG+5Bd6KYi/Dz4
 0mY+C+mzyWIaXZsqG+LUHjSS9uX9AdOvP15SM5F2e8FghPegtSs9FgcTiA1QF6CLdLGJ
 n8eLerir+VUEJSYMH/aFIUS9F5fRE41y979Ic8HjnPM2LCYc1CPEw8UPW/qhfKBqshaA nw== 
Received: from sc-exch02.marvell.com ([199.233.58.182])
        by mx0b-0016f401.pphosted.com with ESMTP id 35cx8tejh8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Wed, 16 Dec 2020 21:24:38 -0800
Received: from SC-EXCH03.marvell.com (10.93.176.83) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 16 Dec
 2020 21:24:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by SC-EXCH03.marvell.com (10.93.176.83) with Microsoft SMTP Server (TLS) id
 15.0.1497.2 via Frontend Transport; Wed, 16 Dec 2020 21:24:37 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XxwAH+iwJtvNZDlEtxTbAt/B0KmRPFonbPPVKDsrfE7lBscGBNedG/lzBjKtPRaiON+Sb5vDrDRsfejuS05pM2yIyGGlpdn5+pk7K3V4Bv9F5U7QsuGX2txlLWZVBgRb2ZEHPRGGeZkCQSZrlXe9V0q/YpY9sAlyaX/xYEhGAvgBFxe0ajrQmm2tPM+reRTc2iYCusa00wmgjTIHaqoOaHPgujOBRtEwSU6brSCN49tKZMA63hVM1nA/jDGKNodjDTBF5i6DJJLg/UCh4WNDnGgvMNZ8alwa9G6TLnXFTWSVd2RIB/W2YDqnFMYV8tUOV1wDf0wtPofAbWIeNbxAgw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PyzHMHmUm5Pt8YL06e1RQilku9hasQcpdldVlB6m2U=;
 b=oUW+uSam6/Ay+r7BBJST5dRe1vYSGqeWFAKlx/Oh+rqpKQonG0EJ4nv7wwhVrz/RXBusRYhgaYtGEIVFRHsVww9LI1HJ2NidOgoYS1gCvytAH50b/CWFU2ny9FQHt+zQlnG/3eKsGB7n/FKT9ORWrWSYMlaaCMlewk7eBn1yW8bS/B69ujkvT+G8jTqraLTjn/Ah8hO6rfOPUcLzlCSFG/Ki+jG6I21LHOfeD4GiWpt7cCiTpFXHT4cli6PiGfT4JRU1BfmePKkHivnxpxjHBq/fpqBBpIoBc3f5Wh3t5KWIE29hnZSpYSz0lJzdFRLRkYuhVid/aW4FdBPOHOK8yg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PyzHMHmUm5Pt8YL06e1RQilku9hasQcpdldVlB6m2U=;
 b=oOOhLcmJy9rhHZC+YIQzPrHRUg3kgrgtuH3iWCppYQwdJbQfbkx9z7NYomxq+8RuIgQplgvV5neDCEJM+JYYrcTr87SFC/z53CF1SM0hFJv3kk+R/7gUEFFiagjnjFmWz0vXnI7TRHpb7rY0z9TCIlIMsowLho49uFhRICUP2nQ=
Received: from BYAPR18MB2679.namprd18.prod.outlook.com (2603:10b6:a03:13c::10)
 by BY5PR18MB3137.namprd18.prod.outlook.com (2603:10b6:a03:1a6::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3654.12; Thu, 17 Dec
 2020 05:24:34 +0000
Received: from BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::246d:f9ff:9252:8540]) by BYAPR18MB2679.namprd18.prod.outlook.com
 ([fe80::246d:f9ff:9252:8540%7]) with mapi id 15.20.3654.025; Thu, 17 Dec 2020
 05:24:34 +0000
From:   George Cherian <gcherian@marvell.com>
To:     Colin King <colin.king@canonical.com>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        "Geethasowjanya Akula" <gakula@marvell.com>,
        Jerin Jacob Kollanukkaran <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH][next] octeontx2-af: Fix undetected unmap PF error check
Thread-Topic: [PATCH][next] octeontx2-af: Fix undetected unmap PF error check
Thread-Index: AdbUNBxyLXJwCXXaTtybFbhN3ps0nw==
Date:   Thu, 17 Dec 2020 05:24:34 +0000
Message-ID: <BYAPR18MB2679726F785B910EA9325ADCC5C40@BYAPR18MB2679.namprd18.prod.outlook.com>
Accept-Language: en-IN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [202.164.131.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 33d46cbe-8283-40e4-93a4-08d8a24c0a4a
x-ms-traffictypediagnostic: BY5PR18MB3137:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR18MB3137095518E60B199CB395DFC5C40@BY5PR18MB3137.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EiLSqWwUVt4zIc+SD0GCvccOtrbEWPZqVS96GQ8WdeouzwrhBQthDrc7uHx7xzvw7ZjpFFcsfJcDK1R/JFt8BcJ+xbW2/3lO/UrF1szlaEFS+8IJVvWRPWdGj6MN/OuJjfN1ns9zBfK3TkMKo6SAwxodgLN+0/8QcyyMR6X7MOk5PFNG52NQWYfN3wQ5qOrNbUf6mAMgl+q3q1eJAtG0yUINuPi2oHCm7CxaWSGyYwcQlHiHVmodrkpLb5KjZq1xcwF1yc+kznNWjYsn9Nzck13UhseuHcDS4sPIFpmTUI0JhpSc8YL/mIVjn7YOtVR7ZuReG58YVHIv+qWlJl4tbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR18MB2679.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(396003)(376002)(39860400002)(346002)(366004)(53546011)(5660300002)(8676002)(8936002)(186003)(316002)(9686003)(64756008)(2906002)(478600001)(71200400001)(7696005)(66556008)(33656002)(52536014)(54906003)(66946007)(66476007)(83380400001)(76116006)(110136005)(55016002)(4326008)(86362001)(26005)(66446008)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TUt1b1hEajVmWVhhYnhqTG1UWTlzL0tyVklsN25YWThOOTBpUU8zN0owODFU?=
 =?utf-8?B?ZDhHYko1aUJMOGE5TXl4SFFPMHhnM3g1Zkg2c2t6QXpWeVlhN3U4a2orenVO?=
 =?utf-8?B?S1VkTFRDN3BzK3VXdlBRZDJRaVI2WUNib01mcjVTNWZ2Y1IycURQYWFtd01T?=
 =?utf-8?B?MmZITm12YTRReUtjdDJXOC8vWHdNMWVPVDRvNjkrUUxXb1N0N2lTNExsdE5q?=
 =?utf-8?B?Yzk0ZDR4N2wzQlEzUzBrWEo4L3FnQittRjBraEpwYWpwSDkyaE1zZkpLQ3lL?=
 =?utf-8?B?anVFZkF6SWhuWDRFV2xlRDdhdmw4NzcxcG5RUExDQ0JBT3MxNFFiSjdvWjd0?=
 =?utf-8?B?V3l4a2RHR0FMV3M3UU1pSWt0Q1lZUE81ZVRQQnZieHZNWGhCNWFjVy9Fck9x?=
 =?utf-8?B?NEMzUmlSUXhhc25lYU1sWXh6N3A0Q0FaOWJuaXdJeDVjLytwUGZhZ2x6WEZp?=
 =?utf-8?B?SWhJa2p6ZFFSQUFQR3VOTzM2bUI4UjZXaEkwSm9DeW5uZDYxUTVxWm1RV25R?=
 =?utf-8?B?MzJHMzBTc21SV3MwMmt2OWx4NDVRNU1hRnhnLzRlQ1NMNi9uSGUydXAyUzRC?=
 =?utf-8?B?YWpBUGZ5NTNwdVI5SFhJWmtlb1ZwYjZvaCtvSmZacm1HZkUzVkcrTGJhTTBG?=
 =?utf-8?B?RGZJV2xvUEM2SWhzRWQwWGlCMDlqSmUxaURROHRNRnhkeHoreTl0SDNnNkZO?=
 =?utf-8?B?TTJNMmlPU2xMc0tIOWw2L21mcFArdUQrbCtLUkIybDcrUUgzNGFSRW80Qjd1?=
 =?utf-8?B?UE5sTkNBOUxaNG1jYW1wd3hSYWlnSW1WOEVPQ2NqRVNacnlzQnRNZUVQV2I0?=
 =?utf-8?B?QVh3LzVoZnJ4YUdDK2FyNEd0d0kyU1Y4Ukc2MVk3ejFsZTZOZHdXOVRwSHl4?=
 =?utf-8?B?WWpiaWxMR2VUZ0wyVGtDYmUweFdvZnVEekphS1JBb3cwY2w3VzIvTENPZlVi?=
 =?utf-8?B?MSs1eVZ3YlA3TWhpNzRLY21KelRnaERvOXk0b2owTXpvenYxcDlXVk04Z2Z1?=
 =?utf-8?B?V2dHSjlYMHcyczlFSEdmQkJreXduSzBOVEZCR0NuOEpHSldheUQ3Ym1ya0Rv?=
 =?utf-8?B?dDRVRStKcU1CMWFINHk0VGlIVlBJZi9ILzBXN1Byc0NyN1VyVHQ5OTJpelI0?=
 =?utf-8?B?bCtJYmJ4OVZWbXVvQ0pLelFkNVU3cHptVDR2bnQzaFdHamgrN2ZoMFU1WHI0?=
 =?utf-8?B?cy9MZlZPd2wycFJ1QmJvbVVYQjVLYm9tUlp0eFc2MEYvNi9wd1l3MlgxUEd2?=
 =?utf-8?B?emx0c3NTQUNjbEpPVzN5UHBXemNVcnRYT3RyYW5UVHNWcW5tZmFqU1hwendw?=
 =?utf-8?Q?CMI9nT2/FT2jk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR18MB2679.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 33d46cbe-8283-40e4-93a4-08d8a24c0a4a
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2020 05:24:34.5689
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ytw8S2SMl/rWRrkNQ2ayr33cK8NXog7UbkCJzk9CpeLjcacYBUkYPYAl6ZR8YTanOlfCZ8dUAk4v33yrtidY6A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR18MB3137
X-OriginatorOrg: marvell.com
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2020-12-17_03:2020-12-15,2020-12-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQ29saW4gS2luZyA8Y29s
aW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIERlY2VtYmVyIDE2LCAy
MDIwIDY6MDYgUE0NCj4gVG86IFN1bmlsIEtvdnZ1cmkgR291dGhhbSA8c2dvdXRoYW1AbWFydmVs
bC5jb20+OyBMaW51IENoZXJpYW4NCj4gPGxjaGVyaWFuQG1hcnZlbGwuY29tPjsgR2VldGhhc293
amFueWEgQWt1bGEgPGdha3VsYUBtYXJ2ZWxsLmNvbT47DQo+IEplcmluIEphY29iIEtvbGxhbnVr
a2FyYW4gPGplcmluakBtYXJ2ZWxsLmNvbT47IERhdmlkIFMgLiBNaWxsZXINCj4gPGRhdmVtQGRh
dmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgR2VvcmdlDQo+
IENoZXJpYW4gPGdjaGVyaWFuQG1hcnZlbGwuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0K
PiBDYzoga2VybmVsLWphbml0b3JzQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0hdW25leHRdIG9jdGVvbnR4Mi1hZjogRml4IHVu
ZGV0ZWN0ZWQgdW5tYXAgUEYgZXJyb3INCj4gY2hlY2sNCj4gDQo+IEZyb206IENvbGluIElhbiBL
aW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KPiBDdXJyZW50bHkgdGhlIGNoZWNr
IGZvciBhbiB1bm1hcCBQRiBlcnJvciBpcyBhbHdheXMgZ29pbmcgdG8gYmUgZmFsc2UgYmVjYXVz
ZQ0KPiBpbnRyX3ZhbCBpcyBhIDMyIGJpdCBpbnQgYW5kIGlzIGJlaW5nIGJpdC1tYXNrIGNoZWNr
ZWQgYWdhaW5zdCAxVUxMIDw8IDMyLiAgRml4DQo+IHRoaXMgYnkgbWFraW5nIGludHJfdmFsIGEg
dTY0IHRvIG1hdGNoIHRoZSB0eXBlIGF0IGl0IGlzIGNvcGllZCBmcm9tLCBuYW1lbHkNCj4gbnBh
X2V2ZW50X2NvbnRleHQtPm5wYV9hZl9ydnVfZ2UuDQo+IA0KPiBBZGRyZXNzZXMtQ292ZXJpdHk6
ICgiT3BlcmFuZHMgZG9uJ3QgYWZmZWN0IHJlc3VsdCIpDQo+IEZpeGVzOiBmMTE2OGQxZTIwN2Mg
KCJvY3Rlb250eDItYWY6IEFkZCBkZXZsaW5rIGhlYWx0aCByZXBvcnRlcnMgZm9yIE5QQSIpDQo+
IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9uaWNhbC5jb20+
DQpBY2tlZC1ieTogR2VvcmdlIENoZXJpYW4gPGdlb3JnZS5jaGVyaWFuQG1hcnZlbGwuY29tPg0K
DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvcnZ1
X2RldmxpbmsuYyB8IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWFy
dmVsbC9vY3Rlb250eDIvYWYvcnZ1X2RldmxpbmsuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0
L21hcnZlbGwvb2N0ZW9udHgyL2FmL3J2dV9kZXZsaW5rLmMNCj4gaW5kZXggM2Y5ZDBhYjZkNWFl
Li5iYzBlNDExMzM3MGUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21hcnZl
bGwvb2N0ZW9udHgyL2FmL3J2dV9kZXZsaW5rLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvbWFydmVsbC9vY3Rlb250eDIvYWYvcnZ1X2RldmxpbmsuYw0KPiBAQCAtMjc1LDcgKzI3NSw4
IEBAIHN0YXRpYyBpbnQgcnZ1X25wYV9yZXBvcnRfc2hvdyhzdHJ1Y3QgZGV2bGlua19mbXNnDQo+
ICpmbXNnLCB2b2lkICpjdHgsDQo+ICAJCQkgICAgICAgZW51bSBucGFfYWZfcnZ1X2hlYWx0aCBo
ZWFsdGhfcmVwb3J0ZXIpICB7DQo+ICAJc3RydWN0IHJ2dV9ucGFfZXZlbnRfY3R4ICpucGFfZXZl
bnRfY29udGV4dDsNCj4gLQl1bnNpZ25lZCBpbnQgaW50cl92YWwsIGFsbG9jX2RpcywgZnJlZV9k
aXM7DQo+ICsJdW5zaWduZWQgaW50IGFsbG9jX2RpcywgZnJlZV9kaXM7DQo+ICsJdTY0IGludHJf
dmFsOw0KPiAgCWludCBlcnI7DQo+IA0KPiAgCW5wYV9ldmVudF9jb250ZXh0ID0gY3R4Ow0KPiAt
LQ0KPiAyLjI5LjINCg0KUmVnYXJkcywNCi1HZW9yZ2UNCg==
