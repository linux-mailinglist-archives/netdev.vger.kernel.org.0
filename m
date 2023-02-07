Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A67168DA7E
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 15:22:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232454AbjBGOWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 09:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbjBGOWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 09:22:00 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam02on2079.outbound.protection.outlook.com [40.107.212.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CF216ACC;
        Tue,  7 Feb 2023 06:21:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dZcTdHc0Etw+WKLL3zd6LximvmtJcBBjgDFVnJHnc22mClh+V8m3Q1Hw5/SE34h7QE/392Jqd7FMYe+9/q1Uvgwj/3Y134aKpLH/wGdLlK422ljOCYkT2gAsumVy1ocglKaxf3FQS2smJTlBLr9Iqst8rTwju062dAjRQAVRZkJ6bISLfYYY8D6VMU4plweCrsKEtZFrbpI5Jx8hE+OQhxXnuYK3QkCr0T9GlzvzgD3HeLM9aq0c/25XJzGztez/mYimoA2lOEzKWBqUbFssQlwfz/MyxP6aG1VGgzDsnBUk7nsUUAFY5XHGKiiwcN8a9GIBS2JSxPIMOFEGA6SkJg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hDKPpzfHn2LsWqlTNeIvScQdpflg6Nme+hQnCZ8oW+c=;
 b=KCvjKUIYMPfXZrVc1qWJR+wNzGdmjPWGwV1CDDdU80/3GymJrkNi7k1fyjnr9VDpNR4AWkZ5KzABsP/cbLfLwwJrfLdtMVr5FocfRMQu2OnnThqn/CRS3G0B0SvXVLveLrgsmxSaoPnknqi5qXHu1bWu4bwAgIRORv9c5/WMHhZlO0RoXV7va89lYpZsl9uSbjKO0L+k2Elqay96+8dMM9L51CXNJF4oHceAmzFoeY3Q7Wtydehaz3eIbzBq+xBho2G4+TVRGAptzG8WX4dZfQZlP08CuIynHgMH0TkG1CrTXqbOGX8pOJJiRLyDol5YFHHZ+2RKfNsKwi9jvL8PlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hDKPpzfHn2LsWqlTNeIvScQdpflg6Nme+hQnCZ8oW+c=;
 b=YbDgr+a4v45zNyuzIfWzXFs2PV9UBeimJa/iR/nKMuGqFPb16i9vPneYVxVD55xZAqEgKv7fRurdwJxBtaviAxVDfvSY8Vvx/C7QxKZnM2+O0D1Ue9WiuIKAg4VMpJYuTDpTzbyzN3/67WENP3Cte2XON51vFyJ0qpDRmdYWq0Q=
Received: from DM6PR12MB4202.namprd12.prod.outlook.com (2603:10b6:5:219::22)
 by SA0PR12MB4526.namprd12.prod.outlook.com (2603:10b6:806:98::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.35; Tue, 7 Feb
 2023 14:21:53 +0000
Received: from DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939]) by DM6PR12MB4202.namprd12.prod.outlook.com
 ([fe80::33a7:54d4:2de0:3939%9]) with mapi id 15.20.6064.036; Tue, 7 Feb 2023
 14:21:53 +0000
From:   "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        "Lucero Palau, Alejandro" <alejandro.lucero-palau@amd.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers (AMD-Xilinx)" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "habetsm.xilinx@gmail.com" <habetsm.xilinx@gmail.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "jiri@nvidia.com" <jiri@nvidia.com>
Subject: Re: [PATCH v5 net-next 1/8] sfc: add devlink support for ef100
Thread-Topic: [PATCH v5 net-next 1/8] sfc: add devlink support for ef100
Thread-Index: AQHZNveL5f88zbx8cE66rtffR/bzVq7B10eAgAG5uwA=
Date:   Tue, 7 Feb 2023 14:21:53 +0000
Message-ID: <DM6PR12MB42025E6DF2C74AA99571C1D0C1DB9@DM6PR12MB4202.namprd12.prod.outlook.com>
References: <20230202111423.56831-1-alejandro.lucero-palau@amd.com>
 <20230202111423.56831-2-alejandro.lucero-palau@amd.com>
 <66a5d1bc-2220-4298-b166-b41f17508599@gmail.com>
In-Reply-To: <66a5d1bc-2220-4298-b166-b41f17508599@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
x-ms-exchange-imapappendstamp: DM6PR12MB4202.namprd12.prod.outlook.com
 (15.20.6086.009)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB4202:EE_|SA0PR12MB4526:EE_
