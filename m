Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25BF24F7609
	for <lists+netdev@lfdr.de>; Thu,  7 Apr 2022 08:29:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241101AbiDGGbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Apr 2022 02:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239374AbiDGGbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Apr 2022 02:31:34 -0400
Received: from APC01-TYZ-obe.outbound.protection.outlook.com (mail-tyzapc01on2106.outbound.protection.outlook.com [40.107.117.106])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2A93E0DA;
        Wed,  6 Apr 2022 23:29:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fZeO1zLZ1JiZjwmHqOpMGE0BGuvWOqow+IJaWbUFN1UIMWV93OvSZVWPJp1VN1lBzph9TtMtjSbi77/Dd6BkpWHlrv92XKsLeIkQsGVobjakCOb778izc8jqlGvq0OfRkrl1sZDH2GyQyAckUwxmB9n5jnNJZg170vCAtOMaIfweWOEVuwfagD973kJ57+J2JgPOfCQHfGOvEZnCWffJVYi370glkOuAxuHNJ/W7YJXErkCsgygdyjmPwMW9P9rM3Gflgp0BX/w1gnumyUVMRQ98mRYpwTN+O4bzTaYZqATVOrisBneqS4fSxpomEOP33CUvqR4E+ZA0QRj254d4Sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Hy5kdrLoqizzUTELa7km3s2Z87CfpXSJgF48gqFUuzo=;
 b=iFdZn3b++BTjiJXt+yquk+vbkRsFlemIKNoNG2fIj8nH0qk1AW/+BfuQSL51iKDtJDJWjUH1usWAkI39oDEBMndx48OCEHWRDjXJCrlqzzWkd8di3CmVwrBM+qxfUtQ0nt7uqLJ8IeVIu8bRtLfmDEh94txpgYLwkblYdcwRSqDEihL2QdqcKfsa3Z+0xvpu9raHlnvc6zg+HV2rTfZG9NeOBpuoVbmkEe5AIZtWTlsNT4Pmssw2ORke/te5wmVlT6GVNjCxTfy4KJSmGBxNNs6PKSFTmfnq9KUSe87MFx/zif3nOr6vXBAJurSxBP54aCRLRZgzN2o29432h9+YSw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aspeedtech.com; dmarc=pass action=none
 header.from=aspeedtech.com; dkim=pass header.d=aspeedtech.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aspeedtech.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Hy5kdrLoqizzUTELa7km3s2Z87CfpXSJgF48gqFUuzo=;
 b=P1Cjum/yv+7J7pW8AcMPmztUdWT6EEOU01icwvceDUZyATZGFgBiUkQA9+udTNh0mslGEIIR0dxpfg2QvKf8mJS8CRGjhHHe8O6E2xRhYLEAV0ZYyvAPhIHAyAwYb5+FgnfLnmIavSxGUI2ug0VBBlnYjdNjq6eyTWI+gMWDuYtwVM8KJmJJR2QybFiaaG4XotAry1K+fd/Cz+e1Srz2Q5D2xvnjIt1iq3kjcgCXAdH84I1yoI8b5tJa/r36YSiPxxtWLj+sYP4BZ2WIAOQ3BhorM5oFtYOdp6IAqIkOQOgX6nwCsuZJer/Zeazx+fZ5znUfvfYVI9uXGGFdpB5PBg==
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com (2603:1096:203:5c::20)
 by SG2PR06MB2617.apcprd06.prod.outlook.com (2603:1096:4:21::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Thu, 7 Apr
 2022 06:29:26 +0000
Received: from HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::4b4:4f33:eaec:c5bd]) by HK0PR06MB2834.apcprd06.prod.outlook.com
 ([fe80::4b4:4f33:eaec:c5bd%4]) with mapi id 15.20.5144.021; Thu, 7 Apr 2022
 06:29:26 +0000
