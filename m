Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5FB442BC29
	for <lists+netdev@lfdr.de>; Wed, 13 Oct 2021 11:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239187AbhJMJyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 05:54:13 -0400
Received: from mail-am6eur05on2097.outbound.protection.outlook.com ([40.107.22.97]:61171
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238206AbhJMJyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 Oct 2021 05:54:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K1aAQTmF1nfNZ+4DeGwOP0AU69uXu/9YIjBauLBtM5nxOjZUlDEALqO2EyUYi8+qcGPfGqzDoAkC5jcExHhexvY9xizk6NsSd6TpIP+TvTGhDhmwpRzyGzabbkqUYA7Jjsrb/BscNwpW2Ory5dKA88ONJb3M6ZVCI1AgKTMJ9oo6GA3Ckd5xr7aGAXlaJJ+i+OKOJ+KTXd/eiY61YncHCMsDCZNS6GpABqHmgJQr0/MTmbDf646hiU08TTW6d3sKYzabtafST6KxzuU4jRQNHUt5aB+TCl90sfgjWmBwn6cqOyKUREdxIZsJNpLN90LwN2bFUNXtXWaSED3HhoyjXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qx69sN3dLeDoMSsbT4vDj+5edb5pjT/zt4r/qolTOb4=;
 b=aQ/hXT/tgr63SH2NyjQsnr+FAFKp2JZ+htWisG1Dwi7KWC7IKyW/FwICl8Q7lc7bUw0OGNDpfawx2BPtO2LubtYAlANGCW7/5ZkXCe3BUNr7TwL61OHQJaKbLO/8g8i7dsfi4vo2Bn9nXgLOpUV5cqfN2c3zMXGzRykHzljmEAj2xQvO6lq2hVkYOINsq4Em9okNrwN6osQR7cL8tPS7hut9D30pk39A3vcXuAD6Wi8mTORJVM4YY749/PjmGQdKDFcEhJxa8FxOEwMx36Dn0JY/dMH/wVm/G+AF/E0vqZvH4/mAJgWgYRz6XzY9zcLXHpm83QxlBzt/BYDGkdNbyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=bang-olufsen.dk; dmarc=pass action=none
 header.from=bang-olufsen.dk; dkim=pass header.d=bang-olufsen.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bang-olufsen.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qx69sN3dLeDoMSsbT4vDj+5edb5pjT/zt4r/qolTOb4=;
 b=tNfUFKr9g6DpcK4Mt37bxX571FLAQ1smGUDJjbeo7JvDbVnxYIDf3WShhorF/ZaYmUtHB1U3pyn9exwPdnrtBVNRJ4Lp0OZPocYk2Opi66Ghb4VGcjSK94JONQMQQmYDupgrBSTK0hjK+SMUocJ1HDJi8lORlKbpwpGFdksUCyQ=
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com (2603:10a6:7:60::18) by
 HE1PR0301MB2412.eurprd03.prod.outlook.com (2603:10a6:3:6f::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4587.24; Wed, 13 Oct 2021 09:52:05 +0000
Received: from HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56]) by HE1PR03MB3114.eurprd03.prod.outlook.com
 ([fe80::d984:dc33:ba2e:7e56%5]) with mapi id 15.20.4587.026; Wed, 13 Oct 2021
 09:52:05 +0000
From:   =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <ALSI@bang-olufsen.dk>
To:     DENG Qingfang <dqfext@gmail.com>,
        =?utf-8?B?QWx2aW4gxaBpcHJhZ2E=?= <alvin@pqrs.dk>
CC:     Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 4/6] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Thread-Topic: [PATCH net-next 4/6] net: dsa: tag_rtl8_4: add realtek 8 byte
 protocol 4 tag
Thread-Index: AQHXv2Xk4ZzjiU9NskmrdkmqALWWxKvQr0EAgAAB5YA=
Date:   Wed, 13 Oct 2021 09:52:04 +0000
Message-ID: <2dfff5ad-2483-b6bc-16fa-70025acd835a@bang-olufsen.dk>
References: <20211012123557.3547280-1-alvin@pqrs.dk>
 <20211012123557.3547280-5-alvin@pqrs.dk>
 <20211013094516.55722-1-dqfext@gmail.com>
