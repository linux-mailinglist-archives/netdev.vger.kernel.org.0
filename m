Return-Path: <netdev+bounces-4880-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C68A70EF4F
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 09:25:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3C7CE280FB6
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 07:25:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8746079FE;
	Wed, 24 May 2023 07:25:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 708C91FA2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 07:25:20 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9231F9B;
	Wed, 24 May 2023 00:25:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684913118; x=1716449118;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=QtaiFeDA4mB4+1LpL0FCJj4i6cJXmB0BAACsnky/hoE=;
  b=rpWN1Q1DB0cSUu5O7Fsfu1EIsGDWDeSw4NsSi7+E/G+Fhv6DYF3kYOtW
   LD09sexM2xyR/4NuFYqLKpj7hJLamAbttArsp1TznIEAONLK2bFePKNgH
   +fNrLuoWxt9xlYeAXJybaF9TACtivAUeDSk6mBcZgaad1QB0kxJ3d5DfD
   sCvYRJzWayQvp2ZjPNtzjGR0O0hCqflUfwYTx+DkeHgRgrUnKlucPnhAx
   BKxhc9AMX06HZyqAxdzT60wk5dXRx8U7I+b15AwcpoXMdKVvBa91hyVwc
   WUW/6wOzRp0BpLCwTtxLF632jtNLv5U8KL7/mSgk8dVL0pR6FkX+sRzlf
   Q==;