From:   Dylan Hung <dylan_hung@aspeedtech.com>
To:     Russell King <linux@armlinux.org.uk>
CC:     "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "joel@jms.id.au" <joel@jms.id.au>,
        "andrew@aj.id.au" <andrew@aj.id.au>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "p.zabel@pengutronix.de" <p.zabel@pengutronix.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-aspeed@lists.ozlabs.org" <linux-aspeed@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        BMC-SW <BMC-SW@aspeedtech.com>
Subject: RE: [PATCH v3 2/3] net: mdio: add reset control for Aspeed MDIO
Thread-Topic: [PATCH v3 2/3] net: mdio: add reset control for Aspeed MDIO
Thread-Index: AQHYP/7MGHM6IZJ2t0qQgt8l7lF3rKzZHVqAgAryirA=
Date:   Thu, 7 Apr 2022 06:29:26 +0000
Message-ID: <HK0PR06MB2834DA2D814BC55A10F6584D9CE69@HK0PR06MB2834.apcprd06.prod.outlook.com>
References: <20220325041451.894-1-dylan_hung@aspeedtech.com>
 <20220325041451.894-3-dylan_hung@aspeedtech.com>
 <YkVUWV0czTzo6MrJ@shell.armlinux.org.uk>
In-Reply-To: <YkVUWV0czTzo6MrJ@shell.armlinux.org.uk>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=aspeedtech.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c0fd5c38-658e-41fc-a349-08da185ff69a
x-ms-traffictypediagnostic: SG2PR06MB2617:EE_
x-microsoft-antispam-prvs: <SG2PR06MB26170A6A6AE8CF6636851F1E9CE69@SG2PR06MB2617.apcprd06.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0aoOQRpIkYWey9ROhoWBF80IoNWnTar1qezqJwVRIBm7ujioGzm3Mq7iHs+VirAggA9e+pZNzuWIgmyV2iyyGZlTtm4hZavaduFkJfr5z0woPjD4OCoMhX9TvVMd5pXrUX0PxWx+6iLWmdr8f009MaPpSJ7oylVsYLnZ7CEeqPty1QGIXr75G5wbl2jZEKbTAq/DzeosemSjLTy0YVtJL8+i6VUcUrKSXBRL44+FFNIcPMSDo9AqtXkXRdvDl/GbobGkTVC/LKYXJJlOmd73bWx75DnQunfhhcVIxMtgaqubR3eyaUdAypD18N2JgC51LydjWoBTTYxGL38O3rDuS+XYB+vFuPsZYS9AjqqQkx77WcLyilGzmfL2NAnTQ/by5a5TTNiXrvQIwuEOO1FDvyeeeN2Tjr8A3owOlsRpob4w/QvPS7+za4SUWP/d0QHcJW/WsDg3O4/WwIs84TjjNRX5mj1Am4CXRBh1M6l5tiYsEht//NCbil4KgvYk/usUyCMOEAwlhaea8cm1Paiw6yQrC9LtXapHab6vEnU6XzSe4OUanL/ni6/+87P47t6ha7zwSV6i/DEKmEPqBmaajZLFCDomSSmKXx/GW2a06aae14xtCwbv0pla1N+JY6Rig7SYdNfbx/gIbEWwcgwrwjEmsscqmpBoBEWNM0plCzYg9HC61vKWEi5bQ4QXUAn0Je2xI6eKXf/uJb3casadHMuCLFa69PNyUYCmL581NsdqTmAcNwpux0yZr5mc7Y9pPgVQvrHCnU28CQut0NpR89FsauX0Hlx8eCCaZiQYXJA=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0PR06MB2834.apcprd06.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(136003)(346002)(366004)(376002)(396003)(39840400004)(66556008)(508600001)(66476007)(8676002)(7696005)(2906002)(66946007)(7416002)(76116006)(6506007)(8936002)(4326008)(5660300002)(53546011)(64756008)(66446008)(9686003)(33656002)(38100700002)(52536014)(122000001)(186003)(6916009)(71200400001)(83380400001)(55016003)(54906003)(26005)(38070700005)(107886003)(86362001)(966005)(316002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?big5?B?YlFOU1ZBNTZRaWRHbHh5cjFyL2xEOGo3WEQzSUIyVVlnNi9iMm1pVXVoaGE4aXhs?=
 =?big5?B?N28yM2ZQS1BGbmZjUFB5S2V6RFNLbjlOVFJNb2FnMnVmNEdrSG8vSXIyZEszbXVR?=
 =?big5?B?UDJ3Mlk3VXFjem03V0NhaUtkRUs1ajBadUtHb3MyVERRbmRMR2xhdzZHYUF1SVFK?=
 =?big5?B?aG5NaFFPb0ZCbjRhWGJYR0ZTV0RTTzVjaGxvOUgwZGRTUmNJMTZUTktFM3pUWHBQ?=
 =?big5?B?VEpWN3U4QWV4bHFUblFIa0U0VEE1dW9obXBkY1ZvWHlBanhZdm44WmtpemJUT0l3?=
 =?big5?B?bFNrQ0QxYlMrYkh1VXE5VzhSTjRDcnc2WklVSFVBcEFYY2JFT2x3WUc4QTEwWG9o?=
 =?big5?B?VkJsYUhFN09LR3RGcGRUV3h3cUFHZlBPalBTcG5DNkRCY2JScU9nSisvUjJTR3NQ?=
 =?big5?B?Z2t3OHVtdThRZWRZWk9Ob3k3L3JxUzM0WmdKK2ticGJDZXAzdjA2UzhrZ040aGhn?=
 =?big5?B?ZjY2bWxmWTFKSXZrb1locW5UQnBxSDV6blRqQ29LTWRWeGVBMCtPa3A4QXVsZis0?=
 =?big5?B?bE9NRythZU8zWnk0Y2E0MmlBWjFtTHcyRXk5WkZ1SnUwajNlRjRxc3kreVpJbk9N?=
 =?big5?B?Y3dESS90WlVxZDVzdHFzc0U4Z2VmVUlYbVZBQ3BxMldOWjBwRUo0RElGZlBDcHlu?=
 =?big5?B?VCtXWlprQjFmUHJwb2xlSlV1ODl6elZ1dkNDWDBvWXpnMDlSSForUkRSWm42TUxT?=
 =?big5?B?RzliMkkxZXpYSWQ4QWV3bXJtRmJsTVg1MDVWRUpQTnhJRld6dnhmR290bmQzb2Yr?=
 =?big5?B?TnVmcXVpZ0RlNVRvaDBBdG1mMDJENTdwMkd0c0lnMnhlalhTWCtMSzlnVGVFZGl5?=
 =?big5?B?bDZKS2c0bG5kK1owVzdBb2RhNjJCc3UycVBmNmRuWVZxNklIYVRzdkxWSlcySFdJ?=
 =?big5?B?T3hIeGJjS1UrM1ZNcUhyWEdzREFvOExFay9UcFZiN3pGdkdkOGlFMHM5OS9zTFJi?=
 =?big5?B?Zmh0cDlDYis0T1NFWnV6cVltTDl0VGhtZnhVS2NZc2tQRGxIQjBJM2I5amtHT2dV?=
 =?big5?B?NFhQVzRxdFRmWlNkbjdFcDYxbmFPb0R0TERjZVdjNTV3bCsxaFgwRHFsR3I4T2pI?=
 =?big5?B?UmNNMHRRTzdjYUpmVVhPUGNXcnAwZk1uRHFJeXgrWkZEbExOYXlUc2djKzRBZWZO?=
 =?big5?B?aStBMGxSY0tFY1QrSjJ2eXZwVC9OR2lBekJoT0U0NThZMWloR0dEU2hsUE12aC9p?=
 =?big5?B?VnV0clQzTXV2TkV0bUFWM0IyZzJiL2tTNGNiVTB1eENPd05yNWVYcXowU1pyQVNy?=
 =?big5?B?N21EZWROb3RSaEl0YUJJemE4SWtObGVjMXNnenFibG9RQXlxWEh5aUYyam1LOTZZ?=
 =?big5?B?cmtiR0xxRTFhV0EvSGtxWWpCMzZ1cFgyT2Z0R3lLNy9LL0lCMEF2MGZhQWZUdW5D?=
 =?big5?B?enl6UXRXSS9vb2g1WUFyd0Y0dTFoUFVFMG9kYjVhQUFvcnhXblhnWFFFclRCOHVO?=
 =?big5?B?WUNRTExlRUZRcjdBRFMrZ283Q1ZVcTdWVU5nU2Z6c1NiTG5GWGVIUEhzVm92TURS?=
 =?big5?B?OUlCMTBUOHg0cFNwY3dOeE1na3FiRWdNL3Q0U0YvdUJKKzVhK1U0Q2NOc3R5eSsw?=
 =?big5?B?SDhZUmpjam1KUzh2aHVFb0IxdzlMSWZLTXZlTUlvcW9LVmIvU0ZsSmN3ait1T0lU?=
 =?big5?B?ZVpvVzU4djh6RWRpZW1yMVljYUZOTmdYeWRBM1ZxRWN0RVh1SHFvbkNtdEg5Vlkv?=
 =?big5?B?b2cwU0MrcFpCUUdaTGtaMDNJNDJlZVdURFBaRlk2WUhWSFd4bjYycWowQWw4WEtQ?=
 =?big5?B?K3BuSE85L2x3NGRUZ291TXBGVUtDYVVPbEc2YlRGa29VOWNkR3Nod3g1eERCM1JN?=
 =?big5?B?bnlHNWwwZ1RmSVAzTTNKQlQweEtxTjBGSURxVWxRSGxFV01OSHc0bHNyY0txait3?=
 =?big5?B?K211b3c1WCszZ2R2K1pMS2s0R09SQUJ0dXBpWW12K3NXV0x5UHYzbi9Gd1V0bCta?=
 =?big5?B?cTRvbW8zWnRYcVlnTWxwVHBGN0RyY0dXYmdvNnBwSEVLUmpMeTFFQ2QvMExVT3dz?=
 =?big5?B?T0FxS2RLU0hwdWpZUlMxeXl3VUFoVFh3aDNQMEswRjY4ZmpuL3Z4TTh2YU15RDU0?=
 =?big5?B?T0g2Z2lZZjhWbFc1cVg0UmxnZXlscVVOUlM0eXFEeUdnWDNhYUF6NXdVKzk3RW45?=
 =?big5?B?RlVNMFBickgyRU5XODhkb2xWekMrNVhoNUpkQTV6YTdwcjZaUTJPOCtDbnk0b01Z?=
 =?big5?Q?6fkAzLo+fpDALee93dYxGPVZJd2DbWvvOcJ0s3UVOM4=3D?=
