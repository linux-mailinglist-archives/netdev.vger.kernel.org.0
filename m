Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F06439460B
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 18:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236551AbhE1Qvu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 12:51:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:31832 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236456AbhE1Qum (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 May 2021 12:50:42 -0400
IronPort-SDR: faW3gRXb6QFOlXJt4+6/yZV1fX6ATHoikxINbQR8fb74NH0fbXIpv7SlZsQOCbPQAyjW9e6Cmg
 kvPVy/ktadmA==
X-IronPort-AV: E=McAfee;i="6200,9189,9998"; a="199953409"
X-IronPort-AV: E=Sophos;i="5.83,230,1616482800"; 
   d="scan'208";a="199953409"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2021 09:48:20 -0700
IronPort-SDR: ++uMhmFgDC6N/FNxQYNs07yiOvlmLJBtuxS2E1iNg8ZEDUH1EqJ1bBxxSioGHBFBIfZ5wFJw1/
 fVAWsBFgjiCg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,230,1616482800"; 
   d="scan'208";a="477990812"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga001.jf.intel.com with ESMTP; 28 May 2021 09:48:20 -0700
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 28 May 2021 09:48:20 -0700
Received: from orsmsx604.amr.corp.intel.com (10.22.229.17) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Fri, 28 May 2021 09:48:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx604.amr.corp.intel.com (10.22.229.17) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Fri, 28 May 2021 09:48:19 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Fri, 28 May 2021 09:48:19 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XD3Z0YCB611LW/cLcQpQfOiX+P6DXyplo6RmglNgwLD0d36I1ULR9uvbWnYur7zNR3KYivKTLgHahXtpHYzeXOTtiucIFGrStjM3+464dB7hj9wDRJQIE+1z54BP+1I/tcChHic8+SK3iQm4VMX7EuIFe2a2dwYAoMCbAvYwaXBlCxakl6NZ5B+Ln+NH3jMKSGk5VLJ/lOG3TgLjkn1LkLYtd+jWgmpCwIyEOc+sFk6EO05A15QKiAUBpmIeJeGNCbeff9Wgtg11fifYRml6kx12uCH7DuRUNcavmDVbUfXxZvDHZmze68WjsOEphXYBxaoNBbKufzHA1q5Gjy4lAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/f4wD9di7/eCHUt2UkugFPobN6u9nyXLPuGTZWyM8gE=;
 b=SjBd+cMyHyhZEjVsnl4rH674C+XvNt8WK8Bnakp4cL38xScRAhZg2D2PsEj+PT6HkK0OadObqUhoBR3K3pw8Py5r8Q5v9Xhe0xCf6pULaFbEuiHTwOdtfyBBZ5d410ODILIw4H+dMGS9+cxJ4hh0nXUWCKnCWmRLfdr+wQraASfQsvhIaoLYkyKUJLbkmZsdLEY2WnX7dQS6V9mt4w43bHU+qnfSq8oRP3iaW186ZYexCZofa1CdDxynShXZJWN85T8uJGpUcvN++kdbpFq6PZI4w7JIsFtKxLu7HLMFc/t4EbDxFRw3dJnvlJwwF1hy2riA6oKYAF51iUf4ksBb0Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/f4wD9di7/eCHUt2UkugFPobN6u9nyXLPuGTZWyM8gE=;
 b=i2Ds7bD9BCfDXPSxgKPg0QwYyZTn26WpOBgzSL2xi2HbCne7PE9T3Hr63G4ajwOQw9sqinqhrhjm7Puyl3ScVXr+1Zt5/Y5EaoruxzQRChTmhHmwNaEGHGrTK15WIdBiM/xcMO7jh3QCsOYXyTiAvYUoIzTnxAePC1G11Pt9bsI=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SA2PR11MB4812.namprd11.prod.outlook.com (2603:10b6:806:f8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.21; Fri, 28 May
 2021 16:48:17 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4173.023; Fri, 28 May 2021
 16:48:17 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "jgg@nvidia.com" <jgg@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "Ertman, David M" <david.m.ertman@intel.com>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 4/7] ice: Implement iidc operations
Thread-Topic: [PATCH net-next v2 4/7] ice: Implement iidc operations
Thread-Index: AQHXUx2mVf8C92CTZEuUWXa28rYScar4Bh2AgADXAACAAD/dAA==
Date:   Fri, 28 May 2021 16:48:17 +0000
Message-ID: <3cc44e5cde9894f0b4d1c6351d40f289d5938005.camel@intel.com>
References: <20210527173014.362216-1-anthony.l.nguyen@intel.com>
         <20210527173014.362216-5-anthony.l.nguyen@intel.com>
         <20210527171241.3b886692@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
         <20210528130212.GL1002214@nvidia.com>
In-Reply-To: <20210528130212.GL1002214@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-2.fc32) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e16fe8b8-4457-4dd1-6afa-08d921f864e7
x-ms-traffictypediagnostic: SA2PR11MB4812:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR11MB48127F737086241C39746E31C6229@SA2PR11MB4812.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: aSByZopb+JFxCbVwHapzi6eh/93PWWGWC5HG749erJHjtJGRR8zNliJ+gxBxFGrOwQIIWS9/g2/L+KuZAGhwzRSTpo2YdJj1GcfShhylE4SSaegeL1GLFoCeL3cm3R8PkBseBCBKMBmgg0HadazERpi4NHutj4TiAWwzTjf5++3KydHvG04Li/WzExXJ4QQUx9T7Sixkz/3pGEAmui8CebfSEI5DBKBFqK1cyBgSWJMX9HIgzqmUSEdwFFVWL9kvnU7+0F/+Q626CiZPD33TYWJusg2EQctRc8KfEBzbfnKNdyASaYI9Kp0v9TkPbsarZRrqRTunrVL/uL5MUpQ/SftNrAhdBeB+W9wzI+XC/qmNDIfTA1yfZSp1fdZCr271m6fMSbn+6We1p/y45/NLpDfwcKM0kX0oVC6Cec4K6vgg69dKAbpAR6XAfhUYIh/FxVsBHgkt4G568K1Zwp/iBFQ3K+kUYs2Li5r8jTcHYo6KZDqPT8Q1WQIotEzAlYmUw4yHULOU/iycCOnCs+Bdby9IOQn8GRFddJFMn6aacMYLOC3Yi7+LZFUF37RmYoj+uB2BEcM9RsLNMwJITjScVK0BirzmPyoiV5pfKy6VvUQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(376002)(346002)(186003)(2616005)(86362001)(38100700002)(122000001)(8936002)(2906002)(54906003)(6506007)(6512007)(8676002)(316002)(110136005)(6486002)(26005)(66946007)(478600001)(66556008)(71200400001)(4326008)(66476007)(66446008)(91956017)(76116006)(64756008)(5660300002)(36756003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?Q0txSTRBQWFXYjNvUU1XT0ZwSDZmNStxdHdCVTE2d3hNbWpzcExxakh3MnZC?=
 =?utf-8?B?aW9ROTdCQkNXeHpGMUpWenMvT0Y4NkZ5bXAvV1VUMFNWZiszOUF6L1oyS2ta?=
 =?utf-8?B?Nm5GU1BkT0VlRlAzeURnSjJhOTFYd090QU5TVzVLVll2NEFUcWwzc2VPK0hn?=
 =?utf-8?B?ZGtOeHg3TERuRTRLdFhPNFp5VW8weEdydzFsSkYrZVoxbHFJb0g4QU5XL0NM?=
 =?utf-8?B?dyt6bzV3aVJJNFRGRVlCZjhndS93VThwV294Mk4vYkdJdmZqTEhjR2NaV1Iy?=
 =?utf-8?B?QVNhVjVoK3Q5Y0hKcDJwYVJQSUI1K0c0Z05Da0dwVTUvaEFKS1A3eDAzY09U?=
 =?utf-8?B?REJValNaL3p0TDdVYzIzWVUzaXR0dDRGcjRGWXdCSkdpaVFYREFFTUVyQjBI?=
 =?utf-8?B?OU83a2xTbXhZN0d6aU5aeXZsOXVFenV5czNRVVI0VVh0Mi9GTEM0cTg5RFhD?=
 =?utf-8?B?a2RjUXgxcUIyNVl6bTR3RVdUa01XdUpHbzk3alFWQVVyMjhEaXVQRVlUaTN5?=
 =?utf-8?B?YnZqSTBHLzc1dXQyMUhTalF4bGwvMytidi9oUUtIa2RUSVI3M3hOVUdYZ2d3?=
 =?utf-8?B?elBWOGJhNEJTd3JLK1Y3bklYVDZCQUJia0s1VDhWUTNoOG5NRUNRd3duZXdD?=
 =?utf-8?B?VlFxZkJuSEZNamFNVmR2d01xZ01aZFk2MzllNWlrSjE5eXhabXNNODB6a3I0?=
 =?utf-8?B?dXpYajNkS2pVSzN3Y3BxYkZNQzdibWRoUmRySC9jQWtoL3hBaXhEVEV6cHAy?=
 =?utf-8?B?eU5aTFpPeUtJOFZWRGtoaktNTmRudkpyN3JVT2VNNk5xVEkybjBLOEc4QS9Z?=
 =?utf-8?B?bTc3R2NyQ2JrL2lPd093RmJYRE9yUTRyYUowUWIxS0pPbk5mT3haZnVUNGJS?=
 =?utf-8?B?VzNBbVZwTVBiaSt4RnNQalhyTTkrV2ZWRUZJMGFtTDZzZTBCQUM2V05oYlFu?=
 =?utf-8?B?Ly83NG94aGNKRUh3RER2VzBCdFovRTBCVlNjbU1sc0JjZ1lvbDZlUUEvUFNT?=
 =?utf-8?B?cUN1L2F6QnFaMWJZQTFjdWExMWtsWG1wbGsydWd0SVlRZ3dlekZseGpqK3d5?=
 =?utf-8?B?N3ROT1lpa3RsYU1iRlpzR2RuaElFbGZVcE9LQ0o2alRpMXMycFdvT08vejFW?=
 =?utf-8?B?Ym92M3ZMNjZ3WTVINDRyUmdXMFJWSHJvWnFYc2xNSThUR1BjWGp3NWIza1VP?=
 =?utf-8?B?OHNhSTdtelN4V2UrWDJVQW4vN2xUdnJBbGJPcHZiT0NaN0tlbm5wT1RzWXVT?=
 =?utf-8?B?V0g5bTBRamdjcUdJejI0czNoT3VJR1NGaHVLV1JHWjdKVDdnNTFMU1pZNU9W?=
 =?utf-8?B?cVlqZnhacUJBazBZVmEvNVJxdkFUMzlpU2NMeXduNEtuLzBxY1BNRWpJTGRu?=
 =?utf-8?B?TnNpU3g1RkhIUjVuRmlKRnV0WS9uWTR3Ym55VmsrZU45NlNxZk1RejJoN0M5?=
 =?utf-8?B?aHlvTUlWVFBOOEhFQUJqek1qSUc5MlI2K1A1Mk9yNjJNazAvRWFGRnZUWEJF?=
 =?utf-8?B?MVAwUm1TbG1nMC9hMy9ha1htdFZPa2lNU0hHZ0pHY09jdGVxekE1Wnc2NWRZ?=
 =?utf-8?B?b2UzUkdTNnQrSzYzNHFnb2xWSXZLRDBnY1hmcDNJZWJjZWZXOFlLQWpaUFB6?=
 =?utf-8?B?MFRZWHM4aEFBRmNNTU9CMkhCM1ZLOGVxckN0K09Ra3RmSEJxTS8xTmljbGtP?=
 =?utf-8?B?cXRyNG9wSnpMTFJETy9QU0NsaHpvNWxTZ25lUWE1YytSUDBMVlRWUDBBMnJp?=
 =?utf-8?B?QUxrZnhwMStNS3RsOTRZNmFKeUQ0dEQ0VTJUWS9LT3J1TWYrVkVhWmNkTkRH?=
 =?utf-8?B?N0Y5WGQ1OGFFZVY4RE9sZz09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <46F1CE4CBFDA394EA406B9CA66AEE827@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e16fe8b8-4457-4dd1-6afa-08d921f864e7
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2021 16:48:17.6580
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PobGBph8DU1CF/nMdGS8bZHMdXHJBCsMYSo/15vLVR1AYmQ0tvKJEnNEsvkuE02mnzHp48f5EfY8MdQvPDPMVPYVGDGdiZG6lzvwVKksOJ8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4812
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA1LTI4IGF0IDEwOjAyIC0wMzAwLCBKYXNvbiBHdW50aG9ycGUgd3JvdGU6
DQo+IE9uIFRodSwgTWF5IDI3LCAyMDIxIGF0IDA1OjEyOjQxUE0gLTA3MDAsIEpha3ViIEtpY2lu
c2tpIHdyb3RlOg0KPiA+IE9uIFRodSwgMjcgTWF5IDIwMjEgMTA6MzA6MTEgLTA3MDAgVG9ueSBO
Z3V5ZW4gd3JvdGU6DQo+ID4gPiArc3RhdGljIGVudW0gaWNlX3N0YXR1cw0KPiA+ID4gK2ljZV9h
cV9hZGRfcmRtYV9xc2V0cyhzdHJ1Y3QgaWNlX2h3ICpodywgdTggbnVtX3FzZXRfZ3JwcywNCj4g
PiA+ICsJCSAgICAgIHN0cnVjdCBpY2VfYXFjX2FkZF9yZG1hX3FzZXRfZGF0YSAqcXNldF9saXN0
LA0KPiA+ID4gKwkJICAgICAgdTE2IGJ1Zl9zaXplLCBzdHJ1Y3QgaWNlX3NxX2NkICpjZCkNCj4g
PiA+ICt7DQo+ID4gPiArCXN0cnVjdCBpY2VfYXFjX2FkZF9yZG1hX3FzZXRfZGF0YSAqbGlzdDsN
Cj4gPiA+ICsJc3RydWN0IGljZV9hcWNfYWRkX3JkbWFfcXNldCAqY21kOw0KPiA+ID4gKwlzdHJ1
Y3QgaWNlX2FxX2Rlc2MgZGVzYzsNCj4gPiA+ICsJdTE2IGksIHN1bV9zaXplID0gMDsNCj4gPiA+
ICsNCj4gPiA+ICsJY21kID0gJmRlc2MucGFyYW1zLmFkZF9yZG1hX3FzZXQ7DQo+ID4gPiArDQo+
ID4gPiArCWljZV9maWxsX2RmbHRfZGlyZWN0X2NtZF9kZXNjKCZkZXNjLA0KPiA+ID4gaWNlX2Fx
Y19vcGNfYWRkX3JkbWFfcXNldCk7DQo+ID4gPiArDQo+ID4gPiArCWlmICghcXNldF9saXN0KQ0K
PiA+IA0KPiA+IGRlZmVuc2l2ZSBwcm9ncmFtbWluZw0KDQpXaWxsIHJlbW92ZSB0aGlzLg0KDQo+
ID4gDQo+ID4gPiArCQlyZXR1cm4gSUNFX0VSUl9QQVJBTTsNCj4gPiANCj4gPiBSRE1BIGZvbGtz
LCBhcmUgeW91IG9rYXkgd2l0aCBkcml2ZXJzIGludmVudGluZyB0aGVpciBvd24gZXJyb3INCj4g
PiBjb2Rlcz8NCj4gDQo+IE5vdCByZWFsbHksIEkgd2FzIGlnbm9yaW5nIGl0IGJlY2F1c2UgaXQg
bG9va3MgbGlrZSBiaWcgcGFydCBvZiB0aGVpcg0KPiBuZXRkZXYgZHJpdmVyIGxheWVyLg0KDQpX
ZSBoYXZlIGxvb2tlZCBpbnRvIGhvdyB3ZSBjYW4gZWxpbWluYXRlL21pbmltaXplIHRoZSB1c2Ug
b2YgaWNlX3N0YXR1cw0KYW5kIG91ciBhc3Nlc3NtZW50IGlzIHRoYXQgdGhpcyB3aWxsIHRha2Ug
YSBkZWNlbnQgYW1vdW50IG9mIHdvcmsuIFdlDQphcmUgdHJ5aW5nIHRvIGdldCB0aGlzIGRvbmUu
DQoNClRoYW5rcywNClRvbnkNCg0KPiA+IEhhdmluZyBoYWQgdG8gbWFrZSB0cmVlLXdpZGUgY2hh
bmdlcyBhbmQgZGVhbCB3aXRoIHRoaXMgY3J1ZnQgaW4gDQo+ID4gdGhlIHBhc3QgSSd2ZSBkZXZl
bG9wZWQgYSBzdHJvbmcgZGlzbGlrZSBmb3IgaXQuIEJ1dCBpZiB5b3UncmUgb2theQ0KPiA+IEkg
Z3Vlc3MgaXQgY2FuIHN0YXksIHRoZXNlIGFyZSBSRE1BIGZ1bmN0aW9ucyBhZnRlciBhbGwuDQo+
IA0KPiBJIGRvbid0IHRoaW5rIGl0IGlzIGEgIlJETUEiIGlzc3VlOg0KPiANCj4gJCBnaXQgZ3Jl
cCBJQ0VfRVJSX1BBUkFNIHwgd2MgLWwNCj4gMTY4DQo+ICQgZ2l0IGdyZXAgLWwgSUNFX0VSUl9Q
QVJBTQ0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2NvbW1vbi5jDQo+IGRy
aXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2VfY29udHJvbHEuYw0KPiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX2RjYi5jDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2ljZS9pY2VfZmRpci5jDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
ZmxleF9waXBlLmMNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9mbG93LmMN
Cj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9saWIuYw0KPiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX21haW4uYw0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9p
bnRlbC9pY2UvaWNlX252bS5jDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2ludGVsL2ljZS9pY2Vf
c2NoZWQuYw0KPiBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3NyaW92LmMNCj4g
ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV9zdGF0dXMuaA0KPiBkcml2ZXJzL25l
dC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3N3aXRjaC5jDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L2ludGVsL2ljZS9pY2VfdmlydGNobmxfcGYuYw0KPiANCj4gSmFzb24NCg==
