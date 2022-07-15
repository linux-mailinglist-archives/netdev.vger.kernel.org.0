Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98B99576706
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 21:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbiGOTAS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 15:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGOTAQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 15:00:16 -0400
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2060.outbound.protection.outlook.com [40.107.96.60])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CCE4E625;
        Fri, 15 Jul 2022 12:00:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNODM2sqwZ1CrZomqJcc3VJTfY01y0wNoIf4fNj7Tv1dVxAm9sKWuTFflzJpqwJnYMXh4lQ900lzpYdGRBefZjBnQfj9I5jWXiCyKXGIu+KDD9l2kJXFi2lqHRl0cmmnV8cdWdSai4wFY8gJGRNSy83LLqrAqq159WDf4acdekZITcwrGZIk0f2+NW/AhIYzrrDNIltN7SbuvYuwE6iTh7AdPHhXmTtA2C/vb14NjobotgoQGHYvlb86aG34LQI6/1ViK3oEezvnnxmixE6dkNVU5IbWYMDXMu/jaQCTObo/RplGh4V2ua1dMBupHNCYYZeIoCvOW31cHMt3ytkSNA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=E0c9cRgHIQo6vNTAsThYeT7U4HbKdIKLL3oJtlvZM0w=;
 b=WQ9NO8xQHVzKmX7N3uR3Puu1SyGr+r5JxG0vxeL27TjOph+mig2YUiccsLo3PXLcJkoK3wQZSwpshsmUh5GBF8fjjHK6qeR1j5285vK4O2tCgg3p5e0Sjdy9Wgqphf3aNjujnyOjRpnDmWTGEDksgGc1kbsm8ZiY05OvxZNmi4TSyJTA4k0dtfvFwbS6HR842TdRb2QhlCxFkqvisHJ+KNAQY3Ry/HBiEaCpEzztNVEXm1trRrJww/OmC7A/jC3vnllE3u9RYF2xLpnmLDTTtOwSjUh+m1fH/FMnMojqQcaoB9e2i12RwROHmegYhp8AqeuB0QZM5/2Vwb0TrjEEyQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=E0c9cRgHIQo6vNTAsThYeT7U4HbKdIKLL3oJtlvZM0w=;
 b=oNiKdQBMhFPH4DvUAtxUWGC+VBQH+PAQvLnSQGa3ZNsNWViteHFMeivf+jznHBXokpxJPSwZjnAyDLrTSRaEEcfBWZih9L3lvmJV8ib5rmhDG4C2p+0hePz3y+PadOg/vaafSYvcpY6Jz2cr8aqJv9OzKIct0SkDC2K0YeaacEQ=
Received: from MN0PR12MB5953.namprd12.prod.outlook.com (2603:10b6:208:37c::15)
 by MN0PR12MB6031.namprd12.prod.outlook.com (2603:10b6:208:3cd::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5417.26; Fri, 15 Jul
 2022 19:00:12 +0000
Received: from MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4]) by MN0PR12MB5953.namprd12.prod.outlook.com
 ([fe80::bd1b:8f4b:a587:65e4%3]) with mapi id 15.20.5438.014; Fri, 15 Jul 2022
 19:00:12 +0000
From:   "Pandey, Radhey Shyam" <radhey.shyam.pandey@amd.com>
To:     Saravana Kannan <saravanak@google.com>
CC:     Andrew Lunn <andrew@lunn.ch>,
        "nicolas.ferre@microchip.com" <nicolas.ferre@microchip.com>,
        "claudiu.beznea@microchip.com" <claudiu.beznea@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "git (AMD-Xilinx)" <git@amd.com>
Subject: RE: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Topic: [PATCH net-next v2] net: macb: In shared MDIO usecase make MDIO
 producer ethernet node to probe first