x-ms-office365-filtering-correlation-id: 91084758-3f42-4d9a-68ea-08db0916a8e8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FmRnSph8iGoINcRuBzUuKUe/Fi76Hbc5OvKlbSWmPlb9324+hEyWP6yt4+V/bSTvhM7oiom6ffG0/qUBh33h+urtY+Kntw9rU7eJ5UjR6U4h5IYYbmEJS+w6YcA9Y9/Zi8binuI1IjxmEwrF3MHfG7EkynuY4L0/VNnk84Uz5TciI4KojOHJMl884g0xe8CzvNorUXyu6AA9NSiWkP9gLZXAeKjt5TOD45mKTCxaKVAEm+U9/xSkZNy0TuO+LpIcXSo3Y0ltVyfQIdrGesN4eV8KwU3pWg6KxO0qzkmwABqvRfABkAC8tuiNYjaWUjHlmBF10YnhYSF6CWjL8OMdGM5zx93Vaj06nOs2CfJ03SQziyWRroq/TOWFt4Cyno2wpolcPykzhMioB2LJiPI/vb8M+YCXUIypAk/ZzlT04Rm0JRVCB3F/JGqzUQhaxYre4dY+UIsbFaM8K9txVQ3/9ikvTHQks2dMMLWucggJdYAHQoThyo4678iS9pVH7BGLP+Kz0Ozdp8KCbhFG0gUXNIitZXrTnMrEbM9hAvehtv/fkbzqzYFo/6xQNd30GxMWrjWUX9smYrYxqbR+UsL4MZLMQkwKQ6+Nnb38RWo7fxDjsvYfeMgFyMxhbiiEhXIXJRZhRgWWeD7pUscAmBVZ8Bb2NyZK57sGL/6yyR9x+e+weFaTWl25MqA0fzzy2QNSTsO0ag35FDQGUmJbCPVpdCkc5hIQhP0Im6OwnAx76chAPhAZy0jgVKzwfS92T1ELhMQVDUTRf3c/+9V0ferHc5JkObMNIDeIwKssU4HMFVo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4202.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(346002)(366004)(136003)(451199018)(186003)(6506007)(26005)(53546011)(9686003)(7696005)(38070700005)(33656002)(478600001)(71200400001)(7416002)(316002)(2906002)(54906003)(110136005)(6636002)(8676002)(4326008)(76116006)(38100700002)(66446008)(122000001)(66476007)(64756008)(66556008)(41300700001)(66946007)(8936002)(52536014)(5660300002)(55016003)(65966003)(2004002)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Ly9iM0RDRlMzbTh2bnNTWC83cUF6bVBTNUVyMk1ab0RnSlhpK3R6RGVpSDJa?=
 =?utf-8?B?dnkyNWw2aVJWelllRVJ0R1U3RjBIU1BsYWNhWFArdWtObm5YTG4ycC9scVhW?=
 =?utf-8?B?QnYxRENFSSt3TU5MNW95WEtnaVdiUWdvNE1EWng2T0VtQVo2UHlUMHVHV2Nn?=
 =?utf-8?B?eWdSejY0TDduSUl3dUtYQTQyd2NXMHRKbzlVMVkvMzN4T01yZDArcmZaMDdv?=
 =?utf-8?B?VG84ZUd1dXNnbVhpZUVoa0xTQTMxNjBoVG1tS1hoL3Z3ajdvQng3bmRFSWNC?=
 =?utf-8?B?YnYzNVAzc3B6T0ZFeVhRbS91YVp5K1ZmMWlyZGZUN3F4eENmdHZ1VW85aThQ?=
 =?utf-8?B?R1pGVGZMTzVEb2ZyY3RWVllxYTdQNlB2K0JaNVgwd3FzNWVlYWppc2FGbGs0?=
 =?utf-8?B?UG5BSTkwdzQ5ajNvblhSWENUQjZORHMwRVNudlF2V1crekNoUUpQaXd6ZExG?=
 =?utf-8?B?dFY1cmJzV3U2TXllSkRTQ0JBUTJOVGQxeFRteDd6TVAwOHpFV01CeVVlT1l1?=
 =?utf-8?B?NTBBRTJnejY0czBuVExuRUxJNDNmdmc0K0FPL1FMQTV4Q1FSNHprc0JKYUVL?=
 =?utf-8?B?Q2NwcHFOWHIvak9SRjZXeTZDd29XNFRxNUtsdDBBUXRRWGZObStVK0VyYW9i?=
 =?utf-8?B?OEw3Z2hTMDc3M3lkbzdDRkRXc0xGTHlrWEJxWGF0UElTc1M4OG1XYUV6OHlK?=
 =?utf-8?B?UHpmSzgrUDNEeEdFY3BGN0VhSUJFMUJvVGFtUFo1UWpQR1VlSHlSU25GS0wr?=
 =?utf-8?B?cDBjMjNaOU56anZyRyswakw1MCtpVlIvbS9HZWNma21hUGFRWW1wTjZ5UUxD?=
 =?utf-8?B?OXB4a2czakpHZ3dFb1RPaUVIdkNJaWVsQVJOYVBuNkNsUEQwanl4K0V3SUtS?=
 =?utf-8?B?QUlqZ3Y0UlVsTHJsNSsvZ1VpU0w4Rzc2dzZFYzljZGJSOTFuT3g3THVKa0sx?=
 =?utf-8?B?c3NnY2FIczVqUlhqWDRaNExMckRqL1pMbURNOG1xM0VqblNicUYxM1NZUUtE?=
 =?utf-8?B?VVljcVFXUEVwNmtkM2wxcXFPLzFFTytuR25xOE9rbmlhSHFmUk1tT3VTem9G?=
 =?utf-8?B?WlpLb01lTVRJQVA3MWtyRlJPMnZNR3hiMDNReFBhZE9FUUYrcDBLTnR4REZP?=
 =?utf-8?B?L09LNG1VY1FXOSs3ZUxMNEZkZ21nenlKdWx0WGFISlZHM3lqZzQ0Mzc2UjhW?=
 =?utf-8?B?ZC9KZzFJb0N0SUx2NWF5RVdFT2FjQ3hmWm0xbXYxWE9EdHNaSUVZck04bjdM?=
 =?utf-8?B?RUFSeklpR2YvbnNKQ01pdTQwQk1USDRCUVUwbEFwTzY1ZVJpNEYrV2FSSWMv?=
 =?utf-8?B?UlFZdzY0Y1MzWUpmVG9hT2VkdXBtMHFHZ1RjSDhsUXFWK3FpS29seG1yMDVh?=
 =?utf-8?B?MG0zRm93NzBqQ09pcUovZ2ZMajV2bklRdkZKYWlsMlBFTVZCL1oyRDJQT29Q?=
 =?utf-8?B?b0k2TnQ4RG40QzltbHBQRnZYblNxQTZPeVU1YjZtZlZkY1pQWHdKblhXTFUw?=
 =?utf-8?B?MUdLWENJcUtTWlZMR0llOFl1TmNMS0tZYnpmbmNHRmo2VW5vTVlsNmR4amQ5?=
 =?utf-8?B?L0htMkthZ1lMTTgrZGFYaC8yc2Z3aEJETjBCaFlGZ2xkOFBwUU1GRE9lRkN6?=
 =?utf-8?B?cUlhdHNLQXlEYWVZRXVvNnJ5U3JPaFZLUUNXcWJ0UnFVZjFFci9mU0JNVnpF?=
 =?utf-8?B?MFliejdhcEt3VXBvc3AvbGQ2eWhGRVY4Q2Naa3VNc0pjNWxEcEVlemUrMGpU?=
 =?utf-8?B?TUVHNEIwU3hIVVF3RzhWeEVaU1hkamdOZjVYSUk2ZEZRQzdiNmppMlRNTjhL?=
 =?utf-8?B?bER5RzR2enN4MkdacE03TEY0Q1pRZHlPMWlaQm9yYVNvSW9VQ3FCM2NEb3Jw?=
 =?utf-8?B?bTBrRlhUc3g3NVErUXVPV3JTVFFKL3BmU0xWWGJpUVJ4Slh5a24zbmFBWXZr?=
 =?utf-8?B?QUNqQ2pLenJPM29pT3VxU1hZQ215blRqZmhKclNVbzVqZmg3czM3NTFZU0RY?=
 =?utf-8?B?QUVRUnA3RisvZElOaFBOOUl1Z1RSd2FVaGZxc25OLzRFa0xYT00wZG84M1N0?=
 =?utf-8?B?MmRzemZMSjdLQVN3bFB6dTMzQnJJczhzdldEa2dRNUFJRmZGNjMrN1YrR0Ns?=
 =?utf-8?Q?xldY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAA236692D53DB4890F32F94C9EBA906@amdcloud.onmicrosoft.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4202.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91084758-3f42-4d9a-68ea-08db0916a8e8
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Feb 2023 14:21:53.0478
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F5xyAKOWh9CmqVd5qSxgfXzTHhY7lgJvzcAuJ7wQCP2741nVgqpNPxuXRe17OF/bSCw4RhWTE1HtuYbSBRLG9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4526
X-Spam-Status: No, score=0.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_MUA_MOZILLA,
        FORGED_SPF_HELO,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiAyLzYvMjMgMTI6MDAsIEVkd2FyZCBDcmVlIHdyb3RlOg0KPiBPbiAwMi8wMi8yMDIzIDEx
