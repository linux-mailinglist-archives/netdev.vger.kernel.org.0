Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 117134C3C2A
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 04:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232921AbiBYDIQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 22:08:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiBYDIP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 22:08:15 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70083.outbound.protection.outlook.com [40.107.7.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12AF2B0A59
        for <netdev@vger.kernel.org>; Thu, 24 Feb 2022 19:07:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kg6C+zpY3VR5zBHCpWOnSMlSKROIYCJYPSeLR3LYpLE6oR76gQIW9KBE5MUMXc2Uz/mZHxlxf3NyQNZvW5+oIy3n3qDe7c+0PehifeblZrOtfrYLf5AqzFDwpHYuXvidJjislxjO9dgw13puyetNbzmO+dCH04egtBIOw85q9zmuVT57rgCP8g7ETAIpRCWCklAjEN/4+f79UGi1aSHp30SN6vHu5vFayXZxsdN8JiUPrxenGPpIQhVXoE3yXMtJd8yxNDmWpUunhk8O4e1q95E3iWeTJPUEsKBLO0iu1Tyz9ur+1d/wfM7XmIdcY6/v8xJlLQi1dctEsbTS1ToUIg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=JP/fZIy4bQ5UOjrBod8KCY6rwxuspb65/mFeh8VpvJc=;
 b=POFMfGSUY01Ro2g2lzY0oW9/H3SD7aLe0rQXUDRRFSnN9r/PDLyJkRvpyQBC6HLYybVITigmGscoC0K4mAkpw8Wne8sM8a1KIClIpfHdmmiQipbjK30QTo4GlLkpGKlWCkhdzZZzNYnNzTcBuNHuyAqOb+lJyAkoGE5oPrVon8hVtAoxhjh/JKRZFXXy0zoQuTHnzuazEbqdvZs2LK2FCbUD92OizUhJBRKM43ONo0iHTF2RkXUJJxj3atB0Cbphe9d4BMtftzHL+3rpiCzu+vjsOrshVaHhSvs1FuVog98+tc1wJjVvlwi4LnR9VJUXR2b1ZayAUOVutBvp8o3rnQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JP/fZIy4bQ5UOjrBod8KCY6rwxuspb65/mFeh8VpvJc=;
 b=KI73tYOydIt81U32grTodbSvEhNMdMyvTnbsoPtFAXemnviw45uMNGC0f1OeIeDOTVx/rjxsM/4MS7HWnhTNsD03toXzaq2AkWqySGNodzMBlVXLCdTAm7Nu9YOT2oLjlric2niSicmfXMYKi3i30RXQShLj1USvxgvc6oAlA9o=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by AM0PR04MB6753.eurprd04.prod.outlook.com (2603:10a6:208:169::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.24; Fri, 25 Feb
 2022 03:07:41 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::85c7:17f1:d414:28a4]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::85c7:17f1:d414:28a4%5]) with mapi id 15.20.5017.024; Fri, 25 Feb 2022
 03:07:41 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Sascha Hauer <s.hauer@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>
Subject: RE: [PATCH] net: fec: ethtool: fix unbalanced IRQ wake disable
Thread-Topic: [PATCH] net: fec: ethtool: fix unbalanced IRQ wake disable
Thread-Index: AQHYKIyscA7G5aKyYkaL59ObHIcYZKyg7UuggAAJiICAAqFzAA==
Date:   Fri, 25 Feb 2022 03:07:41 +0000
Message-ID: <DB8PR04MB6795ED6754BAD893822A1039E63E9@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20220223080918.3751233-1-s.hauer@pengutronix.de>
 <DB8PR04MB6795F51CEFF0DE50E57C9FFBE63C9@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <20220223105609.GL9136@pengutronix.de>
