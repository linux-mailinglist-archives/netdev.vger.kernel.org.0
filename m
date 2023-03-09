Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BB46B19DE
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 04:17:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjCIDRx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 22:17:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbjCIDRv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 22:17:51 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C14FC99251;
        Wed,  8 Mar 2023 19:17:48 -0800 (PST)
X-UUID: f5ef8622be2811ed945fc101203acc17-20230309
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=6ekB0136q+AHaHDVCYN2MXJgbUOSslj7hxr+lbgi9rg=;
        b=aTi5LF1Zw+jm80G4/9qK18XTsAMtkVgPLXLQGjR113Qw96TlqvqvnsNLJ//tVf67PicJyVXFTMWqXU7Mw2KhOf/ZlNRrXgeXoG9zIYgy+QlW9YP3ngzWeUEq04VU0JBYNe2F+U4UcoFQ+S/7YAcIGrhjHSpflAkE8GtlqR9cQj0=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:c9eb3614-35f3-4aaf-b38e-a814d6b2e9e7,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:9a6a39f5-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0,NGT
X-UUID: f5ef8622be2811ed945fc101203acc17-20230309
Received: from mtkmbs11n2.mediatek.inc [(172.21.101.187)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1829616159; Thu, 09 Mar 2023 11:17:45 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 9 Mar 2023 11:17:44 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 9 Mar 2023 11:17:43 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q3UQzXNBq9Oe80rLZS9HHtEEqBbrGQBkeDEI9Xu6R7NZnWijVGh/QWekkgHbOYalapOWvmq0GlOAjWZIjzp8dRZaontONqvDWCnQmNgL3LQSxMKe3dblQyJYLAacGGy+27L6wgSKsQdoDxfkCUB3vKlZJOO8Gtk7c4fCxVdsH36AUsU3+/jk3DMhl+mYFkMVHtHaoSaPokso780UEhRDwIMSmNliHbJ+q9mEBqEZ6qziRFc+J3yQSx9BhLDuKqoQivqt0svb2dvn6qcA7L4BTosGMMJPaI3T/CFJgmeju0eTKE57L9IVo/s50hwsHGJ481RU3muDjbDDB+yEA6srUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6ekB0136q+AHaHDVCYN2MXJgbUOSslj7hxr+lbgi9rg=;
 b=nneHP/qS3+GHAf06YfV92WfuXQS0NUxzhI0iCi12NmN/SgxIKA+0x4b0HnqqlhG3Mz//infNkSJ5MfTDsS4Twf5Xuq0kpMcsMeVPeGtFg+krXKyHX6JpEwa+vcfCRluUJdRxjF6fs7xhSYVOAE5fPBYU/J7vxzR1X1vH4tE3bOTUIiOvU6FE//OkL/bjAvWE6yI9fOQbOZN3ucqjo1n4Ywvit9JtF8onjt+1CIC7uX7nJKmeyO05XwwTwEOgrR8xGkLTyfo/nSNR1qzHtQm+M9ABG4ytRe++wvb4nZY8F5+rymvj+tV73GxmfYiG6xkwR60p5v1o1xIs35nA42bgYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6ekB0136q+AHaHDVCYN2MXJgbUOSslj7hxr+lbgi9rg=;
 b=ZLd9pKme7b3aNoi28yHh2k/iu/HEnjwJ4Eo+Pkj9hmtqbv5g4DdgRd3cLF+BJMFK6cK64Aea8pt8sftYLyk/fE+eW4jhQZz92B2Sp3HHuOnVM91vEJKg7K7IRuKDu8jxnqnMLsFwHV4mOqVQnPRERICsG2jj7XgSKRLY88UTnX8=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by TYZPR03MB6470.apcprd03.prod.outlook.com (2603:1096:400:1ca::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Thu, 9 Mar
 2023 03:17:41 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 03:17:41 +0000
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
Subject: Re: [PATCH v5 19/19] clk: mediatek: Add MT8188 adsp clock support
Thread-Topic: [PATCH v5 19/19] clk: mediatek: Add MT8188 adsp clock support
Thread-Index: AQHZLAR6vSYJ4kvugU2KoZrR5FW8tK687UeAgDUmF4A=
Date:   Thu, 9 Mar 2023 03:17:40 +0000
Message-ID: <0a35db84279047ff4a6f000f80c9eed364ec1312.camel@mediatek.com>
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
         <20230119124848.26364-20-Garmin.Chang@mediatek.com>
         <CAGXv+5EW8DXXp+D_M1AU7ohrrbmU8e7eMwo5LpZb9FHWi7ELAw@mail.gmail.com>
In-Reply-To: <CAGXv+5EW8DXXp+D_M1AU7ohrrbmU8e7eMwo5LpZb9FHWi7ELAw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|TYZPR03MB6470:EE_
x-ms-office365-filtering-correlation-id: 2079d06e-cd71-4494-c164-08db204cd779
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4itRWKxufRAtKreVvt5m0LM0Uk7is1GMBRKCqUmlVs5z1pETkF7TuM+Y+E3vIgGUg+UWybLVVZmu1oy7w06nnmw7+t8ernklhVRiiM5RuspxZ8gScaDjAmt7coP1HjCm2gQ80ueE14n6+fDp4eNiInTTFFb2P1MrDE2OOwuaYtXVfvaVt/mxcT5BKnhqacWYVJSoSHl+GOFPfq8XeYVNuZp1iKGknxHReh8Y1/jCeJfcCAGxiJ/lXOXVYD9736n12JQNg228+ILRlGwXls0yRrnq2H1Pyo0Gu7GtpynQtWbKNIKU48ztDCgcWsAZ1QtrENm/Ru8eKUk0o3iH62ECBvD/L17FUgtAHwBvaGK9XTWu3NsvXsGvcUE/e5aPJXyCJTPe0dAAmQXdj5tXtYhz+ACMUc6PsaXUN1mYSckMavgSaFHjX83ihSeKYPls3vdGcs/7WxDQo7wgvSGVHmYp2pEvhXMgXfIc7d3rX2imyOIaiT8sPChJ4CMXM2YMVFv+nHASu9zpqTdShgQorElw4Tl9qWdyQ4JjNj+3BsP4kPLWuoNhhwnR6ZFkt0PBZoycl7kuQ3yBHMDjSRcKmdzy3DpkTjaUue/am4SgcpyZT7Q5kduht/8yHYDRIA//XbqIiL++HQsYOmMIrZCyc+07KNDYTUlAAQprOhW02Gny6++7azZwxxqeW2rrMo32IrO/
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(346002)(396003)(366004)(136003)(451199018)(122000001)(5660300002)(86362001)(38070700005)(66476007)(85182001)(66946007)(36756003)(8936002)(4326008)(38100700002)(2906002)(41300700001)(7416002)(8676002)(66446008)(66556008)(64756008)(76116006)(6916009)(2616005)(53546011)(186003)(83380400001)(6512007)(26005)(91956017)(54906003)(478600001)(71200400001)(6506007)(6486002)(966005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bnpCV0R1Rm9VNEJEN2RmeFVNemZrWkJ0dzAvY2tDVkhtK2R2NitYODdpcHhW?=
 =?utf-8?B?VlRVeXM5QjUzWis5ajlyaFR5UG9jUjVHWHdZa2FPbE5BQ2tYTUJ0QXoxOXhK?=
 =?utf-8?B?WDVHQVNZTldxZGh5RFFCeWtpbS9oOWwwakhwanVFcmk2MnU4N0MxeExwMkF1?=
 =?utf-8?B?TnNQRitRanIzcE1KY2JXT0lmd0d4bEtKeExiYVFyaXlLekRqRlc2WGxhb3hF?=
 =?utf-8?B?bEtvdnNkU3BoR1puVFdsRDBRRUtteXpMWkxrQU9sTmg5Y3RqUFpSTkExQVFv?=
 =?utf-8?B?QXBhUy9tUUxCTUUrRXE5bS9CNm5oQ2tlR1VNa2ZjVUZENzlTK2dLNDlseTFI?=
 =?utf-8?B?c0ZpQkdPMDQyaHlCcW1rNDl2UlMzTGt1QzdWaWlnWUV4VWFvL3lTTU0xb0py?=
 =?utf-8?B?U1JiT0dWdnE1eDVGbDZoUWpwRmlUa0ZhZDlhTVkxdmM5WEFtK2thSExmOUN6?=
 =?utf-8?B?R3l3d0kzclM0OFNxZXhjZXZ4WThkM2ZOVm5nK21QYm80NUZHUVR4Wmx4UXNz?=
 =?utf-8?B?TUMxNnp0SC9DWTFWZnRUOEdPMmNsZXhvcDZIbWpCZW1SZVoxNjVHUm1ZZE9N?=
 =?utf-8?B?ckk1b1RwVElVMVFRcVpXeVR0RGNabjkrZ1Arc2VVdVVqRkZHQlMrZHAwNENI?=
 =?utf-8?B?MTBwOUtlc1NIL2lIWEY1L3RuZWVISlQ0QW5VSFZ0dFN2V0daY3hiQmxTbEdU?=
 =?utf-8?B?VUN6NkNxSWFDdVk2a2JBK3dtbVhLMlZ0VVFVV2xiTEphL2gxN0RLOWp3Z25r?=
 =?utf-8?B?K0loM1ZDYXQzOENBYllabEJjZ0czaEVRN2NtM1ZQeGVaWDIzeXVnWWZ4alhC?=
 =?utf-8?B?U2cxZWdXTWRaZTdGcmxFNHR3eUF3ZW45VXgwaEZxMFlTZWhGSkgwR1ROTnox?=
 =?utf-8?B?Mys0djRCVmQzZ2YxSkc0djdrR1lFYkdhbjNFeG54bkJST29YZFJhUVQ3eVhy?=
 =?utf-8?B?dUgxcXlaekJIcG1QOU42dkZjZFNsOXFGYXFVRUUzSDZvQ3l2UFdYWDhIM1Nm?=
 =?utf-8?B?WFN5U05hMkNyWGJRWTVYMG8vNEtFdVdnU2h5VWdYeUgxWDI3aFBmY0JEek5U?=
 =?utf-8?B?VldRTEJXSmJSTWdGak1sQXZUTG1ac2pjRFBDSzFQcjdFWVY1UW9CSW43UTBB?=
 =?utf-8?B?dllTN1BROC9LL3pHQVcvR2ozU3dleTl4bndVYmpNbFNydzhlRUxaajMycGVs?=
 =?utf-8?B?MW8xS2FFcUlaNW5wWE9BV0d4RUVicjFlZW9YelFRaHZtSW9FdjJ6YkZlYWg1?=
 =?utf-8?B?YWx3dXpVUFF0dTU1NHNYR3ZUcnpTSUpTOFdXMGZVRi9LdzFJbUYwdUE2TFl5?=
 =?utf-8?B?NGluZnQ0ekU5YWZkeW8xRnJFSUdybkNTS0ltU1VrVEhDSnp3YlZON0hrV0d3?=
 =?utf-8?B?SDBmU21FTVNZaFVlc21OV2p3WW0rOEFuaGpsV090MWdWRG84ZTBIejlqSFFp?=
 =?utf-8?B?dENaUGVGbGhBajZrYTZuWkhuWGVUUGcrYzJiT1BvejdPRWtlc1JjWk1xWkM5?=
 =?utf-8?B?QXNBSGkyUWFoakg4V3lSWnNVZUd4azVXaHMyRjdkWi9oTmF6QzVvMUN3Z3hG?=
 =?utf-8?B?b1g0TjFlOGZra0I1NVdWZzg2QXdIckNORUUrbmpKVklhZFdqRmRReElUUUsz?=
 =?utf-8?B?MlJsbUJnS3BLOURRUFMzQWJmc1hsS0pvRHRMZW9GY2MzNVFhRVJMWk5NTWo5?=
 =?utf-8?B?UlpTTUFHN3pOZGtvTHR6Zi9ybWZBZkpUZGxGVEJjaXdNSlZXT1cxY29Uall3?=
 =?utf-8?B?emV0di9OTExab01kUzZ1NkZFV2VwbFdyRFBOWThqOUxkZ0g1NVFka3dZQ3R5?=
 =?utf-8?B?cU1rWW9SRm9IVTNvaU5rL281eU1WSTVMU2ptNEsreForU3RPK0lCcnNCSXpr?=
 =?utf-8?B?czd1a3JscXdwTnovN3g4MzhCeGJOM21hZlJHTmprbXVUZG0yV1h4Z2FWTytr?=
 =?utf-8?B?T1NoaC90cE9obVlZemQ2ejl1SWhEZmNsbnFPeEpNQitRR1dIRmRMd2h3STNG?=
 =?utf-8?B?WjkvaWlKclNpNVc0cnQzQ0pabFZ1dmFyY3hlV1NDaG4vc2xrbU5JTEV2QnVL?=
 =?utf-8?B?bjVldjRUNG1YU1FNMDFMMHJKT3hHZVgyOTlTMXdZY1o5QjlDM040cHBjSjBB?=
 =?utf-8?B?ekdQbGQ1M0k5R0RpcE5vVWFkVHBMclYyTGRuVnVUQytsMmlRdjJqNU93VUNC?=
 =?utf-8?B?bkE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <074D2E16DFF8EE49A59E0BF4740B90FB@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2079d06e-cd71-4494-c164-08db204cd779
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 03:17:40.7585
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8MFSibRPa2ZMZX0p/VuuL+C4XZmUbIDLT1kb/7P/8j6BYw8Ye3t1yZRz+mf/+U/MRzDlqDr/oWnHhy/cEPdxlKuypH0HHhBKVyjPY+wc6OM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB6470
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDE1OjM5ICswODAwLCBDaGVuLVl1IFRzYWkgd3JvdGU6DQo+
IE9uIFRodSwgSmFuIDE5LCAyMDIzIGF0IDk6MDIgUE0gR2FybWluLkNoYW5nIDwNCj4gR2FybWlu
LkNoYW5nQG1lZGlhdGVrLmNvbT4gd3JvdGU6DQo+ID4gDQo+ID4gQWRkIE1UODE4OCBhZHNwIGNs
b2NrIGNvbnRyb2xsZXIgd2hpY2ggcHJvdmlkZXMgY2xvY2sgZ2F0ZQ0KPiA+IGNvbnRyb2wgZm9y
IEF1ZGlvIERTUC4NCj4gPiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBHYXJtaW4uQ2hhbmcgPEdhcm1p
bi5DaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvY2xrL21lZGlhdGVr
L01ha2VmaWxlICAgICAgICAgICAgICAgICB8ICAyICstDQo+ID4gIC4uLi9jbGsvbWVkaWF0ZWsv
Y2xrLW10ODE4OC1hZHNwX2F1ZGlvMjZtLmMgICB8IDQ1DQo+ID4gKysrKysrKysrKysrKysrKysr
Kw0KPiA+ICAyIGZpbGVzIGNoYW5nZWQsIDQ2IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkN
Cj4gPiAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvY2xrL21lZGlhdGVrL2Nsay1tdDgxODgt
YWRzcF9hdWRpbzI2bS5jDQo+ID4gDQo+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvY2xrL21lZGlh
dGVrL01ha2VmaWxlDQo+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+IGlu
ZGV4IDhiZWZhZWRmZGQzZC4uYjU2YWU5YmVlMWQ4IDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMv
Y2xrL21lZGlhdGVrL01ha2VmaWxlDQo+ID4gKysrIGIvZHJpdmVycy9jbGsvbWVkaWF0ZWsvTWFr
ZWZpbGUNCj4gPiBAQCAtODksNyArODksNyBAQCBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgx
ODgpICs9IGNsay1tdDgxODgtDQo+ID4gYXBtaXhlZHN5cy5vIGNsay1tdDgxODgtdG9wY2tnZW4u
bw0KPiA+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgY2xrLW10ODE4OC1pcGUu
byBjbGstbXQ4MTg4LQ0KPiA+IG1mZy5vIGNsay1tdDgxODgtdmRlYy5vIFwNCj4gPiAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIGNsay1tdDgxODgtdmRvMC5vIGNsay1tdDgxODgt
DQo+ID4gdmRvMS5vIGNsay1tdDgxODgtdmVuYy5vIFwNCj4gPiAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgIGNsay1tdDgxODgtdnBwMC5vIGNsay1tdDgxODgtDQo+ID4gdnBwMS5v
IGNsay1tdDgxODgtd3BlLm8gXA0KPiA+IC0gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgY2xrLW10ODE4OC1pbXBfaWljX3dyYXAubw0KPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgY2xrLW10ODE4OC1pbXBfaWljX3dyYXAubyBjbGstDQo+ID4gbXQ4MTg4LWFk
c3BfYXVkaW8yNm0ubw0KPiA+ICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTIpICs9IGNs
ay1tdDgxOTIubw0KPiA+ICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgxOTJfQVVEU1lTKSAr
PSBjbGstbXQ4MTkyLWF1ZC5vDQo+ID4gIG9iai0kKENPTkZJR19DT01NT05fQ0xLX01UODE5Ml9D
QU1TWVMpICs9IGNsay1tdDgxOTItY2FtLm8NCj4gPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9jbGsv
bWVkaWF0ZWsvY2xrLW10ODE4OC1hZHNwX2F1ZGlvMjZtLmMNCj4gPiBiL2RyaXZlcnMvY2xrL21l
ZGlhdGVrL2Nsay1tdDgxODgtYWRzcF9hdWRpbzI2bS5jDQo+ID4gbmV3IGZpbGUgbW9kZSAxMDA2
NDQNCj4gPiBpbmRleCAwMDAwMDAwMDAwMDAuLmY5MTM4MWExMzE2Yw0KPiA+IC0tLSAvZGV2L251
bGwNCj4gPiArKysgYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LWFkc3BfYXVkaW8y
Nm0uYw0KPiA+IEBAIC0wLDAgKzEsNDUgQEANCj4gPiArLy8gU1BEWC1MaWNlbnNlLUlkZW50aWZp
ZXI6IEdQTC0yLjAtb25seQ0KPiA+ICsvLw0KPiA+ICsvLyBDb3B5cmlnaHQgKGMpIDIwMjIgTWVk
aWFUZWsgSW5jLg0KPiA+ICsvLyBBdXRob3I6IEdhcm1pbiBDaGFuZyA8Z2FybWluLmNoYW5nQG1l
ZGlhdGVrLmNvbT4NCj4gPiArDQo+ID4gKyNpbmNsdWRlIDxsaW51eC9jbGstcHJvdmlkZXIuaD4N
Cj4gPiArI2luY2x1ZGUgPGxpbnV4L3BsYXRmb3JtX2RldmljZS5oPg0KPiA+ICsjaW5jbHVkZSA8
ZHQtYmluZGluZ3MvY2xvY2svbWVkaWF0ZWssbXQ4MTg4LWNsay5oPg0KPiA+ICsNCj4gPiArI2lu
Y2x1ZGUgImNsay1nYXRlLmgiDQo+ID4gKyNpbmNsdWRlICJjbGstbXRrLmgiDQo+ID4gKw0KPiA+
ICtzdGF0aWMgY29uc3Qgc3RydWN0IG10a19nYXRlX3JlZ3MgYWRzcF9hdWRpbzI2bV9jZ19yZWdz
ID0gew0KPiA+ICsgICAgICAgLnNldF9vZnMgPSAweDgwLA0KPiA+ICsgICAgICAgLmNscl9vZnMg
PSAweDgwLA0KPiA+ICsgICAgICAgLnN0YV9vZnMgPSAweDgwLA0KPiA+ICt9Ow0KPiA+ICsNCj4g
PiArI2RlZmluZSBHQVRFX0FEU1BfRkxBR1MoX2lkLCBfbmFtZSwgX3BhcmVudCwgX3NoaWZ0KSAg
ICAgICAgICAgXA0KPiA+ICsgICAgICAgR0FURV9NVEtfRkxBR1MoX2lkLCBfbmFtZSwgX3BhcmVu
dCwgJmFkc3BfYXVkaW8yNm1fY2dfcmVncywNCj4gPiBfc2hpZnQsICAgICAgICAgICAgIFwNCj4g
PiArICAgICAgICAgICAgICAgJm10a19jbGtfZ2F0ZV9vcHNfbm9fc2V0Y2xyLCBDTEtfSUdOT1JF
X1VOVVNFRCkNCj4gDQo+IFdoeSBDTEtfSUdOT1JFX1VOVVNFRD8NCg0KVGhhbmsgeW91IGZvciB5
b3VyIHJldmlldy4NCg0KQmVjYXVzZSBBRFNQX0lORlJBIGlzIGFsd2F5cyBvbiwgaXQgaXMgdW5u
ZWNlc3NhcnkgdG8gYWRkDQpDTEtfSUdOT1JFX1VOVVNFRCBub3cuICBJIHdpaWwgcmVtb3ZlIGl0
IGluIHY2LiBQbGVhc2Ugc2VlIGNvbW1pdA0KDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3Jn
L3Byb2plY3QvbGludXgtbWVkaWF0ZWsvcGF0Y2gvMjAyMjEyMjMwODA1NTMuOTM5Ny0zLUdhcm1p
bi5DaGFuZ0BtZWRpYXRlay5jb20vDQoNCkFkZCBpZ25vcmVfdW51c2VkIGJlZm9yZSB0byBhdm9p
ZCAiQURTUF9JTkZSQSBpcyB0dXJuZWQgb2ZmIi4gSWYNCkFEU1BfSU5GUkEgaXMgdHVybmVkIG9m
ZiwgYWNjZXNzaW5nIHJlZ2lzdGVycyB3aWxsIGNhdXNlIHRoZSBzeXN0ZW0gdG8NCmhhbmcuDQo=
