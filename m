Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56D9969DB28
	for <lists+netdev@lfdr.de>; Tue, 21 Feb 2023 08:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233633AbjBUHZb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 02:25:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233607AbjBUHZ2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 02:25:28 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0775324121;
        Mon, 20 Feb 2023 23:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1676964321; x=1708500321;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=/pi/l0eS6UBExenP5K1Z4gqyx0B6exCOWcZ1dzxjb6g=;
  b=XjW44QgJJuoAuesimBRKdCmlxFXxNg2B9wZBPc15JEvlGIFaMiaYARkH
   5HhJ9Ytv18rXtBYW0kaNTezt8EXQlYUe15tX5ubvoRuuwXo7BUjB0w+w+
   4HF6GsvQ5B+n5LXOqP95r/s2k7/HXa/aX0kXgaH+MtVtUYlydE+4UM0hx
   4tbYqma+PARzkW/VJcl71+DS8gnrdklR+ILEUpXjkVlHYQVFGhbYB9V+o
   CbfjzDGj+qm2u5eTOgoAwPbfvoohOem1TLRPn9lVFdMLWkGxcijU7RYph
   fuUltcBi1ExgK6QqYZg+dTG8n/awUsp4HO+RYr96e7Akq+Gk1YDmBIKYf
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,315,1669100400"; 
   d="scan'208";a="201847717"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 21 Feb 2023 00:25:20 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 21 Feb 2023 00:25:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Tue, 21 Feb 2023 00:25:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXTNGfXB+yoGFwj/8BNCpRFLe5blxUW1BDB7SUI6ZHqYtCzXiOyiaPRZH2QNYzHrfW9ayOiMTWjKTFjQ1YugBKCAgG1+4657gHofi2yCuDj+2Cj2o3NRow0ZivdY+DIaBDV3v432J/X6hghJg+fbhoZ0dGmFrjvQtPh73hpNE/RJOs499P8WzCPVhikyDxebGnyjc4B4ycxbl5eJBxD3XaDkZlkMnRt2xSQMWxdngqywLTRp8Tfx1hATnZ7lUTH7nVthTU01a9XK4hohcCWxptX/rIMFvoQkua9wFTz71TtM0/Ba/Myle+Xcoezmd58Agz1Z6cQXq5OhX6b831Zabg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/pi/l0eS6UBExenP5K1Z4gqyx0B6exCOWcZ1dzxjb6g=;
 b=gLefkuU6mKZRuPrv/25SPdyO7XlSB/2tbXsmmXtfo1vnuc4SF7txxY2vWNFA9/Mhid92kbV2Yu3yKymmhVbCf0MK/c8ppOGxIaggE5puFT1VtW3ghjoU6wwu48iZuyy1vZe16Vg0GS2nwnv8KxQpKvqVzhfsZk+QBvmm2AyPRJpN8XKKgpDhDdH26cU9JufWEoAT3yqH09vGRlQPOSjZR+NzPC3SAGuqEqQszWEGn+hOcdHjIvTmr4kFz7ws2jSDicfkJbCHRn4QWvOA6Th7232IbPgwyDkR1RmbNjYgfmA8M3h6xxVWWa0z0FBS5rwNOSIpK4dSRL7G5CuzxKm1bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/pi/l0eS6UBExenP5K1Z4gqyx0B6exCOWcZ1dzxjb6g=;
 b=uVfpW5gCLF/L6bSvkgaQlA38l1lZv12nbiS4mXXd/QIcdQ2GyZwNnLmGQzIMQONWVlmbXh45+EA7vS2X0w5oWHljTQvadKtJ1gFN//BrvOxZDOiGOES6BBrMdwLubaAH2EnC/T+7m5WNqqyyyjYIBRV9WMtuZ+2G+/zmtnGsiDY=
Received: from MN0PR11MB6088.namprd11.prod.outlook.com (2603:10b6:208:3cc::9)
 by DM6PR11MB4756.namprd11.prod.outlook.com (2603:10b6:5:2a7::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.19; Tue, 21 Feb
 2023 07:25:17 +0000
Received: from MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e]) by MN0PR11MB6088.namprd11.prod.outlook.com
 ([fe80::6be3:1fbb:d008:387e%8]) with mapi id 15.20.6111.019; Tue, 21 Feb 2023
 07:25:17 +0000
