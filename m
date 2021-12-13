Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D50C473401
	for <lists+netdev@lfdr.de>; Mon, 13 Dec 2021 19:29:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241887AbhLMS3n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Dec 2021 13:29:43 -0500
Received: from mail-co1nam11on2060.outbound.protection.outlook.com ([40.107.220.60]:8544
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S241876AbhLMS3k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Dec 2021 13:29:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OXp0wcRCrX+UGK/n8D2HJ2V20pPLxueTXV7ke3UgAGxa4uPYjEoUxaY1M4O8Em+9++n+G7VA8KvN26Xf0aKo3V3iQZtc99klnRDsC1NHATe5wkmIbWRX3XD5MO4c4XQhubspBb5zoFRtw6noxPn3M6WDlcmVibeyhw4Xp0pu6HcvDbgEAcbM96jyu/HrOOrFwMrbNYjcXcJvI7IX0g9uU4V2LXwha24JN4ReCwEYzM2RRHRUXlyHqBEkwu2XQXWUxoyyjSGUKaVXM9yTIQ3wg7VkOoVfdNWsc9EbWPZWFhY+lkS2dATR0+oc0c7EI2P2jszDSamoKq5ZIWttw1yF8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0mQbGgdEBvAotAzJbqr9/XLBSVf2cSYw4/6StnVPzn8=;
 b=bASDTp9CN8I54JCqzLeLhF5yleZU/X180Zng8T0bxlBqa3AMe3rbNtNjCO2Sm6AjQEYmJ+4qfDGyKLeNsB00MgoOZ6TdUVqvUr5PeikwaUixqyZ5fpDGyxJX4XssuNcTgX0NaiT8jwE0QxtRDlIgaR1tOKARiP2/3gufyKcnWbqUkpK1ua8OCJ8t7fkjhkvbuhxsilIYffEMBYQp3fhiinIiqFiJPLoXBfw+Ov8lyK/mLnIVX2K5PXEFPIQwyh6dyXtK1FeOTJw9yr9zzp1bsCAdOOUaq3hPSCdnpTr2UDQ/MMhBi9eFThzhETvbM51FZFektkU6FVeFULv6XOPL7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0mQbGgdEBvAotAzJbqr9/XLBSVf2cSYw4/6StnVPzn8=;
 b=JkVr5vbcu0CGmRUAVBr0+9z1AjOGO2ZgfC1mTLtEjZrhs1FTZbM0mlhbSWh3aCHN5B24r9ro/OQw0VpOIcF3tPQDjt2a2U2B2/+9uhG2AU9Q6nSqKmcac4D0tagB9zR93jDAkC117e37Iy0r6noETqjf69W1m2oIXogSgXiQn/yK5/WPVvEp6YxNYEEcWew964uP0atbBr2LeqaAzaJs+nMC9bqi5ezghVOaKxpWM9nVixEG9SQkt96d3NMCvROufCUAcTrpuarLo09c+ih9r5ZkcbfEE0utucqP5nAb+Kbz+ZLq+hIDSjrvjB15+ookYFviSlJW5rRwA/KjPk1kXQ==
Received: from BY5PR12MB4209.namprd12.prod.outlook.com (2603:10b6:a03:20d::22)
 by BYAPR12MB4711.namprd12.prod.outlook.com (2603:10b6:a03:95::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4778.17; Mon, 13 Dec
 2021 18:29:39 +0000
Received: from BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2]) by BY5PR12MB4209.namprd12.prod.outlook.com
 ([fe80::940f:31b5:a2c:92f2%7]) with mapi id 15.20.4778.017; Mon, 13 Dec 2021
 18:29:39 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     "zhangshaokun@hisilicon.com" <zhangshaokun@hisilicon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH] net/mlx5: Remove the repeated declaration
