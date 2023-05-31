Return-Path: <netdev+bounces-6873-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8DA8E718810
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 19:07:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0D431C20E52
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 17:07:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 462C8182B1;
	Wed, 31 May 2023 17:07:41 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AC83171C4
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 17:07:41 +0000 (UTC)
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2079.outbound.protection.outlook.com [40.107.243.79])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CDCE6D
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 10:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=itfcCyr5PLyCw1ewguz9hw1Ckfst0e75LUngG8mijWqGDmYz2y5iBeerP82GEVFmOPKs8miY8XsFjj70OtWLskJg1bFDpmXScVtlhIf9dImC0Vi8JhgGAbKtjpU4rJSHTLOrIJDM490zy8+ClJHapHf55tLlqxZSArOwL1mDTJbujaLWvzR0D4f1amvXA14Ztb+Qq6+0XDeO1HVwIJ5MZ64onn6REmiSy/eNJ5rnrQPVS4xmBgIB61gCIxyQNMBVONm590W0GYtJZiL4i1wpdwSvYMyvkDef+bQUTv13HejPf4VISXYDUpwk+AxVTyH65u4KxJCx+VtAbTdAHP3VfA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Y1/L5OTa6hIT0BiRKbhebNf8vkNCgVTymtnCv6NQayQ=;
 b=ic/LmkeMqsbhATTY3+vgwTtkw5Pd7j+mFjzem29J6AIAr+TudZ7NqcFOodpEtlP4U6e3ZdckHPEOos+ZUTO1RKjoeNx1LNiEs8/35pQCSHj01g7fYbQGNPfJcSOpwj9hz4iINKWVrU3xTRlq+QLJZS+0YgaB625tpv6iXvtNOmodgwCl558RXobEv52vKt8P7XRBm4/56moSiVKnNBoTlEt7wdCXXTkEUmwgZJpR0Pa+W2M+McIyH4EmWVbkS5rVMlI5kH4R/iyacTEZLnrDVHcAqL04bSunC3AWK24UcmKQe/IbA31eLst0h9k9MXw+uT7ZbeMcRWTtjkXo3K4XFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Y1/L5OTa6hIT0BiRKbhebNf8vkNCgVTymtnCv6NQayQ=;
 b=Q71BpmR+gEReJJzydvJSJcp+Mxi3pBVGeAXWYnGBsjhY+KW90cqfXj7LYIR14U5iFYyWSIqhsBzShN5MUFlc6WHu2JdkpKNT3Mdl2Anl89ANYY6qa74hIk/UVFJmliiC/YQ5o2UQ3lzEg96S3l0OU/n5ZWJfv3tLVzvo0SLBnBHDgKHzl+Agd4YTTvb3FCjk2HY9O1dhJJ39P1q0PCMdoEQKWQuA+jCpj8FszysUky+tvlFNFujOcUKV5ZlS2kEiWlqOT+AnLLANGJsOoO/lTaFNxSg6GLfWPlinxRaXAV3AtjWWys1MX9CXCxOeP0buaDGhMTNNmxcu7F47ippuIw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CY5PR12MB6106.namprd12.prod.outlook.com (2603:10b6:930:29::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6433.24; Wed, 31 May
 2023 17:07:19 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::824c:2f44:2922:fd76]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::824c:2f44:2922:fd76%5]) with mapi id 15.20.6433.022; Wed, 31 May 2023
 17:07:19 +0000
From: Parav Pandit <parav@nvidia.com>
To: Eric Dumazet <edumazet@google.com>, David Ahern <dsahern@kernel.org>
CC: Jakub Kicinski <kuba@kernel.org>, "davem@davemloft.net"
	<davem@davemloft.net>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next] net: Make gro complete function to return void
Thread-Topic: [PATCH net-next] net: Make gro complete function to return void
Thread-Index:
 AQHZkjPELq30Jr2uT0qjGHkTzwnBm69y8YgAgAAGYwCAAECTgIAAMYMAgABlJoCAANCbUA==
Date: Wed, 31 May 2023 17:07:19 +0000
Message-ID:
 <PH0PR12MB5481383E1487D7EA976BB085DC489@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20230529134430.492879-1-parav@nvidia.com>
 <b4940bfa-aab6-644a-77d3-20bf9a876a6a@kernel.org>
 <CANn89iLxUk6KpQ1a=Q+pNb95nkS6fYbHsuBGdxyTX23fuTGo6g@mail.gmail.com>
 <20230530123929.42472e9f@kernel.org>
 <cabcc033-89d2-de7b-d510-14f875942109@kernel.org>
 <CANn89iKKsOGWQNhYFSXChkHMx5ZBojLZf2sKuybTxage4LC4_Q@mail.gmail.com>
