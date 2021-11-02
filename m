Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 193984428F8
	for <lists+netdev@lfdr.de>; Tue,  2 Nov 2021 08:55:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231189AbhKBH6a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 03:58:30 -0400
Received: from mga18.intel.com ([134.134.136.126]:48551 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230508AbhKBH63 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Nov 2021 03:58:29 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10155"; a="218115521"
X-IronPort-AV: E=Sophos;i="5.87,202,1631602800"; 
   d="scan'208";a="218115521"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Nov 2021 00:55:53 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,202,1631602800"; 
   d="scan'208";a="559922042"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 02 Nov 2021 00:55:52 -0700
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Tue, 2 Nov 2021 00:55:51 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Tue, 2 Nov 2021 00:55:51 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.108)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Tue, 2 Nov 2021 00:55:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B8/nkzziiF2NScHOSGKqFD9gF2V3xhPpj62XU7BGUdJgHsmNGPioBeotzATDLzWup0TxeCaccCNSQS+lHWYEIw4cXXNMwSbWwF2WOMU1xYLkym6yYtwvVOXCnzj/b19Wo05stXArJkbEV9bnBXv6WmrCQejplU2ouPx555zJaaUZ6bjD4lJXkyOIBSzZg/YoSLJNE10mmfkuF/2t9/iz4ioNjjFlJpEuRIaUKBFpyKjUPFvF6cAbYi8UdXBSqVInWJjr8rprGLbiq4Vl6kiraFRm0pVKzE5/C6sjFoc/838TqrtXcRwURyyNb9VWeA3WWrNqwFLu60WbKKQo9CnZHA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KGb7Va1CQaeU9sZGh4bJVwIfJUh9kuOkO6M+wPwwblE=;
 b=jWH7U7HQCNLez66zHUxT0jfvtT4QpGsc+KN3BO/q64hwlPH3b+er/2nMKE+IeVVLtXpeOGQNNsEFG3h2t9YGFXEmuEDUY61HrronCkx2YxQR5zRers28x8bX3/X9jnKeiaeUlhMKGedb1yWlr7JIy+U3Ow4HcJmYKFI+sGiZNcUMSe2lOp99gJpTDrezW8rElSVo5ZHGsDEojUZByP/OA829Zrmtbk1UeAc1fhwjDs1ZHJzpK/3srEHvzpNxXt2BabH3W2WGZ1cCmecZT7Q5dnF0cRvO4dlDWVkuuRClu7muJ29G/QnT8RjVpdCFr8/bzGJt0yTiOgFBb6H5dI9alg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KGb7Va1CQaeU9sZGh4bJVwIfJUh9kuOkO6M+wPwwblE=;
 b=iyJ89q2wuSLj9bhKKJYIkG2HHGTyy1HSBoLihD+YHpgzt12geHpQM4Rb/RQCf0VcASymN6YrzvPEtZZqS5tgUxX3TNLZiou+xNDWfog1ySdDmvNotDFto+K2Go0EABKuscueIQU8hottolmPZv5dtU5BNcZZCNQquNlHc6vxv54=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by SJ0PR11MB4832.namprd11.prod.outlook.com (2603:10b6:a03:2dd::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4649.15; Tue, 2 Nov
 2021 07:55:50 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::e559:d4e6:163c:b1ae%6]) with mapi id 15.20.4649.020; Tue, 2 Nov 2021
 07:55:50 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "jiapeng.chong@linux.alibaba.com" <jiapeng.chong@linux.alibaba.com>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: Re: [PATCH v2] iwlwifi: Fix missing error code in iwl_pci_probe()
