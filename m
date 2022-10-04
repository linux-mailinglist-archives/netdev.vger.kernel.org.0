Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5565F444B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 15:34:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbiJDNeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 09:34:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiJDNeN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 09:34:13 -0400
Received: from EUR02-AM5-obe.outbound.protection.outlook.com (mail-eopbgr00079.outbound.protection.outlook.com [40.107.0.79])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FA611AF23;
        Tue,  4 Oct 2022 06:34:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fo2SC12+3wLcTPoCeAeuTXg9XApKSvf2VCIiiJKRsFfmRL3v4nVX3mhyNmfefNgnMy0/kJF/V2Yt7x9vkHcbltxBEdyPmhl+/Fz3vZDEGbpMP08xg8qpkxJSfNk6IMkuaK50/d9cKLQvMW32fRovDPyi0yLDBthUBpdRRQGsp7rokKOeNFsV8LsY/OcNcuPgPOO2Evm2v5iKW5oskCOMwQCDOKKQx4o1N1XRvnXh6dl20DG0KRNNnjmmwYy4gxhFtYd4BYHrWGH2L55xyXdCRYAG4ZtFQPVnc/pc/oUisbxdPCxhnlgDnog3qo3C7HoHMHa/uZ8J7Ts0apl74I3XYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ZAcE0Rk4yXMTZTUoykCzQKwnGqklCpv4LqeHdptBObk=;
 b=PfyAO39mv2KQi88UX52eJYU9KiMr8NiyCHHRO1Zc0dWw/u+qva8rL2ZQNYrOYmLLq/gp3LUSazbdLkeYE0a53knOkCraJeG5ODCvEPTAt6soVEhtBgYmd60gzyBJlYClRkuOLIc/+UNwVxDD2v88X75aIt4jnybG31zhgj4H+9uIOabl16PKHqQrIXYhkCjXJe4u6AL0hp8wDqy2Ctt0qdQVKla/hR7RBsE/PvqpyBXZ30RPSHBgmHAItfToRjV6SOhy/3KsaG6Aq29gGxW550ZEN5drIFYrxm31PeXQ8phRxFMRndmzDDiOjzKoV4fU3Dj4xdoRgtUMSQWr4hU10w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZAcE0Rk4yXMTZTUoykCzQKwnGqklCpv4LqeHdptBObk=;
 b=CBhnRmBOC0pm1OvSPfbf87cQhJWEhDURmrzqb3+YK848U1kX0ZNnThEDhO1Un7nRm5cIQ2Az8oJ1L/Ue80dn8mcaZNhXOCpfev/9VTLyqyM8MpSxKs5M5tApL73y9HAkFCwTEpgoq4Z0ltHpBB2vxh6YYeD88j8Tng0s97bwAiA=
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com (2603:10a6:20b:44b::7)
 by AM9PR04MB7489.eurprd04.prod.outlook.com (2603:10a6:20b:281::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5676.30; Tue, 4 Oct
 2022 13:34:10 +0000
Received: from AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::e756:33d3:f738:f8ae]) by AS8PR04MB9176.eurprd04.prod.outlook.com
 ([fe80::e756:33d3:f738:f8ae%7]) with mapi id 15.20.5676.028; Tue, 4 Oct 2022
 13:34:10 +0000
From:   Shenwei Wang <shenwei.wang@nxp.com>
To:     Jesper Dangaard Brouer <jbrouer@redhat.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "brouer@redhat.com" <brouer@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "imx@lists.linux.dev" <imx@lists.linux.dev>,
        Magnus Karlsson <magnus.karlsson@gmail.com>,
        =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: RE: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Topic: [EXT] Re: [PATCH 1/1] net: fec: add initial XDP support
