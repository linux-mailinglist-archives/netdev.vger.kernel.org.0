Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABE158A9D4
	for <lists+netdev@lfdr.de>; Fri,  5 Aug 2022 12:59:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237607AbiHEK7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 06:59:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbiHEK7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 06:59:45 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B653B7435A
        for <netdev@vger.kernel.org>; Fri,  5 Aug 2022 03:59:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f011rkutmmHuWunGew3RQbFtRjvzWGSQ2Y6fljwiut5KpX7eQpR1+RjVe/uTv03zu9AfgEMBAhkMw0y1b+MKSaGNmjSE8vzGaOS1jmRSRcUojRLz5WHIJYTmGQPbVjUhLZZ/DXV04tb9UE5uZlDbgRsTRruVzT2HF4OwiNH3D8VM6d1rhVTCqgf8jhoJMjP6/vUG14avtTYp1OBLicuJVmqboldyWSxHYlU6t6SytOK32tdBOzwyiydCCkqQ1X4VQcF5bo/TqK2+5hFDsAwiASUFm4f+JBdxM42Y0NhIKnaF/dFjoecRyfhfreUsLWeEe7kY1Team03OoL4OcGAdKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FxWGOUJrARHgD0xcZBkJRfDwhjTuA5BaZqB/fuPMXRM=;
 b=D3tI07+KO70jSTQEJfby18TgimJIz1+zhis1E6C9TLoiuK1FzBBXupaeJO5g1ulfQDfkG9Q26LOO8J9Qu/JmVtObZ8Utni8vLMj/Av7wYdAtE2gKdP3vJEN5tyB1Q49TnyGgloFJjLo86G0LP/sCj5SZIBZvJ4shM0G1unQELF/yctWO2jGOFBO2x7ol0jvutqIY4LKtGhbhWOpGmAkBUfhP/tAyBw8FK+3SPVC66NnUe2rGEirAO7ikYwSgWKczTyJWAZ5IhQwMIfhTqzl4dNV+hFvzteaQbyCA3Z5VbXlEhXLBQ/zt2HXxlqmHIljB945Z+lK3H59SIcf8FfFmBQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FxWGOUJrARHgD0xcZBkJRfDwhjTuA5BaZqB/fuPMXRM=;
 b=n8cKaIDoGSNWndFOrTbFSycLKbqFi0oOJ2zbe8nJ0dZx/jJMywimx05jB5bFns+QnCdhyIeB7aU4Eqzag/fbcTE0Xz6GqYNpCAHUpXYDVxsW60PofDMB6esSvhFfSIsIElbwO0LcjsDgo/0oC+QHxWn0CKP+Y2g8mip7yZgnsXblWzFTpTSjnWf68vL22+YQyVuEYOC2AX3sgyBoeP9tTy11+erkweEmYLnIGDacxxcuqIEJKgZ+UrSICMPGjx8cfvEo3i87ROy+6qPYlHZh0aD3fM457i9ygh9EqMhiiIk5MuhHu1Yk5xoSpabfk7/Ilv3cSUtaz0mgRT5WD3qkFg==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by BN6PR1201MB0113.namprd12.prod.outlook.com (2603:10b6:405:55::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5504.14; Fri, 5 Aug
 2022 10:59:42 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::205d:65ed:1439:d135]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::205d:65ed:1439:d135%7]) with mapi id 15.20.5504.016; Fri, 5 Aug 2022
 10:59:42 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Thread-Topic: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Thread-Index: AQHYpXzdw3PxP7W5AU+7nUMUJ/fFua2acr2AgAESDYCAADvKgIABLLWAgABYVoCAAB0+gIABBPQAgACIwQCAATlfAA==
Date:   Fri, 5 Aug 2022 10:59:42 +0000
Message-ID: <00c2fcb5718e59511eb87936219c9b4324a9de2d.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
         <20220801124239.067573de@kernel.org>
         <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
         <20220802083731.22291c3b@kernel.org>
         <8bf08924a111d4e0875721af264f082cc9c44587.camel@nvidia.com>
         <20220803074957.33783ad4@kernel.org>
         <20220803163437.GF2125313@paulmck-ThinkPad-P17-Gen-1>
         <dc8a86b89350e05841aaecfba5939cfb63a084ba.camel@nvidia.com>
         <20220804091804.77d87fcc@kernel.org>
