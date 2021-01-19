Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 085812FB2DF
	for <lists+netdev@lfdr.de>; Tue, 19 Jan 2021 08:25:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730765AbhASHVH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 02:21:07 -0500
Received: from mga05.intel.com ([192.55.52.43]:35401 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730560AbhASHUm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 02:20:42 -0500
IronPort-SDR: 4c0gWmcHjaSoztp1XGMbE/QPcVgEaRKG9kkDHQ7sZ0qKWg56pnbJ0OGKECMhH5QNBq4H0wkDty
 oc2z5rGdtBMg==
X-IronPort-AV: E=McAfee;i="6000,8403,9868"; a="263696790"
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="263696790"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jan 2021 23:19:49 -0800
IronPort-SDR: ycLjy7FI+tJGaHae43b1hunrJLeOpqIy4j3oveHtiB6xJ3ej1+TA+rH68SvH9Dk+cZM/pt+3DA
 YGNRznL9AsBw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,358,1602572400"; 
   d="scan'208";a="570922706"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga006.fm.intel.com with ESMTP; 18 Jan 2021 23:19:48 -0800
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 18 Jan 2021 23:19:48 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 18 Jan 2021 23:19:46 -0800
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Mon, 18 Jan 2021 23:19:46 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VVUpsskD1++WSCNVz4A+ulWiPfhX7fly2v148C7kavmkrdXOlLLRQK/qc2D2SmJBu3dVLyYpcxrzcdg/VJ7WBTlqwgdtr0VfLU0pA+pAJZrbNNdw/evpQu1VJ7TA1JGT2PJnQbCrXCh6rljMxP4uyWD/kJrlmMEfIwU5WTT0A1Qs7HxO6yyCbhZ9eqclvxz7AkKqi1IkdHiGe1rL23WWG1/q4M4x9aiLEnzmAPK04fLM0AtoWzyhAXHobfBBn2nhxYlNYLQJ2sA5gjofJVUYbgmZUP8Jd66laRZwt8saWCLSSDb5Az0eNCxduvFyh40bpdkwW8yinhSs+YhuIarQRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuY4GYh5nWSnpNmYO7Xd8T1hTOEEXSi9PuwSRCq3TxE=;
 b=X5r5h8Rpvw56cW7c5zRdq27+DtoQi2F/GgNyuE0p2PzoJWCn5SK9+I5uuOowO1dYQVB/seQEoLI+eQm+3g7scCbmUETKoi2g2SZIRB3delC/oZNeBWVy/TG9HwOEkc9mSPnC4c5hnEJDC3pnJOUfecEzDm5BMTW9ksMUvNa+nB/24aW0SsQN398SO4qEEixaZqbJ0eDvcMGcII7bjcqI1l+i1WtCjY+RatUSVEpvxF/aaSO+ZiNmzndfsHl5cofbQ74NJZc/mv3JvAu+0VTE2/PXyUKfxazDUTBJwIKFb+vEw7TVM9asKizl2fCWsbShcpB3FqUMbMt6LamTi1Bv1g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cuY4GYh5nWSnpNmYO7Xd8T1hTOEEXSi9PuwSRCq3TxE=;
 b=KeUo6cjQRx9ClgP6ypB6U2trRg7JMNAys1tuhXnnjrEAmkHj4l6qXzkmrC9IlPAtic6B2Li0qg15Ktbx+M/vgmJB/695cm29IBMqkSgT37ukaEnC8axyNe7XrUmIWX/2RukVPX53RxH6wxD3g6twI88Y/3jhHAdXq8FE3X3l9uA=
Received: from BN7PR11MB2610.namprd11.prod.outlook.com (2603:10b6:406:ab::31)
 by BN6PR11MB4179.namprd11.prod.outlook.com (2603:10b6:405:76::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Tue, 19 Jan
 2021 07:19:43 +0000
Received: from BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c]) by BN7PR11MB2610.namprd11.prod.outlook.com
 ([fe80::7c38:d64f:7d96:e3c%6]) with mapi id 15.20.3763.014; Tue, 19 Jan 2021
 07:19:43 +0000
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
Thread-Index: AQHW4rwYhFgUlszMR0OBRT1c2rvcL6oYwsJQgBU0EYCAAKpjcA==
Date:   Tue, 19 Jan 2021 07:19:43 +0000
Message-ID: <BN7PR11MB2610DEB82E8ED4514DAF3CF3E9A30@BN7PR11MB2610.namprd11.prod.outlook.com>
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
x-ms-office365-filtering-correlation-id: 760a3ff8-cfd7-456e-7f55-08d8bc4a97e9
x-ms-traffictypediagnostic: BN6PR11MB4179:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN6PR11MB4179838C0E419FB8A571CC1DE9A30@BN6PR11MB4179.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:407;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AarPc/UzsyMt2FtbQBdfpY/HhabFGcatAB+Jn7tetXGL4aVXu1JGDA4512vQqEWUGx6j0QbFPzzw5mhQnBrx6BDVRumfdCp7LzmE3bzHE5HRBRKAlMTxDg9b04Zu+H2E7HAh1zBlebmn3yqW7QNKs9HoQqQ1EnJDYOCesNhod/p0cPSFDD56Tq1YWMuqjtO0+nXWORCM6QatINVyzNZSWVo1ynD311DGcRCgfavirP+XzDAApI/VCehnwuVfgnqko0wxM22176hz8DTPFEfllm2xBcxOXWUV+oFRzsZKoB87wMlzC0Ik11Zu7CiflX1eG3h5O5Pr+BYY6WrmAvnv322+8aWdT2ElTvWLzbaEZb5nibfpZNNprJXEtbErhf7/pE/M8mQUQ1Tb2z68w4vvWznJPv3quhrixpMlM55lUpwdYrxqXYrAHz+rXm/QizYo
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN7PR11MB2610.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(396003)(39860400002)(346002)(366004)(478600001)(33656002)(26005)(5660300002)(52536014)(316002)(7416002)(66946007)(64756008)(66446008)(921005)(8936002)(110136005)(53546011)(66476007)(66556008)(54906003)(7696005)(76116006)(8676002)(9686003)(2906002)(71200400001)(6506007)(86362001)(83380400001)(4326008)(186003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?T05kZ04vRjZJUTA1blRBWXl5ZUo1ZkZaVDhoNlNzSG82VE83SmZMVXQwUExF?=
 =?utf-8?B?RXlzR2VQT1YxSTlyV2lPSWhUc2tpK1JZMm9jQnBuQU14NXdpbTRIVDV5OWlL?=
 =?utf-8?B?cW41M0RxYUZqWnNSZTJTQjBvWTc2VUp0SlFQVU1oUnAzRFhHMTdkdHBqSEhk?=
 =?utf-8?B?SnRUNmdtZDlQNk5sVDJZVGh0NGZFWDk4MERpUWJvSHN1VzdRcGZXeXRNOXQ4?=
 =?utf-8?B?ZVBRZDRWdEFtdlFwTmRMS1BaK2pFeTJPQUsvYWNjNU5RVXJtL3phTzN6Umgy?=
 =?utf-8?B?YzVjY0N2RG5FUnVlTXZ3bDVVaU9IcGp0ZU9aZGdZd0daay91bDBnTWw5ay9h?=
 =?utf-8?B?U1lzNDJqTEFkV3ZueW5CYXNaR09odzY2ZEU4a3VMdHVaTWFKaDFMVEdLTzVn?=
 =?utf-8?B?cUl5MW1pRmk2bjBRa1g0MG1JNnhjZGVjamwzUENPZklWWEw0TXkzME9IcUdy?=
 =?utf-8?B?RmN6cGpMVWZFT2dvWVMwTWx6QS9QMzNjckpaZDlNOHBlSXNKSWpNci91MjZO?=
 =?utf-8?B?eW9LUE1RTFlzWW4rVWZ4ZVpEWDR4S1I2OWlFY1FjN2tJWWtjV1BzT1NNdU5o?=
 =?utf-8?B?LzlCaW1wYXRQNHZ3V1VkYkpMTWRSM1JFN0F6TzY2bks1R0o5Z0tKVW1HbmlF?=
 =?utf-8?B?ZlNTVklOUGVtTEVhVE50WnNCRjBXWDBnVW9nNVRhZ1RwNnloRW5LK2ZaeXJC?=
 =?utf-8?B?aWE3eWMxeW81Q0tYUDVZc0JrellLcDlGMjRBSVdCR0haRGd2dVRUeWxnTWV6?=
 =?utf-8?B?MlhWdERlMnI0Nk5TcjFNUytYdjBnWWNPTXdSdkxuLy8yRWNqTjV4K3hPQkF0?=
 =?utf-8?B?MzRxYWhlWW1rUWFtMTUzcnIvM0tiN05TaHZJc2ltcFlCL3B0Q3oxREhEM293?=
 =?utf-8?B?Skx2RjNXOGt2WjhSc3F0T3dsSEV1amFYM0p5ZnRGejQxT0ladnNKVlVFSzVL?=
 =?utf-8?B?UThiRktOOHlFK3ovTU1OZ1JEUnk1aVk1bnB5eVBWUU1oTmZUYjV4UWQwN1FM?=
 =?utf-8?B?bzB0SjhqYVJldXY2WHZkNDczSjVRL1BTKzJuQUxkRHF6UWZmelZZUC9aS1dQ?=
 =?utf-8?B?cDlVVUZneEZQdkhiaVJsUjFXSDdZN20zNXQ5dWVkMG9OMzRVVHYyRXVTVUxD?=
 =?utf-8?B?QjljQnNaL1FZTENWUjJtWUFiTDlzUGlSd29YWXR6VlhUNEhHZnNQWURzUVd4?=
 =?utf-8?B?NzRKT1I5aURxUzhBTTNJbVd5WEhVczh1K2tRWGlmSzNCUjVGcFh1ZkYza0x6?=
 =?utf-8?B?QWFnc2ZUZFNxZ0tWZHhWc2x1Y3U5NzVOTkZubTZCenVaMkpQZUZLb1ZQTklp?=
 =?utf-8?Q?ylJnbmcATVzhg=3D?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN7PR11MB2610.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 760a3ff8-cfd7-456e-7f55-08d8bc4a97e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jan 2021 07:19:43.4039
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lyx6NCrfR/ykLwLCszFiYyjfBG9EV5CIi21mNzPyEF+p2IU42kc6nBwE/02fnC35INPTsvvQri7EDC9f/Bqj2A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB4179
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBIYW5zIGRlIEdvZWRlIDxoZGVn
b2VkZUByZWRoYXQuY29tPg0KPiBTZW50OiBNb25kYXksIEphbnVhcnkgMTgsIDIwMjEgMjM6MDkN
Cj4gVG86IFBlZXIsIElsYW4gPGlsYW4ucGVlckBpbnRlbC5jb20+OyBKb2hhbm5lcyBCZXJnDQo+
IDxqb2hhbm5lc0BzaXBzb2x1dGlvbnMubmV0PjsgRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2
ZW1sb2Z0Lm5ldD47DQo+IEpha3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBSb2pld3Nr
aSwgQ2V6YXJ5DQo+IDxjZXphcnkucm9qZXdza2lAaW50ZWwuY29tPjsgUGllcnJlLUxvdWlzIEJv
c3NhcnQgPHBpZXJyZS0NCj4gbG91aXMuYm9zc2FydEBsaW51eC5pbnRlbC5jb20+OyBMaWFtIEdp
cmR3b29kDQo+IDxsaWFtLnIuZ2lyZHdvb2RAbGludXguaW50ZWwuY29tPjsgSmllIFlhbmcgPHlh
bmcuamllQGxpbnV4LmludGVsLmNvbT47DQo+IE1hcmsgQnJvd24gPGJyb29uaWVAa2VybmVsLm9y
Zz4NCj4gQ2M6IGxpbnV4LXdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGFsc2EtZGV2ZWxAYWxz
YS1wcm9qZWN0Lm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIXSBjZmc4MDIxMTogRml4ICJzdXNw
aWNpb3VzIFJDVSB1c2FnZSBpbg0KPiB3aXBoeV9hcHBseV9jdXN0b21fcmVndWxhdG9yeSIgd2Fy
bmluZy9iYWNrdHJhY2UNCj4gDQo+IEhpLA0KPiANCj4gT24gMS81LzIxIDEwOjI0IEFNLCBQZWVy
LCBJbGFuIHdyb3RlOg0KPiA+IEhpLA0KPiA+DQo+ID4+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+ID4+IEZyb206IEhhbnMgZGUgR29lZGUgPGhkZWdvZWRlQHJlZGhhdC5jb20+DQo+ID4+
IFNlbnQ6IE1vbmRheSwgSmFudWFyeSAwNCwgMjAyMSAxOTowNw0KPiA+PiBUbzogSm9oYW5uZXMg
QmVyZyA8am9oYW5uZXNAc2lwc29sdXRpb25zLm5ldD47IERhdmlkIFMgLiBNaWxsZXINCj4gPj4g
PGRhdmVtQGRhdmVtbG9mdC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsg
Um9qZXdza2ksDQo+ID4+IENlemFyeSA8Y2V6YXJ5LnJvamV3c2tpQGludGVsLmNvbT47IFBpZXJy
ZS1Mb3VpcyBCb3NzYXJ0IDxwaWVycmUtDQo+ID4+IGxvdWlzLmJvc3NhcnRAbGludXguaW50ZWwu
Y29tPjsgTGlhbSBHaXJkd29vZA0KPiA+PiA8bGlhbS5yLmdpcmR3b29kQGxpbnV4LmludGVsLmNv
bT47IEppZSBZYW5nDQo+ID4+IDx5YW5nLmppZUBsaW51eC5pbnRlbC5jb20+OyBNYXJrIEJyb3du
IDxicm9vbmllQGtlcm5lbC5vcmc+DQo+ID4+IENjOiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUBy
ZWRoYXQuY29tPjsgbGludXgtDQo+ID4+IHdpcmVsZXNzQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgbGludXgtDQo+ID4+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IGFs
c2EtZGV2ZWxAYWxzYS1wcm9qZWN0Lm9yZzsgUGVlciwgSWxhbg0KPiA+PiA8aWxhbi5wZWVyQGlu
dGVsLmNvbT4NCj4gPj4gU3ViamVjdDogW1BBVENIXSBjZmc4MDIxMTogRml4ICJzdXNwaWNpb3Vz
IFJDVSB1c2FnZSBpbg0KPiA+PiB3aXBoeV9hcHBseV9jdXN0b21fcmVndWxhdG9yeSIgd2Fybmlu
Zy9iYWNrdHJhY2UNCj4gPj4NCj4gPj4gQ29tbWl0IGJlZWUyNDY5NTE1NyAoImNmZzgwMjExOiBT
YXZlIHRoZSByZWd1bGF0b3J5IGRvbWFpbiB3aGVuDQo+ID4+IHNldHRpbmcgY3VzdG9tIHJlZ3Vs
YXRvcnkiKSBhZGRzIGEgZ2V0X3dpcGh5X3JlZ2RvbSBjYWxsIHRvDQo+ID4+IHdpcGh5X2FwcGx5
X2N1c3RvbV9yZWd1bGF0b3J5LiBCdXQgYXMgdGhlIGNvbW1lbnQgYWJvdmUNCj4gPj4gd2lwaHlf
YXBwbHlfY3VzdG9tX3JlZ3VsYXRvcnkgc2F5czoNCj4gPj4gIi8qIFVzZWQgYnkgZHJpdmVycyBw
cmlvciB0byB3aXBoeSByZWdpc3RyYXRpb24gKi8iDQo+ID4+IHRoaXMgZnVuY3Rpb24gaXMgdXNl
ZCBieSBkcml2ZXIncyBwcm9iZSBmdW5jdGlvbiBiZWZvcmUgdGhlIHdpcGh5IGlzDQo+ID4+IHJl
Z2lzdGVyZWQgYW5kIGF0IHRoaXMgcG9pbnQgd2lwaHktPnJlZ2Qgd2lsbCB0eXBpY2FsbHkgYnkg
TlVMTCBhbmQNCj4gPj4gY2FsbGluZyByY3VfZGVyZWZlcmVuY2VfcnRubCBvbiBhIE5VTEwgcG9p
bnRlciBjYXVzZXMgdGhlIGZvbGxvd2luZw0KPiA+PiB3YXJuaW5nL2JhY2t0cmFjZToNCj4gPj4N
Cj4gPj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT0NCj4gPj4gV0FSTklORzogc3VzcGlj
aW91cyBSQ1UgdXNhZ2UNCj4gPj4gNS4xMS4wLXJjMSsgIzE5IFRhaW50ZWQ6IEcgICAgICAgIFcN
Cj4gPj4gLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0NCj4gPj4gbmV0L3dpcmVsZXNzL3Jl
Zy5jOjE0NCBzdXNwaWNpb3VzIHJjdV9kZXJlZmVyZW5jZV9jaGVjaygpIHVzYWdlIQ0KPiA+Pg0K
PiA+PiBvdGhlciBpbmZvIHRoYXQgbWlnaHQgaGVscCB1cyBkZWJ1ZyB0aGlzOg0KPiA+Pg0KPiA+
PiByY3Vfc2NoZWR1bGVyX2FjdGl2ZSA9IDIsIGRlYnVnX2xvY2tzID0gMQ0KPiA+PiAyIGxvY2tz
IGhlbGQgYnkga3dvcmtlci8yOjAvMjI6DQo+ID4+ICAjMDogZmZmZjlhNGJjMTA0ZGYzOCAoKHdx
X2NvbXBsZXRpb24pZXZlbnRzKXsrLisufS17MDowfSwgYXQ6DQo+ID4+IHByb2Nlc3Nfb25lX3dv
cmsrMHgxZWUvMHg1NzANCj4gPj4gICMxOiBmZmZmYjZlOTQwMTBiZTc4DQo+ID4+ICgod29ya19j
b21wbGV0aW9uKSgmZndfd29yay0+d29yaykpeysuKy59LXswOjB9LA0KPiA+PiBhdDogcHJvY2Vz
c19vbmVfd29yaysweDFlZS8weDU3MA0KPiA+Pg0KPiA+PiBzdGFjayBiYWNrdHJhY2U6DQo+ID4+
IENQVTogMiBQSUQ6IDIyIENvbW06IGt3b3JrZXIvMjowIFRhaW50ZWQ6IEcgICAgICAgIFcgICAg
ICAgICA1LjExLjAtcmMxKyAjMTkNCj4gPj4gSGFyZHdhcmUgbmFtZTogTEVOT1ZPIDYwMDczL0lO
VkFMSUQsIEJJT1MgMDFXVDE3V1cgMDgvMDEvMjAxNA0KPiA+PiBXb3JrcXVldWU6IGV2ZW50cyBy
ZXF1ZXN0X2Zpcm13YXJlX3dvcmtfZnVuYyBDYWxsIFRyYWNlOg0KPiA+PiAgZHVtcF9zdGFjaysw
eDhiLzB4YjANCj4gPj4gIGdldF93aXBoeV9yZWdkb20rMHg1Ny8weDYwIFtjZmc4MDIxMV0NCj4g
Pj4gIHdpcGh5X2FwcGx5X2N1c3RvbV9yZWd1bGF0b3J5KzB4YTAvMHhmMCBbY2ZnODAyMTFdDQo+
ID4+ICBicmNtZl9jZmc4MDIxMV9hdHRhY2grMHhiMDIvMHgxMzYwIFticmNtZm1hY10NCj4gPj4g
IGJyY21mX2F0dGFjaCsweDE4OS8weDQ2MCBbYnJjbWZtYWNdDQo+ID4+ICBicmNtZl9zZGlvX2Zp
cm13YXJlX2NhbGxiYWNrKzB4NzhhLzB4OGYwIFticmNtZm1hY10NCj4gPj4gIGJyY21mX2Z3X3Jl
cXVlc3RfZG9uZSsweDY3LzB4ZjAgW2JyY21mbWFjXQ0KPiA+PiAgcmVxdWVzdF9maXJtd2FyZV93
b3JrX2Z1bmMrMHgzZC8weDcwDQo+ID4+ICBwcm9jZXNzX29uZV93b3JrKzB4MjZlLzB4NTcwDQo+
ID4+ICB3b3JrZXJfdGhyZWFkKzB4NTUvMHgzYzANCj4gPj4gID8gcHJvY2Vzc19vbmVfd29yaysw
eDU3MC8weDU3MA0KPiA+PiAga3RocmVhZCsweDEzNy8weDE1MA0KPiA+PiAgPyBfX2t0aHJlYWRf
YmluZF9tYXNrKzB4NjAvMHg2MA0KPiA+PiAgcmV0X2Zyb21fZm9yaysweDIyLzB4MzANCj4gPj4N
Cj4gPj4gQWRkIGEgY2hlY2sgZm9yIHdpcGh5LT5yZWdkIGJlaW5nIE5VTEwgYmVmb3JlIGNhbGxp
bmcNCj4gPj4gZ2V0X3dpcGh5X3JlZ2RvbSAoYXMgaXMgYWxyZWFkeSBkb25lIGluIG90aGVyIHBs
YWNlcykgdG8gZml4IHRoaXMuDQo+ID4+DQo+ID4+IHdpcGh5LT5yZWdkIHdpbGwgbGlrZWx5IGFs
d2F5cyBiZSBOVUxMIHdoZW4NCj4gPj4gd2lwaHktPndpcGh5X2FwcGx5X2N1c3RvbV9yZWd1bGF0
b3J5DQo+ID4+IGdldHMgY2FsbGVkLCBzbyBhcmd1YWJseSB0aGUgdG1wID0gZ2V0X3dpcGh5X3Jl
Z2RvbSgpIGFuZA0KPiA+PiByY3VfZnJlZV9yZWdkb20odG1wKSBjYWxscyBzaG91bGQgc2ltcGx5
IGJlIGRyb3BwZWQsIHRoaXMgcGF0Y2gga2VlcHMNCj4gPj4gdGhlDQo+ID4+IDIgY2FsbHMsIHRv
IGFsbG93IGRyaXZlcnMgdG8gY2FsbCB3aXBoeV9hcHBseV9jdXN0b21fcmVndWxhdG9yeSBtb3Jl
DQo+ID4+IHRoZW4gb25jZSBpZiBuZWNlc3NhcnkuDQo+ID4+DQo+ID4+IENjOiBJbGFuIFBlZXIg
PGlsYW4ucGVlckBpbnRlbC5jb20+DQo+ID4+IEZpeGVzOiBiZWVlMjQ2OTUxNTcgKCJjZmc4MDIx
MTogU2F2ZSB0aGUgcmVndWxhdG9yeSBkb21haW4gd2hlbg0KPiA+PiBzZXR0aW5nIGN1c3RvbSBy
ZWd1bGF0b3IiKQ0KPiA+PiBTaWduZWQtb2ZmLWJ5OiBIYW5zIGRlIEdvZWRlIDxoZGVnb2VkZUBy
ZWRoYXQuY29tPg0KPiA+PiAtLS0NCj4gPj4gIG5ldC93aXJlbGVzcy9yZWcuYyB8IDUgKysrLS0N
Cj4gPj4gIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+
ID4+DQo+ID4+IGRpZmYgLS1naXQgYS9uZXQvd2lyZWxlc3MvcmVnLmMgYi9uZXQvd2lyZWxlc3Mv
cmVnLmMgaW5kZXgNCj4gPj4gYmI3MjQ0N2FkOTYwLi45MjU0YjljYmFhMjEgMTAwNjQ0DQo+ID4+
IC0tLSBhL25ldC93aXJlbGVzcy9yZWcuYw0KPiA+PiArKysgYi9uZXQvd2lyZWxlc3MvcmVnLmMN
Cj4gPj4gQEAgLTI1NDcsNyArMjU0Nyw3IEBAIHN0YXRpYyB2b2lkIGhhbmRsZV9iYW5kX2N1c3Rv
bShzdHJ1Y3Qgd2lwaHkNCj4gPj4gKndpcGh5LCAgdm9pZCB3aXBoeV9hcHBseV9jdXN0b21fcmVn
dWxhdG9yeShzdHJ1Y3Qgd2lwaHkgKndpcGh5LA0KPiA+PiAgCQkJCSAgIGNvbnN0IHN0cnVjdCBp
ZWVlODAyMTFfcmVnZG9tYWluICpyZWdkKSAgew0KPiA+PiAtCWNvbnN0IHN0cnVjdCBpZWVlODAy
MTFfcmVnZG9tYWluICpuZXdfcmVnZCwgKnRtcDsNCj4gPj4gKwljb25zdCBzdHJ1Y3QgaWVlZTgw
MjExX3JlZ2RvbWFpbiAqbmV3X3JlZ2QsICp0bXAgPSBOVUxMOw0KPiA+PiAgCWVudW0gbmw4MDIx
MV9iYW5kIGJhbmQ7DQo+ID4+ICAJdW5zaWduZWQgaW50IGJhbmRzX3NldCA9IDA7DQo+ID4+DQo+
ID4+IEBAIC0yNTcxLDcgKzI1NzEsOCBAQCB2b2lkIHdpcGh5X2FwcGx5X2N1c3RvbV9yZWd1bGF0
b3J5KHN0cnVjdA0KPiB3aXBoeQ0KPiA+PiAqd2lwaHksDQo+ID4+ICAJaWYgKElTX0VSUihuZXdf
cmVnZCkpDQo+ID4+ICAJCXJldHVybjsNCj4gPj4NCj4gPj4gLQl0bXAgPSBnZXRfd2lwaHlfcmVn
ZG9tKHdpcGh5KTsNCj4gPj4gKwlpZiAod2lwaHktPnJlZ2QpDQo+ID4+ICsJCXRtcCA9IGdldF93
aXBoeV9yZWdkb20od2lwaHkpOw0KPiA+PiAgCXJjdV9hc3NpZ25fcG9pbnRlcih3aXBoeS0+cmVn
ZCwgbmV3X3JlZ2QpOw0KPiA+PiAgCXJjdV9mcmVlX3JlZ2RvbSh0bXApOw0KPiA+DQo+ID4gVGhp
cyBvbmx5IGZpeGVzIHRoZSBmaXJzdCBjYXNlIHdoZXJlIHRoZSBwb2ludGVyIGluIE5VTEwgYW5k
IGRvZXMgbm90IGhhbmRsZQ0KPiB0aGUgd3JvbmcgUkNVIHVzYWdlIGluIG90aGVyIGNhc2VzLg0K
PiA+DQo+ID4gSSdsbCBwcmVwYXJlIGEgZml4IGZvciB0aGlzLg0KPiANCj4gQW55IGx1Y2sgd2l0
aCB0aGlzPyBUaGlzIGlzIGEgcmVncmVzc2lvbiBpbiA1LjExLCBzbyB0aGlzIHJlYWxseSBzaG91
bGQgYmUgZml4ZWQgaW4NCj4gYSBmdXR1cmUgNS4xMS1yYyBhbmQgdGhlIGNsb2NrIGlzIHJ1bm5p
bmcgb3V0Lg0KPiANCg0KWWVzLiBUaGUgZml4IGlzIHJlYWR5LiBXZSdsbCBzZW5kIGl0Lg0KDQpS
ZWdhcmRzLA0KDQpJbGFuLg0K
