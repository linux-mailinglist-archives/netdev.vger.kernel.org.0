Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D326F466902
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 18:20:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242070AbhLBRYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 12:24:02 -0500
Received: from mga05.intel.com ([192.55.52.43]:51234 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233690AbhLBRYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Dec 2021 12:24:02 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10185"; a="323002176"
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="323002176"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Dec 2021 09:20:27 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,282,1631602800"; 
   d="scan'208";a="477978206"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga002.jf.intel.com with ESMTP; 02 Dec 2021 09:20:27 -0800
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 09:20:27 -0800
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Thu, 2 Dec 2021 09:20:26 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Thu, 2 Dec 2021 09:20:26 -0800
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Thu, 2 Dec 2021 09:20:26 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i9YXArlCPBX1ogaP+WIdgkkhv9Dz4eSPfmtJrkv/p8bXM4b2oq9cabiD1+O630JTy0VOx7PQehoZNPYS/g4a4aQv05D7V+cfJzSYWhlzCgsPqPJsED3bmzmnfTUobT2tLhI1tNlr/1hyz6RVnDtVkutlOADNouO/0xhtm9e4Z6rAcB9ylYlaA/XZnhMKYhUdU5fky+V3zW7I0Sx9WxAQ9NZibloJ1BsE63eHDoMXAyXSNFNrX11vdmO7rjWdRN0en/VPZDSJLNhGR73saV2nAXp5XFXHjZhNzs7bZh65A1sSI/rN9soRcshTdTPxJj/iAAzNTQM4O1M7JAAWrf0SYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=TRQzgc8s0PtlnxAGuZcyfFVjaLcon+KfmbHdSWLeMQ4=;
 b=JiW40Sd6OxPfNaXV7vkDay+l0UBqgskAITezLbMAUFqYTIXWRURYnMgsBV5rYt9RLa6AmWc1Uj/97hBBIQMeLqWrVFflcoFv4OI9oL5fhhmxpOOi3uzDbTF9BjUj5cU9RcQPmmIydh/Czwsz+NaF/3cNSHCCt9XV7CVCdMs//CMfvnb7i1OcExkduwlzgcjrhaoKe4iBin2qvSvfSmhJHi5+xNbmRwfq9cpz236KAFrQxDQtLKG9WIVl/93d2hwn9WJI4XtsTfhR8y+25dhrN56CXCZIOLIYSkJHJPd/M+ZuuRHnPuhw0lpXtDLj7+BxR6+7NtCtW69r4HtSlcJdaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TRQzgc8s0PtlnxAGuZcyfFVjaLcon+KfmbHdSWLeMQ4=;
 b=ZQnNklYOe5RJpA2ejpqGH3qe0h1XsK8tr+PVyUvrhfXLbLsQsNe7yyY1OEcCIPxxUbWbu3VjuS4MJhttupBzvHAV1YbRM/EF5HOKEnhvTFcB/i+7SRS3WruZVoWt2HarS3UcZtFfu/OjIf3oDDbO4SkHSZh9WzGGaB31ErJjj7A=
Received: from PH0PR11MB5831.namprd11.prod.outlook.com (2603:10b6:510:14b::15)
 by PH0PR11MB4872.namprd11.prod.outlook.com (2603:10b6:510:32::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4755.11; Thu, 2 Dec
 2021 17:20:25 +0000
Received: from PH0PR11MB5831.namprd11.prod.outlook.com
 ([fe80::7535:84db:8e4f:5985]) by PH0PR11MB5831.namprd11.prod.outlook.com
 ([fe80::7535:84db:8e4f:5985%4]) with mapi id 15.20.4690.015; Thu, 2 Dec 2021
 17:20:25 +0000
From:   "Machnikowski, Maciej" <maciej.machnikowski@intel.com>
To:     Ido Schimmel <idosch@idosch.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "abyagowi@fb.com" <abyagowi@fb.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "petrm@nvidia.com" <petrm@nvidia.com>
Subject: RE: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Topic: [PATCH v4 net-next 2/4] ethtool: Add ability to configure
 recovered clock for SyncE feature
Thread-Index: AQHX5t+zHNhA4eAQzEyd+4hcIqumb6wfJraAgAAesICAACIlAIAACV/g
Date:   Thu, 2 Dec 2021 17:20:24 +0000
Message-ID: <PH0PR11MB583105F8678665253A362797EA699@PH0PR11MB5831.namprd11.prod.outlook.com>
References: <20211201180208.640179-1-maciej.machnikowski@intel.com>
 <20211201180208.640179-3-maciej.machnikowski@intel.com>
 <Yai/e5jz3NZAg0pm@shredder>
 <MW5PR11MB5812455176BC656BABCFF1B0EA699@MW5PR11MB5812.namprd11.prod.outlook.com>
 <Yaj13pwDKrG78W5Y@shredder>
In-Reply-To: <Yaj13pwDKrG78W5Y@shredder>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-reaction: no-action
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f238f23-98aa-4922-2ccc-08d9b5b80776
x-ms-traffictypediagnostic: PH0PR11MB4872:
x-microsoft-antispam-prvs: <PH0PR11MB48727BB2FEC96B27AF919988EA699@PH0PR11MB4872.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IW8iMh81LX2vKG14k6IaxT8KTSNymVH+uQ/bpl4Hkwt1BVfm0Sy5ju2Rau6AvRtUOJ+kLU90z75dN2CDq+Tnb7bwahArjojg3hJePtdfUBHtpg+Uin58JOpY62qIsC9XYDp25GUJvCyvrvpLEh+F5cmPxuzWzEKF/xUXkJipnTvsGyS34Oeq87FshPrh92e18DF/hgFPON1ivqECqx9s6l2pvXsXLX7xb+/ODomthbQEUAZvG66wqIBJbcKzzrFeUutmTGviLeqUf0WShSSPrRRMKLVdgSFQMw2ImqiBDkFarerMYIuBEUlQ6BapF/wSxOoc1OcLeLKs/H2hJrO4Zy18O2oZHiS9z1fuC9IwUtvGU0hPZsC9HMfR+rJUMmIAi+fQyxwQabcZ1fNh/scnl03foJ5kyScB0+Cakb5FPNuxE/qaytEQ1s8CZ6vZXSBc5TZ3KQpGxpamHrDV2RBxSGbrZVpVquaX/Cvhy5Jh648Y2dadt/Nhc3rlX3YBpodB6OwNKRN5QEZD7xsNrhYtatT5mBUhFEq66WtljeCKg7ubqYAlUpJoMY0damHm8YX+bELWVJ7AB3SGfZSzebvI6KmYrbdLd42hrxoXXVmmh0dQPkjhVcqSiB4DkmqGkh6peSfyQHRArBySbnalIT1AmYng0INJ3E6Gwams/texzZ8UBC+j+UluPmTFKlsBXBeHya6PtWQujNMU8SdWArSgzYx1LDQHjsy6aJ5STBCjSJk6cuVhOjm+flUnbQKvRs/TGMDPrcTftTYpT92ADNeFBZm3iR5MNq7dP2uBeB2CBKQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5831.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66476007)(64756008)(66556008)(76116006)(122000001)(5660300002)(66946007)(508600001)(53546011)(66446008)(8676002)(4326008)(33656002)(7696005)(38070700005)(8936002)(54906003)(38100700002)(316002)(9686003)(7416002)(26005)(55016003)(6916009)(71200400001)(83380400001)(966005)(82960400001)(86362001)(186003)(52536014)(6506007)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?Tkc4RkpGV2RsL3pNNnZmZktIcE96SU9MUXcwMDc2N1pvYzRJYTBoWHhWOUha?=
 =?utf-8?B?SklYZkJPVHgvZVh3czNLdjBoanF1OXV4eG1CZWdqM2IxMXpaQUNiZlc4dXFN?=
 =?utf-8?B?dkorZFc2MWh0MThmVmFIRUlSNDZFRm1hUjd4YlhQZUsvV0ZvbGFTTWprVXdG?=
 =?utf-8?B?K2FCbXErd2tyUEhBSzluZ3Arb1NlU1Vxa0JYRXZmSnZlcS8xRlZXcy83Vlhq?=
 =?utf-8?B?NE9ndkYxK3NCUWNqSSsvN0RJSFpvbTZLQkZSRll4RWwwUWc5MjNBTXZxcFF0?=
 =?utf-8?B?cjEwcTFGbVF2ZzdzYnpTNitZR2hoZVZCNUo0cXAzYTRzQjhQTjNxb3lCZHJF?=
 =?utf-8?B?TTlVNUVlaUtrTzhQV3llSXl0N2ttRGVwMTA2M1dra05HQ0M1RGJRZXoyWnU4?=
 =?utf-8?B?eHcyWGtCa2RwWTVZaFBCa211S2ZBS2xlR2xtdFowSGc3ZXo2RDIvd1NFTHpN?=
 =?utf-8?B?Z1VsQTF4TW0xNERjb0s1S2grM2pER3gwdjJZUkRZd0R2Z1JiK3R0T0g2d2dq?=
 =?utf-8?B?ckNZaUs2S2VXWHpHZ2cvN25SMS94Y1JwQlB6WU95YWhralJZRUdqTTNpY21u?=
 =?utf-8?B?RTMzWnI2RmNKR3Y4RXFJTFNEV3ZoNVN3anVTVFZVL2NWQ2wwNzE1Vy9NdkJY?=
 =?utf-8?B?RVl1MjVnV1hjNVFZeFNobExsZ201Nlg0MjVXN1k1bEYxcm1mT3NBWTZFdVVU?=
 =?utf-8?B?cDV2QU1zeHhSNEZkYXhRVHRrQnlpWmNVR1c3V3RsNFFmRGhvSG55UGRuMlR3?=
 =?utf-8?B?b1RVVDI5SkxIZ3BRMUZDbFR2YTVkVFViaHN1ZFdDR00valk5Y0s2TTh2ZEtx?=
 =?utf-8?B?MkJYcGJpa1FxRXREcUc5VGtGTVM0K1IvcjROT1hlYXk2RjI3UXRUanlmSVFW?=
 =?utf-8?B?UjAzYW83cFZqZDVVa0Y4bjErTjdMcGNpZVdtT0dCckN4QVRCbUFMdjNtRDZD?=
 =?utf-8?B?aTN1T2ZpeWZKWVFFenB0azhQL2l5aWZiVWtmWml6RTVLaTZlSGx4dWZwMFk0?=
 =?utf-8?B?Nk9ldDN5bWFlTmVzUWZFV256cGcwNis4UENLY0RGVkpFcC9rRDhOSVQwVXgv?=
 =?utf-8?B?aW5WSDVNYWIybnpmVWl1SUdPREwxSk9vc2tDWFdFRmIwcnhRNXJJQ29XYXZn?=
 =?utf-8?B?Ly8wcno4b3dNVzVwdzV3WmlTK1FWWS9kT2VnaE10R0laQ2JSV0tpTzc2eVRm?=
 =?utf-8?B?RUNQNUNRN0RPWmsvNFVkd1hMMzF0WTloS3czWFo4SUxGdDYyRERoSm1PTUIz?=
 =?utf-8?B?bk85b3JMSGp0ajN5MEFBZnhvRmxhRlVNc0h1N3lGcVl6dXMvQldrYm9XWmVk?=
 =?utf-8?B?UlM4TmFoN1NLT1l5b2syWTlUajc0cDdJT2tVeFJobkh2WU9ZbTRzK0RwVnZn?=
 =?utf-8?B?aE0zZ0p5V25TSjUwMGxiaGthS0RtckRLL3Y3bE9uMVB5YUlyQnZJSmloV1oz?=
 =?utf-8?B?cm5LV05IbDBQc2trS0NUdnY4N1ZkV0VvLzRTcWVCQnhNQ1pqVktWODhBOUtM?=
 =?utf-8?B?eWoreXl1bkdWUjhMb29lS0gwME1MZnNOSWdLS3pQSndLaEtzZmVPbkFNbXZ3?=
 =?utf-8?B?NDh1YW5XcGZHbWdnWDEvbWRjS1ZMaFpDS2J1YXdMMFY3c3V2cjBDV2lNNDNQ?=
 =?utf-8?B?VFE1b2gxVVN5WkNKRWcvK0t0dkRuMFYrODZQa2paRm5xUFQyc3lvdFZWYSs1?=
 =?utf-8?B?a2s2ejV3WnV0UUhLYzgwTXpreHdmZThZSXVLQkZOa1dkdjJpNHZ3ZnZsMk5J?=
 =?utf-8?B?NGRUZmY1TVZ3QUFRT1FrWHV2QTEydzFERUlpQy9NOVBLTlIzRS94ZTNPZkx2?=
 =?utf-8?B?VE9id3NnNGpTOFh2WWMwSllmci9uVnZjREE0MXMyeFVaWHFrZEg4K3I3MVY1?=
 =?utf-8?B?ME96SXdpU2ZtcFFVREZld0hmTERscU9IZ2JEYlBualJUcCtzRHNiNnBRdDNS?=
 =?utf-8?B?ak03Ym45d2Z6R01WV0dtU2VBOWRyWnk0L01KWW9Jekd4RVRkV1RKZUoyc3p2?=
 =?utf-8?B?VEo4Q0trd2JVcmJIbmNpeFMxU3NxSjN5TVBoZzZ3WlYra2VhR3dGcDhTZktT?=
 =?utf-8?B?QWZVczdoaTkyYzFydmpZSmduUlVDNUlDbGxqTHMrRkdMWUE2U0w0TXRhOXg3?=
 =?utf-8?B?V1ZPRm5SRjZZVW9Nd3MrOFd6SlZlUHQzUjBmeC9YZENQam5PY3hmMUJoeHpY?=
 =?utf-8?B?TkhmRXgyU25JTURpR0d4dGtyZzg3M3RFOCtaNlpXWGZhU1NPdXBzME9LdXJQ?=
 =?utf-8?B?czhPaDlJS2Yyek5JUHRBMzJuclZ3PT0=?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5831.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f238f23-98aa-4922-2ccc-08d9b5b80776
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Dec 2021 17:20:25.0424
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NfcenV8fHgBb04mGeXQksL33PX9hdcizYhdieJ06QohTd4L3mCcxHlomX71/lZ27P8cozvkmX2BmNrGKv0NWZjO8QpyCx+gtD6wEXvJpBsw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4872
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBJZG8gU2NoaW1tZWwgPGlkb3Nj
aEBpZG9zY2gub3JnPg0KPiBTZW50OiBUaHVyc2RheSwgRGVjZW1iZXIgMiwgMjAyMSA1OjM2IFBN
DQo+IFRvOiBNYWNobmlrb3dza2ksIE1hY2llaiA8bWFjaWVqLm1hY2huaWtvd3NraUBpbnRlbC5j
b20+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0ggdjQgbmV0LW5leHQgMi80XSBldGh0b29sOiBBZGQg
YWJpbGl0eSB0byBjb25maWd1cmUNCj4gcmVjb3ZlcmVkIGNsb2NrIGZvciBTeW5jRSBmZWF0dXJl
DQo+IA0KPiBPbiBUaHUsIERlYyAwMiwgMjAyMSBhdCAwMzoxNzowNlBNICswMDAwLCBNYWNobmlr
b3dza2ksIE1hY2llaiB3cm90ZToNCj4gPiA+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+
ID4gPiBGcm9tOiBJZG8gU2NoaW1tZWwgPGlkb3NjaEBpZG9zY2gub3JnPg0KPiA+ID4gU2VudDog
VGh1cnNkYXksIERlY2VtYmVyIDIsIDIwMjEgMTo0NCBQTQ0KPiA+ID4gVG86IE1hY2huaWtvd3Nr
aSwgTWFjaWVqIDxtYWNpZWoubWFjaG5pa293c2tpQGludGVsLmNvbT4NCj4gPiA+IFN1YmplY3Q6
IFJlOiBbUEFUQ0ggdjQgbmV0LW5leHQgMi80XSBldGh0b29sOiBBZGQgYWJpbGl0eSB0byBjb25m
aWd1cmUNCj4gPiA+IHJlY292ZXJlZCBjbG9jayBmb3IgU3luY0UgZmVhdHVyZQ0KPiA+ID4NCj4g
PiA+IE9uIFdlZCwgRGVjIDAxLCAyMDIxIGF0IDA3OjAyOjA2UE0gKzAxMDAsIE1hY2llaiBNYWNo
bmlrb3dza2kgd3JvdGU6DQo+ID4gPiBMb29raW5nIGF0IHRoZSBkaWFncmFtIGZyb20gdGhlIHBy
ZXZpb3VzIHN1Ym1pc3Npb24gWzFdOg0KPiA+ID4NCj4gPiA+ICAgICAgIOKUjOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUrOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUkA0K
PiA+ID4gICAgICAg4pSCIFJYICAgICAgIOKUgiBUWCAgICAgICDilIINCj4gPiA+ICAgMSAgIOKU
giBwb3J0cyAgICDilIIgcG9ydHMgICAg4pSCIDENCj4gPiA+ICAg4pSA4pSA4pSA4pa64pSc4pSA
4pSA4pSA4pSA4pSA4pSQICAgIOKUgiAgICAgICAgICDilJzilIDilIDilIDilIDilIDilroNCj4g
PiA+ICAgMiAgIOKUgiAgICAg4pSCICAgIOKUgiAgICAgICAgICDilIIgMg0KPiA+ID4gICDilIDi
lIDilIDilrrilJzilIDilIDilIDilJAg4pSCICAgIOKUgiAgICAgICAgICDilJzilIDilIDilIDi
lIDilIDilroNCj4gPiA+ICAgMyAgIOKUgiAgIOKUgiDilIIgICAg4pSCICAgICAgICAgIOKUgiAz
DQo+ID4gPiAgIOKUgOKUgOKUgOKWuuKUnOKUgOKUkCDilIIg4pSCICAgIOKUgiAgICAgICAgICDi
lJzilIDilIDilIDilIDilIDilroNCj4gPiA+ICAgICAgIOKUgiDilrwg4pa8IOKWvCAgICDilIIg
ICAgICAgICAg4pSCDQo+ID4gPiAgICAgICDilIIg4pSA4pSA4pSA4pSA4pSA4pSAICAg4pSCICAg
ICAgICAgIOKUgg0KPiA+ID4gICAgICAg4pSCIFxfX19fLyAgIOKUgiAgICAgICAgICDilIINCj4g
PiA+ICAgICAgIOKUlOKUgOKUgOKUvOKUgOKUgOKUvOKUgOKUgOKUgOKUgOKUtOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUmA0KPiA+ID4gICAgICAgICAx4pSCIDLilIIgICAgICAgIOKW
sg0KPiA+ID4gIFJDTEsgb3V04pSCICDilIIgICAgICAgIOKUgiBUWCBDTEsgaW4NCj4gPiA+ICAg
ICAgICAgIOKWvCAg4pa8ICAgICAgICDilIINCj4gPiA+ICAgICAgICDilIzilIDilIDilIDilIDi
lIDilIDilIDilIDilIDilIDilIDilIDilIDilLTilIDilIDilIDilJANCj4gPiA+ICAgICAgICDi
lIIgICAgICAgICAgICAgICAgIOKUgg0KPiA+ID4gICAgICAgIOKUgiAgICAgICBTRUMgICAgICAg
4pSCDQo+ID4gPiAgICAgICAg4pSCICAgICAgICAgICAgICAgICDilIINCj4gPiA+ICAgICAgICDi
lJTilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilIDilJgN
Cj4gPiA+DQo+ID4gPiBHaXZlbiBhIG5ldGRldiAoMSwgMiBvciAzIGluIHRoZSBkaWFncmFtKSwg
dGhlIFJDTEtfU0VUIG1lc3NhZ2UgYWxsb3dzDQo+ID4gPiBtZSB0byByZWRpcmVjdCB0aGUgZnJl
cXVlbmN5IHJlY292ZXJlZCBmcm9tIHRoaXMgbmV0ZGV2IHRvIHRoZSBFRUMgdmlhDQo+ID4gPiBl
aXRoZXIgcGluIDEsIHBpbiAyIG9yIGJvdGguDQo+ID4gPg0KPiA+ID4gR2l2ZW4gYSBuZXRkZXYs
IHRoZSBSQ0xLX0dFVCBtZXNzYWdlIGFsbG93cyBtZSB0byBxdWVyeSB0aGUgcmFuZ2Ugb2YNCj4g
PiA+IHBpbnMgKFJDTEsgb3V0IDEtMiBpbiB0aGUgZGlhZ3JhbSkgdGhyb3VnaCB3aGljaCB0aGUg
ZnJlcXVlbmN5IGNhbiBiZQ0KPiA+ID4gZmVkIGludG8gdGhlIEVFQy4NCj4gPiA+DQo+ID4gPiBR
dWVzdGlvbnM6DQo+ID4gPg0KPiA+ID4gMS4gVGhlIHF1ZXJ5IGZvciBhbGwgdGhlIGFib3ZlIG5l
dGRldnMgd2lsbCByZXR1cm4gdGhlIHNhbWUgcmFuZ2Ugb2YNCj4gPiA+IHBpbnMuIEhvdyBkb2Vz
IHVzZXIgc3BhY2Uga25vdyB0aGF0IHRoZXNlIGFyZSB0aGUgc2FtZSBwaW5zPyBUaGF0IGlzLA0K
PiA+ID4gaG93IGRvZXMgdXNlciBzcGFjZSBrbm93IHRoYXQgUkNMS19TRVQgbWVzc2FnZSB0byBy
ZWRpcmVjdCB0aGUNCj4gZnJlcXVlbmN5DQo+ID4gPiByZWNvdmVyZWQgZnJvbSBuZXRkZXYgMSB0
byBwaW4gMSB3aWxsIGJlIG92ZXJyaWRkZW4gYnkgdGhlIHNhbWUNCj4gbWVzc2FnZQ0KPiA+ID4g
YnV0IGZvciBuZXRkZXYgMj8NCj4gPg0KPiA+IFdlIGRvbid0IGhhdmUgYSB3YXkgdG8gZG8gc28g
cmlnaHQgbm93LiBXaGVuIHdlIGhhdmUgRUVDIHN1YnN5c3RlbSBpbg0KPiBwbGFjZQ0KPiA+IHRo
ZSByaWdodCB0aGluZyB0byBkbyB3aWxsIGJlIHRvIGFkZCBFRUMgaW5wdXQgaW5kZXggYW5kIEVF
QyBpbmRleCBhcw0KPiBhZGRpdGlvbmFsDQo+ID4gYXJndW1lbnRzDQo+ID4NCj4gPiA+IDIuIEhv
dyBkb2VzIHVzZXIgc3BhY2Uga25vdyB0aGUgbWFwcGluZyBiZXR3ZWVuIGEgbmV0ZGV2IGFuZCBh
bg0KPiBFRUM/DQo+ID4gPiBUaGF0IGlzLCBob3cgZG9lcyB1c2VyIHNwYWNlIGtub3cgdGhhdCBS
Q0xLX1NFVCBtZXNzYWdlIGZvciBuZXRkZXYgMQ0KPiA+ID4gd2lsbCBjYXVzZSB0aGUgVHggZnJl
cXVlbmN5IG9mIG5ldGRldiAyIHRvIGNoYW5nZSBhY2NvcmRpbmcgdG8gdGhlDQo+ID4gPiBmcmVx
dWVuY3kgcmVjb3ZlcmVkIGZyb20gbmV0ZGV2IDE/DQo+ID4NCj4gPiBEaXR0byAtIGN1cnJlbnRs
eSB3ZSBkb24ndCBoYXZlIGFueSBlbnRpdHkgdG8gbGluayB0aGUgcGlucyB0byBBVE0sDQo+ID4g
YnV0IHdlIGNhbiBhZGRyZXNzIHRoYXQgaW4gdXNlcnNwYWNlIGp1c3QgbGlrZSBQVFAgcGlucyBh
cmUgdXNlZCBub3cNCj4gPg0KPiA+ID4gMy4gSWYgdXNlciBzcGFjZSBzZW5kcyB0d28gUkNMS19T
RVQgbWVzc2FnZXMgdG8gcmVkaXJlY3QgdGhlIGZyZXF1ZW5jeQ0KPiA+ID4gcmVjb3ZlcmVkIGZy
b20gbmV0ZGV2IDEgdG8gUkNMSyBvdXQgMSBhbmQgZnJvbSBuZXRkZXYgMiB0byBSQ0xLIG91dCAy
LA0KPiA+ID4gaG93IGRvZXMgaXQga25vdyB3aGljaCByZWNvdmVyZWQgZnJlcXVlbmN5IGlzIGFj
dHVhbGx5IHVzZWQgYW4gaW5wdXQgdG8NCj4gPiA+IHRoZSBFRUM/DQo+IA0KPiBVc2VyIHNwYWNl
IGRvZXNuJ3Qga25vdyB0aGlzIGFzIHdlbGw/DQoNCkluIGN1cnJlbnQgbW9kZWwgaXQgY2FuIGNv
bWUgZnJvbSB0aGUgY29uZmlnIGZpbGUuIE9uY2Ugd2UgaW1wbGVtZW50IERQTEwNCnN1YnN5c3Rl
bSB3ZSBjYW4gaW1wbGVtZW50IGNvbm5lY3Rpb24gYmV0d2VlbiBwaW5zIGFuZCBEUExMcyBpZiB0
aGV5IGFyZQ0Ka25vd24uDQoNCj4gPiA+DQo+ID4gPiA0LiBXaHkgdGhlc2UgcGlucyBhcmUgcmVw
cmVzZW50ZWQgYXMgYXR0cmlidXRlcyBvZiBhIG5ldGRldiBhbmQgbm90IGFzDQo+ID4gPiBhdHRy
aWJ1dGVzIG9mIHRoZSBFRUM/IFRoYXQgaXMsIHdoeSBhcmUgdGhleSByZXByZXNlbnRlZCBhcyBv
dXRwdXQgcGlucw0KPiA+ID4gb2YgdGhlIFBIWSBhcyBvcHBvc2VkIHRvIGlucHV0IHBpbnMgb2Yg
dGhlIEVFQz8NCj4gPg0KPiA+IFRoZXkgYXJlIDIgc2VwYXJhdGUgYmVpbmdzLiBSZWNvdmVyZWQg
Y2xvY2sgb3V0cHV0cyBhcmUgY29udHJvbGxlZA0KPiA+IHNlcGFyYXRlbHkgZnJvbSBFRUMgaW5w
dXRzLg0KPiANCj4gU2VwYXJhdGUgaG93PyBXaGF0IGRvZXMgaXQgbWVhbiB0aGF0IHRoZXkgYXJl
IGNvbnRyb2xsZWQgc2VwYXJhdGVseT8gSW4NCj4gd2hpY2ggc2Vuc2U/IFRoYXQgcmVkaXJlY3Rp
b24gb2YgcmVjb3ZlcmVkIGZyZXF1ZW5jeSB0byBwaW4gaXMNCj4gY29udHJvbGxlZCB2aWEgUEhZ
IHJlZ2lzdGVycyB3aGVyZWFzIHByaW9yaXR5IHNldHRpbmcgYmV0d2VlbiBFRUMgaW5wdXRzDQo+
IGlzIGNvbnRyb2xsZWQgdmlhIEVFQyByZWdpc3RlcnM/IElmIHNvLCB0aGlzIGlzIGFuIGltcGxl
bWVudGF0aW9uIGRldGFpbA0KPiBvZiBhIHNwZWNpZmljIGRlc2lnbi4gSXQgaXMgbm90IG9mIGFu
eSBpbXBvcnRhbmNlIHRvIHVzZXIgc3BhY2UuDQoNClRoZXkgYmVsb25nIHRvIGRpZmZlcmVudCBk
ZXZpY2VzLiBFRUMgcmVnaXN0ZXJzIGFyZSBwaHlzaWNhbGx5IGluIHRoZSBEUExMDQpoYW5naW5n
IG92ZXIgSTJDIGFuZCByZWNvdmVyZWQgY2xvY2tzIGFyZSBpbiB0aGUgUEhZL2ludGVncmF0ZWQg
UEhZIGluDQp0aGUgTUFDLiBEZXBlbmRpbmcgb24gc3lzdGVtIGFyY2hpdGVjdHVyZSB5b3UgbWF5
IGhhdmUgY29udHJvbCBvdmVyDQpvbmUgcGllY2Ugb25seQ0KDQo+ID4gSWYgd2UgbWl4IHRoZW0g
aXQnbGwgYmUgaGFyZCB0byBjb250cm9sIGV2ZXJ5dGhpbmcgZXNwZWNpYWxseSB0aGF0IGENCj4g
PiBzaW5nbGUgRUVDIGNhbiBzdXBwb3J0IG11bHRpcGxlIGRldmljZXMuDQo+IA0KPiBIYXJkIGhv
dz8gUGxlYXNlIHByb3ZpZGUgY29uY3JldGUgZXhhbXBsZXMuDQoNCkZyb20gdGhlIEVFQyBwZXJz
cGVjdGl2ZSBpdCdzIG9uZSB0byBtYW55IHJlbGF0aW9uIC0gb25lIEVFQyBpbnB1dCBwaW4gd2ls
bCBzZXJ2ZQ0KZXZlbiA0LDE2LDQ4IG5ldGRldnMuIEkgZG9uJ3Qgc2VlIGVhc3kgd2F5IG9mIHN0
YXJ0aW5nIGZyb20gRUVDIGlucHV0IG9mIEVFQyBkZXZpY2UNCmFuZCBmaWd1cmluZyBvdXQgd2hp
Y2ggbmV0ZGV2cyBhcmUgY29ubmVjdGVkIHRvIGl0IHRvIHRhbGsgdG8gdGhlIHJpZ2h0IG9uZS4N
CkluIGN1cnJlbnQgbW9kZWwgaXQncyBhcyBzaW1wbGUgYXM6DQotIEkgcmVjZWl2ZWQgUUwtUFJD
IG9uIG5ldGRldiBlbnM0ZjANCi0gSSBzZW5kIGJhY2sgZW5hYmxlIHJlY292ZXJlZCBjbG9jayBv
biBwaW4gMCBvZiB0aGUgZW5zNGYwDQotIGdvIHRvIEVFQyB0aGF0IHdpbGwgYmUgbGlua2VkIHRv
IGl0DQotIHNlZSB0aGUgc3RhdGUgb2YgaXQgLSBpZiBpdHMgbG9ja2VkIC0gcmVwb3J0IFFMLUVF
QyBkb3duc3RlYW0NCg0KSG93IHdvdWxkIHlvdSB0aGlzIGNvbnRyb2wgbG9vayBpbiB0aGUgRUVD
L0RQTEwgaW1wbGVtZW50YXRpb24/IE1heWJlDQpJIG1pc3NlZCBzb21ldGhpbmcuDQogDQo+IFdo
YXQgZG8geW91IG1lYW4gYnkgIm11bHRpcGxlIGRldmljZXMiPyBBIG11bHRpLXBvcnQgYWRhcHRl
ciB3aXRoIGENCj4gc2luZ2xlIEVFQyBvciBzb21ldGhpbmcgZWxzZT8NCg0KTXVsdGlwbGUgTUFD
cyB0aGF0IHVzZSBhIHNpbmdsZSBFRUMgY2xvY2suDQoNCj4gPiBBbHNvIGlmIHdlIG1ha2UgdGhv
c2UgcGlucyBhdHRyaWJ1dGVzIG9mIHRoZSBFRUMgaXQnbGwgYmVjb21lIGV4dHJlbWFsbHkNCj4g
aGFyZA0KPiA+IHRvIG1hcCB0aGVtIHRvIG5ldGRldnMgYW5kIGNvbnRyb2wgdGhlbSBmcm9tIHRo
ZSB1c2Vyc3BhY2UgYXBwIHRoYXQgd2lsbA0KPiA+IHJlY2VpdmUgdGhlIEVTTUMgbWVzc2FnZSB3
aXRoIGEgZ2l2ZW4gUUwgbGV2ZWwgb24gbmV0ZGV2IFguDQo+IA0KPiBIYXJkIGhvdz8gV2hhdCBp
cyB0aGUgcHJvYmxlbSB3aXRoIHNvbWV0aGluZyBsaWtlOg0KPiANCj4gIyBlZWMgc2V0IHNvdXJj
ZSAxIHR5cGUgbmV0ZGV2IGRldiBzd3AxDQo+IA0KPiBUaGUgRUVDIG9iamVjdCBzaG91bGQgYmUg
cmVnaXN0ZXJlZCBieSB0aGUgc2FtZSBlbnRpdHkgdGhhdCByZWdpc3RlcnMNCj4gdGhlIG5ldGRl
dnMgd2hvc2UgVHggZnJlcXVlbmN5IGlzIGNvbnRyb2xsZWQgYnkgdGhlIEVFQywgdGhlIE1BQyBk
cml2ZXIuDQoNCkJ1dCB0aGUgRUVDIG9iamVjdCBtYXkgbm90IGJlIGNvbnRyb2xsZWQgYnkgdGhl
IE1BQyAtIGluIHdoaWNoIGNhc2UNCnRoaXMgbW9kZWwgd29uJ3Qgd29yay4NCg0KPiA+DQo+ID4g
PiA1LiBXaGF0IGlzIHRoZSBwcm9ibGVtIHdpdGggdGhlIGZvbGxvd2luZyBtb2RlbD8NCj4gPiA+
DQo+ID4gPiAtIFRoZSBFRUMgaXMgYSBzZXBhcmF0ZSBvYmplY3Qgd2l0aCBmb2xsb3dpbmcgYXR0
cmlidXRlczoNCj4gPiA+ICAgKiBTdGF0ZTogSW52YWxpZCAvIEZyZWVydW4gLyBMb2NrZWQgLyBl
dGMNCj4gPiA+ICAgKiBTb3VyY2VzOiBOZXRkZXYgLyBleHRlcm5hbCAvIGV0Yw0KPiA+ID4gICAq
IFBvdGVudGlhbGx5IG1vcmUNCj4gPiA+DQo+ID4gPiAtIE5vdGlmaWNhdGlvbnMgYXJlIGVtaXR0
ZWQgdG8gdXNlciBzcGFjZSB3aGVuIHRoZSBzdGF0ZSBvZiB0aGUgRUVDDQo+ID4gPiAgIGNoYW5n
ZXMuIERyaXZlcnMgd2lsbCBlaXRoZXIgcG9sbCB0aGUgc3RhdGUgZnJvbSB0aGUgZGV2aWNlIG9y
IGdldA0KPiA+ID4gICBpbnRlcnJ1cHRzDQo+ID4gPg0KPiA+ID4gLSBUaGUgbWFwcGluZyBmcm9t
IG5ldGRldiB0byBFRUMgaXMgcXVlcmllZCB2aWEgZXRodG9vbA0KPiA+DQo+ID4gWWVwIC0gdGhh
dCB3aWxsIGJlIHBhcnQgb2YgdGhlIEVFQyAoRFBMTCkgc3Vic3lzdGVtDQo+IA0KPiBUaGlzIG1v
ZGVsIGF2b2lkcyBhbGwgdGhlIHByb2JsZW1zIEkgcG9pbnRlZCBvdXQgaW4gdGhlIGN1cnJlbnQN
Cj4gcHJvcG9zYWwuDQoNClRoYXQncyB0aGUgZ28tdG8gbW9kZWwsIGJ1dCBmaXJzdCB3ZSBuZWVk
IGNvbnRyb2wgb3ZlciB0aGUgc291cmNlIGFzIHdlbGwgOikNClJlZ2FyZHMNCk1hY2llaw0KDQo+
ID4NCj4gPiA+IFsxXSBodHRwczovL2xvcmUua2VybmVsLm9yZy9uZXRkZXYvMjAyMTExMTAxMTQ0
NDguMjc5MjMxNC0xLQ0KPiA+ID4gbWFjaWVqLm1hY2huaWtvd3NraUBpbnRlbC5jb20vDQo=
