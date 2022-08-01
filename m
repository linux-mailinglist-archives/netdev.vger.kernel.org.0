Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73ACE5865FF
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 10:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiHAIIN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 04:08:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229555AbiHAIIM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 04:08:12 -0400
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2078.outbound.protection.outlook.com [40.107.237.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 002EB18E07
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 01:08:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZThJ+eML+D0V+Kx3+omz5n8EOytSQacaioLj0mgFSiQocHe5QcNLpOy1iXxB0yqSAUnPMhXOk7iGbfPuEicraMigET4KSWsMiYTpznfu/FNkep+Ilzzu6/yNhYc+2lhYWec+r8OjOKiRMQGXNECT8ecyMZJljP9wBpRDOPKLndImYCvO9C0wXVVL+7+uuOVbXNGkDhR1rqG0AqRU30NKV64N3wihrleQhVQceFVWsoWQ92lZjAUP17stGDeP1l6c8zZdCgpQsghP01h/hCRQp56oDv0hC1rccePiTVWGOtV01mY3yJATIbMGRQdMW7FHWu9IJwWC/9eYcfpG97VXNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E9wVjP+MM1cZyD+J1M3tRLFDYNTBvgiM0d2FYwoV1lk=;
 b=f99Au4XfMW7VOlF3ohPmCLV2fGQIBSkeTYIaXI2to1gb/xQfniji6FkOAFbJuPSbX38N/KdhRL/4DMxNfJ9szTkboVLAx8y/xYQXFTadgnWysqHzL6lH2XR3wefCeVi1WVuWN9u9AAiMKS2epGdg6PFJhAncBnbBK7iQjXzfEiqbBdPju5nMv+8yWY9kHm/Z5gPfk21zHbqULv4TZMlmzJixiDv/PtOaYSjleWEmHixVtRmrlV72X+9+NfT2GfQILcXf28K+gJ+ZmUuZ+xHWw5xPy1+yqxPbW5qmq9tRvmzWivuOzKCRNz3LLojYLU52xg9WQ/L8AdDuKEsUjliQUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E9wVjP+MM1cZyD+J1M3tRLFDYNTBvgiM0d2FYwoV1lk=;
 b=nJN2FXAWLGGCPjf4sZ5HkY2b/LFrs0VS/BDVObBLHchV5RHG0xknfGAWrOSYM8mT+IlqWcjpduhrYmW3Wa4Rk6qeW4YXU+17FrRBAmvB+DYVGBDDnshWodN8Y5NRVCCQkQyy3aJ6mvA0RA1qPwyrxvqZtkd2JmE8MBAI7qe2RrM2jXSiRqQ2xa/Md8FVe7YhdllrLk62L7Y8xyvZUGXmR4rAMO1TmOhVS3aPqm0dcgUz5iF/lo+Wu0cJeA0/aikBR6kIGzHDCTkHP2FyFaQBp4r99ZyyNWbNTp1Mgls7pwYl2GKEso4Qn5NEidebcKa1yTgvKMLRddTpkjx+G9Gpvg==
Received: from DM4PR12MB5150.namprd12.prod.outlook.com (2603:10b6:5:391::23)
 by MN2PR12MB2959.namprd12.prod.outlook.com (2603:10b6:208:ae::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.11; Mon, 1 Aug
 2022 08:08:10 +0000
Received: from DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548]) by DM4PR12MB5150.namprd12.prod.outlook.com
 ([fe80::9d64:c05d:1f75:3548%9]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 08:08:09 +0000
From:   Maxim Mikityanskiy <maximmi@nvidia.com>
To:     "bjorn@kernel.org" <bjorn@kernel.org>,
        "maciej.fijalkowski@intel.com" <maciej.fijalkowski@intel.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>
CC:     Tariq Toukan <tariqt@nvidia.com>, Gal Pressman <gal@nvidia.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on
 striding RQ
Thread-Topic: [PATCH net] net/mlx5e: xsk: Discard unaligned XSK frames on
 striding RQ
Thread-Index: AQHYo0S40mUHMPrn60ubYFdJ/lMLJq2ZtSKA
Date:   Mon, 1 Aug 2022 08:08:09 +0000
Message-ID: <812d2df33f801e594cc6ee774c6625def6c9a5c1.camel@nvidia.com>
References: <20220729121356.3990867-1-maximmi@nvidia.com>
In-Reply-To: <20220729121356.3990867-1-maximmi@nvidia.com>
Accept-Language: en-US, ru-RU
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.44.1-0ubuntu1 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14571f3d-afdb-40d0-1462-08da7394f929
x-ms-traffictypediagnostic: MN2PR12MB2959:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6MqF3xq0mFAlL5J8A+iNRcdA7LXVlJoXQEkHcY02Qnzaud6MSxOLcGSVanlfCENkt38R6eFeD69ljcvOBEItd8zaIJtqAMjM9MMBoBxWbfSUMuz9aQ5ay9QKh6EZVid8nEOIKuGwQBnQK/UeETABHeCe6DSrveDgkMWJ/zGMTnNPDSPRSSJshYNaY6OZNdovHTVuR5R2Zt5vtuqS1tV7PIb3CIGo1aYsyR9gsYWv3fXbEhDbW3Koc60wQ+qiwH88w7fF6cH6ht6ROTVn5BwuLuv8EaPTcfLj4ZaZ2Sj34onTaE1pCVIKFmGk9ubLnKFHSMYl03o2qUeHY6pZZHyWDSXhwmBeUQa5Uehf6WYhEpsXxJ+cNApRnIPNKz2sC3azAN5mF79GOQc7DPxYJiNssx6VzJNltAtZ0OmLGTXKdEITL4NdwoLH0CXGAGCGsWfFZin1DYz+MSMdqEQMu+i8AwlYfHYQXiq993DLmvnmdbvxaLb+dq7kPb+Shmoz2AON4F7r1kyd+Ba/TDu13osvzFwSyHtd+vDF5UCVUr9CoacgmDjYM+SChA0SkOAkt4OjELtna+aLCv9ip7q1B56fnVjf1CUkC9aL6mAAB/4I3g09bdJMNLFqBCO9QGSN+SQvpgA+ByQHI5a9QX4Vf8hfQy5kjxgcTOwJlZcr+jgt+S+aKEoWw3rgNCxRavgJUIb6wQiSGam3iiifbJaLlmsv4sbY8c7VcVokrCm1QILvuFdKW+idbzZt9ua2Yj1KSjhILQWgib5T47wkvw/aNjiknC452ge4CjsFX7yfTI6ZCCE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5150.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(136003)(39860400002)(376002)(396003)(346002)(366004)(186003)(6506007)(110136005)(66946007)(76116006)(8676002)(64756008)(66446008)(54906003)(66556008)(66476007)(91956017)(107886003)(71200400001)(6512007)(36756003)(41300700001)(2616005)(316002)(122000001)(38070700005)(86362001)(38100700002)(2906002)(7416002)(4326008)(5660300002)(8936002)(478600001)(6486002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TjB2UEpxd0tMb2pkVE04d0lLSUVvcDRxS1p0VlRuVUF4SWZ1V053ZFE1dzBw?=
 =?utf-8?B?eDR4SmE5eG1oeUlmWXd1NU5LLzJlVHA1OVlRQVlrajB5bUZLeHk5Mys5L3pP?=
 =?utf-8?B?bjNmU0ordkZjYmV2Tnl4ZHMzeVBRWmIrTCtGZ1dHWGVOMnp4WmVrcmx2aTJn?=
 =?utf-8?B?NDdHOVZhQjEzdXIxWUNlUGxyMWkrbkdaUkpaN3YvMUUzS3Z3V0JlamU1cXJV?=
 =?utf-8?B?SEZBTFJub3FORnVNYUt2TDJ5YThqYm1QdlcybFJrL2xpNjJiRlhmNWZha2ky?=
 =?utf-8?B?ZFZQeDVkOWM0OXJVeWE1V08wSzQxQVkvYlhwMmZkU25naE1hLzRDb1QveHRs?=
 =?utf-8?B?WUsrZ0N0WHRwekRvVjJXWEs4YzYwbnU2djgwRWUveXlmL1NOMWoyNkxZM05s?=
 =?utf-8?B?WUxzTzY4OVhsZGk0LzhLMXRNZ2lFNklPUGtmenVrV1NYelRWblNOQzVJNUtx?=
 =?utf-8?B?VU16bTNTQVphWHF6cHNuY0IzdXVFSzJOdEJDdnRIMVZiY0lZUysyZ3dsSS9v?=
 =?utf-8?B?TzNTZlBNRWRGK3B3OUFsRDBtYXZCd2EzYjJRVXkwYllTMTRlWG9JTTdPYnpj?=
 =?utf-8?B?NTArVVVRSnlhR0hJMTVuUThEczdidDg0NGVaT0ExVy96YnR0b3VZc05GZjlM?=
 =?utf-8?B?bUJoMHl1U1VGbzNXOUNDQlZReXYrTG5zS1dsR0xCaUx3bjZTdm4yMTA4T3J0?=
 =?utf-8?B?T29vWkJ1ckRBcmhuM0FyMGhaV1RBVWVWSXg2MlJHWWt6aTdpOWw5bVVxUXk0?=
 =?utf-8?B?ajVsMkREbjJFMkpUS1JKT1h6cDZ0dmxSdXhDN2EvZnVWRWdPdkx0Y2Z1VDB3?=
 =?utf-8?B?emZqam93UmZwOVNDa2U2NEU4bzlGN1hocXVuaGVHc0ZBTWdyamdrZ2xVZWwr?=
 =?utf-8?B?aGZNZEdlalRMck1BaWkxc3hJMlZFZ3UwQzBTNnZpdXl2WmlaamRvS1hkYVNw?=
 =?utf-8?B?V2pUZUpjc1g2M1MzaUt0NXNpY1dMUkRGaXdLdjByUEViWVJRVnZ6STRuZFdt?=
 =?utf-8?B?M3VSRTNtZUlnU1Ftd2NnQzNOSUVpWi9rUWR3RGxkeU1YMm9idHlNbnQycENC?=
 =?utf-8?B?ZWpXdk5pVFcyemlOaGhBeU5WVGlVUVpBbzVuQ0dXdU12c3lvaUdKWVYwd1FU?=
 =?utf-8?B?T0ZETDc3bWtWaHVQdEZTUkdrcnU0cEFyVFlpWWtQRXd0TzZFcGw5TksxZEhG?=
 =?utf-8?B?S0F1T1RmSk1jY3diNUZ5VmJsbjZ4L0ZUOVZ1cGQ1enZBbVR6SHJjNE53Yjkw?=
 =?utf-8?B?K1hjK2c0NDFiRExYKzdxcU9kelc2aC9ZSGpBR3lxU0YzOEgwSktETXVlZWZt?=
 =?utf-8?B?ZmU5ZGMweWxFdDczUkVwSHdPSEh3Sk9iK2tnWDVQQUdVMG5hSEZydmVudzQy?=
 =?utf-8?B?MVUyeUhVUE5QL014MVJseU9BOFViVDRqU3NYd2RoUjg3WVdsbE1Uc3U5T3BC?=
 =?utf-8?B?dFJPYytmaktRWFhWRndSbm1UZC9FNVBUMzh2Wk1EMHFHc3gzYVlwdHd1VFdD?=
 =?utf-8?B?MVRvczlwbHhLbk9rcFVmRGJ5aHFCRHFvUll5MEVQSTVHaXlLdjhkMkE2aStE?=
 =?utf-8?B?YkFKR1g5QUlTVTMySGV4SEt6YllQeHhySk9kVUUyblRUaGh3c0ttWjlsT0ZI?=
 =?utf-8?B?SkV1LytkMFU3WkVERWFPOVJpdGJmenRpUXE3REFmNDZXMjdwQTVDbUVoSkRa?=
 =?utf-8?B?STQ0YkV3L2kzUml0MlNHSWFiZWNsMmwzVVB4T0ZUaEJiNGdBMmNISHhUYUxB?=
 =?utf-8?B?ZEU4TzRSY3QvNTlQMWpqTk9lTUZNV3F6Tlh4Y3ZxdW0zQUpmSVh0WUkzZDhW?=
 =?utf-8?B?TEJQdXBLOHVZdXRzWTQyU01KOU9ybERYcno4ckswMjBPOWRyajJLMGp5L2VH?=
 =?utf-8?B?WUgxRjNmTkk4aHhNWm9ZSlNEeUY5R2VTUi9LYlgrcFJrQkQ0bXkzdmYwL3gy?=
 =?utf-8?B?OXkrenpvWUJ3d2JVN2IxNHUzNmJoUEp4RWFwQkpsU1EwbVRDQytHZ2ZQU0Z2?=
 =?utf-8?B?NG1NdTlBbFZhdituYVlpUkZLVU5oOU9MVkdOVURMU1Z0RnkxbGNWdzNhRndO?=
 =?utf-8?B?anh1OG9EZGZIN3VPR0FmU2Q2OFNZYnhXMnowMnZOalRDQ2xHVVRON2NLMnJq?=
 =?utf-8?B?RnNPdTdEam4vdG95Z01HNTZoMnVsMTFuYVB6VXVqWUxFSDBnVVN4SVcrOWtW?=
 =?utf-8?B?YWRqbW44VXZzblV0enBlZEZULzRvS1Y5eHhFMDdTUXpVQlgwZVY5VG96Z09n?=
 =?utf-8?B?b1JrN0VYQzBOYTRRcHlNcC9pOE5BPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3CF37196B541664A8FEB92EB1F6748F0@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5150.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14571f3d-afdb-40d0-1462-08da7394f929
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 08:08:09.8606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ekcu+BBBkUlSK/RMuWzMj/GH6Bd6trZHSUByoEsfeJFEe43xQ9dQUWL3sBFwp5rofDsvCf6AHHoRzju1FghnQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB2959
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW55IGNvbW1lbnRzIG9uIHRoaXMgcGF0Y2gsIG9yIGNhbiBpdCBiZSBtZXJnZWQ/DQoNClNhZWVk
IHJldmlld2VkIHRoZSBtbHg1IHBhcnQuDQoNCkJqw7ZybiwgTWFnbnVzLCBNYWNpZWosIGFueXRo
aW5nIHRvIHNheSBhYm91dCB0aGUgWFNLIGRydiBwYXJ0Pw0KDQpPbiBGcmksIDIwMjItMDctMjkg
YXQgMTU6MTMgKzAzMDAsIE1heGltIE1pa2l0eWFuc2tpeSB3cm90ZToNCj4gU3RyaWRpbmcgUlEg
dXNlcyBNVFQgcGFnZSBtYXBwaW5nLCB3aGVyZSBlYWNoIHBhZ2UgY29ycmVzcG9uZHMgdG8gYW4g
WFNLDQo+IGZyYW1lLiBNVFQgcGFnZXMgaGF2ZSBhbGlnbm1lbnQgcmVxdWlyZW1lbnRzLCBhbmQg
WFNLIGZyYW1lcyBkb24ndCBoYXZlDQo+IGFueSBhbGlnbm1lbnQgZ3VhcmFudGVlcyBpbiB0aGUg
dW5hbGlnbmVkIG1vZGUuIEZyYW1lcyB3aXRoIGltcHJvcGVyDQo+IGFsaWdubWVudCBtdXN0IGJl
IGRpc2NhcmRlZCwgb3RoZXJ3aXNlIHRoZSBwYWNrZXQgZGF0YSB3aWxsIGJlIHdyaXR0ZW4NCj4g
YXQgYSB3cm9uZyBhZGRyZXNzLg0KPiANCj4gRml4ZXM6IDI4MmMwYzc5OGY4ZSAoIm5ldC9tbHg1
ZTogQWxsb3cgWFNLIGZyYW1lcyBzbWFsbGVyIHRoYW4gYSBwYWdlIikNCj4gU2lnbmVkLW9mZi1i
eTogTWF4aW0gTWlraXR5YW5za2l5IDxtYXhpbW1pQG52aWRpYS5jb20+DQo+IFJldmlld2VkLWJ5
OiBUYXJpcSBUb3VrYW4gPHRhcmlxdEBudmlkaWEuY29tPg0KPiBSZXZpZXdlZC1ieTogU2FlZWQg
TWFoYW1lZWQgPHNhZWVkbUBudmlkaWEuY29tPg0KPiAtLS0NCj4gIC4uLi9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oICAgIHwgMTQgKysrKysrKysrKysrKysNCj4g
IGluY2x1ZGUvbmV0L3hkcF9zb2NrX2Rydi5oICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTEg
KysrKysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgMjUgaW5zZXJ0aW9ucygrKQ0KPiANCj4g
ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94
c2svcnguaCBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2sv
cnguaA0KPiBpbmRleCBhOGNmYWI0YTM5M2MuLmNjMThkOTdkOGVlMCAxMDA2NDQNCj4gLS0tIGEv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hzay9yeC5oDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbi94c2svcnguaA0K
PiBAQCAtNyw2ICs3LDggQEANCj4gICNpbmNsdWRlICJlbi5oIg0KPiAgI2luY2x1ZGUgPG5ldC94
ZHBfc29ja19kcnYuaD4NCj4gIA0KPiArI2RlZmluZSBNTFg1RV9NVFRfUFRBR19NQVNLIDB4ZmZm
ZmZmZmZmZmZmZmZmOFVMTA0KPiArDQo+ICAvKiBSWCBkYXRhIHBhdGggKi8NCj4gIA0KPiAgc3Ry
dWN0IHNrX2J1ZmYgKm1seDVlX3hza19za2JfZnJvbV9jcWVfbXB3cnFfbGluZWFyKHN0cnVjdCBt
bHg1ZV9ycSAqcnEsDQo+IEBAIC0yMSw2ICsyMyw3IEBAIHN0cnVjdCBza19idWZmICptbHg1ZV94
c2tfc2tiX2Zyb21fY3FlX2xpbmVhcihzdHJ1Y3QgbWx4NWVfcnEgKnJxLA0KPiAgc3RhdGljIGlu
bGluZSBpbnQgbWx4NWVfeHNrX3BhZ2VfYWxsb2NfcG9vbChzdHJ1Y3QgbWx4NWVfcnEgKnJxLA0K
PiAgCQkJCQkgICAgc3RydWN0IG1seDVlX2RtYV9pbmZvICpkbWFfaW5mbykNCj4gIHsNCj4gK3Jl
dHJ5Og0KPiAgCWRtYV9pbmZvLT54c2sgPSB4c2tfYnVmZl9hbGxvYyhycS0+eHNrX3Bvb2wpOw0K
PiAgCWlmICghZG1hX2luZm8tPnhzaykNCj4gIAkJcmV0dXJuIC1FTk9NRU07DQo+IEBAIC0zMiw2
ICszNSwxNyBAQCBzdGF0aWMgaW5saW5lIGludCBtbHg1ZV94c2tfcGFnZV9hbGxvY19wb29sKHN0
cnVjdCBtbHg1ZV9ycSAqcnEsDQo+ICAJICovDQo+ICAJZG1hX2luZm8tPmFkZHIgPSB4c2tfYnVm
Zl94ZHBfZ2V0X2ZyYW1lX2RtYShkbWFfaW5mby0+eHNrKTsNCj4gIA0KPiArCS8qIE1UVCBwYWdl
IG1hcHBpbmcgaGFzIGFsaWdubWVudCByZXF1aXJlbWVudHMuIElmIHRoZXkgYXJlIG5vdA0KPiAr
CSAqIHNhdGlzZmllZCwgbGVhayB0aGUgZGVzY3JpcHRvciBzbyB0aGF0IGl0IHdvbid0IGNvbWUg
YWdhaW4sIGFuZCB0cnkNCj4gKwkgKiB0byBhbGxvY2F0ZSBhIG5ldyBvbmUuDQo+ICsJICovDQo+
ICsJaWYgKHJxLT53cV90eXBlID09IE1MWDVfV1FfVFlQRV9MSU5LRURfTElTVF9TVFJJRElOR19S
USkgew0KPiArCQlpZiAodW5saWtlbHkoZG1hX2luZm8tPmFkZHIgJiB+TUxYNUVfTVRUX1BUQUdf
TUFTSykpIHsNCj4gKwkJCXhza19idWZmX2Rpc2NhcmQoZG1hX2luZm8tPnhzayk7DQo+ICsJCQln
b3RvIHJldHJ5Ow0KPiArCQl9DQo+ICsJfQ0KPiArDQo+ICAJcmV0dXJuIDA7DQo+ICB9DQo+ICAN
Cj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbmV0L3hkcF9zb2NrX2Rydi5oIGIvaW5jbHVkZS9uZXQv
eGRwX3NvY2tfZHJ2LmgNCj4gaW5kZXggNGFhMDMxODQ5NjY4Li4wNzc0Y2U5N2MyZjEgMTAwNjQ0
DQo+IC0tLSBhL2luY2x1ZGUvbmV0L3hkcF9zb2NrX2Rydi5oDQo+ICsrKyBiL2luY2x1ZGUvbmV0
L3hkcF9zb2NrX2Rydi5oDQo+IEBAIC05NSw2ICs5NSwxMyBAQCBzdGF0aWMgaW5saW5lIHZvaWQg
eHNrX2J1ZmZfZnJlZShzdHJ1Y3QgeGRwX2J1ZmYgKnhkcCkNCj4gIAl4cF9mcmVlKHhza2IpOw0K
PiAgfQ0KPiAgDQo+ICtzdGF0aWMgaW5saW5lIHZvaWQgeHNrX2J1ZmZfZGlzY2FyZChzdHJ1Y3Qg
eGRwX2J1ZmYgKnhkcCkNCj4gK3sNCj4gKwlzdHJ1Y3QgeGRwX2J1ZmZfeHNrICp4c2tiID0gY29u
dGFpbmVyX29mKHhkcCwgc3RydWN0IHhkcF9idWZmX3hzaywgeGRwKTsNCj4gKw0KPiArCXhwX3Jl
bGVhc2UoeHNrYik7DQo+ICt9DQo+ICsNCj4gIHN0YXRpYyBpbmxpbmUgdm9pZCB4c2tfYnVmZl9z
ZXRfc2l6ZShzdHJ1Y3QgeGRwX2J1ZmYgKnhkcCwgdTMyIHNpemUpDQo+ICB7DQo+ICAJeGRwLT5k
YXRhID0geGRwLT5kYXRhX2hhcmRfc3RhcnQgKyBYRFBfUEFDS0VUX0hFQURST09NOw0KPiBAQCAt
MjM4LDYgKzI0NSwxMCBAQCBzdGF0aWMgaW5saW5lIHZvaWQgeHNrX2J1ZmZfZnJlZShzdHJ1Y3Qg
eGRwX2J1ZmYgKnhkcCkNCj4gIHsNCj4gIH0NCj4gIA0KPiArc3RhdGljIGlubGluZSB2b2lkIHhz
a19idWZmX2Rpc2NhcmQoc3RydWN0IHhkcF9idWZmICp4ZHApDQo+ICt7DQo+ICt9DQo+ICsNCj4g
IHN0YXRpYyBpbmxpbmUgdm9pZCB4c2tfYnVmZl9zZXRfc2l6ZShzdHJ1Y3QgeGRwX2J1ZmYgKnhk
cCwgdTMyIHNpemUpDQo+ICB7DQo+ICB9DQoNCg==
