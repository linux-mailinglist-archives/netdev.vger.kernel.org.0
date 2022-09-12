Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38AE85B59BF
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 13:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229759AbiILL7X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Sep 2022 07:59:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILL7W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Sep 2022 07:59:22 -0400
Received: from EUR02-HE1-obe.outbound.protection.outlook.com (mail-eopbgr10091.outbound.protection.outlook.com [40.107.1.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B635025E98;
        Mon, 12 Sep 2022 04:59:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P05kkyVZPIabfNqTSBJyAauE9uunqDwWzMK7fGlnnZhUv2Miu72ZzbA60L1i4pDBUA50MXfZ1+CQM9nz7Cq7X+gsBiwTilHHgiifGKWmcOjdu9xMYLaAbSUiMvoHvIpXDxfblE6uu+HzeioBN0gi+mJ9VzItSWi7RimrJmZ8OtIVoUpk4J3UIT8OzSHrLVv9x81JFDYkaJHJG4PbEdUDE/fvi5bpA3req57g8Jiki2NLTwprBwInSlu0OAZqrXk8imiy1SYwsUk31sUuxWlgPCPSfZp+k5BWlvFHb4JpF7C7J0VCOgXv/jX2OAkYGB6WkOH5dJ7inR4SqqkdfA/h7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oaljpYSNJxGg0xM0WfQKxeO+ZAbtdWl7lek1ejdnU8Q=;
 b=jT0xMl2YkEltEPCoDZcvab8SqlyLKgkTxqcYo8M1WphOBTHWdCcmfV2jV+WRUuS5MJN4KqosEvDPFiIKrvyOKbWft+STeEV86Y04iIb8dcGv9/X0nh6Wz/js5sv2Nz3lk6RZk5XUPY37rDo8PS66BYWkLnsgjm8Dz6AbJuoalO0ldJDAADZj0XMFA/K+/pLMaajsI8GATKGKg7MoBjZNmqqSTc8/f/5Vcm0nML2/wXwJ8qDhcdi2np1f6aAyQxLU/quFlR0XXBVW60U+mG0EoX0CCw1WV6s5Lc4B4txRZ3ROtBoOFDbLcCJu/zBn4ZlHQ8GqL6/GgmUVfKOwRppp6Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oaljpYSNJxGg0xM0WfQKxeO+ZAbtdWl7lek1ejdnU8Q=;
 b=f5unecRkrP3gu8eaBgz6DScBuxZyAigtIA+TSCeXdztIQthSs1y3wap+rFUAAvyukeTjFLovRzoH3gn4ZVPi+dUX0SCNAJa1vyK4hGZYZBDZF/4KYDm43+Xq2ekH9SY/p5EUns8h6yvi3LjdPwOlq9C21UFUtOu88ZqOX1KCkpo=
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com (2603:10a6:20b:26::24)
 by DBAPR03MB6485.eurprd03.prod.outlook.com (2603:10a6:10:197::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.22; Mon, 12 Sep
 2022 11:59:17 +0000
Received: from AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb]) by AM6PR03MB3943.eurprd03.prod.outlook.com
 ([fe80::f17f:3a97:3cfa:3cbb%5]) with mapi id 15.20.5612.022; Mon, 12 Sep 2022
 11:59:17 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Russell King <rmk+kernel@armlinux.org.uk>
CC:     Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        "asahi@lists.linux.dev" <asahi@lists.linux.dev>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Hector Martin <marcan@marcan.st>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rafa__ Mi__ecki <zajec5@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        "SHA-cyfmac-dev-list@infineon.com" <SHA-cyfmac-dev-list@infineon.com>,
        Sven Peter <sven@svenpeter.dev>,
        van Spriel <arend@broadcom.com>
Subject: Re: [PATCH wireless-next v2 01/12] dt-bindings: net: bcm4329-fmac:
 Add Apple properties & chips
Thread-Topic: [PATCH wireless-next v2 01/12] dt-bindings: net: bcm4329-fmac:
 Add Apple properties & chips
Thread-Index: AQHYxp8VRhIzhoN1vkifFhGA/p+3uA==
Date:   Mon, 12 Sep 2022 11:59:17 +0000
Message-ID: <20220912115911.e7dlm2xugfq57mei@bang-olufsen.dk>
References: <Yx8BQbjJT4I2oQ5K@shell.armlinux.org.uk>
 <E1oXg7N-0064ug-9l@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1oXg7N-0064ug-9l@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM6PR03MB3943:EE_|DBAPR03MB6485:EE_
x-ms-office365-filtering-correlation-id: 92e17d87-83d2-44ee-42ae-08da94b63816
x-ms-exchange-atpmessageproperties: SA|SL
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 4R+UtDYlDwXWQqHDMpm+PMv4nJlVxgAJOQkwxThQz9sCNxRqHlju4oXDgLPcAEtu4m3hu0r716027An6Q/+ELjKu0yYPb3RRY55Pf9ul2QvwWBSVHbWM/mPPeUB8GVjNfyQdZhbQ3GsHN6vCyCYBZC9sJK1EUwhHPmTvnKBu5RShN1rJU2xynBYHGjKZjIi/LEs7MerD5G4+tmdKyQf6fBRLHjrhiWxjb3KMvL0fnwxUa8jW2iV6N3lEoVUpYQQEORqdH9NZBfLFQElVgAOHMWx+8DjuaoeyD2GeLFO9DXTqxx9SHJw3YJDLKhiitIEcIoPzFjbK89bSkFUNR7zADJHa32WmlQ2e1yoZ6AEysmio8CFIv4PWb3LUHG4IiKY+T7bDK8oSdO2EjPWHY0kbvKacHadFm0ooyuDl6O5GV203Y7xds42XRHgWNwabmNbMBAHIg6W5dX3MGMS85RJT2e/rHigMYcmFDlUA4+PHK34mG4wBakdXgyYQcHr34oT6r7zfEYqaXw372XsqFmtscfnXrFEE62vbDJRAhaj8q1wTusG8QfzUvJEwHdnz4B7qxI+QqIeHx0aJQ5xCSFLBv0ZNxqbvVYkbjHhaW5xDBULaLFnIirUSLQOUfgZc4v5P0mWzm6J7TSCh5vAHU+B/0AycgLfCOni4U18vW7PaNUivY7CgX8DU7o35D0NXPnYyXng/AZvAi1JufPk61/O5z8vLIl2Wjfx5+FuMftJeOD0kM3hJBqUotBihykv8gaT6LqkUAMnGNnhx+UbPb+PkIa9Xpl/n5XN9/WHhwpt5lt8nU00S2+dbAvGXVtSohxQ7iVkKv7QJcd2RqgyIqEWsyg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR03MB3943.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(136003)(346002)(39850400004)(376002)(47660400002)(122000001)(38100700002)(6512007)(38070700005)(26005)(83380400001)(85202003)(2616005)(186003)(1076003)(6506007)(6486002)(4326008)(54906003)(966005)(478600001)(316002)(86362001)(64756008)(66476007)(66946007)(76116006)(66556008)(71200400001)(8676002)(41300700001)(91956017)(7416002)(2906002)(66446008)(85182001)(5660300002)(8936002)(8976002)(36756003)(46800400005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VVVFK3g4aTBJNmFVVzNoVTc0MDk3c2R0dU9lV1U3S2tzcWJUK0VJQ2l1WVk0?=
 =?utf-8?B?aGQ5R3FrZ3hlVW5mQk1McHJtQW5lbXFsR29pRWszYjFpNFlQYkV5ck5OTUpN?=
 =?utf-8?B?UnFhc281K2tDM1UvbUc1ekRGL2Uxa1BRRlJiWThkVURHMk5maUFaaDN5YmhX?=
 =?utf-8?B?RWxQSlRVNlY3M01MMVdNK1BlWHB5Z1BrdlRuNnZwb1hKVFYyWUVJT2JqSWtV?=
 =?utf-8?B?Q216dGkvL2ptQ1MxVjdOZVZHNEJRUTljWC82YitmaGxMM2lXS2ZhYytWbDIz?=
 =?utf-8?B?Ymw1cElmQkRqZWlUK1l2Sy9XbmVRRE81cGNPMmRycTFudGFLc1J3cXhtZ3A3?=
 =?utf-8?B?SHlTSW9NTHZPeFRUYithNnpzbUE3ZEl1NFB2UlEvV21nY3hxSzFpaVArME51?=
 =?utf-8?B?MjNHY1ltVm5CVGJla1hrQlR1dDYwcDZZOWRvVnNFVFlLYWdDM0tBWUxRZitN?=
 =?utf-8?B?SThTNEloYTEvckpoenZ6MlhtQVJUemdYY1B3ZForelRmU2VDNDJ2b0JnMnor?=
 =?utf-8?B?eExnU2tBSmI4dkY4RlNKay9aRmYyYStPRGVPak1PSXdMQjV5TVJ4ZlVuakhw?=
 =?utf-8?B?WDloQmhFK3Z5dXBOV096Q1dlRDY1N0tPOE9ucWJWTWcyMmtybnJEQXpCMWpQ?=
 =?utf-8?B?WkFTVlZSUS9aSldDK0NHWStjMDBiOFJzUDB1eGcrMlRQTzFxY2xWeGIvYkdB?=
 =?utf-8?B?OEF4TEl1ZCtScW9RU2twNTZNL3NreVNtUjJBRVVkdTZUcktZT3p0aTRGM2tI?=
 =?utf-8?B?YXRrOVlTenp0dmpXS1FDMFpNMlF0WVpTYTlZMzBHZUMyeHdiTmpMRUUxRWJo?=
 =?utf-8?B?a01kT0p4RVV0SVlOUXB3MnRtOHAwT2d5S1FtMXJTVE56NUdxOE9PckdCMmxJ?=
 =?utf-8?B?cnp5OXh0TzJ6UXhXU0pHcmVPdzVUM3NlVE1WcmR5eENnb3VuWFpaMFhSdHUz?=
 =?utf-8?B?Ry9tZGZqTUUwc1kwM0lPM2ZDZ1craTBhdGVZSHBGTTZVcW1qeE9mLzhTY05U?=
 =?utf-8?B?dXVXUHdmU1VnTyt1QTlnajA3SWRiTnJlMnJwaXlqaTEwb1hsWXlOMTZ1UHA2?=
 =?utf-8?B?S1Uva0Irb0pQb1pDeDg0akF1eUo2TVBJVlhsc3Z4bmhoNmZ4eEcwazJWeGF6?=
 =?utf-8?B?QXNjQlpxbTVlQlg3Wk96ajZRWSthUjQySDNTNndWZTlCWnBDWHJvdDFMOXNH?=
 =?utf-8?B?elpXVVJ0VUV3dFRSLzVoblBycXZtZzU5ay9CdHRlVXNCaE1naGV5UXlrem8y?=
 =?utf-8?B?QkxGcUxWb0ViS0oxdURpZ29MSGEzN2hEK2hnS0NiT09YeDZHTUEyTHNXN3lt?=
 =?utf-8?B?NXBZTWZIdTJaQVpFR0dIT1JZRm9lT3ZqejVHVXN6NjdIZUF0SnUyWjdNTGp3?=
 =?utf-8?B?Q1dqT2tLaGxmMW9tU3pKQkdlNUNreTFRTmVNcG9XVVFiVER3d2pmOC9zbkt1?=
 =?utf-8?B?VWV2alFWZjdqUENNdUVwWUlmcWFUOHNackxsSmltbnNVTkRxblpwZ1FVZVJ2?=
 =?utf-8?B?ZHpQcGEzcmtyV2JxdG5LbFl0UFpocFR4M1BHa1puNXZMb2lpTEJVakp2SlNk?=
 =?utf-8?B?SHdMMHMwSEI1b2hzV1N0SkZ2U2ZCdjNaZnNlR2lHM095bm96KzU5Y3FIYTRm?=
 =?utf-8?B?RHBNMlp1aHJDM2dSRFYyMUFQUjMramx5QWdYYVptN0xsUkxKQUw5MEM5MmJ3?=
 =?utf-8?B?U3BEZTVXb3hid295eHA5UHhRcnNsejByRUQ4NHo2SXFzNWFpNTRkWHB2T3pP?=
 =?utf-8?B?Mmd3QXhTUm1PZCtlQVVlRVJWaEVDek9HRXlxR1hUTUY3bTUzMEY0cGw1aW1s?=
 =?utf-8?B?cXRlZDhSVGxCWWdSaG40dWF6R3h2bTJ3TUROZEhjZlZmdlNNdEphY051NGZT?=
 =?utf-8?B?dVprZWlSeXZCcFNpYTlzV1RsaHRodzNpSTFMcnE1MUlJaExPNURlb0NnaGZ3?=
 =?utf-8?B?cmkvaHAwN3l1ZjZOaW1xeWlCMnlrQi9WSWlLSnBNWDFqUmdQR2kwTXNkWUo0?=
 =?utf-8?B?Y3pyWm0zeUFkY0pRbGt2Q3QyR0ZPZFRDNFhRS3JwV1hxZklienk2MThsNU5t?=
 =?utf-8?B?dHdKcEdtRGhMdytsMWVtMVljYWEvTXBTZFp1Z09qY2ZLYjYrdUU2WmM4WEIv?=
 =?utf-8?B?WDRYMVhTUjdlRzVQaTl2c0xIRThnQXMyUzRmRjJKNGFQd3Yva0xxdDBlU0hF?=
 =?utf-8?B?V1E9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <0E831374D71B9A48B2DE80A1BFA3BAB2@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR03MB3943.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 92e17d87-83d2-44ee-42ae-08da94b63816
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Sep 2022 11:59:17.2131
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nFfnSn6rmnSlm1CqxQ0JYoLD61Du7yfgjLD+bbcV+IuPuz0zVGEFfHH3OCtdaVHbLxcre2rvYIssSqkIKe+Rpw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DBAPR03MB6485
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCBTZXAgMTIsIDIwMjIgYXQgMTA6NTI6NDFBTSArMDEwMCwgUnVzc2VsbCBLaW5nIHdy
b3RlOg0KPiBGcm9tOiBIZWN0b3IgTWFydGluIDxtYXJjYW5AbWFyY2FuLnN0Pg0KPiANCj4gVGhp
cyBiaW5kaW5nIGlzIGN1cnJlbnRseSB1c2VkIGZvciBTRElPIGRldmljZXMsIGJ1dCB0aGVzZSBj
aGlwcyBhcmUNCj4gYWxzbyB1c2VkIGFzIFBDSWUgZGV2aWNlcyBvbiBEVCBwbGF0Zm9ybXMgYW5k
IG1heSBiZSByZXByZXNlbnRlZCBpbiB0aGUNCj4gRFQuIFJlLXVzZSB0aGUgZXhpc3RpbmcgYmlu
ZGluZyBhbmQgYWRkIGNoaXAgY29tcGF0aWJsZXMgdXNlZCBieSBBcHBsZQ0KPiBUMiBhbmQgTTEg
cGxhdGZvcm1zICh0aGUgVDIgb25lcyBhcmUgbm90IGtub3duIHRvIGJlIHVzZWQgaW4gRFQNCj4g
cGxhdGZvcm1zLCBidXQgd2UgbWlnaHQgYXMgd2VsbCBkb2N1bWVudCB0aGVtKS4NCj4gDQo+IFRo
ZW4sIGFkZCBwcm9wZXJ0aWVzIHJlcXVpcmVkIGZvciBmaXJtd2FyZSBzZWxlY3Rpb24gYW5kIGNh
bGlicmF0aW9uIG9uDQo+IE0xIG1hY2hpbmVzLg0KPiANCj4gUmV2aWV3ZWQtYnk6IExpbnVzIFdh
bGxlaWogPGxpbnVzLndhbGxlaWpAbGluYXJvLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogSGVjdG9y
IE1hcnRpbiA8bWFyY2FuQG1hcmNhbi5zdD4NCj4gUmV2aWV3ZWQtYnk6IE1hcmsgS2V0dGVuaXMg
PGtldHRlbmlzQG9wZW5ic2Qub3JnPg0KPiBSZXZpZXdlZC1ieTogUm9iIEhlcnJpbmcgPHJvYmhA
a2VybmVsLm9yZz4NCj4gU2lnbmVkLW9mZi1ieTogUnVzc2VsbCBLaW5nIChPcmFjbGUpIDxybWsr
a2VybmVsQGFybWxpbnV4Lm9yZy51az4NCj4gLS0tDQo+ICAuLi4vbmV0L3dpcmVsZXNzL2JyY20s
YmNtNDMyOS1mbWFjLnlhbWwgICAgICAgfCAzOSArKysrKysrKysrKysrKysrKy0tDQo+ICAxIGZp
bGUgY2hhbmdlZCwgMzUgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYg
LS1naXQgYS9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL2Jy
Y20sYmNtNDMyOS1mbWFjLnlhbWwgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
bmV0L3dpcmVsZXNzL2JyY20sYmNtNDMyOS1mbWFjLnlhbWwNCj4gaW5kZXggNTNiNDE1M2Q5YmZj
Li5mZWMxY2M5YjlhMDggMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy9uZXQvd2lyZWxlc3MvYnJjbSxiY200MzI5LWZtYWMueWFtbA0KPiArKysgYi9Eb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L3dpcmVsZXNzL2JyY20sYmNtNDMyOS1m
bWFjLnlhbWwNCj4gQEAgLTQsNyArNCw3IEBADQo+ICAkaWQ6IGh0dHA6Ly9kZXZpY2V0cmVlLm9y
Zy9zY2hlbWFzL25ldC93aXJlbGVzcy9icmNtLGJjbTQzMjktZm1hYy55YW1sIw0KPiAgJHNjaGVt
YTogaHR0cDovL2RldmljZXRyZWUub3JnL21ldGEtc2NoZW1hcy9jb3JlLnlhbWwjDQo+ICANCj4g
LXRpdGxlOiBCcm9hZGNvbSBCQ000MzI5IGZhbWlseSBmdWxsbWFjIHdpcmVsZXNzIFNESU8gZGV2
aWNlcw0KPiArdGl0bGU6IEJyb2FkY29tIEJDTTQzMjkgZmFtaWx5IGZ1bGxtYWMgd2lyZWxlc3Mg
U0RJTy9QQ0lFIGRldmljZXMNCj4gIA0KPiAgbWFpbnRhaW5lcnM6DQo+ICAgIC0gQXJlbmQgdmFu
IFNwcmllbCA8YXJlbmRAYnJvYWRjb20uY29tPg0KPiBAQCAtNDEsMTEgKzQxLDE3IEBAIHRpdGxl
OiBCcm9hZGNvbSBCQ000MzI5IGZhbWlseSBmdWxsbWFjIHdpcmVsZXNzIFNESU8gZGV2aWNlcw0K
PiAgICAgICAgICAgICAgICAtIGN5cHJlc3MsY3l3NDM3My1mbWFjDQo+ICAgICAgICAgICAgICAg
IC0gY3lwcmVzcyxjeXc0MzAxMi1mbWFjDQo+ICAgICAgICAgICAgLSBjb25zdDogYnJjbSxiY200
MzI5LWZtYWMNCj4gLSAgICAgIC0gY29uc3Q6IGJyY20sYmNtNDMyOS1mbWFjDQo+ICsgICAgICAt
IGVudW06DQo+ICsgICAgICAgICAgLSBicmNtLGJjbTQzMjktZm1hYw0KPiArICAgICAgICAgIC0g
cGNpMTRlNCw0M2RjICAjIEJDTTQzNTUNCj4gKyAgICAgICAgICAtIHBjaTE0ZTQsNDQ2NCAgIyBC
Q000MzY0DQo+ICsgICAgICAgICAgLSBwY2kxNGU0LDQ0ODggICMgQkNNNDM3Nw0KPiArICAgICAg
ICAgIC0gcGNpMTRlNCw0NDI1ICAjIEJDTTQzNzgNCj4gKyAgICAgICAgICAtIHBjaTE0ZTQsNDQz
MyAgIyBCQ000Mzg3DQo+ICANCj4gICAgcmVnOg0KPiAtICAgIGRlc2NyaXB0aW9uOiBTRElPIGZ1
bmN0aW9uIG51bWJlciBmb3IgdGhlIGRldmljZSwgZm9yIG1vc3QgY2FzZXMNCj4gLSAgICAgIHRo
aXMgd2lsbCBiZSAxLg0KPiArICAgIGRlc2NyaXB0aW9uOiBTRElPIGZ1bmN0aW9uIG51bWJlciBm
b3IgdGhlIGRldmljZSAoZm9yIG1vc3QgY2FzZXMNCj4gKyAgICAgIHRoaXMgd2lsbCBiZSAxKSBv
ciBQQ0kgZGV2aWNlIGlkZW50aWZpZXIuDQo+ICANCj4gICAgaW50ZXJydXB0czoNCj4gICAgICBt
YXhJdGVtczogMQ0KPiBAQCAtODUsNiArOTEsMzEgQEAgdGl0bGU6IEJyb2FkY29tIEJDTTQzMjkg
ZmFtaWx5IGZ1bGxtYWMgd2lyZWxlc3MgU0RJTyBkZXZpY2VzDQo+ICAgICAgICB0YWtlcyBwcmVj
ZWRlbmNlLg0KPiAgICAgIHR5cGU6IGJvb2xlYW4NCj4gIA0KPiArICBicmNtLGNhbC1ibG9iOg0K
PiArICAgICRyZWY6IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3VpbnQ4LWFycmF5
DQo+ICsgICAgZGVzY3JpcHRpb246IEEgcGVyLWRldmljZSBjYWxpYnJhdGlvbiBibG9iIGZvciB0
aGUgV2ktRmkgcmFkaW8uIFRoaXMNCj4gKyAgICAgIHNob3VsZCBiZSBmaWxsZWQgaW4gYnkgdGhl
IGJvb3Rsb2FkZXIgZnJvbSBwbGF0Zm9ybSBjb25maWd1cmF0aW9uDQo+ICsgICAgICBkYXRhLCBp
ZiBuZWNlc3NhcnksIGFuZCB3aWxsIGJlIHVwbG9hZGVkIHRvIHRoZSBkZXZpY2UgaWYgcHJlc2Vu
dC4NCg0KSXMgdGhpcyBhIGxlZnRvdmVyIGZyb20gYSBwcmV2aW91cyByZXZpc2lvbiBvZiB0aGUg
cGF0Y2hzZXQ/IEJlY2F1c2UgYXMNCmZhciBhcyBJIGNhbiB0ZWxsLCB0aGUgQ0xNIGJsb2IgaXMg
KHN0aWxsKSBiZWluZyBsb2FkZWQgdmlhIGZpcm13YXJlLA0KYW5kIG5vIGFkZGl0aW9uYWwgcGFy
c2luZyBoYXMgYmVlbiBhZGRlZCBmb3IgdGhpcyBwYXJ0aWN1bGFyIE9GDQpwcm9wZXJ0eS4gU2hv
dWxkIGl0IGJlIGRyb3BwZWQ/DQoNClRoZSByZXN0IGxvb2tzIHF1aXRlIE9LLg0KDQpLaW5kIHJl
Z2FyZHMsDQpBbHZpbg0KDQo+ICsNCj4gKyAgYnJjbSxib2FyZC10eXBlOg0KPiArICAgICRyZWY6
IC9zY2hlbWFzL3R5cGVzLnlhbWwjL2RlZmluaXRpb25zL3N0cmluZw0KPiArICAgIGRlc2NyaXB0
aW9uOiBPdmVycmlkZXMgdGhlIGJvYXJkIHR5cGUsIHdoaWNoIGlzIG5vcm1hbGx5IHRoZSBjb21w
YXRpYmxlIG9mDQo+ICsgICAgICB0aGUgcm9vdCBub2RlLiBUaGlzIGNhbiBiZSB1c2VkIHRvIGRl
Y291cGxlIHRoZSBvdmVyYWxsIHN5c3RlbSBib2FyZCBvcg0KPiArICAgICAgZGV2aWNlIG5hbWUg
ZnJvbSB0aGUgYm9hcmQgdHlwZSBmb3IgV2lGaSBwdXJwb3Nlcywgd2hpY2ggaXMgdXNlZCB0bw0K
PiArICAgICAgY29uc3RydWN0IGZpcm13YXJlIGFuZCBOVlJBTSBjb25maWd1cmF0aW9uIGZpbGVu
YW1lcywgYWxsb3dpbmcgZm9yDQo+ICsgICAgICBtdWx0aXBsZSBkZXZpY2VzIHRoYXQgc2hhcmUg
dGhlIHNhbWUgbW9kdWxlIG9yIGNoYXJhY3RlcmlzdGljcyBmb3IgdGhlDQo+ICsgICAgICBXaUZp
IHN1YnN5c3RlbSB0byBzaGFyZSB0aGUgc2FtZSBmaXJtd2FyZS9OVlJBTSBmaWxlcy4gT24gQXBw
bGUgcGxhdGZvcm1zLA0KPiArICAgICAgdGhpcyBzaG91bGQgYmUgdGhlIEFwcGxlIG1vZHVsZS1p
bnN0YW5jZSBjb2RlbmFtZSBwcmVmaXhlZCBieSAiYXBwbGUsIiwNCj4gKyAgICAgIGUuZy4gImFw
cGxlLGhvbnNodSIuDQoNCm5pdDogcy9XaUZpL1dpLUZpLw0KDQo+ICsNCj4gKyAgYXBwbGUsYW50
ZW5uYS1za3U6DQo+ICsgICAgJHJlZjogL3NjaGVtYXMvdHlwZXMueWFtbCMvZGVmaW5pdGlvbnMv
c3RyaW5nDQo+ICsgICAgZGVzY3JpcHRpb246IEFudGVubmEgU0tVIHVzZWQgdG8gaWRlbnRpZnkg
YSBzcGVjaWZpYyBhbnRlbm5hIGNvbmZpZ3VyYXRpb24NCj4gKyAgICAgIG9uIEFwcGxlIHBsYXRm
b3Jtcy4gVGhpcyBpcyB1c2UgdG8gYnVpbGQgZmlybXdhcmUgZmlsZW5hbWVzLCB0byBhbGxvdw0K
PiArICAgICAgcGxhdGZvcm1zIHdpdGggZGlmZmVyZW50IGFudGVubmEgY29uZmlncyB0byBoYXZl
IGRpZmZlcmVudCBmaXJtd2FyZSBhbmQvb3INCj4gKyAgICAgIE5WUkFNLiBUaGlzIHdvdWxkIG5v
cm1hbGx5IGJlIGZpbGxlZCBpbiBieSB0aGUgYm9vdGxvYWRlciBmcm9tIHBsYXRmb3JtDQo+ICsg
ICAgICBjb25maWd1cmF0aW9uIGRhdGEuDQo+ICsNCj4gIHJlcXVpcmVkOg0KPiAgICAtIGNvbXBh
dGlibGUNCj4gICAgLSByZWcNCj4gLS0gDQo+IDIuMzAuMg0KPg==
