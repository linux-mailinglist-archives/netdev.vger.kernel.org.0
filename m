Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81A7D37501F
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 09:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233446AbhEFH0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 03:26:50 -0400
Received: from mga17.intel.com ([192.55.52.151]:55655 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233398AbhEFH0t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 03:26:49 -0400
IronPort-SDR: 1HINB36DFUlCUMK6YPCpS71g4cVDL5wdsW4P3GVJ3mU4cyyMdnltN4eFlWexdEPtV+yrwY9gzT
 +iaZafrxUwpg==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="178637264"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="178637264"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 May 2021 00:25:51 -0700
IronPort-SDR: u7h24lFuHcu8InBq/aabfd5WNuNK1FO6wfkDfwFqb4m6P6plg8rhzQ4TuSl4clqSMNlP//67Yq
 PTT5aFc6hDDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="406897337"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 06 May 2021 00:25:51 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Thu, 6 May 2021 00:25:51 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Thu, 6 May 2021 00:25:51 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Thu, 6 May 2021 00:25:51 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JXH1FfkgCF2YsjwaiMK2oLJAwayw5V5z2laUi1TBX+r/euAv3WX/NdzNSYSgSs98JXoQSjRcUrGuiMc+VLQqoU/GbLarp8FsaeR4BfVGkiysjoHXJl1WSSP0wCDgoyWzOux48BRF4u3uUPJxAdmQWRy2nHdaCKnwEzLNKdleCGgaHoFF/rg4E1GfOGmENo6ETXQy1AsI4eK0F2wrH4Rx7HV/WXxCgNszdmNNVXpNqmXXdUOKCRhufWkFFkPOtBgKqn26JBRJUi6NS02/hDs3/E1bECWIXiQStNu+V+EBFUUyekiMSb+tJW90zueurRNxyOm7NcOz0ZsM03MbQ//Buw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JMsDlEFGgdr1FsdRURHCROy3l59DWcqfFzP3lRwxzo=;
 b=bZbSjLCEVoQNcrgM0JtagSKza0tlpelYCFA7+YktG9YuSnWDLRJbRYS1b8o3Hp3cAQsRfQuDLuoUpWlv2rLpPo/dFWs/BkU47LSvDDCROtwRbTj1CcloK3NgnjJB+Zu4byGBG3bZHaguG5W85oMBDcFqWaKctAYd+XGJJh4UanJYT4bt01bBIoEDYXI8nqDCDv2hdh7sjqVTYtszSMkckGuSmt1m82hd50cNGfHw+q4xp6kGPP40clOPfFbI1K6c8jl41nUF5PM1LSzqYPY0bHAwOQw9Tv0M3sWYJmXc708CsEUdDTC/Wi7pzVIlz6fxctlgAG18nn1wfghgK7gdjw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+JMsDlEFGgdr1FsdRURHCROy3l59DWcqfFzP3lRwxzo=;
 b=PKzetqzA1mdW/2IJcGWPxijuSEQsfSjreNtyNHMB/FxtH0foQo+0328qzjowUIivlXG5D6wPvHq9yuhAADF4T5UsTsyL3FRrCo18HmY2sdRL0wZPZXzRURvDQcfdorZrAxTT3h5pP27fFrrryYmfoC9AHU0ZBnehFSfrlxqSY4s=
Received: from MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9)
 by CO1PR11MB4948.namprd11.prod.outlook.com (2603:10b6:303:9b::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.26; Thu, 6 May
 2021 07:25:46 +0000
Received: from MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212]) by MW3PR11MB4748.namprd11.prod.outlook.com
 ([fe80::a995:ea7a:29cf:d212%5]) with mapi id 15.20.4108.027; Thu, 6 May 2021
 07:25:46 +0000
From:   "Switzer, David" <david.switzer@intel.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     Kees Cook <keescook@chromium.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-hardening@vger.kernel.org" <linux-hardening@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH][next] ixgbe: Fix out-bounds warning in
 ixgbe_host_interface_command()
Thread-Topic: [Intel-wired-lan] [PATCH][next] ixgbe: Fix out-bounds warning in
 ixgbe_host_interface_command()
