Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29636B1AC6
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 06:31:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbjCIFbk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 00:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229919AbjCIFa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 00:30:57 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 113D45CEC2;
        Wed,  8 Mar 2023 21:30:47 -0800 (PST)
X-UUID: 8a3a4788be3b11eda06fc9ecc4dadd91-20230309
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=IdKebhelVPMPtXIJ8Bu6o7xqVDsrfHvxcs4HeKJeDH8=;
        b=it84C7Rn2d7nHC8lZTtYk1VFlZMNlIXbm3M7D7V+i4ixWDH7t01zf2EUzEPREJMwgOQJkF8dINs3/8S7PCkQyu8DrMSKDSTpTCzIcARXicqYFhjydqmlmQDcDanXzwzuJ3he+XKOQweCwnbE4NjubHjYq5mbzZwvW0QWv6En7cI=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:77fe51a7-baa7-4bfa-a667-5b7a44f16900,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:34773df5-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: 8a3a4788be3b11eda06fc9ecc4dadd91-20230309
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw01.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1520450484; Thu, 09 Mar 2023 13:30:44 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 9 Mar 2023 13:30:43 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 9 Mar 2023 13:30:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KGu5bQvEorrOKrB18lR9snKoh3r8vvPHn281uW8SfX7PuInMT43eVI/a4ncGbPz3TKgQyudfVwfYD0lMiqfVyJA1ecXL3UbsTzV8K1uBPpRoiTAZwXWe+5EApr6dkDzgGv5TxMtC4Pya/qbAxkvv9gt35UBr+6mdYIHfEas7tvzN/ASbBINjzVksNUT9EqkkACe3yo1jP/Xj67KNqUDm+bfsPQGI/U4kJO/7+teUOF+Wn/u9dpIPYUDfPotfkI5sCTQ5a3bplDvLGWvDv2+ozfvmuAolPBVz0LYoT9WbLp7/m/JdILs0W4Q3WOB3fjeaM6LQdJaQkplNPk0zzo0GGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=IdKebhelVPMPtXIJ8Bu6o7xqVDsrfHvxcs4HeKJeDH8=;
 b=XB67nVlu6bX+7BC6xtq5eRuqgBdxSUn2MLAKAo9/g7EpLu6T9n8LSq2VdFFs0jRE+aJyOyZaiW5E4H2FoT2QF53GsNqzMVc+KH4/ZelRMYWsWfdDXckFf9nIAXyz/lNXnCtYow7aO0dIYAZRTerGHXh2dzpJ0piwdCaUyfjOkYZm9gXt59in4ewzXO+cdMvVZ38uvM7v5EbhIt3jVPliHc/t4GHcSUA9cVspihY98gow1MQ+9ZFR3rIsTS+v4M+mDwbLDPwAClOFBxJz5Ad4oPYEupOzaYUpXK8DMNh3tshk3dS5IORyfreURB2bRblc2IGMkHJtgucKs6LyHnRWzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IdKebhelVPMPtXIJ8Bu6o7xqVDsrfHvxcs4HeKJeDH8=;
 b=dap5vZYs5nZocwMiL4j3V2yR85X2H2EmYs3xMczqNoGA2uzbyAHVmO2BNNFymcbFtsKVMpsVpDJe8kgtv0GpJhfUnrkAkCOCsUqDuLCcEA88AvTt/03a7p7LDnK7/B1f6ftMdFykGAEsR81PeGFIIxhH6cmQYPY0i5WvTze/MsI=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by TY0PR03MB6388.apcprd03.prod.outlook.com (2603:1096:400:14d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.18; Thu, 9 Mar
 2023 05:30:41 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 05:30:41 +0000
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
Subject: Re: [PATCH v5 10/19] clk: mediatek: Add MT8188 mfgcfg clock support
Thread-Topic: [PATCH v5 10/19] clk: mediatek: Add MT8188 mfgcfg clock support
Thread-Index: AQHZLAR76JqVjwXo0UuKYengHMVEJ6684uKAgDVVpwA=
Date:   Thu, 9 Mar 2023 05:30:41 +0000
Message-ID: <3a4ab2f1da5f3d8a8bf6d2f4e3574d3a2708e229.camel@mediatek.com>
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
         <20230119124848.26364-11-Garmin.Chang@mediatek.com>
         <CAGXv+5FGCVSihGu5diCQ1Q=jPRHz7RQ2KrXk-13LL4z1wbkfjg@mail.gmail.com>
In-Reply-To: <CAGXv+5FGCVSihGu5diCQ1Q=jPRHz7RQ2KrXk-13LL4z1wbkfjg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|TY0PR03MB6388:EE_
x-ms-office365-filtering-correlation-id: 084cc3c4-1a40-4dc2-8b91-08db205f6c57
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r2tRnoL82W50wO3+xTlsum7w6eS99FjJ0HPDTh9pzEyP8rh7UF/pzXjw3swHdKYJQ3W9ABMe3FsJ2fXRr8sCw+ztDYvZDK2RRj1Aw9KI5Al1y/yMVCP7s59ROXqjFqgMFClP1iwzNxQy55m+mpUEUavVAELU0j2p7V0a/lZdCFuGLXEwxf79WrUeQLTLWhHXwqB7cuS+2ljOaniQfsGaFyNVAOGxM9TAbSay+BCy0yaOaEoQ9J6yDDWU54IF7sIQQ6FOcpEVp7K6b4IZcNXV84T+FDXq02x1KYqTO/gD9ltQjtW6kVq7S9wcPDfgrp3C5jJUd+2I1cLVFS2nnIsBtKr5SED/aICG7kKHCb8Holo1fXK4aZgdlnL661+4CD8udwxkoseZruefNnBtp/fKqz9FDa82JuWJqNfCGM3wfOMoLJAuaBEzlx27LDU577mQHkxPonXMFRnCqacsCtNUnL6enehP5r4CQ9mHEHn8e7jj2k+oePF1JsOs4LKNiRN8VoHZCQ/cqqppr24LSMQ23upqQAZKpV+hVVAlNZTI4hoV1g/ntvi2QswSH5Kz1LC2NV3Q4HumGEEO2LtvsZiNk2lNLXE75CwnC2zoQ7K1DR6edyBtmjyyLrNZcAMQCfITBc4Or7plawDjA5H6BrDEncmAhMgBQNmWXLGZ1zOsDwolcxjdH7hutFrM9zzyFtuZZJOmxi3bXgYGN7ueFOxJeIeWdlU0HmdhCqqH5dahe9k=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(39860400002)(346002)(376002)(366004)(396003)(451199018)(38070700005)(2906002)(7416002)(5660300002)(26005)(8936002)(36756003)(85182001)(66446008)(41300700001)(66556008)(66476007)(4326008)(66946007)(64756008)(76116006)(6916009)(316002)(91956017)(8676002)(86362001)(54906003)(71200400001)(478600001)(6486002)(38100700002)(122000001)(6506007)(6512007)(53546011)(186003)(2616005)(83380400001)(40753002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZDZMUklwb2ZsNFpyTlZuVEFwblNtT041Y29rclVzeFNheXFjNW14R2t1RlIz?=
 =?utf-8?B?TTdYUUt3Vy85VWNZUkxYN1grdStRK0crZnVVaTBJYm8xSXBoK2VUTnhaNXRT?=
 =?utf-8?B?SzNPUzkxZHhZN2VOUW8rODMydCs5cTBxbmhrQ282dVBtb0hMN3dlcm1ydWZi?=
 =?utf-8?B?OXJoZjJHZjAzS05VVjNzdXhNTVRQK2h2U1dpR2pvT0tQS0pzaVBTeVV1ZjFv?=
 =?utf-8?B?ai90RlFMZ2hhOXFNZkNYc2liMkZOREpQcGIrOWdhY0ZqcGYyNllXa2JBb0xt?=
 =?utf-8?B?TGEvQUtpSnBpZUlwQ2xvMFIvR3hpQ1lyeG11NXFhaCtIQ2tEUFVQOXJxQW9r?=
 =?utf-8?B?cXlRVWYraFB6Y0ljUHhqMm11MTlURFpFR0FzRW1qUGhqcmNIcHdzSHU5R2xO?=
 =?utf-8?B?NG1aSlc1YjF5R1hWMCtvamFrQ1ZDUGZlNWhqOW1KTUFwaHJXd1VBWHF5MDh3?=
 =?utf-8?B?SkM4U3UyeVBDNVBDRDAxTFBacW9jb3FieFJ2V0p5YXJGMzlwNXR2dzMrMnB2?=
 =?utf-8?B?NjdXa2xoS1RuMG9DTkoxcFVIZ1dOSSttYTZBT01YQ3VCdVFOb3pXeW1OUk5F?=
 =?utf-8?B?NkJvbjUvVGV3S3RjK2FmZWNXMWp0d1BtSkN2aGZKeVZPWlpWczhxU1VQd0Qx?=
 =?utf-8?B?dG5IVUJpU2dTbjFMWUVVK3Jta1F6a3RQM3lwcW9HQy9TalV3YVJNdm83N0ZQ?=
 =?utf-8?B?Q1NqcGdlemR0Y2hwQVpoMEtKSVRFNDhkY0RHdUR3eHcvT1l0OUZ0Nkp3ek50?=
 =?utf-8?B?UzBhYWhDelBYLzVFS3YvcVBjY05qVkJqVUcwRVh5bnV6Q0RaRmd5by9rZ0hw?=
 =?utf-8?B?S0ZLQlgxdUVSODU2RXJEZlB5SUVqT1F6Ukd4SDRCTDdTbEJsbVRJQmNLcFZ2?=
 =?utf-8?B?dU52SGRUU0wxaU9KbjVZOHFCdEp6MlU5dlYyNXduOHRYVkFhNnlkZ1RoZHBP?=
 =?utf-8?B?ZTJVVGl2TUNINEVoWXYvd0JUMjlabXlUK1BhMVdqanBBdWhqMFVLTjRseWhu?=
 =?utf-8?B?Rmt2R3Rwc0wvOHBtUGlTbFljREU1OVBCMmNoWVI0eFFZWkUxc1FqWjR5SU56?=
 =?utf-8?B?cmltejdNUnNlRmVlb3pGVTBES1ZXT3lkdGpQeEVhWHQwU1FkbVJPNVFveXZE?=
 =?utf-8?B?M2I5dm9lSkNlZERVa2FGWW00UUFvSXl1OFRJVSt0ekxHVHE3S2xSZkhYdm1T?=
 =?utf-8?B?cEZuRi84akw2aE5PVmk1MktrTFRrTVdnc05QcHdkK2szajNMN2RWZGNIbFd3?=
 =?utf-8?B?dnd5aG41R1BwcXpYNVNVRS92RVczVzFqUU03cmNEOFBOdjJKTCtsak1iando?=
 =?utf-8?B?M3pyR09XaklwWWlFVzgxOGdOOEU0N3VzOXUwSnR1YXF6VU04Z0JyOEp5MDVE?=
 =?utf-8?B?cnpVcytTdXJzYnZUalNXS2t1YzZDTUdGZlhJYmN3YVo5a0NFcWw4YWZvb3Nv?=
 =?utf-8?B?anlLdzc3dFhRWWt2VXlnVFU1Y2xjeUJCdkFZWkIrd0lNUFVaSUU3c3FSZnJx?=
 =?utf-8?B?Wk1icHBvaWVEOElyNGY4YUE5YVFpRndCMjJmMFdUZFA4dENuK2pTSHRKOUxu?=
 =?utf-8?B?UEFqK3U0ZWFFaDR5SW1kZXcrZmVkeGI0WWo1bWdkMnB3cnkzR1BXMVhTVnBk?=
 =?utf-8?B?R05SRlhsY2VkRDdxdVRLZUZzelpYTTF4UHJrbmtMb3pHcC9sQ3UrdzIwVmVP?=
 =?utf-8?B?RmpNUUh1Mm1BODJCbkZEbEpoYnpKN01kRWM1dG1ENjVMM3RVaEZBVVJGS3lQ?=
 =?utf-8?B?dmFtNkt5MlhpeHF0RHRkN1NPR3RBOVlFaTAxZ3p2RURoeTQ4cXZGR09GOHd0?=
 =?utf-8?B?SG9VcFlxdjZldnJPZlhaYXkvVWpJRE9jakpsOUJ1Z1BudjlyaFV6aTF2eGRo?=
 =?utf-8?B?UXFMbHZMUVU4SVpIa0c4Z3JsdlFPVUpBMjhjdGFObW01YTRHazFhV2hvNVZT?=
 =?utf-8?B?UURvQXRCZm1pMXNGTDBzWmRNUVJ0c2VqaFZYbHorRTliNlVhaXpBOVl5SThz?=
 =?utf-8?B?blowOWl2M2R4dElKTDRDZ0t6RGt0bk1JdEJobklIVnpnUmFOUlRNNGhyUGV2?=
 =?utf-8?B?VTByTDN2VkYySWthVVkrWmlQZHI0QUdXaFBEckl0MW4yRllpYXQ1c053VFBO?=
 =?utf-8?B?dTl6UnFKRkxCVW5qcjFqZGFLUlFKcjhreWVEcjBFS3lxbzY4eDI3U3d3S1pw?=
 =?utf-8?B?bFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <38E0490536A98F4CAF0E65469B0CBDC2@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 084cc3c4-1a40-4dc2-8b91-08db205f6c57
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 05:30:41.4246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hq8OfKOn7Ex1PSnILDeC+JqP+cg2uAIe5vRnKYsukN+ppQliw3l1C5Gs1vUa6BRbfbDwxJFz7PdtwGa8k4zmO1kZfqSx79Bm2rCZ3wSr5yM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY0PR03MB6388
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDE1OjAyICswODAwLCBDaGVuLVl1IFRzYWkgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDE5LCAyMDIzIGF0IDg6NTAgUE0gR2FybWluLkNoYW5nIDwNCj4gR2FybWlu
LkNoYW5nQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIE1UODE4OCBtZmcgY2xv
Y2sgY29udHJvbGxlciB3aGljaCBwcm92aWRlcyBjbG9jayBnYXRlDQo+ID4gY29udHJvbCBmb3Ig
R1BVLg0KPiA+IA0KPiA+IFNpZ25lZC1vZmYtYnk6IEdhcm1pbi5DaGFuZyA8R2FybWluLkNoYW5n
QG1lZGlhdGVrLmNvbT4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZp
bGUgICAgICAgICB8ICAyICstDQo+ID4gIGRyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgt
bWZnLmMgfCA0Nw0KPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysrKw0KPiA+ICAyIGZpbGVz
IGNoYW5nZWQsIDQ4IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPiAgY3JlYXRlIG1v
ZGUgMTAwNjQ0IGRyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtbWZnLmMNCj4gPiANCj4g
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4gPiBiL2RyaXZl
cnMvY2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gaW5kZXggNGE1OTkxMjJmNzYxLi5hMGZkODdh
ODgyYjUgMTAwNjQ0DQo+ID4gLS0tIGEvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4g
PiArKysgYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+IEBAIC04Niw3ICs4Niw3
IEBAIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE4NikgKz0gY2xrLW10ODE4Ni0NCj4gPiBt
Y3UubyBjbGstbXQ4MTg2LXRvcGNrZ2VuLm8gY2xrLW10DQo+ID4gIG9iai0kKENPTkZJR19DT01N
T05fQ0xLX01UODE4OCkgKz0gY2xrLW10ODE4OC1hcG1peGVkc3lzLm8gY2xrLQ0KPiA+IG10ODE4
OC10b3Bja2dlbi5vIFwNCj4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNs
ay1tdDgxODgtcGVyaV9hby5vIGNsay1tdDgxODgtDQo+ID4gaW5mcmFfYW8ubyBcDQo+ID4gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGstbXQ4MTg4LWNhbS5vIGNsay1tdDgx
ODgtDQo+ID4gY2N1Lm8gY2xrLW10ODE4OC1pbWcubyBcDQo+ID4gLSAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBjbGstbXQ4MTg4LWlwZS5vDQo+ID4gKyAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBjbGstbXQ4MTg4LWlwZS5vIGNsay1tdDgxODgtDQo+ID4gbWZnLm8N
Cj4gPiAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyKSArPSBjbGstbXQ4MTkyLm8NCj4g
PiAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtfTVQ4MTkyX0FVRFNZUykgKz0gY2xrLW10ODE5Mi1h
dWQubw0KPiA+ICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJfQ0FNU1lTKSArPSBjbGst
bXQ4MTkyLWNhbS5vDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1t
dDgxODgtbWZnLmMNCj4gPiBiL2RyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgtbWZnLmMN
Cj4gPiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uNTdiMGFm
YjVmNGRmDQo+ID4gLS0tIC9kZXYvbnVsbA0KPiA+ICsrKyBiL2RyaXZlcnMvY2xrL21lZGlhdGVr
L2Nsay1tdDgxODgtbWZnLmMNCj4gPiBAQCAtMCwwICsxLDQ3IEBADQo+ID4gKy8vIFNQRFgtTGlj
ZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gPiArLy8NCj4gPiArLy8gQ29weXJpZ2h0
IChjKSAyMDIyIE1lZGlhVGVrIEluYy4NCj4gPiArLy8gQXV0aG9yOiBHYXJtaW4gQ2hhbmcgPGdh
cm1pbi5jaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gKw0KPiA+ICsjaW5jbHVkZSA8bGludXgvY2xr
LXByb3ZpZGVyLmg+DQo+ID4gKyNpbmNsdWRlIDxsaW51eC9wbGF0Zm9ybV9kZXZpY2UuaD4NCj4g
PiArI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1jbGsuaD4NCj4g
PiArDQo+ID4gKyNpbmNsdWRlICJjbGstZ2F0ZS5oIg0KPiA+ICsjaW5jbHVkZSAiY2xrLW10ay5o
Ig0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtfZ2F0ZV9yZWdzIG1mZ2NmZ19j
Z19yZWdzID0gew0KPiA+ICsgICAgICAgLnNldF9vZnMgPSAweDQsDQo+ID4gKyAgICAgICAuY2xy
X29mcyA9IDB4OCwNCj4gPiArICAgICAgIC5zdGFfb2ZzID0gMHgwLA0KPiA+ICt9Ow0KPiA+ICsN
Cj4gPiArI2RlZmluZSBHQVRFX01GRyhfaWQsIF9uYW1lLCBfcGFyZW50LA0KPiA+IF9zaGlmdCkg
ICAgICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiArICAgICAgIEdBVEVfTVRLX0ZMQUdTKF9p
ZCwgX25hbWUsIF9wYXJlbnQsICZtZmdjZmdfY2dfcmVncywNCj4gPiBfc2hpZnQsICAgIFwNCj4g
PiArICAgICAgICAgICAgICAgICAgICAgICZtdGtfY2xrX2dhdGVfb3BzX3NldGNsciwNCj4gPiBD
TEtfU0VUX1JBVEVfUEFSRU5UKQ0KPiA+ICsNCj4gPiArc3RhdGljIGNvbnN0IHN0cnVjdCBtdGtf
Z2F0ZSBtZmdjZmdfY2xrc1tdID0gew0KPiA+ICsgICAgICAgR0FURV9NRkcoQ0xLX01GR0NGR19C
RzNELCAibWZnY2ZnX2JnM2QiLA0KPiA+ICJ0b3BfbWZnX2NvcmVfdG1wIiwgMCksDQo+IA0KPiBB
cmUgeW91IHN1cmUgdGhlIHBhcmVudCBpc24ndCAibWZnX2NrX2Zhc3RfcmVmIj8NCg0KVGhhbmsg
eW91IGZvciB5b3VyIHN1Z2dlc3Rpb25zLiANCk9LLCBJIHdpbGwgY2huYWdlIHRvIG1mZ19ja19m
YXN0X3JlZiBpbiB2Ni4NCg0KPiANCj4gQ2hlbll1DQo=
