Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662D65B6C19
	for <lists+netdev@lfdr.de>; Tue, 13 Sep 2022 12:58:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiIMK6p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Sep 2022 06:58:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231883AbiIMK6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Sep 2022 06:58:16 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BA05FAEC
        for <netdev@vger.kernel.org>; Tue, 13 Sep 2022 03:58:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663066681; x=1694602681;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=cQblezuNd9pC1GOkGdc8ZC22UgevVfBv8h21d12CO8Y=;
  b=fwBRxjWPE83GK8jqpkW0UG+2+tDxnHqZgkREeaEikReA/1p7O1VNdBQe
   g1vzMp4sd095bPd1Tb8wZNlSsd4ZQoIXgirgD54S3oB724n/HMVEDiNvJ
   qM/IjnLyHsqNmzNho+ivZGivnSl2RH98Buk2ByeSQMclimwOh2NxZtxst
   NVKwekJAyNJfy/VGb+NVx5leK3fl/3xtA5pRoqtSMeinirRj7LZgAEjMr
   +x6qpgiNBUrTtuWeijEon3UAxLKH2dzWHzJ+6SnT6glCmbFVIkgNpxDUu
   cquE8mDkFqVjMKRDli3zInrGZfvG4sP3g02EcIEyVJof/mrP4h7i05a08
   w==;
X-IronPort-AV: E=Sophos;i="5.93,312,1654585200"; 
   d="scan'208";a="113410970"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Sep 2022 03:57:49 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Tue, 13 Sep 2022 03:57:46 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Tue, 13 Sep 2022 03:57:46 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxwVX3wnBGYiL5ddo6xDyOHmzVwv0BE1JyjNfGxIaLDurVYRSeponQSmaYWGceb3RNX0nE00p0EetdFrSmL0DKAdPXZ4odmo7dSyptz43Np9v+9rmWUt0M/22HRnMJuNPX+//y6pfyyx5ZIVsX++5kGZX+Vr8PGOmkLP9dIbZi+WVssvjCuhSNuV5jiekxcjOssBuLqQeZ9bNTmBc1mnymt98qefeh6yX338hmtIPf9dD5rl4qm442QQjjminW48ZkT2PRXyjZoYuUhHpepK/4nHP/ksOqi6L4rOaHMMe224EPKEgVFC/IxAxheTpMw6V7mw8fHX7QT4kuNBMU6PYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=cQblezuNd9pC1GOkGdc8ZC22UgevVfBv8h21d12CO8Y=;
 b=KjMjWWcDQ3xnBx6cwe7H8wJYvBTtKUXd+sSy+/0+2e8iQHwa/JQt8WXZSBONR0MLPP/XHfViZvrU/hG1vI4CE7vnTe+wfDblBMhoNg0TEvwusQv50YYnoT5wU5dp4VqFISpmRkv2FMM7R/4uIqnoMKgGA4ZvJ94PvnResd3lcav+NFKCpJR/uzfBbAmP9LSPAJgs5jV3Z/Wyl6UyMKQSQaHk1JALP+ohgOZEGtec5ZhTQ0dSmKe7LdY4dwOo1tGXzkDSEe5MXH0MQXG1Y7o7WeYZ7mP0Tehw0s/4h1EX9nEZtG7pLPp1Z4nWD35k98nayBStND31U7+RHeBgmvSA9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cQblezuNd9pC1GOkGdc8ZC22UgevVfBv8h21d12CO8Y=;
 b=MvcFdLkh2Bk3ssgJHfcGELoWLA3qD9hJJuJlSX8CSm3OAOuvyKhD83Dk3vozc2G3n0lDnE1pmW084ojeHnnuWEOTEDNSTbrLX/LkQfrORSGsd288YmIMaXG83Ona6VSWUon3b6uYWTn/zYBAcXUcyKfeqId9dINawFkZ+j6y274=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 IA1PR11MB6170.namprd11.prod.outlook.com (2603:10b6:208:3ea::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Tue, 13 Sep
 2022 10:57:44 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714%3]) with mapi id 15.20.5612.022; Tue, 13 Sep 2022
 10:57:44 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <vladimir.oltean@nxp.com>