In-Reply-To: <20220804091804.77d87fcc@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3200a0fb-d941-4e10-cfd6-08da76d199b5
x-ms-traffictypediagnostic: BN6PR1201MB0113:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YfrgDjem7iL3TcuF5I9qxnarnckSxXb8Ubrz/zC6Kq8vQja42lrmnuvXBw2lYYkB67XjPLrKT8z6CYh/uBjaJGRf801dUxZdXjL5QK3SE95+29fPKnUK4+M2E6wgnD0vkIoXimBKRGYJ8PZQSjr19ZtORiKNIeShdrv46HkAhBJCi0KwX4nuY+qjT6+cuRXRvWdYHlCnq0AhQIw1KVKHjgbtDCWZtO+zU9gtYXDkPqHP5sw3pTP6kscmxIezS+jVVrQrUnE6ER8ZPzclVI7+T/OhurZsC2TVHDqACPdp0k7w+6uLjuZsdkl+HvaR2YHecYg0KIZktY6S32YbDHQrWeqLcpxYY2gN6O4/8RMCIZjLig1Nc6rE4wdoPQntLQkfIYumQMBOOWLjCMWy88ucn+SbWVHtW+BEKDp0m113+EAy+Mga7y5KlA3scBegFQFcwLgCnvOh+CQsdPbuagAoUc5oPm3DKIbsJwGz8oFN62LlI9vSxMc+gyoKxidKpRk/6o90KWZlKFMn0YMBGAIc7MkTV5xI0m2efUcITncGEkQ5WjVZXOKpMYhHYgIHT362toJ7xqe4r/SwIXrvWWYthMC6elKa/7/ypYNWIhuZ1xFUOvqshbR8YItg0fdmwSeyA0qz76J+vx7aW/BPWpsZ9rc6TOe9OigeXwHjQdXuJ6nByafFWU3XsiWPwJi8qCyM2WhPkjuu524zBlHnWbgYZ8sXzFavh8ZaqTcTP9bVvh509MHJFP6f7z0ANtX9IvdRySefXxjt9oW4FPNWYBA5CV4oUxQv2HH6fzue9gbDE1D9S48o19W+wOuPy2WKwu8i
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(376002)(396003)(136003)(366004)(2616005)(6916009)(6506007)(5660300002)(8936002)(478600001)(36756003)(316002)(83380400001)(41300700001)(54906003)(107886003)(86362001)(6486002)(122000001)(2906002)(186003)(38100700002)(6512007)(66556008)(8676002)(66476007)(38070700005)(76116006)(4326008)(71200400001)(66446008)(64756008)(66946007)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Qm5idnpjVk0wSmMwa2NDNjkxMGppRDQvVkFzbThiWnhpQmJHWUNobnJIcktl?=
 =?utf-8?B?eEZ4emNqY3JldWhBb3c2cjNaL3VqMDJvVHp2dWhUM1kxQUxlOWFCSTJYWC8r?=
 =?utf-8?B?c0RQREFwNkI3b3Y0WjdZUkxRang2d0RuSVhQT0MxN1F0RS9ZYlRqQnhFQ0pj?=
 =?utf-8?B?cXlOMTAxdzJyRlZOQXlLT0thbm5iQTZ1TmZSMTVxTDhYMDk4ODNhdTY3cThX?=
 =?utf-8?B?MEZZSHkwMEtYSE00Q3FjL1U0dmVzclRESE9MSDI4dU5jOXFsd2F4VmgxeTRE?=
 =?utf-8?B?UDFoQXRQZnViR2V2VUhkdTRvVUUwSGw4SXJmZDhjbDlGSENtV3FTMGw3Kzcw?=
 =?utf-8?B?WU11cGh1eTRmVStCckZhSStTTjBBYVRKR205czdFUXJxSXZiTjdiSGkxMnM4?=
 =?utf-8?B?SkFnNmFyQzMvRDlhQ0c0c0JJa0NjYnBud1ZXWmxQL2txTk81VGpyWXorK0pR?=
 =?utf-8?B?UVN6MkorVytiQlRCaG02ZGNQMENteUtPeFhOdWZxYTZIR2RrMjR4dXB4NW8w?=
 =?utf-8?B?RFZwRUF5U0llblBZOHBJMDFWRmVaK2FvMmtHWmlUdGhGV0RsQ0NIQkhkc1pt?=
 =?utf-8?B?OEhuZmhYd0MyNUozK0xBYXVrU2lkU0ZFaW1JKyt2RDBBczB6SEZ0R0x1YlBp?=
 =?utf-8?B?aW11eEU4OXBmZWdQM0ZGUkpWZGwwODBmKzBPOWtZSUVKUUpWWEM4SzJpbktk?=
 =?utf-8?B?azhFWDVabjNNZGNCU3J3YlY0eDNXa0E3SU1Ba3NwVFpjQ014WC9WYlBwdlpM?=
 =?utf-8?B?amtHRnIxUjE5bmo5am55bzJuMyt6Mmw3MHZSU0E1MFNqYzV6d3l0T2x5bCti?=
 =?utf-8?B?N3dWRU1EQ1Yrd3AxazViak5KQVJ6UDMxSm12RDRaWDFDNmJWTFd0V0x0bnd4?=
 =?utf-8?B?K3pRbi9KcE1VRFVCRjlLMW5WbTFyd2FNbEJlcE43R0pveDgwQVkvTFM4QW84?=
 =?utf-8?B?MWVud08wS1d4Uk0za1ZXc0dmaW5YRGVUZ1QvZ0Z3TWRWMlk0WGxtb1BUOWFC?=
 =?utf-8?B?Tm8zR0VpMjcrdnVWeGVSOGhKMnh5b0dtakxuYlZON1NqbWp5TXNQeTNTbDRp?=
 =?utf-8?B?TjJheHdiQURSV1NhTVRlKzhDdDMyT2ZyMmZMYWxKeEFjUlQ3eUJwSjZoUWVR?=
 =?utf-8?B?QUdYdm9QU05LZzVhTzlEUXQ2cjljSUtXdllMNUNrTzh3c0JFNUtFR3RIdFBU?=
 =?utf-8?B?dEYyMHFuODJFVGh3aXQzVVpwR3h6eFBxdzhIclV2T3hhT0luamxvNUFMQklw?=
 =?utf-8?B?NHNmMDZlL3FVb2R3WjJiSDd2Njl3cXRCZldBamtMTTcyMlMxSzh6N29RRzlC?=
 =?utf-8?B?bzRiQnYrTzdzc2lSd1prZHFLbnBtZ2orOWZYbkNnekV2RUFoTDRxRUpCTndm?=
 =?utf-8?B?d05FNmpYYW14RGNKWjJHVFpRWGxwaGw3WUJHWUJsZ1AyQUt0WTdVOTZNdDcy?=
 =?utf-8?B?djJyWTJpNFFnR2toUC9RUGg3U0kxZTMzOGZPRHBzM0xYckc4ampaTFN1MGxC?=
 =?utf-8?B?Z2ZmcnJlNUNSKy85WXV5M2ozaU85WDI0SklvTjV1SDUvdkhsNU9Bcy82dWdG?=
 =?utf-8?B?dFVSZWVaeElYdlF3aFp4RHB4S0Y1NzNCbCtNV0pLOUdPVDZrUWtqNlZ2UEUx?=
 =?utf-8?B?ZkRqOXgrS2RpSUFPSFo4L0kvQnRKRVJFWVVTbGtBNXlZMTJ4UlN4MG84bzNp?=
 =?utf-8?B?UWVSeFQwUFg3a25laHhJN29HbS9GbmNyd1BPM01uSFlvdHZGOWM2K05CK04r?=
 =?utf-8?B?UFhFb1VqRjRQbHk2bmIyTlNUMitNajJJS0tYdURNdVhnb3c0ODcxNGh0TUpN?=
 =?utf-8?B?UzA5MGdpWlkxeXZuUkVJemxaM0J4dVM0L0lCVEZZZ3V4Sjcwb3cxWmhPZEwz?=
 =?utf-8?B?SlM1N3BwS0l1Mm8wZDF5R1BRQ2w5aldkaEpkWTVMMHl0QkZpbENta3N4bWhD?=
 =?utf-8?B?ODFzUEhnQ09LVFYyc0l6NDVFcWFhRHY5WkNTL1h1ZW83czk4WWp6V0xmUGFB?=
 =?utf-8?B?bG9hcXhqNzFIa1B6MlkrdkYvczAwRDZaRjQzNDhJU3E1TDE1d21Bcjc4QnU0?=
 =?utf-8?B?NzJtUk1vL0Ixeng3TzNYR2F0MW5USm5rdEltU2l0VFJkK2dudTJJa1BvN3Vp?=
 =?utf-8?B?bVVGMjlSSWJOVXhFWnZTaFViZkg2VFNMRUFrUlV5TklkWEwrUFhJZG8yRFJW?=
 =?utf-8?B?MHFXMVBvc21KcmRZdnJyVU5NaDhQclFkM2V6WkxFUzRqWFNMYVFqb1JoWC85?=
 =?utf-8?B?aU1RZm00NmlSeVpXSlg3a1BQS1JRPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <63614CC67CDBE54F89F1E8A2E9AD4ECD@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3200a0fb-d941-4e10-cfd6-08da76d199b5
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2022 10:59:42.5105
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dvnH/k51k1zZ3FcWu7gH3sJd554ZKyOAGm49Vx3Pyqn6JTUSCoWit4xQKpskDcMLDu5gwtpfoJV2O+yGtYJzEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1201MB0113
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA4LTA0IGF0IDA5OjE4IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCA0IEF1ZyAyMDIyIDA4OjA4OjM3ICswMDAwIE1heGltIE1pa2l0eWFuc2tpeSB3
cm90ZToNCj4gPiAyLiBjdHgtPnJlZmNvdW50IGdvZXMgZG93biB0byAwLCBubyBvbmUgY2FuIGFj
Y2VzcyBjdHgtPm5ldGRldiBhbnltb3JlLA0KPiA+IHdlIHRlYXIgZG93biBjdHggYW5kIG5lZWQg
dG8gY2hlY2sgd2hldGhlciBjdHgtPm5ldGRldiBpcyBOVUxMLg0KPiA+IA0KPiA+ICBpZiAoIXJl
ZmNvdW50X2RlY19hbmRfdGVzdCgmY3R4LT5yZWZjb3VudCkpDQo+ID4gICAgICAgICAgcmV0dXJu
Ow0KPiA+ICBuZXRkZXYgPSByY3VfZGVyZWZlcmVuY2VfcHJvdGVjdGVkKGN0eC0+bmV0ZGV2LA0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICFyZWZjb3VudF9yZWFkKCZj
dHgtPnJlZmNvdW50KSk7DQo+ID4gIGlmIChuZXRkZXYpDQo+ID4gICAgICAgICAgcXVldWVfd29y
ayguLi4pOw0KPiA+IA0KPiA+IEl0J3Mgc29tZXdoYXQgc2ltaWxhciB0byB0aGUgInN0cnVjdHVy
ZSBpcyBiZXlvbmQgYmVpbmcgdXBkYXRlZCIgY2FzZSwNCj4gPiBidXQgaXQncyBlbnN1cmVkIGJ5
IHJlZmNvdW50LCBub3QgYnkgUkNVIChpLmUuIHlvdSBleGFtcGxlIGFzc2lnbmVkDQo+ID4gbXlf
cmN1X3BvaW50ZXIgPSBOVUxMIGFuZCBjYWxsZWQgc3luY2hyb25pemVfcmN1KCkgdG8gZW5zdXJl
IG5vIG9uZQ0KPiA+IHRvdWNoZXMgaXQsIGFuZCBJIGVuc3VyZSB0aGF0IHdlIGFyZSB0aGUgb25s
eSB1c2VyIG9mIGN0eCBieSBkcm9wcGluZw0KPiA+IHJlZmNvdW50IHRvIHplcm8pLg0KPiA+IA0K
PiA+IFNvLCBob3BpbmcgdGhhdCBteSB1bmRlcnN0YW5kaW5nIG9mIHlvdXIgZXhwbGFuYXRpb24g
aXMgY29ycmVjdCwgYm90aA0KPiA+IGNhc2VzIGNhbiB1c2UgYW55IG9mIHJjdV9hY2Nlc3NfcG9p
bnRlciBvciByY3VfZGVyZWZlcmVuY2VfcHJvdGVjdGVkLg0KPiA+IElzIHRoZXJlIHNvbWUgcnVs
ZSBvZiB0aHVtYiB3aGljaCBvbmUgdG8gcGljayBpbiBzdWNoIGNhc2U/DQo+IA0KPiBJTUhPLCBy
Y3VfZGVyZWZlcmVuY2VfcHJvdGVjdGVkKCkgZG9jdW1lbnRzIHdoeSBpdCdzIHNhZmUgdG8NCj4g
ZGVyZWZlcmVuY2UgdGhlIHBvaW50ZXIgb3V0c2lkZSBvZiB0aGUgcmN1IHJlYWQgc2VjdGlvbi4g
DQo+IA0KPiBXZSBhcmUgb25seSBkb2N1bWVudGluZyB0aGUgd3JpdGVyIHNpZGUgbG9ja2luZy4g
VGhlIGZhY3QgdGhhdCB0aGVyZQ0KPiBpcyBhIFJDVSBwb2ludGVyIGludm9sdmVkIGlzIGNvaW5j
aWRlbnRhbCAtIEkgdGhpbmsgd2UgY291bGQgDQo+IGFzIHdlbGwgYmUgY2hlY2tpbmcgdGhlIFRM
U19SWF9ERVZfREVHUkFERUQgYml0IGhlcmUuDQoNClllcywgY2hlY2tpbmcgVExTX1JYX0RFVl9E
RUdSQURFRCB3b3VsZCBiZSBlcXVpdmFsZW50IGluIHRoZSBjdXJyZW50DQppbXBsZW1lbnRhdGlv
bi4gQnV0IEkgZG9uJ3Qgd2FudCB0byBnaXZlIHRoaXMgZmxhZyBleHRyYQ0KcmVzcG9uc2liaWxp
dGllcyAoY3VycmVudGx5IGl0J3MgZm9yIFJYIHJlc3luYyBvbmx5KSBpZiB3ZSBjYW4gY2hlY2sN
CnRoZSBuZXRkZXYgcG9pbnRlciwgaXQgc2hvdWxkIGJlIG1vcmUgZmxleGlibGUgaW4gbG9uZyB0
ZXJtLg0KDQo+IFdlIGNhbiBhZGQgYXNzZXJ0cyBvciBjb21tZW50cyB0byBkb2N1bWVudCB0aGUg
d3JpdGVyIHNpZGUgbG9ja2luZy4NCj4gUGlnZ3kgYmFja2luZyBvbiBSQ1Ugc2VlbXMgY29pbmNp
ZGVudGFsLiBCdXQgYWdhaW4sIEknbSBmaW5lIGVpdGhlciANCj4gd2F5LiBJJ20ganVzdCBzYXlp
bmcgdGhpcyBiZWNhdXNlIEkgcmVhbGx5IGRvdWJ0IHRoZXJlIGlzIGEgcnVsZSBvZg0KPiB0aHVt
YiBmb3IgdGhpcyBsZXZlbCBvZiBkZXRhaWwuIEl0J3MgbW9zdCBsaWtlbHkgeW91ciBjYWxsLg0K
DQpPSywgSSdkIGtlZXAgcmN1X2RlcmVmZXJlbmNlX3Byb3RlY3RlZCB3aXRoIGl0cyBhc3NlcnRz
LCByYXRoZXIgdGhhbg0KcmVpbnZlbnQgbXkgb3duIGFzc2VydHMuDQo=
