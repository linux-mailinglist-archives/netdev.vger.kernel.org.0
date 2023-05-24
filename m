Return-Path: <netdev+bounces-5032-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D336670F780
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 15:21:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8DAA728125C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 13:21:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3127C2E5;
	Wed, 24 May 2023 13:21:47 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE36660870
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 13:21:47 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F3CE58;
	Wed, 24 May 2023 06:21:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1684934505; x=1716470505;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=5vC500yYG5G3DX0pQ1eIK7ai9BbSKygTpylcys9tyFc=;
  b=w+9Edr2omUhBjurdnrOJiPwL/jK6o+bXS/UhmTV34BghVchi5YTQduYF
   2ArrO6xw0I/1/Mwhv/HDBaq8PtuP7er6kR38X1+CDclQsnp4Kbiw15bqB
   LMbZcZjOGRXFhnozhcLycspDiy6cRnFoYfNP1B52Zxwgs235x9508p3tB
   C5BQ3zGo0t4fzGPUqg2qVZWu4AgZ++vml2OqpFVjDMJLpozd2jolou2Tv
   tZQzwbyBbLsVp0tBI9A/eN1bV7LazlQtUKZT0OfEP6fOS6n7ZyKUtyOxh
   XjNC7JKs0cf2kh2ESyP03h6BjXSSqpxZ5UgKwyNO63/e8IbWX1KxT94wT
   g==;
X-IronPort-AV: E=Sophos;i="6.00,189,1681196400"; 
   d="scan'208";a="214702347"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 May 2023 06:21:45 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Wed, 24 May 2023 06:21:44 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Wed, 24 May 2023 06:21:44 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UessMC55aGCN1eifQ+ma+cfsuy+Vtw4470T9r6PNjztBGUA9Ucobdx+Kz0lpuWC+SzGphykh5hxtgOyW7gaQZC/0WcFkzDzm2VN3hGpOKqONXm4vrF/pMNC0ZHRHF/iK0uuYCspWj1KVe0ZcIchN/V4At+Ojw/8OJJMdBKrxLbb4KEp0pSk+SVzG6qzb0f6mlX8upX+dN7P7PezExMV0qdzHhv0ddZZNH5yGgvR86k/BHSs6i/6XDPBuBDu4EF+gVsChtVWK4q2KkkJ/BY1YslWhnvZlMcQce07Bt6PmQ1FS/aBUZtfkLnaGGyCgFA1ffjJr6WqrYVMmTkVkTXsegg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5vC500yYG5G3DX0pQ1eIK7ai9BbSKygTpylcys9tyFc=;
 b=IUit/qSW/kJtKTEurhUtWJ1r+q+GevOk5wDHJyyEnN02+sSApuYPgmOhybQJuk1uoGa6u4jqDs+C/G2n8RRiUQ89Q11P9HmMFNFgE+NDWfVvo/FP39kUQiqMHrw4AL6pCDMBVg8EIG5LdvvJowP8ztOhNDCnxnvwa5h+ndyMv86PKmaABDc5LUZsar4I0Rbv8sAQj+9pDzCIbraPn2ywqVTQEiKUFO+6m3kPH2z5MvV3T9pOiFZPy3uMQYXRK+f4UCjSUBnPuCn/0HmucheKNlD/foCgSoayWc5Knopx6oE+jObj2fTRGKHc+0i1Ct5V66GvosdQcTsR9UQuedRuxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5vC500yYG5G3DX0pQ1eIK7ai9BbSKygTpylcys9tyFc=;
 b=TCivwPcjtX6mvdPctI9pNPbm4pitS+rhqhUtEvP/XaeLx41Egqgw47aEw4zWdiIqKBgP09qVMRnoVSBeSQoZbbc8RBY3UmUaDy436lrtseXLm2n0CcmXWI6JCYI/G/ZFqxqWrOFoNi6uzIxv01q6EVnsrLZU6o+cR1K6YrQbTAo=
Received: from DM6PR11MB3532.namprd11.prod.outlook.com (2603:10b6:5:70::25) by
 DS7PR11MB7888.namprd11.prod.outlook.com (2603:10b6:8:e6::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6411.28; Wed, 24 May 2023 13:21:42 +0000
Received: from DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570]) by DM6PR11MB3532.namprd11.prod.outlook.com
 ([fe80::ba23:4a94:b951:f570%7]) with mapi id 15.20.6411.027; Wed, 24 May 2023
 13:21:42 +0000
