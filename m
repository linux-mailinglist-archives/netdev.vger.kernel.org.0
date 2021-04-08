Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8B33579A1
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 03:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230337AbhDHBop (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 21:44:45 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:18432 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229544AbhDHBon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Apr 2021 21:44:43 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1381ffHv017452;
        Wed, 7 Apr 2021 18:44:26 -0700
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by mx0b-0016f401.pphosted.com with ESMTP id 37rvbf54va-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 07 Apr 2021 18:44:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ahpl0WydyvyQiFMT3RhCWqNE+lMnA1064Nl7+QU23NA/PQw6m1dstsFM1M3WBN+dRONd6wXT7ZZAaZj0TmiLJjhiPgqf1aENtZnoVI4UacDV/+v3cfz3zvqkHdijo6Jj2g1exrhV+dKdakKsERnocOlKrjgeIVHbuhcQCmmt5Bq8uKx6U9LfiKZE8AgxKo+bvGet8xPlj8nNsBKHCLN0m/lYIEJzlr96ePl0ntUsffuWKJh5RLz1GnPXBmSlRZaw+Khyh0jOkADp7/Jm933pNNGer50P5kw0lAuOozfxE7YND8Wy8k8O+0lpT1qcqmT1pRluuJivM5mc3yPwBI6Vaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/l6OThnTvIMd55+RZzOkznugYd9AHlj5KRgWtfzOm4=;
 b=AjW4bA+RYPSplow47+cpIsSLZSKpj19FxAUPmDFQy60/QEXUYcOQVN6DIkJHFuZAx1RdOV0zHenYo4WJ5km7s/4y+lv78Z3zSt0JEfly3Ys2dVp+IMaQ4yVbMVYdCatxGYRDmvZDvGF0/pESGJ1m9vsaZvH8iD71DQ+kHS76diZj3OpIOFC9kc0BK7oXOI9rxOjAbLIha2uoqVidA41IYOmuHPqBvvx2olrxXsnPfPW1yI/ANAzrX88detCOz52zm2k11V59n9W6jHPEQj9w6GyVAyEPN25dIq72UlzLbkp6VfYxviv5zZyrFIGcHzcBcAMiqJ8UNQv7fuVUtl3F+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=marvell.com; dmarc=pass action=none header.from=marvell.com;
 dkim=pass header.d=marvell.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=marvell.onmicrosoft.com; s=selector1-marvell-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U/l6OThnTvIMd55+RZzOkznugYd9AHlj5KRgWtfzOm4=;
 b=OruEgHbqxU8d/PcRfvvBCYN0rrXPkPZqNkduRGxCAKtg6oCR3bOfEE8wXQ6OG9MI5Hn6JVAYvtWNFmaYc4xQoYyls93iKd9DNUuFkpZUx5FN535Pw/pFikfQXGoZx6DkIj7QFjUNZEUIhOJLeGrN/0o41o658OFkooLWZxZ5JYs=
Received: from PH0PR18MB4039.namprd18.prod.outlook.com (2603:10b6:510:2d::6)
 by PH0PR18MB3911.namprd18.prod.outlook.com (2603:10b6:510:29::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Thu, 8 Apr
 2021 01:44:24 +0000
Received: from PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::69d1:7a51:3445:ba7e]) by PH0PR18MB4039.namprd18.prod.outlook.com
 ([fe80::69d1:7a51:3445:ba7e%5]) with mapi id 15.20.3999.032; Thu, 8 Apr 2021
 01:44:24 +0000
From:   Sudarsana Reddy Kalluru <skalluru@marvell.com>
To:     Colin King <colin.king@canonical.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Eilon Greenstein <eilong@broadcom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [EXT] [PATCH] bnx2x: Fix potential infinite loop
Thread-Topic: [EXT] [PATCH] bnx2x: Fix potential infinite loop
Thread-Index: AQHXK7o7yGPWrLpTiEyYRZbthW9QfKqp2JJg
Date:   Thu, 8 Apr 2021 01:44:23 +0000
Message-ID: <PH0PR18MB403997479411C615A95E6E71D3749@PH0PR18MB4039.namprd18.prod.outlook.com>
References: <20210407142802.495539-1-colin.king@canonical.com>
In-Reply-To: <20210407142802.495539-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: canonical.com; dkim=none (message not signed)
 header.d=none;canonical.com; dmarc=none action=none header.from=marvell.com;
