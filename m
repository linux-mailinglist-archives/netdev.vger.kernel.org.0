Return-Path: <netdev+bounces-11132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8BA27731A5A
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 15:44:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AE6B41C20E77
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 13:44:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5051F15AFC;
	Thu, 15 Jun 2023 13:44:42 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42305168D1
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 13:44:42 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE8E0199D;
	Thu, 15 Jun 2023 06:44:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686836680; x=1718372680;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=U7vYimpWWg9rKovSPdQKO8rjWXCizyWsm99EPMhTrQ4=;
  b=KYVGJHd4wqLZFMvPmUi402bXM/6jYaXdwT7R8Cu3v9mg64C5Fa+BMW2p
   xk1hdYivjRWqPbZgsxGgGEjDErUkE/mejz/xJ4/1CZ6KNq9Kuzy4lAMBX
   dv64Tiut4b+9xMorSrXeP/G3QZg7JSUspAA1Y4gjiMU8h3oeNBnS25U2W
   3E81DhtMtHUldep1A82ZJXJZUAVi89O50pAFkrlupnzjYvOh56/4kGCVn
   1ZXt9hC7ipwf7xa5/xuCQkw33pFLET0EhuQmAtQN5DvWtuoLhdltiNj2c
   hHS8pBb91y4uXZAFygAF/zjlrO1bpCJhW8B+3hJJ9ytLIi0C3j5I7DjWO
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="356409189"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="356409189"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jun 2023 06:44:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10742"; a="782523687"
X-IronPort-AV: E=Sophos;i="6.00,245,1681196400"; 
   d="scan'208";a="782523687"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 15 Jun 2023 06:44:37 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:44:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Thu, 15 Jun 2023 06:44:36 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Thu, 15 Jun 2023 06:44:36 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.100)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Thu, 15 Jun 2023 06:44:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RILp4RTC9vNZZosLtcppXunwQzdy3Kl4oWDAyXBLpZrFXM0Evrlw7gKsP+p+sM3NJiDsc1HJZuhPeK10x1hs9EGyKXAssG8FB904ghXBTJbmCjofnS2PVchuXoOfusPtvLn1yZOR1rxeedWmDgivBTFgoz/iZ0nP1dirQAHb4Osn9hgpe0tzQXN2U5aIJAVIYYnpq6UpxqirAgWObaF2wg+X/l1n3QcYV0tHaau7U67lQNRVUkhbqX6p3AZJ6gHok5m7XTsnckJLeiK0uA8ru/J3UisNaz5LtaKZECVCNkWqOjoNXamEs4cI8m5fOMNve5rNbEW4tlrTGDLJvmg7DA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8qmOW6flucvPcUSZ7/+d90wxbYQ5XchkCyOXU7daG1Y=;
 b=N6B+0Wr0lsFvWs9/DqhealzcFoAdfmRYvZH5HDnkNjwqkFRnaRH79fVyx4ulOeq89wW8V3LMJYhrHsal8wjR5U31iHQh4fjgK2JvJy8+EKzgzVDhz9E5jzZSynAp1/VuhsO7R4C5UdfrsAcrvG4p3oqcw2nM6JJ2EwJS3foh5HGwpDz+wZcs9SiW4DnP81Fw43A5B/615iuXJs+P006o2OBBkn4fQB3/DOHUh3/xfQqEhgIGAHxjfefo0I649DDG9RlQ+LEOUAs/U1qiIufq3PJRLfn+m2xkRKBbHXwlksimNr6HuH+qyL3FQHKotx2bv1Rg/4ufc5YhvjaXwuisZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 DS0PR11MB6352.namprd11.prod.outlook.com (2603:10b6:8:cb::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.39; Thu, 15 Jun 2023 13:44:31 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6500.025; Thu, 15 Jun 2023
 13:44:31 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>, Jakub Kicinski <kuba@kernel.org>
CC: "vadfed@meta.com" <vadfed@meta.com>, "jonathan.lemon@gmail.com"
	<jonathan.lemon@gmail.com>, "pabeni@redhat.com" <pabeni@redhat.com>,
	"corbet@lwn.net" <corbet@lwn.net>, "davem@davemloft.net"
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
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "linux-clk@vger.kernel.org"
	<linux-clk@vger.kernel.org>, "vadim.fedorenko@linux.dev"
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Thread-Topic: [RFC PATCH v8 01/10] dpll: documentation on DPLL subsystem
 interface
Thread-Index: AQHZmszoYeH83BxaW02EVqODRhjpgq+HyQOAgAC7rICAAHCNgIABGgiAgAAa0HCAAIlpAIAAAmUAgAD5+ACAADldwA==
Date: Thu, 15 Jun 2023 13:44:31 +0000
Message-ID: <DM6PR11MB465768D2B3C4F1E6F2DD1B219B5BA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-2-arkadiusz.kubalewski@intel.com>
 <20230612154329.7bd2d52f@kernel.org> <ZIg8/0UJB9Lbyx2D@nanopsycho>
 <20230613093801.735cd341@kernel.org> <ZImH/6GzGdydC3U3@nanopsycho>
 <DM6PR11MB465799A5A9BB0B8E73A073449B5AA@DM6PR11MB4657.namprd11.prod.outlook.com>
 <20230614121514.0d038aa3@kernel.org> <20230614122348.3e9b7e42@kernel.org>
 <ZIrldB4ic3zt9nIk@nanopsycho>
In-Reply-To: <ZIrldB4ic3zt9nIk@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|DS0PR11MB6352:EE_
x-ms-office365-filtering-correlation-id: 224dc520-915c-4a61-86cc-08db6da6a580
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: FgVWjyAavzHESc8rmOoSnZeEBnR4RnlgrBlYMqScl0aZUppLD+a88dg1xaUeCtlKOSji7YsktLSyQybeMYcFssRAQ8Gb0sOYobFhKdHm94Ed5zrI5rZr13kRbqWhAE205YaU6dhuJ9NUet64dsPf8Uctlo2oPWga+DN89oeIB6/7nfx+8z8s9TW5zXvBLkCsDXpKBl6Ufbzm5tZPCMLxWIwQ9R/2DK/MxrpqzYonvRGn1VhTZRTVcnE0zUa5EA50Wn6jS/SoawW1Jbdsyr6bwLm/2NBt+4c9f/9x4jpie+3mAwM5qgwxJEdp9mnMBN8fMSCh/dxQNG/wqr+MLq+Uu0DsV3v8QRnDLyQsqNqFAR69es4bTs+5SJ3Gc2nBRxYnsOmUGlhp3++krPaxVy1nt5ZsU30J6PkzLbgZ2BTcxAqk9eg7zd+mvR9IOgaxP35w2ym7DDvPgfBK5YvXjN/gBn49RyFOVD5vpIQm2vrZx4m51ZA1MBpNm8pmbd8yW2cd4oMxwmB2sLQSvBly69P8nlA/HG7qSu49AKa4Xqm5XIP5T1zRUEvlec1giRiJiDPCIPZWike+/rIQy+7BWplmGROyWDYhVM0KsufQEt0ujWe0Zg/OZqgVQXAia40S5TGG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(39860400002)(366004)(136003)(396003)(346002)(451199021)(66446008)(66946007)(66556008)(66476007)(76116006)(478600001)(54906003)(110136005)(8676002)(5660300002)(52536014)(71200400001)(64756008)(4326008)(8936002)(7696005)(55016003)(41300700001)(316002)(9686003)(38100700002)(122000001)(82960400001)(6506007)(38070700005)(86362001)(7406005)(26005)(186003)(7416002)(4744005)(33656002)(2906002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?zYlKXSIEOY7xKwW5q2wd+ovRKD/k7OFzlXcjX+PZT49mZ7CTNgjG2wHiOQcJ?=
 =?us-ascii?Q?x8ustZ8oHMqvZXwmQnLQqd1LA2VV2NfQfk5l4SUT0lVmn5gm2D8dWQ05/Lny?=
 =?us-ascii?Q?N81+L23NrZCZ8CW013YbxkDShvplmPSNF4fdp/4MXEOs1aNbscBQ8Suuaamx?=
 =?us-ascii?Q?Bwve8GzpecNfKnhv8sH/ZLi/Ch6aogSqhCZMemMmT6XlNXYPk0dSq6MFtkMs?=
 =?us-ascii?Q?oDY99+H+GUpZAkahjlZXbz+Fjb9Eiuts2k7/w1a4EvI9xQNSuCDholVl472Z?=
 =?us-ascii?Q?C9r6ur8tqMKLg5e2y7xoEu7NWRAaCaiC21jVmiw7sSwKV6OuzqPNvEOo5DrJ?=
 =?us-ascii?Q?X+32PT+vZFAAsrPIJNEBAy8+UlZMD/m+oNGOV5oOVs7dz3ynRvZPGTOTwqYJ?=
 =?us-ascii?Q?7TNCMnWNnydTWZDF4JV9VBAPbk4Ys6h6sd0j5O0PfZ1MxwKX+VHff6GRXgcU?=
 =?us-ascii?Q?lxh4C+TvGvbyWvMzz63JMN1R68H75/xnVyysSdUDnKm3Vj4A7xlEwNgagJrx?=
 =?us-ascii?Q?r5EfQOHhdl5OxnYjl9EJ+hx8bhBx9tE3QcXW3RHkSIM6kZBb7D6znAXgDe3z?=
 =?us-ascii?Q?npTDSAwGteLDkiZWOeC98Y1LJ54XZ9cCeLDcum0FI8ojsSf9YD818O1l+sO9?=
 =?us-ascii?Q?cQLfyhiLjWQLiLvqVB0CRpzFJ3joa169mx7Fy9Pe5l6jZSjy+EWyVWtLs5yG?=
 =?us-ascii?Q?cYmwcVA4PZbvfR+Kry6q4Q7AY8EDCzXXPqjelusI01gllhJiYviBp8kjEhTo?=
 =?us-ascii?Q?jaEpKglVYRo/EQOnFVdp511AUbmUdscpH3cRw+TfPrwEkryQTPTKPHl7n50o?=
 =?us-ascii?Q?CNOmyJhNClu/bzgd7ihxcD+ru+svgsj1wLLrUIAcj2QSqldY4tsPGZPyA/5y?=
 =?us-ascii?Q?mui7TnMGX0eG2Uw8hiKG1S8poo+V5CN9GUjIvOm1ftHNoCGoxOoMIVWdVw8z?=
 =?us-ascii?Q?W49UxxnESq64aDS+iPAH0KKXHTeFIF3SLrKQyFBqdg73+doV9y8p+2GNl1Xx?=
 =?us-ascii?Q?TPQ2zAAC9UGF5PikTfe8bShDWvTGXjL0ix9wk6Zu21C4ewEg/zR3nn/f0qlP?=
 =?us-ascii?Q?p8OVZL5DGBq6ERYmLPPOyRT2cYqRUdQyvOys1/UTxMIZl6ObjXtPY0GOGdWA?=
 =?us-ascii?Q?v7IvEL5JJCflgKuacRLzVlXmH0hx9Lz1/A+4kFkcQBQvAhbSnMnKFET2/yXo?=
 =?us-ascii?Q?oXU5n1aG+L8WKEV2r6KV3CfeEz8xRifTqMS8eUnIApNjipeN5y+7vRFId+IQ?=
 =?us-ascii?Q?D3vFPLZEwqXhjJcuzhfZ7Kn6zTMQ9sUuuUXpPvLtQhm/zt/wHJp5nKtWv7Cv?=
 =?us-ascii?Q?PvpSpBZB7kSQhuqCUb2mdoAtvkfTgYHyl1ZsKLIBj2pw17xCvET9/8qHuqJd?=
 =?us-ascii?Q?YQi8pavAoc5AHMDBWwve8eODKP/XBcTij/AO1Z5pftDuLkSDgnUGUH7mcUXy?=
 =?us-ascii?Q?BNMRAGEI/XY61PS+kvIPBEzZEnjYktrabeRLIj1qmObsTbgxBrb+zNTOeX1E?=
 =?us-ascii?Q?74p7EDsZmEIaJoq+R88PfknFXHOql3gpukwLatp+cgc9BDckzVkqgYs5R/fg?=
 =?us-ascii?Q?iQyQ8u4RdJN0+zxYWprvQR4AUCPSJFodOs6r9dHFyXnuDQbyMId7HBKuoiW/?=
 =?us-ascii?Q?eA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB4657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 224dc520-915c-4a61-86cc-08db6da6a580
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 Jun 2023 13:44:31.1232
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PRQ6HoGyIvKGrdG1fa6kt0OY5DkRQxIbVYbuDobUng+hDCont5z7n0PfszqItKGsiynv0vlOOlYyTR67Q6Mln/Fq51zV1+wKetnvH4sTfg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6352
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Thursday, June 15, 2023 12:18 PM
>
>Wed, Jun 14, 2023 at 09:23:48PM CEST, kuba@kernel.org wrote:
>>On Wed, 14 Jun 2023 12:15:14 -0700 Jakub Kicinski wrote:
>>> On Wed, 14 Jun 2023 12:21:29 +0000 Kubalewski, Arkadiusz wrote:
>>> > Surely, we can skip this discussion and split the nest attr into
>something like:
>>> > - PIN_A_PIN_PARENT_DEVICE,
>>> > - PIN_A_PIN_PARENT_PIN.
>>>
>>> Yup, exactly. Should a fairly change code wise, if I'm looking right.
>>                               ^ small
>
>Yeah, that is what we had originally. This just pushes out the
>different attr selection from the nest one level up to the actualy
>nesting attribute.
>
>One downside of this is you will have 2 arrays of parent objects,
>one per parent type. Current code neatly groups them into a single array.
>
>I guess this is a matter of personal preference, I'm fine either way.

Ok, I will split it.

Thank you!
Arkadiusz

