Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D154B901C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 19:23:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbiBPSXp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 13:23:45 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236822AbiBPSXo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 13:23:44 -0500
Received: from EUR05-VI1-obe.outbound.protection.outlook.com (mail-vi1eur05on2137.outbound.protection.outlook.com [40.107.21.137])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEBEB1F4667;
        Wed, 16 Feb 2022 10:23:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H6x34zvA1ZeVaCmP8X83iD8e4u8iLGX2XDRM72NU8jQF+cUC7Zavcd3n26vrh5h6fJX0gqTY54XZ/P0j+/rNZaIhI/DrhtELfienVQbuTHW3jueQm3MCDlHOKoGekLW9ksDa7Ubx6uptPjAcfXV8phAPAXRH4w2sBC3DlxNR0TEWF8NsFumoRM0Xz3kntUoMZ4tgHszub2WX8WuzA+kGCEVaA2yG9T2k4XA72+J1RxEDkVTFtm4FSlM/jW8UJJm14dqsSSFQpiZae/6+XM54ZKg3C4gPbO7VmcEEGdQeMqKlzvYPk0sL+f/7EjlZEeRKtwAArWFCrq2XUcDU2QnKfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TD9DhZJJeCfD2MepEOOsrqdtcb+L0fwCgSzIPQF6frw=;
 b=f7uzJ4PG4PpGRF/6XnLT+8psnGzX32NXV+RDY5yK42wybXJQDMx1nka4iL5jyjqtsYDgtyZFHWw60jsHTFDpxgJB2ghP1T9wPnhaG+trHlbihhzgaxAW/TrN2wBYKiYVJexaXWF5NHMujf7yoap2fL9qoODqq5nwL0172yxOWDqoqBojMX1ePmqiY8TZrOeBTYDk8NMjDf59If61z+B2xOHdk9n9L2mgFnD7Oh4BHOYeMk9bXrkRJC6YoYQTCi2MP8+RPNac6L/Hr73Opaa6h2iqn8HZvXDlT1awDIrjz0HAgKL5K1MAvPghCzl5bwRses4Sbh/Zi0GBxIEhOH/P9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TD9DhZJJeCfD2MepEOOsrqdtcb+L0fwCgSzIPQF6frw=;
 b=pExbkWRVIJ2wc/CYx1+bCAt0i2KoKMq/+MWWW6Q/EAs5eB7rXYheua6o9PdbQrplFgPpWxqbck/4o2vuO0jg0lh/eM7JkZnGijM8iKmI0Te7jT4kpB3Yn3hqpW9lDvEIJ+fjhKKE+s3RGFSZuUnzrds5OiHstyw2Qpa4vSkTVCY=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DBAPR03MB6501.eurprd03.prod.outlook.com (2603:10a6:10:191::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4975.19; Wed, 16 Feb
 2022 18:23:25 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::6123:22f6:a2a7:5c1e%5]) with mapi id 15.20.4995.016; Wed, 16 Feb 2022
 18:23:25 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michael Rasmussen <MIR@bang-olufsen.dk>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Topic: [PATCH net-next 0/2] net: dsa: realtek: fix PHY register read
 corruption
Thread-Index: AQHYI06+Oi3bmZ4n+EmyFAzgV7y6pg==
Date:   Wed, 16 Feb 2022 18:23:25 +0000
Message-ID: <87k0dusmar.fsf@bang-olufsen.dk>
References: <20220216160500.2341255-1-alvin@pqrs.dk>
        <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>
