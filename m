Return-Path: <netdev+bounces-6679-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5C24F71769E
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 08:06:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1214A281367
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 06:06:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1940363BC;
	Wed, 31 May 2023 06:06:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E1020F3
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 06:06:40 +0000 (UTC)
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2056.outbound.protection.outlook.com [40.107.220.56])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4753E11D;
	Tue, 30 May 2023 23:06:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C6V+dnlsO7Fb45xuRjdRg8pPIfup/XdeGXYjv6EeOBYAVWqJw7e8riaGzOl00MdZ1jgIcee+lcYLyxzQckt0GCmay1IOS4w2IEwcIioCXugzCy/z4FMOaZk/SNPAFNZf2GW4dGjcEOOkumgBBUxB986s9G7MCTY2UOczJCbArPD2oEgcXt+WhR2EMNfyLy9X7i8hGPoM5XtaLQxy4WskqtX7+v2hUEFQsUW4Ss2UJ3zov1BGohUA5q3DwZmZrq04gCux+8uiSGKdL5LLY5ga04mtfB4MVwuao77mSO+3ffqEqJwADvJrwsw+9iaCqCLYBhula4/UIhr7JFrdFt5EJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ds7yLsyKuhtDq476rWdAEl5Cj69AXQlNjwfComFuK1o=;
 b=ZK5XYRrbgPn9j5Zkuagfx2Gw1SgkPRqhDMBXPuUovT4deLynCIvwnACja8UoNUES1YxnDNJiBj6ADPBVWdVWBOh85aFZnpgr8aCzCMAgnowLJY5xgN2vKb58eZUb47HjDG/g8olq/qx8ZoMRJj4BLXBH8WkTrwA0lEn1V7B3PZFJV+I9bllSiPQ3aH0gspqQH3fgMZtWm4rOPKlnVWq8obp1tYZmTmndo8iXWKmF9DWuqHB8F/hoOErIkzs5mA31sMTe7Z5vOn4NFoKrLBiPHerJr9FO1hW3z9yWD1PtKO/mPvGDwp/81SBRbX0lMnVW2notqSPMbaySSpuJaYEw1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ds7yLsyKuhtDq476rWdAEl5Cj69AXQlNjwfComFuK1o=;
 b=ksvw3UpxfWlH5fAINIPgguQr7SFcNEWXv/2/wPbQSEJGWjjshIXy6N7tC4+QrjZ6HnsY+IZsWWJywpdIhOkB0aZYBD/uPph6T/DcPHnHHXCecTcFU2NYlk2Jnf1k0nqcejUB+VQgM7766tbe84jEIk29OKIfSfLcXjK1aXKkELKwgN4vdimeyPuhJGXoPyvMsIplM9dId40OKu94nKUOE0rrvEGrgEMXdR3YxKYROB+fBy4KNQ0E2ULqDi0jWJlndfVkw0oC0s9vl8Y7YLi1w/N3l5nbSC8SmDfQuI44ZvNswDl+yFEtpbH3ERzRkq9oU/r+IsSU9JHM3AjJVstJNw==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 CY5PR12MB6347.namprd12.prod.outlook.com (2603:10b6:930:20::10) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6433.22; Wed, 31 May 2023 06:06:36 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::20d3:3ec7:5609:da29]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::20d3:3ec7:5609:da29%7]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 06:06:36 +0000
From: Eli Cohen <elic@nvidia.com>
To: Niklas Schnelle <schnelle@linux.ibm.com>, Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>, "David
 S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [PATCH net] net/mlx5: Fix setting of irq->map.index for static
 IRQ case
Thread-Topic: [PATCH net] net/mlx5: Fix setting of irq->map.index for static
 IRQ case
Thread-Index: AQHZkwDhjyJj7/M2mkCYVLE8ZxJkNa9z5Xlw
Date: Wed, 31 May 2023 06:06:36 +0000
Message-ID:
 <DM8PR12MB540061C3FF83D1E77108F2BBAB489@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20230530141304.1850195-1-schnelle@linux.ibm.com>
