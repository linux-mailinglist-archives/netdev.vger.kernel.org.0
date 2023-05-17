Return-Path: <netdev+bounces-3212-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id BDD70705FE1
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:23:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B4D831C20DF2
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 06:23:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3F7B5682;
	Wed, 17 May 2023 06:23:29 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C248C53A0
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 06:23:29 +0000 (UTC)
Received: from APC01-PSA-obe.outbound.protection.outlook.com (mail-psaapc01on2073.outbound.protection.outlook.com [40.107.255.73])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 492A730DC;
	Tue, 16 May 2023 23:23:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CKnPDIbAW7Dz3CKVO5ti9dHaTf4hCD2LiPbaJJcO4iyBKe+0Zvv9lPzFOU5v7GBYLxmFjs/NCucC7zvgmhvuW2o4p0R3bTZpZcoIfb3UqX0BSuL1SCvnq8uYezxcjtRoUyQBbB4hfBP5Lvb8tmQ5ZKtbsRpFTELtCczlMHPsAJIVNmET5Mwx9JRZGcfif09A0lSKVQHAcAoSFXy6HJVck4WstY5Ng82mYamX8BuFuL2c4IFtaz7Mgr+hMaxLJeWlaLTReYNqlI7eP3LYVNhuRqenzBiCpMiRMZxpHZOsCWHdGevBzMLJc9oQ8mAub4KxNQM7nLoHu+Gayj/m/96cwg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=C3AYXHgLnKZ8LJ7fLhyjAd/4lk7QMVPShz7Sxl8OlfU=;
 b=YOrYdaMHG31v738C41OQU3DySmtDbxiUMGknxprO8mi+Zkjrx40VyNGWF9ni8HdjkAhStRX5Mn8eMAmXU7jZDQLAb73N082piW94zTjZcOaYEq18h4yKffeuJh13CdGbBzn96UuM2J/wXf+71A7YTdobW2jIqC0Rmx8c+H7EK2QC8q8PTSX7KdAQZ/Syad0Hja/UacrHBnPfbWqtWhkMmPQUKM/dLrRClIrDHV16Tg7lv+h8lADpYwInb3rApUPf6Z2k8jYUSWW0HqwYxoIfyEEtNoD4jHlt7N2KZPaGv9ctF+4xDbLfTysMW7mO0acP1z1mtoCmlKqsgAibQEJ04g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=jaguarmicro.com; dmarc=pass action=none
 header.from=jaguarmicro.com; dkim=pass header.d=jaguarmicro.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaguarmicro.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C3AYXHgLnKZ8LJ7fLhyjAd/4lk7QMVPShz7Sxl8OlfU=;
 b=eTagii0tTey1pEaN7HJd59iawmVZR3vKQbgda1GnDU+zboaB4A/RUQ/lbBU3g/nHvHTSsKNyBbgA35TSucDZJAWVU0+dNRDeDSu0oI4PH4wAbZGUo5AwL7nTdaqhfFiL3NAUvUWFEmJDWnU+cl6zkeM9HOIzl8ONyfOHpQOTJ46ZRS80/qH6xs6ObrersEiJvyU+1LfzomxQmbw4chmqEHyQJGsss8Llskl4FdQQVdnCZ7ZszxPCPqZlyMhZhc41M93ediZXZGeWG0AFZB+ILDe9nHs7M3krlDPS2x1MX0yV80+hHWXxJLXwMosuv/K+IkKDT3WEYyA2kinK4R3/GQ==
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com (2603:1096:404:104::19)
 by SEYPR06MB6778.apcprd06.prod.outlook.com (2603:1096:101:170::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.32; Wed, 17 May
 2023 06:23:20 +0000
Received: from TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::60d6:4281:7511:78f7]) by TY2PR06MB3424.apcprd06.prod.outlook.com
 ([fe80::60d6:4281:7511:78f7%6]) with mapi id 15.20.6387.034; Wed, 17 May 2023
 06:23:20 +0000
From: Angus Chen <angus.chen@jaguarmicro.com>
To: Jakub Kicinski <kuba@kernel.org>
CC: "davem@davemloft.net" <davem@davemloft.net>, "dsahern@kernel.org"
	<dsahern@kernel.org>, "edumazet@google.com" <edumazet@google.com>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "netdev@vger.kernel.org"
	<netdev@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "idosch@idosch.org" <idosch@idosch.org>,
	"petrm@nvidia.com" <petrm@nvidia.com>
