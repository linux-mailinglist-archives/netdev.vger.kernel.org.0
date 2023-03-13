Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 324B26B6F99
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 07:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCMGrB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 02:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCMGq7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 02:46:59 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2255E48E3E;
        Sun, 12 Mar 2023 23:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1678690016; x=1710226016;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Ka2XxIyV+HGdQABPaSeZS75ymvM3FEoLMg9AEtA09bc=;
  b=gmGQ9FocSE6s7/J9y+d+W1GAnfLKlC2i/7Z1gYglzoIrcTPUktngLu3h
   4UoyeYUIYaVGbFYauGQYjwFYn3PX8U89Ol5UqDokes/pFomGB1QQ8ABeH
   isDpdaV0mH3ZrjNt0TnZTVaArnfrrVz3BcLpNl7oja41+5r0OfJd2BDXL
   UDItlZJwGkGFOiNEvTeqzsNCA+uvU3gr8x5zJGFzdF2203ASduwalSkYt
   TE6eulDAulb8bxlzAuVeYEGxeydb+lJ1BMWy6DZI4pF2kK1mYIjNPqTHU
   zTTsM0+yMhEIeuVSgMW9RPhSSi8xuYjhGLfPRr16b7WnP7eg4kO+DGv2p
   A==;
X-IronPort-AV: E=Sophos;i="5.98,256,1673938800"; 
   d="scan'208";a="201296430"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Mar 2023 23:46:54 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sun, 12 Mar 2023 23:46:53 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21 via Frontend Transport; Sun, 12 Mar 2023 23:46:53 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=F2KhqPf59gZn0HADPdTz8Ho6qSouIpy6Ov7fs/HWuJS5pLuGC28tqs+TDY+oDMEjIXPjkM5injK31K6p/6UDpJNAxW7r2JJ5EU9JH6z13pGClWsLy4mJ0PWFgsIT2mDW4tudxoWfaWXx2ntnnx+hdswun8liWMrG9V5wZxWId9+Un8q2VoCP3SVljIYWBKNHcy5S2C4fkW6zVIcpkFbG6iAdGVIKOCjm99oZZXoGahthrOawgbIDtUadeiQXfSkdnH0xtMmwuIsC8JNoJEPH9wHUm99XKwgXXBANURKEv4IXljlVGxekV3zfS5uNGYp3WkWkmUEZGDEgW0wPQtiDAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ka2XxIyV+HGdQABPaSeZS75ymvM3FEoLMg9AEtA09bc=;
 b=cXOu1M/Pw1qNoDpYCQSjqfQ78aEFWu7ZcSVpVPhkDbVD23QV1LlHCb5rA2Ds106r4odzMkJx18XSaulDMkaXHXd3b32jV+DGDXaCkXAiFAmm0ftgrrD/Cg56xLGTWxtrngA2vXw1fG42ozsc5skfN45E0wWiJogHD/iNvDetsL3bd251yAzXp/GG43m7OMc0sgu+7lRNfxZuostCG7nRtA4DfqXT9xnsFwqITNM0LLsHTtU1bgcK3aRmqtHl+WEQm4FhUhVsPFl+2a4OmvfEJ6ZnuCVG0axXULT7yC1aWrHFlgBacypq2sr9m8wiBZ7Ncl9WIa1DrYJcVQZZcRspdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ka2XxIyV+HGdQABPaSeZS75ymvM3FEoLMg9AEtA09bc=;
 b=mz64j32lS2d53P6nRktqlyZT8+YS0SK47IytwUVxvxOENXFvaJKViUax66oe8zoLw2VVc9EpXEkOq7EZG3KgIBkILH2MP/q2oM8sium6zFC54Ceq0HvUw0BiYlGnRJJSqwixuQuCBZnH9gjwcRoA7+fBSY61f+rXcw2tnAJiZo4=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM4PR11MB6382.namprd11.prod.outlook.com (2603:10b6:8:be::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.24; Mon, 13 Mar 2023 06:46:50 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::cbd2:3e6c:cad1:1a00%3]) with mapi id 15.20.6178.025; Mon, 13 Mar 2023
 06:46:50 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <o.rempel@pengutronix.de>
