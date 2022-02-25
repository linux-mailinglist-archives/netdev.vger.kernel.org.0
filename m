Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCFB4C49EE
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 17:01:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237541AbiBYQBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 11:01:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbiBYQBT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 11:01:19 -0500
Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-eopbgr70050.outbound.protection.outlook.com [40.107.7.50])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FAD1F1252
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 08:00:46 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Jb+h/sfc5E+s2a3Ifi0qedcQHUG0cjv3xcyZzZzUHM7r4KikHMkgvtCZ9+BHeVTJLkFEw9DJyMdkLMFfkDAWoDBPSXlKoRcltqOYUZwY+iCHNoZjZUU/9IUvr8gn4FsXkqgFncLpNR8Ka5ZrImEIaZ8GiHwymEHxPvhQYqVe6zlAXNBgcwJ/suu27ft+zy5BG4uJtt+7FyJzZFrcoqexRLL9ORcPlPV+hz8bM2g1fU8db+gculJBcKYYxUKg28R12nc8Z5IGGE1OCuJy6p8SE6GiteU4YVmyH68pDHkrpB9p1NSvosT2yUU+Fp7IrUQi2V4W8RFv690142cjY4OtxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xcKKuAqrW6ApFahcxKdGxB5NIRK+vZ1zA4/ESvXkfNY=;
 b=N35hBn4T47PEdzNh0H921JdiU/tMDrNSAOZKziSdrL8x4G6sW7PnIVGYvi1rbbSU33r96Ap0bO4r34386sV2QRezV6hsEYbyzpq57hx0SoJQP2ELEl4X0Ssmtr56cgOVs+h+oDWkzCxH4j7OVJ0mMAfvQoZiqmdvseCm8QLcLmO8EyD8UFiVYRzDyOuq9p0KcWARt9nDvOVCXWwNAVkN5X4Vr/7wZ6dQupw/2objBd+B0mK7vPweZOYnTagCMx4eKXnb68n3arvWs2wx+Y+Iba8gXznlfA+8L3h0abN932aegGqZB8XFKYw3iJtux0Qt7zBvYe1TQvrgr0lh4XMjlA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xcKKuAqrW6ApFahcxKdGxB5NIRK+vZ1zA4/ESvXkfNY=;
 b=msYNIRLgNPwPqYSrFHuU4ByGbq+k74fCg+L98rbBzlQV8Yz6bY+qw6XZxEtmaMLKWppvh02c86XDOibeCozCevxg6qJRlcgct/Y/rnslXptPtN3eB/p7ATKN01cKm81ErSgpENFx2iPmkafrFcLL/1rKH1WXUYwE3eUvIKwAn88=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM6PR04MB5480.eurprd04.prod.outlook.com (2603:10a6:20b:96::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5017.25; Fri, 25 Feb
 2022 16:00:42 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::95cf:8c40:b887:a7b9%4]) with mapi id 15.20.4951.019; Fri, 25 Feb 2022
 16:00:42 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
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
Thread-Index: AQHYKlT2wti3IUK/eUa3U+8PWlhSp6ykaSOAgAADmQCAAABGgA==
Date:   Fri, 25 Feb 2022 16:00:42 +0000
Message-ID: <20220225160041.qwrghcnlsrgu5jam@skbuf>
References: <Yhjo4nwmEZJ/RsJ/@shell.armlinux.org.uk>
 <E1nNbgx-00Akj1-Sn@rmk-PC.armlinux.org.uk>
 <20220225154649.qi7rl6sfeq7g3n5i@skbuf>
 <Yhj87ncKgaYMXpzR@shell.armlinux.org.uk>
