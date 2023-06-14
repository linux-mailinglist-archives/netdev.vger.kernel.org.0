Return-Path: <netdev+bounces-10710-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CD9A072FE7F
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 14:25:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0BCD1C20CD6
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 12:25:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B9648A94F;
	Wed, 14 Jun 2023 12:25:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3BFB8F74
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 12:25:16 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD877109;
	Wed, 14 Jun 2023 05:25:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686745515; x=1718281515;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=gc95NjL2WLV4eMomtr8XsvP+NfhXwWJPZbI5fjnvaY8=;
  b=hJhktN5tUD0tYYJjaEpRuMdM6ttvi0qiIJBZV+LaMiK3h3pDrauITtYz
   z6jNaZs2fviC36UlhDiE76bwW5QoqUNW4v+bmhkTmi65KnEW5vKFh00r8
   JgrAt8rxGEW8QOsIwzrVsHmku3tJmliBknvLh12gWdwevJYVWWZfYbWyO
   5u72O9tFIVBNGPysYX8AxxrRikFkp58Nhn74n/G1KQvV0X+yIbAFFkSaD
   Z9+jyMdL1C4ztctf0aKlttxIiV4xwvl+XVqfjRmg1wsyzYfhX7Z6a8jA0
   5xKlr/OONOzGuRQ4YvDSMcTD9Gfx4mjoB6db8qsh6GRoAsAxRjEIxXdhA
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="348258442"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="348258442"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2023 05:25:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10741"; a="824798315"
X-IronPort-AV: E=Sophos;i="6.00,242,1681196400"; 
   d="scan'208";a="824798315"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by fmsmga002.fm.intel.com with ESMTP; 14 Jun 2023 05:25:11 -0700
