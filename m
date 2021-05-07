Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDFDA376D15
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 00:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhEGW7s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 May 2021 18:59:48 -0400
Received: from mga04.intel.com ([192.55.52.120]:58167 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229470AbhEGW7r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 May 2021 18:59:47 -0400
IronPort-SDR: 2x6eZ3R8cXPc+IyZTtx7ldTTlOjNrVYAT/gF2P07OvmSf5/jU6Qmz91Mn7PHrvWpQLGhAdf05G
 tf2kmPbbnP9w==
X-IronPort-AV: E=McAfee;i="6200,9189,9977"; a="196817783"
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="scan'208";a="196817783"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2021 15:58:47 -0700
IronPort-SDR: IKGRTybl5vtkxH2qFe9kuwnPWJXVW8k/55ZG/HCqNIno8lad7ws6LJa9vipYBOMoh4Fe6HK+oE
 6MmQFk/ypTbw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,282,1613462400"; 
   d="scan'208";a="620368402"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by fmsmga006.fm.intel.com with ESMTP; 07 May 2021 15:58:46 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 7 May 2021 15:58:46 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Fri, 7 May 2021 15:58:46 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2
 via Frontend Transport; Fri, 7 May 2021 15:58:46 -0700
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2106.2; Fri, 7 May 2021 15:58:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=V+2esUrhGCQiQB1JQTf9oj5Jhwa124hZvnjN1Ut+GnNd9wwGGhanm/zRX2RYiGrKXlB4Se9pYQD/iovJra95NpR7ENpyqcxogV69c25eP+fB03EX29iMLnibHj/k/fX4To+C3yGdS46Qrg8PFj2I6O2Cr1hwcGaZ5hWjRV+3vO4JiVvy4TsJpfXc1Bab8RjJ1enx2TSNsvszOvLgBAa7hFbXQtgDjn3lTyVQ1l2XuWfoC3JU8RBNurUvOHQ+XfHZVQMMM2U0TrR9bQj1Z3aZetb6FgfkljweHFF5gXjKpz6YXQRbGLL9NG+s0XFkCtOdvHXEentGIdSJuutsjn5rSA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLAoemcEIv8Ufv7BB5DrnTSB6n5FGGARVu1gp6XOHrs=;
 b=Xue29XKLhk047JGcz4cJDjJw3hzY6wYFmmSh33sbw5vmErRwg9WnIReqLseONeS5qEWAQPvrYHN2zymQAlbkhJrwWuRcJh/cpM04PYB4z+qT6bv+W2XRzlb8Tn2+7oXIHOl9pN68i7KwEa5e41fsvhul9FIGm1FQqjIlkofFi/bYI9cZXIb1awW6t8/IspVv69sNUfSnY1kiNs6KNmXhAh4f6dKLlUnSa2NeJnGps/p1VjmebNxeHBk+KAH6OK4GobriKXdiyI1j3LcdEcxAvCiOe/I10Gj+pYzmBqIjSz61haUziaWgheVpq7avxUKJC0XkL7JE0i3qwKZm3HXsWQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLAoemcEIv8Ufv7BB5DrnTSB6n5FGGARVu1gp6XOHrs=;
 b=RlR9dym1dIKf0JJpo2vr6t536v5SWRkXSiI6vZSmxJw65UENZB/iqnpK4KNj+lJbXr7GP/D4bRHi5PtiU6nXCed/yhttSXSdbHv4dKPes3KcABSKZxcGMlb/i6JqsZ+uGqYklOYsYbg3sWYMxls5h5qwR+KoaLCjFVHQ4N1D0QQ=
Received: from SN6PR11MB3229.namprd11.prod.outlook.com (2603:10b6:805:ba::28)
 by SN6PR11MB2704.namprd11.prod.outlook.com (2603:10b6:805:53::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.24; Fri, 7 May
 2021 22:58:42 +0000
Received: from SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c]) by SN6PR11MB3229.namprd11.prod.outlook.com
 ([fe80::7ca2:37ff:9cbd:c87c%6]) with mapi id 15.20.4108.027; Fri, 7 May 2021
 22:58:42 +0000
From:   "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
To:     "magnus.karlsson@gmail.com" <magnus.karlsson@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "brouer@redhat.com" <brouer@redhat.com>
Subject: Re: [PATCH intel-net 0/5] i40e: ice: ixgbe: ixgbevf: igb: add correct
 exception tracing for XDP
