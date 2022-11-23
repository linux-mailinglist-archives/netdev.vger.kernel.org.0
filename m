Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B96DD6350F7
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 08:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbiKWHLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 02:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235633AbiKWHLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 02:11:11 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A83F72DD;
        Tue, 22 Nov 2022 23:11:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669187464; x=1700723464;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=JtvAc7enjk2fy5yZjrdcfExxE0S0SJgHCzhlldFzB7M=;
  b=ftAccrKVtGBMrG4fdYiKFzJ6J2amVzZK8Xi+fkt9Ld2HsENBRpoyW+2S
   1lpQ1B8do2VfmTcKHbqsHPDJe5L46TYigox4RTWZD2pB7ERsRgFdXtdic
   sFrdhB62Ogmo5Ve+mIikreVcpKz8wKWNovgm+OpP5x1I/XgHwWhZJUXJ9
   //Lc3a75JePRr1blKA0w8ma9UkVDeCxG3jbtM7O//AufO2/xooPFU9Bsv
   x8hxiJpuW9YGzWpOMpQ5UVZjs5v5TE8nieFchrpGUAgj0t7/aAb8+ApGv
   w7hItY2RotJyPRoXzcsgynCtt9HLgqrqNsqgmbyqSyaOCuTZ4Mk93Thl+
   g==;
X-IronPort-AV: E=Sophos;i="5.96,186,1665471600"; 
   d="scan'208";a="190189650"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Nov 2022 00:11:03 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Wed, 23 Nov 2022 00:11:01 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Wed, 23 Nov 2022 00:11:01 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Kui4oyLks0n+aaAlUH+7OivGMVIv6DKBF4iKhqulldTyTMElOr851R7TSjQEwHD5ZZFeXLQ3uOmBiwgtueioE5m8X4xYoMIRPyJi7AY6mRShPFCLH9murB0oJrDZZDqCVEomGpz6pftENpy4msdNJmunz3062yxrSUs9Nvzw/UcYKe/j24hViZXJplCXNxXSyf3whRcS5qFJUz94a3PJMsr38xGm9myKbIvQ4k8eYFi8LMmDdWZOlQ8v4oyUS9t9IFuMCO5UHnmdB/quYaMEJcyDX4cNmyc6I6swKfWhIiANTjVpJEzkBCziD1jyHI7JMHMajqlMTPyiykX+Qlf9Kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JtvAc7enjk2fy5yZjrdcfExxE0S0SJgHCzhlldFzB7M=;
 b=HJzTKuXfe4lCHn2/AG4Nm4EpuqelsIDlzssd7+WWsgBTYplhof7ZuFKxGrXSp4Xj4kA+SwDs5reLdZWgLwfuNRDOCJ2WTjU8M0EE1r8j/0sqSeXS7zOHmer4hI0ZYHxJG9zJKds1o3aCtfLX2PYcgjhmVkyYRpO04zzggmx1YBkezpTppIcWsPwLKvae5t5lqRqTkKyRdJhChnG137ZaIUlenTWaezYmvrM6ZrnNS8UQJCXv5c1BcP4Vpq3Ffj2BvpeSoK8wL5Yi9L8nmOGIFvyBbkwslG5nkBPEjso9+T7Kk5X7DFn3xuje/jd8K74e8wqpbdqagt4wn4l4Jc90mA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JtvAc7enjk2fy5yZjrdcfExxE0S0SJgHCzhlldFzB7M=;
 b=KolPeK71NXftZ8uw0qBg51b3kJiok1wpRWgm71pkFaoXGjHFViKfJcRETFNzLIKBkPlQ3k56/da3Ru04p4YgcOHTdDexdyx95R3htCoKbldbnIP++3453PZfC271anxujmIFVYZpWgsBUjsY+XXODsGjgcJztK1ymvaFvDZVxMs=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 PH7PR11MB7100.namprd11.prod.outlook.com (2603:10b6:510:20f::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Wed, 23 Nov 2022 07:10:58 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 07:10:58 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <richardcochran@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <olteanv@gmail.com>, <linux@armlinux.org.uk>,
        <Tristram.Ha@microchip.com>, <f.fainelli@gmail.com>,
        <kuba@kernel.org>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 1/8] net: ptp: add helper for one-step P2P
 clocks
Thread-Topic: [RFC Patch net-next v2 1/8] net: ptp: add helper for one-step
 P2P clocks
Thread-Index: AQHY/b/VxkKnx5Kv/0CZDjVwUKEHeK5LA3gAgAEWfgA=
Date:   Wed, 23 Nov 2022 07:10:58 +0000
Message-ID: <8de1953d8297c506b58d960fc56edee135d7d8c5.camel@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
         <20221121154150.9573-2-arun.ramadoss@microchip.com>
         <Y3zd4s7c3TPKd/Rb@hoboy.vegasvil.org>