In-Reply-To: <20220223105609.GL9136@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 47d38273-29a0-4079-36a9-08d9f80bfc6b
x-ms-traffictypediagnostic: AM0PR04MB6753:EE_
x-microsoft-antispam-prvs: <AM0PR04MB675337EC4FDD97D10671BA67E63E9@AM0PR04MB6753.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: djvlQ7DPmauDhizDfQjpp7TtxIqGXXHcBh3t3RQgIsg0KS6g3OlJIQvkkeq4pnayv67X0nGGvxC7Bxc+Mi8ZzxoLNFLY/Rijy9m35bkxKNu4aUdDk+H9Q3OFQKEvnLVGQDXHMdSsek48yqquHVVfFzNRsb+FUKDcy5WntgSqGcYPEfSKpm0Lb/6CpuO+MWYe+Z2YYGPfnDk0/Urj4QnsFcL56eLQCo7VRLdSBBfsPzC546ff3siRQGN2dSlW5ZZKNSMefEK5usmcggrga8WPCO/AOlM40En401s+bMIRyjQRJvi/KO5oi4nSejIiMZfhGmwvMit9AMOaVpfKOdxbeRCWwqbT6/DQWZfms0pXW32XeHErgE0Q3ZiPAnmRA+FM/oqaAllfrfJM9fQWM/ii0IEMIBj7uLh5NMYxOkOJIQJezw/7lKufinglbnl+rxoy76Aikraz7zEHKc1G95s9vZ3C9NShY49CuZBQy0dRMETXcg0ACLPloqZqg5hWepJtM2j9VzmQ1DwKmdNusY9HJYn1LieHlxsRrpZzEAW0P/MX9K6KZnVUw0GS9sVdWCdNLaa8OzDZokCKgqGCDedN6bGaDWyVJN4dvgM1jLx/c/vlPzf2Ox+eusSXEH5TPin2MbLnGy0pjH92H8Q2GAy5FLfovNVdt4pK91NaM61aXj6QGQGwHfMmkiptrDJB7PmdqVSpZ9pDJuQMHcqK05byW9LTJo+Y15gadpPPdF0WtTBkIKz/5Hda9EDabW6LlAX3wZs3cSRc3B+dbFYDKAALh9oyx/Jig5TfLMoSfHfcLgTTrz6d5ienHTLFuvj5uA2y
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(7696005)(6506007)(55016003)(186003)(45080400002)(53546011)(83380400001)(9686003)(38100700002)(71200400001)(26005)(38070700005)(966005)(508600001)(122000001)(64756008)(66556008)(316002)(66476007)(66446008)(8676002)(54906003)(86362001)(52536014)(6916009)(5660300002)(2906002)(76116006)(66946007)(8936002)(33656002)(4326008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?T2FPOWZKTllwMnRiL0FWbXVtUnpwOHJHZXNob1BMZVQ0RnUwTHdOQXpOU0xN?=
 =?utf-8?B?S1FVZG5rUURGUWNoNTMzNnUrOTMzM3hnSTlKRlNkek92Skx0RW8wWG96dFNW?=
 =?utf-8?B?Rmd0aERKbmZBNkJTZDhTOFJCdi8ydjlKQVlibjNQMkRJQWFiZ1hqcGYyU1E3?=
 =?utf-8?B?ZStsM1hxTERuWDBXWFR3WXRaKzhjeGFxNHBOSDBRMFdjeER6dkJzN216Witv?=
 =?utf-8?B?ZjlxVXVxMjY4WGgvRWVUbElFa1dWTk5kZHJOTmlsaWhGNGE3dUNKUzY0ZzNF?=
 =?utf-8?B?NTBPdGRjY09JeU9yQmI2eXpQTlpJQUYxOWMvRWs2TktnSk40OVpYR1lIdXRp?=
 =?utf-8?B?REFLOUY1dXE0ZmJHSHpwdWNLUlMyU2JGZzJwSmQyL2wrLy9HODdxRHgvR05S?=
 =?utf-8?B?SjM0WXVXTERBRWZiZ003eFpBQ25xRHJ0Q0JYdlpSSmxLLytGUDJTOU8zZ0gy?=
 =?utf-8?B?SmZRcDJmdXVpZnlPbEY2V1ZoVnM1MXo4R040VkhBYXFsbEZNZFZTZ0tHVWlE?=
 =?utf-8?B?aUxJbHBjQ2xxZ3IzemYzdUZrNjVhVkxzendzdEFzV2lqWW5mUWpDV29LVzQv?=
 =?utf-8?B?MzBMYkJGR1BiMzVyS29oOWtibzl4L253dzllZ2VDRkRwdlFtTVBUbTZNdk56?=
 =?utf-8?B?dmRYeTdoQnBGdnpFTXY2WEFoTXI4NnNwRnNBTmwwNDRQUUtBU1daa1E1TW1F?=
 =?utf-8?B?b0J3N3M5QnNwUjAvbHhlNDhNcTdubGdOeVBBNGU0V011WDZvYktiZnpIQnNG?=
 =?utf-8?B?WU0vS2JLQVVKSG5WOVdUMndPZ1VwMTk4UU1Yd0JOelRiZ3dtSXRac29KTHdC?=
 =?utf-8?B?akNDT3VvNFVoL0hHdVVNU1NDN21KdmpvRU5zcENDMnJTaGg1dVphREJab0NS?=
 =?utf-8?B?cEo1djNDaHJudW4wdTBta2pHeGFFZkFxYjdoMlFnK01vazJWTEw1ZUlwM2NQ?=
 =?utf-8?B?UmplNitFbVd6RGlqWVJod3FOVHdVOHJPMTV6NUhlOUVkTjBCUmVPbWtoODVs?=
 =?utf-8?B?dklROVRFaFN6enFyNi83RGFEekF5b3ErQXo0aUpQNkY2ZTJWNitRUy9tTUVQ?=
 =?utf-8?B?anJENTRIaFAyNm4rc2ZTR3FDNE5MbjBRZ1BySjZDTUdEQW0wV0pjaTFHai9h?=
 =?utf-8?B?N05UdW0rUTd4Ti9WUytXRGgwVGVqVWMyK2JCUGphdVlrMUttWDFRVjk5L0cv?=
 =?utf-8?B?dCszL08zd2ZQZDd5MGpLcW5hd3ZMQWZRWkt5SVI3SW5yQkZFT0VubDh2c1NS?=
 =?utf-8?B?b2NyYmw1VmZSKzdaVXh5ZWtjQ0FGNjBOWlFDZzdNYksvOVZkZndwYjFXNmp5?=
 =?utf-8?B?ek1RYWdNamh4K1hZYVJaT0V1d0hLZUNNLzQ1NU0vSDVLNkZNQkFIcWZReTlT?=
 =?utf-8?B?MXV4b2xqYjZPaStRVkVXaU5lalJIdGdWLzZrVytiSzJ0RE1xb2pYUXk2Z0FY?=
 =?utf-8?B?TEIzZFBseE5EemEzUEM5NmRRZkVrYjRqZEVTdTFsWjZIeEhLbFQrMEM2R2U2?=
 =?utf-8?B?Q2hhYUtVNkFNQTBLZERpWlo5djhvRjd6ZnY3akRpbXlkRDBYWU1iSlJLalo0?=
 =?utf-8?B?amR1RzZHeWZvOGRzZjVnYTJDMkVnS3ZtNnNYeFBZSkhpeFExYUgvd3MzdnZt?=
 =?utf-8?B?T3ZkYnF2bWxTWnJEU2NJbi9GY2VqNFBKbi9qalUySStWc08zcEJVakVNOUNv?=
 =?utf-8?B?STh5NkhIWDNJZkZ2aFZXY1NUTlpIVnRJTDZRa2VPT2dmY0tuTHd6SWVIVDBh?=
 =?utf-8?B?MXRLeHZhaXExTUMrSjdFWTZGRDBsQXRXd3R3ZUhJZ01FRzJudTVpcjlyZHh6?=
 =?utf-8?B?ajhmYnFETUdGYXBmK09aRFEzV3dPUVYyOHpmbmJlamVScGVrV2owbUQvSllV?=
 =?utf-8?B?V2RnOFJkQlFVNk55blZGNzhLNGJVd1V3a3Q1TkFsdzJzcE5Lb1hFakhJSmlp?=
 =?utf-8?B?VkxKYkZiWi9Uc2FFMTVMcndCc3VSelBNMGxZUVRzWEJ2eERUdWIxZmMxSU9S?=
 =?utf-8?B?UnlkRHVLRk8rY0tTN3dLcmtmRkV6cUNYNTRhc3g1SGVFcWNCTnFhR3pLWDZr?=
 =?utf-8?B?cUpqVFA0Q1c1Z0dadU1ZT2FvUjQ3SkVRYmMzR1JUSExaaXRocnVaY0FVSE13?=
 =?utf-8?B?OUlSSHF6TG9JQmdCbmRKZHRZZktSU0VvSzZVYjcvYUJtaDd6SzRqL1Nqcm54?=
 =?utf-8?B?Zmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 47d38273-29a0-4079-36a9-08d9f80bfc6b
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 03:07:41.2223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kncxREaJya5R2QcjAiGhwRsjdT/edAOhcV3CZXkFqwafDGcmUjmzvUlz7rrkOi0wlEQ5vXTyxKN7m3b8doq30Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB6753
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpIaSBTYXNjaGEsDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogU2Fz
Y2hhIEhhdWVyIDxzLmhhdWVyQHBlbmd1dHJvbml4LmRlPg0KPiBTZW50OiAyMDIy5bm0MuaciDIz
5pelIDE4OjU2DQo+IFRvOiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56aGFuZ0BueHAuY29tPg0K
PiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47DQo+IGtlcm5lbEBwZW5ndXRyb25peC5kZTsgQWhtYWQgRmF0b3VtIDxhLmZh
dG91bUBwZW5ndXRyb25peC5kZT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gbmV0OiBmZWM6IGV0
aHRvb2w6IGZpeCB1bmJhbGFuY2VkIElSUSB3YWtlIGRpc2FibGUNCj4gDQo+IE9uIFdlZCwgRmVi
IDIzLCAyMDIyIGF0IDEwOjI4OjM0QU0gKzAwMDAsIEpvYWtpbSBaaGFuZyB3cm90ZToNCj4gPg0K
PiA+IEhpIFNhc2NoYSwNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
PiA+IEZyb206IFNhc2NoYSBIYXVlciA8cy5oYXVlckBwZW5ndXRyb25peC5kZT4NCj4gPiA+IFNl
bnQ6IDIwMjLlubQy5pyIMjPml6UgMTY6MDkNCj4gPiA+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwu
b3JnDQo+ID4gPiBDYzogSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhwLmNvbT47IERh
dmlkIFMgLiBNaWxsZXINCj4gPiA+IDxkYXZlbUBkYXZlbWxvZnQubmV0Pjsga2VybmVsQHBlbmd1
dHJvbml4LmRlOyBBaG1hZCBGYXRvdW0NCj4gPiA+IDxhLmZhdG91bUBwZW5ndXRyb25peC5kZT47
IFNhc2NoYSBIYXVlciA8cy5oYXVlckBwZW5ndXRyb25peC5kZT4NCj4gPiA+IFN1YmplY3Q6IFtQ
QVRDSF0gbmV0OiBmZWM6IGV0aHRvb2w6IGZpeCB1bmJhbGFuY2VkIElSUSB3YWtlIGRpc2FibGUN
Cj4gPiA+DQo+ID4gPiBGcm9tOiBBaG1hZCBGYXRvdW0gPGEuZmF0b3VtQHBlbmd1dHJvbml4LmRl
Pg0KPiA+ID4NCj4gPiA+IFVzZXJzcGFjZSBjYW4gdHJpZ2dlciBhIGtlcm5lbCB3YXJuaW5nIGJ5
IHVzaW5nIHRoZSBldGh0b29sIGlvY3Rscw0KPiA+ID4gdG8gZGlzYWJsZSBXb0wsIHdoZW4gaXQg
d2FzIG5vdCBlbmFibGVkIGJlZm9yZToNCj4gPiA+DQo+ID4gPiAgICQgZXRodG9vbCAtcyBldGgw
IHdvbCBkIDsgZXRodG9vbCAtcyBldGgwIHdvbCBkDQo+ID4gPiAgIFVuYmFsYW5jZWQgSVJRIDU0
IHdha2UgZGlzYWJsZQ0KPiA+ID4gICBXQVJOSU5HOiBDUFU6IDIgUElEOiAxNzUzMiBhdCBrZXJu
ZWwvaXJxL21hbmFnZS5jOjkwMA0KPiA+ID4gaXJxX3NldF9pcnFfd2FrZSsweDEwOC8weDE0OA0K
PiA+ID4NCj4gPiA+IFRoaXMgaXMgYmVjYXVzZSBmZWNfZW5ldF9zZXRfd29sIGhhcHBpbHkgY2Fs
bHMgZGlzYWJsZV9pcnFfd2FrZSwNCj4gPiA+IGV2ZW4gaWYgdGhlIHdha2UgSVJRIGlzIGFscmVh
ZHkgZGlzYWJsZWQuDQo+ID4NCj4gPiBJIGhhdmUgbm90IGZvdW5kIGRpc2FibGVfaXJxX3dha2Ug
aW4gZmVjX2VuZXRfc2V0X3dvbC4NCj4gPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0
aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMlM0ElMkYlMkZlbGl4DQo+ID4NCj4gaXIuYm9vdGxp
bi5jb20lMkZsaW51eCUyRnY1LjE3LXJjNSUyRnNvdXJjZSUyRmRyaXZlcnMlMkZuZXQlMkZldGhl
cm4NCj4gZXQNCj4gPiAlMkZmcmVlc2NhbGUlMkZmZWNfbWFpbi5jJTIzTDI4ODImYW1wO2RhdGE9
MDQlN0MwMSU3Q3FpYW5ncWluZy56DQo+IGhhbmclNA0KPiA+DQo+IDBueHAuY29tJTdDMmQ0YWI5
YTdlZmE5NDA0MzI0OGEwOGQ5ZjZiYjFiMDQlN0M2ODZlYTFkM2JjMmI0YzZmYTkNCj4gMmNkOTlj
DQo+ID4NCj4gNWMzMDE2MzUlN0MwJTdDMCU3QzYzNzgxMjEwNTc0MzkxMzY4NCU3Q1Vua25vd24l
N0NUV0ZwYkdac2IzDQo+IGQ4ZXlKV0lqb2kNCj4gPg0KPiBNQzR3TGpBd01EQWlMQ0pRSWpvaVYy
bHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhWQ0k2TW4wJTNEJTdDMzAwDQo+IDAmYW1wOw0KPiA+
DQo+IHNkYXRhPVBvJTJGMHNtbDFTakJTWGx4OEJURUxnMjloRTVxc0xJVzJ4eUFMeTdPODdzMCUz
RCZhbXA7cmVzZXJ2DQo+IGVkPTANCj4gPg0KPiA+ID4gTG9va2luZyBhdCBvdGhlciBkcml2ZXJz
LCBsaWtlIGxwY19ldGgsIHN1Z2dlc3RzIHRoZSB3YXkgdG8gZ28gaXMgdG8NCj4gPiA+IGRvIHdh
a2UgSVJRIGVuYWJsaW5nL2Rpc2FibGluZyBpbiB0aGUgc3VzcGVuZC9yZXN1bWUgY2FsbGJhY2tz
Lg0KPiA+ID4gRG9pbmcgc28gYXZvaWRzIHRoZSB3YXJuaW5nIGF0IG5vIGxvc3Mgb2YgZnVuY3Rp
b25hbGl0eS4NCj4gPg0KPiA+IEZFQyBkb25lIGFzIHRoaXMgd2F5Og0KPiA+IGh0dHBzOi8vZXVy
MDEuc2FmZWxpbmtzLnByb3RlY3Rpb24ub3V0bG9vay5jb20vP3VybD1odHRwcyUzQSUyRiUyRmVs
aXgNCj4gPg0KPiBpci5ib290bGluLmNvbSUyRmxpbnV4JTJGdjUuMTctcmM1JTJGc291cmNlJTJG
ZHJpdmVycyUyRm5ldCUyRmV0aGVybg0KPiBldA0KPiA+ICUyRmZyZWVzY2FsZSUyRmZlY19tYWlu
LmMlMjNMNDA3NSZhbXA7ZGF0YT0wNCU3QzAxJTdDcWlhbmdxaW5nLnoNCj4gaGFuZyU0DQo+ID4N
Cj4gMG54cC5jb20lN0MyZDRhYjlhN2VmYTk0MDQzMjQ4YTA4ZDlmNmJiMWIwNCU3QzY4NmVhMWQz
YmMyYjRjNmZhOQ0KPiAyY2Q5OWMNCj4gPg0KPiA1YzMwMTYzNSU3QzAlN0MwJTdDNjM3ODEyMTA1
NzQzOTEzNjg0JTdDVW5rbm93biU3Q1RXRnBiR1pzYjMNCj4gZDhleUpXSWpvaQ0KPiA+DQo+IE1D
NHdMakF3TURBaUxDSlFJam9pVjJsdU16SWlMQ0pCVGlJNklrMWhhV3dpTENKWFZDSTZNbjAlM0Ql
N0MzMDANCj4gMCZhbXA7DQo+ID4NCj4gc2RhdGE9SDlrZE5sUEoxS1BPeXZTJTJGTG0lMkJqNk5y
UGU1TjFtRCUyQnJmZ1dvTmhFVVlnVSUzRCYNCj4gYW1wO3Jlc2VydmUNCj4gPiBkPTANCj4gPiBo
dHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2suY29tLz91cmw9aHR0cHMl
M0ElMkYlMkZlbGl4DQo+ID4NCj4gaXIuYm9vdGxpbi5jb20lMkZsaW51eCUyRnY1LjE3LXJjNSUy
RnNvdXJjZSUyRmRyaXZlcnMlMkZuZXQlMkZldGhlcm4NCj4gZXQNCj4gPiAlMkZmcmVlc2NhbGUl
MkZmZWNfbWFpbi5jJTIzTDQxMTkmYW1wO2RhdGE9MDQlN0MwMSU3Q3FpYW5ncWluZy56DQo+IGhh
bmclNA0KPiA+DQo+IDBueHAuY29tJTdDMmQ0YWI5YTdlZmE5NDA0MzI0OGEwOGQ5ZjZiYjFiMDQl
N0M2ODZlYTFkM2JjMmI0YzZmYTkNCj4gMmNkOTljDQo+ID4NCj4gNWMzMDE2MzUlN0MwJTdDMCU3
QzYzNzgxMjEwNTc0MzkxMzY4NCU3Q1Vua25vd24lN0NUV0ZwYkdac2IzDQo+IGQ4ZXlKV0lqb2kN
Cj4gPg0KPiBNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhW
Q0k2TW4wJTNEJTdDMzAwDQo+IDAmYW1wOw0KPiA+DQo+IHNkYXRhPU1IMzBwNW8yZmpscCUyRkxY
ek1TUFAyMEk3UlRvUU5yOWtZclRHbCUyRlpTSGJ3JTNEJmFtcDtyDQo+IGVzZXJ2ZWQ9DQo+ID4g
MA0KPiA+DQo+ID4gPiBUaGlzIG9ubHkgYWZmZWN0cyB1c2Vyc3BhY2Ugd2l0aCBvbGRlciBldGh0
b29sIHZlcnNpb25zLiBOZXdlciBvbmVzDQo+ID4gPiB1c2UgbmV0bGluayBhbmQgZGlzYWJsaW5n
IGJlZm9yZSBlbmFibGluZyB3aWxsIGJlIHJlZnVzZWQgYmVmb3JlDQo+ID4gPiByZWFjaGluZyB0
aGUgZHJpdmVyLg0KPiA+DQo+ID4gQWhoLCB3aGF0IEkgbWlzdW5kZXJzdGFuZD8gQWxsIHRoZSBk
ZXNjcmlwdGlvbiBtYWtlcyBtZSBjb25mdXNpb24uDQo+IFBsZWFzZSB1c2UgdGhlIGxhdGVzdCBr
ZXJuZWwuDQo+IA0KPiBUaGlzIHBhdGNoIHdhcyBmb3J3YXJkIHBvcnRlZCBmcm9tIHY1LjE2LiBJ
IHNob3VsZCBoYXZlIGhhZCBhIGNsb3NlciBsb29rDQo+IGJlZm9yZSBwb3N0aW5nLCB0aGVuIEkg
bWF5YmUgd291bGQgaGF2ZSByZWFsaXplZCB0aGF0IDBiNmY2NWM3MDdlNQ0KPiAoIm5ldDogZmVj
OiBmaXggc3lzdGVtIGhhbmcgZHVyaW5nIHN1c3BlbmQvcmVzdW1lIikgYWxyZWFkeSBmaXhlcyB0
aGUgaXNzdWUuDQo+IA0KPiBTb3JyeSBmb3IgdGhlIG5vaXNlLg0KDQpOZXZlciBtaW5kISEg8J+Y
ig0KDQo+IFNhc2NoYQ0KPiANCj4gLS0NCj4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAg
ICAgICAgICAgICAgIHwNCj4gfA0KPiBTdGV1ZXJ3YWxkZXIgU3RyLiAyMSAgICAgICAgICAgICAg
ICAgICAgICAgfA0KPiBodHRwczovL2V1cjAxLnNhZmVsaW5rcy5wcm90ZWN0aW9uLm91dGxvb2su
Y29tLz91cmw9aHR0cCUzQSUyRiUyRnd3dy4NCj4gcGVuZ3V0cm9uaXguZGUlMkYmYW1wO2RhdGE9
MDQlN0MwMSU3Q3FpYW5ncWluZy56aGFuZyU0MG54cC5jb20lDQo+IDdDMmQ0YWI5YTdlZmE5NDA0
MzI0OGEwOGQ5ZjZiYjFiMDQlN0M2ODZlYTFkM2JjMmI0YzZmYTkyY2Q5OWM1YzMwMQ0KPiA2MzUl
N0MwJTdDMCU3QzYzNzgxMjEwNTc0MzkxMzY4NCU3Q1Vua25vd24lN0NUV0ZwYkdac2IzZDhleUoN
Cj4gV0lqb2lNQzR3TGpBd01EQWlMQ0pRSWpvaVYybHVNeklpTENKQlRpSTZJazFoYVd3aUxDSlhW
Q0k2TW4wJTNEJQ0KPiA3QzMwMDAmYW1wO3NkYXRhPWs3Q1B2SGxuT2dQYmNxU3VxdHBRbmxXcyUy
QjNEMCUyRmVGM0xWaUhRQiUyDQo+IEJOcHpRJTNEJmFtcDtyZXNlcnZlZD0wICB8DQo+IDMxMTM3
IEhpbGRlc2hlaW0sIEdlcm1hbnkgICAgICAgICAgICAgICAgICB8IFBob25lOiArNDktNTEyMS0y
MDY5MTctMA0KPiB8DQo+IEFtdHNnZXJpY2h0IEhpbGRlc2hlaW0sIEhSQSAyNjg2ICAgICAgICAg
ICB8IEZheDoNCj4gKzQ5LTUxMjEtMjA2OTE3LTU1NTUgfA0K
