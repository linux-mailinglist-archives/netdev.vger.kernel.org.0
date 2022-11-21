Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E4DB631EF5
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 12:02:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiKULCS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 06:02:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiKULCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 06:02:16 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E7CA3436;
        Mon, 21 Nov 2022 03:02:06 -0800 (PST)
X-UUID: 22c59f0052144ee88a21161432520400-20221121
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=iMIXDDOZlBS3UP8LSRsGE4/ezbp8Wmm96cjAdzcz8ME=;
        b=ZA/NlxNcXHYkusMROb7bNj/yYtn8gDLoWggpouh65dKX8AbwQQdSqPBwDVUPNttA2rhsL2wLvBDQKePntgWeH/gIDTawaUdnl0Br2nH2czwGBncC9DfYS7b7C0gfZhE3C3L2feJtLTUBx8Oisxz24OW14NWSy7IWcZ0pGwD2EEw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.12,REQID:38b95f55-df6d-4001-935b-af8abad44fb9,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:62cd327,CLOUDID:c54ecbdb-6ad4-42ff-91f3-18e0272db660,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0
X-UUID: 22c59f0052144ee88a21161432520400-20221121
Received: from mtkexhb02.mediatek.inc [(172.21.101.103)] by mailgw02.mediatek.com
        (envelope-from <haozhe.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 2145910275; Mon, 21 Nov 2022 19:01:59 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Mon, 21 Nov 2022 19:01:59 +0800
Received: from APC01-SG2-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Mon, 21 Nov 2022 19:01:59 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KxaJx5mrcAhIWfB9eHUHE2CoUjrSOOCX7WsRy/2u/8ONucom1+D6mPhFLHs02enjDht9KuxZGIDFqTiR1LPqAH4y0YqVDQIK9tWeHUirLA/udVqhoq7uvE9ApjB5/alMh1bRZsD6NWUNxE/X+0B5T8SW++6C+wkzewZ+S4MvofDWgdgZ8yBFvKT6bWGVPJpmqqH5N7l17p92BVSLyHx4bsy9BBBHu9pEemll8qbyfKkE7apI+ipnVMrtK4u6YHc4vyzk3/GzHGf1vZv6R/bUQFgk3Kv9ZhOM8JUDuXE5gwuvlToatgqYFOTMdFDO6aUWc2uCuqrp+TALBOa4ZRzutQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iMIXDDOZlBS3UP8LSRsGE4/ezbp8Wmm96cjAdzcz8ME=;
 b=V3yhSPS/TnmtlcjQVYNcUgcQSJ2Ns2SureK9XtS5qMVWbsI3QfDYJrKJha5Jutp+tlDML5Sofi9gz268ke4c/LRONSxZzkf1B/4em9HDtvdKpE2qGucmCeUyV1LKtIfbHxdHXoEVP5jS9pEK6yBiLT/re1CnX64zE70HiJUrcwiJL+2cZ+pnC4ELnh2t24MIIBdbAyBAXIDDSxUEfd6q3pbN9hR7lAkThIYFrI0wVNbQadCdwkrAbdGJ1BeyQ9qkjFtFZCBTHmFRF3ls79o0/DrMuc2d9203/x/W92ZtOptu41/a9z5C7GHc7CbX1oF4fWaP7HUDUxx0zdbSrOQPRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iMIXDDOZlBS3UP8LSRsGE4/ezbp8Wmm96cjAdzcz8ME=;
 b=ED9VzPoNzrSUB3nzHMclgXjgdloaceOA1JcUuXHpq+0HVYzjnpfp6e2qGcSXff7K6jBkpvzohXtgWYDYa91w/GFrIBV688V/+Dl5w2c7a3fFW4wdZN48LtROIHDom/dO+0Tn6A8cWb+VC6xTozIY4dAqC30N9Ay9ZGKxRiWfAw4=
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com (2603:1096:301:8f::9)
 by SI2PR03MB6613.apcprd03.prod.outlook.com (2603:1096:4:1e4::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 11:01:57 +0000
Received: from PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::3e67:567d:4e5f:307d]) by PSAPR03MB5653.apcprd03.prod.outlook.com
 ([fe80::3e67:567d:4e5f:307d%9]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 11:01:57 +0000
From:   =?utf-8?B?SGFvemhlIENoYW5nICjluLjmtanlk7Ip?= 
        <Haozhe.Chang@mediatek.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "stephan@gerhold.net" <stephan@gerhold.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-remoteproc@vger.kernel.org" <linux-remoteproc@vger.kernel.org>,
        "linuxwwan@intel.com" <linuxwwan@intel.com>,
        "m.chetan.kumar@intel.com" <m.chetan.kumar@intel.com>,
        "oneukum@suse.com" <oneukum@suse.com>,
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
Thread-Index: AQHY9bWtrKc/UECIFUujkKbHGSO6OK450bSAgAR53QCAAAS3AIAK9aEA
Date:   Mon, 21 Nov 2022 11:01:57 +0000
Message-ID: <7e67abf9ccbbb74d86440642fdf58540785a07db.camel@mediatek.com>
References: <20221111100840.105305-1-haozhe.chang@mediatek.com>
         <Y25j7fTdvCRqr26k@kroah.com>
         <82c8728b0b0b20c7da4e25642e90de27af52feca.camel@mediatek.com>
         <Y3IpGs0SFSgvS0kw@kroah.com>
In-Reply-To: <Y3IpGs0SFSgvS0kw@kroah.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PSAPR03MB5653:EE_|SI2PR03MB6613:EE_
x-ms-office365-filtering-correlation-id: c2172f11-6dde-49d7-b754-08dacbafce7e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hbUzD9hP+KGsp25iMRw4VhWbzACDMK+QxuVtELB+Ykxl9IGyD8cfJ64jXfCQ3stGQ5uIArIoK1cfdC+eqYJ96QBPdGq5uQSNliwfxs5TRYv6MSw/9/MuVVMgHSyp/c9iWYJNnmjOX9yjUw8JD2fDYuHMBbbtO2u/TBKCOS9BvPzTmpYe1Y+bCq/y38xj2OvYlhqjXJSqG2i7DtuxkfixsfnMNyAE1pwSExjMapIeQ+AxZW3de09LhN/0xjRLGKyf4KI/KA3yTbbNTogJn4oShb5uAR6eXe+JKn469PCAH07YZVRge1CX8nyLQTN4gTxYbxWHscw+GZ/MoguTad4Dg9T/49FKYkSTTGuckmPD2kv9evaAwn4MHz0tvgQgwlP2E/0Pt/U0ctmddKu9Ko38HsHta6I3EjwZyTGbZcVwKnCiEytExHjYX8SyKPrbMZJee2LGIju1gyrQzuCwEcFUfSbuXwy/vpuEgnTL1J1NiwCgyS4z3Fn/9japbqU/qpW4VbaeWTPkIjwifuh/t4spaxqCF3P8c0EHnXL4oL10cOqB0TgvoxuD6tXhthpl/TjEuzIbCvC0fFv55ZyRiu+JPapFQfM2AvbeY4DGIcIyOe+fQf7EGV5QApA0qGZhApuvWb3nccKqc8nWfVFtHIfBh9MrWq9rAMzVzlUK9rFVWZzHtHVRCz1Pwi5WrXjKBbqxGsepNsUNhydMChmARLonNumfHygfuPH3DxIMpaLKvoI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PSAPR03MB5653.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(39860400002)(366004)(346002)(396003)(376002)(136003)(451199015)(38100700002)(83380400001)(122000001)(2906002)(38070700005)(86362001)(8676002)(4001150100001)(7416002)(8936002)(4326008)(66476007)(64756008)(66446008)(41300700001)(5660300002)(71200400001)(107886003)(26005)(6506007)(6512007)(316002)(186003)(2616005)(6916009)(54906003)(91956017)(478600001)(76116006)(66556008)(66946007)(6486002)(36756003)(85182001)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TnRxdHBqK0NHOGthS1Y4OWJDQ25Xc2RMZWpSei90U2Q1SlJBM2RJU2RHdXNy?=
 =?utf-8?B?OTZzSlpFam5lQmMvdTYxZVBDR0FlVEZvS2g3LzdYM2NuK042am5rTGRYb3lV?=
 =?utf-8?B?Vys5TjZWamppR3VxZi9aYjNHYmZwRWpvT0pHU1BYU0R3UVh3ZXpaTXlNRFBC?=
 =?utf-8?B?aFEwb0o0dnBIdFZRQlNLckhtd2Zab1ZkNGQ2Mms0WFhHZDJYbjgzTWNaSDdU?=
 =?utf-8?B?dU5pakNRcnU4TG40SUF4MWhZbnNNdkFvU0VDaVlDVmpqYlBmZVFvSXN5RUYv?=
 =?utf-8?B?Y0VOVGRIMlhYQmViQ24yajNHODRxTysrWm1UWVREMXN1ZGM1NzIxcXltN1ho?=
 =?utf-8?B?ZU5oQnRHSER6eFVsYkVFWGNPZHFVRzZhcjBwdkRCUVZjcHduSlJheGIyLy9H?=
 =?utf-8?B?MTNRbDJCUW0rZnJBQ1JRekVYbmFZcDJRKzVoTWFWTDhxSmNmUGZ4ZGZ0N1ZQ?=
 =?utf-8?B?OHNTNGhScDdCQ3lMU2s4bzl3RVBYZ0FxckVmZmxlMCtFYnJ5c0htMkVZV2dm?=
 =?utf-8?B?WW9lZFBxVEtvZi9EMVBnMzNsTW9pTm1rZmNMaS9nQ2tEQmVqU1VTTGNMWGE3?=
 =?utf-8?B?SzBja0o4UHVlNG9CamNSR3JCYVF2UFlpYTF5V1RTek5TdVMzY0x4SGt2Vmp4?=
 =?utf-8?B?MUptS21jcDUyMFUyb1NaN3p4bk9sTnhWYjZENXZ6cVgwU2lJM1lpQm9pUU9h?=
 =?utf-8?B?Wk5rZkRIa1l4QmdrWUJwaGlKamovQWMvNG9zNWtQT1dWL3QrbEJPTnVxVWdK?=
 =?utf-8?B?UWhPaU4rZnFzdERPRWZVNjV4dnBvcWUvRkJZeUtNNnZIUmRlZVhFdHp1NnZ3?=
 =?utf-8?B?Z0JNODZTSjZaQVVCOXl3OXNYWTdHaDIyZjF4bk4vZkdkS0tQdjJ2MERNYURk?=
 =?utf-8?B?TTVreHNPb0hxMGZTaXZpcndiWTVJZkZRbHhFU2hOZjdTYkRVamRlUXpsZFA1?=
 =?utf-8?B?Wk5Ma1V3djQwUEF5ZFpjNVZGL241ekFBemRHMDJCOXFuSE53ZEVxMitHeUE1?=
 =?utf-8?B?Y0UzNFNxSUNIR294SVNNbzVtUHB2M0VaT0dFSkFDdW54Zms0S3A5UDhhWEow?=
 =?utf-8?B?RXZzSkhSTVI5dGxaTGZxZHhRVzgvWmtyTEQ1MFp2UFlvMFR3MlRUV2RQaEhC?=
 =?utf-8?B?WFIzOUEzaFJQYmxYVXFyK2t2QUNWZ2k4WHpiOWtIVUs1YW5qVVRFbG9tV0VN?=
 =?utf-8?B?MzJxYy9wcjJDSTFMS1BBbXFveGorbTBhS0RsUURMVGdOb2VwTnNXNU9maHZU?=
 =?utf-8?B?WVlHRFUrbEhxc2EramJwOG43VXhySmYvZDc4c0ZJUE96YkJ1a3NsMGVaZFlI?=
 =?utf-8?B?YVZyVlhKVWJiOGk1d2NXcVliOWtOSjBJR2Vhd3VHdXdiVmVVNGZ4cmJXa2tT?=
 =?utf-8?B?RkhQMmVtcDVlM0Y5ZEtYN3crNytSdU95Vm96L3BtMVNZNGtNZFBiaElscUd2?=
 =?utf-8?B?eXZmVlZoT1VOMnM5SHM2TlFSYlh4d2RYSUoyODF1eTVwNDh6NGJMZFRpaFN2?=
 =?utf-8?B?Rk5LYUwvNFNaczBQc3N4My81ZGc2R2hLUkhGU2V6NTdtbjc5c2xXU2RmNStH?=
 =?utf-8?B?ZEJwTFNPcXFYUXdPaWttR3ZrK3c4dlhTRWROazAxbE1rMmVvS2xOZUphTDYy?=
 =?utf-8?B?Z1g1ekMrdXBVNWRDWXNkQmdnU3l6WVVYOWZsR1ZnQUMvQzUvdStvYXR0Tncv?=
 =?utf-8?B?S1NNdGhHVlVOTCtzWXRzUE5IY0JMcEFqblh4dEhyVngyKzFHZ2VYZDNiUkFy?=
 =?utf-8?B?N2lUbzJqb1phL0J6c0VaUHdiUXlWUHpRdkp3THhOTWM1QVlSUTdBUWZHVFAr?=
 =?utf-8?B?MW1KQ3ZPTzB0VTFUVmhSS1EyQVNFUUF0dlV5K3hRN1lqdDhxVjdwVGIyS0NS?=
 =?utf-8?B?OWU5R2wrUHFxLzIyQ1hTQ3RtQld2WTBudlpyOWd0TXlsZU55bUtxbWY2OEhO?=
 =?utf-8?B?S0tkQUR1djZqVTM4d0cyb2FYR0VoNDlmOXpGTi9zQnlnZDl2OHZxMzhjL0pB?=
 =?utf-8?B?NXplRDc3OFpDWlVrMysvdWY0REVHanFyeWxyaWgvanV2aFRXQWZtZFhFZ3g1?=
 =?utf-8?B?VW9ibGk4S3FPVGpveUgzUFdXejQzYzNRSTdiY21nOThZeGM3WnY4UEJsYmk4?=
 =?utf-8?B?SnVvQ05nMkRNL1hiRktFODN5dm1DbU0wd0Z3elNLY3FoMSs2RjhFZGhMYzhE?=
 =?utf-8?B?Q1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <26730AE4F1E0BC4F9BCE752B9CAE3E34@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PSAPR03MB5653.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2172f11-6dde-49d7-b754-08dacbafce7e
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 11:01:57.0159
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SGb/uY4cVMD3C1F/fPJaHy7Pj2ZWE/HTBXVUvoKRf+votLzZWv3HmQBVYgeNPUtjaZ/0K8k527FQxPrggWwl9ff/SFVykAhJYSUFRjwynxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB6613
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SPF_TEMPERROR,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDIyLTExLTE0IGF0IDEyOjQwICswMTAwLCBncmVna2hAbGludXhmb3VuZGF0aW9u
Lm9yZyB3cm90ZToNCj4gT24gTW9uLCBOb3YgMTQsIDIwMjIgYXQgMTE6MjM6MTlBTSArMDAwMCwg
SGFvemhlIENoYW5nICjluLjmtanlk7IpIHdyb3RlOg0KPiA+IEhpIEdyZWcgS3JvYWgtSGFydG1h
bg0KPiA+IA0KPiA+IE9uIEZyaSwgMjAyMi0xMS0xMSBhdCAxNjowMiArMDEwMCwgR3JlZyBLcm9h
aC1IYXJ0bWFuIHdyb3RlOg0KPiA+ID4gT24gRnJpLCBOb3YgMTEsIDIwMjIgYXQgMDY6MDg6MzZQ
TSArMDgwMCwgDQo+ID4gPiBoYW96aGUuY2hhbmdAbWVkaWF0ZWsuY29tDQo+ID4gPiB3cm90ZToN
Cj4gPiA+ID4gRnJvbTogaGFvemhlIGNoYW5nIDxoYW96aGUuY2hhbmdAbWVkaWF0ZWsuY29tPg0K
PiA+ID4gPiANCj4gPiA+ID4gd3dhbl9wb3J0X2ZvcHNfd3JpdGUgaW5wdXRzIHRoZSBTS0IgcGFy
YW1ldGVyIHRvIHRoZSBUWA0KPiA+ID4gPiBjYWxsYmFjayBvZg0KPiA+ID4gPiB0aGUgV1dBTiBk
ZXZpY2UgZHJpdmVyLiBIb3dldmVyLCB0aGUgV1dBTiBkZXZpY2UgKGUuZy4sIHQ3eHgpDQo+ID4g
PiA+IG1heQ0KPiA+ID4gPiBoYXZlIGFuIE1UVSBsZXNzIHRoYW4gdGhlIHNpemUgb2YgU0tCLCBj
YXVzaW5nIHRoZSBUWCBidWZmZXIgdG8NCj4gPiA+ID4gYmUNCj4gPiA+ID4gc2xpY2VkIGFuZCBj
b3BpZWQgb25jZSBtb3JlIGluIHRoZSBXV0FOIGRldmljZSBkcml2ZXIuDQo+ID4gPiA+IA0KPiA+
ID4gPiBUaGlzIHBhdGNoIGltcGxlbWVudHMgdGhlIHNsaWNpbmcgaW4gdGhlIFdXQU4gc3Vic3lz
dGVtIGFuZA0KPiA+ID4gPiBnaXZlcw0KPiA+ID4gPiB0aGUgV1dBTiBkZXZpY2VzIGRyaXZlciB0
aGUgb3B0aW9uIHRvIHNsaWNlKGJ5IGZyYWdfbGVuKSBvcg0KPiA+ID4gPiBub3QuIEJ5DQo+ID4g
PiA+IGRvaW5nIHNvLCB0aGUgYWRkaXRpb25hbCBtZW1vcnkgY29weSBpcyByZWR1Y2VkLg0KPiA+
ID4gPiANCj4gPiA+ID4gTWVhbndoaWxlLCB0aGlzIHBhdGNoIGdpdmVzIFdXQU4gZGV2aWNlcyBk
cml2ZXIgdGhlIG9wdGlvbiB0bw0KPiA+ID4gPiByZXNlcnZlDQo+ID4gPiA+IGhlYWRyb29tIGlu
IGZyYWdtZW50cyBmb3IgdGhlIGRldmljZS1zcGVjaWZpYyBtZXRhZGF0YS4NCj4gPiA+ID4gDQo+
ID4gPiA+IFNpZ25lZC1vZmYtYnk6IGhhb3poZSBjaGFuZyA8aGFvemhlLmNoYW5nQG1lZGlhdGVr
LmNvbT4NCj4gPiA+ID4gDQo+ID4gPiA+IC0tLQ0KPiA+ID4gPiBDaGFuZ2VzIGluIHYyDQo+ID4g
PiA+ICAgLXNlbmQgZnJhZ21lbnRzIHRvIGRldmljZSBkcml2ZXIgYnkgc2tiIGZyYWdfbGlzdC4N
Cj4gPiA+ID4gDQo+ID4gPiA+IENoYW5nZXMgaW4gdjMNCj4gPiA+ID4gICAtbW92ZSBmcmFnX2xl
biBhbmQgaGVhZHJvb21fbGVuIHNldHRpbmcgdG8gd3dhbl9jcmVhdGVfcG9ydC4NCj4gPiA+ID4g
LS0tDQo+ID4gPiA+ICBkcml2ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfcG9ydC5jICB8ICAz
ICstDQo+ID4gPiA+ICBkcml2ZXJzL25ldC93d2FuL21oaV93d2FuX2N0cmwuYyAgICAgICB8ICAy
ICstDQo+ID4gPiA+ICBkcml2ZXJzL25ldC93d2FuL3JwbXNnX3d3YW5fY3RybC5jICAgICB8ICAy
ICstDQo+ID4gPiA+ICBkcml2ZXJzL25ldC93d2FuL3Q3eHgvdDd4eF9wb3J0X3d3YW4uYyB8IDM0
ICsrKysrKystLS0tLS0tLQ0KPiA+ID4gPiAgZHJpdmVycy9uZXQvd3dhbi93d2FuX2NvcmUuYyAg
ICAgICAgICAgfCA1OQ0KPiA+ID4gPiArKysrKysrKysrKysrKysrKysrKw0KPiA+ID4gPiAtLS0t
LS0NCj4gPiA+ID4gIGRyaXZlcnMvbmV0L3d3YW4vd3dhbl9od3NpbS5jICAgICAgICAgIHwgIDIg
Ky0NCj4gPiA+ID4gIGRyaXZlcnMvdXNiL2NsYXNzL2NkYy13ZG0uYyAgICAgICAgICAgIHwgIDIg
Ky0NCj4gPiA+ID4gIGluY2x1ZGUvbGludXgvd3dhbi5oICAgICAgICAgICAgICAgICAgIHwgIDYg
KystDQo+ID4gPiA+ICA4IGZpbGVzIGNoYW5nZWQsIDczIGluc2VydGlvbnMoKyksIDM3IGRlbGV0
aW9ucygtKQ0KPiA+ID4gPiANCj4gPiA+ID4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3d3YW4v
aW9zbS9pb3NtX2lwY19wb3J0LmMNCj4gPiA+ID4gYi9kcml2ZXJzL25ldC93d2FuL2lvc20vaW9z
bV9pcGNfcG9ydC5jDQo+ID4gPiA+IGluZGV4IGI2ZDgxYzYyNzI3Ny4uZGM0M2I4ZjBkMWFmIDEw
MDY0NA0KPiA+ID4gPiAtLS0gYS9kcml2ZXJzL25ldC93d2FuL2lvc20vaW9zbV9pcGNfcG9ydC5j
DQo+ID4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L3d3YW4vaW9zbS9pb3NtX2lwY19wb3J0LmMNCj4g
PiA+ID4gQEAgLTYzLDcgKzYzLDggQEAgc3RydWN0IGlvc21fY2RldiAqaXBjX3BvcnRfaW5pdChz
dHJ1Y3QNCj4gPiA+ID4gaW9zbV9pbWVtDQo+ID4gPiA+ICppcGNfaW1lbSwNCj4gPiA+ID4gIAlp
cGNfcG9ydC0+aXBjX2ltZW0gPSBpcGNfaW1lbTsNCj4gPiA+ID4gIA0KPiA+ID4gPiAgCWlwY19w
b3J0LT5pb3NtX3BvcnQgPSB3d2FuX2NyZWF0ZV9wb3J0KGlwY19wb3J0LT5kZXYsDQo+ID4gPiA+
IHBvcnRfdHlwZSwNCj4gPiA+ID4gLQkJCQkJICAgICAgICZpcGNfd3dhbl9jdHJsX28NCj4gPiA+
ID4gcHMsDQo+ID4gPiA+IGlwY19wb3J0KTsNCj4gPiA+ID4gKwkJCQkJICAgICAgICZpcGNfd3dh
bl9jdHJsX28NCj4gPiA+ID4gcHMsIDAsDQo+ID4gPiA+IDAsDQo+ID4gPiA+ICsJCQkJCSAgICAg
ICBpcGNfcG9ydCk7DQo+ID4gPiANCj4gPiA+IEhvdyBpcyAwLCAwIGEgdmFsaWQgb3B0aW9uIGhl
cmU/DQo+ID4gPiANCj4gPiA+IGFuZCBpZiBpdCBpcyBhIHZhbGlkIG9wdGlvbiwgc2hvdWxkbid0
IHlvdSBqdXN0IGhhdmUgMiBkaWZmZXJlbnQNCj4gPiA+IGZ1bmN0aW9ucywgb25lIHRoYXQgbmVl
ZHMgdGhlc2UgdmFsdWVzIGFuZCBvbmUgdGhhdCBkb2VzDQo+ID4gPiBub3Q/ICBUaGF0DQo+ID4g
PiB3b3VsZCBtYWtlIGl0IG1vcmUgZGVzY3JpcHRpdmUgYXMgdG8gd2hhdCB0aG9zZSBvcHRpb25z
IGFyZSwgYW5kDQo+ID4gPiBlbnN1cmUNCj4gPiA+IHRoYXQgeW91IGdldCB0aGVtIHJpZ2h0Lg0K
PiA+ID4gDQo+ID4gDQo+ID4gMCBpcyBhIHZhbGlkIG9wdGlvbi4gDQo+ID4gZnJhZ19sZW4gc2V0
IHRvIDAgbWVhbnMgbm8gc3BsaXQsIGFuZCBoZWFkcm9vbSBzZXQgdG8gMCBtZWFucyBubyANCj4g
PiByZXNlcnZlZCBoZWFkcm9vbSBpbiBza2IuIA0KPiA+IA0KPiA+IFNvcnJ5LCBJIGNhbid0IHVu
ZGVyc3RhbmQgd2h5IGl0J3MgbW9yZSBkZXNjcmlwdGl2ZSwgY291bGQgeW91IGhlbHANCj4gPiB3
aXRoIG1vcmUgaW5mb3JtYXRpb24/IEl0IHNlZW1zIHRvIG1lIHRoYXQgdGhlIGRldmljZSBkcml2
ZXIgbmVlZHMNCj4gPiB0bw0KPiA+IGtub3cgd2hhdCBlYWNoIHBhcmFtZXRlciBpcyBhbmQgaG93
IHRvIHNldCB0aGVtLCBhbmQgdGhhdCBwcm9jZXNzDQo+ID4gaXMNCj4gPiBhbHNvIHJlcXVpcmVk
IGluIHlvdXIgcHJvcG9zZWQgc29sdXRpb24gLSAid2l0aCAyIGRpZmZlcmVudA0KPiA+IGZ1bmN0
aW9ucyIsDQo+ID4gcmlnaHQ/DQo+IA0KPiBXaGVuIHlvdSBzZWUgcmFuZG9tIGludGVnZXJzIGlu
IHRoZSBtaWRkbGUgb2YgYSBmdW5jdGlvbiBjYWxsIGxpa2UNCj4gdGhpcywNCj4geW91IHRoZW4g
aGF2ZSB0byBnbyBhbmQgbG9vayB1cCB0aGUgZnVuY3Rpb24gY2FsbCB0byBkZXRlcm1pbmUgd2hh
dA0KPiBleGFjdGx5IHRob3NlIHZhbHVlcyBhcmUgYW5kIHdoYXQgaXMgaGFwcGVuaW5nLiAgVXNp
bmcgMCwgMCBhcyB2YWxpZA0KPiB2YWx1ZXMgaGVscHMgbm8gb25lIG91dCBoZXJlIGF0IGFsbC4N
Cj4gDQo+IFdoaWxlIGlmIHRoZSBjb2RlIHNhaWQ6DQo+IAlpcGNfcG9ydC0+aW9zbV9wb3J0ID0g
d3dhbl9jcmVhdGVfcG9ydChpcGNfcG9ydC0+ZGV2LA0KPiBwb3J0X3R5cGUsDQo+IAkJCQkJCSZp
cGNfd3dhbl9jdHJsX29wcywNCj4gCQkJCQkJTk9fU1BMSVQsDQo+IAkJCQkJCU5PX1JFU0VSVkVE
X0hFQURST09NLA0KPiAJCQkJCQlpcGNfcG9ydCk7DQo+IA0KPiANCj4gb3Igc29tZXRoaW5nIGxp
a2UgdGhhdCwgaXQgd291bGQgbWFrZSBtb3JlIHNlbnNlLCByaWdodD8NCj4gDQo+IFJlbWVtYmVy
LCB3ZSB3cml0ZSBjb2RlIGZvciBwZW9wbGUgdG8gcmVhZCBhbmQgdW5kZXJzdGFuZCBhbmQNCj4g
bWFpbnRhaW4NCj4gaXQgb3ZlciB0aW1lIGZpcnN0LCBmb3IgdGhlIGNvbXBpbGVyIHNlY29uZC4N
Cj4gDQpZZXMsIHlvdSdyZSByaWdodCwgSSdsbCBjaGFuZ2UgaXQ6IGNoYW5nZSB0aGUgcmFuZG9t
IGludGVnZXIgdG8gdGhlDQptYWNybyBkZWZpbml0aW9uIHRvIG1ha2UgaXQgbW9yZSByZWFkYWJs
ZSwgdGhhbmtzLg0KPiB0aGFua3MsDQo+IA0KPiBncmVnIGstaA0K
