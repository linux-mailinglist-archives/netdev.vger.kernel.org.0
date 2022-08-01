Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1E36586D60
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 17:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231599AbiHAPGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiHAPGa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 11:06:30 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265AB18E0E;
        Mon,  1 Aug 2022 08:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1659366387; x=1690902387;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SiAxZQ5vOw9twLsqV6Zb16Pp4hAr59sc+3nDJzukkYw=;
  b=nlitdlB4UOehU9fnYcpNZjF3+VMxuLIqIxqG50WengW29CH3cXcUMfWM
   V4qwhTA/UE/QvvHQNKGt99IWvgAfSZnAMVO5CIN4xrVLbVK23fDq/SiDv
   ktfylj33F+bGQXFeUaW7HeNfxC7EDXtkum48cL4C3SKx75D1Qx3RgN9YD
   UfQVR7BsjspzA4roi0kLMgmcAdUWST5ji1vmRAI9yxytbjtCkQiZxN9rN
   L+KsKUBXKTnmv/ccKDZfVZI/0OEYzX2sZ+XIqkW3MmCfs5bgtc4HFPR5K
   Z18uWIknD+iFDRzBJJQ658lsh/U68P3+V6e1ISbBSDg5FVn3egr6R7uWJ
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,208,1654585200"; 
   d="scan'208";a="107043835"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Aug 2022 08:06:26 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Mon, 1 Aug 2022 08:06:26 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28 via Frontend Transport; Mon, 1 Aug 2022 08:06:26 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YtCctnQXFWphJyUBIIxuVxAA2qFYYnC0RzdjtJfyqdM6w9blOlyNfnQpCH/lYi7wHytGrTGHkiDIHTmWvkUmPOUbncR/qR5eevWDsWut1YpjTn3bGflKVCUONbtkfS/j0BPd+f8mc09BiA7nsWDx0VNgM2xe3R1jfgT24Cd4pDtFi24V+xna9TDcEq6xx25F05OD5lZb9azcRX8bLUrZ9kTHQ/8gNv1+digRkXemg6W0zYuDPIgJCwLsrGzVy9C92DMqa/t0hLP5Jhm/+1u/mKc35Tq3a3kO8T9evcyHTlEgGKkau2TYA0J6rWtmTdh9yiu/dhICxVExNLobPNktIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SiAxZQ5vOw9twLsqV6Zb16Pp4hAr59sc+3nDJzukkYw=;
 b=FvucWQnNyAwK3+L/WJUjLGpG0yjbPV9k/42/MQ6dbKMLWQZomowewEitqeAh6InrYc7WX90TWjOIlXWvrjq/QQOOg41efmsGgbBdDPqWHe9u5vUU7R47Ne0Z7kssJss6Ig4n3Gt7g0ggtgrm32dMvyFynmNk7xVKYxr9RTp21QSFQWurvzlz3Xb0KA1yoiGKnRsy17T38pc2c8FkixVt4BLhG44KXFAfsmeCqFnH/E9AZarKwlHtlFcBd7ewEJc1TyS8TMLDBrSdc/SzFdZCFrgvVlf//m8SIhocg2ja57bEnnijBLcY6BBTHhDV1VuqpWBO4R8a5/KOFjVzj3HBpQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SiAxZQ5vOw9twLsqV6Zb16Pp4hAr59sc+3nDJzukkYw=;
 b=Z3OZkcb/lH7z1+hUoVhGO54yRMj7d/45hhVAaGM3FWhH77aGgJA3gdQ4BJwDX7PCml5n+hdvP4F7sZNuk0i9twYAMVcatPHM6FnUKFU7151LjYt13nBFQwlsXx4/KX1Xw1O+ypE1cP5XPp03gKHXffP8T2aZ7L/asLvlKpsPgic=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by DM4PR11MB6528.namprd11.prod.outlook.com (2603:10b6:8:8f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5482.16; Mon, 1 Aug
 2022 15:06:24 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5482.016; Mon, 1 Aug 2022
 15:06:23 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <git@xilinx.com>, <ronak.jain@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <michal.simek@xilinx.com>
Subject: Re: [PATCH v2 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Topic: [PATCH v2 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Index: AQHYpYz/w4ja8yXDQUmz9HznJF0suw==
Date:   Mon, 1 Aug 2022 15:06:23 +0000
Message-ID: <cf40f613-d0bd-406c-d080-d35d0e01b5e4@microchip.com>
References: <1659123350-10638-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1659123350-10638-2-git-send-email-radhey.shyam.pandey@amd.com>
 <bcbea902-6579-f1d4-421e-915e8855822a@microchip.com>
 <MN0PR12MB5953E6739D58E6BC444DE3E6B79A9@MN0PR12MB5953.namprd12.prod.outlook.com>
In-Reply-To: <MN0PR12MB5953E6739D58E6BC444DE3E6B79A9@MN0PR12MB5953.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 292bd4ad-9952-4cbd-e95d-08da73cf664f
x-ms-traffictypediagnostic: DM4PR11MB6528:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SHY9xzFEV4ztT4XGFmG3ev+ZZnEWBB8rZm03W2Bd73Q0NVoZbj8NnjP6Ny+TOJeFjYlmTMLu2CbbRIlwmuAI6Lv2i4HrgOxFjVTR6rbzkG2d3oy+XiZJ31FZvISUkki5XUc0cK18XHh3ahbRKis3DdEM798QQft+qj/feT4gQ2dXiiSncqUErYbMJglU4N4LpAkzX0coQgffaQ6uptn19xoPLCjvdWl2ZZey9ihQuQ8m4O20cFVv6f257bUp7lijOuUZPhILRNJ0mFNzdSTUzMzDJaQubpwTrtwf09T5R5nfjpbzzFC07so5sJ+5lbnIpWVoNGjoIxWEZM2cL5Zwy8A+wQByMVwNLyoSPJqytCJFGc6lnc2bg1tx+lzWm99XakmmVxmW8MQKLpG6LfnMPXb2jlFrVcHVMsINvbMqI/ArSRe831pvrERgaLyRW2kgQMosZolcUHwloW20SmhnjbM9Ky6pgJwKHnIhrSeyAEsFSKvo2huq2+NENpvIzH9fJb/9y9kO+LuqIM72+XQcEMMXyZjPmSB3MouwdG6qtLx7PWoE81p/Hute/oQobp7Kxeu0xOFFGUN521yi169Z6F1CgXsvoFVxmyRAqIR8jvBgLx+x2r9tbGeOcavbAdudUsK1ro7kHBENr3b1mcc2VHZ6znS61PiNc4cw4z3VXN48cXRgI7c1jcWF3jB3v03EZZV0/4YFAfDA6uTpr5OGL2lLY3rTQCDth8j+YE/3T4olj0mVztm7gILQ1b4JSFseNJsDjxdfIaV4c+9FSqHdMJfi4bj29W4K5PkI9aBV9oLAEBIKmv7Ux/3UzKeXzkLZqO9/X3jJioGzOJZamum6JTGT2x+Z+W/OVRS+zZPi17alF3aKy+Xo/QpemAAkMM3adsXBaAAWkNJG/Xxfg9RriA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(136003)(366004)(396003)(376002)(31696002)(31686004)(54906003)(38100700002)(83380400001)(71200400001)(2906002)(316002)(86362001)(6506007)(4326008)(2616005)(8676002)(36756003)(66556008)(76116006)(186003)(122000001)(6512007)(26005)(5660300002)(6862004)(41300700001)(64756008)(66476007)(66946007)(966005)(478600001)(6486002)(91956017)(53546011)(8936002)(38070700005)(7416002)(66446008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dytSWVBMNXhJZnRtOHJEL2JXSVlsUVpnS3dRNGQzSG5Nb2lka1ZiaVlSSDFa?=
 =?utf-8?B?aWE2MGJnRnphbmx4S3RvTnl5eVl3SEZ3MTRiWDVzMmJsWnpVUXhvVGsvL3hw?=
 =?utf-8?B?NzA5Qm95YkdKYlRwUllXNlpVRDVDb1Q1U0V1QWNJZHc1dkZaaTBFSGoyRnRQ?=
 =?utf-8?B?YWwvaktvNjk5cnZYOU5WSHNsc0EwWGU3SlpvaXI4dGh1ZElVRS80c1FpRTFi?=
 =?utf-8?B?aXZLbDlhZnhGQklkTDB3S0FrR013OFdFTXdTaDFoQ2RxbnhZa1VLcmpDQi9J?=
 =?utf-8?B?WGNiaTl2T093SEZDZVJ5TFAxOVp5Mm5VYzZrNjYvRUxIMnpwcThIUW1KYUEz?=
 =?utf-8?B?YjQ5UmY3MlhjSkRmMk5na05pKzQyZThLM280MlZkR3ZnbkN5bUwvdkRaRkxt?=
 =?utf-8?B?emdoQzd6RW85VEptdXEwcS92RVRzcmFnTk1YQldjcUpOMVpQRGp0cm1ISzNU?=
 =?utf-8?B?NWpienUxMTF0SDZCM24rVWgvY09DbHZWV3lXdld5Z1FqQlZUNUR4cEVXZzF6?=
 =?utf-8?B?a2RKa3U5djgyb252NEpmbENadTZPN0puTmhjRFZsM1FDZnhwYS9JQUt1aitp?=
 =?utf-8?B?bG8rb1pwREFIK3JFeWdRNnAxRkxaSlY3cUJxMm1OZGswUzdPZG9PMWJuSFpB?=
 =?utf-8?B?SnloQUE1TXY4WTN1Ny9MZjdRQlZzRitoemZtZWMxQW1QbkdyMGJCd1NPOGJ3?=
 =?utf-8?B?NnpGajhnR1lVbXg0a3hxOGlENVppWE5YWG9VVmNEeUxQSEFwWEs1YS9NWjRC?=
 =?utf-8?B?bTFlYWhYM2pkZ1BEWGNIWU9rNTFMK0JvbkdFN3p0MEF6dDFXUUMvZzFOcy9G?=
 =?utf-8?B?OXBrOUI4L2M5OCsrWFE2NFlzNFVKaDBTS0x1UjlTSkVMUjE2UlFUYi9YdUw4?=
 =?utf-8?B?ZGcwTWd3d3RSOFpVSXNhOGlPd295TDhyRVpqOWI3SlcwZ25lZjdWdUhDSTdO?=
 =?utf-8?B?djM4RGJSUXFzd2prN3k3WTVYTlJHTStreEVxQ0czczNxdGR4ZzVYRDB2NU5h?=
 =?utf-8?B?cDVwTmlLVzlUdkEzNXJOZG8wTVZucjBuSzJHWnlDV2hxTnJ3Q1h0N2VTTENN?=
 =?utf-8?B?dmtoRmpvVTZqRlI1VXc0U1laRmVpbnpHSTRaQ3ZKNHZjTmUvbFZwc0VjZE5u?=
 =?utf-8?B?WGoxNGxlSkYvaE9CMXpxOERLSHBPQVp1c3JWNS8xRFNtVnJydHRaMDUzYXVN?=
 =?utf-8?B?ZEpGR0J0emdkb2lYbFluVEc0UWdaMTV5Zk9aRnFheFhWS2RkQ2pFeGxORE5h?=
 =?utf-8?B?YkRmSVpKbVYyS3R4N3FJL1IyRWZjcHppcHFRS0JmekE4YnBPS01QTk91SjVp?=
 =?utf-8?B?MlVxOEw4WlBGTHc5MDN1akxOR2VLcHRrUGVJZnE4Qzd1K1BQeTFZVWpYaExk?=
 =?utf-8?B?VWk1WU01VGVlR3FLbFJ1b3lsZUJpOVp0OWp1UFJQMk9QdGpRU092MmtKbXFZ?=
 =?utf-8?B?NlZHRUZiN01LYXlTU0dJdCtab1lIQ3JoTEtQbkJHMzd0dVZCRVhNSzM1b1dE?=
 =?utf-8?B?ejdMMmNUWDdVWXcyUjNrb0NYT3hBWllOM3ZZZk8wTy9NK3NQQURVSC9uUVFl?=
 =?utf-8?B?blN3UDhGZHNUbjdieTdxVjBQQkZQanhEa0hudUFyR291ZTdxUk9vb2VLMzVl?=
 =?utf-8?B?citMM1IyckovdUV2UG8yUjhtS241Y2NLYy9FUzBCaFRoVytabG1ZcG94L2dF?=
 =?utf-8?B?LzAybU9vaFZuUTFHWFFGeVJvcW9lYXZYVUVhb0V4eWEveWR4Zy9Bazhhemtl?=
 =?utf-8?B?SDRzRDcyUm5nU1ZDMDUvLy9FSnRPbUhqdFBIamtnaEZEb2hxRGIrMEpWSE0v?=
 =?utf-8?B?SldnU25adUpQOWMyZzkybEtERHN0NVNtYzVMWjZyRFpveHF2cXFwUnZoeDR4?=
 =?utf-8?B?ODh0d3pLRWw3bjRIYnAzUVB6a1dzaFhka2Q2c1VvcWlMWkF6NFBqL1l6T0ZU?=
 =?utf-8?B?R05FQ0s5Yy9SQmcvQVo5QlhpNVdPby9HdDZOV1hEWmVadFU4SVMxQmlJZVNN?=
 =?utf-8?B?YWt3YkQrNy9SU0pwdlNSdHV6TStNSzNpZ2lLRTlHZ3JMa1lpZjZock5HODlu?=
 =?utf-8?B?NTc5Z2FqS0NwYXBiL2c1cVBEN0FoUWJIZUZMVmllT3I0OVdvNEpLZWRabXFM?=
 =?utf-8?B?VmpwMFVmLzZJNEhEWmlOaHl1QjRSM1BjdEtwek9rQjl0S0YranoyWmpvSUZH?=
 =?utf-8?B?Znc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AEB97DF0F6BB1741BC9B96B0275CFE60@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 292bd4ad-9952-4cbd-e95d-08da73cf664f
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2022 15:06:23.7815
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cwUHOlkVsy6B8Q9yRTZ2e0IS6mE98rh153ul6lbWvE4MGlBeIDiSKvMZdjEWjE5yd6269H6cWsSZZdsn2czjcWUWILBhz7AoHZqqvOeimzg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6528
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEuMDguMjAyMiAxNTo1MiwgUGFuZGV5LCBSYWRoZXkgU2h5YW0gd3JvdGU6DQo+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4+IC0tLS0tT3JpZ2luYWwgTWVzc2Fn
ZS0tLS0tDQo+PiBGcm9tOiBDbGF1ZGl1LkJlem5lYUBtaWNyb2NoaXAuY29tIDxDbGF1ZGl1LkJl
em5lYUBtaWNyb2NoaXAuY29tPg0KPj4gU2VudDogTW9uZGF5LCBBdWd1c3QgMSwgMjAyMiAzOjI3
IFBNDQo+PiBUbzogUGFuZGV5LCBSYWRoZXkgU2h5YW0gPHJhZGhleS5zaHlhbS5wYW5kZXlAYW1k
LmNvbT47DQo+PiBtaWNoYWwuc2ltZWtAeGlsaW54LmNvbTsgTmljb2xhcy5GZXJyZUBtaWNyb2No
aXAuY29tOw0KPj4gZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3Vi
YUBrZXJuZWwub3JnOw0KPj4gcGFiZW5pQHJlZGhhdC5jb207IGdyZWdraEBsaW51eGZvdW5kYXRp
b24ub3JnDQo+PiBDYzogbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51
eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZ2l0
IChBTUQtWGlsaW54KSA8Z2l0QGFtZC5jb20+OyBnaXRAeGlsaW54LmNvbTsNCj4+IHJvbmFrLmph
aW5AeGlsaW54LmNvbQ0KPj4gU3ViamVjdDogUmU6IFtQQVRDSCB2MiBuZXQtbmV4dCAxLzJdIGZp
cm13YXJlOiB4aWxpbng6IGFkZCBzdXBwb3J0IGZvcg0KPj4gc2QvZ2VtIGNvbmZpZw0KPj4NCj4+
IE9uIDI5LjA3LjIwMjIgMjI6MzUsIFJhZGhleSBTaHlhbSBQYW5kZXkgd3JvdGU6DQo+Pj4gRVhU
RVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVz
cyB5b3Uga25vdw0KPj4+IHRoZSBjb250ZW50IGlzIHNhZmUNCj4+Pg0KPj4+IEZyb206IFJvbmFr
IEphaW4gPHJvbmFrLmphaW5AeGlsaW54LmNvbT4NCj4+Pg0KPj4+IEFkZCBuZXcgQVBJcyBpbiBm
aXJtd2FyZSB0byBjb25maWd1cmUgU0QvR0VNIHJlZ2lzdGVycy4gSW50ZXJuYWxseSBpdA0KPj4+
IGNhbGxzIFBNIElPQ1RMIGZvciBiZWxvdyBTRC9HRU0gcmVnaXN0ZXIgY29uZmlndXJhdGlvbjoN
Cj4+PiAtIFNEL0VNTUMgc2VsZWN0DQo+Pj4gLSBTRCBzbG90IHR5cGUNCj4+PiAtIFNEIGJhc2Ug
Y2xvY2sNCj4+PiAtIFNEIDggYml0IHN1cHBvcnQNCj4+PiAtIFNEIGZpeGVkIGNvbmZpZw0KPj4+
IC0gR0VNIFNHTUlJIE1vZGUNCj4+PiAtIEdFTSBmaXhlZCBjb25maWcNCj4+Pg0KPj4+IFNpZ25l
ZC1vZmYtYnk6IFJvbmFrIEphaW4gPHJvbmFrLmphaW5AeGlsaW54LmNvbT4NCj4+PiBTaWduZWQt
b2ZmLWJ5OiBSYWRoZXkgU2h5YW0gUGFuZGV5IDxyYWRoZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+
DQo+Pj4gLS0tDQo+Pj4gQ2hhbmdlcyBmb3IgdjI6DQo+Pj4gLSBVc2UgdGFiIGluZGVudCBmb3Ig
enlucW1wX3BtX3NldF9zZC9nZW1fY29uZmlnIHJldHVybg0KPj4gZG9jdW1lbnRhdGlvbi4NCj4+
PiAtLS0NCj4+PiAgZHJpdmVycy9maXJtd2FyZS94aWxpbngvenlucW1wLmMgICAgIHwgMzENCj4+
ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiAgaW5jbHVkZS9saW51eC9maXJt
d2FyZS94bG54LXp5bnFtcC5oIHwgMzMNCj4+PiArKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysNCj4+PiAgMiBmaWxlcyBjaGFuZ2VkLCA2NCBpbnNlcnRpb25zKCspDQo+Pj4NCj4+PiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9maXJtd2FyZS94aWxpbngvenlucW1wLmMNCj4+PiBiL2RyaXZl
cnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jDQo+Pj4gaW5kZXggNzk3N2E0OTRhNjUxLi40NGM0
NDA3N2RmYzUgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVycy9maXJtd2FyZS94aWxpbngvenlucW1w
LmMNCj4+PiArKysgYi9kcml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYw0KPj4+IEBAIC0x
Mjk4LDYgKzEyOTgsMzcgQEAgaW50IHp5bnFtcF9wbV9nZXRfZmVhdHVyZV9jb25maWcoZW51bQ0K
Pj4+IHBtX2ZlYXR1cmVfY29uZmlnX2lkIGlkLCAgfQ0KPj4+DQo+Pj4gIC8qKg0KPj4+ICsgKiB6
eW5xbXBfcG1fc2V0X3NkX2NvbmZpZyAtIFBNIGNhbGwgdG8gc2V0IHZhbHVlIG9mIFNEIGNvbmZp
ZyByZWdpc3RlcnMNCj4+PiArICogQG5vZGU6ICAgICAgU0Qgbm9kZSBJRA0KPj4+ICsgKiBAY29u
ZmlnOiAgICBUaGUgY29uZmlnIHR5cGUgb2YgU0QgcmVnaXN0ZXJzDQo+Pj4gKyAqIEB2YWx1ZTog
ICAgIFZhbHVlIHRvIGJlIHNldA0KPj4+ICsgKg0KPj4+ICsgKiBSZXR1cm46ICAgICBSZXR1cm5z
IDAgb24gc3VjY2VzcyBvciBlcnJvciB2YWx1ZSBvbiBmYWlsdXJlLg0KPj4+ICsgKi8NCj4+PiAr
aW50IHp5bnFtcF9wbV9zZXRfc2RfY29uZmlnKHUzMiBub2RlLCBlbnVtIHBtX3NkX2NvbmZpZ190
eXBlDQo+PiBjb25maWcsDQo+Pj4gK3UzMiB2YWx1ZSkgew0KPj4+ICsgICAgICAgcmV0dXJuIHp5
bnFtcF9wbV9pbnZva2VfZm4oUE1fSU9DVEwsIG5vZGUsDQo+PiBJT0NUTF9TRVRfU0RfQ09ORklH
LA0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uZmlnLCB2YWx1ZSwg
TlVMTCk7IH0NCj4+PiArRVhQT1JUX1NZTUJPTF9HUEwoenlucW1wX3BtX3NldF9zZF9jb25maWcp
Ow0KPj4+ICsNCj4+PiArLyoqDQo+Pj4gKyAqIHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyAtIFBN
IGNhbGwgdG8gc2V0IHZhbHVlIG9mIEdFTSBjb25maWcNCj4+IHJlZ2lzdGVycw0KPj4+ICsgKiBA
bm9kZTogICAgICBHRU0gbm9kZSBJRA0KPj4+ICsgKiBAY29uZmlnOiAgICBUaGUgY29uZmlnIHR5
cGUgb2YgR0VNIHJlZ2lzdGVycw0KPj4+ICsgKiBAdmFsdWU6ICAgICBWYWx1ZSB0byBiZSBzZXQN
Cj4+PiArICoNCj4+PiArICogUmV0dXJuOiAgICAgUmV0dXJucyAwIG9uIHN1Y2Nlc3Mgb3IgZXJy
b3IgdmFsdWUgb24gZmFpbHVyZS4NCj4+PiArICovDQo+Pj4gK2ludCB6eW5xbXBfcG1fc2V0X2dl
bV9jb25maWcodTMyIG5vZGUsIGVudW0gcG1fZ2VtX2NvbmZpZ190eXBlDQo+PiBjb25maWcsDQo+
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICB1MzIgdmFsdWUpIHsNCj4+PiArICAgICAg
IHJldHVybiB6eW5xbXBfcG1faW52b2tlX2ZuKFBNX0lPQ1RMLCBub2RlLA0KPj4gSU9DVExfU0VU
X0dFTV9DT05GSUcsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25m
aWcsIHZhbHVlLCBOVUxMKTsgfQ0KPj4+ICtFWFBPUlRfU1lNQk9MX0dQTCh6eW5xbXBfcG1fc2V0
X2dlbV9jb25maWcpOw0KPj4+ICsNCj4+PiArLyoqDQo+Pj4gICAqIHN0cnVjdCB6eW5xbXBfcG1f
c2h1dGRvd25fc2NvcGUgLSBTdHJ1Y3QgZm9yIHNodXRkb3duIHNjb3BlDQo+Pj4gICAqIEBzdWJ0
eXBlOiAgIFNodXRkb3duIHN1YnR5cGUNCj4+PiAgICogQG5hbWU6ICAgICAgTWF0Y2hpbmcgc3Ry
aW5nIGZvciBzY29wZSBhcmd1bWVudA0KPj4+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L2Zp
cm13YXJlL3hsbngtenlucW1wLmgNCj4+PiBiL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16
eW5xbXAuaA0KPj4+IGluZGV4IDFlYzczZDUzNTJjMy4uMDYzYTkzYzEzM2YxIDEwMDY0NA0KPj4+
IC0tLSBhL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0KPj4+ICsrKyBiL2lu
Y2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0KPj4+IEBAIC0xNTIsNiArMTUyLDkg
QEAgZW51bSBwbV9pb2N0bF9pZCB7DQo+Pj4gICAgICAgICAvKiBSdW50aW1lIGZlYXR1cmUgY29u
ZmlndXJhdGlvbiAqLw0KPj4+ICAgICAgICAgSU9DVExfU0VUX0ZFQVRVUkVfQ09ORklHID0gMjYs
DQo+Pj4gICAgICAgICBJT0NUTF9HRVRfRkVBVFVSRV9DT05GSUcgPSAyNywNCj4+PiArICAgICAg
IC8qIER5bmFtaWMgU0QvR0VNIGNvbmZpZ3VyYXRpb24gKi8NCj4+PiArICAgICAgIElPQ1RMX1NF
VF9TRF9DT05GSUcgPSAzMCwNCj4+PiArICAgICAgIElPQ1RMX1NFVF9HRU1fQ09ORklHID0gMzEs
DQo+Pj4gIH07DQo+Pj4NCj4+PiAgZW51bSBwbV9xdWVyeV9pZCB7DQo+Pj4gQEAgLTM5Myw2ICsz
OTYsMTggQEAgZW51bSBwbV9mZWF0dXJlX2NvbmZpZ19pZCB7DQo+Pj4gICAgICAgICBQTV9GRUFU
VVJFX0VYVFdEVF9WQUxVRSA9IDQsDQo+Pj4gIH07DQo+Pj4NCj4+PiArZW51bSBwbV9zZF9jb25m
aWdfdHlwZSB7DQo+Pj4gKyAgICAgICBTRF9DT05GSUdfRU1NQ19TRUwgPSAxLCAvKiBUbyBzZXQg
U0RfRU1NQ19TRUwgaW4gQ1RSTF9SRUdfU0QNCj4+IGFuZCBTRF9TTE9UVFlQRSAqLw0KPj4+ICsg
ICAgICAgU0RfQ09ORklHX0JBU0VDTEsgPSAyLCAvKiBUbyBzZXQgU0RfQkFTRUNMSyBpbiBTRF9D
T05GSUdfUkVHMQ0KPj4gKi8NCj4+PiArICAgICAgIFNEX0NPTkZJR184QklUID0gMywgLyogVG8g
c2V0IFNEXzhCSVQgaW4gU0RfQ09ORklHX1JFRzIgKi8NCj4+PiArICAgICAgIFNEX0NPTkZJR19G
SVhFRCA9IDQsIC8qIFRvIHNldCBmaXhlZCBjb25maWcgcmVnaXN0ZXJzICovIH07DQo+Pj4gKw0K
Pj4+ICtlbnVtIHBtX2dlbV9jb25maWdfdHlwZSB7DQo+Pj4gKyAgICAgICBHRU1fQ09ORklHX1NH
TUlJX01PREUgPSAxLCAvKiBUbyBzZXQgR0VNX1NHTUlJX01PREUgaW4NCj4+IEdFTV9DTEtfQ1RS
TCByZWdpc3RlciAqLw0KPj4+ICsgICAgICAgR0VNX0NPTkZJR19GSVhFRCA9IDIsIC8qIFRvIHNl
dCBmaXhlZCBjb25maWcgcmVnaXN0ZXJzICovIH07DQo+Pg0KPj4gQXMgeW91IGFkYXB0ZWQga2Vy
bmVsIHN0eWxlIGRvY3VtZW50YXRpb24gZm9yIHRoZSByZXN0IG9mIGNvZGUgYWRkZWQgaW4gdGhp
cw0KPj4gcGF0Y2ggeW91IGNhbiBmb2xsb3cgdGhpcyBydWxlcyBmb3IgZW51bXMsIHRvby4NCj4g
DQo+IFdoaWNoIHBhcnRpY3VsYXIgc3R5bGUgaXNzdWUgeW91IGFyZSBtZW50aW9uaW5nIGhlcmU/
DQoNCkknbSB0YWxraW5nIGFib3V0Og0KDQpodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20v
bGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQvdHJlZS9Eb2N1bWVudGF0aW9uL2Rv
Yy1ndWlkZS9rZXJuZWwtZG9jLnJzdCNuMTY5DQoNCiBUaGVyZSBpcyBhIHRhYg0KPiBiZWZvcmUg
R0VNX0NPTkZJR18qIGVudW0gbWVtYmVyIGFuZCBhbHNvIGNoZWNrcGF0Y2ggIC0tc3RyaWN0DQo+
IHJlcG9ydCBubyBpc3N1ZXMuDQoNCllvdSBoYXZlIHRoaXMgZm9yIGZ1bmN0aW9uczoNCisvKioN
CisgKiB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWcgLSBQTSBjYWxsIHRvIHNldCB2YWx1ZSBvZiBH
RU0gY29uZmlnIHJlZ2lzdGVycw0KKyAqIEBub2RlOiAgICAgIEdFTSBub2RlIElEDQorICogQGNv
bmZpZzogICAgVGhlIGNvbmZpZyB0eXBlIG9mIEdFTSByZWdpc3RlcnMNCisgKiBAdmFsdWU6ICAg
ICBWYWx1ZSB0byBiZSBzZXQNCisgKg0KKyAqIFJldHVybjogICAgIFJldHVybnMgMCBvbiBzdWNj
ZXNzIG9yIGVycm9yIHZhbHVlIG9uIGZhaWx1cmUuDQorICovDQoNCkFuZCBzb21lIHN0cnVjdHVy
ZXMgaW4gdGhlIGZpbGUgYXJlIHVzaW5nIGl0LCBlLmcuOg0KDQovKioNCg0KICogc3RydWN0IHp5
bnFtcF9wbV9xdWVyeV9kYXRhIC0gUE0gcXVlcnkgZGF0YQ0KDQogKiBAcWlkOiAgICAgICAgcXVl
cnkgSUQNCg0KICogQGFyZzE6ICAgICAgIEFyZ3VtZW50IDEgb2YgcXVlcnkgZGF0YQ0KDQogKiBA
YXJnMjogICAgICAgQXJndW1lbnQgMiBvZiBxdWVyeSBkYXRhDQoNCiAqIEBhcmczOiAgICAgICBB
cmd1bWVudCAzIG9mIHF1ZXJ5IGRhdGENCg0KICovDQoNCg0KPiANCj4+DQo+Pj4gKw0KPj4+ICAv
KioNCj4+PiAgICogc3RydWN0IHp5bnFtcF9wbV9xdWVyeV9kYXRhIC0gUE0gcXVlcnkgZGF0YQ0K
Pj4+ICAgKiBAcWlkOiAgICAgICBxdWVyeSBJRA0KPj4+IEBAIC00NjgsNiArNDgzLDkgQEAgaW50
IHp5bnFtcF9wbV9mZWF0dXJlKGNvbnN0IHUzMiBhcGlfaWQpOyAgaW50DQo+Pj4genlucW1wX3Bt
X2lzX2Z1bmN0aW9uX3N1cHBvcnRlZChjb25zdCB1MzIgYXBpX2lkLCBjb25zdCB1MzIgaWQpOyAg
aW50DQo+Pj4genlucW1wX3BtX3NldF9mZWF0dXJlX2NvbmZpZyhlbnVtIHBtX2ZlYXR1cmVfY29u
ZmlnX2lkIGlkLCB1MzINCj4+IHZhbHVlKTsNCj4+PiBpbnQgenlucW1wX3BtX2dldF9mZWF0dXJl
X2NvbmZpZyhlbnVtIHBtX2ZlYXR1cmVfY29uZmlnX2lkIGlkLCB1MzINCj4+PiAqcGF5bG9hZCk7
DQo+Pj4gK2ludCB6eW5xbXBfcG1fc2V0X3NkX2NvbmZpZyh1MzIgbm9kZSwgZW51bSBwbV9zZF9j
b25maWdfdHlwZQ0KPj4gY29uZmlnLA0KPj4+ICt1MzIgdmFsdWUpOyBpbnQgenlucW1wX3BtX3Nl
dF9nZW1fY29uZmlnKHUzMiBub2RlLCBlbnVtDQo+PiBwbV9nZW1fY29uZmlnX3R5cGUgY29uZmln
LA0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgdTMyIHZhbHVlKTsNCj4+PiAgI2Vs
c2UNCj4+PiAgc3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX2dldF9hcGlfdmVyc2lvbih1MzIg
KnZlcnNpb24pICB7IEBADQo+Pj4gLTczMyw2ICs3NTEsMjEgQEAgc3RhdGljIGlubGluZSBpbnQg
enlucW1wX3BtX2dldF9mZWF0dXJlX2NvbmZpZyhlbnVtDQo+Pj4gcG1fZmVhdHVyZV9jb25maWdf
aWQgaWQsICB7DQo+Pj4gICAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4+PiAgfQ0KPj4+ICsNCj4+
PiArc3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX3NldF9zZF9jb25maWcodTMyIG5vZGUsDQo+
Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgZW51bSBwbV9zZF9j
b25maWdfdHlwZSBjb25maWcsDQo+Pj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdTMyIHZhbHVlKSB7DQo+Pj4gKyAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4+PiAr
fQ0KPj4+ICsNCj4+PiArc3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX3NldF9nZW1fY29uZmln
KHUzMiBub2RlLA0KPj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBlbnVtIHBtX2dlbV9jb25maWdfdHlwZSBjb25maWcsDQo+Pj4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIHUzMiB2YWx1ZSkgew0KPj4+ICsgICAgICAgcmV0dXJu
IC1FTk9ERVY7DQo+Pj4gK30NCj4+PiArDQo+Pj4gICNlbmRpZg0KPj4+DQo+Pj4gICNlbmRpZiAv
KiBfX0ZJUk1XQVJFX1pZTlFNUF9IX18gKi8NCj4+PiAtLQ0KPj4+IDIuMS4xDQo+Pj4NCj4gDQoN
Cg==