In-Reply-To: <Yhj87ncKgaYMXpzR@shell.armlinux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 64e95f8f-1f53-46ba-ff47-08d9f877f9ec
x-ms-traffictypediagnostic: AM6PR04MB5480:EE_
x-microsoft-antispam-prvs: <AM6PR04MB5480DB0653DDCE0EE21BDFF3E03E9@AM6PR04MB5480.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yWqDyXpET6Do3ooz03PDs4GnOU6M5a82rIuGcKJBOJcUKNdjxbeXAD+8KCqHgGmgQabanQ4yTHEIWJDkLkyVx3+wMx2TzCMlW2qZmfLd8Fj+TDIyyqj8wLJNnl4rNJMq8FGyuPXHHfebotwZqSud63qTw9PVASyodpey7KL1xc9Lrutn8yXuG4/qjbcSsb+FuJHdgfE0CnFXEwH7ELbj02LP4W6thelHyyg3LuJhlCigyuCxj6cLpSGxYm0ll8nDRDoDF813AJtt/bF01WgJX1eJ2gdoq9rQLs6rZyshd2gWI+IfgiMpvfGQFCdGbj01hsL0R0A+HD6UnesOHsc3ul4fLE0qolCFF1kN5yJ1kFtPhgw0XwBllYqpXdiPOGiH3GKjYS4HyWfGtOH1uWR9Fon2w4pvs3ZddtG0ldXEYDOVidi/drWzH5sx8N1gMOyStZmq+0LRo1U9BLLnEtOKrdhHLwTO9VNEddzIL31my7xCkLglWIkukGubrPijh8ry2yt3v/O009ZkZMGzEPgCGwLJ4zDFQuILO6xJ8IBURMclRqMAbnxarAg+k1rmn4+LZh5XdjG1t41Kq0UWEhMYI3YRGTC0MuPczuxZVW9nJo1VqMENgZ4cuPQ8ndG+1SlCZYi68QqnLPZBEu8xWA+osyk4G71BQToAIRsL9EhcaWsdCgmZTRTTKAZpf+8GnJVp+FCIwqakfhFGEQuQry6QHQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(7916004)(4636009)(366004)(33716001)(54906003)(6916009)(316002)(2906002)(86362001)(44832011)(4744005)(38100700002)(38070700005)(122000001)(6486002)(508600001)(66446008)(1076003)(186003)(26005)(4326008)(71200400001)(8676002)(64756008)(66476007)(91956017)(76116006)(6506007)(66556008)(66946007)(5660300002)(7416002)(9686003)(6512007)(8936002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Mjg1a2QyRjQwbldjT0JsK2JLZEJYaGVNcURzOTllQVArbzgwbmM0VndDc0tx?=
 =?utf-8?B?bkEweTJ4eUVkWWhxNDVubGE1Wmp4RWpzc08zV0MzMTIyZGYreE84VFVOa0s3?=
 =?utf-8?B?T0ZXMjBNbUViVGVaVUtpaDlWZTZKRmxwVEZnZis1N0YvY2kvRHBTVFl1UFpq?=
 =?utf-8?B?M0hFbTJRbmRKdVM0UzlnYkx4b1RERWQ1R3JKYUhHaHNnazBBUGhUUzh5TExz?=
 =?utf-8?B?ZUhQTGNVUmpVSG90RWw0VUVGZHBYc3FJVFZtZzBJT24rWjdKWk9aOUV3SlBs?=
 =?utf-8?B?RVdEQlNCUDdtVG43d1RBN0pGNEl0dG5wNkJwcjlYMFJsVFRLNDBSczhmREFx?=
 =?utf-8?B?cXRUSUJsMjNKblZrV0k5MDJvanRCMWNHRTR6bmswK2laYlg4L3AySmEyK1dV?=
 =?utf-8?B?VmE1WWxvYTFIUnExTEZDYmQ4aTl2L2pMaU5wVU11aTllYTRZWUpIWklpdXcx?=
 =?utf-8?B?bmFkbDJrYVlqUlV1MExuZ29PbStFNnRhRm5hUDlFaFZjL2hCZVZHaWRUdGF0?=
 =?utf-8?B?SVJTR3dvVG0rcExHZllONHJsa3JFV1ZOQTRCZGFCQ0ZhVGVBdjBHVmFiVGVH?=
 =?utf-8?B?bnFSczJRNENMdWJMK3FmaUxpZlh2VkdrQjBXeEJPYjg5Tm5nb29iRWFleTYx?=
 =?utf-8?B?bTMrY0kzNUJ1OXdMSWw4N0wyN0FMMnNlb1hRQ2pudTVDM09Lek4xTFRqWmZS?=
 =?utf-8?B?RDlRdkk1WjVsb0Y5Q0tIRU5qdHFsVCt2OUx3UFFiMjRRa3ZwbDQ1RGRZUDIr?=
 =?utf-8?B?SGg0cmZ0NjVOQ2tiQ3htOHVRdG90NUdYaFhOMks1b3dpY2V4OFZDbVoxeFFN?=
 =?utf-8?B?a05McUI3WVpLQS9pdHFHOGc0NlY1R3M5RllsYXVzTHA1RnIwOTB3Yi9QWDlG?=
 =?utf-8?B?SWo1N3U4SXVoVVNXdWtJWlpETWpJVzQzT0RhaTZ5bjRsQUs0V25vVU9wN2hU?=
 =?utf-8?B?WmE1NkpQWWFYY2Exc2VQOEZ2UlFyTW5JeDhUOFJRNVpXSWxaZHQ4NUtTN3Z2?=
 =?utf-8?B?bUtHei8vdGl0OVRxZERUWUlNZkpSbkJxc2J3bjA1U0g5TXFvc3ByTUVlYTBD?=
 =?utf-8?B?QnR3UDNZeElyaTdXNGNVSHRJWVpKMVBiem04ZVZMaXdVT0d1a3BzSkUzNkMw?=
 =?utf-8?B?dTV5ZlZZbTBuWTVHR3A0VDNWZ1FQRE0xN3FSVEpjcmJZd2JjNWUyWWFkVWpV?=
 =?utf-8?B?cENhRHViVGtzYkdyNGlxUmZ0elFKY0tib0YzUzgreGU0ZjI1VGlnK25wUEcx?=
 =?utf-8?B?bFNHTkw0T1JGcHBva2h0ZGN5cFhDM3pIVXNWVVM1bTFlRWpmc1ZTc0w2Tnhp?=
 =?utf-8?B?Ri9Fa2JDS2VnYkNkOVduUHZBSzlweDhPZFh0Vk4rNi94S0swaGtvOFNndnA3?=
 =?utf-8?B?TERackorL0RWc1ZLSFNmb1RCWFhBM0NadkNuZ1VHWWN4ZW5aNmVEWXJ3bmhh?=
 =?utf-8?B?akFVYmMydTA2dXlremVXVEQzZUtjaEtHWXBhbU45SHNPZU1qcHd4dDZDQm4w?=
 =?utf-8?B?YlhURzRPeHkyUFNtZ05uL1l1cVZZQndtRVVnN1NaNW5LNGRFcEhFUWt2OEEz?=
 =?utf-8?B?TGUxK09ic0FwZnZaQWpEc09MYnEvNi9wdlNhc2lPMnB6MlhJNDNpMzBhb1Vx?=
 =?utf-8?B?K1d4cVBFQWVHeVlUblEwdjZQcnNxdUJzclZPVWdwRHQrVXd4VGtTODNpUzJV?=
 =?utf-8?B?Ym1xNUU0K2sxeTZqQUhHWVREcGROeXRIOTVKV1B5aHNxb1owRjJndVRtek9p?=
 =?utf-8?B?SExIa282b3RlZUJ4aC9zYUpxMkNLeDY4RkdGem9HeFB5dkRMdWpJdDY1TTJU?=
 =?utf-8?B?d1lCSWE4ZVlFd0w3Z2RHaVFPTnVSTVhKbWhoRmxmUE1CS0J3Z2pzcXk5SGQv?=
 =?utf-8?B?ZDU1Y1NUVjJJdVdLU0JHZS9yTlhYOWEyLy9sQzhiSXdma3BxMW44TklZM3p5?=
 =?utf-8?B?TEU3RVRtQ1ZMVGRrSkc2anI2ZEllUWJKd3dOU0NSQVdmRTBnLzZhMDNCL0p3?=
 =?utf-8?B?bDlVWGxsaENyU1lqQXNabzcwNFFxYzk3aEd3ckdoTm5nR01RUXh2d2lqVmZH?=
 =?utf-8?B?UksvVHd5emlsYm5wVXdGeDZEVm5CZmNlQlIxMjlBTHEwa1NNaHUvYy8wMU4z?=
 =?utf-8?B?MHpXenIwUWJyNithMFZYNkkwNkRibmFVcTE4T1djcHF6YmFGUzRHV3VsUXZI?=
 =?utf-8?Q?BkbhhtSJhUPUHxknl3u2vgM3O4v+kqO6DmRcXj9WGlUY?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7FD7AEFEC94B2243907970F018C03534@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64e95f8f-1f53-46ba-ff47-08d9f877f9ec
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Feb 2022 16:00:42.6085
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vi9bjlLKE7sS6DK3SnzVhGaRc70lxZz6TaoglvV60ZHpqE8hwDpBtUaNEsZidfzp5Cn2mg/b3solqCjANBMA+A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB5480
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDM6NTk6NDJQTSArMDAwMCwgUnVzc2VsbCBLaW5nIChP
cmFjbGUpIHdyb3RlOg0KPiBPbiBGcmksIEZlYiAyNSwgMjAyMiBhdCAwMzo0Njo1MFBNICswMDAw
LCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6DQo+ID4gT24gRnJpLCBGZWIgMjUsIDIwMjIgYXQgMDI6
MzU6MzFQTSArMDAwMCwgUnVzc2VsbCBLaW5nIChPcmFjbGUpIHdyb3RlOg0KPiA+ID4gVGhlIG9j
ZWxvdCBEU0EgZHJpdmVyIGRvZXMgbm90IG1ha2UgdXNlIG9mIHRoZSBzcGVlZCwgZHVwbGV4LCBw
YXVzZSBvcg0KPiA+ID4gYWR2ZXJ0aXNlbWVudCBpbiBpdHMgcGh5bGlua19tYWNfY29uZmlnKCkg
aW1wbGVtZW50YXRpb24sIHNvIGl0IGNhbiBiZQ0KPiA+ID4gbWFya2VkIGFzIGEgbm9uLWxlZ2Fj
eSBkcml2ZXIuDQo+ID4gPiANCj4gPiA+IFNpZ25lZC1vZmYtYnk6IFJ1c3NlbGwgS2luZyAoT3Jh
Y2xlKSA8cm1rK2tlcm5lbEBhcm1saW51eC5vcmcudWs+DQo+ID4gPiAtLS0NCj4gPiANCj4gPiBS
ZXZpZXdlZC1ieTogVmxhZGltaXIgT2x0ZWFuIDx2bGFkaW1pci5vbHRlYW5AbnhwLmNvbT4NCj4g
PiBUZXN0ZWQtYnk6IFZsYWRpbWlyIE9sdGVhbiA8dmxhZGltaXIub2x0ZWFuQG54cC5jb20+DQo+
IA0KPiBIaSBWbGFkaW1pciwNCj4gDQo+IFNoYWxsIEkgYXNzdW1lIHRoZSB0ZXN0ZWQtYnkgYXBw
bGllcyB0byBwYXRjaCAyIGFuZCAzIGFzIHdlbGw/DQo+IA0KPiBUaGFua3MuDQoNClllcy4=
