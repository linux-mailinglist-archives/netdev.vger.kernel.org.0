Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C2E63D524
	for <lists+netdev@lfdr.de>; Wed, 30 Nov 2022 13:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229644AbiK3MBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Nov 2022 07:01:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiK3MBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Nov 2022 07:01:01 -0500
Received: from EUR01-HE1-obe.outbound.protection.outlook.com (mail-he1eur01on2070.outbound.protection.outlook.com [40.107.13.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001AE6F83F;
        Wed, 30 Nov 2022 04:00:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b3vRxN777BrO8I0HcULJETG/Yy9zmOuVsRMjIdB+wLN2hDsiOFbTOTWYnCbm0bUwy79f3JJevMQ/3n51AqqNJfediI80JF/X3HvIARhkAK7K/pQnNSB2kJnFGW76kdZXbIgN5Ty9qrbMNaA2bLtuO0CWH0LEeMvHgRmmdpcTFLKgf60eHeyi4bPuFK6UErBN7X2mLokI0I0tesprs6nnWFhvbqawTGJqm0buTH8/8u378szeFjEAl71TKDIv5J3Zd5pFRRWDLyNS6GkTONQ+i2fc9MS0aOoPOGrUCA1vpo7U5O5B+SruIFQfKVk+wN26rTV03asiqykqtvAqBTMRHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VysAqWN5kdm4BefYMGhPLV3B5lcfVYKAKkV73vpfFrc=;
 b=DWYd1riMkjXGxrvkb5TBAF0GuXZMMxZnJAoOT8faHHC5WdgOp51w6OS0pW/MsE2jw8wwMueW/tgDr5KKVApAfZZdEhjX/RlBIMizxqVmTuoejhq5h7sE9T6ef1pjI5h9dVVCZ9w9CcaZv4uWe8FWoaWocJQYW10p27QmOB92jJ5XA+/XUERQEgOwAAlvp9Talbbzl8THXfYelRu7iioZ4yNj3aE3yH6kdGkKhdRB3+h1tF2WTFbHktg4bGFPHDpsT22qvSn1O23Mb6SZLWaQ3AVeBXvaVNbANdViLuI+ucZmLiNiASBa/sw8KgOja3arqFDbv5b8iLTINUMF/VHjAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VysAqWN5kdm4BefYMGhPLV3B5lcfVYKAKkV73vpfFrc=;
 b=OJAz8jTuwf7rztZ3sxIGIQpAUKDxqn3spT3pJ62WrLQMLmskj+PqZVKJQptfxOqujs+e7w42J7E72wBjn53utq+5m7yxSBgYZ4KCt4XGNZw7TeOJ79hnjWTBaTWU+HXVduLXDJZJ3pfWMCt8Yv7CMmIluW1UnVJf1kvS8O91KAY=
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com (2603:10a6:3:db::18)
 by DB9PR04MB9554.eurprd04.prod.outlook.com (2603:10a6:10:302::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5857.23; Wed, 30 Nov
 2022 12:00:56 +0000
Received: from HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d]) by HE1PR0402MB2939.eurprd04.prod.outlook.com
 ([fe80::7682:a2e6:b891:2f4d%10]) with mapi id 15.20.5857.023; Wed, 30 Nov
 2022 12:00:55 +0000
From:   Clark Wang <xiaoning.wang@nxp.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@foss.st.com" <alexandre.torgue@foss.st.com>,
        "joabreu@synopsys.com" <joabreu@synopsys.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "mcoquelin.stm32@gmail.com" <mcoquelin.stm32@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Thread-Topic: [PATCH 1/2] net: phylink: add sync flag mac_ready to fix resume
 issue with WoL enabled
Thread-Index: AQHZBKyo4U8XamUbok2HUhpB4yX+kq5XUw0AgAAALtCAAAdnAIAAAThg
Date:   Wed, 30 Nov 2022 12:00:55 +0000
Message-ID: <HE1PR0402MB2939235E54E5ED7D9FC3A904F3159@HE1PR0402MB2939.eurprd04.prod.outlook.com>
References: <20221130111148.1064475-1-xiaoning.wang@nxp.com>
 <20221130111148.1064475-2-xiaoning.wang@nxp.com>
 <Y4c9PlfEC17pVE08@shell.armlinux.org.uk>
 <HE1PR0402MB2939242DB6E909B4A62109E5F3159@HE1PR0402MB2939.eurprd04.prod.outlook.com>
 <Y4dDmvOQwuIYxgro@shell.armlinux.org.uk>
In-Reply-To: <Y4dDmvOQwuIYxgro@shell.armlinux.org.uk>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: HE1PR0402MB2939:EE_|DB9PR04MB9554:EE_
x-ms-office365-filtering-correlation-id: 181e3b40-4bc0-4a71-7299-08dad2ca8927
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6o04H1wpDd6BSK0BIjjzx5VufO9Aw90pfLq7HXgM3tb5qpeDhr3h0iVheApnWNjbA7d6O1Dj0M7h5GO2xZm6sJ9dPhVhHfALC7aes+Z4oP7aOxCC2POhJcWIku3mEXMsvnjxpmZYeulvCve7751SVpQIwKmnp4AdV4KlReOTtFNYU1J2Rb8+iZ1a/YP109jKX2/gVVEK4xkmDM4bd6sLJpxwPRl6JJ+txJNLLa/j+5dC1mwir1bpJx4F6RK3V5+sVUKweRRk7YGhZxAw+fin6EvyMI0j2Cn/hphQSdAA4ErtS9I0CjAPU9PhtBrSzWrPVIl6MFoUeZaCSB+ql4RL7UusPjbvtadj+MB9p7144JUEKrRKZN5EAU/ECIoLcYLL+3Y3j2018g7RB7XJ0bEf6jGf6GGXIzrxxeg2eihjmNeQCrnQ8mx8PfAskxvq+KWGIbdnXaaW+fk8FF8a6uE02a9TLz6XvLOjvnvrdof2Fvzrv4hPQHyU1x6OiSh3eJS+YAEy5RyWBLH1/6JfGFRkzWyt2zWGzWrjR+HeWLNP2xqlbC2/ks4SQ+GbX87zzp9dJqFhFy2wYtRYhRCa+8JTwCQx///1tIs6C65hkfvo2MBcOTRxiXIMT+//mhcYJXpNaz4oyLN52Xlmf3MqwF6t0AWmToQuGof4nsLGUoGjc8f/wjGfAssDF5Q88rjAHBVUehgCfdPYL3rSJWwwGxGCA/TWLDTh+nL97SRLixaPKKs=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR0402MB2939.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(396003)(136003)(346002)(376002)(39860400002)(366004)(451199015)(53546011)(9686003)(122000001)(71200400001)(45080400002)(478600001)(6506007)(966005)(7696005)(41300700001)(26005)(66946007)(66556008)(66476007)(33656002)(66446008)(8676002)(64756008)(76116006)(86362001)(4326008)(316002)(55016003)(52536014)(6916009)(54906003)(38070700005)(7416002)(5660300002)(8936002)(186003)(38100700002)(83380400001)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?ZGVZYnN3ZkZMRGxIRnlCYklhM28xSTA4U0d6TXJLMjNHdHdhMitiMU5yWjJq?=
 =?gb2312?B?RDZNSUpLZ0dlMzVQb3JKc3hMWkRBdW9xSFBqdWllQlpFU25hUkpuZkN6QjRB?=
 =?gb2312?B?TG51Wm5EY0Q2K3FOUFArQ3Exb0tCZEp6NFdmM1lVSktoSjZNN3NhWnNnVWR6?=
 =?gb2312?B?cEFpSDBDM08xTUx5czZEaHRHZm04Rkg3TDFFVlpUWDFScHZ1a05nOVhZOUor?=
 =?gb2312?B?a3h3RHZ4dVpaaWNoVWxCd2pWeEVZS0pGWmRlVUx1NVJheWRNaUZabVhGMHlE?=
 =?gb2312?B?akFEZTBWR3dJdlBsWVdUTzhvLzFaL2hTVzBDWGpOK3BleStQV1YveHFtRWM5?=
 =?gb2312?B?L0dHejBsMWtldklldWd0WUtuRDdYaWNESUVLRmRScUxaUW9JQnNLL3Q3YnlE?=
 =?gb2312?B?b3o0czBRcjdraTd0WHV1bUNCWWFMWDdNZGg2ZTBUQW9ob0lkaC96WkkrTng0?=
 =?gb2312?B?MWdodE4vdUhTbHBIMWJMc20xZVlqcmRRVis3NUdJYWswQ2ZzZm8wMk1GVGdH?=
 =?gb2312?B?U2pVSXJibFhPcDJYN0tKVisySzJFSUVQemkzU3ZDZ0lML0N0NFY4dXNXQlhW?=
 =?gb2312?B?ZGMzcFVBSkJUZWZaWkdKUGhRMGVZVCsxN2FaSVIyQTNaWVlTdGYrZ2VKY0d5?=
 =?gb2312?B?VGNkT0VkRUxERHgxNUNQSG0yRlB4YzZqbE1xcFRCR1JKZ3B0emNLck4vRGJJ?=
 =?gb2312?B?VUJsUHFSaXp3YlUvcnBhMXcwa21WZmZKclBQWU13bnEwbjNkRGRLWHpQdWZ4?=
 =?gb2312?B?V3lkVmNTc2xZaEVtc1h1UXhGMU1PeXlJOTRvRW12U25CbXVHTGJyUmVkUFJX?=
 =?gb2312?B?VzE1OUM2TXVxU3NRY0k3QnNWa0ZDdjNRMEowZFJkT2ZWUDZmZ1FXT1Z2YjdH?=
 =?gb2312?B?L3NjL2NDY2RWT1czL0VsUlVZWUxSYm1TbWpZaGgvT3RVc096UGNCUThndmpi?=
 =?gb2312?B?b3BwQVpvVkNKZXBBZFR5NXFOcTdOUnFQR2FremdmUm5WdFRBVlA3VTVEZ1dX?=
 =?gb2312?B?c3MwdFlHQ3ZhZHNrQmFDR2h6NG5qdlcxUU1STTREcEllRHBXaXdaYUlmbEE2?=
 =?gb2312?B?RmE4SG1ENDNvalYxSkdHT3RBN0kzQUJteEJLcHdJUzlYdVhyKzA5RlVhcHUr?=
 =?gb2312?B?VFl4OExXdVh3MGRKd0pKcFFVR2NHdTJCT1QzSjFGUDRlZzI3Ulp6R0d6K2pM?=
 =?gb2312?B?OExDUE5qZlAveDh5ZVFWYjY2YTQzYlVCa2x5RFhsamtLZjlLYXh5SnlKK2dL?=
 =?gb2312?B?dmVZYStOSm81RU13dTNTZVQvVmxyUzlPcUQ2eGpHcEFFYzlVMG51TmhLNTht?=
 =?gb2312?B?R1ZwY3hMZk9CYmxCMitGdGV6R1VWeEVNNE9aUEJrN2lNbXplcmFRdndKMUU3?=
 =?gb2312?B?Rk5DdE94WUkzOEhJcGZiZ0hWRmFJdmVCbDhwRy9wajBwSWd4SnBJY1JsTnNH?=
 =?gb2312?B?YVhZck1qMmY2SEdIRFNvQVRZUHcxSVlHamlTU2dIK2RoOStmcGNQKzNGeHAy?=
 =?gb2312?B?VDAvL0NhaDJLUVI0bStPdjhqSFBKaE04aVRKWExQbkI2ck4wRnczRjJkQkpV?=
 =?gb2312?B?SlJER1RsZlNiWmF1U1RaTlRxQmQ0RmplYlpXeUlDYnRoMFJUNFZqQzd2RWhW?=
 =?gb2312?B?Z1U4ZHl0NE83Um1ZZ283NlE3K2NGNGJNc1JyczJCVVJna09leUpPQVppRXhE?=
 =?gb2312?B?T3ZjYjV0UHpDdG5hNDYwVnRid1B0L1Qyck1Jc3VVRHViRGkyN2JIU0I2aVlP?=
 =?gb2312?B?RFVDUHkvcXovZXJpa0cvYWR0MDZoQ2dybHpVU3hLVHBscXpOdFRoSTdQVStX?=
 =?gb2312?B?QVR5ZnRPM0VNMmM5aHZoeGQ2dGh6cHBjMEFERFoyazJUZkVkTkI4a3lZbXc5?=
 =?gb2312?B?QXNac292OWRBZHpxOWx2eEtybVhOL2krS09lbGlva3VsVWZtbFdBTTdudStQ?=
 =?gb2312?B?MVFwandSRUNKdFlrZVE3SEJveVV6K0s4cEd4S2gzTUxGWDVPcXNwQ01NWi92?=
 =?gb2312?B?RFlEU2ZqMHhRWkdCSUI0d0VZSE5Pd3kzeFAzY2lwMkJFeFg2ZG43dytMYjRu?=
 =?gb2312?B?MUZ4TGZmbUhMN05nNW00N0piT2VsRWcvZDV5ZG0rd0pKMjM4MkJsWUxBSkd3?=
 =?gb2312?Q?mYb0kCeBOwejYYVWWh26hNhVl?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR0402MB2939.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 181e3b40-4bc0-4a71-7299-08dad2ca8927
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Nov 2022 12:00:55.2480
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FVHUy/+kIeqOFFzJouXZSB1LA/LgtLTNVZZjfogNTugsULQw7sf5vipH9tTHpj4RFSb64l5MBOPJdDq8/pN8aA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR04MB9554
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IFJ1c3NlbGwgS2luZyA8bGlu
dXhAYXJtbGludXgub3JnLnVrPg0KPiBTZW50OiAyMDIyxOoxMdTCMzDI1SAxOTo1MQ0KPiBUbzog
Q2xhcmsgV2FuZyA8eGlhb25pbmcud2FuZ0BueHAuY29tPg0KPiBDYzogcGVwcGUuY2F2YWxsYXJv
QHN0LmNvbTsgYWxleGFuZHJlLnRvcmd1ZUBmb3NzLnN0LmNvbTsNCj4gam9hYnJldUBzeW5vcHN5
cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207DQo+IGt1YmFA
a2VybmVsLm9yZzsgcGFiZW5pQHJlZGhhdC5jb207IG1jb3F1ZWxpbi5zdG0zMkBnbWFpbC5jb207
DQo+IGFuZHJld0BsdW5uLmNoOyBoa2FsbHdlaXQxQGdtYWlsLmNvbTsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsNCj4gbGludXgtc3RtMzJAc3QtbWQtbWFpbG1hbi5zdG9ybXJlcGx5LmNvbTsNCj4g
bGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5r
ZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggMS8yXSBuZXQ6IHBoeWxpbms6IGFkZCBz
eW5jIGZsYWcgbWFjX3JlYWR5IHRvIGZpeCByZXN1bWUNCj4gaXNzdWUgd2l0aCBXb0wgZW5hYmxl
ZA0KPiANCj4gT24gV2VkLCBOb3YgMzAsIDIwMjIgYXQgMTE6MzI6MDlBTSArMDAwMCwgQ2xhcmsg
V2FuZyB3cm90ZToNCj4gPiBIaSBSdXNzZWxsLA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1l
c3NhZ2UtLS0tLQ0KPiA+ID4gRnJvbTogUnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcu
dWs+DQo+ID4gPiBTZW50OiAyMDIyxOoxMdTCMzDI1SAxOToyNA0KPiA+ID4gVG86IENsYXJrIFdh
bmcgPHhpYW9uaW5nLndhbmdAbnhwLmNvbT4NCj4gPiA+IENjOiBwZXBwZS5jYXZhbGxhcm9Ac3Qu
Y29tOyBhbGV4YW5kcmUudG9yZ3VlQGZvc3Muc3QuY29tOw0KPiA+ID4gam9hYnJldUBzeW5vcHN5
cy5jb207IGRhdmVtQGRhdmVtbG9mdC5uZXQ7DQo+IGVkdW1hemV0QGdvb2dsZS5jb207DQo+ID4g
PiBrdWJhQGtlcm5lbC5vcmc7IHBhYmVuaUByZWRoYXQuY29tOyBtY29xdWVsaW4uc3RtMzJAZ21h
aWwuY29tOw0KPiA+ID4gYW5kcmV3QGx1bm4uY2g7IGhrYWxsd2VpdDFAZ21haWwuY29tOyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+ID4gbGludXgtc3RtMzJAc3QtbWQtbWFpbG1hbi5zdG9y
bXJlcGx5LmNvbTsNCj4gPiA+IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsg
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCAx
LzJdIG5ldDogcGh5bGluazogYWRkIHN5bmMgZmxhZyBtYWNfcmVhZHkgdG8gZml4DQo+IHJlc3Vt
ZQ0KPiA+ID4gaXNzdWUgd2l0aCBXb0wgZW5hYmxlZA0KPiA+ID4NCj4gPiA+IE9uIFdlZCwgTm92
IDMwLCAyMDIyIGF0IDA3OjExOjQ3UE0gKzA4MDAsIENsYXJrIFdhbmcgd3JvdGU6DQo+ID4gPiA+
IElzc3VlIHdlIG1ldDoNCj4gPiA+ID4gT24gc29tZSBwbGF0Zm9ybXMsIG1hYyBjYW5ub3Qgd29y
ayBhZnRlciByZXN1bWVkIGZyb20gdGhlIHN1c3BlbmQNCj4gd2l0aA0KPiA+ID4gPiBXb0wgZW5h
YmxlZC4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIGNhdXNlIG9mIHRoZSBpc3N1ZToNCj4gPiA+ID4g
MS4gcGh5bGlua19yZXNvbHZlKCkgaXMgaW4gYSB3b3JrcXVldWUgd2hpY2ggd2lsbCBub3QgYmUg
ZXhlY3V0ZWQNCj4gaW1tZWRpYXRlbHkuDQo+ID4gPiA+ICAgIFRoaXMgaXMgdGhlIGNhbGwgc2Vx
dWVuY2U6DQo+ID4gPiA+DQo+IHBoeWxpbmtfcmVzb2x2ZSgpLT5waHlsaW5rX2xpbmtfdXAoKS0+
cGwtPm1hY19vcHMtPm1hY19saW5rX3VwKCkNCj4gPiA+ID4gICAgRm9yIHN0bW1hYyBkcml2ZXIs
IG1hY19saW5rX3VwKCkgd2lsbCBzZXQgdGhlIGNvcnJlY3QNCj4gc3BlZWQvZHVwbGV4Li4uDQo+
ID4gPiA+ICAgIHZhbHVlcyB3aGljaCBhcmUgZnJvbSBsaW5rX3N0YXRlLg0KPiA+ID4gPiAyLiBJ
biBzdG1tYWNfcmVzdW1lKCksIGl0IHdpbGwgY2FsbCBzdG1tYWNfaHdfc2V0dXAoKSBhZnRlciBj
YWxsZWQgdGhlDQo+ID4gPiA+ICAgIHBoeWxpbmtfcmVzdW1lKCkuIHN0bW1hY19jb3JlX2luaXQo
KSBpcyBjYWxsZWQgaW4gZnVuY3Rpb24NCj4gPiA+ID4gc3RtbWFjX2h3X3NldHVwKCksDQo+ID4g
Pg0KPiA+ID4gLi4uIGFuZCB0aGF0IGlzIHdoZXJlIHRoZSBwcm9ibGVtIGlzLiBEb24ndCBjYWxs
IHBoeWxpbmtfcmVzdW1lKCkgYmVmb3JlDQo+IHlvdXINCj4gPiA+IGhhcmR3YXJlIGlzIHJlYWR5
IHRvIHNlZSBhIGxpbmstdXAgZXZlbnQuDQo+ID4NCj4gPiBUaGFuayB5b3UgdmVyeSBtdWNoIGZv
ciB5b3VyIHJlcGx5IQ0KPiA+DQo+ID4gWW91IGFyZSByaWdodC4NCj4gPg0KPiA+IEhvd2V2ZXIs
IHN0bW1hYyByZXF1aXJlcyBSWEMgdG8gaGF2ZSBhIGNsb2NrIGlucHV0IHdoZW4gcGVyZm9ybWlu
ZyBhDQo+IHJlc2V0KGluIHN0bW1hY19od19zZXR1cCgpKS4gT24gb3VyIGJvYXJkLCBSWEMgaXMg
cHJvdmlkZWQgYnkgdGhlIHBoeS4NCj4gPg0KPiA+IEluIFdvTCBtb2RlLCB0aGlzIGlzIG5vdCBh
IHByb2JsZW0sIGJlY2F1c2UgdGhlIHBoeSB3aWxsIG5vdCBiZSBkb3duDQo+IHdoZW4gc3VzcGVu
ZC4gUlhDIHdpbGwga2VlcCBvdXRwdXQuIEJ1dCBpbiBub3JtYWwgc3VzcGVuZCh3aXRob3V0IFdv
TCksDQo+IHRoZSBwaHkgd2lsbCBiZSBkb3duLCB3aGljaCBkb2VzIG5vdCBndWFyYW50ZWUgdGhl
IG91dHB1dCBvZiB0aGUgUlhDIG9mIHRoZQ0KPiBwaHkuIFRoZXJlZm9yZSwgdGhlIHByZXZpb3Vz
IGNvZGUgd2lsbCBjYWxsIHBoeWxpbmtfcmVzdW1lKCkgYmVmb3JlDQo+IHN0bW1hY19od19zZXR1
cCgpLg0KPiANCj4gSSB0aGluayB3ZSBuZWVkIHBoeWxpbmtfcGh5X3Jlc3VtZSgpIHdoaWNoIHN0
bW1hYyBjYW4gdXNlIHRvIHJlc3VtZSB0aGUNCj4gUEhZIHdpdGhvdXQgcmVzdW1pbmcgcGh5bGlu
aywgYXNzdW1pbmcgdGhhdCB3aWxsIG91dHB1dCB0aGUgUlhDLiBXaGljaA0KPiBQSFkgZHJpdmVy
KHMpIGFyZSB1c2VkIHdpdGggc3RtbWFjPw0KDQpZZXMsIHRoYXQgd2lsbCBiZSBhIGJldHRlciB3
YXkhIA0KRm9yIG5vdywgd2UgdXNlIEFSODAzMSBpbiBkcml2ZXJzL25ldC9waHkvYXQ4MDN4LmMg
YW5kDQpSVEw4MjExRi9SVEw4MjExRi1WRCBpbiBkcml2ZXJzL25ldC9waHkvcmVhbHRlay5jIHdp
dGggc3RtbWFjLg0KDQoNCkJlc3QgUmVnYXJkcywNCkNsYXJrIFdhbmcNCg0KPiANCj4gLS0NCj4g
Uk1LJ3MgUGF0Y2ggc3lzdGVtOg0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9u
Lm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZ3d3cNCj4gLmFybWxpbnV4Lm9yZy51ayUy
RmRldmVsb3BlciUyRnBhdGNoZXMlMkYmYW1wO2RhdGE9MDUlN0MwMSU3Q3hpYQ0KPiBvbmluZy53
YW5nJTQwbnhwLmNvbSU3QzliM2E1Mzg5OTczYjQ4OTYzZWU3MDhkYWQyYzkyNGEzJTdDNjg2DQo+
IGVhMWQzYmMyYjRjNmZhOTJjZDk5YzVjMzAxNjM1JTdDMCU3QzAlN0M2MzgwNTQwNTg1OTEwODU0
NDglN0MNCj4gVW5rbm93biU3Q1RXRnBiR1pzYjNkOGV5SldJam9pTUM0d0xqQXdNREFpTENKUUlq
b2lWMmx1TXpJaUxDSkINCj4gVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0QlN0MzMDAwJTdDJTdD
JTdDJmFtcDtzZGF0YT0wcWIlMkYNCj4gTnBaVWVJNDJTR2VrVDQ4OExvYjlhUTZkMkVCNHhWOTQ0
MzMwUWtJJTNEJmFtcDtyZXNlcnZlZD0wDQo+IEZUVFAgaXMgaGVyZSEgNDBNYnBzIGRvd24gMTBN
YnBzIHVwLiBEZWNlbnQgY29ubmVjdGl2aXR5IGF0IGxhc3QhDQo=
