Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DA36A9343
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 10:00:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbjCCJAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 04:00:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbjCCJAK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 04:00:10 -0500
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E07FF43460;
        Fri,  3 Mar 2023 00:59:45 -0800 (PST)
X-UUID: bc6dd218b9a111eda06fc9ecc4dadd91-20230303
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=RGWrA+Ph2u8tfBfHc5T/Az1pVgbdgFUid8acOK9WwE8=;
        b=nd4D1ow+juqm4E+VKuicjDJEj/W3vNYW1FCoD85NyegPUJa0zLviCo/iPDbQM3FdKbnhWQ4ajh9E/qw3CnCu67yzEJ8PL9NtET5MldYIVcgWvCYIAeYWvsdUTqdKRPX4ucOFetfkY2qV01Wm15eGMLigU3F72zORl0wvj+JI/3A=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:a5a346d2-04ad-4270-8613-85938be865aa,IP:0,U
        RL:0,TC:0,Content:-5,EDM:0,RT:1,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
        N:release,TS:-9
X-CID-INFO: VERSION:1.1.20,REQID:a5a346d2-04ad-4270-8613-85938be865aa,IP:0,URL
        :0,TC:0,Content:-5,EDM:0,RT:1,SF:-5,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:-9
X-CID-META: VersionHash:25b5999,CLOUDID:9a6faaf4-ddba-41c3-91d9-10eeade8eac7,B
        ulkID:2303031659436KGY9CM5,BulkQuantity:0,Recheck:0,SF:17|19|102,TC:nil,Co
        ntent:0,EDM:-3,IP:nil,URL:1,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,O
        SA:0,AV:0
X-CID-BVR: 0
X-UUID: bc6dd218b9a111eda06fc9ecc4dadd91-20230303
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 1055287266; Fri, 03 Mar 2023 16:59:42 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Fri, 3 Mar 2023 16:59:40 +0800
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Fri, 3 Mar 2023 16:59:40 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KmZuN7QOBmDHp2+3mU3Yk5mjHXFzvRsOgrmuvcsSbMJSQ47mM0mAFp9ckTQivy7pPUiY6ZfkIuK87WD/40FN2Rd6DMr+4Qnz8tRt4dtz+1MTP8FLHcXASSi6KnDd8S4hLKv8EWjIg7bsG3M77mM8iu30MbfxJp+Ej5r/kyX826V2A4T/GXpBNlWn3L+jx0RoZ9Dh1uZcEOKQ9DWryzwSFqGonWvdFYAQgrLLDSTqvMSP4V9bXP2w049p1tf7v0TbDoWgA/i96Vgw4pW3LpD1cLBN9jKSnblIUlp7PjXTNF5eRXu60O9GDkT9dfFOGUxOWOtjR1KHDcGPMsnKRk+3EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=RGWrA+Ph2u8tfBfHc5T/Az1pVgbdgFUid8acOK9WwE8=;
 b=cG2vNcroJ7KzVgbnlMRGAeTSyjlcIq8eLDFlFlDGb3BIrYpn1OX+KpG8UCCntwFRXPIhO2EOyXRlf9+wao+rIFKI9m3HEVKmxn4N+z+XsVwj3ABHfzr5fzA1FM7Sy9N4SgHiGX8kwqT/Ilc9OdxcM9Q1b7aju/DAQAmG2EmpT584wkl4zWlfnezz1KD+WD77/bDVR48s5CxWfC6fGFbTda1QujFd8btPywhue/2fwepKA1aovLNdyhRCi4VD1UcNYjq2j4ryDlaaNMCKSyyry/fksjqLwSftXG1n8jqL5lcLPy+PXaQIEZqQb0AosiPnWeMKECxsDX4R9N7dMoSyAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RGWrA+Ph2u8tfBfHc5T/Az1pVgbdgFUid8acOK9WwE8=;
 b=F3Z4BlM8gnzvGM/mkaSOVj8IdsMCkBbwVQk9NY8mTRev7QvaIa6joDNwY2fYtqjgNByPlfB/FYebKynUtmHPLkXmTN2P10aQpU27W2LLL9uXLJOAW99PHiadcABOLDv+h0M5dsb8gc66ilZIq9AVF4s+thIv9VeoLI26e0DT468=
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com (2603:1096:301:8f::9)
 by SI2PR03MB5467.apcprd03.prod.outlook.com (2603:1096:4:103::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.18; Fri, 3 Mar
 2023 08:59:38 +0000
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::2559:136d:352e:705f]) by PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::2559:136d:352e:705f%8]) with mapi id 15.20.6156.021; Fri, 3 Mar 2023
 08:59:38 +0000
