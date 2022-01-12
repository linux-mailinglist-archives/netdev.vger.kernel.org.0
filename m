Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1FFD48C0FF
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 10:30:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352049AbiALJa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 04:30:29 -0500
Received: from mga01.intel.com ([192.55.52.88]:18207 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238137AbiALJa2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 Jan 2022 04:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641979828; x=1673515828;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3wPeeTccvqWcEyU705xzkfaTYxQ/IXB3IHu2V0svqto=;
  b=NPP565eU1Uqju5x+bvjQjAvtlalCIhDI+nSItWQrSYb+xWToLA+C0LaV
   t73jXYkptbueXcLCpr9/DjGC1oJdAwoA/LLLZcqdrVFeJqc62R70xCIVO
   mcgUjQGGvvPPg/dwG8J1dHqREYDw7xBOLlb73T6mZhotLIdGbQt4XCNbz
   k8+TfqoTITMwwYMAdDj/d87dAdo8kWAF0JDteqoTDmsk6CrSnjDLDVR+R
   g6Xk9cEkUhRnT1u80A+BVhFvsJqm1CsEarOKIq8t6jBAWOpWSrfCNHS2S
   DKYvq7/5K7Wa2W3L87kLwARz2SA0AnhF+NLapRg7yHh/4TBPWWzf95tmO
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10224"; a="268041767"
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="268041767"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jan 2022 01:30:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,282,1635231600"; 
   d="scan'208";a="490685529"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga002.jf.intel.com with ESMTP; 12 Jan 2022 01:30:27 -0800
Received: from orsmsx606.amr.corp.intel.com (10.22.229.19) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Wed, 12 Jan 2022 01:30:26 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Wed, 12 Jan 2022 01:30:26 -0800
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.172)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Wed, 12 Jan 2022 01:30:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Qaz8QBrAN5OHIRXvnz3mbaxXpfXBoT4lwO4dlZTrjzm0D7Ji35QaJ6Q7DnAa9LgEM415Xx4CfpcvRxQNYUtZCalBmWm1kAXUa7dRXyUKzMPsam50cmPW3GioZMY1y5hz6PgUQEP2yiUD1hoRaTaCtCaXfTy9PRtzZ3x8BpLTDRkZrzenozbKvNgX/V09WXcrgG6yrM2l4gH56rq1y2wJ7akY0OxqBiYIuYk2jQ/NtS9Ve8iJvGgnehS2k2QZpGZKPynej4you6u8kaMp8JCHnYCGCBneJx1XyiFWMkLP/g5FSlER/FuVxDMJ9amDzzGjnTeaiVcxSuO5FRJwcY+4bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3wPeeTccvqWcEyU705xzkfaTYxQ/IXB3IHu2V0svqto=;
 b=f9lyv2mocbcO8qeIZzZO7F1/Cj4InbABLu+UmTgvSAEf/Gcj2t1YRpWBF7kAw/HhhkbLPcwqz+SUwpfihNLjlJtI7yH45NKbCjVgSLJHm8Ieh48/VYFPu4L1LUqwSfBPdH0pSh9cZP2+nX6kqwCsXZtbKEYUn7bUhImXI9+up6nwByaeZwl2FIkW9cIp7NLarKfqleCeQzRBP6qr3UHn2nOWv+JeFeyKhBCFbU4psIvvlLdhhWngkaKUvZyGRG+InaMkjk9edO4hpJero2eSJ5RKYdcDpBVc6eHn+NPAMTrHbAWlDcS4m5VCmkhzjw1rsRV8Wcfgz0ow2m++S4wxAg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB4771.namprd11.prod.outlook.com (2603:10b6:303:9f::9)
 by MWHPR11MB1278.namprd11.prod.outlook.com (2603:10b6:300:1d::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Wed, 12 Jan
 2022 09:30:25 +0000
Received: from CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088]) by CO1PR11MB4771.namprd11.prod.outlook.com
 ([fe80::4843:15c6:62c1:d088%3]) with mapi id 15.20.4888.011; Wed, 12 Jan 2022
 09:30:25 +0000
