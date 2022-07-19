Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21B7C57A3BD
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 17:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239527AbiGSPzA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 11:55:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239504AbiGSPy6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 11:54:58 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C3525A44A;
        Tue, 19 Jul 2022 08:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658246096; x=1689782096;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=6eLyP9I/0GoSvXoz6qqCUDwdv/tpUo3w5AIXRPYlzyE=;
  b=K2ln4lCVw1GqdKhrY0UmV0iTu5VuBOeVBkqcjTnm9VkU0Ec73an4vkZm
   AGEkM20MQz2wJA5beODi6W1PxuKWLhgKum5raIe8e+e48/iCTZRkjCAdv
   ppVgxPs187vB5/RqpXVYGYiDPTlfqlVBgXqEjeIEvhYkuGUWOtKTGT92A
   FOhjT1poHvzSeLq3MHffGKHQcDN0iXUY6FVASaZXw9yEXX0182nM7Rd1u
   IXHRsZ4ZdCLd8//nyZ6UukNg3PeSRkfaEOc1fb22dT9MMMrmXWqzp/t0P
   8VhmWJq9UkPmW5YinYx57URyXM83yoqqVRl8OLNfY8EgnGCAVAWI9hiYd
   A==;
X-IronPort-AV: E=Sophos;i="5.92,284,1650956400"; 
   d="scan'208";a="182843353"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 19 Jul 2022 08:54:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 19 Jul 2022 08:54:49 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17 via Frontend Transport; Tue, 19 Jul 2022 08:54:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X/qAOecSF0qpDUW14HDnz0NWTqWZzD67vV0dS77GIEg6uKotVmukB5xz9LGpJoFEiKU2PUd/9ZDeZu+Ii8MtzlxiGQikWd8ZP3h/QrfpG+e3nxtBnXGC9S/XLB+6TD2736xpoY0lG/w6nhSlfFTuGjhwnkxV3l/y0DsR+NQwKeqY9oYuk/7hakhL/j9gRP/+j6dGDqKij9Q9jhJK97lmECnENu4/sNfW60Ca8uwWo2HFK7JuDuPpEc/795BZeSrQY9xqp9rr+pV9lbYqdKGc34ljaVIivshOPrSR3Eq4QFTWjKIGR4H+4tBz+usIVB/sCfIT+MKL98CmYT3AJ7A0qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6eLyP9I/0GoSvXoz6qqCUDwdv/tpUo3w5AIXRPYlzyE=;
 b=H2jcVU65ckUxogDWK6byTZaGRxjTUwPkfjk+Joeb2f8CuOc0GaE0QZHx1WtTQ625HVTrbzVlpzg/UVMxcNR1kyaAdZYxnZExl1emBbLyuiD1E8jA//aWeMI7Egy8ZW6CkmlzXZ2m9nV3DxYAJMLn1Dw1NGPHK/KYhik4hVoHTps7vLm8Paqr+zMiLjaDPH1k9vcJhJY++JYJgW0iJ4R1VoYGiW/mP6U7qNhKpKsRJCtDLN1c+QOGd1kiGz7mRdaEVQlnYlxbgTQllpnAkvFGvICzW1GCTatJEBZndACHMB5h8wW29o1/AR4IS8cqAPIJflOzgJ7Z0OH3pITlK3g8Iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6eLyP9I/0GoSvXoz6qqCUDwdv/tpUo3w5AIXRPYlzyE=;
 b=AvAKsIhN7AgGSKj3t3xmD2rztNSoLVnjJ8x90FqkX8mMlqaLUKQEeyyjnU1rgn4YRprh59JA9aOHKuLOVXnrCQbmk971TJ0VkttNWwqV1s3fhYbwg/V0W8i8etRV15v4xYBHIzYh9q8kch38cav64Gu77m2LSpALIMtBliXxgcg=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 CY4PR1101MB2229.namprd11.prod.outlook.com (2603:10b6:910:19::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5438.21; Tue, 19 Jul
 2022 15:54:45 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::a4d9:eecb:f93e:7df0%6]) with mapi id 15.20.5438.014; Tue, 19 Jul 2022
 15:54:44 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <f.fainelli@gmail.com>, <kuba@kernel.org>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next 04/10] net: dsa: microchip: add common duplex
 and flow control function
