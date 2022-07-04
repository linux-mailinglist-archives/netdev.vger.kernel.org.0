Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A25564DAE
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 08:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231986AbiGDG3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 02:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGDG3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 02:29:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F39D1115E;
        Sun,  3 Jul 2022 23:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1656916148; x=1688452148;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=I5Cs1OMarZvZl+q1GbMDS7h33nM1pzBgAWcRMH6gHPA=;
  b=y6vFdSoYEVF3RAyCGePmwnf11AEMn7s/N3h8itsZfS1hZoy8ilSm4aB6
   BLrEhR3z1rQuMACs33w5zqU/IVFID5NNeVOAlrppMrbAMHLTMN4fNi2jL
   niPc09l1bzD1LUI4HHnlOBeKNubV84NBUK7c2AAd9FzQ8taqn95haSDsn
   OXhnFiQO4EDlklN4qtuhyftvYjjdOKYHWKKvrbSM76YgUv3OrxadW7mzf
   +kNDTVUUveLigJNdyjcZ6BUnU9aIYEsd5UXvBWyaVuR6jjqehJd6eiWmN
   ahCwUIeWF5ROP2kgviT7ls0QExlmoI1pERoG+9OzDlKw29z4OOg4vorFa
   w==;
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="170643197"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Jul 2022 23:29:07 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Sun, 3 Jul 2022 23:29:05 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Sun, 3 Jul 2022 23:29:05 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hZ6lJDwUirN8YpMhDZ2cUjK7qvxQBBW1Bdppxl1DVpQ0MWHaXsSPsZvgfbmMJ0JDFX+wvS7bXqiPIC+ZI494vDwBjFGaRhyUwkTCaS+Y2MQa+STOT9VFH7u2Pd5PQm1EteHJg1VYIBYP/n0R8+aPkKvjmj2Rk8UKD8rcen2URD2RY9/Br4jhUK+qB8hRaGM00dvimKinj9DG/ap1iLV+C47x2DdMXhs0LBRIZ6qFqLAmLunclPyuMMpZ8UdxXUqqbo3putIg1vGvDAsMOztEHvfphXHD+3AzoToAXO7YJXxsbr1Jypo1yBaZKw3B1KNy9BG0KjUGeSCGwsVPfcKPZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=I5Cs1OMarZvZl+q1GbMDS7h33nM1pzBgAWcRMH6gHPA=;
 b=m0wmvWU7jyfxHYQScc75+vh2D/PtetVrySDYKqkJxn1vfmzjGHmCHmHUjNk7iLDdtcvDe7OWJsy6nBH28O3RU52fU/DGFVngNMGEc5M/g6+mmmqflnadPy5tn49VG4xos30pRLBVtZJlqk/sooYowXm3XXkNFC9vxweOn2jRZvakeXBCa2Y+UvJc+50rJUCNaxGd+Mp+AQBe1+rWHxAb4KX2DaQ7q3mKjPb9LP+MX8z+TTYWmRQXCXD9VKgTYBgCBISNdnSpnY3oH0Q+F93bsS1yG5Hyi78V7BiZhwzEp8u/Op+qOu6i89V5Os+vryKUhNfJAmmzj3fK1zuELFt5sg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I5Cs1OMarZvZl+q1GbMDS7h33nM1pzBgAWcRMH6gHPA=;
 b=dthTlPjIINqYZdDe3WbuPRUcIM2lajbDUkewNqQWOK3v7/rKW86LX6ykAcpRZiDzMN6FAxivalZxbWcDDkTjxN4FUqb2F/g2D8xaFYt0Li10jY8j/tw1MxzJ2Q8cgQ1zmqxEYKZro0AZk3/Poj9qSeNIFt0RYPIjktJizhUzy4s=
Received: from CO1PR11MB5154.namprd11.prod.outlook.com (2603:10b6:303:99::15)
 by CH0PR11MB5281.namprd11.prod.outlook.com (2603:10b6:610:bc::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5395.14; Mon, 4 Jul
 2022 06:29:04 +0000
Received: from CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa]) by CO1PR11MB5154.namprd11.prod.outlook.com
 ([fe80::699b:5c23:de4f:2bfa%4]) with mapi id 15.20.5395.020; Mon, 4 Jul 2022
 06:29:03 +0000
