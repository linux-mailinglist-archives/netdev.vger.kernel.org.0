Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 844B94BB828
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:33:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234504AbiBRLeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:34:04 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231401AbiBRLeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:34:03 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80044.outbound.protection.outlook.com [40.107.8.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EDCE2A0717;
        Fri, 18 Feb 2022 03:33:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IDsKQhDIAq7y917aBvh7q79/nhT73OM6KXtL2QwLDfVf+bRQeEoaiF2jVIB9VbC8bUxWO6jvpWKAARfbego436GURbExzOy9TfFYCgibYpY8tOru4RlDgeaaIjeH5hM0u8IDhr8qxKYcJw8L0QutxxVGqggBzVi2Ob+yWOokB2jzmp9weRIPOglN2pcALSrwMl4FoXYCLK/jb6A/TUgLVfNZpauMDUNLICNf9R7H5m6+qa1j+BfGJllC8nufyC8tCwscxW4QAjSRE6lk2ltklBEP+U1EV2dkG21V1V+/hNEC1hcwUxo3q02MpD8X5XuMcBSIHrjuoxGkb+YH1taIFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=acOqlNz6PR5Qww/ppLALs2+V7Jla2unpYFkHQ0lshMc=;
 b=j34d9QARzT7H0uhi/pJ+p4v7kw1ELPceEDNsSRRdykK5kjH77AI7z0K1WoAUVBYTgaII0bo07ZuSq14OXwcnOdnJ1Amue3d56AGukvvIGMUzn5sPR0G77ymtI6RkGA4HRDFV2nE+wUc9X+xGDa8tRKb4JVRpeJLz2XRGzCTDMY75fCiWYTFZ7hihgp1iL7crUhIenIgo0KoQtEX6+1ETdyqIu+tUGhqRXcuB6EIowThABo/shcO2uFExZ1LbiTkgN7+CpRh/GwsgerBpOnFR5MequjZuaG+aJSL5MKgNx30juhyPZdphs2VfpAFMU09uvGA3qRQo/fVndtD9zyoo4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=acOqlNz6PR5Qww/ppLALs2+V7Jla2unpYFkHQ0lshMc=;
 b=betAQh7MuKy6GGv5h4FvXZT89V67eQH37R/RAv3pAf7ma+zm9HMAJF3RAZdYBrJdMKRHZYUYLSupjRNlyEBP6yYfKlMLvm8EqEljMFrG1uxWVhQfGzFBDs02tLRBoXZKiNgxhmZL+3mDfBDQ58s2o4VKaoRO34GQ9fJbKgYah1w=
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com (2603:10a6:209:3f::17)
 by DB7PR04MB5082.eurprd04.prod.outlook.com (2603:10a6:10:14::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Fri, 18 Feb
 2022 11:33:43 +0000
Received: from AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::10c0:244:ae5:893d]) by AM6PR04MB3976.eurprd04.prod.outlook.com
 ([fe80::10c0:244:ae5:893d%4]) with mapi id 15.20.4951.019; Fri, 18 Feb 2022
 11:33:43 +0000
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     EVS Hardware Dpt <hardware.evs@gmail.com>
CC:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
Thread-Topic: [PATCH 1/2] net/fsl: fman: Allow fm_max_frame_sz &
 rx_extra_headroom config from devicetree.
Thread-Index: AQHYJBi7im4VlVtoXEK5XJ+cBjruzqyY6EQwgABE+YCAAABbgA==
Date:   Fri, 18 Feb 2022 11:33:43 +0000
Message-ID: <AM6PR04MB397692A930803C5CB6B1D568EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
References: <20220217160528.2662513-1-hardware.evs@gmail.com>
 <AM6PR04MB39761CAFB51985AFC203C535EC379@AM6PR04MB3976.eurprd04.prod.outlook.com>
 <CAEDiaShTrWgA75e8x2deHMHF-53LFiusrVHTxP_Jy4gvaLg_9A@mail.gmail.com>