Thread-Topic: [PATCH] net/mlx5: Remove the repeated declaration
Thread-Index: AQHX62bJysasqL3Go0O2NMzcBl+ocawwx/aA
Date:   Mon, 13 Dec 2021 18:29:38 +0000
Message-ID: <729c2e0ab68663db3d2c5a3f596a586c42cc081f.camel@nvidia.com>
References: <20211207123515.61295-1-zhangshaokun@hisilicon.com>
In-Reply-To: <20211207123515.61295-1-zhangshaokun@hisilicon.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.40.4 (3.40.4-2.fc34) 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: dc0a12e5-6def-4e71-f12c-08d9be6685ca
x-ms-traffictypediagnostic: BYAPR12MB4711:EE_
x-microsoft-antispam-prvs: <BYAPR12MB4711484B291D8EB60D6EA71FB3749@BYAPR12MB4711.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FvLvtLK4IS1nTg6rmp1bIKRbWDHRShdw4Gi/h9HphsJL9n5nLf44yt9X00qqPo2FXgAzBUJ8VtQirgEpXUFaA2u+bysi1lrE35inNlnQcl58naokPGKPL4UaEsRcBAh0ZS1mrktBN0agtgkTNb9ZjA9RGn4FKcOMHJjQZxIANL4AFe8HNI2UMYfDXzQNNGb8CnVuAP0TPmaYT84kYb4vqHYlNdDXEfBmFG57r8ZXM/XZRrtUX1DT3uSzt7+zADaAZdTPCSkpQYC2ro+9J7SaaGJlAVGfXy5USaHJ0U0oqqPAwY/aRxtD/2yTC4R7qOsP//uO10XsuwRCw+n2Xav/9+AS5oMrfg1MS/iQwstqWG7l6TCeqgzQR1ZkPq1EQFCJSKQhk2C9Csesx/dFnYNEDiOfWE78tfp2meykypXupFJXMQAtsDkP7kjjED2+z6pQBLUC0uQCIjtv6V8eFLxEo0A/qghbtW1ZmT7ZXsCANjMs3nOZcpZM1L7OPq6zYZUPZMEz1jOTl3X94nLQYhJqM2TojGCqUdIsot/Hxe6vJVftwW1zrs8W3ZYZbjDe8jd7XRkm++DmOoX89oUnDpDn/uFr2JDVZgEdg8ZGmYluk9k1OarJhk7/1yUrcV7u6f29JeUdED/uew56XrH0NWS6X/ZNsBWyjS5Qup25aMf4lJ58ISaEfCOe/Cl8cHCObKYyemlXnJ/i96G2XSw8qXdODQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4209.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66946007)(54906003)(110136005)(4326008)(66476007)(316002)(6506007)(508600001)(71200400001)(76116006)(66556008)(186003)(5660300002)(4744005)(6486002)(66446008)(64756008)(8936002)(8676002)(2616005)(6512007)(86362001)(38070700005)(36756003)(38100700002)(122000001)(2906002)(26005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2R4WVBscXZtM1lGTUtrL3Jybk5RRHN4NHhYTGxBaVExNEc3czR4cXdrUUdD?=
 =?utf-8?B?T1JOWkZBcHRlYzgrSHZsYTFvY1ZPUHhFR054dXZxWm9TM1h1UGJBdllNZ3kw?=
 =?utf-8?B?aWdPdHZEZ1JjVWtXYXJEcGhQYkRrcW12RHJxTDBseUp0M0luNldBOWpNOHQr?=
 =?utf-8?B?U2lLTnBvUVh4ZXNiTFlnTGJjT05rbWl5N0N0ZFZDc2J0S0lsUDJ4NmlMbTlx?=
 =?utf-8?B?V1o5Qk4xR1lYQ2ZUS1ErcWhOZWkvMWtHZTdGeUZvdGhYMUpMNmhBSkc5cERN?=
 =?utf-8?B?R2todCtpUGRyTEZMTDQ0d2VpY0d4eElRWmZKSVVBKzRXTE51NkJ0MzJFTGdO?=
 =?utf-8?B?QXQzanIxb3A5MzVKNTNwM2ZmOElpVDNHeElidWRLUnJ2RnhUc2pKUkxxUDhh?=
 =?utf-8?B?TWlRR24vT2FLTEhQVitMVk55YUFKbDhSVncwTkJ2ZXdiek9vczZDeGtaODZN?=
 =?utf-8?B?bEplNXdJeDZhbVcwMU9LLzBGd3dKSDFWVnJIenJYeEJjekJWL0hob1pOd1Bt?=
 =?utf-8?B?Y0lGTCtlc0FmbEJTRi9xUHAwdTZnY3NZQ3lJN0luV0ZZR3ROdU0wSCt3OTVm?=
 =?utf-8?B?VVRpR2N3d2dZcWIwMVdQOHlHcTF3bG9Vb1R2ZC9GYXdCbElMcTMydnJ0WFFu?=
 =?utf-8?B?d2lvN20veEM4WmlMK2RZNWMwOWhQV3FKaFRla0JvZXVKWnF1bzhob0I3U0oz?=
 =?utf-8?B?QW5lMEtqK3VyUjlFbms3amNpWkNpdFYwNUpGeDRVRDAyZ09GRW90eFNUZ1RS?=
 =?utf-8?B?eUd3VDIxVG81YktnK2ZOOUVJaGxuQkVBR1J1SVhydFhGWDRmWkphS3A0K2sx?=
 =?utf-8?B?L1ZhbTdjbXFWR3lXWlBuRFAyVUVoWmx6a3J0QlpsRXkvNVJMeERVREYzb0Ez?=
 =?utf-8?B?dzkwcEE4U1NMLy9BSnRJUGNyc08wVk85dXFCYlhtU3V6TXdocUgvRTc4Rmpt?=
 =?utf-8?B?ZDMvQjBkNUNJbnBmUUNkTDdLN21MVm4rQVl3V3dlaWlubS94Q0QxMWNqeEF2?=
 =?utf-8?B?Uis0NVVMd25KWUcyalBZQ2J3cTNVVWZpM3VaanFyaDRMNFo2WXhjME1xeklI?=
 =?utf-8?B?L083alJiMkYvSTZteit3SjZZWndVRWtrZFZxVE9BOHpWMWdGc0szNnpMMFdT?=
 =?utf-8?B?Tnh6U2VOaXVvS3JXUGErT1BCYms4QTdpZm1nSkhDZE9Pd2FaTmJNOTJPTndm?=
 =?utf-8?B?M1FiL2dxc2xvMHJFN3FOUWNJWEE0VXkwMkg3ekowTmFvMXV1a3BqcHFBUFda?=
 =?utf-8?B?SldQVnBFTEwyRlhKeS95cVY0VVlBZVdHSUF6Z1hiYm9XNk8zaWd1R1BaY000?=
 =?utf-8?B?a3JKcEs4Sjl1bDE0Mms1SnNldjRvU29vekx3M1FEU3ZMSllRVm8vMG1DSjcv?=
 =?utf-8?B?cEJzZllHQ2hPUXZEamljTTJZRXhBd04yUXYyclFJWGtDK1Izbm53V3VvQ3FO?=
 =?utf-8?B?NTNsYTF5dG1ZMnVXek01aWJKUllKSWRTaTJNOUM4d0R2S2h3OGdqb1VvWC9Q?=
 =?utf-8?B?SDRiazJXbzlYZmJTZWphSERxSmdSNDU2UzhueGNMNW8ydzUrMmIzVTA1eitQ?=
 =?utf-8?B?SldyMUpxM2xHUTg3dU05L1FjZys4ZVJ3bVQ1MVl3UUlLczNLcEQrcUROaG5P?=
 =?utf-8?B?eVZPZHJ1djB3UUo4NnVjL0YrLytMbTdqcWtuaHd1ZXdUR1JUK1FEejExbnQ3?=
 =?utf-8?B?dnJrd05Cd1NWMC82UXlRWlhlS3lmRkhCT0t3NmFxalRXemJPdHEyWW11VmdK?=
 =?utf-8?B?OUZOK2c3bHJnY1g2WEIyNW9iZGl2dmVuVGZqaENZZjJGNi9yWFlGbmhvVEhz?=
 =?utf-8?B?K1BNbE1lTkpnQnZPUHN0dFdXRE4yZFBwY3hEenNhN2VtZHlYRXhOdGdHTU4y?=
 =?utf-8?B?TGsyRXhZd2pIWHBHSGlEWGN2NXZKcUFIN29lcm1rWEZGV2tjeGpiRm1RRGRS?=
 =?utf-8?B?aS9JRWlrTEcrOHhIa0tUVHp0M0QycExKMFFwSkVqWnBLbjNaNC9INmZmQ2lw?=
 =?utf-8?B?RmpvMkRxSGxENnRGRmFpRWhhcUdtS042dlM1aVJJaGc5NzNxYU1IeFNYNWJE?=
 =?utf-8?B?WnV2UCtvVkZOUVVGVDhKUFVFdHUzN0JQR2pteEh6UlBjVExRaVJsZnZvNGJj?=
 =?utf-8?B?YlMzMWhxRE03TTlZQ1JPOUlqa1lFeTRMSUlselVmd0NiZm55OXFnTzFxczVK?=
 =?utf-8?Q?IN9RQ0KAwrPe4HN/o1UWWnE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <884D18369AA4914486A930E18BFEA289@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4209.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc0a12e5-6def-4e71-f12c-08d9be6685ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2021 18:29:38.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4jJpdXPL5agw/SWpGMsaI7bIDdCZxytWVxaNks02jF8chMYHjO2NMMN52KCK99nDIw02mcL9o3Ag9KgEf0XXaQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB4711
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTEyLTA3IGF0IDIwOjM1ICswODAwLCBTaGFva3VuIFpoYW5nIHdyb3RlOg0K
PiBGdW5jdGlvbiAnbWx4NV9lc3dfdnBvcnRfbWF0Y2hfbWV0YWRhdGFfc3VwcG9ydGVkJyBhbmQN
Cj4gJ21seDVfZXN3X29mZmxvYWRzX3Zwb3J0X21ldGFkYXRhX3NldCcgYXJlIGRlY2xhcmVkIHR3
aWNlLCBzbyByZW1vdmUNCj4gdGhlIHJlcGVhdGVkIGRlY2xhcmF0aW9uIGFuZCBibGFuayBsaW5l
Lg0KPiANCj4gQ2M6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbnZpZGlhLmNvbT4NCj4gQ2M6IExl
b24gUm9tYW5vdnNreSA8bGVvbkBrZXJuZWwub3JnPg0KPiBDYzogIkRhdmlkIFMuIE1pbGxlciIg
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQo+IENjOiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwu
b3JnPg0KPiBTaWduZWQtb2ZmLWJ5OiBTaGFva3VuIFpoYW5nIDx6aGFuZ3NoYW9rdW5AaGlzaWxp
Y29uLmNvbT4NCg0KQXBwbGllZCB0byBuZXQtbmV4dC1tbHg1Lg0KVGhhbmtzICENCg0KDQo=
