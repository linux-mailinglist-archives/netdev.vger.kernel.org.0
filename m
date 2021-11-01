Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3971C441EBD
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 17:42:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbhKAQoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 12:44:12 -0400
Received: from mail-cusazon11021017.outbound.protection.outlook.com ([52.101.62.17]:26430
        "EHLO na01-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231361AbhKAQoL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Nov 2021 12:44:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=inQ226WynPVQagIoI/GyIDQiIQBM05A1JloS6PpmyEqA46285r5vbsKmtr5ltDVbOpXtiNk6SJ9+AfXM7ysfMjr9nWbX9FMLA44Azov9PaAHPotEBivQ3pDjriAGCCA8UemX03/8pmbnRycjTGpQk+Yjq7usQJHi3c/feH910ca0L3IPDx7wlcdhBXUbGI5xycFDdpOP3wC2Q3eCg57SAgvbHBd0a2Z+AgT0X7r6su4HWyA5favgfDhXNwbFGrj45r17DEl27uOkPCK9bxK25pZyZxjUaD8VQSi5/+P+YbmIo71KkOMzDi2Pypj8iqHJHbykCYVSTRJr5sJgny5ERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ViRg+AuPreaDug9P84ezo/9gi0sLh004V8HSPeHCTwo=;
 b=hWj02S+3T2C3U/0I7AOl3Rfjd1ssI1W4SYDoM5cKeKqcz5bMlsHjkm9JT++HJocN9nCUwKNw9hFxdPSTlb0OaoWTeHYS0GD1tebCADYIy2UYmaWjX8s9ntFNjz1wZjseOhPLLyidzfL32cWmaKNG+OtgYR7a1T47P1SyETV/TUJ0d9LSGIGW+Bqxf4ZztZ5+YYQPTNXnevzM3PUVucz5+gnBP7M8rFQTAzcPpd1aH8t5M+Mq/T2AQTRk4aBNt+QmHE4eTUKjE4jMqUbTTgFZJPmoQi1dBYHssQmKCx+j63YQmISsvygYSQaolOGTIJcKsAaWvrGTMVpRnFGh9RO7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ViRg+AuPreaDug9P84ezo/9gi0sLh004V8HSPeHCTwo=;
 b=e/7skE6RoxDQ5oItImg8BAEAu9PS2CxXyCrwvtbdZvqvsJaskCn9gSOskFDXD0w6feYLcDOsG6jZHjRf/P3g8hbHyhF2oHZzw2WrvG+8zu/LQ3mEWtYzSQmleMR5vMODpTUHOX7+s61JcczVnIaFnhEbPV4Bk79VSIH5XEYXqx0=
Received: from BYAPR21MB1270.namprd21.prod.outlook.com (2603:10b6:a03:105::15)
 by BYAPR21MB1174.namprd21.prod.outlook.com (2603:10b6:a03:104::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.10; Mon, 1 Nov
 2021 16:41:33 +0000
Received: from BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1]) by BYAPR21MB1270.namprd21.prod.outlook.com
 ([fe80::9c8a:6cab:68a6:ceb1%6]) with mapi id 15.20.4690.002; Mon, 1 Nov 2021
 16:41:33 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Haiyang Zhang <haiyangz@microsoft.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "gustavoars@kernel.org" <gustavoars@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     KY Srinivasan <kys@microsoft.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "wei.liu@kernel.org" <wei.liu@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        Shachar Raindel <shacharr@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>
Subject: RE: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Topic: [PATCH net-next 4/4] net: mana: Support hibernation and kexec
Thread-Index: AQHXzSi5FL+xs47DTkemjnXcBfjf5qvrr5YAgAKLS0CAAJBXoIAAF54A
Date:   Mon, 1 Nov 2021 16:41:33 +0000
Message-ID: <BYAPR21MB127004E34EBA263FB4D0B1C2BF8A9@BYAPR21MB1270.namprd21.prod.outlook.com>
References: <20211030005408.13932-1-decui@microsoft.com>
 <20211030005408.13932-5-decui@microsoft.com>
 <BN8PR21MB1284785C320EFE09C75286B6CA889@BN8PR21MB1284.namprd21.prod.outlook.com>
 <BYAPR21MB1270A16AA0BF1A302BABCB3FBF8A9@BYAPR21MB1270.namprd21.prod.outlook.com>
 <BN8PR21MB128460B5BE376A9E05D43418CA8A9@BN8PR21MB1284.namprd21.prod.outlook.com>
