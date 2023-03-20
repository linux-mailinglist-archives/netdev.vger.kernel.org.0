Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E203F6C1344
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 14:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbjCTN1p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 09:27:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjCTN1e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 09:27:34 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4811E252BD;
        Mon, 20 Mar 2023 06:27:08 -0700 (PDT)
X-UUID: e6b464d6c72211ed91027fb02e0f1d65-20230320
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=kJxJoGbbpNkp5xglrch4HwNqHKQUkIsmJB1qrPwyEYI=;
        b=YiFO/sr/n0zKItmHjFg7z1Gsh/bQHo7a6WwAHzjwt0UrP/tjtPzWu+Py49VVOvSGsOp4ZAi96wTRvLjsScmSgLYHYkdwuQsgpIKSnHfXdN8SWlUwjibifestrf+lUqmso6yJZ2ZKveHLzclZQIU/ORzuPKtVxNl9toW8ifNYAzk=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.22,REQID:5195dbca-4f15-4d1a-ad04-8763c3b06dd4,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:120426c,CLOUDID:0e0a59f6-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-UUID: e6b464d6c72211ed91027fb02e0f1d65-20230320
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 537233598; Mon, 20 Mar 2023 21:27:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 20 Mar 2023 21:27:02 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Mon, 20 Mar 2023 21:27:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g/3ZlcSoiHT/OZZVB6Qj5rqAKXvPdj/kSU/R+aKIPj4RWoR1GdNUEDkkL3wJHDkznT7KfDDwrmMnI3zrGz21KiDRfoPRkTulceI5XzCswn+aogYRgD5oeEwTcuW3y9UkpME3VLSY62lAZg7VS+w7RDfy7M4MYKz0KXTscg32Cw2Hygrvh0Be8zaB5D8s3rCFovOlo64+qixRDZ7U3RXnI0/UViFufelQR+uh4RPv6je1fmbnem/vaa0vJCvsJ1/8TfjT7ViBsdQlNwkkSjQ5UNCZB0jg+jCxmiKcMbqRpEmzUATY+cYdjVNlyqY6xhn5Ibr8MyPWrBm32tZ7lIv6gA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJxJoGbbpNkp5xglrch4HwNqHKQUkIsmJB1qrPwyEYI=;
 b=KUs0E/XAOG1Lq0dMfVmXbbo5u6V/f2MQ2oNhIkNdKYOomCxlBGKeAlKWM4e6BjaIyl5iqR0NCSmBMMW3HcjPfIhnlBb1J+0CUFoIifJJFWkOas5pfJ8gUmM9XA/xzdszEY+Kg6wx5/4s9I1fe8dFRDkuRJ/KBsH0GQdU+80ywJ8W2np7Ais3mjY2tNLyO9aQT+Eqtwr4nR6euyuVLVGw5AYgEPTR/tB1nDPDouuzeu6xk+ULzBtUAptrwekFPbFffUDWJsKxfawqNpUubT3RQUZD91XX30QPlkLR48xgEthiFwYhX9pubLITwMVjoNyXx7UgE3sYSScsHq8I20d61w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kJxJoGbbpNkp5xglrch4HwNqHKQUkIsmJB1qrPwyEYI=;
 b=Xu1p4tI9BayPwEH1k/n3LG9vecpZyYThB/VhEr+bZST4bJRe6t9sj4RTTIRVhnkTPyoNdjkv3Nb1dtsl9T16kKIQq6qUmdYqWQRWEtQCiE0A8aympE5ZtdN4rOPJv6HKVlMCuwsY6kfrsE9FAjTqu0UOYnUnJ3jy5sge2753N9w=
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by SI2PR03MB5194.apcprd03.prod.outlook.com (2603:1096:4:106::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.37; Mon, 20 Mar
 2023 13:26:59 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7%9]) with mapi id 15.20.6178.037; Mon, 20 Mar 2023
 13:26:55 +0000
