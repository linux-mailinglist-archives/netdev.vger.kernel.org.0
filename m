Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B04A562CFF
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 09:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbiGAHrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 03:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235514AbiGAHrt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 03:47:49 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB9D6D555;
        Fri,  1 Jul 2022 00:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656661668; x=1688197668;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=giXcuKiCJi8W2gUqTe2yUapLxff038jlc58PelCef1U=;
  b=PxVBVTCcJKip4yhfjX/hOlPZDTcqGAEJ1+XhkFcdqIeyRimVhJA3JIeq
   uN8DXM/36Nwovwf/bnlTvw5PFNlqNgmwvHaStn7i9CfyXnP8ZRXN5rca4
   75YMkMUfWJlcq9LgKjTNq3f4s0S88vd61BZuY54iM897RBAZVBE9nrzUp
   0X+3bFC1N0J6EB7jgDKGjKIsQkzIS+HKRN6MoJOp9cm1JhYkqbrFBLeEk
   Q9ShHRXTEO55BLgb7h+rR4rOyAQbTFEFvhfYip5vkuJroIVXMb4V7dXkQ
   VXG5AzNLrzJ3FG0gmi9hovhnrqPMZQ+7JSQxy718MpHOwyfgRiTnb0pbp
   A==;
X-IronPort-AV: E=Sophos;i="5.92,236,1650956400"; 
   d="scan'208";a="165967283"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Jul 2022 00:47:36 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 1 Jul 2022 00:47:36 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 1 Jul 2022 00:47:36 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zf5vo6y1P/2Cv8SEhk+x2vudC1TsUwydSopTQZINn4NH4j8Tkx4W+7QQjlA5eq0CfD0e4OFWjD8/iNgLiChGRAUEJSOAL0y9Yo3eog0PTnmbACGCZB0UtWJmxIBrythIHeIdKY+3/nmcOCV2uYWZk+oyQDlWwgu0Q1pVd9s84Jc84KBDMoBKMZXbqsyZoiSKZampXUfZoibEviVVvrVGrnIny89C7IiIj13rRvxzl4OKG+g/ZcChDFbf/OxFLaWaVWbatOlTf0TREKNIFwrs8vgucriCFK80BYiJHtCyd4r35jSVxdS++gKjRyGRSHHr+q9brizia+cciQ8XR6YXxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=giXcuKiCJi8W2gUqTe2yUapLxff038jlc58PelCef1U=;
 b=PrN/J5xZp9yqPK1kDiv3Xwpp50vUKi5w66weXp8bDoWE1vNVjVJoQffQdCEiP8479qH/yM0L0wy6oytly8zDpJkPB4VdDouVfNkK48UD09VMsze16z8y5hMQn7mCRGW3w1gsN3AlzGCWj+SPaw0NDwjILI3pa6auVg6/YMfPBTj71CFWfdRsQnbokCB1PzW3J84KBmc86lBDY5KxQYsh3uUy2ZISwK71JvE0HiueWApj1LVlXc+mxqwAcmF+pa4v9CkdNMEos/k+lf9znJSQzkAQu7VTnJr3CiNG3umKkPEUjfvmXO8YW0P2jVeDZ+xDMXSq+xguPsJH/VdxqLt70w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=giXcuKiCJi8W2gUqTe2yUapLxff038jlc58PelCef1U=;
 b=ZTTmnbjc4Gd56YSmdrsVosAdhNCyXmPV/NZ8fCDzji+MWRmNdvbib4VU5w+72ZY8v31XTgu3BWmP1LRvtwM/wWvj9h77c8g7A+E+b1PuTP2EuXvYkkCAbpU9wBc0bHqGxv968H+rtFwEhCFZ6aLNEwZTMoDZnmz7PiElb8KhafI=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by DM5PR11MB1257.namprd11.prod.outlook.com (2603:10b6:3:12::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Fri, 1 Jul
 2022 07:47:34 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5395.015; Fri, 1 Jul 2022
 07:47:34 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <Conor.Dooley@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <robh+dt@kernel.org>, <krzysztof.kozlowski+dt@linaro.org>,
        <Nicolas.Ferre@microchip.com>
CC:     <netdev@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Topic: [net-next PATCH RESEND 2/2] net: macb: add polarfire soc reset
 support
Thread-Index: AQHYjR7TauaCitsCNUadh5DGhDTAlg==
Date:   Fri, 1 Jul 2022 07:47:34 +0000
Message-ID: <25230de4-4923-94b3-dcdb-e08efb733850@microchip.com>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
 <20220701065831.632785-3-conor.dooley@microchip.com>
In-Reply-To: <20220701065831.632785-3-conor.dooley@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b5d6ce2-522b-46f3-1654-08da5b35f5fa
x-ms-traffictypediagnostic: DM5PR11MB1257:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: x5b7YdRcyVXmquqEOBzm13GkkKCRwT/kLNOxysI+6WFH5gfoFLLUkS5/IiDZQENOETOFQ4DKVDp40IFZfQNG1ct7KGA5AUsjR0WxklIwhitP0SdQXgq9GTSTlYOU/Wz2PkX+qUGyoK2YVJUg9NN0KordymQocwfH5P9V0zGoXTPjpQslv1JEN32XEg/F670mBPBnXhwHqG2zckABWDjJtEuRZ4u4FC4LnuRdUe2DKf1i4ZTlKP3K66SKeFWJzTjub7XajSJKrN/mMB7RXmyKyUQD+fa0EHPRHiy9aYKS2dczIyntpodRfW+A9L1b/ZSLR5yY8SVZ8Fnc6UvTpVnOENWeRk2CZ5nFrcb5gOW1FsQskMuyTH3Cm6LGsLNv7YpBC0eDtHoG27YFQUsj6+fssSGohKVMnwq2lggGiq8Pk3WET/HL3VwEJd00bzCnE8D5bpVJEHr79veZwL9sq+FsTQHjb1knBZeJoWaJ/8WwviOkEkisWnWEzd7fBNU9qOcSi8O2MsQhfiKevk381tiffgF+WHlxNgvLNtAiEOZLZkh9SK1YOburidgJTqMnzB1G6RWOAy0I51TO+p/emJy24iHtSKwtNSa3SNuPtly0/Pep/7fm2G+kZ090UjJTsKhctCK1Wg2PgJyRbLmdrH0zQHJ0c53hU+bGhc6UmhUXKvS7xoV0UBeng+pkrRPD8gzJedf2F3jWkA/alOIxdXN1A/ruw607MNEAqbqv49wcCBLgCIo+FFEyoHIvTay86MMPiTXfJozPC1o1yhHjeXc09XxuVVkeEz/+cjPdG3+2v/wVOR8RIJe5+KjvazyRUHZ5g5b5F9f7aeuTpCaq5Yp6OUtDgfCPHXfHGmGK2tgisv9bE/rpP++3ia5pREXvLb6s
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(366004)(346002)(376002)(39860400002)(6512007)(26005)(64756008)(4326008)(86362001)(2616005)(5660300002)(8936002)(7416002)(38070700005)(53546011)(6486002)(6506007)(478600001)(31696002)(186003)(6636002)(38100700002)(41300700001)(2906002)(54906003)(122000001)(31686004)(8676002)(36756003)(83380400001)(71200400001)(66556008)(66446008)(66946007)(66476007)(76116006)(316002)(91956017)(110136005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dEs2Z056MlRNdkE4SSs3cjNOeEV6V1hKNDgzSzVKZGo5OTE1YVkyK1JMaDE4?=
 =?utf-8?B?N1dPaXU3aHBOcVFmYVQ1bHBSZFVueHI3MXE2TWQ3c0tTbUtuczJmSE9VRkMr?=
 =?utf-8?B?UUJLMlhBWDVQZE1IV3h5RWZWM3pDWGxFdjNHNUg4bzA2T2lEbFF2K1U1WitO?=
 =?utf-8?B?ZmsxaE81YUlYWGdudEl0Z3JuaThMQ01Mcy9JOXpXamQ2ZTEvQkFwSWxyR0gx?=
 =?utf-8?B?N2ZOdEJ4c1FEWWU4dk1laTYxZEpLOUNMZ25IelFXZTQzR0J1VUxSOEVrdVhv?=
 =?utf-8?B?QnIvQ1pGZkgzbDBTYmxhanpLUTRmWWptN0tLZkNvcUZBYkp5R3VhY3JnUlFk?=
 =?utf-8?B?RUhKbjhnUmdmZTRpcG9sWCs5UjNNWXNnMW5GRm0wOU1HWFhXbEt1UGl1NmVh?=
 =?utf-8?B?YzhJS0xHejdCakdRaXZVY1RMTlIraC8rcWNmc0RRT01YTWFJUXZOa24xeFFh?=
 =?utf-8?B?Ry8wQlFkUjJvV1FpSHhWbkJOSmFrUGJ6cXhrTUI5bFdtR3dmOHcrUkxUYkNv?=
 =?utf-8?B?VjlMUjB5SThBTXdCd0NEaU4zNFU0TGR2c3RrMFdEZUtXdlJWZFhNcVJPSysr?=
 =?utf-8?B?TU1BZWYwWW1lTUlaaFZnOFVpQktuZmQrbkcydFIzTjUrRE4yNU9mUEJJVndH?=
 =?utf-8?B?NDVvWTdna05qRklmekN0WUpxclVXOUtoVE9WRjNiOElMZXg1ZDIrVXg4MUZs?=
 =?utf-8?B?N2ZacnYrd2ppcUJTNTFibWpSN0VSM0EzOEcxdnpMbzhiaVNSL0NnY1ozOTFJ?=
 =?utf-8?B?d0dnenN2NUxXUTBVa3FBdTl0T0lBVVJsQThWc2xnejZPS0lOeUJvYXlFOVdk?=
 =?utf-8?B?eDV1b0pvWFYxU3dQSnB3dFhjcjhqb25qOW92NzFJN3ZJVjZSWHQrV2tCUUVT?=
 =?utf-8?B?cXBRUnZraW50S3FwaDBVOGErWTQxUWN5OHBJWkhNQ1NGdDROWCs1TFJDR3Vp?=
 =?utf-8?B?WmNrMFFIZW9iTEpwbDlHaVZubW8xUzdGcjM0MEZLZmlMbkg0cGtjOXUvbkx0?=
 =?utf-8?B?RmVoalYzWWlMWExXemxMTUJjYUw3eDdZOWkydndjNWMxMEloRTIrNHMyZVpX?=
 =?utf-8?B?TTlRSURjaE91SjRYa01weTZ2YmRBaTlaaG00MlJzQmhJWUNwWjdrSGs1a1Ri?=
 =?utf-8?B?UkM3eXFuSTkrOVlTbGNpbjBjb0dqYXhPOTNFcm13TTJuLytyODM5RHgvNWIy?=
 =?utf-8?B?T1E0Y1Zyek1BeXY5K1ZVTGQwemJXS2R0aUJSQjRLdEhXVHZITElpTis5ejdS?=
 =?utf-8?B?dTNMMzNVb3lteXFQWVhlaE5zSVFDTUNic0h6cjFxZklHd2ZOUmFxWU50VmxW?=
 =?utf-8?B?RFYwRDFLa3VjYW5EQnBjSkJCQmFlRE5SVUNyWHNFU29hWnV4NVUvYnFnY2dG?=
 =?utf-8?B?c2ptcWk2RjZhaHU5OG9yZktqbUNiVzVqOWg4aFBlMHhNUnh6eG1hOFROOFFI?=
 =?utf-8?B?T2Vmd0d3OE1XRE9EcDhxWVhvLzBlakorbWxsdzNRbldpemFkRWdXRC9oQzdh?=
 =?utf-8?B?anJXTDE1NjRqZ250clpvRlVxU2VpcGh4S3NtdlllbU1ad2N4WVVVRmJnN3R0?=
 =?utf-8?B?ZTc0djlLWFlVbzcweVpZdlhtNDZTMXJlQ1psU0JiU2FDWG1Xa0V1RzNJQkJh?=
 =?utf-8?B?YWREOXJWNDF2TXV6L05nUnA5S3FRUEgxdTBnby9TRUtpUGYyYVF4LzVHYXdJ?=
 =?utf-8?B?a1laQkN2cHdQRTJWU0p4UG1DcHhmV003anpTZ0Z0UGtkREVlN2RjVEg4d2dS?=
 =?utf-8?B?ZDFXdlM1T3FyVDRRWHlraEkyQ2hySTJpbjBCYkR4MmNKcnlIeDNySXVVc0lp?=
 =?utf-8?B?NjdidUo0VWxvSFhraU1ZMkFlcjZoMEc2eGxqMjM2YUJNc1VQOEJlK2wzWWxj?=
 =?utf-8?B?OEcrcnQ4TVNTRk5DekRVY0VVSXNBemtQZnFHMmFCMjhBVmZlWGZOcWlmWDFz?=
 =?utf-8?B?K2k2SEI3QkVQREVPSytCZVF5dUk5a3l6TUxqM2RuU0IyWk4vU213eTgzMDR3?=
 =?utf-8?B?YWgyVjl2cnVzU0pRbXlZU2dKVkVVbTJHQXQrVjFnQmZTMzVWc1FqeFBSSXF6?=
 =?utf-8?B?UGJzU0Nld3Qxc1I1TE1qOE5HdmQ2RXN3SVVSdTZwSHF2ZmE1am9kRnVTaTha?=
 =?utf-8?B?UkVlcXdZWDJYa3JrYkhiUldsTFhXSVBYM2RZeSt3aS9BU1dYOHozcTlRdE42?=
 =?utf-8?B?S1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0F3AF21E4C153D4BB55C33D71AAA8F4D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b5d6ce2-522b-46f3-1654-08da5b35f5fa
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Jul 2022 07:47:34.3923
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4IKXeQFzPTsiPM2a20QpJeqLB7FRFIJs9ASTzp8g1SHcc2VGx/FcvQfdnVRpiPXUD1a5uVVzUJv9Lukz7qT6CFe6AAVXEPV2kwygkgop5Rc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1257
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDEuMDcuMjAyMiAwOTo1OCwgQ29ub3IgRG9vbGV5IHdyb3RlOg0KPiBUbyBkYXRlLCB0aGUg
TWljcm9jaGlwIFBvbGFyRmlyZSBTb0MgKE1QRlMpIGhhcyBiZWVuIHVzaW5nIHRoZQ0KPiBjZG5z
LG1hY2IgY29tcGF0aWJsZSwgaG93ZXZlciB0aGUgZ2VuZXJpYyBkZXZpY2UgZG9lcyBub3QgaGF2
ZSByZXNldA0KPiBzdXBwb3J0LiBBZGQgYSBuZXcgY29tcGF0aWJsZSAmIC5kYXRhIGZvciBNUEZT
IHRvIGhvb2sgaW50byB0aGUgcmVzZXQNCj4gZnVuY3Rpb25hbGl0eSBhZGRlZCBmb3IgenlucW1w
IHN1cHBvcnQgKGFuZCBtYWtlIHRoZSB6eW5xbXAgaW5pdA0KPiBmdW5jdGlvbiBnZW5lcmljIGlu
IHRoZSBwcm9jZXNzKS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENvbm9yIERvb2xleSA8Y29ub3Iu
ZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiX21haW4uYyB8IDI1ICsrKysrKysrKysrKysrKysrLS0tLS0tLQ0KPiAgMSBmaWxl
IGNoYW5nZWQsIDE4IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMv
bmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMNCj4gaW5kZXggZDg5MDk4ZjRlZGU4Li4z
MjVmMDQ2M2ZkNDIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2Uv
bWFjYl9tYWluLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21h
aW4uYw0KPiBAQCAtNDY4OSwzMyArNDY4OSwzMiBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG1hY2Jf
Y29uZmlnIG5wNF9jb25maWcgPSB7DQo+ICAJLnVzcmlvID0gJm1hY2JfZGVmYXVsdF91c3JpbywN
Cj4gIH07DQo+ICANCj4gLXN0YXRpYyBpbnQgenlucW1wX2luaXQoc3RydWN0IHBsYXRmb3JtX2Rl
dmljZSAqcGRldikNCj4gK3N0YXRpYyBpbnQgaW5pdF9yZXNldF9vcHRpb25hbChzdHJ1Y3QgcGxh
dGZvcm1fZGV2aWNlICpwZGV2KQ0KDQpJdCBkb2Vzbid0IHNvdW5kIGxpa2UgYSBnb29kIG5hbWUg
Zm9yIHRoaXMgZnVuY3Rpb24gYnV0IEkgZG9uJ3QgaGF2ZQ0Kc29tZXRoaW5nIGJldHRlciB0byBw
cm9wb3NlLg0KDQo+ICB7DQo+ICAJc3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IHBsYXRmb3JtX2dl
dF9kcnZkYXRhKHBkZXYpOw0KPiAgCXN0cnVjdCBtYWNiICpicCA9IG5ldGRldl9wcml2KGRldik7
DQo+ICAJaW50IHJldDsNCj4gIA0KPiAgCWlmIChicC0+cGh5X2ludGVyZmFjZSA9PSBQSFlfSU5U
RVJGQUNFX01PREVfU0dNSUkpIHsNCj4gLQkJLyogRW5zdXJlIFBTLUdUUiBQSFkgZGV2aWNlIHVz
ZWQgaW4gU0dNSUkgbW9kZSBpcyByZWFkeSAqLw0KPiArCQkvKiBFbnN1cmUgUEhZIGRldmljZSB1
c2VkIGluIFNHTUlJIG1vZGUgaXMgcmVhZHkgKi8NCj4gIAkJYnAtPnNnbWlpX3BoeSA9IGRldm1f
cGh5X29wdGlvbmFsX2dldCgmcGRldi0+ZGV2LCBOVUxMKTsNCj4gIA0KPiAgCQlpZiAoSVNfRVJS
KGJwLT5zZ21paV9waHkpKSB7DQo+ICAJCQlyZXQgPSBQVFJfRVJSKGJwLT5zZ21paV9waHkpOw0K
PiAgCQkJZGV2X2Vycl9wcm9iZSgmcGRldi0+ZGV2LCByZXQsDQo+IC0JCQkJICAgICAgImZhaWxl
ZCB0byBnZXQgUFMtR1RSIFBIWVxuIik7DQo+ICsJCQkJICAgICAgImZhaWxlZCB0byBnZXQgU0dN
SUkgUEhZXG4iKTsNCj4gIAkJCXJldHVybiByZXQ7DQo+ICAJCX0NCj4gIA0KPiAgCQlyZXQgPSBw
aHlfaW5pdChicC0+c2dtaWlfcGh5KTsNCj4gIAkJaWYgKHJldCkgew0KPiAtCQkJZGV2X2Vycigm
cGRldi0+ZGV2LCAiZmFpbGVkIHRvIGluaXQgUFMtR1RSIFBIWTogJWRcbiIsDQo+ICsJCQlkZXZf
ZXJyKCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gaW5pdCBTR01JSSBQSFk6ICVkXG4iLA0KPiAgCQkJ
CXJldCk7DQo+ICAJCQlyZXR1cm4gcmV0Ow0KPiAgCQl9DQo+ICAJfQ0KPiAgDQo+IC0JLyogRnVs
bHkgcmVzZXQgR0VNIGNvbnRyb2xsZXIgYXQgaGFyZHdhcmUgbGV2ZWwgdXNpbmcgenlucW1wLXJl
c2V0IGRyaXZlciwNCj4gLQkgKiBpZiBtYXBwZWQgaW4gZGV2aWNlIHRyZWUuDQo+ICsJLyogRnVs
bHkgcmVzZXQgY29udHJvbGxlciBhdCBoYXJkd2FyZSBsZXZlbCBpZiBtYXBwZWQgaW4gZGV2aWNl
IHRyZWUNCj4gIAkgKi8NCg0KVGhlIG5ldyBjb21tZW50IGNhbiBmaXQgb24gYSBzaW5nbGUgbGlu
ZS4NCg0KPiAgCXJldCA9IGRldmljZV9yZXNldF9vcHRpb25hbCgmcGRldi0+ZGV2KTsNCj4gIAlp
ZiAocmV0KSB7DQo+IEBAIC00NzM3LDcgKzQ3MzYsNyBAQCBzdGF0aWMgY29uc3Qgc3RydWN0IG1h
Y2JfY29uZmlnIHp5bnFtcF9jb25maWcgPSB7DQo+ICAJCQlNQUNCX0NBUFNfR0VNX0hBU19QVFAg
fCBNQUNCX0NBUFNfQkRfUkRfUFJFRkVUQ0gsDQo+ICAJLmRtYV9idXJzdF9sZW5ndGggPSAxNiwN
Cj4gIAkuY2xrX2luaXQgPSBtYWNiX2Nsa19pbml0LA0KPiAtCS5pbml0ID0genlucW1wX2luaXQs
DQo+ICsJLmluaXQgPSBpbml0X3Jlc2V0X29wdGlvbmFsLA0KPiAgCS5qdW1ib19tYXhfbGVuID0g
MTAyNDAsDQo+ICAJLnVzcmlvID0gJm1hY2JfZGVmYXVsdF91c3JpbywNCj4gIH07DQo+IEBAIC00
NzUxLDYgKzQ3NTAsMTcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZpZyB6eW5xX2Nv
bmZpZyA9IHsNCj4gIAkudXNyaW8gPSAmbWFjYl9kZWZhdWx0X3VzcmlvLA0KPiAgfTsNCj4gIA0K
PiArc3RhdGljIGNvbnN0IHN0cnVjdCBtYWNiX2NvbmZpZyBtcGZzX2NvbmZpZyA9IHsNCj4gKwku
Y2FwcyA9IE1BQ0JfQ0FQU19HSUdBQklUX01PREVfQVZBSUxBQkxFIHwNCj4gKwkJCU1BQ0JfQ0FQ
U19KVU1CTyB8DQo+ICsJCQlNQUNCX0NBUFNfR0VNX0hBU19QVFAsDQoNCkV4Y2VwdCBmb3Igenlu
cW1wIGFuZCBkZWZhdWx0X2dlbV9jb25maWcgdGhlIHJlc3Qgb2YgdGhlIGNhcGFiaWxpdGllcyBm
b3INCm90aGVyIFNvQ3MgYXJlIGFsaWduZWQgc29tZXRoaW5nIGxpa2UgdGhpczoNCg0KKwkuY2Fw
cyA9IE1BQ0JfQ0FQU19HSUdBQklUX01PREVfQVZBSUxBQkxFIHwNCisJCU1BQ0JfQ0FQU19KVU1C
TyB8DQorCQlNQUNCX0NBUFNfR0VNX0hBU19QVFAsDQoNClRvIG1lIGl0IGxvb2tzIGJldHRlciB0
byBoYXZlIHlvdSBjYXBzIGFsaWduZWQgdGhpcyB3YXkuDQoNClRoYW5rIHlvdSwNCkNsYXVkaXUg
QmV6bmVhDQoNCj4gKwkuZG1hX2J1cnN0X2xlbmd0aCA9IDE2LA0KPiArCS5jbGtfaW5pdCA9IG1h
Y2JfY2xrX2luaXQsDQo+ICsJLmluaXQgPSBpbml0X3Jlc2V0X29wdGlvbmFsLA0KPiArCS51c3Jp
byA9ICZtYWNiX2RlZmF1bHRfdXNyaW8sDQo+ICsJLmp1bWJvX21heF9sZW4gPSAxMDI0MCwNCj4g
K307DQo+ICsNCj4gIHN0YXRpYyBjb25zdCBzdHJ1Y3QgbWFjYl9jb25maWcgc2FtYTdnNV9nZW1f
Y29uZmlnID0gew0KPiAgCS5jYXBzID0gTUFDQl9DQVBTX0dJR0FCSVRfTU9ERV9BVkFJTEFCTEUg
fCBNQUNCX0NBUFNfQ0xLX0hXX0NIRyB8DQo+ICAJCU1BQ0JfQ0FQU19NSUlPTlJHTUlJLA0KPiBA
QCAtNDc4Nyw2ICs0Nzk3LDcgQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBvZl9kZXZpY2VfaWQgbWFj
Yl9kdF9pZHNbXSA9IHsNCj4gIAl7IC5jb21wYXRpYmxlID0gImNkbnMsenlucW1wLWdlbSIsIC5k
YXRhID0gJnp5bnFtcF9jb25maWd9LA0KPiAgCXsgLmNvbXBhdGlibGUgPSAiY2Rucyx6eW5xLWdl
bSIsIC5kYXRhID0gJnp5bnFfY29uZmlnIH0sDQo+ICAJeyAuY29tcGF0aWJsZSA9ICJzaWZpdmUs
ZnU1NDAtYzAwMC1nZW0iLCAuZGF0YSA9ICZmdTU0MF9jMDAwX2NvbmZpZyB9LA0KPiArCXsgLmNv
bXBhdGlibGUgPSAibWljcm9jaGlwLG1wZnMtbWFjYiIsIC5kYXRhID0gJm1wZnNfY29uZmlnIH0s
DQo+ICAJeyAuY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsc2FtYTdnNS1nZW0iLCAuZGF0YSA9ICZz
YW1hN2c1X2dlbV9jb25maWcgfSwNCj4gIAl7IC5jb21wYXRpYmxlID0gIm1pY3JvY2hpcCxzYW1h
N2c1LWVtYWMiLCAuZGF0YSA9ICZzYW1hN2c1X2VtYWNfY29uZmlnIH0sDQo+ICAJeyAvKiBzZW50
aW5lbCAqLyB9DQoNCg==
