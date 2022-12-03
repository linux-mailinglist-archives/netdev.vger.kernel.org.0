Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E928641424
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 05:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231182AbiLCEkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 23:40:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229823AbiLCEk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 23:40:28 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC1B113F44;
        Fri,  2 Dec 2022 20:40:23 -0800 (PST)
X-UUID: 9d03be2913354dcc84443909ef700271-20221203
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=153OjsiryXJ/zqIVF8ZmEe3SQU987halTBFC209Ldng=;
        b=Vwcw94wZWQD/GI3L9FZLJmifsNvR7lS6Yb+GEQTNa7g6XjolwFK8NP9okNfIpToib7ZfsYeOh+s82PncpN2ZQ9og93BiLSClLJMxvuDt/O0rLgTqX091zet4oa1nmNw/YLNRHvjcP4EAsnZExIFMb0UliRxXfuTdp8dea8ewFBA=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:ce1b13af-e3e0-40db-a51c-98a848e5708d,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.14,REQID:ce1b13af-e3e0-40db-a51c-98a848e5708d,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:dcaaed0,CLOUDID:84206f6c-41fe-47b6-8eb4-ec192dedaf7d,B
        ulkID:221203124019KRKFZ9OB,BulkQuantity:0,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 9d03be2913354dcc84443909ef700271-20221203
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1733981565; Sat, 03 Dec 2022 12:40:17 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Sat, 3 Dec 2022 12:40:12 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Sat, 3 Dec 2022 12:40:12 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jZYnVUgUoZxn6GOGywisQv9jFwnvpXUGZRL8MKRJxhNDsW9EiAFyN45nnlL4FDhKXRg0Lm7AcvC+83/OMuFezxxtXsIv3BQ/ZVEkfGPbEj/Vgp673VKI+SwUapiroH3WIsxZBWNpe+OmVub0zCImdoB3wPJIBLzqB40gL8ddyhTjnmB+/0tAvQX1HdWdek7ZHE/w8iLj+LhuChp8sNkx1Ts5EqlKfLk7b+iIXoByQl4EMQHR95LMPKssiqtR0pMVKyqOCR8+4zzspy2uUnUxhbaBJUMFjxTnWR19D4Kh78vdlFqEeYAI/Jb86iH3VEKLJAiuetJn1w05wG9VVxNYag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=153OjsiryXJ/zqIVF8ZmEe3SQU987halTBFC209Ldng=;
 b=QYRz4oDrjnDBT5p5hQdMK7oL1F9KQzlRf32DW75UrzbY0nHVZwO9lqw/+eJqxQrmPsReEAZ0GB7X7RrHrVmC4pNNfJgzORcFyT+w2/qTcqtFAmUu+3BStTymtetFfqjRR8WC0a+X5/ry02DDUantUBuGdx94VIQ3lHk8bNqyzDQiKK7Kc+Dpxd6fLg0IpmqdGeamFky5E8VIjjLATvdQ7+QxIs30cRb6ErGFpXYBSbjVUW7bg492Byyvc/AgX63Set3ngTprfHcCjRCY2w1WHuR9a1AdvU5eh98oBE4ZSa77WMUyeUNeWLeDf+GOBJYLKFhBTJCIvxIx0CPfay+ODg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=153OjsiryXJ/zqIVF8ZmEe3SQU987halTBFC209Ldng=;
 b=hlXi5LNa+/fmF5W7eTQv7xd5pHK5Zy4aT5OVPCLcgQ9mpNn73hf8B1KCQqEbR78crMS82JNQXJ3sP0n+nmVHzXEyrQoxIDN7fsW/BIMIGW6wSaSYwjd2ufSK7/BndTc/YZilBeUDylpsm/GlcXwCc3/lzTZYwlV3ApMofEel3uA=
