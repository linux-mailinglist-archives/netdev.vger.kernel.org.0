Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BB3356D750
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 10:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbiGKIB2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 04:01:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229508AbiGKIB0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 04:01:26 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20070.outbound.protection.outlook.com [40.107.2.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24A51CB36;
        Mon, 11 Jul 2022 01:01:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SVTrhQBz2VDm7GJD+2zQHP5Q+fjfdCObhjP+peBkWL8U+Gi/F2GGWG2x5w7nAEhB9Gp6bfZ6WZueu5B4QRKhYr3FToEPybRAdRjlSxp5AZMFJDHIuIG8nX933snI9ab9vm5jjBvU8G2TxqoiY/hDawK6hdDc5FEuka3Q/9OX6YEl8zeOm33Y8n+Hitf1FvbE16pCf/hAyVJ/rIS6Q6ACZy5fj1MZ79n81KIhgesYdrF0pdFJLGtbqjKplipk2BvRDeNK8z9bihh01kk+OL8h4BCZ7WY0bub9StAKR2FOWcQ7C8tp6C6POvmjRCztak240M1JI7sn39KhNhzFVAobPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=d8wYy1FUJeMfoo2AS2Ro4X0P/7GSBO94TWFC+r2Z8c0=;
 b=SMnoE5Cwuonib+lhWrYWCSUB0vHzPnj5T9RslBxm7uy+zxFVld8ClCTP/ckz8/F656zgj2AnvIRfOrCiVbnz5oDLHtmHSS7AYXYhP1nNy0Kyd1MteCn9iiORmGk6TrLbR99aEpBZdyYBFkBX6zcI/XsEQA0NU9TS+1HzLrxZPM6CijtBCwvcJSeB/hUCCEqJhV0cs0wXeSE611zxkgsVRqgyJ0fIuyFJ6jF3uBKzNnN9AJ+4s/cAO5BZ0MfprDpsV/PzeVPA+mMsAhtl9wbJ5o85y6q/UWWgxd/O2elwCWT7kgemwFkePE/4JywPeggNDC/wKSmKYxD0LRoXJwrRDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d8wYy1FUJeMfoo2AS2Ro4X0P/7GSBO94TWFC+r2Z8c0=;
 b=A83bpENLQ1MHOx/dHMJIvs9pJ3ngr88Ny2SJajrbTNy8Jp8C8cgcTz0OWSoIf1GYb2Qihy2FGqVXQckHRoXoTAYSL+2q5yV7TwHc/OLWyM2fNw5o97LZ05h2qre4Hp67RgjdyEW29ldT7W4jsWU1bnzOFYrBrWfS6205Pr6+Vc4=
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com (2603:10a6:20b:40a::9)
 by AM0PR04MB5988.eurprd04.prod.outlook.com (2603:10a6:208:11b::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Mon, 11 Jul
 2022 08:01:21 +0000
Received: from AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573]) by AM9PR04MB9003.eurprd04.prod.outlook.com
 ([fe80::a9e6:66bf:9b6f:1573%8]) with mapi id 15.20.5417.026; Mon, 11 Jul 2022
 08:01:21 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "shawnguo@kernel.org" <shawnguo@kernel.org>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "festevam@gmail.com" <festevam@gmail.com>,
        dl-linux-imx <linux-imx@nxp.com>, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>,
        "sudeep.holla@arm.com" <sudeep.holla@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Aisheng Dong <aisheng.dong@nxp.com>
Subject: RE: [EXT] Re: [PATCH V2 3/3] arm64: dts: imx8ulp-evk: Add the fec
 support
Thread-Topic: [EXT] Re: [PATCH V2 3/3] arm64: dts: imx8ulp-evk: Add the fec
 support
Thread-Index: AQHYlMiDYnPhAVEG+UCiNL5+l3Or0K14vryAgAAKnoA=
Date:   Mon, 11 Jul 2022 08:01:21 +0000
Message-ID: <AM9PR04MB900338F44D0A21A5E192559A88879@AM9PR04MB9003.eurprd04.prod.outlook.com>
References: <20220711094434.369377-1-wei.fang@nxp.com>
 <20220711094434.369377-4-wei.fang@nxp.com> <YsvK99Gb0JL3YbQB@lunn.ch>
