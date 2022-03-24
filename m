Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57CC44E664B
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 16:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351395AbiCXPuj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 11:50:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344780AbiCXPui (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 11:50:38 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4209736313;
        Thu, 24 Mar 2022 08:49:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1648136944; x=1679672944;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=OAyLSFVAcxmqzB5jZUvoiOyAzVFPe8VA5rCMHJ4Psf8=;
  b=s+GLLIVgbTQT5JF+MUfz6sMYtbV7DGTxXsksYDy9sFtKz6e2eEShskUZ
   Izw+1h9BA3jolbWhTMR4GbMXaqy8YRFZls+CSs+l6vT/5LJ8jkL3QSBnU
   Cm0Vj03OZaJOHFUDf+BYcELlLq6XibSYjQwOUl0uKmdngTTX6tUnrcxJ1
   xHXf2QoZm2ibcdyTWuX4zumXUczhOePnU3xYFCplOfeaGEi4zQQX7SHlA
   kZKzr+OkVubE+2G/MfWpVWH7pr1ZtTQ3IWOcfMIlRlo9Q//ZZoagO47zR
   eocWdGTmk1u3zmsTOnEdddYj3oFMfqQgGB2/+054i0dwr2L9NHk0zq6Qv
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,207,1643698800"; 
   d="scan'208";a="90044126"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2022 08:49:02 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 24 Mar 2022 08:49:02 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 24 Mar 2022 08:49:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IkAdbYPFQV6ewK/70YAL1awQXxB7FpUEr5Pz6xmcyUdCDDgDf9QPcTD03KiSSdk+Rcz87SpFT+SBz1GzBm7o5E8qjV8VR3ChNNgXoe0Xug2tDbiJr2Hkz5B+1eSVNPEfQ6pEKOAzcV4AL+6qO3hXuPh1GW7j4gapxUyL60IRGyW0HcuVtKda7HanfTVaCWgbeMhQgHpvoHG3wwPCbzS7WCIpS223SmOrUAwsMVu/GV6EVOjtfRFwII5LOkrfqIPPhs7PjP2qUYwBPdNRLsmsZ4F5YguFAaQ0h3e31ouSNiD1Z+DJNQ4xJiyV/jcJ28D8qPEGqAyiPsmuc0i9I3eNAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OAyLSFVAcxmqzB5jZUvoiOyAzVFPe8VA5rCMHJ4Psf8=;
 b=gcQgXJkrqrYNzQilRWbWPY6hWjw+O9D/IAWUc5gRZx6Ti301tUWMTTMuACzKxgg18DIbJc5b6hxZJrDM8g/Rz/SGyX69RcSolnZv9WQxEhnvlDQIvzBRvP7pRjQJybIgwbvPu8HAZJ04yJAZ9ypNHb4VGa/AoK9yYlVViK72JIhWTNHGbNIavtSJiyNQm/74hcLh0KpqgMhS9uIrab+QDJLlxXpE2PADyWKi/c5afBfqAmNyEl+qy6hSOkPhoAdOpFNaPoFF37CLrZWeTamBAmit3m0C+T+GGD/FMl46lQcgT4zhR+1tFPaAx8WqmbQ2OeBeRtov5T/5A+5jVVGQxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OAyLSFVAcxmqzB5jZUvoiOyAzVFPe8VA5rCMHJ4Psf8=;
 b=TDUPQDnXVB68KfzO9orzWWPgGeMzkBB8NjORpXIJiE5SREPzpgb3mNy5hj9y/YmMSzrI4qYJQGqxLVsxouzf6SLo8FiIPWdiR6ttqeLLutb9un33mmpF6qFipGpE66tI59nSCtPXVXkq/92cCfhiCbGCiTj9J/QhbWhPKqigiFc=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH7PR11MB6029.namprd11.prod.outlook.com (2603:10b6:510:1d0::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5102.19; Thu, 24 Mar 2022 15:48:57 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::f13d:328d:8e22:2b3]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::f13d:328d:8e22:2b3%6]) with mapi id 15.20.5102.016; Thu, 24 Mar 2022
 15:48:57 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <andrew@lunn.ch>