From:   <Conor.Dooley@microchip.com>
To:     <dlan@gentoo.org>, <mail@conchuod.ie>
CC:     <palmer@dabbelt.com>, <linux-riscv@lists.infradead.org>,
        <paul.walmsley@sifive.com>, <aou@eecs.berkeley.edu>,
        <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <john.fastabend@gmail.com>, <kpsingh@kernel.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <bpf@vger.kernel.org>
Subject: Re: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Thread-Topic: [PATCH] RISC-V/bpf: Enable bpf_probe_read{, str}()
Thread-Index: AQHYjt5C7+o+zgpwvEWlpAAqR9vFbK1sn0+AgADcGoCAAEWQAA==
Date:   Mon, 4 Jul 2022 06:29:03 +0000
Message-ID: <1ad358de-ac73-d430-aab1-c77df14b0011@microchip.com>
References: <20220703130924.57240-1-dlan@gentoo.org>
 <c373eec7-2cc4-a41d-916c-f073aba5494b@conchuod.ie> <YsJOVZU1gPo3KzdB@ofant>
In-Reply-To: <YsJOVZU1gPo3KzdB@ofant>
Accept-Language: en-IE, en-US
Content-Language: en-IE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2566a4ca-c603-4ff6-1b26-08da5d867d7b
x-ms-traffictypediagnostic: CH0PR11MB5281:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nTTO3Rsr9/HMXAH+tM77uu73DLvbfzzhU2TXUYkBAfdK6qGm/roVVrQdyr27XlAtNRLJWO7qtUBH9UROup27yRznp4+CY/UMxxfRgHMohVmlcsUIb7FR9FmqsTl22KzU/ZCZr2Zg9pVl/BWoqP0qfVAwZSWj0UkmF8PGpleQFGkfcY/YpNEfg5Ojc7gfLFzB5+moKQRtflu0et79FreNYbh0ktruZ/kPMD3HEymsYiywfXdyZ6I3BCfbP0brIT96SfDV6ae+gmtAce6bshxOpv8QFHKqKGV8v913SS997JD1Qwwv5MNG/RawkieoHKtnZ/INNu3aZkEfXI6dgffRtrcVviZAFadOEe4YVpZz+DiFnlADC+M5y67OIbZnHc0l1rdxUflcZEyCW7g1u2w4UNy/UvgULGSDgFwRgMDRBkXG21vwNH93Apdmn/h89oiWm5rU6DvwBMsaGmeOqN10avq/2Upoikb41XM7dNU6feof90h+CtnPQVmf048tUjLYPjclCyac15lknxbxD8VJFswLd9pr6HLS2Lp5egXT70u0+YaTH9kPrVik/soS0JhFAtMYdm419IaPgk+YrxmP0nWveZlBdfpppGWeUyR+XeSdCkkgzshzULmo/mPb0eQQ37UUbPH2H2JBNwYLXRu71u8ZtBBmCjjaLszN2TcEwh/rchbSYqcvk7S7l+rR1tgv8HVpeoDRLpopdTAYrV/D1eBlb/Sr04b2u+8kQp76ou9DREBkiMtYkrJ2fUHtiNQZYNGT7/iMRHOYBbps2HJGGaiCGgrQzgXlTvr9McQK1cdi5RKHSPwPk5nCr7cflRyb8StOlLuv9HxTQdYZJZ+Vt4RuTFU+8yMP/JDaCQYPlpY6C3P78msJkHBJuR5gt2NEnydrTEGqZ/C+vzphnrb2WRDQrKjQ2YRdgXVAFs5qVnw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5154.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(396003)(39860400002)(346002)(366004)(376002)(41300700001)(2906002)(8936002)(478600001)(966005)(6486002)(38100700002)(5660300002)(7416002)(186003)(31696002)(86362001)(2616005)(83380400001)(6506007)(53546011)(6512007)(54906003)(110136005)(122000001)(26005)(38070700005)(36756003)(31686004)(71200400001)(66476007)(66556008)(66946007)(316002)(8676002)(66446008)(64756008)(91956017)(76116006)(4326008)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SUdjZW5mU3M3bXRubVBWK0g5UCtXdGs5ZHMveDVxQlhmUTl6K1pzc3YzcUVC?=
 =?utf-8?B?N3pZb21TVWJnaFZvYkRQdWxZZzQyVkh6cTJwRzRmc3JkT1RoWFYyS0g5MEgr?=
 =?utf-8?B?NXoyRHR5WXpkUExuTjEzc284cVdnRWYzZ0MrRXArbHR1TWhMdi9xc0NzM1Np?=
 =?utf-8?B?ejBYcXNVYUo3Y0ZlSk5vR1ErQmplSWtmYytRNzJRUGNNdVRrN0JVZXRiUWlH?=
 =?utf-8?B?NlRPNm1GaEt6Q2Y1WHFrbjh4S0FueW9EMWpWZWd0Yk1JSzFEc2JCRFN6aUlp?=
 =?utf-8?B?V0VuQVV5QWU2SDFRS0xuSkg5blRyVTR6YzNENGFQRjd1NElPTHRnRHFSczla?=
 =?utf-8?B?RHZQSlJ4VVpkZHNPYW9vS2NUUExSd1RtMytLV2RVOTZOakxoTnZlNHdYenZP?=
 =?utf-8?B?SWdvbUppS3ByZFMzbW91Z0IraGFEN3FXbzk4L1FacEJPTExpRHVWZ0ZQTG1M?=
 =?utf-8?B?YTVKdnozZVpKcHdjc2hGTGU2UW9nVXl1YURjanBKNUc0RlRoa2lEVE9ScVlS?=
 =?utf-8?B?eUtiTFM4TEtuOGRjalNJRjYyLzlwdDY1SCttQ3pteE9yRUYvb0dFSkdoRnI2?=
 =?utf-8?B?bWl6YVpJR2E4RkJyY0s1R2plMy9rTUtwNWVZVXptdm9qckJOTXZRSklseFZ3?=
 =?utf-8?B?dmdhYzBpbGc2NVNSN3FKdXlIUURqU3lXY3M2NWkxSElSVUpOWnQ2S0JraTVD?=
 =?utf-8?B?aVJQQ3dBMkM2elFRSWVJQUpJMlVSVHRvQmNmak54Q283TlBMdE1ZaXZQWFY2?=
 =?utf-8?B?Q1hMTE1oNjErR1dudXV1Q2p2VnROT3hqNjN3Y2ZLaUt4blcvN3ZVY1FHdXhB?=
 =?utf-8?B?QjEydG1OYzJDOUVHS1ZJRndZZTFkem54STJjQis3WU9pN2I2NWpubVFtWm5D?=
 =?utf-8?B?ZXNRNk1LajhGeVFQWDY0ejVGUnFHTm1XTzdPNGkzZEZUNFBsU2N1Nzgrdkhl?=
 =?utf-8?B?U2lIZTNhenBSTFdhSDN6SWxoV0pTVEJPVVZoNGg5M2cwTXliNS9zMlhEZm14?=
 =?utf-8?B?U29BRlV3MW9ZYVh1aFVaRW81WDBkRXp2cFBzQTZvREtBdlk5MllpcmUxbXVr?=
 =?utf-8?B?ZXk2NmpUdHRmVVJnVTJzcXhsa3o0QWQ1dVNhTFp3ZGdoSnhYZnc4cTZjSWxH?=
 =?utf-8?B?YVM2S0NKaFBsWk5lZkNoejVESGd4KzZVL0FXRFJQMFVLaGVQSWFvT2Z4SktR?=
 =?utf-8?B?czFBWm9UZkRZenJwTHgxM1Z5NWNJUlFKL2FPbHZYR0wxeUZsWUVydDdCWlgy?=
 =?utf-8?B?MGlZcEZqUGNFRVlVbk96bGNoT1lzQUlUWWFIejh3UzVJYjUzNGF5NTJJZDl3?=
 =?utf-8?B?TkNOVjQ3WldDOC9HR01yR29ONHZ5bXlHckJ3ZEcrL2J3QXpCbTVDSTV2dlpZ?=
 =?utf-8?B?N0FBUTQ3NWI5aWtGYnJOZkJqa01XYm9teGFTVkNTQ1ZHQzMxU000UVRpYzlN?=
 =?utf-8?B?T1RKY2M2Slo2VkliMHNMOVA3cGEydmQ4MmVweEJFK2RiR3RaQmMzZFhOMk1B?=
 =?utf-8?B?dVBVVEMvVXhibDhZVS9BMHBHS29LRnVvUzFJSnNmb0htRVFlNEZQL3grZEo5?=
 =?utf-8?B?SFBUZTJiNTNXSlozNkZRUFAxbjVqd3RVQnVKM2NtTmZ0TG1PSlBxYlJaeFRE?=
 =?utf-8?B?MkVKajQ4SWZJdUpvSnUzcmJXWGd4Wm9STHlKOHJTTmFLTlRvMS80ZmRXVmNx?=
 =?utf-8?B?NUpQclI1WGhpMW05c21OTXNYQXFHaGpBTGlYZ1NKWjFVRmdzRjcyVWNrK0hl?=
 =?utf-8?B?WTJhcWZaQkxNZmdhbzhBRXQ0ZDk1aG00eEFSNTBWRWFYdnFBTVBaanZzU3hM?=
 =?utf-8?B?T2Z2NitZZE83d1VZZER4M29JSzlYeW0vYVlodGxCOW1CR0NCUml6TVJGWmQy?=
 =?utf-8?B?SFlja0h3VkVmbmp6UElqTStlQ0ZqanQ1Z0RXeWRpdFZnZEJDQlFDY3YzYlgy?=
 =?utf-8?B?N1haSzlhelNyTUNTT2h5YjR1NnMzMkRVSng2bWNxZUlnQnR3OHl5SDl2UkN6?=
 =?utf-8?B?Z0pjbmhJWFNnUXFYL0pybDhwc0VQcTMrdkZLUFVmQTdYR2trdDRDN0FzMGZQ?=
 =?utf-8?B?WXFaYnJTeXFOZENYcW1VeVVrU2FnQjd2SE1OTFZEaWltNlBaNC9oaDdxZjZw?=
 =?utf-8?Q?4exrw8rMwuKjsyks9wlcLF1Nk?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FC3D488096A8284A854444AEA159A1AE@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5154.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2566a4ca-c603-4ff6-1b26-08da5d867d7b
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Jul 2022 06:29:03.8098
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8xiCKI94v3HwMZ5JMFEjwlKEfvcT3wMj3yikOwDVAer8RWETQjPcaBbYvKYzb1IdT42M53UGMBVaIo34Y7DfavQFyJOdQ/tQba25xZJnTPU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5281
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMDQvMDcvMjAyMiAwMzoyMCwgWWl4dW4gTGFuIHdyb3RlOg0KPiBbWW91IGRvbid0IG9mdGVu
IGdldCBlbWFpbCBmcm9tIGRsYW5AZ2VudG9vLm9yZy4gTGVhcm4gd2h5IHRoaXMgaXMgaW1wb3J0
YW50IGF0IGh0dHBzOi8vYWthLm1zL0xlYXJuQWJvdXRTZW5kZXJJZGVudGlmaWNhdGlvbiBdDQo+
IA0KPiBFWFRFUk5BTCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVu
dHMgdW5sZXNzIHlvdSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEhpIENvbm9yIERv
b2xleToNCj4gDQo+IE9uIDE0OjEyIFN1biAwMyBKdWwgICAgICwgQ29ub3IgRG9vbGV5IHdyb3Rl
Og0KPj4gT24gMDMvMDcvMjAyMiAxNDowOSwgWWl4dW4gTGFuIHdyb3RlOg0KPj4+IEVuYWJsZSB0
aGlzIG9wdGlvbiB0byBmaXggYSBiY2MgZXJyb3IgaW4gUklTQy1WIHBsYXRmb3JtDQo+Pj4NCj4+
PiBBbmQsIHRoZSBlcnJvciBzaG93cyBhcyBmb2xsb3dzOg0KPj4+DQo+Pj4gfiAjIHJ1bnFsZW4N
Cj4+PiBXQVJOSU5HOiBUaGlzIHRhcmdldCBKSVQgaXMgbm90IGRlc2lnbmVkIGZvciB0aGUgaG9z
dCB5b3UgYXJlIHJ1bm5pbmcuIFwNCj4+PiBJZiBiYWQgdGhpbmdzIGhhcHBlbiwgcGxlYXNlIGNo
b29zZSBhIGRpZmZlcmVudCAtbWFyY2ggc3dpdGNoLg0KPj4+IGJwZjogRmFpbGVkIHRvIGxvYWQg
cHJvZ3JhbTogSW52YWxpZCBhcmd1bWVudA0KPj4+IDA6IFIxPWN0eChvZmY9MCxpbW09MCkgUjEw
PWZwMA0KPj4+IDA6ICg4NSkgY2FsbCBicGZfZ2V0X2N1cnJlbnRfdGFzayMzNSAgICAgICAgICA7
IFIwX3c9c2NhbGFyKCkNCj4+PiAxOiAoYjcpIHI2ID0gMCAgICAgICAgICAgICAgICAgICAgICAg
IDsgUjZfdz0wDQo+Pj4gMjogKDdiKSAqKHU2NCAqKShyMTAgLTgpID0gcjYgICAgICAgICA7IFI2
X3c9UDAgUjEwPWZwMCBmcC04X3c9MDAwMDAwMDANCj4+PiAzOiAoMDcpIHIwICs9IDMxMiAgICAg
ICAgICAgICAgICAgICAgIDsgUjBfdz1zY2FsYXIoKQ0KPj4+IDQ6IChiZikgcjEgPSByMTAgICAg
ICAgICAgICAgICAgICAgICAgOyBSMV93PWZwMCBSMTA9ZnAwDQo+Pj4gNTogKDA3KSByMSArPSAt
OCAgICAgICAgICAgICAgICAgICAgICA7IFIxX3c9ZnAtOA0KPj4+IDY6IChiNykgcjIgPSA4ICAg
ICAgICAgICAgICAgICAgICAgICAgOyBSMl93PTgNCj4+PiA3OiAoYmYpIHIzID0gcjAgICAgICAg
ICAgICAgICAgICAgICAgIDsgUjBfdz1zY2FsYXIoaWQ9MSkgUjNfdz1zY2FsYXIoaWQ9MSkNCj4+
PiA4OiAoODUpIGNhbGwgYnBmX3Byb2JlX3JlYWQjNA0KPj4+IHVua25vd24gZnVuYyBicGZfcHJv
YmVfcmVhZCM0DQo+Pj4gcHJvY2Vzc2VkIDkgaW5zbnMgKGxpbWl0IDEwMDAwMDApIG1heF9zdGF0
ZXNfcGVyX2luc24gMCB0b3RhbF9zdGF0ZXMgMCBwZWFrX3N0YXRlcyAwIG1hcmtfcmVhZCAwDQo+
Pj4NCj4+PiBUcmFjZWJhY2sgKG1vc3QgcmVjZW50IGNhbGwgbGFzdCk6DQo+Pj4gICAgRmlsZSAi
L3Vzci9saWIvcHl0aG9uLWV4ZWMvcHl0aG9uMy45L3J1bnFsZW4iLCBsaW5lIDE4NywgaW4gPG1v
ZHVsZT4NCj4+PiAgICAgIGIuYXR0YWNoX3BlcmZfZXZlbnQoZXZfdHlwZT1QZXJmVHlwZS5TT0ZU
V0FSRSwNCj4+PiAgICBGaWxlICIvdXNyL2xpYi9weXRob24zLjkvc2l0ZS1wYWNrYWdlcy9iY2Mv
X19pbml0X18ucHkiLCBsaW5lIDEyMjgsIGluIGF0dGFjaF9wZXJmX2V2ZW50DQo+Pj4gICAgICBm
biA9IHNlbGYubG9hZF9mdW5jKGZuX25hbWUsIEJQRi5QRVJGX0VWRU5UKQ0KPj4+ICAgIEZpbGUg
Ii91c3IvbGliL3B5dGhvbjMuOS9zaXRlLXBhY2thZ2VzL2JjYy9fX2luaXRfXy5weSIsIGxpbmUg
NTIyLCBpbiBsb2FkX2Z1bmMNCj4+PiAgICAgIHJhaXNlIEV4Y2VwdGlvbigiRmFpbGVkIHRvIGxv
YWQgQlBGIHByb2dyYW0gJXM6ICVzIiAlDQo+Pj4gRXhjZXB0aW9uOiBGYWlsZWQgdG8gbG9hZCBC
UEYgcHJvZ3JhbSBiJ2RvX3BlcmZfZXZlbnQnOiBJbnZhbGlkIGFyZ3VtZW50DQo+Pj4NCj4+PiBT
aWduZWQtb2ZmLWJ5OiBZaXh1biBMYW4gPGRsYW5AZ2VudG9vLm9yZz4NCj4+DQo+PiBEbyB5b3Ug
a25vdyB3aGF0IGNvbW1pdCB0aGlzIGZpeGVzPw0KPj4gVGhhbmtzLA0KPj4gQ29ub3IuDQo+Pg0K
PiANCj4gSSB0aGluayB0aGlzIGlzIGVmZmVjdGl2ZWx5IGJyb2tlbiBmb3IgUklTQy1WIDY0IGF0
IHRoZSBjb21taXQ6DQo+ICAgMGViZWVhOGNhOGE0OiBicGY6IFJlc3RyaWN0IGJwZl9wcm9iZV9y
ZWFkeywgc3RyfSgpIG9ubHkgdG8gYXJjaHMgd2hlcmUgdGhleSB3b3JrDQo+IA0KPiBIb3dldmVy
LCB0aGUgYmNjIHRvb2xzIGhhdmVuJ3QgZ290IEJQRiBzdXBwb3J0IGZvciBSSVNDLVYgYXQgdGhh
dCB0aW1lLA0KPiBzbyBubyBvbmUgbm90aWNlZCBpdA0KPiANCj4gSSBjYW4gYWRkIGEgRml4ZXMg
dGFnIGlmIHlvdSB0aGluayBpdCdzIGEgcHJvcGVyIHdheQ0KDQpIbW0sIEkgaGFkIGEgcmVhZCBv
ZiB0aGF0IGNvbW1pdCBhbmQgdGhlIGJyZWFrYWdlIHNvdW5kZWQgaW50ZW50aW9uYWwuDQpJIHJh
biBhIGdpdCBsb2cgLS1ncmVwICIwZWJlZWE4Y2E4YTQiICYgaXQgc2VlbXMgbGlrZSBhIG1peGVk
IGJhZyBvZg0KZml4ZXMgdGFncy4gV2hldGhlciBvciBub3QgaXQgZGVzZXJ2ZXMgdGhlIGV4cGxp
Y2l0IHRhZywgbWVudGlvbmluZw0KdGhlIGNvbW1pdCB3b3VsZCBiZSB1c2VmdWwuIFRoZSB0YWcg
d291bGQgYmU6DQpGaXhlczogMGViZWVhOGNhOGE0ICgiYnBmOiBSZXN0cmljdCBicGZfcHJvYmVf
cmVhZHssIHN0cn0oKSBvbmx5IHRvIGFyY2hzIHdoZXJlIHRoZXkgd29yayIpDQoNClRoYW5rcywN
CkNvbm9yLg0KDQo+IA0KPj4+IC0tLQ0KPj4+ICAgYXJjaC9yaXNjdi9LY29uZmlnIHwgMSArDQo+
Pj4gICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykNCj4+Pg0KPj4+IGRpZmYgLS1naXQg
YS9hcmNoL3Jpc2N2L0tjb25maWcgYi9hcmNoL3Jpc2N2L0tjb25maWcNCj4+PiBpbmRleCAzMmZm
ZWY5ZjZlNWI0Li5kYTAwMTZmMWJlNmNlIDEwMDY0NA0KPj4+IC0tLSBhL2FyY2gvcmlzY3YvS2Nv
bmZpZw0KPj4+ICsrKyBiL2FyY2gvcmlzY3YvS2NvbmZpZw0KPj4+IEBAIC0yNSw2ICsyNSw3IEBA
IGNvbmZpZyBSSVNDVg0KPj4+ICAgICAgc2VsZWN0IEFSQ0hfSEFTX0dJR0FOVElDX1BBR0UNCj4+
PiAgICAgIHNlbGVjdCBBUkNIX0hBU19LQ09WDQo+Pj4gICAgICBzZWxlY3QgQVJDSF9IQVNfTU1J
T1dCDQo+Pj4gKyAgIHNlbGVjdCBBUkNIX0hBU19OT05fT1ZFUkxBUFBJTkdfQUREUkVTU19TUEFD
RQ0KPj4+ICAgICAgc2VsZWN0IEFSQ0hfSEFTX1BURV9TUEVDSUFMDQo+Pj4gICAgICBzZWxlY3Qg
QVJDSF9IQVNfU0VUX0RJUkVDVF9NQVAgaWYgTU1VDQo+Pj4gICAgICBzZWxlY3QgQVJDSF9IQVNf
U0VUX01FTU9SWSBpZiBNTVUNCj4gDQo+IC0tDQo+IFlpeHVuIExhbiAoZGxhbikNCj4gR2VudG9v
IExpbnV4IERldmVsb3Blcg0KPiBHUEcgS2V5IElEIEFBQkVGRDU1DQo+IA0KPiBfX19fX19fX19f
X19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fX19fXw0KPiBsaW51eC1yaXNjdiBtYWls
aW5nIGxpc3QNCj4gbGludXgtcmlzY3ZAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiBodHRwOi8vbGlz
dHMuaW5mcmFkZWFkLm9yZy9tYWlsbWFuL2xpc3RpbmZvL2xpbnV4LXJpc2N2DQoNCg==
