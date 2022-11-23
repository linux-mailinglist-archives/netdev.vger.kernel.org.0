Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B5F635054
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 07:19:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235828AbiKWGSq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 01:18:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235805AbiKWGSS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 01:18:18 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2DD12EF30;
        Tue, 22 Nov 2022 22:18:10 -0800 (PST)
X-UUID: 6b79be3e892d456da4f10cedb7c2cc56-20221123
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=J4krrHbYsjijrfLQYNjQ/uGl6wGYA9i4dsiyQ6JFNbM=;
        b=iJugQURxCkc3k94mTKUOTs7ZX1O5hwLaaDjM0coegrcfcJ/TDb6irbySlllCwbUQhnGwIqImAAugNzPmn5lRVPBqoqtpKizXTIsEohZIanWOX9VdbkzDlO5Dp3dD+Ndj5vFP2eCgekRGvGSS9Vcvs3sxDCwreIRDW3BA4LweK/A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:9fc859d6-99cf-423a-9b2a-cf8f3adb1268,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.12,REQID:9fc859d6-99cf-423a-9b2a-cf8f3adb1268,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:62cd327,CLOUDID:16cb0ff9-3a34-4838-abcf-dfedf9dd068e,B
        ulkID:221122222918DOR05IQG,BulkQuantity:8,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: 6b79be3e892d456da4f10cedb7c2cc56-20221123
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1582957859; Wed, 23 Nov 2022 14:18:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Wed, 23 Nov 2022 14:18:02 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 23 Nov 2022 14:18:01 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aitdWmtg3T1RuJz8IMqpcOQvu6nylSh1faDnoFSqkNnr2w8pBPN+ry9zpeOz+iZTVO2LSRlVeNHObO4PKhSNLgb4T5HiwE4Wc7yRBD+XO8nyN4YMOFWnlrWfJQfIaGpjexRcm4+oM39nY7aiDbbPsQRqAahA6H/eBQyafKS/PUtOl9TAhAyD8IQdynEgks794jtr52j5r8Gfo8S0nUuLuwnbJuVMbeu9zqnLulK+quKVXa7wY0p/QdgGry6q1e+nmeST/vd0/4RTdfpv7x9v3X4b0d4MmP9eU65bw03xMNuQhkeaFDxH4efexdG6Nwd1dlUawj9H/70pA6sOQkfLkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=J4krrHbYsjijrfLQYNjQ/uGl6wGYA9i4dsiyQ6JFNbM=;
 b=oYX5Ws0NbWIQLvTBswcp9HA4prHxXajua77CWzvFfX9QAa8tvAry+EpZWDflFCo379gKA8pn1q43hXaGSmg2tML7F3u5uq739LiidUmUshi8kKeKL9U85sFtFWlSyC0f9S2N5r49JgGRfSMmcOlAPlLXBJk3HDU+Gi9zokh5ew8dZVZIiJy4af+n/Sz2JbFt2P66iEIWh717t3ZU2InEmer2Y0yxXywr7FasDQukvnVtUy1HJZwitAI9XluRjwTWRoBD4gRo9Ze3WY5FpvVkJhqxsE3y/Uxr0efQAitRFVBthslY/RWqhZ+oe+chMZKvkRcovD0Pun5ZeB/xkBOI1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J4krrHbYsjijrfLQYNjQ/uGl6wGYA9i4dsiyQ6JFNbM=;
 b=TGRrmLtnixXs5hK8PEDSs754mAu9njXU2Hw/8o5YZGccNYePEb/GT2cbHDDvLSnMfrv0p6iaXovMahukJI4XUtuPSzirXn4E8/9knVxhQi+ZxzIwCCsvSF7jt99vCCdTDCtw5GXmacmkqFV/UOt3w/Rav9JVGWYAhsUj4X42/BM=
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by PUZPR03MB7211.apcprd03.prod.outlook.com (2603:1096:301:11f::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Wed, 23 Nov
 2022 06:18:00 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::99dd:4e25:7157:760c]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::99dd:4e25:7157:760c%8]) with mapi id 15.20.5834.015; Wed, 23 Nov 2022
 06:18:00 +0000
