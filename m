Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B94A1316E3A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 19:14:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233668AbhBJSOF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 13:14:05 -0500
Received: from mga11.intel.com ([192.55.52.93]:32475 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232236AbhBJSKx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 13:10:53 -0500
IronPort-SDR: GcPSOauhzklt6j7aj4/RUVrJ3m00K5127U96jbXBziYfb4g78FMVIt7GFwB6Wh47AhQ5n9CBv9
 oPETxp1YhD3Q==
X-IronPort-AV: E=McAfee;i="6000,8403,9891"; a="178617558"
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="178617558"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2021 10:09:58 -0800
IronPort-SDR: pYU3y2mqw7/9qTcqBumlqRxHULgDNaUvWaPEyaERcQL6DtsXPW54iZrBf+m6ixrKrkIhE1/p1M
 XNkO956gNejg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,168,1610438400"; 
   d="scan'208";a="578500053"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by orsmga005.jf.intel.com with ESMTP; 10 Feb 2021 10:09:57 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Wed, 10 Feb 2021 10:09:57 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Wed, 10 Feb 2021 10:09:57 -0800
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (104.47.46.51) by
 edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Wed, 10 Feb 2021 10:09:56 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y7WPEjNgT81b0JDUVShvc2MuYzfiwzIVvzABm9YM8FSMXtk/idnSWsnoCRY0KbMRxWpnNsNxaPfTB3zd3UySqu5bxHTZJHes4DQvEDf6IKRPCfpfvvePgJ+hxikHJkm2HKejuCsiSYgzp1CIFFP48y3eeLQtSHBAvwSFKhDhtyngeit77rSYcq1BQ+1bOAxS25TXd7wxU1HNyoM1PL8MJX5rAm8mDnXIfadhqo7Amx9pUtugAwALlwUq+aIFhwjv1OKfL6VVyXYtrBTaw81Q8ODB6+fFH2I+DnUUGm8gFe28Y+ww4tOcvyiPND17NsVD5ZdGlR1zY5XOBzMt5GQ2PA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yxqutlc9ycr6uY9cQb7K5nAK/Tx+2Sq78NtFMP/3js=;
 b=h0X/XhjH/Q0OCw/uQLN+vqkdxwxw0WUpIVkvFvUxaOwlpPQ/3F0+37PRd3wlmvRB4itnkrue+8wcqT/dKmBT0r71Wvkjl7Q1iXsvbhw1c3kMx9NDu9YKPHHYZ+fTPUehHpVAIG8l692z3cilKH4Pco1oF0roHBPbjE0BpxV0l3RWHTiGQ4LyBbF0jrsFq5v4QiFHgdjpofcPgfhIpPmHUeifcvZsLlwZ2hWa+VWEX/lxh/5pqFehCJfoMjpc1e26kE9DdG7zaWxlfTGreA1SNLXFWyuUHBGCy4nfzO90Ul4eX2OwgW9VwMURy9to6+ncNnqVLu9u8CXhorPT7QHoYQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2yxqutlc9ycr6uY9cQb7K5nAK/Tx+2Sq78NtFMP/3js=;
 b=G5pU15w6uUQ/QM3Q6o3423na9duzgxexATR/adxugAEwFM+whGO8amrOI9lRWcXT8shg5CsfvwSJjpV7Q5sooFR3FszrAbwAjB2T/8TpyUqKGOV9ORPwmAziUOoGokj1ATF4zRhRTqZl5UlJWIZsRz7VaQUwI+0Ppm9etpk4BUo=
Received: from BYAPR11MB3095.namprd11.prod.outlook.com (2603:10b6:a03:91::26)
 by SJ0PR11MB5038.namprd11.prod.outlook.com (2603:10b6:a03:2d8::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.27; Wed, 10 Feb
 2021 18:09:55 +0000
Received: from BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::9dcf:f45f:7949:aa3f]) by BYAPR11MB3095.namprd11.prod.outlook.com
 ([fe80::9dcf:f45f:7949:aa3f%6]) with mapi id 15.20.3825.020; Wed, 10 Feb 2021
 18:09:55 +0000
