Return-Path: <netdev+bounces-3510-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8CD9707A2E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:17:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7FA7B1C2100C
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 06:17:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4AB72A9DA;
	Thu, 18 May 2023 06:17:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 910DE15A2
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 06:17:06 +0000 (UTC)
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2067.outbound.protection.outlook.com [40.107.93.67])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9891A19BB;
	Wed, 17 May 2023 23:17:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=eEqdNozUYsQzZlMvBBg7BsZzlUvCwG3lSwVU+1jCadgjPeqFXQl5Up7bw8aIW6SFpfalxpUBaPR0+TB9AvLjTs2E9d7heU63LvdcxKi+KwNSKwiYOkML8OxRDYgW8PcxIcmzmxOTqtua5vB6eLPN1Y9DGkWVqDyqfKgwXdb2bba6KpkOyddU21WIZXqhSy9Qf6EBIx/j7aB3IxIHYHFwJEVD26tp8ZiKMJiYni2hx74gahnvdRDvdYWSx2jPaPmhtyAtJVZIQ6y2pwol+YDz/WlPapRiw1DWLrSMa/MatipURIo06RScq9Hz85pHqks+T36alM7neNrwcnxeYamPRQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KkhkIVsUuHtIWB97eBEA+1VKJ/sP3XyCBpnvkjUO1gU=;
 b=V1RyfMylvA0igro0PZ+uLR2eTNfh7QUMTx5klhfPvY0pWWC9Vg1lCjG0A+z8RRM6kC7IqhrZzOdzenlsOfZTiLDbMUT/6lnOzND28M3XLr1yB52MpOv4ccXcgFFMfLTm+XnKifw2pK5WD4BfLJotZ3eoEyIc2kx2bOO7/ASDzHMM2L4WYMYxhgz0YyJrhysHlc7azJmhURfigUl6hLdb27rBcYyTnypXYAG9uDh/opmvq7/MkOLPEiDYL/W9kwiNbIv4TyyEqsBJKQD/LjIqS6ItZbr4JIXIX0tAuGI5+TLE8tQzr3duPXH38zowvIGN91T5v96JGy33IwopdWkOfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KkhkIVsUuHtIWB97eBEA+1VKJ/sP3XyCBpnvkjUO1gU=;
 b=J3XNgBp+hUIEvQJ278FnLxOBVS7+STMLSHTiggeuA/JQ4KlVVqTIRSptmhMabsKLPl8sq5xg4BGUCbqKDOuBRcWNCuQDCN4Yw7PMYiGkYQRRZyTobnagf6d4dhLegGU0G2FeA+aLa0w2yUZqL0mMCKcoaVbfcqMQijjtdZlPxiU=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by DS0PR12MB8455.namprd12.prod.outlook.com (2603:10b6:8:158::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.19; Thu, 18 May
 2023 06:17:00 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c%6]) with mapi id 15.20.6411.017; Thu, 18 May 2023
 06:17:00 +0000
From: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "robh+dt@kernel.org"
	<robh+dt@kernel.org>, "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>