In-Reply-To: <20230530141304.1850195-1-schnelle@linux.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR12MB5400:EE_|CY5PR12MB6347:EE_
x-ms-office365-filtering-correlation-id: 63d7455f-dc98-461d-0452-08db619d3158
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Yeab52j4KUUBx7RSz47J82k21YxoYYI1nJQmhBfl9MSBYmcOsyFH9AUE6XrIy0lENLhrIoxIrxjNHgpEQTKV3eTXDN9/nrZm3X+dlfPxkorJWwAMwJZdvtFlXvGmRVcfvK/3rm36rW5y3o0nkVqbfODvLlknhRC2xQobs50/X4NYFB073hujECrEQPI5GXS31T56KJ0sSqmeLVl0ATBkus7p84XnaJbxAZ9alHoJ7q4fFdEKPGBgL3JaJPcV459XQ6z2uFYUNhhdE+5uyM3RFq6qzZf3R8EP/f2JIasE1tDiKm+dm65HYhvU8N0uQbAFPgXEEyq+gD/z7z8C5ZNF/ILsmq6FmAuoW3gIjYnn98FJ3v4mi0Wc37AXtf2Juw4mv+A4+udQWtB9aY/yMuWZxfQ9i08aJz1yG4DGt2Fzy18hUvvBQq8TX7UGtbnC9ywK6t4w8vzyCi/VmCIBdGNUJ1QBtbgTJEMYqqrmKLaAsmMvMhon+5XQ1nDFly/5+gxW8t5GBxCxZhL5a0vvsoNr2ZAEVqoM8pzI3ziNYpLJt70KwcUN79SCnGmmW5VH6ONY7dqkgAVRsjcXIKe3O/kT+WXWFUMKNVLTgq3qc2qtI3SFTt6okaIbV2Y7rsrNd7VI
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(376002)(366004)(451199021)(186003)(26005)(7696005)(33656002)(53546011)(9686003)(6506007)(316002)(71200400001)(2906002)(55016003)(5660300002)(52536014)(41300700001)(8936002)(7416002)(8676002)(122000001)(38100700002)(86362001)(110136005)(66899021)(4326008)(478600001)(54906003)(38070700005)(64756008)(66446008)(76116006)(66556008)(66946007)(83380400001)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?c2FFMEJGdFFMdlN6TU9FTTJLMU5PWW1lbS9RcjYyNU5YZ0kvWmNBWGwvbEtx?=
 =?utf-8?B?SHhtNWE5dzBzQU5qdG83eVYwQXladGJIUXVIOCthalBnVEpkN0dkd1daSkEv?=
 =?utf-8?B?aFo1alRKV3RlbE5hWlFnNWplL0ZhWTVDeUcvSERmcWQrOEN5M1gwbHlxc2FB?=
 =?utf-8?B?aEgvbGJLNFlBU2kwb0hGbzdGTnJOd0JPOFNoditFMjBvM2VxNUZDT2N4OG55?=
 =?utf-8?B?ZlI4ckNRcy9XN1RkOE5VM0tzZmtOV0hOSERxbjdzS1lUOFErVTMxZTJRZWw1?=
 =?utf-8?B?MmRnWDZaRG9kVE8zRlBTWFBHM1dObG9iY1FRc0wxa1FHRUlpUGlmWmtDZG9j?=
 =?utf-8?B?c001V0prcU92STJiUTJyVlFobjNGcWl4T0hDK29PK1ZTRWVEa3VIL1hEYjVV?=
 =?utf-8?B?RWRTbXhUZ0dVVlE3UnBORmg0WWE5M3B3UE5KQWJDL1RPM0NoMkFFampMZWJu?=
 =?utf-8?B?L1FwdkMydjVkVXVmRDBVNGw0WVhzdzlzOVBtaFUwZEpPaHFORUh4a0ZJYzUy?=
 =?utf-8?B?WFNJTzNiS3RPNXFCMDBDTkllV2dCUFBXc1dSWHp2SmU5bXNSVkl5T0M3NkVo?=
 =?utf-8?B?bjczV3RvRHd4bnNLYUpMUXFmS1FjQ0hiZUxtRjI0dUp1SnFna0szOVJIN3hx?=
 =?utf-8?B?T0VTSXMra3I3QUIrWnJnSWRBcXpMb2V3Ti9yRnU2M0V2RFVXWlNXS2UyejIr?=
 =?utf-8?B?bktjUnRCUlltUXA2bythZjh5RjJQaVR0cWw5eUUydUFDU1FWaU5jS01UbUxB?=
 =?utf-8?B?Y3BpWitQdDI1d0cwZ2JGU1RWTnBnU2I4dmYxQy9nS3BQL3ptS1E4b1c2WWs5?=
 =?utf-8?B?bWxoVmpxVmI4dnRsNnR6bGNMdGdOWlRhQndpMDhEbitHUnE5czRkd2hlMTl4?=
 =?utf-8?B?TWlCbXlnRVFlYW9uTHVON0NDV3RXVjNyV1p0NHNwR1hycVRSQzlVaS9XV2JZ?=
 =?utf-8?B?V0c0TWo5YmFwbkhaMXdSVlo5dmZOTlFoa0dwY1hOa0NJWkdFZytTZERMdGpH?=
 =?utf-8?B?c1l1MnFiQjZnV0thWFlJenQ0aGdXV3hsNWtZc2lYRWJScjlRblkveGxyelB6?=
 =?utf-8?B?eDYyeE1oZlZ2U20zOGJEMGN0bXhZUWsrbGhWbXVCWHdtZmplK1pwUEQvdzJi?=
 =?utf-8?B?UDUzLzE2a3ZtdGZPblZnZ1VYckpLMDZZZWRVYjZLMkFmSm40N0U3NW00RmtD?=
 =?utf-8?B?bVlqcUlMMWJ0UXp5c0VSby9HeTRzL3FqNlFzMllVeWN4K2lTZW5iWDlVdlVW?=
 =?utf-8?B?MzlXYVRlMWNoNGszMWpocytGOE5UeVcxbVA1aGw1MzZ0dFVKVkltVDBCUlRp?=
 =?utf-8?B?V2ZNWkx2NXRnY1pGVmdjbzlFV1l5NDNsRGJESEJ4a2RBS080K0dqa25yUExT?=
 =?utf-8?B?dkUwR1JBMGZuZ2FoQWluMDUzTk1ndlZLbmkrbW56R0JTWDNOTHJ4YlhNTC9D?=
 =?utf-8?B?K0tMaWsvQnBVeFhvcFByMlNJMDI1VGw5dCtaT2pOdHFJS1VqOUpUbDhoWFhk?=
 =?utf-8?B?MWdZQmFPdDhHRTg0anpxRlZCM09aQ1BoSWUyN2gzQ3FkRm9YaGxORGtGbGln?=
 =?utf-8?B?M1lYclQ3S01ReGttMk9vRnhyOUxQK1BLakcrdTNWb0NMeUxIY1VZWXRvbnZi?=
 =?utf-8?B?MzRJN0daTUxkdlZST1g0bGlIV3pnaEUvVWhRU1lKUEN6ZGp3MzN0clF0R0V4?=
 =?utf-8?B?SmZxOXA3aHE2SUJIaGttZHF4TTBMUnRjdWIyUnNvbUdOU0IvTmNtUHJ1c2pG?=
 =?utf-8?B?Q3MzdzFvak5PY3NoaHpqZU12Z0tXb2d3Vm5TMG9oSUhKSkRINkxFbnFpaUtM?=
 =?utf-8?B?NjFUVERwa0xZTHRycnd1NlRQQ2s3WXJVSnBsUVBsYnBVRkh3eExJdlEwU0k0?=
 =?utf-8?B?Zmxwd2NjWGdHYU9wNkNSbDI5Y0k3Z0JlVzhzOTB0Q1dGc2VGUk9SZzRXOFFR?=
 =?utf-8?B?MVFuVTZNK2dmVWw5bVVzRWIxWjgrUWtGTmFRV2NxdnZ2b3B0UDdFV0RLRFBZ?=
 =?utf-8?B?YlhDSWIwTTVNSXBnSDI3R2pvM200L2hiQ3E3bmJWY0l5ZkFhQWFXRWtDVzdr?=
 =?utf-8?B?Zm1SQ25NZjNmRGxIdTByY3FxVUlmZXUzak85OUNDOTZFQklYN3hKTVRjaVFH?=
 =?utf-8?Q?LE54=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63d7455f-dc98-461d-0452-08db619d3158
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 06:06:36.8588
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 53y6JLbVg4lfuFQ0A6I2ZsMySVTWkkcryyn7OYzru1h+7DzRVUYPJUFAUOwm5xv2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6347
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiBGcm9tOiBOaWtsYXMgU2NobmVsbGUgPHNjaG5lbGxlQGxpbnV4LmlibS5jb20+DQo+IFNlbnQ6
IFR1ZXNkYXksIDMwIE1heSAyMDIzIDE3OjEzDQo+IFRvOiBTaGF5IERyb3J5IDxzaGF5ZEBudmlk
aWEuY29tPjsgU2FlZWQgTWFoYW1lZWQNCj4gPHNhZWVkbUBudmlkaWEuY29tPjsgRWxpIENvaGVu
IDxlbGljQG52aWRpYS5jb20+OyBMZW9uIFJvbWFub3Zza3kNCj4gPGxlb25Aa2VybmVsLm9yZz47
IERhdmlkIFMuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEVyaWMgRHVtYXpldA0KPiA8
ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBQ
YW9sbyBBYmVuaQ0KPiA8cGFiZW5pQHJlZGhhdC5jb20+DQo+IENjOiBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gczM5MEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LXJkbWFAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFtQQVRD
SCBuZXRdIG5ldC9tbHg1OiBGaXggc2V0dGluZyBvZiBpcnEtPm1hcC5pbmRleCBmb3Igc3RhdGlj
IElSUSBjYXNlDQo+IA0KPiBXaGVuIGR5bmFtaWMgSVJRIGFsbG9jYXRpb24gaXMgbm90IHN1cHBv
cnRlZCBhbGwgSVJRcyBhcmUgYWxsb2NhdGVkIHVwDQo+IGZyb250IGluIG1seDVfaXJxX3RhYmxl
X2NyZWF0ZSgpIGluc3RlYWQgb2YgZHluYW1pY2FsbHkgYXMgcGFydCBvZg0KPiBtbHg1X2lycV9h
bGxvYygpLiBJbiB0aGUgbGF0dGVyIGR5bmFtaWMgY2FzZSBpcnEtPm1hcC5pbmRleCBpcyBzZXQN
Cj4gdmlhIHRoZSBtYXBwaW5nIHJldHVybmVkIGJ5IHBjaV9tc2l4X2FsbG9jX2lycV9hdCgpLiBJ
biB0aGUgc3RhdGljIGNhc2UNCj4gYW5kIHByaW9yIHRvIGNvbW1pdCAxZGE0MzhjMGFlMDIgKCJu
ZXQvbWx4NTogRml4IGluZGV4aW5nIG9mIG1seDVfaXJxIikNCj4gaXJxLT5tYXAuaW5kZXggd2Fz
IHNldCBpbiBtbHg0X2lycV9hbGxvYygpIHR3aWNlIG9uY2UgaW5pdGlhbGx5IHRvIDAgYW5kDQo+
IHRoZW4gdG8gdGhlIHJlcXVlc3RlZCBpbmRleCBiZWZvcmUgc3RvcmluZyBpbiB0aGUgeGFycmF5
LiBBZnRlciB0aGlzDQo+IGNvbW1pdCBpdCBpcyBvbmx5IHNldCB0byAwIHdoaWNoIGJyZWFrcyBh
bGwgb3RoZXIgSVJRIG1hcHBpbnMuDQo+IA0KDQpzL21seDRfaXJxX2FsbG9jL21seDVfaXJxX2Fs
bG9jLw0KUmV2aWV3ZWQtYnk6IEVsaSBDb2hlbiA8ZWxpY0BudmlkaWEuY29tPg0KDQo+IEZpeCB0
aGlzIGJ5IHNldHRpbmcgaXJxLT5tYXAuaW5kZXggdG8gdGhlIHJlcXVlc3RlZCBpbmRleCB0b2dl
dGhlciB3aXRoDQo+IGlycS0+bWFwLnZpcnEgYW5kIGltcHJvdmUgdGhlIHJlbGF0ZWQgY29tbWVu
dCB0byBtYWtlIGl0IGNsZWFyZXIgd2hpY2gNCj4gY2FzZXMgaXQgZGVhbHMgd2l0aC4NCj4gDQo+
IEZpeGVzOiAxZGE0MzhjMGFlMDIgKCJuZXQvbWx4NTogRml4IGluZGV4aW5nIG9mIG1seDVfaXJx
IikNCj4gU2lnbmVkLW9mZi1ieTogTmlrbGFzIFNjaG5lbGxlIDxzY2huZWxsZUBsaW51eC5pYm0u
Y29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9w
Y2lfaXJxLmMgfCA5ICsrKysrLS0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDUgaW5zZXJ0aW9ucygr
KSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9tZWxsYW5veC9tbHg1L2NvcmUvcGNpX2lycS5jDQo+IGIvZHJpdmVycy9uZXQvZXRoZXJuZXQv
bWVsbGFub3gvbWx4NS9jb3JlL3BjaV9pcnEuYw0KPiBpbmRleCBkYjU2ODdkOWZlYzkuLmZkNWI0
M2U4ZjNiYiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL3BjaV9pcnEuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9t
bHg1L2NvcmUvcGNpX2lycS5jDQo+IEBAIC0yMzIsMTIgKzIzMiwxMyBAQCBzdHJ1Y3QgbWx4NV9p
cnEgKm1seDVfaXJxX2FsbG9jKHN0cnVjdA0KPiBtbHg1X2lycV9wb29sICpwb29sLCBpbnQgaSwN
Cj4gIAlpZiAoIWlycSkNCj4gIAkJcmV0dXJuIEVSUl9QVFIoLUVOT01FTSk7DQo+ICAJaWYgKCFp
IHx8ICFwY2lfbXNpeF9jYW5fYWxsb2NfZHluKGRldi0+cGRldikpIHsNCj4gLQkJLyogVGhlIHZl
Y3RvciBhdCBpbmRleCAwIHdhcyBhbHJlYWR5IGFsbG9jYXRlZC4NCj4gLQkJICogSnVzdCBnZXQg
dGhlIGlycSBudW1iZXIuIElmIGR5bmFtaWMgaXJxIGlzIG5vdCBzdXBwb3J0ZWQNCj4gLQkJICog
dmVjdG9ycyBoYXZlIGFsc28gYmVlbiBhbGxvY2F0ZWQuDQo+ICsJCS8qIFRoZSB2ZWN0b3IgYXQg
aW5kZXggMCBpcyBhbHdheXMgc3RhdGljYWxseSBhbGxvY2F0ZWQuIElmDQo+ICsJCSAqIGR5bmFt
aWMgaXJxIGlzIG5vdCBzdXBwb3J0ZWQgYWxsIHZlY3RvcnMgYXJlIHN0YXRpY2FsbHkNCj4gKwkJ
ICogYWxsb2NhdGVkLiBJbiBib3RoIGNhc2VzIGp1c3QgZ2V0IHRoZSBpcnEgbnVtYmVyIGFuZCBz
ZXQNCj4gKwkJICogdGhlIGluZGV4Lg0KPiAgCQkgKi8NCj4gIAkJaXJxLT5tYXAudmlycSA9IHBj
aV9pcnFfdmVjdG9yKGRldi0+cGRldiwgaSk7DQo+IC0JCWlycS0+bWFwLmluZGV4ID0gMDsNCj4g
KwkJaXJxLT5tYXAuaW5kZXggPSBpOw0KPiAgCX0gZWxzZSB7DQo+ICAJCWlycS0+bWFwID0gcGNp
X21zaXhfYWxsb2NfaXJxX2F0KGRldi0+cGRldiwNCj4gTVNJX0FOWV9JTkRFWCwgYWZfZGVzYyk7
DQo+ICAJCWlmICghaXJxLT5tYXAudmlycSkgew0KPiAtLQ0KPiAyLjM5LjINCg0K

