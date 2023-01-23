Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A77406785D6
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbjAWTKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjAWTKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:10:20 -0500
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2079.outbound.protection.outlook.com [40.107.22.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701D632E53
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:10:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BktkS4dgsnjh/VZi1Q53pNoRdqhcmu3bR7XSYNEDeCHNmGiHlDkg7I+APkivbVpIHSiqXFrG7qN77GNbLhq2R+juTINnZMJzWyuKNdpXYXsJuVOpNyjAS3KLHbUuDpv7W9pFVGdPbfPLgeBNG6Slu7rwXbm5JVnIlJ5iHi/2P9vxcmLaUf2+sFnbGVXkvjn+9wMzCHQlUSnzXKeqYFFcJoqqXTxYobS9nIerk3U76N7dAtRT3g+5gyl/IRk4lUjuhQycKZkKJm7xKlQB0hVIn5XNwdVF/YGKTlOPXluPJV1nLMIX/Z/HGb+DMy9hnciI2ZRJdpPiJXytQ8uTEoi7Vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7PNJnYaYUONcz2wU4qkG1oF0R8XtNVuZ79nIEO4aMyg=;
 b=oQCUaz6mtFHEJY4I7E2N7VvE7+CIRjCMcr4qLOsz5BOBmd9FU1OIwxteY7Xrm+fPs5Axyr2/CY4FEs10iRtH5yihT3DJ41YH2zuTr8yoN7Wfa9PZmGpm3Onb9J1KTkQ0TTGBfFp+w2BGknoyRXwHO6kdwW9Mq4fPBvxSMPedSvEJM18m3c2Ceu9xUL4D3xvUcYCQHD4JHwfy2W6QzwPx/LLBVyVd7+CZAuUQcJ9e5KCzROLappcD/x+Da0eAaYVRYcBL9xNWG7CzqFsXsRi+s4+vVu7c7v37qrTcV8PVTN6DJ14zEBXoeWTwnSMtQ4CM6Du9pCtLD5odZ6c3U3MSOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=siemens.com; dmarc=pass action=none header.from=siemens.com;
 dkim=pass header.d=siemens.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=siemens.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7PNJnYaYUONcz2wU4qkG1oF0R8XtNVuZ79nIEO4aMyg=;
 b=vbljxNU6x7DlHCjQXqgTNhnl/ulXMNEniMyQzaC6N0qmaMUPcFGJdaxMIBsJJLpJra59h8s2wXMhzh/TywbcpAdVAhqh03omAzcwG2tpgTu9BI8w+qHyPX3twOw/B7W+rUES8ZwCSQkR/XLPcixM2cB6k2ARpIvQyxFE5g/gUFcIfIYSF9G4b3paRLS4y5H9ouuYUmD01tQxUH/x79EaeOlRiFeGbrzrLbJVnu5QPLfyN2Bf898ENL7OuZQeICuQJ+Gvel6wOGh/u/D/N696jny9iyBeqz8vFLw3nTUtzNehcgU6P38qJhFmvXBlHfFulFEzM0sqCk4/2QEMlhI7Vw==
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:5b6::22)
 by DB4PR10MB7423.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:10:3f0::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Mon, 23 Jan
 2023 19:10:14 +0000
Received: from AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6180:97c1:d0ad:56a9]) by AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::6180:97c1:d0ad:56a9%2]) with mapi id 15.20.6002.028; Mon, 23 Jan 2023
 19:10:14 +0000
From:   "Sverdlin, Alexander" <alexander.sverdlin@siemens.com>
To:     "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
CC:     "Freihofer, Adrian" <adrian.freihofer@siemens.com>
Subject: Re: dsa: phy started on dsa_register_switch()
Thread-Topic: dsa: phy started on dsa_register_switch()
Thread-Index: AQHZL1l5u/8UqDcWzUK0y/q7DWBrr66sWksAgAADpgA=
Date:   Mon, 23 Jan 2023 19:10:14 +0000
Message-ID: <49ed2198d5cf219086eee24ba1ac640b60d32a1f.camel@siemens.com>
References: <f95cdab0940043167ddf69a4b21292ee63fc9054.camel@siemens.com>
         <6b63fe0f-a435-1fdf-bc56-10622b832419@gmail.com>
