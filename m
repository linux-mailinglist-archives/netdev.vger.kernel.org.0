Return-Path: <netdev+bounces-3329-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9FB8F70678C
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:07:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CFDA3281517
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:07:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFA2E2C748;
	Wed, 17 May 2023 12:07:04 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC3B2C73F
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:07:04 +0000 (UTC)
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2040.outbound.protection.outlook.com [40.107.236.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81AC66580;
	Wed, 17 May 2023 05:06:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UqCkQt7nyVkw9KGJ8Jx1KJMUwx035csjao4siHcPJUZ2N8huafxfigJCOBbU3LPbhf9MJapckLNDVeSqhhaPdXFYQH0jXpziNuwaTC1c/i3I+yqGkjCi3g2dxfHMJMB71LU9Lf3+dGPeORZYcus6CGTxAhuvrkEvedFpuL3nNgLRtFNhMmBvOnTQHPtn424shrlemTRHgeBDtBs6tvyZg53LMeD8MURra8OdgRgItjROEM/djpqk0xrfJ96lfdO0pEd/KtKyMo5ofM4PZBm3oiZDSCx+zF7f8nqqETT6CsyLtdlBPdUq+6GSFs3DZydXW2C/J0CDrL6iDVzDfNIimg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Cp5WzJp0fZRq5noITaStoNwLWF3PNAs3UJri99VBNjs=;
 b=GkjsCuf9dvgSTOBDqErN3Y1F7T7krDOf/jzTwNDHSZoZ7Ssr556zXGiCQpKKg8v7tdVwnNb1ttZi9m3tlYNnpO/872HaFukeh0EuhZsjk6PW+/+fRm9xo5NQYrsoucBJtFQf3Z+8NF8bg21xiit8s8LT9/dt0Ysu0eWAX6Qb/pL0h09ue5hpOEPRXXO05XVgRRxl0R4srSooIYKJzYv694dkNAsX7QvhX53XSD3D7ghzVK9jN0f0evKvy4hDAXsFiodSNJDO/dFzFVRSPVFKOQ356YS8TQ+m6pM9XlB2l72K8oD20LJbLzizL6hqtxKz9xwaKn1s2zCo6CF83ggaRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cp5WzJp0fZRq5noITaStoNwLWF3PNAs3UJri99VBNjs=;
 b=ydyv2OT02n+0YslHcAAM95eZ5j447DOubQ93LxEg7F81z+QNrq/Yrq6PgMW3T1c5UuQCDbZo9WZyTNVrfY53URSb8WnbEGpaKlp/Klgp/1WuA9TT2J2JKCcCBh5efiWBqtuWcwxW3luO5fEsr/cSc4lYp2QSWbFzQ18kJdqssqk=
Received: from MW5PR12MB5598.namprd12.prod.outlook.com (2603:10b6:303:193::11)
 by DS0PR12MB8069.namprd12.prod.outlook.com (2603:10b6:8:f0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6387.33; Wed, 17 May 2023 12:06:48 +0000
Received: from MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c]) by MW5PR12MB5598.namprd12.prod.outlook.com
 ([fe80::8a8d:1887:c17e:4e0c%6]) with mapi id 15.20.6411.017; Wed, 17 May 2023
 12:06:48 +0000
From: "Gaddam, Sarath Babu Naidu" <sarath.babu.naidu.gaddam@amd.com>
To: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"davem@davemloft.net" <davem@davemloft.net>, "edumazet@google.com"
	<edumazet@google.com>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "robh+dt@kernel.org"
	<robh+dt@kernel.org>, "krzysztof.kozlowski+dt@linaro.org"
	<krzysztof.kozlowski+dt@linaro.org>