Thread-Index: AQHYjLtb1TFGTzmc5Uq+BMzIcSbNRq1pPD4AgAbloJCAAAbUAIAPrYYA
Date:   Fri, 15 Jul 2022 19:00:12 +0000
Message-ID: <MN0PR12MB59539E587A8B46FDC190FB7AB78B9@MN0PR12MB5953.namprd12.prod.outlook.com>
References: <1656618906-29881-1-git-send-email-radhey.shyam.pandey@amd.com>
 <Yr66xEMB/ORr0Xcp@lunn.ch>
 <MN0PR12MB59531DFD084FA947084D91B6B7819@MN0PR12MB5953.namprd12.prod.outlook.com>
 <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com>
In-Reply-To: <CAGETcx_BUR3EPDLgp9v0Uk9N=8BtYRjFyhpJTQa9kEMHtkgdwQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 84e09100-6a43-4904-8b93-08da66943ef5
x-ms-traffictypediagnostic: MN0PR12MB6031:EE_
x-ld-processed: 3dd8961f-e488-4e60-8e11-a82d994e183d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: h8G4E3C3ier5CF27alFYqwwrXXfy8+9fzXyA/jw9T3tBRqFhSc6q7BCRgdsICFu8GHlUGpP8YfEa6M8Ius/C8uX2GNcR82JraYci54+K6vyxuItOH7g2tpqcPLf3vvz8o6Jd1QBk7nbEg4Tkw68JGkCj8pdb2w1cy3yJQbCXcxy7CYVq4pyilRIkaKB3YCClJYLxwT4Q89eBHAdJ+x/Sv3QDPGmhcpbWLgjzTGgbhq+13aWgtyMIXeDYMqUFPD2JqtBbl0CMBftZKQAOLzK8REh5ZCJfeLfbFcgXj/k6TU3OfWWY7hajhZLtswCqozKc0IWihvz4JSktertHshbjNv9Dxa9E8ub5qzFKAV+e5hmrLNLEQKpxCF7bv1gw9ZrSp07sO+2w28MjkK34O1ixtO/uDDwZp9XxUuULdbBEDD/xyRJNDt6bbq2EuonwXicitkc5iDb0pyReKUPaU/1B5x8AeJYb/Or2HObHwaQlp8cT7/2cgJQ9PN0if0QJ0kHfefxE6KlS6x848dcwI2j9r/wssDUx1oDxAWpNQguakjubm+Gq7gm3iogDPCJaYiadQ84Q/go6gJq7iipmbroPpt43JFiQyHjwhSizFiOHMrEyovYTHJNJEb9xn0Key25Rg//I5Wcnzlr4pWi9IGKjdqt5+bU+J4gh8P88AJRPWVU9UVFGdjwUNvW+cS6EadTJXICnDrbYp7XZrpZTOXH3JvwYqQr18DFkbblXslgLYYzDfzwAJDzUfBwWAEZ3BZK/vDNQyaqLq4+SebyAuWo3mNKEwvwXKIEepzmDIaMZm7yvwBtGenK55Z/tKvmyCn/F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB5953.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(396003)(136003)(376002)(346002)(366004)(39860400002)(478600001)(38100700002)(4326008)(86362001)(6506007)(122000001)(38070700005)(8676002)(71200400001)(76116006)(66446008)(7696005)(316002)(33656002)(66556008)(6916009)(66476007)(64756008)(54906003)(8936002)(41300700001)(7416002)(5660300002)(66946007)(52536014)(53546011)(2906002)(55016003)(83380400001)(9686003)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?c1JsM2drUmt1NUkyRlhISDBkbkRkZ1lpMWRKcUIxNnQ4aU13WEZkTW96ZjVi?=
 =?utf-8?B?cjZiYmxsQmFrc0VGRG1ZZW9iZFptdDc2TnN1d2trWVorSnhsN3RkODRpeS9a?=
 =?utf-8?B?Q0xSTDJTckp3ZTVJbEhxbHVRclNMcWl6MmRacndnMjg3cXU2WW5MV2E0ZVJk?=
 =?utf-8?B?dHVsR2ZhMG45VTM4M25HVFVibWlPaFdGbHNUK3BQdzY2MEdsY0xYR3JrN21X?=
 =?utf-8?B?TWRCTjhlVGh5cFgxdGpMWk9yQnB0ajlkVHFOVzBkVGJwd3NOVExOZnk5cXJq?=
 =?utf-8?B?NG4va3czOVhSTGhpaCtGNW5xM3pjK0gzMmJlWFJYQ3IrZXJMRjFJSnh4WWlL?=
 =?utf-8?B?ZnRrTzlzZmVsWTM2clVsRkc0YlQ0MFpNRlFNQ3dGejF0bVJFeXdXM0p1Tmgr?=
 =?utf-8?B?eTNwMXIxcUg5eHNaSENrNzFwOEJJcnNHaWIvQW1Jb1FJUlFKRTBUOXZFNjBz?=
 =?utf-8?B?RHNDNXBUREx1OWJwZk9OeGJEeFc5c0VYdVBEUUxBbzh4cE8rUFdFd2RqUC9T?=
 =?utf-8?B?UGpEbFptaTlIOS90ejR2eE1sZThhQlp4dForZExScmVJdlAyUFZkOU5UQjNL?=
 =?utf-8?B?SE81OHZqK2tqQkV2M3VRNWN5cXBOUk1aZG0rSUdZZmk5bVBpVlN3dzdQeUxT?=
 =?utf-8?B?TEs0bnpoZFZaMkhkcTU2cWhFT1JPM1dQL05lRW5hOEhvM1JTWmVrclhSdmxt?=
 =?utf-8?B?VUE5N1VkNVpTS0l5eEpXZTFEdDBTZHhOVWtUYVdwb1d6TFZVbmJ0dXp5ZHh4?=
 =?utf-8?B?OVRoN1pIVG9ob1hRVFR0RVNtV2JINkJ5bWRmYVM4RWhVOGJCSjNVN21uS3BK?=
 =?utf-8?B?NW5wZ3BkSGw0Q0l5VVVvNjJNMDBxS2NaRWxSV1lIaTVVdlNWdzNDWnpOUytN?=
 =?utf-8?B?aXNiSHZoS204dUhzeVErU3hNa1JKbHBMR1kvVm5rYXBpMGwxQmx1UllyTkZG?=
 =?utf-8?B?R2tCblZKSUdIMlVqVHBaRk5ISUs4RzJsNGpQNE10dkhaSC9zU3BuZjJ6cEs4?=
 =?utf-8?B?VXlGVHEzOFZqRktBSEw1LzhHQmo5UkpYTXRnVTVTL2dBMXFzMllBU3lmTHJX?=
 =?utf-8?B?U1AzKzNRc2ZWUVA1SkM2cDBUc2phVEM4cVpGYlVoaEhXanZ1TmZoaHFkeG9t?=
 =?utf-8?B?K2doTzFGemN6cUNYVk9RcHNsc0wxN1prTGxta3FJZHU0RUxtamF4SUhHMnlO?=
 =?utf-8?B?ZS9MUDRyd0ttZzJBNGlyTnJnOVB0TUJCNUlKeERYV29zQUd1WWUrZlpUMEhT?=
 =?utf-8?B?NVpBVjFFZUNkRHNmT1JEbk1waGFoY0F2Q2c3YUpHMTNRQTB5N2grdkhUSGFB?=
 =?utf-8?B?VlBYKzVtUEhRTktoTXQ4c1hkYzE3NUFXUTB0Si94bys1N1NlUzFVa2JMenRk?=
 =?utf-8?B?RFpGT1U4cXZTL25zR2xVOENDNjBQb2pMeHZYUXRQTVVDV0hpalNrSTRad1VZ?=
 =?utf-8?B?d0l6TU1TOFBoMlNmaTh6THJtT01CTUhSblZycFEyRlA2S05rUndubzhVcVVO?=
 =?utf-8?B?dTZpVGNTSFMzU0t3VEpXM2l4ZUpQc2hDRHZrY1IyUTg3TGh4R05peC95QVRM?=
 =?utf-8?B?b1YwV3pJem1vSjFXVVJGcTNnT3Y2andhemM4a3kxM3ZMTWRXUi96dDN0aHpk?=
 =?utf-8?B?bDZpRC9VQ0VsRW1zMExKQjkrQ0x0R2Fmc0RQU1o3Um9FaVBCRUEzZkkwNXlZ?=
 =?utf-8?B?OER4RkxPSGJrTDBCR2FmQi9wQjBWZi9kN1FmWVRLK2tGWmp6TTQzU3JFWDBt?=
 =?utf-8?B?Z1lKUHR1cnh4MG9TVnBFTGdsSjREbHVTYWdtZWRNUGgzUUZYTkErdjVkWUhP?=
 =?utf-8?B?YW9QdmtOOGxqblVBNkZtN0F3cW03UU85R3d0eXV2UnhFdmZCWWZtSlBEUzlC?=
 =?utf-8?B?VTB1NUcrTzNpem82L3ZtNVhqSEhPSU9CQS94aVpMemJGRGdzTjNNbllIdVZS?=
 =?utf-8?B?MTBVN0F3VmNTcHRJY2NaR1M4SkpWdTZMcDQvamhZNk5OcGxrcWlxUTZDVk1O?=
 =?utf-8?B?dENnVlF1M2xZOWtsb1hKK3FldXBLS2VzeTYyWXRKNHUrK0owN2R1RHpzcU9K?=
 =?utf-8?B?dVROeTZPS3Bmbm1YeGN2RXMyVk5mUVJueTM5RHlna3FFRVVHN1FJc0UvNHlj?=
 =?utf-8?B?RFBjbjJxcUIvYzhSdlB5WForajJxeS9wWGwxYU1mWUlJc21Dd05yanFQSWU3?=
 =?utf-8?Q?uUb0PF2URdwirBUGxEASQIs=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB5953.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 84e09100-6a43-4904-8b93-08da66943ef5
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jul 2022 19:00:12.3660
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0wZN41RWZLeOTNqnacq0H7VN/DkgrLea6OOQ3XGo5Iep5N2xYaFpANN6X42WR8NX
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR12MB6031
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBTYXJhdmFuYSBLYW5uYW4gPHNh
cmF2YW5ha0Bnb29nbGUuY29tPg0KPiBTZW50OiBXZWRuZXNkYXksIEp1bHkgNiwgMjAyMiAxMjoy
OCBBTQ0KPiBUbzogUGFuZGV5LCBSYWRoZXkgU2h5YW0gPHJhZGhleS5zaHlhbS5wYW5kZXlAYW1k
LmNvbT4NCj4gQ2M6IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IG5pY29sYXMuZmVycmVA
bWljcm9jaGlwLmNvbTsNCj4gY2xhdWRpdS5iZXpuZWFAbWljcm9jaGlwLmNvbTsgZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldDsNCj4gZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3JnOyBwYWJl
bmlAcmVkaGF0LmNvbTsNCj4gaGthbGx3ZWl0MUBnbWFpbC5jb207IGxpbnV4QGFybWxpbnV4Lm9y
Zy51azsNCj4gZ3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc7IHJhZmFlbEBrZXJuZWwub3JnOyBu
ZXRkZXZAdmdlci5rZXJuZWwub3JnOw0KPiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBn
aXQgKEFNRC1YaWxpbngpIDxnaXRAYW1kLmNvbT4NCj4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQt
bmV4dCB2Ml0gbmV0OiBtYWNiOiBJbiBzaGFyZWQgTURJTyB1c2VjYXNlIG1ha2UNCj4gTURJTyBw
cm9kdWNlciBldGhlcm5ldCBub2RlIHRvIHByb2JlIGZpcnN0DQo+IA0KPiBPbiBUdWUsIEp1bCA1
LCAyMDIyIGF0IDExOjQ5IEFNIFBhbmRleSwgUmFkaGV5IFNoeWFtDQo+IDxyYWRoZXkuc2h5YW0u
cGFuZGV5QGFtZC5jb20+IHdyb3RlOg0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gRnJvbTogQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPg0KPiA+ID4gU2Vu
dDogRnJpZGF5LCBKdWx5IDEsIDIwMjIgMjo0NCBQTQ0KPiA+ID4gVG86IFBhbmRleSwgUmFkaGV5
IFNoeWFtIDxyYWRoZXkuc2h5YW0ucGFuZGV5QGFtZC5jb20+DQo+ID4gPiBDYzogbmljb2xhcy5m
ZXJyZUBtaWNyb2NoaXAuY29tOyBjbGF1ZGl1LmJlem5lYUBtaWNyb2NoaXAuY29tOw0KPiA+ID4g
ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgZWR1bWF6ZXRAZ29vZ2xlLmNvbTsga3ViYUBrZXJuZWwub3Jn
Ow0KPiA+ID4gcGFiZW5pQHJlZGhhdC5jb207IGhrYWxsd2VpdDFAZ21haWwuY29tOyBsaW51eEBh
cm1saW51eC5vcmcudWs7DQo+ID4gPiBncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZzsgcmFmYWVs
QGtlcm5lbC5vcmc7DQo+IHNhcmF2YW5ha0Bnb29nbGUuY29tOw0KPiA+ID4gbmV0ZGV2QHZnZXIu
a2VybmVsLm9yZzsgbGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZzsgZ2l0DQo+ID4gPiAoQU1E
LVhpbGlueCkgPGdpdEBhbWQuY29tPg0KPiA+ID4gU3ViamVjdDogUmU6IFtQQVRDSCBuZXQtbmV4
dCB2Ml0gbmV0OiBtYWNiOiBJbiBzaGFyZWQgTURJTyB1c2VjYXNlDQo+ID4gPiBtYWtlIE1ESU8g
cHJvZHVjZXIgZXRoZXJuZXQgbm9kZSB0byBwcm9iZSBmaXJzdA0KPiA+ID4NCj4gPiA+IE9uIEZy
aSwgSnVsIDAxLCAyMDIyIGF0IDAxOjI1OjA2QU0gKzA1MzAsIFJhZGhleSBTaHlhbSBQYW5kZXkg
d3JvdGU6DQo+ID4gPiA+IEluIHNoYXJlZCBNRElPIHN1c3BlbmQvcmVzdW1lIHVzZWNhc2UgZm9y
IGV4LiB3aXRoIE1ESU8gcHJvZHVjZXINCj4gPiA+ID4gKDB4ZmYwYzAwMDApIGV0aDEgYW5kIE1E
SU8gY29uc3VtZXIoMHhmZjBiMDAwMCkgZXRoMCB0aGVyZSBpcyBhDQo+ID4gPiA+IGNvbnN0cmFp
bnQgdGhhdCBldGhlcm5ldCBpbnRlcmZhY2UoZmYwYzAwMDApIE1ESU8gYnVzIHByb2R1Y2VyIGhh
cw0KPiA+ID4gPiB0byBiZSByZXN1bWVkIGJlZm9yZSB0aGUgY29uc3VtZXIgZXRoZXJuZXQgaW50
ZXJmYWNlKGZmMGIwMDAwKS4NCj4gPiA+ID4NCj4gPiA+ID4gSG93ZXZlciBhYm92ZSBjb25zdHJh
aW50IGlzIG5vdCBtZXQgd2hlbiBHRU0wKGZmMGIwMDAwKSBpcyByZXN1bWVkDQo+IGZpcnN0Lg0K
PiA+ID4gPiBUaGVyZSBpcyBwaHlfZXJyb3Igb24gR0VNMCBhbmQgaW50ZXJmYWNlIGJlY29tZXMg
bm9uLWZ1bmN0aW9uYWwgb24NCj4gPiA+IHJlc3VtZS4NCj4gPiA+ID4NCj4gPiA+ID4gc3VzcGVu
ZDoNCj4gPiA+ID4gWyA0Ni40Nzc3OTVdIG1hY2IgZmYwYzAwMDAuZXRoZXJuZXQgZXRoMTogTGlu
ayBpcyBEb3duIFsNCj4gPiA+ID4gNDYuNDgzMDU4XSBtYWNiIGZmMGMwMDAwLmV0aGVybmV0OiBn
ZW0tcHRwLXRpbWVyIHB0cCBjbG9jaw0KPiB1bnJlZ2lzdGVyZWQuDQo+ID4gPiA+IFsgNDYuNDkw
MDk3XSBtYWNiIGZmMGIwMDAwLmV0aGVybmV0IGV0aDA6IExpbmsgaXMgRG93biBbDQo+ID4gPiA+
IDQ2LjQ5NTI5OF0gbWFjYiBmZjBiMDAwMC5ldGhlcm5ldDogZ2VtLXB0cC10aW1lciBwdHAgY2xv
Y2sNCj4gdW5yZWdpc3RlcmVkLg0KPiA+ID4gPg0KPiA+ID4gPiByZXN1bWU6DQo+ID4gPiA+IFsg
NDYuNjMzODQwXSBtYWNiIGZmMGIwMDAwLmV0aGVybmV0IGV0aDA6IGNvbmZpZ3VyaW5nIGZvcg0K
PiA+ID4gPiBwaHkvc2dtaWkgbGluayBtb2RlIG1hY2JfbWRpb19yZWFkIC0+IHBtX3J1bnRpbWVf
Z2V0X3N5bmMoR0VNMSkNCj4gaXQNCj4gPiA+ID4gcmV0dXJuIC0NCj4gPiA+IEVBQ0NFUyBlcnJv
ci4NCj4gPiA+ID4NCj4gPiA+ID4gVGhlIHN1c3BlbmQvcmVzdW1lIGlzIGRlcGVuZGVudCBvbiBw
cm9iZSBvcmRlciBzbyB0byBmaXggdGhpcw0KPiA+ID4gPiBkZXBlbmRlbmN5IGVuc3VyZSB0aGF0
IE1ESU8gcHJvZHVjZXIgZXRoZXJuZXQgbm9kZSBpcyBhbHdheXMNCj4gPiA+ID4gcHJvYmVkIGZp
cnN0IGZvbGxvd2VkIGJ5IE1ESU8gY29uc3VtZXIgZXRoZXJuZXQgbm9kZS4NCj4gPiA+ID4NCj4g
PiA+ID4gRHVyaW5nIE1ESU8gcmVnaXN0cmF0aW9uIGZpbmQgb3V0IGlmIE1ESU8gYnVzIGlzIHNo
YXJlZCBhbmQgY2hlY2sNCj4gPiA+ID4gaWYgTURJTyBwcm9kdWNlciBwbGF0Zm9ybSBub2RlKHRy
YXZlcnNlIGJ5ICdwaHktaGFuZGxlJyBwcm9wZXJ0eSkNCj4gPiA+ID4gaXMgYm91bmQuIElmIG5v
dCBib3VuZCB0aGVuIGRlZmVyIHRoZSBNRElPIGNvbnN1bWVyIGV0aGVybmV0IG5vZGUNCj4gcHJv
YmUuDQo+ID4gPiA+IERvaW5nIGl0IGVuc3VyZXMgdGhhdCBpbiBzdXNwZW5kL3Jlc3VtZSBNRElP
IHByb2R1Y2VyIGlzIHJlc3VtZWQNCj4gPiA+ID4gZm9sbG93ZWQgYnkgTURJTyBjb25zdW1lciBl
dGhlcm5ldCBub2RlLg0KPiA+ID4NCj4gPiA+IEkgZG9uJ3QgdGhpbmsgdGhlcmUgaXMgYW55dGhp
bmcgc3BlY2lmaWMgdG8gTUFDQiBoZXJlLiBUaGVyZSBhcmUNCj4gPiA+IEZyZWVzY2FsZSBib2Fy
ZHMgd2hpY2ggaGF2ZSBhbiBNRElPIGJ1cyBzaGFyZWQgYnkgdHdvIGludGVyZmFjZXMgZXRjLg0K
PiA+ID4NCj4gPiA+IFBsZWFzZSB0cnkgdG8gc29sdmUgdGhpcyBpbiBhIGdlbmVyaWMgd2F5LCBu
b3Qgc3BlY2lmaWMgdG8gb25lIE1BQw0KPiA+ID4gYW5kIE1ESU8gY29tYmluYXRpb24uDQo+ID4N
Cj4gPiBUaGFua3MgZm9yIHRoZSByZXZpZXcuICBJIHdhbnQgdG8gZ2V0IHlvdXIgdGhvdWdodHMg
b24gdGhlIG91dGxpbmUgb2YNCj4gPiB0aGUgZ2VuZXJpYyBzb2x1dGlvbi4gSXMgdGhlIGN1cnJl
bnQgYXBwcm9hY2ggZmluZSBhbmQgd2UgY2FuIGV4dGVuZA0KPiA+IGl0IGZvciBhbGwgc2hhcmVk
IE1ESU8gdXNlIGNhc2VzLyBvciBkbyB3ZSBzZWUgYW55IGxpbWl0YXRpb25zPw0KPiA+DQo+ID4g
YSkgRmlndXJlIG91dCBpZiB0aGUgTURJTyBidXMgaXMgc2hhcmVkLiAgKG5ldyBiaW5kaW5nIG9y
IHJldXNlDQo+ID4gZXhpc3RpbmcpDQo+ID4gYikgSWYgdGhlIE1ESU8gYnVzIGlzIHNoYXJlZCBi
YXNlZCBvbiBEVCBwcm9wZXJ0eSB0aGVuIGZpZ3VyZSBvdXQgaWYNCj4gPiB0aGUgTURJTyBwcm9k
dWNlciBwbGF0Zm9ybSBkZXZpY2UgaXMgcHJvYmVkLiBJZiBub3QsIGRlZmVyIE1ESU8NCj4gPiBj
b25zdW1lciBNRElPIGJ1cyByZWdpc3RyYXRpb24uDQo+IA0KPiBSYWRoZXksDQo+IA0KPiBJIHRo
aW5rIEFuZHJldyBhZGRlZCBtZSBiZWNhdXNlIGhlJ3MgcG9pbnRpbmcgeW91IHRvd2FyZHMgZndf
ZGV2bGluay4NCj4gDQo+IEFuZHJldywNCj4gDQo+IEkgaGF2ZSBpbnRlbnRpb25hbGx5IG5vdCBh
ZGRlZCBwaHktaGFuZGxlIHN1cHBvcnQgdG8gZndfZGV2bGluayBiZWNhdXNlIGl0DQo+IHdvdWxk
IGFsc28gcHJldmVudCB0aGUgZ2VuZXJpYyBkcml2ZXIgZnJvbSBiaW5kaW5nL2NhdXNlIGlzc3Vl
cyB3aXRoIERTQS4gSQ0KPiBoYXZlIHNvbWUgaGlnaCBsZXZlbCBpZGVhcyBvbiBmaXhpbmcgdGhh
dCBidXQgaGF2ZW4ndCBnb3R0ZW4gYXJvdW5kIHRvIGl0IHlldC4NClRoYW5rcywganVzdCB3YW50
IHRvIHVuZGVyc3RhbmQgb24gaW1wbGVtZW50YXRpb24gd2hlbiBwaHktaGFuZGxlIHN1cHBvcnQg
aXMNCmFkZGVkIHRvIGZ3X2RldmxpbmsuIERvZXMgaXQgZW5zdXJlIHRoYXQgc3VwcGxpZXIgbm9k
ZSBpcyBwcm9iZWQgZmlyc3Q/IE9yIGl0IHVzZXMNCmRldmljZV9saW5rIGZyYW1ld29yayB0byBz
cGVjaWZ5IHN1c3BlbmQvcmVzdW1lIGRlcGVuZGVuY3kgYW5kIGRvbid0IGNhcmUNCm9uIGNvbnN1
bWVyL3Byb2R1Y2VyIHByb2JlIG9yZGVyLg0KIA0KPiANCj4gLVNhcmF2YW5hDQo=
