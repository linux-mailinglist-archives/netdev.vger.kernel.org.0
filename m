Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B64F04C48F5
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 16:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbiBYPbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 10:31:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233758AbiBYPbe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 10:31:34 -0500
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-eopbgr80055.outbound.protection.outlook.com [40.107.8.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BB65218CD9
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 07:31:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C45rkpyPymZVwQVYNFnVHX60KgMg7pfzdId9jtO3ra/ty/d3RIIgA4gUoORBxf+t2e58r4Y4EllRuHV1UYuSlIgIKQzcT9/+wFN33AhyYPnX/jknJL2RTRfFLt3lITWBNCS/VsdICcG/471P+E9lQtPYSavlf/9HMSTqmWcCG2x8zXA4EQWTAEjmRMtwOi4XaHSStZ4DDu23VoDLZ0GSKb81yUiAczQLZ1IbCxJ5ryBs5KknLDLcaRFOU+5QJBK7afOEBIn4U/pU8+kENktIzHGqbQDkcNBCEoYtFEsMIUmu7P6Lb1xGFTolt7VzKHCcNiU38y/W3PI/yH38wJoSCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rALaf0xAm8I/II1LQ3vUlji9hVBNigG/beNqmNJlHVA=;
 b=enRRVlSckXBMAWNZiSopTlVlDWifOK9l2yziBFrWGkx0sAA66lONm+zJRNxuLgQFWYvBJO+nBBFQ59HbZCYpiTdZ/fAR8ZSx7EUcKLmxvFSzeDoQjI2q5dqZY31O6FmNqdhVDu8bdE+P+PrSL4AfQer5jovZfMx5z7YnBxEvd14LX94wvO1knb223myuR9giGMLzsLCDFss8qDleQWhuzG1igtQ4YzE0NxB+kJuNL8K1ybVuqByjTQ2LEygsxTQb93S9aaNGcC+ulJtbOiI4IOEAjE+XfC4PEbR+FHjtUO0viRNVre6H6NMxTDeHMTrox2HHgD+487YFW2ZKEDjT5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rALaf0xAm8I/II1LQ3vUlji9hVBNigG/beNqmNJlHVA=;
 b=nqR4mWt09EAn000okSPlGcIhJghFbat7ysnsMUwDRKVRZNWa0lxkwxrsXb89SrghsBrxtMaBIJYqoTW4PZuKzDrHstT75EcylSTNF1deQSb7Ap+rCSOPl7GcDh0TGlo6tGsn+GAUMla+iDnrG6GPXWsI0MWJWgwEgCWe1JBBLlo=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AS8PR04MB7752.eurprd04.prod.outlook.com (2603:10a6:20b:288::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 15:31:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 15:31:00 +0000
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
Subject: Re: [PATCH RFC net-next 2/4] net: dsa: ocelot: remove interface
 checks
Thread-Topic: [PATCH RFC net-next 2/4] net: dsa: ocelot: remove interface
 checks
Thread-Index: AQHYKlTyxQLkrDseBkiFAVz+Hn5MdaykZLaA
Date:   Fri, 25 Feb 2022 15:30:59 +0000
Message-ID: <20220225153059.f6hxctvj2r3ih42d@skbuf>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
 <E1nNbgn-00Akik-MJ@rmk-PC.armlinux.org.uk>
In-Reply-To: <E1nNbgn-00Akik-MJ@rmk-PC.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b62cb4a3-0e76-47be-b665-08d9f873d35c
x-ms-traffictypediagnostic: AS8PR04MB7752:EE_
x-microsoft-antispam-prvs: <AS8PR04MB77523CD11204E2FB3233B823E03E9@AS8PR04MB7752.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QqDydM7PRiURv5diEVnkcFs4bHHDIepKAFaiAKujCq0zkqY0NYynbVvc/GypGF+xuWda75F6XmoDsDX9lbaRxyBA+/7htHmyKSk9RtJ2180I/OF3KIRWYaFVDplOPPfYpK69ABEaYcAUz6kfqCz3lDjLFse4TACoqJ4oaedYzoofYa8G2uCXxwiEA43pF7TAH0PnoikjRPVRjOjWUmmV2S4mc8DSe24ktX/VG6wpBVkH/T0/jmg+cZJSZ5hjjKsuK9fchZJ+L8pMjId3vZmoTU4UQ/79ZAEjA3As8M2dpI+awwUB0BXsFJgjKgVf2VbayMRK+/ZKjY0IijFYJB2JprTr2A1WpI7WHVP61/REyCG25raODv8Dv0r3smRb4ze8BRBrp6Hrdxfhmck++MFz13sRtlxXG8uXfykhf+vmj7WfAUpA5Oqc9v5+RRb9dx2Iij7RIFiyqCrKl4st5mSZQ0V6FHjZJEsYnAfZbNwhkiWcAAdgjNcYPKcR70aZw/lGn2ALdYYqnJhMYN2EQ+7J73Q1jUdL9jM34bj/Xh37ictWz9XU/oHIvOEdUzpmMRy1fNueX3wDKJEarsY/+bOsjn4Z2JGDBOXxh0BUiE8SuDXt5lV1bbqcunt7C3LoGPqUVzso2tUDP/zWkV7/p6+9xAZsy8IPOlwf2PZi6FVuJBI2xq7KLY0hJNpo0Vd+UjFu57c5xjkz2BUpzTd2oTYLdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(71200400001)(26005)(186003)(9686003)(1076003)(8936002)(7416002)(44832011)(38100700002)(86362001)(316002)(91956017)(33716001)(6486002)(6512007)(66556008)(6506007)(5660300002)(54906003)(76116006)(83380400001)(508600001)(122000001)(64756008)(66446008)(66476007)(2906002)(66946007)(38070700005)(4326008)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Z09Ma2xSMHZnTlg5STRab2pvb0VaY1U2WFd3YUZsS0dYVCtwdVVzMmFUWVQ3?=
 =?utf-8?B?ZG01TnFLaGpoeWE5eHRxb2lDU3g5b1lGeE0ybjArYkxISkdxNUFJVUh3UTc4?=
 =?utf-8?B?L3RWQWwzUi9vMnBXc1RQR05qSHVQcWF4Y1EwSy9nSnFrRCtSR3BFSUxJWTVO?=
 =?utf-8?B?WnptQ2lsWEdNQjMySEMrQ294bWxuekNQTm81L1BDY1NNVExQSTBDb3I4OXFU?=
 =?utf-8?B?M084YmtqcEFWSVl5cS9pSVBaSVJITk9EWDdvcGhiaFRObUgxS3JUYWJTWE02?=
 =?utf-8?B?V3U5ci9od3pJTWRPWGhCU0UzODRDYm00U2Z0dVBwek8rUitPVWJoUit4Y2xR?=
 =?utf-8?B?VjdFaTlmdkp0RmpicE1xWTViSzkrUko3bXozT09RbjFMVTBZNkpzWkFDUkFu?=
 =?utf-8?B?b3MzUk4yMHpDQkhCUjc0VXRqeFRuSDZ4Ym14UjJQVG1aRmdXYXorbWdDWG5P?=
 =?utf-8?B?SjJVMGVEWmNPaUptMVJIakpxU3MwOUNYV1h5YktRWWFLa3plNFB6QkpXNldt?=
 =?utf-8?B?Q0M0SW5tWHdkNVduWDZSM3Y4c2xSeTRReUJwcHEvRGZ3Y1NockFiQUxzMVFo?=
 =?utf-8?B?Zk53UXR6NFNRbUhIZEJHcGZCSUFsS2JVZC9CaHI5c1JadTZhdVhsZmxmQ1A1?=
 =?utf-8?B?cHJ2a1NKWHpwUSsvd3NLSVdIWUluUm5USUhnOXZibW5Ramg5V3IyaTF3Y1ZP?=
 =?utf-8?B?UWxNSkpGSnVZaTc2SHJHa0Z2UTVYRW5DUklyejVtNXd3QXFXcmNJS2Vjc0pw?=
 =?utf-8?B?QkF6dzg1b1RWbFNwbEw2RGVxRGExZGhmdUxNU204bjQvZENSd0pCNjkvaUtN?=
 =?utf-8?B?T1lNUHgxdlBOQ3FxRkxaQVpBTGhLTGd5TWEvSXhOdWhyTVViNjR2M3c1eGRs?=
 =?utf-8?B?V0hyaXl4TENMSyt1ZG1VYTRBQjNlSWFNWUxuMlV1MzhlN1A3RFVrcTJKcTlQ?=
 =?utf-8?B?eEtsWHE0OFBvVWFpYU55cjVCZ3JHZkQ4eEVhdERsekRhRFQ4c296YUtOeHp2?=
 =?utf-8?B?RmxTM2VPZHJlTDJJUEQ3dUJOWG81LytRSjdYakRUMEhJMzdaUU1nSnhmejd2?=
 =?utf-8?B?aXpTOStsS0piRGhuTklBMnRMSjJsNEZQbDBVMWtKcUhvbnZUNi81NDVNS3Rw?=
 =?utf-8?B?WHhJK1JOaWFKdDBtR3A1WXlVUENOeVRRSDBabW85ajIvY2dDZmNpNGdscEpz?=
 =?utf-8?B?VkNzKzFUWnNvSEF4TDNGbGF5d0tTZjZqQ3I0YTlCVFd5VkNHbTJ0NjcxTFlM?=
 =?utf-8?B?U1BOL1BsWUhzMEFkZU10LzkvcHIwQ3N0MzcveFdHSm5qTlVrUTRBZjFKcDdD?=
 =?utf-8?B?Z083am9OMWM2NnFDSHdXQm84YWpRMXU4U21lS05OQlozN0lCSGljSUppSWJT?=
 =?utf-8?B?RmYra3JHOG9maWorUzBuVWF4Vm9LWTZRaFA0WXdsQlArV1VadnliczBvcFMw?=
 =?utf-8?B?bVB0RHlxK0N6b21Ud1VWKy9zQVhxVk96UzFRdzFWdCs1MWJzLzY2WmRTOUNI?=
 =?utf-8?B?TEsyUERGSlBlRVpxOTJ4S1lBVktJbldETFpGVDV2MXhDMk83YUR1S1JNSDhj?=
 =?utf-8?B?TWI2Z2IwcEltWithcW5Td2VPL3Fxdjd0cUREZ0lsVVZTYVVObzE0ZTllVC9N?=
 =?utf-8?B?RE1PMlVoOFV1YkpuekhYWFNRL0pSZHZPVU5aMUJZQURwR3pvWjVpbzkyZzIy?=
 =?utf-8?B?dlpXMFZEQ2tLL09SeW42VUZITkhYVGxSLzhGM3pKcHFRa2xhM09TSTNyUzR5?=
 =?utf-8?B?cnVVVUlsd00xUjFBdzl3VmJFUkRKWWxQdUhmTDlyS0J2MHg0VzBTM0cydXpC?=
 =?utf-8?B?SkUwdEVUVk4vOW9mS2l3bWMyRHJSSG53SHNwaDd6OUJRY29GQm9Mb1ZGbWtG?=
 =?utf-8?B?Um5OL2RNdUN5L283UXhWUis0cmFvdFZjTjQza2FBS1BoOTZPbVYvWU5OeTBK?=
 =?utf-8?B?R1VzbkptQnZiVGJWM1FTN0t1ZlFWcjNEdVQzbk9VWVk3d0xxdkF2OUFwbUQ3?=
 =?utf-8?B?OCs3WGhYTzBlbHZNSjNaUVVmVFNadDJIaDEzU1pDTE8zbHp1ck1xWjZla3Fp?=
 =?utf-8?B?Rnc5RENvQmVoWWZCOVljckRHNXl5ODl3eGdIU0dJQzFsMWo0aDZoMWxodW9M?=
 =?utf-8?B?dlpuZVovL1JLSjFzelFKbHVzMVUrMnV1TE5tbm9kaDY5dFQxbjZmVTRzaUJX?=
 =?utf-8?Q?sXKM3vyKEIfmK5by6h1f1eSDFkFPv/+a5zsOq16fz8jY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3C3500772458964F8A8D996264A4EE95@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b62cb4a3-0e76-47be-b665-08d9f873d35c
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 15:30:59.9382
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /P5ay9Swoo8zqVpgvmtKKuExcfakFz612L7k7oCOvUvpJEIXrXpIX79Y3mFjy6bfoCORXO7Sj7cH5EaDUJhdDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AS8PR04MB7752
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDI6MzU6MjFQTSArMDAwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBXaGVuIHRoZSBzdXBwb3J0ZWQgaW50ZXJmYWNlcyBiaXRtYXAgaXMg
cG9wdWxhdGVkLCBwaHlsaW5rIHdpbGwgaXRzZWxmDQo+IGNoZWNrIHRoYXQgdGhlIGludGVyZmFj
ZSBtb2RlIGlzIHByZXNlbnQgaW4gdGhpcyBiaXRtYXAuIERyaXZlcnMgbm8NCj4gbG9uZ2VyIG5l
ZWQgdG8gcGVyZm9ybSB0aGlzIGNoZWNrIHRoZW1zZWx2ZXMuIFJlbW92ZSB0aGVzZSBjaGVja3Mu
DQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBSdXNzZWxsIEtpbmcgKE9yYWNsZSkgPHJtaytrZXJuZWxA
YXJtbGludXgub3JnLnVrPg0KPiAtLS0NCg0KUmV2aWV3ZWQtYnk6IFZsYWRpbWlyIE9sdGVhbiA8
dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQoNCj4gIGRyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVs
aXhfdnNjOTk1OS5jICAgfCA2IC0tLS0tLQ0KPiAgZHJpdmVycy9uZXQvZHNhL29jZWxvdC9zZXZp
bGxlX3ZzYzk5NTMuYyB8IDYgLS0tLS0tDQo+ICAyIGZpbGVzIGNoYW5nZWQsIDEyIGRlbGV0aW9u
cygtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2RzYS9vY2Vsb3QvZmVsaXhfdnNj
OTk1OS5jIGIvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9mZWxpeF92c2M5OTU5LmMNCj4gaW5kZXgg
YTFiZTBlOTFkZGU2Li40YzYzNWM0NjcwNWUgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2Rz
YS9vY2Vsb3QvZmVsaXhfdnNjOTk1OS5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2RzYS9vY2Vsb3Qv
ZmVsaXhfdnNjOTk1OS5jDQo+IEBAIC05NTYsMTIgKzk1Niw2IEBAIHN0YXRpYyB2b2lkIHZzYzk5
NTlfcGh5bGlua192YWxpZGF0ZShzdHJ1Y3Qgb2NlbG90ICpvY2Vsb3QsIGludCBwb3J0LA0KPiAg
CXN0cnVjdCBvY2Vsb3RfcG9ydCAqb2NlbG90X3BvcnQgPSBvY2Vsb3QtPnBvcnRzW3BvcnRdOw0K
PiAgCV9fRVRIVE9PTF9ERUNMQVJFX0xJTktfTU9ERV9NQVNLKG1hc2spID0geyAwLCB9Ow0KPiAg
DQo+IC0JaWYgKHN0YXRlLT5pbnRlcmZhY2UgIT0gUEhZX0lOVEVSRkFDRV9NT0RFX05BICYmDQo+
IC0JICAgIHN0YXRlLT5pbnRlcmZhY2UgIT0gb2NlbG90X3BvcnQtPnBoeV9tb2RlKSB7DQo+IC0J
CWxpbmttb2RlX3plcm8oc3VwcG9ydGVkKTsNCj4gLQkJcmV0dXJuOw0KPiAtCX0NCj4gLQ0KPiAg
CXBoeWxpbmtfc2V0X3BvcnRfbW9kZXMobWFzayk7DQo+ICAJcGh5bGlua19zZXQobWFzaywgQXV0
b25lZyk7DQo+ICAJcGh5bGlua19zZXQobWFzaywgUGF1c2UpOw0KPiBkaWZmIC0tZ2l0IGEvZHJp
dmVycy9uZXQvZHNhL29jZWxvdC9zZXZpbGxlX3ZzYzk5NTMuYyBiL2RyaXZlcnMvbmV0L2RzYS9v
Y2Vsb3Qvc2V2aWxsZV92c2M5OTUzLmMNCj4gaW5kZXggMmRiNTE0OTRiMWE5Li4wYWU4NDI0YzQ3
ZTIgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2RzYS9vY2Vsb3Qvc2V2aWxsZV92c2M5OTUz
LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZHNhL29jZWxvdC9zZXZpbGxlX3ZzYzk5NTMuYw0KPiBA
QCAtOTI5LDEyICs5MjksNiBAQCBzdGF0aWMgdm9pZCB2c2M5OTUzX3BoeWxpbmtfdmFsaWRhdGUo
c3RydWN0IG9jZWxvdCAqb2NlbG90LCBpbnQgcG9ydCwNCj4gIAlzdHJ1Y3Qgb2NlbG90X3BvcnQg
Km9jZWxvdF9wb3J0ID0gb2NlbG90LT5wb3J0c1twb3J0XTsNCj4gIAlfX0VUSFRPT0xfREVDTEFS
RV9MSU5LX01PREVfTUFTSyhtYXNrKSA9IHsgMCwgfTsNCj4gIA0KPiAtCWlmIChzdGF0ZS0+aW50
ZXJmYWNlICE9IFBIWV9JTlRFUkZBQ0VfTU9ERV9OQSAmJg0KPiAtCSAgICBzdGF0ZS0+aW50ZXJm
YWNlICE9IG9jZWxvdF9wb3J0LT5waHlfbW9kZSkgew0KPiAtCQlsaW5rbW9kZV96ZXJvKHN1cHBv
cnRlZCk7DQo+IC0JCXJldHVybjsNCj4gLQl9DQo+IC0NCj4gIAlwaHlsaW5rX3NldF9wb3J0X21v
ZGVzKG1hc2spOw0KPiAgCXBoeWxpbmtfc2V0KG1hc2ssIEF1dG9uZWcpOw0KPiAgCXBoeWxpbmtf
c2V0KG1hc2ssIFBhdXNlKTsNCj4gLS0gDQo+IDIuMzAuMg0KPg==
