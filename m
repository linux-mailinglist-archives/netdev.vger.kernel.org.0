Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51DFD513960
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 18:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232963AbiD1QJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 12:09:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236129AbiD1QIm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 12:08:42 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CD81A39E;
        Thu, 28 Apr 2022 09:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1651161924; x=1682697924;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=UjnLXYYeg+5fTiGw3McklBv3B5iZ0b4QZ4SrSxDPZ9Q=;
  b=OdD59+rQAULdt0LzZPAGjGSSIku2UmYNR9xj2zFV1LY0VSmjAhrPbdto
   QCjEL5M4LqeZ2FgUwqpU3n5UMluN6UYsT2LBBQx+FBcUp0RoCZ8FKT1c+
   fo7NbsjZpSEepYaSMyTynQYE46hvj+XwqMCcGjTBLRFlFQmniwfu7P6xT
   d/+FQXd5t0IXPgHe5SMPCPoIQ8dF1MLbY16YhQPnddlj8aDcMnkMaj501
   hyjQlmW72hBmMDTz1YeVvfFDB1KR9/YvrpyakmU5uWzYAfvphMZ74TqOF
   9wFJ+qr4VeQGcINt+zb/d2mTwJO5beKKMhdji8LBeYrK4UxeLpd6M0lMI
   A==;
X-IronPort-AV: E=Sophos;i="5.91,295,1647327600"; 
   d="scan'208";a="157173260"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2022 09:05:23 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 28 Apr 2022 09:05:22 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 28 Apr 2022 09:05:22 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E6qIw30aV8xnqa2TlxIgavvX6zc6dr8yEx9d/8tWasIVdrHjUFJPLFZNQh8ZeueTmNbWTEDMINVky6/L6miEt3DU6AeVGmy6PC+W8547sGiarqLfeozdRSjpifvhqKR7KD56xndRaWa+47FkYNSHVO4uLuvwsoWkOBlg0XrXeKWJEtqD8ua7o1L/4VVchwURLvxm0EgVAcgLXY//++TqFojNzpo8h0xUEVpKuWimfcMyJtTUznzVItMPvlxCbdQ+8kIKXeCYEK33TtG3WicAYaHR/d6zKmuyaVVAKaOiWPXBMP72i5OxDMnzhLlbzDBZXbL5nSYCZ43/VWU/TNTkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=UjnLXYYeg+5fTiGw3McklBv3B5iZ0b4QZ4SrSxDPZ9Q=;
 b=nWPkfsI621iAEBYKgcZDKPl2thieAsZDvzd88mM1JcIxIrcgAMSdHwA+KL4CVtkyJK42STIEkMmH1mhpNHXfhVajQNT9TLjCbMtB7w2tcQX997nbu8l8He99VqgKJdYWRm3SdUS2ww/2ucG27wi7E92EZYb5LX52PUvWSwNmMArxUVv/ex77p5kCx2z3AF/Q9YBvymxhgaFIx1rmGoFcVmDgxYXoK+ks+brqzJk7T6TJAy+bqEpR+bHFHLS7HpfmFcy/zOYODFYjIrW/WUFMdQea04p2hZQv8NpEGbUW8sA2v21crUwuZ8ZgNsZPBiJyr8WqGPg2uZafjcI0lRMONA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UjnLXYYeg+5fTiGw3McklBv3B5iZ0b4QZ4SrSxDPZ9Q=;
 b=EMbLk8sBxKJXeS5Ai/C/joBxmpG7JT1EmVtfD7tbfahcMblg33XFOSlbTECiwfUou8cvkt+FFgvlofssYVwbOdBQA3xOdSrRTllPQRM4YB0gqrXLmj2pxybORbp7UB5nZGt1lUtl6m+BmzVjiFL8LmGk0ZjEOwOZ3MyYxJ06S/k=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SN6PR11MB3069.namprd11.prod.outlook.com (2603:10b6:805:d5::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5206.13; Thu, 28 Apr 2022 16:05:16 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3113:cf18:bdbc:f551]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3113:cf18:bdbc:f551%3]) with mapi id 15.20.5186.021; Thu, 28 Apr 2022
 16:05:16 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC patch net-next 3/3] net: dsa: ksz: moved ksz9477 port mirror
 to ksz_common.c
