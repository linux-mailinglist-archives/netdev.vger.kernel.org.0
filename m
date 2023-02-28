Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C479C6A53E0
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 08:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjB1Hrd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 02:47:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbjB1Hrb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 02:47:31 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C9F20079;
        Mon, 27 Feb 2023 23:47:22 -0800 (PST)
X-UUID: 1d77b898b73c11ed945fc101203acc17-20230228
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=yS5zy5xoDlhhNHkE8D5XPFY2KtyEF2KmKNnU5ebKD4A=;
        b=g2bbHsl9Aq3Phfsn6zo2TmBHdApANY5gerNUsIXjEUXzs8wnLrqL4+7499gbx4pD2S0zUdZ3oiTxErdQjLwUWNsFVNFUV4PxRFANJAuFU3cYku3iD4YVhEUbOJx0MPV/wE1zAYcnfrw+zj/KFOsELBd6t7MX0wifQ2F6okCqTWk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:d68496a6-ede2-4951-b8d8-8018dfca885f,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:7ca7d926-564d-42d9-9875-7c868ee415ec,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: 1d77b898b73c11ed945fc101203acc17-20230228
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 2034651578; Tue, 28 Feb 2023 15:47:13 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Tue, 28 Feb 2023 15:47:12 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Tue, 28 Feb 2023 15:47:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CDM+zjAxoX2g5KdKlB+AqeEJjonQYuY7r1kTi/K1LuntfOfPJqAZDkXztIM+sum/BBTZtEuxcovOC16OAhO4+XkOhxblj5KHI/oBpEIKdg0d03fuOCIhwDACaTX3ONDqWzscdNxHgab+H9Xa4mUE7mYsKj7+yj3kDd06ZjV+wnCMWuAze/4/fb+noKwncyvIx0vovl29i4UW25W1UiOSyzwXILn1zQX2/jc5/oN7jHZq5fyTyOoX6HHhoMueDx0GyLtfZUB+PVmZEBK5/KJe5U2bhSpo/UkuFDSisFWzvAJHWiiGN3tl2vOlLRkWBNapZMnvEE48W43sCcRAeZSklg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yS5zy5xoDlhhNHkE8D5XPFY2KtyEF2KmKNnU5ebKD4A=;
 b=imstjNoGnnl5iQNLzLTyIvni+Gf+XCVgY/JrOirfiEnoaHZLiPaMpq+18fOo+WK2cqMdiVD1V5gZrGjmBD/rw/6eBWlU1gGXIM/EvUeWsDJYL0FNfV35cvhqb0s7iqG2UG7gLMXG7dCmZlZEDSsjNdqFquHyTp/EZgGz/6qLZlyMuvBuYJ8Q8TPXGn7sPqMEpQhCOvCgfqbpFfjiclguCm349g/87JeSNI5yx41krUda7GrjpeIBixqpLy4j1w3/81yyWn4VWz1fq3kTC728F7YLDHuEbb094X+hYmg9C+E5kGivO1ae+MJz1TTiooIhqNtzITn4ZMQHir7tdl657Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by TY0PR03MB6981.apcprd03.prod.outlook.com (2603:1096:400:277::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Tue, 28 Feb
 2023 07:47:09 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7%8]) with mapi id 15.20.6134.030; Tue, 28 Feb 2023
 07:47:09 +0000
From:   =?utf-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     =?utf-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        =?utf-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        =?utf-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?utf-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?utf-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        =?utf-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?utf-8?B?QWlkZW4gV2FuZyAo546L5ZKP6bqSKQ==?= 
        <Aiden.Wang@mediatek.com>,
        =?utf-8?B?RmVsaXggQ2hlbiAo6ZmI6Z2eKQ==?= <Felix.Chen@mediatek.com>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?TWluZ2NodWFuZyBRaWFvICjkuZTmmI7pl68p?= 
        <Mingchuang.Qiao@mediatek.com>,
        =?utf-8?B?R3VvaGFvIFpoYW5nICjlvKDlm73osaop?= 
        <Guohao.Zhang@mediatek.com>
