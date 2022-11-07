Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8097861F6AD
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 15:54:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbiKGOye (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 09:54:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231486AbiKGOyd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 09:54:33 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2075.outbound.protection.outlook.com [40.107.212.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC95AFD32
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 06:54:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e2Lf2IuhXXqqmqHvSTY7YYKpu8xukfMfi4EkRQgLfvHSt22QVnyYMz94h+ckr/0Cs2S2AmhBbg0Dbny0/PirB6DBe6ERPmZfaF389CvuLV0mTiOtJZ4qRnDQ51PTveFXd7KCsvWT9RkX5t1AvMM/juwnWEyh6mCfg05hCxPlwI7KdulWqsRgI3FF5ZfrmI0WYDFRgj6CC1TMZKPA/M00uzQXU3saPahL5DniMAHOMpuspa0KRiMhpBG1FRUctbe2EwjrUymmwpf/HnsmpV3+MXpeYW2ii/8l9z7UbBzYTdGyc/aiUZhlo1nfBdIcs4sgpPeG2S+Yd8q0BJjA1vHyRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z2yQoGGooJpGUpflUtPlpEtKFBcr87Vk8I0h3lXBcFw=;
 b=AqC8aWc4+CnbjcY3trDf2ONnnkb0QzSMe4iBiAJBsuZX05Lhl4tFeXQvgpUvOpUhJXBHEOqWS3lwX1wMrnLZdAdXv8wzdXmrB6yOMb3fladILwTfGHRcI4Q6HXrQjwgFvLJOflrAegaDgN2D4r8lLV5qVHPIpSOGVJimpvDEpHdYOn0RLxiQa9b5vg64F9rQKA13QlzQZJ7nIbd26U9+osTPcqSMbmU3SLcbOp1H1Aurg8JskJQk3bE1323JQaezcqnl1Be63gVxWRj5/8Tu1RfHM+Z2w5EdHDSmu1HvvSYIUg4Ht15+9NG0Vux95wjZcYI3vt+kC/6DAERF68x6zA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z2yQoGGooJpGUpflUtPlpEtKFBcr87Vk8I0h3lXBcFw=;
 b=Pxkm8I8wRD19s8QKf3xrvsVzMGhm4xf2iXT5qzRUE5Z85nlU4jtqXfLgFFzLF9NxpUSeEKOGlXC75zoZHUHgGCOon/4oZY5ys6ZnTr1aAwAXb3B6fnVbGTROtB24gK6GgMRNnECp4il5NXXyrfnCJsl11k3ieaMs8ZEWuSXJ7Io=
Received: from PH0PR10MB4615.namprd10.prod.outlook.com (2603:10b6:510:36::24)
 by DS7PR10MB4909.namprd10.prod.outlook.com (2603:10b6:5:3b0::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 7 Nov
 2022 14:54:29 +0000
Received: from PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::f1fa:376b:b2ee:1b29]) by PH0PR10MB4615.namprd10.prod.outlook.com
 ([fe80::f1fa:376b:b2ee:1b29%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 14:54:29 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: NET_RX_DROP question
Thread-Topic: NET_RX_DROP question
Thread-Index: AQHY7425gopL1im9FEG80NeHfAHo8a4zko6A
Date:   Mon, 7 Nov 2022 14:54:28 +0000
Message-ID: <db2af4c2d70fb2582fbf5e27a31052d9d9c57953.camel@infinera.com>
References: <7dceaec046d54e8db9cefb2e3b198f25765f6d8e.camel@infinera.com>
In-Reply-To: <7dceaec046d54e8db9cefb2e3b198f25765f6d8e.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.4 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=infinera.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR10MB4615:EE_|DS7PR10MB4909:EE_
x-ms-office365-filtering-correlation-id: aba8356f-1c99-4c4c-f2b2-08dac0cff8c1
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: C+g/NMRwr/VbgG1tt2fFBSGAT+P5ogjqq72g8ykQhiWf1cW0T0GtDNEyyq6DAXBn1ouEBm/iHrHDSRQTuVriQrBLdTUK80CRUVvf02v2gAeuuQzTmbOnzc7IfjqYsWi7SOsnG5G803D17luWnQI+rnxVBr/HHCCMIac+lBZYDvYSgs346nqvNrzwbc5ci1l49/ptzeumX8tAPHn0MkXfvDho+6mvib+DJlmylVe3vl444Z/AD9PbDC9mySaWwZXw3pRtraGDyfJXr/4xCFvUSagLZVrjU+F5p1zTDL2cF8FPHZ8n9cRW/QjKSTneC3TB4xexyIhutL4wnNLdWf4SpplUqlxzVbHPtfPaKnHiQ7LMteoWM35Kk2cWPOqCAU3VhoETNYVHY/AjSyfLzOfywjbgxrkzrdNcehQ1I/DBMB9Hz8KQ0zWZUWLemg7w5JY72W4TLsv4x8GLA6iBvdICcTWXy6fC6SaOZcCnDW49fXRwd8MMouDs2LNJr9b2J3Dew4yoL4XfwuU3Z58XPPx46i71bSPrfRM0T5zAtAhn4b/EO1Mim5/j5nFhWp3Zcu+xskm9VdKEdJ9PiXtILEpkH3G0lYWx71XjhWmMwXDFJND6s+shwz6+b39y1io73unG14nCqj/qu5I4uBBgATkueZ+Cl+TfCKSrU/sP833NSu91MeIFui9JG0hZ0ug5oo3pu8Q8Jo/sUZ4WcbTB3Xc6CmAjsN4D1tmFb27fMWRsYPjn3PC3Uvh4+HvYRFaRlF173haQedUmL9oky2K57MTr3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4615.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(346002)(376002)(396003)(136003)(366004)(451199015)(6916009)(71200400001)(316002)(8676002)(36756003)(2906002)(91956017)(76116006)(66946007)(64756008)(6506007)(66476007)(66446008)(66556008)(83380400001)(26005)(6512007)(2616005)(186003)(38070700005)(478600001)(6486002)(86362001)(122000001)(38100700002)(8936002)(4744005)(5660300002)(41300700001)(7116003)(66899015);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dUh6NHRZZ09iZ1FwU2NySW8rTVhCZmxxNzFLTmJTc3MySXFrVFM5RERUZUpp?=
 =?utf-8?B?b3RpUFEvUk81Z3MrRHVtc1owcG12UHUvTS9tY1JEdkRJMDkweFgrNW1rdlpR?=
 =?utf-8?B?cVNXTjhmVFhOMlJTL2hLbGZoOG5MZXk1YnZTYVZ1dmcrb2F6SDhLcmRycUpo?=
 =?utf-8?B?VW91aDlCRk1HRGlWQUZiYURlUUFPRGhQQzA5R2lvWDdrbnhKbG5FcDdtcGM2?=
 =?utf-8?B?Nmp6SFZva0VBVlp3TENGVVArUU4ydWFvWGROeDNleXl6bEQyVGdJdHpiNEhF?=
 =?utf-8?B?aFBTeE9vRTBIRUh1TTgxTC9MZnNSMnBnclhjN2pSWThTdGZrVzVqZEhXYkRC?=
 =?utf-8?B?bEdHWVV2c3E3eVEwQUhnNUYxbGlWYXpKZ2w0cy9USFltM1BwR2J0UHFJeUhw?=
 =?utf-8?B?SjRiUnFVb0RrL1VSVzFEZi9Bc3ZQYmQ5MkZQVk0rZTN4bHBuWmJCMGZ5cmZ5?=
 =?utf-8?B?UW9WajkyajRJZVk0cTU4NUpPbzhUTmIwa3JBTUxiVjlZUitRQ2I5OUhtd0Z3?=
 =?utf-8?B?RFNHWUxORVVMVGRnR00weERiY2I4UXg5djQ3R3ByUTBUYjFOaVVGM1pZMm4v?=
 =?utf-8?B?bFBPTmx1eGY4QmJCL2dqMjJwSkltbTZRU3JxN2dnY2Zva3Q2YnJPU2pGMVNQ?=
 =?utf-8?B?Umd3Vm1ONkNVUlZITWlGSlhJVGVwWExPMkYvdUhYdE9DdFhvVzBxRVhSc1hL?=
 =?utf-8?B?RjMreVAwVzBrYU12MVU0ME91WHpYL1d5S2JTcWZGTjdWK2pIRlZueTMwYmFG?=
 =?utf-8?B?TjE4N0JxbUx0aUVWbUZWR01xSlVLaEpnRk5vYTZ2VXU4Q05peTcvNzJ5Nkdl?=
 =?utf-8?B?dXM5bGQxSzN1emJnU1JqSlBUNUZ0Rk5uMjNDd0dVOTdXNkdmQkVXQ1BGQmx2?=
 =?utf-8?B?OG5aYkEvcmZJTU5SOEkwd1lGdXVNZlZRMlVqVlNqdnlsUlRhbmZDTHNrcjJJ?=
 =?utf-8?B?NVZ3TkI4SThlYjF0QktBcGxOYjNKcys3cndTTmZnNCtPNzlFNmZIbVJpOENX?=
 =?utf-8?B?WlFWWGRtVnprZW9lMnZiU3BFcjVKcFphNm1nR0J1cXY2aHZVN2NQdGJnVnNK?=
 =?utf-8?B?NnhnV251dGdacmVFZC9sck4rVXk2UzV4akVuV2QxZWxvTUZzdDRjeWVxZ3Fi?=
 =?utf-8?B?RGhKcVpDZ0daakpzMlJIQXFocnBieDIxKzdoTHdRSmtDS1Zra3ZXejNXeUVP?=
 =?utf-8?B?R1QzVTQzTkNOemUzWndjdmhHZVVrZDBIdSt3T21EUUcxbjlzQVZLYlBkWm9N?=
 =?utf-8?B?ODRQRnpDRWFNbU1kL0ZVOXZqUTh6b0ZqM0NhZ0NzVHEraVI3cDU0U3gydm1q?=
 =?utf-8?B?SEE4ZW9IRDNNNURsQ0pCVy9LenlhNkUxYmd4cUxVV2grSCtpaFU2T3Q2QldD?=
 =?utf-8?B?VkNLeGpwRzVSb3BERkdmMWtuT2w2b01lSmVDNUxJMnJOZHl2SldkanI1cG04?=
 =?utf-8?B?ZXo4cUFBRWg3dDVsRjBTQ21Gaks3a3hQcmNaUVRDVzhjZUxtQnlobWFGQklh?=
 =?utf-8?B?UyszRnJ3QjYzRWRCTzV6VE0zY1FNMGc2SElzU3k1akI5bUd6R2o3TUJBVkZ4?=
 =?utf-8?B?VXVWdERtS3kwMUNJZ0FOZ1BsMDVsYTJFQVcybVdFWHlqWkNaTTJXbzd3N2h4?=
 =?utf-8?B?TTN0ZXhiVVNFaUFyeUtoUnl0U0plY2VkQ1Q4SlhIYWlXR2h1N3NYdzNhRVF5?=
 =?utf-8?B?RUJ5OXJZWmo2M1NQdzVUVTNnZWVBNi90clY2YllubStKSnZSWXVpa2pxMm5m?=
 =?utf-8?B?UTRnSGpvSE5LWHhkMmFKa1A0VHpjcjd3cGk5eXdIMWtNbjJ3ZVF3WGx6M0dm?=
 =?utf-8?B?ZzhQZnBRV0JpWkd1MFB5SnBpUlFqRWlkWDZxUThqdWp1U0tTRjhDdHdnTHJm?=
 =?utf-8?B?K3NuQmg3dVo5SGZDRXFnc2c0MS9SeDh5Q0NyTDYrMU1VcVB3MFora2drbTdF?=
 =?utf-8?B?UVEyTDNsZ3h4ZDV5cXptY29lN3hEckVYZHRZQnBwSG5wWDdKV0RxVGhXWEs0?=
 =?utf-8?B?VG1sdWhlOFhaNWVnK1Jzd2RyNDRBd3o3MzZWbW95RXBvMklXSndIRVBnVkdn?=
 =?utf-8?B?bTg4WEFVaTRFSkxGVzhqZEhSVUVSVWJVeXpvUkZwL2ZBRzdIb0xzN1NwWlVD?=
 =?utf-8?Q?t8U61flNQxE5Z6+OUdvW7b+Bu?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A470078B790FF14EA21A842620FC3796@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4615.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aba8356f-1c99-4c4c-f2b2-08dac0cff8c1
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2022 14:54:28.9944
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PufKOvGgFYQ++aInmXHe/lkD3maUER9jnDWo1LHaW/DfRQLv4PmEjwiMNKYYZVUtEabdoWkA+2GQhQlcM/5VbA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR10MB4909
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTAzIGF0IDE1OjA4ICswMTAwLCBKb2FraW0gVGplcm5sdW5kIHdyb3Rl
Og0KPiBJbiBvdXIgZXRoZXJuZXQgZHJpdmVycyBSWCBwYXRoIHdlIGhhdmU6DQo+ICAgaWYgKG5l
dGlmX3JlY2VpdmVfc2tiKHNrYikgPT0gTkVUX1JYX0RST1ApDQo+ICAgICAgcHJpdi0+c3RhdHMu
cnhfZHJvcHBlZCsrOw0KPiANCj4gTm93IHdlIGNhbiBzZWUgZHJvcHBlZCBjb3VudGVyIGNvdW50
aW5nIGRyb3BwZWQgcGtncyBidXQgd2UgZG9uJ3Qgc2VlDQo+IGFueSBjb3JydXB0IHBrZ3MgZXRj
LiBJcyBORVRfUlhfRFJPUCByZWFsbHkgbWVhbnQgdG8gYmUgdXNlZCBsaWtlIHRoaXM/DQo+IEl0
IGdpdmVzIHRoZSBpbXByZXNzaW9uIHRoYXQgdGhlcmUgaXMgc29tZXRoaW5nIHdyb25nIHdpdGgg
dGhlIGRyaXZlci4NCj4gDQo+ICBKb2NrZQ0KDQpMb29raW5nIGludG8gZHJpdmVycy9uZXQvZXRo
ZXJuZXQgaXMgc2VlbXMganVzdCBhIGZldyBjaGVja3MgaWYgKG5ldGlmX3JlY2VpdmVfc2tiKHNr
YikgPT0gTkVUX1JYX0RST1ApLA0KdGhlIG1ham9yaXR5IGRvZXMgbm90IHdoaWNoIG1ha2VzIG1l
IHRoaXMgSSBzaG91bGQganVzdCBkcm9wIHRoaXMgY2hlY2suDQoNCkNvbmZpcm1hdGlvbiBtb3Jl
IHRoYW4gd2VsY29tZS4NCg0KIEpvY2tlDQo=
