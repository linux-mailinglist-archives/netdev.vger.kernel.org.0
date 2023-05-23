Return-Path: <netdev+bounces-4756-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8672270E1DA
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 18:35:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AF8201C20E43
	for <lists+netdev@lfdr.de>; Tue, 23 May 2023 16:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 088D620682;
	Tue, 23 May 2023 16:35:36 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA7411F18C;
	Tue, 23 May 2023 16:35:35 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2046.outbound.protection.outlook.com [40.107.220.46])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E12341A8;
	Tue, 23 May 2023 09:35:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hedC9pp+ZHiou2SSg4wehsYr8bQ+41eK3m1Ruhp0Bd/Cod5mE3C6tRBI5JqK5EAt8sIi+53iY+ZYhYntrCBVJ48v/UF21TCtIY/xPX+HD36Y8ZuAns+9QeX5SUAOi/Z2gHUSTSbQrPstF2nk1TCo8MAU8PZsQ2SRqPfeQ1tswEINXALVzQJF961rzjGHLlLknYwg83ZgJOAv9rKVax5/9X62aaUHSzI3XTt+pjqflF8/mCUEEU9hCGQAMbifg+smsDnFjymfsMWBsK1PAQB3jsMZF7NAxWx4ffYkqE2DDjJ7oSMcptbtiddgKPttukYOG9zqA63MXRQFnNtGTmASiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ByXLCCMgpa+Ghj7i2jJLqjRoXdlekfGvNqlxmIItCZk=;
 b=IBLjsz1pBocHa9U7S8N6u7O8DyIIWnfH9SERceVGOPBxi5k1FfY7JYPUTu73P1UvvWuyh9bIj7AMFgM1vp3REOmN7JhrqN1JYHzCs1ixWdNyVxggfuTNTiAnoXWameQxiOnfA1sOEhAUWj+bgq60SFVAtdJOlDHLTFFfxM1AIXU0F0JyGnSx+DtuEsDcHMQ8/WpkWCsNiohhiCuW5uy2N7Jg3EqoMvgGd+bMd0GpXbPsmakBAvF7ZKHCTk1XdGP8u0lFLkJsCRY2rmNFqCk4N9BuEFYTwnDIHqDep/gMjeJwnjFwF4LWXa/So/aI2HWLNiB2asHfPHakMtUhcp2KBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ByXLCCMgpa+Ghj7i2jJLqjRoXdlekfGvNqlxmIItCZk=;
 b=W/Sp5gRcpIduDbVl15Gx0F7o+8fF/VnuB7bTXDlhaJbarPq2hI3Q5YfEoUO5S/JMK5MT7d4jetCsMpt6V1St11P+BudHLeOwpMCwaV2ZPvOsT0A9kVAGWJeMjwfqc6IogsOEIVSvwtTeUonXkxdRueR+tZSOQBxoGb6RYfxzOj9Bp2maxOFgYImimrT8Eegf6v9ixBxvN7oaRf36HSlC56YZFhpg1dHxF5/iPt1S/76pkhXS2+NM4V1EnsWEK+R3uMCnqBEfZv+B5Zw45PQ/snqSr2HnAGC7g8uYWzQD+OcB/ChudDZpIp8rJre5n4wvDrKYqxfzS/ec0tyo0qqiQg==
Received: from DM6PR12MB5565.namprd12.prod.outlook.com (2603:10b6:5:1b6::13)
 by PH7PR12MB7116.namprd12.prod.outlook.com (2603:10b6:510:1ef::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.14; Tue, 23 May
 2023 16:35:16 +0000
Received: from DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02]) by DM6PR12MB5565.namprd12.prod.outlook.com
 ([fe80::9e8a:eef5:eb8a:4a02%6]) with mapi id 15.20.6411.028; Tue, 23 May 2023
 16:35:16 +0000
From: Dragos Tatulea <dtatulea@nvidia.com>
To: Tariq Toukan <tariqt@nvidia.com>, "ttoukan.linux@gmail.com"
	<ttoukan.linux@gmail.com>, "jbrouer@redhat.com" <jbrouer@redhat.com>, Saeed
 Mahameed <saeedm@nvidia.com>, "saeed@kernel.org" <saeed@kernel.org>,
	"linyunsheng@huawei.com" <linyunsheng@huawei.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>