CC:     <olteanv@gmail.com>, <andrew@lunn.ch>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <netdev@vger.kernel.org>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v3 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Thread-Topic: [PATCH net-next v3 2/2] net: dsa: microchip: add ETS Qdisc
 support for KSZ9477 series
Thread-Index: AQHZUy//xI4vRrArI0eXiyVZdC83n674EwIAgAAiCYCAABPFgA==
Date:   Mon, 13 Mar 2023 06:46:50 +0000
Message-ID: <42e1c1fe287d7109e0a9c2d2d3f83fde6181d04e.camel@microchip.com>
References: <20230310090809.220764-1-o.rempel@pengutronix.de>
         <20230310090809.220764-3-o.rempel@pengutronix.de>
         <1b07b82f8692f5eb5134f78dad4cbcb3110224b2.camel@microchip.com>
         <20230313053607.GD29822@pengutronix.de>
In-Reply-To: <20230313053607.GD29822@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|DM4PR11MB6382:EE_
x-ms-office365-filtering-correlation-id: 9acca11c-4830-4013-aed9-08db238eb96d
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GHkNRXuTyv4/R8OXL2sqzxxAuvrfjFqI2HTCBmbPkbvCRZuuC2574ifcW+zxD6dURm2XquZFrZ66FHg6nBex6M8184u7c1dBEZQvGqpIe6aZEZdCES6uNfOy8lmnL2WDs/kBHqETDNF4oczYcQEnWmcaSEwkGVmvR5j8EyfHq+sCUFYhYN8x/hTzdaj58qvQaeNALiA2AOKrLUGxVUsZUhh1R7lXDjcDB5/mH9cPquh0EH3Fc6N/JmVYDv81F6YciYRaswvL6euDJNZYo3ag3NR2V1W1FcvKe3931tMj/HQPa4eHjvEHBeSSjt6ARPdTKzjFZLI5BhU6YA9ez1ILBkz21AdT7g7zrhLMzednZp3pKiBuHiHgzd0r17gM1PJ/pvraXbZlkGIVDN7SWikG6CjdxeR2URPG/g6ru7me/4LMBCrafMUJa1Et3kfpebM1nKji1FJy8WRppTsB1H61za6WIS7y2LAXvw3XtzLszgIHbNqJoWGnUU4jTbps/o0aBlF+PVVqPisKNwg7JUEXpCEElloLJjhujGo6d3g31JRXvw4/dgz8n+iXqdaUd72I4ZFNEwInDikAkU2Pnb+Aeo4bLnsZrFK9b3eaB4s/H/Bp0YTmFlOS04NnZKyy3ef+lPobsZvlKjfFENTSRBKIMcQ8P5ihJuxoiHyvbCWI7i/WEvAB+LMTjp19VwgbtoDgCiayi9fT9iblhIrCYcIEbA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(376002)(346002)(136003)(396003)(39860400002)(451199018)(8936002)(54906003)(91956017)(41300700001)(478600001)(66446008)(4326008)(64756008)(8676002)(66946007)(66556008)(66476007)(6916009)(76116006)(36756003)(38070700005)(86362001)(122000001)(38100700002)(6512007)(26005)(966005)(6486002)(71200400001)(186003)(7416002)(5660300002)(2906002)(316002)(6506007)(83380400001)(2616005)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?akZRTExlM0dZWmxkYnlVZkpVb1VaaWVzWnNUVlFIay84KzdyZ0xjeHBSU0o0?=
 =?utf-8?B?LzR4S3YwWm43RzFBb1lFOWU5dTR1Z3VhRWxacnpZdG5NVUtLVUpxbGdxSVBI?=
 =?utf-8?B?M0tNVXJnMXBzazZWUUJuMlBRcDAzNzNlK2oyVUNROTgycFJUa25TSzBzTkpJ?=
 =?utf-8?B?YnhuRlNsMHVQUERYMTZRY2h5WUVnQnIrQ0l5Y0pBb1FMczlIT29DWDhIZnpE?=
 =?utf-8?B?b0pwZDBIVktZNldwdFdvUlJPellCZFBEV3NqR3ZFNWZtSTZvc2VIUXlzY21F?=
 =?utf-8?B?dFVVUnZKR3J5WmkxTXBhbUQ1R09qZEwzbUhwdU9ReEJZTWFuQkVtQ0lXRWlk?=
 =?utf-8?B?YTVHd3dlRklmUWpGM0NhQXZwdXFLYWN1Qy83bUFNR0h2SGoyMVYxM0VJZkhm?=
 =?utf-8?B?bCsvbWtJK3h3d0tOQzJHU2pGSHdsd1EvUEdZRTk3UU41OVkwajREdGxCd0F4?=
 =?utf-8?B?VUJ2dUptVlE2NHdMYXY0dWlTd3F1b1MrTWpGKy96MUZQV2RMcXVnaTgxQXFY?=
 =?utf-8?B?eHlobzlTMGpQTVZMSHlyU1NJUDl0aEc0YUNmekxwL2duOEg3cmtYcnEyN2tF?=
 =?utf-8?B?SUFKT3B4aDU5WnZLWS9kQnhub29kSUExcGdsckZyQlpJT28xc0xPTitoK0wx?=
 =?utf-8?B?aGdNMEJXUU5md1lDSGVBQWZCWkxyQXU2RStDblVpSEhrM040bUhsaUVoYjE1?=
 =?utf-8?B?U1pxT3VXSW9SM1MwSk1Yc1owekcybnBUT1JYcjJTdjFNMWtqNjJXSm42czdw?=
 =?utf-8?B?QytJenZyTVljYUZhQ2dpR2dGZFNoamVMZXZ5QThGVWxoeWxPc1NhS1hDY1VK?=
 =?utf-8?B?dHZvclhNY1RqQTRuQllwL2VFRXhSdVpmTDl6U1piYmpxWHFJN1FiUEVmU1Zh?=
 =?utf-8?B?TTdiTGdqZUhMSXNSdmFCcVFId1VvL3N6bUkvbXlpNVFuWm1MQ0ltZXZrZmZ2?=
 =?utf-8?B?Q25uTXpzVTdRNGZhdy9rTmoyaXBYL1BtR0p3L25vNFZqRzFXZjBOWTN5ZjFG?=
 =?utf-8?B?d0FFQ0RjcnBpdzF6aTFISmJYSEIzRXpYZDB0RHJ4TXd3WWtDVzZrM1N0cDNE?=
 =?utf-8?B?eElScnh4L2FrWEJlSCtoN1ZGV2V1VitBYkdubG5aK0Q5bU1qN21GcDZLb29Y?=
 =?utf-8?B?eXZEc1N3cjhrWFZZenhtVkorM1hvZ01ndEVmbkdCQ2loZ3hJdUhYVmhnS2Zz?=
 =?utf-8?B?MmVGR3NTMERpNDU3V2s3b1FidjJkeDV2TEdEcE1sNktZa2Z1UnliVzFTRTlB?=
 =?utf-8?B?aXdVZkFRSFVINHJ0c2g5K091VHdYU2pMeFVyZ0EvM2ZNc0hZTWtybGNndklU?=
 =?utf-8?B?ZjNMcEdkQUtCWGtxUTNGU0gzeFdGbklxRjA2SjZsQSt2V25XczZWcjBNMjhz?=
 =?utf-8?B?STV1UTVMZ1pmTXlxenBDVFNsS3VFWkJrWnN6OXNIT3g3NnVZSXhRcEdFdW5y?=
 =?utf-8?B?bVlFaU9HVTBabnFOdWZUYnFPUHpzZEJLVis3bjMwL0xrdC9qWlUxNUNIeGRU?=
 =?utf-8?B?NE9wS1NvQm5qYTB2eWxManZmRlEyVjVLYUpLU3ZhT2VpWkszbG9NTmVoaTR3?=
 =?utf-8?B?TmlEb2VLVERmQjJkUkNvRXJnTVhWM0F3Uk90bDFmdG4vVkVhd2pZWmZKVEZE?=
 =?utf-8?B?aytCanV4WFJjNHQ4UmZNVThVREJQamIza3JGVjNBTVpIeVk1d04wRWJtN25Z?=
 =?utf-8?B?QThCQ1lRWWNENGE4bFVSTkhkR3VaaEFCTHloYjR0Y2t2NnhCZUx5bXZxTWFL?=
 =?utf-8?B?M2tNM2h6cVNzMkdxQWhNdDFZbjdHcll3RmQrb2JndmQzRGVaeUlCMGt2UkZZ?=
 =?utf-8?B?VlJSamdtNk9GenZDQ3g2MlJqSjVDbnFhZzVNSjFPYUFJaXpXcVpOQUs4ZXEr?=
 =?utf-8?B?a1dKMkFYcUtpbTh6UXBvSDFmWXlmVWFBWml3ZzBjYWV2U0txc05jSTQzbG03?=
 =?utf-8?B?cHk0N3JlMld3MUR2WnVrMEhhQUo4NWZsYlFnNnFJaFBRM2cvV1IxTkJMd3V2?=
 =?utf-8?B?OGJEeEpPcTNCRlo3L3FGdjRpeiszQXVUV3BZYVJKL0hoWTZraEhtdGVhNEJn?=
 =?utf-8?B?ZFRHb1dBYzhrSVFVRmlWdG96RDZCbnU3dzAwYlhoUUdib1BNSjNINjA1dXpG?=
 =?utf-8?B?Z1EvTDlLcWJEelRhMFpPNitDaWxURy8rcU9mSWVwL21vQXRlOGU5SXhkKzlD?=
 =?utf-8?Q?4jTSGo3ZT/7g2Vb87trMVSU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <103685543AD6924B8F24ABF608C44F80@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9acca11c-4830-4013-aed9-08db238eb96d
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Mar 2023 06:46:50.5889
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: N3N4Fq35vLgcZqIZqmaSnVlB8TFykzyfh7MveE9zSEFup2QlS4sTFJQ2fQmMedFBSX9JQ4kxZ5ff9NFtPHVSN6tFki7nEokPe5erbCUNxQg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6382
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIzLTAzLTEzIGF0IDA2OjM2ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiBNb24sIE1h
ciAxMywgMjAyMyBhdCAwMzozNDoxNkFNICswMDAwLCBBcnVuLlJhbWFkb3NzQG1pY3JvY2hpcC5j
b20NCj4gIHdyb3RlOg0KPiA+IEhpIE9sZWtzaWosDQo+ID4gT24gRnJpLCAyMDIzLTAzLTEwIGF0
IDEwOjA4ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToNCj4gPiA+IEVYVEVSTkFMIEVNQUlM
OiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+ID4g
PiBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gPiA+IA0KPiA+ID4gQWRkIEVUUyBRZGlzYyBz
dXBwb3J0IGZvciBLU1o5NDc3IG9mIHN3aXRjaGVzLiBDdXJyZW50DQo+ID4gPiBpbXBsZW1lbnRh
dGlvbg0KPiA+ID4gaXMNCj4gPiA+IGxpbWl0ZWQgdG8gc3RyaWN0IHByaW9yaXR5IG1vZGUuDQo+
ID4gPiANCj4gPiA+IFRlc3RlZCBvbiBLU1o4NTYzUiB3aXRoIGZvbGxvd2luZyBjb25maWd1cmF0
aW9uOg0KPiA+ID4gdGMgcWRpc2MgcmVwbGFjZSBkZXYgbGFuMiByb290IGhhbmRsZSAxOiBldHMg
c3RyaWN0IDQgXA0KPiA+ID4gICBwcmlvbWFwIDMgMyAyIDIgMSAxIDAgMA0KPiA+ID4gaXAgbGlu
ayBhZGQgbGluayBsYW4yIG5hbWUgdjEgdHlwZSB2bGFuIGlkIDEgXA0KPiA+ID4gICBlZ3Jlc3Mt
cW9zLW1hcCAwOjAgMToxIDI6MiAzOjMgNDo0IDU6NSA2OjYgNzo3DQo+ID4gPiANCj4gPiA+IGFu
ZCBwYXRjaGVkIGlwZXJmMyB2ZXJzaW9uOg0KPiA+ID4gaHR0cHM6Ly9naXRodWIuY29tL2VzbmV0
L2lwZXJmL3B1bGwvMTQ3Ng0KPiA+ID4gaXBlcmYzIC1jIDE3Mi4xNy4wLjEgLWIxMDBNICAtbDE0
NzIgLXQxMDAgLXUgLVIgLS1zb2NrLXByaW8gMg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5
OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1wZWxAcGVuZ3V0cm9uaXguZGU+DQo+ID4gPiAtLS0NCj4g
PiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYyB8IDIxOA0KPiA+ID4g
KysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6X2NvbW1vbi5oIHwgIDEyICsrDQo+ID4gPiAgMiBmaWxlcyBjaGFuZ2VkLCAyMzAgaW5z
ZXJ0aW9ucygrKQ0KPiA+ID4gDQo+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmMNCj4gPiA+IGluZGV4IGFlMDVmZTBiMGE4MS4uNTRkNzVlYzIyZWYwIDEwMDY0
NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4g
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gPiBA
QCAtMTA4Nyw2ICsxMDg3LDcgQEAgY29uc3Qgc3RydWN0IGtzel9jaGlwX2RhdGENCj4gPiA+IGtz
el9zd2l0Y2hfY2hpcHNbXSA9DQo+ID4gPiB7DQo+ID4gPiAgICAgICAgICAgICAgICAgLnBvcnRf
bmlycXMgPSAzLA0KPiA+ID4gICAgICAgICAgICAgICAgIC5udW1fdHhfcXVldWVzID0gNCwNCj4g
PiA+ICAgICAgICAgICAgICAgICAudGNfY2JzX3N1cHBvcnRlZCA9IHRydWUsDQo+ID4gPiArICAg
ICAgICAgICAgICAgLnRjX2V0c19zdXBwb3J0ZWQgPSB0cnVlLA0KPiA+IA0KPiA+IFdoZXRoZXIg
dGhlIHN3aXRjaCB3aGljaCBhcmUgc3VwcG9ydGluZyBjYnMgd2lsbCBhbHNvIHN1cHBvcnQgZXRz
DQo+ID4gb3INCj4gPiBub3QuIElmIENCUyBhbmQgRVRTIGFyZSByZWxhdGVkLCB0aGVuIGlzIGl0
IHBvc3NpYmxlIHRvIHVzZSBzaW5nbGUNCj4gPiBmbGFnDQo+ID4gY29udHJvbGxpbmcgYm90aCB0
aGUgZmVhdHVyZS4gSSBjb3VsZCBpbmZlciB0aGF0IHN3aXRjaCB3aGljaCBoYXMNCj4gPiB0Y19j
YnNfc3VwcG9ydGVkICB0cnVlLCBhbHNvIGhhcyB0Y19ldHNfc3VwcG9ydGVkIGFsc28gdHJ1ZS4N
Cj4gPiANCj4gPiBJZiBib3RoIGFyZSBkaWZmZXJlbnQsIHBhdGNoIGxvb2tzIGdvb2QgdG8gbWUu
DQo+IA0KPiBCb3RoIGFyZSBkaWZmZXJlbnQuIEZvciBleGFtcGxlIG9uIGtzejggc3dpdGNoZXMg
aXQgaXMgcG9zc2libGUgdG8NCj4gaW1wbGVtZW50IHRjLWV0YyBidXQgbm90IHRjLWNicy4NCg0K
T2suIA0KDQpBY2tlZC1ieTogQXJ1biBSYW1hZG9zcyA8YXJ1bi5yYW1hZG9zc0BtaWNyb2NoaXAu
Y29tPg0KDQo+IA0KPiBSZWdhdGRzLA0KPiBPbGVrc2lqDQo+IC0tDQo+IFBlbmd1dHJvbml4DQo+
IGUuSy4gICAgICAgICAgICAgICAgICAgICAgICAgICB8ICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICB8DQo+IFN0ZXVlcndhbGRlciBTdHIuIDIxICAgICAgICAgICAgICAgICAgICAgICB8IA0K
PiBodHRwOi8vd3d3LnBlbmd1dHJvbml4LmRlL2UvICB8DQo+IDMxMTM3IEhpbGRlc2hlaW0sIEdl
cm1hbnkgICAgICAgICAgICAgICAgICB8IFBob25lOiArNDktNTEyMS0yMDY5MTctDQo+IDAgICAg
fA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiAgICAgICAgICAgfCBGYXg6ICAg
KzQ5LTUxMjEtMjA2OTE3LQ0KPiA1NTU1IHwNCg==