Received: from TY0PR03MB6354.apcprd03.prod.outlook.com (2603:1096:400:14a::9)
 by PSAPR03MB5254.apcprd03.prod.outlook.com (2603:1096:301:4d::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.10; Sat, 3 Dec
 2022 04:40:10 +0000
Received: from TY0PR03MB6354.apcprd03.prod.outlook.com
 ([fe80::320d:30ac:41ac:b1a3]) by TY0PR03MB6354.apcprd03.prod.outlook.com
 ([fe80::320d:30ac:41ac:b1a3%5]) with mapi id 15.20.5880.010; Sat, 3 Dec 2022
 04:40:09 +0000
From:   Ryder Lee <Ryder.Lee@mediatek.com>
To:     "keescook@chromium.org" <keescook@chromium.org>,
        =?utf-8?B?U2hheW5lIENoZW4gKOmZs+i7kuS4nik=?= 
        <Shayne.Chen@mediatek.com>
CC:     =?utf-8?B?U3RhbmxleVlQIFdhbmcgKOeOi+S+kemCpik=?= 
        <StanleyYP.Wang@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?utf-8?B?SG93YXJkLVlIIEhzdSAo6Kix6IKy6LGqKQ==?= 
        <Howard-YH.Hsu@mediatek.com>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        =?utf-8?B?RXZlbHluIFRzYWkgKOiUoeePiumIuik=?= 
        <Evelyn.Tsai@mediatek.com>,
        =?utf-8?B?TW9uZXkgV2FuZyAo546L5L+h5a6JKQ==?= 
        <Money.Wang@mediatek.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        "nbd@nbd.name" <nbd@nbd.name>,
        =?utf-8?B?TWVpQ2hpYSBDaGl1ICjpgrHnvo7lmIkp?= 
        <MeiChia.Chiu@mediatek.com>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        =?utf-8?B?U3VqdWFuIENoZW4gKOmZiOe0oOWonyk=?= 
        <Sujuan.Chen@mediatek.com>,
        =?utf-8?B?Q2h1aS1oYW8gQ2hpdSAo6YKx5Z6C5rWpKQ==?= 
        <Chui-hao.Chiu@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        =?utf-8?B?Qm8gSmlhbyAo54Sm5rOiKQ==?= <Bo.Jiao@mediatek.com>
Subject: Re: Coverity: mt7996_hw_queue_read(): Integer handling issues
Thread-Topic: Coverity: mt7996_hw_queue_read(): Integer handling issues
Thread-Index: AQHZBpsT2efY3IsmxECzUUgoRAK1m65blWsA
Date:   Sat, 3 Dec 2022 04:40:09 +0000
Message-ID: <786eff1a1751a5bc0dc68d6567be585b635bddb1.camel@mediatek.com>
References: <202212021411.A5E618D3@keescook>
In-Reply-To: <202212021411.A5E618D3@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY0PR03MB6354:EE_|PSAPR03MB5254:EE_
x-ms-office365-filtering-correlation-id: 330158ed-c5de-4661-ba8e-08dad4e87553
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CEFqz8SvB5wcIMm/a49bXdw7i8OTimnWs+7dSf2f7lVGKRSuDEvOfFBLc3y2Lg0R8+qHWpuxHolElHJxqFOTB553vHQu2FCsu8x/9sHk1YQH5p8cI1qmFmn+Uy+KcnTrwQYGaDt13ij66GzPz8DOSPyyG8rTlEEXfZUASNHOj6w6BZmLwX/b1dOw6/ntsxUHdMdLJTdk5IkfFWjZnKSS4ONUufyMyBd4k4AFQ1EyvOcnS8duTbT9YrDpxok1z++4HY2VaIeZ6J50QD/tZv0C/FrLsQ/lUuUjARgZEEgJInWvZzAvlMRJMWs4mj/CSIOUmJSvRhmm3DHAtYrlgPl6YhU5z9pR/FksKGkwonrGFORTNi4jbQwOpbwDehemC9kYg5hmQyMhV5H0w/strdUNGhe+qMRN8gXWNoiAk95tPFuSrpWsLoH/qPcwIWuLkgGSj/onN/4343kro4O76Rj8QbgCbKyhgRh7d/qDq18xOsxAzcHBP/lBQA6V41QmCdjX4E2+ru58ErOvXVPZ15t9ft7lJdwP53LfUKfocA6r/x2Vtv+/6NRU6FaWf9o6X0bdL8/LSzSKA0AS20tbyqr/yir9rK9i820GxzYRXWG1Zv+ui631q0puVP/SjJnsXLGnnuSOnP1puKEkOdOIv6fNAkWWlsxagX9jxxJ1BETlsMtNF31cKPhmOgCSVSTsEh37CGKKDStbYDZEQdznpyi1jjEzBM9p7S+QNs6XOQjtGL04k4ThzQdG47OgVHjPxcHpMCVkSv89AdZWXuC8iAKrPlohacSS+J6ZFWZPkFaztJk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR03MB6354.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(346002)(39860400002)(376002)(396003)(366004)(451199015)(2616005)(6636002)(316002)(478600001)(6486002)(966005)(110136005)(36756003)(86362001)(38070700005)(54906003)(83380400001)(122000001)(38100700002)(26005)(107886003)(186003)(6512007)(6506007)(4326008)(71200400001)(66446008)(2906002)(8936002)(66556008)(64756008)(66946007)(66476007)(5660300002)(41300700001)(91956017)(76116006)(7416002)(8676002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2dLQk1aUW1scXUvaVk3bnB6TXhvcnQycHdtTDIvc1h3bFZrOTl2WFYwZE8y?=
 =?utf-8?B?MGFCaWxjeExpYXgveURzaGJKUDJNTTE4aG5FV2t2STRvcExrQ2w2ZjllZWww?=
 =?utf-8?B?OEZnRmJyNWo1V2lOV2hPYXd0bFBqMG14Q0ZtVURBRVVlNjBCdi9CbW5NZGhO?=
 =?utf-8?B?ZkREUldrZlljVThNeGhQNFZTRkpPTFlSNUdXUktpNEsyOWFGcFl5c2g5bXUy?=
 =?utf-8?B?akd5ZFN3OVBPUVNObHJESkNWaTBuNzZPTGx1K0kvbU02ZnFjS3cyRndpb0pN?=
 =?utf-8?B?UjlBZGdRSDNveGQvTWQvdDkrenRPNUdtL09qV28vcGl1ZXBoUW1NeVVxbUtH?=
 =?utf-8?B?RXRxdmxZd3pmTzBNMXI3c0owbjUzYW0zbms3Y3RseEREdUlhdTMweHRKMGUw?=
 =?utf-8?B?Y3ptbVdHU25TZFZ5UzZuU3hYOThtZ01HbGNGYUZUWm50UzUwSVRvUmkyVEgr?=
 =?utf-8?B?bGU3VUl4c3NGM1NmTWxscW5tY2xwQlBjbkVCamYybVpNeFlENEgwQ3A3NEdn?=
 =?utf-8?B?VU94UDE4ZlI3VjF0blU4Z2lKNDZBZWlZY2ViWWpaT3U2YVpiWHFhaSt1b21D?=
 =?utf-8?B?NHhYTk9sd0ExZ0dWaGtsYWt3bDlsbEE4SVk5blR2YnV1cU9telE0OE1DVWhM?=
 =?utf-8?B?aTJqeXZicXF3MGdYNDh2T0xhakF4bzhkRnErUTZLTTVZWW5qZVJMUXZkeUl3?=
 =?utf-8?B?N2N3NjVJRGt1NS9vMTlXVFFzdWdoemwrM2F1TUZSMFZsM2VKdVJQa05Ubk5I?=
 =?utf-8?B?TWtxMzlRQWZXUlZJeU45bWNENWJpZ1BoVDJ1ZldTd29uNzE1SHB6NFoyNURT?=
 =?utf-8?B?NUlCNzRhTjVxVzZOci9lRVgvVWlHdHBDbloyaHZTS3JwRWIzVjUrQis2aHJR?=
 =?utf-8?B?eGNvd212Y0RZY1dkZllDdks5QnFvWE8zR0Fidkw4V01HOW1xTlFlWmpRdUFT?=
 =?utf-8?B?OVl0K2RFUnZaaWNFT0U2ZFNHeW0veUZRWlFHYkg5TkF5aU1Ld0ZnRU50VXZV?=
 =?utf-8?B?NSt2dGxmL3J5eXkrQlhQenYyN2VVYTJJUFkxV05Za3lid2RZc2kreDQ0NXpa?=
 =?utf-8?B?QVh2djBBRzA2bERvNk1WSWFkODNnZlF5ZUFidWRDdUkwM3ZsYThGcVdtTzBX?=
 =?utf-8?B?aWRPWkhucWwvNGp5cUNXTHdOb3ViUkpKUlZTZVYxcGl4TDcyaThPWGtoYXdU?=
 =?utf-8?B?bUFjSkMwK0xWL0VHbkVYWUpqNWxaVks5UFlWcEJRWWw1dGcrcXpnUHdZWm9a?=
 =?utf-8?B?NkhmWG55VE5JYnRUYTFZUng1dTUxTEgwUWNQTnByb2xXa1gyQUNzU0UyTWZU?=
 =?utf-8?B?SnZ6dC9TVmc5eTFERXhqajlweEtDQ0VJT1J1SE9kQ09zYSt4dklsREJlZGk2?=
 =?utf-8?B?T2g4aGRGZmJuR1prZlpLK0owc0ErYkRoc0c4d0xzZWZic3lMZDRTaWJIdW9B?=
 =?utf-8?B?MUhYTC9OR1crM3R6b0VlTDhrREwyUFFsbnVLQmRUVHkwVElhYkZrWkkrc3RT?=
 =?utf-8?B?aWQvNU1VSEdkenNnMU00VCtwZzVLMWxVNnhUVEtkUGZ2QVE5TG0zeW93NFRn?=
 =?utf-8?B?ODNSWHl4cTJxYW9VVnpuMi9hZVAybVhkeHRTRGx0ZGtWWVJEazN2a2thY2Zi?=
 =?utf-8?B?amxlS1ZvZGtoN0NaNmpSUmJ0c2RGRklTeUNYYmZLZnVpWVllVFdCRGJKU0hK?=
 =?utf-8?B?T05LQTJLbjNINy9QaFBDWjc0bWdMZWpLSWw4RzcxZTNiS2NGOXdnTzBwSGFZ?=
 =?utf-8?B?ZEgwMDUvdlU1WlhSUUNxT21xaHMzUkFzK3RnRmt2TTVVZ2dtbW5lRkRRSVRV?=
 =?utf-8?B?akFaUzJwY2FXNGEvRkNjcWJyS2xzdXNjMlpQVnNZVlJSUzNuTHFiYmk2VVk5?=
 =?utf-8?B?MGhreStyd3EycVNxTnhPdXlDbzFES1J5Zm83M25pcFpaanhXOWZRNkIrVGhs?=
 =?utf-8?B?Z2syYzBDbDJYR3VnMkQrTGgyYk9sbUx0Nm1iT3lpVUFySjY0WExUckR5QTVs?=
 =?utf-8?B?U1RPdE9yUVVkNFB3dWtKWTFyOS9abTZPWTVRQWNIbzg1TnNVUkJjdkh3SktR?=
 =?utf-8?B?b2Y5M2oyWnd6Y2dIVlJKamZNaHZabytoV3hIV2RYTWlENDZ5WGY2VWorY0pF?=
 =?utf-8?B?Vzh0bFc5YnJlOVJ5T0xrb3d0cHhhWm5TSzk0S2dyQ3lGMVgyRXlxNnR4NHhw?=
 =?utf-8?B?Vnc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <48C42208EE1D874895BF59C22D9BBA96@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY0PR03MB6354.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 330158ed-c5de-4661-ba8e-08dad4e87553
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Dec 2022 04:40:09.2112
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lz9wUtsiNuRHDU7/DxvOnuIo5HMY+i4xLbqF9wqE4wFsjuDP4fQElja5IQLUWuxaTy1YoK3yidVkLuAuTK4l3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PSAPR03MB5254
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDE0OjExIC0wODAwLCBjb3Zlcml0eS1ib3Qgd3JvdGU6DQo+
IEhlbGxvIQ0KPiANCj4gVGhpcyBpcyBhbiBleHBlcmltZW50YWwgc2VtaS1hdXRvbWF0ZWQgcmVw
b3J0IGFib3V0IGlzc3VlcyBkZXRlY3RlZA0KPiBieQ0KPiBDb3Zlcml0eSBmcm9tIGEgc2NhbiBv
ZiBuZXh0LTIwMjIxMjAyIGFzIHBhcnQgb2YgdGhlIGxpbnV4LW5leHQgc2Nhbg0KPiBwcm9qZWN0
Og0KPiANCmh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3NjYW4uY292ZXJpdHku
Y29tL3Byb2plY3RzL2xpbnV4LW5leHQtd2Vla2x5LXNjYW5fXzshIUNUUk5LQTl3TWcwQVJidyFq
Qk9vajZMTXFxQThFMEF5aktRVGEtMHJWemNGaVozQmJwY2lFSW43c285NzRrY01CZUc0elptLVFV
NEF1ZExYWTctak5VU3QwdW56QXQyemlyU0YkwqANCj4gIA0KPiANCj4gWW91J3JlIGdldHRpbmcg
dGhpcyBlbWFpbCBiZWNhdXNlIHlvdSB3ZXJlIGFzc29jaWF0ZWQgd2l0aCB0aGUNCj4gaWRlbnRp
ZmllZA0KPiBsaW5lcyBvZiBjb2RlIChub3RlZCBiZWxvdykgdGhhdCB3ZXJlIHRvdWNoZWQgYnkg
Y29tbWl0czoNCj4gDQo+ICAgVGh1IERlYyAxIDE3OjI5OjE0IDIwMjIgKzAxMDANCj4gICAgIDk4
Njg2Y2QyMTYyNCAoIndpZmk6IG10NzY6IG10Nzk5NjogYWRkIGRyaXZlciBmb3IgTWVkaWFUZWsg
V2ktRmkNCj4gNyAoODAyLjExYmUpIGRldmljZXMiKQ0KPiANCj4gQ292ZXJpdHkgcmVwb3J0ZWQg
dGhlIGZvbGxvd2luZzoNCj4gDQo+ICoqKiBDSUQgMTUyNzgxMzogIEludGVnZXIgaGFuZGxpbmcg
aXNzdWVzICAoU0lHTl9FWFRFTlNJT04pDQo+IGRyaXZlcnMvbmV0L3dpcmVsZXNzL21lZGlhdGVr
L210NzYvbXQ3OTk2L2RlYnVnZnMuYzo0NjAgaW4NCj4gbXQ3OTk2X2h3X3F1ZXVlX3JlYWQoKQ0K
PiA0NTQgICAgIAlmb3IgKGkgPSAwOyBpIDwgc2l6ZTsgaSsrKSB7DQo+IDQ1NSAgICAgCQl1MzIg
Y3RybCwgaGVhZCwgdGFpbCwgcXVldWVkOw0KPiA0NTYNCj4gNDU3ICAgICAJCWlmICh2YWwgJiBC
SVQobWFwW2ldLmluZGV4KSkNCj4gNDU4ICAgICAJCQljb250aW51ZTsNCj4gNDU5DQo+IHZ2diAg
ICAgQ0lEIDE1Mjc4MTM6ICBJbnRlZ2VyIGhhbmRsaW5nIGlzc3VlcyAgKFNJR05fRVhURU5TSU9O
KQ0KPiB2dnYgICAgIFN1c3BpY2lvdXMgaW1wbGljaXQgc2lnbiBleHRlbnNpb246ICJtYXBbaV0u
cWlkIiB3aXRoIHR5cGUNCj4gInU4IiAoOCBiaXRzLCB1bnNpZ25lZCkgaXMgcHJvbW90ZWQgaW4g
Im1hcFtpXS5xaWQgPDwgMjQiIHRvIHR5cGUNCj4gImludCIgKDMyIGJpdHMsIHNpZ25lZCksIHRo
ZW4gc2lnbi1leHRlbmRlZCB0byB0eXBlICJ1bnNpZ25lZCBsb25nIg0KPiAoNjQgYml0cywgdW5z
aWduZWQpLiAgSWYgIm1hcFtpXS5xaWQgPDwgMjQiIGlzIGdyZWF0ZXIgdGhhbg0KPiAweDdGRkZG
RkZGLCB0aGUgdXBwZXIgYml0cyBvZiB0aGUgcmVzdWx0IHdpbGwgYWxsIGJlIDEuDQo+IDQ2MCAg
ICAgCQljdHJsID0gQklUKDMxKSB8IChtYXBbaV0ucGlkIDw8IDEwKSB8DQo+IChtYXBbaV0ucWlk
IDw8IDI0KTsNCg0KdTMyIGN0cmwgPSBCSVQoMzEpIHwgKG1hcFtpXS5waWQgPDwgMTApIHwgKG1h
cFtpXS5xaWQgPDwgMjQpOw0KDQpIbW0gLi4ud2hlcmUncyB0eXBlICJpbnQiICgzMiBiaXRzLCBz
aWduZWQpIGZyb20/DQoNClJ5ZGVyDQo+IDQ2MSAgICAgCQltdDc2X3dyKGRldiwgTVRfRkxfUTBf
Q1RSTCwgY3RybCk7DQo+IDQ2Mg0KPiA0NjMgICAgIAkJaGVhZCA9IG10NzZfZ2V0X2ZpZWxkKGRl
diwgTVRfRkxfUTJfQ1RSTCwNCj4gNDY0ICAgICAJCQkJICAgICAgR0VOTUFTSygxMSwgMCkpOw0K
PiA0NjUgICAgIAkJdGFpbCA9IG10NzZfZ2V0X2ZpZWxkKGRldiwgTVRfRkxfUTJfQ1RSTCwNCg==
