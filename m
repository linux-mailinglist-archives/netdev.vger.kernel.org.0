Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3439C522149
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:32:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347443AbiEJQgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347456AbiEJQgu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:36:50 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2120.outbound.protection.outlook.com [40.107.22.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 808222A2F7B
        for <netdev@vger.kernel.org>; Tue, 10 May 2022 09:32:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LOWVmFdC4chEwIyUqNm8o8E65xUri1ZhlGMOFKMGkfG3QNIL0cOweqr+uLvGJ2H4LOZ71KBTpE9bg/Nc6bKlvgjzytCx1XhR2zuxsRtyHUrNIFP147kuA4Gf9qKJX++nHt2GiaZXrYSkxXzpFZiVpgaMqWIAlj+9PAw9aK88R0++NNEbnRlQEY6lKyz6NnAJr1BRva4KxELSfmS18Bed7Kcy0N/pLuhS0GG1INAkLZiqBiCtya1vLgQjgQ6jXmtjkAeEuGRDrw/I/2gFi4nnWddxhsUG4MzPMSXszLDqe3JT7NpyAVlv0Qv3xJkW0Es/inDp2OfRuRjcdHo6/Ytaug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9XZDfW6D7UU4NQg22tL12QY3GdlNV0pNsGvyFOWVnW8=;
 b=DzUGVMw8nkgqWgkGNvvaPdvWKCKZbV/4xGJ7CHqGzigTa52o3NxyEPX/Gbnx+4ckuMoYvD+jytKbkhLg0QMClcA25k9rSv2EZFj5YstXvixFNk44vyO2gW66iYEXrLPXW5KsOfer/vZF9x7z0zyMrQ+WERim8VDYoJxwQL+2xD2FNPVzd+K+lOmZ+weFK3zRj5s+Ze+7oefMyfNg7Y0jjcaeJ8dZTbBsQa8F68ULp7px+RAInHgLEX5ubQCq282S5cV9tiCkl9qzuQyZi9y4byy1/aXfXLAtumWzxcDkE2ND630JdvNtyoR9Hj92TgswhmqvojJzyVTuI7ozlP24aQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9XZDfW6D7UU4NQg22tL12QY3GdlNV0pNsGvyFOWVnW8=;
 b=HAq4t5i4ykL+8MV9e6mNG2xe4Fd3YaKJfrEE/qhAp2k7D4jWlcLGZNoi0+KLHjWPrrow0mZFOpyDXuty9CTE/Yn5OykXv6xiaxjIUtRkd+mBa7TwpHKNb1XvK3QSHt52pCGSmLy9niE+h4BOhZRv2XGJNVJ5b6wV5PWA/ZyrIQA=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by PR3PR03MB6426.eurprd03.prod.outlook.com (2603:10a6:102:7a::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5227.22; Tue, 10 May
 2022 16:32:45 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::e5d4:b044:7949:db96%3]) with mapi id 15.20.5227.023; Tue, 10 May 2022
 16:32:44 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Hauke Mehrtens <hauke@hauke-m.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/4] net: dsa: realtek: rtl8365mb: Get chip option
Thread-Topic: [PATCH 2/4] net: dsa: realtek: rtl8365mb: Get chip option
Thread-Index: AQHYYy3l/MgoxiPE0UGaWb9gTkXOOK0YUMmA
Date:   Tue, 10 May 2022 16:32:44 +0000
Message-ID: <20220510163243.c2o6ttpxjwbjfhof@bang-olufsen.dk>
References: <20220508224848.2384723-1-hauke@hauke-m.de>
 <20220508224848.2384723-3-hauke@hauke-m.de>
