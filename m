Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F396AAD8D
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 23:03:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388531AbfIEVDU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Sep 2019 17:03:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:25735 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbfIEVDU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Sep 2019 17:03:20 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 14:03:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,471,1559545200"; 
   d="scan'208";a="188101331"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga006.jf.intel.com with ESMTP; 05 Sep 2019 14:03:19 -0700
Received: from FMSMSX110.amr.corp.intel.com (10.18.116.10) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Sep 2019 14:03:18 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx110.amr.corp.intel.com (10.18.116.10) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 5 Sep 2019 14:03:18 -0700
Received: from NAM04-SN1-obe.outbound.protection.outlook.com (104.47.44.56) by
 edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 5 Sep 2019 14:03:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcBFHzGam8sasDttsBRJr7vWo4JeZCX9QDZDRE7bREEztf+wXoqOaoCnU8mMRFRboMfuVuXR50IlKLJUtGe6BSPDhpJycOhBGwW+X/C+KDbEdCymRquiTBmClHIsLOPo9A+CQqALsVrb/BTN3MrRWDwzLH7B+yY+1TSmHZHxSlMSb471QwRvQFvEipM3H8ojzGpX1v4XkmeWWqfrTZVtsf8pQ/bfkI4y4pAeZzeiaaXCn6HMFsWOkAk7dKd0CU1uCggcoLK25mtLlbm1WyJpPNJ+25oF2BKYvNVd0cQY7JjApgfnx6fejEGDkxArpOqkMBwygA5qGs5XPH849bIghA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ri2S5A5vwbwl0Zr+D8WJBBgURXPJnPb3dax2h0srVNE=;
 b=lp237XA9OmffdF4mfjLF6of5JXURDHlI2CdNcktWSIw7MXmtY2pxMumg9jg3iNi7s1ukKQKBoCY+BkFGIRe3J+jHk346g5tGUufbcYYHbkC6V0P090BvIF+1wMOOCm04SZkvWBOS5Osor/zklFmekfZDkyAeA67yk2O5XjP5V/aMefwd4/9RkhDZgKv01eAlCAbAXKoM6Npzhr9Sdw/Iv02e/hpDsGUCymSvLFagx0GxfPT4GD/EiDlZHpKvpnD08KoCu2TY2QHWY66nDs1Yz/S0GRdxWViNLj6xAdNV6TyxnqaOo6R0wzDnebh3Dfy6LUO6QHsMHKSuvqtDOoUzqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ri2S5A5vwbwl0Zr+D8WJBBgURXPJnPb3dax2h0srVNE=;
 b=cbTjgF1EqJugF02oHXSLUH6xjZVizXTJTHWSSBs16CREq5E0wgnYVj1TyqD90RzYqdZwTQQw37CvVVmvWkAsN6CvWT8DHn0cO6j1amkoXxHxJR2SqtC0dxoeawBW8NIExzYmMQ5l8yiJlSyXRs3ZQU/YJx0GrAldPat9euQX8qQ=
Received: from BN6PR11MB0050.namprd11.prod.outlook.com (10.161.155.32) by
 BN6PR11MB1713.namprd11.prod.outlook.com (10.173.26.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.21; Thu, 5 Sep 2019 21:03:03 +0000
Received: from BN6PR11MB0050.namprd11.prod.outlook.com
 ([fe80::a4e9:cc41:8ded:4c03]) by BN6PR11MB0050.namprd11.prod.outlook.com
 ([fe80::a4e9:cc41:8ded:4c03%3]) with mapi id 15.20.2241.014; Thu, 5 Sep 2019
 21:03:03 +0000
From:   "Gomes, Vinicius" <vinicius.gomes@intel.com>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     Eric Dumazet <eric.dumazet@gmail.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] net: sched: taprio: Fix potential integer overflow in
 taprio_set_picos_per_byte
Thread-Topic: [PATCH] net: sched: taprio: Fix potential integer overflow in
 taprio_set_picos_per_byte
Thread-Index: AQHVYfQR/bBKdBXupkm2zvl2OxkQsqcZ8H0AgAAwbYCAALxVgIACtQmAgAADWrA=
Date:   Thu, 5 Sep 2019 21:03:03 +0000
Message-ID: <BN6PR11MB0050674280A0EEB96C488D7286BB0@BN6PR11MB0050.namprd11.prod.outlook.com>
References: <20190903010817.GA13595@embeddedor>
 <cb7d53cd-3f1e-146b-c1ab-f11a584a7224@gmail.com>
 <CA+h21hpCAJhE8xhsgDQ55_MUUiesV=uVY4tD=TzaCE6wynUPoQ@mail.gmail.com>
 <8736hd9ilm.fsf@intel.com>
 <CA+h21hqtuGuJm0rMx_SZAy_HCjSVD_UK1j8wa7fv+p_zUGNV7A@mail.gmail.com>
