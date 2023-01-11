Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 988BA665CB6
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 14:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234177AbjAKNgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 08:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbjAKNfY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 08:35:24 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFC691CB06;
        Wed, 11 Jan 2023 05:33:21 -0800 (PST)
X-UUID: 81d9e6a691b411ed945fc101203acc17-20230111
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=dMXe7EnGj1mkusNjqtX3eo0X1DCAt2G6B1xiTTWOkG4=;
        b=tBM1C3bVpWkpopgPncGQ/Om8yELtIQ24bkSyxyO10QtgQ9lVG4DXRPEyejgq02HhSdOM90JWBVxmZqAfNnqIvBoCM10SIFDWw7CWSbKtY0YXMGwbnyJP3cCLkWTyGmFIZ/jTcfes95XeSbc08B4vJh7hA/1/U62qf5JtoeoelMM=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.17,REQID:0558e7f0-95c5-43dc-90d1-35e33b41d69f,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:1,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-4
X-CID-INFO: VERSION:1.1.17,REQID:0558e7f0-95c5-43dc-90d1-35e33b41d69f,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:1,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-4
X-CID-META: VersionHash:543e81c,CLOUDID:75d885f5-ff42-4fb0-b929-626456a83c14,B
        ulkID:230111213318DGB23MMG,BulkQuantity:0,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:11|1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:
        0,OSA:0
X-CID-APTURL: Status:success,Category:nil,Trust:0,Unknown:0,Malicious:0
X-CID-BVR: 0
X-UUID: 81d9e6a691b411ed945fc101203acc17-20230111
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 217970276; Wed, 11 Jan 2023 21:33:17 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 11 Jan 2023 21:33:16 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Wed, 11 Jan 2023 21:33:16 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WJBYQTXG280zdBnoJXg251kNeNuNTQOzCBb4W9DMO1hB63IZGB92In/OZWEdXeiMCRvF8SeDd0VJ0OF4ZjUKC6vjdUrZ45OObGe2kYldElW2BD3xjqCJDrVNmoNEP0aUd9JQ234mY1hlJcfwW8u+sd/cJ7H4COljoj9lS2NVuwLuNFBDXkhn8ayT+B/3/xotsgCB1Iigr+MaSlQCSC48yoZoJo22kbrS2bjzjXB24YgxEuUmp14ZseHsMjec9N8QhH2K045FLzJBj/fGoSz/TJHs0vtXaZh0mx1Xjb0oqiGvBGH8XMnuo2rW6JM1kO+o/uRv6RmK+rrAYIXNYpI3Eg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dMXe7EnGj1mkusNjqtX3eo0X1DCAt2G6B1xiTTWOkG4=;
 b=aC/hHZq0B1u8/xGD2UI9HCzT5RPUszqlKhoF/SLqkIB9BB1KlqoAJkQxTcJjVqLBqXAVj7HsCsc5w+5L0nISVwtu27t/lHTHAkXWSBHa+mTYnl3ydIPaleHkxJnaBWrxrnmAdcXPAzONRGAdNiA1sGF5D1WY5ihZW7pqjJ/OQWN3GbT4hFnYujT/nxLGveSEFLCezHHpA9gNTVgapFbGpcVMhwjI2ToNnqohiwy5whBPNLw7W5o5P0x7Gld4HZx0a5+JAWg88L7c0lkdadY0DXU+QqJcLUWSOocQsaFzqglimJUXht9GnnyWRc2OnCbZ/ZyXP0ELO2Sdz7eclDaGCg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dMXe7EnGj1mkusNjqtX3eo0X1DCAt2G6B1xiTTWOkG4=;
 b=Kkai5PB5GrHAyWGvNyJZMUIn0BbLWAnN7W+IAvavEKwKiT181GGFB+pPRqFh+ZuxaRPSJWGUqaWrO3t+C0LubmLhFIWNAauYiU1M5DSPrmNFb9Iu1QpmK3Jr5iPsw9pPaGtnKsBwDr51CP/7L6eYxs+PCyPvuVL0yl37p36itWc=
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by SI2PR03MB5594.apcprd03.prod.outlook.com (2603:1096:4:12b::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5986.18; Wed, 11 Jan
 2023 13:33:14 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::e366:4e14:ceda:9b22]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::e366:4e14:ceda:9b22%5]) with mapi id 15.20.5986.018; Wed, 11 Jan 2023
 13:33:14 +0000
