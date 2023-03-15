Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C6E6BA755
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 06:49:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjCOFs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 01:48:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCOFsy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 01:48:54 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2081.outbound.protection.outlook.com [40.107.20.81])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0029122789;
        Tue, 14 Mar 2023 22:48:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BIR/rAJ0+yhH6fxnky98yhhQ8i/TeA0qWA2/TPYaVyxldzOX3zYDM6CdteuFZdy5N/ZMcnHAXJlhxmZMVw5QOAavrJUw2mNMJt7HMQQxtkLZtPxuaNe8V6asxtRALQvxvx1+r5oXBxhHQ1sB8I+eQ73+tZVjLyhsJ8hPDLlOnbXx3WXFXCbBr1POjyF5sZJgfygqtNj3A30RYbmlXr4gckECmT9g5SjMNerOopEHVHIo4rjK03SnQfRvHvFc0oLmqHWlo3+YVsARXJYn3keu4j0oyZPcGHZGFrRVqRJiwnyLr8MDydFW6spUSTw0g8XRbUIy4apdG9zYUCxzkvihZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=di0oTCBZKn/QQULM1l8dCiOqafF5ObfhRydD9o1hn18=;
 b=k69AQyGobUA75GNDiFvxbhI+C3DW3c8J7cYJuctyxmTLfd6GUIa/jBJjZPlkt341WG2REHHIJR88+5pjCRo+CO0n9MEFbDXjImf5A4Fkmehp6I8CFNDTR2BNzUucCFEAkmCgh1S2/D69KALxYhXzERii9Wa4zfUEJO7Eq/CRfn+zYSYJcWRdtZMFBOvEABdSAKV8JrDecH+zoqtNDFTikMHASwCW9GYCvnH9HrOd+KGG2FQt6wXaZQXooRj+Uq5ezs5jkm2H9M1zk8ZveG+U6DCBOK/UpQ4xZqGVicRIvCRrK8qJh72kbtVjB8ot9JypKDcZZYsSvngNzc75Hby4SA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=di0oTCBZKn/QQULM1l8dCiOqafF5ObfhRydD9o1hn18=;
 b=slWFRJA4hr6C0IYoXQkBEgE/0DOn/mv+x9eBsrsCIPVfXwaZlSecWXqqUuAK1HdM3xnJ0+Rhl4bO1r57z6hLHoU9egUFJ3OSOlgTsv7yAIrKiqLeoHLG9wVpKeHOO5s33tMvS4vUZI6AuMPTAaUBvRtIQa3b96KJCjJVzWEKJoM=
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com (2603:10a6:10:24b::13)
 by PAXPR04MB9594.eurprd04.prod.outlook.com (2603:10a6:102:23c::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 05:48:49 +0000
Received: from DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::7f2:8bc6:24d8:bb9a]) by DB9PR04MB8106.eurprd04.prod.outlook.com
 ([fe80::7f2:8bc6:24d8:bb9a%8]) with mapi id 15.20.6178.026; Wed, 15 Mar 2023
 05:48:49 +0000
From:   Wei Fang <wei.fang@nxp.com>
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
CC:     "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        Shenwei Wang <shenwei.wang@nxp.com>,
        Clark Wang <xiaoning.wang@nxp.com>,
        dl-linux-imx <linux-imx@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 3/4] fec: add FIXME to move 'mac_managed_pm' to
 probe
Thread-Topic: [PATCH net-next 3/4] fec: add FIXME to move 'mac_managed_pm' to
 probe
Thread-Index: AQHZVnb/KB/pqz+XYEihHV2b1uAXEK77VTGw
Date:   Wed, 15 Mar 2023 05:48:49 +0000
Message-ID: <DB9PR04MB8106C492FAAE4D7BE9CB731688BF9@DB9PR04MB8106.eurprd04.prod.outlook.com>
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com>
 <20230314131443.46342-4-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230314131443.46342-4-wsa+renesas@sang-engineering.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DB9PR04MB8106:EE_|PAXPR04MB9594:EE_
