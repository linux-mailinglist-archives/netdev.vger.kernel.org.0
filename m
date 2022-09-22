Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFA95E64D5
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 16:13:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231709AbiIVOMx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 10:12:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiIVOM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 10:12:29 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67BEDF3F97
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 07:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663855938; x=1695391938;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DNWcUxJPGfZZTcnx42jyiO9lHvv04sC77ZVyfmUypBo=;
  b=N3ldbRp8p9bYJjH/oSZ6pkyIsAYnLt0sI0j8ZOp1V9pO//BkxYasiv8e
   9g99PC+ZFExvQ0AtcFyQ6GiOWcGdSAZlCJp2TATsTKTsJWw2DNaGOGDPQ
   U50ldTR8GkTsNf4FSSRRIyD8I+8uSTne8pTOHv7N93UcU9ydumhGzPlXl
   hzxQA2FCJYXI8ppb1QxVc4jYCAWbnqk/YeYfwUJwaqh6IPCXotqaOOPog
   sian5a4xcM3M+kSCcS1HAyC8V03tcIEt0E09dCahf5uMXYZVIWcxkGkRw
   ltwK+VCxbm4Q/Baf1qxBnSvLov07zKnN5JOcceyjG5UUcwWBWB7TDKy9m
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,335,1654585200"; 
   d="scan'208";a="192039949"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Sep 2022 07:12:17 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 22 Sep 2022 07:12:17 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 22 Sep 2022 07:12:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NmII2QkjivH/UAIC0l7+mdOxWi1T8cGCHfM51ZXBwAqUO3i8q6w1FfDwTyAJ2VPrdNHlK2BhSoEst/t3mYogO3hNLr8nPVEfp/0OfSNrkSW71ZLLkcXdpEjdzPIXhVGJSVBICj579WGOsypOu/UI0oS/XCIrzywMAk0yzdRYi9b33BrJExPvF4vcsN3g+60srC4IaedJH3OLktgo3NZShaPaAB5Lc9kWjmjo7L1A69hdr/P0O8i30jzHFO/CWTX4yteXJIJmc6QESWoO18xP8GI2wrz4vro8gWJqVkojoJrNkL9TRau6aMmBzBt5cldqHutT+5W2hN3Fo1SqX6reTA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DNWcUxJPGfZZTcnx42jyiO9lHvv04sC77ZVyfmUypBo=;
 b=dHX3J0DmahlQ2W8uXunkZkqWKPRyj0cy4ChsTdqnB0hVjvpZRQHY+onj3BCpLVeyiJ6Fzyufq2K8Uuz1hl9Y2z1tG727FOl9ZbKm9hptN6wYKmNHi2gVCyJFP2fYvlHa9KQ5zAXYTY+Iaq4pkdOpoEv01E2BxwJqBBkcpcan8MwMpVqf26jKrenY30enSIYZGa262m+wLCw2YAXw6zTfnQLApofw4EJBVj+mzO5dVZ6YxV6i+X7VVqvR9dIg9wgDgBVwBxgQEbzvp+O6Wj6Tqb7/Vm6Y7UhGztTjIuRnKibzNSoIH9TnCP7gSTzmOgGCpItMedg8Sr1pNJgnkoHhzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DNWcUxJPGfZZTcnx42jyiO9lHvv04sC77ZVyfmUypBo=;
 b=FGiuMoGkU8CY+0ngzgfMcCuWqUpOnsyYiQJGibGYSXGAxfuPCl2TjHxRmTpKt4LrBX5K6nqW4+JM21bmNiAMVubnYvfEqpjiaRVyhWNeVlHCpKFf/dwNCxHJfONT+bOO+/KRK6MiJIZecFpY/8zk13MA5qDU5nlMOHnzAGj9wII=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY8PR11MB7194.namprd11.prod.outlook.com (2603:10b6:930:92::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5632.21; Thu, 22 Sep 2022 14:12:08 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714%3]) with mapi id 15.20.5654.016; Thu, 22 Sep 2022
 14:12:08 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <yangyingliang@huawei.com>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>,
        <george.mccollister@gmail.com>, <vivien.didelot@gmail.com>,
        <linus.walleij@linaro.org>, <f.fainelli@gmail.com>,
        <hauke@hauke-m.de>, <clement.leger@bootlin.com>,
        <sean.wang@mediatek.com>, <kurt@linutronix.de>,
        <Woojung.Huh@microchip.com>
Subject: Re: [PATCH 7/18] net: dsa: microchip: remove unnecessary
 set_drvdata()
Thread-Topic: [PATCH 7/18] net: dsa: microchip: remove unnecessary
 set_drvdata()