From:   =?utf-8?B?WWFuY2hhbyBZYW5nICjmnajlvabotoUp?= 
        <Yanchao.Yang@mediatek.com>
To:     "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>
CC:     =?utf-8?B?Q2hyaXMgRmVuZyAo5Yav5L+d5p6XKQ==?= 
        <Chris.Feng@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linuxwwan@mediatek.com" <linuxwwan@mediatek.com>,
        =?utf-8?B?TWluIERvbmcgKOiRo+aVjyk=?= <min.dong@mediatek.com>,
        =?utf-8?B?TWluZ2xpYW5nIFh1ICjlvpDmmI7kuq4p?= 
        <mingliang.xu@mediatek.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        =?utf-8?B?TGlhbmcgTHUgKOWQleS6rik=?= <liang.lu@mediatek.com>,
        =?utf-8?B?SGFpanVuIExpdSAo5YiY5rW35YabKQ==?= 
        <haijun.liu@mediatek.com>,
        =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>,
        =?utf-8?B?SHVhIFlhbmcgKOadqOWNjik=?= <Hua.Yang@mediatek.com>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        =?utf-8?B?VGluZyBXYW5nICjnjovmjLop?= <ting.wang@mediatek.com>,
        "edumazet@google.com" <edumazet@google.com>,
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
Subject: Re: [PATCH net-next v1 01/13] net: wwan: tmi: Add PCIe core
Thread-Topic: [PATCH net-next v1 01/13] net: wwan: tmi: Add PCIe core
Thread-Index: AQHY/mOOLXwwV7yd6EmMw/xxfngMlK5eJmEAgAOlhQCAD1S3AIAoZR2A
Date:   Wed, 11 Jan 2023 13:33:14 +0000
Message-ID: <9a3fc5784b38d30a7d7def20aa503d399d336484.camel@mediatek.com>
References: <20221122111152.160377-1-yanchao.yang@mediatek.com>
         <20221122111152.160377-2-yanchao.yang@mediatek.com>
         <64aada78-8029-1b05-b802-a005549503c9@gmail.com>
         <8878ed64fadfda9b3d3c8cd8b4564dd9019349b6.camel@mediatek.com>
         <7d44c9ed-cf9d-64e1-df85-726a97859e06@gmail.com>
