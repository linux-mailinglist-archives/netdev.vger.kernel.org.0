Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6A7C5B959A
	for <lists+netdev@lfdr.de>; Thu, 15 Sep 2022 09:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbiIOHnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Sep 2022 03:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiIOHnU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Sep 2022 03:43:20 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE2C9108D;
        Thu, 15 Sep 2022 00:43:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1663227798; x=1694763798;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=60ne6MHqq8Tcd8X8FVWAbG0i5P4JRvDMw01Da0agL30=;
  b=zj8PS/Vvq45QyEXmGuIeHsxRWehnDLPaOYjBazSueO+Hy08yNh8qWb+m
   FtW4tvITAxY//wsCY05oGQxjyPO6UmG/l3va/32qC3kFFsv3j0zOEyl2H
   pzD1YPlQ8ZRvfTQSHF+40+ylrt7YlwFmfBD2wXopQgwXJFVUVwF3wrfo+
   MZ1hNdPz4JJRdK1qGLJBtQXIahw2ZtMKyBYJg0VLmdHdYcM+ek/9ORD2T
   ackgy3hPHoYaMEqr7bubT++MYP6oPv7NIT2+GeP9QKdjRofc4Je3t7qRM
   bWzNMxO/ocyZc1/D5R7203+KhbGTkva5prrck+bvfqM9SyTW0CYE4D1Tc
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,317,1654585200"; 
   d="scan'208";a="113783238"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 15 Sep 2022 00:43:17 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 15 Sep 2022 00:43:17 -0700
Received: from NAM04-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 15 Sep 2022 00:43:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AOYG+ANYISWkbHWNT65NEiYmVLrEaz6c25U3C1vcm3nY+wRI6J5yoAUj44cM3bNAQyJJ2OfQtLluI58Vd8NIZVSF3gunfhEAuW6UCy9LxOIRuvu6zOz58U2zNsBQM0nU2TrfGjeHwSq0zbsWHVjUIUsWrVCn1LA2WPBhtCuLZub4YHGfg5lBXqRHaAn0c1vsRD0WlCTkfljpFIHcf3nSwsWQWNBU7marbKkfCgK1uZXZwrIGIR6oHsAR6N1lb7WpXS7BK/WYr5onFlSk2uj4rdaMlbVJhLYqwWsZEvjLEN7x/zFm6vMtVZKdTrKtVpiKhxROhdWIzVVqcnEQJ80Y/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=60ne6MHqq8Tcd8X8FVWAbG0i5P4JRvDMw01Da0agL30=;
 b=Gr4szzw1RuTqf8y+OKgmP8pZA7gn5wh3SJXGBY1snNCUgZtt1zlHLpVaVgTE54bBy2VCkkD0+VO5jHWX7D4+uX+tCnDK+264OTqqEBW8A5FlthPaTPAItaSuSgf7GVXB96QtdwMsry/lOjZZtqL4kDfXaf6LKs7eCfPAoVlFjWXO1aG89CjiLqbf6RtEb5arLxXU6FzqVd974c5KIxF1QfpOoVlIB9dqWYwMQIpVBrA2kfa4JVqRh1uobqHx1vVGB2L2RqN6ABhH6BaPJxY/ipKbDDIKl7JhymkNNXjeYBjJt7RMG/aloXH1cJIllOQUCGl4PPA/0EahMUPPmznmag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=60ne6MHqq8Tcd8X8FVWAbG0i5P4JRvDMw01Da0agL30=;
 b=GFyaOybON47MVcNF+BTOwp1FWNwCzlW6cgREo91JpeBoq6xN0US+eSx+XsvHKOykYc/FlDKCWnVzQAB9y7gKOIBbFBmlH4pHrBKeRQnxTbJvBqLiR8DFfekXgitP6Suf1TVi/KYLYlErGu4HJn87Ox1lKu9Q+W8+mm0OZWdLoGg=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by MW4PR11MB6761.namprd11.prod.outlook.com (2603:10b6:303:20d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5632.15; Thu, 15 Sep
 2022 07:43:11 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::a159:97ec:24bc:6610]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::a159:97ec:24bc:6610%11]) with mapi id 15.20.5632.015; Thu, 15 Sep
 2022 07:43:11 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <andrew@lunn.ch>,
        <Conor.Dooley@microchip.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@amd.com>, <ronak.jain@xilinx.com>
