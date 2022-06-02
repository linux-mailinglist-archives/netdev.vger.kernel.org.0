Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B1ED53BC7C
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 18:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237063AbiFBQ00 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 12:26:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237058AbiFBQ0W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 12:26:22 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2075.outbound.protection.outlook.com [40.107.92.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E79B2B12C9;
        Thu,  2 Jun 2022 09:26:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OsNk11r8m8V7FzsgytS6g0iw/24UFKMz9mnKSt72jpSZrhHJeNajxfw2VqCZg1TpLfPrOEpOu2ahtCxwOad+hSeyzJZ1R713QT08LFHNZ6RZlwflzqbe7vuT6mTMd//OEconUI5r6tx+pQuz72Qw+jgxzvB134jPopuJynKqEEHVjTsT2p1QlOA/zuRljkkhArRjGPQDuehUF0MArMPsYyjp+rb82sY7r7OFM6ZWrWAEuwN/cA39PxzC0/fheWYWwERYtS31WhgEB5cKjPKn9UtCG4WQMCZ+WHSwWNWALvz/tATveD1JYXHLsm/lm/OavRSdAYjYPJpSTZ9YQbbhbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=X2SdwJk612D8X6QCrtih8ftnTj75a1QSvSwK+i3nf4c=;
 b=Bin+nUTprK/zG+2EqzuU9oWBj1xZ/2il8Xk23/r02XyCXynIZh/igqlP9i3Kk95xy0kWpPmIx64EagD1FTv7X02mXkpBDfFrUTiEHfth9t75KG0C0SZtOBgfAxLLWWJTRad25gSnol6afM49mpRvH5MR6Rhfn/OirWyADZ4eVtT/vjgtTHjq3JrG/Rba3DKging3MHsUJdDcHBeM29tV+AAJeHpkgqtAZg2F7VkRa7bNuMEmaUNFUxCDzdxy/VvBVl6tZze2KNnDWfJZ6FBpIoAzQHnYxXyyXwyScnbfOwk4v7MXblcyQmZ5gCURlMxbCjrGEyTpmpkTFfloYRyUtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=X2SdwJk612D8X6QCrtih8ftnTj75a1QSvSwK+i3nf4c=;
 b=SmOACSil8h/tmQRTSon4/yBmCrdHiczJZnZixMSHkfZSFGvFngoyAVIRaDfxmHsWO0dq8nwOi/xnVN31dz9YR3Ny2C6ThdTKBxm/px1yIE0Q0BNGrqPPiozLKwdxFidb2sZ8tAw+w/vcAigPj12XVmUh1iWE5L5b28j07EUvtPQ=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by BN7PR10MB2611.namprd10.prod.outlook.com (2603:10b6:406:c7::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5314.13; Thu, 2 Jun
 2022 16:26:18 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::84d6:8aea:981:91e5%5]) with mapi id 15.20.5314.013; Thu, 2 Jun 2022
 16:26:18 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "stephen@networkplumber.org" <stephen@networkplumber.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net-sysfs: allow changing sysfs carrier when interface is
 down
Thread-Topic: [PATCH] net-sysfs: allow changing sysfs carrier when interface
 is down
Thread-Index: AQHYdhitF3sF8MdKyEyE/FAADx5cL607THmAgACL6YCAAG4kgIAACD8A
Date:   Thu, 2 Jun 2022 16:26:18 +0000
Message-ID: <b4b1b8519ef9bfef0d09aeea7ab8f89e531130c8.camel@infinera.com>
References: <20220602003523.19530-1-joakim.tjernlund@infinera.com>
         <20220601180147.40a6e8ea@kernel.org>
         <4b700cbc93bc087115c1e400449bdff48c37298d.camel@infinera.com>
         <20220602085645.5ecff73f@hermes.local>