In-Reply-To: <6b63fe0f-a435-1fdf-bc56-10622b832419@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=siemens.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR10MB6867:EE_|DB4PR10MB7423:EE_
x-ms-office365-filtering-correlation-id: d26e2cda-8522-4547-c4da-08dafd757521
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pGYKbFsF+xn6wXTqND3v5WIoMKVh5tTH79yL0CYzN7eIdzpjXYeyn8t0gHYYCx7HcDqqAl/5/8DLQCU1afaHVXtQ1055EYZm4lKt1YAezy9rHAVNGL+y//SkF88KAXVrivEfwQNu9BeplH4WzqMlOClW+WuGv2lepPQmNyRk1hEeibJ7VIyNcWxjgMuYQMv1HuV2XOEqj5nUPJgxmUdTGxAYzdM5sf7PvoXVE2XoHNGFmuIX+DZYe3nStAyR1mFEDzd2pQHsyiQkAg2BvjZpZfL7LgSe3+g584YW8rGGxLeNbQm+5GaQPrNpN2fG0TFiqQQH/HbDwzGQqZ/LKKysC/TCvLoRCPY5yz/lBUTS597VDBY/bNOUgan6EIYSzWvbWdLWoGv5vA4IWTCKZr9Db1yrtZi1dt/JI44UGVkYLH4XBFmjK+ye6RaxwQVfGhKEdhLOvTELGi12DW+uTb8W7v2YA1t6Xc/nOa9r2plGwdz1Eu1Ma0oAf9ZUPyAFAPxFGKxEXncJOLV23jj9LmPKlNdnt4MtMzmTaL4Eord1GEwAHowEI2jN1sqmrA/1XPj17nPxgL4mukNLT7EKoSLtDIwWYfslDC/WwdkPS9v11yPVvuulZnTT8gvOHDfulTlLk/S08qZFHSLwqCfbBPbRhJceNpNcSl0pUqx4SKOtZyRnE4LDFP/g06ODGQU6tg8x4bnT0ayLzNP7kr6TEf+ZqptmbN/6bpzmC/9BQNG6oY9ztry1Nq1odpOIWUj3p81urYOTvSlKrB47f0NDzDkw/g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(396003)(136003)(366004)(346002)(39860400002)(451199015)(2906002)(38070700005)(82960400001)(38100700002)(122000001)(36756003)(91956017)(15974865002)(316002)(2616005)(71200400001)(110136005)(86362001)(64756008)(66476007)(66556008)(41300700001)(8936002)(8676002)(76116006)(66446008)(66946007)(4326008)(6506007)(107886003)(478600001)(5660300002)(26005)(83380400001)(186003)(55236004)(6512007)(6486002)(18886075002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OWxvWVpOWlRpVnJnWHZvTzNDTUNZUTVSRFo0SXRuRXJxL2dTekdubFlodmtF?=
 =?utf-8?B?ZE9GYTNNanRySXlmTU9WM3I1NE1rTjVLdUVuMWEvS3VtVnFWeTlMYXg2SEhy?=
 =?utf-8?B?OGFVZkhNVWJudzE1NEZjRVBnUDFGWWVxZ2pFRjhTN1FhQmtwWXF0NmpUdlNs?=
 =?utf-8?B?YXFUeGhwNWtXTzV6NFNyMXc1TGNqb2tJZEhIRHZaMWNBaUxHdS9mYzV1aTNU?=
 =?utf-8?B?RzhYdXFxZ1hVZTdmVjBlR2NMdjJRY0RMLzgvdzl6N2pnSWFQenB1VFdYOGYw?=
 =?utf-8?B?TUpTaEMwRHdialQ3L1ZwU25DUkZ3dnZwd202WE5vYWhDa2Zzdzc4L3lHV2VH?=
 =?utf-8?B?TCtBTWQ0VWdIYXNYUHpiaDhrWnBuVUwvd1lYT0RsQUlLcm5RSXJGWWlMdXdZ?=
 =?utf-8?B?ZVJ1YU1sS2dNQ0RFcXliV2JDQTRUYVcxNW55TlVDWGtkS3o1NEZxT0JGaFo1?=
 =?utf-8?B?SFhxZ0dyQkN0RE9VTmJPOGJ1NXJkSSs2MG5zcnUrL3Z2ZVZLemI3Uk9hWFVJ?=
 =?utf-8?B?OGtGTG5DYW44d05QSEJXdTBPdC9wK0NkaHhmTTQzdERJTTRwbkJNbnh5WW9Z?=
 =?utf-8?B?ZzZLZS90bWFMc09UOVJ4UVpvTGFaVlZyRHB3QlY4T0tyeGRNV2JwejAzMGlN?=
 =?utf-8?B?eFhrcmhwUE55UjNGUkRqaWZURkdrNDBaVzJnR0g3VERLM3JIQW9kNHVOTGVt?=
 =?utf-8?B?cjNNeTlnS25uTUp0ZkVpSEdKc2FxdnVYV2MydWhPcGx0Vm9sM2lDaGZhMFgv?=
 =?utf-8?B?RTAxZ3l4c1d6UUV6WUZBdlhBUlc5WEhFQ3pCQWc5ekpyakVoQTJzbm1PbENY?=
 =?utf-8?B?Szd4R25tazZaWm56M2NPTGxodUxNMHdzOHUrMis4R3VnZGZUTGQ0OVdsaUZs?=
 =?utf-8?B?WFRSOVR0eWp0dzFwMWVsUC9OcGdiVDdET0RxNGtBMUNZVi9JaUQyUFMvTUF5?=
 =?utf-8?B?L2t4UElsTGV3Zk5VUWdTTVQwcHBmbzAwaWFrMEQyY3VXNklIRUxBaVRZd2p6?=
 =?utf-8?B?aWRacFpxNHp1WkR3Nlg4RjQ1dEdPWnozYVVXa0FBOTYrM3QzdG44SFNFcE5E?=
 =?utf-8?B?Q1lNYlM2Z0diLzZUVXNNSHBlMm02a0hFeGRFdHZ0WGJ1ZlFGd042L3RqRi9L?=
 =?utf-8?B?L2hMaDkwV1R2SjE3QUpzaVhkS0ExVjNtUEZ5SlJKTUJWNWpTWm9MOFNUdmtv?=
 =?utf-8?B?TlY4YnZaRnhQNCtQckJlRi9nUWpLT1FtcnFrc25mY0R1TmdyN2h5M3RMWnZl?=
 =?utf-8?B?VzA5T2JnWW1IelJsQmp6azdIU0Z6KzBJWmVJKzJTdnQzeU1QZXBzMVUxUzZT?=
 =?utf-8?B?SlJSazVyYkxHUDlrSzJyaFVsWHRiWTZHZ2RZM0k3dWpYL001aTJPMzV4U1My?=
 =?utf-8?B?RzFaUlRoaXRDaFFjblBZMTBQck8zcUxnQWdsczZxczgzZjcyTWh2REw5MFRr?=
 =?utf-8?B?RVNJRU0vMnQrZ0ZodDFXbitrTFYwUXhpYXppK2U4aFFIajlqMy9yQm0rWWNQ?=
 =?utf-8?B?L3g5d0xoam12d0h4djFIT0pFTFZiOEFzeDFZMFdjWHFBYzRweTBzN1V2UGl5?=
 =?utf-8?B?azFvK0lZalluaUk1TXNlQlFRSVBQb1F1UHlmc1hUOStaUTAyek5ldTN3MUx4?=
 =?utf-8?B?dlNIT015VWFpK2VIczRFZ2lETFJseHk1MDNWbGVqcmE0LzVhOTc4NklCbm1x?=
 =?utf-8?B?bnJ2ODdGS05rdmNqa2tmYnV3MllYcjRXYWNTaEpFaERyN0Nwa1M2ckRVNGIy?=
 =?utf-8?B?TlYyb2lWVFo5SS9EWXN2YTR0MXdUcWJ6WDZHcHhzMGtzdFQ4TFNRMk5jTkp2?=
 =?utf-8?B?aVI5RkdneWljYVlzbXZQZEVycU93QitPVGpXNUVtRExkdW52ZnM0cmI1UXRm?=
 =?utf-8?B?eU8xMEJkVlR1cWszclI2SDIzSFJmOGhMZjZDcWhYZ25hcmFrWU1Vdjk1QWo1?=
 =?utf-8?B?dFdKN0hheDU3Q0FxL2ZIQ3VYREUySXl5VDY2UWJ3czRBckxvUUZYajk4SzhD?=
 =?utf-8?B?Q0U3Q1IvODFVbm5oYWRZYjlSTFpZUllvSkoyajFqMWlRS0xQSk4xdytUUVBG?=
 =?utf-8?B?aFFwaHN0WkQ1QmlhWkZhTUVMcGRTTFVGY2lMaEoyelR4dUNYam4xWHV5bjJW?=
 =?utf-8?B?dExZU1JNNEJhcWsvWmllNnhvbGc5OHN1REw0TUlOTmxxbzdxM3hUUXlDSU5P?=
 =?utf-8?Q?viqkz7Xh4l8WnZEDeqyLAwI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <02ED7AE215C1324DB28815CB13735F30@EURPRD10.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: siemens.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR10MB6867.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: d26e2cda-8522-4547-c4da-08dafd757521
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jan 2023 19:10:14.3869
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 38ae3bcd-9579-4fd4-adda-b42e1495d55a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JMnP6NAuuqhsMF/2T6DCCGwPL6yKqd4TrWFSHOOwDbYxWjBTOW/OhYGCTPt1EpVEz6IJrAtLni+Y5EJ7Rl1p6KTz/C9UmeOHAE+Pv8LbhUk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB4PR10MB7423
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhhbmsgeW91IEZsb3JpYW4gZm9yIHRoZSBxdWljayByZXBseSENCg0KT24gTW9uLCAyMDIzLTAx
LTIzIGF0IDEwOjU3IC0wODAwLCBGbG9yaWFuIEZhaW5lbGxpIHdyb3RlOg0KPiA+IEkndmUgYmVl
biBwdXp6bGVkIGJ5IHRoZSBmYWN0IHBvcnRzIG9mIHRoZSBEU0Egc3dpdGNoZXMgYXJlIGVuYWJs
ZWQNCj4gPiBvbg0KPiA+IGJvb3R1cCBieSBkZWZhdWx0IChQSFlzIGNvbmZpZ3VyZWQsIExFRHMg
T04sIGV0YykgaW4gY29udHJhc3QgdG8NCj4gPiB0aGUNCj4gPiBub3JtYWwgRXRoZXJuZXQgcG9y
dHMuDQo+ID4gDQo+ID4gU29tZSBwZW9wbGUgdGVuZCB0byB0aGluayB0aGlzIGlzIGEgc2VjdXJp
dHkgaXNzdWUgdGhhdCBwb3J0IGlzDQo+ID4gIm9wZW4iDQo+ID4gZXZlbiB0aG91Z2ggbm8gY29u
ZmlndXJhdGlvbiBoYXMgYmVlbiBwZXJmb3JtZWQgb24gdGhlIHBvcnQsIHNvIEkNCj4gPiBsb29r
ZWQgaW50byB0aGUgZGlmZmVyZW5jZXMgYmV0d2VlbiBFdGhlcm5ldCBkcml2ZXJzIGFuZCBEU0EN
Cj4gPiBpbmZyYXN0cnVjdHVyZS4NCj4gDQo+IElmIHlvdSBhcmUgY29uY2VybmVkIGFib3V0IHNl
Y3VyaXR5IHdpdGggYSBzd2l0Y2gsIHRoZW4gY2xlYXJseSB0aGUgDQo+IHN3aXRjaCBzaG91bGQg
aGF2ZSBhbiBFRVBST00gd2hpY2ggY29uZmlndXJlcyBpdCB0byBpc29sYXRlIGFsbCBvZg0KPiB0
aGUgDQo+IHBvcnRzIGZyb20gb25lIGFub3RoZXIsIGFuZCBwb3NzaWJseSBkbyBhZGRpdGlvbmFs
IGNvbmZpZ3VyYXRpb24gdG8gDQo+IHByZXZlbnQgYW55IHBhY2tldHMgZnJvbSBsZWFraW5nLiBU
aGUgUEhZIGFuZCBFdGhlcm5ldCBsaW5rIGJlaW5nDQo+IGFjdGl2ZSANCj4gd291bGQgbm90IGJl
IGEgcmVsaWFibGUgd2F5IHRvIGVuc3VyZSB5b3Ugc3RhcnQgdXAgaW4gYSBzZWN1cmUgc3RhdGUs
DQo+IGl0IA0KPiBtYXkgcGFydGljaXBhdGUgaW50byBpdCwgYnV0IGl0IGlzIG5vdCB0aGUgb25s
eSB0aGluZyB5b3UgY2FuIHJlbHkNCj4gdXBvbi4NCj4gDQoNCkFic29sdXRlbHkhIFRoaXMgd2Fz
IG1lcmVseSBhbiBpbmRpY2F0aW9uIHByb2JsZW0sIHBlb3BsZSB3YW50IHRvIHNlZQ0KdGhhdCBk
aXNhYmxlZCBwb3J0cyBhcmUgdmlzaWJseSBkaXNhYmxlZCBmcm9tIHRoZSBvdXRzaWRlLCBhbmQg
d2UNCndhbnQgdG8gYnJpbmcgdGhlIG5ldGRldiBzdGF0ZSBpbiBzeW5jIHdpdGggTEVEIGluZGlj
YXRpb24uDQoNCj4gPiBUcmFkaXRpb25hbGx5IHBoeWxpbmtfb2ZfcGh5X2Nvbm5lY3QoKSBhbmQg
cGh5bGlua19jb25uZWN0X3BoeSgpDQo+ID4gYXJlDQo+ID4gYmVpbmcgY2FsbGVkIGZyb20gX29w
ZW4oKSBjYWxsYmFja3Mgb2YgdGhlIEV0aGVybmV0IGRyaXZlcnMgc28NCj4gPiBhcyBsb25nIGFz
IHRoZSBFdGhlcm5ldCBwb3J0cyBhcmUgIUlGRl9VUCBQSFlzIGFyZSBub3QgcnVubmluZywNCj4g
PiBMRURzIGFyZSBPRkYsIGV0Yy4NCj4gDQo+IFRoaXMgaXMgd2hhdCBpcyBhZHZpc2VkIGZvciBF
dGhlcm5ldCBjb250cm9sbGVyIGRyaXZlcnMgdG8gZG8sIGJ1dCBpcw0KPiBub3Qgc3RyaWN0bHkg
ZW5mb3JjZWQgb3IgdHJ1ZSB0aHJvdWdob3V0IHRoZSBlbnRpcmUgdHJlZSwgdGhhdCBpcywgaXQN
Cj4gZGVwZW5kcyBsYXJnZWx5IHVwb24gd2hldGhlciBwZW9wbGUgd3JpdGluZy9tYWludGFpbmlu
ZyB0aG9zZSBkcml2ZXJzDQo+IGFyZSBzZW5zaXRpdmUgdG8gdGhhdCBiZWhhdmlvci4NCj4gDQoN
CllvdSBhcmUgcmlnaHQsIHRoaXMgYmVoYXZpb3IgaXMgdXAgdG8gdGhlIGluZGl2aWR1YWwgZHJp
dmVycywgdGhlcmUNCmlzIG5vIGd1YXJhbnRlZSBmb3IgdGhpcyBpbiBjb3JlLg0KDQpbLi4uXQ0K
DQo+ID4gVGhlIHRoaW5ncyBnZXQgd29yc2Ugd2hlbiBhIHVzZXIgcGVyZm9ybXMNCj4gPiAiaXAg
bGluayBzZXQgZGV2IGxhbjEgdXA7IGlwIGxpbmsgc2V0IGRldiBsYW4xIGRvd24iLCBiZWNhdXNl
IG5vdw0KPiA+IHRoZSBMRURzIGdvIE9GRi4NCj4gDQo+IFRoYXQgc2VlbXMgdG8gYmUgZXhhY3Rs
eSB0aGUgYmVoYXZpb3IgeW91IHdhbnQgYmFzZWQgdXBvbiB0aGUNCj4gcHJldmlvdXMgDQo+IHBh
cmFncmFwaCBhcyBpdCBpbmRpY2F0ZXMgdGhhdCB0aGUgUEhZIGhhcyBiZWVuIHBvd2VyZWQgZG93
bi4NCj4gDQoNCk1heWJlIHlvdSBhcmUgcmlnaHQgYW5kIHdlIHNob3VsZCBqdXN0IHRvZ2dsZSBJ
RkZfVVAgb25jZSBvbiBib290DQp0byBzeW5jIHRoZSBzdGF0ZSwgYXMgdGhpcyBiZWhhdm91ciBp
cyBub3QgdW5pZmllZC4uLg0KVGhhbmtzIGZvciBsb29raW5nIGludG8gdGhpcyENCg0KPiA+IElz
IHRoaXMgYmVoYXZpb3VyIGludGVuZGVkPyBTaGFsbCBJIHRyeSB0byBkZXZlbG9wIHBhdGNoZXMg
bW92aW5nDQo+ID4gcGh5bGlua18uKnBoeV9jb25uZWN0IHRvIGRzYV9zbGF2ZV9vcGVuKCkgYW5k
IHNvbWV0aGluZyBzaW1pbGFyDQo+ID4gZm9yIENQVSBwb3J0Pw0KPiANCj4gWWVzIHRoaXMgd2Fz
IGludGVudGlvbmFsIHNpbmNlIHRoZSBiZWdpbm5pbmcgdG8gc3BlZWQgdXAgDQo+IGF1dG8tbmVn
b3RpYXRpb24sIGFuZCBpdCBkYXRlcyBiYWNrIHRvIHdoZW4gRFNBIHdhcyBicm91Z2h0IGludG8g
dGhlIA0KPiBrZXJuZWwgY2lyY2EgMjAwOC4NCj4gDQo+IFdlIGFyZSBhbG1vc3QgZ3VhcmFudGVl
ZCB0byBiZSBicmVha2luZyBzb21lb25lJ3MgYmVoYXZpb3IgaWYgd2UgDQo+IHBvc3Rwb25lIHRo
ZSBjb25uZWN0aW9uIHRvIHRoZSBQSFksIGhvd2V2ZXIgd2UgY291bGQgaW50cm9kdWNlIGEgZmxh
Zw0KPiBhbmQgbWFrZSB0aGUgZGVmZXJyaW5nIG9mIGNvbm5lY3RpbmcgdG8gdGhlIFBIWSB0byBu
ZG9fb3BlbigpIGENCj4gZHJpdmVyIA0KPiBieSBkcml2ZXIgZGVjaXNpb24gd2hlbiBwcm92ZW4g
dGhpcyBoYXMgbm8gaWxsIGVmZmVjdC4NCg0KLS0gDQpBbGV4YW5kZXIgU3ZlcmRsaW4NClNpZW1l
bnMgQUcNCnd3dy5zaWVtZW5zLmNvbQ0K
