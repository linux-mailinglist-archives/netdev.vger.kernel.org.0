Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13F9133995A
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 22:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235359AbhCLV4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 16:56:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:50475 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235357AbhCLVzs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 12 Mar 2021 16:55:48 -0500
IronPort-SDR: izuwndOuxg3boUcTjBE84jAPMJJn/ZD/d0lK/WaftCL7rKg/6yVxwBxi9C2w/7yGSiP3tdTJQV
 E1EFCduWDNYQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9921"; a="208741730"
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="txt'?scan'208";a="208741730"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Mar 2021 13:55:45 -0800
IronPort-SDR: j0WlYwx6Xr+g8y4s3ilGRBm3V8n5Wc4BNSVlXE8w3eImexUFxa7vWgYuQdgHaKMyDAAu69if9+
 3lBYhTCHF52g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,244,1610438400"; 
   d="txt'?scan'208";a="600730262"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by fmsmga006.fm.intel.com with ESMTP; 12 Mar 2021 13:55:44 -0800
Received: from orsmsx609.amr.corp.intel.com (10.22.229.22) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 13:55:43 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX609.amr.corp.intel.com (10.22.229.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 12 Mar 2021 13:55:43 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 12 Mar 2021 13:55:43 -0800
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 12 Mar 2021 13:55:43 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZT6HRzHhzDqK3q+VYTt490O6vR3dGAlv7WcNIZmO/Q/llM9LQozkcW9AolwIL7otEGZ+ocOosx5tjNhzbJRBtE5UBKWt/8mUDBDtbsOb9E+a8jZZ1Gy6oeXC6sU9VVUwaknQQWvqZocnld43nBwDkpC4IGtE5EFWlmPdvsIm1LJLmfCFW0ZulFD9TsDy4tqODhTa1S3/O2I9+EHMlxtNm87wLUs2EJ2xc/9+q3R0Qu/CWC8vPUHR+KJhhcICbCw6ngZ39vW6uU7ZEJ+zi5VqqD9XOZiOD8+cwFXvY5sBdtxYJ1MM3lGHKYkXF4kaAbfSVXaitnQGcfS9M3jc/PzE1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T+XQSGwTPSW7WD/2PuJxDfSj3YzP/RjVx2UW8ZttZ0=;
 b=k6j6HofS8dMVhuDqq5Gu9iPMa6Ugn4+kzeEBioq88gtQjYlZ1KOdyQpaYZ9ni3GiKPciwU970ra4BvGxx7QzKAfHTiYXpWdZTC+OY9CP3uIIpj8kRxtxxKDXkZbpq3M+mSlP+n51bkrW4/bEuJIwcu9c95fd5e7UTMQijtXtE26pfgDdvVaxGtCGjj6s48geSx/3nveAQlaoXVLNoSbsNr25+ts/RYcFW/5SoNnI5i4+sqDDYp8sYC8GuTDoxioYQMI4+o/SO2I2MtD32tGFSRHN14OyL3MH5Vtnrq+h//YHQv40QGqXCl1wYpymFD+P+kCCW3I1ncFuFz2XRO/vgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9T+XQSGwTPSW7WD/2PuJxDfSj3YzP/RjVx2UW8ZttZ0=;
 b=o6zFcbl4fK+0giTsequKGWTvj1m/EZYo90N5Fxp+H7DFbGbU9qfka6ksYb1ewqjChiPVReAx+KCDF46+/+bd+BBn83hXt2uwUobIabd0grvaQeTjCLBYovAYd/f5gFrTvkPCfdKGWNoC4Vyv7NcXM8Qr2byyVMWsLUpo2HoJmmE=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by BYAPR11MB3365.namprd11.prod.outlook.com (2603:10b6:a03:7e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Fri, 12 Mar
 2021 21:55:41 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::e47d:c2cb:fe53:e0e6%4]) with mapi id 15.20.3890.042; Fri, 12 Mar 2021
 21:55:41 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        "Pierre-Louis Bossart" <pierre-louis.bossart@linux.intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
Subject: RE: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Topic: [PATCH v10 00/20] dlb: introduce DLB device driver
Thread-Index: AQHW/9Zt8wdlPnXnkESxoD5/CU9Koap9GIKAgAMHmACAAN/QcA==
Date:   Fri, 12 Mar 2021 21:55:40 +0000
Message-ID: <BYAPR11MB30950965A223EDE5414EAE08D96F9@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210210175423.1873-1-mike.ximing.chen@intel.com>
 <YEiLI8fGoa9DoCnF@kroah.com>
 <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
