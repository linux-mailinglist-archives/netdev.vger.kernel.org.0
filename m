Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE0B55AB320
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 16:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237244AbiIBONO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 10:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238973AbiIBOMz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 10:12:55 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B068E1906
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 06:40:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1662126045; x=1693662045;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=SNoXGsC8w/88oZEPJ7ZieIzp9uUSvZoiPsQcLR2x4Sc=;
  b=fQKBlu743JAij0NA57s4ckxsCuGl6J6zZ8s+7+v0Yjis5EsqZudO32mZ
   bQYD9W9/nhjqTK5f2hgl3dGsOlBTuR/d1xxzd04ULRs7StcVbfx9ZDsCX
   TPSUAPrOcRzxg0HnVzT+LFqlpzVOnLKCQi0di1xk/S5mmI/lln/EVaoqb
   nHZXSIPmcbp5bvT9pkn5Sf6GfO1SHNkEbdEo1gXJtlQa/lSmddfIZRvxg
   4pAC+4y9lZ97AdGvfF6/iI0SrmLdIj9XB/WjdPs5eM5HE75laqukpiCmY
   OtUYQLhHsIxSLn1sAXjJ87QJhpMOfk0ZFLp/+057hWsO/ywEhiAkKy2QE
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="111932186"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 02 Sep 2022 06:39:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 2 Sep 2022 06:39:32 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 2 Sep 2022 06:39:32 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iORj/eZbDeruzb2erOpyQ+gkgIrox8cYfcgwhK5dnZrbuck2A+JuJK0eHRngW/ooamOFvz4OndA/CvDoQ/xTEhVZrd5SxOv8FfFOhTuqAKLS0eFW6Q9TyQ2wmzAiNuq1mj11wTG0IeZwfmXUFn7MaJWMB/3/JqHo13RiA4tW2omsQqxpbeOL8QD3wyrHgqdOApXI6LaydmUWXh/Xsww4RtRzNj/ARc2Zcv4FR7pB1j2Zc75mGszAxDmAv5VstQ3YOwBZdd1fHZETmYJVEqCENuavlY66wdigmIohZpxdZBpN8x/R/r5oGMF8ibYRSwVt9wLjYAONNMT0uPFp3hYO6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SNoXGsC8w/88oZEPJ7ZieIzp9uUSvZoiPsQcLR2x4Sc=;
 b=EibZZfwoxaCT23z7EPaiK9XDOHKlym+/rAjEyG5xxsib0FJp8LQJmGWMprNacjJJyALcrwDDY8csr57ewNzDy5ukiCNJ6/DnMKoOYmMPOUj+f4mBtTftapRGxzi10Q2BNSsJVb4BUl7sP7ijjuEC3KbrQEALr53WRGrf9Kze3HLfp4kdH3x65ZtBh+6PcLpyvZo4Ycr9rOgZcGHpc5dFPim80iAeYTWCOp+Ieroy8xY6mppjkHznxAIhohuiMY/N+lufH0NB4ep4h2W8UrZkHfzea4NpZttsiL4WgVqidBp1P/NzzRLfNqpyl3LYzi2EOVl4sWmdk7tOCE9C/Txhag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SNoXGsC8w/88oZEPJ7ZieIzp9uUSvZoiPsQcLR2x4Sc=;
 b=k8ZncOBh+ZxjpDtFOoUtx9KbC1TFpZaEkT2fH5kdDjFrBTTFQPmrYQU9sOs89KbcSCOSJjhZ4ooxEzEiMkXFOwVpX0EJQk7luQ2R8vQX5wtKya7GEiU3UwuIgTAVLzcnUNWK78JGnf54Mp08lPTCkxoQOcAiAuiRt1T5E8qnucg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY8PR11MB7108.namprd11.prod.outlook.com (2603:10b6:930:50::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Fri, 2 Sep 2022 13:39:31 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::3c5c:46c3:186b:d714%3]) with mapi id 15.20.5588.015; Fri, 2 Sep 2022
 13:39:31 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <romain.naour@smile.fr>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <Woojung.Huh@microchip.com>,
        <romain.naour@skf.com>, <davem@davemloft.net>
Subject: Re: [PATCH v3: net-next 2/4] net: dsa: microchip: add KSZ9896 to
 KSZ9477 I2C driver
Thread-Topic: [PATCH v3: net-next 2/4] net: dsa: microchip: add KSZ9896 to
 KSZ9477 I2C driver
