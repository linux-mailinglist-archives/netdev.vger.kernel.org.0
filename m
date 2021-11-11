Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6065B44D715
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 14:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbhKKNVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 08:21:48 -0500
Received: from mail-eopbgr40139.outbound.protection.outlook.com ([40.107.4.139]:65510
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232033AbhKKNVk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 08:21:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iJZEj1/zgLtU5ZoLPC3arPT60KxLXg66VR1eFtytOlstdcfOoBBwiHsex18d6OjdSLssyqNjYPIn4vdpRUPaPr7SCQqmViK2g2RTszs6ClXLRyaJAt9KzU6KAwecqSv6IDVxL/YZU5xE++xtBdH3tCDTrYkXLVykgVo22rY2/pBd7AbdsFjRxYk97HINJVF8ZbypUOEM6GU1YWv/O1BRjM4oqsybWEodjtkA0X7UEbcHgGSTcbL/Gc11JZTWD9hBxOVZl2+8qYMV4gAvYKB66MfZUw5Vb9yNYUOW4h33O4pwp640geo0DO17Pb0TUdIlK0VYWEu8URB+UXgK3Vz71Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Do+Zf4OOq35PQE+gxCJusT6bnXqIFhmle2p+jmUW79U=;
 b=MQ+93hbYnjuEEeSaKbQT2nZGMxQ7HK6vLuIlkxX6WChfV3V9rzIx2b8NPWJXrpJVqjm54c59LyBVAhCawjo/7jP2C3GBY+1/oXdNAxg+hdrLQnv2zJNiJ7qohTfyP10b9fACE1OiQmf5Mz26dlStdMvEKG6NwFZDFkKDVQ7iU0N6d+IIeVxrsL5Z0K7l2z/3wqwS6sDjaIv3++fRwrxCFJM6BXN6dxLtHdTd1IC+oKzXMlDtyXBZY7b0EjzPhkhNIkG0NrYyMTO5n8mt2KVdFlXbJq0ocN0KW4Yni8kKw+VOcs71Xh6xVDEzCAc3mgbihF7roZNo5fACfakm3BbXdw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Do+Zf4OOq35PQE+gxCJusT6bnXqIFhmle2p+jmUW79U=;
 b=kaDnCp7Tozk6K/71cPbe7qGYerkrQvbAHA2Kp3M0DiHntZilZyDVAe7diDvz+kh4nlcHrCLtrCp3Ui2Y+efmR6yPHiQS59MIhfNG8ILp1HRurwPocnaygfK7J8ptrZ9ak+MnGmjjkKeN5urSBBixADtTpFlcm1HPT0AQUAPwJ5o=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB3592.eurprd03.prod.outlook.com (2603:10a6:209:34::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4669.18; Thu, 11 Nov
 2021 13:18:50 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5970:5e76:6869:ecc]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::5970:5e76:6869:ecc%6]) with mapi id 15.20.4669.016; Thu, 11 Nov 2021
 13:18:50 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: [RFC PATCH net-next 1/6] net: dsa: make dp->bridge_num one-based
Thread-Topic: [RFC PATCH net-next 1/6] net: dsa: make dp->bridge_num one-based
Thread-Index: AQHXyoZIv49lCrL2KEivRROk+Vty+Kv+WS0AgAAFyACAAAlSgA==
Date:   Thu, 11 Nov 2021 13:18:50 +0000
Message-ID: <59260c46-0dcb-7288-4186-3e20e847dc6a@bang-olufsen.dk>
References: <20211026162625.1385035-1-vladimir.oltean@nxp.com>
 <20211026162625.1385035-2-vladimir.oltean@nxp.com>
 <a84ee210-b695-c352-8802-5b982d4037d5@bang-olufsen.dk>
 <20211111124528.2tecc3hoslheswl3@skbuf>
