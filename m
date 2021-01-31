Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14149309AE3
	for <lists+netdev@lfdr.de>; Sun, 31 Jan 2021 08:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbhAaHIl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 02:08:41 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24500 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhAaHIh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 02:08:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1612076917; x=1643612917;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=xi3HqIGXioHVzded6mWmZHW2kRzCr+ay/BG0gvu5wbI=;
  b=JHNwGHPo64rUikj4UCMYOPRPKivwzYz+TW7TcvS557yxGJ1wx0fLXgXv
   T2MNSe/tHNY8WJnBHAzjNvK67pA79SHLIpIEkCDKA/g3YFqXJuGcqo7GY
   oozDzyg309oCtqFxpVxtBC984TfAi4RSlStnDuP1RyluvASh176XroBvl
   jLSzmV6Ei9E/BxugAZeK/+R3M5stWf6gqiw+EtOvte1Ykr58T7QecFxbF
   Z/ubiO18LDc+ekYlouIwao+QoaCj824xV6NKbV8hsJTo7HtKj8vMo2jG7
   PwuShi9Hvs3F6Og5WjuJbhNEQwQ1PL7+3tUtOWOZ2+YLanMwHVHN+XBVG
   g==;
IronPort-SDR: GDHARS/N3oIarMfHD3sC6eptPCu6Rz6k8ZgP9O+WH8t4vuJA1Ow7YHurr3WMeKZFVb67QcQRLM
 knXo3TVkLVZU+fgs3/+SSfpsWaP1jtIjQp6Rgn/+3NnncDBs1ck4PlqDTZe4WsMxeAqFSYX308
 zfU6SjhVitLXRvYTtvYzBmmiviuB7cqLH+c2UO9MCeSKvoKSPUnnx4fnhAFF4Cy+yfkaDwAyiU
 0/FBAC3ZMgZHvZdeni/B6vVrAFllieWUhe99rPoG2RBmGo0RDiT7RuCoWpjpvWauwO+TziL4eO
 K/8=
X-IronPort-AV: E=Sophos;i="5.79,389,1602572400"; 
   d="scan'208";a="107915642"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2021 00:06:55 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sun, 31 Jan 2021 00:06:55 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3
 via Frontend Transport; Sun, 31 Jan 2021 00:06:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=chi7wLRBWBYXqNM9xr3Th/UERYsZH2RhucRrx/dwMKZ8BHqrCasNicoe/Ga8uI3XBPmiepS4KKfPmmoPm3bulOKx3Ej7KQHAWQbfcXAACfcIJN95Puzn3j+EZmYKaWIizJPwNmlyWOTI4yDwHnE2EcxmkmmXgr0XTXYQdcx88yX6NgVMiSA/XhGDgAGIGOr8sxFRi/0Yo8bAQlcd6DcMvis0Kh1ofmENC/dyWZcyhpxbWVgrhiXOE12APXhpjOwSacHM923YlZT06IVzbRc68WD9e85SIWojmBLkE8X0KStmHix+/Gdoj21/67rna5NhR7SeOT6HHdtPGrv+nahdKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xi3HqIGXioHVzded6mWmZHW2kRzCr+ay/BG0gvu5wbI=;
 b=gIAYu0AYKfV6sSfUsRCmUF9WkTpFMHf/HVqqXGyq4IJdX9/4c+5XnJXl+j4FewOtW2DO+yCsNEauBJsw9wODGNbriV3zWiaUwT0ZulR5qxSIRKOzK4Bxl/DCiTwJhR3+YBxDxIC6AxraYhxdnoytALZ1t8mGtGit4WaBHiaq14KF1tCLym6XqBejxsbG6T/M7VrdWWkisRfR4l2h7YcfZLOYRBK5iFeL8QwNk/rVMIy3RXSh1I+Uc5Z2Vp8D7KDUgV48Y+uaMIY3ux14aVdQQOhCBq5E8bZPnhVbZ9fwXlSFTlVf3rH2xfff7VGBh487en/1uFnAmytF73zjNW38iw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xi3HqIGXioHVzded6mWmZHW2kRzCr+ay/BG0gvu5wbI=;
 b=anedNxOxTDIn3lMjp9gapUcubfFi66MQv8zbuT5aENjGJwebGVhGXcE0uqHcuWCGavJ79mMD4qz5hBa7D7rCoPOgn/mdlSS2WdLL1chPotbOCVn6gnmbDdzE3i5ySkMBCvuXdg+sDlv6+Orvn3d7+CeVoN+yElcayYXA5EogvLM=
