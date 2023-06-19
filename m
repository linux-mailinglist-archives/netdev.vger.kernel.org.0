Return-Path: <netdev+bounces-12075-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 11047735E8B
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 22:34:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 345CC1C20A44
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 20:34:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E91A03D7C;
	Mon, 19 Jun 2023 20:34:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E3E28F2
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 20:34:21 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C69CEE5;
	Mon, 19 Jun 2023 13:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1687206859; x=1718742859;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=XV6kBS3hbzOU8sgFvGurJkZKG2OKa574uDcmINQ4/5o=;
  b=RQSAARpe//goHzg24udCPe1D2u7OVd2U9Xj64EuVN1MF65bcwj8o39Qy
   rJazc+vmuXkZo4rbGRGWyQIvJLCQnNEMt6GkgSbytTqirf6ZLAKx+FHF3
   FYPhFu+yY0mjNbHlHbJzfHXnfqsDziY/2Rx2b1S9K511Drk7ygPQkkwOn
   CpXVynRYCrrr0A0Iw+U3151fsYxbyKF8ZJz+el4dZ4j8fjNAae3UUmW8j
   IoUEJ8d6oKbQI1cNPFjgoQv8mriojsEL99LAQOzFYbJqQK/jSxi/UR+us
   7zOGklywPhXiIHOGU5XenVVqtqwuEB5sEyk9UrcXXIv+JMrQnEDh6qG6K
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="357198804"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="357198804"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jun 2023 13:34:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10746"; a="1043995905"
X-IronPort-AV: E=Sophos;i="6.00,255,1681196400"; 
   d="scan'208";a="1043995905"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga005.fm.intel.com with ESMTP; 19 Jun 2023 13:34:17 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 13:34:16 -0700
Received: from orsmsx602.amr.corp.intel.com (10.22.229.15) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 19 Jun 2023 13:34:16 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 19 Jun 2023 13:34:16 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 19 Jun 2023 13:34:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IwHyOQ8AeRYlQDtVl3aeCTg455r3RsRRAiy96l3NNGzF+JZsirIfyeMzWVSPPvW/NgHu5cJ/LBQfITOrLcHQhx0j2cyFuYvjNUxbiCgHBE/gyo9LX8kmnlQAjfA/zfCSVPidmKdPrZn6r5mKOL7/0VOxVTVyaLczILrXEeqXEtlTT12LikGdY3FEgSpuHH2nWtRVgIlKFTJUUFKw4kSC6OkqDhURXtMHw9UPHDy93vtFIv6QIXFmYFvsaKHcM26iAmKkD2GU0LzdFsuvCT0fe5L7KnzTPEka87zZoYkB6Wz4oEsQEKlDvJvPAbV6mW6CHXCL7jdyY5J2iR1eLoTY1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=goLyHlUZQOonFry8+cRjbyEpV1Dmn2PDW6OMstTIGHA=;
 b=eGUNL9nZ/UZQguu65wP21Z1txRgZb1YqvuwV9tow2iTxk9u21wBH9jG2ehuiu0xAWF5qCxypOSVlPUhxlBxbtUL/Tb1jazhUVVHDTRwLxvTFpaC2Hvup9HRgdQ82wjVvbTBD4LqBfaYiN1mQg4UIcdqoKlzhQADB+2zL3YOzjxothFvgPAQ1l+5PJurjpHDpVxzs5kJKcFqOB3sfnK+4/rv67TLDn/xwF95LARpvAreBHarItTdo2xaICWvfxX6Vu4avDDALV+KpqphIhvB+Yxb/T0ozzVGIzJXIvw0+dlGlaqt0HR1m9fgyCBPppJcobW3GYR9Cf3whQqF8Q8x5qQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM6PR11MB4657.namprd11.prod.outlook.com (2603:10b6:5:2a6::7) by
 PH0PR11MB4933.namprd11.prod.outlook.com (2603:10b6:510:33::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6500.36; Mon, 19 Jun 2023 20:34:13 +0000
Received: from DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6]) by DM6PR11MB4657.namprd11.prod.outlook.com
 ([fe80::24bd:974b:5c01:83d6%3]) with mapi id 15.20.6500.036; Mon, 19 Jun 2023
 20:34:13 +0000
From: "Kubalewski, Arkadiusz" <arkadiusz.kubalewski@intel.com>
To: Jiri Pirko <jiri@resnulli.us>
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
	<linux-arm-kernel@lists.infradead.org>, poros <poros@redhat.com>, mschmidt
	<mschmidt@redhat.com>, "linux-clk@vger.kernel.org"
	<linux-clk@vger.kernel.org>, "vadim.fedorenko@linux.dev"
	<vadim.fedorenko@linux.dev>
Subject: RE: [RFC PATCH v8 08/10] ice: implement dpll interface to control cgu
Thread-Topic: [RFC PATCH v8 08/10] ice: implement dpll interface to control
 cgu
