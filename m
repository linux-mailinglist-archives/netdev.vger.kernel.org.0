Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAFE2191C7
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 22:45:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726276AbgGHUpL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 16:45:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:50817 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725964AbgGHUpK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 16:45:10 -0400
IronPort-SDR: YYGTjTLOUwRltevue24cDET9+2U+lkTCTviloi4AGh03nTIqZic2sYKYj6nU3ZvIk8ptCdmUvs
 wMZolQBKaoOg==
X-IronPort-AV: E=McAfee;i="6000,8403,9676"; a="232774715"
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="232774715"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Jul 2020 13:45:09 -0700
IronPort-SDR: VH7qaLowxxQ4zX0oGlI78aU47chwEXOHcc/UB1S4fcILpnoM+Vycvj2QkO/4I0KfuUbsdtxHLT
 Gm3zlFRWNoqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,329,1589266800"; 
   d="scan'208";a="268564063"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga008.fm.intel.com with ESMTP; 08 Jul 2020 13:45:08 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jul 2020 13:45:04 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 8 Jul 2020 13:45:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Wed, 8 Jul 2020 13:45:02 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mBUsApAeDtfsNQzHFTwkO4/ihBN8HDrh0kVz6Zk9CHIWASGNZohzxNFdBOdpNmxvRXXE7/FM2vwZ1CATQtLXQY1hPivaRPFkPzYy8pu3SJplycNSZQIbw7e/bd/0h3wZ/bLtilSoquuqo23mfMDm5emVe3KF7V2TfQnw4OuGE0n5sNnAiSAJaEG9EqdM8qNUqDUTAb2Gs/xAzujZNGGw3aovYKhdCSuix4SdKvfYRF9c+1ztgcEZlpYoKeCRd+gVvubUBY84S+MqXn9kpnEmGarTGkBVS4lN0KskswBK1wwi8yPJXQiVlVFLT9O+ThDQ2tYlp1AepXmR+t88zmsALQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tbiv1+AYQ17zi2dF2Z1vEDyS7squmTMYV8esbj//KI=;
 b=DBPocrcliSuo8xX4zpK6xitWvgJtR554GRDv5lKJNkDaUcv+80lvHv98pQmJ3Zm21UPjWa7s8hLoUevkgq1M4ue+57WOtAbatMU/yukXboLZQvHkuhaXCQX6z129pfJWf2oZsjnKWVzmRNxSUKgK0lnmAhM8Ykj7pnLOWFS7YSyFvwcHD3kaTfN8brO2Rm/eBhcBAUlZ6gdPwkYv+30eKPoa1hUXoWg41COvNhc306JM9PhAxSZPewF9c4kgIe+Dz5sXN84wTTgAm35G36Sb3h0C0L/QLTLUyavLMXahhBfr5XqV43T5dpbcWzfIvfjDakHT8QaDvRGSX6HO1ahT2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1tbiv1+AYQ17zi2dF2Z1vEDyS7squmTMYV8esbj//KI=;
 b=zBSezrc7YxgwVmyZC5sxbCGpC0K6Z3hAE6nmPwWNHEWhBnAtKjoyZgw4RYtwvHiVZ0iyFRl/bk2ZQ1vq57OZSXLu8xB7DOFR4csXRB+XM63fq249Sll4qHwxi5YM6qyA6TInlvDBml4HWizq54kYYwSbT5rOwaxAcDgVFFHPRs4=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN7PR11MB2594.namprd11.prod.outlook.com
 (2603:10b6:406:b5::31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.23; Wed, 8 Jul
 2020 20:45:01 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::6cc1:1382:c39c:18e3%9]) with mapi id 15.20.3174.022; Wed, 8 Jul 2020
 20:45:01 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next 4/4] i40e, xsk: move buffer
 allocation out of the Rx processing loop
Thread-Topic: [Intel-wired-lan] [PATCH net-next 4/4] i40e, xsk: move buffer
 allocation out of the Rx processing loop
Thread-Index: AQHWUIbXBY/tQeYWKkmJiY0Mw2lXlaj+MChw
Date:   Wed, 8 Jul 2020 20:45:01 +0000
Message-ID: <BN6PR1101MB214588230CD9820C8AAF3C298C670@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200702153730.575738-1-bjorn.topel@gmail.com>
 <20200702153730.575738-5-bjorn.topel@gmail.com>
