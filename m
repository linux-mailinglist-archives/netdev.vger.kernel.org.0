Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEF25608D5
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 20:15:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiF2SPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 14:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231298AbiF2SPB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 14:15:01 -0400
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30117.outbound.protection.outlook.com [40.107.3.117])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F81F39B81
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 11:14:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oEp5F9asyROn+qcTcecIhzhy4Dridu2ZIcineevizpfoMLJRwZcstBVCwkUm+ECR0s8qxFWKjijioeeezNjl8k1g1PHJyPljrbh+m/JXsFrGMG2T+00g4jy7OIhsLuywfd4tk/c4TqGJVrCFnON+yWhPWaimwwmav+MepCFgtvVYb4XBN8OcnGZlv7YQP4dzcguw4DBhoU6kbVXrdAUYT1l2g5QeqKcB3NIczoVoh0Vmji6RNhBzNmVQFbU6fogRyOYsgabZ0z7WNILgxct1ABResMBle7Ig93RV/abRDAv99j/r9F6OOfcAUjEpeuJOsdQU2eCf4Ex2UjLbbsnxBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yTO6KeJj62QGoFI4aLQIchiz9RgbcioUFkjR+6rLBv8=;
 b=Kkto8FbFYi98yrs8W0NPAXkf43ABBV+cb7s2kG9HgzAASuoHZTE8QA97BPcvf/0mw0UFMLD8WdyFzCTal0Z4iFI/xKcYJynA4D2qweAb/1s/Q0AhjLOpNyHedcAiE/BtxuTHJW9lUkiIT8Oxcce07DyuFnIn1hVzvs1Mq8xQ2bazKwIX3lnoBBzinqnAlqkEDsYwNrl1ibC8PnVlU9r0msB3ztKskOglO7cX55Rxf/jqTZBMca/Wl9mHGt+Cgi77vD97TXfd6SzgnACN2eEK9Craktg1k/D1rL1sSFwPZSzcZrjB/doF4zjphWuzVD6zC5Ac+HXNl+LH1vHO+7LRiA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yTO6KeJj62QGoFI4aLQIchiz9RgbcioUFkjR+6rLBv8=;
 b=kM+WHGiqDe67NRqYGdCT5EXBGo3Pn/OSaNz3Cv8QktTXW56GXcREdGweM7xNZJ6nxF3PixwVcuHrWW5fmBnIsvuOC78AbbkqsZJ2GW/OMVDz95Z0nOlnRn52FUN2o3/PFkPJDyZ/R+fWUXe2GxVrcxIX85YFqXJSpk7XI0Fxxp4=
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com (2603:10a6:803:75::30)
 by GV2PR03MB8653.eurprd03.prod.outlook.com (2603:10a6:150:75::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5373.18; Wed, 29 Jun
 2022 18:14:56 +0000
Received: from VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78]) by VI1PR03MB3950.eurprd03.prod.outlook.com
 ([fe80::de7:d0ed:2d93:9f78%6]) with mapi id 15.20.5373.018; Wed, 29 Jun 2022
 18:14:56 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>
CC:     "open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        "krzk+dt@kernel.org" <krzk+dt@kernel.org>,
        =?utf-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
Subject: Re: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave MII
Thread-Topic: [PATCH net-next RFC 0/3] net: dsa: realtek: drop custom slave
 MII
Thread-Index: AQHYi2v6y8XzldS8b0+51yVWVr7FnK1ml/OAgAAZeYA=
Date:   Wed, 29 Jun 2022 18:14:56 +0000
Message-ID: <20220629181455.boerjnqmvovmtzra@bang-olufsen.dk>
References: <20220629035434.1891-1-luizluca@gmail.com>
 <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