Thread-Topic: [RFC patch net-next 3/3] net: dsa: ksz: moved ksz9477 port
 mirror to ksz_common.c
Thread-Index: AQHYWlNaxCafaAnnVkiLtvq2xaWdqq0D+xIAgAF0RQCAAAOSgIAAC+0A
Date:   Thu, 28 Apr 2022 16:05:15 +0000
Message-ID: <7092c728df06e762aa659119c057b4ee308967d4.camel@microchip.com>
References: <20220427162343.18092-1-arun.ramadoss@microchip.com>
         <20220427162343.18092-4-arun.ramadoss@microchip.com>
         <20220427165722.vwruo5q63stahkby@skbuf>
         <a6760b49fae3df27d2b337f5212a3f967a015064.camel@microchip.com>
         <20220428152233.tqzbdrqqgydilncw@skbuf>
In-Reply-To: <20220428152233.tqzbdrqqgydilncw@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 19090e00-5de5-4b34-808d-08da2930e282
x-ms-traffictypediagnostic: SN6PR11MB3069:EE_
x-microsoft-antispam-prvs: <SN6PR11MB30698D7EA49AFE367E6902E7EFFD9@SN6PR11MB3069.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tBRhdI3nou9YZkejUEsW/QsQtxwtot8gHw+0sCKnOjV4PJt+3lHoZ/OgXhNy77tlBa3YVm++Ue5TeXdon3vtOvdlJtHOea7DxYmMJd9w5eVTPXIB8y/YT7uQ1DpHQtnUrPh4rP9/eTLIVEo0z5zG7AmJmiTmNS61Hiy/YPlXvRA+aWOT/njjlfMdRvqEAkpX2go1ug3LaomOm9TjV60txDOTnDanF6orzRMGOKPS4N0tgaG4ALRwyGA07ni0qMj7zbXFQvQXG4XjDw38vSWFK3HBBxUZ7Dsk4kU8IhFT/jQAKxJq+t5s+jc+ucbmkvYlMapy9zQ3FUYjOgnkhSUMatR0Rv7XT2JVBcbkKF5Ku9vmv8/hcH1tChB3FGIH0Vp4iJABfZkIEN3qTTRJFkdrCP5HWSr+xF07Vg87WMHNFnHHMvzCtyhiUrAfAK9vflymxcbQitY9mbIysagVW2TyMBd7fyU7eVPxX1B8DyQcnWlFO9TyGy0/DE4+cxkKdkcb/WmVCO242NriIUhVF2BrYKS5hJPch7loy5OCczN/NIgutQOkPBEPkSc7AXYepyTbZguupWIWHCmZg6cfwtTJVBzJI9aaJkPvJkFHLxGowm5iLHALVif01t95jcmnTTgA2mW9udnwsgIs7uN62lqvqS45Q/LG8Lf4DLV747J4ddbung+5N1Twc/LJKWR5YINmDAoZAMK1oXfA9dXuO5AWloSYxrJkmMKCnNNfQjAbSJI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(6512007)(6506007)(26005)(54906003)(5660300002)(71200400001)(6916009)(6486002)(316002)(91956017)(508600001)(8936002)(122000001)(86362001)(8676002)(2616005)(186003)(36756003)(76116006)(4326008)(83380400001)(55236004)(38100700002)(66946007)(38070700005)(64756008)(66556008)(66476007)(66446008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEFoWHUrdTJ0dW5ZcFpIanBraFBjMVAzOHo3RjgxREM2SmdwSjE5cnNQUmdH?=
 =?utf-8?B?OGNHdWJZRFFCVXJsUjlPU2lJVjB1dllYQ3hRTUJTc2RmYkV6cS9qOG9NdWlB?=
 =?utf-8?B?UDlSUUZYdzNKbTBvVncxR3RySTZRbVZlOFlHbUJPZ3kyeGtQOUN1V0JYZlVr?=
 =?utf-8?B?VWppeXBoUmZjSHRpSDlYUjU1Q0IvNTZyQ2hQUXZnU3FiRWxwUGZtWUt0c2RV?=
 =?utf-8?B?OWp5ME15d3p2MHZSUWJydFV4VFZXRkJLRWF3TVVhaGJwZFZxcWdNWUMwdE5p?=
 =?utf-8?B?aERlelo1cUtxbytvUFpFdTdlQXhSYU5QbUp1bUh1NzYyd2l2Y1F5TDN4aTJl?=
 =?utf-8?B?N3kwa0ROaU9EUmpXMWFSNEI4eHVZOUxZOEdJTzN3SlpyNFBsV0Z3WG00VzAx?=
 =?utf-8?B?dWh4V3hFQVpCWExTOC8rWTJMWkVKSXNCYWFKcEkzb2VxdVYxL2hHWDNWVnlu?=
 =?utf-8?B?Z0R0MjI4L3QxM3QzWjV3Qm1RVG0xWU9JNHpBem9mcjI0OU1BUmpEUXhuUVlD?=
 =?utf-8?B?NU1SV0lxZkdPWmVaSjY5SWhGVGdDbzh3bHRnKzhLY2RYcGxXQVV5ZllJVXRF?=
 =?utf-8?B?RjF1UnJ3REFXU1Q3S2x0cjdIWUE4bnE2aCtzSXROblorS0dWeStYbUkrcHJa?=
 =?utf-8?B?dEgzK2kyVCt6amRQUHhmUUxvYUxTZllIQVIrOGlVTWxKNFovWWtPeXlxQWo5?=
 =?utf-8?B?MFNxUWhibkFjWndYZTFzVFZvandreGMvbUFQcS9uUmpGa2FMd2g5YlRsakFB?=
 =?utf-8?B?VHBtWXRYQm02SlJ0Z0xpTVNDSjBmQndlWG1QYm1IUlE0aG1zY0NmTThVNmdW?=
 =?utf-8?B?aDJrZy9CRVA1cXdqUnBIMUN1a1BnemF6U2xlcStmZXJXL2dKTlR6aXE1dWxB?=
 =?utf-8?B?T0xWVmgzZnZ5VnhGM2Nqb1FudGVNTEZNUEtESWdtWUw5aUMzZmJjUmZIL3Nm?=
 =?utf-8?B?NEh1alNjZGlkMUIwZldKMUU3QU5tSnJnVC9BMGd1ZDhMSGNjQ3lQTXdlZ1Jn?=
 =?utf-8?B?V2JkdUhReGNEcXBmb2NMcVpwZk8zd2Y4N2wydWVoR1JtNWUwRGNFZzVXNkh2?=
 =?utf-8?B?N29qQ3pOSjZ5R0ZpTldiUlZVdVR2NjRjcXVTME5Ga1J4MXgzdjFZbzd5NkNp?=
 =?utf-8?B?T0RHbDV6cnBzdU1TOUlqZC9KdThWMzdMaFIzQ05BRHBWYmdRMCtTemU4SCs5?=
 =?utf-8?B?akNuZVFWaVBCVkJnaWd0TXJWN3BvVnJpMGF3cGR2R3krSklxME1MZ2RNdUV1?=
 =?utf-8?B?RDVXMnBnMk9xNEJuNTBBYWpzaGRUZHFkQVpBaCtyN3pGcEZiMkJxdUJ6T2xX?=
 =?utf-8?B?bEcyUjc1dzFudG1MUXZ3ekkzY012QnEwajBWbEY2dWREdStwdEtWTGlFQTF1?=
 =?utf-8?B?d2t2RkJCZ25yTUZQZTdmd2RyMlFkQVpwcklobVh0bWpNSWdCdndHeFYxTmdV?=
 =?utf-8?B?Sks3L2pEalltejlTSUI1M0M0UWhhYVZLNFpld09yOW9mZ2Y1dU5uRERCdnhw?=
 =?utf-8?B?Yk9oZVlHUkIrY20zbGRoWkp1WGxHMzZqaHNnM2xreWNsbmwxK2FpOVZOM01U?=
 =?utf-8?B?YlYvcGd5aGVvWmVTY2g2MWhmcHRNeEtGa3VjYzg0OXZZMXIxTFRUcHl5b3hm?=
 =?utf-8?B?cVg4d2duV2hYTFB5L0ZqSXNCSVdaZjlzVU5YcG9uS1lPcXlNVEEwZGhZVXZI?=
 =?utf-8?B?VUlRV0RJc1pGNXBwMTJMbUFKWk1iZ1lIN2dFaEV4T3FBdm9xQzdCZkhWSVhp?=
 =?utf-8?B?V0U1Y0JGQWJRUnFBeDBwZGhQc1AzUjRNMFh4VzN1aVFIcUdCWG81cWlWL0pu?=
 =?utf-8?B?bWhkdllFeGxUVDYvdUhVK0NZYnBpemlkQmdVM0ZkbE1WNSs3RVMxR01ISGd0?=
 =?utf-8?B?MlplTU45cXpJazhKVHJUc3M2ZUFyUWw1Y3pjVm9NR2JxNGFhVnh3SVVUakRh?=
 =?utf-8?B?Y0o5V25MalN1SzF5OTVmRzgwT1FYQ1ZQdXQvV1NtVnJtVEJXd2g0UU9PL2xy?=
 =?utf-8?B?VWVZOWNlTXlJWjROTXZZQW5jSEtHbS9WU1ovTzFaclBmRlhCUElNaWlFQWtN?=
 =?utf-8?B?azFKbmFhYVZRVTlMSVBLQ3dYMXR0aEFOSnhGbEZQWVhZdFpqSDV4WURrdGV6?=
 =?utf-8?B?aUdMVE9nYTJmbVR2WldjZVllZEFzZ252UDRiRlVmbFRMckU4UExqVGZLY0ll?=
 =?utf-8?B?WkdmRDFzRGY4b0RwV2hCdmxaS0s0LzBsNjFReHgrdVlnQ09td1RQSk5ybnVY?=
 =?utf-8?B?T1o4NXl5OXI0Tm5KcW9uOThCZmhkMlk3OFhiWG1pRzE4WCtxT1diUThQR2lj?=
 =?utf-8?B?eUI0R1FyNGNFOUswNmtSMzlGQ0cvTHZBcCtvRHFxTGlpOVp5a0VSSyt3OUoy?=
 =?utf-8?Q?HIYWJyhmG98qvSFKKNHcdjLrqaDP8jQb/89pW?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3631B9980DF3144194FFFCDA17B5EDFE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 19090e00-5de5-4b34-808d-08da2930e282
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2022 16:05:16.1406
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GLb6BmCUnLnGsfiPdurYEuB0vPkdMrBJMkFAtTqXPudwx4j8A1X304QYj2KyAYXI8CT85H78F0iDnmva8FYVL2YUkUWKH2kTUuGQdLDjRoM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3069
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTA0LTI4IGF0IDE4OjIyICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVGh1LCBB
cHIgMjgsIDIwMjIgYXQgMDM6MDk6NTBQTSArMDAwMCwgQXJ1bi5SYW1hZG9zc0BtaWNyb2NoaXAu
Y29tDQo+ICB3cm90ZToNCj4gPiA+ID4gKyNkZWZpbmUNCj4gPiA+ID4gUF9NSVJST1JfQ1RSTCAg
ICAgICAgICAgICAgICAgICAgICAgIFJFR19QT1JUX01SSV9NSVJST1JfQ1RSTA0KPiA+ID4gPiAr
DQo+ID4gPiA+ICsjZGVmaW5lIFNfTUlSUk9SX0NUUkwgICAgICAgICAgICAgICAgICAgICAgICBS
RUdfU1dfTVJJX0NUUkxfMA0KPiA+ID4gDQo+ID4gPiBTbWFsbCBjb21tZW50OiBpZiBQX01JUlJP
Ul9DVFJMIGFuZCBTX01JUlJPUl9DVFJMIGFyZSBleHBlY3RlZCB0bw0KPiA+ID4gYmUNCj4gPiA+
IGF0DQo+ID4gPiB0aGUgc2FtZSByZWdpc3RlciBvZmZzZXQgZm9yIGFsbCBzd2l0Y2ggZmFtaWxp
ZXMsIHdoeSBpcyB0aGVyZSBhDQo+ID4gPiBtYWNybw0KPiA+ID4gYmVoaW5kIGEgbWFjcm8gZm9y
IHRoZWlyIGFkZHJlc3Nlcz8NCj4gPiANCj4gPiBrc3o4Nzk1IGFuZCBrc3o5NDc3IGhhdmUgZGlm
ZmVyZW50IGFkZHJlc3MvcmVnaXN0ZXIgZm9yIHRoZQ0KPiA+IE1pcnJvcl9jdHJsLiBUbyBtYWtl
IGl0IGNvbW1vbiBmb3IgdGhlIGJvdGgsIFBfTUlSUk9SX0NUUkwgaXMNCj4gPiBkZWZpbmVkDQo+
ID4gaW4ga3N6ODc5NV9yZWcuaCBhbmQga3N6OTQ3N19yZWcuaCBmaWxlLg0KPiA+IEkganVzdCBj
YXJyaWVkIGZvcndhcmQgdG8ga3N6X3JlZy5oLg0KPiANCj4gU28gaWYgUF9NSVJST1JfQ1RSTCBo
YXMgZGlmZmVyZW50IHZhbHVlcyBmb3Iga3N6OTQ3NyBhbmQga3N6ODc5NSwgaG93DQo+IGV4YWN0
bHkgZG8geW91IHBsYW4gdG8gbWFzayB0aGF0IGRpZmZlcmVuY2UgYXdheSB0aHJvdWdoIHRoZSBD
DQo+IHByZXByb2Nlc3Nvcg0KPiBhdCB0aGUgbGV2ZWwgb2Yga3N6X3JlZy5oIGluY2x1ZGVkIGJ5
IGtzel9jb21tb24uYywgZGVwZW5kaW5nIG9uDQo+IHdoaWNoDQo+IHN3aXRjaCBkcml2ZXIgY2Fs
bHMga3N6X3BvcnRfbWlycm9yX2FkZCgpPw0KPiANCj4gVGhpcyBjYW4ndCB3b3JrLCB5b3UgbmVl
ZCB0byBwcm92aWRlIHRoZSBvZmZzZXQgb2YgUF9NSVJST1JfQ1RSTCBhcw0KPiBhcmd1bWVudCB0
byB0aGUgY29tbW9uIGZ1bmN0aW9uLiBXaGF0IGFtIEkgbWlzc2luZz8NCkkgY29tcGFyZWQgdGhl
IGtzejg3OTUgYW5kIGtzejk0NDcgbWlycm9yX2FkZC9kZWwgaW1wbGVtZW50YXRpb24sIHRoZXkN
CmFyZSBkaWZmZXJlbnQuIEtzejk0Nzcgd3JpdGVzIFNfTUlSUk9SX0NUUkwgaW4gYWRkaXRpb24g
dG8NClBfTUlSUk9MX0NUUkwuIEtTWjk0NzcgYW5kIExBTjkzN3ggaGF2ZSBzaW1pbGFyIHJlZ2lz
dGVyIHNldCBidXQNCktTWjg3OTUgaGFzIG9ubHkgbGltaXRlZCByZWdpc3RlcnMvZnVuY3Rpb25h
bGl0eS4NClNpbWlsYXIgdG8gcG9ydF9taXJyb3IsIGZldyBvdGhlciBmdW5jdGlvbmFsaXR5IGxp
a2UgbWliIGNvdW50ZXIsIHZsYW4NCnJlZ2lzdGVycyBhcmUgc2FtZSBmb3IgYm90aCBLU1o5NDc3
ICYgTEFOOTM3eC5CdXQga3N6ODc5NSBoYXMgZGlmZmVyZW50DQpzZXQgb2YgcmVnaXN0ZXIgaW1w
bGVtZW50YXRpb24gZm9yIHRoYXQuDQpTbyBJIHRob3VnaHQgb2Ygbm90IHRvIGRpc3R1cmIgdGhl
IGV4aXN0aW5nIGtzejg3OTUgaW1wbGVtZW50YXRpb24NCmV4Y2VwdCBmb3IgYW55IGNvbmZsaWN0
cywganVzdCBtb3ZlIHRoZSBrc3o5NDc3IHRvIGtzel9jb21tb24sIGFuZCBjYWxsDQp0aGlzIGZv
ciBLU1o5NDc3IGFuZCBMQU45Mzd4IGRzYSBob29rcy4NCg==