Thread-Topic: [RFC Patch net-next 04/10] net: dsa: microchip: add common
 duplex and flow control function
Thread-Index: AQHYlgkT+dmXYxEBNkuGIbGEgD9ph62Fj38GgABUJgA=
Date:   Tue, 19 Jul 2022 15:54:44 +0000
Message-ID: <c7b276dd299e66fac8b4dff7315296741335d4af.camel@microchip.com>
References: <20220712160308.13253-1-arun.ramadoss@microchip.com>
         <20220712160308.13253-1-arun.ramadoss@microchip.com>
         <20220712160308.13253-5-arun.ramadoss@microchip.com>
         <20220712160308.13253-5-arun.ramadoss@microchip.com>
         <20220719105259.h2pbg4jdjhblbkv5@skbuf>
In-Reply-To: <20220719105259.h2pbg4jdjhblbkv5@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: be6660ec-190c-4f31-4484-08da699f0023
x-ms-traffictypediagnostic: CY4PR1101MB2229:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FsGQZVeXhfRxpYMSIlrGgVNdwhX/CfwmOof7ksEwlbaRYuTzJBinHf4v32nuF3Kox4tF1S8KFCmLEOR5/wBKJtNkFs0IhJ9I/LkCU3sHrcrguS6AGTfNEHa+ENgUglfAh8ZnkqdA2sNHDiMCuQSyDMEKBlJaDJZhvLZaVldjVgB9aCLPJ2P+klEnSDVnwuwLtNmjK1Rz6zHvPyuEcfx/Jj5jVgeU5wQdpqfPPf61l+BE5WqhI9RKdIDM0l7kF58L/WNxcLV2yhQAcwPwDHn99fGHSw8UQ5dnqxTL1CB0Wy6dvzYFSEPAwvNi5w+k+b1W1maCYTgUlMDvqtZxHgRce6e2pxePYxppPCzwnnKcycfjQnYCEUz6338PHeGnkNyUmWPiXZAkWyZG+Rg9PsfqcxR5nBBrJCBlVcmmUgyC3rwg12UibZygnRLtD3uTaURe9+9wITQggjT5qZqI9JAuOqGYSUmREijw1/OJuGstQ0ZaFxs2bud08ecmi/B2nXiWxFg8IC1agsoZ2vy8bT1jdVZB+HUaFNyOJJNDh9rLqpaXgF5/gN9l8G3AdISTFwAzKbBHi6j59XAZ83ietIie944QuljCifzLQgxdID20BkmZsc/wZueerO8ScRmyz/OWkxFeNNXsw++TyUvYqOkvvKh7tDGhtg6oToe4scwRQ9snzxJTR/coDGhgDHtyWiolBZOWaJz0QEWBNpyoeKZhROaNWC2DcwXGxepHvllpuWyXABKBo0hu0kxG4eABE9jpBuVJ4bzZXHj7NsZTRa4M0QxfFAT2RPKdJ5pw4BxnCaR+BqqFzMLP22YT34eS6Lq7CcVbwziATJfovuPbRWm+0w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(39860400002)(346002)(376002)(366004)(136003)(396003)(6512007)(38100700002)(86362001)(38070700005)(36756003)(71200400001)(478600001)(2616005)(186003)(6486002)(6506007)(41300700001)(66556008)(6916009)(64756008)(316002)(5660300002)(2906002)(8936002)(66476007)(4326008)(76116006)(66946007)(54906003)(122000001)(7416002)(66446008)(83380400001)(8676002)(91956017)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WmFobUhES2h2RGRhVGdyN2lZczIwQXdSSGttdFljSnQ5RmFUb2FpcjdVbWZ5?=
 =?utf-8?B?Y3lyV0M5MTFzaHAvQ1ZrMWJna0NzRDU0bWdLbXBhcHlleFJMTDJucnNmR2pH?=
 =?utf-8?B?OWtPMWxxeWFUZDBUUmlYdzdIeHJvSkRTU2g4R2VEa0YwWlR1MEYxeDZlSkxX?=
 =?utf-8?B?bHFTaVIzaEZtK3ZIVjBWQ0hvN05Qazg0b3BmeHNBYjR1L3hBOWR3T3pPbXNt?=
 =?utf-8?B?SDBGMEZmOWo0cmFBR2dFN2ZZM2hDN0pZaWhJMUwxZTNiWEE5RmM3NU0vbVNX?=
 =?utf-8?B?ZFZ5LytRcmRvNkFMa1AvNWl1NUJ2c0xiV2VZc2hyQ0Y5blFXK3Yvd3BXVDM5?=
 =?utf-8?B?dU5NMnJ6akhPdCtXVWFuTDFEWkU4ak9Bcno0aUFZNTZBTmlGK0ZtK2NoRFV0?=
 =?utf-8?B?bkJxWUlhWXQ1RXRPeTU5MHBsYU4rdlQ1bnlFdFpkb2dOcFF6azdORHdOUUY4?=
 =?utf-8?B?eHNZRHlJdXFJQ0hyZlNIVVhZNmhQZjVtTmpSUUdGTWo3U0pSVk1SREpWRGVo?=
 =?utf-8?B?RWtrMEI2aDI5U2VMSzdaUXB6VmhlQnVGYlQrSndZRzFNS0toSmRvcWlzT1VS?=
 =?utf-8?B?QjFkN1plTURZL3VQK0gxdXFWR1VUV000UzVJNFJ4blVaNTk0M2lsTFRycEYv?=
 =?utf-8?B?NFhBcHJ6eWRlYTltbnR5VkVhYmd3QTdINVN4MGExemh5RlBVVnpiTnJkZlVM?=
 =?utf-8?B?UmlJZ0pRdStMSFJPd1ljQVUwZmVvemJ5TDJiOWRja1Rna0lIZTRVcURlazVG?=
 =?utf-8?B?WVJYcktvb21YZk42MFJWZGNPb2dSWlpLZ01pdEFPVTJFa0trSEgrR3Ruc0xJ?=
 =?utf-8?B?ZEZPbHZ3TjJpajhVUlQ5WExCS015QlZUNEU2L2Q2S0p0NTdHRkxXL0dQbDFC?=
 =?utf-8?B?MGl0N0JoQkIyN3M4R0JYWnN5SHVSaXZCUk9FQ3dVeU5Wd1VGTWZyNG1UUXFY?=
 =?utf-8?B?cGFVNERxbThJTC82VDRDVFMvaVZCbmVNTTNlMFlvSVI4Q2VLYm5jc1pDZVNy?=
 =?utf-8?B?RVZWNkJGZ0tNZDJwME1xdStiTzBqQXI4b1NCN2pqaldzQXgrTlpyeE1PTE9Q?=
 =?utf-8?B?enk4QjJkSmdLMWExamNFcXJrRjFPMlJVZW9aWGVMSFVOa2NMQ2JDNVZwYXY2?=
 =?utf-8?B?d2E1WmF2QjZMZ2xlbWRqdWJOVnFuMVp0c1FmSmNBa2xUYzBicSttTlRBNm9w?=
 =?utf-8?B?b25QRlhObkZmNDZUTkxyUXRiQkx1UXVud01kaGtBL1FBVGF6ZEhxcC9kYjlJ?=
 =?utf-8?B?TWZjSndXZkh4b0duLzdISXo4K2pzUmpzanJxalgxQ1lxV0xUZkRTeWxLUmg1?=
 =?utf-8?B?UEp6bDdOYUl0SmpjVkx0ZnJmZDg3dVhkWnJJbjhGaGdTWllhMDlKQnlKTVVC?=
 =?utf-8?B?ckJPc3BuVE82aExnUk9EbDlrbTZ1U1dHWlpNZHl5YjRvY1I3TzRJVjd1THlC?=
 =?utf-8?B?SW9LMTZPVEwrRnlha09sZjc3VXJRWW1QdUhpaUtpQTdHRVNxYWRReTVPR01l?=
 =?utf-8?B?ZCtQdEZ1UlREMzlJK05lelF5NENYUzRWbEpiMWpSSE0rYklEaGdJRHlLT2Np?=
 =?utf-8?B?NSt6Zk1PMmg3aXR4TUx4R21oZjljRUYzU3FKYUF5dEU3RGRJd1JCWm1GTU0w?=
 =?utf-8?B?R1ZreDZwVTZFODltMzErUjRDbXdkU0xlT1dHdFZhY2FrblBpNnovd3ZLYnNU?=
 =?utf-8?B?cGhLcGxScmd1eW1kSWdMeENHaXpHNzFQdjVranZmQTYrOGk1OEg2YmpGd0ls?=
 =?utf-8?B?MTJzMG0yOTgzZUlBcldrNVRid01YaVBFck1sVW5UNThNQlZiei9ydUN6dFVn?=
 =?utf-8?B?aEdrUTdDUGRONmI4eURMY0VCZnpzS1o3bnFJajEvZHZ1aDl4bC9JMCtZOEZs?=
 =?utf-8?B?TG9DSzFJNTlnaGQxNGRrZklINVcyd05DL3haSW1xUkY3QklwQm44b0Joc3Mv?=
 =?utf-8?B?YnVTTzg0aXJmdTdSbStXV0JURlRXcTczTWVEbG1pb1l2WTREL0kxaGFjdVgv?=
 =?utf-8?B?dmdHc0J4Y0Qzd1o4MUF0UkpOR09kMHlacXZyRnVLQmQwRWlBUzJFdDBuNjNE?=
 =?utf-8?B?OXZaVVFwZHNHV1NVL1JEL1VqbHNRdHlrMVN6WVh4djIrZm1qRmhqRXNjSHdy?=
 =?utf-8?B?eEYwY0pQZ1F5UVZJd0dnRCtFVVpnREdqQ2ZlWUprbldzZzg4Vk1sL2RMeTFS?=
 =?utf-8?B?VEcvRWdheUtrYVZuMkNUeUcrdEt1dGJJandRVmwwTUxGSGJlZnFOR3BOQTMy?=
 =?utf-8?Q?y0DvHCju1iRvqCST8aAQQEUCyYXyb4syajphIzgOBQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <568C6380C065EF47881CA40163AA2A3E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: be6660ec-190c-4f31-4484-08da699f0023
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jul 2022 15:54:44.8749
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jTtpAPtSf92TO1FX5/g46M7Eg8I2c6dOTRhRRhGQ7Chd8j0KQZ7ZAJqseLwALCnh4vzJTCHf5LSguhogvU8WXJZnRelThtHlTrWSdkekm38=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR1101MB2229
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIyLTA3LTE5IGF0IDEzOjUyICswMzAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gVHVlLCBK
dWwgMTIsIDIwMjIgYXQgMDk6MzM6MDJQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4g
PiBUaGlzIHBhdGNoIGFkZCBjb21tb24gZnVuY3Rpb24gZm9yIGNvbmZpZ3VyaW5nIHRoZSBGdWxs
L0hhbGYgZHVwbGV4DQo+ID4gYW5kDQo+ID4gdHJhbnNtaXQvcmVjZWl2ZSBmbG93IGNvbnRyb2wu
IEtTWjg3OTUgdXNlcyB0aGUgR2xvYmFsIGNvbnRyb2wNCj4gPiByZWdpc3Rlcg0KPiA+IDQgZm9y
IGNvbmZpZ3VyaW5nIHRoZSBkdXBsZXggYW5kIGZsb3cgY29udHJvbCwgd2hlcmVhcyBhbGwgb3Ro
ZXINCj4gPiBLU1o5NDc3DQo+ID4gYmFzZWQgc3dpdGNoIHVzZXMgdGhlIHhNSUkgQ29udHJvbCAw
IHJlZ2lzdGVyLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEFydW4gUmFtYWRvc3MgPGFydW4u
cmFtYWRvc3NAbWljcm9jaGlwLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3o5NDc3X3JlZy5oICB8ICAxIC0NCj4gPiAgZHJpdmVycy9uZXQvZHNhL21pY3Jv
Y2hpcC9rc3pfY29tbW9uLmMgICB8IDY0DQo+ID4gKysrKysrKysrKysrKysrKysrKysrKysrDQo+
ID4gIGRyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5oICAgfCAgOCArKysNCj4g
PiAgZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9sYW45Mzd4X21haW4uYyB8IDI0ICsrKy0tLS0t
LQ0KPiA+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2xhbjkzN3hfcmVnLmggIHwgIDMgLS0N
Cj4gPiAgNSBmaWxlcyBjaGFuZ2VkLCA4MCBpbnNlcnRpb25zKCspLCAyMCBkZWxldGlvbnMoLSkN
Cj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3
X3JlZy5oDQo+ID4gYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfcmVnLmgNCj4g
PiBpbmRleCAyNjQ5ZmRmMGJhZTEuLjZjYTg1OTM0NTkzMiAxMDA2NDQNCj4gPiAtLS0gYS9kcml2
ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejk0NzdfcmVnLmgNCj4gPiArKysgYi9kcml2ZXJzL25l
dC9kc2EvbWljcm9jaGlwL2tzejk0NzdfcmVnLmgNCj4gPiBAQCAtMTE3OCw3ICsxMTc4LDYgQEAN
Cj4gPiAgI2RlZmluZSBSRUdfUE9SVF9YTUlJX0NUUkxfMCAgICAgICAgIDB4MDMwMA0KPiA+IA0K
PiA+ICAjZGVmaW5lIFBPUlRfU0dNSUlfU0VMICAgICAgICAgICAgICAgICAgICAgICBCSVQoNykN
Cj4gPiAtI2RlZmluZSBQT1JUX01JSV9GVUxMX0RVUExFWCAgICAgICAgIEJJVCg2KQ0KPiA+ICAj
ZGVmaW5lIFBPUlRfR1JYQ19FTkFCTEUgICAgICAgICAgICAgQklUKDApDQo+ID4gDQo+ID4gICNk
ZWZpbmUgUkVHX1BPUlRfWE1JSV9DVFJMXzEgICAgICAgICAweDAzMDENCj4gPiBkaWZmIC0tZ2l0
IGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gPiBiL2RyaXZlcnMv
bmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+ID4gaW5kZXggZjQxY2QyODAxMjEwLi40
ZWYwZWU5YTI0NWQgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9uZXQvZHNhL21pY3JvY2hpcC9r
c3pfY29tbW9uLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzel9jb21t
b24uYw0KPiA+IEBAIC0yODAsNiArMjgwLDggQEAgc3RhdGljIGNvbnN0IHUzMiBrc3o4Nzk1X21h
c2tzW10gPSB7DQo+ID4gICAgICAgW0RZTkFNSUNfTUFDX1RBQkxFX0ZJRF0gICAgICAgICA9IEdF
Tk1BU0soMjYsIDIwKSwNCj4gPiAgICAgICBbRFlOQU1JQ19NQUNfVEFCTEVfU1JDX1BPUlRdICAg
ID0gR0VOTUFTSygyNiwgMjQpLA0KPiA+ICAgICAgIFtEWU5BTUlDX01BQ19UQUJMRV9USU1FU1RB
TVBdICAgPSBHRU5NQVNLKDI4LCAyNyksDQo+ID4gKyAgICAgW1BfTUlJX1RYX0ZMT1dfQ1RSTF0g
ICAgICAgICAgICA9IEJJVCg1KSwNCj4gPiArICAgICBbUF9NSUlfUlhfRkxPV19DVFJMXSAgICAg
ICAgICAgID0gQklUKDUpLA0KPiANCj4gVGhlIG1hc2tzIGFyZSB0aGUgc2FtZSBmb3IgVFggYW5k
IFJYIGZsb3cgY29udHJvbCBhbmQgdGhlIHdyaXRlcyBhcmUNCj4gdG8NCj4gdGhlIHNhbWUgcmVn
aXN0ZXIgKHJlZ3NbUF9YTUlJX0NUUkxfMF0pLCBpcyB0aGlzIGFuIGVycm9yPw0KDQpJIGhhdmUg
Z29uZSB0aHJvdWdoIGtzejg3OTUgZGF0YXNoZWV0LCBJIGNvdWxkIG5vdCBmaW5kIHNlcGFyYXRl
IGJpdA0KZm9yIFR4IGFuZCBSeCBmbG93IGNvbnRyb2wgYml0LiBCaXQgNSBtZW50aW9uZWQgYXMg
RmxvdyBjb250cm9sIG9uIHRoZQ0Kc3dpdGNoIE1JSS9STUlJIGludGVyZmFjZS4gU28gSSBoYWQg
Y29uZmlndXJlZCBzYW1lIGJpdCBmb3IgVHggYW5kIFJ4Lg0KDQo+IA0KPiA+ICB9Ow0KPiA+IA0K
PiA+ICBzdGF0aWMgY29uc3QgdTgga3N6ODc5NV92YWx1ZXNbXSA9IHsNCj4gPiBAQCAtMjg3LDYg
KzI4OSw4IEBAIHN0YXRpYyBjb25zdCB1OCBrc3o4Nzk1X3ZhbHVlc1tdID0gew0KPiA+ICAgICAg
IFtQX01JSV9OT1RfMUdCSVRdICAgICAgICAgICAgICAgPSAwLA0KPiA+ICAgICAgIFtQX01JSV8x
MDBNQklUXSAgICAgICAgICAgICAgICAgPSAwLA0KPiA+ICAgICAgIFtQX01JSV8xME1CSVRdICAg
ICAgICAgICAgICAgICAgPSAxLA0KPiA+ICsgICAgIFtQX01JSV9GVUxMX0RVUExFWF0gICAgICAg
ICAgICAgPSAwLA0KPiA+ICsgICAgIFtQX01JSV9IQUxGX0RVUExFWF0gICAgICAgICAgICAgPSAx
LA0KPiA+ICB9Ow0KPiA+IA0KPiA+ICBzdGF0aWMgY29uc3QgdTgga3N6ODc5NV9zaGlmdHNbXSA9
IHsNCj4gPiBAQCAtMzY2LDYgKzM3MCw4IEBAIHN0YXRpYyBjb25zdCB1MTYga3N6OTQ3N19yZWdz
W10gPSB7DQo+ID4gIHN0YXRpYyBjb25zdCB1MzIga3N6OTQ3N19tYXNrc1tdID0gew0KPiA+ICAg
ICAgIFtBTFVfU1RBVF9XUklURV0gICAgICAgICAgICAgICAgPSAwLA0KPiA+ICAgICAgIFtBTFVf
U1RBVF9SRUFEXSAgICAgICAgICAgICAgICAgPSAxLA0KPiA+ICsgICAgIFtQX01JSV9UWF9GTE9X
X0NUUkxdICAgICAgICAgICAgPSBCSVQoNSksDQo+ID4gKyAgICAgW1BfTUlJX1JYX0ZMT1dfQ1RS
TF0gICAgICAgICAgICA9IEJJVCgzKSwNCj4gPiAgfTsNCj4gPiANCj4gPiAtLQ0KPiA+IDIuMzYu
MQ0KPiA+IA0KPiANCj4gDQo=
