Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F31159A3B7
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 20:04:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354552AbiHSRXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 13:23:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350095AbiHSRWi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 13:22:38 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2050.outbound.protection.outlook.com [40.107.22.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 043A11272C5
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 09:42:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XllqZAbi51E9++0UMDxJZZb0C1YYUn34ftvB4k/HHpzE9V3213VRhduWTJZvDU9GA5XtRAIzIhzbGFNnoC+OwYGRUT0TUQSJxnLnDr+0g0/qbq1oX9UkU/y+5rO8V4H+scnk4CKfP60Q3udeCGNp7ByifeQ5JNZxU1NOYg36u8fIE+CUqAHICS6IEiRS8vIbQddEQza4XL+uV22xWp5RuCwba3gpO92Z8sQLqIaNIvRYp36h8jB/BAWEbtS6HzPzdvyUtDpi+6QnSf16bnwE46b36KTI08+WdVQu7ODyOjTzA5icpau972P9hlgcEi5X0Jdcj74fMsTcNik6A52BdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bCRey14c2/8sA1Rft21JGM84WaeT0D/tdj/CFdcoUl4=;
 b=GvELenR8IEPOkEulXxPUlI7USR2qiqvp0qtcehUT8ff/CGIAIQ2G2ln4ZzGBBdPQ2VZp6zWW7HbH9FdbChR5MOc/l8pj29OGcZC3UrNPu8+p6nyqkb19y0gOGoWY47svYDdnDrzlsPtYy9xWjKlyv3YpmS4L1q4h/a6RAiFZiAZg5Bv4qZ6o1PYC35EEt44LZDW2sxrYRRlumQViRPTc4GtXfAmd+Qj01CKjbTeq24Ng0Cwurj1T3C18vSbOt9JOUeP2hmh9+pKnxjKuFdv8kVztv7DyyJn1sOuPBPNgSjmcYB5/hhc5ZgVVt6SOS1FJ0vYXErumx80wFAes1ODXuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bCRey14c2/8sA1Rft21JGM84WaeT0D/tdj/CFdcoUl4=;
 b=dNTMw9QRm8j7P6cKxOGPRBv3BLBeyxMtlObfa34EtcciLAiS2Lvr6Zbi85JwO3LD3Esdo9XQNseWxdH/MGcnW2ll2fJgzMm9idhJfuOlqkdOq0wv3eTzL1pVde65xpnn2RX0CeKDBNAxHEIppz4N1gcPAkzRlXbIJwj2zueFyyA=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB4417.eurprd04.prod.outlook.com (2603:10a6:208:76::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.18; Fri, 19 Aug
 2022 16:42:00 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::71b7:8ed1:e4e0:3857%4]) with mapi id 15.20.5546.016; Fri, 19 Aug 2022
 16:41:58 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Rasmus Villemoes <linux@rasmusvillemoes.dk>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Woojung Huh <woojung.huh@microchip.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Russell King <linux@armlinux.org.uk>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Thorsten Leemhuis <regressions@leemhuis.info>,
        =?gb2312?B?QWx2aW4gqeCoomlwcmFnYQ==?= <alsi@bang-olufsen.dk>,
        Craig McQueen <craig@mcqueen.id.au>,
        "tharvey@gateworks.com" <tharvey@gateworks.com>
Subject: Re: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Topic: [PATCH net] net: dsa: microchip: keep compatibility with device
 tree blobs with no phy-mode
Thread-Index: AQHYsw9wTPJvcSDZh0qzuivUfmRwaa22BCEAgAAKkACAAA41gIAAUiyA
Date:   Fri, 19 Aug 2022 16:41:58 +0000
Message-ID: <20220819164157.hubjxqczaxnoltjy@skbuf>
References: <20220818143250.2797111-1-vladimir.oltean@nxp.com>
 <095c6c01-d4dd-8275-19fc-f9fe1ea40ab8@rasmusvillemoes.dk>
 <20220819105700.5a226titio5m2uop@skbuf>
 <5c9aa2f3-689f-6dd7-ed26-de11e14f5ba0@rasmusvillemoes.dk>
