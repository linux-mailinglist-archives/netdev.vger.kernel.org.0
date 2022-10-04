Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29A465F46B8
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229509AbiJDPbQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:31:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiJDPbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:31:14 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2089.outbound.protection.outlook.com [40.107.92.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282732F3B5
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 08:31:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GSq4dIqSpInay/gOSicXr7tQHE0jyYKyRfaveNo8/NEVxJwJBbvadaYXYBdyFwby94vSMsrSRSPeww3d1jTRjxzSEv9WPUtRg6g1/2uQ65LVfERthEeKgSp9PWC3+bxJoIWkq+a3bkU6q+Lzr+bA956J2Nj2qrWcOLwtMDzq7wgAT+a1W+HA0h4/HYGLGOg+fSP1FPYkDew6G0QAoWCDsX3h+jX/JLnGHIyLIdUILxRjsvVLdx9C42xDgphYMWquL5LF6kEePFEv5T8f25fReG7XN72DIF8gzbpnM//XEPE84R1mOtVMhWrsbkVJPSSmAB6U4htqIewcuKBsVp9ojw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=V/dUZad3p7s41aeHOvm7riF90v/yBiIyC8XSu+xPAdg=;
 b=IvSq2Ay9QIgReaztT7jPpqHMnfM7lRDOQfvsnJgiLzz/xQtRMPRAd/wW6MlnggVwMO1E3zveU1q9QwRECALTz/4jtGEfOjEathEgX86T6lXUV0dZlWn2D17LHQZ3/Op03Z/JNrdfU5RqE3ro73NFUdTTlpKrp7ryHRoc9PSGRd91jp+NP73RAkh73iomtNfRTrCpf1/rg6XxoVAKZEwO4kEQf3v31RnCWk6AWCZ/7NZuacW7bF7309tGa4FnTB+1++CAuZWkkN8U32HYId2YqQxhoenmZgvCoenGbi4X0RTd01g5n3xygzWU+veEjrI3JyvvpqR1WqUOjhooFvB9/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=V/dUZad3p7s41aeHOvm7riF90v/yBiIyC8XSu+xPAdg=;
 b=EKuVe5DVZQu7mX83Gt8vhmlPon/Z64hfxIhm1P1EnbgxL8WUvokD6C5OTcn7R0+pO/8QEZey/l1v0CjehXglWdafh1Lxv/N5BA73u30dIUW8nT5xAMqlYTbYK91z9pxIAMKw36I/+EYe1MVUdxC7WGbTjGXh//FLCYmsZAW3Ip8=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by DM4PR12MB6592.namprd12.prod.outlook.com (2603:10b6:8:8a::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5676.28; Tue, 4 Oct 2022 15:31:10 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::b131:1ee7:1726:3ac9]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::b131:1ee7:1726:3ac9%5]) with mapi id 15.20.5676.028; Tue, 4 Oct 2022
 15:31:10 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "dmichail@fungible.com" <dmichail@fungible.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "anthony.l.nguyen@intel.com" <anthony.l.nguyen@intel.com>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "drivers@pensando.io" <drivers@pensando.io>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "yangyingliang@huawei.com" <yangyingliang@huawei.com>
Subject: Re: [patch net-next 0/3] devlink: fix order of port and netdev
 register in drivers
Thread-Topic: [patch net-next 0/3] devlink: fix order of port and netdev
 register in drivers
Thread-Index: AQHY0aQfklrqw/9EBkuPEu5x26dKnK3+aFkA
Date:   Tue, 4 Oct 2022 15:31:10 +0000
Message-ID: <6dd32faa-2651-31bf-da2e-e768b9966e36@amd.com>
References: <20220926110938.2800005-1-jiri@resnulli.us>
Accept-Language: en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/16.53.21091200
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|DM4PR12MB6592:EE_
x-ms-office365-filtering-correlation-id: 0f9f7a56-c5fb-459d-afe4-08daa61d7709
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7H8tSURG+6VuezBMHyNP519ZMno06kzDrbpK9PNeegXID+7bbu8HvLlaZGngvlsMe0bjP9e33V048r736BWoC6otniWbgDHd7awIH2M8nRSOP9sbQl39O6ur59jMKMF6hhrGSAvWNaQU8oahv6JrMPdTY6Y60JB4722/QWaMMaxBD42ZgnpOdOEmHXaQj8NWEkTSl4x4pYnoQjOLKOwxFh1y/uVRCY/QhqOPw1s+MDvjSrwUKiH6zsReYpZLYAXfAeCHHoaf2ej+ly98U0tVimx7Hn6KTD82h2wmgsx0XZCg3+KHFre2o9KsArshtgl7FoZw76PzIvPki0wXEAOz3dqDQb+tt/+pvVzj25O0r8QwuF20djg4x5dbhEsdRcWS9EUC4QVAUpPB/NaNbtaff/w0rmNF4Li8ZLAsUHog4BKwbgV2ThX3WnHMnUbwEiXLadd/I4VWcRc2lqZ7WQ4pbn8LT1QSCNhOWwHFgLw1+hHVrKY7tLTSWvWArShpZj8TUbO5MlxcpotRb7BcKhfgKU1d5O3wqhu9k2cb37SVu+xhTU43jLCda0CbU2Mx4rINNHR37rQylALMMv/kNzFIoJ6B9EiiSWYRBaqRilo+AvNmMTeaPpPN6Y64PO4cnY8VIEx1vrR6nLjs4pUxQAA5P2+ZjyVdVrocvtBTMejk0DzUCBAZLMy7nK4La9d9Yfpgp4hh0KxPiL5r7t9HE53ZXL9J7fssOmMdq0u7kAR1Vk5r7NS1nIXO9IjEj8eSPTw7+UoFmZwq+YI8+dh5L+P0GaUCl9/3vhmhZ1zQOumupL0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(136003)(396003)(366004)(376002)(451199015)(2906002)(31686004)(316002)(36756003)(91956017)(8936002)(8676002)(76116006)(64756008)(66446008)(66476007)(66556008)(66946007)(6486002)(4326008)(86362001)(478600001)(31696002)(54906003)(110136005)(7416002)(41300700001)(5660300002)(71200400001)(83380400001)(6506007)(2616005)(53546011)(6512007)(26005)(38070700005)(122000001)(186003)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OFlzR20zNlhrWWVuSGFwb1RMZlB0emJqR3lIbmpidnVEdmFFRkRQMUFOY0I4?=
 =?utf-8?B?OHZvQUY3NkFOYVhMSDZVNTBMVFFCbGJDUHA3bzM1U2c3allUbTdIYStkMk5K?=
 =?utf-8?B?V2Fvd3k1QkUycGppSjBQYUtRYlBSbkVzbTVoZ1IwRUhzdk5QbFM0QmFyY2Vz?=
 =?utf-8?B?OVhEN3RpVkFYdTFaclFjbWxlTjhKL3RzQWFOOVFRQXRWdXJDaURTa1JnS1pt?=
 =?utf-8?B?bkNLckNVUnVUM0piOXdsMHNSZ0NLN0pIZUg4ZHN1SE9WVmlJem9hUUIva0ZU?=
 =?utf-8?B?NVd4RG5EY3d2dlZjempoYnlKZ1d3NVhvN0dQS0cweTJKUXVGOVFLR0hBQWhx?=
 =?utf-8?B?V0xRU3E1aW9SZnIzUFQ4R1RobmwzMnRCb1MxRm5qZVllUHB2cHZ4aU5hR3F0?=
 =?utf-8?B?dkNqdEhldmovZjFETzNNV3JKK0pmQ2h5cFROaVZINWlRM2YxSDMyRW4yQy84?=
 =?utf-8?B?Z3VpVVBEaGFpSjFodldaYk9CazZSK080cG9OTWw5MjFXdmxVZ2paMW11RFNz?=
 =?utf-8?B?R1VvaE9sZ2N6UGtLSi9LaUJWUElhNFVXYXpmZ3YvdFVTTUlEZ3I1TkRTLzVY?=
 =?utf-8?B?UDgzcGhTTHhOOFNPSzVwYWt4MXRZRWV6eVpWWWNPaXlpWGZtdDJPcTJkcWt5?=
 =?utf-8?B?SXJyTmUxaEdQRzhSQTQ5Z2RFcDZYMm52cmhWc3IvSU5uZldKKzJUQ0VYK0NG?=
 =?utf-8?B?bGo2b2M4N2R1NXZPMmxlSTFIYmxjYWJGbFFFR0IyRTdYYVh6NEZnQmk3Tzlu?=
 =?utf-8?B?VkhXWkJsWlNoV3lxTE9EMXA5Yk9kMmFqNm9JWndmcDB1eHRuS2tJcXVkdDNP?=
 =?utf-8?B?M0hyZk5KZkh1VlB0R3Jub00ybFZGbHF4MTJ4Uys5bjFJYmZsd2RzNit1RktK?=
 =?utf-8?B?QmtrSmVGYkt1WlRRNHZpNWZuTVNmZnFEeFJrOWFGLzhMcEsxWkRlSWhXakVx?=
 =?utf-8?B?WDBlUTgwTk85MlNMa3lSc2VsTm9KcmNsSERONzlqSnhQc0EwZ2srQUprdTll?=
 =?utf-8?B?Rm1ROWZqdWNnK2RIc3pqSWwvVld6WlgvTWNPdzhKSitnZjBoelN0NXQwcVBP?=
 =?utf-8?B?ckFUS2VnMkRHVEdSOXlJQ2xCUCtIMjJhMTN4TXVyeDIrb2pUZzkwNFpQa3M2?=
 =?utf-8?B?RzAyWnlmcm14cVo0dXUvMkRuQjRHcDdudG1UTEZjQ3Z3aVlZdTcveDJyaXhl?=
 =?utf-8?B?WUZ3N2FXQitocitYLzFOaFZPMXlaNnFGV3FCUXpGZlIzR3g1ZDE0WTFkdGg1?=
 =?utf-8?B?UWhUWmRKL2RxcmZtcWdFdmQyK2ZTb2tWd1ZvM2IySjI4TzNrTzBOSGZHa0w3?=
 =?utf-8?B?M0VNVnRZZFFLUE44NW5hV2NHOElmZ0tkZFZwRENXWWpwYVRXYTVGRTV4Ykc1?=
 =?utf-8?B?VVBZZk9aWXpVdVJCalQ0elA3S3RYWjR6WjVzS1htckpDRUZ6cEdhK2NQL0g0?=
 =?utf-8?B?bjIyVGFnZjNNT0oxOGpKYi9aUlQwam5TMDV2R0tFd1BYVzlJMUNJcE1xY0pU?=
 =?utf-8?B?Skw2MnlHaG40VTZKWjF4ekZjSnVJU1o2WjJyZEpnMm05QXEzekdNTWszM2hO?=
 =?utf-8?B?MEwwdFRhd2FJWUFkZUlaK1lzQkwxbDdTeEdtWkk3dnB5TDl3R1k0YU95NzRS?=
 =?utf-8?B?anBsZ3NENENiWUo5bENiRnFFMFpGNUErYlRFY3AxRkxTRzRlQTkzVXZMS2RC?=
 =?utf-8?B?dkZDU2NGSUtobVNJc2Ivd3NaZGRpOGdPY1FNK2tPdU9tQi9NZUYrNkRyK0pz?=
 =?utf-8?B?dzNrT244bE5YQm1mYmtCdFlESFlXU21YbGZDQWZNcG1UdDFoZXZrZW9lUjZr?=
 =?utf-8?B?QTdFZ2IvTGJ6am16R0gvUjNTL1RodDVlQ0xZT0Q0NW0rMlhLaXdQaFp0Vy85?=
 =?utf-8?B?cjd2RFFtNXlVdUl4M05UYzVqMVVhNm5aaHZiSEFIb2EwQVlPZU9DLzZMZXla?=
 =?utf-8?B?V2I2ekNmN0FIN09ua0Fld3B1WDNndVRUVG5zMFd0bXE1dU5OTllWUi9ERG05?=
 =?utf-8?B?TVczUlZaMk85ODJuV0ExMTdZMFVXYytKMFF4NGdrUnhvMWNLN29hWk1LdXc5?=
 =?utf-8?B?aVoyanpTK1FDczRTWTJLOWZ2NDRKWlhIUDdQcTg4MUV5aUxjekJQdWFvMzNJ?=
 =?utf-8?Q?HljZJXAOE5C3OqSGzbOYVvbah?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <B98DF20E3D00484A872489AD62A90106@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f9f7a56-c5fb-459d-afe4-08daa61d7709
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 15:31:10.7576
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: crDQzKcXgNi4xc9yYW+8JOMK+UJuo1v8EBY1wowED0V/IGbEB+TrVlN3i/P9l7Z3MhMiW+Lf3d6S0HRIW/CF5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6592
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmlyaSwNCg0KSSB0aGluayB3ZSBoYXZlIGFub3RoZXIgaXNzdWUgd2l0aCBkZXZsaW5rX3Vu
cmVnaXN0ZXIgYW5kIHJlbGF0ZWQgDQpkZXZsaW5rX3BvcnRfdW5yZWdpc3Rlci4gSXQgaXMgbGlr
ZWx5IG5vdCBhbiBpc3N1ZSB3aXRoIGN1cnJlbnQgZHJpdmVycyANCmJlY2F1c2UgdGhlIGRldmxp
bmsgcG9ydHMgYXJlIG1hbmFnZWQgYnkgbmV0ZGV2IHJlZ2lzdGVyL3VucmVnaXN0ZXIgDQpjb2Rl
LCBhbmQgd2l0aCB5b3VyIHBhdGNoIHRoYXQgd2lsbCBiZSBmaW5lLg0KDQpCdXQgYnkgZGVmaW5p
dGlvbiwgZGV2bGluayBkb2VzIGV4aXN0IGZvciB0aG9zZSB0aGluZ3Mgbm90IG1hdGNoaW5nIA0K
c21vb3RobHkgdG8gbmV0ZGV2cywgc28gaXQgaXMgZXhwZWN0ZWQgZGV2bGluayBwb3J0cyBub3Qg
cmVsYXRlZCB0byANCmV4aXN0aW5nIG5ldGRldnMgYXQgYWxsLiBUaGF0IGlzIHRoZSBjYXNlIGlu
IGEgcGF0Y2ggSSdtIHdvcmtpbmcgb24gZm9yIA0Kc2ZjIGVmMTAwLCB3aGVyZSBkZXZsaW5rIHBv
cnRzIGFyZSBjcmVhdGVkIGF0IFBGIGluaXRpYWxpemF0aW9uLCBzbyANCnJlbGF0ZWQgbmV0ZGV2
cyB3aWxsIG5vdCBiZSB0aGVyZSBhdCB0aGF0IHBvaW50LCBhbmQgdGhleSBjYW4gbm90IGV4aXN0
IA0Kd2hlbiB0aGUgZGV2bGluayBwb3J0cyBhcmUgcmVtb3ZlZCB3aGVuIHRoZSBkcml2ZXIgaXMg
cmVtb3ZlZC4NCg0KU28gdGhlIHF1ZXN0aW9uIGluIHRoaXMgY2FzZSBpcywgc2hvdWxkIHRoZSBk
ZXZsaW5rIHBvcnRzIHVucmVnaXN0ZXIgDQpiZWZvcmUgb3IgYWZ0ZXIgdGhlaXIgZGV2bGluayB1
bnJlZ2lzdGVycz8NCg0KU2luY2UgdGhlIHBvcnRzIGFyZSBpbiBhIGxpc3Qgb3duZWQgYnkgdGhl
IGRldmxpbmsgc3RydWN0LCBJIHRoaW5rIGl0IA0Kc2VlbXMgbG9naWNhbCB0byB1bnJlZ2lzdGVy
IHRoZSBwb3J0cyBmaXJzdCwgYW5kIHRoYXQgaXMgd2hhdCBJIGRpZC4gSXQgDQp3b3JrcyBidXQg
dGhlcmUgZXhpc3RzIGEgcG90ZW50aWFsIGNvbmN1cnJlbmN5IGlzc3VlIHdpdGggZGV2bGluayB1
c2VyIA0Kc3BhY2Ugb3BlcmF0aW9ucy4gVGhlIGRldmxpbmsgY29kZSB0YWtlcyBjYXJlIG9mIHJh
Y2UgY29uZGl0aW9ucyBpbnZvbHZpbmcgdGhlIA0KZGV2bGluayBzdHJ1Y3Qgd2l0aCByY3UgcGx1
cyBnZXQvcHV0IG9wZXJhdGlvbnMsIGJ1dCB0aGF0IGlzIG5vdCB0aGUgDQpjYXNlIGZvciBkZXZs
aW5rIHBvcnRzLg0KDQpJbnRlcmVzdGluZ2x5LCB1bnJlZ2lzdGVyaW5nIHRoZSBkZXZsaW5rIGZp
cnN0LCBhbmQgZG9pbmcgc28gd2l0aCB0aGUgDQpwb3J0cyB3aXRob3V0IHRvdWNoaW5nL3JlbGVh
c2luZyB0aGUgZGV2bGluayBzdHJ1Y3Qgd291bGQgc29sdmUgdGhlIA0KcHJvYmxlbSwgYnV0IG5v
dCBzdXJlIHRoaXMgaXMgdGhlIHJpZ2h0IGFwcHJvYWNoIGhlcmUuIEl0IGRvZXMgbm90IHNlZW0g
DQpjbGVhbiwgYW5kIGl0IHdvdWxkIHJlcXVpcmUgZG9jdW1lbnRpbmcgdGhlIHJpZ2h0IHVud2lu
ZGluZyBvcmRlciBhbmQgDQp0byBhZGQgYSBjaGVjayBmb3IgREVWTElOS19SRUdJU1RFUkVEIGlu
IGRldmxpbmtfcG9ydF91bnJlZ2lzdGVyLg0KDQpJIHRoaW5rIHRoZSByaWdodCBzb2x1dGlvbiB3
b3VsZCBiZSB0byBhZGQgcHJvdGVjdGlvbiB0byBkZXZsaW5rIHBvcnRzIA0KYW5kIGxpa2VseSBv
dGhlciBkZXZsaW5rIG9iamVjdHMgd2l0aCBzaW1pbGFyIGNvbmN1cnJlbmN5IGlzc3Vlcy4NCg0K
DQpMZXQgbWUga25vdyB3aGF0IHlvdSB0aGluayBhYm91dCBpdC4NCg0KDQoNCk9uIDkvMjYvMjIg
MTM6MDksIEppcmkgUGlya28gd3JvdGU6DQo+IENBVVRJT046IFRoaXMgbWVzc2FnZSBoYXMgb3Jp
Z2luYXRlZCBmcm9tIGFuIEV4dGVybmFsIFNvdXJjZS4gUGxlYXNlIHVzZSBwcm9wZXIganVkZ21l
bnQgYW5kIGNhdXRpb24gd2hlbiBvcGVuaW5nIGF0dGFjaG1lbnRzLCBjbGlja2luZyBsaW5rcywg
b3IgcmVzcG9uZGluZyB0byB0aGlzIGVtYWlsLg0KPg0KPg0KPiBGcm9tOiBKaXJpIFBpcmtvIDxq
aXJpQG52aWRpYS5jb20+DQo+DQo+IFNvbWUgb2YgdGhlIGRyaXZlcnMgdXNlIHdyb25nIG9yZGVy
IGluIHJlZ2lzdGVyaW5nIGRldmxpbmsgcG9ydCBhbmQNCj4gbmV0ZGV2LCByZWdpc3RlcmluZyBu
ZXRkZXYgZmlyc3QuIFRoYXQgd2FzIG5vdCBpbnRlbmRlZCBhcyB0aGUgZGV2bGluaw0KPiBwb3J0
IGlzIHNvbWUgc29ydCBvZiBwYXJlbnQgZm9yIHRoZSBuZXRkZXYuIEZpeCB0aGUgb3JkZXJpbmcu
DQo+DQo+IE5vdGUgdGhhdCB0aGUgZm9sbG93LXVwIHBhdGNoc2V0IGlzIGdvaW5nIHRvIG1ha2Ug
dGhpcyBvcmRlcmluZw0KPiBtYW5kYXRvcnkuDQo+DQo+IEppcmkgUGlya28gKDMpOg0KPiAgICBm
dW5ldGg6IHVucmVnaXN0ZXIgZGV2bGluayBwb3J0IGFmdGVyIG5ldGRldmljZSB1bnJlZ2lzdGVy
DQo+ICAgIGljZTogcmVvcmRlciBQRi9yZXByZXNlbnRvciBkZXZsaW5rIHBvcnQgcmVnaXN0ZXIv
dW5yZWdpc3RlciBmbG93cw0KPiAgICBpb25pYzogY2hhbmdlIG9yZGVyIG9mIGRldmxpbmsgcG9y
dCByZWdpc3RlciBhbmQgbmV0ZGV2IHJlZ2lzdGVyDQo+DQo+ICAgLi4uL25ldC9ldGhlcm5ldC9m
dW5naWJsZS9mdW5ldGgvZnVuZXRoX21haW4uYyAgIHwgIDIgKy0NCj4gICBkcml2ZXJzL25ldC9l
dGhlcm5ldC9pbnRlbC9pY2UvaWNlX2xpYi5jICAgICAgICAgfCAgNiArKystLS0NCj4gICBkcml2
ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21haW4uYyAgICAgICAgfCAxMiArKysrKyst
LS0tLS0NCj4gICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3JlcHIuYyAgICAg
ICAgfCAgMiArLQ0KPiAgIC4uLi9uZXQvZXRoZXJuZXQvcGVuc2FuZG8vaW9uaWMvaW9uaWNfYnVz
X3BjaS5jICB8IDE2ICsrKysrKysrLS0tLS0tLS0NCj4gICA1IGZpbGVzIGNoYW5nZWQsIDE5IGlu
c2VydGlvbnMoKyksIDE5IGRlbGV0aW9ucygtKQ0KPg0KPiAtLQ0KPiAyLjM3LjENCj4NCg0K
