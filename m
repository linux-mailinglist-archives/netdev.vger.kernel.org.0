Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EA9767FDB0
	for <lists+netdev@lfdr.de>; Sun, 29 Jan 2023 09:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjA2IvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Jan 2023 03:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230128AbjA2IvJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Jan 2023 03:51:09 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 450E01CF6E;
        Sun, 29 Jan 2023 00:51:05 -0800 (PST)
X-UUID: 0f734b6e9fb211eda06fc9ecc4dadd91-20230129
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=fIHDbZYfh4a6huduFRxKMSjtQDoR88GMhqjkj0uMvUw=;
        b=jXKTU1UxIC1lWSdwRcJWTvStiy6J32zF0anrlEcFdue19ugP0CMZeq7qL9qXHztY5DWa0H9n7W3T+5sj6NdkyS+ORO4Bi9/XLev4Y5KAofNWnmHqAlAoDaxID0pMeup8JzpziE0TllZQhU2bnBypJq+fqSpg1rTRgcIR+cW4oTg=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.18,REQID:dd979262-a28f-45fb-b893-4859d8b2ae4a,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:1,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:1
X-CID-META: VersionHash:3ca2d6b,CLOUDID:2527a455-dd49-462e-a4be-2143a3ddc739,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0
X-CID-BVR: 0
X-UUID: 0f734b6e9fb211eda06fc9ecc4dadd91-20230129
Received: from mtkmbs11n1.mediatek.inc [(172.21.101.185)] by mailgw01.mediatek.com
        (envelope-from <yanchao.yang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 881328972; Sun, 29 Jan 2023 16:51:03 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n1.mediatek.inc (172.21.101.193) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Sun, 29 Jan 2023 16:51:02 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Sun, 29 Jan 2023 16:51:02 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EqP824OFIM9N8pdcJSz0eGgbHMs610vG4UidcoSleQYQyn/1U9ANMeCRZ07H8h+hiz6agxyRn7tYa+GG/HKgnyHHS3cUyJClJcf5GZetoOTNWfCbIcxbKgx9cvHLdbB0YVz1iL9794Nu4cIejCeWnwDk578DW43OYm+ve4RafJkIXiNvmhe6/plmnYLdc+c6toXsdmXVgRvN/cn295puUBYyAUOgqQg8pkCw6KxNhlyhl0PoSt4EX0eOEX49JM5dp2g7pb2i1EcOX8otdDjLzVl9abucRNHSZMFM1Vfno3Yiqxte9TA4kAExLQFwume49ullAwNOsYiyaC46WnD++w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fIHDbZYfh4a6huduFRxKMSjtQDoR88GMhqjkj0uMvUw=;
 b=RW17g/SJS8u5E3m3+JNct+ksk/38Mo29zwdgmT4RDq9DKDcrQI3hAszwn1MyVZgoxmZNqOI50YYngFBTfdDrnRig+RBawFeg57S+rUjEc12vjFgaL+p3gmKQExiwwqMhZCgPHBoeE0JFhNrgybbU4sFqmXS52LGF7b8fS7NhzHW9jW9ermreir2SuUF1J7fKWGjbnsCm4jBdanzmcvuqgpPGiQy5BHMdhOsQOq0g6+94tEKbHI0endXpqigYy9lJGoYN7l9BkC0QjmjE/DYWXEPffzTTNEQekA/2DspAk40m2Hlr4z2yCxeVndI/bQFPfTNRFArzibhTUTWC0TU+LQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fIHDbZYfh4a6huduFRxKMSjtQDoR88GMhqjkj0uMvUw=;
 b=d2iiewDH7DxYIYRHdT5n41v3m1jbvbj+A8u8rp+1OuIKodqwte+rb0J+//mdOAXFWXrbo99SbFTmBpw7N0Q9JWjxVH/AgCvpUkagCvXFjFiMH+GAkNGN0Rb7sQH32GrQRF7jlAeAOEQi5hg+SCOdx/8P2sUwjyaSrGwo/rDOYsk=
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com (2603:1096:400:12c::13)
 by TYZPR03MB5744.apcprd03.prod.outlook.com (2603:1096:400:70::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.30; Sun, 29 Jan
 2023 08:51:00 +0000
Received: from TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::e366:4e14:ceda:9b22]) by TYZPR03MB6161.apcprd03.prod.outlook.com
 ([fe80::e366:4e14:ceda:9b22%4]) with mapi id 15.20.6043.033; Sun, 29 Jan 2023
 08:51:00 +0000
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
Subject: Re: [PATCH net-next v2 08/12] net: wwan: tmi: Add data plane
 transaction layer
