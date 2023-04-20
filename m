Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB946E8A8C
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 08:39:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbjDTGjR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Apr 2023 02:39:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjDTGjP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Apr 2023 02:39:15 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947DF1710
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 23:39:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681972753; x=1713508753;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=VBiIS/FArw2ZouQijwg9wNCE3mpAPPBR4sTuxlZNik4=;
  b=XEP3+AXUqUTkobtGZx9qze2aa5O4orDCnQSPdm0Nnovgg3uIFeSW7tDR
   x6RNr6wJ4U15ZMCIZiEMsdK7Rsj/XOCQXN/axmTdvLyqFMVCMjtvSnFcu
   CA0PRsVXyYUVL5Rfl92J6BqvSnRILJJIKt9Y+5DYqmHZGWoRJSnUDtp1X
   1kSYhTkO0tVyNr5GmBxK+67mKzRb8SWxvpZuFSeQ0xQqZ3pTZSln/8H3x
   nRrFIwAWORGrqkYB5m77pRFB6nhFFzdhTPOrf37JTuuKUo1ERYhyFcRgH
   eyaFj7wMHClgOJMLmIPy6dVjdDVzt238dWcA9qGbsQv22lDAAGEq9U26B
   w==;
X-IronPort-AV: E=Sophos;i="5.99,211,1677567600"; 
   d="scan'208";a="221756753"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Apr 2023 23:39:12 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 19 Apr 2023 23:39:12 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 19 Apr 2023 23:39:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cDX1KP7FDSM8iBeLzWFH0qSb1jr0c5hddk/T2OQQ8tdqCcbeFNKRw2T5nId1ktxtji3At3ILQHvfghKE2/qxj6Iabgm8ewgsgReKyeLO9QKbEa8KHxgX/bK1CiN3TIrOKJIFkem/xdlqScexzX3TAnAtX3rIY4tonOeRtxRPvG++r4sADLciWwGdU0TRnK5M7X6f8g8O2VfAZJ3Fy9Yl6Tkaicl2WJx7yCMsLu4EiaSn03/HVX6ZR9MuKARX9dRBkZ4ZjgEAnS8MfReal0LYV8NqauwzRwyfW3VOrWpzuldRFD3UH3ayEMN5XxsO3YksyHbT6DEspuQAs3oHVoZQgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VBiIS/FArw2ZouQijwg9wNCE3mpAPPBR4sTuxlZNik4=;
 b=Ye9EeU3GMIvDz7DNaxyh2wQznYQBLNzQCNIiWyQjYYyOyP6K4dvTsBiSeieVek5n3qWao5sxu5/wBkzMD5Irf+eH056II2yCVDxxygRe6WPHd5coiLeSlgHGtneslQcPai2xHhh8e55CtVLQLeijscQff7FyMS1EmjrtgLh+5qtFly/vay43wt3PVV+/MYx5EVQmGzDQQq6YbFJoMF0hVi2NXo9JPW4SO1KLnPp7Fe+VKZRIqKdutjRrOxDaUAPY3YFOnaJiEsq+M+6F7tGSQplvK+gbIuDY8VVbbvCTarKEgnJ63eY2sJQ1SxGnrKk6l7d70xphPI1txdGqoh4jjQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VBiIS/FArw2ZouQijwg9wNCE3mpAPPBR4sTuxlZNik4=;
 b=BUuKCrnzQKYTCeUTCF9PcWWf6aa8y77QNZesj9SrVJi2CQ5a43kfeyOG2KpPSn7Z7Ifb3bhqPWvll1/u1fENzqUDTDnIH3+f0bKrOTeZ9JMh3RM5ZzL9rUhQNAI3k6Hrtti5knV+55UToMcSfx0gikZBQ+WKutGjlAe7P38fMSs=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 PH0PR11MB7636.namprd11.prod.outlook.com (2603:10b6:510:26f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Thu, 20 Apr
 2023 06:39:10 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::1c94:f1ec:9898:11df%5]) with mapi id 15.20.6319.022; Thu, 20 Apr 2023
 06:39:09 +0000
From:   <Parthiban.Veerasooran@microchip.com>
To:     <andrew@lunn.ch>
CC:     <ramon.nordin.rodriguez@ferroamp.se>, <hkallweit1@gmail.com>,
        <linux@armlinux.org.uk>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Jan.Huber@microchip.com>,
        <Horatiu.Vultur@microchip.com>, <Woojung.Huh@microchip.com>
Subject: Re: [PATCH] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Thread-Topic: [PATCH] drivers/net/phy: add driver for Microchip LAN867x
 10BASE-T1S PHY
Thread-Index: AQHZch60FAFhEuZCEEOymhDDWGLMLK8ytcIAgAAIDYCAAPEwgIAAEp0A
Date:   Thu, 20 Apr 2023 06:39:09 +0000
Message-ID: <6b3f73c9-3391-2769-1b22-b19f0d55ddc5@microchip.com>
References: <ZD7YzBhzlEBHrEPC@builder>
 <9e5da8b1-bd47-307c-da75-580df4d575f6@microchip.com>
 <83ee7ed8-87a2-4581-99c2-5efd4011257a@lunn.ch>
 <e8f98365-d542-d3ba-d2b3-0903a3e7cea7@microchip.com>