Thread-Index: AQHZms0YKn5zDyH6hUaEbqiMD+5Ufq+EPdwAgA5hq2A=
Date: Mon, 19 Jun 2023 20:34:12 +0000
Message-ID: <DM6PR11MB4657161D2871747A7B404EDD9B5FA@DM6PR11MB4657.namprd11.prod.outlook.com>
References: <20230609121853.3607724-1-arkadiusz.kubalewski@intel.com>
 <20230609121853.3607724-9-arkadiusz.kubalewski@intel.com>
 <ZISmmH0jqxZRB4VX@nanopsycho>
In-Reply-To: <ZISmmH0jqxZRB4VX@nanopsycho>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR11MB4657:EE_|PH0PR11MB4933:EE_
x-ms-office365-filtering-correlation-id: a18878c1-71bb-44fc-b926-08db71048b0f
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6rGg05lvazUsotEUZn3ZNW02AGNBb3kEhZc1jOyv2Hjvi3TUwxd9wETJ4iNKYJSv+HABbif8DgcQjZsgwP+RCOsa7091vpgbicqgzdIggVc2fZMh/HffeqzPEoxome1LqEmgYR4gYViT+wYflVMiIJwleCEBE0Zxa4bJ3KA46v6jn+zjnfciFlxafm4xVtPHYcFViCtc4KSg2Jep/daCtse4T0ogorbWM73+KycO9NoziOnL9IlnwSEhGMP+4PKJgIuBy9rw0+R4x36Y8MN1I1z5McdG3OEwrwiURxY4jWnUNQBYKqgEtsk/6vdwblI38PdZawGeQEFOwPGOgKjZ+ilBrsgrx/k0kWyAPMuG7flQ+XnWKsPkin+wUD1I2DhxKJZx1rNVOd2NJZgSJpB9pV+dDmv0Nw6l+nu1mFVbLlZZDZ8qxyjA7FeE+id6sxoo8EhacigFSE7Ko8tLPfuGm1JxfLAHfx2lROzvxnamUpO6uEkpiy70gH5xBjh1lK5lDDWlMRkTGvCNmIzep0SrjJVQSskYE12N83eVlc6pED4Qv0pGioCSeLdu2eX362Sg52LvMufoSlkVHwpb/qTIfmDijyYZcLdnHb6eMGoQtjATbhGGwZe6PdCJ2NCoTKQH
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB4657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(376002)(136003)(39860400002)(366004)(396003)(451199021)(76116006)(71200400001)(478600001)(4326008)(54906003)(26005)(9686003)(186003)(6506007)(7696005)(2906002)(55016003)(8936002)(38070700005)(8676002)(41300700001)(66946007)(66446008)(64756008)(66556008)(66476007)(316002)(6916009)(5660300002)(7406005)(7416002)(52536014)(86362001)(33656002)(83380400001)(38100700002)(122000001)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?jbB6S7i+zpXiL+nCQZCIipvOf7NnaqOC+jtK99ufCjcqivvTIbY76WFUbmRS?=
 =?us-ascii?Q?95b7cInbcm5ryk573HU5BN85gqui8xb35CKPUa8EJHNJM1NQ6uobHJrhJWv5?=
 =?us-ascii?Q?VJnL9YA3QLaM2+9+88GliQ0yLmiY9Hy3vbWME7oIDZFZGsCIJblXRW1QuvKP?=
 =?us-ascii?Q?R1D3TMvF0y3rVpuzCrQZT237WY7KrU2Ksf59N8TlZliOQEEtN+stC7UKHGUi?=
 =?us-ascii?Q?8HAlAm8okWhSkWalr4h2moKpIUEO1UqDFIbYOOpC81OiGY1uDHAXp0rZOn3O?=
 =?us-ascii?Q?jSe2ZNfTHE5CEdH3S4L7WZDXuiYF5mynrRP1gSlQjPjZQ6AuGR8aUGfz02Ss?=
 =?us-ascii?Q?ELwe5XD4bxWFBYBZz5DAijofjDJpt7YBmE7LaOrgRuW9Db9YUiwRH2/3Wcyh?=
 =?us-ascii?Q?dF5HtdJw9QNJu3VRwnTrKC9mT+QhVQkvZ/t0WBCZHjgtCtHb3x3uZLBwK/YM?=
 =?us-ascii?Q?KU7jkGO0kCfl/n1fcNiPJvsJvlaJ10SYdfu0h6wDP3ymKX26NuFu99CdcdNt?=
 =?us-ascii?Q?oe6ZgwGhhd2u0JXJfC7bZDCTtlcXlEeWAorzhw5NCNa/gMvTaCPcQ3wF7Kat?=
 =?us-ascii?Q?Mf3AkpvTfeaRRJTV01aEuEKOUIwfOSKzR+kgPQVyQS641+aRN0nEnwa58NVN?=
 =?us-ascii?Q?BsHZba2huRptuFB/jGQM0EmIjOMv/EBWgq8rrojUJqzX7T3bVBJ6jr05InPF?=
 =?us-ascii?Q?AW8map8XsZURMYmugg4EL9MdoyRjH9tWtstEwj51/t/4u8j8YopWguQ5FVPc?=
 =?us-ascii?Q?d3DHto//yuHHedEr4W6+rzuUOMISA72pjNrJyVUXfVUhb68f67AoZ98UFnIu?=
 =?us-ascii?Q?rmBawihofuYo3dtGTmaNRHyXL3GXL7H2LJtPgO9PlvjrWZQtCMsRyfgLwkw/?=
 =?us-ascii?Q?MylaRF1ZyGPbyrTL+J1pOE6Eb8qQIpEmubi6cI+kFjVuCVqfH8aiRw910AW6?=
 =?us-ascii?Q?ltmbVCuC1AzruEe6O16PQ7t4MPYg32fK6l/7eEYO38k5umWLsmt0cEY3+sPG?=
 =?us-ascii?Q?cGomlSuA5HY5C3zGSN4UEhegv7Ae6xQRjlv40+MLbMGQU3r5EpsMRPYIyISb?=
 =?us-ascii?Q?PtwAKo13uHlSF5EIPEvvcnMO77cPzTX1g9rvjwyPyhRuzgSxPvv/f2q8xbez?=
 =?us-ascii?Q?VqasFMMzXrWyVK09C0iTS3kgQR8HT5msS9j6UUEmZ1AwvOsh5QUZEm2i4/NP?=
 =?us-ascii?Q?z4/k/4eU3RUJAGcjo3jTqZOAKHQJm/70RCfm74HQbgh3iTiEKZBv9/+X9oaX?=
 =?us-ascii?Q?0nK07HAs8m0wzc+bnisWXVYVGbY1h8HkESz7E33eZB9NGcVi8DuUF9jez00a?=
 =?us-ascii?Q?BRhf+LrLVtwt973dEMkEWZv8qSfyzUpxGc3cByEz2lAkH1RMweSycDSlBWIf?=
 =?us-ascii?Q?qm/xz4mUEqjD/pXKAs17VYLzGXNxRSXQjjXjMWVvs2V1vvwgy++1vwcA2c3I?=
 =?us-ascii?Q?h6zSoXFc9M2mQJVGX/zhHd9BjpX2ybXNnrTKoHHim3tSYrsoGvjCYbPQpHYM?=
 =?us-ascii?Q?i5Tc2aSDEE1fy+5qdMS0tBeM5KpqEIWJd4n9bSRJceazmBtITepgmX52h5A7?=
 =?us-ascii?Q?z113V6QztvbeIWk+9FpmWnKbqW2m4Hvi+PLIbOXnRZOD3eB8p5y981rR+UyW?=
 =?us-ascii?Q?DA=3D=3D?=
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
X-MS-Exchange-CrossTenant-Network-Message-Id: a18878c1-71bb-44fc-b926-08db71048b0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2023 20:34:12.9387
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aC7ykUk70PLJiDpk4ReanhTxrRNsAdh2HLz/+bX25eMTiq7YO8DNK6lwZj0auk/10Pzv9EdDCQGEM4L+ESH9bNz5jOU+yak3gqv9wKXaE24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB4933
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