Received: from MN2PR11MB3662.namprd11.prod.outlook.com (2603:10b6:208:ee::11)
 by MN2PR11MB3679.namprd11.prod.outlook.com (2603:10b6:208:f1::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.17; Sun, 31 Jan
 2021 07:06:53 +0000
Received: from MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584]) by MN2PR11MB3662.namprd11.prod.outlook.com
 ([fe80::20a8:8a27:a512:d584%2]) with mapi id 15.20.3805.021; Sun, 31 Jan 2021
 07:06:53 +0000
From:   <Bryan.Whitehead@microchip.com>
To:     <thesven73@gmail.com>, <UNGLinuxDriver@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>
CC:     <andrew@lunn.ch>, <rtgbnm@gmail.com>, <sbauer@blackbox.su>,
        <tharvey@gateworks.com>, <anders@ronningen.priv.no>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Topic: [PATCH net-next v1 2/6] lan743x: support rx multi-buffer packets
Thread-Index: AQHW9nhaCkvjLk51A0iB0GiaIb00V6pBUlxw
Date:   Sun, 31 Jan 2021 07:06:53 +0000
Message-ID: <MN2PR11MB3662C081B6CDB8BC1143380FFAB79@MN2PR11MB3662.namprd11.prod.outlook.com>
References: <20210129195240.31871-1-TheSven73@gmail.com>
 <20210129195240.31871-3-TheSven73@gmail.com>
