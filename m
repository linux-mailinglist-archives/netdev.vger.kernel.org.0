Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2932695BD8
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 09:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231831AbjBNIDW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 03:03:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230120AbjBNIDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 03:03:02 -0500
Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2060.outbound.protection.outlook.com [40.107.6.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B72270A;
        Tue, 14 Feb 2023 00:02:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i5aITRUdoaNKetGqd5xsJke6KWjhOiiXrwsesbmq7PGpRFx77PM9PQCm3hMcSO7arYlj+BLzu7er/dFEKRpHa46iUDYeidBPe2IHRoPEY1uGiZzpoih4Pq2qiCduATIYItccvrfD995fn2Q9MJvp6Re0Z9xr0s3J5lW89oTLs1nb8148UO4fidJ8jt9NV7uR6UPnF/PAO7nNqLckkVB6AJblJWXqhCAAqPml3D3PJT27OR7pEYK95+n8JTb/fwhFIHkEI2sSHiCQrYm7XbWWM77KHpxtPg1n59IP5Qpfnp0CwdPY21FB/k/YQbKR3+MUYQXCopzKmSxX4/nhlFoyWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fw3umQXzCZBumnWTNHJqaGe9d5fPWov+w/9upUaV+c4=;
 b=JIsCv6XwrjRqjhqu7T74tB98AELfPFxP/I8Cq+ZYLscadcweSEzFIdZ2nXFDRWMeE3dxt2B/ZQQFVOr+UjF2Za60C5wqkqB7MooXnd4dhDf/rivASjbwZSFsmfGdnkn3ZczprcfSwVlsM7Lew1dbDkw+Q7BtOj8R0PngLu7npKaj5vcpc+pWNtgda1/JUm1kQ5O6OpQag9AnFwo84jGaSSIwSIRw3ukFsD454nPoNXgfxSEYDCUi/jE6OaMSj2mX3AaFyPlHXVxXRWSX9E3OBVmwlQQ4MD3tO9/jqqBmwXrY3mDmQGwcFLM8wYlccMQWcAhG1ryy2MF1kuSb2Wsb6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fw3umQXzCZBumnWTNHJqaGe9d5fPWov+w/9upUaV+c4=;
 b=DdOKbD73dijEpZYCsVS3tXnUYp3OA00JC85mKa7Wvq15xLEYKYh2vO7/y8xmcBLznZ8jDR/SNARtV9ldS+f5SXYEZklecfA3et6pI6p9om5VT0O8MAWQ1MbO5qrRYMqGLVVtaDc7/SZk9O10XQ/MfDcJPWd3j9Y81mpVnHJWJEo=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PA4PR04MB7741.eurprd04.prod.outlook.com (2603:10a6:102:c6::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 08:02:35 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::5b45:16d:5b45:769f%6]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 08:02:35 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Topic: [PATCH V2 net-next] net: fec: add CBS offload support
Thread-Index: AQHZP44WIaasQ+1ZZ0O2FaaW5aXAcK7M4BmAgAEGe5A=
Date:   Tue, 14 Feb 2023 08:02:34 +0000
Message-ID: <DB9PR04MB81061DBCB81202863FC1655E88A29@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230213092912.2314029-1-wei.fang@nxp.com>
 <Y+o75wT84f6RTohf@lunn.ch>
In-Reply-To: <Y+o75wT84f6RTohf@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|PA4PR04MB7741:EE_
x-ms-office365-filtering-correlation-id: ef06a32b-1178-4897-6351-08db0e61d4f0
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8T48YTE0b01D1qKfAwK9WarrdIVqNdWFBx2U44oIHqpe0zqwUppy2TT1nCLpHvG70WN7IRiUVv5GMHuZk1qMJJey38jq1HxeeCw+ZKTRmLvLqn3NRwLgd66E/NLcJDR2//rQj44qDRHd9CYnARgpGMZNpPTKidNY515AkreT3Q0Yd3ri5JIEilrdnfxMnyvG2JpQcPu1wb3BsgSnJlrashKzLyJA866APCdWWqt4NlQqAUnIA2TO1l3arffxP9G6cOsA4bPUOsJ1Y4Ro2MI0VkuwwaI3NCKRJM1G0xXSCPaLVjwM6HQxlyTTkeecAjJ9/LMu0dxW6kWOFqHQfrQxcuK/rc/HZOz5Xs1e646O7Df0OGKfGBz9wpRS+aiylsoOvFGOJWPAn+Mz4wCB4fKLbkB3XFrQ9lhPxNdU2ltTx6S8PfS9J2gZDASvzuuEloB3i80IpaTp6ttsE8S86N/TLwX6Sxsy9TGrApl1AeDc5KWhajfgRHTpzYTwk48YTqxXDzGpCRFg9hFijQoBteWxatFGhMUcs00jGK6mH8Ne377EHi4A8MKDe++TJxP0zuOC/yB+HLlqotTFRx0Gytvbcut5d+olYUO5Dy+hv/Zey5L9SdgJjhP8OaTzaZxo88+WSr7+8QjMUkhmPWlbA4fZT4KHKOtjLm6+fNQuCuVpvl5dytOkRkjMjSKw17/BQM0TG//PWR8T0GTfzaVAY2a8BQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(346002)(396003)(366004)(39860400002)(376002)(451199018)(83380400001)(44832011)(2906002)(9686003)(7696005)(71200400001)(186003)(478600001)(8676002)(64756008)(6916009)(53546011)(41300700001)(33656002)(6506007)(4326008)(26005)(54906003)(86362001)(55016003)(5660300002)(122000001)(38100700002)(316002)(66446008)(52536014)(66476007)(66556008)(38070700005)(8936002)(76116006)(66946007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?cnh2S0l4OE4yZ2Q0K1hxUXJPTFNpT054ZHBCYnhvaUZWeWxlSVRqMEpNVWFm?=
 =?gb2312?B?c3plZ3JFQU5xVUwrVStGbTN2dkMzZ2xGTWF0OGFOdjI3RTZueC9VcWNaeWti?=
 =?gb2312?B?WUR6N0NaZW5vdmZPamVBSVAzODVFenlPV2l1NkN1L2FKYlJYczFaS3EwYmpY?=
 =?gb2312?B?OWRPWm5ZZ2YxUWJzL05ObTRTL2hmYW9VL25GL0VmL3RPclBsQndNNW9UTktY?=
 =?gb2312?B?SFBSLzZ5ZE1wSEZQamQraVN1UFNGV01uSkp1OVVhdWNLWDFodjNhOVZwWXFY?=
 =?gb2312?B?TFl5bUlVR3FOUEZOeUVEa1pRdTVVdW5UNTllOVo0eHZQQkFwR3dCRmVyVGEw?=
 =?gb2312?B?T0l5ZEpzakovRXJFWSszMmxyNkVyakJnUGJJU2laQ09xQWJmZE52U1lHL3ox?=
 =?gb2312?B?bFVKSWR3Q2xDL3EzcTdMUUdnZEFrcktUTDdSOG9jYnluRXNtbVVVWVpPVHJ3?=
 =?gb2312?B?L0tZUmNjZm11Q2ZlMVpOV3FGQThsaE43VEhtM0hyWGFYYytLcStLQkx0dWJD?=
 =?gb2312?B?Wnp6dGZRdllRVlBUZ2FGa3F6VzREcHRGOTFiQzRwZ0p3T3B5aVRZaHhuM2g0?=
 =?gb2312?B?SFJLalNUcEVQRXhDcGlCMFczTitFUm00aGdRemFnTjh0dWZNZXRNYVZlSUdN?=
 =?gb2312?B?MnB2RE1hWWUwQVJOdXF5Wk5xdTkxYTZVRXdMeXFIQUROZEpLSWZ5T2YzWnNq?=
 =?gb2312?B?c1hua0dNeE5uZ25zcmNIdG4zekVXcC9NVFdkMDIwV2dCU0QzeEsvODlqNWQ4?=
 =?gb2312?B?OGJTaDBlSm1sN2NCZDh5TnNPRmVWUG9LekNVTFdMUVVEZ010OUM5YXZ2VStS?=
 =?gb2312?B?b0N1RUpabW1obmV2emIzK2dqSHRzMmlWTXV1R21SZ0xHcWJpR016dXU5WWUz?=
 =?gb2312?B?WktMdVg5cDJEaVhJZDdZM01BT0diaTJuNEh1Y2dRWkI4RllrUFVtS09NZXNL?=
 =?gb2312?B?SlN6NkdtanFOa3habE82T3Y5WVdRRitkbXE5WjBJSUFieUdWUnBGSWtQYU94?=
 =?gb2312?B?MmcvYWRIWG9KOTdFMnR4US9VM3JmcHpXdG9CZjMzd2hIL1NjaGlRUVJRZmZW?=
 =?gb2312?B?UWllRFo4Z1lHdVZCbVN2WEl6Z2hSZTArSERlZmlUcUxMK2x4RDVLdGl1OWlz?=
 =?gb2312?B?cENYZ3I5Q283dFkzVU9FUk1tc0d0R3V1T3h1ZlVLa2QxYzU5U2hTYkxrKzZm?=
 =?gb2312?B?cmtmOStzaDRlWmhyWFkzTXg0Q1dVVHpJSEdlSkNHRy91RCtHUmNiUkVqMGF6?=
 =?gb2312?B?bHhrSVRjdEVQazFjWGpYSHIrZmJNYXRMRWN2VjJMM3l3RzVmQ053ZFZFbHhB?=
 =?gb2312?B?K0RhSWF6MUtxMk9IZTNlSitQQWU0M3RYVFdjYlJqUEdXd1FUODg4cmJPUWpO?=
 =?gb2312?B?QUR5elRiR0ZyQXlJT3kyVXRZZ3M3UVU3TFVxM1VDaFg0aUNyMjFLcU5sL1BI?=
 =?gb2312?B?bzFHQmQvSUt6ZGw1ajE2U3ZReHY5MG0wZkRTSmdScEl6MmJneHlIdTc4cUdm?=
 =?gb2312?B?c2QyOE13T21nQnlxZi81azU0RjI3R1hVVWI5aDUrbEs0dFFsM0RxeS90SWY3?=
 =?gb2312?B?bTFFUzQ0RUFOY1BHOWswclVYTHUyVDB2WkZNTmltNFVTNGhJQnhZNzFUV2d5?=
 =?gb2312?B?ZEV0ajhDVlovdWpRZ3YxQzVWSmJGb21iY2VYdUE0RkRXckZxclovUldIeDV1?=
 =?gb2312?B?amFMMjZIS0kzdkh4V1Q0SEN4cXkreEhUdmpTUUpMZlZYSEFxQm5BcjJ4VEpV?=
 =?gb2312?B?L1BTQ2pMblBsbk1vK3gyR1RGWm1XdzFzclpGcDg1ajJNQlhIdUpSU0hrdzJE?=
 =?gb2312?B?R0RtenV5Sm12eitXNlpXN0w1Y29DSVk0b3R3cTdsU294ZnFvcFdOcUMrc0ZD?=
 =?gb2312?B?OE93cHVnTy8vVmlENDdUQi9VTEEwK3c3b3VOeUQwV09Vb1NhV1FVcmczMTlh?=
 =?gb2312?B?YkNGS1BCN1JrVmRJVHVyZTlUU1BENWt2UHdlU0VhaXNid1VOMHhWbUhrZENW?=
 =?gb2312?B?Yjh1dU1WNVQyRjdwMXRRN0l4K2tKdFllZlJSRVVRZk1DZ29LZjltKzVTNVZL?=
 =?gb2312?B?RzlYN0ZrSUxmY0dBWVdVZTNqcmhCSjBVdE1FUmNUL1loMU9HbmtzM3BVSUVH?=
 =?gb2312?Q?bJoQ=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ef06a32b-1178-4897-6351-08db0e61d4f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 08:02:34.9885
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0AE60HBoC9/13BUBpsgiDc9R7gfslD5uwI3FD3LN709I1bpFZmZ8M0tmiZCHIJWMjcXePl2tG0Ep4Gr327BpGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PA4PR04MB7741
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmRyZXcgTHVubiA8YW5kcmV3
QGx1bm4uY2g+DQo+IFNlbnQ6IDIwMjPE6jLUwjEzyNUgMjE6MzINCj4gVG86IFdlaSBGYW5nIDx3
ZWkuZmFuZ0BueHAuY29tPg0KPiBDYzogU2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhwLmNv
bT47IENsYXJrIFdhbmcNCj4gPHhpYW9uaW5nLndhbmdAbnhwLmNvbT47IGRhdmVtQGRhdmVtbG9m
dC5uZXQ7IGVkdW1hemV0QGdvb2dsZS5jb207DQo+IGt1YmFAa2VybmVsLm9yZzsgcGFiZW5pQHJl
ZGhhdC5jb207IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7DQo+IHNpbW9uLmhvcm1hbkBjb3JpZ2lu
ZS5jb207IGRsLWxpbnV4LWlteCA8bGludXgtaW14QG54cC5jb20+Ow0KPiBsaW51eC1rZXJuZWxA
dmdlci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggVjIgbmV0LW5leHRdIG5ldDog
ZmVjOiBhZGQgQ0JTIG9mZmxvYWQgc3VwcG9ydA0KPiANCj4gPiAzLiBBY2NvcmRpbmcgdG8gQW5k
cmV3J3MgY29tbWVudHMsIHRoZSBzcGVlZCBtYXkgYmUgZXF1YWwgdG8gMCB3aGVuIHRoZQ0KPiA+
ICAgIGxpbmsgaXMgbm90IHVwLCBzbyBhZGRlZCBhIGNoZWNrIHRvIHNlZSBpZiBzcGVlZCBpcyBl
cXVhbCB0byAwLiBJbg0KPiA+ICAgIGFkZHRpb24sIHRoZSBjaGFuZ2UgaW4gbGluayBzcGVlZCBh
bHNvIG5lZWQgdG8gYmUgdGFrZW4gaW50byBhY2NvdW50Lg0KPiA+ICAgIENvbnNpZGVyaW5nIHRo
YXQgdGhlIGNoYW5nZSBvZiBsaW5rIHNwZWVkIGhhcyBpbnZhbGlkYXRlZCB0aGUgb3JpZ2luYWwN
Cj4gPiAgICBjb25maWd1cmF0aW9uLCBzbyB3ZSBqdXN0IGZhbGwgYmFjayB0byB0aGUgZGVmYXVs
dCBzZXR0aW5nLg0KPiANCj4gSSBkb24ndCB0aGluayB0aGF0IGlzIHdoYXQgeW91IGhhdmUgYWN0
dWFsbHkgaW1wbGVtZW50ZWQuIEEgbGluayBzdGF0dXMgY2hhbmdlDQo+IGNhdXNlcyBhIGZlY19y
ZXN0YXJ0LiBBbmQgaW4gZmFjX3Jlc3RhcnQsIHlvdSBub3cgcmVwcm9ncmFtIHRoZSBoYXJkd2Fy
ZS4gU28gaWYNCj4gdGhlIGxpbmsgc3BlZWQgaXMgc3VmZmljaWVudCB0byBzdXBwb3J0IHRoZSBy
ZXF1ZXN0LCB0aGUgaGFyZHdhcmUgc2hvdWxkIGJlDQo+IHNldHVwIHRvIHN1cHBvcnQgaXQuDQo+
IA0KSSBhbHNvIGNvbnNpZGVyZWQgdGhhdCBhcyBsb25nIGFzIHRoZSBjdXJyZW50IGxpbmsgc3Bl
ZWQgbWVldHMgdGhlIGlkbGVzbG9wZSwgdGhlDQpoYXJkd2FyZSBzaG91bGQgYmUgc2V0IHRvIHN1
cHBvcnQgaXQuIEJ1dCBJIG5vdGljZWQgdGhhdCB0aGUgZGVzY3JpcHRpb24gaW4gSUVFRQ0KODAy
LlEtMjAxOCBTZWN0aW9uIDguNi44LjIgaXRlbToNCglzZW5kU2xvcGUgPSAoaWRsZVNsb3BlIKhD
IHBvcnRUcmFuc21pdFJhdGUpDQpUaGVyZWZvcmUsIEkgdGhpbmsgdGhhdCB0aGUgYWJvdmUgZm9y
bXVsYSB3aWxsIG5vdCBob2xkIHRydWUgaWYgdGhlIGxpbmsgc3BlZWQgY2hhbmdlcy4NCkJhc2Vk
IG9uIHRoaXMgY29uc2lkZXJhdGlvbiwgbXkgY3VycmVudCBpbXBsZW1lbnRhdGlvbiBpcyByZXN0
b3JlIHRvIHRoZSBkZWZhdWx0DQpzZXR0aW5nIGlmIHRoZSBzcGVlZCBjaGFuZ2VzLiBGb3Igb3Ro
ZXIgY2FzZXMsIHN1Y2ggYXMgbGluayBkb3duL3VwLCB0cmFuc21pdCB0aW1lb3V0LA0KYW5kIHNv
IG9uLCB0aGUgaGFyZHdhcmUgd2lsbCBiZSByZWNvbmZpZ3VyZWQgdG8gc3VwcG9ydCBpdC4NCk9m
IGNvdXJzZSwgaWYgeW91IGluc2lzdCB0aGF0IGlmIHRoZSBsaW5rIHNwZWVkIGlzIHN1ZmZpY2ll
bnQgdG8gc3VwcG9ydCB0aGUgcmVxdWVzdCAsIHRoZQ0KaGFyZHdhcmUgc2hvdWxkIGJlIHNldHVw
IHRvIHN1cHBvcnQgaXQsIEkgd2lsbCBjb250aW51ZSB0byBpbXByb3ZlIHRoaXMgcGF0Y2guDQoN
Cj4gV2hhdCBhcmUgdGhlIHJlYWwgdXNlcyBjYXNlcyBoZXJlPyBWb0lQPyBWaWRlbyBzdHJlYW1p
bmc/DQoNClllcywgdGhpcyBmZWF0dXJlIGlzIHVzdWFsbHkgdXNlZCBmb3IgQXVkaW8gYW5kIFZp
ZGVvIHN0cmVhbXMuDQoNCj5TbyAxMjhrYnBzLA0KPiAyTWJwcy4gQm90aCBvZiB0aG9zZSBhcmUg
ZmluZSBvdmVyIGEgMTBIYWxmIGxpbWsuIFNvIGkgdGhpbmsgeW91IHNob3VsZCB0cnkgdG8NCj4g
Y29uZmlndXJlIHRoZSBoYXJkd2FyZSB3aGVuZXZlciBwb3NzaWJsZSwgYWZ0ZXIgbGluayBjaGFu
Z2Ugb3IgYW55IG90aGVyDQo+IGNvbmRpdGlvbiB3aGljaCBjYXVzZXMgYSByZXNldCBvZiB0aGUg
aGFyZHdhcmUuDQo+IA0KVGhpcyBpcyB3aGF0IHRoZSBjdXJyZW50IHBhdGNoIGltcGxlbWVudHMg
ZXhjZXB0IGZvciBsaW5rIHNwZWVkIGNoYW5nZXMuDQoNCj4gV2hhdCBpIGhhdmUgbm90IHNlZW4g
YWRkcmVzc2VzIGhlcmUgaXMgbXkgY29tbWVudC9xdWVzdGlvbiBhYm91dCB3aGF0IHRjDQo+IHNo
b3dzIHdoZW4gaXQgaXMgbm90IHBvc3NpYmxlIHRvIHBlcmZvcm0gdGhlIHJlcXVlc3QgYWZ0ZXIg
YSBsaW5rIGNoYW5nZT8gRGlkDQo+IHlvdSBsb29rIGF0IGhvdyBvdGhlciBkcml2ZXJzIGhhbmRs
ZSB0aGlzPyBNYXliZSB5b3UgbmVlZCB0byBhc2sgSmFtYWw/DQoNCkZvciBtb3N0IGRyaXZlcnMs
IHRoZSBzZXR0aW5ncyBmb3IgaGFyZHdhcmUgQ0JTIGRvIG5vdCBjaGFuZ2UgYXMgdGhlIGxpbmsg
c3BlZWQNCmNoYW5nZXMuIEkgbG9va2VkIHRoZSBzdG1tYWMgYW5kIGVuZXRjIGRyaXZlcnMsIHRo
ZXkganVzdCBrZXB0IHRoZSByZWdpc3RlcnMnDQpzZXR0aW5nIHdoZW4gdGhlIGxpbmsgc3BlZWQg
aGFkIGJlZW4gY2hhbmdlZC4NCkFib3V0IHRoZSB0YyBzaG93IGNvbW1hbmQsIGRvIHlvdSBtZWFu
IHRoZSAidGMgcWRpc2Mgc2hvdyBkZXYgZGV2bmFtZSINCmNvbW1hbmQ/IElmIHNvLCBJIHRoaW5r
IHRoaXMgY29tbWFuZCBqdXN0IGdldCB0aGUgcHJldmlvdXNseSBzYXZlZCBkYXRhIGZyb20NCnRo
ZSB1c2VyIHNwYWNlLiBTbyBpdCBpcyBub3QgcG9zc2libGUgdG8gaW5kaWNhdGUgaW4gdGhlIHRj
IHNob3cgY29tbWFuZCB0aGF0DQp0aGUgY29uZmlndXJhdGlvbiBpcyBubyBsb25nZXIgcG9zc2li
bGUuIFVubGVzcyB0aGVyZSBpcyBhbiBpbnRlcmZhY2UgcHJvdmlkZWQNCmZvciB0aGUgZHJpdmVy
IHRvIGdldCB0aGUgY3VycmVudCBDQlMgY29uZmlndXJhdGlvbi4NCg0KPiANCj4gPiArc3RhdGlj
IGludCBmZWNfZW5ldF9zZXR1cF90Y19jYnMoc3RydWN0IG5ldF9kZXZpY2UgKm5kZXYsIHZvaWQN
Cj4gPiArKnR5cGVfZGF0YSkgew0KPiA+ICsJc3RydWN0IGZlY19lbmV0X3ByaXZhdGUgKmZlcCA9
IG5ldGRldl9wcml2KG5kZXYpOw0KPiA+ICsJc3RydWN0IHRjX2Nic19xb3B0X29mZmxvYWQgKmNi
cyA9IHR5cGVfZGF0YTsNCj4gPiArCWludCBxdWV1ZSA9IGNicy0+cXVldWU7DQo+ID4gKwlpbnQg
c3BlZWQgPSBmZXAtPnNwZWVkOw0KPiA+ICsJaW50IHF1ZXVlMjsNCj4gPiArDQo+ID4gKwlpZiAo
IShmZXAtPnF1aXJrcyAmIEZFQ19RVUlSS19IQVNfQVZCKSkNCj4gPiArCQlyZXR1cm4gLUVPUE5P
VFNVUFA7DQo+ID4gKw0KPiA+ICsJLyogUXVldWUgMSBmb3IgQ2xhc3MgQSwgUXVldWUgMiBmb3Ig
Q2xhc3MgQiwgc28gdGhlIEVORVQgbXVzdA0KPiA+ICsJICogaGF2ZSB0aHJlZSBxdWV1ZXMuDQo+
ID4gKwkgKi8NCj4gPiArCWlmIChmZXAtPm51bV90eF9xdWV1ZXMgIT0gRkVDX0VORVRfTUFYX1RY
X1FTKQ0KPiA+ICsJCXJldHVybiAtRU9QTk9UU1VQUDsNCj4gPiArDQo+ID4gKwlpZiAoIXNwZWVk
KSB7DQo+ID4gKwkJbmV0ZGV2X2VycihuZGV2LCAiTGluayBzcGVlZCBpcyAwIVxuIik7DQo+ID4g
KwkJcmV0dXJuIC1FQ0FOQ0VMRUQ7DQo+IA0KPiBFQ0FOQ0xFRD8gRmlyc3QgdGltZSBpJ3ZlIHNl
ZW4gdGhhdCBvbmUgdXNlZC4gSSBoYWQgdG8gZ28gbG9vayBpdCB1cCB0byBzZWUNCj4gd2hhdCBp
dCBtZWFucy4gSXQgZG9lcyBub3QgcmVhbGx5IGdpdmUgdGhlIHVzZXIgYW55IGlkZWEgd2h5IGl0
IGZhaWxlZC4gSG93DQo+IGFib3V0IC1FTkVURE9XTj8NCj4gDQpJJ3ZlIGJlZW4gdGhpbmtpbmcg
YWJvdXQgaXQgZm9yIGEgbG9uZyB0aW1lLCBhbmQgSSB0aG91Z2h0IHRoaXMgbWlnaHQgYmUgbW9y
ZQ0KYXBwcm9wcmlhdGUuIEJ1dCBub3cgSSB0aGluayB0aGF0IHVzZSB0aGUgIWZlcC0+bGluayBo
ZXJlIGlzIG1vcmUgYmV0dGVyDQp0aGFuICFzcGVlZCwgc28gLUVORVRET1dOIGlzIG1vcmUgcHJv
cGVyLg0KDQoNCg==
