Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 544F32FA7A0
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 18:36:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436559AbhARRev (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 12:34:51 -0500
Received: from mail.eaton.com ([192.104.67.6]:10400 "EHLO mail.eaton.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407100AbhARRdu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 Jan 2021 12:33:50 -0500
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A9C42A4152;
        Mon, 18 Jan 2021 12:32:38 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=eaton.com;
        s=eaton-s2020-01; t=1610991158;
        bh=Xqmd9czfTIlTmFg2uMOszl5N72G+YX8ZRJL5tMXVM3Y=; h=From:To:Date;
        b=C5N/itnmRTv5HAA29fC5CqndYFIlf3Y38hth+Tem66aAl6Wtc2d4brzmoUQZAq/BG
         oRrIgO6RT03qKVxAHBpdP9tXx7O2JhPeqLgBgXViu8jbNgnJSVoRKEAmSksOH7E7eH
         zRVh1/fOpzv1+7FGuWuHWp8gGbClDe4luorXDPisMRH1BH+I/CHtALAkvdqEpP9kxP
         ZDAvzOYhtfufrUhhGTreQpL/s/4JG5zodSC4VeuLH+G/+YIDq2RLkXwITYCZf8WX1Q
         a9gwnTJLAMGvfzHvKqnaGyFeZXpKEua9CI8ljH2Kcuo/2F4JzAUzDrdsI3wFiNtmep
         X3KDWKUq/ke7Q==
Received: from mail.eaton.com (simtcimsva03.etn.com [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id A31A4A416F;
        Mon, 18 Jan 2021 12:32:38 -0500 (EST)
Received: from SIMTCSGWY04.napa.ad.etn.com (simtcsgwy04.napa.ad.etn.com [151.110.126.121])
        by mail.eaton.com (Postfix) with ESMTPS;
        Mon, 18 Jan 2021 12:32:38 -0500 (EST)
Received: from LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) by
 SIMTCSGWY04.napa.ad.etn.com (151.110.126.121) with Microsoft SMTP Server
 (TLS) id 14.3.487.0; Mon, 18 Jan 2021 12:32:36 -0500
Received: from USSTCSEXHET01.NAPA.AD.ETN.COM (151.110.240.153) by
 LOUTCSHUB05.napa.ad.etn.com (151.110.40.78) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Mon, 18 Jan 2021 12:32:35 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by hybridmail.eaton.com (151.110.240.153) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1591.10; Mon, 18 Jan 2021 12:32:18 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HRqKm3sl3mNFGIXDJJxg3as2zX2lZkQ5JKQ79lZpUjtQubQtNoZI2A8YfGb9st2CQwWi83NXNUWpQAw3Ul+59atSzkhURkRUdPSuxMZYIm3iuwNdlZTPtuJF3rsrziS4Zob1Oe8yH5wllqFArjC1r9u2D3CYj6J2AXwtXABi7xbL2C0V2CZR1/FpFZSKgsPLEs+htRavoP15W2H4AwYJWw0Y72+9lGpserdf8/DPl+y8/3nXi6spseOaWbYLfTlIz7lJ816lkZm2wi6wk9EepOtcZhlOfLDURmBkRoJCCFFlwsu9RR4SX+YvuhKex+z3p4Z2V5oASqNCjnPIH7NCkQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20AhLWOEkMnV0DEPK7W+mU22Zn9dgKJoAHl+LPDhjMI=;
 b=N2FCg9GZnk5wY3+Su+bcv09s0opAx+CYPS5FiQCXF/eyOdN5R7saD3nm6Ri5dCiBwlaHq582VNguhLARVyelhr58FDfoqrBpfnWkx+M1A/yRfKKtbHS0K3n1IrOU32qfbLOpzQfNLFJxHiPReFKhlDu3go0RH9L8AUIyHalFMQjhhAwi6XmNdsJKm9kVnw4ovSnuJrQZdM+oA0AS9mpbHxCUKIrXQayODnAWcsYvaHHv83R+rsviXqaLOwjx7FWgwB4kgolHLWSG6/VeUdZc/ufY7nVgJJu9ClV0E7FhEHz6SHILjCmCHksZiExHVm92ZFm3uMIbY4MofEqOZJoWKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=eaton.com; dmarc=pass action=none header.from=eaton.com;
 dkim=pass header.d=eaton.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Eaton.onmicrosoft.com;
 s=selector1-Eaton-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=20AhLWOEkMnV0DEPK7W+mU22Zn9dgKJoAHl+LPDhjMI=;
 b=FCF66uiYuBO5pueV8HcUdMmGwRgfzCPqJfXT97TEEyeLGZZMdWnfZfVP/hMIEOmvZIQxWq71OrrdafKFLPaXHTjoFVyQa5emnmWdZxZF7ENnMUV4jpIcXPvwVQ9c3oRADUXqDwmQjFVH2VNsmzsp6KSLLiAwWOs8FdATdfF0frI=
Received: from MW4PR17MB4243.namprd17.prod.outlook.com (2603:10b6:303:71::6)
 by MW4PR17MB4290.namprd17.prod.outlook.com (2603:10b6:303:73::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Mon, 18 Jan
 2021 17:32:34 +0000
Received: from MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30]) by MW4PR17MB4243.namprd17.prod.outlook.com
 ([fe80::950b:b237:60e4:d30%7]) with mapi id 15.20.3763.014; Mon, 18 Jan 2021
 17:32:34 +0000
From:   "Badel, Laurent" <LaurentBadel@eaton.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "m.felsch@pengutronix.de" <m.felsch@pengutronix.de>,
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
        "marex@denx.de" <marex@denx.de>
Subject: RE: [EXTERNAL]  Re: [PATCH v4 net-next 1/5] net: phy: Add
 PHY_RST_AFTER_PROBE flag
Thread-Topic: [EXTERNAL]  Re: [PATCH v4 net-next 1/5] net: phy: Add
 PHY_RST_AFTER_PROBE flag
Thread-Index: AdbtuyJ8H2lqftHoQdi+B2oA/e66agAAJ9MAAAD8QsA=
Date:   Mon, 18 Jan 2021 17:32:34 +0000
Message-ID: <MW4PR17MB4243814D9651CEF803B5BB0DDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
References: <MW4PR17MB4243C51A3D1616487F201B2EDFA40@MW4PR17MB4243.namprd17.prod.outlook.com>
 <35b89925-1fe9-0161-f007-8085942bc35b@gmail.com>
In-Reply-To: <35b89925-1fe9-0161-f007-8085942bc35b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=eaton.com;
x-originating-ip: [89.217.230.232]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4f52bd78-ce89-4e89-a5ce-08d8bbd70a8c
x-ms-traffictypediagnostic: MW4PR17MB4290:
x-microsoft-antispam-prvs: <MW4PR17MB42905AF3381649538E3D536ADFA40@MW4PR17MB4290.namprd17.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:418;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rsckpog2uhjLvF6qS4W4bCSiX0BzOvM2lzzQDcr4UFQwuusNclyHOIWpczGWE94ocKzTULMD4ObjhLcPVE5hiWyCXgy6bGgXItlonLo9I3K35IYC058cvC4Lx6TKUCGWgNYbphlrHHT/pZoNjqJqFHPP/tLa2mDdBj7p0jYljUeFSc+/tk2gbrSy0q1PcWHxHdQaOzC2Z+sK9GA6Jhqf+VPduTkixkqvsz2+xbqQEMegWDPe4k/jrG+kbCwz1s9x3/NHU34rvZaJ6Y6pygq1fVx0Fx2GwnsVgm8gTV+bPHMq1o6CUtLkIo103LYHS+l9q2vx0mbWM/b8Lhc0wCkq4rttPTavH6VBeqUxea0q5FbQM81DdV15092VotyGn3G98DZTGqd0aepPpoR3c2o9CQKrZGCMDyIZdLwnkXz8zJwzTWyRJXJt3Rulvwk0UwFE20sdIyZzMUJyDasS6dGuMIhMI8JJ/ACsgJXNYstI2e/n2Z2b2HxEbhXrUMcTPbONdohW4ycDHWAfDPnNZDQrsBu9WAXLwbWOVJQvbEQBTYSPq57u3RqWi0ynzlbpgUXO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR17MB4243.namprd17.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(136003)(39860400002)(396003)(52536014)(7696005)(8936002)(8676002)(64756008)(33656002)(71200400001)(86362001)(6506007)(83380400001)(9686003)(53546011)(5660300002)(478600001)(66446008)(186003)(7416002)(66946007)(66556008)(66476007)(921005)(55016002)(2906002)(110136005)(316002)(26005)(76116006);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dE9oVDJKdEEwNEJkREhQTGNvM0pTVEhaM3JYaEtqcHFpM3BwR085THFjaFRh?=
 =?utf-8?B?VEw2a2hXY1QyVWlySkxyOEZRRlg1Z3lPQTdLZFA0REJUcGsvOUlFKzQ5cjlW?=
 =?utf-8?B?Y0t0VWJ5SjREMXlxYmhUcmJLVnM3Z3hFWTZYb3RqNkFpUXY5aWt1MHNSOWxF?=
 =?utf-8?B?ZGtCOWJhQTZURHVHcW9uaDJaYnE3UlBZeUZ5RlZoM0ZoUmd1VXM0U25Xdlc2?=
 =?utf-8?B?bTY1aW94VWVnRzRCaCthS2xiSlkrZkpxblIvTW9mVnBzZC9xN2FZQW5kWUlH?=
 =?utf-8?B?TUQwakRGMDFXajBkcUtnWjBJaG9OV2ZuTkZnMGc5dW9NeDZPckcyczg3RXdF?=
 =?utf-8?B?NXVVSWtXNXNCYS8xMmVqeHU2N2tkQ0FZcjUvbEVydGdRT2dWT0dUalZNUDJI?=
 =?utf-8?B?L21iNklUVE1VU3VpS0t5bTlqMGF2VGRBQXl3b0dZQ1lXaDFwYVJYbi92ZlZK?=
 =?utf-8?B?VzdvaWxsVGoxc0xBeGdTNXE2M0FLcXpoZDF1d1FCTWhsREltZ1ZNQm9FM0ZS?=
 =?utf-8?B?dWJYT3hwWGFteG5GblpMdjhjOVFoamJCTS9VUVVvc0JSeUtRc0kzTXJqbklw?=
 =?utf-8?B?TVAweCtTL2JBWHJOWnBPQkRUR1c3OWoxRkI3UDlzc2tzd3QrZ2ZSNE5uTEVM?=
 =?utf-8?B?QXQ3cWowVkg3NlZ6Z3RGUzlZZzIwbmhQUHVsT0RjRWhtU1hpVTJwaWF0aG43?=
 =?utf-8?B?cm85VnNic1I2QktpcXkzbXprcE5QcExwdVdDSFM2ZGdKemE2TEQzNDg0eDBF?=
 =?utf-8?B?N2FaVEJyZnJBZUZmKzVpWDJHWXBvSmFrTHFPUkMzUmN6WHZYY0RnTUUwM2M4?=
 =?utf-8?B?U29mZGFUTFg2OTBaSlZXOHVYV1IzSXM0T05SVFJMQUNLS2s1eHY0Rjd6STFZ?=
 =?utf-8?B?NUxlbGlZRlJDRmxrRmJhYnVENzRXZUp3R1pycFRXRnJvODljVkZGWUNteDlr?=
 =?utf-8?B?bC9ONTJTd2FJNFZmUnNuQXcwSHZKcGlzTytkbjF5R1BmcnJWeVFxZ2VwUGNP?=
 =?utf-8?B?YjQ0bGJRaDMzbHhqRTM2S3ZpSXhSTDNtKzJLWkd2SXlVMTZ3YkRoNnMveVpK?=
 =?utf-8?B?MDFTS1lUR1VTaEFjL2hXRTBZdldGZHNUa2trc0tsWTFOWjdPa0hRL0ZpVFhH?=
 =?utf-8?B?TUhFV3VoTUJramZRanJ4VzU0aWtNTiswWmVjRDljdWFPOHFSY0pjMWZpbEQz?=
 =?utf-8?B?cDVud1phVkdtNGxBaXJDQlVtUG1BdWNjSFlTcVRRd010RjEvWTIxVEJhUmd0?=
 =?utf-8?B?Q1VNNkVBKzJ6Um43QjNWeEg0LzNndUNrZ0R4RnVaTXpkUnp0NXdoQXdxc1VJ?=
 =?utf-8?Q?stWNvjP/qQ2OU=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR17MB4243.namprd17.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4f52bd78-ce89-4e89-a5ce-08d8bbd70a8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jan 2021 17:32:34.0336
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d6525c95-b906-431a-b926-e9b51ba43cc4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: X4v11sjl08EELJetSeNnKtrN2bxGHn90dzQY3e2V2X87vHDiQHFBIOaqLNEmSarAEfsqGS99LvcDd9eZMVbCxA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR17MB4290
X-TM-SNTS-SMTP: 30314DBDCF4F324AA50F9B70D388B688665E2C5579AEE53722458A465147F5582002:8
X-OriginatorOrg: eaton.com
X-EXCLAIMER-MD-CONFIG: 96b59d02-bc1a-4a40-8c96-611cac62bce9
X-TM-AS-GCONF: 00
X-TM-AS-Product-Ver: IMSVA-9.1.0.1988-8.6.0.1013-25920.001
X-TM-AS-Result: No--11.486-7.0-31-10
X-imss-scan-details: No--11.486-7.0-31-10
X-TMASE-Version: IMSVA-9.1.0.1988-8.6.1013-25920.001
X-TMASE-Result: 10--11.486000-10.000000
X-TMASE-MatchedRID: bgM1eS1Zl68pwNTiG5IsEldOi7IJyXyIypNii+mQKrGqvcIF1TcLYAjJ
        M0WLRMJtsrWE1NucEUAfEGhpkJfE8rvUM1lvDMQ6iVJZi91I9JjLQx8PUawjWyS30GKAkBxWdgU
        kpXXx9rCh8Vy1BXa2gMN39+z7cvBz5i83OgDg/A2aVoAi2I40/ReK/B+WKxKsfkiy7TTogYYTJ7
        4q/iXJivsHYBqJcHFFzHR5txO5BcAh4UgUH4JX7APZZctd3P4B2LlbtF/6zpCL0zi0dfYTDNlQt
        UFiiij6GzTNVTitbor8nUTy5iFBDBb6ePjTO5D5ngIgpj8eDcCrGKyaRMBTR38DvkUabErVKrau
        Xd3MZDUMFsa+1wyh/BOxOH1isUvdmA4ocoFI/P9r0st4DzkRwl/VHAtC+wjrmW14Sy7p0tA=
X-TMASE-SNAP-Result: 1.821001.0001-0-1-12:0,22:0,33:0,34:0-0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

77u/DQoNCj4gDQoNCi0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQpFYXRvbiBJbmR1c3Ry
aWVzIE1hbnVmYWN0dXJpbmcgR21iSCB+IFJlZ2lzdGVyZWQgcGxhY2Ugb2YgYnVzaW5lc3M6IFJv
dXRlIGRlIGxhIExvbmdlcmFpZSA3LCAxMTEwLCBNb3JnZXMsIFN3aXR6ZXJsYW5kIA0KDQotLS0t
LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQ0KDQotLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0K
PiBGcm9tOiBGbG9yaWFuIEZhaW5lbGxpIDxmLmZhaW5lbGxpQGdtYWlsLmNvbT4NCj4gU2VudDog
TW9uZGF5LCBKYW51YXJ5IDE4LCAyMDIxIDY6MDMgUE0NCj4gVG86IEJhZGVsLCBMYXVyZW50IDxM
YXVyZW50QmFkZWxAZWF0b24uY29tPjsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsNCj4gbS5mZWxzY2hA
cGVuZ3V0cm9uaXguZGU7IGZ1Z2FuZy5kdWFuQG54cC5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4g
YW5kcmV3QGx1bm4uY2g7IGxpbnV4QGFybWxpbnV4Lm9yZy51azsgcC56YWJlbEBwZW5ndXRyb25p
eC5kZTsNCj4gbGdpcmR3b29kQGdtYWlsLmNvbTsgYnJvb25pZUBrZXJuZWwub3JnOyByb2JoK2R0
QGtlcm5lbC5vcmc7DQo+IHJpY2hhcmQubGVpdG5lckBza2lkYXRhLmNvbTsgbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsNCj4gZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IG1hcmV4QGRlbnguZGUN
Cj4gU3ViamVjdDogW0VYVEVSTkFMXSBSZTogW1BBVENIIHY0IG5ldC1uZXh0IDEvNV0gbmV0OiBw
aHk6IEFkZA0KPiBQSFlfUlNUX0FGVEVSX1BST0JFIGZsYWcNCj4gDQo+IA0KPiANCj4gT24gMS8x
OC8yMDIxIDg6NTggQU0sIEJhZGVsLCBMYXVyZW50IHdyb3RlOg0KPiA+IO+7v0FkZCBuZXcgZmxh
ZyBQSFlfUlNUX0FGVEVSX1BST0JFIGZvciBMQU44NzEwLzIwLzQwLiBUaGlzIGZsYWcgaXMNCj4g
PiBpbnRlbmRlZCBmb3IgcGh5X3Byb2JlKCkgdG8gYXNzZXJ0IGhhcmR3YXJlIHJlc2V0IGFmdGVy
IHByb2JpbmcgdGhlDQo+IFBIWS4NCj4gPg0KPiA+IFNpZ25lZC1vZmYtYnk6IExhdXJlbnQgQmFk
ZWwgPGxhdXJlbnRiYWRlbEBlYXRvbi5jb20+DQo+ID4gLS0tDQo+ID4gIGRyaXZlcnMvbmV0L3Bo
eS9zbXNjLmMgfCA0ICsrLS0NCj4gPiAgaW5jbHVkZS9saW51eC9waHkuaCAgICB8IDEgKw0KPiA+
ICAyIGZpbGVzIGNoYW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMiBkZWxldGlvbnMoLSkNCj4gPg0K
PiA+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9waHkvc21zYy5jIGIvZHJpdmVycy9uZXQvcGh5
L3Ntc2MuYyBpbmRleA0KPiA+IGRkYjc4ZmI0ZDZkYy4uNWVlNDVjNDhlZmJiIDEwMDY0NA0KPiA+
IC0tLSBhL2RyaXZlcnMvbmV0L3BoeS9zbXNjLmMNCj4gPiArKysgYi9kcml2ZXJzL25ldC9waHkv
c21zYy5jDQo+ID4gQEAgLTQzMyw3ICs0MzMsNyBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIg
c21zY19waHlfZHJpdmVyW10gPSB7DQo+ID4gIAkubmFtZQkJPSAiU01TQyBMQU44NzEwL0xBTjg3
MjAiLA0KPiA+DQo+ID4gIAkvKiBQSFlfQkFTSUNfRkVBVFVSRVMgKi8NCj4gPiAtDQo+ID4gKwku
ZmxhZ3MJCT0gUEhZX1JTVF9BRlRFUl9QUk9CRSwNCj4gPiAgCS5wcm9iZQkJPSBzbXNjX3BoeV9w
cm9iZSwNCj4gPiAgCS5yZW1vdmUJCT0gc21zY19waHlfcmVtb3ZlLA0KPiA+DQo+ID4gQEAgLTQ2
MCw3ICs0NjAsNyBAQCBzdGF0aWMgc3RydWN0IHBoeV9kcml2ZXIgc21zY19waHlfZHJpdmVyW10g
PSB7DQo+ID4gIAkubmFtZQkJPSAiU01TQyBMQU44NzQwIiwNCj4gPg0KPiA+ICAJLyogUEhZX0JB
U0lDX0ZFQVRVUkVTICovDQo+ID4gLQkuZmxhZ3MJCT0gUEhZX1JTVF9BRlRFUl9DTEtfRU4sDQo+
ID4gKwkuZmxhZ3MJCT0gUEhZX1JTVF9BRlRFUl9DTEtfRU4gJiBQSFlfUlNUX0FGVEVSX1BST0JF
LA0KPiANCj4gDQo+IE5vdCBQSFlfUlNUX0FGVEVSX0NMS19FTiB8IFBIWV9SU1RfQUZURVJfUFJP
QkU/DQo+IC0tDQo+IEZsb3JpYW4NCg0KQWgsIHlvdSBhcmUgcmlnaHQsIG15IG1pc3Rha2UsIHNv
IG11Y2ggZm9yIGJpc2VjdGFiaWxpdHkuIEknbGwgZml4IGFuZCByZS1zZW5kLCBzb3JyeSBhZ2Fp
bi4gDQo=