Thread-Index: AQHYvrUYiHutkz2/5UOi7eYPad+xjK3MJW+A
Date:   Fri, 2 Sep 2022 13:39:30 +0000
Message-ID: <aa0c9a7b3384a69ce4b5be85673df479788d1208.camel@microchip.com>
References: <20220902101610.109646-1-romain.naour@smile.fr>
         <20220902101610.109646-2-romain.naour@smile.fr>
In-Reply-To: <20220902101610.109646-2-romain.naour@smile.fr>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4b515c0f-b414-47be-265a-08da8ce89070
x-ms-traffictypediagnostic: CY8PR11MB7108:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: pFI/JxJfoXeMU9MAe4zl1KVSRQPOe5s+5iXceW1lTROaGLUkQ24pTKFPw8gcpnm+OicR3hXtpBPdHgtX+OtJjITIZyAeq+0Xrzmdg6SEJxGYU+HEpbx6Dtwew8q5PPL3iSVKqNbrFoTWmWGj9NQrs/O7+EA4OOELmWpnuN17ENZ6c57ta49Aos7TwxzQflkoJFM3izhK+JVgqPa33/DhPC6U4KOY4L9ilWolz8eeJ7hGiWUCERdzQih25sCV3YFX/HByfqGZ/ADah9uWMrM2Qx4yX93J6o4s7NwiO16OpJqaGMH2e54TnY45giSmpw/5yi5pWMX5V88clTudHR1Tane4Y2bwPpwerx8vKxvI+hCWs7w30pbXiTYocDSCWztgDK58ALKM+ID0i9ZgjZ51CGqgLkVxCej97UV/y1RXZomRWll4iO6JlZfs6oHPn78OcjQgQBYEMQErvIJ44AQomApCy4gz8Zrd1Ck8OcovjsHDTPC8lpHw3AtUVjdmMtf+ZBOfWaY/03pdU6UWA7r5FNHOKXMzAqjvIHBRf0/xxCl5lVvlIHhG5G1k17K15sYqXPo5BFd3sDujY7Ud5Hi05oD+ozHbo+/Xi0aqcrZ57iD3kYu6Nj9hEIfvhSohxVpYwPMtRi/XVjx/9AaGqR1sS3oI/W2H0sfQ0X3MgBRJsaopMjwk2dqXawBxQ14l2i/kzQ2TwEmRrSbY8UBWWWsCfGziZsS0fOA37qjXkVNEnoVWJ+cEwPYHgm3T0I86WYOAT6ykKsTGLPk1JUkA+kTWkyM7/NpAD2XQ+XkDE2V8ry0=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(396003)(366004)(346002)(39860400002)(136003)(66946007)(8676002)(76116006)(66476007)(71200400001)(66446008)(64756008)(91956017)(316002)(110136005)(6486002)(54906003)(478600001)(8936002)(2906002)(5660300002)(66556008)(4326008)(7416002)(38070700005)(36756003)(38100700002)(86362001)(122000001)(186003)(41300700001)(2616005)(6506007)(6512007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWJscUxhbk16R1pWMU1GMEJjakRmQmxGUEE2TGlJeEl1K3JBUGFlUzIxMXZX?=
 =?utf-8?B?UXV2K3ZrL3BmZitSbUVIRi9zMGZMUHhRNzJ0eHkvNTJxblV5U1BETWg4SUpx?=
 =?utf-8?B?SmZ5aGYxa3R0OERLRDRFTmI2bzFVdW5oQlFxUVdVWFdhV21ncXNtaXFnVUd3?=
 =?utf-8?B?L2pJTTFNNy9XbG84SEcyTFJSQnZyUnpmL0hlRHdIMnNVclkwd1QrVElxd0o5?=
 =?utf-8?B?aFMxcFpxTm9McHNwSVdvU3BRV1IzZTJPTFQzRUpONkRHQUtGcytyY3RkMkU1?=
 =?utf-8?B?L09pcFVDTEFONDFwaHMrU0s1cVU3cFhVMTNsdFFwRzBNa1ZtRGhkMW5xc1Zm?=
 =?utf-8?B?aThSRW5tRUthOERXTzRsbFNxR0JKdFBDeVhIdTlYZ2lWMGlxZDRDVmZ1VXdq?=
 =?utf-8?B?UWpIQjliMzFReURnTU81MlI2M0dIUlJQNGxldCs0MWZ6OFBobFZIaDUrSzhy?=
 =?utf-8?B?VjNldmZpMTE0SkZGODV5MURibzJySmJaVzNPOGhwOGRtbjhOR0R3YWhZTStz?=
 =?utf-8?B?VEEySmtEckRJZ28zbmtOOEVCNHFWZVVwVXBQWWhteUp3bTNITWZDS2R5NkhD?=
 =?utf-8?B?V1IxOXZwcjFrRXZGZVhFQlM5L3IyWU15STFKNVowL2xRa3N5WVV3K0w2ZU5z?=
 =?utf-8?B?ZmNVMWdIUFFlbHhvQVNsWDU5bTd1TU5sZ2dicE01UlVZa3RkRzg0dzFPNjFN?=
 =?utf-8?B?NE9PVWNpbjdONGJrKy8vUzNzdEdkT3RVd2J6a2FHY3lFR1cwYS9yL2d0S2pm?=
 =?utf-8?B?MERlZG5JMkdnN29weFB2MlhLczlWZjN4VjJsWFIxcGlBZnhSbGxtdmdCS1Ja?=
 =?utf-8?B?N2RSa2lLTEY0aHNSNWx6elRtU1d0Z3BRT0YxOFJSUGxDNVlYUitoRllVTVFQ?=
 =?utf-8?B?NS9FWWhZODA4VkNVZEFlZEgzMlJrNWR0VzNUY0RYZVEzaUN5MkhNWGdXUUVx?=
 =?utf-8?B?cEQ5UVppVS9lQUZFMVNRSnBUNTh1QlF4YWZjY2IxQVE2WkFDdmpweFpyYVFQ?=
 =?utf-8?B?ZllLNGdwcWxTRXpuQ3llQW1WSVVla0NvTys5T2ZWRkU1ejFmREVVN2l6Z3Yr?=
 =?utf-8?B?QzRHRWhTZmVHZEYyRFNjUk01SmNXUUUyMWd3aTd3NW4xWlE2SEtVQzdsWVkz?=
 =?utf-8?B?VnpDVisrTVJFcm42WERIRkFTaDlhdnIwNHZLYlRZd3JnVUdHU2xkK041Yi9U?=
 =?utf-8?B?STZIN0h2TUtWZC9kSDBaYWJjM1hkS21GMkxpTzg4T2xHSDNEb05YQzU5WjNa?=
 =?utf-8?B?aFNiTWpoWC9JWHcxTHpIdmRTaUg5OUNmeEtTMk9QUWxYdWpNYUtkMEMvL1J1?=
 =?utf-8?B?dHZ4ZDdVcEhGL2QzZXBvUXF2OGV2d1FvR0IwVlFsc25xNHR2ODVmQ01ESWpX?=
 =?utf-8?B?R3d6bzdTY0s0eUg5Y2RGOVludUZnQUtSL25XT1l0bGMwZGlabjlleHlCbzNT?=
 =?utf-8?B?VnFMNFlYWGh6SHVoaXZoamFrZ05iRmI5SXQ5bEZNVFNsZU5tU2xTbGdGZ3hx?=
 =?utf-8?B?STgwaWlzc0xjVFV1S3BxVGhJdjZYUFFsZ2xyUDM4Vkpkc0JkNHVocWtJNWdD?=
 =?utf-8?B?VXVxNXB3U3ZWMzgrcWp6cVJMWlFFU3BwL1hvMkZVcjJydktTeWV3RXZVeFY5?=
 =?utf-8?B?Mnl4REJOcm96Y0xNeTJoamV6SHJlZUFkRVY5dFZ4di8xZmN5WFBSaGsrOXQ4?=
 =?utf-8?B?RGprdEtFRHNXTHV5c2ZodnlFdGt6QlM4dWFtdCt3d0NrZFhqbllUdTU0MFAy?=
 =?utf-8?B?YTBVZ2YyMUlUOEhPYzIzbTJHSjB6Q3l1bG9HYkdGd05DUThhckxIdys0N1g3?=
 =?utf-8?B?WjJDQ3JsVFBLc1ZnSnIyanhKaHdobGVvWklDR3hpOHB6VGozVVZHS09lK2tP?=
 =?utf-8?B?UjlURzRpNUFkWTZvUFAwTVMwY1NiVWwydnpIMkFhb3B0SDAvQ3BjYWJsK05w?=
 =?utf-8?B?TEdkYWZQSlJRMzBXYlowRnBtaXk4WGpqb0R5OTR0bXlISFFQK0N0UjM4TENY?=
 =?utf-8?B?VDhVbDZ2QUw0VFhVMW5BZGxpbWtscGRlMHBEYnlZQUtUdFFMY3BSUmVCSGhB?=
 =?utf-8?B?NTNkeEt5RjhnVTVFTW1HNzhHeFhrU2NLWEc3eDJCTGVxWkVyWU55Sm9KRlFO?=
 =?utf-8?B?QTVYUk1QVmlDeXpjRUZUdGVRNzVZTldzQXR0dHFEL2ZMVmg4K2ZLa2VlcTBk?=
 =?utf-8?B?ZTNrK3Nta3o0Z0lkaXJoN2dLVjcreVYvWnV6R2JDOHU2ZGJFeFdBNi8yZ00r?=
 =?utf-8?Q?Eh9jARbWMHaE6/iSO45CzJ75aeLDT0oHfR3epkEs7E=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <9CA09B2E8752B848A84F21C18F861943@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b515c0f-b414-47be-265a-08da8ce89070
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 13:39:30.9448
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5AzA/hSTyv9NOyfoY3HbufevI4jkuYkyJr5XyzemgTCfCIY3RyGt0YzX60g9GpY9NidJ2hkKNO+BjEcNEh0nYQqHIJh3XAGHb7umcSPnbAQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7108
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTA5LTAyIGF0IDEyOjE2ICswMjAwLCBSb21haW4gTmFvdXIgd3JvdGU6DQo+
IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gRnJvbTogUm9tYWlu
IE5hb3VyIDxyb21haW4ubmFvdXJAc2tmLmNvbT4NCj4gDQo+IEFkZCBzdXBwb3J0IGZvciB0aGUg
S1NaOTg5NiA2LXBvcnQgR2lnYWJpdCBFdGhlcm5ldCBTd2l0Y2ggdG8gdGhlDQo+IGtzejk0Nzcg
ZHJpdmVyLiBUaGUgS1NaOTg5NiBzdXBwb3J0cyBib3RoIFNQSSAoYWxyZWFkeSBpbikgYW5kIEky
Qy4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJvbWFpbiBOYW91ciA8cm9tYWluLm5hb3VyQHNrZi5j
b20+DQo+IC0tLQ0KPiBUaGUgS1NaOTg5NiBzdXBwb3J0IGkyYyBpbnRlcmZhY2UsIGl0IHNlZW1z
IHNhZmUgdG8gZW5hYmxlIGFzIGlzIGJ1dA0KPiBydW50aW1lIHRlc3RpbmcgaXMgcmVhbGx5IG5l
ZWRlZCAobXkgS1NaOTg5NiBpcyB3aXJlZCB3aXRoIHNwaSkuDQo+IA0KPiB2MjogcmVtb3ZlIGR1
cGxpY2F0ZWQgU29CIGxpbmUNCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tz
ejk0NzdfaTJjLmMgfCA0ICsrKysNCj4gIDEgZmlsZSBjaGFuZ2VkLCA0IGluc2VydGlvbnMoKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfaTJj
LmMNCj4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfaTJjLmMNCj4gaW5kZXgg
OTk5NjY1MTRkNDQ0Li44ZmJjMTIyZTMzODQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2Rz
YS9taWNyb2NoaXAva3N6OTQ3N19pMmMuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzejk0NzdfaTJjLmMNCj4gQEAgLTkxLDYgKzkxLDEwIEBAIHN0YXRpYyBjb25zdCBzdHJ1
Y3Qgb2ZfZGV2aWNlX2lkIGtzejk0NzdfZHRfaWRzW10NCj4gPSB7DQo+ICAgICAgICAgICAgICAg
ICAuY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsa3N6OTQ3NyIsDQo+ICAgICAgICAgICAgICAgICAu
ZGF0YSA9ICZrc3pfc3dpdGNoX2NoaXBzW0tTWjk0NzddDQo+ICAgICAgICAgfSwNCj4gKyAgICAg
ICB7DQo+ICsgICAgICAgICAgICAgICAuY29tcGF0aWJsZSA9ICJtaWNyb2NoaXAsa3N6OTg5NiIs
DQo+ICsgICAgICAgICAgICAgICAuZGF0YSA9ICZrc3pfc3dpdGNoX2NoaXBzW0tTWjk4OTZdDQo+
ICsgICAgICAgfSwNCg0KRG8gd2UgbmVlZCB0byBhZGQgdGhlIGNvbXBhdGlibGUgaW4ga3N6X3Nw
aSBpbnRlcmZhY2UgYXMgd2VsbCwgc2luY2UNCmtzejk4OTYgc3VwcG9ydHMgYm90aCBpMmMgYW5k
IHNwaSBpbnRlcmZhY2UuDQoNCj4gICAgICAgICB7DQo+ICAgICAgICAgICAgICAgICAuY29tcGF0
aWJsZSA9ICJtaWNyb2NoaXAsa3N6OTg5NyIsDQo+ICAgICAgICAgICAgICAgICAuZGF0YSA9ICZr
c3pfc3dpdGNoX2NoaXBzW0tTWjk4OTddDQo+IC0tDQo+IDIuMzQuMw0KPiANCg==