In-Reply-To: <20211111124528.2tecc3hoslheswl3@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e92764ab-38e4-4305-c69b-08d9a515cd14
x-ms-traffictypediagnostic: AM6PR03MB3592:
x-microsoft-antispam-prvs: <AM6PR03MB3592026569BAF835B1B018E883949@AM6PR03MB3592.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XC3q7xKiiOiWIaSa4efocsZzHiPqaClZKWpATkZD4dS3im091H4qatgY8Ua2hlVGMMXfw67WXpZq8x2VHBUd4UbxG4SrRH8q0lrLW7YR6a8bHSk7fCJ0zb57LrCCsmwLzq0+PomXsCV3NQJMrVKzfAYSPLYKRzjH5PKKtPDwDNz3AyPhBxZPmNU/BhCGnhKG5k/lYinBDBgXm0mnTEpfod0hp5xmaNkLzWpmgqQqYAnHp9fDXPppUYANFkhP8a55ZuTu5xjVluZZSygG4PJrvUefCpWraPlUZtjeb+c8xoolenSISQvkm45x1DxvYKsy0GDZ2837yeN6Z1rMkThuItLGtaRMDizsQTnaddZvRZdjHiQOJz+K4+qrjrGcuYE9IpwuMC252kxsT1WOxgxmGGDHEAxdSVj7v1UXN3XVNSERLPdEKnYq3nI942varVW4ArWNaodFFK5vw6ai4ijzCmTV1m4BPcI4V+H+P9QrRhrh2F6JR5jp0ufxIzuxse/n6F/NvKxaTZjzoPM2lYxTGEGc/7cuI5Rqubsafjr7FPN3PaRahdrZyah30Zst59g/lPPlvAL9axrGLCnOyUzjH+w2gxlMUoUbPzDQQqOkxCxG9vO3RfylRg1OU7maRGhOMOsEHIkbB4oCO5fxhMoqkW6NUZPw+eZhSWNyQx/kd5Gi/OdX9TvxdPTOSzyFXwUJ+YvBPYo8B/+IDdKHV1I9xvkSoVFGDZwl7Fr6sGKd29Z/DqF6L4Co6uNk3cKKKhRq/iSC86IyKNH/DjcKUDdXlg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(83380400001)(36756003)(31696002)(4326008)(6506007)(53546011)(66574015)(5660300002)(6512007)(8676002)(2616005)(91956017)(2906002)(76116006)(186003)(6916009)(6486002)(8936002)(66446008)(66946007)(66476007)(8976002)(85202003)(86362001)(31686004)(508600001)(26005)(66556008)(64756008)(38070700005)(85182001)(54906003)(122000001)(71200400001)(38100700002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Y3Z6Y0dUbm5zZXByQWM1WGxaQWtaVlN2ZDZEYTZ2emtpVzhjZ1Z5UEFHN3U2?=
 =?utf-8?B?U2huVit3VVk5L05sQ01Ib0tIT3ozUVc2RGxyTldpV1ZTZkJCbVN3elorMGlT?=
 =?utf-8?B?UGl0ajBjMCtMNmdMMHl2cFVFbWZodEFZNnVJeFNaNGRxdnBHQlVTQzQvQVBP?=
 =?utf-8?B?NFFOWjRkQzJZaXJ2Um5JSm5YR1dQekpBM0pjNVkvQ1N6MjM5emFzQTBwTjRN?=
 =?utf-8?B?UDlBUGJTaXpXc3NyUFBLaExqaWxGK2FJNG82SkFWVmZsWVcyMDBXYW01RjYr?=
 =?utf-8?B?bmhZbDczendDK00vcUVYL2FqQjlpOWk5ZjN6STN3dHRKdnZOdFFxdmdhZzhp?=
 =?utf-8?B?WDM4TTNUSFZ6SnBxRHE3RStOQy9XOXdweXJZWms0RWJUWUdVbGExT3pKdjY2?=
 =?utf-8?B?czJENlRpdk5QWHpMRjl1YzhwcVZEamlDMmh1WVhuQ0xvMkZtaVp1Qi9Nci9D?=
 =?utf-8?B?NDVzL2tXRmVTQUdibWFVNklTRmZTNHVYMlJ6VVgyTHNNZ0kzYlZvZWpvUnhJ?=
 =?utf-8?B?U0xFdXI3US8wY01TTHBRcldHc21xUHBjelJzVDllRHljRnI0Zyt4eElpWEdx?=
 =?utf-8?B?SDk5c2ppRElYdS8rR3Y5ZSsybXYvbDQ4RGRuSmVzVGRoZEwvd1JHQlBqbHcw?=
 =?utf-8?B?RXUvY3J4aWpaR1VMc24zdWZJeTZTU29zWlMyY3lFbkloMXJKSEx2THdvb3NM?=
 =?utf-8?B?VC9YcGVWN1Q5SDZudWY4ZlNSZWRSclZVVXpiK2ZMb3NvdWJBcmlCSUJ0ekJi?=
 =?utf-8?B?bEpmS1FGVkN3aUtzU3ZzazZlaU4wbU9WcHRpM0lKbkR0SXk5UE9tV3ZqYmJm?=
 =?utf-8?B?SlJHN2lwNEZ5cXJYVnl5UnNjeFhhYWJ3dS9adndFcURiSDJHekxJa1BybVdW?=
 =?utf-8?B?UkVrUXk0ODZnbVFwbUsvN1QrRkhwazdtVnVFTlZLM3p1WmhKeDJrdWd5TjA5?=
 =?utf-8?B?WDlTZGtnRkIzV0N1V2RnN2JJb1hOQ3l0SXBzRFFrMlZZMi8wTmZkTzNXUmxX?=
 =?utf-8?B?NW5BUXpBNGUvL2NQTGdYUXpSU0hOQm93c3B2SmhPc2VybVBaTHRicWR2aEJ4?=
 =?utf-8?B?T2pFbG4vbEVGK1RnZUNsNERDWmQvRGdTN1dGN1ovaDFYOUFpaTNjREcrTldT?=
 =?utf-8?B?Qkh4K1o2MDdkRDJERzRvSGRUN25KR1FOb0NUZVpJSCt0RWVNRVZWZklWWmpJ?=
 =?utf-8?B?SjNDVXNFdlhyY05ybjZPUW93R28zMDB5YS9jVDFsZ0JtU3UvMFhZc0UrTmlQ?=
 =?utf-8?B?YnpTWHBXYXhIM2FLNkFMeWFGdTkrdGhFbFh0ZU0yR2ozY2dhaTZtZyt0YmFY?=
 =?utf-8?B?UGlZYk9jMWE4RUdkQUZMZG41cnpMcm9tcWx1QmVReWxxTk12bzdicTVXZk1s?=
 =?utf-8?B?Yk1WdTc3c1RQK2Q2Q0IyajNoVVRoSGlOSVRVcGUrYUx1M0Z4SDYyUU9Ccy84?=
 =?utf-8?B?UXhBVzR2OWJpRDhXZUhYNVhiVDNyRm0raWp6eFZRL1dwTHhST1hKU3daeVdB?=
 =?utf-8?B?UWN2dllBaExkSUNyUm02L1J3WEcvNThXbmtCcXB5MnVkckZBWHFEYlhraFdP?=
 =?utf-8?B?Nzk2UHo1R1NXc1pJUjU0bk1scHdXVWRiUUJUNVhXTXMwSE1raVdyenVqbzJQ?=
 =?utf-8?B?cHV6QnVSbnBMZVRrb3VndldXdnNLZmtTVEh5NXRXdmtaZ2xZbnlobFQxeXp1?=
 =?utf-8?B?aUlKa2dCZXU2VnFiOWo4VTJLNzZTaHpqeGF1Qm1qa3NadHA5UnBMdHE1MmFk?=
 =?utf-8?B?ZGNNT3ptQ1lhQ3hnQXFHd0hpeGNyYWJKZ085NTNoVTBYcEpaT0Fidk4vdmdU?=
 =?utf-8?B?Q1Y0alBvcXF5RWZPems5c1lFdDlGNHRmbUZ4T0pwTy9nUTdLRkpwbDVrbWhU?=
 =?utf-8?B?clBuRk15N20zMmVCRG5NVnh2MEdxaWxKaE1ZdDRueDhRZUZBNWRqU2laTXQy?=
 =?utf-8?B?bW84Y2ZLUEdmTlkyN0RkYWpKUlNWaDl0UFZqUnl6MUZneEt4Y2M4UWszbEVW?=
 =?utf-8?B?M1k5TnVPc0RnZytWVmxaK2FpbEdLTkFBeW9vVlZMaE5oSURyWFk2b3JteHhQ?=
 =?utf-8?B?bVF0U1ByaUo5cW5naDZCZHNCUHhXM1hFTzhlek5PWU9ZWllYTWdwOWxsM1BR?=
 =?utf-8?B?UjdtbWxacWoxNWlXUVVqTnh5Q2s4aGQ0U01oeDFINnp0SXIvZVJJME5lN0Nm?=
 =?utf-8?Q?E9cH+ExaCdFYeX++spONgqk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <22BB0A6E4CCA7B4BB4C1BD7D6AC1FAE5@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e92764ab-38e4-4305-c69b-08d9a515cd14
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2021 13:18:50.2483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x3NMxStfU75n0nsWCPxARBhW/sid/BqTWjbvEGvSa1/7BunPb2U9DZc3tiS3pYizwc3HeUKlsT/DODrtmRZyAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3592
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTEvMTEvMjEgMTM6NDUsIFZsYWRpbWlyIE9sdGVhbiB3cm90ZToNCj4gT24gVGh1LCBOb3Yg
MTEsIDIwMjEgYXQgMTI6MjQ6NDdQTSArMDAwMCwgQWx2aW4gxaBpcHJhZ2Egd3JvdGU6DQo+PiBP
biAxMC8yNi8yMSAxODoyNiwgVmxhZGltaXIgT2x0ZWFuIHdyb3RlOg0KPj4+IEkgaGF2ZSBzZWVu
IHRvbyBtYW55IGJ1Z3MgYWxyZWFkeSBkdWUgdG8gdGhlIGZhY3QgdGhhdCB3ZSBtdXN0IGVuY29k
ZSBhbg0KPj4+IGludmFsaWQgZHAtPmJyaWRnZV9udW0gYXMgYSBuZWdhdGl2ZSB2YWx1ZSwgYmVj
YXVzZSB0aGUgbmF0dXJhbCB0ZW5kZW5jeQ0KPj4+IGlzIHRvIGNoZWNrIHRoYXQgaW52YWxpZCB2
YWx1ZSB1c2luZyAoIWRwLT5icmlkZ2VfbnVtKS4gTGF0ZXN0IGV4YW1wbGUNCj4+PiBjYW4gYmUg
c2VlbiBpbiBjb21taXQgMWJlYzBmMDUwNjJjICgibmV0OiBkc2E6IGZpeCBicmlkZ2VfbnVtIG5v
dA0KPj4+IGdldHRpbmcgY2xlYXJlZCBhZnRlciBwb3J0cyBsZWF2aW5nIHRoZSBicmlkZ2UiKS4N
Cj4+Pg0KPj4+IENvbnZlcnQgdGhlIGV4aXN0aW5nIHVzZXJzIHRvIGFzc3VtZSB0aGF0IGRwLT5i
cmlkZ2VfbnVtID09IDAgaXMgdGhlDQo+Pj4gZW5jb2RpbmcgZm9yIGludmFsaWQsIGFuZCB2YWxp
ZCBicmlkZ2UgbnVtYmVycyBzdGFydCBmcm9tIDEuDQo+Pj4NCj4+PiBTaWduZWQtb2ZmLWJ5OiBW
bGFkaW1pciBPbHRlYW4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPg0KPj4+IC0tLQ0KPj4NCj4+
IFJldmlld2VkLWJ5OiBBbHZpbiDFoGlwcmFnYSA8YWxzaUBiYW5nLW9sdWZzZW4uZGs+DQo+IA0K
PiBUaGFua3MgZm9yIHRoZSByZXZpZXcuDQo+IA0KPj4gU21hbGwgcmVtYXJrIGlubGluZS4NCj4+
DQo+Pj4gLWludCBkc2FfYnJpZGdlX251bV9nZXQoY29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmJy
aWRnZV9kZXYsIGludCBtYXgpDQo+Pj4gK3Vuc2lnbmVkIGludCBkc2FfYnJpZGdlX251bV9nZXQo
Y29uc3Qgc3RydWN0IG5ldF9kZXZpY2UgKmJyaWRnZV9kZXYsIGludCBtYXgpDQo+Pj4gICAgew0K
Pj4+IC0JaW50IGJyaWRnZV9udW0gPSBkc2FfYnJpZGdlX251bV9maW5kKGJyaWRnZV9kZXYpOw0K
Pj4+ICsJdW5zaWduZWQgaW50IGJyaWRnZV9udW0gPSBkc2FfYnJpZGdlX251bV9maW5kKGJyaWRn
ZV9kZXYpOw0KPj4+ICAgIA0KPj4+IC0JaWYgKGJyaWRnZV9udW0gPCAwKSB7DQo+Pj4gKwlpZiAo
IWJyaWRnZV9udW0pIHsNCj4+PiAgICAJCS8qIEZpcnN0IHBvcnQgdGhhdCBvZmZsb2FkcyBUWCBm
b3J3YXJkaW5nIGZvciB0aGlzIGJyaWRnZSAqLw0KPj4NCj4+IFBlcmhhcHMgeW91IHdhbnQgdG8g
dXBkYXRlIHRoaXMgY29tbWVudCBpbiBwYXRjaCAyLzYsIHNpbmNlIGJyaWRnZV9udW0NCj4+IGlz
IG5vIGxvbmdlciBqdXN0IGFib3V0IFRYIGZvcndhcmRpbmcgb2ZmbG9hZC4NCj4+DQo+Pj4gLQkJ
YnJpZGdlX251bSA9IGZpbmRfZmlyc3RfemVyb19iaXQoJmRzYV9md2Rfb2ZmbG9hZGluZ19icmlk
Z2VzLA0KPj4+IC0JCQkJCQkgRFNBX01BWF9OVU1fT0ZGTE9BRElOR19CUklER0VTKTsNCj4+PiAr
CQlicmlkZ2VfbnVtID0gZmluZF9uZXh0X3plcm9fYml0KCZkc2FfZndkX29mZmxvYWRpbmdfYnJp
ZGdlcywNCj4+PiArCQkJCQkJRFNBX01BWF9OVU1fT0ZGTE9BRElOR19CUklER0VTLA0KPj4+ICsJ
CQkJCQkxKTsNCj4gDQo+IEkgd2lsbCB1cGRhdGUgdGhpcyBjb21tZW50IGluIHBhdGNoIDIgdG8g
c2F5ICJGaXJzdCBwb3J0IHRoYXQgcmVxdWVzdHMNCj4gRkRCIGlzb2xhdGlvbiBvciBUWCBmb3J3
YXJkaW5nIG9mZmxvYWQgZm9yIHRoaXMgYnJpZGdlIi4gU291bmRzIG9rPw0KPiANCg0KWWVzIHNv
dW5kcyBnb29kIC0gdGhhdCdzIGFsc28gd2hhdCBJIGhhZCBpbiBtaW5kLg==
