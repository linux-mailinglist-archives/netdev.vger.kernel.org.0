Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 902B66D16B1
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 07:16:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229664AbjCaFQt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 01:16:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjCaFQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 01:16:48 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5562EB51;
        Thu, 30 Mar 2023 22:16:41 -0700 (PDT)
X-UUID: 3481c02ecf8311edb6b9f13eb10bd0fe-20230331
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=8QqqaBCnZs2Jx88uSemQErpuYCrxSL+y8tcCiZs5IBg=;
        b=fO/r8R39sDb6PlUWEvUqnXuSryKHJuHCt/ZY+OOAHZSmJV6KVEuvmu+k483OXjOji/W+NXCZf+H8+pbVXXPFCplHX4GuOwVC5sJA6VZcM2ByJ0F74kjewMaKjIKQMdu+B/IAA68CadGVOyt0iuHzH+r2sZ0+PQeTFdEm7uxnHRA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:45ce6de3-c044-4c00-80bd-75d3dd80e1d2,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:574e7cf7-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: 3481c02ecf8311edb6b9f13eb10bd0fe-20230331
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1818616103; Fri, 31 Mar 2023 13:16:34 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 31 Mar 2023 13:16:33 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 31 Mar 2023 13:16:33 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NhFxO1GGWDCIfmKauuBbCQW+UIqlrSC81GhGA3q6z2vd4SJSytyqbU+6mlinywjgprOU8t52CAtim20BjkDFQRIhX3MDprdjWr2jxUbgNbNbEwnVXYP+Lza9HNQRdAtoa/UTVYXX5QmnGHvglPrZCNimfc0UjeiiHRx3tl4kASxkUFLh0Wn8m6k0usVHeh2FglcDDSLg2XVhA3LbWRlxtgCr0wr29x9K0uzryESv7DYD/4INbqRmTwEWKQjj6PrbuxQmeWnd9iFgAK0I1buikCgtjImgsjRuzkci+QTovtYoFVf5re1py02I1llon1oB8dOZiB7WVwi5+WVMfrT0/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8QqqaBCnZs2Jx88uSemQErpuYCrxSL+y8tcCiZs5IBg=;
 b=BiAQhGVeTXXjT6HVL/2c5GbJ7bR6YKXWln1sR7soi+Ict6HLHvLUPUY5YQHdOaR9YWFUDjIyyOwm1WQpEyM6Jj77qOio9Jb4OnuTYnzBQy7es5vqfwHU8c+8UwMpyF5GOWgAHIwrWV+pKxUq+mcFNmG4gm+AUWv4C7ptRVk/kgq79TrFEmIhBHpk8hVmWnUBPPOPMT9NMfOc/zN0d9dcLuvHn3PAOoBQNBzQ9niIbsGso3V+5QIq2CXAefq1rqM+ZMHt2jwAYKLTF57yo77YRAXub5dfRuM4cdEwCCNu6Ucofp0k2lE8pUxx7Qo/qKcJ2wMKBh1sOTD17Q2p2f87Bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8QqqaBCnZs2Jx88uSemQErpuYCrxSL+y8tcCiZs5IBg=;
 b=No39ZUse/lUayAXfW9ET/iZKMNDwpwl8iLsQq5bvcOHNGpp4QVeiKG6TD0COohHl55QEJZpcquSUCt7y/G+puI+gp8nogz1poDnyWQ/OWtNBFwhgeagt8sHZJKYJ6s43yhZT7EXPg2BzOuvYjjwXz3FpzhLrenqPjYm0BJHUmfE=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by TY0PR03MB6701.apcprd03.prod.outlook.com (2603:1096:400:212::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6254.22; Fri, 31 Mar
 2023 05:16:27 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.041; Fri, 31 Mar 2023
 05:16:27 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
CC:     "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        Project_Global_Chrome_Upstream_Group 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v6 12/19] clk: mediatek: Add MT8188 vdosys0 clock support
Thread-Topic: [PATCH v6 12/19] clk: mediatek: Add MT8188 vdosys0 clock support
Thread-Index: AQHZUo7DVhpY191gr0ml28KUEv4EDa76BX+AgBp1RIA=
Date:   Fri, 31 Mar 2023 05:16:26 +0000
Message-ID: <db16219a6b6c194235d847eb035aa48fad93bf88.camel@mediatek.com>
References: <20230309135419.30159-1-Garmin.Chang@mediatek.com>
         <20230309135419.30159-13-Garmin.Chang@mediatek.com>
         <cd0289cc-00cb-398a-214e-09b994de4274@collabora.com>
In-Reply-To: <cd0289cc-00cb-398a-214e-09b994de4274@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|TY0PR03MB6701:EE_
x-ms-office365-filtering-correlation-id: 41f5f925-dea6-45b4-55ee-08db31a713fc
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +KPsmHWpRSpiWl4CjJGQwV3OPnFsQ505gWPN8JCT/7T3QPAkXrzv3ovOiX4848vbxL4nnB1ok9pkmOnK7qpU7YdG2ZhOqO1Ul7hxLyIc1MpOMQmab+G2uWSvtTjKLmfCMaId/I3oIXNxFVgiujqhUGkcxwC4zbEBoeCvbWQzgVh9WfGh75pz0UyLoft5du4GKzO2xsaHxfuH5kaM9JQFViiTY+FSP/w76/bThUPG10d7z9iqDwB+ikiDIYOOpj6tg6BHG9se4tDqBamDR2aFWErASPbGokdd+OIYzsf0lJEKmMmVFCghLFNpnsx8hTe6ZX5sc5X2DQMvUU8M8vgbC7S/vZEguLmxc1Cmb74Q2sYhpySTKnLdYKAL4XHM2yJ6FnG//sBHXtSsFOErIylWwLTaiJODHXvvqPByadbDFIqJwnLP8fVew/idNUUCBVUDHOdurxWSUSfe78APiktRljjneOWFdtRWFpGmcQiDRBbhKuPsaQm4qubsXnQ+zBl7X+N1Ry2a+7SLr82x4MyG6thY9AVU9KjXmnl4py0zEDOZD2TNmFOMjjVvOLiiDshfKzXD17JmeOpALtxoLzl0pmTBJ2bpg3GHNIzIV3oE2DTR3Wpxn+wsmZZIEIDv3Gyx
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(451199021)(71200400001)(6486002)(54906003)(110136005)(478600001)(122000001)(86362001)(38070700005)(38100700002)(2616005)(36756003)(85182001)(186003)(83380400001)(6506007)(6512007)(26005)(41300700001)(2906002)(8936002)(5660300002)(7416002)(91956017)(316002)(66476007)(8676002)(64756008)(66446008)(76116006)(66556008)(4326008)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djlTOGlVZEs2TzI2eVdGZ3dwa3A3cTRFdW1uK3pFTmtGQkRyTkVGSndTSnpB?=
 =?utf-8?B?VFpyWmVzdEEreTBDN3RVTy9lYTFrTHY5dVpFbnNSWWVpVzI4UTFMcUhHeEMx?=
 =?utf-8?B?UG52Q2lHSCtMUHYwcnZUZ29oOXJQdEhsWGZSWUthUC9EV1BIZVprQStWYktT?=
 =?utf-8?B?dVpOWjBaRjlkQ3VlYkFnM2crS1BRTXIrbFpzUDZBVzNXRnc2VHMwTDFBMjZS?=
 =?utf-8?B?MGVMaWhiT1NTWEFYMUdkSFlXOW95TnVmK0xCL2VUeUlHY25WV3ZvNmpWcTVX?=
 =?utf-8?B?MUk1YjhiUnJrTEFkQjBzbTJUU3RrUjFSb3IrbUhBUFZUWkJyR01zblRlZkRZ?=
 =?utf-8?B?MWNHVm14MDBxRlhMMzhubWpuVkhrSXArUjhyaFNuSmhnc3hpamwrclp5SWNP?=
 =?utf-8?B?anR6N1VlaWo2b2Z0ai9hdk5oL05KcjR0OTd2dnhlaUpQaEZ0Sk9pbWtLemQz?=
 =?utf-8?B?cnQvbS85RkRoWTBUTHpIa2l0c0Q3T0ZPVjVZRjl1MklDb3lkV3QwZldZSmJx?=
 =?utf-8?B?YXVVVi9YTlBGZTBmU3AzdS9TZEt5b0NCcVkzVllHT2UyVXNnTXkrRWhQbnZG?=
 =?utf-8?B?Ymt5QXcrdkF1ZjFMTkpzaHl5ZmV5Y2VSUU94djdvZmh1M3VWYWxBMTBKb3c3?=
 =?utf-8?B?dmVSYWZiLzB1b0VzYUlER05iVDBaMEwxZk5pc0VhL005WldFc3ZSdUthajZl?=
 =?utf-8?B?SnIreDVoSnJXWEZBYm95T283dE4xS3NlczNPaUpoOXhZbG9TMzdtKzlPcGE0?=
 =?utf-8?B?WUNxd1hqVTlKL1Q2UXp6ZytIQzVxV0hzZ01pTjZoY2xvc2ZraGt5dUhRS0pu?=
 =?utf-8?B?ZWxHc2xGZGFEM1JvNnc3T281WVp5T1dlV1ZmaTFkWVNoQW1GdHNvYzhGRXdz?=
 =?utf-8?B?SGFCYnJoT2dSVXYwWUN4QXd1RkR5UVQyYlJhYSt1OHR0RzlhZFB5NFdXUTUw?=
 =?utf-8?B?cHNadWd1R0VyVUY0R3YwRUtVWWJuakZ3dVFZOEVJKzU3MmMrUTYrQjEzYzhP?=
 =?utf-8?B?RDVpMEZGNmFaYmVDMXdtQ1R3eWpoQk1JeThvMHFQelZaUmVNcDdCK2FIQjNa?=
 =?utf-8?B?b0ZUWU1IbTJKU0wyRnVnTWNFQlkwVUZzempMcm1WY01iRVFaLzllY0lWek1O?=
 =?utf-8?B?Z3M2T0gzRU9DclUwSHlTSkJpckMxVUVSaXRMZW1va3Blb29qWjcwM1ZwNFdK?=
 =?utf-8?B?NnNiTUJtaSttUzF1UkI0bTF4a3hLUkZ0V2pYdFdqWXpmNzduaklPTjN4NGNo?=
 =?utf-8?B?Zy9ZVU84RWpPZDlOMUgxbWdRSm5rYlVnUHl6b0IxMHRySVFKcDdXVGViQms1?=
 =?utf-8?B?YXJCL2FERUxoYzh5ME1pTFl4RFVOdHJyK09CcjM5L29RSWJuNDNGa2hLVlh3?=
 =?utf-8?B?Q2JhVW1OeUlMSlFmMWNkRC9MdDAvb1NXd1ZpQ0xHd1FMNGJCbmh0YVRnRi83?=
 =?utf-8?B?KzdDai9DMFluWWJSZGZ4aWsxR3plZUZWYVBTanAwZnNNcHNHdmQrL2NWTXBv?=
 =?utf-8?B?UHF6TlNyMFdKd0V0OVJueTdNbjVyTjR2clVVLzE2Wk9PSi96Wmt5OUNwV29H?=
 =?utf-8?B?UzRMUXBCNFoxdTFteTdiYUdxb1Nsa1RubFpHay9Rd3VORHBrSm5kN05iN0d4?=
 =?utf-8?B?eW52TDN5R2J0WWR3Q2U0clN1K3FMZFdLaVRpZjQ3RVNmMjExVUdUVEZmZ3FT?=
 =?utf-8?B?WkpaSGRYWmVvZGJ6alQ2bDlha1RBNkFDNUdQbzZ0TWkwajY3WkFhQzd4djk1?=
 =?utf-8?B?Zm1zN3FjaGFNcDl1ZDdKeXZpcWUrRWQvUE0wTDdzT1habVNEN0ZkaHI4MElq?=
 =?utf-8?B?Mm9sOXdzQzFFYUF3ZCtydmV2V1MvSFJ1RHpsS2JwRVRHamI4V2xHSk9EcUgw?=
 =?utf-8?B?cjZuR1hpVm8wSTlXR2VjMmZ2TU1RNTZTNHNQcHZRejYzTDRvVno5aGR1UVJy?=
 =?utf-8?B?U1hQandub3c0bFQzb1FzdXRoVERscnhzMVFsWE5YNHFmL09EdEs1a1V6T3Ry?=
 =?utf-8?B?b1VZLzZ4S1dtc0tpVlM2RnpuRGFzNlU2aHFSZUNYcWgwWGZYRWhFV2xVME4v?=
 =?utf-8?B?cFhmNVJZQi84UzZYMzc5Um05Vk0zVjdzVk5BMzIxTFU5OThVbVlpVTNBREV1?=
 =?utf-8?B?TmlkVFZHNEZtN1JPcDh2S3RJald1enRrQnVheGZMK0thL09FRTBYcXI5RHZ3?=
 =?utf-8?B?eXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2EB1D1BFE9B5A840ACAC939B15A7B48C@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41f5f925-dea6-45b4-55ee-08db31a713fc
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2023 05:16:26.7192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SErQScerMturv06vao7zgwvcJCBPO7qHQmzTptt1apmezxjSDy1LX0sOGVRwgQhJZ1xvnvNW3mEP08ltN5S9/qnWsSP8oJcb1s0gggzvAjU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6701
X-Spam-Status: No, score=1.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,RDNS_NONE,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIzLTAzLTE0IGF0IDEwOjEzICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gSWwgMDkvMDMvMjMgMTQ6NTQsIEdhcm1pbi5DaGFuZyBoYSBzY3JpdHRv
Og0KPiA+IEFkZCBNVDgxODggdmRvc3lzMCBjbG9jayBjb250cm9sbGVyIHdoaWNoIHByb3ZpZGVz
IGNsb2NrIGdhdGUNCj4gPiBjb250cm9sIGluIHZpZGVvIHN5c3RlbS4gVGhpcyBpcyBpbnRlZ3Jh
dGVkIHdpdGggbXRrLW1tc3lzDQo+ID4gZHJpdmVyIHdoaWNoIHdpbGwgcG9wdWxhdGUgZGV2aWNl
IGJ5IHBsYXRmb3JtX2RldmljZV9yZWdpc3Rlcl9kYXRhDQo+ID4gdG8gc3RhcnQgdmRvc3lzIGNs
b2NrIGRyaXZlci4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBHYXJtaW4uQ2hhbmcgPEdhcm1p
bi5DaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gICBkcml2ZXJzL2Nsay9tZWRpYXRl
ay9NYWtlZmlsZSAgICAgICAgICB8ICAgMyArLQ0KPiA+ICAgZHJpdmVycy9jbGsvbWVkaWF0ZWsv
Y2xrLW10ODE4OC12ZG8wLmMgfCAxMzUNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKysrDQo+
ID4gICAyIGZpbGVzIGNoYW5nZWQsIDEzNyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+
ID4gICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xrLW10ODE4OC12
ZG8wLmMNCj4gPiANCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZp
bGUNCj4gPiBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gaW5kZXggYmY4ZTUw
YjU0YmI0Li5mY2E2NmMzN2NlY2MgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jbGsvbWVkaWF0
ZWsvTWFrZWZpbGUNCj4gPiArKysgYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+
IEBAIC05NCw3ICs5NCw4IEBAIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE4NikgKz0gY2xr
LW10ODE4Ni0NCj4gPiBtY3UubyBjbGstbXQ4MTg2LXRvcGNrZ2VuLm8gY2xrLW10DQo+ID4gICBv
YmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxODgpICs9IGNsay1tdDgxODgtYXBtaXhlZHN5cy5v
IGNsay0NCj4gPiBtdDgxODgtdG9wY2tnZW4ubyBcDQo+ID4gICAJCQkJICAgY2xrLW10ODE4OC1w
ZXJpX2FvLm8gY2xrLW10ODE4OC0NCj4gPiBpbmZyYV9hby5vIFwNCj4gPiAgIAkJCQkgICBjbGst
bXQ4MTg4LWNhbS5vIGNsay1tdDgxODgtY2N1Lm8NCj4gPiBjbGstbXQ4MTg4LWltZy5vIFwNCj4g
PiAtCQkJCSAgIGNsay1tdDgxODgtaXBlLm8gY2xrLW10ODE4OC1tZmcubw0KPiA+IGNsay1tdDgx
ODgtdmRlYy5vDQo+ID4gKwkJCQkgICBjbGstbXQ4MTg4LWlwZS5vIGNsay1tdDgxODgtbWZnLm8N
Cj4gPiBjbGstbXQ4MTg4LXZkZWMubyBcDQo+ID4gKwkJCQkgICBjbGstbXQ4MTg4LXZkbzAubw0K
PiA+ICAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyKSArPSBjbGstbXQ4MTkyLm8NCj4g
PiAgIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE5Ml9BVURTWVMpICs9IGNsay1tdDgxOTIt
YXVkLm8NCj4gPiAgIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE5Ml9DQU1TWVMpICs9IGNs
ay1tdDgxOTItY2FtLm8NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvY2xr
LW10ODE4OC12ZG8wLmMNCj4gPiBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtdmRv
MC5jDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLmY2
NDlmNjAzYWFiNw0KPiA+IC0tLSAvZGV2L251bGwNCj4gPiArKysgYi9kcml2ZXJzL2Nsay9tZWRp
YXRlay9jbGstbXQ4MTg4LXZkbzAuYw0KPiA+IEBAIC0wLDAgKzEsMTM1IEBADQo+ID4gKy8vIFNQ
RFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiArLy8NCj4gPiArLy8gQ29w
eXJpZ2h0IChjKSAyMDIyIE1lZGlhVGVrIEluYy4NCj4gPiArLy8gQXV0aG9yOiBHYXJtaW4gQ2hh
bmcgPGdhcm1pbi5jaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGlu
dXgvY2xrLXByb3ZpZGVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2Uu
aD4NCj4gPiArI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1jbGsu
aD4NCj4gPiArDQo+ID4gKyNpbmNsdWRlICJjbGstZ2F0ZS5oIg0KPiA+ICsjaW5jbHVkZSAiY2xr
LW10ay5oIg0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZV9yZWdzIHZk
bzBfMF9jZ19yZWdzID0gew0KPiA+ICsJLnNldF9vZnMgPSAweDEwNCwNCj4gPiArCS5jbHJfb2Zz
ID0gMHgxMDgsDQo+ID4gKwkuc3RhX29mcyA9IDB4MTAwLA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiAr
c3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZV9yZWdzIHZkbzBfMV9jZ19yZWdzID0gew0KPiA+
ICsJLnNldF9vZnMgPSAweDExNCwNCj4gPiArCS5jbHJfb2ZzID0gMHgxMTgsDQo+ID4gKwkuc3Rh
X29mcyA9IDB4MTEwLA0KPiA+ICt9Ow0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBt
dGtfZ2F0ZV9yZWdzIHZkbzBfMl9jZ19yZWdzID0gew0KPiA+ICsJLnNldF9vZnMgPSAweDEyNCwN
Cj4gPiArCS5jbHJfb2ZzID0gMHgxMjgsDQo+ID4gKwkuc3RhX29mcyA9IDB4MTIwLA0KPiA+ICt9
Ow0KPiA+ICsNCj4gPiArI2RlZmluZSBHQVRFX1ZETzBfMChfaWQsIF9uYW1lLCBfcGFyZW50LCBf
c2hpZnQpCQkJDQo+ID4gXA0KPiA+ICsJR0FURV9NVEsoX2lkLCBfbmFtZSwgX3BhcmVudCwgJnZk
bzBfMF9jZ19yZWdzLCBfc2hpZnQsDQo+ID4gJm10a19jbGtfZ2F0ZV9vcHNfc2V0Y2xyKQ0KPiA+
ICsNCj4gPiArI2RlZmluZSBHQVRFX1ZETzBfMShfaWQsIF9uYW1lLCBfcGFyZW50LCBfc2hpZnQp
CQkJDQo+ID4gXA0KPiA+ICsJR0FURV9NVEsoX2lkLCBfbmFtZSwgX3BhcmVudCwgJnZkbzBfMV9j
Z19yZWdzLCBfc2hpZnQsDQo+ID4gJm10a19jbGtfZ2F0ZV9vcHNfc2V0Y2xyKQ0KPiA+ICsNCj4g
PiArI2RlZmluZSBHQVRFX1ZETzBfMihfaWQsIF9uYW1lLCBfcGFyZW50LCBfc2hpZnQpCQkJDQo+
ID4gXA0KPiA+ICsJR0FURV9NVEsoX2lkLCBfbmFtZSwgX3BhcmVudCwgJnZkbzBfMl9jZ19yZWdz
LCBfc2hpZnQsDQo+ID4gJm10a19jbGtfZ2F0ZV9vcHNfc2V0Y2xyKQ0KPiA+ICsNCj4gPiArI2Rl
ZmluZSBHQVRFX1ZETzBfMl9GTEFHUyhfaWQsIF9uYW1lLCBfcGFyZW50LCBfc2hpZnQsIF9mbGFn
cykJDQo+ID4gCVwNCj4gPiArCUdBVEVfTVRLX0ZMQUdTKF9pZCwgX25hbWUsIF9wYXJlbnQsICZ2
ZG8wXzJfY2dfcmVncywgX3NoaWZ0LAkNCj4gPiBcDQo+ID4gKwkmbXRrX2Nsa19nYXRlX29wc19z
ZXRjbHIsIF9mbGFncykNCj4gPiArDQo+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2dhdGUg
dmRvMF9jbGtzW10gPSB7DQo+ID4gKwkvKiBWRE8wXzAgKi8NCj4gPiArCUdBVEVfVkRPMF8wKENM
S19WRE8wX0RJU1BfT1ZMMCwgInZkbzBfZGlzcF9vdmwwIiwgInRvcF92cHAiLA0KPiA+IDApLA0K
PiA+ICsJR0FURV9WRE8wXzAoQ0xLX1ZETzBfRkFLRV9FTkcwLCAidmRvMF9mYWtlX2VuZzAiLCAi
dG9wX3ZwcCIsDQo+ID4gMiksDQo+ID4gKwlHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX0NDT1JS
MCwgInZkbzBfZGlzcF9jY29ycjAiLA0KPiA+ICJ0b3BfdnBwIiwgNCksDQo+ID4gKwlHQVRFX1ZE
TzBfMChDTEtfVkRPMF9ESVNQX01VVEVYMCwgInZkbzBfZGlzcF9tdXRleDAiLA0KPiA+ICJ0b3Bf
dnBwIiwgNiksDQo+ID4gKwlHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX0dBTU1BMCwgInZkbzBf
ZGlzcF9nYW1tYTAiLA0KPiA+ICJ0b3BfdnBwIiwgOCksDQo+ID4gKwlHQVRFX1ZETzBfMChDTEtf
VkRPMF9ESVNQX0RJVEhFUjAsICJ2ZG8wX2Rpc3BfZGl0aGVyMCIsDQo+ID4gInRvcF92cHAiLCAx
MCksDQo+ID4gKwlHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX1dETUEwLCAidmRvMF9kaXNwX3dk
bWEwIiwgInRvcF92cHAiLA0KPiA+IDE3KSwNCj4gPiArCUdBVEVfVkRPMF8wKENMS19WRE8wX0RJ
U1BfUkRNQTAsICJ2ZG8wX2Rpc3BfcmRtYTAiLCAidG9wX3ZwcCIsDQo+ID4gMTkpLA0KPiA+ICsJ
R0FURV9WRE8wXzAoQ0xLX1ZETzBfRFNJMCwgInZkbzBfZHNpMCIsICJ0b3BfdnBwIiwgMjEpLA0K
PiA+ICsJR0FURV9WRE8wXzAoQ0xLX1ZETzBfRFNJMSwgInZkbzBfZHNpMSIsICJ0b3BfdnBwIiwg
MjIpLA0KPiA+ICsJR0FURV9WRE8wXzAoQ0xLX1ZETzBfRFNDX1dSQVAwLCAidmRvMF9kc2Nfd3Jh
cDAiLCAidG9wX3ZwcCIsDQo+ID4gMjMpLA0KPiA+ICsJR0FURV9WRE8wXzAoQ0xLX1ZETzBfVlBQ
X01FUkdFMCwgInZkbzBfdnBwX21lcmdlMCIsICJ0b3BfdnBwIiwNCj4gPiAyNCksDQo+ID4gKwlH
QVRFX1ZETzBfMChDTEtfVkRPMF9EUF9JTlRGMCwgInZkbzBfZHBfaW50ZjAiLCAidG9wX3ZwcCIs
IDI1KSwNCj4gPiArCUdBVEVfVkRPMF8wKENMS19WRE8wX0RJU1BfQUFMMCwgInZkbzBfZGlzcF9h
YWwwIiwgInRvcF92cHAiLA0KPiA+IDI2KSwNCj4gPiArCUdBVEVfVkRPMF8wKENMS19WRE8wX0lO
TElORVJPVDAsICJ2ZG8wX2lubGluZXJvdDAiLCAidG9wX3ZwcCIsDQo+ID4gMjcpLA0KPiA+ICsJ
R0FURV9WRE8wXzAoQ0xLX1ZETzBfQVBCX0JVUywgInZkbzBfYXBiX2J1cyIsICJ0b3BfdnBwIiwg
MjgpLA0KPiA+ICsJR0FURV9WRE8wXzAoQ0xLX1ZETzBfRElTUF9DT0xPUjAsICJ2ZG8wX2Rpc3Bf
Y29sb3IwIiwNCj4gPiAidG9wX3ZwcCIsIDI5KSwNCj4gPiArCUdBVEVfVkRPMF8wKENMS19WRE8w
X01EUF9XUk9UMCwgInZkbzBfbWRwX3dyb3QwIiwgInRvcF92cHAiLA0KPiA+IDMwKSwNCj4gPiAr
CUdBVEVfVkRPMF8wKENMS19WRE8wX0RJU1BfUlNaMCwgInZkbzBfZGlzcF9yc3owIiwgInRvcF92
cHAiLA0KPiA+IDMxKSwNCj4gPiArCS8qIFZETzBfMSAqLw0KPiA+ICsJR0FURV9WRE8wXzEoQ0xL
X1ZETzBfRElTUF9QT1NUTUFTSzAsICJ2ZG8wX2Rpc3BfcG9zdG1hc2swIiwNCj4gPiAidG9wX3Zw
cCIsIDApLA0KPiA+ICsJR0FURV9WRE8wXzEoQ0xLX1ZETzBfRkFLRV9FTkcxLCAidmRvMF9mYWtl
X2VuZzEiLCAidG9wX3ZwcCIsDQo+ID4gMSksDQo+ID4gKwlHQVRFX1ZETzBfMShDTEtfVkRPMF9E
TF9BU1lOQzIsICJ2ZG8wX2RsX2FzeW5jMiIsICJ0b3BfdnBwIiwNCj4gPiA1KSwNCj4gPiArCUdB
VEVfVkRPMF8xKENMS19WRE8wX0RMX1JFTEFZMywgInZkbzBfZGxfcmVsYXkzIiwgInRvcF92cHAi
LA0KPiA+IDYpLA0KPiA+ICsJR0FURV9WRE8wXzEoQ0xLX1ZETzBfRExfUkVMQVk0LCAidmRvMF9k
bF9yZWxheTQiLCAidG9wX3ZwcCIsDQo+ID4gNyksDQo+ID4gKwlHQVRFX1ZETzBfMShDTEtfVkRP
MF9TTUlfR0FMUywgInZkbzBfc21pX2dhbHMiLCAidG9wX3ZwcCIsIDEwKSwNCj4gPiArCUdBVEVf
VkRPMF8xKENMS19WRE8wX1NNSV9DT01NT04sICJ2ZG8wX3NtaV9jb21tb24iLCAidG9wX3ZwcCIs
DQo+ID4gMTEpLA0KPiA+ICsJR0FURV9WRE8wXzEoQ0xLX1ZETzBfU01JX0VNSSwgInZkbzBfc21p
X2VtaSIsICJ0b3BfdnBwIiwgMTIpLA0KPiA+ICsJR0FURV9WRE8wXzEoQ0xLX1ZETzBfU01JX0lP
TU1VLCAidmRvMF9zbWlfaW9tbXUiLCAidG9wX3ZwcCIsDQo+ID4gMTMpLA0KPiA+ICsJR0FURV9W
RE8wXzEoQ0xLX1ZETzBfU01JX0xBUkIsICJ2ZG8wX3NtaV9sYXJiIiwgInRvcF92cHAiLCAxNCks
DQo+ID4gKwlHQVRFX1ZETzBfMShDTEtfVkRPMF9TTUlfUlNJLCAidmRvMF9zbWlfcnNpIiwgInRv
cF92cHAiLCAxNSksDQo+ID4gKwkvKiBWRE8wXzIgKi8NCj4gPiArCUdBVEVfVkRPMF8yKENMS19W
RE8wX0RTSTBfRFNJLCAidmRvMF9kc2kwX2RzaSIsICJ0b3BfZHNpX29jYyIsDQo+ID4gMCksDQo+
ID4gKwlHQVRFX1ZETzBfMihDTEtfVkRPMF9EU0kxX0RTSSwgInZkbzBfZHNpMV9kc2kiLCAidG9w
X2RzaV9vY2MiLA0KPiA+IDgpLA0KPiA+ICsJR0FURV9WRE8wXzJfRkxBR1MoQ0xLX1ZETzBfRFBf
SU5URjBfRFBfSU5URiwNCj4gPiAidmRvMF9kcF9pbnRmMF9kcF9pbnRmIiwNCj4gPiArCQkidG9w
X2VkcCIsIDE2LCBDTEtfU0VUX1JBVEVfUEFSRU5UKSwNCj4gPiArfTsNCj4gPiArDQo+ID4gK3N0
YXRpYyBpbnQgY2xrX210ODE4OF92ZG8wX3Byb2JlKHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2UgKnBk
ZXYpDQo+ID4gK3sNCj4gPiArCXN0cnVjdCBkZXZpY2UgKmRldiA9ICZwZGV2LT5kZXY7DQo+ID4g
KwlzdHJ1Y3QgZGV2aWNlX25vZGUgKm5vZGUgPSBkZXYtPnBhcmVudC0+b2Zfbm9kZTsNCj4gPiAr
CXN0cnVjdCBjbGtfaHdfb25lY2VsbF9kYXRhICpjbGtfZGF0YTsNCj4gPiArCWludCByOw0KPiA+
ICsNCj4gPiArCWNsa19kYXRhID0gbXRrX2FsbG9jX2Nsa19kYXRhKENMS19WRE8wX05SX0NMSyk7
DQo+ID4gKwlpZiAoIWNsa19kYXRhKQ0KPiA+ICsJCXJldHVybiAtRU5PTUVNOw0KPiA+ICsNCj4g
PiArCXIgPSBtdGtfY2xrX3JlZ2lzdGVyX2dhdGVzKCZwZGV2LT5kZXYsIG5vZGUsIHZkbzBfY2xr
cywNCj4gPiArCQkJCSAgIEFSUkFZX1NJWkUodmRvMF9jbGtzKSwgY2xrX2RhdGEpOw0KPiA+ICsJ
aWYgKHIpDQo+ID4gKwkJZ290byBmcmVlX3ZkbzBfZGF0YTsNCj4gPiArDQo+ID4gKwlyID0gb2Zf
Y2xrX2FkZF9od19wcm92aWRlcihub2RlLCBvZl9jbGtfaHdfb25lY2VsbF9nZXQsDQo+ID4gY2xr
X2RhdGEpOw0KPiA+ICsJaWYgKHIpDQo+ID4gKwkJZ290byB1bnJlZ2lzdGVyX2dhdGVzOw0KPiA+
ICsNCj4gPiArCXBsYXRmb3JtX3NldF9kcnZkYXRhKHBkZXYsIGNsa19kYXRhKTsNCj4gPiArDQo+
ID4gKwlyZXR1cm4gcjsNCj4gPiArDQo+ID4gK3VucmVnaXN0ZXJfZ2F0ZXM6DQo+ID4gKwltdGtf
Y2xrX3VucmVnaXN0ZXJfZ2F0ZXModmRvMF9jbGtzLCBBUlJBWV9TSVpFKHZkbzBfY2xrcyksDQo+
ID4gY2xrX2RhdGEpOw0KPiA+ICtmcmVlX3ZkbzBfZGF0YToNCj4gPiArCW10a19mcmVlX2Nsa19k
YXRhKGNsa19kYXRhKTsNCj4gPiArCXJldHVybiByOw0KPiA+ICt9DQo+ID4gKw0KPiA+ICtzdGF0
aWMgaW50IGNsa19tdDgxODhfdmRvMF9yZW1vdmUoc3RydWN0IHBsYXRmb3JtX2RldmljZSAqcGRl
dikNCj4gPiArew0KPiA+ICsJc3RydWN0IGRldmljZSAqZGV2ID0gJnBkZXYtPmRldjsNCj4gPiAr
CXN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSA9IGRldi0+cGFyZW50LT5vZl9ub2RlOw0KPiA+ICsJ
c3RydWN0IGNsa19od19vbmVjZWxsX2RhdGEgKmNsa19kYXRhID0NCj4gPiBwbGF0Zm9ybV9nZXRf
ZHJ2ZGF0YShwZGV2KTsNCj4gPiArDQo+ID4gKwlvZl9jbGtfZGVsX3Byb3ZpZGVyKG5vZGUpOw0K
PiA+ICsJbXRrX2Nsa191bnJlZ2lzdGVyX2dhdGVzKHZkbzBfY2xrcywgQVJSQVlfU0laRSh2ZG8w
X2Nsa3MpLA0KPiA+IGNsa19kYXRhKTsNCj4gPiArCW10a19mcmVlX2Nsa19kYXRhKGNsa19kYXRh
KTsNCj4gPiArDQo+ID4gKwlyZXR1cm4gMDsNCj4gPiArfQ0KPiA+ICsNCj4gDQo+IHN0YXRpYyBj
b25zdCBzdHJ1Y3QgbXRrX2Nsa19kZXNjIHZkbzBfZGVzYyA9IHsNCj4gCS5jbGtzIC4uLg0KPiAJ
Lm51bV9jbGtzIC4uLi4NCj4gfTsNCj4gDQo+IHN0YXRpYyBjb25zdCBzdHJ1Y3QgcGxhdGZvcm1f
ZGV2aWNlX2lkIGNsa19tdDgxODhfdmRvMF9pZF90YWJsZVtdID0gew0KPiAJeyAubmFtZSA9ICJj
bGstbXQ4MTg4LXZkbzAiLCAuZHJpdmVyX2RhdGEgPQ0KPiAoa2VybmVsX3Vsb25nX1QpJnZkbzBf
ZGVzYyB9LA0KPiAJeyAvKiBzZW50aW5lbCAqLyB9DQo+IH07DQo+IA0KPiA+ICtzdGF0aWMgc3Ry
dWN0IHBsYXRmb3JtX2RyaXZlciBjbGtfbXQ4MTg4X3ZkbzBfZHJ2ID0gew0KPiA+ICsJLnByb2Jl
ID0gY2xrX210ODE4OF92ZG8wX3Byb2JlLA0KPiA+ICsJLnJlbW92ZSA9IGNsa19tdDgxODhfdmRv
MF9yZW1vdmUsDQo+IA0KPiAJLnByb2JlID0gbXRrX2Nsa19wZGV2X3Byb2JlLA0KPiAJLnJlbW92
ZSA9IG10a19jbGtfcGRldl9yZW1vdmUsDQo+IA0KPiA+ICsJLmRyaXZlciA9IHsNCj4gPiArCQku
bmFtZSA9ICJjbGstbXQ4MTg4LXZkbzAiLA0KPiA+ICsJfSwNCj4gDQo+IAkuaWRfdGFibGUgPSBj
bGtfbXQ4MTg4X3ZkbzBfaWRfdGFibGUsDQo+IA0KPiA+ICt9Ow0KPiA+ICtidWlsdGluX3BsYXRm
b3JtX2RyaXZlcihjbGtfbXQ4MTg4X3ZkbzBfZHJ2KTsNCj4gDQo+IG1vZHVsZV9wbGF0Zm9ybV9k
cml2ZXIgYW5kIE1PRFVMRV9MSUNFTlNFLg0KPiANCj4gU2FtZSBmb3IgVkRPMSwgVlBQMCwgVlBQ
MS4NCj4gDQo+IFJlZ2FyZHMsDQo+IEFuZ2Vsbw0KDQpUaGFuayB5b3UgZm9yIHlvdXIgc3VnZ2Vz
dGlvbnMuDQoNCk9LLCBJIHVzZSBtdGtfY2xrX3BkZXZfcHJvYmUgZm9yIFZETzAsIFZETzEsIFZQ
UDAsIFZQUDEgaW4gdjcuDQoNClRoYW5rcywNCkJlc3QgUmVnYXJkcywNCkdhcm1pbg0K