Thread-Topic: [PATCH v2] iwlwifi: Fix missing error code in iwl_pci_probe()
Thread-Index: AQHXz75+rO6exLGIZki9dI5DRh9vfavv3psA
Date:   Tue, 2 Nov 2021 07:55:50 +0000
Message-ID: <93e2a980e9cacb160cc73b4c4589c88f807fa7bd.camel@intel.com>
References: <1635838727-128735-1-git-send-email-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <1635838727-128735-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.42.0-2 
authentication-results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9a22f0a2-9099-4855-ba31-08d99dd63033
x-ms-traffictypediagnostic: SJ0PR11MB4832:
x-microsoft-antispam-prvs: <SJ0PR11MB483271A76F6A679103B79589908B9@SJ0PR11MB4832.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ub5EnYbudgoVJN5OYshC3WSncB/Ux5vpMp0gwaxOvFs3PVmpgO53C+xahMd8R8B1CWt4R8IaEeA88zt8WxYSpDX36WhywykbpRP/hhj9wgCIQLfGyKuFbKaQTUwfilFk+gsK8fiXoYbR7vJTRgJdYRvMpWSrPyz33ZfKkgG/kVWwqntOv9Df8JRc5TMaNVApYj+Gan4tV+dtyDfmf4jaPWEXUcOSRbyV3u3zBm1RyrbjygrDRcW/3sr+Rm1LgEIUH8e83Vr5j/ZYUp5JfcbQ49hihvfqoFjcO8xAyOTvDlHQnZ+R/poLb7MHXeAZmOV7xhbBXAv7x/7ztL/m2ZLO5OGQ77kWYv0pkxiROjD/rROC5ZW3yTRbv/bHDzEWDkyiFAEMPXETuDvwPRWXZiRpVczhIZgFGhi4j6cuHgP6KlL6Ha7mbRX6y4lGsPr0Z4KkULlzgAciYtDUsMydKKLJPDL8P1VuwicVRtgPnDvzXHFm8M+kCSODZTUWOzQIKRqhr03F83OmP+ZW5FD1lCxrTwYc2lJIw44vPg1+hEgcVv1/mZCyUnZTfXuUpswvTzSjiBEILaBGhvrWTSCwlnewucD0UBD1EqWgZOFJwkuVA1hxF+Y3hsuBTIEBCjvA+DYMQbVKDqDq+IfulTqWmHxM+pVeF8/dToUKp0e/oSS5dPLWpzyTAdZPYCOjSaW+25qj80cYib7bt2+TvrI/X9XKe5zr2JXKVR9dxf+NN07xp72ztXdxl7qWhuZ7xlBTQXVzM9VVwT6MOrk0qgeYf3hRZH/6u0xb3RXlNCvKk1zPJ5A=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(71200400001)(82960400001)(66946007)(26005)(36756003)(508600001)(76116006)(6512007)(966005)(83380400001)(2906002)(91956017)(5660300002)(2616005)(6486002)(86362001)(64756008)(38070700005)(66476007)(38100700002)(66556008)(8676002)(4326008)(8936002)(186003)(6916009)(54906003)(122000001)(316002)(66446008)(6506007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?MFM1QjI0b05nMkcxRTM5cmVmVUpCbUt5d0NIL3B4dkJ2R1NtQjgvKzhodGZr?=
 =?utf-8?B?YytJZjVIZ2NZaXQvWkNnK3dqc3B4M2NZNmJSdStPTmZ5NnUzNm5DcDdiVWFF?=
 =?utf-8?B?OUJOUnZlZFQwaE1RSDdqOGxwS3BHNU90Q2JJdHFlTDdvTHV6eTQwYk1mNERB?=
 =?utf-8?B?RTd2VXg5NHFVVWNqeFRaRzVwRXFMQndBYmpPazY3cXI3S2VhQzcvUEIzTWh0?=
 =?utf-8?B?MG0vUndKaEtRdU9oM2NmTGFpa1VtUjRocXdiZVJ6Rjg2Q1IyeU82Y0F0d3pN?=
 =?utf-8?B?SEhRTWRKSHZzaWFVUCtvdmxBamg0eTUxMmtPVDdTaitPODVybHBnb3dDRXZ3?=
 =?utf-8?B?L2lkQlk0OWRFcDV6SE5zUVZjVjhrL2tFTWpGQXFBLzFRWnBDaU1lMGpibktM?=
 =?utf-8?B?aEN1RGR5RTJnNUMraVpMY1MxdkhWemp5a0hMaFUwMU5IWXZHUlFqYW9WcG1I?=
 =?utf-8?B?b21xcGhZZ1Z0VlZ3MkY2TW9YSEttVytyOGIzYVV4c3RTcW12cG1BQUpJNWZT?=
 =?utf-8?B?NXp1UDVjcVl3U3ljeG50eFZ5eUJQK1Avb01UU0psc2l0Mlp3MFphMWtFVk0r?=
 =?utf-8?B?Y0FUc2JWejQ4aTF5T2RUcithdmFFeThFTDNGV0RIdjNyRFdHV21oRmEwV2xr?=
 =?utf-8?B?czRUcFpzYkRPL3RmNWpmbDFNK0xqeUtDTDlWcG9jd3ZhQXNUcENZWndxTC9v?=
 =?utf-8?B?UldpVUZ3L0F2RXBjaWxZZXdwWTNJOVE2Y085WGtMYytOVUMvYkx6VUtzVVY1?=
 =?utf-8?B?NVoyV01jZVNIbHB6N29SWHI3LzN3SHplcTdna213QlcyaUp6b29jSDkwaWdS?=
 =?utf-8?B?cFpRNEd5T2QrTEd4Qms0bUJoL0hLYnRXb1BVOGpKUStMeU0vV3E3ZUxQRVh2?=
 =?utf-8?B?U1RRQ2xZNjRwak8wRWRHUGdGZU1XQXhWbDUrOHA4SnI4NCtPUUQyelgwVCtn?=
 =?utf-8?B?eUU5cFRlY29NQ3NWb0pWOWN2Nng3V0JDVE8yUXliVkQwMTFPTFIxalBsQ1Rq?=
 =?utf-8?B?SGh0YTk5bG9zNTBKaUp4RkJlOGFOcCtkNUY0bmNKcGtXZlJaUTlWRjdIVFNU?=
 =?utf-8?B?QmdLVkJHTjdhZjBpcHo1dWNUcytudDBPSWtIbFVodEg5akZmWE1hWERKZW5m?=
 =?utf-8?B?SXBsemk1WGNKV0FUWkcwbE4vS050Y2JGVzlMYVFiL0ZESVQxWDZicGx0M096?=
 =?utf-8?B?L0pKb0NlU1Fmc3lCb09SL25neERpdkt2cGVhbGlpd2FqSm54WUI0N2Y5dDFh?=
 =?utf-8?B?ekFKbWpaNkthb09GUHRYb2VzUGljQS92cm9DS3RwNnk3TysyZnZuUDdxMEU5?=
 =?utf-8?B?Tk1vUEo4a1Q3ZWJTcG56bjdDaTJnWTd4Q2FkYVJMSDVkc1pzMCtBb0M1RXVl?=
 =?utf-8?B?UFI4anJjR0VxSDVYcVJWU2FRRlQ2WVFkc09PSmxNbnA3L2RBQ25uVStMakRK?=
 =?utf-8?B?eUpkWnlIWHd6VGUrLzl4bC9YT2xFeDFyY2pndXNTd0ZpS0FnMUZSeGJGZXN5?=
 =?utf-8?B?bnluVmhPQm5wRFVieGJKTHJlYmczb2JyRkVxSU9GcU9iZThiUVdoYldVR3VL?=
 =?utf-8?B?YVF2QzZ1MjFoUkQxWGt2SG04ZHFzNFczOG1uNDZxdXdiSVpucTZIMzY1S04x?=
 =?utf-8?B?bkpXbzVjVU9yS3FTcUp1MHdmVTdGUkF3NHFPMDFFQnhmSndtWjlOR0NHa0Yx?=
 =?utf-8?B?WXpCaFB3OFMwcnY4ZmFVczJuYUlnN0FRVU13ZFpLUFlNbHR4U1Y0MHQ3OVVS?=
 =?utf-8?B?MWI2eTEyREZYb1YyYzh2QUdYTkNUOTBvem5iUjZxa3d2QXRvSVdIeEZISDI4?=
 =?utf-8?B?VFkveTA3UGYyc0h5UGMzazZwd29Jam1zSjhiRjlTU0tnTXRXWFppUUJaUmpI?=
 =?utf-8?B?amczK1pKWnk0Y1czZEFId3k1NW9ncFNocVpDcVF3anoveHFLOGNUd2lvR2FJ?=
 =?utf-8?B?T0VxOWdIOGtlOGJiU3V2V3VtMkJJSXh4SmZoRGlVY3pDZmhKeXZBdS9GUHBC?=
 =?utf-8?B?by9JS1A3OXh1b25Ca2QzcUtjdERxeHRMSEVzRU11VUFCNll2RHU2Tm90UVlK?=
 =?utf-8?B?VHc0Zm1FTmxHcmN5RVdTYjgxanlIaSsxUnluUnU5a1lGb1dXQkVWZm5GUTI5?=
 =?utf-8?B?MEV2Z05PWXpLTmJ0K05hcGV2N2k2YUYyY0RHZXZHLytpUVRnd0t0L2lDZXNm?=
 =?utf-8?B?SUFxc3U3WUowMENwT0NVZlFDdUJ3RkRiVXM3SDFnL1ltUUZ6dEZycjJzMDZG?=
 =?utf-8?Q?B5OU/G6EIzT4LhOyu7mPUgauEeBfeCTohaJFqkCKik=3D?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <236BB49217248343A7A7507AF145D9AD@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a22f0a2-9099-4855-ba31-08d99dd63033
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Nov 2021 07:55:50.6324
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +5vJHUlaIO3u26vH0KMbl11/cTQZ94GutXYDwXz5ByqwjVufskhFYqXFxkJKNVufxG2Eb3drt1rTs10eWR2ov+leW0RwNsEZ29DXzlCWMfA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB4832
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTExLTAyIGF0IDE1OjM4ICswODAwLCBKaWFwZW5nIENob25nIHdyb3RlOg0K
PiBGcm9tOiBjaG9uZ2ppYXBlbmcgPGppYXBlbmcuY2hvbmdAbGludXguYWxpYmFiYS5jb20+DQo+
IA0KPiBUaGUgZXJyb3IgY29kZSBpcyBtaXNzaW5nIGluIHRoaXMgY29kZSBzY2VuYXJpbywgYWRk
IHRoZSBlcnJvciBjb2RlDQo+ICctRUlOVkFMJyB0byB0aGUgcmV0dXJuIHZhbHVlICdyZXQnLg0K
PiANCj4gRWxpbWluYXRlIHRoZSBmb2xsb3cgc21hdGNoIHdhcm5pbmc6DQo+IA0KPiBkcml2ZXJz
L25ldC93aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmM6MTM3NiBpd2xfcGNpX3Byb2Jl
KCkgd2FybjoNCj4gbWlzc2luZyBlcnJvciBjb2RlICdyZXQnLg0KPiANCj4gUmVwb3J0ZWQtYnk6
IEFiYWNpIFJvYm90IDxhYmFjaUBsaW51eC5hbGliYWJhLmNvbT4NCj4gRml4ZXM6IDFmMTcxZjRm
MTQzNyAoIml3bHdpZmk6IEFkZCBzdXBwb3J0IGZvciBnZXR0aW5nIHJmIGlkIHdpdGggYmxhbmsg
b3RwIikNCj4gU2lnbmVkLW9mZi1ieTogY2hvbmdqaWFwZW5nIDxqaWFwZW5nLmNob25nQGxpbnV4
LmFsaWJhYmEuY29tPg0KPiAtLS0NCj4gQ2hhbmdlcyBpbiB2MjoNCj4gICAtRm9yIHRoZSBmb2xs
b3dpbmcgYWR2aWNlOg0KPiAgIGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL2xrbWwvOWRiYWE3MmM4
NjQ3MGU1NGM1ZGRmNTQ3NmZiOTU2OWI0MDI1YmUzZS5jYW1lbEBpbnRlbC5jb20vDQo+IA0KPiAg
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5jIHwgNCArKystDQo+
ICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBk
aWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5j
IGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5jDQo+IGluZGV4
IGM1NzRmMDQxZjA5Ni4uMzMyNTBkMjRjMmI5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC93
aXJlbGVzcy9pbnRlbC9pd2x3aWZpL3BjaWUvZHJ2LmMNCj4gKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvaW50ZWwvaXdsd2lmaS9wY2llL2Rydi5jDQo+IEBAIC0xNDQyLDggKzE0NDIsMTAgQEAg
c3RhdGljIGludCBpd2xfcGNpX3Byb2JlKHN0cnVjdCBwY2lfZGV2ICpwZGV2LCBjb25zdCBzdHJ1
Y3QgcGNpX2RldmljZV9pZCAqZW50KQ0KPiAgCSAqLw0KPiAgCWlmIChpd2xfdHJhbnMtPnRyYW5z
X2NmZy0+cmZfaWQgJiYNCj4gIAkgICAgaXdsX3RyYW5zLT50cmFuc19jZmctPmRldmljZV9mYW1p
bHkgPj0gSVdMX0RFVklDRV9GQU1JTFlfOTAwMCAmJg0KPiAtCSAgICAhQ1NSX0hXX1JGSURfVFlQ
RShpd2xfdHJhbnMtPmh3X3JmX2lkKSAmJiBnZXRfY3JmX2lkKGl3bF90cmFucykpDQo+ICsJICAg
ICFDU1JfSFdfUkZJRF9UWVBFKGl3bF90cmFucy0+aHdfcmZfaWQpICYmIGdldF9jcmZfaWQoaXds
X3RyYW5zKSkgew0KPiArCQlyZXQgPSAtRUlOVkFMOw0KPiAgCQlnb3RvIG91dF9mcmVlX3RyYW5z
Ow0KPiArCX0NCj4gIA0KPiAgCWRldl9pbmZvID0gaXdsX3BjaV9maW5kX2Rldl9pbmZvKHBkZXYt
PmRldmljZSwgcGRldi0+c3Vic3lzdGVtX2RldmljZSwNCj4gIAkJCQkJIENTUl9IV19SRVZfVFlQ
RShpd2xfdHJhbnMtPmh3X3JldiksDQoNClRoYW5rcyENCg0KS2FsbGUsIGNhbiB5b3UgcGljayB0
aGlzIHVwIGZvciB3aXJlbGVzcy1kcml2ZXJzLmdpdD8gSSBoYXZlIGFzc2lnbmVkDQppdCB0byB5
b3UgaW4gcGF0Y2h3b3JrLg0KDQpBY2tlZC1ieTogTHVjYSBDb2VsaG8gPGx1Y2lhbm8uY29lbGhv
QGludGVsLmNvbT4NCg0KLS0NCkNoZWVycywNCkx1Y2EuDQo=