In-Reply-To: <e8f98365-d542-d3ba-d2b3-0903a3e7cea7@microchip.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|PH0PR11MB7636:EE_
x-ms-office365-filtering-correlation-id: 3be57a3f-d28f-4aee-8ab0-08db4169f23f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jdAkwGpJ78Exb8I3qKyGCZf8+jNzNzFJNpT/TUXMFZiIzQH18DILKpcNxp99yZ0VxMNH307uc9iYXPwxqixfoneCbFzFhyNriE5os8lBPnmK9NZoswDR3GB0WTzMsJRg1phG095yjhIh9ZZb8vlFGkKQk291RIVQcsMLH7fQHY0fascO4q+vHJaxIVfTTjEPC+whHSHzQVN/InCLGJ/gS7eFMimQGQYG+fzvgtujRurU1SZv4lbA955HpkqRaczdYbL0KTmEt3Lrgw2dNopqt1B9vNo6QbAZQi2IRzkdo2nqSfuGz1EDpws9jDIXYztg+glQLoyjEOX7hxGculwIQ3DywnOgUw3mHrcPvmgnnI+M0O48DPGnbSoywXq3YcBTWaOcdiqBdBYALolORe2eQgt3K+AG7Z+/9aptXBOb24wDvHGw87OkLp1YeV7W/71M3XitbwUQ35p8aRiZ7OmuvXZqx7Eo51uRkpSZZMbfZTer29qdjpMKNtilwjsD0S/zC7ubbFBz8bV2WYbx5RVFy9jjjT072QTXpJNgtBjVF9UBvpzg3ta9cUniNy84+vxg27KbQp0wfhunBUqrWHZAmCulqe+FkX4OtEoLqB6m+OEnrhPOr/kaoqJ9wN5Vw4sw5cBw6dDfuuuV90GSo8ZY0RtOYdMjGHqRhEKeqSsK+GOMgnmlv7Pq4+FKaOrBdFQ55HJg6PzVWcYUAPYd+CNJhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(346002)(396003)(136003)(39860400002)(451199021)(31686004)(5660300002)(186003)(2616005)(71200400001)(6506007)(2906002)(53546011)(8936002)(8676002)(26005)(83380400001)(6512007)(36756003)(86362001)(41300700001)(31696002)(38100700002)(107886003)(122000001)(66899021)(966005)(6486002)(66946007)(91956017)(76116006)(6916009)(66446008)(66556008)(64756008)(4326008)(66476007)(316002)(54906003)(38070700005)(478600001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MUY3SjVRdWx3VEJjS0RvL1Yyb3RxVTNMeUhONjYvNXROeWV6SFU2RFF3OGhP?=
 =?utf-8?B?ck9MKzZMd20wM05zSnpWa3RmSUVUZjF0UUMwc0doSWFWN0dxWVNJRWFVb1ho?=
 =?utf-8?B?MnlzQ2I2K05zMjFLUU5qbnN5dXBlOWl1aXR5U0s2UkxBUVlrNjAxWkZucllB?=
 =?utf-8?B?bmY3dXNnRDgyOUc3NGRTaHZIZHhhalZrTDM2L2l3Z2R2RUVkSTlmeWMxZkRG?=
 =?utf-8?B?MitjWWEyMExZVWxFdDB1Wi9BdFlJa2tOTHZDVU9HVlNkV0FCTVJ2YVJ6K0dE?=
 =?utf-8?B?ZDdlUGlWdXliRGUza1ZubUlSMWZPRHIvaVJqYWpjc2hJUlMwbExCNmpzaEhz?=
 =?utf-8?B?ZVVzOTNiRHpacnBTQmpsU043YXdHYmwrakxHaVFOOG1mc1N3ZGlzc2NxWndG?=
 =?utf-8?B?c1RiTytURi92ckNOc2ZzbDdyM0lwWG54QjdaVWIxZnkzekozcmhneEd4VWtG?=
 =?utf-8?B?NnZ6ajk4K29ERVRHQThyeGx0MHZwT25xSys3QktFNTRRaHZBSlRoSS93Y044?=
 =?utf-8?B?dlBVVCtvaFBCdWxsUEJaWnZTQ2V3ekd5WEJFMlhxdnhCUnJDSWFlOEtwU0l3?=
 =?utf-8?B?UHFKR2VyYVQxTHRrckFXck0zMWFTOVNhMnlmMkNlbXpCeWZBWnZXdElxYjVu?=
 =?utf-8?B?UXRVL3dnemRzWFdleWZQaTB2QWl5VFJyT1Qzb3BjK040ODlJdXlUM0dpTWYw?=
 =?utf-8?B?aU9QWU9DRHI0L1M3SFlFNWtlUVFYL3lOVWRqTDZOdkJ6bDdMc1ZyZlp4SlNJ?=
 =?utf-8?B?a2hSRm1CSDZwdXBzc3BLV3paWE1CWnNEbWlCNDRhb1F2NkF6Lzc5QXVsK1lH?=
 =?utf-8?B?NkVsRjh2MEtQVVZXTXcyejRWaFdXNXRPa04rc0VqZ1VMTVZjb2Y1Q21YVmJi?=
 =?utf-8?B?TFVvelFmemk3VFNwcGZtZUh0L0tGcXYxdC8yZk5Cbmcyai9DRm5oeENOZ0Vi?=
 =?utf-8?B?MHRtd2FCazV6aVdFVGhBVE9odVExUG1mWTZNem1VZDcvMGkwS2kwS0g5SkRZ?=
 =?utf-8?B?QVRpQmNjWlBWR1grbSt0MUxJK052OW9tNklBeWVkL1U5bmVWcUlQRTdrbith?=
 =?utf-8?B?OWpwZnkwNEw4OElGT0NiOWszSlpXZ2hHU204Vk4vemp5aUl6TmlrcEtOekhz?=
 =?utf-8?B?MFNTTUp2c0JQTVp5MkYrdjkycHNLdzlERjNhWUJaaWZVMXdRUkFYc0JjWGdw?=
 =?utf-8?B?SWRXdExhdHgvYTFwL051WU93cWZIWGFBUXNTL1BuWFBFeVk1b0ZyczkvRUFp?=
 =?utf-8?B?K2RWTEY5Q240Yi9VajFwUDRjRW5BdHZwN09LTW0rOXYyQkpXeW54N0NoVFpt?=
 =?utf-8?B?VGNKWXBqRDA0eUU1STlEZU5tZnVaY3lxZzh6RzFCZ0tETE5FVWtYSTBnZzJI?=
 =?utf-8?B?WXRjNHRGbk56WlQxanpFOEFxdStZeGp4K3hSejFzZWUzKy9xaUpIMDRtVXpE?=
 =?utf-8?B?ZzIxZ1EwN0pNNE56Zm11cnVMd3FWL0xVSGtzS3dpTnl3akhzUkJUbXo2QzJ6?=
 =?utf-8?B?cSsyTlJJaFhKc3FLNkI2MHZkREE3ajNyWnJvSERHbUh1RnJ6enY5N2txZmRo?=
 =?utf-8?B?SEZDeVlBdDNYbnZ3OGNWdlozQ2ZLQVFEQW9KSVllNGozMDB5WTYwWUEvMW9D?=
 =?utf-8?B?N1ZSTG1xUUxrLzRXRndQVWdacWxFa1FUZitsZTNSZEI5RlhSakVMREU4ZkNu?=
 =?utf-8?B?VjNGZjlmOEdTdzBML3cvVm9TTjhFcXU3eEtuZllBSEVuemlrc042azdKdC9D?=
 =?utf-8?B?d1VyYU50WVp0QXNKZm1VK28rbFE2NGhVVC9NbjVndVVKekFSYVpna1VBczZF?=
 =?utf-8?B?ckk5WU15RXJLWm00UXBJWlFvRExVMEdNYUJncTlENWszVGFncjZlNGl2b0tZ?=
 =?utf-8?B?RVV2dWwyZFFMeXpIcU5kUmJtN2NUZmlEbUhURHM1d3FYZzI0NXpwUWhQeDZD?=
 =?utf-8?B?NmNWK1E2OXphL3hSWWZUZFpwU0dmZGdqd3g2Vm9TYnEvWVVDQ3gzZWlyby9h?=
 =?utf-8?B?YWxWVWZOQ3NzZHhXbFhDVHExWDdUTm11cnd4MG1KMVMzUHhwd1B0Y1c2eWJU?=
 =?utf-8?B?NWVpZi9TTU9OcStOMkdpSDB2bEdDVHJHV0ZhbnhTNWk0dTZ0cjlYMmJ2aEpl?=
 =?utf-8?B?aEllNlB6b1p5cDFZeTI3bHQ5Q094c1Y5dDBuTTh3QjVJZDBjYlprQmh0RUZz?=
 =?utf-8?B?bXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <964C32D11B424E4FA970800FD013616F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3be57a3f-d28f-4aee-8ab0-08db4169f23f
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Apr 2023 06:39:09.4457
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QcBqdLXBR/rsg0FA1a82v4z9+lmbb+8G/ojn2yJD340qCytc1sVHAryTyZXG9I0rnJyIX4wuEURVll78Ssy79xh+QPA0k8KR8t3CrqN4Zvvthf59tHF/p3cIsO9YLhp8
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB7636
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjAvMDQvMjMgMTE6MDMgYW0sIFBhcnRoaWJhbiBWZWVyYXNvb3JhbiB3cm90ZToNCj4gT24g
MTkvMDQvMjMgODo0MCBwbSwgQW5kcmV3IEx1bm4gd3JvdGU6DQo+PiBFWFRFUk5BTCBFTUFJTDog
RG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdSBrbm93IA0K
Pj4gdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPj4NCj4+IE9uIFdlZCwgQXByIDE5LCAyMDIzIGF0IDAy
OjQwOjI5UE0gKzAwMDAsIA0KPj4gUGFydGhpYmFuLlZlZXJhc29vcmFuQG1pY3JvY2hpcC5jb20g
d3JvdGU6DQo+Pj4gSGkgUmFtb24sDQo+Pj4NCj4+PiBHb29kIGRheS4uLiEgVGhpcyBpcyBQYXJ0
aGliYW4gZnJvbSBNaWNyb2NoaXAuDQo+Pj4NCj4+PiBUaGFua3MgZm9yIHlvdXIgcGF0Y2hlcyBm
b3IgdGhlIE1pY3JvY2hpcCBMQU44Njd4IDEwQkFTRS1UMVMgUEhZLiBXZQ0KPj4+IHJlYWxseSBh
cHByZWNpYXRlIHlvdXIgZWZmb3J0IG9uIHRoaXMuDQo+Pj4NCj4+PiBGb3IgeW91ciBraW5kIGlu
Zm9ybWF0aW9uLCB3ZSBhcmUgYWxyZWFkeSB3b3JraW5nIGZvciB0aGUgZHJpdmVyIHdoaWNoDQo+
Pj4gc3VwcG9ydHMgYWxsIHRoZSAxMEJBU0UtVDFTIFBIWXMgZnJvbSBNaWNyb2NoaXAgYW5kIGRv
aW5nIGludGVybmFsDQo+Pj4gcmV2aWV3IG9mIHRob3NlIGRyaXZlciBwYXRjaGVzIHRvIG1haW5s
aW5lLiBUaGVzZSBwYXRjaGVzIGFyZSBnb2luZyB0bw0KPj4+IHJlYWNoIG1haW5saW5lIGluIGNv
dXBsZSBvZiBkYXlzLiBJdCBpcyB2ZXJ5IHVuZm9ydHVuYXRlIHRoYXQgd2UgdHdvIGFyZQ0KPj4+
IHdvcmtpbmcgb24gdGhlIHNhbWUgdGFzayBhdCB0aGUgc2FtZSB0aW1lIHdpdGhvdXQga25vd2lu
ZyBlYWNoIG90aGVyLg0KPj4+DQo+Pj4gVGhlIGFyY2hpdGVjdHVyZSBvZiB5b3VyIHBhdGNoIGlz
IHNpbWlsYXIgdG8gb3VyIGN1cnJlbnQgaW1wbGVtZW50YXRpb24uDQo+Pj4gSG93ZXZlciB0byBi
ZSBhYmxlIHRvIHN1cHBvcnQgYWxzbyB0aGUgdXBjb21pbmcgMTBCQVNFLVQxUyBwcm9kdWN0cw0K
Pj4+IGUuZy4sIHRoZSBMQU44NjV4IDEwQkFTRS1UMVMgTUFDLVBIWSwgYWRkaXRpb25hbCBmdW5j
dGlvbmFsaXRpZXMgaGF2ZSB0bw0KPj4+IGJlIGltcGxlbWVudGVkLiBJbiBvcmRlciB0byBhdm9p
ZCB1bm5lY2Vzc2FyeS9yZWR1bmRhbnQgd29yayBvbiBib3RoDQo+Pj4gc2lkZXMsIHdlIHdvdWxk
IGxpa2UgdG8gY29sbGFib3JhdGUgd2l0aCB5b3Ugb24gdGhpcyB0b3BpYyBhbmQgaGF2ZSBhDQo+
Pj4gc3luYyBvdXRzaWRlIG9mIHRoaXMgbWFpbGluZyBsaXN0IGJlZm9yZSBnb2luZyBmb3J3YXJk
Lg0KPj4NCj4+IEhpIFBhcnRoaWJhbg0KPj4NCj4+IFBsZWFzZSByZXZpZXcgdmVyc2lvbiAyIG9m
IHRoZSBwYXRjaCB3aGljaCB3YXMgcG9zdGVkIHRvZGF5LsKgIElzIHRoZXJlDQo+PiBhbnl0aGlu
ZyBpbiB0aGF0IHBhdGNoIHdoaWNoIGlzIGFjdHVhbGx5IHdyb25nPw0KPj4NCj4+IEkgZG9uJ3Qg
bGlrZSB0aGUgaWRlYSBvZiBkcm9wcGluZyBhIHBhdGNoLCBiZWNhdXNlIGEgdmVuZG9yIGNvbWVz
IG91dA0KPj4gb2YsIG1heWJlIHVuaW50ZW50aW9uYWwsIHN0ZWFsdGggbW9kZSwgYW5kIGFza3Mg
Zm9yIHRoZWlyIHZlcnNpb24gdG8NCj4+IGJlIHVzZWQsIG5vdCBzb21lYm9keSBlbHNlJ3MuIEZv
ciBtZSB0aGlzIGlzIGVzcGVjaWFsbHkgaW1wb3J0YW50IGZvcg0KPj4gYSBuZXcgY29udHJpYnV0
b3IuDQo+Pg0KPj4gTXkgcHJlZmVycmVkIHdheSBmb3J3YXJkIGlzIHRvIG1lcmdlIFJhbW9uJ3Mg
Y29kZSwgYW5kIHRoZW4geW91IGNhbg0KPj4gYnVpbGQgb24gaXQgd2l0aCBhZGRpdGlvbmFsIGZl
YXR1cmVzIHRvIHN1cHBvcnQgb3RoZXIgZmFtaWx5DQo+PiBtZW1iZXJzLg0KPj4NCj4+IFBsZWFz
ZSBkb24ndCBnZXQgbWUgd3JvbmcsIGkgZmluZCBpdCBncmVhdCB5b3UgYXJlIHN1cHBvcnRpbmcg
eW91ciBvd24NCj4+IGRldmljZXMuIE5vdCBtYW55IHZlbmRvcnMgZG8uIEJ1dCBMaW51eCBpcyBh
IGNvbW11bml0eSwgd2UgaGF2ZSB0bw0KPj4gcmVzcGVjdCBlYWNoIG90aGVycyB3b3JrLCBvdGhl
ciBtZW1iZXJzIG9mIHRoZSBjb21tdW5pdHkuDQo+Pg0KPj4gwqDCoMKgwqDCoMKgwqDCoCBBbmRy
ZXcNCj4+DQo+PiBGWUk6IERvIHlvdSBoYXZlIGFueSBvdGhlciBkcml2ZXJzIGluIHRoZSBwaXBl
bGluZSB5b3Ugd2FudCB0bw0KPj4gYW5ub3VuY2UsIGp1c3QgdG8gYXZvaWQgdGhpcyBoYXBwZW5p
bmcgYWdhaW4uDQo+IA0KPiBIaSBBbmRyZXcsDQo+IA0KPiBUaGFua3MgYSBsb3QgZm9yIHlvdXIg
cmVwbHkgYW5kIGNsYXJpZmljYXRpb24uDQo+IA0KPiBTdXJlIEkgd2lsbCBhbHNvIHBhcnRpY2lw
YXRlIGluIHJldmlld2luZyB0aGUgcGF0Y2hlcyBpbmNsdWRpbmcgdjIuDQo+IA0KPiBJIGZ1bGx5
IGFncmVlIHdpdGggeW91IGFuZCBhbHNvIEkgcmVhbGx5IGFwcHJlY2lhdGUgUmFtb24ncyBlZmZv
cnQgb24gDQo+IHRoaXMgd2hpY2ggc2hvd3MgaG93IG11Y2ggaW50ZXJlc3QgaGUgaGFzIG9uIG91
ciBwcm9kdWN0IGFuZCBkcml2ZXIgDQo+IGRldmVsb3BtZW50Lg0KPiANCj4gIMKgwqDCoMKgMS4g
QWRkIHN1cHBvcnQgZm9yIExBTjg2NTAvMSAxMEJBU0UtVDFTIE1BQy1QSFkncyBQSFkgaW4gdGhl
IA0KPiBtaWNyb2NoaXBfdDFzLmMgZHJpdmVyIHdoaWNoIGlzIGJlaW5nIG1haW5saW5lZCBieSBS
YW1vbi4NCj4gIMKgwqDCoMKgMi4gQWRkIGdlbmVyaWMgZHJpdmVyIHN1cHBvcnQgZm9yIHRoZSBP
UEVOIEFsbGlhbmNlIDEwQkFTRS1UMXggDQo+IE1BQy1QSFkgU2VyaWFsIEludGVyZmFjZS4NCj4g
IMKgwqDCoMKgMy4gQWRkIGRyaXZlciBzdXBwb3J0IGZvciBMQU44NjUwLzEgMTBCQVNFLVQxUyBN
QUMtUEhZLg0KPiANCj4gTm90ZTogMm5kIGFuZCAzcmQgd2lsbCBiZSBpbiBhIHNpbmdsZSBwYXRj
aCBzZXJpZXMuDQo+IA0KPiBBYm92ZSBwcm9kdWN0IGxpbms6IGh0dHBzOi8vd3d3Lm1pY3JvY2hp
cC5jb20vZW4tdXMvcHJvZHVjdC9sYW44NjUwDQo+IA0KPiBBcyBJIGNvbW11bmljYXRlZCBiZWZv
cmUgaW4gdGhlIGJlbG93IGVtYWlsLCB3ZSBoYXZlIHRoZSBhYm92ZSBkcml2ZXJzIA0KPiBpbiB0
aGUgcGlwZWxpbmUgdG8gbWFpbmxpbmUuDQpIaSBBbmRyZXcsDQoNClNvcnJ5LCBmb3Jnb3QgdG8g
YWRkIG9uZSBtb3JlIHRhc2sgaW4gdGhlIGFib3ZlIHBpcGVsaW5lLiBQbGVhc2UgZmluZCANCnRo
ZSB1cGRhdGVkIGxpc3QgYmVsb3csDQoNCgkxLiBBZGQgc3VwcG9ydCBmb3IgTWljcm9jaGlwIExB
Tjg2NTAvMSBSZXYuQjAgMTBCQVNFLVQxUyBNQUMtUEhZJ3MgUEhZIA0KaW4gdGhlIG1pY3JvY2hp
cF90MXMuYyBkcml2ZXIgd2hpY2ggaXMgYmVpbmcgbWFpbmxpbmVkIGJ5IFJhbW9uICh3aGljaCAN
CndpbGwgYmUgdXNlZCBieSB0aGUgYmVsb3cgTEFOODY1MC8xIFJldi5CMCAxMEJBU0UtVDFTIE1B
Qy1QSFkgZHJpdmVyKS4NCgkyLiBBZGQgc3VwcG9ydCBmb3IgTWljcm9jaGlwIExBTjg2NzAvMS8y
IFJldi5DMSAxMEJBU0UtVDFTIFBIWSBpbiB0aGUgDQptaWNyb2NoaXBfdDFzLmMgZHJpdmVyIHdo
aWNoIGlzIGJlaW5nIG1haW5saW5lZCBieSBSYW1vbi4NCgkzLiBBZGQgZ2VuZXJpYyBkcml2ZXIg
c3VwcG9ydCBmb3IgdGhlIE9QRU4gQWxsaWFuY2UgMTBCQVNFLVQxeCBNQUMtUEhZIA0KU2VyaWFs
IEludGVyZmFjZSAod2hpY2ggd2lsbCBiZSB1c2VkIGJ5IHRoZSBiZWxvdyBMQU44NjUwLzEgMTBC
QVNFLVQxUyANCk1BQy1QSFkgZHJpdmVyKS4NCgk0LiBBZGQgZHJpdmVyIHN1cHBvcnQgZm9yIExB
Tjg2NTAvMSBSZXYuQjAgMTBCQVNFLVQxUyBNQUMtUEhZLg0KDQpXZSBhcmUgYWxyZWFkeSB3b3Jr
aW5nIG9uIHRoZSBhYm92ZSBkcml2ZXJzIGFuZCBnb2luZyBmb3IgaW50ZXJuYWwgDQpyZXZpZXcg
dG8gZ2V0IHRoZSBkcml2ZXJzIG1haW5saW5lZCBpbiB0aGUgdXBzdHJlYW0uDQoNCkJlc3QgUmVn
YXJkcywNClBhcnRoaWJhbiBWDQo+IA0KPiBIaSBBbmRyZXcsDQo+IA0KPiBUaGFua3MgYSBsb3Qg
Zm9yIHlvdXIgc3VwcG9ydC4gSSB3aWxsIGNoZWNrIHdpdGggb3VyIGNvbGxlYWd1ZXMNCj4gc3Vn
Z2VzdGVkIGJ5IHlvdSBhbmQgZ2V0IGJhY2sgdG8gbWFpbmxpbmUgYWdhaW4uDQo+IA0KPiBCZXN0
IFJlZ2FyZHMsDQo+IFBhcnRoaWJhbiBWDQo+IE9uIDExLzAzLzIzIDExOjE1IHBtLCBBbmRyZXcg
THVubiB3cm90ZToNCj4gID4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UgDQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0K
PiAgPg0KPiAgPiBIaSBBbGxhbg0KPiAgPg0KPiAgPiBJdCBoYXMgYmVlbiBhIGxvbmcgdGltZSBz
aW5jZSB3ZSB0YWxrZWQsIG1heWJlIDIwMTkgYXQgdGhlIExpbnV4DQo+ICA+IFBsdW1iZXJzIGNv
bmZlcmVuY2UuLi4uIEFuZCB0aGVuIFBUUCBkaXNjdXNzaW9ucyBldGMuDQo+ICA+DQo+ICA+IEl0
IHNlZW1zIGxpa2UgU3Bhcng1IGlzIGdvaW5nIHdlbGwsIGFsb25nIHdpdGggZmVsaXgsIHNldmls
bGUsIGV0Yy4NCj4gID4NCj4gID4gT24gRnJpLCBNYXIgMTAsIDIwMjMgYXQgMTE6MTM6MjNBTSAr
MDAwMCwgDQo+IFBhcnRoaWJhbi5WZWVyYXNvb3JhbkBtaWNyb2NoaXAuY29tIHdyb3RlOg0KPiAg
Pj4gSGkgQWxsLA0KPiAgPj4NCj4gID4+IEkgd291bGQgbGlrZSB0byBhZGQgTWljcm9jaGlwJ3Mg
TEFOODY1eCAxMEJBU0UtVDFTIE1BQy1QSFkgZHJpdmVyDQo+ICA+PiBzdXBwb3J0IHRvIExpbnV4
IGtlcm5lbC4NCj4gID4+IChQcm9kdWN0IGxpbms6IGh0dHBzOi8vd3d3Lm1pY3JvY2hpcC5jb20v
ZW4tdXMvcHJvZHVjdC9MQU44NjUwKQ0KPiAgPj4NCj4gID4+IFRoZSBMQU44NjUwIGNvbWJpbmVz
IGEgTWVkaWEgQWNjZXNzIENvbnRyb2xsZXIgKE1BQykgYW5kIGFuIEV0aGVybmV0IA0KPiBQSFkN
Cj4gID4+IHRvIGFjY2VzcyAxMEJBU0XigJFUMVMgbmV0d29ya3MuIFRoZSBjb21tb24gc3RhbmRh
cmQgU2VyaWFsIFBlcmlwaGVyYWwNCj4gID4+IEludGVyZmFjZSAoU1BJKSBpcyB1c2VkIHNvIHRo
YXQgdGhlIHRyYW5zZmVyIG9mIEV0aGVybmV0IHBhY2tldHMgYW5kDQo+ICA+PiBMQU44NjUwIGNv
bnRyb2wvc3RhdHVzIGNvbW1hbmRzIGFyZSBwZXJmb3JtZWQgb3ZlciBhIHNpbmdsZSwgc2VyaWFs
DQo+ICA+PiBpbnRlcmZhY2UuDQo+ICA+Pg0KPiAgPj4gRXRoZXJuZXQgcGFja2V0cyBhcmUgc2Vn
bWVudGVkIGFuZCB0cmFuc2ZlcnJlZCBvdmVyIHRoZSBzZXJpYWwgDQo+IGludGVyZmFjZQ0KPiAg
Pj4gYWNjb3JkaW5nIHRvIHRoZSBPUEVOIEFsbGlhbmNlIDEwQkFTReKAkVQxeCBNQUPigJFQSFkg
U2VyaWFsIEludGVyZmFjZQ0KPiAgPj4gc3BlY2lmaWNhdGlvbiBkZXNpZ25lZCBieSBUQzYuDQo+
ICA+PiAobGluazogaHR0cHM6Ly93d3cub3BlbnNpZy5vcmcvQXV0b21vdGl2ZS1FdGhlcm5ldC1T
cGVjaWZpY2F0aW9ucy8pDQo+ICA+PiBUaGUgc2VyaWFsIGludGVyZmFjZSBwcm90b2NvbCBjYW4g
c2ltdWx0YW5lb3VzbHkgdHJhbnNmZXIgYm90aCB0cmFuc21pdA0KPiAgPj4gYW5kIHJlY2VpdmUg
cGFja2V0cyBiZXR3ZWVuIHRoZSBob3N0IGFuZCB0aGUgTEFOODY1MC4NCj4gID4+DQo+ICA+PiBC
YXNpY2FsbHkgdGhlIGRyaXZlciBjb21wcmlzZXMgb2YgdHdvIHBhcnRzLiBPbmUgcGFydCBpcyB0
byBpbnRlcmZhY2UNCj4gID4+IHdpdGggbmV0d29ya2luZyBzdWJzeXN0ZW0gYW5kIFNQSSBzdWJz
eXN0ZW0uIFRoZSBvdGhlciBwYXJ0IGlzIGEgVEM2DQo+ICA+PiBzdGF0ZSBtYWNoaW5lIHdoaWNo
IGltcGxlbWVudHMgdGhlIEV0aGVybmV0IHBhY2tldHMgc2VnbWVudGF0aW9uDQo+ICA+PiBhY2Nv
cmRpbmcgdG8gT1BFTiBBbGxpYW5jZSAxMEJBU0XigJFUMXggTUFD4oCRUEhZIFNlcmlhbCBJbnRl
cmZhY2UNCj4gID4+IHNwZWNpZmljYXRpb24uDQo+ICA+Pg0KPiAgPj4gVGhlIGlkZWEgYmVoaW5k
IHRoZSBUQzYgc3RhdGUgbWFjaGluZSBpbXBsZW1lbnRhdGlvbiBpcyB0byBtYWtlIGl0IGFzIGEN
Cj4gID4+IGdlbmVyaWMgbGlicmFyeSBhbmQgcGxhdGZvcm0gaW5kZXBlbmRlbnQuIEEgc2V0IG9m
IEFQSSdzIHByb3ZpZGVkIGJ5DQo+ICA+PiB0aGlzIFRDNiBzdGF0ZSBtYWNoaW5lIGxpYnJhcnkg
Y2FuIGJlIHVzZWQgYnkgdGhlIDEwQkFTRS1UMXggTUFDLVBIWQ0KPiAgPj4gZHJpdmVycyB0byBz
ZWdtZW50IHRoZSBFdGhlcm5ldCBwYWNrZXRzIGFjY29yZGluZyB0byB0aGUgT1BFTiBBbGxpYW5j
ZQ0KPiAgPj4gMTBCQVNF4oCRVDF4IE1BQ+KAkVBIWSBTZXJpYWwgSW50ZXJmYWNlIHNwZWNpZmlj
YXRpb24uDQo+ICA+Pg0KPiAgPj4gV2l0aCB0aGUgYWJvdmUgaW5mb3JtYXRpb24sIGtpbmRseSBw
cm92aWRlIHlvdXIgdmFsdWFibGUgZmVlZGJhY2sgb24gbXkNCj4gID4+IGJlbG93IHF1ZXJpZXMu
DQo+ICA+Pg0KPiAgPj4gQ2FuIHdlIGtlZXAgdGhpcyBUQzYgc3RhdGUgbWFjaGluZSB3aXRoaW4g
dGhlIExBTjg2NXggZHJpdmVyIG9yIGFzIGENCj4gID4+IHNlcGFyYXRlIGdlbmVyaWMgbGlicmFy
eSBhY2Nlc3NpYmxlIGZvciBvdGhlciAxMEJBU0UtVDF4IE1BQy1QSFkgDQo+IGRyaXZlcnMNCj4g
ID4+IGFzIHdlbGw/DQo+ICA+Pg0KPiAgPj4gSWYgeW91IHJlY29tbWVuZCB0byBoYXZlIHRoYXQg
YXMgYSBzZXBhcmF0ZSBnZW5lcmljIGxpYnJhcnkgdGhlbiBjb3VsZA0KPiAgPj4geW91IHBsZWFz
ZSBhZHZpY2Ugb24gd2hhdCBpcyB0aGUgYmVzdCB3YXkgdG8gZG8gdGhhdCBpbiBrZXJuZWw/DQo+
ICA+DQo+ICA+IE1pY3JvY2hpcCBpcyBnZXR0aW5nIG1vcmUgYW5kIG1vcmUgaW52b2x2ZWQgaW4g
bWFpbmxpbmUuIEpha3ViDQo+ICA+IHB1Ymxpc2hlcyBzb21lIGRldmVsb3BlcnMgc3RhdGlzdGlj
cyBmb3IgbmV0ZGV2Og0KPiAgPg0KPiAgPiBodHRwczovL2x3bi5uZXQvQXJ0aWNsZXMvOTE4MDA3
Lw0KPiAgPg0KPiAgPiBJdCBzaG93cyBNaWNyb2NoaXAgYXJlIG5lYXIgdGhlIHRvcCBmb3IgY29k
ZSBjb250cmlidXRpb25zLiBXaGljaCBpcw0KPiAgPiBncmVhdC4gSG93ZXZlciwgYXMgYSByZXZp
ZXdlciwgaSBzZWUgdGhlIHF1YWxpdHkgcmVhbGx5IHZhcmllcy4gR2l2ZW4NCj4gID4gaG93IGFj
dGl2ZSBNaWNyb2NoaXAgaXMgd2l0aGluIExpbnV4LCB0aGUgbmV0ZGV2IGNvbW11bml0eSwgYW5k
IHRvDQo+ICA+IHNvbWUgZXh0ZW50IExpbnV4IGFzIGEgd2hvbGUsIGV4cGVjdHMgYSBjb21wYW55
IGxpa2UgTWljcm9jaGlwIHRvDQo+ICA+IGJ1aWxkIHVwIGl0cyBpbnRlcm5hbCByZXNvdXJjZXMg
dG8gb2ZmZXIgdHJhaW5pbmcgYW5kIE1lbnRvcmluZyB0bw0KPiAgPiBtYWlubGluZSBkZXZlbG9w
ZXJzLCByYXRoZXIgdGhhbiBleHBlY3QgdGhlIGNvbW11bml0eSB0byBkbyB0aGF0DQo+ICA+IHdv
cmsuIERvZXMgc3VjaCBhIHRoaW5nIGV4aXN0IHdpdGhpbiBNaWNyb2NoaXA/IENvdWxkIHlvdSBw
b2ludA0KPiAgPiBQYXJ0aGliYW4gdG93YXJkcyBhIG1lbnRvciB3aG8gY2FuIGhlbHAgZ3VpZGUg
dGhlIHdvcmsgYWRkaW5nIGdlbmVyaWMNCj4gID4gc3VwcG9ydCBmb3IgdGhlIE9QRU4gQWxsaWFu
Y2UgMTBCQVNFLVQxeCBNQUMtUEhZIFNlcmlhbCBJbnRlcmZhY2UgYW5kDQo+ICA+IHRoZSBMQU44
NjUwLzEgc3BlY2lmaWMgYml0cz8gSWYgbm90LCBjb3VsZCBTdGVlbiBIZWdlbHVuZCBvciBIb3Jh
dGl1DQo+ICA+IFZ1bHR1ciBtYWtlIHNvbWUgdGltZSBhdmFpbGFibGUgdG8gYmUgYSBtZW50b3I/
DQo+ICA+DQo+ICA+IFRoYW5rcw0KPiAgPsKgwqDCoMKgwqDCoMKgwqDCoCBBbmRyZXcNCj4gDQoN
Cg==