CC: "michal.simek@xilinx.com" <michal.simek@xilinx.com>,
	"radhey.shyam.pandey@xilinx.com" <radhey.shyam.pandey@xilinx.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Sarangi, Anirudha"
	<anirudha.sarangi@amd.com>, "Katakam, Harini" <harini.katakam@amd.com>, "git
 (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Topic: [PATCH net-next V7] dt-bindings: net: xlnx,axi-ethernet: convert
 bindings document to yaml
Thread-Index: AQHZUYT4JLsiahlKOkOq6wiaqDsKBK76dskAgBXCyhCANuRuAIABfynwgBdfw3A=
Date: Thu, 18 May 2023 06:17:00 +0000
Message-ID:
 <MW5PR12MB55984CA9A0C4E87E46C6029D877F9@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230308061223.1358637-1-sarath.babu.naidu.gaddam@amd.com>
 <5d074e6b-7fe1-ab7f-8690-cfb1bead6927@linaro.org>
 <MW5PR12MB559880B0E220BDBD64E06D2487889@MW5PR12MB5598.namprd12.prod.outlook.com>
 <a5e18c4f-b906-5c9d-ec93-836401dcd3ea@linaro.org>
 <MW5PR12MB5598ED29E01601585963D5D0876C9@MW5PR12MB5598.namprd12.prod.outlook.com>
In-Reply-To:
 <MW5PR12MB5598ED29E01601585963D5D0876C9@MW5PR12MB5598.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|DS0PR12MB8455:EE_
x-ms-office365-filtering-correlation-id: ca5c7e88-a744-4c27-8a12-08db57677d7e
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 ETkiiEiISJXAcpUEYa9aYfB1vxX2yihmWMS6UuUr3kuEVM29r0n23vZZjWOpiNS3FYjTH0oPHp9HLs/gPKlKTZgJkH123Kkw3pCrDAFq5URhxwF71Hrzmw8/jAaufJMo+iDF5u06MJFzwA59FcVBLrEWSNR5mRIpZpJ0z64u3/2T8fP8RJpNvHdadBfGP1PXQegpoFqDEwVM6xy50dDdtwL97iWO2C3pkJ+Yk/bXM8U8a+gZ+JjCWDaK4j2DTO6YTCFnQXugc9rdTkI9EL/0hy9YeH7eL+9E7M3CUJLCoEF79TDW7aq+L4y2cfY0rDWCTYQzVYzmIJCB6JBwGNLdyeJKcHeN966PDPA9EY4WQA6p866bmRjhu0OghULrpyJh1HFBpt+BN6P5xYG7pACpgbwCSWMVT2in+MeL72RI0Iek27GsZeEs5ZiSyhKKtiwkyNNl/0zYsYI7I3jQbqN2BgK4FAsXx+XhefS0tObPT52dyCZntWI3YYH7fU3XlcayKgURHFvS08gKqCmMnob8IuO+BAYH06pj385+j1CDdyLEft1lYcNjc7yzWrT9ihPXULyqF27n6k5mZxZu4OVCBb8haJr/1ykYvRJ0iyfosDVpFG8jy/6qFGpZ/D3Exu2Hr+8t162nihKFjQaCCWr8DQ==
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(376002)(346002)(136003)(396003)(366004)(451199021)(86362001)(33656002)(38070700005)(7696005)(54906003)(110136005)(316002)(66556008)(45080400002)(66476007)(64756008)(66446008)(76116006)(66946007)(966005)(4326008)(478600001)(55016003)(52536014)(7416002)(8936002)(5660300002)(41300700001)(2906002)(8676002)(38100700002)(122000001)(9686003)(6506007)(53546011)(26005)(186003)(83380400001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?M3RBZ1dBMEJZZTdKR1VqeUNQSXpaNHNGM1I5K1pJWHVCN2pqZnYraHp5L0dP?=
 =?utf-8?B?dzdld0lQUWRIaTVTbjhIR0hFZHlqUFFKdHk0bjFhNThqMlU2NFpZQWFmTGpM?=
 =?utf-8?B?VndWVW4rV25SUmszenIzRElDWkZRbUVKaVEwMXJNWS9tN2Y5a0FRT2kzY0RE?=
 =?utf-8?B?U1g1U2FrTStSMWtIOVhYeVEwRHRrbEFEVGljeDJGNlhScnNkQXFYR0lubDdJ?=
 =?utf-8?B?VkFJdHVyZjducnpSU1ljQk5CS3NMSllPdHIwUGgzVzZHY1BRZUNtS3hTb00r?=
 =?utf-8?B?eW9HKzJITEZKM25XaEVOczRvM0o3L3A4VGhWUG0rQkN4cERLN1NkbXlHS0Uy?=
 =?utf-8?B?dTZGVGpIQ0xuRGRhVTEwRy9QVU5zMWxMdld4ZDNxZzM0Z25ZdkFLKzk0VnBT?=
 =?utf-8?B?bWlkL3lXZUp0QlorMjFaWlcyOEN1RlViRHI3bGJVVC9USzlYd0JrcFViWEJK?=
 =?utf-8?B?aUhZamk1Qk9FMW9BU2FoT005a29obDRHM0hnWXlmREVlUlFrS0FUeHlxdFkx?=
 =?utf-8?B?Y0E5Ti9WTkFiR2QxYUNvNG5XMHZHTythdHRCeEpVeWZmZE52dkxUU3hidFRK?=
 =?utf-8?B?ZHgvUjBzQ2p2UWNPK2I3V2NoeEg4RDlvQUV3RGkrQUYvSDI5WlhxZWluUGt0?=
 =?utf-8?B?ZjJNQUQ3aC9GMXozRDdQR3YxV25ZczhBUzBoMC9iRVl2T05iT2p4WnZuVXVn?=
 =?utf-8?B?RDRvUVdRWDNyMmc0SFJ2SElMQk1TUmx6L0VRKzFGUlJjZ05jUEUvVTVUWUQz?=
 =?utf-8?B?VUtGODhTOHBXd3pQWFFTakZicEd0V21YWFNtQUZhVGZCR2hNKzF6Z0NBL09x?=
 =?utf-8?B?TTF1MnV5c05xdExLUER0a3VJUDR3MVBnbUtCTUxYTkoweGlLT0E3dTA5b2F0?=
 =?utf-8?B?M2h5Q0FqVjFTTThGbGFFN0Fsd0Q4a3lISnJLVVM5QlZpV1FpV1hCVDRmWkUw?=
 =?utf-8?B?SEptZkdsZjZtamxzOURsenhFcVBTUE9TbmtNQ1ZDWVV5L29KU0lLaExQcWhy?=
 =?utf-8?B?SERxSEY3ZTNlaGY2NFBvVVZ5R2N1cEYzNXdRY2ZkMG9qRXV1MlhlOXk5bkh0?=
 =?utf-8?B?bi9kd1FNbGRhdmZYVm1KUWU3WFdzNzV4V3R6UDRnQm5QS1lWRms0SmlhN0Rj?=
 =?utf-8?B?bjdpeGZQUHJSMmwxOExDTDNvblFsTkFLZUl1bU93UGRySi9DR3VuNW9IRVJP?=
 =?utf-8?B?MFpOdjYwdHJOUldrZGJFRmlzNFJXU3NUdnBaYzBVc1RyQlRyMWZ3OVA4b0hB?=
 =?utf-8?B?V3ViZHBoMkM2Zi9qY001SmFQdXZpcTVKVEhLdk1wdUtlRE85NHlsaGhlaXZu?=
 =?utf-8?B?Uzd3aUthWlZOMnVOMWJGb3kwVVpWbC9ja1FKUzF1Z2Y2UmpDYjQrb1QzU1lQ?=
 =?utf-8?B?VmZoUXg3SFRjdDRYTi8xak5DZ3h1Uk9MTHA5OWE1MHN3NHRGcW1FOWtzVHFO?=
 =?utf-8?B?cTNucnJxN05XWHVTenN5TnAvSFQ1Njg0TC9lUzV3Z21OamkxUFArTmltcHV5?=
 =?utf-8?B?RldMODk5VjcrWmVjdlZxeWtRMTVtRTExY3pUTGdDVzlWOTh2czRyampHOUQ4?=
 =?utf-8?B?Mi8rNFdhVE9WVmxSLzdaYVBweWk5NHE2cEk5djB1SUNlbzBLSnE5Q1lPMlVv?=
 =?utf-8?B?NnpvSm1Yb1VUSW53S1ZQRC92dTg2SmM1VU1jcE56azJXblRGeUZRZXQzK3BT?=
 =?utf-8?B?bmUyVzZFMWs3UFNndGhhVEE3QW5FNHJPdXVGMVE1YzZQMWJua3FrWlU0Ykp4?=
 =?utf-8?B?RW1iclBQbVdiaWNscTVxaXpUbXdDK3dxY214Y09nUVpJYmlDaE1WNENMUlJs?=
 =?utf-8?B?ajZ3RFJlb2xNZS9MVklZaDVlZ2lpRGRlV2hocWdielRnVk9WUnpVdE80blo2?=
 =?utf-8?B?dDRpTzVvUjhscGxscmtrRU9uSEFhYTN2MXJ0MktSWCtmcmlHUVhTVWVxakJ1?=
 =?utf-8?B?R3hETWJtNmpLRWM3SWU3SXFKdUZjZjZxL0tLNjJsTTY0RERaa2ZaWXZTZXVR?=
 =?utf-8?B?NllodU51ZWtzZWhQa0xUYldtRDVRUUszaVZKeDBDK2xwckpKTmg2cXhVdFZz?=
 =?utf-8?B?NStvMnl6MGF2eGVjdTVRUHp5Wnc0dU1obENXWkpzSkxHRnBraGRWQk56NkZl?=
 =?utf-8?Q?Pupw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR12MB5598.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca5c7e88-a744-4c27-8a12-08db57677d7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2023 06:17:00.1462
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4W7Dnih3+ymI0fL7lN7PgZH7CD/OMgKVtH1dC2Ej4owznLAXTVWmHNjh9xhbgK/iHY6B7iPk7eNgEdbk/jWqjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8455
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogR2FkZGFtLCBTYXJhdGgg
QmFidSBOYWlkdQ0KPiBTZW50OiBXZWRuZXNkYXksIE1heSAzLCAyMDIzIDM6MDEgUE0NCj4gVG86
IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lAbGluYXJvLm9yZz47DQo+
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9y
ZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IHJvYmgrZHRAa2VybmVsLm9yZzsNCj4ga3J6eXN6dG9m
Lmtvemxvd3NraStkdEBsaW5hcm8ub3JnDQo+IENjOiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsg
cmFkaGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29tOw0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3Jn
OyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMu
aW5mcmFkZWFkLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwNCj4g
QW5pcnVkaGEgPGFuaXJ1ZGhhLnNhcmFuZ2lAYW1kLmNvbT47IEthdGFrYW0sIEhhcmluaQ0KPiA8
aGFyaW5pLmthdGFrYW1AYW1kLmNvbT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0K
PiBTdWJqZWN0OiBSRTogW1BBVENIIG5ldC1uZXh0IFY3XSBkdC1iaW5kaW5nczogbmV0OiB4bG54
LGF4aS1ldGhlcm5ldDoNCj4gY29udmVydCBiaW5kaW5ncyBkb2N1bWVudCB0byB5YW1sDQo+IA0K
PiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBLcnp5c3p0
b2YgS296bG93c2tpIDxrcnp5c3p0b2Yua296bG93c2tpQGxpbmFyby5vcmc+DQo+ID4gU2VudDog
VHVlc2RheSwgTWF5IDIsIDIwMjMgMzo1NiBQTQ0KPiA+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1
IE5haWR1DQo+ID4gPHNhcmF0aC5iYWJ1Lm5haWR1LmdhZGRhbUBhbWQuY29tPjsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsNCj4gPiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBh
YmVuaUByZWRoYXQuY29tOw0KPiA+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxv
d3NraStkdEBsaW5hcm8ub3JnDQo+ID4gQ2M6IG1pY2hhbC5zaW1la0B4aWxpbnguY29tOyByYWRo
ZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb207DQo+ID4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsg
ZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS0NCj4gPiBrZXJuZWxAbGlzdHMu
aW5mcmFkZWFkLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwNCj4g
PiBBbmlydWRoYSA8YW5pcnVkaGEuc2FyYW5naUBhbWQuY29tPjsgS2F0YWthbSwgSGFyaW5pDQo+
ID4gPGhhcmluaS5rYXRha2FtQGFtZC5jb20+OyBnaXQgKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNv
bT4NCj4gPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IFY3XSBkdC1iaW5kaW5nczogbmV0
OiB4bG54LGF4aS1ldGhlcm5ldDoNCj4gPiBjb252ZXJ0IGJpbmRpbmdzIGRvY3VtZW50IHRvIHlh
bWwNCj4gPg0KPiA+IE9uIDI4LzAzLzIwMjMgMTQ6NTIsIEdhZGRhbSwgU2FyYXRoIEJhYnUgTmFp
ZHUgd3JvdGU6DQo+ID4gPg0KPiA+ID4NCj4gPiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0t
LQ0KPiA+ID4+IEZyb206IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRvZi5rb3psb3dza2lA
bGluYXJvLm9yZz4NCj4gPiA+PiBTZW50OiBUdWVzZGF5LCBNYXJjaCAxNCwgMjAyMyA5OjIyIFBN
DQo+ID4gPj4gVG86IEdhZGRhbSwgU2FyYXRoIEJhYnUgTmFpZHUNCj4gPiA+PiA8c2FyYXRoLmJh
YnUubmFpZHUuZ2FkZGFtQGFtZC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiA+ID4+IGVk
dW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+
ID4gPj4gcm9iaCtkdEBrZXJuZWwub3JnOyBrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5v
cmcNCj4gPiA+PiBDYzogbWljaGFsLnNpbWVrQHhpbGlueC5jb207IHJhZGhleS5zaHlhbS5wYW5k
ZXlAeGlsaW54LmNvbTsNCj4gPiA+PiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVl
QHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLQ0KPiA+ID4+IGtlcm5lbEBsaXN0cy5pbmZyYWRl
YWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTYXJhbmdpLA0KPiA+ID4+IEFu
aXJ1ZGhhIDxhbmlydWRoYS5zYXJhbmdpQGFtZC5jb20+OyBLYXRha2FtLCBIYXJpbmkNCj4gPiA+
PiA8aGFyaW5pLmthdGFrYW1AYW1kLmNvbT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29t
Pg0KPiA+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgVjddIGR0LWJpbmRpbmdzOiBu
ZXQ6IHhsbngsYXhpLWV0aGVybmV0Og0KPiA+ID4+IGNvbnZlcnQgYmluZGluZ3MgZG9jdW1lbnQg
dG8geWFtbA0KPiA+ID4+DQo+ID4gPj4gT24gMDgvMDMvMjAyMyAwNzoxMiwgU2FyYXRoIEJhYnUg
TmFpZHUgR2FkZGFtIHdyb3RlOg0KPiA+ID4+PiBGcm9tOiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxy
YWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQo+ID4gPj4+DQo+ID4gPj4+IENvbnZlcnQg
dGhlIGJpbmRpbmdzIGRvY3VtZW50IGZvciBYaWxpbnggQVhJIEV0aGVybmV0IFN1YnN5c3RlbQ0K
PiA+IGZyb20NCj4gPiA+Pj4gdHh0IHRvIHlhbWwuIE5vIGNoYW5nZXMgdG8gZXhpc3RpbmcgYmlu
ZGluZyBkZXNjcmlwdGlvbi4NCj4gPiA+Pj4NCj4gPiA+Pg0KPiA+ID4+ICguLi4pDQo+ID4gPj4N
Cj4gPiA+Pj4gK3Byb3BlcnRpZXM6DQo+ID4gPj4+ICsgIGNvbXBhdGlibGU6DQo+ID4gPj4+ICsg
ICAgZW51bToNCj4gPiA+Pj4gKyAgICAgIC0geGxueCxheGktZXRoZXJuZXQtMS4wMC5hDQo+ID4g
Pj4+ICsgICAgICAtIHhsbngsYXhpLWV0aGVybmV0LTEuMDEuYQ0KPiA+ID4+PiArICAgICAgLSB4
bG54LGF4aS1ldGhlcm5ldC0yLjAxLmENCj4gPiA+Pj4gKw0KPiA+ID4+PiArICByZWc6DQo+ID4g
Pj4+ICsgICAgZGVzY3JpcHRpb246DQo+ID4gPj4+ICsgICAgICBBZGRyZXNzIGFuZCBsZW5ndGgg
b2YgdGhlIElPIHNwYWNlLCBhcyB3ZWxsIGFzIHRoZSBhZGRyZXNzDQo+ID4gPj4+ICsgICAgICBh
bmQgbGVuZ3RoIG9mIHRoZSBBWEkgRE1BIGNvbnRyb2xsZXIgSU8gc3BhY2UsIHVubGVzcw0KPiA+
ID4+PiArICAgICAgYXhpc3RyZWFtLWNvbm5lY3RlZCBpcyBzcGVjaWZpZWQsIGluIHdoaWNoIGNh
c2UgdGhlIHJlZw0KPiA+ID4+PiArICAgICAgYXR0cmlidXRlIG9mIHRoZSBub2RlIHJlZmVyZW5j
ZWQgYnkgaXQgaXMgdXNlZC4NCj4gPiA+Pg0KPiA+ID4+IERpZCB5b3UgdGVzdCBpdCB3aXRoIGF4
aXN0cmVhbS1jb25uZWN0ZWQ/IFRoZSBzY2hlbWEgYW5kDQo+ID4gPj4gZGVzY3JpcHRpb24gZmVl
bCBjb250cmFkaWN0b3J5IGFuZCB0ZXN0cyB3b3VsZCBwb2ludCB0aGUgaXNzdWUuDQo+ID4gPg0K
PiA+ID4gVGhhbmtzIGZvciByZXZpZXcgY29tbWVudHMuIFdlIHRlc3RlZCB3aXRoIGF4aXN0cmVh
bS1jb25uZWN0ZWQNCj4gYW5kDQo+ID4gZGlkDQo+ID4gPiBub3Qgb2JzZXJ2ZSBhbnkgZXJyb3Jz
LiBEbyB5b3UgYW50aWNpcGF0ZSBhbnkgaXNzdWVzL2Vycm9ycyA/DQo+ID4NCj4gPiBZZXMsIEkg
YW50aWNpcGF0ZSBlcnJvcnMuIFdoYXQgeW91IHdyb3RlIGhlcmUgbG9va3MgaW5jb3JyZWN0IGJh
c2VkIG9uDQo+ID4gdGhlIHNjaGVtYS4NCj4gPg0KPiA+IEFsc28sIFNlZSBhbHNvIG15IGZ1cnRo
ZXIgY29tbWVudHMgKG9yIHlvdSBpZ25vcmVkIHRoZW0/KS4NCj4gPg0KPiA+IFlvdSBjYW4gY29t
ZSBtYW55IG1vbnRocyBhZnRlciBteSByZXZpZXcgdG8gYXNrIGFib3V0IGRldGFpbHMsIHRvIGJl
DQo+ID4gc3VyZSBJIHdpbGwgZm9yZ2V0IHRoZSB0b3BpYy4NCj4gDQo+IA0KPiBIaSBLcnp5c3p0
b2YsIEFwb2xvZ2llcyBmb3IgbWlzY29tbXVuaWNhdGlvbi4gSSByZXBsaWVkIHRvIHRoaXMgdGhy
ZWFkIG9uDQo+IE1hcmNoIDI4IGFuZCBzYWlkIHRoYXQgSSB3b3VsZCBhZGRyZXNzIHJlbWFpbmlu
ZyByZXZpZXcgY29tbWVudHMgaW4NCj4gdGhlIG5leHQgdmVyc2lvbi4NCj4gDQo+IExvcmUgbGlu
azoNCj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsL01XNVBSMTJNQjU1OTg4MEIwRTIyMEJE
QkQ2NEUwNkQyNA0KPiA4Nzg4OUBNVzVQUjEyTUI1NTk4Lm5hbXByZDEyLnByb2Qub3V0bG9vay5j
b20vDQo+IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2FsbC9NVzVQUjEyTUI1NTk4Njc4QkI5QUI2
RUMyRkZDNDI0RjQ4DQo+IDc4ODlATVc1UFIxMk1CNTU5OC5uYW1wcmQxMi5wcm9kLm91dGxvb2su
Y29tLw0KPiANCj4gSSBwbGFubmVkIHRvIHNlbmQgbmV4dCB2ZXJzaW9uIHdpdGggcGh5LW1vZGUg
YW5kIHBjcy1oYW5kbGUgbWF4SXRlbXMNCj4gZml4ZWQuYnV0IEkgd2FudGVkIHRvIGNsb3NlIG9u
IHRoZSBheGlzdHJlYW0tY29ubmVjdGVkIGRpc2N1c3Npb24gYmVmb3JlDQo+IGRvaW5nIHNvLg0K
PiANCj4gUmVsYXRlZCB0byBheGlzdHJlYW0tY29ubmVjdGVkIGRpc2N1c3Npb246DQo+IEkgYWxy
ZWFkeSByYW4gZHQgYmluZGluZyBjaGVjayBmb3Igc2NoZW1hIGFuZCBkdHMgbm9kZSB2YWxpZGF0
aW9uLiBJDQo+IGFzc3VtZSB0aGlzIHNob3VsZCBwb2ludCBhbnkgZXJyb3JzIG9uIGl0Lg0KPiAN
Cg0KSGkgS3J6eXN6dG9mLCBDb3VsZCB5b3UgcGxlYXNlIGNvbW1lbnQgb24gdGhpcyA/IFBsZWFz
ZSBsZXQgbWUgaWYgSSBtaXNzZWQNCmFueSBjaGFuZ2VzIG9yIGNvbW1lbnRzLg0KDQpUaGFua3Ms
DQpTYXJhdGggDQoNCg==