In-Reply-To: <7d44c9ed-cf9d-64e1-df85-726a97859e06@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|SI2PR03MB5594:EE_
x-ms-office365-filtering-correlation-id: 5acc3a05-b05c-4006-68fa-08daf3d863e6
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q8v2m2UczpdpAee1oQkVrDw9yNsj+bi5AFZw3MZ05zwiFVONMtgw5TVxGsq+HkL5iH3YX1vqe+3iAtUY2kVHgNMwfpUvYCpdVAakU0s7vWuqDrbrhH3pqtpgSxZ5GzLuwqp/TYdAVGUf689rN/RqMHjsBQ56oO0DQTIrDu6IiXimsTYOzP0ZbsOcqapHAZPw9JtnL1b/p2P/8wE0H6NTXSQg6U3BdqOmJ2zdDwbKLrK31pFKHvmo4uYUmhN7X9nvpwxRdsoKn2C0mdlvLrEQqFl1gbLI3D8rj275ODzZsrIremuLYrs2ZyvKqyMSZkKZk4Lx0DtNLVGXGDgdNffYnygEDj71kEeaXOs8zAFmfqOtsxqE27+u1DJR0r8c+3MQy2okwUn6KyZy1uPEhPcQPlHED8Fv3soSlnrG34p2g0bYg1AY6dBccbdeq02L3a1Lg3Oeh0K+03uXIKeMjFsrbWoKiokd1hI6tp1nJmT/B2Ym3+FAA65H89MPW9K8uF5byGhZMnx7u960gaZ8PKSOzNJMECtV0s6yQTX0uhqyMjntdiRAUnzOOyHq9NIaqn2asCdnMIj8cQ+M0v2KYhZIfuf8JlTWDxtFAaMJnDcxCSQ2U917FIefBkBab9pjk7DF8hTk8dueu0l288lt8txcxN4MAnOgVPa2EzlA2Yhdnid9Sa52wynJrBncA2/eMv1v1CMqoVU7niNghZiRVaAFHX9/fN623kAugCZUmpVzJQw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(376002)(366004)(39860400002)(396003)(346002)(136003)(451199015)(4001150100001)(2906002)(7416002)(53546011)(8936002)(5660300002)(26005)(6512007)(41300700001)(85182001)(36756003)(4326008)(71200400001)(66556008)(66446008)(66476007)(6916009)(86362001)(66946007)(64756008)(38100700002)(122000001)(76116006)(186003)(91956017)(8676002)(107886003)(2616005)(54906003)(83380400001)(6486002)(6506007)(478600001)(38070700005)(316002)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SDcwT1N6TUx0Y0lSb3B1b3o3RHZVdkZqWWZTZU5VMnJCZjJERG9DMVRXYzUv?=
 =?utf-8?B?Y2NIQVdQWC9mU0djZXBQcGhPZUVHaGQ4eWJJZEFCanQ1U0t2ejZSK3oxdzZM?=
 =?utf-8?B?QlBtaWxxcEJub0hYNDhPeGMwNDAyd0VpT243elIwRmVJNTZjY0xBbFlZT1RV?=
 =?utf-8?B?dVkya2FyTGdVWXgwWUhVVG9MemhZemRubXVnQjhBY08weTFkZmRWTG9RR1Jz?=
 =?utf-8?B?L2lqb0ViM1M2MllrVEZiUHZ5QWFhVHFwaTljKzVmOVJ2Q1A5ZkRTN0ZZZy8w?=
 =?utf-8?B?ZlVzaTlNcUJQRlZJSzFKUU5pUHFDc2E2TndPelBnU3hqV2p4RjZONUhsY2N1?=
 =?utf-8?B?SWdzZlZiWjZZNE1rQ0k0Sm1sOHcxUVFRK3hBRVdzQmFudHVGZUhsMFRheWRU?=
 =?utf-8?B?WWJRTmFsZHZmbW5FMFlaSWR4ak1nVDJEbWhRSysxVmpaV3J6MXllTEUwS0pt?=
 =?utf-8?B?dmV3TVlCblhtdmlqNUlTU2pCeDk5YWFYbWdjenpaNy9mMlBaSnhoSW12elo1?=
 =?utf-8?B?NkhHdjdBejR6MHNpMk9XZmMrK1NHMFRYNmhDWHlkbW9wbmtOSkFOcFNGSVJv?=
 =?utf-8?B?YlAvMk1QL3hPK1RmaDl5cDJrdEtmeXBlM0ozQkdBditDY05BNGc3Y3MrUVU3?=
 =?utf-8?B?bkkvWHMxRTNIcFJLY0dwT2d0TlVZc0xSR2lWMGNyYXhkTGV2SkxPT21hdVJQ?=
 =?utf-8?B?NjlCTUNMcU44SWI1ZkFJemFxNWtVZUV2Tlc5SlBUOTMyYVJhQ3JJM1orTGhI?=
 =?utf-8?B?dENOR2JMK2owT3BLVzRRdEtEK0pDWmZFODBKUndndmJqZWI5Y1pKWjRzVHFF?=
 =?utf-8?B?b0srUjA4TTdWdm9zZGkxRFNEb3JYVDdkRS9PYm5ZTmkyUWxNWjFXR0pyV1dN?=
 =?utf-8?B?U0UwYWVzOEVxc0RWSDA0dzRYamZaaUNwdElMT2lUSHdmSzNqcGxxb3Q2eXUw?=
 =?utf-8?B?ejVObjFzcFhsY01NVkJiSDdBd0xmNGx6Tk4xRDNWQ293RjhHMSt2QzdxMWk4?=
 =?utf-8?B?RjgvYzh4Nnd3RW5DSTc5MTVNVkxkUURKMGFWVVFBQUwvNmpyZ3BWdVUxUm1E?=
 =?utf-8?B?MHkrQlROaThscmYxNlZGVjRPK0V6ZWhqSTYwa1NqV1RXdStobmpQMThCQXFj?=
 =?utf-8?B?eTVDQVg1d1RaZlFjVFYwTElwNUJWTUMzU1lzZ1NYczVSbFFNM1pReit0ZWRq?=
 =?utf-8?B?OUxOUldjVXBOcTBISU4vWFY2RWZwTGhQQ2Z3NmUxb0wwbEZia0xNVUZseXFp?=
 =?utf-8?B?Qjk1aXRCV0xzSERLaFhoQS95a09SWXZjZEsxbnQxQksxSkZrOTBFRHcySi9m?=
 =?utf-8?B?dTBQMHk3d3ZUc0R4ajZpeWdib2hpUnlESmZPVk1XQVdxOG1XNmVNcmFZRDd0?=
 =?utf-8?B?Q3F5bzYxaHRWWndzSGs2YjFsUzJyQVNXOWxLRG9UM1JmWXJjT3pmS05Eb29G?=
 =?utf-8?B?MkMxL2NRUzRiWEZTTGE4VmtaUG1ZRERsU0dUcGZsUHArU0FFWDF1cWlReUUv?=
 =?utf-8?B?NEFWZ2Y1eExmTk0yb3ZIeHdFVXh1b08rZURJcUR1MUFpWTFJNXVMZGc3SXVC?=
 =?utf-8?B?Mm94RWRwRTYyazZQUUNUaGNadEpWUTRoV2kwYndNQzlCSVFPbnZSVThYY0Jz?=
 =?utf-8?B?bFFPOFQwYkVsa2lxSjFmVGRiSzhOaUw4MWc2ZCtGQUdNbktJeGZHaVhrQTdV?=
 =?utf-8?B?eGVKemp2bVJWZGJ4NTlQTWE3VmpHZUdrUGdXSmxIdnZjME14R2RrYUE2SWx0?=
 =?utf-8?B?eGR5Z2RuY0xTRGQ3WmNFK3JKaDJPL2s4YWxCaDJXMG10RTk0eWdXK2plVVh0?=
 =?utf-8?B?b21DbmRZYnEzRFZ3OGtWWkp6K0tKZU1jalIwN2ZQcWJKeG15QktUZFN0aGtr?=
 =?utf-8?B?a2tMM3h1ZnNOWHNZTzJVdE9QOURxWlgybGFpQk1ybUU2NDRVSzhyY2hreHRV?=
 =?utf-8?B?RmMvOVZNSjN2QnFxVTBibkxOVVp6dlpBZFZvVHh2cURjZXRkVEliYXRlSmhX?=
 =?utf-8?B?Q0dSaFJORHZ5UDl0ZUJMeE0xcW8vVFJTNWQ2VmN6cFJBZ0lCaTFEQVVsakxv?=
 =?utf-8?B?dHAxWmRzN0d1c2c3QmNwYmxuRkFCNnJuL0ZaRjBidExWQWVUdFA1dmgyZm51?=
 =?utf-8?B?NjZsamRGcWJCc0MxWnBHUmNVL0lpQlljSjFEU2VmamhDa0RIaG81OVlnc2pt?=
 =?utf-8?B?MEE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0DD29BEFE6F8124B85282AF7EDF88A44@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5acc3a05-b05c-4006-68fa-08daf3d863e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jan 2023 13:33:14.0407
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xOltunrPeGWU2FqBRFsLV8uk46voZkKGPrIGImGd/9hTfd9XHtp+1A65aH6r0Ztd6/5Mpy3UgFDKA6aMF+Hk0eqe67r7d0Go0ugPM2PQtCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5594
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

