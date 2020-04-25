Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDB531B8318
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 03:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726107AbgDYBtP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 21:49:15 -0400
Received: from mail-am6eur05on2048.outbound.protection.outlook.com ([40.107.22.48]:31585
        "EHLO EUR05-AM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726032AbgDYBtM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 21:49:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iZ8x9yPonWVwRq4sqGHe1ZLJ/anzUDlkwQAGBGDcbY8A+OpLcrK1URWoXAVuUNDHtCYqrWoWjOC9jm/NqPvTXV6Za/BGxtdf0vyTtMyknq47z/bKVsgM56NHbQJLZ5umPIupy1ueHWmC/5vHXGydfvf+YheEObuV3kLvJVCR2K0QDAmgejk7jxBbtjtmkbJ/9LWLVQGyNWqx0F43Uy0xsQhO4e4MI2xvqeAWVKHCF3xV5kXt5ekQKarfm2mklOjAMfsBz52QTCw7cXNmgul5YYrNsifAKLSzje17u/r+ZmF1k3R5O4gLLNCLCresFDuyIWmZOQHWiCOoWu+YgJepCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dnZGiG5qBwtoLOz+ZC3DNQU40pjcs0tUiE3zrkn2DI=;
 b=cRm3/W69kJ7l0rwRMwQJdQbLATlngK7SQoeOK+2ceWk7mHRYTbA2G4YyArFvQwI/oUAKIbfOrbb7mNiCkwuwjoAz6C8Ht8UBKEU8WGQQRF5p/c5KRCDOmjeBhWCx3KfpgATZT4GWj+gW25TpiqAWl6LHBSHIKNDECIQNo0cMpZYZnQijvAxkAbzLK2kvjujFOOO5KJAGhAkVsfG9T04uHgNpMi5fVBFbk16cp61UNyNp1S6AcjwIdMCELYlsRwOIa+2DbBUCf73XFMh4ilZnNVpu7iqz3NsRl+MlO9xJKdy4jAIoJQRYp93Ic7ZfZ3ZJgS+k6oJVQm/uLAcAnLDIBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7dnZGiG5qBwtoLOz+ZC3DNQU40pjcs0tUiE3zrkn2DI=;
 b=hT3Yt8x2hlUM9hiBps/Z11P3aYfnbB1G/WUkDHehwXupbUi+x0KtKcUrJIXnsP0PzpcW7gAAadeqFoGpL9AR92qbqIzhNNMk6/rc4Fsu2b0fWxznVdrlc0s6A03PQmGMfHeHHSFRi1Twap+bsPNC4GobZJix0NsBWqN83HF0pDA=
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com (2603:10a6:803:11c::29)
 by VE1PR04MB6719.eurprd04.prod.outlook.com (2603:10a6:803:128::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.13; Sat, 25 Apr
 2020 01:49:08 +0000
Received: from VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173]) by VE1PR04MB6496.eurprd04.prod.outlook.com
 ([fe80::1479:38ea:d4f7:a173%7]) with mapi id 15.20.2921.036; Sat, 25 Apr 2020
 01:49:08 +0000
From:   Po Liu <po.liu@nxp.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "vishal@chelsio.com" <vishal@chelsio.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "jiri@mellanox.com" <jiri@mellanox.com>,
        "idosch@mellanox.com" <idosch@mellanox.com>,
        "alexandre.belloni@bootlin.com" <alexandre.belloni@bootlin.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "simon.horman@netronome.com" <simon.horman@netronome.com>,
        "pablo@netfilter.org" <pablo@netfilter.org>,
        "moshe@mellanox.com" <moshe@mellanox.com>,
        "m-karicheri2@ti.com" <m-karicheri2@ti.com>,
        "andre.guedes@linux.intel.com" <andre.guedes@linux.intel.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>
Subject: RE: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control
 flow action
Thread-Topic: [EXT] Re: [v3,net-next  1/4] net: qos: introduce a gate control
 flow action
