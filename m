Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 376521ECBDF
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 10:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726410AbgFCIuS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jun 2020 04:50:18 -0400
Received: from mga02.intel.com ([134.134.136.20]:42523 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726295AbgFCIuR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Jun 2020 04:50:17 -0400
IronPort-SDR: LO6x9dzm0tMWaPFB28eV+woJj4xu1CxFriVfXN8dh4j5VPBtehvjYKEyvKGmUmfiTxToYLOHYT
 Oap0aXdtA0sw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jun 2020 01:50:16 -0700
IronPort-SDR: dGufkFDBj7eGbhmH/lFjjb6HCMpHJRjgfeExsC8sFbQHgquogT37fAxakm8rTiIGs/kSETm8HK
 CyLtDEwXEXrw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,467,1583222400"; 
   d="scan'208";a="445023647"
Received: from orsmsx104.amr.corp.intel.com ([10.22.225.131])
  by orsmga005.jf.intel.com with ESMTP; 03 Jun 2020 01:50:15 -0700
Received: from orsmsx111.amr.corp.intel.com (10.22.240.12) by
 ORSMSX104.amr.corp.intel.com (10.22.225.131) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 3 Jun 2020 01:50:15 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX111.amr.corp.intel.com (10.22.240.12) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 3 Jun 2020 01:50:15 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.104)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 3 Jun 2020 01:50:09 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KUrwG5tOUVrTYAWqYCYz65yq6OhZXClLVvzOfShI366TjRvPTe5Tic4EevwN2w9Jbp48cET3jJi0ZSgwzw5VGdrzZ+dbiyXoWj7HCLOefYIS8pAXqYr+GckM34+oVc2LbS0qbjPoP8PwQli94o2LjTvMnit3vj/YAnYI7C2jHRqBOu15VMvwVg9470IE3o7MAyQItGHSs/AtVUthNOcHOYa/WLJXflVpdu64e+chbAazzdW/bINenCLzmIazrrowl6CAg6auzb23zv4MmQTGwcohahVm8RKpHMyNqLgiTetSwc1elflsiSz+0B0XBgHRuRV2yslaXGUGKWyMxVia0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SB6akxpHU1arB0kOTH6F0mL7OqzzVXwY725W2ovTX8=;
 b=KmgeniDrAKJhOT4arCySxK3oElqywPfLVCcPd9GiU49UMmuY5AtOZw75dCdROtb+0dNKnalXN2ZkkxDHONgQa4bxCJT5OfiDXDk7AyXHg5QWFSIadWxv4L237T4/uS/TKyAejGFpNF7xrEg6yrLEomr1542rwTpTbA+k0hntlBRTefw/eirZQObQ98WSCBVN7NQ6wvIdgGtNbzD1bMEovbZS5uacCk1HpM7tZzk1bZFM7E0L/eM1GUt6WHjKQF4DK3rsB9Te4hObjUePdF348xTFYsphIhacQVoN2ItoQ95oq5LPRXbL/XYyzt6bkH1NB78HcWfhjvlxezAxxxArEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1SB6akxpHU1arB0kOTH6F0mL7OqzzVXwY725W2ovTX8=;
 b=ZfbLxSzq5tAju1i/4nR+nVb4YhHIBK7ag3/Ck+t6KW4OmPG+PWrjkTbNjOm1+7x6/rsh6Uteiav/O+xjoeDtFN8MfEULpcJ/PfJ0uDRVEPci5ZDEc3TT1ZkRX7CBDIecY4i+2h+2HbPCNCX700G58Q/Xu/rsvcjXuQ1n7Y+Dwos=