From:   "Ismail, Mohammad Athari" <mohammad.athari.ismail@intel.com>
To:     Heiner Kallweit <hkallweit1@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Oleksij Rempel <linux@rempel-privat.de>,
        Russell King <linux@armlinux.org.uk>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Topic: [PATCH net 1/1] net: phy: marvell: add Marvell specific PHY
 loopback
Thread-Index: AQHYBepnvfJifzbICkqWD8xlExtYIaxb7dCAgAAPa/CAAA1dAIADFwdw
Date:   Wed, 12 Jan 2022 09:30:25 +0000
Message-ID: <CO1PR11MB477122437E5628C83A153720D5529@CO1PR11MB4771.namprd11.prod.outlook.com>
References: <20220110062117.17540-1-mohammad.athari.ismail@intel.com>
 <20220110062117.17540-2-mohammad.athari.ismail@intel.com>
 <1be1444c-b1f7-b7d6-adaa-78960c381161@gmail.com>
 <CO1PR11MB4771E08DD8C8CAE63E7A9A54D5509@CO1PR11MB4771.namprd11.prod.outlook.com>
 <95b539d2-f72a-f967-c670-2aa37cb5039b@gmail.com>
In-Reply-To: <95b539d2-f72a-f967-c670-2aa37cb5039b@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 9dec9f80-fae1-44c3-9a91-08d9d5ae2a02
x-ms-traffictypediagnostic: MWHPR11MB1278:EE_
x-microsoft-antispam-prvs: <MWHPR11MB12787D13C3849338B195D3F5D5529@MWHPR11MB1278.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: roZAHASAKjhoMD98+AEGAfUPtS8QRsLRq0vvJhMwfhGjkhBTlIqzrXqJy5SXTluFkst9kkldsmBLcJM2Wbmo2EYe5b+nMjBOwuXn0sb6ljArR5rN+ah20SJf2IILQnl0mHNhxqAzMmsyjhfo3vTw/F8DI6VdyRvjbLe6TxS/DXfpbcfrFnPDw0XXbDUpe5O5wciAArouvRu3HwwRzubt4nUxuG3RpXPmKGHG7Q5Xs3Hxkc8W7Q/T/9s6RkJz8AwfU0Ito+Ohf6OnchokGqNxwQrt+MoLxREgWaQjdySVdFApCjaD85B/9o4iQxiNTLgIq6tghf96IkSNBCvna1H72ylOZVE5dvi0cy9k4RRAWHw6cC7KQcH8RU4JAwErGDv3CjfbNMgk2RPE14EgmolBN8MiqHeb67SbLSrPWThgWMs0nNUCrdLodfo8N4CKqKmXjcb9aFrHjGfHw6fJyju7HB2mz/9s05TiaNCCR+ZwlcWcs7Bq9apXW3bSFkbuzwMj9Vo18kw+ImidITqkp4CWN6VCPdbDmXq49w+WPshWEw4fViXZajd/0Un1iVO3SB15xIExc5p1RkVGV6uTpY80+6nxrJswyL8YibTPfGjxqVxiWKabBvA+n8Dp0o27+bH0I3oymhULoGgliYONrBYWw8yhw6hnTVefGvkP4MyPqdcmwqCrXUD0UNRkuPJlK1fbs7GxTR+wbwPiBk9+W8OAew==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB4771.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55236004)(53546011)(66446008)(38070700005)(26005)(66476007)(64756008)(66556008)(6506007)(38100700002)(186003)(8936002)(8676002)(55016003)(7696005)(508600001)(122000001)(5660300002)(52536014)(4326008)(54906003)(110136005)(316002)(76116006)(9686003)(66946007)(83380400001)(2906002)(71200400001)(33656002)(86362001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?VGkxZFlYZkZraHZqWHNkNG14a0lQVUs2RjU5SnhxZWxsOUdJV3plVWlGT1gz?=
 =?utf-8?B?bGlJU3N6Qmg2elZzdUJhL3JlbnBpNWUvVW9hdERZUitVakxvNm0wTk9QbENP?=
 =?utf-8?B?czVrWmxzRHdYbFRaaHd2bkdyd1VPOVpJblBXaW5aZlJsR05xOFVhWU1Zb0Zt?=
 =?utf-8?B?Tlpzd1BKZXo0N3lqZlg2WWhTZS9sRTBYNmkzMUlEOHAzTlBGN09YeDlrMmV0?=
 =?utf-8?B?UGE1dlJlVzkzM3BIZDNXUGIwYm1PcWtSRmdIc1VlL3pGTG5iTzRuR2l5OXlt?=
 =?utf-8?B?bjdtK3JLbTZWUkQwYWx6czVwSjR4dDVnZGxnTjFYMjZJTVM3d1hDby9JQTlH?=
 =?utf-8?B?K3pMcjQxUG5DUGE0VEhMQUZsKzQ5VHgvS0E1OWNFRm9zRE5VOW15R1ZGQ0Nw?=
 =?utf-8?B?Y0dqWjc2aU5sRkdJdW94bDdYU0lwdHVlMG1ScnNNMy9qZG9MVUM3bk9EZlRN?=
 =?utf-8?B?ZnF1RU1pa2cyNlBRdnVlNktHS0RHQ01mdmsxeVhPQ0ZXd0J3anR5dWc0SlpJ?=
 =?utf-8?B?L2dTZ0ZVTFVoSkppZ2d5WFpHS2xzQlVPOWd3U01pS0Rsb25yQ2JrUkdMVW9v?=
 =?utf-8?B?T09RZkNGUjNHU3l0R1VpalpCM1BQZjVTVytUWU5xOVRKdGJUMHZxTXc0c3F6?=
 =?utf-8?B?MnQweXJvdkhkKzdkTk1FTW5Pd09kNUdoeG1kQ054bDhMbGNwbXNWN210Tmlj?=
 =?utf-8?B?dE9VcHYxUW1ib2RPMmpFdWl2cFp5UU9UUTBwRkptL21kVzhlbmtpOVF3VFZL?=
 =?utf-8?B?QngzblFBKys0c0FmaXN1OFNEY2dqY2JjY1dzUFA0U3ZLakwyRVNEMHFFcmRn?=
 =?utf-8?B?OVZIRjVjK01YTnJHVlBnME91eHNtQVAreFVXQ2Q2MENUTmMycFZoem1xRHpO?=
 =?utf-8?B?Qm9vWDNyMm84ak9TVlF0ZU40dDRxWlJrdVd5NWVmZ1hHN3pRN2FHVmNzVXVE?=
 =?utf-8?B?SnpJWWNSNXQ3MmR2bkVWZmpoYjN1OTJRaXU1SGFWbTd2Witjd1o5TENMdlF4?=
 =?utf-8?B?TUNUNzIvcjJzWmVHdzNaQUhURGZFcS94a0hFVTMzY0JSdDA2Zzl2Vm5XRnNl?=
 =?utf-8?B?MXN3RG9UQmdJMTBVcG9ZRm9wNUhFTklEempRN3V6OXdlVmE2a0ZkTWNscm41?=
 =?utf-8?B?OXM4TVJHczk0cGxST2ZjSzJ6YnJuakRQMFFVWm43dHo3Wm0zUmkzQXQ2K2Yz?=
 =?utf-8?B?NjFFUmZFeW5QRUVPM3NVcS9EOGZWRUd2VmRPSFpNeUlQdFhVRFFjOWFoL0xr?=
 =?utf-8?B?MVhKQXVuZWVKZk1iYUJ4QjFVbmJ5SFdZaDMrM1lyUnFEOHh5TGZydi9ZZDEx?=
 =?utf-8?B?VkliZkVNMTNtaEp6Yk42K2tFTlVxT0NZaWlWUXRadm5tV2lId3R2WkxISldn?=
 =?utf-8?B?SERoUjhIUHZRcVhWZy9JeTI4UW1rNllneWVLWnRRK3dlTmpVaGdRdEdYMlU2?=
 =?utf-8?B?ZjNTSHlkazcrY1RKTjJVWjB4Tnl0SHdIb1BYUGNrZVdIRUJEZWpaY29jMHRw?=
 =?utf-8?B?QU5rYnVpc1dSOGJJcFZ6NDd0dE90eEVXYy9kZFdPbWFKRFpMOE9BcXVlNkdw?=
 =?utf-8?B?OVN1anNDb2h0TktncnpqRzh6bHRZc2t2WDc3ZE9ZQ0JYVExSMmx4Z1hYWjl5?=
 =?utf-8?B?VjFjUThUdjluU0xkaVpzaVpQWEp5THNBREx3RERKaVgreFZvWVhRWDBhRGlH?=
 =?utf-8?B?bk9DczdrakV1aXRWaUVqVW05Si9hbTIyTVhwdEdvZTh4VlVsOVg1aFd1RG1r?=
 =?utf-8?B?d29QZHFKZTBIbDhJR1h6aHpkbDVPaktuT2VLYXcrTExZVWM5dHJ1SlQ3RWFw?=
 =?utf-8?B?TStTYnBUazVGNnNOWjNycmcxSU5ZTVJjeWhway90dEE5L1E2Y3V0UlNiNlJh?=
 =?utf-8?B?bVIwbk1RQlhKdmUrZ1hMNnY4Zk9GTStBS2NQRzB1bDdMSytDaElVMDhZTmRz?=
 =?utf-8?B?NHpPSjV2SGlDWjZ1UTByZFh5Z2h1RUpGL3BOblRaZENxQkdQRGNFc2I4N1hr?=
 =?utf-8?B?UEYwd2IybEhkTXNKL3IyekZWb1dxR0RraEdOWENEWUpBU3NZaFl2SjBFVmRG?=
 =?utf-8?B?bG1SVWpqanh1SEF2QkU4b3lRZVpSZUxTcERxZ2JpcDBzMTAwZUNGVlBTaHlu?=
 =?utf-8?B?bURtWE5iSWdOaVBmc2V2clovRWs1M3RsNnN4K1Y5eW1LaDVxbEhGdHZ2TjFk?=
 =?utf-8?B?WEdaNk5zOGw1TW8wV2h6bFhUSzVmbjZVQkdZa2VKbFhiOFY5T0p3MXc2WWVW?=
 =?utf-8?B?Vjc3Q05jL2c4RytRMEljT2pualZqUTZPRXBNRThNWDRiejd4N2lIeXFCTjdv?=
 =?utf-8?B?WGFVaXc4bmkwcU00TlNPb1ZFSTU2RnM3WStseG5mM1puYkVwQjlrZz09?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB4771.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dec9f80-fae1-44c3-9a91-08d9d5ae2a02
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Jan 2022 09:30:25.4694
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FrUKSnwSsZ24MAjtp560mo5l5SjdE2NshsFlRTCcplSmt+5S2+ahXg8ovjBQzmjltlflN4XELaT3sjwxfsfcz/sX1LrHzQuyQZCN+fuBrzwATEKAfGbN5AowgKqGROca
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1278
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogSGVpbmVyIEthbGx3ZWl0
IDxoa2FsbHdlaXQxQGdtYWlsLmNvbT4NCj4gU2VudDogTW9uZGF5LCBKYW51YXJ5IDEwLCAyMDIy
IDY6MTcgUE0NCj4gVG86IElzbWFpbCwgTW9oYW1tYWQgQXRoYXJpIDxtb2hhbW1hZC5hdGhhcmku
aXNtYWlsQGludGVsLmNvbT47DQo+IEFuZHJldyBMdW5uIDxhbmRyZXdAbHVubi5jaD47IERhdmlk
IFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+Ow0KPiBKYWt1YiBLaWNpbnNraSA8a3Vi
YUBrZXJuZWwub3JnPjsgT2xla3NpaiBSZW1wZWwgPGxpbnV4QHJlbXBlbC0NCj4gcHJpdmF0LmRl
PjsgUnVzc2VsbCBLaW5nIDxsaW51eEBhcm1saW51eC5vcmcudWs+DQo+IENjOiBuZXRkZXZAdmdl
ci5rZXJuZWwub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnOw0KPiBzdGFibGVAdmdl
ci5rZXJuZWwub3JnDQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggbmV0IDEvMV0gbmV0OiBwaHk6IG1h
cnZlbGw6IGFkZCBNYXJ2ZWxsIHNwZWNpZmljIFBIWQ0KPiBsb29wYmFjaw0KPiANCj4gT24gMTAu
MDEuMjAyMiAxMDozNiwgSXNtYWlsLCBNb2hhbW1hZCBBdGhhcmkgd3JvdGU6DQo+ID4NCj4gPg0K
PiA+PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiA+PiBGcm9tOiBIZWluZXIgS2FsbHdl
aXQgPGhrYWxsd2VpdDFAZ21haWwuY29tPg0KPiA+PiBTZW50OiBNb25kYXksIEphbnVhcnkgMTAs
IDIwMjIgNDozNCBQTQ0KPiA+PiBUbzogSXNtYWlsLCBNb2hhbW1hZCBBdGhhcmkgPG1vaGFtbWFk
LmF0aGFyaS5pc21haWxAaW50ZWwuY29tPjsNCj4gPj4gQW5kcmV3IEx1bm4gPGFuZHJld0BsdW5u
LmNoPjsgRGF2aWQgUyAuIE1pbGxlcg0KPiA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47DQo+ID4+IEph
a3ViIEtpY2luc2tpIDxrdWJhQGtlcm5lbC5vcmc+OyBPbGVrc2lqIFJlbXBlbCA8bGludXhAcmVt
cGVsLQ0KPiA+PiBwcml2YXQuZGU+OyBSdXNzZWxsIEtpbmcgPGxpbnV4QGFybWxpbnV4Lm9yZy51
az4NCj4gPj4gQ2M6IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc7DQo+ID4+IHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gPj4gU3ViamVjdDogUmU6
IFtQQVRDSCBuZXQgMS8xXSBuZXQ6IHBoeTogbWFydmVsbDogYWRkIE1hcnZlbGwgc3BlY2lmaWMN
Cj4gPj4gUEhZIGxvb3BiYWNrDQo+ID4+DQo+ID4+IE9uIDEwLjAxLjIwMjIgMDc6MjEsIE1vaGFt
bWFkIEF0aGFyaSBCaW4gSXNtYWlsIHdyb3RlOg0KPiA+Pj4gRXhpc3RpbmcgZ2VucGh5X2xvb3Bi
YWNrKCkgaXMgbm90IGFwcGxpY2FibGUgZm9yIE1hcnZlbGwgUEhZLiBTbywNCj4gPj4+IGFkZGlu
ZyBNYXJ2ZWxsIHNwZWNpZmljIFBIWSBsb29wYmFjayBvcGVyYXRpb24gYnkgb25seQ0KPiA+Pj4g
c2V0dGluZyhlbmFibGUpIG9yDQo+ID4+PiBjbGVhcmluZyhkaXNhYmxlKSBCTUNSX0xPT1BCQUNL
IGJpdC4NCj4gPj4+DQo+ID4+PiBUZXN0ZWQgd29ya2luZyBvbiBNYXJ2ZWxsIDg4RTE1MTAuDQo+
ID4+Pg0KPiA+PiBXaXRoIHRoaXMgY2hhbmdlIHlvdSdkIGJhc2ljYWxseSByZXZlcnQgdGhlIG9y
aWdpbmFsIGNoYW5nZSBhbmQgbG9vc2UNCj4gPj4gaXRzIGZ1bmN0aW9uYWxpdHkuIERpZCB5b3Ug
Y2hlY2sgdGhlIE1hcnZlbGwgZGF0YXNoZWV0cz8NCj4gPj4gQXQgbGVhc3QgZm9yIGZldyB2ZXJz
aW9ucyBJIGZvdW5kIHRoYXQgeW91IG1heSBoYXZlIHRvIGNvbmZpZ3VyZSBiaXRzDQo+ID4+IDAu
LjIgaW4gTUFDIFNwZWNpZmljIENvbnRyb2wgUmVnaXN0ZXIgMiAocGFnZSAyLCByZWdpc3RlciAy
MSkgaW5zdGVhZCBvZg0KPiBCTUNSLg0KPiA+DQo+ID4gTWF5IEkga25vdyB3aGF0IGRhdGFzaGVl
dCB2ZXJzaW9uIHRoYXQgaGFzIHRoZSBiaXRzIDI6MCdzIGRldGFpbA0KPiBleHBsYW5hdGlvbj8g
VGhlIHZlcnNpb24gdGhhdCBJIGhhdmUsIGJpdHMgMjowIGluIE1BQyBTcGVjaWZpYyBDb250cm9s
IFJlZ2lzdGVyDQo+IDIgc2hvd3MgYXMgUmVzZXJ2ZWQuDQo+ID4gVGhlIGRhdGFzaGVldCBJIGhh
dmUgaXMgIk1hcnZlbGwgQWxhc2thIDg4RTE1MTAvODhFMTUxOC84OEUxNTEyLzg4RTE1MTQNCj4g
SW50ZWdyYXRlZCAxMC8xMDAvMTAwMCBNYnBzIEVuZXJneSBFZmZpY2llbnQgRXRoZXJuZXQgVHJh
bnNjZWl2ZXIgUmV2LiBHDQo+IERlY2VtYmVyIDE3LCAyMDIxIg0KPiA+DQo+IEkgY2hlY2tlZCB0
aGUgODhFNjM1MiBzd2l0Y2ggY2hpcCBkYXRhc2hlZXQuIFRoZSBwYXJ0IGNvdmVyaW5nIHRoZQ0K
PiBpbnRlZ3JhdGVkIFBIWSdzIGxpc3RzIHRoZSBtZW50aW9uZWQgYml0cyBpbiBNQUMgU3BlY2lm
aWMgQ29udHJvbCBSZWdpc3RlciAyLg0KPiANCj4gVGFibGUgNzUgaW4gdGhlIDg4RTE1MTAgZGF0
YXNoZWV0IHNheXM6IExvb3BiYWNrIHNwZWVkIGlzIGRldGVybWluZWQgYnkNCj4gUmVnaXN0ZXJz
IDIxXzIuNiwxMy4NCj4gU28gTWFydmVsbCBQSFkncyBzZWVtIHRvIHVzZSBkaWZmZXJlbnQgYml0
cyAoYWx0aG91Z2ggc2FtZSByZWdpc3RlcikgZm9yDQo+IGxvb3BiYWNrIHNwZWVkIGNvbmZpZ3Vy
YXRpb24uDQoNCkkgZ2V0IHlvdXIgcG9pbnQuIFJlZ2lzdGVycyAyMV8yLjYsMTMgYWxzbyBuZWVk
IHRvIGJlIGNvbmZpZ3VyZWQgZm9yIGxvb3BiYWNrIHRvIHdvcmsgZm9yIGFsbCBzcGVlZHMuDQpJ
J2xsIHNlbmQgdGhlIHYyIHBhdGNoIGxhdGVyLg0KDQotQXRoYXJpLQ0KDQo+IA0KPiA+IFJlYWxs
eSBhcHByZWNpYXRlIGlmIHlvdSBjb3VsZCBhZHZpY2Ugb24gUEhZIGxvb3BiYWNrIGVuYWJsaW5n
IGZvciBNYXJ2ZWxsDQo+IDg4RTE1MTAgYmVjYXVzZSB0aGUgZXhpc3RpbmcgZ2VucGh5X2xvb3Bi
YWNrKCkgZnVuY3Rpb24gZG9lc24ndCB3b3JrIGZvcg0KPiB0aGUgUEhZLg0KPiA+DQo+ID4gVGhh
bmsgeW91Lg0KPiA+DQo+ID4gLUF0aGFyaS0NCj4gPg0KPiA+Pg0KPiA+Pg0KPiA+Pj4gRml4ZXM6
IDAxNDA2OGRjYjViMSAoIm5ldDogcGh5OiBnZW5waHlfbG9vcGJhY2s6IGFkZCBsaW5rIHNwZWVk
DQo+ID4+PiBjb25maWd1cmF0aW9uIikNCj4gPj4+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9y
Zz4gIyA1LjE1LngNCj4gPj4+IFNpZ25lZC1vZmYtYnk6IE1vaGFtbWFkIEF0aGFyaSBCaW4gSXNt
YWlsDQo+ID4+PiA8bW9oYW1tYWQuYXRoYXJpLmlzbWFpbEBpbnRlbC5jb20+DQo+ID4+PiAtLS0N
Cj4gPj4+ICBkcml2ZXJzL25ldC9waHkvbWFydmVsbC5jIHwgOCArKysrKysrLQ0KPiA+Pj4gIDEg
ZmlsZSBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkNCj4gPj4+DQo+ID4+
PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvcGh5L21hcnZlbGwuYyBiL2RyaXZlcnMvbmV0L3Bo
eS9tYXJ2ZWxsLmMNCj4gPj4+IGluZGV4IDRmY2ZjYTRlMTcwMi4uMmE3M2E5NTliNDhiIDEwMDY0
NA0KPiA+Pj4gLS0tIGEvZHJpdmVycy9uZXQvcGh5L21hcnZlbGwuYw0KPiA+Pj4gKysrIGIvZHJp
dmVycy9uZXQvcGh5L21hcnZlbGwuYw0KPiA+Pj4gQEAgLTE5MzIsNiArMTkzMiwxMiBAQCBzdGF0
aWMgdm9pZCBtYXJ2ZWxsX2dldF9zdGF0cyhzdHJ1Y3QNCj4gPj4+IHBoeV9kZXZpY2UNCj4gPj4g
KnBoeWRldiwNCj4gPj4+ICAJCWRhdGFbaV0gPSBtYXJ2ZWxsX2dldF9zdGF0KHBoeWRldiwgaSk7
ICB9DQo+ID4+Pg0KPiA+Pj4gK3N0YXRpYyBpbnQgbWFydmVsbF9sb29wYmFjayhzdHJ1Y3QgcGh5
X2RldmljZSAqcGh5ZGV2LCBib29sIGVuYWJsZSkgew0KPiA+Pj4gKwlyZXR1cm4gcGh5X21vZGlm
eShwaHlkZXYsIE1JSV9CTUNSLCBCTUNSX0xPT1BCQUNLLA0KPiA+Pj4gKwkJCSAgZW5hYmxlID8g
Qk1DUl9MT09QQkFDSyA6IDApOw0KPiA+Pj4gK30NCj4gPj4+ICsNCj4gPj4+ICBzdGF0aWMgaW50
IG1hcnZlbGxfdmN0NV93YWl0X2NvbXBsZXRlKHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXYpICB7
DQo+ID4+PiAgCWludCBpOw0KPiA+Pj4gQEAgLTMwNzgsNyArMzA4NCw3IEBAIHN0YXRpYyBzdHJ1
Y3QgcGh5X2RyaXZlciBtYXJ2ZWxsX2RyaXZlcnNbXSA9IHsNCj4gPj4+ICAJCS5nZXRfc3NldF9j
b3VudCA9IG1hcnZlbGxfZ2V0X3NzZXRfY291bnQsDQo+ID4+PiAgCQkuZ2V0X3N0cmluZ3MgPSBt
YXJ2ZWxsX2dldF9zdHJpbmdzLA0KPiA+Pj4gIAkJLmdldF9zdGF0cyA9IG1hcnZlbGxfZ2V0X3N0
YXRzLA0KPiA+Pj4gLQkJLnNldF9sb29wYmFjayA9IGdlbnBoeV9sb29wYmFjaywNCj4gPj4+ICsJ
CS5zZXRfbG9vcGJhY2sgPSBtYXJ2ZWxsX2xvb3BiYWNrLA0KPiA+Pj4gIAkJLmdldF90dW5hYmxl
ID0gbTg4ZTEwMTFfZ2V0X3R1bmFibGUsDQo+ID4+PiAgCQkuc2V0X3R1bmFibGUgPSBtODhlMTAx
MV9zZXRfdHVuYWJsZSwNCj4gPj4+ICAJCS5jYWJsZV90ZXN0X3N0YXJ0ID0gbWFydmVsbF92Y3Q3
X2NhYmxlX3Rlc3Rfc3RhcnQsDQo+ID4NCg0K
