Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A96E76410F1
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 23:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234815AbiLBW4f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 17:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234041AbiLBW4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 17:56:33 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90323E2547;
        Fri,  2 Dec 2022 14:56:29 -0800 (PST)
X-UUID: 52e9cc934c474574b61e387cc13c705b-20221203
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=m+1aKpWzOGz+hrfxZQ872EjCpj6uogsLGePWtpvvxE4=;
        b=ieMN3SYq0L119iDq4tmsI2XGaAuJYOmEeL+CDQG1SpMHAvIuBKZe57R77znnm1AFwUBbgevE9wdgmEGy27sMAAmAKyXsUJWUczMhSlWZnk6SxgJvskEEn/IR9Ia56lN28xvYbhxWS7xazbBfczqNJ0GDPtBj/MeVKRuEULeVoQI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.14,REQID:b24ef7d0-6c1e-49b3-a707-219001d633aa,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.14,REQID:b24ef7d0-6c1e-49b3-a707-219001d633aa,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:dcaaed0,CLOUDID:61b38830-2938-482e-aafd-98d66723b8a9,B
        ulkID:221203065626A3XV88X6,BulkQuantity:1,Recheck:0,SF:38|17|19|102,TC:nil
        ,Content:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:40,QS:nil,BEC:nil,COL:0
X-UUID: 52e9cc934c474574b61e387cc13c705b-20221203
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <ryder.lee@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 1750462147; Sat, 03 Dec 2022 06:56:24 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Sat, 3 Dec 2022 06:56:22 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Sat, 3 Dec 2022 06:56:22 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EfJe1ylcJZKCLLTDAwLXTKwgYTJOMFnz5ME5hzlteSoFUEI/svbNW/YOElWUJG/MiygRti6neyRXNCwrqZVo0GSxKmjPyWgCfjvq/e1pZhwLufcLYFz5yO7RvMADrTGWe72brFXQQwg3p2+GAjrmNypr7m98h3WO2UqwnxMISTAkRkf7Hs3yl4wfs7c5Glc16Lr0fQoeKPQ196Qqzx6RelFGGcN3QNk0G7Ii+VDAF5as0mlHtfuMo5uoqfJS6dy3i7QYltSKZpuAefsKI8ng/DTmCirlo3ekTX/sN/Psjn7C+pBnm6IUbcjCNy4/PbxAX3oHXEZ35QDOiy2LwHunrg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=m+1aKpWzOGz+hrfxZQ872EjCpj6uogsLGePWtpvvxE4=;
 b=f2CwJonWZnGS53OguNedK5sRijf3o8lN8MliRe0ktM6BATTS6VNKo0qM9SQYtIoZa50X0dXkavBlLRuGYOWXG7FyMtYaHMewIpUoZhuxU4BFjz3wcdnneLR5x8egTa7KsQZJAxuP7wShDxW/ibucyyXD2CGGGE28KWP3jZri+sPNdZQjkvewpvwLHv+i+hf7CPOzV3J5RgaybvRUjW4TU0wRBNYQvn6k/MMite85CgIEattWv4RCmnC7vgLbSifjN3RIuBGof7cB4occ4mZtyMsaTJTdvKtA5rwJEuhJujkz/Qjs0S6eTYiozOBNg8meKKoTKbiHUZo+wXQ8e2lMSQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=m+1aKpWzOGz+hrfxZQ872EjCpj6uogsLGePWtpvvxE4=;
 b=dOXxoZEjSp/S4tTQPULMwNR80awq2otKeK1zXDwX8KGSdZtHWkSPo+4vSNM0Z1trq/OWSEepp1f1qJhiRX9+X9d7H4oRCrT+Fja/7Bwg/1xIkX9SKpvEotae7YXgTOjzNbfekY2PwT7Ho/LX32D6wo+VvRsW4+qacy/IyiZjzaE=