CC:     <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <linux@armlinux.org.uk>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>
Subject: Re: [RFC Patch net-next 3/3] net: phy: lan87xx: added ethtool SQI
 support
Thread-Topic: [RFC Patch net-next 3/3] net: phy: lan87xx: added ethtool SQI
 support
Thread-Index: AQHYPTv6Rz9N3nMm00iQFEEVAeUBG6zKKrmAgASIJIA=
Date:   Thu, 24 Mar 2022 15:48:57 +0000
Message-ID: <ba1d251a9bd93cdf4c894313637dd9618cd8091c.camel@microchip.com>
References: <20220321155337.16260-1-arun.ramadoss@microchip.com>
         <20220321155337.16260-4-arun.ramadoss@microchip.com>
         <YjjFtUEDm2Dta1ez@lunn.ch>
In-Reply-To: <YjjFtUEDm2Dta1ez@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 86a5fc02-cad6-4207-406e-08da0dadce81
x-ms-traffictypediagnostic: PH7PR11MB6029:EE_
x-microsoft-antispam-prvs: <PH7PR11MB6029B121BDFAA519A8FC59B6EF199@PH7PR11MB6029.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c31yxRUeBBBbwbp9xAyJvz1jbAUTr3XVyefe+jKd6KlA9Ar79tYB4i3FI9wIFP+GqDB9WCk8Tne1/E0JxzRN6cWs9yd5WWFOuz1OPpie9WiW7myDpaL9Dz8VdsZOSJUo40plvR9euiSs3xaJCOSWO5t4BZmfx6fOsz/KmorFB27ujVqD+CWW9dopI6eFU1IDXUeZJbKhCBnjESJmSBxPo4Sbb2trcgPeln3tMcskesmKR1R3OcX9BQcvVD2RJ/+EupVAUcWRfbiXTbaNUtOWO6A17Av8jrWPGgCiudxd7eWPcicqUQdkwxZ9seiMevRcvOEDqDzcHsM7drsUc0HQS3W24dVMzraBP/I0Sqjin21igERJDcWnglph+bfbFWofTRJ9hjxko+8Qd/D7ttWldc617OoFpHUw2uTh2P2JQs5eky1sQ2xI5GWiAwbek27U3DUAo0g5NbHy5aQaNRBSMeT3L4rPQe7X4hpxbGY+Lj+UBJ7T2eNwS7MgJQ4g8/EWhFFRvgR1NPYo4lZfZp63a7GQ3VSCf22WeAzvJfax81Mn16nFtxoKHgBOH2SenuLJkxX4cgm3iAjx2NObDdLyo19u3jSNMUMnR2pOke8Tzqqzk4YqXoax0F/F6AoPUerWcOqj9uQFsEyLD/wW9O4ubIIo+02NqpElMg6hK4HHlz0Uw8DJxXWErXB+YD8ErKOhuNhqPvT9gBxPJn0R1pZnNIRZ9wijyt3fz4hvJVk6S+s=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2616005)(38070700005)(76116006)(66556008)(66946007)(66476007)(64756008)(36756003)(8676002)(66446008)(4326008)(316002)(71200400001)(38100700002)(122000001)(91956017)(54906003)(6916009)(6512007)(86362001)(508600001)(6486002)(2906002)(6506007)(186003)(5660300002)(8936002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OGhicE9UR3VVZk5IdWswSkNhK1k5cW5jMmZaZ0R3VlJBTG9JeExVL3lkbXhP?=
 =?utf-8?B?d0xEWjd1OU1ITlZUcWJpRmQ4ZEhTeTB3Z1RHMWpxWlllUHNicGExU3FPclly?=
 =?utf-8?B?NjBpak83NHdnVlVPMUdrbXZkRm1PZlVhK0pBKzlVSEN4RGZpUkN2OFhUVVQ3?=
 =?utf-8?B?RzFzL3hPbkEreXcxUk1rbmZpS0lXSzg3bG56Rkl0YkpJSk9tcG00SUVqamNQ?=
 =?utf-8?B?TGJJMm9RZnAyUmxNTkFpcUdySkZRT2I4Z0psTW80R2NkTW9Gbkd4MXIxQ0U5?=
 =?utf-8?B?QjBNdTVyMnRHcjdFWnJUSFJ3M0g4dWt1ejVDR01HNHpxeWNEWGR2dVJZeGZ4?=
 =?utf-8?B?U1Y5VlBTbkdCamFLSnFyb0dZSmhaZzdkZWFaSmF4bU5EdE9HcHhrQk5IQ3ZO?=
 =?utf-8?B?d2E2U1NkMHdNcmUwZUhITTZ5aG95WHoxa3ZvTUxlWGs0cHM3SWovRGtVdllq?=
 =?utf-8?B?MnlGSGxuVWlVVGpxZmRCRG5yQWVmSFdCUUQ5TVdnc0JLbk93ZFdnUkIvYWhB?=
 =?utf-8?B?cXA4K1lMWXc4djNLU3dWZzdaY2kxeWJkUGNXR2k4aFJQeGFycDIrem43L204?=
 =?utf-8?B?RGtMc1hzcG1iT0QvTDJYTXRpYjNnL2taSDZrZ3oya0JrcDd1cmUvZG9zRTJ5?=
 =?utf-8?B?d1pEK0QxM1FHTjhrTG1CeVFQUy9XM2RXTHBweitCaFNqVTl6eDA5akJ4ZSt2?=
 =?utf-8?B?YzZYcmY2LzJSWWsvcVh4MzRSdDIwTzdYUzA1bWhScUhxbWFyeGtrbXhWZCtZ?=
 =?utf-8?B?bS9VREtBVzZMcGdLSVN3UkErZ3lGTW16cG8vL2NzT1hGVk9oWTFRMjM4bERB?=
 =?utf-8?B?dGt2d0NxNjQ4a1ZZck0rMFNHMVNvK1JiWkNza2JDR0prY0c1d0NYRWRMUXd4?=
 =?utf-8?B?OHlCbEZxOWFXdDFYMnQvb2RhTFIvWGlueUZrU0tNY2N0cndWNFgrRE9SZk9C?=
 =?utf-8?B?a0dSWVZBUFJ4VWo3MklmaWZreHZHZnZKWnM0YlVVcjhDZEdRbXRJRXRhZEw3?=
 =?utf-8?B?dzluZHpBRE9HWnVWNVdNclFYS0p0dXNQeWpsRXVSb3ExUnlnNHRVYzg2RzE3?=
 =?utf-8?B?dmdic0RkLzFaZEVveGJEMFczcjMxMVdwZjRVSjR6WTNYNHc1SXZVendYbjkz?=
 =?utf-8?B?Zm90KzhQOFVtdUs5cXgydmNzOCtCbkFyY1pIak90VVZuQlFQNjdSWkJFUlBo?=
 =?utf-8?B?ekNYeVFicUM3NkRKeHRhMWxJczVnbjlLV05tNG1KOVpMQW1rbkJNcllaa1RF?=
 =?utf-8?B?MU5oaFVmbGFnZjdBRDlxNGp0aTI5Y0FZZm9LZjNzUkgvUWM0dU1hcG95NUZ0?=
 =?utf-8?B?L0RwY2pvalBraDFKMkErZW9RVmd4UXg5NVJjZU5xTTI5RStaS01YSXE2a3Vs?=
 =?utf-8?B?ZkJYbHhFVVM2RUhmWklCMjVjMW1lVFEvbUppWHpiZC9DTWZVN1VGd0k0a1ZN?=
 =?utf-8?B?cWg2VzhzY3MySWZKZCsrNzhsWjJ1L3FhMEFkQ0k1aDNYc3NmelBKYXZ1TWtl?=
 =?utf-8?B?QUk2RUxqRUIxeEZEaEJPcnEzNjF4KzB1aFZ6ZVhWZUpEWFdLWUhuc2FQRElo?=
 =?utf-8?B?UnQvK3lUZitkbDJLSC9YR2hJck9xN2JUa1YvbVRJSWdlWEs4ZTcrYno0UDNj?=
 =?utf-8?B?K1pSdFNaVDdVZFJObStiaGJmM3ZacUtXSm5zTHJXNUZSRFZhejBNS0Z0V2l6?=
 =?utf-8?B?TDhUaktyZzQ1R2ZuLzg3RHZRM1lXNG9lbU95ZlBsQ2hUZktIM0xhMGVYYzJL?=
 =?utf-8?B?RE5ta1o0YTNKVDg3OEJKa2t6SDJpdmx3Q0NlUkJ2a0hyRlB0TW1JT1hUQ0Jw?=
 =?utf-8?B?NXFUbzFhNnc1U2hiZnh6ajZGSmRvWnRSZ0QxRTdwa0s0NWpLQ0NoWWE1WmN5?=
 =?utf-8?B?OVo4UkZNVEUrc05oZEJNODMxNlZWNzE4STNmQ3JFQ1BxTTlnQ2RpQW5uQjlZ?=
 =?utf-8?B?VjhUT0svVlNPYi9SMjl6NHdJdklRTkg3SFhOQ3lwQXc1TERPZS9BNkFIZGhp?=
 =?utf-8?B?aDcwTlBmNjA0WGNZOWZ2Y2NxWFJNTzJ0ek44WG1JaHVSZkxMVUs4WmhPd3lr?=
 =?utf-8?B?cUVFMXl2dDlQUGhDR2J2dTdxUFBHZDJENm1GSzVzeTJCWE5VZlJYaUJqRTFn?=
 =?utf-8?B?T3lKQnZLTkJRTUR1TmNuU2tOQ3d3ZWEzd1ZrcjN1b1RKWE1idzkzemZ1NHhR?=
 =?utf-8?B?SjVMMFBMczcvMWp4YTRod1ZvUWxrM0tPTGU3MWdLR0RVT0Q0RXppNDFKRzEz?=
 =?utf-8?B?NVRQZDFBckl3d1FjSGdKenNuUnJ0T0UxWE5OWThUdlZTSDZHanFGU3NlSHVa?=
 =?utf-8?B?dVBuazV5RlJhOG8zM3c4N3A3d2RSR2k1NFhZRlN0SEdya1c0YkN1enNGUDh6?=
 =?utf-8?Q?vCCFh6gry9jI/olOpYRuVdU+Z3FHBYbDGjE1jiKSmQBHP?=
x-ms-exchange-antispam-messagedata-1: /568lWVPsCveMIGC7OvqbokqXH4OfxZ5XssoNYJKLAKPc8ffIjjc7apA
Content-Type: text/plain; charset="utf-8"
Content-ID: <CACAD07E85F89846B63CC2074E9AD283@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a5fc02-cad6-4207-406e-08da0dadce81
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Mar 2022 15:48:57.0645
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M/SHU+MYt9s707ku4otaIkefw8Dvi8DFjdqhcJJVbL5GY546Kn1OPGbEWbq9fHYEq8hv6wzAVJz93EgwwEVWFDnyqWwQTo2EuwycAxl7fKA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB6029
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LA0KDQpUaGFua3MgZm9yIHRoZSByZXZpZXcuDQoNCk9uIE1vbiwgMjAyMi0wMy0y
MSBhdCAxOTozNiArMDEwMCwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBE
byBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cg
dGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gPiArI2RlZmluZSBUMV9EQ1FfU1FJX01TSyAgICAg
ICAgICAgICAgICAgICAgICAgR0VOTUFTSygzLCAxKQ0KPiA+ICtzdGF0aWMgaW50IGxhbjg3eHhf
Z2V0X3NxaShzdHJ1Y3QgcGh5X2RldmljZSAqcGh5ZGV2KQ0KPiA+ICt7DQo+ID4gKyAgICAgdTE2
IHNxaV92YWx1ZVtMQU44N1hYX1NRSV9FTlRSWV07DQo+ID4gKyAgICAgZm9yIChpID0gMDsgaSA8
IExBTjg3WFhfU1FJX0VOVFJZOyBpKyspIHsNCj4gPiArDQo+ID4gKyAgICAgICAgICAgICBzcWlf
dmFsdWVbaV0gPSBGSUVMRF9HRVQoVDFfRENRX1NRSV9NU0ssIHJjKTsNCj4gPiArDQo+ID4gKyAg
ICAgLyogU29ydGluZyBTUUkgdmFsdWVzICovDQo+ID4gKyAgICAgc29ydChzcWlfdmFsdWUsIExB
Tjg3WFhfU1FJX0VOVFJZLCBzaXplb2YodTE2KSwNCj4gPiBsYW44N3h4X3NxaV9jbXAsIE5VTEwp
Ow0KPiANCj4gU29ydCBpcyBxdWl0ZSBoZWF2eXdlaWdodC4gWW91ciBTUUkgdmFsdWVzIGFyZSBp
biB0aGUgcmFuZ2UgMC03DQo+IHJpZ2h0Pw0KPiBTbyByYXRoZXIgdGhhbiBoYXZlIGFuIGFycmF5
IG9mIExBTjg3WFhfU1FJX0VOVFJZIGVudHJpZXMsIHdoeSBub3QNCj4gY3JlYXRlIGEgaGlzdG9n
cmFtPyBZb3UgdGhlbiBqdXN0IG5lZWQgdG8ga2VlcCA4IHVpbnRzLiBUaGVyZSBpcyBubw0KPiBu
ZWVkIHRvIHBlcmZvcm0gYSBzb3J0IHRvIGRpc2NhcmQgdGhlIG91dGxpZXJzLCBzaW1wbHkgcmVt
b3ZlIGZyb20NCj4gdGhlDQo+IG91dGVyIGhpc3RvZ3JhbSBidWNrZXRzLiBBbmQgdGhlbiB5b3Ug
Y2FuIGNhbGN1bGF0ZSB0aGUgYXZlcmFnZS4NCj4gDQo+IFRoYXQgc2hvdWxkIGJlIGZhc3RlciBh
bmQgdXNlIGxlc3MgbWVtb3J5Lg0KPiANCj4gICAgICBBbmRyZXcNCg0KSSBjb3VsZCBnZXQgdGhl
IGFsZ29yaXRobSBmb3IgcmVwbGFjaW5nIGFycmF5IG9mIExBTjg3WFhfU1FJX0VOVFJZKDIwMCkN
CnRvIGFycmF5IG9mIDggKHNxaSB2YWx1ZXMgMCB0byA3KSBhbmQgaW5jcmVtZW50IHRoZSBhcnJh
eVtzcWlfdmFsdWVdDQpmb3IgZXZlcnkgcmVhZGluZy4gQW5kIGNhbGN1bGF0ZSB0aGUgQXZlcmFn
ZSA9ICggMSAqIGFycmF5WzFdICsgMiAqDQphcnJheVsyXSAuLi4gKyA3ICogYXJyYXlbN10pL0xB
Tjg3WFhfU1FJX0VOVFJZLiBCeSB0aGlzIHdheSB3ZSBnZXQgdGhlDQphdmVyYWdlIGZvciAyMDAg
ZW50cmllcy4NCkJ1dCBJIGNvdWxkbid0IGdldCB0aGUgYWxnb3JpdGhtIG9uIGhvdyB0byBkaXNj
YXJkIHRoZSBvdXRsaWVycyBmcm9tDQp0aGUgYnVja2V0cy4gb3VyIG1haW4gYWltIGlzIHRvIGF2
ZXJhZ2UgZnJvbSBhcnJheVs0MF0gdG8gYXJyYXJ5WzE2MF0NCnZhbHVlLiBDYW4geW91IGJpdCBl
bGFib3JhdGUgb24gaG93IHRvIHJlbW92ZSB0aGUgb3V0ZXIgaGlzdG9ncmFtDQpidWNrZXRzLg0K
DQpBcnVuDQoNCg==