In-Reply-To: <CAJq09z6Mr7QFSyqWuM1jjm9Dis4Pa2A4yi=NJv1w4FM0WoyqtA@mail.gmail.com>       (Luiz
 Angelo Daros de Luca's message of "Wed, 16 Feb 2022 14:57:11   -0300")
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b186ad79-7c0b-433c-e76c-08d9f1796bea
x-ms-traffictypediagnostic: DBAPR03MB6501:EE_
x-microsoft-antispam-prvs: <DBAPR03MB6501D01F62C3C2A94E75C95383359@DBAPR03MB6501.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: YhL8a6AE7+Wact8rUHsrKYiy628jnOZlqTHST0zMV5xd4AQ5p0Z0JeNcmobwfEru5qZNQoRpDEybQosDTqEWtj8EvxoDnJSnzJHGkHRwu5d2BD12Nd4u64JRju27hzrDNpg/De7YVVx6timoAxxaVged0ilYhSGh324KYgoeYGYhpF01BMEQbZhtt9WZxcX/lal2Zd9kSuGSStbfP/paYnsgPVBOiYs8FZo07qYQc8a8rmr3YNUcAi5putwGrGaQ3eha258QDjlJQ2Sa7NqcJGwkDSNCLJrnFiaf+hvEyfwznrcltIjV84rPeHKzNehZF7w16ek0rzQQ42ol3QJZHIGoI+V2uir+nHV2zO5vDNoi/LeytM3GxdyT9UafuxJEFV5TQ8gYBiNaU/U/IQRR4S+D30JiVY6oDT/4lPHUUqeJLkVzM2qVVqdFbgjr2TM4Hy629InDlr6NHuJzHoc8A1tFT6j7NvtN9txhUCD4pRB1x45rCqvkMwyf+BmiT1rcMlaSVG12/x4tF4+oSn52rWXXxcR18LM0PkN3EajOES7FW4Gf8a6/S6s2m4Jafr0OfU7oDHrI6mqwBn+nml8bsRLrRXewFob9x5M/ArHV7orNmWFEfl7WSqLbVBo+YXbO1ojFtLJvUatwUW/EBcfwQnEQWlnQNk4QMrKuyqa9uMasQ0nY50EC3eSY9pPdm+hRciE4J4jG10PLsZPWyYVjhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(84040400005)(64756008)(66946007)(86362001)(71200400001)(6916009)(508600001)(8676002)(66556008)(6486002)(66476007)(316002)(66446008)(54906003)(5660300002)(91956017)(122000001)(38100700002)(38070700005)(4326008)(8976002)(2906002)(8936002)(83380400001)(85202003)(66574015)(85182001)(6512007)(7416002)(76116006)(6506007)(186003)(2616005)(36756003)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?YzlFb3duaFNzVUg5dXJwRE5raXFlME1HR0NlS1c2Qlh4cnF6VXBkR2x6L3RO?=
 =?utf-8?B?V2NCYW5mMTFmWWNNRTdKTE03Smk2NWNPNTZQMlFlRXhwYnU1QmlGYzhWakpZ?=
 =?utf-8?B?a3JXcWVUaFBYKytGMXlsaTN4K2s5VmMveWJua2hjY0wyVFpFV2tDKzhOL2NN?=
 =?utf-8?B?aUJUWnVOWDlZZnM5OTdjWk9pWFZZOVBYVUdwYXBncUFXZE9PUDlRU2NBTTJl?=
 =?utf-8?B?bGZNbFVCdTRCMUYvV1R1V3FlbXYvTFo2ZnJ3eGVkMXd4ak94NGJCaXd4eFVN?=
 =?utf-8?B?WW12elhtODVaak5CYTR3anJuWE9Idy9xNWNrRGZWNWNxVXhGV2k0TjRyQ21q?=
 =?utf-8?B?NlBpejdNMHU4Q3hOOFBMSGtYQ0h1KysyeHozQ3FrNDhOS29BZWROdFZTT3c4?=
 =?utf-8?B?UDhqTVlPNmo5L1EyaE9XRVg1eEJ1SVJBMCtxYk5UTXU1dHROOHJNbTlaelJC?=
 =?utf-8?B?bDc0dlkya0wyTGpEa2ZPZTE1cHoxYlJwbThGN3RNYmdvVWtTSVRncGIveHpt?=
 =?utf-8?B?Uy9Bck82RnQrYmZLZU92VHJNa3FWaWRHak5ML29MRzdMakdSQmxMZ2hJeXk2?=
 =?utf-8?B?ODdvWWpvbGcvcVV0em1XcGpMUXFrTml4bzFKMUtLT3pNNlY0V0V6QlJhV1Yz?=
 =?utf-8?B?QUxHMXV5Mmg5a2JoTmlGTUNnQWRLRFh3V2JwSG9WeUk2amZINncvOEhqOEt1?=
 =?utf-8?B?YmxKYXpVYnNaRmdWZDkzTXlsZkxqbmZtOFJtaXZraFFvRWQwRkkvZFY0RllC?=
 =?utf-8?B?LzU5Tkh1b1JBb0VRS05sVFpJcjFJb3NROWFhQ1lPL1FwSm4xaU8zZkQxWFZ2?=
 =?utf-8?B?clhSZVlTbysyblhOdkZleDdxU3FZTktTaWgyWG40ZjA3N0VQcUN4cjhLNWVy?=
 =?utf-8?B?WEx5enNiUTV4bEFKQWN6QThicE5iSUNYK3ZWTXVlc1p2c045ZVdLWjBBeGRQ?=
 =?utf-8?B?dHgvOHBRcldSVGVSV3Z1cjRhclR5amJ3OVRnT0ZueStydTRpMkUrK3VNTWty?=
 =?utf-8?B?M09uem04ajBydmhTV0YxZE5DMHhQNXRQQzE1L1ZqNklkSkR6eVhSR2U4bXE2?=
 =?utf-8?B?M0lvTTVHNW4xR0xEQjhGYWUrMi93WFhBZFBHYThoK0toSXNvUFIxcXJZbkpL?=
 =?utf-8?B?YXRMdkNERUFCYUVjKzY5LytIT1BTMUVrSzJRNHVUNnJuOXdjVUpBaWVSVVBr?=
 =?utf-8?B?cEFzdWRleE9aMm1ENkxhNzFFdUR1cElLUVloR05lSUxMZzBqV0lMSnY4UWhq?=
 =?utf-8?B?OFZDcEhJaE1hY01UZkxxTmNtWkdXVFpHenI1Mis1cDN4ZStndmNXUWxwVVBK?=
 =?utf-8?B?eXFXNDRGOG80Q0x0OUJmM1VlWmFwNDUxRExveGd6RHBxdlFkTDl1eFpuM0lT?=
 =?utf-8?B?ZVc5OE1mdlZWa3JJelZTQnZkUGQyQ1FsTUNoU3dhZUZia3gzcXIra3lLYVZ4?=
 =?utf-8?B?TlVyR2Mxd1NpbWpTSmJnWHNBeTNzanpOd0ZWOWV3bWxPTDR0Q3BneTFhVGNk?=
 =?utf-8?B?TzIvaVV2SGpYckhhWTIwUEpTK1htN1NiZlBCM0h0Y2ljdGMvTE9CZUovMEMr?=
 =?utf-8?B?ZzQ4eXBGNVU5UERLRlRYUUJ4K3VGQ2JmeGtPbDROcjZ2d2pSSkpoaE1UbWxi?=
 =?utf-8?B?YzhqVmtsa2JHb2pib01RZTNhbGJHOTBiSEtuaW1rb0xkZHV4UjF6QzhlQ0Vl?=
 =?utf-8?B?cGE3SFpDZnh5eklCOXNZYndIUFhYRTVjOGZqUGlKeklwaHZwRFdyTXhuYU11?=
 =?utf-8?B?RzFqeVBKMXZXMW9QNnBHU0REcjdSeWRCOE5haUNyUENFc0JicVpwd0tYeGk3?=
 =?utf-8?B?Y3p3RUhwY2F5TXJrU0RKaTFDTEZYOXNPeThFSy93Q21NZCt1TUZITENhamR3?=
 =?utf-8?B?cUQyRWdMN2FFV2ViZU5LRi91ajFlenlDNHNiYVE5U0NWcFpTRnp6MGxFWkMw?=
 =?utf-8?B?Tk1hRm04MkU4RWVWY3F1aDZYaXJ0MlNDQjAzakJzdWVRNWdGTHhUTWVCTjEw?=
 =?utf-8?B?REFVd1oxc1F4OXJZcWxJNFVHZnBXY2FldlpwOEEvUWV4Uko0dTlOb2RZdk9G?=
 =?utf-8?B?Z0kwOUdMaDdXNnlqb2hHMTkyeTgrbGxqWWxXbXprblpQd1FCdWJRb1VLSzNp?=
 =?utf-8?B?eTc5eXNGeHJNdXYvMGx6bit2dEw4OWdvN0tjNSs5KzJTc256SENTMCtWa1Bt?=
 =?utf-8?Q?F3xiEDjbD5FcFFYlovYfuLA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <99A4BE1DC0C83B4186DBFB0DEBB1861E@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b186ad79-7c0b-433c-e76c-08d9f1796bea
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2022 18:23:25.2123
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nASQCTWWziME6lV0vSDNtZbE7PJdAWHdg+i7M73t8NPuVNIEax9BsG5v1KC40ah4PSqi+ZZGg+qikSRW68ecaA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6501
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
Cj4+IFRoZXNlIHR3byBwYXRjaGVzIGZpeCB0aGUgaXNzdWUgcmVwb3J0ZWQgYnkgQXLEsW7DpyB3
aGVyZSBQSFkgcmVnaXN0ZXINCj4+IHJlYWRzIHNvbWV0aW1lcyByZXR1cm4gZ2FyYmFnZSBkYXRh
Lg0KPj4NCj4+IE1BSU5UQUlORVJTOiBQbGVhc2UgY2FuIHlvdSBoZWxwIG1lIHdpdGggdGhlIHRh
cmdldHRpbmcgb2YgdGhlc2UgdHdvDQo+PiBwYXRjaGVzPyBUaGlzIGJ1ZyBpcyBwcmVzZW50IGNh
LiA1LjE2LCB3aGVuIHRoZSBTTUkgdmVyc2lvbiBvZiB0aGUNCj4+IHJ0bDgzNjVtYiBkcml2ZXIg
d2FzIGludHJvZHVjZWQuIEJ1dCBub3cgaW4gbmV0LW5leHQgd2UgaGF2ZSB0aGUgTURJTw0KPj4g
aW50ZXJmYWNlIGZyb20gTHVpeiwgd2hlcmUgdGhlIGlzc3VlIGlzIGFsc28gcHJlc2VudC4gSSBh
bSBzZW5kaW5nIHdoYXQNCj4+IEkgdGhpbmsgaXMgYW4gaWRlYWwgcGF0Y2ggc2VyaWVzLCBidXQg
c2hvdWxkIEkgc3BsaXQgaXQgdXAgYW5kIHNlbmQgdGhlDQo+PiBTTUktcmVsYXRlZCBjaGFuZ2Vz
IHRvIG5ldCBhbmQgdGhlIE1ESU8gY2hhbmdlcyB0byBuZXQtbmV4dD8gSWYgc28sIGhvdw0KPj4g
d291bGQgSSBnbyBhYm91dCBzcGxpdHRpbmcgaXQgd2hpbGUgcHJldmVudGluZyBtZXJnZSBjb25m
bGljdHMgYW5kIGJ1aWxkDQo+PiBlcnJvcnM/DQo+Pg0KPj4gRm9yIG5vdyBJIGFtIHNlbmRpbmcg
aXQgdG8gbmV0LW5leHQgc28gdGhhdCB0aGUgd2hvbGUgdGhpbmcgY2FuIGJlDQo+PiByZXZpZXdl
ZC4gSWYgaXQncyBhcHBsaWVkLCBJIHdvdWxkIGdsYWRseSBiYWNrcG9ydCB0aGUgZml4IHRvIHRo
ZSBzdGFibGUNCj4+IHRyZWUgZm9yIDUuMTYsIGJ1dCBJIGFtIHN0aWxsIGNvbmZ1c2VkIGFib3V0
IHdoYXQgdG8gZG8gZm9yIDUuMTcuDQo+Pg0KPj4gVGhhbmtzIGZvciB5b3VyIGhlbHAuDQo+Pg0K
Pj4NCj4+IEFsdmluIMWgaXByYWdhICgyKToNCj4+ICAgbmV0OiBkc2E6IHJlYWx0ZWs6IGFsbG93
IHN1YmRyaXZlcnMgdG8gZXh0ZXJuYWxseSBsb2NrIHJlZ21hcA0KPj4gICBuZXQ6IGRzYTogcmVh
bHRlazogcnRsODM2NW1iOiBzZXJpYWxpemUgaW5kaXJlY3QgUEhZIHJlZ2lzdGVyIGFjY2Vzcw0K
Pj4NCj4+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLW1kaW8uYyB8IDQ2ICsrKysr
KysrKysrKysrKysrKysrKy0NCj4+ICBkcml2ZXJzL25ldC9kc2EvcmVhbHRlay9yZWFsdGVrLXNt
aS5jICB8IDQ4ICsrKysrKysrKysrKysrKysrKysrKy0tDQo+PiAgZHJpdmVycy9uZXQvZHNhL3Jl
YWx0ZWsvcmVhbHRlay5oICAgICAgfCAgMiArDQo+PiAgZHJpdmVycy9uZXQvZHNhL3JlYWx0ZWsv
cnRsODM2NW1iLmMgICAgfCA1NCArKysrKysrKysrKysrKysrLS0tLS0tLS0tLQ0KPj4gIDQgZmls
ZXMgY2hhbmdlZCwgMTI0IGluc2VydGlvbnMoKyksIDI2IGRlbGV0aW9ucygtKQ0KPj4NCj4+IC0t
DQo+PiAyLjM1LjANCj4+DQo+DQo+IFRoYW5rcyBmb3IgdGhlIGZpeCwgQWx2aW4uDQo+DQo+IEkg
c3RpbGwgZmVlbCBsaWtlIHdlIGFyZSB0cnlpbmcgdG8gZ28gYXJvdW5kIGEgcmVnbWFwIGxpbWl0
YXRpb24NCj4gaW5zdGVhZCBvZiBmaXhpbmcgaXQgdGhlcmUuIElmIHdlIGNvbnRyb2wgcmVnbWFw
IGxvY2sgKHdlIGNhbiBkZWZpbmUgYQ0KPiBjdXN0b20gbG9jay91bmxvY2spIGFuZCBjcmVhdGUg
bmV3IHJlZ21hcF97cmVhZCx3cml0ZX1fbm9sb2NrDQo+IHZhcmlhbnRzLCB3ZSdsbCBqdXN0IG5l
ZWQgdG8gbG9jayB0aGUgcmVnbWFwLCBkbyB3aGF0ZXZlciB5b3UgbmVlZCwNCj4gYW5kIHVubG9j
ayBpdC4NCg0KQ2FuIHlvdSBzaG93IG1lIHdoYXQgdGhvc2UgcmVnbWFwX3tyZWFkLHdyaXRlfV9u
b2xvY2sgdmFyaWFudHMgd291bGQNCmxvb2sgbGlrZSBpbiB5b3VyIGV4YW1wbGU/IEFuZCB3aGF0
IGFib3V0IHRoZSBvdGhlciByZWdtYXBfIEFQSXMgd2UgdXNlLA0KbGlrZSByZWdtYXBfcmVhZF9w
b2xsX3RpbWVvdXQsIHJlZ21hcF91cGRhdGVfYml0cywgZXRjLiAtIGRvIHlvdSBwcm9wb3NlDQp0
byByZWltcGxlbWVudCBhbGwgb2YgdGhlc2U/DQoNCj4NCj4gQlRXLCBJIGJlbGlldmUgdGhhdCwg
Zm9yIHJlYWx0ZWstbWRpbywgYSByZWdtYXAgY3VzdG9tIGxvY2sgbWVjaGFuaXNtDQo+IGNvdWxk
IHNpbXBseSB1c2UgbWRpbyBsb2NrIHdoaWxlIHJlYWx0ZWstc21pIGFscmVhZHkgaGFzIHByaXYt
PmxvY2suDQoNCkhtbSBPSy4gQWN0dWFsbHkgSSdtIGEgYml0IGNvbmZ1c2VkIGFib3V0IHRoZSBt
ZGlvX2xvY2s6IGNhbiB5b3UgZXhwbGFpbg0Kd2hhdCBpdCdzIGd1YXJkaW5nIGFnYWluc3QsIGZv
ciBzb21lb25lIHVuZmFtaWxpYXIgd2l0aCBNRElPPyBDdXJyZW50bHkNCnJlYWx0ZWstbWRpbydz
IHJlZ21hcCBoYXMgYW4gYWRkaXRpb25hbCBsb2NrIGFyb3VuZCBpdCAoZGlzYWJsZV9sb2NraW5n
DQppcyAwKSwgc28gd2l0aCB0aGVzZSBwYXRjaGVzIGFwcGxpZWQgdGhlIG51bWJlciBvZiBsb2Nr
cyByZW1haW5zIHRoZQ0Kc2FtZS4NCg0KcHJpdi0+bG9jayBpcyBhIHNwaW5sb2NrIHdoaWNoIGlz
IGluYXBwcm9wcmlhdGUgaGVyZS4gSSdtIG5vdCByZWFsbHkNCnN1cmUgd2hhdCB0aGUgcG9pbnQg
b2YgaXQgaXMsIGJlc2lkZXMgdG8gaGFuZGxlIHVubG9ja2VkIGNhbGxzIHRvIHRoZQ0KX25vYWNr
IGZ1bmN0aW9uLiBJdCBtaWdodCBiZSByZW1vdmFibGUgYWx0b2dldGhlciBidXQgSSB3b3VsZCBw
cmVmZXIgbm90DQp0byB0b3VjaCBpdCBmb3IgdGhpcyBzZXJpZXMuDQoNCktpbmQgcmVnYXJkcywN
CkFsdmlu
