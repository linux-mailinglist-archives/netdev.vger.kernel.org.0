Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4418132A369
	for <lists+netdev@lfdr.de>; Tue,  2 Mar 2021 16:16:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382159AbhCBI4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 03:56:32 -0500
Received: from mga12.intel.com ([192.55.52.136]:24564 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1837119AbhCBH0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Mar 2021 02:26:18 -0500
IronPort-SDR: RxaJkYKD2/xLsdqV7Tm5OAuzMcH4W+/qt3Ah9cYilcq4ExseiDUDt2MohlLgiJTYdo2sMULDNG
 Xt5MPPxngbVA==
X-IronPort-AV: E=McAfee;i="6000,8403,9910"; a="165952426"
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="165952426"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2021 23:24:24 -0800
IronPort-SDR: ReSQ9tbePiDIQ56hrGaUrqi0qOHcxCf5SpYg29SYBRgoWU0aczO8YJsFzxcSLHlfBHc6NpT1De
 rrmOe/CGWMow==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,216,1610438400"; 
   d="scan'208";a="398195112"
Received: from orsmsx605.amr.corp.intel.com ([10.22.229.18])
  by fmsmga008.fm.intel.com with ESMTP; 01 Mar 2021 23:24:23 -0800
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX605.amr.corp.intel.com (10.22.229.18) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Mar 2021 23:24:23 -0800
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 1 Mar 2021 23:24:23 -0800
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Mon, 1 Mar 2021 23:24:23 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.48) by
 edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Mon, 1 Mar 2021 23:24:22 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lKcEfkGvKdLp4eDG9ZjgtW41vX90FTZN5V/h04tOtG3FKOYMCuBI8XK/vOZcFSjXBbQv1IFC3vHLNsCoPCawAufogN8voivUot/QDuGoX4XamB/IToBdbT8DVCaP9YTMtwezKQnozIiFHb7/XDjqCHrA7UujjFTgoMuaff2ENQrID14h+u+hsht3fmcDkPXdn2W2muYrpcCq3LJ1X9Z5IJiuz59jEfBmetdgM+pwr9Yy3C/oD03xIH0qyHUPIHN2MqmOWLl58a1LAqy0ImhcFuoyIJnxLV1Vx3o6j7g8CWWDUSAeJXqU449KPtfKZfgNEwx0EF9Sg2uF4R2FpsbrRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9keEohbXvJYYrGLzJEUx5smQh4egbv9kakzBNuG8FE=;
 b=divMPDLWB9I9ATcVwEk7cVPkPiMQ5uyBd76SrQBQl+fq/p6n2sN4EKWPXvnSwNKGmucHKqH9ABBbM+rd6drWe6wnUwIIfb0eAGCSYipOpcwHj92/WBiWigo5bP2QP3IIgFdCsIbhXVX/BL9upHJxIm/DE7Pdc0Hm0euPDSVhieCguun4l+CHTAqkyI3hzuQPYg0gj4FKyoTvOR/QVsqTRFPh2RovhXzDQ321DCI0TLQ3/2cQ9Wtu+hKODk0+FK79dh770vv6P8kqprS1rek+6O6Js/8pReqIHuAWqtKVjDqYCIxxDvmH6AccluILxu8gn93/kzC3mQpB1gwMSECVIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T9keEohbXvJYYrGLzJEUx5smQh4egbv9kakzBNuG8FE=;
 b=Jc6M0YIZtGnHRgBqywFSIXO97skzz9dBOmRQuO97XvsQRI3cuyXYGYzMMn6BgUKdK238Xacn+zhKiF05MVlYiszqD/Y/7+MccBVXUfWoTRKm0Q1M5r2lY8uJaSOpsvSwz12Qm7OebKLeFNb2SyjckJ3uta9Lk0A7935Tc5X6hE0=
Received: from BYAPR11MB3207.namprd11.prod.outlook.com (2603:10b6:a03:7c::14)
 by BYAPR11MB3829.namprd11.prod.outlook.com (2603:10b6:a03:fa::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.28; Tue, 2 Mar
 2021 07:24:22 +0000
Received: from BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf]) by BYAPR11MB3207.namprd11.prod.outlook.com
 ([fe80::c951:3ae4:1aca:9daf%3]) with mapi id 15.20.3890.023; Tue, 2 Mar 2021
 07:24:22 +0000
From:   "Coelho, Luciano" <luciano.coelho@intel.com>
To:     "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>
CC:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] iwlwifi: fix ARCH=i386 compilation warnings
Thread-Topic: [PATCH] iwlwifi: fix ARCH=i386 compilation warnings
Thread-Index: AQHXDwHCZhYGmtuUrkCfjHc0gwOiPapwNEqkgAAX0oA=
Date:   Tue, 2 Mar 2021 07:24:22 +0000
Message-ID: <d8437a2c23aa2217233a55222c6968d1ce887bf2.camel@intel.com>
References: <20210302011640.1276636-1-pierre-louis.bossart@linux.intel.com>
         <87k0qq85bj.fsf@codeaurora.org>
