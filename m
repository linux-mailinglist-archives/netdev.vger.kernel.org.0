Return-Path: <netdev+bounces-72-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D9C76F503F
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:34:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DF8C71C20A80
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 06:34:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5C15AEA3;
	Wed,  3 May 2023 06:34:14 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49FD5A48
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 06:34:14 +0000 (UTC)
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (mail-bn8nam12on2052.outbound.protection.outlook.com [40.107.237.52])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF5A2684;
	Tue,  2 May 2023 23:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WnCDjcXUHH6A5GYn6Kx57G0uA9j3Nd3+SMjPaWGsz2BGDKaUWodkUzoGy7/K43TeXhEF+d8H0TfqvMchHAu9XflquZpTcgYeP2JvDRyHpduRSEGvL6k0juHxGndS8oDWEEmXqQUGaVouOHj1Km4rp7PWsYbcGpIQLCRPeDMQfChX25OsuZ2FCjbhdBrCBF7XCbZv2DdQr69mY1QavGdKI2u9sghPr4/CCinwJOimRNgEqmsDc/DIHOiSq6eQqmVbgtN9X2B/KSXRLdfESCOzc6bvUVE6FjThlECO/jCHM0F5lPVepnnhH0cowcE+RNlcEle1aAUpHM6i9EPJkLOCxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mJvR1rsgDUKiL/jAzhzqcR9EzObMks5bwh5wiZEvRFY=;
 b=GwEs7qBEPI8pgu37/ryjRVL+MMVM4dXdU67L6o8PrxY1IDVyt9RtzU/9LzGkXjzLWCxuFQYYVn8mUSJDTdXZdIyvI6FcKNOt3Bge1kkRBeAAnR57uiZFx9G58J/Qnb3ws9gFL9yHO+3pRkcP5q/eJv9FdCJx0RDGs4yyWhzIE6brmUmKJfORtOy/yUKBbfjsrL79bhiSQsjw3Q2milBMSMOfT0ifDNFpWTFIKu080iFlxxOpfodIrfY9kJFGFxgot9hUU+rcGXAzLOvTbP2K969URR16nYjc6ky5H/0fi/FD8vY5vXNeHkjZcflfX/ey2OFtLy3vK8QFQPlzSjX5HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJvR1rsgDUKiL/jAzhzqcR9EzObMks5bwh5wiZEvRFY=;
 b=qVpidQkAQmiN3goE4PPpw3y5AyOOLUoDZxzchou4tvgGV4fIZKiiPE5lh2wYL1Ma/ll4rlIuWz9fl6emc92NecIuRE7VA0FTf27e5ptKqhCGhK+/udFUwhiVoOr8TY7VinA6Q/rI/eQoisVv1r1kI4XolxoNn9ZHixxHY1DdpOVav0rlFndSu+A/yauI9I1nUPHclRED1C9DVHZTK7vyPU8AzDNBG9+xjv3i5mf5SUnrxw6gb88XGyrO51w4Dsc/HxKummiaTPDI7DYwZQ8hDHyM7C4D4y3xMpjCbsoxolJjrv3PvMZayFBru7Gl+XKr9t4rJ4CslZALFMe+L9AiUg==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 CH2PR12MB4873.namprd12.prod.outlook.com (2603:10b6:610:63::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6340.31; Wed, 3 May 2023 06:34:10 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::3bfc:e3ce:f6c0:8698]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::3bfc:e3ce:f6c0:8698%6]) with mapi id 15.20.6340.031; Wed, 3 May 2023
 06:34:10 +0000
From: Eli Cohen <elic@nvidia.com>
To: Chuck Lever III <chuck.lever@oracle.com>
CC: Saeed Mahameed <saeedm@nvidia.com>, Leon Romanovsky <leon@kernel.org>,
	linux-rdma <linux-rdma@vger.kernel.org>, "open list:NETWORKING [GENERAL]"
	<netdev@vger.kernel.org>
Subject: RE: system hang on start-up (mlx5?)
Thread-Topic: system hang on start-up (mlx5?)
Thread-Index: AQHZfVsRBH+TK4pd40qPySTJP7qIg69IF2Fg
Date: Wed, 3 May 2023 06:34:10 +0000
Message-ID:
 <DM8PR12MB54003FBFCABCCB37EE807B45AB6C9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
