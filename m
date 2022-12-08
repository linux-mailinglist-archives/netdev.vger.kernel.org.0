Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 979D4646974
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 07:53:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiLHGxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 01:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiLHGxV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 01:53:21 -0500
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (mail-dm6nam12on2041.outbound.protection.outlook.com [40.107.243.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D4156F0DF;
        Wed,  7 Dec 2022 22:53:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PVubzhPeGuNslzPPLs7cOkCoAYhUQfdZdgKYxMJxKGJ2huzHpnslm4DS2W6qoLdZLR9hty7WijM4bnmLsj37jiepDmHCI9XxO9hItQRc2hdgxyurpLezhskv7ymzijLaLhp5FASAc+Ag4eQRMU286Njdu97rceyeycNlAqErrTDJJKRe01kaQglRd8cDPePWjyY7PdV1rB7NEhnc9umKKuPSHhDwCCqS1yLwIjBlUk556Z5ZIPeaaNLJESo6PbN1zy5F8fQIqnH812EwK1i6zC22Ore/V6J7Ill1cV05SviqYO31sW9K/eXL2usmjcPj+tJcRafx4ekZutzP5RavbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yuHRfEfKNrZ/c8FNwVhIru3f7DleOoVJI97lzC0P/Sk=;
 b=bV1adsCG2bbDzUgFJP2jyiJ0SFIFZyMjiqcfNUotEPwlk00+El9kcxhg5E2fSy6puj1wMWwTooGlIsWZWgrojAmEWB4z7iNMsvTBJzVI483tshFfFNHb31dWaEs5W6StbNmY6IHvKW+ALAs2SAfN8kaj9JXp35ftCC/4olIp/j/GvmjwtlzLGniwg7MlgwnR0p0/DtZliQtzryPgaLD/fSlWF1lvwejXPPvmChwoPYCVvFQlW7cn6y6dNSC0QkRaB9E3bjjPf8nIoqhlkduKIVs0QPuzBcvYKTdmbVehBoMR2p6YqIxq+8PIPk4ZIrtINF/E+v6tIkpq+cRYVQs+kw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuHRfEfKNrZ/c8FNwVhIru3f7DleOoVJI97lzC0P/Sk=;
 b=dVKxZCnoDOoVs1CUXgEFcNC6wPUVZdU5dysUQmbSJNToxxAFFDYTnYsFUf1r9GFOaDnHs6widwAfHX+ygqiMiJRS5uHZ7YkpDaXrATRV2mQMrfwBA2XfRDUzrL8VEjwdznGCfJYrBgDTEUBTzMCDPH9VplMkTmtvQOYDsIOstl1lgiCvqBjl1GxVwnh8TSFj4q2VBabCwMLVNDcnyBapaLrzmKYl6bvaH61Qt9HyoG9ew4nclqc50dNUnPx9Sq/TrwFAvc4jevpDB1VjHStamZMgpwsuKSMP7wreOYy6lhWOPWzTjAQwlQpFvzQ45ytaJUc4bw0IBAtWpS0+7Uikug==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DM4PR12MB6446.namprd12.prod.outlook.com (2603:10b6:8:be::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.14; Thu, 8 Dec 2022 06:53:18 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%8]) with mapi id 15.20.5880.014; Thu, 8 Dec 2022
 06:53:18 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>
Subject: RE: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v3 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZCiQusL+UzHu/8U2fyvKlL6owS65ikZoAgAAA31CAAGjLgIAAki4g
Date:   Thu, 8 Dec 2022 06:53:18 +0000
Message-ID: <IA1PR12MB6353847AB0BC0B15EFD46953AB1D9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221207101017.533-1-ehakim@nvidia.com> <Y5C1Hifsg3/lJJ8N@hog>
 <IA1PR12MB635345D00CDE8F81721EEC89AB1A9@IA1PR12MB6353.namprd12.prod.outlook.com>
 <Y5ENwSv4Q+A4O6lG@hog>
In-Reply-To: <Y5ENwSv4Q+A4O6lG@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DM4PR12MB6446:EE_
x-ms-office365-filtering-correlation-id: 7191494e-d568-4249-cda7-08dad8e8e370
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7qsPmge6344z58lgdrxmAxiYqsW6YjVdncubU5+o/soxebMni7BmgMe6ukEIj+OMnEGA8P8yguTfP198mvzQLq62EBUVTlCfnY6cAqtueMHJ1DpWw+XW7/r0JsTTaQrVwxnqhdrCYq261n0y8pRlS4L3moFRvumS1AaCuwmGb+p3P4kWeMalSyPy8np7UgFjPJ5yMzAfpFKbQIoG2fZRRzutRJ1yapDskw9tZuJavfFEAvOQQt8PW5XcQIqayd0He4rh7PqS2U8jo6Svg2jqQElM4Ih1EpiKSowg+Chk9ZfcOIwVylreSvKh9IIq69UJ4OdJfjzJbXBVL13ELyCPl+ar7BmMdoUxNrozpXprdOf8LvFGqf59KW03x0dsOU5KUG+Hx3YoBXQBeYF6QnhFl4wafs5wd5THR0csFzBNSicCqjTvK7VcK72uy/puRJ3MtCOE9UUFfm218FuJ5+mEdZhlAoxlt8+6liZJfCXNhQPbrDlLxAT8dC4YBjZobXw02FUaevmRHs6x6hxrLUabNoE75+YUxqqB0sCDMYPMLu6Lv/5HA1+aXGisAYwu5yyIZZlrxwiSvWsPxnz903djBEJbTMRnwIBMYGrii3tvN3HMY2idKtDaa1I9S8BOcO6jrsTWpylkp32Ef0/eJVQy67odpKM6ifZi0ep7IKpniPbmI07klaEdA0FeRD0T4qQuJZ5UqMrqaYfgncmzJdI9Xg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(346002)(366004)(39860400002)(376002)(136003)(451199015)(478600001)(6506007)(71200400001)(7696005)(53546011)(33656002)(38070700005)(55016003)(86362001)(8936002)(122000001)(26005)(9686003)(83380400001)(186003)(5660300002)(38100700002)(41300700001)(8676002)(52536014)(66556008)(66946007)(64756008)(54906003)(6916009)(316002)(4326008)(76116006)(2906002)(66446008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUhCbUN4R3ZscE90N3hCN3hNOS9XSEd1S2hKZFNVQjNCd1RJcTZraGRBVkha?=
 =?utf-8?B?KzA3cEJBd3ZBeGZQcGp6WXdBTmdpYXNJVUp5ZDBIcmRsYVVWRG1YODk5c0RO?=
 =?utf-8?B?TWpqY3JZWkVkaUxCQTVUemZ5WXpEVmZKM1NrVzJrUWNNRFpDK0xicVpIQlFQ?=
 =?utf-8?B?WU9Vcy8yem96ME9RbGE2d2IrNjk1RzBoTEpOY3ZzczM5bDBKR3JEcVhlejZz?=
 =?utf-8?B?V3lwSldaa2hPZ0VHRjJ4cGc2a2g3a0tMeDV5RFY4WnMwUmtGN0dnb0JTb2NX?=
 =?utf-8?B?TzRjNXU2YzRFTHQyK2xzWm1WNEh1L0dJWTlrL3hCbjVRenhBVTRGUkxBSk1D?=
 =?utf-8?B?VlEzZ1VweTBUdmVGSVF6MWxzSXJHWDZJaTFhaDBpV1NnTkVvcWFHRCtLNUFY?=
 =?utf-8?B?VU9kaGNIek5xVU4xK3drdW5ZcjlYckd3VzJzMkdjemFNaXgzd1lUY0lDM0dQ?=
 =?utf-8?B?MndCL2h6Z1FFR2JpM29ORjBVMFd6NGhFeVZ5NWx5ZHFGUllkWWV1ZFBSUTRL?=
 =?utf-8?B?eHdiQ2tURFZSTEJ5Z2p6U29LMzcwaGxCcms1S3RRa2o0VVFuei9VTTBXUUFq?=
 =?utf-8?B?Znl1dmlkR0tMb3Y4T0N2YmIzc2x5YzdGT0RpTkFmb0kxMVFRamo1aTgwbENE?=
 =?utf-8?B?YzE3TmpWc1BnaWViYkF5ZVhaZFBPRS8zNVpzV1VLdXhjT1ZLWGlxZG41bE5S?=
 =?utf-8?B?RlNFN0s3bFFTK1pZUUZIa3huYjRES0lhdjkxL29VWG5NWTIrM3dDSFdiMENw?=
 =?utf-8?B?UTdVWkpjaGlObml4WVBLS1g0QUlDdUZoemplTG5kR0Fhekd4N2FYVVNsUGth?=
 =?utf-8?B?WGRpdmpuOW1aR0pQZEZPWmVwR1ZvVWlrTkxKY0NOdVNyRWQ2SEk5M0Q1dkFG?=
 =?utf-8?B?T1BnZDR5WlA0RklCSk00UFIycC9KT2FBdVJ3UFN4L0pNd1dIalplaDUvVUc0?=
 =?utf-8?B?aC82ZUJSZ1dUL0xFQkUrVDdidGpuSHh2WEZDb25zLzZBVzFXblRNZlZsczVN?=
 =?utf-8?B?OTExL05LVElrdXFmN1c2QWhRVEhVamdXWXRJcjM5YkVKdmlvVUgrOWtmeFE1?=
 =?utf-8?B?Z3VOYWdSZzEwTU0zTjZBQzczQnBqZnhTdE9oNnFYL05CRmhhWUFNWnNlaFV6?=
 =?utf-8?B?Tlcrc2xjWCtxSitmamRWMXZqQ3NDb0poRGVGTkFGU2gzU3NCQm52bVJQaUZi?=
 =?utf-8?B?clQyUk1OZE5xVXh6a0JlR0p2dnUyNXlUQlhib3NpNWl6YjBZWGM5eGFmdklR?=
 =?utf-8?B?c0tRZ0s1TDZzYSs1QkRtNTJwR1U0QXFpU2dXL0ZSMzhpdzVlanZOYmZueTcx?=
 =?utf-8?B?Z0taaEtZTTNjWmw3WC9yWk96NXJyZHJYNlZiNkxWcUF4bEtjdVo4aTFZM1dP?=
 =?utf-8?B?L1ZqdURodjlFdFVBUU9CSCtkcDVOSjZQcUhnbjNsRERkOGRzSnp6cW0zTnV0?=
 =?utf-8?B?VDJCT1FCejI3NjV0cC9adVM2SzNrV1VPOWJrTjZtQkE5OVB4VlZaZXl1Z1N3?=
 =?utf-8?B?anZSdDlnMExCTmNDbHRnU1VmQmR6QTZ4b2dLdzZmUXJsWVVBM21hRWZkYWpT?=
 =?utf-8?B?R1J1Y2M1NDlUemVpUU0wWUV6cWk4SXBMOWJLWXBRbWVUK1grNjRaT0J1NXF4?=
 =?utf-8?B?RGVsYlFNVEs5ekg1STY5VWtoR29aTThIZlpoMndYYnpsSXB2YzhIMU9Lbmw2?=
 =?utf-8?B?TG9iQndpV3RGZWJEVDRLQzlVMGwvREk3aVJaMHlpbGhObmh2NkRlVm82QnhE?=
 =?utf-8?B?V2xZUk5FNkxra1JhOHYvSWl0ZW1sRFl5eEh4TmJkWWl5OXFjaTNIU1JidTFB?=
 =?utf-8?B?SmMyaW9iQkdMOWZacTY0M1FQV0pxWTNrMlFxOE9vNGl1dmlRMCtuM1ppVjk0?=
 =?utf-8?B?WDVkUWdvK3FweFllcGgyQUNPVURlTUhBVFUreUJLb2svekZudkN6MS9NMzBI?=
 =?utf-8?B?NWV0WkZmNTJHSnBJNU1kMWRicjQvRndUQ25uRkFqR3pQV1JJclZ0MjJaM3JQ?=
 =?utf-8?B?ZmNlRUU1anVqdFAyV0t3NGVKakdWVnVHcitnSW13MEYvUTU5ZnNObzcvdHJG?=
 =?utf-8?B?WVRhSG92M05XZ2tMdnFYVGJrQStVN05UU0Eyd0t0SFVwdWVHN282VUhPaEVW?=
 =?utf-8?Q?Gsn4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7191494e-d568-4249-cda7-08dad8e8e370
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Dec 2022 06:53:18.5710
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jRYUOTSTXkd9WwKp+L+I5h8pqLZRsOJuFERN+lCH57hA5D8zY/Xa0ZDmfJrQdBDimkIzGAKNM9oMh5OYN+hltA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB6446
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2FicmluYSBEdWJyb2Nh
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFRodXJzZGF5LCA4IERlY2VtYmVyIDIwMjIg
MDowNA0KPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogbGludXgt
a2VybmVsQHZnZXIua2VybmVsLm9yZzsgUmFlZCBTYWxlbSA8cmFlZHNAbnZpZGlhLmNvbT47DQo+
IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9y
ZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGF0ZW5hcnRA
a2VybmVsLm9yZzsgamlyaUByZXNudWxsaS51cw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1u
ZXh0IHYzIDEvMl0gbWFjc2VjOiBhZGQgc3VwcG9ydCBmb3INCj4gSUZMQV9NQUNTRUNfT0ZGTE9B
RCBpbiBtYWNzZWNfY2hhbmdlbGluaw0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9u
IG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiAyMDIyLTEyLTA3LCAxNTo1
MjoxNSArMDAwMCwgRW1lZWwgSGFraW0gd3JvdGU6DQo+ID4NCj4gPg0KPiA+ID4gLS0tLS1Pcmln
aW5hbCBNZXNzYWdlLS0tLS0NCj4gPiA+IEZyb206IFNhYnJpbmEgRHVicm9jYSA8c2RAcXVlYXN5
c25haWwubmV0Pg0KPiA+ID4gU2VudDogV2VkbmVzZGF5LCA3IERlY2VtYmVyIDIwMjIgMTc6NDYN
Cj4gPiA+IFRvOiBFbWVlbCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+ID4gPiBDYzogbGlu
dXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgUmFlZCBTYWxlbSA8cmFlZHNAbnZpZGlhLmNvbT47
DQo+ID4gPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtl
cm5lbC5vcmc7DQo+ID4gPiBwYWJlbmlAcmVkaGF0LmNvbTsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgYXRlbmFydEBrZXJuZWwub3JnOw0KPiA+ID4gamlyaUByZXNudWxsaS51cw0KPiA+ID4gU3Vi
amVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MyAxLzJdIG1hY3NlYzogYWRkIHN1cHBvcnQgZm9y
DQo+ID4gPiBJRkxBX01BQ1NFQ19PRkZMT0FEIGluIG1hY3NlY19jaGFuZ2VsaW5rDQo+ID4gPg0K
PiA+ID4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9wZW5pbmcgbGlua3Mgb3IgYXR0YWNo
bWVudHMNCj4gPiA+DQo+ID4gPg0KPiA+ID4gMjAyMi0xMi0wNywgMTI6MTA6MTYgKzAyMDAsIGVo
YWtpbUBudmlkaWEuY29tIHdyb3RlOg0KPiA+ID4gWy4uLl0NCj4gPiA+ID4gK3N0YXRpYyBpbnQg
bWFjc2VjX2NoYW5nZWxpbmtfdXBkX29mZmxvYWQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4g
PiA+ID4gK3N0cnVjdCBubGF0dHIgKmRhdGFbXSkgew0KPiA+ID4gPiArICAgICBlbnVtIG1hY3Nl
Y19vZmZsb2FkIG9mZmxvYWQ7DQo+ID4gPiA+ICsgICAgIHN0cnVjdCBtYWNzZWNfZGV2ICptYWNz
ZWM7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgbWFjc2VjID0gbWFjc2VjX3ByaXYoZGV2KTsN
Cj4gPiA+ID4gKyAgICAgb2ZmbG9hZCA9IG5sYV9nZXRfdTgoZGF0YVtJRkxBX01BQ1NFQ19PRkZM
T0FEXSk7DQo+ID4gPg0KPiA+ID4gQWxsIHRob3NlIGNoZWNrcyBhcmUgYWxzbyBwcmVzZW50IGlu
IG1hY3NlY191cGRfb2ZmbG9hZCwgd2h5IG5vdA0KPiA+ID4gbW92ZSB0aGVtIGludG8gbWFjc2Vj
X3VwZGF0ZV9vZmZsb2FkIGFzIHdlbGw/IChhbmQgdGhlbiB5b3UgZG9uJ3QNCj4gPiA+IHJlYWxs
eSBuZWVkIG1hY3NlY19jaGFuZ2VsaW5rX3VwZF9vZmZsb2FkIGFueW1vcmUpDQo+ID4gPg0KPiA+
DQo+ID4gUmlnaHQsIEkgdGhvdWdodCBhYm91dCBpdCAsIGJ1dCBJIHJlYWxpemVkIHRoYXQgdGhv
c2UgY2hlY2tzIGFyZSBkb25lDQo+ID4gYmVmb3JlIGhvbGRpbmcgdGhlIGxvY2sgaW4gbWFjc2Vj
X3VwZF9vZmZsb2FkIGFuZCBpZiBJIG1vdmUgdGhlbSB0bw0KPiA+IG1hY3NlY191cGRhdGVfb2Zm
bG9hZCBJIHdpbGwgaG9sZCB0aGUgbG9jayBmb3IgYSBsb25nZXIgdGltZSAsIEkgd2FudCB0byBt
aW5pbWl6ZQ0KPiB0aGUgdGltZSBvZiBob2xkaW5nIHRoZSBsb2NrLg0KPiANCj4gVGhvc2UgY291
cGxlIG9mIHRlc3RzIGFyZSBwcm9iYWJseSBsb3N0IGluIHRoZSBub2lzZSBjb21wYXJlZCB0byB3
aGF0DQo+IG1kb19hZGRfc2VjeSBlbmRzIHVwIGRvaW5nLiBJdCBhbHNvIGxvb2tzIGxpa2UgYSBy
YWNlIGNvbmRpdGlvbiBiZXR3ZWVuIHRoZQ0KPiAibWFjc2VjLT5vZmZsb2FkID09IG9mZmxvYWQi
IHRlc3QgaW4gbWFjc2VjX3VwZF9vZmZsb2FkIChvdXRzaWRlIHJ0bmxfbG9jaykgYW5kDQo+IHVw
ZGF0aW5nIG1hY3NlYy0+b2ZmbG9hZCB2aWEgbWFjc2VjX2NoYW5nZWxpbmsgaXMgcG9zc2libGUu
IChDdXJyZW50bHkgd2UgY2FuDQo+IG9ubHkgY2hhbmdlIGl0IHdpdGggbWFjc2VjX3VwZF9vZmZs
b2FkIChjYWxsZWQgdW5kZXIgZ2VubF9sb2NrKSBzbyB0aGVyZSdzIG5vIGlzc3VlDQo+IHVudGls
IHdlIGFkZCB0aGlzIHBhdGNoKQ0KDQpBY2ssIA0Kc28gZ2V0dGluZyByaWQgb2YgbWFjc2VjX2No
YW5nZWxpbmtfdXBkX29mZmxvYWQgYW5kIG1vdmluZyB0aGUgbG9ja2luZyBpbnNpZGUgbWFjc2Vj
X3VwZGF0ZV9vZmZsb2FkDQpzaG91bGQgaGFuZGxlIHRoaXMgaXNzdWUNCg0KPiANCj4gPiA+ID4g
KyAgICAgaWYgKG1hY3NlYy0+b2ZmbG9hZCA9PSBvZmZsb2FkKQ0KPiA+ID4gPiArICAgICAgICAg
ICAgIHJldHVybiAwOw0KPiA+ID4gPiArDQo+ID4gPiA+ICsgICAgIC8qIENoZWNrIGlmIHRoZSBv
ZmZsb2FkaW5nIG1vZGUgaXMgc3VwcG9ydGVkIGJ5IHRoZSB1bmRlcmx5aW5nIGxheWVycyAqLw0K
PiA+ID4gPiArICAgICBpZiAob2ZmbG9hZCAhPSBNQUNTRUNfT0ZGTE9BRF9PRkYgJiYNCj4gPiA+
ID4gKyAgICAgICAgICFtYWNzZWNfY2hlY2tfb2ZmbG9hZChvZmZsb2FkLCBtYWNzZWMpKQ0KPiA+
ID4gPiArICAgICAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiA+ID4gKw0KPiA+ID4g
PiArICAgICAvKiBDaGVjayBpZiB0aGUgbmV0IGRldmljZSBpcyBidXN5LiAqLw0KPiA+ID4gPiAr
ICAgICBpZiAobmV0aWZfcnVubmluZyhkZXYpKQ0KPiA+ID4gPiArICAgICAgICAgICAgIHJldHVy
biAtRUJVU1k7DQo+ID4gPiA+ICsNCj4gPiA+ID4gKyAgICAgcmV0dXJuIG1hY3NlY191cGRhdGVf
b2ZmbG9hZChtYWNzZWMsIG9mZmxvYWQpOyB9DQo+ID4gPiA+ICsNCj4gPiA+DQo+ID4gPiAtLQ0K
PiA+ID4gU2FicmluYQ0KPiA+DQo+IA0KPiAtLQ0KPiBTYWJyaW5hDQoNCg==