Subject: Re: [PATCH v3 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Topic: [PATCH v3 net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Index: AQHYyNbONHT7Ph2SKUWd33IpeQBXhQ==
Date:   Thu, 15 Sep 2022 07:43:11 +0000
Message-ID: <dc38ae51-7f92-0e7c-c665-d674b66585c7@microchip.com>
References: <1663158796-14869-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1663158796-14869-2-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1663158796-14869-2-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BN6PR11MB1953:EE_|MW4PR11MB6761:EE_
x-ms-office365-filtering-correlation-id: 491cb883-cd57-45a1-9331-08da96edf093
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GmDj7ULdVkRxq3iVv0B34DQfPh4/5cLIcDtlQEYRsvtmKdE2IY/+EDuZcUz5Kdv+K7Cwln2yH9S4z9/ifcebzw4HVYG9bmgIrVDyOswJJH+wlRZzOg9z9AiornoY3I1tuDQS65cRQJMlIdpMKKlAC+5OJA1rwo9XpyM0qpH7GKzNNZ6WzaD428svMfS3eKANzg7ujV9N3Z1q5FMAg+OvVE4XoQl3uTI2LsMIe6xSwFFMfm2LnnKYvCwjsathS3aCUGpd4aFrpoj4qRtbzUaXab1wO1OQcpX7YoyDe3n9CIn6Vd8THIFIJRnzqx09zEnmBS+r2aXfdv7ZiyIqDh8fgpbM2KA1gPMB1YsQGvRx81bzfQL/2RmsItB+0yKgdQaV5PddSdYjZ6VbWKBAdQctGrnVzUHyvOzdJI8Ergd4qZmhFx0QWK1bUUrluaO+tU0lITalWBWInPku2cF5meTXBbmgwGkmV7WJCWoA7gw1r7N1B3EkuxJgSjIsSUs7f281jofvA6tRml76x9UFqpkEiYDipqgq2m9zVmFGjNNjhjKNXAWQdnKkM00a2FfolNFnpLsSXUvkhVqWxQbeS8KHoHINau4UWOhKRvHxszxdOhk7E60oEzIQ0MBYVesGfo+V/0h7bjmK96E6U+nzrkni7avjGOfrBLtZ+9/sKnzn4Q1beZ4fXI5WKuM8fTECtwn1jVx6DYQGX6r0VOk7JgAVhfHPlCmcgQHb5nuRKaaENAw35g4Z6+St9KWk4ey4ppzZ6TwsK6Q0ybR7tvri4fUJHEwQgfIUxCY7GOb8iBCE3Pahb7CVzeZAxkxFZEoMIPQ8v0lgN2JC81n7I40qwblD1AjyG5TnSE1JpNcufjlCumY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(396003)(346002)(366004)(136003)(451199015)(76116006)(91956017)(31686004)(66946007)(38100700002)(2906002)(64756008)(66556008)(66476007)(8676002)(4326008)(66446008)(921005)(6636002)(26005)(122000001)(478600001)(41300700001)(2616005)(6486002)(5660300002)(36756003)(110136005)(186003)(53546011)(31696002)(54906003)(6512007)(7416002)(86362001)(6506007)(8936002)(38070700005)(71200400001)(316002)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?S0pMNFNxVEh4MTVRc3paWUZlVVBNS1pQZDA2aFBWMTZwTGMzcHpTL00zL3J3?=
 =?utf-8?B?ZHhabURlMk9kRHBTNkk0dDJScUVwUVNIZ1lzQ3dRRTBCZHVucGxIZjErT2Q3?=
 =?utf-8?B?d0dCbnpjcThyUUhGaE1Hd0tIOWNUVmtuZ09vMlNRUkNGOURkTkhWSmtIcmJD?=
 =?utf-8?B?SDJSejM0OGJaNEcrSWRvbmxXKy9WUFBROGdyNU9JdlcvaEJoSXZJRXdKOHNu?=
 =?utf-8?B?L2U0RGpya1Mrb21HamNnQnlTUzRmbEdvNS9tYzI3YnFBbWtwblZHa1NWUyti?=
 =?utf-8?B?SlRBZGdvbCt5cFU3YlcyNXdzRWNrWmVWbWw0ZytSN2NHbXl3bmk4QldEVGJM?=
 =?utf-8?B?ZjYxbXpFb2RNNi9jSU5xa25Ic3dHQWxQcTBTSEl4ekltUDc1Wm5aSXJCSVBL?=
 =?utf-8?B?aWM4eEdFTCtGUEMxRmx0eEMwYzVNVzRWUHdXTmk5T3FuaHJhVGs5d1pXU2tI?=
 =?utf-8?B?N05hMk0yODZtbEpxRWF2YzlwNVVBOGNsNGZzNXlXbTVuY2pSTjRYQ0Fqamsz?=
 =?utf-8?B?QVlMUTFHV2IzWEhEYUd5bFdDZVZ2LzBoL2xERlpBaUdSbGJZTjNlaVhIVFJM?=
 =?utf-8?B?QnRtM2Uybm1nckQyY00rRkM2NDRFMnVGUnpuRUxUck4xelNkbE4yREVxbW5o?=
 =?utf-8?B?dlRjY2lock4wRTdDMGNwZVNwQUlybllBZEdRckczcE1HVFBsV2hMNENPeTdn?=
 =?utf-8?B?cVRkelk1VU1WNVVrNUxpSW1MZXgwUGg1MkdVcTVnV1FpYk1TMnllZGZuOVoy?=
 =?utf-8?B?T3dRTVdacHMyOW9xcDIySVFJNFpJeCs1Tys5QWd4c2FoUVlqdjk5SzNLSmV5?=
 =?utf-8?B?MkZybXgyVVVwSWZTNno4QlN4bnowREU3bWowK0N0MzNSU0Mwb3hkWlhtNDVz?=
 =?utf-8?B?VXN4cmVXTFJXK3JiNFZhRi9ZMVpLRXhITkljRFhOZllxMnIvTTFJclUybzZ0?=
 =?utf-8?B?TGxFdFZBOUt6OFUwSUlFUmpEMGpqMEFMaGp3bU45SWgrVm5MQlF3ajZaTHZ2?=
 =?utf-8?B?RjZtNy9KZ1hiWXVjelRNcGRCbDFKY2RxR3h0K1BEVXk0K2NqeDRMNkpFd2ZJ?=
 =?utf-8?B?TUpaYUZ0TTUzT1JkTUFnUXRMZ2Y3RTJZOG1JYmxMU3F5djIvZEV2TmpiY2tp?=
 =?utf-8?B?dWV4dU5YMnYyRHhkYnNmQ0hnNjZyOEVORkdybnpuZGFDaGdTQjN6Y1daUWhK?=
 =?utf-8?B?UEJSSmEvNFFFR2xGNEtvYXprS201YS94RmhERkdiWkpyTjZaRmJwSE44WEc5?=
 =?utf-8?B?TVYyODRIZksvT2dVNzIvK2NaeGJYSS8wOHNoK2FiNm1lTG5OdTBRZUY0N2dr?=
 =?utf-8?B?em5oV0hvendLWDh4NFFCUEYyNHlPcE13NWFDWmJJTDFUN1lienlZRmNoOVZW?=
 =?utf-8?B?RXkyUnNHbUFsdSttc25vRWdiNURQS2RlUzZwelpITDZyaUtmaE5rVy9FazlM?=
 =?utf-8?B?RE5zbm9GcThrYjlxMEFxMzlzQVV0MkZEdFdBSHFIc1h1a2pWVWcybmg3alNk?=
 =?utf-8?B?R3VXd3JQcXhqZ2RBU3RzKzBDQVFvbENaZ25DMURhRWlFdG5UdXl1RytWV3Vs?=
 =?utf-8?B?V01UUlNhMzhJZk9NVERzTUpLSWZCVXQzZmFCbkMwcHZtcjF0L1dvMGF1akxN?=
 =?utf-8?B?QVp5QWlYaDdzMVlnL2hVWEp4Z252UUNpK0thOFUvOUkyaUg1bGEwdHUzTjZ0?=
 =?utf-8?B?aUNhdDZDQ3VoeS93RW1pM3pDdVpwSEN1enhSaEhicDNGNDE3NFJhSUtZekls?=
 =?utf-8?B?cjlBVVlkRWIxMUJqMlBzOEhkRWhnRHo5TDduOGZCbDcweXhqMmFUWGIvcXk1?=
 =?utf-8?B?aFlqa0JLSVBvWk1zQ0EvZi84K1RkTE42VXdiT3J1OVNrUTR4R29ZemwzL25x?=
 =?utf-8?B?Y242M3d3QzVwZ3ozcG5nSytjZTlkamdidkdOeGRocG0zUHA5eGpvSVVhZlJY?=
 =?utf-8?B?YlRHbzlYcEVtUDZCZ2pBRmhEZjdPci81Ykxkbk03WVBwQ0ZWcWRkQkNxOGtw?=
 =?utf-8?B?YXppMHdRL2NvU3dpbDlmOXB5eVo2bitPcDlsMDJVZ3QrTXQvR0xXWlcwRWxw?=
 =?utf-8?B?ZEZHRDNCL1dlSWQySHhEVlllUzVObU55M2hWQlBjUFBhSlo5NGltQWdnZTdZ?=
 =?utf-8?B?bGEzbnQ0QVRlWjhtVTZiOHRIMjRRbkZTS3JvaFN4clFhYkQ4cEc1Sjk4dDJ1?=
 =?utf-8?B?aGc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C587070FF663354A923718B57D6EDF61@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 491cb883-cd57-45a1-9331-08da96edf093
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Sep 2022 07:43:11.3652
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ECbDdPFt//dTExAnOB8nHcAfxT6SppLuFgtxtpA+Ga/HlZ+xfCJgtqPC/rtR/ymMJtSGf3KkHiZO68/X/wncx4reaK3pOfHIRHvvWXbryyc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6761
X-Spam-Status: No, score=-6.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTQuMDkuMjAyMiAxNTozMywgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBGcm9tOiBSb25hayBKYWluIDxyb25h
ay5qYWluQHhpbGlueC5jb20+DQo+IA0KPiBBZGQgbmV3IEFQSXMgaW4gZmlybXdhcmUgdG8gY29u
ZmlndXJlIFNEL0dFTSByZWdpc3RlcnMuIEludGVybmFsbHkNCj4gaXQgY2FsbHMgUE0gSU9DVEwg
Zm9yIGJlbG93IFNEL0dFTSByZWdpc3RlciBjb25maWd1cmF0aW9uOg0KPiAtIFNEL0VNTUMgc2Vs
ZWN0DQo+IC0gU0Qgc2xvdCB0eXBlDQo+IC0gU0QgYmFzZSBjbG9jaw0KPiAtIFNEIDggYml0IHN1
cHBvcnQNCj4gLSBTRCBmaXhlZCBjb25maWcNCj4gLSBHRU0gU0dNSUkgTW9kZQ0KPiAtIEdFTSBm
aXhlZCBjb25maWcNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJvbmFrIEphaW4gPHJvbmFrLmphaW5A
eGlsaW54LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5
LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KDQpSZXZpZXdlZC1ieTogQ2xhdWRpdSBCZXpuZWEgPGNs
YXVkaXUuYmV6bmVhQG1pY3JvY2hpcC5jb20+DQoNCg0KPiAtLS0NCj4gLSBDaGFuZ2VzIGZvciB2
MzoNCj4gICBVc2UgZW51bSBrZXJuZWwtZG9jIGNvbW1lbnQgc3R5bGUgZm9yIGVudW0gcG1fc2Rf
Y29uZmlnX3R5cGUgYW5kDQo+ICAgcG1fZ2VtX2NvbmZpZ190eXBlLg0KPiANCj4gLSBDaGFuZ2Vz
IGZvciB2MjoNCj4gICBVc2UgdGFiIGluZGVudCBmb3IgenlucW1wX3BtX3NldF9zZC9nZW1fY29u
ZmlnKCkgcmV0dXJuDQo+ICAgZG9jdW1lbnRhdGlvbg0KPiAtLS0NCj4gIGRyaXZlcnMvZmlybXdh
cmUveGlsaW54L3p5bnFtcC5jICAgICB8IDMxICsrKysrKysrKysrKysrKysrKysNCj4gIGluY2x1
ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaCB8IDQ1ICsrKysrKysrKysrKysrKysrKysr
KysrKysrKysNCj4gIDIgZmlsZXMgY2hhbmdlZCwgNzYgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlm
ZiAtLWdpdCBhL2RyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jIGIvZHJpdmVycy9maXJt
d2FyZS94aWxpbngvenlucW1wLmMNCj4gaW5kZXggZDFmNjUyODAyMTgxLi5mZjVjYWJlNzBhMmIg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jDQo+ICsrKyBi
L2RyaXZlcnMvZmlybXdhcmUveGlsaW54L3p5bnFtcC5jDQo+IEBAIC0xMzExLDYgKzEzMTEsMzcg
QEAgaW50IHp5bnFtcF9wbV9nZXRfZmVhdHVyZV9jb25maWcoZW51bSBwbV9mZWF0dXJlX2NvbmZp
Z19pZCBpZCwNCj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBpZCwgMCwgcGF5
bG9hZCk7DQo+ICB9DQo+IA0KPiArLyoqDQo+ICsgKiB6eW5xbXBfcG1fc2V0X3NkX2NvbmZpZyAt
IFBNIGNhbGwgdG8gc2V0IHZhbHVlIG9mIFNEIGNvbmZpZyByZWdpc3RlcnMNCj4gKyAqIEBub2Rl
OiAgICAgIFNEIG5vZGUgSUQNCj4gKyAqIEBjb25maWc6ICAgIFRoZSBjb25maWcgdHlwZSBvZiBT
RCByZWdpc3RlcnMNCj4gKyAqIEB2YWx1ZTogICAgIFZhbHVlIHRvIGJlIHNldA0KPiArICoNCj4g
KyAqIFJldHVybjogICAgIFJldHVybnMgMCBvbiBzdWNjZXNzIG9yIGVycm9yIHZhbHVlIG9uIGZh
aWx1cmUuDQo+ICsgKi8NCj4gK2ludCB6eW5xbXBfcG1fc2V0X3NkX2NvbmZpZyh1MzIgbm9kZSwg
ZW51bSBwbV9zZF9jb25maWdfdHlwZSBjb25maWcsIHUzMiB2YWx1ZSkNCj4gK3sNCj4gKyAgICAg
ICByZXR1cm4genlucW1wX3BtX2ludm9rZV9mbihQTV9JT0NUTCwgbm9kZSwgSU9DVExfU0VUX1NE
X0NPTkZJRywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25maWcsIHZh
bHVlLCBOVUxMKTsNCj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHp5bnFtcF9wbV9zZXRfc2Rf
Y29uZmlnKTsNCj4gKw0KPiArLyoqDQo+ICsgKiB6eW5xbXBfcG1fc2V0X2dlbV9jb25maWcgLSBQ
TSBjYWxsIHRvIHNldCB2YWx1ZSBvZiBHRU0gY29uZmlnIHJlZ2lzdGVycw0KPiArICogQG5vZGU6
ICAgICAgR0VNIG5vZGUgSUQNCj4gKyAqIEBjb25maWc6ICAgIFRoZSBjb25maWcgdHlwZSBvZiBH
RU0gcmVnaXN0ZXJzDQo+ICsgKiBAdmFsdWU6ICAgICBWYWx1ZSB0byBiZSBzZXQNCj4gKyAqDQo+
ICsgKiBSZXR1cm46ICAgICBSZXR1cm5zIDAgb24gc3VjY2VzcyBvciBlcnJvciB2YWx1ZSBvbiBm
YWlsdXJlLg0KPiArICovDQo+ICtpbnQgenlucW1wX3BtX3NldF9nZW1fY29uZmlnKHUzMiBub2Rl
LCBlbnVtIHBtX2dlbV9jb25maWdfdHlwZSBjb25maWcsDQo+ICsgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgdTMyIHZhbHVlKQ0KPiArew0KPiArICAgICAgIHJldHVybiB6eW5xbXBfcG1faW52
b2tlX2ZuKFBNX0lPQ1RMLCBub2RlLCBJT0NUTF9TRVRfR0VNX0NPTkZJRywNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICBjb25maWcsIHZhbHVlLCBOVUxMKTsNCj4gK30NCj4g
K0VYUE9SVF9TWU1CT0xfR1BMKHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyk7DQo+ICsNCj4gIC8q
Kg0KPiAgICogc3RydWN0IHp5bnFtcF9wbV9zaHV0ZG93bl9zY29wZSAtIFN0cnVjdCBmb3Igc2h1
dGRvd24gc2NvcGUNCj4gICAqIEBzdWJ0eXBlOiAgIFNodXRkb3duIHN1YnR5cGUNCj4gZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaCBiL2luY2x1ZGUvbGlu
dXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0KPiBpbmRleCA5ZjUwZGFjYmY3ZDYuLjc2ZDJiM2Vi
YWQ4NCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9maXJtd2FyZS94bG54LXp5bnFtcC5o
DQo+ICsrKyBiL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0KPiBAQCAtMTUz
LDYgKzE1Myw5IEBAIGVudW0gcG1faW9jdGxfaWQgew0KPiAgICAgICAgIC8qIFJ1bnRpbWUgZmVh
dHVyZSBjb25maWd1cmF0aW9uICovDQo+ICAgICAgICAgSU9DVExfU0VUX0ZFQVRVUkVfQ09ORklH
ID0gMjYsDQo+ICAgICAgICAgSU9DVExfR0VUX0ZFQVRVUkVfQ09ORklHID0gMjcsDQo+ICsgICAg
ICAgLyogRHluYW1pYyBTRC9HRU0gY29uZmlndXJhdGlvbiAqLw0KPiArICAgICAgIElPQ1RMX1NF
VF9TRF9DT05GSUcgPSAzMCwNCj4gKyAgICAgICBJT0NUTF9TRVRfR0VNX0NPTkZJRyA9IDMxLA0K
PiAgfTsNCj4gDQo+ICBlbnVtIHBtX3F1ZXJ5X2lkIHsNCj4gQEAgLTM5OSw2ICs0MDIsMzAgQEAg
ZW51bSBwbV9mZWF0dXJlX2NvbmZpZ19pZCB7DQo+ICAgICAgICAgUE1fRkVBVFVSRV9FWFRXRFRf
VkFMVUUgPSA0LA0KPiAgfTsNCj4gDQo+ICsvKioNCj4gKyAqIGVudW0gcG1fc2RfY29uZmlnX3R5
cGUgLSBQTSBTRCBjb25maWd1cmF0aW9uLg0KPiArICogQFNEX0NPTkZJR19FTU1DX1NFTDogVG8g
c2V0IFNEX0VNTUNfU0VMIGluIENUUkxfUkVHX1NEIGFuZCBTRF9TTE9UVFlQRQ0KPiArICogQFNE
X0NPTkZJR19CQVNFQ0xLOiBUbyBzZXQgU0RfQkFTRUNMSyBpbiBTRF9DT05GSUdfUkVHMQ0KPiAr
ICogQFNEX0NPTkZJR184QklUOiBUbyBzZXQgU0RfOEJJVCBpbiBTRF9DT05GSUdfUkVHMg0KPiAr
ICogQFNEX0NPTkZJR19GSVhFRDogVG8gc2V0IGZpeGVkIGNvbmZpZyByZWdpc3RlcnMNCj4gKyAq
Lw0KPiArZW51bSBwbV9zZF9jb25maWdfdHlwZSB7DQo+ICsgICAgICAgU0RfQ09ORklHX0VNTUNf
U0VMID0gMSwNCj4gKyAgICAgICBTRF9DT05GSUdfQkFTRUNMSyA9IDIsDQo+ICsgICAgICAgU0Rf
Q09ORklHXzhCSVQgPSAzLA0KPiArICAgICAgIFNEX0NPTkZJR19GSVhFRCA9IDQsDQo+ICt9Ow0K
PiArDQo+ICsvKioNCj4gKyAqIGVudW0gcG1fZ2VtX2NvbmZpZ190eXBlIC0gUE0gR0VNIGNvbmZp
Z3VyYXRpb24uDQo+ICsgKiBAR0VNX0NPTkZJR19TR01JSV9NT0RFOiBUbyBzZXQgR0VNX1NHTUlJ
X01PREUgaW4gR0VNX0NMS19DVFJMIHJlZ2lzdGVyDQo+ICsgKiBAR0VNX0NPTkZJR19GSVhFRDog
VG8gc2V0IGZpeGVkIGNvbmZpZyByZWdpc3RlcnMNCj4gKyAqLw0KPiArZW51bSBwbV9nZW1fY29u
ZmlnX3R5cGUgew0KPiArICAgICAgIEdFTV9DT05GSUdfU0dNSUlfTU9ERSA9IDEsDQo+ICsgICAg
ICAgR0VNX0NPTkZJR19GSVhFRCA9IDIsDQo+ICt9Ow0KPiArDQo+ICAvKioNCj4gICAqIHN0cnVj
dCB6eW5xbXBfcG1fcXVlcnlfZGF0YSAtIFBNIHF1ZXJ5IGRhdGENCj4gICAqIEBxaWQ6ICAgICAg
IHF1ZXJ5IElEDQo+IEBAIC00NzUsNiArNTAyLDkgQEAgaW50IHp5bnFtcF9wbV9pc19mdW5jdGlv
bl9zdXBwb3J0ZWQoY29uc3QgdTMyIGFwaV9pZCwgY29uc3QgdTMyIGlkKTsNCj4gIGludCB6eW5x
bXBfcG1fc2V0X2ZlYXR1cmVfY29uZmlnKGVudW0gcG1fZmVhdHVyZV9jb25maWdfaWQgaWQsIHUz
MiB2YWx1ZSk7DQo+ICBpbnQgenlucW1wX3BtX2dldF9mZWF0dXJlX2NvbmZpZyhlbnVtIHBtX2Zl
YXR1cmVfY29uZmlnX2lkIGlkLCB1MzIgKnBheWxvYWQpOw0KPiAgaW50IHp5bnFtcF9wbV9yZWdp
c3Rlcl9zZ2kodTMyIHNnaV9udW0sIHUzMiByZXNldCk7DQo+ICtpbnQgenlucW1wX3BtX3NldF9z
ZF9jb25maWcodTMyIG5vZGUsIGVudW0gcG1fc2RfY29uZmlnX3R5cGUgY29uZmlnLCB1MzIgdmFs
dWUpOw0KPiAraW50IHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyh1MzIgbm9kZSwgZW51bSBwbV9n
ZW1fY29uZmlnX3R5cGUgY29uZmlnLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgIHUz
MiB2YWx1ZSk7DQo+ICAjZWxzZQ0KPiAgc3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX2dldF9h
cGlfdmVyc2lvbih1MzIgKnZlcnNpb24pDQo+ICB7DQo+IEBAIC03NDUsNiArNzc1LDIxIEBAIHN0
YXRpYyBpbmxpbmUgaW50IHp5bnFtcF9wbV9yZWdpc3Rlcl9zZ2kodTMyIHNnaV9udW0sIHUzMiBy
ZXNldCkNCj4gIHsNCj4gICAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gIH0NCj4gKw0KPiArc3Rh
dGljIGlubGluZSBpbnQgenlucW1wX3BtX3NldF9zZF9jb25maWcodTMyIG5vZGUsDQo+ICsgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVudW0gcG1fc2RfY29uZmlnX3R5
cGUgY29uZmlnLA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1
MzIgdmFsdWUpDQo+ICt7DQo+ICsgICAgICAgcmV0dXJuIC1FTk9ERVY7DQo+ICt9DQo+ICsNCj4g
K3N0YXRpYyBpbmxpbmUgaW50IHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyh1MzIgbm9kZSwNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGVudW0gcG1fZ2VtX2Nv
bmZpZ190eXBlIGNvbmZpZywNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgIHUzMiB2YWx1ZSkNCj4gK3sNCj4gKyAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gK30N
Cj4gKw0KPiAgI2VuZGlmDQo+IA0KPiAgI2VuZGlmIC8qIF9fRklSTVdBUkVfWllOUU1QX0hfXyAq
Lw0KPiAtLQ0KPiAyLjI1LjENCj4gDQoNCg==