From: <Parthiban.Veerasooran@microchip.com>
To: <andrew@lunn.ch>
CC: <hkallweit1@gmail.com>, <linux@armlinux.org.uk>, <davem@davemloft.net>,
	<edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<ramon.nordin.rodriguez@ferroamp.se>, <Horatiu.Vultur@microchip.com>,
	<Woojung.Huh@microchip.com>, <Nicolas.Ferre@microchip.com>,
	<Thorsten.Kummermehr@microchip.com>
Subject: Re: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Topic: [PATCH net-next v2 4/6] net: phy: microchip_t1s: fix reset
 complete status handling
Thread-Index: AQHZjKFISJBP+UyLBEKuwTcTckxbq69mPN6AgAEZewCAAHNJAIABQN8AgABLzQCAABYkgA==
Date: Wed, 24 May 2023 13:21:42 +0000
Message-ID: <07fb7d24-93c3-6090-d17c-e799df7c3283@microchip.com>
References: <20230522113331.36872-1-Parthiban.Veerasooran@microchip.com>
 <20230522113331.36872-5-Parthiban.Veerasooran@microchip.com>
 <f0769755-6d04-4bf5-a273-c19b1b76f7f6@lunn.ch>
 <b226c865-d4a7-c126-9e54-60498232b5a5@microchip.com>
 <e9db9ce6-dee8-4a78-bfa4-aace4ae88257@lunn.ch>
 <2523bd58-2b2c-723f-6261-aa44ca92e00a@microchip.com>
 <e0ea8a35-3ea6-43a5-bb5b-a914f86cd492@lunn.ch>