In-Reply-To: <A1E5B427-897B-409E-B8E3-E417678E81F6@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR12MB5400:EE_|CH2PR12MB4873:EE_
x-ms-office365-filtering-correlation-id: 77ef17d7-f151-4379-654e-08db4ba06734
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ef7GCrDintgVEYxv17zn0E7x14+CYGe/L8/Shio8q7+r9zRTbKXbL0LNbRnngcpMiJVQJtPOqk31KdW5Es7WpTl816o4bnmJu6mUbx4VBu+iy9tBgSO9ubfnaTUyqi6PlUeDabLSYONavZ0812SAnOS+NlinEHC3hhwTz2HBcUxb/qoQkRsLH3/ZJ9k+3YT+WCPG7/WIf18kU9GQ/iWeYcBDEShgQYA4oNMDkMrMlo1z1ku1k7XYKPFE6WV4RcS5wzloANlkYKyGhbAl7leeHQh8GO7vvgImAspQnmNg1wcGtrGoI35Rk9KEhATV6+aBuFzh9r6p+zekO9cSTPtcr7JuLNs9bN8WmcZ+7YEAXwZIlXVS90IJkN8xBExUBlz1ntWBxcuwwHa5yCR4P80WQ8qbU3k+3xJXHE+PqNWYE2Hv2s5MLJgSJ3mX8b743yNWI7c/IlOBgCN18A3ka6aHgXdznW1xT1C3Ki8EkTM17TDieyrP7Z65RutNl9f5/hHQ/78dTiqSPoJckwkgzKS/9wEC9ryY1TcwpjgUMFowjB4epNPYSD3zkgmdQ0ci6viVJdBrg9mezCfhM32+c95i3QM31fkgSna5mh43fRXWnJa1jlcAKNIF2IDXGbrm1LW3
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(136003)(366004)(39860400002)(376002)(396003)(451199021)(122000001)(52536014)(5660300002)(41300700001)(8936002)(38100700002)(8676002)(66556008)(66946007)(66476007)(66446008)(76116006)(4326008)(64756008)(316002)(55016003)(4744005)(2906002)(38070700005)(86362001)(26005)(9686003)(6506007)(53546011)(186003)(7696005)(71200400001)(6916009)(83380400001)(33656002)(478600001)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?eElNZzl4UHpoMWp0ZVZyYjZjbHJmbFJlL3B3SlY4aXJLVHZtZk1uMVViZkdr?=
 =?utf-8?B?bEIyRy8ycDFzb1pBTmt4ZUw0UHV5NFRaUFlGdzhjSXExZmdiS2YwWGJtRHZy?=
 =?utf-8?B?N0NJc2RBQ2dnN0I4dnpxYkRJT0M3TlAreXN0TXh4b0VUd29Jd0lubGwvaUpD?=
 =?utf-8?B?RmVrM011UGE2V2srUFNNbVErd0VPbFhHdllIYzBESzROV1ZqSkYxQ1ZMcDBM?=
 =?utf-8?B?YUdvNUErR1BFejE2ZmxlbmlyZG5wSThKdnY4cG03YlJVNTk2YXg2NnhrbXFD?=
 =?utf-8?B?KzRETndBNXJWZXg0RkpDSlZMTUcrRWwyUXBnYXZ1U1dhaTZZU1B1MjBPMFA3?=
 =?utf-8?B?T1o1dCthbG9EYXZXS1hsOXZJUlZVZUQ3L1Q5V011UFhDOU8zQ3BlaTd3Y3Z1?=
 =?utf-8?B?TG9IRlkweFFpbzVHMDF1NFovQXdIUWFhMm8wZElOZ010RjFuMzFuSUJzQmJB?=
 =?utf-8?B?UUNDSTdQcTRucDdwQjE0Q2dxLzhBOVpzaHd1RlNYZnVaMzQwVUpkY08zR2Zs?=
 =?utf-8?B?dXBhdlIzdFhZL2lXWjZva1pOdnZ3YTJjNTNUSm1FQ2h6Sis4WGdPMmk1cTkx?=
 =?utf-8?B?NEpPL1ZBV0o3WjI0NVZwKzZhUUNicGRwVksrQUwxV3ZnMlJJSUVrN0tYWGJv?=
 =?utf-8?B?VmtqWHVMZnk5OWVTQnNzS2pJMGl4S3JUcWhkdGN0SkpsbUJsaFVMbTF2VzRR?=
 =?utf-8?B?clQvci9tUkFnMjNLdWV2ZnRjd0g5OEhUUkVTaEN1MjFYL1FNQUVBK09IL0dJ?=
 =?utf-8?B?MlN6T1dEbXBTNmJqZ0c0bzFqajZxbm1semFZdHYzaUFUYkg4T2Rpd0puN0ha?=
 =?utf-8?B?aGE5NFBTcjVRMVhtWCtmcHlXUXdoMmtoRkNidXltRzFTejdrMmJZbGdQN2F4?=
 =?utf-8?B?a1JGdEcwbTFJa2Y0ekxpOTlMTEYrNktKaS80cW9oNHZBT1dOVUVzQmhrVEtP?=
 =?utf-8?B?aC94eUt3N0pHNUhWejhlVWEzSy9nNDdMQzRFM2EvTE1oUDd3Z2RwUGo0aWNW?=
 =?utf-8?B?MDdvWG1aeVoySUNvdjdCN1hNamlYUVlkaXpuM0JkcVZibkhBdWxpbURYcW1s?=
 =?utf-8?B?Q29jc2tERTJkTnBiS0l5a3VuRTNLNERNcDJVT1pWWUszdHVBS2FIdytqdmRq?=
 =?utf-8?B?MGRqTktWUUdzRGxqdklSWlROQlNwV3d1MTMzVnpGM3BBNFFOODhtU3RtWmV1?=
 =?utf-8?B?bmJWaE5VNmxyNG5CRytodExuQUh0THJpVHp6VkxLa2NnWm5xaUloNjl5cWh6?=
 =?utf-8?B?NGMzVEl3ai9pY2RHMnoraGpVYnloQkJvQ3lvdmZ6a29KMWxmREpLKytaS2Rm?=
 =?utf-8?B?eVJaR0I1dGtGZzY3dVkxRmFBeXRkOWRnRTNieTVaSWFGT1VWVzV6N3UyR3BK?=
 =?utf-8?B?M1lmMm5RMmtyNXdHMmZqb0M3OTIvL0tDWTA2R1JMTlRDQk5BV0hlV1l0MVpG?=
 =?utf-8?B?WllpSm5LNlJEQ1E4UVVxbzN5V1Y0YlFUWGVaT1Z6c3NaVVhhZ3N1QUtibThW?=
 =?utf-8?B?anZJVFZjQ1RHSzUyL3M3Ny9yZTZvSWoyeXIreis2RGFUWktvbzBFUXFGZ2tZ?=
 =?utf-8?B?cFcvcWRLRlBPckplaHNBdkpHUjE3RFZpcGNza3hiaWdxM0llNEQ0TlBTaCtw?=
 =?utf-8?B?cTZhYkZkdjNPeTMyZDFLbndFaDNSNHpFRVlHeVpRUlNyWjR1b2dWb243ekhL?=
 =?utf-8?B?c2JFZ216d0REcmowWURJNjY4Sy9ZTklxeUhjemkxVlVlenEwTE00ZklMdmhn?=
 =?utf-8?B?REtiSjE2cWJmUmVxdTZCVVMwNUhCekozb09jaWF3TytZT2xLRFFuck5ueHNX?=
 =?utf-8?B?UHMveVlyUnZWMzlZbUJkcnBtamE1d21KcmdUUURLZXVXdTJhMDc5NnI3RFdX?=
 =?utf-8?B?emQyUHNtTVl0eW05azJsZFg0em9iZ1ZoV0kzWEE3UloyVFZJT09zeW9HckNt?=
 =?utf-8?B?OFVYTWFzZGVybzV4bnExdUNBTVFRL0dCZnpVTWpyN252VGtEL0x6TVliMjFl?=
 =?utf-8?B?dUhWM1JaYnFxQkc5OHhublRZQkpQUGdBcDVHOUJGTmUzblNqR1Y5SkthYVg5?=
 =?utf-8?B?N0MyK2RjbXpOZ1d3NkRWME1jbUlIY1pweGh5M29WZ1p5Rk1FVE03ZFJRWG1v?=
 =?utf-8?Q?PsKk=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: 77ef17d7-f151-4379-654e-08db4ba06734
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 May 2023 06:34:10.0926
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nucgXIahg9EueFC40oihEpUf42yMFVa0S9yE2bAACKIQCeVQTkBeFem7smQj3pc5
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4873
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQ2h1Y2ssDQoNCkp1c3QgdmVyaWZ5aW5nLCBjb3VsZCB5b3UgbWFrZSBzdXJlIHlvdXIgc2Vy
dmVyIGFuZCBjYXJkIGZpcm13YXJlIGFyZSB1cCB0byBkYXRlPw0KDQpXaWxsIHRyeSB0byBzZWUg
aWYgSSBjYW4gcmVwcm9kdWNlIHRoaXMgaGVyZS4NCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiBGcm9tOiBDaHVjayBMZXZlciBJSUkgPGNodWNrLmxldmVyQG9yYWNsZS5jb20+DQo+
IFNlbnQ6IFdlZG5lc2RheSwgMyBNYXkgMjAyMyA0OjAzDQo+IFRvOiBFbGkgQ29oZW4gPGVsaWNA
bnZpZGlhLmNvbT4NCj4gQ2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT47IExl
b24gUm9tYW5vdnNreQ0KPiA8bGVvbkBrZXJuZWwub3JnPjsgbGludXgtcmRtYSA8bGludXgtcmRt
YUB2Z2VyLmtlcm5lbC5vcmc+OyBvcGVuDQo+IGxpc3Q6TkVUV09SS0lORyBbR0VORVJBTF0gPG5l
dGRldkB2Z2VyLmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IHN5c3RlbSBoYW5nIG9uIHN0YXJ0LXVw
IChtbHg1PykNCj4gDQo+IEhpLQ0KPiANCj4gSSBoYXZlIGEgU3VwZXJtaWNybyBYMTBTUkEtRi9Y
MTBTUkEtRiB3aXRoIGEgQ29ubmVjdFjCri01IEVOIG5ldHdvcmsNCj4gaW50ZXJmYWNlIGNhcmQs
IDEwMEdiRSBzaW5nbGUtcG9ydCBRU0ZQMjgsIFBDSWUzLjAgeDE2LCB0YWxsIGJyYWNrZXQ7DQo+
IE1DWDUxNUEtQ0NBVA0KPiANCj4gV2hlbiBib290aW5nIGEgdjYuMysga2VybmVsLCB0aGUgYm9v
dCBwcm9jZXNzIHN0b3BzIGNvbGQgYWZ0ZXIgYQ0KPiBmZXcgc2Vjb25kcy4gVGhlIGxhc3QgbWVz
c2FnZSBvbiB0aGUgY29uc29sZSBpcyB0aGUgTUxYNSBkcml2ZXINCj4gbm90ZSBhYm91dCAiUENJ
ZSBzbG90IGFkdmVydGlzZWQgc3VmZmljaWVudCBwb3dlciAoMjdXKSIuDQo+IA0KPiBiaXNlY3Qg
cmVwb3J0cyB0aGF0IGJiYWM3MGM3NDE4MyAoIm5ldC9tbHg1OiBVc2UgbmV3ZXIgYWZmaW5pdHkN
Cj4gZGVzY3JpcHRvciIpIGlzIHRoZSBmaXJzdCBiYWQgY29tbWl0Lg0KPiANCj4gSSd2ZSB0cm9s
bGVkIGxvcmUgYSBjb3VwbGUgb2YgdGltZXMgYW5kIGhhdmVuJ3QgZm91bmQgYW55IGRpc2N1c3Np
b24NCj4gb2YgdGhpcyBpc3N1ZS4NCj4gDQo+IA0KPiAtLQ0KPiBDaHVjayBMZXZlcg0KPiANCg0K