Thread-Topic: [PATCH intel-net 0/5] i40e: ice: ixgbe: ixgbevf: igb: add
 correct exception tracing for XDP
Thread-Index: AQHXOCgtNwfDqjz9y0elFA8tzkoNg6rYuLuA
Date:   Fri, 7 May 2021 22:58:42 +0000
Message-ID: <75d0a1d13a755bc128458c0d43f16d54fe08051e.camel@intel.com>
References: <20210423100446.15412-1-magnus.karlsson@gmail.com>
In-Reply-To: <20210423100446.15412-1-magnus.karlsson@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Evolution 3.28.5 (3.28.5-3.fc28) 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [134.134.136.204]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bb8fde3e-c67c-4fb9-d77f-08d911aba944
x-ms-traffictypediagnostic: SN6PR11MB2704:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB27045D06FE3F02AD1CD9287EC6579@SN6PR11MB2704.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: QhqHaZ1lCWPtf5JjDqqGsgP9EDth9rNHDXrEGScHp6exhSQC6kSSnEhYEtu87V1s6MDzUPvbEfujUEOVBiMXq/PnSb1siLUGl0Ck7YsqILc3ejiT1XqnPmXBQ04Rs4NryZApFSgVgEuVpNRpwP4dzDygobE14UP4r2/Al6DbVf9/K68Y7hl5PSy6WT/s8hRJAdhWVSI/f7ZnUAqyHegKcY9sD7XrIfEhD+Y3chzrbdVtGxkDJ466OQijNp0rEyvBZZvmsRhizvUaKtjPgwwYaXIEWPWGgmZ87PNVD/UyRR0cl7cqnEWenrA7UUU/nh/4nEib3elXO8XcVJ+LLgTc7k5oxEb5S6sN/BQxDinqGm9NBBOOR6pwyAGQEacm+if20xygq9hKPzxn1mK1jTPapU0hd9FH7hojij8ZHZan0nqUbXHFo7LyQo2TsB6c74Vx1k+O5N6/ECsKIfMiqHLlZDftbbHbyVdhWqDSXsSyRTtvLcRYSII4/oEJoed7PgrzFmA7CPX6j5giYJSAWE0Z/ZmWs7zYzNA2D2cVLtB3CbXsSFoBY9qDyYBh7PnlQJuJ8aBz5hV3I9pfK/onH23/XxFNnGR1pm+pW/DjujsKYtPGEdqKLgmU2Zf0RJSGgfrFmS8jjs1ridrBC1/KJOW7Bw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3229.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(5660300002)(6636002)(6486002)(26005)(83380400001)(2616005)(186003)(2906002)(6512007)(478600001)(6506007)(71200400001)(66446008)(38100700002)(86362001)(316002)(8676002)(4326008)(122000001)(36756003)(110136005)(54906003)(8936002)(64756008)(66556008)(91956017)(76116006)(66946007)(66476007)(99106002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?utf-8?B?bitaWkhsT3BWUkRtT1JQL2NyUHhlcm1tUjE4UHpOOURieVJ4QXBweDVhVjlI?=
 =?utf-8?B?UkFZWHlmUktmazYzb0s5Tm5aZDhnTlF1MnpWS1hrdHhVbjFqU3oyRVlGdUht?=
 =?utf-8?B?blVpSTBQbUM4Zlg4aUs0QncwQVd4MXBFNkxJRVovMXRPOVpsTEpTS2RWQlp6?=
 =?utf-8?B?ZUQyTm1Rd3c5TXBpRXhuVTNaSE9KVFBRdFdYZUt5T3FFaG9EYkluUERDNmlq?=
 =?utf-8?B?ek1mMnIzMzB1TVIvRk02WmQ3VnZWYUljZVVhWmx0SThnTGQ1UkFCNktvOHc1?=
 =?utf-8?B?cmd0UmhRd1dKVHFiU3RpOE5TU2Z2N2g0KzRmd2ltQzhEcjdpZm5ob09lRmN3?=
 =?utf-8?B?U2xxVmlha0RVNUZhVHRsVnF1R3JZWHlMQ3pOVmloWUdDRVpRZ0lNckh6YlRQ?=
 =?utf-8?B?VWZ3NTlUdHZRTDQ2RWZ3WTZJdGJFckI4cUZ0b0VEVVpVMWRFbkNEeXcvTDZF?=
 =?utf-8?B?WlB4M1RENk1XZGlXUCtGRUZCVE9BTHBrQmd1ejJZN001MklqVHFRZTFwdEs0?=
 =?utf-8?B?YzlUN0xDYnRQRmtwUmRBUzcxSm1LQk9uVUlETUFHa0FZRzA0WUJWd3pvYmww?=
 =?utf-8?B?aEVCZWJ0cEZGbzZyaHhnbTI5eWdrak16L3ZvWmlUVHpaRG5zRG5sZ0VKLzBR?=
 =?utf-8?B?WDNrKzFsK0xtVkV4d3NSb2orbEhUSmNhV25jSHovUVhGMTJUVUFIZGVSanZF?=
 =?utf-8?B?bXJGQWthekE4Smg2YnFMRVZnRS9xbzI2VjR2RzZGWEZnRlJJbHpJYlE2QmtL?=
 =?utf-8?B?cU1FVndoRVF6c3VSWmtwWkc2aHVyd1VyN2FxR1VLODJRakZuVlJMT1IvK2Yz?=
 =?utf-8?B?WFdBUGJSM2ZvYUYwclk0enpNQUs0MUFnNEFMWHM1a2JzVCthS1kvbVlDaVJH?=
 =?utf-8?B?UjI5dXZLWnZVaHNhU280VmFTVnlBNU9KaTIrdEZBZG1mNU1Mci9NTVdsL3E5?=
 =?utf-8?B?NFRzWUlLbzRzVFhpS3hyZTliREdBdWRPcUk3eEZBWldzdFRUU29XTi9aN3Zl?=
 =?utf-8?B?eEtrUStBNWZtRk1IMmZBQk9tbWxBazByMjUxZ1ZjT0NoN1FDdHhlYWN2dzhT?=
 =?utf-8?B?SmdDL3pOVEFreGsxSTYrNkFoekpRU3dDZHI3ZnpIMGZFQ3czN1pJRUYrbWd1?=
 =?utf-8?B?RmVUcC8xZzJxNEVUc3c3RWJhWm1xMDdxWUM2UzRvSHBmUWJwRUVKZXFZMjAz?=
 =?utf-8?B?bTlRYS9BOG5oTFJyeWJObHJra05UbzNoVHhpTmFPQXBhS1lwOU5uc1BMTkVk?=
 =?utf-8?B?cENFRCtPYnd6NG1maXVZSkw5NFpxMlI0QWxRTVRlL3QwVDZnMGo1ZUkwMzR5?=
 =?utf-8?B?TFlxWVVDTWVtMFE3MUtRMm95UDdEenhZKzRNUXRYOEU1WVpsbzRrUy9pL25o?=
 =?utf-8?B?T0VrNTl4bTFaalVDNnBlSXFHejdTMWdwVXdnejRHcXNxNnM5YnZqYWFtVGU5?=
 =?utf-8?B?MnluL1NYY3hxK28vSzhPOG1mM0h5V2RmTnlHK3NneFpiaXhoUW1CRG9BTVI3?=
 =?utf-8?B?OWk0aktnWU1JRkxTeXNVczRPTlJoVkhBUmpUU1NmVjZBdHhuVTJXNHJVbUlC?=
 =?utf-8?B?aENDTGhNSDcxeW9PS3RhRGZSLzUwdUlpSUkxZU5DRHpieWh2ZFVNbU5CQmw5?=
 =?utf-8?B?bE1kZlppdXoyQzJ6cXhpVU1YRXBKR3VWZlZ0d2MyUW5WL3VpWmFGQS9MVG5i?=
 =?utf-8?B?aW9yb3l6WVA3Y2hyVmZyN2Z1K0c2U2FpMVFzVEZKd05vVEZ6Z1FTcUwzQVFk?=
 =?utf-8?B?aGdLMnNueElxM1hLS1RyN2tNMWhmU3BLMGFoZ0hOYmd6b1htakQyL3A5cG5W?=
 =?utf-8?B?aENtWVpvV0ViRWNxaG1TUT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F62AE3979A220540B8E206699AE49C90@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3229.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb8fde3e-c67c-4fb9-d77f-08d911aba944
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 May 2021 22:58:42.5727
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: BP5nctezIP41B9gYVGYgL9XOemvuloGCjT/tZ13XSsChlykrCjdxJh6Q2GpMW+/GaX3z5Lrq46ORtOU+wm7lOzRwAqTiSd1XgBsDk1mE7uo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2704
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIxLTA0LTIzIGF0IDEyOjA0ICswMjAwLCBNYWdudXMgS2FybHNzb24gd3JvdGU6
DQo+IEFkZCBtaXNzaW5nIGV4Y2VwdGlvbiB0cmFjaW5nIHRvIFhEUCB3aGVuIGEgbnVtYmVyIG9m
IGRpZmZlcmVudA0KPiBlcnJvcnMNCj4gY2FuIG9jY3VyLiBUaGUgc3VwcG9ydCB3YXMgb25seSBw
YXJ0aWFsLiBTZXZlcmFsIGVycm9ycyB3aGVyZSBub3QNCj4gbG9nZ2VkIHdoaWNoIHdvdWxkIGNv
bmZ1c2UgdGhlIHVzZXIgcXVpdGUgYSBsb3Qgbm90IGtub3dpbmcgd2hlcmUgYW5kDQo+IHdoeSB0
aGUgcGFja2V0cyBkaXNhcHBlYXJlZC4NCj4gDQo+IFRoaXMgcGF0Y2ggc2V0IGZpeGVzIHRoaXMg
Zm9yIGFsbCBJbnRlbCBkcml2ZXJzIHdpdGggWERQIHN1cHBvcnQuDQo+IA0KPiBUaGFua3M6IE1h
Z251cw0KDQpUaGlzIGRvZXNuJ3QgYXBwbHkgYW55bW9yZSB3aXRoIHRoZSA1LjEzIHBhdGNoZXMu
IEl0IGxvb2tzIGxpa2UgeW91cg0KIm9wdGltaXplIGZvciBYRFBfUkVESVJFQ1QgaW4geHNrIHBh
dGgiIHBhdGNoZXMgYXJlIGNvbmZsaWN0aW5nIHdpdGgNCnNvbWUgb2YgdGhlc2UuIERpZCB5b3Ug
d2FudCB0byByZXdvcmsgdGhlbT8NCg0KVGhhbmtzLA0KVG9ueQ0KDQo+IE1hZ251cyBLYXJsc3Nv
biAoNSk6DQo+ICAgaTQwZTogYWRkIGNvcnJlY3QgZXhjZXB0aW9uIHRyYWNpbmcgZm9yIFhEUA0K
PiAgIGljZTogYWRkIGNvcnJlY3QgZXhjZXB0aW9uIHRyYWNpbmcgZm9yIFhEUA0KPiAgIGl4Z2Jl
OiBhZGQgY29ycmVjdCBleGNlcHRpb24gdHJhY2luZyBmb3IgWERQDQo+ICAgaWdiIGFkZCBjb3Jy
ZWN0IGV4Y2VwdGlvbiB0cmFjaW5nIGZvciBYRFANCj4gICBpeGdiZXZmOiBhZGQgY29ycmVjdCBl
eGNlcHRpb24gdHJhY2luZyBmb3IgWERQDQo+IA0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaW50
ZWwvaTQwZS9pNDBlX3R4cnguYyAgICAgIHwgIDcgKysrKysrLQ0KPiAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvaW50ZWwvaTQwZS9pNDBlX3hzay5jICAgICAgIHwgIDcgKysrKysrLQ0KPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaWNlL2ljZV90eHJ4LmMgICAgICAgIHwgMTIgKysrKysrKysr
LS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pY2UvaWNlX3hzay5jICAgICAgICAg
fCAgNyArKysrKystDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9pZ2IvaWdiX21haW4u
YyAgICAgICAgfCAxMCArKysrKystLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9pbnRlbC9p
eGdiZS9peGdiZV9tYWluLmMgICAgfCAxNiArKysrKysrKy0tLS0NCj4gLS0tLQ0KPiAgZHJpdmVy
cy9uZXQvZXRoZXJuZXQvaW50ZWwvaXhnYmUvaXhnYmVfeHNrLmMgICAgIHwgMTMgKysrKysrKyst
LS0tLQ0KPiAgLi4uL25ldC9ldGhlcm5ldC9pbnRlbC9peGdiZXZmL2l4Z2JldmZfbWFpbi5jICAg
IHwgIDMgKysrDQo+ICA4IGZpbGVzIGNoYW5nZWQsIDUyIGluc2VydGlvbnMoKyksIDIzIGRlbGV0
aW9ucygtKQ0KPiANCj4gDQo+IGJhc2UtY29tbWl0OiBiYjU1NmRlNzlmMGE5ZTY0N2U4ZmViZTE1
Nzg2ZWU2ODQ4M2ZhNjdiDQo+IC0tDQo+IDIuMjkuMA0K
