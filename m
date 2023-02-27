Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BAAA6A417B
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 13:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229788AbjB0MME (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 07:12:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjB0MMC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 07:12:02 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE85F1F5DA;
        Mon, 27 Feb 2023 04:11:59 -0800 (PST)
X-UUID: ed345456b69711eda06fc9ecc4dadd91-20230227
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=Og8Tg/g1mzI9/Onzp+I/o//uBV/XafOG7CRv++lCUQg=;
        b=UjbuRXXloOO13c3iTv131iCiX0ZuKD3XNahBYadojh/mWJkV34SR+zusSDtOoG5zaTaZQah4b42zddSaWyGSyB7KzdhgIAVJi4XkiLbALHQ89P1CdCZ6HDJzz/zg8XS8C4/hpI3XM3VIDU27XxemzrROhjQC8q3Ypqq0Tmdzv+Q=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:f29338b8-ec38-4bc5-a49c-e0468dbbc42f,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:8d39c926-564d-42d9-9875-7c868ee415ec,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: ed345456b69711eda06fc9ecc4dadd91-20230227
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 277418374; Mon, 27 Feb 2023 20:11:55 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Mon, 27 Feb 2023 20:11:54 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Mon, 27 Feb 2023 20:11:54 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hHuyRo2hB30Q+XfQd6b9TyLC5r8bRG862vvj1pXhhdhjd1jYEAVc3sQ/dTOjaCSH99ORAjL7btX7DNrSjcA+nHWcJw2sYj/VyqxAywl9qRAGLdtyTwO4r6Mk/ukx4ji5VZ5yNx8dI4WLXFEKvtTgJUCSD/B5z3cRyRgM/uHAFgmVdTAvpaHwV1zaCwTh9sBIqzNAs94rej2MVgUQHh1Lqq2ShGQA1v9NlesywoSgfbJRSwlFQv0u2+COVvnI+xrun9Kyki1DBeZqydw2sCK101n6mLjeGl//NR/N63nEE6voVCmuFRU5C6+TvF4thgrkP3B7RLPwEUWbQCvmeBwdow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Og8Tg/g1mzI9/Onzp+I/o//uBV/XafOG7CRv++lCUQg=;
 b=JXWtvB1KXIoz4NSgjLPxHbFljDl91GyXRVEYYc+W/OL/Ixmnie2mie5D9EQj4233Fvl68g0BRPYPvh+WFsoVAPE2rJ7rR1ORSUm6SSymanRdXi/zBU6oEazemOHPeGUDT9GjeOq4Klmjwbggh+Dt1HNMmJMihE1WEuHQR4DU0U8KlLl1gAO4pay/I89wLt5hxOXpdGCxBGBK/QrSjdkYM3fLFQmDXsekSe8tOwssJvYR6r7sp9DJGFIf13aK5iolMVCXFxmV7VJFzdj9cBOSF5iuZheunCE8yNCxn46jWqPP7FOxJYgpEQI3lYIencFtgJ6zXIlwiOOeP6Yaff8E8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Og8Tg/g1mzI9/Onzp+I/o//uBV/XafOG7CRv++lCUQg=;
 b=F1mgZrwrYAtNGQqbvG3j9kKOcYm6kCQgdNxNixZwEhS2RhfA1iYgW6XKAz/FI9CB/moQ077Wu1aO+Xj3SF9MUkJZ2bKS7kz36CRaawcDNWz8v5XHJZLYWICQOfRClkq4EC20V19kUkBGflJPhtj00HSxvmgcvQQApCaYXX8imvM=
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by SEZPR03MB6914.apcprd03.prod.outlook.com (2603:1096:101:a5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.29; Mon, 27 Feb
 2023 12:11:52 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7%8]) with mapi id 15.20.6134.025; Mon, 27 Feb 2023
 12:11:52 +0000
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
Thread-Index: AQHZPfRhXG0uLuMh9ki8uUJNPx0e967PblKAgAIgUwCADDu2AIAAzFUAgAQ2vAA=
Date:   Mon, 27 Feb 2023 12:11:51 +0000
Message-ID: <e7628b89847adda7d8302db91d48b3ff62245f43.camel@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
         <20230211083732.193650-2-yanchao.yang@mediatek.com>
         <20230214202229.50d07b89@kernel.org>
         <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
         <d6f13d66a5ab0224f2ae424a0645d4cf29c2752b.camel@mediatek.com>
         <20230224115052.5bdcc54d@kernel.org>
