Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCE16376D6
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 11:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiKXKwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 05:52:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbiKXKww (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 05:52:52 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD261E71A;
        Thu, 24 Nov 2022 02:52:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1669287172; x=1700823172;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=ipO08FlefsUQYWJ7rxBQsRSpDrm1ahbDEDXGno4KdNs=;
  b=CCEZt++JDryy8s7d9r1dgk25zvjzh4XXE4IvLvp3tHZRSIEJXZDZ08Lv
   e6VFxKYdbGIU28PJv5pniobPmpUGI8UEi8MFiHXB+0eNvL8D2TRraASC3
   yTSavVbtYjOkzciF2qvo4RRDSKOBuYKvl4LwddDTnXJICAP/54yzvq0yI
   YswmCoKq9FSlIXY2Ghd89buRb3JTBIDHDOHD/AONATN6Zd7H16ixlAfut
   unIfIZYvgiXel/pVha1Ab2AJkqWggH2JJ5a/DqeIMTrD28VOnDRBeRk7d
   8a4ciYglKXA64DiaASVefFnYZAoEG+1lIVEuzoYpwL3t7W+ALuMwAnSiW
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="188494990"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Nov 2022 03:52:50 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 24 Nov 2022 03:52:49 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 24 Nov 2022 03:52:49 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aFFOeS2k9P7TNmMGC9rx7twiuQWEqDsbU75Sa4Lzp9d3Ho3ymuh4OrKMVrkKpto8PliKBiYoTANDJIrCSNVlpv50kp/4Hw5qLSiRe1TcCFpmNxLCinqoi42GbEg5YcagJy8mWZqjsQ5F5I9VBa6m8JnXAlpvD1o+SMkKmPICtbOj74QUNrRLes49dCD8JV07BreJ8VN5KNstykj4vWhlDtq8Yl2SpVj675yQqMB45yh45SlbuXuoKvXIWHuCEEd+1i+fafGb0Cei/DsGe+gRYQIiZ735mPadiYb1mRYXXsdvg//GJriFuSYe32uZK95kzZrsU3QHGhVfg1ZNYVs2Hg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ipO08FlefsUQYWJ7rxBQsRSpDrm1ahbDEDXGno4KdNs=;
 b=kLZjJiMuanZZ5ZTrARDcXeFW0mX1EX3En+hsEVDitpkMuTAy7hu9PZYQVVfcRNOVbGlW808pr0spnVUdV3LcZvB2H6m7KdLZJlbo+g8uqptjQUPbQvEVPjr1aBYB/O1jq/NDnlfOTVU1E6Y3c2Pz/cMqqZIn6Rd1R4PkLKNbjhmSOP4lb5P9qc8mKX55ezvkDqvDuxT5bhhCp+lgJY1SXwmkaVWu7fPHbidknhuwzPNRl4igzCkpamu1w/9T6w/wtd4ziy4vUFG5dbujf/Izoie1RU23aB1NzwTmW/HgWhSFOMhZodw1OXZcGF7MsxwWR+KRMlvirJXt8h1Yk6GowQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ipO08FlefsUQYWJ7rxBQsRSpDrm1ahbDEDXGno4KdNs=;
 b=ZzzrNS5Q1CjHlrNUnoudfLOK/RkExT50mmqFe2ai/YeN/bvPB736ADfmEyMAviUuYko70hAgj4l0rzk14L7eJDbluEZoCNqDvd3SxqQJavtYnKSxM7NdchJW2do/1hoeDGjuLvI5VwaFWRFzgKYzLWgQ4dvsc40yVIi0ObDJucc=
Received: from DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) by
 SN7PR11MB6923.namprd11.prod.outlook.com (2603:10b6:806:2aa::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Thu, 24 Nov
 2022 10:52:46 +0000
Received: from DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953]) by DM5PR11MB0076.namprd11.prod.outlook.com
 ([fe80::9b7a:7604:7a30:1953%7]) with mapi id 15.20.5857.018; Thu, 24 Nov 2022
 10:52:46 +0000
