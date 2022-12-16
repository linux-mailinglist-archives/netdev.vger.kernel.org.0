Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9E964E699
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 05:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229822AbiLPEH0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Dec 2022 23:07:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiLPEHY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Dec 2022 23:07:24 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE4FC4AF33;
        Thu, 15 Dec 2022 20:07:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671163644; x=1702699644;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=nVPY2Iyv7QJMq3fcZpIN2FVAS2AsCDXsdrbK5RNodk4=;
  b=E4+C7bD9yjHG9GP5Teo54QOv+pwIjhaT6xJuXiTVwxFszv/b6Vc/uKD4
   tkJu5sipDpzQAfa56zJqtAKUGQN6OGPkcUyKDviuwmmkMDTPfNzk/rtCl
   Fs4Tij/xNfMU0Es/KDLh5P9/hMnkn4rxKbN6bYiUCPvh90ZFZabxYeUFE
   DblV1wEGSCqnk8jMjj80z3rFdkHYbQG1lQqsMzvSq5OK9tBgWiE7pgBNC
   wnD86vjqf/I04uMDT+qQ5O/NYlp4k9Yz+hbtwFWaHliYM5EJ34gCiFOiG
   vsJWx3PqGQ3YjPHoLbMbFu+blaTX9ghwFwRGRcIu8lOx6sH4gkjQQQKdF
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="188447938"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Dec 2022 21:07:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Thu, 15 Dec 2022 21:07:22 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Thu, 15 Dec 2022 21:07:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q61R5AH9sccPBm8t+y3UmgpaKbsyuTgBD2e1hAB58xzZcrCDNWb7cnQD/1p/+KlCCtF4S9xwoJf4r9C57uPGpF8tKJPr8x0dfhdSXla/+r+1hTMiBQ6N0nPfQn+pjO7xdCjBQxuSA/39jwW2Axy7DgqJwauZeiuupwrSpAfgDVjTe8nw4yqF566MKtp3WMaX8/uQ8UMW/D6k6RVLl7Gbp5KOjplngnVkiJYwoCDo1pzvjVJZ5j8WPq+r5q1sM4TlyV0E9KZzj9QC0reydNloyjMEeMinBpEhgpeCFh7AKqDppSlEE+BwnSgmyXrKCTJQ1ebg1FHnFdDLqDHDb6sYeg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nVPY2Iyv7QJMq3fcZpIN2FVAS2AsCDXsdrbK5RNodk4=;
 b=MHVz2twPH4SGR8/H/4pvEQa2vHqHmE0c4SdnvlPbjudkeCyCm3zccH16Zat9zq0nNoaVoGK1I5XWbkIfELz8EwsrwsfMeMNIrfudYi1/k6gOQt3U9v7jwv5X6LOGkunNc0KaxD59CYK5ctUEcoyFPPrOa5cTnOCC8xzBJq6eH1U4xPmEIvaZw4xcPmFraIZqbi2psfWBrOBKAWxZmU/6vt6tOxqpXV9t36RkUXCu8BQJVa1dc+LEGnKf484NH8Gx5hMitVBaR+MjFnWLGH6q/CEYLsWiKibhlHXaU5z9I7fRuxMFXdyeQg4CVXAssNrwhjM2iKEaXsoBOf5yYgYzjA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nVPY2Iyv7QJMq3fcZpIN2FVAS2AsCDXsdrbK5RNodk4=;
 b=JyDC6DFmVGxuVaPh5ck7EwnVOjyAGYEbxcKMWmCGoyBLB8BUSwyf06pK3hPUGeDKM0YCGM7ju35YplkuUvtVp7JIINc/014ARYaur/1vmgkAtuGtmxf38w+iJ65jk3k0AOEjIIwd2ycRfFRJ5IvG3lhlauEBx4X2aPedAf/04nE=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB5567.namprd11.prod.outlook.com (2603:10b6:5:39a::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5924.12; Fri, 16 Dec 2022 04:07:20 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 04:07:20 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <ceggers@arri.de>, <pabeni@redhat.com>
CC:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
Subject: Re: [Patch net] net: dsa: microchip: remove IRQF_TRIGGER_FALLING in
 request_threaded_irq
Thread-Topic: [Patch net] net: dsa: microchip: remove IRQF_TRIGGER_FALLING in
 request_threaded_irq
Thread-Index: AQHZDtvCRIn+LRRQkkCMz8493G6geq5u0z0AgAAnj4CAAO9EgA==
Date:   Fri, 16 Dec 2022 04:07:20 +0000
Message-ID: <8142b2b482f11b03b6c5e4e977c649f0e9fb4ef1.camel@microchip.com>
References: <20221213101440.24667-1-arun.ramadoss@microchip.com>
         <0d35858867ae1c3de899d6162aa39e013daff435.camel@redhat.com>
         <2280237.ElGaqSPkdT@n95hx1g2>
In-Reply-To: <2280237.ElGaqSPkdT@n95hx1g2>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB5567:EE_
x-ms-office365-filtering-correlation-id: 22fc7fcc-52aa-463c-1fb8-08dadf1b072c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: LCt31enRsnr1W5TbHyCrrziPuZruQsFu7kdxFGBMqr3zMpuWrBYHanjdlgbrva8IPeL+apXAfFtKUWZ+RdWXOKBAuwO9lIW5BULSXfk2eU+AKbrO07YskoxjkuR9p7Yxjb94qze5g4+nZ7Iti7aA+ggRr9jfhXoFOtH++jpnUKJRMpmmA2DrLX2R5SphlDYWp2qsyFah+rMM83o/8NUkNzHKqSixXaDaPL+7MzdHvNDvko0jhO0saHoKAt867z863g15wrAZQEs1+TyEUss8ZeAa6z8+Z7IUstveG2UntD9VsbYtxTlSniYLf2nnQDPNn8iAl+sNs0zHTUNIzqeI9yFAmKxWMNDDcGI1UqPoX90KQ2Alh2TWQJjGgjtJ9r4HCppIZRPY6Xl/HUzOVWImZHPvFaOXDAFJBBkwsxB9c567ZzHYhXATxxRUJs8DzPSZ6hJU0Hvzkpas66J5KhGi0jkElNqt06izdJeoWOCrpvknUqgreDmh/30arSfttLmlHQsOfjagIaGDFHZMmebmSbuhU28V7uofrIt21ceMNlGtHKLS5phlPkJxOXhUvKIsZwaAfA2/lzJbewkU+AA1LauIZJAH7aBQG0kVTeAO+h7odpx6b/QOJfSaXaskgof4xj4sOdKuxQjHgyMJDCQTs+S4CndL4zfcySh+dOoevj9RI5iNCfWlAvtAeyCkS5b/nj7lb1VgZSJRElUPNNPh2jZDhsibwQhNgKCEkxeIfThBT908gUHzOa9DhS80Kr6V
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(396003)(39860400002)(376002)(136003)(451199015)(26005)(6512007)(6506007)(71200400001)(186003)(76116006)(66446008)(66946007)(54906003)(91956017)(2616005)(110136005)(316002)(478600001)(66476007)(66556008)(8676002)(4326008)(6486002)(966005)(64756008)(86362001)(8936002)(38100700002)(5660300002)(7416002)(41300700001)(83380400001)(122000001)(4001150100001)(2906002)(38070700005)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aDF4Wm43ckQrTG9ZbHExVmxGV1p0OXc3N1QvMVRPK0M5a1VXM0I0dWdzNE9W?=
 =?utf-8?B?dkhSUTkxTzlxVVhJS0hIanluaWoraDNCektUZTNvcERmbEJXdFhvTFB2UVBu?=
 =?utf-8?B?UDAxWUN3VEhiaGxkeGJ0Z3ZVUTVIb0M2SEZuZi9RNVZnUkYxVTl1bzZxYzI5?=
 =?utf-8?B?QjdVUjBWdGpCOVZ4dy96S0s0a0tHWmQ5SVNaOWVCL0NxTXRDckVxUDdHK0o2?=
 =?utf-8?B?SEFTQ3crVkVKckdMYlFKNHB5R29kVmNNYXdWbmordEl6dHpXU2EzZkxqQi9o?=
 =?utf-8?B?OFE1ZS9TcTdWbTFzNm9NSEhMOFdLbmtGYmxqL2VTWFoyNEZyTnlNWFpOK3Z1?=
 =?utf-8?B?UzYrQUxBMjRWZVZ2eGJYclkrSFlzcHA4b1ZhVmh5ZyszTjRPeDBKWUhaN2RH?=
 =?utf-8?B?R0pYODBkLy9KOTRJbitwdklwakpEYXp0eHRoL0czaGZKdEo3WWkwdXlLaFZm?=
 =?utf-8?B?cTFIWmpsaXNvUjRLRUZrakZMbmRTV1JCNXRHSHIyc0M3Tkp1WThqZi9aY0lq?=
 =?utf-8?B?dWp6NndrcU00TnQ2VkI2b0JOYUFCQVNOQTZNakIvMVZWRTJLZlNCdDZ1REtG?=
 =?utf-8?B?NjhyMDk5WlU1RVI4RFR6eGhXNEEweTJiRzl5cW4zRUY2ZVVCcFNpWXFiSS9y?=
 =?utf-8?B?TDY1WHNoYmtKZEduaWJRSzYvbG05VzNWR3ZOVXYwVW13djNlMGNPY2I5elhF?=
 =?utf-8?B?NDhjZ3BBT2pvRjBjckdWR21icW5vQlVYQndTVlpTZ005U0ZsTGdUOWpoRGhx?=
 =?utf-8?B?bno0bXhzc3RnbmRLYmxxeGF1bUg3ajh6bVVSWi8vY2dqUU05M1FtOVFjUm9D?=
 =?utf-8?B?ekp6VWtsb2h3L24xRm9LenhET1dxUFJUa1djSjlGZmtBS2VBeUpLZWd6UXF1?=
 =?utf-8?B?ODYyQXJWcnk5QTJxcTVTR1FGNk9jTkpURTdYR25jNFQ0NmU3OXExMzU1ZWph?=
 =?utf-8?B?M0k4UFQyQklockh0dlZ6dzhSclNqbm1TdVZKbmp6MWU5aURHYzkrZzRJUXc3?=
 =?utf-8?B?S2N1VmV2dlM2SE5CRFRqZm9KSFpWSnNyTjVYdWFyRUp2c1dneFFXMXNuUXpn?=
 =?utf-8?B?M0RibnlkL0lGWHJyQ2NCL1pGN0RXQXgrRUtXdFBjUmJIak84Z3FyVXZlc1Iz?=
 =?utf-8?B?bkY5UGlBejVmWnVjTXBrcHJFRkdHTUhpYk0vSkU0VGRpRVNZdjQ5OHJKT2NJ?=
 =?utf-8?B?UXZlZFIzY1Q5ZjE1VURxN1VkWVBtcHdLR0xPSXY5RFBhS1NpdkRqd2lsYWV3?=
 =?utf-8?B?cmJTS2JMZEVOZVlNcHVKNThDM2N2SUk0UTRkVERkTGJVWnZabUZ2ZDJOSDV5?=
 =?utf-8?B?Q3FiOFBQbVJBdHd5bXpxbVlVNCtEemZ6SHZORjFLTkZ4L1ovbmlGMjJRaHNB?=
 =?utf-8?B?WEE1UGRVTEVRWm9WUVF4RXI1TGtVSVduVGhjUjR3eE83UEZWVnl1eStweVZz?=
 =?utf-8?B?THh0dWg2SmJvYk5SNDdhQjRGamRKcHY1RHg4cXBVUlF6Rk0vQlEyTGdFbTlM?=
 =?utf-8?B?QTR6U0JrNjdtSiszWndsdlpqSXhMK0RoZ1FzYzRKODE4anpDeUV2bjFzcXU5?=
 =?utf-8?B?OXFOeUtEUUZsbHd4QVd0UVdDMXFramxvbm5kcjY5WXRmOXQvRzN0aWVOam9p?=
 =?utf-8?B?UGUzamFKdWIzb3RGTHlycDFEbWEyVCthWExsK0pUdUtRSFovOGNBMjQzUHlq?=
 =?utf-8?B?cEFkOU5XQXZ2elVVNmR2ZHl2SzExUlRtbk9UcnVQK3I2WHVwVlgwTzZFWFp4?=
 =?utf-8?B?a3VoaEtlM3dRZEdPaW81NHlBKzZremNrZElST21wczg3cDVEQkZIY1dCTGJL?=
 =?utf-8?B?Y0EwdldTcDVLM2RQY3JqZ1h0RHpMQ0F0cUJ3dzE0WDNSMjk1U3IvMStWa2cx?=
 =?utf-8?B?UGhVZld3ZGJ0eitOQSt6Tm5Ua252T0V0bzVicm1YUkNqbWNHdWYzaURERFJx?=
 =?utf-8?B?ZlpLQUNMWE5JZHJXdXdFZERsR0ZuVFkyellVcmZMallkR2N3SG15T0RJa0Yv?=
 =?utf-8?B?YzNvdnd6OGJueDUvZXY2dkljZ1M0dWNIempQUFVJemJ0OVJ6NWNSQmxXdDdy?=
 =?utf-8?B?SDNCTzZZNjVSNExvb09qT0kwcHpxU2tseTJUcjRmVmtMd2RRNlREeDZqeGtY?=
 =?utf-8?B?T0ZPUGRMNGFHY1VYckFTaXFyd3QxWWdtbU5ydUFDVlkrT3RSNXNGZEZrYzJB?=
 =?utf-8?Q?DQ/5Mv8mVhSOjs9xj/0z40s=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C48EB084E1090F4887EB8C69EF577942@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22fc7fcc-52aa-463c-1fb8-08dadf1b072c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2022 04:07:20.3633
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1sxfh8GS8h4KMGhrZvpDdjU288AXj2vYmbVz0sYk27RQPFGV2hdpPm1zmpP18WZ36BMiPYLMfvQuX3Sv9NnCVXgYlCaemLR+/wgmSi/0NZ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB5567
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2hyaXN0aWFuLA0KDQpPbiBUaHUsIDIwMjItMTItMTUgYXQgMTQ6NTAgKzAxMDAsIENocmlz
dGlhbiBFZ2dlcnMgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mg
b3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2Fm
ZQ0KPiANCj4gSGkgUGFvbG8sDQo+IA0KPiBPbiBUaHVyc2RheSwgMTUgRGVjZW1iZXIgMjAyMiwg
MTI6Mjk6MjIgQ0VULCBQYW9sbyBBYmVuaSB3cm90ZToNCj4gPiBPbiBUdWUsIDIwMjItMTItMTMg
YXQgMTU6NDQgKzA1MzAsIEFydW4gUmFtYWRvc3Mgd3JvdGU6DQo+ID4gPiBLU1ogc3dpdGhlcyB1
c2VkIGludGVycnVwdHMgZm9yIGRldGVjdGluZyB0aGUgcGh5IGxpbmsgdXAgYW5kDQo+ID4gPiBk
b3duLg0KPiA+ID4gRHVyaW5nIHJlZ2lzdGVyaW5nIHRoZSBpbnRlcnJ1cHQgaGFuZGxlciwgaXQg
dXNlZA0KPiA+ID4gSVJRRl9UUklHR0VSX0ZBTExJTkcNCj4gPiA+IGZsYWcuIEJ1dCB0aGlzIGZs
YWcgaGFzIHRvIGJlIHJldHJpZXZlZCBmcm9tIGRldmljZSB0cmVlIGluc3RlYWQNCj4gPiA+IG9m
IGhhcmQNCj4gPiA+IGNvZGluZyBpbiB0aGUgZHJpdmVyLA0KPiA+IA0KPiA+IE91dCBvZiBzaGVl
ciBpZ25vcmFuY2UsIHdoeT8NCj4gDQo+IEFzIGZhciBhcyBJIGtub3csIHNvbWUgSVJRRl8gZmxh
Z3Mgc2hvdWxkIGJlIHNldCB0aHJvdWdoIHRoZSBmaXJtd2FyZQ0KPiAoZS5nLiBkZXZpY2UgdHJl
ZSkgaW5zdGVhZCBoYXJkIGNvZGluZyB0aGVtIGludG8gdGhlIGRyaXZlci4gT24gbXkNCj4gcGxh
dGZvcm0sIEkgaGF2ZSB0byB1c2UgSVJRRl9UUklHR0VSX0xPVyBpbnN0ZWFkIG9mDQo+IElSUUZf
VFJJR0dFUl9GQUxMSU5HLg0KPiBJZiB0aGUgdmFsdWUgaXMgaGFyZCBjb2RlZCBpbnRvIHRoZSBk
cml2ZXIsIHRoZSB2YWx1ZSBmcm9tIHRoZSBkcml2ZXINCj4gd2lsbCBoYXZlIHByZWNlZGVuY2Uu
DQo+IA0KPiBTZWUgYWxzbzogaHR0cHM6Ly9zdGFja292ZXJmbG93LmNvbS9hLzQwMDUxMTkxDQo+
IA0KPiA+ID4gc28gcmVtb3ZpbmcgdGhlIGZsYWcuDQo+ID4gDQo+ID4gSXQgbG9va3MgbGlrZSB0
aGUgZGV2aWNlIHRyZWUgY3VycmVudGx5IGxhY2sgc3VjaCBpdGVtLCBzbyB0aGlzIGlzDQo+ID4g
ZWZmZWNpdmVsbHkgYnJlYWtpbmcgcGh5IGxpbmt1cC9saW5rZG93bj8NCj4gDQo+IFdoYXQgaXMg
InRoZSIgZGV2aWNlIHRyZWUuIERvIHlvdSBtZWFuIHRoZSBkZXZpY2UgdHJlZSBmb3IgeW91cg0K
PiBzcGVjaWZpYw0KPiBib2FyZCwgb3IgdGhlIGV4YW1wbGUgdW5kZXINCj4gRG9jdW1lbnRhdGlv
bi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9kc2EvbWljcm9jaGlwLGtzei55YW1sPw0KPiBUaGUg
bGF0dGVyIGRvZXNuJ3QgbWVudGlvbiB0aGUgaXJxIGF0IGFsbC4NCj4gDQo+IEJUVzogSW4gbXkg
a2VybmVsIGxvZyBJIGdldCB0aGUgZm9sbG93aW5nIG1lc3NhZ2VzOg0KPiANCj4gPiBrc3o5NDc3
LXN3aXRjaCAwLTAwNWY6IGNvbmZpZ3VyaW5nIGZvciBmaXhlZC9ybWlpIGxpbmsgbW9kZQ0KPiA+
IGtzejk0Nzctc3dpdGNoIDAtMDA1ZiBsYW4wICh1bmluaXRpYWxpemVkKTogUEhZIFtkc2EtMC4w
OjAwXSBkcml2ZXINCj4gPiBbTWljcm9jaGlwIEtTWjk0NzddIChpcnE9UE9MTCkNCj4gPiBrc3o5
NDc3LXN3aXRjaCAwLTAwNWY6IExpbmsgaXMgVXAgLSAxMDBNYnBzL0Z1bGwgLSBmbG93IGNvbnRy
b2wgb2ZmDQo+ID4ga3N6OTQ3Ny1zd2l0Y2ggMC0wMDVmIGxhbjEgKHVuaW5pdGlhbGl6ZWQpOiBQ
SFkgW2RzYS0wLjA6MDFdIGRyaXZlcg0KPiA+IFtNaWNyb2NoaXAgS1NaOTQ3N10gKGlycT1QT0xM
KQ0KPiANCj4gU2hvdWxkIEkgc2VlIHNvbWV0aGluZyBkaWZmZXJlbnQgdGhhbiAiaXJxPVBPTEwi
IHdoZW4gYW4NCj4gaXJxIGxpbmUgaXMgcHJvdmlkZWQgaW4gdGhlIGRldmljZSB0cmVlPw0KDQpJ
ZiB0aGUgZGV2aWNlIHRyZWUgaXMgcHJvdmlkZWQgKmludGVycnVwdCBjb250cm9sbGVyIGFuZCBp
bnRlcnJ1cHQNCmNlbGxzKiwgdGhlIGtlcm5lbCBtZXNzYWdlIHNob3VsZCBwcmludCB0aGUgaXJx
IG51bWJlciBsaWtlIChpcnE9NjcpDQppbnN0ZWFkIG9mIFBPTEwuICg2NyBpcyByYW5kb20gbnVt
YmVyKS4NCkZvbGxvd2luZyBpcyB0aGUgZGV2aWNlIHRyZWUgc25pcHBldCwNCg0Ka3N6OTU2Mzog
c3dpdGNoQDAgew0KICAgICAgICAgICAgICAgICBjb21wYXRpYmxlID0gIm1pY3JvY2hpcCxrc3o5
NTYzIjsNCiAgICAgICAgICAgICAgICAgcmVnID0gPDA+Ow0KICAgICAgICAgICAgICAgICBzcGkt
bWF4LWZyZXF1ZW5jeSA9IDw0NDAwMDAwMD47DQogICAgICAgICAgICAgICAgIGludGVycnVwdC1w
YXJlbnQgPSA8JnBpb0I+Ow0KICAgICAgICAgICAgICAgICBpbnRlcnJ1cHRzID0gPDI4IElSUV9U
WVBFX0xFVkVMX0xPVz47DQogICAgICAgICAgICAgICAgIGludGVycnVwdC1jb250cm9sbGVyOw0K
ICAgICAgICAgICAgICAgICAjaW50ZXJydXB0LWNlbGxzID0gPDI+Ow0KICAgICAgICAgICAgICAg
ICByZXNldGItZ3Bpb3MgPSA8JnBpb0QgMTggR1BJT19BQ1RJVkVfTE9XPjsNCiAgICAgICAgICAg
ICAgICAgcGluY3RybC0wID0gPCZwaW5jdHJsX3NwaV9rc3pfcnN0PjsNCiAgICAgICAgICAgICAg
ICAgc3RhdHVzID0gIm9rYXkiOw0KCQ0KCS4uLi4NCn0NCg0KDQoNCj4gDQo+IHJlZ2FyZHMNCj4g
Q2hyaXN0aWFuDQo+IA0KPiANCj4gDQo=
