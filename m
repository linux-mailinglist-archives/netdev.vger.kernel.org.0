Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE36D64C503
	for <lists+netdev@lfdr.de>; Wed, 14 Dec 2022 09:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237587AbiLNIZr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Dec 2022 03:25:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236681AbiLNIZp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Dec 2022 03:25:45 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FA56260;
        Wed, 14 Dec 2022 00:25:39 -0800 (PST)
X-UUID: 03629c52176c43ed8a0389096884bf34-20221214
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=bgUDQ1bUov5KO5KCUfDZww5xtWbP47vnmExAOqi0U9M=;
        b=q+JJtVad5Rpyg/+iNazdF7ntaRwwj0xL6OrWiu7nM+3gBbsT70VybSu3uZYZgM0o1gUW97Dzksk4LsEooVCCJ2nyuxR/QlKF2npaJN7MBxPb31zPAwt+iE8RCZZRlzzYIDJ9gDAgCgnTg3qQCD5O0sQa1HSkvgoC8O7yEHz2kqs=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:0fdcb9d7-187d-4e18-97fc-bca59996ffed,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:dcaaed0,CLOUDID:8c887c17-b863-49f8-8228-cbdfeedd1fa4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 03629c52176c43ed8a0389096884bf34-20221214
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw01.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 631001887; Wed, 14 Dec 2022 16:25:33 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 14 Dec 2022 16:25:32 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 14 Dec 2022 16:25:32 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LVJLDQGzV5smh4/PxuXVJP0cqs1OZgAlMns3sp/WekJlc2Cr4d059RmJUyIb2UJ78x0EoGRDftmaJrrjjHiTQ/zrVbRpgyNepgK2gOXguT8k2zm0OpVS2D56Ycl+wFsmnLVk9KXhCw61mQE+MNuromAhGdfjy/yuw5izvjgLk+BVYotqxbI9b4kfeF46vQlXl/YHr/1p5GSbW1qyVYjdChL37u4ugmfqssrk27oJdRyLqZJ6XSSUIhWzHMEVehyPg5+N0RR7VOuPJRzIlzAdpY1vjDaE9T2X2HYo8UNGWYYm+se8jrMAkrcHdCtvJzn1Dxp8h/WC+Du0eq7HSPIQag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bgUDQ1bUov5KO5KCUfDZww5xtWbP47vnmExAOqi0U9M=;
 b=AuONr4mtvDGMTtRRzLg3SDczR13NNwl31GLPb6b2tW2CBNqk/vgtr3i2f6sV86SHA5v2R9hkxUN0FV7bfD0XrKmr1V/Wb75imkiYx+DkbbmPOuIMGjgQ0uUdvZw9hLU+HwOs3/b6/pJXQlgWJ2wS74VA5SOLzlOArYk4/23E/gHVbxmQ4liZrlW+qYlWa7OVpGDkmI5kuOOMdQIz5hwnBRdZKZflaJM738qNoJcrZoN0DnCj8dATAAWEb4ZGSVVBOmP3qRDUMhusW/GkP4jCpP27iYHyFWymTMl5HrBlBMOsRE8wZQ43YyCliqWK/9Ty43yQxep8EjO423PwzEVvhA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bgUDQ1bUov5KO5KCUfDZww5xtWbP47vnmExAOqi0U9M=;
 b=heSKEWOWVNTGXkFhUyyC1gRljf9BhJ6SBiREVY/XWkiL+RCmv+p2Vg/8NDC5xTw5ncFvHmbM8ODD8EiXx5iqWQSRozGLWfMpsky30BagIkDzcIdbl+o90GPI8eowRajhNWOMboR8eYwwBxkbbAq7r7/fJCnMy9JVYZc7+j6Fxw0=
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com (2603:1096:301:8f::9)
 by TYZPR03MB5215.apcprd03.prod.outlook.com (2603:1096:405:5::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.19; Wed, 14 Dec
 2022 08:25:30 +0000
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::3e67:567d:4e5f:307d]) by PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::3e67:567d:4e5f:307d%4]) with mapi id 15.20.5880.019; Wed, 14 Dec 2022
 08:25:30 +0000
From:   =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>
To:     "loic.poulain@linaro.org" <loic.poulain@linaro.org>
CC:     "stephan@gerhold.net" <stephan@gerhold.net>,
        "oneukum@suse.com" <oneukum@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "chiranjeevi.rapolu@linux.intel.com" 
        <chiranjeevi.rapolu@linux.intel.com>,
        =?utf-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "shangxiaojing@huawei.com" <shangxiaojing@huawei.com>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Topic: [PATCH v5] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Index: AQHY/9kYYzEaTkwM8Eq+zQIVqHDO1a5Y1r6AgBRUz4A=
