Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD59458897E
	for <lists+netdev@lfdr.de>; Wed,  3 Aug 2022 11:33:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236712AbiHCJdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 05:33:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236217AbiHCJdw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 05:33:52 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F00335A167
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 02:33:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=foQQ/prTQd48i/OnB6eMqM7K5JRy2qhqqZHvYlVDgJUSGruULsNLPpQ03brBg8gPfPnMDl0eVv169hBsYYR2LvRMAekbtcwOXlNReR5BOpVjI0+ZYC1QKSMk4mY0cTphrihwHChlsObFeiB2+PTpaIxjhuGUtReRn2e83y8Kc+yS2s0qA28O69lpdhv379m4RigYyB2wPwNLbUjqgWyTwR+km2z+ObpVq2OVH7+1DTBbR0O+nEpLrV6UhzMzJHmxfaHrEvbcwoI8y5FqJvx77ohPTH88By5TK9ISCORBqAJxv55azxH9tqJnjBSUcSvZMRit4lm9/stnqC/MvSINoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HvyZ++i2QBPL9HvSuEnIlMtXHaHeV4j9FzxOOYIXuPA=;
 b=fbHWMrh3b7oKFvMRFNhrINJmfRym2JzfKvTVAa8bU8Tb/RcJUffi5nEmadLdzJtI/n4eKMNi5Y6iKXTew58THNcCE1kV7X+OB6P/IoPYLgOUY/HQNAp3Igdbp3HATf9N34FR09Ao+DPJJYVIVVJTlaHulofxrsSkm5qzfOB3oFwr+nw5DIF+32RhB/m0CbSa5UFtsxLcJXwXK1bk/bclhVme+nSf9re99HJgfjLAjzd1CzlkRz+T2+SrTWcMkkuI24ljRxuYuS8OASQey3O61F1+J7YBXfcjvHxF0k5ElcZcyaHHuXEl98jrGCMzPjGONjHdYgbDnCp8n8ZS+UJmhw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HvyZ++i2QBPL9HvSuEnIlMtXHaHeV4j9FzxOOYIXuPA=;
 b=CSiJMze0gam23OdS0mAajYlgN6L1U7sgD6CUc7dDHVrFJpXGPYLhPqWTBgnZ56I5KQOLkUQVXXoW8a7FvXTQPbUwrKkZ2ftAs6GolpGCj2bu609DC3Hk5L79zr3vzC1BP1yj1W3Tumwr1AHnmrRd4CRuFtM8DkVqVg+P4NuLfP1o3FaxiJ4qiEBx8VHYIOGvLuk9cP7sRZCcxGLDB72hcbwUpmUkURCpJZR1I1GzOaCeRohH7B1QbTwQ1ld8q3wFQEnoTr3KUfaMmgIVo4vLITE12X6pJg9YdfSShhlGZ3OHBv/GtM73xojakSm08esvhQk0pvmVMK5Hj5lI8v+LWA==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MN2PR12MB3582.namprd12.prod.outlook.com (2603:10b6:208:cd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.12; Wed, 3 Aug
 2022 09:33:49 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%9]) with mapi id 15.20.5482.016; Wed, 3 Aug 2022
 09:33:48 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        Tariq Toukan <tariqt@nvidia.com>,
        Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>
Subject: Re: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Thread-Topic: [PATCH net-next] net/tls: Use RCU API to access tls_ctx->netdev
Thread-Index: AQHYpXzdw3PxP7W5AU+7nUMUJ/fFua2acr2AgAESDYCAADvKgIABLLWA
Date:   Wed, 3 Aug 2022 09:33:48 +0000
Message-ID: <8bf08924a111d4e0875721af264f082cc9c44587.camel@nvidia.com>
References: <20220801080053.21849-1-maximmi@nvidia.com>
         <20220801124239.067573de@kernel.org>
         <380eb27278e581012524cdc16f99e1872cee9be0.camel@nvidia.com>
         <20220802083731.22291c3b@kernel.org>
