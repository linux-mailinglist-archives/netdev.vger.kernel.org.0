Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D03958120B
	for <lists+netdev@lfdr.de>; Tue, 26 Jul 2022 13:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238128AbiGZLfU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jul 2022 07:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229759AbiGZLfT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Jul 2022 07:35:19 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70089.outbound.protection.outlook.com [40.107.7.89])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25E01BC2F;
        Tue, 26 Jul 2022 04:35:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OKHEzbJCKtSYF+UTz6klob/DG1hHpARYyCaX8GbLFCun5gJ5zTSLnTrrp88S8AM+4+GtNSasxjFseiV2XQhjTADhEtoUiBDa5A0BKSYtnNbZp3bmGg/puQ4U6jn9YRz9+VMjDe7vQCy2UTJ7VXPqIEHv0UoaoOxy3B2kJYx/XuAnsOgiV7JqN70mKIKqZ4bN0Wqrxr91+6duyQFeLIPi3XniEU2XU+zPIsVLwkwPqtEroWnB5Z/1dMJFIqFC2cPvwKehP8TWNzg1myThAG8MVAYsmVVOnFNlM53xupfXxqoQV4CqxhQQKJKaT8qeDsFi901AVhg4Zbj1jJ6wAjAQ+w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4lBEG5sYCbS2frSVb4cGP2Je4HDPhHz193HwzeAP8e8=;
 b=Bm60Ej/blgV8+UaR6gNdm+Umb6ocn47eIdBaEHm96thBzeBFsG1uvh0fkn97JK1d3m7gn2zDvwfBh6lJnmTyeVkZ+G8ZT+jLnAc3kOKh84UIvj/mF1ZBwFotuS4QNthYYTI/ub9lYFuRNW9VgrPpLBa8RPpXw7RTZCusAkovWIzjqgMsh6KkBskvd10bSNqivKfZg8e+2rv9edQ768xG+rI051GKF6af1QYF5glyRzEzXmTJjU4GxiHSheMj6KiwKc0bRR/fwMq4rVuhU90+d/kHJroiTZxEKwuyrVHblBO3yt+2wEe3aukG68NYht3l/LNeCrUVnRf1+MkgEBkGQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4lBEG5sYCbS2frSVb4cGP2Je4HDPhHz193HwzeAP8e8=;
 b=EabqHpdu3yAJ3tKBTnPllkxAX17+8WDcQ9vAN8itl4HO6lGxlY5a+TF/5HmC5c5RI42xAV4A1djmqOElEMzEIM2m4bApv0Of1UuNODx2BaSxSzkE2Iw75ZHFPHDnBSOmsERaUJ56n6+w44p6ZEJNHicjauTCeyZ6nxZF/RWOcFs=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by DB7PR04MB5420.eurprd04.prod.outlook.com (2603:10a6:10:8e::33) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.24; Tue, 26 Jul
 2022 11:35:15 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.024; Tue, 26 Jul 2022
 11:35:14 +0000
From:   Camelia Alexandra Groza <camelia.groza@nxp.com>
To:     Sean Anderson <sean.anderson@seco.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@armlinux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Leo Li <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Vinod Koul <vkoul@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-phy@lists.infradead.org" <linux-phy@lists.infradead.org>
Subject: RE: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
 bindings
Thread-Topic: [PATCH net-next v3 46/47] arm64: dts: ls1046ardb: Add serdes
 bindings
Thread-Index: AQHYmJdO9OJQL8uRzkOwnuesK8wAT62I4DBggAAfFwCAAV64UIAFM66AgAEDxaA=
Date:   Tue, 26 Jul 2022 11:35:14 +0000
Message-ID: <VI1PR04MB58071BADCCD64FB726D34DD5F2949@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-47-sean.anderson@seco.com>
 <VI1PR04MB58077A401571734F967FAF12F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <5f32679a-3af3-f3ba-d780-5472c4d08a81@seco.com>
 <VI1PR04MB58076F8E57D04F5F438385DCF2909@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <787a4a58-2900-9f06-bb41-2ae96f70b025@seco.com>