From:   =?utf-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
To:     "leon@kernel.org" <leon@kernel.org>
CC:     =?utf-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        =?utf-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        =?utf-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        "linuxwwan@mediatek.com" <linuxwwan@mediatek.com>,
        =?utf-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?utf-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?utf-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
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
        <Guohao.Zhang@mediatek.com>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>
Subject: Re: [PATCH net-next v1 13/13] net: wwan: tmi: Add maintainers and
 documentation
Thread-Topic: [PATCH net-next v1 13/13] net: wwan: tmi: Add maintainers and
 documentation
Thread-Index: AQHY/mV4v2glGCZftk2iwIMCmGYmsa5LAMQAgAEJGYA=
Date:   Wed, 23 Nov 2022 06:18:00 +0000
Message-ID: <56217abcbe9433520ee8f1f67085c1a83d29a231.camel@mediatek.com>
References: <20221122112710.161020-1-yanchao.yang@mediatek.com>
         <Y3zctKXWaVuGvGhP@unreal>
In-Reply-To: <Y3zctKXWaVuGvGhP@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|PUZPR03MB7211:EE_
x-ms-office365-filtering-correlation-id: bc679869-75a5-4bfe-668e-08dacd1a78a4
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eIuTD5dP8K2rzNaQ21sROtdb8VgH+kH9ajSwHOLvQM/SvMbJVnD+KPgGPLYPJA+GgfIRLo0e980zvVZwgQ+9ER9TaBz/ly4uCIWsQWbxY6b4e43Mih/Q9+I+zhqS6cIGX1gYErnhRuckE6QTkMtgLaFTFSY/tiS5aRdRVvuTp8cPKifW032ZKpwyr9in1ty0F7mAZwnIn+VTWKocFrnCG9QJzbSMxr+dCg3AWHnLEIicsCIv/b7clEsdS5pQSpzTwlrljCzNCqA62hnnuErfHOpVWZz8ZA+0d+CwJV17wEg/LSMmsCQALmWeHZaow7esGkUjAI0k9sGqUt0pUItbvJ+Qon/amJV8RqsdJulW4FaWAnglq7+9GJasBPdNd/2DXwu0xTkeUkDN8Cxg7KetwPV3wvLIPoizOdwcvtsmXMupHsb9Fc8SdBtYeuKbNUbS/RLVUAH/OWQU1u3WLCwMq2w10EGtRO14a2+FUq1WMxL1EwIfa+sHjXpTR7bATmPVrwzwuJ378Bjxnk997EsHP6DFQP1FWcrfqsgSphE1kV8SPfbzA+TgQ6qX17nTUnVCX1B02wLFCZyB3k2tIgqSn0SeE4QO6VPYjgfX1PNkigyBObLo4UezzTDNO6KOyxsByWMVVsUyiQpvfnnpIIC1GzI7N2yYeGBiLgw4h/gW2Zy7OiujKXQriva5zvAauc4WuEJkuWqZEvCMgUoFMg4tQcPWotGnLcyimTvpGe89r9E=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(136003)(366004)(396003)(376002)(39860400002)(451199015)(5660300002)(26005)(8936002)(86362001)(6512007)(4001150100001)(107886003)(2906002)(36756003)(71200400001)(6506007)(2616005)(7416002)(38100700002)(85182001)(4744005)(478600001)(122000001)(6486002)(186003)(316002)(66946007)(66446008)(66476007)(4326008)(8676002)(76116006)(64756008)(66556008)(41300700001)(38070700005)(54906003)(6916009)(91956017)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MU1OYWVuUTM0UVRPQVQ2Zk9XVzBFOEJtOUw0eEFzTklIdlVycHROTzRXak4z?=
 =?utf-8?B?VWYvVDV5UDl2eGcrYVgwQUZYanlFcERuenRHQTZqSWZyaFFlZWpucWx6QWZW?=
 =?utf-8?B?RGVIVHlrb1hCYUNDYkwweEVRbWxuMkpJSitqZ3dCbWJTQ1B3eTBzQzdaRllH?=
 =?utf-8?B?MStESWVhb09iRWE4QWZxaGkrYUxxc3UvdjRKbE8wNk56UzJ3Zm8ySnBJOVQ4?=
 =?utf-8?B?UlFHWkRRN2tELzJyd0k4eWlUVlpzL3BaOEVDdnhycFJNR0JCL3ZNSk1JRyt2?=
 =?utf-8?B?UFdGQjJzMzl1K3pYVVdVcFZ3a1hlSlcwZGEzaW9FaFQ0VkNya096eHV0TDZj?=
 =?utf-8?B?alFJeG1ySlFLSWQ0ZUhpSlpnZUhvSlJ0SmNpeDZoMWljVlJWdHFMcitHNXQw?=
 =?utf-8?B?NGNUUzB3WmNDTVZ6dUc5TFlVNXpSd1pseGFNZU5kTzZVYUlCdnFQTThWQWZW?=
 =?utf-8?B?Sng2UFpxN2xnM2d3QXlFbm1LNTM0Zk1lbEtXdllvbXRLQ2lub1FHa1RJRC8v?=
 =?utf-8?B?SlI4SXo4NEJpUUp2a1U2emdTTmVCVXNxRjRTZjQ5WGk1RlM0RUhobmw1V1hH?=
 =?utf-8?B?MldJUjFwRWs3dmE5K1N0K2ZOeDV1MFd5ZzNZc1FkMUdHQ1JSanljd0VTbGNp?=
 =?utf-8?B?amhCN1o5OW1IRjcrQjUzZDk0TEU5SERFZlNNcFNzSVp0cjJtanhMY01VMHNt?=
 =?utf-8?B?czFEazlReW95WSt0d2lSTXZTakJ4L3MwUkF2US9jVTBZWjJaUHozaVJIQVhQ?=
 =?utf-8?B?MnpFZUZ6cCtMb1dXZTkvdGFiV2NicmluQVlTMVZTUU9NQndtVHZmOVdqRmhz?=
 =?utf-8?B?M1hIREdZVEJobFJTZDBWTHAzS1lWSitxOUoxSmpQUkhIcU5qdUJKSzJQMDVa?=
 =?utf-8?B?cmh4cmFWdXN0UTN6TmxIckRENUxaS2hBNnRSUFVtckx1TGJ3MzFOTWYzSDVj?=
 =?utf-8?B?TFdiaFlNVUp0UElTQjhickU2OVErRXNzZFJTaWU3YWYvc25FYnM4amJMeE5X?=
 =?utf-8?B?VVNvNTFHdXlKZjJ3S3FzZTBMWkxEY21GOUliZHdLclFvd09YM0UxVWNMZWE4?=
 =?utf-8?B?Y21Id2hqeWI4ajc5NnI3byt3VTZnTmYzcVM5OVFZVDd1U2p1OHhEN3JVcGZ0?=
 =?utf-8?B?dm1seXEyZGI1NjdLS1BrZkNyZ1MzYVNYYS9QUWZmOTlkdWczdXRDR3VKd2hF?=
 =?utf-8?B?dmVCMTh2OUh1SkJSTGlFVWFUbGovL0lkYlFJTjJpMEJIekhVc0dmV09RVDhn?=
 =?utf-8?B?NjNmMnVvRDYrZXhhczR6ODRJdFFoRGcvcmgrbXNDWlFVR2dEVTRrRFIxRksw?=
 =?utf-8?B?L2xqczROQ1dzbS9qd0hZVXhoTjg4R1VYTEpmOURMcVdZN2NaVlJQMXZITnEz?=
 =?utf-8?B?TUliZnZDTS9lTjEvYUh3SmhkN1diaUpqVGllZFF6QlYvQ0I5eDVZck9aajhX?=
 =?utf-8?B?bkdCenVrRVpCY0w0QWt6K2lLajdFOHAzbVdrcTBITWUxdnBWeFNyd3k4UWo0?=
 =?utf-8?B?U3U4eEsxaUJjZFpnZWU4Z1BReXFqa1R2NzIwUzByemd1dHR0Vi9CUnM5Uk9S?=
 =?utf-8?B?allyTWQwWG1YTDFtcmMxcFdWMGhrZzI5NVNSZFZNa3lvNVg3RjRIN3JNUkM3?=
 =?utf-8?B?WTY2c3dQSWp6UVpabm9mUUhnWWoyb1BEaGJUTk1iREJ4d2dxWWdwNVRmZmJ3?=
 =?utf-8?B?WHJ0NUd1cWJGMjhvOHNheExxQktxeFNaWlpYZnB4aEk4dDR6SjYrQlJnVEM2?=
 =?utf-8?B?amtvZ2pyUTJRcXRXQVNlSldKN2lGN1A1aW14RDd2aS9wTVptN1ZWWnFCamVT?=
 =?utf-8?B?bldScmcwU1lXcUxiMVRqcm02ZVlzL2JOR3dCZnYyakdBQnhSNHlSbDRzbnVv?=
 =?utf-8?B?UXIvWmZ1T0VmSU05VzZhY0lpQ05UWXY3T0I2ZzJxYkFaWkxYVnFSa3NoS1NG?=
 =?utf-8?B?MXpCbENiS2Z3UkpFSUtoSUhrY0dZM3hoUldkN0tHSjc3MVVGMWIwc3NzL2o1?=
 =?utf-8?B?cnF4ZDdoZDZ1WnFPMGthTm9PWUxhRzUzemZtdG5JVkZFd1dhb3Y2Tlc0dW5n?=
 =?utf-8?B?bHBiQjJjSStMUVFFdktIOVF5QU9SV0MwL3BraXNLTlJzM2d3QUJ2ZTlnNEZD?=
 =?utf-8?B?a0xMNmtSQmFiWnZ5WlU5ODh4MXJ5Y3pxYzdQSTdqUHAvTWlWNjU3MkQ5b2FQ?=
 =?utf-8?B?aHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A1A48311D830BF49BD7586BE656338CD@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bc679869-75a5-4bfe-668e-08dacd1a78a4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Nov 2022 06:18:00.2605
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: fuuKgFgbUVE/PAgEs6yj9+Of+OYJhemoLtjF5/yvQ3MBWFL2Uu/7QE57BGHZ5NgvlruzT8ktzrBNRAv8QxV2lFzgGkS0EPKzRgf1fY6ibW4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7211
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

