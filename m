Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6C957DCF2
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 10:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234091AbiGVIxI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 04:53:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235160AbiGVIww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 04:52:52 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C760247BA8;
        Fri, 22 Jul 2022 01:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1658479949; x=1690015949;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=DXi8EbqWawjdjpa1FO2Cw2lWggztPpxU4i/6dn1qtIo=;
  b=dnILOGDx5SIk/jUobi+Wa2mcaZwpYRbiFWfATqC4HaSFPgBi8uFsRFVL
   Di6BU6emMvEiwlffA/z0+wBuEK/n+7akgwNyx0OhP/OGWrA8J2zix8Afl
   0rf8QXTyALUVQWyJtK21uvpU5RyJRFniI+isUiHuYH5O6nIi4sXmMimbk
   pYUWQN4EsmNvcgaVGfyjcGMtlr5cgX1qDD8/DGLJR771HMyxRPivYfqGz
   tGpjYRBUp57fZ4KUoj1PDCmRCk3r8zCIx1ApR6/395houR21OhUXglOuK
   UR2Nyh1ygIy4xgPUEWUgxLkmhEGMjns98P1f1IfDcJ7JMi1OkRS/D6TlZ
   w==;
X-IronPort-AV: E=Sophos;i="5.93,185,1654585200"; 
   d="scan'208";a="169039661"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 22 Jul 2022 01:52:24 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.28; Fri, 22 Jul 2022 01:52:21 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 22 Jul 2022 01:52:21 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVHqnRQI6F62s6zw5AwL/3D1rB+QqPegYQi1KJIWqNVlHepNvEANcilwWje7HZ42jpYl+wKoywniGCdPpsR6CYKPEVDJ3vVLYe5AtkPm8gf5FV/nEh+giRc0E755cnyhBTEvPIC23m+t1pEdCicAwCr+s7xDq+Ht/OmA4PL3+ACF10GbBjUbgeIX91WqrLXGtyRYYryRP02qAlDzSWYX2tCRWFrBNcKoMAmx6q5aup5ORP+ClcYIlekVPDzxB7dYvSln4HoEM/mjODGsqEuEXyI/7bpVFRwEab/3fs/ZOYlImIXybIq2MtebpB2zQFdQ2AzRx0Izl3Qra9My+uNvaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXi8EbqWawjdjpa1FO2Cw2lWggztPpxU4i/6dn1qtIo=;
 b=IvYBFOrmnhXqqpD99y/S5VhG4phA7WWFxozlykdUriq6FIoWVAtfsLWUMqjzw5Gg+9qco8gbbn6Qv4Mkq441eHMvPe2l1WaAanBhTmMBHD6N+rD75VlZGalfWPVXdATs7IPXEw9k+iOyh3zG2XUSfWN6CUf5GungSt5p6vM44vzbL6SGrt3eSNsh9DHSpaXAn+y3iNgf2z4ssuLd+TF4oMgPeveWgIKq7gihzX2kGpWVLQU9lhQLt77lZA0WtP6F9jfVlzyrT5yBYg17vsHlO1nbOM7NdbDXkIop/p6IxwOhY1sFvtzblM+hoMDNUOYsrZZ97N63o3yzMC1Lowi2gA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXi8EbqWawjdjpa1FO2Cw2lWggztPpxU4i/6dn1qtIo=;
 b=fUndGXpKi6Yqofjx48xuwcr0qtK/dCzm9XVc6Cw+2zKmsmKK1xRYgATzMackP+Se5AIQxZx91w2BPpyOmA7iN60Kksf3TWirHtVIFxU0eLZZC+TlYRtxGVichkpFnhxH32TboIcJ8FE82RC3KkGZNAXALJF3f4AG+ed7fKwJbyc=
Received: from BN6PR11MB1953.namprd11.prod.outlook.com (2603:10b6:404:105::14)
 by CH0PR11MB5489.namprd11.prod.outlook.com (2603:10b6:610:d4::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 08:52:20 +0000
Received: from BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c]) by BN6PR11MB1953.namprd11.prod.outlook.com
 ([fe80::5c8c:c31f:454d:824c%8]) with mapi id 15.20.5458.019; Fri, 22 Jul 2022
 08:52:20 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <radhey.shyam.pandey@amd.com>, <michal.simek@xilinx.com>,
        <Nicolas.Ferre@microchip.com>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <gregkh@linuxfoundation.org>, <ronak.jain@xilinx.com>