In-Reply-To: <CAJq09z44SNGFkCi_BCpQ+3DuXhKfGVsMubRYE7AezJsGGOboVA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9339149b-f058-44ab-f595-08da59fb455d
x-ms-traffictypediagnostic: GV2PR03MB8653:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yxAXVJw1VYiUaN+KiuScc+tp1+A9MyUZ4xGf13oJ0ptkGZopiPBMn9UFKuZrP4BzPnm53xHizsPDIc4e9hAVfLP7MZRunoFD7YaKCdwvPuqCyTamgHRpw4thVRpJYj/mC7v1pk8aP51JVYpxIJhRfw5AKi7Zy5XF+BjmQp5JcubtAxFKTGT1Qamm/VC+RJa8kaf9+JijyxHlrghIUx1HCAgyvwvwRXpU5XwvB9iYeDAHerWrgujvgrMpj/lGGKIMVFp4OItR9RLdcU0XmcaZFejpdwa/C0tPx/Xe3h345Ws220KPpeslIuGRv5EeyHkyvpZOKxk9G+natGSFIE/XiDekeykWQr4HLWEDr6uH4O+Fno18QKwJAB6bzHNLZtS3/TpOQuMA5Pzp9LF9fyKy2aya76sFoTZKzB2YrTbVN2STpiefRlbpUQ9AOvVuxRXdY5TI4up5ggWNDMase4+hz/A4QUgpg3Ntqqisc/rD13njrXCRs1WnmrYOUbJCg2DzWsbeDw1cLuqySEYntS6GzNTs30gOu7gToQF0rhHZK7xEsZde7QAbcC2dWjlJCPLnj5MXAkL4NmxDBqYxhKzQXprIRc7gl05jDbkji8x9NbBhpp1cBYnQ40UDqncsKDuTETguFmkAEWZmXOmCaCNzsJO9rMg8Xw2w1rLyZ/5w2TtWGIuMrCs2Tspk6CKCkOUnyz97BdEhymRLRrOAFJQtYV1EoNwRLPF8xkUWhGlgq5i4aesZIHJGNie77uat8BYL7u+sxDsFkurNzBfr4W5sjxyyRfRORr3qmMzmxc8mP3rxQCKchXjCauwCUR1uVXeY2WxvodZKi+WhgZc8wlBqpg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR03MB3950.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(366004)(376002)(136003)(346002)(39850400004)(8976002)(86362001)(66946007)(66556008)(3716004)(2616005)(41300700001)(38070700005)(26005)(4326008)(91956017)(6506007)(66446008)(8676002)(64756008)(8936002)(66476007)(5660300002)(83380400001)(76116006)(71200400001)(2906002)(85182001)(6486002)(54906003)(6916009)(1076003)(6512007)(38100700002)(122000001)(7416002)(478600001)(186003)(36756003)(316002)(85202003)(21314003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?ZHRoc3MwdlR3TWFEWmZRSk5VenlSOUg5Y2cyd0EwSFVSaTFrT3krdWpZWlRP?=
 =?utf-8?B?V01JUW93dVVhUGEybU5xeHl6WHJaWHBCWm5QNmYvOFE1UmFqZTUwWHJ0blNR?=
 =?utf-8?B?NUUxaVlVSTNHYlM4SzN3Q1JrZHdQTzBoaDNreExKaGFxUDN5dHdidUUzUXhr?=
 =?utf-8?B?eGhaVHNXbGRMZlM3TkdyVjBBa1IrSEplMzI1MER6bXF0MDNvcnd3MjdERlV1?=
 =?utf-8?B?dHJESVFwRWVsV2Z0NmFreWNqZ1B5UkxQNWZzSGZyZ0lQZ0lUR05wakZlZjV0?=
 =?utf-8?B?THVHc1RCdFUxb0VudmlZZnpnbXgwekV1enh2VTlXR3B4Zk5BNG8yeFViMEkv?=
 =?utf-8?B?UmdoNEplaE9aWENibWZRSFBOVUpwd2tsd1Y5anlycHJ1YyttVFpodkRvWUk2?=
 =?utf-8?B?MDBwVFA4T1dVR0RTZ1BwNElkVHBJQ3hWQ05OQzRIVGdBM20wY1dyMlN1bHRM?=
 =?utf-8?B?Q0JuaXRpMVhEbXcxVkdrdTRNRU9TeWpHYVRJMmVUUEZrT2NvWjhrRXdYQ1h5?=
 =?utf-8?B?SzI4bjRudFhiTlBTWUgyZXg3Njc4dVptbWdPU0h5Z1E3KzVoS0l3eDZDR3ht?=
 =?utf-8?B?d0VUdWNmWkx4NHhUTWtDc1h0WXVTSEZqWkJxMkM1a0o0QkpkcUlKRnNLZ1ph?=
 =?utf-8?B?b2p4QVVZdGpTb3drcHFEZVg4YTRyZ3JOY0E0eTZwL2N1TXBBZ2lRRmZESkcx?=
 =?utf-8?B?MjM0M25tL01ScFhnUkdXS2x6OXAxK3YrdWVnYlJsVXZSdlhJOUFnUU05djBX?=
 =?utf-8?B?ekprL3FXaVdpRm5BcTFqVTFpamo1Q2lieTRGYjU2NDFDWjFvdDBGWlhwUVJM?=
 =?utf-8?B?Q1FneFcrNFhLZmo3UGhjdlp4dVZ2NUdOV2ZHK280VytVT2EvS2pITjIzMnRr?=
 =?utf-8?B?by85d0M2NVJ0c3pPS29ZUmJkZTd0T0VUcko3RzRiR3NBUDIwd052aXlLV3lw?=
 =?utf-8?B?QUc0OFh6K0V5dDBrQTFYYW9DN081Vm9PeDM1RjRxQTBlQVd1a3kxRnk5VmF1?=
 =?utf-8?B?dHBIbTVVZ0V0OFM2ajB6OERXM1pzZGNMSWg5VHJORUMybVIzNG5jdnhZNzdE?=
 =?utf-8?B?R3FvdHhIYkgvRXo5NnRibzNhdWlSYnJ4L3d0Y1dVcHJvWVh4M3Bsc1NsVldw?=
 =?utf-8?B?V3hqN1JjcGdIOHFWdE5KNUF4T01XZlpiRGNlcEt6eVVSKzM0RWZzVkNNZkpY?=
 =?utf-8?B?ekFDQUF2VitPOU5DM3pyYnNTSjlXMTdUaXFjVzdRczN6VWI0V1g3WW5ZMS9W?=
 =?utf-8?B?SUl2YklRTklxV2lYZUd4RkVaYTJ2TWYzczdodnZXYVd1U0JicVYrdW5Kaktx?=
 =?utf-8?B?cy9mdUp1N0EvaHMxVkc1YVh5M2FCdVRzUDJmajloSjVGOTZoVWVnTEYxdlVE?=
 =?utf-8?B?WEMxbzRPeXM0WS9VWFl0TVZaTER2aklWZFROMTErVW5hUjJNa3dUZDlWTmhx?=
 =?utf-8?B?a3lhVy8zcTVlSStPUU5NZnowZmJoeTQ3SDFFOCt6MnNIRmNBTFNRUzd3UU4v?=
 =?utf-8?B?SFd5QU0rM2pHT0ZISVhwalZjS2dMK2xFUnU5VnhIeHN3SFNWVDA5L3RUaGdY?=
 =?utf-8?B?YXloTUJ2ZExuc3QvbHFWSCtWMGt0V296QjZ1UncxcE5UZmVlWEFIL2gyRE4x?=
 =?utf-8?B?Rm9rQkRFbENuTW9EK2JIWmV4eDVnN2EzQ1JwT1oxcGtocG9VaHhFcXVYMmZO?=
 =?utf-8?B?TXcwYUlrSzQ3WFh2S3JHNTZPVnZHNUdZV29meGJYSnlXUUlRRTZ2dWtlS1g0?=
 =?utf-8?B?UjBwaTBCcFR3TE56V21QVmtpdllmVHB0L2x5ZDErTi9wQ21qd0VNNUZLRzV4?=
 =?utf-8?B?N1M0MksvYXpONW9NQU4wT1Q1TjVLWHJRSjJqWi8xeVFqYXdIK1NEZno0emJX?=
 =?utf-8?B?N1pPZGE3S2JFc2FuRmhDZjB6UklTcXZBK2VCN29XZWVSc21vaCtIdWN2YWls?=
 =?utf-8?B?czdrY2ZBMk5BR2hsckNrV21KbzV3N0VCSVJJc1VDa3V4M2dSRzd3bnI0VEJv?=
 =?utf-8?B?RTFIUzF0V3VwUnI4emMrNE43NktiRnZPOXFXODJRNUlxMDZXU1R4S0ZUZStq?=
 =?utf-8?B?TXpHZ0hBcitEU3Y0WlNIMXE0Rm45eU5sZkhhVlZFdGMyZENvWWJsWWJvcWp5?=
 =?utf-8?B?M3JhTjllSmRQTzhkMm9NdWtSMWwxTmlXRjZJSHZQN1cxTU5YVldxN1V1dXpz?=
 =?utf-8?B?MlE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <541458D8A30BA1418B4CEDF8C15B3211@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR03MB3950.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9339149b-f058-44ab-f595-08da59fb455d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2022 18:14:56.1326
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: sHOJKdFWMXP5wHEtFYElxeRPnbkCg5eQHqTyRkE7yjdqnDhwAXsp+byQwHB4m1Nz27rWZGlJRM1V3RqIf+S0DQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV2PR03MB8653
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTHVpeiwNCg0KT24gV2VkLCBKdW4gMjksIDIwMjIgYXQgMDE6NDM6NDVQTSAtMDMwMCwgTHVp
eiBBbmdlbG8gRGFyb3MgZGUgTHVjYSB3cm90ZToNCj4gVGhpcyBSRkMgcGF0Y2ggc2VyaWVzIGNs
ZWFucyByZWFsdGVrLXNtaSBjdXN0b20gc2xhdmUgbWlpIGJ1cy4gU2luY2UNCj4gZmU3MzI0Yjkz
MiwgZHNhIGdlbmVyaWMgY29kZSBwcm92aWRlcyBldmVyeXRoaW5nIG5lZWRlZCBmb3INCj4gcmVh
bHRlay1zbWkgZHJpdmVyLiBGb3IgZXh0cmEgY2F1dGlvbiwgdGhpcyBzZXJpZXMgc2hvdWxkIGJl
IGFwcGxpZWQNCj4gaW4gdHdvIHN0ZXBzOiB0aGUgZmlyc3QgMiBwYXRjaGVzIGludHJvZHVjZSB0
aGUgbmV3IGNvZGUgcGF0aCB0aGF0DQo+IHVzZXMgZHNhIGdlbmVyaWMgY29kZS4gSXQgd2lsbCBz
aG93IGEgd2FybmluZyBtZXNzYWdlIGlmIHRoZSB0cmVlDQo+IGNvbnRhaW5zIGRlcHJlY2F0ZWQg
cmVmZXJlbmNlcy4gSXQgd2lsbCBzdGlsbCBmYWxsIGJhY2sgdG8gdGhlIG9sZA0KPiBjb2RlIHBh
dGggaWYgYW4gIm1kaW8iDQo+IGlzIG5vdCBmb3VuZC4NCg0KSW4gcHJpbmNpcGxlIEkgbGlrZSB5
b3VyIGNoYW5nZXMsIGJ1dCBJJ20gbm90IHN1cmUgaWYgd2hhdCB5b3UgYXJlIGRvaW5nDQppcyBh
bGxvd2VkLCBzaW5jZSBEVCBpcyBBQkkuIFRoZSBmYWN0IHRoYXQgeW91IGhhdmUgdG8gc3BsaXQg
dGhpcyBpbnRvDQp0d28gc3RlcHMsIHdpdGggdGhlIGZpcnN0IHN0ZXAgd2FybmluZyBhYm91dCBv
bGQgImluY29tcGF0aWJsZSIgRFRzDQooeW91ciBwb2ludCAzIGJlbG93KSBiZWZvcmUgdGhlIHNl
Y29uZCBzdGVwIGJyZWFrcyB0aGF0IGNvbXBhdGliaWxpdHksDQpzdWdnZXN0cyB0aGF0IHlvdSBh
cmUgYXdhcmUgdGhhdCB5b3UgY291bGQgYmUgYnJlYWtpbmcgb2xkIERUcy4NCg0KSSdtIG5vdCBn
b2luZyB0byBhcmd1ZSB3aXRoIHlvdSBpZiB5b3Ugc2F5ICJidXQgdGhlIG5vZGUgd2l0aCBjb21w
YXRpYmxlDQpyZWFsdGVrLHNtaS1tZGlvIHdhcyBhbHNvIGNhbGxlZCBtZGlvIGluIHRoZSBiaW5k
aW5ncywgc28gaXQgc2hvdWxkbid0DQpicmVhayBvbGQgRFRzIiwgd2hpY2ggaXMgYSB2YWxpZCBw
b2ludC4gQnV0IGlmIHRoYXQgaXMgeW91ciByYXRpb25hbGUsDQp0aGVuIHRoZXJlJ3Mgbm8gbmVl
ZCB0byBzcGxpdCB0aGUgc2VyaWVzIGF0IGFsbCwgcmlnaHQ/DQoNCklmIHlvdSB3YW50IHRvIGF2
b2lkIHRoYXQgZGViYXRlLCB3aGF0IHlvdSBjb3VsZCBkbyBpbnN0ZWFkIGlzIGFkZCBhDQpjb25z
dCBjaGFyICpzbGF2ZV9taWlfY29tcGF0aWJsZTsgbWVtYmVyIHRvIHN0cnVjdCBkc2Ffc3dpdGNo
LCBhbmQgdHJ5DQpzZWFyY2hpbmcgaW4gZHNhX3N3aXRjaF9zZXR1cCgpIGZvciBhIGNoaWxkIG5v
ZGUgd2l0aCB0aGF0IGNvbXBhdGlibGUgaWYNCnRoZSBsb29rdXAgb2YgYSBub2RlIG5hbWVkICJt
ZGlvIiBmYWlscy4gSSBkb24ndCBrbm93IGlmIHRoaXMgd291bGQgaGVscA0KeW91IGRvIHRoZSBz
YW1lIHRoaW5nIHdpdGggb3RoZXIgZHJpdmVycy4NCg0KQnR3LCBJIHRoaW5rIHRoZSBmaXJzdCBw
YXRjaCBpbiB0aGUgc2VyaWVzIGlzIGtpbmQgb2YgcG9pbnRsZXNzLiBZb3UgY2FuDQpqdXN0IGRv
IHRoZSByZW5hbWUgb2YgZHNfb3BzX21kaW8gdG8gZHNfb3BzIGluIHRoZSBsYXN0IHBhdGNoLCBh
ZGRpbmcNCnlvdXIganVzdGlmaWNhdGlvbiBpbiB0aGUgY29tbWl0IG1lc3NhZ2U6ICJ3aGlsZSB3
ZSdyZSBhdCBpdCwgcmVuYW1lDQpkc19vcHNfbWRpbyBldGMuLi4iLg0KDQpLaW5kIHJlZ2FyZHMs
DQpBbHZpbg0KDQo+IA0KPiA+DQo+ID4gVGhlIGxhc3QgcGF0Y2ggY2xlYW5zIGFsbCB0aGUgZGVw
cmVjYXRlZCBjb2RlIHdoaWxlIGtlZXBpbmcgdGhlIGtlcm5lbA0KPiA+IG1lc3NhZ2VzLiBIb3dl
dmVyLCBpZiB0aGVyZSBpcyBubyAibWRpbyIgbm9kZSBidXQgdGhlcmUgaXMgYSBub2RlIHdpdGgN
Cj4gPiB0aGUgb2xkIGNvbXBhdGlibGUgc3RpbmdzICJyZWFsdGVrLHNtaS1tZGlvIiwgaXQgd2ls
bCBzaG93IGFuIGVycm9yLiBJdA0KPiA+IHNob3VsZCBzdGlsbCB3b3JrIGJ1dCBpdCB3aWxsIHVz
ZSBwb2xsaW5nIGluc3RlYWQgb2YgaW50ZXJydXB0aW9ucy4NCj4gPg0KPiA+IE15IGlkZWEsIGlm
IGFjY2VwdGVkLCBpcyB0byBzdWJtaXQgcGF0Y2hlcyAxIGFuZCAyIG5vdy4gQWZ0ZXIgYQ0KPiA+
IHJlYXNvbmFibGUgcGVyaW9kLCBzdWJtaXQgcGF0Y2ggMy4NCj4gPg0KPiA+IEkgZG9uJ3QgaGF2
ZSBhbiBTTUktY29ubmVjdGVkIGRldmljZSBhbmQgSSdtIGFza2luZyBmb3IgdGVzdGVycy4gSXQN
Cj4gPiB3b3VsZCBiZSBuaWNlIHRvIHRlc3QgdGhlIGZpcnN0IDIgcGF0Y2hlcyB3aXRoOg0KPiA+
IDEpICJtZGlvIiB3aXRob3V0IGEgY29tcGF0aWJsZSBzdHJpbmcuIEl0IHNob3VsZCB3b3JrIHdp
dGhvdXQgd2FybmluZ3MuDQo+ID4gMikgIm1kaW8iIHdpdGggYSBjb21wYXRpYmxlIHN0cmluZy4g
SXQgc2hvdWxkIHdvcmsgd2l0aCBhIHdhcm5pbmcgYXNraW5nDQo+ID4gdG8gcmVtb3ZlIHRoZSBj
b21wYXRpYmxlIHN0cmluZw0KPiA+IDMpICJ4eHgiIG5vZGUgd2l0aCBjb21wYXRpYmxlIHN0cmlu
Zy4gSXQgc2hvdWxkIHdvcmsgd2l0aCBhIHdhcm5pbmcNCj4gPiBhc2tpbmcgdG8gcmVuYW1lICJ4
eHgiIHRvICJtZGlvIiBhbmQgcmVtb3ZlIHRoZSBjb21wYXRpYmxlIHN0cmluZw0KPiA+DQo+ID4g
SW4gYWxsIHRob3NlIGNhc2VzLCB0aGUgc3dpdGNoIHNob3VsZCBzdGlsbCBrZWVwIHVzaW5nIGlu
dGVycnVwdGlvbnMuDQo+ID4NCj4gPiBBZnRlciB0aGF0LCB0aGUgbGFzdCBwYXRjaCBjYW4gYmUg
YXBwbGllZC4gVGhlIHNhbWUgdGVzdHMgY2FuIGJlDQo+ID4gcGVyZm9ybWVkOg0KPiA+IDEpICJt
ZGlvIiB3aXRob3V0IGEgY29tcGF0aWJsZSBzdHJpbmcuIEl0IHNob3VsZCB3b3JrIHdpdGhvdXQg
d2FybmluZ3MuDQo+ID4gMikgIm1kaW8iIHdpdGggYSBjb21wYXRpYmxlIHN0cmluZy4gSXQgc2hv
dWxkIHdvcmsgd2l0aCBhIHdhcm5pbmcgYXNraW5nDQo+ID4gdG8gcmVtb3ZlIHRoZSBjb21wYXRp
YmxlIHN0cmluZw0KPiA+IDMpICJ4eHgiIG5vZGUgd2l0aCBjb21wYXRpYmxlIHN0cmluZy4gSXQg
c2hvdWxkIHdvcmsgd2l0aCBhbiBlcnJvcg0KPiA+IGFza2luZyB0byByZW5hbWUgInh4eCIgdG8g
Im1kaW8iIGFuZCByZW1vdmUgdGhlIGNvbXBhdGlibGUgc3RyaW5nLiBUaGUNCj4gPiBzd2l0Y2gg
d2lsbCB1c2UgcG9sbGluZyBpbnN0ZWFkIG9mIGludGVycnVwdGlvbnMuDQo+ID4NCj4gPiBUaGlz
IHNlcmllcyBtaWdodCBpbnNwaXJlIG90aGVyIGRyaXZlcnMgYXMgd2VsbC4gQ3VycmVudGx5LCBt
b3N0IGRzYQ0KPiA+IGRyaXZlciBpbXBsZW1lbnRzIGEgY3VzdG9tIHNsYXZlIG1paSwgbm9ybWFs
bHkgb25seSBkZWZpbmluZyBhDQo+ID4gcGh5X3tyZWFkLHdyaXRlfSBhbmQgbG9hZGluZyBwcm9w
ZXJ0aWVzIGZyb20gYW4gIm1kaW8iIE9GIG5vZGUuIFNpbmNlDQo+ID4gZmU3MzI0YjkzMiwgZHNh
IGdlbmVyaWMgY29kZSBjYW4gZG8gYWxsIHRoYXQgaWYgdGhlIG1kaW8gbm9kZSBpcyBuYW1lZA0K
PiA+ICJtZGlvIi4gIEkgYmVsaWV2ZSBtb3N0IGRyaXZlcnMgY291bGQgc2ltcGx5IGRyb3AgdGhl
aXIgc2xhdmUgbWlpDQo+ID4gaW1wbGVtZW50YXRpb25zIGFuZCBhZGQgcGh5X3tyZWFkLHdyaXRl
fSB0byB0aGUgZHNhX3N3aXRjaF9vcHMuIEZvcg0KPiA+IGRyaXZlcnMgdGhhdCBsb29rIGZvciBh
biAibWRpby1saWtlIiBub2RlIHVzaW5nIGEgY29tcGF0aWJsZSBzdHJpbmcsIGl0DQo+ID4gbWln
aHQgbmVlZCBzb21lIHR5cGUgb2YgdHJhbnNpdGlvbiB0byBsZXQgdmVuZG9ycyB1cGRhdGUgdGhl
aXIgT0YgdHJlZS4NCj4gPg0KPiA+IFJlZ2FyZHMsDQo+ID4NCj4gPiBMdWl6DQo+ID4NCj4gDQo+
IEkgbWlnaHQgaGF2ZSBmb3Jnb3R0ZW4gdG8gYWRkIGEgbmV3IGxpbmUgYWZ0ZXIgdGhlIHN1Ympl
Y3QuIEl0IGF0ZSB0aGUNCj4gZmlyc3QgcGFyYWdyYXBoLiBJJ20gdG9wLXBvc3RpbmcgaXQuDQo+
IA0KPiBSZWdhcmRzLA0KPiANCj4gTHVpeg==