In-Reply-To: <20210129195240.31871-3-TheSven73@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [47.19.18.123]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8d52ee88-0c3f-4533-9db5-08d8c5b6c9fe
x-ms-traffictypediagnostic: MN2PR11MB3679:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB367919D961421DB498044724FAB79@MN2PR11MB3679.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BLgLAZamcVartvftnyuLfz+NNwQqCyXJaYa3MdtF3aCx8220NQwCjJjg4IQjI9MmPSByG/5C5I3PgsHp1+GsXFBWW7O3HzRrRs91+gnRvk9fQ5JBVSH2pwjvGvzqjUdMuek3QLhkj6dokxpyI937XF1dCoFopzyLyB7nGsfFhwLi8Rki4ZuN8sJbA8xkkUMYmaYh/LijIsoiQ006jNszNnOS/9o9p+VPiw2zk42ZUvBVgRUjnXIcHZiq6O5DmItXhjl0Zrh1O+OxpAN+OaQF0M/f7quxYPxuWf/ogOvSu6Osq4kEAhxwoITYxlDQqDLWyt2QjVdTPJMwkCQ4i/JJn8KYQd8T3KGuRQK1+Yi4/LuJOOYLx6RDDPUb3BoaQ5CNfvMMc1K5qkYDBz0hmYHeOqi0r/An15qY+Zev9Pv4V+FVy4Mng5Rd9MLIa3sDjKpM7SP0Ot3gMZSBkwCh32idmpOrPhiFv9lq/EpiBVD3bqA3K85OrH94bIXjYuNj/vPg2z6UH/LJubLlUDZv+E+99Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB3662.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(396003)(39850400004)(136003)(346002)(6506007)(33656002)(4326008)(52536014)(55016002)(54906003)(66946007)(9686003)(76116006)(66476007)(66556008)(110136005)(316002)(71200400001)(26005)(2906002)(7696005)(66446008)(64756008)(86362001)(83380400001)(8676002)(478600001)(186003)(7416002)(8936002)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?dWd3VFRFWnZZY2cyVTdYdko2UWo1c1VUclluUkNHS2NibERJQjAxU3RBQWQ5?=
 =?utf-8?B?UkJ6WG5hbndWeDZUUnRxSjBaUE12SE5EaW42YjhFcGFTTE9wMkZyWndrNFo1?=
 =?utf-8?B?V3V1NmVsUW9qemwrSXVGRDR6akZURTRaWWJMUFZrdC85Vy85N2FMa2UzdlhQ?=
 =?utf-8?B?SWczcTdERFhkTHBKb05zcEQxVXpsSVppUnpTL1VqQjlBK3F1Rk92M0JyaHcw?=
 =?utf-8?B?QVp3THI2TWNra2NQeGxDSWR6VnhZTlVJM0ZSeWlscTJJYVZGZCtHeWJvMjV5?=
 =?utf-8?B?bEtMSWJ2TVJXcUlqQmVWMC9kMzZTQ3VjZUQ5ME1sRWR6Y014Vmd2cEtDME1X?=
 =?utf-8?B?Y2JxU0xHRFZuUzdJZkxCTHl5U1B2aU9HWG1JUElsYUNDbElkRmx3a0o2OHJy?=
 =?utf-8?B?ektKWGdCdEN5SGZkRk9OZSthMFRjSVkxL3VPVFRVSitTMncrdFRtbGRGVnU4?=
 =?utf-8?B?eG40eG9LajEvMWwweUU2TE1qdkZhZHlIZWhGbDMwbXVkMkRJeTlqWUdDdy9G?=
 =?utf-8?B?RytoRjNVWU1ja00xemVSdnRQdzc4dzlMcGllRmVvWTMzM0w4NWk2RjVHTnRn?=
 =?utf-8?B?Zmd0clhoODdubzRDQnZLamdhMFM2MHZxR2xSYUVzc2RCUkpidWw4MGNUQnJW?=
 =?utf-8?B?U3lyZ0wzRFdFTk8vVXBSQ01FbHBPQjMyV2QwV2ZobTBHdi9NOTBJYlExMXVI?=
 =?utf-8?B?VHA2M3Blb29iYkh2aU5tTndJK0ZDVHlVZVRTVjdYU0VJZTgwUGpLNWcxd2E3?=
 =?utf-8?B?eUhrNnZVbURRMWFsSk90TE9KWFhPRmpybFZtcGNqRWNqK0E3M1RkWngza0Zw?=
 =?utf-8?B?ejFQTEpmTmxMZGNDWHZsNU56VHlLN1Zia3hSakVQN1Y2RE1KenQ2TW9zajNS?=
 =?utf-8?B?UEdkYyswYVphenMyRDRvaklCRnpmVnAxV3JzYU53VTJRKzFxcGU3c3lBMW1i?=
 =?utf-8?B?TUd1Q2IrelQ1VHdCT3NKazFMbE02eTNPZ3hvVXFHVVBoOVRHeXlPWlFvRjFK?=
 =?utf-8?B?Y0cvWk93bkpsdTZMRVlzZnVTcnZXalRybWU2a0hTelBMWjNwd01OVzJmSCtl?=
 =?utf-8?B?YkJGd0I4VFNmOVlrdUk2TWo3RmwzeVlheG8vNjlWckRMb0lvNnk5RUwrV0ZL?=
 =?utf-8?B?a3Y3UjZRRmE2SGgwT1p5SlVrVVNyZ1lzV2tKbGZtNjhKcUlFQTZsTmdwVHVp?=
 =?utf-8?B?U0MxM0JVZXBTNWM0amQ1OEsyMXU4UXJHekNNMFlkdnZqczRNSzQ4dEpBdTJY?=
 =?utf-8?B?T1FJVTk0Y3NzRW5GY1FMc1ZOK2l4YlRwZy9nalRmNjQ4RmFpVHlOSGpqRFh6?=
 =?utf-8?B?UkUycDVlbkd0eWpUMDlSa2xCdjBtTVJjRXgxN3FwTFdNMTlCV3dwdHFSbmRn?=
 =?utf-8?B?MjNKdEdheEdsNEkyM3NXYUVMZnpqMXZPTXdjVWRsOXFUc050N0RuLzQxN3E5?=
 =?utf-8?Q?ExUmOXGC?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB3662.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d52ee88-0c3f-4533-9db5-08d8c5b6c9fe
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2021 07:06:53.5572
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IaJB7SWRdeS1yYyUJoHqJc+0FhE/GKqw8JbG/HEv4e6F2VJdjP5J8gaQoe/X++enB/g4m5LL+IYgbGPyDq2mSQpj+IjRF4cW8W+bKeUxzGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB3679
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgU3ZlbiwgDQoNCkxvb2tzIGdvb2QuDQpzZWUgY29tbWVudHMgYmVsb3cuDQoNCj4gIHN0YXRp
YyBpbnQgbGFuNzQzeF9yeF9wcm9jZXNzX3BhY2tldChzdHJ1Y3QgbGFuNzQzeF9yeCAqcngpICB7
DQpJdCBsb29rcyBsaWtlIHRoaXMgZnVuY3Rpb24gbm8gbG9uZ2VyIHByb2Nlc3NlcyBhIHBhY2tl
dCwgYnV0IHJhdGhlciBvbmx5IHByb2Nlc3NlcyBhIHNpbmdsZSBidWZmZXIuDQpTbyBwZXJoYXBz
IGl0IHNob3VsZCBiZSByZW5hbWVkIHRvIGxhbjc0M3hfcnhfcHJvY2Vzc19idWZmZXIsIHNvIGl0
IGlzIG5vdCBtaXNsZWFkaW5nLg0KDQouLi4NCj4gKyAgICAgICAvKiB1bm1hcCBmcm9tIGRtYSAq
Lw0KPiArICAgICAgIGlmIChidWZmZXJfaW5mby0+ZG1hX3B0cikgew0KPiArICAgICAgICAgICAg
ICAgZG1hX3VubWFwX3NpbmdsZSgmcngtPmFkYXB0ZXItPnBkZXYtPmRldiwNCj4gKyAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgYnVmZmVyX2luZm8tPmRtYV9wdHIsDQo+ICsgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIGJ1ZmZlcl9pbmZvLT5idWZmZXJfbGVuZ3RoLA0KPiAr
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBETUFfRlJPTV9ERVZJQ0UpOw0KPiArICAg
ICAgICAgICAgICAgYnVmZmVyX2luZm8tPmRtYV9wdHIgPSAwOw0KPiArICAgICAgICAgICAgICAg
YnVmZmVyX2luZm8tPmJ1ZmZlcl9sZW5ndGggPSAwOw0KPiArICAgICAgIH0NCj4gKyAgICAgICBz
a2IgPSBidWZmZXJfaW5mby0+c2tiOw0KPiANCj4gLXByb2Nlc3NfZXh0ZW5zaW9uOg0KPiAtICAg
ICAgICAgICAgICAgaWYgKGV4dGVuc2lvbl9pbmRleCA+PSAwKSB7DQo+IC0gICAgICAgICAgICAg
ICAgICAgICAgIGRlc2NyaXB0b3IgPSAmcngtPnJpbmdfY3B1X3B0cltleHRlbnNpb25faW5kZXhd
Ow0KPiAtICAgICAgICAgICAgICAgICAgICAgICBidWZmZXJfaW5mbyA9ICZyeC0+YnVmZmVyX2lu
Zm9bZXh0ZW5zaW9uX2luZGV4XTsNCj4gLQ0KPiAtICAgICAgICAgICAgICAgICAgICAgICB0c19z
ZWMgPSBsZTMyX3RvX2NwdShkZXNjcmlwdG9yLT5kYXRhMSk7DQo+IC0gICAgICAgICAgICAgICAg
ICAgICAgIHRzX25zZWMgPSAobGUzMl90b19jcHUoZGVzY3JpcHRvci0+ZGF0YTIpICYNCj4gLSAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFJYX0RFU0NfREFUQTJfVFNfTlNfTUFTS18p
Ow0KPiAtICAgICAgICAgICAgICAgICAgICAgICBsYW43NDN4X3J4X3JldXNlX3JpbmdfZWxlbWVu
dChyeCwgZXh0ZW5zaW9uX2luZGV4KTsNCj4gLSAgICAgICAgICAgICAgICAgICAgICAgcmVhbF9s
YXN0X2luZGV4ID0gZXh0ZW5zaW9uX2luZGV4Ow0KPiAtICAgICAgICAgICAgICAgfQ0KPiArICAg
ICAgIC8qIGFsbG9jYXRlIG5ldyBza2IgYW5kIG1hcCB0byBkbWEgKi8NCj4gKyAgICAgICBpZiAo
bGFuNzQzeF9yeF9pbml0X3JpbmdfZWxlbWVudChyeCwgcngtPmxhc3RfaGVhZCkpIHsNCg0KSWYg
bGFuNzQzeF9yeF9pbml0X3JpbmdfZWxlbWVudCBmYWlscyB0byBhbGxvY2F0ZSBhbiBza2IsDQpU
aGVuIGxhbjc0M3hfcnhfcmV1c2VfcmluZ19lbGVtZW50IHdpbGwgYmUgY2FsbGVkLg0KQnV0IHRo
YXQgZnVuY3Rpb24gZXhwZWN0cyB0aGUgc2tiIGlzIGFscmVhZHkgYWxsb2NhdGVkIGFuZCBkbWEg
bWFwcGVkLg0KQnV0IHRoZSBkbWEgd2FzIHVubWFwcGVkIGFib3ZlLg0KDQpBbHNvIGlmIGxhbjc0
M3hfcnhfaW5pdF9yaW5nX2VsZW1lbnQgZmFpbHMgdG8gYWxsb2NhdGUgYW4gc2tiLg0KVGhlbiBj
b250cm9sIHdpbGwganVtcCB0byBwcm9jZXNzX2V4dGVuc2lvbiBhbmQgdGhlcmVmb3INCnRoZSBj
dXJyZW50bHkgcmVjZWl2ZWQgc2tiIHdpbGwgbm90IGJlIGFkZGVkIHRvIHRoZSBza2IgbGlzdC4N
CkkgYXNzdW1lIHRoYXQgd291bGQgY29ycnVwdCB0aGUgcGFja2V0PyBPciBhbSBJIG1pc3Npbmcg
c29tZXRoaW5nPw0KDQouLi4NCj4gLSAgICAgICAgICAgICAgIGlmICghc2tiKSB7DQo+IC0gICAg
ICAgICAgICAgICAgICAgICAgIHJlc3VsdCA9IFJYX1BST0NFU1NfUkVTVUxUX1BBQ0tFVF9EUk9Q
UEVEOw0KSXQgbG9va3MgbGlrZSB0aGlzIHJldHVybiB2YWx1ZSBpcyBubyBsb25nZXIgdXNlZC4N
CklmIHRoZXJlIGlzIG5vIGxvbmdlciBhIGNhc2Ugd2hlcmUgYSBwYWNrZXQgd2lsbCBiZSBkcm9w
cGVkIA0KdGhlbiBtYXliZSB0aGlzIHJldHVybiB2YWx1ZSBzaG91bGQgYmUgZGVsZXRlZCBmcm9t
IHRoZSBoZWFkZXIgZmlsZS4NCg0KLi4uIA0KPiAgbW92ZV9mb3J3YXJkOg0KPiAtICAgICAgICAg
ICAgICAgLyogcHVzaCB0YWlsIGFuZCBoZWFkIGZvcndhcmQgKi8NCj4gLSAgICAgICAgICAgICAg
IHJ4LT5sYXN0X3RhaWwgPSByZWFsX2xhc3RfaW5kZXg7DQo+IC0gICAgICAgICAgICAgICByeC0+
bGFzdF9oZWFkID0gbGFuNzQzeF9yeF9uZXh0X2luZGV4KHJ4LCByZWFsX2xhc3RfaW5kZXgpOw0K
PiAtICAgICAgIH0NCj4gKyAgICAgICAvKiBwdXNoIHRhaWwgYW5kIGhlYWQgZm9yd2FyZCAqLw0K
PiArICAgICAgIHJ4LT5sYXN0X3RhaWwgPSByeC0+bGFzdF9oZWFkOw0KPiArICAgICAgIHJ4LT5s
YXN0X2hlYWQgPSBsYW43NDN4X3J4X25leHRfaW5kZXgocngsIHJ4LT5sYXN0X2hlYWQpOw0KPiAr
ICAgICAgIHJlc3VsdCA9IFJYX1BST0NFU1NfUkVTVUxUX1BBQ0tFVF9SRUNFSVZFRDsNCg0KU2lu
Y2UgdGhpcyBmdW5jdGlvbiBoYW5kbGVzIG9uZSBidWZmZXIgYXQgYSB0aW1lLA0KICBUaGUgcmV0
dXJuIHZhbHVlIFJYX1BST0NFU1NfUkVTVUxUX1BBQ0tFVF9SRUNFSVZFRCBpcyBub3cgbWlzbGVh
ZGluZy4NCiAgQ2FuIHlvdSBjaGFuZ2UgaXQgdG8gUlhfUFJPQ0VTU19SRVNVTFRfQlVGRkVSX1JF
Q0VJVkVELg0KDQoNCg==