x-ms-office365-filtering-correlation-id: 53915ab1-703c-45e3-b32e-08db2518f325
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SjzSdnstiLGBYNUBk0yYVwaJ+1EZIMMTE9HsOY/HH5V12LDd/D6o7plIsW0SAH94TzrMT55PdZ5lLGfNmerEeVikylKP+x/XDw06pyieBN8asS0kAvnwoPZNtZl6J9hQQs11yDsnxo/VG0iowGCOpGnpgNhcs3ZlxaS9Y5TrjQg/Es/S4md04K+tHhQYejxC83KLj+lHGvcBvG/0DmrJ86t8E4iCxoarThMUiUJk1A+r3PaU2vhZHg0tcwY+Bi/Opx4cI0WtXuP3bgnxBNDsCpwBO7GDjg2+uJVgAy5k/VOMVthNDHBdWRQG9hQNrFTMEPgUC+KndNr9O96dVqjjRVYpnZmg+Iw9lVeG9n0JgHrAw85WPOQNuEXQYxYts/eogLFpjgDj5S3fuv44d/238TkJBD8y0Vx48i7nLBG5DOKMllDwHBIgDmanWrwcbNFA/woa12pBDChfArl/eLOpcm/R6w5TuVW+ZAlDpOZmwa4b1cObJcfpOOYvoWqKyB90BN66KHm44wPfnDf/1t0iNmnorbl4FvV2RQHndJ5QgYaBDjLkNmyApGvDmgxN5cEMoiTbB2urTGpx5boZX+mjZu47Os2E8503Hzi9/cQE/3PXAvNHRRumJuvC+7iTe/9I60n5rxOzx1G/BhZZCiE86h1GJysajC/dVLpamKVItjSDGyZ3WBRn2wPtivKlVbTGsd6BQUhXUj+exzAR90ry0A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB8106.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(54906003)(33656002)(316002)(55016003)(86362001)(122000001)(38070700005)(83380400001)(53546011)(9686003)(26005)(186003)(6506007)(5660300002)(52536014)(478600001)(8676002)(71200400001)(66446008)(41300700001)(38100700002)(4326008)(7696005)(8936002)(64756008)(2906002)(44832011)(66946007)(76116006)(66556008)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?Q25lbzlBTlBHMW9uZTYzUFBBYWFETFYxTVp6OUpMSUZiY0xKb21pSkROWENL?=
 =?gb2312?B?WXJZWEtyazg2ZGJuK1FQNWZwL3BuT01jc2hyMkRRYVhZOHlQRlF5d0tIbEV2?=
 =?gb2312?B?SDRXd3RVZGNyMnRRZFRjY3FIelRWeUdTNUxYaXEzdm1vRTczQzFTRW1JS3Z3?=
 =?gb2312?B?TXYwWEF5VFBwc1VMV0p3ZWIzcHV4bEFnVGJldThrb3UzTzA0MFU3bHM2L3hr?=
 =?gb2312?B?NGlMYWFIZzZidGVTQ3QxeU1wYzJXY1pGVmkyRTZERS9IcEEvSklOWnJwc2hJ?=
 =?gb2312?B?ZG82WDJ2Y3RYZkIya0Q4YzQxbXc4MmRmOFhEQ0ltWk5SbTBPUDhHUFUzVGtk?=
 =?gb2312?B?N1duTkpaOTg1TC9jbUNnQjZ4V0llTC9zN283dEd4cjRpVkt4VC8rVWZJVjVK?=
 =?gb2312?B?N3RkTGZTYnI3azk0SDFCZ0ZOR0duUTBWZVhCWEUwQXd4NTdsVFRtczlpMm83?=
 =?gb2312?B?UFZscVR0ZWp3STVSdnhGN3MrVllMNlVHTW5xaWpTZHpRN0ZYK0diMDNuczdK?=
 =?gb2312?B?UWZoLzVYb3R1R0Jzb3dKbnU4ZVkrOXExSXl5ZTVqSFJNa0tLbTZpVTJRcTRB?=
 =?gb2312?B?VmFXUGpWZUpXTDJWbkx3dytaR0hJdkFET1ExZllXSklsYW1ZNUFzOWZtZGxr?=
 =?gb2312?B?UEw3ejVtbFp2RXJ0ay96dll4N2ZkOGNTOVhHSDFuNjBYaC9PczAvb0Z2Mnlz?=
 =?gb2312?B?a0kwVytYZGg3K2ptRjIxUUxESWxZUlhDT29LNUh6aks3aVc4Zyt5TlBJcHhW?=
 =?gb2312?B?UVFaZlEzdUFmck14bEJSY3JmOU9WWEtNOWkvdFd6aVNyQ3FmeGhvdU5kK0lk?=
 =?gb2312?B?RElkc0IxQmgxWnArRWJTQlRiWS96VTg0NnV6dGtkbUZabkxGMVB5bVI4bDB1?=
 =?gb2312?B?TFFtWmR4TXhZUktqeFBDMXh5OWJZdjc5OHRKLzQwRm9VRHZyV25EcDY5L29K?=
 =?gb2312?B?TVZsV1NQUXVKVjBxZHg3V1Y4K3podjBrVnlRcmdid0ljcXl1bXBKMjJ0dUtG?=
 =?gb2312?B?Uy9zc21BVHdYeHk1TDBCRWNqUFdOSHpkdm5BcEpNUlVNM3ZIQmNlb3FGK2Zj?=
 =?gb2312?B?UFpHMTltYVg3d3QrWFZrSjhLcmorNExaM2lzSGhob1pXUDN3cmNtcnNic01p?=
 =?gb2312?B?My9xMTNPOGNMeUxwT2hLTUE1ZHIrd3U4U3hzQVVNdVZQdkI0Q2VmV21iYTJY?=
 =?gb2312?B?bTl3YXhKZkhOUWhrVUQrU2lnRmRtMGFod0U5aEVOa0hQenJ0RExOOVlrYy8v?=
 =?gb2312?B?TTkyQ1k2L0NmSGJQQTlPZHVsRzMrVVBmRW1JaDY5b2xVVTdJeXFwcHhHVWJ6?=
 =?gb2312?B?VXEvZ2JQZkJqVEZtNTAybVNWM0wzWTFRb3pTaVZ4cnVNR1NzOXFyaFJXRWNi?=
 =?gb2312?B?OWhjV0NOL3VnTC9sZnpBOXBQOUpMOXNJYzAyYkpucWxzUFhrZUdRK3BWRnpV?=
 =?gb2312?B?SHNXOHBiL2F3SEFOaFUzcXcrRVR1aC9NZFRQaldkeHdVemZSU0o5UGw0cHhE?=
 =?gb2312?B?aXlQZEV2bEI3cEpFQXMwQU9GelV4cExyeGY0c3V1V3N0SmJoOTJhdGlxbEFn?=
 =?gb2312?B?V2szbDNML3NSZGxzbEg2MDFQbW5NZ1QyVmQxeWp5dFNERGFyNHZteHVJQzYy?=
 =?gb2312?B?MGhLTEYwQ25TRmJUSFpOWEhIZWFwbEdXMWNLcXQrcVI0TFVaODhNTUpTN0Nj?=
 =?gb2312?B?UUoveXpGM2ZJV1IvUkJYbXRjMXVQVU5oUFEvejNjUXNsWFBIenBoL1F3NDMy?=
 =?gb2312?B?aHVBNUdWT1NkeGV3MWhtTlFubzNFRWg1NmoxOFVqZVVqS2dsYzFoNzd3bnI4?=
 =?gb2312?B?ZmVFdkhibEZ3aUNzVW9tOG5UblJzTkl2d2E0Z3VPTWkrcUF2WVAyNHpIczFZ?=
 =?gb2312?B?TTE5c1FJMHhldlcxZnVTRlhBQlZVUFQzeWhXVktoNHV6SWpMQmRwYmdjQ3d5?=
 =?gb2312?B?WjFXaTNHbHFXbk1idjhsWlNCVjN4ZEFuTDN5WktUWXh6azA2SXRHbmxBQzZL?=
 =?gb2312?B?SzhCNTcxczZDMFFMVElITGY1dXdTVHY1OVppYmxGUzZndmp4emxteDI4R2Zv?=
 =?gb2312?B?cXNDRDJJUzlNZURmeERxdWNIWlFkME5KeU5uVGZmMUVJTkJtdVJkR01WeWsr?=
 =?gb2312?Q?7D3Q=3D?=
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB8106.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53915ab1-703c-45e3-b32e-08db2518f325
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Mar 2023 05:48:49.1053
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nc7ZAx9Njrf7TDfK1uvpcGWKdlLudV7MGeLFrMN3///465IH4cm+UpQC87Js18hKQeSjbpXi17FG7z4te1JyIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PAXPR04MB9594
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gV29sZnJhbSwNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBX
b2xmcmFtIFNhbmcgPHdzYStyZW5lc2FzQHNhbmctZW5naW5lZXJpbmcuY29tPg0KPiBTZW50OiAy
MDIzxOoz1MIxNMjVIDIxOjE1DQo+IFRvOiBuZXRkZXZAdmdlci5rZXJuZWwub3JnDQo+IENjOiBs
aW51eC1yZW5lc2FzLXNvY0B2Z2VyLmtlcm5lbC5vcmc7IGtlcm5lbEBwZW5ndXRyb25peC5kZTsg
V29sZnJhbSBTYW5nDQo+IDx3c2ErcmVuZXNhc0BzYW5nLWVuZ2luZWVyaW5nLmNvbT47IFdlaSBG
YW5nIDx3ZWkuZmFuZ0BueHAuY29tPjsNCj4gU2hlbndlaSBXYW5nIDxzaGVud2VpLndhbmdAbnhw
LmNvbT47IENsYXJrIFdhbmcNCj4gPHhpYW9uaW5nLndhbmdAbnhwLmNvbT47IGRsLWxpbnV4LWlt
eCA8bGludXgtaW14QG54cC5jb20+OyBEYXZpZCBTLg0KPiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBFcmljIER1bWF6ZXQgPGVkdW1hemV0QGdvb2dsZS5jb20+Ow0KPiBKYWt1YiBLaWNp
bnNraSA8a3ViYUBrZXJuZWwub3JnPjsgUGFvbG8gQWJlbmkgPHBhYmVuaUByZWRoYXQuY29tPjsN
Cj4gbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBbUEFUQ0ggbmV0LW5l
eHQgMy80XSBmZWM6IGFkZCBGSVhNRSB0byBtb3ZlICdtYWNfbWFuYWdlZF9wbScgdG8NCj4gcHJv
YmUNCj4gDQo+IE9uIFJlbmVzYXMgaGFyZHdhcmUsIHdlIGhhZCBpc3N1ZXMgYmVjYXVzZSB0aGUg
YWJvdmUgZmxhZyB3YXMgc2V0IGR1cmluZw0KPiAnb3BlbicuIEl0IHdhcyBjb25jbHVkZWQgdGhh
dCBpdCBuZWVkcyB0byBiZSBzZXQgZHVyaW5nICdwcm9iZScuIEl0IGxvb2tzIGxpa2UgRkVDDQo+
IG5lZWRzIHRoZSBzYW1lIGZpeCBidXQgSSBjYW4ndCB0ZXN0IGl0IGJlY2F1c2UgSSBkb24ndCBo
YXZlIHRoZSBoYXJkd2FyZS4gQXQNCj4gbGVhc3QsIGxlYXZlIGEgbm90ZSBhYm91dCB0aGUgaXNz
dWUuDQo+IA0KDQpDb3VsZCB5b3UgZGVzY3JpYmUgdGhpcyBpc3N1ZSBpbiBtb3JlIGRldGFpbHM/
IFNvIHRoYXQgSSBjYW4gcmVwcm9kdWNlIGFuZCBmaXggdGhpcw0KaXNzdWUgYW5kIHRlc3QgaXQu
IFRoYW5rcyENCg0KPiBTaWduZWQtb2ZmLWJ5OiBXb2xmcmFtIFNhbmcgPHdzYStyZW5lc2FzQHNh
bmctZW5naW5lZXJpbmcuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVz
Y2FsZS9mZWNfbWFpbi5jIHwgMSArDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKykN
Cj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21h
aW4uYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+IGlu
ZGV4IGM3M2UyNWY4OTk1ZS4uYjE2ZjU2MjA4ZDY2IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZmVjX21haW4uYw0KPiBAQCAtMjMxOCw2ICsyMzE4LDcgQEAgc3RhdGlj
IGludCBmZWNfZW5ldF9taWlfcHJvYmUoc3RydWN0IG5ldF9kZXZpY2UNCj4gKm5kZXYpDQo+ICAJ
ZmVwLT5saW5rID0gMDsNCj4gIAlmZXAtPmZ1bGxfZHVwbGV4ID0gMDsNCj4gDQo+ICsJLyogRklY
TUU6IHNob3VsZCBiZSBzZXQgcmlnaHQgYWZ0ZXIgbWRpb2J1cyBpcyByZWdpc3RlcmVkICovDQo+
ICAJcGh5X2Rldi0+bWFjX21hbmFnZWRfcG0gPSB0cnVlOw0KPiANCj4gIAlwaHlfYXR0YWNoZWRf
aW5mbyhwaHlfZGV2KTsNCj4gLS0NCj4gMi4zMC4yDQoNCg==
