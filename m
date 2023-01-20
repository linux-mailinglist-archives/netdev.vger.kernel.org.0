Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FC367570E
	for <lists+netdev@lfdr.de>; Fri, 20 Jan 2023 15:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjATO0X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Jan 2023 09:26:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbjATOZv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Jan 2023 09:25:51 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1421660CB4;
        Fri, 20 Jan 2023 06:25:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1674224734; x=1705760734;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=XXzN7uFDKVrzjcectFxBVksY61e7WCmnLwAFBq17ZRM=;
  b=Gt1pqEXljjDmmJEK/yhG5W4RlkdfT7I6wFoWr3e5F8MDTlyD+jw64qW7
   hJoyEXoxkrlk71z75h5tAhedfocWTythC8maQotm1bTw/QO/LY/Gp9pS6
   UvZ8U72ImVzEpVDYz8Hlj5AZqTE/TAd62338+gVf1bOlF9rMmV6fBmK6x
   wMXoCgssfEIUK6aCzoJHw8tL2qyuKBsJRPEVCy/JzkIqLGqzIBE1bRYLj
   MlKfB0/M+1SJ1QJnhJ7l9beKoX7ocCV73c/az6G9n/3Vi7XvGBMVOFQuF
   lXjvZVgibx4HuWKeLW/1Y5tzu88Px2pfGwcqKQh/7j4zr3Y5PW7wXEdwf
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,232,1669100400"; 
   d="scan'208";a="197637328"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jan 2023 07:25:30 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 20 Jan 2023 07:25:14 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 20 Jan 2023 07:25:14 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YPCLYc5k2vfKt3bz0ZPxEUfOT2Hd4iryq7AKH/bbTxUZL5ycWb7ERd+5/LMQ7wxW3c0t0+6iSNsddlDPEJCeoTwKCkf14aEN0cAi/FDtf7bFQXs0eiy9oVF3q4iZSjWYwuhIb1ub4PzpwOWU+qHmbrHES8H8ftwSrJTIsu8HVVihlR6Z53PiJPA3xIReNUkvrxxYo1m10BuSylELimYGnWA+XX7s9HqOQNg95n1nHleN/lmbqQx4wjOzWfPl3PqMWOrrULY4Ra+Dou94dTGXlgugdf7dBt0wfHr+E7iALXSY29xNisQHdz6rgyfJJe1/LWKiDK4PgX1NfOCZ2LZMMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XXzN7uFDKVrzjcectFxBVksY61e7WCmnLwAFBq17ZRM=;
 b=gPxJEC8IO73TcACvEmUokJ6x4IHNOSqBgRFsUJCi5IFyoob3xDcLZL7SExpwEEbdmRC4YhjvOtpV+2O8VtmACUZLQHaQBOdByUOm9brqPHNNE6T6Ct2qstVVHQTUppLD3im0zLPx/3ZaMW3ax1UMeHcXSiCvOXVv7ILpUHKSUiUAYFvo0Op6cwHOd/AyOldVzNfSfmL4M3q9KKC0Tt2VgnslU3zHshsoZS1ca1YK/SsxVUhLGs0q0CK3tYmVXVvaYlC/8sAI4OTRXTfxKZW8pv7LP6JgfCyZi795Ul1uWuSg5utmCYJtLFwbpWBf/hs++5M9Fn+UsZpKhzXopMRiQw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XXzN7uFDKVrzjcectFxBVksY61e7WCmnLwAFBq17ZRM=;
 b=Va85uWoH6p8wud3fDJoHQYIC39dn4ecVFiLHuOQM0XSvAvRuhRp7oiGv056MRoQ0vu/OdMPkKWwbUa9S3r+E5jkdtQNSUv28Mul/g6kyiiMOcDltBw/dr4qkftJ3b/7gHkYP7HJuZU7i1DU1D0Bh7u55njSVNH9IouuEHeOBq7c=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA3PR11MB7535.namprd11.prod.outlook.com (2603:10b6:806:307::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.27; Fri, 20 Jan
 2023 14:25:12 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.5986.018; Fri, 20 Jan 2023
 14:25:12 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v2 4/4] net: dsa: microchip: enable EEE support