In-Reply-To: <YsvK99Gb0JL3YbQB@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ea617621-85b5-4d67-4c97-08da63138b2d
x-ms-traffictypediagnostic: AM0PR04MB5988:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mk5m7pPY9Itw5Nk7hJ4vAdc/MVY8lufcg+fyiSY/jvOV8OL4V7fqgD6iewAQv1LQbPNq3KCUh+27jqQIU8n9kdUWCReS28TYKLE4PGgZOIWEeWIfZZjyPCjm2GgqfH8LYI+KIv5CU4NgCUS3ZhYayZyI8/Y5cc7DLK0w946ts0upswWk7GNpEDRxx24lgVdXCwmPv2UAsqs7tlrBtbXiO1ZVdrerCZJjkASanrRIG2phQpHs+414JQOLqhXpj89XbYrY1BaV/3cDEWqrZ+GCQYCXOHwoBJ66WAjzgGIEYb3c3Dw+QLRx+DZSXniBr9H9T49wZTKh4fOF4tT1RyPIqITSefosqXxEp1kAhZBPypRJ1xSVWsUegbN7MrpnVAZBs67mLwJW1hzGJhqk9bgQEeQdjKB1AGbnF7l7hVj0N5cjAZQScWMgUh+viPb6BnzSDwdT6vvjdbMwAdqQHmveN1vzH1x21Euw5N+79VAe6BpI10lSQO/fzN6JXiPh+cCrIC6hrI18Le7knk6R+X1K1/BFYkA9T4p3md0srjhqPOafmblYy+a0gZIugYyBiEeoKEa8zTWDp147xvOu2YJKFFTANJE8KYMztmSUqd0BmFkd6kxyKvFylqyCoBS17TxV1WqCvCqQvkRfZvf1Uf6VYkzKWM86DSto0gtL0HEYoIu7hwsVhf9sLS3PjDv2yGAwfRUOYpZ8b/T1alBFqomlOVMsG974trRc604emkllgLZuLysbiJvpD5ObnWRgO9ZF5DgrQStovz6J9xcs3P6rVyjGhGmvW+kiJ6MAg0awsVMNHR9Ga7jCB4nQ1LVVRUMQwq8pFvpZehUfq+7XwgcV7A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR04MB9003.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(396003)(376002)(346002)(136003)(26005)(64756008)(8676002)(66556008)(4326008)(76116006)(53546011)(66446008)(66476007)(66946007)(44832011)(5660300002)(8936002)(86362001)(478600001)(71200400001)(9686003)(52536014)(41300700001)(122000001)(38100700002)(7416002)(38070700005)(7696005)(6916009)(54906003)(316002)(33656002)(2906002)(83380400001)(55016003)(6506007)(186003)(32563001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?YllkZ1FUNm5Md1padDBRZTdtSWxWMXJ4WExkTnNQN1NwTXFrNWU2aHh2cFBI?=
 =?gb2312?B?Um1VV1Fabk9uaThSeGFKYnBHSHlLdDRtSitFRFdQaG91bE8xQkhnQXhKcEZP?=
 =?gb2312?B?bkxOMVBhb2lvSGxqb1hxOTFXMlJvYUZWaFNRT2phaWh0SXlQYjRmVGw3WjQv?=
 =?gb2312?B?QnpPMzhRWGtUeVI0TWdMWk4xY25TTTZONStUN3g1Z1ZpYXI5YjhRUWZHa3BK?=
 =?gb2312?B?c1BXN0dPMEt6Sy93NnVreml3emg1Rk85V3cvam0rOVBibWpDVkU5MCtIQmtD?=
 =?gb2312?B?V2FBT2N3U2FNdDAzSFc4VmZLUW9MdDJYeG52ZERYbnBpa2pBK0dlTHhWUXN3?=
 =?gb2312?B?dzM2QjJXQkZpRDBkem9wRUdWSVpkWTZtM25LeDVyeEVmbHNwL2NMN0F3NkY2?=
 =?gb2312?B?TmNLTmhwNzZKdDdWUEd4OE9sTVlVSlkrVGhGd0NaaGlmQ0ZILzhuLzJyR2FT?=
 =?gb2312?B?T3F3L3FaQlAxckloa1RvMnhxQlBwTk44Q2dpRVdsZnJpbjU1OTREM294cXgx?=
 =?gb2312?B?YUFzY00wcnNBS0xBa0VXMHJzblpkUVllS2Z2aFNXYUsyM2JhSnEwaHNXVDJZ?=
 =?gb2312?B?Wkd6RXpBaTZqa0Z2WlVzYnQwU0VyYllsaXJsbFNRc2VEMmVOL0ZRVjl1bVBm?=
 =?gb2312?B?UG4wcWlWVy9OTW5Sd0ZidXQ4c3BJSkloczlJdVpHNTlrRWJJdkRvaXlzUjlW?=
 =?gb2312?B?QzNOZ2FnVlRCdjZVWHdzdEpVRmdWT1VlV05rb2JiQjhJblVKVytyMmx0Z0pG?=
 =?gb2312?B?Y2srRHF0eTRpQjRHQlBnOGtMSndtZlNYbWw4azNtNWpXNzNIWXVXMGw0YWxl?=
 =?gb2312?B?Z2FWdUlxbzRNbGdHQXRhb3JUVGtLOTFpUXFuc3NadlhjN3pBSjh4UDdHRVEv?=
 =?gb2312?B?c3p3TUkvTytrQlBYQXhiWmJmOUJZRkFVOU9CMXJYNGhGQ0FiQkJKUjFKa1o2?=
 =?gb2312?B?WkVHVXdWdjBtMS9FUDZDYXNzSGdVUExqMFJxUzFweGVkU3JNeWxLZE5QRWM4?=
 =?gb2312?B?M0V1WUcvNXFubHdiQXQ1aUdReTR6cGFzQXlSUXAyNFhtREFrR0s2bkVGNERR?=
 =?gb2312?B?UTU2YW45b2VKRW9CdElqZ1V3azRUS1FONjFmQ1F4RWNVWlYrajQwVFRjUmRL?=
 =?gb2312?B?aGxtUTJwdDQ3Q1RlNUlheVRYZlZaUlhHOGEwUXN1WUR3S2NOUmQ4OUlDWUhx?=
 =?gb2312?B?MTV0QjNvT2tlZlVZQldHUWc3YTRFbXhCLzNobE9QQVZIN0MwYTZBcnhjb245?=
 =?gb2312?B?VVdWQ1dRenVndy9PVWlubi8vQmhkWkxrdzh2UStCejZKbjAyQ3RZK1krVkJ5?=
 =?gb2312?B?ZDdtMTRVOURJMER0Znc0clVQZHd6QWZDZ29UTDNOdTk5MWZVTjFhNnRSbnBo?=
 =?gb2312?B?cENyMmxCQ2tBWEdUL3BmYnFDVFM2L0w5MUhOQmNHZGNLQUVjZEdIUmd6NHIx?=
 =?gb2312?B?MWsvbjVFOWlTN3NlN2xIU2V5MllyQkJlYlBLd1VpVXhKUlpTNU1FcHc3R2J5?=
 =?gb2312?B?VzRHV0txdmVqVUVOWkxERGVNREtkdVBGNXBCWGs5dUl1NmRsa0VucEJJMkFp?=
 =?gb2312?B?YlMwUzJPSmNaYm5aVDhNenZGK0lYKzJ5Z253c2czTitWdzJ4djBvb3J5K0pE?=
 =?gb2312?B?SmZtWDJ6ZG5qaVZlM1cxMkZIOWdNN1BEdzY4aUhUSGdNM2RYRHVjL3JlZk9h?=
 =?gb2312?B?UTF3Vmt6cmZVUndmRmxzTnhsRFJTYzJUZDl1ME1OZkl4V3NkZ0g3MUFMenRy?=
 =?gb2312?B?OWJQQ1dWemVSRDJFNTJDckYyVzJ0cGFLRmUwUklQME1kUldhY1hHVy9VR1lD?=
 =?gb2312?B?Y1VpaDBLK0tPNk5VeEtqbHI2ODdZNittaFNkYXhQdjU5cWFTT3FGU3lISklV?=
 =?gb2312?B?TFpqbFRhcFozQ25BeS9wbGFjYkVDS3NETCtLWEd3bGpKKzZoV3NZKzI0UnZt?=
 =?gb2312?B?cXovMmZncHhicUVTRkpwdHcxQzlxYVhNMHZGR1ZLUENIT1BKdkFQUEhrWnVJ?=
 =?gb2312?B?czdyM1ZkSkN2WWwzbXN0SVpub0J0UEZHdktBSXlKYjdNSXFHNy9CRDQya0Nt?=
 =?gb2312?B?cTlvbkczT0x6c2NiblBSbVErQ0tmOXFKTk5XbmtmemZhYkJXOG1WODdNL3Er?=
 =?gb2312?Q?bcYU=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM9PR04MB9003.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea617621-85b5-4d67-4c97-08da63138b2d
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Jul 2022 08:01:21.6251
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CQjyAAYBQ8F7HlaF6f2S6xfSfztG8A+0fBGslqTE4GU2ioKhdPt+pXM7h4WwRxTqpNJpV/JdSWRaqLIBSUv5Ww==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5988
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOo31MIxMcjVIDE1OjAyDQo+IFRvOiBXZWkgRmFu
ZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0
QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IHJvYmgr
ZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOw0KPiBzaGF3
bmd1b0BrZXJuZWwub3JnOyBzLmhhdWVyQHBlbmd1dHJvbml4LmRlOyBuZXRkZXZAdmdlci5rZXJu
ZWwub3JnOw0KPiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIu
a2VybmVsLm9yZzsNCj4ga2VybmVsQHBlbmd1dHJvbml4LmRlOyBmZXN0ZXZhbUBnbWFpbC5jb207
IGRsLWxpbnV4LWlteA0KPiA8bGludXgtaW14QG54cC5jb20+OyBQZW5nIEZhbiA8cGVuZy5mYW5A
bnhwLmNvbT47IEphY2t5IEJhaQ0KPiA8cGluZy5iYWlAbnhwLmNvbT47IHN1ZGVlcC5ob2xsYUBh
cm0uY29tOw0KPiBsaW51eC1hcm0ta2VybmVsQGxpc3RzLmluZnJhZGVhZC5vcmc7IEFpc2hlbmcg
RG9uZyA8YWlzaGVuZy5kb25nQG54cC5jb20+DQo+IFN1YmplY3Q6IFtFWFRdIFJlOiBbUEFUQ0gg
VjIgMy8zXSBhcm02NDogZHRzOiBpbXg4dWxwLWV2azogQWRkIHRoZSBmZWMNCj4gc3VwcG9ydA0K
PiANCj4gQ2F1dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBPbiBNb24sIEp1bCAxMSwgMjAyMiBhdCAw
Nzo0NDozNFBNICsxMDAwLCBXZWkgRmFuZyB3cm90ZToNCj4gPiBFbmFibGUgdGhlIGZlYyBvbiBp
Lk1YOFVMUCBFVksgYm9hcmQuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBXZWkgRmFuZyA8d2Vp
LmZhbmdAbnhwLmNvbT4NCj4gPiAtLS0NCj4gPiBWMiBjaGFuZ2U6DQo+ID4gQWRkIGNsb2NrX2V4
dF9ybWlpIGFuZCBjbG9ja19leHRfdHMuIFRoZXkgYXJlIGJvdGggcmVsYXRlZCB0byBFVksgYm9h
cmQuDQo+ID4gLS0tDQo+ID4gIGFyY2gvYXJtNjQvYm9vdC9kdHMvZnJlZXNjYWxlL2lteDh1bHAt
ZXZrLmR0cyB8IDU3DQo+ID4gKysrKysrKysrKysrKysrKysrKw0KPiA+ICAxIGZpbGUgY2hhbmdl
ZCwgNTcgaW5zZXJ0aW9ucygrKQ0KPiA+DQo+ID4gZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQvYm9v
dC9kdHMvZnJlZXNjYWxlL2lteDh1bHAtZXZrLmR0cw0KPiA+IGIvYXJjaC9hcm02NC9ib290L2R0
cy9mcmVlc2NhbGUvaW14OHVscC1ldmsuZHRzDQo+ID4gaW5kZXggMzNlODRjNGU5ZWQ4Li5lYmNl
NzE2YjEwZTYgMTAwNjQ0DQo+ID4gLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUv
aW14OHVscC1ldmsuZHRzDQo+ID4gKysrIGIvYXJjaC9hcm02NC9ib290L2R0cy9mcmVlc2NhbGUv
aW14OHVscC1ldmsuZHRzDQo+ID4gQEAgLTE5LDYgKzE5LDIxIEBAIG1lbW9yeUA4MDAwMDAwMCB7
DQo+ID4gICAgICAgICAgICAgICBkZXZpY2VfdHlwZSA9ICJtZW1vcnkiOw0KPiA+ICAgICAgICAg
ICAgICAgcmVnID0gPDB4MCAweDgwMDAwMDAwIDAgMHg4MDAwMDAwMD47DQo+ID4gICAgICAgfTsN
Cj4gPiArDQo+ID4gKyAgICAgY2xvY2tfZXh0X3JtaWk6IGNsb2NrLWV4dC1ybWlpIHsNCj4gPiAr
ICAgICAgICAgICAgIGNvbXBhdGlibGUgPSAiZml4ZWQtY2xvY2siOw0KPiA+ICsgICAgICAgICAg
ICAgY2xvY2stZnJlcXVlbmN5ID0gPDUwMDAwMDAwPjsNCj4gPiArICAgICAgICAgICAgIGNsb2Nr
LW91dHB1dC1uYW1lcyA9ICJleHRfcm1paV9jbGsiOw0KPiA+ICsgICAgICAgICAgICAgI2Nsb2Nr
LWNlbGxzID0gPDA+Ow0KPiA+ICsgICAgIH07DQo+ID4gKw0KPiA+ICsgICAgIGNsb2NrX2V4dF90
czogY2xvY2stZXh0LXRzIHsNCj4gPiArICAgICAgICAgICAgIGNvbXBhdGlibGUgPSAiZml4ZWQt
Y2xvY2siOw0KPiA+ICsgICAgICAgICAgICAgLyogRXh0ZXJuYWwgdHMgY2xvY2sgaXMgNTBNSFog
ZnJvbSBQSFkgb24gRVZLIGJvYXJkLiAqLw0KPiA+ICsgICAgICAgICAgICAgY2xvY2stZnJlcXVl
bmN5ID0gPDUwMDAwMDAwPjsNCj4gPiArICAgICAgICAgICAgIGNsb2NrLW91dHB1dC1uYW1lcyA9
ICJleHRfdHNfY2xrIjsNCj4gPiArICAgICAgICAgICAgICNjbG9jay1jZWxscyA9IDwwPjsNCj4g
PiArICAgICB9Ow0KPiANCj4gRG8geW91IG5lZWQgYW55IFBIWSBwcm9wZXJ0aWVzIHRvIHR1cm4g
dGhpcyBjbG9jayBvbj8gT3IgaXMgaXQgc3RyYXBwZWQgdG8gYmUNCj4gYWx3YXlzIG9uPw0KPiAN
ClllcywgdGhlIGNsb2NrIGlzIHN0cmFwcGVkIHRvIGJlIGFsd2F5cyBvbiwgc28gYW55IFBIWSBw
cm9wZXJ0eSBpcyBub3QgcmVxdWlyZWQuDQoNCj4gSSdtIHN1cnByaXNlZCBpdCBpcyBsaW1pdGVk
IHRvIEZhc3QgRXRoZXJuZXQuIEkga25vdyB0aGUgVnlicmlkIGFuZCBzb21lIG9mIHRoZQ0KPiBv
bGRlciBTb0NzIGFyZSBGYXN0IEV0aGVybmV0IG9ubHksIGJ1dCBpIHRob3VnaHQgYWxsIHRoZSBu
ZXdlciBzdXBwb3J0ZWQgMUc/DQo+IA0KPiAgICAgICAgICBBbmRyZXcNCg0KVGhlIEZFQyBvZiBp
bXg4dWxwIGlzIHJldXNlZCBmcm9tIGlteDZ1bCAsIGl0IHN1cHBvcnRzIDEwLzEwMCBNYml0L3Mg
ZnVsbC1kdXBsZXggYW5kIGNvbmZpZ3VyYWJsZSBoYWxmLWR1cGxleCBvcGVyYXRpb24sIGRvIG5v
dCBzdXBwb3J0IDFHLg0K
