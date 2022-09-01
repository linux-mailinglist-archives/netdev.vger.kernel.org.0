Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FFCA5A98E7
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 15:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbiIANdE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Sep 2022 09:33:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiIANcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Sep 2022 09:32:42 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20084.outbound.protection.outlook.com [40.107.2.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8B6926E7;
        Thu,  1 Sep 2022 06:29:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CTnVpeJZrQfeYGHjQ7jYdllFF1TLzoVzkHlWk3A+vvP6fRIewzBskLfcP1lp/Ry8bodFTsyv1DYyKwpgB0iushiqc1Oa5Tuqj6yZ8UQl9rg2jrclhTlaP1eSC/piVSgXPdq5TTsEF1pFp1QBSjCDlIg9MnkgTagd3u8BW4V1WFWH7T6v0Rzvdf/omJYBfU1d/APa70Jgxjl3AcSl81/ZhYRpEiV+YbR76Y6EbtO/AGTr+AxM/6SQ6WfiY5VDtcXyulwtL1EDBbEpR55Ktq/i0H8c9X1Mdnf2DW2qlX4muRtIgfwzfMr2X5PjwAYayT/Z6oYkYIGW5JZrer3w9GyuCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YUAJmu5FkbyHLBjGmJDbu4e/xiltYoBJlcQXRDxFmeY=;
 b=MxZOzSSvsmV7c944hCqM3mIW+j8tuB4g8XgxTpVFAuXD4W6Di31PN2INaH7MYTP5sqGHH+cunNZRTc2ipQt4axDedrl8c2EuIj1mACJwRu0TuHB2YFf/IxaBPrUjF7EawtK+ibTDw7xdCljdnFyJlPLTTsP29qSY7AtkAPYXlCf8Tqn9T3KHgQ7aAGJ3dWLi0f3ba5Js5SSrLXTzc4m0LheeR97jhp7i3LrFuAK1u/WaVt58sKCXVMRSoCU3cm9bSG9OQ8yfppXoWF1tXUGdeKRBRCZhYyu/SPZSuoq9c17PWDGpzStpI0GYBoLkcSd2kdJ5fZlj9Mb5/iWTWWGorw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YUAJmu5FkbyHLBjGmJDbu4e/xiltYoBJlcQXRDxFmeY=;
 b=gd3A6rDrCZG6KN0FCZcjUtjCUEq2qxzTfroVHakwQO06SwdA2CPqFLUWBAdXqp2V6alYf39G8z7466O0fb6ErX4V74Vq9TyDHvGb6DJ15Mw0yp1VJtRhOlgzKvRg4Mrx9AioiINzUTHtpdZvDt+unQFu5ENlFRA93ZAqeVvm+2Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4883.eurprd04.prod.outlook.com (2603:10a6:208:c5::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Thu, 1 Sep
 2022 13:29:04 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::3412:9d57:ec73:fef3%5]) with mapi id 15.20.5588.010; Thu, 1 Sep 2022
 13:29:04 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Colin Foster <colin.foster@in-advantage.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <razor@blackwall.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        =?utf-8?B?TWFyZWsgQmVow7pu?= <kabel@kernel.org>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        DENG Qingfang <dqfext@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alsi@bang-olufsen.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>
Subject: Re: [PATCH net-next 3/9] net: dsa: allow the DSA master to be seen
 and changed through rtnetlink
Thread-Topic: [PATCH net-next 3/9] net: dsa: allow the DSA master to be seen
 and changed through rtnetlink
Thread-Index: AQHYvKsOCAAEFUKZsUm3SQq/zYx5cK3J8pMAgAChsYA=
Date:   Thu, 1 Sep 2022 13:29:04 +0000
Message-ID: <20220901132903.yidpk3v4wrm4hfu4@skbuf>
References: <20220830195932.683432-1-vladimir.oltean@nxp.com>
 <20220830195932.683432-4-vladimir.oltean@nxp.com>
 <20220831205020.28fbfcc5@kernel.org>