Thread-Index: AQHY006sqGpD/PA5gEmZiYlRlE0jhK31oHQAgAC4dcCAAA2WgIAAADZwgAAi/oCAAARmwIAANVQAgAXfkgCAAX1ggIAAGiewgAAJ2QA=
Date:   Tue, 4 Oct 2022 13:34:10 +0000
Message-ID: <AS8PR04MB917670AAD2045CEBC122FEE1895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
References: <20220928152509.141490-1-shenwei.wang@nxp.com>
 <YzT2An2J5afN1w3L@lunn.ch>
 <PAXPR04MB9185141B58499FD00C43BB6889579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <YzWcI+U1WYJuZIdk@lunn.ch>
 <PAXPR04MB918545B92E493CB57CDE612B89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <ae658987-8763-c6de-7198-1a418e4728b4@redhat.com>
 <PAXPR04MB918584422BE4ECAF79C0295A89579@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <afb652db-05fc-d3d6-6774-bfd9830414d9@redhat.com>
 <PAXPR04MB9185743919EC6DDA54FAC3B7895B9@PAXPR04MB9185.eurprd04.prod.outlook.com>
 <4f7cf74d-95ca-f93f-7328-e0386348a06e@redhat.com>
 <AS8PR04MB9176281109667B36CB694763895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
