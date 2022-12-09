Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B02796481AE
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 12:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbiLIL3H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 06:29:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230051AbiLIL2r (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 06:28:47 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF0F750B0
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 03:28:36 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VKz7uRrqlchEb6qLMQYtHeJzSKVtQpeT3ChD2IAyl/oYhE4cVaQanAdo15RMl24u2u7g1H0sJjqpE/8auIZGt4O4cOw8ZjY4iXhZpIm94y3a4et3DHi8cOWzKyXK5p1mCpZqix40ZmdfpkNle2+rIaTGgekFYTTq7AzUSEetpgV/oHT0QgNi1r+uWYuqgtepMhGXTTbLRPNsORDqb5Z5pLY33P1hvDQcjROn9sT0YT4S1AHNOh05QcvunQP3vDXPND67KxxycKMVY7HRaBG/E/MnPzrOn9yBrdLpaYIeImcTiBN1/UR3q9GPKqLB27udNagO/THTGKfZHJCPVVs+Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zo9F9XVpaSgwlRgMgraOgjfFKbQlbKUbh9pG6svj0x4=;
 b=elAnXDPnJGSUaTAJj9o4qT/E6Mm8iNW3NpQjvMWRep1ecSIynUX5MBDtpJCmqLlRPE0JJsl51uUnvN5aCHDCLe+cww6/eNmEvULT6ijOUu2EVjHD9N7jpJA0JNA0fD7KBu+GTs6b7ohRApgqAumU189evF6KmXxYtAZnk3Gb78PdPVli38v1CBV9cUFgE5EYRXo6+eQPxyLak/yQufXdLLKPAEW3ep3MZjtf1ze7bay3P7B4fIjnri6NB/KNDkCH9jXmDQ85qiiIPv6WbT5hOo/INmlOyEYi/RiZIxKLhYX8woJyBFOFs1YjRad1EzlcOqSGopq1CtIe1cV/TuOmBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zo9F9XVpaSgwlRgMgraOgjfFKbQlbKUbh9pG6svj0x4=;
 b=k2LXPAStNS6hIL1DV1UmoNV0Aj7KQfioWvuts3WIq7w8JmDFyPNMEPmK58VXSM87diYcjAhboPW+D1uGEB0i2p9uGyCF5fUmf30WXEvAjcHGMPaJ1JKC5R3AEZgQ+MdQEqUzrobOyrsTnCtwIXWi63LaFCJ8j9OxBcxB2iHZQvpbo6yhC5+mtOcZEosbbSp7bCl5ZZM1o5cfNsbJWq8zlKp8CzxyzaZlFK6W4qwva+wVwlGJ202FZ0Qwd/wfYjc1Nr0MWBrKDtefcZdfo1e4Kfx0VNxj2Y3uCuKgQIpVHgVUbHGCa1Uc/WXSbv8Jjwx3SGpvNdD+gTaJNm1wqVW6DQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by SA0PR12MB4510.namprd12.prod.outlook.com (2603:10b6:806:94::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.16; Fri, 9 Dec
 2022 11:28:35 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::349c:7f4b:b5a3:fc19%8]) with mapi id 15.20.5880.014; Fri, 9 Dec 2022
 11:28:35 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "atenart@kernel.org" <atenart@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next v5 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Topic: [PATCH net-next v5 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Thread-Index: AQHZC7lvXo/YNcB2Y0OJYmqLpVjNs65laBSAgAADIUA=
Date:   Fri, 9 Dec 2022 11:28:35 +0000
Message-ID: <IA1PR12MB6353E45425F721CFB8CE1F72AB1C9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221209103108.16858-1-ehakim@nvidia.com>
 <Y5MZL5fv2OgVXgtw@nanopsycho>
In-Reply-To: <Y5MZL5fv2OgVXgtw@nanopsycho>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|SA0PR12MB4510:EE_
x-ms-office365-filtering-correlation-id: 7098c395-e47a-4521-7072-08dad9d88276
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: X1GNFC4FGGbfg3hHPWs6DMzaB1Fq6USL8tw3VgVtmlPFksdRFKQufCqVZgiTvR8opksvP5asTZf6yEheJ/IGLraaF8bJmHn+03Qi5RFz0vX3cPjWSWkgUnUm+j2cF3n/j+RhLTgVdHQjO2Vd02woPiosUMWvBQdLnXNCxauxrOGAW4kPobNFt0hzQW3koF72jJGDrr/0M68MjOMgXrBI2oW7WMx8mkYjqg5PLvk07xRCyg0/CnI/wptlZebNbH2enXrxa38vmvwpzf68y9aXMFim+7JTCFwONscmjLOte8TcEyC0Yc/M7sA+cIRGXppiUZ0IDmdMrhoGJ67PIgRHpevkyU/PUROxMXf9ZXkV+EgBNBa9SNTdulvzH9GisZr7BTvclbXaABBK0SXs6NktC5E5JPz8RPdP7RyJQgEIJHlC5PkqmXURQlVG80yL5OVkj3xGhITxl9ODbIwnqTYnxm4BAiOzxKR16arvJENoD0yURY6if8WYOYbwj7mk9muEfFZiNW154DsGL7W56fGK23sP2NVi9YUkiq4+Y7h/5cJHDZXCkUnN9WWw5wjezy2F1iWmiEE7I7dROP6RmuTYRLa/HNRuTYXy8ey2b2zdq1/hpPOl9vcTpef2ikuEAfGQUgnFkZBDLvxcdD9OJ9sJIA5RGe0DyPrl2Jk09PuKPhjASNePIWqTGj7FQ36qmbNB27o5k+8wpepyuYd0vK0Ozw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(396003)(366004)(346002)(376002)(39860400002)(451199015)(478600001)(6506007)(53546011)(107886003)(7696005)(71200400001)(38100700002)(66556008)(9686003)(122000001)(41300700001)(6916009)(83380400001)(26005)(186003)(54906003)(66476007)(8676002)(66446008)(4326008)(64756008)(316002)(33656002)(76116006)(66946007)(38070700005)(5660300002)(55016003)(86362001)(2906002)(52536014)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dFVQbTcyT2M0SWtXYkdKU3h0MENrUlpQU0crZlR0NzRiR25BdWl5dWdHMm80?=
 =?utf-8?B?RklpbWxDblRFV1hZTnA2RUNVd0s3bEVWSm9QMThZUFhrY0ZBK1BUZVZycXJp?=
 =?utf-8?B?NmpYcVIyUm14MGR6ZFNSZUpPU3NZUzRSV1ExYmp1WmxaNlBzVUF0WDRDZ1Qz?=
 =?utf-8?B?SDJyRURLVlNsRHVURUhqTDM2eDJRWld1WTBIREVhVWh2TzYyeEpuSzJna2Mx?=
 =?utf-8?B?VFRCNlJqOU5kaUVxY1ZhYnhldk1Qam1uWFljUW5TT3RnR0VYMERLK1MraFFL?=
 =?utf-8?B?dVRKakwwZ1V3ZGVMcWF1dzA0UWJYMFpWNFNKN1JBTjBSV2dHMGlUTGUvTVkr?=
 =?utf-8?B?ZkxranA2WHI4c3VGU1R6UEtPSWdJNXZxWGhMN3FRK2xHbWNsU29sSXdnZExX?=
 =?utf-8?B?dXB3eC9ERHB5TlZ4VXVlRVp5VWdPKzlxNnZHaDJSWDJRV0FCZ0MrZDIvRnli?=
 =?utf-8?B?cHBlNTRLT3dXdmxXUGZsTFNVT0ZlbmphaUZkOXJ5dGcrc0xOMnhSbG14Y0Vv?=
 =?utf-8?B?MVZkSUdqd2Z6MjQrVFZLSkNPUWxKT01SN2liOVV1RUM5MGJiNElBQkdPLzlK?=
 =?utf-8?B?UU1GK2hkc3BVSTUvR3RLdTk2MUpXcVVPbTdlMHNlWllLUE8zR2lSblg0NlBV?=
 =?utf-8?B?Umx6VzMvVExyYVBGdUt2QWZqV2pCRUR4bTZtNGxwMnpwUUJSYTJlclNVZy9x?=
 =?utf-8?B?M05Wbm1idFQ0dlNwU1dHQ1NZOTBRcktOWC9BY3I1dXV4UU1Ya1pnQkFTQnFJ?=
 =?utf-8?B?VTduMDRZa2RrUStBYi9Gb2JGVGEwWjFrZzdObXNJc0FWYzRvYkpzVE01UDNv?=
 =?utf-8?B?OTRyTCsrMUpFYzVSY1JYMytPSW5IRERwYWI5OWk4VlQzQmdYN3NiNEVSL1oy?=
 =?utf-8?B?MlNoWG1CanFaM1dHcHhyY2lEMkNoMjJvdmZoSWMxVVRhNy84SDBGRHpDb2hX?=
 =?utf-8?B?TllpbkRuK2ZvNk1JU0tkU1p3MGdoYkVCWHd3NzRyNFJjTzFJQnp2QWNtMmM4?=
 =?utf-8?B?dTRhbm83ci9EWVA4VE5waHJ5SnA2ME5HVytEUTVWU043dzRudFFxSDMzK3Fi?=
 =?utf-8?B?ajZqZlh2UHQrbU1vaDNZR094bys5STh6YkJkK3NEd0d2RDBUSXNSZksrL2Rn?=
 =?utf-8?B?N2EzMTc0bFIvR01qVzJpTkdGSlQyaGJjMmRtdkVaOXg5T2tUS090dmZuVWU4?=
 =?utf-8?B?WkF5WXJEUGVJWFdOUUxGYTZjTWxvMW9UbGN1RTJEOXhoQ3RyVjRqZXdJS3R4?=
 =?utf-8?B?bE9wR3Vjb05BNXppNkZhZHNBUmVPTTBOS1BNcUkyQ0IxaS9PKzJUY25sZE4z?=
 =?utf-8?B?MHFLQzVEMjM1bTBJNHRwVytvVlRSSm1GclN2R2FQOHFIZm1LTmpYMlZVZDBk?=
 =?utf-8?B?QjROZko0dTU0YnpXUG50V0xrbjlFbzNadVp5ZWxaa1BMU3l5RlFGOHFVNGQw?=
 =?utf-8?B?bUU4OUFhNStzc1FQcnpGRTlGMDA5M1pMdi9VTHhONlRXbkJ6VHlIQmtla3V0?=
 =?utf-8?B?TWFLS1NsYW4vb3ZSZXR3Ymg1clppV2hRSUcxM1E5N1dSYUFCMWpPeXVhUXhH?=
 =?utf-8?B?eG14KzFvbWVhWG16SmR1amVsSjcwR1BIcURWTld1bFdrSlRXVjZsK2pGejFy?=
 =?utf-8?B?RWNSVXVaL3BVNUFoZjEyL1kvciszR2pSZmhPa0tFTm1HMXF3QjI0NjM3WnpS?=
 =?utf-8?B?QjArSXJZNFkvRTB6VEU1MDdxeERsZlZOWGRlWFNxdTNaV2pwUU5oVkRPTnJX?=
 =?utf-8?B?K0pPS3FnY2lNMGQ0V2l4WFM3ZkttVDMrdmFXM1VMSDNUU0dXUmQveE0xSVd1?=
 =?utf-8?B?eDJ2L09MaTRXajBIRFpKN2dkcDBNbkpiSXphd3NSQTVkczZTOW41R3U0SzZP?=
 =?utf-8?B?SXhQb1pGWTgyRG1CcHlkcUY5bnFiMW13VVE3NE5MYWFGZi9obFlWNjhwVkJu?=
 =?utf-8?B?KzExLzVGa1BkcFI2YlJWUXJVSjFnclp1UGJGeDZvemZjTDdDMDRHUi9lMER6?=
 =?utf-8?B?K28vemM1RGxyMEJXMEt2UTBNYUF3a0p0Sk4yRlR6TDF4Q21tM3RpeC9qdmJt?=
 =?utf-8?B?dmVHL1g2aVg5UDVLV0hONlpaak9FSUVHemlndnlhZ3pMUEpaWGxlTzRhMkZn?=
 =?utf-8?Q?gq8Y=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7098c395-e47a-4521-7072-08dad9d88276
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Dec 2022 11:28:35.0685
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: UvDoqFPhV40tzAKp1WUSOq5yq1EJfkMkiJTY3+XNvQljNYxIX/53w8lZL9vEp7yXjhNsJZ0XObeZkteDPBLHUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4510
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSmlyaSBQaXJrbyA8amly
aUByZXNudWxsaS51cz4NCj4gU2VudDogRnJpZGF5LCA5IERlY2VtYmVyIDIwMjIgMTM6MTcNCj4g
VG86IEVtZWVsIEhha2ltIDxlaGFraW1AbnZpZGlhLmNvbT4NCj4gQ2M6IG5ldGRldkB2Z2VyLmtl
cm5lbC5vcmc7IFJhZWQgU2FsZW0gPHJhZWRzQG52aWRpYS5jb20+Ow0KPiBkYXZlbUBkYXZlbWxv
ZnQubmV0OyBlZHVtYXpldEBnb29nbGUuY29tOyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUBy
ZWRoYXQuY29tOyBzZEBxdWVhc3lzbmFpbC5uZXQ7IGF0ZW5hcnRAa2VybmVsLm9yZzsgSmlyaSBQ
aXJrbw0KPiA8amlyaUBudmlkaWEuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0
IHY1IDEvMl0gbWFjc2VjOiBhZGQgc3VwcG9ydCBmb3INCj4gSUZMQV9NQUNTRUNfT0ZGTE9BRCBp
biBtYWNzZWNfY2hhbmdlbGluaw0KPiANCj4gRXh0ZXJuYWwgZW1haWw6IFVzZSBjYXV0aW9uIG9w
ZW5pbmcgbGlua3Mgb3IgYXR0YWNobWVudHMNCj4gDQo+IA0KPiBGcmksIERlYyAwOSwgMjAyMiBh
dCAxMTozMTowOEFNIENFVCwgZWhha2ltQG52aWRpYS5jb20gd3JvdGU6DQo+ID5Gcm9tOiBFbWVl
bCBIYWtpbSA8ZWhha2ltQG52aWRpYS5jb20+DQo+ID4NCj4gPkFkZCBzdXBwb3J0IGZvciBjaGFu
Z2luZyBNYWNzZWMgb2ZmbG9hZCBzZWxlY3Rpb24gdGhyb3VnaCB0aGUgbmV0bGluaw0KPiA+bGF5
ZXIgYnkgaW1wbGVtZW50aW5nIHRoZSByZWxldmFudCBjaGFuZ2VzIGluIG1hY3NlY19jaGFuZ2Vs
aW5rLg0KPiA+DQo+ID5TaW5jZSB0aGUgaGFuZGxpbmcgaW4gbWFjc2VjX2NoYW5nZWxpbmsgaXMg
c2ltaWxhciB0bw0KPiA+bWFjc2VjX3VwZF9vZmZsb2FkLCB1cGRhdGUgbWFjc2VjX3VwZF9vZmZs
b2FkIHRvIHVzZSBhIGNvbW1vbiBoZWxwZXINCj4gPmZ1bmN0aW9uIHRvIGF2b2lkIGR1cGxpY2F0
aW9uLg0KPiA+DQo+ID5FeGFtcGxlIGZvciBzZXR0aW5nIG9mZmxvYWQgZm9yIGEgbWFjc2VjIGRl
dmljZToNCj4gPiAgICBpcCBsaW5rIHNldCBtYWNzZWMwIHR5cGUgbWFjc2VjIG9mZmxvYWQgbWFj
DQo+ID4NCj4gPlJldmlld2VkLWJ5OiBSYWVkIFNhbGVtIDxyYWVkc0BudmlkaWEuY29tPg0KPiA+
UmV2aWV3ZWQtYnk6IEppcmkgUGlya28gPGppcmlAbnZpZGlhLmNvbT4NCj4gDQo+IFlvdSBoYXZl
IHRvIGRyb3AgdGhpcyB0YWcgd2hlbiBwYXRjaCBjaGFuZ2VzLg0KDQpBY2sNCg==
