Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 921A9638451
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 08:14:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229552AbiKYHOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 02:14:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229455AbiKYHOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 02:14:39 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A202E22B33;
        Thu, 24 Nov 2022 23:14:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669360478; x=1700896478;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=fvOd+a7HsfhjqpPfXzSdi8f3mwxEV6VAT9vIlm0Zeeg=;
  b=AVtwR+QO6RCODPGZT64/Ew5sQqc7Bti/nghK6lYty60CArSPiHvVTf/C
   rg6pKZmyCM84qaHHrIMJ7k51nd0ocZRmPYt/GkmgRjwWJsWwKc8StDiwZ
   ar8NSycIEbtyFi8Ov2iy9blj1rDuLrHHrlD7JmsGSNnJ0MwEYyKyFOOm3
   ygXR8NZOmiJ6eI8P6u1SFVC9n9FSLnzLDnYTy+CEka5VKtor3ShifjeR3
   nvLIZ7WNtsxnq2+T6ZZ3zjVyiagwkyx0HIY/BptxOovguR4QpbHlfaayH
   2fnoeW1g9PElvO/Lm039IPm6BRnvBYZGl6z2yiDp7uUJf6yMUGjc9+1KM
   w==;
X-IronPort-AV: E=Sophos;i="5.96,192,1665471600"; 
   d="scan'208";a="125055676"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Nov 2022 00:14:37 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Fri, 25 Nov 2022 00:14:35 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Fri, 25 Nov 2022 00:14:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mE1RnOWPMbPQMGTveNKV0XaMS7AeqtS7JjaiY2JiP1sPCQiP0/YvGKydInvY55R6G5KyxrlFziQn1wQrf6SI557NVf2cyuMrNW8dF4DXO6j7Ut81pO682QQWSK/ja+NXLRjvENALGHivMLvFinA4vsV+J8ynjz8XXjwlMJl36xtTnw/xhU4yzWSd+x8LNi4jSDKgAsbbL0PVfavuzTyDiSDNP4RgJytc6t9O1M9FBRbDWsi/HVl85pxLAVYLg2YaZ+0oWJKxHGin2rMR+DvKkESJ3e5hoOdTPN+Y4ph9tlQ62Yirypvr9DL/8t3sl0bNW/YG5kdBB4nI0kJx8CUKeA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fvOd+a7HsfhjqpPfXzSdi8f3mwxEV6VAT9vIlm0Zeeg=;
 b=BXG0QM/Y6RYsuKqG6p47siNZRLcCSI/4q+vJ/SWh0VC2fJ0WHmKEZPTLf0SSdcRFbYuOcASj8wtTzRaP3ChBYQt+owAvsaXsZ6dFAuDW7C2KQzZFWpnf3VhyKD4OFtetXE9y+ogaIvqcyRXzf0IwcV8fzjddEiyhJEvgxWej0vo6xUVvyZyACSjONW6z87oRs6egC22GyVLWuPhwYqgZLkQea2VV46kb7iG1Ww4gpsuykbqXjBVEnd6OWI0B8HvYHYgzI3STBHlv1/vzdReMb9cPwlQz9Z3mirYkXP4HK3M3Jb1nYlPhqhekbc8Gge1rPc+A6NbEtxcr7egkQJdJUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fvOd+a7HsfhjqpPfXzSdi8f3mwxEV6VAT9vIlm0Zeeg=;
 b=D7WTQgJhrnxV6kAtgIgti0m16+WyIv6mox8EcajadKoLAS/Act6CYVgosLuJrOfHw/fM7TYrNvooU/kBKuMPY+94CB2xeLJAjwT21Jsz53q1Vp5kxt6mVwRUj5uKuI3byOhX8zFeufpzgpDswK6lAQS2bHPfYMdqu+51R1QoL5c=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA2PR11MB5196.namprd11.prod.outlook.com (2603:10b6:806:119::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.19; Fri, 25 Nov
 2022 07:14:33 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Fri, 25 Nov 2022
 07:14:32 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <o.rempel@pengutronix.de>
CC:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <linux-kernel@vger.kernel.org>, <vivien.didelot@gmail.com>,
        <andrew@lunn.ch>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Thread-Topic: [PATCH net-next v6 6/6] net: dsa: microchip: ksz8: move all DSA
 configurations to one location
Thread-Index: AQHY/+3FigeduKl0pEWlWfqldCou765OLIIAgAD35ACAABbegA==
Date:   Fri, 25 Nov 2022 07:14:32 +0000
Message-ID: <439da76d5f0fb800f11cec66c06a444a7a4e591a.camel@microchip.com>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
         <20221124101458.3353902-7-o.rempel@pengutronix.de>
         <e270aedb761cad689ee969285ac07578848e2ae5.camel@microchip.com>
         <20221125055240.GA22688@pengutronix.de>
In-Reply-To: <20221125055240.GA22688@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA2PR11MB5196:EE_
x-ms-office365-filtering-correlation-id: c03f26a4-5ac0-4b9d-cd41-08daceb4b398
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: A3+6FpHnS68W14bZFjO6ONOiRoy8bF6niuyXJ3b0j0bfp+KIWm6F4roSUjHcGOnWl/pWjKXP/lkRE2m3zWFQVWboQS3TSH+R1GaynMnUQ/p8nsJiw/bnOhXFz+lM2K9FPnlDfkq4P0Ml+0vTqOBHbfHCKiLvyraMgWDIL+fdHNMw8Pj8kBQ94VbSnHWJT8zD3jnrjbp0j+FDTOqrnAFmQ+NsmTAAxp/uweEALleP4gY0Oi5ZFB9oMstrNxHjsiJEH00G6yWHr+rojKZTnPP6u+cfDbsqxvFXG8d7zlea2dMEsaXCXhzkxsORF6FEVU3yBhOfTmbDGNB/Zor/6KNFBHlbxCrrJdDpUroAC9/jmnxGYWqU168AyUPqBjObipSlXJKQKXOWiCjGmrvvwEDchy0HPULHjh0HQujnZTdfk5BYOaE4yku6L/vzyCQG4DkD5sh3IhRC49p4ndYtQwiacGeQJi65il+ThmMkHaw8GwcTlie57EPMN7va3rl8794eB+E6s0W2b8EntoQJHzvKwk5gWG/8cwAoMo+CyqqDz6qgVeq4Y9XQ260sHG5gn8peL5Ad4Nv3z4X0D5Kj2JyGFEY/DtYeg/WwmMJWwPXZZD2Tzo3uk11HGw3WKknnye+xGWA7PkwOUQDBt0kbXmq1FEQlQV3HBpdR2XFkB98zbw8KBeApZ41zp69ERTZKQb/Enql8TExYKN5H4MvgwbpWVH8QYgE2UYAdHpM6SeuCVdzMBvp6He2Lie8/LaFxV247
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(346002)(366004)(136003)(376002)(396003)(451199015)(36756003)(64756008)(8676002)(38070700005)(6916009)(66946007)(66446008)(71200400001)(66476007)(66556008)(76116006)(91956017)(86362001)(122000001)(26005)(4326008)(38100700002)(478600001)(6506007)(83380400001)(2616005)(6512007)(4001150100001)(41300700001)(2906002)(316002)(5660300002)(7416002)(54906003)(186003)(8936002)(966005)(6486002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QWdTaE1OUVJYcE9SbS8yclBXc00reDQ2c2hNOEFUbXBzOCs0MEIzcG9RbExK?=
 =?utf-8?B?T3BCMXdYaEM2anJGT1RFL1lLMXAzMmUvWFVvZUxCR054aTZyL3RCMWlJMDQ0?=
 =?utf-8?B?eGhXU2tBeVJDZUgxOWllV1E3blorTy8xTm4yZU9Gb2s5YytxckFubFBhbUlz?=
 =?utf-8?B?REpIN29MY051aGswR0hJU2srN0ZocHBMRTJJVHF1TlJweTQxVDYyU0RMcjBF?=
 =?utf-8?B?dUVTcllGcmZBQUdhMnFlMm5rYjRGZk1IQmg3dEtrek45VHZramcrbmlmRlcr?=
 =?utf-8?B?UHFsbjhZM2xKZVFmVm5CTGtXdjljanIwUXVLSS9MQ1FMaVFBNThiSjV6WkJB?=
 =?utf-8?B?c20wRmp4Z1dMVzNZQUpSdi8vRVd0cmRLQVozVTlTOWk4ZUpUdmFRMUdvNFpn?=
 =?utf-8?B?RFdCdFVDQURKVWRPTU5DTVlzMGZ6S3RIOFJkbGYxcllHNVczd1hoNjNJaSsr?=
 =?utf-8?B?cEEycTRpd3cyV0JQME5mcG9pR3lEMnpKdTBmUngyOUowb1UwaXE0UUZCeWth?=
 =?utf-8?B?b1Z0UGVWQWJVRGtvdk1pTm10bFpaUFNrNk02TW1sRkU1QWhwMnExaGg5Sm11?=
 =?utf-8?B?ZDZhQnN3dmxWZTc2TWM4VjJTMldwQlNBeE1lekh6Q3BmWkJDMS9jeUhXRVBj?=
 =?utf-8?B?Z2wvUEZONmc0ejhUdnVqZktnTUZwNUVzK0F5aUZKU3ZlaXdLYUgvMC84WFpj?=
 =?utf-8?B?aGs0YkxkV3hWeG5UbnQ4Z1BvSHNJTmZjYkR4eHZQR2dZbjV4ZWI3aXQ3WjEz?=
 =?utf-8?B?T0I1ZVZLNWpiUFhhcXJtWGdVL1Z6WXJSLzRrS1h3TjQxaURFUkRWYkEwckdk?=
 =?utf-8?B?OVVsbEVKVmxCQWRZa2VnMzdOcW1rL3ZTUjFnNGs0amZidFZCanAwc0RFNzFK?=
 =?utf-8?B?NVlFQTRMd3B1bi9sM0w2ZTl2VTBEMFVrQ2xXVlBRQWtsTzF3RzdEZGU4MkJK?=
 =?utf-8?B?akdHVEdndVlLV0NIOEV5c3VSTWU2NXVBb1M1UmZORlRNYTVaRktEWUlzSzFT?=
 =?utf-8?B?T3pyNzU1KzkrM2xxNjVrN1A3Wkc3dVJhQWoyaExCSVhEQXNkNG1sV1h4eGVa?=
 =?utf-8?B?Mk9WNEhTdlBCaW9lam40cFpEMGNUc25LdnJoS1diYkcyOUV6NWVleXl6NGJH?=
 =?utf-8?B?dTdMd3ZoOXNGZTdKSk1nR2t4TWszRUNXRVRJRGJWekdIM04rQkkvVUtlUlpv?=
 =?utf-8?B?NTBMamxxc1JSdnYrMHlzNWprVzBDUkQ2Q2UrKzBGZXRTOUh6aGxlZXArajJO?=
 =?utf-8?B?M0hkN3NmbllvWUlseFQ0NjFqa291Z3NsUDYyOTJTcFFYZG1HbUE3bTB1SnpG?=
 =?utf-8?B?YVcrUXh5Szl6SUtSRnR4VjV5czdJMGFhbCtNMWFYWFluNzY0b2Z1ZkZvZ2F6?=
 =?utf-8?B?QjlXeHl3NnhOL0JxaUh4TWhIV3owMG1VdGR0a29wNmZhZHk0aEdwZlJTdlE1?=
 =?utf-8?B?RWdVTENRSUtSaCtBTVM5aytIRVJZNlFaNERNWDdBQkU0T3JRVUlZWEZsMS9k?=
 =?utf-8?B?SlZzZ2xQZG5FVVBvcjdnOXJhWnlkRTh0TEVJSXNGKzRUYlY4K244OUU0MTNL?=
 =?utf-8?B?cHo1cUtYOHpOcDFVaUloVGJvYXNwV0dsRkFsQ2s5elYyT3pqdlM5bWhMRi9s?=
 =?utf-8?B?V2E2dFdla3h2amY0Q00wZ2dyc0o0SG40aFVERGpwbkpmU2l0NWNxNVJZdjlO?=
 =?utf-8?B?UVk5UHIzVGRzU3lFMDMzTjlVM2RkdjFSUHFOaURmaGY2ODR6TUYwVHNWMjR6?=
 =?utf-8?B?VG85UHBlWmRJZEovK1J3a0h6VXRGeldtTXQydUdUWVpvOXdxMGoxbU5VbHVY?=
 =?utf-8?B?THFocjdWblN0YUFMTkNxc3AxcWcvQTNYNmFYa0llbmFJaFlVbUppbkdITWIz?=
 =?utf-8?B?ZFNVb09OMFAwL3ZFdlZhRzJxSzVqU0RnYTdvZFd6a0dvZWo4dEtoZFpMVWdJ?=
 =?utf-8?B?dHBvU1E1d1Y3Nis5dXZKS1hYcXBoN3lVWWxJbzdvYkZFYXdXcWNLclNHcFAr?=
 =?utf-8?B?QUsvQzNhNkRtamxMYTd5SlFhdzl2ejZZU2xJUkpEUE1EaDFwQ29BQjdaQkg2?=
 =?utf-8?B?VGtsS0swL3lBblVKcUMzZFRwMmVUM2RyTkk1bk9LcGIwK1N4aEtKaUorNGpo?=
 =?utf-8?B?dmtFejNhd2xRdDVGZGt1T0NJd3IrOElNTVB5YWREREJsTGQyeGZZbUNrdlV0?=
 =?utf-8?Q?QHKTMZs8KLDsIzI76X5KPnI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <1D7CB8691FB6474CAE1E089DBD7D4017@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c03f26a4-5ac0-4b9d-cd41-08daceb4b398
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Nov 2022 07:14:32.8292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: p+/S61RT8shfXNo2IbHraZEIQHPba1k+Bnw7hZO6BZWeJa1Feiyef7DS3FxmK58jlEmJ0yjYP83cv/FOQ15tySgf+UkoDPkzaXY1rffwfRE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5196
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCg0KT24gRnJpLCAyMDIyLTExLTI1IGF0IDA2OjUyICswMTAwLCBPbGVrc2lq
IFJlbXBlbCB3cm90ZToNCj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBv
cGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+
IA0KPiBIaSBBcnVuLA0KPiANCj4gT24gVGh1LCBOb3YgMjQsIDIwMjIgYXQgMDM6MDU6MjdQTSAr
MDAwMCwgQXJ1bi5SYW1hZG9zc0BtaWNyb2NoaXAuY29tDQo+ICB3cm90ZToNCj4gPiBIaSBPbGVr
c2lqLA0KPiA+IE9uIFRodSwgMjAyMi0xMS0yNCBhdCAxMToxNCArMDEwMCwgT2xla3NpaiBSZW1w
ZWwgd3JvdGU6DQo+ID4gPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9w
ZW4gYXR0YWNobWVudHMgdW5sZXNzIHlvdQ0KPiA+ID4ga25vdyB0aGUgY29udGVudCBpcyBzYWZl
DQo+ID4gPiANCj4gPiA+IFRvIG1ha2UgdGhlIGNvZGUgbW9yZSBjb21wYXJhYmxlIHRvIEtTWjk0
NzcgY29kZSwgbW92ZSBEU0ENCj4gPiA+IGNvbmZpZ3VyYXRpb25zIHRvIHRoZSBzYW1lIGxvY2F0
aW9uLg0KPiA+ID4gDQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBPbGVrc2lqIFJlbXBlbCA8by5yZW1w
ZWxAcGVuZ3V0cm9uaXguZGU+DQo+ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9kc2EvbWlj
cm9jaGlwL2tzejg3OTUuYyB8IDIwICsrKysrKysrKystLS0tLS0tLS0tDQo+ID4gPiAgMSBmaWxl
IGNoYW5nZWQsIDEwIGluc2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPiA+ID4gDQo+ID4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gPiA+
IGIvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gPiA+IGluZGV4IDA2MGU0
MWI5YjZlZi4uMDAzYjBhYzI4NTRjIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNh
L21pY3JvY2hpcC9rc3o4Nzk1LmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2No
aXAva3N6ODc5NS5jDQo+ID4gPiBAQCAtMTM1OSw2ICsxMzU5LDE2IEBAIGludCBrc3o4X3NldHVw
KHN0cnVjdCBkc2Ffc3dpdGNoICpkcykNCj4gPiA+IA0KPiA+ID4gICAgICAgICBkcy0+bXR1X2Vu
Zm9yY2VtZW50X2luZ3Jlc3MgPSB0cnVlOw0KPiA+ID4gDQo+ID4gPiArICAgICAgIC8qIFdlIHJl
bHkgb24gc29mdHdhcmUgdW50YWdnaW5nIG9uIHRoZSBDUFUgcG9ydCwgc28gdGhhdA0KPiA+ID4g
d2UNCj4gPiA+ICsgICAgICAgICogY2FuIHN1cHBvcnQgYm90aCB0YWdnZWQgYW5kIHVudGFnZ2Vk
IFZMQU5zDQo+ID4gPiArICAgICAgICAqLw0KPiA+ID4gKyAgICAgICBkcy0+dW50YWdfYnJpZGdl
X3B2aWQgPSB0cnVlOw0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICAvKiBWTEFOIGZpbHRlcmluZyBp
cyBwYXJ0bHkgY29udHJvbGxlZCBieSB0aGUgZ2xvYmFsIFZMQU4NCj4gPiA+ICsgICAgICAgICog
RW5hYmxlIGZsYWcNCj4gPiA+ICsgICAgICAgICovDQo+ID4gPiArICAgICAgIGRzLT52bGFuX2Zp
bHRlcmluZ19pc19nbG9iYWwgPSB0cnVlOw0KPiA+ID4gKw0KPiA+ID4gICAgICAgICBrc3pfY2Zn
KGRldiwgU19SRVBMQUNFX1ZJRF9DVFJMLCBTV19GTE9XX0NUUkwsIHRydWUpOw0KPiA+ID4gDQo+
ID4gPiAgICAgICAgIC8qIEVuYWJsZSBhdXRvbWF0aWMgZmFzdCBhZ2luZyB3aGVuIGxpbmsgY2hh
bmdlZA0KPiA+ID4gZGV0ZWN0ZWQuICovDQo+ID4gPiBAQCAtMTQxOCwxNiArMTQyOCw2IEBAIGlu
dCBrc3o4X3N3aXRjaF9pbml0KHN0cnVjdCBrc3pfZGV2aWNlDQo+ID4gPiAqZGV2KQ0KPiA+ID4g
ICAgICAgICBkZXYtPnBoeV9wb3J0X2NudCA9IGRldi0+aW5mby0+cG9ydF9jbnQgLSAxOw0KPiA+
ID4gICAgICAgICBkZXYtPnBvcnRfbWFzayA9IChCSVQoZGV2LT5waHlfcG9ydF9jbnQpIC0gMSkg
fCBkZXYtDQo+ID4gPiA+aW5mby0NCj4gPiA+ID4gY3B1X3BvcnRzOw0KPiA+IA0KPiA+IFNpbmNl
IHlvdSBtb3ZlZCBkc2EgcmVsYXRlZCBpdGVtcyB0byBrc3o4X3NldHVwLCByZW1haW5pbmcgaXRl
bXMgaW4NCj4gPiBrc3o4X3N3aXRjaF9pbml0IGFyZQ0KPiA+IC0gZGV2LT5jcHVfcG9ydCAtIFVz
ZWQgaW4ga3N6X3NldHVwIGJ1dCBjYWxsZWQgYWZ0ZXIgdGhlIGluZGl2aWR1YWwNCj4gPiBzd2l0
Y2ggc2V0dXAgZnVuY3Rpb24uIFdlIGNhbiBtb3ZlIGl0IGtzejhfc2V0dXAuDQo+ID4gLSBkZXYt
PnBoeV9wb3J0X2NudCAtIFVzZWQgaW4ga3N6OF92bGFuX2ZpbHRlcmluZyBhbmQNCj4gPiBrc3o4
X2NvbmZpZ19jcHVwb3J0LiBXZSBjYW4gbW92ZS4NCj4gPiAtIGRldi0+cG9ydF9tYXNrIC0gdXNl
ZCBpbiBrc3pfc3dpdGNoX3JlZ2lzdGVyLiBTbyB3ZSBjYW5ub3QgbW92ZS4NCj4gPiANCj4gPiBU
byBtYWtlIHRoZSBrc3o4X3N3aXRjaF9pbml0IGFuZCBrc3o5NDc3X3N3aXRjaF9pbml0IGZ1bmN0
aW9uDQo+ID4gc2ltaWxhciwNCj4gPiB3ZSBjYW4gbW92ZSBkZXYtPmNwdV9wb3J0IGFuZCBkZXYt
PnBoeV9wb3J0X2NudCBmcm9tDQo+ID4ga3N6OF9zd2l0Y2hfaW5pdA0KPiA+IHRvIGtzejhfc2V0
dXANCj4gDQo+IEl0IG1ha2Ugbm8gc2Vuc2UgdG8gbW92ZSB0aGlzIHZhcmlhYmxlcy4gRXZlcnkg
cGxhY2Ugd2hlcmUgdGhleSBhcmUNCj4gdXNlZCwgY2FuIGJlIHJlcGxhY2VkIHdpdGggZHNhIGZ1
bmN0aW9ucyBsaWtlOg0KPiBkc2Ffc3dpdGNoX2Zvcl9lYWNoX3VzZXJfcG9ydCgpIG9yIGRzYV9j
cHVfcG9ydHMoKS9kc2FfaXNfY3B1X3BvcnQoKQ0KPiBNYWtpbmcgdGhpcyBjaGFuZ2VzIHdpdGhp
biB0aGlzIHBhdGNoIHNldCBtYWtlIG5vIHNlbnNlIHRvLg0KDQpBZ3JlZWQuIA0KSSB0aG91Z2h0
IG9mIGNsZWFuaW5nIHVwDQprc3o4X3N3aXRjaF9pbml0L2tzejk0Nzdfc3dpdGNoX2luaXQvbGFu
OTM3eF9zd2l0Y2hfaW5pdCwgc2luY2UgdGhlc2UNCmZ1bmN0aW9ucyBhcmUgbm90IHBlcmZvcm1p
bmcgYW55IHVzZWZ1bCBhY3Rpdml0eSBvdGhlciB0aGFuDQppbml0aWFsaXppbmcgdGhlc2UgdmFy
aWFibGVzLiBTaW1pbGFybHkgYWxsIHRoZSBleGl0IGZ1bmN0aW9uIGFyZQ0KcGVyZm9ybWluZyBz
YW1lIHJlc2V0IGZ1bmN0aW9uLiBJIHRob3VnaHQgdGhlc2UgaW5pdCBhbmQgZXhpdCBmdW5jdGlv
bg0KaW4gdGhlIGtzel9kZXZfb3BzIHN0cnVjdHVyZSBpcyByZWR1bnRhbnQuDQoNCj4gDQo+IFJl
Z2FyZHMsDQo+IE9sZWtzaWoNCj4gLS0NCj4gUGVuZ3V0cm9uaXgNCj4gZS5LLiAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHwgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4gU3RldWVy
d2FsZGVyIFN0ci4gMjEgICAgICAgICAgICAgICAgICAgICAgIHwgDQo+IGh0dHA6Ly93d3cucGVu
Z3V0cm9uaXguZGUvZS8gIHwNCj4gMzExMzcgSGlsZGVzaGVpbSwgR2VybWFueSAgICAgICAgICAg
ICAgICAgIHwgUGhvbmU6ICs0OS01MTIxLTIwNjkxNy0NCj4gMCAgICB8DQo+IEFtdHNnZXJpY2h0
IEhpbGRlc2hlaW0sIEhSQSAyNjg2ICAgICAgICAgICB8IEZheDogICArNDktNTEyMS0yMDY5MTct
DQo+IDU1NTUgfA0K
