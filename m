Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F0267348F
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 10:38:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjASJiL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Jan 2023 04:38:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229592AbjASJiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Jan 2023 04:38:10 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B78DA5D106;
        Thu, 19 Jan 2023 01:38:02 -0800 (PST)
X-UUID: f28d54c297dc11ed945fc101203acc17-20230119
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=0D4pgzAENKu76Tq9YUFGozuOAdfp7hrKPFcqou0eIdY=;
        b=CUTDs51mVNitpagoo8fJkZF8uckTpwEEKQZAJ1B/YH7I6Jio1D4/Es+9Pa81aQ8ys+7J5FljJNElYjB4ZTq2mCqmSgSIbqlzFayupquVt1RE18WEx80pxK9oKsJoFNNm660MgXCAtFfiy5EF58yRbgV/fRmct4H/FCvlyzTHloU=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:53992ee1-344b-4b10-8b82-52e52c2ef942,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:3ca2d6b,CLOUDID:4b8b1c55-dd49-462e-a4be-2143a3ddc739,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0,NGT
X-UUID: f28d54c297dc11ed945fc101203acc17-20230119
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 609007003; Thu, 19 Jan 2023 17:37:53 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Thu, 19 Jan 2023 17:37:52 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Thu, 19 Jan 2023 17:37:52 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VqxhHCzmVa98ekgvqdmJsZHRkkudQM1yvt+6Zi63d0lzCf5qKJ/ktE6Xd/VMb/o/gAMDtsLWvxHlLn8n4g1PLPjSTdEtu1HEUzXUkUJjAcMexZ9RWZWGYGFWA6T5nNoNrMHP1DzEIVffV6/68IBgEy5F6c68GNrl2hPjxiHOAmHWREKOHscABgjtWNC6EQSWvMHdzAe3d0TaPu92fZBKqE1meg3rB7FYjsI7GsGqHFkBMyOG1aW1N1F5DyvZGoPvwSVsSjc+wJ3GBspYnpz7mVTu9/y+3+JA/KN+3lR70ewjcqUc/G1JoBtl6vSivb3U6i+SRGaqnoAt7zJx2YeHOQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0D4pgzAENKu76Tq9YUFGozuOAdfp7hrKPFcqou0eIdY=;
 b=CGsei1f1++uX4wdwouxezl9o9zNukpBjSuk6svWVI+03F7EOvAki0jtiA0Yz+8/c96JH0gDZkc4BwZV23mYpdjFWb9JYNmpsFq8tBbYCFbqxvktXecaneiLbUhq+eoWRv2EJLYlDkuA94akVz96d6uTzsu+S7b6WZP/vlSHJMPCKOx4/zOtfFhSmjuZ9o/uQIFeNvMCPaihDZ1as4MAUoLc1jEPhLwVJgGBA8Il5InLKQ0hE3GhVY5IJR+d74Eb69QD/yxSYKTp1tyPOk7a9ywxbRHhYVLDpF9ANF+FsA8X+BVxtOW92cT9rTBuTdew/+QeBatRJxNC3sMVfCFBUdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0D4pgzAENKu76Tq9YUFGozuOAdfp7hrKPFcqou0eIdY=;
 b=P0VsWl2Fmm7yizmfcd/hsPcZ5+rwMbRbclh3Cilkrq3FNhBFiHpWwq+1aqQXrapxTLDSNyoediMRrsvkGSk1DGPQOYfIZUbF/O8bLUBQgnert8GTZTqM7tQeA46tbs+MZGDc/X6p2MXATwF5VqsZMcRJ4WVRIERSwKi51CMC4eQ=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by SEZPR03MB6714.apcprd03.prod.outlook.com (2603:1096:101:7e::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.12; Thu, 19 Jan
 2023 09:37:50 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::6bf6:aaf0:3698:5453]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::6bf6:aaf0:3698:5453%5]) with mapi id 15.20.6002.025; Thu, 19 Jan 2023
 09:37:49 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
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
Subject: Re: [PATCH v4 01/19] dt-bindings: ARM: MediaTek: Add new MT8188 clock
Thread-Topic: [PATCH v4 01/19] dt-bindings: ARM: MediaTek: Add new MT8188
 clock