In-Reply-To: <CA+h21hqtuGuJm0rMx_SZAy_HCjSVD_UK1j8wa7fv+p_zUGNV7A@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiOTA4YWZjNjMtZTg1MS00ODk3LWEwOTgtNDIyYWRhNTBjN2VmIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiOWxhUW5kbDlIYXBnK1wvaEYySGlydEE0RlBJTkxnczI1SHhEWXR0VzFVWXNJajNKM09od3JwM081dFVNU2k0b2YifQ==
x-ctpclassification: CTP_NT
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vinicius.gomes@intel.com; 
x-originating-ip: [134.134.136.207]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 775923b1-eaf6-4b2e-6198-08d732447150
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:BN6PR11MB1713;
x-ms-traffictypediagnostic: BN6PR11MB1713:
x-microsoft-antispam-prvs: <BN6PR11MB1713ABF2D657591C3BE110A686BB0@BN6PR11MB1713.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 015114592F
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(136003)(396003)(366004)(39850400004)(376002)(346002)(189003)(199004)(4744005)(256004)(305945005)(74316002)(11346002)(71200400001)(66446008)(64756008)(66556008)(66476007)(4326008)(99286004)(71190400001)(446003)(25786009)(33656002)(7736002)(486006)(76116006)(8676002)(476003)(14454004)(86362001)(5660300002)(6436002)(54906003)(2906002)(478600001)(6116002)(316002)(9686003)(1411001)(76176011)(53936002)(102836004)(8936002)(52536014)(186003)(55016002)(26005)(6916009)(81166006)(81156014)(229853002)(7696005)(66066001)(3846002)(6506007)(66946007)(6246003);DIR:OUT;SFP:1102;SCL:1;SRVR:BN6PR11MB1713;H:BN6PR11MB0050.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: qDwY89MY6Gw0H0SnmpvuDvjsG6ttvhAHMC2sw6xdR5upDmMHfEoffm+VpkPWwKQQ30qsOY1GPfnSsZ0aJcHcIWWwa3KuYyykmo4+UiLUrBbpKtCV39rvEJp6i79IlAIGUFfRgXVrXlE3H9vqHMMCtIyk191BYDgZvilsuWRSKP+8xqNbP7kKlwk77IIbfvcXDewdY1wwCjtbv+qoShqefF6oHPQkCNWKQcTdvDpwmciEId0pDk7VkDmZ0GA/lIYzdRZsFszjg06HcBKLxtT3WSi9F+lN4QZNSbLHwKcIfUauIdVfQDTw15PPGFtl+Wn7wULHzPJutrxbHCdvjZIdOYCtBCudkt70VMI85eCVvhjWx+CdGLQjEEDiMQLX7zGQKWubEyJt/LCx3SqFr6e5VniC+WmNKKKdQwXGfDxoqeI=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 775923b1-eaf6-4b2e-6198-08d732447150
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Sep 2019 21:03:03.5983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9G/cXtQMVW0OkgHNitCmWtD1nUbKfHqWMJUGlQQ6QDa6pOAYG9l7COGb2WEolPn8evYz5XAxiFk41//lVSfOIN2DCzw4wL7Ke+qD1E5GmWY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB1713
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgVmxhZGltaXIsDQoNCj4gTG9va3Mgb2sgdG8gbWUsIGJ1dCBJIGhhdmUgbm8gc2F5aW5nIG92
ZXIgZXRodG9vbCBBUEkuIEFjdHVhbGx5IEkgZG9uJ3QgZXZlbg0KPiBrbm93IHdob20gdG8gYXNr
IC0gdGhlIG91dHB1dCBvZiAuL3NjcmlwdHMvZ2V0X21haW50YWluZXIucGwNCj4gbmV0L2NvcmUv
ZXRodG9vbC5jIGlzIGEgYml0IG92ZXJ3aGVsbWluZy4NCj4gVG8gYXZvaWQgY29uZmxpY3RzLCB0
aGVyZSBuZWVkcyB0byBiZSBzb21lYm9keSBvdXQgb2YgdXMgd2hvIHRha2VzIEVyaWMncw0KPiBz
aW1wbGlmaWNhdGlvbiwgd2l0aCBHdXN0YXZvJ3MgUmVwb3J0ZWQtYnkgdGFnLCBhbmQgdGhlIDIg
ZXRodG9vbCAmIHRhcHJpbw0KPiBwYXRjaGVzIHRvIGF2b2lkIGRpdmlzaW9uIGJ5IHplcm8sIGFu
ZCB0aGUgcHJpbnRpbmcgZml4LCBhbmQgbWF5YmUgZG8gdGhlIHNhbWUgaW4NCj4gY2JzLiBXaWxs
IHlvdSBiZSB0aGUgb25lPyBTaG91bGQgST8NCg0KSWYgeW91IGhhdmUgdGhlIGN5Y2xlcyB0byBk
byBpdCwgZ28gZm9yIGl0LiBJIHdvdWxkIG9ubHkgYmUgYWJsZSB0byB3b3JrIG9uIHRoaXMgbmV4
dCB3ZWVrLg0KDQo+IA0KPiBUaGFua3MsDQo+IC1WbGFkaW1pcg0KDQpUaGFua3MgYSBsb3QsDQot
LQ0KVmluaWNpdXMNCg==
