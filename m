Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962BF1FFBF6
	for <lists+netdev@lfdr.de>; Thu, 18 Jun 2020 21:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728514AbgFRTqQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 15:46:16 -0400
Received: from mga04.intel.com ([192.55.52.120]:47764 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727978AbgFRTqO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 15:46:14 -0400
IronPort-SDR: 47iwE7tXy5RYfn3sQPqgGVmhVsluarH990bB8eOxjSEf0WEa5XT83vk9QHBYdbbh2kniK2Upac
 t6nxekOBtmcQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9656"; a="140230017"
X-IronPort-AV: E=Sophos;i="5.75,252,1589266800"; 
   d="scan'208";a="140230017"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Jun 2020 12:46:12 -0700
IronPort-SDR: Mo4UdZovO5rJjZ/7dXa935BgbUvDKjzjyDo2urnw5H1yR9zgUTa/ZIddV/e2Fb4lFU2+xKEGlv
 mmhNS0EqdIJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,252,1589266800"; 
   d="scan'208";a="383623013"
Received: from fmsmsx106.amr.corp.intel.com ([10.18.124.204])
  by fmsmga001.fm.intel.com with ESMTP; 18 Jun 2020 12:46:12 -0700
Received: from fmsmsx101.amr.corp.intel.com (10.18.124.199) by
 FMSMSX106.amr.corp.intel.com (10.18.124.204) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 12:46:11 -0700
Received: from FMSEDG002.ED.cps.intel.com (10.1.192.134) by
 fmsmsx101.amr.corp.intel.com (10.18.124.199) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 18 Jun 2020 12:46:11 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.177)
 by edgegateway.intel.com (192.55.55.69) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Thu, 18 Jun 2020 12:46:11 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X8+EBwsQLcbPyXUu6LHO0/Kwu2PDfHNJEgrXNtmY6HJiYMCK/f8g1IaXAniwA7btXOU2XF0pxg71j8H7JTWFl1KibGZneD8RTiW7okHMZSqBt4P7nojJlhr7gUWxRausD2AU+T5HCOyd5HAYEj5NRW/RwrN9aJsWGatlwrFxNQxuZALC6boZTb/1aWasLFnzdwMCHYy9/IlP1rCW704K0kGV9mqof0FQZRdAaa9950ifWw2C4gVgmXO5J0Z2bJ7ERaDN4n243xsS6G6pPH6H5kRbFrHkenEeZMHi4vJF/mBeiAyR6Qbl/AZdJRuFny1uG1ThryCNMAogNLctbzxkMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25pK3uf3c7e5KiD0dLlJjlHi/zKPev+ClCIgXIkbopk=;
 b=Gj1nrPKlhMfj+1WqI+B+xdvGM0t3l5iNmAav01qTj5vdPNhYvAqPSKeq5+BvXLvfcHNRN959WEzjbKsHfnn3i39mub94w6DeXFXYhAJcVR3D/RGe3i8BufzltJAZq70I4GXZFLwpacnSh97KMaWSWdvqktsEVxMLagtmA0MOx+79TTGqPanX7nMZ4qCp7L1u+psHPXozoKnXcwnTXvQan2jzb6q331pdy+HJC4sLdFJs8yfZ1OXkUAfOVpcj1z41r7dDJZA/zRGwg0BjNOkvYnP7cVk+fW7XU7VXgoyKOi9umcKOio3rSOGQaUjQok70QPh1GJ+sFYdcsOpjx6tIfA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=25pK3uf3c7e5KiD0dLlJjlHi/zKPev+ClCIgXIkbopk=;
 b=I1OCDOBxpQSWuD4jTPWgnTLlVOZwj2wVUIsG1CW7k3wj1iDUVecWq9+RCz/vPhNNCwvpr4zxPDjUA7xkpJPaolwitRIP1f55Xxj4QRl3v4zDuiV42j8ETlwKKMYXwz8KuF/ozlrX54g0kNLcRRHYWfacfXNbVYEB4kTytxdSyuA=
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 (2603:10b6:405:51::10) by BN7PR11MB2563.namprd11.prod.outlook.com
 (2603:10b6:406:b0::33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3109.22; Thu, 18 Jun
 2020 19:46:10 +0000
Received: from BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362]) by BN6PR1101MB2145.namprd11.prod.outlook.com
 ([fe80::c908:e244:e85:3362%9]) with mapi id 15.20.3109.021; Thu, 18 Jun 2020
 19:46:09 +0000
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
To:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net] i40e: fix crash when Rx descriptor
 count is changed