OjE0LCBhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20gd3JvdGU6DQo+PiBGcm9tOiBBbGVq
YW5kcm8gTHVjZXJvIDxhbGVqYW5kcm8ubHVjZXJvLXBhbGF1QGFtZC5jb20+DQo+Pg0KPj4gQmFz
aWMgZGV2bGluayBpbmZyYXN0cnVjdHVyZSBzdXBwb3J0Lg0KPj4NCj4+IFNpZ25lZC1vZmYtYnk6
IEFsZWphbmRybyBMdWNlcm8gPGFsZWphbmRyby5sdWNlcm8tcGFsYXVAYW1kLmNvbT4NCj4gLi4u
DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvc2ZjL2VmeF9kZXZsaW5rLmMg
Yi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0KPj4gbmV3IGZpbGUgbW9k
ZSAxMDA2NDQNCj4+IGluZGV4IDAwMDAwMDAwMDAwMC4uOTMzZTYwODc2YTkzDQo+PiAtLS0gL2Rl
di9udWxsDQo+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9zZmMvZWZ4X2RldmxpbmsuYw0K
Pj4gQEAgLTAsMCArMSw3MSBAQA0KPj4gKy8vIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwt
Mi4wLW9ubHkNCj4+ICsvKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioq
KioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKg0KPj4gKyAqIERyaXZlciBmb3IgQU1E
IG5ldHdvcmsgY29udHJvbGxlcnMgYW5kIGJvYXJkcw0KPj4gKyAqIENvcHlyaWdodCAoQykgMjAy
MywgQWR2YW5jZWQgTWljcm8gRGV2aWNlcywgSW5jLg0KPj4gKyAqDQo+PiArICogVGhpcyBwcm9n
cmFtIGlzIGZyZWUgc29mdHdhcmU7IHlvdSBjYW4gcmVkaXN0cmlidXRlIGl0IGFuZC9vciBtb2Rp
ZnkgaXQNCj4+ICsgKiB1bmRlciB0aGUgdGVybXMgb2YgdGhlIEdOVSBHZW5lcmFsIFB1YmxpYyBM
aWNlbnNlIHZlcnNpb24gMiBhcyBwdWJsaXNoZWQNCj4+ICsgKiBieSB0aGUgRnJlZSBTb2Z0d2Fy
ZSBGb3VuZGF0aW9uLCBpbmNvcnBvcmF0ZWQgaGVyZWluIGJ5IHJlZmVyZW5jZS4NCj4+ICsgKi8N
Cj4+ICsNCj4+ICsjaW5jbHVkZSA8bGludXgvcnRjLmg+DQo+PiArI2luY2x1ZGUgIm5ldF9kcml2
ZXIuaCINCj4+ICsjaW5jbHVkZSAiZWYxMDBfbmljLmgiDQo+PiArI2luY2x1ZGUgImVmeF9kZXZs
aW5rLmgiDQo+PiArI2luY2x1ZGUgIm5pYy5oIg0KPj4gKyNpbmNsdWRlICJtY2RpLmgiDQo+PiAr
I2luY2x1ZGUgIm1jZGlfZnVuY3Rpb25zLmgiDQo+PiArI2luY2x1ZGUgIm1jZGlfcGNvbC5oIg0K
PiBuaXQ6IGFzIGZhciBhcyBJIGNhbiB0ZWxsLCBtb3N0IG9mIHRoZXNlIGluY2x1ZGVzIGFyZW4n
dCB1c2VkIHVudGlsDQo+ICAgdGhlIG5leHQgcGF0Y2ggKHJ0YywgbWNkaSosIHBvc3NpYmx5ICpu
aWMgdG9vKSBhbmQgc2hvdWxkIHRodXMgb25seQ0KPiAgIGJlIGFkZGVkIHRoZXJlLiAgSWYgeW91
J3JlIHJlc3Bpbm5pbmcgYW55d2F5LCBtYXkgYXMgd2VsbCBmaXggaXQuDQoNCg0KWWVzLCBJIHNw
bGl0IHVwIHRoZSBmaXJzdCBvcmlnaW5hbCBwYXRjaCBhbmQgZm9yZ290IGFib3V0IHRoZSBoZWFk
ZXIgZmlsZXMuDQoNCkknbGwgZG8gaXQuDQoNClRoYW5rcw0KDQo=