CC: "maxtram95@gmail.com" <maxtram95@gmail.com>, "lorenzo@kernel.org"
	<lorenzo@kernel.org>, "alexander.duyck@gmail.com"
	<alexander.duyck@gmail.com>, "kheib@redhat.com" <kheib@redhat.com>,
	"ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
	"mkabat@redhat.com" <mkabat@redhat.com>, "brouer@redhat.com"
	<brouer@redhat.com>, "atzin@redhat.com" <atzin@redhat.com>,
	"fmaurer@redhat.com" <fmaurer@redhat.com>, "bpf@vger.kernel.org"
	<bpf@vger.kernel.org>, "jbenc@redhat.com" <jbenc@redhat.com>
Subject: Re: mlx5 XDP redirect leaking memory on kernel 6.3
Thread-Topic: mlx5 XDP redirect leaking memory on kernel 6.3
Thread-Index: AQHZjY743nR7ST598kifD6Q1M3DiL69oDfyA
Date: Tue, 23 May 2023 16:35:16 +0000
Message-ID: <00ca7beb7fe054a3ba1a36c61c1e3b1314369f11.camel@nvidia.com>
References: <d862a131-5e31-bd26-84f7-fd8764ca9d48@redhat.com>
In-Reply-To: <d862a131-5e31-bd26-84f7-fd8764ca9d48@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Evolution 3.48.1 (3.48.1-1.fc38) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB5565:EE_|PH7PR12MB7116:EE_
x-ms-office365-filtering-correlation-id: deeb8079-b407-4406-1e8e-08db5babb090
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 TE1rSC3zxdIC7GfSAU9m8Wi+sE6oSeXZLZWkEPKCzdCv1ahiJ0cjbw0fUUkRDuEXjzQM+hDaqcuAMh2vpuVqTUitdooaRs8m/0EgNzuXTmlnrMztyxUb+6HdeJu5O5vXAnqD5v4O8aNdZTgluXAtzAEhTj6T9PwUkNs+IXeMK/Vt+JzdQrbolZ5KgdVWEVBiMTBauAEuyUncn8t9w2wnll+qBznuwwsb5v+/VFFfAOM4aCR37lXaUEJ+o3KovwGF292EphG4nxiLw0WQDT5/F0L6faRZoQo6rxbvpj7itvvaLXNXBST1cMAUR3SmJkGvsCmebeWM3ULfbqFoGs7p3HBMyfQURmNWhXPHZH8GsHXKcioHs1LnDVd4aZpGOwyCXi7WbbYHZOr5k/GMNWySLaGU4uvfl83D1kkeg+gffMaxp1hNeGkUn1q942yVuEOEDdmj/40N/uBFZOtod/kY3G/aM7hhB86RBgvUc6rOfC03SGWaRGhCpCXxWo3rYKcGTXVJphI150nao0R26BfwrPlp9RkSMZ2DDrv94MfX+FBvBhGQrvBs3h66aIN8EgIiOqBMGdxyg/g4MEWJV1ZVeuKIPoZjrdCBk8NCrY7vVeXS93oWuXY693CUV9GdiGi2sGnAEvksX24MZLD0iPOO5smqMgUFk868cwsyrM0+7+05HbCueNgUuzYplnMe9O8UUvxo6bAwKS/oSk8oUF/6Yw==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB5565.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(366004)(136003)(346002)(376002)(396003)(451199021)(2906002)(2616005)(186003)(83380400001)(6486002)(66476007)(64756008)(66446008)(76116006)(66946007)(41300700001)(66556008)(91956017)(316002)(71200400001)(4326008)(110136005)(54906003)(478600001)(7416002)(5660300002)(6512007)(6506007)(966005)(8676002)(8936002)(38100700002)(122000001)(36756003)(86362001)(38070700005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SEFHd0ZpbWVYUG9TRC8zc1ZxY0twUWZNdmU3ZDZjc2RDMkI5cTJnWHFCMFg4?=
 =?utf-8?B?SWF6cysySjBpNkFWS0lZcSs3U25LQ0NXbWRaMHpMdm1ZbVQ4YjJocHpuRTh1?=
 =?utf-8?B?YlN0MnM0bkdickdMbXJxTElkRm1OY0xQYWtMOVhvY3JsaE1VanFFYXBTWmho?=
 =?utf-8?B?MUpuVk13Z1ErMDBySkdyVUx1OEpBNmJKUldxOXd5dmFFdmhKdFgzeHlRTmxB?=
 =?utf-8?B?a2xuNnppUmVuSFVKaTBRWjNMaHd2TUJRSXl6WGxoU21aU2ZXd1VCKzFiZEVv?=
 =?utf-8?B?Vkd2cFR5Um12OFM2U1htTVBxd3JjdStMYnA3bWt0OG5RSEVFVjJRc2IzRW0z?=
 =?utf-8?B?dUY0b2hNb20rcU9RWkVXbk1FV0UxTmRhQkh0MER1VE1EZjFkNWNncmk2ZHlD?=
 =?utf-8?B?aW1BR3VydVJOMlFRd3ZkU3RtTERLU1Q4eG5NeFp2TmJOU2tVVUdJNUlsS1dE?=
 =?utf-8?B?UTZNclBTZVk0ckpuZld0MU9yRjFlQjVUMVp4RXgrbHFPdFY4OHkxc3VyZENn?=
 =?utf-8?B?bEQ4azdXc1VRY0FrMXJjOWFEaDhDVUFaTmg2MjJvRU1aMCs0TWxPQUx5d05k?=
 =?utf-8?B?a01iTmNSeCtmUmlsTnNXdjdXdFhiUDl0MTh0WDFEL2k3YkVxbTkzeUVRZzRq?=
 =?utf-8?B?YzU5SEJrU3lRNnI5eERXWTkwcHpxdVJQcG0xSjlwcGkvamZYTGxHQjU0dThK?=
 =?utf-8?B?aUR6MVB3RjhlT2ZDOEt5Z3EzckllMkpuZkF6RnFhTmNvNlUvNGNjSUE1aWJT?=
 =?utf-8?B?VC9MdGV5RmwreFlUU0o3VFJibWp1Q0JvV0NpZ2tzZGFwUEp2eUF2SS82Z0Zx?=
 =?utf-8?B?bk9rUWg4czlTdkJ5YVl4WVZDdkZINjhMTWY5RHg3MFFyaHFUbWhQYy9kT1NZ?=
 =?utf-8?B?V1RYNWdzTEhDS0dkK2RTbUNzeldIZG5BNjFqVFMxRGEyQ3k1V0duU1JlSUpE?=
 =?utf-8?B?MEpIeUluTFVnWGNNb0xNVjIySHVhNXRuTTkwZWlNZk85clhqdjJQYVVQWnN3?=
 =?utf-8?B?NzFwdWYrallvOVhOS1h0SUhKb1RxekMvYkd1MVprbjVxd0FzRzI0VlI1bko1?=
 =?utf-8?B?QlBrWXp5YTRTdTIxc2Rua3Z0SGxHSUtJVU1qd25ST3NXQzdYYVZDUlhONVI3?=
 =?utf-8?B?L2FqdC9uMkovZHc5bytUa0xzcU1JVTN3Wk81MUJvNlBhSTFyZS9VbGttV0hp?=
 =?utf-8?B?WGtHQlE3Nks5ZWdYd1MySHFsWmxZSll3bXFxUUtzMTZ5anFUNkN6VEZzMDB3?=
 =?utf-8?B?WW5ZalA2MHJwU2d3RS84NDIyc0dqU1BmWU96dFhyMHNnZ1B1eThUZ1VHSjdq?=
 =?utf-8?B?RkJmR0RZTGRoTkZld2szMy9xWm5sNVVmYS94bnVMdFZKWDh3Skg0T2lNYzJO?=
 =?utf-8?B?VjhxQ0VQdmlpaGhpeHZBSytINVdjSGxBTldXdlRoYzU2M2x5THAvRWFVMTFZ?=
 =?utf-8?B?T0dMcFBkMndpT2haRnY0czhoOVRxaStpQzNLNkoyYVh2S2VDZjJueE1PYXVH?=
 =?utf-8?B?djVDOFc3aXZ3TkNjZVM5Qld0aG95c0x6c05SamcyL2tOQlJNR0lUb0JKWnBU?=
 =?utf-8?B?bUM1QWlBd09FVzVNTG4rcG5ublRFamN6ckl0ZmxFcXg2anBQYnFEZE81UTVz?=
 =?utf-8?B?enNTOVYrS1ArYlFpa2l0bEJIcWRtb2hCQkxuWDZjWk4wbklGUHNhSTJvRlJl?=
 =?utf-8?B?Q2hhNllzRlhRWUp2dHZpT3E5a0ZONm5nWW5tWG8wZDZsTUFuSHg3QnIvOUxP?=
 =?utf-8?B?NEUvUHBZSk02VS9Wck9ZZ2RjZys1VURuQzY5SW1UczdqMjh6ZnRJc0JVWnRp?=
 =?utf-8?B?ZkxPNFozK09SQUdmZEZvVThOU2hnNXk0U0gzZzRFaWRqTkJMeFpidm01YStX?=
 =?utf-8?B?bHl3dy9BSWIrZ0YxZjVYamZyRUVQdnZuQUZsVWEwWUxqQ3NtQU9GNGlnMXJx?=
 =?utf-8?B?cmRBS3BobFlENTB5K1l2bVpEOGMzUXlvK3VCSU9XWiszS2JsSU1CUm5ZL1Fj?=
 =?utf-8?B?aTZIb3NpbVg5NWpzTEtDbmxYTkVyM3graGFoRTB4MXlwNllNTkFzWnNQYkNJ?=
 =?utf-8?B?M3ZIeEwvSm1qZTZJYmtIZ1F0M2Y0M29xQUduMWdaRDZpeWdsaVIvVXZkMnpw?=
 =?utf-8?B?eGRuWkVud3d2Zk9zdTU1YnNoMmhDOFpnWlljbWkvaG11OUtPYmtuUG9lNjlT?=
 =?utf-8?Q?rrbil2A+twkIdDVPwaPSqf1WrExskLwHzU0xY3oqkZkK?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5AD61064CA361948B13B111EC993BAC2@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB5565.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: deeb8079-b407-4406-1e8e-08db5babb090
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 May 2023 16:35:16.2622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mjc7vD/1NZ5iAKHZ9E7M7bXMf7eEUG1tDqOILidZsxzzz2iZjcQv4WmrzgLXRpBQKU4BmRV18Cz7YOk/YVci7Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR12MB7116
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQpPbiBUdWUsIDIwMjMtMDUtMjMgYXQgMTc6NTUgKzAyMDAsIEplc3BlciBEYW5nYWFyZCBCcm91
ZXIgd3JvdGU6DQo+IA0KPiBXaGVuIHRoZSBtbHg1IGRyaXZlciBydW5zIGFuIFhEUCBwcm9ncmFt
IGRvaW5nIFhEUF9SRURJUkVDVCwgdGhlbiBtZW1vcnkNCj4gaXMgZ2V0dGluZyBsZWFrZWQuIE90
aGVyIFhEUCBhY3Rpb25zLCBsaWtlIFhEUF9EUk9QLCBYRFBfUEFTUyBhbmQgWERQX1RYDQo+IHdv
cmtzIGNvcnJlY3RseS4gSSB0ZXN0ZWQgYm90aCByZWRpcmVjdGluZyBiYWNrIG91dCBzYW1lIG1s
eDUgZGV2aWNlIGFuZA0KPiBjcHVtYXAgcmVkaXJlY3QgKHdpdGggWERQX1BBU1MpLCB3aGljaCBi
b3RoIGNhdXNlIGxlYWtpbmcuDQo+IA0KPiBBZnRlciByZW1vdmluZyB0aGUgWERQIHByb2csIHdo
aWNoIGFsc28gY2F1c2UgdGhlIHBhZ2VfcG9vbCB0byBiZQ0KPiByZWxlYXNlZCBieSBtbHg1LCB0
aGVuIHRoZSBsZWFrcyBhcmUgdmlzaWJsZSB2aWEgdGhlIHBhZ2VfcG9vbCBwZXJpb2RpYw0KPiBp
bmZsaWdodCByZXBvcnRzLiBJIGhhdmUgdGhpcyBicGZ0cmFjZVsxXSB0b29sIHRoYXQgSSBhbHNv
IHVzZSB0byBkZXRlY3QNCj4gdGhlIHByb2JsZW0gZmFzdGVyIChub3Qgd2FpdGluZyA2MCBzZWMg
Zm9yIGEgcmVwb3J0KS4NCj4gDQo+IMKgIFsxXSANCj4gaHR0cHM6Ly9naXRodWIuY29tL3hkcC1w
cm9qZWN0L3hkcC1wcm9qZWN0L2Jsb2IvbWFzdGVyL2FyZWFzL21lbS9icGZ0cmFjZS9wYWdlX3Bv
b2xfdHJhY2tfc2h1dGRvd24wMS5idA0KPiANCj4gSSd2ZSBiZWVuIGRlYnVnZ2luZyBhbmQgcmVh
ZGluZyB0aHJvdWdoIHRoZSBjb2RlIGZvciBhIGNvdXBsZSBvZiBkYXlzLA0KPiBidXQgSSd2ZSBu
b3QgZm91bmQgdGhlIHJvb3QtY2F1c2UsIHlldC4gSSB3b3VsZCBhcHByZWNpYXRlIG5ldyBpZGVh
cw0KPiB3aGVyZSB0byBsb29rIGFuZCBmcmVzaCBleWVzIG9uIHRoZSBpc3N1ZS4NCj4gDQo+DQo+
IFRvIExpbiwgaXQgbG9va3MgbGlrZSBtbHg1IHVzZXMgUFBfRkxBR19QQUdFX0ZSQUcsIGFuZCBt
eSBjdXJyZW50DQo+IHN1c3BpY2lvbiBpcyB0aGF0IG1seDUgZHJpdmVyIGRvZXNuJ3QgZnVsbHkg
cmVsZWFzZSB0aGUgYmlhcyBjb3VudCAoaGludA0KPiBzZWUgTUxYNUVfUEFHRUNOVF9CSUFTX01B
WCkuDQo+IA0KDQpUaGFua3MgZm9yIHRoZSByZXBvcnQgSmVzcGVyLiBJbmNpZGVudGFsbHkgSSd2
ZSBqdXN0IHBpY2tlZCB1cCB0aGlzIGlzc3VlIHRvZGF5DQphcyB3ZWxsLg0KDQpPbiBYRFAgcmVk
aXJlY3QgYW5kIHR4LCB0aGUgcGFnZSBpcyBzZXQgdG8gc2tpcCB0aGUgYmlhcyBjb3VudGVyIHJl
bGVhc2Ugd2l0aA0KdGhlIGV4cGVjdGF0aW9uIHRoYXQgcGFnZV9wb29sX3B1dF9kZWZyYWdnZWRf
cGFnZSB3aWxsIGJlIGNhbGxlZCBmcm9tIFsxXS4gQnV0LA0KYXMgSSBmb3VuZCBvdXQgbm93LCBk
dXJpbmcgWERQIHJlZGlyZWN0IG9ubHkgb25lIGZyYWdtZW50IG9mIHRoZSBwYWdlIGlzDQpyZWxl
YXNlZCBpbiB4ZHAgY29yZSBbMl0uIFRoaXMgaXMgd2hlcmUgdGhlIGxlYWsgaXMgY29taW5nIGZy
b20uDQoNCldlJ2xsIHByb3ZpZGUgYSBmaXggc29vbi4NCg0KWzFdDQpodHRwczovL2dpdC5rZXJu
ZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9uZXRkZXYvbmV0LW5leHQuZ2l0L3RyZWUv
ZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuL3hkcC5jI242NjUNCg0K
WzJdDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC9uZXRk
ZXYvbmV0LW5leHQuZ2l0L3RyZWUvbmV0L2NvcmUveGRwLmMjbjM5MA0KDQpUaGFua3MsDQpEcmFn
b3MNCg0KDQo=

