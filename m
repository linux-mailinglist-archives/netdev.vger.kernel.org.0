Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92FDC69A602
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 08:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjBQHYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 02:24:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBQHYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 02:24:11 -0500
Received: from EUR01-DB5-obe.outbound.protection.outlook.com (mail-db5eur01on2057.outbound.protection.outlook.com [40.107.15.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5275529C;
        Thu, 16 Feb 2023 23:24:09 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=db/AZYZ4VhUjcipnT9VVyzFkVXV1++d3C74fHKsPsmm/0DglJxnxjpTG1LIFk4wZuR0homvAQW0/foH+Ba2O3zKotYnWn62pJINK20VHrM4Nzsp61ISLq3s+Kesee70wLrmVAq40p/SItVs2wCjof7RDWQ0COK06EDskcZLuk9qWzAKEQL92RJP0Y5Tkqxv+7k8BS+Y/AsBA8Kh+Vb2FBBzR9kQoki31E9hFcSWrh3VlNc0dvx97pUPv6mZHK/4ELjn06ErogoCu+VpfgOFr5+5IBtieHaTthASKpWlLYUEkV9V2qwTpJQTyZreqemxUeWhJNKzl2f+Iw74NBiVoIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6dt6cq3heZ9aiAwi7fmxJmPirHBOjzui1OhjHVC4Db8=;
 b=fuESmd3YM+eDn5txaUWIO7Akb//kM0E21kdC6LlM/v+V3TklVqdqjslpOChf1vA7KAYS8oN/XjwuMniolPfIZ3dERFqHgFOljKcT9r4jyTBgIDnz8/hS6IizSqsATUt7hVT9CjejVeHhDuVD35RkZMIVFgG3NgtttanQ50gyqitRX6Nsc/wJ8sGvBHQ38PjnTQqt7DlheJ9vQdpQXPAEOaFjo3wk+Gf23eSX7UIIqJHErXRczr386JEZ7hoFY28BSxlrU7Ge1XiCyi30Tr7/gTd14LeWXROXpLqhkccMLPla1ic4W2qBBIbCLgn3pdHKg6wnhYZ8bADW9S+2TJixnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=ericsson.com; dmarc=pass action=none header.from=ericsson.com;
 dkim=pass header.d=ericsson.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ericsson.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6dt6cq3heZ9aiAwi7fmxJmPirHBOjzui1OhjHVC4Db8=;
 b=YMlZAQWKwD8NIMBBkFKSRRuMQSyt4TfTLwqQcfmcO8azZs16LDkHCIAwQgw25+CGk8MtIKUUluyYeIPbZA9HkCcIRau7O7z/tnvbLdzxsPwQM1yn95GZXS9QRTDNaifsiPNc/3yE6w+KdkFUqeDwVLq6d6B3IDAmoBMqur7l0F8=
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com (2603:10a6:803:29::11)
 by AM9PR07MB7089.eurprd07.prod.outlook.com (2603:10a6:20b:2d3::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6111.13; Fri, 17 Feb
 2023 07:24:07 +0000
Received: from VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::87dd:ebea:d813:fe56]) by VI1PR07MB4080.eurprd07.prod.outlook.com
 ([fe80::87dd:ebea:d813:fe56%4]) with mapi id 15.20.6111.013; Fri, 17 Feb 2023
 07:24:07 +0000
From:   Ferenc Fejes <ferenc.fejes@ericsson.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vladimir.oltean@nxp.com" <vladimir.oltean@nxp.com>
CC:     "andrew@lunn.ch" <andrew@lunn.ch>,
        "amritha.nambiar@intel.com" <amritha.nambiar@intel.com>,
        "vinicius.gomes@intel.com" <vinicius.gomes@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "claudiu.manoil@nxp.com" <claudiu.manoil@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "xiaoliang.yang_1@nxp.com" <xiaoliang.yang_1@nxp.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "gerhard@engleder-embedded.com" <gerhard@engleder-embedded.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "kurt@linutronix.de" <kurt@linutronix.de>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>
Subject: Re: [PATCH net-next 08/12] net/sched: mqprio: add an extack message
 to mqprio_parse_opt()
Thread-Topic: [PATCH net-next 08/12] net/sched: mqprio: add an extack message
 to mqprio_parse_opt()
Thread-Index: AQHZQl12JDo9jBkV0EqYI+gyJWFPpa7SvOcA
Date:   Fri, 17 Feb 2023 07:24:07 +0000
Message-ID: <c60720e1a6a9768b063ba709ec536f0d89a31ff9.camel@ericsson.com>
References: <20230216232126.3402975-1-vladimir.oltean@nxp.com>
         <20230216232126.3402975-9-vladimir.oltean@nxp.com>
In-Reply-To: <20230216232126.3402975-9-vladimir.oltean@nxp.com>
Accept-Language: hu-HU, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=ericsson.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: VI1PR07MB4080:EE_|AM9PR07MB7089:EE_
x-ms-office365-filtering-correlation-id: 170f5e11-00cb-4d27-b2e4-08db10b7f4cf
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: TUFxOCNegINFxx1pZAIocOYewLsMCCI6BqF3ejSxUEQ45va829Ki6/7L7VMS8NbD9w4lupZN6HzelKYQODZxroNX6NohvZyMZqWvqPQh4fWY3KF6g27Zu9MTYiJlNr3EMZfXTe27cMhqTLadjY7XaVy1zuUwVTiUm1+IKUwOrRiNbYd4HtQo0bkscTTpcdLlsFG2mS+aKYZDoyIpICSIMt8SB6VG7PSeKQp3/7u1JoVfPE7/TTpEnts2P19xDdxxsxdINKzuvGbkkiS3nZpocRagQ96sAnicuw8xmMbBH2VWrmJp+q5jCJazZMWvp2aXXzSLNzUgHcS5gB13gcrPDOh7YGav+BNG1WYnaLqz9FPieQpudWLXmIPLZyTd0IaLfCuecHpodfimwIqJn/7zxsyVGljgW3NXpqM7jPOfWwrTs+8BMtk7D9ExBJuv8//h1d7UQj3yaQ8BeCeO0aJrkWwkFPomRUEiLnPKNRKDLTKWV9QrqpHQ+iYRn+q7zF4dVy8pOUv5uLROtlyzsOM/l1sYtni14hEsrRvHcNCt6tNuE1P/90TnJxWy2hz/whSid9vf5JaDYbHlCxGEOKSGW9m7QytkR64UZ1zh9som1gEYS0VxEReOSocm7hnDjT6yE+XzTfOTLk3kIT8bGiEyWMsC/+7SAxi9WYB8k8XCFaQU1HRUodaf5Y5yZOsNw6vPZ11AcyivsMHCK6L3naUU1Oq4C2Qccn52f+FhQuAMcz4=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR07MB4080.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(136003)(396003)(376002)(366004)(346002)(451199018)(36756003)(4326008)(66446008)(66556008)(8936002)(91956017)(66946007)(8676002)(76116006)(66476007)(2906002)(64756008)(44832011)(5660300002)(7416002)(38070700005)(38100700002)(82960400001)(86362001)(122000001)(41300700001)(478600001)(6486002)(966005)(54906003)(110136005)(316002)(71200400001)(83380400001)(6506007)(2616005)(26005)(6512007)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SVo3YzR1YXkwZVFMa0ZqOC8vRWwzb1h3VjYzdTlXanUyV2FtZG5Dc1ZQMTlh?=
 =?utf-8?B?V3hyT25OaXFEdll0WjNnL0dXNGRHOU9MRVlMdXQyUjgySEhXUE9XU1lQNmpG?=
 =?utf-8?B?TnMreEcvZnBKUWZQdldhSXdybWlsVUswVU9LTmdGd1QraFcvVkpBZG5Mc0Mz?=
 =?utf-8?B?d0JRa21UemdGeUVadEhNSmJnZDR1MldCTzg4S0prbDhvaUJLN0xDR2x2azVo?=
 =?utf-8?B?S2RER3NjTnZpMjFtbGZUZUh6c0JXSEQxcUVYQmtKZVF0aEhKNzA5VjA1MWEx?=
 =?utf-8?B?YllOTm56c0J2YVdjZGF0STlRWXpuVzE4QnAwclpVZFdPeHV0U0Yxbm1pUFVW?=
 =?utf-8?B?akNMWFVtZ0ExRElwaXI1MlJHUEVwRXdtRndwKyt4cGZ0ZVdncWhXYkRLbExT?=
 =?utf-8?B?L1YxWGtBYUx2MVpaT0dtTllHRmdKbDVHSUF3dVhtWEJrNGROVTR6QzN5UUh0?=
 =?utf-8?B?MHJxMENWSTByQUtBVUFydU03U3pZMmMxcUs5Z2NtQUhCT3BhUnduRktyVm1y?=
 =?utf-8?B?SFNjRktlNS9MWStJR1BwNWNlenlWYjBFaGQrak9NbUdPWDF3L3FMUmt0SHR6?=
 =?utf-8?B?b0haQ3N2MmNZd09JQ3hHUXNVRDdYZDlXeE9QQXFLUjNEdkY1UThXWHZnMW40?=
 =?utf-8?B?REhNMXdFTVpzZ2ZvblBsSkRvazJPQlRMVE1weXdRYUFMZ3Zsc0w0UUhzMGV6?=
 =?utf-8?B?REJ2MDAxQVJCc0Z1MVhpL01lUE16OFowMnJQZ2wwa2wrMXNPV2JYc0M3bEZW?=
 =?utf-8?B?ckUzZFZGek5CaTR5bGFEbEpvZSsxNmtpaWhCM2g3U3IzakJkMkpLR0NLUkpW?=
 =?utf-8?B?dGt0RTVBeG9HaG5vbDV0Y3lCZ05BcmFEamVqdDBpM2EzKzRDZWtOaTQvTmxm?=
 =?utf-8?B?TFR6Sm5FUW5ScllOTzRSMUNGSVpUTGd6Q2Q5bHkvcytPMjMxOTNnazhTNVpl?=
 =?utf-8?B?MWtPbUxKaDZiS1EreGlTVnhhc2wrL0xzbVBWeDJSRVZIbjRKaUFpRTc3WVND?=
 =?utf-8?B?emh0M0g0a0U3cHcyL0lYM1d3ckJjdVJxekIxUjdRTldGVUVzc21uaWNwVzdw?=
 =?utf-8?B?cTlHSGxjd2RFaEpPYUszWjFSNXJ3dU5KdmoxV1hrNStCMDBlTTZrVWpSMGVF?=
 =?utf-8?B?YVFoSjBsRWY1RklwQk9PemlTQTQwci9mZWpRKy92UEk5VWd6OWpacUYyRC9S?=
 =?utf-8?B?Ulc5ZEJ0enlZWEhUYmhJTG9Sd2ZIQzZHbzl3VDFNM0VGZ0d2dm1XcGVqOTZ1?=
 =?utf-8?B?WEorbmZDUnJZb0tFZ2ZZSTBDeFpGSnV1eExqKzI1M3lYWXNIVTVHN2dyMEtk?=
 =?utf-8?B?cGh4MTNEdzUxR2hPUWx5RVZhcGNWS1l0ZGZrcy9hZmU3ZzVWbWg4WGZIUTll?=
 =?utf-8?B?NlI0K1B4UkRvL0o5RGRPbThaa3YyUVJwcEREMCs3R1NuWUlxYVJEMEJVODFH?=
 =?utf-8?B?MzVzVWhMbnp0S3c2a3pLeDNDQzJHV05OamFQNHVUd3hGdVd2bm1xTTkzL3Yr?=
 =?utf-8?B?WGgxR1o3T1h1dS9NaldKclBvODBTMW5XR0JIejA2cmhmdUlycTNwdHpDUklU?=
 =?utf-8?B?ejFtVnMrVjc0blp3THVHaXZ6NkZiQ1Q1UFlmeVFYdE1OSEh6ZytMUnVMQkJQ?=
 =?utf-8?B?WTk4N0w2ZUFySVhqRUY3NkNnbjk0RTRKbXk4YkVQN1lNdzJKOGYzZmZqN25C?=
 =?utf-8?B?TkxxRDlydnRvVW9WZmhEZGdKeFBBZTdUSUs4UmxJU0orV1o4R2ZnMFNnc0NH?=
 =?utf-8?B?eG1jeDhiaFd4VVIzTlN0eU1lM3FDQ2JhZHl6ZGNpT0ZQb2VUYkZudVhGblNX?=
 =?utf-8?B?bWpuTTA3YnUrUmpybTZFcEhPWkY4TVpuYmE4a0dmMjU3bCs4UHdOcHFncEhK?=
 =?utf-8?B?d1BjQTUzME9LZVpuOFZVbmRBN2FML203Zk1nbFRpa2wwRFU5VjFMOHNOMkRs?=
 =?utf-8?B?akQzU0VvYXBqZmtYZWtuZ1hXVnFwUDhhUlc1aUpQZjB4U3hma0VHRnp6Y09D?=
 =?utf-8?B?d1g0N3B1UWhBVWhtZmdTWG1LZEJnbXFwK2xIQ1YrdnUyelRzVHNQaXJJUTVK?=
 =?utf-8?B?eXMzeGVHMGRRMHVsNXlidGxFYUZHb2JLMUdhVVVMZElNc2JSc3BnMEJOZDR3?=
 =?utf-8?B?TDdxcU16RlJKM21zUlRENDNsTUhPV2FyQ3I1ZHhNaDdQODZzVzNIMG9qeTds?=
 =?utf-8?B?Y0E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <8F425764BC0F86438947F7F8126DDF40@eurprd07.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: ericsson.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR07MB4080.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 170f5e11-00cb-4d27-b2e4-08db10b7f4cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Feb 2023 07:24:07.4900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 92e84ceb-fbfd-47ab-be52-080c6b87953f
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: degRRKs/K9CpToz4R5rT9Ii454l+rPi0oJPxCfzubhrA0m2Cqbp/muMx12igUHpjJ5682kxIjoduf3Q98dtLfWxpKQ5MUmWWHdJYY1EMEy0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR07MB7089
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIhDQoNCk9uIEZyaSwgMjAyMy0wMi0xNyBhdCAwMToyMSArMDIwMCwgVmxhZGlt
aXIgT2x0ZWFuIHdyb3RlOg0KPiBGZXJlbmMgcmVwb3J0cyB0aGF0IGEgY29tYmluYXRpb24gb2Yg
cG9vciBpcHJvdXRlMiBkZWZhdWx0cyBhbmQNCj4gb2JzY3VyZQ0KPiBjYXNlcyB3aGVyZSB0aGUg
a2VybmVsIHJldHVybnMgLUVJTlZBTCBtYWtlIGl0IGRpZmZpY3VsdCB0bw0KPiB1bmRlcnN0YW5k
DQo+IHdoYXQgaXMgd3Jvbmcgd2l0aCB0aGlzIGNvbW1hbmQ6DQo+IA0KPiAkIGlwIGxpbmsgYWRk
IHZldGgwIG51bXR4cXVldWVzIDggbnVtcnhxdWV1ZXMgOCB0eXBlIHZldGggcGVlciBuYW1lDQo+
IHZldGgxDQo+ICQgdGMgcWRpc2MgYWRkIGRldiB2ZXRoMCByb290IG1xcHJpbyBudW1fdGMgOCBt
YXAgMCAxIDIgMyA0IDUgNiA3IFwNCj4gwqDCoMKgwqDCoMKgwqAgcXVldWVzIDFAMCAxQDEgMUAy
IDFAMyAxQDQgMUA1IDFANiAxQDcNCj4gUlRORVRMSU5LIGFuc3dlcnM6IEludmFsaWQgYXJndW1l
bnQNCj4gDQo+IEhvcGVmdWxseSB3aXRoIHRoaXMgcGF0Y2gsIHRoZSBjYXVzZSBpcyBjbGVhcmVy
Og0KPiANCj4gRXJyb3I6IERldmljZSBkb2VzIG5vdCBzdXBwb3J0IGhhcmR3YXJlIG9mZmxvYWQu
DQoNCk11Y2ggYmV0dGVyLCBncmVhdCBpbXByb3ZlbWVudCENCg0KPiANCj4gVGhpcyB3YXMgcmVq
ZWN0ZWQgYmVjYXVzZSBpcHJvdXRlMiBkZWZhdWx0cyB0byAiaHcgMSIgaWYgdGhlIG9wdGlvbg0K
PiBpcw0KPiBub3Qgc3BlY2lmaWVkLg0KPiANCj4gTGluazoNCj4gaHR0cHM6Ly9wYXRjaHdvcmsu
a2VybmVsLm9yZy9wcm9qZWN0L25ldGRldmJwZi9wYXRjaC8yMDIzMDIwNDEzNTMwNy4xMDM2OTg4
LTMtdmxhZGltaXIub2x0ZWFuQG54cC5jb20vIzI1MjE1NjM2DQo+IFNpZ25lZC1vZmYtYnk6IFZs
YWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+IC0tLQ0KPiDCoG5ldC9z
Y2hlZC9zY2hfbXFwcmlvLmMgfCA1ICsrKystDQo+IMKgMSBmaWxlIGNoYW5nZWQsIDQgaW5zZXJ0
aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL25ldC9zY2hlZC9zY2hf
bXFwcmlvLmMgYi9uZXQvc2NoZWQvc2NoX21xcHJpby5jDQo+IGluZGV4IDE4ZWRhNWZhZGU4MS4u
NTJjZmMwZWMyZTIzIDEwMDY0NA0KPiAtLS0gYS9uZXQvc2NoZWQvc2NoX21xcHJpby5jDQo+ICsr
KyBiL25ldC9zY2hlZC9zY2hfbXFwcmlvLmMNCj4gQEAgLTEzNCw4ICsxMzQsMTEgQEAgc3RhdGlj
IGludCBtcXByaW9fcGFyc2Vfb3B0KHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpkZXYsIHN0cnVjdCB0
Y19tcXByaW9fcW9wdCAqcW9wdCwNCj4gwqDCoMKgwqDCoMKgwqDCoC8qIElmIG5kb19zZXR1cF90
YyBpcyBub3QgcHJlc2VudCB0aGVuIGhhcmR3YXJlIGRvZXNuJ3QNCj4gc3VwcG9ydCBvZmZsb2Fk
DQo+IMKgwqDCoMKgwqDCoMKgwqAgKiBhbmQgd2Ugc2hvdWxkIHJldHVybiBhbiBlcnJvci4NCj4g
wqDCoMKgwqDCoMKgwqDCoCAqLw0KPiAtwqDCoMKgwqDCoMKgwqBpZiAocW9wdC0+aHcgJiYgIWRl
di0+bmV0ZGV2X29wcy0+bmRvX3NldHVwX3RjKQ0KPiArwqDCoMKgwqDCoMKgwqBpZiAocW9wdC0+
aHcgJiYgIWRldi0+bmV0ZGV2X29wcy0+bmRvX3NldHVwX3RjKSB7DQo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqBOTF9TRVRfRVJSX01TRyhleHRhY2ssDQo+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgICJEZXZpY2UgZG9l
cyBub3Qgc3VwcG9ydCBoYXJkd2FyZQ0KPiBvZmZsb2FkIik7DQo+IMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgcmV0dXJuIC1FSU5WQUw7DQo+ICvCoMKgwqDCoMKgwqDCoH0NCj4gwqAN
Cj4gwqDCoMKgwqDCoMKgwqDCoHJldHVybiAwOw0KPiDCoH0NCg0KVGhhbmtzIGZvciBkb2luZyB0
aGlzIQ0KDQpCZXN0LA0KRmVyZW5jDQo=
