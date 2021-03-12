Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60C8A338A03
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 11:24:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233258AbhCLKYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 05:24:23 -0500
Received: from mga14.intel.com ([192.55.52.115]:27300 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233169AbhCLKYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 05:24:11 -0500
IronPort-SDR: /ln06CV3n0sH7JOdwEXudWsiBqVs3r9YW3KaMSXNS2YXIy7o8YvfdNEKfy+ImHAylUMiGRzTMB
 hPBInIVrhGJg==
X-IronPort-AV: E=McAfee;i="6000,8403,9920"; a="188178824"
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="188178824"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 02:24:10 -0800
IronPort-SDR: MWqsfcPfKnVB7ULkGJKbdRYPIlzdqgALYxnNHEoa6MiU9OdmqA3bIITr+bzTpw5Erf7Jj0F5mN
 aaQJA0JoWa0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,243,1610438400"; 
   d="scan'208";a="372636173"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by orsmga006.jf.intel.com with ESMTP; 12 Mar 2021 02:24:10 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 02:24:09 -0800
Received: from fmsmsx605.amr.corp.intel.com (10.18.126.85) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 02:24:09 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx605.amr.corp.intel.com (10.18.126.85) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 12 Mar 2021 02:24:09 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.171)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 12 Mar 2021 02:24:08 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CfU0rGGuRKXf7Oza+xLO/os5PN5r9MrmjOM9r6iaMN5T+cYSp1Wr/kfkGTWY8hUz3KtPmkmEtvwu0JimMrbc5jLMr7N51M+PHrLo9YcFOxiHwYGcao0Wtxn3n0xi1b9z/vOutGZCu5wAsIdGWzajdp2FtixZ7sj1GtTlZIMFm4EEa2shpy5hW2bLxiFlBeFWIUJ1OvPM4QxxLqnSWupsqzGoYTm1l87SGe/0NCqbD523CbVwgy8FKhiWejpYhbgo5k8dfBA2MB8IgF+AlF2WcmmhTks3TOxIfHKYbXIypudOVtSM01oLCOiiFm4dF4dQDEJK6LYj+elnRBtonXFHcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhHOm1Zy1GyFlDBdSCT8Sh/63TTRW9X/dGy38zjsRmA=;
 b=ZxnZm0YQzNAzCwHFDHX1C5nmK942W1+4ugxgqzXHll9+QrFwmiAr0BvuAeFptinLlSKQXSbdVNZEpxcepxFte5phQR4jOymVZJhjFM3ylDy6L95ckm++V/CdMAdY/R0VZAFEYXT0iojtkmshCMd0DvrGtlIz1VDGgUpXKXZhNmAIC02+EZWi9ZOtDQKZZJVh6WIxvWBAp7Lo50uwSsyo4plzD3PCzxsjW6tdc9zYT1yACCLBWTV5NdvquCa5qIm7Yg/YApiiRUfPIXUnC0TO23PMw0021M3NXXzY7uDhZI3+1LmM48ijWhEC74ydjoMt3N3uct5LKzmuBp3z6PzgDw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vhHOm1Zy1GyFlDBdSCT8Sh/63TTRW9X/dGy38zjsRmA=;
 b=p5KIRGvBjaoMWvLWXWSuYKxpkBbIhxk8gYzC9u+zJ4fb8yjooWx7e87lkFUBZ52I785JuvmSkOdwY60Ky43WXIO8hgJyZaFKLoe1Z1ZFYwjBdcjuJ8vTZWXx7OHnnPtUNN1zxHnhtc+fIMkhqyoLOtfVCkdxeRJYVDKrA8My/u8=
Received: from SA2PR11MB4940.namprd11.prod.outlook.com (2603:10b6:806:fa::13)
 by SN6PR11MB2669.namprd11.prod.outlook.com (2603:10b6:805:56::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Fri, 12 Mar
 2021 10:24:06 +0000
Received: from SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::c5d3:e5b4:55f7:e4e7]) by SA2PR11MB4940.namprd11.prod.outlook.com
 ([fe80::c5d3:e5b4:55f7:e4e7%6]) with mapi id 15.20.3912.031; Fri, 12 Mar 2021
 10:24:06 +0000
From:   "Jambekar, Vishakha" <vishakha.jambekar@intel.com>
To:     "Li,Rongqing" <lirongqing@baidu.com>,
        Alexander Duyck <alexander.duyck@gmail.com>
CC:     Netdev <netdev@vger.kernel.org>,
        "Topel, Bjorn" <bjorn.topel@intel.com>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>
