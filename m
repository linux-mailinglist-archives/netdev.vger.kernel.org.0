Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8470F54C20B
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 08:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242727AbiFOGko (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 02:40:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236984AbiFOGkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 02:40:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8DE443EB;
        Tue, 14 Jun 2022 23:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1655275241; x=1686811241;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=A2JDM0glQitVUDlNyXWD3osFifRxVt2qNWV7veM5F5c=;
  b=xvZB4ie/0qQXehr8Y3nMHL7c+IgGgNYZrOfXJezkZaN62GmGy2GI2YAt
   M5HJFJzWXO6I+A/HA3CR8d92gxwhG6dV7hRN5x1m/5uPrgfkOLMpyQc/p
   Q+B8gwFYZjJuED5HIK8gNMPXpBAtbiTmU9zxwcJTJqemaEmyECDAYkUk9
   SP1GolDSn4p0fLjJKAZNXZtPJ1IIO87et5F4WypVf3Wb2F8TlRfnNGpHr
   AJxhREQkROHCPR6bag4FcN5avM4L/MkOFR65qRGjFVLuTYbRlcQzk1b2j
   RaiAHCscShN5+Xwc2Eng716SNh+1iFQKKZz17fT3bwFTT2jCRA3kYnyk3
   A==;
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="178012226"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jun 2022 23:40:40 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 14 Jun 2022 23:40:41 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 14 Jun 2022 23:40:40 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YaJgFBiovRrRf05a5wGy4DJ1RpCsFqD3qBFqVlVjBme/LnzX8wwKSAnH6n64C6A2fINZ433iMqX4AsBCMh+5YVef6GFmwnxyZMldxXI/t+Na+lkxfpocVI/Ehk+w3Tko7CEws8pCm74AkXF4FT9XVUKIb6szj6m3TvFiR515m2+/Myoe1lyLdXQg29YCyIFnQ4lufugLPceA2nj6x+NlG7H5kf3q0KSn1iw9rSDNdH/fgtp5paWnawSmaFO72opmcxyu82D3TcsKOnSRuE8mKq2n8fVE4WSkicQnXMZC+6cqHSB5pCncwrc4enoQ4P/x+upKtQx0Rn9nYUHcPOZrzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=A2JDM0glQitVUDlNyXWD3osFifRxVt2qNWV7veM5F5c=;
 b=IRuKXMSPrE9L4KkDh8LkcyQqRpjh3k4LUac0xY7F2mJ24DhFoOyFr72j5LNmG+5BHFo+jzd28RCnRnjXBsWVlwM8CSdwKUWYOb+VsszL2llcM376nnwypbBb7gmefr3e5FUMn232fFGXWY9Qa/JTmT8cmn2ng/yyobjtvRHNatTOPBgtr3UEdzqPFLBN0AV7vBQ+UrQlqJX8NP7oYIiK5Shv15Vm+9jknG/XM8RsnY+AbEMTAFO7ntiVm5ajdQnkKZBPBy/OvAqQx4xUNuOaLqYWUDqXL12MS0WgbCCkShNM5KQsBqRmAzMYbhZWLfIvSWPVXd6quFQdOOh/EKoAWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=A2JDM0glQitVUDlNyXWD3osFifRxVt2qNWV7veM5F5c=;
 b=tHKxb9i9swYkjSXe7ska7IpEPVR2xfXBiLfJf+huu8XnpUiBMchYDhibXIPumXcXkkZy3XjnQVCNkCuJmvlDH83MzPWYTYJeFI/rurCC5U3LJDuCcSCaRm7knTQq0ANyFegW/9W5iEZJ2IcxYVry/3ytofHqMX0rRvqJzNDNVpE=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 DM6PR11MB3228.namprd11.prod.outlook.com (2603:10b6:5:5a::29) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5332.13; Wed, 15 Jun 2022 06:40:39 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5332.020; Wed, 15 Jun 2022
 06:40:39 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 05/15] net: dsa: microchip: move the port
 mirror to ksz_common
Thread-Topic: [RFC Patch net-next v2 05/15] net: dsa: microchip: move the port
 mirror to ksz_common
Thread-Index: AQHYdBIzkzZ0Kx9VnUKYyTdHKvPjZK1NJ8KAgAL1xgA=
Date:   Wed, 15 Jun 2022 06:40:39 +0000
Message-ID: <5122bb72cee5e0a3fa3cb66d55f141b66f145e7b.camel@microchip.com>
References: <20220530104257.21485-1-arun.ramadoss@microchip.com>
         <20220530104257.21485-6-arun.ramadoss@microchip.com>
         <20220613092833.f4sk2lhhbl64imrb@skbuf>
