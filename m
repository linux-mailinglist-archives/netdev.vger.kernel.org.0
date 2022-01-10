Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972984898BB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 13:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245585AbiAJMin (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 07:38:43 -0500
Received: from mail-eopbgr130097.outbound.protection.outlook.com ([40.107.13.97]:1489
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245578AbiAJMik (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 Jan 2022 07:38:40 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hMdG+PVdGcGLcmMDuaaKNDfNbI0Kj3vuMDPTwHQdaJJHujsW9bPAFRcghWijLIXDPoqZBqREcWCt6ZX1V8BJwu968zUvqmFldgXrqN/oSld5hYrqQXkYcFxV+3ae8e9lU8Bb7323rNoCPB6dtYLvS4kQDFIai5+HVHOSubPJBIr9SmK+RtLijcJ+vcO1KDeZqXxzlqsTX33tiz7pOxsrR4F3Rq4wnAre2N/BjEeOzTGbRiWFqZtPPOSp+IOMbR9rQ5es6Y4lWEhdFnpQH06nJbVBgVEkMmieBIHliAz4rpn+Em3kJXxr9kWBgcHFWnA4uW+zcBdYr6aS89P/xvXCZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=se/i0ZtS8B2M8FteRFqZroBQ2ioCLOh2D9lF6f7MSVY=;
 b=FbZxb00lM19+0HVW0uBakDMPUHJVmR/Tx17HSTLsbEEMvya68dHkRptzMR/1Iz2Ww9smWSesIfzoQVjn0LcSkytb9YU90PgDUotp5y1yibnZ0JAVBDGI80xD4ary7y1pmoenZj7oj/w17PzbWjXBHFxONyi39Pwq2OzyY1bHq6/b86kBGnDYsJEoOwnCq7PShpx4LFGXbEcJMub62Ktr4BO0WLhHTGymjfkdO/EzPoRx1kI9FN8IkYAqB7uopjPc8JXDI+6IVoJomhAqck5Ok2qF1j4VS6OX7K++Gl+AVADZvRYAKXu23YfbBRrG6bF4yKtxzlNewfLvqGoRvem9lA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=se/i0ZtS8B2M8FteRFqZroBQ2ioCLOh2D9lF6f7MSVY=;
 b=PBXzb06XeF2WY0LogZDKZsZSTsn9SLXGowk5T0chNPtmxyFIEMTJI8ON+cVS+MgeuzZUcxznWb3Aq8qOsWwM7gRMPHsk43R3cmcpjdXohp8eiRAr9xHajWRoPowULzsFyMAR8aBX/KyYY0eliL9KZWlhxEuCb99VfFXkrrY/zvo=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by AM6PR03MB3813.eurprd03.prod.outlook.com (2603:10a6:20b:18::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4867.10; Mon, 10 Jan
 2022 12:38:36 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::dd50:b902:a4d:312f%5]) with mapi id 15.20.4867.011; Mon, 10 Jan 2022
 12:38:36 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "frank-w@public-files.de" <frank-w@public-files.de>
Subject: Re: [PATCH net-next v4 03/11] net: dsa: realtek: remove direct calls
 to realtek-smi
Thread-Topic: [PATCH net-next v4 03/11] net: dsa: realtek: remove direct calls
 to realtek-smi
Thread-Index: AQHYAeKNTaFznmRN3Umi7rcvQyLodw==
Date:   Mon, 10 Jan 2022 12:38:36 +0000
Message-ID: <87mtk3epf7.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
        <20220105031515.29276-4-luizluca@gmail.com>
In-Reply-To: <20220105031515.29276-4-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Wed, 5 Jan 2022 00:15:07 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ae00e72-f964-4a37-b456-08d9d4361f51
x-ms-traffictypediagnostic: AM6PR03MB3813:EE_
x-microsoft-antispam-prvs: <AM6PR03MB381360B18401FF9FFBA5A90F83509@AM6PR03MB3813.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1107;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BGX1fHBHiRTA404kEu99JBKCfJkDcyLi6AIwNF2ht4de9+Jo6z3HZkxe203dMnnkbqq3Nitv09x90XE85rl9K8rUKY6VdX5NH8mIBUxcoyGeufMrYLcrppTmoWrCLFmQj7MakuPbwgtv/in26PL5NyvJT38a4Q5IIYD80+xfscfnKcn45LIJGmy4OQatfx8W4xY0+3Nr7Mc0A27cV6UFiV7HKhdEFFtKTOIDAeqLkWUn53M0zSf9DBEb9eyKy7D11OaA/quTvKwM8TTVEN7d5Way1IF5EGzDCeMMiyWVRWeRNzO7MHJQDiieNVYgtAmMY525erIhvvkp7os6fI1nkPW/D4zD8rgxpMhS6uHJoA63BW+8MkJorxHe0a+UIS06+r+hx/HY4n81m6VehlLcC7b88X0TqvTDJQiMX5r46785QDhCUfouK3KJPG7jj+fPpJnQql2l/a4WqnB33EXCiV8O5MygjQYBBOCsOaqivnN36BN4EXFYbR6izbX7R9vxOjyEITcFXCD/DNTADTxgrPpLg+up5tHLOMy12hYcCrinzpUrtEUoGlQEfXTjpiYquxHKHiMeoW6nHPzx8qT+SeIr4tT23FjxIRF4vVldHqwabL79witkSf+CvmYSdStIedCubcy8YrbM9+x91DFhL1FNO9GvonJNyP3Qs07JOubD/ep3KnO/b1qmV4s3ADsiM3m24qnKOYLHzq3iThzywg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(66446008)(508600001)(2906002)(64756008)(66556008)(6512007)(4326008)(38070700005)(558084003)(66476007)(86362001)(66946007)(91956017)(85202003)(76116006)(85182001)(71200400001)(5660300002)(54906003)(36756003)(6916009)(8676002)(186003)(26005)(2616005)(8936002)(8976002)(6486002)(122000001)(6506007)(38100700002)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eUxkYTZWK2VNWE9uZ0oxc25jOUU5QTBWNlBnQ2ZaMjJ4L1NxaExXcnM3WnVu?=
 =?utf-8?B?OGxTby85WVhicEFIRjhTQ0Ewc2YwdUxjMFlaK1BES2dEOXMvdXM1Tkp6RXhE?=
 =?utf-8?B?RHBTc2RISnFMdk9DdDlJemtrQ0F0c0gwdkxrS25zVmdOTXRCcWY3QUIzMkp1?=
 =?utf-8?B?elhiL09qdXdqcUU4TThSRzNQSVYyWmt1T1NxNThlSVBLNUplVHhseDJabUxT?=
 =?utf-8?B?cXRZVmltaCsrbllKTUg4SzBHOHQ2eXQzS2VkZzB3WEQ2b0VORlNZTWdwalc1?=
 =?utf-8?B?OHFoTEtOVmRZQ3BzVjVNRXJqZFJTLzdKdmlXdHMyQkNqSVFPeUFzVmkwbEFk?=
 =?utf-8?B?RDNvcHErZFhXWW5YZ1Y4M3ozSjBxSWtvOHUvODJXWnRJQTd2bDdzaWlTSEdl?=
 =?utf-8?B?VVNwZVcxZk5kaUxNdU1HT2g1RUJVeVZnOU8rWU1BOFdlWG9CV3o0SWZxWG03?=
 =?utf-8?B?U2Vka3BZay9zVy94TlJrMTd6dmxUczcweVlzOCs2cEdpL01FYTF2N2tWTUFT?=
 =?utf-8?B?SmprQi9QWjhHV3djSkE1ODFrZTRLUFBBVWFUNzdVZkV2OGJMYnlyUkc2bjVy?=
 =?utf-8?B?OWZSZU1SZnBnVTJKUU5xcy9xWHpOOUtocVI0U3RQazNkWVZLUzFvK01nQW5h?=
 =?utf-8?B?Mm9kUjhEUnQzV2JyRWkxRC8xVTBVY3M5U1BnNFJLVkZkK0p5bjNQL2kzcVJj?=
 =?utf-8?B?Z2Z2ZjdxKzhtMmNvaWZZWEl5V3psMElsVmFjUUtScTFaVE44bnFMUWVnNGVH?=
 =?utf-8?B?cnZXVkZ6aXUvRHNmUWhlakFGcUZtTWhwT1psSVhEdEJhdTdza1BoQk90OUp6?=
 =?utf-8?B?Tkt0REJORHZiZmNBRFhZcm9YREJTd091dklXZVBZbi90dzhIb0hPM042cVV3?=
 =?utf-8?B?UmFLWGNydDd6SnNRanBFamh4alpZbUFhRTFwdEI5Tm1XN1hNVWl1THRuRk81?=
 =?utf-8?B?M3IwZ3VuL2NtOUVFY285dW4yeS9OQmxFSWk4OTFYNEpleFcvbVI5YXR0R2U4?=
 =?utf-8?B?VVhka2sweWF6SEs1Wm9jTnFob1R4ODBhSXdvMmg2dytMeHUxeDgxMzluMlFH?=
 =?utf-8?B?bXB1S0IvTG1uWmlxYkovVzRMbEIyVFZiWDBoejRPbWNDUld0eVNUWkFCM1Vn?=
 =?utf-8?B?dHpKWkJTS0RlajVjYW5SQi9IUk9IYWppb3BXZHg4WDVYbERaRHExR3p2RGpF?=
 =?utf-8?B?cEh0MWs3OHlsK3ZyWUhIRE5tVTdWSUFtY0JjRmFEbHlZVXQ4OXR6WEVMcVhs?=
 =?utf-8?B?VWdtbXAyejRCK1NTZ1I3UjE2VnVJT1Z4dXpMSVJodWU1ZzZCY1MwbzhSZlFz?=
 =?utf-8?B?Y1JjWlFQRElvci9aT0p6QmNmd3Zid1VIOUNDYkkxdmlqSkYxQU9rYnVJRno4?=
 =?utf-8?B?dDdUaEJDK2NYam5pSDE1N3NxSWxLQkthcUg4NnZCdjl0WlpJNWw5c0F6aEFD?=
 =?utf-8?B?akQyZytBQjdyM3NqTVowU05UZlFTMEIxMGpQdFJCaXc2K01BY29HTTQ5YUdw?=
 =?utf-8?B?UGdlSmltT3NPb2R2SGVod3lXR1lseS9obWpFQUE4dmJGTk9LOVpHakVUOWww?=
 =?utf-8?B?ci91QWVkM1N3RjNPNU1UaUpQNUlwbHhQWU1vWVNkQ2QyckRmYThvc3FGVFh0?=
 =?utf-8?B?YWE0QWhiQ1BDSWx3ckF5eENiUitEdEJTTnFaSW5ZNk9jakFBeisrKzJFTFRq?=
 =?utf-8?B?ZSttYWpxZ3NmUHpwcjVWSUF4a2JncVpJSEYxYU5oSGt1dEpKMFQyMXlCRklN?=
 =?utf-8?B?bFEzMTM4dTYwQlFXRSt0aXRnQ0dTVGUvNm0wUTNETHR5Rzl4b2kvOHdONmpG?=
 =?utf-8?B?czZWNHRnRzVLbndkVDkwRnZLZnlmWHowVUdKOUxTcXNmaFhRa0hQQ2JGTWF4?=
 =?utf-8?B?UzNyNTgrV3ZOeUpOTmdUUWh1VFlqbzNBaHpmOWhDSnc1Wm9FcXZMMS9MeERK?=
 =?utf-8?B?ZlNLVDQrQkh6SitRd0dNUjN4ZTAzTkxSM2NuL0JlL0NlNW5RQTlDc3hxU3oz?=
 =?utf-8?B?ZFhnUk5LN2RmMzNDdkJaM1M5aTBWTkgxUnpxK3lub2tQRHZvUU9lTzFMQTZs?=
 =?utf-8?B?NXZMWXpNRmhWa25SSVhva2RWOElVTi9oOWpKZHBRbm5NZVN4YnpCZ085YW5T?=
 =?utf-8?B?cVBTcEFNd29tcy96WE9SMjZyb3dJcnpQTUd6bVJVU0ZRTmNMYmFWMnplZFVG?=
 =?utf-8?Q?tcqXoYozttow+492M4RRZKw=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <5C1A852E4DC42149AD940E257912D2D9@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ae00e72-f964-4a37-b456-08d9d4361f51
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2022 12:38:36.7625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BX8hsfAWfFTodL3ZzsGrPC0pjmcKeuTX9z7LpdyFeyQ9TW/PhDpsJfeuiLoT984+6XRi4X7Z16Q9AOppPQf9hg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR03MB3813
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gUmVtb3ZlIHRoZSBvbmx5IHR3byBkaXJlY3QgY2FsbHMgZnJvbSBzdWJkcml2ZXJzIHRvIHJl
YWx0ZWstc21pLg0KPiBOb3cgdGhleSBhcmUgY2FsbGVkIGZyb20gcmVhbHRla19wcml2LiBTdWJk
cml2ZXJzIGNhbiBub3cgYmUNCj4gbGlua2VkIGluZGVwZW5kZW50bHkgZnJvbSByZWFsdGVrLXNt
aS4NCj4NCj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1
Y2FAZ21haWwuY29tPg0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1v
bHVmc2VuLmRrPg==