CC: "linux@armlinux.org.uk" <linux@armlinux.org.uk>, "Simek, Michal"
	<michal.simek@amd.com>, "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Sarangi, Anirudha"
	<anirudha.sarangi@amd.com>, "Katakam, Harini" <harini.katakam@amd.com>, "git
 (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Thread-Topic: [PATCH net-next V3 1/3] dt-bindings: net: xilinx_axienet:
 Introduce dmaengine binding support
Thread-Index: AQHZgxyMhcxz4C0Hi06uaEd1rO/7na9TSJIAgAGnKOCAAT+aAIAIK2FA
Date: Wed, 17 May 2023 12:06:48 +0000
Message-ID:
 <MW5PR12MB55983A529A1F57A39C7A61B7877E9@MW5PR12MB5598.namprd12.prod.outlook.com>
References: <20230510085031.1116327-1-sarath.babu.naidu.gaddam@amd.com>
 <20230510085031.1116327-2-sarath.babu.naidu.gaddam@amd.com>
 <95f61847-2ec3-a4e0-d277-5d68836f66cf@linaro.org>
 <MW5PR12MB55986A4865DB56F7F024EA7687749@MW5PR12MB5598.namprd12.prod.outlook.com>
 <fe2989c2-2d90-286f-0492-2b07720afcf9@linaro.org>
In-Reply-To: <fe2989c2-2d90-286f-0492-2b07720afcf9@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR12MB5598:EE_|DS0PR12MB8069:EE_
x-ms-office365-filtering-correlation-id: cc323e52-9c03-4f62-6028-08db56cf3104
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 I//Pnn2bdohkEEK4cUU1iu9HYB7IxPB6g/zlCSAA+yw7yIs2gtRUibjnSFYtxRCsdMlwuSgXwJQn1zrXL90HEio22+LiItruSbC4f5AoKJB/8VOFwkMDRgRrE9RDs5KdtEBHaVx/Ej6SD9MunKcyqeo4dWSGS5QOcD2ybu0uERDhLPXPzIMey3vuxYe+JQ+r52gGo1RYvNuS/Gh2F/bMyFfvuy9nOF42fbd9yupJ53LY4Hb4HW8/z4Kf0Pg3ozHBTlISE1z9C9qqBWXqtRFmFIurH9fvOcw5X7OMwY8sJOvL1g8T0eCpNte14LZqtNBAeHdnr0sZ1f6uxP/9pmbahLF7HQ8RhbLywfA0/8kaRnamar1Vy5oUbrHkG1nbjioKIPxvDoGUXzeEeA6VoqRdaVFuac/lbni72B9dikU+yprhiWQM1tTPkraZQHdeddtDS9FGyeBQKtWgP+2wtlD93san2mkrUB53RPepmRaEQ1bS/k+iAWgP1Y9foMbZL2qI7S6kMBKZEV8QQINQHlK+yALtfTngTlKXPyvVGwN5gWLZG2qnN5ssDrgiUaUHi1xdKDDfeh+Dm0I/5GZDNKYoTxNjLW6Qtw7Zc4zZ7FkJAO0=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR12MB5598.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(366004)(396003)(376002)(451199021)(52536014)(5660300002)(8936002)(86362001)(7416002)(8676002)(66556008)(83380400001)(966005)(6506007)(9686003)(53546011)(26005)(38100700002)(186003)(122000001)(38070700005)(7696005)(478600001)(71200400001)(33656002)(110136005)(55016003)(316002)(66446008)(41300700001)(66946007)(54906003)(66476007)(76116006)(64756008)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?utf-8?B?SjV1cWp5Nlp6c1lGWHdaZ2RwTTQycXNVMVpKakdLRjNYbUdYa213VldXSTVs?=
 =?utf-8?B?ZzBNT1VMSlMySXVWWXlvOCtPZUFoLzZkU2tCQTJIMFQ1MFFqT1kxZERUVm8r?=
 =?utf-8?B?TEZZa09OaDhSazhmcjBpeSswZ1IvdGJyeVZybkVZbmkydnVjYTVxdXgyTGVK?=
 =?utf-8?B?eTZWVzhkeXhMWk9saE9JaGx3VnlQR0h3RHRZUncwNzhGeTNOR3lVd1lWY2J1?=
 =?utf-8?B?RVd0MHA3VCtTUkxma0Q3eUhaVjZ4SFlFWlZWT2ZrYkd1Z3duOTJwUEdIenJO?=
 =?utf-8?B?WFZrNFFQdWlpckh1bFN4T0o2TFJsNVd2WGdXcUdVUFpneVZ0ZXVUdDlkZ3I5?=
 =?utf-8?B?bHZQTkgvcHhEcFhVMzhET2Y2RzlGbkdhQWFTTEhGL1o5Um0zRXBvKzV0T0JZ?=
 =?utf-8?B?UXlwZFVjUDg5RmtaQW5CbkxIbWRBRzd6SGlUM3I4NFlPOFVlU2ZvcUtoSDFE?=
 =?utf-8?B?OW5uMmNKb0cvTzlZYWd5UE9Mbzg4c1kzZ2JyL3JaSlhtYnJZaHZBbGxReXAx?=
 =?utf-8?B?RXZyZzFBS1BtWjRzTEU0Nm0rMjBXSHhvVHQ5cUhJZVpXRGgzOTNnRTRrcVRi?=
 =?utf-8?B?OGE1Q2RQRDJkQ3NPR1VZMkNlVWJmZXpXVmVRMWdsMCt1SllXa0dadkdOLzRJ?=
 =?utf-8?B?emJVdE5pdXRPVlk2M0FaWU9yQzFvR2hTd3ppSnhkUm9OSEhjYWhzN1VmdzhV?=
 =?utf-8?B?Uit4WGIzTEJxM2Z0R2pQeWVVSTJVTDJxbTdrS0RXTldFTUQzVTRVNzVDNWlB?=
 =?utf-8?B?L2hDUGlUVU9idGs2NE9QZDV6LzB6a2FpRzhqYUxpWGZWbzFKcjhwUHFRWUR2?=
 =?utf-8?B?V1N0dmFSYUNwdG9FWEgxa01oTC9vOXQxTUFyYjhpRnpqL2crUGRTSUs5SXlm?=
 =?utf-8?B?Nm52amNQZHhOTHpjTTZHOFcvM0c0eXlyc1l3bzFML0ptRTYzWk00VTIybWM2?=
 =?utf-8?B?YVB0cTBhS1o3ejJSODlUQ1RZU29id2tCZWptdEl0VGg2bzJacmp5MUY5V1dy?=
 =?utf-8?B?WmMxNUpJYktpaW80Q2syQVJ2R1BlZUt2TWZRNDRBck14OVhSd05HbEhOekdM?=
 =?utf-8?B?WXplc1R6NG5BUkZtN1NjcHhxTFJRbHhxYUVNYzd4Y0EvRGd0WThSUmdpVXVU?=
 =?utf-8?B?S0NHSFZRYXV5WlRXUHR2OFNaWkV0QlE4aHNmRTUwV0UrTERzS003ZGF6NVZD?=
 =?utf-8?B?L0YxNVlJVnYvMmxqNnkyV2F5N1Z4bDFqbWFQOE80d3hvSm1lckF2RGdWbUI2?=
 =?utf-8?B?dk9WdVg5eDRaMlpOUkgzc0xjK2VFd3Q4KzMzL091SmJSM1VqaTNMeGFFUzZU?=
 =?utf-8?B?cFBuaHBPU21pYmIreVF5a0RhMEk3cUV2ZFB1d1cvWFh6WVozeUZqRS9idWhr?=
 =?utf-8?B?M21KaGNIZCtBUWxOUmtsK0RFcXczQmk0cHA0VFJzbUUzWHdsWTNMKzljVTQ3?=
 =?utf-8?B?RDM4Q2x3d1pkc2JxSHBRNG9keUtsVG5lL09TUGRVeHZVNGRIYWpGWXhpLzJF?=
 =?utf-8?B?NnRJR2xUVS91dWNaYm1zNzNCM0xjZHJhcWc4SFRCMUEvNXpjVFFwUDl3U2hv?=
 =?utf-8?B?Qkp0L0djQ2srL1ZhY3pTVkhQRjRMeHZWUlpUbyt5eTd2djUyVDdzMXBHeHNh?=
 =?utf-8?B?UnZyMUxoOVhDQnVOa1R4bU1FRU9OTDZ4RTRwcnE2OUZSYUhNREllSUNvNTI4?=
 =?utf-8?B?K2JqcEtSMENWN3cwcUVWOVEvNEdiUEFHWm4xNDlLR1Z1aHJGaCs4TzdZaEt3?=
 =?utf-8?B?K2dySkljMHZrYUZQdjBFR3JGZHdKMHBFek1nWHY1R0Jrb3FMM0l0clRERS82?=
 =?utf-8?B?TnVoTGV5NXl2YWxBOG8xQkpucGs1MXlXcmtyZllHQ2I3N1g2ZXMrVDdNU2xI?=
 =?utf-8?B?ZVVLRHhQRVdsNjQ5cjJzWXo2Z2JObDVaMTNmdVpLeHhnSDhNNjFNS2Zvdmdp?=
 =?utf-8?B?ZVNTUUQvN2krQnV1OWZFZ1lYT25JNXZsbnp1M0FuNFYyZWQ5dy9QTWVQc3FB?=
 =?utf-8?B?eTZGTmR4Vmpxc3pJV0xoOXVjN2svdDJaRTI1VndLTlAzcEFtalh2cy85UGxv?=
 =?utf-8?B?VDhUS2dpUloxZFJjL3lpS2pmdncrMVllcjdRY1RodUEwWEpRZzVadndoZ0JU?=
 =?utf-8?Q?wp8A=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: cc323e52-9c03-4f62-6028-08db56cf3104
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 May 2023 12:06:48.3413
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GZmlCFRHrloEV5vVkfCXMz4HwDLM+eJu6NvA4a1/2AsBK0frqDsvGEuZoaZgCwYFpEaqXQMGbDNLP09iUABe9w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB8069
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogS3J6eXN6dG9mIEtvemxv
d3NraSA8a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiBTZW50OiBGcmlkYXksIE1h
eSAxMiwgMjAyMyAxMTo1NyBBTQ0KPiBUbzogR2FkZGFtLCBTYXJhdGggQmFidSBOYWlkdQ0KPiA8
c2FyYXRoLmJhYnUubmFpZHUuZ2FkZGFtQGFtZC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0K
PiBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29t
Ow0KPiByb2JoK2R0QGtlcm5lbC5vcmc7IGtyenlzenRvZi5rb3psb3dza2krZHRAbGluYXJvLm9y
Zw0KPiBDYzogbGludXhAYXJtbGludXgub3JnLnVrOyBTaW1laywgTWljaGFsIDxtaWNoYWwuc2lt
ZWtAYW1kLmNvbT47DQo+IFBhbmRleSwgUmFkaGV5IFNoeWFtIDxyYWRoZXkuc2h5YW0ucGFuZGV5
QGFtZC5jb20+Ow0KPiBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBkZXZpY2V0cmVlQHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtYXJtLQ0KPiBrZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgU2FyYW5naSwNCj4gQW5pcnVkaGEgPGFuaXJ1ZGhhLnNh
cmFuZ2lAYW1kLmNvbT47IEthdGFrYW0sIEhhcmluaQ0KPiA8aGFyaW5pLmthdGFrYW1AYW1kLmNv
bT47IGdpdCAoQU1ELVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENI
IG5ldC1uZXh0IFYzIDEvM10gZHQtYmluZGluZ3M6IG5ldDogeGlsaW54X2F4aWVuZXQ6DQo+IElu
dHJvZHVjZSBkbWFlbmdpbmUgYmluZGluZyBzdXBwb3J0DQo+IA0KPiBPbiAxMS8wNS8yMDIzIDEz
OjMyLCBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1IHdyb3RlOg0KPiA+DQo+ID4NCj4gPj4gLS0t
LS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPj4gRnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSA8
a3J6eXN6dG9mLmtvemxvd3NraUBsaW5hcm8ub3JnPg0KPiA+PiBTZW50OiBXZWRuZXNkYXksIE1h
eSAxMCwgMjAyMyAzOjM5IFBNDQo+ID4+IFRvOiBHYWRkYW0sIFNhcmF0aCBCYWJ1IE5haWR1DQo+
ID4+IDxzYXJhdGguYmFidS5uYWlkdS5nYWRkYW1AYW1kLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5u
ZXQ7DQo+ID4+IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJl
ZGhhdC5jb207DQo+ID4+IHJvYmgrZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStk
dEBsaW5hcm8ub3JnDQo+ID4+IENjOiBsaW51eEBhcm1saW51eC5vcmcudWs7IFNpbWVrLCBNaWNo
YWwgPG1pY2hhbC5zaW1la0BhbWQuY29tPjsNCj4gPj4gUGFuZGV5LCBSYWRoZXkgU2h5YW0gPHJh
ZGhleS5zaHlhbS5wYW5kZXlAYW1kLmNvbT47DQo+ID4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7
IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC1hcm0tDQo+ID4+IGtlcm5lbEBsaXN0
cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTYXJhbmdpLA0K
PiA+PiBBbmlydWRoYSA8YW5pcnVkaGEuc2FyYW5naUBhbWQuY29tPjsgS2F0YWthbSwgSGFyaW5p
DQo+ID4+IDxoYXJpbmkua2F0YWthbUBhbWQuY29tPjsgZ2l0IChBTUQtWGlsaW54KSA8Z2l0QGFt
ZC5jb20+DQo+ID4+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0LW5leHQgVjMgMS8zXSBkdC1iaW5k
aW5nczogbmV0OiB4aWxpbnhfYXhpZW5ldDoNCj4gPj4gSW50cm9kdWNlIGRtYWVuZ2luZSBiaW5k
aW5nIHN1cHBvcnQNCj4gPj4NCj4gPj4gT24gMTAvMDUvMjAyMyAxMDo1MCwgU2FyYXRoIEJhYnUg
TmFpZHUgR2FkZGFtIHdyb3RlOg0KPiA+Pj4gRnJvbTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFk
aGV5LnNoeWFtLnBhbmRleUB4aWxpbnguY29tPg0KPiA+Pj4NCj4gPj4+IFRoZSBheGlldGhlcm5l
dCBkcml2ZXIgd2lsbCB1c2UgZG1hZW5naW5lIGZyYW1ld29yayB0byBjb21tdW5pY2F0ZQ0KPiA+
Pj4gd2l0aCBkbWEgY29udHJvbGxlciBJUCBpbnN0ZWFkIG9mIGJ1aWx0LWluIGRtYSBwcm9ncmFt
bWluZyBzZXF1ZW5jZS4NCj4gPj4NCj4gPj4gU3ViamVjdDogZHJvcCBzZWNvbmQvbGFzdCwgcmVk
dW5kYW50ICJiaW5kaW5ncyIuIFRoZSAiZHQtYmluZGluZ3MiDQo+ID4+IHByZWZpeCBpcyBhbHJl
YWR5IHN0YXRpbmcgdGhhdCB0aGVzZSBhcmUgYmluZGluZ3MuDQo+ID4+DQo+ID4+IEFjdHVhbGx5
IGFsc28gZHJvcCAiZG1hZW5naW5nIiBhcyBpdCBpcyBMaW51eGlzbS4gRm9jdXMgb24gaGFyZHdh
cmUsDQo+IGUuZy4NCj4gPj4gIkFkZCBETUEgc3VwcG9ydCIuDQo+ID4+DQo+ID4+Pg0KPiA+Pj4g
VG8gcmVxdWVzdCBkbWEgdHJhbnNtaXQgYW5kIHJlY2VpdmUgY2hhbm5lbHMgdGhlIGF4aWV0aGVy
bmV0IGRyaXZlcg0KPiA+Pj4gdXNlcyBnZW5lcmljIGRtYXMsIGRtYS1uYW1lcyBwcm9wZXJ0aWVz
Lg0KPiA+Pj4NCj4gPj4+IEFsc28gdG8gc3VwcG9ydCB0aGUgYmFja3dhcmQgY29tcGF0aWJpbGl0
eSwgdXNlICJkbWFzIiBwcm9wZXJ0eSB0bw0KPiA+Pj4gaWRlbnRpZnkgYXMgaXQgc2hvdWxkIHVz
ZSBkbWFlbmdpbmUgZnJhbWV3b3JrIG9yIGxlZ2FjeQ0KPiA+Pj4gZHJpdmVyKGJ1aWx0LWluIGRt
YSBwcm9ncmFtbWluZykuDQo+ID4+Pg0KPiA+Pj4gQXQgdGhpcyBwb2ludCBpdCBpcyByZWNvbW1l
bmRlZCB0byB1c2UgZG1hZW5naW5lIGZyYW1ld29yayBidXQgaXQncw0KPiA+Pj4gb3B0aW9uYWwu
IE9uY2UgdGhlIHNvbHV0aW9uIGlzIHN0YWJsZSB3aWxsIG1ha2UgZG1hcyBhcyByZXF1aXJlZA0K
PiA+Pj4gcHJvcGVydGllcy4NCj4gPj4+DQo+ID4+PiBTaWduZWQtb2ZmLWJ5OiBSYWRoZXkgU2h5
YW0gUGFuZGV5DQo+ID4+IDxyYWRoZXkuc2h5YW0ucGFuZGV5QHhpbGlueC5jb20+DQo+ID4+PiBT
aWduZWQtb2ZmLWJ5OiBTYXJhdGggQmFidSBOYWlkdSBHYWRkYW0NCj4gPj4+IDxzYXJhdGguYmFi
dS5uYWlkdS5nYWRkYW1AYW1kLmNvbT4NCj4gPj4+IC0tLQ0KPiA+Pj4gVGhlc2UgY2hhbmdlcyBh
cmUgb24gdG9wIG9mIGJlbG93IHR4dCB0byB5YW1sIGNvbnZlcnNpb24gZGlzY3Vzc2lvbg0KPiA+
Pj4gaHR0cHM6Ly9sb3JlLmtlcm5lbC5vcmcvYWxsLzIwMjMwMzA4MDYxMjIzLjEzNTg2MzctMS0N
Cj4gPj4gc2FyYXRoLmJhYnUubmFpZHUNCj4gPj4+IC5nYWRkYW1AYW1kLmNvbS8jWjJlLjoyMDIz
MDMwODA2MTIyMy4xMzU4NjM3LTEtDQo+ID4+IHNhcmF0aC5iYWJ1Lm5haWR1LmdhZGRhDQo+ID4+
PiBtOjo0MGFtZC5jb206MWJpbmRpbmdzOm5ldDp4bG54OjoyY2F4aS1ldGhlcm5ldC55YW1sDQo+
ID4+Pg0KPiA+Pj4gQ2hhbmdlcyBpbiBWMzoNCj4gPj4+IDEpIFJldmVydGVkIHJlZyBhbmQgaW50
ZXJydXB0cyBwcm9wZXJ0eSB0byAgc3VwcG9ydCBiYWNrd2FyZA0KPiA+PiBjb21wYXRpYmlsaXR5
Lg0KPiA+Pj4gMikgTW92ZWQgZG1hcyBhbmQgZG1hLW5hbWVzIHByb3BlcnRpZXMgZnJvbSBSZXF1
aXJlZCBwcm9wZXJ0aWVzLg0KPiA+Pj4NCj4gPj4+IENoYW5nZXMgaW4gVjI6DQo+ID4+PiAtIE5v
bmUuDQo+ID4+PiAtLS0NCj4gPj4+ICAuLi4vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQveGxueCxh
eGktZXRoZXJuZXQueWFtbCAgIHwgMTINCj4gPj4gKysrKysrKysrKysrDQo+ID4+PiAgMSBmaWxl
IGNoYW5nZWQsIDEyIGluc2VydGlvbnMoKykNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0DQo+ID4+
PiBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQveGxueCxheGktZXRoZXJu
ZXQueWFtbA0KPiA+Pj4gYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3hs
bngsYXhpLWV0aGVybmV0LnlhbWwNCj4gPj4+IGluZGV4IDgwODQzYzE3NzAyOS4uOWRmYTE5NzZl
MjYwIDEwMDY0NA0KPiA+Pj4gLS0tIGEvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC94bG54LGF4aS1ldGhlcm5ldC55YW1sDQo+ID4+PiArKysgYi9Eb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvbmV0L3hsbngsYXhpLQ0KPiBldGhlcm5ldC55YW1sDQo+ID4+PiBA
QCAtMTIyLDYgKzEyMiwxNiBAQCBwcm9wZXJ0aWVzOg0KPiA+Pj4gICAgICAgIG1vZGVzLCB3aGVy
ZSAicGNzLWhhbmRsZSIgc2hvdWxkIGJlIHVzZWQgdG8gcG9pbnQgdG8gdGhlDQo+ID4+PiBQQ1Mv
UE1BDQo+ID4+IFBIWSwNCj4gPj4+ICAgICAgICBhbmQgInBoeS1oYW5kbGUiIHNob3VsZCBwb2lu
dCB0byBhbiBleHRlcm5hbCBQSFkgaWYgZXhpc3RzLg0KPiA+Pj4NCj4gPj4+ICsgIGRtYXM6DQo+
ID4+PiArICAgIGl0ZW1zOg0KPiA+Pj4gKyAgICAgIC0gZGVzY3JpcHRpb246IFRYIERNQSBDaGFu
bmVsIHBoYW5kbGUgYW5kIERNQSByZXF1ZXN0IGxpbmUNCj4gPj4gbnVtYmVyDQo+ID4+PiArICAg
ICAgLSBkZXNjcmlwdGlvbjogUlggRE1BIENoYW5uZWwgcGhhbmRsZSBhbmQgRE1BIHJlcXVlc3Qg
bGluZQ0KPiA+Pj4gKyBudW1iZXINCj4gPj4+ICsNCj4gPj4+ICsgIGRtYS1uYW1lczoNCj4gPj4+
ICsgICAgaXRlbXM6DQo+ID4+PiArICAgICAgLSBjb25zdDogdHhfY2hhbjANCj4gPj4NCj4gPj4g
dHgNCj4gPj4NCj4gPj4+ICsgICAgICAtIGNvbnN0OiByeF9jaGFuMA0KPiA+Pg0KPiA+PiByeA0K
PiA+DQo+ID4gV2Ugd2FudCB0byBzdXBwb3J0IG1vcmUgY2hhbm5lbHMgaW4gdGhlIGZ1dHVyZSwg
Y3VycmVudGx5IHdlIHN1cHBvcnQNCj4gPiBBWEkgRE1BIHdoaWNoIGhhcyBvbmx5IG9uZSB0eCBh
bmQgcnggY2hhbm5lbC4gSW4gZnV0dXJlIHdlIHdhbnQgdG8NCj4gPiBleHRlbmQgc3VwcG9ydCBm
b3IgbXVsdGljaGFubmVsIERNQSAoTUNETUEpIHdoaWNoIGhhcyAxNiBUWCBhbmQNCj4gPiAxNiBS
WCBjaGFubmVscy4gVG8gdW5pcXVlbHkgaWRlbnRpZnkgZWFjaCBjaGFubmVsLCB3ZSBhcmUgdXNp
bmcgY2hhbg0KPiA+IHN1ZmZpeC4gRGVwZW5kaW5nIG9uIHRoZSB1c2VjYXNlIEFYSSBldGhlcm5l
dCBkcml2ZXIgY2FuIHJlcXVlc3QgYW55DQo+ID4gY29tYmluYXRpb24gb2YgbXVsdGljaGFubmVs
IERNQSAgY2hhbm5lbHMuDQo+ID4NCj4gPiBkbWEtbmFtZXMgPSB0eF9jaGFuMCwgdHhfY2hhbjEs
IHJ4X2NoYW4wLCByeF9jaGFuMTsNCj4gPg0KPiA+IHdpbGwgdXBkYXRlIHRoZSBjb21taXQgbWVz
c2FnZSB3aXRoIHNhbWUuDQo+IA0KPiBJIGV4cGVjdCB0aGUgYmluZGluZyB0byBiZSBjb21wbGV0
ZSwgb3RoZXJ3aXNlIHlvdSBnZXQgY29tbWVudHMgbGlrZSB0aGlzLg0KPiBBZGQgbWlzc2luZyBw
YXJ0cyB0byB0aGUgYmluZGluZyBhbmQgcmVzZW5kLg0KDQpCaW5kaW5nIGlzIGNvbXBsZXRlIGZv
ciBjdXJyZW50IHN1cHBvcnRlZCBETUEgKHNpbmdsZSBjaGFubmVsKS4gIFdlIHdpbGwNCmV4dGVu
ZCB3aGVuIHdlIGFkZCBNQ0RNQS4NCg0KV2Ugd2lsbCBkZXNjcmliZSB0aGUgcmVhc29uIGZvciB1
c2luZyBjaGFubmVsIHN1ZmZpeCBpbiB0aGUgZGVzY3JpcHRpb24gYXMgDQpiZWxvdy4gDQoNCiAg
IGRtYS1uYW1lczoNCiAgICAgIGl0ZW1zOg0KICAgICAgICAtIGNvbnN0OiB0eF9jaGFuMA0KICAg
ICAgICAtIGNvbnN0OiByeF9jaGFuMA0KICAgICBkZXNjcmlwdGlvbjogfA0KICAgICAgICAgICBD
aGFuIHN1ZmZpeCBpcyB1c2VkIGZvciBpZGVudGlmeWluZyBlYWNoIGNoYW5uZWwgdW5pcXVlbHku
DQogICAgICAgICAgIEN1cnJlbnQgRE1BIGhhcyBvbmx5IG9uZSBUeCBhbmQgUnggY2hhbm5lbCBi
dXQgaXQgd2lsbCBiZSANCiAgICAgICAgICAgZXh0ZW5kZWQgdG8gc3VwcG9ydCBmb3IgbXVsdGlj
aGFubmVsIERNQSAoTUNETUEpIHdoaWNoDQogICAgICAgICAgIGhhcyAxNiBUWCBhbmQgMTYgUlgg
Y2hhbm5lbHMuIERlcGVuZGluZyBvbiB0aGUgdXNlY2FzZSBBWEkNCiAgICAgICAgICAgZXRoZXJu
ZXQgZHJpdmVyIGNhbiByZXF1ZXN0IGFueSBjb21iaW5hdGlvbiBvZiBtdWx0aWNoYW5uZWwNCiAg
ICAgICAgICAgRE1BICBjaGFubmVscy4NCg0KVGhhbmtzLA0KU2FyYXRoDQoNCg0KDQo=

