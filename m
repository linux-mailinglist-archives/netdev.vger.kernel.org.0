Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54013554BAA
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 15:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236417AbiFVNrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 09:47:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbiFVNrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 09:47:31 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D7E27CE4;
        Wed, 22 Jun 2022 06:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655905649; x=1687441649;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=qWmmPWCYCQM9SjMk3OAALQ3VYHnoqMc9gfXt0MgRBHo=;
  b=lGhDcsyDaPCKIEhonwY+ANEgs6fbaXLKil2K6HoYSJ4e3vpchuYa77U8
   Cf1uOGgliktIaGfbDUs8PdgtdFxkZPQJBv/L1ezSzebjExUm/HaoEb8qX
   zmveDvI3OCasoTu90N12NikkszJr91rzN3NThq2wt39P9s0dhoTz3rUW8
   QqWuSRawgljqbHxzhhpcZpZTBT9sDCdJ1pgGG7wzmq/BWd1vJrJutvMmW
   QSmFvqHxb6X1eTSz7V/QRFAu0QoVJscSZnzkYbntcOgoGNjZNQ2plBzbm
   Mwds7Js6TZWtYQyT7RrRilHefNLVg3Ak+O1sVA6zN4beGdJSKGCLfmUvb
   A==;
X-IronPort-AV: E=Sophos;i="5.92,212,1650956400"; 
   d="scan'208";a="164572871"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jun 2022 06:47:27 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Wed, 22 Jun 2022 06:47:27 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Wed, 22 Jun 2022 06:47:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ev/V4vu5yVYhhsqX4Ik9AQhReZ+BluXtBlMtuoxf//6/dHVTkbcVEF2PxXwRXgfi1DRJeJ/bqAsWEjPUwZIWhKFnHw2DDIT/Hg2+GYWZ9Wp4G1YbeLLtU+jLIlb6Yl0h6Q+z0pwaR0yzQ8uAZv11H/xr/YS3YFEaq+pcqkuCBe/zxWjATEz/TAWnxPYV0Nf+rbVTy4MTio3KGZWdyN6AxI9tPyIUISiPHZPE0yrMLOZXqAqJlEfA0HmqRLBtkEM4RRhGwPHWz6p/Xptpl51k0XF6CS3r79RC2ZKZenEJ9tQJPTiKIOT96GqCjo5NIKB+EZ8kUSkZOujyUji8kgEZtw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qWmmPWCYCQM9SjMk3OAALQ3VYHnoqMc9gfXt0MgRBHo=;
 b=IfAXxjs52YU5UAUTRotx/Et4sW8O8HAudd7VGwztqUlPOLDNHY8bzv+nAowkVyy2JGEGnGX/IsZW8MjEXszHClBf01KZwWRIaQKEZQApHMOTbCA3g6pp0Rd2MkKACNjCky6UvPm0LV8YDzMMJS1C/agMh7n4kbbXAhmL8zs3gfprdhIq/pLucRGox+nyn0PFLHuTkNj6zPDGzXPqI7QZKJ1maRBIoU439H6POAg1OstfX5TWPLv93OKJ9thfcf+JGS0SH+yDhP9E4CGGqGRRFrhXCh6JZA/xBFfWt6XwVZTRo2vnd91pH7x/pJbdn9bnThqEPqrUtbUSECRmYKC6mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qWmmPWCYCQM9SjMk3OAALQ3VYHnoqMc9gfXt0MgRBHo=;
 b=JaJQSwJqnmZTpL4A5iKxhfVLROv+IMtudlmEudE6FNinZ3Ytl/aJ3nRCfJuK89iF5B/q2EcEcnNsO1/0lxiB9Gvu87gZf7DY4zwDJP5JoAmHbSUhRlJN2kgp0zi8e7R3bR9Kh1Whd8/04WyleNLdT+66V1tfCit9oA02raqFZF0=
