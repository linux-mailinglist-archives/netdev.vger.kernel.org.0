Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1126E6A1790
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 08:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbjBXHzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 02:55:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbjBXHzD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 02:55:03 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 510F54FAA2;
        Thu, 23 Feb 2023 23:54:55 -0800 (PST)
X-UUID: 63d09752b41611ed945fc101203acc17-20230224
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=QvC9vkCAz7ts9+TSwK8ZJ8GegyXfNCAsMqmAecfSWIA=;
        b=Vx8ZXQleXLR2jooYNFJCiFjORU4tuZwcQkImsr0xMf3sAQ2YLF8a55bYZB+fnAer/qHUtsLZsZMeBOkciU7wNQvp3pbo0vW4onxDHSiXKPgmSW0noeDEEYIAA5sCbGTzMvORJ/WS/LhF0ZXuzng8A90/wHtC2RTzuxNH036XyHo=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:2eb4a615-c752-4a3c-b667-f13b098d6adc,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:77ed9526-564d-42d9-9875-7c868ee415ec,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-UUID: 63d09752b41611ed945fc101203acc17-20230224
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1631992789; Fri, 24 Feb 2023 15:39:37 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Fri, 24 Feb 2023 15:39:36 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Fri, 24 Feb 2023 15:39:36 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IUvjbyK53iv+ST4rhSjrqKKaastUWbOk3WM24rf7LnhlWUt34Sf7woRrCeD2bBstCLHEjPiI5dHhbB3HjCRhYnqmzfmrquDxgxTpPH+gA9/Z/RvnTwxXML/KMmfyZ7doSnPmAK7GJSh4vho0t8ZjGs1wQlXqdYsqHrlC3L0BKDHEIi7Yu8jjecd1te8dEP2ozBkd2vxVB7zxj6NBpy3MaSfsOIjQM5ij2tb+ZwJTVFppSEiOeQl4eF0iI0vD31/CjYPmO1pMfL3ie/k0uDRDkB/gw1u1vMvRDGuNtlUE140roXnJZ8tbznJUnFKA6/PbeAOiTzp6J08iXKHCzBvwGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QvC9vkCAz7ts9+TSwK8ZJ8GegyXfNCAsMqmAecfSWIA=;
 b=Ih0I8wxGQ5TEQn1RBnrZ5/FE3PKkNIMeolPLYXEUI6yM3/OvsIu5y9GMhXkQOsk3L/snAPMmIbXNUGxtb4C2eWBFcafLqtiaUmlygoOWGBfk0TxaMCyWNUIUsDdTgOWOFStlklh7FyYbru5vx1OvuL9+EtG8BqFOIXtx8f3yOE43lq2s8y4WAxLyHOJ+nDX5CBrTU1aep5mc3pk3bHlwc1ikTXySZHdbNrJkg2kfMhya0lcCSupz/GfSSXmHoALlLNLMMxUQ/utdp6cGtHeUIHQElnn0ipltb3fmDx36SsRkMIlCTOtA0n02CSdtgs0teKOqNLhcFI6ioocxVl5afA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QvC9vkCAz7ts9+TSwK8ZJ8GegyXfNCAsMqmAecfSWIA=;
 b=FUtVcJhXwgCNrn5GSOoc1R/nX9thL3f2L1kZxGlAvcd8925FA8NcLxPRn3i/yPLpsoBvxc0kuIeoemiP0PXh6AN9Sns/gXCJmOy8MBAB+84qugeSaEp5QCW1iNmphFLbnxdq+xOduheI2E5z1bCncI7Kvlg++e1do84TqPRuExs=
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by SI2PR03MB5449.apcprd03.prod.outlook.com (2603:1096:4:103::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6134.20; Fri, 24 Feb
 2023 07:39:34 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::7b38:f629:1b13:6dc7%8]) with mapi id 15.20.6134.023; Fri, 24 Feb 2023
 07:39:34 +0000
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
Thread-Index: AQHZPfRhXG0uLuMh9ki8uUJNPx0e967PblKAgAIgUwCADDu2AA==
Date:   Fri, 24 Feb 2023 07:39:33 +0000
Message-ID: <d6f13d66a5ab0224f2ae424a0645d4cf29c2752b.camel@mediatek.com>
References: <20230211083732.193650-1-yanchao.yang@mediatek.com>
         <20230211083732.193650-2-yanchao.yang@mediatek.com>
         <20230214202229.50d07b89@kernel.org>
         <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
