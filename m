Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6E5627C36
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 12:26:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236596AbiKNL0c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 06:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236443AbiKNL0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 06:26:15 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64FE521A5;
        Mon, 14 Nov 2022 03:23:31 -0800 (PST)
X-UUID: cc7c5073ff3840fbb74665c28b5c37a5-20221114
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=hUE9ND3EGs4mbSJ15ofPJqeM91J5vNGvrL26lgbJlgM=;
        b=sUSZVw/mnf5vujWc2/fEu7mZQpH2UntHXM83wIBNciBa9ZzW1MF4LFdu6yEX9deF/qtyzSt6JnjY9y4WX50cpt1/B3SM4tNXn64Sd4o13RV5T23EZbXdWysqwdJGUZBQhYM7lTLRmKXYkN42lwzLygde3e/HT4LKGZHX/1BXjQE=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:3bfaded6-a440-4328-8210-3725c1c49b7a,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION
        :release,TS:-5
X-CID-INFO: VERSION:1.1.12,REQID:3bfaded6-a440-4328-8210-3725c1c49b7a,IP:0,URL
        :0,TC:0,Content:0,EDM:0,RT:0,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:r
        elease,TS:-5
X-CID-META: VersionHash:62cd327,CLOUDID:b3d47673-e2f1-446d-b75e-e1f2a8186d19,B
        ulkID:221114192324XLYPKYYC,BulkQuantity:0,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: cc7c5073ff3840fbb74665c28b5c37a5-20221114
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 291888951; Mon, 14 Nov 2022 19:23:22 +0800
Received: from mtkmbs10n1.mediatek.inc (172.21.101.34) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 14 Nov 2022 19:23:21 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n1.mediatek.com (172.21.101.34) with Microsoft SMTP Server id
 15.2.792.15 via Frontend Transport; Mon, 14 Nov 2022 19:23:21 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MiUb/+FIVRM7JuTRCourNKb9Y4jIw2j8qGz5hYwNdhug18gKA5Wuk1cSCY6YA35ErJl9l5rMKhMBtKipJe2mNioiW3HM1pbITZ6GzlqvEYwP3e8XmriOp5d3OyaAMRSig58oyI+6gIqIM/CxHE2JIzf2/V/TgCDLr5iO1OS7wwK00/rcW/faGqDvcwwWU2E/1nVBnlR5dv+D/3Dvac5/Un4WQAAAqjksKwVmD066UdDqauXYVps8aSgiy/XXbbAOq9ru6vFbShP08BlglwIBEi8jSLr6QvZ0sArz1GXrGk4YRgQ/UUGEICaPOHk7RjEqzt0oPGaLULzgIptqSw9WEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hUE9ND3EGs4mbSJ15ofPJqeM91J5vNGvrL26lgbJlgM=;
 b=V8UYWjdCI8xYxUR28LDGneMHbdbBDb+EG7TY+4OM5P/lxHDEFNZcNnlvWtZKXdbjJYyG4wJdhnU3SoUy8BiMXoddMhvCgfRTimsHdTErRzd0+S+I9ogxjwM9IlnEKFJ4Tbch8m6hHt9k5HLMFuJNQ04H3qoXT/+fvMV7NXzPR5ivT5XUqedF8JFdRDS8QyO0rcIwWkzQ82lasCAl+3U4+nLqk7umKnsIU/eGNmuDKZkyyffsFpnoXfLFJpPeYdlezZ90ANgFZieK2jsbR5E/C1fdNI8i8gw4IPSxHTN025XBrXB9TCEixgeq7UyKxif0lUwNyCgN5hZ3WaCokrL43Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hUE9ND3EGs4mbSJ15ofPJqeM91J5vNGvrL26lgbJlgM=;
 b=Ac5CK17Zq/dCuY2FSByLKx18eBofNgPdr92gh5IwfFveLJ7fIdtZfTgNKBf2Ou6MptYrDX2dKJxhz5ghbpyNgyEHtrShvUJWLDMkmM+WWtpiBAsWEBg9BjbyKXhLXrPMNmuUB9efFFGHBLbO7ljDKitpHeUO8G1V314XMhZptIE=
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com (2603:1096:301:8f::9)
 by SI2PR03MB6137.apcprd03.prod.outlook.com (2603:1096:4:14d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.17; Mon, 14 Nov
 2022 11:23:19 +0000
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::4682:d6f1:6744:aca6]) by PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::4682:d6f1:6744:aca6%9]) with mapi id 15.20.5813.017; Mon, 14 Nov 2022
 11:23:19 +0000
