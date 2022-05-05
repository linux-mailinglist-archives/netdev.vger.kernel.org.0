Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE37751BBB0
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 11:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352145AbiEEJSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 May 2022 05:18:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235961AbiEEJSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 May 2022 05:18:32 -0400
Received: from JPN01-TYC-obe.outbound.protection.outlook.com (mail-tycjpn01on2101.outbound.protection.outlook.com [40.107.114.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 283E44D61B;
        Thu,  5 May 2022 02:14:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kGBylaESe9W4+sE/Uctr1xG+CaMBlbLR1s7tpnhKuRC6xbYZ8XLTi99UJYUrgojQz8r0GZasicoqK58flpsLkYvFv44nJuYAmCQZJywOicvmc3je42acmAVhktvx1bAF+Mgc3iKK9Y78nhpalx5THAacVXl+ll2mE7rhN4J3TdB8qDKrqHtyrnLaPWvqnVPTr6HsSlCzbHc5FiBY6ueMTyjOUgB4dQIXASk3bZ6wp4WK6pBaNRCwvf5H48U75sx2X5/ca1yn2uGs6RQtXvwanzaLKk/A74DRuqSPRrV+wFLHhf1VvLKyn0ScGFLvcUGWZFEAvhiieXKVcd7C9earzg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Yz09ZI4m4mFP5S63eyJF3dwpxI+fjugYY5HVEiA9xLo=;
 b=M9XqNkPZqQQctmILQ0iaDheTcWl3k/L65tKbub6+AGJWV+T9jCDkunaiDlkyncW00qVz4wz0xevGq76yKpeZZuboXaGlMDVthktIhU0xlGhEaNFEHThrICxXoPW/XyKvuXLMHoNfoAkxXlcdga5Pgi01D6HBh3e7gXGAPf93F54cQ5CzydG8oo3qFvBl2dNp5HYTI+z98wLOKukRG/vfP5LinsgXGJkcJFn68Vvypm1RxxzdWImfx1OgbKFO8MnwYvLTGQ5W/vTVJsxWROTUyLvbnkzH1zJ/zgPPKzxpUapfCpbGufAWVRCJQQWOPDIm1NU1PQk8OYPL2Zu89LFyfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=renesas.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Yz09ZI4m4mFP5S63eyJF3dwpxI+fjugYY5HVEiA9xLo=;
 b=hMMAidabiVrmm1gm7oVcT/lI0F8AT5m0y6glW+S0F5MrpEC0wV9nz7sOPXnUVgS89NcvP/7Ee9Sb/IZHNoylSfQtKb3QtqahHBm+zo4CXlragjGB3L1pXX4yhi40Y7PsC7llAUg/zRkHrvB0URoAkN8W22I/jwzK/otPjnRmcE8=
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com (2603:1096:400:de::11)
 by OSAPR01MB2097.jpnprd01.prod.outlook.com (2603:1096:603:1a::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5206.24; Thu, 5 May
 2022 09:14:50 +0000
Received: from TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244]) by TYYPR01MB7086.jpnprd01.prod.outlook.com
 ([fe80::e180:5c8b:8ddf:7244%6]) with mapi id 15.20.5206.027; Thu, 5 May 2022
 09:14:50 +0000
From:   Phil Edworthy <phil.edworthy@renesas.com>
To:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Biju Das <biju.das.jz@bp.renesas.com>,
        Prabhakar Mahadev Lad <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Chris Paterson <Chris.Paterson2@renesas.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        linux-clk <linux-clk@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH 0/9] Add Renesas RZ/V2M Ethernet support
Thread-Topic: [PATCH 0/9] Add Renesas RZ/V2M Ethernet support
Thread-Index: AQHYX8cA0dMANzazQUOW+7qmNSnHrq0PdsOAgABk94CAACT1sA==
Date:   Thu, 5 May 2022 09:14:50 +0000
Message-ID: <TYYPR01MB70867164E2533890E9EF901EF5C29@TYYPR01MB7086.jpnprd01.prod.outlook.com>
References: <20220504145454.71287-1-phil.edworthy@renesas.com>
 <20220504175757.0a3c1a6a@kernel.org>
 <CAMuHMdXKUpHa0SGGQUbepAHoS3evEBSzF4RYqA8B09eq1CtBUw@mail.gmail.com>