From:   =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>
To:     Loic Poulain <loic.poulain@linaro.org>
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
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "ryazanov.s.a@gmail.com" <ryazanov.s.a@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        =?utf-8?B?WGlheXUgWmhhbmcgKOW8oOWkj+Wuhyk=?= 
        <Xiayu.Zhang@mediatek.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "chandrashekar.devegowda@intel.com" 
        <chandrashekar.devegowda@intel.com>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "shangxiaojing@huawei.com" <shangxiaojing@huawei.com>,
        =?utf-8?B?TGFtYmVydCBXYW5nICjnjovkvJ8p?= 
        <Lambert.Wang@mediatek.com>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "ricardo.martinez@linux.intel.com" <ricardo.martinez@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?utf-8?B?5Zue5aSNOiBbUEFUQ0ggdjVdIHd3YW46IGNvcmU6IFN1cHBvcnQgc2xpY2lu?=
 =?utf-8?Q?g_in_port_TX_flow_of_WWAN_subsystem?=
Thread-Topic: [PATCH v5] wwan: core: Support slicing in port TX flow of WWAN
 subsystem
Thread-Index: AQHY/9kYYzEaTkwM8Eq+zQIVqHDO1a5Y1r6AgBRUz4CAAAywAIB8JPnA
Date:   Fri, 3 Mar 2023 08:59:38 +0000
Message-ID: <PSAPR03MB5653D7BAA0E5DDB2D03B341BF7B39@PSAPR03MB5653.apcprd03.prod.outlook.com>
References: <20221124074725.74325-1-haozhe.chang@mediatek.com>
 <CAMZdPi9JOQpmhQepBMeG5jzncP8t5mp68O2nfSOFUUZ9e_fDsQ@mail.gmail.com>
 <54c37c8f8eb7f35e4bb983b9104bd232758bae7b.camel@mediatek.com>
 <CAMZdPi8NOfMn99yy043oYGrO1=UrnhhRvpZq-zWe4BfiU_08NA@mail.gmail.com>