Subject: RE: [PATCH] igb: avoid premature Rx buffer reuse
Thread-Topic: [PATCH] igb: avoid premature Rx buffer reuse
Thread-Index: AQHW6JB8VYvKzU/bH0mfxdsV4LH0rKqAgTbA
Date:   Fri, 12 Mar 2021 10:24:06 +0000
Message-ID: <SA2PR11MB4940B65641B2D901330B4E40FF6F9@SA2PR11MB4940.namprd11.prod.outlook.com>
References: <1609990905-29220-1-git-send-email-lirongqing@baidu.com>
 <CAKgT0Ucar6h-V2pQK6Gx4wrwFzJqySfv-MGXtW1yEc6Jq3uNSQ@mail.gmail.com>
 <65a7da2dc20c4fa5b69270f078026100@baidu.com>
In-Reply-To: <65a7da2dc20c4fa5b69270f078026100@baidu.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: baidu.com; dkim=none (message not signed)
 header.d=none;baidu.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [103.241.225.110]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 88a6d7dd-61e9-4ae0-a22d-08d8e540f74e
x-ms-traffictypediagnostic: SN6PR11MB2669:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB2669E5BA6E29177072317B1BFF6F9@SN6PR11MB2669.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: hjoiY+Nb9UpSi0LZStHO5xqDoXP9wHx87oEOmxKlN27nelpxWpP3eCWieo36SiLQJnGwgQ2Jlh2jF2WVfHBNGm8ICnCB68UHhM9AGBDoPtma0EYutY2i+iTUp9AH1Tb9O2dPeP5fGGbvDfiBVwwPfI9PMh6t2qkz454dxElGZTPOJ9R9sQ0JQZpJq/gjIJHytHXSZq4Eqfnf7wpBn1qqO9RRrnXT4ES/EG/I01UU6nc8LQZpwvOKG71I+aBCtwbFAcAhNz3l6FL5/x9HT32p4C0LeFl0j7jdbXsZA29OyWXmnX0AbppNqB6wLSOuYweFQXmxhXebNAlg3bC30SKbn1v97/iDlwP26djaBy2zLs/ovJjw//1DGYwBNIOFjX148qk5iTK8KNk47KBpjzeZJavkQSis+3147tNx6WX1crnbeerqy7WAeP/HBZZQfHh+69xr6BSsad22K0+N3BttFI6zgzfzfujmj2WVF+E3c/P/0GS/9+TEVMgILLAIusqPBHQLypMLHhkbcsKqEoL6Mrmsg1UyJnDDOa7+UtCQlnOD8wc276J7/qhEV2soeZMO
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB4940.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(136003)(39860400002)(376002)(396003)(71200400001)(86362001)(5660300002)(54906003)(52536014)(66556008)(66476007)(64756008)(66446008)(66946007)(33656002)(53546011)(2906002)(8936002)(110136005)(8676002)(6506007)(7696005)(66574015)(83380400001)(478600001)(26005)(186003)(76116006)(316002)(9686003)(4326008)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?eUsrcndJeVdReEg1M2FCUDRzVTg5YVNhemd6OWZQb1RjS214a0lzektsV1Rt?=
 =?utf-8?B?SjJJWHhucWJOMFljZklwUXM5dVdxdWNUVnh0T2dWOUVVSmt1RC9ycU9POTNa?=
 =?utf-8?B?UkFqd3F3TjN5Ym8xZDUrbjdHcnlOdU9WV0UyTlV6MmpnWTNzR1dXOWgzZW10?=
 =?utf-8?B?MU1yNEdZNEowSjRLZ3hwZFYwakZ6d1VxbkllWHJXNXJrZTFxNVdFUm11aWxu?=
 =?utf-8?B?bEFibENZK0VVaTh1NEs3V2drSEJFT3V5cnJLaVNMTHdyMnJaUGZ2NVgrOHNR?=
 =?utf-8?B?TERsTXJUdGc4UkUwUEdKdU1UdEZJdXQzZWNkT21OUFNqeXhQeEc1ZFhMaVFY?=
 =?utf-8?B?aWlPeW5TQ29BUWg4QVNoVEV1MkVnQzhCMzRwTHNuOStYcmE2a2w5ck1qaEJw?=
 =?utf-8?B?MnppNUFpcENFN0hxUUJGZjRrQ09NQXBPbi82T2E3bFk3dFV2NTIweGtYSjVT?=
 =?utf-8?B?cWt0c00yMHJ2a3d1YjEzTE42ZXRsck9oMlhDa3E1Si9ielBTVkVrOXIrSFNC?=
 =?utf-8?B?VUg1UEREWTlCd1B6STk0aXdaMFo2Q09QSkhCYllUbVJkcUJpblN1T21PRlFM?=
 =?utf-8?B?cUYzcXRHVVlEZE53SnBTVEtVaVVZQW5rVVFtV2Y0NzhVdWlISUp4cDc0R2o3?=
 =?utf-8?B?SnIybnB6Z0xIMDJxM2QrcjB5WXd5enhVaHhucTdIL3IyeGE2Z3RXTllMaXhi?=
 =?utf-8?B?VWdpaGdYaFFuYVl4MGRVM2NFSmlabmRCamphUVd2SHkyK3cvTGZ6L0ZKcGhU?=
 =?utf-8?B?S1JrQlY2bWdVanVhMWUwTGY4SXlqdFIxWVhZaCtRUHI4cXJzcndIcGNJcVBH?=
 =?utf-8?B?OFdnOCtMTTVxWG5peXZVaGV6RFRGai9RaXViR0hGeDhYTHI5aHB1b0lIZUpZ?=
 =?utf-8?B?UWNDbW4xVTRiVjliZitwNzlFTlJtRUxSQ3VNMW0xSVF6RitoQkF5T0JXc3R1?=
 =?utf-8?B?bzgrTlBDQ0l3eHBRbDNXYkl5ZlBHTGFYSEJGTEhMeTJrL2JjdE1pOFpUY1JE?=
 =?utf-8?B?VGRhbjFHcmNlTUhCaTNZZk9RZVpXN0xDQzUvMUlKOGlxTTUwcjRROHFNVzhN?=
 =?utf-8?B?Y2VsRU1pS08wVUZuRTZuelplQmJCVE81RnRNN1UzaUM2NldoakhZK08rbkNh?=
 =?utf-8?B?N25qY2Z2OW1PSCtTL3NUMTcrY3ptMEpYd0pwbFhnZTBSRmpYeE1Jb0p3bity?=
 =?utf-8?B?UUFIU1RqWHRSMDFNVXFYeXdhM2tzZ3JjMG8zalExb0xMREROOHlSY3Bvejht?=
 =?utf-8?B?TEpNKzJOTTZ6eVEyU2J6d2ZuMnJpek9EQkIvTmFTdU1wUzgwK2s3dU5pdks2?=
 =?utf-8?B?VkVURmpEM3N1bGd0OFRCNG1ibnhZUXBqTmwvQnRGSlZxeXhaQ1lYVyt2b2pS?=
 =?utf-8?B?YUZDYVN3MFA5NG82OFVuV05RWjAvdlJncFJFb0M0QXUzeUhaU2puOS92TWZN?=
 =?utf-8?B?WHZhZXNxWWNxZXVuY242UzZBbWgzdW55NC80Q1JnR3Rwa0VCRnhJclZtWmk3?=
 =?utf-8?B?bWNLVEQ4YTdGTGxOQVM5NlU2ZDlieEh4REtuZ0o2VWFqLzJNT3lnZ0owVWd0?=
 =?utf-8?B?Q1ErMXVjZUZ6bEdMNDFMOGVkZzArbUVndmhMckRpbWZWZGdVOE1TMDdOeHFK?=
 =?utf-8?B?aDJhcnFrcGEwdlJ5ZDVsR0xyTDg0WTlBVnRxN0lMd3llcFNYbk83ZmJES21l?=
 =?utf-8?B?TURTd3BBV2hWNU84ZnIzRXZzSHMxWElLTm53TVB0L3BLeVZxZHFqS0I4NXI2?=
 =?utf-8?Q?tGQ/ox2BAhEl0ukOouer7vhhP05yKhoKHUeUT+1?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB4940.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 88a6d7dd-61e9-4ae0-a22d-08d8e540f74e
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 10:24:06.1205
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: f5s1xuXTzqjhOZFpFnSS9GhYYvaNZvIbv/J/L5XWjztITz6pcI/KOEcE5+iw8YSPhbQF3Y61nYlwnhomTwbCFHuHqe34Owp7ghPUxvJnLcQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2669
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGludGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5v
cmc+IE9uIEJlaGFsZiBPZg0KPiBMaSxSb25ncWluZw0KPiBTZW50OiBUdWVzZGF5LCBKYW51YXJ5
IDEyLCAyMDIxIDg6MjQgQU0NCj4gVG86IEFsZXhhbmRlciBEdXljayA8YWxleGFuZGVyLmR1eWNr
QGdtYWlsLmNvbT4NCj4gQ2M6IE5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IFRvcGVs
LCBCam9ybiA8Ympvcm4udG9wZWxAaW50ZWwuY29tPjsNCj4gaW50ZWwtd2lyZWQtbGFuIDxpbnRl
bC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZz4NCj4gU3ViamVjdDogUmU6IFtJbnRlbC13aXJl
ZC1sYW5dIFtQQVRDSF0gaWdiOiBhdm9pZCBwcmVtYXR1cmUgUnggYnVmZmVyIHJldXNlDQo+IA0K
PiANCj4gDQo+ID4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gPiBGcm9tOiBBbGV4YW5k
ZXIgRHV5Y2sgW21haWx0bzphbGV4YW5kZXIuZHV5Y2tAZ21haWwuY29tXQ0KPiA+IFNlbnQ6IFR1
ZXNkYXksIEphbnVhcnkgMTIsIDIwMjEgNDo1NCBBTQ0KPiA+IFRvOiBMaSxSb25ncWluZyA8bGly
b25ncWluZ0BiYWlkdS5jb20+DQo+ID4gQ2M6IE5ldGRldiA8bmV0ZGV2QHZnZXIua2VybmVsLm9y
Zz47IGludGVsLXdpcmVkLWxhbg0KPiA+IDxpbnRlbC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9y
Zz47IEJqw7ZybiBUw7ZwZWwNCj4gPiA8Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiA+IFN1Ympl
Y3Q6IFJlOiBbUEFUQ0hdIGlnYjogYXZvaWQgcHJlbWF0dXJlIFJ4IGJ1ZmZlciByZXVzZQ0KPiA+
DQo+ID4gT24gV2VkLCBKYW4gNiwgMjAyMSBhdCA3OjUzIFBNIExpIFJvbmdRaW5nIDxsaXJvbmdx
aW5nQGJhaWR1LmNvbT4gd3JvdGU6DQo+ID4gPg0KPiA+ID4gVGhlIHBhZ2UgcmVjeWNsZSBjb2Rl
LCBpbmNvcnJlY3RseSwgcmVsaWVkIG9uIHRoYXQgYSBwYWdlIGZyYWdtZW50DQo+ID4gPiBjb3Vs
ZCBub3QgYmUgZnJlZWQgaW5zaWRlIHhkcF9kb19yZWRpcmVjdCgpLiBUaGlzIGFzc3VtcHRpb24g
bGVhZHMNCj4gPiA+IHRvIHRoYXQgcGFnZSBmcmFnbWVudHMgdGhhdCBhcmUgdXNlZCBieSB0aGUg
c3RhY2svWERQIHJlZGlyZWN0IGNhbg0KPiA+ID4gYmUgcmV1c2VkIGFuZCBvdmVyd3JpdHRlbi4N
Cj4gPiA+DQo+ID4gPiBUbyBhdm9pZCB0aGlzLCBzdG9yZSB0aGUgcGFnZSBjb3VudCBwcmlvciBp
bnZva2luZyB4ZHBfZG9fcmVkaXJlY3QoKS4NCj4gPiA+DQo+ID4gPiBGaXhlczogOWNiYzk0OGI1
YTIwICgiaWdiOiBhZGQgWERQIHN1cHBvcnQiKQ0KPiA+ID4gU2lnbmVkLW9mZi1ieTogTGkgUm9u
Z1FpbmcgPGxpcm9uZ3FpbmdAYmFpZHUuY29tPg0KPiA+ID4gQ2M6IEJqw7ZybiBUw7ZwZWwgPGJq
b3JuLnRvcGVsQGludGVsLmNvbT4NCj4gPg0KPiA+IEknbSBub3Qgc3VyZSB3aGF0IHlvdSBhcmUg
dGFsa2luZyBhYm91dCBoZXJlLiBXZSBhbGxvdyBmb3IgYSAwIHRvIDENCj4gPiBjb3VudCBkaWZm
ZXJlbmNlIGluIHRoZSBwYWdlY291bnQgYmlhcy4gVGhlIGlkZWEgaXMgdGhlIGRyaXZlciBzaG91
bGQNCj4gPiBiZSBob2xkaW5nIG9udG8gYXQgbGVhc3Qgb25lIHJlZmVyZW5jZSBmcm9tIHRoZSBk
cml2ZXIgYXQgYWxsIHRpbWVzLg0KPiA+IEFyZSB5b3Ugc2F5aW5nIHRoYXQgaXMgbm90IHRoZSBj
YXNlPw0KPiA+DQo+ID4gQXMgZmFyIGFzIHRoZSBjb2RlIGl0c2VsZiB3ZSBob2xkIG9udG8gdGhl
IHBhZ2UgYXMgbG9uZyBhcyBvdXINCj4gPiBkaWZmZXJlbmNlIGRvZXMgbm90IGV4Y2VlZCAxLiBT
byBzcGVjaWZpY2FsbHkgaWYgdGhlIFhEUCBjYWxsIGlzDQo+ID4gZnJlZWluZyB0aGUgcGFnZSB0
aGUgcGFnZSBpdHNlbGYgc2hvdWxkIHN0aWxsIGJlIHZhbGlkIGFzIHRoZQ0KPiA+IHJlZmVyZW5j
ZSBjb3VudCBzaG91bGRuJ3QgZHJvcCBiZWxvdyAxLCBhbmQgaW4gdGhhdCBjYXNlIHRoZSBkcml2
ZXIgc2hvdWxkIGJlDQo+IGhvbGRpbmcgdGhhdCBvbmUgcmVmZXJlbmNlIHRvIHRoZSBwYWdlLg0K
PiA+DQo+ID4gV2hlbiB3ZSBwZXJmb3JtIG91ciBjaGVjayB3ZSBhcmUgcGVyZm9ybWluZyBpdCBz
dWNoIGF0IG91dHB1dCBvZg0KPiA+IGVpdGhlciAwIGlmIHRoZSBwYWdlIGlzIGZyZWVkLCBvciAx
IGlmIHRoZSBwYWdlIGlzIG5vdCBmcmVlZCBhcmUNCj4gPiBhY2NlcHRhYmxlIGZvciB1cyB0byBh
bGxvdyByZXVzZS4gVGhlIGtleSBiaXQgaXMgaW4gaWdiX2NsZWFuX3J4X2lycQ0KPiA+IHdoZXJl
IHdlIHdpbGwgZmxpcCB0aGUgYnVmZmVyIGZvciB0aGUgSUdCX1hEUF9UWCB8IElHQl9YRFBfUkVE
SVIgY2FzZQ0KPiA+IGFuZCBqdXN0IGluY3JlbWVudCB0aGUgcGFnZWNudF9iaWFzIGluZGljYXRp
bmcgdGhhdCB0aGUgcGFnZSB3YXMgZHJvcHBlZCBpbg0KPiB0aGUgbm9uLWZsaXBwZWQgY2FzZS4N
Cj4gPg0KPiA+IEFyZSB5b3UgcGVyaGFwcyBzZWVpbmcgYSBmdW5jdGlvbiB0aGF0IGlzIHJldHVy
bmluZyBhbiBlcnJvciBhbmQgc3RpbGwNCj4gPiBjb25zdW1pbmcgdGhlIHBhZ2U/IElmIHNvIHRo
YXQgbWlnaHQgZXhwbGFpbiB3aGF0IHlvdSBhcmUgc2VlaW5nLg0KPiA+IEhvd2V2ZXIgdGhlIGJ1
ZyB3b3VsZCBiZSBpbiB0aGUgb3RoZXIgZHJpdmVyIG5vdCB0aGlzIG9uZS4gVGhlDQo+ID4geGRw
X2RvX3JlZGlyZWN0IGZ1bmN0aW9uIGlzIG5vdCBzdXBwb3NlZCB0byBmcmVlIHRoZSBwYWdlIGlm
IGl0IHJldHVybnMgYW4NCj4gZXJyb3IuDQo+ID4gSXQgaXMgc3VwcG9zZWQgdG8gbGVhdmUgdGhh
dCB1cCB0byB0aGUgZnVuY3Rpb24gdGhhdCBjYWxsZWQgeGRwX2RvX3JlZGlyZWN0Lg0KPiA+DQo+
ID4gPiAtLS0NCj4gPiA+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX21haW4u
YyB8IDIyDQo+ID4gPiArKysrKysrKysrKysrKystLS0tLS0tDQo+ID4gPiAgMSBmaWxlIGNoYW5n
ZWQsIDE1IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiBUZXN0ZWQtYnk6
IFZpc2hha2hhIEphbWJla2FyIDx2aXNoYWtoYS5qYW1iZWthckBpbnRlbC5jb20+DQo=