Received: from CY4PR11MB1528.namprd11.prod.outlook.com (2603:10b6:910:d::12)
 by CY4PR11MB1320.namprd11.prod.outlook.com (2603:10b6:903:2b::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.22; Wed, 3 Jun
 2020 08:50:07 +0000
Received: from CY4PR11MB1528.namprd11.prod.outlook.com
 ([fe80::80a:cad3:9a37:28dd]) by CY4PR11MB1528.namprd11.prod.outlook.com
 ([fe80::80a:cad3:9a37:28dd%11]) with mapi id 15.20.3045.022; Wed, 3 Jun 2020
 08:50:07 +0000
From:   "Stankiewicz, Piotr" <piotr.stankiewicz@intel.com>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        netdev <netdev@vger.kernel.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 14/15] net: hns3: use PCI_IRQ_MSI_TYPES where appropriate
Thread-Topic: [PATCH 14/15] net: hns3: use PCI_IRQ_MSI_TYPES where appropriate
Thread-Index: AQHWOL8+QuC3lCH200WP4kDp59YhPqjFdm4AgAEfB7A=
Date:   Wed, 3 Jun 2020 08:49:53 +0000
Deferred-Delivery: Wed, 3 Jun 2020 08:49:47 +0000
Message-ID: <CY4PR11MB15287ACFF4C55F84D43433E9F9880@CY4PR11MB1528.namprd11.prod.outlook.com>
References: <20200602092118.32283-1-piotr.stankiewicz@intel.com>
 <CAHp75VfEcm-Mmo7=i40sJ0RqpOgFRpJHxQ9ePWvvqsyRp+=9GA@mail.gmail.com>