In-Reply-To: <CAPcyv4gCMjoDCc2azLEc8QC5mVhdKeLibic9gj4Lm=Xwpft9ZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7c6278cb-8217-4a9d-7d7d-08d8e5a19429
x-ms-traffictypediagnostic: BYAPR11MB3365:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3365756B8A8037E9EEF45F83D96F9@BYAPR11MB3365.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: H1QFehiuedlIfagVhBE/wUzJZpH52xKuXEEDJNr+GGAB5s36UMcnWgy7gythrt2VRl6F26khaZCt/ar29XWBoQpJkV+8cWMUxB09JiHla3bX9qNv1wh+lYYgxjs2EaHMPICuPjtwEDfaO9mMHS/YubH6VyjB/IKO+ZnN4qT3HuJUYe/qay2jUTrn9er3ZvCASDUAl1nGfAoEq1Sgw1wgWll1yRZDmbuygOimbJUi4+ptP86o+UJxvRF5tsZClYj3R881F72EFsGFfc9zUWixGI7fq1avxcMjeSf8OGqZr8me9Pmet/GmOHew1feeGs9WH8zCpAADkloN6dIkt6atVpG1pJNR71DanJRFwqoTiBtxUChDrMs0Fpojt7xNfKdH7zWitHJ6MH3ILhwolHVUntmzz5kW6Fh9iwKMFbMst4ZIzustiB75QruOGvBGWBfwMRJ0yzDbdmhiwzEj5lPtudOieCJQFQEAUwHWo4QTsDn39WMcs3MOXqu2ZJ3Unsn3SmYmzkE2p0dtRIVayTz3yw3MtWve+CXS6QJ/JrWggNK9I28hyKuSdTyDi5UzIuc1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(376002)(136003)(2906002)(83380400001)(7696005)(86362001)(99936003)(33656002)(76116006)(5660300002)(64756008)(478600001)(6506007)(186003)(52536014)(66616009)(316002)(26005)(66556008)(8936002)(71200400001)(66446008)(53546011)(9686003)(55016002)(4326008)(8676002)(110136005)(54906003)(66476007)(66946007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bVdFLyt6QUJXbGN1QlNRSkYrZ0xkdHNZZ0M3bDMwVytVU1N2L2szRjJVOGlW?=
 =?utf-8?B?TURnZUhzRTd5OVpCbXhPamNkREVqbFRMZlZPM3dVMjgwcUJwOGVMR01WUXlv?=
 =?utf-8?B?WUVnQmhIOERzZlp4V1pOMGV5SE5zTWpCeDZudmdvWWNRdGxIVVc3dVhFdmlM?=
 =?utf-8?B?R3ZOUnFKSFN2bDhGVzloZytRemhFM1FtNjNFZ1VQa0pzdStjLy91aFJGRU5m?=
 =?utf-8?B?UU9XbGlDdmp0TkJIN0FmRXNzZ2JFanpBODdwdlNPNVVyVTk5K3VkVnJoNFZh?=
 =?utf-8?B?L0JIbi9VeTJjU0FiZXk5VE00UWIySlo5SHYybnk0eDhkbTZFODRkcUZUdnBJ?=
 =?utf-8?B?NUdmbFFTelZ0MzVhWjcwYkZiZ3JJL0hUaFZaQ3pBRlpMdE12Y2pNRjZ1ZDZx?=
 =?utf-8?B?dG1WSGsvTWJmTkpvd0Z2Z25FVVJRMU1WbXNlVVRhcHRhT2ZiT204RHlQenBm?=
 =?utf-8?B?RGtmUmN4bGR3TkhmUVJ4VzhrOW92SG9zeFo1bXlxeEtRMitGQjdIQW4rclF3?=
 =?utf-8?B?ZnVQaCtUNVN4MTF2QjNZTVlRdXduN0Q4VFhqMXlvTXZxT2tnelF6WjdOV0wx?=
 =?utf-8?B?eWtYVjVzeHFlR1lZeVc3MVlKOW5GZHBNUkRnRVROdWlGSGVIZjFyZXRaUHdW?=
 =?utf-8?B?dkdCem9nT0tmcDU0QjhqZlQvZGp5ZjVic3lxalN4Q3U2bVUraHM4V2NyOSs3?=
 =?utf-8?B?cWR0TlordUJlcHNnSVpPWitpWFVjellndnhlVWg4MWJQWEs0elZuOUlVakIz?=
 =?utf-8?B?TVMyWHFKdTBTM2RiQ0V6akJmd21hT2ZVcU9FM3lZK0gxUkZtNm5tVGhxcHNj?=
 =?utf-8?B?VnZ1TUR4UTZIWnVaMWw2RTFLWmdzemhXZFlZU0xLOWpEVmdKUWNGS3owVjFX?=
 =?utf-8?B?cVI4cE10ekRmbXc0THIvV3dqTE5aUFlsYVlTVU9uYVJFRG5JUFI2cUphclRu?=
 =?utf-8?B?TGxUU2RyZ1F2Wm5SdVFPSHFUSDlTblFnSWtzT3NKbUJHNW9NS1R2TWE5ZGRj?=
 =?utf-8?B?MXAvdytUcWFwR0JuNVA2dTJNbndDWUVqSXlKVWFBUHpEUW5ycXUvbkF6a3VJ?=
 =?utf-8?B?dUJWbkpwM0drUjVGWGNjWjBweWc5MHMxSnFQU010aFVYTWw4OE9XcU9jYW1W?=
 =?utf-8?B?NGlCZmJwWjBzTDRyREhUaUx6VTlERXUxRzBOVDBVOWpDbjFMeUNWVWJ3bEV6?=
 =?utf-8?B?akV5aVg5QWQ4SDkwQzllMkFFbGtlTGwwUGlTSkRUNndGbEdtb3o3ekFqeWRj?=
 =?utf-8?B?dEUzQTFUR0k3QjUxaGJIa2JkbDdtd205b2ZKVmtWZXU1c1h3M1JDSzNjY2JB?=
 =?utf-8?B?UXBWdGlkUlVoTURmcmNsYmhuejFRWFM4U2sydzZxVXhSNm01KzJISWdBUnZ6?=
 =?utf-8?B?VWNCamtUaHNkSlNzblYyL0FiaHJzdXVxZVRWRkxmWk1ZdXFiZVBnWVpLTUZz?=
 =?utf-8?B?d1BIWVJ6RUcwMytDQmRVWmtXQ3lmK1lDWVI5OVdjTXJrRUVmd2c1bmJzZ2dp?=
 =?utf-8?B?VWZ6KzN5OWdjSkl1eDVhS0ZobFpvT2FMK0NMMTJMdHlrYkRVQVU2cEdoeU5q?=
 =?utf-8?B?dUhFbXZmdklnS1ZVdkZwWTFtWnNtbU5SczFpcS9mbUgxcWZTbFpDN0dYS0Nt?=
 =?utf-8?B?U0RDZldZSXQvOUZmNzk4YlJ1ZTg0b0ZHOHNwejc2eDFZZEJZSW41Qmp4ZldV?=
 =?utf-8?B?KzV1VlJDbE5uN2RPanUyRnJpU0RPTXkyT2FRbzNnUU9XSzJxbnpXbEpZYi9K?=
 =?utf-8?Q?tJkJk2VnzzLU2PDZ/Ry1HWVbdTt/aQraap0/Y6p?=
Content-Type: multipart/mixed;
        boundary="_002_BYAPR11MB30950965A223EDE5414EAE08D96F9BYAPR11MB3095namp_"
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7c6278cb-8217-4a9d-7d7d-08d8e5a19429
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Mar 2021 21:55:40.9748
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YUG0xSM4VDI3r4duAyc0K+t4UUD0gfNdd7qm0LYzpXwGyisOrK5h7rqnKcglAccP8mivVt6WClwZNoXmjQXPUrHWEFZWvuX2N9i20tFfs8I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3365
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--_002_BYAPR11MB30950965A223EDE5414EAE08D96F9BYAPR11MB3095namp_
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuIFdpbGxpYW1zIDxk
YW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IFNlbnQ6IEZyaWRheSwgTWFyY2ggMTIsIDIwMjEg
MjoxOCBBTQ0KPiBUbzogR3JlZyBLSCA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+DQo+IENj
OiBDaGVuLCBNaWtlIFhpbWluZyA8bWlrZS54aW1pbmcuY2hlbkBpbnRlbC5jb20+OyBOZXRkZXYg
PG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyBEYXZpZCBNaWxsZXINCj4gPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+OyBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPjsgQXJuZCBCZXJnbWFubiA8
YXJuZEBhcm5kYi5kZT47IFBpZXJyZS0NCj4gTG91aXMgQm9zc2FydCA8cGllcnJlLWxvdWlzLmJv
c3NhcnRAbGludXguaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMCAwMC8yMF0g
ZGxiOiBpbnRyb2R1Y2UgRExCIGRldmljZSBkcml2ZXINCj4gDQo+IE9uIFdlZCwgTWFyIDEwLCAy
MDIxIGF0IDE6MDIgQU0gR3JlZyBLSCA8Z3JlZ2toQGxpbnV4Zm91bmRhdGlvbi5vcmc+IHdyb3Rl
Og0KPiA+DQo+ID4gT24gV2VkLCBGZWIgMTAsIDIwMjEgYXQgMTE6NTQ6MDNBTSAtMDYwMCwgTWlr
ZSBYaW1pbmcgQ2hlbiB3cm90ZToNCj4gPiA+IEludGVsIERMQiBpcyBhbiBhY2NlbGVyYXRvciBm
b3IgdGhlIGV2ZW50LWRyaXZlbiBwcm9ncmFtbWluZyBtb2RlbCBvZg0KPiA+ID4gRFBESydzIEV2
ZW50IERldmljZSBMaWJyYXJ5WzJdLiBUaGUgbGlicmFyeSBpcyB1c2VkIGluIHBhY2tldCBwcm9j
ZXNzaW5nDQo+ID4gPiBwaXBlbGluZXMgdGhhdCBhcnJhbmdlIGZvciBtdWx0aS1jb3JlIHNjYWxh
YmlsaXR5LCBkeW5hbWljIGxvYWQtYmFsYW5jaW5nLA0KPiA+ID4gYW5kIHZhcmlldHkgb2YgcGFj
a2V0IGRpc3RyaWJ1dGlvbiBhbmQgc3luY2hyb25pemF0aW9uIHNjaGVtZXMNCj4gPg0KPiA+IFRo
ZSBtb3JlIHRoYXQgSSBsb29rIGF0IHRoaXMgZHJpdmVyLCB0aGUgbW9yZSBJIHRoaW5rIHRoaXMg
aXMgYSAicnVuDQo+ID4gYXJvdW5kIiB0aGUgbmV0d29ya2luZyBzdGFjay4gIFdoeSBhcmUgeW91
IGFsbCBhZGRpbmcga2VybmVsIGNvZGUgdG8NCj4gPiBzdXBwb3J0IERQREsgd2hpY2ggaXMgYW4g
b3V0LW9mLWtlcm5lbCBuZXR3b3JraW5nIHN0YWNrPyAgV2UgY2FuJ3QNCj4gPiBzdXBwb3J0IHRo
YXQgYXQgYWxsLg0KPiA+DQo+ID4gV2h5IG5vdCBqdXN0IHVzZSB0aGUgbm9ybWFsIG5ldHdvcmtp
bmcgZnVuY3Rpb25hbGl0eSBpbnN0ZWFkIG9mIHRoaXMNCj4gPiBjdXN0b20gY2hhci1kZXZpY2Ut
bm9kZS1tb25zdHJvc2l0eT8NCj4gDQo+IEhleSBHcmVnLA0KPiANCj4gSSd2ZSBjb21lIHRvIGZp
bmQgb3V0IHRoYXQgdGhpcyBkcml2ZXIgZG9lcyBub3QgYnlwYXNzIGtlcm5lbA0KPiBuZXR3b3Jr
aW5nLCBhbmQgdGhlIGtlcm5lbCBmdW5jdGlvbmFsaXR5IEkgdGhvdWdodCBpdCBieXBhc3NlZCwg
SVBDIC8NCj4gU2NoZWR1bGluZywgaXMgbm90IGV2ZW4gaW4gdGhlIHBpY3R1cmUgaW4gdGhlIG5v
bi1hY2NlbGVyYXRlZCBjYXNlLiBTbw0KPiBnaXZlbiB5b3UgYW5kIEkgYXJlIGJvdGggY29uZnVz
ZWQgYnkgdGhpcyBzdWJtaXNzaW9uIHRoYXQgdGVsbHMgbWUNCj4gdGhhdCB0aGUgcHJvYmxlbSBz
cGFjZSBuZWVkcyB0byBiZSBjbGFyaWZpZWQgYW5kIGFzc3VtcHRpb25zIG5lZWQgdG8NCj4gYmUg
ZW51bWVyYXRlZC4NCj4gDQo+ID4gV2hhdCBpcyBtaXNzaW5nIGZyb20gdG9kYXlzIGtlcm5lbCBu
ZXR3b3JraW5nIGNvZGUgdGhhdCByZXF1aXJlcyB0aGlzDQo+ID4gcnVuLWFyb3VuZD8NCj4gDQo+
IFllcywgZmlyc3QgYW5kIGZvcmVtb3N0IE1pa2UsIHdoYXQgYXJlIHRoZSBrZXJuZWwgaW5mcmFz
dHJ1Y3R1cmUgZ2Fwcw0KPiBhbmQgcGFpbiBwb2ludHMgdGhhdCBsZWQgdXAgdG8gdGhpcyBwcm9w
b3NhbD8NCg0KSGkgR3JlZy9EYW4sDQoNClNvcnJ5IGZvciB0aGUgY29uZnVzaW9uLiBUaGUgY292
ZXIgbGV0dGVyIGFuZCBkb2N1bWVudCBkaWQgbm90IGFydGljdWxhdGUgDQpjbGVhcmx5IHRoZSBw
cm9ibGVtIGJlaW5nIHNvbHZlZCBieSBETEIuIFdlIHdpbGwgdXBkYXRlIHRoZSBkb2N1bWVudCBp
bg0KdGhlIG5leHQgcmV2aXNpb24uDQoNCkluIGEgYnJpZWYgZGVzY3JpcHRpb24sIEludGVsIERM
QiBpcyBhbiBhY2NlbGVyYXRvciB0aGF0IHJlcGxhY2VzIHNoYXJlZCBtZW1vcnkNCnF1ZXVpbmcg
c3lzdGVtcy4gTGFyZ2UgbW9kZXJuIHNlcnZlci1jbGFzcyBDUFVzLCAgd2l0aCBsb2NhbCBjYWNo
ZXMNCmZvciBlYWNoIGNvcmUsIHRlbmQgdG8gaW5jdXIgY29zdGx5IGNhY2hlIG1pc3NlcywgY3Jv
c3MgY29yZSBzbm9vcHMNCmFuZCBjb250ZW50aW9ucy4gIFRoZSBpbXBhY3QgYmVjb21lcyBub3Rp
Y2VhYmxlIGF0IGhpZ2ggKG1lc3NhZ2VzL3NlYykgDQpyYXRlcywgc3VjaCBhcyBhcmUgc2VlbiBp
biBoaWdoIHRocm91Z2hwdXQgcGFja2V0IHByb2Nlc3NpbmcgYW5kIEhQQyANCmFwcGxpY2F0aW9u
cy4gRExCIGlzIHVzZWQgaW4gaGlnaCByYXRlIHBpcGVsaW5lcyB0aGF0IHJlcXVpcmUgYSB2YXJp
ZXR5IG9mIHBhY2tldA0KZGlzdHJpYnV0aW9uICYgc3luY2hyb25pemF0aW9uIHNjaGVtZXMuICBJ
dCBjYW4gYmUgbGV2ZXJhZ2VkIHRvIGFjY2VsZXJhdGUNCnVzZXIgc3BhY2UgbGlicmFyaWVzLCBz
dWNoIGFzIERQREsgZXZlbnRkZXYuIEl0IGNvdWxkIHNob3cgc2ltaWxhciBiZW5lZml0cyBpbiAN
CmZyYW1ld29ya3Mgc3VjaCBhcyBQQURBVEEgaW4gdGhlIEtlcm5lbCAtIGlmIHRoZSBtZXNzYWdp
bmcgcmF0ZSBpcyBzdWZmaWNpZW50bHkNCmhpZ2guIEFzIGNhbiBiZSBzZWVuIGluIHRoZSBmb2xs
b3dpbmcgZGlhZ3JhbSwgIERMQiBvcGVyYXRpb25zIGNvbWUgaW50byB0aGUgDQpwaWN0dXJlIG9u
bHkgYWZ0ZXIgcGFja2V0cyBhcmUgcmVjZWl2ZWQgYnkgUnggY29yZSBmcm9tIHRoZSBuZXR3b3Jr
aW5nIA0KZGV2aWNlcy4gV0NzIGFyZSB0aGUgd29ya2VyIGNvcmVzIHdoaWNoIHByb2Nlc3MgcGFj
a2V0cyBkaXN0cmlidXRlZCBieSBETEIuIA0KKEluIGNhc2UgdGhlIGRpYWdyYW0gZ2V0cyBtaXMt
Zm9ybWF0dGVkLCAgcGxlYXNlIHNlZSBhdHRhY2hlZCBmaWxlKS4NCg0KDQogICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICBXQzEgICAgICAgICAgICAgIFdDNA0KICstLS0tLSsgICArLS0tLSsg
ICArLS0tKyAgLyAgICAgIFwgICstLS0rICAvICAgICAgXCAgKy0tLSsgICArLS0tLSsgICArLS0t
LS0rDQogfE5JQyAgfCAgIHxSeCAgfCAgIHxETEJ8IC8gICAgICAgIFwgfERMQnwgLyAgICAgICAg
XCB8RExCfCAgIHxUeCAgfCAgIHxOSUMgIHwNCiB8UG9ydHN8LS0tfENvcmV8LS0tfCAgIHwtLS0t
LVdDMi0tLS18ICAgfC0tLS0tV0M1LS0tLXwgICB8LS0tfENvcmV8LS0tfFBvcnRzfA0KICstLS0t
LSsgICAtLS0tLSsgICArLS0tKyBcICAgICAgICAvICstLS0rIFwgICAgICAgIC8gKy0tLSsgICAr
LS0tLSsgICAtLS0tLS0rDQogICAgICAgICAgICAgICAgICAgICAgICAgICBcICAgICAgLyAgICAg
ICAgIFwgICAgICAvDQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICBXQzMgICAgICAgICAg
ICAgIFdDNiANCg0KQXQgaXRzIGhlYXJ0IERMQiBjb25zaXN0cyBvZiByZXNvdXJjZXMgdGhhbiBj
YW4gYmUgYXNzaWduZWQgdG8gDQpWREVWcy9hcHBsaWNhdGlvbnMgaW4gYSBmbGV4aWJsZSBtYW5u
ZXIsIHN1Y2ggYXMgcG9ydHMsIHF1ZXVlcywgY3JlZGl0cyB0byB1c2UNCnF1ZXVlcywgc2VxdWVu
Y2UgbnVtYmVycywgZXRjLiBXZSBzdXBwb3J0IHVwIHRvIDE2LzMyIFZGL1ZERVZzIChkZXBlbmRp
bmcNCm9uIHZlcnNpb24pIHdpdGggU1JJT1YgYW5kIFNJT1YuIFJvbGUgb2YgdGhlIGtlcm5lbCBk
cml2ZXIgaW5jbHVkZXMgVkRFViANCkNvbXBvc2l0aW9uICh2ZGNtIG1vZHVsZSksIGZ1bmN0aW9u
YWwgbGV2ZWwgcmVzZXQsIGxpdmUgbWlncmF0aW9uLCBlcnJvciANCmhhbmRsaW5nLCBwb3dlciBt
YW5hZ2VtZW50LCBhbmQgZXRjLi4NCg0KVGhhbmtzDQpNaWtlDQo=

--_002_BYAPR11MB30950965A223EDE5414EAE08D96F9BYAPR11MB3095namp_
Content-Type: text/plain; name="dlb_drawing.txt"
Content-Description: dlb_drawing.txt
Content-Disposition: attachment; filename="dlb_drawing.txt"; size=542;
	creation-date="Fri, 12 Mar 2021 21:49:10 GMT";
	modification-date="Fri, 12 Mar 2021 21:38:07 GMT"
Content-Transfer-Encoding: base64

CgoKCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIFdDMSAgICAgICAgICAgICAgV0M0ICAg
ICAgICAgIAogKy0tLS0tKyAgICstLS0tKyAgICstLS0rICAvICAgICAgXCAgKy0tLSsgIC8gICAg
ICBcICArLS0tKyAgICstLS0tKyAgICstLS0tLSsKIHxOSUMgIHwgICB8UnggIHwgICB8RExCfCAv
ICAgICAgICBcIHxETEJ8IC8gICAgICAgIFwgfERMQnwgICB8VHggIHwgICB8TklDICB8CiB8UG9y
dHN8LS0tfENvcmV8LS0tfCAgIHwtLS0tLVdDMi0tLS18ICAgfC0tLS0tV0M1LS0tLXwgICB8LS0t
fENvcmV8LS0tfFBvcnRzfCAKICstLS0tLSsgICAtLS0tLSsgICArLS0tKyBcICAgICAgICAvICst
LS0rIFwgICAgICAgIC8gKy0tLSsgICArLS0tLSsgICAtLS0tLS0rCiAgICAgICAgICAgICAgICAg
ICAgICAgICAgIFwgICAgICAvICAgICAgICAgXCAgICAgIC8gICAgICAgICAgICAgICAgICAgICAg
ICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgV0MzICAgICAgICAgICAgICBXQzYg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIAo=

--_002_BYAPR11MB30950965A223EDE5414EAE08D96F9BYAPR11MB3095namp_--