From:   <Arun.Ramadoss@microchip.com>
To:     <olteanv@gmail.com>
CC:     <andrew@lunn.ch>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <vivien.didelot@gmail.com>,
        <linux@armlinux.org.uk>, <Tristram.Ha@microchip.com>,
        <f.fainelli@gmail.com>, <kuba@kernel.org>, <edumazet@google.com>,
        <pabeni@redhat.com>, <richardcochran@gmail.com>,
        <netdev@vger.kernel.org>, <Woojung.Huh@microchip.com>,
        <davem@davemloft.net>
Subject: Re: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial hardware
 time stamping support
Thread-Topic: [RFC Patch net-next v2 3/8] net: dsa: microchip: Initial
 hardware time stamping support
Thread-Index: AQHY/b/imAgaAgzTi0Cq9JpLcCQfmK5KAikAgAKJeACAAVYlgIAACH0A
Date:   Thu, 24 Nov 2022 10:52:46 +0000
Message-ID: <0d7df00d4c3a5228571fd408ea7ca3d71885bf6f.camel@microchip.com>
References: <20221121154150.9573-1-arun.ramadoss@microchip.com>
         <20221121154150.9573-4-arun.ramadoss@microchip.com>
         <20221121231314.kabhej6ae6bl3qtj@skbuf>
         <298f4117872301da3e4fe4fed221f51e9faab5d0.camel@microchip.com>
         <20221124102221.2xldwevfmjbekx43@skbuf>