In-Reply-To: <AS8PR04MB9176281109667B36CB694763895A9@AS8PR04MB9176.eurprd04.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR04MB9176:EE_|AM9PR04MB7489:EE_
x-ms-office365-filtering-correlation-id: afae8f9f-6390-40d5-2d4f-08daa60d1e6a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +kQNuRsQr2TBGQ3VLS28mwn/yewsVdnzKdmDMzRvU0vcrP57X1cwv3HpFydmHGozmu7C38+QmHf8SAcUw2Ol4c9zwo6OjAEu4BlbdawzIX/oGEyXbGaAFB8LEQ6KqDCewMCB0/4v964fqDb2JBP9Rh0ya5RUFKfgoWSM1BOOVUap3MhYKnNyxKtc3vsROwWwdPidcyaKRLVueVAPVb9YcWYKzOSSlM/j/OefWVojithaEHuNwQMyZsNC+AWFvvcjat2t1ltM9a0xXC3Z4HAAK0z/P3cN4YOdaHpxd+wht/9KSr3aMd6VPsR/d5fSERpf72UnWNNsEOvuQFYTBWQZEk1MMU6kXYJF6U3ZRXe1xpu4vxVBoqpYNa3+zoNI+oGuA0ybEDH47X3tOeevMChaKHypEZlCe0Gi4XZVcoxhsaG/FJOnjsVGFNGGx+Ptmd6nSo/uNGCs1vAu4CETIqDvCksS27Eurm4qh3qgo+MR9OkQ6eZygTea6QLhoJpNG9xzTcclQZLpS+XS8MgfXerT9Bz9MvOqb7iNSGZApweusVfM+sSLdkdLB2XfxtYlIWn40rjpL6ZGVtvd7m/EkZRxEQKXSa6julfwLBPXfNiBOKEEp8dg2qaYOebqzMzKf7O6XIpArOUQMqRPHN1EQqbR9On0sLogVd011EXvA8tn/nPlOW0b0yuC1kRTKCTDTs+6QlTTrvapUY+2RT3CiLLfrh2uK21CRfcAP+VFxb+1kO+KiNrKmmuSPDkWyi7QlCsUGScVVkwk1DI202NlVVy9Sw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR04MB9176.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(136003)(366004)(39860400002)(396003)(376002)(346002)(451199015)(26005)(55236004)(9686003)(86362001)(316002)(110136005)(71200400001)(54906003)(8676002)(38100700002)(55016003)(6506007)(122000001)(38070700005)(33656002)(66446008)(4326008)(7696005)(53546011)(186003)(4744005)(5660300002)(8936002)(44832011)(66946007)(66476007)(52536014)(7416002)(2940100002)(64756008)(76116006)(478600001)(66556008)(83380400001)(2906002)(41300700001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T0hoVVoxLzlWc0o0VzZiQ0gzWlNEcWJJNThuVzhMYzRpTVV0cWVka25OZjdw?=
 =?utf-8?B?Q1pjKy8vbUhWUHBwYkRNQzlzUEVrbTQ2VEdOMFZuT0pxU1ZhVjVPV0taOXRQ?=
 =?utf-8?B?dEVid0xuTWtER0tybzduWjQ2QnhlQkJOYjExZkNtUWJsZUkwdHZhZVhXbWJp?=
 =?utf-8?B?bXpSV0dCc2ZmRS92M2lDbXg2QnN0RzdMbC9uVmlQQTdHNy9FNXhPVVBmbUw2?=
 =?utf-8?B?VWhBUnBZOHZ6VDRjUVlleUZ4clIycGY4UzZhU2ZxdWIrM1h1L2cwZVoxdkVG?=
 =?utf-8?B?RW9RSjQwc3VTeGJJRHRlT2FsSjBBU3VPQlU1NW1wR2N4REZKNnV4bXJxSlR6?=
 =?utf-8?B?MHNLY2ZlZVVUTVR5NzhHbm9FUFEzMjc5UmNJK016VnVtUVdoQmx5N3dhZTBD?=
 =?utf-8?B?SFdtVkVGcVFWN0NEalI4YUZqeExEQU90TlpJazVNbS8vQzZ2TEZvMlJJQ3V1?=
 =?utf-8?B?WjRoc2tPb013d08yZ2RMU05vbWVTNktHUVpFSmFoSnRqUjlrWER6R2xRYmlp?=
 =?utf-8?B?SGwrNk05WFJVK2U5WVFWdEVHVzFVRHp2ZXJVVjZLM1BUYlNrK0krbnJOeFdQ?=
 =?utf-8?B?R1FUOTdPdHJ0RStrRXRvQy92a0JydmJsUmtXN1lXZGcvdFJ1dllvaE9EK3N0?=
 =?utf-8?B?TFFJWU5Nb3kvNCtlcnYxZFFoVVRMQ2pxU3BPVGoyWjlLWGNlbFNxNjZ4MXph?=
 =?utf-8?B?elB3OHFlZzRHR0YrKzNWTmZKY2VGMXZYcUpXWi9KOWd2cWZCNXg3dEVCeVRU?=
 =?utf-8?B?QlRKVTQ5aitpNXhRSGRqcHNTOWlZeU5sbzNQNmx3TXhGcFlhZSsrd0RmNDBX?=
 =?utf-8?B?a1VRR0RMZGVLMUEzalA4SENWMkpraGdUSWNpaHhiRmM3RnZsdG1oS2JTSldQ?=
 =?utf-8?B?Y2xHNHdOZVhYN29YSWR0VENoVlJZR2pqRzFlaXhCNng1UW1ZMDFVWXllZTJw?=
 =?utf-8?B?L1NkQ1hOT28xRWhCV1BaRTNWVU1DTWk5NGdFVEM0elBsWGQxMVgvZEZJdVhR?=
 =?utf-8?B?TVhLWXhMdnkyMmplb2I4L0hPN1MrYy9ZUWZpWDJ6Q2JUek9DcW5GZEZZNmVo?=
 =?utf-8?B?VlF1L2xQSEJyK1lTdHBPSjhUUHVZejF5YzRjMmNQN2h4SHNhUm1PNStwdlBS?=
 =?utf-8?B?SXRjUENiYnUwOUJtSkRDMG1LQis3VnRiWmhmcndqNFR1bmNicG1NNWF0VXRT?=
 =?utf-8?B?RU5PbHFBSXF3NmdJTnZjbFJvWlhTMzdqTTNHN1lLbTJjMThidmoyWTJqUloy?=
 =?utf-8?B?Rjh2eSthSGo0eEVlYXhBZUJiSnRISHM3ck13Y2dyR3JDbWF4VG1qQXE1RlJQ?=
 =?utf-8?B?Wm5jK3hDU2xMMnhQQ3VydEJTVjl0b1k2VTBIRjUrb3lJaVFtR3ZqdlhvdmNM?=
 =?utf-8?B?UjNkTjRuQXpXNW9PNDQ0bHhnOEt0ZXBFRWxvbFNTMUNFZGw0QUpLSzZTUDVQ?=
 =?utf-8?B?VGFnWUVCN2VZQkpJQkN0WGVrTFJzMzJpQ1ZUL0I1bW9XejdWcWdublg0MGJk?=
 =?utf-8?B?T2pub0Q0bURPdHpZTVI3V1JRUXMrbGRiNEdOSHZQOHU5eVEvU1NNOGNVZXpa?=
 =?utf-8?B?MVVzaDJCZFdZMXQ5d3UrSTZwY2ZZKzNKWlFLN0ZKdEZxbDI2QXozeDFWb2RZ?=
 =?utf-8?B?dFhOR1dmMVY1R1NHWTZjSHp0Mk0yaHdDd3FDVUxvVzI4ck9sT1dtc1dJVUJi?=
 =?utf-8?B?ZkUyVTRWeEIrOWtCRXlBSEVlZmJlUWtTemR2UUQrY1VaNklvYkhGZzF4VlhG?=
 =?utf-8?B?b0xEQ0twTDVzbkI0Q0F5ZWZ4Zy9QNkhUMmFXWTYvdDRFMGFsT3FJZGtTcWo4?=
 =?utf-8?B?M285aUFMM0YxbUUzbkppY3p4NWJjUDlvdGtwdS9Jb2FxUzNtaTRMSTZnSER5?=
 =?utf-8?B?bXJOWVZDSlArdGpheGQvcDdLSU1vVnppMTQvaEczblZTcDlnekVGcDEwbGN4?=
 =?utf-8?B?Wjh6MjRaUk1kQ3RxL3lZOVpKRE90cmk3V2Q1SjcvRFlYYk9QNmd5aFVlZVhE?=
 =?utf-8?B?WVFqUlFmZUE0dTBnRXdyVzR6QkFSTDc1eHoyVDM2U2ZoY0xJMDRtanR6clhM?=
 =?utf-8?B?cCtmWGZRUlNUdWxmeTJ0TDVvSzF2T0ZmaCt2bnBMNW1wb1hhZUtVaG1QWHQ3?=
 =?utf-8?Q?qlaZgwCxWe7JD8RqsEQayIsVi?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR04MB9176.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afae8f9f-6390-40d5-2d4f-08daa60d1e6a
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Oct 2022 13:34:10.1094
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: avMBfVpxce06YZtPP5cDZZRxp+XY9MNEGjRzR6IY47bkjT/iboPvdj7KDubr0AUncYDO+C6pra+YcZ3ayP+eLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM9PR04MB7489
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2hlbndlaSBXYW5nDQo+
IFNlbnQ6IFR1ZXNkYXksIE9jdG9iZXIgNCwgMjAyMiA4OjEzIEFNDQo+IFRvOiBKZXNwZXIgRGFu
Z2FhcmQgQnJvdWVyIDxqYnJvdWVyQHJlZGhhdC5jb20+OyBBbmRyZXcgTHVubg0KLi4uDQo+IEkg
aGF2ZW4ndCB0ZXN0ZWQgeGRwX3J4cV9pbmZvIHlldCwgYW5kIHdpbGwgaGF2ZSBhIHRyeSBzb21l
dGltZSBsYXRlciB0b2RheS4NCj4gSG93ZXZlciwgZm9yIHRoZSBYRFBfRFJPUCB0ZXN0LCBJIGRp
ZCB0cnkgeGRwMiB0ZXN0IGNhc2UsIGFuZCB0aGUgdGVzdGluZyByZXN1bHQNCj4gbG9va3MgcmVh
c29uYWJsZS4gVGhlIHBlcmZvcm1hbmNlIG9mIE5hdGl2ZSBtb2RlIGlzIG11Y2ggaGlnaGVyIHRo
YW4gc2tiLQ0KPiBtb2RlLg0KPiANCj4gIyB4ZHAyIGV0aDANCj4gIHByb3RvIDA6ICAgICA0NzUz
NjIgcGt0L3MNCj4gDQo+ICMgeGRwMiAtUyBldGgwICAgICAgICAgICAgIChwYWdlX3Bvb2xfcmVs
ZWFzZV9wYWdlIHNvbHV0aW9uKQ0KPiAgcHJvdG8gMTc6ICAgICA3MTk5OSBwa3Qvcw0KPiANCj4g
IyB4ZHAyIC1TIGV0aDAgICAgICAgICAgICAgKHNrYl9tYXJrX2Zvcl9yZWN5Y2xlIHNvbHV0aW9u
KQ0KPiAgcHJvdG8gMTc6ICAgICA3MjIyOCBwa3Qvcw0KPiANCg0KQ29ycmVjdGlvbiBmb3IgeGRw
MiAtUyBldGgwCShza2JfbWFya19mb3JfcmVjeWNsZSBzb2x1dGlvbikNCnByb3RvIDA6ICAgICAg
ICAgIDAgcGt0L3MNCnByb3RvIDE3OiAgICAgMTIyNDczIHBrdC9zDQoNClRoYW5rcywNClNoZW53
ZWkNCg0K