CC:     <claudiu.manoil@nxp.com>, <UNGLinuxDriver@microchip.com>,
        <alexandre.belloni@bootlin.com>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <idosch@nvidia.com>, <linux@rempel-privat.de>,
        <petrm@nvidia.com>, <f.fainelli@gmail.com>, <hauke@hauke-m.de>,
        <martin.blumenstingl@googlemail.com>, <xiaoliang.yang_1@nxp.com>,
        <kuba@kernel.org>, <pabeni@redhat.com>, <edumazet@google.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Topic: [RFC PATCH net-next 3/3] net: dsa: never skip VLAN configuration
Thread-Index: AQHYkJVA+iLppAy/uE2cW1NrBQONVa1xiwcAgAADhICAADWVAIABvUGAgADAlICAACQggIAArH6AgAiqEgCAAEpdAIABMNoAgABliACABKhtgIAAHsCAgAx97ICAACSgAIBLUNeAgAADfICAAUKwAA==
Date:   Tue, 13 Sep 2022 10:57:44 +0000
Message-ID: <66fee4c617dc073ce355addd19a9543cd1b344d8.camel@microchip.com>
References: <CAFBinCCnn-DTBYh-vBGpGBCfnsQ-kSGPM2brwpN3G4RZQKO-Ug@mail.gmail.com>
         <f19a09b67d503fa149bd5a607a7fc880a980dccb.camel@microchip.com>
         <20220714151210.himfkljfrho57v6e@skbuf>
         <3527f7f04f97ff21f6243e14a97b342004600c06.camel@microchip.com>
         <20220715152640.srkhncx3cqfcn2vc@skbuf>
         <d7dc941bf816a6af97c84bdbb527bf9c0eb02730.camel@microchip.com>
         <20220718162434.72fqamkv4v274tny@skbuf>
         <5b5d8034f0fe7f95b04087ea01fc43acec2db942.camel@microchip.com>
         <20220726172128.tvxibakadwnf76cq@skbuf>
         <262ef822025a205b1b4975c967cc5e5bd07faa16.camel@microchip.com>
         <20220912154244.azn3roke3rxyqdcb@skbuf>
