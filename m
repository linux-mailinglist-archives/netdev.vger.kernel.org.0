Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C90206B1AF8
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 06:49:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCIFt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 00:49:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCIFt0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 00:49:26 -0500
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A4D48F731;
        Wed,  8 Mar 2023 21:49:22 -0800 (PST)
X-UUID: 1efa5b2cbe3e11ed945fc101203acc17-20230309
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=mediatek.com; s=dk;
        h=MIME-Version:Content-Transfer-Encoding:Content-ID:Content-Type:In-Reply-To:References:Message-ID:Date:Subject:CC:To:From; bh=DXIg+I3oFu1zjYAdMaitVvgXPJ9O/ef6or13ex83zqE=;
        b=jbmgft2u/N74r9hFdSgvRn3zK7h9UaPfSBIPC/r/GBJNMjkBqTXbIb9vfix+FX39R6r0rk4pkJTktxQofsp8gTBJuOLmY1r7YrsRHMSnS+pWJrpb3Hi0Bycv8OHeyBiZmST7JmDZIxRG0cctBPbNWTIDWsK4V0e4yM1WHetG6aw=;
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.20,REQID:afa9d928-9b6c-47ad-a30b-0003434bfdff,IP:0,U
        RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
        release,TS:0
X-CID-META: VersionHash:25b5999,CLOUDID:0062b0b2-beed-4dfc-bd9c-e1b22fa6ccc4,B
        ulkID:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0
