Return-Path: <netdev+bounces-7381-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BDE0171FF78
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 12:37:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6A707281711
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 10:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2AC3FC8C0;
	Fri,  2 Jun 2023 10:37:00 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F8B1363
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 10:37:00 +0000 (UTC)
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2060b.outbound.protection.outlook.com [IPv6:2a01:111:f400:7d00::60b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A833710C4;
	Fri,  2 Jun 2023 03:36:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=U9nXqIBHw9djSsU+JFn3jCszLmaF9YOvlQa2ADUB6+qBeGoLs1HCE8rNpPrCvvZ7drW5i+TxwTLO2hX3XAUARcJHtiGeJOssdZ8pgFFuo9L4NlxPFpf+ZVJUSoSezajC7dJimloUHfJ0lQfJ62Of6F+RcGr8Km6Es0ZVcBdv+yVq0LzQx3IYVpOM3dhr6ytCbDP2p7KwUULPaKJ+y7gtT+22yiQ+n04pBkdokz3hB6d/hbt2dVhoR0vnQ198s00PB3tEh493Lf7vhi5qNUMIEIXdjgOa6TBCIXUPfW484c78CE6ifjvMHEpi5RrBbxEZROgAp1u3tGhBuiTukLy8cw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=L3kA/wtloeSeYgTmTCgtivfSLN2skVQshiPOgGckeIw=;
 b=DGvrajESfmW0ZoqQE6AW5nJx1ftQClWPeR/3BAB4AWKsbQe4AgZ/n5c/mAyRN1/8NEkWlDBTiYNNBaA7bJLVW4/W5w+MoTx8uIZfLXzSBGa6FkoTsBtIwb4hwyDN7iIGrngvokv1UMCOGlcPswyptDYiMfC9yVCmm3goxbYjg3IcarXf/JikdItuMhd9C2TCJsdOyAJm/HOxePaTZr/JNRGl0N+w5gq67qT4y70K5bkDv98neaL4ZQxv+Wf/KKNOutDro7D8Mx5nQRmV/Vg4QyMtJP+gui/dJ2v5Ylszyc9g5bnhuQsfRMEBZRND/ZqDimaomFKlShM3kD0pvrr0zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L3kA/wtloeSeYgTmTCgtivfSLN2skVQshiPOgGckeIw=;
 b=pOfv8b7ZMPgiCxI4ofAeELoBtlgEELvOswFJ5JCBdJF44zfnhszQnXejFZLy8RUnqu4GgyyBXkyC/UcnB+ZRCutcCsp9ZO0stbKJBr7bOULlrQwdhe9iY8mnYH2kzBXvpsSGqG3H6IMWHK+rA0dgsvKlm6bu1VUonfM2rJGOjoc=
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com (2603:10a6:206:8::20)
 by DBBPR04MB7819.eurprd04.prod.outlook.com (2603:10a6:10:1e9::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.24; Fri, 2 Jun
 2023 10:35:53 +0000
Received: from AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2]) by AM5PR04MB3139.eurprd04.prod.outlook.com
 ([fe80::682b:185:581f:7ea2%4]) with mapi id 15.20.6433.018; Fri, 2 Jun 2023
 10:35:53 +0000
From: Wei Fang <wei.fang@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
CC: Claudiu Manoil <claudiu.manoil@nxp.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"kuba@kernel.org" <kuba@kernel.org>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"ast@kernel.org" <ast@kernel.org>, "daniel@iogearbox.net"
	<daniel@iogearbox.net>, "hawk@kernel.org" <hawk@kernel.org>,
	"john.fastabend@gmail.com" <john.fastabend@gmail.com>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] net: enetc: correct the statistics of rx bytes
Thread-Topic: [PATCH net 1/2] net: enetc: correct the statistics of rx bytes
Thread-Index: AQHZlTffhwfuU54qiEe0/Kj0J7gVa693UGgAgAAAIZA=
Date: Fri, 2 Jun 2023 10:35:53 +0000
Message-ID:
 <AM5PR04MB3139F0649E36BB4AB25B0B80884EA@AM5PR04MB3139.eurprd04.prod.outlook.com>
References: <20230602094659.965523-1-wei.fang@nxp.com>
 <20230602094659.965523-2-wei.fang@nxp.com>
 <20230602103142.ryesgb7ykamtzxnx@skbuf>