>From: Jiri Pirko <jiri@resnulli.us>
>Sent: Saturday, June 10, 2023 6:37 PM
>
>Fri, Jun 09, 2023 at 02:18:51PM CEST, arkadiusz.kubalewski@intel.com wrote=
:
>
>[...]
>
>
>>+static int ice_dpll_mode_get(const struct dpll_device *dpll, void *priv,
>>+			     enum dpll_mode *mode,
>>+			     struct netlink_ext_ack *extack)
>>+{
>>+	*mode =3D DPLL_MODE_AUTOMATIC;
>
>I don't understand how the automatic mode could work with SyncE. The
>There is one pin exposed for one netdev. The SyncE daemon should select
>exacly one pin. How do you achieve that?
>Is is by setting DPLL_PIN_STATE_SELECTABLE on the pin-netdev you want to
>select and DPLL_PIN_STATE_DISCONNECTED on the rest?
>
>
>[...]

AUTOMATIC mode autoselects highest priority valid signal.
As you have pointed out, for SyncE selection, the user must be able to manu=
ally
select a pin state to enable recovery of signal from particular port.

In "ice" case there are 2 pins for network PHY clock signal recovery, and b=
oth
are parent pins (MUX-type). There are also 4 pins assigned to netdevs (one =
per
port). Thus passing a signal from PHY to the pin is done through the MUX-pi=
n,
by selecting proper state on pin-parent pair (where parent pins is highest =
prio
pin on dpll).

Thank you!
Arkadiusz

