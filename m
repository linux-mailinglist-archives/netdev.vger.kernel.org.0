Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908662FC798
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 03:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729454AbhATCPr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 21:15:47 -0500
Received: from mga03.intel.com ([134.134.136.65]:50465 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728441AbhATCP2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 21:15:28 -0500
IronPort-SDR: deyhqaoEiawe1TE2mNjPIr8jZ7GIrC9ev7klCO9H+pKTcc+DfrcOLslpCmkjEMKiWWqmqbXYAO
 Thgt7v6vfZqA==
X-IronPort-AV: E=McAfee;i="6000,8403,9869"; a="179117207"
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="179117207"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2021 18:14:46 -0800
IronPort-SDR: R3XNQWfvlN2vc0Fb2jmd6PWOpB6natzcUhgDKuDYN2OiG2Kq+j1u0SwvGTGmnMPDLfTPrAgUHr
 hMAcQ9yLK3NQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.79,359,1602572400"; 
   d="scan'208";a="406743061"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 19 Jan 2021 18:14:44 -0800
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 19 Jan 2021 18:14:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 19 Jan 2021 18:14:43 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Tue, 19 Jan 2021 18:13:38 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=exqMZI/9AG62VGK29pbEaMveyhXDIaag5uYlvhm2P++7p+f8qbKwCkYpcO+hxmIHi7Pnu4Di9A4NweyqqqrV+ipzBeKbEuC/GGAwlU2tiy2Sc45fjNCAmP+cMj4VCx3h8xQXX9B1mV7rJyR974QMEScodJcCmL/g5mlEiWefqp+ycjN+uvmEqzQw7zvuLAxZkiD6mGLFV4LbJgukpe9ZB604rh0ug4l5e6bdbA4cfIFbu83anRWloYTWLN9CTAk+ghSmhhmsQPkavTieAB9+dmdgS4yMe9cKUgHyZMXRNkJFD1RovsaOGEqBkBVgrVB9TBaijJEgVYMaQYngA9P9jg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDynLvH1uioZmjbfHa9y048/cpzNv6slvU/eYZuM6J4=;
 b=mp9HFOgGfyC+DvBhwRy32pzpoSoxtFZRvbVJCdyYy+KQgsbAkR+WpsGKdtXZrVNopPWF6K7cXjXUHx3jqu7tv6/m/hkBht1cfes0/Ddr+y4miD6G+oHWYSRHhFyI4n9Xm4HmKuhsGE+mLGArZbMNPOKWuks5c2pA7S/Z8BWrWpyOnzqISFEELGKd6rogK4KFNJzVOlTgMwYQ+YN8Lz+2kfZuH2h46RJbGDQOqH1wA7fIFKafbGiIZEWbDgjR8AL9YErKvl4eH/SNz4SOz7giVc5PrQ67Iv3UZXaDNqS+k7zqG6jnIo148yJ/WKef7W/a83Jp3mfr2KJS4tSBFwu8/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=cDynLvH1uioZmjbfHa9y048/cpzNv6slvU/eYZuM6J4=;
 b=ET55Vtkm4CeaDbhhOUzON5ErzneZWTz6qv6QMEHzGmyvkJtuzh4+mN8jp12WxjJXXc15kwD5u1pam9irEZk4xjZBGL3ptCoDC0azNbCMebnA56G5L29isaavg01kNyIZkLaKaCz1XkvCJXccgxwOVFSSDvpMHb/30aiLeWFh7CE=
Received: from MW3PR11MB4764.namprd11.prod.outlook.com (2603:10b6:303:5a::16)
 by MW3PR11MB4569.namprd11.prod.outlook.com (2603:10b6:303:54::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Wed, 20 Jan
 2021 02:13:36 +0000
Received: from MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::851c:df49:9853:26af]) by MW3PR11MB4764.namprd11.prod.outlook.com
 ([fe80::851c:df49:9853:26af%8]) with mapi id 15.20.3763.014; Wed, 20 Jan 2021
 02:13:36 +0000
From:   "Venkataramanan, Anirudh" <anirudh.venkataramanan@intel.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     "Brelinski, TonyX" <tonyx.brelinski@intel.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Creeley, Brett" <brett.creeley@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Thread-Topic: [PATCH net-next 1/1] ice: Improve MSI-X vector enablement
 fallback logic
