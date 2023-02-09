Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1E9968FE3C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 05:07:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232937AbjBIEHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 23:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232930AbjBIEHX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 23:07:23 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4DCF4201;
        Wed,  8 Feb 2023 20:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1675915640; x=1707451640;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jw3YkgXIRF8BJnXk37o028tdqDuhdf6Rocu8O/QajCc=;
  b=bMgSMFlYvcpzlYiuxFFkwA7l8kB0dpGpcItUPJWsuathVZtR6gVUrgeb
   xi6FlmL7UfmE1uSynYlaB0W5xsrK9yKYhcn1sF9CDmiUfTxRsnZyQZ1aV
   phXIMIAjcbM+9PDI6lF7XNUIwaEN4Qu8q2fSwCVgMhbPzngjtBIxlDm5Y
   OFUEHk+wgAno2/VfWcAMuxebnB02mBFscyqTUHpay3dNINbaWd90J16T5
   Xhu06Zoplsjb+dht+lTkmYOLFUdghLo5GNSI4BUW//vHFj6umkDIWfv4J
   lBK+VuM0SpisYHvnnshXjZvguaoAUCMCOP4Y3kNRAMFrGRHgx7Jq5hnMf
   w==;
X-IronPort-AV: E=Sophos;i="5.97,281,1669100400"; 
   d="scan'208";a="199621235"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Feb 2023 21:07:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 8 Feb 2023 21:07:13 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Wed, 8 Feb 2023 21:07:13 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Bun9LXNCoo21sXClh01Ke5GWpUWtEtouqYWu0rDZhlztqg/gVYArb0GQCxRV0Cc4bVCn3u2K1UNlGTXTMoY195oEkQwRC2FZe/oLJ03IIvJdRVzdY+WWI5NczQS8KZQbyONV60Avur2qhWlF3JmrD66FRpAk+5GQUh6D8yeMo4xz2DcCA2HJVvyR9oMdZETrvdH4OX9kgOkeU+C+bDfZceYquVLwz+Lz3ClRKkvys9iHGWZyPZaxTPhne1ls95+qXHbZxjzr+QCOODueDQpt5Ji89qGlTK1W/PP4I3NYbPJyxjRkqwrO0HBzCmXk/AiOPlbZDAbxY2cAaA+sOtYs9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jw3YkgXIRF8BJnXk37o028tdqDuhdf6Rocu8O/QajCc=;
 b=SBtjssARYuSuWDiQayziZP571Bi3evvbUAQ7ef16j8BWlXgZsiH6F6zlE8aYn66+nQG78IbAqXjnLfejbeb0T38LvEsoc9TBmn/uCmUPIixiWdUVGglSWCPQeBsc/PvbyLVSTI93/VoWtbQz+RSdAXAetyVWgDwNSDZtL+FAlNZeEvx36k/xbWsb44z8zrzQL7rvdsWFi48t4HE8b+nzE9mscveyZbq39dAr+ByFJORS+NB0ghFjoWwhmy+ZqeZTPa1kE4BatwZPfkmvHexElHgzvTRvq4Gc4dVtPKISQaBcQFGVY3WIqigOAOPXVA6h1YVh0aaEvX4icp53EXgRFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jw3YkgXIRF8BJnXk37o028tdqDuhdf6Rocu8O/QajCc=;
 b=V9wf6ysBrNxAw3elajFU7BLH41wFxeNzV0CjIj5nWZOV7nQyJJk3HHLZpLawBQBajS9Tp5CjxTwHdYdZ0gketNOE9pPLjh7pOMoVqxh2vllcq5BzF5VJ+tjMZInBzcoMBOoq812W9dUaHGam8SpwCrFl/JBszb58fKwJctESCEc=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SA0PR11MB4767.namprd11.prod.outlook.com (2603:10b6:806:97::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6086.17; Thu, 9 Feb 2023 04:07:11 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::33d3:8fb0:5c42:fac1%5]) with mapi id 15.20.6064.035; Thu, 9 Feb 2023
 04:07:11 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <vivien.didelot@gmail.com>, <andrew@lunn.ch>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <wei.fang@nxp.com>,
        <edumazet@google.com>, <pabeni@redhat.com>,
        <o.rempel@pengutronix.de>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>, <hkallweit1@gmail.com>
CC:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <kernel@pengutronix.de>
Subject: Re: [PATCH net-next v6 1/9] net: dsa: microchip: enable EEE support
Thread-Topic: [PATCH net-next v6 1/9] net: dsa: microchip: enable EEE support
Thread-Index: AQHZO6i8rQRV75tTjUqi+3V/hQ46ta7GAKUA
Date:   Thu, 9 Feb 2023 04:07:11 +0000
Message-ID: <332df2fff4503fac256e0895e4565b68fd76dee4.camel@microchip.com>
References: <20230208103211.2521836-1-o.rempel@pengutronix.de>
         <20230208103211.2521836-2-o.rempel@pengutronix.de>