Thread-Topic: [PATCH net-next v2 08/12] net: wwan: tmi: Add data plane
 transaction layer
Thread-Index: AQHZKzJnz2yD50jcZUGHCVYMX1nNq66mrsAAgA54eIA=
Date:   Sun, 29 Jan 2023 08:51:00 +0000
Message-ID: <ea8001238622a81bfb89dbdc35a6604914a4d052.camel@mediatek.com>
References: <20230118113859.175836-1-yanchao.yang@mediatek.com>
         <20230118113859.175836-9-yanchao.yang@mediatek.com>
         <20230119195210.03537a93@kernel.org>
In-Reply-To: <20230119195210.03537a93@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: TYZPR03MB6161:EE_|TYZPR03MB5744:EE_
x-ms-office365-filtering-correlation-id: 3ee80af8-5e4e-4ba5-802a-08db01d5f233
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kDk8Edi4K8EfA8itWk91l7YVQRA9ohS7Vt5UG11OXIkc6cKlicQChdf0WGu1IVn11rFtnhCtqNhYGARirzw/lQ6RjoUoh2i4cWl0SabPFFVT6mzle6HwK54b2p/1t2sohRA+Z7bEG03P8VcZocGgHrv9pR1vxeLnfyJEmtv9EHjN+ONKzJk1Bi9Ov+OCioF7omEGKPqq4/UivPvYVxLuldsR5TMvuCvfxw3X+XWkk8/ZpF4UlOfLbx5PVKO7LoOxNIJWccgrZMJyV9LSx8OVKuGsWoJv7N2uh3nGK6AcHaiJXUhovQ6k3MoCdxKAnlMIgTPXpbmQKeZ0tNSggO1kbtcd0S6+gHSylDtxjzfamV13K2Pbjw3EJoB6zdiho+TR+tNBjnQdaZt0gsMKRpZF2mPJUAxiw4vapzh9SaPXFNdyfh4hcfDM1MpduYivTk00EQRj3f4ZsN7SEsjcip4gixyrrWy+ptOWYvWg+rUA/36vsI1r86dInRrotdiaoECetFco0Ks85yR3SdS4e/LANZc6xNY5286H12gOhckDkDBx50wqiE+XDlwirqgKNq9fBnegJ/FFpVr6tN9Peu0YAgQIZMOQ9SO9J3jEb8iCb9hL0Le4OJKlezivV5dYFPzcUy7jkd7OVbednSt2Z2jAuEa2csC5w8STj7cjYU1oOWhmaaqtRoM+IxjoTwZOYttwxBfwGzvAi9sGeaRM/tM+7BdnYy/k9HNR2FRodEL3RGUdI90XMeTKt18ZnW+OvCyX02urh8m5kfmBTdDgv0OEBQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYZPR03MB6161.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(346002)(39850400004)(396003)(136003)(366004)(451199018)(122000001)(85182001)(36756003)(2906002)(478600001)(107886003)(7416002)(6486002)(54906003)(71200400001)(86362001)(38070700005)(38100700002)(2616005)(41300700001)(6506007)(8676002)(66476007)(64756008)(6916009)(76116006)(4326008)(4744005)(66946007)(316002)(66556008)(91956017)(66446008)(8936002)(5660300002)(186003)(26005)(6512007)(83380400001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UU1vNDVrOGtWU1NKU0lDYk9IZTlFVEg2VTN2ekRrTXdUSDh5S3Z3YWZ5RzRL?=
 =?utf-8?B?c1ByODJtQkJVeFBTQnZSdFRTOTdLUHNXN2dvaG1xcERLc01qMUhzamx4RFBI?=
 =?utf-8?B?K0FtSUV6UDAxMytub0R3c3lGWVl3cnFnKzc3NllwRDlXRDk1RzFFK3cwaisy?=
 =?utf-8?B?dlAyeE1SSlR6RmIwN0NmMStnd1ZiUkxLcnZMTnVEemlFNkNEQ21WbE9VSFpr?=
 =?utf-8?B?Ym1yYjZYaGZyc05Ob0NOLzdhRENQOC9ScXBZcGhJMDlFa1g0ZFZzaC85NjU1?=
 =?utf-8?B?Nk5TMTc0a2k2RnhINmVreTkzVXVzOElEK1cxcmJPM3F2WDlweG9Vc0I0MjdY?=
 =?utf-8?B?Zi9kSk1SYUpmTXhlQit4U3kzbVM0WFdRYXU0MVMvcUQxTUw2a3l5Uzdyc3dI?=
 =?utf-8?B?MmYycGpuRmtLU1VaRTZETDViaGQ1TTdoay90bjl3d0V0SkFPM1BleitCdkFP?=
 =?utf-8?B?YUxaMEtaazN2bEMvaCtEM3RabnFxT1NDWHJCUHhmQ3RZcStWcjlYQU9DNzVz?=
 =?utf-8?B?Y0IxSE5FdGU2M2tlRjNSWTRxZHJ2U3ZWMXpnVk03VThYbE93Wk9ObTMySlpr?=
 =?utf-8?B?bnRSbkVxcmUwYzdveFVMdWxiUXRDeGZSclkwK1p5ZFArUFBEd01tTnlNNDFq?=
 =?utf-8?B?bGN5QlFVekl5QnNiZFVUYzM5QTNvYWI5R2RGcDhia1N4NzdvbGF6UitKM1hT?=
 =?utf-8?B?VWQrVmtiV0lHNEtiN0J2RHRIK25wRmo4eXZXWlRId1dpQk1jNGhxVlBQbm00?=
 =?utf-8?B?RStFZHRGZXJkQkc5NFNqOTFnWTkwZnhTOUkvRmhWbFpZSUVjY3VLMXU5bSsw?=
 =?utf-8?B?bVF2Wnl1M3dSeW1QdmEwSVZpVytVNnlLNVpVME15Uy9VdFJpeEZMQS9TalFh?=
 =?utf-8?B?S08rM3VNbWU0bkRNUTNGLzV0MzJRMTNRRnMrNlJleFJWUTViWi9FY2pOYXNn?=
 =?utf-8?B?cFFDdGk2U1ljV2tZRlJGOVBUdGNaZzJKbXA3S3NNUmhzOGdzMm9jNDg4d2RP?=
 =?utf-8?B?aFZ5VGEyNFY1dlJwQ0RVZW5TUklNcFhucllKODBMU29mb3UxeFpsMWRWRlo3?=
 =?utf-8?B?QjJEblpxOGQ0SndiM1BvUit1Qno5WEdZSmRIMC9Sc3V2NHNRaklqMldMSUo1?=
 =?utf-8?B?OW9XUDIvY1dpdTMzTytZWmVPNWwwNFNzRDd1bktqaFphc1RVV3FwOUR1TGt5?=
 =?utf-8?B?Qk9NOGY3ZnFBMWtvNHhKNS9SRmJOeHNZampNb3RJTy9qQlJOc3FRMkVZMnZ1?=
 =?utf-8?B?bE9NMDVkRjJqSlZzenJRNzVVSVBmTlg2YThKWEhvbC9XdHY5alZZWWVFRFhQ?=
 =?utf-8?B?M05ISWxQZW5MSW9KTFhIR1NrR2dkeUJhcXNjbU90RjEvQVRhd1JUZWh0U0Ra?=
 =?utf-8?B?NTVCOGdpV2VwSzkrVVRhUzlHalE0cmloNnRWbXZmNHc0eCtETVVybkEvT0w5?=
 =?utf-8?B?VTVmSWp1ZTI3czFoalNpYi9WL2k5Z2lheUdQQ0dyMUZ2SElwQjUrU1hJZ09x?=
 =?utf-8?B?OTVmWjUwTVFLR0NQKzdHRW83SWMrVXFwQnZ2NUNwMFFqYXVSb2VOSXVrWHBx?=
 =?utf-8?B?SitZNTQ5ZFZCdUdFU0ZYNWQ3OTBidytDRWhOMWdTWVJXUnlYRUVDUFJUZXFT?=
 =?utf-8?B?QVlkVnpLREtkZFJjc2NBSFdWME1McWp6VUhvTFd0VEk1dUpxQXljcXNYd1dh?=
 =?utf-8?B?OW5qUWFHNGRONHdwRzh6cWtkejZPbVZNclNvekljbDNldmM1VW1OSUhhTW9j?=
 =?utf-8?B?VXhKWVVwdTFqQ1M0Y3g3QXd1OTB1QmxOSTlCeUEyazZ6eGVob0VQQzh6c3NL?=
 =?utf-8?B?WGppNWpUOVN4M1JIMWlwamNXYkJUMWNxeGlod1FLT2tJcFhvTmk1dG9YRWg4?=
 =?utf-8?B?OUZVMjMrdGpSWmVsWkVGQjFlK3ZLei9hQUFLcWl5c3lzaVpQdVVMaHJMYW1h?=
 =?utf-8?B?ZitEb2lUZjZxd3dvODNNK3hPMko2a3ZvTGxEMWN4ZHpWcTVPUXVlRUpETHNN?=
 =?utf-8?B?Nk94anpmTklZcEtRdFFLWHhoTEUrNlo0TERQbjV3Rkx2Y3dzRjNkYzBsOG5U?=
 =?utf-8?B?a2hDRGFJR2RxSHFNUUI2MzhtWEJ5OHd4anpGRVZZcHpPSzJlbk1OOXFKUnFh?=
 =?utf-8?B?NW5aSjIxMldPblpxRkcwcE5SNFV0a3BpOVV4akZvdmladlJYdWMwbnBGYm1M?=
 =?utf-8?B?Q2c9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <36022660138F1E40863708FFF7C467EE@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYZPR03MB6161.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ee80af8-5e4e-4ba5-802a-08db01d5f233
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2023 08:51:00.5712
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vQCVl3RxLtZOjE76yVe0bAXy3gfLeLfy1ndTB9vG5x9sqOj1R0H+CQF8NYBqQhWy5w4sDcChkLaEhbrEBOYohsdGs7JipylvOWoVNcIdT4E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYZPR03MB5744
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

SGkgSmFrdWIsDQoNCnNvcnJ5IGZvciBsYXRlIHJlc3BvbnNlLCBwbGVhc2UgY2hlY2sgZm9sbG93
aW5nIHJlcGx5Lg0KDQpPbiBUaHUsIDIwMjMtMDEtMTkgYXQgMTk6NTIgLTA4MDAsIEpha3ViIEtp
Y2luc2tpIHdyb3RlOg0KPiBPbiBXZWQsIDE4IEphbiAyMDIzIDE5OjM4OjU1ICswODAwIFlhbmNo
YW8gWWFuZyB3cm90ZToNCj4gPiAgZHJpdmVycy9uZXQvd3dhbi9tZWRpYXRlay9tdGtfZHBtYWlm
LmMgICAgIHwgNDAwNQ0KPiA+ICsrKysrKysrKysrKysrKysrKysrDQo+IA0KPiBjbGFuZyBkZXRl
Y3RzIG91dC1vZi1ib3VuZCBtZW1jcHkvc3RyY3B5IG9yIHN1Y2ggc29tZXdoZXJlIGluIHRoaXMN
Cj4gZmlsZS4NCj4gUGxlYXNlIGZpeCB0aGF0Lg0KT2ssIHdlIHdpbGwgY2hlY2sgYW5kIGZpeCBp
dC4NCj4gDQo+IFBsZWFzZSB0cnkgdG8gbWFrZSB0aGUgc2VyaWVzIHNtYWxsZXIgdGhhbiAxNyw3
NzAgOi8NCj4gU3RyaXAgc3R1ZmYgZG93biB0byBtaW5pbWFsIHdvcmtpbmcgdmVyc2lvbi4NCj4g
SSBkb24ndCB0aGluayBhbnlvbmUgY2FuIHJldmlldyAxN2tMb0MgaW4gb25lIHNpdHRpbmcgOi8N
ClRoYW5rIHlvdXIgc3VnZ2VzdGlvbi4gSSBhZ3JlZSB3aXRoIHlvdS4gQ29uc2lkZXJpbmcgYm90
aCB0aGUgY29udHJvbA0KcGxhbmUgYW5kIGRhdGEgcGxhbmUgYXJlIHRoZSBtaW5pbWFsIGZ1bmN0
aW9uIGZvciBUTUkgZHJpdmVyLCBvdGhlcg0KZnVuY3Rpb25zIGNhbiBiZSByZW1vdmVkIGFuZCBz
dWJtaXR0ZWQgYWZ0ZXIgdGhlIGluaXRpYWwgdmVyc2lvbiBpcw0KYXBwcm92ZWQuIFRoZSB3aG9s
ZSBwYXRjaCBjYW4gYmUgcmVkdWNlZCBhYm91dCAyayBsaW5lcy4gSXMgaXQgb2s/IE9yDQpkbyB5
b3UgaGF2ZSBhbnkgbW9yZSBzdWdnZXN0aW9ucz8gUGxlYXNlIGhlbHAgc2hhcmUgaXQuDQoNCk1h
bnkgdGhhbmtzLg0KeWFuY2hhby55YW5nDQo=