Thread-Index: AQHWGFNl1uy1t0tlFE2NuiTq9Lz8sqiG+0OAgACaOiCAAPkGAIAAhDNQ
Date:   Sat, 25 Apr 2020 01:49:07 +0000
Message-ID: <VE1PR04MB6496FB4F90A5DEDD1CACBA7492D10@VE1PR04MB6496.eurprd04.prod.outlook.com>
References: <20200418011211.31725-5-Po.Liu@nxp.com>
 <20200422024852.23224-1-Po.Liu@nxp.com>
 <20200422024852.23224-2-Po.Liu@nxp.com> <878sim2jcs.fsf@intel.com>
 <VE1PR04MB6496B9EA946877FB473E5D7892D00@VE1PR04MB6496.eurprd04.prod.outlook.com>
 <874kt83ho7.fsf@intel.com>
In-Reply-To: <874kt83ho7.fsf@intel.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is ) smtp.mailfrom=po.liu@nxp.com; 
x-originating-ip: [221.221.133.215]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0f506947-0d06-42f9-1ad9-08d7e8bad821
x-ms-traffictypediagnostic: VE1PR04MB6719:|VE1PR04MB6719:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VE1PR04MB67192AC93663022F2698BD6B92D10@VE1PR04MB6719.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0384275935
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VE1PR04MB6496.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(376002)(396003)(39860400002)(366004)(86362001)(26005)(64756008)(6506007)(7696005)(5660300002)(110136005)(52536014)(54906003)(316002)(4326008)(71200400001)(44832011)(33656002)(53546011)(186003)(76116006)(66556008)(66476007)(66446008)(66946007)(9686003)(478600001)(8676002)(55016002)(8936002)(2906002)(7416002)(81156014);DIR:OUT;SFP:1101;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mLkDtAhUBPLH18HY2RYnilEFBH0d4Kd4kcojVMeYU3+ekG5rZxI78nouzl2ZRG/d9KXOAN3dljHbE8voVh9kLOPfIcw6xzMEhHsgWLVLzPllusUjSro1VQmHnLzgbV+MjJ/wEEErIwHkUb/Hy6GpuIWy/kpyQpgTkJlBMTyJLlExm9wa4UvfX6evKp/nbUHUgBTJOREQE2xmPW1ivTBbSZbA8nDpKzflHlYYH/hdXu+TQ45PSUexL8CjkRYxzep19wnM8tLrF3y8xDI3O+sKWYI7lZ/Vq4VD+vUIAYQsK5Knrfv+D3h7j6RzozPRQAV/rzHKExRa8/ABf7QYtWmL3keZKHtMKFUQm8AmTgDR7Iob2pFviDKVuxOrh6v6YltWGdrNl1jYGq4vkfKZOKI7QhRfJU6nm81CEXHV3Fji/DiCKEM40vLm5oPk1P3uL2I9
x-ms-exchange-antispam-messagedata: B4reaKBfwPbmgYRphwolGjfjj6O1E6Nik9AjogV4rhuiYxKqc/Zi9Y6xLciP3qYtXxoXGEtExr+ynod7f+3ntTAemF/7wFtMG+W6Ey1VVils/l1QiiSeb7mwCJeCkw3BsE6O+fVcK/GzoX0DFctJ8Ulp4Hv5igb6afHAmIvu5P5odDwk74P2kgd1WQLdqnLoxRLUTMgP9csGm/o8l6MUXCS8/5dJUM2UIkFck/6Rx4fO1pyRt+HzIxGNAKPbvNf8mV60prqy/fszYVR9TqsuGFRc7yRavD1LQmBoXSD7VzRalcCiixwuaHShlaY3pjegiVoCetgFEIsNSNGTxr+HiiUwiLrBVNc5URzau+44rK0WK3A4KvXKW3gcTl/bGuNOE+Gw/JvOvCUq1itjbGkNk+mNVh/n+J+/fM2M2RJA7MusnYIis0ybO713oYa6O0PLPv/UebJbjIRPdUBGZXC9yDW4Gj8K9jL3fPVZC1pyyk2v1lBFJgaED41GZJCofAfE8aOY3witprBgvkRViB+uiXXou20oO3oXNIMtZlMMnvfXpExC85RfVYCYo3M0JDDRpqa6Qla+ngzOMkHHHWKaBNrlo+xi3DRvC+Dbtk2hxzPlM9bz9kI/2mFWe7JMaaNd5h/7C723uyGn1jCy/OfZlqdSsj4bxNiLSzt6jXQYLkjQF7RtuV5S10OkKYiC1tNhPhW+ZJZSjupvZw9E2jW2PUQLEBrrJQJ1Am5hn7BbN44FGuR4FP/Kl9B6Yq08qSNWwx1PiaPelhS19MLAxb38FSiU+Tieg1MyYGsY/cLcyXbNZ0UCycxCCDiTWjafRfnc
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f506947-0d06-42f9-1ad9-08d7e8bad821
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Apr 2020 01:49:08.1824
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SL1JzK5HL7x6B/Kdz7pNAA3DEcyVYLi7jqm+4KBNEputoSNbjFUTcv3mYihG+UE2
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VE1PR04MB6719
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCg0KQnIsDQpQbyBMaXUNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9t
OiBWaW5pY2l1cyBDb3N0YSBHb21lcyA8dmluaWNpdXMuZ29tZXNAaW50ZWwuY29tPg0KPiBTZW50
OiAyMDIwxOo01MIyNcjVIDE6NDENCj4gVG86IFBvIExpdSA8cG8ubGl1QG54cC5jb20+OyBkYXZl
bUBkYXZlbWxvZnQubmV0OyBsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZw0KPiBDYzogQ2xhdWRpdSBNYW5vaWwgPGNsYXVkaXUubWFub2lsQG54
cC5jb20+OyBWbGFkaW1pciBPbHRlYW4NCj4gPHZsYWRpbWlyLm9sdGVhbkBueHAuY29tPjsgQWxl
eGFuZHJ1IE1hcmdpbmVhbg0KPiA8YWxleGFuZHJ1Lm1hcmdpbmVhbkBueHAuY29tPjsgbWljaGFl
bC5jaGFuQGJyb2FkY29tLmNvbTsNCj4gdmlzaGFsQGNoZWxzaW8uY29tOyBzYWVlZG1AbWVsbGFu
b3guY29tOyBsZW9uQGtlcm5lbC5vcmc7DQo+IGppcmlAbWVsbGFub3guY29tOyBpZG9zY2hAbWVs
bGFub3guY29tOw0KPiBhbGV4YW5kcmUuYmVsbG9uaUBib290bGluLmNvbTsgVU5HTGludXhEcml2
ZXJAbWljcm9jaGlwLmNvbTsNCj4ga3ViYUBrZXJuZWwub3JnOyBqaHNAbW9qYXRhdHUuY29tOyB4
aXlvdS53YW5nY29uZ0BnbWFpbC5jb207DQo+IHNpbW9uLmhvcm1hbkBuZXRyb25vbWUuY29tOyBw
YWJsb0BuZXRmaWx0ZXIub3JnOw0KPiBtb3NoZUBtZWxsYW5veC5jb207IG0ta2FyaWNoZXJpMkB0
aS5jb207DQo+IGFuZHJlLmd1ZWRlc0BsaW51eC5pbnRlbC5jb207IHN0ZXBoZW5AbmV0d29ya3Bs
dW1iZXIub3JnDQo+IFN1YmplY3Q6IFJFOiBbRVhUXSBSZTogW3YzLG5ldC1uZXh0IDEvNF0gbmV0
OiBxb3M6IGludHJvZHVjZSBhIGdhdGUgY29udHJvbA0KPiBmbG93IGFjdGlvbg0KPiANCj4gQ2F1
dGlvbjogRVhUIEVtYWlsDQo+IA0KPiBQbyBMaXUgPHBvLmxpdUBueHAuY29tPiB3cml0ZXM6DQo+
IA0KPiA+Pg0KPiA+PiBPbmUgaWRlYSB0aGF0IGp1c3QgaGFwcGVuZWQsIGlmIHlvdSBmaW5kIGEg
d2F5IHRvIGVuYWJsZSBSWA0KPiA+PiB0aW1lc3RhbXBpbmcgYW5kIGNhbiByZWx5IHRoYXQgYWxs
IHBhY2tldHMgaGF2ZSBhIHRpbWVzdGFtcCwgdGhlIGNvZGUNCj4gPj4gY2FuIHNpbXBsaWZpZWQg
YSBsb3QuIFlvdSB3b3VsZG4ndCBuZWVkIGFueSBocnRpbWVycywgYW5kIGRlY2lkaW5nIHRvDQo+
ID4+IGRyb3Agb3Igbm90IGEgcGFja2V0IGJlY29tZXMgYSBjb3VwbGUgb2YgbWF0aGVtYXRpY2Fs
IG9wZXJhdGlvbnMuDQo+IFNlZW1zIHdvcnRoIGEgdGhvdWdodC4NCj4gPg0KPiA+IFRoYW5rcyBm
b3IgdGhlIGRpZmZlcmVudCBpZGVhcy4gVGhlIGJhc2ljIHByb2JsZW0gaXMgd2UgbmVlZCB0byBr
bm93DQo+ID4gbm93IGlzIGEgY2xvc2UgdGltZSBvciBvcGVuIHRpbWUgaW4gYWN0aW9uLiBCdXQg
SSBzdGlsbCBkb24ndCBrbm93IGENCj4gPiBiZXR0ZXIgd2F5IHRoYW4gaHJ0aW1lciB0byBzZXQg
dGhlIGZsYWcuDQo+IA0KPiBUaGF0J3MgdGhlIHBvaW50LCBpZiB5b3UgaGF2ZSB0aGUgdGltZXN0
YW1wIG9mIHdoZW4gdGhlIHBhY2tldCBhcnJpdmVkLA0KPiB5b3UgY2FuIGNhbGN1bGF0ZSBpZiB0
aGUgZ2F0ZSBpcyBvcGVuIGFuZCBjbG9zZWQgYXQgdGhhdCBwb2ludC4gWW91IGRvbid0DQo+IG5l
ZWQgdG8ga25vdyAibm93IiwgeW91IHdvcmsgb25seSBpbiB0ZXJtcyBvZiAic2tiLT50c3RhbXAi
DQo+IChzdXBwb3NpbmcgdGhhdCdzIHdoZXJlIHRoZSB0aW1lc3RhbXAgaXMgc3RvcmVkKS4gSW4g
b3RoZXIgd29yZHMsIGl0DQo+IGRvZXNuJ3QgbWF0dGVyIHdoZW4gdGhlIHBhY2tldCBhcnJpdmVz
IGF0IHRoZSBxZGlzYyBhY3Rpb24sIGJ1dCB3aGVuIGl0DQo+IGFycml2ZWQgYXQgdGhlIGNvbnRy
b2xsZXIsIGFuZCB0aGUgYWN0aW9ucyBzaG91bGQgYmUgdGFrZW4gYmFzZWQgb24gdGhhdA0KPiB0
aW1lLg0KDQpJIGdldCB5b3VyIGlkZWEuIEJ1dCB0aGF0IHdvdWxkIHJlbHkgb24gdGhlIHNvZnR3
YXJlIHRpbWVzdGFtcGluZyBvbiBkcml2ZXIgdG8gYmUgc2V0LiAgQnkgc2V0IGFsbCBzdHJlYW1z
IG9yIGJ5IGZpbHRlcmVkIHN0cmVhbSBlYWNoIHRpbWUgc2V0IHdpdGggdGMgZmxvd2VyIGZpbHRl
ci4gQWxzbyBob3cgdGhlIHZpcnR1ZSBuZXQgZml4IGl0IGlzIHVua25vdy4NCg0KPiANCj4gPg0K
PiA+Pg0KPiA+PiBUaGUgcmVhbCBxdWVzdGlvbiBpczogaWYgcmVxdWlyaW5nIGZvciB0aGUgZHJp
dmVyIHRvIHN1cHBvcnQgYXQgbGVhc3QNCj4gPj4gc29mdHdhcmUgUlggdGltZXN0YW1waW5nIGlz
IGV4Y2Vzc2l2ZSAoZG9lc24ndCBzZWVtIHNvIHRvIG1lKS4NCj4gPg0KPiA+IEkgdW5kZXJzdGFu
ZC4NCj4gPg0KPiA+Pg0KPiA+Pg0KPiA+PiBDaGVlcnMsDQo+ID4+IC0tDQo+ID4+IFZpbmljaXVz
DQo+ID4NCj4gPiBUaGFua3MgYSBsb3QhDQo+ID4NCj4gPiBCciwNCj4gPiBQbyBMaXUNCj4gDQo+
IC0tDQo+IFZpbmljaXVzDQo=