T24gVHVlLCAyMDIyLTExLTIyIGF0IDE2OjI5ICswMjAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgTm92IDIyLCAyMDIyIGF0IDA3OjI3OjEwUE0gKzA4MDAsIFlhbmNoYW8gWWFu
ZyB3cm90ZToNCj4gPiBGcm9tOiBNZWRpYVRlayBDb3Jwb3JhdGlvbiA8bGludXh3d2FuQG1lZGlh
dGVrLmNvbT4NCj4gPiANCj4gPiBBZGRzIG1haW50YWluZXJzIGFuZCBkb2N1bWVudGF0aW9uIGZv
ciBNZWRpYVRlayBUTUkgNUcgV1dBTiBtb2RlbQ0KPiA+IGRldmljZSBkcml2ZXIuDQo+ID4gDQo+
ID4gU2lnbmVkLW9mZi1ieTogRmVsaXggQ2hlbiA8ZmVsaXguY2hlbkBtZWRpYXRlay5jb20+DQo+
ID4gU2lnbmVkLW9mZi1ieTogTWVkaWFUZWsgQ29ycG9yYXRpb24gPGxpbnV4d3dhbkBtZWRpYXRl
ay5jb20+DQo+IA0KPiBBdXRob3IgYW5kIFNPQiBzaG91bGQgaGF2ZSByZWFsIG5hbWVzIGFuZCBj
YW4ndCBiZSBjb21wYW55Lg0KPiANCj4gVGhhbmtzDQoNClRoYW5rIHlvdXIgc3VnZ2VzdGlvbi4g
Zml4IGl0IG5leHQgdmVyc2lvbigxLiByZW1vdmUgU09CIGNvbXBhbnkncw0KbmFtZTsgMi4gYWRk
IGF1dGhvdXIgbmFtZSwgZXg6ICBGcm9tOiBNZWRpYVRlayBDb3Jwb3JhdGlvbiA8DQpsaW51eHd3
YW5AbWVkaWF0ZWsuY29tPiAtLT4gRnJvbTogWWFuY2hhbyBZYW5nIDwNCnlhbmNoYW8ueWFuZ0Bt
ZWRpYXRlay5jb20+KQ0KDQpNYW55IHRoYW5rcy4NCg==
