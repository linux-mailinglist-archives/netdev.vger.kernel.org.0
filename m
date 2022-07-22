Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A881A57E18B
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 14:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234251AbiGVMnr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 08:43:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230486AbiGVMnq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 08:43:46 -0400
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70053.outbound.protection.outlook.com [40.107.7.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B85AE0CA;
        Fri, 22 Jul 2022 05:43:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QRl8JNapdkgJwOUet67LAHHscP9mlXgHJQLMN7E/AzE1IUR30e6aOSXyDyFThPBugjPcz0y3ScEZGYGTyZrGgJzIJ6PGptPKvl6iM7GAK9mpuwZ52YaLjck3otd3rZFgfZiiY+bDtB3KGzU4L+41irQa3WQTvkS42X6eGz6hhHK++yzDYw7ifPiBrDrYNgWC8E3xTzmovo2NLmH3Xp5gbYEX1fP/6B9f8JdP2qCT7IyRwbtgiMKuAPC3wyM5ePJ1HgN+xgqvbivCVPyXsGY6d3lXcSRgv5KvM9we2SyGuLYWQGuuO/iAGCQySEAIrNqEWoigI/zAOzYMptgPbqECkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=N95xQlSGh5GEUP3qe8PQvhqYYQtOA3PRZqajNyMfwWM=;
 b=D8ZqRUO4XO0MhUugX4OUwbOIUHEYItiFX7J4kUn0P79qg+Zm6cv84WZ+iVsN67d3uRU61hLgfFpyFN+TSTU/waFTBn4NkWxQnuP0rXGw4mBQRJQqtvMTIQo0j5a+YntxbTCX9BPGsJ2tgSyX47g3iu+/IkM4ucw/tXYykz5VtK4NXz3WrxjybnbtIG7D/P6inT0KBALpchvqtYlJoQTLKOy15jtmg9cs78NedcQG/+Su8F0Z+/HcYxyr86M956Eb69RJyocniUXFvOCf/MH9w0SyYQ3Xq7/jA1kUKnXYDFYyQp/hlOOyE38ldzMasFDu0yVEq54KIc3598eZ5ifeag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N95xQlSGh5GEUP3qe8PQvhqYYQtOA3PRZqajNyMfwWM=;
 b=sAft2xUnf9BUeBrYAaXhXCydFBN/tJoS0yrVO/WXpyZcpPXJIItTBleS2Al3cviKLyFxCc81ork7OP6SAWQE1lieui1PMsx3ssIbVAsVjdTBjITsmzEaH34cRkhJpBW7AgCMp8W+jGZBLoVXiq7ffC6ZnCB08Th/Duntw1Ph/XI=
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com (2603:10a6:803:ec::21)
 by AS1PR04MB9503.eurprd04.prod.outlook.com (2603:10a6:20b:4d1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19; Fri, 22 Jul
 2022 12:43:42 +0000
Received: from VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27]) by VI1PR04MB5807.eurprd04.prod.outlook.com
 ([fe80::1df3:3463:6004:6e27%4]) with mapi id 15.20.5458.018; Fri, 22 Jul 2022
 12:43:42 +0000
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
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
Thread-Topic: [PATCH net-next v3 39/47] net: fman: memac: Add serdes support
Thread-Index: AQHYmJcSjDRhpKy6Qk2ihwHZ5ZBFnq2I17xAgAAm1ACAAWF6QA==
Date:   Fri, 22 Jul 2022 12:43:41 +0000
Message-ID: <VI1PR04MB5807D896858665A3F3C6418FF2909@VI1PR04MB5807.eurprd04.prod.outlook.com>
References: <20220715215954.1449214-1-sean.anderson@seco.com>
 <20220715215954.1449214-40-sean.anderson@seco.com>
 <VI1PR04MB58071192E279070C90F81843F2919@VI1PR04MB5807.eurprd04.prod.outlook.com>
 <ecc9051b-63dc-131b-9f87-138af7dc88aa@seco.com>