Thread-Index: AQHZJChKM+sNJTbGQUWGczuW9TtUtK6iiGEAgAMCsAA=
Date:   Thu, 19 Jan 2023 09:37:49 +0000
Message-ID: <797d3ff10dd6434727210c66d33bf9cbc2f24df9.camel@mediatek.com>
References: <20230109124516.31425-1-Garmin.Chang@mediatek.com>
         <20230109124516.31425-2-Garmin.Chang@mediatek.com>
         <9c11bf53-6639-2cbe-0d27-ce1ea154f576@linaro.org>
In-Reply-To: <9c11bf53-6639-2cbe-0d27-ce1ea154f576@linaro.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|SEZPR03MB6714:EE_
x-ms-office365-filtering-correlation-id: ae3d8b33-e604-4492-a08b-08dafa00d47a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4qokJvvZnf07mLLGG6C16XLOoloEaOWnp4MXlAmXsdwYidAWvKmuZ0BVzJOilIY7/Tk7ExmtrxzazqDYoOrDZK1LcDpjsLF/sdkZdRFSpglwuFgHWl5Sdn8nMNQO5nfZvPux/mFqrT+VFO1lznerXc7+8JGNuyW5DEIpRSzHEtr/zi6jAN++B59NE9zgJfOS/Im9KbaNGEH9gScN6ZW98h+uYVRZWklp0oDDTfwdBoCKqYgOt7sY/8iPsD9KwdhjrBob3pqrvsjmlpbqZwS4PmE8HwlatdqXXJx+sxqn1gmSKmGNHuTqZQEGoQMv2hOu5auW4H/PlJUgEm0SpdomdvwkKdDm/KC8MDq9KTD1u4E0LWRXXn73A3l5EE3IuFvue+hsBlO1BsFb9q6RxI34aGAx9IkyBbGI8FCkGQNrzrsVZ//ZMVH0MFLEb4PCkYR8v5gJwJal8ok1jmN7GRkP1cp7dXA5J1LSkXUyH9vFWysUqmwIo1a6AmQFcfqBssITsLgASTyIAMjAzzpiMZTQxrXWQUFf3dhTGQ+yMr+nJrTVmXLV5glzAQi/q4hAY/U2Gc/2rGYKPj9Vdh3Wq7DCgPQgYOEXRPY8kc6RTax0Bguxi1dulLiun0GFkmqpjZTXM3kP254p+BInjxhfPGEo2AFcxuUxGV35JUc7xYcdN6VL8sn8yZt2ebv3jjtiaUOsQLVAPr536LjnLGrdRozm01oyz+GnN1E6E0sWqv92v3bZzuv51UZKGs7r/0c7bNedcDqufguVJ3XNKTsT56dBF4YsPneStcljgdBoVol4uKGZDGm9cs0D7nZDIF+Yiz6K
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(366004)(376002)(346002)(39860400002)(136003)(451199015)(6486002)(478600001)(85182001)(966005)(71200400001)(38100700002)(86362001)(2906002)(36756003)(6512007)(2616005)(83380400001)(6506007)(53546011)(5660300002)(186003)(26005)(76116006)(66946007)(66446008)(64756008)(66476007)(4326008)(7416002)(91956017)(66556008)(41300700001)(8676002)(122000001)(316002)(8936002)(110136005)(54906003)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bWRhc1RvRmNLbUtaa1BmcUFzQlV4QVBOb0JjK3BJdThkMVMrbHRlREt2bEVW?=
 =?utf-8?B?QUUyei95UThNZ1R6QkRBMjlsNFIxV29CcnBjNXdWakRzdkRPSC9PR1R4TjN1?=
 =?utf-8?B?YURPdWVkdnV1eDJ5ODVYcWtMbjYrZCtHQW1VbDdyQkZmT0hoMjljUS90SnlP?=
 =?utf-8?B?bWNDNzJSdForVWdRYmpYQzM5YytidGQzTmdnZkdtYjBxSmxCdEg4bXIyMmRU?=
 =?utf-8?B?RytXTDBlVlY2ZGRLeExjZ3YvdWJCdy9zVGY4QTJEdkJaZkQwM09KcC9xeUF3?=
 =?utf-8?B?YTU1NXpRVmR1YjdBOUcycXdkSDNmOUJ0YXZ0dERHMWI4TTZUdmtWd0gxNHRN?=
 =?utf-8?B?MXBEaFlPd0tsL2Y3dGd2UDQ0RWJXRVA1TnlVWGdjRmdBTGtkd1RXUmVJeUVO?=
 =?utf-8?B?QjNzNXpBWE1mVU9JSXdxTVJjVWowZHB1VWhRazlHTFJLc3pDUWhmckZKc3pz?=
 =?utf-8?B?Y2QzMUc5OCtLVm4yRFUwdGJpamhoZDIxYlNGNldFRkVDY083aml1Q1VnQ2tE?=
 =?utf-8?B?eHg0eTBQMmRhbExpdjdaYnhGQVVVK0d0R2g1OWNOU2FPTTZRTmJQdW55S2F2?=
 =?utf-8?B?OVV5WnBaeU5PQ09mZnhpMlRxRjlWM09kQ1ZiYnVaV1VRczhPaExlTDgxZ3Ri?=
 =?utf-8?B?c2REMjFzaEs5VGdOUmJYWkltampWSzZGbnNrNUtWMWpFUVVPNnlONjlqUWlY?=
 =?utf-8?B?ZS9OMmVQdXlyTHBUZSt4cTlIQ2Q1aUh2Z2liSmlmUmV6MGtDOEhkcFgzVllP?=
 =?utf-8?B?ZndjS3Y0cERZUlFXRkJNLzZSdkw4eTNCRVdnY1QycFlsVmhRVkNwUFZrOExU?=
 =?utf-8?B?UzBLZ2M2VFY0SWZkc0FXR0xmMlgvZkJ1SlBHMXVDZDZ5YmEzaUNxN3NRWjhE?=
 =?utf-8?B?TGlHdHlQN3Y1enFBanl1WGJMMzhuY21BUUpka2dIN1QxTElwUmpXWDFHSkVr?=
 =?utf-8?B?Qzh1UHU3b2h5S2Jkcyt5N3FkM01OLzZKMmRBNXQzWXRsTGJZbEM2Ylk4MGhL?=
 =?utf-8?B?NjlPZFZDU2phWFUydlZVWEZ2dHNYZWlSRWNJbUFpMlpuQ1BOMU9wSXNwdGhs?=
 =?utf-8?B?cUFsZStXRE0yNEJnaXg1NGpyZGFteS9GSUgyS0h3K1M0emk3Y1J2bTlZcEFr?=
 =?utf-8?B?NVFXQjdYMm9KblorVGF5bmc2Zyt1UE0xUG9IVEl2ZHJhNzFNM09uODUvNU5I?=
 =?utf-8?B?SUpzUGpId3M0NXg1QW1nOHBqc2R1UnhRdUQxSlEyelNROUJxZzdxODdnL3dR?=
 =?utf-8?B?dktsQXRjTXFBbUtlNjZPbU92QTYzVDFZUzFSa1JZZmIyalJBSnZSSTYxNnkw?=
 =?utf-8?B?SncyU1RIOHNpQXVibGtDWDEzV2dlcTh1ZkdITkowRFNHSkhsUkkrMFFKa0l1?=
 =?utf-8?B?QXlzSHFOSXFEbjV5YytJK0lrZmdKSVZKM0p6RlZWcE1BM2x5SWppWHFnQXZk?=
 =?utf-8?B?MXJ2WDNCYS80L3B6UzVpcStnNGlRNlVWM3BDaFkxN2pSanJzVTl1ZGEvRmtr?=
 =?utf-8?B?WVhSTXREOFhQWDh4MmhoZ3hUbDZYd2JPcGpSQkxHTkgyUkRBdk9pb2pWazFY?=
 =?utf-8?B?RElYQ05kWFJQSTJwQXAxR3JEczhZN0hIekdLa3JRTHlRMHBMRnN5cVdidU9R?=
 =?utf-8?B?TERlUGJoWURPRHBlbTN1VTJWRnNnQ1VCcW9SUFdqbHBnWG1UKzRHMFhoZDBa?=
 =?utf-8?B?bnlITDhDdlVvQ051bStXZEFiNDVZT0Y0OXpCczZoNUxLc29raE56bkROdjdF?=
 =?utf-8?B?VktuTjY2OGhwMWVvbVhMVVNMNmhIc2JhNVJwSVl2MkJlcjMvdlRUeVIxSWFr?=
 =?utf-8?B?MUhOSnhENkRxTVR5cUJDSTl4eHoxUy9hZFJjbS9PWStiYzYyZnBYeU0wTFgx?=
 =?utf-8?B?Y2JiR3NIWU1RR0JOSUtxRzRsSzUrMDFoWUxBT2FyQWlqUHc3bVgzR0p0RGpw?=
 =?utf-8?B?bmFVRUNxdnlFSUd0V2MyUkVIempVbHZhL096YzV3RndxRm9OVVVXM3dEajl5?=
 =?utf-8?B?K2VwWGw0RWNOM3BRcUNsUDhSaXg2K2Y3WFJsWkthSFVpOEtIL292b0xUOVRt?=
 =?utf-8?B?a3VVV1pVblJpSys4V0pFQUZtNjdWL29qdFVUSVBYV1FJcnd2SE1Db2I0OWNZ?=
 =?utf-8?B?NGVvNzlyY1hyTU9wZHhRaUd5ZmtDeVptS3lSUUZVQk1QM3grdGpreDh1VndE?=
 =?utf-8?B?N3c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD26D9626A9B674C9FBA4515A45F9AAC@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae3d8b33-e604-4492-a08b-08dafa00d47a
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2023 09:37:49.7628
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8w1x9kjxLJPfch1E9bDPKXpC4Mnv+T7qxaNXjXUKxRl2lhTyN9ynpheweAXTAbsm33dKzquamvLlG0fd/3b1QdCd/OEOixuM1EDyhSxNoIs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6714
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,RDNS_NONE,
        SPF_HELO_PASS,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIzLTAxLTE3IGF0IDEyOjM5ICswMTAwLCBLcnp5c3p0b2YgS296bG93c2tpIHdy