Received: from fmsmsx611.amr.corp.intel.com (10.18.126.91) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:25:11 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx611.amr.corp.intel.com (10.18.126.91) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 14 Jun 2023 05:25:10 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 14 Jun 2023 05:25:10 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 14 Jun 2023 05:25:10 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PNv0yMmfO/oLJm2iFGyEyM9yJZzHt3Z3kzLOnmFEoUA5HKViGprxbwifxvz/r/U5rnAfTPgwoZ5V/Sm9rnEVExCQeWbu2S03rRxyl/+lfMZpsrkfMB/8DyQXcJ7CePRmzSg33n3sVmPmEE8StVtv1F9wQW7P8E/01mbSmDRyzR/yv4SnR25chOxvMlDwVo/CmwxQPq6KkYFDZ6lXFRyVfaUNnH3cpJqFPy3UrhR+mvktRkLFDvw0hVdikm5D7ZqlzfFZ72NGmWWTOHrd6BThozJSje64vHZWGKz6wi1zlhaiHLC+sGMa+TzRpRv8z6AbEpgp/0zZB6eR0Bo/70nE6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=gc95NjL2WLV4eMomtr8XsvP+NfhXwWJPZbI5fjnvaY8=;
 b=STjNPv60UVcx6011EImlKT9W1CJEWKGGtopxvWExzAg49z37SbnYTq8MRb683NpVAEXd/D7cU9cJw92oH3OniAPc5t1pnUyW6T00C78MhI5MnrcSo4KAnqPDCi5ELesird5TUHoVBANLYVDKNYhkWAphiRs3dsT3ZlpFGtmLsHwiGjhsktLqt0fm6a5bqdORhbz+bgUeMfDP0iBvdKhxK5uq7k+7OmfXUeA3fG3I9bHyBRrKDtpATxEN3/rl/1BKQT4J9QwbGtA7iu0c5gpjHphC39JrzAvUGNABG3C4LL7LXkI0CYTbKjV2p+SnMLxYjMM+zxsMBBl6w72ctePGZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH8PR11MB8258.namprd11.prod.outlook.com (2603:10b6:510:1c1::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.44; Wed, 14 Jun 2023 12:25:07 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6455.045; Wed, 14 Jun 2023
 12:25:07 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, poros <poros@redhat.com>
CC: "kuba@kernel.org" <kuba@kernel.org>, "vadfed@meta.com" <vadfed@meta.com>,
	"jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>, "pabeni@redhat.com"
	<pabeni@redhat.com>, "corbet@lwn.net" <corbet@lwn.net>, "davem@davemloft.net"
	<davem@davemloft.net>, "edumazet@google.com" <edumazet@google.com>,
	"vadfed@fb.com" <vadfed@fb.com>, "Brandeburg, Jesse"
	<jesse.brandeburg@intel.com>, "Nguyen, Anthony L"
	<anthony.l.nguyen@intel.com>, "M, Saeed" <saeedm@nvidia.com>,
	"leon@kernel.org" <leon@kernel.org>, "richardcochran@gmail.com"
	<richardcochran@gmail.com>, "sj@kernel.org" <sj@kernel.org>,
	"javierm@redhat.com" <javierm@redhat.com>, "ricardo.canuelo@collabora.com"
	<ricardo.canuelo@collabora.com>, "mst@redhat.com" <mst@redhat.com>,
	"tzimmermann@suse.de" <tzimmermann@suse.de>, "Michalik, Michal"
	<michal.michalik@intel.com>, "gregkh@linuxfoundation.org"
	<gregkh@linuxfoundation.org>, "jacek.lawrynowicz@linux.intel.com"
	<jacek.lawrynowicz@linux.intel.com>, "airlied@redhat.com"
	<airlied@redhat.com>, "ogabbay@kernel.org" <ogabbay@kernel.org>,
	"arnd@arndb.de" <arnd@arndb.de>, "nipun.gupta@amd.com" <nipun.gupta@amd.com>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "linux@zary.sk" <linux@zary.sk>,
	"masahiroy@kernel.org" <masahiroy@kernel.org>,
	"benjamin.tissoires@redhat.com" <benjamin.tissoires@redhat.com>,
	"geert+renesas@glider.be" <geert+renesas@glider.be>, "Olech, Milena"
	<milena.olech@intel.com>, "kuniyu@amazon.com" <kuniyu@amazon.com>,
	"liuhangbin@gmail.com" <liuhangbin@gmail.com>, "hkallweit1@gmail.com"
	<hkallweit1@gmail.com>, "andy.ren@getcruise.com" <andy.ren@getcruise.com>,
	"razor@blackwall.org" <razor@blackwall.org>, "idosch@nvidia.com"
	<idosch@nvidia.com>, "lucien.xin@gmail.com" <lucien.xin@gmail.com>,
	"nicolas.dichtel@6wind.com" <nicolas.dichtel@6wind.com>, "phil@nwl.cc"
	<phil@nwl.cc>, "claudiajkang@gmail.com" <claudiajkang@gmail.com>,
	"linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>, mschmidt <mschmidt@redhat.com>,
	"linux-clk@vger.kernel.org" <linux-clk@vger.kernel.org>,
	"vadim.fedorenko@linux.dev" <vadim.fedorenko@linux.dev>, Jiri Pirko
	<jiri@nvidia.com>
Subject: RE: [RFC PATCH v8 06/10] netdev: expose DPLL pin handle for netdevice
Thread-Topic: [RFC PATCH v8 06/10] netdev: expose DPLL pin handle for
 netdevice
Thread-Index: AQHZms0LMEE2eHihEU+gzon4iCudjq+G58qAgAHfCYCAAXnsUA==
Date: Wed, 14 Jun 2023 12:25:07 +0000
Message-ID: <DM6PR11MB4657B7316954968658B40CE39B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-7-arkadiusz.kubalewski@intel.com>
 <343e2638d2e9b3d13216235f85c2d1dae2634881.camel@redhat.com>
 <ZIh0e5b/xp6H85pN@nanopsycho>
In-Reply-To: <ZIh0e5b/xp6H85pN@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH8PR11MB8258:EE_
x-ms-office365-filtering-correlation-id: eb33f761-bc8d-45f1-44c9-08db6cd26381
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6sCaqX7W7BabgVfoUwXmlWmmMRYLN2NG2so0fmZlBHQ6iDg1dcZLTw+OwqsPd3U0Wp8/Td7JkRYHoD84/s9IGryp1KHXcq2CSWMc6GgrGk7uE0UzdBL6YdVLQhGhRIGTTJ3WxLX6hOByVJzzdZUWB0SzIJZzZAP9ui97rQUQM6mmACRwcXwAC7ULZWTabRh0wPQuvxbifHr4rxbqXiX+4iQ2ZiR0VfsYu0erWoc8B+LGgY0bt6Q+VvKVL9nYXLCnKIzt5ckh745et7WS5G2qcQOPEiq0TC+eZm0p0tN4NJX7IZxlCD2+VPp794+QoP/SlAagYHDDeBL1eTYyB5XXK+dYTpy4EaKVBAjOwXcp1c5CXuutaK320QfraOzJyNpgcLLncxIG4RmSqG0KlqATmoIf+FAyRVPXN/wE+l7OIMDVs2SfpWGkMICjBqSOKU9hqLjZEYSfvp54j37MCWtHQIDpQYJFWMD8qdrRohZeOFI3gO/W5JeC5TOvZtMskiGCYSv3ZS4mn9Nd8kyVeFiccNhEJQGnuBSKHzbnCLfO6MjVIHydkWKmK4sMGXGipp+5qhFDer7fhC06QrDQfyb+5nH7y6dKBIDftDwmEL77C3HNWNHglJuD8mrgG4RuuGjf
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(346002)(39860400002)(396003)(451199021)(66556008)(66446008)(66476007)(66946007)(64756008)(316002)(76116006)(71200400001)(54906003)(4326008)(110136005)(478600001)(33656002)(86362001)(38070700005)(6506007)(9686003)(26005)(83380400001)(186003)(41300700001)(8676002)(8936002)(7416002)(5660300002)(2906002)(52536014)(7406005)(7696005)(55016003)(82960400001)(122000001)(38100700002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?bklHWnpycWdIRXBzdUdEb2U1a1R5THpYaDlSb2E2bnRGY25GWnM3N2tzaTdN?=
 =?utf-8?B?ZXVSa05SdlNmSUlHRkJIU0UrRDBBY3VEYXpxcjFXRStsYUp4NHBIbWpacHRR?=
 =?utf-8?B?QU1lSTMrNHlvRDVkZUNvVkpaWGcwcFpaTGpoR3JxMW5WTFBZN0tjSndCRUl6?=
 =?utf-8?B?NVkyMUFqbGYyM0dXSEtPcGRFbUQ3am0vdGMxV2RJbzVDeGlDUkI2RGcvSG1W?=
 =?utf-8?B?VVVCOWVlRFJxelNrUXNoekUwY2pnbWNudEN0eUdsRzdhN0IyLzAzMmprQ3Yv?=
 =?utf-8?B?RHF1QnZUc2xEUjJPU0RRb1lhT3VRUjRpQlFoWjVXVktNUVNkOG93OGxoTE5j?=
 =?utf-8?B?eVNnaWtlWUszbkxzN1orZDUzakdCcXd5VEswNzRzSUdocERveHd1SHNQdm4r?=
 =?utf-8?B?RXFBU2k2ZlVxR2ZSQ2k3VThyNXIwaWVKTm5saW5ZcUR5aitDMlo2bkh3TEdr?=
 =?utf-8?B?aGVzK1VHbTlSRnViUXhDYmFuT1dIY25FZWxPM0NxdTRua2xjT0NxbzV6TjJ5?=
 =?utf-8?B?NEhGdGFuUGdZTndGQ09xamFoWHIvMC9qMm1pc2lWR0F1ZnZ1eTJGdGdKaDhv?=
 =?utf-8?B?V1M0WFlSVFY1U2NsQ1NRYmZOLzlzcVI3bEVCc0ZCQ0NndzNKVW9NQmgvenRy?=
 =?utf-8?B?ejk1aGIraXppdWZWNEVIdVIwTUxOUDQ3R0EweXBUVGdYZmFMLzNjWFFINkVH?=
 =?utf-8?B?bmdmS2xuTDlxYmdQNm5CSlBRcHBITTNuNDdkRHF0eHV4aXMvYk9ST3FuUGxu?=
 =?utf-8?B?MS9tR3FSd0VEMHRhNEN3ZGt6UGpaNWROd1FYQjlCU2p5VUJNNXkyc2c1SHNv?=
 =?utf-8?B?TlNWcUZpUzcwaFBrZitTcFBUU0gwY0ZtWjlVL3MvTVlXSEpSUnJGcGtmRnVi?=
 =?utf-8?B?ZjNLUEZCQXhPdnVzdjA5ZUtTV0JWSi9ieXZHRHBJakVIWFpSSmlsVHJDbmp4?=
 =?utf-8?B?dnBXTS9RdmswU0k5cmJhdjloK0N6KzRadHZHT0FUdDJPVFU2RDg5eDVicDAz?=
 =?utf-8?B?RmQ1dktSS0thMnc1YUZESjN3aEdqbFQxMDl1VUsrc3ZsMm9sQlNzdXZmSGd6?=
 =?utf-8?B?akNzaEtUajhvWlRkb24xbTVIYmhrYUtpaTV6YnoxL2JHcXdHTkd1eDVRbzZB?=
 =?utf-8?B?TUN0T3hKYTZuVVozY3JXeGRBODZPMFpDNmNTL3ZTQ2RqMlp3RW1uamRQenNM?=
 =?utf-8?B?bHUxWXZNOFVtVGl2M3k3YUhHTVNQbS9qcjlUdmovemlmaEhZUHNsRWd1amxN?=
 =?utf-8?B?dzgxRWFGVFBmU1hjdFFvNXRwMUhiU2pNbFhrNmprWGJaSzhLUVk5U1Vjbm45?=
 =?utf-8?B?emJXN1VqQ0hUbkNwYXRVN2swUUJGaEgvTjhKU1U4d1RIOEhrODZheHR3dmR5?=
 =?utf-8?B?REpvRFRLdmI3bzFtNGx2eVJCalI3RDVkYmlSeXUzUk9vV09PSGlTWktWYVdt?=
 =?utf-8?B?S2lkazJ1VnVZNzJXV1lENTFGb2dhR3BOMkJLbWZNSEVlbFgyaEV0WWFpcjdW?=
 =?utf-8?B?c3FWdGZlQVcvNFpQUUZxSW1CTUxYODlrV3ZFL3ZLa3FpbUhia1BNVitydVhZ?=
 =?utf-8?B?SWNRWGx2NWRyR0xZZXdoNUpzZUxoUnRTbTR5L3l5Q2lWY0lHdkRQVGdoT01x?=
 =?utf-8?B?ZnpkVC9HdndMOW00NjRrazNLTThMakJZWUZPUnl2VWxacDE4ZnVYYUJibW1D?=
 =?utf-8?B?WTlZMWFkTVRudzV2b2F6a0ZUVitOSVV5QTV0SHJYTVhBVzhDK0dzRXZnYzNE?=
 =?utf-8?B?bHkxbHUrVXJseXV2ZVhsT1FmenhnWkp1MWJMM2FldUg0QUlTd3NuTlpweE8z?=
 =?utf-8?B?clFMdWRHUEFZYVVCZVg2TlovbmZJbW1yN3QxZTVVNFROaTc0Zm9RY1lsMUdC?=
 =?utf-8?B?dUoybGNTSEpNb1Foa0xHZTVXM2wvaTRnRldHMUF4Z0N2aWdPRU5uZUx4R1RW?=
 =?utf-8?B?NktFSjBreHB6czdZRVhIVlprT2diN3RNUFk4M0hBdWFDVWNMN2tzLysvTEow?=
 =?utf-8?B?a201OExUMUFBZ1Urb0V6L2xlbDJOOERUSElGZFk2VzhUbTIranhxdHZjYnJZ?=
 =?utf-8?B?U3puQ2RhbzZqUmxCc2swd1BtMjJhRG44YUJ0bWdtYkFhZUtzdjJQSkxTSW9U?=
 =?utf-8?B?b2xUMXVNM0xxSHdnTW5RamJ4M1RVZmxOVTRQNE9HMGw1Z3d2SENBQ284RjMz?=
 =?utf-8?B?VFE9PQ==?=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb33f761-bc8d-45f1-44c9-08db6cd26381
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Jun 2023 12:25:07.1265
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8mX1LQDOubCMSRiMLp8u1dZihxeTQGlIF0MfgxLYqsz5gXlyv7/SpfoJ4/PRDb7JQgo7B+LqVpqvawgRBxXg5dbv+PEYB7KlAs5IwWWZVmY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB8258
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

PkZyb206IEppcmkgUGlya28gPGppcmlAcmVzbnVsbGkudXM+DQo+U2VudDogVHVlc2RheSwgSnVu
ZSAxMywgMjAyMyAzOjUyIFBNDQo+DQo+TW9uLCBKdW4gMTIsIDIwMjMgYXQgMTE6MTc6MjNBTSBD
RVNULCBwb3Jvc0ByZWRoYXQuY29tIHdyb3RlOg0KPj5BcmthZGl1c3ogS3ViYWxld3NraSBww63F
oWUgdiBQw6EgMDkuIDA2LiAyMDIzIHYgMTQ6MTggKzAyMDA6DQo+Pj4gRnJvbTogSmlyaSBQaXJr
byA8amlyaUBudmlkaWEuY29tPg0KPg0KPlsuLi5dDQo+DQo+DQo+Pj4gK3N0YXRpYyBzaXplX3Qg
cnRubF9kcGxsX3Bpbl9zaXplKGNvbnN0IHN0cnVjdCBuZXRfZGV2aWNlICpkZXYpDQo+Pj4gK3sN
Cj4+PiArwqDCoMKgwqDCoMKgwqBzaXplX3Qgc2l6ZSA9IG5sYV90b3RhbF9zaXplKDApOyAvKiBu
ZXN0IElGTEFfRFBMTF9QSU4gKi8NCj4+PiArDQo+Pj4gK8KgwqDCoMKgwqDCoMKgaWYgKGRldi0+
ZHBsbF9waW4pDQo+Pj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHNpemUgKz0gZHBs
bF9tc2dfcGluX2hhbmRsZV9zaXplKGRldi0+ZHBsbF9waW4pOw0KPj4NCj4+SGkgQXJrYWRpdXN6
LA0KPj4NCj4+bmV0X2RldmljZS0+ZHBsbF9waW4gaXMgb25seSB2YWxpZCBpZiBJU19FTkFCTEVE
KENPTkZJR19EUExMKQ0KPj5CdXQgdGhlIGNvZGUgaW4gbmV0L2NvcmUvcnRuZXRsaW5rLmMgZG9l
c24ndCByZXNwZWN0IHRoYXQuDQo+PklmIENPTkZJR19EUExMIGlzIG5vdCBzZXQsIG5ldC9jb3Jl
L3J0bmV0bGluay5jIGNhbm5vdCBiZSBjb21waWxlZC4NCj4+DQo+PlJlZ2FyZHMsDQo+PlBldHIN
Cj4NCj5Zb3UgYXJlIGNvcnJlY3QuIEhlcmUncyB0aGUgc3F1YXNoLXBhdGNoIHRvIGZpeCB0aGlz
LiBBcmthZGl1c3osIGNvdWxkDQo+eW91IHBsZWFzZSBtYWtlIHRoZSBzcXVhc2g/IFRoYW5rcyEN
Cj4NCg0KU3VyZSB0aGluZywgd2lsbCBkby4NCg0KVGhhbmsgeW91IQ0KQXJrYWRpdXN6DQoNCj5k
aWZmIC0tZ2l0IGEvZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5jIGIvZHJpdmVycy9kcGxsL2Rw
bGxfbmV0bGluay5jDQo+aW5kZXggZTZlZmMxN2FhZjI2Li4wMGRjOTZjM2FkZTQgMTAwNjQ0DQo+
LS0tIGEvZHJpdmVycy9kcGxsL2RwbGxfbmV0bGluay5jDQo+KysrIGIvZHJpdmVycy9kcGxsL2Rw
bGxfbmV0bGluay5jDQo+QEAgLTMwMywxMiArMzAzLDE0IEBAIGRwbGxfY21kX3Bpbl9maWxsX2Rl
dGFpbHMoc3RydWN0IHNrX2J1ZmYgKm1zZywgc3RydWN0DQo+ZHBsbF9waW4gKnBpbiwNCj4NCj4g
c2l6ZV90IGRwbGxfbXNnX3Bpbl9oYW5kbGVfc2l6ZShzdHJ1Y3QgZHBsbF9waW4gKnBpbikNCj4g
ew0KPi0JcmV0dXJuIG5sYV90b3RhbF9zaXplKDQpOyAvKiBEUExMX0FfUElOX0lEICovDQo+Kwly
ZXR1cm4gcGluID8gbmxhX3RvdGFsX3NpemUoNCkgOiAwOyAvKiBEUExMX0FfUElOX0lEICovDQo+
IH0NCj4gRVhQT1JUX1NZTUJPTF9HUEwoZHBsbF9tc2dfcGluX2hhbmRsZV9zaXplKTsNCj4NCj4g
aW50IGRwbGxfbXNnX2FkZF9waW5faGFuZGxlKHN0cnVjdCBza19idWZmICptc2csIHN0cnVjdCBk
cGxsX3BpbiAqcGluKQ0KPiB7DQo+KwlpZiAoIXBpbikNCj4rCQlyZXR1cm4gMDsNCj4gCWlmIChu
bGFfcHV0X3UzMihtc2csIERQTExfQV9QSU5fSUQsIHBpbi0+aWQpKQ0KPiAJCXJldHVybiAtRU1T
R1NJWkU7DQo+IAlyZXR1cm4gMDsNCj5kaWZmIC0tZ2l0IGEvaW5jbHVkZS9saW51eC9uZXRkZXZp
Y2UuaCBiL2luY2x1ZGUvbGludXgvbmV0ZGV2aWNlLmgNCj5pbmRleCBiMDAyZTNjYzk5NDMuLjgy
YWQxMmZkNDI2NiAxMDA2NDQNCj4tLS0gYS9pbmNsdWRlL2xpbnV4L25ldGRldmljZS5oDQo+Kysr
IGIvaW5jbHVkZS9saW51eC9uZXRkZXZpY2UuaA0KPkBAIC0zOTY3LDYgKzM5NjcsMTYgQEAgaW50
IGRldl9nZXRfcG9ydF9wYXJlbnRfaWQoc3RydWN0IG5ldF9kZXZpY2UgKmRldiwNCj4gYm9vbCBu
ZXRkZXZfcG9ydF9zYW1lX3BhcmVudF9pZChzdHJ1Y3QgbmV0X2RldmljZSAqYSwgc3RydWN0IG5l
dF9kZXZpY2UNCj4qYik7DQo+IHZvaWQgbmV0ZGV2X2RwbGxfcGluX3NldChzdHJ1Y3QgbmV0X2Rl
dmljZSAqZGV2LCBzdHJ1Y3QgZHBsbF9waW4NCj4qZHBsbF9waW4pOw0KPiB2b2lkIG5ldGRldl9k
cGxsX3Bpbl9jbGVhcihzdHJ1Y3QgbmV0X2RldmljZSAqZGV2KTsNCj4rDQo+K3N0YXRpYyBpbmxp
bmUgc3RydWN0IGRwbGxfcGluICpuZXRkZXZfZHBsbF9waW4oY29uc3Qgc3RydWN0IG5ldF9kZXZp
Y2UNCj4qZGV2KQ0KPit7DQo+KyNpZiBJU19FTkFCTEVEKENPTkZJR19EUExMKQ0KPisJcmV0dXJu
IGRldi0+ZHBsbF9waW47DQo+KyNlbHNlDQo+KwlyZXR1cm4gTlVMTDsNCj4rI2VuZGlmDQo+K30N
Cj4rDQo+IHN0cnVjdCBza19idWZmICp2YWxpZGF0ZV94bWl0X3NrYl9saXN0KHN0cnVjdCBza19i
dWZmICpza2IsIHN0cnVjdA0KPm5ldF9kZXZpY2UgKmRldiwgYm9vbCAqYWdhaW4pOw0KPiBzdHJ1
Y3Qgc2tfYnVmZiAqZGV2X2hhcmRfc3RhcnRfeG1pdChzdHJ1Y3Qgc2tfYnVmZiAqc2tiLCBzdHJ1
Y3QgbmV0X2RldmljZQ0KPipkZXYsDQo+IAkJCQkgICAgc3RydWN0IG5ldGRldl9xdWV1ZSAqdHhx
LCBpbnQgKnJldCk7DQo+ZGlmZiAtLWdpdCBhL25ldC9jb3JlL3J0bmV0bGluay5jIGIvbmV0L2Nv
cmUvcnRuZXRsaW5rLmMNCj5pbmRleCBlYmU5YWU4NjA4ZmMuLjY3ZGQ0NTVlMTVjNyAxMDA2NDQN
Cj4tLS0gYS9uZXQvY29yZS9ydG5ldGxpbmsuYw0KPisrKyBiL25ldC9jb3JlL3J0bmV0bGluay5j
DQo+QEAgLTEwNTYsOCArMTA1Niw3IEBAIHN0YXRpYyBzaXplX3QgcnRubF9kcGxsX3Bpbl9zaXpl
KGNvbnN0IHN0cnVjdA0KPm5ldF9kZXZpY2UgKmRldikNCj4gew0KPiAJc2l6ZV90IHNpemUgPSBu
bGFfdG90YWxfc2l6ZSgwKTsgLyogbmVzdCBJRkxBX0RQTExfUElOICovDQo+DQo+LQlpZiAoZGV2
LT5kcGxsX3BpbikNCj4tCQlzaXplICs9IGRwbGxfbXNnX3Bpbl9oYW5kbGVfc2l6ZShkZXYtPmRw
bGxfcGluKTsNCj4rCXNpemUgKz0gZHBsbF9tc2dfcGluX2hhbmRsZV9zaXplKG5ldGRldl9kcGxs
X3BpbihkZXYpKTsNCj4NCj4gCXJldHVybiBzaXplOw0KPiB9DQo+QEAgLTE3OTAsMTEgKzE3ODks
OSBAQCBzdGF0aWMgaW50IHJ0bmxfZmlsbF9kcGxsX3BpbihzdHJ1Y3Qgc2tfYnVmZiAqc2tiLA0K
PiAJaWYgKCFkcGxsX3Bpbl9uZXN0KQ0KPiAJCXJldHVybiAtRU1TR1NJWkU7DQo+DQo+LQlpZiAo
ZGV2LT5kcGxsX3Bpbikgew0KPi0JCXJldCA9IGRwbGxfbXNnX2FkZF9waW5faGFuZGxlKHNrYiwg
ZGV2LT5kcGxsX3Bpbik7DQo+LQkJaWYgKHJldCA8IDApDQo+LQkJCWdvdG8gbmVzdF9jYW5jZWw7
DQo+LQl9DQo+KwlyZXQgPSBkcGxsX21zZ19hZGRfcGluX2hhbmRsZShza2IsIG5ldGRldl9kcGxs
X3BpbihkZXYpKTsNCj4rCWlmIChyZXQgPCAwKQ0KPisJCWdvdG8gbmVzdF9jYW5jZWw7DQo+DQo+
IAlubGFfbmVzdF9lbmQoc2tiLCBkcGxsX3Bpbl9uZXN0KTsNCj4gCXJldHVybiAwOw0KDQo=