Thread-Topic: [PATCH net-next v2 4/4] net: dsa: microchip: enable EEE support
Thread-Index: AQHZLLCaWOUUGqo41kSb1nBU7nmcPa6nXKCA
Date:   Fri, 20 Jan 2023 14:25:12 +0000
Message-ID: <f8eb963ca4ed87e9c3150abdaa97bf956bb77cc3.camel@microchip.com>
References: <20230120092059.347734-1-o.rempel@pengutronix.de>
         <20230120092059.347734-5-o.rempel@pengutronix.de>
In-Reply-To: <20230120092059.347734-5-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA3PR11MB7535:EE_
x-ms-office365-filtering-correlation-id: 395844e2-2335-4b60-dff0-08dafaf22429
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F2YSKMnHiIf7ihZxGdy3e/YM15FUGTEacKNRND8mYBQdj8yRDNxxLY6WokqzviU8soCKMcAr9YtytrhlOYKcEYi/6aaIngX4ClFQvPA36tIfuTEA7UkqzMDLobLraFHi9a90T3eFdN4UeQQnuScm+a3R5oJVpy9ZUrO0PrsTQ3Av0EpzMxcOscW6qhGBnifPOtAygRbcC4JKQ0wPTofeqAH6wgzTpC5+yErlkdlE7+1OxaQf3LO+R1CmhFC3G9oSjgX1FrX+wBlfv+E7k0Zp/fKyd2EcbUq9eyi2+3wTnR2fjs5ph58GfCsDJ2/fjITH/Xmjd8GZfWWqtZhGtnRRgugHS/jsaWrCmE/e9OdjM7F6fckcVYQDJHzv8iSXFC4cTAakeHvIiZ4AL07ZsC1pufBtCdMmU1m3Gyx9eBkO6VR7fqqAgQOCrRi8XsAi3zt40tjnKa+PyADGmpnkWX4W+9Bhq0tNwCh/qLC4DeBK6kA/xIpd4CYr7JXIpljObdsY7MPHj74I3YqkOd9sxDu/M3yXvK4l++ZGxVqB46WP9/vjBRYVamMSycpvNvjWhEOtDnh07WXkcXPiWrbYhhcwqi3cMaTsGQGqSx/yVDTKWFsT1qMNOtCMh4eDBPwkjWkXngwjRn90r7Dva6ej5xfoMqKbpS4pkqtyM84rc5mrzwygE2Hnp9rZP3yJeWZafhYtx/2BIMOK581kkeSkOYrdW5HIaEIfDPRjZNfYcvdE1HC9Y5Wf9fHeu/jUdpIvZkQ/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199015)(122000001)(38100700002)(38070700005)(921005)(66446008)(7416002)(5660300002)(8936002)(86362001)(2906002)(66476007)(8676002)(76116006)(66556008)(91956017)(4326008)(41300700001)(64756008)(66946007)(2616005)(6512007)(186003)(83380400001)(6506007)(110136005)(316002)(54906003)(71200400001)(478600001)(6486002)(36756003)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UmtDSmVDbk5sVmF3SkYvQml6dTFhWk1ZRzZZYi9WS3hzeDFMWWtMV08vMCs3?=
 =?utf-8?B?TUQwQkx1bjF4SmROSW5CWE55bDVGNWNYaS84ZG1mdE5xdUM0NUNXZ2pPS3l2?=
 =?utf-8?B?aVhBNVJEL25yRmJUWjVCcXlxdXNPWHd3ZGZUR2ZaekVSTGZ0c2dJdTd4cEV3?=
 =?utf-8?B?dEQ5SDhFRUhnTUw5NGFrbXJudDJIZmh6MTBoQXZwZmgxSlFWQ1VuN2NORWRH?=
 =?utf-8?B?TmJreU1IUmcwU2tHS3U0NkNpYnpmTndYczFhMnU1VGwwc2ZpL0FhVGRUcEox?=
 =?utf-8?B?L212QXRZTzU5aVZSRUtIeExtQW80WS9Kc3pxMEMwUjZUUHo5VkhNaTNMV0pI?=
 =?utf-8?B?ek5ZWStqbFVWQkVpL2l4a0svVk9CSVMrMTJIVzNnSnlZV3oyYkM1ZlliYURR?=
 =?utf-8?B?MHFhZHpVMUJuMXlSYzBUYmtYNDZIWVJoajVwNG5ZYithR2orQ0NOc2VNeUJR?=
 =?utf-8?B?VmZMSmFLTm9OZHR2ZkhleTY3a0NkQnFPVm5IUDFrQVNkamRSMkgxVXVvcDMr?=
 =?utf-8?B?TkVCM1lzY3ZLQTRRbzAxU3hCTXl4anVuRFZiak0rRGIyVHBJQmZ1NjVJMklI?=
 =?utf-8?B?V2JhcFZsa3FLVFdLdnpXZ1IyZXd1SS9JbjN6NkJrUXBTYnNIN29QeDJlNXdX?=
 =?utf-8?B?SW5RTFp2QXVEc0pscXpFZ1ozb202SjRKMENack14aktmeUNreHg4ODFjM0hy?=
 =?utf-8?B?N1BmQUM2dDZZYjhRQnhlVnBGNHE4VGJDakdGRVNFdkpCYzdIckxpcEhvSVkx?=
 =?utf-8?B?eGpuMkQ1MWZFVVMyUDc5bWFWcGhiRDNXQVpsbzdUQTNXSjBobFB0SFp4NXQv?=
 =?utf-8?B?S3hsNXR4Qk5CWU9RSEk3UnN1b21Yd3EzSVpxTGpUQktNNFcvR1FxZnhXVDhw?=
 =?utf-8?B?amRGeUxHM1czWmI5K0R0RzQycWdJdDJObnZlNjBla1ZhM2lFeDI1MXBlV1hQ?=
 =?utf-8?B?cVg3S0QxQ1hTdDJZek9UV2hIMGEzQzI4TGlZbU0yOTZVSVhnZlR0R2MrU2JI?=
 =?utf-8?B?K0k4c3g5SWxZbVFkcFdGZUxSRG5uMlN5QVdYV0dTRmJaUFJCOEhTY3hEdHV4?=
 =?utf-8?B?emliRitJV0RGZmtMays3OGRhVk8xZDhySmNxR0VSOHpiZmI5SGpyOXkrYm1Y?=
 =?utf-8?B?ZWl0QlRZWXFDMlN0SUV2YzhDc3VEZEdwTWdMdjNXYWhZWDNXTitTMnlINktI?=
 =?utf-8?B?d0hmY3h3SUVFTFgrVDV3K1YwdVIvcEJrWXlhaDFrVFBJa2ZTTXBHb3ZWYjRR?=
 =?utf-8?B?eE9CR2xLdm14dFhqdU9LNkMxNjJCZ3hUdGxoOEVVWEx4ZHBSeGZEamF6dnlU?=
 =?utf-8?B?Nk1Dcm5ZTFg2STduS0ZYWU4rNjNBWEd2MFQ4MlFHWFU1ZG9KS3JQTDQ3VkVy?=
 =?utf-8?B?dkZ3NjZGL3oyWGZZT2FaeVJ4TG4rSGY2S011L1lTOEFhZDdLd0dTSjU1Nmlj?=
 =?utf-8?B?d256NTF3VWZpeW1XREJNUFpYcXI5M1BVRncrc01PUGFvY1NsdTFFWnpZcGRk?=
 =?utf-8?B?WWpDNGdLZkdTTjllc2VDVm5QVlFYYjh6ZEYzcmdxd2xmS2xiNENYblZSd25w?=
 =?utf-8?B?ZEdRYysyejlVK3lwb1ZMVVRGUFd2QWRFZFpJQmN0bFFmM3dzVU9SaFBPdDJC?=
 =?utf-8?B?QUljRUxORHBtRTBGSTl0TzFHL1RFb2hqTHlNUkF2RnJrNHhyZkI5VEhETzFC?=
 =?utf-8?B?ekJtN3BLSzMvSk5wZUgyUXNQQWJuaE9JRjhMSThxRmRGajFzU1NtZjQ0ZmxC?=
 =?utf-8?B?eGpNOHJ2UFZNQ0pFMWVPSFNBWFJHZU8xRlVqMGUra3I4UGYrOEx6Zm5hNW9l?=
 =?utf-8?B?ci81TklpcXFNUFBXRXBxdk1xWlFiazJtZVdzNHJMTXZQZlAweDB6TzcvRVpk?=
 =?utf-8?B?VExsYi9lbjBWbEFJUkJla0E2YitnNmhta1pNK0JISlk4QStUTitCMzJXVkRj?=
 =?utf-8?B?OUJpQXY1UUk2VmtrVzgxdkVXbWZIeUU4WEpwYkJnS3Y5TDhDOTdtcXJBOTEw?=
 =?utf-8?B?ZWNMS2dvaXd4T3lVUkhlR2hDVEpYVGQ3Q2VnTVQ2RjBQVG1ZWGtLRnhtOG1D?=
 =?utf-8?B?OGR5MzgvTnlyZWtHemVEWmhtZDRtVWgyYnZEREFlcXFZSkFKY1UrT1l5c29G?=
 =?utf-8?B?OU9TaklIaGpKNXVsM2VDeENuOU5zc21MelFrQzRnUXdsQmZvT1pEOGVPRWkw?=
 =?utf-8?B?cnhRU3d3cDM2UXc3SEozRUc3NzM5MVVsRlFKcUd6ME14cjlhTkoxWlhVeDR6?=
 =?utf-8?Q?+pzHZ8rCeKxdaDnzwZ2N8uut4pq11GGvwOPcWwZETY=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9AFC7EA6CEBA5D4F95F9CD5D2FD1AA7B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395844e2-2335-4b60-dff0-08dafaf22429
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2023 14:25:12.1787
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YlCPuJszcnJyNOCnwoT1QkeR0lyNLjBv++MPn4K3GnacFhWpRklq8Vwky6ENxqsYP8CLph0KjR8KRTmIfssPUjkM9fsa6vgmIZheC6dH4xQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA3PR11MB7535
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gRnJpLCAyMDIzLTAxLTIwIGF0IDEwOjIwICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBTb21lIG9mIEtTWjk0NzcgZmFtaWx5IHN3aXRjaGVzIHByb3ZpZGVzIEVFRSBzdXBwb3J0
LiBUbyBlbmFibGUgaXQsDQo+IHdlDQo+IGp1c3QgbmVlZCB0byByZWdpc3RlciBzZXRfbWFjX2Vl
ZS9zZXRfbWFjX2VlZSBoYW5kbGVycyBhbmQgdmFsaWRhdGUNCj4gc3VwcG9ydGVkIGNoaXAgdmVy
c2lvbiBhbmQgcG9ydC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE9sZWtzaWogUmVtcGVsIDxvLnJl
bXBlbEBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlw
L2tzel9jb21tb24uYyB8IDM1DQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3pfY29tbW9uLmMNCj4gaW5kZXggNWUxZTViZDU1NWQyLi4yZjFmNzFiM2JlODYgMTAw
NjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ICsr
KyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IEBAIC0yNjQ1LDYg
KzI2NDUsMzkgQEAgc3RhdGljIGludCBrc3pfbWF4X210dShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMs
DQo+IGludCBwb3J0KQ0KPiAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gIH0NCj4gDQo+
ICtzdGF0aWMgaW50IGtzel92YWxpZGF0ZV9lZWUoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQg
cG9ydCkNCj4gK3sNCj4gKyAgICAgICBzdHJ1Y3Qga3N6X2RldmljZSAqZGV2ID0gZHMtPnByaXY7
DQo+ICsNCj4gKyAgICAgICBpZiAoIWRldi0+aW5mby0+aW50ZXJuYWxfcGh5W3BvcnRdKQ0KPiAr
ICAgICAgICAgICAgICAgcmV0dXJuIC1FT1BOT1RTVVBQOw0KPiArDQo+ICsgICAgICAgc3dpdGNo
IChkZXYtPmNoaXBfaWQpIHsNCj4gKyAgICAgICBjYXNlIEtTWjg1NjNfQ0hJUF9JRDoNCj4gKyAg
ICAgICBjYXNlIEtTWjk0NzdfQ0hJUF9JRDoNCj4gKyAgICAgICBjYXNlIEtTWjk1NjNfQ0hJUF9J
RDoNCj4gKyAgICAgICBjYXNlIEtTWjk1NjdfQ0hJUF9JRDoNCj4gKyAgICAgICBjYXNlIEtTWjk4
OTNfQ0hJUF9JRDoNCj4gKyAgICAgICBjYXNlIEtTWjk4OTZfQ0hJUF9JRDoNCj4gKyAgICAgICBj
YXNlIEtTWjk4OTdfQ0hJUF9JRDoNCj4gKyAgICAgICAgICAgICAgIHJldHVybiAwOw0KPiArICAg
ICAgIH0NCj4gKw0KPiArICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gK30NCj4gKw0KPiAr
c3RhdGljIGludCBrc3pfZ2V0X21hY19lZWUoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9y
dCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGV0aHRvb2xfZWVlICplKQ0K
PiArew0KPiArICAgICAgIHJldHVybiBrc3pfdmFsaWRhdGVfZWVlKGRzLCBwb3J0KTsNCj4gK30N
Cj4gKw0KPiArc3RhdGljIGludCBrc3pfc2V0X21hY19lZWUoc3RydWN0IGRzYV9zd2l0Y2ggKmRz
LCBpbnQgcG9ydCwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgc3RydWN0IGV0aHRvb2xf
ZWVlICplKQ0KPiArew0KPiArICAgICAgIHJldHVybiBrc3pfdmFsaWRhdGVfZWVlKGRzLCBwb3J0
KTsNCj4gK30NCj4gKw0KDQpuaXQ6IEFzIGJvdGggc2V0IGFuZCBnZXQgZnVuY3Rpb24gcGVyZm9y
bSB0aGUgc2FtZSBvcGVyYXRpb24sIHdlIGNhbg0KYXNzaWduIC5nZXRfbWFjX2VlZSBhbmQgLnNl
dF9tYWNfZWVlIHRvIGtzel92YWxpZGF0ZV9lZWUgZnVuY3Rpb24gYnkNCmNoYW5naW5nIGl0cyBw
cm90b3R5cGUuIEluIGZ1dHVyZSwgaWYgYW55IHRoaW5ncyB0byBiZSBhZGRlZCBzcGVjaWZpYw0K
dG8gZ2V0IG9yIHNldCwgd2UgY2FuIHNlcGFyYXRlIGl0IHRvIHR3byBmdW5jdGlvbi4NCg0KPiAg
c3RhdGljIHZvaWQga3N6X3NldF94bWlpKHN0cnVjdCBrc3pfZGV2aWNlICpkZXYsIGludCBwb3J0
LA0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgcGh5X2ludGVyZmFjZV90IGludGVyZmFjZSkN
Cj4gIHsNCj4gQEAgLTMwMDYsNiArMzAzOSw4IEBAIHN0YXRpYyBjb25zdCBzdHJ1Y3QgZHNhX3N3
aXRjaF9vcHMNCj4ga3N6X3N3aXRjaF9vcHMgPSB7DQo+ICAgICAgICAgLnBvcnRfaHd0c3RhbXBf
c2V0ICAgICAgPSBrc3pfaHd0c3RhbXBfc2V0LA0KPiAgICAgICAgIC5wb3J0X3R4dHN0YW1wICAg
ICAgICAgID0ga3N6X3BvcnRfdHh0c3RhbXAsDQo+ICAgICAgICAgLnBvcnRfcnh0c3RhbXAgICAg
ICAgICAgPSBrc3pfcG9ydF9yeHRzdGFtcCwNCj4gKyAgICAgICAuZ2V0X21hY19lZWUgICAgICAg
ICAgICA9IGtzel9nZXRfbWFjX2VlZSwNCj4gKyAgICAgICAuc2V0X21hY19lZWUgICAgICAgICAg
ICA9IGtzel9zZXRfbWFjX2VlZSwNCj4gIH07DQo+IA0KPiAgc3RydWN0IGtzel9kZXZpY2UgKmtz
el9zd2l0Y2hfYWxsb2Moc3RydWN0IGRldmljZSAqYmFzZSwgdm9pZCAqcHJpdikNCj4gLS0NCj4g
Mi4zMC4yDQo+IA0K