In-Reply-To: <20230224115052.5bdcc54d@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|SEZPR03MB6914:EE_
x-ms-office365-filtering-correlation-id: 63a19aae-9a51-4aee-1c2b-08db18bbcf53
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 715/PZ6tGxVVuaOxf+QD17NEdPer8qCXLUF36JiO4mz0DUaFXhGZxnw1nCqRjVloipB7WObICfPcDna/n97UbUvHf22XqgYH2aNXY5lRIJLHpWwg0BhUmDl55TqnOj26GhxSYesluUnDO9d9ioUqAWEBUkqOU+mSFUW3/mevOwT+xMX4SmpKTzsryInOrp+mFSUrRPqTZBiLigGU/w3KVJsr37AzMnUlbtXla5a7m/gzLhq50iGXZ8+QOX7qNt4M87kTxSD9ma21vaWt6W1JX9TWaox09g0C48cpL33CtsD1VYzllbCZ/1AgyMs/A3y7o9fU9h10MH5+DsWRkVpL5AIEZ9G52vdDpc+/JPOmD960uiXH4NRCtqe3Of0abKMGqCkuu+IJjniHfT6KhIKLNfGFhwOfr06lkUX8Eyckkgy5Vqwo2rqy6rmQ5ye39TV03DYkaVwpViroUhuoaUao/QXcr4qyW9KklL6daeibyANWJJBiTIKLbc95iBQ90aa4qv6RO2X8RZGR/AQoky/mucUHhoHPwD8fMVBJXvZllwDnjxk8wlJUAF/0N3iwZg2K/oZ9ZQEkT/eSCVr21dyHoJb9rvgKdnQFH1rYc2b1DnxRalzVSah06kk+vLKLlOH0eMWMSyX88XExE/9lnMzOWNjst6Y/hNN1tzRoZvLOVE07zzPcBkg5ssZhJFX8ru4wcDrtKo/HcHB72/uSwXKPHost7x+9EcpqGwZ8oYydx40=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(451199018)(91956017)(4326008)(76116006)(66946007)(6916009)(66446008)(66556008)(66476007)(64756008)(83380400001)(41300700001)(316002)(38070700005)(36756003)(85182001)(8676002)(8936002)(122000001)(54906003)(38100700002)(2616005)(7416002)(5660300002)(6486002)(86362001)(71200400001)(478600001)(186003)(26005)(2906002)(6506007)(6512007)(107886003)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c3Bqb2NuSzlvbHdLKzdWM0RHVVpXNWQwb2tVNkJZNlBCVVdHOXNiS3VCdHZi?=
 =?utf-8?B?UGFjTWtCaEtreUJ4Yjd0bUFlcEVhQlBMUGZqQWtBbVMzT3oyV0FQNStBK2RI?=
 =?utf-8?B?cFZmaG94d1VtS1lBOFJRVjdQN0RLV0drLzZQRzVWUXBUd2VVRmlHZGh2MDlq?=
 =?utf-8?B?N3pNSU11TFJuRUI2UFVqalZCeXNubWdnNjArN24ydzhmdXR6TWp4eFdwQWgz?=
 =?utf-8?B?Y1BVTWp1dENFTjlHdWxTQ1lMQk5uYW4ybGhYTGIzejQreHROd21CZmFLQ3RX?=
 =?utf-8?B?bVp0U2hDUEo2eERkVTkzbEJBTndORzdsSlRCTFRYelJlVDRMMzg1S05vY2lw?=
 =?utf-8?B?LzRsZjBGMUxwSm5CT21sUWZEVnM4ZEhHYVdIcHAxN1FzVjdsTVpZNGlRS3ZS?=
 =?utf-8?B?Q1VuRE8zMGp3YXhRRmMyZXJKUGpKOFFyT3ZiNEtnYk1peHFJb0ZzNSszM0VF?=
 =?utf-8?B?VG1mdStYd21peHc4dkRtMy9HVVlTTmFEeUUzanpPVjJqdjhqbEdSV1U5SzZD?=
 =?utf-8?B?MlhOVG5kclBNcjk4N3Yya2pxZmJwVm1rcWM3RTlsUEF5YmloNG83TGFhQy8w?=
 =?utf-8?B?bjRtRkplSmZtQU8raDJOMkdWQjkwVVFGd3c3YVVUWEx4SEtBcXh3YTBMMjJD?=
 =?utf-8?B?d2VUdU9UamczZ2FrRk50eFRRNXRXN2pHZ2JvbzI0alFqYXRndjd3WW13YWFC?=
 =?utf-8?B?UkxFR3VJSW5pZitnSUVwZWRiV3hyb29iZi96RFhHUHF4ejFEbGxLTEp0Q1gx?=
 =?utf-8?B?R29ReG1FelBhb2V1VGNIaWVXZG84cXY1VjZWYTRNVk9MUHEyOGtCT2tEb1Bv?=
 =?utf-8?B?WVQyU3ljWmRoUEdweGkwbE9TaEVkYkF3RUxSSy9oRm82ZHhzd1JVajdWQjFK?=
 =?utf-8?B?TFEvcHh4YzYrU3JrOWZCQnAzcVYrbkIyeE0rQjNpUi9Na2hzcW9DazUxTTFY?=
 =?utf-8?B?SlZCa0F4allibGhIb050WWR5WUZkWDltYytRZDMxcXBlRTRQNll6V2ZyQXlX?=
 =?utf-8?B?akRWY3NJbFpQN3FPYnR1VUZNdXR4RlF4WjRVZmlRRmVwUVVDc2VBUnhmU2JP?=
 =?utf-8?B?ZXdCbFVLbHd3a1BVbEtoU2ZQK3BVT3dXM0pmZlp5MTJYbFA0TXNHSElKS1ZK?=
 =?utf-8?B?TlgvdzNDc04zQkZSclAxMWRjck9jbE83ZlUvb1NQeVVid2xxa3ZpYVd5N0VD?=
 =?utf-8?B?UzZUL3JVZ0VXb1g1djJjOU5WTEJyZTRqZTlQVitWb3djbzBIb3RnQzJuUnYw?=
 =?utf-8?B?UERWaWpwRUh5dytKbVk1Z1h3MWJ0Mno5Nk1qRGQyUFZoN0IvZjJTT1N5cFZx?=
 =?utf-8?B?eE5YU09ramlGSmFJSU4xOVZXeWRFcWZURVRIcDVWS3hMdkNGTGRCa0lCUVZK?=
 =?utf-8?B?TzVJTEY1VWp3anI3c3R0VUd5N0JoLzhMcE4xUlpzUWJGSEZKNlNuZGNuSkll?=
 =?utf-8?B?enNDQXlKRVJXbU9pTjFCWG80akRuYkJSSXZCSkc2WlBod2FMbkNjam1WMEVY?=
 =?utf-8?B?eWswL3FETjk0MXhrb1F0eXY0d0RZRUMwKzlnYmZibW9UTzREN3dVSm5mWEVt?=
 =?utf-8?B?Zy9rUUFIMlpHVExWOFFzelZaampVUnZWUjE5YUZVTU81N3JvNUlUdWd5ZUF2?=
 =?utf-8?B?TzJQdFVEeERFWnFpWnRENVNxdThSajR6NU0vRXhRRXpmTGlDYlJwbFIxSVJY?=
 =?utf-8?B?N08ySW50UTVRc1JwSGhLZnlMNDlMRHFqUFplU1FsSlNRSThZQmppTUZWNFNS?=
 =?utf-8?B?NFFEaSttUGQwOFpEZnQycUU0VjhGU3JYeHBGTlhpZzV2UU05M1BJVTY0RXVO?=
 =?utf-8?B?RzRPQU9MenR4cnQ5bC9OK0F0UXhLOTJFRWd2MnZPOVUwVHBTRlV4dm52cWx1?=
 =?utf-8?B?MWxSeEo5TDBObmQ4blNoOFhkYlltdTBNR3VRZ0xGQTZ4M1BTMG1YVHliakxG?=
 =?utf-8?B?K1IwNVAyeHNCODRzaEdQZ3ZtYWxmTmo2dVJmdkE4WnNONXdPa29pczlYYTBV?=
 =?utf-8?B?Q1VwdHNnOVVPSUxzTjIzd1JacGMrQUVNTURWZkJSdmhmWHFna2hZTWVMbHBW?=
 =?utf-8?B?NDBrSitVb1pYcUpZditQMEJ0TUVNaGo1Vk5lcXk1NlU1VmZ2RTBEODNxQXp6?=
 =?utf-8?B?aDZNNmx3OWE1SHNEWVpSYlVQeGgyQmxuY1k0RXlTMFZsSkpXdVVXMHliQ3dn?=
 =?utf-8?B?clE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <EFB2F77F3F02CD468ECB1A136F570DEE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 63a19aae-9a51-4aee-1c2b-08db18bbcf53
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Feb 2023 12:11:51.9026
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8RBnG93lOIhRhi5OaikF8p6/sCn9/i+LUGfnfZ5l1HBL7BMhyf9QSqU3HlOYsBZcecJdeAtXekoRAmBc753GSVggYtMdHLC8J1bGCJPQec8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SEZPR03MB6914
X-MTK:  N
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTI0IGF0IDExOjUwIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCAyNCBGZWIgMjAyMyAwNzozOTozMyArMDAwMCBZYW5jaGFvIFlhbmcgKOadqOW9
pui2hSkgd3JvdGU6DQo+ID4gPiA+IERvIHlvdSByZWFsbHkgbmVlZCB0aGVzZSBmbGFncz8gIA0K
PiA+ID4gDQo+ID4gPiBXZSB3aWxsIGNoZWNrIGFuZCB1cGRhdGUgaWYgaXQncyByZWFsbHkgcmVk
dW5kYW50IHNvb24uICANCj4gPiANCj4gPiBVcGRhdGUgdGVzdCByZXN1bHQuDQo+ID4gQm90aCBm
bGFncyBhcmUgZGVsZXRlZCwgdGhlbiBydW4gdGhlIG1ha2UgY29tbWFuZCB3aXRoIA0KPiA+ICJi
dWlsZCBpbiIgYW5kICJidWlsZCBtb2R1bGUiIG9uIGEgc2VwYXJhdGUga2VybmVsIHRyZWUuIEJv
dGgNCj4gPiBzdWZmZXINCj4gPiB0aGUgc2FtZSBidWlsZCBlcnJvci4NCj4gPiDigJxkcml2ZXJz
L25ldC93YW4vbWVkaWF0ZWsvcGNpZS9tdGtfcGNpLmM6MTY6MTA6IGZhdGFsIGVycm9yOg0KPiA+
IG10a19mc20uaDoNCj4gPiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5DQo+ID4gICNpbmNsdWRl
ICJtdGtfZnNtLmgiIg0KPiA+IFRoZSByZWFzb24gaXMgdGhhdCBhbGwgZmlsZXMgYXJlIG5vdCBw
bGFjZWQgaW4gdGhlIHNhbWUgZm9sZGVyLiBUaGUNCj4gPiBkcml2ZXIgbmFtZWQgVE1JIG5lZWRz
IGEgY2hpbGQgZm9sZGVyLCB0aGVuIG5lZWRzIHRoZXNlIGZsYWdzLg0KPiA+IA0KPiA+IEFueSBp
ZGVhcyBvciBjb21tZW50cyBmb3IgdGhpcz8gUGxlYXNlIGhlbHAgc2hhcmUgaXQgYXQgeW91cg0K
PiA+IGNvbnZlbmllbmNlLg0KPiANCj4gUmVsYXRpdmUgcGF0aHMgd29yaywgcmlnaHQ/DQo+IA0K
T2theS4gQ2hhbmdlIGFzIGZvbGxvd3MsIGlzIHRoYXQgcmlnaHQ/DQptdGtfcGNpLmggaW5jbHVk
ZXMgIm10a19kZXYuaCIsDQp3aGljaCBpcyBsb2NhdGVkIGluIHRoZSBwYXJlbnQgZm9sZGVyLg0K
I2luY2x1ZGUgIi4uL210a19kZXYuaCINCg0KbXRrX2ZzbS5jDQppbmNsdWRlcyAibXRrX3JlZy5o
Iiwgd2hpY2ggaXMgbG9jYXRlZCBpbiB0aGUgY2hpbGQgZm9sZGVyICJwY2llIg0KI2luY2x1DQpk
ZSAicGNpZS9tdGtfcmVnLmgiDQoNCj4gPiA+ID4gTGFiZWxzIHNob3VsZCBiZSBuYW1lZCBhZnRl
ciBhY3Rpb24gdGhleSBwZXJmb3JtLCBub3Qgd2hlcmUNCj4gPiA+ID4gdGhleQ0KPiA+ID4gPiBq
dW1wDQo+ID4gPiA+IGZyb20uIFBsZWFzZSBmaXggdGhpcyBldmVyeXdoZXJlLiAgDQo+ID4gPiAN
Cj4gPiA+IFdlIGNhbiBmb3VuZCBzaW1pbGFyIHNhbXBsZXMgaW4ga2VybmVsIGNvZGVzLCBuYW1p
bmcgdGhlIGxhYmVsDQo+ID4gPiBwZXINCj4gPiA+IHdoZXJlIGp1bXAgZnJvbeKApg0KPiA+ID4g
ZXguIHBjaS1zeXNmcy5jDQo+ID4gPiBzaGFsbCB3ZSBhcHBseSB0aGlzIHJ1bGUgdG8gb3VyIGRy
aXZlcj8NCj4gPiA+IEkNCj4gPiA+IHQncyBtYW5kYXRvcnkgb3IgbmljZSB0byBoYXZlLiAgDQo+
ID4gDQo+ID4gQW55IGlkZWFzIG9yIGNvbW1lbnRzIGZvciB0aGlzPyBQbGVhc2UgaGVscCBzaGFy
ZSBpdCBhdCB5b3VyDQo+ID4gY29udmVuaWVuY2UuDQo+IA0KPiBJdCdzIG1hbmRhdG9yeSBmb3Ig
bmV3IGNvZGUuDQpPa2F5LiBDaGFuZ2UgYXMgZm9sbG93cywgaXMgdGhhdCByaWdodD8NCgkuLi4u
Li4NCglSZXQgPQ0KbXRrX2N0cmxfaW5pdChtZGV2KTsNCglJZiAocmV0KQ0KCQlnb3RvIGZyZWVf
ZnNtOw0KCXJldCA9IG10a19kYXRhX2luaXQobWRldikNCg0KCUlmIChyZXQpDQoJCWdvdG8gZnJl
ZV9jdHJsX3BsYW5lOw0KCXJldHVybiAwOw0KZnJlZV9jdHJsX3BsYW5lOg0KDQoJbXRrX2N0cmxf
ZXhpdChtZGV2KTsNCmZyZWVfZnNtOg0KCW10a19mc21fZXhpdChtZGV2KTsNCmV4aXQ6DQoJcmV0
dXJuIHJldDsNCn0NCg0KbWFueSB0aGFua3MuDQoNCg==