Thread-Index: AQHW6hko29AaKvr6HE2iTtaOFm6DP6on2oMAgAfQUoCAAAsJgIAAFs+A
Date:   Wed, 20 Jan 2021 02:13:36 +0000
Message-ID: <910a50d7ae84913e140d14aed11675f751254eb1.camel@intel.com>
References: <20210113234226.3638426-1-anthony.l.nguyen@intel.com>
         <20210114164252.74c1cf18@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <7272d1b6e6c447989cae07e7519422ab80518ca1.camel@intel.com>
         <20210119164147.36a77cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210119164147.36a77cf5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.139.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9060a192-eb3d-470e-b628-08d8bce8fe88
x-ms-traffictypediagnostic: MW3PR11MB4569:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4569ABEE62F295648F83488190A20@MW3PR11MB4569.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: e4Bnm9nI7RJKuu/mbodBPPvkogZBWLObSMlMZkvEbvftpGbGhx+F+9bcyvYLZO8EyqJr38877jJL/F6bXaJp0+s1g9WqCDg2zs+P6q+CURJA4rMiU8epz3EaaP+xuNDooZ/vm0/AWyEwCrG7DzmOuH6hGJrrcKTmj6DAlhEVSaUaBs+/4SzwIlgiFCnrytAB0Xf4YnitRpCOptHSMS6MO+bov1zS6duQt6nMpL591lVzFE0R+XeGPyc57+fQBNRfiFmyoqQgFhmAMyGxQA3nIsOHxIhaMKghh58dMXt3jQIJO26hU+v7R0xFGeFLPhNwaGQkXze05TD6G3pPltEhvHl8MlwTEprzAPQa1dV76sMvcKd/C+Dq8uIDN5py1d0TcGoUIfhdX78tY5JM+x6Yow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4764.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(376002)(366004)(346002)(136003)(396003)(186003)(8676002)(6512007)(2906002)(316002)(36756003)(5660300002)(54906003)(6506007)(4326008)(26005)(6486002)(76116006)(66446008)(2616005)(66556008)(8936002)(478600001)(66476007)(83380400001)(66946007)(6916009)(64756008)(86362001)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?TFdmeWlPZFhrSlVFeW5BWWJPU3ZVd2JyN1cxYVRMNzBrK0p4L1FZUHFPWGdG?=
 =?utf-8?B?OW8vbHdkNDRlL0lYVHNBV3Qrb2k5SzBHLzB4MUR2RXJPdlJteGd3eFZ4Q3Fk?=
 =?utf-8?B?cXIwMFpOUlkwb3NwUU5KbSthcmpmKzMwc2ZaRm9JU0RPcGRQYkE2MldJYXN3?=
 =?utf-8?B?MFRIbnMzSkRUanExS2pYTmcwYllGTUFsbmVyNlcvc1RXc2N0aDV5NGhjVUFR?=
 =?utf-8?B?YVVWMTFIOTFHelpFc0N5VDl5N3Z1N3FvWTQwa09OZThpNHNmcExhWlFkbDJn?=
 =?utf-8?B?T2d4OVU1SGZGUm52OEJ5dWljaUl4ck0ybUxuRTBJU3FwSGlsSWNtTjBzRlNJ?=
 =?utf-8?B?azRHTVpwUXZXU0dGbW0xL1hzcklTRjBHQ3A5Zy9yWEM3cXFXK0RsS2ZWV3dm?=
 =?utf-8?B?RU41MTNRNE9mcDM4SzF1ekNsTUwzTHhEOHRwckxFOW1Pb0xpa2NsYkRmaWd2?=
 =?utf-8?B?Tmtyd3RwSys0VGNaUFFWMTFiZW5udnRJRkhPaGtRWjJibENtQytWaS9tQWJL?=
 =?utf-8?B?WHV5OWd5R3FVMm1SMHA4WHFTbHpBZDd3MkpmRFFCVVJ6Z1FKV2FQRitZMGdP?=
 =?utf-8?B?d0tGZlU4RWl5RGRXck5xVC9ZQk5VbXFNdlBmcG5FZEsyQUJOWXdnNTJtM0Qz?=
 =?utf-8?B?QjNZbld3T00zNit5eFl3N2FtQjVkSWdyZzFWODZDMSt6ejFGbDdLN29iVjlk?=
 =?utf-8?B?b2E3ekg3Q0xERWxuZWhwQjhnQ0VBYmV4VHc1T1B6Mks5MEtkcUJqczBKbXhu?=
 =?utf-8?B?YXJKSUZhMk5QQTdjRVIwcThRTGRmMWxNVE9zUE0wQXREdDVwc3Rja0lKOFJZ?=
 =?utf-8?B?ZUxTQUxUTUtGcUUzM3BNbUJDTVVEdEFodldES3U5aWNtRDVvUmNDek93OEsz?=
 =?utf-8?B?UEtQbENSN3FPbzBjTy9MSTBiMUZYVzZxSmlqZVp6UVJwcFBmbS9GTmczdnBR?=
 =?utf-8?B?V0doMTlsSFBhZjRYZkpBR1VyYVEvemhVb0x3cStha25IRHhJSjlVaWpBbmc2?=
 =?utf-8?B?aENQNURRRjRDVkJnR3ZWYlNmcmt2cUs2djF3aCtNM1BwTStvdmpnMmxWbFRz?=
 =?utf-8?B?eStQQWorY0xDblQxa0pJbTU1Tm9STkJMbmdSZnJEWkc0ZXpzMmVselV1UFBC?=
 =?utf-8?B?MDMyYjhTV2ozLzduM0NoUGxzdnljNTZMc1BzZXp5dVVKOW1Jb08wVU9DNEZT?=
 =?utf-8?B?amJmT0VsQ0JDcm1TdXkzWUR0eDRUSTlwZWVvZVNFc0wxVmF2QmhGa25Kd2Rl?=
 =?utf-8?B?aTR0SDFrS2g0ZENpTXR3Q2x2cU9kbzVaZlV3MlJFNnRqSFJhTmQxWkxsQzJ2?=
 =?utf-8?Q?AlHgYrf/LaS6edM8O5wNiYulS2ntkEahoz?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2B0A8AC1B88F7C4F9498036A6729A90E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4764.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9060a192-eb3d-470e-b628-08d8bce8fe88
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Jan 2021 02:13:36.0836
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Vc5Ti1zCv64KJvdFe9bJOGhd+7jRAhuMgxBRqUhyBn4DvJZcrNpLGl5AGRoT4kHyvpDSBLiP2oH0IPaxHxtW/nJAPTOQll37qlicD6RoclybxRIwsLq/CL8LIlahHGSE
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4569
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAxLTE5IGF0IDE2OjQxIC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gV2VkLCAyMCBKYW4gMjAyMSAwMDoxMjoyNiArMDAwMCBWZW5rYXRhcmFtYW5hbiwgQW5p
cnVkaCB3cm90ZToNCj4gPiA+ID4gQXR0ZW1wdCBbMF06IEVuYWJsZSB0aGUgYmVzdC1jYXNlIHNj
ZW5hcmlvIE1TSS1YIHZlY3RvcnMuDQo+ID4gPiA+IA0KPiA+ID4gPiBBdHRlbXB0IFsxXTogRW5h
YmxlIE1TSS1YIHZlY3RvcnMgd2l0aCB0aGUgbnVtYmVyIG9mIHBmLSAgDQo+ID4gPiA+ID4gbnVt
X2xhbl9tc2l4ICANCj4gPiA+ID4gcmVkdWNlZCBieSBhIGZhY3RvciBvZiAyIGZyb20gdGhlIHBy
ZXZpb3VzIGF0dGVtcHQgKGkuZS4NCj4gPiA+ID4gbnVtX29ubGluZV9jcHVzKCkgLyAyKS4NCj4g
PiA+ID4gDQo+ID4gPiA+IEF0dGVtcHQgWzJdOiBTYW1lIGFzIGF0dGVtcHQgWzFdLCBleGNlcHQg
cmVkdWNlIGJ5IGEgZmFjdG9yIG9mDQo+ID4gPiA+IDQuDQo+ID4gPiA+IA0KPiA+ID4gPiBBdHRl
bXB0IFszXTogRW5hYmxlIHRoZSBiYXJlLW1pbmltdW0gTVNJLVggdmVjdG9ycy4NCj4gPiA+ID4g
DQo+ID4gPiA+IEFsc28sIGlmIHRoZSBhZGp1c3RlZF9iYXNlX21zaXggZXZlciBoaXRzIHRoZSBt
aW5pbXVtIHJlcXVpcmVkDQo+ID4gPiA+IGZvcg0KPiA+ID4gPiBMQU4sDQo+ID4gPiA+IHRoZW4g
anVzdCBzZXQgdGhlIG5lZWRlZCBNU0ktWCBmb3IgdGhhdCBmZWF0dXJlIHRvIHRoZSBtaW5pbXVt
DQo+ID4gPiA+IChzaW1pbGFyIHRvIGF0dGVtcHQgWzNdKS4gIA0KPiA+ID4gDQo+ID4gPiBJIGRv
bid0IHJlYWxseSBnZXQgd2h5IHlvdSBzd2l0Y2ggdG8gdGhpcyBtYW51YWwgImV4cG9uZW50aWFs
DQo+ID4gPiBiYWNrLQ0KPiA+ID4gb2ZmIg0KPiA+ID4gcmF0aGVyIHRoYW4gY29udGludWluZyB0
byB1c2UgcGNpX2VuYWJsZV9tc2l4X3JhbmdlKCksIGJ1dCBmaXhpbmcNCj4gPiA+IHRoZQ0KPiA+
ID4gY2FwcGluZyB0byBJQ0VfTUlOX0xBTl9WRUNTLiAgDQo+ID4gDQo+ID4gQXMgcGVyIHRoZSBj
dXJyZW50IGxvZ2ljLCBpZiB0aGUgZHJpdmVyIGRvZXMgbm90IGdldCB0aGUgbnVtYmVyIG9mDQo+
ID4gTVNJLQ0KPiA+IFggdmVjdG9ycyBpdCBuZWVkcywgaXQgd2lsbCBpbW1lZGlhdGVseSBkcm9w
IHRvICJEbyBJIGhhdmUgYXQgbGVhc3QNCj4gPiB0d28NCj4gPiAoSUNFX01JTl9MQU5fVkVDUykg
TVNJLVggdmVjdG9ycz8iLiBJZiB5ZXMsIHRoZSBkcml2ZXIgd2lsbCBlbmFibGUNCj4gPiBhDQo+
ID4gc2luZ2xlIFR4L1J4IHRyYWZmaWMgcXVldWUgcGFpciwgYm91bmQgdG8gb25lIG9mIHRoZSB0
d28gTVNJLVgNCj4gPiB2ZWN0b3JzLg0KPiA+IA0KPiA+IFRoaXMgaXMgYSBiaXQgb2YgYW4gYWxs
LW9yLW5vdGhpbmcgdHlwZSBhcHByb2FjaC4gVGhlcmUncyBhIG1pZC0NCj4gPiBncm91bmQNCj4g
PiB0aGF0IGNhbiBhbGxvdyBtb3JlIHF1ZXVlcyB0byBiZSBlbmFibGVkIChleC4gZHJpdmVyIGFz
a2VkIGZvciAzMDANCj4gPiB2ZWN0b3JzLCBidXQgZ290IDY4IHZlY3RvcnMsIHNvIGVuYWJsZWQg
NjQgZGF0YSBxdWV1ZXMpIGFuZCB0aGlzDQo+ID4gcGF0Y2gNCj4gPiBpbXBsZW1lbnRzIHRoZSBt
aWQtZ3JvdW5kIGxvZ2ljLiANCj4gPiANCj4gPiBUaGlzIG1pZC1ncm91bmQgbG9naWMgY2FuIGFs
c28gYmUgaW1wbGVtZW50ZWQgYmFzZWQgb24gdGhlIHJldHVybg0KPiA+IHZhbHVlDQo+ID4gb2Yg
cGNpX2VuYWJsZV9tc2l4X3JhbmdlKCkgYnV0IElNSE8gdGhlIGltcGxlbWVudGF0aW9uIGluIHRo
aXMNCj4gPiBwYXRjaA0KPiA+IHVzaW5nIHBjaV9lbmFibGVfbXNpeF9leGFjdCBpcyBiZXR0ZXIg
YmVjYXVzZSBpdCdzIGFsd2F5cyBvbmx5DQo+ID4gZW5hYmxpbmcvcmVzZXJ2aW5nIGFzIG1hbnkg
TVNJLVggdmVjdG9ycyBhcyByZXF1aXJlZCwgbm90IG1vcmUsIG5vdA0KPiA+IGxlc3MuDQo+IA0K
PiBXaGF0IGRvIHlvdSBtZWFuIGJ5ICJyZXF1aXJlZCIgaW4gdGhlIGxhc3Qgc2VudGVuY2U/IA0K
DQouLiBhcyAicmVxdWlyZWQiIGluIHRoYXQgcGFydGljdWxhciBpdGVyYXRpb24gb2YgdGhlIGxv
b3AuDQoNCj4gVGhlIGRyaXZlcg0KPiByZXF1ZXN0cyBudW1fb25saW5lX2NwdXMoKS13b3J0aCBv
ZiBJUlFzLCBzbyBpdCBtdXN0IHdvcmsgd2l0aCBhbnkNCj4gbnVtYmVyIG9mIElSUXMuIFdoeSBp
cyBudW1fY3B1cygpIC8gMSwyLDQsOCAicmVxdWlyZWQiPw0KDQpMZXQgbWUgYmFjayB1cCBhIGJp
dCBoZXJlLiANCg0KVWx0aW1hdGVseSwgdGhlIGlzc3VlIHdlIGFyZSB0cnlpbmcgdG8gc29sdmUg
aGVyZSBpcyAid2hhdCBoYXBwZW5zIHdoZW4NCnRoZSBkcml2ZXIgZG9lc24ndCBnZXQgYXMgbWFu
eSBNU0ktWCB2ZWN0b3JzIGFzIGl0IG5lZWRzLCBhbmQgaG93IGl0J3MNCmludGVycHJldGVkIGJ5
IHRoZSBlbmQgdXNlciINCg0KTGV0J3Mgc2F5IHRoZXJlIGFyZSB0aGVzZSB0d28gc3lzdGVtcywg
ZWFjaCB3aXRoIDI1NiBjb3JlcyBidXQgdGhlDQpyZXNwb25zZSB0byBwY2lfZW5hYmxlX21zaXhf
cmFuZ2UoKSBpcyBkaWZmZXJlbnQ6DQoNClN5c3RlbSAxOiAyNTYgY29yZXMsIHBjaV9lbmFibGVf
bXNpeF9yYW5nZSByZXR1cm5zIDc1IHZlY3RvcnMNClN5c3RlbSAyOiAyNTYgY29yZXMsIHBjaV9l
bmFibGVfbXNpeF9yYW5nZSByZXR1cm5zIDIyMCB2ZWN0b3JzIA0KDQpJbiB0aGlzIGNhc2UsIHRo
ZSBudW1iZXIgb2YgcXVldWVzIHRoZSB1c2VyIHdvdWxkIHNlZSBlbmFibGVkIG9uIGVhY2gNCm9m
IHRoZXNlIHN5c3RlbXMgd291bGQgYmUgdmVyeSBkaWZmZXJlbnQgKDczIG9uIHN5c3RlbSAxIGFu
ZCAyMTggb24NCnN5c3RlbSAyKS4gVGhpcyB2YXJpYWJpbHR5IG1ha2VzIGl0IGRpZmZpY3VsdCB0
byBkZWZpbmUgd2hhdCB0aGUNCmV4cGVjdGVkIGJlaGF2aW9yIHNob3VsZCBiZSwgYmVjYXVzZSBp
dCdzIG5vdCBleGFjdGx5IG9idmlvdXMgdG8gdGhlDQp1c2VyIGhvdyBtYW55IGZyZWUgTVNJLVgg
dmVjdG9ycyBhIGdpdmVuIHN5c3RlbSBoYXMuIEluc3RlYWQsIGlmIHRoZQ0KZHJpdmVyIHJlZHVj
ZWQgaXQncyBkZW1hbmQgZm9yIHZlY3RvcnMgaW4gYSB3ZWxsIGRlZmluZWQgbWFubmVyDQoobnVt
X2NwdXMoKSAvIDEsMiw0LDgpLCB0aGUgdXNlciB2aXNpYmxlIGRpZmZlcmVuY2UgYmV0d2VlbiB0
aGUgdHdvDQpzeXN0ZW1zIHdvdWxkbid0IGJlIHNvIGRyYXN0aWMuDQoNCklmIHRoaXMgaXMgcGxh
aW4gd3Jvbmcgb3IgaWYgdGhlcmUncyBhIHByZWZlcnJlZCBhcHByb2FjaCwgSSdkIGJlIGhhcHB5
DQp0byBkaXNjdXNzIGZ1cnRoZXIuDQoNCkFuaQ0K