In-Reply-To: <20220602085645.5ecff73f@hermes.local>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.0 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 600a38a7-ec7a-4e93-0767-08da44b49f4f
x-ms-traffictypediagnostic: BN7PR10MB2611:EE_
x-microsoft-antispam-prvs: <BN7PR10MB26114AC86E326024A1309D07F4DE9@BN7PR10MB2611.namprd10.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YR1Ze2t/ZqtEP1V00wl283B0L2E5OPBs8dkOXJa/5U1KAqdJ9meele+ZYbXfeOoa7YbeKujniEWILxupDBvtlQB3qRiQBXwpvkwzbYpWGNW6HyTSOApBNmyeFeJEGvsXu7JGEYuwz8fNuoQsOhDUrflPGl+mdHmKIbgN4Fxi038C+w4fAcvWeLLngz07hulkswmD7LhdpD0H1U6ydcuBEC6LzRVzwPPbPT1KpAlFZl40DpqbP4S3iaubDwOO+qhEhIF+1nPOEgRryxw5rMGPfBgpOQfHbx89NjFbkoxfUZn/wN9yI4CrvAYa7D4G0oJP3mFJWsCg58B6oDlT8caZhfBc6popi3DU8uZ8VGbtj3vssusP2wPSat+SV1T8S03TQ6VWVbSyToqh4s0dut63IeLtG/dzT7HXqsa1fOsC1usRMPD3iwVto14P3Xr3U62GPy1taMDj0CZp6hMcKOgndO8jEzfpHWLiUDr6xPH459eGUz7x2wxGaZoPVbttTJYpogSISqMwS3H6pf+rwhCoipu6Z6NEVyhAgscwJbFaTYTOd6v5GoeUpTj3SekjEsPfBMCZhPPGy9DnwNNIKSPrYYjMpaWo10VdV4lwfkvz3YLi299m3WsoN/TOkCoMAywhz0RyXadkvvo6EmChArpwGHx/QahAK8gVvLmmngbHT0PkabjaPMPqYodK6ZDhlsAq7qmcbC4scK+d+bZ5De6xoQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(4326008)(36756003)(8676002)(66476007)(64756008)(66556008)(71200400001)(66946007)(38070700005)(316002)(66446008)(91956017)(54906003)(6916009)(83380400001)(26005)(38100700002)(186003)(2906002)(8936002)(86362001)(6486002)(2616005)(6506007)(508600001)(5660300002)(122000001)(6512007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SzhZNW0wMitkdmJNajlyaUFMUUhLQ0ptR1hZQ2FXMGZwREcrWXpJU0Y3eXNY?=
 =?utf-8?B?WGFyRHc1U1I0TWF6OU5TQ1ErMVcwS1hpNlllTzZYZWNsVm5SUDIrVElxbzl3?=
 =?utf-8?B?RXM5aVMrQzdFcWc3Sjl3cS9xWVQ0TndqeFZuQmZ0NHRFNkt2ZURpeWdpTnBs?=
 =?utf-8?B?SjFISUFiMkhJM1FLODFwVlJGUkFRZ1F4anQwVlh6d0JsYTFnRnh5OHlKeFlH?=
 =?utf-8?B?S0pJWUJsYUM0Y1pTSGNjSzZ4SFEwM2wxeC96Qy9JeDV0bFcyemc1SDhUR2sz?=
 =?utf-8?B?TlBSU1d0b0dhWUZWQmtjblFPcFRwTnREQ1hGRXpzSGVZaUJ3K0pOUE9TaTEv?=
 =?utf-8?B?cHZ1UUYrejNaN0xETnJWWEJNcE9jUFpJZ210UlJUbW4rMGo2ZUd5MXl6cEd1?=
 =?utf-8?B?cENaMUtiSWgrK3VIbGlqTmV2dGJZMkFaaVhrQkdRT0I4Y0NVL1ZhSnpFcmFk?=
 =?utf-8?B?RGxRZmlPMGpwZXhIdkFsQW1tUllMZXB4N1IrbllOQjd3cit6QlI3aTVEU2do?=
 =?utf-8?B?S3BTSzlqaS81UC9yaVNCVGNqQnZnUHpLTzJGS3dvczgvV2xaRGtZVXZtb1NO?=
 =?utf-8?B?ZlRsVDM4cmpsN1VyUmMzaGs0M0NRZ1RoWEpFVFVvb1IxN0g5TkRpd1VXY1gr?=
 =?utf-8?B?SUpDSmdFTXJJZ1FUcEZzSlNnUTVwUjBleFkvZlhmbDRGWlVYSVFsa2szTGY5?=
 =?utf-8?B?M2E2b3ZLZHQyOEtkZ2NBanhDcXpGd2VOVjNhT2hEY2FLQXpRV2doZFEyVVk3?=
 =?utf-8?B?dWozT0pVcDJFcG56em9tOGZXRkFiVFpTb1RGNUZ4eFYvQ1NQVlVkcmlVZzFQ?=
 =?utf-8?B?eVdoaFlBNURsT2Qrc2pkcUpEcFU1TDRJM0cyLzVUV2Z6bEFMZ2hBZkxKbEV2?=
 =?utf-8?B?TEtaZEQ0Znl1anNycHphbVRFY0JvL2xsYngwVWtjUFlFVTYySVhpZHNBVGM2?=
 =?utf-8?B?YjZPc0xwM0RwSGJ6VThoVkIyeDErNklxUndHSm1oN0ZFNWhSUVY1SDNoU3RF?=
 =?utf-8?B?Y0dTKzhRVHkxd2JlQ3ZRNWNoaUo3cFpwcXhhV0xnaHpJOHp3MTk5d01XbVNh?=
 =?utf-8?B?cGRiOTBXRDh5cWU0OGVzWlcrb2NBNEVOanV0c3dhYXczVHVleUlLbXZZRFhZ?=
 =?utf-8?B?UkNZRXdaL043NmlPd0lub3d2ZjZiMXNZUnpVb1FYNjQyUjVyYmNFQU9NQllx?=
 =?utf-8?B?ZGtZRTdqNC93L3RTc21vVE96SHBWcFM3cUdSSFFGNDVRNXVUaENuMmxHUm45?=
 =?utf-8?B?SWs3RW9iT0thYU9pZFVYVzNQR0NubDFPa3IvRmlQVDFOVHpBQmNmZEN3endS?=
 =?utf-8?B?cXBpSnM5YTlSdUZLMU1kMUkwbnVjNmNFcElpUi90c0VZSmRVcVBzbjhMYi9X?=
 =?utf-8?B?aEpreDZ3NGRHa05ZMEpJZ3Q0Mnc2dUsxQkppNWpSUWNxbGdOV0FNTVNaSzdx?=
 =?utf-8?B?Uy8vVnhyZUtMZU1DZWEzQ3FVcGdVYU5rTEpCZG9aTWp5cHlmU3BXL1dqOVVx?=
 =?utf-8?B?dEJOcTZnQ0NVc0RMQmtCU0FZV1NWYjNLQkdUcWxqMzNkR1dDaW5EdUVpQy8r?=
 =?utf-8?B?SUtMWkc0YlZvNVlaZGR6RTRxelNCL25Xc0RCUlgvbjBIdFBUMnRnb1NrY0Z3?=
 =?utf-8?B?RGEzZGYySFFrSnJYdFpZZVRJdVRPTndOYTBaa3kyaCsrbVM3Z2hiK205L0lp?=
 =?utf-8?B?d3JBOVlHb29yWUx2aVM1YUFlQ21kZnJTNytiUHR2UHFBZXZpeHBCWWV1a3Rw?=
 =?utf-8?B?OGV5QWZkWXRYejBZQjNua3RRMFBFVDlJZUlkUWI0OGJkSjgzMEVVS2ZlMXl6?=
 =?utf-8?B?NDFoLzh3RlcydDNXejRuRGRUSm1iZnNkVXF5QWV5bmFyem0rUEZ2SHN6aGs3?=
 =?utf-8?B?MzFoSHp2RWtLdmJ2bzUyZTRxQXlIajVwSGNCYWdQbFpJNUxORmhBYWN6YlRF?=
 =?utf-8?B?TjAyWW9NUVJoRDJmVDNOdXpIVmM1R1c0N2NHOVpyVkV3Tk1EYWxoU05VUVFJ?=
 =?utf-8?B?U1FKWmVzYVJJOTZpa0UrNmI3NUdkaFM0VXkySFAyWUM1eDlWMVljb1ZMK3E0?=
 =?utf-8?B?bFZON2txVk9Ock5qc2l2dkkyNlRxS2JNL0hDOEVwa1N4akF1b2NEWUhkbWFB?=
 =?utf-8?B?azI0SDZhYk4rbjVXNzROUXNYS1M1cXdsWTZXRHNFc1hxREN0ZDR2UitBaVNn?=
 =?utf-8?B?b3V3ZDFUdmtYTUNNSlhOeVNwNnZzd0pGSDduZm00UzJUWS9hT1hQY09xT1lt?=
 =?utf-8?B?alIrS2lxTEpSQ1Q2NnhFR3R3N2F2T1Jub3U2RDNnMUp4a3Q2VnVPMUd2TEJ4?=
 =?utf-8?B?SmhKb0xtd1N0MllSZkRKcmtLekNpUXRKRXJHTmt1QWIxNTdCYk83dnFPcCtO?=
 =?utf-8?Q?xGPufUCGe4mAFGvU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DC660A9A9B2BD14CB4B8B89BBBF38015@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 600a38a7-ec7a-4e93-0767-08da44b49f4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2022 16:26:18.3592
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tBaKjsdbvUw+IGxbzOIVg3/N/uJ5w0eSfzcqHVbLxf0xQKaqm+nJ4E4Qj84lPYwTmdHBcFi2vSDB3Wk+1DGkPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR10MB2611
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA2LTAyIGF0IDA4OjU2IC0wNzAwLCBTdGVwaGVuIEhlbW1pbmdlciB3cm90
ZToNCj4gT24gVGh1LCAyIEp1biAyMDIyIDA5OjIyOjM0ICswMDAwDQo+IEpvYWtpbSBUamVybmx1
bmQgPEpvYWtpbS5UamVybmx1bmRAaW5maW5lcmEuY29tPiB3cm90ZToNCj4gDQo+ID4gT24gV2Vk
LCAyMDIyLTA2LTAxIGF0IDE4OjAxIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4gPiA+
IE9uIFRodSwgMiBKdW4gMjAyMiAwMjozNToyMyArMDIwMCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
OiAgDQo+ID4gPiA+IFVQL0RPV04gYW5kIGNhcnJpZXIgYXJlIGFzeW5jIGV2ZW50cyBhbmQgaXQg
bWFrZXMgc2Vuc2Ugb25lIGNhbg0KPiA+ID4gPiBhZGp1c3QgY2FycmllciBpbiBzeXNmcyBiZWZv
cmUgYnJpbmdpbmcgdGhlIGludGVyZmFjZSB1cC4gIA0KPiA+ID4gDQo+ID4gPiBDYW4geW91IGV4
cGxhaW4geW91ciB1c2UgY2FzZT8gIA0KPiA+IA0KPiA+IFN1cmUsIG91ciBIVyBoYXMgY29uZmln
L3N0YXRlIGNoYW5nZXMgdGhhdCBtYWtlcyBpdCBpbXBvc3NpYmxlIGZvciBuZXQgZHJpdmVyDQo+
ID4gdG8gdG91Y2ggYW5kIHJlZ2lzdGVycyBvciBUWCBwa2dzKGNhbiByZXN1bHQgaW4gU3lzdGVt
IEVycm9yIGV4Y2VwdGlvbiBpbiB3b3JzdCBjYXNlLg0KPiA+IA0KPiA+IFNvIHRoZSB1c2VyIHNw
YWNlIGFwcCBoYW5kbGluZ3MgdGhpcyBuZWVkcyB0byBtYWtlIHN1cmUgdGhhdCBldmVuIGlmIHNh
eSBkY2hwDQo+ID4gYnJpbmdzIGFuIEkvRiB1cCwgdGhlcmUgY2FuIGJlIG5vIEhXIGFjY2VzcyBi
eSB0aGUgZHJpdmVyLg0KPiA+IFRvIGRvIHRoYXQsIGNhcnJpZXIgbmVlZHMgdG8gYmUgY29udHJv
bGxlZCBiZWZvcmUgSS9GIGlzIGJyb3VnaHQgdXAuDQo+ID4gDQo+ID4gQ2FycmllciByZWZsZWN0
cyBhY3R1YWwgbGluayBzdGF0dXMgYW5kIHRoaXMga2FuIGNoYW5nZSBhdCBhbnkgdGltZS4gSSBo
b25lc3RseQ0KPiA+IGRvbid0IHVuZGVyc3RhbmQgd2h5IHlvdSB3b3VsZCBwcmV2ZW50IHN5c2Zz
IGFjY2VzcyB0byBjYXJyaWVyIGp1c3QNCj4gPiBiZWNhdXNlIEkvRiBpcyBkb3duPyANCj4gPiAN
Cj4gPiA+ICAgDQo+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IEpvYWtpbSBUamVybmx1bmQgPGpvYWtp
bS50amVybmx1bmRAaW5maW5lcmEuY29tPg0KPiA+ID4gPiBDYzogc3RhYmxlQHZnZXIua2VybmVs
Lm9yZyAgDQo+ID4gPiANCj4gPiA+IFNlZW1zIGEgbGl0dGxlIHRvbyByaXNreSBvZiBhIGNoYW5n
ZSB0byBwdXNoIGludG8gc3RhYmxlLiAgDQo+ID4gDQo+ID4gVGhlIGNoYW5nZSBpcyBtaW5pbWFs
IGFuZCBvbmx5IGFsbG93cyBhY2Nlc3MgdG8gY2FycmllciB3aGVuIEkvRiBpcyBhbHNvIGRvd24u
DQo+ID4gSSB0aGluayB0aGlzIGlzIGEga2VybmVsIGJ1ZyBhbmQgc2hvdWxkIGdvIHRvIHN0YWJs
ZSB0b28uDQo+ID4gDQo+IA0KPiBGb3IgbWFueSBkZXZpY2VzIHdoZW4gZGV2aWNlIGlzIGRvd24s
IHRoZSBwaHkgaXMgdHVybmVkIG9mZiBzbyB0aGUNCj4gc3RhdGUgb2YgY2FycmllciBpcyBlaXRo
ZXIgYWx3YXlzIGRvd24gb3IgdW5kZWZpbmVkLg0KPiANCj4gVGhhdCBpcyB3aHkgdGhlIGNvZGUg
aGFkIHRoZSBjaGVjayBvcmlnaW5hbGx5Lg0KPiANCg0KTWF5YmUgc28gYnV0IGl0IHNlZW1zIHRv
IG1lIHRoYXQgdGhpcyBsaW1pdGF0aW9uIHdhcyBwdXQgaW4gcGxhY2Ugd2l0aG91dCBtdWNoIHRo
b3VnaHQuDQpIZXJlIGFuIGFwcCB0YWtlcyBvbiB0aGUgcm9sZSB0byBtYW5hZ2UgY2FycmllciBm
b3IgdGhhdCBkZXZpY2UgYW5kIHRoZSBhcHAgc2hvdWxkIGJlIGZyZWUNCnRvIG1hbmFnZSB0aGUg
Y2FycmllciBhcyBpdCBzZWUgYmVzdC4NCg0KQXJlIHRoZXJlIHNvbWUgdXNlIGNhc2VzIHRoYXQg
bXVzdCBkZW55IHN5c2ZzIGNhcnJpZXIgYWNjZXNzIHRvIGl0cyBvd24gY2Fycmllcj8gDQoNCiBK
b2NrZQ0KDQo=
