Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EE1E663F34
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 12:23:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjAJLXt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 06:23:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230083AbjAJLXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 06:23:31 -0500
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (mail-mw2nam04on2080.outbound.protection.outlook.com [40.107.101.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25001431B5
        for <netdev@vger.kernel.org>; Tue, 10 Jan 2023 03:23:30 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VzXOqT8uTNNzKo6gdiHNHy0nNOhzBHTB8MhCSe0zRoNu+5xFdeBc8xO3EFBs8qr7aN56qCC4l8fnHz2VY5upJa+zhmxOY9tFazcOgMLQngAKqsK4KQ/JdG7MCU1YsnrHIZiRcDS0c5JmpQVi4C0NoAy3Vvk60gRMMkCXHOyHxEuf1+cP9WJ2LluA1ThhP4wd1JsHJVRPu1SNHHsiStwbTkJfJXEoM4ynh6zdvl439bCmWQd1QLspxz8S36+unkcTGYO42Y2XKAvoy04NL/TAdn70L4WHCYaruLt+n5iun0S6geDGK5d8HdPgH6jjy32cG7vmVriG736wRLGWW4o1vg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=U9PknKPFYUQUoA7hzpjZadx7CQ+fVrkJ0CqrQj99fic=;
 b=ItI7XTlaA7un627Kl+fqplAAiSZ/TF40LKV8C07U6ru6bB/ZY1lOvsXWMYsv39KHgpH2URz2Bp6mwEhQ/seP43NfhCJvFrmjW5v9G8SERj4qmJI3vvcyMb+Hu3W5y7YS/iAiguPwPwjPjB/9jATZ9vU/HBbuyURKtiPMHX7EgexHx7rsL7LpIyU4HTdYLOP5q6ON7vJexc6c+uthJjQfBts5bhahWaJeTdaSpQB2w2oRe2mSpdd66ZkLQtE2wiYkXE45x827nAa9UNg+9xHYHvY9oyEpL9AhRTg6Szg/kcIqW2UC6AzIKuwPlbcI+F78BjsqcfTavO7YFfQPyfKY5g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=U9PknKPFYUQUoA7hzpjZadx7CQ+fVrkJ0CqrQj99fic=;
 b=nwQYDMJM3Z7Vxph4wSyvClNIF3JwKULUh291fk1pm+la0jBRKpkGKIsSay9fZUmcy41SG++9M9TNusNk/FYxP6WTopFKNWK+E62lPBwRD+jQQgmJe+YKJ8luG+Sxc0FVLK5Aag4avsyqF9ihgPiCQ3tC26Zcgcc3E7SXS+9IZLvL6geW0IQMcGXOo/ku1OIQEQd6OTvEopgy8CeKY905ECmc9zHdBnBBxNAlFaO3u5wO793zmUES5i2H6HHwt6c2oZYlJqDADgAnxyHmJhb7YS23bOki3kaYw5N10cUGJJLttE5q16uTFGZerRfLyj5t1397sKwFc4FkuU6sPbTagQ==
Received: from IA1PR12MB6353.namprd12.prod.outlook.com (2603:10b6:208:3e3::9)
 by DS0PR12MB6413.namprd12.prod.outlook.com (2603:10b6:8:ce::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Tue, 10 Jan
 2023 11:23:26 +0000
Received: from IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e]) by IA1PR12MB6353.namprd12.prod.outlook.com
 ([fe80::9d53:4213:d937:514e%7]) with mapi id 15.20.5986.018; Tue, 10 Jan 2023
 11:23:26 +0000
From:   Emeel Hakim <ehakim@nvidia.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     "dsahern@kernel.org" <dsahern@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>
Subject: RE: [PATCH main 1/1] macsec: Fix Macsec replay protection
Thread-Topic: [PATCH main 1/1] macsec: Fix Macsec replay protection
Thread-Index: AQHZJMo4IObyE0HZYEC1M2UkECCch66Xa5iAgAAVavA=
Date:   Tue, 10 Jan 2023 11:23:26 +0000
Message-ID: <IA1PR12MB635369F750521C87790D328AABFF9@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20230110080218.18799-1-ehakim@nvidia.com> <Y703mx5EEjQyH8Fu@hog>
In-Reply-To: <Y703mx5EEjQyH8Fu@hog>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR12MB6353:EE_|DS0PR12MB6413:EE_
x-ms-office365-filtering-correlation-id: b55664c9-fccd-44bb-c7be-08daf2fd17c9
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Agdj33KTNj53bM2TFhFpdIQW1OuZIrZ+6j0LrZjZh1qq87w6Kl2sZ7vPBqfWFQCQX8PQJ7rgyKjjDeibu6gfPuhyU/JY0H7JKCRHXwDWE3b8mSzvrwW/DkaJMS0oULSMtA8O01HWve4GdplT0t2Ar9NYFt/jl2slDd+MKplplMcTkw64nMbG4aRxjVLBAhACzMAiaHqZ8hgdx4qIFfUHJ+OFQVfdbmC5P9qRljG/Q9eknBXW266qHoI6agsCSe2UzZ5DOWN91qCZY2HZMha9LeSNjzhAmK3+zyTWX/O7HJXRg+fJdXPiYN702ESKwfohxt9kwFWIoL36ZGEfWJNAX2UwoFdve2Stk58gWQlNmSFz07UvJciq1lE2Dq4F+YiVtP85OKamJrlhulvaoPZQyv2D52oGSBazsZ6Fw4Q1XZ8Gf72WlBiFcitbri7TUx/4UuG4oxajvi19MKXMwv3bxlNyMnb+Tn1Mz7QrxAaM8tqtAT6aiwBRkKxf9StkzcL10FJneA+n7OeNZiBJP6JadoDDrXEfxQ/V/Y7XZqARWDBoV7jTYt4wUOCtVCReXfM8JINDjcPQcJoR42frOXPuKZ55Wh/KdJwPmp8DARhX+hxK+xC9h9Ynb1Hx6dfjyxxprMGRqIww4ZeWdPcU4JzCUpuui7GXMLq846lJacQZTWz0odaYIbzWngEz0TSGxq653sVpQrpRrS6OVvmU/3q6hw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR12MB6353.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(136003)(376002)(396003)(451199015)(9686003)(6506007)(186003)(55016003)(107886003)(54906003)(8676002)(76116006)(86362001)(4326008)(66446008)(66946007)(38100700002)(66476007)(38070700005)(64756008)(5660300002)(122000001)(66556008)(478600001)(53546011)(6916009)(2906002)(26005)(316002)(71200400001)(33656002)(52536014)(41300700001)(8936002)(7696005)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmZ2TjlkckhING9kOHJtWldyV1pxRk5uRjBDMTZGRnR0SlB5UnVRTnR6b21v?=
 =?utf-8?B?WCtkT3BqTU9tVmpSNS8yUXZXQnpKd29rZElxbmF1ZE1YUGpZVmg3VUVzZW4y?=
 =?utf-8?B?OWVWZHFXUndDLzl6T2J0N3VOd2Fhckx1aElIeGxtRWdKaDF6ak56MDl5akF4?=
 =?utf-8?B?OVp5WUNoRCtYYkF1M053MGg3S1VEL0VDS3FJa08zTGdRNmlkV3FwazRQbDF5?=
 =?utf-8?B?V3N2Si9hSTBjdVJVT3dJUnJEV2dicDQwTmdiaTNXRUkzcWQ2V0xObis1aUxR?=
 =?utf-8?B?cFFtTHM1SnovKzVSVTZSZUF5RmFldmJFKzdKUnpjU0tienUrK1cwZGxKVkJQ?=
 =?utf-8?B?QVR5b2gxQUFRWGthKy9KTHJ0SDFieGIzS0M4UzdaTGFqdlZXN0hWUmd4anZx?=
 =?utf-8?B?VmVUQjJJTkUycUxXdXVYdGJaUG5lczl6LytreUNEaDlQU1BkRDN3R1Q5ZGJI?=
 =?utf-8?B?NWVCRk55T2FNTW1CVGZvN1lkenhBUDUraWVjYi9nZVJ4Q0RKNzc5L1ZQSStW?=
 =?utf-8?B?dDFJczJPeDlPWjJYT1NabDF4bG51dEVVQ3hsL2Q0NUdUMTZlU2E1VFgyNHVa?=
 =?utf-8?B?d0lEMEFPNTBhbkJoMTd6TmhiYzRrL3lMdEF6aGdlMGV2N0NEaDliUGpqOFFU?=
 =?utf-8?B?VzZWcUZzUzBzdWc0VkwxTzNveDNjZlFCQTg5dlltZW1yRHNaZVNNQUxGZnY5?=
 =?utf-8?B?RUZycFl3Ly9wTjl4QWNJaGV2R0JMdXpsZTArd1JmVFc1WUZVTXcxRDdub3Zq?=
 =?utf-8?B?aDI5UXJCMVhQRUp5OGJLYmtDRHYzMm1oODJ1UTByRkVNYjB4RTJkb3U3VERR?=
 =?utf-8?B?OVduRndOcTBvaWVwck9nd0FYVjdFTkNvY3U1TEdGQzllWHBoa1J3bzArRWov?=
 =?utf-8?B?VE12WjFvci9NdHJLcnV6VUVWRjZLWEo3M0FsOHplS2ZUY080bUlXcGtockpC?=
 =?utf-8?B?dTgzQmlDZitBeStISkFLRWFxRXdWMEFReUg4OTRuWTdzeDJlby8xWXZVMmxw?=
 =?utf-8?B?Vk5xd1ZBWExSRVZ3bjlxbUVHT2Y3QkdmSFdHeDQ3Mjc1VVRTVWdzNnVTNEtI?=
 =?utf-8?B?d2hxZUo3dTN1V1dtU0FQMjdpdkJDaVhETWRhQVZUQWM5d1hxbWdBT0lLR29y?=
 =?utf-8?B?TTNNUzlpNUU2eE41cHlWSi9kUGxWRW9vUWlROWluU3VXdThLQ0t5cHcwUW5Q?=
 =?utf-8?B?cGU5N0U2YVZVMjk3dFVFL2RqSFB0UlBXdjEyWU0yUEx1elgySldoRzFwcUxK?=
 =?utf-8?B?cGdtZVd2blBMUExMWGh5MlJLS2huNGpvemRNNm1uaGF2Z2FNRW44UEVJaVlq?=
 =?utf-8?B?cjFhbGVBWGlUQkhjTGNEaHNiSDdDcmFhS0tlS0RPYUQ1V3locnBNSkJRUlM0?=
 =?utf-8?B?MDIvMmZzTXVQZmlPck9PSFJYbUFtSkk2WnhoNmhacjV2cDI2WlJKRDZlL1di?=
 =?utf-8?B?ellaSkdPdTNqQTJFUWUxVmQ4ZVozcVM0dXRFRFA3dUZSZGpGMnMzWTJZeVRq?=
 =?utf-8?B?Z1lBUVQ4ZGxlREpuUGloQS9WMjJSWDJOK0k5SjR2NEp1dTZjZU5xZ0F0VzJF?=
 =?utf-8?B?eHRLbUFjMzhEeTBhUGg4NlZLeUxYNW1YcHp0dVdBTHI0WTBieUs1RGtTd2tw?=
 =?utf-8?B?c3VwcWtyaStISDc3OGhXN0w5YTZSY0taVjY5NUJ3RGN5V0VJN1hSY09PWDZL?=
 =?utf-8?B?VldlbVBnU1praUI3dG5XbFFJK2F3TG10OHZtYUZiTk4vZGp2cDNJNzNaV09X?=
 =?utf-8?B?dCs4cEM5MzBEbmlldFJxRTZFclJlQWdHckFTMHUzRFlRK0pKM1J6TXdKdGxp?=
 =?utf-8?B?K0wyRy9VRHIxTkJ2ZTB1ei8yakFDazV0eGo2UHQ3TUpMWWhncGR5WHNXSWVP?=
 =?utf-8?B?c2ZpZFVpRUNpWGZZdmJvRjdieWVIemlsamkxWlpwYWhSK2s2d0ZjY0lyZTNw?=
 =?utf-8?B?a0Z6YmRTY3FBQXhFSE9Ba2daMmhwYjZjcGNiMWcrcjFBNjBmTkw3NlJpYjcw?=
 =?utf-8?B?OU5zdVRsQkNnRHdwbGVudURoam1sQWl4NnBNcFZVOXNtd053bXQ3V3NyQ3dk?=
 =?utf-8?B?WG52QmtibnlzV2dKcC82Z1hhajBRMlZoSGVEbmJUMmpPUDA5QklQTXFaTk1J?=
 =?utf-8?Q?PnCtwCrYkUGsWut+qRFnsbpca?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR12MB6353.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b55664c9-fccd-44bb-c7be-08daf2fd17c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2023 11:23:26.5469
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JnmDM7YJC4bZsYHnzh62YmrOwAWvCJhOUPBJJEdlBBMo5wSEo3fg3wvuTvy1biUlGEo34Wy1zsNim3U1jJR94g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB6413
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
IDxzZEBxdWVhc3lzbmFpbC5uZXQ+DQo+IFNlbnQ6IFR1ZXNkYXksIDEwIEphbnVhcnkgMjAyMyAx
MjowMg0KPiBUbzogRW1lZWwgSGFraW0gPGVoYWtpbUBudmlkaWEuY29tPg0KPiBDYzogZHNhaGVy
bkBrZXJuZWwub3JnOyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBSYWVkIFNhbGVtDQo+IDxyYWVk
c0BudmlkaWEuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIG1haW4gMS8xXSBtYWNzZWM6IEZp
eCBNYWNzZWMgcmVwbGF5IHByb3RlY3Rpb24NCj4gDQo+IEV4dGVybmFsIGVtYWlsOiBVc2UgY2F1
dGlvbiBvcGVuaW5nIGxpbmtzIG9yIGF0dGFjaG1lbnRzDQo+IA0KPiANCj4gMjAyMy0wMS0xMCwg
MTA6MDI6MTkgKzAyMDAsIGVoYWtpbUBudmlkaWEuY29tIHdyb3RlOg0KPiA+IEBAIC0xNTE2LDcg
KzE1MTUsNyBAQCBzdGF0aWMgaW50IG1hY3NlY19wYXJzZV9vcHQoc3RydWN0IGxpbmtfdXRpbCAq
bHUsIGludA0KPiBhcmdjLCBjaGFyICoqYXJndiwNCj4gPiAgICAgICAgICAgICAgIGFkZGF0dHJf
bChuLCBNQUNTRUNfQlVGTEVOLCBJRkxBX01BQ1NFQ19JQ1ZfTEVOLA0KPiA+ICAgICAgICAgICAg
ICAgICAgICAgICAgICZjaXBoZXIuaWN2X2xlbiwgc2l6ZW9mKGNpcGhlci5pY3ZfbGVuKSk7DQo+
ID4NCj4gPiAtICAgICBpZiAocmVwbGF5X3Byb3RlY3QgIT0gLTEpIHsNCj4gPiArICAgICBpZiAo
cmVwbGF5X3Byb3RlY3QpIHsNCj4gDQo+IFRoaXMgd2lsbCBzaWxlbnRseSBicmVhayBkaXNhYmxp
bmcgcmVwbGF5IHByb3RlY3Rpb24gb24gYW4gZXhpc3RpbmcgZGV2aWNlLiBUaGlzOg0KPg0KDQpU
aGFua3MgZm9yIGNhdGNoaW5nIHRoYXQuDQoNCj4gICAgIGlwIGxpbmsgc2V0IG1hY3NlYzAgdHlw
ZSBtYWNzZWMgcmVwbGF5IG9mZg0KPiANCj4gd291bGQgbm93IGFwcGVhciB0byBzdWNjZWVkIGJ1
dCB3aWxsIG5vdCBkbyBhbnl0aGluZy4gVGhhdCdzIHdoeSBJIHVzZWQgYW4gaW50IHdpdGgNCj4g
LTEgaW4gaXByb3V0ZSwgYW5kIGEgVTggbmV0bGluayBhdHRyaWJ1dGUgcmF0aGVyIGEgZmxhZy4N
Cj4gDQo+IEkgdGhpbmsgdGhpcyB3b3VsZCBiZSBhIGJldHRlciBmaXg6DQo+IA0KPiAgICAgICAg
IGlmIChyZXBsYXlfcHJvdGVjdCAhPSAtMSkgew0KPiAtICAgICAgICAgICAgICAgYWRkYXR0cjMy
KG4sIE1BQ1NFQ19CVUZMRU4sIElGTEFfTUFDU0VDX1dJTkRPVywgd2luZG93KTsNCj4gKyAgICAg
ICAgICAgICAgIGlmIChyZXBsYXlfcHJvdGVjdCkNCj4gKyAgICAgICAgICAgICAgICAgICAgICAg
YWRkYXR0cjMyKG4sIE1BQ1NFQ19CVUZMRU4sIElGTEFfTUFDU0VDX1dJTkRPVywNCj4gKyB3aW5k
b3cpOw0KPiAgICAgICAgICAgICAgICAgYWRkYXR0cjgobiwgTUFDU0VDX0JVRkxFTiwgSUZMQV9N
QUNTRUNfUkVQTEFZX1BST1RFQ1QsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICByZXBsYXlf
cHJvdGVjdCk7DQo+ICAgICAgICAgfQ0KPiANCj4gRG9lcyB0aGF0IHdvcmsgZm9yIGFsbCB5b3Vy
IHRlc3QgY2FzZXM/DQoNClRoZSBtYWluIHRlc3QgY2FzZSB3b3JrcyBob3dldmVyIEkgd29uZGVy
IGlmIGl0IHNob3VsZCBiZSBhbGxvd2VkIHRvIHBhc3MgYSB3aW5kb3cgd2l0aCByZXBsYXkgb2Zm
DQpmb3IgZXhhbXBsZToNCmlwIGxpbmsgc2V0IG1hY3NlYzAgdHlwZSBtYWNzZWMgcmVwbGF5IG9m
ZiB3aW5kb3cgMzIgDQoNCmJlY2F1c2Ugbm93IHRoaXMgd2lsbCBzaWxlbnRseSBpZ25vcmUgdGhl
IHdpbmRvdyBhdHRyaWJ1dGUNCg0KYSBwb3NzaWJsZSBzY2VuYXJpbzoNCndlIHN0YXJ0IHdpdGgg
YSBtYWNzZWMgZGV2aWNlIHdpdGggcmVwbGF5IGVuYWJsZWQgYW5kIHdpbmRvdyBzZXQgdG8gNjQN
Cm5vdyB3ZSBwZXJmb3JtOg0KaXAgbGluayBzZXQgbWFjc2VjMCB0eXBlIG1hY3NlYyByZXBsYXkg
b2ZmIHdpbmRvdyAzMg0KaXAgbGluayBzZXQgbWFjc2VjMCB0eXBlIG1hY3NlYyByZXBsYXkgb24N
Cg0Kd2UgZXhwZWN0IHRvIG1vdmUgdG8gYSAzMi1iaXQgd2luZG93IGJ1dCB3ZSBzaWxlbnRseSBm
YWlsZWQgdG8gZG8gc28uDQoNCndoYXQgZG8geW91IHRoaW5rPw0KDQo+IA0KPiA+ICAgICAgICAg
ICAgICAgYWRkYXR0cjMyKG4sIE1BQ1NFQ19CVUZMRU4sIElGTEFfTUFDU0VDX1dJTkRPVywgd2lu
ZG93KTsNCj4gPiAgICAgICAgICAgICAgIGFkZGF0dHI4KG4sIE1BQ1NFQ19CVUZMRU4sIElGTEFf
TUFDU0VDX1JFUExBWV9QUk9URUNULA0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgcmVwbGF5
X3Byb3RlY3QpOw0KPiANCj4gLS0NCj4gU2FicmluYQ0KDQo=