In-Reply-To: <787a4a58-2900-9f06-bb41-2ae96f70b025@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8c490b8a-eca7-4112-b904-08da6efae88a
x-ms-traffictypediagnostic: DB7PR04MB5420:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: uzBBrViGZa/uNKPyqiGyqYqo9+Wia8FdwPi7632JBAGmBwRRGcSExAi1T0ojSHo4FC4c1cmbr3r+/WXkq3zMC1czmCNc4JmuuinTzXt9HyuOTLn1nXIcj3gUcpGk/O0FJ/ghzucArnoIQOoMtksYgwCeRjXQpp6nXi8yGUVbVAOngTD11CFZuYod2Pp0fZRn4r1H4FvbJISjjG1ljGPyNm+yVVRc6GDKSMty5uh2FzP6Le3QkbdHPXPJFnkqOUjPbKGbC+TJyNLfD1vhoZr8MlQ36PUsqkqVopXC9579uRIgk4QKGGSPV68fbqdNPlCGcJXVoKJ55gY+OA5jupmddxjU/i/opGofH5MF/EAG2mp/3Io2JVaUDltaGsklrPub8gcRQNMhd4VjiiyjU/ZqpHCjCp00YAiqebl6BdM/39+3jqcfR/R6qPqwwbC6ddBvDYXOHmdvfgWLUhs+slFV5LQpyYQAp7PnBr9l9aW3cPcgYfsKiKToB+pc7Ei+tuHu/8m27Ckf5LID5DZn/DgqAd37fgX6tDNK1aKnoRVhvrTUXtWYCeEmRCpFTPbqXoootXJWE2K/gwYzd1/IeaKoMmXH3PHcTHv7lyAEM2pDuLCo7prDo3p1xuiKPE69ij0l4q0iZkno5UhiRDSI1ZS3JVnAAj2YwAqzyneT/6jyZXLL9pus8Be1NHPd0DERKFj6Hjvfdd90rbvexY9UHPSpvTMU5JWW0MrSvAUY25Eu2UphmfeD6lOzgISJvQ0XLHEYqn6yHK7Q/HGEEqXpOrnn5x72l9ZR2rwP4YlNq7wD6G9GeFBqax+cT1wN2T1WIDvU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(366004)(396003)(346002)(39860400002)(136003)(55016003)(83380400001)(5660300002)(38070700005)(7416002)(8936002)(52536014)(38100700002)(2906002)(54906003)(110136005)(478600001)(66446008)(66556008)(66946007)(4326008)(8676002)(76116006)(122000001)(316002)(41300700001)(66476007)(6506007)(9686003)(53546011)(7696005)(86362001)(26005)(71200400001)(33656002)(186003)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?aURwNjhFOHl2Y2ljZm40U3VmSTdUMHhNaFgwVHIzL0FYVXBPejdpbWZadFMz?=
 =?utf-8?B?UFlLdmpndTB3UDlUa1FBYmVuQW83aFkzamU3QnlsdjNjV3ZLYUM0aENTWXNR?=
 =?utf-8?B?bm5aQUl0WmpkRmRGZThDNnFBQnpIRVVOU2xyZ0daWm9vOUJNTGVScEczcEF3?=
 =?utf-8?B?dU9kdE11K28yNEpMejlIRzlYN0ZXWURnRVd1OVd6Nmg0WHNuWEQxbDE1M1pZ?=
 =?utf-8?B?aUhJNlZLN1VNQlc0M0pSVXNiNHJFVTYyNXRNYWFJQi80dzdBd1FGU3lFOXMy?=
 =?utf-8?B?TU41TXZjaitJTkFmTmluY2NaUkpGUXJFcWJ2ZWdZR0txRFpKS1d1S2UyaHY0?=
 =?utf-8?B?M1NvdFJaZnBjeGE2M012bXhsY3Mvb2lwYkpna3RrRXRhZnJoeXFuVFI5amtW?=
 =?utf-8?B?VTBZNmVoMkdvVGtBYTYyWHIxTjQzcVpVL1J2UlB5ZjVneVcrSG91bTgxZUtn?=
 =?utf-8?B?MHYvWElmWENtbWY5Zm95VkFiczY4Q0V5Zy90Z2lxVnZSY3MxMjJDWWF5SThY?=
 =?utf-8?B?enBseFFSdGFRZVpQTS9oWjJlRzFPSTdZNkY0UmFlU2VPRmxWVmx0bzlSaWxw?=
 =?utf-8?B?cURHNHlWeUpJN2k2SUtRc3BqS0NLNEF0dHkyWFh1S3FBOFJ0M2JtR2pjSnNS?=
 =?utf-8?B?VnpId2JtWUw4VGtETFJkamR5TFFqNEw3SElHYm5XUGdvVUpYcGROSU55MUJQ?=
 =?utf-8?B?d0VGRmRmYTA1bU5JU0JVRXlqdmljalNTRUJaYm96WXN6RkdrZHNXUkVwMHBy?=
 =?utf-8?B?OVBXd1dMcVJNbGxnSXU4ancxTC9JZ0d6QUt2WHVvMkhHL0s5Y09tNDc0aTRm?=
 =?utf-8?B?cno2bERESWhjc3A5aUVnYUIrWEFIUFFpNHRkbkszcHVwNjZacWczUkszUERJ?=
 =?utf-8?B?eXd1dkxPYlFJdVR0eWF4K2h1NHZKRlFubEk5ZCt1NTR2Z1pjVENpSkFJVXo0?=
 =?utf-8?B?MDUzN0hFVUxnR01QbTJTb2daVndvSS92T1RkUzZwcU5NUUZZbzhQZ3BmcDNq?=
 =?utf-8?B?T3RRK2FvRmk0QlovVUgyb2pIRmd1dGZLdzNEaXBSaHA3dXdvWmpCTTdUcldU?=
 =?utf-8?B?YzFUN1RHbWRhSW5sRFNkL0pDUDhodFRETVFZTnVyYXJKK2Z0S2tQcHRWWmpo?=
 =?utf-8?B?ZzB5TTI4UHhPZ0xuWlRyRnJrUjUva2V5RjlBVE1yRW12MVVjUDlVTFFUWEFw?=
 =?utf-8?B?R2wwK3dtOWZWWGxXb1VRSkhQaURRRG5ScXVuaXh6SzFkU0tud0RjRjhPS1FZ?=
 =?utf-8?B?dGhjbEg0NmtVS3JxaEtueC8zSDJmZHIrQ3FySVROV2tSSUZYUmVQZk5KVUFt?=
 =?utf-8?B?QVFRZDdQMkxYazdCUlhsamE2UHFjZnJhOCsrOGRGaDBoZHJTUGVqYTRSZDFO?=
 =?utf-8?B?WXhQcTduOStLS3dlNHE0L25hS3pVeloyMWtVdVU2VlY4am9NZ3NNTGY4UzBk?=
 =?utf-8?B?TzBMeHQ1bnRWY1BPSXVxNXdZM3dya0hvSjh2aUFRWUgxNzczdUhWUDFYTExT?=
 =?utf-8?B?bjE1SlFIWHRoaFBWckFqeTJ3T2JsUmZUQUl5ZTRTNjhzQUJIQTlEM01la1Rr?=
 =?utf-8?B?eXFUQ2lCSWc1Q3gvdU0vM1BTRjNjTmlqSEhOU1cyaHNZcGRMQ25JdmdWayt3?=
 =?utf-8?B?b09OTUQ2SDRFWDJyNmJibW1PVysxTVF6Rk9RaWhDWVdhdGpyKy9qYTNjVVZw?=
 =?utf-8?B?cWtFOWxjdWkwZzAweGZ4UUZKVzJ4SGRKR3NxdFdOQjRlNzBuY1ZtNDNLZ0Fw?=
 =?utf-8?B?RWRtaTRpbzdGMkNyWVRRdndNWDM3SFBuQUlRUlM3UVdUYUd4bmJmYXM3RWZN?=
 =?utf-8?B?ZFIxNnNFTUZYMVFNMjh0L1R6eTNzQkVUdkI2UFZDWTd6eGU3TUJTVnhDdFdv?=
 =?utf-8?B?SGw3YzdGOEhTUSszZjcveS9Ybk5lMUVTT1hMamVYMDdwNDlKYUdlMlovRzZh?=
 =?utf-8?B?ZFhDNlVSbFAvK1hDN29vUHNjbmN1aTRwd2QxV0FJYklXclp6R211VW1BVFJT?=
 =?utf-8?B?VktQS0l1VWxXYVozYTYvYlBvdzFUa2pOR0wvRW92NnlZd0dEWW10MldTZWs2?=
 =?utf-8?B?bVU3ZTl2YnVZNzY0T3d3MmtaM21Cb2N6Z2VvbmQxYlFVaUZpR1ZGaUtHS25E?=
 =?utf-8?Q?lwU1nlq8jm+LJjOGeX+I8zGtd?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8c490b8a-eca7-4112-b904-08da6efae88a
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2022 11:35:14.8162
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: WQhRVyOO4o6CKUK/zK6qebHcb+RJmGYODkPYgAyWfZqPhR4+1JMC8U9l75Nlt/Su3LB/BJTGsgKng28NIpj/nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5420
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTZWFuIEFuZGVyc29uIDxzZWFu
LmFuZGVyc29uQHNlY28uY29tPg0KPiBTZW50OiBNb25kYXksIEp1bHkgMjUsIDIwMjIgMjM6MDIN
Cj4gVG86IENhbWVsaWEgQWxleGFuZHJhIEdyb3phIDxjYW1lbGlhLmdyb3phQG54cC5jb20+OyBE
YXZpZCBTIC4gTWlsbGVyDQo+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kg
PGt1YmFAa2VybmVsLm9yZz47IE1hZGFsaW4gQnVjdXINCj4gPG1hZGFsaW4uYnVjdXJAbnhwLmNv
bT47IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gQ2M6IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVk
aGF0LmNvbT47IEVyaWMgRHVtYXpldA0KPiA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IGxpbnV4LWFy
bS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9yZzsgUnVzc2VsbA0KPiBLaW5nIDxsaW51eEBhcm1s
aW51eC5vcmcudWs+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBLaXNob24gVmlqYXkN
Cj4gQWJyYWhhbSBJIDxraXNob25AdGkuY29tPjsgS3J6eXN6dG9mIEtvemxvd3NraQ0KPiA8a3J6
eXN6dG9mLmtvemxvd3NraStkdEBsaW5hcm8ub3JnPjsgTGVvIExpIDxsZW95YW5nLmxpQG54cC5j
b20+OyBSb2INCj4gSGVycmluZyA8cm9iaCtkdEBrZXJuZWwub3JnPjsgU2hhd24gR3VvIDxzaGF3
bmd1b0BrZXJuZWwub3JnPjsgVmlub2QNCj4gS291bCA8dmtvdWxAa2VybmVsLm9yZz47IGRldmlj
ZXRyZWVAdmdlci5rZXJuZWwub3JnOyBsaW51eC0NCj4gcGh5QGxpc3RzLmluZnJhZGVhZC5vcmcN
Cj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4dCB2MyA0Ni80N10gYXJtNjQ6IGR0czogbHMx
MDQ2YXJkYjogQWRkIHNlcmRlcw0KPiBiaW5kaW5ncw0KPiANCj4gDQo+IA0KPiBPbiA3LzIyLzIy
IDg6NDEgQU0sIENhbWVsaWEgQWxleGFuZHJhIEdyb3phIHdyb3RlOg0KPiA+PiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBTZWFuIEFuZGVyc29uIDxzZWFuLmFuZGVyc29u
QHNlY28uY29tPg0KPiA+PiBTZW50OiBUaHVyc2RheSwgSnVseSAyMSwgMjAyMiAxODo0MQ0KPiA+
PiBUbzogQ2FtZWxpYSBBbGV4YW5kcmEgR3JvemEgPGNhbWVsaWEuZ3JvemFAbnhwLmNvbT47IERh
dmlkIFMgLiBNaWxsZXINCj4gPj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgTWFkYWxpbg0KPiBCdWN1cg0KPiA+PiA8bWFkYWxpbi5idWN1
ckBueHAuY29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+PiBDYzogUGFvbG8gQWJlbmkg
PHBhYmVuaUByZWRoYXQuY29tPjsgRXJpYyBEdW1hemV0DQo+ID4+IDxlZHVtYXpldEBnb29nbGUu
Y29tPjsgbGludXgtYXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBSdXNzZWxsDQo+ID4+
IEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51az47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IEtpc2hvbiBWaWpheQ0KPiA+PiBBYnJhaGFtIEkgPGtpc2hvbkB0aS5jb20+OyBLcnp5c3p0
b2YgS296bG93c2tpDQo+ID4+IDxrcnp5c3p0b2Yua296bG93c2tpK2R0QGxpbmFyby5vcmc+OyBM
ZW8gTGkgPGxlb3lhbmcubGlAbnhwLmNvbT47IFJvYg0KPiA+PiBIZXJyaW5nIDxyb2JoK2R0QGtl
cm5lbC5vcmc+OyBTaGF3biBHdW8gPHNoYXduZ3VvQGtlcm5lbC5vcmc+Ow0KPiBWaW5vZA0KPiA+
PiBLb3VsIDx2a291bEBrZXJuZWwub3JnPjsgZGV2aWNldHJlZUB2Z2VyLmtlcm5lbC5vcmc7IGxp
bnV4LQ0KPiA+PiBwaHlAbGlzdHMuaW5mcmFkZWFkLm9yZw0KPiA+PiBTdWJqZWN0OiBSZTogW1BB
VENIIG5ldC1uZXh0IHYzIDQ2LzQ3XSBhcm02NDogZHRzOiBsczEwNDZhcmRiOiBBZGQNCj4gc2Vy
ZGVzDQo+ID4+IGJpbmRpbmdzDQo+ID4+DQo+ID4+DQo+ID4+DQo+ID4+IE9uIDcvMjEvMjIgMTA6
MjAgQU0sIENhbWVsaWEgQWxleGFuZHJhIEdyb3phIHdyb3RlOg0KPiA+PiA+PiAtLS0tLU9yaWdp
bmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiA+PiBGcm9tOiBTZWFuIEFuZGVyc29uIDxzZWFuLmFuZGVy
c29uQHNlY28uY29tPg0KPiA+PiA+PiBTZW50OiBTYXR1cmRheSwgSnVseSAxNiwgMjAyMiAxOjAw
DQo+ID4+ID4+IFRvOiBEYXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFr
dWIgS2ljaW5za2kNCj4gPj4gPj4gPGt1YmFAa2VybmVsLm9yZz47IE1hZGFsaW4gQnVjdXIgPG1h
ZGFsaW4uYnVjdXJAbnhwLmNvbT47DQo+ID4+ID4+IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4g
Pj4gPj4gQ2M6IFBhb2xvIEFiZW5pIDxwYWJlbmlAcmVkaGF0LmNvbT47IEVyaWMgRHVtYXpldA0K
PiA+PiA+PiA8ZWR1bWF6ZXRAZ29vZ2xlLmNvbT47IGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5m
cmFkZWFkLm9yZzsNCj4gUnVzc2VsbA0KPiA+PiA+PiBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcu
dWs+OyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBTZWFuDQo+ID4+IEFuZGVyc29uDQo+
ID4+ID4+IDxzZWFuLmFuZGVyc29uQHNlY28uY29tPjsgS2lzaG9uIFZpamF5IEFicmFoYW0gSQ0K
PiA8a2lzaG9uQHRpLmNvbT47DQo+ID4+ID4+IEtyenlzenRvZiBLb3psb3dza2kgPGtyenlzenRv
Zi5rb3psb3dza2krZHRAbGluYXJvLm9yZz47IExlbyBMaQ0KPiA+PiA+PiA8bGVveWFuZy5saUBu
eHAuY29tPjsgUm9iIEhlcnJpbmcgPHJvYmgrZHRAa2VybmVsLm9yZz47IFNoYXduDQo+IEd1bw0K
PiA+PiA+PiA8c2hhd25ndW9Aa2VybmVsLm9yZz47IFZpbm9kIEtvdWwgPHZrb3VsQGtlcm5lbC5v
cmc+Ow0KPiA+PiA+PiBkZXZpY2V0cmVlQHZnZXIua2VybmVsLm9yZzsgbGludXgtcGh5QGxpc3Rz
LmluZnJhZGVhZC5vcmcNCj4gPj4gPj4gU3ViamVjdDogW1BBVENIIG5ldC1uZXh0IHYzIDQ2LzQ3
XSBhcm02NDogZHRzOiBsczEwNDZhcmRiOiBBZGQgc2VyZGVzDQo+ID4+ID4+IGJpbmRpbmdzDQo+
ID4+ID4+DQo+ID4+ID4+IFRoaXMgYWRkcyBhcHByb3ByaWF0ZSBiaW5kaW5ncyBmb3IgdGhlIG1h
Y3Mgd2hpY2ggdXNlIHRoZSBTZXJEZXMuIFRoZQ0KPiA+PiA+PiAxNTYuMjVNSHogZml4ZWQgY2xv
Y2sgaXMgYSBjcnlzdGFsLiBUaGUgMTAwTUh6IGNsb2NrcyAodGhlcmUgYXJlDQo+ID4+ID4+IGFj
dHVhbGx5IDMpIGNvbWUgZnJvbSBhIFJlbmVzYXMgNlY0OTIwNUIgYXQgYWRkcmVzcyA2OSBvbiBp
MmMwLiBUaGVyZQ0KPiBpcw0KPiA+PiA+PiBubyBkcml2ZXIgZm9yIHRoaXMgZGV2aWNlIChhbmQg
YXMgZmFyIGFzIEkga25vdyBhbGwgeW91IGNhbiBkbyB3aXRoIHRoZQ0KPiA+PiA+PiAxMDBNSHog
Y2xvY2tzIGlzIGdhdGUgdGhlbSksIHNvIEkgaGF2ZSBjaG9zZW4gdG8gbW9kZWwgaXQgYXMgYSBz
aW5nbGUNCj4gPj4gPj4gZml4ZWQgY2xvY2suDQo+ID4+ID4+DQo+ID4+ID4+IE5vdGU6IHRoZSBT
ZXJEZXMxIGxhbmUgbnVtYmVyaW5nIGZvciB0aGUgTFMxMDQ2QSBpcyAqcmV2ZXJzZWQqLg0KPiA+
PiA+PiBUaGlzIG1lYW5zIHRoYXQgTGFuZSBBICh3aGF0IHRoZSBkcml2ZXIgdGhpbmtzIGlzIGxh
bmUgMCkgdXNlcyBwaW5zDQo+ID4+ID4+IFNEMV9UWDNfUC9OLg0KPiA+PiA+Pg0KPiA+PiA+PiBC
ZWNhdXNlIHRoaXMgd2lsbCBicmVhayBldGhlcm5ldCBpZiB0aGUgc2VyZGVzIGlzIG5vdCBlbmFi
bGVkLCBlbmFibGUNCj4gPj4gPj4gdGhlIHNlcmRlcyBkcml2ZXIgYnkgZGVmYXVsdCBvbiBMYXll
cnNjYXBlLg0KPiA+PiA+Pg0KPiA+PiA+PiBTaWduZWQtb2ZmLWJ5OiBTZWFuIEFuZGVyc29uIDxz
ZWFuLmFuZGVyc29uQHNlY28uY29tPg0KPiA+PiA+PiAtLS0NCj4gPj4gPj4gUGxlYXNlIGxldCBt
ZSBrbm93IGlmIHRoZXJlIGlzIGEgYmV0dGVyL21vcmUgc3BlY2lmaWMgY29uZmlnIEkgY2FuIHVz
ZQ0KPiA+PiA+PiBoZXJlLg0KPiA+PiA+Pg0KPiA+PiA+PiAobm8gY2hhbmdlcyBzaW5jZSB2MSkN
Cj4gPj4gPg0KPiA+PiA+IE15IExTMTA0NkFSREIgaGFuZ3MgYXQgYm9vdCB3aXRoIHRoaXMgcGF0
Y2ggcmlnaHQgYWZ0ZXIgdGhlIHNlY29uZA0KPiBTZXJEZXMNCj4gPj4gaXMgcHJvYmVkLA0KPiA+
PiA+IHJpZ2h0IGJlZm9yZSB0aGUgcG9pbnQgd2hlcmUgdGhlIFBDSSBob3N0IGJyaWRnZSBpcyBy
ZWdpc3RlcmVkLiBJIGNhbiBnZXQNCj4gPj4gYXJvdW5kIHRoaXMNCj4gPj4gPiBlaXRoZXIgYnkg
ZGlzYWJsaW5nIHRoZSBzZWNvbmQgU2VyRGVzIG5vZGUgZnJvbSB0aGUgZGV2aWNlIHRyZWUsIG9y
DQo+ID4+IGRpc2FibGluZw0KPiA+PiA+IENPTkZJR19QQ0lfTEFZRVJTQ0FQRSBhdCBidWlsZC4N
Cj4gPj4gPg0KPiA+PiA+IEkgaGF2ZW4ndCBkZWJ1Z2dlZCBpdCBtb3JlIGJ1dCB0aGVyZSBzZWVt
cyB0byBiZSBhbiBpc3N1ZSBoZXJlLg0KPiA+Pg0KPiA+PiBIbS4gRG8geW91IGhhdmUgYW55dGhp
bmcgcGx1Z2dlZCBpbnRvIHRoZSBQQ0llL1NBVEEgc2xvdHM/IEkgaGF2ZW4ndA0KPiBiZWVuDQo+
ID4+IHRlc3Rpbmcgd2l0aA0KPiA+PiBhbnl0aGluZyB0aGVyZS4gRm9yIG5vdywgaXQgbWF5IGJl
IGJldHRlciB0byBqdXN0IGxlYXZlIGl0IGRpc2FibGVkLg0KPiA+Pg0KPiA+PiAtLVNlYW4NCj4g
Pg0KPiA+IFllcywgSSBoYXZlIGFuIEludGVsIGUxMDAwIGNhcmQgcGx1Z2dlZCBpbi4NCj4gPg0K
PiA+IENhbWVsaWENCj4gPg0KPiANCj4gQ2FuIHlvdSB0cnkgdGhlIGZvbGxvd2luZyBwYXRjaD8g
SSB3YXMgYWJsZSB0byBib290IHdpdGggUENJIHdpdGggaXQgYXBwbGllZC4NCg0KV29ya3MgZm9y
IG1lIGFzIHdlbGwuIFRoZSBib2FyZCBib290cyBmaW5lIGFuZCB0aGUgUENJIGNhcmQgaXMgZnVu
Y3Rpb25hbC4gVGhhbmtzLiANCg0KPiBGcm9tIDcxZjQxMzZmMWJkZGE4OTAwOTkzNmE5YzI0NTYx
YjYwZTA1NTQ4NTkgTW9uIFNlcCAxNyAwMDowMDowMA0KPiAyMDAxDQo+IEZyb206IFNlYW4gQW5k
ZXJzb24gPHNlYW4uYW5kZXJzb25Ac2Vjby5jb20+DQo+IERhdGU6IE1vbiwgMjUgSnVsIDIwMjIg
MTY6MDE6MTYgLTA0MDANCj4gU3ViamVjdDogW1BBVENIXSBhcm02NDogZHRzOiBsczEwNDZhOiBG
aXggbWlzc2luZyBQQ0llIGxhbmUNCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFNlYW4gQW5kZXJzb24g
PHNlYW4uYW5kZXJzb25Ac2Vjby5jb20+DQo+IC0tLQ0KPiAgYXJjaC9hcm02NC9ib290L2R0cy9m
cmVlc2NhbGUvZnNsLWxzMTA0NmEuZHRzaSB8IDEwICsrKysrKysrKy0NCj4gIDEgZmlsZSBjaGFu
Z2VkLCA5IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9h
cmNoL2FybTY0L2Jvb3QvZHRzL2ZyZWVzY2FsZS9mc2wtbHMxMDQ2YS5kdHNpDQo+IGIvYXJjaC9h
cm02NC9ib290L2R0cy9mcmVlc2NhbGUvZnNsLWxzMTA0NmEuZHRzaQ0KPiBpbmRleCAwYjM3NjVj
YWQzODMuLjM4NDFiYTI3NDc4MiAxMDA2NDQNCj4gLS0tIGEvYXJjaC9hcm02NC9ib290L2R0cy9m
cmVlc2NhbGUvZnNsLWxzMTA0NmEuZHRzaQ0KPiArKysgYi9hcmNoL2FybTY0L2Jvb3QvZHRzL2Zy
ZWVzY2FsZS9mc2wtbHMxMDQ2YS5kdHNpDQo+IEBAIC01MzIsNyArNTMyLDcgQEAgcGNpZS0wIHsN
Cj4gIAkJCQkJLyogUENJZS4xIHgxICovDQo+ICAJCQkJCWNmZy0xIHsNCj4gIAkJCQkJCWZzbCxj
ZmcgPSA8MHgxPjsNCj4gLQkJCQkJCWZzbCxmaXJzdC1sYW5lID0gPDE+Ow0KPiArCQkJCQkJZnNs
LGZpcnN0LWxhbmUgPSA8MD47DQo+ICAJCQkJCX07DQo+IA0KPiAgCQkJCQkvKiBQQ0llLjEgeDQg
Ki8NCj4gQEAgLTU0Myw2ICs1NDMsMTQgQEAgY2ZnLTMgew0KPiAgCQkJCQl9Ow0KPiAgCQkJCX07
DQo+IA0KPiArCQkJCS8qIFBDSWUuMiB4MSAqLw0KPiArCQkJCXBjaWUtMSB7DQo+ICsJCQkJCWZz
bCxpbmRleCA9IDwxPjsNCj4gKwkJCQkJZnNsLHByb3RvID0gInBjaWUiOw0KPiArCQkJCQlmc2ws
Y2ZnID0gPDB4MT47DQo+ICsJCQkJCWZzbCxmaXJzdC1sYW5lID0gPDE+Ow0KPiArCQkJCX07DQo+
ICsNCj4gIAkJCQlwY2llLTIgew0KPiAgCQkJCQlmc2wsaW5kZXggPSA8Mj47DQo+ICAJCQkJCWZz
bCxwcm90byA9ICJwY2llIjsNCj4gLS0NCj4gMi4zNS4xLjEzMjAuZ2M0NTI2OTUzODcuZGlydHkN
Cg==
