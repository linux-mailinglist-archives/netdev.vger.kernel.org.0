Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE951637C7C
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:08:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiKXPIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKXPIx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:08:53 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C60F914EC84;
        Thu, 24 Nov 2022 07:08:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669302534; x=1700838534;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=g7ruuGccsgwHdMiGTfTnFq/6K5xWMC+o0uFdYP9QxlA=;
  b=hLVqAZIPVdCX7/8f0yy9gQZoaI2XGdgRKv1h3JH1e6De1oYZ4aC870E0
   tCvuoRPR3K5vyUJ3VtnyI77CGZpV3wHtoEEoE/d6bqNEr74XSw2H49Pg3
   fPFHlcGeP9v9IAvvgQAgWoh2pM5g4/3TQgrg7bGnIU3Z1O6M2lj1uri4u
   Wi0cNlQwfJVQ7trbLwNjhwEVybDzCzYUKF9zoK28lgNjmjV5Yagee52g3
   WoZijPFH1xFGszcB/pNRsFPmZdkMgjjLb7gzUpZVwLFuRF7BfoF3wRJFk
   LI5zTEPVS6logHTHZIB+ff0XY3IiX56h1rYm+CO+z2pf1vfhkM/ZLaTO6
   A==;
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="190411202"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2022 08:08:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 24 Nov 2022 08:08:51 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 24 Nov 2022 08:08:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HOsq5HbVYo1PxChTxHIR5Y0LtwMe7giKl6VQKF5SlbGDNapnP4WnaXLgsCxxpIXQkxp87c3CYSHiJJqb7p4msYWohb75RXHWnXyE7u/Lny8BzsVjd/4/QH7QxmSPK+ze3V1bhbOhz8Bpfn1gtneLK6naKjaPGian7A1mKFeLHZAKILlOuvG3HPpnPkC4gKf1GBSEodgBZhoT9pqACM80KoeZlQaFis/XEHSDqe8/G+3N1jxT/Hn1Jj8t1yiMuWDJijitrZba/BY0i6WCz+YBOnVMVNAHCuFX5cA8QsBC53L/PECPtZVL0KxDyyTG2Ox0rg+uomyfbKCCdR3N//ddaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=g7ruuGccsgwHdMiGTfTnFq/6K5xWMC+o0uFdYP9QxlA=;
 b=ZV2sh5h4gDVH6KM3tzY3zVaxJWTbEl/kDEh3XIac3tyYWJ1JZ+Typ5fUJy6SGmfGiCuwPX1TgldeAcGh+1nuHkTq5USAatAYKIiw0ll2H51FN3UDHG8Q44OyDG6boeLKniXE5ibPy4vCd08OFV70XhkmNKxe9Am2LTFM6RwBHSQ1G2VHgwIFve4pLvwymrtUCtakM7oGga6fOKesTS5rOUGbF8tO75KVMWmYTQ9tIs/nEcpLc2kiDUEnqlEEgQOE2eF7p6CmJaWt6SGnJvEqlV7xzEiPrPxygLc0qq9J2YtApD20yO0PmkXNdEy7lSUrYXDpszCgIFk1EnjwTaZtLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g7ruuGccsgwHdMiGTfTnFq/6K5xWMC+o0uFdYP9QxlA=;
 b=GK3OeM/3pQMiAb0KF8zuOkIgsnSfYiPVyx3+mK515qo0IjxqWOnJVEpkU5LyaDOPM6660hc7dBqQD+uumeR6CdwJPB641f1ZYH5piJMeImBS3JIs+8q0ccPMiq0+eqBFNBcGB8ozjlJ6OAKOiHhXn8QUx7yysGXL/mg5zkhZGjI=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 MN0PR11MB6278.namprd11.prod.outlook.com (2603:10b6:208:3c2::8) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.9; Thu, 24 Nov 2022 15:08:49 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 15:08:49 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <o.rempel@pengutronix.de>,
        <Woojung.Huh@microchip.com>, <davem@davemloft.net>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v6 5/6] net: dsa: microchip: enable MTU
 normalization for KSZ8795 and KSZ9477 compatible switches
Thread-Topic: [PATCH net-next v6 5/6] net: dsa: microchip: enable MTU
 normalization for KSZ8795 and KSZ9477 compatible switches
Thread-Index: AQHY/+3FLfaHIzZM1UWhWkCP+40fXa5OLXMA
Date:   Thu, 24 Nov 2022 15:08:49 +0000
Message-ID: <5b22acfb5fee0b315a091a43badc01683c567c6f.camel@microchip.com>
References: <20221124101458.3353902-1-o.rempel@pengutronix.de>
         <20221124101458.3353902-6-o.rempel@pengutronix.de>
