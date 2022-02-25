Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 910714C4979
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbiBYPr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:47:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240745AbiBYPr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:47:26 -0500
Received: from EUR03-AM5-obe.outbound.protection.outlook.com (mail-eopbgr30051.outbound.protection.outlook.com [40.107.3.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 961841FCC8
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:46:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iXHClfBoQSASIiZAuKNjo6hobHsL49RVpZx3PePdh0UyVuM+hybHDcMUzGULXYvgGqUOR9cf/09WuI1lazCtmNJEfM3JNCFoCibkyfgDKv6ThCqtC4QYmKQCcRUtv40Oq5JumNu0kvV74HMKLCh3Imqz5N6qs1t+jlFfxuZwehHm8Hk1WypQPssNo6Y5FIY8e3WY9i4l0ytZuP8Lysfvu2qIkjINhVmeDB92nnQytViODZ2N63Q7j67Ook5JGTm457jIJaYIKaCy0rNlS6xUEVv7IGzh4/SEa9xeG2ApTuIWJBWE0Ne9uyonqcRK5H/eK/fff0CNcRxoe/ZJDEto/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j4hLNZABbgXsjuBdPF9VeN4mkOg0o0GauERZuxYySgc=;
 b=kdSfXg9Op1rkbsWArphkir4hmZLzrkIOBjnQV6ly1Le0q/3qdDXNADnN7TsitqtnahPMc2U/TbH0KKJHgAETJbAkGrvmjS+EqVTJcDhE9OkqCS1vwsCKl9Tyx0pAEWH+nyjkz4zWsnhywXvhQZv6n9Q8Zt4SzYRO7jRPjWgs7dPLrUoFFSpMpD1x3GZwskTqgsq4NFOy/43XGawIxjPIRUZDmNAnV2u1deoHWZ3/hr4D6ZAMSIbY1rHsguqELMjW4yIM6eeUf2fxDAY1xW5j5vLCmqZAXbExM0K7Lxxf61NTfHq/rjO48H//C100dYXypff5HGW+S3mJuUAi7Ytx8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j4hLNZABbgXsjuBdPF9VeN4mkOg0o0GauERZuxYySgc=;
 b=slO31b9oDiiumLmSvbYUfHxs3o+32VZZKhCqVRizn8or/KpntLJgENP88J/cObSXAMmCrdFyqGjqYMizo6sHgPXpyYwZ58AolHQz2UWf3MXy6FuCfsl9kVMHFaicr49dyv4pnxUJt5Y004FkTfs4IX7pd2zaxQBAmzmmBx9CT1Q=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by VI1PR04MB5598.eurprd04.prod.outlook.com (2603:10a6:803:e9::30) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 15:46:50 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 15:46:50 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
CC:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        =?utf-8?B?TWFyZWsgQmVoxILImW4=?= <kabel@kernel.org>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH RFC net-next 4/4] net: dsa: ocelot: mark as non-legacy
Thread-Topic: [PATCH RFC net-next 4/4] net: dsa: ocelot: mark as non-legacy
Thread-Index: AQHYKlT2wti3IUK/eUa3U+8PWlhSp6ykaSOA
Date:   Fri, 25 Feb 2022 15:46:50 +0000
Message-ID: <20220225154649.qi7rl6sfeq7g3n5i@skbuf>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
 <E1nNbgx-00Akj1-Sn@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nNbgx-00Akj1-Sn@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c850d9a5-6509-42df-fc4f-08d9f87609e1
x-ms-traffictypediagnostic: VI1PR04MB5598:EE_
x-microsoft-antispam-prvs: <VI1PR04MB55981E2248A9D854BBC46059E03E9@VI1PR04MB5598.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 7IczcQbYfxnJgX7PoDLR6ghIv8RFOGtrSdAYm6rodBIrkQsxSDjhOpOwGDJWCNGmq1iBFWhryxJInc78jspuhefv0lxN3dVD9sdvaI6dGXI33jEx1s3SfEU2S/Nffpflwerz++yjE5VUAKwc5ziqu5tWIVho9TPkqBdcJAFmoxDg4tv3fFqWLpFR97fA852hYBV0uAazQJbNMrizsHVkcm8cjRy9OBu3Unbl27tZAe67/tXxQDinzJOMZkmN4hBiPRjzADk5u0A7ER5f4RHG3g+VWvAT8r3fcoyF/2bow42djnKPdrdP4m+Kq9rjWcJvRFu+Fn/S3q+yq3B71dFGw+7RB1jkLXbHXfP8zlgF4TkT5VlluLfNhzNiV9BjEwOwjtD+Hi+t+CSD4twyLHirV9pYZwg7l+f8zxPKKiN0yC1eKWrh92l/wIzkcb9TDupyCBuaDf/wIHqr7cjdt5HkoljbXivnm/409Tmo44WRu65rmp8QovlC26Jkv7A/lnlpqThmnE/iD0in2ZhtPshj09hxIeSyTQiHE5CDJOkwh09oav+JoaZXuql2TI3GFHZvSm8rw1L6yF+hJ1Oz/oVcT6NxV631chdCj5mhKTcU1mwNpFVTtHdauOtMJj+v4OBAgyXvDOa2cSH45iVWk5mO3b4EVenhTUJg1Q72xU3Uc7qOwIF5bvRvetmqG2XyOiQu7Q92LxQ0GVR7ByBfmBWPMQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(54906003)(33716001)(316002)(86362001)(76116006)(64756008)(66446008)(66946007)(4326008)(8676002)(91956017)(66556008)(66476007)(186003)(6486002)(26005)(38100700002)(6512007)(1076003)(9686003)(122000001)(508600001)(6506007)(8936002)(71200400001)(5660300002)(4744005)(7416002)(38070700005)(2906002)(44832011);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bVhKemFFbVZXYXBjNGpiQ1grSGhHblpLdGZVdDhmMjliUVhVSkhac2k3eEY5?=
 =?utf-8?B?Q2JjWS9mZXd3dlJuVG0ydytzTWZCbTdwRE9qZU9iczhWSExYTTUvMm52TW41?=
 =?utf-8?B?Z0Z5K1REVlU1OVhoamE1Rjg5YXd2aWFHQ0ZCc1pFNW1reGgxUWdKVnBWTVFD?=
 =?utf-8?B?NFhxYXlVdXVHaml3ZzBuZC9IMldkUUJ4NUlnTERHYklBMTlyY3dxc0lBa1VL?=
 =?utf-8?B?Zy9DSldveWdVbTdwVzZSS3dSTFNrOWFpU0R4M0x5SWtSZENkTWhoODdmbTRw?=
 =?utf-8?B?QWxyTmkxM3pJTUtvVzJkY3NVWnBnc3FickQvQmN6WXFpTm5DUVNJa0VGL2Rn?=
 =?utf-8?B?MEsrUnNzNkpsY3IzdG8yWW5vM0lKcjYvWGJEQ09uNE03MGZ1dU83V1BXaXZW?=
 =?utf-8?B?NjdnZGJnRUNkaFhMdzVsQk02WENWTThNbW9QU2ZVTGVwRDlEVmJyMEF5OThD?=
 =?utf-8?B?ay9jc2toVktKeHRBdmFnVmtFUjMrcUFlYXlMWW9tMzdYR3l0SmpZUlJPSDhP?=
 =?utf-8?B?bWtUNUdCUWk0SXhCMjVwL2V4SkdzbS9HWW5EejZKWHRzdTRDSnFnVEpaa3Bj?=
 =?utf-8?B?aVNudk95aUVKOTAvRzFNQ0JqSnM0RTExQXVJMXRvdTB3K3F2TkZmc2c0YWVu?=
 =?utf-8?B?OUN2VzZOMGdNWHRQYnFrUFAvK2tSOHJQZDZBR1JlaGRRcmdkQ2JvcHdYZ1pE?=
 =?utf-8?B?SFZ5anI2aEs1YXkrN0drY29VUFR6ZVA0clFjNCtYSEJVWU5qZitJdk92WnVI?=
 =?utf-8?B?TDMzNkZqY2RyY0J3THRXNEh2eUdSaVB1MFo5WWUwbWc5Z3EzSUJKQThTc1lN?=
 =?utf-8?B?NUhma2VaWCs2WkFDa25xYUlHQm1Ud3F3RVpJSFN6amhRVVhkc21QYmJLbVVD?=
 =?utf-8?B?OWh2ZXpIaGtMU3RCRGdOOEYveW8vQ0RUVzlkczd2L3hMZXNVTEpiWldXNVRV?=
 =?utf-8?B?ODRKSHJnd0VHQzY3bTNQLzMwR2JFYlRocGxCbVY1dEc4UzJUS1BwekV1MlZt?=
 =?utf-8?B?RlVhNmgvTDFKaEZyMkY3SGMyY0YrVUtmY2F2a2wzSU1JdEFqRFpmeDVwVXZN?=
 =?utf-8?B?SE1iSDJ6VmJiZmxkcmJnSk40Tng1dGIzVzBMYzNEd0VTY2k4R1ljRTFqTlBQ?=
 =?utf-8?B?UmYwMVpZNlVZMDRpTFBWYmVOZFNYaUlHNEFIQTVzUU5Pa28wcWN6WDhtS1dU?=
 =?utf-8?B?SFBleDE5Vm16S3ZuVGFTb2o5NXhORlZZcVVpeVl1KzdzczczWFRpKzdBMURu?=
 =?utf-8?B?VDlIUWRuUEYzdUV1ZTRrbm43aUwycVBUaExFLzl4MGRtL1g2SWRNb3BPNVpT?=
 =?utf-8?B?RGt1a2g4eXY1ZGtsQndWRTE4K2pnK0U0UWQ2SFlZVFJNQTZoVWpGRW1CWTRV?=
 =?utf-8?B?QzFOb2JtQjJxd2lOdkVBQ2d4QUdTM0pkRlpQR2VXb3dLSk0xZTFoN05oVHJk?=
 =?utf-8?B?R3dnMzZjTnplemRUZ3pxdzdTWEN2TWsxWUIrRGNOc0U5OE9lNmtrZHowSGY1?=
 =?utf-8?B?cklXbmgveTlZM3JBMm5zeWR4SkZUMzRyQlVSY09yYmlDYW1ERjN6TEI4MS9x?=
 =?utf-8?B?SE16NlM4WlpZOUx2UzdxdDB6Q3lMdThIdmttVU9RNGZYSXVSSWhJcVJzWENY?=
 =?utf-8?B?T0hrQ296UTJhZFRjdGw1bnhqaktONEdtcWV1eWQ2T0V1NGo5S3RvSkFzQklv?=
 =?utf-8?B?MSs0UGtScVcrNWc5Z2lMNnczbU9Cd3lJTFA4UnVUV1l0L1lrdGE2MTEyMHkx?=
 =?utf-8?B?UGJucTBxQWllOHVHdzlrdXMxbDZNWE5nK2JoZDl2aFJGeXd1bW1ZaWxTSHR6?=
 =?utf-8?B?UjA1bmx0MmZJRXdNV0V5cmxmbnlBUkhJY0JXMklZeTQ1SGh6Y1lRaE5Damtr?=
 =?utf-8?B?NUZzNkZvdlJXMi9VVWN0bk9yY01zcEtjTnhiNFVZbkMvRXd6OG90ZFZHektB?=
 =?utf-8?B?UDhQM1NDbm9WR1FpSm80UTNickRmUERWZy8yblhJa0Z6a2JobC83Nm9ScVNM?=
 =?utf-8?B?elRRN1dDMmRicFp6UVFlTitubHRGOFFtNzZqejlnQkN4V2RnakxkVVYyWklF?=
 =?utf-8?B?VFBSVVF2WjBNWjZvR3lSdHRGcVJGRjNNcE1LRzF4ZW0rSDR4Q0M5dGtxdHpT?=
 =?utf-8?B?Q2JLRnNoUnp6T096Vld4WGxJOUl2dzhRZEdaV0lFU3JoYlZ3M2pvbmdoT2xQ?=
 =?utf-8?Q?Hc+DrmLf1xMjWJ48DDYELM6vsdenpBrDHtWu9cIFJcIp?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C88902640EB4354896BE163FAFB33806@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c850d9a5-6509-42df-fc4f-08d9f87609e1
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 15:46:50.4020
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXCiCnknJ7v4iJ56ap7oSipKbsetcAurvx3CwGPRQgt2TBtsqvKjWiKkxlY1DDtNJ8UGF8qwHxl1dvG3mr59Iw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5598
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDI6MzU6MzFQTSArMDAwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBUaGUgb2NlbG90IERTQSBkcml2ZXIgZG9lcyBub3QgbWFrZSB1c2Ug
b2YgdGhlIHNwZWVkLCBkdXBsZXgsIHBhdXNlIG9yDQo+IGFkdmVydGlzZW1lbnQgaW4gaXRzIHBo
eWxpbmtfbWFjX2NvbmZpZygpIGltcGxlbWVudGF0aW9uLCBzbyBpdCBjYW4gYmUNCj4gbWFya2Vk
IGFzIGEgbm9uLWxlZ2FjeSBkcml2ZXIuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtp
bmcgKE9yYWNsZSkgPHJtaytrZXJuZWxAYXJtbGludXgub3JnLnVrPg0KPiAtLS0NCg0KUmV2aWV3
ZWQtYnk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQpUZXN0ZWQt
Ynk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+
