Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301BC6C7663
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 04:51:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjCXDv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 23:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230471AbjCXDvy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 23:51:54 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7247510F7;
        Thu, 23 Mar 2023 20:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1679629912; x=1711165912;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=bD+yCOW2Ar2cjNUDPIyQeZcYWNH1RPhBGs+TPTEdJh4=;
  b=Kn16vHpnDd34bJf+EhVW8JJFElma4F0yrkVLOPYvUBbzL27LzgY83DpE
   Ssn4pjbYtCwXbQ/3N+Ro+h02p6DrKEA1arnoUf5Eh5oXa7gKs6Q3X58I6
   SwWY/3V1DLKEFqXFAk5yovctb/cx8wATqFLqJdQ+nPJ8rmEiJSq2/IM09
   iI/Gc3G3NijUSipsyiws6OJ6CKs6GnXVP9FaILlhh9nYPpkP3wWeSl0kN
   7zC6HRdEIxA7WkmGHtBTHn4N0iZjcunLlEiAxVqpn6h2GWK+caDkwZ7wK
   rCZZJRnTFsBKzU4uoW57X6BWcSyENR1gXFGpKyQsncn0a4Sa8Ypj/81MG
   A==;
X-IronPort-AV: E=Sophos;i="5.98,286,1673938800"; 
   d="scan'208";a="203203635"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Mar 2023 20:51:51 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 23 Mar 2023 20:51:51 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Thu, 23 Mar 2023 20:51:50 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XuwYiZEuhcBR8vGfZCuPFhfUAP1QqMG8tXu7rMshmdg3rdAhNugStB41tmEOZkBlt+0UiJi7bKueGwJCzeUFSAWFKz1NswBAgZHOOUTiDxoGf/NYgAnPoMX980aFJcvBCK2GgKLQeXzkFEx72cwMnJ62VQAJu6Z7ikb6fcnij9035jxddLR6WBg6WV6kuSqGIzq/goTLAG/Xl3pZt9rX8F66zXzwR4rq5l9xJQwB4DRYcnK8OG3s1Nf8B0y6jTo+EaqSEN3ifVqHZtBmVDK+X1ZPffFBQIRuvkPbHNMWzFlg0wnHARJJRA9T1Q+a/Kz1pHLu4vIyEHWFCq52SgGEyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bD+yCOW2Ar2cjNUDPIyQeZcYWNH1RPhBGs+TPTEdJh4=;
 b=Okrr7xgpNpnlv7BSSJyEisX5fuNLh8ZS0En/B6KeGhW+lWIvQ1LhjBGaIiMXtaiNe6fFSt+QI0wc5tuWZ/c7qkPmEpMMP8YGxne+2I/CcyzsGioa3DtFI1uc8xOyXcU0Rwg7xPDKEYc3j9Z5PCXb28oCVKgJvlPvOdvHa6pRhPGd13Wq8oq9sUPIFLdK7rD9zQq29Jezpu486ctlU7bjdgd0OSqRVuxCaK4rNM+Gtmo0Xgs6EVqxQQWNmF7zn6OVVy71itN+T6X+w7GKVKs98e/lG/0TbgXehKFfhlWJAy7/PHfc1XmLT40ueXwZb9uumMMiNcfXbO8a3iKHtum3aw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bD+yCOW2Ar2cjNUDPIyQeZcYWNH1RPhBGs+TPTEdJh4=;
 b=UaMwkbGKPJQsfTIKJFcuHDlx3+XYyIiLlsJ6pjrvcMRJ0dYt6gu/y+nuf/3ywMk5rcyiXqmzJw79GcCJQQjVp85p2kvQu2SCNOq1gjoMzMFPcLzwjXHraPbzIxdywARux2GNZxtS0dypLuKtPaZUgGg+S/+FEnnix2xbbFUbTjs=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SN7PR11MB6971.namprd11.prod.outlook.com (2603:10b6:806:2ab::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Fri, 24 Mar
 2023 03:51:49 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.037; Fri, 24 Mar 2023
 03:51:48 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <andrew@lunn.ch>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <kernel@pengutronix.de>
Subject: Re: [PATCH net v1 2/6] net: dsa: microchip: ksz8: fix ksz8_fdb_dump()
 to extract all 1024 entries
Thread-Topic: [PATCH net v1 2/6] net: dsa: microchip: ksz8: fix
 ksz8_fdb_dump() to extract all 1024 entries
Thread-Index: AQHZXMsdC0CJdB9wWUmYvQ/9XhvICa8JTlQA
Date:   Fri, 24 Mar 2023 03:51:48 +0000
Message-ID: <e29999b013544987c796967f32130f608aabe311.camel@microchip.com>
References: <20230322143130.1432106-1-o.rempel@pengutronix.de>
         <20230322143130.1432106-3-o.rempel@pengutronix.de>
In-Reply-To: <20230322143130.1432106-3-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SN7PR11MB6971:EE_
x-ms-office365-filtering-correlation-id: 71720009-849f-41a1-147b-08db2c1b184c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IrAA90x0Tgi1LntqsD9dHuqEeEegFAptu2IprL17a2DnYS9OSkqT7vOQ5QysdsGFRtdRHJkTsfvOGpDGfwwqe8sbq3GWBQOIfXdRDJ3SCXqmMBmaIT8gA+bnxyLDUVa0m7h8Y3qZagiptmMUs4CrZwQT/0hibyqmraMox4R52DXPOa/ZetRe68Zrse2UWIM1EyAqGRzYKDD+FBQ8bXw/f4ERUKb4QLZtK+K83CvN0W+/FDoCzkozrgKmR0IYoiDgm+7/k8DwzrIofasz/sxw1kJSP7LNxr8130qePtqyQNOrqzGuxB0uGnpjHhpScqdtMKgh8SfeiHn1HgLW310VZ+bvGSrba/QKkuyK27GRqWwZX37z4MIFOXDWJjCy3B1duhWXbrRGWv2GXOZMi/f4IqxjUueBuCI1Sgm1N7s+PGFRtIJr2CUHxU7rJBVSimjmEoxlLJJjx/1tcsioedXtXkFUXothMvkkEadlI5w9r49a/1j/2RyDyBq7ZDg3xQET8MCOzuik/Sbkg9bW7bRSELtojrSjz824LKtRNdPq9ffjnWfCKfhfNCUEtNH1r+LcX31FRXu6XhC83m27WjLyxvzWnm4PKuK1QbH5AJPi7vmJPAR7jxrYCwDW3MEA6P+4Z16LPb5QF6kK6lzEXhTCPGJpQY1F+PMq0nm0PlVKwKh70i/tEQvUAo+UqYH6cRbDp3EFaubrqzSo560qtWBXBcL4XHfMQNI/bNyDnzOwgJw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(346002)(39860400002)(366004)(376002)(136003)(451199018)(76116006)(4326008)(66556008)(8936002)(66476007)(66946007)(41300700001)(91956017)(8676002)(64756008)(86362001)(36756003)(66446008)(122000001)(26005)(6512007)(6506007)(38070700005)(2616005)(83380400001)(186003)(71200400001)(6486002)(316002)(110136005)(478600001)(54906003)(38100700002)(2906002)(7416002)(5660300002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0p0eW51d3FzTjNOTUl2ZTNXUWxjNHVZNnY1Q0dudGE4V0RwM09aWU9CNGJa?=
 =?utf-8?B?V2VFbmJrUWxSVXcxK2FVZ3lSMDF0eUhZWlUxcVlySGRWM0N0ajVmbjZOdDkz?=
 =?utf-8?B?b1haRVpQcjZTQTNaa1JLWmRTUlErYVpBczJSSHdZSGt1WGk2ZjJjK09iT0Uz?=
 =?utf-8?B?allTd0Vka2VtaFBnUmhyNlJzeGZvOW9iV1BjYnhLbWxwcGFzWDRrb0RmZmJL?=
 =?utf-8?B?YklhU25vYnc2bC9YUmZEaHVOSU9Hc2VuaE5xNS8walVkVUZGTVVrd1FpbDN1?=
 =?utf-8?B?UXZ5cFFPSlQzV09YdElUM2RhSERUT1ZUUHRPMXFkUThwTVhmOGNFWkVJRTFB?=
 =?utf-8?B?enFKU1VBZUxrTm9ESEcrb3c3MlN6Nng5TVpVN2lrZHpIR1J6Ukp1VTZoL21Q?=
 =?utf-8?B?Nms2N296WjBLR05XRTJxdW9iTkhwSlhXWENuVVpKempKS2xwbVFmL1F1dEIz?=
 =?utf-8?B?elQzdXlneVVEN3lhYTd5M1Fla1VZTGJtWklCSXRTZGY0ZVVXUXFpT0QvRHJj?=
 =?utf-8?B?Y1BndHlISmxhQTU1b0xLRjM3QkdPMU1EamJGbXFnelp2N1duVmc3TVNIOW55?=
 =?utf-8?B?Y1dYcFhHQmlnd3JEaGh4VGZ5R0k5L0lPdkJkMy9veFFTOXV2aTdlWldnanBT?=
 =?utf-8?B?Z0hRZGZWVThKb1hiNFk1WlltK3YycHdIQ0lEQWFZWHNMTENPclRYU2Iwa1Rh?=
 =?utf-8?B?bkhDQ0dONUdYUVRiV2FUVDhNdTA2VmtQa25XaGNadDMrdlNVempnOExIclM3?=
 =?utf-8?B?Y0Znc3dFKzd2TnVidHB3T2dsMUVhUjNjWGo0TnpsaGprSDFLYjlUY1pJV045?=
 =?utf-8?B?QUIwdXdJTk9tT00raDFWa2RpcnVpTlEwemhNUTVVYnFUSkJoc1VKSXZ2ZzZO?=
 =?utf-8?B?VHNhUmk1TDhqL3J2RGp1Z2NNUm9JbVREelVEVkpxaEE1dDBNZGRpR2FBcVBw?=
 =?utf-8?B?N1FReXVTcXY0U1pEQTN4eWo2ZCthRFY1WUl0NHMwRHJ6MTdYZ3FVR1pLTHFj?=
 =?utf-8?B?Qy8xZ0tlY1g1T2xGUzBvcEM0K1Iyc0dMckR2Y2VTUmxwTGkzaGlSbVFKdWpC?=
 =?utf-8?B?bXV5dXk2RnFZTUZHSW1kZUp2c1pZaStGVU9QdmlUM2NQRzZQWXhIcS9QUWg4?=
 =?utf-8?B?Y1ZDM1EzdHpkdDhUZDFVekVraEZZcXhQNTF6bDlwbU5hOHZ0eTA5RDB4UVhR?=
 =?utf-8?B?RG1hUWJGcEFiWnFhbEF6RHZKaExPRk9CaGZCcGlqU1dDNHh4WHBuRHhERWd3?=
 =?utf-8?B?YzFzM2lEelRmcklNWi9xQUpZR1d4SW8zZ3MvZzNrVUQySnIyQzYyNFh4U0gw?=
 =?utf-8?B?RmtZcjJSdmtnVWJZTU5Sd0Q3WGZqZXV5Qm1tRVB4VVd0ZzV4cGw5ZXgzK2VB?=
 =?utf-8?B?U2pjY2MreUlaNkJRMmlpQzR1MXRsd1FSVWpvRlF5bDZKbTBtMXFIWkJ0S0pr?=
 =?utf-8?B?QUZSVkZVdDdxVUJ4UUNVTWNqK1oxYzFGWk5FY1pQcXhaQXFiUGN3VFc1eEsv?=
 =?utf-8?B?d1lMaWxtN09WcEJMTTcybEhETUdjcmwycUk2WFBrTG5Nd2UrRWhzNG1FbFJR?=
 =?utf-8?B?aGZyKzhJUU8wVTRIMzBhWm9leXBXbUlGZGgwbFE3OGRNR2UyeU5ZbGVXV1Ju?=
 =?utf-8?B?V3JpSUJBU2J5OWQ2RE84K3VKZEkraGpwc1hNQWdrNDRkYmhaemJpUEU2VDdU?=
 =?utf-8?B?SXRvWXBZRXhtQlIyMnBuTks0MEZlaHNWcWhjYzJCa3dvN0N4Ni95NWpySnNn?=
 =?utf-8?B?ZDE1SXJaY2h4VnVBcytGd0tXazRCWkNlZ054Q3lHSmRrNXJiQzVEOWdrTWM0?=
 =?utf-8?B?Wi92OUtDTDhxMldIQnNNR1BNK25EeUYvWjFqMWZVQzFnTkV6MS9OM1JJUmNC?=
 =?utf-8?B?VlNuelJweTIrbGVwWXFRY1dMNlh6SmZmZnAyNVovMjRzL2IzN0NnWnJ2OEpH?=
 =?utf-8?B?eUdGWVczY3BucmVyWStnb3NLUDNFZllvdU05L3VpbXJRcFFCV2RpcHRyUTJD?=
 =?utf-8?B?c3B4S1pUZ0VzeWtFdlo2S3F4aFMxZzdTRXM3RnVTQUdiVFlOUjl6dndXOW90?=
 =?utf-8?B?OTFSbG5MWlNSME92bTl3UHRCQWxrMDN3SG9tVjZWMXFJaEtleW9PZE1jQ3V0?=
 =?utf-8?B?WFFvV256TWpjbU1RQ0VPYnB5SWNIWDMvUUd4dDZDTXpqdEZKMmlDNjVTQU9K?=
 =?utf-8?Q?yNvGwmYgMWkRzpp15CmD8N4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <454318382963F14087B1E413EC507ECB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71720009-849f-41a1-147b-08db2c1b184c
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2023 03:51:48.6122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LO6u2+Cved3R2/VkfbIJ7G2K6gm+zAmu61O6vCj+TvJXSpzUaG8UNY+qxCFzw4s0cNe9qn2ulKx5k+JuEO6KUWinDjZaIb5tEGv1ZaKFgio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6971
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gV2VkLCAyMDIzLTAzLTIyIGF0IDE1OjMxICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBDdXJyZW50IGtzejhfZmRiX2R1bXAoKSBpcyBhYmxlIHRvIGV4dHJhY3Qgb25seSBtYXgg
MjQ5IGVudHJpZXMgb24NCj4gdGhlIGtzejg4NjMva3N6ODg3MyBzZXJpZXMgb2Ygc3dpdGNoZXMu
IFRoaXMgaGFwcGVuZWQgZHVlIHRvIHdyb25nDQo+IGJpdCBtYXNrIGFuZCBvZmZzZXQgY2FsY3Vs
YXRpb24uDQo+IA0KPiBUaGlzIGNvbW1pdCBjb3JyZWN0cyB0aGUgaXNzdWUgYW5kIGFsbG93cyBm
b3IgdGhlIGNvbXBsZXRlIGV4dHJhY3Rpb24NCj4gb2YNCj4gYWxsIDEwMjQgZW50cmllcy4NCj4g
DQo+IEZpeGVzOiBkMjNhNWUxODYwNmMgKCJuZXQ6IGRzYTogbWljcm9jaGlwOiBtb3ZlIGtzejgt
Pm1hc2tzIHRvDQo+IGtzel9jb21tb24iKQ0KPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBl
bCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3pfY29tbW9uLmMgfCA2ICsrKy0tLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6X2NvbW1vbi5jDQo+IGluZGV4IDdmYzIxNTVkOTNkNi4uM2ExYWZjOWY0NjIxIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiArKysg
Yi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiBAQCAtNDA3LDEwICs0
MDcsMTAgQEAgc3RhdGljIGNvbnN0IHUzMiBrc3o4ODYzX21hc2tzW10gPSB7DQo+ICAgICAgICAg
W1NUQVRJQ19NQUNfVEFCTEVfRklEXSAgICAgICAgICA9IEdFTk1BU0soMjksIDI2KSwNCj4gICAg
ICAgICBbU1RBVElDX01BQ19UQUJMRV9PVkVSUklERV0gICAgID0gQklUKDIwKSwNCj4gICAgICAg
ICBbU1RBVElDX01BQ19UQUJMRV9GV0RfUE9SVFNdICAgID0gR0VOTUFTSygxOCwgMTYpLA0KPiAt
ICAgICAgIFtEWU5BTUlDX01BQ19UQUJMRV9FTlRSSUVTX0hdICAgPSBHRU5NQVNLKDUsIDApLA0K
PiArICAgICAgIFtEWU5BTUlDX01BQ19UQUJMRV9FTlRSSUVTX0hdICAgPSBHRU5NQVNLKDEsIDAp
LA0KPiAgICAgICAgIFtEWU5BTUlDX01BQ19UQUJMRV9NQUNfRU1QVFldICAgPSBCSVQoNyksDQo+
ICAgICAgICAgW0RZTkFNSUNfTUFDX1RBQkxFX05PVF9SRUFEWV0gICA9IEJJVCg3KSwNCj4gLSAg
ICAgICBbRFlOQU1JQ19NQUNfVEFCTEVfRU5UUklFU10gICAgID0gR0VOTUFTSygzMSwgMjgpLA0K
PiArICAgICAgIFtEWU5BTUlDX01BQ19UQUJMRV9FTlRSSUVTXSAgICAgPSBHRU5NQVNLKDMxLCAy
NCksDQo+ICAgICAgICAgW0RZTkFNSUNfTUFDX1RBQkxFX0ZJRF0gICAgICAgICA9IEdFTk1BU0so
MTksIDE2KSwNCj4gICAgICAgICBbRFlOQU1JQ19NQUNfVEFCTEVfU1JDX1BPUlRdICAgID0gR0VO
TUFTSygyMSwgMjApLA0KPiAgICAgICAgIFtEWU5BTUlDX01BQ19UQUJMRV9USU1FU1RBTVBdICAg
PSBHRU5NQVNLKDIzLCAyMiksDQo+IEBAIC00MjAsNyArNDIwLDcgQEAgc3RhdGljIHU4IGtzejg4
NjNfc2hpZnRzW10gPSB7DQo+ICAgICAgICAgW1ZMQU5fVEFCTEVfTUVNQkVSU0hJUF9TXSAgICAg
ICA9IDE2LA0KPiAgICAgICAgIFtTVEFUSUNfTUFDX0ZXRF9QT1JUU10gICAgICAgICAgPSAxNiwN
Cj4gICAgICAgICBbU1RBVElDX01BQ19GSURdICAgICAgICAgICAgICAgID0gMjIsDQo+IC0gICAg
ICAgW0RZTkFNSUNfTUFDX0VOVFJJRVNfSF0gICAgICAgICA9IDMsDQo+ICsgICAgICAgW0RZTkFN
SUNfTUFDX0VOVFJJRVNfSF0gICAgICAgICA9IDgsDQo+ICAgICAgICAgW0RZTkFNSUNfTUFDX0VO
VFJJRVNdICAgICAgICAgICA9IDI0LA0KPiAgICAgICAgIFtEWU5BTUlDX01BQ19GSURdICAgICAg
ICAgICAgICAgPSAxNiwNCj4gICAgICAgICBbRFlOQU1JQ19NQUNfVElNRVNUQU1QXSAgICAgICAg
ID0gMjQsDQoNCkNyb3NzIHZlcmlmaWVkIHRoZSBhYm92ZSBlbnRyaWVzIHdpdGggZGF0YXNoZWV0
LiANCg0KQXMgSmFrdWIgbWVudGlvbmVkLCBhYm92ZSBmaXggY29tbWl0IGlzIGp1c3QgY29kZSBt
b3ZlbWVudCBmcm9tDQprc3o4Nzk1LmMgdG8ga3N6X2NvbW1vbi4gDQoNCk90aGVyIHRoYW4gRml4
IGNvbW1pdCwgcGF0Y2ggTG9va3MgZ29vZCB0byBtZS4NCg0KQWNrZWQtYnk6IEFydW4gUmFtYWRv
c3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCg0KPiAtLQ0KPiAyLjMwLjINCj4gDQo=