In-Reply-To: <20211013094516.55722-1-dqfext@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=bang-olufsen.dk;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 675ff07f-fa7b-4436-5ef1-08d98e2f1cfe
x-ms-traffictypediagnostic: HE1PR0301MB2412:
x-microsoft-antispam-prvs: <HE1PR0301MB2412B5D0D91A21E35FB61DE183B79@HE1PR0301MB2412.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lOpPYjxC3AEpOrV2rXaTyiGcFe04o6WSYrE0mlig3mD/Apjw44UZ/LWoSQ0w0tOKJgBjUC1Y/mpeza61RTuxv59RM/DmX5W800ag7aprtqp5ks46sL53mcMpd1vQBwYoAwOAW0xAQowFsvSN8Ix8HlWW22/HG1pGfv/8bzHxAFH1zl8JVhkiL4YONIAyQLIDHv29C2srLHBPbjuR4QIW6hSfXDYQnBfq5HAsPWTKlYrng5i2VFdhiiflx5MyHylLCUikwBv/MhevO+nhu5K+BH1B2xjVAwkKSt6uPFmf7xuIwBClYqZM2gjOMPCH0aBHBouWAyyFGCOXWZqhpqZ65rn7uTeg2uNV0t663RxR9fIKOhUec9JWDXrfrGe09001xSNcGzDw5uoimuVPcYt2ksCruVqfBjpDMim5ZzeTiRhnxCRaDVYUJjDquelRsHcJ186pWdcnroXNWjuAscgjecgUbdPm8wC6lRGGkKgx3Cq2VFk1W/F9x49TCLni4jZ9cErDFIHXVyhq7ZwiTbc3RB8Gj8xJAAJ1U8t+99WHHDHR0phWiUi1Xhfgap0NIh2fat7bWaVTgqbOhJNGGtD34wNr+y58+toR5dvOZUK4CDHxPmyH9lNGCGEXaxxapANYZ3I+0jp2U3VOOti1O3X/2/uQKsg9tw5HJOiMpj8d4rH9U5ITqKtDmFUFPKRhvQawW1ngTvDvXAQxXBlOjRHj4tP51XZi6FxKdOXHC6sAsT3/tr4B8OvMkwGvbPJx+kSc4GRlncNVT4xuOQA6WYwJ4Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR03MB3114.eurprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(36756003)(6486002)(85182001)(2906002)(2616005)(85202003)(76116006)(26005)(316002)(508600001)(66574015)(6506007)(66946007)(8936002)(64756008)(66446008)(8976002)(54906003)(186003)(31696002)(38100700002)(66476007)(86362001)(110136005)(38070700005)(4326008)(122000001)(83380400001)(66556008)(7416002)(53546011)(71200400001)(5660300002)(8676002)(31686004)(6512007)(43740500002)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tkw3MDBBM2d2VFRNazlvYTBNdzh4SVhFS1drUUpLZDc5M2p3T3Uzb29jK2NG?=
 =?utf-8?B?dkU5QlZkd2pWeDFHaE8vNVVWWjBEWEg3VEhGWUxFL1M0bnBrQkl2S0tnWWNC?=
 =?utf-8?B?dXlHblpaYWlCNTArUmFjalFXck5uT2FvemRjT29qOWRLSGQvSTVFMXRmZzFK?=
 =?utf-8?B?dHluTmt3MWJOZVR2N3NKaSt1ZGIzemNOckhlWnlreW1tR1BiL0d2clJCdlkw?=
 =?utf-8?B?bnQyZU5EV0lyTzNVc1RZcXMrbHJYbjA1WFVhS0N3TWMxUitJM0ZNL04wUXMr?=
 =?utf-8?B?VlFHY04rYWxpTndpSExqcHNXNkN4VDdwVXFrdU9GbFVpendOUGx3SXM3Tk5p?=
 =?utf-8?B?cXZxQmpuMzB5NFV5TTNsOGI2RW56U1hsQ3NuYkRjRHNOcFVESGlyRHBEUCtG?=
 =?utf-8?B?TmNLTkUvdjA3MFhKaER6djJrdUVneHJUanA0YWxjc0FZSFliV0tVLzRtVzZI?=
 =?utf-8?B?WjY5bUZPenBKWUIrZmpNYW14Y2NCSWZFNFJpZVk0RTk0K2w3aWl3T251WElT?=
 =?utf-8?B?V0ZXWElLMVJhcmFaNTlBRGxMTytHenl6MDVKK3ZoZzl5Ujl2Z2ZnZisycTB5?=
 =?utf-8?B?QjYxNVZTckZic2JSM3dJajIzWXgxSmZMK05FMTd1aTg4RUp3enpXcFFIRnIy?=
 =?utf-8?B?ajdpUk8xeHl1dGF2cXkwVkFuM3hZZ1Y5MW1nQ2RvbTZjRkh0WVl0K01TSlBm?=
 =?utf-8?B?UE5UR0toOWIxUmRUQU1sTEFaRjNlOFZyWFVObDRXZWpYK1RWT1oyRzFQUTNr?=
 =?utf-8?B?aGp1WFM4LzdKVmdjeWFaYnhZRWtwTnBkMXZ0b0dqTlBDaWI5dlNwRjlRc01I?=
 =?utf-8?B?TDZqTVZmb0NNQlVlZVNaY05jTU1xaS9JajM4UzBobDFzM1VqaDN0QjV5d2FM?=
 =?utf-8?B?NS9RMUQ1aWFkUXpob2g5M1FxajRrV0ZjamNwUXhaeEtBZHZ1dnhjd2ttZHFy?=
 =?utf-8?B?ZXZJakZ4WVFRY0xTODYyalRMSy9WeXFrd3FxQ1k2bUdFYkt2WW43cU8rOGY2?=
 =?utf-8?B?SmtJL0RYN1VHWlYrRTNKaktmeFJmYnZnZEdsc2VWeCs0Y2djaHFqcnkxTmhs?=
 =?utf-8?B?NUdHcXhUNkhoNkpWaXBVeXJWU3dkOHhqUkJSTXF3dzY0SytXZFRpWjlwVmEx?=
 =?utf-8?B?QjBlZ1VTVDluTFl6b3JDZ1Z4YnEvUnhDV1pwVnovQW5BbDJXeWk4S3RXc1ZJ?=
 =?utf-8?B?UUJ0SFg0eHpHTDVlMFpTYm5tRWdacXlpQ3hGT3FwS3A4ZnRiYnRWSkZHQWFG?=
 =?utf-8?B?bDkvdzhRQzdMaHpZZzBMZk0zMGd4d0ZZTVVkWlQyK29vYlEwUHFVcmxQanBv?=
 =?utf-8?B?QWZsd2JaZVhQSDZ1ejJVWk1ScCtBMytHTk1ZQ3luNVA4c2l4eTN6dTNnUE84?=
 =?utf-8?B?UmRleTRMazg3VlBXMW1RVnExVHVnSmpETk9vT1RwR0x2cFVMU0lqdWI0Z1Y0?=
 =?utf-8?B?VmNmMkdteGtpY0V5K293UnVFWmtXWWRRTGdrb0VFazNjVktaQ3VNNEJmVzFQ?=
 =?utf-8?B?VEphSkpYTW9EVG00RGFsbnlDOEJ0VFM0ZjJILzJBVGh6TzdNVTVKbFQ3NzZq?=
 =?utf-8?B?M0NPUkJmVnoyM1BYczVtU284RTJTSURMcVBHTGNOWHlpR29BNGI1T2FBQnJN?=
 =?utf-8?B?WHhLajl3WCtzV3FGQzdRMGVaUXpiaGtpMTNxVHMzZmtZamxORHRlcE9DZDNO?=
 =?utf-8?B?WWRycXN3ek5QY2ZDSC9rNkpmdmxORHJNZzdnbGE0UzhMbDl6OGVndExsOW1j?=
 =?utf-8?Q?5KEn3jMJLbGL1h7UcYxbtyMgOVuKAkkoyvM3/8I?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D513456F74EEB046A26235F67910DA53@eurprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: bang-olufsen.dk
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HE1PR03MB3114.eurprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 675ff07f-fa7b-4436-5ef1-08d98e2f1cfe
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Oct 2021 09:52:04.9206
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 210d08b8-83f7-470a-bc96-381193ca14a1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: TZZleXSYYujTb36fZwa59zIU60N/DEjwZakWFN4gph9DsSO98+CX098XK9VTgH3BiPZIUxa4+RG13ClZ0LrGAA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0301MB2412
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTAvMTMvMjEgMTE6NDUgQU0sIERFTkcgUWluZ2Zhbmcgd3JvdGU6DQo+IE9uIFR1ZSwgT2N0
IDEyLCAyMDIxIGF0IDAyOjM1OjUzUE0gKzAyMDAsIEFsdmluIMWgaXByYWdhIHdyb3RlOg0KPj4g
K3N0YXRpYyBzdHJ1Y3Qgc2tfYnVmZiAqcnRsOF80X3RhZ19yY3Yoc3RydWN0IHNrX2J1ZmYgKnNr
YiwNCj4+ICsJCQkJICAgICAgc3RydWN0IG5ldF9kZXZpY2UgKmRldikNCj4+ICt7DQo+PiArCV9f
YmUxNiAqdGFnOw0KPj4gKwl1MTYgZXR5cGU7DQo+PiArCXU4IHByb3RvOw0KPj4gKwl1OCBwb3J0
Ow0KPj4gKw0KPj4gKwlpZiAodW5saWtlbHkoIXBza2JfbWF5X3B1bGwoc2tiLCBSVEw4XzRfVEFH
X0xFTikpKQ0KPj4gKwkJcmV0dXJuIE5VTEw7DQo+PiArDQo+PiArCXRhZyA9IGRzYV9ldHlwZV9o
ZWFkZXJfcG9zX3J4KHNrYik7DQo+PiArDQo+PiArCS8qIFBhcnNlIFJlYWx0ZWsgRXRoZXJUeXBl
ICovDQo+PiArCWV0eXBlID0gbnRvaHModGFnWzBdKTsNCj4+ICsJaWYgKHVubGlrZWx5KGV0eXBl
ICE9IEVUSF9QX1JFQUxURUspKSB7DQo+PiArCQlkZXZfd2Fybl9yYXRlbGltaXRlZCgmZGV2LT5k
ZXYsDQo+PiArCQkJCSAgICAgIm5vbi1yZWFsdGVrIGV0aGVydHlwZSAweCUwNHhcbiIsIGV0eXBl
KTsNCj4+ICsJCXJldHVybiBOVUxMOw0KPj4gKwl9DQo+PiArDQo+PiArCS8qIFBhcnNlIFByb3Rv
Y29sICovDQo+PiArCXByb3RvID0gbnRvaHModGFnWzFdKSA+PiA4Ow0KPj4gKwlpZiAodW5saWtl
bHkocHJvdG8gIT0gUlRMOF80X1BST1RPQ09MX1JUTDgzNjVNQikpIHsNCj4+ICsJCWRldl93YXJu
X3JhdGVsaW1pdGVkKCZkZXYtPmRldiwNCj4+ICsJCQkJICAgICAidW5rbm93biByZWFsdGVrIHBy
b3RvY29sIDB4JTAyeFxuIiwNCj4+ICsJCQkJICAgICBwcm90byk7DQo+PiArCQlyZXR1cm4gTlVM
TDsNCj4+ICsJfQ0KPj4gKw0KPj4gKwkvKiBQYXJzZSBUWCAoc3dpdGNoLT5DUFUpICovDQo+PiAr
CXBvcnQgPSBudG9ocyh0YWdbM10pICYgMHhmOyAvKiBQb3J0IG51bWJlciBpcyB0aGUgTFNCIDQg
Yml0cyAqLw0KPj4gKwlza2ItPmRldiA9IGRzYV9tYXN0ZXJfZmluZF9zbGF2ZShkZXYsIDAsIHBv
cnQpOw0KPj4gKwlpZiAoIXNrYi0+ZGV2KSB7DQo+PiArCQlkZXZfd2Fybl9yYXRlbGltaXRlZCgm
ZGV2LT5kZXYsDQo+PiArCQkJCSAgICAgImNvdWxkIG5vdCBmaW5kIHNsYXZlIGZvciBwb3J0ICVk
XG4iLA0KPj4gKwkJCQkgICAgIHBvcnQpOw0KPj4gKwkJcmV0dXJuIE5VTEw7DQo+PiArCX0NCj4+
ICsNCj4+ICsJLyogUmVtb3ZlIHRhZyBhbmQgcmVjYWxjdWxhdGUgY2hlY2tzdW0gKi8NCj4+ICsJ
c2tiX3B1bGxfcmNzdW0oc2tiLCBSVEw4XzRfVEFHX0xFTik7DQo+PiArDQo+PiArCWRzYV9zdHJp
cF9ldHlwZV9oZWFkZXIoc2tiLCBSVEw4XzRfVEFHX0xFTik7DQo+PiArDQo+PiArCWRzYV9kZWZh
dWx0X29mZmxvYWRfZndkX21hcmsoc2tiKTsNCj4gDQo+IFRoaXMgc2hvdWxkIG5vdCBiZSBzZXQg
aWYgdGhlIFJFQVNPTiBpcyB0cmFwcGVkIHRvIENQVS4NCg0KVGhhbmtzLCB5b3UncmUgcmlnaHQu
IEFsdGhvdWdoIHdpdGggdGhlIGN1cnJlbnQgc3RhdGUgb2YgdGhlIGRyaXZlciwgDQpza2ItPm9m
ZmxvYWRfZndkX21hcmsgd2lsbCBuZXZlciBnZXQgc2V0LCBiZWNhdXNlIHRoZSBicmlkZ2UgaXMg
bm90IA0Kb2ZmbG9hZGVkIG9udG8gdGhlIEhXLiBCdXQgSSB3aWxsIGZpeCB0aGlzIHVwIGluIHYy
Lg0KDQo+IA0KPj4gKw0KPj4gKwlyZXR1cm4gc2tiOw0KPj4gK30NCg0K
