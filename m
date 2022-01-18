Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035C5493129
	for <lists+netdev@lfdr.de>; Wed, 19 Jan 2022 00:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345513AbiARXFn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 18:05:43 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:34926 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230234AbiARXFm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 18:05:42 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20ILqUJ4032144;
        Tue, 18 Jan 2022 18:05:17 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2054.outbound.protection.outlook.com [104.47.61.54])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dnapfs450-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 18 Jan 2022 18:05:17 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FrrEs6f9YbATtRyG3N2Fub1r+FDrvnZ/osMVwIy04a9yasKSCdBmQgvPlIqcplj9gZ36hw8KHYTD1HLoixCLqW3jsEO09KRJ+E4fSDUy4OWyONE3vopSGRxU0wqbrrEOW/6fHttnf6pt48eXv2QwqR/vJ6QAtrSqZ+9gsfAAG1/GFkzLF8w3pgjbLvzezj3fJMl+ng9K5ZQ57SLBNW7uucaTWlImB8TB76BIcx58QihRAmmNvmBFQ5MhD+c2VoenGYiWf8FtGb4CQWjVec4SBTKgig89zcjy8o4IVJz9Rvt/2IisjnQy9WYRNCTTb0xEvC9VSPyaqrwM1t5sgHbMaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQnawUC1X0/xXPYtyW6ihkE/iOiyB9r7M2GsA+9yB1Q=;
 b=Nyc+e2xWRtggBslBgmWdYMnQe64fTsdrJoOh+ZtyzJ2c+/w7Hvoo9o8ewERckPWSTl3b1zzv7b7Qpsm0Ric53akmJ8N2EqC6/trRInrwBYM3kbWpPKmCuDPmsoCpk8e38BmMNwQQYphhPZP8y+ihsdPqA7ITmiMMNP1/ogMVIYRD6EFUe3CC5MAkCpJqqBGIY78XreE6Qw3H10btu1d1youIwhIQMuW4fGBf29iZklscbyka+7E+BZC7ReCRg8m+v/IKDnhhd+HYsZoy3+Bb3P1o3GdWJU+hglwICZ15r8f/P1Z2zl59aFuHnQWJy2ra7DV2nRPAS5ojS2ecg4OAPg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQnawUC1X0/xXPYtyW6ihkE/iOiyB9r7M2GsA+9yB1Q=;
 b=0YdXEnYHf821A64rwZUJDVLnQo2Rn/uAI7lo1EcVfVcWSJYS4Ydu3SYVikkefARk3C8CowWe9OLm0Hzcb0YpaOhg6Khys2kqXHZhPvG8YPGSMNwJ7MUayr22ywZptnV2d70dIz4CMSR7GLHNfo/FvIkdUKOkyTmXQ1WDeIi805M=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YTXPR0101MB1264.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:a::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.11; Tue, 18 Jan
 2022 23:05:14 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.014; Tue, 18 Jan 2022
 23:05:14 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH net v3 0/9] Xilinx axienet fixes