In-Reply-To: <20220613092833.f4sk2lhhbl64imrb@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 66ae25c3-aaf4-4444-0abf-08da4e99f64f
x-ms-traffictypediagnostic: DM6PR11MB3228:EE_
x-microsoft-antispam-prvs: <DM6PR11MB32281119D138F1F55D1DACBBEFAD9@DM6PR11MB3228.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: J7wNOPDY9dhPdIdA7PrdYYRc9a5pD8YILQlHbfWEW0c2uvrZvqqb9y0zlxuRcL9LUg6o+QD93ttEpSqYlnZn4hw5NtFOSssyTY464s5vPfvWAYl1R9FsFGymnqryXDv1h5zzZmfxRukVfJBCLZyjqjZ0xYkpDh7p8UfqqXsUU1gYvMN2UaIS+j7yOrFB4lpkdYzta0qnx6JXOIHO6g0xqhHf4kVqCTZmPQP080+5ehz01n0zrZMiCIqQSnnRK0OAKA4HNvuoNAH4URwfopbdQ86YV+Vsqn/QuvGr7ZKaxhKRcuh0RCszIZqmAAtI3QePSTZARMmJOkSfpPX0nIm2x2NLWmxGCOh1Yo+P2zHk+Ufq0QjTLpV9xV4JC3CAb7v0t6dF525QCm4l5BuUawuAPn0V8XTi/LCdESTYSNQfGtcrGfNEOvR8wGDiUOx24hCNiysBxge7JSyVfdmJjF2MwJd1k7gSLLtSJCPAiVK6UcKgeOTxM0QOyLHCPh/9a4/H89E4YHPvRh6oDyFDZHqZL9BUHsOuCsE0KFZmbLGVi9PzzfkVqorN5BqbP8XKwZTkh0ae9FpHIBlDZMugB7nQ69A+7vuKxxV8MNOFWL62TUbOQAtmyvvi+qQCRvVvzqzv8duFkgvOm7EOPRLEiVUX3fbrtwgVZ2mEYt30b7p7oAPCQwCCNfWJCuuOgTnBEaNsnwl/QzY07rPFx/Uc/zqQZgJyGs7H+2PbtzVKqtpjSFo=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(26005)(6512007)(86362001)(91956017)(122000001)(6506007)(38070700005)(2616005)(186003)(66946007)(316002)(6916009)(8936002)(54906003)(66556008)(5660300002)(38100700002)(36756003)(8676002)(66476007)(4326008)(508600001)(6486002)(66446008)(83380400001)(7416002)(64756008)(76116006)(2906002)(71200400001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cXVUNGY3Z3lpZGl1bVJPSU5nOUVSUFg3Nm5BZVovT2lUOVZGN3JiQ25ISzBu?=
 =?utf-8?B?VmQ1bk43b0djQXByVzFDL3l2TkJSOU5ZZEw1QUx0TGg4aHZwK3Z2amRxUU05?=
 =?utf-8?B?MmErbHVZeHJoRnBwekVqN2dtbDJ4NHpWUkpnc1VqM3YvL2hIczl2dDI5Ynhh?=
 =?utf-8?B?em0zU0ZSM3ZzV2R4YVVuY3NtbllZL1V1cjkvQUx4QzRIRUEzakVBQW8vbTBC?=
 =?utf-8?B?VWdrMmFIZTdvcWxFNXU4dHkwOHVEV204d2tYejZoNmhDa1JpNVZieStDT1Fq?=
 =?utf-8?B?R21VQ2lXRHhEOE1ucGNrR3c2R2pLOEx2VVpJbThtbjZRblY4Vjl2bFJBaGxB?=
 =?utf-8?B?cjR6QnVuY3FrK2RseE8zM3RKNkZkVXQvallZUGVqZHJpWTliaG1Ja3REOTBO?=
 =?utf-8?B?UEorc2FWU1prUTZxbk1oODFDellxT04wd0Y2cWxBcGZPVUpIempsTENkWGNO?=
 =?utf-8?B?eDdJdUI1VXl5YjRWcTBzZUtyNUNwTnpSdk9uZDlDNE1abXBuM2wyYmZTcVVQ?=
 =?utf-8?B?cFdSVE16eUVPNUN0VFJqYnZrUnJaVWhDQ1ZHU3hFWDAycTEzSU5KVng1M2do?=
 =?utf-8?B?Umh2MTE4TW5VMzdyUlBPMlhVVE45K2FTeGpJWDljelpPenFCbjNHT29WajA3?=
 =?utf-8?B?VkdFZWhXMEUwTnh2WGFCeXYyZmE0dkduSStRMFhKS2lxK3haSmxSL0Q4LzlR?=
 =?utf-8?B?aStxeHlnYTgwZytRQkxaTnYwVXNFbzl2WDJIYlZtVGU0d2x0OXQ5dVluOWNJ?=
 =?utf-8?B?ckFFUUlJU1dYVldyWGtqeHNxcVJEN2p2L2V5N2dyOU1yWHQ2dzhRNmhwUE8z?=
 =?utf-8?B?b0xKQm9JcGErcDRENmp3RVk0MEdoc2xUdm1QSlhKYXBXUE9FNmx3L09oTUx6?=
 =?utf-8?B?QlFHVXRHL1lJVGU2NEZ6RDRWalYzcFhWTWRVRS9naHhvSXVTVjFxMnhVSHIv?=
 =?utf-8?B?MkNjcXdjVE11OUpUV2dkcDA0VXFLYlp3S2E5YTBPODFESnZ4a3h2bDk3WXhK?=
 =?utf-8?B?T0JuVXM0TEJMMUFBbXh0eFU4OTlwTWh3RFhBK0VnZHVEZ0RaMFhGYnFoRXdj?=
 =?utf-8?B?VFBZdzVzT0NSeGhnNXR0a0cwcUpxZDk0ZnAxTTBrZDkzVHE4dGY3TE5uUGxt?=
 =?utf-8?B?dnBtcm4yanZDa1F3T0Zkc2JTbWZDcEJWNWFBV0xjT2Z4RFVTYzdHdlhXbmRu?=
 =?utf-8?B?R1BMclRGdk5lTU5FQ2NuKzZoeHNDYW5JVDIxWmIwSEJocWQrYUZPTVhHbVJM?=
 =?utf-8?B?bjkxVE5mYThmaDhGdHRsVjJOSU9ncjZqZURRK0hBYUZ0RVFRVVBEQmJLSXNN?=
 =?utf-8?B?L1NBZnErOUdhN0FaY2tiUFhsbitFSTdJd1BReVVhNGd2TmNvSUdqS2IvcXJX?=
 =?utf-8?B?Q2FSb1dVNzEveW9saENnQm05V1pTUGFNcHFObGlmWWhERmNOazd3cnQzWXM5?=
 =?utf-8?B?RE8xcWZNVXk3OGlkYzdpQnpQRXMvaEUyMURmWGlLbitsR1Q0dW51RytBRThh?=
 =?utf-8?B?Y3FVcG4vNXowYklTVTIvM0h4MlRNMVhabkpzbTVsdmpqVVAvWW52OXM2dWN3?=
 =?utf-8?B?clZRS1lHNjF4dkM3ZHNqcVNaa0w5ZXFlTHJPSHJVcGFRTmQ0d0l3cDhIbW81?=
 =?utf-8?B?cm5ncDZxSmxtN2JuNGR6aEdVQUxZRFBMRUFKaXFhZ0RVaFFRZ0U3YXU3THJ2?=
 =?utf-8?B?S2U5TDRXeTBwSk5ZenBDejJMd20zSjQrYnZiK1NSRUtvQzdHeFl0RnFOdFdY?=
 =?utf-8?B?QUh6Q3ZJRjIvQm5wVkJqZFNEZ2FaMHEraFREUXpQKy9DNnNmYmYzbmdxRHVS?=
 =?utf-8?B?aUU2VGk3aXpSQWVnQk5FRVljd1A5WUVoVFpzNjhDUTNJRFR1MkJ6RDljd3Bk?=
 =?utf-8?B?RkZrekk3UVBkazdVbGdISlJ1ck1IUXRxd3RSWVNCTmFDclUwb3Z2TjFUTGo3?=
 =?utf-8?B?ZUNHaGNGeXJiV2lBT3BWUFBET0wzSyt5RHUwaSt2RWVVZ2oyeW1WVzVSWUR4?=
 =?utf-8?B?SzZTNXpUN0lUa05wQ29CY1dicG5LS0lKWkJWSVc0S1B6czllN3ljTVhXUTR0?=
 =?utf-8?B?ZUs2WEQ4MVUyK1RTdERsQU0rVXVibXBndDFMUHRaRzlkWEJsODhlSVVUU0hF?=
 =?utf-8?B?OTBHUVhjY1BrUW40dzM1dVA1N0dsWElrMDluenU0bE1KY3BrT24vcTdxSzFV?=
 =?utf-8?B?c2JCZjJSUnNKWFNndm1OczFaK3ZaVWhmd3NINEc1M0gybGNBeGRwM1kwcXZO?=
 =?utf-8?B?c0dGUEJCTDlHOWdjN1FWMkNZajdVdzkvM2Izdjc5UnBqNDIyQlEzVDMxWXdJ?=
 =?utf-8?B?Z1ByL3kza3ZaYzJnd2V6SG9vUUM0U2tjaHE4WkVNVnIyZWJjYVU2RXFYK1E3?=
 =?utf-8?Q?0FbnOWY9b8T8enGY+qfcm9jkeR7G3oBy59jXk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1B46C813105D984EB20A948445B7B813@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66ae25c3-aaf4-4444-0abf-08da4e99f64f
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2022 06:40:39.5372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 2cHKIISmDkNZDB8REHUA7ezONKRjkx56cO42ve8BTNnyNfYHiDnJTJ0jQWgoegQd+4s3E6QM/ioZLLXN2HT0OsyKeTdU4TIsl5Ea1LH8sJk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3228
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTA2LTEzIGF0IDEyOjI4ICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBN
YXkgMzAsIDIwMjIgYXQgMDQ6MTI6NDdQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBUaGlzIHBhdGNoIHVwZGF0ZXMgdGhlIGNvbW1vbiBwb3J0IG1pcnJvciBhZGQvZGVsIGRzYV9z
d2l0Y2hfb3BzIGluDQo+ID4ga3N6X2NvbW1vbi5jLiBUaGUgaW5kaXZpZHVhbCBzd2l0Y2hlcyBp
bXBsZW1lbnRhdGlvbiBpcyBleGVjdXRlZA0KPiA+IGJhc2VkDQo+ID4gb24gdGhlIGtzel9kZXZf
b3BzIGZ1bmN0aW9uIHBvaW50ZXJzLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFydW4gUmFt
YWRvc3MgPGFydW4ucmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4gPiAtLS0NCj4gDQo+IFJldmll
d2VkLWJ5OiBWbGFkaW1pciBPbHRlYW4gPG9sdGVhbnZAZ21haWwuY29tPg0KPiANCj4gPiAgZHJp
dmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMgICAgfCAxMyArKysrKystLS0tLS0tDQo+
ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jICAgIHwgMTIgKysrKysrLS0t
LS0tDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jIHwgMjUNCj4g
PiArKysrKysrKysrKysrKysrKysrKysrKysrDQo+ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6X2NvbW1vbi5oIHwgMTAgKysrKysrKysrKw0KPiA+ICA0IGZpbGVzIGNoYW5nZWQsIDQ3
IGluc2VydGlvbnMoKyksIDEzIGRlbGV0aW9ucygtKQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9k
cml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0KPiA+IGIvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gPiBpbmRleCAxNTdkNjllNDY3OTMuLjg2NTdiNTIwYjMz
NiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYw0K
PiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+ID4gQEAgLTEw
ODksMTIgKzEwODksMTAgQEAgc3RhdGljIGludCBrc3o4X3BvcnRfdmxhbl9kZWwoc3RydWN0DQo+
ID4ga3N6X2RldmljZSAqZGV2LCBpbnQgcG9ydCwNCj4gPiAgICAgICByZXR1cm4gMDsNCj4gPiAg
fQ0KPiA+IA0KPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9j
b21tb24uYw0KPiA+IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4g
PiBpbmRleCBhMWZlZjllNGUzNmMuLjFlZDRjYzk0Nzk1ZSAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21tb24uYw0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gQEAgLTk5NCw2ICs5OTQsMzEgQEAgaW50
IGtzel9wb3J0X3ZsYW5fZGVsKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywNCj4gPiBpbnQgcG9ydCwN
Cj4gPiAgfQ0KPiA+ICBFWFBPUlRfU1lNQk9MX0dQTChrc3pfcG9ydF92bGFuX2RlbCk7DQo+ID4g
DQo+ID4gK2ludCBrc3pfcG9ydF9taXJyb3JfYWRkKHN0cnVjdCBkc2Ffc3dpdGNoICpkcywgaW50
IHBvcnQsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkc2FfbWFsbF9taXJyb3Jf
dGNfZW50cnkgKm1pcnJvciwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgYm9vbCBpbmdyZXNz
LCBzdHJ1Y3QgbmV0bGlua19leHRfYWNrICpleHRhY2spDQo+ID4gK3sNCj4gPiArICAgICBzdHJ1
Y3Qga3N6X2RldmljZSAqZGV2ID0gZHMtPnByaXY7DQo+ID4gKyAgICAgaW50IHJldCA9IC1FT1BO
T1RTVVBQOw0KPiA+ICsNCj4gPiArICAgICBpZiAoZGV2LT5kZXZfb3BzLT5taXJyb3JfYWRkKQ0K
PiA+ICsgICAgICAgICAgICAgcmV0ID0gZGV2LT5kZXZfb3BzLT5taXJyb3JfYWRkKGRldiwgcG9y
dCwgbWlycm9yLA0KPiA+IGluZ3Jlc3MsDQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgZXh0YWNrKTsNCj4gPiArDQo+ID4gKyAgICAgcmV0dXJuIHJldDsN
Cj4gPiArfQ0KPiA+ICtFWFBPUlRfU1lNQk9MX0dQTChrc3pfcG9ydF9taXJyb3JfYWRkKTsNCj4g
DQo+IEp1c3QgYXMgYSBtaW5vciBzdHlsZSBjb21tZW50LCB0YWtlIGl0IG9yIGxlYXZlIGl0Lg0K
PiANCj4gSWYgeW91IHN3aXRjaCB0aGUgZnVuY3Rpb24gcG9pbnRlciBwcmVzZW5jZSBjaGVjaywg
eW91IHJlZHVjZSB0aGUNCj4gaW5kZW50YXRpb24gb2YgdGhlIGxvbmcgc3RhdGVtZW50LCBtYWtp
bmcgaXQgZml0IGEgc2luZ2xlIGxpbmUsIGFuZA0KPiB5b3UNCj4gZWxpbWluYXRlIHRoZSBuZWVk
IGZvciBhICJyZXQiIHZhcmlhYmxlOg0KPiANCj4gICAgICAgICBpZiAoIWRldi0+ZGV2X29wcy0+
bWlycm9yX2FkZCkNCj4gICAgICAgICAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gDQo+
ICAgICAgICAgcmV0dXJuIGRldi0+ZGV2X29wcy0+bWlycm9yX2FkZChkZXYsIHBvcnQsIG1pcnJv
ciwgaW5ncmVzcywNCj4gZXh0YWNrKTsNCg0KWWVzIGl0IHJlZHVjZXMgdGhlIGluZGVudGF0aW9u
LiBJIHdpbGwgdXBkYXRlIGl0IGZvciBvdGhlciBjaGVja3MgdG9vLg0KDQo+ID4gKw0KPiA+ICt2
b2lkIGtzel9wb3J0X21pcnJvcl9kZWwoc3RydWN0IGRzYV9zd2l0Y2ggKmRzLCBpbnQgcG9ydCwN
Cj4gPiArICAgICAgICAgICAgICAgICAgICAgIHN0cnVjdCBkc2FfbWFsbF9taXJyb3JfdGNfZW50
cnkgKm1pcnJvcikNCj4gPiArew0KPiA+ICsgICAgIHN0cnVjdCBrc3pfZGV2aWNlICpkZXYgPSBk
cy0+cHJpdjsNCj4gPiArDQo+ID4gKyAgICAgaWYgKGRldi0+ZGV2X29wcy0+bWlycm9yX2RlbCkN
Cj4gPiArICAgICAgICAgICAgIGRldi0+ZGV2X29wcy0+bWlycm9yX2RlbChkZXYsIHBvcnQsIG1p
cnJvcik7DQo+ID4gK30NCj4gPiArRVhQT1JUX1NZTUJPTF9HUEwoa3N6X3BvcnRfbWlycm9yX2Rl
bCk7DQo+ID4gKw0KPiA+ICBzdGF0aWMgaW50IGtzel9zd2l0Y2hfZGV0ZWN0KHN0cnVjdCBrc3pf
ZGV2aWNlICpkZXYpDQo+ID4gIHsNCj4gPiAgICAgICB1OCBpZDEsIGlkMjsNCj4gPiANCj4gPiAN
Cj4gPiAtLQ0KPiA+IDIuMzYuMQ0KPiA+IA0KPiANCj4gDQo=