In-Reply-To: <20221124102221.2xldwevfmjbekx43@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_|SN7PR11MB6923:EE_
x-ms-office365-filtering-correlation-id: 73a5e494-1769-4e6c-e3f0-08dace0a0590
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AM1EEqloVvGCJnK/+CfC/Y0p4cZSsiEBKAP3zT8vmG0QKyZ7XcUq37rR3g3xqkZCvTz0QByDRkrfu/4R7MVD851b+2RW4W6R6hyO8s+z2DIa7j4R6Y+2mIhEhXyCraZyE8lh8x0l8yejU8/uUp7jT+w/e9gQ4meOisa3Uy6gfkSvEBOFib3yO7QWpH6d1DUvIfxPZf1sgFY/EOqSMNQil6EPoK6EqfI2RrtpIa7mlqnkkAyDpzcNhJuiiYx9lHz8MMNzgTNRxWifrDXXwd1gt9SpyUNUNpoiXIMN+KxIl2IMH7q93nDVH5bqcZipSy0sFxpGlmk/JD+pkApxutRrTrwQRkfHS/sxIFjP1qjKDGWhFzotqt29eNTWykUI5hi6pyXdew9YLGGGs35TOyPeqr1vahgg8PlXjbd7m9N4eCnP7m+Tlsl6zFeqIFnpcn54JJmDYmLyDsg5uvnBEaKvUGobTrtDlf6NCPLOvzNYCqQPNdTLb4BKFmp5Xkaa4eweKGabxNnIC9fo/Nzd5lhrUoswD5IWT23w/7b3MWWTbRZ90UjckgLSIZAS1Oo7LJrfUmXy76Dj8DKAnYxeJv/QYdYD4K8p/q6mvGTpxwqx0ja8+U6GXHc8fpWUinZt3lrUyLL4x22cT6ZUJVerKD7wUSMhEuG3Ag1R+8Z+WiHlePSPKaXQ5RMNw51+5bdOYOOmjxAd83ILcgcPZqEEtZeuP5PuQO4Z0Sla1e0WvcaQ5yY=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR11MB0076.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(39860400002)(366004)(136003)(396003)(451199015)(478600001)(38070700005)(36756003)(71200400001)(83380400001)(186003)(2616005)(26005)(5660300002)(86362001)(6512007)(66899015)(6506007)(8936002)(4001150100001)(41300700001)(2906002)(6486002)(38100700002)(122000001)(91956017)(54906003)(7416002)(76116006)(8676002)(66446008)(4326008)(66556008)(66946007)(6916009)(316002)(66476007)(64756008)(99106002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MEI1WjMyUEdNUFE4VEE1QXpjajJkWFdneklXL0VkM1dFMndUNjVLbXoxeEJv?=
 =?utf-8?B?KzA1a25OVkg1S1pSdE90TFVmV3RuaTdDMStBbDNYM0FiaFc1b2hsVDRTOGpw?=
 =?utf-8?B?bFlXV3FZbUc0OGMxRERSS0hUdkkxYlJPaFNMckNmWXZEUncydDRYdFNTbjdz?=
 =?utf-8?B?a0ZFVnlicmhQVU53WmkrMWRReVp6RHRGVzI3YU1La0orVGRSMU55N01XekpC?=
 =?utf-8?B?aEI0QXd1c0g1aCtJN0tkZGJDQ1lZejNnSDdHMDJsbHdHZDR1UmNmaUNCMDBM?=
 =?utf-8?B?S0Rkcm95clYwN2lRUU9mcnkzcE96cG5JcC9CcUNzNGpzcXUyclB2WWRlaG9s?=
 =?utf-8?B?VUlJWmEzM0J2aFFKbkJ2YkRQWndETHBYaWtxVUEzdjdIUml2cEFCMTlZeEtN?=
 =?utf-8?B?aGd5L2VUR0l5VWJUaVo2bjRHMG1MZ056cm8xUkNWVXhWc3hQSFBHbTREMnVs?=
 =?utf-8?B?WklQVEdsa3lTMkRIYkIwcWsydmFoMlcyUjAybDNNVEFUVXdpR3c4djBMaC9C?=
 =?utf-8?B?T2ZnQlVmLzNnK3ZtdGZtNjV0VU5kb2lvWmRpZ3pQQ2dhUkt3NnZTNWlzeWhl?=
 =?utf-8?B?ZFZGdGRIVHZDMEdDYU0xblI2amNaK083ai92KzRMS0F2WlZXK0ptc29VN1RB?=
 =?utf-8?B?TndOQlN5bHRIUWJnMFZJSnRRQUkyMHIzdlVweWFnVVFMZkpweE16U3VvRTB2?=
 =?utf-8?B?VWs4YTIzeDg2L0hveWpwQ2pJZ0swamxDZEtlN0s1T0M3cktPSlVBbU1ua29Q?=
 =?utf-8?B?WS9QU0ZDc1FtYWdxNHRrZCtaUFVLa0hqVXBqVm1OOXBHTkJaMlZ0UkM1S3h1?=
 =?utf-8?B?SnIxV1F5VkYwNVdFaTRwOU1kM2VLZjZUTzJrblVtT2FqbnJZMisrWDB4QW4x?=
 =?utf-8?B?dzQzNFFnMHJxYk51SklBbHRBT0JWRHVEYmVxa1UxbDdaQ2hHNmk0SWdWQUd4?=
 =?utf-8?B?WWlSenRnL285N0g3WlZyNFZnUDZRb3V1YzJrODExd3BPRzU0UXV3LzZ6TXov?=
 =?utf-8?B?UCs4TXdBMGU5ekl4cENEMXJjWEFTZ0pyWmthY20yVWMvOVVzSU1UWlp1M1R4?=
 =?utf-8?B?ajRWZ3Q1cXhqbWNQK09raDJNaFFBb0JmTnMySThKQlQwUlVXTUZPejBEVno3?=
 =?utf-8?B?U0F1bnhjRFp0V0YyTjBORjRNZ01PTVM1QVRSSjZsV1UzOHk1ODFpdHY0ZVlG?=
 =?utf-8?B?cm1sWEFHSkZmN01HUjcyRDgzdE55WG8wZ2piNHlYUzUwSFF1M0pWaW1zWHRS?=
 =?utf-8?B?THBWeU80MVhuT09oT2pGVXNmYzJVak9GdURoVWlXNHc5VVkzU2ZLanJlUkZI?=
 =?utf-8?B?TVZSUjZ5K05XNFNnUVlmSGZSaU5Valp0WXh2NDZRUlFiSS9mR3padEM3VS9L?=
 =?utf-8?B?TFFOYU0vR2J6b1VGZ3BFK3pzTzIyZFRLMG1TOGc5b0JZRjA5ZlhrVXhuMFlO?=
 =?utf-8?B?dGJic25lU3Z6UnJaUzh6MjhLc3FwNlNxV3F5Z3JlS2kwNHY3S2k2K1pDN01W?=
 =?utf-8?B?WTBtZmZrYThFUlpMY2FCbU1aTVJyNG5rWGNxMEV6cmliaVhNRVJlbkhXOHl4?=
 =?utf-8?B?K3k1SERhRmhKcFdwOUhjaU5zSHZEY3pHa3R5Y2pXelhJVWE4aUMranNiR2dI?=
 =?utf-8?B?Mm1ZSkJSNHc3TWRYR2dCYTZ2RFg4ejlXeWRzMllONEwyVit1RXF1Wm5jVXJx?=
 =?utf-8?B?M1c1U0VEMDRPNmoyK2tYZ2l5UlJnaStRaHp2YUtRenZIb3dWeUN4dU5PYjR6?=
 =?utf-8?B?TVNRdjNWazlDTC9XUTdteXo0ekNlWnQyWEY0UXBNdjR3QTM4MnJCR2pZQ3dG?=
 =?utf-8?B?WXFreUVUclpTNUJPNS82OWJneGplZFdDUWpUZkE3RnN3UzdOZWtqeEJZK3Vj?=
 =?utf-8?B?N0VhSlJpTjB3Y2pEWmtiV1A2d0xpQWpDZ04zT2J1WUcwZzVFQnFZN0lFWk5n?=
 =?utf-8?B?UmZHeHdQL1hYNXlRa3VXeTNVR2tXTFc4N1ZnTEl3WjNtYlZLRkxRdDA5bGZi?=
 =?utf-8?B?RjBYYit2RWFDZEpGUHpmQnNCdDFBL2FvVnRBcytpbmNzUzB6eXgxd2x2WTBO?=
 =?utf-8?B?YXVRMnh1SWl3ZVFKa2dLazRkd0RGT21lc3VncFY5RHRpSlBOQkJNZ0RSemFZ?=
 =?utf-8?B?SUV3WWdwQTZ6THBKZ0xUUEJkbk90YmpkSDBLY0oxWHVDblNpZFhFajUvZk9D?=
 =?utf-8?Q?KdM/ezWzyPuki6N7mVQMvhU=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CA9311911CF98B4AB8173B7074AC7B6B@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR11MB0076.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 73a5e494-1769-4e6c-e3f0-08dace0a0590
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Nov 2022 10:52:46.4097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9qPax6cQI1ioqw37y+P15opeCD/BZLp2CoewqZL+55JqVyGB0wceo6uLISpiXTdl4v5L4hyMsOzaJCROx2Vur7duxpcv0wbeY66Wq0OH4EY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR11MB6923
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDIyLTExLTI0IGF0IDEyOjIyICswMjAwLCBWbGFkaW1pciBPbHRlYW4gd3JvdGU6
DQo+IEVYVEVSTkFMIEVNQUlMOiBEbyBub3QgY2xpY2sgbGlua3Mgb3Igb3BlbiBhdHRhY2htZW50
cyB1bmxlc3MgeW91DQo+IGtub3cgdGhlIGNvbnRlbnQgaXMgc2FmZQ0KPiANCj4gT24gV2VkLCBO
b3YgMjMsIDIwMjIgYXQgMDE6NTc6NDdQTSArMDAwMCwgQXJ1bi5SYW1hZG9zc0BtaWNyb2NoaXAu
Y29tDQo+ICB3cm90ZToNCj4gPiA+IFdoYXQncyB5b3VyIGV4Y3VzZSB3aGljaCBzdWNoIGEgaG9y
cmlibGUgY29kZSBwYXR0ZXJuPyBXaGF0IHdpbGwNCj4gPiA+IGhhcHBlbg0KPiA+ID4gc28gYmFk
IHdpdGggdGhlIHBhY2tldCBpZiBpdCdzIGZsYWdnZWQgd2l0aCBhIFRYIHRpbWVzdGFtcA0KPiA+
ID4gcmVxdWVzdCBpbg0KPiA+ID4gS1NaX1NLQl9DQihza2IpIGF0IHRoZSBzYW1lIHRpbWUgYXMg
UkVHX1BUUF9NU0dfQ09ORjEgaXMgd3JpdHRlbg0KPiA+ID4gdG8/DQo+ID4gPiANCj4gPiA+IEFs
c28sIGRvZXNuJ3QgZGV2LT5wb3J0c1twb3J0XS5od3RzX3R4X2VuIHNlcnZlIGFzIGEgZ3VhcmQN
Cj4gPiA+IGFnYWluc3QNCj4gPiA+IGZsYWdnaW5nIHBhY2tldHMgZm9yIFRYIHRpbWVzdGFtcHMg
d2hlbiB5b3Ugc2hvdWxkbid0Pw0KPiA+ID4gDQo+ID4gDQo+ID4gSSB0b29rIHRoaXMgY29uZmln
dXJhdGlvbiB0ZW1wbGF0ZSByb3V0aW5lIGZyb20gb3RoZXIgZHJpdmVyLg0KDQpNaXN0YWtlIGhl
cmUuIEl0IGlzIGNhcnJpZWQgZm9yd2FyZGVkIGZyb20gQ2hyaXN0aWFuIEVnZ2VycyBwYXRjaC4N
Cg0KPiANCj4gTm90IHJlYWxseSBhIGdvb2QgZXhjdXNlLiBUaGUgc2phMTEwNSBkcml2ZXIgaGFz
IG1vcmUgaGFyZHdhcmUtDQo+IHNwZWNpZmljDQo+IGlzc3VlcyB0byBkZWFsIHdpdGgsIG5vdCBu
ZWNlc3NhcmlseSB0aGUgc2FtZSBhcyBrc3ouDQo+IA0KPiA+IENhbiBJIHJlcGxhY2UgYWJvdmUg
c25pcHBldCB3aXRoDQo+ID4gDQo+ID4gdGFnZ2VyX2RhdGEtPmh3dHN0YW1wX3NldF9zdGF0ZShk
ZXYtPmRzLCByeF9vbik7DQo+ID4gcmV0ID0ga3N6X3B0cF9lbmFibGVfbW9kZShkZXYsIHJ4X29u
KTsNCj4gPiBpZiAocmV0KQ0KPiA+ICAgICByZXR1cm4gcmV0Ow0KPiANCj4gV2h5IGRvIHlvdSBu
ZWVkIHRvIGNhbGwgaHd0c3RhbXBfc2V0X3N0YXRlIGFueXdheT8NCg0KSW4gdGFnX2tzei5jLCB4
bWl0IGZ1bmN0aW9uIHF1ZXJ5IHRoaXMgc3RhdGUsIHRvIGRldGVybWluZSB3aGV0aGVyIHRvDQph
bGxvY2F0ZSB0aGUgNCBQVFAgdGltZXN0YW1wIGJ5dGVzIGluIHRoZSBza2JfYnVmZmVyIG9yIG5v
dC4gVXNpbmcgdGhpcw0KdGFnZ2VyX2RhdGEgc2V0IHN0YXRlLCBwdHAgZW5hYmxlIGFuZCBkaXNh
YmxlIGlzIGNvbW11bmljYXRlZCBiZXR3ZWVuDQprc3pfcHRwLmMgYW5kIHRhZ19rc3ouYw0KDQo=