In-Reply-To: <20220912154244.azn3roke3rxyqdcb@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|IA1PR11MB6170:EE_
x-ms-office365-filtering-correlation-id: e2f78d6c-941d-454b-0b3c-08da9576c95e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: i55ynxNxn3a/aX/TemwnlAOLc7WNkUjw9q6HDlUBjAxjSsBDU9aC0gU0qBBDecMbVsphI7SwKClXccbdPTjz6pJZZE4jQQng9GmN0bRj0sQKbSVTgCXMlSGyCaN0Eq9gM9+9M8Tl6cUjEjZOPxOK6TU10RQo6/DXDqJ4dUKMw5KIH/Ow6F9/2clubLe7j0HBXKUYs1TewdeL1G63O4zdeoEG+/9JVzhdy9YhGf5MwHklCMKunXKWW33Cv1o9TomehNHD4IMeMYNOzF2cw8aVmmK19v91BtJwufKhnNNQcVDaUOTYgf8xwpxEzIJOuMDUw0BveKiwsexkwID+Fh333F0Y6wWMKIQ3gXDInUTowuZdbqJXmqezHedaVJ4EUrYwABwVqfXLaQlWPg6mBm4++CCy9Z2sBUBajNo/5Bl1B2EAZh8HnIoX3aNbCbMRYEk7+eP63wq+WY7ushmxmTS5h0v02nK+qrrJF2sRDoxbaINAeJSOy8kZkBs7ABi6G+A50PorXnNy7zZubTGdB3epubI1vsjWVcNnc/c+goy5W8ep0xcphWdXFWX/rHX/g3k1ypIjQyuX7Gg1sPLxMtPRQtTuElxfHZsDjPa9YgzfviO+J6uEug1VC6533t03lUlAg6hq8JaTd+5N9tnNeqmmLr5C10VRNkTJCTwii5dPoe4fL5/ZEEtG9J6UE2jN+PGfldsq1HV4VQuQVoq91gHf42l2K71tCjfhsZcczTjEPdhQpVeMNlqlQdUaq/bCn5q5RrimtREcGbBt/OdDi+NaDgSQec27LAO1sk2FO+eKdng=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(39860400002)(366004)(396003)(451199015)(83380400001)(64756008)(8676002)(66946007)(66446008)(86362001)(122000001)(76116006)(26005)(38070700005)(66476007)(38100700002)(54906003)(36756003)(41300700001)(66574015)(6506007)(2616005)(6512007)(4326008)(2906002)(91956017)(8936002)(6486002)(186003)(6916009)(478600001)(316002)(66556008)(71200400001)(5660300002)(7416002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NE9scWZpOHZkRnUyd0xWNm4wZG1LODNucGpTZ3B4c3hsUXNwRy8wOSsvL2NM?=
 =?utf-8?B?Y2pUL2NUQnNxZ3VnTzJmb05NbkNaMytLZVJVeUJ1T3I3MkRUcW16cW9wRjFx?=
 =?utf-8?B?SFc1MGoySDNORGJYbitzZmd5MFQwZi83dmxQRkVLYmRpQndkZ2hob2lRdDNM?=
 =?utf-8?B?aVRzRUs1Q0ttSWVac3RnWHcxMFhtUnVWcy9VajVLUDdHZWJpSXRsYjN2WlVY?=
 =?utf-8?B?dWZrUVNkcFNnVEZiNGJDSm9Bd1VlQS9XMnpmSFZoRHdrL1JTQlJmV2daUG5P?=
 =?utf-8?B?by9manZJbkh4alljQ3ovTUY2Z3ZGZFNFbUQzMXJVRTJ3OUswMDRBN2VXL2xX?=
 =?utf-8?B?U1N0WWU4OXV6TjRjM2ZqRFA2NjNhZnJiMzVVWTZxcDBTWDVrMGdyM3BmUHRy?=
 =?utf-8?B?ZlJySlpCL1AwL055Rjg0Qk1zWUZsUmxES3crZm9maXFrOVd4Y2l5UUJad3Za?=
 =?utf-8?B?Ung2V0MrQ2Q4STRUekYwcUJUNnVqVTFEc3VQeHdoZEswbVF6OGtKenpiK0ZE?=
 =?utf-8?B?RzByK2pyT1hNZjI4MW03M2orbUZ5a3FSeDBXSDBvT0srT1BxSjJ1aUVzazZi?=
 =?utf-8?B?NEt6Qyt0S1hkSVJDR1NSbWNkYnVOS3NJTFZuK3JERkhWSEZsZVIwSTRwSStm?=
 =?utf-8?B?WTVOSmVjV2hsVHh4SGRLMzFvQXA2ZktudGZuSUxGQUx4dEJIcllad0V4NmFF?=
 =?utf-8?B?VXp2YS9jRjNQeUdqZVhpVXVIUnJjVG5ocmpqY1dqRXRGOXBEbzNaaTJDRzJF?=
 =?utf-8?B?c2NFdERtSzJ3QzEwb0grcXNESm9LOEZjcncyMUt3OHlvQjcrWTVKcHRVN1Zm?=
 =?utf-8?B?SHNESXpTSkp1eXhxeWU2K2VnRUV2RzNXOWtIT21LcVQ0K2JxRFlmdXNJbGVJ?=
 =?utf-8?B?WHJaZ0E1RWRiUWtXZk5rQjB0MGEzSlgrUTZaSThEYzFYSVNBZDJkVnpLOXN2?=
 =?utf-8?B?NFFDOGZoaDJaWUdxeGJxaTZ1N3F6aXYwWlBRTjBhTmh6S0RuWUFMSFVQRk9U?=
 =?utf-8?B?OWxNV2hON1lRSVV1Wkk4aExPTGcwTFQ2cUhaUHFZUE85bGlUc0N6UjN2ek5C?=
 =?utf-8?B?Q1RIVzh2M3NtSkpGdWFONDFLeXdWSVR5ZDRuQ0FMcFNaTnVBN3g3ZG9WVnE3?=
 =?utf-8?B?TStzTFNPMzFRQit6YkdiTGVMdlpHR3U5azBYUk4zREZiZ1pXS3Z4ODFMU3Ux?=
 =?utf-8?B?Q1J4WHBWclhiRkphMzdlZmRMZjNFaG5DNE5STG1RRFBhSnRNcllzTGpuQlp2?=
 =?utf-8?B?Skw1Q3BQZEVINTdBdkltWko3U1VVRVlrTnlZOWJOTldWNXFMRXZaT04zekxY?=
 =?utf-8?B?UVJVY01WajlIbU1QOVIvSjZFQndqKzJmaG10UWxucFNXVk8vZit0ZjhPcFpq?=
 =?utf-8?B?Rzk3NXYzMUJFckFxdVRwWkpBYnB0R1R1Z0NYQTB1OVNWY215Z2FWbVpIdlEx?=
 =?utf-8?B?OWVSc0IrL3B4SGx1dHFuSnI1M2hERkZxS0Q0STNGQkNIU0pwS1piaFNRRVV4?=
 =?utf-8?B?eWFtVXNzV2Q0eG91L0JKNzl0aWpkbE1YWkpJa3UvMWtZSVhJSjVFbWpyQXdt?=
 =?utf-8?B?SVlCbEZVanVrRklVdnlVS0RxU3loL3NUeTl1L3g5R2pRT2o0a0Mrb3NPa2Qr?=
 =?utf-8?B?Y3UySi8zeVJWbWJtQTFuUmNUSkdKZ0hveTM0VURvaWhSODN2ZSs4WSs1RCtv?=
 =?utf-8?B?ZUJCNUdoaytFR2ZJVzBQNVJpWDJubXg1b0U0Y3lrRWZxcTVzYXd5ZTJTbVMw?=
 =?utf-8?B?YWtkRWkyQUp1N1NzUjQ0Q0NoVlhLeFFZbk81a0FxL0h5dWtzeHNubS8zSHUz?=
 =?utf-8?B?RDcyQ1JwK1RKdytudHFibS9BSjRuOVpHV0k2TXkxeTk4MkQ1WkpEb0tjRlhQ?=
 =?utf-8?B?c3ZZKzRaSjVzQmRTVldPK1JSYWdDdDVUVHo5bUUvQURYZ2cwa2lHQm9IMjU4?=
 =?utf-8?B?OHNVYVdQeC8wd3RCTzg1VjNDS0VxYkZ4SWQ0dWIzZmV4L3laY2FPeUt6Vlg0?=
 =?utf-8?B?cXIrZ3NKaUF1S3ZJZ0NiTzFrNWgzSEs2QWxvM1JiN3JHS3ZNWE50TU1hRGc3?=
 =?utf-8?B?WkVzZmJiWitna3RzclY3L0dMRlpHQU96NDFzMWgzb21zZnRpeHdTekZxUXBn?=
 =?utf-8?B?NFEzTW1BNEd3Y0xxeE1vanhRUndsRUM4R3gyazNlS1p0V0hXZTR5K0FqK1hv?=
 =?utf-8?Q?kUMw5LJjz9MfJQ/U4rdp6Fo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <410B55BBA47A724CA6663F9DC1E4DCCC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e2f78d6c-941d-454b-0b3c-08da9576c95e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Sep 2022 10:57:44.2784
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oF+8pfk4kyNeGPW/RGC9+1VVPFfSmAJb1Zs9GTpt/jptGfWUdvAbj9+JwOsJ6Gtegbf2jsKXgsULwYEfqC1iaSoYgbI5x49g/7IkACVh17M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR11MB6170
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQpUaGFua3MgZm9yIHJlcGx5Lg0KT24gTW9uLCAyMDIyLTA5LTEyIGF0IDE1
OjQyICswMDAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBu
b3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhl
IGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMDM6MzA6MThQ
TSArMDAwMCwgQXJ1bi5SYW1hZG9zc0BtaWNyb2NoaXAuY29tDQo+ICB3cm90ZToNCj4gPiBPbiBU
dWUsIDIwMjItMDctMjYgYXQgMTc6MjEgKzAwMDAsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4g
PiA+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+ID4gPiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gPiANCj4gPiBI
aSBWbGFkaW1pciwNCj4gPiBJIGFtIHRyeWluZyB0byBicmluZ3VwIHRoZSBrc2VsZnRlc3QgZm9y
IGJyaWRnZV92bGFuX2F3YXJlLnNoLCBpbg0KPiA+IHRoYXQNCj4gPiBJIGFtIGZhY2luZyBwcm9i
bGVtIGR1cmluZyB0aGUgcGluZyB0ZXN0IGFuZCBhbGwgdGhlIHRlc3RzIGFyZQ0KPiA+IGZhaWxp
bmcuDQo+ID4gDQo+ID4gI2lwIHZyZiBleGVjIHZsYW4xIHBpbmcgMTkyLjAuMi4yDQo+ID4gQ2Fu
bm90IG9wZW4gbmV0d29yayBuYW1lc3BhY2U6IE5vIHN1Y2ggZmlsZSBvciBkaXJlY3RvcnkNCj4g
PiBGYWlsZWQgdG8gZ2V0IG5hbWUgb2YgbmV0d29yayBuYW1lc3BhY2U6IE5vIHN1Y2ggZmlsZSBv
ciBkaXJlY3RvcnkNCj4gPiANCj4gPiBJcyB0aGVyZSBhbnkgY29uZmlndXJhdGlvbnMgbmVlZCB0
byBiZSBlbmFibGVkIGluIHRoZSBsaW51eCBrZXJuZWwsDQo+ID4gY2FuDQo+ID4geW91IHN1Z2dl
c3QvaGVscCBtZSBvdXQgaW4gcmVzb2x2aW5nIGl0Lg0KPiA+IA0KPiA+IC0tDQo+ID4gQXJ1bg0K
PiANCj4gWWVzLCBxdWl0ZSBhIGZldywgaW4gZmFjdC4NCj4gTm90ZSB0aGF0IEknbSBub3QgcXVp
dGUgc3VyZSB3aHkgaXQgc2F5cyAiY2Fubm90IG9wZW4gbmV0d29yaw0KPiBuYW1lc3BhY2UiDQo+
IHdoZW4gdGhlIGNvbW1hbmQgYWNjZXNzZXMgYSBWUkYgaW5zdGVhZC4NCj4gDQo+IFRyeSB0aGVz
ZToNCj4gDQo+IENPTkZJR19JUF9BRFZBTkNFRF9ST1VURVI9eQ0KPiBDT05GSUdfSVBfTVVMVElQ
TEVfVEFCTEVTPXkNCj4gQ09ORklHX05FVF9MM19NQVNURVJfREVWPXkNCj4gQ09ORklHX0lQVjZf
TVVMVElQTEVfVEFCTEVTPXkNCj4gQ09ORklHX05FVF9WUkY9eQ0KPiBDT05GSUdfQlBGX1NZU0NB
TEw9eQ0KPiBDT05GSUdfQ0dST1VQX0JQRj15DQoNCkluIGFkZGl0aW9uIHRvIGFib3ZlIGNvbmZp
ZywgSSBoYWQgc2V0IENPTkZJR19OQU1FU1BBQ0VTPXksIHRoZW4gdGhlDQphYm92ZSBlcnJvciBt
ZXNzYWdlIGRpc2FwcGVyZWQuDQpCdXQgdGhlIHBpbmcgaXMgbm90IHN1Y2Nlc3NmdWwuIA0KDQpJ
ZiBJIGNoYW5nZSB0aGUgc2V0dXAgbGlrZQ0KTGludXggbGFwdG9wIDEgLS0+IERVVDEgKExhbjIp
IC0tPiBEVVQxIChMYW4zKSAtLT4gTGludXggbGFwdG9wIDINCnRoZW4gcGluZyBpcyBzdWNjZXNz
ZnVsLg0KDQpJZiBJIHVzZSB0aGUgc3RhbmRhcmQga3NlbGZ0ZXN0IHNldHVwIA0KbGFuMSAtLT4g
bGFuMiAtLT4gbGFuMyAtLT4gbGFuNCwgcGluZyBpcyBub3Qgc3VjY2Vzcy4NCg0KSSB3ZW50IHRo
cm91Z2ggdGhlIGNvbW1lbnRzIGdpdmVuIGluIHRoaXMgdGhyZWFkIHRvIGJyaW5nIHVwIHBpbmcg
Zm9yDQpvcGVud3J0LCBpcyB0aGF0IGFwcGxpY2FibGUgdG8ga3NlbGZ0ZXN0IGFsc28uIA0KDQpp
cCBuZXRucyBhZGQgbnMwDQppcCBsaW5rIHNldCBsYW4yIG5ldG5zIG5zMA0KaXAgLW4gbnMwIGxp
bmsgc2V0IGxhbjIgdXANCmlwIC1uIG5zMCBhZGRyIGFkZCAxOTIuMTY4LjIuMi8yNCBkZXYgbGFu
MiANCmlwIG5ldG5zIGV4ZWMgbnMwIHRjcGR1bXAgLWkgbGFuMiAtZSAtbiBwaW5nIDE5Mi4xNjgu
Mi4yDQoNCkkgYW0gc3RydWNrIHdpdGggdGhlIHBpbmcgdGVzdCBicmluZ3VwLiBJdCB3b3VsZCBi
ZSBoZWxwZnVsLCBpZiB5b3UgY2FuDQpnaXZlIHNvbWUgc3VnZ2VzdGlvbiB0byBicmluZyBpdCB1
cC4NCg0KDQoNCg0K
