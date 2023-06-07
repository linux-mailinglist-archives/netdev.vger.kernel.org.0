Return-Path: <netdev+bounces-8669-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A1107251E8
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 04:02:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CAE9A28117B
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 02:02:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E930765E;
	Wed,  7 Jun 2023 02:02:45 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD0A37C
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 02:02:45 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2040.outbound.protection.outlook.com [40.107.21.40])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A8E2D3;
	Tue,  6 Jun 2023 19:02:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NDQmpwYz+f/Cf13ZoOTLtSsGpmOVH6eu8FviZAgLcrjYSjl6IH7LeKo4WvoFVBshq+cIe9kENxcpew5yvMdVHxSBGTQSPgNsIUeqdseVtcBT/tIO+OaM7Sh9cDX1jqlJhF3HZTSxQVWrP7pvatk1k+n2l3qG5ky7yymTnPnOC1Eaqty/PCcM8ze7JMKJPBU+G31MzUilOeq/EsZOXJl12V5ptI6s0bzU4GbC7zJ279K/CsCo/I4+nQv2V+XWNONySNi1L1GPGT/QilPVRBR47fMbSrVLi6ADI4GcCO9xrzMIg19BMQ3e4ndu4moZnEdVY21OV7wNo29y4EToNaIGbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HdpEQWUMKWda8/8e8tinbqqzPFpoheAbwrU5LWAoyCs=;
 b=MV6g+hj2KjwkTvDwWNl5ADy86DXH/Gyjy4SGA5HJ9J7QdSS9f8yRRNxKXEUtdWcChcceCauAxggvoG4X9BezpS0j9x2tZZcACj9ys8+jEwIfIX9OT9Ov7nq8dOTslwuLEjJDH1zDEREKgV5AGig929abwJ19vFbLy0/6i0sIIqx7uFuOplruPMF/7CQZiz9nSHn6ZTLSQiM/95CHi7mB7bSAE/ksOjl4lxMRRqQB3qDnvlV4eh7iyVaLiz9VLUww9/4KXZ9x+wjrVdnNps7RdX6eV5zbtFWb2tLZeFR4PlXMAdOaYpbiusCWFmL/YPoTd+VqqQlyVs8KX8+efKA4sQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HdpEQWUMKWda8/8e8tinbqqzPFpoheAbwrU5LWAoyCs=;
 b=iHePGE1e8U3op24eGUrLrxKqKJphYNBGNrTFPQh1q/Pkhq90Qz5kGh0Xi4332r3iCarbvRHh+NCIiejlvi5XTsJH6+iXY//C9+o141NX5wuzFEnBSzQN38ncNPNVEhICxDClSjLbsSYBsDiNFxMbbH69W+Veo5mNZ0dpp8znvqM=