Content-Type: text/plain; charset="big5"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aspeedtech.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: HK0PR06MB2834.apcprd06.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0fd5c38-658e-41fc-a349-08da185ff69a
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Apr 2022 06:29:26.2917
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43d4aa98-e35b-4575-8939-080e90d5a249
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1M2NZlK7Fpf/u3BdDIBFKQg2u6r5lF8FmEHnfwWbD4Z6s8CO2VNi+IjHtYQ7TRs9RCGeaArdjUYr78s77KQXP7fxbOdu9l8SeGkB0Xejhag=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SG2PR06MB2617
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgUnVzc2VsbCwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBSdXNz
ZWxsIEtpbmcgW21haWx0bzpsaW51eEBhcm1saW51eC5vcmcudWtdDQo+IFNlbnQ6IDIwMjKmfjOk
6zMxpOkgMzoxMiBQTQ0KPiBUbzogRHlsYW4gSHVuZyA8ZHlsYW5faHVuZ0Bhc3BlZWR0ZWNoLmNv
bT4NCj4gQ2M6IHJvYmgrZHRAa2VybmVsLm9yZzsgam9lbEBqbXMuaWQuYXU7IGFuZHJld0Bhai5p
ZC5hdTsgYW5kcmV3QGx1bm4uY2g7DQo+IGhrYWxsd2VpdDFAZ21haWwuY29tOyBkYXZlbUBkYXZl
bWxvZnQubmV0OyBrdWJhQGtlcm5lbC5vcmc7DQo+IHBhYmVuaUByZWRoYXQuY29tOyBwLnphYmVs
QHBlbmd1dHJvbml4LmRlOyBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsNCj4gbGludXgtYXJt
LWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1hc3BlZWRAbGlzdHMub3psYWJzLm9y
ZzsNCj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgQk1DLVNXDQo+IDxCTUMtU1dAYXNwZWVkdGVjaC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbUEFU
Q0ggdjMgMi8zXSBuZXQ6IG1kaW86IGFkZCByZXNldCBjb250cm9sIGZvciBBc3BlZWQgTURJTw0K
PiANCj4gSGksDQo+IA0KPiBPbiBGcmksIE1hciAyNSwgMjAyMiBhdCAxMjoxNDo1MFBNICswODAw
LCBEeWxhbiBIdW5nIHdyb3RlOg0KPiA+IEFkZCByZXNldCBhc3NlcnRpb24vZGVhc3NlcnRpb24g
Zm9yIEFzcGVlZCBNRElPLiAgVGhlcmUgYXJlIDQgTURJTw0KPiA+IGNvbnRyb2xsZXJzIGVtYmVk
ZGVkIGluIEFzcGVlZCBBU1QyNjAwIFNPQyBhbmQgc2hhcmUgb25lIHJlc2V0IGNvbnRyb2wNCj4g
PiByZWdpc3RlciBTQ1U1MFszXS4gIFRvIHdvcmsgd2l0aCBvbGQgRFQgYmxvYnMgd2hpY2ggZG9u
J3QgaGF2ZSB0aGUNCj4gPiByZXNldCBwcm9wZXJ0eSwgZGV2bV9yZXNldF9jb250cm9sX2dldF9v
cHRpb25hbF9zaGFyZWQgaXMgdXNlZCBpbiB0aGlzDQo+IGNoYW5nZS4NCj4gPg0KPiA+IFNpZ25l
ZC1vZmYtYnk6IER5bGFuIEh1bmcgPGR5bGFuX2h1bmdAYXNwZWVkdGVjaC5jb20+DQo+ID4gUmV2
aWV3ZWQtYnk6IFBoaWxpcHAgWmFiZWwgPHAuemFiZWxAcGVuZ3V0cm9uaXguZGU+DQo+IA0KPiBT
aG91bGQgdGhpcyByZWFsbHkgYmUgc3BlY2lmaWMgdG8gb25lIGRyaXZlciByYXRoZXIgdGhhbiBi
ZWluZyBoYW5kbGVkIGluIHRoZQ0KPiBjb3JlIG1kaW8gY29kZT8NCj4gDQoNCklzIHRoZSBjb3Jl
IG1kaW8gY29kZSBhYmxlIHRvIGtub3cgdGhlIHJlc2V0IGlzIHNoYXJlZCBvciBleGNsdXNpdmU/
IEkgc3VwcG9zZWQgdGhhdA0KdGhlIHJlc2V0IHByb3BlcnR5IGlzIGhhcmR3YXJlIGRlcGVuZGVu
dC4gRGlkIEkgZ2V0IHRoYXQgcmlnaHQ/DQoNCj4gLS0NCj4gUk1LJ3MgUGF0Y2ggc3lzdGVtOiBo
dHRwczovL3d3dy5hcm1saW51eC5vcmcudWsvZGV2ZWxvcGVyL3BhdGNoZXMvDQo+IEZUVFAgaXMg
aGVyZSEgNDBNYnBzIGRvd24gMTBNYnBzIHVwLiBEZWNlbnQgY29ubmVjdGl2aXR5IGF0IGxhc3Qh
DQo=
