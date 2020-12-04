Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66442CF37A
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 18:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgLDR55 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 12:57:57 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:8287 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgLDR54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 12:57:56 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5fca787c0001>; Fri, 04 Dec 2020 09:57:16 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL107.nvidia.com
 (172.20.187.13) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Fri, 4 Dec
 2020 17:57:13 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.174)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Fri, 4 Dec 2020 17:57:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Zpo5ovJ1GBw9JqdAIOtwbq6d2qOdR4izP0VZbLK4MiL5x8ue5CEgDmlvLxfJAUUiK9kUhPjOm3FkgcI8W3SUm9faypzJe2KhHPg+sRD8ILIF31ecBLxiBBtDpAD1Bir/mrX0Zpbq03y25Fe7oWJSqpGzlpRTJuqTAe9kCsTG6n02PiL/vXJLpO/8nD86t5qSTY5i8pvKu0ChDgDHMQayfQWK0vnC+VRT5w/FYhzhDdEAJtiDcWm5q67ezlE/NPfvIm5vbzWe/vlKvOclDSnPZtyarBXXpw4J4QmUMUy7rHQyxTRv89Au74zQJfdwjIjO8Q94o9i6ao0VfAzSDZdutQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GHTsqUbpQObKePLVykPF4YMGN5jRRXULypEl/bZkO04=;
 b=bR5HkxCgBlfsa7Rbbt/+TXjM6x8qEw+73c2BPjhgnF9+B2woTos6j/NpkgB6t+0sfbSLbvdtz/ms0761PkJengsfMttfndsVFHGv/DzjKt3LDktz1t77+ABea6i8P34Lknydsd7d9CpulbgnISKIU67ezm/V6WRWhLBwP1GA82Ff7WkjlOcqnkGWEHnGeM5DCMthNZI50h27WsuEd62lgLoXL8SvRyzSRrAU1Fxy1uLH95xN0iHIFA14iQzYN5xrheWhVTHP632K5QU4UI7hb1egtfp4YdfiBQtJIC8D6lS/TIP5n/+62oq+CJ/AdMu2OsTum9QOKNxc/FxKZ1Soug==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from CH2PR12MB4213.namprd12.prod.outlook.com (2603:10b6:610:a4::24)
 by CH2PR12MB4261.namprd12.prod.outlook.com (2603:10b6:610:a9::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.25; Fri, 4 Dec
 2020 17:57:11 +0000
Received: from CH2PR12MB4213.namprd12.prod.outlook.com
 ([fe80::98:4658:724f:a941]) by CH2PR12MB4213.namprd12.prod.outlook.com
 ([fe80::98:4658:724f:a941%2]) with mapi id 15.20.3611.025; Fri, 4 Dec 2020
 17:57:11 +0000
From:   Saeed Mahameed <saeedm@nvidia.com>
To:     Leon Romanovsky <leonro@nvidia.com>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "david.m.ertman@intel.com" <david.m.ertman@intel.com>,
        "shiraz.saleem@intel.com" <shiraz.saleem@intel.com>,
        "ranjani.sridharan@linux.intel.com" 
        <ranjani.sridharan@linux.intel.com>,
        "mhabets@solarflare.com" <mhabets@solarflare.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "fred.oh@linux.intel.com" <fred.oh@linux.intel.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "lgirdwood@gmail.com" <lgirdwood@gmail.com>,
        "kiran.patil@intel.com" <kiran.patil@intel.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pierre-louis.bossart@linux.intel.com" 
        <pierre-louis.bossart@linux.intel.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "broonie@kernel.org" <broonie@kernel.org>,
        "dan.j.williams@intel.com" <dan.j.williams@intel.com>
Subject: Re: [resend/standalone PATCH v4] Add auxiliary bus support
Thread-Topic: [resend/standalone PATCH v4] Add auxiliary bus support
Thread-Index: AQHWyQ8TNP1v8NEBekWsm06ohs7ZG6nm4aqAgAAFi4CAADr3AIAAGXwA
Date:   Fri, 4 Dec 2020 17:57:11 +0000
Message-ID: <3b80200ec25958308d46b643c8434f9a5ce67346.camel@nvidia.com>
References: <160695681289.505290.8978295443574440604.stgit@dwillia2-desk3.amr.corp.intel.com>
         <X8os+X515fxeqefg@kroah.com>        <20201204125455.GI16543@unreal>
         <20201204082558.4eb8c8c2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204082558.4eb8c8c2@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.5 (3.36.5-1.fc32) 
authentication-results: nvidia.com; dkim=none (message not signed)
 header.d=none;nvidia.com; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [24.6.56.119]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 5b59e8cc-b3b3-4b48-86b1-08d8987e06b8
x-ms-traffictypediagnostic: CH2PR12MB4261:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CH2PR12MB426163768F9C54C6D38D2C03B3F10@CH2PR12MB4261.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4714;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: B3rgaU6ztWj/ldH/vDjaEdzgwQaATccc0p98KS5humOrYvM1foDntZNSnhIVvPEM9bkSgo97C8STglbnaFvunxqxepgKPIxmsE0EQNN4N/DpsJgHYlWDzW85BXHZ5guf1+BOqZemlZeHCxqTYXHGdP1+/BizIOaltP+aClBtY8Q66UFpVeVuxnanJfN6VkbQgbYsTHLm5lfSuMiJo370hEyxTPt7Jd8HBHT/lPWnlSPGrrNXD3qXqTn5ni/e+dTQ7dfrIya/4HjwzmkytcOOJohOgjeMVPljtHRBYmEGN6DuU+UDERH2zk/ukpY63HXBkmQ886D56qKUMTSvajYVhQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4213.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(91956017)(8676002)(66556008)(6512007)(4326008)(8936002)(86362001)(6506007)(36756003)(5660300002)(2616005)(2906002)(186003)(110136005)(66476007)(7416002)(4744005)(76116006)(6486002)(66946007)(71200400001)(64756008)(54906003)(316002)(26005)(478600001)(66446008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?cDc4SXBtbjVCOVAwb0tRemZmTjE2OGMrQlBTVWRNUDdwYWIyN2UzSVB5Z1VH?=
 =?utf-8?B?YkFtczZRQ2huZXVsaUhTY2FOZkpwME83QktpUzJjTEVjUkdRUHlmYi9QNnUw?=
 =?utf-8?B?SmpkK0pHNzFBNVZOdVJXSDh1UDZWZFJpV0JMSm5MNGQ0WGxSQkZPeCtYU20w?=
 =?utf-8?B?d3I2SjJ1SWowaWlSb3loRkRvS1Q5SFpFc2Q5bjF4a1FzOFJ0enNmZ2JsTENX?=
 =?utf-8?B?TmxBdGdoMlBjR216WDRtNEdFVk5OZWhTSmJWdGhPa0FkSFh4WEpSMjBQQXdF?=
 =?utf-8?B?blJUdXVvRllIMjBuV2xhVEFrcXE5MG5TbDgrWU9PbUpXRzhXNnJSWmtuWjhL?=
 =?utf-8?B?a1NrV3BvYTZ0c2ZBejdGdWRzOEVYRU5PZnlubGdZcEtSSngxVllLZ3JueUdX?=
 =?utf-8?B?RDZ1MHlNeXJtRVpDUHErR25iMm1WVlg0d05hekJNVUJORzZkYjJ4bXZlcHRq?=
 =?utf-8?B?VXBJQjBYRDB3S1o5ZTI4VjFTMDA2M2tBY0lkRm5XbUVtSFV6WDhlMjhsVHNS?=
 =?utf-8?B?WnlMMzJtMjVFNTFGTm1oM2pWZS83Zkdzd1JqQzJ2ckhNekZxcXR1Q2VHanFn?=
 =?utf-8?B?ek9LeTJybzhPNTRpYW8zZld0WXVrMzNRTkFjK1d0R1pNZVhVRTIxM1RKTis3?=
 =?utf-8?B?dTl6cGIzWG0xZDZIZnJyRzBoREtzR2ZxWUZnN1d2Y0JoNmYxdVNwSDhjSHZo?=
 =?utf-8?B?V1FTZVVFSnpYai9SbjRkM09MejE5V0tRaXJlNFJQbDhreFVxVVdpOXlCWG1X?=
 =?utf-8?B?WjN2SCtZNTJ6R0VBeUQvbS9hTzNVYTNsR2ZxRFpjUnFyUE1WeUZZZ1ZpVmNw?=
 =?utf-8?B?RSt1MFQzV3VSaVF1R1VHOUJuMUVHUldlMXdQNDNiaXF0U3libkZMczR6VkJL?=
 =?utf-8?B?RVhvbFp1RXluOTEzTkdYNGpQWWJ3V1ZaRzJNZ1M1cFpwcVBySzcreThaaUw1?=
 =?utf-8?B?Uk1SR1BxSElWRTlVUk5Wb0pZdDlEUEdwOFZPUjZqc0NmNC9qbXBhZWxWV2lv?=
 =?utf-8?B?czhFMFd0UUk3cHhIenQrK2pic1g4TENhcTl3K2NjUGp4cGhIWHZpZ2lPSXJl?=
 =?utf-8?B?N2xwRVFXYTdLb0JlcnFuSWVpQi8ybmo0RFdpeUhqeWRONG1KU1JmQU5YMDJr?=
 =?utf-8?B?dHFkVDNzUW9jTlNBbEVERFp5MHZTdEFJeXZrRU9QbmtuajZDd2taNGQ0bFpT?=
 =?utf-8?B?NGJHYzd5eEZUU2h6RUR5OE15dG1qakkyT0Y5UDcrRUxzc1F5MEpuYi9vb25W?=
 =?utf-8?B?aktKNmhHVG0wd0M4RTlOOFpBVjdobVZHdGdvSmJCajJJb2JqemlHM3ZTRXR3?=
 =?utf-8?Q?Mk2GifThJVqN0eQcEW/nN/QK0Rj4IyyaTb?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F398E237A43BDF48A3613E53FDCD24DA@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4213.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5b59e8cc-b3b3-4b48-86b1-08d8987e06b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Dec 2020 17:57:11.7957
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uakeNj1BPHIQBGbGLHVohJpLpBXZgHdurw5+otEKc9TP8r7EPxKUi5HkEuG0OzR5ofQvNV33WaRERdule3s6nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4261
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1607104636; bh=GHTsqUbpQObKePLVykPF4YMGN5jRRXULypEl/bZkO04=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:user-agent:authentication-results:
         x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=UW1JWU32v92IcTlinqDy5ld3en3sdM5JLfxrkFLstbRppcNmQX3fI17tQYUX7zZui
         yXuYTmJuSwL/EaQ2c0GYUgggNh93Cln49YOlX9mMCDd9k67MBtzR1LoG1WaouAyIzm
         lGIoCe4tTLC/s9MZ9/jWsY6tu8b4IM1Kh1HVN8dAmCtcDBJHXlmNQggcvbs6oAwxti
         svCbyi4xMuDaOwJgFgwo1aqUFFJUJsrkA6fua5JGt3BhfoujqeLClzwcm4sgDw7KQn
         /yCpF0OXV3odTwHiuvw4uvuuCYdAb5sPvNzhfydD6N/y8ZMbevfHRZS5IIR0fPvfXi
         96ZVeor1yRiVg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTEyLTA0IGF0IDA4OjI1IC0wODAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gRnJpLCA0IERlYyAyMDIwIDE0OjU0OjU1ICswMjAwIExlb24gUm9tYW5vdnNreSB3cm90
ZToNCj4gPiBUaGFua3MsIHB1bGxlZCB0byBtbHg1LW5leHQNCj4gPiANCj4gPiBKYXNvbiwgSmFr
b2IsDQo+ID4gDQo+ID4gQ2FuIHlvdSBwbGVhc2UgcHVsbCB0aGF0IG1seDUtbmV4dCBicmFuY2gg
dG8geW91ciB0cmVlcz8NCj4gPiBnaXQ6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tl
cm5lbC9naXQvbWVsbGFub3gvbGludXguZ2l0DQo+IA0KPiBDb3VsZCB5b3UgcG9zdCBhIFBSIHdp
dGggYSBwcm9wZXIgZGVzY3JpcHRpb24gYW5kIHNvIG9uPw0KPiANCj4gVGhhbmtzIQ0KDQpJIHdp
bGwgZG8gdGhhdC4NCg0KVGhhbmtzIQ0K