Subject: RE: [PATCH v3] net: Remove low_thresh in ip defrag
Thread-Topic: [PATCH v3] net: Remove low_thresh in ip defrag
Thread-Index: AQHZiFUh7DWloVrfU0SoASzh7SP85a9d0tMAgAAqc2A=
Date: Wed, 17 May 2023 06:23:20 +0000
Message-ID:
 <TY2PR06MB34247F4E2615F7B12AFA2072857E9@TY2PR06MB3424.apcprd06.prod.outlook.com>
References: <20230517001820.1625-1-angus.chen@jaguarmicro.com>
 <20230516204330.1443bc7c@kernel.org>
In-Reply-To: <20230516204330.1443bc7c@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=jaguarmicro.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY2PR06MB3424:EE_|SEYPR06MB6778:EE_
x-ms-office365-filtering-correlation-id: 6f3acb2a-d044-49f4-6373-08db569f3585
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 u4yDzbuNSHV74Dnhq0e/gVYVnmiVHHwJsD6iPiwBxPNXFy5ujJLJjMkU+cB1kGmimcGV0IpiWkk7olcjKqcZb1Go/+24MMerplqsyUrrawd9vEYJ5agzNzC6ZKYiYhqBz87drj1qcqjppE2us6xFIHsxN6cYKhXKOdlvZshXJ8IJbWY9dUOydT2eOM6LpoE4ZGhGxQbvUj1OEU1Wylr/Q0aCcqRm1+aFUmR3ZrFp7fB68gtx6JY4ND5kp9bsuGp+IP51X27yePKboAf5OO4qNBJTbnAow37R9zPsDzxXRd0fnGJClfHBPCJtzKUx4e4qeen+kT/i4d0qiPBvhywx3pWZX6GDL7Vs6LP/GSh4SG5SzxU+rNvdLUXfm/mgOuTsrWumizbdSBsHHqYfREsXWcymYeuoBivpc32GtcH7OJL7m2HLKvVBbQWZihIRW/TDGRbWeYNmumf703tBTNBTRS8ixl/vbAtt9emkzp/A2nLqCPcZXibxx2t0N6SmvDE6akWGDX4St/zkD6Qr6KudsJ5TXb68lNCkx0Qi32XIDfCdF8t9bQvqCKp34DcuYmTLIKldpHfutRaqggB9uvCUaYZrmU1wDMRa8z6NqoR2vs9GfP+9pYbm8jk9HMwfS8cU
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR06MB3424.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39840400004)(366004)(346002)(376002)(136003)(396003)(451199021)(478600001)(54906003)(8936002)(8676002)(38070700005)(86362001)(52536014)(5660300002)(2906002)(33656002)(44832011)(66476007)(6916009)(64756008)(66556008)(66946007)(66446008)(4326008)(316002)(76116006)(55016003)(38100700002)(9686003)(41300700001)(122000001)(26005)(6506007)(53546011)(186003)(66899021)(71200400001)(83380400001)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M3NGTnNad0xjTGd2Y2V0amNhVzJlTHY0S1dWS0hmVGtrQVJkWEhzelZiTXE0?=
 =?utf-8?B?aEg5eVJrcys2NUhvemtFZVVkY2FGTFRHVXdLVlI1UC95aTE5MkQ1VlFTQ2xr?=
 =?utf-8?B?Yy94WEo3RFlyMVdKWVI3VUZZdXp1THZ6SFgvOHVKOVVSZGoxNnRQVjNSNG01?=
 =?utf-8?B?MlRBMHl6ZGowUXhiNUMySGYwK2tMZlRuWHlnRDZ1RmVjZkVlb3R5dlJSSWh1?=
 =?utf-8?B?NEE2U2RFN2w3UDF1a0t4dnlrUWFpVTBBYlR2MlpZRFJXMkZNcURka0xkMzFC?=
 =?utf-8?B?dlNRVmlaUitITHBUYmloSDhpb2tONldFMTZyRi9vQ0JLWGtibmJqTHhBRUl6?=
 =?utf-8?B?WDR5YnRWOFZxazBlalNqWjVWNU9WVjczSWxtbXk0bHZWbzZ6UEJYQnNaUWJu?=
 =?utf-8?B?S24rSy9kL0xrNEYxcmcrZ0RTWVJtVWloZ29DM004S1JJMkpoQWZ6eSs2TnYx?=
 =?utf-8?B?L2lwZ05sbm1aM2M1TXN4R0ZnWTU2WU4xR3Y4UHdFZll6MmxPTXI1aWVBbFho?=
 =?utf-8?B?b0c4VER1UnlUUWNCZ09LeHZPZ1lsKzcvdnhiQ1NxbVdCaktjQWdYSmtaMzFi?=
 =?utf-8?B?QnNEVWg5dVlhREhZN3NWdTNGeklSdFg4MDk1RW5wS2FBTWV0djVNMk1VYldC?=
 =?utf-8?B?R3BYVk5FdVVkNG1tcFRiRlN5WXRJWm1UTEt1S21xdi9qWXBqd1lObGdYY3Fr?=
 =?utf-8?B?QXJpNXk3bVd5dTlpRDZ0SXZjOGNZM0w4TEZjc1VZaVVUNXBiTjJNcTlyOEh1?=
 =?utf-8?B?cERRdmxKSWR6S1ZzOWZHdE01ZkVXcG8rV0R5YVY5T2ZaQnQxOFh2dDhBZEts?=
 =?utf-8?B?cS9yeFZKT3l4V1o0NkRaMmwzU3M3ZHRzWlFrQjdjYkVJeEFkQ1RCblIvTERX?=
 =?utf-8?B?RG10SlV3UUJYdUZBMVk4STI2VG1GcFZ5TlZJZzZUK3FSN2FxdjVaeDRwcTdw?=
 =?utf-8?B?bThlMWxEejdLekY2bVhXUTlFSlI0RHhDNTFLZ0FoWnYrUE5tMUdxTGN1Tjh4?=
 =?utf-8?B?dzVCZ1Rud3pQYnBHbzVyVWQrSW1VT21lS1E2QmdNdU1DVU9mbEprYVVOUVRp?=
 =?utf-8?B?RjJrMjVNdFc5NVBnYzg3eFMzL3JYR3JTNHFrUU5ESW9mb1dDUklzbWpjVmZR?=
 =?utf-8?B?UG45bDVoU3diVXhqUE5CcW9MN1BnVzRLbUJQRmplNXBzTi9Fakc4Y1dMakwy?=
 =?utf-8?B?a29jOUppOEl1YUIrUDN1dWhXM1N4elRVbVdldXNkUzhnMi9WZEFFSkYvUG5k?=
 =?utf-8?B?eEEza2t0WTdaK1hTV0RIUWcxeU9CZldVMlIwNmJ6azlHS0xCV1NrdFZlWWdC?=
 =?utf-8?B?TmRWMG9td2RBUW14bjVmNmdxN28ySHpwblhGSWl4OStuSVZabHZuS2p3WGJz?=
 =?utf-8?B?UVhacUN2SDFxV1ZxdVVEUlFkTmEwVmtrQkhLa2V4MktRNENwekVEL3BRL1VJ?=
 =?utf-8?B?ZHQ0RTdQZHhnbjZHL3BvUlJqT3pmQXFRdjV3Y1BUbGhnUTZLdERLcW1SdlVj?=
 =?utf-8?B?MjdKRXpJMC9YbXdsQS9aamV6R0oxMk5OdStKcW1JT3BXS1l5OVZpampxNTZz?=
 =?utf-8?B?RnA1aWh2RjhkZjNtU0xrUzNYNUFaU1FyK1l5bWQ4cm5tUU1wZENsZjd6VkZW?=
 =?utf-8?B?Q3hidlpBYzVqTnMrWXhvcE1nZUdnTGxnZUZnb0FyeFpta0VhQ2JnZURkOEpN?=
 =?utf-8?B?d1NITDEzU1VQSUdJaWgvV254eG9ucE1wUXdxZmN6RUtCL3ZWY2hXRW9ZSzFK?=
 =?utf-8?B?Zml0RS9ILy9DQ0l2ZW5LNnJHdTZEYm16d0FQeHhDa21VaEVVQ0x2S2tGa2Rh?=
 =?utf-8?B?R2hCVEVOM2VpcjdjOG5hSkpzQWRKeUFXQUt6bFZDTGxoVEFqREFTVUN2cGFm?=
 =?utf-8?B?TEJJTU1vV1A4MGdDZkVnb09yYnQ1aGVQdytNdXh0YkhwU1BIemRvQTcyUlZB?=
 =?utf-8?B?ekxvNU8raCszWTUxNUl2NmNVbmxHTXdKRGZUemNsSEJRbHZrUE5pK0xyMXpI?=
 =?utf-8?B?eldDN1o0QkhoZGR6aStBSnVkWEJSbWt6RDBRTllCWmpEdUtKckFCcTJXdGNl?=
 =?utf-8?B?WWZRMHJwbWdwbnU2VDFjSjZuS3NNUUVRK1Fnc2xUY2txVmp4Z0tPTW04MFVB?=
 =?utf-8?Q?uteXexW1fpguf8fZzTfHva07h?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: jaguarmicro.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR06MB3424.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f3acb2a-d044-49f4-6373-08db569f3585
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 06:23:20.0331
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 1e45a5c2-d3e1-46b3-a0e6-c5ebf6d8ba7b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: gfw9khxv5asG/e6+xGIysbw18zD75kTvPZBt4PVgDDpHlQfTwHWL4/Hs3yCljHBYbn/crN6uGxXEWdqu/ko+imwfPIBSWGjCF+EOcOPV+so=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEYPR06MB6778
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz4NCj4gU2VudDogV2VkbmVzZGF5LCBNYXkgMTcsIDIwMjMgMTE6NDQg
QU0NCj4gVG86IEFuZ3VzIENoZW4gPGFuZ3VzLmNoZW5AamFndWFybWljcm8uY29tPg0KPiBDYzog
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZHNhaGVybkBrZXJuZWwub3JnOyBlZHVtYXpldEBnb29nbGUu
Y29tOw0KPiBwYWJlbmlAcmVkaGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsNCj4gaWRvc2NoQGlkb3NjaC5vcmc7IHBldHJtQG52aWRp
YS5jb20NCj4gU3ViamVjdDogUmU6IFtQQVRDSCB2M10gbmV0OiBSZW1vdmUgbG93X3RocmVzaCBp
biBpcCBkZWZyYWcNCj4gDQo+IE9uIFdlZCwgMTcgTWF5IDIwMjMgMDg6MTg6MjAgKzA4MDAgQW5n
dXMgQ2hlbiB3cm90ZToNCj4gPiBBcyBsb3dfdGhyZXNoIGhhcyBubyB3b3JrIGluIGZyYWdtZW50
IHJlYXNzZW1ibGVzLG1hcmsgaXQgdG8gYmUgdW51c2VkLg0KPiA+IEFuZCBNYXJrIGl0IGRlcHJl
Y2F0ZWQgaW4gc3lzY3RsIERvY3VtZW50Lg0KPiA+DQo+ID4gU2lnbmVkLW9mZi1ieTogQW5ndXMg
Q2hlbiA8YW5ndXMuY2hlbkBqYWd1YXJtaWNyby5jb20+DQo+IA0KPiBXZSBuZWVkIHRvIHJldmVy
dCB0aGUgb2xkIHBhdGNoIGZpcnN0LCB3ZSBjYW4ndCByZW1vdmUgdGhlIGNvbW1pdCBmcm9tDQo+
IHRoZSBnaXQgaGlzdG9yeSBiZWNhdXNlIGl0IHdvdWxkIGNoYW5nZSBhbGwgbGF0ZXIgaGFzaGVz
IGFuZCBicmVhaw0KPiByZWJhc2luZy4NCj4gDQo+IFdoeSBhcmUgeW91IHJlbmFtaW5nIHRoZSBt
ZW1iZXI/IEp1c3QgYWRkIHRoZSBjb21tZW50IGFuZCB1cGRhdGUgdGhlDQo+IGRvY3VtZW50YXRp
b24uIFlvdSBzYWlkIHlvdSBoYWQgYSB0ZXN0ZWQgY29tcGxhaW50LCB0aGUgdGVzdGVyIHdpbGwN
Cj4gb25seSByZWFkIHRoZSBkb2NzLCByaWdodD8NClllcyxJIGNhbiBiZSBkaWQgbGlrZSB5b3Ug
YW5kIElkbyBTY2hpbW1lbCBqdXN0IHNhaWQuDQpCdHcsIHJlYWQgdGhlIGRvY3MgaXMgYWxzbyBr
aW5kIG9mIGNvbXBsaWNhdGVkLg0KSWYgd2UgY2FuIGludHJvZHVjZSBhIHBsYWNlICxsaWtlIC9w
cm9jL2RlcHJlY2F0ZWQgb3Igc29tZXdoZXJlLA0KdGhlbiB0aGUgc2NyaXB0cyBjYW4gcmVhZCBp
dCBmb3IgcmVhbHRpbWUgY2hlY2suDQpBZnRlciB0aGF0LCB3ZSBwdXQgdGhlIGRlcHJlY2F0ZSBw
cm9jIGVudHJ5IHdpdGggYSBsaXN0Lg0KSXQgbWF5YmUgd2VsY29tZWQgYnkgRGV2T3BzIEVuZ2lu
ZWVyIGFsc28uDQo+IC0tDQo+IHB3LWJvdDogY3INCg==