In-Reply-To: <e0ea8a35-3ea6-43a5-bb5b-a914f86cd492@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB3532:EE_|DS7PR11MB7888:EE_
x-ms-office365-filtering-correlation-id: 43a3a445-cc66-4b4a-ae54-08db5c59d0bc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n0rU8zKzeZABGIdb7fdmc3BGuNS8Ps6E79HFHlrTDJG+rSvE04bn+j4Nu68OTO8/MkLG4N0E9hjYGi6dcktUgoMLwOzEaRqEoPshcJn9ctcgqfPvCny/ahmmfNrljzygik7RrUMOjDryvsJVpJWP7/80nMQYlVONeaRarKiAXaAPfMRmy9f19m9UKBvfzYkojciUKY2Vn5N10oXIkNznEBPpdhaurGIChm/znMCqQzDTz9a743Vgmxvjy/qWj9eFX6fEGR4WURX7wlcsJy6kKaHEBC5QiZWfEmK35DhRrTFv4YpzOsZN14w8s9M+I8lRstO4cehgzkyT6Tj6T/jR3OaZgzL2AZ1MdvjJy2+R31A6iuBDEUfb/pdAOz+cVbm1UAfojL51WDtFPo3b1GFLZNIa7Y80ScoR5aocco85RcnFQx+ooj9r6Yr6w5p+xzfES8f9xcWwslLukH4bxNyQWHzxRHzDspJamen6Jd2eSxyXNSZdUQedoZ3jWMCHi2YEG3taCePlqtVVSFpWddcIWbyv4Y8FG9FyxtkdQqSrG2J2iQaytcfkSJnguad41vv5fqIRehvzaXNakWpn/oUOwiaG7b5+kb1U84ic9Vyrs6w60IStePSsEndTR4UO4yvpGzLe4ohH9n9vwuzInLyiX6nFaaas7GM6NlrIG7mObFyCbUCr8/4kC1NRtcmFvlm3
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3532.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(136003)(396003)(39860400002)(376002)(451199021)(31686004)(66476007)(91956017)(66556008)(76116006)(66946007)(64756008)(31696002)(478600001)(66446008)(6916009)(41300700001)(6486002)(54906003)(316002)(71200400001)(38070700005)(4326008)(86362001)(5660300002)(8676002)(8936002)(4744005)(107886003)(122000001)(26005)(6512007)(186003)(53546011)(38100700002)(6506007)(7416002)(2906002)(2616005)(36756003)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NTE2Qlc2QThHTGIrQVZrZ00vUGxwbENMSGI4a3VYbTMrMXJjaFEzSFE4WWhC?=
 =?utf-8?B?b21ON2pEOEpySjBCZDVwTm9jcGwrZ3NZUXdoUEJmbW5WcjY3ZmNWMkRjaXJa?=
 =?utf-8?B?TWxvSWEzcTdWNC9GKzBWTGpwSktnQ2tkMTBRbkVtTUI4ZjhUSzQ3bTYwVHdL?=
 =?utf-8?B?Z0FJZVIrWkRnV1hndTZtUjR4ckhzcG5xUmk5WEYrbVdqU01LN2l1TmdOY1hF?=
 =?utf-8?B?WUE0TkRyRzFpaHFvcUZMOFIzUHlaQkxWQjJ1bDcxSVEyUkxWMTJPUkUva1dF?=
 =?utf-8?B?TTNtbWZEbEpSNmY2RFBXR1prNEtqZHJUT0pHR1VNSzhhajdnT2JCVmY0RVBB?=
 =?utf-8?B?KzBvYStXNmNiTGJLSnAxNnVUY3duMVRzL2dTTVdBdmxHTktpSVJiVVpuMk1F?=
 =?utf-8?B?Q0NQZ3JNb3JMcFc2UnBlZ2d2SlNSYlZRT0pRRUZoQ3Z6R1lrSDF6c3RxNytU?=
 =?utf-8?B?REp5dTFUT3pVWG9WOUFQM3FWdWVCaEZBWXpQY2pUVVh3RWlkYzg3VXo3S2Vi?=
 =?utf-8?B?ZWdVd0o0bUVKdEpkRTBRcEZCTmpvWHFVSUFMdWRndXcxSExpbGZBVHVCbHY2?=
 =?utf-8?B?RjFIUzRKWEsxUkRFQmdXb3pJYmpERk90eEJKUWxFbGIzNmVEbDh6QW9ta0Na?=
 =?utf-8?B?TXNPRk1yTUk0TnRHK3o3UGo0eFZRNEdIaFVkQ0dHUmRqRlA4OU8zbnJJOTdY?=
 =?utf-8?B?Mm90Q2dNVXZjcWxTOER1aElEQldHSjlzTFIyRy9FUlVLVlVtdnBjcUtwYUd1?=
 =?utf-8?B?T3FFYlF5d0x6ZjJBY2FqL1hFTG5nRXJjakxDdit0cmVmM3Erdk9LSE1SWi8v?=
 =?utf-8?B?WExWZjkzUDVBSmphK204U1NTUmxFakc4RHg1WUc5TWE5eDBVUWNHVjdpSDRS?=
 =?utf-8?B?ZUluUTdia0FoTnJOMmZZaFUzUDJZTDRjYmtqRVpQVC9JZVUwckZRbUpmZ0hN?=
 =?utf-8?B?Z3lxSmRaQ1ZQdHV0OE9USW54Mis3MmJFei9XV2oySjlZdFRJd1V5RTI0WE5h?=
 =?utf-8?B?aXNVMHFaNENIeEkyVnlrN1pqRkJ5SDBuMUp0bytxb2FLUUc5dEVPS2RTQ1ZY?=
 =?utf-8?B?VCtzMldDSGV4OVlpWk9Sb0c3Yk5DT2J2TlNLbk9nampYb3RlelNIRVpmVEJ6?=
 =?utf-8?B?bEd0eW5zY1BaSUlITHhlblFoNUNRL0drUnRtRy9JdXJvUWtJQlVYQ3NkOEtT?=
 =?utf-8?B?RVdaYWxaQk9xK2hnbVVsVmhGYmF5N1R6Q0l6M3QxdS9zUENYOGl1eitMM1ZH?=
 =?utf-8?B?SmVITFFkQUIrVUZRam1zbVB1R1ZmOUVBaW10VVlDNTUySTVyd2JZcjdQWGxT?=
 =?utf-8?B?VUdBQlplUjdDbjRpWGhmRUNrUGpuREU5STh3UzZ6R3JCOHR6L2E2ak5tQTJE?=
 =?utf-8?B?ekh6a3BNOVczVGtDbEQ3UytwTkl0VzZyVVRWTkdPZ2V0VWxSV3BPZmxvdURQ?=
 =?utf-8?B?KytQN0NGWmVXVVZMNkttUHdEcGlGMVVvdXV3K2t4anViOXNWS3BiRHllZm5F?=
 =?utf-8?B?U2grUnlLbjluYkk3RFNFWFZ6TExiQnFzVElDYU82d3dDWCtiUVpNanZOUjFh?=
 =?utf-8?B?REphd1c5Zlc5TjNYUk9tYmFodVJpYnRhMEZ2cEJ4dkFFNXc2cnJZejN4cHVq?=
 =?utf-8?B?T2NuU2p1RkVqVXNYeFNMSXE4Q1RYUnlZa3cxWUF2eEl5aXYvZlF0dkhreXhD?=
 =?utf-8?B?bzBnQWxXV2F3NTBnVmJOTG5YQUFJbHBrVXp2c2s3MTFzME1aQ0YxOWRpS3la?=
 =?utf-8?B?cUNNRTduUXY2YW1EVjg2Z0tlU0RMMllvdktWTmVSQjJPRDNjVXRYT3VyYlM5?=
 =?utf-8?B?SmV5VFl0VGdVU1ZONll3ZGlKNm1RRDIxQ3FlWXljc25KZHBzL1AzMGVyL0hj?=
 =?utf-8?B?SVJyYUl0c0hPZVdma3RXL2JacTNjczI3bWZJQTBMaUhRRDV6WGRva21GeU5u?=
 =?utf-8?B?MGc3ZWVqSzNDMnlhRHd5bytHS0ptdnNMdXlPSDl3SHVVM1JrOWkyck1HelE5?=
 =?utf-8?B?THIvQittQmxiQmRWYmxFWTJ1UnB0Rng0bXA0dDMzNEI0bDBWd2F4VmVPbE9r?=
 =?utf-8?B?dlRlaFJ5S05HQVlxbjZOdzJkOHFnd2FiUWNoS2VvMWdQMnUxWXVvdU5EKzR5?=
 =?utf-8?B?RC9BMGhFZHM3YldyMUEwMHhyZzNVR3dLSitrZ25lcUVoL3Y1dnZxakhhVHdn?=
 =?utf-8?B?MUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FAE262DF728EC141996BFE3315BACACB@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3532.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43a3a445-cc66-4b4a-ae54-08db5c59d0bc
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 May 2023 13:21:42.6643
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ARPZeF2YdkK58SaKAVeUpVTAcKNCwaHW1Ax7OZD2UCGkutCB0yZnEMWfl2YB5hx0U+ry7kz2/+NmMV49buTE/f3uC/C7QFgFX9aMsScSSHY3/knZAI5h5Wgbd8oLA3DS
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR11MB7888
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
	SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