In-Reply-To: <Y3zd4s7c3TPKd/Rb@hoboy.vegasvil.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|PH7PR11MB7100:EE_
x-ms-office365-filtering-correlation-id: d2aeb73e-0670-412e-d9e3-08dacd21dec4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fXjevxpKjRVUAvQUQrSxNrUW0ZZtqgTCEZ/rmkPLL9fCqDHIO8Ok4Yc5e8qOPcrepQhuD7JoGDPH1rbUsmCH7Lp5Y8z+3pk/5HYXx/YwRpXygzFfns/ZH2Ur5URrKoSxaB4XRs92dHS0z0q6yW4PQSkc9TQJmZU3NMjxjv4dzP4JoiManxucmQZGhKWx6m+l1Vl9Qd4ZQNfJzCAcBzJY61wcFQxR0BBexOldL7eliSEzIg+f1c5hA57cBP19aPtDX3IARD2dpVfQF2girGRy0jepkyLI4jcniNLApGSaFb+d83uTlrm8f1slUg7jLh9g9Q91FqJQahckNxF+I//OcBRbOVXDzje+zayBlq6voNQGmXVd4cWYRBY/IIz74USTQ1/VNrSn8dh9fvNp46El6RakOo2PfAFW6x4ZjL0jEG30GMZO2gttCOetMdDfT6fQDK214HOXHGyk049yYv4ARg9PGt134J8bpSPyHNt2ueX3uf92xj5KmbhRuolO6vuR7BiHj2WOjWgwSRHUF3qj4z3sMK6HEWCso+RrxeGHdCBZPZ5Z7CoR/SI8dov17MGPzCLCdW6ZKlMlItqO4cJ/jmx8x/gs3WTHQ4zfn1WCV3Dri41pClLEAZQSd5CfReJQzKIZBs7Wb+ybbldt4lLJW3Z/x5zNNgvs4VdTaBc00z6rw+E0mFvPcX200v5oKCbr/9xsPNnPpdFLFA8Co7/DnYRb81HXpIcXhP9hGzjR6fsqs/86mTTuvg9ENJ1IskPK7Qft0zi6D6hsluO37Zvj78y0XNtV9B1zmsalrvc6RWA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(396003)(366004)(39860400002)(346002)(376002)(451199015)(6512007)(2616005)(83380400001)(186003)(122000001)(76116006)(64756008)(38100700002)(4001150100001)(2906002)(26005)(7416002)(5660300002)(6506007)(4326008)(66476007)(6916009)(66556008)(71200400001)(966005)(8676002)(66946007)(8936002)(316002)(66446008)(41300700001)(478600001)(54906003)(6486002)(91956017)(38070700005)(36756003)(86362001)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R05semw0c29HVkNXaHZLcWkvLy84a2hpQTFZRFNDUFkwR2J0dmRMaEVLK0FM?=
 =?utf-8?B?czQ3RW5hNEEwVHNSdmJuMGdRS0t3RkJTUkZIQW5CV1doR1Z4WmxZWVFaUFNj?=
 =?utf-8?B?QXViSk1RSXdUVCtwUlBqVTFvODlBaDlJVHhOcVlMdmk0QTFQVXI5RGxVVFFo?=
 =?utf-8?B?a2o1cGNRMGZRUVQ1U2dMVnc1Mnd1MVRNKzVUb2pnYVJMMkpIM1g0WUpJZXQr?=
 =?utf-8?B?STdDRG0xcDBPeWlTcVdROGlWcDJoY1UrMUV1a0ppM0xDaWhKYWh2aVpxVm5r?=
 =?utf-8?B?eTNncnRxcVUyMmFkYnFmd1NiUzdPTStaM0ZDRkZkTHd2dnFlUDQ0Q0V0ZUR3?=
 =?utf-8?B?b0lTTEFxb3hreEpKV051STFMY3U0T0xDOTFpVmE3ZHhnZnI1Vmo0ZEIxbzlt?=
 =?utf-8?B?eng5cTVEQU5XWGdKaWRRU3BlSFdhMlo4blBkeW1DNGpXVVRzUlFMQVNZQkd2?=
 =?utf-8?B?aDBlb1FtRXBhVzJtM1JtVytjNHAxOVpBMGtBbm9QL2lRZk1wZHJiOEJyTi9t?=
 =?utf-8?B?U0YrRWprVjV3RlQvL09maEljN1pSWmt4L1BKdjFqOHcrWGlrRzVKWUpYdnJv?=
 =?utf-8?B?S25mZm1oZjV1RnY0Vks5d1g2aDgvYXVSbC9FRTl1MXZjTGZQWGJTMmxjbGMz?=
 =?utf-8?B?MnZuN0NSMFk0c01sNmtxSEZnUDdOcG9xa25LZEJLdDJPN0lwY0ZRTVZSS0hW?=
 =?utf-8?B?NGZRWHNiYmVBZDUyKzh6TFM4SndCSHVNWVJiZ3hYaG56cm1raHRvTWsxVGdR?=
 =?utf-8?B?TG1mNkRLcW9SSUYwSmM4ZmFoVTRQRXNvSmtBbmpYZDRqaDBnaWMwSHplMnRv?=
 =?utf-8?B?alQ5WjBDRU4raDJESlVnSFhRQU4wc2NiSFB5WkNWRnZpRHhiL2JYQWJMME5t?=
 =?utf-8?B?MWFkUnowVHpOTzhVU1BRa2dOZHE1WTkrZjExdHh0R2JWSk9iNGpwZHptQlhl?=
 =?utf-8?B?SVlqR2NtS1FUdk9RMHk0T0FEVEl2L3VBK3lrekhYaGU0V2N3aEhXaFQxNUNN?=
 =?utf-8?B?OHlmWVhCOUpodmplZmtOQmovRHBHSVRCTStheDlBRHBxUy9qcjdtNjA5eVBv?=
 =?utf-8?B?UDdBa1V0dXNkVUVxMFYyVThSRmtwZ05NQUNlTndPRTJ3Tm5mdm1sdmlVNkky?=
 =?utf-8?B?dUJnOTNHV0FDSE5jZnF2Q2prdjR5cUR0dkNCNjZhNXNiN0ZPUUJ1QnV1eFpy?=
 =?utf-8?B?K3E4MzBhOTFIZlpHamhTZE1PNmcxV2xsMkhnWjFQa3MwaFgzdEs2c2t2bWpw?=
 =?utf-8?B?MmlvR3NNMWtENlJvRm5xVTVLNS9xMFpiSmtOWGJIZlkzZk1XZFVVbG5nd2Vx?=
 =?utf-8?B?b1VEWUs0dU5CNFZrLzF4b29DWVlDOStyMlZWNFhYZ3E1bmZnRE1XdzVPZ2Nu?=
 =?utf-8?B?NktneWZuWllNSXBNdHFJaDhEcDZJWm9ialByRUNoNHpkUEtyRnRTY2pYWnpO?=
 =?utf-8?B?NGl1aUNaNkNIcnhUWThEQlhpcVlBUFFneVI4NmZBY0FiaGNxYjRUS05EakNE?=
 =?utf-8?B?eHlJenRFaHFnaEZLckRDNXg5dnN5eUlkUXdnWlk5cGt0ajU1U2EzcFR5NHI0?=
 =?utf-8?B?Y3c2ay9xMlZPS1V2bmdJcEFBakNEdG1zdG1IRWVERklkZ1JWcjcxdVZLOFZ4?=
 =?utf-8?B?WUhDeTFjdTVRcjk1cGcxSmFwYU5pWkZXQTE2YkJKWkNXSVBQa2JYamtwcDZU?=
 =?utf-8?B?dkdSWmVQa2M0c1VkZTRGZVpGVGoyakVDQUZBNWh3QzM3VElGalNmaS9YbnQr?=
 =?utf-8?B?eEpabnYrUGJ2MkV6RkJjeGRDaHk4MHpVMDBEcndpS2xsQ0dnVy92RUVWdE15?=
 =?utf-8?B?UEg4VlhEZkhoRUlZa09tdWtsQ1gveHZZclNtVDdEMXlBRmlsTjVGN0hMNW5m?=
 =?utf-8?B?ZXFMd1ZJZlY0YUJNUEF0ZVZoK25sUXlqbms2SEJhVndXVlNYclFMdjROUzkr?=
 =?utf-8?B?aVNZT0wyQ0VidFZINS9SbmdRRFdiMHdjblF6bWhVWGhIOWV4bnFha284K0FK?=
 =?utf-8?B?NXBHNk43N1RCL3JXWGk2QVEzQVNqOW0xbzZEQ2lYN1RaUXExR24zL2dzZEVt?=
 =?utf-8?B?ZTU5NytLalY3WHlMNmE2RTUzcXR0Q0NvdkFpZ2p2UGVGNy9hSVBKa2xkU0kw?=
 =?utf-8?B?Q1NWYThNc2JsUjliLzNTU2pjdmp2UGRGMlNkOEc4cHFSMjhqOHg0YVdiY29R?=
 =?utf-8?Q?ynmQyY0TSqJT6c7kIJB5zY4=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7DDCA61D1E1BDC47A465686C362AD896@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d2aeb73e-0670-412e-d9e3-08dacd21dec4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 07:10:58.1247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7t1REldAJf/sqeIN8s0BSmAyYqevDlW/MvHzo23m4DY5VYjYb9s41lRlbsKryYiWU88wRf+Uhsvd8pvFXCN+rdQsX/+koBWzhtJBVdCkVvU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB7100
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUmljaGFyZCwNClRoYW5rcyBmb3IgdGhlIGNvbW1lbnQuDQoNCk9uIFR1ZSwgMjAyMi0xMS0y
MiBhdCAwNjozNCAtMDgwMCwgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPiBbU29tZSBwZW9wbGUg
d2hvIHJlY2VpdmVkIHRoaXMgbWVzc2FnZSBkb24ndCBvZnRlbiBnZXQgZW1haWwgZnJvbQ0KPiBy
aWNoYXJkY29jaHJhbkBnbWFpbC5jb20uIExlYXJuIHdoeSB0aGlzIGlzIGltcG9ydGFudCBhdCAN
Cj4gaHR0cHM6Ly9ha2EubXMvTGVhcm5BYm91dFNlbmRlcklkZW50aWZpY2F0aW9uIF0NCj4gDQo+
IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50cyB1
bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gTW9uLCBOb3Yg
MjEsIDIwMjIgYXQgMDk6MTE6NDNQTSArMDUzMCwgQXJ1biBSYW1hZG9zcyB3cm90ZToNCj4gPiAr
LyoqDQo+ID4gKyAqIHB0cF9oZWFkZXJfdXBkYXRlX2NvcnJlY3Rpb24gLSBVcGRhdGUgUFRQIGhl
YWRlcidzIGNvcnJlY3Rpb24NCj4gPiBmaWVsZA0KPiA+ICsgKiBAc2tiOiBwYWNrZXQgYnVmZmVy
DQo+ID4gKyAqIEB0eXBlOiB0eXBlIG9mIHRoZSBwYWNrZXQgKHNlZSBwdHBfY2xhc3NpZnlfcmF3
KCkpDQo+ID4gKyAqIEBoZHI6IHB0cCBoZWFkZXINCj4gPiArICogQGNvcnJlY3Rpb246IG5ldyBj
b3JyZWN0aW9uIHZhbHVlDQo+ID4gKyAqDQo+ID4gKyAqIFRoaXMgdXBkYXRlcyB0aGUgY29ycmVj
dGlvbiBmaWVsZCBvZiBhIFBUUCBoZWFkZXIgYW5kIHVwZGF0ZXMNCj4gPiB0aGUgVURQDQo+ID4g
KyAqIGNoZWNrc3VtIChpZiBVRFAgaXMgdXNlZCBhcyB0cmFuc3BvcnQpLiBJdCBpcyBuZWVkZWQg
Zm9yDQo+ID4gaGFyZHdhcmUgY2FwYWJsZSBvZg0KPiA+ICsgKiBvbmUtc3RlcCBQMlAgdGhhdCBk
b2VzIG5vdCBhbHJlYWR5IG1vZGlmeSB0aGUgY29ycmVjdGlvbiBmaWVsZA0KPiA+IG9mIFBkZWxh
eV9SZXENCj4gPiArICogZXZlbnQgbWVzc2FnZXMgb24gaW5ncmVzcy4NCj4gPiArICovDQo+IA0K
PiBEb2VzIHRoaXMgcmVhbGx5IGJlbG9uZyBpbiB0aGUgY29tbW9uIFBUUCBoZWFkZXI/DQo+IA0K
PiBTZWVtcyBtb3JlIGxpa2UgYSBkcml2ZXIvaGFyZHdhcmUgc3BlY2lmaWMgd29ya2Fyb3VuZCB0
byBtZS4NCg0KVGhpcyBwYXRjaCBzZXJpZXMgaXMgZXh0ZW5zaW9uIG9mIFBUUCBzdXBwb3J0IGZv
ciBLU1o5NTYzIHBhdGNoIHNlcmllcw0Kc3VibWl0dGVkIHR3byB5ZWFycyBiYWNrIHdoaWNoIGlz
IG5vdCBtYWlubGluZWQuDQpJbiB0aGF0IHBhdGNoIHJldmlldyBmZWVkYmFjaywgaXQgd2FzIHN1
Z2dlc3RlZCB0byBtYWtlIHRoaXMgZnVuY3Rpb24NCmdlbmVyaWMgYW5kIHNvIGl0IHdhcyBtb3Zl
ZCBmcm9tIGtzel9jb21tb24uaCB0byBwdHBfY2xhc3NpZnkuaA0KDQpMaW5rOiANCmh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIwMTAyMjExMzI0My40c2hkZHR5d2d2cGNxcTZjQHNr
YnVmLw0KDQoNCmh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIwMTAyMjE0MzQyOS5H
QTk3NDNAaG9ib3kudmVnYXN2aWwub3JnLw0KDQo+IA0KPiBUaGFua3MsDQo+IFJpY2hhcmQNCg==