From:   "Chen, Mike Ximing" <mike.ximing.chen@intel.com>
To:     "Williams, Dan J" <dan.j.williams@intel.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: RE: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Topic: [PATCH v10 01/20] dlb: add skeleton for DLB driver
Thread-Index: AQHW9P+hri3YEhHn10KqfTIlfsDxHqpP5y6AgAAwW4CAAawUUA==
Date:   Wed, 10 Feb 2021 18:09:55 +0000
Message-ID: <BYAPR11MB30954B40E64D8055AC9B0E65D98D9@BYAPR11MB3095.namprd11.prod.outlook.com>
References: <20210127225641.1342-1-mike.ximing.chen@intel.com>
 <20210127225641.1342-2-mike.ximing.chen@intel.com>
 <YCKP5ZUL1/wMzmf4@kroah.com>
 <CAPcyv4hC2dJGAXbG2ogO=2THuDUHjgYekkNy4K_zwEmQcXLcjA@mail.gmail.com>
In-Reply-To: <CAPcyv4hC2dJGAXbG2ogO=2THuDUHjgYekkNy4K_zwEmQcXLcjA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [69.141.163.46]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d9bea2d9-4df6-486f-8eb8-08d8cdef1207
x-ms-traffictypediagnostic: SJ0PR11MB5038:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SJ0PR11MB50381D56499D1CDC0A5323D4D98D9@SJ0PR11MB5038.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VAuRby8NSnLHxwdgswgX2z8UsMUCVn41Fhot3q+LwU4ZDd3f3oMFdjUPNULuYwF9k3xiMH03yCRyOX96zvZKjVKSFtR41APiAgskMTg2FZTAFPUOtw4MR9y3SxjWFALwuO3sWq24GJksitOgES0/SNJWBuuZoOe13GItSyajSihCPTSUL9S/Ai17WMkbDd5uwJJ7yQWsdS7qhBBJugSRQO4shm7HKE0ib3a7HfGLCxbLHP4b7xz5GJvdmeTlp01sqfrIaeYPo8/jseJnirdJcThS5ZzZnT0HmHsxuSrpmwhhMYEWvnj9O/XQMDDcfeeOI/cRex4WqUXmf7wTsIJm9WMac+gcCG1gQOp+6ONmBNNTnfR4bVuCU+lzF8H3yCETo94cvY6/p26g5DHIDf6v1KVmtNDg4ExWKN6FQngfAnnn+0tmRDsNvyiV1TRPTkq6BEWWDiyxdK/OimC2kPvoeScfy62hR9D2xJ0XPw4TzoFtYtIdgsoZw718FTZOpf9luGpsaXFnSSl6iC24g6p7kg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3095.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39850400004)(136003)(396003)(346002)(366004)(33656002)(54906003)(110136005)(52536014)(4326008)(316002)(26005)(86362001)(71200400001)(53546011)(186003)(7696005)(9686003)(55016002)(6506007)(5660300002)(66556008)(66476007)(66446008)(64756008)(8936002)(76116006)(2906002)(83380400001)(66946007)(8676002)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?V2doMmIxWCtoUXFhNC9KbkpzZ1NTb3NzbDY2UWhNQUt5RFV0K0ZkUmdXM2JK?=
 =?utf-8?B?NE16b1FkSHc2NFJYVzg3d2RLUzd3bVVaNllkYm4zb3BPenlNeVJHOWdvMmsy?=
 =?utf-8?B?ZjB1akMwY0RabnR4Zlc4ekVxTG84SFhldUl1NVF5a3ZDRjVUTHN3TTZYZWRS?=
 =?utf-8?B?aWJlYjZqWmwreXpMelIzdkJGeGNXdTdEQWEzMU9CLzE4ZlNKc3pqRDBxcC9B?=
 =?utf-8?B?L1FNeHZJeUk0WVlRNUkvdVUyUGNHSHRFR3FIWEoxaXgvTzBGQnNPZjExTFIw?=
 =?utf-8?B?bVlmZ1RVd1lyaHB1emZUdGNIZnRpRmJMVHpPeW5BTU1qUkk0R2VPeEJuTkpu?=
 =?utf-8?B?UjJuY0NZMVQ0UDVWL0s0NUJGNmYxaXhzQWQvVTRCZzZ3Y1psaUpwZkZiUFAx?=
 =?utf-8?B?UXE3MEMzZUtFaFpORlY3bFUzcG9DWE4yMktXQ1dJTUZIdHVmbDdpY3pyekJZ?=
 =?utf-8?B?L0EwdHRzZXJ6ajBKell2TG81cExCY0JhZ1R0Y1dNYnllT1o3SXRWQnlzbVFx?=
 =?utf-8?B?K3F5a0JiR1N4ZkNEZk1IcUNKeDkyMGRPcElkUlAzSmxyNmJpQjRXUngxNUlR?=
 =?utf-8?B?bjVFQldoR243YmFCd25pbUtQTytHR25FcDhIZkR0cjBXdVVNQitOZUhtUC96?=
 =?utf-8?B?bTdqeHRTbWpGOVhFcC9FNVJmMXlrNGV6SVRTWmdrcS9Ebk1CTnZUeEl4eWox?=
 =?utf-8?B?eHZMRDFPQ3MrVVRaUzUySVpDRHIva2l1anh6bTVUTDF4RHBYaDV0Mkw4RmZj?=
 =?utf-8?B?bDR4aTA4K0NwU1EzWjVqYU1FR3RhUVZnL24wV0p2czV1dXR1NFVGTDhWcGJD?=
 =?utf-8?B?WDhMeUNDRktNZUpYYVVUc2FEUHZWQXRML2NXZDZKMVZ2MEVyd3paVWVIUEww?=
 =?utf-8?B?VjlGWUNVY01hK2JFcTBOSzBGbFpHNmVVQURQWWd1VnFTNlZFbzhnZWtwM2dT?=
 =?utf-8?B?SmNJSTZuZFJTVzhqL0pITGErQVBNcUpCZFA2MkVCMWQvbnJpSVptQUw4QW5O?=
 =?utf-8?B?MzFxajZ3cUpWN240bUZlZHdvYjg4L0U0dGlIOFB1cGpxem83NkxqNG5hMi8x?=
 =?utf-8?B?bzZXTVZLbjdxaW5KTVB1WnJBYUJDRitOT044UVByL3E5TFVEQ3NGajhuL2JE?=
 =?utf-8?B?bzlydHdlMUpVaUo2d08zQ01NajB0THRtV0s5UUtXVmFTTVFycmJzUXNjRFBK?=
 =?utf-8?B?Tmdzb0p4bFJZQ2VVc0s4SXpCZFgvWUc4b1l3MjdpQXdZc2Z4M1VJcSt1QTZS?=
 =?utf-8?B?cHkvVktucjZteDFLcE9PMHFPQTRsb1dDSVlpY2hsSllkM284SWJDZ2xqaHVF?=
 =?utf-8?B?WVlMbjFPTWNKUWQxb2VFdk5ZYk9mMjc3WWN4N0ZPUEw0S0VJK2YxZXowOXIw?=
 =?utf-8?B?YWhSQ1pXM3FtS3ljcDJJM05pZEFPWWQ0SFA2d0lUYzdPUzJUY3FQUGlXc2dZ?=
 =?utf-8?B?UmR3M3dzSDBock1mdjdPNTIrQ1pqdU1MeTUzb3JBVXlXVlVEZU0rdDNKY1lB?=
 =?utf-8?B?Q2JXZU9GSVIrU2x0N1k3b2gwangwT3UvZTJSc1gwbjRSTVNuMWZjM2xzSUxt?=
 =?utf-8?B?SWNyYTJPcTFiN1FBNkJOUmw3OHMzWkFtUldRbUdXaXZDMnh6Rkp1TjBxdDVT?=
 =?utf-8?B?Ui9CdkxpZ3F3TDBEc3ozSmtoRDhGaVpha1B4SXltMmJTaWtNcUdCMGllV2kr?=
 =?utf-8?B?cHJzc2IvVi9jUlVRYlpvT09OR0ZSSlk2YSs1WEVGeU4wZE9YbUU0RXRCeitq?=
 =?utf-8?Q?pLE/KVghm4D+CmbL1IjdyaGxh8BkG5NfLsuZNGV?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3095.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d9bea2d9-4df6-486f-8eb8-08d8cdef1207
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Feb 2021 18:09:55.4589
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Jp0Rqzm5gcf3OcNqUtPFRWpUGfvLwTaLrSClqPBHrvqogu1PNs+zwBYOIlel59wk/oqMWJubZGRO5+P73khKfUhSQnW13H0D8M/WAq7ZUWA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB5038
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogRGFuIFdpbGxpYW1zIDxk
YW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+IFNlbnQ6IFR1ZXNkYXksIEZlYnJ1YXJ5IDksIDIw
MjEgMTE6MzAgQU0NCj4gVG86IEdyZWcgS0ggPGdyZWdraEBsaW51eGZvdW5kYXRpb24ub3JnPg0K
PiBDYzogQ2hlbiwgTWlrZSBYaW1pbmcgPG1pa2UueGltaW5nLmNoZW5AaW50ZWwuY29tPjsgTGlu
dXggS2VybmVsIE1haWxpbmcgTGlzdA0KPiA8bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47
IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+OyBQaWVycmUtTG91aXMNCj4gQm9zc2FydCA8
cGllcnJlLWxvdWlzLmJvc3NhcnRAbGludXguaW50ZWwuY29tPjsgR2FnZSBFYWRzIDxnYWdlLmVh
ZHNAaW50ZWwuY29tPg0KPiBTdWJqZWN0OiBSZTogW1BBVENIIHYxMCAwMS8yMF0gZGxiOiBhZGQg
c2tlbGV0b24gZm9yIERMQiBkcml2ZXINCj4gDQo+IE9uIFR1ZSwgRmViIDksIDIwMjEgYXQgNToz
NiBBTSBHcmVnIEtIIDxncmVna2hAbGludXhmb3VuZGF0aW9uLm9yZz4gd3JvdGU6DQo+ID4NCj4g
PiBPbiBXZWQsIEphbiAyNywgMjAyMSBhdCAwNDo1NjoyMlBNIC0wNjAwLCBNaWtlIFhpbWluZyBD
aGVuIHdyb3RlOg0KPiA+ID4gQWRkIGJhc2ljIGRyaXZlciBmdW5jdGlvbmFsaXR5IChsb2FkLCB1
bmxvYWQsIHByb2JlLCBhbmQgcmVtb3ZlIGNhbGxiYWNrcykNCj4gPiA+IGZvciB0aGUgRExCIGRy
aXZlci4NCj4gPiA+DQo+ID4gPiBBZGQgZG9jdW1lbnRhdGlvbiB3aGljaCBkZXNjcmliZXMgaW4g
ZGV0YWlsIHRoZSBoYXJkd2FyZSwgdGhlIHVzZXINCj4gPiA+IGludGVyZmFjZSwgZGV2aWNlIGlu
dGVycnVwdHMsIGFuZCB0aGUgZHJpdmVyJ3MgcG93ZXItbWFuYWdlbWVudCBzdHJhdGVneS4NCj4g
PiA+IEZvciBtb3JlIGRldGFpbHMgYWJvdXQgdGhlIGRyaXZlciBzZWUgdGhlIGRvY3VtZW50YXRp
b24gaW4gdGhlIHBhdGNoLg0KPiA+ID4NCj4gPiA+IEFkZCBhIERMQiBlbnRyeSB0byB0aGUgTUFJ
TlRBSU5FUlMgZmlsZS4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBHYWdlIEVhZHMgPGdh
Z2UuZWFkc0BpbnRlbC5jb20+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBNaWtlIFhpbWluZyBDaGVu
IDxtaWtlLnhpbWluZy5jaGVuQGludGVsLmNvbT4NCj4gPiA+IFJldmlld2VkLWJ5OiBNYWdudXMg
S2FybHNzb24gPG1hZ251cy5rYXJsc3NvbkBpbnRlbC5jb20+DQo+ID4gPiBSZXZpZXdlZC1ieTog
RGFuIFdpbGxpYW1zIDxkYW4uai53aWxsaWFtc0BpbnRlbC5jb20+DQo+ID4gPiAtLS0NCj4gPiA+
ICBEb2N1bWVudGF0aW9uL21pc2MtZGV2aWNlcy9kbGIucnN0ICAgfCAyNTkgKysrKysrKysrKysr
KysrKysrKysrKysrKysrDQo+ID4gPiAgRG9jdW1lbnRhdGlvbi9taXNjLWRldmljZXMvaW5kZXgu
cnN0IHwgICAxICsNCj4gPiA+ICBNQUlOVEFJTkVSUyAgICAgICAgICAgICAgICAgICAgICAgICAg
fCAgIDggKw0KPiA+ID4gIGRyaXZlcnMvbWlzYy9LY29uZmlnICAgICAgICAgICAgICAgICB8ICAg
MSArDQo+ID4gPiAgZHJpdmVycy9taXNjL01ha2VmaWxlICAgICAgICAgICAgICAgIHwgICAxICsN
Cj4gPiA+ICBkcml2ZXJzL21pc2MvZGxiL0tjb25maWcgICAgICAgICAgICAgfCAgMTggKysNCj4g
PiA+ICBkcml2ZXJzL21pc2MvZGxiL01ha2VmaWxlICAgICAgICAgICAgfCAgIDkgKw0KPiA+ID4g
IGRyaXZlcnMvbWlzYy9kbGIvZGxiX2h3X3R5cGVzLmggICAgICB8ICAzMiArKysrDQo+ID4gPiAg
ZHJpdmVycy9taXNjL2RsYi9kbGJfbWFpbi5jICAgICAgICAgIHwgMTU2ICsrKysrKysrKysrKysr
KysNCj4gPiA+ICBkcml2ZXJzL21pc2MvZGxiL2RsYl9tYWluLmggICAgICAgICAgfCAgMzcgKysr
Kw0KPiA+ID4gIDEwIGZpbGVzIGNoYW5nZWQsIDUyMiBpbnNlcnRpb25zKCspDQo+ID4gPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IERvY3VtZW50YXRpb24vbWlzYy1kZXZpY2VzL2RsYi5yc3QNCj4gPiA+
ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9taXNjL2RsYi9LY29uZmlnDQo+ID4gPiAgY3Jl
YXRlIG1vZGUgMTAwNjQ0IGRyaXZlcnMvbWlzYy9kbGIvTWFrZWZpbGUNCj4gPiA+ICBjcmVhdGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9taXNjL2RsYi9kbGJfaHdfdHlwZXMuaA0KPiA+ID4gIGNyZWF0
ZSBtb2RlIDEwMDY0NCBkcml2ZXJzL21pc2MvZGxiL2RsYl9tYWluLmMNCj4gPiA+ICBjcmVhdGUg
bW9kZSAxMDA2NDQgZHJpdmVycy9taXNjL2RsYi9kbGJfbWFpbi5oDQo+ID4gPg0KPiA+ID4gZGlm
ZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vbWlzYy1kZXZpY2VzL2RsYi5yc3QgYi9Eb2N1bWVudGF0
aW9uL21pc2MtDQo+IGRldmljZXMvZGxiLnJzdA0KPiA+ID4gbmV3IGZpbGUgbW9kZSAxMDA2NDQN
Cj4gPiA+IGluZGV4IDAwMDAwMDAwMDAwMC4uYWE3OWJlMDdlZTQ5DQo+ID4gPiAtLS0gL2Rldi9u
dWxsDQo+ID4gPiArKysgYi9Eb2N1bWVudGF0aW9uL21pc2MtZGV2aWNlcy9kbGIucnN0DQo+ID4g
PiBAQCAtMCwwICsxLDI1OSBAQA0KPiA+ID4gKy4uIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBH
UEwtMi4wLW9ubHkNCj4gPiA+ICsNCj4gPiA+ICs9PT09PT09PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09DQo+ID4gPiArSW50ZWwoUikgRHluYW1pYyBMb2FkIEJhbGFuY2VyIE92
ZXJ2aWV3DQo+ID4gPiArPT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09
PQ0KPiA+ID4gKw0KPiA+ID4gKzpBdXRob3JzOiBHYWdlIEVhZHMgYW5kIE1pa2UgWGltaW5nIENo
ZW4NCj4gPiA+ICsNCj4gPiA+ICtDb250ZW50cw0KPiA+ID4gKz09PT09PT09DQo+ID4gPiArDQo+
ID4gPiArLSBJbnRyb2R1Y3Rpb24NCj4gPiA+ICstIFNjaGVkdWxpbmcNCj4gPiA+ICstIFF1ZXVl
IEVudHJ5DQo+ID4gPiArLSBQb3J0DQo+ID4gPiArLSBRdWV1ZQ0KPiA+ID4gKy0gQ3JlZGl0cw0K
PiA+ID4gKy0gU2NoZWR1bGluZyBEb21haW4NCj4gPiA+ICstIEludGVycnVwdHMNCj4gPiA+ICst
IFBvd2VyIE1hbmFnZW1lbnQNCj4gPiA+ICstIFVzZXIgSW50ZXJmYWNlDQo+ID4gPiArLSBSZXNl
dA0KPiA+ID4gKw0KPiA+ID4gK0ludHJvZHVjdGlvbg0KPiA+ID4gKz09PT09PT09PT09PQ0KPiA+
ID4gKw0KPiA+ID4gK1RoZSBJbnRlbChyKSBEeW5hbWljIExvYWQgQmFsYW5jZXIgKEludGVsKHIp
IERMQikgaXMgYSBQQ0llIGRldmljZSB0aGF0DQo+ID4gPiArcHJvdmlkZXMgbG9hZC1iYWxhbmNl
ZCwgcHJpb3JpdGl6ZWQgc2NoZWR1bGluZyBvZiBjb3JlLXRvLWNvcmUgY29tbXVuaWNhdGlvbi4N
Cj4gPiA+ICsNCj4gPiA+ICtJbnRlbCBETEIgaXMgYW4gYWNjZWxlcmF0b3IgZm9yIHRoZSBldmVu
dC1kcml2ZW4gcHJvZ3JhbW1pbmcgbW9kZWwgb2YNCj4gPiA+ICtEUERLJ3MgRXZlbnQgRGV2aWNl
IExpYnJhcnlbMl0uIFRoZSBsaWJyYXJ5IGlzIHVzZWQgaW4gcGFja2V0IHByb2Nlc3NpbmcNCj4g
PiA+ICtwaXBlbGluZXMgdGhhdCBhcnJhbmdlIGZvciBtdWx0aS1jb3JlIHNjYWxhYmlsaXR5LCBk
eW5hbWljIGxvYWQtYmFsYW5jaW5nLCBhbmQNCj4gPiA+ICt2YXJpZXR5IG9mIHBhY2tldCBkaXN0
cmlidXRpb24gYW5kIHN5bmNocm9uaXphdGlvbiBzY2hlbWVzLg0KPiA+DQo+ID4gQXMgdGhpcyBp
cyBhIG5ldHdvcmtpbmcgcmVsYXRlZCB0aGluZywgSSB3b3VsZCBsaWtlIHlvdSB0byBnZXQgdGhl
DQo+ID4gcHJvcGVyIHJldmlld3MvYWNrcyBmcm9tIHRoZSBuZXR3b3JraW5nIG1haW50YWluZXJz
IGJlZm9yZSBJIGNhbiB0YWtlDQo+ID4gdGhpcy4NCj4gPg0KPiA+IE9yLCBpZiB0aGV5IHRoaW5r
IGl0IGhhcyBub3RoaW5nIHRvIGRvIHdpdGggbmV0d29ya2luZywgdGhhdCdzIGZpbmUgdG9vLA0K
PiA+IGJ1dCBwbGVhc2UgZG8gbm90IHRyeSB0byByb3V0ZSBhcm91bmQgdGhlbS4NCj4gPg0KPiA+
dGhhbmtzLA0KPiA+DQo+ID5ncmVnIGstDQo+ID4NCj4gVG8gYmUgY2xlYXIsIEkgZGlkIG5vdCBz
ZW5zZSBhbnkgYXR0ZW1wdCB0byByb3V0ZSBhcm91bmQgbmV0d29ya2luZw0KPiByZXZpZXcgYXMg
aXQgYXBwZWFyZWQgZ2VuZXJpY2FsbHkgY2VudGVyZWQgYXJvdW5kIGhhcmR3YXJlIGFjY2VsZXJh
dGVkDQo+IElQQy4gQXQgdGhlIHNhbWUgdGltZSBJIGRvbid0IGtub3cgd2hhdCBJIGRvbid0IGtu
b3cgYWJvdXQgaG93IHRoaXMNCj4gbWlnaHQgaW50ZXJhY3Qgd2l0aCBuZXR3b3JraW5nIGluaXRp
YXRpdmVzIHNvIHRoZSByZXZpZXcgdHJpcCBzZWVtcw0KPiByZWFzb25hYmxlIHRvIG1lLg0KDQpP
Sy4gSSBoYXZlIGZvcndhcmRlZCB0aGUgcGF0Y2ggc2V0IHRvIG5ldGRldi4NCg0KVGhhbmtzIQ0K
TWlrZQ0K
