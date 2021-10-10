Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6435E428099
	for <lists+netdev@lfdr.de>; Sun, 10 Oct 2021 12:56:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbhJJK6i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 06:58:38 -0400
Received: from mail-eopbgr1410104.outbound.protection.outlook.com ([40.107.141.104]:39168
        "EHLO JPN01-OS2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231556AbhJJK6f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Oct 2021 06:58:35 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PpHkpjsWrx3CpJiGbHzI/Skr5boz+Uo1f42FkjLn6LzeFDzOLaTbOkT87XrnpiBOjEs6fHnvUjZfz/r6ljUpE1jR8j+TsWSgB8mmqUIE058PBpze7zGmUsCprExy9Ud7NHACLt6J969J+kUMEGd0CWqMBH3zk5BuSzQWQEJVSIkdkGr5el+xt5YpPs5LyDDU3iAvGM80oDFctlAIMKJZiJqlpGnrfW7Eqq/eXazk03JeBayXBLDKHvM3wR9FucYv5ITWpu+Z+In+N/1xUCkTpvBmaAF/cefMQeB6rblTMSpPUMgHQlZrYdTMbFEZFWhpIktTXTLZO9ZjeWZzq2whCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=R6SHmzDQ/eiRF7wGUtgfmmr0wBrBCmE+Cx+zJFchXgE=;
 b=gEIjn7tNpZ9meKTEEHRuI74vBi6pvz/QyVTFaaBm6kgSUd4BOzl3gzacKeFGyq19sQv8sKEJciMMW/MwvVqcBnk1PjqsfpakULN/ezG25QowS+nmrNvex0NPH4nwp9aEO+EzY8VuHFSVRNT+/kCzbbDlUkWMvvOE8AFIWk2joX8xR9kn2pblkBxvuZQ5bf5Lvx/62m5vYrH0ba5kpXZQRiYOKCT/Rq5lr55xbGQmdMh2NGiyyqiJfaYmnD6zKiFiHSYYvvaM+5CFuIAUebiex/tAtWtcH8ew7XxMtgcLf6y4CUCa/Xk+Dm56ApgfgvXVzYAVq8YL6B9t30PSM865Pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bp.renesas.com; dmarc=pass action=none
 header.from=bp.renesas.com; dkim=pass header.d=bp.renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=R6SHmzDQ/eiRF7wGUtgfmmr0wBrBCmE+Cx+zJFchXgE=;
 b=VTMzW/ZqJ8zW90ORcWiX6UG+4oeMibT8AjQ3K2vKu7qKBhhGPQsLnRkl7C9KO+2Tv+kar2n6n63jk8qLjgDBBbtWCp12Iju0lq+wmAnaW4tbo65tXdMoBXL2nLGnbcEh0gqfEQRvVqBs8oJFrfZK/r3y2iRk7Xl5DrknZsVQl3U=
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com (2603:1096:604:bb::5)
 by OS3PR01MB5960.jpnprd01.prod.outlook.com (2603:1096:604:d2::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4587.19; Sun, 10 Oct
 2021 10:56:32 +0000
Received: from OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1]) by OS0PR01MB5922.jpnprd01.prod.outlook.com
 ([fe80::9ca6:1cf:5:9fc1%3]) with mapi id 15.20.4587.025; Sun, 10 Oct 2021
 10:56:32 +0000
From:   Biju Das <biju.das.jz@bp.renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        Adam Ford <aford173@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Biju Das <biju.das@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>
Subject: RE: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Topic: [PATCH net-next v2 13/14] ravb: Update EMAC configuration mode
 comment
Thread-Index: AQHXvaixd8lMzh4St0+QfQ9kX6MhhKvL9taAgAABWOCAAAStAIAABr7Q
Date:   Sun, 10 Oct 2021 10:56:32 +0000
Message-ID: <OS0PR01MB592229224714550A4BFC10B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
References: <20211010072920.20706-1-biju.das.jz@bp.renesas.com>
 <20211010072920.20706-14-biju.das.jz@bp.renesas.com>
 <8c6496db-8b91-8fb8-eb01-d35807694149@gmail.com>
 <OS0PR01MB5922109B263B7FDBB02E33B986B49@OS0PR01MB5922.jpnprd01.prod.outlook.com>
 <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