Received: from DB6PR04MB3141.eurprd04.prod.outlook.com (2603:10a6:6:c::21) by
 DB9PR04MB9580.eurprd04.prod.outlook.com (2603:10a6:10:307::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.33; Wed, 7 Jun 2023 02:02:41 +0000
Received: from DB6PR04MB3141.eurprd04.prod.outlook.com
 ([fe80::4fc7:994a:43c9:7058]) by DB6PR04MB3141.eurprd04.prod.outlook.com
 ([fe80::4fc7:994a:43c9:7058%7]) with mapi id 15.20.6455.030; Wed, 7 Jun 2023
 02:02:41 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
CC: Claudiu Manoil <claudiu.manoil@nxp.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: enetc: correct the indexes of highest and 2nd
 highest TCs
Thread-Topic: [PATCH net] net: enetc: correct the indexes of highest and 2nd
 highest TCs
Thread-Index: AQHZmFQUAMDZTouDBkWfpQ3adjlaMK99foGAgAEV8xA=
Date: Wed, 7 Jun 2023 02:02:41 +0000
Message-ID:
 <DB6PR04MB31419A2E70C34BC974EA7F7D8853A@DB6PR04MB3141.eurprd04.prod.outlook.com>
References: <20230606084618.1126471-1-wei.fang@nxp.com>
 <20230606091631.xqof3ponylrpnoo4@skbuf>
In-Reply-To: <20230606091631.xqof3ponylrpnoo4@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB6PR04MB3141:EE_|DB9PR04MB9580:EE_
x-ms-office365-filtering-correlation-id: ff48cc1c-5aa2-4a3c-f65e-08db66fb46bd
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 XwnVza46uRgALI0sz4lzB6FIsgi5YOGMQGgk545SSx6n+vHJomhiCvGcJFfzSmw5s8ywuGwsourF4HCKE2oObub6Fl17va8vV0aDgdRGPK9bj8l5UUAh38lwwWxJE8zI16fL82KX6U2uueqWyIlvQd7ZWLsWenfhOhvzzq79fUkIUUHRQYyPjfshKCyuL8eqaAEKvz0cAgozLG77shTGZSFSVmIlR2ZfWBt6i9fGgBGnyeDcWe9elhGoBWZueQoKSY8Ttui8zK2ZDFO6NhSde8y+wxWE7pF+eOEw7XSLYCUMBa+qGzBUvS2/h8MDB/MvYhJ+L+icB75Bn04RvkBEiUvaQ3nlXgxWvMcyto5KyqJtiax97nT1eKKh0bezVDudyknRzWGsi86f7aVoz6K2UijlpNSFE/wwqDCVtktmlXY/XL6mB78SPZwJbVM6lBUBsFqAl9u/17RLDGPE4K/brQ2DmS0yj5JUNb/w7RBL3yZE5soi4KKdz2z4BWw2wP24SqQ61cW+g3g/WsPhmDy4EVzmox3YJDOLtmjCSi/tIjTu91BakRid7t/AF89tMENZXn5RqZ6e9Eg9DxsjLdww4ex9C9rXN8Vcs7kK8kquuq9+Iw6LJZsNYdx+inRGtG8W
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB6PR04MB3141.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(136003)(396003)(366004)(346002)(39860400002)(451199021)(41300700001)(2906002)(478600001)(38070700005)(83380400001)(53546011)(9686003)(186003)(6506007)(86362001)(26005)(122000001)(38100700002)(33656002)(7696005)(55016003)(71200400001)(5660300002)(52536014)(6636002)(4326008)(316002)(6862004)(8676002)(8936002)(66476007)(66446008)(64756008)(76116006)(66556008)(54906003)(66946007)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?NlRCNVVMSzd4UmZNVnZwWVlqQXkwckZRV2ptT255cHExdDQycERCcXE4d2RY?=
 =?gb2312?B?NHp0RGluNmtnV3lIRDZndW9mcVdHbzJveTM4Q0EwdXlMZHUyWCs5SEg2ZWRh?=
 =?gb2312?B?RWp5YVJhUjRxU2QxMDVYSkFGOFRoVmNlTTlsV2IvNlRSVllFd2lmMEV3RGdY?=
 =?gb2312?B?eHVMcENGQnBLMW1ydEJQTFBHWlZBQ1JpVVlESzZ4L1l0TWFxdnJzV2dKdW9F?=
 =?gb2312?B?ajdPSE5yM3REdWZxb0dzOFFxREpnOGw5OGR4aEhKYXN3aGZqSW93WUtmd25S?=
 =?gb2312?B?ekk5cHhpVWh0cE1ORjZDVldZak1qWm9vTytvbXdXV0ZnQjE1WmdaTEZyY2tY?=
 =?gb2312?B?ZHlaMjdmWmNiSlBUVzhTcTAvV0lmVjFlTGFRZ1cweURmbGJkSFQ3WmN6eWZM?=
 =?gb2312?B?VGhzZ1Y4VndGeWh0TnNxRjBNTFpJWFB5N2hLNGFRMG1kcDNtb25mN3J0UFI0?=
 =?gb2312?B?S2pXZ1Vrd08xZW1aTU84elFDWFN1ZWRZVFpUMEpxKzhuQUF0eUxZSG1PTWZo?=
 =?gb2312?B?aVR3aE8zRWhOKy9CaEQyWjNqOGFyTU4vUFUzU1hGWThvSHdibkhwOW1iT2NP?=
 =?gb2312?B?VGpZbDVYVUtYSkRpdDdUOGxpaVZiMXhYU3Nhb3ZuSUhUS0xvMFk3MWM3Rlpj?=
 =?gb2312?B?SGdsbkxYR3JSNWQwb0V3empzbGNiN2doQTFROS9Fek1oQTE3YnZtckRWbVVN?=
 =?gb2312?B?ZHlGMTZXcnRibm5GckhVdmROQjNYSTlWMUhmK3JENE9VK3BqYVJvMy9SZmtv?=
 =?gb2312?B?N1JtQW51c3dWS3JnQXQ5bGVibzhlK2kySk85STU1RHQ3cWU3N0NtOVZkbFgz?=
 =?gb2312?B?ckd5RWR4a204amlJUnc3eFZrWi9ZVlZlWWIwSEJNWVdQOTNlbEU5eVVBNUdO?=
 =?gb2312?B?a3poVUN1ajh0aDZZOEVVV2sxcXFTMDl3THcvRjVndGoySGlrN0xmTHZ2V04z?=
 =?gb2312?B?ZXdqSGMvUE5SQlYxNi9LM3N1dlBJNUREdGsxN3U1UTNLYzRHR3FJaExLNlN5?=
 =?gb2312?B?N1hhcklscDR6UFFSMUFzcVBYQW40MHNpd0VocnUrOThSek5JdWVXSStwQmFh?=
 =?gb2312?B?K3hUdmswdW1UU2YzUnRQNGt5ZnZNRUxQSE5HVGp6NCtDNnkwTml4cUFMTlBx?=
 =?gb2312?B?dE9xaTNVZk52SGJPdjBTcWMxaWxyMVRMUk1oQXVSUi8zRE4vc1U5SDMyTEJt?=
 =?gb2312?B?cUhOWWllcys0R3pGbWhWOEZCY0hwbDBDSXZXbXc4eHhzMVp0Tkt3SGR2T280?=
 =?gb2312?B?RzZCaEJNSVVMVHduelJTd1ZyclBDTTRXU210aDA2VFJDamg1UXZsMVR4WlhW?=
 =?gb2312?B?bXdXa0h5N1BLY3JSbWJFNFZXZVFWOW1UL3Njc09tbTVYZWJjeFRaL3JRamlB?=
 =?gb2312?B?YldMcUIyclFaeEhsWW9JL3VScEd3a0YvTTIrVGJNWXU4c0tMZ0dDeWY4OFZ0?=
 =?gb2312?B?SmxhMXdsQ0hVSUtVWmI1MC9wZktYQmtsMndtTWdSNmx2TVFjRTBQc3IyV2FY?=
 =?gb2312?B?c1RzNk9uM09ZRWhCNHBGdWtKWC84TDBueHN0SEx4bi9IMG10S09WVUNzWFZX?=
 =?gb2312?B?c2VQWlRQdSs2TVBydkNnYlhCemdpVk5UL3NuaXpFM0czMCthMGpJSURCME5u?=
 =?gb2312?B?NjRnT01oLzI3Z2c2Zzh4Qk9MOWVGUkczKzhJWDVtdTBnQmJWNkhaQTFpcGVQ?=
 =?gb2312?B?UkhFdHpReEUzT2MvN0lFK0tXYkZRUW8yOEhpNFh5cE50aEoxbGloQk9QNDJY?=
 =?gb2312?B?d0FmQjBGKy9PbXlMYW5XUTRyRGRGYWZIMWV2dDhteWoydW1WMXFFSWlQVFFq?=
 =?gb2312?B?Tm4ySVNoQkdla0s2OE40Tks4ZE9QcGs3aDNIVUFIaUo1YkRHSCtSa2REQUJk?=
 =?gb2312?B?QlFRaGE1ZXlMSk0yWUVKcERlVm9qV2hBKzhiRlJkQmtXVUt1SlhqU0t3SUdr?=
 =?gb2312?B?dmVuSDZUWExwWWdIM09SQk1MQi9uWkNseTdEcG5sOVd2eThWc0FiN0FvUllD?=
 =?gb2312?B?VXdZc09ZU1Uray93dnluam1mc1V3VVFmMzFNdTBzdWcya2JHZ2VYQi96Nmx6?=
 =?gb2312?B?RytVVkZLaW1FSWJnWS85SUFhS2Z2cVhobEVKblMzeXZSKysyaGUzR08zRW1L?=
 =?gb2312?Q?Q0WU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB6PR04MB3141.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ff48cc1c-5aa2-4a3c-f65e-08db66fb46bd
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2023 02:02:41.2734
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JzfyLa8vtuV5B+pSMjcRGQk6/+9tLQe0WkR7siIm++d1RDvqiWoL4nM1pkswWl/3ZXXTOMdiJPxuSct6ymTa0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9580
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBWbGFkaW1pciBPbHRlYW4gPHZs
YWRpbWlyLm9sdGVhbkBueHAuY29tPg0KPiBTZW50OiAyMDIzxOo21MI2yNUgMTc6MTcNCj4gVG86
IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogQ2xhdWRpdSBNYW5vaWwgPGNsYXVk
aXUubWFub2lsQG54cC5jb20+OyBkYXZlbUBkYXZlbWxvZnQubmV0Ow0KPiBlZHVtYXpldEBnb29n
bGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOw0KPiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJl
OiBbUEFUQ0ggbmV0XSBuZXQ6IGVuZXRjOiBjb3JyZWN0IHRoZSBpbmRleGVzIG9mIGhpZ2hlc3Qg
YW5kIDJuZA0KPiBoaWdoZXN0IFRDcw0KPiANCj4gT24gVHVlLCBKdW4gMDYsIDIwMjMgYXQgMDQ6
NDY6MThQTSArMDgwMCwgd2VpLmZhbmdAbnhwLmNvbSB3cm90ZToNCj4gPiBGcm9tOiBXZWkgRmFu
ZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPg0KPiA+IEZvciBFTkVUQyBoYXJkd2FyZSwgdGhlIFRD
cyBhcmUgbnVtYmVyZWQgZnJvbSAwIHRvIE4tMSwgd2hlcmUgTg0KPiA+IGlzIHRoZSBudW1iZXIg
b2YgVENzLiBOdW1lcmljYWxseSBoaWdoZXIgVEMgaGFzIGhpZ2hlciBwcmlvcml0eS4NCj4gPiBJ
dCdzIG9idmlvdXMgdGhhdCB0aGUgaGlnaGVzdCBwcmlvcml0eSBUQyBpbmRleCBzaG91bGQgYmUg
Ti0xIGFuZA0KPiA+IHRoZSAybmQgaGlnaGVzdCBwcmlvcml0eSBUQyBpbmRleCBzaG91bGQgYmUg
Ti0yLg0KPiA+IEhvd2V2ZXIsIHRoZSBwcmV2aW91cyBsb2dpYyB1c2VzIG5ldGRldl9nZXRfcHJp
b190Y19tYXAoKSB0byBnZXQNCj4gPiB0aGUgaW5kZXhlcyBvZiBoaWdoZXN0IHByaW9yaXR5IGFu
ZCAybmQgaGlnaGVzdCBwcmlvcml0eSBUQ3MsIGl0DQo+ID4gZG9lcyBub3QgbWFrZSBzZW5zZSBh
bmQgaXMgaW5jb3JyZWN0LiBJdCBtYXkgZ2V0IHdyb25nIGluZGV4ZXMgb2YNCj4gPiB0aGUgdHdv
IFRDcyBhbmQgbWFrZSB0aGUgQ0JTIHVuY29uZmlndXJhYmxlLiBlLmcuDQo+IA0KPiBXZWxsLCB5
b3UgbmVlZCB0byBjb25zaWRlciB0aGF0IHByaW9yIHRvIGNvbW1pdCAxYTM1MzExMWI2ZDQgKCJu
ZXQ6DQo+IGVuZXRjOiBhY3QgdXBvbiB0aGUgcmVxdWVzdGVkIG1xcHJpbyBxdWV1ZSBjb25maWd1
cmF0aW9uIiksIHRoZSBkcml2ZXINCj4gd291bGQgYWx3YXlzIHNldCB1cCBhbiBpZGVudGl0eSBt
YXBwaW5nIGJldHdlZW4gcHJpb3JpdGllcywgdHJhZmZpYw0KPiBjbGFzc2VzLCByaW5ncyBhbmQg
bmV0ZGV2IHF1ZXVlcy4NCj4gDQpJIGFsc28gY29uc2lkZXJlZCB0aGUgc2l0dWF0aW9uIHByaW9y
IHRvIHRoZSBjb21taXQgMWEzNTMxMTFiNmQ0LiBUaGUNCnByb2JsZW0gYWxzbyBleGlzdGVkLg0K
ZS5nLg0KJCB0YyBxZGlzYyBhZGQgZGV2IGVubzAgcm9vdCBoYW5kbGUgMTogbXFwcmlvIG51bV90
YyA4IFwNCgltYXAgMCAxIDIgMyA2IDcgNCA1IHF1ZXVlcyAxQDAgMUAxIFwNCgkJCSAgXiBeIF4g
Xg0KCTFAMiAxQDMgMUA0IDFANSAxQDYgMUA3IGh3IDENClRoZSBkcml2ZXIgd291bGQgZGVlbSB0
aGUgaW5kZXhlcyBvZiB0aGUgdHdvIGhpZ2hlc3QgVENzIGFyZSA1IGFuZCA0LA0KcmF0aGVyIHRo
YW4gNyBhbmQgNi4NCg0KPiBTbywgeWVzLCBnaXZpbmcgYSAidGMiIGFyZ3VtZW50IHRvIG5ldGRl
dl9nZXRfcHJpb190Y19tYXAoKSBpcw0KPiBzZW1hbnRpY2FsbHkgaW5jb3JyZWN0LCBidXQgaXQg
b25seSBzdGFydGVkIGJlaW5nIGEgcHJvYmxlbSB3aGVuIHRoZQ0KPiBpZGVudGl0eSBtYXBwaW5n
IHN0YXJ0ZWQgYmVpbmcgY29uZmlndXJhYmxlLg0KPiANCkluIG15IG9waW5pb24sICJ1bmNvbmZp
Z3VyYWJsZSIgaXMgYWxzbyBhIHByb2JsZW0uDQoNCj4gPiAkIHRjIHFkaXNjIGFkZCBkZXYgZW5v
MCBwYXJlbnQgcm9vdCBoYW5kbGUgMTAwOiBtcXByaW8gbnVtX3RjIDYgXA0KPiA+IAltYXAgMCAw
IDEgMSAyIDMgNCA1IHF1ZXVlcyAxQDAgMUAxIDFAMiAxQDMgMkA0IDJANiBodyAxDQo+ID4gJCB0
YyBxZGlzYyByZXBsYWNlIGRldiBlbm8wIHBhcmVudCAxMDA6NiBjYnMgaWRsZXNsb3BlIDEwMDAw
MCBcDQo+ID4gCXNlbmRzbG9wZSAtOTAwMDAwIGhpY3JlZGl0IDEyIGxvY3JlZGl0IC0xMTMgb2Zm
bG9hZCAxDQo+ID4gJCBFcnJvcjogU3BlY2lmaWVkIGRldmljZSBmYWlsZWQgdG8gc2V0dXAgY2Jz
IGhhcmR3YXJlIG9mZmxvYWQuDQo+ID4gICBeXl5eXg0KPiANCj4gb2suDQo+IA0KPiA+DQo+ID4g
Rml4ZXM6IGM0MzEwNDdjNGVmZSAoImVuZXRjOiBhZGQgc3VwcG9ydCBDcmVkaXQgQmFzZWQgU2hh
cGVyKENCUykgZm9yDQo+IGhhcmR3YXJlIG9mZmxvYWQiKQ0KPiANCj4gSW4gcHJpbmNpcGxlLCB0
aGVyZSBzaG91bGRuJ3QgYmUgYW4gaXNzdWUgd2l0aCBiYWNrcG9ydGluZyB0aGUgZml4IHRoYXQN
Cj4gZmFyICh2NS41KSwgZXZlbiBpZiBpdCBpcyB1bm5lY2Vzc2FyeSBiZXlvbmQgY29tbWl0IDFh
MzUzMTExYjZkNCAodjYuMykuDQo+IElmIHlvdSB3YW50IHRvIHJlc3BpbiB0aGUgcGF0Y2ggdG8g
Y2xhcmlmeSB0aGUgc2l0dWF0aW9uLCBmaW5lLiBJZiBub3QsDQo+IGFsc28gZmluZS4NCj4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+ID4gLS0tDQo+
IA0KPiBSZXZpZXdlZC1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNv
bT4NCg==