Received: from TY0PR03MB6354.apcprd03.prod.outlook.com (2603:1096:400:14a::9)
 by PUZPR03MB7210.apcprd03.prod.outlook.com (2603:1096:301:119::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Fri, 2 Dec
 2022 22:56:20 +0000
Received: from TY0PR03MB6354.apcprd03.prod.outlook.com
 ([fe80::320d:30ac:41ac:b1a3]) by TY0PR03MB6354.apcprd03.prod.outlook.com
 ([fe80::320d:30ac:41ac:b1a3%5]) with mapi id 15.20.5880.010; Fri, 2 Dec 2022
 22:56:20 +0000
From:   Ryder Lee <Ryder.Lee@mediatek.com>
To:     "keescook@chromium.org" <keescook@chromium.org>,
        =?utf-8?B?Qm8gSmlhbyAo54Sm5rOiKQ==?= <Bo.Jiao@mediatek.com>
CC:     =?utf-8?B?TWVpQ2hpYSBDaGl1ICjpgrHnvo7lmIkp?= 
        <MeiChia.Chiu@mediatek.com>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>,
        =?utf-8?B?U2hheW5lIENoZW4gKOmZs+i7kuS4nik=?= 
        <Shayne.Chen@mediatek.com>, "nbd@nbd.name" <nbd@nbd.name>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Sean Wang <Sean.Wang@mediatek.com>,
        "kvalo@kernel.org" <kvalo@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        =?utf-8?B?U3VqdWFuIENoZW4gKOmZiOe0oOWonyk=?= 
        <Sujuan.Chen@mediatek.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Coverity: mt7915_mcu_get_chan_mib_info(): Memory - illegal
 accesses
Thread-Topic: Coverity: mt7915_mcu_get_chan_mib_info(): Memory - illegal
 accesses
Thread-Index: AQHZBp97nbgv/Go0Rk6e4OypxWDzN65bNVOA
Date:   Fri, 2 Dec 2022 22:56:19 +0000
Message-ID: <1a16599dd5e4eed86bae112a232a3599af43a5f2.camel@mediatek.com>
References: <202212021424.34C0F695E4@keescook>
In-Reply-To: <202212021424.34C0F695E4@keescook>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TY0PR03MB6354:EE_|PUZPR03MB7210:EE_
x-ms-office365-filtering-correlation-id: 4b4aba9e-e396-4963-a026-08dad4b86d4f
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Wdu8qeOyYxjLrzwxdqcZ8iH94s9pHVyd2rc7dwotCKfFgleGhOZHay1xRusltqzrv0WYe2pHnsJz/60SoQi2Z9e8vtjYjPQ+ZlhGBcRtDgc2xMJTYqeAilY6ijifEXD1aNUB1mgR+9SUv5xZhXtxjHKuWzXN6FZrcgvfqvN7DPnMdzFeVQiQUen7dTlYuKySUD/uVf3aSgP8/yiurA/onmyNYFRoq2yyuo4d/+h3fejXspGzJOaoBMXmIaoVD8/m2stOvT8bgIhdnv23OkGV/vOA2uUzVqEuMHSzjyeKTXPHEGScl0UHr+BHyB+I5Vzihs67sW5yizfE6Odd0CLySjPLpQ5iDCmg2lZGDUom/7fX9qh1Qzp1oEP3pVELhs0yEzdROnKY2vNOD4z1qRjCoo4t1OZAUEAoPu+JEUJZOSk+Tqs6gyFDgDvhk7S4iRHLtsgMIOUY7L96sDYoNX2uYAch4Cu4+LX+iDrcLG2TIf7POj/+w1+Y8Ekdq5mcZu8qdHPFWmrINUgwQgV1+z7vWSQQi1IQQY9mXfoERIQ4cOTe/Z+CJYYZCIYU93ZNKXk+e7nN3yxhMFTqfWKxTBENQcmcYXK+5xwMdmvquKXCTZDA9ax5dzdOu26DkWBfRrUifiC570gE8TlLILETeWeKaSQKlX04zJ7sO1KrrOkyqU9EBGV2hDEyedm6v9fiCZH8yJr06GNLbtJWrPJScE+NGyFbC03oOLig+39gaBKo2P9Xjfz5ZR1ZBWEWMU1qDbfvD22XjNaQI8HVnH9zIxkFd7DDNH/byoR+sHTOh7zeXpY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY0PR03MB6354.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(136003)(396003)(346002)(39860400002)(376002)(451199015)(66556008)(86362001)(4326008)(2616005)(76116006)(966005)(36756003)(91956017)(66946007)(41300700001)(186003)(122000001)(5660300002)(7416002)(71200400001)(66476007)(66446008)(6506007)(316002)(8676002)(478600001)(6486002)(8936002)(6512007)(54906003)(6636002)(38100700002)(26005)(38070700005)(110136005)(64756008)(83380400001)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?dC9ObmJ1Sm9pZlI5OTRERTk0djVQcjhGVVVlVTRSSUMzUWgwNk1iQ2wxUGJ4?=
 =?utf-8?B?bVQ5a1FBOGYyTTRkenVHWitwMGJRcjlGSVNuUDllVVJ6Z040YlRvUE5uaWMv?=
 =?utf-8?B?Tkh4K2hHWktCNEV3OFB3ZmEweklxNG8zNTdKdmNkdWVwTVNuZkNUWlRlVGhB?=
 =?utf-8?B?ZWd3NThzQVBMUi9wODZRN1NKNFphem9taVdTUW01ZnlCQi9hK3dyUEdXUmVm?=
 =?utf-8?B?OGFQeDJxZXhZaHZzckJiZnJjTVVFN3FLcVNnZU1wZ016V3pMc3F5YUtEN1Vm?=
 =?utf-8?B?YTBobk1TWTA0WGhCb2VwYUd5L1VyN0Z6SHl6M2ZGNWYvKy9TczkzSS9FRHVr?=
 =?utf-8?B?My9saFQzamR4NGJweUhMTFhXU2Ixd2htN1p1Zmc0cEV2K1pob3NlVktsSHNS?=
 =?utf-8?B?N0IzZkYrQjNFd1JQdkJyNGVMc3ArempHMWIwcTRRTmNuVVRRa05Jek5tY3Zz?=
 =?utf-8?B?aEY0eXVWNXdZb01waWpwVFZXZU00QW9LY1F6eEZjZjRUM3VBcGZ0aUZuWG5n?=
 =?utf-8?B?MW9LWklxMU9aRE8wMml5TFc3Vk9ORTRTN2ZpTk9Ub21LUGVkOXVTeXFRY1pa?=
 =?utf-8?B?bGFWM2ludFpCckhuV3JYNmZKdFZOUlkvUksxSXVOZWdCRHNIOG02SHRFU1Vx?=
 =?utf-8?B?T3F0NSsrSHJTcFZVa0pEdmZuSDNIdmFiem5sZDNEa0VTZE82cFUvOFg3azZV?=
 =?utf-8?B?Y050RSsySFB3TGl1czVvekJDZXM1ekZuSHhmSHRORUlYelVMc0ZGTks3dGpy?=
 =?utf-8?B?blRzcHpvYWZjUzJZNlZJOHFMUEdkbUJQUnpiUVhnK1RlRTA2cXlIZUpDR2Ex?=
 =?utf-8?B?dXhkaUtNb0VLUUV5RWpxTnJrdDU1cS9MUDBjNmM1cklyenBvb2V3QTdDVnNy?=
 =?utf-8?B?cG5ZcVVJMVpvWXhCTnpnVzBHaFdLZXBrWGU1RzAxVzFlcTZlcUVCZk9XUTRz?=
 =?utf-8?B?QmlhYUdUakVNT0RHZUtFMFlvNlU0aGx3dmkxUlJVcE9nbWYvRkNZWkZzSEli?=
 =?utf-8?B?M04zbjEyYWFLK09nV1RheEFWMjBSQ3V3QS9td1dUSnhCRkJOanZwbFQ3TVN4?=
 =?utf-8?B?SGJ5TVF4M1JCSm1wWi8vMEJTdHlnWWV2alFiWHVJaElvckdzVksvdzdCaC9o?=
 =?utf-8?B?d2VXaVZ5N0F4ZnpBeExaUXQ0RmV3RTMxQ0FJSy9vUHMxZjU5eEJONmNkMmFF?=
 =?utf-8?B?R2ZTTTJxRzlCNHN0QnVxeEFtT2h2cFRSNVdOUXEvR1dPZHlrK0xMTkNvanVq?=
 =?utf-8?B?WkpaMGl2L3NRdkVLdS9YSU9HdVl1MTgyaHdkbUlPbmJnblE5YndmT3hBUWtz?=
 =?utf-8?B?aStRbmFVcWRmNlY1clhzTDJ5aVE4Q3F6NFQ2T1p2c09IZmkxaFRSR2o0OHZ1?=
 =?utf-8?B?NXptaS95dGthYmlXZ2I0cWlGSmJmaUt6dS8vdkl2ZXpaTmk1cHFEU1ZHS1Jx?=
 =?utf-8?B?UmlIWXlFV0xnVGxKaUpGUm1BOC9oODVackMxWVNscGVycUFtNHQwM0NudlZ3?=
 =?utf-8?B?NzN2MkExUU9GTU5QTkx6NTM5eCszT0oyTUZSeTZFQ09lSGV1VzZPV1dtWTZJ?=
 =?utf-8?B?eS8rdVJyZG1LaVlxcHF6MDVVS292allidnArRWhrVVRhdjdVdnFMa3JhbHdC?=
 =?utf-8?B?Mkg0Sy9jNDlWdnQ4dG1JRlgzai9jOUxZQndNSjU0b0taVnlEcXp0L2taajZ5?=
 =?utf-8?B?MkV6eXRVcXEwSWRQMnJjQmx5ZnNQL1FiQ3RzL1pvNHFuOGROTHJ5dGFOWCtC?=
 =?utf-8?B?RTFMNXhNcDdqMmhRTTVaLzBQZy9rN0kwczZjcUwwSitmMUhvWnB1LzE5WnRO?=
 =?utf-8?B?a2RBMi8xVHU2SVhKait3MHJGSzJULzFTMW1KRjdKOHVxb1ZEZ0hZeVNwOW5C?=
 =?utf-8?B?SGo2SmJvQ3dtYm0rV2RjZGg3aHFDeUU3T1FFdHZmbGphRitjZzlzY251azFz?=
 =?utf-8?B?Qm5NUE5sUVdFTjlJcUVNczZabnpWOTF1ekk5TUVMUUMyeEFsMGdaOEh0bmJ4?=
 =?utf-8?B?ekZaZmxEaENDTlorSTFFdjFUd2h3VWJrQllrdDVCQ0t5eHpvOUErcklhVXBJ?=
 =?utf-8?B?Q0pZa3F0Ym1mdlVuZENYRHBFbUJUaVRtallieS92Qy9kK3NSM0l3cFBLOXNh?=
 =?utf-8?B?cjdwUlFaTzJFZFlMblIwOCt4MWRmSVlwUEFPSWpzQmI1bkc1SSs1NU5pVjA1?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EC13E8F764D94544A858DA110FE10713@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY0PR03MB6354.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4b4aba9e-e396-4963-a026-08dad4b86d4f
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2022 22:56:19.9196
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oMSS4w4w0hZ9o+k5GCBwDwj6F/oa1cLgzw8P1umkI7qNW1vVD5CokYdVvW6wFflJ491xtk3de7+imbGRWlMV2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PUZPR03MB7210
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIyLTEyLTAyIGF0IDE0OjI0IC0wODAwLCBjb3Zlcml0eS1ib3Qgd3JvdGU6DQo+
IEhlbGxvIQ0KPiANCj4gVGhpcyBpcyBhbiBleHBlcmltZW50YWwgc2VtaS1hdXRvbWF0ZWQgcmVw
b3J0IGFib3V0IGlzc3VlcyBkZXRlY3RlZA0KPiBieQ0KPiBDb3Zlcml0eSBmcm9tIGEgc2NhbiBv
ZiBuZXh0LTIwMjIxMjAyIGFzIHBhcnQgb2YgdGhlIGxpbnV4LW5leHQgc2Nhbg0KPiBwcm9qZWN0
Og0KPiANCmh0dHBzOi8vdXJsZGVmZW5zZS5jb20vdjMvX19odHRwczovL3NjYW4uY292ZXJpdHku
Y29tL3Byb2plY3RzL2xpbnV4LW5leHQtd2Vla2x5LXNjYW5fXzshIUNUUk5LQTl3TWcwQVJidyFq
N2pfQzBLcE80VkQyeU1Pb2R2cGVJZXhUR3E0Zmh5MnlxNm5va051YTl1NExUb2lVT0xrNG91OEpG
Rk5yWGtyaDgwZDVCSzJrNDRmYVJRc3RIRTkkwqANCj4gIA0KPiANCj4gWW91J3JlIGdldHRpbmcg
dGhpcyBlbWFpbCBiZWNhdXNlIHlvdSB3ZXJlIGFzc29jaWF0ZWQgd2l0aCB0aGUNCj4gaWRlbnRp
ZmllZA0KPiBsaW5lcyBvZiBjb2RlIChub3RlZCBiZWxvdykgdGhhdCB3ZXJlIHRvdWNoZWQgYnkg
Y29tbWl0czoNCj4gDQo+ICAgVGh1IEZlYiAzIDEzOjU3OjU2IDIwMjIgKzAxMDANCj4gICAgIDQx
N2E0NTM0ZDIyMyAoIm10NzY6IG10NzkxNTogdXBkYXRlIG10NzkxNV9jaGFuX21pYl9vZmZzIGZv
cg0KPiBtdDc5MTYiKQ0KPiANCj4gQ292ZXJpdHkgcmVwb3J0ZWQgdGhlIGZvbGxvd2luZzoNCj4g
DQo+ICoqKiBDSUQgMTUyNzgwMTogIE1lbW9yeSAtIGlsbGVnYWwgYWNjZXNzZXMgIChPVkVSUlVO
KQ0KPiBkcml2ZXJzL25ldC93aXJlbGVzcy9tZWRpYXRlay9tdDc2L210NzkxNS9tY3UuYzozMDA1
IGluDQo+IG10NzkxNV9tY3VfZ2V0X2NoYW5fbWliX2luZm8oKQ0KPiAyOTk5ICAgICAJCXN0YXJ0
ID0gNTsNCj4gMzAwMCAgICAgCQlvZnMgPSAwOw0KPiAzMDAxICAgICAJfQ0KPiAzMDAyDQo+IDMw
MDMgICAgIAlmb3IgKGkgPSAwOyBpIDwgNTsgaSsrKSB7DQo+IDMwMDQgICAgIAkJcmVxW2ldLmJh
bmQgPSBjcHVfdG9fbGUzMihwaHktPm10NzYtPmJhbmRfaWR4KTsNCj4gdnZ2ICAgICBDSUQgMTUy
NzgwMTogIE1lbW9yeSAtIGlsbGVnYWwgYWNjZXNzZXMgIChPVkVSUlVOKQ0KPiB2dnYgICAgIE92
ZXJydW5uaW5nIGFycmF5ICJvZmZzIiBvZiA5IDQtYnl0ZSBlbGVtZW50cyBhdCBlbGVtZW50DQo+
IGluZGV4IDkgKGJ5dGUgb2Zmc2V0IDM5KSB1c2luZyBpbmRleCAiaSArIHN0YXJ0IiAod2hpY2gg
ZXZhbHVhdGVzIHRvDQo+IDkpLg0KPiAzMDA1ICAgICAJCXJlcVtpXS5vZmZzID0gY3B1X3RvX2xl
MzIob2Zmc1tpICsgc3RhcnRdKTsNCj4gMzAwNg0KPiAzMDA3ICAgICAJCWlmICghaXNfbXQ3OTE1
KCZkZXYtPm10NzYpICYmIGkgPT0gMykNCj4gMzAwOCAgICAgCQkJYnJlYWs7DQo+IDMwMDkgICAg
IAl9DQo+IDMwMTANCj4gDQo+IElmIHRoaXMgaXMgYSBmYWxzZSBwb3NpdGl2ZSwgcGxlYXNlIGxl
dCB1cyBrbm93IHNvIHdlIGNhbiBtYXJrIGl0IGFzDQo+IHN1Y2gsIG9yIHRlYWNoIHRoZSBDb3Zl
cml0eSBydWxlcyB0byBiZSBzbWFydGVyLiBJZiBub3QsIHBsZWFzZSBtYWtlDQo+IHN1cmUgZml4
ZXMgZ2V0IGludG8gbGludXgtbmV4dC4gOikgRm9yIHBhdGNoZXMgZml4aW5nIHRoaXMsIHBsZWFz
ZQ0KPiBpbmNsdWRlIHRoZXNlIGxpbmVzIChidXQgZG91YmxlLWNoZWNrIHRoZSAiRml4ZXMiIGZp
cnN0KToNCj4gDQoNCkkgdGhpbmsgdGhpcyBpcyBhIGZhbHNlIHBvc3RpdmUgYXMgdGhlIHN1YnNl
cXVlbnQgY2hlY2sgJ2lmDQooIWlzX210NzkxNSgmZGV2LT5tdDc2KSAmJiBpID09IDMpJyBzaG91
bGQgYnJlYWsgYXJyYXkgIm9mZnMiIG9mIDguDQoNClJ5ZGVyDQoNCj4gUmVwb3J0ZWQtYnk6IGNv
dmVyaXR5LWJvdCA8a2Vlc2Nvb2srY292ZXJpdHktYm90QGNocm9taXVtLm9yZz4NCj4gQWRkcmVz
c2VzLUNvdmVyaXR5LUlEOiAxNTI3ODAxICgiTWVtb3J5IC0gaWxsZWdhbCBhY2Nlc3NlcyIpDQo+
IEZpeGVzOiA0MTdhNDUzNGQyMjMgKCJtdDc2OiBtdDc5MTU6IHVwZGF0ZSBtdDc5MTVfY2hhbl9t
aWJfb2ZmcyBmb3INCj4gbXQ3OTE2IikNCj4gDQo+IFRoYW5rcyBmb3IgeW91ciBhdHRlbnRpb24h
DQo+IA0K