From:   <Rakesh.Sankaranarayanan@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <davem@davemloft.net>, <pabeni@redhat.com>,
        <Woojung.Huh@microchip.com>, <linux-kernel@vger.kernel.org>,
        <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <edumazet@google.com>, <UNGLinuxDriver@microchip.com>,
        <kuba@kernel.org>
Subject: Re: [PATCH v2 net-next 5/5] net: dsa: microchip: remove
 num_alus_variable
Thread-Topic: [PATCH v2 net-next 5/5] net: dsa: microchip: remove
 num_alus_variable
Thread-Index: AQHZQr9iGxwUF1QyZE+1YAdC979rna7TYbYAgAWkagA=
Date:   Tue, 21 Feb 2023 07:25:17 +0000
Message-ID: <dd3f01dc1206339fcc5b748cace2ab564aed7c8d.camel@microchip.com>
References: <20230217110211.433505-1-rakesh.sankaranarayanan@microchip.com>
         <20230217110211.433505-6-rakesh.sankaranarayanan@microchip.com>
         <20230217171642.p364te2guqc7klns@skbuf>
In-Reply-To: <20230217171642.p364te2guqc7klns@skbuf>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR11MB6088:EE_|DM6PR11MB4756:EE_
x-ms-office365-filtering-correlation-id: 893002fa-f8cf-4892-c0db-08db13dcc821
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aQ4I0SmIzLjrJL2SAfgJZBHHF52rXvN+awr3Cb2kv+4W9xOwoolkMU1NwYS4SxnUSinmNFowrmPT0vhz0xLAkprcAn0kQwz1Te4jYRIWsB5N+Gi1FrLws47hP4B7A6jEXswTHng5qstNOYik6gqTF8zhiAWM7Nd6c/uFS6wWPKsK1CJAYb4UxfKGPoH3AwWmN/25uB5nIBYpbkCe5ffY7D4bvWKRoW/5FOBo3c4G8JxrDVKNkfU1+XkcMeZFqBqQP3xWOZOe7xSz2PqzZdxpH5FOSSf9afl07/rpknhOrR2SNJik5mZNgz7kfzOGtd0IRqhd/jJy84YQsQaD77jQH5dmv2yTt//rFmxTjNbDvFf7odUNyOGn04ZgEGUooff/HPDzE9Tro7ElZa51V1IFCvGk/VSChKmyouUP0epDiDm+oes3q6qIp4pqPbT84+GpVCG6SsJJ1IGSV7KwHdXRfENMHKeHfaESB5q3s8R7nwF6I4RoHqhN0tufADlaOmAQJMG0okxGXVxGtvlwMabqCmrPMjkmEneGVP3VF2aE92Vvmomdu+teBIyye0zYqsNAvv+ZRmyKEy2x5ypIu+pqedMsIB7nQJhNeMUCGvsex3l5uzuvyQkOZX97s5pzy6LB/zFG1KsShZno0AvPFHtbrogoPot5+a6Atqv24i2EmAry9Aw63SmNOBLV9llvo+upsqqCsF4AMrmx1tqT23DOrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6088.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(376002)(39860400002)(136003)(366004)(346002)(451199018)(66946007)(83380400001)(316002)(66556008)(76116006)(91956017)(54906003)(4326008)(66476007)(66446008)(8936002)(8676002)(6506007)(6916009)(41300700001)(64756008)(2616005)(186003)(6512007)(478600001)(36756003)(26005)(6486002)(38070700005)(2906002)(86362001)(5660300002)(4744005)(38100700002)(122000001)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?a0xacGZUeGoyMkVDc3dpb0N5ODZIREJSQXpNNWhGMTRua0tDYU0yMUJQZTFR?=
 =?utf-8?B?R3djKyt4OVo3bFJmNnVJTEJ2ZE5EWU56SE51Q2FPblRjLzlMcW9aR3NGVFZX?=
 =?utf-8?B?dUNOMU4wLzN3ZmtZQ21IK0x1MmIzU1I0TzIyZEhQQm9kaHppekZJais4SE9V?=
 =?utf-8?B?U3ZIR0kzdllpak5YZS83SGlLNW5xSFNBNGJSUDRJNE95Q082eXNlTzlKalpS?=
 =?utf-8?B?RWZiL2UrWXkyQkJoSnNpMHlFZXZnUGhGdTdTNXpXaGtkZk1xVUF2ZTV4SDRL?=
 =?utf-8?B?YmhxdzZORnRPd0NhSzUvUTBoOVJURE5WUzkvUXdFYkVBLzNFSlJycyt2R2dr?=
 =?utf-8?B?NFV1RUEvZ1B5MEIvVDRIS3lWdlh3VFpCTXpGc1RaVW80R0R2cW1vNUwzeTJB?=
 =?utf-8?B?Y2VQQ3dKbUd3RUROUURZN1ZRUS9rb1FpcTUyY2VseXpXWk9iZkUxa1JzeVRR?=
 =?utf-8?B?TkRNM1NEOWZoY0lPT1dXQ3o4QUhGWWRac2pxRVB3S292N3pHazVWdEVOYThR?=
 =?utf-8?B?YVNiMmZNR2tkV1NyaWQ0VFdtaUpRSjFNUnBQQVBwanhXOG4rZ2R1aDNYYk5p?=
 =?utf-8?B?R3dYVTczTjExTFIrenZweGZrc1BkRVpXMEUrSXlQMUdVQit3dmlzWTFYNEY1?=
 =?utf-8?B?dnYxcVZRZ3RlYWl5VFlnSGtzOHJqbjUvSW02U2Q1UktxUHNRYS9QMForTHZX?=
 =?utf-8?B?dEN5bEZGdjJDK3VlNk1wbDZ3aWNTT1QrRURxNWl0YXBsQTZyUjdXVXJlb2lB?=
 =?utf-8?B?WHp6K1Jxa0pSZkd3d1JFbFExTmFXSE03a2RNS1BNRmJUaWJ4ZE9oOE9RN1Nq?=
 =?utf-8?B?YmRXbWlXdUFyNmtuQ1htRjVBaGtqVFhsSzFuSVpkZCtkcWVUM1UwVzFTcUh6?=
 =?utf-8?B?N2lyclc2TitIMVlOczVSaVNKSXlwMGkraVMzL3hnbnE3SE5hSTlwMDBHcUgv?=
 =?utf-8?B?bG9kTVVMZ21vcWcvNjFBZjJiUmZMTUs3SjV3UDJHOHZkanFSK210aTFVcnpT?=
 =?utf-8?B?VFQzNWZXUitGcjZlMWk3UnVmeEt5WmdLSXRqL2htMVBxWm52eHNuNTJ5aG9Q?=
 =?utf-8?B?MXdNOFFvcnF2d3F5aDl2bXhFQkROLzM5K1psenhLcHdJY1VnNVBuZmdGOEVN?=
 =?utf-8?B?Y3NTOTlyakUvTzVJVStOaXFka0xnTWMrRjRIYkVvZHJqNWo0Yzd6UFUrK0FF?=
 =?utf-8?B?MWlEcHJOR1U0VUhxcGRXQTdXamNMMkR4WllCTzRmazN5L2NLdDhjUzBocVdQ?=
 =?utf-8?B?SFoxR2NPb1U2bUYrcWNRblZHU0xDMVBwM3NTZUY5KzkwMHdWUzRCa0dIQlBG?=
 =?utf-8?B?UzAxOGxSKzI1SjhtTStuTk9GSStSVzV6SHJMYlRsSjNqYXc3bTg4UG5CSDFO?=
 =?utf-8?B?bmRxV0JqUm91N1VXTFhMUVdHREdGQlBJaUhqRnQwSlFaV1c0REc5b3NYQTVt?=
 =?utf-8?B?Q0MybGl2UHp6Vm9TZnFuQURBaHNwd2p4bDlTZWNzV2VoUjVSbEdFOC9GNDNQ?=
 =?utf-8?B?eVRRVzZ1dkswY0lxbllPZUZ5V296UEhLd3RHd3g1NThmMDlLRVhaSlhwOS9o?=
 =?utf-8?B?TUhZb0VETUE4UWozMWdFNW1uc0ZtWTRqcFR6dkxCN3p5TkZ4SUpjUkRrMjFZ?=
 =?utf-8?B?ZFJPZkhlRlA5aHhOWStlK0toZ3h2YnR6SGpWNkJRa1ptQ05xdW5RaVgreXcz?=
 =?utf-8?B?SHA3aTVvd2Vyd0FxM0xWYnN6eCt1NHF2K1R5Yi9nSDVuV1UrL0gvYThSVThq?=
 =?utf-8?B?NGlXRVhkaUo1ZnhmTjRWWUVYSlZtemRlUXoybzNuVzhPM0UvVlVmRDlwNCt0?=
 =?utf-8?B?NTk5SmlpWEx3UC9FTzZQR1dPaXdoK29adEtOd1VYUlhycHhsTzAweUl4cExo?=
 =?utf-8?B?TnE1aWkyZXlIWTY0SU9GRVIyNXo3WGVFWmI2MGNrZGJ1OGt4Z2JRT1BNMGJs?=
 =?utf-8?B?dUJjUkVTcWpRdmk5c3NMVytObkpOVE9mN2NHdlZtZGhQVVM4cmRXSW9vb1hT?=
 =?utf-8?B?SVVmZTRDTFhLQ1Jlbm1TZ0RhUER3VTdVSk5wOGFhUkVTQWM0TGRsTmFLUXZK?=
 =?utf-8?B?cnFSNmFEVzB4amVGak9IdzFMTk5KaTYzTGpmM0g5WnpXZHlzVWhBcVdBMGk2?=
 =?utf-8?B?RTRMOUloUnpIck5PMWd5aVhOVGdYNVhtY0JQNmhJWUFPc0NyZXZRd3JGY0I1?=
 =?utf-8?Q?LUSueX59txohSDy0qKDENZlwEkBj6VvZUySCIdFbQYKY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8E4941CD3511854AAF149F460C4B5921@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6088.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 893002fa-f8cf-4892-c0db-08db13dcc821
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2023 07:25:17.4133
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ivj92qDWUbDk46NNyRx7eftPeeT1MmBAn2eBDjQn87dV2/EsS1Vbqfv572afQw8OEjat+Rb2nS9tdDi5VR9lxXQE+ah7RplufiuD8BpGeFNcyT5mRObsLIGwmF5x7j32
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4756
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZCwNCk9uIEZyaSwgMjAyMy0wMi0xNyBhdCAxOToxNiArMDIwMCwgVmxhZGltaXIgT2x0
ZWFuIHdyb3RlOg0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4g
YXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+
IE9uIEZyaSwgRmViIDE3LCAyMDIzIGF0IDA0OjMyOjExUE0gKzA1MzAsIFJha2VzaCBTYW5rYXJh
bmFyYXlhbmFuDQo+IHdyb3RlOg0KPiA+IMKgwqDCoCBSZW1vdmUgbnVtX2FsdXMgdmFyaWFibGUg
ZnJvbSBrc3pfY2hpcF9kYXRhIHN0cnVjdHVyZSBzaW5jZQ0KPiA+IMKgwqDCoCBpdCBpcyB1bnVz
ZWQgbm93Lg0KPiANCj4gbm93PXNpbmNlIHdoZW4/DQo+IA0KPiAiZ2l0IGxvZyAtR251bV9hbHVz
IGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAvIiBzYXlzIGl0IHdhcyBuZXZlcg0KPiB1c2VkLg0K
WWVzLCB0aGlzIHZhcmlhYmxlIGlzIG5ldmVyIHVzZWQgYWZ0ZXIgZGVjbGFyYXRpb24sIHdpbGwg
dXBkYXRlIGNvbW1pdA0KbWVzc2FnZSBhY2NvcmRpbmdseQ0KDQo=