In-Reply-To: <20220831205020.28fbfcc5@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ae24a428-35a4-4db6-978d-08da8c1df08c
x-ms-traffictypediagnostic: AM0PR04MB4883:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4qWPxLuKiqQghXlmTfTsjYUZMGCxQeW3DaqEd33GoWqGiLLbxhh/J4Prvy4vMH5emo3qgqJ9zygUsq8H7OUm6yyDlk61WtBEM/zSPUvP+ZtdzK5D5KZ1P38Jbq7mjniAvJTd1Oah0F95kisdCGrPvU2qcV2+spVqCK4TxjrGIDfsTzBeHvCojKN+shlE3ugNmi6z6OkyLv17aXimqzZFKqKH4HynqX6Uh5Y8fyXgO+O9OJw7MSqifEcCKqoZCVa5SguAuTa9uPVpaenmE4qufEYTCe9m9DFp/KzI/tm1ZfnzSfVqgpi2dENAptmnXwbEsDes6aWBXU+lxi31+KRwGsvAyGvcEbCiC3/s8XWzXYhDh+SMp9yX8EOD29zvMiByDYlyx/uE4um3ceAIifffx4XesfEwmNNbiJQuhHeFFB3kUM86DJGSFLzM9c+WJK0pVm8dkR3RhA+oB65c6matOeXBwl7A6QOorc+/1Upd52gumqHWXcmHJfdCGyCfW2mewr2HfbSjvqm/3fp2mDZf4OnWG8o7zXwPXSHcISurXe2DbJ1GZKCuWC+rsovywcgxA/Zmz92a60gbeTDZUwCkDIeWIbN6j6HVQ7lbv9lH0I9Uj4DW4yr2/NTLxErT7jPIpzzmkpEdKXQDU9jZTRXD67E8IobHetvdsb62Yi6+C4RQKM7ZNBGC6krJ+WHPJoSNovfegjRMT7w7C3BJS8eWWsbDSzCYkB1YQjMIfCxDUZhXYaGe8ieY+sonX1lfv6Fn
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(4636009)(346002)(396003)(39860400002)(376002)(366004)(136003)(6486002)(6512007)(83380400001)(9686003)(6506007)(71200400001)(41300700001)(478600001)(76116006)(26005)(1076003)(186003)(33716001)(44832011)(5660300002)(7416002)(8936002)(8676002)(4744005)(86362001)(91956017)(66556008)(38070700005)(4326008)(54906003)(316002)(66946007)(38100700002)(122000001)(64756008)(66446008)(66476007)(6916009)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Uk1jTWFFWXAvdG5qbG8vazBZVXF2ckVMQjZSVGZhRTFUR2JPOXluUURUZGZW?=
 =?utf-8?B?MmhLZytKK0NOUjZNMXh0czlub3RqcnphSmVFL3gvcXh3eWtXcWR6bDJnQzFO?=
 =?utf-8?B?Z0ZCbVNhV1dBVjdLcFBiLzJLUVVBOWFWbzFCQTZKazRvWENJdmFSR1h4clRK?=
 =?utf-8?B?QzZWNXozdTVtUHlvd200N1JRcWVnRXo4VThHYURCdnF4b0p4Y2J6c3BBRXg1?=
 =?utf-8?B?MTM4T2tOZUpsMG5ObFljMWVwcGg4VXJFTVhPVVFQT0FzSkJTdW5TYlpDci9S?=
 =?utf-8?B?VzdibXFGektmS0JCNEVSdEJzZTJFZGk5cHNaT2I5bkJRVTBJNlg4MEk1Sk1a?=
 =?utf-8?B?WTlqKzRHNTRET2wxZEVRSCtyejYrc3E2aElyZXo4NmE5bXJmVU5HOTNjTkJT?=
 =?utf-8?B?NVdBVjVRVUNKSy81UkxsSmRMd3hwUDkwbjJtU2o5RmtMNDFZL0xONTZvVVpk?=
 =?utf-8?B?Mk02S1Rxam91WDhIem14YlgvS0swSnZPRllEWk5RV2xZVSthenFsc3pWNWVZ?=
 =?utf-8?B?SHV1bkN1ZjF3Ynd3MHgrczRvTTVwVUpJcjBrQ0hjQ1NHalpaV0QzRnB4SFlH?=
 =?utf-8?B?K3NPVGhNeFN1RHdPQk5RaXVXcjQrOU1oem0zV3BPMmYwNXdDZDNmdzVEQSsy?=
 =?utf-8?B?ZTcvaVp6eXozRnJjVHlrUm9NdEZtM1FnYmVROUF6V3BZVVl6ajJMaTNXVW5M?=
 =?utf-8?B?eDRZZTVGcFREQysrMEpHYXhCcGNiaFZSejNBaHllSDltelNtWnVwV0hRWXZa?=
 =?utf-8?B?VVRKM2dZUE1yTkJwRzhPSlpYN1lEelkyU0R2RU5SRjRXdlhOenZaTWY4MXZY?=
 =?utf-8?B?cjRRWnhTNWRDNysycnlhYnUzWVVYYzQvYWoxYjM4NUsvVDhqK1dPWjlxVFJi?=
 =?utf-8?B?ejVKWUJqU2RZK2I3ZmlnL1FZUmdBdEJSNzFCZDNFYm5sV2VwVnp1c1M3eHlr?=
 =?utf-8?B?UDVFN3ZnZjVtMStIK296VGRtTDlkVGt6Z21ueGpoVk13VG1IeFkza2U0R0tP?=
 =?utf-8?B?YVR3aEJtVDhNcGc5ZDN5czhMWUNCYXljdjlrZHZBY3UxaTk3UmtjMzlCRGlO?=
 =?utf-8?B?NzFKeGxDbVBITllWYkRzb3p1SVl3L0pwVExrcjlJSE1hSjJVYjc0SkVvL2Rt?=
 =?utf-8?B?VDZhNTMweDZWb0dSUUJzeHRldVNnaklsbGZCbDRxbWNGTlNRQVVNTEpqOWVW?=
 =?utf-8?B?akJ5b3RYTVgwNjBtUzBvciszMk55akl0MTFNY2U1OGljNlNUdHFoOUFLVWlz?=
 =?utf-8?B?b2JJZFBaSDdLMStJcW12WE1VaXJ0cU04V0xGbE9SOUZBSFRiWUYzWmg4aWdW?=
 =?utf-8?B?Vlg5cXFZRmVQeTYzM29PazFVMmVVRVplbVBpMkpydThFSzh6MTBYeHU4WG1R?=
 =?utf-8?B?Ykd0dE02aTdSOUZMWndKVUhtbVEvdGNieklJUXFKOGZKSzdtcXgrUlhxYWgx?=
 =?utf-8?B?Mk53Wjk1LzUzYVBvQXdrbnU4aWUvOUpiT3pDUTVNZ2J6bkxmdk41aUdHYUgy?=
 =?utf-8?B?K1VXSTlrcjBjdWh3YmdqcDhtYjhMZHBOLzFXdHNXRlpENFA5dDJKczRxRDJz?=
 =?utf-8?B?NUdFcW1vYlBIYndDK0pjZTdVUkJvV3ZKc2o5cUlBZjJKS0Y1R0xDSTNrcEZM?=
 =?utf-8?B?VTFJa0trNzMzMEtydFNGcGNQNHU0UkpLaWNkd1dKRzNNQXg2WjRaLzIvNWI4?=
 =?utf-8?B?MnN0c21zZzAveFZkQzBPU1o5UzFGMHhIdmxPanRwM29jSlNsbmozRElIMlNI?=
 =?utf-8?B?czVEdE82Yi9YMmtUY0ZwUk9KV1pwdURXTHcyb29FakVhV2JSbVZhTG9lZ05Y?=
 =?utf-8?B?NGQ0R0k3VjkxMUFaMmFtdEdRbjB4a0xuOFBVZWNUcWhoQ0t0UWk3aWNhZDR2?=
 =?utf-8?B?Y1RmdkJVdGJrUGhUYTRGdkNZNTJKczVoUk1hcnh1R0l5UDYreWNkaktHRHNy?=
 =?utf-8?B?RktkZFMwMFdmeTBxcEVmaDdhbFN5ZFZEeHhqWTdHcnJLZWpRZUtRd2RmSWFk?=
 =?utf-8?B?ZkZudGxZZ0Z6dlc3cHpVVVNLU2JwQktBQVg3dUNsOTdXT3lDMHZrblhHUm9K?=
 =?utf-8?B?RCtZVlhYcWlxbjIxVXJWWW4vSTd0c2l4MlpFVm9RTXMrR2JIWWZPV2ZlU2Zt?=
 =?utf-8?B?SWM4SExrcjhPZWpXMkRNQVhSSEZxaXFnT2JjRWJnN1kwUEVpMUpIei9XS2x0?=
 =?utf-8?B?TUE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DE9B21398335924F92E296F06DC6488D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ae24a428-35a4-4db6-978d-08da8c1df08c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2022 13:29:04.3563
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ut4iMKgnzZBxGjXT+kR4n3iNnlQW+b8ZmgMGR+Ap3hGFChValOeYHVHXj0MZf4HtOSdLELNV5GCvPOR2pUZplA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4883
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCBBdWcgMzEsIDIwMjIgYXQgMDg6NTA6MjBQTSAtMDcwMCwgSmFrdWIgS2ljaW5za2kg
d3JvdGU6DQo+IG5ldC9kc2EvcG9ydC5jOiBJbiBmdW5jdGlvbiDigJhkc2FfcG9ydF9jaGFuZ2Vf
bWFzdGVy4oCZOg0KPiBuZXQvZHNhL3BvcnQuYzoxNDE0OjEzOiB3YXJuaW5nOiB1bnVzZWQgdmFy
aWFibGUg4oCYcG9ydOKAmSBbLVd1bnVzZWQtdmFyaWFibGVdDQo+ICAxNDE0IHwgICAgICAgICBp
bnQgcG9ydCA9IGRwLT5pbmRleDsNCj4gICAgICAgfCAgICAgICAgICAgICBefn5+DQoNCkkgZGlk
IGJ1aWxkIHBhdGNoIGJ5IHBhdGNoLCBidXQgaW4gdGhlIHNlYSBvZiBzdHVmZiB0aGF0IGdvdCBy
ZWJ1aWx0DQp3aGVuIEkgbW9kaWZpZWQgaW5jbHVkZS91YXBpL2xpbnV4L2lmX2xpbmsuaCwgSSBj
b3VsZG4ndCBub3RpY2UgYW55dGhpbmcuDQoNCj4gSSBwcmVzdW1lIHlvdSBoYWQgYSBsb29rIGFy
b3VuZCB3aGF0IHNpZGUgZWZmZWN0cyBzZXR0aW5nIHJ0bmxfbGlua19vcHMNCj4gd2lsbCBoYXZl
PyBTaG91bGQgLm5ldG5zX3JlZnVuZCBiZSB0cnVlPw0KDQpJJ20gbm90IHF1aXRlIHN1cmUgd2hh
dCBvdGhlciBzaWRlIGVmZmVjdHMgdGhlcmUgd2lsbCBiZS4gVGhlIG5ldG5zX3JlZnVuZA0KcHJv
cGVydHkgc2hvdWxkIGJlIHNldCB0byB0cnVlLCB5ZXMu