In-Reply-To: <20230208103211.2521836-2-o.rempel@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SA0PR11MB4767:EE_
x-ms-office365-filtering-correlation-id: 8045f712-8c06-4b07-ec47-08db0a531e87
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p2lSaPCguL/OPo6+tOAPBpttS7Sj0fMmerZ9ZybJL4luGVo1tpMtML68f8/HDOkNT7otxxwq6HrSg9RrSyswC52ykAkL7LulP6RiaJZ7iXMuDFlM42Omygp99AuX97bhyQMq04vsMiURssTmBNxXwvLFZVmo1ugtR3Aej9qn84rAbMgTkHScQBe2sDSJGzp6SkAR78RXlQsGEtotj4Wm36HprzjkRogr2dg6Qkc/Addrtms3sWbfR0605fLadMiVzUEIZiFll6HK/uSclP5kB+t0AMEr2kzQBDoI4O2HdhDqZjx4CuyKSG0aCocEXLe4re+9Mn7rxh/VcSyQR7rbYd8Xhmny7PuIw8YUuNHfr+dFLpK8m7dbYFfuLDBYX9RoKFE/XwN61ONae5og7qVsfPF6abAHij/S09aSohE//qyxBWZbxsjC7Wb9ajV6Tkfv/8w/2f15UDK/WfmczO6cjNmeA/M9pKlw9Dl4R6uklBW7CWC3i04iTOE2+HFUTIOBMbWlq9rj60E4XkyGZ0WoNag2Z3abey8J4WRInSUdzUhRZ4qivJCIKq4VNrERkSA16+n9EahGp+l5rpw+6vfwyHidQ0PhLDsmndWHrpYKRA32DtEJAQRYqC13oNfO60+XQTLhIfbplQEvi8YP+BRftnVei0t+WyXRLvtpRzcoK/B2/uJrL1dkvE2DtVbCCmxod2H5QriixLtdW3Z6Z7kgmk6PKrx/BbCYJyzzvnrgEw6EHZi+m+e7Aq6cU32jJsrk
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(346002)(376002)(136003)(39860400002)(396003)(451199018)(38070700005)(6506007)(921005)(36756003)(71200400001)(86362001)(6486002)(478600001)(2616005)(122000001)(6512007)(26005)(186003)(83380400001)(38100700002)(8936002)(41300700001)(8676002)(316002)(54906003)(5660300002)(110136005)(7416002)(91956017)(76116006)(66946007)(2906002)(4326008)(64756008)(66446008)(66556008)(66476007)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bk43aWVvTHhnSDNLeWlKSjR4K0cwYk1KR1R2R2RUdTBGYWk3dzJqcmJBMlMz?=
 =?utf-8?B?aW51NzljYmdQY1RTWTBBS05sYUt5dWtwK2c1ZkFabEQ0Vk56SkhHTk04Ymda?=
 =?utf-8?B?a2cybm9xTVp1d1U5S084VHdiSlplWG5pRjVwVmRkTTd0eGdEOE4wbW5zS0Nt?=
 =?utf-8?B?ajBnSm05SnZXSDRiTFJtNXNvQy9Fc0hSaVExa3MxMFE4MVNDMWVZb0Ezb2tl?=
 =?utf-8?B?TEwzMkoxanYxdWlXK3Jua1FUYm16MVNVbzR4UFRNMG5rUC9kZHdYTUIzVnNs?=
 =?utf-8?B?Rks3Wmd1dktFdy8rZmlPbWMzSGF3NTJrR0pCTEV0Mk9XbVpTL21KdVVFN3o3?=
 =?utf-8?B?TXh5UkM2SDFJbCtRZTgxU3NuZW9pN1p3bFdyaXM2QzAvekUxU2Joc0lMRzA5?=
 =?utf-8?B?T3ZGSU0wR1g2TmtGdXJHMjJ0cStHeTNxY3MwdXZVQm9Pbjkwekh0aGJ4RUh2?=
 =?utf-8?B?ZVVMYW1IbVVBNXlBcjJSQTJpemNJWEczUnVZbUd2MC9TSGpWQUFPOWpuZCs3?=
 =?utf-8?B?M0ZiZ2I5bkVFTytrcWxvSTU0emk3cmltcDVVdUc0UHBNR0xiY1YvUFJVTkIv?=
 =?utf-8?B?L1BrdzVZUktMLy91UGM3VFJqblFSclNHN1VLbXYxRU5wS012UllhQm5aUHgv?=
 =?utf-8?B?MmNsZUlkb2k1V1k3SitPYlcxMEF2UlNVZG51VjVXZlJmdnlNc0NzQ0YzNHcw?=
 =?utf-8?B?US9BWTlMR0FHc2tSWU1ub3o1elcxeDFLWUtrbjhpcGl4S2hJL1VDdEpIY3kz?=
 =?utf-8?B?TnBOVEtQR2dETmRIbE5ZSzFiZmdNMHh6RElEalZuaE5mTFpIS3NISzFOUTE0?=
 =?utf-8?B?VGNTU01qNmFNRElXVVlUQVZQcXczM0Y4U3AvcHNLNVd5d0NBSUk0OEM0TXRi?=
 =?utf-8?B?QUp3TnhnRm1WMGRHc29Ob3R2NzhzcmJzU0dyaXcvbDUwRGZlNHFzQzkwdGtq?=
 =?utf-8?B?VE8yMjk1TXhkeHNVOXM2TEpUWTNmSnVPdVNFSWxZOGx6bG1TYUgrSlhBL2tG?=
 =?utf-8?B?WlFCblhMZEFuQkoyMExSSFQ0RjRsZ3hPYzhobWtLOGlPcHUwWEtpTlUxUU1D?=
 =?utf-8?B?bnQwRmlrc3FsSGg1U2tiaVgybWNabVdmMlloaHdBYmVlRC9RUEZUL0NRdHhk?=
 =?utf-8?B?RFozbDd0dTdFcHUxZXJOd2hjOVVzS0ZvUTJUQlBvQzNiaWEwejZINTUzeTAw?=
 =?utf-8?B?cHhWejFPa1UwNEhMQlJTK285c1F0SjArL3YxVTlhUmdmblpUVHcyT1BFN3VM?=
 =?utf-8?B?RU1GMzlVeDF0QkVpRTM0MHBOLzIvRFBxKzY5Y0dzZXJwTGxnNlBBUjN3Y0dD?=
 =?utf-8?B?WmYwUDVQU0hVdFNVRWlSb2RJbmkyL2p6ZmRWWlpkZTk1Q2d3SDZUZnBLcS9s?=
 =?utf-8?B?c2FCN0gwQ2Y3aUlHV1dJVmo4ODJqS3p1aW1yOFBqZWJ6TWQ0RkxOV1hnZ1Zs?=
 =?utf-8?B?SnpGeW9EcXZsMUcvWUdGS0g3Y2VUekovVC9ZWE1Kem1WOXUxck5hS0QyeWNS?=
 =?utf-8?B?T3k4RG43SWEwdEdYVUZjcFQ5TGIvUmtvb01OcTlBcHVac3lmVDlFVUVKak43?=
 =?utf-8?B?SzhCaWxzazM4UHJTN1lVRDBCM2lFancrcklkaXFNVFNFR2VoeGlnT1VubzY2?=
 =?utf-8?B?eU4zNnp6OU13L2tzU2hqcmtxRUZ3Mm5PemNLSTA5ampVbTJQZVdZRGdkMVc1?=
 =?utf-8?B?Q0wyWFVnN1hZQ0RnRFZXM0hheE43c0VRSWdJNDhBeGE0cm1EdHAxZmU2QzhY?=
 =?utf-8?B?Y0tzVFJiWGxzZTdndGJNUFk4QVBoOXMxSElaZnNOTGRNOGxWZWgwbGRBUDU4?=
 =?utf-8?B?UUhoSy9ObW9yMmdFMDVBaWQ3VHdaTm9JdW1zamQxYVVseGxaNVJjZjF4cVhX?=
 =?utf-8?B?dUIxV05PQTAxblFVMXE3aGRhek1McVNWaFZ3YmVORjJmbitXangrVSttTjhk?=
 =?utf-8?B?cnY0ditwWkZxVHdrOS9CQXkvV0VqcUc4NURIMHBhb1U1WWR5T2J2YnBzc0Yw?=
 =?utf-8?B?WEl2b09RUVJ6UFNRcnR2MU0ycVRHTklQWm9yNGIwRnZhRUlWcnJFUWhDNnd2?=
 =?utf-8?B?MUc5elRBSm0zaFZHOFV4RDFIVEpFc1pyOE5nVi9EWUd4V0JaOUltR3QvNzJ6?=
 =?utf-8?B?d2VjZmJiaUtFK3oxam10b09UUXFKUlE1ckcwK1VjelU1UXZETUZ6OE44ZmJL?=
 =?utf-8?Q?ekYFl1TB7CPkr9fmj69lAhc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C746B84289FBE04D8C4AEC364415E006@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8045f712-8c06-4b07-ec47-08db0a531e87
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Feb 2023 04:07:11.3219
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nqfCw5dFbExGOK7J31Ln53z1lcWYPr1mDqbaddlsXY4Nqdb9L42fd+K9k1KJATeAAgLGqehygkuAvSvynA03+XNB95lwYRZrkdATJuW+fJU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4767
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgT2xla3NpaiwNCk9uIFdlZCwgMjAyMy0wMi0wOCBhdCAxMTozMiArMDEwMCwgT2xla3NpaiBS
ZW1wZWwgd3JvdGU6DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3Bl
biBhdHRhY2htZW50cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiAN
Cj4gU29tZSBvZiBLU1o5NDc3IGZhbWlseSBzd2l0Y2hlcyBwcm92aWRlcyBFRUUgc3VwcG9ydC4g
DQoNCm5pdDogSWYgeW91IGNhbiBlbGFib3JhdGUgd2hhdCBhcmUgdGhlIGNoaXAgc3VwcG9ydHMg
d2lsbCBiZSBnb29kLiANCg0KPiBUbyBlbmFibGUgaXQsIHdlDQo+IGp1c3QgbmVlZCB0byByZWdp
c3RlciBzZXRfbWFjX2VlZS9zZXRfbWFjX2VlZSBoYW5kbGVycyBhbmQgdmFsaWRhdGUNCj4gc3Vw
cG9ydGVkIGNoaXAgdmVyc2lvbiBhbmQgcG9ydC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IE9sZWtz
aWogUmVtcGVsIDxvLnJlbXBlbEBwZW5ndXRyb25peC5kZT4NCj4gUmV2aWV3ZWQtYnk6IEFuZHJl
dyBMdW5uIDxhbmRyZXdAbHVubi5jaD4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9kc2EvbWljcm9j
aGlwL2tzel9jb21tb24uYyB8IDY1DQo+ICsrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAx
IGZpbGUgY2hhbmdlZCwgNjUgaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IGIvZHJpdmVycy9uZXQvZHNhL21p
Y3JvY2hpcC9rc3pfY29tbW9uLmMNCj4gaW5kZXggNDZiZWNjMDM4MmQ2Li4wYTJkNzgyNTNkMTcg
MTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+
ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9taWNyb2NoaXAva3N6X2NvbW1vbi5jDQo+IEBAIC0yNjcz
LDYgKzI2NzMsNjkgQEAgc3RhdGljIGludCBrc3pfbWF4X210dShzdHJ1Y3QgZHNhX3N3aXRjaCAq
ZHMsDQo+IGludCBwb3J0KQ0KPiAgICAgICAgIHJldHVybiAtRU9QTk9UU1VQUDsNCj4gIH0NCj4g
DQo+ICtzdGF0aWMgaW50IGtzel9nZXRfbWFjX2VlZShzdHJ1Y3QgZHNhX3N3aXRjaCAqZHMsIGlu
dCBwb3J0LA0KPiArICAgICAgICAgICAgICAgICAgICAgICAgICBzdHJ1Y3QgZXRodG9vbF9lZWUg
KmUpDQo+ICt7DQo+ICsgICAgICAgaW50IHJldDsNCj4gKw0KPiArICAgICAgIHJldCA9IGtzel92
YWxpZGF0ZV9lZWUoZHMsIHBvcnQpOw0KPiArICAgICAgIGlmIChyZXQpDQo+ICsgICAgICAgICAg
ICAgICByZXR1cm4gcmV0Ow0KPiArDQo+ICsgICAgICAgLyogVGhlcmUgaXMgbm8gZG9jdW1lbnRl
ZCBjb250cm9sIG9mIFR4IExQSSBjb25maWd1cmF0aW9uLiAqLw0KPiArICAgICAgIGUtPnR4X2xw
aV9lbmFibGVkID0gdHJ1ZTsNCg0KQmxhbmsgbGluZSBiZWZvcmUgY29tbWVudCB3aWxsIGluY3Jl
YXNlIHJlYWRhYmlsaXR5Lg0KDQo+ICsgICAgICAgLyogVGhlcmUgaXMgbm8gZG9jdW1lbnRlZCBj
b250cm9sIG9mIFR4IExQSSB0aW1lci4gQWNjb3JkaW5nDQo+IHRvIHRlc3RzDQo+ICsgICAgICAg
ICogVHggTFBJIHRpbWVyIHNlZW1zIHRvIGJlIHNldCBieSBkZWZhdWx0IHRvIG1pbmltYWwgdmFs
dWUuDQo+ICsgICAgICAgICovDQo+ICsgICAgICAgZS0+dHhfbHBpX3RpbWVyID0gMDsNCg0KZm9y
IGxwaV9lbmFibGVkLCB5b3UgaGF2ZSB1c2VkIHRydWUgYW5kIGZvciBscGlfdGltZXIgeW91IGhh
dmUgdXNlZCAwLg0KSXQgY2FuIGJlIGNvbnNpc3RlbnQgZWl0aGVyIHRydWUvZmFsc2Ugb3IgMS8w
LiANCg0KPiArDQo+ICsgICAgICAgcmV0dXJuIDA7DQo+ICt9DQo+ICsNCj4gDQo=
