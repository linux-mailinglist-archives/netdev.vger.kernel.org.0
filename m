Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15B6A64B0E5
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 09:15:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234470AbiLMIPN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Dec 2022 03:15:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234027AbiLMIPK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Dec 2022 03:15:10 -0500
Received: from EUR02-VI1-obe.outbound.protection.outlook.com (mail-vi1eur02on2060.outbound.protection.outlook.com [40.107.241.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C25856576;
        Tue, 13 Dec 2022 00:15:08 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M81+1n5V7fQ+WBcET9WjETxeOqkcaOry/rGIYYbavTL2rx72XvNU2EtF4wGM/14RL5NuuK3TZu+tMn9w+AtkncbuiG0u70waawplK0BNyYmOf88wqFDY9ejqGattrUE6/beZbEf1awnCsoS/MiYoiX9ZDk0Vxdn2GscIxfw96iQVew8De/2aI+yxWDaeuZkETfoywZzNzye/dmy458/X8zJzj/eMgH2UxcindsUG3erTzHd60+95g4EhE9IKJ0ws0QRYxHFYupntj8YX+jhiKCfMYpXLHx5icWWv8jSvDQwpcqLJtQI1ES3Qxctk8NLCG48mcu0/qK6i6QkUwAU2Mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4YQslwGi9GgVoW6L8w++nxXJK0itC5hAHOnS2i7X8fg=;
 b=gITun4D4ZN9WgYTNialYb5F6U5TGG+P7D3k4J4dWFbszE0egvRcy91IkXYVLffxayDnWmT6eJxfXvtVgzLmqBWErsEgH+fjw8YcUNcg6C+lE3BRVSOvTf75Kxi8EyfyiQ2gy+bPskZbTQFhNP8/FauBAwrM8mMQjHjUOKTc5l6/vYhVfAZPDlc0dlMhrE2TqGiisNSlThr5TgQWbWWDAoaKgaLxkVSrgruVXpTRy1GuYdwef1UBPoF+T6sM7PbHvu/nRBWNqHbVpowdPPeRHOeGq4Qc4HTA4QyjmQ8uqQkfzEMMuWMGxqvcTcsGw5Xq7j6y04i30JB1VNapfZHQW2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4YQslwGi9GgVoW6L8w++nxXJK0itC5hAHOnS2i7X8fg=;
 b=B2PbbyQt15erhvk7SVXvlJvj2HNUCui+vHjT/MvmqttPGblqzAERw2jDShDLN8jNKd+3Tz35syhR9m0Y8Ka2hicYzhh4Di092nOK/QMWswUAmCZndQmp+JM2oW9EXw7jtxRcuHbFvm6hODmaHH0DtxvLqxkOTRue3Gs4FiPSvHo=
Received: from PA4PR04MB9640.eurprd04.prod.outlook.com (2603:10a6:102:261::21)
 by DB8PR04MB7146.eurprd04.prod.outlook.com (2603:10a6:10:127::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.11; Tue, 13 Dec
 2022 08:15:05 +0000
Received: from PA4PR04MB9640.eurprd04.prod.outlook.com
 ([fe80::cc4:c5c2:db97:1313]) by PA4PR04MB9640.eurprd04.prod.outlook.com
 ([fe80::cc4:c5c2:db97:1313%9]) with mapi id 15.20.5880.019; Tue, 13 Dec 2022
 08:15:05 +0000
From:   Jun Li <jun.li@nxp.com>
To:     Fabio Estevam <festevam@gmail.com>,
        "bjorn@mork.no" <bjorn@mork.no>,
        Peter Chen <peter.chen@kernel.org>, Marek Vasut <marex@denx.de>
CC:     netdev <netdev@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Schrempf Frieder <frieder.schrempf@kontron.de>
Subject: RE: imx7: USB modem reset causes modem to not re-connect
Thread-Topic: imx7: USB modem reset causes modem to not re-connect
Thread-Index: AQHZDlUhV+kS2pCWsUGZGAatOM7Zpq5qm5mAgADc97A=
Date:   Tue, 13 Dec 2022 08:15:05 +0000
Message-ID: <PA4PR04MB96407AC656705A79BF72D2E089E39@PA4PR04MB9640.eurprd04.prod.outlook.com>
References: <CAOMZO5AFsvwbC4Pr49WPFmZt7OnKjuJnYSf3cApGqtoZ_fFPPA@mail.gmail.com>
 <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com>
In-Reply-To: <CAOMZO5AWRDLu5t0O=AG7CxNLv20HTmMTRh=so=s7+nTH0_qYgQ@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PA4PR04MB9640:EE_|DB8PR04MB7146:EE_
x-ms-office365-filtering-correlation-id: 6e2e9bc5-2411-4f2b-f981-08dadce22474
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: p4+C68CuZ0zrGBX2Btz1oOc2N16ZLqaSNREnPagFMAO4J7eEV1sSIVwQf69SYY5p6bVzswjo+iJeu1eM7OfkhaBuuZ1yQm9ERjsyxXVlU5YDI9J1MjXi4jTwZsuSPIkdism4NzMA7mkhFXNXxD/6MZyBPH53OOsHv601CtK5ZtRQilKLBWrx7smE2zjPJqsDeHOUNf9Dr3DIh9SS79J/zbRgTvqCTN/aURJJ39p+b5A6bcjCjLHHIdIdkoEQeiLllaG5LZ5SQEpzESKf/KClUE0HvXcMiwVMrm6+4E4+AMBwVmBnGSigjACBOriyf70N+UoZdDAej11a762TOx6ImqyOUoi8gCstSHKj9cZWvQlwdSOzYY4wHXx1scft8e+ajBu3wWMKHCC/tC+ZLOMaIFXUQo/XSnaeFvwqGlHDDNOMwLbnnhKToECoSGK1huyS32tIfk7083ePxeD1/1HLYrIKn52s6DYVgV81vGVEdDKlaEHRn+3qbnjeclkY6VcIMrn+pCLzIpi/ISLIHeswUDXG3Uqv46e/yeZqBf+OHh7cfiVFjkTQF6JV4Ua0cVw4HehXxbbHdKE2c4sXKYvwcCIjvm2e9t/FVhahos/tmctDTfGpE9vreR3BnVEewd5No/rBJ/3g2w23RlowDPbf932isJ6BJDrc13iP2NsCaj8XLnbwml2GXHk8ic2Sttj0FrGrY1LvUygQREf7aw1lUw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PA4PR04MB9640.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(376002)(346002)(136003)(451199015)(71200400001)(478600001)(6506007)(38100700002)(9686003)(186003)(26005)(41300700001)(110136005)(122000001)(54906003)(64756008)(83380400001)(53546011)(86362001)(7696005)(33656002)(316002)(2906002)(8676002)(76116006)(66476007)(66946007)(66446008)(66556008)(4326008)(5660300002)(38070700005)(44832011)(8936002)(52536014)(55016003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?UzFUYm81Rmh4WkJpMGlvVy9hdlkveW9SYmFHWE9EOXRUNGUxQk5HVjJFdTJR?=
 =?utf-8?B?ZlA3RFlVdGRVQlBwL0NlamZTZGlldU5yQ0NsN2ZBNXlxVDJrTTdGKzJ2K1V1?=
 =?utf-8?B?U1kzSUxuWXBPOXovSlFlZVJYYk5JR2FEL3ZGcU1yRk5iNkt0VmY1WlZyeDRN?=
 =?utf-8?B?aHMwa0E5WlZBUDduNmxaejBWZTlYVEtTZzU5S2J4RnhYYjBuT3FIS3pvVHls?=
 =?utf-8?B?TngwdVExMlhJMU5xbnJQTmZDVlhlU3daMENaL1pPd0lFa1VpRG11VUU5bURr?=
 =?utf-8?B?VHFUbVVWeWRTS3Z3SnZSQW1OTks3VGIvOXNhQmJ6TGVOUnVXVENGcnNpQTl5?=
 =?utf-8?B?ODYxTG1XekVQK0plWm9Nc3ZuNjJRMklVV0h3UkhWbFRUck8wWTRUallhV0tX?=
 =?utf-8?B?K1F5K2hPMFdNS1Y2cmdZZ0RzSDhuRkYzSVNhNS9CcGNOeTBCL1ZlcWFhWGsy?=
 =?utf-8?B?VGZRRGFzVnpZb2dTR2dJQUpObkhYaG0razZGbDdMb3NlZmdhNlFENmZJZlVK?=
 =?utf-8?B?cEV2amJKNXRVd1hKSGZKNHZXVWtTRXRkRCs4QldmQU5tMmpObS9zTE9QOVdh?=
 =?utf-8?B?ajF6a0lGRm51MElVa0MxWDNPQkRsSDR5TkpsZ1E2YkdpTDN2b2ZkdGNGb0w1?=
 =?utf-8?B?emtQUGJ5T2p2Rlk2YlNrVzBoY3Z4RHhyRjdXcWtrbHJLbjEyK1RCbHVzbnJj?=
 =?utf-8?B?MS9QYng5YXhBVUVxbFFLSUE3SlRDRk12RUVlc1pmcFBvaStXeDlXRlAvcFVi?=
 =?utf-8?B?a1ZVNGVvNy9qenF5Z2tnMmFaaE9ROVF5dDg4OHdEWG1RS1gvTnF4RDRCOFNJ?=
 =?utf-8?B?bVFJdWFCQ1hZOStaT1ljS05nWlJOOHBIb3lpODRVclpKcmZibDgreng4akt5?=
 =?utf-8?B?bjk2SjliaHp3aTl3VDhncVlocXFQQW9LNWZmNVY0UEVUMG9tZnMzRjYxWEhE?=
 =?utf-8?B?azZrbkxCRThIczY4UmEzTWx6YTlkZlY4ZmRzemM0a2JDeWVHbFY1L3gxTkhs?=
 =?utf-8?B?dC9IRjl6aUdFNFU3dkdUbU9sVy95U2VMK1EyN0ZTSUhZeFYxeFhPaEVsOVhU?=
 =?utf-8?B?ekVCQytSbDlnTURBRFN5RC8rOUhGMW0xaHdBdjBFOGNBRFdBU0VVZTkwOWNM?=
 =?utf-8?B?eFNoaGtMdEl5UW94Sk42RktLbWg3dTlZalEwUmdrckZWYmRNMmpEZ0Vhc2xv?=
 =?utf-8?B?U3lLaXYvL0FidmdWZHhXSmhMRyt0eFY5M2hSMGdSL0tNOXhEa1Fya3ZTd0Uy?=
 =?utf-8?B?ZjNlSkNRQXFlQ2tWK3Mvd1FZdTA4S0YwTGZnTWhrQ2NBa3k5djV5Z2ZwN3BZ?=
 =?utf-8?B?amFaK0JoWW56cTBKaTNCZ1JpU21XdWZFSklYR1E5azN0c05ZSFpabHdmWWlt?=
 =?utf-8?B?UGJ0V3NJNGdGbUoyVHpPWTdpZThHTDJVVEkwR3YrR3puaDA5RllwdklTQzd4?=
 =?utf-8?B?TklKbnJJS1VvSktweGVLcWxMM3VDVXdSOGIvdzBIbHZxdG5DbTltN3RZSUZm?=
 =?utf-8?B?S3ZwUWpmT2FuY2xiVjEwblFwOC92Y2prV1lMa1JmMEZTU3FsUEt0S0VkdXFF?=
 =?utf-8?B?TGFBci8xZzhIQjB4Uk1hQ3I0ZnQzUUhJT1pDNk5ZenRBdlpPMEpMajJETzVv?=
 =?utf-8?B?cGc4QS9TMHd5VUQ0RFZ5clRvS0JDN011TjBac1o4ZFc3T2ZEV0dVM2NEK044?=
 =?utf-8?B?N1lkckk2TDZWSjNyckl5VFBYQXhxUkVMRXZSZ3daa255aDQ3UHZVSG1Pd2F1?=
 =?utf-8?B?T1RjeEsxNWl2bjlWZTRBRTJKbTRRN01FZ0tZT2xkWU1sQ2U2QjQyNDhsdmFE?=
 =?utf-8?B?azJoTjEvVXpndFd6VUt5S3MrUGV2T2RGTDUvOWJnTWszZFFJUWxnU2pyOStS?=
 =?utf-8?B?RENkM1JYbyt1UVVzS3NGekZYanZCYkxwbFZpODRhcVcrOHUvZElxN3gvcW5T?=
 =?utf-8?B?eXpCbXNDaEl4a002OVFCK3ViL2ZNekVTSFN3em14L1JiR0lqdjNJVysvU3Nu?=
 =?utf-8?B?RWtOQklzMWxUWmNvSFFNMkRFTEtFZHVIY2d6bEFZOXB6dUtVblBmUEFpa1Zu?=
 =?utf-8?B?ZXEzSDZybUVtRWNnTGlDcURnQ2NndkUzN2VMcUpJYkpoRGYwaEZ4cVVIZjZX?=
 =?utf-8?Q?xvrA=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PA4PR04MB9640.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6e2e9bc5-2411-4f2b-f981-08dadce22474
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Dec 2022 08:15:05.8243
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: cI7trO0rDft6OT1KquVIo2/Pxd4QdfZr3hTL5/BtNGtmfpO0NkGX/hQ0p7u5yOnm
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR04MB7146
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRmFiaW8gRXN0ZXZhbSA8
ZmVzdGV2YW1AZ21haWwuY29tPg0KPiBTZW50OiBUdWVzZGF5LCBEZWNlbWJlciAxMywgMjAyMiAz
OjAxIEFNDQo+IFRvOiBiam9ybkBtb3JrLm5vOyBQZXRlciBDaGVuIDxwZXRlci5jaGVuQGtlcm5l
bC5vcmc+OyBNYXJlayBWYXN1dA0KPiA8bWFyZXhAZGVueC5kZT47IEp1biBMaSA8anVuLmxpQG54
cC5jb20+DQo+IENjOiBuZXRkZXYgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBVU0IgbGlzdCA8
bGludXgtdXNiQHZnZXIua2VybmVsLm9yZz47DQo+IEFsZXhhbmRlciBTdGVpbiA8YWxleGFuZGVy
LnN0ZWluQGV3LnRxLWdyb3VwLmNvbT47IFNjaHJlbXBmIEZyaWVkZXINCj4gPGZyaWVkZXIuc2No
cmVtcGZAa29udHJvbi5kZT4NCj4gU3ViamVjdDogUmU6IGlteDc6IFVTQiBtb2RlbSByZXNldCBj
YXVzZXMgbW9kZW0gdG8gbm90IHJlLWNvbm5lY3QNCj4gDQo+IE9uIE1vbiwgRGVjIDEyLCAyMDIy
IGF0IDM6MTAgUE0gRmFiaW8gRXN0ZXZhbSA8ZmVzdGV2YW1AZ21haWwuY29tPiB3cm90ZToNCj4g
Pg0KPiA+IEhpLA0KPiA+DQo+ID4gT24gYW4gaW14N2QtYmFzZWQgYm9hcmQgcnVubmluZyBrZXJu
ZWwgNS4xMC4xNTgsIEkgbm90aWNlZCB0aGF0IGENCj4gPiBRdWVjdGVsIEJHOTYgbW9kZW0gaXMg
Z29uZSBhZnRlciBzZW5kaW5nIGEgcmVzZXQgY29tbWFuZCB2aWEgQVQ6DQo+IA0KPiBEaXNhYmxp
bmcgcnVudGltZSBwbSBsaWtlIHRoaXM6DQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy91c2Iv
Y2hpcGlkZWEvY2lfaGRyY19pbXguYw0KPiBiL2RyaXZlcnMvdXNiL2NoaXBpZGVhL2NpX2hkcmNf
aW14LmMNCj4gaW5kZXggOWZmY2VjZDMwNThjLi5lMmEyNjNkNTgzZjkgMTAwNjQ0DQo+IC0tLSBh
L2RyaXZlcnMvdXNiL2NoaXBpZGVhL2NpX2hkcmNfaW14LmMNCj4gKysrIGIvZHJpdmVycy91c2Iv
Y2hpcGlkZWEvY2lfaGRyY19pbXguYw0KPiBAQCAtNjIsNyArNjIsNiBAQCBzdGF0aWMgY29uc3Qg
c3RydWN0IGNpX2hkcmNfaW14X3BsYXRmb3JtX2ZsYWcNCj4gaW14NnVsX3VzYl9kYXRhID0geyAg
fTsNCj4gDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGNpX2hkcmNfaW14X3BsYXRmb3JtX2ZsYWcg
aW14N2RfdXNiX2RhdGEgPSB7DQo+IC0gICAgICAgLmZsYWdzID0gQ0lfSERSQ19TVVBQT1JUU19S
VU5USU1FX1BNLA0KPiAgfTsNCj4gDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGNpX2hkcmNfaW14
X3BsYXRmb3JtX2ZsYWcgaW14N3VscF91c2JfZGF0YSA9IHsNCj4gDQo+IG1ha2VzIHRoZSBVU0Ig
bW9kZW0gdG8gc3RheSBjb25uZWN0ZWQgYWZ0ZXIgdGhlIHJlc2V0IGNvbW1hbmQ6DQo+IA0KPiAj
IG1pY3JvY29tIC9kZXYvdHR5VVNCMw0KPiA+QVQrQ0ZVTj0xLDENCj4gT0sNCj4gWyAgIDMxLjMz
OTQxNl0gdXNiIDItMTogVVNCIGRpc2Nvbm5lY3QsIGRldmljZSBudW1iZXIgMg0KDQpTbyBkaXNj
b25uZWN0IGhhcHBlbmVkLg0KDQo+IFsgICAzMS4zNDk0ODBdIG9wdGlvbjEgdHR5VVNCMDogR1NN
IG1vZGVtICgxLXBvcnQpIGNvbnZlcnRlciBub3cNCj4gZGlzY29ubmVjdGVkIGZyb20gdHR5VVNC
MA0KPiBbICAgMzEuMzU4Mjk4XSBvcHRpb24gMi0xOjEuMDogZGV2aWNlIGRpc2Nvbm5lY3RlZA0K
PiBbICAgMzEuMzY2MzkwXSBvcHRpb24xIHR0eVVTQjE6IEdTTSBtb2RlbSAoMS1wb3J0KSBjb252
ZXJ0ZXIgbm93DQo+IGRpc2Nvbm5lY3RlZCBmcm9tIHR0eVVTQjENCj4gWyAgIDMxLjM3NDg4M10g
b3B0aW9uIDItMToxLjE6IGRldmljZSBkaXNjb25uZWN0ZWQNCj4gWyAgIDMxLjM4MzM1OV0gb3B0
aW9uMSB0dHlVU0IyOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVyIG5vdw0KPiBkaXNjb25u
ZWN0ZWQgZnJvbSB0dHlVU0IyDQo+IFsgICAzMS4zOTE4MDBdIG9wdGlvbiAyLTE6MS4yOiBkZXZp
Y2UgZGlzY29ubmVjdGVkDQo+IFsgICAzMS40MDQ3MDBdIG9wdGlvbjEgdHR5VVNCMzogR1NNIG1v
ZGVtICgxLXBvcnQpIGNvbnZlcnRlciBub3cNCj4gZGlzY29ubmVjdGVkIGZyb20gdHR5VVNCMw0K
PiAjIFsgICAzMS40MTMyNjFdIG9wdGlvbiAyLTE6MS4zOiBkZXZpY2UgZGlzY29ubmVjdGVkDQoN
CkFmdGVyIGEgd2hpbGUsIHJlLWVtdWxhdGlvbiBoYXBwZW5zLiAgDQoNCj4gWyAgIDM2LjE1MTM4
OF0gdXNiIDItMTogbmV3IGhpZ2gtc3BlZWQgVVNCIGRldmljZSBudW1iZXIgMyB1c2luZyBjaV9o
ZHJjDQo+IFsgICAzNi4zNTQzOThdIHVzYiAyLTE6IE5ldyBVU0IgZGV2aWNlIGZvdW5kLCBpZFZl
bmRvcj0yYzdjLA0KPiBpZFByb2R1Y3Q9MDI5NiwgYmNkRGV2aWNlPSAwLjAwDQo+IFsgICAzNi4z
NjI3NjhdIHVzYiAyLTE6IE5ldyBVU0IgZGV2aWNlIHN0cmluZ3M6IE1mcj0zLCBQcm9kdWN0PTIs
DQo+IFNlcmlhbE51bWJlcj00DQo+IFsgICAzNi4zNzAwMzFdIHVzYiAyLTE6IFByb2R1Y3Q6IFF1
YWxjb21tIENETUEgVGVjaG5vbG9naWVzIE1TTQ0KPiBbICAgMzYuMzc1ODE4XSB1c2IgMi0xOiBN
YW51ZmFjdHVyZXI6IFF1YWxjb21tLCBJbmNvcnBvcmF0ZWQNCj4gWyAgIDM2LjM4MTM1NV0gdXNi
IDItMTogU2VyaWFsTnVtYmVyOiA3ZDE1NjNjMQ0KPiBbICAgMzYuMzg5OTE1XSBvcHRpb24gMi0x
OjEuMDogR1NNIG1vZGVtICgxLXBvcnQpIGNvbnZlcnRlciBkZXRlY3RlZA0KPiBbICAgMzYuMzk3
Njc5XSB1c2IgMi0xOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVyIG5vdyBhdHRhY2hlZCB0
byB0dHlVU0IwDQo+IFsgICAzNi40MTI1OTFdIG9wdGlvbiAyLTE6MS4xOiBHU00gbW9kZW0gKDEt
cG9ydCkgY29udmVydGVyIGRldGVjdGVkDQo+IFsgICAzNi40MjAyMzddIHVzYiAyLTE6IEdTTSBt
b2RlbSAoMS1wb3J0KSBjb252ZXJ0ZXIgbm93IGF0dGFjaGVkIHRvIHR0eVVTQjENCj4gWyAgIDM2
LjQzNDk4OF0gb3B0aW9uIDItMToxLjI6IEdTTSBtb2RlbSAoMS1wb3J0KSBjb252ZXJ0ZXIgZGV0
ZWN0ZWQNCj4gWyAgIDM2LjQ0Mjc5Ml0gdXNiIDItMTogR1NNIG1vZGVtICgxLXBvcnQpIGNvbnZl
cnRlciBub3cgYXR0YWNoZWQgdG8gdHR5VVNCMg0KPiBbICAgMzYuNDU3NzQ1XSBvcHRpb24gMi0x
OjEuMzogR1NNIG1vZGVtICgxLXBvcnQpIGNvbnZlcnRlciBkZXRlY3RlZA0KPiBbICAgMzYuNDY1
NzA5XSB1c2IgMi0xOiBHU00gbW9kZW0gKDEtcG9ydCkgY29udmVydGVyIG5vdyBhdHRhY2hlZCB0
byB0dHlVU0IzDQoNClNvIHRoaXMgZGlzY29ubmVjdCBhbmQgdGhlbiBjb25uZWN0IGlzIHlvdSBl
eHBlY3RlZCBiZWhhdmlvcj8NCg0KTGkgSnVuDQo+IA0KPiBEb2VzIGFueW9uZSBoYXZlIGFueSBz
dWdnZXN0aW9ucyBhcyB0byB3aGF0IGNvdWxkIGJlIHRoZSBwcm9ibGVtIHdpdGggcnVudGltZQ0K
PiBwbT8NCg==