x-originating-ip: [2405:201:c000:6f30:9d2b:550c:e95:1cdb]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb5f5bd5-04ba-4d60-07d8-08d8fa2fd684
x-ms-traffictypediagnostic: PH0PR18MB3911:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR18MB3911C98FF32DEFCBB5B129C9D3749@PH0PR18MB3911.namprd18.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HgGCZew0jbZ9odtX2/ipiCq2o2wSU5SLewXrJm8GGO3v2SBJEIJj8lkRzs5chTneatnn842WcPw/fD6CCYERTwphnIXdIcPj74hu+Pd1HK8AR1j0Hh573VZBGgTeLHVlANXxdpA7Be5dDWel3ypWt5voeIJIJiYOEDSq9ITcxtwOB7lPWEQFSrWRWReD134Isb2z7jjEwC1hYva44RMBFSCqt1nEyGVNu0hqYlCPlupFWh2K0cCSHl9mUQp2hx6gPiK6LZukesO8bTPa1XrZ8cknwDRhRqhxYPueW0NvlczKWq27cmu16C4OUmU4T/MtNiaTyj7ZsCuiFp4Iv0aUL80kM8F0otNiWHnnHfqLj4FUJhg6moP1Ys2FepEiGS+tegTo2oR6qfxBTkj1p2LSSMuocYlfl+ekdgzNC5s9uOdovgHZ3Ye67jmWPkwyHmAnPsbAMkjvvIimchdB1uCeqlve6Vx/ZTnqBSJzs8LTN4sV9j1BKKYnUZOXnc0tQiirNaioqod0ag6VBB+PCZvfPJslivVFt2pHO32MoEy23VhdnJxcIyMfxJQ3dqEEMM27BqKq6DyjwJpKjSLMD2xBd24Bs1yDkFgudoURjMXcOi4OkL4RRjnSE2nelPyU/VR8dVzskdB05AOAl4yTSKJmQl/n/H1DzQ2yGCULLXzyfqo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR18MB4039.namprd18.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(66476007)(66556008)(86362001)(316002)(8676002)(9686003)(33656002)(38100700001)(52536014)(7696005)(478600001)(4326008)(186003)(76116006)(55016002)(66946007)(2906002)(110136005)(5660300002)(83380400001)(66446008)(53546011)(64756008)(8936002)(6506007)(71200400001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Zk5OZzlWWm1YZFJoMzRVbDBTYzRXNmE5czM3R3JPelAzV1liejB2NEJQUU1s?=
 =?utf-8?B?dGNFYnZEMVBIbHo5Q2V6M3UrQUN4cjFOK1RnZzM0aTNPS1NOdVk0WUFlcGRJ?=
 =?utf-8?B?b3M1U2NkWU1wQXU5UHhKczRYYUo2RUZRU1RTQTRvN0g0RTEyOFZpK3FhSlFZ?=
 =?utf-8?B?OUFUUkNUaGIwR1hKQ25pNy85R2ZVcHhjVk91aDRhWnZuczlmRkRiT2hCQWpv?=
 =?utf-8?B?Y1YwN2RWc0ZUU2RPeHhWR3QzWWdjazVLN1lBczAwOXhMOHJYTzIzOERRL09C?=
 =?utf-8?B?bjRjK1k3YUw1S2gzTmJFRXdWWkZ2RXh4UTNwRnJmUkJhV0NZQS9uakVnSy9E?=
 =?utf-8?B?QkV2bUtIQytmajN0a3hFaXpqQk01UlFkaDhjbWtqQ3FkTzN5bGJzTnQ3Rksy?=
 =?utf-8?B?aUpOcW5NaVNPZXJPei9xVE5Cdk9IMi9OWEJ1OUt0OVJsMkVHZU56U1o0aDRD?=
 =?utf-8?B?RnIyTEJkM0ZlU1hUZmlieG5YRHdENmRYMkNWa09FcDNyY0Z0MnJSQ1FEdVZz?=
 =?utf-8?B?RHFWemFoeTBrUzlqSWYwa1lMMFR5cnVvRnZBbHNZazJNSGg3TnBPTFJlVXlQ?=
 =?utf-8?B?OHRWWEJJck1SS2lkVG5STFgzNFFNQnFtN0ZCdm15ZlhEMDh2eWxwS2NlUCtJ?=
 =?utf-8?B?U2t1dWVXQjhvbmVMSUlZVk1admxEQU14c3pvNmNLeEU4dC9lOWh4VHBydTRH?=
 =?utf-8?B?N09sWWh4NVBpUThXdm9uYWlrM3ZqM0g2bjF3eVBEdEpCMHFQUGRmZFFZN3pE?=
 =?utf-8?B?MDJVdTlwWStWZ1l0cG5mRXdIcHZCcVlnMmlidlZJZFVwRmp1RWs4OG1EVDh3?=
 =?utf-8?B?a01oRUlGYW1jMFFucEQ0N1JheVcyVzFjK2RHNVBYcy95Ulg4WnpMV2hYaGNi?=
 =?utf-8?B?MGxER1dmOGxGa0lwWHBTTUM2cUVFVXRESENLL2dxZEVpQ1NwOEZNUkcrSk5j?=
 =?utf-8?B?WDNna0JhRlpyWWNRTE85ODRTamwwNG5zRHlyS1BxeEU1SGUzWWVTREVHMFBN?=
 =?utf-8?B?a0NLMW8vaGQ5UmQrM1V1dDZxUnNYUG11YTE3T1E2S2NmSWN4RWt3Tm1zNEJ1?=
 =?utf-8?B?R200QnNwcnhNT1JWWkdYWkdOeThOaFhQVzRIbUZaM3VOT2NQdGV6RDhDSjN0?=
 =?utf-8?B?MVJtRzFZeVlWazdWV0dlWExRYmd3T2Zuc2RpMkxndG1JcHFXUFRZNVBHVzhI?=
 =?utf-8?B?cDBwbjV0VDdlb21IZlJPdkxBNm1ERjN5UjBNczVhUCtNUldtVEl3MmY3MWxQ?=
 =?utf-8?B?cTRSSU1CVWhuVkp2cjB5a3dUSmFPWWxCcmxUNlNoSWpaRVJodGVqY2RSVmFM?=
 =?utf-8?B?NHlYakNrSzZjYStmVzZoOERReHlHVSthSStGWWRzQVdkN3FpQk9jN3pGZnZO?=
 =?utf-8?B?VzQ0MWpKUkI1QXl2SERKb3BMQlVkYVk1aENKSEJ4eVRGZytBUVdGaG50YVRa?=
 =?utf-8?B?cmJQT3RvU285dDhPREdRYWRUdU1YVEdZbTdUT213VW1XMDd4MElDV3QzSmJl?=
 =?utf-8?B?Rlltd2YvSmd2WjdjWGpVTFpHeVdlSURKdlJJTHIvbS9mU2xXZ0RGaXdUaEdh?=
 =?utf-8?B?OWZEcytmZzA0aHQ5eTZ1YmE4Zm1TSHltMzdINXFNSWJ6OWN0aGtpaVBYQUN0?=
 =?utf-8?B?UEhGR05xSERUaDdDWW0wc21IL3FleEJEUVZjaWpRME5UV1dGY3JCNG82TCtN?=
 =?utf-8?B?MHpBZnRwT1lJUVZxWStVaDZ1QUVsWU92R0ZqMXpOSXlTR3YvK0NNYkJScHM0?=
 =?utf-8?B?U05kVU45blM2RE8zYTc0SG52ZzQrcTFZMzFmQmZ5N3RtTkZ0a3I5U2ZFWmhp?=
 =?utf-8?B?TXpkMlBPMUlISTB2L3lvWHE0TFdTcS9MallVWE04NXBNdGhXUVRINEczdzVI?=
 =?utf-8?Q?UNZPPvSNRgFKS?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: marvell.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR18MB4039.namprd18.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb5f5bd5-04ba-4d60-07d8-08d8fa2fd684
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Apr 2021 01:44:24.1034
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 70e1fb47-1155-421d-87fc-2e58f638b6e0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QwX5thBW+75KAXi92UZgI1av5wPx95H0W7LLCPKAlhzSxBEV0ht0CjtVZsRoAXBvclNgUqUG1djLd+ASlKitcw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR18MB3911
X-Proofpoint-ORIG-GUID: cAGKwt6QaMlbcmV6jCJZrHhlKDGBeAMf
X-Proofpoint-GUID: cAGKwt6QaMlbcmV6jCJZrHhlKDGBeAMf
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.391,18.0.761
 definitions=2021-04-07_11:2021-04-07,2021-04-07 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IENvbGluIEtpbmcgPGNvbGlu
LmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gU2VudDogV2VkbmVzZGF5LCBBcHJpbCA3LCAyMDIxIDc6
NTggUE0NCj4gVG86IEFyaWVsIEVsaW9yIDxhZWxpb3JAbWFydmVsbC5jb20+OyBTdWRhcnNhbmEg
UmVkZHkgS2FsbHVydQ0KPiA8c2thbGx1cnVAbWFydmVsbC5jb20+OyBHUi1ldmVyZXN0LWxpbnV4
LWwyIDxHUi1ldmVyZXN0LWxpbnV4LQ0KPiBsMkBtYXJ2ZWxsLmNvbT47IERhdmlkIFMgLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraQ0KPiA8a3ViYUBrZXJuZWwu
b3JnPjsgRWlsb24gR3JlZW5zdGVpbiA8ZWlsb25nQGJyb2FkY29tLmNvbT47DQo+IG5ldGRldkB2
Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IGtlcm5lbC1qYW5pdG9yc0B2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogW0VYVF0gW1BBVENIXSBibngy
eDogRml4IHBvdGVudGlhbCBpbmZpbml0ZSBsb29wDQo+IA0KPiBFeHRlcm5hbCBFbWFpbA0KPiAN
Cj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tLQ0KPiBGcm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5v
bmljYWwuY29tPg0KPiANCj4gVGhlIGZvcl9lYWNoX3R4X3F1ZXVlIGxvb3AgaXRlcmF0ZXMgd2l0
aCBhIHU4IGxvb3AgY291bnRlciBpIGFuZCBjb21wYXJlcw0KPiB0aGlzIHdpdGggdGhlIGxvb3Ag
dXBwZXIgbGltaXQgb2YgYnAtPm51bV9xdWV1ZXMgdGhhdCBpcyBhbiBpbnQgdHlwZS4gIFRoZXJl
DQo+IGlzIGEgcG90ZW50aWFsIGluZmluaXRlIGxvb3AgaWYgYnAtPm51bV9xdWV1ZXMgaXMgbGFy
Z2VyIHRoYW4gdGhlIHU4IGxvb3ANCj4gY291bnRlci4gRml4IHRoaXMgYnkgbWFraW5nIHRoZSBs
b29wIGNvdW50ZXIgdGhlIHNhbWUgdHlwZSBhcyBicC0NCj4gPm51bV9xdWV1ZXMuDQo+IA0KPiBB
ZGRyZXNzZXMtQ292ZXJpdHk6ICgiSW5maW5pdGUgbG9vcCIpDQo+IEZpeGVzOiBhZDVhZmM4OTM2
NWUgKCJibngyeDogU2VwYXJhdGUgVkYgYW5kIFBGIGxvZ2ljIikNCj4gU2lnbmVkLW9mZi1ieTog
Q29saW4gSWFuIEtpbmcgPGNvbGluLmtpbmdAY2Fub25pY2FsLmNvbT4NCj4gLS0tDQo+ICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyeC9ibngyeF9jbW4uYyB8IDMgKystDQo+ICAx
IGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfY21uLmMN
Cj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9icm9hZGNvbS9ibngyeC9ibngyeF9jbW4uYw0KPiBp
bmRleCAxYTZlYzFhMTJkNTMuLmVkZmJlYjcxMGFkNCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfY21uLmMNCj4gKysrIGIvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvYnJvYWRjb20vYm54MngvYm54MnhfY21uLmMNCj4gQEAgLTI5NTksNyArMjk1
OSw4IEBAIGludCBibngyeF9uaWNfbG9hZChzdHJ1Y3QgYm54MnggKmJwLCBpbnQNCj4gbG9hZF9t
b2RlKQ0KPiANCj4gIGludCBibngyeF9kcmFpbl90eF9xdWV1ZXMoc3RydWN0IGJueDJ4ICpicCkg
IHsNCj4gLQl1OCByYyA9IDAsIGNvcywgaTsNCj4gKwl1OCByYyA9IDAsIGNvczsNCj4gKwlpbnQg
aTsNCj4gDQo+ICAJLyogV2FpdCB1bnRpbCB0eCBmYXN0cGF0aCB0YXNrcyBjb21wbGV0ZSAqLw0K
PiAgCWZvcl9lYWNoX3R4X3F1ZXVlKGJwLCBpKSB7DQo+IC0tDQo+IDIuMzAuMg0KDQpUaGFua3Mg
Zm9yIHRoZSBjaGFuZ2UuIFtqdXN0IGZvciB0aGUgaW5mbywgdGhlb3JldGljYWwgbWF4IG51bV9x
dWV1ZXMgdmFsdWUgZm9yIGJueDJ4IGRldmljZSBpcyAzM10NCg0KQWNrZWQtYnk6IFN1ZGFyc2Fu
YSBSZWRkeSBLYWxsdXJ1IDxza2FsbHVydUBtYXJ2ZWxsLmNvbT4NCg==