In-Reply-To: <ecc9051b-63dc-131b-9f87-138af7dc88aa@seco.com>
Accept-Language: en-GB, ro-RO, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d3ed4eac-0bbd-4eca-0e99-08da6bdfcee3
x-ms-traffictypediagnostic: AS1PR04MB9503:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: eFjJgNT0HPdw5F6ObSRITpBYdtgjPuNX8iWvMVxLu5ttmtUNneKxw3WraWPD2mDZgRZ+q/wW1aQdN8ZXPkJItDAhJLwWJSR6tKJFalHDDJHYMkmNDnnEMzF5BVt/spLVwhdxFU7gYYqSeoLx8dTI6NfmQwGcrmdbzw7Tl9UIOogLo+4Ta2/YDqhhD311aATB3dSIXuRAXdqhEfoS2LWu/WByUpxF8CwO/0YFQmtvfJUgi5Yexsei9sa1/WF2hi4AayCcJlZPuO67XrMij7x2Iu1MWkdgtN+7HUJPtwnd10NTmrMIoUsb9zrSaR+H1qfGHQ6ehQI7j8StBnaHiB0anwMx3wCKpTVFn7fgGmg5j+1uMpbkxwdWmp04JC9rWBoUeSaCMTSDhWOVq6MaA1vewv/omQPQr1DV+dyqPNyCseKj3oOq9vtEGMRg+ldvU+O85Pu9Zw+ynSx6Uc+MIo9ruTe9Bjgs/JaCeB1J6Yezl8Gy/EQzI2cN2PIfVGxF1wCTIgXgyxVdwERBR9hb/cFQ8UBghjRvgGdL6FMrgkDt+D1rjD+Bbo19/VxHfkkn/wFnlLgt7pEL6xXXDuSEULPxeio8nV9UX1CW2cOLXd4BWn3Y5KOrrqilhqWalsZzW3I2eAF3BOot8OkonLtUbIuAWnoS0DqKdKwjBtdmY1e9qqUpZNTIyGX+/5Q2Dnz5Zz+c8LrVVjkkIV8VLsYJ60U5+cz2TY8mrwMR5uDRtc77naOacsH7EcqBfCyyjJS6rQJjseV05iYZGVb6zH9pGjtP27ZIzoPPTYb3sQ2aoJZrZtCaQWbf73IlnygTDvc2/kw+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5807.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(366004)(136003)(376002)(39860400002)(396003)(186003)(2906002)(83380400001)(52536014)(66446008)(7696005)(478600001)(41300700001)(53546011)(26005)(9686003)(6506007)(71200400001)(55016003)(38100700002)(33656002)(64756008)(86362001)(38070700005)(4326008)(8936002)(110136005)(66556008)(316002)(122000001)(66946007)(5660300002)(66476007)(76116006)(8676002)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cS9FcVQ5SWtZWC9wNWFWbzJKaFZsUWlOOUhGQ0I2MzNmWWxNTGVjaWNuRzNH?=
 =?utf-8?B?eGtmbzRpaDBDQVdVNTRKaFU3RkN3QTAzT2JSRjJzYUdyaDl1ME5CUHE1c1Ir?=
 =?utf-8?B?YzdxMHdyMW5ENnZGY21IY1l0OXhGa2NFbzQyejBhV1Y1S3I1NFFCVEN2aEsz?=
 =?utf-8?B?amJNaVJiWGpzWHZENmI0aTRadmx0NG1vWXBuYXlsRlBNVzV2dTVla0JDcTRw?=
 =?utf-8?B?SlVtWDZHUDR6bGt0YndxcWI0TUx4VFBZZDBjdzVZMkdGTTk1OVVoSVlMTE9Y?=
 =?utf-8?B?bFR4MXBmS1BNZnlyOGNsODVZNTB1R1k4bGdhY2tSK1A0SG9OYUhWZ1FyRTBE?=
 =?utf-8?B?N010QkI5aGo5czBjZ1ZMTFMvc2kzVmlIbHVwTTdxVEdYRWRYY1VBYmgrSGVS?=
 =?utf-8?B?d2ZWakRqZ1ZHQzFBYzRoOGRqZGZqcnVZS3RabHBBcEFsbWJiQlg5M0tZYVBO?=
 =?utf-8?B?cW5DWTducHBFWjVxb0ZTNXBybDI3cUdCN2dQQytnNnlwamRVdHFaQUhSaHV0?=
 =?utf-8?B?bUI3akQ0dzU5akd1NE5nUjgzVkVHRm8yYU5ZditERUZ4Zm5VTjRSS0dIMmJE?=
 =?utf-8?B?UmRsQzFsY3htWHdBTDFEV3c1WVBvdlFWQWxrQWU5V3k3Q2JKcWl4NzFhVGJ5?=
 =?utf-8?B?Q0pzZFJLY1RTV2dwTndUT0xmdUZqUzRwcUFKUE5PamRDV0FJNWNLRDBSMDc3?=
 =?utf-8?B?c085MlJuRnVCYWpIajcxU08rYitncE5wc3pLOWhYZkV1OGg1QWhSRE56SXp0?=
 =?utf-8?B?bFdVUnNKYW1sSXJRNnVFMm1DZlJKdHhLcnV4cWpWbFlMcGdKUm9sQzgrT1Np?=
 =?utf-8?B?NnQxdGczdklhS0JMR1k3ZTVwV3ZxK1VMVXJKZjk5NmRnSStUM0t2aXk4TnFB?=
 =?utf-8?B?N2JjY3V2RlFEaHovY3VrMDl4KzYydk52bFlUNHRQMTlTTisxYWtYTHZCU3dL?=
 =?utf-8?B?L3VPMXFmckFDTG9ZMWtIU0o4OXFTL0JWbTNDNE5LdnhPL2JUVXl5YWFNVmNx?=
 =?utf-8?B?M3NoL05nQ2c3TWJSb1VUZXlqaUVUSiszL3FNR0FuOFBka3p6VDk4THd3dzkr?=
 =?utf-8?B?bTM5dm0wSmhVYkdJMUVnVkN6WS9UZmJncmgzWE9UcWNTNzBYbWNwdUZySzJP?=
 =?utf-8?B?ejBXK3k5dURtS1ZUb0ZpSCsvRTRIUXBsUjRaM2lQcjhhdks1RUM5RUplbDlY?=
 =?utf-8?B?V1ZCcW9aMmJjekcveHU4cGNlWFVqbUg0WFlDT0djVTZ4OEtiWllScXJmK0pI?=
 =?utf-8?B?L0VpVXR6MDIrMVQzWlM1Qzl1UnhzdEdZMDlyTklSRzk1VHFrMVpRejlPeXJu?=
 =?utf-8?B?RWpMUXNNMGp3VG9LNzNBV29KYkd2WWliMGlKWExMbExnSHF3dHFXaGg1dkta?=
 =?utf-8?B?eUUvZDhyZmhyNDdkVEE4Sk5iR1ZnNVNUaEVOVWlZOUl0RkphcGxDRUIxeVNa?=
 =?utf-8?B?Qnd2eGt1d2Ztbzdvc3VmeHlmRFQxbStXWm5ZNnFEaHNtSWpRWmZWbnVEbndM?=
 =?utf-8?B?YTFHWDFuSVVKSW8yK2toUG1aTFN2ekxMc0pQVmNvNjB6YllpRWZ3UkZRTVBn?=
 =?utf-8?B?cGZZQS9iVm9IMUp1cWluVXNpMzNMWVhQbzVTQnZLUWNVZFdoQUpLZ2FVVThx?=
 =?utf-8?B?aHB4WmRpU01aNGRjc1A5aHAxdXFXcnZtRnRvSzhsSUdzckhRU2xvUDA1RDlz?=
 =?utf-8?B?c3RsMW10bjdJYWtiZGdiV1d3bUpTMXlNcFhxSGhQUUU2eEQ3QTZDcnQ1ZkMv?=
 =?utf-8?B?ckZLNHppWDJuaTlkT2FUSDJrUkI3b3A5MFJDT0pDL0tkT3Rkck1JeE9yS3Yv?=
 =?utf-8?B?M1JVNk5kV054T01rNGI2TDczS3VONHYyeDN4VXFvZHlyWk1WMXl0dG9BWHhG?=
 =?utf-8?B?UzJJRldyODFjZE5IckRtOSt2SGZPZ2VXTVB3cXNldW9WcVQwYitVODcwRDFt?=
 =?utf-8?B?QmNrKzM5ZUI0ZGVWemdqcnFaZzU0RFZPMGswcGZ2N0t6TnJ4SjllS0owU2R4?=
 =?utf-8?B?NFpDNko2UzkwUmxXcnd5ZUlxak01bFgrT3kwS2JiNnJMWlJzVlhzVXZuSmF0?=
 =?utf-8?B?U2wxL2FlaXlYVHUyNkFTbDRocWh6bkRRSXk1amhnKzlFcURtQi91akVVOTV0?=
 =?utf-8?Q?nBW3Xox9BbpE00lyx/szwsxV1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5807.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d3ed4eac-0bbd-4eca-0e99-08da6bdfcee3
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Jul 2022 12:43:41.8743
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Ns8nxq5eUK40QQxxX0NSteTtKaMnP9T0viUj4Tsz3HvHcNkNNTslr6eQAFNS9b4bmVH6PjSkPPoPR0tOsImsxQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS1PR04MB9503
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
LmFuZGVyc29uQHNlY28uY29tPg0KPiBTZW50OiBUaHVyc2RheSwgSnVseSAyMSwgMjAyMiAxODoz
OA0KPiBUbzogQ2FtZWxpYSBBbGV4YW5kcmEgR3JvemEgPGNhbWVsaWEuZ3JvemFAbnhwLmNvbT47
IERhdmlkIFMgLiBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNr
aSA8a3ViYUBrZXJuZWwub3JnPjsgTWFkYWxpbiBCdWN1cg0KPiA8bWFkYWxpbi5idWN1ckBueHAu
Y29tPjsgbmV0ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBDYzogUGFvbG8gQWJlbmkgPHBhYmVuaUBy
ZWRoYXQuY29tPjsgRXJpYyBEdW1hemV0DQo+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgbGludXgt
YXJtLWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBSdXNzZWxsDQo+IEtpbmcgPGxpbnV4QGFy
bWxpbnV4Lm9yZy51az47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmcNCj4gU3ViamVjdDog
UmU6IFtQQVRDSCBuZXQtbmV4dCB2MyAzOS80N10gbmV0OiBmbWFuOiBtZW1hYzogQWRkIHNlcmRl
cw0KPiBzdXBwb3J0DQo+IA0KPiANCj4gDQo+IE9uIDcvMjEvMjIgOTozMCBBTSwgQ2FtZWxpYSBB
bGV4YW5kcmEgR3JvemEgd3JvdGU6DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
ID4+IEZyb206IFNlYW4gQW5kZXJzb24gPHNlYW4uYW5kZXJzb25Ac2Vjby5jb20+DQo+ID4+IFNl
bnQ6IFNhdHVyZGF5LCBKdWx5IDE2LCAyMDIyIDE6MDANCj4gPj4gVG86IERhdmlkIFMgLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraQ0KPiA+PiA8a3ViYUBrZXJu
ZWwub3JnPjsgTWFkYWxpbiBCdWN1ciA8bWFkYWxpbi5idWN1ckBueHAuY29tPjsNCj4gPj4gbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiA+PiBDYzogUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQu
Y29tPjsgRXJpYyBEdW1hemV0DQo+ID4+IDxlZHVtYXpldEBnb29nbGUuY29tPjsgbGludXgtYXJt
LWtlcm5lbEBsaXN0cy5pbmZyYWRlYWQub3JnOyBSdXNzZWxsDQo+ID4+IEtpbmcgPGxpbnV4QGFy
bWxpbnV4Lm9yZy51az47IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IFNlYW4NCj4gQW5k
ZXJzb24NCj4gPj4gPHNlYW4uYW5kZXJzb25Ac2Vjby5jb20+DQo+ID4+IFN1YmplY3Q6IFtQQVRD
SCBuZXQtbmV4dCB2MyAzOS80N10gbmV0OiBmbWFuOiBtZW1hYzogQWRkIHNlcmRlcw0KPiBzdXBw
b3J0DQo+ID4+DQo+ID4+IFRoaXMgYWRkcyBzdXBwb3J0IGZvciB1c2luZyBhIHNlcmRlcyB3aGlj
aCBoYXMgdG8gYmUgY29uZmlndXJlZC4gVGhpcyBpcw0KPiA+PiBwcmltYXJseSBpbiBwcmVwYXJh
dGlvbiBmb3IgdGhlIG5leHQgY29tbWl0LCB3aGljaCB3aWxsIHRoZW4gY2hhbmdlIHRoZQ0KPiA+
PiBzZXJkZXMgbW9kZSBkeW5hbWljYWxseS4NCj4gPj4NCj4gPj4gU2lnbmVkLW9mZi1ieTogU2Vh
biBBbmRlcnNvbiA8c2Vhbi5hbmRlcnNvbkBzZWNvLmNvbT4NCj4gPj4gLS0tDQo+ID4+DQo+ID4+
IChubyBjaGFuZ2VzIHNpbmNlIHYxKQ0KPiA+Pg0KPiA+PiAgLi4uL25ldC9ldGhlcm5ldC9mcmVl
c2NhbGUvZm1hbi9mbWFuX21lbWFjLmMgIHwgNDgNCj4gPj4gKysrKysrKysrKysrKysrKysrLQ0K
PiA+PiAgMSBmaWxlIGNoYW5nZWQsIDQ2IGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZm1h
bi9mbWFuX21lbWFjLmMNCj4gPj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZm1h
bi9mbWFuX21lbWFjLmMNCj4gPj4gaW5kZXggMDJiM2EwYTJkNWQxLi5hNjJmZTg2MGIxZDAgMTAw
NjQ0DQo+ID4+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mbWFuL2ZtYW5f
bWVtYWMuYw0KPiA+PiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZm1hbi9m
bWFuX21lbWFjLmMNCj4gPj4gQEAgLTEzLDYgKzEzLDcgQEANCj4gPj4gICNpbmNsdWRlIDxsaW51
eC9pby5oPg0KPiA+PiAgI2luY2x1ZGUgPGxpbnV4L3BoeS5oPg0KPiA+PiAgI2luY2x1ZGUgPGxp
bnV4L3BoeV9maXhlZC5oPg0KPiA+PiArI2luY2x1ZGUgPGxpbnV4L3BoeS9waHkuaD4NCj4gPj4g
ICNpbmNsdWRlIDxsaW51eC9vZl9tZGlvLmg+DQo+ID4+DQo+ID4+ICAvKiBQQ1MgcmVnaXN0ZXJz
ICovDQo+ID4+IEBAIC0zMjQsNiArMzI1LDcgQEAgc3RydWN0IGZtYW5fbWFjIHsNCj4gPj4gIAl2
b2lkICpmbTsNCj4gPj4gIAlzdHJ1Y3QgZm1hbl9yZXZfaW5mbyBmbV9yZXZfaW5mbzsNCj4gPj4g
IAlib29sIGJhc2V4X2lmOw0KPiA+PiArCXN0cnVjdCBwaHkgKnNlcmRlczsNCj4gPj4gIAlzdHJ1
Y3QgcGh5X2RldmljZSAqcGNzcGh5Ow0KPiA+PiAgCWJvb2wgYWxsbXVsdGlfZW5hYmxlZDsNCj4g
Pj4gIH07DQo+ID4+IEBAIC0xMjAzLDE3ICsxMjA1LDU1IEBAIGludCBtZW1hY19pbml0aWFsaXph
dGlvbihzdHJ1Y3QgbWFjX2RldmljZQ0KPiA+PiAqbWFjX2RldiwNCj4gPj4gIAkJfQ0KPiA+PiAg
CX0NCj4gPj4NCj4gPj4gKwltZW1hYy0+c2VyZGVzID0gZGV2bV9vZl9waHlfZ2V0KG1hY19kZXYt
PmRldiwgbWFjX25vZGUsDQo+ID4+ICJzZXJkZXMiKTsNCj4gPg0KPiA+IGRldm1fb2ZfcGh5X2dl
dCByZXR1cm5zIC1FTk9TWVMgb24gUFBDIGJ1aWxkcyBiZWNhdXNlDQo+IENPTkZJR19HRU5FUklD
X1BIWSBpc24ndA0KPiA+IGVuYWJsZWQgYnkgZGVmYXVsdC4gUGxlYXNlIGFkZCBhIGRlcGVuZGVu
Y3kuDQo+ID4NCj4gPj4gKwlpZiAoUFRSX0VSUihtZW1hYy0+c2VyZGVzKSA9PSAtRU5PREVWKSB7
DQo+IA0KPiBJIHRoaW5rIGl0IGlzIGJldHRlciB0byBhZGQgLUVOT1NZUyB0byB0aGUgY29uZGl0
aW9uIGhlcmUuIFRoYXQgd2F5LA0KPiB0aGUgcGh5IHN1YnN5c3RlbSBzdGF5cyBvcHRpb25hbC4N
Cj4gDQo+IC0tU2Vhbg0KDQpTdXJlLCBzb3VuZHMgZ29vZC4NCg0KPiA+PiArCQltZW1hYy0+c2Vy
ZGVzID0gTlVMTDsNCj4gPj4gKwl9IGVsc2UgaWYgKElTX0VSUihtZW1hYy0+c2VyZGVzKSkgew0K
PiA+PiArCQllcnIgPSBQVFJfRVJSKG1lbWFjLT5zZXJkZXMpOw0KPiA+PiArCQlkZXZfZXJyX3By
b2JlKG1hY19kZXYtPmRldiwgZXJyLCAiY291bGQgbm90IGdldA0KPiA+PiBzZXJkZXNcbiIpOw0K
PiA+PiArCQlnb3RvIF9yZXR1cm5fZm1fbWFjX2ZyZWU7DQo+ID4+ICsJfSBlbHNlIHsNCj4gPj4g
KwkJZXJyID0gcGh5X2luaXQobWVtYWMtPnNlcmRlcyk7DQo+ID4+ICsJCWlmIChlcnIpIHsNCj4g
Pj4gKwkJCWRldl9lcnJfcHJvYmUobWFjX2Rldi0+ZGV2LCBlcnIsDQo+ID4+ICsJCQkJICAgICAg
ImNvdWxkIG5vdCBpbml0aWFsaXplIHNlcmRlc1xuIik7DQo+ID4+ICsJCQlnb3RvIF9yZXR1cm5f
Zm1fbWFjX2ZyZWU7DQo+ID4+ICsJCX0NCj4gPj4gKw0KPiA+PiArCQllcnIgPSBwaHlfcG93ZXJf
b24obWVtYWMtPnNlcmRlcyk7DQo+ID4+ICsJCWlmIChlcnIpIHsNCj4gPj4gKwkJCWRldl9lcnJf
cHJvYmUobWFjX2Rldi0+ZGV2LCBlcnIsDQo+ID4+ICsJCQkJICAgICAgImNvdWxkIG5vdCBwb3dl
ciBvbiBzZXJkZXNcbiIpOw0KPiA+PiArCQkJZ290byBfcmV0dXJuX3BoeV9leGl0Ow0KPiA+PiAr
CQl9DQo+ID4+ICsNCj4gPj4gKwkJaWYgKG1lbWFjLT5waHlfaWYgPT0gUEhZX0lOVEVSRkFDRV9N
T0RFX1NHTUlJIHx8DQo+ID4+ICsJCSAgICBtZW1hYy0+cGh5X2lmID09IFBIWV9JTlRFUkZBQ0Vf
TU9ERV8xMDAwQkFTRVggfHwNCj4gPj4gKwkJICAgIG1lbWFjLT5waHlfaWYgPT0gUEhZX0lOVEVS
RkFDRV9NT0RFXzI1MDBCQVNFWCB8fA0KPiA+PiArCQkgICAgbWVtYWMtPnBoeV9pZiA9PSBQSFlf
SU5URVJGQUNFX01PREVfUVNHTUlJIHx8DQo+ID4+ICsJCSAgICBtZW1hYy0+cGh5X2lmID09IFBI
WV9JTlRFUkZBQ0VfTU9ERV9YR01JSSkgew0KPiA+PiArCQkJZXJyID0gcGh5X3NldF9tb2RlX2V4
dChtZW1hYy0+c2VyZGVzLA0KPiA+PiBQSFlfTU9ERV9FVEhFUk5FVCwNCj4gPj4gKwkJCQkJICAg
ICAgIG1lbWFjLT5waHlfaWYpOw0KPiA+PiArCQkJaWYgKGVycikgew0KPiA+PiArCQkJCWRldl9l
cnJfcHJvYmUobWFjX2Rldi0+ZGV2LCBlcnIsDQo+ID4+ICsJCQkJCSAgICAgICJjb3VsZCBub3Qg
c2V0IHNlcmRlcyBtb2RlDQo+ID4+IHRvICVzXG4iLA0KPiA+PiArCQkJCQkgICAgICBwaHlfbW9k
ZXMobWVtYWMtPnBoeV9pZikpOw0KPiA+PiArCQkJCWdvdG8gX3JldHVybl9waHlfcG93ZXJfb2Zm
Ow0KPiA+PiArCQkJfQ0KPiA+PiArCQl9DQo+ID4+ICsJfQ0KPiA+PiArDQo+ID4+ICAJaWYgKCFt
YWNfZGV2LT5waHlfbm9kZSAmJiBvZl9waHlfaXNfZml4ZWRfbGluayhtYWNfbm9kZSkpIHsNCj4g
Pj4gIAkJc3RydWN0IHBoeV9kZXZpY2UgKnBoeTsNCj4gPj4NCj4gPj4gIAkJZXJyID0gb2ZfcGh5
X3JlZ2lzdGVyX2ZpeGVkX2xpbmsobWFjX25vZGUpOw0KPiA+PiAgCQlpZiAoZXJyKQ0KPiA+PiAt
CQkJZ290byBfcmV0dXJuX2ZtX21hY19mcmVlOw0KPiA+PiArCQkJZ290byBfcmV0dXJuX3BoeV9w
b3dlcl9vZmY7DQo+ID4+DQo+ID4+ICAJCWZpeGVkX2xpbmsgPSBremFsbG9jKHNpemVvZigqZml4
ZWRfbGluayksIEdGUF9LRVJORUwpOw0KPiA+PiAgCQlpZiAoIWZpeGVkX2xpbmspIHsNCj4gPj4g
IAkJCWVyciA9IC1FTk9NRU07DQo+ID4+IC0JCQlnb3RvIF9yZXR1cm5fZm1fbWFjX2ZyZWU7DQo+
ID4+ICsJCQlnb3RvIF9yZXR1cm5fcGh5X3Bvd2VyX29mZjsNCj4gPj4gIAkJfQ0KPiA+Pg0KPiA+
PiAgCQltYWNfZGV2LT5waHlfbm9kZSA9IG9mX25vZGVfZ2V0KG1hY19ub2RlKTsNCj4gPj4gQEAg
LTEyNDIsNiArMTI4MiwxMCBAQCBpbnQgbWVtYWNfaW5pdGlhbGl6YXRpb24oc3RydWN0IG1hY19k
ZXZpY2UNCj4gPj4gKm1hY19kZXYsDQo+ID4+DQo+ID4+ICAJZ290byBfcmV0dXJuOw0KPiA+Pg0K
PiA+PiArX3JldHVybl9waHlfcG93ZXJfb2ZmOg0KPiA+PiArCXBoeV9wb3dlcl9vZmYobWVtYWMt
PnNlcmRlcyk7DQo+ID4+ICtfcmV0dXJuX3BoeV9leGl0Og0KPiA+PiArCXBoeV9leGl0KG1lbWFj
LT5zZXJkZXMpOw0KPiA+PiAgX3JldHVybl9maXhlZF9saW5rX2ZyZWU6DQo+ID4+ICAJa2ZyZWUo
Zml4ZWRfbGluayk7DQo+ID4NCj4gPiBfcmV0dXJuX2ZpeGVkX2xpbmtfZnJlZSBzaG91bGQgZXhl
Y3V0ZSBiZWZvcmUgX3JldHVybl9waHlfcG93ZXJfb2ZmDQo+IGFuZCBfcmV0dXJuX3BoeV9leGl0
DQo+ID4NCj4gPj4gIF9yZXR1cm5fZm1fbWFjX2ZyZWU6DQo+ID4+IC0tDQo+ID4+IDIuMzUuMS4x
MzIwLmdjNDUyNjk1Mzg3LmRpcnR5DQo+ID4NCg==
