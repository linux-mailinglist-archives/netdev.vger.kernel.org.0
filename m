Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF4D64B517
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 13:23:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235645AbiLMMXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 07:23:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235565AbiLMMXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 07:23:44 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2115.outbound.protection.outlook.com [40.107.7.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15FAD1AA27;
        Tue, 13 Dec 2022 04:23:43 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EQryEoR773s+W0lpWnhnnZI55YcQ9rlEQNmveBWZ/xl6/3znh9I5Kl3vhsyNB//nay9tYyXLZ8yFwb4ER2qrjxwUJjB8m/cIuE0YQWd8pSDUMEN68/dBuLD314J6QfOe1QZzpcVeL4HGY6uzMbm7NUpEg1Az+EWNgUWeicV//vPq/baU3nVaRIxkSG5feGOifv08NO3EESe2tGDRHMYBUwAHfsCHrVho+6o0a+Ed7jr74r6MtnMzeA5orYzWlAcfJvlq0prIU5LzuDLsbGo/u5Uf/h3WlbtAU/Ju2aTHYmTGICGqsCqE8OPBppyn4tApWo3c5gqDBRIymO9j6JypSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sUsU4zINsUlcT6fcx8JtbhQIgliyAPESh/ysgDrmqWc=;
 b=OmoGGOE82J53AbiN3pd2N3BD2IzAaPGMnqTBb7gLmeaDn9VVXqeha2dbaO9qUqFmtd2cZWEgq8iLC0WPEf+MYNQKYolR99lbx1WnKYgcVUB/MgQHNVGrLmgLrb9i/SmDhMc66hiMXf9JY9ojztfmZN97qge5DtdM/KcqyvCQiu3fOhGWs1a+1uAmUiiecK8/tKHG/oJfH/0Ntwyk3dsNP4PNBYn1CEyVqOpDYTh/anc83Zus0KKGViqcnQLCQO6fB7gRozcoaich2UWtC4Ir0C4S2RmPkt8KYsEqxZytfYP/LTS2s54aFv4l4+Ey2uzYvUqx+Lms0Kl9Gg4ERY82vA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sUsU4zINsUlcT6fcx8JtbhQIgliyAPESh/ysgDrmqWc=;
 b=A2jli7RNkM3e62CpqbHtKiZE3nDzfkSI7fIOwqJ+oAE9xB3tkVuBzu/s1Flx6ZWcQGsZ8vKmyrQUxtaEenufOTY9Vm0R6zC+N+ncPGicgORZ4uyVM9uNkte70wYrPtLTUdHC156HKwACswDhMfh8/O+bIhdylAV2n+KdEyvCjrs=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by PAWP189MB2526.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:35e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.10; Tue, 13 Dec
 2022 12:23:40 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::8f70:435b:ab64:9420%3]) with mapi id 15.20.5924.010; Tue, 13 Dec 2022
 12:23:40 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: RE: [PATCH] netfilter: conntrack: document sctp timeouts
Thread-Topic: [PATCH] netfilter: conntrack: document sctp timeouts
Thread-Index: AQHZDhXfdB18zsUsOU+kgPNUQgQV665rr1AAgAAPeTA=
Date:   Tue, 13 Dec 2022 12:23:40 +0000
Message-ID: <DBBP189MB1433EA2F233FDADA5A94D80595E39@DBBP189MB1433.EURP189.PROD.OUTLOOK.COM>
References: <20221212100705.12073-1-sriram.yagnaraman@est.tech>
 <Y5hhZEkz3nxlbVX7@salvia>