In-Reply-To: <CAEDiaShTrWgA75e8x2deHMHF-53LFiusrVHTxP_Jy4gvaLg_9A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ccb262be-ca3e-41fc-6273-08d9f2d284ef
x-ms-traffictypediagnostic: DB7PR04MB5082:EE_
x-microsoft-antispam-prvs: <DB7PR04MB508241DAD68F0C067DCA9307EC379@DB7PR04MB5082.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6JON/PS847km9IH9Yw89gAszXH2W4oa7ca3wdlqu0KKIPzBsLHZmue45J/Asme506vDV7Sjiw1qMvEbb+Kw1jdvWlYDhj64ogFPTD0HbePnLL4+s1muW88SxCjE75Hog8UFlyf/6NnPqtvHcjlr0lQTnXjmq18QsekEVSXSiBcdoKdjr27vtGb6ie9NCI2Z2sG5ASvUJF9tn+mHtd4GPwKDpuskj9942XZYaa3cfCM+4SpnXfrTJvvze1CuSRbR28dXz+CzNFaaMieyaW8gIZlqtFVb3O8wX9QlDbR32sqeqfZeU3XWIbXeEWeqFVIGRhmTNNyX5IDibvWvTjjtM5Li2muDqnAKtC12f9/IraVbUzgVwL9KVLqj5CQI1mwS7WCk+Xkn2F4HU/wPkLasPYF+ylXOinKEFzwnUjLw8eN+dD8eavjM8cHB6xXLi1NjDAKF3kZ8b9DpyE6vYKk+oKUPx9gb9IcriWS1NNV5kLSKRTFYJdX9EHtAdz1e5+NsWFOnSzAjvX9qDVKSNx040lTQYfp6UvzgG6TTllHT1STJpidVoeG5QmG4+8zTCCRKcj00+JvrNESuX1Bm8bhVCsEYNNMV4WbAK3cBCLprbq0fZmC9ZOoWGHlcJhkagUmW4E4j1njtOfieC4Rh7Gs4zD51Pn005gbJ1n9G8sCBGe5TX+xes0GjkUMNTFpaRmAmGKqeTwWap1kp5W9WZgCNz3Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM6PR04MB3976.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(54906003)(7696005)(6506007)(83380400001)(71200400001)(6916009)(55016003)(8676002)(76116006)(64756008)(508600001)(66556008)(66446008)(4326008)(66946007)(66476007)(33656002)(9686003)(5660300002)(8936002)(52536014)(38070700005)(186003)(26005)(316002)(2906002)(122000001)(38100700002)(44832011)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MkVRZGdKZ1RYU1VHNHlTcE16Ym9ybWVINy9QWUtKd2x4UXNVNXdva1VqOVhM?=
 =?utf-8?B?bk8vMG5xMDg4ZjU3ZVZqM2NnL3ZPc2pQZE9nRzI5Tk5ZZHBMdGw1bW1oWHU2?=
 =?utf-8?B?UkthTGFBTE44UFU4cG94WWMza1gyMkRxeGNsSkY2Mi9UenBaTVZ2RFcxbzFs?=
 =?utf-8?B?bm9GL3FqRHNzcjJJNUEyd2ZmTEpCYUM3aEFTemlpZVBOZmE3SHYzMmxrb2h1?=
 =?utf-8?B?WDhrZ083dUVsNmQ2V2lwUmhsall1SWY1QjBvRmsxTGxXOWxuZ0FONmo1ckRr?=
 =?utf-8?B?K0F2dHBHWGZjUzNtQzZxcVdzQmxUOS8yTkVmdGwvMzA1Mkk4Zk9mSDVCWXhP?=
 =?utf-8?B?cWM2eHJpdDlEMEMzK3Y5YWdjUXY0ZEcrb0RwMHR2Z1Vteko5cjNROVd6U0E0?=
 =?utf-8?B?bW1rajBjMWNlekJSZW9pRnhoK1hSdHByR0M3eVVCSEJEOGlhaXIwR2ZseS9X?=
 =?utf-8?B?VTBHeGRDaVN6YmZMcU5VYkVDQURKbWxKRzFWZjRENDNYYjdYb0pHbGI4R0FG?=
 =?utf-8?B?Z3dIdyt4L2dBcnptL3lSMEJaU1V3UVVZUnV2WWxXaVRXZ1ErZU84YW4vVkIy?=
 =?utf-8?B?UWp2MWpXZDNPK1lYWG02ZnBHOVdvc29aMkhoVU1GQkd5Sk1JdzRjaE1NR0N0?=
 =?utf-8?B?a2s1RExkdmk4RnQzYUozakltQ2Nvb0FIdnF0WjBHMjFRbFU0V2ZsMStmSkZL?=
 =?utf-8?B?MTJDS2JOOWNTNE82c0hiSDBLdHpOeGVsMDNYSFh0U25YRU9hcWlWN256RjRx?=
 =?utf-8?B?SjBZcG41TlNYUWFjb09mVVBFS3NQR3NGeEVBVG9idGVrUkhnZks4V1FjN0s2?=
 =?utf-8?B?Y1ZKOFB4aXZRYmZieDFDRHYxNjFqWlF5aHcxRGRUWEsxZGttZTFDbExiMUMw?=
 =?utf-8?B?YnNwKzVKRkZOaDNraWlnWUNOOWtESkpoQzF6WDR2T1Bxem0rK0YzeUlqR1BH?=
 =?utf-8?B?OWQ1Y3A1clZtMURLcTNMQnhGS0pPQlFDTTBCRU9vN3FKdXNxZ3MyaTBFR3dv?=
 =?utf-8?B?MkMwMzJGWW5jSFFCVVpnTVduN3FyTXdyUWdMdVBQWXAreXFYME1IVmtCK1lW?=
 =?utf-8?B?MTBqUEUwcVR5RUVadU8rWmN3WHg3OWYvM1h2Z2U2NktveHNuaUQrNm1YanRG?=
 =?utf-8?B?YmdiMFJEUXdmOGxZcG9WRzFUWldQRGlYMDVWaVllcG1jaThUYTlOK2hwSjZ0?=
 =?utf-8?B?Z1lVaWF1ZmIyNWJvWjlVb3pNN1NRMzliNE9LT0tVbDRWL05lR1Y5czBibXYw?=
 =?utf-8?B?ZFZpTitNTVhkY1VoOS9RWUxrMHl2UndxaFAzQUh3RWp6dDJjdDZxa0NFUXJr?=
 =?utf-8?B?ZkxleTYyWFBOeWl2L01oQ2FyVXJNRFMrZHBjQXJOVzZJRUZqeEZhb0dQV01C?=
 =?utf-8?B?MXE0WmorTW1TNGFIckNUUkZBZzNsdlllazFtWjhsbkFzRWo0TE1ZMmU0MS9C?=
 =?utf-8?B?UVdaSXpMaUZNVkZ0MXFlUGpqZEpmQjRET2ViNW9Xcmk0djNpNmJVd2wyTFhT?=
 =?utf-8?B?STJvTnJhOXlDcE1QUjM2aFViSXJxT3k0NW15b0pXU0FpbDZReVp5M21lSUlV?=
 =?utf-8?B?Z3ZKWVZLVG1jamlJYkVTOW1mYVo1KzY1Y2JXcURRY2tDdFdtS1N4b1BUOFBS?=
 =?utf-8?B?S3VIVlpWQWtZWi9CV2ErT29vWkFRbjQzbHR3YTE4UElpaWlIZGdaRk0rakhq?=
 =?utf-8?B?VDVxaTRyUGVnNm5GV0hheVhyOGxkb3Vxd1I1cEhUcVAxNFhJaXROTnFNUGZt?=
 =?utf-8?B?UTZGc1pXSDNjY1RVYkx3V3hNcWF5clR3MHM3WUNZdnQ0dGJvMllvcExkNHhw?=
 =?utf-8?B?T3lnSUF4NXF4Z2FYTXRCSUlYZTZpRytLenJpS2hKTWpCdlZBdHUvRFVsZ2xW?=
 =?utf-8?B?YUI3TlJVTTU3d0tzR0NUMlNsTnoxVXFOODBlTk5RRzZTczJ3TWRSekZtRGc2?=
 =?utf-8?B?Y05nRDFqWk5hd2ZOTFBzRWVVdk5RclVPMEZZUU8razNpcEhsZ3dlRFlkVUhk?=
 =?utf-8?B?M3JpNzJzcUh3VEk5VCtMamxlNVR2b3pRU2RoeFg1bUEwNDA1RVhQaVZIcDhM?=
 =?utf-8?B?UE1xdFA2YU9CYmpVWEYyRVdyQlFvNnQraFdIVlRZRDI2NVV6NDRCMlg5UXNR?=
 =?utf-8?B?dVhhaVdOTTRVVVJrbnc0dUk0R2NmRU1WcVBSR0NqQzM0VndLbCtDQzlqVWVv?=
 =?utf-8?B?Vmc9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM6PR04MB3976.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccb262be-ca3e-41fc-6273-08d9f2d284ef
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Feb 2022 11:33:43.5876
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: q6efrMPl65AC+1lPHTdV2wEjRgGdA5Z+JCRBD1N+4IWA/Rb19fJy4OLzufEKr7ZWeOLJb6FyWQCBe32iEhJfgA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB7PR04MB5082
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBFVlMgSGFyZHdhcmUgRHB0IDxo
YXJkd2FyZS5ldnNAZ21haWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIDEvMl0gbmV0L2Zz
bDogZm1hbjogQWxsb3cgZm1fbWF4X2ZyYW1lX3N6ICYNCj4gcnhfZXh0cmFfaGVhZHJvb20gY29u
ZmlnIGZyb20gZGV2aWNldHJlZS4NCj4gDQo+IEhpIE1hZGFsaW4sIEd1eXMNCj4gDQo+IEkga25v
dywgYnV0IGl0J3Mgc29tZXdoYXQgZGlmZmljdWx0IHRvIHVzZSB0aG9zZSBwYXJhbWV0ZXJzIG9u
IGtlcm5lbCdzDQo+IGNvbW1hbmQgbGluZS4NCj4gSSBkb24ndCB0aGluayBpdCdzIHdyb25nIHRv
IGFsc28gYWRkIHRoYXQgaW4gZGV2aWNldHJlZS4NCj4gTm8gcmVtb3ZhbCwganVzdCBhbiBhZGRl
ZCBmZWF0dXJlLg0KPiANCj4gRm9yIGV0aGVybmV0IG5vZGUgaW4gZGV2aWNldHJlZSwgdGhlcmUg
YXJlIGEgbG90IG9mIGNvbmZpZ3VyYXRpb24gc3R1ZmYNCj4gbGlrZQ0KPiBtYXgtZnJhbWUtc2l6
ZSB0byBhbGxvdyBjb25maWd1cmF0aW9uIG9mIE1UVQ0KPiAoYW5kIHNvIHBvdGVudGlhbGx5IGVu
YWJsZSBqdW1ibykgYW5kIGl0J3MgcmVnYXJkZWQgYXMgZmluZS4NCj4gDQo+IEl0J3MgYWxzbyB0
aGUgZ29hbCBvZiB0aGlzIHBhdGNoLiBBbGxvdyBhbiBlYXN5IGNvbmZpZ3VyYXRpb24gb2YNCj4g
ZnNsX2ZtX21heF9mcm0gZnJvbSBhIGR0cy4gSSBhZGRlZCByeF9leHRyYV9oZWFkcm9vbSBmb3Ig
dGhlIHNha2Ugb2YNCj4gY29tcGxldGVuZXNzLg0KPiANCj4gU28gSSBwbGVhZCBmb3IgdGhpcyBh
ZGRpdGlvbiBiZWNhdXNlIEkgZG9uJ3QgdGhpbmsgaXQncyB3cm9uZyB0byBkbyB0aGF0DQo+IGFu
ZA0KPiBJIGNvbnNpZGVyIGl0J3MgbmljZXIgdG8gYWRkIGFuIG9wdGlvbmFsIGRldmljZXRyZWUg
cHJvcGVydHkgcmF0aGVyIHRoYW4NCj4gYWRkaW5nIGEgbG90IG9mIG9ic2N1cmUgc3R1ZmYgb24g
a2VybmVsJ3MgY29tbWFuZCBsaW5lLg0KPiANCj4gSG9wZSB5b3UnbGwgc2hhcmUgbXkgcG9pbnQg
b2Ygdmlldy4NCj4gDQo+IEhhdmUgYSBuaWNlIHdlZWtlbmQgTWFkYWxpbiwgR3V5cywNCj4gRnJl
ZC4NCg0KSGksIEZyZWQsDQoNCkkgdW5kZXJzdGFuZCB5b3VyIGNvbmNlcm5zIGluIHJlZ2FyZHMg
dG8gdXNhYmlsaXR5IGJ1dCB0aGUgZGV2aWNlIHRyZWVzLCBhcw0KZXhwbGFpbmVkIGVhcmxpZXIg
YnkgSmFrdWIsIGhhdmUgYSBkaWZmZXJlbnQgcm9sZSAtIHRoZXkgZGVzY3JpYmUgdGhlIEhXLA0K
cmF0aGVyIHRoYW4gY29uZmlndXJlIHRoZSBTVyBvbiBpdC4gUmVtb3ZhbCBvZiBzdWNoIGNvbmZp
ZyBlbnRyaWVzIGZyb20gdGhlDQpkZXZpY2UgdHJlZSB3YXMgb25lIGl0ZW0gb24gYSBsb25nIGxp
c3QgdG8gZ2V0IHRoZSBEUEFBIGRyaXZlcnMgdXBzdHJlYW1lZC4NCg0KPiBMZSB2ZW4uIDE4IGbD
qXZyLiAyMDIyIMOgIDA4OjIzLCBNYWRhbGluIEJ1Y3VyIDxtYWRhbGluLmJ1Y3VyQG54cC5jb20+
IGENCj4gw6ljcml0IDoNCj4gPg0KPiA+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4g
PiA+IEZyb206IEZyZWQgTGVmcmFuYyA8aGFyZHdhcmUuZXZzQGdtYWlsLmNvbT4NCj4gPiA+IFN1
YmplY3Q6IFtQQVRDSCAxLzJdIG5ldC9mc2w6IGZtYW46IEFsbG93IGZtX21heF9mcmFtZV9zeiAm
DQo+ID4gPiByeF9leHRyYV9oZWFkcm9vbSBjb25maWcgZnJvbSBkZXZpY2V0cmVlLg0KPiA+ID4N
Cj4gPiA+IEFsbG93IG1vZGlmaWNhdGlvbiBvZiB0d28gYWRkaXRpb25hbCBGcmFtZSBNYW5hZ2Vy
IHBhcmFtZXRlcnMgOg0KPiA+ID4gLSBGTSBNYXggRnJhbWUgU2l6ZSA6IENhbiBiZSBjaGFuZ2Vk
IHRvIGEgdmFsdWUgb3RoZXIgdGhhbiAxNTIyDQo+ID4gPiAgIChpZSBzdXBwb3J0IEp1bWJvIEZy
YW1lcykNCj4gPiA+IC0gUlggRXh0cmEgSGVhZHJvb20NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2Zm
LWJ5OiBGcmVkIExlZnJhbmMgPGhhcmR3YXJlLmV2c0BnbWFpbC5jb20+DQo+ID4NCj4gPiBIaSwg
RnJlZCwNCj4gPg0KPiA+IHRoZXJlIGFyZSBtb2R1bGUgcGFyYW1zIGFscmVhZHkgZm9yIGJvdGgs
IGxvb2sgaW50bw0KPiA+DQo+ID4gZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2ZtYW4v
Zm1hbi5jDQo+ID4NCj4gPiBmb3IgZnNsX2ZtX3J4X2V4dHJhX2hlYWRyb29tIGFuZCBmc2xfZm1f
bWF4X2ZybS4NCj4gPg0KPiA+IFJlZ2FyZHMsDQo+ID4gTWFkYWxpbg0K