Thread-Topic: [Intel-wired-lan] [PATCH net] i40e: fix crash when Rx descriptor
 count is changed
Thread-Index: AQHWQK9XAgivUUSSI0CW3i0lwPBrwaje0KtA
Date:   Thu, 18 Jun 2020 19:46:09 +0000
Message-ID: <BN6PR1101MB2145F6C2A5F5B5458B41845A8C9B0@BN6PR1101MB2145.namprd11.prod.outlook.com>
References: <20200612114731.144630-1-bjorn.topel@gmail.com>
In-Reply-To: <20200612114731.144630-1-bjorn.topel@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: lists.osuosl.org; dkim=none (message not signed)
 header.d=none;lists.osuosl.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.196]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cf1c457a-a55a-4f93-bb8e-08d813c03fe6
x-ms-traffictypediagnostic: BN7PR11MB2563:
x-microsoft-antispam-prvs: <BN7PR11MB256392B87B97ACB9EEF38B898C9B0@BN7PR11MB2563.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2043;
x-forefront-prvs: 0438F90F17
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HkOseYOOU20eAm+7tmkaHufXlpPHqZijIi3ZvWw/zzq6GhybYMbUeOThekun6kDuGGPPBWgfFMUNCnjC3QMUz8xCxEaU3hypJbNuGP/8uE1/2cUt9PwBCErzYf+o1HHSs+9lsBuR/bw7NBgKJFf0gtSoGExYMCDlcrLun9QzWLVArow/Tl9KDPLDSrWBEBTTH4HnlykaF0bNE7Uetf4WmaNngsg7NAluGBAFQrza5zHC6RergzxIdljarufKXRAt/AagLApD3L6WR/LbQKIu6rmpUQnXs7LZR0v2C/QqER2PgjFfPvjitvirPIJZxSuPCwCEQyZoWwvri6kdlsuCrQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR1101MB2145.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(136003)(376002)(396003)(346002)(39860400002)(71200400001)(5660300002)(54906003)(316002)(83380400001)(4326008)(9686003)(55016002)(8676002)(8936002)(478600001)(2906002)(66946007)(186003)(66476007)(66556008)(6916009)(86362001)(26005)(53546011)(6506007)(7696005)(76116006)(64756008)(66446008)(33656002)(52536014);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: AsAlBKZsmxvy4H2Dpmc/NPhN+ISCeUsqbJe20JgOXCuL4N/gcQ5P2mnUYXeSH9+AYj0uclgBKfb0hy6BKN2ka4CyueCLuDLacHcvEiHPGTlK7BHu+oPnpTxYokuyw7XQ3nUkZDF7Ki/Km/Lpg+sk3mx1WzHwplfCbcXoAO7n6H657a/epTGCQCxpSlV3sDl3JqAVceJEtLFWKDZg5tLxHu4k2u74FmQwSGrW30ChHs5G4HNTZfKF4ucVzLhHRHG8wUY0E7KgDHHFg8pM12inn+lBiyk1qOCDNO/j/WZD/7kUjNi8J1XPC9pNyMvdERxDbPJ2HSDb4Rrr+5PWwmIrqdLhZEmp25ujTikuraYMjseibfpYgObdLTfAg8UwFCBCb9w9aGq+r4MQoDY2Mrt+2VmyJM+X0jK3KbBynx1L2/h0r/qVF5N07qC24o3VTsSGm7A4MdNhS3Z58HueFg1FIP15dRgHUpla7Q785gC+5iyWcsVPvZ1i+PDV4pN5clNT
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: cf1c457a-a55a-4f93-bb8e-08d813c03fe6
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Jun 2020 19:46:09.8620
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wH0BRInWuO+9YljCgCcJW6iT/JHfUQguSnz97gcS6BNDU7k6np3H8vf/q5bbBIzsYRj+UpgOQEaEq72l+DTYX8fK9wBlJzHuBMvLYACFl6E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2563
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJbnRlbC13aXJlZC1sYW4gPGlu
dGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5vcmc+IE9uIEJlaGFsZiBPZg0KPiBCasO2cm4g
VMO2cGVsDQo+IFNlbnQ6IEZyaWRheSwgSnVuZSAxMiwgMjAyMCA0OjQ4IEFNDQo+IFRvOiBpbnRl
bC13aXJlZC1sYW5AbGlzdHMub3N1b3NsLm9yZw0KPiBDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9y
ZzsgYnBmQHZnZXIua2VybmVsLm9yZzsgVG9wZWwsIEJqb3JuDQo+IDxiam9ybi50b3BlbEBpbnRl
bC5jb20+OyBLYXJsc3NvbiwgTWFnbnVzIDxtYWdudXMua2FybHNzb25AaW50ZWwuY29tPg0KPiBT
dWJqZWN0OiBbSW50ZWwtd2lyZWQtbGFuXSBbUEFUQ0ggbmV0XSBpNDBlOiBmaXggY3Jhc2ggd2hl
biBSeCBkZXNjcmlwdG9yDQo+IGNvdW50IGlzIGNoYW5nZWQNCj4gDQo+IEZyb206IEJqw7ZybiBU
w7ZwZWwgPGJqb3JuLnRvcGVsQGludGVsLmNvbT4NCj4gDQo+IFdoZW4gdGhlIEFGX1hEUCBidWZm
ZXIgYWxsb2NhdG9yIHdhcyBpbnRyb2R1Y2VkLCB0aGUgUnggU1cgcmluZyAicnhfYmkiDQo+IGFs
bG9jYXRpb24gd2FzIG1vdmVkIGZyb20gaTQwZV9zZXR1cF9yeF9kZXNjcmlwdG9ycygpIGZ1bmN0
aW9uLCBhbmQgd2FzDQo+IGluc3RlYWQgZG9uZSBpbiB0aGUgaTQwZV9jb25maWd1cmVfcnhfcmlu
ZygpIGZ1bmN0aW9uLg0KPiANCj4gVGhpcyBicm9rZSB0aGUgZXRodG9vbCBzZXRfcmluZ3BhcmFt
KCkgaG9vayBmb3IgY2hhbmdpbmcgdGhlIFJ4IGRlc2NyaXB0b3INCj4gY291bnQsIHdoaWNoIHdh
cyByZWx5aW5nIG9uIGk0MGVfc2V0dXBfcnhfZGVzY3JpcHRvcnMoKSB0byBoYW5kbGUgdGhlDQo+
IGFsbG9jdGlvbi4NCj4gDQo+IEZpeCB0aGlzIGJ5IGFkZGluZyBhbiBleHBsaWNpdCBpNDBlX2Fs
bG9jX3J4X2JpKCkgY2FsbCB0byBpNDBlX3NldF9yaW5ncGFyYW0oKS4NCj4gDQo+IEZpeGVzOiBi
ZTEyMjJiNTg1ZmQgKCJpNDBlOiBTZXBhcmF0ZSBrZXJuZWwgYWxsb2NhdGVkIHJ4X2JpIHJpbmdz
IGZyb20NCj4gQUZfWERQIHJpbmdzIikNCj4gU2lnbmVkLW9mZi1ieTogQmrDtnJuIFTDtnBlbCA8
Ympvcm4udG9wZWxAaW50ZWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2k0MGUvaTQwZV9ldGh0b29sLmMgfCAzICsrKw0KPiAgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKQ0KDQpUZXN0ZWQtYnk6IEFuZHJldyBCb3dlcnMgPGFuZHJld3guYm93ZXJzQGlu
dGVsLmNvbT4NCg0KDQoNCg==