SGkgQW5kcmV3LA0KDQpPbiAyNC8wNS8yMyA1OjMzIHBtLCBBbmRyZXcgTHVubiB3cm90ZToNCj4g
RVhURVJOQUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVu
bGVzcyB5b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPj4gQXMgcGVyIHRoZSBkYXRh
c2hlZXQgRFMtTEFOODY3MC0xLTItNjAwMDE1NzNDLnBkZiwgZHVyaW5nIHRoZSBQb3dlciBPTg0K
Pj4gUmVzZXQoUE9SKS9IYXJkIFJlc2V0L1NvZnQgUmVzZXQsIHRoZSBSZXNldCBDb21wbGV0ZSBz
dGF0dXMgYml0IGluIHRoZQ0KPj4gU1RTMiByZWdpc3RlciB0byBiZSBjaGVja2VkIGJlZm9yZSBw
cm9jZWVkaW5nIGZvciB0aGUgaW5pdGlhbA0KPiANCj4gcmVnaXN0ZXIgX2hhc18gdG8gYmUgY2hl
Y2tlZCBiZWZvcmUgcHJvY2VlZGluZyBfdG9fIHRoZSBpbml0aWFsDQo+IA0KPj4gY29uZmlndXJh
dGlvbi4gUmVhZGluZyBTVFMyIHJlZ2lzdGVyIHdpbGwgYWxzbyBjbGVhciB0aGUgUmVzZXQgQ29t
cGxldGUNCj4+IGludGVycnVwdCB3aGljaCBpcyBub24tbWFza2FibGUuDQo+IA0KPiBPdGhlcndp
c2UsIHRoaXMgaXMgTy5LLg0KVGhhbmtzIGZvciB5b3VyIGZlZWRiYWNrLiBJIHdpbGwgcHJlcGFy
ZSB0aGUgbmV4dCB2ZXJzaW9uIGFuZCBzZW5kIGZvciANCnRoZSByZXZpZXcuDQoNCkJlc3QgUmVn
YXJkcywNClBhcnRoaWJhbiBWDQo+IA0KPiAgICAgICAgICBBbmRyZXcNCj4gDQoNCg==

