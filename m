Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 182C8506D46
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 15:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238517AbiDSNQp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Apr 2022 09:16:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231312AbiDSNQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Apr 2022 09:16:44 -0400
Received: from EUR02-VE1-obe.outbound.protection.outlook.com (mail-eopbgr20123.outbound.protection.outlook.com [40.107.2.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97CB6338B3;
        Tue, 19 Apr 2022 06:14:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Dm6pissZsLx5PKexOwbqWwv/4mfsa9gl1noWGTiUP0ngbhp4f7HrfNabJ35aExxeYwAlFCo2nKEu1Fgb5sjILgrmxc1UFqj0i8qFs29xmviVWXBOjCorm7B77EOsCGbsvdIWqL7LO4rLX0StVszZ9sBWbVJUzpNxYISUcU55R296oGEnTYseXlpAGzzpx6jpbGLoUPLMOVObrH+5ocbkKC+eklxmGChiHha4RFFkZj7IY/i24SDaaZOYt9j0hhjdn4qscMf/vTcnLbFlDdohEuOhD/vnagxD6va+ghDMme1nrAnR0FFaubGNu9ntu2slv72GitZj2g6fPTUXg067RQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VoYypxePYLZiZz5bpaTg4YNDERYnNkJtxfOAtghP/NY=;
 b=FWOw+i22UZQrHhV5Q1ngciCnv1jibO2GQvwizonUcZx0SsNCtgGDDAsQtENkzi/C6xmKBqmpWqQ++EIRYdMiW39N/XAvnrofib3nhxXMQYMURXVHB35N3a7JvvDY3FLplQRuQ8x7cQ/5ygm6Lh5Eb5dACD9X6wvivs6FqDRNDXrx17izqajntUQo3K3houACmFpu9BpKawnKCg+WErv95Vfep+1Y8n8lp370TtYV28UpwAcjvbpAyx7XbuAeKZeK56dfYzCDf0Arq+biqHXbOY98h8bzA5iNUKy7YmFlajgZLSuq5WU2Lwbfz3aeN2Rx93oXzwp6wRM1XpmAfuI9HA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VoYypxePYLZiZz5bpaTg4YNDERYnNkJtxfOAtghP/NY=;
 b=T2zkrs8u8XBdMHpEoIw8KKAjRWp42PryW7OK0CXoaLRkSivFWhXR6EVitnVvnRZ22tMPgcyInCPULytzJDEkmRyQQRSb/PrsUTypITjOXtWzJXJ9fpr3eh6cnco2DcAU6/3BloqEdUdrhEVVQIBAIFoS+DTUjlDYiEmEQ8dfQ3A=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DU0PR03MB8342.eurprd03.prod.outlook.com (2603:10a6:10:3a5::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Tue, 19 Apr
 2022 13:13:56 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5164.025; Tue, 19 Apr 2022
 13:13:56 +0000
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
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Thread-Topic: [PATCH net v2 1/2] dt-bindings: net: dsa: realtek: cleanup
 compatible strings
Thread-Index: AQHYU30cVvAvKL/RyUaWN8kP+4vAsKz3N6qA
Date:   Tue, 19 Apr 2022 13:13:56 +0000
Message-ID: <20220419131355.zzass4zmweqfnkbz@bang-olufsen.dk>
References: <20220418233558.13541-1-luizluca@gmail.com>
In-Reply-To: <20220418233558.13541-1-luizluca@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 44402493-343e-449b-f38b-08da220675dd
x-ms-traffictypediagnostic: DU0PR03MB8342:EE_
x-microsoft-antispam-prvs: <DU0PR03MB834255F6EB695B2E6C1C64F283F29@DU0PR03MB8342.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Asc/4rcRnfrzVJYcROILfAz8G9DQKDZWM2jTF/3doWjZHbpx3bhUFEoxcF7v2M8uyvZAk2np51O7oJPEt9Iui7qU4snpAy1hlBZTn9ib77EwStsLT3npRPGmntMEEYIpmihj8jAIYUoFLOTdOo8h/+D0c5Yr4LPChlbNFfqfehBComa6juKExpa0VXF82w9GAMz5WDBRgqBqnm9hhVY3n+74pFuyDQvy6vouhO8mxgjnEMUDmJkJ/lf6PjVK+XQGBgVzfLNBt5BN9eQ1g91eLmiDjqn0lBn1+/1DfH77Fz35Hb5P9Cbcdi0Kkjm4lkSuBZf8kq0tZr0SLIq86p+nQZkx+M8iVoBaue1wbzHJzxmO9XMUFSJJac9pgV6fRcuo4nPrezX19obl2ixZaReodxDmtvbUiEKeeCBmbGAnpEZz2J/r0/YLVbMDdhK9Gw7P2xsIRdleEbQWjl78ZTapisZqJb1BP1pNHtqrbnQngntpJ2JkqXogN1ChYSmnbv69RGtT+rhZTFiQNwvletKOBaGlLa6FWnM1Ha5MscLOdRKx9n0ivQCeWHsAMqe6U32HVuBN1M68s2SLKOvhvZFGBhMgqjEZE4pRzaJGNYr+C6s1UTE02yzFtzVmBr22fQICkf3esSmrrQqHFETnhpo2LleY1ap6zqufcb/tIn9tTDEUgjeyYadw4LiPeRDe3n4QSFOkao/akOJp/BVJxMu/08gXybMC219y/mWYr8K2ehCBwDdNVb5s2FyHZvk1Sk01ua55fNkgz0vF/RX8uRxTzUR5j92qMl7EZZDLwMWoP08=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(508600001)(38100700002)(4744005)(8676002)(6506007)(2616005)(8976002)(7416002)(86362001)(66446008)(5660300002)(85182001)(2906002)(36756003)(85202003)(71200400001)(966005)(8936002)(26005)(54906003)(66574015)(122000001)(186003)(38070700005)(76116006)(6486002)(66476007)(66556008)(316002)(66946007)(91956017)(4326008)(1076003)(83380400001)(6916009)(6512007)(64756008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?TXZ0Qlc0ZzEvbDJMTkMwQTM0dVlJSnp5dEIxd1BoVU5zVy9DZForemtlcGZE?=
 =?utf-8?B?Z1JNd0FBOStXbmxkYW5VM2tlVzQrb2pSdlByZXo5V09GSTdmclI4SWo1ekFJ?=
 =?utf-8?B?bXNwaitaYWg3UEsvZjlac2toVWkrQktJRE5sUjlQTW1HbGdUL01vYmJCR09v?=
 =?utf-8?B?SEpoMWRMSTlIUndEWVYxb2EvRW84YmR6cmJPRXVCTEdnbHpON3NpRzlaUWVJ?=
 =?utf-8?B?TXRYSFN6ajVHOURNUS9HL295am0zaU9aVzRJeFkwV29YKzVkSjlFd0dwa09M?=
 =?utf-8?B?NXVSNGFNNXV3cmZUOGlsZlJvdGUyUmdLUWF3YTRoTDl5VTl0NXF1VlA1MmVo?=
 =?utf-8?B?a0l6M01Jc0ZVbzh5dHE0a3pEa2lLQm9lQTN6allSYzNSVURWNVpzVW9kWWZS?=
 =?utf-8?B?N2ZVM0VGa1g2Sy9BOTFINnBDVFo4elQySlNoRlFqSTRTeVczeXVZZmQwcDh1?=
 =?utf-8?B?N2gxc0llV3p4Z3RqbjFydHFnNUVRYVpvaHlyWkdEa0twUTNzTlBOZzgyQ1ZE?=
 =?utf-8?B?S2ZWbVVSRG9LbTRWSFdXaDZhWUZLVFBXL00veThwenB4TmlkL0dVWG5haDdk?=
 =?utf-8?B?aEpSd285L2wzTDRxOGluTDR0YTJxai9EK0NlUXRJVFRJMUdvTXdOQ3ZLNnRU?=
 =?utf-8?B?dEpwMTBOUWYvYlRuZWZKWXhkU2lkTDBxT0RXc2JuUENYdjlhekt2Qkx4TUFK?=
 =?utf-8?B?MkpKazVlbnFpanNqdWd6WUJwdVgzNytiNXdaOE0wT25kdG93TkU0eVEyanN4?=
 =?utf-8?B?ak1kRVI5Z1NhWUVsYi9SR3VHUmF5eFpvV1NjelhhTW45TVcrRlZ3d2lLSHoy?=
 =?utf-8?B?WFZWanAwQ2FLcnpTQTd0SVJyYlhuaHZCQmNLYkR0UVorSUxLa3plSTdvS1BG?=
 =?utf-8?B?MkdISVVUOXduN3F0eWtwUy9FT1UzeUFqR1NhMFI1YllTZnJveGsvU2l3U0VH?=
 =?utf-8?B?TGdxVDBGLzZZMUJPRnNHSDJ6T0dDWCtVOG1hWHFtR2sxdUphNit1SU1PbFNm?=
 =?utf-8?B?eEhGYStXRXNiZ0dicGg4aVcvZ0JKQk55aWxKRXFLeDRMNFl5VVp6aTBYbDBC?=
 =?utf-8?B?amxybk56cXpsNkNubUVjTmRlem5idERleVE3YlRyNm9QblBkN0FIUzlnZS9H?=
 =?utf-8?B?QytDMTNkTE9FTGNWbEd0M282UHpGYktXQ0RwcFhaenpSU0QvT3hWcHZhMHNu?=
 =?utf-8?B?Qk9NV3hvRWdiTUNWZllrdnR3WGVtNFFNd3B3d1F3WGI0NWN0bk96cTlmNzBq?=
 =?utf-8?B?ZGRkNGpKbmlRWE1JRHp1QVovTVRHdVVXWnhqMDh5NHVEWDlORjUzTGpyMzJC?=
 =?utf-8?B?a3E2YWJnckpvdml0eFJ5dXlLVXgwYzJyTmhwbHpTWWJta2pmWEZ2cHgyMDVR?=
 =?utf-8?B?c0VLOXh0YTE0TnQrK29Ub0ZmYjkycC9NcGxlaXM3MlZvcUpwQ09MNmU4UmhR?=
 =?utf-8?B?N041YXlxU3BmUXp1WW5kazdPZUN0amgxZVltQWFHMDQ0cXFvc2hPQ3ArRFY5?=
 =?utf-8?B?ZWp5OThiZEE1YVZGbWhtR092Q01TQXdqQzY4K1dCZmZYVnRaVUpFeVhSSWpG?=
 =?utf-8?B?RFlucWJGTjMzbklJRHJrRklRb25UOEhnazhPNDVzZ2ZxV2FMQmMzN3hDRDBo?=
 =?utf-8?B?RDk4aHVGRmhTOFpRaDk3ZllDc2Y3TFAvdlNRaVg5Q2ltR2RXSUxsRUpveVQ5?=
 =?utf-8?B?NndDRGxFRDNuTWNGVXRQdEsyRVI3TGFoS1lqNnk3NWp4NzN5eUN5MWhKZlhC?=
 =?utf-8?B?c3pETDREREp3WlBQeDNZUU9OUGxFK3I5RGEvak9ua0dBYWlnNVJ6N2hIN3Jz?=
 =?utf-8?B?Z0g3WktpM0tpYUFLMU9oOEF3aVZpaE9nRldFaC9zQmM2d1l0bUMvT3M4cW5T?=
 =?utf-8?B?U2tGWU9qU0wvL0sxMHlwWlk0OHZDYnozOGtBZUFLNEIwR0pGN1JrLzNaUmZF?=
 =?utf-8?B?U2RkSE0zNVprVFM0U2hJWnNWN1oyZ0kvN1lPcDhRTVZib2RSREliZDFaMXUx?=
 =?utf-8?B?aWszSjV6NFN5Rit0TzErMUk3czkwaGVGREY2YzRrWTBJMnhzSi9CaVBYR1k1?=
 =?utf-8?B?TU9BQXVxblZVNW5MSXR2RGJGbVBFam1SMHpYeTVDY3ZiaHROZzJ6c0tGcElI?=
 =?utf-8?B?MVkway9MS1J2Q1lwYjI0WHl6akNjRVR4YVBRUmxuSTVwK3FxaDV3TzloTERW?=
 =?utf-8?B?RG8zY1FGb2o5RVVJWGROamxicEJSM1JwQWtQWmRrZGVodVl4ZmxHRmVpV0ZT?=
 =?utf-8?B?ZllDUDVFQjlxN0tBa25RYnYvSUxYWUhETnpEQ3JqUHdmVENucm4zTEVWVFk4?=
 =?utf-8?B?NTdwNFVVaWFqdGVqdVUyck5JQ0YyaGpjNmx0UGhPb043ZVFFTDlRTmo5VFB0?=
 =?utf-8?Q?pWP8T833p9bM7XRo=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0D5C01FFBD4C8149A7BF0778C3AFD6AB@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44402493-343e-449b-f38b-08da220675dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Apr 2022 13:13:56.8037
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ntNkRiasFq0bnPMv7IvarlD8vpXcJbTNKzsenj5lgBn8An1qQ4zBQ4p+tZmTDt5w6gZqvHpklGmMlZb8e0Hrqg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR03MB8342
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBBcHIgMTgsIDIwMjIgYXQgMDg6MzU6NTdQTSAtMDMwMCwgTHVpeiBBbmdlbG8gRGFy
b3MgZGUgTHVjYSB3cm90ZToNCj4gQ29tcGF0aWJsZSBzdHJpbmdzIGFyZSB1c2VkIHRvIGhlbHAg
dGhlIGRyaXZlciBmaW5kIHRoZSBjaGlwIElEL3ZlcnNpb24NCj4gcmVnaXN0ZXIgZm9yIGVhY2gg
Y2hpcCBmYW1pbHkuIEFmdGVyIHRoYXQsIHRoZSBkcml2ZXIgY2FuIHNldHVwIHRoZQ0KPiBzd2l0
Y2ggYWNjb3JkaW5nbHkuIEtlZXAgb25seSB0aGUgZmlyc3Qgc3VwcG9ydGVkIG1vZGVsIGZvciBl
YWNoIGZhbWlseQ0KPiBhcyBhIGNvbXBhdGlibGUgc3RyaW5nIGFuZCByZWZlcmVuY2Ugb3RoZXIg
Y2hpcCBtb2RlbHMgaW4gdGhlDQo+IGRlc2NyaXB0aW9uLg0KPiANCj4gVGhlIHJlbW92ZWQgY29t
cGF0aWJsZSBzdHJpbmdzIGhhdmUgbmV2ZXIgYmVlbiB1c2VkIGluIGEgcmVsZWFzZWQga2VybmVs
Lg0KPiANCj4gQ0M6IGRldmljZXRyZWVAdmdlci5rZXJuZWwub3JnDQo+IExpbms6IGh0dHBzOi8v
bG9yZS5rZXJuZWwub3JnL25ldGRldi8yMDIyMDQxNDAxNDA1NS5tNHdibXI3dGR6NmhzYTNtQGJh
bmctb2x1ZnNlbi5kay8NCj4gU2lnbmVkLW9mZi1ieTogTHVpeiBBbmdlbG8gRGFyb3MgZGUgTHVj
YSA8bHVpemx1Y2FAZ21haWwuY29tPg0KPiAtLS0NCj4gIC4uLi9kZXZpY2V0cmVlL2JpbmRpbmdz
L25ldC9kc2EvcmVhbHRlay55YW1sICB8IDM1ICsrKysrKysrLS0tLS0tLS0tLS0NCj4gIDEgZmls
ZSBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAyMSBkZWxldGlvbnMoLSkNCg0KSSB0aGluayB0
aGlzIGlzIE9LIG5vdy4gSSdsbCBmb2xsb3cgdXAgd2l0aCB3aGF0ZXZlciByZXBseSBJIGdldCBm
cm9tIFJlYWx0ZWsNCnJlZ2FyZGluZyB0aGUgcmV2aXNpb24gSUQgcmVnaXN0ZXIgdmFsdWVzIGZv
ciBzd2l0Y2hlcyB3ZSBkbyBub3Qgb3duLg0KDQpSZXZpZXdlZC1ieTogQWx2aW4gxaBpcHJhZ2Eg
PGFsc2lAYmFuZy1vbHVmc2VuLmRrPg==
