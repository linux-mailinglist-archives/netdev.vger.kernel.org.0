Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 637862FBB33
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 16:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391461AbhASP2s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 10:28:48 -0500
Received: from mga12.intel.com ([192.55.52.136]:26687 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391515AbhASPZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 10:25:24 -0500
IronPort-SDR: 4wvkH/OScUW7r0uMf7o3JbECaqZxmnXs4QNdZ9H0mX80fbzpAwtF6NvP/TlaE47xYNVYtptlyU
 voIHaq26qDsQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="158122681"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="158122681"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 07:24:39 -0800
IronPort-SDR: mgc2T7PC729NsRGTPxqv0Fz0i/zpuxO2bzhNHMaPm+Dz+E5wa2pdaiophS1vFfm09bxCiF+SlE
 DsINY5VwAMRA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="466732319"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga001.fm.intel.com with ESMTP; 19 Jan 2021 07:24:38 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Jan 2021 07:24:38 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Jan 2021 07:24:37 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 19 Jan 2021 07:24:37 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 19 Jan 2021 07:24:34 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fCzGuOkQXUFNDW7BSDan7m2NZj/6E1YLvEQnmWg1k6F2ZpQ+wF/uG9vCLPia3JpCDjqJdjL0FjNiVnT6nUqRzPy3DtfqTKji/Ga+90mKJtzeW8oI8XH0At0S6I3NV28cGqQWSCoWX4JPwz6Y0F01qEaneBZhYxySCp744uHHbY1tlSEJpVb9EPpNxTJFidof5X05vqgaHHoXIIUU69CCgTRzbe14//zXz9XapMnMAIBLpzblqNjvXey7ejzjA6U0w25dXlqn8/v9QyqQzh21+H9C8J7FCG7oE4RX2rzSgzi3v+ZHR3Eh/YCNe0RafqeL6VPkxLN3mOphEU4CTBRdZg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5mIp4jvmbExteDv9QR3+7fghr6FuxD8+DPvk452OE0=;
 b=D6q5rS/V/KQJRvU8FCZHvB1Rt5TZydywxMY9F7AOqT7Jmnnv0akMvmw2JxIGvaBR99tz2FLtxlp4tXeD7bNXRe8QG9ErinYTcO9sOBGdm3+mTxQ9jcvx9UYLQ8GOPO9w0T2qsynXWrNIc/zA3B8Qa4CcRumm3pJnRG9TP2PrUApkniA34TiXltJ1JuFvpt+yD5oazzWRiVpZmxCeRoIEEJJzGHzlxVl2sq9WGA8V+HyiepsL9vsLoPg20OHsQOBB6CEqoBp7768ZTmcV/nVhlchnVCWU7M8eZr8wBbVsjGSiN+K8KeBXpzs48h0r340G6ew6AbfcFYd3sArcJfOJ3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5mIp4jvmbExteDv9QR3+7fghr6FuxD8+DPvk452OE0=;
 b=ZCze8A3WleCwXL5IuHK2p0ulS6piEbHO274xmn8ZYMQ2TgiDfmLD4HYJnZyiF5oEOBcmZvySrBObXzu5a6/MwdoCSQCeqClMI7pUL4xolZMwsQqxXGffQON4CVbVfP1t8YWFH57slHxB4WCdEd4OIDOTUmzKfVd+gUNayXmTJBo=
Received: from BN7PR11MB2610.namprd11.prod.outlook.com (2603:10b6:406:ab::31)
 by BN6PR11MB1923.namprd11.prod.outlook.com (2603:10b6:404:107::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.12; Tue, 19 Jan
 2021 15:24:31 +0000
Received: from BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c]) by BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 15:24:31 +0000
From:   "Peer, Ilan" <ilan.peer@intel.com>
To:     Hans de Goede <hdegoede@redhat.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Rojewski, Cezary" <cezary.rojewski@intel.com>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Liam Girdwood <liam.r.girdwood@linux.intel.com>,
        Jie Yang <yang.jie@linux.intel.com>,
        "Mark Brown" <broonie@kernel.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>
Subject: RE: [PATCH] cfg80211: Fix "suspicious RCU usage in
 wiphy_apply_custom_regulatory" warning/backtrace
