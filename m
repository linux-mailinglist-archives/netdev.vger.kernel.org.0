Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25B4E460C19
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 02:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349515AbhK2BUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 20:20:00 -0500
Received: from mga03.intel.com ([134.134.136.65]:33978 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231580AbhK2BR7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 28 Nov 2021 20:17:59 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10182"; a="235809454"
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="235809454"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Nov 2021 17:14:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,272,1631602800"; 
   d="scan'208";a="511459199"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga008.jf.intel.com with ESMTP; 28 Nov 2021 17:14:42 -0800
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Sun, 28 Nov 2021 17:14:42 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Sun, 28 Nov 2021 17:14:42 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Sun, 28 Nov 2021 17:14:42 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G5EmBLslk6K12ceM8LNEcsvgZV8/rvGx6REEw2MQxYkAMre2LBoPdrwZuA8kvXTcOcN+lDmRoXSHKagvir2Sa+rAc0L6qVAJiwKCAdpdz0a0niYlEW4o1UerK6PX8wPdOmZOIrVGSgU128dwILn6wpksExVnOzqIDkNIk7bhgBHQGPbj2iLQ81mSk01UM41sYmzjU5HEF0T2hjKJAebg3Y2SJ9ErH6IBNFA2egPy7WbTk5uRNKQSKDjWcylN0Av7brgk6dvdmO26yuZObh01vEsfQ5qMkAMGAx4wVMLwSw4St3HfKWaVzdvceiiivCh/oZxSPkiYcdjLMlGe/fkkvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sgH2pIyjRJlZRVGQN5PbH5ePoFmksuZXqAbDHwY3ZsQ=;
 b=UbCSVayAQfrhWthBOvcgAj1NnJJ9olqvAE1GtalV+7WvD4NWThZxbD4szmiAJn7lnBJTY5xIYl4BFK2rAie9cSXDoXY1pjcRZjARPeXjVlik41vEYXzCAwIabX3zS0xvmUTeJ4zutk1CH+SHVCty9sXodLvz5xMd9hp15P9klvoAeC+DLwUt7/dx89TlMzjmoDr4UnN5tnarJrGO8Sfq+zs14sWBl0I1a8tJJeRvy4B4zrOhygM2nNFQYLLr8wuS1mCLa7+MkP4C4zBcaK1v9Cvnb3mKDb/ffZOxR4lUlYAiUNGwkETVdDGUrNw0KxtSFVWi9dhc5Loe+vtoU9VDyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sgH2pIyjRJlZRVGQN5PbH5ePoFmksuZXqAbDHwY3ZsQ=;
 b=pVxbSlxvVRXTDc0MX/LRL6lTwztfgTJlD4lxFdtet0bk56i0FVAhLavE+bYneRRWhY1Sh/qc7RxM1z4Us5AVH4+cjCYfncFcqvWnuECPq7AuCGVSL8NrD4i+s2D453kwuLwgAAm4AvAfPIn4QEUvzs/9O2N6VmvbrhhHM+HiIew=
Received: from DM6PR11MB2780.namprd11.prod.outlook.com (2603:10b6:5:c8::19) by
 DM6PR11MB3001.namprd11.prod.outlook.com (2603:10b6:5:6e::27) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Mon, 29 Nov 2021 01:14:41 +0000
Received: from DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::64ad:1bc9:2539:3165]) by DM6PR11MB2780.namprd11.prod.outlook.com
 ([fe80::64ad:1bc9:2539:3165%7]) with mapi id 15.20.4734.023; Mon, 29 Nov 2021
 01:14:41 +0000
From:   "Ong, Boon Leong" <boon.leong.ong@intel.com>
To:     Song Liu <song@kernel.org>
CC:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Martin KaFai Lau" <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@kernel.org>
Subject: RE: [PATCH bpf-next 4/4] samples/bpf: xdpsock: add time-out for
 cleaning Tx
Thread-Topic: [PATCH bpf-next 4/4] samples/bpf: xdpsock: add time-out for
 cleaning Tx
Thread-Index: AQHX4RSkHhP1XGzjyEK8ljdRfYznu6wW8qyAgALEwyA=
Date:   Mon, 29 Nov 2021 01:14:40 +0000
Message-ID: <DM6PR11MB2780F41AC6F97C34DBDC3268CA669@DM6PR11MB2780.namprd11.prod.outlook.com>
References: <20211124091821.3916046-1-boon.leong.ong@intel.com>
 <20211124091821.3916046-5-boon.leong.ong@intel.com>
 <CAPhsuW4AiqzH+vx3hOJb5taae0cN0NDKUUNsi5iybG+PF9xYgg@mail.gmail.com>
