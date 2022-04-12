Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AD304FE2C0
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235997AbiDLNdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355952AbiDLNdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:33:17 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2093.outbound.protection.outlook.com [40.107.20.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CED110FE0;
        Tue, 12 Apr 2022 06:30:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lnanwF4mapjCHH+31JVd0tf7v7RXiQ8MWu+hoX7dmAYrUPufuf1rkdeiHjqP8+YLowp/5M2gnSLuVfT8XqWH4Gqihb7SfOB87f/bEO9M4opvH4jv4YRgf4imm+xoUaMs3vrt7uMIUOuxQ37wmoQ8SyjszylBFV3wHJPvGRb6C9qtRBFCxvOMobTLFZy8mMljAUsOHttHSJwsekl6pztfYwoGN41+ZL6Jsr7tP6iXRMvAB3zNkX7EON3gF/ko6fxEAZfPcSU4SUQEMAkTAm+14RxT57rhDlphtmZ+SCNG2DJ9OxshtGhQJf5IuOmhuRdi9rd6cDLkkiiNMQUSGHiePw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aMYHymg0b2ROtlfT6Iv2if1XZvtAmfmRhLrNYFFpM9s=;
 b=EStHDHJxHRJ1/3rWLsooW2rcXbT9BxB1aDvoBQhGZl7o2KaQtNqFNSlaBnH8riJLhikhPCQ+ljaCOB04gDncsjuAxBGfIStUFBAiDQPvW0B/GmdoZnbr/hKsxYqroyF+iRogSlPhhDwB1IyZtZ21+dOU227pI/YvzbHLb9NMwvta3ND4dRcwboIdURDtmMrS+vhaPCDVwg/upaFeyGsGyJ4P7+IIru4kW+dVXBAUvjwkgQ9POHvnAxcdEijc9ilCEeQTiVY+I2tzSB1MJA7RYS5SiF9c6J4/CTPl52mFwOwACID5HE6jZ+VurBcQ0dnP+BFzAqwRcR1qzwppSo972g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aMYHymg0b2ROtlfT6Iv2if1XZvtAmfmRhLrNYFFpM9s=;
 b=TZrTdWP6TGadOnBhZ2BUNfamNYIag2amklviOAlTQDnAqk30aOxOR7qtBvJLlhjKZKI1zCHsfVT+HVMmvZTfjRQchtBoa+kFyTrnSsyLC54ACxch/vu1QjHwwTntLHPqEW3CpEtJzaA8PWHT6KqMUw+2v9wUdFHWHVDMEPCDFxg=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DB6PR03MB3079.eurprd03.prod.outlook.com (2603:10a6:6:35::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Tue, 12 Apr
 2022 13:30:56 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::a443:52f8:22c3:1d82%3]) with mapi id 15.20.5144.030; Tue, 12 Apr 2022
 13:30:56 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Topic: [PATCH net-next] net: dsa: realtek: add compatible strings for
 RTL8367RB-VB
Thread-Index: AQHYTnGJ5PP7ok0nLUG60UBEzGR+wQ==
Date:   Tue, 12 Apr 2022 13:30:56 +0000
Message-ID: <20220412133055.vmzz2copvu2qzzin@bang-olufsen.dk>
References: <20220411210406.21404-1-luizluca@gmail.com>
 <YlTFRqY3pq84Fw1i@lunn.ch>
 <CAJq09z7CDbaFdjkmqiZsPM1He4o+szMEJANDiaZTCo_oi+ZCSQ@mail.gmail.com>
 <YlVz2gqXbgtFZUhA@lunn.ch>