Subject: Re: [PATCH net-next v3 01/10] net: wwan: tmi: Add PCIe core
Thread-Topic: [PATCH net-next v3 01/10] net: wwan: tmi: Add PCIe core
Thread-Index: AQHZPfRhXG0uLuMh9ki8uUJNPx0e967PblKAgAIgUwCADDu2AIAAzFUAgAQ2vACAAHJFgIAA1h0A
Date:   Tue, 28 Feb 2023 07:47:09 +0000
Message-ID: <ebe8c4057b16c6565223af53bfb229dd1846d26b.camel@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
         <20230211083732.193650-2-yanchao.yang@mediatek.com>
         <20230214202229.50d07b89@kernel.org>
         <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
         <d6f13d66a5ab0224f2ae424a0645d4cf29c2752b.camel@mediatek.com>
         <20230224115052.5bdcc54d@kernel.org>
         <e7628b89847adda7d8302db91d48b3ff62245f43.camel@mediatek.com>
         <20230227110047.224909ee@kernel.org>
In-Reply-To: <20230227110047.224909ee@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|TY0PR03MB6981:EE_
x-ms-office365-filtering-correlation-id: aff1f8e1-a54b-48e2-9997-08db195fff18
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SChSjGLdgGHnsfVwtDUK/7ezrmHYZssnZJVPWxqt1fmq/vk6azonG4W33Gax8Ph4MzxdO+vS/96qlbupOLd/Sl3b41hgJrBkhy+fKlU005w48S/cQ7teT+2jXZ197TopMBmDVADUaxeCTjXfLwWKc9jbL1eEraxB5VPRl0waaSCLViYM1fjTfD6PgWgyhjqXLd4rnfFVv9BfFHaECszALqQG+SMOVx6eZpj+7G5NGVnTG2qnfwu+/wBVUO/o07eTnHv/7GC8reLzRnnC/DPjfSBflQrxgWyqDeXWuuWbIhVKmKpWD6nJGi84Tr7YJkCNGZ+OTYzndSiyHko4ljkxCJIqtQxDn29svFdVO6tZWD64LqiGVO+ZFBSftdXN6KrRCc2hXUn8D2fy9fk6ywKG6ZfUOK2JwGw4X1EZJuB2Kquab/6a+h2Ic0Z3/mWo03LGBaIf8OE3xnmI2+D3ZvgmO7aHRlOqS6LRZo/p7Uis+CubktIyH2mH3siRd6qGq68/BPy2hyA8bj+zCk5D5qDGvCLn2i6TnyjMxSjLApSG1+6Plzkib5q5OM8+Gj99tUrVOGJxNUoFLQ018QyJOD2mQmQsRyw1QYUKH5WT3xgNzr5hsAGiQotlNVjpgiJNKxoqPEfSDUlPE0GbOFq4718dWsqdff5Lj5PQH9POdWKiRa9QT1rUdySSyVXwNh0k14jkgHpQ4qKBsdUx2q/uOusstTmd+ekFG2r70vcZ5rDYFNzka/dQ54yPaE2GXzDL703172rNGEhPJTeTVyi9/PKybg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199018)(6486002)(478600001)(71200400001)(2616005)(6506007)(186003)(26005)(6512007)(54906003)(316002)(107886003)(66556008)(4326008)(66446008)(8676002)(76116006)(66476007)(6916009)(41300700001)(91956017)(7416002)(5660300002)(8936002)(122000001)(86362001)(38100700002)(36756003)(66946007)(85182001)(64756008)(38070700005)(2906002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?QUY5RFd5RWlkZjRQOWZzdzBTU0paek1lY3ZKdGlRbytGbE1waE5nOUMxUjAv?=
 =?utf-8?B?bUJqMzhHVEFKbDVDdDlwb1NoaWdRVWdxWGQzWnNNdlJVYTRhYkJVOXFFcUo0?=
 =?utf-8?B?WUhHa3Y3UFZpNGpOdVBoNHVQUU1FdkFPelozdkxPRTVBeWhnVGt0c05xN0xZ?=
 =?utf-8?B?b0lWYlpMTUwwdkNpSm40K2ZmbyswV0FESFZIOUh5cWtvRGtMQlhIbVZFK3lh?=
 =?utf-8?B?RG15NE1QVjVvRnZUV1N3YkUxcndaSmtXZXhEWXdtYm9NSDUwTkp4MTV4WjRI?=
 =?utf-8?B?WUhDaW1rUFlHdzFDRXI0VDFhdXRsL1JsZElHUGIwd21wS1A3K1BlU3VpMXZG?=
 =?utf-8?B?NjdQenJ4Qk1BanljWGFsam1XNmNpaGpHbjJiTVFNM1VuTDBaNFMybk5ta3JD?=
 =?utf-8?B?bUhLRVh1THhna0doejNGOUl1RDBuaWdoMlFrU3FOWnVDSW5MNGNHMzFsWi9R?=
 =?utf-8?B?MWdRanc1SmlJNjFHUWdZZTRSNVh5VFNiZzJLTUtPNDZ4QU1NeS9oL2M4NVVq?=
 =?utf-8?B?T2FKT0R5ai9CQS90VU15YzgvQUVMS3R4LzltT1JoazBNRHFBdGNnK0VSTTVp?=
 =?utf-8?B?VXpkQ2ZPZVlkYWhwRUdWOXJRNXQ1Tjl0S0h1Q0RndERFSEo4UGpSYlB5SkZx?=
 =?utf-8?B?dzZJT1dlQlhhT2NCdVNoT244VW9hVkRjMFFLQW44dDI3dGpqbFZYbzdzWGpv?=
 =?utf-8?B?Ukd4OVg1TTZTbE9kNXhjNC9SUldOcUpKdFg0N21hdzk0cUlncDhwRlhCZFZV?=
 =?utf-8?B?emRlNk4rQUU2UkEzdkluYmxaVGJsazJ1MzZ3QUozUU8rWnB5Wi9tU2xISnJ4?=
 =?utf-8?B?L2F5RXZ5RlFYRFAzb2dnMkI4bkNTR09ZTkxBeWwweURwN0orZGpRRGt0bEtE?=
 =?utf-8?B?bXpkOWszcytHa0h6Z3p0eWtjMzlGR3kxMWdJRk1DbFpwMVNWemV6ZVp6U2Js?=
 =?utf-8?B?R09GbjlaWmxKL045VEY1YzVzSmNFWDRhUzB1bEQyd3NUKzhUZldqbE96TUFz?=
 =?utf-8?B?YmdKQnpNYVgyRk1sa1FrUFZqVldoc2crem1OcEN0ajR2WGVXU3JCSC9KaE4x?=
 =?utf-8?B?d2luVUpaRkw3YWUvQVRaSXh5SlIxM0JNcE1wNXZka0pXN2Q4NzdXRldjejMv?=
 =?utf-8?B?ODd2N0NkK1ExTElnTy83T1ZzQ3Uvcjl6bGhzNU9BY095bGV4VFBIaHN5SVhX?=
 =?utf-8?B?Q3dTVUZ5TFRWR0NKeFltODBBZVFzWVVhR0s0YWVPbjB3M3BSdTVUU1lWdDkz?=
 =?utf-8?B?Y2tlV1Zmd2RjY3RvMUFsUUp3ZWJkeW54SDBHeHBla1hHUGZhMGpRTEVJcGIz?=
 =?utf-8?B?NzcvRWlDSVVoNk5nbmhFRUhIVElscEtYMk84STh1K0RPdnM5VUF2MWg4UlBY?=
 =?utf-8?B?VTFzbTUyOHBvc1FXcktZeGxkeXY1MXIyc2VVbGFZWWxON2xvU0tRWENTY0lJ?=
 =?utf-8?B?NjJKeEtzVjUyeFpFc1VYMXd4TWx3dEd6bm1VM0JEYTUwUDNwMlRNdkNFelpy?=
 =?utf-8?B?RmJ3b2VmYS9IaWdxVWl3RU5XY1FHVU1raGtTUVdBNW1VVkk1Tmt0Vk50RkVq?=
 =?utf-8?B?MUZ6N0c2QkpGMjc4YzE3MW1ucDk2UlA0S1JqVWMwS2w0eUVuUlM3aWFzT0hl?=
 =?utf-8?B?cCtrK21JczBwckV3VW1KVkZtOVdIZDVMVXNzTmt4U1dVdEtFMmsrdUQ3aXZP?=
 =?utf-8?B?czhEQWc0MWNGQi9HWk1yeXpDTXkvQU5BV1VWeTdrS0FwaDdVeW1oZkJxY0Fp?=
 =?utf-8?B?YjNtSElnbjdtRGR4bjQ0Nm42RldQaTV2azhrWFp2MW1hTXp5bVlyRWVwU04z?=
 =?utf-8?B?M0cvVXNvQ2JyOHl3eDY2aDdNZ0hnalF6RkNtWmxvY3FZeGl5OVUvaVVuOHRX?=
 =?utf-8?B?YnNiaFk0cmVOdFgvd3pEMFJ1dEFMdTAraUZxU1RtZTYwYWpyYkI0dGpGTXhY?=
 =?utf-8?B?bVhLaWZzbThvMlZtNzEyaFFSZ0UvbUpjWU1BdWYzM1NIYURVNVgrdlFVTmMy?=
 =?utf-8?B?dmlLTlJ2UUZPbjhPclRvelpEWmdMRi9qUy91R2x5MjBkSk5Qc1NKQml3Rkgx?=
 =?utf-8?B?WEJsTlFQU003L3ExMGdBejJuUWZrL3hkanJYenlMclVDajMvNFdhZG9Ya2Jl?=
 =?utf-8?B?QVNHZnJPVDdCZis0UytwWFBQSHN4eXNCbWlvRUpVYWVhRFZHWm1YTm8zR2w2?=
 =?utf-8?B?RXc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <863D290AF76AE349931DFB72B3B17F9D@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aff1f8e1-a54b-48e2-9997-08db195fff18
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Feb 2023 07:47:09.4822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /bYIAgzKnh7M5Nc5wG73ziJDb0s6jmG2zrgHK5Cs999kfkZTnFr5P7G7K+6DaNZw2xmeHZqxVwg+g7Dl7i6SU6u9Vfqd4hXDjEtRk7kqnh0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6981
X-MTK:  N
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,RDNS_NONE,
        SPF_HELO_PASS,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIzLTAyLTI3IGF0IDExOjAwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gTW9uLCAyNyBGZWIgMjAyMyAxMjoxMTo1MSArMDAwMCBZYW5jaGFvIFlhbmcgKOadqOW9
pui2hSkgd3JvdGU6DQo+ID4gT24gRnJpLCAyMDIzLTAyLTI0IGF0IDExOjUwIC0wODAwLCBKYWt1
YiBLaWNpbnNraSB3cm90ZToNCj4gPiA+IFJlbGF0aXZlIHBhdGhzIHdvcmssIHJpZ2h0Pw0KPiA+
ID4gICANCj4gPiANCj4gPiBPa2F5LiBDaGFuZ2UgYXMgZm9sbG93cywgaXMgdGhhdCByaWdodD8N
Cj4gPiBtdGtfcGNpLmggaW5jbHVkZXMgIm10a19kZXYuaCIsDQo+ID4gd2hpY2ggaXMgbG9jYXRl
ZCBpbiB0aGUgcGFyZW50IGZvbGRlci4NCj4gPiAjaW5jbHVkZSAiLi4vbXRrX2Rldi5oIg0KPiA+
IA0KPiA+IG10a19mc20uYw0KPiA+IGluY2x1ZGVzICJtdGtfcmVnLmgiLCB3aGljaCBpcyBsb2Nh
dGVkIGluIHRoZSBjaGlsZCBmb2xkZXIgInBjaWUiDQo+ID4gI2luY2x1ZGUgInBjaWUvbXRrX3Jl
Zy5oIg0KPiANCj4gWWVzLCB0aGF0J3MgcmlnaHQuDQo+IA0KPiA+ID4gPiBBbnkgaWRlYXMgb3Ig
Y29tbWVudHMgZm9yIHRoaXM/IFBsZWFzZSBoZWxwIHNoYXJlIGl0IGF0IHlvdXINCj4gPiA+ID4g
Y29udmVuaWVuY2UuICANCj4gPiA+IA0KPiA+ID4gSXQncyBtYW5kYXRvcnkgZm9yIG5ldyBjb2Rl
LiAgDQo+ID4gDQo+ID4gT2theS4gQ2hhbmdlIGFzIGZvbGxvd3MsIGlzIHRoYXQgcmlnaHQ/DQo+
ID4gCS4uLi4uLg0KPiA+IAlyZXQgPSBtdGtfY3RybF9pbml0KG1kZXYpOw0KPiA+IAlpZiAocmV0
KQ0KPiA+IAkJZ290byBmcmVlX2ZzbTsNCj4gPiAJcmV0ID0gbXRrX2RhdGFfaW5pdChtZGV2KQ0K
PiA+IAlpZiAocmV0KQ0KPiA+IAkJZ290byBmcmVlX2N0cmxfcGxhbmU7DQo+ID4gDQo+ID4gCXJl
dHVybiAwOw0KPiA+IGZyZWVfY3RybF9wbGFuZToNCj4gPiANCj4gPiAJbXRrX2N0cmxfZXhpdCht
ZGV2KTsNCj4gPiBmcmVlX2ZzbToNCj4gPiAJbXRrX2ZzbV9leGl0KG1kZXYpOw0KPiA+IGV4aXQ6
DQo+ID4gCXJldHVybiByZXQ7DQo+ID4gfQ0KPiANCj4gVGhhdCdzIHJpZ2h0LCB0aGFua3MhDQpI
aSBKYWt1YiBhbmQgUmV2aWV3ZXJzLA0KDQpUaGFuayB5b3VyIHN1Z2dlc3Rpb25zLiBCb3RoIGlz
c3VlcyB3aWxsIGJlIGZpeGVkIGluIHRoZSBuZXh0IHZlcnNpb24NCihWNCkuDQpCVFcsIHRoZXJl
IGFyZSB0d28gcHJvYmxlbXMuIFBsZWFzZSBoZWxwIHNoYXJlIHlvdXIgYWR2aWNlIGF0IHlvdXIN
CmNvbnZlbmllbmNlLg0KMS4gV2UgcmVjZWl2ZSBtYW55IGNvbW1lbnRzIGF0IHRoZSBiZWdpbm5p
bmcgb2Ygc2V2ZXJhbCBwYXRjaGVzLiBUaGVyZQ0KYXJlIGxpdHRsZSBjb21tZW50cyBhYm91dCBv
dGhlciBwYXRjaGVzLiBIb3cgYWJvdXQgb3RoZXIgcGF0Y2hlcyAocGF0Y2gNCjJ+cGF0Y2ggMTAp
PyANCjIuIE5lZWQgd2UgYWRkIHlvdXIgbmFtZSBpbiB0aGUgdGFnIOKAnFJldmlld2VkLWJ5OiDi
gJwgbmV4dCB2ZXJzaW9uPw0KDQpNYW55IHRoYW5rcy4NCllhbmNoYW8uIFlhbmcNCg==