Thread-Topic: [PATCH] cfg80211: Fix "suspicious RCU usage in
 wiphy_apply_custom_regulatory" warning/backtrace
Thread-Index: AQHW4rwYhFgUlszMR0OBRT1c2rvcL6oYwsJQgBU0EYCAATHogA==
Date:   Tue, 19 Jan 2021 15:24:30 +0000
Message-ID: <BN7PR11MB261074B2F2CB613C17354F1DE9A30@BN7PR11MB2610.namprd11.prod.outlook.com>
References: <20210104170713.66956-1-hdegoede@redhat.com>
 <BN7PR11MB2610DDFBC90739A9D1FAED52E9D10@BN7PR11MB2610.namprd11.prod.outlook.com>
 <391ac436-9981-0f12-6e00-7a1bbe4d5c20@redhat.com>
In-Reply-To: <391ac436-9981-0f12-6e00-7a1bbe4d5c20@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [147.236.145.30]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca36ab43-beb9-4ccd-e4de-08d8bc8e5187
x-ms-traffictypediagnostic: BN6PR11MB1923:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB1923B47B47C0F71C0FDE304BE9A30@BN6PR11MB1923.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:529;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: f8onijNReK/9sC/DQfYUzobc2+AgbQNXBK6tOxNxP5qneXutxfijR51DyHiHWeFKgu1rVSoYOMaWkEVH5dbndf3+dDjVt7bgzwRk4900jjr72/dyR+EYzPA5cmg1PZMmnJCMQK4aUVGcBU4OLECff156mZbrRekAX76h22y0z/Sp3oUBGfOgrwwKDZAphzS1LZAfmetcHpgrKAUT+12iL1KfajsqjVow3HIGX2nFryRVZVAUBi5cTAMVX8bu3gMkX5niiryHIv4npdCh/jFJPHekkUHq4cpl3nGbjXiS1h2pQNepdXEO37rlRM3y4J5+PcfEFb2amjy+34upsHD4F0P8Hb3JgAj6LQ6Y4liZ2UueExVzdsRkaXkKbRZe7/knTnYNQdYSsDZGyzQV2pJA+IhOZEEVZeT4fdWrCjiGa4H3EBdeUKAJfSTw8ZnKlCadIpzJ4wsEX4Jz+YnEJMkWgVYgBb/NG+Inaf+/5vMkxo2Jr3dcx0Mznbajbg/EQXJc84B0xS7reT7TX8tVKZjunQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2610.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(396003)(376002)(366004)(39860400002)(136003)(110136005)(71200400001)(86362001)(54906003)(186003)(2906002)(316002)(7696005)(83380400001)(8936002)(8676002)(76116006)(921005)(53546011)(64756008)(66556008)(33656002)(478600001)(6506007)(66946007)(5660300002)(66446008)(9686003)(66476007)(966005)(26005)(52536014)(4326008)(55016002)(7416002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?di9LUDRDWlRwUFlXT0tNdjBxbEpSRm1VcEFBTTVzUEpFOUxIVE5Oc3JLaEcy?=
 =?utf-8?B?aW81UmZtQjFuRWlONDBVZU93ZzR4L3h5UVNtR25xTTJVWUlFeVZzRlNuTlNO?=
 =?utf-8?B?ZStobHpvdVE4aEdpZWI0Zzg2R1h5UzQ3ZERrOGhreHRrOVBSRHVVU0p3Nmlt?=
 =?utf-8?B?TE1pN29tUXpzQmJuMytSV0gxKzNYWjFjSUlTejViMURsNExRK2J2NzA5UUJM?=
 =?utf-8?B?NFlVelFndEh0UDhRZ3BoSHQ3eWJNdEhnc1dIV1NOVWY1c21sSHdHS25LV2Rs?=
 =?utf-8?B?cnA1RXNzTnkwNUliUzVaeHZpbU5JRmNNcjhncVBUK2UyV0duVHFXVnFUdlVH?=
 =?utf-8?B?bU1aWndlZGZwc3M4TCs4QU50WVVtZjRscW0wbVFnNTVoek5FWml5UDVQNktL?=
 =?utf-8?B?VmZMdUJpa3kyR2RweXFXd0xjb0NzaTh2S2hMMzMySmZLd0lvVTErOHh6UDFY?=
 =?utf-8?B?ODVVYzhpZ0J6TGZjWTZ1MklVMnFzNjhiYXkxR2tUU3JWZU5QeURPcmgrSi85?=
 =?utf-8?B?U0FHOWhUek5CS1M3M2dxcXFhc2R2MFd3Z2xKV2RNaDJrUXNldHZ5K3JvZFQ0?=
 =?utf-8?B?bmUrVUZtSWFZWC9vaENHYis2WVhNVmc2eTVDTEJEcnYydTEySXpJVlpaL1Rx?=
 =?utf-8?B?S3hjL0g3SUs1TUE4TXludEM1cjluWTNJVGtRYUxKRGo4WTQ3REY5RU9PZEVo?=
 =?utf-8?B?QmhVYjBiU1pMNGVwSnZoMERaRmg0Z1I0QjhIMjZ1cThYTWR3bU55ZlFSeXlF?=
 =?utf-8?B?all0UWFhcmx4ay81VExFd25TQ0ZOeHF3blJXL0FmNEc1Z0Q5NzgzWk5TMHR6?=
 =?utf-8?B?dmRMZzZiMjBnRmh1Z3ZNSml2cEY2bmhkb01GVzBkdTNOcE9mampUbDJvNTFD?=
 =?utf-8?B?Q0NRL2RIVzVrVEU1UG9VaVgweXptaEdaZGsvWkhjbWpLN0QwQm9tMEVMeTlX?=
 =?utf-8?B?MFdLNGJQQXdueTFGRG5FRU53bjFPclVLWG1mYWdwY2pJUEZCRkZ3Ylk2emQ1?=
 =?utf-8?B?djgzTUowanYyNk1pSHM2cFNTSmxFWmQ0QzFQZ0RTYU5tT1R0Q1ljblJsZHhO?=
 =?utf-8?B?YlcybndIRnk2U0NVNmdndlhweVIzbS90dTY1dUdMYk5VRys1Yi8wOVlTOFZT?=
 =?utf-8?B?UnBGTm1OeDhHcXNBK3hmQi9JZG8xZi9vSlpuaitOYzAvVHdUdXpvUjhxMXJ1?=
 =?utf-8?B?aDFmMnFtZEhnY3QwM3BqVjZ2ZHp0S3FjQk5XS1ZtRjJZUVBFaG5EeitKV29z?=
 =?utf-8?B?TlpYcHlZZzZoWmVIcmVBbStaUVdPK1NMVTRTV1FrVkpJdkZrbzNGS1g2S3Fu?=
 =?utf-8?Q?wJ8Se/G+93vZk=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2610.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca36ab43-beb9-4ccd-e4de-08d8bc8e5187
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 15:24:31.0894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Y7JJqmmfQaNElCBzNAonSl5+A6ouK66up86P9dVDEaNI4vWHP2mdFwkNufYFgYoO7TYgSGGbCVNK764WmqP30w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1923
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGksDQoNClRoaXMgZml4IGNhbiBiZSBmb3VuZCBoZXJlLiBJdCB3YXMgbWVyZ2VkIHRvIHRoZSBt
YWM4MDIxMSB0cmVlLg0KDQpodHRwczovL3BhdGNod29yay5rZXJuZWwub3JnL3Byb2plY3QvbGlu
dXgtd2lyZWxlc3MvcGF0Y2gvaXdsd2lmaS4yMDIxMDEwNTE2NTY1Ny42MTNlOWE4NzY4MjkuSWEz
OGQyN2RiZWJlYTI4YmY5YzU2ZDcwNjkxZDI0MzE4NmVkZTcwZTdAY2hhbmdlaWQvDQoNClJlZ2Fy
ZHMsDQoNCklsYW4uDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGFu
cyBkZSBHb2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5
IDE4LCAyMDIxIDIzOjA5DQo+IFRvOiBQZWVyLCBJbGFuIDxpbGFuLnBlZXJAaW50ZWwuY29tPjsg
Sm9oYW5uZXMgQmVyZw0KPiA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD47IERhdmlkIFMgLiBN
aWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJu
ZWwub3JnPjsgUm9qZXdza2ksIENlemFyeQ0KPiA8Y2V6YXJ5LnJvamV3c2tpQGludGVsLmNvbT47
IFBpZXJyZS1Mb3VpcyBCb3NzYXJ0IDxwaWVycmUtDQo+IGxvdWlzLmJvc3NhcnRAbGludXguaW50
ZWwuY29tPjsgTGlhbSBHaXJkd29vZA0KPiA8bGlhbS5yLmdpcmR3b29kQGxpbnV4LmludGVsLmNv
bT47IEppZSBZYW5nIDx5YW5nLmppZUBsaW51eC5pbnRlbC5jb20+Ow0KPiBNYXJrIEJyb3duIDxi
cm9vbmllQGtlcm5lbC5vcmc+DQo+IENjOiBsaW51eC13aXJlbGVzc0B2Z2VyLmtlcm5lbC5vcmc7
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiBrZXJuZWxAdmdlci5rZXJuZWwub3Jn
OyBhbHNhLWRldmVsQGFsc2EtcHJvamVjdC5vcmcNCj4gU3ViamVjdDogUmU6IFtQQVRDSF0gY2Zn
ODAyMTE6IEZpeCAic3VzcGljaW91cyBSQ1UgdXNhZ2UgaW4NCj4gd2lwaHlfYXBwbHlfY3VzdG9t
X3JlZ3VsYXRvcnkiIHdhcm5pbmcvYmFja3RyYWNlDQo+IA0KPiBIaSwNCj4gDQo+IE9uIDEvNS8y
MSAxMDoyNCBBTSwgUGVlciwgSWxhbiB3cm90ZToNCj4gPiBIaSwNCj4gPg0KPiA+PiAtLS0tLU9y
aWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUBy
ZWRoYXQuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEphbnVhcnkgMDQsIDIwMjEgMTk6MDcNCj4g
Pj4gVG86IEpvaGFubmVzIEJlcmcgPGpvaGFubmVzQHNpcHNvbHV0aW9ucy5uZXQ+OyBEYXZpZCBT
IC4gTWlsbGVyDQo+ID4+IDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgSmFrdWIgS2ljaW5za2kgPGt1
YmFAa2VybmVsLm9yZz47IFJvamV3c2tpLA0KPiA+PiBDZXphcnkgPGNlemFyeS5yb2pld3NraUBp
bnRlbC5jb20+OyBQaWVycmUtTG91aXMgQm9zc2FydCA8cGllcnJlLQ0KPiA+PiBsb3Vpcy5ib3Nz
YXJ0QGxpbnV4LmludGVsLmNvbT47IExpYW0gR2lyZHdvb2QNCj4gPj4gPGxpYW0uci5naXJkd29v
ZEBsaW51eC5pbnRlbC5jb20+OyBKaWUgWWFuZw0KPiA+PiA8eWFuZy5qaWVAbGludXguaW50ZWwu
Y29tPjsgTWFyayBCcm93biA8YnJvb25pZUBrZXJuZWwub3JnPg0KPiA+PiBDYzogSGFucyBkZSBH
b2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNvbT47IGxpbnV4LQ0KPiA+PiB3aXJlbGVzc0B2Z2VyLmtl
cm5lbC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LQ0KPiA+PiBrZXJuZWxAdmdl
ci5rZXJuZWwub3JnOyBhbHNhLWRldmVsQGFsc2EtcHJvamVjdC5vcmc7IFBlZXIsIElsYW4NCj4g
Pj4gPGlsYW4ucGVlckBpbnRlbC5jb20+DQo+ID4+IFN1YmplY3Q6IFtQQVRDSF0gY2ZnODAyMTE6
IEZpeCAic3VzcGljaW91cyBSQ1UgdXNhZ2UgaW4NCj4gPj4gd2lwaHlfYXBwbHlfY3VzdG9tX3Jl
Z3VsYXRvcnkiIHdhcm5pbmcvYmFja3RyYWNlDQo+ID4+DQo+ID4+IENvbW1pdCBiZWVlMjQ2OTUx
NTcgKCJjZmc4MDIxMTogU2F2ZSB0aGUgcmVndWxhdG9yeSBkb21haW4gd2hlbg0KPiA+PiBzZXR0
aW5nIGN1c3RvbSByZWd1bGF0b3J5IikgYWRkcyBhIGdldF93aXBoeV9yZWdkb20gY2FsbCB0bw0K
PiA+PiB3aXBoeV9hcHBseV9jdXN0b21fcmVndWxhdG9yeS4gQnV0IGFzIHRoZSBjb21tZW50IGFi
b3ZlDQo+ID4+IHdpcGh5X2FwcGx5X2N1c3RvbV9yZWd1bGF0b3J5IHNheXM6DQo+ID4+ICIvKiBV
c2VkIGJ5IGRyaXZlcnMgcHJpb3IgdG8gd2lwaHkgcmVnaXN0cmF0aW9uICovIg0KPiA+PiB0aGlz
IGZ1bmN0aW9uIGlzIHVzZWQgYnkgZHJpdmVyJ3MgcHJvYmUgZnVuY3Rpb24gYmVmb3JlIHRoZSB3
aXBoeSBpcw0KPiA+PiByZWdpc3RlcmVkIGFuZCBhdCB0aGlzIHBvaW50IHdpcGh5LT5yZWdkIHdp
bGwgdHlwaWNhbGx5IGJ5IE5VTEwgYW5kDQo+ID4+IGNhbGxpbmcgcmN1X2RlcmVmZXJlbmNlX3J0
bmwgb24gYSBOVUxMIHBvaW50ZXIgY2F1c2VzIHRoZSBmb2xsb3dpbmcNCj4gPj4gd2FybmluZy9i
YWNrdHJhY2U6DQo+ID4+DQo+ID4+ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQo+ID4+
IFdBUk5JTkc6IHN1c3BpY2lvdXMgUkNVIHVzYWdlDQo+ID4+IDUuMTEuMC1yYzErICMxOSBUYWlu
dGVkOiBHICAgICAgICBXDQo+ID4+IC0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tDQo+ID4+
IG5ldC93aXJlbGVzcy9yZWcuYzoxNDQgc3VzcGljaW91cyByY3VfZGVyZWZlcmVuY2VfY2hlY2so
KSB1c2FnZSENCj4gPj4NCj4gPj4gb3RoZXIgaW5mbyB0aGF0IG1pZ2h0IGhlbHAgdXMgZGVidWcg
dGhpczoNCj4gPj4NCj4gPj4gcmN1X3NjaGVkdWxlcl9hY3RpdmUgPSAyLCBkZWJ1Z19sb2NrcyA9
IDENCj4gPj4gMiBsb2NrcyBoZWxkIGJ5IGt3b3JrZXIvMjowLzIyOg0KPiA+PiAgIzA6IGZmZmY5
YTRiYzEwNGRmMzggKCh3cV9jb21wbGV0aW9uKWV2ZW50cyl7Ky4rLn0tezA6MH0sIGF0Og0KPiA+
PiBwcm9jZXNzX29uZV93b3JrKzB4MWVlLzB4NTcwDQo+ID4+ICAjMTogZmZmZmI2ZTk0MDEwYmU3
OA0KPiA+PiAoKHdvcmtfY29tcGxldGlvbikoJmZ3X3dvcmstPndvcmspKXsrLisufS17MDowfSwN
Cj4gPj4gYXQ6IHByb2Nlc3Nfb25lX3dvcmsrMHgxZWUvMHg1NzANCj4gPj4NCj4gPj4gc3RhY2sg
YmFja3RyYWNlOg0KPiA+PiBDUFU6IDIgUElEOiAyMiBDb21tOiBrd29ya2VyLzI6MCBUYWludGVk
OiBHICAgICAgICBXICAgICAgICAgNS4xMS4wLXJjMSsgIzE5DQo+ID4+IEhhcmR3YXJlIG5hbWU6
IExFTk9WTyA2MDA3My9JTlZBTElELCBCSU9TIDAxV1QxN1dXIDA4LzAxLzIwMTQNCj4gPj4gV29y
a3F1ZXVlOiBldmVudHMgcmVxdWVzdF9maXJtd2FyZV93b3JrX2Z1bmMgQ2FsbCBUcmFjZToNCj4g
Pj4gIGR1bXBfc3RhY2srMHg4Yi8weGIwDQo+ID4+ICBnZXRfd2lwaHlfcmVnZG9tKzB4NTcvMHg2
MCBbY2ZnODAyMTFdDQo+ID4+ICB3aXBoeV9hcHBseV9jdXN0b21fcmVndWxhdG9yeSsweGEwLzB4
ZjAgW2NmZzgwMjExXQ0KPiA+PiAgYnJjbWZfY2ZnODAyMTFfYXR0YWNoKzB4YjAyLzB4MTM2MCBb
YnJjbWZtYWNdDQo+ID4+ICBicmNtZl9hdHRhY2grMHgxODkvMHg0NjAgW2JyY21mbWFjXQ0KPiA+
PiAgYnJjbWZfc2Rpb19maXJtd2FyZV9jYWxsYmFjaysweDc4YS8weDhmMCBbYnJjbWZtYWNdDQo+
ID4+ICBicmNtZl9md19yZXF1ZXN0X2RvbmUrMHg2Ny8weGYwIFticmNtZm1hY10NCj4gPj4gIHJl
cXVlc3RfZmlybXdhcmVfd29ya19mdW5jKzB4M2QvMHg3MA0KPiA+PiAgcHJvY2Vzc19vbmVfd29y
aysweDI2ZS8weDU3MA0KPiA+PiAgd29ya2VyX3RocmVhZCsweDU1LzB4M2MwDQo+ID4+ICA/IHBy
b2Nlc3Nfb25lX3dvcmsrMHg1NzAvMHg1NzANCj4gPj4gIGt0aHJlYWQrMHgxMzcvMHgxNTANCj4g
Pj4gID8gX19rdGhyZWFkX2JpbmRfbWFzaysweDYwLzB4NjANCj4gPj4gIHJldF9mcm9tX2Zvcmsr
MHgyMi8weDMwDQo+ID4+DQo+ID4+IEFkZCBhIGNoZWNrIGZvciB3aXBoeS0+cmVnZCBiZWluZyBO
VUxMIGJlZm9yZSBjYWxsaW5nDQo+ID4+IGdldF93aXBoeV9yZWdkb20gKGFzIGlzIGFscmVhZHkg
ZG9uZSBpbiBvdGhlciBwbGFjZXMpIHRvIGZpeCB0aGlzLg0KPiA+Pg0KPiA+PiB3aXBoeS0+cmVn
ZCB3aWxsIGxpa2VseSBhbHdheXMgYmUgTlVMTCB3aGVuDQo+ID4+IHdpcGh5LT53aXBoeV9hcHBs
eV9jdXN0b21fcmVndWxhdG9yeQ0KPiA+PiBnZXRzIGNhbGxlZCwgc28gYXJndWFibHkgdGhlIHRt
cCA9IGdldF93aXBoeV9yZWdkb20oKSBhbmQNCj4gPj4gcmN1X2ZyZWVfcmVnZG9tKHRtcCkgY2Fs
bHMgc2hvdWxkIHNpbXBseSBiZSBkcm9wcGVkLCB0aGlzIHBhdGNoIGtlZXBzDQo+ID4+IHRoZQ0K
PiA+PiAyIGNhbGxzLCB0byBhbGxvdyBkcml2ZXJzIHRvIGNhbGwgd2lwaHlfYXBwbHlfY3VzdG9t
X3JlZ3VsYXRvcnkgbW9yZQ0KPiA+PiB0aGVuIG9uY2UgaWYgbmVjZXNzYXJ5Lg0KPiA+Pg0KPiA+
PiBDYzogSWxhbiBQZWVyIDxpbGFuLnBlZXJAaW50ZWwuY29tPg0KPiA+PiBGaXhlczogYmVlZTI0
Njk1MTU3ICgiY2ZnODAyMTE6IFNhdmUgdGhlIHJlZ3VsYXRvcnkgZG9tYWluIHdoZW4NCj4gPj4g
c2V0dGluZyBjdXN0b20gcmVndWxhdG9yIikNCj4gPj4gU2lnbmVkLW9mZi1ieTogSGFucyBkZSBH
b2VkZSA8aGRlZ29lZGVAcmVkaGF0LmNvbT4NCj4gPj4gLS0tDQo+ID4+ICBuZXQvd2lyZWxlc3Mv
cmVnLmMgfCA1ICsrKy0tDQo+ID4+ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAy
IGRlbGV0aW9ucygtKQ0KPiA+Pg0KPiA+PiBkaWZmIC0tZ2l0IGEvbmV0L3dpcmVsZXNzL3JlZy5j
IGIvbmV0L3dpcmVsZXNzL3JlZy5jIGluZGV4DQo+ID4+IGJiNzI0NDdhZDk2MC4uOTI1NGI5Y2Jh
YTIxIDEwMDY0NA0KPiA+PiAtLS0gYS9uZXQvd2lyZWxlc3MvcmVnLmMNCj4gPj4gKysrIGIvbmV0
L3dpcmVsZXNzL3JlZy5jDQo+ID4+IEBAIC0yNTQ3LDcgKzI1NDcsNyBAQCBzdGF0aWMgdm9pZCBo
YW5kbGVfYmFuZF9jdXN0b20oc3RydWN0IHdpcGh5DQo+ID4+ICp3aXBoeSwgIHZvaWQgd2lwaHlf
YXBwbHlfY3VzdG9tX3JlZ3VsYXRvcnkoc3RydWN0IHdpcGh5ICp3aXBoeSwNCj4gPj4gIAkJCQkg
ICBjb25zdCBzdHJ1Y3QgaWVlZTgwMjExX3JlZ2RvbWFpbiAqcmVnZCkgIHsNCj4gPj4gLQljb25z
dCBzdHJ1Y3QgaWVlZTgwMjExX3JlZ2RvbWFpbiAqbmV3X3JlZ2QsICp0bXA7DQo+ID4+ICsJY29u
c3Qgc3RydWN0IGllZWU4MDIxMV9yZWdkb21haW4gKm5ld19yZWdkLCAqdG1wID0gTlVMTDsNCj4g
Pj4gIAllbnVtIG5sODAyMTFfYmFuZCBiYW5kOw0KPiA+PiAgCXVuc2lnbmVkIGludCBiYW5kc19z
ZXQgPSAwOw0KPiA+Pg0KPiA+PiBAQCAtMjU3MSw3ICsyNTcxLDggQEAgdm9pZCB3aXBoeV9hcHBs
eV9jdXN0b21fcmVndWxhdG9yeShzdHJ1Y3QNCj4gd2lwaHkNCj4gPj4gKndpcGh5LA0KPiA+PiAg
CWlmIChJU19FUlIobmV3X3JlZ2QpKQ0KPiA+PiAgCQlyZXR1cm47DQo+ID4+DQo+ID4+IC0JdG1w
ID0gZ2V0X3dpcGh5X3JlZ2RvbSh3aXBoeSk7DQo+ID4+ICsJaWYgKHdpcGh5LT5yZWdkKQ0KPiA+
PiArCQl0bXAgPSBnZXRfd2lwaHlfcmVnZG9tKHdpcGh5KTsNCj4gPj4gIAlyY3VfYXNzaWduX3Bv
aW50ZXIod2lwaHktPnJlZ2QsIG5ld19yZWdkKTsNCj4gPj4gIAlyY3VfZnJlZV9yZWdkb20odG1w
KTsNCj4gPg0KPiA+IFRoaXMgb25seSBmaXhlcyB0aGUgZmlyc3QgY2FzZSB3aGVyZSB0aGUgcG9p
bnRlciBpbiBOVUxMIGFuZCBkb2VzIG5vdCBoYW5kbGUNCj4gdGhlIHdyb25nIFJDVSB1c2FnZSBp
biBvdGhlciBjYXNlcy4NCj4gPg0KPiA+IEknbGwgcHJlcGFyZSBhIGZpeCBmb3IgdGhpcy4NCj4g
DQo+IEFueSBsdWNrIHdpdGggdGhpcz8gVGhpcyBpcyBhIHJlZ3Jlc3Npb24gaW4gNS4xMSwgc28g
dGhpcyByZWFsbHkgc2hvdWxkIGJlIGZpeGVkIGluDQo+IGEgZnV0dXJlIDUuMTEtcmMgYW5kIHRo
ZSBjbG9jayBpcyBydW5uaW5nIG91dC4NCj4gDQo+IFJlZ2FyZHMsDQo+IA0KPiBIYW5zDQoNCg==