Thread-Topic: [PATCH net v3 0/9] Xilinx axienet fixes
Thread-Index: AQHYDLRF7DPR5PgYOEmYU3Flrfxa0qxpZksA
Date:   Tue, 18 Jan 2022 23:05:14 +0000
Message-ID: <993dcdd75d3839b5952e8632ae278f723273df03.camel@calian.com>
References: <20220118214132.357349-1-robert.hancock@calian.com>
In-Reply-To: <20220118214132.357349-1-robert.hancock@calian.com>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d7130d00-b3c2-48ad-30f0-08d9dad6fcab
x-ms-traffictypediagnostic: YTXPR0101MB1264:EE_
x-microsoft-antispam-prvs: <YTXPR0101MB1264793AF93ADDB1B276C744EC589@YTXPR0101MB1264.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:2399;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: dhAdTIwb1CmoQE6+DCg1yLM+WM1F0ChAmzj3y9ieLQPSo80kRd9dGCXzaBrT0a6A5dYReiJoZCZjuFDfJRgGt1vmaBEhOAMXCtBQQugjVhHQB9Szv5dBBtGQ/wFTBcgeudy3cPhJn/gLBZXuRzpoJ/Z0M/wiEqGGzx0yOb7qIq06SkC3i9vqIgGvKfxLJI3VJFXiksSjp/YzxvaNOdBS3EnBLfxHrMiU7GlLgrxTkW9Y7M7Qdr+i51BscumJVagpu4mjHTLzgN3+0udMIhbenJm/uEFI+3g86MlMWUZeJUMZsdZQkK06hu6oVvfc9vkMUFk4+wtqAAXY7mL75tFHFMpIFBufJn13fa1du4P76eswamRlabi+i7iX4I8X986xmGn9thTu1HQ0e/NCo993Z9SLybKb3DvLaFPLQwyYgbF1kvxnx3hFgC5RiktCtvcRb1UOcBbWfiPZ/iBvFxsETs4tJe3ViAzha0SZ4Q6RSd+9IbKhiF34hJ7YxI5t/gm5MDGPaBAbikF/1FNCMoShTQmJgyMVJ9myXI8vp+FetjAdOPVXVCEeapveWdIaNICk1QLzeMWPkJjeqPYnxNd6hitJ3P275BpLUslM0O9gWo40R9m29ZASduVp0vey3QFaLcTqV14OiQ2YCJgve5QIYf5p7iVUEfnMdsnDldITDY1keOt5GWDJtivoz6HhHQuYkQ4V27roWdeQ1iYMg1Zllx+8RKCJz8CvueMyCjvNr/aXcJmCFzm7nYHFURFvpV/Cen5100upS6duO1y79ehlnKAnRtB0zDeaBMFy0bmB+kbdF/5mZOguUhbzxib3nk9/eKoa262Pyx4QGVgI5b3kGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(44832011)(66476007)(36756003)(316002)(66446008)(76116006)(38070700005)(91956017)(4326008)(64756008)(5660300002)(66946007)(2906002)(6916009)(2616005)(186003)(86362001)(8936002)(6512007)(6506007)(122000001)(6486002)(508600001)(83380400001)(26005)(54906003)(15974865002)(66556008)(8676002)(71200400001)(38100700002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OG1Cbk8wa0dib010OVR5Q1RFdmwrV0tMdW9SRlRReVVVUFNNM2l2aW9pWEFj?=
 =?utf-8?B?QVlPdjl5dTMxWmVYS3lMVnA3YjVRa2liZG0rTE42ZDZvTmt5WlIwMUJPQTd3?=
 =?utf-8?B?RXVTUFBCTWZqeWhIbjZlQ2hFSG0wRVRpZFZNTDVnR3kvL2toTXg2d25zbVpS?=
 =?utf-8?B?elBPelhZMHozZkpOYzdYRXBYQks5RDVOTlkvR0tDUVhQaGIrS3V5R2xKWm9G?=
 =?utf-8?B?eGtIL0N0Y0V5M3dnNm9hMmtKZWF2WW9YdlRySEdyUHZPejhnUUIveDE2blFv?=
 =?utf-8?B?cXVndiswUWlCckZTczBFQWtsREJKZEdGR2x5NzRsdEJqQW1QUVgweExQTit1?=
 =?utf-8?B?U0EvM2VrVTkvZW1xMFQwZnVVdGRqQTdCZ2NySmxyQW5DNmFZREZiYXczRUlx?=
 =?utf-8?B?c3FqMExxRTFuRGlTOFV0d3FydERBcHAzTklJcndxZTR0T0JIaHRPM00wby9T?=
 =?utf-8?B?ZzJaM0ZlZzAwQ2ZSWXhIUEVXSHNjdHpvdEFqbloxcmoyZzJ3SHdRNzJFQ0s3?=
 =?utf-8?B?Yis5RWVCTG5KV3lhNi9PeWVjQldWVHFMZkg4L0s5dU0zUTFWaXV5dFIwOWk0?=
 =?utf-8?B?dFhteWtHV0dXYkFaamx0amhZVHQxTnZWcU50dUhoUDlqRktTeHkrbDIvVzVk?=
 =?utf-8?B?WjVYdnFON0p5dkV0OXBwWVE2dmt0SGYvSkpwRi9KSGhKRFdzK0FJem8wZmpr?=
 =?utf-8?B?UUVpaTZwb3N5VmRLeW9GYlRjcSs1YzNtTm9PWjlCc0wwWTVjMlFCKzNrM1NV?=
 =?utf-8?B?OXNONWl0YldvUEwrUEhPR1EyYzE0NEJVeU1WWGNOcmVyalhQYmxMU1JnZExs?=
 =?utf-8?B?ZGY4Lys0Vno3VnVBQjVKbXJXSDVIeG9nVlV2eVdQaDV4R1ZZKzI4R3plRUZO?=
 =?utf-8?B?WEdqSE5vUEYwTEduVG5QYUNQbGJkN2U1WEJFTTAzdnlyN2hVRE1rVEg1TVZ3?=
 =?utf-8?B?YmlnRC90SjRFcWNOaWJFTkFFck5mY293WWFMeFhLWFpUQng3M3lSWmdISjVi?=
 =?utf-8?B?V29qb0pGUEdScXFiblVTcVpDU2wrWldvSHBwUG40YzF0c2pPSlhmSVJXT3hq?=
 =?utf-8?B?WTJBMXlJMlMwQ0QrK1JDSGdPZGI4VlRoVUQzMjdtR1NmTE14bnB5NEFWQXdY?=
 =?utf-8?B?TVBVYkhWTkMwWVk2aHRLQ2tTZEV6TXhvdTdEQkN2VXZWOUtEeU5vQ2RUemhk?=
 =?utf-8?B?KzVoNmx6UDFUNGpIaHBrMUkwMHhBbjhWckNFbUw5TGpkLzErSk5VRXV4R2xQ?=
 =?utf-8?B?K2UrWGswMWcvR2VHZy9wSDUyWjNpQm1ZVXB2bmF5QTg0M21vS1M2b2lrUld1?=
 =?utf-8?B?Q0tFRk9sblFObkRscGxMc2lROU5kbUhXZllaRzRuUE03MzBtVFR6WDVWYWl1?=
 =?utf-8?B?SHZ6SFVXYkJockJRRGhPN1ZYaXVJOGNraTdlSVlURDlMbHFXZjFZMTF2ODVM?=
 =?utf-8?B?NkEwa0FsQlcxQzdDcmVodFhoemlsbm13N2poNytkcGIvSXZwVUZYTlh4S1dX?=
 =?utf-8?B?QmdTSDVRL0RxZndNNjB6S3NUWXBsQzBpQ3pBdGFlTWYzc3hrN0ZXREQ5NEZl?=
 =?utf-8?B?VXlkMC9WV002SEtrQklDK2dMYlNQS3NVbEtic3ZYc2gyZjVtMmNFVERsbk9Y?=
 =?utf-8?B?VFFibk1mOVBESFFkVDU2L3NXZVE4RGpoVnJ6ZHlIZDIrbmNjeFNPMWNGcExv?=
 =?utf-8?B?UVFOd2h2d2NhM1pMeVFTNitsZGJvS1k2K1F0RkZuZFZSYitGTDgzblNwc3dm?=
 =?utf-8?B?N0hUSVZIZnc2Nno0eGhMTWQreENGOTBBTW9YR1BJejduNnlTUUQxSUxxd2dS?=
 =?utf-8?B?akxCMFZ0UkdZN1BDbTNybXlGUjdqU2dEWEthMm1ibkJ1amFJT1cxUDlUOWVJ?=
 =?utf-8?B?d0N3OUJNM256NWRGckdHdGY2MDlreU8yZDVvTU1ja25veGdmSzY1bTdhcWRS?=
 =?utf-8?B?YTNiUmdVUHRlMEg3OXdUcjFTSjhzRURMTUtmNmFWTlN5RzhSOXBkWWVHTE15?=
 =?utf-8?B?OVk1RzhUMERMaTU2Mi9veGE5MXRMaDQrMVJQbVAxdDJFTC93ZkdzczBONTZZ?=
 =?utf-8?B?cWhKTTBjTy9SbWJtTGNUQU1NbjVHM0tjbEhsR0lCZGVtTkxXVmRmK2xad2tz?=
 =?utf-8?B?Ull1VE1yQXRuQTQ2VERGVmowSG1XWGtvNVV0RjVXZkpIMFUxSDNBeUpXUDNK?=
 =?utf-8?B?Q3paaUtNMm5MbjZhdjJ1SWZIOW4yVG5XakY5UWVnb21Pb3VwM2U0UE1PZWpC?=
 =?utf-8?Q?jEblc6I6Uo31nbhTVo/X7WEpXziWwBbnvJHY5HBTAQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7A6E32C4B766C1449B3B6CDBD973ED4F@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d7130d00-b3c2-48ad-30f0-08d9dad6fcab
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2022 23:05:14.6257
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mwewQvrVQc5XY9gX9WNGPNkjqpqrq81Ob08KM122wahuS7eBEtcMduFFCT3forFurGvZKpN5jM8UKiH79xthuqySO8JNRcZ8SnGVK/Kdz84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YTXPR0101MB1264
X-Proofpoint-GUID: COv5hnJxeHAb7nylOR_nyee7uJUzY2rq
X-Proofpoint-ORIG-GUID: COv5hnJxeHAb7nylOR_nyee7uJUzY2rq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.816,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-18_06,2022-01-18_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 suspectscore=0
 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0 bulkscore=0
 spamscore=0 mlxscore=0 malwarescore=0 impostorscore=0 adultscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201180130
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAxLTE4IGF0IDE1OjQxIC0wNjAwLCBSb2JlcnQgSGFuY29jayB3cm90ZToN
Cj4gVmFyaW91cyBmaXhlcyBmb3IgdGhlIFhpbGlueCBBWEkgRXRoZXJuZXQgZHJpdmVyLg0KPiAN
Cj4gQ2hhbmdlZCBzaW5jZSB2MjoNCj4gLWFkZGVkIFJldmlld2VkLWJ5IHRhZ3MsIGFkZGVkIHNv
bWUgZXhwbGFuYXRpb24gdG8gY29tbWl0DQo+IG1lc3NhZ2VzLCBubyBjb2RlIGNoYW5nZXMNCj4g
DQo+IENoYW5nZWQgc2luY2UgdjE6DQo+IC1jb3JyZWN0ZWQgYSBGaXhlcyB0YWcgdG8gcG9pbnQg
dG8gbWFpbmxpbmUgY29tbWl0DQo+IC1zcGxpdCB1cCByZXNldCBjaGFuZ2VzIGludG8gMyBwYXRj
aGVzDQo+IC1hZGRlZCByYXRlbGltaXQgb24gbmV0ZGV2X3dhcm4gaW4gVFggYnVzeSBjYXNlDQo+
IA0KPiBSb2JlcnQgSGFuY29jayAoOSk6DQo+ICAgbmV0OiBheGllbmV0OiBpbmNyZWFzZSByZXNl
dCB0aW1lb3V0DQo+ICAgbmV0OiBheGllbmV0OiBXYWl0IGZvciBQaHlSc3RDbXBsdCBhZnRlciBj
b3JlIHJlc2V0DQo+ICAgbmV0OiBheGllbmV0OiByZXNldCBjb3JlIG9uIGluaXRpYWxpemF0aW9u
IHByaW9yIHRvIE1ESU8gYWNjZXNzDQo+ICAgbmV0OiBheGllbmV0OiBhZGQgbWlzc2luZyBtZW1v
cnkgYmFycmllcnMNCj4gICBuZXQ6IGF4aWVuZXQ6IGxpbWl0IG1pbmltdW0gVFggcmluZyBzaXpl
DQo+ICAgbmV0OiBheGllbmV0OiBGaXggVFggcmluZyBzbG90IGF2YWlsYWJsZSBjaGVjaw0KPiAg
IG5ldDogYXhpZW5ldDogZml4IG51bWJlciBvZiBUWCByaW5nIHNsb3RzIGZvciBhdmFpbGFibGUg
Y2hlY2sNCj4gICBuZXQ6IGF4aWVuZXQ6IGZpeCBmb3IgVFggYnVzeSBoYW5kbGluZw0KPiAgIG5l
dDogYXhpZW5ldDogaW5jcmVhc2UgZGVmYXVsdCBUWCByaW5nIHNpemUgdG8gMTI4DQo+IA0KPiAg
Li4uL25ldC9ldGhlcm5ldC94aWxpbngveGlsaW54X2F4aWVuZXRfbWFpbi5jIHwgMTM1ICsrKysr
KysrKysrLS0tLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDg0IGluc2VydGlvbnMoKyksIDUxIGRl
bGV0aW9ucygtKQ0KPiANCg0KRllJLCBmb3IgdGhlIG5ldGRldi9jY19tYWludGFpbmVycyBQYXRj
aHdvcmsgY2hlY2ssIEkgZHJvcHBlZCBBcmlhbmUgS2VsbGVyIDwNCmFyaWFuZS5rZWxsZXJAdGlr
LmVlLmV0aHouY2g+IGZyb20gdGhlIENDIGxpc3QgYXMgdGhlaXIgbWFpbCB3YXMgYm91bmNpbmcu
DQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlvciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFu
IEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNhbGlhbi5jb20NCg==