Thread-Index: AQHYzo0CUk/sq3E7bU2UJLua1emqFq3rfX0A
Date:   Thu, 22 Sep 2022 14:12:07 +0000
Message-ID: <291e1e20d479629e82bbca984c15e9e87dbe1197.camel@microchip.com>
References: <20220921140524.3831101-1-yangyingliang@huawei.com>
         <20220921140524.3831101-8-yangyingliang@huawei.com>
In-Reply-To: <20220921140524.3831101-8-yangyingliang@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|CY8PR11MB7194:EE_
x-ms-office365-filtering-correlation-id: 59fbe064-48d1-4a3f-e682-08da9ca46f27
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GYxZh21NbOq8VB9+zJHBs965FOR4PbbA2zEMiYBwtwj8kgXZ7WXSeiYD9IIUoPMs6112Le+gxQPmZgeDqqhhk9SoUTDcvY91tDLakVVe2qY2h5yAlKvutvtTRPjiZcnEv8nhMDov7L89NaU0kYB9me02K0+BLc2MI8PySmDoYJCXNF1FXOwDxmpg8TRp1L4/n7d+OKdZB//mKsu1A8VySQw8K4R0u21xvSKnd15AA/hcL3S95SjIGgf/6iVmFNxsgJEmhfxTojqjD0y8bIsmWKuqU0DaAshOmVdRZOh6Fsqp5cf30avn7+4SchILYAM+eQ1mNDhRm+TRX9McAKxrB6s7RAs4ALNQVRB+TREIwIdPV4hSbmjCc2ol1uBzv2fEjmZX8+EV7iOBu0Vr1QpMDtmG74sfo9gAJf/fvwImJMmcOuHnIfjHwvq+nzrOKPfIYTctiIF4mSA+I5pDLdvMMjGwlGWcGGo2Xcj5Uline2ioiGQdrsh8NFaXURniPvEqwmtVIVuipyprY997L9uXGmrssU51JiUxLQd7OojTwRp8gSsNWAFwPLrKQ4O2XuLEEcmeq0SjB4z3Tp1TEuAkXvhkzrzdR59NuoISTDPRUBhgV2DjCViyBRdSvbSqsIgviXB+uXV+M0iyOi+ouOiu9LJtajx01OYaqs3oGhVnlBnx42fMxoDf85zdnsAvykkRuwOYeHwAM8YwWLf8kfULP9V2njcwcyee1k0X9m0Z7V5AmiNAuP5T8YwOpHd6DcsESLnKV0nhHAYThRBvVtiIiwCq+uInH896UdfSti0O0AA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(396003)(376002)(39860400002)(136003)(451199015)(5660300002)(7416002)(83380400001)(122000001)(110136005)(316002)(54906003)(6512007)(6486002)(66946007)(186003)(38070700005)(66476007)(38100700002)(2906002)(8936002)(478600001)(2616005)(36756003)(86362001)(91956017)(71200400001)(41300700001)(76116006)(66556008)(66446008)(64756008)(107886003)(6506007)(8676002)(4326008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cDBLbnp5YUMvaXVzYnlKN1RJZEZnc2pFUTJrekN2WHVGVXVqSHhkREJFeVhM?=
 =?utf-8?B?NzhzbUpLY2twc1ZxdEYwNE5uLy83elUwNlNjV2FLOU9SR01SYmVqRCtsNW4y?=
 =?utf-8?B?NnZteXYrYzBCZXRRbHRtRzkzVWxGWDBWVm9PUGlzZVdyYms3eitOQUEwRm9t?=
 =?utf-8?B?ZXhRa2RBQm5YTHF0ZzhyVnRXenY1SDhhTXJiQ3V3UEZBSS85RjFTN2Fpajh0?=
 =?utf-8?B?ek4wbEhTTEZHckhURFI5cVNHckI0Q1VBMjB4RVplOUNmbXVxekZNOXIrRlY5?=
 =?utf-8?B?T0g0Sys1QzhuMnpTTUdzN09yV0RQbHZmYlBmb28zRkRkY0E4R3VwU2tqTDFq?=
 =?utf-8?B?MjJLSFc0Y2ZmcjMzRFJoUEVWaHhzd1U2Sk1waHRYREhhV1hZWXR5dFdrWHgy?=
 =?utf-8?B?WmxiMStHNzFaOFZkQWxlL2I1MVZmMmM3R2czSHEzL0FndGdVOXRYbUpxR3ZE?=
 =?utf-8?B?U01KRmFGaHF1c3VOeVVFYjdKQ0NxWE56NHZjbDJhWWt3WXZoNkxtTkl0amdM?=
 =?utf-8?B?T1R2TlIxV2JRU2lGOGcrdUhMRnJUVDVmbzBsUTNPWkY1MXkydXJIYmQwdG13?=
 =?utf-8?B?Ui9Obnk1UUhHbFlLMURHZTVHNE5HRisrWEF0UmZaRERvQy9YYTk4YlRJK21W?=
 =?utf-8?B?L0VTTEJDQnpKdk96S0E4WVlUTTlxd1d5bE9jdlRUL1dxcmt2b0RCQmZXTTlm?=
 =?utf-8?B?VWRYZWhlV0RnbVdQSmRPOWRtci9xQVNodnp3QmMzNkFvQ1NIbmhPM3kzdUtC?=
 =?utf-8?B?SWl3N2hEMzlZZlBVdWhHN1hlSVFMM1YvYzdWZkdsWWN3NW84aUxPNW9yY2hq?=
 =?utf-8?B?djZ1MDZxZHNmWnl3Zzd3QzNKdGZYa3gwNDMwN09nNHJSQ1hEZ3VGaWRCNlRa?=
 =?utf-8?B?M3ZHRkUydHhnTTNQL0l6L3ZkWHlsT2NYSUFzTURLMWQvL2pyejhKREdzeVFv?=
 =?utf-8?B?T1hGdUdHTVA1OU5TemJJVW9JWGo3dE1hTUc5S3hTWEZJZEJ3ZE9aQzJVK0tw?=
 =?utf-8?B?ekg2WlZOMU8yN3RZV1pkMGkvanBEMWl2KzEwbWZ4L3M5YTRKYy90L0RLemVV?=
 =?utf-8?B?eit3bm9IQ1VFYlN5VkVBQlc5akgxbmNSNksrK3dIQ2Z2Y1NXL0FuMjkrS2xv?=
 =?utf-8?B?ZzJ4V1ZSOEk4ZWs5T0tCYUNnZTQxTVBTOTZPTnZ1cXRWTm1hTGx6RTNsNmRy?=
 =?utf-8?B?MHlqd1RLQlFMVmxCNWt5ODBXRXNsSitmdWJYMG1qbGtZZE5NNkdJeEx6Wk5k?=
 =?utf-8?B?Nm1ZUHpVZVRoTkc2Wmo3YXIvbVNYQ2owZVhqZXdrYVBVMEVaWU5MaUNiaXNy?=
 =?utf-8?B?L0dVSlVoTEpYZ1pVN0lzekQzdndscW50eHFiUnpET0VlV3JGV0VsN3R5OEcy?=
 =?utf-8?B?ZnVUN0dyNWlnQlFqVDZJQ0kreFJkdEhqcFprRWZJNW54cjc0VlVxa2hkTTNm?=
 =?utf-8?B?K0V4eERLZktxSElkNXFDNU1uZWwwOWNnSytwWmRFSzlQamYwd2xWZ0xrdktK?=
 =?utf-8?B?MlpGcVo2TmJaOEVpNUt4L2IydlU3VEE0VGlrZ3grMXI0bWVmMVVQWkNlMnd4?=
 =?utf-8?B?Z1d5Znh6dXc5dGg2dlhaVG94NTl5UC95N1hNQUhERnBmSkhkNDRUb1BTeWdN?=
 =?utf-8?B?ZVdKRkhDWmJUZnNlRHN2RlF5MjRIaEZ1L1lUdk5oQkx2Q2tOR2pkc3A3LzJW?=
 =?utf-8?B?SDQ5S1k0STF0elNZUzlEYzQzRXdxeHlUTVczYXB1MXdjZllYWW9yZy9ORUJN?=
 =?utf-8?B?UkFEd0doWStKTVI0cjc4QzNJUDlCSFYzY1l2VjJUekoyTkhaTk9acDlqMDJX?=
 =?utf-8?B?OXczWkFsLy84dU5sOFhPcGtpT0dhVWYvTHd0VWlMN04vR3NHMXROYkI0V1JK?=
 =?utf-8?B?U1NvNnBsZ2NUUVVkeHZiK3ZuanJRREFBMWExNlMzMXhUckhCZURNNjl0SkNS?=
 =?utf-8?B?dEpleERDUWxiQm1ibWtERURrNlpHRzdhVXoxa2lLZFpkam9LeXlDNXU0OE1j?=
 =?utf-8?B?cDBFY1V5NnE5M2RDTForOGN2MDA4TjRFVzQ1UHZWbTlnWkhRL3hDVUd6NkM2?=
 =?utf-8?B?c05xdUljcGlXWjhMTnN1QVduVGppVHhvTGNxbG5mTHhxTFM3ZEZzNFpvVFlC?=
 =?utf-8?B?WjVkeVVwaUo4V01qa0JPOVd3VFVBT3cweW5FOFdvQVkvNTB5cWljKzJyYStP?=
 =?utf-8?B?MVMxTzFYSHVZV2NUa0p0dEdvTlZEU2ZpRzBlNXY1QnFIRUE2RzlZMmUvT3dx?=
 =?utf-8?Q?H4fcl5EgffZ1o2dbxzWf8AbQr0Xo762jpoX6VLhMl8=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BEBD127D1FDF844B9DC48C4889D9C287@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 59fbe064-48d1-4a3f-e682-08da9ca46f27
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Sep 2022 14:12:07.9333
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: flrWZi+bK0KPofYxRRGEYAPEEAWGAKYBf3Ja+3Yerl6KHeKm0ha2BauYOyarkEBdzdnZD88IMg+1uEOX7b4x87OouNnf1YM4EuNnGXTseeQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7194
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIyLTA5LTIxIGF0IDIyOjA1ICswODAwLCBZYW5nIFlpbmdsaWFuZyB3cm90ZToN
Cj4gUmVtb3ZlIHVubmVjZXNzYXJ5IHNldF9kcnZkYXRhKE5VTEwpIGZ1bmN0aW9uIGluIC0+cmVt
b3ZlKCksDQo+IHRoZSBkcml2ZXJfZGF0YSB3aWxsIGJlIHNldCB0byBOVUxMIGluIGRldmljZV91
bmJpbmRfY2xlYW51cCgpDQo+IGFmdGVyIGNhbGxpbmcgLT5yZW1vdmUoKS4NCg0KRG8gd2UgbmVl
ZCB0byByZW1vdmUgaTJjX3NldF9jbGllbnRkYXRhKGkyYywgTlVMTCkgaW4ga3N6OTQ3N19pMmMu
YyBvcg0KaXMgaXQgYXBwbGljYWJsZSBvbmx5IHNwaSBhbmQgbWRpbyBidXMuDQoNCj4gDQo+IFNp
Z25lZC1vZmYtYnk6IFlhbmcgWWluZ2xpYW5nIDx5YW5neWluZ2xpYW5nQGh1YXdlaS5jb20+DQo+
IC0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4ODYzX3NtaS5jIHwgMiAtLQ0K
PiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfc3BpLmMgICAgIHwgMiAtLQ0KPiAgMiBm
aWxlcyBjaGFuZ2VkLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6ODg2M19zbWkuYw0KPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNy
b2NoaXAva3N6ODg2M19zbWkuYw0KPiBpbmRleCA1MjQ3ZmRmYjk2NGQuLmRkYjQwODM4MTgxZSAx
MDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4ODYzX3NtaS5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODg2M19zbWkuYw0KPiBAQCAtMTgw
LDggKzE4MCw2IEBAIHN0YXRpYyB2b2lkIGtzejg4NjNfc21pX3JlbW92ZShzdHJ1Y3QgbWRpb19k
ZXZpY2UNCj4gKm1kaW9kZXYpDQo+ICANCj4gIAlpZiAoZGV2KQ0KPiAgCQlrc3pfc3dpdGNoX3Jl
bW92ZShkZXYpOw0KPiAtDQo+IC0JZGV2X3NldF9kcnZkYXRhKCZtZGlvZGV2LT5kZXYsIE5VTEwp
Ow0KPiAgfQ0KPiAgDQo+ICBzdGF0aWMgdm9pZCBrc3o4ODYzX3NtaV9zaHV0ZG93bihzdHJ1Y3Qg
bWRpb19kZXZpY2UgKm1kaW9kZXYpDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzel9zcGkuYw0KPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X3NwaS5j
DQo+IGluZGV4IDgyZTIzNTJmNTVmYS4uMWI2YWI4OTFiOTg2IDEwMDY0NA0KPiAtLS0gYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9zcGkuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2Ev
bWljcm9jaGlwL2tzel9zcGkuYw0KPiBAQCAtMTA3LDggKzEwNyw2IEBAIHN0YXRpYyB2b2lkIGtz
el9zcGlfcmVtb3ZlKHN0cnVjdCBzcGlfZGV2aWNlDQo+ICpzcGkpDQo+ICANCj4gIAlpZiAoZGV2
KQ0KPiAgCQlrc3pfc3dpdGNoX3JlbW92ZShkZXYpOw0KPiAtDQo+IC0Jc3BpX3NldF9kcnZkYXRh
KHNwaSwgTlVMTCk7DQo+ICB9DQo+ICANCj4gIHN0YXRpYyB2b2lkIGtzel9zcGlfc2h1dGRvd24o
c3RydWN0IHNwaV9kZXZpY2UgKnNwaSkNCj4gDQo=