In-Reply-To: <Y5hhZEkz3nxlbVX7@salvia>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|PAWP189MB2526:EE_
x-ms-office365-filtering-correlation-id: a96e6ebd-3d74-4b0e-0314-08dadd04de25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iih+3SzHULhCMyq7O7bgvolH7YobWzWbY0B508FWIiwj5HfEOc1s/R+sXidnAGuE9MWsYHLxTHr63KKYNPefIYy/KPtwAoJPDuyiboLSiDB07Frb0n7dsWi8CyaXiLhCltiNjK9Y9C7hfSMMkWvjeXz6gIlnyI9h9H99ael2RES0j+SNYumfSyitblvSntnMFtz2VzNDI3itiGUBc6pAVD95pV1lPipf/HeEWTDbP5N1yI15E7kCQMH/z+HAOtXEQYIWoX8cQEP1qKbU1sOpvHikbbw3xLzoMCxsxflReDTPeJFXvWFFRLTHM8JMDgem8INdpTAqpXGN5ddWI9UyuBLsM1B4Npf9cuHVG55jyUuxMsq1MyHm+vPVMO3xizZfFf4sHwnKOJ3mU7pAag9x7GIm2J17FQFGQjCaNuZEuhUe85Z55SjugVNxf/mionUwKTFrw+0oAkmLBDwuQgbV/PU066qBie+OHfwkH2nXhb8ZHSBRz54z09JQLFPTXC0MtbfNwVA7cY5BFAgrSJsRME640d00rV/Ov+RWD4AJfRKEDK8sz4gGBgudHt1NzGhFr8tnTCj1Ypt+To3e45ywP8e+PPDrAh4cVW+UhjBfF+A+ytPfb0oxnCkivB3tLPaVJTucMttwWtm/aKNdVjdULVG94o1TuzqLHsf/x+sHlKeHjv+Yyxxj49vKhMZ5Ev3q
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(396003)(366004)(136003)(346002)(39830400003)(376002)(451199015)(122000001)(38100700002)(83380400001)(33656002)(38070700005)(86362001)(5660300002)(44832011)(2906002)(8936002)(64756008)(66446008)(4744005)(8676002)(66556008)(4326008)(66946007)(66476007)(41300700001)(52536014)(55016003)(76116006)(186003)(6506007)(53546011)(9686003)(26005)(7696005)(316002)(54906003)(6916009)(478600001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmtlVS9vTlZZRS8zVExQTjJWSWtvenBXUkdmV0EyWjRRSkhkcW53cFIrT0pH?=
 =?utf-8?B?SHdzWnFDMXMwTW1jTDVzUHJ3djNySWE1b0NwMk9pVE1kVWk0SElZVjU1b1ZE?=
 =?utf-8?B?Kzc2Y1BSZmRZNEV6VzJORnFyOGFGTklvMUk4UmJjYisvMmdKN0hFa0ljdFFl?=
 =?utf-8?B?aTVudWg0UWVYWkVEdWVJNk5vQ3VBSWtiWkZFRGgreVVHWDlYMmhLaXpBRCtt?=
 =?utf-8?B?SVN3WlBqWE0wSUlVTThVWkJ6TFRLWWZETFV6TUM3NzBaTWNvNXRCWEpNVkxM?=
 =?utf-8?B?TEJwWkVOQ0tOTUE1ckVZY09YeTRMWTN2UFFyNjVDSVg3V3Y4UXZ1ZzNRVkNQ?=
 =?utf-8?B?aHBMOUh1RjlTNFUvYXp5K2dZc2RYYzRLR2FGSGJ4K0VZemNXeHZnenFacGsx?=
 =?utf-8?B?eDRwakF5Szg5M1FzQzJlaU8vSC83bzFjWHg5YjBaT3JSZ0o2K0wxVHp1WWYx?=
 =?utf-8?B?WlRURUg4TmhTTlBON0J2V1dMOXhrZ2JYTjA2Q3FheXlOaEkyanNKR25Qb0pz?=
 =?utf-8?B?eTVka25ZQkFHVTdvaXpaTm5YMm54SVVWSlplbGgrTDJDR1lRU3BCTjZZMHNJ?=
 =?utf-8?B?THNCRXZTaHB6ZFZsSUpHb0pYR1hSRWhsTFZKTnlyR3VTK3hQWVg5UHUzL1Qr?=
 =?utf-8?B?aVVXc3RLNldTVlRhNVdTblNiY2dUUngrNjh4M1FUdTIvVGE5UTA0bk53S0Vp?=
 =?utf-8?B?RUZkWnhlc2hjV1VadlJQbVV5WUlpbjM1ZjBSQ243cmdpZ0xVQ1B5ck9Yb296?=
 =?utf-8?B?b2NZTzBQYmNQaWNJZncvUk9HcXJFZEhqOEtNVDJvZE5UUU92QnJYYVhMTHhK?=
 =?utf-8?B?b3ZvQTYzREdMUUh3Qkx2V1dqMGJZbUcrYXJWcXBtbGdMZ0JoWVNnSHRCcmVG?=
 =?utf-8?B?cWZpeWEzMm9hd2dxUXV0RzJSQklma0I0a0pHSXcvNndBQ3JUak1tZTRmZG52?=
 =?utf-8?B?RjJkcDBPaC9rM2lBOUs3OC80dWJuaG1jano1YUh1SE5oaVBsM3ZEYXdWK2hl?=
 =?utf-8?B?aG9UUGJsQmpkbDIyVEp6MFQrbzFsT21Tb0NQdjVaMGFzNmVQNjhSakNEOFNh?=
 =?utf-8?B?UmR4UzZ5NTg1eUxZYk84dU1TVGpNWk1oeXRnOHkzdm1xWWdkQ1ZUVTdjYVJE?=
 =?utf-8?B?aXQwREtHVDVjMS95RDhhRTJYT1BEMDdVTWNTMmhSdWFLV0F6VGhYZXQ2eTJ5?=
 =?utf-8?B?T2ZXK2ZJZEVDK3lMNjVFelpwMVY3RGFsUkxUWTNRZWVKOGt6SXpMN010ekRU?=
 =?utf-8?B?OGtGTG4wZUdOMjgvR2NKaXhrQkQ4bVFTbHJDMXRzQXp1c2FzUU5ickcwTjBz?=
 =?utf-8?B?ZThHdE16a2F1ZFJMcDZ0bHFGSDFveksvMWtaWHZnZEZZUk9icTBPeVRPaDFy?=
 =?utf-8?B?UW9mcTZYaU9NaDJ4V1BISzFkYW9zQnZZd2ZObGxBZzAyK1NBL3BPRmRscitV?=
 =?utf-8?B?MklYRkFnZ3JabE5vQlRyVEk5T09ZOU85UWFwQk9zQzZkYjUvMDl2OTRmYWVW?=
 =?utf-8?B?R21Ib2NaZHc4SFlZMkd4KzJzWEFESkZ2YjFvdWNFeGY2YURsZGRnV2ZHVzE3?=
 =?utf-8?B?c2E2Q08zcWpycTdudHVLRWJ3bC8vQSt6ZVEyYllkWGovTmtCUitUVXFCazRG?=
 =?utf-8?B?RlhwZ2VyM045Si9VQ2ttUmVuMys1YWI0K0Y0TjRGTEsydU4zeWhKem5FNUVH?=
 =?utf-8?B?VEZGTGNpVEprVmxvb3ROdlYzOVNDQytnOGtWc1pFSk1LZ05tV1dlVWIydWp5?=
 =?utf-8?B?OGJuYTlmd3BiNC9aMW1mYzVZRmhWRHRJSnNTeXlzSW13cnorUk1IbWFRVTY5?=
 =?utf-8?B?SjJ3SU05S1lrbkF5SWlUamhicEI4akQzbkc0aDNEWkhpVEY0TUtnMFFGY1RG?=
 =?utf-8?B?RVBhbUJyWUlQQ1Nla1h0MjhNTVFtdlh2ZXQxNVdwb2wreUU3bXZ6UE50Nkty?=
 =?utf-8?B?U0I3ZS8wYkpTZWJVemx6OGhGQnRQZ0ZzT21GS0RpZStKTXR6KzM5ODI3TEpU?=
 =?utf-8?B?TW00MWJNQktsRW4zN2o0cWozdzhTSmNLSS9zbnJ6dWo2WWp6V0ZQbHZ5YTl4?=
 =?utf-8?B?MExzdXkxUUh4QzgrQUk3R1B3K3Q3cnBsblFwWGdNRmV2aTBUeklheVJ4MTNP?=
 =?utf-8?Q?T8q11q+llo2nroo+RW9gfsisl?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: a96e6ebd-3d74-4b0e-0314-08dadd04de25
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 12:23:40.2609
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8cdMVYLIDjupT1Qg4oYLTaa6KfLly349+wrKnMlRpobL5vVtTDcbp3cfAM0zMkXXpKF0vvLz/As7iIdqlmwtiX7kpeES+MsptySFTsH8+ig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAWP189MB2526
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBQYWJsbyBOZWlyYSBBeXVzbyA8
cGFibG9AbmV0ZmlsdGVyLm9yZz4NCj4gU2VudDogVHVlc2RheSwgMTMgRGVjZW1iZXIgMjAyMiAx
MjoyNg0KPiBUbzogU3JpcmFtIFlhZ25hcmFtYW4gPHNyaXJhbS55YWduYXJhbWFuQGVzdC50ZWNo
Pg0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbmV0ZmlsdGVyLWRldmVsQHZnZXIua2Vy
bmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBuZXRmaWx0ZXI6IGNvbm50cmFjazogZG9j
dW1lbnQgc2N0cCB0aW1lb3V0cw0KPiANCj4gTWF5YmUgSSBhZGQgeW91ciBTaWduZWQtb2ZmLWJ5
OiB0YWcgdG8gdGhpcyBwYXRjaD8NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNyaXJhbSBZYWduYXJh
bWFuIDxzcmlyYW0ueWFnbmFyYW1hbkBlc3QudGVjaD4NCj4gDQpZZXMgcGxlYXNlLCB0aGFuayB5
b3UsIGZvcmdvdCB0byBhZGQgaXQgbXlzZWxmLg0KDQo+IFRoYW5rcy4NCj4gDQo=