In-Reply-To: <2e518c17bf54298a2108de75fcd35aaf2b3397d3.camel@mediatek.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|SI2PR03MB5449:EE_
x-ms-office365-filtering-correlation-id: 0a1f8490-e981-4fe8-898a-08db163a45ca
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cQlIqqrlsmx+Se4QP9eMG386plB8mjAnEL9c6lKr2cSEBpo2SMeaGcbBxJIpbYo5pu6XaCW5YWEP72KXbpejis6QBKzCF/cp8AVfLlgvm3NNGS+lmXv+0HzbrDepIKegw/i7rsPmv7B44xLZQOWBFj5IQk0ZPZSadfdHRKxAqYWKO6lmXU1Vrj0yI+wg4fo620xM2B8xKFUAlxZ/TDQcDSIihH2X8h4szfduEGid4DMjUDemhRAq0yXFrjxhhWZFlrYggV2LNtWPSag4XDRjGcWEYs4wb/8U9CUlZRsTinHR8P6U5WAJvMtO71ddjA4Ua4hTiLgTFvFjZ+V91ChllUQhrelYkvPIppnXcMoGfVywTrap+RcXx48KMtr3E5Igmz8ZmS/f13Af7/ee0+FBWA9wV9/m6bmwblhxdG9kAufqk7FdmlzK1r3JjPEe5cee6TXY3y27/cHlLCgjS6Ns/1rYcI3aqEM2yGGBuMeB0Nr4U+BdEsreybLvShUzEHd4VHaIJUjRDE1J7Rhu1nw/DObzpXxZ3hEEpP55OlGtawwn4KN0vIBMzOnp2zuGmSDjIsxAPdDCYTLkj9Y3ZmC1s2PhvbhLenQd6tR0Kv3v964iCObkzNpnP2LXdWovvBwJek+tG032kuArnTb+yF1a3lXgpYERdGkvJ1dhMB3MeZOyVVNom/LUdC7Q5y1iNc3cLzCbJtJJGd9VLXZmUWNSaqzymBvYjW6Sqo1FPHQP7yE/jVQUNQYmgRV29cnHjN+t
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(366004)(136003)(451199018)(54906003)(316002)(2906002)(8936002)(2616005)(7416002)(38070700005)(186003)(122000001)(38100700002)(6512007)(71200400001)(6506007)(85182001)(26005)(6486002)(478600001)(83380400001)(86362001)(107886003)(36756003)(66946007)(64756008)(41300700001)(66476007)(66556008)(76116006)(66446008)(4326008)(5660300002)(91956017)(8676002)(6916009)(99106002)(473944003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WVJTZC9aT2g1RklJaU1rZFZNU29IcVpPSldMOWJ0OVRKdzBXSm5SeVpFZTRB?=
 =?utf-8?B?T2wwMmNzSHkzb1pwRTg0cHRLODErWmlpOTFQSHlJTzQzVHAxTW9nSngwaEVC?=
 =?utf-8?B?eDBtVFk1ZENMN0ZsWERveFh4VzQzeW11dWtBRFltWkVCbkM3RzVuZmQyWWYx?=
 =?utf-8?B?OURueEQyNVRseDF2ZldqVXJDVFR0c0lrUU1XZjR4RjRuZS9HaEIwYVkxZUJy?=
 =?utf-8?B?MHRKQW1zY2VDNlBxbWN1dTk2dGNQMUdsY0pNd1FwdHd2Si9zSUQvR256TUlQ?=
 =?utf-8?B?bTQyeGpuc0k5MVhoVEM5cmtzZXFCN3R4SVpoVlgrdEY2T1ZhQXBuL2I0NDhp?=
 =?utf-8?B?WE40TDFhempoSWo4MkJDdkhQUmhVK01RS1M5K2dpS2J1UkhTYTVON3ZhV0Zh?=
 =?utf-8?B?eVF0S05jdDNTeVlZZmJRbThXamhWSlArSUxvdEttZkhoNnlTLzJPNGUzR1Yr?=
 =?utf-8?B?cC82RjlFQjdaNDgzc2poazBxa2ZOU1FnM1pVbGdDNGI1NjN3WnBjWnJOMURj?=
 =?utf-8?B?RVNHNTJCY01BdTVNVlViRjQvLzFxUUVETzl6SEZjbmFpYzk2SUl3ekxBb1ZI?=
 =?utf-8?B?aHBZK2xuUEkxenFlaEpTSDJNTW0zV05vdmg0dTVBa1QvYS8vNm1xMWNVMXIr?=
 =?utf-8?B?aXExdFFYNGhlcFRjOTFadU85NC9taHF4OEhhMlVHdFF6dWNaSmFSb3RqbFRh?=
 =?utf-8?B?K0tHK2hLMmlkK0ZPdVJFbGIzQTlkSlBQbUVtQTI5MHZXREVnbm5Pbm5uUE1t?=
 =?utf-8?B?ZHRCZWFzZnE4UVpqUkFrWGcxdjR3VXB3dVJmN09qOGdBUytETFN3RkFGdExV?=
 =?utf-8?B?UFh3UmJaNlM2R1NRb2hCQ3p5dXdlNFpDQkdXVjRmc0hwNEhJbDlwYmJzK1Av?=
 =?utf-8?B?Z1FyYUhWVDhhTDBHSTFCQ0lSKzUxanBQWXEySlJXNVRrK1FHU3lPMWxoSkYv?=
 =?utf-8?B?blRYN0ZNeVlEcGlVaEtOQzl4QzZJTlVMcm13aG8yL2graVNYOHAxamppM2Vu?=
 =?utf-8?B?Umsvd1ovSkFLRm1wTWpraUJBaWlINlo1OE15cG1lbDF6Vld4RWY3UmxtZ1Vn?=
 =?utf-8?B?ZTJSMW1WUXFrcDI3Zjd2bWMyWGpSR2Z6R1UxQnNMazhyNzYvQ2JjZGFaVTky?=
 =?utf-8?B?Slc0Sk84NCtXR2JTQW11YjBMbjhPR3BuTTlURVAyYnVUdFNTR3UxdWdnU1Jl?=
 =?utf-8?B?YWMyLzRmblNSVUF1UEFKeGN3cVN2Z3RCOXBSVkVFb2JTci85bmYvbE5xYXpG?=
 =?utf-8?B?SkVVMDNFN3Q3Q3p3bUkvNzdKaXBTajBHbWZVYmREbWxNUzdQRHRNcE5zUm45?=
 =?utf-8?B?OWxCR3lDS3IvYVJBdkEvUVZITk1CN01MQlE1OXBOWlZValdiZTQ2b1hZdE5Y?=
 =?utf-8?B?RThSbFhWbm9kdmVrT3pZcWlDcWQyODcxQXpHd09RU3JwTXFoL1ltL2hNd0VK?=
 =?utf-8?B?UldaQUdJWGF5SmVDN0ZDcWpYYTNYTUZPdEhybCtIYWt0RHNCeEZpdkVOMFg2?=
 =?utf-8?B?Mms5ckFoakZyV0VpRVcyNXNQWEo5T2J1a25yOHYxc3d0VTc4dHV3NURMZUxS?=
 =?utf-8?B?c0l5Sng1UXZNTzQ5RURFUy9xaWtKT2RNRzMwR0RlNk1zaUpEaXRuR2lCaGR6?=
 =?utf-8?B?SVN4RGExcG1YYzM1cmNWU1hURTkzUzZzc3FSVHN6SHJpMG5MSFEyQUthKzBE?=
 =?utf-8?B?bFBHb2dYZmNTd0d0OXhNUGFoaGV6U2MvZStDT2xDTGZZWEhYNnl1eE1CZHBx?=
 =?utf-8?B?aDl6alp6TjN5aFZnMnpLYW5GelQ2bjloNWxkd2RzYllCdVR2MVVzZXY1d1RF?=
 =?utf-8?B?M2sybkdrY2w4QTVRa1F1bDRPNW83eVhQSGQ4WU5ROUEzbFVVZ245VWxhZzNv?=
 =?utf-8?B?VExLdDNJRzZ0VTVrcXVwMXIyT1JwRUpoMDBQb1NoSGdpUk43UVJ2WEtCYUJS?=
 =?utf-8?B?RllnTU5GVDMrVW44ZmJ4QWpjQmxlbHRqOTNPMHM3UUw1bVFHRVN1b25nMjhm?=
 =?utf-8?B?Y1NvWXFYdFl3T2NicUpHLzRCMnJHSUIzVG5kbExZOTkwTTkzZlVOeGk5RDk2?=
 =?utf-8?B?YVNZbVpuTVRRSkhZNXRBVVhTVzVPaS9ZcG9ZUTBzSXY4Z0xqSnd5alFHMi9k?=
 =?utf-8?B?b29WQ1dWVm1ZWDFkWXpjNkJkc2w3eEduTlR0a2kzd0xzWnV3Qk12TE5VV0Z0?=
 =?utf-8?B?eWc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BAA4F721FDDFE149AFC5943149FADB2F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0a1f8490-e981-4fe8-898a-08db163a45ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Feb 2023 07:39:33.7247
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9usGiu+GD30XnE5MA/SRZfdft9stLQFUgIEKBYMSCOoTMA96bswN+McUm8mJGX+P2nMbSgc7NcTmNSJN5OuHPZPknqTSRSlF2JOBGfmgRWQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5449
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

SGkgSmFrdWIsDQpPbiBUaHUsIDIwMjMtMDItMTYgYXQgMjA6NTAgKzA4MDAsIFlhbmNoYW8gWWFu
ZyB3cm90ZToNCj4gPiANCj4gSGkgSmFrdWIsDQo+IA0KPiBPbiBUdWUsIDIwMjMtMDItMTQgYXQg
MjA6MjIgLTA4MDAsIEpha3ViIEtpY2luc2tpIHdyb3RlOg0KPiA+IE9uIFNhdCwgMTEgRmViIDIw
MjMgMTY6Mzc6MjMgKzA4MDAgWWFuY2hhbyBZYW5nIHdyb3RlOg0KPiA+ID4gK2NjZmxhZ3MteSAr
PSAtSSQoc3JjdHJlZSkvJChzcmMpLw0KPiA+ID4gK2NjZmxhZ3MteSArPSAtSSQoc3JjdHJlZSkv
JChzcmMpL3BjaWUvDQo+ID4gDQo+ID4gRG8geW91IHJlYWxseSBuZWVkIHRoZXNlIGZsYWdzPw0K
PiANCj4gV2Ugd2lsbCBjaGVjayBhbmQgdXBkYXRlIGlmIGl0J3MgcmVhbGx5IHJlZHVuZGFudCBz
b29uLg0KVXBkYXRlIHRlc3QgcmVzdWx0Lg0KQm90aCBmbGFncyBhcmUgZGVsZXRlZCwgdGhlbiBy
dW4gdGhlIG1ha2UgY29tbWFuZCB3aXRoIA0KImJ1aWxkIGluIiBhbmQgImJ1aWxkIG1vZHVsZSIg
b24gYSBzZXBhcmF0ZSBrZXJuZWwgdHJlZS4gQm90aCBzdWZmZXINCnRoZSBzYW1lIGJ1aWxkIGVy
cm9yLg0K4oCcZHJpdmVycy9uZXQvd2FuL21lZGlhdGVrL3BjaWUvbXRrX3BjaS5jOjE2OjEwOiBm
YXRhbCBlcnJvcjogbXRrX2ZzbS5oOg0KTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQ0KICNpbmNs
dWRlICJtdGtfZnNtLmgiIg0KVGhlIHJlYXNvbiBpcyB0aGF0IGFsbCBmaWxlcyBhcmUgbm90IHBs
YWNlZCBpbiB0aGUgc2FtZSBmb2xkZXIuIFRoZQ0KZHJpdmVyIG5hbWVkIFRNSSBuZWVkcyBhIGNo
aWxkIGZvbGRlciwgdGhlbiBuZWVkcyB0aGVzZSBmbGFncy4NCg0KQW55IGlkZWFzIG9yIGNvbW1l
bnRzIGZvciB0aGlzPyBQbGVhc2UgaGVscCBzaGFyZSBpdCBhdCB5b3VyDQpjb252ZW5pZW5jZS4N
Cg0KPiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IHBjaV9kZXYgKnBkZXYgPSB0b19wY2lfZGV2KG1k
ZXYtPmRldik7DQo+ID4gPiArCWludCBpcnFfY250Ow0KPiA+ID4gKw0KPiA+ID4gKwlpcnFfY250
ID0gcGNpX2FsbG9jX2lycV92ZWN0b3JzKHBkZXYsIE1US19JUlFfQ05UX01JTiwNCj4gPiA+IG1h
eF9pcnFfY250LCBpcnFfdHlwZSk7DQo+ID4gPiArCW1kZXYtPm1zaV9udmVjcyA9IGlycV9jbnQ7
DQo+ID4gPiArDQo+ID4gPiArCWlmIChpcnFfY250IDwgTVRLX0lSUV9DTlRfTUlOKSB7DQo+ID4g
PiArCQlkZXZfZXJyKG1kZXYtPmRldiwNCj4gPiA+ICsJCQkiVW5hYmxlIHRvIGFsbG9jIHBjaSBp
cnEgdmVjdG9ycy4gcmV0PSVkDQo+ID4gPiBtYXhpcnFjbnQ9JWQgaXJxdHlwZT0weCV4XG4iLA0K
PiA+ID4gKwkJCWlycV9jbnQsIG1heF9pcnFfY250LCBpcnFfdHlwZSk7DQo+ID4gPiArCQlyZXR1
cm4gLUVGQVVMVDsNCj4gPiA+ICsJfQ0KPiA+ID4gKw0KPiA+ID4gKwlyZXR1cm4gbXRrX3BjaV9y
ZXF1ZXN0X2lycV9tc2l4KG1kZXYsIGlycV9jbnQpOw0KPiA+ID4gK30NCj4gPiA+ICsNCj4gPiA+
ICtzdGF0aWMgdm9pZCBtdGtfcGNpX2ZyZWVfaXJxKHN0cnVjdCBtdGtfbWRfZGV2ICptZGV2KQ0K
PiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IHBjaV9kZXYgKnBkZXYgPSB0b19wY2lfZGV2KG1kZXYt
PmRldik7DQo+ID4gPiArCXN0cnVjdCBtdGtfcGNpX3ByaXYgKnByaXYgPSBtZGV2LT5od19wcml2
Ow0KPiA+ID4gKwlpbnQgaTsNCj4gPiA+ICsNCj4gPiA+ICsJZm9yIChpID0gMDsgaSA8IHByaXYt
PmlycV9jbnQ7IGkrKykNCj4gPiA+ICsJCXBjaV9mcmVlX2lycShwZGV2LCBpLCAmcHJpdi0+aXJx
X2Rlc2NbaV0pOw0KPiA+ID4gKw0KPiA+ID4gKwlwY2lfZnJlZV9pcnFfdmVjdG9ycyhwZGV2KTsN
Cj4gPiA+ICt9DQo+ID4gPiArDQo+ID4gPiArc3RhdGljIHZvaWQgbXRrX3BjaV9zYXZlX3N0YXRl
KHN0cnVjdCBtdGtfbWRfZGV2ICptZGV2KQ0KPiA+ID4gK3sNCj4gPiA+ICsJc3RydWN0IHBjaV9k
ZXYgKnBkZXYgPSB0b19wY2lfZGV2KG1kZXYtPmRldik7DQo+ID4gPiArCXN0cnVjdCBtdGtfcGNp
X3ByaXYgKnByaXYgPSBtZGV2LT5od19wcml2Ow0KPiA+ID4gKwlpbnQgbHRyLCBsMXNzOw0KPiA+
ID4gKw0KPiA+ID4gKwlwY2lfc2F2ZV9zdGF0ZShwZGV2KTsNCj4gPiA+ICsJLyogc2F2ZSBsdHIg
Ki8NCj4gPiA+ICsJbHRyID0gcGNpX2ZpbmRfZXh0X2NhcGFiaWxpdHkocGRldiwgUENJX0VYVF9D
QVBfSURfTFRSKTsNCj4gPiA+ICsJaWYgKGx0cikgew0KPiA+ID4gKwkJcGNpX3JlYWRfY29uZmln
X3dvcmQocGRldiwgbHRyICsgUENJX0xUUl9NQVhfU05PT1BfTEFULA0KPiA+ID4gKwkJCQkgICAg
ICZwcml2LT5sdHJfbWF4X3Nub29wX2xhdCk7DQo+ID4gPiArCQlwY2lfcmVhZF9jb25maWdfd29y
ZChwZGV2LCBsdHIgKw0KPiA+ID4gUENJX0xUUl9NQVhfTk9TTk9PUF9MQVQsDQo+ID4gPiArCQkJ
CSAgICAgJnByaXYtPmx0cl9tYXhfbm9zbm9vcF9sYXQpOw0KPiA+ID4gKwl9DQo+ID4gPiArCS8q
IHNhdmUgbDFzcyAqLw0KPiA+ID4gKwlsMXNzID0gcGNpX2ZpbmRfZXh0X2NhcGFiaWxpdHkocGRl
diwgUENJX0VYVF9DQVBfSURfTDFTUyk7DQo+ID4gPiArCWlmIChsMXNzKSB7DQo+ID4gPiArCQlw
Y2lfcmVhZF9jb25maWdfZHdvcmQocGRldiwgbDFzcyArIFBDSV9MMVNTX0NUTDEsDQo+ID4gPiAm
cHJpdi0+bDFzc19jdGwxKTsNCj4gPiA+ICsJCXBjaV9yZWFkX2NvbmZpZ19kd29yZChwZGV2LCBs
MXNzICsgUENJX0wxU1NfQ1RMMiwNCj4gPiA+ICZwcml2LT5sMXNzX2N0bDIpOw0KPiA+ID4gKwl9
DQo+ID4gPiArfQ0KPiA+ID4gKwlkZXZfaW5mbyhtZGV2LT5kZXYsICJQcm9iZSBkb25lIGh3X3Zl
cj0weCV4XG4iLCBtZGV2LT5od192ZXIpOw0KPiA+ID4gKwlyZXR1cm4gMDsNCj4gPiA+ICsNCj4g
PiA+ICtlcnJfc2F2ZV9zdGF0ZToNCj4gPiANCj4gPiBMYWJlbHMgc2hvdWxkIGJlIG5hbWVkIGFm
dGVyIGFjdGlvbiB0aGV5IHBlcmZvcm0sIG5vdCB3aGVyZSB0aGV5DQo+ID4ganVtcA0KPiA+IGZy
b20uIFBsZWFzZSBmaXggdGhpcyBldmVyeXdoZXJlLg0KPiANCj4gV2UgY2FuIGZvdW5kIHNpbWls
YXIgc2FtcGxlcyBpbiBrZXJuZWwgY29kZXMsIG5hbWluZyB0aGUgbGFiZWwgcGVyDQo+IHdoZXJl
IGp1bXAgZnJvbeKApg0KPiBleC4gcGNpLXN5c2ZzLmMNCj4gc2hhbGwgd2UgYXBwbHkgdGhpcyBy
dWxlIHRvIG91ciBkcml2ZXI/DQo+IEkNCj4gdCdzIG1hbmRhdG9yeSBvciBuaWNlIHRvIGhhdmUu
DQoNCkFueSBpZGVhcyBvciBjb21tZW50cyBmb3IgdGhpcz8gUGxlYXNlIGhlbHAgc2hhcmUgaXQg
YXQgeW91cg0KY29udmVuaWVuY2UuDQoNCk1hbnkgdGhhbmtzLg0KeWFuY2hhby55YW5nDQo=
