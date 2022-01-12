Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4338248C8AD
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 17:45:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349737AbiALQpe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 11:45:34 -0500
Received: from mx0c-0054df01.pphosted.com ([67.231.159.91]:35855 "EHLO
        mx0c-0054df01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349725AbiALQp2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 11:45:28 -0500
Received: from pps.filterd (m0208999.ppops.net [127.0.0.1])
        by mx0c-0054df01.pphosted.com (8.16.1.2/8.16.1.2) with ESMTP id 20CE6hRW020034;
        Wed, 12 Jan 2022 11:45:20 -0500
Received: from can01-to1-obe.outbound.protection.outlook.com (mail-to1can01lp2053.outbound.protection.outlook.com [104.47.61.53])
        by mx0c-0054df01.pphosted.com (PPS) with ESMTPS id 3dj0fcg3s1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 12 Jan 2022 11:45:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lWZ6AhEBU+7/uHIBqm0rqmTlcweDka+WSY60Z/1H/Hdy/JmKMAq5OimItjYoe/Up06YuEGrMwtxT+Oycfr4llAkSUVOpPql8ZeNQD7ge8eHcXXN/RU+0x9f3A2yGkn0xUGBisZXwqT/+wUfFCdYCukuH1NVmKRNQJ7tTPjn1UroTWlOVRoEXZIGZwi9UNr6pO8xfe7N1TOMcCZ7fqHQkbyu5CteBLqV8GDEfbOPFyP3a34P5w4aKtEwqCJ/sbbEVfpXvjKImpuQ0mcmUf9fs4Y4+GJcUZypz2cAsb7XKAjjpk3qKt3imJzLjfMIyZpQ7YrGZJVQrf5zANJZwgsquTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=e/J7UxqA4Q6WLbMcuIzCCOZnz/JJlTc6gosY3LJ+rVs=;
 b=IpR2NAt+Ux3kKTDyWJjQcxarC9vMIUnaS1ItAoH+K1gsVM3wHTt4JXKytbqoEQfU9kVY7VRKwY+xn3E2zDB3+e+lqFGpLppYa27UHKlR/HMkQjjDY+4BlYOctC0CWaCTJkwmlaIOeHF/25n8jocolgsRb5EMTrkU/zrp/A1DaooI03CPgNZchrFaNAmuGvJgAKssX9DDXpyp951jN1BrTd7Udd/PAB1RK1lKdz4SJS9KRbKKEIOaeQ5lEg0+nWh+eyT8FKK7oHWsszaeYOCT2rbr2K/w5k3Fg8VNuiFbwPMsN7aUuEKLTZB65q1hBshxFinzcLSSDYhYETJXUTwm3A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=calian.com; dmarc=pass action=none header.from=calian.com;
 dkim=pass header.d=calian.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=calian.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e/J7UxqA4Q6WLbMcuIzCCOZnz/JJlTc6gosY3LJ+rVs=;
 b=AaS5ic6ZYRaBciM3vgdeQdAbjxEQvBud1CfLBu0N5sYquJ/NhJhXYMD2HFhttkC99O4gcJk+7oTif66x6OFxI2imxWz6Kyd2YUprreTO1R04019lYH+EvqVLnNFTHpmOZv0nFLGoh30xdaqsH3XzInVhetC1dg+Hp2DGcp8+Q0k=
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:6a::19)
 by YQXPR0101MB0726.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c00:1b::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.11; Wed, 12 Jan
 2022 16:45:18 +0000
Received: from YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8]) by YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
 ([fe80::6929:c39f:d893:b6c8%2]) with mapi id 15.20.4888.010; Wed, 12 Jan 2022
 16:45:18 +0000