From:   =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
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
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "loic.poulain@linaro.org" <loic.poulain@linaro.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "shangxiaojing@huawei.com" <shangxiaojing@huawei.com>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>
Subject: Re: [PATCH v3] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Topic: [PATCH v3] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Index: AQHY9bWtrKc/UECIFUujkKbHGSO6OK450bSAgAR53QA=
Date:   Mon, 14 Nov 2022 11:23:19 +0000
Message-ID: <82c8728b0b0b20c7da4e25642e90de27af52feca.camel@mediatek.com>
References: <20221111100840.105305-1-haozhe.chang@mediatek.com>
         <Y25j7fTdvCRqr26k@kroah.com>
In-Reply-To: <Y25j7fTdvCRqr26k@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5653:EE_|SI2PR03MB6137:EE_
x-ms-office365-filtering-correlation-id: 75a88068-2b70-4c42-51ed-08dac632a1d0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GiW8MPTyyPNS3m+A0+vsmjZ1JubMar3l+bmi8u609lCBhxo978XXEkst5OZOaOMM3V9coKOjPTVBkQN+JWcnv1yB6aWM+fZzro+gjYogpOB+OjMbhjVMYddaP3ER3HUvK1ImUiwgc9kL8fdrvupvsiZtlXVOxhNypYiqtrs3cTWcysdryxz/pAxyoEXlrCO1In6XvbGv6t9OqgJqwQP8U3Wbevo3QIwD5LxFXYSKSZKf/Ij9/DO2zG7RQhqUxydujokYezxxD2X9bJu+vo+sdQpU3fZtbVXA0IV4vFo7ruOIQ3K3rm23nKpt7hxIl/mubUIvEzrowcHrsf/M+lxk9c99ioOhk98lZlIbr5gQC1xmLAs+JbBjygFo3rBij2bQD8WrNzvWWwEmmkOAp+xHKjkVpNjm1Z0rg2ixxaSLYg9fX+NxyVx/MFuQ8+Wdca/jVMBx1RAdkVs1qFMLHxZoWl+TH9gUP+K8yznWUhfc09bAMcz/xcky7GDbiaWT9Gs8847sCrWalk32OLq0ngyiDBZ3AxfDkpW64h0uTmNLC95HnlRDiUD225shXcFp+2V/gux5s4tjXXvIUrfTZojAVgZvGirm/FnJcJvH0kGZ8wM3nR7z1FzH2/z7at4R0iVVxWci3NcwUPfaFTjPvaUkZRq/qDpUURp6vlZDZcZ/7BRhwwaBR0Z3NrMQPrYaB1CIHvPsitbzKf4nHtlq6MEsa4ARDuYRp6mcEn8ILSex6/2myLImHncxNebPCbGn0esvKGGjaCGDjQsttxssvq65AxvEnHDFRPBGp3ZDabPbaEs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5653.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(39860400002)(396003)(346002)(376002)(366004)(451199015)(6916009)(71200400001)(6486002)(478600001)(54906003)(107886003)(38070700005)(6506007)(316002)(6512007)(86362001)(26005)(91956017)(64756008)(66946007)(66446008)(122000001)(76116006)(66556008)(36756003)(66476007)(8676002)(4326008)(38100700002)(85182001)(2616005)(7416002)(5660300002)(186003)(8936002)(83380400001)(41300700001)(2906002)(4001150100001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MWdtQzJ0QjFHekJmWG40cGlUNmRsUFRWb2FtTEMyNy9JWklyRkMwaEJZcG5j?=
 =?utf-8?B?WXl5dXY3R2hIVXllb1JhSHI2bVg0U1ZEY0RXQ1gzenh2NXEzVFJCL01kc0pa?=
 =?utf-8?B?MkZEQzdNOTZZbEw2aTJ0d2tiRm5mNTIvSHkwUGZReng3TXZJaUpBUXQveVRJ?=
 =?utf-8?B?NmFlL2hFWk1PMVFsSlhhN0I4cFU3OWJJZGQraHZTQmNQYkRsTXFHYW9kQnNa?=
 =?utf-8?B?WDJ5WGFsNmIwNU1IUVh5ZGFOZW1VVFdGc3NnNzFGQzJyTkNHSitRVVpURGxu?=
 =?utf-8?B?VWNBOUZiamc2SEo1VUREdUNhSC9sS21qRWl1NmNKejZhWTRHR0tlTE5lb053?=
 =?utf-8?B?cjUrTnJYcUE2Sk5rZ2FZQXBqWHdObEZ3Q2Q2UjVyaTJVdHFyNGRrOHVyNjZE?=
 =?utf-8?B?WVUxc1VJa2VVblA5SzJQckZIblpqRzFCM0xnKzlMUEY0cXh2Qk8rZjF6M3c3?=
 =?utf-8?B?d0hIWXB6L252akM4SFJIckMwZ3pDRUtwWDVSbzhHWEx2K0dzY3FrTCtUOUV6?=
 =?utf-8?B?ZUNSdjB3akhsaXVCZXBBNmp6R29sTnBvUU1DNXdKdmp0VHVzRk44NDhEMmpn?=
 =?utf-8?B?SER3bXQxMXFwaWNzU0UvYXhyZERBaEZoUWs3NHlKYnJvaFZwcHNhaUpvVk0v?=
 =?utf-8?B?Q01Vci9qNnpkUDdWZzQwMFlHWCtWSUdHN01Cd2thZHZQK0lJRUlZNmk2NHBJ?=
 =?utf-8?B?dVNVMzhKRDZyRXVHMVNMNWQ3a2xsSWF0dlB2SmJQcFlwbVNHZ1BPRHQvbndk?=
 =?utf-8?B?SlAvWkIxZkFCSWpNMVJOMzdzR0dzemRwaDFlaVRnd1lTcmQxQk9Mc3VZRzFo?=
 =?utf-8?B?MDE3TFhEakNncmplblNEd3JXYStNYzFQMlVqckFlNFhLejlIT0tRcllQNVVo?=
 =?utf-8?B?UW1zSFNEYm5Bd2F2dG5CblpuUm52Z0twRVlnS2hmbzdBSkRTMUdnNmNFRGky?=
 =?utf-8?B?VlkveG53YUUwa3J0WDZXdCs0b1FIT3RMT3JBTncvMDdxcS9UNllVK3dsbm43?=
 =?utf-8?B?emt3RmZnYThXTmhHMnBpWHUwamtsNGdqZE1vb0RJb2kzNzRTRisvcm1QQkw4?=
 =?utf-8?B?UE94eFBuVHdxQ0o0RmJTbTZwcnFReU00VFhqZlpGRExQdURoZFVKL2x0NUZM?=
 =?utf-8?B?T3hRZUhnZjRzenViNklsK1FDTHpSTmU1RVkxd1BqWHBTZzEra2svNUtDTlNY?=
 =?utf-8?B?bjBvT2MzQ3JOSjg0T0VzK0VyYnp5N2dSbnpvOEp0UGRRT0hXOU1HaVlyd1FG?=
 =?utf-8?B?V1pOTFdqbVdOT2pScFNOWmtISUovVzdwZzB5L20yQWtDRXBpcDVRaDBBSkFn?=
 =?utf-8?B?Lzd4eVRlSmd2UmY0bEVUUjZnK3NHSDg5cFhnQmpham51NkIrVjZwVWdTSjds?=
 =?utf-8?B?d3M5ZFNyZDhiZXMzTXQzaitBOFdYY3V6azVMM2NsbVFuNmxjR2psVmhDWXdF?=
 =?utf-8?B?WWZqMlBjZDQzKy9TdmVncnU2Q2x5QmlUdUgvSnE5MTI1ZDgzcVh3dVUzb2hj?=
 =?utf-8?B?MHA4Tmc5QTVyeFNoY0ZTUlhHMHMyOUgya2gwMnUzRUlRdkNPSGNiTGtFWDVY?=
 =?utf-8?B?MzFrQndZaEpDK2ZqS3VMZHBhelY2TGtMTWJ1c05YbzdJOW5KTWNOTVJubGVO?=
 =?utf-8?B?V2dZLzhWeEVqNE5xa0krbHhYeHREOWhEakVQS0VWQ3I2RkVaUHJaQi9ycWNu?=
 =?utf-8?B?R0hmNGZKRGRKUFdYenFoejFEQkJ5TGdlMGFnaWxhVDBUSXBjZGxyc3hTd0du?=
 =?utf-8?B?b2d3dHEzVUUvUVAvejhQdWUzTzZxVEdUZFhUWWlSTzNHNEo2WjBMMHhIeXNz?=
 =?utf-8?B?QmgrUFBTQnVwQUNadkZEQ2l3SExtQ1B0TUUwTXpNWXVkL1hoZFltbFRJbDdM?=
 =?utf-8?B?OFRSQVBTenRkOTJ6bHowa0ZybExBZHVEVUZyUlVsd2IzcCsvWExWVUdxQk83?=
 =?utf-8?B?a0ZjQk4yZS96Q053anFnQVJZcER2RmJkNFdDVm9JTUkvOWhBNGpwRkM5QzVV?=
 =?utf-8?B?cS85YzUzMm56MlhCRUlyYjI3R2krY3lYSVNqbVovTmp0eVd5akpmbnIzZG02?=
 =?utf-8?B?QjdWVWFLaXg2SWl2Y3VydWhKRHh3dDEyci85dnJRNlVINElSL2lqOUFPaDR0?=
 =?utf-8?B?U2FWSEVpQkp2WnhIOC8vSjJyR01rMWs0WU1CQ09EYUFrNlRLRGlPVnlUdFhH?=
 =?utf-8?B?WVE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D66E753ADA87874792A3CD83FF608DA1@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5653.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75a88068-2b70-4c42-51ed-08dac632a1d0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Nov 2022 11:23:19.1326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EbUNdEYOeGxgqymFwxLz+PGdiMPajN1/jIG3GT5Nq9gge0VxTKneBEjePjuV+XRDCgB9+zhg96bHNJPmBggHYwGaGOnB2CaJ4F0Balu6EzQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6137
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

SGkgR3JlZyBLcm9haC1IYXJ0bWFuDQoNCk9uIEZyaSwgMjAyMi0xMS0xMSBhdCAxNjowMiArMDEw
MCwgR3JlZyBLcm9haC1IYXJ0bWFuIHdyb3RlOg0KPiBPbiBGcmksIE5vdiAxMSwgMjAyMiBhdCAw
NjowODozNlBNICswODAwLCBoYW96aGUuY2hhbmdAbWVkaWF0ZWsuY29tDQo+IHdyb3RlOg0KPiA+
IEZyb206IGhhb3poZSBjaGFuZyA8aGFvemhlLmNoYW5nQG1lZGlhdGVrLmNvbT4NCj4gPiANCj4g
PiB3d2FuX3BvcnRfZm9wc193cml0ZSBpbnB1dHMgdGhlIFNLQiBwYXJhbWV0ZXIgdG8gdGhlIFRY
IGNhbGxiYWNrIG9mDQo+ID4gdGhlIFdXQU4gZGV2aWNlIGRyaXZlci4gSG93ZXZlciwgdGhlIFdX
QU4gZGV2aWNlIChlLmcuLCB0N3h4KSBtYXkNCj4gPiBoYXZlIGFuIE1UVSBsZXNzIHRoYW4gdGhl
IHNpemUgb2YgU0tCLCBjYXVzaW5nIHRoZSBUWCBidWZmZXIgdG8gYmUNCj4gPiBzbGljZWQgYW5k
IGNvcGllZCBvbmNlIG1vcmUgaW4gdGhlIFdXQU4gZGV2aWNlIGRyaXZlci4NCj4gPiANCj4gPiBU
aGlzIHBhdGNoIGltcGxlbWVudHMgdGhlIHNsaWNpbmcgaW4gdGhlIFdXQU4gc3Vic3lzdGVtIGFu
ZCBnaXZlcw0KPiA+IHRoZSBXV0FOIGRldmljZXMgZHJpdmVyIHRoZSBvcHRpb24gdG8gc2xpY2Uo
YnkgZnJhZ19sZW4pIG9yIG5vdC4gQnkNCj4gPiBkb2luZyBzbywgdGhlIGFkZGl0aW9uYWwgbWVt
b3J5IGNvcHkgaXMgcmVkdWNlZC4NCj4gPiANCj4gPiBNZWFud2hpbGUsIHRoaXMgcGF0Y2ggZ2l2
ZXMgV1dBTiBkZXZpY2VzIGRyaXZlciB0aGUgb3B0aW9uIHRvDQo+ID4gcmVzZXJ2ZQ0KPiA+IGhl
YWRyb29tIGluIGZyYWdtZW50cyBmb3IgdGhlIGRldmljZS1zcGVjaWZpYyBtZXRhZGF0YS4NCj4g
PiANCj4gPiBTaWduZWQtb2ZmLWJ5OiBoYW96aGUgY2hhbmcgPGhhb3poZS5jaGFuZ0BtZWRpYXRl
ay5jb20+DQo+ID4gDQo+ID4gLS0tDQo+ID4gQ2hhbmdlcyBpbiB2Mg0KPiA+ICAgLXNlbmQgZnJh
Z21lbnRzIHRvIGRldmljZSBkcml2ZXIgYnkgc2tiIGZyYWdfbGlzdC4NCj4gPiANCj4gPiBDaGFu
Z2VzIGluIHYzDQo+ID4gICAtbW92ZSBmcmFnX2xlbiBhbmQgaGVhZHJvb21fbGVuIHNldHRpbmcg
dG8gd3dhbl9jcmVhdGVfcG9ydC4NCj4gPiAtLS0NCj4gPiAgZHJpdmVycy9uZXQvd3dhbi9pb3Nt
L2lvc21faXBjX3BvcnQuYyAgfCAgMyArLQ0KPiA+ICBkcml2ZXJzL25ldC93d2FuL21oaV93d2Fu
X2N0cmwuYyAgICAgICB8ICAyICstDQo+ID4gIGRyaXZlcnMvbmV0L3d3YW4vcnBtc2dfd3dhbl9j
dHJsLmMgICAgIHwgIDIgKy0NCj4gPiAgZHJpdmVycy9uZXQvd3dhbi90N3h4L3Q3eHhfcG9ydF93
d2FuLmMgfCAzNCArKysrKysrLS0tLS0tLS0NCj4gPiAgZHJpdmVycy9uZXQvd3dhbi93d2FuX2Nv
cmUuYyAgICAgICAgICAgfCA1OSArKysrKysrKysrKysrKysrKysrKw0KPiA+IC0tLS0tLQ0KPiA+
ICBkcml2ZXJzL25ldC93d2FuL3d3YW5faHdzaW0uYyAgICAgICAgICB8ICAyICstDQo+ID4gIGRy
aXZlcnMvdXNiL2NsYXNzL2NkYy13ZG0uYyAgICAgICAgICAgIHwgIDIgKy0NCj4gPiAgaW5jbHVk
ZS9saW51eC93d2FuLmggICAgICAgICAgICAgICAgICAgfCAgNiArKy0NCj4gPiAgOCBmaWxlcyBj
aGFuZ2VkLCA3MyBpbnNlcnRpb25zKCspLCAzNyBkZWxldGlvbnMoLSkNCj4gPiANCj4gPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX3BvcnQuYw0KPiA+IGIvZHJp
dmVycy9uZXQvd3dhbi9pb3NtL2lvc21faXBjX3BvcnQuYw0KPiA+IGluZGV4IGI2ZDgxYzYyNzI3
Ny4uZGM0M2I4ZjBkMWFmIDEwMDY0NA0KPiA+IC0tLSBhL2RyaXZlcnMvbmV0L3d3YW4vaW9zbS9p
b3NtX2lwY19wb3J0LmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNf
cG9ydC5jDQo+ID4gQEAgLTYzLDcgKzYzLDggQEAgc3RydWN0IGlvc21fY2RldiAqaXBjX3BvcnRf
aW5pdChzdHJ1Y3QgaW9zbV9pbWVtDQo+ID4gKmlwY19pbWVtLA0KPiA+ICAJaXBjX3BvcnQtPmlw
Y19pbWVtID0gaXBjX2ltZW07DQo+ID4gIA0KPiA+ICAJaXBjX3BvcnQtPmlvc21fcG9ydCA9IHd3
YW5fY3JlYXRlX3BvcnQoaXBjX3BvcnQtPmRldiwNCj4gPiBwb3J0X3R5cGUsDQo+ID4gLQkJCQkJ
ICAgICAgICZpcGNfd3dhbl9jdHJsX29wcywNCj4gPiBpcGNfcG9ydCk7DQo+ID4gKwkJCQkJICAg
ICAgICZpcGNfd3dhbl9jdHJsX29wcywgMCwNCj4gPiAwLA0KPiA+ICsJCQkJCSAgICAgICBpcGNf
cG9ydCk7DQo+IA0KPiBIb3cgaXMgMCwgMCBhIHZhbGlkIG9wdGlvbiBoZXJlPw0KPiANCj4gYW5k
IGlmIGl0IGlzIGEgdmFsaWQgb3B0aW9uLCBzaG91bGRuJ3QgeW91IGp1c3QgaGF2ZSAyIGRpZmZl
cmVudA0KPiBmdW5jdGlvbnMsIG9uZSB0aGF0IG5lZWRzIHRoZXNlIHZhbHVlcyBhbmQgb25lIHRo
YXQgZG9lcyBub3Q/ICBUaGF0DQo+IHdvdWxkIG1ha2UgaXQgbW9yZSBkZXNjcmlwdGl2ZSBhcyB0
byB3aGF0IHRob3NlIG9wdGlvbnMgYXJlLCBhbmQNCj4gZW5zdXJlDQo+IHRoYXQgeW91IGdldCB0
aGVtIHJpZ2h0Lg0KPiANCjAgaXMgYSB2YWxpZCBvcHRpb24uIA0KZnJhZ19sZW4gc2V0IHRvIDAg
bWVhbnMgbm8gc3BsaXQsIGFuZCBoZWFkcm9vbSBzZXQgdG8gMCBtZWFucyBubyANCnJlc2VydmVk
IGhlYWRyb29tIGluIHNrYi4gDQoNClNvcnJ5LCBJIGNhbid0IHVuZGVyc3RhbmQgd2h5IGl0J3Mg
bW9yZSBkZXNjcmlwdGl2ZSwgY291bGQgeW91IGhlbHANCndpdGggbW9yZSBpbmZvcm1hdGlvbj8g
SXQgc2VlbXMgdG8gbWUgdGhhdCB0aGUgZGV2aWNlIGRyaXZlciBuZWVkcyB0bw0Ka25vdyB3aGF0
IGVhY2ggcGFyYW1ldGVyIGlzIGFuZCBob3cgdG8gc2V0IHRoZW0sIGFuZCB0aGF0IHByb2Nlc3Mg
aXMNCmFsc28gcmVxdWlyZWQgaW4geW91ciBwcm9wb3NlZCBzb2x1dGlvbiAtICJ3aXRoIDIgZGlm
ZmVyZW50IGZ1bmN0aW9ucyIsDQpyaWdodD8NCj4gPiBAQCAtMTEyLDcgKzExNyw2IEBAIHZvaWQg
d3dhbl9wb3J0X3J4KHN0cnVjdCB3d2FuX3BvcnQgKnBvcnQsDQo+ID4gc3RydWN0IHNrX2J1ZmYg
KnNrYik7DQo+ID4gICAqLw0KPiA+ICB2b2lkIHd3YW5fcG9ydF90eG9mZihzdHJ1Y3Qgd3dhbl9w
b3J0ICpwb3J0KTsNCj4gPiAgDQo+ID4gLQ0KPiA+ICAvKioNCj4gDQo+IFVubmVlZGVkIGNoYW5n
ZS4NCj4gDQpZZXMsIEkgd2lsbCByb2xsYmFjayBpdC4NCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBr
LWgNCg==