In-Reply-To: <CAPhsuW4AiqzH+vx3hOJb5taae0cN0NDKUUNsi5iybG+PF9xYgg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.6.200.16
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 288881aa-3b6f-47e2-d9fe-08d9b2d59ebb
x-ms-traffictypediagnostic: DM6PR11MB3001:
x-microsoft-antispam-prvs: <DM6PR11MB300160041A3E56EC62801972CA669@DM6PR11MB3001.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:499;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ohn6+4bdG23AMbhibqNtlUcsY0PsqK0Btns1u3HEPkO7nAc6Mkj88/+32W4d3gNeyooLBc+Ph21yyu0ZCU32maubldFYmO4Wum5J5/emKCM7tjjyuqi1fR1F0ah1zM2cfDaMg5d4x0BY2xgftdtWLCqDbl8a6yqRuoBjptE/N46GrPIch23SVsuhIjxqN3nSSZQ1ibpFigJdtViYdc3gRndeSU1bbtSB029yhI8VunGxJZP8JExD4PYml0hOvr+N75nTJjZvuaU/d19geOYKNdvIbwsz5e7bpQgCApwDajkUgK+Ml2pf+H8JsKHw4wi0VyUuo7JCzIHbyJoV58KONqC1UoF8PB6OrarXYkcjrMduLUEKSAyZtQ/PztrKY8JcdnMmOm46ueF+yyjBWIvKS2LgeRg5C1yZ/U7dSev3ffQLzrvHmIz4ZJwGaU1T4AwLwZ6O7DK7RfHQQb0yJoG6aM5CGRnQwPnc9UqqGffkX7eO8bfDdQYlOKbvdwn+DfMGpdO1BsnS45ufml7LvVzhW0R/SHv9JeC7eJD9tn3KJ0V15LmBnXwR/SHjaQdmfEnU1lcjNTF3HuCn2d9ufdGqesYCII+DqPXneHkIi9kdR3QwByB2Yv2rKQ+EWasyQhWgPoC8JzWnES2QWtXsk5L/TqjWSBLZPdC02MV3Wr/Og9w0N0+JGdbTBot7OgQGKS/MITTTuECtTyw76YGoN/DU+w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB2780.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(26005)(508600001)(83380400001)(6506007)(33656002)(38100700002)(316002)(38070700005)(2906002)(7696005)(8936002)(7416002)(54906003)(82960400001)(6916009)(66446008)(66946007)(66476007)(64756008)(66556008)(122000001)(55016003)(9686003)(5660300002)(8676002)(76116006)(71200400001)(52536014)(86362001)(4326008)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?cm4yWVIxNnpJb1VERTlta2FOOEtwQTY1SldOaUtrekd3cmEybWgvL2F6ajQv?=
 =?utf-8?B?WldMZndRWnNmTHArMVdtN3N2TEdJTTd4WU1KcTdqc09TZVkxU3NCRnBvbWxx?=
 =?utf-8?B?RnQ5WDAzMnlOdnpsS1JQR2FpNVhWZHlJcjNGVU5LM2Rxc3k0bHhQRURVTURN?=
 =?utf-8?B?QnhYd0k3Tk11T1VucTBYQkhaY3ZhSWFVc2NwTUgxcUZBU2gyT0JJWGNWa0Yy?=
 =?utf-8?B?RnVWcnd3RG0rUjdXMkYzY0kzaFd1NHhGdWx2R1BQNm0wVG1TRTRoMGNIK3RG?=
 =?utf-8?B?UTR2WThndVNDUC9YRW14elVueWNldjZ3TTMvRWhFbmVCRUU1OFd0Y0RkRnVr?=
 =?utf-8?B?SW4xWGpzcy9CZVFIZFJVVHJhYm4zY3QxNGh6YVcwSnpnQm92ZGpMaHFxVHpp?=
 =?utf-8?B?NjhjQ2hHakc4S2pCbnRpQzNhVlBxTXMvallnUEIyQ0Mxck04bTMxZ25sbTZN?=
 =?utf-8?B?VEc2cGd5QnorVEZVczJ3ZU1WcHVkTm1iYlNVT09lTDlhTHYvUEQwNFdrVDg4?=
 =?utf-8?B?ZEhFMFJ3UmpYZ2RiZmk5K0lNTEtIL0Z6dElLUzNjR2pwd2w5c0Mrb0loYW1T?=
 =?utf-8?B?b1I4T0ZYQnc2bENIN1ZnSUpGTkcxcXE1NTRvcjcwQVJYck5VcGp5YVR3SVJm?=
 =?utf-8?B?NDhKV0pnN1JGVmx3ay9JYncvRG1nemUyc2NUQXlyZTdNVitYckh2WDN0NWJi?=
 =?utf-8?B?M21PaDhTdzJKYjlHQjJGcE1TMGtWMlc0WEp6S2FtQk1NM0xyOGN2cFZmZHA1?=
 =?utf-8?B?SGgvTjNXU0tDZm5pNVpYOVRteFRNQm5jRmZ0M1R3aklIOFpLV3dBYnlsSS9Q?=
 =?utf-8?B?T3Yxcy9QTHhrK1k0elFxWlZERFoyVHRRTWI3RmhUdzRtMUpOakZCVURiV2lI?=
 =?utf-8?B?WFB0UU12YXFxdm9jWStWclFrRm5sMy96VG0xSUZ6UjBLQ1Q4ako0YytrdFBG?=
 =?utf-8?B?U0o4eUJ1Mlp0MmpubGlwWnFjTWhrbjdwYlBSTEkrNkJJNnRwZ0pDM1NZU1BT?=
 =?utf-8?B?c0JKdHBZaEZnUGZVQmdKdXZQWlVFc3Y5YWxkT3Avdk5PdmxJL3B4UGJnNEEr?=
 =?utf-8?B?aEZ4clJMcFNkUUh2U0xjcTJIZWUyR0lvczdIdjAvNnZhbE1wRmwvUGt2NnhI?=
 =?utf-8?B?WXNXeEVDVUE1UUJDREh5eFZUSG9vQ01RSkpEbnZRdXhtOUZXSk16ZnZ0TE82?=
 =?utf-8?B?RDdoTkVxN3hXciszYUpTWXBROWV5SkhCZjZRTnIrVzRkUzRJRjg3bFVCVEor?=
 =?utf-8?B?T3pmVDVxQUtPdmxmcWN5NFJ5RTYzdEV5Wmd2dkZhVmkvbzVneS95aURZZTZ6?=
 =?utf-8?B?aXFxcEpyb0crUDM0UGp1dFN6cWFXY0oxd0lLcGVNTTBxa3FISlEzYVNUNlk4?=
 =?utf-8?B?ZXVkcDEzSWhwZlJpMzJTZ2JEOWRoTzdYK0JFTkVXazN0MmtQWStwanRsNUtJ?=
 =?utf-8?B?cW1URzJnYjJsUHFiZWRXYU5FclAzV051MXYzdFNiWHBEZTZsZmhWRkNiZGxa?=
 =?utf-8?B?WmNIYndweC9IS0d6ZjY5TExGcWtONXlxRElGVk1LYkkyRWFVSS9QR2Jsbk1H?=
 =?utf-8?B?c1BRUUFiTldxYy9jN0FOdTQ2TUJOblFkUHNLQ0phZlBOQjBCdGp6NDZxVHZw?=
 =?utf-8?B?UGlYb3JuYldPeHk4V2xlMjJuUFZKZmxlR0E0TllWekZLT1RHVUwyRGNkQVRK?=
 =?utf-8?B?a1JuT0QzbFI2YUY2M2h3TVhlcHM5NEh5T2dzcTRUa2Q1QzNYY2NEcysyd3Vk?=
 =?utf-8?B?YmRJbXJFUjQySXIyR1EvT1NjVWxOM0c3aHlBcnJmQkJCNzFlWkYvWmllRXFT?=
 =?utf-8?B?U3gvakl1SDRZOUdOcTRQWUVPT2lyenNLYzJ2NTRpTk9FalNRck5FaTIrUldE?=
 =?utf-8?B?TmlZUEdBelJ5SStGYmNsUUQ4WlhDdGNqQzlTeE9ZT25zZWw4cFo4ai9BM3p2?=
 =?utf-8?B?MW9PbHhXbW5hNWYraXI2bmlJK0Z3TDdZZXh3T2E1NWUzRGFRdzBZRFgvWmht?=
 =?utf-8?B?WmdZdkFZNWl1NTBPL3FINXN1MllLamxsRTFJV1dIYzNia0Evc0lrZkN6amh0?=
 =?utf-8?B?QTBOWFE3V0h0MVBIaWN4WlYvaHo0aE05N3k1M2M0WWdrdTlLZHdTWGJ3eHY2?=
 =?utf-8?B?Nm9FeDZNeExRS2YzYzdmVzYwRGRVNkp5Vm5kY2hIMW4rK2NnWjRkczFkblZ4?=
 =?utf-8?B?TFEyQ3FOeUVhSHVTL2NmamFuVkllZDJEenZDWmIrYmZjOElMUlJmcXFNMCtC?=
 =?utf-8?B?K0dvTENsV0hXRFhETnlwbCtjUzJBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB2780.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 288881aa-3b6f-47e2-d9fe-08d9b2d59ebb
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Nov 2021 01:14:40.8936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lvIsBqTbyyez0tC64RHyzTGxv5VSD+u34VBqGFf5YAmlfpvPMQmOC2T9AkUpPn+EK7TNk0MCZ2cFin5dr2Y7FvoUc4kKIHR/zV10sVfNQLk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3001
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pk9uIFdlZCwgTm92IDI0LCAyMDIxIGF0IDE6MjIgQU0gT25nIEJvb24gTGVvbmcNCj48Ym9vbi5s
ZW9uZy5vbmdAaW50ZWwuY29tPiB3cm90ZToNCj4+DQo+PiBXaGVuIHVzZXIgc2V0cyB0eC1wa3Qt
Y291bnQgYW5kIGluIGNhc2Ugd2hlcmUgdGhlcmUgYXJlIGludmFsaWQgVHggZnJhbWUsDQo+PiB0
aGUgY29tcGxldGVfdHhfb25seV9hbGwoKSBwcm9jZXNzIHBvbGxzIGluZGVmaW5pdGVseS4gU28s
IHRoaXMgcGF0Y2gNCj4+IGFkZHMgYSB0aW1lLW91dCBtZWNoYW5pc20gaW50byB0aGUgcHJvY2Vz
cyBzbyB0aGF0IHRoZSBhcHBsaWNhdGlvbg0KPj4gY2FuIHRlcm1pbmF0ZSBhdXRvbWF0aWNhbGx5
IGFmdGVyIGl0IHJldHJpZXMgMypwb2xsaW5nIGludGVydmFsIGR1cmF0aW9uLg0KPj4NCj4+ICBz
b2NrMEBlbnAwczI5ZjE6MiB0eG9ubHkgeGRwLWRydg0KPj4gICAgICAgICAgICAgICAgICAgIHBw
cyAgICAgICAgICAgIHBrdHMgICAgICAgICAgIDEuMDANCj4+IHJ4ICAgICAgICAgICAgICAgICAw
ICAgICAgICAgICAgICAwDQo+PiB0eCAgICAgICAgICAgICAgICAgMTM2MzgzICAgICAgICAgMTAw
MDAwMA0KPj4gcnggZHJvcHBlZCAgICAgICAgIDAgICAgICAgICAgICAgIDANCj4+IHJ4IGludmFs
aWQgICAgICAgICAwICAgICAgICAgICAgICAwDQo+PiB0eCBpbnZhbGlkICAgICAgICAgMzUgICAg
ICAgICAgICAgMjQ1DQo+PiByeCBxdWV1ZSBmdWxsICAgICAgMCAgICAgICAgICAgICAgMA0KPj4g
ZmlsbCByaW5nIGVtcHR5ICAgIDAgICAgICAgICAgICAgIDENCj4+IHR4IHJpbmcgZW1wdHkgICAg
ICA5NTcgICAgICAgICAgICA3MDExDQo+Pg0KPj4gIHNvY2swQGVucDBzMjlmMToyIHR4b25seSB4
ZHAtZHJ2DQo+PiAgICAgICAgICAgICAgICAgICAgcHBzICAgICAgICAgICAgcGt0cyAgICAgICAg
ICAgMS4wMA0KPj4gcnggICAgICAgICAgICAgICAgIDAgICAgICAgICAgICAgIDANCj4+IHR4ICAg
ICAgICAgICAgICAgICAwICAgICAgICAgICAgICAxMDAwMDAwDQo+PiByeCBkcm9wcGVkICAgICAg
ICAgMCAgICAgICAgICAgICAgMA0KPj4gcnggaW52YWxpZCAgICAgICAgIDAgICAgICAgICAgICAg
IDANCj4+IHR4IGludmFsaWQgICAgICAgICAwICAgICAgICAgICAgICAyNDUNCj4+IHJ4IHF1ZXVl
IGZ1bGwgICAgICAwICAgICAgICAgICAgICAwDQo+PiBmaWxsIHJpbmcgZW1wdHkgICAgMCAgICAg
ICAgICAgICAgMQ0KPj4gdHggcmluZyBlbXB0eSAgICAgIDEgICAgICAgICAgICAgIDcwMTINCj4+
DQo+PiAgc29jazBAZW5wMHMyOWYxOjIgdHhvbmx5IHhkcC1kcnYNCj4+ICAgICAgICAgICAgICAg
ICAgICBwcHMgICAgICAgICAgICBwa3RzICAgICAgICAgICAxLjAwDQo+PiByeCAgICAgICAgICAg
ICAgICAgMCAgICAgICAgICAgICAgMA0KPj4gdHggICAgICAgICAgICAgICAgIDAgICAgICAgICAg
ICAgIDEwMDAwMDANCj4+IHJ4IGRyb3BwZWQgICAgICAgICAwICAgICAgICAgICAgICAwDQo+PiBy
eCBpbnZhbGlkICAgICAgICAgMCAgICAgICAgICAgICAgMA0KPj4gdHggaW52YWxpZCAgICAgICAg
IDAgICAgICAgICAgICAgIDI0NQ0KPj4gcnggcXVldWUgZnVsbCAgICAgIDAgICAgICAgICAgICAg
IDANCj4+IGZpbGwgcmluZyBlbXB0eSAgICAwICAgICAgICAgICAgICAxDQo+PiB0eCByaW5nIGVt
cHR5ICAgICAgMSAgICAgICAgICAgICAgNzAxMw0KPj4NCj4+ICBzb2NrMEBlbnAwczI5ZjE6MiB0
eG9ubHkgeGRwLWRydg0KPj4gICAgICAgICAgICAgICAgICAgIHBwcyAgICAgICAgICAgIHBrdHMg
ICAgICAgICAgIDEuMDANCj4+IHJ4ICAgICAgICAgICAgICAgICAwICAgICAgICAgICAgICAwDQo+
PiB0eCAgICAgICAgICAgICAgICAgMCAgICAgICAgICAgICAgMTAwMDAwMA0KPj4gcnggZHJvcHBl
ZCAgICAgICAgIDAgICAgICAgICAgICAgIDANCj4+IHJ4IGludmFsaWQgICAgICAgICAwICAgICAg
ICAgICAgICAwDQo+PiB0eCBpbnZhbGlkICAgICAgICAgMCAgICAgICAgICAgICAgMjQ1DQo+PiBy
eCBxdWV1ZSBmdWxsICAgICAgMCAgICAgICAgICAgICAgMA0KPj4gZmlsbCByaW5nIGVtcHR5ICAg
IDAgICAgICAgICAgICAgIDENCj4+IHR4IHJpbmcgZW1wdHkgICAgICAxICAgICAgICAgICAgICA3
MDE0DQo+Pg0KPj4gIHNvY2swQGVucDBzMjlmMToyIHR4b25seSB4ZHAtZHJ2DQo+PiAgICAgICAg
ICAgICAgICAgICAgcHBzICAgICAgICAgICAgcGt0cyAgICAgICAgICAgMS4wMA0KPj4gcnggICAg
ICAgICAgICAgICAgIDAgICAgICAgICAgICAgIDANCj4+IHR4ICAgICAgICAgICAgICAgICAwICAg
ICAgICAgICAgICAxMDAwMDAwDQo+PiByeCBkcm9wcGVkICAgICAgICAgMCAgICAgICAgICAgICAg
MA0KPj4gcnggaW52YWxpZCAgICAgICAgIDAgICAgICAgICAgICAgIDANCj4+IHR4IGludmFsaWQg
ICAgICAgICAwICAgICAgICAgICAgICAyNDUNCj4+IHJ4IHF1ZXVlIGZ1bGwgICAgICAwICAgICAg
ICAgICAgICAwDQo+PiBmaWxsIHJpbmcgZW1wdHkgICAgMCAgICAgICAgICAgICAgMQ0KPj4gdHgg
cmluZyBlbXB0eSAgICAgIDAgICAgICAgICAgICAgIDcwMTQNCj4+DQo+PiAgc29jazBAZW5wMHMy
OWYxOjIgdHhvbmx5IHhkcC1kcnYNCj4+ICAgICAgICAgICAgICAgICAgICBwcHMgICAgICAgICAg
ICBwa3RzICAgICAgICAgICAwLjAwDQo+PiByeCAgICAgICAgICAgICAgICAgMCAgICAgICAgICAg
ICAgMA0KPj4gdHggICAgICAgICAgICAgICAgIDAgICAgICAgICAgICAgIDEwMDAwMDANCj4+IHJ4
IGRyb3BwZWQgICAgICAgICAwICAgICAgICAgICAgICAwDQo+PiByeCBpbnZhbGlkICAgICAgICAg
MCAgICAgICAgICAgICAgMA0KPj4gdHggaW52YWxpZCAgICAgICAgIDAgICAgICAgICAgICAgIDI0
NQ0KPj4gcnggcXVldWUgZnVsbCAgICAgIDAgICAgICAgICAgICAgIDANCj4+IGZpbGwgcmluZyBl
bXB0eSAgICAwICAgICAgICAgICAgICAxDQo+PiB0eCByaW5nIGVtcHR5ICAgICAgMCAgICAgICAg
ICAgICAgNzAxNA0KPg0KPkkgYW0gbm90IGZvbGxvd2luZyB3aHkgd2UgbmVlZCBleGFtcGxlcyBh
Ym92ZSBpbiB0aGUgY29tbWl0IGxvZy4NCg0KSSBwYXN0ZWQgdGhlIGxvZyB0byBkZW1vbnN0cmF0
ZSB0aGUgYmVoYXZpb3Igb2YgdGhlIHRpbWUtb3V0LCB0aGF0IGlzDQphbGlnbmVkIHdpdGggdGhl
IHN0YXRzIHBvbGxlci4gV2lsbCByZW1vdmUgaW4gbmV4dCByZXYuDQoNCj4NCj4+DQo+PiBTaWdu
ZWQtb2ZmLWJ5OiBPbmcgQm9vbiBMZW9uZyA8Ym9vbi5sZW9uZy5vbmdAaW50ZWwuY29tPg0KPj4g
LS0tDQo+PiAgc2FtcGxlcy9icGYveGRwc29ja191c2VyLmMgfCA0ICsrKy0NCj4+ICAxIGZpbGUg
Y2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+Pg0KPj4gZGlmZiAtLWdp
dCBhL3NhbXBsZXMvYnBmL3hkcHNvY2tfdXNlci5jIGIvc2FtcGxlcy9icGYveGRwc29ja191c2Vy
LmMNCj4+IGluZGV4IDYxZDQwNjNmMTFhLi45YzMzMTEzMjllYyAxMDA2NDQNCj4+IC0tLSBhL3Nh
bXBsZXMvYnBmL3hkcHNvY2tfdXNlci5jDQo+PiArKysgYi9zYW1wbGVzL2JwZi94ZHBzb2NrX3Vz
ZXIuYw0KPj4gQEAgLTE0MTAsNiArMTQxMCw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGdldF9iYXRj
aF9zaXplKGludCBwa3RfY250KQ0KPj4NCj4+ICBzdGF0aWMgdm9pZCBjb21wbGV0ZV90eF9vbmx5
X2FsbCh2b2lkKQ0KPj4gIHsNCj4+ICsgICAgICAgdTMyIHJldHJpZXMgPSAzOw0KPg0KPlNoYWxs
IHdlIG1ha2UgdGhlIHJldHJ5IHZhbHVlIGNvbmZpZ3VyYWJsZT8gQW5kIG1heWJlIG1ha2UgaXQg
YSB0aW1lb3V0DQo+dmFsdWUgaW4gc2Vjb25kcz8NCg0KT0ssIG5leHQgcmV2IHdpbGwgaGF2ZSBz
ZWNvbmRzIGdyYW51bGFyaXR5LiBPaywgSSBjYW4gbWFrZSBpdCBjb25maWd1cmFibGUuIA0KDQo=