In-Reply-To: <5c9aa2f3-689f-6dd7-ed26-de11e14f5ba0@rasmusvillemoes.dk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 43741dcb-97cf-4c44-ecaa-08da8201bbbc
x-ms-traffictypediagnostic: AM0PR04MB4417:EE_
x-ld-processed: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GCRTM3o1qxXZrR/lnLL2HT8zZi/IAz/5BWgtQOVE/4JSxKxBdRENhhGwSV7bZomvyKt2Fxe/8HgTyYYpM5ovmi3dHoIU+0FbOM59UFLzINFf3RNs9Mmt4jWN5RdHxk9JS8RqwxXsqmfg88HV3Wz6SYCgJcobYlrI2051t5N8sc8Rv1rxdpf7PDKIgBGfXwKekKSGcFSuH34CAjIrf6DwVugagw6kSMP9yFg+oxL4PFtKXZMD2E5zvre2QcwHRebvBuQzfSSW+IeO1OZugimItRkftRzDkSs8CkInZQGpapTl90EE+E4m9CSOJwW6BqA5tquJgAmE4nB/O8c92vz6XXrqOget2AkULGlgxY9XQ/gi9qRYVz3qqhHsi/Z20enir1aLQUMjv7uiiMf0Yfej1RTMT603WQMK3KyjHp8smGTbhDIqTgXCmvag1KaxzOeJBRPRvN2gYfL99xaZxpJ++oYRTK5v9vNGKZCKnZajZ0vKnh4PrScTiT0HDRxYYP6kdGAbQNW4Mb34uqWv7MS+nz8hYiHd80Ufuf6M8DhDjC86YUUIdn5dtv638C7X3fq+i6oViYO3rBX5BfZ7ip3GfXA9od81VFYpua3YZXATeOkninjDJXDL+Xz6j5boNwmKyBRkTCisVJ/3pJChjf/ln5cXGJ5jIMLA9Bk0ss2TkrKVDuAodJrRodbp4lBvUOkBl8Mze5nzPvro0obLIvc+g0CiXFPyHfoyrSSQbH0yfidJykeAdpWl+UQKmxQPt8btVoXqNOi41u+F+kONB7aa3+Z2HLlKl4cGONZInc1vGiM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(7916004)(346002)(366004)(39860400002)(396003)(376002)(136003)(86362001)(38070700005)(122000001)(186003)(1076003)(76116006)(38100700002)(64756008)(54906003)(6916009)(316002)(2906002)(5660300002)(8936002)(4326008)(44832011)(7416002)(66556008)(66946007)(3716004)(66476007)(33716001)(41300700001)(6506007)(26005)(9686003)(6512007)(66446008)(478600001)(8676002)(966005)(6486002)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?gb2312?B?a0FJWTZZUGtuS090Qnp2TEdrT1I0TU1jZHA1eGNiWnlZdm5vNDhidkFwRm9W?=
 =?gb2312?B?MVlMUk5ySEZqaGp1K2RHVnpWd3JCcnRHcjhISjNSZDBjcWtwam9VYTB6RmZV?=
 =?gb2312?B?N3g4cFZoenlZbjlWbHkxMUc2cXg4cHBwU0hINnJtVFJCTjBtSDNWTzV1Vm51?=
 =?gb2312?B?OWpBMW1meWdydnY1ZGlWVHZXM3MyM09yZFdpOThRZXZuN3VKSU1lejZnc3Yv?=
 =?gb2312?B?M0ZIT1RQQm5GL25KRVRSMWpCbkVIdUU0RFovOC9CdnNlV2VBQm5BRU1YWVVq?=
 =?gb2312?B?dEtNbnNvU20vVjVYNy8ydEFqN0lneVdUNlhjbkVXelBHaWF6bWZKaGdvME5U?=
 =?gb2312?B?L0JyeFI3bkxFa1NOWGtCekkybDBBREJ2elVUL3Bhak8rTnFJQU1vaTFPeDNQ?=
 =?gb2312?B?N2Zqb3pyK3ZOVlVtNXQvQVRlZ3haMGZGc0xoMHhZWnlqejhtYnRkWXQyR3Az?=
 =?gb2312?B?OVRUOEQvd1VEV3cxWjh6RXZFQU5KZzRWMDJOODQxb2o2NktIbzF0K3FlUjJQ?=
 =?gb2312?B?TGdJQ3d1eWtCa2x1aS80RHN3MGlMUG5pN2ovemN0SDRnc3VVMXFHL0ZYY0Zh?=
 =?gb2312?B?MjFYcHVpaldRNUo5REVwWklmUnA3T2lpRmJrbnNodVhWb2JJNHREYldkZ3Jv?=
 =?gb2312?B?QWVjS21TaWRkOGNSSWZMcGlUby9HZ1drZG4ydU9HdUJDZi9jcTRiaHYreE9w?=
 =?gb2312?B?N3ZyTm5DT3dZVVl2Y1RIdUJtb3lpUEZUN3YrL0tmRnNydWN5eGp1QlZTTkFK?=
 =?gb2312?B?SWRGRUFuMzVPNGxMNUQ3WGRzSnRKdlpYRG8vdWM0L242NWU5MzdsM2hKaXZ0?=
 =?gb2312?B?UVVmVVNLbXRpcHpyK1FOaUQ0Tll4QWJnZUZJMmdZakxOd0R2OXA4Z2ZaR0Yx?=
 =?gb2312?B?TjQrRzRQaG1QOElVd1grdGJSdC9pV08rNCtYMWplZHZBdkVZaVBFV1F6T3cy?=
 =?gb2312?B?MVBzYTJLQ1AxUjgxZU0yUnM5TFdjc0xSc3BwM3hTTTNEWm9wamI4MnF3VWJM?=
 =?gb2312?B?bVJxc1hqSlFLN3NvdVMyWnR2Z21DSkNWL0JEV3E3Qm9senJ0VWZDeVA3U1o1?=
 =?gb2312?B?cHl2TTBzZE5DRk9ndUNzbkUrcTBRTmdYaFl1NGZqODUyeFFYcXdLcEN5Lzlx?=
 =?gb2312?B?SE5LWGtWQ1ZkUnY3bUhMaDNtcFgrMU41SldWcVpZUCtLRHpGeUlJY1J4QUYx?=
 =?gb2312?B?M2Yxdzljdy9LVTQ2cmRsZ1JONVJhdkxTUGFKc3hXVm1GdEIwc2g2dGFOcU4r?=
 =?gb2312?B?a041UDU0eFFuYlNXNVlWamdocVFsbjNGaDJTZjZUQUVUTHN5MGZPVEhXTE5V?=
 =?gb2312?B?eDNPc1FKQThoUjhjRXNPYnRObHhrSjJwRlVyVEhJNlFXTWxaTUlqaktDZ3Jy?=
 =?gb2312?B?Vm1JRWFVVGFnK25TTWJUd2tjeFVpR29ZWHFYY3JXQXVFbVlpRmZaeUY3dkFI?=
 =?gb2312?B?UHh0bU1CQ0RjWi9xYVZiSnFEU1N6SGpHU0F6N1NFQkNrV0tlRTJnYnZVTlBB?=
 =?gb2312?B?eHRLRmtxbVRhU3llRHF1VE53MEV2RnZacDM1TmZHUUlhRkN1YWZEVXEzbkNX?=
 =?gb2312?B?a1F3c2pqVUF6Y2xFVlNORzJHY1l6YmQveVp3ZXBrbzZHcnNCREZSenVsTE5W?=
 =?gb2312?B?U0ZiQUltaVBzTkVxdGM5dmd4SzdDTGNJTGhzQU9qSzR1a0Y5Yjl2MXRjREFi?=
 =?gb2312?B?ME1aeGkvU1UvRjdOSTBTVjVocXNYdTB1a2QvRysxd2tzWENDL0RvaGNHdllm?=
 =?gb2312?B?WHY5WXI3UjRkenJ0RU40ZkpKOG00Q0QvaElKMWdSVXQvMlJpdWFQYkQvd3pl?=
 =?gb2312?B?aUlKMmhsSWFwNjhzWVpnMFJ2N1Fha0xpS21hT2xHMEt5S1Q0dFpoRWo5dm1W?=
 =?gb2312?B?V0xObGlhenpuLzN3UVVIYjV4QldidHlSZUR1aDZPYXlkaWEyNGVLNlNxR2hT?=
 =?gb2312?B?c3Jod05wVXVIVy9VRzEzem5NQ1lrVWNQVVRWRnQ2ektRYjRuOWs5ZGZuaXdl?=
 =?gb2312?B?UStvcEZiaGp6bDVlL3BkdFpocmRQUmVKNlFBNGtIN1puYzJySyt5MGNyRGgw?=
 =?gb2312?B?d0VJSHN4ZVlDdHcxaHdzQmlWQVJvOS9nNzBMd3ZMd3RGZ0JHR2Rtb1JmS0pw?=
 =?gb2312?B?dWNkS1FxWnd6L1N6QWFoajZ5LzBzTDFoWjRkTUFKRTR5c2tGaUNnV05CRXJN?=
 =?gb2312?B?RXc9PQ==?=
