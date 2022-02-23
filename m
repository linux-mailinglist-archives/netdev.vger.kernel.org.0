Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2000C4C15D9
	for <lists+netdev@lfdr.de>; Wed, 23 Feb 2022 15:54:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237591AbiBWOzM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Feb 2022 09:55:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiBWOzL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Feb 2022 09:55:11 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30093.outbound.protection.outlook.com [40.107.3.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A849B251B
        for <netdev@vger.kernel.org>; Wed, 23 Feb 2022 06:54:42 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kKI5588VAUmbNMSVmeiXL+GAw8dtIu+k1N9Z9yPjQ3bZUQRMAH09U71DhIb0vYq7Cl6Vehri63zl7NLNIOSBplQHiftukq7hdJNrSeKl0BuzwDj9n26+S8nSLxUj9KfxZTp7eAc2u4KrYU977PRJPgY/XmB3UsAgmkoTcHkwafCaQ4J2srikAGtkVgkT7oYUoNdcMfuypiB1KGTplC1qBtU0pJ0NVUQ1ZtlN1n/6TaD/N/O8ruKg3uX+PetXAoZQMbPYnJyTGggGXHoIbAeo8WGLTmKNpj64VVp8FBTYrl3lCk4sP0lOHqjKBVYW2MKp79fGyWNjEkz3YEx9na/gyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mqVhCGIuyj8k4pFnvlShqciAdV+nw0SZTxMrU92MPUY=;
 b=EBd1KpmdjYIbwBbxJmkaZn3GVw9AVI0uJ2LvjvhvGYr1D1CZAXKH12kuY6O0KPYtORNd9gPVKiJKShmDvYMZudoJZ0B+BIUIoeon3IPqw07UK5qfa3N0N8vGszvt+UoEI7aaLUlEjawvz2rM2i6HomDmHJ0fbZ5MHmGgGgnN2zSYRxq4V/+nn3twGFFOcY02CS3DWWVIPxxkLijnX1M7sHLhGQ1PmdJHNU84DnfMXQf6py1XAk91PNXGqbhlWWZthjuLkeIUG96vqJ/sYZvl/SWYvbOcjxJT2TcEFn+nS5ucU9wvOJdzCH0QVBO/nttV6YqCrAQ20dD2A1rdtVj7+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mqVhCGIuyj8k4pFnvlShqciAdV+nw0SZTxMrU92MPUY=;
 b=jCr5ote3W4lpySj0/rUDqpkYiLe1nzBYhVcB5iSv4k6Yai7Wk2wx8lNjdLkQFnsu5eS11XCljs8T2zWPTiQ/Ztff4OMKUY57abvcXalO/2CaHZo0A/Iq5AnsR4GPS0kB0amEAr9x9Vcb9rp2DPYRdYTgxlHSC8LTpeAzJoga39U=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB7PR03MB3579.eurprd03.prod.outlook.com (2603:10a6:5:4::26) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.27; Wed, 23 Feb 2022 14:54:39 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.5017.022; Wed, 23 Feb 2022
 14:54:39 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next v3 1/2] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Thread-Topic: [PATCH net-next v3 1/2] net: dsa: tag_rtl8_4: add rtl8_4t
 trailing variant
Thread-Index: AQHYKD5ZvCUsEirlcEC5YcpbFWA+sg==
Date:   Wed, 23 Feb 2022 14:54:39 +0000
Message-ID: <8735k9fxao.fsf@bang-olufsen.dk>
References: <20220222224758.11324-1-luizluca@gmail.com>
        <20220222224758.11324-2-luizluca@gmail.com>
