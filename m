Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85DDB6B19A7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 03:56:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjCIC4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 21:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCIC4D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 21:56:03 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCF06A04E;
        Wed,  8 Mar 2023 18:55:57 -0800 (PST)
X-UUID: e6b96ffebe2511eda06fc9ecc4dadd91-20230309
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=XU11vwf0bcQE/psseS2vUcWOQ8P/EbGVUnukLPGwgek=;
        b=hY9yLL2VxCYmMOudRm5VUARgfxOw+ped8LzjaZFyxUcNg/PYI0ZJHflhldrccUG9BaT8piIquflpYJEUcKKpEZI/OYSQxtq7fIWvL6DXiG9dsEf8GRCOFt5Aq+GG88k4eLFmQdTRudI/qX/Pbu5kzUrRyp4i5lhIPfGPZa/tzB4=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:a1657626-9952-4aa7-a2b8-2cfa0088ee13,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.20,REQID:a1657626-9952-4aa7-a2b8-2cfa0088ee13,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:25b5999,CLOUDID:a47838f5-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:230309105553YS0NTQKA,BulkQuantity:0,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,O
        SA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: e6b96ffebe2511eda06fc9ecc4dadd91-20230309
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1459635460; Thu, 09 Mar 2023 10:55:51 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 9 Mar 2023 10:55:50 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 9 Mar 2023 10:55:49 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bS4UHuLs2mmUwOBXGL3OYdVQVe04wANnKF1OlwxNzxxK/2+gndfBKQ9ddwsqjADJL9MebGUH1bSJZ6mpVT1rmh4DYUJK4gkIY+mX3VaiyVWM5kGKqPuyF/nm9hQHDnZG9S69fZ885AkXTvg2OCNpV7dHOrB/BCJVtfHYzLfewlv3Xa1UlOSmyFGM2G/VKbgqskuNoP2qmD4mRvrsCwGZ3tMh/vR86LmflZLQut0RXeSC3RMqrKPEYgCM78J10skXIyI0UeSz6GfUGeLr/IpwVLK0OkkybGATJ+cWqP9ijTzeAOUN2SP1BnlYFzuFEJf7I5AfXHQFi9KP8CebhsPaSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XU11vwf0bcQE/psseS2vUcWOQ8P/EbGVUnukLPGwgek=;
 b=GCWbZltVY6F+MXx/Q4xAH3k6DZQo2FobHP6Rb/u/F3MD2oJ6KcCLPBEcbIaACGO/ohe9xGEcgHCY836+0+4bUqS0BaSZKGPBYeFCyRztC5dO03zj/Itdu53O9XNYCnLpW0KcPbTdXo16/MmDIclx4Lb2fu0Pss1WnNxdomuz9fGlp5OwMuSlzyrMuFqDphgG3M3zM8JeEt7Ca2TSLl/8BcRUwlJKEU2RfgyPITtRVR4Six+wlEZALpRG/iYi7P4n2bkEkVW6QJa78WU8Ok9/tTFJxUYwRTsDcUpBfDeRo0BUVXNFGQVXJVj+LO7pt6TTdNysip0Bj+9AMQPNX7JltQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XU11vwf0bcQE/psseS2vUcWOQ8P/EbGVUnukLPGwgek=;
 b=LLCptqJbjd0+w6PxH2T5tqmsOrhEXlmT5cGLMbPNTcSApZ6gylf+AxdjPdJ6wp/iMnTpAVySUFiFCfXzVuPADpu1a1c15IqWTjE9POM2lpJcgPHA12Ot+90wI7l2iyrbtPoDcJP6z2HjB+viUQLreKsr8D82hvlr4Pee8ndZH3w=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by SI2PR03MB6165.apcprd03.prod.outlook.com (2603:1096:4:14d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 02:55:45 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 02:55:45 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "wenst@chromium.org" <wenst@chromium.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Project_Global_Chrome_Upstream_Group 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 00/19] MediaTek MT8188 clock support
Thread-Topic: [PATCH v5 00/19] MediaTek MT8188 clock support
Thread-Index: AQHZLARzEGoyIZoOhEiaRt2yOb9uG6682BeAgDU1J4A=
Date:   Thu, 9 Mar 2023 02:55:45 +0000
Message-ID: <9422834b6f103f531aa7cd31a6f5a45a7fbef3c8.camel@mediatek.com>
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
         <CAGXv+5F-4Tyf1Yn7BYYMkPVyRQffEpx709F6+T65M1J+LfUPvg@mail.gmail.com>