X-CID-BVR: 0
X-UUID: 1efa5b2cbe3e11ed945fc101203acc17-20230309
Received: from mtkmbs13n2.mediatek.inc [(172.21.101.108)] by mailgw02.mediatek.com
        (envelope-from <garmin.chang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 759253866; Thu, 09 Mar 2023 13:49:13 +0800
Received: from mtkmbs10n2.mediatek.inc (172.21.101.183) by
 mtkmbs13n2.mediatek.inc (172.21.101.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.25; Thu, 9 Mar 2023 13:49:11 +0800
Received: from APC01-PSA-obe.outbound.protection.outlook.com (172.21.101.239)
 by mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server id
 15.2.1118.25 via Frontend Transport; Thu, 9 Mar 2023 13:49:11 +0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IWD3T6W5lcEnbNPfU21+WdUbf/GxoSUU/tRXofKtnMWbPMQUaYvHjN6saaZ+0FWo1AuzyiPmKCMQ/t2+HdOtI0j268gTgMHn1NF6AZEvHPxBbqzwbOYbcBTprJ5KHg/MTztlienrkJ5GifdjLgi6xFREy1dedyPHaIuseXfahjF0e+qvJciJm0SU5llf5U4ztGo+r0cvJmJMGnR/Gs4duWbUZrRIbW5kitOaRY/4KtYlxt7KWn2G8dhwTyhLXqqSYvn9H3YyoIlX2uhG4L4yZhUcANLoiLzwE+vg7Rd8nWTiYYyndh3QgROYcGf94oi5VZ+oR76vdlYTeHmcwG67Lw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DXIg+I3oFu1zjYAdMaitVvgXPJ9O/ef6or13ex83zqE=;
 b=V0fqcyVNAAfudRoEeOpG2jsT4EjYjDPPvKZAFvJPeZeiUI4XhddjziuDMFDy/2Jp3zb++ChqeGmw+dzBpRNlynuR+egh/h4M7vF8ECXHZN5eZmZ1tIe+0Z2Jrczh/+KdWxQ/XhMYudtpEBxLXUjrzB7sA6GelcSJKp310Sa7OMzyAEZ2pdJ7bHRO3BhtIAXKsmaoFNYEQlZ7hxbCpWvO6nK67Muvj18i/2fIlJS47EifZ03aYPhPloIQIdzRAiWYTgHZRjULSlVhzSZwDLtIqKNRHhWvZoGXMVewmwg9v6EiUfzb9wpBqgU+VZV0EN+RtahomYn+auxXJB8HHG5otg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mediatek.com; dmarc=pass action=none header.from=mediatek.com;
 dkim=pass header.d=mediatek.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mediateko365.onmicrosoft.com; s=selector2-mediateko365-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DXIg+I3oFu1zjYAdMaitVvgXPJ9O/ef6or13ex83zqE=;
 b=TgjJD5xEIAGHajmLJhXkFXb+9CdCW08Tiv6hdwGIArGoliPqxdauNlXlPUrLWtXw2aOUDlfg3zv9HFvcY4zbyCqiN4Nt279sgLfYls2eAREWR1koqS+GPBtbPFQaTzFFicl+s9LiJkfYgyNCHk8X9ba6QdJdxhPVnm0y0sSSvgg=
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com (2603:1096:301:a5::6)
 by SI2PR03MB5195.apcprd03.prod.outlook.com (2603:1096:4:108::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Thu, 9 Mar
 2023 05:49:08 +0000
Received: from PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa]) by PUZPR03MB5877.apcprd03.prod.outlook.com
 ([fe80::cd32:5baf:ebd0:3eaa%8]) with mapi id 15.20.6178.018; Thu, 9 Mar 2023
 05:49:08 +0000
From:   =?utf-8?B?R2FybWluIENoYW5nICjlvLXlrrbpipgp?= 
        <Garmin.Chang@mediatek.com>
To:     "wenst@chromium.org" <wenst@chromium.org>,
        "angelogioacchino.delregno@collabora.com" 
        <angelogioacchino.delregno@collabora.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        "mturquette@baylibre.com" <mturquette@baylibre.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "sboyd@kernel.org" <sboyd@kernel.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>,
        Project_Global_Chrome_Upstream_Group 
        <Project_Global_Chrome_Upstream_Group@mediatek.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "krzysztof.kozlowski+dt@linaro.org" 
        <krzysztof.kozlowski+dt@linaro.org>,
        "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
        "linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v5 12/19] clk: mediatek: Add MT8188 vdosys0 clock support
Thread-Topic: [PATCH v5 12/19] clk: mediatek: Add MT8188 vdosys0 clock support
Thread-Index: AQHZLAR2rWST28FWtkaz2oaSNryUuK6858SAgAA6fICANRtwgA==
Date:   Thu, 9 Mar 2023 05:49:08 +0000
Message-ID: <329042ba313a93a389df5c69b1750f88cc26b9d4.camel@mediatek.com>
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com>
         <20230119124848.26364-13-Garmin.Chang@mediatek.com>
         <CAGXv+5Fysy4iCvHEXWtf5oXCHkaKezPqcrGd8QzhnaTrYdyecA@mail.gmail.com>
         <76f33f1f-53ab-65a9-f6e8-23db4ca0e0b5@collabora.com>
In-Reply-To: <76f33f1f-53ab-65a9-f6e8-23db4ca0e0b5@collabora.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=mediatek.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PUZPR03MB5877:EE_|SI2PR03MB5195:EE_
x-ms-office365-filtering-correlation-id: 82efe972-2f86-4856-2c0f-08db20620035
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yN7V9M/jT9hBdwpvr3X/CfeYucT3mSGKnBsMsQoxZMcehTz0HA3h1HXyBJy+L41Rlz05RoBLQEfejuIzUU2oFU8abaIEuUGAtVwXTpmGGkHPcxJyNctUjD3QaDhu5hQhKltOw6PWgvzBTsP9BSaU09t8U/NMy0YwU1BwApSWfKCpPgbnzeSKrbErwtcJ/dbnJXiFBi+ZsVa0HHeO7oMv71FE++8uhkF+bXHJ/3kOzSBlhPOqBc5gxEVX6MxCjnaGX7WLKUncMv+s4B7oTTzgUkXOlkk2wYGeddjYzwDoNWXf2qOTan2BODgEXG2SwJ9ejUCDtMfpl/zCk4iXU4ISQIxasvhGF+mvGVXfjF4fAp2WcDRSlqqKJQqaaWTP020b2j4d6ucww2dHuWJr6Iz1JrD1/wVNNNkzO+ZQzJBHG9xlEcOuUvpz1qBb6jPLjXWg1G2PL0+uW6WOI5nAMUcMu+5FQFlZhJggszerpn3UbK59BLqhJoPbLthUVnhihJEJVqDrOdbh7CjW7W0k1P1TMq+YiCgDSB3N/e+2jl5MFJDslU0q7FvmmwUTSHQE2lM2Iu3e5JrGys+8PokxYz9Gi1PnUpY6CbrkNPN/UYToBhpvSpKzavCgiwWjQ0nvUwaF6TSsR5NuwQPM9ApTVanH2jHzF2b9EJuHQfyMSvuhh1IvDDNHYdycmcbgtSrF1A9WL/30fNHLWFFR5buaD9b9nkNJYbheFsM872/c+Hw53E/wqvlOjdIyV9QQA5gIcMhW
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PUZPR03MB5877.apcprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(396003)(346002)(366004)(376002)(39860400002)(451199018)(110136005)(54906003)(36756003)(85182001)(38070700005)(38100700002)(86362001)(122000001)(6512007)(6506007)(26005)(53546011)(83380400001)(186003)(2616005)(316002)(71200400001)(7416002)(5660300002)(478600001)(6486002)(41300700001)(4326008)(2906002)(8936002)(66556008)(66446008)(64756008)(8676002)(76116006)(66946007)(66476007)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?L2xUWE5UU1hHSnVIbFk3dEJzaHllaTJ5QlE1endrMk9wNW9KMldFdHNyeEhh?=
 =?utf-8?B?WjB2dVpCeUYzWlFXYzBuWk5Rb1Vjajd2Z1YwdEltQUJvVGVtc3ljd2FxTlhq?=
 =?utf-8?B?VGxGUWlMYnQvYmtTbE84QXF1UzZkZ2ZxN0lpRTJ4U2loV1lIMzR2aWFMTGo4?=
 =?utf-8?B?S3hmV010d2ZOS2EyaStKeFFkOXR2L05UTmZCR0d0YWxvNVI0SGc2aEZjb3RP?=
 =?utf-8?B?ODVlRE1lM1NkQTBNZlJNdXBBNFVXZHphank4ZHg1WU00OEQwaWpyUXhPcFVu?=
 =?utf-8?B?c2s5R0ttaHMvemF0NCtHSUpIKzJnZm5YOWFCb2d6S2FvMGdIUW5nZGJuRXly?=
 =?utf-8?B?V1R2VHJvbmZtNmk4MFNMVDhiOGVPTWFnTkpnSHJIeVZtRWNvNy92OVFFQ2dX?=
 =?utf-8?B?aUg5VDlEaFRtdEN6SWxjclZzbzNIc3kwN0p0cE0wdFA5aFVtSFhwaUxidlBy?=
 =?utf-8?B?UG1tazFpKzFBY0ROc2U1UXlIRDBFdElJMXRRcUtPNVdaaHpyOVh3TFVWZytX?=
 =?utf-8?B?NmdpTEtNRkRjSTA2a2xyWXg2dWZwYjJkNlY0Z3VGanpjcVRpQWJJWFZrTU14?=
 =?utf-8?B?OWNteThnUmV5ckN4U2NmQTJWcmtoQ1ZYNUlmVEQ0dnpaME5LbVRuMkp6ZjM1?=
 =?utf-8?B?ZWhpRkdHTzlJVnduQ3lDQkVreVhsYXdrQ1k4QWJlU2VDOEphNG9MZjJyVm54?=
 =?utf-8?B?WjhGaFcyeEJsMlpZT29QSkpXOVF6b0V5Z0huYXVIdjZldW1yQ05LTldpWWdS?=
 =?utf-8?B?bndqZm9DY1FVQzRDNlRlbGt4dmN2TjIyVk80T05IZTlwSnFHdkZ0TXliMjNJ?=
 =?utf-8?B?cXdmZ1hWSFlhaDdWeWYzMlo5elJLckRzT0NkYUJ2ekFpZ3Fnblk3Tk5ZYllu?=
 =?utf-8?B?QTBqSjVoZ0lGenVockxiQU90QlVvU1QreVhQaTdWUGJia2J3ZlFnZThxSjBp?=
 =?utf-8?B?ZFRKYUxXb1NZM3B0M1M1enJvYTVHTTRLNFIxdTRGcVJPNXhZblFBdHlvek5C?=
 =?utf-8?B?SGxQUjh6a0JRTmwrMmltcjM5cnR6Z2pscHl5ekNtdzB6aWl4NzRMOHhXcmxv?=
 =?utf-8?B?TFY5Q0dhVURRaXZyUWZTSUx3V0NCV3VmVGE4WjRUY2hvQzVCQWZTNTlrcFRa?=
 =?utf-8?B?N3QzUHg0dHdXc3dHblh4L2RoWS9qN29oQnlrcnM1NkFqbmxaVWY1K2Q1S2tY?=
 =?utf-8?B?S2ZDRW1PSGtqd05IMlZCYlVVVUhxeUdqdTVxSW15T3BSa21Sc0ptMXNzRVAy?=
 =?utf-8?B?aG9rTi9LWEJYeDVvWUd5V1pibGlIRGN6UzhBT0JlMHNPQmtpbU5GbGNZRTc0?=
 =?utf-8?B?UE52YyszTHNvNlhUTUJ5VnZkdWlyazhYNHR4L3dEd04wWngvUng3TG1zcVNO?=
 =?utf-8?B?UDBqRHpFRGNxMXVJZ0ZKTHQ2bmZkK25rMDZ3OVB0VGZqRDlwbTJUK1VWekY2?=
 =?utf-8?B?UDhYak5GdVRPNFFMR3ZYRWxKOEozOXVDMGE0ZWxxZnNZSy9vYmp1ekFmcEFH?=
 =?utf-8?B?WktDYkhlcER6ZW0wMUdxNWt4YTRJR0Y5MDcvS1dDc2NLYzFLZUpqTU43THhF?=
 =?utf-8?B?dHJhREFCMHA3c3NOaytQcm5lc1U1TmRvci9RNWM3V3VoUVNVMDFiOTJWWVVK?=
 =?utf-8?B?TGc2bDdxZituMTNHcUdZclV4REliT2FOVXhMS24zdVZVTk1pVTJGVW9RUWJV?=
 =?utf-8?B?a2l5cFoxLzlOSFl1U2hXbGwvTXlBN3hpdFc0RUZTQzZicUZJMUtCb2QxS2l5?=
 =?utf-8?B?MFFIRnBxNXBCaDJaeG5pUTRuU0FoTGU1aG91Qy9QZUQyRnJhVDd6eFVjbUFX?=
 =?utf-8?B?TFRybFQ5MWwvRnl0WmpkdDlEbm9vRUp1cHNDeENOTnFRTUxQdlkxbWluZ2Nu?=
 =?utf-8?B?cWdRSExQSytoTTlSUTlnTnV0SDdTZ0M1Wi9naWdsUkJuVE9SNWxPNm90c2lx?=
 =?utf-8?B?OHpJOGRlWUJYWEZRa2dta212Q2RmTCtveUVYaDJ3cjlwOXZheWxIa2Zvbndy?=
 =?utf-8?B?ZXA2QXdQUmtxOEZzcGNuSlpYY2g2T2tBb3l0TWRZd25hRTJNQnBFR0RkYlYv?=
 =?utf-8?B?aXVtMlBOV0thNm1ETXpRQTVsaDBjRStOaDZUbGZtbEV6NnVxeitWZkpiUWxC?=
 =?utf-8?B?WVRKRFV2RnBPdExTL0thNlRMT3dNU0ltSHpZLzJody8zUWtYRTE2REJEVTFC?=
 =?utf-8?Q?zLxru5QgOBOsCYhwmKovLJQ=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <082F044A4CBCAB4AB6409222CF09CD4F@apcprd03.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PUZPR03MB5877.apcprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 82efe972-2f86-4856-2c0f-08db20620035
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2023 05:49:08.5113
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a7687ede-7a6b-4ef6-bace-642f677fbe31
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ccOX4wmdcDMKxa3Oxk+OMK2RHbH0MOcKJL1HBfMttUFNV6bKYjCCPWIt5WQxNzKw0aPIw8WNQ2JGwm6IIt4IKOW6d4aejOD1zjkzkVNaZ9w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SI2PR03MB5195
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_PASS,UNPARSEABLE_RELAY autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIzLTAyLTAzIGF0IDExOjQ5ICswMTAwLCBBbmdlbG9HaW9hY2NoaW5vIERlbCBS
ZWdubyB3cm90ZToNCj4gSWwgMDMvMDIvMjMgMDg6MTksIENoZW4tWXUgVHNhaSBoYSBzY3JpdHRv
Og0KPiA+IE9uIFRodSwgSmFuIDE5LCAyMDIzIGF0IDg6NTQgUE0gR2FybWluLkNoYW5nIDwNCj4g
PiBHYXJtaW4uQ2hhbmdAbWVkaWF0ZWsuY29tPiB3cm90ZToNCj4gPiA+IA0KPiA+ID4gQWRkIE1U
ODE4OCB2ZG9zeXMwIGNsb2NrIGNvbnRyb2xsZXIgd2hpY2ggcHJvdmlkZXMgY2xvY2sgZ2F0ZQ0K
PiA+ID4gY29udHJvbCBpbiB2aWRlbyBzeXN0ZW0uIFRoaXMgaXMgaW50ZWdyYXRlZCB3aXRoIG10
ay1tbXN5cw0KPiA+ID4gZHJpdmVyIHdoaWNoIHdpbGwgcG9wdWxhdGUgZGV2aWNlIGJ5DQo+ID4g
PiBwbGF0Zm9ybV9kZXZpY2VfcmVnaXN0ZXJfZGF0YQ0KPiA+ID4gdG8gc3RhcnQgdmRvc3lzIGNs
b2NrIGRyaXZlci4NCj4gPiA+IA0KPiA+ID4gU2lnbmVkLW9mZi1ieTogR2FybWluLkNoYW5nIDxH
YXJtaW4uQ2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+ID4gLS0tDQo+ID4gPiAgIGRyaXZlcnMvY2xr
L21lZGlhdGVrL01ha2VmaWxlICAgICAgICAgIHwgICAzICstDQo+ID4gPiAgIGRyaXZlcnMvY2xr
L21lZGlhdGVrL2Nsay1tdDgxODgtdmRvMC5jIHwgMTM0DQo+ID4gPiArKysrKysrKysrKysrKysr
KysrKysrKysrDQo+ID4gPiAgIDIgZmlsZXMgY2hhbmdlZCwgMTM2IGluc2VydGlvbnMoKyksIDEg
ZGVsZXRpb24oLSkNCj4gPiA+ICAgY3JlYXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvY2xrL21lZGlh
dGVrL2Nsay1tdDgxODgtdmRvMC5jDQo+ID4gPiANCj4gPiA+IGRpZmYgLS1naXQgYS9kcml2ZXJz
L2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+ID4gYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtl
ZmlsZQ0KPiA+ID4gaW5kZXggN2QwOWU5ZmM2NTM4Li5kZjc4YzA3NzdmZWYgMTAwNjQ0DQo+ID4g
PiAtLS0gYS9kcml2ZXJzL2Nsay9tZWRpYXRlay9NYWtlZmlsZQ0KPiA+ID4gKysrIGIvZHJpdmVy
cy9jbGsvbWVkaWF0ZWsvTWFrZWZpbGUNCj4gPiA+IEBAIC04Niw3ICs4Niw4IEBAIG9iai0kKENP
TkZJR19DT01NT05fQ0xLX01UODE4NikgKz0gY2xrLW10ODE4Ni0NCj4gPiA+IG1jdS5vIGNsay1t
dDgxODYtdG9wY2tnZW4ubyBjbGstbXQNCj4gPiA+ICAgb2JqLSQoQ09ORklHX0NPTU1PTl9DTEtf
TVQ4MTg4KSArPSBjbGstbXQ4MTg4LWFwbWl4ZWRzeXMubyBjbGstDQo+ID4gPiBtdDgxODgtdG9w
Y2tnZW4ubyBcDQo+ID4gPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGst
bXQ4MTg4LXBlcmlfYW8ubyBjbGstDQo+ID4gPiBtdDgxODgtaW5mcmFfYW8ubyBcDQo+ID4gPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBjbGstbXQ4MTg4LWNhbS5vIGNsay1t
dDgxODgtDQo+ID4gPiBjY3UubyBjbGstbXQ4MTg4LWltZy5vIFwNCj4gPiA+IC0gICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgY2xrLW10ODE4OC1pcGUubyBjbGstbXQ4MTg4LQ0KPiA+
ID4gbWZnLm8gY2xrLW10ODE4OC12ZGVjLm8NCj4gPiA+ICsgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgY2xrLW10ODE4OC1pcGUubyBjbGstbXQ4MTg4LQ0KPiA+ID4gbWZnLm8gY2xr
LW10ODE4OC12ZGVjLm8gXA0KPiA+ID4gKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICBjbGstbXQ4MTg4LXZkbzAubw0KPiA+ID4gICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgx
OTIpICs9IGNsay1tdDgxOTIubw0KPiA+ID4gICBvYmotJChDT05GSUdfQ09NTU9OX0NMS19NVDgx
OTJfQVVEU1lTKSArPSBjbGstbXQ4MTkyLWF1ZC5vDQo+ID4gPiAgIG9iai0kKENPTkZJR19DT01N
T05fQ0xLX01UODE5Ml9DQU1TWVMpICs9IGNsay1tdDgxOTItY2FtLm8NCj4gPiA+IGRpZmYgLS1n
aXQgYS9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LXZkbzAuYw0KPiA+ID4gYi9kcml2
ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LXZkbzAuYw0KPiA+ID4gbmV3IGZpbGUgbW9kZSAx
MDA2NDQNCj4gPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uMzBkZDY0Mzc0YWNlDQo+ID4gPiAtLS0g
L2Rldi9udWxsDQo+ID4gPiArKysgYi9kcml2ZXJzL2Nsay9tZWRpYXRlay9jbGstbXQ4MTg4LXZk
bzAuYw0KPiA+ID4gQEAgLTAsMCArMSwxMzQgQEANCj4gPiA+ICsvLyBTUERYLUxpY2Vuc2UtSWRl
bnRpZmllcjogR1BMLTIuMC1vbmx5DQo+ID4gPiArLy8NCj4gPiA+ICsvLyBDb3B5cmlnaHQgKGMp
IDIwMjIgTWVkaWFUZWsgSW5jLg0KPiA+ID4gKy8vIEF1dGhvcjogR2FybWluIENoYW5nIDxnYXJt
aW4uY2hhbmdAbWVkaWF0ZWsuY29tPg0KPiA+ID4gKw0KPiA+ID4gKyNpbmNsdWRlIDxsaW51eC9j
bGstcHJvdmlkZXIuaD4NCj4gPiA+ICsjaW5jbHVkZSA8bGludXgvcGxhdGZvcm1fZGV2aWNlLmg+
DQo+ID4gPiArI2luY2x1ZGUgPGR0LWJpbmRpbmdzL2Nsb2NrL21lZGlhdGVrLG10ODE4OC1jbGsu
aD4NCj4gPiA+ICsNCj4gPiA+ICsjaW5jbHVkZSAiY2xrLWdhdGUuaCINCj4gPiA+ICsjaW5jbHVk
ZSAiY2xrLW10ay5oIg0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3QgbXRrX2dh
dGVfcmVncyB2ZG8wXzBfY2dfcmVncyA9IHsNCj4gPiA+ICsgICAgICAgLnNldF9vZnMgPSAweDEw
NCwNCj4gPiA+ICsgICAgICAgLmNscl9vZnMgPSAweDEwOCwNCj4gPiA+ICsgICAgICAgLnN0YV9v
ZnMgPSAweDEwMCwNCj4gPiA+ICt9Ow0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBjb25zdCBzdHJ1
Y3QgbXRrX2dhdGVfcmVncyB2ZG8wXzFfY2dfcmVncyA9IHsNCj4gPiA+ICsgICAgICAgLnNldF9v
ZnMgPSAweDExNCwNCj4gPiA+ICsgICAgICAgLmNscl9vZnMgPSAweDExOCwNCj4gPiA+ICsgICAg
ICAgLnN0YV9vZnMgPSAweDExMCwNCj4gPiA+ICt9Ow0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBj
b25zdCBzdHJ1Y3QgbXRrX2dhdGVfcmVncyB2ZG8wXzJfY2dfcmVncyA9IHsNCj4gPiA+ICsgICAg
ICAgLnNldF9vZnMgPSAweDEyNCwNCj4gPiA+ICsgICAgICAgLmNscl9vZnMgPSAweDEyOCwNCj4g
PiA+ICsgICAgICAgLnN0YV9vZnMgPSAweDEyMCwNCj4gPiA+ICt9Ow0KPiA+ID4gKw0KPiA+ID4g
KyNkZWZpbmUgR0FURV9WRE8wXzAoX2lkLCBfbmFtZSwgX3BhcmVudCwNCj4gPiA+IF9zaGlmdCkg
ICAgICAgICAgICAgICAgICAgICAgIFwNCj4gPiA+ICsgICAgICAgR0FURV9NVEsoX2lkLCBfbmFt
ZSwgX3BhcmVudCwgJnZkbzBfMF9jZ19yZWdzLCBfc2hpZnQsDQo+ID4gPiAmbXRrX2Nsa19nYXRl
X29wc19zZXRjbHIpDQo+ID4gPiArDQo+ID4gPiArI2RlZmluZSBHQVRFX1ZETzBfMShfaWQsIF9u
YW1lLCBfcGFyZW50LA0KPiA+ID4gX3NoaWZ0KSAgICAgICAgICAgICAgICAgICAgICAgXA0KPiA+
ID4gKyAgICAgICBHQVRFX01USyhfaWQsIF9uYW1lLCBfcGFyZW50LCAmdmRvMF8xX2NnX3JlZ3Ms
IF9zaGlmdCwNCj4gPiA+ICZtdGtfY2xrX2dhdGVfb3BzX3NldGNscikNCj4gPiA+ICsNCj4gPiA+
ICsjZGVmaW5lIEdBVEVfVkRPMF8yKF9pZCwgX25hbWUsIF9wYXJlbnQsDQo+ID4gPiBfc2hpZnQp
ICAgICAgICAgICAgICAgICAgICAgICBcDQo+ID4gPiArICAgICAgIEdBVEVfTVRLKF9pZCwgX25h
bWUsIF9wYXJlbnQsICZ2ZG8wXzJfY2dfcmVncywgX3NoaWZ0LA0KPiA+ID4gJm10a19jbGtfZ2F0
ZV9vcHNfc2V0Y2xyKQ0KPiA+ID4gKw0KPiA+ID4gKyNkZWZpbmUgR0FURV9WRE8wXzJfRkxBR1Mo
X2lkLCBfbmFtZSwgX3BhcmVudCwgX3NoaWZ0LA0KPiA+ID4gX2ZsYWdzKSAgICAgICAgIFwNCj4g
PiA+ICsgICAgICAgR0FURV9NVEtfRkxBR1MoX2lkLCBfbmFtZSwgX3BhcmVudCwgJnZkbzBfMl9j
Z19yZWdzLA0KPiA+ID4gX3NoaWZ0LCAgICBcDQo+ID4gPiArICAgICAgICZtdGtfY2xrX2dhdGVf
b3BzX3NldGNsciwgX2ZsYWdzKQ0KPiA+ID4gKw0KPiA+ID4gK3N0YXRpYyBjb25zdCBzdHJ1Y3Qg
bXRrX2dhdGUgdmRvMF9jbGtzW10gPSB7DQo+ID4gPiArICAgICAgIC8qIFZETzBfMCAqLw0KPiA+
ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX09WTDAsICJ2ZG8wX2Rpc3Bfb3Zs
MCIsDQo+ID4gPiAidG9wX3ZwcCIsIDApLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtf
VkRPMF9GQUtFX0VORzAsICJ2ZG8wX2Zha2VfZW5nMCIsDQo+ID4gPiAidG9wX3ZwcCIsIDIpLA0K
PiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX0NDT1JSMCwgInZkbzBfZGlz
cF9jY29ycjAiLA0KPiA+ID4gInRvcF92cHAiLCA0KSwNCj4gPiA+ICsgICAgICAgR0FURV9WRE8w
XzAoQ0xLX1ZETzBfRElTUF9NVVRFWDAsICJ2ZG8wX2Rpc3BfbXV0ZXgwIiwNCj4gPiA+ICJ0b3Bf
dnBwIiwgNiksDQo+ID4gPiArICAgICAgIEdBVEVfVkRPMF8wKENMS19WRE8wX0RJU1BfR0FNTUEw
LCAidmRvMF9kaXNwX2dhbW1hMCIsDQo+ID4gPiAidG9wX3ZwcCIsIDgpLA0KPiA+ID4gKyAgICAg
ICBHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQX0RJVEhFUjAsICJ2ZG8wX2Rpc3BfZGl0aGVyMCIs
DQo+ID4gPiAidG9wX3ZwcCIsIDEwKSwNCj4gPiA+ICsgICAgICAgR0FURV9WRE8wXzAoQ0xLX1ZE
TzBfRElTUF9XRE1BMCwgInZkbzBfZGlzcF93ZG1hMCIsDQo+ID4gPiAidG9wX3ZwcCIsIDE3KSwN
Cj4gPiA+ICsgICAgICAgR0FURV9WRE8wXzAoQ0xLX1ZETzBfRElTUF9SRE1BMCwgInZkbzBfZGlz
cF9yZG1hMCIsDQo+ID4gPiAidG9wX3ZwcCIsIDE5KSwNCj4gPiA+ICsgICAgICAgR0FURV9WRE8w
XzAoQ0xLX1ZETzBfRFNJMCwgInZkbzBfZHNpMCIsICJ0b3BfdnBwIiwgMjEpLA0KPiA+ID4gKyAg
ICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9EU0kxLCAidmRvMF9kc2kxIiwgInRvcF92cHAiLCAy
MiksDQo+ID4gPiArICAgICAgIEdBVEVfVkRPMF8wKENMS19WRE8wX0RTQ19XUkFQMCwgInZkbzBf
ZHNjX3dyYXAwIiwNCj4gPiA+ICJ0b3BfdnBwIiwgMjMpLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZE
TzBfMChDTEtfVkRPMF9WUFBfTUVSR0UwLCAidmRvMF92cHBfbWVyZ2UwIiwNCj4gPiA+ICJ0b3Bf
dnBwIiwgMjQpLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9EUF9JTlRGMCwg
InZkbzBfZHBfaW50ZjAiLA0KPiA+ID4gInRvcF92cHAiLCAyNSksDQo+ID4gPiArICAgICAgIEdB
VEVfVkRPMF8wKENMS19WRE8wX0RJU1BfQUFMMCwgInZkbzBfZGlzcF9hYWwwIiwNCj4gPiA+ICJ0
b3BfdnBwIiwgMjYpLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9JTkxJTkVS
T1QwLCAidmRvMF9pbmxpbmVyb3QwIiwNCj4gPiA+ICJ0b3BfdnBwIiwgMjcpLA0KPiA+ID4gKyAg
ICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9BUEJfQlVTLCAidmRvMF9hcGJfYnVzIiwgInRvcF92
cHAiLA0KPiA+ID4gMjgpLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtfVkRPMF9ESVNQ
X0NPTE9SMCwgInZkbzBfZGlzcF9jb2xvcjAiLA0KPiA+ID4gInRvcF92cHAiLCAyOSksDQo+ID4g
PiArICAgICAgIEdBVEVfVkRPMF8wKENMS19WRE8wX01EUF9XUk9UMCwgInZkbzBfbWRwX3dyb3Qw
IiwNCj4gPiA+ICJ0b3BfdnBwIiwgMzApLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMChDTEtf
VkRPMF9ESVNQX1JTWjAsICJ2ZG8wX2Rpc3BfcnN6MCIsDQo+ID4gPiAidG9wX3ZwcCIsIDMxKSwN
Cj4gPiA+ICsgICAgICAgLyogVkRPMF8xICovDQo+ID4gPiArICAgICAgIEdBVEVfVkRPMF8xKENM
S19WRE8wX0RJU1BfUE9TVE1BU0swLA0KPiA+ID4gInZkbzBfZGlzcF9wb3N0bWFzazAiLCAidG9w
X3ZwcCIsIDApLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMShDTEtfVkRPMF9GQUtFX0VORzEs
ICJ2ZG8wX2Zha2VfZW5nMSIsDQo+ID4gPiAidG9wX3ZwcCIsIDEpLA0KPiA+ID4gKyAgICAgICBH
QVRFX1ZETzBfMShDTEtfVkRPMF9ETF9BU1lOQzIsICJ2ZG8wX2RsX2FzeW5jMiIsDQo+ID4gPiAi
dG9wX3ZwcCIsIDUpLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMShDTEtfVkRPMF9ETF9SRUxB
WTMsICJ2ZG8wX2RsX3JlbGF5MyIsDQo+ID4gPiAidG9wX3ZwcCIsIDYpLA0KPiA+ID4gKyAgICAg
ICBHQVRFX1ZETzBfMShDTEtfVkRPMF9ETF9SRUxBWTQsICJ2ZG8wX2RsX3JlbGF5NCIsDQo+ID4g
PiAidG9wX3ZwcCIsIDcpLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMShDTEtfVkRPMF9TTUlf
R0FMUywgInZkbzBfc21pX2dhbHMiLA0KPiA+ID4gInRvcF92cHAiLCAxMCksDQo+ID4gPiArICAg
ICAgIEdBVEVfVkRPMF8xKENMS19WRE8wX1NNSV9DT01NT04sICJ2ZG8wX3NtaV9jb21tb24iLA0K
PiA+ID4gInRvcF92cHAiLCAxMSksDQo+ID4gPiArICAgICAgIEdBVEVfVkRPMF8xKENMS19WRE8w
X1NNSV9FTUksICJ2ZG8wX3NtaV9lbWkiLCAidG9wX3ZwcCIsDQo+ID4gPiAxMiksDQo+ID4gPiAr
ICAgICAgIEdBVEVfVkRPMF8xKENMS19WRE8wX1NNSV9JT01NVSwgInZkbzBfc21pX2lvbW11IiwN
Cj4gPiA+ICJ0b3BfdnBwIiwgMTMpLA0KPiA+ID4gKyAgICAgICBHQVRFX1ZETzBfMShDTEtfVkRP
MF9TTUlfTEFSQiwgInZkbzBfc21pX2xhcmIiLA0KPiA+ID4gInRvcF92cHAiLCAxNCksDQo+ID4g
PiArICAgICAgIEdBVEVfVkRPMF8xKENMS19WRE8wX1NNSV9SU0ksICJ2ZG8wX3NtaV9yc2kiLCAi
dG9wX3ZwcCIsDQo+ID4gPiAxNSksDQo+ID4gPiArICAgICAgIC8qIFZETzBfMiAqLw0KPiA+ID4g
KyAgICAgICBHQVRFX1ZETzBfMihDTEtfVkRPMF9EU0kwX0RTSSwgInZkbzBfZHNpMF9kc2kiLA0K
PiA+ID4gInRvcF9kc2lfb2NjIiwgMCksDQo+ID4gPiArICAgICAgIEdBVEVfVkRPMF8yKENMS19W
RE8wX0RTSTFfRFNJLCAidmRvMF9kc2kxX2RzaSIsDQo+ID4gPiAidG9wX2RzaV9vY2MiLCA4KSwN
Cj4gPiA+ICsgICAgICAgR0FURV9WRE8wXzJfRkxBR1MoQ0xLX1ZETzBfRFBfSU5URjBfRFBfSU5U
RiwNCj4gPiA+ICJ2ZG8wX2RwX2ludGYwX2RwX2ludGYiLA0KPiA+ID4gKyAgICAgICAgICAgICAg
ICJ0b3BfZWRwIiwgMTYsIENMS19TRVRfUkFURV9QQVJFTlQpLA0KPiA+ID4gK307DQo+ID4gPiAr
DQo+ID4gPiArc3RhdGljIGludCBjbGtfbXQ4MTg4X3ZkbzBfcHJvYmUoc3RydWN0IHBsYXRmb3Jt
X2RldmljZSAqcGRldikNCj4gPiA+ICt7DQo+ID4gPiArICAgICAgIHN0cnVjdCBkZXZpY2UgKmRl
diA9ICZwZGV2LT5kZXY7DQo+ID4gPiArICAgICAgIHN0cnVjdCBkZXZpY2Vfbm9kZSAqbm9kZSA9
IGRldi0+cGFyZW50LT5vZl9ub2RlOw0KPiA+ID4gKyAgICAgICBzdHJ1Y3QgY2xrX2h3X29uZWNl
bGxfZGF0YSAqY2xrX2RhdGE7DQo+ID4gPiArICAgICAgIGludCByOw0KPiA+ID4gKw0KPiA+ID4g
KyAgICAgICBjbGtfZGF0YSA9IG10a19hbGxvY19jbGtfZGF0YShDTEtfVkRPMF9OUl9DTEspOw0K
PiA+ID4gKyAgICAgICBpZiAoIWNsa19kYXRhKQ0KPiA+ID4gKyAgICAgICAgICAgICAgIHJldHVy
biAtRU5PTUVNOw0KPiA+ID4gKw0KPiA+ID4gKyAgICAgICByID0gbXRrX2Nsa19yZWdpc3Rlcl9n
YXRlcyhub2RlLCB2ZG8wX2Nsa3MsDQo+ID4gPiBBUlJBWV9TSVpFKHZkbzBfY2xrcyksIGNsa19k
YXRhKTsNCj4gPiANCj4gPiBUaGlzIEFQSSB3YXMgY2hhbmdlZC4gUGxlYXNlIHJlYmFzZSBvbnRv
IHRoZSBsYXRlc3QgLW5leHQgYW5kDQo+ID4gdXBkYXRlLg0KPiA+IA0KPiA+IEFuZ2VsbyAoQ0Mt
ZWQpIGFsc28gbWVudGlvbmVkIGEgbmV3IHNpbXBsZSBwcm9iZSB2YXJpYW50IGZvciBub24tRFQN
Cj4gPiBjbG9jayBkcml2ZXJzIGlzIGJlaW5nIGRldmVsb3BlZC4gSGUgZGlkbid0IG1lbnRpb24g
YSB0aW1lbGluZQ0KPiA+IHRob3VnaC4NCj4gDQo+IEkndmUgYWxyZWFkeSB0ZXN0ZWQgdGhlIG5l
dyBzaW1wbGUgcHJvYmUgdmFyaWFudCBmb3Igbm9uLURUIGNsb2NrDQo+IGRyaXZlcnMgYW5kDQo+
IGl0IHdvcmtzIGZpbmUgb24gTVQ4MTczLCBNVDgxOTIgYW5kIE1UODE5NS4NCj4gDQo+IFRpbWVs
aW5lIC0gSSBzaG91bGQgYmUgYWJsZSB0byBwdXNoIHRoZSBwYXJ0IDIgc2VyaWVzIG5leHQgd2Vl
aywNCj4gd2hpY2ggd2lsbCBpbmNsdWRlDQo+IG1vcmUgY29udmVyc2lvbiB0byBzaW1wbGUgcHJv
YmUgYW5kIGFsbW9zdCBhbGwgY2xvY2sgZHJpdmVycyBjaGFuZ2VkDQo+IHRvIGFsbG93DQo+IGJ1
aWxkaW5nIGFzIG1vZHVsZXMuDQo+IA0KPiBDaGVlcnMsDQo+IEFuZ2Vsbw0KPiANClRoYW5rIHlv
dSBmb3IgeW91ciBzdWdnZXN0aW9ucy4NCldoZW4gdGhlIG5ldyBzaW1wbGUgcHJvYmUgdmFyaWFu
dCBhbmQgYnVpbGRpbmcgYXMgbW9kdWxlcyBhcmUgcmVhZHksIEkNCndpbGwgcmViYXNlIGxhdGVz
dC1uZXh0IGFuZCB1cGRhdGUgaXQuDQo=