From:   =?utf-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
To:     "loic.poulain@linaro.org" <loic.poulain@linaro.org>
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
        "kuba@kernel.org" <kuba@kernel.org>,
        =?utf-8?B?QWlkZW4gV2FuZyAo546L5ZKP6bqSKQ==?= 
        <Aiden.Wang@mediatek.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        =?utf-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        =?utf-8?B?R3VvaGFvIFpoYW5nICjlvKDlm73osaop?= 
        <Guohao.Zhang@mediatek.com>,
        =?utf-8?B?RmVsaXggQ2hlbiAo6ZmI6Z2eKQ==?= <Felix.Chen@mediatek.com>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        =?utf-8?B?TWluZ2NodWFuZyBRaWFvICjkuZTmmI7pl68p?= 
        <Mingchuang.Qiao@mediatek.com>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>
Subject: Re: [PATCH net-next v4 01/10] net: wwan: tmi: Add PCIe core
Thread-Topic: [PATCH net-next v4 01/10] net: wwan: tmi: Add PCIe core
Thread-Index: AQHZWKgMNDhZt253pU6OaAPAT5afDq7+6FUAgATFpIA=
Date:   Mon, 20 Mar 2023 13:26:54 +0000
Message-ID: <462e25346631c6f195ccc3d85ea58d4d0da66e86.camel@mediatek.com>
References: <20230317080942.183514-1-yanchao.yang@mediatek.com>
         <20230317080942.183514-2-yanchao.yang@mediatek.com>
         <CAMZdPi9_xYO_MQ0BpxcqDci761uu=ZoczGMg81qkEDeOsP6apw@mail.gmail.com>