In-Reply-To: <YlVz2gqXbgtFZUhA@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 76932508-e228-4463-e32b-08da1c88ac93
x-ms-traffictypediagnostic: DB6PR03MB3079:EE_
x-microsoft-antispam-prvs: <DB6PR03MB30798120D649546A90C4A12E83ED9@DB6PR03MB3079.eurprd03.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WfJpVlV2ri4Vdr59Lei8U6gBpSV4jhwtuv0/6A8s5GibJKGgoKZrwlG9T+r4XuqzLucIK+cN7dOhV/yboAXYeCKxxZbjEbZM3yV0F39mQDET69tfibcf/E6G36uU6czWOmchpFFodOArAxtAEDU1oYccQGFiOm599EaeJJLb0Qtp4vh0IEqbJYemFk/vdDee5jUswmt7XJgF1SyXC0jhkFaWoZtxZms1cYAVovoqvN+p29jsKOvCB3reqnglDCoAyXHpaIckSBgBFlc/luF2a/HQF1/thQqDg7QM3l/eplW/3T8jACfSuYq2f2s9xK9nAZKLJWRgZXZc6y5Q0rv+ffi5uWJICjWo+N8yxWUEtSqsYq+nOQjbSXC2pJDOTwPBonIRHiiotE7bh122VuvCLepfQX/i3x44vuWY2kGVQ2HfJi5HoAPbokQHDSIqcxYrWgTJex1RsFBnk71b+0qgUr2I1z5mEWTNmddkdKzT1Rp2u0hZkYparF8uW+UZ6s6LfaKtYHdJoQjyCtN5UYrSO3cuJ6my+QW2SqXprflgMdMFdYc7zEqqRadfPZEQxq0g1LeBrQFvdbYctF2jpcrlLTvJLW0n1xAWepAr/f8F/gIIpSbdbkCyzVeNlB7tavRw637CMSh/UW4BnjcqLeuF/linGdIflORWJvDCEmdjimIp5yPHo76bymr9Zel8DELECaY/01RMFqCcQD3g8Psnrw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(4326008)(66556008)(6506007)(5660300002)(8676002)(66946007)(6916009)(76116006)(54906003)(86362001)(36756003)(2906002)(66476007)(122000001)(7416002)(1076003)(66446008)(64756008)(85202003)(6512007)(38070700005)(8936002)(508600001)(2616005)(186003)(71200400001)(85182001)(8976002)(6486002)(26005)(83380400001)(38100700002)(91956017)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MTd6UGhtVnRoY2tsbk9vRWVTMUM5cVNNdUZ3UktYcURVcXFGZ1cxMklkdkUr?=
 =?utf-8?B?cm85RXFYNFBRTjBjZ0Z4cXZ0UExnMFdpZklkTEIxbGx6SGZJVThVNTV2ZlBx?=
 =?utf-8?B?R2p1OURmK24wRnJ0ZHM5UEpic1k4VmM4U0lWZE8xVXBOMHFINmNHSG0vc3dD?=
 =?utf-8?B?S1lhYWVvaEFVVFUvcGJOT1l5TzN3YW42NyttMHhycVRUTWlOWis2VlEyR0pQ?=
 =?utf-8?B?UEdNbE9EWThscm90Q1lHYlJDTUlWbjBCOXBidnl2UDNKWDJHbDMvTXZOa0Zv?=
 =?utf-8?B?Nk9RT0JQdm1iSllPSjQvQytZVjF3aVZEMEEwMnl3NzJzRkQ3N3FGV1FaMVpP?=
 =?utf-8?B?ZmJHQUNzN0JUZEFGNC9GeXJPUkhwNVhmdGFpVUg4czZrTmF6dUwxaFdLRVZT?=
 =?utf-8?B?QUhmMFlQd01ITHNISTdzdzRSNWN3Mjd5OGRXNjRHdERnQnMvMm1UYXIvVDh6?=
 =?utf-8?B?UTF5UENsMFVpY2thc2RhMXNlMC9GRUJtak1ES1JFalBnd0QxRVBxYzlWMDlV?=
 =?utf-8?B?bi9INXBQK1FMVWdFSnFielQ4cXNtNWhIVkFTeEl5WlE3bXlDZXlXTTQyOVMv?=
 =?utf-8?B?WDJGUkNUZHhkaDFtRlZHcEludXA4aGgyc0dIYStCdUJycGNGd2pnWU1jczA5?=
 =?utf-8?B?RWJETStyQlgvck0wNXV5UzVoUEF5MXZieE16Z1hRMEJYSU1wK0tkODQrblRw?=
 =?utf-8?B?Z1hRcDhJeHIxMkY3WjBUUjV4dXlZeVNrQ2tmU2ZyK3phbis4Tk1mMUUyd2lW?=
 =?utf-8?B?bHA2cUpIc3BuaWx0ZHRobzBqY1c3MWlGYlQyRFF5OTJ0TkduY094ZU42dDNL?=
 =?utf-8?B?TElEZHJiUERVZm52b1FlQnJ6SzFqZngwYmwwcE9sUmJFb0pQK0pwN0VtbHBv?=
 =?utf-8?B?dndMbHV1VGh4cEd0WElicE1YM3YzK0hGUmVtem52alZJREtZVkJIeGhaM09x?=
 =?utf-8?B?cjJKWmlUUjF0cTZrZkNOQW5zMXlVYzdNejBGd3JNdC9Jb0xERVNBZUxtMkNL?=
 =?utf-8?B?Zm9pVGpwcmpBSVpPSkYyTlhmUWlhd3A4Q215NzFScVd6NVVRZk9vZ09vRkp5?=
 =?utf-8?B?VUJJK3VwWWVBMFcreThVcytINWR6aXNNYmdMczlySkNtaFR3b0Z5a3drWU1W?=
 =?utf-8?B?WmpUWjJoenZSRGNWUVB6V1VvQ3gvdzNwODRIdjdqenZ4MVkvaXNOTmY0MDJk?=
 =?utf-8?B?MTF3OFdEYzJSM2sydGtLVUpXd3dXbDQ5TDdVUDRLUzVaaS9qTk9oL1BpSXFT?=
 =?utf-8?B?c3h5dysvU2Q0REkyUzBFbWRUTkNTc3BBeU84dVZzQmYydE14bFFmTkVUbS93?=
 =?utf-8?B?cHo3WDluUDZEMGszUnZuRmh5TnlZb1RpS09mcnJMSjV6YzIyL3hzdGlaZWhs?=
 =?utf-8?B?NXRBZU43M2xYa0lkaHdaS2FncS9IRk12bjhoTzFuSURZRnIvdjBYL042SHlZ?=
 =?utf-8?B?Z1lPZkgrQ2lmMXJmQVhxei8yVUhZa1pGYzFHejREdDNjalM5eW1BeW5YOVpZ?=
 =?utf-8?B?QllmNUhNY0s0UnBGaDdPNllIK3k1UmVKZk9lbDVQUkgzZWN2WmUxZzU5UnEr?=
 =?utf-8?B?QndqdlFYS3NORGJkNDBwTWZXVWZJd2dkNEtTdm5KUmxzUEZPcVluZzBpSkJO?=
 =?utf-8?B?bTJURWN6RlkrZEQ1THVGZkI5djU5UXB2eTg5YlFFakt2TWxIM1ZsYUtSNmxD?=
 =?utf-8?B?ZGRBYTc0T2h5cGo0WlE4L2QvUVJ3UTJoMjlHeXhhbFQ4KzVnaFZBNXFudEEx?=
 =?utf-8?B?VFdpSFJ5T3RCckxMd0krdEVRem1xZzEyem1KSzMwdEpBM05KRnJtQTdUMWp2?=
 =?utf-8?B?OU83ZzJBMytHVm5tTjJqSDVodCtQRVhBeDR2d281aXBIODJia29qYkJDUXRJ?=
 =?utf-8?B?QVNrRFhuTy94VTZLTktWNkpKdWRzRTVMdEw5NWQ2djRWOGZoL0VBVTN3UWJN?=
 =?utf-8?B?YTFuUDNmV0x4Wm5TRElCZTNvdVRBWUhtaytINmo2RHNTeEQ3RUM5NEUzSDU2?=
 =?utf-8?B?N3NPZk9ON1RpZTE2UnFDVldSMFdXZ0JTd1NWTHlyR1ovYzhKemcvRC9HbHNi?=
 =?utf-8?B?TGYzWFAvdm42U3krSGdQSnRCN0ZuRHYyU29IMXdsNmxGbmswdndDUHpjdWhQ?=
 =?utf-8?B?ME9oL0JpeVQySlJLRy92ZWdwVHRiZFZQbEtJWlpOZkxYOWF3VHFZdUtHY3B6?=
 =?utf-8?B?ZnpyaVlRNklyd1QwbCtVT082ajVUNlJzY08rR0NxQmp6R1MxV0ZXd3ZDOG5R?=
 =?utf-8?B?bmoyclQ3T3RjTXY2TnQyZDZTcTVuZ3JodUNzRVVUemtLNkNyOG1BV09lWDJq?=
 =?utf-8?B?ZEtnVWRkQTBYQ3gvS2tTaGJLUjY0RGpZZVNSR3BxbFRuL0p2SFVPVldlN2xE?=
 =?utf-8?Q?nzEOOdWgCmIqDDZE=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <DD17DFA6AF20C04C8BF75D18E3B2CE86@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76932508-e228-4463-e32b-08da1c88ac93
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Apr 2022 13:30:56.2068
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: c31nnqkq06QCuUFAKH+STz043UwJvnw3alZCohQMviR+NeQ4UiSt74JFrRt+9Styux1qmFuMrRkBFnQ8wOfhfw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR03MB3079
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBBcHIgMTIsIDIwMjIgYXQgMDI6NDM6MDZQTSArMDIwMCwgQW5kcmV3IEx1bm4gd3Jv
dGU6DQo+IE9uIFR1ZSwgQXByIDEyLCAyMDIyIGF0IDAxOjEyOjUxQU0gLTAzMDAsIEx1aXogQW5n
ZWxvIERhcm9zIGRlIEx1Y2Egd3JvdGU6DQo+ID4gPiBPbiBNb24sIEFwciAxMSwgMjAyMiBhdCAw
NjowNDowN1BNIC0wMzAwLCBMdWl6IEFuZ2VsbyBEYXJvcyBkZSBMdWNhIHdyb3RlOg0KPiA+ID4g
PiBSVEw4MzY3UkItVkIgd2FzIG5vdCBtZW50aW9uZWQgaW4gdGhlIGNvbXBhdGlibGUgdGFibGUs
IG5vciBpbiB0aGUNCj4gPiA+ID4gS2NvbmZpZyBoZWxwIHRleHQuDQo+ID4gPiA+DQo+ID4gPiA+
IFRoZSBkcml2ZXIgc3RpbGwgZGV0ZWN0cyB0aGUgdmFyaWFudCBieSBpdHNlbGYgYW5kIGlnbm9y
ZXMgd2hpY2gNCj4gPiA+ID4gY29tcGF0aWJsZSBzdHJpbmcgd2FzIHVzZWQgdG8gc2VsZWN0IGl0
LiBTbywgYW55IGNvbXBhdGlibGUgc3RyaW5nIHdpbGwNCj4gPiA+ID4gd29yayBmb3IgYW55IGNv
bXBhdGlibGUgbW9kZWwuDQo+ID4gPg0KPiA+ID4gTWVhbmluZyB0aGUgY29tcGF0aWJsZSBzdHJp
bmcgaXMgcG9pbnRsZXNzLCBhbmQgY2Fubm90IGJlIHRydXN0ZWQuIFNvDQo+ID4gPiB5ZXMsIHlv
dSBjYW4gYWRkIGl0LCBidXQgZG9uJ3QgYWN0dWFsbHkgdHJ5IHRvIHVzZSBpdCBmb3IgYW55dGhp
bmcsDQo+ID4gPiBsaWtlIHF1aXJrcy4NCj4gPiANCj4gPiANCj4gPiBUaGFua3MsIEFuZHJldy4g
VGhvc2UgY29tcGF0aWJsZSBzdHJpbmdzIGFyZSBpbmRlZWQgdXNlbGVzcyBmb3Igbm93Lg0KPiA+
IFRoZSBkcml2ZXIgcHJvYmVzIHRoZSBjaGlwIHZhcmlhbnQuIE1heWJlIGluIHRoZSBmdXR1cmUs
IGlmIHJlcXVpcmVkLA0KPiA+IHdlIGNvdWxkIHByb3ZpZGUgYSB3YXkgdG8gZWl0aGVyIGZvcmNl
IGEgbW9kZWwgb3IgbGV0IGl0IGF1dG9kZXRlY3QgYXMNCj4gPiBpdCBkb2VzIHRvZGF5Lg0KPiAN
Cj4gVGhlIHByb2JsZW0gaXMsIHlvdSBoYXZlIHRvIGFzc3VtZSBzb21lIHBlcmNlbnRhZ2Ugb2Yg
c2hpcHBlZCBEVCBibG9icw0KPiBoYXZlIHRoZSB3cm9uZyBjb21wYXRpYmxlIHN0cmluZywgYnV0
IHdvcmsgYmVjYXVzZSBpdCBpcyBub3QgYWN0dWFsbHkNCj4gdXNlZCBpbiBhIG1lYW5pbmdmdWwg
d2F5LiBUaGlzIGlzIHdoeSB0aGUgY291cGxlIG9mIGRvemVuIE1hcnZlbGwNCj4gc3dpdGNoZXMg
aGF2ZSBqdXN0IDMgY29tcGF0aWJsZSBzdHJpbmdzLCB3aGljaCBpcyBlbm91Z2ggdG8gZmluZCB0
aGUNCj4gSUQgcmVnaXN0ZXJzIHRvIGlkZW50aWZ5IHRoZSBhY3R1YWwgc3dpdGNoLiBUaGUgdGhy
ZWUgY29tcGF0aWJsZXMgYXJlDQo+IHRoZSBuYW1lIG9mIHRoZSBsb3dlc3QgY2hpcCBpbiB0aGUg
ZmFtaWx5IHdoaWNoIGludHJvZHVjZWQgdG8gbG9jYXRpb24NCj4gb2YgdGhlIElEIHJlZ2lzdGVy
Lg0KDQpSaWdodCwgdGhpcyB3YXMgYmFzaWNhbGx5IHRoZSBvcmlnaW5hbCBiZWhhdmlvdXI6DQoN
Ci0gcmVhbHRlayxydGw4MjY1bWIgLT4gdXNlIHJ0bDgzNjVtYi5jIHN1YmRyaXZlcg0KLSByZWFs
dGVrLHJ0bDgzNjZyYiAtPiB1c2UgcnRsODM2NnJiLmMgc3ViZHJpdmVyIChkaWZmZXJlbnQgZmFt
aWx5IHdpdGggZGlmZmVyZW50IHJlZ2lzdGVyIGxheW91dCkNCg0KV2UgdGhlbiBjaGVjayBhIGNo
aXAgSUQvdmVyc2lvbiByZWdpc3RlciBhbmQgc3RvcmUgdGhhdCBpbiB0aGUgZHJpdmVyLXByaXZh
dGUNCmRhdGEsIGluIGNhc2Ugb2YgcXVpcmtzIG9yIGRpZmZlcmVudCBiZWhhdmlvdXJzIGJldHdl
ZW4gY2hpcHMgaW4gdGhlIHNhbWUNCmZhbWlseS4NCg0KSSB0aGluayBBbmRyZXcgaGFzIGEgcG9p
bnQgdGhhdCBhZGRpbmcgbW9yZSBjb21wYXRpYmxlIHN0cmluZ3MgaXMgbm90IHJlYWxseQ0KZ29p
bmcgdG8gYWRkIGFueSB0YW5naWJsZSBiZW5lZml0LCBkdWUgdG8gdGhlIGFib3ZlIGJhaHZpb3Vy
LiBQZW9wbGUgY2FuIGVxdWFsbHkNCndlbGwganVzdCBwdXQgb25lIG9mIHRoZSBhYm92ZSB0d28g
Y29tcGF0aWJsZSBzdHJpbmdzLg0KDQo+IA0KPiA+IFRoZXJlIGlzIG5vICJmYW1pbHkgbmFtZSIg
Zm9yIHRob3NlIGRldmljZXMuIFRoZSBiZXN0IHdlIGhhZCB3YXMNCj4gPiBydGw4MzY3YyAod2l0
aCAiYyIgcHJvYmFibHkgbWVhbmluZyAzcmQgZmFtaWx5KS4gSSBzdWdnZXN0ZWQgcmVuYW1pbmcN
Cj4gPiB0aGUgZHJpdmVyIHRvIHJ0bDgzNjdjIGJ1dCwgaW4gdGhlIGVuZCwgd2Uga2VwdCBpdCBh
cyB0aGUgZmlyc3QNCj4gPiBzdXBwb3J0ZWQgZGV2aWNlIG5hbWUuIE15IHBsYW4gaXMsIGF0IGxl
YXN0LCB0byBhbGxvdyB0aGUgdXNlciB0bw0KPiA+IHNwZWNpZnkgdGhlIGNvcnJlY3QgbW9kZWwg
d2l0aG91dCBrbm93aW5nIHdoaWNoIG1vZGVsIGl0IGlzIGVxdWl2YWxlbnQNCj4gPiB0by4NCj4g
DQo+IEluIG9yZGVyIHdvcmRzLCB5b3UgYXJlIHF1aXRlIGhhcHB5IHRvIGFsbG93IHRoZSBEVCBh
dXRob3IgdG8gZ2V0IGlzDQo+IHdyb25nLCBhbmQgZG8gbm90IGNhcmUgaXQgaXMgd3JvbmcuIFNv
IHRoZSBwZXJjZW50YWdlIG9mIERUIGJsb2JzIHdpdGgNCj4gdGhlIHdyb25nIGNvbXBhdGlibGUg
d2lsbCBnbyB1cCwgbWFraW5nIGl0IGV2ZW4gbW9yZSB1c2VsZXNzLg0KPiANCj4gSXQgaXMgYWxz
byBzb21ldGhpbmcgeW91IGNhbm5vdCByZXRyb3NwZWN0aXZlbHkgbWFrZSB1c2VmdWwsIGJlY2F1
c2UNCj4gb2YgYWxsIHRob3NlIGJyb2tlbiBEVCBibG9icy4NCg0KSSB0aGluayBMdWl6IGlzIHNh
eWluZyBoZSB3YW50cyB0byBhbGxvdyBkZXZpY2UgdHJlZSBhdXRob3JzIHRvIHdyaXRlDQoicmVh
bHRlayxydGw4MzY3cmIiIGlmIHRoZWlyIGhhcmR3YXJlIHJlYWxseSBkb2VzIGhhdmUgYW4gUlRM
ODM2N1JCIHN3aXRjaCBhbmQNCm5vdCBhbiBSVEw4MzY1TUIsIHJhdGhlciB0aGFuIHdyaXRpbmcg
InJlYWx0ZWsscnRsODM2NW1iIi4gQnV0IGFuIGVudGVycHJpc2luZw0KZGV2aWNlIHRyZWUgYXV0
aG9yIGNvdWxkIGp1c3QgYXMgd2VsbCB3cml0ZToNCg0KCSBjb21wYXRpYmxlID0gInJlYWx0ZWss
cnRsODM2N3JiIiwgInJlYWx0ZWsscnRsODM2NW1iIjsNCg0KLi4uIHdoaWNoIHdvdWxkIHdvcmsg
d2l0aG91dCB1cyBoYXZpbmcgdG8gY29udGludWFsbHkgYWRkIG1vcmUgKGFyZ3VhYmx5DQp1c2Vs
ZXNzKSBjb21wYXRpYmxlIHN0cmluZ3MgdG8gdGhlIGRyaXZlciwgaW5jbHVkaW5nIHRoaXMgb25l
Lg0KDQpLaW5kIHJlZ2FyZHMsDQpBbHZpbg==
