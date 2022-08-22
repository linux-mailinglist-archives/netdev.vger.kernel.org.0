Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A5E659B735
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 03:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232220AbiHVBQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Aug 2022 21:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiHVBQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 21 Aug 2022 21:16:11 -0400
Received: from EUR03-AM7-obe.outbound.protection.outlook.com (mail-am7eur03on2056.outbound.protection.outlook.com [40.107.105.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 412201E3DB;
        Sun, 21 Aug 2022 18:16:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OR0qGmlHV7zMqQ4lUQkaeB6QMJE7QUEbtQ3SeeJJ2RWFda4JP03ewC04R4AE3x/K1FAwNmHbti2hv+ohu64TRW7k5if6Otxabs412zN0qEE3lRzqH8Mi76K1P8Uf3OFqxCf7EuDhAJvlA6lhoKGAlm+taVuOd2ms6th4eXeojL1eoB4/ceYI+m0+z4PkioXfVBHpCzSk4xLdnTvPxjaNFACjB0c6EfGwJU8vdKmLfnuA/31u9g+ZhpbvRLcMmg+phXBFLQdejXio9VRM6X0cmMmG9Uht0QcrxeYzwz3hPfEtiPuLwc5FYNuFjSy/yx6M/ZDyBkOupJN6TOp82UKHaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=958ByJeyvBxvjAecOU2rlOnvxL4Ujt+3tWJlJneh26U=;
 b=W8bjIBdHcZCTVq6QgkYWppWyDmIsdlFJUz3M5S7gGM7LmeGlpMPz9n8MwbXPbn/+18edtfLTwFZLiK0pCAPffw1iT6uG6rV1Xuozw9UU+kaXYA9X8a0RUkg5u7HronlxtpsjI24qVktybW6akEMxNObHs1DIhfPj0MOEuRQjRIYrIl08Yx0A5OmGdZUSCkOliQcvdHkJKjmR8XfAA9v90UNiYLRiqp1KgdB7RJtDzatlzdReRpe3WY9QRBV1BtLTSoLeZ53qAh6a08XnTwis5+oO4R0xd0OJuMs33Zx9MG/xKJ1ZB6UYzoZd2sclVcumW4sFhaFxOIV7VM63+CuF6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=958ByJeyvBxvjAecOU2rlOnvxL4Ujt+3tWJlJneh26U=;
 b=SRj0Abh88wNwKo04uhM85/j5O1cGwbIbiRXqNleLbpTPBcE6VwtZQ8B+17isUdkT+ItLtGEpCvaxm6SZVA3L58Yo4TKh7nBX50W7yI+WR+cnJmGPfKXf2nZ6qGQ/qHSaC16302hn1D5vOs/EGfjKXtMJpik17WFcg//W5SQI/pE=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by AM4PR0401MB2321.eurprd04.prod.outlook.com (2603:10a6:200:4e::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.22; Mon, 22 Aug
 2022 01:16:07 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::a569:c84a:d972:38ce%9]) with mapi id 15.20.5546.022; Mon, 22 Aug 2022
 01:16:07 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] net: phy: tja11xx: add interface mode and
 RMII REF_CLK support
Thread-Topic: [PATCH net-next 2/2] net: phy: tja11xx: add interface mode and
 RMII REF_CLK support
Thread-Index: AQHYs5/7Pmbzvoq/SES6HkkHV8AXrK22LUeAgAP0sxA=
Date:   Mon, 22 Aug 2022 01:16:07 +0000
Message-ID: <DB9PR04MB8106835D3FDF68248ED3DC2188719@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20220819074729.1496088-1-wei.fang@nxp.com>
 <20220819074729.1496088-3-wei.fang@nxp.com> <Yv+HFz/q1iGFfQ+m@lunn.ch>