In-Reply-To: <87k0qq85bj.fsf@codeaurora.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: linux.intel.com; dkim=none (message not signed)
 header.d=none;linux.intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [192.198.151.182]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d13a723b-69d9-4b51-eba1-08d8dd4c3363
x-ms-traffictypediagnostic: BYAPR11MB3829:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR11MB3829A1112A5F79491BE0E47190999@BYAPR11MB3829.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3513;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iqAhtCcJwbSm4uxy5Pnxi+vxP9PmyzQXv/1Wi9OG7vlZUkypZyk4kZgoMCXszF9HR3Jsee8tGIjsV+UaSsaF4rpMnCS8HTeb/WWjhxN8nEYPpfUCv37o1o9b3KHa1kclUr+ynm9oEuN3L0vEie/OYN6LNP/rVIxeJQHWgh/uYn5xYhFoHkKULqIqD77aQVtPDL0JYdjgm0r5XkweYZp1RElYiQ+EzPnABdppUG5LMqD2cUNi4OKesySXxhC0FcdaU8mjNm8Uu1V19Q279k5XXHknyCw0B0F0GWEjvlpEoDyptJIliHjXtKQX9Yy73JY85Rwwag0mSFf2Wyj6S6h4HRnuLXMWxOyV1U+D7X5tO65xHKZ6FsZc1igKMRHCQZUw6NOmfavXFW4sGe/w24qmeEUxVTaoXy6+LDk7EPswAHUFIoAy2FLR9OyonK+t4O+wgGcW46ixRva0AGFhZq6uxmbpseYF1tTQQy4yjcRLN9yf5r4JtNdCe6HwbCiKL3tgSyQ65xCQKdMFZShgA51FvA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3207.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(346002)(136003)(396003)(376002)(366004)(5660300002)(26005)(6486002)(316002)(4326008)(54906003)(64756008)(83380400001)(2616005)(110136005)(66446008)(66476007)(66556008)(76116006)(186003)(66946007)(91956017)(86362001)(6512007)(478600001)(71200400001)(2906002)(8936002)(6506007)(8676002)(36756003)(4744005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cWV2YUxBaE9Ec2tjcFQ0SXlDSFRwN1NGTFA0b1RhVy9VSTRSck5EZzJPL280?=
 =?utf-8?B?WStkemd6RUFTUXNYUENNNzd1N21BSGQyRFFlRExMTUNyc25UQi9ZYm9Ob2pX?=
 =?utf-8?B?N0pTVUVtckhjc0NjQUV4K2d3Z0RHQkVWbEc1STVSVjFRb2JFcmVWYVUyZm1D?=
 =?utf-8?B?YjV0N2VJRWJEcVcwMHpoWXM5NEhBUzE2YU04SzZoOFQvYU1wQUVmS21BWWx5?=
 =?utf-8?B?KzVKbDE3KzduUjRJTHArZm1aWTkydFRzd1I3TERFQUxweGppMTI2cmJTckNC?=
 =?utf-8?B?cWRsclJKNDJHQkxlcG1iLzVnL3Y3WkNkUUM1enhxRHIzcGpUckE3cTNpanVY?=
 =?utf-8?B?bGdJVVZYTWpPRVhndHh6SDJXZXI1MWdQZW1vaGRZd1k0VFJKbXNZOVdvMUhT?=
 =?utf-8?B?K3BVSFZwZUpmYVBnUU5oTnlEQXNsYjVLQUZyamZUUHl6d2U2Mkk4M3dKbkQ3?=
 =?utf-8?B?WndtR0NDTGlBL1hldmlSSE1OUi9OOGM1MzVWcnNqWnpjelQ1eXpCYlJQZlhT?=
 =?utf-8?B?YjNiZyt2clhWaUozYzVNcGtsMVJmWk9GbU5HYnEvMzQ5dXk3RnR0N0lvcm1B?=
 =?utf-8?B?S3pQRDcrSm80bEFCRU1CT2xqc2Jsamk1c2t6TmxKMkQwZm1LTUJKVW9HN28y?=
 =?utf-8?B?MzZ3NTU5SkpGMmJvYi8rNko0Z3VURTdlTHByTnhUWTNQWDlnMksvdSs2TXRM?=
 =?utf-8?B?OExnNHBQeFc2cTVXY0JoemRIeDBkVkMwTmpMbnlIWkV2eTFNcmoxdnNFU2lB?=
 =?utf-8?B?SWhNUnlpMkx2eUNiMXRLdDhZOVYyMVdScmtQc1liMG5FUmR4OEZ6M1ZMUlY5?=
 =?utf-8?B?RFp2c1ZOR3VGYkhXRFVNYkpDMW0yckJ1SnRwMzIxUkprRS9CalVRSW5pVkZ0?=
 =?utf-8?B?Q2pMd201R0tyMkRxNE8ySWp2dWZDdk5YczhMVmR4dUhmS2FYdXZzRm5BTnhU?=
 =?utf-8?B?K3MzNFN6ejV6RkN4US9FV1NGeUhtb05sUUhyeXZ5MFJKTG1wdHVmOHdsblk3?=
 =?utf-8?B?NW0zUzJ2L0NwY1pwTDBaNjYzZXgydS9iUmtwRjdjSTlRQzF6Tm5OclNzUG5W?=
 =?utf-8?B?Q094RU9JaVFXcFgraVY5UkJZWXV4a1FqdkR0YW5Wdktod0luUXV6NmtaUzZN?=
 =?utf-8?B?aGJTRGVENnJlZkVWSGdFRXZZVncrbXdWTzJIeU1DSXVmaXkzcVR3QTU4dVIy?=
 =?utf-8?B?WnAwZUVCemRPYWlPeFNCQzZ6MGQ5cGlWSzNtdFZXb1JSSURoMmIwMlo4cHpG?=
 =?utf-8?B?V2xhbkRyT3cwYnNobmJLUU1KWHd6OW5qNHRTQjRGYy9ZTCtMbUdURzlTNGxn?=
 =?utf-8?B?b3hLeTcvR0RWb2FNWUNQaG1KUUlRcVd0eHV5T3RRU2c0VmRqNXNQeWxMTnZs?=
 =?utf-8?B?cmdsclFNajVwMDI4bCtscGQ2TGxZM0dtWGxMVHZlQ0hOYStReUpwV0lDNHdE?=
 =?utf-8?B?TkN4MmJjQkpNNS94Y2d5NWM1OG1IV0xmK0VMZjhzdmZwa2lzcDR4SEdpR0oy?=
 =?utf-8?B?cGFkdkFBMFVJVnZTTTE5bmk2WGlkcTBCQ0ZNYzRBZXhvL2h6ZjJYNjFFM3NR?=
 =?utf-8?B?YkFIaEVTRDEvUnJ5dDNxTE05VHNkWVUvaDNKWnh2N21mejBVUjFxMnIyc2JR?=
 =?utf-8?B?MU1URGFmNnVacnJtM2dETklXK1hUNzNTS3pnZVJUdzBVaXc5czl0azZaOUZn?=
 =?utf-8?B?TTMxbkdZMTRiSVVqb0N4NHo0Y2wxQWhqeWFZRGlYWk1WUFZHSWJ3eEwyTXhN?=
 =?utf-8?B?eEpRSDZQZ2dDcnAvM3N4bTlYYk83NExqaFFoN20wdSt5d3Yzbjk5OStWMW1R?=
 =?utf-8?B?MVpSb2IrL01KTlBKMUk3UT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <E186667C187400429AD17AAD2E3DBFF8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3207.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d13a723b-69d9-4b51-eba1-08d8dd4c3363
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Mar 2021 07:24:22.1155
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: j+ldmJJMvt9Auv8jN/FrUQnQKgGK+QDiwlClXQFvphXhC/lTmy6vM9Syz+MC+QSV1wmAdtxURlfLTftMEKs+C7p5uFtCwdDFcJ6TcZF9Rxw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3829
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIxLTAzLTAyIGF0IDA3OjU4ICswMjAwLCBLYWxsZSBWYWxvIHdyb3RlOg0KPiBQ
aWVycmUtTG91aXMgQm9zc2FydCA8cGllcnJlLWxvdWlzLmJvc3NhcnRAbGludXguaW50ZWwuY29t
PiB3cml0ZXM6DQo+IA0KPiA+IEFuIHVuc2lnbmVkIGxvbmcgdmFyaWFibGUgc2hvdWxkIHJlbHkg
b24gJyVsdScgZm9ybWF0IHN0cmluZ3MsIG5vdCAnJXpkJw0KPiA+IA0KPiA+IEZpeGVzOiBhMWE2
YTRjZjQ5ZWNlICgiaXdsd2lmaTogcG52bTogaW1wbGVtZW50IHJlYWRpbmcgUE5WTSBmcm9tIFVF
RkkiKQ0KPiA+IFNpZ25lZC1vZmYtYnk6IFBpZXJyZS1Mb3VpcyBCb3NzYXJ0IDxwaWVycmUtbG91
aXMuYm9zc2FydEBsaW51eC5pbnRlbC5jb20+DQo+ID4gLS0tDQo+ID4gd2FybmluZ3MgZm91bmQg
d2l0aCB2NS4xMi1yYzEgYW5kIG5leHQtMjAyMTAzMDENCj4gDQo+IEx1Y2EsIGNhbiBJIHRha2Ug
dGhpcyB0byB3aXJlbGVzcy1kcml2ZXJzPw0KDQpZZXMsIHBsZWFzZS4NCg0KQWNrZWQtYnk6IEx1
Y2EgQ29lbGhvIDxsdWNpYW5vLmNvZWxob0BpbnRlbC5jb20+DQoNCi0tDQpDaGVlcnMsDQpMdWNh
Lg0K