Received: from BL3PR11MB6484.namprd11.prod.outlook.com (2603:10b6:208:3bf::19)
 by SN6PR11MB3440.namprd11.prod.outlook.com (2603:10b6:805:cb::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.15; Wed, 22 Jun
 2022 13:47:23 +0000
Received: from BL3PR11MB6484.namprd11.prod.outlook.com
 ([fe80::49ea:e5b4:f03f:15ff]) by BL3PR11MB6484.namprd11.prod.outlook.com
 ([fe80::49ea:e5b4:f03f:15ff%7]) with mapi id 15.20.5353.015; Wed, 22 Jun 2022
 13:47:22 +0000
From:   <Thomas.Kopp@microchip.com>
To:     <mkl@pengutronix.de>
CC:     <pavel.modilaynen@volvocars.com>, <drew@beagleboard.org>,
        <linux-can@vger.kernel.org>, <menschel.p@posteo.de>,
        <netdev@vger.kernel.org>, <will@macchina.cc>
Subject: RE: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Topic: [net-next 6/6] can: mcp251xfd: mcp251xfd_regmap_crc_read(): work
 around broken CRC on TBC register
Thread-Index: AQHX63m5RC9thyxmT0S34SqWhDegYawp9YdggAADTb6AExztoIEeCL6AgAGHvgA=
Date:   Wed, 22 Jun 2022 13:47:22 +0000
Message-ID: <BL3PR11MB6484B2AE23D324AD24B614AEFBB29@BL3PR11MB6484.namprd11.prod.outlook.com>
References: <PR3P174MB0112D073D0E5E080FAAE8510846E9@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB5390BA1C370A5AF90E666F1EFB709@DM4PR11MB5390.namprd11.prod.outlook.com>
 <PR3P174MB01124C085C0E0A0220F2B11584709@PR3P174MB0112.EURP174.PROD.OUTLOOK.COM>
 <DM4PR11MB53901D49578FE265B239E55AFB7C9@DM4PR11MB5390.namprd11.prod.outlook.com>
 <20220621142515.4xgxhj6oxo5kuepn@pengutronix.de>
In-Reply-To: <20220621142515.4xgxhj6oxo5kuepn@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c7698f14-e4ff-4910-3ec9-08da5455bbf7
x-ms-traffictypediagnostic: SN6PR11MB3440:EE_
x-microsoft-antispam-prvs: <SN6PR11MB344064F9401C63555C61611FFBB29@SN6PR11MB3440.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: m5mWeBz8uNYf3pnJP4sv6/X0tG4Ucto9nRy0YauANoYOHtbXxeBFK5JQOZEmzDGQR3n7BMZDxtm6VKMaD0jPFentF+pJVLMavoEC4v8nSOh0JoWsfszX6Fn/twGbYmds7Ez0AxFtxM7PWYIHSp9MM3lAydTglVepeWzYp25M04sAkMM589gTuyEdW0HKYFY1cMgZBTeqBBm/3ZhMboJC2HhOHJrhQVEbvkJAinorrttoO2EFZt96kSyA72K02o13ogQMip1LpxCCOagzfkxVbAhx4SuppZnCmJuodXQz+RAAUAvDvHnAQ4cFv51ZOebKaWGLma66Dh+dNz5uYZnigdDmJN8OAnLLEJ7FteLWFkto7WiVb2J9xJSIlqamLdQrk9+dFAbQ2feD4G4vVSSUdeeM6npb9bnBPA82+tcawF3cHTxNe4TzUIEosTooOPqDik67dO7DlYhJr037C1RZsBUC0RX0X8IdJ5o1KFnfULn0azM7gI1ci4mUq8shBUTtwTcwRVJPwEvWuoE85ebh8BwRDKVNjC32HPTnhcmSo05gRTgBmI40swy1ORpNrgS7zyXbM8zuE/BY3c2iicFG8fVEKArhk4GnJbbh4VzlCzErdV8Yvv33BIw7UK73zrX7PctpzHyxvj1ntNP5/+6+AqbcaCKW3wmF3q9Djpw04XaDQb8qcnYAHcITVz7VUcuFOpkaqSGw2HMLXuRmNAcsA8JNh2kYG5SPgu39UbZNPUoOUztvZJsDXgsoeFCDqjDEldhvjnUKY71dSgSiVlkhEg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL3PR11MB6484.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(136003)(366004)(376002)(39860400002)(396003)(33656002)(54906003)(64756008)(8936002)(52536014)(8676002)(55016003)(76116006)(4326008)(86362001)(2906002)(66446008)(66556008)(71200400001)(66476007)(5660300002)(66946007)(6916009)(316002)(478600001)(26005)(6506007)(7696005)(9686003)(41300700001)(38100700002)(38070700005)(83380400001)(186003)(122000001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TEFLNkZ3Y2JCQzJzQjVVQjYwUC91R3h1ZTQ1NHhTelJvNm1Bcy91ZWs2eU5V?=
 =?utf-8?B?ZnhTQ0pxcEk0UDNGS3R6V3RPeDdiTTYvSjh0cDJoT0puanpRcm16WHVDQkZa?=
 =?utf-8?B?YUZJbjdFUkNRZWMrYkJkQjZ4VUZiR3AwakJ1QXhnRmNrUXJOQ0lrYllKVklB?=
 =?utf-8?B?N1h1c2piSUpOV3pabEpSZy9Tc2xiMjlSbTRxV1dydE9SWnNVTHI2SUlzeDln?=
 =?utf-8?B?UUFBZlEzSDQzYXFicVQvSkl0bjlVajNNaDFFTlZLRXkxUktuSm82eVVUay9K?=
 =?utf-8?B?MzE4WTRINkVVU0JYcVA3Q1NRbDQzQzc1U0dpQXlzOVV6Vyt1dko4Q3hPMTdu?=
 =?utf-8?B?QzVRNW1BWTVxbVBqYnhxYlNUN1kyeWYwY2hQTWVVWGdsc2t1R0h6N2p0TDM5?=
 =?utf-8?B?UERNR04vQUFQVy9TWUZKNGVNbHFPTHV0bGN3SUNvdFlINDRYVnkzWTNnR1la?=
 =?utf-8?B?Z0xlc1VTUkFTTXBOYTBWa2p3MmtXNUJPbWlYUWFuRGVpTzVFVFlYTnVpWnMw?=
 =?utf-8?B?dmxGZ1B4YUU2TTFBWVZDb0g3aCsrd2lidmJYQStHZmFPanpOb3Y2a3g4TTdY?=
 =?utf-8?B?L0FHQ1RRWStqK3Q1ZTQ1TFpyWDF3aW5vMEMvUUYwWThmVWM1bGhBZzRUOUJU?=
 =?utf-8?B?SFMzc0pmSVJPWmFpMzF5cWRRaW9zdmtDZ2FydHJwUjdMcWtwZStVcVNPOHJl?=
 =?utf-8?B?SktUUGc2a0Rvb0p0ZmxaTDduQTlGa0NJVUZab2RlOEpBZExLMEdwRHRTZTFG?=
 =?utf-8?B?cHBxOEUwbG5NN3RGYmZoSXdiNFFnYlo3dW1Pbm9rRkswRDZjSWhWQysvYUlG?=
 =?utf-8?B?a2YzdG12T3BTZVMwSGx3RFFUOFY1OStDb0duWWNmSVFRTTJ2b2xBYTVZanRp?=
 =?utf-8?B?S3hDZzVHcmxoeHB3emNzRmtsL2JDNU9zTk1xY3hQZmtvMHJWRmFJU2ZBR1F0?=
 =?utf-8?B?QjNIMFRjOVZkYlNoSWw4M2Vwa2thZmg4SG0zYnYwdFNSL1ZQZHVQZS9tZEFV?=
 =?utf-8?B?U1JEQXVhTk5UVlVzMTR3eXRVQTF5N0t3T3pFRjVuUHhBYU9oZ0VoNk5jSDlJ?=
 =?utf-8?B?disrZjFkd21kdkFwTjMyWW9TNUhHcXNrVWg2bEdNeTRZVjF6aWkwdWZBMWpq?=
 =?utf-8?B?c25DdE1tZ3FKVzRqaExYSVJUWlF5d1liOWhwTFNZRHpyWTBXcjVCNUVYczNF?=
 =?utf-8?B?U2RjVXdqSE90anlYQW11T29wWUtxYWd2YnBpRnpJMDROenJIZWpEQkFIMXk3?=
 =?utf-8?B?U2ZLLzhQOWhFcUNzNjdVTFMyWTlVbHJCL3F4QldhNVZWN2xkUkwrb1dLUWxK?=
 =?utf-8?B?TGpCdExnZUo4N0NTYXFkRzRtejJXYVgzS2s4T0svZFBwNjlLYzArU1h4NllM?=
 =?utf-8?B?RkQ2aktETmRrcnR6Q3RURFZ2aWZLODVmVTdDZm1GVEhXOGZuWnU0MmNHaWVi?=
 =?utf-8?B?RDJnV1grTjhyV21uSExxMHBEUFM3bUNibUN5Qm1vZlFISWZxTjd4R3ZWVUVK?=
 =?utf-8?B?RnJQaWJwblg1TjYwb3JmUXg2eFQvMFJJdm44THN5bURnaTZORmZoQVJxdXJN?=
 =?utf-8?B?bGU1dktTKyt0ZlJGb214MEdjczA2QU56Q2lxZldxZmtqQ05PS3hjNUhlK01B?=
 =?utf-8?B?VWljOFlsM1JqbjVmdWVJamZxMi90SDQ1MDVlVnJ2NEN0YXdYcjBIdk5EU3VZ?=
 =?utf-8?B?Mjl1bTZiQUpZOVdFUS9YSk95WkZEeDlwd1FKM2dpcTRnSTJpdFptdytUZWNN?=
 =?utf-8?B?S2MzemxSSFlHWkRqU0xXZzd5cDM4b050WmtDR2lIU0duQk9IT1dYR3F1ajZZ?=
 =?utf-8?B?ZVpXT3F3OXE2cldQQlZTZkJCWmtTd0kwVXUvVXR2ZmVIcUFDUXpMVFpqRm9D?=
 =?utf-8?B?WnY2cjlsd1R5RWlBb0luZkpZVW4yOURtZVhwU1M4bXBFVTBLRnlGUTBrUjBP?=
 =?utf-8?B?SWNuS3hUM04xeHhPa1Q5c25lbk1nN0dhWXlsWU9yd3dySURHMjVPU2xia1pl?=
 =?utf-8?B?bW9YWmJTcFJWeUZLd0hqYjlUbnRGUG9qY2F6ME5jTmgxL3d4aVRKOEIvdXpz?=
 =?utf-8?B?N1VYa2J2QkJKNi8veE9WWlFUSTI2dGhDWlhBWlcrSnhDbUdEL2VJVEFxbE1E?=
 =?utf-8?B?KzNzOHpVeXF2RVVSWlp1UEVmeGZ6NHd6ZWptVCtGbVZ5OGplQytXajlrRnBC?=
 =?utf-8?B?NGkyQkxDRVZiMjRYWTFRWmQ5WnFwSWZONVhjaE8vamhBQzBML2NqK2ZIRVNY?=
 =?utf-8?B?MHVicytlNU9uMkhCMStSNzlqK3ZyTHhlQXAvUGFCT1M2anE0b3o2RURlM25s?=
 =?utf-8?B?NXpwMmc5YlNsbjVvemdUZ0tjYkwvL0NFRzJVU0Z6eEhWVU5ESTlSdz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL3PR11MB6484.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c7698f14-e4ff-4910-3ec9-08da5455bbf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jun 2022 13:47:22.8686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +xFm7A+nHV/Xm6NQFC55mCxlYyFY9AWRyHP0bbc1xgZrfvN/4QKdydZ0thBGKYYSp9pnGusqX9zzMitcRYp0tdfQ8ZSznd/X7ipjhsqb1M4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3440
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KPiBQaWNraW5nIHVwIHRoaXMgb2xkIHRocmVhZC4uLi4NCj4gDQo+IFRob21h
cywgY2FuIEkgaGF2ZSB5b3VyIFNpZ25lZC1vZmYtYnkgZm9yIHRoaXMgcGF0Y2g/DQo+IA0KPiBN
YXJjDQoNCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvY2FuL3NwaS9tY3AyNTF4ZmQvbWNw
MjUxeGZkLXJlZ21hcC5jDQo+IGIvZHJpdmVycy9uZXQvY2FuL3NwaS9tY3AyNTF4ZmQvbWNwMjUx
eGZkLXJlZ21hcC5jDQo+ID4gaW5kZXggMjk3NDkxNTE2YTI2Li5lNWJjODk3ZjM3ZTggMTAwNjQ0
DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvY2FuL3NwaS9tY3AyNTF4ZmQvbWNwMjUxeGZkLXJlZ21h
cC5jDQo+ID4gKysrIGIvZHJpdmVycy9uZXQvY2FuL3NwaS9tY3AyNTF4ZmQvbWNwMjUxeGZkLXJl
Z21hcC5jDQo+ID4gQEAgLTMzMiwxMiArMzMyLDEwIEBAIG1jcDI1MXhmZF9yZWdtYXBfY3JjX3Jl
YWQodm9pZCAqY29udGV4dCwNCj4gPiAgICAgICAgICAgICAgICAgICoNCj4gPiAgICAgICAgICAg
ICAgICAgICogSWYgdGhlIGhpZ2hlc3QgYml0IGluIHRoZSBsb3dlc3QgYnl0ZSBpcyBmbGlwcGVk
DQo+ID4gICAgICAgICAgICAgICAgICAqIHRoZSB0cmFuc2ZlcnJlZCBDUkMgbWF0Y2hlcyB0aGUg
Y2FsY3VsYXRlZCBvbmUuIFdlDQo+ID4gLSAgICAgICAgICAgICAgICAqIGFzc3VtZSBmb3Igbm93
IHRoZSBDUkMgY2FsY3VsYXRpb24gaW4gdGhlIGNoaXANCj4gPiAtICAgICAgICAgICAgICAgICog
d29ya3Mgb24gd3JvbmcgZGF0YSBhbmQgdGhlIHRyYW5zZmVycmVkIGRhdGEgaXMNCj4gPiAtICAg
ICAgICAgICAgICAgICogY29ycmVjdC4NCj4gPiArICAgICAgICAgICAgICAgICogYXNzdW1lIGZv
ciBub3cgdGhlIENSQyBvcGVyYXRlcyBvbiB0aGUgY29ycmVjdCBkYXRhLg0KPiA+ICAgICAgICAg
ICAgICAgICAgKi8NCj4gPiAgICAgICAgICAgICAgICAgaWYgKHJlZyA9PSBNQ1AyNTFYRkRfUkVH
X1RCQyAmJg0KPiA+IC0gICAgICAgICAgICAgICAgICAgKGJ1Zl9yeC0+ZGF0YVswXSA9PSAweDAg
fHwgYnVmX3J4LT5kYXRhWzBdID09IDB4ODApKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAo
KGJ1Zl9yeC0+ZGF0YVswXSAmIDB4RjgpID09IDB4MCB8fCAoYnVmX3J4LT5kYXRhWzBdICYgMHhG
OCkgPT0NCj4gMHg4MCkpIHsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAvKiBGbGlwIGhp
Z2hlc3QgYml0IGluIGxvd2VzdCBieXRlIG9mIGxlMzIgKi8NCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICBidWZfcngtPmRhdGFbMF0gXj0gMHg4MDsNCj4gPg0KPiA+IEBAIC0zNDcsMTAgKzM0
NSw4IEBAIG1jcDI1MXhmZF9yZWdtYXBfY3JjX3JlYWQodm9pZCAqY29udGV4dCwNCj4gPiAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB2YWxfbGVuKTsNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICBpZiAoIWVycikgew0K
PiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLyogSWYgQ1JDIGlzIG5vdyBjb3Jy
ZWN0LCBhc3N1bWUNCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAqIHRyYW5z
ZmVycmVkIGRhdGEgd2FzIE9LLCBmbGlwIGJpdA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICogYmFjayB0byBvcmlnaW5hbCB2YWx1ZS4NCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAqIGZsaXBwZWQgZGF0YSB3YXMgT0suDQo+ID4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgKi8NCj4gPiAtICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIGJ1Zl9yeC0+ZGF0YVswXSBePSAweDgwOw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgZ290byBvdXQ7DQo+ID4gICAgICAgICAgICAgICAgICAgICAgICAgfQ0KPiA+ICAg
ICAgICAgICAgICAgICB9DQo+ID4NCg0KU2lnbmVkLW9mZi1ieTogVGhvbWFzIEtvcHAgPHRob21h
cy5rb3BwQG1pY3JvY2hpcC5jb20+DQoNCj4gVGhlIG1jcDI1MTdmZCBlcnJhdGEgc2F5cyB0aGUg
dHJhbnNtaXR0ZWQgZGF0YSBpcyBva2F5LCBidXQgdGhlIENSQyBpcw0KPiBjYWxjdWxhdGVkIG9u
IHdyb25nIGRhdGE6DQoNClllcywgd2lsbCBiZSB1cGRhdGVkLg0KDQpCZXN0IFJlZ2FyZHMsDQpU
aG9tYXMNCg0K