From:   Robert Hancock <robert.hancock@calian.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>
Subject: Re: [PATCH net 6/7] net: axienet: fix for TX busy handling
Thread-Topic: [PATCH net 6/7] net: axienet: fix for TX busy handling
Thread-Index: AQHYBzA5L1u5H0SMT06JpF46UOhrCaxewIMAgADYrAA=
Date:   Wed, 12 Jan 2022 16:45:18 +0000
Message-ID: <e3b5c842272de17865477110ee55625464113cda.camel@calian.com>
References: <20220111211358.2699350-1-robert.hancock@calian.com>
         <20220111211358.2699350-7-robert.hancock@calian.com>
         <20220111194948.056c7211@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111194948.056c7211@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-CA, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-18.el8) 
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dcd8df8d-49d9-41a4-492b-08d9d5eaeaba
x-ms-traffictypediagnostic: YQXPR0101MB0726:EE_
x-microsoft-antispam-prvs: <YQXPR0101MB072672DD2752723F0C22472EEC529@YQXPR0101MB0726.CANPRD01.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Fgn3tiLIISkRbRit8lMVnVcYDfNfpQHAlTf/a43jyuPJ6VnZYnzW159YtOhj018xjnEXjMTeogMcBeuvM/kQoGVHmhAGUS+zFvGKH2Vyvo01A2oAN1QUuspkxkt+o0wa/CzYv1VJIg5owi86MJSRQpgAmpF2NFoZmBIFdPxuQ1Cn9EoOeAMyXxAscLTgEHwc2P++GCzEzwa9ZY8l7tePnVC9AYQiupq2/qwmHWaPmK6G7uuTMYGomObezxp1dwmvqJuNLSPIAKVcLcy5n/8CrGYXl7ZL1ZeuUzABq48z7UMh4jgp52qw/M2D9roSKIkyW8TopKfjcvMhXYNsaCGTWKTH+hwco2GbiL32fJ86+tM+u03r14gtTUkKuKw8y8WZu7u19cCV9qz/WRG5gCJuF2X6EBRd5HCPZJ31jDegRzVFNtwBhH4mfg8D/zAX+XV4jUeP9eW5/TETMjl4drElWrCuYt8amOvS8aeyS2e50y7TX/fAiEltRLXUu0MZ+lVCcygIJJR2bmLJ5A1Z2Mv5ehlvMGTwatHQA6x5qVnmKB9ggp9bpP7SwD1i/47ZdNUWGI8fWWqYTuXNrmwJHYqmONchdaG7+tL6pV3EDmV17IEeSXcETZageKkO1RyZm2eAMOrHzBR/6rGbp+BCuSRjhO1DWRy/Sjpr3Yc58r0FmlQV5ShrshayLzu5/hPxxu10lvyxhVxeqh9wW6+7IxFyobkMYu6GyIQmcc94aCEqMuduzJw+TtqRHFtYfmFXjiSuTmv6rp4DYID56QiZ5+BUlUoIghoWt4NIqcsWm+7LehPl4//LBpSy7A6PVARJ8VK1dUk5oWp9UzPxR229qQjTHw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66446008)(2616005)(66556008)(6916009)(83380400001)(5660300002)(6486002)(91956017)(66946007)(76116006)(66476007)(44832011)(86362001)(36756003)(4326008)(26005)(38100700002)(6506007)(8936002)(2906002)(186003)(38070700005)(316002)(71200400001)(508600001)(122000001)(6512007)(54906003)(15974865002)(8676002)(99106002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dE03SHYrbWpTOTdJRXhvRUtWRDZ3Qnc4bXdmU3JFNEJ1QmIxNG5JQTdMSG50?=
 =?utf-8?B?TTRxRXFkb3JxUkUrYWxhbldJWlhYd3hwL1Y2RjVPdURRSllNbk5GQW4yN2dl?=
 =?utf-8?B?b095UWNyL0J4anFFa0FoR2FKYVBKeUk0bllJS2xuQlo2R0VQbGVncldJMHdK?=
 =?utf-8?B?c0RtY20vWXhwNU9JNFRkMFdRekQrbnZjZytQc25wMGFiRjdwNjhOQVIrYkdx?=
 =?utf-8?B?R2J3cVY0b0M5Tlg3VEVoZElQbjFKN05iTURsYnQ0YldnRlVURE94a3ZtUnB0?=
 =?utf-8?B?dTRnbjFLQVpTa3NlY3IzNHplVk5tVlJUZDh5MCttSnpNTDNhNnRqN1dsQXVp?=
 =?utf-8?B?bi9LejJOZGpmUG1aMEJ3OG9IMGhaYVpzV0VRYmtLSnZMajNUREVXSS9lL3Zz?=
 =?utf-8?B?WDF3NmJob00zMlZQL284SUhwZG5oTUFMNjU5RmIzK0h6RUFmMDRsSlpjU2RD?=
 =?utf-8?B?UzIvcFh6TmlvbEM2UE1waGpZSmJJanYrWlpDRW56ZU8zeEl2K3ZTdE84UVJW?=
 =?utf-8?B?NmF3ak8vM0xrWStZTzZXTVZrbng0eUU5Q1hBNHVsVDN2M01qVGpJUUQ2Y1BV?=
 =?utf-8?B?SmZRQ1Ixd1JlMzJEOFQwK2l2L2k5cFN6TVlWakkxTjZmM05CdmxsbW9MWURm?=
 =?utf-8?B?c2F2c3VKRGRicVI2cEczTHordDNHRFVGNklvNk9ONmJMSGpqUDFSNEVPQkcx?=
 =?utf-8?B?ek0zRmkyNlJtMENSZ2NoKzdQdnhjVHpEZkpZNjRRNU5QVVEzQktTM3hJeDIz?=
 =?utf-8?B?SXZmaGJoS2RLTldna2ViRi9KMDJ0OG1OVEw4ODB3WFNGZUdVNVNXeGxmdTdH?=
 =?utf-8?B?U29xS0FBZktZTGYxS3NOT2l5dUNOTGs1NmlPWm9JNFU1WDdGY1lveEh3ejVa?=
 =?utf-8?B?cGFWaS9UTGVRdGdjaG9jM09sUUdzN3ZYdGxMS0lQWWw4VTBkakU3QTNxMS9y?=
 =?utf-8?B?aENXU2JMMk9iS0NOMmxOczZONDFWV3F6MmVhSnA2THpZMi94K0JXYmU0dmZq?=
 =?utf-8?B?WHd6Um15eEc5aDI5N3M5eE1kUG91QnRDZGNsVWJHbjd4N1RSak9LcXU4eXNJ?=
 =?utf-8?B?UVhCQnc4ZlpQL2lOZGpwU2drejRtTjBwRWtIdURYc3BpVnVlN1ZXb3pPQ1RZ?=
 =?utf-8?B?QlJoL1ZZMVhxaGVFWVRUZHI5QWZwdUplQXJ1WXh1TTJ1RlRGQjNqdnNQRTRB?=
 =?utf-8?B?cHdpZDlhYjF0REsyc1k2ZlBvajVRaEMzU2VwWlg2U1BNYnlKb2RVeXV6MVk0?=
 =?utf-8?B?d2pveURzblg0ZjgxOFVIR3RtQWVtak05K3RoUjRLQVU5ck85cFhuV2xOd1E4?=
 =?utf-8?B?YXQwamtGcms1NWZjeCtYQ2FBbzZJU2R2YkZRb3RkWXZvV2FCK2daODd5TjZE?=
 =?utf-8?B?VjFON21IbGY1VEttb2t4K0V0d2w2L1Z3R29XN3QvTTIyNmtzaE11UTZOWkEr?=
 =?utf-8?B?MThhTGI4K0xFc0JEMjE3MDNwd3N5YUI4NnJxSjhPVG5KZmNsSHhTSlJGcTJ5?=
 =?utf-8?B?UGhLYUlQRjFTNVRVRTdZV2lDZUFJd014aVpzWDBsOENCU0FtcHZ5eEg3bXM5?=
 =?utf-8?B?ZWxEYWk0YUVXNU1yWWk2T0ppSUdkazF6N3JRZ2JwTHhxS0NhT0JLaWFqeG1L?=
 =?utf-8?B?a1RHYmNuY2hKZG9sOXJzSGFBakxncVd1TzB0dVlFaWZ6VnVGYjFab1NFd25w?=
 =?utf-8?B?YjR1cFZtVW9acjZ2am5sQUFrMk9kSnMzRU9HYWVWRlppaENKNnl0bnlZMUl6?=
 =?utf-8?B?TnFCMXpGeCtOQUNiSzNHOGJjNHl0RytyT3MzZVVDWGlJaTA2WVJJSi90cUth?=
 =?utf-8?B?aGIyMGE5Z0hCMlhaZjJ4R2lWaHNVVnVpVDY2SnBJWmlJTEVCU0lkZGZBVUJN?=
 =?utf-8?B?anZvVzB6L1hsejIzZXlqL1dERklHckhrRlE0ekliUW1ndTU4NVVzNVlYMVR2?=
 =?utf-8?B?aTVybEZsUnIyT1JCYlI3eWRFdVdDazFXYU9TS2F6K1lqVW1BemZmQUI3YUND?=
 =?utf-8?B?YS9KTDE4emdrQzF0MHJ2UmxjVW9MR0tTZ21ra2VvczZlSzFtZlljb2xDY3dF?=
 =?utf-8?B?N3JEUllPZkozd0NGZ1NZU1YvWWxmWnFpbHAyeGlzVHN2MWpreUE4QWsrVkg2?=
 =?utf-8?B?OWtnbkd2VHI3eXVxTWx0TGJXZnlKRElvMG9QeXN1MW1yMzR3bzl6cmpYU2I0?=
 =?utf-8?B?VEhEck9SQTRhV09WanBTc1hFVnpwK1oraDVJR3Q2dkNrSitZTUkwQ3hQNWpP?=
 =?utf-8?Q?ZA0iDZD1uqLdXQcOxYwi6Za5BCqgKOFFhfucv924hw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <73A267C9A0F8D748B23DB073E87FF332@CANPRD01.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: calian.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: YT3PR01MB6274.CANPRD01.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: dcd8df8d-49d9-41a4-492b-08d9d5eaeaba
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 16:45:18.6151
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 23b57807-562f-49ad-92c4-3bb0f07a1fdf
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iRkAFfmtjV6x3T5MbpADQlMBkhH8WA8mXTWdDetVhH33MSG8MhYLlDltlBDjR9ObWZDqqdD0Ez4ycVqTwmkjL8nuyydz7kuCK12v+FdMxEQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: YQXPR0101MB0726
X-Proofpoint-GUID: IxJ4qPAbAGekww1BtSCfp3ejAtciS7cp
X-Proofpoint-ORIG-GUID: IxJ4qPAbAGekww1BtSCfp3ejAtciS7cp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-12_04,2022-01-11_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=999 spamscore=0
 mlxscore=0 adultscore=0 malwarescore=0 bulkscore=0 lowpriorityscore=0
 suspectscore=0 impostorscore=0 priorityscore=1501 phishscore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201120105
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTAxLTExIGF0IDE5OjQ5IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAxMSBKYW4gMjAyMiAxNToxMzo1NyAtMDYwMCBSb2JlcnQgSGFuY29jayB3cm90
ZToNCj4gPiBXZSBzaG91bGQgYmUgYXZvaWRpbmcgcmV0dXJuaW5nIE5FVERFVl9UWF9CVVNZIGZy
b20gbmRvX3N0YXJ0X3htaXQgaW4NCj4gPiBub3JtYWwgY2FzZXMuIE1vdmUgdGhlIG1haW4gY2hl
Y2sgZm9yIGEgZnVsbCBUWCByaW5nIHRvIHRoZSBlbmQgb2YgdGhlDQo+ID4gZnVuY3Rpb24gc28g
dGhhdCB3ZSBzdG9wIHRoZSBxdWV1ZSBhZnRlciB0aGUgbGFzdCBhdmFpbGFibGUgc3BhY2UgaXMg
dXNlZA0KPiA+IHVwLCBhbmQgb25seSB3YWtlIHVwIHRoZSBxdWV1ZSBpZiBlbm91Z2ggc3BhY2Ug
aXMgYXZhaWxhYmxlIGZvciBhIGZ1bGwNCj4gPiBtYXhpbWFsbHkgZnJhZ21lbnRlZCBwYWNrZXQu
IFByaW50IGEgd2FybmluZyBpZiB0aGVyZSBpcyBpbnN1ZmZpY2llbnQNCj4gPiBzcGFjZSBhdCB0
aGUgc3RhcnQgb2Ygc3RhcnRfeG1pdCwgc2luY2UgdGhpcyBzaG91bGQgbm8gbG9uZ2VyIGhhcHBl
bi4NCj4gPiANCj4gPiBGaXhlczogOGEzYjdhMjUyZGNhOSAoImRyaXZlcnMvbmV0L2V0aGVybmV0
L3hpbGlueDogYWRkZWQgWGlsaW54IEFYSQ0KPiA+IEV0aGVybmV0IGRyaXZlciIpDQo+ID4gU2ln
bmVkLW9mZi1ieTogUm9iZXJ0IEhhbmNvY2sgPHJvYmVydC5oYW5jb2NrQGNhbGlhbi5jb20+DQo+
IA0KPiBGZWVscyBhIGxpdHRsZSBtb3JlIGxpa2UgYW4gb3B0aW1pemF0aW9uIHRoYW4gc3RyaWN0
bHkgYSBmaXguDQo+IENhbiB3ZSBhcHBseSB0aGlzIGFuZCB0aGUgZm9sbG93aW5nIHBhdGNoIHRv
IG5ldC1uZXh0IGluIHR3bw0KPiB3ZWVrJ3MgdGltZT8gSXQncyBub3QgdG9vIG11Y2ggb2YgYSBz
dHJldGNoIHRvIHRha2UgaXQgaW4gbm93DQo+IGlmIGl0J3MgYSBiaXQgY29udmVuaWVuY2UgYnV0
IEkgZG9uJ3QgdGhpbmsgdGhlIEZpeGVzIHRhZ3Mgc2hvdWxkIA0KPiBzdGF5Lg0KDQpXZWxsIGl0
J3MgYSBmaXggaW4gdGhlIHNlbnNlIHRoYXQgaXQgY29tcGxpZXMgd2l0aCB3aGF0DQpEb2N1bWVu
dGF0aW9uL25ldHdvcmtpbmcvZHJpdmVyLnJzdCBzYXlzIGRyaXZlcnMgc2hvdWxkIGRvIC0gSSdt
IG5vdCB0b28NCmZhbWlsaWFyIHdpdGggdGhlIGNvbnNlcXVlbmNlcyBvZiBub3QgZG9pbmcgdGhh
dCBhcmUsIEkgZ3Vlc3MgbW9zdGx5DQpwZXJmb3JtYW5jZSBmcm9tIGhhdmluZyB0byByZXF1ZXVl
IHRoZSBwYWNrZXQ/DQoNCkZyb20gdGhhdCBzdGFuZHBvaW50LCBJIGd1ZXNzIHRoZSBjb25jZXJu
IHdpdGggYnJlYWtpbmcgdGhvc2UgdHdvIHBhdGNoZXMgb3V0DQppcyB0aGF0IHRoZSBwcmV2aW91
cyBwYXRjaGVzIGNhbiBpbnRyb2R1Y2UgYSBiaXQgb2YgYSBwZXJmb3JtYW5jZSBoaXQgKGJ5DQph
Y3R1YWxseSBjYXJpbmcgYWJvdXQgdGhlIHN0YXRlIG9mIHRoZSBUWCByaW5nIGluc3RlYWQgb2Yg
dHJhbXBsaW5nIG92ZXIgaXQgaW4NCnNvbWUgY2FzZXMpIGFuZCBzbyB3aXRob3V0IHRoZSBsYXN0
IHR3byB5b3UgbWlnaHQgZW5kIHVwIHdpdGggc29tZSBwZXJmb3JtYW5jZSANCnJlZ3Jlc3Npb24u
IFNvIEknZCBwcm9iYWJseSBwcmVmZXIgdG8ga2VlcCB0aGVtIHRvZ2V0aGVyIHdpdGggdGhlIHJl
c3Qgb2YgdGhlDQpwYXRjaCBzZXQuDQoNCj4gDQo+ID4gLQkJbmV0aWZfd2FrZV9xdWV1ZShuZGV2
KTsNCj4gPiArCQluZXRkZXZfd2FybihuZGV2LCAiVFggcmluZyB1bmV4cGVjdGVkbHkgZnVsbFxu
Iik7DQo+IA0KPiBQcm9iYWJseSB3aXNlIHRvIG1ha2UgdGhpcyBuZXRkZXZfd2Fybl9vbmNlKCkg
b3IgYXQgbGVhc3QgcmF0ZSBsaW1pdCBpdC4NCg0KTWlnaHQgd2FudCBpdCBtb3JlIHRoYW4gb25j
ZSAoc28geW91IGNhbiB0ZWxsIGlmIGl0IGlzIGEgb25lLW9mZiBvciBoYXBwZW5pbmcNCm1vcmUg
b2Z0ZW4pLCBidXQgSSBjYW4gcHV0IGluIGEgcmF0ZSBsaW1pdC4uDQoNCj4gDQo+ID4gKwkJcmV0
dXJuIE5FVERFVl9UWF9CVVNZOw0KPiA+ICAJfQ0KPiA+ICANCj4gPiAgCWlmIChza2ItPmlwX3N1
bW1lZCA9PSBDSEVDS1NVTV9QQVJUSUFMKSB7DQoNCi0tIA0KUm9iZXJ0IEhhbmNvY2sNClNlbmlv
ciBIYXJkd2FyZSBEZXNpZ25lciwgQ2FsaWFuIEFkdmFuY2VkIFRlY2hub2xvZ2llcw0Kd3d3LmNh
bGlhbi5jb20NCg==