In-Reply-To: <BN8PR21MB128460B5BE376A9E05D43418CA8A9@BN8PR21MB1284.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=38d1b54a-de51-47ac-a27e-8db573cfb9ed;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-10-30T15:43:58Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microsoft.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6c04ff64-ab08-4010-b348-08d99d5676a8
x-ms-traffictypediagnostic: BYAPR21MB1174:
x-ld-processed: 72f988bf-86f1-41af-91ab-2d7cd011db47,ExtAddr
x-microsoft-antispam-prvs: <BYAPR21MB11746110E318EE3167E91099BF8A9@BYAPR21MB1174.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1122;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oJ7s+O8NG+gY/rUh1n3xzR0gFOlemFfIPgYaTVFngvKM8TPGNL114LDyQAmFk4yOY6YyBMJEW/G5iXLeqf+pBqBBLBAo3V2tx6uozXCu4+wehh3IDuP4Zyx1WsF9gdaYq+es8EevtHSkqDro7f50zH3mv80ppyOG15FpOnAHl/0vKPxCRRYEI1SHIzWxJoUZ1Ve5qkbC9ZPrsNesNDVEyQ/scyh1hUayX7kC5I18Isr2+Qp8ODfu+01W8IMh12n512PlgB/uOaob3yiATKgzKtrqoB9zBZehKNRkS61oxyGh7poBpdG+WiPWYwKTZ8MhRWdGvXmCbCBcqVjcTQT+VGU+iXvlb8sZhI6l/fC8z5oGYo2i6ZmxASfu5/QhqF/O2ZAjiH6SnOPfwzhzZ2djZgmk8lamg8QI2hBAHsWtfnQYqTs5SoadHzdKOV4Ke14MrH0MTta54dXAbk3mSHVwZ0ztwmVutUwO4jY11VSdZ8qySKtYS97EPb87Y4WSHbkwqV8duSFdKjQJh52U3EQyHoUD5l1dUNB4+baJiJGgK5p+aZzhCow6yV3lJhtvBvK3r7aw1J8usSMPN1TSPwmnb0Ma1qwwj/URNWGKgBoC+m/h/Erve2zQF+ZBsKBZOR8XovgelZoIH24Gd2S8H0nXiuILkXHtzd4Gwkf+4KR8g3HvUng4hQgw799IW/VMX9JPCmwJ3KBbkFmGTFqE5zkgVA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR21MB1270.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(4326008)(508600001)(122000001)(5660300002)(71200400001)(82950400001)(10290500003)(26005)(558084003)(86362001)(7696005)(7416002)(8936002)(8676002)(8990500004)(316002)(9686003)(76116006)(54906003)(66556008)(52536014)(33656002)(66946007)(66476007)(186003)(2906002)(6506007)(38070700005)(64756008)(55016002)(38100700002)(66446008)(110136005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?xLuDQ/wrzGmREbYhuVTby6+yvU5HMobmkxgdXPJKiwPtYhE+i2ajWcOokhRs?=
 =?us-ascii?Q?sh+UjxYN2JBcLRMEHpAGFOQ8Bulo28G2ct6SQ/23ypLWliki8mYb/Sj6Fjen?=
 =?us-ascii?Q?TcP9HXUR+imf3vT79suxlyAHapM+i0fTgC5Uko8UQPP8VBIdVUf620ChH+RA?=
 =?us-ascii?Q?1Jc+TiNk6AmMXpRDDGwGNpv/vu6gYBkKbYcR2oecJAYcTAUzNKHEkTuZX2yK?=
 =?us-ascii?Q?Pazw4ol7oxE6xuDWXwb6+tOJPwy869ZZ8lhvGvih8ctVGLNrcZLM9j2TYt97?=
 =?us-ascii?Q?UXpuFQtNQO+ilWfb8xu03RW8arYQNEfmcvSB7zuiVtSNBG/YVrzES1C/ktAk?=
 =?us-ascii?Q?UA/+SwXumLAmbPUEG1KgrH33TISjUtHmvjAPq61TyhRsP+2Jf9hNciGN3sqo?=
 =?us-ascii?Q?zaf3BUj1Nh4YFiAn/v8CmCN8n1TzrD3utVh7hrUxe25l+U9/AcWZZImfF0qE?=
 =?us-ascii?Q?pDM5bUUGuH11ATgDlpMOiULRdc3+u1I0g8xILs23OAiZ+HGppA/befHz3ZIB?=
 =?us-ascii?Q?ox0GCDxWZr6eSDLbSXlYEUS39I0aqRfOLi5NofWW1TXaIwSXl4cGVLOvuWO0?=
 =?us-ascii?Q?279K2flU/JZPbtdMCO6a+fluds4PA5Lu+yYi5l2ktq2Aa1QFPgLiNpPc073w?=
 =?us-ascii?Q?wHKwl0eWFE5RB1FAkzyvID4ZZnNYoHkq9YOBrSbipqPxEZIFMTg1DYx7EuCY?=
 =?us-ascii?Q?a2h7pU2MOx/vIB7l+i8yJtiPsc36pNm0W0f3RWxdWYyTqAM1X0RVahWbDuRa?=
 =?us-ascii?Q?WmorRDXzBOpX4AJVRfPrAbQ+TETOB/croGMahofi1/z/h0IqAplczyZUa2K0?=
 =?us-ascii?Q?8oYTz39SSPXHyaF6eR1l86TTlAQdI6qHvDCpccrXeKgHJiyHZxpC+NRevdrY?=
 =?us-ascii?Q?YhyLza9keYJ76mEGPWQ5js695VnHxxKJzyDQzHjxurO7SX8wZiUjX/0SnPO4?=
 =?us-ascii?Q?9Pgs250WOkK2nenNnDXv+DAUZ8w+Yk5rK2b4klJhMGQDvj6jZdBABscjkTIm?=
 =?us-ascii?Q?XJ+IcCLClwgW+ylPtzyl7UjKbQXpTCdqQE7iVBlc3y8bWpL4sTw9Cn5AxqQ2?=
 =?us-ascii?Q?HgNY7kAJcqpoIegbK8y65G+MTf6MlHC5gFo+t8KbLGW1GPqbQyjDyV2QJxL/?=
 =?us-ascii?Q?wrw31LM0aq8K9Vpwjaqhqo8jFO9yikrh+ciMuwLimZqYrgWK8Vqx8HmSEiqu?=
 =?us-ascii?Q?bJUkKGOOlVY1shLeOtv+Sr274Cnf7oNMObNYTfmRggJmpDZlfcAQjwk64jaE?=
 =?us-ascii?Q?ynVQRV8Q/F1svLZGHnzFw+p4c8buf1nXpuVcxhHPQLi8iiei21E1H8UHrSOA?=
 =?us-ascii?Q?7o4hV/K+GgDLMpuJx8b0p+LkHhX+KleeXwPpJN01frybq4hs05k9yXV7lYL8?=
 =?us-ascii?Q?dkcIBZ+SPcFmfyEK7sCDZOHthz8t7efu1iC6TCJq52lj06C5lCRJg6CAj72I?=
 =?us-ascii?Q?1yjH3R2o3hj1YzgWIMhvfl2EYYB+47nlmRvsCnXtbVVRsoi2uA2s0HRmzJwX?=
 =?us-ascii?Q?2qKXXz1sSf/GwfsyaV9w/U+cAjDvYu3ng0y3JDr++iIPQHW8SH51ciEmqm7o?=
 =?us-ascii?Q?l4Drv+kYet27q9pch/LQj35G2ycxcJJeJC3YfVGildVVWHdxQnTbHTQAX6nS?=
 =?us-ascii?Q?ecnRd5dhqAEvWXN0dy+e2mE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR21MB1270.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6c04ff64-ab08-4010-b348-08d99d5676a8
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2021 16:41:33.1822
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: D5gYIo6Vt3j+naB6sLxy9nJYCCKdhKRjzGqKBfpm/tp++dXWwC0VjW0lQarmROAk/E4uCs0F1LPUXNJEuEBl/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR21MB1174
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Haiyang Zhang <haiyangz@microsoft.com>
> Sent: Monday, November 1, 2021 8:12 AM
>  ...
> The new code looks good!
>=20
> Thanks,
> - Haiyang

The v1 patchset has been merged into net-next.git by=20
patchwork-bot+netdevbpf@kernel.org ...=20

I'll post an incremental patchset.

Thanks,
Dexuan
