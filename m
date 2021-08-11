Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D1BB3E8749
	for <lists+netdev@lfdr.de>; Wed, 11 Aug 2021 02:38:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235680AbhHKAie (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 20:38:34 -0400
Received: from mga04.intel.com ([192.55.52.120]:1391 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235624AbhHKAid (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 20:38:33 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10072"; a="213170507"
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="213170507"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2021 17:38:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,311,1620716400"; 
   d="scan'208";a="526415927"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 10 Aug 2021 17:38:08 -0700
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10; Tue, 10 Aug 2021 17:38:08 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.10 via Frontend Transport; Tue, 10 Aug 2021 17:38:08 -0700
Received: from NAM04-DM6-obe.outbound.protection.outlook.com (104.47.73.45) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Tue, 10 Aug 2021 17:38:08 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C1AzZtQvjFR3g3EsrOoMUHmTT5TcYZQRw+KGbUnm+18zY2RclWWrJYzLl9pnmLSgILvl5ep3XtPEqw4NmvYPOsrqXPXGW4iXUr3+whzO8HIpn0IsNolQ68BkrFIbzZhtwMFRPW1WRt3XmEJeLWlbLDaOEm8xt3Py6XXmyu9bpmDHYVVHLKjPaajsG/l0oIJitK9zViZ1lhdtCVL2FNl7955yl0mH5w2Rw/Ur9qWGSaQ3SIlvC7IJoqXfaoUPcyi0kziGJtoyJa85buTjBaUmNlyTbphFpBtfgDBOqJAPIwkLfD9DwpMMPvFUV7Xrel0mNRTe56RJbvBsTXlnc0ovsA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go/D9p9Efo6UZ57kbCGIq1AD026GQsGBk8eHOwcnQvM=;
 b=XZ65InMeQCUHwpYjnMd4bnplj94ZF/JjGqAwJ71UF0ePbkvHmr6N9KbJFjDR27LlilIZiGVsBaEghVKYouiXqo9xThPHAJUTexMbmSixhNGfoA+lBdXJt0Um4jmWfoOgPpdZ9rLvJxHB8X29U5Ddk7Vl/gaPnZv7AH0Gf8goS+u3PDlNbj9KUZWV98PyXiK51WUJKcWiSzgEkvz8/sNQVFsdx2kIMiB1fmFltpxs5iaaGenwVPn23UNTCXepuDBxYGCQp83bxOI1NiK0ycgsAuPb5VZP9Rm9zwdDE34bwQ2trYNE8nmygjvC0ysA7T5AyGZVAkhJ0cma06GTcJwufA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=go/D9p9Efo6UZ57kbCGIq1AD026GQsGBk8eHOwcnQvM=;
 b=jGEKBAjSYwtdzKxZfz0BTYtHvkfktQWvUbLlDtg2Ge/KU1+USXfxe6DZWK/ZoqTSST0H0lOulqPHNwB7aoYEfMFzvKA2ZAZcqHb4/hAUX74KHqXdFSuY7BqsgiBBc7LwqL0lMpOeF8AKXRuncpEyevv2UTZy2/ZqYZwkLlMyl0A=
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW3PR11MB4587.namprd11.prod.outlook.com (2603:10b6:303:58::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.13; Wed, 11 Aug
 2021 00:38:07 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::adef:da48:ea32:5960%3]) with mapi id 15.20.4394.023; Wed, 11 Aug 2021
 00:38:07 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Andrew Lunn <andrew@lunn.ch>, Jakub Kicinski <kuba@kernel.org>
CC:     Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "pali@kernel.org" <pali@kernel.org>,
        "vadimp@nvidia.com" <vadimp@nvidia.com>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Topic: [RFC PATCH net-next 1/8] ethtool: Add ability to control
 transceiver modules' low power mode
Thread-Index: AQHXjQh2iw3UgViIbkGUQrHAheSIDKtrO5cAgAEcgYCAAGu3AIAAAh0AgABxmACAABTCAIAAAaEAgAAG7ACAACNkAA==
Date:   Wed, 11 Aug 2021 00:38:07 +0000
Message-ID: <ff07fe13-9fcc-214f-fe56-fa29c4b022ad@intel.com>
References: <20210809102152.719961-1-idosch@idosch.org>
 <20210809102152.719961-2-idosch@idosch.org> <YRE7kNndxlGQr+Hw@lunn.ch>
 <YRIqOZrrjS0HOppg@shredder> <YRKElHYChti9EeHo@lunn.ch>
 <20210810065954.68036568@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRLlpCutXmthqtOg@shredder> <71a5bd72-2154-a796-37b7-f39afdf2e34d@intel.com>
 <20210810150636.26c17a8c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YRL+On9xAt6C+H5v@lunn.ch>
In-Reply-To: <YRL+On9xAt6C+H5v@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 20643232-1a61-4043-0291-08d95c6049dd
x-ms-traffictypediagnostic: MW3PR11MB4587:
x-microsoft-antispam-prvs: <MW3PR11MB45872C95DA0D623072BDC289D6F89@MW3PR11MB4587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: q45JUAIJK+KeafujDaGjUYUWuqjlz3G46dVxpUu9HSVmIzGBTdmguHlzUH6db1+5stpA7cNyrAhfLgYTcY9SxU6U3yOs3L1BDoBRumpuVMrbDr8GBZ3s5Nclks4Km5uU5B5M3S9/kATIxFCd0vkptfwLL0MADaiZi+yJWuNyMovvC1voBCU4zoEdZ324UZ0rxYdFCEP3gjZfLKiaLzQ8LJS9xsVqRHglsXadEtdx/XDLoo0jDXMWGLobL5vNY8frzaQosJLfi/dZ5Ga8fdK96OfqGAY1LcxPotxASTBVxEiQFboqkqQs0IhXQyrnXnajarOrFeKC6wEa44lcRDQyE7/IV8vh+V/qfr5NECqjgqXP9wOjtKvmYaoERCE09e2D4hBpP5k2PhlgYO3veeTMYlCM6GEfdaC2tqZMogfs7wYbrPIo/2KRyOhxnH8MFWnkwAK4TiqbqPNegUURZlWWTv1/qs7kk/Zq1pBYh57iqqO0iqvtQBCHGmFSGsO9/wNJeZEq8CCc654+15Pku+MxJ6wRstRJHzZDDtgMA6BbAVFKTNh16Pdm4A7lTeO3slFdkDwzEil076hlbZTqEgsUT8NLJ7rESHOlEQOxJvLIeXVgU9aJoZNUUjpjXcSFUw6O91yNSP/WSr18pYC/bK5j1y6WVq2w9DZ/GvUjIQHwaUQsxCLI7kAdrPfZZqGjWdsWxjnNmCBsxuaYlL+fW4//Aqt7h1aBcm+mnAaZupxgylc54Nm5/emec846xGenRYlh5sSWZo4rrliuvuVhb0IkwXd1b5ZCsS3nHxAQVdX8fDHq3r17YBr8GWTteOo2+NY6C76JSqONOHviPS+h6RypWEQSvYwxA/S3MFoevdCrNYwAsaH68ARkJC/kqSXtH6Nu3571JYTnl21j3JIMvw93pw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(376002)(136003)(396003)(366004)(39860400002)(478600001)(966005)(7416002)(2616005)(71200400001)(83380400001)(86362001)(4326008)(6506007)(31696002)(36756003)(8676002)(6486002)(8936002)(6512007)(54906003)(110136005)(53546011)(66476007)(66446008)(64756008)(316002)(66946007)(122000001)(76116006)(31686004)(38100700002)(38070700005)(66556008)(186003)(26005)(2906002)(5660300002)(45980500001)(43740500002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?djRzSTM4eTdhRVdRa2pUR0ZsZ1ZBZEs3VXdSSjBvbFNXV3lLTjRwTDd5STVL?=
 =?utf-8?B?bEZRQldNMXV6eWNQWDNyTmRDOHI2OU44U2ZydHZ6VkFQZmI2RlRZbDNLMC9a?=
 =?utf-8?B?QVRkMUp1Nkh5T2phYnA1U1BrYlRENDF6TnpGR2c3ZmVFZjg5emIxVUdBMWF0?=
 =?utf-8?B?VEhiWXg1YnFsZU5NTkV6dEgyM2ZNckpIQUhjQUErUHo1MTd5YndMSXByRm1C?=
 =?utf-8?B?clFRTUVDL2sxVVRpYmFRekdNMHd4cXhCUEJ1bWF6NVBxVjQvVHBJbUpiU1ZS?=
 =?utf-8?B?R1A2SnV1UDBsVFRWM3lCaGZONDI3bDFPRkU4ZGpsaUNveXVKVWR3ZVEzN0Rj?=
 =?utf-8?B?ZEd0d2hFQWs4K2ZRN2p3M1QyMDVyenNGZ3V3djE2bG5vVnc0aG9MKzdYK3p1?=
 =?utf-8?B?dm9iZ1ZqSXUyUnJYZ2dod3ZGaWU3S3czaE1QSElDRGFhSVNMQTY3WWdXQlB0?=
 =?utf-8?B?a1B1aFpCdWpHWmovOGZBUUI0eGpreXIrOThDN1JZc1Z2SEY3N1N2US9USEI4?=
 =?utf-8?B?YlhTY2M2U1pIeng3OWZLeSs1QTZ6cUNsVG0vZ2ZucGNqYXJUUjJ4Qm5tWHBU?=
 =?utf-8?B?UlZOS1RuTlJSMVZPYXBKb29oenJNOWVXd2NHRWhITXhsQmh2a3FidHVEbzMv?=
 =?utf-8?B?MFN1TzJYNnNmOTljT1doS3BoeTcwbG9MVGE5RDd0SXlQdGZhTTczZkgreXE0?=
 =?utf-8?B?cldyaTVtSVM1MHJMbU9HSnZUcGMwa3N1VDJJMzI5WWdIUTUxbXRJQjkvMko0?=
 =?utf-8?B?cC8yelVhdDRWRWtWOTNKekdEUE9NSG5OQTZZUDJXMllhNCtQOHF1ZkNRSUUr?=
 =?utf-8?B?WlFEbTJEaUwyZGFaV2NLVVBaUFQvVjFFS3ZwYkRlTXBvMWtCTnIzZnAzOGZM?=
 =?utf-8?B?UnJmTHFEMmY3L3YxQzJvRmd0OEFoSVBxN29iZ2ZUKzkrOTJ3bG9CcFhTbnN6?=
 =?utf-8?B?a1FCajBwNUl4L0ZNZ0xUSDZ0MFBYZ3FFQXpqOUNGYkF6ZWRFOUFJb05mT2s2?=
 =?utf-8?B?c0lrNHhNbTZpYlhTcURjeHFRb0puaDBwTzExdC9wT1ZuZ3plUE1iVmIzZUZW?=
 =?utf-8?B?SnlMQTltVDlDVURHTEVvMENsbmJ5M0FIYzNmMGY0T3NxOWx3aU5UMW4xbVBG?=
 =?utf-8?B?d2JFUk44emxWdmN4Q29sUFFlZUdpS1dNZ0wxNnFwQXR1dG5WTE83TlFhcTZZ?=
 =?utf-8?B?d0dmLzU3UnF5Rlh6NGcvUHZtaFFlNThuTFpyaUtPTTU3QnRLVVdQb3ZSSklE?=
 =?utf-8?B?NlJzU1FGTDdCcUFTckRuYWdvMGF6eUg1NXJMak5JU0h2eStmdG5zU1dlUFU0?=
 =?utf-8?B?UlRBYUU3cER0a1JwTC9SSGVuWDVYTExlTWtkaERHeSs1ZGhML2NIbUhHTGFU?=
 =?utf-8?B?MHJaT202QzNYT3NJb0lLeHdUN0FKRE40TkJkdWkwTGFHeFJxUGZaU0dkR1VC?=
 =?utf-8?B?c2U2elh3MEovU01PcEYxSVl0SnFtSTI4SEFoZk42eWNNOCt3T2E1d1NzNEpW?=
 =?utf-8?B?cEtoVE5WU3Q4NjBSMzJFQkxjbWtES25JV0dIeS9wRGg5bW1MeFhxR2p1ZGVo?=
 =?utf-8?B?amRUR0VseDI5Z3IrRFBRWE42ZUVBVVlldmhpbjlxNGYyc2FiazRJNGg1eVZU?=
 =?utf-8?B?NnNoNGVFUWhDbGtWcFNWNDNiQk9zNWpsVGVEL0w5SldySC90eWVSRnIrYUtB?=
 =?utf-8?B?Q3lFMnBZb0JybVlpaDRRN015M1d5UTlUVzlLaG9MUEJLK2liMjRKYzgzY2xO?=
 =?utf-8?Q?SKtrcmo24Bm7jjrciw=3D?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <AABD9475891B1C469FB27D1BE491DD83@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20643232-1a61-4043-0291-08d95c6049dd
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Aug 2021 00:38:07.3819
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: YWY4PKPRIDfTKhN4HbmkzasxM2e1YMWid7BYY7CpQ00hHM6o4UTHSHKBetEskC+m8DKlETCfGngoMsewVu4C/upkjaJudN4NdgTgc41g5NI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4587
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOC8xMC8yMDIxIDM6MzEgUE0sIEFuZHJldyBMdW5uIHdyb3RlOg0KPiBPbiBUdWUsIEF1ZyAx
MCwgMjAyMSBhdCAwMzowNjozNlBNIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToNCj4+IE9u
IFR1ZSwgMTAgQXVnIDIwMjEgMjI6MDA6NTEgKzAwMDAgS2VsbGVyLCBKYWNvYiBFIHdyb3RlOg0K
Pj4+Pj4gSmFrZSBkbyB5b3Uga25vdyB3aGF0IHRoZSB1c2UgY2FzZXMgZm9yIEludGVsIGFyZT8g
QXJlIHRoZXkgU0ZQLCBNQUMsDQo+Pj4+PiBvciBOQy1TSSByZWxhdGVkPyAgDQo+Pj4+DQo+Pj4+
IEkgd2VudCB0aHJvdWdoIGFsbCB0aGUgSW50ZWwgZHJpdmVycyB0aGF0IGltcGxlbWVudCB0aGVz
ZSBvcGVyYXRpb25zIGFuZA0KPj4+PiBJIGJlbGlldmUgeW91IGFyZSB0YWxraW5nIGFib3V0IHRo
ZXNlIGNvbW1pdHM6DQo+Pj4+DQo+Pj4+IGh0dHBzOi8vZ2l0Lmtlcm5lbC5vcmcvcHViL3NjbS9s
aW51eC9rZXJuZWwvZ2l0L3RvcnZhbGRzL2xpbnV4LmdpdC9jb21taXQvP2lkPWMzODgwYmQxNTlk
NDMxZDA2YjY4N2IwYjVhYjIyZTI0ZTZlZjAwNzANCj4+Pj4gaHR0cHM6Ly9naXQua2VybmVsLm9y
Zy9wdWIvc2NtL2xpbnV4L2tlcm5lbC9naXQvdG9ydmFsZHMvbGludXguZ2l0L2NvbW1pdC8/aWQ9
ZDVlYzllMmNlNDFhYzE5OGRlMmVlMThlMGU1MjliN2ViYmM2NzQwOA0KPj4+PiBodHRwczovL2dp
dC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dpdC90b3J2YWxkcy9saW51eC5naXQv
Y29tbWl0Lz9pZD1hYjRhYjczZmMxZWM2ZGVjNTQ4ZmEzNmM1ZTM4M2VmNWZhYTdiNGMxDQo+Pj4+
DQo+Pj4+IFRoZXJlIGlzbid0IHRvbyBtdWNoIGluZm9ybWF0aW9uIGFib3V0IHRoZSBtb3RpdmF0
aW9uLCBidXQgbWF5YmUgaXQgaGFzDQo+Pj4+IHNvbWV0aGluZyB0byBkbyB3aXRoIG11bHRpLWhv
c3QgY29udHJvbGxlcnMgd2hlcmUgeW91IHdhbnQgdG8gcHJldmVudA0KPj4+PiBvbmUgaG9zdCBm
cm9tIHRha2luZyB0aGUgcGh5c2ljYWwgbGluayBkb3duIGZvciBhbGwgdGhlIG90aGVyIGhvc3Rz
DQo+Pj4+IHNoYXJpbmcgaXQ/IEkgcmVtZW1iZXIgc3VjaCBpc3N1ZXMgd2l0aCBtbHg1Lg0KPj4+
PiAgIA0KPj4+DQo+Pj4gT2ssIEkgZm91bmQgc29tZSBtb3JlIGluZm9ybWF0aW9uIGhlcmUuIFRo
ZSBwcmltYXJ5IG1vdGl2YXRpb24gb2YgdGhlDQo+Pj4gY2hhbmdlcyBpbiB0aGUgaTQwZSBhbmQg
aWNlIGRyaXZlcnMgaXMgZnJvbSBjdXN0b21lciByZXF1ZXN0cyBhc2tpbmcgdG8NCj4+PiBoYXZl
IHRoZSBsaW5rIGdvIGRvd24gd2hlbiB0aGUgcG9ydCBpcyBhZG1pbmlzdHJhdGl2ZWx5IGRpc2Fi
bGVkLiBUaGlzDQo+Pj4gaXMgYmVjYXVzZSBpZiB0aGUgbGluayBpcyBkb3duIHRoZW4gdGhlIHN3
aXRjaCBvbiB0aGUgb3RoZXIgc2lkZSB3aWxsDQo+Pj4gc2VlIHRoZSBwb3J0IG5vdCBoYXZpbmcg
bGluayBhbmQgd2lsbCBzdG9wIHRyeWluZyB0byBzZW5kIHRyYWZmaWMgdG8gaXQuDQo+Pj4NCj4+
PiBBcyBmYXIgYXMgSSBjYW4gdGVsbCwgdGhlIHJlYXNvbiBpdHMgYSBmbGFnIGlzIGJlY2F1c2Ug
c29tZSB1c2VycyB3YW50ZWQNCj4+PiB0aGUgYmVoYXZpb3IgdGhlIG90aGVyIHdheS4NCj4+Pg0K
Pj4+IEknbSBub3Qgc3VyZSBpdCdzIHJlYWxseSByZWxhdGVkIHRvIHRoZSBiZWhhdmlvciBoZXJl
Lg0KPj4NCj4+IEkgdGhpbmsgdGhlIHF1ZXN0aW9uIHdhcyB0aGUgaW52ZXJzZSAtIHdoeSBub3Qg
YWx3YXlzIHNodXQgZG93biB0aGUNCj4+IHBvcnQgaWYgdGhlIGludGVyZmFjZSBpcyBicm91Z2h0
IGRvd24/DQo+IA0KPiBIdW1tLiBTb21ldGhpbmcgZG9lcyBub3Qgc2VlbSByaWdodCBoZXJlLiBJ
IHdvdWxkIGFzc3VtZSB0aGF0IHdoZW4geW91DQo+IGFkbWluaXN0cmF0aXZlbHkgY29uZmlndXJl
IHRoZSBsaW5rIGRvd24sIHRoZSBTRVJERVMgaW4gdGhlIE1BQyB3b3VsZA0KPiBzdG9wIHNlbmRp
bmcgYW55dGhpbmcuIFNvIHRoZSBtb2R1bGUgaGFzIG5vdGhpbmcgdG8gc2VuZC4gVGhlIGxpbmsN
Cj4gcGVlciBTRVJERVMgdGhlbiBsb29zZXMgc3luYywgYW5kIHJlcG9ydHMgdGhhdCB1cHdhcmRz
IGFzIGNhcnJpZXINCj4gbG9zdC4NCj4gDQoNClJpZ2h0Li4uLg0KDQo+IERvZXMgdGhlIGk0MGUg
YW5kIGljZSBsZWF2ZSBpdHMgU0VSREVTIHJ1bm5pbmcgd2hlbiB0aGUgbGluayBpcw0KPiBjb25m
aWd1cmVkIGRvd24/IE9yIGlzIHRoZSBzd2l0Y2ggRlVCQVIgYW5kIGRvZXMgbm90IGNvbnNpZGVy
IFNFUkRFUw0KPiBsb3NzIG9mIHN5bmMgYXMgY2FycmllciBkb3duPw0KPg0KDQoNCkl0J3Mgbm90
IGNsZWFyIHRvIG1lLiBJIHRyaWVkIHRvIHRlc3Qgd2l0aCB0aGUgZHJpdmVyLCBhbmQgaXQgbG9v
a3MgbGlrZQ0KdXBzdHJlYW0gZG9lc24ndCB5ZXQgaGF2ZSB0aGUgbGluay1kb3duLW9uLWNsb3Nl
IG1lcmdlZCBpbnRvIG5ldC1uZXh0LA0Kc28gSSBncmFiYmVkIG91ciBvdXQtb2YtdHJlZSBkcml2
ZXIuDQoNCkludGVyZXN0aW5nbHksIGJvdGggaXAgbGluayBzaG93IGFuZCBldGh0b29sIGRvIG5v
dCByZXBvcnQgbGluayBhcyB1cA0Kd2hlbiB0aGUgZGV2aWNlIGlzIGNsb3NlZCAoaXAgbGluayBz
ZXQgZW5wMTc1ZjBzMCBkb3duKS4uLi4uDQoNClNvLi4uIHdoYXRldmVyIGRpZmZlcmVuY2UgbGlu
ay1kb3duLW9uLWNsb3NlIG1ha2VzIHdlJ3JlIGRlZmluaXRlbHkgbm90DQpyZXBvcnRpbmcgdGhp
bmdzIHVwLg0KDQoNCkkgZG9uJ3QgaGF2ZSBhIHNldHVwIHRvIGNvbmZpcm0gYW55dGhpbmcgZWxz
ZSByaWdodCBub3cgdW5mb3J0dW5hdGVseSwNCmJ1dCBJIHN1c3BlY3Qgc29tZXRoaW5nIGlzIHdy
b25nIHdpdGggdGhlIGltcGxlbWVudGF0aW9uIG9mDQpsaW5rLWRvd24tb24tY2xvc2UgKGF0IHRo
ZSB2ZXJ5IGxlYXN0IGl0IHNlZW1zIGxpa2Ugd2Ugc2hvdWxkIHN0aWxsIGJlDQpyZXBvcnRpbmcg
TE9XRVJfVVAuLi4uIG5vPykNCg0KVW5sZXNzIHRoZXJlJ3Mgc29tZSBvdGhlciB3ZWlyZG5lc3Mg
bGlrZSB3aXRoIFFTRlAgb3Igb3RoZXINCm11bHRpLXBvcnQtc2luZ2xlLWNhYmxlIHNldHVwcz8N
Cg0KSSBldmVuIHRyaWVkIGFkZGluZyBzb21lIFZGcyBhbmQgSSBzZWUgdGhhdCByZWdhcmRsZXNz
IG9mIHdoZXRoZXINCmxpbmstZG93bi1vbi1jbG9zZSBpcyBzZXQsIEkgY2FuIHNlZSBsaW5rIHVw
IG9uIHRoZSBWRi4uLi4NCg0KSG1tbW1tLg0KDQo+IElkbydzIHVzZSBjYXNlIGRvZXMgc2VlbSB0
byBiZSBkaWZmZXJlbnQuIFRoZSBsaW5rIGlzIGRvd24uIERvIHdlIHdhbnQNCj4gdG8gbGVhdmUg
dGhlIG1vZHVsZSBhY3RpdmUsIHByb2JhYmx5IHNlbmRpbmcgYSBiaXQgc3RyZWFtIG9mIGFsbCAw
LA0KPiBtYXliZSBub2lzZSwgb3IgZG8gd2Ugd2FudCB0byBwb3dlciB0aGUgbW9kdWxlIGRvd24s
IHNvIGl0IGRvZXMgbm90DQo+IHNlbmQgYW55dGhpbmcgYXQgYWxsLg0KPiANCj4gICAgICBBbmRy
ZXcNCj4gDQoNClJpZ2h0LCBJIHRoaW5rIHRoZXNlIHR3byBjYXNlcyBhcmUgdmVyeSBkaWZmZXJl
bnQuDQo=
