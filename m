Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8426B638B80
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 14:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbiKYNqm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 08:46:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229838AbiKYNqk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 08:46:40 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44FF029353;
        Fri, 25 Nov 2022 05:46:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669383998; x=1700919998;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=kOC9ROjbdJ2WJG/Hq1FHytSv7atvH7WyEgXCsz3UqFI=;
  b=Q5r93lSlnNCvKEyykppGNCxD0I5bNwlbyU4PL2+LPuxJNxDhUsuY2cud
   RAikPuFlP9D/y1bwdzA7ZH5Hjq47QTQd45WFFRWrkPDgEeaqfEoB5NMzT
   SuJh7K3MLc6qHxdnCHBbIbMk4XcOoENGp1Dc//QNPvDOJTEF04Cp9sTLq
   TlYJguCz+R1zdFRVtDYj9AqemP5gKVf0OdFlV6M9WNYCp8lI+naX+URMA
   2PjqdyccVWeeKas2gHW4fy/jOzw80a4ldfyhUTz3TjyF4BIpl1LbFq1DW
   SIfbVsmmGkCWBk9UUDZFCqPKv/qX7xM+E5+rqLrPb7TzrS9HQOLPpwR9K
   A==;
X-IronPort-AV: E=Sophos;i="5.96,193,1665471600"; 
   d="scan'208";a="125110454"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 06:46:37 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 06:46:37 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.12 via Frontend
 Transport; Fri, 25 Nov 2022 06:46:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XdaxHVX32csPVhMLav6nDRX3shHkMmHBuHulF3yZdAWg11Oxtv23utAEDe+QnFp+MKVdkprapcZyWHaoBIBQxkTi6bK6WjQ9lGNY6uDI7ig5oEdIt4a0Gct4DqUZYXpIp2nCAMVbTrVsDKeb7jBkwhcpIlvb5F7cffj8RAGG6F7l+f92j2TJdgVjtbUU4Yh7spkL3hRnIG8qWvy5gMCVwS//1gbfvRwV2GGVYw8HBW3qcuNjogr81NmRjaJl4TN8BLa0/xoPjFoKunRIGZw5tGoVZCy+3cmdNK3yFglgAKwozBp1A4nSMV/nnNVFgAx54Waavd2c1rE9lkI6YRlSOw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOC9ROjbdJ2WJG/Hq1FHytSv7atvH7WyEgXCsz3UqFI=;
 b=DigO5ZUPY5GNzPiIfJHAYwBYMCLjGRvkF5soykm0+LSP5rmLDxGzhdPSEpecbi7LgKXmS8c9s68pdI1a7g2OekkYjcHs/uANmShhISKGdaAXg65W4V5DNdY8r4iB6aWLxlv1T7raDAkBl+AdZI4PfmMLpLeg2H3d8gfqce/Jz8PKYiNHuT+0TdEk8YZR9Mxew8LMgXHRCXk9r2v56nNd+JFoLxgeBU1wtbDyoJBw31bPeQMjAlXt6rJ/FwCTzcWCpmeFnZVk6FMOTphHkC/1mGsKWuHXQzN69eB+vBeY/cJ7Ru4tCpR7p3/OtjptS3gdtAceJX32b12zeT3HUCKuaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOC9ROjbdJ2WJG/Hq1FHytSv7atvH7WyEgXCsz3UqFI=;
 b=L4WLnTae+7+iFTrTBirt8IpiKQBBA8RMFjXAGM1TLnomuFlpa3FOMa/HAIoe8/x4AVioYJaaXoq6wZ15Q3gYU/7A3154FPHkm4TbRmlaw3v7bmpgKG6qSTMHae9Pavg+vnI2/IYtZBP7klRJrn0KpjzFLXbdj2p+ruUoFQj78Gs=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 IA1PR11MB7320.namprd11.prod.outlook.com (2603:10b6:208:424::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 13:46:35 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Fri, 25 Nov 2022
 13:46:34 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <o.rempel@pengutronix.de>
CC:     <andrew@lunn.ch>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <olteanv@gmail.com>,
        <vivien.didelot@gmail.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Thread-Topic: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Thread-Index: AQHY/+3FigeduKl0pEWlWfqldCou765OLIIAgAD35ACAABbegIAATl2AgAAfK4A=
Date:   Fri, 25 Nov 2022 13:46:34 +0000
Message-ID: <62117bf174509842dc393e8f226aaeb62530b44e.camel@microchip.com>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
         <20221124101458.3353902-7-o.rempel@pengutronix.de>
         <e270aedb761cad689ee969285ac07578848e2ae5.camel@microchip.com>
         <20221125055240.GA22688@pengutronix.de>
         <439da76d5f0fb800f11cec66c06a444a7a4e591a.camel@microchip.com>
         <20221125115459.GD22688@pengutronix.de>
In-Reply-To: <20221125115459.GD22688@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|IA1PR11MB7320:EE_
x-ms-office365-filtering-correlation-id: 53a3a9eb-2e61-4e68-864e-08daceeb77a8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YY4//1bCODEP1jgUoUCf8B8EHbYoF2AZUb0fgikd0oKfBHrVAiypbSUwG06Wls47lyXS+zQQ91EkRxCnOxs1sdHMyhFLHNWB+/otnn5tavX85dCETHJjbi4SzLsc3vKvaern9+e3mBV9/s7219j9Qv7OLox1VmdRFfV3LUmF1PFIbI0Jr+fCYAo0jmePhN3QGLHp/6RenxqY37BfFE4D71cf8DyPVQJ97bfcE1CkvD+6qtlmL4aLhTuddlDV8rPpnutcgb/UBn4aMF2Uc3z6TdXU+IGFuxlMU9j3k3ws1618Jo+MjgaKEVoW1G48AUH4zOlcPDK0khs77HQgaWHiUuk19JPLyWU3d4sOrMTCQGwrydKN3SVuWleyXtlewjDMdyiEOEJhjRHotzb8xGMh8fzOvl24wJ2DIP1kD5swyFYy6QVDVKZXJ8uRjM0RRpjFTrcUzmb3jaSJjDWKH19tGhnTmGSPQ2w+eupZ2Y7fr8DCIoyC0F0hamz7MGZu2fvPux0lTUZ8TcynqG+897CLX9Y4uE5H3Xr46K90ZhGPa/VVueufc+k3uYBRpRofyqV6IlfSKHSxt9ToKjxL2xVH50lOJNQ5vNWIfoC8tPQHu3p7OiArgyUwyy/s6Pym9XTgX8iBIwAc0aR3xELuLBg1bKzbfuViOwQBzC6ONFSAuIHcTIdW23pTIU+GGrMPsBbinnBvv5jsJhd8eLh1F1ZrVL4b6XMu9bXKkKUEkQpwCoSurPTg3WmvYlnDSKydORt1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(39860400002)(376002)(366004)(346002)(451199015)(7416002)(5660300002)(2906002)(4001150100001)(66946007)(64756008)(36756003)(66556008)(83380400001)(91956017)(8676002)(4326008)(76116006)(66446008)(66476007)(86362001)(54906003)(6916009)(316002)(41300700001)(8936002)(6486002)(966005)(478600001)(6506007)(38070700005)(6512007)(2616005)(186003)(38100700002)(71200400001)(122000001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cHdLeDR3WlArRTlJZEtXSGFsRmxDaE5BSXVucmczT1IxZjBjZldubFM4R1B4?=
 =?utf-8?B?VmlXV2F3aWRrcWNSSWFOSVM4RUV2ek5HUEdzYjFOS2xWbElTb0VqNjZ3MDIw?=
 =?utf-8?B?aHlCYTJad2ZIRnUybXZvdGRmZTcyUCtYSk13TE5EVFFaVXk5VWtFa3YrdEsr?=
 =?utf-8?B?eE54ZitSaTBXREJRYVduVmkxb1BFVThnT00vT01iaTEvTUxlQkxvZEFWaTJx?=
 =?utf-8?B?ajhSZ2R0TFQ4aTJZZmNzWDAwenNzMHdtRzR6V3d1Y1hBQ0ErVTd3My9NL2x5?=
 =?utf-8?B?N2h4U0Vhb0MyaS9VQmErNXErUWRMNStoVlJYYjMxeEg1Y3NwQUdqYTVCclBi?=
 =?utf-8?B?aTVpQkNjWGVQa1RUekl0d0Y1OGJxQS8wTlF4V2RWTWxacWRZNnVWTXV2bHNY?=
 =?utf-8?B?TFdQbjFkeEhkdy9vaG5ueTNsTXREK3R0MHNkQjE1RG1mMU83NXN0NHFFdzZY?=
 =?utf-8?B?d25HOWpLcEl3OUFZTThKNy8rR25aenROQ1dmY25mMlNLdkFDcDdkT0x4NFFp?=
 =?utf-8?B?NnY1Ny9BWWxRWGJlZ1pQSDUvZlRwSnBSNTlYRUs1Qm5WSVFaM1R4SUhlREtl?=
 =?utf-8?B?Y1paZTIwSzV0N0dvSktNL2FGRjNRdGZjV3hiVmZQU0d0akFCelZnMTl3dTg5?=
 =?utf-8?B?eERTZG1BTTRCYSthWFcwYmhRRWtnOTZJRTRIbmlzM1I5Q25INXhLK3JaaC9m?=
 =?utf-8?B?WVkwb0RTcHcvcmtQdmFQcGR5OGw2R2l4NExZcUVuTVhCQXNLcVpZRFZwNUtV?=
 =?utf-8?B?UTZ2VitHMXNneE12VHZZUkp5d01uc09ja3FuckR5R0t3OGdSWUZlUTZIdWpL?=
 =?utf-8?B?a0JTclYyRWwyK0Q5Z1ZldHhmSG9Fa2xHeHJ3bnp1bFZzTkVMY1M4S09ZSVVz?=
 =?utf-8?B?UE9ZWC9mUU1OZ2NiRUJPVmxHcjB5c3d2SGV1czduUW5Bb0ZESmhLemViSDN3?=
 =?utf-8?B?aUl4cmdYanhHaCsxdnJEY0tHck5RV05UbnpoL3haajBTVnhaMjQ1TU1vQWl4?=
 =?utf-8?B?WWI1OUh5cnJFR0NKMFV6cWp4NSs3S3JOMHNEMVRZVms4bEpBSTU4c0t3WUR0?=
 =?utf-8?B?c3lURVcwRFVsdTBmaUJ4ZHYwdkVoRGlJZjJsNkNMWU9WMmNPZnRTMndZZEZG?=
 =?utf-8?B?blJmc2VvMmphRlBVTDFnL2ZoSjZTcjE0ZjRBenhBcnF3TEd6RWw2eWxLaHh5?=
 =?utf-8?B?TmN5RVRWazdHTzF1bHAwTDNrQ0FTanVzTitJWTJTYXFwcDJlUUlHSjByZW9n?=
 =?utf-8?B?S1Biek93MkVBeStxWDBGRitTbEdaeVRXRHB3Y0IrSXRnTHNzNGY0Q2QwbEVo?=
 =?utf-8?B?amRsY2xWMWZHT0F2MXFtS3FsRUd4K1RyeUtoUUh6MVl3M2JJV1JzS2xZb1B3?=
 =?utf-8?B?OW83NDJyYW5ESW1RTjdwVlFYWTVoMTRiTEVoWkJPaElqUCtzL2dNckxNVWhD?=
 =?utf-8?B?WFh6Z0VWRlVJVmtrOWxjczdoeHRhcGdSWmM3c0ZiRFBvcFpldnNWNGd3YWsw?=
 =?utf-8?B?eXl1WmRIYVYvUjBrVGpGMHpHVUxqczE0cEprUi9PbWpTQUxQQ3lUZzBBRWh3?=
 =?utf-8?B?b25INGZReDhCK0FMYVh4NHVZbXR1cG5mb0QwZEZBYm5BdUZLeVNrWmEybWdJ?=
 =?utf-8?B?M3lrZGVMS1kxRzMwTTVGbUdtSzRWSG53Szcya0F3NDQyZml4Vyt0eGlqRDRw?=
 =?utf-8?B?K0o2emdWWndJWGlXUkxHS1V6ZlZDT0ZPbE1EYWUva1ZEKzNIcktPcERsdGkr?=
 =?utf-8?B?cG1KdGdaM2dxM2ZzYTgrdXhLeVlDaTJwSVYwU0JoQWYvUEJ2bXVTMEVvU3Vy?=
 =?utf-8?B?b2hLRC9DQnpESFRzWm00UVR4b3BEeXRyL05mdldYOWFnZXdSZzZvSXRlRUVN?=
 =?utf-8?B?LzBLRkRJRXZ1UGlySGg3MWRsU01JbEh4K3kyLzNYSjhXSmMzWFN5UlY0d09t?=
 =?utf-8?B?WlQrbDhlOTQrVk5YZHcrTG05S3h1eXpnM2hFTVJmajkrU0VqbnRjR2tHOVYx?=
 =?utf-8?B?cGxxREpoRjg2M0VqMTlHTGp2MUxwSnRWcGxpUm9MNkZhRTAwNjEzdXMxODVq?=
 =?utf-8?B?d0VBbDRmQjNTQlJwaFgwNEZ5d0FGL2dnbER1dS9LUUlRcFIxa2J3UTVBN1dE?=
 =?utf-8?B?TlFnL05MWXlsM3lLdnJLY3BiNjBlTHEvZmdHeUxUQWVJUGNJVGYwTWJJMktJ?=
 =?utf-8?B?VkN1bmtibEJnazA4Z0pFZ2VzVkk4SldNak5SbWFHM1pzNU5iRG54cVVkb2VH?=
 =?utf-8?Q?WtdRyK5czghYZt/ro8TeK/dK5O+mPGxonQT1bC+DM8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <91821531393B1341A14B2EB4E70FA238@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53a3a9eb-2e61-4e68-864e-08daceeb77a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 13:46:34.6203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A7wL2j2JVxH+P3RXBPw1IzvS5xzVz7bSzSPWQc/GM6oxiJD/Afb1r7d96EDMAr5UtrHY0Jswxc7aSDsoZoTW7XikLJ6RAlmsWAtnbsaotAs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB7320
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTExLTI1IGF0IDEyOjU0ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBGcmksIE5v
diAyNSwgMjAyMiBhdCAwNzoxNDozMkFNICswMDAwLCBBcnVuLlJhbWFkb3NzQG1pY3JvY2hpcC5j
b20NCj4gIHdyb3RlOg0KPiA+IEhpIE9sZWtzaWosDQo+ID4gDQo+ID4gT24gRnJpLCAyMDIyLTEx
LTI1IGF0IDA2OjUyICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToNCj4gPiA+IEVYVEVSTkFM
IEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91
DQo+ID4gPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gPiA+IA0KPiA+ID4gSGkgQXJ1biwN
Cj4gPiA+IA0KPiA+ID4gT24gVGh1LCBOb3YgMjQsIDIwMjIgYXQgMDM6MDU6MjdQTSArMDAwMCwg
DQo+ID4gPiBBcnVuLlJhbWFkb3NzQG1pY3JvY2hpcC5jb20NCj4gPiA+ICB3cm90ZToNCj4gPiA+
ID4gSGkgT2xla3NpaiwNCj4gPiA+ID4gT24gVGh1LCAyMDIyLTExLTI0IGF0IDExOjE0ICswMTAw
LCBPbGVrc2lqIFJlbXBlbCB3cm90ZToNCj4gPiA+ID4gPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90
IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzDQo+ID4gPiA+ID4geW91DQo+
ID4gPiA+ID4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4g
VG8gbWFrZSB0aGUgY29kZSBtb3JlIGNvbXBhcmFibGUgdG8gS1NaOTQ3NyBjb2RlLCBtb3ZlIERT
QQ0KPiA+ID4gPiA+IGNvbmZpZ3VyYXRpb25zIHRvIHRoZSBzYW1lIGxvY2F0aW9uLg0KPiA+ID4g
PiA+IA0KPiA+ID4gPiA+IFNpZ25lZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBw
ZW5ndXRyb25peC5kZT4NCj4gPiA+ID4gPiAtLS0NCj4gPiA+ID4gPiAgZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o4Nzk1LmMgfCAyMCArKysrKysrKysrLS0tLS0tLS0tDQo+ID4gPiA+ID4g
LQ0KPiA+ID4gPiA+ICAxIGZpbGUgY2hhbmdlZCwgMTAgaW5zZXJ0aW9ucygrKSwgMTAgZGVsZXRp
b25zKC0pDQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2Rz
YS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ID4gPiA+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzejg3OTUuYw0KPiA+ID4gPiA+IGluZGV4IDA2MGU0MWI5YjZlZi4uMDAzYjBhYzI4NTRj
IDEwMDY0NA0KPiA+ID4gPiA+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5
NS5jDQo+ID4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMN
Cj4gPiA+ID4gPiBAQCAtMTM1OSw2ICsxMzU5LDE2IEBAIGludCBrc3o4X3NldHVwKHN0cnVjdCBk
c2Ffc3dpdGNoICpkcykNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAgICAgICAgIGRzLT5tdHVfZW5m
b3JjZW1lbnRfaW5ncmVzcyA9IHRydWU7DQo+ID4gPiA+ID4gDQo+ID4gPiA+ID4gKyAgICAgICAv
KiBXZSByZWx5IG9uIHNvZnR3YXJlIHVudGFnZ2luZyBvbiB0aGUgQ1BVIHBvcnQsIHNvDQo+ID4g
PiA+ID4gdGhhdA0KPiA+ID4gPiA+IHdlDQo+ID4gPiA+ID4gKyAgICAgICAgKiBjYW4gc3VwcG9y
dCBib3RoIHRhZ2dlZCBhbmQgdW50YWdnZWQgVkxBTnMNCj4gPiA+ID4gPiArICAgICAgICAqLw0K
PiA+ID4gPiA+ICsgICAgICAgZHMtPnVudGFnX2JyaWRnZV9wdmlkID0gdHJ1ZTsNCj4gPiA+ID4g
PiArDQo+ID4gPiA+ID4gKyAgICAgICAvKiBWTEFOIGZpbHRlcmluZyBpcyBwYXJ0bHkgY29udHJv
bGxlZCBieSB0aGUgZ2xvYmFsDQo+ID4gPiA+ID4gVkxBTg0KPiA+ID4gPiA+ICsgICAgICAgICog
RW5hYmxlIGZsYWcNCj4gPiA+ID4gPiArICAgICAgICAqLw0KPiA+ID4gPiA+ICsgICAgICAgZHMt
PnZsYW5fZmlsdGVyaW5nX2lzX2dsb2JhbCA9IHRydWU7DQo+ID4gPiA+ID4gKw0KPiA+ID4gPiA+
ICAgICAgICAga3N6X2NmZyhkZXYsIFNfUkVQTEFDRV9WSURfQ1RSTCwgU1dfRkxPV19DVFJMLCB0
cnVlKTsNCj4gPiA+ID4gPiANCj4gPiA+ID4gPiAgICAgICAgIC8qIEVuYWJsZSBhdXRvbWF0aWMg
ZmFzdCBhZ2luZyB3aGVuIGxpbmsgY2hhbmdlZA0KPiA+ID4gPiA+IGRldGVjdGVkLiAqLw0KPiA+
ID4gPiA+IEBAIC0xNDE4LDE2ICsxNDI4LDYgQEAgaW50IGtzejhfc3dpdGNoX2luaXQoc3RydWN0
IGtzel9kZXZpY2UNCj4gPiA+ID4gPiAqZGV2KQ0KPiA+ID4gPiA+ICAgICAgICAgZGV2LT5waHlf
cG9ydF9jbnQgPSBkZXYtPmluZm8tPnBvcnRfY250IC0gMTsNCj4gPiA+ID4gPiAgICAgICAgIGRl
di0+cG9ydF9tYXNrID0gKEJJVChkZXYtPnBoeV9wb3J0X2NudCkgLSAxKSB8IGRldi0NCj4gPiA+
ID4gPiA+IGluZm8tDQo+ID4gPiA+ID4gPiBjcHVfcG9ydHM7DQo+ID4gPiA+IA0KPiA+ID4gPiBT
aW5jZSB5b3UgbW92ZWQgZHNhIHJlbGF0ZWQgaXRlbXMgdG8ga3N6OF9zZXR1cCwgcmVtYWluaW5n
DQo+ID4gPiA+IGl0ZW1zIGluDQo+ID4gPiA+IGtzejhfc3dpdGNoX2luaXQgYXJlDQo+ID4gPiA+
IC0gZGV2LT5jcHVfcG9ydCAtIFVzZWQgaW4ga3N6X3NldHVwIGJ1dCBjYWxsZWQgYWZ0ZXIgdGhl
DQo+ID4gPiA+IGluZGl2aWR1YWwNCj4gPiA+ID4gc3dpdGNoIHNldHVwIGZ1bmN0aW9uLiBXZSBj
YW4gbW92ZSBpdCBrc3o4X3NldHVwLg0KPiA+ID4gPiAtIGRldi0+cGh5X3BvcnRfY250IC0gVXNl
ZCBpbiBrc3o4X3ZsYW5fZmlsdGVyaW5nIGFuZA0KPiA+ID4gPiBrc3o4X2NvbmZpZ19jcHVwb3J0
LiBXZSBjYW4gbW92ZS4NCj4gPiA+ID4gLSBkZXYtPnBvcnRfbWFzayAtIHVzZWQgaW4ga3N6X3N3
aXRjaF9yZWdpc3Rlci4gU28gd2UgY2Fubm90DQo+ID4gPiA+IG1vdmUuDQo+ID4gPiA+IA0KPiA+
ID4gPiBUbyBtYWtlIHRoZSBrc3o4X3N3aXRjaF9pbml0IGFuZCBrc3o5NDc3X3N3aXRjaF9pbml0
IGZ1bmN0aW9uDQo+ID4gPiA+IHNpbWlsYXIsDQo+ID4gPiA+IHdlIGNhbiBtb3ZlIGRldi0+Y3B1
X3BvcnQgYW5kIGRldi0+cGh5X3BvcnRfY250IGZyb20NCj4gPiA+ID4ga3N6OF9zd2l0Y2hfaW5p
dA0KPiA+ID4gPiB0byBrc3o4X3NldHVwDQo+ID4gPiANCj4gPiA+IEl0IG1ha2Ugbm8gc2Vuc2Ug
dG8gbW92ZSB0aGlzIHZhcmlhYmxlcy4gRXZlcnkgcGxhY2Ugd2hlcmUgdGhleQ0KPiA+ID4gYXJl
DQo+ID4gPiB1c2VkLCBjYW4gYmUgcmVwbGFjZWQgd2l0aCBkc2EgZnVuY3Rpb25zIGxpa2U6DQo+
ID4gPiBkc2Ffc3dpdGNoX2Zvcl9lYWNoX3VzZXJfcG9ydCgpIG9yDQo+ID4gPiBkc2FfY3B1X3Bv
cnRzKCkvZHNhX2lzX2NwdV9wb3J0KCkNCj4gPiA+IE1ha2luZyB0aGlzIGNoYW5nZXMgd2l0aGlu
IHRoaXMgcGF0Y2ggc2V0IG1ha2Ugbm8gc2Vuc2UgdG8uDQo+ID4gDQo+ID4gQWdyZWVkLg0KPiA+
IEkgdGhvdWdodCBvZiBjbGVhbmluZyB1cA0KPiA+IGtzejhfc3dpdGNoX2luaXQva3N6OTQ3N19z
d2l0Y2hfaW5pdC9sYW45Mzd4X3N3aXRjaF9pbml0LCBzaW5jZQ0KPiA+IHRoZXNlDQo+ID4gZnVu
Y3Rpb25zIGFyZSBub3QgcGVyZm9ybWluZyBhbnkgdXNlZnVsIGFjdGl2aXR5IG90aGVyIHRoYW4N
Cj4gPiBpbml0aWFsaXppbmcgdGhlc2UgdmFyaWFibGVzLiBTaW1pbGFybHkgYWxsIHRoZSBleGl0
IGZ1bmN0aW9uIGFyZQ0KPiA+IHBlcmZvcm1pbmcgc2FtZSByZXNldCBmdW5jdGlvbi4gSSB0aG91
Z2h0IHRoZXNlIGluaXQgYW5kIGV4aXQNCj4gPiBmdW5jdGlvbg0KPiA+IGluIHRoZSBrc3pfZGV2
X29wcyBzdHJ1Y3R1cmUgaXMgcmVkdW50YW50Lg0KPiANCj4gQ2FuIHlvdSBwbGVhc2UgZ2l2ZSB5
b3VyIEFja2VkLWJ5PyA6KQ0KDQpBY2tlZC1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9z
c0BtaWNyb2NoaXAuY29tPg0KDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peA0KPiBlLksuICAgICAg
ICAgICAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiBT
dGV1ZXJ3YWxkZXIgU3RyLiAyMSAgICAgICAgICAgICAgICAgICAgICAgfCANCj4gaHR0cDovL3d3
dy5wZW5ndXRyb25peC5kZS9lLyAgfA0KPiAzMTEzNyBIaWxkZXNoZWltLCBHZXJtYW55ICAgICAg
ICAgICAgICAgICAgfCBQaG9uZTogKzQ5LTUxMjEtMjA2OTE3LQ0KPiAwICAgIHwNCj4gQW10c2dl
cmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgICAgICAgICAgIHwgRmF4OiAgICs0OS01MTIxLTIw
NjkxNy0NCj4gNTU1NSB8DQo=