Content-Type: text/plain; charset="gb2312"
Content-ID: <28B03D9B2E5A384D8DD876A18180672D@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43741dcb-97cf-4c44-ecaa-08da8201bbbc
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Aug 2022 16:41:58.2176
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EPO7uWlJ31Q4ksmLo8ZpHJMhFZidnHkY7xhcQLykmGGBW8RkCUd5lgrd2++Cha4i5/mGEzfFuftbzYSz0yBO+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB4417
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBBdWcgMTksIDIwMjIgYXQgMDE6NDc6NTFQTSArMDIwMCwgUmFzbXVzIFZpbGxlbW9l
cyB3cm90ZToNCj4gPiBUbyBnaXZlIHlvdSBhbiBpZGVhIG9mIGhvdyB0aGluZ3Mgd29yayBmb3Ig
dXNlciBwb3J0cy4gSWYgYSB1c2VyIHBvcnQNCj4gPiBoYXMgYSBwaHktaGFuZGxlLCBEU0Egd2ls
bCBjb25uZWN0IHRvIHRoYXQsIGlycmVzcGVjdGl2ZSBvZiB3aGF0IE9GLWJhc2VkDQo+ID4gTURJ
TyBidXMgdGhhdCBpcyBvbi4gSWYgbm90LCBEU0EgbG9va3MgYXQgd2hldGhlciBkcy0+c2xhdmVf
bWlpX2J1cyBpcw0KPiA+IHBvcHVsYXRlZCB3aXRoIGEgc3RydWN0IG1paV9idXMgYnkgdGhlIGRy
aXZlci4gSWYgaXQgaXMsIGl0IGNvbm5lY3RzIGluDQo+ID4gYSBub24tT0YgYmFzZWQgd2F5IHRv
IGEgUEhZIGFkZHJlc3MgZXF1YWwgdG8gdGhlIHBvcnQgbnVtYmVyLiBJZg0KPiA+IGRzLT5zbGF2
ZV9taWlfYnVzIGRvZXNuJ3QgZXhpc3QgYnV0IHRoZSBkcml2ZXIgcHJvdmlkZXMNCj4gPiBkcy0+
b3BzLT5waHlfcmVhZCBhbmQgZHMtPm9wcy0+cGh5X3dyaXRlLCBEU0EgYXV0b21hdGljYWxseSBj
cmVhdGVzDQo+ID4gZHMtPnNsYXZlX21paV9idXMgd2hlcmUgaXRzIG9wcyBhcmUgdGhlIGRyaXZl
ciBwcm92aWRlZCBwaHlfcmVhZCBhbmQNCj4gPiBwaHlfd3JpdGUsIGFuZCBpdCB0aGVuIGRvZXMg
dGhlIHNhbWUgdGhpbmcgb2YgY29ubmVjdGluZyB0byB0aGUgUEhZIGluDQo+ID4gdGhhdCBub24t
T0YgYmFzZWQgd2F5Lg0KPiANCj4gVGhhbmtzLCB0aGF0J3MgcXVpdGUgdXNlZnVsLiBGcm9tIHF1
aWNrIGdyZXBwaW5nLCBpdCBzZWVtcyB0aGF0IGtzejk1NjcNCj4gY3VycmVudGx5IGZhbGxzIGlu
dG8gdGhlIGxhdHRlciBjYXRlZ29yeT8NCg0KU28gaXQgd291bGQgYXBwZWFyLg0KDQo+IE5vLCBi
dXQgaXQncyBhY3R1YWxseSBlYXNpZXIgZm9yIG1lIHRvIGp1c3QgZG8gdGhhdCByYXRoZXIgdGhh
biBjYXJyeSBhbg0KPiBleHRyYSBwYXRjaCB1bnRpbCB0aGUgbWFpbmxpbmUgZml4IGhpdHMgNS4x
OS55Lg0KDQpXaGF0ZXZlciBzdWl0cyB5b3UgYmVzdC4NCg0KPiA+IHRoZXJlIGlzIHNvbWV0aGlu
ZyB0byBiZSBzYWlkIGFib3V0IFUtQm9vdCBjb21wYXRpYmlsaXR5LiBJbiBVLUJvb3QsDQo+ID4g
d2l0aCBETV9EU0EsIEkgZG9uJ3QgaW50ZW5kIHRvIHN1cHBvcnQgYW55IHVubmVjZXNzYXJ5IGNv
bXBsZXhpdHkgYW5kDQo+ID4gYWx0ZXJuYXRpdmUgd2F5cyBvZiBkZXNjcmliaW5nIHRoZSBzYW1l
IHRoaW5nLCBzbyB0aGVyZSwgcGh5LW1vZGUgYW5kDQo+ID4gb25lIG9mIHBoeS1oYW5kbGUgb3Ig
Zml4ZWQtbGluayBhcmUgbWFuZGF0b3J5IGZvciBhbGwgcG9ydHMuIA0KPiANCj4gT0suIEkgc3Vw
cG9zZSB0aGF0IG1lYW5zIHRoZSBsaW51eCBkcml2ZXIgZm9yIHRoZSBrc3o5NDc3IGZhbWlseSAg
c2hvdWxkDQo+IGxlYXJuIHRvIGNoZWNrIGlmIHRoZXJlJ3MgYW4gIm1kaW8iIHN1Ym5vZGUgYW5k
IGlmIHNvIHBvcHVsYXRlDQo+IGRzLT5zbGF2ZV9taWlfYnVzLCBidXQgdW5saWtlIGxhbjkzN3gs
IGFic2VuY2Ugb2YgdGhhdCBub2RlIHNob3VsZCBub3QNCj4gYmUgZmF0YWw/DQoNClllcy4NCg0K
PiA+IFUtQm9vdCBjYW4gcGFzcyBpdHMgb3duIGRldmljZSB0cmVlIHRvIExpbnV4LCBpdCBtZWFu
cyBMaW51eCBEU0EgZHJpdmVycw0KPiA+IG1pZ2h0IG5lZWQgdG8gZ3JhZHVhbGx5IGdhaW4gc3Vw
cG9ydCBmb3IgT0YtYmFzZWQgcGh5LWhhbmRsZSBvbiB1c2VyDQo+ID4gcG9ydHMgYXMgd2VsbC4g
U28gc2VlIHdoYXQgVGltIEhhcnZleSBoYXMgZG9uZSBpbiBkcml2ZXJzL25ldC9rc3o5NDc3LmMN
Cj4gPiBpbiB0aGUgVS1Cb290IHNvdXJjZSBjb2RlLCBhbmQgdHJ5IHRvIHdvcmsgd2l0aCBoaXMg
ZGV2aWNlIHRyZWUgZm9ybWF0LA0KPiA+IGFzIGEgc3RhcnRpbmcgcG9pbnQuDQo+IA0KPiBIbS4g
SXQgZG9lcyBzZWVtIGxpa2UgdGhhdCBkcml2ZXIgaGFzIHRoZSBtZGlvIGJ1cyBvcHRpb25hbCAo
YXMgaW4sDQo+IHByb2JlIGRvZXNuJ3QgZmFpbCBqdXN0IGJlY2F1c2UgdGhlIHN1Ym5vZGUgaXNu
J3QgcHJlc2VudCkuIEJ1dCBJJ20NCj4gY3VyaW91cyB3aHkga3N6X3Byb2JlX21kaW8oKSBsb29r
cyBmb3IgYSBzdWJub2RlIGNhbGxlZCAibWRpb3MiIHJhdGhlcg0KPiB0aGFuICJtZGlvIi4gVGlt
LCBqdXN0IGEgdHlwbz8NCg0KTm8sIGRlZmluaXRlbHkgbm90IGEgdHlwby4gSSBoYXZlIHRvIGV4
cGxhaW4gdGhpcyBmb3Igd2hhdCBzZWVtcyBsaWtlDQp0aGUgbWlsbGlvbnRoIHRpbWUgYWxyZWFk
eSwgYnV0IHRoZSBpZGVhIHdpdGggYW4gIm1kaW9zIiBjb250YWluZXIgd2FzDQpjb3BpZWQgZnJv
bSB0aGUgc2phMTEwNSBkcml2ZXIsIHdoZXJlIHRoZXJlIGFyZSBhY3R1YWxseSBtdWx0aXBsZSBN
RElPDQpidXNlcy4gRG9jdW1lbnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tZGlvLnlh
bWwgd2FudHMgdGhlICRub2RlbmFtZQ0KdG8gaGF2ZSB0aGUgIl5tZGlvKEAuKik/IiBwYXR0ZXJu
LCBhbmQ6DQotIGlmIHlvdSB1c2UgIm1kaW8iIHlvdSBjYW4gaGF2ZSBhIHNpbmdsZSBub2RlDQot
IGlmIHlvdSBkb24ndCBwdXQgdGhlIE1ESU8gbm9kZXMgdW5kZXIgYSBjb250YWluZXIgd2l0aCBh
bg0KICAjYWRkcmVzcy1jZWxscyAhPSAwLCB5b3UgY2FuJ3QgdXNlIHRoZSAibWRpb0Bzb21ldGhp
bmciIHN5bnRheA0KDQpodHRwczovL2xvcmUua2VybmVsLm9yZy9hbGwvMjAyMTA2MjEyMzQ5MzAu
ZXNwamF1NWwydDVkcjc1eUBza2J1Zi9ULyNtZTQzY2Y2YjE5NzZhM2MzYWVjODM1N2YxOWFiOTY3
Zjk4ZWVhMWY3Mw0KDQpXaGF0IEknbSBhY3R1YWxseSBsZXNzIGNsZWFyIGFib3V0IGlzIHdoZXRo
ZXIga3N6OTQ3NyBhY3R1YWxseSBuZWVkcyB0aGlzLg0KTHVja2lseSBVLUJvb3Qgc2hvdWxkIGhh
dmUgbGVzcyBjb21wYXRpYmlsaXR5IGlzc3VlcyB0byB3b3JyeSBhYm91dCwNCnNpbmNlIHRoZSBE
VCBpcyBhcHBlbmRlZCB0byB0aGUgYm9vdGxvYWRlciBpbWFnZSwgc28gc29tZSBjb3JyZWN0aW9u
cw0KY2FuIGJlIG1hZGUgaWYgbmVjZXNzYXJ5Lg==
