Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2BD562027
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 18:20:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbiF3QUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 12:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236097AbiF3QUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 12:20:23 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 811F42A428;
        Thu, 30 Jun 2022 09:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656606022; x=1688142022;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=IvryVm35M7XaaFczN1NEItQqso5NUvMa5/2a5x79jbk=;
  b=X9VGyDog5U/gNHvyYrBbqOcH1ttvTYpu25ZLcfIIjY/sVmlMVzUNi802
   VLbVWgH3G8bF95QO423OTl/O59vyq2lOLuvNiVFuACEj9jgI1uOb92kD5
   5Mi1apJbUBzbDp9jU6Ymzhp8lfUmbnL2I7X7CblxmeQr6u5EaMmwLssRZ
   OqV5WNISzwwHexEWBQPyqWimHOjyoAiWRvbd/bEG/x6YMWB6R2utfusxj
   EPwFTpZCnTqMmh5Tk2zZodxr/yc75N4W7OGT4xvQSicdUC1AtGQaQxDQe
   cU1vFTzf2R9OFa+AUX62iLxVK//vOhmv3335v2PkVqpHIMrV3fG0CHiCr
   w==;
X-IronPort-AV: E=Sophos;i="5.92,234,1650956400"; 
   d="scan'208";a="170560878"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 30 Jun 2022 09:20:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 30 Jun 2022 09:20:21 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Thu, 30 Jun 2022 09:20:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MgRPre/JIUco4PZMpsn8QNjJxv/1gTBw4/0FG45w2DNS8gZecn550e4FYcNKbNYD1rP1yLT9cpm6aLz7VfFnMJ4qJLoyji7uR9HahMl2zCmvH+9qjBJAw0C95+YdURcpvpHjyLCSfxGsb6tjr/qyeyWn1uc5c3RTGIrnCVy2SOtCF7nZKzo2uoZcs+m3V/NSXB3St2aaf0yeQXzUyNh03ZF+r71sgu8PQNgrkPJx4nEvg11h+ZpOi1WJI0EQPMn6soH/D6S9+qj8OCC+6gGUUbtPGQ+zTTzzQavBk3AjKxivtDFiDtDhYJxj/LzMs/7DWswZxBnusSKQeGv3M0RJiQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IvryVm35M7XaaFczN1NEItQqso5NUvMa5/2a5x79jbk=;
 b=IQqFOZcLY0tcl3Qz0zaWW3D62Q7SCpPc0aLdl71ZOu8Ve4flFfeYPHPESN7nzaWNDqpT0Nt5sEA0QZ8QHkFEIjvP08OUYn9rrWyGJFGbvESN1kOknZJVfRwW+qHhemDJfazfbfnu4rKn9/Kh5aioVXLP3TWkpznsih6BhbTGWUT+mPSfVsXlGYT2pZjBcL2TyZxsj2D0tBfKuXI63Vk3rIhzPlxjiQoke32XoN4S5T+xqdxAWbBuC9bFJ6XOx5HjA7iqlR2hzQAZmdhwt9+RrDO2zdoxA660Hzo/tvoghiHDkMQsiSWN0TXb9Kqe6dh1SdHnALNY3zhsUX3ihkaSPQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IvryVm35M7XaaFczN1NEItQqso5NUvMa5/2a5x79jbk=;
 b=RRFy9Os9m4RkfGVMJIy4q2IpPnyc8rXrFYBXlmS4raevaJ1rbjm4JypsfMkRsfqSSDGg4w8BUsVG5EFxoRy4ZlNYLuchOC1Fzn1wHKShOGCL1H8issRRdTkfNE0JL4pRVXLPPe55MxG5AaZsSy4oQJF48aWRBohcU2+8n6fvYnE=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by CH2PR11MB4392.namprd11.prod.outlook.com (2603:10b6:610:3e::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Thu, 30 Jun
 2022 16:20:19 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5373.022; Thu, 30 Jun 2022
 16:20:19 +0000
From:   <Conor.Dooley@microchip.com>
To:     <p.zabel@pengutronix.de>, <mturquette@baylibre.com>,
        <sboyd@kernel.org>, <robh+dt@kernel.org>,
        <krzysztof.kozlowski+dt@linaro.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <palmer@dabbelt.com>, <Nicolas.Ferre@microchip.com>,
        <Claudiu.Beznea@microchip.com>, <Daire.McNamara@microchip.com>
CC:     <paul.walmsley@sifive.com>, <aou@eecs.berkeley.edu>,
        <linux-clk@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>
Subject: Re: [PATCH v1 04/14] reset: add polarfire soc reset support
Thread-Topic: [PATCH v1 04/14] reset: add polarfire soc reset support
Thread-Index: AQHYjFiLUdivMuF33kSysKGuotnsQq1nqk8AgAB3kwA=
Date:   Thu, 30 Jun 2022 16:20:19 +0000
Message-ID: <eed577e2-b416-dfea-a830-2c037e34ac64@microchip.com>
References: <20220630080532.323731-1-conor.dooley@microchip.com>
 <20220630080532.323731-5-conor.dooley@microchip.com>
 <813a3b51f82a11a86bd3af2c3299c344e08e8963.camel@pengutronix.de>
In-Reply-To: <813a3b51f82a11a86bd3af2c3299c344e08e8963.camel@pengutronix.de>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d04aefa-0008-40b6-ac65-08da5ab46cff
x-ms-traffictypediagnostic: CH2PR11MB4392:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zcM7B35t3YKSOBIOkHkRmsgiD+NgVc1VrsvUTDCq+J+mCAroTvEbwjzxOjFijBb7L8uX3GsnciUaQjmqb4FeIOCFIXaztNdfn3V6Gd7ac31jjWiN0ZZ2bpv2eHmv0Tk6nEsLmfI/U5i/xUh0iI67jrrLfql7MhdnjUbaIB4ReqAhgxjqMvKBPJoIQIjHH0+SgJxN7nO0Xwy34Z7Ig5NpcLol/hu+mHYYPop1f2KdXF5bSaL6Dw6xFsGcsN1oGjpYBwxs+0YraQDb1Px+lWEpQ09bFS1BO1AND+gg222ycubARKt3aAdA0LtUCI23luirwbXie7hdhBRelZt/QCNPYOyQpPLqsnBV3QEP60ZRYkRkeNdqnE9BYmev9Kf7/IsbLhqnvY3vy1VhMSV9RTrqfgqAL/HlRTC4dYQV63cQR31lysnnlHEqfXeW2Fj3Jy3VRgYynTjV8vqbfrxkxbuv7wH6XcQg5yBJr7Zwlb2C+WAfqX+U3mGHWZ/2hLTXFPQDrWlIFARRUokBA8duSCx8lHzYrKAzUjp/8RdZ1KJFWPWQsVlm/8icf7jc1WFNrvc4I/fWYXmhP6g7pdGBcew3l83hwpU3LK63k0soIFZcug4mP6ETBVtQ2lCKELkolhptEqnVgetx4mSOUyTZVnHz9gcfLYp4IOCZQadAWl3UXoOwXD4qs35s30la+352S5GDuzQii9pWqC9cJvqCaXqm4uADgOJSvBkscfVW5sn8VgU3KjFzBYj+VgKtc8C69//EIQiCkgud7/EUcakJuRmr+cRh7wp7n+DQyjch/QsL1Vb/iG9KersqeYxj1Q+5LBVxPgFUqLFZBSUvhz57cxB3LfFNkdiLNXzObC2ujQJx6qce5nTnKgYq1V7UUdzo4GlQWr/XgBwtOobINpT2JGe4cg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(366004)(39860400002)(346002)(396003)(136003)(7416002)(2616005)(41300700001)(31696002)(8936002)(5660300002)(2906002)(38070700005)(186003)(6512007)(86362001)(26005)(71200400001)(6486002)(478600001)(53546011)(6506007)(110136005)(38100700002)(4326008)(6636002)(91956017)(8676002)(66476007)(64756008)(66946007)(66556008)(31686004)(76116006)(66446008)(316002)(122000001)(83380400001)(36756003)(921005)(54906003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?czExQWdWSGo4VWlheWdrVDkxR3N2cWFkMVdaaUt5cUwwT05RVmZnMUNOL0Fi?=
 =?utf-8?B?NW9JdWJFay8wZ1BHMGRZWEVpelQvK0VhUnd6dENyemlEc3p5dFlqVVVvaUhI?=
 =?utf-8?B?Y1pFcm12TEVtUCt0L3pObHdraHYxd2VhdWlPcm1xbVZTMm9lWUQ3T2dIL0x3?=
 =?utf-8?B?VEE0bkJPVGdTOWp2dlBNaWRmNmdqZVdwY293dlNaa3lYZ2xYMkovd0FnS3dV?=
 =?utf-8?B?N1ZYekllQ1F1alR2bE1ocCtPZWE0cjdYR25zeGwvUWRXZjVncEJUSUYydEJh?=
 =?utf-8?B?RlNSMkJGRXlISGxlbHIvb3FiSkVmOFR1KzM0WEhVdCt2dFh2RU1FWWxRdFlw?=
 =?utf-8?B?ZzJ4YWVFUlpPRGwxZDF1cG9URm5uTFRFMHBYMXgyMTVmMkhQUFRiZ2lrS3Y3?=
 =?utf-8?B?WEF5ZUxUYmF2UVN3UngzWDZtRWJrTFRWR0JjUUx4L2pZSEpZYVBlOHVRRE9u?=
 =?utf-8?B?c1Bwcm9VRjZLMGVMTzNvdzNQWlZ2M2FjQVZTZkRyaTQvUnBYSmZod0c5dmho?=
 =?utf-8?B?eFQrNklGdDh1ZlRNY3JYUmpwa0N0TUpQajFSVzVJMG9KSUVwL051N0g2ekpL?=
 =?utf-8?B?TS8vdHRwbHFDaDJvYnlsUXc4T1RpcWpHV3U1WFhScEpiOVZWNDZ6S0dJdDVm?=
 =?utf-8?B?NmhUNkwxci9GSFc2c0xqME1YdlhDOCtSUEI1RVBLQXVLc0RJNjlkQlZ6Rk51?=
 =?utf-8?B?NEpEcFdVOVNMMm5aSk1iZlhQKytER0wrSnRYZHpCSi9XUHhyQi9TRmhkdTB1?=
 =?utf-8?B?U21LRVJxU20zVmoxVk5qWGdjSWI1ZVFKV21aM0RoLzJoTnVxaU9Rb3o0YzIw?=
 =?utf-8?B?SXNFV2FMc0ZKclZRajYxMFNVTllZbzlNNHVVNXFTYnNtc2pxYzZNUEVvK1h1?=
 =?utf-8?B?VUg2c1VpMTZFeDNsME8yc2pTODNLSi9EYktKTHdOSGthNWFtLzFWcDcvdE5V?=
 =?utf-8?B?V2x4RlNNQXBXZU1UdFVMOUtkZGk0Q2VvQ2F2bjJRSzU5ODlqU2ZqZjBuQkYr?=
 =?utf-8?B?aDNTY0RXN2JvWTJNYm4xUDd2S3JUV3BkbUhjVEplaTJrQWtCbU80MU5UcE9E?=
 =?utf-8?B?YjhrYWQ3R0p6cXVqVXRGeGxKZGg2bzBpTlJTL3pjbitnYzhiL2s2MTI4US9x?=
 =?utf-8?B?ZXRYakoxcEpQc3M1dGdSRlBQVHlldE54a0R6SU9CclVXR05sdjhzYXdFOUlo?=
 =?utf-8?B?TFF6YXFjR1BvK3VqUWxoTU0wa1VkTXJyQjFYNUF1WndaaE5wbjEyUUk1akh0?=
 =?utf-8?B?SStja2VBQ2JxNHdMKzNoNnRvdW9NTklFM3JQdUFlSTVsRXRYREhpREVYV3Fa?=
 =?utf-8?B?emxhSHJCYWtUbkxiVmNHY0xWMWIzVlNnVUVjVSthVW0wRTVqaTFJR2RORW8x?=
 =?utf-8?B?NXFKaWRwYzZ2MVQyUnBIRk1CbHdyYUFBN0FJRFQyeDBSZVdIMVhkMlIyTStw?=
 =?utf-8?B?VDE1d3NLV01pb2RYaWdwZVowTGtZS1hCb1BHT3grM2dGS0hEZFFEUmMwK05M?=
 =?utf-8?B?VlhzUjhrMXFGSGpaS0lQdDlBQTk1MnZxRlhkKzNhejVicnlKV2lZTXhXM1hu?=
 =?utf-8?B?WllXTmlSSEYrMzBuTmN2LzhoVjhzWG15N2VXZWRJOTRwRnBJSjIzTjcyblda?=
 =?utf-8?B?S1hhUzh0KzI5N25kZDZHQ1JBRDczejllZU5ERE9hVGNCOG56OXdDbGdBZjVM?=
 =?utf-8?B?dmVmNkJ2RXUvaEZMY1VTN3RpbGNXak9aUTFUZGwzZ1doS0VXZk56bmFOenpL?=
 =?utf-8?B?L0VqSnY1RE9xcUZ6djE1dEJyeHN3RVVxbGFVR2gzY0RadDErWk9DYk8zSkVs?=
 =?utf-8?B?NFp5TzBUU1BrYWxnbDZvUlRsRDBVbms3V3FmdUhmWU5KWWJ6SmJkUEI0dUlt?=
 =?utf-8?B?Z0lYRW1WZGd6QktmeTI3NTNLeE5SSWowcjZsVGZWb1Nqc3FIeGZ3VkxVYUR2?=
 =?utf-8?B?MTFPUlZ6RVR4RW5yWmtsakxCTXB3ZDhpMG8wQko2ZUxvREFaYUxNNktvMlhk?=
 =?utf-8?B?V2hWSlU1cThNRzJQWTczYUNkSklsVWpZMC9sb2NvUDlIZG5SbGMzTk1tZWFG?=
 =?utf-8?B?NHdRbkxHRWVpeE0zellOM0dwc1hwQ1prcWZWdmZtcmsweHc0T2l4QlZXeTBs?=
 =?utf-8?B?UDJvckU2TFNpUWhIRFhaYnZUT2VpMFRHLzhWclByaUg5dFAxWUNUQlo2Rmdl?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33FA11B684C06E4CB076FA3678F7EE2E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d04aefa-0008-40b6-ac65-08da5ab46cff
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Jun 2022 16:20:19.5342
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qyQitjiK2nfN+pBvGfk3GG+obsxh/73FO1pi6BlT+PvwuUUli3Z6EnUUq7fxPUuUtuKdmuwVTl1rAdu/1FZoJQajmALSOww8eR+ZORBv/vw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR11MB4392
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMzAvMDYvMjAyMiAxMDoxMiwgUGhpbGlwcCBaYWJlbCB3cm90ZToNCg0KKFRoaXMgY2FtZSB0
byBtZSBvZGRseSBxdW90ZWQsIHNvIEkgaGF2ZSBmaXhlZCBpdCBteXNlbGYpDQoNCj4+IEVYVEVS
TkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3Mg
eW91IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPj4gDQo+PiBIaSBDb25vciwNCj4+IA0KPj4g
T24gRG8sIDIwMjItMDYtMzAgYXQgMDk6MDUgKzAxMDAsIENvbm9yIERvb2xleSB3cm90ZToNCj4+
IEFkZCBzdXBwb3J0IGZvciB0aGUgcmVzZXRzIG9uIE1pY3JvY2hpcCdzIFBvbGFyRmlyZSBTb0Mg
KE1QRlMpLg0KPj4gUmVzZXQgY29udHJvbCBpcyBhIHNpbmdsZSByZWdpc3Rlciwgd2VkZ2VkIGlu
IGJldHdlZW4gcmVnaXN0ZXJzIGZvcg0KPj4gY2xvY2sgY29udHJvbC4gVG8gZml0IHdpdGggZXhp
c3RlZCBEVCBldGMsIHRoZSByZXNldCBjb250cm9sbGVyIGlzDQo+PiANCj4gZXhpc3RpbmcgICAg
ICAgICAgICAgICAgICAgICBeDQo+PiANCj4+IGNyZWF0ZWQgdXNpbmcgdGhlIGF1eCBkZXZpY2Ug
ZnJhbWV3b3JrICYgc2V0IHVwIGluIHRoZSBjbG9jayBkcml2ZXIuDQo+PiANCj4+IFNpZ25lZC1v
ZmYtYnk6IENvbm9yIERvb2xleSA8Y29ub3IuZG9vbGV5QG1pY3JvY2hpcC5jb20+DQo+PiAtLS0N
Cj4+ICBkcml2ZXJzL3Jlc2V0L0tjb25maWcgICAgICB8ICAgOSArKysNCj4+ICBkcml2ZXJzL3Jl
c2V0L01ha2VmaWxlICAgICB8ICAgMiArLQ0KPj4gIGRyaXZlcnMvcmVzZXQvcmVzZXQtbXBmcy5j
IHwgMTQ1ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+ICAzIGZpbGVz
IGNoYW5nZWQsIDE1NSBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+PiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvcmVzZXQvcmVzZXQtbXBmcy5jDQo+PiANCj4+IGRpZmYgLS1naXQg
YS9kcml2ZXJzL3Jlc2V0L0tjb25maWcgYi9kcml2ZXJzL3Jlc2V0L0tjb25maWcNCj4+IGluZGV4
IDkzYzhkMDdlZTMyOC4uZWRmNDg5NTFmNzYzIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy9yZXNl
dC9LY29uZmlnDQo+PiArKysgYi9kcml2ZXJzL3Jlc2V0L0tjb25maWcNCj4+IEBAIC0xMjIsNiAr
MTIyLDE1IEBAIGNvbmZpZyBSRVNFVF9NQ0hQX1NQQVJYNQ0KPj4gICAgICAgICBoZWxwDQo+PiAg
ICAgICAgICAgVGhpcyBkcml2ZXIgc3VwcG9ydHMgc3dpdGNoIGNvcmUgcmVzZXQgZm9yIHRoZSBN
aWNyb2NoaXAgU3Bhcng1IFNvQy4NCj4+IA0KPj4gDQo+PiArY29uZmlnIFJFU0VUX1BPTEFSRklS
RV9TT0MNCj4+ICsgICAgICAgYm9vbCAiTWljcm9jaGlwIFBvbGFyRmlyZSBTb0MgKE1QRlMpIFJl
c2V0IERyaXZlciINCj4+ICsgICAgICAgZGVwZW5kcyBvbiBBVVhJTElBUllfQlVTICYmIE1DSFBf
Q0xLX01QRlMNCj4+ICsgICAgICAgZGVmYXVsdCBNQ0hQX0NMS19NUEZTDQo+PiArICAgICAgIGhl
bHANCj4+ICsgICAgICAgICBUaGlzIGRyaXZlciBzdXBwb3J0cyBwZXJpcGhlcmFsIHJlc2V0IGZv
ciB0aGUgTWljcm9jaGlwIFBvbGFyRmlyZSBTb0MNCj4+ICsNCj4+ICsgICAgICAgICBDT05GSUdf
UkVTRVRfTVBGUw0KPj4gDQo+VGhpcyBkb2Vzbid0IGxvb2sgaW50ZW50aW9uYWwuDQoNCkNvcnJl
Y3QuIEkgZml4ZWQgaXQgd2hlbiByZWJhc2luZyBvbiAtbmV4dCBhbmQgZm9yZ290IHRvIHJlLWZp
eCBpdA0Kd2hlbiBJIGhhZCB0byByZXNldCBiYWNrIHRvIC1yYzIuLi4NCg0KPj4gDQo+PiArDQo+
PiAgY29uZmlnIFJFU0VUX01FU09ODQo+PiAgICAgICAgIHRyaXN0YXRlICJNZXNvbiBSZXNldCBE
cml2ZXIiDQo+PiAgICAgICAgIGRlcGVuZHMgb24gQVJDSF9NRVNPTiB8fCBDT01QSUxFX1RFU1QN
Cj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Jlc2V0L01ha2VmaWxlIGIvZHJpdmVycy9yZXNldC9N
YWtlZmlsZQ0KPj4gaW5kZXggYTgwYTljNDAwOGE3Li41ZmFjM2E3NTM4NTggMTAwNjQ0DQo+PiAt
LS0gYS9kcml2ZXJzL3Jlc2V0L01ha2VmaWxlDQo+PiArKysgYi9kcml2ZXJzL3Jlc2V0L01ha2Vm
aWxlDQo+PiBAQCAtMTcsNiArMTcsNyBAQCBvYmotJChDT05GSUdfUkVTRVRfSzIxMCkgKz0gcmVz
ZXQtazIxMC5vDQo+PiAgb2JqLSQoQ09ORklHX1JFU0VUX0xBTlRJUSkgKz0gcmVzZXQtbGFudGlx
Lm8NCj4+ICBvYmotJChDT05GSUdfUkVTRVRfTFBDMThYWCkgKz0gcmVzZXQtbHBjMTh4eC5vDQo+
PiAgb2JqLSQoQ09ORklHX1JFU0VUX01DSFBfU1BBUlg1KSArPSByZXNldC1taWNyb2NoaXAtc3Bh
cng1Lm8NCj4+ICtvYmotJChDT05GSUdfUkVTRVRfUE9MQVJGSVJFX1NPQykgKz0gcmVzZXQtbXBm
cy5vDQo+PiAgb2JqLSQoQ09ORklHX1JFU0VUX01FU09OKSArPSByZXNldC1tZXNvbi5vDQo+PiAg
b2JqLSQoQ09ORklHX1JFU0VUX01FU09OX0FVRElPX0FSQikgKz0gcmVzZXQtbWVzb24tYXVkaW8t
YXJiLm8NCj4+ICBvYmotJChDT05GSUdfUkVTRVRfTlBDTSkgKz0gcmVzZXQtbnBjbS5vDQo+PiBA
QCAtMzgsNCArMzksMyBAQCBvYmotJChDT05GSUdfUkVTRVRfVU5JUEhJRVIpICs9IHJlc2V0LXVu
aXBoaWVyLm8NCj4+ICBvYmotJChDT05GSUdfUkVTRVRfVU5JUEhJRVJfR0xVRSkgKz0gcmVzZXQt
dW5pcGhpZXItZ2x1ZS5vDQo+PiAgb2JqLSQoQ09ORklHX1JFU0VUX1pZTlEpICs9IHJlc2V0LXp5
bnEubw0KPj4gIG9iai0kKENPTkZJR19BUkNIX1pZTlFNUCkgKz0gcmVzZXQtenlucW1wLm8NCj4+
IC0NCj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL3Jlc2V0L3Jlc2V0LW1wZnMuYyBiL2RyaXZlcnMv
cmVzZXQvcmVzZXQtbXBmcy5jDQo+PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4gaW5kZXggMDAw
MDAwMDAwMDAwLi40OWM0N2EzZTZjNzANCj4+IC0tLSAvZGV2L251bGwNCj4+ICsrKyBiL2RyaXZl
cnMvcmVzZXQvcmVzZXQtbXBmcy5jDQo+PiBAQCAtMCwwICsxLDE0NSBAQA0KPj4gKy8vIFNQRFgt
TGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4+ICsvKg0KPj4gKyAqIFBvbGFyRmly
ZSBTb0MgKE1QRlMpIFBlcmlwaGVyYWwgQ2xvY2sgUmVzZXQgQ29udHJvbGxlcg0KPj4gKyAqDQo+
PiArICogQXV0aG9yOiBDb25vciBEb29sZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPg0K
Pj4gKyAqIENvcHlyaWdodCAoYykgMjAyMiBNaWNyb2NoaXAgVGVjaG5vbG9neSBJbmMuIGFuZCBp
dHMgc3Vic2lkaWFyaWVzLg0KPj4gKyAqDQo+PiArICovDQo+PiArI2luY2x1ZGUgPGxpbnV4L2F1
eGlsaWFyeV9idXMuaD4NCj4+ICsjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4NCj4+ICsjaW5jbHVk
ZSA8bGludXgvbW9kdWxlLmg+DQo+PiArI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5o
Pg0KPj4gKyNpbmNsdWRlIDxsaW51eC9yZXNldC1jb250cm9sbGVyLmg+DQo+PiArI2luY2x1ZGUg
PGR0LWJpbmRpbmdzL2Nsb2NrL21pY3JvY2hpcCxtcGZzLWNsb2NrLmg+DQo+PiArI2luY2x1ZGUg
PHNvYy9taWNyb2NoaXAvbXBmcy5oPg0KPj4gKw0KPj4gKy8qDQo+PiArICogVGhlIEVOVk0gcmVz
ZXQgaXMgdGhlIGxvd2VzdCBiaXQgaW4gdGhlIHJlZ2lzdGVyICYgSSBhbSB1c2luZyB0aGUgQ0xL
X0ZPTw0KPj4gKyAqIGRlZmluZXMgaW4gdGhlIGR0IHRvIG1ha2UgdGhpbmdzIGVhc2llciB0byBj
b25maWd1cmUgLSBzbyB0aGlzIGlzIGFjY291bnRpbmcNCj4+ICsgKiBmb3IgdGhlIG9mZnNldCBv
ZiAzIHRoZXJlLg0KPj4gKyAqLw0KPj4gKyNkZWZpbmUgTVBGU19QRVJJUEhfT0ZGU0VUICAgICBD
TEtfRU5WTQ0KPj4gKyNkZWZpbmUgTVBGU19OVU1fUkVTRVRTICAgICAgICAgICAgICAgIDMwdQ0K
Pj4gKyNkZWZpbmUgTVBGU19TTEVFUF9NSU5fVVMgICAgICAxMDANCj4+ICsjZGVmaW5lIE1QRlNf
U0xFRVBfTUFYX1VTICAgICAgMjAwDQo+PiArDQo+PiArLyoNCj4+ICsgKiBQZXJpcGhlcmFsIGNs
b2NrIHJlc2V0cw0KPj4gKyAqLw0KPj4gKw0KPj4gK3N0YXRpYyBpbnQgbXBmc19hc3NlcnQoc3Ry
dWN0IHJlc2V0X2NvbnRyb2xsZXJfZGV2ICpyY2RldiwgdW5zaWduZWQgbG9uZyBpZCkNCj4+ICt7
DQo+PiArICAgICAgIHUzMiByZWc7DQo+PiArDQo+PiArICAgICAgIHJlZyA9IG1wZnNfcmVzZXRf
cmVhZChyY2Rldi0+ZGV2KTsNCj4+ICsgICAgICAgcmVnIHw9ICgxdSA8PCBpZCk7DQo+PiArICAg
ICAgIG1wZnNfcmVzZXRfd3JpdGUocmNkZXYtPmRldiwgcmVnKTsNCj4gDQo+IFRoaXMgaXMgbWlz
c2luZyBhIHNwaW5sb2NrIHRvIHByb3RlY3QgYWdhaW5zdCBjb25jdXJyZW50IHJlYWQtbW9kaWZ5
LQ0KPiB3cml0ZXMuDQo+PiANCj4+ICsNCj4+ICsgICAgICAgcmV0dXJuIDA7DQo+PiArfQ0KPj4g
Kw0KPj4gK3N0YXRpYyBpbnQgbXBmc19kZWFzc2VydChzdHJ1Y3QgcmVzZXRfY29udHJvbGxlcl9k
ZXYgKnJjZGV2LCB1bnNpZ25lZCBsb25nIGlkKQ0KPj4gK3sNCj4+ICsgICAgICAgdTMyIHJlZywg
dmFsOw0KPj4gKw0KPj4gKyAgICAgICByZWcgPSBtcGZzX3Jlc2V0X3JlYWQocmNkZXYtPmRldik7
DQo+PiArICAgICAgIHZhbCA9IHJlZyAmIH4oMXUgPDwgaWQpOw0KPiANCj4gWW91IGNvdWxkIHVz
ZSBCSVQoaWQpIGluc3RlYWQgb2YgKDF1IDw8IGlkKS4NCj4gDQo+PiArICAgICAgIG1wZnNfcmVz
ZXRfd3JpdGUocmNkZXYtPmRldiwgdmFsKTsNCj4+ICsNCj4+ICsgICAgICAgcmV0dXJuIDA7DQo+
PiArfQ0KPj4gKw0KPj4gK3N0YXRpYyBpbnQgbXBmc19zdGF0dXMoc3RydWN0IHJlc2V0X2NvbnRy
b2xsZXJfZGV2ICpyY2RldiwgdW5zaWduZWQgbG9uZyBpZCkNCj4+ICt7DQo+PiArICAgICAgIHUz
MiByZWcgPSBtcGZzX3Jlc2V0X3JlYWQocmNkZXYtPmRldik7DQo+PiArDQo+PiArICAgICAgIHJl
dHVybiAocmVnICYgKDF1IDw8IGlkKSk7DQo+IA0KPiBTaWRlIG5vdGUsIHRoaXMgd29ya3MgYmVj
YXVzZSBNUEZTX05VTV9SRVNFVFMgbWFrZXMgc3VyZSB0aGUgc2lnbiBiaXQNCj4gaXMgbmV2ZXIg
aGl0Lg0KDQpJIGNhbiBhZGQgYSBjb21tZW50IHRvIHRoYXQgZWZmZWN0IGlmIHlvdSB3YW50Pw0K
DQo+PiANCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGludCBtcGZzX3Jlc2V0KHN0cnVjdCByZXNl
dF9jb250cm9sbGVyX2RldiAqcmNkZXYsIHVuc2lnbmVkIGxvbmcgaWQpDQo+PiArew0KPj4gKyAg
ICAgICBtcGZzX2Fzc2VydChyY2RldiwgaWQpOw0KPj4gKw0KPj4gKyAgICAgICB1c2xlZXBfcmFu
Z2UoTVBGU19TTEVFUF9NSU5fVVMsIE1QRlNfU0xFRVBfTUFYX1VTKTsNCj4+ICsNCj4+ICsgICAg
ICAgbXBmc19kZWFzc2VydChyY2RldiwgaWQpOw0KPj4gKw0KPj4gKyAgICAgICByZXR1cm4gMDsN
Cj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGNvbnN0IHN0cnVjdCByZXNldF9jb250cm9sX29wcyBt
cGZzX3Jlc2V0X29wcyA9IHsNCj4+ICsgICAgICAgLnJlc2V0ID0gbXBmc19yZXNldCwNCj4+ICsg
ICAgICAgLmFzc2VydCA9IG1wZnNfYXNzZXJ0LA0KPj4gKyAgICAgICAuZGVhc3NlcnQgPSBtcGZz
X2RlYXNzZXJ0LA0KPj4gKyAgICAgICAuc3RhdHVzID0gbXBmc19zdGF0dXMsDQo+PiArfTsNCj4+
ICsNCj4+ICtzdGF0aWMgaW50IG1wZnNfcmVzZXRfeGxhdGUoc3RydWN0IHJlc2V0X2NvbnRyb2xs
ZXJfZGV2ICpyY2RldiwNCj4+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25zdCBzdHJ1
Y3Qgb2ZfcGhhbmRsZV9hcmdzICpyZXNldF9zcGVjKQ0KPj4gK3sNCj4+ICsgICAgICAgdW5zaWdu
ZWQgaW50IGluZGV4ID0gcmVzZXRfc3BlYy0+YXJnc1swXTsNCj4+ICsNCj4+ICsgICAgICAgLyoN
Cj4+ICsgICAgICAgICogQ0xLX1JFU0VSVkVEIGRvZXMgbm90IG1hcCB0byBhIGNsb2NrLCBidXQg
aXQgZG9lcyBtYXAgdG8gYSByZXNldCwNCj4+ICsgICAgICAgICogc28gaXQgaGFzIHRvIGJlIGFj
Y291bnRlZCBmb3IgaGVyZS4gSXQgaXMgdGhlIHJlc2V0IGZvciB0aGUgZmFicmljLA0KPj4gKyAg
ICAgICAgKiBzbyBpZiB0aGlzIHJlc2V0IGdldHMgY2FsbGVkIC0gZG8gbm90IHJlc2V0IGl0Lg0K
Pj4gKyAgICAgICAgKi8NCj4+ICsgICAgICAgaWYgKGluZGV4ID09IENMS19SRVNFUlZFRCkgew0K
Pj4gKyAgICAgICAgICAgICAgIGRldl9lcnIocmNkZXYtPmRldiwgIlJlc2V0dGluZyB0aGUgZmFi
cmljIGlzIG5vdCBzdXBwb3J0ZWRcbiIpOw0KPj4gKyAgICAgICAgICAgICAgIHJldHVybiAtRUlO
VkFMOw0KPj4gKyAgICAgICB9DQo+PiArDQo+PiArICAgICAgIGlmIChpbmRleCA8IE1QRlNfUEVS
SVBIX09GRlNFVCB8fCBpbmRleCA+PSAoTVBGU19QRVJJUEhfT0ZGU0VUICsgcmNkZXYtPm5yX3Jl
c2V0cykpIHsNCj4+ICsgICAgICAgICAgICAgICBkZXZfZXJyKHJjZGV2LT5kZXYsICJJbnZhbGlk
IHJlc2V0IGluZGV4ICV1XG4iLCByZXNldF9zcGVjLT5hcmdzWzBdKTsNCj4gDQo+IHMvcmVzZXRf
c3BlYy0+YXJnc1swXS9pbmRleC8NCj4gDQo+PiArICAgICAgICAgICAgICAgcmV0dXJuIC1FSU5W
QUw7DQo+PiArICAgICAgIH0NCj4+ICsNCj4+ICsgICAgICAgcmV0dXJuIGluZGV4IC0gTVBGU19Q
RVJJUEhfT0ZGU0VUOw0KPj4gK30NCj4+ICsNCj4+ICtzdGF0aWMgaW50IG1wZnNfcmVzZXRfcHJv
YmUoc3RydWN0IGF1eGlsaWFyeV9kZXZpY2UgKmFkZXYsDQo+PiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgY29uc3Qgc3RydWN0IGF1eGlsaWFyeV9kZXZpY2VfaWQgKmlkKQ0KPj4gK3sNCj4+
ICsgICAgICAgc3RydWN0IGRldmljZSAqZGV2ID0gJmFkZXYtPmRldjsNCj4+ICsgICAgICAgc3Ry
dWN0IHJlc2V0X2NvbnRyb2xsZXJfZGV2ICpyY2RldjsNCj4+ICsgICAgICAgaW50IHJldDsNCj4+
ICsNCj4+ICsgICAgICAgcmNkZXYgPSBkZXZtX2t6YWxsb2MoZGV2LCBzaXplb2YoKnJjZGV2KSwg
R0ZQX0tFUk5FTCk7DQo+PiArICAgICAgIGlmICghcmNkZXYpDQo+PiArICAgICAgICAgICAgICAg
cmV0dXJuIC1FTk9NRU07DQo+PiArDQo+PiArICAgICAgIHJjZGV2LT5kZXYgPSBkZXY7DQo+PiAr
ICAgICAgIHJjZGV2LT5kZXYtPnBhcmVudCA9IGFkZXYtPmRldi5wYXJlbnQ7DQo+PiANCj4+IHMv
YWRldi0+ZGV2Li9kZXYtPi8NCj4+IA0KPj4gKyAgICAgICByY2Rldi0+b3BzID0gJm1wZnNfcmVz
ZXRfb3BzOw0KPj4gKyAgICAgICByY2Rldi0+b2Zfbm9kZSA9IGFkZXYtPmRldi5wYXJlbnQtPm9m
X25vZGU7DQo+PiANCj4+IHMvYWRldi0+ZGV2Li9kZXYtPi8NCj4+IA0KPj4gKyAgICAgICByY2Rl
di0+b2ZfcmVzZXRfbl9jZWxscyA9IDE7DQo+PiArICAgICAgIHJjZGV2LT5vZl94bGF0ZSA9IG1w
ZnNfcmVzZXRfeGxhdGU7DQo+PiArICAgICAgIHJjZGV2LT5ucl9yZXNldHMgPSBNUEZTX05VTV9S
RVNFVFM7DQo+PiArDQo+PiArICAgICAgIHJldCA9IGRldm1fcmVzZXRfY29udHJvbGxlcl9yZWdp
c3RlcihkZXYsIHJjZGV2KTsNCj4+ICsgICAgICAgaWYgKCFyZXQpDQo+PiArICAgICAgICAgICAg
ICAgZGV2X2luZm8oZGV2LCAiUmVnaXN0ZXJlZCBNUEZTIHJlc2V0IGNvbnRyb2xsZXJcbiIpOw0K
PiANCj4gSXMgdGhpcyByZWFsbHkgdXNlZnVsIGluZm9ybWF0aW9uIGZvciBtb3N0IHVzZXJzPw0K
DQpQcm9iYWJseSBub3QsIGJ1dCBpdCBpcyB1c2VmdWwgZm9yIG15IENJIGhhaGEuDQpJZiB5b3Ug
ZG9uJ3QgbGlrZSBpdCwgSSB3aWxsIHJlbW92ZSBpdC4NCg0KPiANCj4+ICsNCj4+ICsgICAgICAg
cmV0dXJuIHJldDsNCj4+ICt9DQo+PiArDQo+PiArc3RhdGljIGNvbnN0IHN0cnVjdCBhdXhpbGlh
cnlfZGV2aWNlX2lkIG1wZnNfcmVzZXRfaWRzW10gPSB7DQo+PiArICAgICAgIHsNCj4+ICsgICAg
ICAgICAgICAgICAubmFtZSA9ICJjbGtfbXBmcy5yZXNldC1tcGZzIiwNCj4+ICsgICAgICAgfSwN
Cj4+ICsgICAgICAgeyB9DQo+PiArfTsNCj4+ICtNT0RVTEVfREVWSUNFX1RBQkxFKGF1eGlsaWFy
eSwgbXBmc19yZXNldF9pZHMpOw0KPj4gKw0KPj4gK3N0YXRpYyBzdHJ1Y3QgYXV4aWxpYXJ5X2Ry
aXZlciBtcGZzX3Jlc2V0X2RyaXZlciA9IHsNCj4+ICsgICAgICAgLnByb2JlICAgICAgICAgID0g
bXBmc19yZXNldF9wcm9iZSwNCj4+ICsgICAgICAgLmlkX3RhYmxlICAgICAgID0gbXBmc19yZXNl
dF9pZHMsDQo+PiArfTsNCj4+ICsNCj4+ICttb2R1bGVfYXV4aWxpYXJ5X2RyaXZlcihtcGZzX3Jl
c2V0X2RyaXZlcik7DQo+PiArDQo+PiArTU9EVUxFX0RFU0NSSVBUSU9OKCJNaWNyb2NoaXAgUG9s
YXJGaXJlIFNvQyBSZXNldCBEcml2ZXIiKTsNCj4+ICtNT0RVTEVfQVVUSE9SKCJDb25vciBEb29s
ZXkgPGNvbm9yLmRvb2xleUBtaWNyb2NoaXAuY29tPiIpOw0KPj4gK01PRFVMRV9MSUNFTlNFKCJH
UEwiKTsNCj4+ICtNT0RVTEVfSU1QT1JUX05TKE1DSFBfQ0xLX01QRlMpOw0KPj4gDQo+IHJlZ2Fy
ZHMNCj4gUGhpbGlwcA0K