In-Reply-To: <57dbab90-6f2c-40f5-2b73-43c1ee2c6e06@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bp.renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8ca329e3-4ef5-46e2-cc0b-08d98bdc9ef9
x-ms-traffictypediagnostic: OS3PR01MB5960:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <OS3PR01MB59605A0C197911C544813ABC86B49@OS3PR01MB5960.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2582;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4AvwyOLt0IbxcqMcB1bn2jQm7yYOzBtdPQVPa+4QoOf/pI9ss9gSBNi8ifWoYAB0dMNkunGAS4a3ZMXbaCQ3pK/JqEXw7GPZcW2NXpMTmaCqSCkGxgF4xN9HHFqtODHH6CUcQzlV43D3xRt3hZKD4r17m2Y/eHm01lqWmWCJoh4xdMzBZExtSTJVpU2VIicsAg3dfD9Jxc5O5YyY1CxwRbAERMngR5QSvpmWNTOIqoC4rkyJDBAjICdB/TPBZAlvNQ1hSqoGigBtbwBDD3TU5ZaExIRsqqMA6fSsePgBI1erOWrv49kYt0D7kv84wxO/KMwg4R5EDdiCvRxZDrK2AMBznqrpDfmK2IbOkzr/T+KZ6bL8UanvMnI1C49KMn8CuKL4TKb9CJNoUZLoeyC30YiyEwlIGmnwyAN5KOo4DqUkqn2ZXXRhNADJeC9W+VzjKggf09BWQA3Ml1I+hHV+SOrbO9AJFS/OcpX34reHpIG+OFimqhz30e3wlM/OI/7cIDWIOrsNA9Wylx0/YIMOrbZvGBHXa2GBjjQ56DjKtjPMKL9GlqMRtKGpXYlpVOOj/pFUT1Vls87kb+hv3BOp7AfKwDFG+IWDdlmytB4nF/f60o2P8sI3AqjVyxH2gcko+bLexwgNLGJjJnQQA84Hmdjb0V1119iWRxapod1St5Pgk2BsHFPyn2VyN8bSJlREuEwlPoS5OeZiU0eiMhrsVg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:OS0PR01MB5922.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(52536014)(71200400001)(15650500001)(53546011)(38070700005)(55016002)(6506007)(122000001)(86362001)(316002)(38100700002)(110136005)(7416002)(33656002)(7696005)(2906002)(9686003)(8676002)(4326008)(8936002)(66446008)(76116006)(66476007)(64756008)(66556008)(508600001)(54906003)(5660300002)(26005)(186003)(66946007)(107886003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z2pONC9ENmhmWUoxK3NETkZLQis2UnVwc0x0UlZDM295N2VFTWwrR3k3L2V5?=
 =?utf-8?B?YkRBQkdaYXFLYXNXdk0rMnhweEpuVXFzZUpWcVdBZXNWUzlhRjlkRXVRdFl6?=
 =?utf-8?B?SThKbHE4QWt0UVN5V2hsNEowUHhtdnZpTCsxaXJQaGF0MEJwSXpodHNxRENl?=
 =?utf-8?B?Vmo2NkZLWEJtdTgwQU5wNC8yUERlMlR3U090TmVORTdObDdLUWtzTVhvekpa?=
 =?utf-8?B?NzlDTi9iK3BXS2VBclV2QTJVeWN2cy9SSnJMSHFOaENVbEVlUGZkeUFRc3ZX?=
 =?utf-8?B?TnlDMTZnTjREZzJUUkZYS3BKMmd1UG40RGxUK1RPakorbU5COFRGd2oxc1Vh?=
 =?utf-8?B?Zm9qMkRQc09oSGVqR2FWWVhIYlpBSVFoQXNGSm96V1ZvSzQ5ZGM5VG1pRkhi?=
 =?utf-8?B?NGlzb2ZPa2Q1SGNmNjE4dFJobTN3WXlYVUlzWlVGajNkRDdXdlRtd29zeUc3?=
 =?utf-8?B?T3V4emt0RUpjbVNlU1lpVk9VL1RFQmo1NEgwVE1EQ3BiUkQzeEk5L2o5Q0tq?=
 =?utf-8?B?OWZnQ1Q0NXFuYU0vaUlKaW5XMHI2bW5yMGpvS1dxVmlDU1RGUnY5V05BODht?=
 =?utf-8?B?elF3bFpDWWpPcFhxd3psNEZYVVkvQjdYMDd3cDlOWkIrS2I2c1lzY28zbFN5?=
 =?utf-8?B?eFphamJQdkRVQ3Qzemw2bmhYWDYzNGpKbFcxR29pWHhkajc5SzhBK1dRYkU5?=
 =?utf-8?B?YkI1ZlhaUi9TMEdQWDR6WmVWS0FXNXg5UnVHejRSeTY0bUdJRVYweXhkcERD?=
 =?utf-8?B?RTVDRXVPU3g1UHJmNnpqZ3ZvL09xY0dyZG4wZWJ5WWFlQm1VTk9ZMFl3cHRN?=
 =?utf-8?B?SVhhMTg5dEFxUjVyS0ZwNU9qSnRzaldLUlh2OWVHVmQ0eElJS2FjengrTG9x?=
 =?utf-8?B?b1NTaDJtaytPc3AvNCt0RjhIa1dYTnRnT21JZC9jbDYzbWRiZytqUktXdUxU?=
 =?utf-8?B?SHV2aXdoZXQxYWhUaEFYaEhYbHBoNW8vK29OR1EybXI3clFPTTNDZUdhSTlu?=
 =?utf-8?B?dDFBNzBOM0prMjlzSmZLM2hqaUQ5Mzd2eXlwMzZqc2pYVCs2Qis5NlJzNlNM?=
 =?utf-8?B?OFp1dlRIYXRKZVlrZmxkY1Z2WDFqS2xUbHIvVENVRWNncE9sbitESHJLZ3po?=
 =?utf-8?B?M2I5MjJHNktGY3pzRDBzMUFZUERyM3EvTGxUMHN2WXF2LzNoUXY5VmJ0ZkFx?=
 =?utf-8?B?OVE0bFdVeWJLUGVraUg2UmVUVkZ1UmhraUdZczJXeUxnaTFTSDQ5QUcxek9O?=
 =?utf-8?B?eGlGb002cGFuc1NncEFNcVEweGVzQ2lsdSsyTGNhTG4rcisvdTJ1cVVVWVha?=
 =?utf-8?B?UlFWS0Z5a2J1Uk1Na0JuSWxJc2FNRWdnWTZmTHFtcnRhWGN1b1pVZnEyZEE3?=
 =?utf-8?B?MkYwQXJoaE1WZzJ5VDR4YWFEc29hbkJaMDNpenZNY3d0b0pzQXc3NWJETWdG?=
 =?utf-8?B?TW5vWVJ1U1UvL0dOUzR6b3JaY0FMT0tFL2EyOEJGa3BvWmplT256bkFmdGcy?=
 =?utf-8?B?aTRNa21FTitLa0I1c085RGxzdUo2eExROSs2MzYvb0hjUkVZbUU2TDFqRXB6?=
 =?utf-8?B?OHlqWlB2SDVENmNJYWp3cTVUQ3NrZCtpaVdNWGt4SEp3WHk5cWVQV3lnOHFT?=
 =?utf-8?B?b1paODN0TS9pRDBwRlhsQWs0RDhlb2NzRXVxdXZwMDloK1ZpeWkxb01ZQVZC?=
 =?utf-8?B?NTA1cWh3bVFtZ3FVVnBQNU10SWVJbGJXR0xpd24xR2J2RllacEJEVVRTS2JW?=
 =?utf-8?Q?BPXjbKL5vArTpU9UCc=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bp.renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: OS0PR01MB5922.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ca329e3-4ef5-46e2-cc0b-08d98bdc9ef9
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2021 10:56:32.1372
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FjfnFTVj6UEQJHcufd5NUwd4/GNgbmQimfrJ2M8YYD7TqMCcphbhKBWmWRUaDAYmwMZMV8GSgQG/KL5z8st3j+MPNBEfGhfw99RX+OTN6KE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OS3PR01MB5960
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2VyZ2VpIFNodHlseW92
IDxzZXJnZWkuc2h0eWx5b3ZAZ21haWwuY29tPg0KPiBTZW50OiAxMCBPY3RvYmVyIDIwMjEgMTA6
NDkNCj4gVG86IEJpanUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT47IERhdmlkIFMu
IE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViIEtpY2luc2tpIDxrdWJhQGtl
cm5lbC5vcmc+DQo+IENjOiBTZXJnZXkgU2h0eWx5b3YgPHMuc2h0eWx5b3ZAb21wLnJ1PjsgR2Vl
cnQgVXl0dGVyaG9ldmVuDQo+IDxnZWVydCtyZW5lc2FzQGdsaWRlci5iZT47IFNlcmdleSBTaHR5
bHlvdiA8cy5zaHR5bHlvdkBvbXBydXNzaWEucnU+OyBBZGFtDQo+IEZvcmQgPGFmb3JkMTczQGdt
YWlsLmNvbT47IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IFl1dXN1a2UgQXNoaXp1a2EN
Cj4gPGFzaGlkdWthQGZ1aml0c3UuY29tPjsgWW9zaGloaXJvIFNoaW1vZGENCj4gPHlvc2hpaGly
by5zaGltb2RhLnVoQHJlbmVzYXMuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgbGludXgt
cmVuZXNhcy0NCj4gc29jQHZnZXIua2VybmVsLm9yZzsgQ2hyaXMgUGF0ZXJzb24gPENocmlzLlBh
dGVyc29uMkByZW5lc2FzLmNvbT47IEJpanUNCj4gRGFzIDxiaWp1LmRhc0BicC5yZW5lc2FzLmNv
bT47IFByYWJoYWthciBNYWhhZGV2IExhZCA8cHJhYmhha2FyLm1haGFkZXYtDQo+IGxhZC5yakBi
cC5yZW5lc2FzLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MiAxMy8xNF0g
cmF2YjogVXBkYXRlIEVNQUMgY29uZmlndXJhdGlvbg0KPiBtb2RlIGNvbW1lbnQNCj4gDQo+IE9u
IDEwLjEwLjIwMjEgMTI6MzcsIEJpanUgRGFzIHdyb3RlOg0KPiA+IEhpIFNlcmdleSwNCj4gPg0K
PiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBTZXJnZWkgU2h0eWx5
b3YgPHNlcmdlaS5zaHR5bHlvdkBnbWFpbC5jb20+DQo+ID4+IFNlbnQ6IDEwIE9jdG9iZXIgMjAy
MSAxMDoyOA0KPiA+PiBUbzogQmlqdSBEYXMgPGJpanUuZGFzLmp6QGJwLnJlbmVzYXMuY29tPjsg
RGF2aWQgUy4gTWlsbGVyDQo+ID4+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5z
a2kgPGt1YmFAa2VybmVsLm9yZz4NCj4gPj4gQ2M6IFNlcmdleSBTaHR5bHlvdiA8cy5zaHR5bHlv
dkBvbXAucnU+OyBHZWVydCBVeXR0ZXJob2V2ZW4NCj4gPj4gPGdlZXJ0K3JlbmVzYXNAZ2xpZGVy
LmJlPjsgU2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcHJ1c3NpYS5ydT47DQo+ID4+IEFk
YW0gRm9yZCA8YWZvcmQxNzNAZ21haWwuY29tPjsgQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNo
PjsgWXV1c3VrZQ0KPiA+PiBBc2hpenVrYSA8YXNoaWR1a2FAZnVqaXRzdS5jb20+OyBZb3NoaWhp
cm8gU2hpbW9kYQ0KPiA+PiA8eW9zaGloaXJvLnNoaW1vZGEudWhAcmVuZXNhcy5jb20+OyBuZXRk
ZXZAdmdlci5rZXJuZWwub3JnOw0KPiA+PiBsaW51eC1yZW5lc2FzLSBzb2NAdmdlci5rZXJuZWwu
b3JnOyBDaHJpcyBQYXRlcnNvbg0KPiA+PiA8Q2hyaXMuUGF0ZXJzb24yQHJlbmVzYXMuY29tPjsg
QmlqdSBEYXMgPGJpanUuZGFzQGJwLnJlbmVzYXMuY29tPjsNCj4gPj4gUHJhYmhha2FyIE1haGFk
ZXYgTGFkIDxwcmFiaGFrYXIubWFoYWRldi0gbGFkLnJqQGJwLnJlbmVzYXMuY29tPg0KPiA+PiBT
dWJqZWN0OiBSZTogW1BBVENIIG5ldC1uZXh0IHYyIDEzLzE0XSByYXZiOiBVcGRhdGUgRU1BQw0K
PiA+PiBjb25maWd1cmF0aW9uIG1vZGUgY29tbWVudA0KPiA+Pg0KPiA+PiBPbiAxMC4xMC4yMDIx
IDEwOjI5LCBCaWp1IERhcyB3cm90ZToNCj4gPj4NCj4gPj4+IFVwZGF0ZSBFTUFDIGNvbmZpZ3Vy
YXRpb24gbW9kZSBjb21tZW50IGZyb20gIlBBVVNFIHByb2hpYml0aW9uIg0KPiA+Pj4gdG8gIkVN
QUMgTW9kZTogUEFVU0UgcHJvaGliaXRpb247IER1cGxleDsgVFg7IFJYOyBDUkMgUGFzcyBUaHJv
dWdoOw0KPiA+Pj4gUHJvbWlzY3VvdXMiLg0KPiA+Pj4NCj4gPj4+IFNpZ25lZC1vZmYtYnk6IEJp
anUgRGFzIDxiaWp1LmRhcy5qekBicC5yZW5lc2FzLmNvbT4NCj4gPj4+IFN1Z2dlc3RlZC1ieTog
U2VyZ2V5IFNodHlseW92IDxzLnNodHlseW92QG9tcC5ydT4NCj4gPj4+IC0tLQ0KPiA+Pj4gdjEt
PnYyOg0KPiA+Pj4gICAgKiBObyBjaGFuZ2UNCj4gPj4+IFYxOg0KPiA+Pj4gICAgKiBOZXcgcGF0
Y2guDQo+ID4+PiAtLS0NCj4gPj4+ICAgIGRyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2
Yl9tYWluLmMgfCAyICstDQo+ID4+PiAgICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyks
IDEgZGVsZXRpb24oLSkNCj4gPj4+DQo+ID4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvcmVuZXNhcy9yYXZiX21haW4uYw0KPiA+Pj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9y
ZW5lc2FzL3JhdmJfbWFpbi5jDQo+ID4+PiBpbmRleCA5YTc3MGEwNWMwMTcuLmI3OGFjYTIzNWMz
NyAxMDA2NDQNCj4gPj4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9t
YWluLmMNCj4gPj4+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3JlbmVzYXMvcmF2Yl9tYWlu
LmMNCj4gPj4+IEBAIC01MTksNyArNTE5LDcgQEAgc3RhdGljIHZvaWQgcmF2Yl9lbWFjX2luaXRf
Z2JldGgoc3RydWN0DQo+ID4+PiBuZXRfZGV2aWNlDQo+ID4+ICpuZGV2KQ0KPiA+Pj4gICAgCS8q
IFJlY2VpdmUgZnJhbWUgbGltaXQgc2V0IHJlZ2lzdGVyICovDQo+ID4+PiAgICAJcmF2Yl93cml0
ZShuZGV2LCBHQkVUSF9SWF9CVUZGX01BWCArIEVUSF9GQ1NfTEVOLCBSRkxSKTsNCj4gPj4+DQo+
ID4+PiAtCS8qIFBBVVNFIHByb2hpYml0aW9uICovDQo+ID4+PiArCS8qIEVNQUMgTW9kZTogUEFV
U0UgcHJvaGliaXRpb247IER1cGxleDsgVFg7IFJYOyBDUkMgUGFzcyBUaHJvdWdoOw0KPiA+Pj4g
K1Byb21pc2N1b3VzICovDQo+ID4+DQo+ID4+ICAgICAgUHJvbWlzY3VvdXMgbW9kZSwgcmVhbGx5
PyBXaHk/IQ0KPiA+DQo+ID4gVGhpcyBpcyBUT0UgcmVsYXRlZCwNCg0KSSBtZWFudCB0aGUgY29u
dGV4dCBoZXJlIGlzIFRPRSByZWdpc3RlciByZWxhdGVkLiBUaGF0IGlzIHdoYXQgSSBtZWFudC4N
Cg0KPiANCj4gICAgIFRoZSBwcm9taXNjdW91cyBtb2RlIGlzIHN1cHBvcnRlZCBieSBfYWxsXyBF
dGhlcm5ldCBjb250cm9sbGVycywgSQ0KPiB0aGluay4NCj4gDQo+ID4gYW5kIGlzIHJlY29tbWVu
ZGF0aW9uIGZyb20gQlNQIHRlYW0uDQo+IA0KPiAgICAgT24gd2hhdCBncm91bmRzPw0KDQpUaGUg
cmVmZXJlbmNlIGltcGxlbWVudGF0aW9uIGhhcyB0aGlzIG9uLiBBbnkgd2F5IGl0IGlzIGdvb2Qg
Y2F0Y2guIA0KSSB3aWxsIHR1cm4gaXQgb2ZmIGFuZCBjaGVjay4NCg0KYnkgbG9va2luZyBhdCB0
aGUgUkogTEVEJ3MgdGhlcmUgaXMgbm90IG11Y2ggYWN0aXZpdHkgYW5kIHBhY2tldCBzdGF0aXN0
aWNzIGFsc28gc2hvdyBub3QgbXVjaCBhY3Rpdml0eSBieSBkZWZhdWx0Lg0KDQpIb3cgY2FuIHdl
IGNoZWNrLCBpdCBpcyBvdmVybG9hZGluZyB0aGUgY29udHJvbGxlcj8gU28gdGhhdCBJIGNhbiBj
b21wYXJlIHdpdGggYW5kIHdpdGhvdXQgdGhpcyBzZXR0aW5nDQoNCj4gDQo+ID4gSWYgeW91IHRo
aW5rIGl0IGlzIHdyb25nLg0KPiA+IEkgY2FuIHRha2UgdGhpcyBvdXQuIFBsZWFzZSBsZXQgbWUg
a25vdy4gQ3VycmVudGx5IHRoZSBib2FyZCBpcyBib290aW5nDQo+IGFuZCBldmVyeXRoaW5nIHdv
cmtzIHdpdGhvdXQgaXNzdWVzLg0KPiANCj4gICAgIFBsZWFzZSBkbyB0YWtlIGl0IG91dC4gSXQn
bGwgbmVlZGxlc3NseSBvdmVybG9hZCB0aGUgY29udHJvbGxlciB3aGVuDQo+IHRoZXJlJ3MgbXVj
aCB0cmFmZmljIG9uIHRoZSBsb2NhbCBuZXR3b3JrLg0KDQoNCkkgY2FuIHNlZSBtdWNoIGFjdGl2
aXR5IG9ubHkgb24gUko0NSBMRUQncyB3aGVuIEkgY2FsbCB0Y3BkdW1wIG9yIGJ5IHNldHRpbmcg
SVAgbGluayBzZXQgZXRoMCBwcm9taXNjIG9uLg0KT3RoZXJ3aXNlIHRoZXJlIGlzIG5vIHRyYWZm
aWMgYXQgYWxsLg0KDQpSZWdhcmRzLA0KQmlqdQ0KDQo+IA0KPiA+IFRoZSBtZWFuaW5nIG9mIHBy
b21pc2N1b3VzIGluIEgvVyBtYW51YWwgYXMgZm9sbG93cy4NCj4gDQo+ICAgICBJIGtub3cgd2hh
dCB0aGUgcHJvbWlzY3VvdXMgbW9kZSBpcy4gOi0pDQo+ICAgICBJdCdzIG5lZWRlZCBieSB0aGlu
Z3MgbGlrZSAndGNwZHVtcCcgYW5kIG5vcm1hbGx5IHNob2lsZCBiZSBvZmYuDQo+IA0KPiA+IFBy
b21pc2N1b3VzIE1vZGUNCj4gPiAxOiBBbGwgdGhlIGZyYW1lcyBleGNlcHQgZm9yIFBBVVNFIGZy
YW1lIGFyZSByZWNlaXZlZC4gU2VsZi1hZGRyZXNzZWQNCj4gPiB1bmljYXN0LCBkaWZmZXJlbnQg
YWRkcmVzcyB1bmljYXN0LCBtdWx0aWNhc3QsIGFuZCBicm9hZGNhc3QgZnJhbWVzDQo+ID4gYXJl
IGFsbCB0cmFuc2ZlcnJlZCB0byBUT0UuIFBBVVNFIGZyYW1lIHJlY2VwdGlvbiBpcyBjb250cm9s
bGVkIGJ5IFBGUg0KPiBiaXQuDQo+ID4gMDogU2VsZi1hZGRyZXNzZWQgdW5pY2FzdCwgbXVsdGlj
YXN0LCBhbmQgYnJvYWRjYXN0IGZyYW1lcyBhcmUNCj4gPiByZWNlaXZlZCwgdGhlbiB0cmFuc2Zl
cnJlZCB0byBUT0UuDQoNCg0KDQo+ID4NCj4gPiBSZWdhcmRzLA0KPiA+IEJpanUNCj4gDQo+IE1C
UiwgU2VyZ2V5DQo=