CC:     <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <git@xilinx.com>, <git@amd.com>
Subject: Re: [PATCH net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Topic: [PATCH net-next 1/2] firmware: xilinx: add support for sd/gem
 config
Thread-Index: AQHYnahZUZZG3Bc3k0i8TISjVRfPRw==
Date:   Fri, 22 Jul 2022 08:52:19 +0000
Message-ID: <0fb28327-46c2-7e5e-dc6e-6d98c8e4b6cd@microchip.com>
References: <1658477520-13551-1-git-send-email-radhey.shyam.pandey@amd.com>
 <1658477520-13551-2-git-send-email-radhey.shyam.pandey@amd.com>
In-Reply-To: <1658477520-13551-2-git-send-email-radhey.shyam.pandey@amd.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9b279b0d-0607-4cbe-15d2-08da6bbf7c92
x-ms-traffictypediagnostic: CH0PR11MB5489:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zzxalIh38ZEmB3vpG6cDh6n++hTjlH71X5faYRboo4PsF8vkEgkBHZBkDN86lCU2JfBgFX6rZCNdBu2b68OtfvgfYOFFQEu5JD0lWf6cAY5GFGuZGVICd99Xqd+vU9vBJ2e4qUX+kHEv72/HzsB/KZgO7mwBASVM7hMEq8p+2Jo7YC3czxiDlY0kh6KcUMSv66DLxgNsa8gbO0tjAc34LoAR1ZpdiIQbGyp0+iBekB8cGpw9EuppAs1lc9Wbw2AJRLjSXMVAYG0etgIaAF/6En7oAmH/rBjijkAX2no8EpDiImg7txIHmI4RSoeU0AMrGXDCaHXEtCioNBM2rNOlcwA9+xybF+QQGDbbgQPuO0MFvF8Q3ZNa08wGw+3Fzavq4B3dPeiQRRnFJEbeIPjPTApAylmhaj3UZGMhRGjjfjZf7ci5JkIud70Pjcw5H/74Vj0pogiQriNowBEtAKzZ78GZuRodBDbVbGRGvJkWbIgA71T+cUTfLZXAOb4yF3XXbJafq7CCc/aGtzOtRmdxTFSGA4rP4sPRzZO/mnQedSp18MLpFyJTnLDnBLBG3OTp28fOqflCLKRcXsiE+Tc01KOkZoZFDASxwghASURnytW9/T5MITJw0rKZ5upipXGX/7S7niywrtvXa7uiYlg/At/t+3kzQY+kXnkjf/QuCEEgaLzraEUouNt+mSOg/VNypBfGwWpkBiXcVBQhbwGE8fLA3D+LKXxvz7ECXXMsS1EdkYV6NtCXptXznj0GJT6XQPPBL71qn5847GR5cpWHPqDxj9F8MYE3lgsrz0RsxU29ZQ3BMpnCGc7e//YrCvwwZRIIlX82IGhyN19WVPjlhUg1F37YOFxVub63jXXNcrIhryEkjeF01IzgFnvdqyep
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB1953.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(346002)(396003)(366004)(39860400002)(376002)(36756003)(31696002)(122000001)(41300700001)(86362001)(38070700005)(2906002)(6506007)(53546011)(66476007)(110136005)(4326008)(66556008)(31686004)(316002)(64756008)(8676002)(76116006)(66946007)(54906003)(66446008)(91956017)(8936002)(71200400001)(7416002)(83380400001)(5660300002)(26005)(6512007)(2616005)(38100700002)(186003)(478600001)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?R0czVjUzV2JQTHdoWHF1QXRvb0NzWEtxRktDWmJteGozM25jWk9iYVF6K1F6?=
 =?utf-8?B?M21UdjAvZXEwQlI0SnNKTVJpUkJSbTRSclhjT01CNE5TTERyemdKbUhiMGhx?=
 =?utf-8?B?am5SUnZhLzBkQmZ1Q2NvVEpraE8wSXpZNUhpN0N5ZytDUG02UmIzQ29VVStn?=
 =?utf-8?B?SFM3dWxUamQraTVLTlF5cC9aUFJwRElpdkM2TTNlcllSeTM5WHVDWUxRN25F?=
 =?utf-8?B?V3EyNVZ6UzN4bk82cjRWM09wQkI2WW9zdlAxNkZYUWk2TkpGeUpjTEo2Zk5E?=
 =?utf-8?B?ckN2U1J0NjByeXhNd3VxcndpWVZ1ekJlVHRyK05iRXpmaGVHWWR4VlpzYlk3?=
 =?utf-8?B?ZmVjb3JkTmNaaFh4TDdYTG9hVTVQUWpPM3RmTlZqa1VoMW5JNm9RY2ZBSHNE?=
 =?utf-8?B?QzA2Z3dncWJ0OTdHMlBqdGhrVXlheEdjOFl0MnJ2TCtDWmZjZEIvb0RHMzU0?=
 =?utf-8?B?bHBTWWdveGdXQzIvVjd3aGRQUnlPNVhuMmd6eUlIM3FMWU5uWmpVbDBLQ1RC?=
 =?utf-8?B?Rm9NazZES3l3NjRHS3ltM1JWdlVFQThOTlJpdFRZZmlwNW1ienQ4SXZDTWVO?=
 =?utf-8?B?aXJ6L0draWRvczRFa0ZJQ0FQWVd0b08wMzNxQ3ZIUmg5czQwdkp6S0lVU3Yy?=
 =?utf-8?B?YkxqVGo2TkdqNDFDenRPNS9Wb0J1YTIydkNYM05SOWVOK3hFK2xzRVpaNDBP?=
 =?utf-8?B?MWhwd2hRamtVZ2YzMGpINlNUanIxakY0SkExUzlqZTJMUTlxeWtyd2pyQ2Ir?=
 =?utf-8?B?aEFMd3orWWprWU1LSEpCazBGQS9UTWdxTXR6MWlkYm02cVNNa2FQK3FqSnFo?=
 =?utf-8?B?L3hiMFdzSkhIUTBHVEtYYkRWanVaNGJyYVp1ZVo0V1Q1WDY2cS9KK243V0Rz?=
 =?utf-8?B?WTYrNjRtZDVIL2o0Q0xtcXNzczB5bWhzY1k1MnQwZUNxaDhhUU5POFJoaXBZ?=
 =?utf-8?B?U0F6bC92RkpqRUhxQTZmKytMUC9YTXBNQThKT1RhSW0wNkdndHF2b1pQVW4z?=
 =?utf-8?B?Y1BsaU5MYkYxdUdUNUhsRitibFN0V0lId0oxTzZIdVRpcnpwUWVnR1J3QUM1?=
 =?utf-8?B?b1RuakxZMC8xeVBoMDU4ZksycVNOV3NtejF1aFhpVXRzR01LUG1YcndWK2Mw?=
 =?utf-8?B?N3ZQV1FYeHJaeUMvNUhBblFOd2packNvdW81dWtObW1JRGdOMTlLU1dCeW1E?=
 =?utf-8?B?MTJJSWJOd1VxN05vbUtEUWY4WmdWeDBGUVVpWG11blUrazFIbmRpTmJ1cjFq?=
 =?utf-8?B?d0FKdnRKTE1JalJkRUNXV2Qvb0hSM2lubEhjU24rZVZvSWlzaWZ3UGJaR1pK?=
 =?utf-8?B?eENwQjcyKzh0YnFmcFpXQ1BFN1hzbTJvbUs3LytPRjRtaDhnZXV3Lzd3YWtR?=
 =?utf-8?B?a0pGenRTTnNzRGphYzZWWk56RUw1bkpvOXZjcFRBbGJDYWRPYitzaUhUVDBs?=
 =?utf-8?B?eUVZbm9wS2Z5VStIYmZabStzOGxRQkllOGtRVWxLL1p0WldTdEREdXRsZFBE?=
 =?utf-8?B?R0NpSW9Ga3RsOFkrZ3NMSVFlSnp6cmh3dGZXTXJJOXVuUW1NaEd3REh5aVlu?=
 =?utf-8?B?d2RPQTc4ZGZuRFlOZE5oVEF1TVc4NEpEbUV4YlJScStSb3NSOGkxTEpENjI0?=
 =?utf-8?B?ZWNPZTBHK0REaGxCd0x2ZVVmekhJb2h5eTR1UU4zNDEwME1PdEhQQWJzSkdv?=
 =?utf-8?B?NDQ4UFdEeGQwcW5ydk9teW9tWkxqSkYxajltOFkzbUJ2UjR1M09IaDNia0pT?=
 =?utf-8?B?SVhadzdFTlNQcG5ibyswZjdYMFZYWVRlNU9vcVAwb0pVSUxvMFdaVHlVTUp0?=
 =?utf-8?B?cXZEUHlpNFR3TUIvZW4rMDdzMnJERFhvdklRcWdvanZQeGEveXRxemJpd3hl?=
 =?utf-8?B?TS92NlBWVWlpdzVHbzFuSloyNEtwMGx2US9zVHN5N0tFSm5kU0taS3ZTNE00?=
 =?utf-8?B?L3huVkJOTExGbWl4bElpZ2t2dDJPODR3cUd6bDB0RytmazJ3enREOUR0c0ts?=
 =?utf-8?B?NTJLeCtJMmlXUHJiYWVpWDc1dFdwYzZHVUx3aS9UVG5aZ2hjeVB4U2ZBTnFR?=
 =?utf-8?B?SHozMUVteVdXa1ZxMGc3WmRCWkxPUkhuZ2FlVitDREQ0c1BKTWhBN0c4OVk1?=
 =?utf-8?B?ZUM0b0lTYk5jTFpxdngwSVdXQldoMVEwWGZmcFNrcmtubFFkUWJmMHI1a3ht?=
 =?utf-8?B?dVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDAEB6022004E84B87A52763A9B2235B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR11MB1953.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9b279b0d-0607-4cbe-15d2-08da6bbf7c92
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 08:52:19.8908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SuYHo2ZRtCA21XeXvzBKl34tER4Rckjp3KPL0h+pazl06pj30MvvD+vWTxqQRzEISC5LaiooJ5Sj9kEfO2XPOUHivnKAgXCsA/u5ZI0UOG0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR11MB5489
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjIuMDcuMjAyMiAxMToxMSwgUmFkaGV5IFNoeWFtIFBhbmRleSB3cm90ZToNCj4gRVhURVJO
QUwgRU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5
b3Uga25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBGcm9tOiBSb25hayBKYWluIDxyb25h
ay5qYWluQHhpbGlueC5jb20+DQo+IA0KPiBBZGQgbmV3IEFQSXMgaW4gZmlybXdhcmUgdG8gY29u
ZmlndXJlIFNEL0dFTSByZWdpc3RlcnMuIEludGVybmFsbHkNCj4gaXQgY2FsbHMgUE0gSU9DVEwg
Zm9yIGJlbG93IFNEL0dFTSByZWdpc3RlciBjb25maWd1cmF0aW9uOg0KPiAtIFNEL0VNTUMgc2Vs
ZWN0DQo+IC0gU0Qgc2xvdCB0eXBlDQo+IC0gU0QgYmFzZSBjbG9jaw0KPiAtIFNEIDggYml0IHN1
cHBvcnQNCj4gLSBTRCBmaXhlZCBjb25maWcNCj4gLSBHRU0gU0dNSUkgTW9kZQ0KPiAtIEdFTSBm
aXhlZCBjb25maWcNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFJvbmFrIEphaW4gPHJvbmFrLmphaW5A
eGlsaW54LmNvbT4NCj4gU2lnbmVkLW9mZi1ieTogUmFkaGV5IFNoeWFtIFBhbmRleSA8cmFkaGV5
LnNoeWFtLnBhbmRleUBhbWQuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvZmlybXdhcmUveGlsaW54
L3p5bnFtcC5jICAgICB8IDMxICsrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICBpbmNsdWRl
L2xpbnV4L2Zpcm13YXJlL3hsbngtenlucW1wLmggfCAzMyArKysrKysrKysrKysrKysrKysrKysr
KysrKysrDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDY0IGluc2VydGlvbnMoKykNCj4gDQo+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYyBiL2RyaXZlcnMvZmlybXdh
cmUveGlsaW54L3p5bnFtcC5jDQo+IGluZGV4IDc5NzdhNDk0YTY1MS4uMzJhMzViYWZiNjVlIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYw0KPiArKysgYi9k
cml2ZXJzL2Zpcm13YXJlL3hpbGlueC96eW5xbXAuYw0KPiBAQCAtMTI5Nyw2ICsxMjk3LDM3IEBA
IGludCB6eW5xbXBfcG1fZ2V0X2ZlYXR1cmVfY29uZmlnKGVudW0gcG1fZmVhdHVyZV9jb25maWdf
aWQgaWQsDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaWQsIDAsIHBheWxv
YWQpOw0KPiAgfQ0KPiANCj4gKy8qKg0KPiArICogenlucW1wX3BtX3NldF9zZF9jb25maWcgLSBQ
TSBjYWxsIHRvIHNldCB2YWx1ZSBvZiBTRCBjb25maWcgcmVnaXN0ZXJzDQo+ICsgKiBAbm9kZTog
ICAgICBTRCBub2RlIElEDQo+ICsgKiBAY29uZmlnOiAgICBUaGUgY29uZmlnIHR5cGUgb2YgU0Qg
cmVnaXN0ZXJzDQo+ICsgKiBAdmFsdWU6ICAgICBWYWx1ZSB0byBiZSBzZXQNCj4gKyAqDQo+ICsg
KiBSZXR1cm46ICAgICAgUmV0dXJucyAwIG9uIHN1Y2Nlc3Mgb3IgZXJyb3IgdmFsdWUgb24gZmFp
bHVyZS4NCg0KWW91IGhhdmUgc3BhY2VzIGFmdGVyICJSZXR1cm46IiwgZG9lc24ndCBtYXRjaCB3
aXRoIHRhYnMgdGhhdCB5b3UgaGF2ZQ0KYWZ0ZXIgdmFyaWFibGUgZG9jdW1lbnRhdGlvbi4NCg0K
PiArICovDQo+ICtpbnQgenlucW1wX3BtX3NldF9zZF9jb25maWcodTMyIG5vZGUsIGVudW0gcG1f
c2RfY29uZmlnX3R5cGUgY29uZmlnLCB1MzIgdmFsdWUpDQo+ICt7DQo+ICsgICAgICAgcmV0dXJu
IHp5bnFtcF9wbV9pbnZva2VfZm4oUE1fSU9DVEwsIG5vZGUsIElPQ1RMX1NFVF9TRF9DT05GSUcs
DQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY29uZmlnLCB2YWx1ZSwgTlVM
TCk7DQo+ICt9DQo+ICtFWFBPUlRfU1lNQk9MX0dQTCh6eW5xbXBfcG1fc2V0X3NkX2NvbmZpZyk7
DQo+ICsNCj4gKy8qKg0KPiArICogenlucW1wX3BtX3NldF9nZW1fY29uZmlnIC0gUE0gY2FsbCB0
byBzZXQgdmFsdWUgb2YgR0VNIGNvbmZpZyByZWdpc3RlcnMNCj4gKyAqIEBub2RlOiAgICAgIEdF
TSBub2RlIElEDQo+ICsgKiBAY29uZmlnOiAgICBUaGUgY29uZmlnIHR5cGUgb2YgR0VNIHJlZ2lz
dGVycw0KPiArICogQHZhbHVlOiAgICAgVmFsdWUgdG8gYmUgc2V0DQo+ICsgKg0KPiArICogUmV0
dXJuOiAgICAgIFJldHVybnMgMCBvbiBzdWNjZXNzIG9yIGVycm9yIHZhbHVlIG9uIGZhaWx1cmUu
DQoNClNhbWUgaGVyZS4NCg0KPiArICovDQo+ICtpbnQgenlucW1wX3BtX3NldF9nZW1fY29uZmln
KHUzMiBub2RlLCBlbnVtIHBtX2dlbV9jb25maWdfdHlwZSBjb25maWcsDQo+ICsgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgdTMyIHZhbHVlKQ0KPiArew0KPiArICAgICAgIHJldHVybiB6eW5x
bXBfcG1faW52b2tlX2ZuKFBNX0lPQ1RMLCBub2RlLCBJT0NUTF9TRVRfR0VNX0NPTkZJRywNCj4g
KyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjb25maWcsIHZhbHVlLCBOVUxMKTsN
Cj4gK30NCj4gK0VYUE9SVF9TWU1CT0xfR1BMKHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyk7DQo+
ICsNCj4gIC8qKg0KPiAgICogc3RydWN0IHp5bnFtcF9wbV9zaHV0ZG93bl9zY29wZSAtIFN0cnVj
dCBmb3Igc2h1dGRvd24gc2NvcGUNCj4gICAqIEBzdWJ0eXBlOiAgIFNodXRkb3duIHN1YnR5cGUN
Cj4gZGlmZiAtLWdpdCBhL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaCBiL2lu
Y2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0KPiBpbmRleCAxZWM3M2Q1MzUyYzMu
LjA2M2E5M2MxMzNmMSAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9maXJtd2FyZS94bG54
LXp5bnFtcC5oDQo+ICsrKyBiL2luY2x1ZGUvbGludXgvZmlybXdhcmUveGxueC16eW5xbXAuaA0K
PiBAQCAtMTUyLDYgKzE1Miw5IEBAIGVudW0gcG1faW9jdGxfaWQgew0KPiAgICAgICAgIC8qIFJ1
bnRpbWUgZmVhdHVyZSBjb25maWd1cmF0aW9uICovDQo+ICAgICAgICAgSU9DVExfU0VUX0ZFQVRV
UkVfQ09ORklHID0gMjYsDQo+ICAgICAgICAgSU9DVExfR0VUX0ZFQVRVUkVfQ09ORklHID0gMjcs
DQo+ICsgICAgICAgLyogRHluYW1pYyBTRC9HRU0gY29uZmlndXJhdGlvbiAqLw0KPiArICAgICAg
IElPQ1RMX1NFVF9TRF9DT05GSUcgPSAzMCwNCj4gKyAgICAgICBJT0NUTF9TRVRfR0VNX0NPTkZJ
RyA9IDMxLA0KPiAgfTsNCj4gDQo+ICBlbnVtIHBtX3F1ZXJ5X2lkIHsNCj4gQEAgLTM5Myw2ICsz
OTYsMTggQEAgZW51bSBwbV9mZWF0dXJlX2NvbmZpZ19pZCB7DQo+ICAgICAgICAgUE1fRkVBVFVS
RV9FWFRXRFRfVkFMVUUgPSA0LA0KPiAgfTsNCj4gDQo+ICtlbnVtIHBtX3NkX2NvbmZpZ190eXBl
IHsNCj4gKyAgICAgICBTRF9DT05GSUdfRU1NQ19TRUwgPSAxLCAvKiBUbyBzZXQgU0RfRU1NQ19T
RUwgaW4gQ1RSTF9SRUdfU0QgYW5kIFNEX1NMT1RUWVBFICovDQo+ICsgICAgICAgU0RfQ09ORklH
X0JBU0VDTEsgPSAyLCAvKiBUbyBzZXQgU0RfQkFTRUNMSyBpbiBTRF9DT05GSUdfUkVHMSAqLw0K
PiArICAgICAgIFNEX0NPTkZJR184QklUID0gMywgLyogVG8gc2V0IFNEXzhCSVQgaW4gU0RfQ09O
RklHX1JFRzIgKi8NCj4gKyAgICAgICBTRF9DT05GSUdfRklYRUQgPSA0LCAvKiBUbyBzZXQgZml4
ZWQgY29uZmlnIHJlZ2lzdGVycyAqLw0KPiArfTsNCj4gKw0KPiArZW51bSBwbV9nZW1fY29uZmln
X3R5cGUgew0KPiArICAgICAgIEdFTV9DT05GSUdfU0dNSUlfTU9ERSA9IDEsIC8qIFRvIHNldCBH
RU1fU0dNSUlfTU9ERSBpbiBHRU1fQ0xLX0NUUkwgcmVnaXN0ZXIgKi8NCj4gKyAgICAgICBHRU1f
Q09ORklHX0ZJWEVEID0gMiwgLyogVG8gc2V0IGZpeGVkIGNvbmZpZyByZWdpc3RlcnMgKi8NCj4g
K307DQo+ICsNCj4gIC8qKg0KPiAgICogc3RydWN0IHp5bnFtcF9wbV9xdWVyeV9kYXRhIC0gUE0g
cXVlcnkgZGF0YQ0KPiAgICogQHFpZDogICAgICAgcXVlcnkgSUQNCj4gQEAgLTQ2OCw2ICs0ODMs
OSBAQCBpbnQgenlucW1wX3BtX2ZlYXR1cmUoY29uc3QgdTMyIGFwaV9pZCk7DQo+ICBpbnQgenlu
cW1wX3BtX2lzX2Z1bmN0aW9uX3N1cHBvcnRlZChjb25zdCB1MzIgYXBpX2lkLCBjb25zdCB1MzIg
aWQpOw0KPiAgaW50IHp5bnFtcF9wbV9zZXRfZmVhdHVyZV9jb25maWcoZW51bSBwbV9mZWF0dXJl
X2NvbmZpZ19pZCBpZCwgdTMyIHZhbHVlKTsNCj4gIGludCB6eW5xbXBfcG1fZ2V0X2ZlYXR1cmVf
Y29uZmlnKGVudW0gcG1fZmVhdHVyZV9jb25maWdfaWQgaWQsIHUzMiAqcGF5bG9hZCk7DQo+ICtp
bnQgenlucW1wX3BtX3NldF9zZF9jb25maWcodTMyIG5vZGUsIGVudW0gcG1fc2RfY29uZmlnX3R5
cGUgY29uZmlnLCB1MzIgdmFsdWUpOw0KPiAraW50IHp5bnFtcF9wbV9zZXRfZ2VtX2NvbmZpZyh1
MzIgbm9kZSwgZW51bSBwbV9nZW1fY29uZmlnX3R5cGUgY29uZmlnLA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIHUzMiB2YWx1ZSk7DQo+ICAjZWxzZQ0KPiAgc3RhdGljIGlubGluZSBp
bnQgenlucW1wX3BtX2dldF9hcGlfdmVyc2lvbih1MzIgKnZlcnNpb24pDQo+ICB7DQo+IEBAIC03
MzMsNiArNzUxLDIxIEBAIHN0YXRpYyBpbmxpbmUgaW50IHp5bnFtcF9wbV9nZXRfZmVhdHVyZV9j
b25maWcoZW51bSBwbV9mZWF0dXJlX2NvbmZpZ19pZCBpZCwNCj4gIHsNCj4gICAgICAgICByZXR1
cm4gLUVOT0RFVjsNCj4gIH0NCj4gKw0KPiArc3RhdGljIGlubGluZSBpbnQgenlucW1wX3BtX3Nl
dF9zZF9jb25maWcodTMyIG5vZGUsDQo+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIGVudW0gcG1fc2RfY29uZmlnX3R5cGUgY29uZmlnLA0KPiArICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICB1MzIgdmFsdWUpDQo+ICt7DQo+ICsgICAgICAg
cmV0dXJuIC1FTk9ERVY7DQo+ICt9DQo+ICsNCj4gK3N0YXRpYyBpbmxpbmUgaW50IHp5bnFtcF9w
bV9zZXRfZ2VtX2NvbmZpZyh1MzIgbm9kZSwNCj4gKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGVudW0gcG1fZ2VtX2NvbmZpZ190eXBlIGNvbmZpZywNCj4gKyAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHUzMiB2YWx1ZSkNCj4gK3sNCj4g
KyAgICAgICByZXR1cm4gLUVOT0RFVjsNCj4gK30NCj4gKw0KPiAgI2VuZGlmDQo+IA0KPiAgI2Vu
ZGlmIC8qIF9fRklSTVdBUkVfWllOUU1QX0hfXyAqLw0KPiAtLQ0KPiAyLjI1LjENCj4gDQoNCg==