In-Reply-To: <CAHp75VfEcm-Mmo7=i40sJ0RqpOgFRpJHxQ9ePWvvqsyRp+=9GA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.2.0.6
dlp-product: dlpe-windows
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiNDU5YTJhYWEtZDdhMS00YTU3LTlmMzQtM2I1MTUxYTc1MTZjIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiTXJxUlh5U1wvUXVZVDErbTZyZmRLa2pIWWt3N2JFWDR5S0sxdW9FYnFtQlE1UEZZWEZRWU53QkFuS0hOKzFcL2ViIn0=
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.191.221.121]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 418fb09d-0006-4468-cf1e-08d8079b1de7
x-ms-traffictypediagnostic: CY4PR11MB1320:
x-microsoft-antispam-prvs: <CY4PR11MB13205171244DC6B613E5111EF9880@CY4PR11MB1320.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 04238CD941
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Jr1nnjk/CwMinT17sEg+6GvKKB5uKV006DKqMpWXA7AaXZAsM+z0UHdfCEu5hb/9kYyaOmXqLPk527uFbnZJOjkRU7pyq0WqzhtDo9KV8Uo2wInlYtscGgCW9sxpHaFnvKLc9oGf79QLH4vcKv50Y3Vzts/FUSs9aWNf4G83WCFIMhs5hjbNkWU1H5TwHUiv+sfm+5dheDYzz7DOpQOIHv/elQfU2koBKSRMNotE7V+2KKpFXg7nxpLiRUN3rpKlpKkcARz/9SsMuBxMO2qo9exPSOzlFKV15/oxoWOKsJU7SBJlW8KZfLPOb/2J4PFwcfklgVAgXET7UUUaNovGAQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR11MB1528.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(396003)(39860400002)(346002)(136003)(376002)(366004)(53546011)(55016002)(9686003)(6916009)(76116006)(66476007)(6666004)(33656002)(66556008)(71200400001)(4744005)(66446008)(64756008)(26005)(7696005)(66946007)(8676002)(8936002)(186003)(5660300002)(54906003)(83380400001)(316002)(6506007)(52536014)(86362001)(4326008)(2906002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: OiUZCPe9nVIkHYK/4sLjFl9lTvVLCBUB4bEBOHyTqyBBwGP+glFs2WuHgimJZ73/LROmGTQtKuGrYhCcfp5Rje4TfpSZskxnBaJ1PcgH2msr9uUuWqafKKwGAK8/S7RmjWdzFoNLddhmP8dbooUOD71lIEVf2b9M/qyo6FRRU8mq+ZjlxGbq4AB3i7LZphOGw35gDKRg3XWdTN5lcUoTehjB0CK/Rh6kEAhJRl7pizvulI7N9iLxb8OqlWzQ8Smo1fdPcSpFtCraKW1uJ5KEe4vg1JSYa4APJ0guDpkzDMB58KQBCz3LrjwYD7T8N54AknfpX9nDFuQNtxrrf8ZdnQ9GbUq5xphrMroG/m+DD5B/jC+uj7j45GjFIV7cJOzUFrS2SXk1R/+9+wod/Qtxv2knNTz+ETHC5iIeFqLiEe57Rp7z9h4C8Js+az372bxZ1TsOh94eiIihSuh9s8+2EjS5j3IvipqYhgNFmoXUKgGeNPZXiu7byC/Wt8aWCICo
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 418fb09d-0006-4468-cf1e-08d8079b1de7
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Jun 2020 08:50:07.3422
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7Veh7JNE+dVdkX2XPhaR6v0n3/+1TE2YIlQ/7/WhXAFXHuBeDkUMqTsDHg32A0I2qCIyu9xILNRJHe8nJNNEai/CM1LtvW/FIsPyYv7po7M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR11MB1320
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBBbmR5IFNoZXZjaGVua28gPGFu
ZHkuc2hldmNoZW5rb0BnbWFpbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEp1bmUgMiwgMjAyMCA1
OjM5IFBNDQo+IA0KPiBPbiBUdWUsIEp1biAyLCAyMDIwIGF0IDEyOjI2IFBNIFBpb3RyIFN0YW5r
aWV3aWN6DQo+IDxwaW90ci5zdGFua2lld2ljekBpbnRlbC5jb20+IHdyb3RlOg0KPiA+DQo+ID4g
U2VlaW5nIGFzIHRoZXJlIGlzIHNob3J0aGFuZCBhdmFpbGFibGUgdG8gdXNlIHdoZW4gYXNraW5n
IGZvciBhbnkgdHlwZQ0KPiA+IG9mIGludGVycnVwdCwgb3IgYW55IHR5cGUgb2YgbWVzc2FnZSBz
aWduYWxsZWQgaW50ZXJydXB0LCBsZXZlcmFnZSBpdC4NCj4gDQo+IC4uLg0KPiANCj4gPiAgICAg
ICAgIHZlY3RvcnMgPSBwY2lfYWxsb2NfaXJxX3ZlY3RvcnMocGRldiwgSE5BRTNfTUlOX1ZFQ1RP
Ul9OVU0sDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIGhkZXYt
Pm51bV9tc2ksDQo+ID4gLSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBD
SV9JUlFfTVNJIHwgUENJX0lSUV9NU0lYKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgaGRldi0+bnVtX21zaSwgUENJX0lSUV9NU0lfVFlQRVMpOw0KPiANCj4g
Li4uDQo+IA0KPiA+ICAgICAgICAgICAgICAgICB2ZWN0b3JzID0gcGNpX2FsbG9jX2lycV92ZWN0
b3JzKHBkZXYsIEhOQUUzX01JTl9WRUNUT1JfTlVNLA0KPiANCj4gPiAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICBoZGV2LT5udW1fbXNpLA0KPiA+IC0gICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFBDSV9JUlFfTVNJIHwg
UENJX0lSUV9NU0lYKTsNCj4gPiArICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBQQ0lfSVJRX01TSV9UWVBFUyk7DQo+IA0KPiBPbmUgbGluZSBhcyBhYm92ZT8N
Cj4gDQoNCkl0IHdvdWxkIHB1c2ggdGhlIGxpbmUgYWJvdmUgODAgY2hhcmFjdGVycy4gDQoNCj4g
LS0NCj4gV2l0aCBCZXN0IFJlZ2FyZHMsDQo+IEFuZHkgU2hldmNoZW5rbw0KDQpCUiwNClBpb3Ry
DQo=