b3RlOg0KPiBPbiAwOS8wMS8yMDIzIDEzOjQ0LCBHYXJtaW4uQ2hhbmcgd3JvdGU6DQo+ID4gQWRk
IHRoZSBuZXcgYmluZGluZyBkb2N1bWVudGF0aW9uIGZvciBzeXN0ZW0gY2xvY2sNCj4gPiBhbmQg
ZnVuY3Rpb25hbCBjbG9jayBvbiBNZWRpYVRlayBNVDgxODguDQo+IA0KPiBVc2Ugc3ViamVjdCBw
cmVmaXhlcyBtYXRjaGluZyB0aGUgc3Vic3lzdGVtICh3aGljaCB5b3UgY2FuIGdldCBmb3INCj4g
ZXhhbXBsZSB3aXRoIGBnaXQgbG9nIC0tb25lbGluZSAtLSBESVJFQ1RPUllfT1JfRklMRWAgb24g
dGhlDQo+IGRpcmVjdG9yeQ0KPiB5b3VyIHBhdGNoIGlzIHRvdWNoaW5nKS4NCj4gDQpUaGFua3Mg
Zm9yIHlvdXIgc3VnZ2VzdGlvbnMuDQpJIHdpbGwgY2hhbmdlIHRoZSBzdWJqZWN0IGFzICJkdC1i
aW5kaW5nczogY2xvY2s6IG1lZGlhdGVrOiBBZGQgbmV3DQpNVDgxODggY2xvY2siLg0KDQo+ID4g
DQo+ID4gU2lnbmVkLW9mZi1ieTogR2FybWluLkNoYW5nIDxHYXJtaW4uQ2hhbmdAbWVkaWF0ZWsu
Y29tPg0KPiA+IC0tLQ0KPiA+ICAuLi4vYmluZGluZ3MvY2xvY2svbWVkaWF0ZWssbXQ4MTg4LWNs
b2NrLnlhbWwgfCAgNzEgKysNCj4gPiAgLi4uL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1zeXMtY2xv
Y2sueWFtbCAgICAgIHwgIDU1ICsrDQo+ID4gIC4uLi9kdC1iaW5kaW5ncy9jbG9jay9tZWRpYXRl
ayxtdDgxODgtY2xrLmggICB8IDczMw0KPiA+ICsrKysrKysrKysrKysrKysrKw0KPiA+ICAzIGZp
bGVzIGNoYW5nZWQsIDg1OSBpbnNlcnRpb25zKCspDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NA0K
PiA+IERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9jbG9jay9tZWRpYXRlayxtdDgx
ODgtY2xvY2sueWFtbA0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQNCj4gPiBEb2N1bWVudGF0aW9u
L2RldmljZXRyZWUvYmluZGluZ3MvY2xvY2svbWVkaWF0ZWssbXQ4MTg4LXN5cy0NCj4gPiBjbG9j
ay55YW1sDQo+ID4gIGNyZWF0ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2R0LWJpbmRpbmdzL2Nsb2Nr
L21lZGlhdGVrLG10ODE4OC1jbGsuaA0KPiA+IA0KPiA+IGRpZmYgLS1naXQNCj4gPiBhL0RvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9jbG9jay9tZWRpYXRlayxtdDgxODgtDQo+ID4g
Y2xvY2sueWFtbA0KPiA+IGIvRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL2Nsb2Nr
L21lZGlhdGVrLG10ODE4OC0NCj4gPiBjbG9jay55YW1sDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLjY2NTRjZWFkNzFmNg0KPiA+IC0tLSAvZGV2L251
bGwNCj4gPiArKysgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvY2xvY2svbWVk
aWF0ZWssbXQ4MTg4LQ0KPiA+IGNsb2NrLnlhbWwNCj4gPiBAQCAtMCwwICsxLDcxIEBADQo+ID4g
KyMgU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wIE9SIEJTRC0yLUNsYXVzZSkNCj4g
PiArJVlBTUwgMS4yDQo+ID4gKy0tLQ0KPiA+ICskaWQ6IA0KPiA+IGh0dHBzOi8vdXJsZGVmZW5z
ZS5jb20vdjMvX19odHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy9hcm0vbWVkaWF0ZWsvbWVk
aWF0ZWssbXQ4MTg4LWNsb2NrLnlhbWwqX187SXchIUNUUk5LQTl3TWcwQVJidyFnanE1ZDg2NGt6
ZXdXNDhEbjd6ZTlqTlZfTW1HZHJDSmE4dURhbVhMT2ZubVF1MGh0MDJDUU1KeGlIX3EyWl9RWllM
YjVXcnU1YjB5bHpxX0RTc0ltbEtrVVNnUnprbyTCoA0KPiA+ICANCj4gPiArJHNjaGVtYTogDQo+
ID4gaHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHA6Ly9kZXZpY2V0cmVlLm9yZy9tZXRh
LXNjaGVtYXMvY29yZS55YW1sKl9fO0l3ISFDVFJOS0E5d01nMEFSYnchZ2pxNWQ4NjRremV3VzQ4
RG43emU5ak5WX01tR2RyQ0phOHVEYW1YTE9mbm1RdTBodDAyQ1FNSnhpSF9xMlpfUVpZTGI1V3J1
NWIweWx6cV9EU3NJbWxLa0ljcmFrQ2MkwqANCj4gPiAgDQo+ID4gKw0KPiA+ICt0aXRsZTogTWVk
aWFUZWsgRnVuY3Rpb25hbCBDbG9jayBDb250cm9sbGVyIGZvciBNVDgxODgNCj4gPiArDQo+ID4g
K21haW50YWluZXJzOg0KPiA+ICsgIC0gR2FybWluIENoYW5nIDxnYXJtaW4uY2hhbmdAbWVkaWF0
ZWsuY29tPg0KPiA+ICsNCj4gPiArZGVzY3JpcHRpb246IHwNCj4gPiArICBUaGUgY2xvY2sgYXJj
aGl0ZWN0dXJlIGluIE1lZGlhVGVrIGxpa2UgYmVsb3cNCj4gPiArICBQTExzIC0tPg0KPiA+ICsg
ICAgICAgICAgZGl2aWRlcnMgLS0+DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICBtdXhlcw0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAtLT4NCj4gPiArICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgY2xvY2sgZ2F0ZQ0KPiA+ICsNCj4gPiArICBUaGUgZGV2aWNlcyBwcm92
aWRlIGNsb2NrIGdhdGUgY29udHJvbCBpbiBkaWZmZXJlbnQgSVAgYmxvY2tzLg0KPiA+ICsNCj4g
PiArcHJvcGVydGllczoNCj4gPiArICBjb21wYXRpYmxlOg0KPiA+ICsgICAgZW51bToNCj4gPiAr
ICAgICAgLSBtZWRpYXRlayxtdDgxODgtYWRzcC1hdWRpbzI2bQ0KPiA+ICsgICAgICAtIG1lZGlh
dGVrLG10ODE4OC1pbXAtaWljLXdyYXAtYw0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10ODE4OC1p
bXAtaWljLXdyYXAtZW4NCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgxODgtaW1wLWlpYy13cmFw
LXcNCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgxODgtbWZnY2ZnDQo+ID4gKyAgICAgIC0gbWVk
aWF0ZWssbXQ4MTg4LXZwcHN5czANCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgxODgtd3Blc3lz
DQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LXdwZXN5cy12cHAwDQo+ID4gKyAgICAgIC0g
bWVkaWF0ZWssbXQ4MTg4LXZwcHN5czENCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgxODgtaW1n
c3lzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWltZ3N5cy13cGUxDQo+ID4gKyAgICAg
IC0gbWVkaWF0ZWssbXQ4MTg4LWltZ3N5cy13cGUyDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4
MTg4LWltZ3N5cy13cGUzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWltZ3N5czEtZGlw
LXRvcA0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10ODE4OC1pbWdzeXMxLWRpcC1ucg0KPiA+ICsg
ICAgICAtIG1lZGlhdGVrLG10ODE4OC1pcGVzeXMNCj4gPiArICAgICAgLSBtZWRpYXRlayxtdDgx
ODgtY2Ftc3lzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWNhbXN5cy1yYXdhDQo+ID4g
KyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWNhbXN5cy15dXZhDQo+ID4gKyAgICAgIC0gbWVkaWF0
ZWssbXQ4MTg4LWNhbXN5cy1yYXdiDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWNhbXN5
cy15dXZiDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LWNjdXN5cw0KPiA+ICsgICAgICAt
IG1lZGlhdGVrLG10ODE4OC12ZGVjc3lzLXNvYw0KPiA+ICsgICAgICAtIG1lZGlhdGVrLG10ODE4
OC12ZGVjc3lzDQo+ID4gKyAgICAgIC0gbWVkaWF0ZWssbXQ4MTg4LXZlbmNzeXMNCj4gDQo+IFRo
ZSBsaXN0IHNob3VsZCBiZSBvcmRlcmVkIGJ5IG5hbWUuDQo+IA0KT2ssIEkgd2lsbCBtb2RpZnkg
aW4gYWxwaGFiZXRpY2FsIG9yZGVyLg0KDQo+ID4gKw0KPiA+ICsgIHJlZzoNCj4gPiArICAgIG1h
eEl0ZW1zOiAxDQo+ID4gKw0KPiA+ICsgICcjY2xvY2stY2VsbHMnOg0KPiA+ICsgICAgY29uc3Q6
IDENCj4gPiArDQo+ID4gK3JlcXVpcmVkOg0KPiA+ICsgIC0gY29tcGF0aWJsZQ0KPiA+ICsgIC0g
cmVnDQo+ID4gKyAgLSAnI2Nsb2NrLWNlbGxzJw0KPiA+ICsNCj4gPiArYWRkaXRpb25hbFByb3Bl
cnRpZXM6IGZhbHNlDQo+ID4gKw0KPiA+ICtleGFtcGxlczoNCj4gPiArICAtIHwNCj4gPiArICAg
IGNsb2NrLWNvbnRyb2xsZXJAMTEyODMwMDAgew0KPiA+ICsgICAgICAgIGNvbXBhdGlibGUgPSAi
bWVkaWF0ZWssbXQ4MTg4LWltcC1paWMtd3JhcC1jIjsNCj4gPiArICAgICAgICByZWcgPSA8MHgx
MTI4MzAwMCAweDEwMDA+Ow0KPiA+ICsgICAgICAgICNjbG9jay1jZWxscyA9IDwxPjsNCj4gPiAr
ICAgIH07DQo+ID4gKw0KPiA+IGRpZmYgLS1naXQNCj4gPiBhL0RvY3VtZW50YXRpb24vZGV2aWNl
dHJlZS9iaW5kaW5ncy9jbG9jay9tZWRpYXRlayxtdDgxODgtc3lzLQ0KPiA+IGNsb2NrLnlhbWwN
Cj4gPiBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9jbG9jay9tZWRpYXRlayxt
dDgxODgtc3lzLQ0KPiA+IGNsb2NrLnlhbWwNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+
IGluZGV4IDAwMDAwMDAwMDAwMC4uNTQxZTBmN2RmNzlmDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+
ICsrKyBiL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9jbG9jay9tZWRpYXRlayxt
dDgxODgtc3lzLQ0KPiA+IGNsb2NrLnlhbWwNCj4gPiBAQCAtMCwwICsxLDU1IEBADQo+ID4gKyMg
U1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6IChHUEwtMi4wIE9SIEJTRC0yLUNsYXVzZSkNCj4gPiAr
JVlBTUwgMS4yDQo+ID4gKy0tLQ0KPiA+ICskaWQ6IA0KPiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5j
b20vdjMvX19odHRwOi8vZGV2aWNldHJlZS5vcmcvc2NoZW1hcy9hcm0vbWVkaWF0ZWsvbWVkaWF0
ZWssbXQ4MTg4LXN5cy1jbG9jay55YW1sKl9fO0l3ISFDVFJOS0E5d01nMEFSYnchZ2pxNWQ4NjRr
emV3VzQ4RG43emU5ak5WX01tR2RyQ0phOHVEYW1YTE9mbm1RdTBodDAyQ1FNSnhpSF9xMlpfUVpZ
TGI1V3J1NWIweWx6cV9EU3NJbWxLa1Q2eEJob0kkwqANCj4gPiAgDQo+ID4gKyRzY2hlbWE6IA0K
PiA+IGh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwOi8vZGV2aWNldHJlZS5vcmcvbWV0
YS1zY2hlbWFzL2NvcmUueWFtbCpfXztJdyEhQ1RSTktBOXdNZzBBUmJ3IWdqcTVkODY0a3pld1c0
OERuN3plOWpOVl9NbUdkckNKYTh1RGFtWExPZm5tUXUwaHQwMkNRTUp4aUhfcTJaX1FaWUxiNVdy
dTViMHlsenFfRFNzSW1sS2tJY3Jha0NjJMKgDQo+ID4gIA0KPiA+ICsNCj4gPiArdGl0bGU6IE1l
ZGlhVGVrIFN5c3RlbSBDbG9jayBDb250cm9sbGVyIGZvciBNVDgxODgNCj4gPiArDQo+ID4gK21h
aW50YWluZXJzOg0KPiA+ICsgIC0gR2FybWluIENoYW5nIDxnYXJtaW4uY2hhbmdAbWVkaWF0ZWsu
Y29tPg0KPiA+ICsNCj4gPiArZGVzY3JpcHRpb246IHwNCj4gPiArICBUaGUgY2xvY2sgYXJjaGl0
ZWN0dXJlIGluIE1lZGlhVGVrIGxpa2UgYmVsb3cNCj4gPiArICBQTExzIC0tPg0KPiA+ICsgICAg
ICAgICAgZGl2aWRlcnMgLS0+DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICBtdXhlcw0KPiA+
ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAtLT4NCj4gPiArICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgY2xvY2sgZ2F0ZQ0KPiA+ICsNCj4gPiArICBUaGUgYXBtaXhlZHN5cyBwcm92
aWRlcyBtb3N0IG9mIFBMTHMgd2hpY2ggZ2VuZXJhdGVkIGZyb20gU29DDQo+ID4gMjZtLg0KPiA+
ICsgIFRoZSB0b3Bja2dlbiBwcm92aWRlcyBkaXZpZGVycyBhbmQgbXV4ZXMgd2hpY2ggcHJvdmlk
ZSB0aGUgY2xvY2sNCj4gPiBzb3VyY2UgdG8gb3RoZXIgSVAgYmxvY2tzLg0KPiA+ICsgIFRoZSBp
bmZyYWNmZ19hbyBwcm92aWRlcyBjbG9jayBnYXRlIGluIHBlcmlwaGVyYWwgYW5kDQo+ID4gaW5m
cmFzdHJ1Y3R1cmUgSVAgYmxvY2tzLg0KPiA+ICsgIFRoZSBtY3VzeXMgcHJvdmlkZXMgbXV4IGNv
bnRyb2wgdG8gc2VsZWN0IHRoZSBjbG9jayBzb3VyY2UgaW4gQVANCj4gPiBNQ1UuDQo+ID4gKyAg
VGhlIGRldmljZSBub2RlcyBhbHNvIHByb3ZpZGUgdGhlIHN5c3RlbSBjb250cm9sIGNhcGFjaXR5
IGZvcg0KPiA+IGNvbmZpZ3VyYXRpb24uDQo+ID4gKw0KPiA+ICtwcm9wZXJ0aWVzOg0KPiA+ICsg
IGNvbXBhdGlibGU6DQo+ID4gKyAgICBpdGVtczoNCj4gPiArICAgICAgLSBlbnVtOg0KPiA+ICsg
ICAgICAgICAgLSBtZWRpYXRlayxtdDgxODgtdG9wY2tnZW4NCj4gPiArICAgICAgICAgIC0gbWVk
aWF0ZWssbXQ4MTg4LWluZnJhY2ZnLWFvDQo+ID4gKyAgICAgICAgICAtIG1lZGlhdGVrLG10ODE4
OC1hcG1peGVkc3lzDQo+ID4gKyAgICAgICAgICAtIG1lZGlhdGVrLG10ODE4OC1wZXJpY2ZnLWFv
DQo+IA0KPiBEaXR0bw0KPiANCk9rLCBJIHdpbGwgbW9kaWZ5IGluIGFscGhhYmV0aWNhbCBvcmRl
ci4NCg0KPiANCj4gQmVzdCByZWdhcmRzLA0KPiBLcnp5c3p0b2YNCj4gDQo=