X-IronPort-AV: E=Sophos;i="6.00,188,1681196400"; 
   d="scan'208";a="217006314"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 00:25:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 00:25:17 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Wed, 24 May 2023 00:25:17 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=frheY3od220WF+gXrEE3Dhwhr71LQGVHG+wWnTIfzC8Oaa9ITSQA/VVRfEmxgr8/VpPby1/0nvN8Y0MjxhW2JtM9ZxVjrux3RDoPFdmOXP9PYgkm2pYoseaql/Yq+jd02wRaQNM2MTvRKMj9E0hmCH3veKO6m/4vwrEryXJvjBqi51MsgSRFKlGyvPMN8XypBUX72/hxG4XseQ/kVOxe//6Sd6EXaDK0+9BQe+w6yPcR2YC+pip2taKVNahw1S8u4YkXzduWzahvrtvT4pkGdI0ONVslmp3KZ0COoVqYUOsx0gx1u6okFRctPJmOlTDT1asCR6ktwj8juReNC6lpjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QtaiFeDA4mB4+1LpL0FCJj4i6cJXmB0BAACsnky/hoE=;
 b=XwlK7htw+L7ivBevs6563kkbVzXbtzRptYUHuDsw9JJPhWiG57eOufYe+y8TPBggQMT1XFxye6hE/d+ZLXWFs3vSQ9il5ScxgOG3bHKcyWvUdecV8HDVagUPlZWJ90bNWggYS7Z+l4MPSEFqb5iKMWYV7KBaj35YoU5VsH31evpDsXCbPqvyeOt9vgA63JDVY/sDC24YrGZF2Iw5w1DsKnI+le/nBKyUNrT5ot5nSz1FF5bydvwcGgYkOAvgLDclzCPdahnc8NkwgXEZ+M/fTK432UtnE/AfibLjXNLqCVZs8uEkLKwSJ/ODyYysuymJMz4bX8DoSQdCa+JfhrR1KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QtaiFeDA4mB4+1LpL0FCJj4i6cJXmB0BAACsnky/hoE=;
 b=KUDL5/JRTjaoIpvNtfyipk9rO+x8qVcYs2b68Hx16gNQQL/yJOxyQonZ32Q7P1jrVvMsAVq7nTyiqcEkkkWyNRpjDk4rrTERaFVd5usQly4XiZGnM9x0CqRXNbKvkdr7XR5g3rKyaseQDoOqvc/4zYVOofvMOpWk96rl8sALyKo=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 CH0PR11MB8236.namprd11.prod.outlook.com (2603:10b6:610:184::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6411.28; Wed, 24 May
 2023 07:25:16 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Wed, 24 May 2023
 07:25:16 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Topic: [PATCH net-next v2 6/6] net: phy: microchip_t1s: add support for
 Microchip LAN865x Rev.B0 PHYs
Thread-Index: AQHZjKFXg4D7h/qJg0WxwlInlNp8HK9mQHSAgAEiHQCAAGiSgIABPbgA
Date: Wed, 24 May 2023 07:25:16 +0000
Message-ID: <4b873053-38d8-f642-a5be-d9eba1f408fe@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-7-Parthiban.Veerasooran@microchip.com>
 <349e1c57-24c6-46fa-b0ab-c6225ae1ece4@lunn.ch>
 <f366d388-420a-082d-ed26-25e93d143671@microchip.com>
 <819531cd-ebd7-4734-b35b-8f8c3d138004@lunn.ch>
In-Reply-To: <819531cd-ebd7-4734-b35b-8f8c3d138004@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|CH0PR11MB8236:EE_
x-ms-office365-filtering-correlation-id: 7cb66a31-21d0-4093-13f6-08db5c280550
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: snFsYNA9ciy2skHdi95hHvesRWFYq6QPMSHgnKJ5XFfO5ho7/+QZ5CrxtRJEHokB7C7e7FbTOoed8CBmyx9DzkN6IoqHPZ3zT0kjuQpmMKThcCgE73jGv0WbXMFTTOH9gfsI5CmHCX+WJg8dcTrDi4mqRNhh+rc+f+EhJWzbUHEFzNxE4AHAOYH+r0jLqdtG6cDBfY774laIC0lmHMFFZqhhPF5mzseG+1JLc76kGw47ClDLQUNs6wP4EIt2/egA6ieU0/M+IUJnADLDfuW+Shljqub85qD4rbSc8LsyKnQVINghYb3Xp0rH3ZQBTmucV2REJ37WpXM+wyMJ4fMu8RJHYL2dFS5Ah6YIclbgaZif8l1IUDMBem31U39/Hj4dTTnZkkgbiTuE/g8bhF99lA+rU2xBycorDQYCFjvG4q9qHrPM82d3Y5ZKaiujs8392Ww0MG82PbvTKECBQQaJHkMDiK8E9qcS9BQTDQxsJnYJEacLCzFq+HLbrqHW8XMQetIr5jg81H588nSvw9GiCiOWPm1iQ9wNVnqG06dao8EmN4RzAEv33e25Q3geG0dFDgkS6vibLNzu1IMW+mOC0h1/lNyPZL3pae2Cw70Jr38YUnlNlbAe8j4LwWkBB6I/943rpKhETAtK/HdYSH+kFRqJ2dOyVE51WkuFICtb8OoByJjAWcXCS5S1O8ccXTLC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(396003)(136003)(39860400002)(376002)(346002)(451199021)(54906003)(91956017)(31686004)(2906002)(5660300002)(7416002)(36756003)(8676002)(8936002)(6916009)(41300700001)(4326008)(66446008)(66476007)(66946007)(66556008)(64756008)(478600001)(76116006)(316002)(71200400001)(6486002)(38070700005)(107886003)(6506007)(26005)(86362001)(31696002)(53546011)(186003)(122000001)(38100700002)(2616005)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aU8rZjZ2UHhRNmladHNtd2srMkpmeFh1UDJLSElTYjVFbWRmK3hudEQ4aVgw?=
 =?utf-8?B?Vnkxb2F4bUFPQzI0aDhUZ2RjVG5sa3JUc240YW14MGZsNFlLc1ozMVRrL2Vv?=
 =?utf-8?B?N0I1UUZYSm9lclpKZk04WnhYaTFKSENDdWlwKzVqajdDa1Y2REttVkJWa2E0?=
 =?utf-8?B?WVZTZG9hVnQ0S1NmR3UzaHpsa2tsUXcrVE9LaUk4ZCtUVm5CYXdYZXVHdFNp?=
 =?utf-8?B?RG5VZ0tuN3VVNmlSUldac05sZ2ZKYmYvWTFUTlFJYkdmYVFuWVZYK3lTZTkz?=
 =?utf-8?B?MzZVWGkzdDd6RnR1aENWU1lPTU55T0MzU3ZsbEl1eEx3RjdydlhVbk5VUnJ4?=
 =?utf-8?B?KzRVd2tqN2RxK0FQaUh5M0R0VWI3ckFZZXlOQU5rN3FMMHV4VEhBVHpOZmpv?=
 =?utf-8?B?MUN4cjRTSVRhajREbXd1d05KeXBKRlVNSmkzWjM3WDFqaDJ2WUN6dlNIOC9V?=
 =?utf-8?B?QzFYWXh3ZE5sNWZuaVkvRnc5T0dza1Q2U0xmYVBmRmttcHh3SjU1WjRobDB3?=
 =?utf-8?B?TCtuc09OZjRGUG5yMnNDM3VRRTkxb2paMHdETURTc09FdjNZUS9MUVE4RHpm?=
 =?utf-8?B?MmxkbnRzNnJSTElkZTRIRXV0QmFpTGp2MWlheWlUcXRhOGtKbnBvWURvMEhw?=
 =?utf-8?B?cyt4UER1ZVdjcjJIMWtQQWpQT2JkTXZodDI3T05va3pzREhJSk9oRTJpRmg0?=
 =?utf-8?B?SDRTcXBwWXVPNTVMUGN2eTVSM0lWV01qY1o3aVFQdURGbGZSQmpIRVFjUTls?=
 =?utf-8?B?YXBIOXlOc3I4UVVyMTVnQXlmVW1uZnFNM1FudXZNc3Q5aGhxZzE1R1prK2lk?=
 =?utf-8?B?elJDcHpRTEZ3bzBhNzZjNTRzWS90Yys3TTN0S2NITGIrczBOWUxRTTlOd2xs?=
 =?utf-8?B?Q0tERW5ZQUZVQWg0TUJJeFgyb0RQdWNGazdJYmoxM0RTUmdHR2FyQ3lwck4x?=
 =?utf-8?B?SXBOcFRTa2YxUGhYSVdkSml0UW1HR2NUeXBsN1UxVlNBdVNlUUNBOXVvQy94?=
 =?utf-8?B?cEs4UmlSanQ0SmZZMTdYR1Q5RWZML0tnQ3lxODdRVEQvWm1jZXZhVGxXVEVs?=
 =?utf-8?B?TUszbVNPVExQazN4b1VHTHlUeVUyVHcyY29SYkhuZkl0c3pxYkY0UnZ1N2Jl?=
 =?utf-8?B?WG1qRDBKaDkrOSt0M3hwbFlaS2NXQktYNEpPTVBTSUVtakRkaFVRWEFxNEdn?=
 =?utf-8?B?NGRvODdVZmduem9VWnJ0L3IrczV1OXNMT1MwSEZ3aGNDcHVZMFRGVEZ4UjBz?=
 =?utf-8?B?b0lnRStZcXlsdUUrbXJZQWJQYmhyR294aCswaEhPcWExeS9FMTd4bzIwYUg4?=
 =?utf-8?B?Q3I4enhhZ2UxNjI4NzJmUUJTalBJTEVXNEpvbmNvam5jenRIdTVzbTdOSzFH?=
 =?utf-8?B?MUJvMkVkUE5kRG5oaGFBT3RReWVsRlB6ZDY4MDJxZEZwaGRXV01iSVlid2p0?=
 =?utf-8?B?bDRybG9zcExWRkVoU1g1TlJNMVJOd0JqR2dYN29YMklmdlVMdGEvdHZKSWRX?=
 =?utf-8?B?MlMybE0wd09pRVB6QmFSQmtnNEhtS3g3dFJ4dVJCS1VZUXRvUWtqcWp2Z1J4?=
 =?utf-8?B?NVVuVjNkZFlpY0lBeitSQWFqK0E2MGZKbjZHcGdKTE5FYUlURkkweUZZUWZB?=
 =?utf-8?B?YzgxTGhzUUJrek9mT24zSTc2c20wMEU0clFZRGxHbUxHcW1uMDFhRWxFMDBP?=
 =?utf-8?B?cHdkVjBqbWxyckU5YlhEWFdKcU9NRDdpNEl1NGYrMGlxSGF2OE82MjNKWFNT?=
 =?utf-8?B?NW53ZDhBUC82dGZLV2kvK0tHOWNCeEtGY0RsMlhiQzRmcVpOTlJYTDB2eG1X?=
 =?utf-8?B?OHd0QTIxMmV3eEpuaWMxM2t3QUxqUW5jOXNDYytUeER6dHdMeFNLdy9PWXE3?=
 =?utf-8?B?N09Jb2txR1o3NEVMY0MyT09aRXh4aFN4blVlVVJnUzFiS3djNmZBQkxkUzQ2?=
 =?utf-8?B?Mm11V0lBcHdwc0ovTjlRY0QrTURuMVVHVHlDSUlWKzVUdmZuK1AzRmVQcjBB?=
 =?utf-8?B?UERVektBRlFyQTNZaUxWMVhyUmQ4VERxcHlDd3dFZm41KzB2TjU0ODlJTmtY?=
 =?utf-8?B?ZmJISDJGUUY2UldZYmVnSGZ0c2NEM2poUWJMVW1wT1ZDcFl6NkRKcU84YVlu?=
 =?utf-8?B?cDN3UmNBUUZUdzRvN3Bkc3lZekk2UXhsRHZvTUxTUFlnRTREZ21VbTlqNm5Z?=
 =?utf-8?B?SXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <01C1E593EDF2554E992EC867592240AF@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb66a31-21d0-4093-13f6-08db5c280550
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 07:25:16.0296
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5HMSzKcoWhiAjs9sMDVdzBtXnyQSzSeXPvp2LGiogU62glEzT1YCuxt2nBhDYIb27D0geQ788zY885AcEkFBp4dpKzCn186cjcFIRCNPKo+3iXJF+wp0/jrIM1NJ7hih
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB8236
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpPbiAyMy8wNS8yMyA1OjU5IHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPj4+IElzIHRoaXMgZG9pbmcg
YSByZWFkIGZyb20gZnVzZXM/IElzIGFueXRoaW5nIGRvY3VtZW50ZWQgYWJvdXQgdGhpcz8NCj4+
PiBXaGF0IHRoZSB2YWx1ZXMgbWVhbj8gV291bGQgYSBib2FyZCBkZXNpZ25lciBldmVyIG5lZWQg
dG8gdXNlDQo+Pj4gZGlmZmVyZW50IHZhbHVlcz8gT3IgaXMgdGhpcyBqdXN0IGEgY2FzZSBvZiAn
dHJ1c3QgdXMnLCB5b3UgZG9uJ3QgbmVlZA0KPj4+IHRvIHVuZGVyc3RhbmQgdGhpcyBtYWdpYy4N
Cj4+IFllcywgaXQgaXMgYSByZWFkIGZyb20gZnVzZXMgYW5kIHRob3NlIHZhbHVlcyBhcmUgc3Bl
Y2lmaWMvdW5pcXVlIGZvcg0KPj4gZWFjaCBQSFkgY2hpcC4gVGhvc2UgdmFsdWVzIGFyZSBjYWxj
dWxhdGVkIGJhc2VkIG9uIHNvbWUgY2hhcmFjdGVyaXN0aWNzDQo+PiBvZiB0aGUgUEhZIGNoaXAg
YmVoYXZpb3IgZm9yIG9wdGltYWwgcGVyZm9ybWFuY2UgYW5kIHRoZXkgYXJlIGZ1c2VkIGluDQo+
PiB0aGUgUEhZIGNoaXAgZm9yIHRoZSBkcml2ZXIgdG8gY29uZmlndXJlIGl0IGR1cmluZyB0aGUg
aW5pdGlhbGl6YXRpb24uDQo+PiBUaGlzIGlzIGRvbmUgaW4gdGhlIHByb2R1Y3Rpb24vdGVzdGlu
ZyBzdGFnZSBvZiB0aGUgUEhZIGNoaXAuIEFzIGl0IGlzDQo+PiBzcGVjaWZpYyB0byBQSFkgY2hp
cCwgYSBib2FyZCBkZXNpZ25lciBkb2Vzbid0IGhhdmUgYW55IGluZmx1ZW5jZSBvbg0KPj4gdGhp
cyBhbmQgbmVlZCBub3QgdG8gd29ycnkgYWJvdXQgaXQuIFVuZm9ydHVuYXRlbHkgdGhleSBjYW4n
dCBiZQ0KPj4gZG9jdW1lbnRlZCBhbnl3aGVyZSBhcyB0aGV5IGFyZSBkZXNpZ24gc3BlY2lmaWMu
IFNvIHNpbXBseSAndHJ1c3QgdXMnLg0KPiANCj4gTy5LLiBQbGVhc2UgY29uc2lkZXIgZm9yIGZ1
dHVyZSBnZW5lcmF0aW9ucyB0aGF0IHlvdSBtb3ZlIGFsbCB0aGlzDQo+IG1hZ2ljIGludG8gdGhl
IFBIWSBmaXJtd2FyZS4gVGhlcmUgZG9lcyBub3Qgc2VlbSB0byBiZSBhbnkgcmVhc29uIHRoZQ0K
PiBPUyBuZWVkcyB0byBrbm93IGFib3V0IHRoaXMuDQpUaGFua3MgZm9yIHRoZSBmZWVkYmFjay4N
Cg0KQmVzdCBSZWdhcmRzLA0KUGFydGhpYmFuIFYNCj4gDQo+ICAgICAgIEFuZHJldw0KDQo=