In-Reply-To: <CAMuHMdXKUpHa0SGGQUbepAHoS3evEBSzF4RYqA8B09eq1CtBUw@mail.gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=renesas.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2f337a2a-036f-4294-486d-08da2e77b523
x-ms-traffictypediagnostic: OSAPR01MB2097:EE_
x-microsoft-antispam-prvs: <OSAPR01MB20974111521E8CDC733D9E59F5C29@OSAPR01MB2097.jpnprd01.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: abA5ydg3+MdAwQrw0xOvy2HjlL/Fh1oF3kIpoDj0kVNhKcbcaqMa5WPVIcICjcY0qSRLE22XFWPkhN7FSouoASITXZXaV+kVAbiq3YR7BZgNa7aSe1aG2mM8p9MnQCgf0WgGyQFcUBSKw9Li/QwtyhFGrxYZzbmcSGuCaquXi4ynz1KZTIo4DNrU8BCWP9ATxLBRRUSilK+dxU6hpDiu/c0vE7ELwoGYKldLAdQKGil4umBoKucjsaK68TgbQ7WLmGB/1fkliUuO3ScQVUm75qQMGUCyvmaB6TsI6HkjTOveLqSuU1BPo4WZGZe7LOgYMIqcroYIJmlKqUPiZkI+jlmMNn+p2PdeY2ak6gtolMRAa9/TbXsZ+sguuOmAMTIXaKOQSM1icylECIEbLsroVWX01u3GKNvho7NQBYM9CnFSAtiySEdzfJ5TNk5pEQjeYzpmscEe8nf6SKSojBR0OfhmF+CBfgNvFLta6CroQqsDOc4EUwybmpVJ2EbWjS1yO8/o+Zex+9ywhQ6+Zi+cnKBGkogFrel+zGVpioCPexzkfIvi/xpeZ3D3SHjggBvS2MyQYufipKg8d1jx9BQlI3kpA1gP/N6/d9Hz24BUHjpvbtfD7exSnP29n+uziN9Bx6t0rfGZp1ztcatWtlpHOgERygBmvepeKgPTTLHZCskn2gQIUPymfNCx+p8yjod0rff52bNWpHSr72vmpnTKsg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TYYPR01MB7086.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(66556008)(4326008)(66446008)(83380400001)(8676002)(86362001)(26005)(66946007)(66476007)(9686003)(76116006)(44832011)(6506007)(7696005)(53546011)(2906002)(122000001)(8936002)(508600001)(5660300002)(7416002)(55016003)(52536014)(54906003)(33656002)(38100700002)(38070700005)(110136005)(316002)(186003)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?THN4SFY1K0VpcW4xV2Q4MEExWnA0NG9JMDBUSm8wS3JuUGRSQXFKZkpCSDV5?=
 =?utf-8?B?TVR4RUFCLzRKbmxrSjd1TjFRdERHNHdObVBvaVVNenlRR21rQWh4M3dOSi9n?=
 =?utf-8?B?Vyt1aXJoYmc1aUgxci83ZlF5VmFNbXdlQVRnK3FKWkRNVVBTMlczalQ4OGUw?=
 =?utf-8?B?Z0svVk1ZZVZMb3hTOVJqS3N2cXdHVFZKRzhuU2JJZ2R1czZ1UHphNHNMOHBF?=
 =?utf-8?B?REowM2dFSGRlUDh6dEg3bHY0ZTA3TmVIMWt1VlBERTUzUyt1UXBTeWF1Titq?=
 =?utf-8?B?S1VLSEx1SGl5NHdQSEZaeGd3aHV4SEkxSGdWZ0RpUU51K1VnV2lBR0pIL1Nm?=
 =?utf-8?B?NmhKWWE3Q1FzT1NEZzN2S2hvbDZhSlhmcmJxNXZscGtHd0RuMm9pRzdMREI4?=
 =?utf-8?B?ZDFoU20yejJvU2VUaXZtTmYwOEFrcGMwT3g0TUdhd2hvaFd6Q3NicEZMUmNw?=
 =?utf-8?B?MEJHUVk5d2hpS1B1eHhLMW42LzhMbzBPOEtoR1llb1VSVGRydXJuSXVoUEEv?=
 =?utf-8?B?a0JXUlRNS3ltSHJsWXkyWWFXbTR0UERVOEQ4QWw5RGE2aCtsY09oMExiNEhY?=
 =?utf-8?B?NmRpRDJNMUQrWVhMMDBjWURGRUhqSHU5OWFVVGtiUnZYUU5Ic25ZSHZHcFd0?=
 =?utf-8?B?NThrcU5DS0JPZ1lkQWs3MVU2YzRTditQSyt5d2lDdnZ1SU1PZXo3ZXpRQTUv?=
 =?utf-8?B?WkdPMUl5eTJPS2IyamlvazFFM3N0LzJTOGZEcHRsNDZRVHh1dndCY0xpQjJp?=
 =?utf-8?B?N08xenJBeGxjd2Z0K1Q5RzkvY1ZkTUNJK05WdkdMb3FrVEgvK2V4VXZoU0dH?=
 =?utf-8?B?dVcxUWZmVkpoWWtON0dCRnd3Tlh5RkZsT3I4WHFHQklrWk9aSUZkQ1A3aWpJ?=
 =?utf-8?B?b2FhNFF1YSsxWUk5KzczMTQvdVROYkJUemI1a3NKQ0tTZU1LSFJSbEp5Wloz?=
 =?utf-8?B?V2dpV3ZoZ1AxQXNkUElpdkM4dE92R2Vnd0dWZ045RW41SGZlbXNJVTlSTVpi?=
 =?utf-8?B?UTh6cjU3QWhHR09OMXFTVHlrN0FST0xiTFo0b2tXRmxsY1psL0VNemNYdTFi?=
 =?utf-8?B?eTJ4ekppdHFJZ21nSmhFNjUzWDlPbW42cHkyaEFmRWl0SVhkZVRZV3AvOTh2?=
 =?utf-8?B?Q2JVN1JwSmkrNnVPSG9DWW9EOEpMK2VTMG5QSEx6VFNhOHdrUlhOQ0p2NHly?=
 =?utf-8?B?STR0VGVmRjN1QnUwa3p3WTNrZmN1NGFaVENuTEorWE1yM0FUc0JFNkp6NUlB?=
 =?utf-8?B?TU1pd1k4MndPbkgrMUFxSFN5aXVXRENHNVpPM3JDRlZKZzFoNElGNHhNZE1h?=
 =?utf-8?B?RE8yU3pEMUp5NE5oNXRtVTVuMW5uNm16VUp5SmJoY0Z5WFY0aWFaM3FKcFdq?=
 =?utf-8?B?RFhRVmtLaUYxM0M0T2tPZmYyYUIzMjg2WnlNLzBxbVU0VjUxclFVN3BWeHFj?=
 =?utf-8?B?akUvREZZa0FJaU9KUE0zQmIvWG5FT1ZIV0l4UTdDaGpicndpclcyKytsSnZG?=
 =?utf-8?B?M1ZhbERJRWxOdEVyZ1g3RTB1NzAva1E3ekFuUVBCSnNjS3FtWEIzVVFoQkFM?=
 =?utf-8?B?TFZJOXd1OHVVVkgzcXlkYjhVMGZMSisySk50ZWJQWmp4dTVCakVpOG1GdzZE?=
 =?utf-8?B?WDBucUNkVitFZEQwZlQ3bHZGNUZmTmxQYURiVmI2YUVBMVgzcTREVzZ2dHhJ?=
 =?utf-8?B?bUhvOE5zb1JzMXo3UEhUUm83dnY1ck80Y2dQQjEwWnhJcS82cFBZVnBpdVFn?=
 =?utf-8?B?UHBIRGhsS1M1WkVkdVVOaklLRnJzMUI1NjVrMkYzNDVNSFZneWlXOW5nVzNF?=
 =?utf-8?B?TWtrUGZpS3lKL05IWjY5YkQ2SkVXYnZqZmJkTlVSODhrbjRwVVl1V0E5ZkRD?=
 =?utf-8?B?NS9QRzFVOVJyYXo5WE5Wc3p2cFR5a1ZwdUxCY2d4MGZOa0lobjVZWTJkNTd6?=
 =?utf-8?B?TWhHTTdGK2xjTzJnTkdoQVJHa1BzdHBUOWM4anZ3M3BXYlcxUDlWN0ZhejZR?=
 =?utf-8?B?MFdxZXVJUlhjTUxrcktiNVNYZENucTVhUmhtKy9xZEQyN1ExRHJTQ2R6V2xB?=
 =?utf-8?B?TEtIZDBHWENkdDhGaVZ0MU9BQlh6WVB3NGlRMWFya2lrUi9SRnpmN1JUcHBO?=
 =?utf-8?B?TzlWbGFOdDFMZ3g0NWtTZ1VkYVZMUlNiOVFhdGprVnk0VjFoSkZaZ2JKMkZx?=
 =?utf-8?B?VmxaUm03bFJ3UkZJUHU1VEVaSWRxR1B1aEtZbms4M1JkZXN3WnBIclFQbHUv?=
 =?utf-8?B?MENqNC96QnZOVHVuTUJTYVQ1d2FENEtLbmlOV3Z2aFlBZmVkYlJReUlMUE5Q?=
 =?utf-8?B?cnJ3eStSZkpiMzJ3Nk1yRWZhcTBjeEMweHM2ekhGdCtCdU1Cc3NHelZvbk42?=
 =?utf-8?Q?eUIcIEjN69/vpeMI=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TYYPR01MB7086.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2f337a2a-036f-4294-486d-08da2e77b523
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2022 09:14:50.1164
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vUtI/Hk9VbEwwh4ma6RhPq6x/ZznyKqiOxdVkynvj69iLuR3wT8lZhaikD3JHn3Nr2Lqu+Q1c+G5E05RkjDe4CMaTArHMnhNauWSnR7Uq50=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSAPR01MB2097
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgSmFrdWIsIEdlZXJ0LA0KDQpPbiAwNSBNYXkgMjAyMiAwNzo1OSBHZWVydCBVeXR0ZXJob2V2
ZW4gd3JvdGU6DQo+IE9uIFRodSwgTWF5IDUsIDIwMjIgYXQgMjo1OCBBTSBKYWt1YiBLaWNpbnNr
aSB3cm90ZToNCj4gPiBPbiBXZWQsICA0IE1heSAyMDIyIDE1OjU0OjQ1ICswMTAwIFBoaWwgRWR3
b3J0aHkgd3JvdGU6DQo+ID4gPiBUaGUgUlovVjJNIEV0aGVybmV0IGlzIHZlcnkgc2ltaWxhciB0
byBSLUNhciBHZW4zIEV0aGVybmV0LUFWQiwNCj4gPiA+IHRob3VnaCBzb21lIHNtYWxsIHBhcnRz
IGFyZSB0aGUgc2FtZSBhcyBSLUNhciBHZW4yLg0KPiA+ID4gT3RoZXIgZGlmZmVyZW5jZXMgYXJl
Og0KPiA+ID4gKiBJdCBoYXMgc2VwYXJhdGUgZGF0YSAoREkpLCBlcnJvciAoTGluZSAxKSBhbmQg
bWFuYWdlbWVudCAoTGluZSAyKQ0KPiBpcnFzDQo+ID4gPiAgIHJhdGhlciB0aGFuIG9uZSBpcnEg
Zm9yIGFsbCB0aHJlZS4NCj4gPiA+ICogSW5zdGVhZCBvZiB1c2luZyB0aGUgSGlnaC1zcGVlZCBw
ZXJpcGhlcmFsIGJ1cyBjbG9jayBmb3IgZ1BUUCwgaXQNCj4gaGFzDQo+ID4gPiAgIGEgc2VwYXJh
dGUgZ1BUUCByZWZlcmVuY2UgY2xvY2suDQo+ID4gPg0KPiA+ID4gVGhlIGR0cyBwYXRjaGVzIGRl
cGVuZCBvbiB2NCBvZiB0aGUgZm9sbG93aW5nIHBhdGNoIHNldDoNCj4gPiA+ICJBZGQgbmV3IFJl
bmVzYXMgUlovVjJNIFNvQyBhbmQgUmVuZXNhcyBSWi9WMk0gRVZLIHN1cHBvcnQiDQo+ID4gPg0K
PiA+ID4gUGhpbCBFZHdvcnRoeSAoOSk6DQo+ID4gPiAgIGNsazogcmVuZXNhczogcjlhMDlnMDEx
OiBBZGQgZXRoIGNsb2NrIGFuZCByZXNldCBlbnRyaWVzDQo+ID4gPiAgIGR0LWJpbmRpbmdzOiBu
ZXQ6IHJlbmVzYXMsZXRoZXJhdmI6IERvY3VtZW50IFJaL1YyTSBTb0MNCj4gPiA+ICAgcmF2Yjog
U2VwYXJhdGUgdXNlIG9mIEdJQyByZWcgZm9yIFBUTUUgZnJvbSBtdWx0aV9pcnFzDQo+ID4gPiAg
IHJhdmI6IFNlcGFyYXRlIGhhbmRsaW5nIG9mIGlycSBlbmFibGUvZGlzYWJsZSByZWdzIGludG8g
ZmVhdHVyZQ0KPiA+ID4gICByYXZiOiBTdXBwb3J0IHNlcGFyYXRlIExpbmUwIChEZXNjKSwgTGlu
ZTEgKEVycikgYW5kIExpbmUyIChNZ210KQ0KPiBpcnFzDQo+ID4gPiAgIHJhdmI6IFVzZSBzZXBh
cmF0ZSBjbG9jayBmb3IgZ1BUUA0KPiA+ID4gICByYXZiOiBBZGQgc3VwcG9ydCBmb3IgUlovVjJN
DQo+ID4gPiAgIGFybTY0OiBkdHM6IHJlbmVzYXM6IHI5YTA5ZzAxMTogQWRkIGV0aGVybmV0IG5v
ZGVzDQo+ID4gPiAgIGFybTY0OiBkdHM6IHJlbmVzYXM6IHJ6djJtIGV2azogRW5hYmxlIGV0aGVy
bmV0DQo+ID4NCj4gPiBIb3cgYXJlIHlvdSBleHBlY3RpbmcgdGhpcyB0byBiZSBtZXJnZWQ/DQo+
ID4NCj4gPiBJIHRoaW5rIHlvdSBzaG91bGQgZHJvcCB0aGUgZmlyc3QgKGNsaykgcGF0Y2ggZnJv
bSB0aGlzIHNlcmllcyBzbyB3ZQ0KPiA+IGNhbiBhcHBseSB0aGUgc2VyaWVzIHRvIG5ldC1uZXh0
LiBBbmQgcm91dGUgdGhlIGNsayBwYXRjaCB0aHJ1IEdlZXJ0J3MNCj4gPiB0cmVlIHNlcGFyYXRl
bHk/DQo+IA0KPiBTYW1lIGZvciB0aGUgbGFzdCB0d28gRFRTIHBhdGNoZXMsIHRoZXkgc2hvdWxk
IGdvIHRocm91Z2ggdGhlIHJlbmVzYXMtDQo+IGRldmVsIGFuZCBTb0MgdHJlZXMuDQpTb3JyeSwg
SSBtaXN0YWtlbmx5IGFzc3VtZWQgdGhpcyB3YXMgYWxsIGdvaW5nIHZpYSBHZWVydCdzIHRyZWUs
IGJ1dCBvZg0KY291cnNlIGl0J3Mgbm90LiBJJ2xsIHNwbGl0IHRoZSBzZXJpZXMgaW4gdHdvLg0K
DQoNCj4gPiBSaWdodCBub3cgcGF0Y2h3b3JrIHRoaW5rcyB0aGUgc2VyaWVzIGlzIGluY29tcGxl
dGUgYmVjYXVzZSBpdCBoYXNuJ3QNCj4gPiByZWNlaXZlZCBwYXRjaCAxLg0KDQpUaGFua3MNClBo
aWwNCg==