In-Reply-To: <Yv+HFz/q1iGFfQ+m@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fb5a5d6a-aa6b-430e-c2bd-08da83dbe418
x-ms-traffictypediagnostic: AM4PR0401MB2321:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IvxWc/BTIM5OerM9VK86b49asKBg1r5KXVhBpkCTCecAHzBunUPUzHupFxVtDRZ9K4uzg8vBQo2oHiQhBcVvXORAC0VOWI60Mxk9kg2PU10H+zR4Wq0ZYKOxyFJivD1n1EtGSVr90HTsfDPiEOm9iTsf61counQqwlqIvwcZesA8gi0V8JFh/lL3Hq1tgOYiPg2U6tvi2veya3culxxVLFyEE+uAF4ApvxbSicsmFKgxKqltPXqqgB5JbMeWGpAAA/PbkeIS2b5X0XgyvF2AnDPvLrDQYe2pXVOLMrJCMuaFo4CLlPmQ5wHF9qFTcehLHbfU8y+BBvqawFbP+efWa4o3y2OTdZgEUyKuZIKP/Rqo3o12FXLLNHL3uWMA83+gGoF9aclrQELT9MN1HfGAgc0tZgk+vD6qFo4TPqjTCwN9eiGY3+AmVLYbeVIXQ1omgc5wvdvcllkv2gjnLOFbc3AIkMA1YgCH6GB+rFKfa4uwVidxg5POyR4SR2gLPYQGsFbvpQ2QlXcBD3GyK1tLMeEpYQ9zd2raqYzqJMfA7+nwbG6s/TuEVys6ktR142CzdrxrRuuGcicnvSJc239CKlaZDCIgEvaWKsGC8NT5mBKuX2E/1Y2xHAm8o3VzWVu5FQr5mTdx3/FEoh1JlrC2kuYNX8v5/Mc9F/tDFU9QhB4IoS2HsAE7+FT4T/D/ojzPCSs7zmfPEI0DXUI2NDiSwdK5jyXVN6ZSCERrQ1IMeW4ZcH9i+SegFEx+a1gN4eggFvWqRutCiOuGWYGSFfPPvg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(39860400002)(346002)(376002)(136003)(396003)(55016003)(38100700002)(83380400001)(38070700005)(66556008)(76116006)(66476007)(66446008)(64756008)(54906003)(71200400001)(8676002)(316002)(4326008)(6916009)(66946007)(9686003)(26005)(33656002)(86362001)(6506007)(5660300002)(2906002)(53546011)(7696005)(186003)(44832011)(7416002)(41300700001)(478600001)(52536014)(4744005)(122000001)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?K3J1K04wZU5nUGdNYnZic3lHSnFudVV0dlpVdkVXbEh5N2FlaVlqa1RnM2Jl?=
 =?gb2312?B?ZTdFMGtBYThlR0ZRWEM4MVVFQXNnWEtDWXRBN29HUkV6bk1zaEtGcVV6cGVl?=
 =?gb2312?B?MDVmUWhrVDlHT0QrZ1U1S2pJRjdhc2tGVE16bkNIRzlBY1R5a3BuNU5uUzFF?=
 =?gb2312?B?V0FsbzdBdng4UzFHbVgwTGdWRlRtNVZqUWw0UUxLYmZQUmFETnJLNEQrK0hN?=
 =?gb2312?B?ZEs2cjVDWVVDczRROEtwZFFjc3UxWUl4WGphM2JlTUJsdWl5cnptUmc0Qk9Z?=
 =?gb2312?B?dy9IaE93YmpzcVdNYmkwcldnWkcrdmc5RGgvb29xQ0RuVkROY1lsRVBXVFda?=
 =?gb2312?B?Y016RmoxRGx5a3dnNHBKay9UT3ZFYjMwRlRmdXZrdkFJSWRzdENNLy9RNjRY?=
 =?gb2312?B?N0phKzNIYmpCREdaQmRZU0VaREhQMXI5NU5ueC9UYXRFYVZEak9BWTlvTDdS?=
 =?gb2312?B?SEpWTmphcDlWc25ob1MzNTlibUNnMjhpS0xqRDRKMUhjZldhSnlvcGlLM3JX?=
 =?gb2312?B?eDdwRlFibldLWno5L1pOODIxTFRXY2lkWmk4Zmsyb1RnUkVRZUNSUHhiVnFa?=
 =?gb2312?B?MmtGTUV1aHVsWitaV04reENGOTQ1blFvSkwwWmE1dHA5cGd1TWhQWk9rWDlr?=
 =?gb2312?B?ZGxxYVA1UElyanRIbkw3VUZvNDliemJ0UUhnWEE1Y3VQeEtvNEtPdHBkaUZL?=
 =?gb2312?B?L0pmVUdtSjJMT3piYkVDUGxwWjZITURibDNacEZLTXRkZ2FUZTNPNi9jWWMx?=
 =?gb2312?B?bVpPSXVXamJkSW5aNXRtSEdvRFdrMzg1blZoWmVrK2E2NjRrS05qR0tMK0Fr?=
 =?gb2312?B?Q09xTWRtbjd1bXh1Z0l1dW05NDFMcjM2V211NDgyVEg5VVRzTFdiaEtuWWhv?=
 =?gb2312?B?RFIyWExDSFZBM3M0SjNKMkVRaGUyRi8rZVZLbmFLbGtkb0gwM0x5dFJ5bXEw?=
 =?gb2312?B?N0ZLYUtKNG5sRSs3YTgxNUNjN3owQmlIT0JHSG1MM09EV2Z4WDdpZ3daTWg0?=
 =?gb2312?B?VzZYVVgxdkNJbUJoVWw4OGRvSzAxb0tvUXA5V2tSQUE2TzZJSHRZdVNKa0M0?=
 =?gb2312?B?VFYrenpDN05CdDNUYXVaVjJpV2xheHJLT0RROWtkT3RxZS9DSHFBL3FISmV3?=
 =?gb2312?B?dkVHWXB0UTl3T2VlSGJKdS9HK004QjFkVmZCcTFKeU1nTytoM0lxME40NzZp?=
 =?gb2312?B?Y0tidjNEbFVHYmdZWFFBOC9EVU1MOTFtaFFEMnNPMU1pa1M2WUZPOXBlUllv?=
 =?gb2312?B?WitCMzBZRCs4RDBFZ1VQK1RobTJwd0RuL3NjczMvNlhOZFFiL1lLa0lvc2hV?=
 =?gb2312?B?RkVZUjFJb0FVQi9ia0ZrZEpVcXZIMEpoeEZuRGlwRGErK2JhTTJBc3dhT0VM?=
 =?gb2312?B?VlN0STFsYWNxb2FralJpVURBNVdRcDdVYlJVd3Vuc0xJMUxUbWFwcVhGWmFS?=
 =?gb2312?B?TVFCNlZZUWMwQll5dGVhdHU0VmRuQUppT0l5VDdKMGNLZGNZODVCc21TdWtV?=
 =?gb2312?B?VFpveUNscy9wWjhpM1RXLzU5czJIemRnVVR6bjRmTlYyejB5NEZNeC9YbWRW?=
 =?gb2312?B?Q2tPbGROV240SDJYL2lpaDFYa3FTZUtPa2RncXlKNHpqM2NCVmk0d3N0QVVr?=
 =?gb2312?B?dThKVks4c0VhWHFuZVh6RnBuYlozSzNsK0RxODRIVUo5Mm1TK3VJZ0IvTWJ3?=
 =?gb2312?B?enc3SjZlU210YWJpcmZEY0VnN1puaWw1QWNQNG80aE9Meml1bzBzMWhhMjdn?=
 =?gb2312?B?YUNvQ0NqWWhCUTJ4YkQ0Zmx3Qm1XSkJkdk14bWZsZW1DdFpvc0dpeVhLNEtu?=
 =?gb2312?B?N3M1YWdiK29TM2FBUEdyVldtN3RZNFpzQXMvTFNNTGJFUkEwZGlMTDJLc0R6?=
 =?gb2312?B?eWtRZjdEWFRBOUVyY2VwMGRnYkg0RW1PNnB3N05CNlVTVFphbFliQytPaTgr?=
 =?gb2312?B?cVNiNlUrZzlWYVVTa0EwUEFyVFM4UExhQmE5S2ZuTDZnc2hqL2ZGeDFzSlNv?=
 =?gb2312?B?ekh3YmtzTnh2VnlKUURWVFRVVGFpb0pYOXJCR1VkeGxjOXk0OFc5b0dLRHBW?=
 =?gb2312?B?a3NyODgyZDNJMGtRYUFHSzRadjQ0MVNtelJLb0dyM0ZtVlZoS3BFZzREQzRJ?=
 =?gb2312?Q?8Oy4=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb5a5d6a-aa6b-430e-c2bd-08da83dbe418
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2022 01:16:07.3937
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: mLZ6+cChpQEQ2DmOZTiDQX3ittrERYY6nhQMoeYvtR6UhT9k1rb2u8VjrYWnFDuGYd0h8PAaOlCqq/4LJW0gJA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0401MB2321
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogQW5kcmV3IEx1bm4gPGFu
ZHJld0BsdW5uLmNoPg0KPiBTZW50OiAyMDIyxOo41MIxOcjVIDIwOjUxDQo+IFRvOiBXZWkgRmFu
ZyA8d2VpLmZhbmdAbnhwLmNvbT4NCj4gQ2M6IGRhdmVtQGRhdmVtbG9mdC5uZXQ7IGVkdW1hemV0
QGdvb2dsZS5jb207IGt1YmFAa2VybmVsLm9yZzsNCj4gcGFiZW5pQHJlZGhhdC5jb207IHJvYmgr
ZHRAa2VybmVsLm9yZzsga3J6eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnOw0KPiBmLmZh
aW5lbGxpQGdtYWlsLmNvbTsgaGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9y
Zy51azsNCj4gbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5v
cmc7DQo+IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRD
SCBuZXQtbmV4dCAyLzJdIG5ldDogcGh5OiB0amExMXh4OiBhZGQgaW50ZXJmYWNlIG1vZGUgYW5k
DQo+IFJNSUkgUkVGX0NMSyBzdXBwb3J0DQo+IA0KPiA+ICsvKiBDb25maWd1cmUgUkVGX0NMSyBh
cyBpbnB1dCBpbiBSTUlJIG1vZGUgKi8NCj4gPiArI2RlZmluZSBUSkExMTBYX1JNSUlfTU9ERV9S
RUZDTEtfSU4gICAgICAgQklUKDApDQo+ID4gKw0KPiA+ICBzdHJ1Y3QgdGphMTF4eF9wcml2IHsN
Cj4gPiAgCWNoYXIJCSpod21vbl9uYW1lOw0KPiA+ICAJc3RydWN0IGRldmljZQkqaHdtb25fZGV2
Ow0KPiA+ICAJc3RydWN0IHBoeV9kZXZpY2UgKnBoeWRldjsNCj4gPiAgCXN0cnVjdCB3b3JrX3N0
cnVjdCBwaHlfcmVnaXN0ZXJfd29yazsNCj4gPiArCXUzMiBxdWlya3M7DQo+IA0KPiBBIHF1aXJr
IGlzIGdlbmVyYWxseSBhIHdvcmthcm91bmQgZm9yIGEgYnVnLiBDb25maWd1cmluZyBhIGNsb2Nr
IGlzIG5vdCBhIHF1aXJrLiBJDQo+IHdvdWxkIHJlbmFtZSB0aGlzIGZsYWdzLg0KPiANClRoYW5r
cywgSSdsbCByZW5hbWUgaXQuDQo=