In-Reply-To: <CAGXv+5F-4Tyf1Yn7BYYMkPVyRQffEpx709F6+T65M1J+LfUPvg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|SI2PR03MB6165:EE_
x-ms-office365-filtering-correlation-id: d17bafc4-cc37-4f2c-0c85-08db2049c790
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KNGxTRcKq/UmSxIxpVolrQmKj/0yoYAbv5N/4KHdat8itCqoFLNpWJDbRF3SZh9IQil5+yN811RiyjKVi1ezEb5Mn3/8s2uanaIBy6r4W5q+qsqfLvze6NCsyz0wDlU3/+/nv64nI/fX4iutX6SzRhTFd+uf1S+Dra92Vd9xfZryMHNz6k8GLgB+ckb0jM3mU4JMiJpaDk2zEeeIIPym52qpzhKXbxj3QcWjZJ4ea+Lt8XfJbY4MnSs9NV+LCSapw0x/ebtxnnh1S2C5kXqr5r42naDf8lQSOg6f62lg4d7D6iajQbzDsHBEI1bTcttO5npJzbH2h0KImeBSEWy4cmswSjzf6K2ZdXKz30rBxPNTABy4pn1FHL9xteytiSvLi8pATnHzrYeed+D+KNCEZF1WcbKY6fbd6gt3mvCThWmM3zuVK29YVLmPTgmTDTVSSAezGs3aUSXRKr4kZ083expncOovYISsB/ODlzR5jgQKt1IZdeMG0PET9nXH0PFKhQS1OZDfuMGt1geG4EW3O4EW9DKl9RS7BQIekZHOGBE1FaDnZgjFFmP/R6WNnSXcnEvptwt7x+T44y0H0am49cJ6xPctUJ97e30rfP70qfheFa2Hddm5lwZ+evy/2JvobSNe1Tn/3zZh6KDK5xBtO/AhWjTOD3LZ0AEgCQe4ljywqcgkFM3lqIjug0zgy17yleqvtGnS34WLk9onb1Y4tSSUaTknsNqcQNycouj3sj0H8F7GLpeH7Yd94MFI+i8v
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(366004)(346002)(39860400002)(396003)(376002)(451199018)(36756003)(85182001)(53546011)(6512007)(186003)(26005)(6486002)(71200400001)(6506007)(2616005)(86362001)(8936002)(66476007)(66556008)(4326008)(8676002)(66446008)(6916009)(66946007)(76116006)(2906002)(5660300002)(7416002)(4744005)(64756008)(41300700001)(316002)(38070700005)(91956017)(38100700002)(122000001)(478600001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bUtjVHdwWWtKaDBmWkh5QXVla2hXMWRtUUlRSnpBN0Vqemt2N2NZZXBjdXVC?=
 =?utf-8?B?SGR2SitTTVBrMUFza0d6L1NSTDUrMnNrSSthN0tZQnRhWTlsMlVmc3poZUdt?=
 =?utf-8?B?TXBQN1JndFdmSzQva1N3VksyWnh6alFjRksvSStWTFdOR1h5UVpaeWptZTk3?=
 =?utf-8?B?cm5zK0p3WHlCL1c0R3RLMHFJZjlxalpWMnl6b3NRODNsUGFmemVnUWN2Z3Fj?=
 =?utf-8?B?Y3I5Q0Q3ZjJKU29WUEpjOTUrSEtXYjNTdEhHTUtIY2Z2TDU2TmVndHUybVFx?=
 =?utf-8?B?bWdPT1FkWUgxUGNFRlJkQmd3Zm1ZeEE4a3FMeWZYU1BpNXpSMzVRdDVoOU5M?=
 =?utf-8?B?UHkzUlN4Vmt1ZzAya1ljc1pQaVZVWVhOdll3cDQ3ZEZFdmVaeGh6WGJEdUJq?=
 =?utf-8?B?UllQeGlEc2JkSy9LUUVYU09KZjhrbjhXa21Xd2dLRUVYUmFvVzdCejRXTjJy?=
 =?utf-8?B?NTRrZjN5cUtqZWhHZGVuNStlM2lkblR1KzhUNFFObm9aZk02UHR4Si9aK2FR?=
 =?utf-8?B?WEFSK2lXdThhVkovQ1JkYUZhYUY3TXBWUFFZZ2FJUmhyQ2ZrRkZLVE5xNHJS?=
 =?utf-8?B?NHJVZWd0ZGxYbXJKVTFlclBReTNRQVZpU1I0UUV2MnIvM0hldVhvdHIvV0RC?=
 =?utf-8?B?bUkrUUk1SDJaREt2SUxYTXU1NHZBT2hscUhieE51bWdDbnlJWTk1eVBLaGV2?=
 =?utf-8?B?ci9WeGV5SG45Qkk4MXNmNlI3c1cyLzlCNDhZL2hraDBwaWhQYlA5NWJvVGR3?=
 =?utf-8?B?azlNU0gvY1lDQzFZNi9jbTdhOGVCS25iVXFLZE0wdDdMS2xZRUtoN1V2RmNO?=
 =?utf-8?B?a01GZnJGemFPcmZsUUxoQ3J5YnFpTlEvaC84U0ZKbUVXdzFyejFUT2RjMUZz?=
 =?utf-8?B?M29aaHRyTkVMV2lDdU9sQ0UzR2lwayswWktLaFVERWFmM2lnT3hGMmtnQWtU?=
 =?utf-8?B?TmptZTVIbnErQ2MzNVRYak5vU2dOWnAzYm1wMHY2NysrcE4wanRYcE9XL3do?=
 =?utf-8?B?eWlNM01zT1dNaWJlTEttWFdTL3BDTnNORlFkTk9qbU5Xa29OTDk1QUpHYTI2?=
 =?utf-8?B?T2xINm45eUwwOC9pUTRHVUdQNjMwU1RzVnROVjlocFBMWmltYzh1R1VwanJB?=
 =?utf-8?B?K2N4S0JLT0Z2RXNkSVdCNDRuc2g0Z3hKY2JLa3VDNkdHMVZESlRnWWJHUFlZ?=
 =?utf-8?B?em5xUXRycm1wZHNualFSQjY2Z29HRllkTU9SSlFyNXlQdkJlUnhTQ0pKUWgw?=
 =?utf-8?B?aExXYzFNalR0ckdOZUUwdlE0Ty9mTEZsSzgvOTZubzRuNVVzU2ZsemdBTGhq?=
 =?utf-8?B?WkpCVHdveld4Y00vQUd2OXhqWlRTUGtZOGFVSGtHdTZhLzltYW8wekFqZlBH?=
 =?utf-8?B?SXdhRUJDM3c1ZExBMkQzQUtuZUdEVEtiZDc2a0FoNW9pd3p2VGdVR3dLamRh?=
 =?utf-8?B?UHg5cjdZL1RJQlVJaVMxQ1hvODhjenFHRzJ6SEV2QjY1cWZEcS8xQi9rejg5?=
 =?utf-8?B?aG9qanZUZlZUalhwT2Jza3VoWVF4ei9JQUpLNzdMS1E0Y0pnMGl3eUEwL2V1?=
 =?utf-8?B?bWkwNEREaGphY2ZCUFNxV0RCNGNYMGgvZnZTTG9TNmZrVkppV3RwcE9ZSkpD?=
 =?utf-8?B?VSt1bnVoeUx3b1VCd1BqT2pvWE1oUVY5ZjRYS1dDZ0VYcktCb2xOSGdPZ0Nl?=
 =?utf-8?B?MGtaNWloSTdKRkFBbENzOWdDeElqbHFLM1g1dGMraUI4VVBPTDhFSk9FWGgz?=
 =?utf-8?B?cklaQWZickZZM1RzeWkrdEJGSm1sc1V3Y3J6WlkyRDBXenlxNW4rdjhCY01P?=
 =?utf-8?B?dmQ0elBtbWhLSERWU2lDRllLaVhWS2pRTGVjY2ZzVkJaMy94aytCWE5FSWFB?=
 =?utf-8?B?dXhPVmhON0NEVXVTR3lXRTVKU2g2K1BQNTNlSnJnUk1uSnMvRHQ0ajlUWDNq?=
 =?utf-8?B?NnNEbVdma2hwU3JROUpEaUZFcUE1czlKTnl0bnJ6QndTKzM0bkcwRUVMUHdt?=
 =?utf-8?B?RkVlUDhkd29VckNtYlV3UnpnMDBTR3E3Uzc4V3o0WjltMUlSMXFNclpSVmRB?=
 =?utf-8?B?cUpWNDNHYUFJdVg5VC9uOXhRR0VBUUVQdHJqa2dDQnRRaEVUOGxKN3g5dTY2?=
 =?utf-8?B?ZXEra28vb3puUitxWHJlUHVSVjZRdmFtNEkycS9QWDhNNGhRZXBZRE8wdjl3?=
 =?utf-8?B?THc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <70F85CBE58B43849B424BFB5E5074017@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17bafc4-cc37-4f2c-0c85-08db2049c790
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 02:55:45.4615
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: L1LTPf+uGBX6Ttc5MjKNcHE6tEKOfh5QB69T0HIvY6n7dWdCLVuXC1VrJpixfwP6LFMt7xJehcT20BKFBXUV6THbdgSYbsHGArqtUQT/5fc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6165
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDE0OjIzICswODAwLCBDaGVuLVl1IFRzYWkgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDE5LCAyMDIzIGF0IDg6NDkgUE0gR2FybWluLkNoYW5nIDwNCj4gR2FybWlu
LkNoYW5nQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQmFzZSBvbiB0YWc6IG5leHQt
MjAyMzAxMTksIGxpbnV4LW5leHQvbWFzdGVyDQo+IA0KPiBUaGVyZSBhcmUgc29tZSByZWNlbnQg
Y2hhbmdlcyB0byB0aGUgTWVkaWFUZWsgY2xrIGRyaXZlciBsaWJyYXJ5DQo+IHRoYXQgbWFrZXMg
dGhpcyBzZXJpZXMgaW5jb21wYXRpYmxlLiBDb3VsZCB5b3UgcmViYXNlIG9udG8gbmV4dC0NCj4g
MjAyMzAyeHgNCj4gYW5kIHNlbmQgYSBuZXcgdmVyc2lvbj8NCj4gDQo+IFRoYW5rcw0KDQpPSy4g
SSdsbCByZWJhc2Ugb250byBuZXh0IDIwMjMwM3h4LCB0aGFua3MuDQo=