In-Reply-To: <20220802083731.22291c3b@kernel.org>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 565ede7e-9f2a-4fc5-38c8-08da753344fc
x-ms-traffictypediagnostic: MN2PR12MB3582:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BOgozITgl8Y2ISGgaVgstPZfJwGyz5jia6rJPXeBpwEJ59aUtJHaW6uHG3g9CBX30nCk+nCP/9xWzy6ylHSDqclGFwm/jkF+sN2WMli1SVdWToHhcLRwdtNW6acrM885AJVKMaKxRGFAYtuJZ+usxnKt24BTLoJgz4PTPw0gAHqPLQBgcJYHWC0vQw6TrhKvhCwNL06mDJ1skGW6cDtMpBcFigad8zxUkVwoPAvilXPVbV69iKq2GBXmZS8yiXk/XUl/Cpom8TVlU1PwXKuM+k9vVBt1/SOz0uIwmv5BRyjncFdKeZ2hl1rs5imXcssKbE0sJYkgWsU4x+TqSD7GBhVTu/asjWCzRDY2ki+6TnynKKprxGLkCxXjRveLmEODpaTwSq+tjNGZh/tKxkYU9P2PWC9WN4OBDtZB/Civ/IcWjx8S8mWhAw0qzjlHeXoTpsTJMmLZP/2N3na4pVymgQ7M4WolsCsoIOu1Y+JT/C7DSJAIY6XP/ugNNCqlkCcl22NKjrs9u+eqnpqiKz8tGxx+J7Ud5alIMqLflFaceiAoyDveIcouxNJCBm+f+VsA5Fetx+XiEcmsNQB8Uea2XaNCP8Ck35Oye2utUuVFPaSjLaNgWS0FJ1C7okmZMl/7N+XJol1K+Iax1f8NI0qCJTWEaN/VzOy/+dxzsTE4rCITlPelUJbuSzYGvGPhzjMfL6JAjeVEtNWw4H/oDhFNfx5acda3O9XFp5EKecLRBoop46vjtYRcKSi6FzzTGkPZXIsp78NStl1OUtyN+zr+tf00Pa5cdpxJCq3mCUl4I3LiJladBT7iPigYTV1cp3ea
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(366004)(136003)(376002)(346002)(396003)(36756003)(316002)(54906003)(38100700002)(122000001)(6506007)(83380400001)(6916009)(71200400001)(8676002)(38070700005)(4326008)(64756008)(66446008)(66556008)(66476007)(66946007)(91956017)(76116006)(8936002)(478600001)(6486002)(2906002)(5660300002)(107886003)(41300700001)(86362001)(6512007)(2616005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T3phTHg4NGJnbVRtcXZxNlVqQWF6aFROSzM5Q3dTTzB6SEcvdXcxTFpzdGhj?=
 =?utf-8?B?b1o4UGNKOTI3YnpnU1RZOXlSNkYvVis1a1NhQ2tYbnhUd3FoNUQ5QVZsNVBF?=
 =?utf-8?B?OXZiTXlmQlNJTno1WGVKaEp1UUpHcHFWUmdVQWNqZzZIaDNWdktKN2VLelBw?=
 =?utf-8?B?OGYvcm8yd21hUlZaOHUzQXFlU2xrNzhCbUh0bXpBK0tJVlZncnc5WHRBSUhi?=
 =?utf-8?B?TmpBWkY0dnFyOEp3cHpGQ0dsUXJNMnhpT3RJR1RrYkx1dTdVVzVlZld6N2pU?=
 =?utf-8?B?NFBPU0JzKzFoUVFqTk1yUWFjRVNFdGREOWZUcFNyVFFpRTFyTWJ5TmMvL3ZL?=
 =?utf-8?B?UXdPdXlaSEY4UVFoWHowdkljY0w1QmxnUFYrQ2xwWWdhSDlHbzF1cloyVmRh?=
 =?utf-8?B?RlJpT3RncG1QTkRSaFlEMlk1UmI2OFE5aXN5bW9HbG01Wm5iVG42ell1d1Jz?=
 =?utf-8?B?dDZBdFYxWWRmR1BpZG5xWjhPUVE0bTdyaWxEVVlQLzlWRVRXam8xRGdkcWtO?=
 =?utf-8?B?bm56d3BBMGEvSHBZWjYrYSs3MzVLdldLQUJpa2RNelhRWXdjYmk0WHlwMzFl?=
 =?utf-8?B?UHhjY0p5aldUd2QzRTRLclpaZ3pNQy8xelhHcWtjUW9Qb2I5d2lCWHVsWVdw?=
 =?utf-8?B?VVZ0TmJJdGpNNitHY2o5ODhVUm1SdVkzblJuK2FwUllyWmlwRGxOeUlZN2NS?=
 =?utf-8?B?Y0ZTZkY1T2pac2JaT215eTE2MzNNRG1qKzZid3E5cjNhSFQrcUtLMUhOYkor?=
 =?utf-8?B?WkZQa0o0eTk4SERlcURjNE1FMHUwcmRMcU9mbTRpQjkvNk5jQ1dMSFFFY3U4?=
 =?utf-8?B?b0xqeGRnYTZ0RTAzZTZZdGN0NkErd1VsYmZNdXhtbGI3OTJ6NTVLRjJZWnUx?=
 =?utf-8?B?K2FYeGdLbVV2N054Q04vekFlaUlPUWNkdVZnS3BPSmFwVllQU3Vjdm11bGxi?=
 =?utf-8?B?SmpPUjh0dWtXOERSWkIwTmh6TDI2TFV6R3A5WmRVZzBtQjErUzFaU0Zya3Bn?=
 =?utf-8?B?cGVmYXdzclpBOWRXdlo5bGhBdWZNejFGbHVQSU01MXNONUFQRWJRSG04Wmho?=
 =?utf-8?B?TE1sVG1rUVRkTXVVdVErL3dsM3JLOFVBYWFLeDM1azN3OEVEVU1PeXNENDIy?=
 =?utf-8?B?bzVycXdZeU9DUGxrUVpYR1lENWU2aUxQS0pjVnhYWEQ3azlmWk9nT2pBaWUv?=
 =?utf-8?B?S21abUJIRGlORGFKbWdETDkrWFl4d1FrVTZkSWNvNVljTXBvMGJBZlNMU2Y0?=
 =?utf-8?B?ZUpIKzlvdWRQYXFqQ2txajBvZVlWOWpiY2dlbHNTN0FxTWtFQWxSa0xPN1Jh?=
 =?utf-8?B?YXJGVmxjUCtWK25LWm85TG5VdkEzcnNNZ21sLzgvemVyYTZhMjd5OWIwelNv?=
 =?utf-8?B?T0pXMW5lejVVc3JKdG5nM2wxUmgvRHlvRDAyNHRqakF3YU5taXMyWm9FN0pt?=
 =?utf-8?B?UHNnZzZsZU9LUjUveHVSaGVMNTdFTFNINS9JUk9wMjNKZWZFS20zRmhaN24r?=
 =?utf-8?B?OW5Rc3ZFWHNCT3dUTi84S21sZU1LMmtEV3BUVWp3MXcxV3RJOHZkMXFwR0tx?=
 =?utf-8?B?VFUvUDZrckVxazAxNm4veWJ0UkZ1bG44LzFSL3hRblYxdEdTUG9OU0g0SHly?=
 =?utf-8?B?b0ZGaGFPZ0F5YmlEUzRmYi8rMVZrT2JybmJZbGVEdzRNZWVSSm5mcmpRL2Yy?=
 =?utf-8?B?YkQ5NW05TDlwMVl1UDZLQlFtc2JLV0crSUlYY2tIL1dMdnFPeGpWeDFRMGdG?=
 =?utf-8?B?UW1PVzNzWUxMM2pGU3hmRklHQWlXZTNsMGk2di9mb1hrWXZ5V0dzMXJmMEpH?=
 =?utf-8?B?cUZ4NUNIczRkQktzYWJCTUdWZVBBU1JpZytMWHZOMXZ0ck9UVmJoRGNUSk5N?=
 =?utf-8?B?VG9mMnI1ZGNYSFpYeW1uak02elROQUVvN0hQRTdwYkQ5Y3lsVzdnYUZsYUEw?=
 =?utf-8?B?RE9CdzdNSkRvR29IODJydjlaTWw5RHdpRXI2VmhzTldDWks2TjVIblNCTzE0?=
 =?utf-8?B?aVVzbXdiUTdLM0QydHJUUUFVQjZuVWh0SG9jc2JmZDBLSm80aTh3dHorUnBa?=
 =?utf-8?B?V216YkwzcklQMVpRNDZSNDVIS1FzR0ZwYWorTXZabm41MlpVT1hHSjVmcXpR?=
 =?utf-8?B?SGNIbzc1K2NYajJLK0dZaEJNTEhaK3BpY2JmZmdYQjlSVkZTalR4YjI2R1Jy?=
 =?utf-8?B?cUpnaEtnbE5CVFBuZDFUSE9IZldyU2lPZmxNNUZHN2dLWmVWR3JuQlF5QUVu?=
 =?utf-8?B?YVVIbUVQbnVnaVBNbGprbDQ0SU9BPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9073EE6A230DF247BB5E4EB077C91883@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 565ede7e-9f2a-4fc5-38c8-08da753344fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Aug 2022 09:33:48.7196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pzE1YOApre+G00CCqsoPwZBAQpubPHtJUQOmDCWUqTSk6PwrIS+/1s5DtxlabdMEirGuvWuGWyO2GSeBGtQKRg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3582
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA4LTAyIGF0IDA4OjM3IC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVHVlLCAyIEF1ZyAyMDIyIDEyOjAzOjMyICswMDAwIE1heGltIE1pa2l0eWFuc2tpeSB3
cm90ZToNCj4gPiA+IEZvciBjYXNlcyBsaWtlIHRoaXMgd2hlcmUgd2UgZG9uJ3QgYWN0dWFsbHkg
aG9sZCBvbnRvIHRoZSBvYmplY3QsIGp1c3QNCj4gPiA+IHRha2UgYSBwZWVrIGF0IHRoZSBhZGRy
ZXNzIG9mIGl0IHdlIGNhbiBzYXZlIGEgaGFuZGZ1bCBvZiBMb0MgYnkgdXNpbmcNCj4gPiA+IHJj
dV9hY2Nlc3NfcG9pbnRlcigpLiAgIA0KPiA+IA0KPiA+IFRoZSBkb2N1bWVudGF0aW9uIG9mIHJj
dV9hY2Nlc3NfcG9pbnRlciBzYXlzIGl0IHNob3VsZG4ndCBiZSB1c2VkIG9uDQo+ID4gdGhlIHVw
ZGF0ZSBzaWRlLCBiZWNhdXNlIHdlIGxvc2UgbG9ja2RlcCBwcm90ZWN0aW9uOg0KPiA+IA0KPiA+
IC0tY3V0LS0NCj4gPiANCj4gPiBBbHRob3VnaCByY3VfYWNjZXNzX3BvaW50ZXIoKSBtYXkgYWxz
byBiZSB1c2VkIGluIGNhc2VzDQo+ID4gd2hlcmUgdXBkYXRlLXNpZGUgbG9ja3MgcHJldmVudCB0
aGUgdmFsdWUgb2YgdGhlIHBvaW50ZXIgZnJvbSBjaGFuZ2luZywNCj4gPiB5b3Ugc2hvdWxkIGlu
c3RlYWQgdXNlIHJjdV9kZXJlZmVyZW5jZV9wcm90ZWN0ZWQoKSBmb3IgdGhpcyB1c2UgY2FzZS4N
Cj4gDQo+IEkgdGhpbmsgd2hhdCB0aGlzIGlzIHRyeWluZyB0byBzYXkgaXMgdG8gbm90IHVzZSB0
aGUNCj4gcmN1X2FjY2Vzc19wb2ludGVyKCkgYXMgYSBoYWNrIGFnYWluc3QgbG9ja2RlcDoNCg0K
V2VsbCwgbWF5YmUgd2UgdW5kZXJzdGFuZCBpdCBpbiBkaWZmZXJlbnQgd2F5cy4gVGhpcyBpcyBo
b3cgSSBwYXJzZWQgaXQNCih0aGUgd2hvbGUgY29tbWVudCk6DQoNCjEuIHJjdV9hY2Nlc3NfcG9p
bnRlciBpcyBub3QgZm9yIHRoZSByZWFkIHNpZGUuIFNvLCBpdCdzIGVpdGhlciBmb3IgdGhlDQp3
cml0ZSBzaWRlIG9yIGZvciB1c2FnZSBvdXRzaWRlIGFsbCBsb2Nrcy4NCg0KMi4gSXQncyBub3Qg
Zm9yIGRlcmVmZXJlbmNpbmcuIFNvLCBpdCdzIGZvciByZWFkaW5nIHRoZSBwb2ludGVyJ3MgdmFs
dWUNCm9uIHRoZSB3cml0ZSBzaWRlIG9yIG91dHNpZGUgYWxsIGxvY2tzLg0KDQozLiBBbHRob3Vn
aCBpdCBjYW4gYmUgdXNlZCBvbiB0aGUgd3JpdGUgc2lkZSwgcmN1X2RlcmVmZXJlbmNlX3Byb3Rl
Y3RlZA0Kc2hvdWxkIGJlIHVzZWQuIFNvLCBpdCdzIGZvciByZWFkaW5nIHRoZSBwb2ludGVyJ3Mg
dmFsdWUgb3V0c2lkZSBhbGwNCmxvY2tzLg0KDQo+IA0KPiANCj4gCWxvY2sod3JpdGVyX2xvY2sp
Ow0KPiAJLyogbm8gbmVlZCBmb3IgcmN1X2RlcmVmZXJlbmNlKCkgYmVjYXVzZSB3ZSBoYXZlIHdy
aXRlciBsb2NrICovDQo+IAlwdHIgPSByY3VfYWNjZXNzX3BvaW50ZXIob2JqLT5wdHIpOw0KPiAJ
cHRyLT5zb21ldGhpbmcgPSAxOw0KPiAJdW5sb2NrKHdyaXRlcl9sb2NrKTsNCg0KSGVyZSBJIHRv
dGFsbHkgYWdyZWUgd2l0aCB5b3UsIHRoaXMgaXNuJ3QgYSB2YWxpZCB1c2FnZSwgYnV0IEkgdGhp
bmsNCnRoZSBkb2N1bWVudGF0aW9uIGNvbW1lbnQgZG9lc24ndCByZWNvbW1lbmQgYW55IHVzYWdl
IHVuZGVyIHRoZSB3cml0ZQ0KbG9jay4NCg0KSXQncyBqdXN0IGEgcmVjb21tZW5kYXRpb24sIHRo
b3VnaCwgc28gaWYgeW91IHByZWZlciByY3VfYWNjZXNzX3BvaW50ZXINCnRvIHNhdmUgYSBmZXcg
bGluZXMgb2YgY29kZSwgSSBjYW4gc3dpdGNoIHRvIGl0LiBXZSdsbCBqdXN0IGxvc2UgZXh0cmEN
CmNoZWNrcyBhbmQgYWRkIGFuIHVubmVjZXNzYXJ5IFJFQURfT05DRSB1bmRlciB0aGUgaG9vZC4N
Cg0KPiANCj4gSXQncyBzdGlsbCBwZXJmZWN0bHkgZmluZSB0byB1c2UgYWNjZXNzX3BvaW50ZXIg
YXMgaW50ZW5kZWQgb24gDQo+IHRoZSB3cml0ZSBzaWRlLCB3aGljaCBpcyBqdXN0IGNoZWNraW5n
IHRoZSB2YWx1ZSBvZiB0aGUgcG9pbnRlciwgDQo+IG5vdCBkZWZlcmVuY2luZyBpdDoNCg0KU3Vy
ZSwgaXQncyBjb3JyZWN0LCBidXQgYWRkcyBhbiBleHRyYSBSRUFEX09OQ0UsIHdoaWNoIGlzIG5v
dCBuZWVkZWQNCnVuZGVyIHRoZSBsb2NrLCBhbmQgc2tpcHMgdGhlIGxvY2tkZXAgY2hlY2ssIHdo
aWNoIGlzIHJhdGhlciByZWR1bmRhbnQNCmluIHRoaXMgY2FzZToNCg0KZG93bl93cml0ZSgmbG9j
ayk7DQpwdHIgPSByY3VfZGVyZWZlcmVuY2VfcHJvdGVjdGVkKHJjdV9wdHIsIGxvY2tkZXBfaXNf
aGVsZCgmbG9jaykpOw0KLi4uDQp1cF93cml0ZSgmbG9jayk7DQoNCmJ1dCBpcyBtb3JlIG1lYW5p
bmdmdWwgaW4gdGhpcyBwaWVjZSBvZiBjb2RlOg0KCQ0KLyogU2FmZSwgYmVjYXVzZSB0aGlzIGlz
IHRoZSBkZXN0cm95IGZsb3csIHJlZmNvdW50IGlzIDAsIHNvDQogKiB0bHNfZGV2aWNlX2Rvd24g
Y2FuJ3Qgc3RvcmUgdGhpcyBmaWVsZCBpbiBwYXJhbGxlbC4NCiAqLw0KbmV0ZGV2ID0gcmN1X2Rl
cmVmZXJlbmNlX3Byb3RlY3RlZChjdHgtPm5ldGRldiwNCgkJCQkgICAhcmVmY291bnRfcmVhZCgm
Y3R4LT5yZWZjb3VudCkpOw0KDQphc3luY19jbGVhbnVwID0gbmV0ZGV2ICYmIGN0eC0+dHhfY29u
ZiA9PSBUTFNfSFc7DQoNCj4gDQo+IAlsb2NrKHdyaXRlcl9sb2NrKTsNCj4gCWlmIChyY3VfYWNj
ZXNzX3BvaW50ZXIob2JqLT5wdHIpID09IHRhcmdldCkNCj4gCQlzb19zb21ldGhpbmcob2JqKTsN
Cj4gCXVubG9jayh3cml0ZXJfbG9jayk7DQoNCg==