Thread-Index: AQHXMJgFlqLb+9DYBkK0dZKPpun+36rWMLgg
Date:   Thu, 6 May 2021 07:25:46 +0000
Message-ID: <MW3PR11MB47483A28574E9F2C5517D3C5EB589@MW3PR11MB4748.namprd11.prod.outlook.com>
References: <20210413190345.GA304933@embeddedor>
In-Reply-To: <20210413190345.GA304933@embeddedor>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=intel.com;
x-originating-ip: [50.38.40.205]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa2affaa-d693-4034-9504-08d910602ab1
x-ms-traffictypediagnostic: CO1PR11MB4948:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CO1PR11MB49481886F6EBEAE57FFC0426EB589@CO1PR11MB4948.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:155;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yA03uipmBEG0tVnceN1/V3XQRKjbGOgPDMBKLp5GFBRHs24RdpwzTqk9EwEHoaJTp9/WmNWyGA2TlakXnh+bpjcV2rPZtDWBQYvd8bIuO965qomZg36SL34Kn4v3tcFaJVl0T1yLXVQGWWtBrY1YXmJUWfRXd2dDODJD78t9ehW5+9Azy/C+2lTs8mSpkB3C+wdzkw5M/39flFfF/QrNOWI1Vc0PHxkbECuRKyBtJbo4TRjqFRFQ7ZAxPQOh5bo0umXam7xc+eLpQg1xYmu7wvO3+i42T1tYJxcpuCIgF8zICSCrG7eLcTXuotvAwMI/ZZFYc2pG6tSDPYnuo3U0PVqGCzBJOKmSPRRuM6NZlXXMMJ6cmMKg7K1j/hwQliggQ+S59Cyqml4Woz+6A1nDSK9yjiLqjrXwS/HG/3E91TOY6ZMs6zQnbZrYXbzUDW6Gw8I21rCnCq54X4VPlVwntITmUCBWKDtjKpVI563OaDScwTRn1rk23czDwrRrr5tXHRQdc+8NRTi30v5+F407JgT/RWBss/F03y6Z9buaQW6LaMvFoAN1tcVzMzyzgRZ57cQBlWW5WmTH/gxSFnxkEmac2yYzSc0KI0fGBn+kaRbBaxhNSwKU/M3M0vnyI+0OBVh9XmPbLwCtg4osd4n6IEErjgDmu2kq2Lz3JYZuzB92Cei6ijsF+U1BeniKQnwt
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4748.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(136003)(366004)(396003)(39860400002)(7696005)(55016002)(38100700002)(966005)(478600001)(66446008)(316002)(83380400001)(66476007)(9686003)(4326008)(76116006)(64756008)(6506007)(52536014)(2906002)(66946007)(66556008)(26005)(5660300002)(110136005)(8676002)(54906003)(186003)(86362001)(33656002)(71200400001)(8936002)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?SkNGbkUyRVVwZ3luSk9BQmF5Y25FSlFhUDBhVFkvVDdlVktudnlXUE9RTUJv?=
 =?utf-8?B?Z0oyQ1dPU28yU3g3QWJreVpmUmRGU2k1dWtPWU03eXpVemFGT3o5SzhjUzlu?=
 =?utf-8?B?emZDa1VvUEF1d2V4NDU2ZzJud2c2a1BrMXN4YS91d2JuNmRFVitBeUoxZG1s?=
 =?utf-8?B?OFpVQ0NzaWNJSmFWd05SNkNtZWlINlhacEM4L3B4NDFoTUF5MnJONkNWbXJx?=
 =?utf-8?B?VjZCSzJxTWgwemUrL1FyVGEzWFpRd0pYdkZYbGY5Wm1rL3ZibXhGbXBzbEFL?=
 =?utf-8?B?eTJhZ3dJVDdvRVQxN1VvMEU3ZDB0QTkwVkVsTVZrS1NoWUlFbmJxNmdjem5v?=
 =?utf-8?B?MFlvVThMQVhITC96MDFZd1RIR1ZnSk8wMWlWakxlWmR6MTl0RkluZTZQR3FK?=
 =?utf-8?B?OVRXUnphemE4clhkdjEvaUxYcUVBUFBRTHZkbHhkRGJOcmhBbGtzRURUK3ps?=
 =?utf-8?B?c3p5WURabFlweDFoM3Fyb3ZWWG1Yc3MwOTVuM1hLM3JXODhVMndNVk5ON0Iy?=
 =?utf-8?B?QkI3RHhhL0dKNGNpSlRpRzZRWEdmQ3M3enl1NGN3UGZTR040cFZwbDJpd2Yx?=
 =?utf-8?B?bTNXdDY4L2R5dWhVYW0waGtDcks1cUd6WkNNUmdHWXliMkttYk4wUDBWV0Ix?=
 =?utf-8?B?cU0zNTNBcjQ3emRXR3NRa21tYm1SYlJlQzhtWnN6KzZOVTBseGk5M2VSQWdv?=
 =?utf-8?B?UGNZdFRMbHVSbXdVYi9NQ2JmOTh1Q2JvNndwNlYrMStLdTAvUk9VR0ZJZS95?=
 =?utf-8?B?QWR3SVN5cGFFaEtxaUhGcEM3eEwwV09nQmZXcnR6VWM0bzNPc0E3Nkdqd3Nl?=
 =?utf-8?B?QjJMcmR6MnJlMUhabHpDWHZhd2d4dVByb2VaWVZjNE9Lc0xBenBaSThqOEV6?=
 =?utf-8?B?MjJya2RiN1JhbE5QYk9FUENNSDBCbk4wT1Rxc3NURHZuNC92Qjl4TTFpRU9l?=
 =?utf-8?B?UWtDOGw0YnlxNVppREFpSUQ1aXVDUzRuS2RlZWdIZTQ3NG44TngvWUZxZzNK?=
 =?utf-8?B?WnJFbzErTVRkY01TVmRGQ2tCb2xWT1pKdzRDYWVKZlF0TitZQ0hLTWI3R3Rr?=
 =?utf-8?B?ZmcxNnkxSjk0RXh4M0ZyK2RHWnhhZk1tMXhtbExVSEkzbFE2aUFWSzFsVjl2?=
 =?utf-8?B?d05QQVgycVhFYTZNcWVGT1dLWkNRcjlRdDdtYVloaDF2a1hNaFFTZnU4MjBG?=
 =?utf-8?B?cjZkSlJPRG5SMndaQ1Yzc1dZNEliUFhKOFRPamlpYVJpM0Z1WjRmcmQ1dVFt?=
 =?utf-8?B?NEhlK0NBZlN5d2lRQ2ZJeThLQW9jQ1VpZHdKeXNXRkpLVlBpWjFSL0VNdi91?=
 =?utf-8?B?VXFZWHFiekhIL3hGQmZmM2h2T214MWU2MzIweGZiazhEYk01UUEza0xrcGNL?=
 =?utf-8?B?cGRCS2wrZkJSWmNMRDU0NHJvblhpSjAzZmgyTGZtZTl1UW15cFJIM0YyZ0Vj?=
 =?utf-8?B?QjhqYkRWc0pOZXVQdVMxVmxrSmtpaXQwdlVzZzlNU3NnVHgxaDM2SGhDcjlh?=
 =?utf-8?B?V1cwRTRybzlZSG90VHg2S0ZXaDl5aHpXc01McmNWK2xTTkpRcmk2ajVTV084?=
 =?utf-8?B?d3Y0Y3FBclhUWXpKWEx2RnRDQUpwUW5GN0VCSStLUlgyUnphVkVQVVc2aWVH?=
 =?utf-8?B?NjhKRFpIZnk2WThka2krUFQ1eEVBMmdMNStUcjBOdTF6V0xxMEJEYVVmZEdm?=
 =?utf-8?B?K3VONm9EMlh3Z0tvNURpMmhtcDFTbmQxbW1UYktXaHRvWS95cEpreFBIdzZ0?=
 =?utf-8?Q?4weWKez1Sxm3VOyjMj1Fdi3eltox5xyvStmt1rV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4748.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aa2affaa-d693-4034-9504-08d910602ab1
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 May 2021 07:25:46.6930
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wSWins9gPB6vgTZl78zYW6rXrtOP1yWkMl2G4su7PXsn8yudagAZzhzpPYIx9lx8HRaMNN2MMPOqdFPndJKQWg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4948
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj5Gcm9tOiBJbnRlbC13aXJlZC1sYW4gPGlu
dGVsLXdpcmVkLWxhbi1ib3VuY2VzQG9zdW9zbC5vcmc+IE9uIEJlaGFsZiBPZg0KPkd1c3Rhdm8g
QS4gUi4gU2lsdmENCj5TZW50OiBUdWVzZGF5LCBBcHJpbCAxMywgMjAyMSAxMjowNCBQTQ0KPlRv
OiBCcmFuZGVidXJnLCBKZXNzZSA8amVzc2UuYnJhbmRlYnVyZ0BpbnRlbC5jb20+OyBOZ3V5ZW4s
IEFudGhvbnkgTA0KPjxhbnRob255Lmwubmd1eWVuQGludGVsLmNvbT47IERhdmlkIFMuIE1pbGxl
ciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IEpha3ViDQo+S2ljaW5za2kgPGt1YmFAa2VybmVsLm9y
Zz4NCj5DYzogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+OyBuZXRkZXZAdmdlci5r
ZXJuZWwub3JnOyBsaW51eC0NCj5rZXJuZWxAdmdlci5rZXJuZWwub3JnOyBHdXN0YXZvIEEuIFIu
IFNpbHZhIDxndXN0YXZvYXJzQGtlcm5lbC5vcmc+OyBpbnRlbC0NCj53aXJlZC1sYW5AbGlzdHMu
b3N1b3NsLm9yZzsgbGludXgtaGFyZGVuaW5nQHZnZXIua2VybmVsLm9yZw0KPlN1YmplY3Q6IFtJ
bnRlbC13aXJlZC1sYW5dIFtQQVRDSF1bbmV4dF0gaXhnYmU6IEZpeCBvdXQtYm91bmRzIHdhcm5p
bmcgaW4NCj5peGdiZV9ob3N0X2ludGVyZmFjZV9jb21tYW5kKCkNCj4NCj5SZXBsYWNlIHVuaW9u
IHdpdGggYSBjb3VwbGUgb2YgcG9pbnRlcnMgaW4gb3JkZXIgdG8gZml4IHRoZSBmb2xsb3dpbmcg
b3V0LW9mLQ0KPmJvdW5kcyB3YXJuaW5nOg0KPg0KPiAgQ0MgW01dICBkcml2ZXJzL25ldC9ldGhl
cm5ldC9pbnRlbC9peGdiZS9peGdiZV9jb21tb24ubw0KPmRyaXZlcnMvbmV0L2V0aGVybmV0L2lu
dGVsL2l4Z2JlL2l4Z2JlX2NvbW1vbi5jOiBJbiBmdW5jdGlvbg0KPuKAmGl4Z2JlX2hvc3RfaW50
ZXJmYWNlX2NvbW1hbmTigJk6DQo+ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhn
YmVfY29tbW9uLmM6MzcyOToxMzogd2FybmluZzogYXJyYXkNCj5zdWJzY3JpcHQgMSBpcyBhYm92
ZSBhcnJheSBib3VuZHMgb2Yg4oCYdTMyWzFd4oCZIHtha2Eg4oCYdW5zaWduZWQgaW50WzFd4oCZ
fSBbLVdhcnJheS0NCj5ib3VuZHNdDQo+IDM3MjkgfCAgIGJwLT51MzJhcnJbYmldID0gSVhHQkVf
UkVBRF9SRUdfQVJSQVkoaHcsIElYR0JFX0ZMRVhfTU5HLCBiaSk7DQo+ICAgICAgfCAgIH5+fn5+
fn5+fn5efn5+DQo+ZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfY29tbW9u
LmM6MzY4Mjo3OiBub3RlOiB3aGlsZQ0KPnJlZmVyZW5jaW5nIOKAmHUzMmFycuKAmQ0KPiAzNjgy
IHwgICB1MzIgdTMyYXJyWzFdOw0KPiAgICAgIHwgICAgICAgXn5+fn5+DQo+DQo+VGhpcyBoZWxw
cyB3aXRoIHRoZSBvbmdvaW5nIGVmZm9ydHMgdG8gZ2xvYmFsbHkgZW5hYmxlIC1XYXJyYXktYm91
bmRzLg0KPg0KPkxpbms6IGh0dHBzOi8vZ2l0aHViLmNvbS9LU1BQL2xpbnV4L2lzc3Vlcy8xMDkN
Cj5Dby1kZXZlbG9wZWQtYnk6IEtlZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPg0KPlNp
Z25lZC1vZmYtYnk6IEtlZXMgQ29vayA8a2Vlc2Nvb2tAY2hyb21pdW0ub3JnPg0KPlNpZ25lZC1v
ZmYtYnk6IEd1c3Rhdm8gQS4gUi4gU2lsdmEgPGd1c3Rhdm9hcnNAa2VybmVsLm9yZz4NCj4tLS0N
Cj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfY29tbW9uLmMgfCAxNiAr
KysrKysrLS0tLS0tLS0tDQo+IDEgZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDkgZGVs
ZXRpb25zKC0pDQo+DQpUZXN0ZWQtYnk6IERhdmUgU3dpdHplciA8ZGF2aWQuc3dpdHplckBpbnRl
bC5jb20+DQogDQo=