In-Reply-To: <20230602103142.ryesgb7ykamtzxnx@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM5PR04MB3139:EE_|DBBPR04MB7819:EE_
x-ms-office365-filtering-correlation-id: 5fa25987-e203-4c07-88dc-08db63552424
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 rB9aIR/6UDt6QYhRXihiXzF09+s3I0NjLWSX/xTDmA2QF1SY3Z+APgWMr11xYfIKzrtNH5yAXU8e/eDSeKdb2RbutXd1QJodY7fr9McRIxvRXg9U1qXBMckks1S5DtQk1PaQvDigvN7CRj5QSoA8NuoNMYg3n6xLwDWG+HxfAEeZDH1efWtiWNW+0kKFf/EyE+K0850qPI4Fr7fGEJLGIe0M33bJVvJihyl61+P5ZlhOaCHCGe3P6sZvYxfi+uLl0SrlD5vmWT+fIRpDvXxI1NOmjGy/kLAalpJWccVPEN5G+aF5Hui6CX+yq2s6cdz5UqNSf1GDDBFzeOPspDs/KsTsSt4Su5CKD+5izo2Uh+IjTEnz+IOZjb67DyRZXIKHanKLwf4XfYbupm+B/ss6vsTZss7Wc27nh1NX4oaggevSZdVCwRPYB+QMOfHyIr2FxxqqxamDpZp8iP0ny45We1l2iD39Lts8f5iErDhd3ilEDu2F9nfw7+/n1KHxCjDsyAQyhkVKTl6qganWNFdIjNeSjA0qtQqjEPIwk7LTOHyuzsvJg+Vr96DXDA8oXYNa3rOU0nu/b8vxZ3AnTD6Pw5XGj1u84Gbw1cL3xjXyvKM7IwuBC0QwB2AkvWL57dQp
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM5PR04MB3139.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199021)(6506007)(53546011)(9686003)(86362001)(186003)(66946007)(66556008)(66476007)(66446008)(64756008)(4326008)(7416002)(38070700005)(6636002)(33656002)(5660300002)(52536014)(8936002)(8676002)(478600001)(6862004)(83380400001)(2906002)(76116006)(7696005)(38100700002)(44832011)(122000001)(316002)(54906003)(41300700001)(26005)(55016003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?gb2312?B?N1FnNFpjdk4wRk1JK1BGWWI1cTNRTHVDNFp2Nk8yTWZPQVQwdEpOL0xWQXNm?=
 =?gb2312?B?OTg5aEdDUzNaU2J1TzBybjBhVEMzVE16dUNDTWVBcFNCNEkranB3NnJQWFJQ?=
 =?gb2312?B?ZzFIOWdyOFYvWFB3NGxhN0FYZ1FNaDVwQ1cyOHVHL2pjcll4RkhFMHRIaStO?=
 =?gb2312?B?VHFockl0cDErZ2RCQ09NRjVJTGVVYXVzN1hLQ21PeFRMR2RDVFlKWCtKZ05H?=
 =?gb2312?B?OEdUVWZEOVZLTkx5WjU3a3VUUVR4UzBqQjI0Z1dnYnYwZ3FuTEhheVFUVWZv?=
 =?gb2312?B?QTQ4R2llalNmMmZuN3hzM2w4OGJNTzJDMWFDeERxS25UNWFlSmxlKzVUd1Nk?=
 =?gb2312?B?Y2hpWDJ4QTVmbWpLZHVaLzRFUVpNOVdyK1BZRFJ2UUVxdWhtbUNYR1ppNnRj?=
 =?gb2312?B?RjhZSnhETGFFNnpiZjA2cnJqQnRQSHdmTnF0YVA0VFdRZlJ1UGJQQXhjREFV?=
 =?gb2312?B?T1pBUU5oSVhKbTViSkJlOURndk9KSE8xTmcwSXBVQWhCajNPcWIvYXJHT2c4?=
 =?gb2312?B?ZmJreXJtNWZHUHVyU3lCVHlqQTcvaHQ0UkQ0ek5obSs5K1h1czF1SXNCQTg2?=
 =?gb2312?B?eEZ3TWNrQ3BhSDdpdEJvRzM5c21HellFdHlnenl5aUUzSWcraTArWnVyaDEr?=
 =?gb2312?B?NXF3dFVicWVaNlpIUDNBNHpWZDdmNWdxalZ0Rm9wSWlNQjhHUzB3bUFEUU4w?=
 =?gb2312?B?QkVZbTRISExzbmdCb3lsbmx0OVRmeld1bHcrMEMvelFxUWpHeVU0RmlNRGlo?=
 =?gb2312?B?dzQvVUpjc1hZMEJDZXE5ZHpDcjBHQkppWTZMdWZ2blJ5QkhXaXhReXJYdkg5?=
 =?gb2312?B?OTdqbmJ2dGhOV1Z0K2tYWHZ1MXE5Wm4wSEhnQytVdDRrLytGbkx4SUtrRzc3?=
 =?gb2312?B?cm0zWlZ4RVRHNnBuRjlwd1hUa0hSYVZ0NFA5cG9oTnFMNkZQNjFCcTdudGVD?=
 =?gb2312?B?czQxUWpkY3h5UExzcmpjUmdQaFFsZUJOVWdZMjdObGJlWHJjRkdtTytDbHRv?=
 =?gb2312?B?bjNIK0o5VDIxQXl0K013VXlSZVdkajh3end1a3hWb1QvZXhGQkNqMlZTL2tQ?=
 =?gb2312?B?UUFaNElvdEEyWXc3d0dua2Y5TVB4Y3FOMkUwb3B6aXRCZk00VDZBaWdJS3h4?=
 =?gb2312?B?L2hjT3hXckc5T1R6RGI1VUw3WmNMc2lzSDZFNjBWVit4ZGEwNGJqZDV3Smh1?=
 =?gb2312?B?NzcrSi80S2JFRjZzR2E2dzEvSFoxVVg4aEN0UkxlZEZhbnhWdUt4ejhES2VI?=
 =?gb2312?B?VzJaYTFTQXdWRFBBakJoRHE2WEd3VTJkK0twRXlCdW5McndPVS9KWjh2Z0dV?=
 =?gb2312?B?dG90UnhrTHpnTVE3Ymhqd2d5UTh0Y1oyeVh6dS9GRG0zTGcvcmxORHF0R05w?=
 =?gb2312?B?SjFheTdMWHhmc0RyVjIyUjJKemY4SUNDVDJwRTU0anNTWktjaVdSZmh3UXhX?=
 =?gb2312?B?NEZpeEE1Qm9kcTRPT0F1NXl5bmxROUhKaCtLcjc3TXo5Q2lZLzNUL3ptOWIx?=
 =?gb2312?B?TUtlU0Fnck9tSkNncGwxLzFwTFlZTWc2OG12WXVWcUIraGR2MUR6S3U2Mk1V?=
 =?gb2312?B?aFNzUitnQnEyWk1Xdk9MWnFTSmtEV242MFZaUEN5RFFWdVpkSElTcVl2WXg3?=
 =?gb2312?B?ZnQrNGo3S0pGd3I4MnBRWDVKZlJEVGFoYWZiR2J3ZEM2Q1gvS21pUlgyc25F?=
 =?gb2312?B?NkJjZGhOSTlDL2FERnV4ZHlxQjBYUVprV2pRVzNHbUJIV2xGY1pVK1JGUDNP?=
 =?gb2312?B?bStaRUtteEJxQjhrclg4ZVMwVFBjYWYzZzFLUEFiOVR3NHhiY3NaRklxZks5?=
 =?gb2312?B?N0k3NXNleGJ5T2xWN1NhcVpFUUw5L2ZrMGt6WXJ3aG84YXVLdEZtMTg5a1pI?=
 =?gb2312?B?TmVGL3FISjdrTmVwS0NzZ2Z4dWkzeGMzMGFqVnpCMEJqK09ranpOTG5LdHNp?=
 =?gb2312?B?Tmk5Z3NGWVpiYzJNTEpVcVd1SnAzSTVmNG9JaS9oWGRzVERtTG0yTXMyVENF?=
 =?gb2312?B?K1JOVjJKbnZMcW82czFFdGVLSUI3TmNqTDE3SVVtQUxPNWg0T0FJenBaT3VQ?=
 =?gb2312?B?amJhSzczUzJoVGxqT0kvcEdsM2FoSFkwanE3U29iNU1EWjBHQjRXMjdkM2lB?=
 =?gb2312?Q?VndY=3D?=
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
X-MS-Exchange-CrossTenant-AuthSource: AM5PR04MB3139.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fa25987-e203-4c07-88dc-08db63552424
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2023 10:35:53.2273
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: u8aMA/tPa4BGt+jEvaFEFmNy5gbIwIDklzQiJVywFlYz4J/nAzuHNo74hy4T3Y8vLhbZzc/UyeE8YpDqFsGfNg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBBPR04MB7819
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
	RCVD_IN_DNSWL_NONE,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFZsYWRpbWlyIE9sdGVhbiA8
dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+IFNlbnQ6IDIwMjPE6jbUwjLI1SAxODozMg0KPiBU
bzogV2VpIEZhbmcgPHdlaS5mYW5nQG54cC5jb20+DQo+IENjOiBDbGF1ZGl1IE1hbm9pbCA8Y2xh
dWRpdS5tYW5vaWxAbnhwLmNvbT47IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdv
b2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207DQo+IGFzdEBrZXJu
ZWwub3JnOyBkYW5pZWxAaW9nZWFyYm94Lm5ldDsgaGF3a0BrZXJuZWwub3JnOw0KPiBqb2huLmZh
c3RhYmVuZEBnbWFpbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IGxpbnV4LWtlcm5l
bEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQgMS8yXSBuZXQ6IGVu
ZXRjOiBjb3JyZWN0IHRoZSBzdGF0aXN0aWNzIG9mIHJ4IGJ5dGVzDQo+IA0KPiBPbiBGcmksIEp1
biAwMiwgMjAyMyBhdCAwNTo0Njo1OFBNICswODAwLCB3ZWkuZmFuZ0BueHAuY29tIHdyb3RlOg0K
PiA+IEZyb206IFdlaSBGYW5nIDx3ZWkuZmFuZ0BueHAuY29tPg0KPiA+DQo+ID4gVGhlIHJ4X2J5
dGVzIG9mIHN0cnVjdCBuZXRfZGV2aWNlX3N0YXRzIHNob3VsZCBjb3VudCB0aGUgbGVuZ3RoIG9m
DQo+ID4gZXRoZXJuZXQgZnJhbWVzIGV4Y2x1ZGluZyB0aGUgRkNTLiBIb3dldmVyLCB0aGVyZSBh
cmUgdHdvIHByb2JsZW1zDQo+ID4gd2l0aCB0aGUgcnhfYnl0ZXMgc3RhdGlzdGljcyBvZiB0aGUg
Y3VycmVudCBlbmV0YyBkcml2ZXIuIG9uZSBpcyB0aGF0DQo+ID4gdGhlIGxlbmd0aCBvZiBWTEFO
IGhlYWRlciBpcyBub3QgY291bnRlZCBpZiB0aGUgVkxBTiBleHRyYWN0aW9uDQo+ID4gZmVhdHVy
ZSBpcyBlbmFibGVkLiBUaGUgb3RoZXIgaXMgdGhhdCB0aGUgbGVuZ3RoIG9mIEwyIGhlYWRlciBp
cyBub3QNCj4gPiBjb3VudGVkLCBiZWNhdXNlIGV0aF90eXBlX3RyYW5zKCkgaXMgaW52b2tlZCBi
ZWZvcmUgdXBkYXRpbmcgcnhfYnl0ZXMNCj4gPiB3aGljaCB3aWxsIHN1YnRyYWN0IHRoZSBsZW5n
dGggb2YgTDIgaGVhZGVyIGZyb20gc2tiLT5sZW4uDQo+ID4gQlRXLCB0aGUgcnhfYnl0ZXMgc3Rh
dGlzdGljcyBvZiBYRFAgcGF0aCBhbHNvIGhhdmUgc2ltaWxhciBwcm9ibGVtLCBJDQo+ID4gd2ls
bCBmaXggaXQgaW4gYW5vdGhlciBwYXRjaC4NCj4gPg0KPiA+IEZpeGVzOiBhODAwYWJkM2VjYjkg
KCJuZXQ6IGVuZXRjOiBtb3ZlIHNrYiBjcmVhdGlvbiBpbnRvDQo+ID4gZW5ldGNfYnVpbGRfc2ti
IikNCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFuZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gPiAt
LS0NCj4gDQo+IFJldmlld2VkLWJ5OiBWbGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBu
eHAuY29tPg0KPiANCj4gQnkgdGhlIHdheSwgeW91IG1hbmdsZWQgSmFrdWIncyBlbWFpbCAoa3Vi
YUBrZXJuZWwub3IpIC0gSSd2ZSBmaXhlZCBpdCB1cC4NCg0KWWVzLCBJIHJlYWxpemVkIHRoaXMg
YWZ0ZXIgc2VuZGluZyB0aGUgZW1haWwuIFRoYW5rIHlvdSBzbyBtdWNoIQ0K