In-Reply-To: <20200702153730.575738-5-bjorn.topel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.55.52.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c2278bda-1ecd-42e6-83f7-08d8237fc923
x-ms-traffictypediagnostic: BN7PR11MB2594:
x-microsoft-antispam-prvs: <BN7PR11MB259458D1F824A69FFDDF54648C670@BN7PR11MB2594.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1443;
x-forefront-prvs: 04583CED1A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QvDFteUjbMZmFBUXDbIOuFMFte6zsebnjOcSaHUzLJIxQF5vY7UeYd/mgDThYbmBwM7fbaxLqK7BKNLfLM415PfYCcNW4li5pmY8pVYGXw0XAHphYFUS+dJMr6GmGFbzLQIE8+gQg0rLw5kLQMFB9gpYFrd8zuogXkbxe8yA10uaBQ36biMVOqdHWSX6uKofKTbXUe/bwsymQcnlmK6KRqW8HFSshwO9EpjNZwEHUB4ZyPf9clcs6qrgC6a5OrKiUAx2A+5JzUGVbOxhbZVPAOh0WvWOiG/rp4L8Mi4Slnn5bOZ6xDEMddRAX4mPHigXYTrPSJcgnmcudHHHledPow==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(396003)(136003)(346002)(376002)(39860400002)(478600001)(33656002)(4744005)(186003)(54906003)(316002)(4326008)(6916009)(71200400001)(9686003)(55016002)(7696005)(64756008)(8936002)(2906002)(66476007)(76116006)(66556008)(8676002)(66946007)(52536014)(53546011)(86362001)(6506007)(26005)(5660300002)(83380400001)(66446008)(66574015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: gfBi3YksFmvkofbibUp7qvzfzHFaAZ35KP8B+FsLnPyskW92eUfPw6uNODFXSfyVDghJnUtjncGwE2OcsZfOFQzjcJrUvIhU4BmFrcUOIDTCnQwM/PlMupBVc4oZ4n1i1FmrCKid+OtRsVN1K0iHUB3wrKwyQ7Ona7Flk1Fw1teU69JLpUvPjY167obI63MF2eLKA0LTEQngjgRQdmCyum5Y4zDKLqS6+w1rKUuKKkJavNEDKWqLLw0B0jlOm3mNeMNGcpHiQMrgPrpNm/QONd7FJXdfOc5YlBI6s8aJMHlMao6iLXPoHoSq5bDBozY0YF9m5gF3h4tUKd4yn1Mj1H1ZwHsidZe3JXg+537q7RnsrEKpXA1rVfDR2RuvdnN6pbogiVQSOkvDj0uC0N1d6skasIFX5tIl1CsgbisrtIWLBMNNso80qPIxv4KODbzpWnGN753MGNsZwfBO4Gzo5blom51fxrHLxOKHt+SCX4Q=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN6PR1101MB2145.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c2278bda-1ecd-42e6-83f7-08d8237fc923
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2020 20:45:01.3622
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eRo5jT7q+M/2R9+mkZxipaUMJk+4K54TqnIkG88U0oNVR97yoQrM0Wyu3lrt0ayhB+9GVkvRalR3QUz3DekMnxEB0xLClICeyY67bGUtcoQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2594
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGlu
dGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5vcmc+IE9uIEJlaGFsZiBPZg0KPiBCasO2cm4g
VMO2cGVsDQo+IFNlbnQ6IFRodXJzZGF5LCBKdWx5IDIsIDIwMjAgODozOCBBTQ0KPiBUbzogaW50
ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmcNCj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmc7IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IFRvcGVsLCBCam9ybg0KPiA8Ympvcm4udG9wZWxAaW50
ZWwuY29tPjsgS2FybHNzb24sIE1hZ251cyA8bWFnbnVzLmthcmxzc29uQGludGVsLmNvbT4NCj4g
U3ViamVjdDogW0ludGVsLXdpcmVkLWxhbl0gW1BBVENIIG5ldC1uZXh0IDQvNF0gaTQwZSwgeHNr
OiBtb3ZlIGJ1ZmZlcg0KPiBhbGxvY2F0aW9uIG91dCBvZiB0aGUgUnggcHJvY2Vzc2luZyBsb29w
DQo+IA0KPiBGcm9tOiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQo+IA0K
PiBJbnN0ZWFkIG9mIGNoZWNraW5nIGluIGVhY2ggaXRlcmF0aW9uIG9mIHRoZSBSeCBwYWNrZXQg
cHJvY2Vzc2luZyBsb29wLCBtb3ZlDQo+IHRoZSBhbGxvY2F0aW9uIG91dCBvZiB0aGUgbG9vcCBh
bmQgZG8gaXQgb25jZSBmb3IgZWFjaCBuYXBpIGFjdGl2YXRpb24uDQo+IA0KPiBGb3IgQUZfWERQ
IHRoZSByeF9kcm9wIGJlbmNobWFyayB3YXMgaW1wcm92ZWQgYnkgNiUuDQo+IA0KPiBTaWduZWQt
b2ZmLWJ5OiBCasO2cm4gVMO2cGVsIDxiam9ybi50b3BlbEBpbnRlbC5jb20+DQo+IC0tLQ0KPiAg
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jIHwgMTIgKysrKy0tLS0t
LS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0K
DQpUZXN0ZWQtYnk6IEFuZHJldyBCb3dlcnMgPGFuZHJld3guYm93ZXJzQGludGVsLmNvbT4NCg0K
DQo=
