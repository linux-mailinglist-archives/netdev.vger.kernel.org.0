Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7FA64E838
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 09:41:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229816AbiLPIlU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 03:41:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiLPIlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 03:41:18 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C33D2D8;
        Fri, 16 Dec 2022 00:41:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1671180077; x=1702716077;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=pm0koxHyfMBGuYDvQx+NMSf1P5GTSYC+H/jU+bF+RL8=;
  b=cbkQD8icNyRbnoT3FU2hG6qKiwFj9fndAUOuZ2PBE/6sVT0PrXp6Q6G3
   rQK++M0F34pbZhUEDz0luTHXv0CLrPodcgvuCo48o3+/mzs9bQt2uTzNZ
   NBRPFDEpqI9bwAahnd/BXmogoeMRIGKKCtH2TjW44BxsvH4omu1nZVOos
   JO/5P4Zi3JkH9UqiJD3/u7vZTNWVO3dUIrg4gktbXqiflyiFg1fl/ATb5
   PGuqZ5Kv7evUj6U1Ou1zCvZzBcJ17yR1yCd7ggVJP/e9mJgzOdqDv7DDi
   p8Wr5OJE+bcFG+KFd3NhUoPQ1CHMom6Ugg+xv8oBaS/BwmIXTTtqB79N/
   A==;