In-Reply-To: <20220508224848.2384723-3-hauke@hauke-m.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a7f8b5c1-1d6a-4a72-3576-08da32a2b629
x-ms-traffictypediagnostic: PR3PR03MB6426:EE_
x-microsoft-antispam-prvs: <PR3PR03MB6426CDEAF9F2FB005BD660C783C99@PR3PR03MB6426.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Q9+F1nBhSOBb8a+lK2i/WOsl8e/+lOYBvyTmqhrmFtlfvwv3e+mEJq7Nr1vmZIHMjIRZvHD3W6WjBqXHeV+wmOPE5rZnk+HVO7HM2wVwE6rC91WXySkcqMh//uUb9Cf2TGiEjOLEPmXthN6z/l96UvXHMNhgjQxVnQv4ugy9T/IDZ3zAWgPsbIf8a+tLfchclFAvSBDdReje853dppr3bubuxZU16SwFnJ9vzDzXhSf9EuzZhvDllZvUtVk0GQ235r30S97OKUdbL4GN32+ZVsxH6PaXKXbkYOPO5mw6zoOK7F4i7hdp48qJptxi+5Jo67npxQ6SbdakUutBHsOqlWRCD3cSudllgPZ9PSrVFlQVrRqUB9kPCij5QUgeDpOJey2arlC8cfDJ/VMoGQ0mooTuJpfPb23IToUrx2fsVvGIh9eIc7Mqu1agUdAgie44Amv8j+Z5HUL0nCJcDqJXaDNyGBCPmDmmOwKvUpy+9ShQ1eBfL2NYQcvakLVx2PwXc91gy1fdlt4drgtdNYMdJUWaD4oXOK/QLNUsjFYPIKcrp/wf7yliUFOxJ6vtVljY54vE5YHFHqqq/eCatBTHLx7lp92KDiUdVuYSw9kvWoZAU2eKFyHsp5X3cRhc7z0ftXCryGEOBgsi6ik0lQFreqYk6q3rFxluiC4jBGijyZo0VYISlGehRAKKlKUbLcFTZqWXa26h13UxKdNZxAnc6k52/F/uzQv2dnCxKWqV9uW7miyWniqicgO3UdvRn5drCwwVKUJzvuZgvuZrP330GEBKP9+Kj8fxUmL8da3MZfc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(76116006)(5660300002)(8936002)(1076003)(71200400001)(8976002)(54906003)(66556008)(66946007)(26005)(91956017)(6916009)(6512007)(2616005)(66476007)(86362001)(316002)(186003)(66446008)(64756008)(4326008)(8676002)(83380400001)(6506007)(85182001)(36756003)(85202003)(966005)(6486002)(38100700002)(2906002)(38070700005)(508600001)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akNqK0tET3gzT0tVZkJka1dsekRvYUVoR1dUQlVaRVpoRmFZZ0kyTzRmVkp0?=
 =?utf-8?B?alVZM09aTWN5MkUzaFM3eXRMcDVoSEgvSDdNMGhHeXMrcDlQTjAzdFl2NUxM?=
 =?utf-8?B?aENGU09zb0ZWNS9qcTNEbGpiN29HUC9Ob3BhbjlaMG4wdmJTVGpxd2xKaWVO?=
 =?utf-8?B?OWFNZjZkdktQWlpsYTV1d05LVzgycmpyNFhnbGpQTk5oQzQ3WDRNODlFZDFU?=
 =?utf-8?B?MWJjeGNiaDAvVjRsT2RxQUNCVnBKcHEzZ09qcjB1azJmUGhrQjB3TFQ2QUE5?=
 =?utf-8?B?OTBXWFF3YzJUaWx1MjA1enArNHVieThaaWlKUkg4Tlp5ZDk0bElxMUFrT3hr?=
 =?utf-8?B?Z0RBeEZJYjc2d2FkL0pXK2R3TTRFbU9CUm9TRGJtUXdiaGpGWmdXTkV2a09i?=
 =?utf-8?B?Ymk1SCs4eVNuemliZ0N1WXNtclpvRDYxeG1OMk41c0wxYVRaRGxwb08vQ3JW?=
 =?utf-8?B?TnlkbHR2c0l2UzR4eVVCS2JxS3JrVCtGcVhIV3hHbVFWcXdzQ3FSd2JKZTNR?=
 =?utf-8?B?UCtlSnJmSTVTSUNHOGJNNk9mRnh4cVdUcWNkREtuR0krVVpLTzM3b2grZW5j?=
 =?utf-8?B?aTBabVR3aVE0TmJnaUNlb1dycUFjWGROTWJYSVBkQWlJSlRpRVBzb3VMdkww?=
 =?utf-8?B?YjM3a1YxbE04b29LRE05TUhYbXFyTXBYR1ZVNFJZZ3JjTGtvMjhidTd1QTk3?=
 =?utf-8?B?Q0JVTHA5YXloNXp5VUNLRng4c1R5SGtTUGVIWFh2QkQxV1c5NEpVcFc0cnBL?=
 =?utf-8?B?Z2JnbCtQaDlkK0YwZ25NY1B4ZzlkMjBEVWNXSFFHQ0tFTU53clQvUHNUV1M2?=
 =?utf-8?B?TGhQOGtwa2ptZ3J2RUoybEdQQ296NWpLOXdTZHgvd1BxejBxVVJYWTVTSDJK?=
 =?utf-8?B?QmIvK21TV1l0LzR4a1dDSHlLby94SGhlRGk5N2dFczM3ZTFWcWdacy9zSTNk?=
 =?utf-8?B?SzlGZDRBL2EvdURIOEFrN0R3d3N4c2gyQjhkZlIyWEJmbzZGWW5WYUlZZTB5?=
 =?utf-8?B?NkkvRlVEY3cvZENrRllocjhHLy9iYURXZVpSalQrZmZMYXhBSUJOZXJ2WjRW?=
 =?utf-8?B?Uy81bmZjNG5lRVpRbm9mYVNvUzUwZzkyTElRVjROWnRBcnI3bGIyYkNCbTB5?=
 =?utf-8?B?UkhmZ3Vqc2M0RUxtZWRVZ3Jyckkzb1dYbkZTd0hYVDRXakROeDhVZlp2ZkEv?=
 =?utf-8?B?aHE5QlN0SlhwS3p4TmFpdWpRVUIxbkhJNFJUazhsZ2gyOTYvZDNrUnNldHVm?=
 =?utf-8?B?d2VqbW55V0JmRm5aa2JoeTBDd1Z3bFlpR1BVdVJ3WUhBVmc5RTVJZzVDZGFL?=
 =?utf-8?B?K1ZWR0VYVlpPcXJLbUk3bnlMbWhMMlVTM0pSYUZzT2E3UFVyU1UxTjNFbTJv?=
 =?utf-8?B?LzJkbWtEVS9KWDh3VWVKRHZka3RNeDAweDJEaTRqaElPcEFJeGNtcFpwSU9i?=
 =?utf-8?B?aVh0bGVOVHpuUndBQk96NkxROWtUS2tyNGUvdzEwUnM1ZTAzdkkxYy9WODhQ?=
 =?utf-8?B?ZVBjejQ1aVpTNkVpU3luQzF0NS9uazZUb3FCYWFVMUM4dGZ2dENxd1cxUzBl?=
 =?utf-8?B?Tms5RWRQL0p3aW9FdWgzY0ZHQUphSHE2Z0JocjhsY3ZwM3Q5dUlCYnJGRXZG?=
 =?utf-8?B?cXA2VG9zLy8vSTMrelo4NzkrbEZ3ckREb0J5eTRrNUt5dW1rcVc5VmJvSVN5?=
 =?utf-8?B?L1pMWXZWZ0tQSWNEcjZLemhYUXdZd01FR21xdkxnZ0o0S1M0Q2cxbUxQdDd6?=
 =?utf-8?B?QTFPS3JvQnNtdlIvekZPSldkaDYvT2dZR3c1L01oclFFdncxT0JUd083emZ4?=
 =?utf-8?B?SXdJRDhIZVhLcXVGUmpQRUpacUg0TVlHVzVPUTlmY0QrdEZ6TmdMejdLejlD?=
 =?utf-8?B?RXhIM1EybnlPQ1lYSCtVaFNKSDljZkJJUk5JZ1RDenltMkVoM0JueHk2SXIv?=
 =?utf-8?B?UGxHcUQrQXJsM0QwWWdUaTVsMk8xNTZvaVhQM1YyeGZpQW9mTFQ4TDNzNUt3?=
 =?utf-8?B?T0JqK3Z2QWh3Y2ZCamJwWnFsR29keW1ySUhYY1IyRFJqRjQ4QWVCampSRlhj?=
 =?utf-8?B?OUxtODlFTjFTd0NQa2dmUUdiVGsxM2Yza0QzeWxIVytDQ1JVWG00S0xsWGdq?=
 =?utf-8?B?NjhBbnhyUDdVRUNQQlVyZDZ0eE9RaWozOXI1MjczbzZ6UlhGN3pjVU5rWFd3?=
 =?utf-8?B?c01uQUlENStMQkJtNjQ3Kzk4SjE4bjhGVHpPN3NqTGNHWGZEbUxMUmRxMXBw?=
 =?utf-8?B?L0JUa1NDTUdjbm9hQ3JGRFBLVkd5TFF0OTBKdXNBc1NTRVR2cUw1azA1TmlB?=
 =?utf-8?B?cHJLTC9DT2pMZ2ViRzNyYnAwckdXTnBBdDNJdU1NMlI3eFBnbTBUeE40SVhv?=
 =?utf-8?Q?8WzD/Yuf8aAmCk5g=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2066C07DF170D644810B2D66C80880AF@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a7f8b5c1-1d6a-4a72-3576-08da32a2b629
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 May 2022 16:32:44.8279
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IKVzrBZeOyTNIGrdPoxFOGZ7OYucO7s6KXNnEywnafPBg0ICCkqAoECb3Eyeksfw+gksyv8Wla/Pmm7iyn3n2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR03MB6426
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBNYXkgMDksIDIwMjIgYXQgMTI6NDg6NDZBTSArMDIwMCwgSGF1a2UgTWVocnRlbnMg
d3JvdGU6DQo+IFJlYWQgdGhlIG9wdGlvbiByZWdpc3RlciBpbiBhZGRpdGlvbiB0byB0aGUgb3Ro
ZXIgcmVnaXN0ZXJzIHRvIGlkZW50aWZ5DQo+IHRoZSBjaGlwLiBUaGUgU0dNSUkgaW5pdGlhbGl6
YXRpb24gaXMgZGlmZmVyZW50IGZvciB0aGUgZGlmZmVyZW50IGNoaXANCj4gb3B0aW9ucy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IEhhdWtlIE1laHJ0ZW5zIDxoYXVrZUBoYXVrZS1tLmRlPg0KPiAt
LS0NCj4gIGRyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jIHwgNDMgKysrKysrKysr
KysrKysrKysrKysrLS0tLS0tLS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAzMSBpbnNlcnRpb25zKCsp
LCAxMiBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvcmVh
bHRlay9ydGw4MzY1bWIuYyBiL2RyaXZlcnMvbmV0L2RzYS9yZWFsdGVrL3J0bDgzNjVtYi5jDQo+
IGluZGV4IDJjYjcyMmE5ZTA5Ni4uYmU2NGNmZGVjY2M3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJz
L25ldC9kc2EvcmVhbHRlay9ydGw4MzY1bWIuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvcmVh
bHRlay9ydGw4MzY1bWIuYw0KPiBAQCAtMTI3LDYgKzEyNyw5IEBAIHN0YXRpYyBjb25zdCBpbnQg
cnRsODM2NW1iX2V4dGludF9wb3J0X21hcFtdICA9IHsgLTEsIC0xLCAtMSwgLTEsIC0xLCAtMSwg
MSwgMiwNCj4gIA0KPiAgI2RlZmluZSBSVEw4MzY1TUJfQ0hJUF9WRVJfUkVHCQkweDEzMDENCj4g
IA0KPiArI2RlZmluZSBSVEw4MzY1TUJfQ0hJUF9PUFRJT05fUkVHCTB4MTNDMQ0KPiArDQo+ICsj
ZGVmaW5lIFJUTDgzNjVNQl9NQUdJQ19PUFRfUkVHCQkweDEzQzANCg0KUmVhbHRlaydzIGRyaXZl
ciBjYWxscyB0aGlzIHJlZ2lzdGVyIFBST1RFQ1RfSUQ6DQoNCmh0dHBzOi8vZ2l0Lm9wZW53cnQu
b3JnLz9wPW9wZW53cnQvb3BlbndydC5naXQ7YT1ibG9iO2Y9dGFyZ2V0L2xpbnV4L21lZGlhdGVr
L2ZpbGVzL2RyaXZlcnMvbmV0L3BoeS9ydGsvcnRsODM2N2MvaW5jbHVkZS9ydGw4MzY3Y19yZWcu
aDtoPWViNGY0OGI4M2UwMmNlMDYyNWQ3MGIzMzdjNDQ1YzM2ZjA3MTY4NmM7aGI9SEVBRA0KMTgw
NTAgI2RlZmluZSAgICBSVEw4MzY3Q19SRUdfUFJPVEVDVF9JRCAgICAweDEzYzANCg0KQ29uc2lk
ZXIgcmVuYW1pbmcgaXQsIG9yIGF0IGxlYXN0IGJlIGNvbnNpc3RlbnQgd2l0aCBfT1BUIGFuZCBf
T1BUSU9OLiBJIHNlZQ0KYm90aCBvcHQgYW5kIG9wdGlvbiB0aHJvdWdob3V0IHRoZSBwYXRjaC4N
Cg0KPiAgI2RlZmluZSBSVEw4MzY1TUJfTUFHSUNfUkVHCQkweDEzQzINCj4gICNkZWZpbmUgICBS
VEw4MzY1TUJfTUFHSUNfVkFMVUUJCTB4MDI0OQ0KDQpDYW4geW91IHJlcGVhdCB0aGlzIGZvciBN
QUdJQ19PUFRfUkVHPyBJdCdzIE9LIHRoYXQgaXQncyB0aGUgc2FtZS4NCg0KPiAgDQo+IEBAIC01
NzksNiArNTgyLDcgQEAgc3RydWN0IHJ0bDgzNjVtYiB7DQo+ICAJaW50IGlycTsNCj4gIAl1MzIg
Y2hpcF9pZDsNCj4gIAl1MzIgY2hpcF92ZXI7DQo+ICsJdTMyIGNoaXBfb3B0aW9uOw0KDQpNb3Jl
b3ZlciwgZG8geW91IGtub3cgd2hhdCBvcHRpb24gaXMgc3VwcG9zZWQgdG8gbWVhbiBoZXJlPyBM
aWtld2lzZSB0aGUNCnJlZ2lzdGVyIG1hcCBmcm9tIFJlYWx0ZWsgY2FsbHMgdGhpcyBDSElQX1ZF
Ul9JTlRMIChpbnRlcm5hbCBtYXliZT8pOg0KDQojZGVmaW5lICAgIFJUTDgzNjdDX1JFR19DSElQ
X1ZFUl9JTlRMICAgIDB4MTNjMQ0KDQo+ICAJdTMyIHBvcnRfbWFzazsNCj4gIAl1MzIgbGVhcm5f
bGltaXRfbWF4Ow0KPiAgCXN0cnVjdCBydGw4MzY1bWJfY3B1IGNwdTsNCj4gQEAgLTE5NTksNyAr
MTk2Myw3IEBAIHN0YXRpYyB2b2lkIHJ0bDgzNjVtYl90ZWFyZG93bihzdHJ1Y3QgZHNhX3N3aXRj
aCAqZHMpDQo+ICAJcnRsODM2NW1iX2lycV90ZWFyZG93bihwcml2KTsNCj4gIH0NCj4gIA0KPiAt
c3RhdGljIGludCBydGw4MzY1bWJfZ2V0X2NoaXBfaWRfYW5kX3ZlcihzdHJ1Y3QgcmVnbWFwICpt
YXAsIHUzMiAqaWQsIHUzMiAqdmVyKQ0KPiArc3RhdGljIGludCBydGw4MzY1bWJfZ2V0X2NoaXBf
aWRfYW5kX3ZlcihzdHJ1Y3QgcmVnbWFwICptYXAsIHUzMiAqaWQsIHUzMiAqdmVyLCB1MzIgKm9w
dGlvbikNCg0KTGlrZXdpc2UgZm9yIGNvbnNpc3RlbmN5LCBjb25zaWRlciB0aGUgbmFtZSBvZiB0
aGlzIGZ1bmN0aW9uIGFzIHlvdSBhZGQgYSBuZXcNCmFyZ3VtZW50IHRvIGl0Lg0KDQo+ICB7DQo+
ICAJaW50IHJldDsNCj4gIA0KPiBAQCAtMTk4Myw2ICsxOTg3LDE5IEBAIHN0YXRpYyBpbnQgcnRs
ODM2NW1iX2dldF9jaGlwX2lkX2FuZF92ZXIoc3RydWN0IHJlZ21hcCAqbWFwLCB1MzIgKmlkLCB1
MzIgKnZlcikNCj4gIAlpZiAocmV0KQ0KPiAgCQlyZXR1cm4gcmV0Ow0KPiAgDQo+ICsJcmV0ID0g
cmVnbWFwX3dyaXRlKG1hcCwgUlRMODM2NU1CX01BR0lDX09QVF9SRUcsIFJUTDgzNjVNQl9NQUdJ
Q19WQUxVRSk7DQoNCk1pZ2h0IGRlc2VydmUgYSBjb21tZW50IGhlcmUgdG9vLCAidGhlIHZlcjIv
dmVyX2ludGwvb3B0aW9uL2V0Yy4gcmVnaXN0ZXIgaXMNCmFsc28gcHJvdGVjdGVkIHdpdGggbWFn
aWMiLg0KDQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0dXJuIHJldDsNCj4gKw0KPiArCXJldCA9IHJl
Z21hcF9yZWFkKG1hcCwgUlRMODM2NU1CX0NISVBfT1BUSU9OX1JFRywgb3B0aW9uKTsNCj4gKwlp
ZiAocmV0KQ0KPiArCQlyZXR1cm4gcmV0Ow0KPiArDQo+ICsJLyogUmVzZXQgbWFnaWMgcmVnaXN0
ZXIgKi8NCj4gKwlyZXQgPSByZWdtYXBfd3JpdGUobWFwLCBSVEw4MzY1TUJfTUFHSUNfT1BUX1JF
RywgMCk7DQo+ICsJaWYgKHJldCkNCj4gKwkJcmV0dXJuIHJldDsNCj4gKw0KPiAgCXJldHVybiAw
Ow0KPiAgfQ0KPiAgDQo+IEBAIC0xOTkxLDkgKzIwMDgsMTAgQEAgc3RhdGljIGludCBydGw4MzY1
bWJfZGV0ZWN0KHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYpDQo+ICAJc3RydWN0IHJ0bDgzNjVt
YiAqbWIgPSBwcml2LT5jaGlwX2RhdGE7DQo+ICAJdTMyIGNoaXBfaWQ7DQo+ICAJdTMyIGNoaXBf
dmVyOw0KPiArCXUzMiBjaGlwX29wdGlvbjsNCj4gIAlpbnQgcmV0Ow0KPiAgDQo+IC0JcmV0ID0g
cnRsODM2NW1iX2dldF9jaGlwX2lkX2FuZF92ZXIocHJpdi0+bWFwLCAmY2hpcF9pZCwgJmNoaXBf
dmVyKTsNCj4gKwlyZXQgPSBydGw4MzY1bWJfZ2V0X2NoaXBfaWRfYW5kX3Zlcihwcml2LT5tYXAs
ICZjaGlwX2lkLCAmY2hpcF92ZXIsICZjaGlwX29wdGlvbik7DQo+ICAJaWYgKHJldCkgew0KPiAg
CQlkZXZfZXJyKHByaXYtPmRldiwgImZhaWxlZCB0byByZWFkIGNoaXAgaWQgYW5kIHZlcnNpb246
ICVkXG4iLA0KPiAgCQkJcmV0KTsNCj4gQEAgLTIwMDUsMjIgKzIwMjMsMjIgQEAgc3RhdGljIGlu
dCBydGw4MzY1bWJfZGV0ZWN0KHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYpDQo+ICAJCXN3aXRj
aCAoY2hpcF92ZXIpIHsNCj4gIAkJY2FzZSBSVEw4MzY1TUJfQ0hJUF9WRVJfODM2NU1CX1ZDOg0K
PiAgCQkJZGV2X2luZm8ocHJpdi0+ZGV2LA0KPiAtCQkJCSAiZm91bmQgYW4gUlRMODM2NU1CLVZD
IHN3aXRjaCAodmVyPTB4JTA0eClcbiIsDQo+IC0JCQkJIGNoaXBfdmVyKTsNCj4gKwkJCQkgImZv
dW5kIGFuIFJUTDgzNjVNQi1WQyBzd2l0Y2ggKHZlcj0weCUwNHgsIG9wdD0weCUwNHgpXG4iLA0K
PiArCQkJCSBjaGlwX3ZlciwgY2hpcF9vcHRpb24pOw0KPiAgCQkJYnJlYWs7DQo+ICAJCWNhc2Ug
UlRMODM2NU1CX0NISVBfVkVSXzgzNjdSQjoNCj4gIAkJCWRldl9pbmZvKHByaXYtPmRldiwNCj4g
LQkJCQkgImZvdW5kIGFuIFJUTDgzNjdSQi1WQiBzd2l0Y2ggKHZlcj0weCUwNHgpXG4iLA0KPiAt
CQkJCSBjaGlwX3Zlcik7DQo+ICsJCQkJICJmb3VuZCBhbiBSVEw4MzY3UkItVkIgc3dpdGNoICh2
ZXI9MHglMDR4LCBvcHQ9MHglMDR4KVxuIiwNCj4gKwkJCQkgY2hpcF92ZXIsIGNoaXBfb3B0aW9u
KTsNCj4gIAkJCWJyZWFrOw0KPiAgCQljYXNlIFJUTDgzNjVNQl9DSElQX1ZFUl84MzY3UzoNCj4g
IAkJCWRldl9pbmZvKHByaXYtPmRldiwNCj4gLQkJCQkgImZvdW5kIGFuIFJUTDgzNjdTIHN3aXRj
aCAodmVyPTB4JTA0eClcbiIsDQo+IC0JCQkJIGNoaXBfdmVyKTsNCj4gKwkJCQkgImZvdW5kIGFu
IFJUTDgzNjdTIHN3aXRjaCAodmVyPTB4JTA0eCwgb3B0PTB4JTA0eClcbiIsDQo+ICsJCQkJIGNo
aXBfdmVyLCBjaGlwX29wdGlvbik7DQo+ICAJCQlicmVhazsNCj4gIAkJZGVmYXVsdDoNCj4gLQkJ
CWRldl9lcnIocHJpdi0+ZGV2LCAidW5yZWNvZ25pemVkIHN3aXRjaCB2ZXJzaW9uICh2ZXI9MHgl
MDR4KSIsDQo+IC0JCQkJY2hpcF92ZXIpOw0KPiArCQkJZGV2X2Vycihwcml2LT5kZXYsICJ1bnJl
Y29nbml6ZWQgc3dpdGNoIHZlcnNpb24gKHZlcj0weCUwNHgsIG9wdD0weCUwNHgpIiwNCj4gKwkJ
CQljaGlwX3ZlciwgY2hpcF9vcHRpb24pOw0KPiAgCQkJcmV0dXJuIC1FTk9ERVY7DQo+ICAJCX0N
Cj4gIA0KPiBAQCAtMjAyOSw2ICsyMDQ3LDcgQEAgc3RhdGljIGludCBydGw4MzY1bWJfZGV0ZWN0
KHN0cnVjdCByZWFsdGVrX3ByaXYgKnByaXYpDQo+ICAJCW1iLT5wcml2ID0gcHJpdjsNCj4gIAkJ
bWItPmNoaXBfaWQgPSBjaGlwX2lkOw0KPiAgCQltYi0+Y2hpcF92ZXIgPSBjaGlwX3ZlcjsNCj4g
KwkJbWItPmNoaXBfb3B0aW9uID0gY2hpcF9vcHRpb247DQo+ICAJCW1iLT5wb3J0X21hc2sgPSBH
RU5NQVNLKHByaXYtPm51bV9wb3J0cyAtIDEsIDApOw0KPiAgCQltYi0+bGVhcm5fbGltaXRfbWF4
ID0gUlRMODM2NU1CX0xFQVJOX0xJTUlUX01BWDsNCj4gIAkJbWItPmphbV90YWJsZSA9IHJ0bDgz
NjVtYl9pbml0X2phbV84MzY1bWJfdmM7DQo+IEBAIC0yMDQzLDggKzIwNjIsOCBAQCBzdGF0aWMg
aW50IHJ0bDgzNjVtYl9kZXRlY3Qoc3RydWN0IHJlYWx0ZWtfcHJpdiAqcHJpdikNCj4gIAkJYnJl
YWs7DQo+ICAJZGVmYXVsdDoNCj4gIAkJZGV2X2Vycihwcml2LT5kZXYsDQo+IC0JCQkiZm91bmQg
YW4gdW5rbm93biBSZWFsdGVrIHN3aXRjaCAoaWQ9MHglMDR4LCB2ZXI9MHglMDR4KVxuIiwNCj4g
LQkJCWNoaXBfaWQsIGNoaXBfdmVyKTsNCj4gKwkJCSJmb3VuZCBhbiB1bmtub3duIFJlYWx0ZWsg
c3dpdGNoIChpZD0weCUwNHgsIHZlcj0weCUwNHgsIG9wdD0weCUwNHgpXG4iLA0KPiArCQkJY2hp
cF9pZCwgY2hpcF92ZXIsIGNoaXBfb3B0aW9uKTsNCj4gIAkJcmV0dXJuIC1FTk9ERVY7DQo+ICAJ
fQ0KPiAgDQo+IC0tIA0KPiAyLjMwLjINCj4=