In-Reply-To: <20221124101458.3353902-6-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|MN0PR11MB6278:EE_
x-ms-office365-filtering-correlation-id: 51419e73-37fb-4a0d-7490-08dace2dcaa5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 2jttS+EoRDY/IQaQ74u9JQqbsrCEUgi6KYMhfH7BJDfEDLYkLioE9kWOXKKX8RuspUqMKqbNao3mgocjMoOLPIDz2Hjlakoa539tikF7pzGiIbkUIRvMpMgsKeMC4RTPA1XHZU+OH8h3Cye0Fx+1jcKCaxIve9ld69OVED1ZuydVe8bpE8s+NIWDbW20bFdwS6wLeBKXlRikwGh4OzP7dzs2sXVHM8brYbO/3vu3XM2+H41RJiVETdQy3yjzgM5Q/Q3Gr2rc/C0rWpQl+SnTH5JwVM2hPH9lP5yyLv/oyVT3Xu75coB9ajVe3/DjSgL9Khlgk1er0glH5GRoyRu3X1IiCWH6l+JuW73NeM2Pf+s0BSgAesmRfdD3AfbSHSBvqkuIfNy5fiou4YbmS1lU6qbEIaZAXTBiAGacbNOgmed8MewG0FRp4wdt5t5/zTzVYJWYAg0MU+9LGA9U+pIXX79eL0Gno70qIa8QdzCJ/41+NQ2gObgGJ5qHTIFvVAQgwBpTIOf12cQwg4cEKwI61RuCsRoWd5+Qoq1Y0kGZR8+0uOIuPWJUGOY85c4CsyRd5ajGyayHqJrqF4zvDmxRtQRO2t0fUGhXp0H0cgiaWS/k5V6oaHhqHWHSj0eAcdTcRwJn1mvmyW/nHnxlTMae7KEyuDBdm9eYegSyygrxLZZX8+AbCQcUC+wHLOWrupwXGw+tBUKMVocqNj9oV10JAp6Tws648Y6Djn1fbvTdnfdMLsLcbQ89kAAAnDYl+Yt6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(366004)(396003)(39860400002)(136003)(451199015)(478600001)(2906002)(4001150100001)(921005)(83380400001)(38070700005)(71200400001)(7416002)(86362001)(5660300002)(6506007)(38100700002)(6486002)(54906003)(66556008)(110136005)(64756008)(66476007)(66446008)(66946007)(122000001)(4326008)(316002)(8676002)(76116006)(41300700001)(186003)(2616005)(91956017)(6512007)(36756003)(8936002)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YTBVQlg0aFJtRUdSVHRaYXlDMm9LMzdXL01vbVBNSXV1TGkvOUxyazhkM1l6?=
 =?utf-8?B?Y2w5OTcvZHFoWk9UdlJHajUrWDhlUWlsSGUvWTladGtvM1lLWG5aYUxPZ3Vh?=
 =?utf-8?B?MFh2MFlteW5tWlRUR1ZDTGR0a0xvZ0VSbnJPaFhKT3JyaXN1aWhoMEE1RjJE?=
 =?utf-8?B?RlRyY2ZQekFUVzFnVUg5Y001eVFmQlFzNEZnUWMvRFFWRWdCK3BXak9xNktn?=
 =?utf-8?B?UXl0TUhwdUUyd2xKSmlNTnY3QTJjWXJyYXNSc09XOUExWGdOVXJvNkkySUN3?=
 =?utf-8?B?VklucC9CQzJmeGJsaGZJWFZRWnFQQ1FtZE4vdXE5dEQ3ZWdMVW5qdHRyV3Fm?=
 =?utf-8?B?NW10Z2ZRb2x6N0NWZTFqb1BVc0tkcGFYU29FZ3cxMGJiUjFGTGFHeXdnSlJE?=
 =?utf-8?B?VWxIb2xTNlpHUTlMTk0vbE51MC9nanByY1pmbU15bVZCSnorZjZELzZrdXdR?=
 =?utf-8?B?UWtCdzI1ZDJLU2F0SmJJZGM1VjR3UG1DdkhENFhLZVVxc0lkWGVpT2VNSVk5?=
 =?utf-8?B?cEFpOGxINmxXUFNpVEx4YzQ2T1V1cVZWUndHdDh5V1B1YkJPMVZyQjRLY2V1?=
 =?utf-8?B?Y3VsL0MyWXVsQytuSDZGM2wrM1BRNVZGMEhFdUo3MitKRlgyRnJ0R3gySlc0?=
 =?utf-8?B?eWJsK2ROQ3Q3YTRnazAyVncyYWUySXZoS25MeGtDMW40NXROUjFHeTh4NGJz?=
 =?utf-8?B?UUtkMmhzcWJudGtZWENOdHRmNExBL2d3TVpmL25DN0s1L21qMDZpWHhQelNK?=
 =?utf-8?B?eURLNW1ZZjA2THNqSW5sVEVTL2lmU0ZsUUg1citKWitpaFZRbStuNHBscXU5?=
 =?utf-8?B?TitSdzA2TzZsY0JiUE5XMm1WV2tXS3BFbzArK2w3OEhlMCt6dytITFZnS3dh?=
 =?utf-8?B?YmVieE1xZE1zS241NWcwcW44T1ZRUFFWZCtYU1c3YWN1Y0VkNkExMVJ2RTF1?=
 =?utf-8?B?cVRaN3RGaDZGeHprN3hpZnl2MThGd1dOSTEyeXJVK1VESUpWdUJHTm5WcUZz?=
 =?utf-8?B?RCtIV2lzaVI3eVVtWFdiU2FLUFpBUkpMYU5lQVFmNmZ4eUhDeDV1UjROSEQy?=
 =?utf-8?B?dGJLM0VKYVlxUTh0U0d0UWsxd3ZCaTB4YkhKUW5sVnhZVlY3Zk9kdGQ1MHUv?=
 =?utf-8?B?QyttZEUrWUNDMlovQjBONVNweDRuYmlmOEwxVGtFakxPWDhxaEM3cEhjdFlq?=
 =?utf-8?B?d2paL0NQdFpXMGxiaGpncVczNnR1MWlFTUJmRGdaY2g4Z0lTU3BTU2pyN1Fx?=
 =?utf-8?B?dEU0aVpib3dFK0k5OHNXTGdLazdMMGFiTTF5YXR2eEh1eC9lSUJabmkvNW1B?=
 =?utf-8?B?MXJreFFvYXg1TG40djFBdllsa21BZGg3NExQeS9ZYXBtUDgwWUsvL3hvQTF6?=
 =?utf-8?B?cjBaVkdoS21pVVd5MTduaHp4VjArV1lZRTZWblZLa1BxWE5ucEZGbENoZ1FZ?=
 =?utf-8?B?azVYNmt4MHB2a0E1cG1WcXREbjZPaGhBMXhQazVrWHhGL1krUzJUZkN2NWFQ?=
 =?utf-8?B?RmlXRk1SM1pJU0UrbmhaNTFNUy85dGNua1NYaUFxcEpnMmVJaXg4KzhmWnFY?=
 =?utf-8?B?QXZSaTRwL2FHOVc3TVhlY2Fkak4wMWhVbkxUTy83aWJXYUlJTHh4M3F2bGxU?=
 =?utf-8?B?VHhERDFFMm1EWDhvbkFiYnVyRUpCRVA2VzljYnB4YlFSaURXRjl3YmR0dTJT?=
 =?utf-8?B?bFJETUt2YVJTSTBBcEMxVVJUUFVvYVVHTkdmdVZMR05PK1l3SjJqUWkwRVEz?=
 =?utf-8?B?ZUZkVGhid2F6M0FRWkNKbVlQRDVNWjZpNzNXQzUvcnJ1R2dSSmROa2poWjVO?=
 =?utf-8?B?bFB6Y3luV2I4bGJock1oUGlMUTU2aGtqU2NVOWNCendEWWJwcWRZOExUZGZz?=
 =?utf-8?B?UC9DaUJLRWttdTEveXk0V3MwTGNON3loVm5DUEJSa1c5WFRXQis5Wml3VDJl?=
 =?utf-8?B?VFpRM1ZLa1FocWliZlZjakZtMlBwSmhCYUlDaWRVVXA1SGlnbC9wVk0rNFJC?=
 =?utf-8?B?cWE2OXZpcGplRUlrcDFDNVdmQ0F0ZkNVeHEyMjhqVHZpVDdHNXFJaW0xNTA4?=
 =?utf-8?B?eUxWQ3VNOHdXWVZocG16YUh0VWw3UjZkQVplUFBsVzJlODYwTWM0WUpITTI0?=
 =?utf-8?B?aDN1T25SSHJnRnp5U2ZLRmw2RUN0Z3JYQWVkeTdkL3Zta2t5a2xnckcycTFp?=
 =?utf-8?B?Q25mZ0RCdzdyVFZSdU5tZkV3NUV4YkVhblE4bmpQMTR0Rm9mMHdCb212VmhU?=
 =?utf-8?Q?EXh6nP857FknbuMCeQ33LsUZlqfW/yXvdZtbdL43uU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <67CD54725501B448BA8A1B1381E98CD8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 51419e73-37fb-4a0d-7490-08dace2dcaa5
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 15:08:49.4881
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: r5AzzJaR2EpxrSiPRWqf+n3UZB4HcUmAyUkYA6HQc/+8+OmUlCe8WPCT9t4STgNYoCW4WIE8dkE1VcNkUj6qbX+07wWEI5mVNW+KeUgwxuw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR11MB6278
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTI0IGF0IDExOjE0ICswMTAwLCBPbGVrc2lqIFJlbXBlbCB3cm90ZToN
Cj4gRVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRz
IHVubGVzcyB5b3UNCj4ga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBLU1o4Nzk1IGFu
ZCBLU1o5NDc3IGNvbXBhdGlibGUgc2VyaWVzIG9mIHN3aXRjaGVzIHVzZSBnbG9iYWwgbWF4DQo+
IGZyYW1lDQo+IHNpemUgY29uZmlndXJhdGlvbiByZWdpc3Rlci4gU28sIGVuYWJsZSBNVFUgbm9y
bWFsaXphdGlvbiBmb3IgdGhpcw0KPiByZWFzb24uDQoNCkFja2VkLWJ5OiBBcnVuIFJhbWFkb3Nz
IDxhcnVuLnJhbWFkb3NzQG1pY3JvY2hpcC5jb20+DQoNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE9s
ZWtzaWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gLS0tDQo+ICBkcml2ZXJz
L25ldC9kc2EvbWljcm9jaGlwL2tzejg3OTUuYyB8IDIgKysNCj4gIGRyaXZlcnMvbmV0L2RzYS9t
aWNyb2NoaXAva3N6OTQ3Ny5jIHwgMiArKw0KPiAgMiBmaWxlcyBjaGFuZ2VkLCA0IGluc2VydGlv
bnMoKykNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tzejg3
OTUuYw0KPiBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6ODc5NS5jDQo+IGluZGV4IGQw
MWJmZDYwOTEzMC4uMDYwZTQxYjliNmVmIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9kc2Ev
bWljcm9jaGlwL2tzejg3OTUuYw0KPiArKysgYi9kcml2ZXJzL25ldC9kc2EvbWljcm9jaGlwL2tz
ejg3OTUuYw0KPiBAQCAtMTM1Nyw2ICsxMzU3LDggQEAgaW50IGtzejhfc2V0dXAoc3RydWN0IGRz
YV9zd2l0Y2ggKmRzKQ0KPiAgICAgICAgIHN0cnVjdCBrc3pfZGV2aWNlICpkZXYgPSBkcy0+cHJp
djsNCj4gICAgICAgICBpbnQgaTsNCj4gDQo+ICsgICAgICAgZHMtPm10dV9lbmZvcmNlbWVudF9p
bmdyZXNzID0gdHJ1ZTsNCj4gKw0KPiAgICAgICAgIGtzel9jZmcoZGV2LCBTX1JFUExBQ0VfVklE
X0NUUkwsIFNXX0ZMT1dfQ1RSTCwgdHJ1ZSk7DQo+IA0KPiAgICAgICAgIC8qIEVuYWJsZSBhdXRv
bWF0aWMgZmFzdCBhZ2luZyB3aGVuIGxpbmsgY2hhbmdlZCBkZXRlY3RlZC4gKi8NCj4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jDQo+IGIvZHJpdmVycy9u
ZXQvZHNhL21pY3JvY2hpcC9rc3o5NDc3LmMNCj4gaW5kZXggZjZlNzk2OGFiMTA1Li40N2I1NGVj
ZjJjNmYgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5j
DQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6OTQ3Ny5jDQo+IEBAIC0xMTM0
LDYgKzExMzQsOCBAQCBpbnQga3N6OTQ3N19zZXR1cChzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMpDQo+
ICAgICAgICAgc3RydWN0IGtzel9kZXZpY2UgKmRldiA9IGRzLT5wcml2Ow0KPiAgICAgICAgIGlu
dCByZXQgPSAwOw0KPiANCj4gKyAgICAgICBkcy0+bXR1X2VuZm9yY2VtZW50X2luZ3Jlc3MgPSB0
cnVlOw0KPiArDQo+ICAgICAgICAgLyogUmVxdWlyZWQgZm9yIHBvcnQgcGFydGl0aW9uaW5nLiAq
Lw0KPiAgICAgICAgIGtzejk0NzdfY2ZnMzIoZGV2LCBSRUdfU1dfUU1fQ1RSTF9fNCwgVU5JQ0FT
VF9WTEFOX0JPVU5EQVJZLA0KPiAgICAgICAgICAgICAgICAgICAgICAgdHJ1ZSk7DQo+IC0tDQo+
IDIuMzAuMg0KPiANCg==