X-IronPort-AV: E=Sophos;i="5.96,249,1665471600"; 
   d="scan'208";a="128459365"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Dec 2022 01:41:16 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 01:41:12 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 01:41:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LZUN1hvzrztqwG18AEPOOts+APVgwtcfqk8fLqI3RlZWCEIGpXy0RXM+u3RC8miQJvEVQdzAE9kbC+YiwwGzXipnVdpCb2QiHElA/BKd9VOcTNrhv+jqhRND91UBJ0PpLIk42QzZU2EktYPsPb7WcXavu3qhSNho/Ep+PbN4MEs96FWS2R+j/vLRPeZsgc8bJ1WggcKKP02x5t3wPbrN3UjV8m3cewi0KHRSTAQXm4qkl/Ms3k6m5rahxU6S7xl4skW8cOzaIsCY31IksgP4NJZ1RIGOLQGA0DjVif0AYCVMoZgA1t7NKwxqEZdyPciab1wMPLKgQaDAjemz4QWZBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=pm0koxHyfMBGuYDvQx+NMSf1P5GTSYC+H/jU+bF+RL8=;
 b=Zy4DyAHSjTFKJKemltxnu7bBel2ggizvaHb16DQgUesa2863A1JiH0DEQJFk2iDw2azhJYVwQBoEg1vpkVchwSOhvV71TBx55+dJ9q95W0St+xW1TxlFDHzbLgp0HqE9P3SFQSUxmvwEOH+C1cnozsW8HRXWoFO6O7z3AvUQ8sXCXWC4wY7N5WgsHh5cGVTF446y9ln0938C+hDKFSHuNlT5J+M3kSkrq6H4hHijGlb6VKv9f2zL9745WwX9nA4b9rij8fHAsXJf0yHyh9a5pAZQndwSBVgSrCSI/YVtNJk/lSVNeAu7wmqK/Yp2baa81GgoHrOZKpR44Okt9pbulA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pm0koxHyfMBGuYDvQx+NMSf1P5GTSYC+H/jU+bF+RL8=;
 b=S/DyIuZLU3kKmkrI5HJpCoRxn711CuXK9droQKTN03i5Ci89lT+vq3W0qZ294XMJQujk78z4+OXGsOU6z7ELC22FjTQYOUCGCil8QLoeZIarjr5kblHWquqJ2RRfSRp+LIs81EkWJw93D5xBJSDsqAs7SEh9OK6Ibp91IwXvee4=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 IA0PR11MB7404.namprd11.prod.outlook.com (2603:10b6:208:430::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Fri, 16 Dec 2022 08:41:10 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5880.019; Fri, 16 Dec 2022
 08:41:10 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <netdev@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <yanhong.wang@starfivetech.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC:     <andrew@lunn.ch>, <robh+dt@kernel.org>, <pgwipeout@gmail.com>,
        <kernel@esmil.dk>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <edumazet@google.com>, <richardcochran@gmail.com>,
        <krzysztof.kozlowski+dt@linaro.org>, <davem@davemloft.net>,
        <hkallweit1@gmail.com>
Subject: Re: [PATCH v2 6/9] net: phy: motorcomm: Add YT8531 phy support
Thread-Topic: [PATCH v2 6/9] net: phy: motorcomm: Add YT8531 phy support
Thread-Index: AQHZESj9G3G4fYxfE0unq8YQO7Ikka5wMfYA
Date:   Fri, 16 Dec 2022 08:41:09 +0000
Message-ID: <ea9ed7f72adb0bd83581e9f55f99fb8630e7bc48.camel@microchip.com>
References: <20221216070632.11444-1-yanhong.wang@starfivetech.com>
         <20221216070632.11444-7-yanhong.wang@starfivetech.com>
In-Reply-To: <20221216070632.11444-7-yanhong.wang@starfivetech.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|IA0PR11MB7404:EE_
x-ms-office365-filtering-correlation-id: fdf2249c-b4bf-4168-cf5e-08dadf4147ff
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tddTr0zvTsGV2fB61ZyEzx5lQTIFgIWOq3sST5IHC+RGRalU8CIJkIgw2lPf2J/IWv4FAObZOoMyF3FDqykMwa7PsC5PI3Vxhh8X8TE1bKVCkw8WE4FUJFLjCOCUcW6kVvpXG3Rc1Vnz7lVsDDrilD+dECXx+zeavzcelwuJdDkaQNujMNnE67cHQ5dcYEasLcWncvCwgQnlN7TXRvmGt+DiLt4WcmT/JHsNSSYuoX17WhdsOarXTQuqwopmRGgOJaBOLONhHe1azpTb+scO/HVtM18RfVd55dbwITrRpxzMmZYLgcvynV6e9E5wsEsJvnOwzeGIKEZrhV8Akq7YFbvjMpG8+L9Gp2uhFz5rqSDiKiWBbkQg3+aDFnN+hNEG1AU53GbkBm9yFI5mxO/iSj5b3PXniXCBuAIK1VSWe9rtnlw6SG7CmuqiJS0NjeUWPh6ItKZWcTKz/6mWNq/8LbPgt/gY8P1Y/hlzAwAHRfxi/8OT9FkyKnZzbJ4gqOI1pCwCFDBfJsRQOJfHthPP45JlXsyVen4OYNeDvZDjoxISXrgaeTT+I1P5FLuLZuAmbaKOc3p+AuU7NpY9wBtj6oYyNlq1j6mJTuCDhbZKodTxslGsXq38bwhbxqqjkFTym6rtcFiTNDDNfLalrrohHf9j4dvUe0bnYsiIt1lSQMPhIwLpZR1VwcgS3xSxAwVXaV2V9kH5d3oKLuneTVmUN/rw5P582vBf7cVQZvvMtok=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(376002)(39860400002)(366004)(346002)(136003)(451199015)(54906003)(2616005)(2906002)(38100700002)(4001150100001)(122000001)(110136005)(71200400001)(38070700005)(316002)(5660300002)(8936002)(6512007)(36756003)(41300700001)(26005)(6486002)(7416002)(186003)(83380400001)(478600001)(6506007)(66946007)(66556008)(66446008)(4326008)(64756008)(8676002)(91956017)(86362001)(66476007)(76116006)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VFVtS2lzYUw5U3RNOERFbk14cDJVcW90MlV4REpmQTdUMW5qSlRqdUhtc3JO?=
 =?utf-8?B?ZzFIYnlyaUVHVEdvS0huMGlJckxTZzZKQlVzMUFEWjE0dnZRRlpYSktlN1ly?=
 =?utf-8?B?VEpwOU5STU1ZY0xZRW55THlocFd1RzZVYzFwTUdlNG5MRmwyMG9jd2N5bXli?=
 =?utf-8?B?eWNXdnlCMkFsWUh5d3hqUFpZcFczU3h0aHByNVg1aWk2Y3FUQTVhNjFqODMr?=
 =?utf-8?B?Q202RGRDUjU4MW5OMi85ak1DaTV6Q3dpTjlvM2pacWFrbDEySkt2aURvUlFR?=
 =?utf-8?B?dWJhakV6bElzVFBTRy9DMHg3WGFKM1NlZkorTFJIUW1CTEs5bmpnMlFMMURm?=
 =?utf-8?B?ZHpUbW80SHFVWHBENnJjei9WbUpoZXNOTVE1M2ltZGI5Q1hTZm9Bai9wWWpZ?=
 =?utf-8?B?RjdWMWEwNzh2QTFZZjUxaU8wTmprV09YeG9sQ2FXcWlnUkd2Si9rMGNzU0sx?=
 =?utf-8?B?OWNmTmlXWHluVHJKVGUvVXFnVVI0YTVtb1gwbEo2UHhPN25qV3lZSGhURkVB?=
 =?utf-8?B?NlhFN0FVVVIreUdlWVMrOTQwT2FHNTAwNFZrOEdjdWRhcDJrU0I0Qm9LeEE0?=
 =?utf-8?B?WjZPNktENDZoSmZXaFBVQU11dVVpdlRTZnpNU3FVQWNVUVUzRkF0MFlDeUNG?=
 =?utf-8?B?UGJtRit3WFBsclRsUWJ5cjllRDVwTmt1enhtVHVndHU4Vmo4amRMOWJXTTNr?=
 =?utf-8?B?bVFjODlxVXJ3ZENQdUx1eDY4Vmh2Ry9sYkIyYWNlaEgzdTJPVjh5NHdDUXNn?=
 =?utf-8?B?NTRlVm0xSVpxZXNOUkdhbERMOUk1S3h3SXlySHpCdFFPem5VeVlEOHBoZE5B?=
 =?utf-8?B?Rk4zcFNWUk93dlhnczZTc1RNYlpsUUZRQWh1RGcybGg3enNYS25SVEU5M3ZL?=
 =?utf-8?B?b3A2b1NNQjVnSEcvUTdPb3dLL240MVkxMllHakkwZmY4NVJ5RXRUelNyV1R2?=
 =?utf-8?B?ZUltcmtVdmhBWGNHWHZETlNMTGxmYk15VENvcW1IL1IzSTJxMUtsWVdrUjhY?=
 =?utf-8?B?bVJIRTcrZ1hzbTlEOE9GK0xpR2pNcXkzZDI5emJEbkNwUWFQNDIxWWJqRG90?=
 =?utf-8?B?RzBSbGNqVzEwM3JaV01rN29ycTBYTnFxVG9ucTJZTlhrU3dGTUdHR0lMMzVx?=
 =?utf-8?B?UHdIbnJ2STJRVU1Pd2JFMXBDUktNUXNwSE9NcXpTSVkwTnYzUjFzakVZYWhC?=
 =?utf-8?B?VkwzaVd6WjZwKys1ZUlIQmhPdjZ5ditYRVhGSHg2T2hGZVppMk81dWdVTlIv?=
 =?utf-8?B?VThBZDZpb1VtMEZrZ0IwRk9aY3FqMzlSM2hhQjRCWXBjcXhhUCtZa1ViL3FO?=
 =?utf-8?B?WXRSZ2ZlbkN1VHlyL2pmNzhJUFpTakNQVnFMeFhnOVV6RjdKbzB3UW5PMXdK?=
 =?utf-8?B?Q0tsQlZmM2xKYzZya3pGejBjTXRVMWxQdEpJa2l1TXBtOCtvMGRQdlUrakl3?=
 =?utf-8?B?OHhxVFQ1emRQRTRnUmxhMnhQeCtGK040Z1JjaTY3cFlUTG5tampjTXVVaXBM?=
 =?utf-8?B?bi8yTU96TzZXd3hFZlJOTEVTdXc0QzBUd0ZLQXJNekVMSzZSVFFoNzRwK2pm?=
 =?utf-8?B?a3hLdHpVRDJLRHY2UUEyUDk1WHd6dkZMSkp0bjZhc2o5RlFMaVFoMVUrRTVt?=
 =?utf-8?B?Zlp4Nmt2VElXT1dpYzYzYWwzaDY4cy9ycllPQTkxdmdCaGw0NUYxM0NjcHQ5?=
 =?utf-8?B?SXkxcVFXOUVsSUp1SngrdFpRY3lkUHdqRkYrT1cxMVZCcEFEeVdOcWh0Y1dP?=
 =?utf-8?B?U3RhRVJOODA4M3dCajhLY3JWNTU3RFQxOHY1VE8ydGQ4NHV1ZTRhVWdNbzMz?=
 =?utf-8?B?NzdTN0xMT1Z6RFFWMjJ2bjhrZTlVbjUvK2Z6U1ZENXN6Z1lQVHd0UmduUytM?=
 =?utf-8?B?VlJDdmR2UUFNejFLbmQwcGVNS2pYYUtDencrN2VZVjdiMExqTHZpdkU3NFBI?=
 =?utf-8?B?eTJDOWE1QWVyWTJYMkF1QnhlOGxMODdkMjd2MlZDR2l6OERKZVpaamdzRG05?=
 =?utf-8?B?dGRFNUpVRHlYcnZaZ2xvMFBoRWJWZWtpa2FyOGtIazcyRC9WVDFzU043MHEz?=
 =?utf-8?B?WnJmMVN2eG0zaXduNmNoRCswYWxXajJTRldPM0lUcFdoUzJYZ0g3UGxVV2ly?=
 =?utf-8?B?NGFlcVZySi9JZUJneTlBeHdaTnphMktyai9RVWovSkVudm9NMUlsak0yZmJ2?=
 =?utf-8?Q?5LX6Ef5PYB3nTyMk9+awOW0=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <570DC99E0F9A564A9FAD7D2A002D2F2E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fdf2249c-b4bf-4168-cf5e-08dadf4147ff
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2022 08:41:09.9693
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0QK5/9odhpiUU5cXe2BRlhuuVTpd63/a9ObFN9OGseRIXm/S1iEIri5w5yeOwgIbmC0fJoG1nTWH0TFx90TcJ6OLk0lL61PXfH4wAPXAf3Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR11MB7404
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgWWFuaG9uZywNCg0KT24gRnJpLCAyMDIyLTEyLTE2IGF0IDE1OjA2ICswODAwLCBZYW5ob25n
IFdhbmcgd3JvdGU6DQo+IFRoaXMgYWRkcyBiYXNpYyBzdXBwb3J0IGZvciB0aGUgTW90b3Jjb21t
IFlUODUzMQ0KPiBHaWdhYml0IEV0aGVybmV0IFBIWS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFlh
bmhvbmcgV2FuZyA8eWFuaG9uZy53YW5nQHN0YXJmaXZldGVjaC5jb20+DQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvcGh5L0tjb25maWcgICAgIHwgICAzICstDQo+ICBkcml2ZXJzL25ldC9waHkvbW90
b3Jjb21tLmMgfCAyMDINCj4gKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+
ICAyIGZpbGVzIGNoYW5nZWQsIDIwNCBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0K
PiANCj4gK3N0YXRpYyBpbnQgeXRwaHlfcmVhZF9leHQoc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRl
diwgdTMyIHJlZ251bSkNCj4gK3sNCj4gKwlpbnQgcmV0Ow0KPiArCWludCB2YWw7DQo+ICsNCj4g
KwlyZXQgPSBfX3BoeV93cml0ZShwaHlkZXYsIFlUODUxMV9QQUdFX1NFTEVDVCwgcmVnbnVtKTsN
Cj4gKwlpZiAocmV0IDwgMCkNCj4gKwkJcmV0dXJuIHJldDsNCg0KWW91IGFyZSByZXR1cm5pbmcg
dGhlIGVycm9yIHZhbHVlIGFzIHdlbGwgYXMgdGhlIHJlYWQgdmFsdWUgaW4gdGhlDQpmdW5jdGlv
bi4gQnV0IGluIHRoZSBjb25maWdfaW5pdCwgeW91IGFyZSBub3QgY2hlY2tpbmcgdGhlIGVycm9y
IHZhbHVlLA0KanVzdCB1c2luZyB0aGUgdmFsdWUgZGlyZWN0bHkuIFNvIGluc3RlYWQgb2YgcmV0
dXJuaW5nIGJvdGggdGhlIHZhbHVlDQphbmQgZXJyb3IsIHlvdSBtYXkgY29uc2lkZXIgcmV0dXJu
IGVycm9yIGFuZCBmb3IgdmFsdWUgdXNlIGNhbGwgYnkNCnJlZmVyZW5jZS4NCg0KPiArDQo+ICsJ
dmFsID0gX19waHlfcmVhZChwaHlkZXYsIFlUODUxMV9QQUdFKTsNCj4gKw0KPiArCXJldHVybiB2
YWw7DQo+ICt9DQo+ICsNCj4gKw0KPiAgc3RhdGljIGludCB5dDg1MTFfY29uZmlnX2luaXQoc3Ry
dWN0IHBoeV9kZXZpY2UgKnBoeWRldikNCj4gIHsNCj4gIAlpbnQgb2xkcGFnZSwgcmV0ID0gMDsN
Cj4gQEAgLTExMSw2ICsxOTEsMTE2IEBAIHN0YXRpYyBpbnQgeXQ4NTExX2NvbmZpZ19pbml0KHN0
cnVjdCBwaHlfZGV2aWNlDQo+ICpwaHlkZXYpDQo+ICAJcmV0dXJuIHBoeV9yZXN0b3JlX3BhZ2Uo
cGh5ZGV2LCBvbGRwYWdlLCByZXQpOw0KPiAgfQ0KPiAgDQo+ICtzdGF0aWMgaW50IHl0cGh5X2Nv
bmZpZ19pbml0KHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpDQo+ICt7DQo+ICsJc3RydWN0IGRl
dmljZV9ub2RlICpvZl9ub2RlOw0KPiArCXUzMiB2YWw7DQo+ICsJdTMyIG1hc2s7DQo+ICsJdTMy
IGNmZzsNCj4gKwlpbnQgcmV0Ow0KPiArCWludCBpID0gMDsNCg0KaSBpbml0aWFsaXplZCBoZXJl
IGFzIHdlbGwgYXMgaW4gZm9yIGxvb3AuDQoNCj4gKw0KPiArCW9mX25vZGUgPSBwaHlkZXYtPm1k
aW8uZGV2Lm9mX25vZGU7DQo+ICsJaWYgKG9mX25vZGUpIHsNCg0KdG8gcmVkdWNlIHRoZSBpZGVu
dCBsZXZlbCwgeW91IG1heSBjb25zaWRlciByZXR1cm5pbmcgaGVyZSBieSBjaGVja2luZw0KaWYo
IW9mX25vZGUpDQoJcmV0dXJuIC1FSU5WQUw7DQoNCj4gKwkJcmV0ID0gb2ZfcHJvcGVydHlfcmVh
ZF91MzIob2Zfbm9kZSwNCj4geXRwaHlfcnhkZW5fZ3JwWzBdLm5hbWUsICZjZmcpOw0KPiArCQlp
ZiAoIXJldCkgew0KPiArCQkJbWFzayA9IHl0cGh5X3J4ZGVuX2dycFswXS5tYXNrOw0KPiArCQkJ
dmFsID0geXRwaHlfcmVhZF9leHQocGh5ZGV2LA0KPiBZVFBIWV9FWFRfQ0hJUF9DT05GSUcpOw0K
PiArDQo+ICsJCQkvKiBjaGVjayB0aGUgY2ZnIG92ZXJmbG93IG9yIG5vdCAqLw0KPiArCQkJY2Zn
ID0gY2ZnID4gbWFzayA+PiAoZmZzKG1hc2spIC0gMSkgPyBtYXNrIDoNCj4gY2ZnOw0KPiArDQo+
ICsJCQl2YWwgJj0gfm1hc2s7DQo+ICsJCQl2YWwgfD0gRklFTERfUFJFUChtYXNrLCBjZmcpOw0K
PiArCQkJeXRwaHlfd3JpdGVfZXh0KHBoeWRldiwgWVRQSFlfRVhUX0NISVBfQ09ORklHLA0KPiB2
YWwpOw0KPiArCQl9DQo+ICsNCj4gKwkJdmFsID0geXRwaHlfcmVhZF9leHQocGh5ZGV2LCBZVFBI
WV9FWFRfUkdNSUlfQ09ORklHMSk7DQo+ICsJCWZvciAoaSA9IDA7IGkgPCBBUlJBWV9TSVpFKHl0
cGh5X3J4dHhkX2dycCk7IGkrKykgew0KPiArCQkJcmV0ID0gb2ZfcHJvcGVydHlfcmVhZF91MzIo
b2Zfbm9kZSwNCj4geXRwaHlfcnh0eGRfZ3JwW2ldLm5hbWUsICZjZmcpOw0KPiArCQkJaWYgKCFy
ZXQpIHsNCj4gKwkJCQltYXNrID0geXRwaHlfcnh0eGRfZ3JwW2ldLm1hc2s7DQo+ICsNCj4gKwkJ
CQkvKiBjaGVjayB0aGUgY2ZnIG92ZXJmbG93IG9yIG5vdCAqLw0KPiArCQkJCWNmZyA9IGNmZyA+
IG1hc2sgPj4gKGZmcyhtYXNrKSAtIDEpID8NCj4gbWFzayA6IGNmZzsNCj4gKw0KPiArCQkJCXZh
bCAmPSB+bWFzazsNCj4gKwkJCQl2YWwgfD0gY2ZnIDw8IChmZnMobWFzaykgLSAxKTsNCj4gKwkJ
CX0NCj4gKwkJfQ0KPiArCQlyZXR1cm4geXRwaHlfd3JpdGVfZXh0KHBoeWRldiwgWVRQSFlfRVhU
X1JHTUlJX0NPTkZJRzEsDQo+IHZhbCk7DQo+ICsJfQ0KPiArDQo+ICsJcGh5ZGV2X2VycihwaHlk
ZXYsICJHZXQgb2Ygbm9kZSBmYWlsXG4iKTsNCj4gKw0KPiArCXJldHVybiAtRUlOVkFMOw0KPiAr
fQ0KPiArDQo+ICtzdGF0aWMgdm9pZCB5dHBoeV9saW5rX2NoYW5nZV9ub3RpZnkoc3RydWN0IHBo
eV9kZXZpY2UgKnBoeWRldikNCj4gK3sNCj4gKwl1MzIgdmFsOw0KPiArCXN0cnVjdCB5dHBoeV9w
cml2X3QgKnl0cGh5X3ByaXYgPSBwaHlkZXYtPnByaXY7DQoNCnJldmVyc2UgY2hyaXN0bWFzIHRy
ZWUNCg0KPiArDQo+ICsJaWYgKHBoeWRldi0+c3BlZWQgPCAwKQ0KPiArCQlyZXR1cm47DQo+ICsN
Cj4gKwkNCj4gK3N0YXRpYyBpbnQgeXQ4NTMxX3Byb2JlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlk
ZXYpDQo+ICt7DQo+ICsJc3RydWN0IHl0cGh5X3ByaXZfdCAqcHJpdjsNCj4gKwljb25zdCBzdHJ1
Y3QgZGV2aWNlX25vZGUgKm9mX25vZGU7DQoNClJldmVyc2UgY2hyaXN0bWFzIHRyZWUuDQoNCj4g
Kwl1MzIgdmFsOw0KPiArCWludCByZXQ7DQo+ICsNCj4gKwlwcml2ID0gZGV2bV9remFsbG9jKCZw
aHlkZXYtPm1kaW8uZGV2LCBzaXplb2YoKnByaXYpLA0KPiBHRlBfS0VSTkVMKTsNCj4gKwlpZiAo
IXByaXYpDQo+ICsJCXJldHVybiAtRU5PTUVNOw0KPiArDQo+ICsJb2Zfbm9kZSA9IHBoeWRldi0+
bWRpby5kZXYub2Zfbm9kZTsNCj4gKwlpZiAob2Zfbm9kZSkgew0KPiArCQlyZXQgPSBvZl9wcm9w
ZXJ0eV9yZWFkX3UzMihvZl9ub2RlLA0KPiB5dHBoeV90eGludmVyX2dycFswXS5uYW1lLCAmdmFs
KTsNCj4gKwkJaWYgKCFyZXQpDQo+ICsJCQlwcml2LT50eF9pbnZlcnRlZF8xMDAwID0gdmFsOw0K
PiArDQo+ICsJCXJldCA9IG9mX3Byb3BlcnR5X3JlYWRfdTMyKG9mX25vZGUsDQo+IHl0cGh5X3R4
aW52ZXJfZ3JwWzFdLm5hbWUsICZ2YWwpOw0KPiArCQlpZiAoIXJldCkNCj4gKwkJCXByaXYtPnR4
X2ludmVydGVkXzEwMCA9IHZhbDsNCj4gKw0KPiArCQlyZXQgPSBvZl9wcm9wZXJ0eV9yZWFkX3Uz
MihvZl9ub2RlLA0KPiB5dHBoeV90eGludmVyX2dycFsyXS5uYW1lLCAmdmFsKTsNCj4gKwkJaWYg
KCFyZXQpDQo+ICsJCQlwcml2LT50eF9pbnZlcnRlZF8xMCA9IHZhbDsNCj4gKwl9DQo+ICsJcGh5
ZGV2LT5wcml2ID0gcHJpdjsNCj4gKw0KPiArCXJldHVybiAwOw0KPiArfQ0KPiArDQo+ICANCg==