Date:   Wed, 14 Dec 2022 08:25:30 +0000
Message-ID: <54c37c8f8eb7f35e4bb983b9104bd232758bae7b.camel@mediatek.com>
References: <20221124074725.74325-1-haozhe.chang@mediatek.com>
         <CAMZdPi9JOQpmhQepBMeG5jzncP8t5mp68O2nfSOFUUZ9e_fDsQ@mail.gmail.com>
In-Reply-To: <CAMZdPi9JOQpmhQepBMeG5jzncP8t5mp68O2nfSOFUUZ9e_fDsQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5653:EE_|TYZPR03MB5215:EE_
x-ms-office365-filtering-correlation-id: 32a2a748-c791-421b-5428-08daddacc32a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: ZuHgzgjcb9SZ9H8645PPUpXLTEI4aDlr7YAlSBbQUih/z0wG4QnprwXhANX1B3exsa0lQKLka9M3K5H2aA+NH0CjnmSxq6GISirOe9+uzjC3aQ+7WQj5GOG7qomhgx9JfVV+VPjxPkCyQLnkmGqnkhshVLwZol9Gjj61b+EbAPFSm9knFmLJE/JXNiQOn6vOT3riYwPVxGerMSblOM9kiDjx1USDcXgPrLIr63P6ig6Wze9QYhCF4BrNu/yMQo4P9rgfryPN8P9frNdRB1eOG4Guywvm0kyFjp+8DxVB8zbWQyQhjJPztK/EJDpYgPVXFPzMfWx2HPa/9WP6smcMHMhcEg8RLoQOPNp1Orf4fZTUHRYZj6lV7V8QVeHNGc6ILEcLB1oAA7fos23UDQmoqAh3Iy6s9ZL3gtn6wK9UgroXBolu/hYVvfhQZStbjYrAb5OzKFw+2XCdLfFxQh6F85crZJrsBi59J+iUEhqeb3g699/DkJdMXZiC65Fkb5i9Css0ED0MnpsSFrJbEVZi6KR7q6KQXaRFxhupPikdQB2SJoG9wWIg3Y37UAc9bBKoBEiAGqSt/UvOU9dN7WDyVQ/w0jEYNmB6pVlH2OmdywLYm0mPMihdbyaX01VnkEfsODt3CwZdjMX6g92C9P6VkCCWL1N9aXl0MNBLB3pxH5FJ1XrtS8yAGkqbD0cKLosFdtkRFbjds7rG4kaX+mIqWkc3WMD145lDqQgaU0YU0eI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5653.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(396003)(136003)(346002)(376002)(451199015)(85182001)(36756003)(38070700005)(86362001)(38100700002)(122000001)(6486002)(6506007)(2616005)(478600001)(71200400001)(6512007)(26005)(186003)(64756008)(4744005)(66556008)(41300700001)(8936002)(54906003)(76116006)(8676002)(7416002)(66476007)(4326008)(2906002)(66446008)(66946007)(91956017)(6916009)(5660300002)(316002)(83380400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkR0YjRSY2hXb3RNM1BjdnhzL1ZZRjNwbDZhVUdmUUFNbjB2dFFMWjhweGlH?=
 =?utf-8?B?ajBxTE9PNjZCK2E5cU1QcEtuOFpwaXo4cVNlemhJck81TjlzNkpDdFFqLzRF?=
 =?utf-8?B?NVZVMFpuQlZhdEcyWngvME5hNUdYQnBhMC9PbTMzd3RmMzlFVzFrOXl4N01k?=
 =?utf-8?B?SytxdlV4cDErRzlPSFBCbktLdC85VUdabnd5d0R6TGo3RVlxREk4a2lOU1VU?=
 =?utf-8?B?MDBnaVkzdnpmQnJGdGt0dC84RmdDalBpTDFMYUlJcjNSUWNIOWYzdEdGQUgw?=
 =?utf-8?B?SklTYXpJbENvbUxYUmt1Y0Ntb1FpYmhzMVl4V0VmbmljZ01VY1FSaWd1OHgv?=
 =?utf-8?B?VHJhMVdOdUNUZlVFZEtQUXltYlNxemNJU0N5Y05icGR2Zm15Um1CTGJ2VHFH?=
 =?utf-8?B?NEI2WUoxVzkvYi8xMUxzaytSRGZjbE5Ia0gwZXY0VHJuRERGaUhvcjVvYllK?=
 =?utf-8?B?Zzlpd2ZFaWJIZ3RSd2ZaOStQMnJISlh6UGtZYXB6ODhnMTJtcWJnOXp4SmlV?=
 =?utf-8?B?dklGRG5WVGNBaFVHTlc5bUZKdndMRFpibGJ2YkFBNkdsUDR0VDFqNy9GVmhC?=
 =?utf-8?B?WG9ONVIydTZOTjJON016RE5sOEo1MkUwWUhQbGlXVElKM2g0TEcrUklBdlFr?=
 =?utf-8?B?bk1XK1AyZWRqUUNPUzNVQ3crR1ZJVncxOSt2SCthcFFZWjlra0VSdGNBOTNJ?=
 =?utf-8?B?NUkrdXNyMGRsSUdWc1psQ1Z4dWVxaVJ2SWhrcXBnOWZHaGJKWDhEZHBUQ0I1?=
 =?utf-8?B?dXlNY3Y3OWpLMG85MFNvbE9oMmk4WmZKRERYZVcxR1hTSUUwaGNYSFU5bWVo?=
 =?utf-8?B?RlpCbFBSSFVnblA4eE1WeitYWjdhWlJiSk9Fc2ZGSXhCWmNMZFJlblRVS1V1?=
 =?utf-8?B?Z3J6eGNEeTY0K2gyS2pRY1d6c2tFa25HcTZsRkQzeUo4dmR1R2FrMHg5Mjl2?=
 =?utf-8?B?TnNKaWtVbzY4aG41UC9rTmNPVUllRDY2SEZkaTMydVFnM0w1aXlLemlGZWVo?=
 =?utf-8?B?aGRzbjVCeitDOEJKRTM1T2lKY095WHErNmlTTVY5V1EyS1hjVVdUMUoxYUFF?=
 =?utf-8?B?N0s4a1I3UHl1bVZLMkFUck9DNFowVkc4bEFObG1jS0daclk5WnRJVmxRbUtE?=
 =?utf-8?B?dEtwS2F4ZEZXSWorRUdqREttenNjYnB6UGxSTm1SRWl6WWJ6TlFOYmwyaGI1?=
 =?utf-8?B?VnB0ckxIZTFiZlJxV1FtYllWNm9mYTlVQzB3NUpvWjFqRlUvTFhVK0JDS0lG?=
 =?utf-8?B?VXBGZVR6VGthMzlVNkttYWFDV01KZWFqZk5rV2RINCtWNjFHZkdBelBLSndl?=
 =?utf-8?B?WkxXNk9sQ2VJbFI2Zlp6VUpKcW00N3pPQkgzNHA2cHorR01odkp6NjNxTzhv?=
 =?utf-8?B?OWdscEx6ZFhFb3BvdUdMNit6ZUlRby9zbkFVT2dCNkNqTTkxUGlPTjZDbFNO?=
 =?utf-8?B?V3AweU9uOW1TY1JuME0vUlhWb0NlZVRJYXE4NUROV2YvZ2J3TGxZQzNUNC9N?=
 =?utf-8?B?VEhWU1JHUmJPdDZMcTdncUI5czVnSGZwUTNHRUhDUGpqbVA5ckRLd3g1by82?=
 =?utf-8?B?VXdyakZnYWlyRld4RWxSQVhMTitrN3Z3ZU1CMjV5N0Q0MmVkYkVZRXVTZ2g5?=
 =?utf-8?B?cjY2NzFmalRsNkxJdEtmU0FiaEJLMklKcnIzQTE2ekhhMkZZUGhuWDhyL0ZG?=
 =?utf-8?B?QmQ2aGhaS3NGcUVrNzIrT09kWmdPcXNrY3VjV0JWMkVGY3dlKytXZWdDdGc3?=
 =?utf-8?B?QklVMVdnZGhmU2xnOXNjWnNrVDZoSzI3NWNoc1A5aXRKNC8wcWdyczdrLzRH?=
 =?utf-8?B?RzAxbmJMUEZUcjdleFgwOS9EZTNLYm9RMzFNU0FuQms2OHJIRUxUbEZMbyto?=
 =?utf-8?B?MENPVkg0RkZoMWIxRnZ4T1lMVm02cjhCbzdRaDVyb3ZSL1JRdnZrSTNYUTRI?=
 =?utf-8?B?YVZVbzZ3UnBWc3B0QmdGcklSWWhrdmxLMFhrZWhEZ2kvWWpmSXZjRW1qSWdE?=
 =?utf-8?B?S0F0b3BZTE9DdzducEpvWWgxSVZibzVDMTBHZGtGUDF6V09qU0JpOFFCRWEz?=
 =?utf-8?B?OWxNN1JiMU5nUENEbUtwcXdPV3l3YlZCbGM2L2lMQXcxN0pNVzc3TFVVcXlX?=
 =?utf-8?B?UVFrUE1FRFB1ejFBQmVYa3h4bXJ4N2xxVGp1OHNnMmZ2L3UvWUNWQVBBZ1pz?=
 =?utf-8?B?V1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6E6E929BB4E3964EBF0FE901BF467B07@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5653.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32a2a748-c791-421b-5428-08daddacc32a
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Dec 2022 08:25:30.4634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: zMcT9bUSRuxFHqYbzmG610qc3UiHO1Ck3Ed4G/55l1rj8WJ3Qs9xZHLl7knD2KPZHO9G44Nhl1YapBXvFzjDsvMyXhg2xzgQGaIyxR8XsVs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB5215
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SEkgTG9pYw0KDQpPbiBUaHUsIDIwMjItMTItMDEgYXQgMTA6NTYgKzAxMDAsIExvaWMgUG91bGFp
biB3cm90ZToNCj4gT24gVGh1LCAyNCBOb3YgMjAyMiBhdCAwODo0NywgPGhhb3poZS5jaGFuZ0Bt
ZWRpYXRlay5jb20+IHdyb3RlOg0KPiA+IA0KPiA+IEZyb206IGhhb3poZSBjaGFuZyA8aGFvemhl
LmNoYW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4gPiB3d2FuX3BvcnRfZm9wc193cml0ZSBpbnB1
dHMgdGhlIFNLQiBwYXJhbWV0ZXIgdG8gdGhlIFRYIGNhbGxiYWNrIG9mDQo+ID4gdGhlIFdXQU4g
ZGV2aWNlIGRyaXZlci4gSG93ZXZlciwgdGhlIFdXQU4gZGV2aWNlIChlLmcuLCB0N3h4KSBtYXkN
Cj4gPiBoYXZlIGFuIE1UVSBsZXNzIHRoYW4gdGhlIHNpemUgb2YgU0tCLCBjYXVzaW5nIHRoZSBU
WCBidWZmZXIgdG8gYmUNCj4gPiBzbGljZWQgYW5kIGNvcGllZCBvbmNlIG1vcmUgaW4gdGhlIFdX
QU4gZGV2aWNlIGRyaXZlci4NCj4gPiANCj4gPiBUaGlzIHBhdGNoIGltcGxlbWVudHMgdGhlIHNs
aWNpbmcgaW4gdGhlIFdXQU4gc3Vic3lzdGVtIGFuZCBnaXZlcw0KPiA+IHRoZSBXV0FOIGRldmlj
ZXMgZHJpdmVyIHRoZSBvcHRpb24gdG8gc2xpY2UoYnkgZnJhZ19sZW4pIG9yIG5vdC4gQnkNCj4g
PiBkb2luZyBzbywgdGhlIGFkZGl0aW9uYWwgbWVtb3J5IGNvcHkgaXMgcmVkdWNlZC4NCj4gPiAN
Cj4gPiBNZWFud2hpbGUsIHRoaXMgcGF0Y2ggZ2l2ZXMgV1dBTiBkZXZpY2VzIGRyaXZlciB0aGUg
b3B0aW9uIHRvDQo+ID4gcmVzZXJ2ZQ0KPiA+IGhlYWRyb29tIGluIGZyYWdtZW50cyBmb3IgdGhl
IGRldmljZS1zcGVjaWZpYyBtZXRhZGF0YS4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBoYW96
aGUgY2hhbmcgPGhhb3poZS5jaGFuZ0BtZWRpYXRlay5jb20+DQo+IA0KPiBSZXZpZXdlZC1ieTog
TG9pYyBQb3VsYWluIDxsb2ljLnBvdWxhaW5AbGluYXJvLm9yZz4NCg0KSSBoYXZlIHN1Ym1pdHRl
ZCBwYXRjaCBWNiB0byBhZGQgYSByZXZpZXdlciwgZG8geW91IGhhdmUgYW55IG90aGVyDQpzdWdn
ZXN0aW9ucyBhYm91dCB0aGUgcGF0Y2g/DQo=
