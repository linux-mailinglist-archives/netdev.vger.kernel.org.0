Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E1825A610
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 09:07:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgIBHHR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 03:07:17 -0400
Received: from mga17.intel.com ([192.55.52.151]:15239 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgIBHHO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Sep 2020 03:07:14 -0400
IronPort-SDR: E2u/AOO46Idv2T15qutuqDvPmGs5caMuPoJnhpq5lDD5wvGXMA1Ot5ur55G/ZOaqb/oDGpCam0
 w2lItzggwt/w==
X-IronPort-AV: E=McAfee;i="6000,8403,9731"; a="137382895"
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="137382895"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2020 00:07:08 -0700
IronPort-SDR: x5jZQwmLxxQ1NLl3NB3MCCHzXcSLTnThjxDwmtieX2wmkhipnlSUJRF1gxcDmq0A9AVAOyw7M0
 1zLnxt80Hx0A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,381,1592895600"; 
   d="scan'208";a="325667286"
Received: from orsmsx604.amr.corp.intel.com ([10.22.229.17])
  by fmsmga004.fm.intel.com with ESMTP; 02 Sep 2020 00:07:08 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 2 Sep 2020 00:07:07 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Wed, 2 Sep 2020 00:07:07 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.1713.5; Wed, 2 Sep 2020 00:07:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OL5N3NSaKDb+D4jYOvbQyuxvSKRPEQ873vg9I1FfwwBQcqRh4yOfSlzHjspCA346wSr+To3FJ6E2UnOTrNeZfBmCgPhN+xwIbOajOYzgxitqGJvJ8SSukMI80d7MyZwHFNrjeZU5p+ChkLeIxbzEVxgZwRY8LlwzIF+tGGnz+2yvYG8nBGdTKhq51j8339DKRv9hNcuuAELjMqS3M0wAvdoSzvEhmK6LNIPDgZvuxT59uExEo2kXgalvV0EC6hJssuZTmiQiy2gkhs+6pIZgkxwgjonvaGzRUHCJfmuCkn92KKsnlYRQQlOnWN4PJ/A4QaG1QoZuVl+kJLUOQQjCgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bndsQpynpmMgWqABA+4167mg4jee8RpdGbZCjVM2Z3g=;
 b=TnHAK83hiyRfK/UKUC/UqGSwEsfpMAkNgUk8TmJhyhwk0DQajxn8V2qJXp7uzF/4O2NfWgpGxXfeuzDrsCa0evcPHlzbsc6QkPg9rdD9tpjp5aoGDN2i92wvWHqjgQsAwkn177hHIPc0sdGdW8OmC134p+GAuA2v71gjtrfiIp78hbaW7/QfGyDCgMGtP6EF8vVK6qd1qVHBIz0qjLWW1Da8ZvG8QMXaQ7W8sUALtCF5H0rgHfon6ujmMao33xKzCaYSAUxWPdrTojJDS4drhsET4DERmImo3uVyhBw7utuVMoZB89g+1eGNPs/qRjulmhsjo0ufd0hk4qoEGSnpdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bndsQpynpmMgWqABA+4167mg4jee8RpdGbZCjVM2Z3g=;
 b=i+bHsvvuSzZsXibFBMY/bd90KBY0hgxJWaF6N53xTx2xa1H70rot05NZfkxmTsGTOGlzz/80cYlhNlGLIL442f9TieI1m5VVu9TFh7VVJMKCDTy+1nS4oQTUTivUIUyRqwUhA0o7Q+K0IDy00YmIvny3d/u/p599jD93uwm+t7M=
Received: from MW3PR11MB4602.namprd11.prod.outlook.com (2603:10b6:303:52::19)
 by MWHPR1101MB2110.namprd11.prod.outlook.com (2603:10b6:301:4f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.24; Wed, 2 Sep
 2020 07:06:54 +0000
Received: from MW3PR11MB4602.namprd11.prod.outlook.com
 ([fe80::9c4d:550:8fd5:2fa9]) by MW3PR11MB4602.namprd11.prod.outlook.com
 ([fe80::9c4d:550:8fd5:2fa9%4]) with mapi id 15.20.3348.015; Wed, 2 Sep 2020
 07:06:54 +0000
From:   "Karlsson, Magnus" <magnus.karlsson@intel.com>
To:     Daniel Borkmann <daniel@iogearbox.net>,
        syzbot <syzbot+5334f62e4d22804e646a@syzkaller.appspotmail.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "andriin@fb.com" <andriin@fb.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "kafai@fb.com" <kafai@fb.com>,
        "kpsingh@chromium.org" <kpsingh@chromium.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "paulmck@kernel.org" <paulmck@kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "yhs@fb.com" <yhs@fb.com>
Subject: RE: KASAN: use-after-free Write in xp_put_pool
Thread-Topic: KASAN: use-after-free Write in xp_put_pool
Thread-Index: AQHWgPZ9cEnXaKRSA0aAKGXifyfMzKlU7PuAgAAARwA=
Date:   Wed, 2 Sep 2020 07:06:54 +0000
Message-ID: <MW3PR11MB460262C77514D97C91319AEAF72F0@MW3PR11MB4602.namprd11.prod.outlook.com>
References: <000000000000bcdbb005ae4f25ce@google.com>
 <7795503d-e112-cc26-81d8-c7a9692675b0@iogearbox.net>
In-Reply-To: <7795503d-e112-cc26-81d8-c7a9692675b0@iogearbox.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZGMzY2U2NGItZWZkNC00MWQxLTg0N2EtMmRkZGFiMGM2NGE0IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiRExqb0hSNmZUejRWTzA0VVZnWXk4WTZCY3E4YlAxZG1CbWNnT2tGT1ZiRWRCbG8xc2w0WFNLaG5RQUU0bWZaYyJ9
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
x-ctpclassification: CTP_NT
authentication-results: iogearbox.net; dkim=none (message not signed)
 header.d=none;iogearbox.net; dmarc=none action=none header.from=intel.com;
x-originating-ip: [78.70.96.136]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5186c6fe-98e8-436a-7fcb-08d84f0ec627
x-ms-traffictypediagnostic: MWHPR1101MB2110:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR1101MB2110161F9546739B4874C052F72F0@MWHPR1101MB2110.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aMN10WiYgR4FI3PBkNaFOrPdDry2TG8E9QFVkzqbtGG61bd2Ip8AdJtfDXr5NL6g24LDdX+VkUpA+CJD/GOA/8Hk0sEYzyy5TI0alPkyn8odRL8lkI5UA+sO7qniU0OUtCxeoB+Me7JRgB1ZPTDJjauGx22bG5wcsxj4YgkJwoMKoOLNm2wa/65tsWpdUNsEG9Oyonw1LJfpvPC0PPGB0G25qgZwfTTGl5/f/vFrddyPeftFIgjSCSiLD/0FbwOZfD3V/hrbzqVVD1a50mCjgow5pAm7Qv8kckA/9xHtNuyJ9/oclACa4n/PxBqTeX+BVAryUjJVKGIUwEzL+fqUu+SDKW5yLnEmAIfU+3fyS5EtjdJX3z8E24RPjRGjg5Nh0Jm0N9SIQXymJNjlOEQD5DLSmM5/WNTKFemgds2PTIe3HndivIY1Kmd7RD8MpMmepYUAM+DIZY4y4XVokb5EVcrh3kVZMw5AfmZzELq+9kc=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4602.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(376002)(39860400002)(366004)(396003)(346002)(76116006)(478600001)(8676002)(55016002)(26005)(8936002)(52536014)(53546011)(966005)(86362001)(6506007)(9686003)(33656002)(7416002)(110136005)(7696005)(64756008)(66946007)(66446008)(66556008)(5660300002)(83380400001)(2906002)(83080400001)(66476007)(186003)(71200400001)(316002)(99710200001)(921003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: SGqZkyKpi74d7jyCeQuAWuQnZsNzZGG4Cm3I7Hz3+yd0RoNwOon/YTOCQWcFc1P58I9aYWKwJ4MVtCvnKRyWUCNjpRaIAEYDAlk//oZa0TpSn4k8uSf8x01t3Sz0EMEBvIbWKvwCl6IARIRLERX46AvJRQaJ05MZBDefzNzbeg8sOwlKGTGha515qu63bf9hPVQ7YPpSsQlNW0BahW15yVc+WtTH0WjP1E2No+E+omeLWWlk1t29E1ZgQoUu05Ddt+Qze19raHvktijv8PWcGEXjhZVjNwjs6hMlx2Qwih2K5s+wkoxm5Lw4lfO+LvsncuR9f+HfyxbhBCRe655DRXy/L6tQJdiinNn27BdJG5U0wIpFDrnhl4IQYS2SRKf8gIlCo3PJBjgfCQAVylwh30crvpRHrKpEZonyPn4zoursUkQdd5qrm1hLB5kloC3k6NwirfPLQTf0YlswsLW+bvYNfUn51HEb8iq40VqFC0lp5udT2+7+/qv2882qUQGd8oUiNluiucBVXw0/NkTjP3kQQJVYXphyrMJ16S81lT29rrNUBmnM3Q0JESpj4PfE5s7rUXaHAD4vBxVcjhJquLWWts9syBXvY1qcXqQ5FZUG8O9QempL7C3Xbte9Mg1siJa2A51ZnMqON58lbyJJoQ==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4602.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5186c6fe-98e8-436a-7fcb-08d84f0ec627
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2020 07:06:54.4742
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 3S4v7BuceTJXuXG3kH8SSCFyBhJnOl//hp1jeHNt7NmJ9mhRonaJMTr8IvpRfO2YsvuDFoUiQdUezxg1WLQsCZy2oXtmVkIVxk2xa/jpUYU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR1101MB2110
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuaWVsIEJvcmttYW5u
IDxkYW5pZWxAaW9nZWFyYm94Lm5ldD4NCj4gU2VudDogV2VkbmVzZGF5LCBTZXB0ZW1iZXIgMiwg
MjAyMCA5OjA2IEFNDQo+IFRvOiBzeXpib3QgPHN5emJvdCs1MzM0ZjYyZTRkMjI4MDRlNjQ2YUBz
eXprYWxsZXIuYXBwc3BvdG1haWwuY29tPjsNCj4gYWtwbUBsaW51eC1mb3VuZGF0aW9uLm9yZzsg
YW5kcmlpbkBmYi5jb207IGFzdEBrZXJuZWwub3JnOyBUb3BlbCwgQmpvcm4NCj4gPGJqb3JuLnRv
cGVsQGludGVsLmNvbT47IGJwZkB2Z2VyLmtlcm5lbC5vcmc7IGRhdmVtQGRhdmVtbG9mdC5uZXQ7
DQo+IGhhd2tAa2VybmVsLm9yZzsgam9obi5mYXN0YWJlbmRAZ21haWwuY29tOyBqb25hdGhhbi5s
ZW1vbkBnbWFpbC5jb207DQo+IGthZmFpQGZiLmNvbTsga3BzaW5naEBjaHJvbWl1bS5vcmc7IGt1
YmFAa2VybmVsLm9yZzsgbGludXgtDQo+IGtlcm5lbEB2Z2VyLmtlcm5lbC5vcmc7IEthcmxzc29u
LCBNYWdudXMgPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+Ow0KPiBtaW5nb0BrZXJuZWwub3Jn
OyBuZXRkZXZAdmdlci5rZXJuZWwub3JnOyBwYXVsbWNrQGtlcm5lbC5vcmc7DQo+IHBldGVyekBp
bmZyYWRlYWQub3JnOyBzb25nbGl1YnJhdmluZ0BmYi5jb207IHN5emthbGxlci0NCj4gYnVnc0Bn
b29nbGVncm91cHMuY29tOyB0Z2x4QGxpbnV0cm9uaXguZGU7IHloc0BmYi5jb20NCj4gU3ViamVj
dDogUmU6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBXcml0ZSBpbiB4cF9wdXRfcG9vbA0KPiANCj4g
T24gOS8yLzIwIDg6NTcgQU0sIHN5emJvdCB3cm90ZToNCj4gPiBIZWxsbywNCj4gPg0KPiA+IHN5
emJvdCBmb3VuZCB0aGUgZm9sbG93aW5nIGlzc3VlIG9uOg0KPiANCj4gTWFnbnVzL0Jqb3JuLCBw
dGFsLCB0aGFua3MhDQoNCk9uIGl0IGFzIHdlIHNwZWFrLg0KDQo+ID4gSEVBRCBjb21taXQ6ICAg
IGRjMWE5YmYyIG9jdGVvbnR4Mi1wZjogQWRkIFVEUCBzZWdtZW50YXRpb24gb2ZmbG9hZA0KPiBz
dXBwb3J0DQo+ID4gZ2l0IHRyZWU6ICAgICAgIG5ldC1uZXh0DQo+ID4gY29uc29sZSBvdXRwdXQ6
DQo+ID4gaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20veC9sb2cudHh0P3g9MTZmZjY3ZGU5
MDAwMDANCj4gPiBrZXJuZWwgY29uZmlnOg0KPiA+IGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3Qu
Y29tL3gvLmNvbmZpZz94PWI2ODU2ZDE2Zjc4ZDhmYTkNCj4gPiBkYXNoYm9hcmQgbGluazoNCj4g
aHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20vYnVnP2V4dGlkPTUzMzRmNjJlNGQyMjgwNGU2
NDZhDQo+ID4gY29tcGlsZXI6ICAgICAgIGdjYyAoR0NDKSAxMC4xLjAtc3l6IDIwMjAwNTA3DQo+
ID4gc3l6IHJlcHJvOiAgICAgIGh0dHBzOi8vc3l6a2FsbGVyLmFwcHNwb3QuY29tL3gvcmVwcm8u
c3l6P3g9MTJlOWYyNzk5MDAwMDANCj4gPiBDIHJlcHJvZHVjZXI6DQo+IGh0dHBzOi8vc3l6a2Fs
bGVyLmFwcHNwb3QuY29tL3gvcmVwcm8uYz94PTEyNWYzZTFlOTAwMDAwDQo+ID4NCj4gPiBUaGUg
aXNzdWUgd2FzIGJpc2VjdGVkIHRvOg0KPiA+DQo+ID4gY29tbWl0IGExMTMyNDMwYzJjNTVhZjYy
ZDEzZTlmY2E3NTJkNDZmMTRkNTQ4YjMNCj4gPiBBdXRob3I6IE1hZ251cyBLYXJsc3NvbiA8bWFn
bnVzLmthcmxzc29uQGludGVsLmNvbT4NCj4gPiBEYXRlOiAgIEZyaSBBdWcgMjggMDg6MjY6MjYg
MjAyMCArMDAwMA0KPiA+DQo+ID4gICAgICB4c2s6IEFkZCBzaGFyZWQgdW1lbSBzdXBwb3J0IGJl
dHdlZW4gZGV2aWNlcw0KPiA+DQo+ID4gYmlzZWN0aW9uIGxvZzoNCj4gaHR0cHM6Ly9zeXprYWxs
ZXIuYXBwc3BvdC5jb20veC9iaXNlY3QudHh0P3g9MTBhMzczZGU5MDAwMDANCj4gPiBmaW5hbCBv
b3BzOg0KPiBodHRwczovL3N5emthbGxlci5hcHBzcG90LmNvbS94L3JlcG9ydC50eHQ/eD0xMmEz
NzNkZTkwMDAwMA0KPiA+IGNvbnNvbGUgb3V0cHV0Og0KPiA+IGh0dHBzOi8vc3l6a2FsbGVyLmFw
cHNwb3QuY29tL3gvbG9nLnR4dD94PTE0YTM3M2RlOTAwMDAwDQo+ID4NCj4gPiBJTVBPUlRBTlQ6
IGlmIHlvdSBmaXggdGhlIGlzc3VlLCBwbGVhc2UgYWRkIHRoZSBmb2xsb3dpbmcgdGFnIHRvIHRo
ZQ0KPiBjb21taXQ6DQo+ID4gUmVwb3J0ZWQtYnk6IHN5emJvdCs1MzM0ZjYyZTRkMjI4MDRlNjQ2
YUBzeXprYWxsZXIuYXBwc3BvdG1haWwuY29tDQo+ID4gRml4ZXM6IGExMTMyNDMwYzJjNSAoInhz
azogQWRkIHNoYXJlZCB1bWVtIHN1cHBvcnQgYmV0d2VlbiBkZXZpY2VzIikNCj4gPg0KPiA+DQo+
ID09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT0NCj4gPT09PT09PT0NCj4gPiBCVUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbiBpbnN0cnVt
ZW50X2F0b21pY193cml0ZQ0KPiA+IGluY2x1ZGUvbGludXgvaW5zdHJ1bWVudGVkLmg6NzEgW2lu
bGluZV0NCj4gPiBCVUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbiBhdG9taWNfZmV0Y2hfc3Vi
X3JlbGVhc2UNCj4gPiBpbmNsdWRlL2FzbS1nZW5lcmljL2F0b21pYy1pbnN0cnVtZW50ZWQuaDoy
MjAgW2lubGluZV0NCj4gPiBCVUc6IEtBU0FOOiB1c2UtYWZ0ZXItZnJlZSBpbiByZWZjb3VudF9z
dWJfYW5kX3Rlc3QNCj4gPiBpbmNsdWRlL2xpbnV4L3JlZmNvdW50Lmg6MjY2IFtpbmxpbmVdDQo+
ID4gQlVHOiBLQVNBTjogdXNlLWFmdGVyLWZyZWUgaW4gcmVmY291bnRfZGVjX2FuZF90ZXN0DQo+
ID4gaW5jbHVkZS9saW51eC9yZWZjb3VudC5oOjI5NCBbaW5saW5lXQ0KPiA+IEJVRzogS0FTQU46
IHVzZS1hZnRlci1mcmVlIGluIHhwX3B1dF9wb29sKzB4MmMvMHgxZTANCj4gPiBuZXQveGRwL3hz
a19idWZmX3Bvb2wuYzoyNjIgV3JpdGUgb2Ygc2l6ZSA0IGF0IGFkZHIgZmZmZjg4ODBhNmE0ZDg2
MA0KPiA+IGJ5IHRhc2sga3NvZnRpcnFkLzAvOQ0KPiA+DQo+ID4gQ1BVOiAwIFBJRDogOSBDb21t
OiBrc29mdGlycWQvMCBOb3QgdGFpbnRlZCA1LjkuMC1yYzEtc3l6a2FsbGVyICMwDQo+ID4gSGFy
ZHdhcmUgbmFtZTogR29vZ2xlIEdvb2dsZSBDb21wdXRlIEVuZ2luZS9Hb29nbGUgQ29tcHV0ZSBF
bmdpbmUsDQo+ID4gQklPUyBHb29nbGUgMDEvMDEvMjAxMSBDYWxsIFRyYWNlOg0KPiA+ICAgX19k
dW1wX3N0YWNrIGxpYi9kdW1wX3N0YWNrLmM6NzcgW2lubGluZV0NCj4gPiAgIGR1bXBfc3RhY2sr
MHgxOGYvMHgyMGQgbGliL2R1bXBfc3RhY2suYzoxMTgNCj4gPiAgIHByaW50X2FkZHJlc3NfZGVz
Y3JpcHRpb24uY29uc3Rwcm9wLjAuY29sZCsweGFlLzB4NDk3DQo+IG1tL2thc2FuL3JlcG9ydC5j
OjM4Mw0KPiA+ICAgX19rYXNhbl9yZXBvcnQgbW0va2FzYW4vcmVwb3J0LmM6NTEzIFtpbmxpbmVd
DQo+ID4gICBrYXNhbl9yZXBvcnQuY29sZCsweDFmLzB4MzcgbW0va2FzYW4vcmVwb3J0LmM6NTMw
DQo+ID4gICBjaGVja19tZW1vcnlfcmVnaW9uX2lubGluZSBtbS9rYXNhbi9nZW5lcmljLmM6MTg2
IFtpbmxpbmVdDQo+ID4gICBjaGVja19tZW1vcnlfcmVnaW9uKzB4MTNkLzB4MTgwIG1tL2thc2Fu
L2dlbmVyaWMuYzoxOTINCj4gPiAgIGluc3RydW1lbnRfYXRvbWljX3dyaXRlIGluY2x1ZGUvbGlu
dXgvaW5zdHJ1bWVudGVkLmg6NzEgW2lubGluZV0NCj4gPiAgIGF0b21pY19mZXRjaF9zdWJfcmVs
ZWFzZSBpbmNsdWRlL2FzbS1nZW5lcmljL2F0b21pYy0NCj4gaW5zdHJ1bWVudGVkLmg6MjIwIFtp
bmxpbmVdDQo+ID4gICByZWZjb3VudF9zdWJfYW5kX3Rlc3QgaW5jbHVkZS9saW51eC9yZWZjb3Vu
dC5oOjI2NiBbaW5saW5lXQ0KPiA+ICAgcmVmY291bnRfZGVjX2FuZF90ZXN0IGluY2x1ZGUvbGlu
dXgvcmVmY291bnQuaDoyOTQgW2lubGluZV0NCj4gPiAgIHhwX3B1dF9wb29sKzB4MmMvMHgxZTAg
bmV0L3hkcC94c2tfYnVmZl9wb29sLmM6MjYyDQo+ID4gICB4c2tfZGVzdHJ1Y3QrMHg3ZC8weGEw
IG5ldC94ZHAveHNrLmM6MTEzOA0KPiA+ICAgX19za19kZXN0cnVjdCsweDRiLzB4ODYwIG5ldC9j
b3JlL3NvY2suYzoxNzY0DQo+ID4gICByY3VfZG9fYmF0Y2gga2VybmVsL3JjdS90cmVlLmM6MjQy
OCBbaW5saW5lXQ0KPiA+ICAgcmN1X2NvcmUrMHg1YzcvMHgxMTkwIGtlcm5lbC9yY3UvdHJlZS5j
OjI2NTYNCj4gPiAgIF9fZG9fc29mdGlycSsweDJkZS8weGEyNCBrZXJuZWwvc29mdGlycS5jOjI5
OA0KPiA+ICAgcnVuX2tzb2Z0aXJxZCBrZXJuZWwvc29mdGlycS5jOjY1MiBbaW5saW5lXQ0KPiA+
ICAgcnVuX2tzb2Z0aXJxZCsweDg5LzB4MTAwIGtlcm5lbC9zb2Z0aXJxLmM6NjQ0DQo+ID4gICBz
bXBib290X3RocmVhZF9mbisweDY1NS8weDllMCBrZXJuZWwvc21wYm9vdC5jOjE2NQ0KPiA+ICAg
a3RocmVhZCsweDNiNS8weDRhMCBrZXJuZWwva3RocmVhZC5jOjI5Mg0KPiA+ICAgcmV0X2Zyb21f
Zm9yaysweDFmLzB4MzAgYXJjaC94ODYvZW50cnkvZW50cnlfNjQuUzoyOTQNCj4gPg0KPiA+IEFs
bG9jYXRlZCBieSB0YXNrIDY4NTQ6DQo+ID4gICBrYXNhbl9zYXZlX3N0YWNrKzB4MWIvMHg0MCBt
bS9rYXNhbi9jb21tb24uYzo0OA0KPiA+ICAga2FzYW5fc2V0X3RyYWNrIG1tL2thc2FuL2NvbW1v
bi5jOjU2IFtpbmxpbmVdDQo+ID4gICBfX2thc2FuX2ttYWxsb2MuY29uc3Rwcm9wLjArMHhiZi8w
eGQwIG1tL2thc2FuL2NvbW1vbi5jOjQ2MQ0KPiA+ICAga21hbGxvY19ub2RlIGluY2x1ZGUvbGlu
dXgvc2xhYi5oOjU3NyBbaW5saW5lXQ0KPiA+ICAga3ZtYWxsb2Nfbm9kZSsweDYxLzB4ZjAgbW0v
dXRpbC5jOjU3NA0KPiA+ICAga3ZtYWxsb2MgaW5jbHVkZS9saW51eC9tbS5oOjc1MCBbaW5saW5l
XQ0KPiA+ICAga3Z6YWxsb2MgaW5jbHVkZS9saW51eC9tbS5oOjc1OCBbaW5saW5lXQ0KPiA+ICAg
eHBfY3JlYXRlX2FuZF9hc3NpZ25fdW1lbSsweDU4LzB4OGQwIG5ldC94ZHAveHNrX2J1ZmZfcG9v
bC5jOjU0DQo+ID4gICB4c2tfYmluZCsweDlhMC8weGVkMCBuZXQveGRwL3hzay5jOjcwOQ0KPiA+
ICAgX19zeXNfYmluZCsweDFlOS8weDI1MCBuZXQvc29ja2V0LmM6MTY1Ng0KPiA+ICAgX19kb19z
eXNfYmluZCBuZXQvc29ja2V0LmM6MTY2NyBbaW5saW5lXQ0KPiA+ICAgX19zZV9zeXNfYmluZCBu
ZXQvc29ja2V0LmM6MTY2NSBbaW5saW5lXQ0KPiA+ICAgX194NjRfc3lzX2JpbmQrMHg2Zi8weGIw
IG5ldC9zb2NrZXQuYzoxNjY1DQo+ID4gICBkb19zeXNjYWxsXzY0KzB4MmQvMHg3MCBhcmNoL3g4
Ni9lbnRyeS9jb21tb24uYzo0Ng0KPiA+ICAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1l
KzB4NDQvMHhhOQ0KPiA+DQo+ID4gRnJlZWQgYnkgdGFzayA2ODU0Og0KPiA+ICAga2FzYW5fc2F2
ZV9zdGFjaysweDFiLzB4NDAgbW0va2FzYW4vY29tbW9uLmM6NDgNCj4gPiAgIGthc2FuX3NldF90
cmFjaysweDFjLzB4MzAgbW0va2FzYW4vY29tbW9uLmM6NTYNCj4gPiAgIGthc2FuX3NldF9mcmVl
X2luZm8rMHgxYi8weDMwIG1tL2thc2FuL2dlbmVyaWMuYzozNTUNCj4gPiAgIF9fa2FzYW5fc2xh
Yl9mcmVlKzB4ZDgvMHgxMjAgbW0va2FzYW4vY29tbW9uLmM6NDIyDQo+ID4gICBfX2NhY2hlX2Zy
ZWUgbW0vc2xhYi5jOjM0MTggW2lubGluZV0NCj4gPiAgIGtmcmVlKzB4MTAzLzB4MmMwIG1tL3Ns
YWIuYzozNzU2DQo+ID4gICBrdmZyZWUrMHg0Mi8weDUwIG1tL3V0aWwuYzo2MDMNCj4gPiAgIHhw
X2Rlc3Ryb3kgbmV0L3hkcC94c2tfYnVmZl9wb29sLmM6NDQgW2lubGluZV0NCj4gPiAgIHhwX2Rl
c3Ryb3krMHg0NS8weDYwIG5ldC94ZHAveHNrX2J1ZmZfcG9vbC5jOjM4DQo+ID4gICB4c2tfYmlu
ZCsweGJkZC8weGVkMCBuZXQveGRwL3hzay5jOjcxOQ0KPiA+ICAgX19zeXNfYmluZCsweDFlOS8w
eDI1MCBuZXQvc29ja2V0LmM6MTY1Ng0KPiA+ICAgX19kb19zeXNfYmluZCBuZXQvc29ja2V0LmM6
MTY2NyBbaW5saW5lXQ0KPiA+ICAgX19zZV9zeXNfYmluZCBuZXQvc29ja2V0LmM6MTY2NSBbaW5s
aW5lXQ0KPiA+ICAgX194NjRfc3lzX2JpbmQrMHg2Zi8weGIwIG5ldC9zb2NrZXQuYzoxNjY1DQo+
ID4gICBkb19zeXNjYWxsXzY0KzB4MmQvMHg3MCBhcmNoL3g4Ni9lbnRyeS9jb21tb24uYzo0Ng0K
PiA+ICAgZW50cnlfU1lTQ0FMTF82NF9hZnRlcl9od2ZyYW1lKzB4NDQvMHhhOQ0KPiA+DQo+ID4g
VGhlIGJ1Z2d5IGFkZHJlc3MgYmVsb25ncyB0byB0aGUgb2JqZWN0IGF0IGZmZmY4ODgwYTZhNGQ4
MDANCj4gPiAgIHdoaWNoIGJlbG9uZ3MgdG8gdGhlIGNhY2hlIGttYWxsb2MtMWsgb2Ygc2l6ZSAx
MDI0IFRoZSBidWdneSBhZGRyZXNzDQo+ID4gaXMgbG9jYXRlZCA5NiBieXRlcyBpbnNpZGUgb2YN
Cj4gPiAgIDEwMjQtYnl0ZSByZWdpb24gW2ZmZmY4ODgwYTZhNGQ4MDAsIGZmZmY4ODgwYTZhNGRj
MDApIFRoZSBidWdneQ0KPiA+IGFkZHJlc3MgYmVsb25ncyB0byB0aGUgcGFnZToNCj4gPiBwYWdl
OjAwMDAwMDAwZGQ1ZmMxOGYgcmVmY291bnQ6MSBtYXBjb3VudDowIG1hcHBpbmc6MDAwMDAwMDAw
MDAwMDAwMA0KPiA+IGluZGV4OjB4MCBwZm46MHhhNmE0ZA0KPiA+IGZsYWdzOiAweGZmZmUwMDAw
MDAwMjAwKHNsYWIpDQo+ID4gcmF3OiAwMGZmZmUwMDAwMDAwMjAwIGZmZmZlYTAwMDI5Y2NlNDgg
ZmZmZmVhMDAwMjVmMjE0OA0KPiA+IGZmZmY4ODgwYWEwNDA3MDANCj4gPiByYXc6IDAwMDAwMDAw
MDAwMDAwMDAgZmZmZjg4ODBhNmE0ZDAwMCAwMDAwMDAwMTAwMDAwMDAyDQo+ID4gMDAwMDAwMDAw
MDAwMDAwMCBwYWdlIGR1bXBlZCBiZWNhdXNlOiBrYXNhbjogYmFkIGFjY2VzcyBkZXRlY3RlZA0K
PiA+DQo+ID4gTWVtb3J5IHN0YXRlIGFyb3VuZCB0aGUgYnVnZ3kgYWRkcmVzczoNCj4gPiAgIGZm
ZmY4ODgwYTZhNGQ3MDA6IGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZjIGZj
IGZjIGZjDQo+ID4gICBmZmZmODg4MGE2YTRkNzgwOiBmYyBmYyBmYyBmYyBmYyBmYyBmYyBmYyBm
YyBmYyBmYyBmYyBmYyBmYyBmYyBmYw0KPiA+PiBmZmZmODg4MGE2YTRkODAwOiBmYSBmYiBmYiBm
YiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYiBmYg0KPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgXg0KPiA+ICAgZmZmZjg4
ODBhNmE0ZDg4MDogZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIgZmIg
ZmINCj4gPiAgIGZmZmY4ODgwYTZhNGQ5MDA6IGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZiIGZi
IGZiIGZiIGZiIGZiIGZiIGZiDQo+ID4NCj4gPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT09PT09PQ0KPiA9PT09PT09PQ0KPiA+DQo+ID4NCj4gPiAt
LS0NCj4gPiBUaGlzIHJlcG9ydCBpcyBnZW5lcmF0ZWQgYnkgYSBib3QuIEl0IG1heSBjb250YWlu
IGVycm9ycy4NCj4gPiBTZWUgaHR0cHM6Ly9nb28uZ2wvdHBzbUVKIGZvciBtb3JlIGluZm9ybWF0
aW9uIGFib3V0IHN5emJvdC4NCj4gPiBzeXpib3QgZW5naW5lZXJzIGNhbiBiZSByZWFjaGVkIGF0
IHN5emthbGxlckBnb29nbGVncm91cHMuY29tLg0KPiA+DQo+ID4gc3l6Ym90IHdpbGwga2VlcCB0
cmFjayBvZiB0aGlzIGlzc3VlLiBTZWU6DQo+ID4gaHR0cHM6Ly9nb28uZ2wvdHBzbUVKI3N0YXR1
cyBmb3IgaG93IHRvIGNvbW11bmljYXRlIHdpdGggc3l6Ym90Lg0KPiA+IEZvciBpbmZvcm1hdGlv
biBhYm91dCBiaXNlY3Rpb24gcHJvY2VzcyBzZWU6DQo+ID4gaHR0cHM6Ly9nb28uZ2wvdHBzbUVK
I2Jpc2VjdGlvbiBzeXpib3QgY2FuIHRlc3QgcGF0Y2hlcyBmb3IgdGhpcyBpc3N1ZSwgZm9yDQo+
IGRldGFpbHMgc2VlOg0KPiA+IGh0dHBzOi8vZ29vLmdsL3Rwc21FSiN0ZXN0aW5nLXBhdGNoZXMN
Cj4gPg0KDQo=