In-Reply-To: <CAMZdPi8NOfMn99yy043oYGrO1=UrnhhRvpZq-zWe4BfiU_08NA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5653:EE_|SI2PR03MB5467:EE_
x-ms-office365-filtering-correlation-id: 7df64aab-6bd0-40d4-9d37-08db1bc59e97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CY+WOAhWDVWR/fTPbLoemeWmLxKkZX6J4sx5Evjo2gcEV2ql04aDwMIl6o3JkE9gKqYqT2yMZVN2/8FCbia42KpepTZzCn5vf/8g+Y/iCBEac/zeBcWmzvDdU75cmdMGJZdIvDQlTCaPutMqrboEL7RPhAri8g3d1SIgAgzv1DGN5LrYCn5gGO0m2LJv6IPSXmOgoTTVISk/ooygMODpzjAwJu7RR3aoyFV+ShnKdo1ElfAGtEnrTx/32Xug+75wqBuV4Z3CMc3H9GORvcns0t2CmJjA/IYZCiNcCFJi2pyt3NV0ENgfPQ6G2q6TjbLav2vJp56IioHHrXB1LNuzEhtmeGWkPHgrEWg3X0O+3DDK6DIkiBPH/p/jRiNNwbfbmJv4US2JTl3FhXhaILmyqB6XYZC5GUCAxRVl3LOm80EXEcKSoGFG9srmmocRaWe/x5FD/5EMV7RXUfAIptCeaNbKrB8dY12O2/c3PbH+zayb8nVfExFL33IwCCqGrUoTyybfRXsfesep6PVEO40A2szbZ8Ngkvt0C6eoBo53qrzi2k3rGPjzc97YMyYSLHDL/skLaxbU3AqqHDYxfqTH4ozMNwIkFrB1QpwVm1w8YYrVNulzqAs5jmW5PTCjZP7yALzV/Q7B5V4oryp1/7E5b20RHD8SXT9ReV/Rc72QPtjNRgeUPCh6S69BWuot0FjHrhseSACq6oTOIXvr3PsrKZinr6SoW8n+fxnN+4Jac2I=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5653.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(396003)(366004)(136003)(346002)(451199018)(7696005)(966005)(71200400001)(38070700005)(41300700001)(55016003)(9686003)(6506007)(186003)(86362001)(85182001)(26005)(224303003)(2906002)(83380400001)(66556008)(54906003)(316002)(5660300002)(6916009)(7416002)(66446008)(76116006)(66476007)(4326008)(38100700002)(64756008)(66946007)(478600001)(52536014)(33656002)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?OHFaQUwzRDdnb3l6d3k4b1BkUkF4TTQxbjhVN0JNaXRFM1ZDakRvYlVZZXVa?=
 =?utf-8?B?Q0h3VUcwMjFjL2c4MDI2bGU3LzNYRWgvcVU4UHpmZFc1ODFrNkt5bGtBMEM1?=
 =?utf-8?B?Vk5va0NnWll0WThQVGRzbTdzTytPcWZ2cU1FME9LLytSU1N3d1hWeVlsZWZL?=
 =?utf-8?B?K2VSd2tzNXEybHFyUFQyZXpZN0tBazBoSUlRYTJBSlREYngrajdSUktXbGd3?=
 =?utf-8?B?bEE5bDVaajg5K0phVE1RYnpDOVlxRy9pVG95N210Mk1oenVQZ1JxUzhhTjFh?=
 =?utf-8?B?RnFOUmZ5eTFOU1VhRldoNjF5akxzeEUrUkFIb01CRlI2NHRFWmM2RkdDNzJQ?=
 =?utf-8?B?WkNjWjhwckJVNExWNXdjaWxKbEo2M0E4ZzVDUCt2aS9YQ0RVcUFFUkJ5d3VZ?=
 =?utf-8?B?bjN2eGRxSnRxUHhSUDdqK29jOWZsRHRMQkRYOUxkNUowZE9XR3kwV0JBVzd1?=
 =?utf-8?B?S0grRG5QK3pPRldoejJuaXdwSEhpV2JtTDVDTDRlc1hDbGxiKytnc3dEcE1X?=
 =?utf-8?B?VGZ0VVY5dmRUZUtMRitJQzNMWVpFODVGYitFS0NKRWNMUWlXMVN6V2lDUFYx?=
 =?utf-8?B?OHE3R0xqeXIzUTZsYmtMRjhVSmhqbjZ4blUvTE53Rm1kYzRBSjZWTmRURVo4?=
 =?utf-8?B?dEdHazJCb3FrMTk5UGF0SnhLb0UvM0g5ZUNTZVNOcFBBQXBHS0FsQjdiaDc1?=
 =?utf-8?B?cWNaNzc5SnVVbVRKL2JzMG5mbGU2Y3piMEtjY0xpdlN0aXhPdHExeE5OVXdk?=
 =?utf-8?B?T2hjcmVud2hEZmdPQjhyemNzOUZRSWhIOHJnUFNjZXJkWFdKbXpOQnJkOU1s?=
 =?utf-8?B?NUI0SUZBVUlua2dhTWE4YnBRb2Vaa05wNHRObnV3QUxTNldwdkk3QVBvMmE1?=
 =?utf-8?B?WklLVThMcUVncm01N0Frb0ozWTQ2UnE0WGZzTFdhVTFNSmF2U3RoZnA1OUpp?=
 =?utf-8?B?TVBReHcvbkNIamdTSm5OOGlsbWs3dTNLSDZTRUJBT2ViOEhlbEVQOWUySnJ6?=
 =?utf-8?B?LytoRE92emVHZG4zQXB6bEh2eTI3UExYcExiKzE4VFBzWXFEWUx2bFk0UnZD?=
 =?utf-8?B?UWFhem5zazZXZDNPUVU4TUs1RkRtd1pna0NMUUU2WVQxUDY4QUttUkJXWHpT?=
 =?utf-8?B?eEdyRkRja0tvUTVOQmNlRjlRSzlweGd6Z1dYZmNCTS9vSDFrOCtiODc0cXlS?=
 =?utf-8?B?UWlVZFJHNFgzV015RFl2YjY4UERRSXI0K0VFcVc0QWpNVWFuOHJmWXlDUzFx?=
 =?utf-8?B?L0ZVV2d1U0cyNW91RE0rTURGVlZCWjNVcWkwR05JNUZrQ2NRWmRuTzJ1Mlp1?=
 =?utf-8?B?cTE4TnNmSWhJOERGOUlSc0RaNnJidk0vMUhRQ2lZQXJPcHNMSVhxbnBraFQz?=
 =?utf-8?B?b2M4cUhhN1VjZU5yZERrTjRnVzZFQkljR3ArYjYvcGZqK3Z6bW1CeitpN3la?=
 =?utf-8?B?TXVlcUZMTkpWSGdlWjFCR01KUUVkZDZzMmswbmdkcWRZK1BTNGdNMVJBc1dN?=
 =?utf-8?B?UDZlOEt5QUlCOGt2Qld3QjIwcHVIZTczanJ6bkNaRlppVWlIbk0vSkorZitW?=
 =?utf-8?B?NnQyQnl2TjZBVWlzTU5DQkhvQUpoNzFmOWdYRWR1RzVnRjNkNEZ4a1hwT2l4?=
 =?utf-8?B?Y1RYQjJNN294SEs0TkczTy9YdDYzQ3N0UHFONklyRXU1RGlac3FEdHFUK3U3?=
 =?utf-8?B?aTlrM0FGS3JjUWp5TEtNV1BVOU42ZmNyVDI5dHRsdnlxdXg3L29GSUg1bzhD?=
 =?utf-8?B?ZlA1VWdOaWJRVlNtM1BQb2FSZ21JTnJPdDE2eVEvb2VTVVVQSHNUQUdOZlUw?=
 =?utf-8?B?NURqY1l4YXpSRTIzSG1vc0xPNndERHBRYTMzeFBPRTZRQW5HQzJmTTdIVUg0?=
 =?utf-8?B?c1hCMmZBcU9HZVFyT28xaVorbGw5MmpJaDBPZGJiUldpTXg5Tlg3NVZRRC9F?=
 =?utf-8?B?NjZQV0pHTE5XcmxDbEQvNlY0TjhHd0NSSzFKV2I1aTVHNVR4Q25nK0lxWEd0?=
 =?utf-8?B?bHBFS05BWEgxVzRkYm1GVUsxcjNUODl6M04rZ2xYL1VYcVQ5aWlDUGpaRHhC?=
 =?utf-8?B?WmhxYjJJWkcyanRsY0M1VTI5bXpUeVcyMTRFVjRCdmE2b3UwMWJBM1d4Zjh4?=
 =?utf-8?B?aFNOSE9Ldjc0WWhZc1FVSXJlSDRnVmdWVXZld3hrU214K2hDNkZPTjB2NkhG?=
 =?utf-8?B?cHc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5653.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7df64aab-6bd0-40d4-9d37-08db1bc59e97
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Mar 2023 08:59:38.5832
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7S8EIum54TRPU1QlCFunpr9Ur8aOcf6YgVZF6SIiznYVqMx8701imYF7IsW+asyrC8hW+QeKL0x5x2VT9TaePzPYJN3vOQFIbfE/ETlZaCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5467
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RGVhciBMb2ljDQoNCkknbSBzb3JyeSB0byBib3RoZXIgeW91LCBidXQgSSB3YW50IHRvIGtub3cg
d2hldGhlciBteSBwYXRjaCBpcyBhY2NlcHRlZCBieSB0aGUgY29tbXVuaXR5Lg0KQmVjYXVzZSBp
dCBzZWVtcyB0byBiZSBhIG1lcmdlIHdpbmRvdywgYnV0IHRoZSBwYXRjaCBzdGF0ZSBzdGlsbCBp
cyAiTm90IEFwcGxpY2FibGUiLiBDb3VsZCB5b3UgDQpnaXZlIG1lIHNvbWUgc3VnZ2VzdGlvbnMg
YWJvdXQgdGhpcyBwYXRjaCBzdGF0ZT8NCg0KQlINCkhhb3poZQ0KDQotLS0tLemCruS7tuWOn+S7
ti0tLS0tDQrlj5Hku7bkuro6IExvaWMgUG91bGFpbiA8bG9pYy5wb3VsYWluQGxpbmFyby5vcmc+
IA0K5Y+R6YCB5pe26Ze0OiAyMDIy5bm0MTLmnIgxNOaXpSAxNzoxMQ0K5pS25Lu25Lq6OiBIYW96
aGUgQ2hhbmcgKOW4uOa1qeWTsikgPEhhb3poZS5DaGFuZ0BtZWRpYXRlay5jb20+DQrmioTpgIE6
IHN0ZXBoYW5AZ2VyaG9sZC5uZXQ7IG9uZXVrdW1Ac3VzZS5jb207IGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc7IGxpbnV4LXVzYkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LXJlbW90ZXByb2NA
dmdlci5rZXJuZWwub3JnOyBsaW51eHd3YW5AaW50ZWwuY29tOyBtLmNoZXRhbi5rdW1hckBpbnRl
bC5jb207IGxpbnV4LW1lZGlhdGVrQGxpc3RzLmluZnJhZGVhZC5vcmc7IEh1YSBZYW5nICjmnajl
jY4pIDxIdWEuWWFuZ0BtZWRpYXRlay5jb20+OyBjaGlyYW5qZWV2aS5yYXBvbHVAbGludXguaW50
ZWwuY29tOyBIYWlqdW4gTGl1ICjliJjmtbflhpspIDxoYWlqdW4ubGl1QG1lZGlhdGVrLmNvbT47
IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgcnlhemFub3Yucy5hQGdtYWls
LmNvbTsga3ViYUBrZXJuZWwub3JnOyBYaWF5dSBaaGFuZyAo5byg5aSP5a6HKSA8WGlheXUuWmhh
bmdAbWVkaWF0ZWsuY29tPjsgcGFiZW5pQHJlZGhhdC5jb207IGVkdW1hemV0QGdvb2dsZS5jb207
IGNoYW5kcmFzaGVrYXIuZGV2ZWdvd2RhQGludGVsLmNvbTsgam9oYW5uZXNAc2lwc29sdXRpb25z
Lm5ldDsgZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IHNoYW5neGlhb2ppbmdAaHVhd2VpLmNv
bTsgTGFtYmVydCBXYW5nICjnjovkvJ8pIDxMYW1iZXJ0LldhbmdAbWVkaWF0ZWsuY29tPjsgbWF0
dGhpYXMuYmdnQGdtYWlsLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgcmljYXJkby5tYXJ0aW5l
ekBsaW51eC5pbnRlbC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCuS4u+mimDogUmU6IFtQ
QVRDSCB2NV0gd3dhbjogY29yZTogU3VwcG9ydCBzbGljaW5nIGluIHBvcnQgVFggZmxvdyBvZiBX
V0FOIHN1YnN5c3RlbQ0KDQo+IE9uIFRodSwgMjAyMi0xMi0wMSBhdCAxMDo1NiArMDEwMCwgTG9p
YyBQb3VsYWluIHdyb3RlOg0KPiA+IE9uIFRodSwgMjQgTm92IDIwMjIgYXQgMDg6NDcsIDxoYW96
aGUuY2hhbmdAbWVkaWF0ZWsuY29tPiB3cm90ZToNCj4gPiA+DQo+ID4gPiBGcm9tOiBoYW96aGUg
Y2hhbmcgPGhhb3poZS5jaGFuZ0BtZWRpYXRlay5jb20+DQo+ID4gPg0KPiA+ID4gd3dhbl9wb3J0
X2ZvcHNfd3JpdGUgaW5wdXRzIHRoZSBTS0IgcGFyYW1ldGVyIHRvIHRoZSBUWCBjYWxsYmFjayAN
Cj4gPiA+IG9mIHRoZSBXV0FOIGRldmljZSBkcml2ZXIuIEhvd2V2ZXIsIHRoZSBXV0FOIGRldmlj
ZSAoZS5nLiwgdDd4eCkgDQo+ID4gPiBtYXkgaGF2ZSBhbiBNVFUgbGVzcyB0aGFuIHRoZSBzaXpl
IG9mIFNLQiwgY2F1c2luZyB0aGUgVFggYnVmZmVyIA0KPiA+ID4gdG8gYmUgc2xpY2VkIGFuZCBj
b3BpZWQgb25jZSBtb3JlIGluIHRoZSBXV0FOIGRldmljZSBkcml2ZXIuDQo+ID4gPg0KPiA+ID4g
VGhpcyBwYXRjaCBpbXBsZW1lbnRzIHRoZSBzbGljaW5nIGluIHRoZSBXV0FOIHN1YnN5c3RlbSBh
bmQgZ2l2ZXMgDQo+ID4gPiB0aGUgV1dBTiBkZXZpY2VzIGRyaXZlciB0aGUgb3B0aW9uIHRvIHNs
aWNlKGJ5IGZyYWdfbGVuKSBvciBub3QuIA0KPiA+ID4gQnkgZG9pbmcgc28sIHRoZSBhZGRpdGlv
bmFsIG1lbW9yeSBjb3B5IGlzIHJlZHVjZWQuDQo+ID4gPg0KPiA+ID4gTWVhbndoaWxlLCB0aGlz
IHBhdGNoIGdpdmVzIFdXQU4gZGV2aWNlcyBkcml2ZXIgdGhlIG9wdGlvbiB0byANCj4gPiA+IHJl
c2VydmUgaGVhZHJvb20gaW4gZnJhZ21lbnRzIGZvciB0aGUgZGV2aWNlLXNwZWNpZmljIG1ldGFk
YXRhLg0KPiA+ID4NCj4gPiA+IFNpZ25lZC1vZmYtYnk6IGhhb3poZSBjaGFuZyA8aGFvemhlLmNo
YW5nQG1lZGlhdGVrLmNvbT4NCj4gPg0KPiA+IFJldmlld2VkLWJ5OiBMb2ljIFBvdWxhaW4gPGxv
aWMucG91bGFpbkBsaW5hcm8ub3JnPg0KPg0KPiBJIGhhdmUgc3VibWl0dGVkIHBhdGNoIFY2IHRv
IGFkZCBhIHJldmlld2VyLCBkbyB5b3UgaGF2ZSBhbnkgb3RoZXIgDQo+IHN1Z2dlc3Rpb25zIGFi
b3V0IHRoZSBwYXRjaD8NCg0KWW91IG5vcm1hbGx5IGRvbid0IG5lZWQgdG8gcmVzdWJtaXQgYSB2
ZXJzaW9uIGp1c3QgZm9yIGFkZGluZyByZXZpZXcgdGFncywgYXMgaXQgaXMgd2VsbCB0cmFja2Vk
LiBZb3UgY2FuIHNlZSBzdGF0dXMgb2YgbmV0ZGV2IGNoYW5nZXMgZnJvbQ0KcGF0Y2h3b3JrOg0K
aHR0cHM6Ly91cmxkZWZlbnNlLmNvbS92My9fX2h0dHBzOi8vcGF0Y2h3b3JrLmtlcm5lbC5vcmcv
cHJvamVjdC9uZXRkZXZicGYvbGlzdC8/c2VyaWVzPSZzdWJtaXR0ZXI9MjA3NTgwJnN0YXRlPSom
cT0mYXJjaGl2ZT1ib3RoJmRlbGVnYXRlPV9fO0tnISFDVFJOS0E5d01nMEFSYnchalh1WjJtT1hK
bmFJekZBNjk2bkJwMDlIWEdwSkJtdUgxVlZEX1JSVUFJVEVPWG0tLXpVUDhHRGRBbTB3YTcwLUli
eENCbWJSaFlSOVNhTG44TXVmMmJHMUU2OCQgIA0KDQpSZWdhcmRpbmcgdGhpcyBjaGFuZ2UgeW91
IHNob3VsZCBob3dldmVyIHJlc3VibWl0IGZvciB0aGUgbmV0LW5leHQgdHJlZSB3aXRoIGFwcHJv
cHJpYXRlIHN1YmplY3Qgc2luY2UgaXQgaXMgbm90IGEgYnVnIGZpeDoNCmh0dHBzOi8vdXJsZGVm
ZW5zZS5jb20vdjMvX19odHRwczovL3d3dy5rZXJuZWwub3JnL2RvYy9odG1sL2xhdGVzdC9wcm9j
ZXNzL21haW50YWluZXItbmV0ZGV2Lmh0bWw/aGlnaGxpZ2h0PW5ldGRldipob3ctZG8taS1pbmRp
Y2F0ZS13aGljaC10cmVlLW5ldC12cy1uZXQtbmV4dC1teS1wYXRjaC1zaG91bGQtYmUtaW5fXztJ
dyEhQ1RSTktBOXdNZzBBUmJ3IWpYdVoybU9YSm5hSXpGQTY5Nm5CcDA5SFhHcEpCbXVIMVZWRF9S
UlVBSVRFT1htLS16VVA4R0RkQW0wd2E3MC1JYnhDQm1iUmhZUjlTYUxuOE11ZmQzVWtJVkkkICAN
Cg0KVGhlbiBpdCBzaG91bGQgYmUgcGlja2VkIGJ5IG5ldGRldiBtYWludGFpbmVyKHMpLiBCdXQg
bm90ZSB0aGF0IHdlJ3JlIGN1cnJlbnRseSBpbiB0aGUgTGludXggNi4yIG1lcmdlIHdpbmRvdywg
c28gbWVyZ2luZyBmb3IgbmV0LW5leHQgY2FuIGJlIGRlbGF5ZWQgdW50aWwgdGhlIG1haW5saW5l
IG1lcmdlIHdpbmRvdyBpcyBjbG9zZWQgKGFuZCBuZXQtbmV4dA0Kb3Blbik6DQpodHRwczovL3Vy
bGRlZmVuc2UuY29tL3YzL19faHR0cHM6Ly93d3cua2VybmVsLm9yZy9kb2MvaHRtbC9sYXRlc3Qv
cHJvY2Vzcy9tYWludGFpbmVyLW5ldGRldi5odG1sP2hpZ2hsaWdodD1uZXRkZXYqaG93LW9mdGVu
LWRvLWNoYW5nZXMtZnJvbS10aGVzZS10cmVlcy1tYWtlLWl0LXRvLXRoZS1tYWlubGluZS1saW51
cy10cmVlX187SXchIUNUUk5LQTl3TWcwQVJidyFqWHVaMm1PWEpuYUl6RkE2OTZuQnAwOUhYR3BK
Qm11SDFWVkRfUlJVQUlURU9YbS0telVQOEdEZEFtMHdhNzAtSWJ4Q0JtYlJoWVI5U2FMbjhNdWZC
TDFMaHhnJCAgDQoNClJlZ2FyZHMsDQpMb2ljDQo=