In-Reply-To: <20220222224758.11324-2-luizluca@gmail.com> (Luiz Angelo Daros de
        Luca's message of "Tue, 22 Feb 2022 19:47:57 -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a6af2aaf-441f-42a2-9c55-08d9f6dc6ae4
x-ms-traffictypediagnostic: DB7PR03MB3579:EE_
x-microsoft-antispam-prvs: <DB7PR03MB3579A16200AE58118C13D66F833C9@DB7PR03MB3579.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: kYGoLwME4ptQMg4cLXjCpsCd2VeJTUizXsP3oezj2xAijztf4OwewAfAvVZbXwW55ZrHKYXDz2P92wfuH4bllK5kkIQrHwyVLgnVnnpFJTehm/P8Cgn1t8uIbfV0s/A/bHyLukhXe5yWt2WSQ/wpiseGDVKtndfXOp2OVEL+TyRsRHVI7Ly31tBe+hSAT/WNd46wH786CS8pFei2pJNRGaA05Bqo1q+Jv0cn1W6NjkF15Zz90bCnGTdGGbedBvBqPJJtOdWmPGD/12zx6+0cay42khXKkHv8u4ZyHe+HxLSLahPq7VhAtRQnYMwiODXoEUOJ0KqIX5Fejn21Wk4hMoxLrLDT593CG3gD9KeYj/1Ycb6UxpXxfCd78CBlpi/gRLjYyxaHvqQrTPqwHi4MpeojvtnnAG8zJDCz8defvkFytg4TNnSwrrmfJBaqutiR1++Z9JHh+54TK0V7r9Z0c+mle9/3x9UUhr6aTWVeQV5Sl4xmFAxxt2xI06V/nk9GvWUKMy50whYOJvu/QRXmhUZGBgCqPGmazWjgVvdTJHjDTutYnB1/ctQJnfrdcYTdz7jUSUWaws1qqpASW0axsOfsqkQ0zVQA94Yf9JQLdShPv5YUqVwDUncRLePD0V+nGBsp/fMoBC5T8i7SDp3gCZrW8CTFsLReiCZ1PrTYskxukjS8KcQPMQaN4iHqiWObdxQVqt0MD7BuRJXB4TVJcQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(76116006)(6506007)(6486002)(122000001)(6512007)(91956017)(316002)(186003)(4744005)(26005)(7416002)(66446008)(8676002)(64756008)(66946007)(66476007)(66556008)(38100700002)(85202003)(83380400001)(71200400001)(5660300002)(85182001)(86362001)(508600001)(6916009)(38070700005)(54906003)(8976002)(36756003)(8936002)(2906002)(2616005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?N0FTeWpwVUhCTThRMmI4V0FKTGJXbE5GN2kvakErb2FuYlFHYmprcHFiazVI?=
 =?utf-8?B?UzBCb1pqRzJ6d3lneDZibVczaE9DQ29RTEpUMHhuVlNhSWdIWmJSR1N3dkZt?=
 =?utf-8?B?ZlNGc0RRZURZZlZzUXU1UjNXM01sajdUN2xNOHIvSnFPKzdzVGc5S1ZTZDNv?=
 =?utf-8?B?eGREeUM5OGJyRXIvdElqTFZnMFo5QVluVEduQVNlRTNlREs4N0g0aEYySjlO?=
 =?utf-8?B?dHltTXlmKzRzbDI3aEZucW1tVlhIaXZnbkwrOHpnaXNjNWhIM3ErV1hFc242?=
 =?utf-8?B?SWtFMmdwK2l1QjZIUmNzeXV5cmpZUWh6aUxQSmFod1QvcXdZRGtUM3QxNitW?=
 =?utf-8?B?WUxJeXE1TnFlaU82WTFiYnQ2elUvcmM0OXlMT2xlUGpseURPSm9td1Fwa0o1?=
 =?utf-8?B?alkzM0VTaHVtOXVzWkxUY201d2tzdnNyV2lXWVBXY3FOZ0I0bmNhcFJIbWZW?=
 =?utf-8?B?OHkvaGQ0TWxkdUtsTkpBK3grcEh1bkxHbFNkbm1mR3pnd2Z4czFDQWczNWxH?=
 =?utf-8?B?SGwxS29tbW1ENFArWWhPY1A3emNwNkJ6OTM1S3BrWFVWUldmVHVBVGNhWkc2?=
 =?utf-8?B?V2tybE9oNTB5T09UdXROUGpKMjZ1dWxrZ1cwWlZBVCtLejVrMElpbzNNNzJv?=
 =?utf-8?B?dFE5akt6RnhLRHRqMEtPai9TdERGZkltc2M3S2w2QzIwenVxNmVjM1pJT1F6?=
 =?utf-8?B?alZ4RHIrOFNuYlJBWWkyMW1DaitCSWQvTzVML3hza2VtSndTMkJQcHgxRjFL?=
 =?utf-8?B?bnJ4SkRaQjMrRTJRaE1KMU51eUQxM3Q2OTVxeklmbEZWZkNyQUh1dFBBWjEx?=
 =?utf-8?B?bVhla1JmK0VoY0ZCdDMwYWNZdnV0VzZvL0g0Wm91RDlxTytpazN5TURmNXAv?=
 =?utf-8?B?REVwVTR3UlFKazV3SDVNTXZqU0U0WkRCbE5mTlBrWUJUWkp6dDduWml5aXU3?=
 =?utf-8?B?U3hsbGZUb3NGTnUwNGhwTG50R0gwdElUUHQ3a2dEOFZmU0hGWi9PZFo5Y2lu?=
 =?utf-8?B?Z2RvV3MxVVgvOG1BTTlaVHp5L2w4SFB4M1JZZ3pTQSs1T1RTdmdJQzRScUM2?=
 =?utf-8?B?M2JjRVVTWC8xL0ltYjF3NDYxS2g3SFRWd3JkcHdSSTI5TVF3NXlENWtpNWl2?=
 =?utf-8?B?V1gxZlA3S2VWaWFqTHp2aG1BYTZ4M3A1KzNKRDI1Tk5WVDZTQ09NNDhCditR?=
 =?utf-8?B?dExEZE9KTVlaMjljcWZGZkF3ZmJsTUswdStYZ3lhZDM5R01ZYlFtV1pOUXpk?=
 =?utf-8?B?VUJCT0FRVmk1bmlrMVJvb054SmxleDZQeEtxblJwNmF5Tno3eWIrSld0WXkw?=
 =?utf-8?B?ZHhUTEliVStSalVmVlhDRXNKNWNIN3ZvNUxjdDNRNDRtNCtpanZUeGVGOW1r?=
 =?utf-8?B?RTVNak13V2l6REZMTlhyREw2T1VXSjdkTzQyaG9hWnZFS2RIYjUwQlIyeGY5?=
 =?utf-8?B?eFgyUjRDTGczcUVjR1FqMnFxbmcwQkNxeCtvbUo0TFFUZDFqZnZVQkJxWWlq?=
 =?utf-8?B?Nm1QV3pRRkdiWGVNNnh2THB1VXJ6MXFjWTY2K0dUeXFVdUdnelNyTWgxZDFE?=
 =?utf-8?B?ZXY5UU1mV0NnakszZ2ZhTmxYWDFIZXphM0lhc1A3NUVFdTJHM0swdU9lUEtB?=
 =?utf-8?B?RVhrV3kvejlUQkJPR21yVlh5SHhyclFndFZQS3VoTmIydnpuaG9vVjRZQ1p3?=
 =?utf-8?B?cjFIUDNCV1dwc0tZK2tENFlnWC9XNmFvY0hMWU93elRBdDdRaXN4OW1IdUw2?=
 =?utf-8?B?bWpoZ0VDeGMrOWUveGRqZDBTaGQ2NU9HajNMZVdiSi83QndLNW95djFRVXRT?=
 =?utf-8?B?WUswT21PWTdpS09lYzRhK3Z3Ty9IV2dCQy93eDJpZDJrekQ1ZXF5ODg2M1Nu?=
 =?utf-8?B?QmJ1ekc4OHRQeGxzUmpCSHNPVHhPUEFTRVA0R0xVMXU3bVJqRTEzTEczSEJM?=
 =?utf-8?B?ZmRWN0pSWDJlOTlDTDBKZWZrSm1mU2dqbVJkT2NSbGRSWVNxQXVjUUEySXg4?=
 =?utf-8?B?NVdCZGEwUGtKUUM1aTd5QXRteGtYL1dYT2JIazQySHVRN2E5UUs0QkVONXhF?=
 =?utf-8?B?T1hRcTY5UTZvNlJNUzVIQVdjSUhHVkIrMHJWUkl6QjYrNm8xcVNQejFyeDhY?=
 =?utf-8?B?dDNJRkpJbGpmSm82RFdYdW4vWWNHeXNiWlFIRVFIekR4dnhYZGdEcVdMczhN?=
 =?utf-8?Q?Adct1vEUqy4/TMjtymAzmqE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FD356CAB4F45784085DCE58CAB61D2E0@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a6af2aaf-441f-42a2-9c55-08d9f6dc6ae4
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Feb 2022 14:54:39.5459
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Tz16bEoXrxJ0nB7X071R5cBZbPfxOk973ZkTAK9svgHLqgJ/8C0tvJublF0ivhfMbNa/DPbG7E6UTz+hWzopjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR03MB3579
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

THVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPiB3cml0ZXM6DQoN
Cj4gUmVhbHRlayBzd2l0Y2hlcyBzdXBwb3J0cyB0aGUgc2FtZSB0YWcgYm90aCBiZWZvcmUgZXRo
ZXJ0eXBlIG9yIGJldHdlZW4NCj4gcGF5bG9hZCBhbmQgdGhlIENSQy4NCj4NCj4gU2lnbmVkLW9m
Zi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVjYSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiAt
LS0NCj4gIGluY2x1ZGUvbmV0L2RzYS5oICAgIHwgICAyICsNCj4gIG5ldC9kc2EvdGFnX3J0bDhf
NC5jIHwgMTU0ICsrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKy0tLS0tLS0tLS0NCj4g
IDIgZmlsZXMgY2hhbmdlZCwgMTIxIGluc2VydGlvbnMoKyksIDM1IGRlbGV0aW9ucygtKQ0KDQpS
ZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2EgPGFsc2lAYmFuZy1vbHVmc2VuLmRrPg==