In-Reply-To: <CAMZdPi9_xYO_MQ0BpxcqDci761uu=ZoczGMg81qkEDeOsP6apw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|SI2PR03MB5194:EE_
x-ms-office365-filtering-correlation-id: d1f3d60f-98b9-45af-1601-08db2946c600
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: rYZwgYakvLde4nGqUh+D76H+W7iCNgbCsHPLNVD6en9uve5VqtLtCkGJo+1cL8Gogl/JHzaPi7LKY+/s7QY+7/f0ZxWm3bNXjDzzliMWu2IJRE2LWoYHr+K3Kx6T0K3PC7S8PfTrI+h9pV1wi+o2JWCj8hhNBgLKD080xy7eSEbudYSYEdzGGF/+gYnaKQB9LeF4r0/bbJ15bRFi6LaAVj1v5qS9OizjBU7sWjynI8uyJ8ez1QR7RnsSRZ8NrdL9TI/riAB8SYT1nXkxeZSXxBo8I9PbkYOTdhjKltpoYq6rMp67wrYcJ0yrlt07efMlqTIJyJFWdgBGew8a/c2Dm7zXqWi0dBuUmxe16iHcD1sUKr2grOKVSBKdehI3cpIbg4pqmbsLm5LhK9oWKWGYEvzrtyvL6abBXOS4+sKn/lvX0/Gk76up6J0zGls4sNiRUACfVuMwThVsiXCLQu1/05r6eynKRvWL28nNtwqG9Oq3sIc4PNfVFmaTR1LYhf2/kUkKEWayEQMGIt5DWGrkFf6aTzqNiOX2hkj1sO7ziMN3E5oWAkPmR4/XJkNmO8TLPtLBBFyG8tyd0CRrwdtK3vnfCoigzvj863M6k2YL0pgZ2GRy4igrI3auhk7fs7ehUYzb2b6arpTPcHrQNet/OFkl+i0l4BcQUVu7Fuh5eE69chBZE7CQWdXOmIxRn99FaEgFIUDshRWnY0djmpbYyMCNRmKwk8fyDcDDGnl3kSE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(346002)(396003)(39860400002)(376002)(451199018)(38070700005)(2616005)(107886003)(6486002)(6512007)(6506007)(26005)(186003)(71200400001)(38100700002)(122000001)(478600001)(2906002)(86362001)(83380400001)(8676002)(91956017)(316002)(54906003)(66476007)(8936002)(64756008)(4326008)(6916009)(76116006)(5660300002)(7416002)(66446008)(41300700001)(66946007)(66556008)(36756003)(85182001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?K0hXaHM1dCttdFlTN3NpSVd0cTFQUUloR2hYb3FxV3Zud09ucXozcjhPelV5?=
 =?utf-8?B?eWpQbExSRnlIZ21EUytHYVRrY0VFN0Vub3JxSFRHOVVaYUs4dzB3R3YxSENR?=
 =?utf-8?B?RHg0MDhDMXl1bGthOVJiejlsdjdEa3Y3bUR0MXBhS0pQaCtCQTZEOHIrQ0VO?=
 =?utf-8?B?MGZjOVM2NEt4ZGpNNytJRUY2QlRPWk1GSk1nQ0RSODIybERrdktPdldWdnRo?=
 =?utf-8?B?Mmo3VUY0ZmF3d1FZTUlUL3N0YXJqZzYrc1hpR2lVa2V3eXNjak1UTjdwMENW?=
 =?utf-8?B?YUthLys4eFc1elFxNHlwZTRSUGorcXNPVlhMWTljV3R4RzJLbVRDU0tla2lm?=
 =?utf-8?B?Qng1RWpvWUlNTFFHM3dzZ2NrRlV3aUJHcTd0eG5OUU1ISlltbkhKdDU0UERp?=
 =?utf-8?B?RVN4SVRBL1hReVQxSU5KNzVEa3JMM3NYN2I0NjVDT2RQcCt2WDJTYjgyeExo?=
 =?utf-8?B?NEt2L2w5SWtiS29wUzBudmZVcUhrYXA2Wmh5K2JwaEVvOU0wdVFyQ0pyMVNL?=
 =?utf-8?B?eUxiakIwL3hLcEVIT0RNNjE3S25qdWdUOXh6SmZ2YStVdzl0VlRGS2lGSEtW?=
 =?utf-8?B?R0w0Sk5BNWhoanBBQ2hETThIMXlCaVZDeStmdzhGSzRQOWFTZ1JuR0N0OHcv?=
 =?utf-8?B?Zm4wZmo3R1Q2RFozZzI1Uy9OajByMHp5eGdwOWhJZmpqeUs0Y01nZ2RKaDUw?=
 =?utf-8?B?eS9keThtTFlacTNOWUdyc0d0SHdpaDZXYzBieVZFYytRMVRwV0VQZTNobzBT?=
 =?utf-8?B?bG5Ud09QKzNvdmZGMktwSVIrM0tFVXA4bE0xMm5USlNDUXc1dE1od0lYUzQ2?=
 =?utf-8?B?SGJRK1V0cDJkQTIxR2wyUjA5M1gvN3dFdUVOS25sMkFqdkZnK2hMYlBoQTNq?=
 =?utf-8?B?NHFvWVJvYVdYaEtXMnRYK1ZjZlVKZXlMY25OandqdC9hVEVna1R3RU9laFly?=
 =?utf-8?B?djhzdG8xYmlvMitzUDlRMmxCbHlkVkU1eWVhUDhGbXFMSVEyL09GYUI1Ritn?=
 =?utf-8?B?YklXNEIxdHBPb0QyY1Fia0h6ZUlBZjBYMVhxVE8xZnJKWTN4WFdxV1FkL0Uy?=
 =?utf-8?B?eXhtSUJFd2JsdEFoaUR1bHNLNEd1NC8vZ2pIdVdpNTgrT1pzVzMvKy9qa1FD?=
 =?utf-8?B?Sm9NZmFTaTdzQk5ZY3VLcFBrRUJsME40dWFvcGVjQ1pvY2tkSkMveDhMOTlS?=
 =?utf-8?B?Vmh2bEpLSFlRMHZMTzhGVWZoR3VtcUJ4am9MWEpNWk9OdG5GeVdjMjVKTkVz?=
 =?utf-8?B?MlI2S1FMcU9SNFAyNUVKZWtqUCtxMisxZmNsVDhUMXJ5d2FYWUpOZTMvQktH?=
 =?utf-8?B?OE9mcUxZMVV4a1RhR1hwQjZnVWhnL2lPNWxuK29tdmduRnJFVkxIbUo4aGhs?=
 =?utf-8?B?bEpkWTBXNk40a1RXWkwwaXk0aG1zWE55NHBQdXZUUDdFUkFJNGJ1c21xZHBu?=
 =?utf-8?B?VjNNcG1qVmJURUlTWWN6YkhYK3ZhcGNkN0h4NlRpWjhQWnRXTWtoQ3ZHNUpi?=
 =?utf-8?B?a0QzZ0pZYXRsaHhnQWk5Q1gvcGNLYlRQN3VGSVUxRXFJWnpCK2Y4L2hzREZk?=
 =?utf-8?B?bVlSRTJBTzlQb01XZ3QyT05vOTE3RXBGRjZhREl1WVNadXVoRWRDcEJEUWx0?=
 =?utf-8?B?QnZtZU5EcTdUQ1pWYUJrbFNQUEtvTGZqOXQwQy9TeFpEL0REZFlQNXg0d25t?=
 =?utf-8?B?SENCdmtDMG02WXkwODY5TGtoUGVIdVBDR1IycW1ZUFRwQ0QyK3ZaUjFyS2tT?=
 =?utf-8?B?VGFRdXk5QTJRRHlaS09kLzRsMmxyMDJyYzBUdUxWTzB1VHcvclpMOGVoNWNS?=
 =?utf-8?B?ZjVFT1hzNk1QamE5RERpTUoxQmxXTGZRNG5Jd1YyS2hFbndNbklpemhSaHQw?=
 =?utf-8?B?RHB2TXI1TE5ianQ5MjZHTXQxeGdseFNMMlpCOG1ZcGd2ZU1kQjM0clY3K1Zm?=
 =?utf-8?B?Y1A5bTVLU241QmczM0c2YVpIQ3dIZEZ0ZzZXTHA1bXBCNUVUVVh2RU0zU3BY?=
 =?utf-8?B?aXhWSXhTQm1BQjdtMjVtWXhPblVuSFFDR0V4cFhhckswb2l2dm92M0F4UzZr?=
 =?utf-8?B?eFBXUXV5eElpWldiTXhlWkxEK1Nja0s1alN0bTk0KzFnejdiSHNaVkcrY01a?=
 =?utf-8?B?ajJVYzlJVHgwQzROQ2FXOWVYdlo3Uk42UEY2WkJBeHpTQVlJK2FvYUZqOWN3?=
 =?utf-8?B?QlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5F61A4227975F345B0228BF8C3D71B1A@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d1f3d60f-98b9-45af-1601-08db2946c600
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Mar 2023 13:26:54.9244
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: OgBkb7qVz3M5ZzndBxyd3Ll2pn/JHRX5VeWx7rpzuei1NIK5l31KOkWNYQT6Zc7WVVWbxu9w7REF2/ElwW1ywHAEQzXDT5tPYHDETTB+MGI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5194
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

SGkgTG9pYywNCg0KT24gRnJpLCAyMDIzLTAzLTE3IGF0IDEzOjM0ICswMTAwLCBMb2ljIFBvdWxh
aW4gd3JvdGU6DQo+IEhpIFlhbmNoYW8sDQo+IA0KPiBPbiBGcmksIDE3IE1hciAyMDIzIGF0IDA5
OjEwLCBZYW5jaGFvIFlhbmcgPHlhbmNoYW8ueWFuZ0BtZWRpYXRlay5jb20NCj4gPiB3cm90ZToN
Cj4gPiANCj4gPiBSZWdpc3RlcnMgdGhlIFRNSSBkZXZpY2UgZHJpdmVyIHdpdGggdGhlIGtlcm5l
bC4gU2V0IHVwIGFsbCB0aGUNCj4gPiBmdW5kYW1lbnRhbA0KPiA+IGNvbmZpZ3VyYXRpb25zIGZv
ciB0aGUgZGV2aWNlOiBQQ0llIGxheWVyLCBNb2RlbSBIb3N0IENyb3NzIENvcmUNCj4gPiBJbnRl
cmZhY2UNCj4gPiAoTUhDQ0lGKSwgUmVzZXQgR2VuZXJhdGlvbiBVbml0IChSR1UpLCBtb2RlbSBj
b21tb24gY29udHJvbA0KPiA+IG9wZXJhdGlvbnMgYW5kDQo+ID4gYnVpbGQgaW5mcmFzdHJ1Y3R1
cmUuDQo+ID4gDQo+ID4gKiBQQ0llIGxheWVyIGNvZGUgaW1wbGVtZW50cyBkcml2ZXIgcHJvYmUg
YW5kIHJlbW92YWwsIE1TSS1YDQo+ID4gaW50ZXJydXB0DQo+ID4gaW5pdGlhbGl6YXRpb24gYW5k
IGRlLWluaXRpYWxpemF0aW9uLCBhbmQgdGhlIHdheSBvZiByZXNldHRpbmcgdGhlDQo+ID4gZGV2
aWNlLg0KPiA+ICogTUhDQ0lGIHByb3ZpZGVzIGludGVycnVwdCBjaGFubmVscyB0byBjb21tdW5p
Y2F0ZSBldmVudHMgc3VjaCBhcw0KPiA+IGhhbmRzaGFrZSwNCj4gPiBQTSBhbmQgcG9ydCBlbnVt
ZXJhdGlvbi4NCj4gPiAqIFJHVSBwcm92aWRlcyBpbnRlcnJ1cHQgY2hhbm5lbHMgdG8gZ2VuZXJh
dGUgbm90aWZpY2F0aW9ucyBmcm9tDQo+ID4gdGhlIGRldmljZQ0KPiA+IHNvIHRoYXQgdGhlIFRN
SSBkcml2ZXIgY291bGQgZ2V0IHRoZSBkZXZpY2UgcmVzZXQuDQo+ID4gKiBNb2RlbSBjb21tb24g
Y29udHJvbCBvcGVyYXRpb25zIHByb3ZpZGUgdGhlIGJhc2ljIHJlYWQvd3JpdGUNCj4gPiBmdW5j
dGlvbnMgb2YNCj4gPiB0aGUgZGV2aWNlJ3MgaGFyZHdhcmUgcmVnaXN0ZXJzLCBtYXNrL3VubWFz
ay9nZXQvY2xlYXIgZnVuY3Rpb25zIG9mDQo+ID4gdGhlDQo+ID4gZGV2aWNlJ3MgaW50ZXJydXB0
IHJlZ2lzdGVycyBhbmQgaW5xdWlyeSBmdW5jdGlvbnMgb2YgdGhlIGRldmljZSdzDQo+ID4gc3Rh
dHVzLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IFlhbmNoYW8gWWFuZyA8eWFuY2hhby55YW5n
QG1lZGlhdGVrLmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBUaW5nIFdhbmcgPHRpbmcud2FuZ0Bt
ZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3d3YW4vS2NvbmZpZyAgICAg
ICAgICAgICAgICAgfCAgMTQgKw0KPiA+ICBkcml2ZXJzL25ldC93d2FuL01ha2VmaWxlICAgICAg
ICAgICAgICAgIHwgICAxICsNCj4gPiAgZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9NYWtlZmls
ZSAgICAgICB8ICAgOCArDQo+ID4gIGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvbXRrX2Rldi5o
ICAgICAgfCAyMDMgKysrKysrDQo+ID4gIGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvcGNpZS9t
dGtfcGNpLmMgfCA4ODcNCj4gPiArKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICBkcml2ZXJz
L25ldC93d2FuL21lZGlhdGVrL3BjaWUvbXRrX3BjaS5oIHwgMTQ0ICsrKysNCj4gPiAgZHJpdmVy
cy9uZXQvd3dhbi9tZWRpYXRlay9wY2llL210a19yZWcuaCB8ICA2OSArKw0KPiA+ICA3IGZpbGVz
IGNoYW5nZWQsIDEzMjYgaW5zZXJ0aW9ucygrKQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJp
dmVycy9uZXQvd3dhbi9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+ICBjcmVhdGUgbW9kZSAxMDA2NDQg
ZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9tdGtfZGV2LmgNCj4gPiAgY3JlYXRlIG1vZGUgMTAw
NjQ0IGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvcGNpZS9tdGtfcGNpLmMNCj4gPiAgY3JlYXRl
IG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvcGNpZS9tdGtfcGNpLmgNCj4g
PiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvcGNpZS9tdGtf
cmVnLmgNCj4gPiANCj4gDQo+IFsuLi5dDQo+IA0KPiA+ICtzdGF0aWMgaW50IG10a19wY2lfZ2V0
X3ZpcnFfaWQoc3RydWN0IG10a19tZF9kZXYgKm1kZXYsIGludA0KPiA+IGlycV9pZCkNCj4gPiAr
ew0KPiA+ICsgICAgICAgc3RydWN0IHBjaV9kZXYgKnBkZXYgPSB0b19wY2lfZGV2KG1kZXYtPmRl
dik7DQo+ID4gKyAgICAgICBpbnQgbnIgPSAwOw0KPiA+ICsNCj4gPiArICAgICAgIGlmIChwZGV2
LT5tc2l4X2VuYWJsZWQpDQo+ID4gKyAgICAgICAgICAgICAgIG5yID0gaXJxX2lkICUgbWRldi0+
bXNpX252ZWNzOw0KPiA+ICsNCj4gPiArICAgICAgIHJldHVybiBwY2lfaXJxX3ZlY3RvcihwZGV2
LCBucik7DQo+ID4gK30NCj4gPiArDQo+ID4gK3N0YXRpYyBpbnQgbXRrX3BjaV9yZWdpc3Rlcl9p
cnEoc3RydWN0IG10a19tZF9kZXYgKm1kZXYsIGludA0KPiA+IGlycV9pZCwNCj4gPiArICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGludCAoKmlycV9jYikoaW50IGlycV9pZCwgdm9pZA0K
PiA+ICpkYXRhKSwgdm9pZCAqZGF0YSkNCj4gPiArew0KPiA+ICsgICAgICAgc3RydWN0IG10a19w
Y2lfcHJpdiAqcHJpdiA9IG1kZXYtPmh3X3ByaXY7DQo+ID4gKw0KPiA+ICsgICAgICAgaWYgKHVu
bGlrZWx5KChpcnFfaWQgPCAwIHx8IGlycV9pZCA+PSBNVEtfSVJRX0NOVF9NQVgpIHx8DQo+ID4g
IWlycV9jYikpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0KPiA+ICsNCj4g
PiArICAgICAgIGlmIChwcml2LT5pcnFfY2JfbGlzdFtpcnFfaWRdKSB7DQo+ID4gKyAgICAgICAg
ICAgICAgIGRldl9lcnIobWRldi0+ZGV2LA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICJV
bmFibGUgdG8gcmVnaXN0ZXIgaXJxLCBpcnFfaWQ9JWQsIGl0J3MNCj4gPiBhbHJlYWR5IGJlZW4g
cmVnaXN0ZXIgYnkgJXBzLlxuIiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBpcnFfaWQs
IHByaXYtPmlycV9jYl9saXN0W2lycV9pZF0pOw0KPiA+ICsgICAgICAgICAgICAgICByZXR1cm4g
LUVGQVVMVDsNCj4gPiArICAgICAgIH0NCj4gPiArICAgICAgIHByaXYtPmlycV9jYl9saXN0W2ly
cV9pZF0gPSBpcnFfY2I7DQo+ID4gKyAgICAgICBwcml2LT5pcnFfY2JfZGF0YVtpcnFfaWRdID0g
ZGF0YTsNCj4gDQo+IFNvIGl0IGxvb2tzIGxpa2UgeW91IHJlLWltcGxlbWVudCB5b3VyIG93biBp
cnEgY2hpcCBpbnRlcm5hbGx5LiBXaGF0DQo+IGFib3V0IGNyZWF0aW5nIGEgbmV3IGlycS1jaGlw
L2RvbWFpbiBmb3IgdGhpcyAoY2YNCj4gaXJxX2RvbWFpbl9hZGRfc2ltcGxlKT8NCj4gVGhhdCB3
b3VsZCBhbGxvdyB0aGUgY2xpZW50IGNvZGUgdG8gdXNlIHRoZSByZWd1bGFyIGlycSBpbnRlcmZh
Y2UgYW5kDQo+IGhlbHBlcnMNCj4gYW5kIGl0IHNob3VsZCBzaW1wbHkgY29kZSBhbmQgaW1wcm92
ZSBpdHMgZGVidWdnYWJpbGl0eQ0KPiAoL3Byb2MvaXJxLi4uKS4NCldlIHdpbGwgY2hlY2sgaXQg
YW5kIHVwZGF0ZSB5b3UgbGF0ZXIuDQo+IA0KPiBbLi4uXQ0KPiANCj4gPiArc3RhdGljIGludCBt
dGtfbWhjY2lmX3JlZ2lzdGVyX2V2dChzdHJ1Y3QgbXRrX21kX2RldiAqbWRldiwgdTMyDQo+ID4g
Y2hzLA0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgaW50ICgqZXZ0X2Ni
KSh1MzIgc3RhdHVzLCB2b2lkDQo+ID4gKmRhdGEpLCB2b2lkICpkYXRhKQ0KPiA+ICt7DQo+ID4g
KyAgICAgICBzdHJ1Y3QgbXRrX3BjaV9wcml2ICpwcml2ID0gbWRldi0+aHdfcHJpdjsNCj4gPiAr
ICAgICAgIHN0cnVjdCBtdGtfbWhjY2lmX2NiICpjYjsNCj4gPiArICAgICAgIHVuc2lnbmVkIGxv
bmcgZmxhZzsNCj4gPiArICAgICAgIGludCByZXQgPSAwOw0KPiA+ICsNCj4gPiArICAgICAgIGlm
ICghY2hzIHx8ICFldnRfY2IpDQo+ID4gKyAgICAgICAgICAgICAgIHJldHVybiAtRUlOVkFMOw0K
PiA+ICsNCj4gPiArICAgICAgIHNwaW5fbG9ja19pcnFzYXZlKCZwcml2LT5taGNjaWZfbG9jaywg
ZmxhZyk7DQo+IA0KPiBXaHkgc3BpbmxvY2sgaGVyZSBhbmQgbm90IG11dGV4LiBBRkFJVSwgeW91
IGFsd2F5cyB0YWtlIHRoaXMgbG9jayBpbg0KPiBhDQo+IG5vbi1hdG9taWMvcHJvY2VzcyBjb250
ZXh0Lg0KQ3VycmVudGx5LCB0aGUgZnVuY3Rpb24gaXMgb25seSBjYWxsZWQgaW4gdGhlIEZTTSBp
bml0aWFsaXphdGlvbiBhbmQNClBNKHBvd2VyIG1hbmFnZW1lbnQpIGluaXRpYWxpemF0aW9uIHBy
b2Nlc3MuIEJvdGggYXJlIGF0b21pYy4NCk9uIHRoZSBvdGhlciBoYW5kLCB0aGlzIHJlZ2lzdHJh
dGlvbiBmdW5jdGlvbiB3aWxsIG9wZXJhdGUgdGhlIGdsb2JhbA0KdmFyaWFibGVzIOKAnG1oY2Np
Zl9jYl9saXN04oCdLCBidXQgaXQgdGFrZXMgdmVyeSBsaXR0bGUgdGltZS4gU28sIHdlIHRoaW5r
DQpzcGlubG9jayBpcyBwcmVmZXJyZWQuDQoNCj4gDQo+ID4gKyAgICAgICBsaXN0X2Zvcl9lYWNo
X2VudHJ5KGNiLCAmcHJpdi0+bWhjY2lmX2NiX2xpc3QsIGVudHJ5KSB7DQo+ID4gKyAgICAgICAg
ICAgICAgIGlmIChjYi0+Y2hzICYgY2hzKSB7DQo+ID4gKyAgICAgICAgICAgICAgICAgICAgICAg
cmV0ID0gLUVGQVVMVDsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBkZXZfZXJyKG1kZXYt
PmRldiwNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICJVbmFibGUgdG8gcmVn
aXN0ZXIgZXZ0LA0KPiA+IGNocz0weCUwOFgmMHglMDhYIHJlZ2lzdGVyZWRfY2I9JXBzXG4iLA0K
PiA+ICsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2hzLCBjYi0+Y2hzLCBjYi0+ZXZ0
X2NiKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICBnb3RvIGVycjsNCj4gPiArICAgICAg
ICAgICAgICAgfQ0KPiA+ICsgICAgICAgfQ0KPiA+ICsgICAgICAgY2IgPSBkZXZtX2t6YWxsb2Mo
bWRldi0+ZGV2LCBzaXplb2YoKmNiKSwgR0ZQX0FUT01JQyk7DQo+ID4gKyAgICAgICBpZiAoIWNi
KSB7DQo+ID4gKyAgICAgICAgICAgICAgIHJldCA9IC1FTk9NRU07DQo+ID4gKyAgICAgICAgICAg
ICAgIGdvdG8gZXJyOw0KPiA+ICsgICAgICAgfQ0KPiA+ICsgICAgICAgY2ItPmV2dF9jYiA9IGV2
dF9jYjsNCj4gPiArICAgICAgIGNiLT5kYXRhID0gZGF0YTsNCj4gPiArICAgICAgIGNiLT5jaHMg
PSBjaHM7DQo+ID4gKyAgICAgICBsaXN0X2FkZF90YWlsKCZjYi0+ZW50cnksICZwcml2LT5taGNj
aWZfY2JfbGlzdCk7DQo+ID4gKw0KPiA+ICtlcnI6DQo+ID4gKyAgICAgICBzcGluX3VubG9ja19p
cnFyZXN0b3JlKCZwcml2LT5taGNjaWZfbG9jaywgZmxhZyk7DQo+ID4gKw0KPiA+ICsgICAgICAg
cmV0dXJuIHJldDsNCj4gPiArfQ0KPiANCj4gWy4uLl0NCj4gDQo+ID4gKw0KPiA+ICtNT0RVTEVf
TElDRU5TRSgiR1BMIik7DQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3d3YW4vbWVkaWF0
ZWsvcGNpZS9tdGtfcGNpLmgNCj4gPiBiL2RyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvcGNpZS9t
dGtfcGNpLmgNCj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAw
MC4uYjQ4N2NhOWIzMDJlDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2RyaXZlcnMvbmV0
L3d3YW4vbWVkaWF0ZWsvcGNpZS9tdGtfcGNpLmgNCj4gDQo+IFdoeSBhIHNlcGFyYXRlZCBoZWFk
ZXIgZmlsZSwgaXNuJ3QgdGhlIGNvbnRlbnQgKGUuZy4gbXRrX3BjaV9wcml2KQ0KPiB1c2VkIG9u
bHkgZnJvbSBtdGtfcGNpLmM/DQpEbyB5b3UgbWVhbiB0aGF0IHdlIHNob3VsZCBtb3ZlIGFsbCBj
b250ZW50cyBvZiDigJxtdGtfcGNpLmjigJ0gaW50bw0K4oCcbXRrX3BjaS5j4oCdIGRpcmVjdGx5
PyBUaGUg4oCcbXRrX3BjaS5o4oCdIHNlZW1zIHRvIGJlIHJlZHVuZGFudCwgcmlnaHQ/DQoNCj4g
DQo+ID4gQEAgLTAsMCArMSwxNDQgQEANCj4gPiArLyogU1BEWC1MaWNlbnNlLUlkZW50aWZpZXI6
IEJTRC0zLUNsYXVzZS1DbGVhcg0KPiA+ICsgKg0KPiA+ICsgKiBDb3B5cmlnaHQgKGMpIDIwMjIs
IE1lZGlhVGVrIEluYy4NCj4gPiArICovDQo+ID4gKw0KPiA+ICsjaWZuZGVmIF9fTVRLX1BDSV9I
X18NCj4gPiArI2RlZmluZSBfX01US19QQ0lfSF9fDQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGlu
dXgvcGNpLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9zcGlubG9jay5oPg0KPiA+ICsNCj4gPiAr
I2luY2x1ZGUgIi4uL210a19kZXYuaCINCj4gPiArDQo+ID4gK2VudW0gbXRrX2F0cl90eXBlIHsN
Cj4gPiArICAgICAgIEFUUl9QQ0kyQVhJID0gMCwNCj4gPiArICAgICAgIEFUUl9BWEkyUENJDQo+
ID4gK307DQo+IA0KPiBbLi4uXQ0KPiANCj4gUmVnYXJkcywNCj4gTG9pYw0KDQpNYW55IHRoYW5r
cy4NCllhbmNoYW8uWWFuZw0K
