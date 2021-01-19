Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7022FB8FF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 15:34:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395277AbhASOM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 09:12:29 -0500
Received: from mail2.eaton.com ([192.104.67.3]:10400 "EHLO mail2.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389611AbhASNZ4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 08:25:56 -0500
Received: from mail2.eaton.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 5058D8C135;
        Tue, 19 Jan 2021 08:25:04 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1611062704;
        bh=ATCTlNcqaiuZN4o+8T5xcRGcNG8lJFssoMSfOitkGBg=; h=From:To:Date;
        b=Hpkl0I5OYFw1HdYapi52SaLOgO9ZCcK9J2sGEG/sYb2DGlmb11kknwkuMvh4qLKDa
         xPSav5k1Z+kG+mrLkYINWLLRaMNwHuizQwxen+UygYgGJEKt5vIrSAiA2yDAtOHpVq
         Bki126sQFR/bOjyez25VThWV0WAOeKYRRvKhAHc/s7qJq6kLaJMGWvTwc6Bc1ZARER
         uXY89TpicxZ5C/Ob2HatajWIpq2UNSbOYzAlke7ZIngfnr1yhmW0LX4k3xUWXsUpHm
         4oLmWpHLbskYFXdACrqZzLQkkEWKz9zKccshphOb86fSBaQ8FY+5G9zTFhxfSl4gZC
         59iIUZsnErzoQ==
Received: from mail2.eaton.com (simtcimsva04.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 2BD4C8C120;
        Tue, 19 Jan 2021 08:25:04 -0500 (EST)
Received: from SIMTCSGWY03.napa.ad.etn.com (simtcsgwy03.napa.ad.etn.com [151.110.126.189])
        by mail2.eaton.com (Postfix) with ESMTPS;
        Tue, 19 Jan 2021 08:25:04 -0500 (EST)
Received: from LOUTCSHUB04.napa.ad.etn.com (151.110.40.77) by
 SIMTCSGWY03.napa.ad.etn.com (151.110.126.189) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Tue, 19 Jan 2021 08:25:03 -0500
Received: from USSTCSEXHET02.NAPA.AD.ETN.COM (151.110.240.154) by
 LOUTCSHUB04.napa.ad.etn.com (151.110.40.77) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Tue, 19 Jan 2021 08:25:03 -0500
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.177)
 by hybridmail.eaton.com (151.110.240.154) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Tue, 19 Jan 2021 08:24:41 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ynq5EevlqjnenfYbYan0ssDez7K90qjMpK1CEiUZF8E5vL6bW2Mx/KbGG2agt4QJiHRemiilyux2qMd4a8NGP1M2ZH/ZqUeg2qg4s17nccwJz9DsJZA93vBPG3ItHqAoCVcYg+XBBm8/sSKfQy3oAB4dYEaPWqISo7M76vEgeXA5/hHcIfOX3NnBHRPfjasd2rpoaAZa/FGnwyCWeEh1VMj0gwDN+oquCMpQ3ZKMbT7L2vMh1ZPFTIFfwFDK8jetQQO5nmJCdJHjOyx/op8pb9aAo+JK5el7HhPOQu7VaglgbfKxiirGEU0G+WqgIZUxUChFGYwSBJ2M3Tvu287h2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQG2DpexawlFPZxg+bfFYBbYXBw5ZPmA3mXcHEoFQd0=;
 b=YWhGw03Aj4sc3T/XIu6Hzb19/Czg2B2cSV29u2+eCZsj/s9irxzg0HeuTFIckpJM7NxMKQ5KTYMPfGKLmoLxuKaqiEVvKDTofxNCgp30/gN/vnBFaE1ZiQAbHIW/raEJ4Aq4F+QcLHnLHSu3zxJ/nGnukhUVt7t4z6lu15wQB4p9b7b2UNXQrEqDkgr+kyWereTXT/7jJdCJOfiiS9ccZlg+vZhXQ3IlWWq0vq2XLB/PQmv2f1iquojZ6U/TuJfNXCgP+iI6AXaTFSs66GHCpMfew0ZoAqZOhAsVQJ4WxCvUqdxe9cm6B//U/Oil4gZ+U72hRu8rDIGugrzpdJjTFw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jQG2DpexawlFPZxg+bfFYBbYXBw5ZPmA3mXcHEoFQd0=;
 b=q0qWXerEp8BDZG02+awPrSlr7H4s9/vVKU2fu+GPaAR0QJxsaf/oRXDnOSmiUuhs3M96QAHWJw9ChUjdu1/7ZlC+mMqOXa6P1A0cxDNphuGFy6dUbEF7PKM1Fh1SJJ7u86uF5YwVrd57B4rUPyoBV96w0vtDSa9mcq7K2NFj9GM=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MW3PR17MB4171.namprd17.prod.outlook.com (2603:10b6:303:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Tue, 19 Jan
 2021 13:25:01 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 13:25:01 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Marco Felsch <m.felsch@pengutronix.de>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "marex@denx.de" <marex@denx.de>
Subject: RE: [EXTERNAL]  Re: [PATCH v4 net-next 0/5] net: phy: Fix SMSC
 LAN87xx external reset
Thread-Topic: [EXTERNAL]  Re: [PATCH v4 net-next 0/5] net: phy: Fix SMSC
 LAN87xx external reset
Thread-Index: Adbtun6FqUuZJJF1QZurTznkrBttxAAGmkuAABuBs3A=
Date:   Tue, 19 Jan 2021 13:25:01 +0000
Message-ID: <MW4PR17MB4243C724D3F7EB57EF9D964FDFA30@MW4PR17MB4243.namprd17.prod.outlook.com>
References: <MW4PR17MB42439280269409B3094724CCDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
 <20210118200253.m2pahxgn7ui7vups@pengutronix.de>
In-Reply-To: <20210118200253.m2pahxgn7ui7vups@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7287f9eb-c343-4b3b-8240-08d8bc7da049
x-ms-traffictypediagnostic: MW3PR17MB4171:
x-microsoft-antispam-prvs: <MW3PR17MB417192C605A0A7BB27657C2CDFA30@MW3PR17MB4171.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n5rCmqrcYEYoMyCNjVXfyf3an28Cb5zIhAoBstMkv41XvKmKJODpMFO66tL1E+i/T4TDl807/1aTPS7eaja97pkgLYqYGeJTd3KIZOH3rilhf85HXG5p1jeeQI+LE9c1DKjy0qPS+yjzAIg9SK7BamKVrCGetP1bZhy91Uyjnd7s6qd2o5+gRwkUPKXsUIzsXCD97OfOwMIUzji6Yfp8T4yX7FYTALSfF950Rx+UWn14HUydvCk05LvZV/7JdJMK7ZYX1Ud19BOMl/S6E9O07wZniVJsOfHgwDIe851IU08zGaPcFfEpHHOeyZ6n6IdC9Cvxu4eGQPAOoCNocgp+kecMgO3umUoQRRpp/eFBAMy2rOhlcvyFkSLT+CLYX16jeQ4eRrrNpSGsIMRSGm6rqC5l8RLSwSMUaNvqe+eZ2stCA2WJ76ZmPTO5OdItdhGmUQ7Dp97+yCHtKM1HANxJF74SOAxnD40TtdvRhyOiUXAZrwjLLkCQts51RdWi27Zja43t5hmDVBebZs+tDZ3Pgw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(396003)(366004)(136003)(346002)(9686003)(55016002)(186003)(478600001)(316002)(86362001)(83380400001)(54906003)(4326008)(26005)(7696005)(5660300002)(2906002)(66946007)(52536014)(53546011)(6916009)(6506007)(66556008)(8676002)(66446008)(71200400001)(64756008)(33656002)(8936002)(76116006)(7416002)(66476007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Y253T2NFa25WaG9GcmNvYTZvVSs3b3BmZVRMUGJpc3B2UWE5a09WdVU0bXIr?=
 =?utf-8?B?UlpqbmxESjh4SEMzemlkNHMvZWdzK2JOMHhmZkVyY1ZycjU5aGNCOEZSS3ZE?=
 =?utf-8?B?VkFmSTZIR3hybDZrOWJUWTN5NlloMGI1cUZ5bHk3K1U0ODhFSmlVdVNNSmlP?=
 =?utf-8?B?dmxuR0RRSFhrcm15U3RBN0ZVcDE5OWR6bEg4ZHoxZUhPYVRCTHZmVCtsNTdD?=
 =?utf-8?B?bkVrTm5QMlhpTHhJRzhXRk96K3JUOUZ3eHlQdTVEejFXZjhaZmVtOThFM05k?=
 =?utf-8?B?dTBGMXpyckJMVGcxOC9LUGpiYit1dWdVVEpLOVlLOGgwZUN0NFJJbDhidnd2?=
 =?utf-8?B?RS84R2IzRUtrdUZZYVJRQVdiMXVUcWxyTEU1eDJ4d2lrdjN3b2RtVnQzSldI?=
 =?utf-8?B?SjVENVc4aDZwTzA0MGZ0WXY3QWRsZW9WVkd2V1JaZGw2TjRVRVdYZ0p3eUVw?=
 =?utf-8?B?NzkwQ3ZBemZqODRXMlZUWXRUdU1jTzdTRW16M05aTFIyYzBSVXBoaTFVeWZY?=
 =?utf-8?B?RC9PNDVKTXk0dWpIMWZJZXRZNWczK24ydHM0alJCNEdzSHhEaGJBNE1hbWFG?=
 =?utf-8?B?eUdrTi9CMmc5QUpMbS8xS1k0anZTaDM4QmNzZVNVY0I3RUd5d3BJUGNSMHRn?=
 =?utf-8?B?c2pIOEg2UlI3N2k4OWY1WmVqVE0xbmJocU9BTDU3K0pFMmNRYW9CMENMOHRj?=
 =?utf-8?B?WVJTbGZSZEZhSTVmNmt3dlJ2OE83cmJZYVNuL0dpSUZhSzV3RzA4QTh0Y1Ir?=
 =?utf-8?B?c2RtckVnbkUvaUZqeDBBWk9xWSs4K1B4ZWZKY0Z0N3hhRzdNYndUa3RuUXZw?=
 =?utf-8?B?VDBQNGk3bkxzMnlnVVZrcmdyMzVTeWhsQW95WFJ5RHJ2azdiZE1xN1ZtTUlE?=
 =?utf-8?B?L0FUQkc2SEY5a1hwTkxTTitYbnBRcHNIQWZSNWxuNVlycWI2NjdtRTZLU3dU?=
 =?utf-8?B?UkpLY1lXc1pmVEprK0tVQ2V6YkhwckhScmxjTXQwQkpjZjhlRnp0Vlk4ZTRi?=
 =?utf-8?B?cWpDTUloZUVhb2o2YUdCZndWVTdkVHYyQ25iaElkc2FiZFhpL1dMRnRTWTlK?=
 =?utf-8?B?YjlYVWlnR0NaS1libXBQNTcwWGtYVDJHdlFIUGt2enE2RmpzcXNxWjhpUXpa?=
 =?utf-8?B?TTMrSjJVVU12eFg1WEIrVGdVR3dkenZOYWE0UEZ2dndUZUVLb29GcXlkT0kv?=
 =?utf-8?B?RkRoWFdtSVNXdUNjUlFqeUtKRmZUMlM4UjEyM2R3OW8veXRvWVNFMlJtV0pt?=
 =?utf-8?B?VDRONlVmNGx0NW5zUWFaUUlVZndzQ3NSTDVVSm1FemdTV2ZNeXcrc0hzSUYy?=
 =?utf-8?Q?aa8ixZzeOMD90=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7287f9eb-c343-4b3b-8240-08d8bc7da049
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 13:25:01.7935
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cbPjMCFOt6SlJlumvlT6rkd+qzo8uUSyA6GRdO2OZc0IiUuxOtLxz68R+6aSkevt31fSmMF2+Le+odLkxw9DHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR17MB4171
X-TM-SNTS-SMTP: FE35E8AAFEA2D9357BD456CA9B534FECA4CB2FECD96577B2DC84FD41228D3C5E2002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.007
X-TM-AS-Result: No--17.226-7.0-31-10
X-imss-scan-details: No--17.226-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.007
X-TMASE-Result: 10--17.225900-10.000000
X-TMASE-MatchedRID: B/xZ9ueeRnApwNTiG5IsEldOi7IJyXyIPbO0S2sWaK3+UVve/ZY5tAAK
        HlqXCFYyFsoSYTyGmMS8jw5tV4j5N6DnkXE/iJaxlXePXNM4FjMiJN3aXuV/oYAjsy+r+wvnYBN
        LrOYveYeZ1i7HY4Fa2mLAc8HDb+/q4DhTNYaHUgNIcJTn2Hkqsdq1p6neH75UeZsdNrsryaxpRe
        zoWC5XLZAhC74hufvucT3LDrIBSWl2CEKBxIsfqovqrlGw2G/kMI2NtA9qrmIda1Vk3RqxOOhwD
        wqATBtTh3CzeKZOWHtYejcVCXX1sg73pMjWPW+oIwk7p1qp3JbnpmIrKZRxTkl/J9Ro+MAB7yZd
        jQ74ky4hV2phUaI2F/Q9s5/XHok080x4p7nTryW5kFk6DtF9fxlKjo8zguyKGlfXMQvierf3rwe
        QC0JUYNQ6Y0qdmhZVPXQMn4FsKNqKAYxIsv6nSwGdJZ3Knh6hCIFiJP1XZ1JahAEL9o+TW0KPQF
        c/fMN/M+nnsEaleMobjonuEKLnQsslzLABTtTRpqbreSinCdMj56rvFVgJ7FoMgvB/UdXhwcv6F
        2TaYR0oycTqiNHD821epnhtOiFFeENXuE9FZ8cJuplsyNNdx2KA1HVKZBuTMKz0tt8wfDpYyLJ7
        di4unzl5XDgtlFs0K3EhyRlZZ3yrofp7IohGw5RUn//0eq2KNeDk89E8KlwDAA5uRHailgRMNuY
        zzuREysL9kp6GGWsQS6J7Dprc4gy0MFDlU705MIxbvM3AVog4OkSgsem1dVIxScKXZnK0PndSIq
        iLvE6kGR2Wha5wrMGA9T8IEJf22I3DiOO33LGeAiCmPx4NwA0cjZtwBq3++gD2vYtOFhgqtq5d3
        cxkNQwWxr7XDKH8cIANl8MbgFUtOZ2SfCaGaRRcg/KP7j40LDlwHbfSAY0ahkXXto8Qyw==
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/VGhhbmsgeW91IHZlcnkgbXVjaCB0byBldmVyeW9uZSB3aG8gdG9vayB0aGUgdGltZSB0byBy
ZWFkIGFuZCBjb21tZW50IA0Kb24gdGhlIHBhdGNoLiANCg0KR2l2ZW4gdGhhdCBNYXJjbyBkb2Vz
bid0IHNlZW0gdG8gYWdyZWUgd2l0aCB0aGUgbWFpbiBpZGVhIG9mIHRoZSBwYXRjaCwgDQpJIGRv
bid0IHRoaW5rIGl0IGlzIHdvcnRoIHNlbmRpbmcgdGhlIGNvcnJlY3RlZCB2ZXJzaW9uIHNvIEkg
d2lsbCBsZWF2ZQ0KaXQgYXMgaXMuIA0KDQpNeSByZXBsaWVzIHRvIE1hcmNvJ3MgY29tbWVudHMg
YXJlIGJlbG93Lg0KDQpCZXN0IHJlZ2FyZHMsDQoNCkxhdXJlbnQNCg0KPiBIaSBMYXVyZW50LA0K
PiANCj4gdGhhbmtzIGZvciB5b3VyIHBhdGNoZXMgOikgQ2FuIHlvdSBjaGVjayB5b3VyIHNldHVw
IHNpbmNlIHdlIGdldCA2DQo+IGluZGl2aWR1YWwgZW1haWxzOiAnZ2l0IHNlbmQtZW1haWwgLS10
aHJlYWQgLi4uJyA7KQ0KDQpIaSBNYXJjbywgdGhhbmsgeW91IGZvciB5b3UgdGltZSByZXZpZXdp
bmcgYW5kIHNvcnJ5IGFib3V0IHRoZSB0aHJlYWRpbmcNCm9mIHRoZSBlbWFpbHMsIEkgd2lsbCBz
ZWUgdG8gaXQgbmV4dCB0aW1lLg0KDQo+IA0KPiBPbiAyMS0wMS0xOCAxNjo1NywgQmFkZWwsIExh
dXJlbnQgd3JvdGU6DQo+ID4gRGVzY3JpcHRpb246DQo+ID4gRXh0ZXJuYWwgUEhZIHJlc2V0IGZy
b20gdGhlIEZFQyBkcml2ZXIgd2FzIGludHJvZHVjZWQgaW4gY29tbWl0IFsxXQ0KPiB0bw0KPiA+
IG1pdGlnYXRlIGFuIGlzc3VlIHdpdGggaU1YIFNvQ3MgYW5kIExBTjg3eHggUEhZcy4gVGhlIGlz
c3VlIG9jY3Vycw0KPiA+IGJlY2F1c2UgdGhlIEZFQyBkcml2ZXIgdHVybnMgb2ZmIHRoZSByZWZl
cmVuY2UgY2xvY2sgZm9yIHBvd2VyDQo+IHNhdmluZw0KPiA+IHJlYXNvbnMgWzJdLCB3aGljaCBk
b2Vzbid0IHdvcmsgb3V0IHdlbGwgd2l0aCBMQU44N3h4IFBIWXMgd2hpY2gNCj4gPiByZXF1aXJl
IGEgcnVubmluZyBSRUZfQ0xLIGR1cmluZyB0aGUgcG93ZXItdXAgc2VxdWVuY2UuDQo+IA0KPiBO
b3Qgb25seSBkdXJpbmcgdGhlIHBvd2VyLXVwIHNlcXVlbmNlLiBUaGUgY29tcGxldGUgcGh5IGlu
dGVybmFsIHN0YXRlDQo+IG1hY2hpbmUgKHRoZSBoYXJkd2FyZSBzdGF0ZSBtYWNoaW5lKSBnZXRz
IGNvbmZ1c2VkIGlmIHRoZSBjbG9jayBpcw0KPiB0dXJuZWQgb2ZmIHJhbmRvbWx5Lg0KDQpZZXMs
IHlvdSBhcmUgcmlnaHQuIExBTjg3eHggZG9uJ3QgbGlrZSB0aGUgUkVGX0NMSyBiZWluZyB0dXJu
ZWQgb2ZmIHdoaWxlIA0KdGhleSBhcmUgcnVubmluZywgd2hpY2ggaXMgdW5kZXJzdGFuZGFibGUs
IHNvIHRoaXMgaXMgd2h5IHlvdSBzaG91bGQgDQplaXRoZXIgYXZvaWQgdHVybmluZyBpdCBvZmYs
IG9yIGlmIHlvdSBkbywgbWFrZSBzdXJlIHlvdSBkb24ndCBkbyBpdA0Kd2hpbGUgdGhlIFBIWSBp
cyBydW5uaW5nLg0KDQo+IA0KPiA+IEFzIGEgcmVzdWx0LCB0aGUgUEhZcw0KPiA+IG9jY2FzaW9u
YWxseSAoYW5kIHVucHJlZGljdGFibHkpIGZhaWwgdG8gZXN0YWJsaXNoIGEgc3RhYmxlIGxpbmsg
YW5kDQo+ID4gcmVxdWlyZSBhIGhhcmR3YXJlIHJlc2V0IHRvIHdvcmsgcmVsaWFibHkuDQo+ID4N
Cj4gPiBBcyBwcmV2aW91c2x5IG5vdGVkIFszXSwgdGhlIHNvbHV0aW9uIGluIFsxXSBpbnRlZ3Jh
dGVzIHBvb3JseSB3aXRoDQo+ID4gdGhlIFBIWSBhYnN0cmFjdGlvbiBsYXllciwgYW5kIGl0IGFs
c28gcGVyZm9ybXMgbWFueSB1bm5lY2Vzc2FyeQ0KPiA+IHJlc2V0cy4gVGhpcyBwYXRjaCBzZXJp
ZXMgc3VnZ2VzdHMgYSBzaW1wbGVyIHNvbHV0aW9uIHRvIHRoaXMNCj4gcHJvYmxlbSwNCj4gPiBu
YW1lbHkgdG8gaG9sZCB0aGUgUEhZIGluIHJlc2V0IGR1cmluZyB0aGUgdGltZSBiZXR3ZWVuIHRo
ZSBQSFkNCj4gZHJpdmVyDQo+ID4gcHJvYmUgYW5kIHRoZSBmaXJzdCBvcGVuaW5nIG9mIHRoZSBG
RUMgZHJpdmVyLg0KPiANCj4gSG9sZGluZyB0aGUgUGh5IHdpdGhpbiByZXNldCBkdXJpbmcgdGhl
IEZFQyBpcyBpbiByZXNldCBzZWVtcyB3cm9uZyB0bw0KPiBtZSBiZWNhdXNlOiBUaGUgY2xvY2sg
Y2FuIGJlIHN1cHBsaWVkIGJ5IGFuIGV4dGVybmFsIGNyeXN0YWwvb3N6aS4NCj4gVGhpcyB3b3Vs
ZCBhZGQgdW5uZWNlc3NhcnkgZGVsYXlzLiBBbHNvIHRoaXMgaXMgYWdhaW4gYSBGRUMvU01TQw0K
PiBjb21iaW5hdGlvbiBmaXggYWdhaW4uIFRoZSBwaHkgaGFzIHRoZSBzYW1lIHByb2JsZW0gb24g
b3RoZXIgaG9zdHMgaWYNCj4gdGhleSBhcmUgdGhlIGNsb2NrIHByb3ZpZGVyIGFuZCB0b2dnbGlu
ZyB0aGUgcmVmLWNsay4NCg0KSXQncyB0cnVlIHRoYXQgdGhlIFBIWSB3aWxsIGJlIGtlcHQgaW4g
cmVzZXQgdW50aWwgdGhlIGludGVyZmFjZSBpcyB1cCwgDQpidXQgdGhlbiBJIGRvbid0IHJlYWxs
eSBzZWUgdGhlIHBvaW50IG9mIGhhdmluZyB0aGUgUEhZIHJ1bm5pbmcgaWYgdGhlIA0KTUFDIGlz
IG5vdCBsaXN0ZW5pbmcgYW55d2F5LiBXaGVuIHRoZSBpbnRlcmZhY2UgaXMgdGFrZW4gZG93biwg
dGhlIFBIWQ0KbGF5ZXIgYXNzZXJ0cyB0aGUgcmVzZXQsIHNvIHRoaXMgaXMgYmFzaWNhbGx5IHRo
ZSBvbmx5IHBsYWNlIHdoZXJlIA0KdGhlIGludGVyZmFjZSBpcyBkb3duIGJ1dCB0aGUgUEhZIGlz
IG5vdCBoZWxkIGluIHJlc2V0LCBzbyBpbiBteSB2aWV3DQppdCBtYWRlIHNlbnNlIHRvIGRvIHRo
aXMuDQpCdXQgZmFpciBlbm91Z2gsIGtlZXBpbmcgdGhlIGNsb2NrIG9uIGRvZXMgdGhlIGpvYiBh
bmQgdGhhdCBpcyB3aGF0IA0KbWF0dGVycyBpbiB0aGUgZW5kLiBUaGlzIGlzIGF0IHRoZSBleHBl
bnNlIG9mIHBvd2VyIG1hbmFnZW1lbnQgdGhvdWdoLCANCmZvciBleGFtcGxlIHRoZSBjbG9jayBz
dGF5cyBvbiBkdXJpbmcgc3VzcGVuZC10by1yYW0sIHRob3VnaCB0aGlzDQpwZXJoYXBzIG5vdCB0
aGUgZW5kIG9mIHRoZSB3b3JsZCBpbmRlZWQuDQoNCj4gPiBUbyBpbGx1c3RyYXRlIHdoeSB0aGlz
IGlzIHN1ZmZpY2llbnQsIGJlbG93IGlzIGEgcmVwcmVzZW50YXRpb24gb2YNCj4gdGhlDQo+ID4g
UEhZIFJTVCBhbmQgUkVGX0NMSyBzdGF0dXMgYXQgcmVsZXZhbnQgdGltZSBwb2ludHMgKG5vdGUg
dGhhdCBSU1QNCj4gPiBzaWduYWwgaXMgYWN0aXZlLWxvdyBmb3IgTEFOODd4eCk6DQo+ID4NCj4g
PiAgMS4gRHVyaW5nIHN5c3RlbSBib290IHdoZW4gdGhlIFBIWSBpcyBwcm9iZWQ6DQo+ID4gIFJT
VCAgICAxMTExMTExMTExMTExMTExMTExMTEwMDAwMDExMTExMTExMTExMTENCj4gPiAgQ0xLICAg
IDAwMDAxMTExMTExMTExMTExMTExMTExMTExMTExMTExMTAwMDAwMA0KPiA+ICBSRUZfQ0xLIGlz
IGVuYWJsZWQgZHVyaW5nIGZlY19wcm9iZSgpLCBhbmQgdGhlcmUgaXMgYSBzaG9ydCByZXNldA0K
PiA+IHB1bHNlICBkdWUgdG8gbWRpb2J1c19yZWdpc3Rlcl9ncGlvZCgpIHdoaWNoIGNhbGxzDQo+
ID4gZ3Bpb2RfZ2V0X29wdGlvbmFsKCkgd2l0aA0KPiANCj4gVGhlcmUgaXMgYWxzbyBhIGRlcHJl
Y2F0ZWQgInBoeS1yZXNldC1ncGlvcyIgZGlkIHlvdSB0ZXN0IHRoaXMgYXMNCj4gd2VsbD8NCg0K
SSBnYXZlIGl0IGEgdHJ5LCBidXQgc2luY2UgRkVDIG9ubHkgdXNlcyB0aGlzIHRvIHJlc2V0IHRo
ZSBQSFkgYXQgcHJvYmUgDQp0aW1lLCB0aGVyZSBpcyBub3QgbXVjaCB0byBleHBlY3QuIEFzIGNh
biBiZSBleHBlY3RlZCwgaWYgd2Ugc2V0IA0KcGh5LXJlc2V0LWdwaW9zIGluIHRoZSBmZWMgbm9k
ZSwgYnV0IG5vdCByZXNldC1ncGlvcyBpbiB0aGUgcGh5IG5vZGUsIA0KdGhlIFBIWSBsYXllciBp
cyB1bmFibGUgdG8gcmVzZXQgdGhlIFBIWSwgc28gZGlzYWJsaW5nIHRoZSBSRUZfQ0xLIA0Kd291
bGQgbWVhbiB0cm91YmxlIGluZGVlZC4gDQogDQo+ID4gIHRoZSBHUElPRF9PVVRfTE9XIGZsYWcs
IHdoaWNoIHNldHMgdGhlIGluaXRpYWwgdmFsdWUgdG8gMC4gVGhlDQo+IHJlc2V0DQo+ID4gaXMg
IGRlYXNzZXJ0ZWQgYnkgcGh5X2RldmljZV9yZWdpc3RlcigpIHNob3J0bHkgYWZ0ZXIuICBBZnRl
ciB0aGF0LA0KPiA+IHRoZSBQSFkgIHJ1bnMgd2l0aG91dCBjbG9jayB1bnRpbCB0aGUgRkVDIGlz
IG9wZW5lZCwgd2hpY2ggY2F1c2VzDQo+IHRoZQ0KPiA+IHVuc3RhYmxlICBsaW5rIGlzc3VlLg0K
PiANCj4gTm9wZSB0aGF0J3Mgbm90IHRydWUsIHlvdSBjYW4gc3BlY2lmeSB0aGUgY2xvY2sgd2l0
aGluIHRoZSBkZXZpY2UtdHJlZQ0KPiBzbyB0aGUgZmVjLXJlZi1jbGsgaXNuJ3QgZGlzYWJsZWQg
YW55bW9yZS4NCg0KWWVzIHJpZ2h0LCBJIHdhcyBhc3N1bWluZyBjbG9ja3MgaXMgbm90IHNldCBp
biByZWZlcmVuY2UgdG8gdGhlIG9yaWdpbmFsDQpzb2x1dGlvbiBpbiBbMV0gYnV0IHRoYXQgbWF5
IG5vdCBoYXZlIGJlZW4gb2J2aW91cy4gDQogDQo+ID4gRXh0ZW5zaXZlIHRlc3Rpbmcgd2l0aCBM
QU44NzIwIGNvbmZpcm1lZCB0aGF0IHRoZSBSRUZfQ0xLIGNhbiBiZQ0KPiA+IGRpc2FibGVkIHdp
dGhvdXQgcHJvYmxlbXMgYXMgbG9uZyBhcyB0aGUgUEhZIGlzIGVpdGhlciBpbiByZXNldCBvcg0K
PiBpbg0KPiA+IHBvd2VyLWRvd24gbW9kZSAod2hpY2ggaXMgcmVsZXZhbnQgZm9yIHN1c3BlbmQt
dG8tcmFtIGFzIHdlbGwpLg0KPiANCj4gWW91IGNhbid0IGRpc2FibGUgdGhlIGNsb2NrLiBXaGF0
IHlvdSBsaXN0aW5nIGhlcmUgbWVhbnMgdGhhdCB0aGUgc21zYw0KPiBwaHkgbmVlZHMgdG8gYmUg
cmUtaW5pdGlhbGl6ZWQgYWZ0ZXIgc3VjaCBhbiBjbG9jayBsb3NzLiBJZiB3ZSBjYW4NCj4gZGlz
YmFsZSB0aGUgY2xvY2sgcmFuZG9tbHkgd2Ugd291bGRuJ3QgbmVlZCB0byByZS1pbml0aWFsaXpl
IHRoZSBwaHkNCj4gYWdhaW4uDQoNCkZhaXIgZW5vdWdoLCBpZiB5b3UgY29ycmVjdGx5IGNvbmZp
Z3VyZSB5b3VyIERUIHdpdGggdGhlIGNsb2NrcyBwcm9wZXJ0eSwgDQp0aGUgY2xvY2sgd2lsbCBz
dGF5IG9uLiAgDQoNCkJlc3QgcmVnYXJkcywNCg0KTGF1cmVudA0KDQoNCi0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLS0tDQpFYXRvbiBJbmR1c3RyaWVzIE1hbnVmYWN0dXJpbmcgR21iSCB+IFJl
Z2lzdGVyZWQgcGxhY2Ugb2YgYnVzaW5lc3M6IFJvdXRlIGRlIGxhIExvbmdlcmFpZSA3LCAxMTEw
LCBNb3JnZXMsIFN3aXR6ZXJsYW5kIA0KDQotLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0K
DQo=