In-Reply-To:
 <CANn89iKKsOGWQNhYFSXChkHMx5ZBojLZf2sKuybTxage4LC4_Q@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5481:EE_|CY5PR12MB6106:EE_
x-ms-office365-filtering-correlation-id: d9872a67-6f34-4576-9c96-08db61f97e16
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 Y3xt+oyCvi3OTTTrXDjkuUvoLi+o32fezu2v5pRV7gGEl2+v1umHtXVMlH4wu7r0jJrW3rhHSq0iD2cgTLd0uly6VRMCzOKHVPAZ6Qdb15NOSezrW6OhGBGyoBzV1aE3EBSdsqgDCEdWE47d7jdLw23kzGS0YR2U1L3cSrw0Bn4p8pfWS3iufvRExOnZvnDNkX8dKum7OPyuiljpj6ScS5V+wWO+TPEcWbtmqEQXS8UDwyyDGSVX/0rC0f/lOKqqu0rUzpXR2CkeXjC3heFVtNv3L8JQ5zib5epHn5HpEFsgd8GeBzY4qOBPgMgnni+8sjfy+YTOTNIaIcf3IZMAJnrld/1GtlKT/P0GEF7aGsLJQDnz+Q2Do0vjUxUHb2JcnC+A60zl1f4PWUjotr6uK6ft+2OMtsoTPnL+iSdPB4Gq3aJnJKDhFtyzsG9tqayzbF/Uwa9gYaEOwB38BoK7Y9eND2tGPCfwy1JI2h3UtAbwCquLBlk95hwk2SLwX/QSsasTalMp/lL+YKQOrF72KAi5C/6VG087BiRAJsJY0zpVYx3enyVycD+hSYYl013BIXZEeYODAjsfbtWhK3bH51NA2e2xMs3YXPhxOrXYpTxmYBrDBTBxPRPaLtCygb8i
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(451199021)(41300700001)(478600001)(54906003)(110136005)(122000001)(38100700002)(66476007)(66446008)(66946007)(76116006)(64756008)(71200400001)(4326008)(66556008)(38070700005)(33656002)(86362001)(316002)(7696005)(55016003)(52536014)(8676002)(8936002)(9686003)(53546011)(26005)(6506007)(2906002)(186003)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?MndFVkhuOEZvaGxrSlBqQ3NTYm9QMGs4NkhUcGhpL1kyTE9jUWNYN2xTdW9D?=
 =?utf-8?B?dUM3RTFWUUlvSURvQ3ZFak5EUktESnpDUjJjdW5vT1U3WTBRZUprd1NyZ2NQ?=
 =?utf-8?B?bWpLRGtlMTFkS3l0KzVPYk5pdlhhY2doNHZKNmNTOGoxSENuUDhUUUVxdE1i?=
 =?utf-8?B?QXRoamJQVlc5ZU0zZnpodS9xc2RnYmNQbElUa0l6U2pDQ2FQNDcxSWhrUzUy?=
 =?utf-8?B?OHdkVERvL1BmUk1aOGJocitsMUNUb0NKVC83amRhUm1leFNab21sUnNOYWYy?=
 =?utf-8?B?QUNpa3djMk5MS3RqY0FIemllaldCYlYza2JKK1ZZeFNsR3RTQVpJYWdmZjlw?=
 =?utf-8?B?Z2RZK2hJYVFYTE1MWjlzeDQvUFVCWmpuUGo1dGFnODM3TXlrQmtOWEFZUTUv?=
 =?utf-8?B?dUJhQ3NpQTZCS2pUc05oSnFHbEhrOTlvN0l0WUg1V1R6T0FWUFlob1IzNmtn?=
 =?utf-8?B?MEF1NVRkSEVoUkFyMUU2enNFMm5qY09ZWFJuSVl0RVdXSEFPSlliOG5DTExR?=
 =?utf-8?B?bTB3Q2JoSFZHR0hiMFlSZmVPaHdjTmZZekdNeXNSbExYdzRSSWJ0L2lyN2cv?=
 =?utf-8?B?MnhHbG5RdjlHOGVsUmpMZjVaSXZTSHNuVS8yYWkyL00xNUtTb0NERXcreFRz?=
 =?utf-8?B?ZlYvTUo1SXUyM0tQWm9LRC93V3lpUWhhUTNDdFEyOU9HTDdhVjlhdHFERksz?=
 =?utf-8?B?YjR5amx3SGRITC9jVmJBWGNyRHhBb2hybE0yZ2lFVUs2RWNsRGRxbUtMakMx?=
 =?utf-8?B?TzZ5c1Y1QXlrTSsza1B5TkRIT3lmVlY4RkRtRjRnclN0OXJ6RXB5Y0pybWN6?=
 =?utf-8?B?amE4Y3llSEsyNC9pejZPbHg4MThacDhJbVJyemFESG8xT0RybU5uZldyU2xS?=
 =?utf-8?B?STdrbk5qbE1FY2dkcnB1a0J6ODJrNy90aDFuSmtGSHpIN1lIUEY0QjBHalNq?=
 =?utf-8?B?eG93ZVQzVUJ4clFZWUJqZVQ3ZEhzZ1lEN09WWW1Sdm5Gd0tiaGF4ZDdWYkFQ?=
 =?utf-8?B?ZGlXNTFTbHZndXJURHFnYXBkbDljTERxeEhZaUZ1alhzVFV2ZEd1ZE5GS1VB?=
 =?utf-8?B?NTJYUTFiMURQL2FiNGp4QU1UdTA5T2tjbkJMeHc0RllHS3M2eS9xWHNpaUJ6?=
 =?utf-8?B?ZFhYaXBNQmloUTZlR2Fvb3NScXNRR09qS09WaXlad1ZFQ1BkZnk0M0ZiUmxv?=
 =?utf-8?B?SGZWMVk0TXp5dUhFckNZcnZSRXJoOEVNWHhwUTRjRFIzc1RYY1BZSHNWcy9Q?=
 =?utf-8?B?YWRIS2g5YUp4RHBJQ29EZkNQQnY2ckFJcytPam9nSGFoT0wrSzVMd2dqVDRu?=
 =?utf-8?B?V1BlbmVlSVVVbENHVkdwOUxGa3lFUDFYd1BhbE5Mc2dnSGNpbG9tY3NqbC9w?=
 =?utf-8?B?ZlFqdzI3TWJSeGpPQld4UHdTN2xFaHVtdjR3cTBxa1NTaHhCZ1Z6azRCZ0R0?=
 =?utf-8?B?d0MwWGd6L0VnU295bUphRU80OHhEaE0rdUN5bmR5MFg0eWIzVFhGY2Vpb1du?=
 =?utf-8?B?WG5yYUo1dzlWbnQ4ZTBSdDFta04xSzl6WXRZVW05SGE2bkpKQ3hUTitUcnlj?=
 =?utf-8?B?Ris1d0NKTkEzblNRNytRS0dodVZUUi8yR0RjTnNrTkdOSmZ5K1FQS0xQQTRU?=
 =?utf-8?B?YmNvVjJHbDRSb1VwYjFtNUFkV1UxM1NleDRxeXB0cnh2ZndldWZvNzZnL3Bt?=
 =?utf-8?B?REVjQmw1THBMZFdubVpDWWNXaWRhU1Q3SDlVS1hxK0x4SlMrVkFia0M1dWh5?=
 =?utf-8?B?Z0FlcGF4VWRKVnFRM212NUg2dk1pSVk3dUNwdTZNcVRhQnRzUkQ4R2toQVBE?=
 =?utf-8?B?bG9jNzcrK2xNZENBeFZYODUxMVZHbk9qc2N6N1IzdEpQQ1JkSUpvV2E2eFVq?=
 =?utf-8?B?TnJ3MkhQSlh0Y2ROcVl3c1BkWnZSZDl2YWVibGJZK0g4c1lkTythV1cxOHlF?=
 =?utf-8?B?V2tJSXZtSGFOZk9KNzYwVldKUWFUUXkrOXVYSEtJTThsVHkvT1ZSdFJDN29v?=
 =?utf-8?B?VGE1MEZqTVRadUpyck54TWJsWDFES0gyVEVLV1JZMmZLVmxPSXB4K2hobk8x?=
 =?utf-8?B?WFhCaUxrVklscEZ0ckxDUEM2dWE1ZkN0TUJyT3Rta1pvdUw0OGtwZzBqbjRL?=
 =?utf-8?Q?7CCE=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9872a67-6f34-4576-9c96-08db61f97e16
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2023 17:07:19.2662
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IwZqtClDjt7iM/tGutfeXmW/OOG2ALIEWJJzNIomVX2ttu5FZuV40jiPnWN1U7i1IUxsU6iNfjQwrAQHiC2yow==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6106
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQo+IEZyb206IEVyaWMgRHVtYXpldCA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT4NCj4gU2VudDogV2Vk
bmVzZGF5LCBNYXkgMzEsIDIwMjMgMTI6MzkgQU0NCj4gDQo+IE9uIFdlZCwgTWF5IDMxLCAyMDIz
IGF0IDEyOjM24oCvQU0gRGF2aWQgQWhlcm4gPGRzYWhlcm5Aa2VybmVsLm9yZz4gd3JvdGU6DQo+
ID4NCj4gPiBPbiA1LzMwLzIzIDE6MzkgUE0sIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+ID4g
T24gVHVlLCAzMCBNYXkgMjAyMyAxNzo0ODoyMiArMDIwMCBFcmljIER1bWF6ZXQgd3JvdGU6DQo+
ID4gPj4+IHRjcF9ncm9fY29tcGxldGUgc2VlbXMgZmFpcmx5IHRyaXZpYWwuIEFueSByZWFzb24g
bm90IHRvIG1ha2UgaXQNCj4gPiA+Pj4gYW4gaW5saW5lIGFuZCBhdm9pZCBhbm90aGVyIGZ1bmN0
aW9uIGNhbGwgaW4gdGhlIGRhdGFwYXRoPw0KPiA+ID4+DQo+ID4gPj4gUHJvYmFibHksIGFsdGhv
dWdoIGl0IGlzIGEgcmVndWxhciBmdW5jdGlvbiBjYWxsLCBub3QgYW4gaW5kaXJlY3Qgb25lLg0K
PiA+ID4+DQo+ID4gPj4gSW4gdGhlIGdyYW5kIHRvdGFsIG9mIGRyaXZlciByeCBuYXBpICsgR1JP
IGNvc3QsIHNhdmluZyBhIGZldw0KPiA+ID4+IGN5Y2xlcyBwZXIgR1JPIGNvbXBsZXRlZCBwYWNr
ZXQgaXMgcXVpdGUgc21hbGwuDQo+ID4gPg0KPiA+ID4gSU9XIHBsZWFzZSBtYWtlIHN1cmUgeW91
IGluY2x1ZGUgdGhlIHBlcmZvcm1hbmNlIGFuYWx5c2lzDQo+ID4gPiBxdWFudGlmeWluZyB0aGUg
d2luLCBpZiB5b3Ugd2FudCB0byBtYWtlIHRoaXMgYSBzdGF0aWMgaW5saW5lLiBPcg0KPiA+ID4g
bGV0IHVzIGtub3cgaWYgdGhlIHBhdGNoIGlzIGdvb2QgYXMgaXMsIEknbSBrZWVwaW5nIGl0IGlu
IHB3IGZvciBub3cuDQo+ID4NCj4gPiBJIGFtIG5vdCBzdWdnZXN0aW5nIGhvbGRpbmcgdXAgdGhp
cyBwYXRjaDsganVzdCBjb25zdGFudGx5IGxvb2tpbmcgZm9yDQo+ID4gdGhlc2UgbGl0dGxlIHNh
dmluZ3MgaGVyZSBhbmQgdGhlcmUgdG8ga2VlcCBsb3dlcmluZyB0aGUgb3ZlcmhlYWQuDQo+ID4N
Cj4gPiAxMDBHLCAxNTAwIE1UVSwgbGluZSByYXRlIGlzIDguM00gcHBzIHNvIEdSTyB3aXNlIHRo
YXQgd291bGQgYmUgfjE4MGsNCj4gPiBmZXdlciBmdW5jdGlvbiBjYWxscy4NCj4gDQo+IEhlcmUg
d2l0aCA0SyBNVFUsIHRoaXMgaXMgY2FsbGVkIDY3ayBwZXIgc2Vjb25kDQo+IA0KPiBBbiBfX3Nr
Yl9wdXQoKSBpbnN0ZWFkIG9mIHNrYl9wdXQoKSBpbiBhIGRyaXZlciAoZWcgbWx4NWVfYnVpbGRf
bGluZWFyX3NrYigpKQ0KPiB3b3VsZCBoYXZlIDQ1eCBtb3JlIGltcGFjdCwgYW5kIHdvdWxkIHN0
aWxsIGJlIG5vaXNlLg0KDQpUaGFua3MsIEVyaWMsIGZvciB0aGUgc3VnZ2VzdGlvbiwgd2lsbCBl
dmFsdWF0ZSB3aXRoIFRhcmlxIHRvIHVzZSBfX3NrYl9wdXQoKS4NCg==