SGVsbG8gU2VyZ2V5LA0Kc29ycnkgZm9yIHRoZSBsYXRlIHJlc3BvbnNlLCBwbGVhc2UgY2hlY2sg
Zm9sbG93aW5nIHJlcGx5Lg0KDQpPbiBTYXQsIDIwMjItMTItMTcgYXQgMDA6NDAgKzA0MDAsIFNl
cmdleSBSeWF6YW5vdiB3cm90ZToNCj4gSGVsbG8gWWFuY2hhbywNCj4gDQo+IE9uIDA3LjEyLjIw
MjIgMDY6MzMsIFlhbmNoYW8gWWFuZyAo5p2o5b2m6LaFKSB3cm90ZToNCj4gPiBPbiBTdW4sIDIw
MjItMTItMDQgYXQgMjI6NTIgKzA0MDAsIFNlcmdleSBSeWF6YW5vdiB3cm90ZToNCj4gPiA+IE9u
IDIyLjExLjIwMjIgMTU6MTEsIFlhbmNoYW8gWWFuZyB3cm90ZToNCj4gPiA+ID4gUmVnaXN0ZXJz
IHRoZSBUTUkgZGV2aWNlIGRyaXZlciB3aXRoIHRoZSBrZXJuZWwuIFNldCB1cCBhbGwgdGhlDQo+
ID4gPiA+IGZ1bmRhbWVudGFsDQo+ID4gPiA+IGNvbmZpZ3VyYXRpb25zIGZvciB0aGUgZGV2aWNl
OiBQQ0llIGxheWVyLCBNb2RlbSBIb3N0IENyb3NzDQo+ID4gPiA+IENvcmUNCj4gPiA+ID4gSW50
ZXJmYWNlDQo+ID4gPiA+IChNSENDSUYpLCBSZXNldCBHZW5lcmF0aW9uIFVuaXQgKFJHVSksIG1v
ZGVtIGNvbW1vbiBjb250cm9sDQo+ID4gPiA+IG9wZXJhdGlvbnMgYW5kDQo+ID4gPiA+IGJ1aWxk
IGluZnJhc3RydWN0dXJlLg0KPiA+ID4gPiANCj4gPiA+ID4gKiBQQ0llIGxheWVyIGNvZGUgaW1w
bGVtZW50cyBkcml2ZXIgcHJvYmUgYW5kIHJlbW92YWwsIE1TSS1YDQo+ID4gPiA+IGludGVycnVw
dA0KPiA+ID4gPiBpbml0aWFsaXphdGlvbiBhbmQgZGUtaW5pdGlhbGl6YXRpb24sIGFuZCB0aGUg
d2F5IG9mIHJlc2V0dGluZw0KPiA+ID4gPiB0aGUNCj4gPiA+ID4gZGV2aWNlLg0KPiA+ID4gPiAq
IE1IQ0NJRiBwcm92aWRlcyBpbnRlcnJ1cHQgY2hhbm5lbHMgdG8gY29tbXVuaWNhdGUgZXZlbnRz
IHN1Y2gNCj4gPiA+ID4gYXMNCj4gPiA+ID4gaGFuZHNoYWtlLA0KPiA+ID4gPiBQTSBhbmQgcG9y
dCBlbnVtZXJhdGlvbi4NCj4gPiA+ID4gKiBSR1UgcHJvdmlkZXMgaW50ZXJydXB0IGNoYW5uZWxz
IHRvIGdlbmVyYXRlIG5vdGlmaWNhdGlvbnMNCj4gPiA+ID4gZnJvbQ0KPiA+ID4gPiB0aGUgZGV2
aWNlDQo+ID4gPiA+IHNvIHRoYXQgdGhlIFRNSSBkcml2ZXIgY291bGQgZ2V0IHRoZSBkZXZpY2Ug
cmVzZXQuDQo+ID4gPiA+ICogTW9kZW0gY29tbW9uIGNvbnRyb2wgb3BlcmF0aW9ucyBwcm92aWRl
IHRoZSBiYXNpYyByZWFkL3dyaXRlDQo+ID4gPiA+IGZ1bmN0aW9ucyBvZg0KPiA+ID4gPiB0aGUg
ZGV2aWNlJ3MgaGFyZHdhcmUgcmVnaXN0ZXJzLCBtYXNrL3VubWFzay9nZXQvY2xlYXINCj4gPiA+
ID4gZnVuY3Rpb25zIG9mDQo+ID4gPiA+IHRoZQ0KPiA+ID4gPiBkZXZpY2UncyBpbnRlcnJ1cHQg
cmVnaXN0ZXJzIGFuZCBpbnF1aXJ5IGZ1bmN0aW9ucyBvZiB0aGUNCj4gPiA+ID4gZGV2aWNlJ3MN
Cj4gPiA+ID4gc3RhdHVzLg0KPiA+ID4gPiANCj4gPiA+ID4gU2lnbmVkLW9mZi1ieTogVGluZyBX
YW5nIDx0aW5nLndhbmdAbWVkaWF0ZWsuY29tPg0KPiA+ID4gPiBTaWduZWQtb2ZmLWJ5OiBNZWRp
YVRlayBDb3Jwb3JhdGlvbiA8bGludXh3d2FuQG1lZGlhdGVrLmNvbT4NCj4gPiA+ID4gLS0tDQo+
ID4gPiA+ICAgIGRyaXZlcnMvbmV0L3d3YW4vS2NvbmZpZyAgICAgICAgICAgICAgICAgfCAgIDEx
ICsNCj4gPiA+ID4gICAgZHJpdmVycy9uZXQvd3dhbi9NYWtlZmlsZSAgICAgICAgICAgICAgICB8
ICAgIDEgKw0KPiA+ID4gPiAgICBkcml2ZXJzL25ldC93d2FuL21lZGlhdGVrL01ha2VmaWxlICAg
ICAgIHwgICAxMiArDQo+ID4gPiA+ICAgIGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvbXRrX2Nv
bW1vbi5oICAgfCAgIDMwICsNCj4gPiA+ID4gICAgZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9t
dGtfZGV2LmMgICAgICB8ICAgNTAgKw0KPiA+ID4gPiAgICBkcml2ZXJzL25ldC93d2FuL21lZGlh
dGVrL210a19kZXYuaCAgICAgIHwgIDUwMyArKysrKysrKysrDQo+ID4gPiA+ICAgIGRyaXZlcnMv
bmV0L3d3YW4vbWVkaWF0ZWsvcGNpZS9tdGtfcGNpLmMgfCAxMTY0DQo+ID4gPiA+ICsrKysrKysr
KysrKysrKysrKysrKysNCj4gPiA+ID4gICAgZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9wY2ll
L210a19wY2kuaCB8ICAxNTAgKysrDQo+ID4gPiA+ICAgIGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0
ZWsvcGNpZS9tdGtfcmVnLmggfCAgIDY5ICsrDQo+ID4gPiA+ICAgIDkgZmlsZXMgY2hhbmdlZCwg
MTk5MCBpbnNlcnRpb25zKCspDQo+ID4gPiA+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L25ldC93d2FuL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gPiA+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0
NCBkcml2ZXJzL25ldC93d2FuL21lZGlhdGVrL210a19jb21tb24uaA0KPiA+ID4gPiAgICBjcmVh
dGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9tdGtfZGV2LmMNCj4gPiA+
ID4gICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbmV0L3d3YW4vbWVkaWF0ZWsvbXRrX2Rl
di5oDQo+ID4gPiA+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL25ldC93d2FuL21lZGlh
dGVrL3BjaWUvbXRrX3BjaS5jDQo+ID4gPiA+ICAgIGNyZWF0ZSBtb2RlIDEwMDY0NCBkcml2ZXJz
L25ldC93d2FuL21lZGlhdGVrL3BjaWUvbXRrX3BjaS5oDQo+ID4gPiA+ICAgIGNyZWF0ZSBtb2Rl
IDEwMDY0NCBkcml2ZXJzL25ldC93d2FuL21lZGlhdGVrL3BjaWUvbXRrX3JlZy5oDQo+ID4gPiA+
IA0KPiA+ID4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd3dhbi9LY29uZmlnDQo+ID4gPiA+
IGIvZHJpdmVycy9uZXQvd3dhbi9LY29uZmlnDQo+ID4gPiA+IGluZGV4IDM0ODZmZmU5NGFjNC4u
YTkzYTBjNTExZDUwIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC93d2FuL0tjb25m
aWcNCj4gPiA+ID4gKysrIGIvZHJpdmVycy9uZXQvd3dhbi9LY29uZmlnDQo+ID4gPiA+IEBAIC0x
MTksNiArMTE5LDE3IEBAIGNvbmZpZyBNVEtfVDdYWA0KPiA+ID4gPiAgICANCj4gPiA+ID4gICAg
CSAgSWYgdW5zdXJlLCBzYXkgTi4NCj4gPiA+ID4gICAgDQo+ID4gPiA+ICtjb25maWcgTVRLX1RN
SQ0KPiA+ID4gPiArCXRyaXN0YXRlICJUTUkgRHJpdmVyIGZvciBNZWRpYXRlayBULXNlcmllcyBE
ZXZpY2UiDQo+ID4gPiA+ICsJZGVwZW5kcyBvbiBQQ0kNCj4gPiA+ID4gKwloZWxwDQo+ID4gPiA+
ICsJICBUaGlzIGRyaXZlciBlbmFibGVzIE1lZGlhdGVrIFQtc2VyaWVzIFdXQU4gRGV2aWNlDQo+
ID4gPiA+IGNvbW11bmljYXRpb24uDQo+ID4gPiA+ICsNCj4gPiA+ID4gKwkgIElmIHlvdSBoYXZl
IG9uZSBvZiB0aG9zZSBNZWRpYXRlayBULXNlcmllcyBXV0FODQo+ID4gPiA+IE1vZHVsZXMgYW5k
DQo+ID4gPiA+IHdpc2ggdG8NCj4gPiA+ID4gKwkgIHVzZSBpdCBpbiBMaW51eCBzYXkgWS9NIGhl
cmUuDQo+ID4gPiANCj4gPiA+IEZyb20gdGhpcyBhbmQgdGhlIHNlcmllcyBkZXNjcmlwdGlvbnMs
IGl0IGlzIHVuY2xlYXIgd2hpY2ggbW9kZW0NCj4gPiA+IGNoaXBzIHRoaXMgZHJpdmVyIGlzIGlu
dGVuZGVkIGZvciBhbmQgaG93IGRvZXMgaXQgY29ycmVsYXRlIHdpdGgNCj4gPiA+IHRoZQ0KPiA+
ID4gVDd4eCBkcml2ZXI/IElzIHRoZSBUTUkgZHJpdmVyIGEgZHJvcC1pbiByZXBsYWNlbWVudCBm
b3IgdGhlIHQ3eHgNCj4gPiA+IGRyaXZlciwNCj4gPiA+IG9yIGRvZXMgdGhlIFRNSSBkcml2ZXIg
c3VwcG9ydCBhbnkgVC1zZXJpZXMgY2hpcHMgZXhjZXB0IHQ3eHg/DQo+ID4gPiBUaGUgZHJpdmVy
IGlzIGludGVuZGVkIGZvciB0OHh4IG9yIGxhdGVyIFQtc2VyaWVzIG1vZGVtIGNoaXBzIGluDQo+
ID4gPiB0aGUNCj4gPiANCj4gPiBmdXR1cmUuIEN1cnJlbnRseSwgdDd4eCBpcyBub3Qgc3VwcG9y
dC4NCj4gDQo+IENhbiB5b3UgYWRkIHRoaXMgaW5mb3JtYXRpb24gdG8gdGhlIG9wdGlvbiBkZXNj
cmlwdGlvbiB0byBtYWtlIGl0DQo+IGVhc2llciANCj4gZm9yIHVzZXJzIHRvIGNob29zZT8NCj4g
DQo+IEJUVywganVzdCBjdXJpb3VzLCBkbyB5b3UgaGF2ZSBhbnkgcGxhbnMgdG8gYWRkIFQ3eHgg
c3VwcG9ydCB0byB0aGUNCj4gVE1JIA0KPiBkcml2ZXIsIG9yIG1heWJlIG1lcmdlIHRoZW0gb3Ig
ZmFjdG9yIG91dCB0aGUgY29tbW9uIGNvZGUgaW50byBhDQo+IGNvbW1vbiANCj4gbGlicmFyeT8g
SSBhbSBhc2tpbmcgYmVjYXVzZSBJIG5vdGljZWQgc29tZSBjb21tb24gY29kZSBhbmQgbW9kZW0g
DQo+IGNvbXBvbmVudHMsIGJ1dCB0aGF0IGlzIG5vdCBhZGRyZXNzZWQgaW4gdGhlIGNvdmVyIGxl
dHRlci4gT3IgaXMNCj4gdGhpcyANCj4gZmVlbGluZyBtaXNsZWFkaW5nIGFuZCB0aGVzZSB0d28g
c2VyaWVzIGFyZSB2ZXJ5IGRpZmZlcmVudD8NCj4gDQpTdXJlLCBuZXh0IHZlcnNpb24gKHYyKSwg
d2Ugd2lsbCBhZGQgZGVzY3JpcHRpb24sICJUTUkgaXMgaW50ZW5kZWQgZm9yDQp0OHh4IFQtc2Vy
aWVzIG1vZGVtIGNoaXBzLiBDdXJyZW50bHksIHQ3eHggaXMgbm90IHN1cHBvcnRlZCIsIHRvIG1h
a2UNCm9wdGlvbiBzZWxlY3Rpb24gbW9yZSBjbGVhcmx5LiBZZXMsIHdlIGhhdmUgYSBwbGFuIHRv
IHN1cHBvcnQgdDd4eA0KYWZ0ZXIgVE1JIGRyaXZlciBpcyBhcHByb3ZlZCBhbmQgbWVyZ2VkLiBE
aXNjdXNzZWQgd2l0aCB0N3h4wqHCr3MNCm1haW50YWluZXIgKEludGVsKSwgTVRLIHdpbGwgc3Vi
bWl0IGEgbmV3IHBhdGNoIHRvIHN1cHBvcnQgdDd4eCBiYXNlZA0Kb24gVE1JIGRyaXZlci4gDQpC
VFcsIHdlIHJlY2VpdmUgbWFueSBjb21tZW50cyBmcm9tIHBhdGNoIDEgYW5kIHBhdGNoIDIuIEhv
dyBhYm91dCBvdGhlcg0KcGF0Y2hlcyAocGF0Y2ggM35wYXRjaCAxMyk/IERvIHlvdSBoYXZlIGFu
eSBzdWdnZXN0aW9uIHRoYXQgd2Ugc2hvdWxkDQp3YWl0IGZlZWRiYWNrIG9uIG90aGVyIHBhdGNo
ZXMgb3Igc3RhcnQgdG8gc3VibWl0IG5leHQgdmVyc2lvbj8NCg0KbWFueSB0aGFua3MuDQp5YW5j
aGFvLnlhbmcNCj4gPiA+ID4gKw0KPiA+ID4gPiArCSAgSWYgdW5zdXJlLCBzYXkgTi4NCj4gPiA+
ID4gKw0KPiA+ID4gPiAgICBlbmRpZiAjIFdXQU4NCj4gPiA+ID4gICAgDQo+ID4gPiA+ICAgIGVu
ZG1lbnUNCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3d3YW4vTWFrZWZpbGUNCj4g
PiA+ID4gYi9kcml2ZXJzL25ldC93d2FuL01ha2VmaWxlDQo+ID4gPiA+IGluZGV4IDM5NjBjMGFl
MjQ0NS4uMTk4ZDgwNzQ4NTFmIDEwMDY0NA0KPiA+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC93d2Fu
L01ha2VmaWxlDQo+ID4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3d3YW4vTWFrZWZpbGUNCj4gPiA+
ID4gQEAgLTE0LDMgKzE0LDQgQEAgb2JqLSQoQ09ORklHX1FDT01fQkFNX0RNVVgpICs9DQo+ID4g
PiA+IHFjb21fYmFtX2RtdXgubw0KPiA+ID4gPiAgICBvYmotJChDT05GSUdfUlBNU0dfV1dBTl9D
VFJMKSArPSBycG1zZ193d2FuX2N0cmwubw0KPiA+ID4gPiAgICBvYmotJChDT05GSUdfSU9TTSkg
Kz0gaW9zbS8NCj4gPiA+ID4gICAgb2JqLSQoQ09ORklHX01US19UN1hYKSArPSB0N3h4Lw0KPiA+
ID4gPiArb2JqLSQoQ09ORklHX01US19UTUkpICs9IG1lZGlhdGVrLw0KPiA+ID4gDQo+ID4gPiBU
aGUgZHJpdmVyIGlzIGNhbGxlZCBtdGtfdG1pLCBidXQgaXRzIGNvZGUgaXMgcGxhY2VkIHRvIHRo
ZQ0KPiA+ID4gZGlyZWN0b3J5DQo+ID4gPiB3aXRoIHRvbyBnZW5lcmljIG5hbWUgJ21lZGlhdGVr
Jy4gRG8geW91IHBsYW4gdG9vIGtlZXAgYWxsDQo+ID4gPiBwb3NzaWJsZQ0KPiA+ID4gZnV0dXJl
IGRyaXZlcnMgaW4gdGhpcyBkaXJlY3Rvcnk/ID4NCj4gPiANCj4gPiBZZXMsIHdlIHBsYW4gdG8g
cHV0IGFsbCBtZWRpYXRlaydzIHd3YW4gZHJpdmVyIGludG8gdGhlIHNhbWUNCj4gPiBkaXJlY3Rv
cnkuDQo+ID4gQ3VycmVudGx5LCB0aGVyZSBpcyBvbmx5IFQtc2VyaWVzIG1vZGVtIGRyaXZlci4g
U28gd2UgZG9uJ3QgY3JlYXRlDQo+ID4gJ3RtaScgZm9sZGVyIHVuZGVyICdtZWRpYXRlaycgZGly
ZWN0b3J5IGV4cGxpY2l0bHkuDQo+IA0KPiBUaGFuayB5b3UgZm9yIHRoZSBjbGFyaWZpY2F0aW9u
Lg0KPiANCj4gLS0NCj4gU2VyZ2V5DQo=
