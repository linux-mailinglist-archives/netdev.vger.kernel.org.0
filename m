Return-Path: <netdev+bounces-10305-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2007D72DB96
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 09:54:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6444E280FE8
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 07:54:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A006E566F;
	Tue, 13 Jun 2023 07:54:10 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 924762581
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 07:54:10 +0000 (UTC)
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310DBE7C
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:54:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686642849; x=1718178849;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=Uegn3YMZANiVDj6iUbDDnMaHoTLmlojKFpDmQRRgQzs=;
  b=C+DdWgK/zBRIOs2fyNMpuLbLT+Y+X6PU+jnr7wQ6AltHEcqRet/ZCpvw
   l15KlvhwcwzY7nJj7iPkBO3MJI2L6N2MTO1N0kg4JGTyriI9WE8+dI0B0
   ig7BMTNZAfORyEJ3fTiyRPza7Lo5uUMVy8RdeK2B0v2R1jYPF4CBfjDmo
   wW/ePVkw5dxHQjU9NscBoLRgBWV0eci5R9p0DI+45lAph2lT6Z+z5HjSb
   i95G2oqBP0jtofpTocsXCu4U72Jfi0AQ5zyzMZFn5yv544ebz2EUiszig
   qVqvcnDKBL/t4ReEtgT5T8mKC9eMVmItRHz/Ri/Dw9CE7NgRV0mW6s3Lr
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="355759275"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="355759275"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jun 2023 00:54:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10739"; a="801361727"
X-IronPort-AV: E=Sophos;i="6.00,239,1681196400"; 
   d="scan'208";a="801361727"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by FMSMGA003.fm.intel.com with ESMTP; 13 Jun 2023 00:54:07 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 00:54:07 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Tue, 13 Jun 2023 00:54:06 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Tue, 13 Jun 2023 00:54:06 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.107)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Tue, 13 Jun 2023 00:54:06 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQvpLEh/kNFftNnga3FGGnC3sTuKee7tmGHbai1t0aLsV+99aTdAhFub2Ps0KxszJkj50iDR01Ljd1eoSTbyqrc1UekHB54bPMqnVx6FxF7MYWkalwgpGLBj6K/xZgGkAyipkqlHI/65YrQSCkvNg/UZQJrX5pmhz4Ly4LYNQqyz+2cn9DwHrk0+A4yMSqeZyTxnHlZoxeT4SDd/4XzwI7oTblFIuycuKRSzGmRBTJA7sjkKHIv+3bzhzHB9FlD15+n8QYAuptqAOfFVVtBOP7uWxY9MzY8dWwpKIK+q+J+7XBfP1mm1lx292rZD0c7aQIH3HtNUp+fWvdNJp/pxDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Q8tMlv5StYDjM9Rh52U9mf6mA+QFN+4VE3MgMh7BgCs=;
 b=DbkGoDO2MARUp7KFThk16KC85RQUb8QuBulJsqGSMMOEzhHv3eWfZGc12ABBOmEpHE5R/dy7FLGmrdVojMHnM4QMNgHqbGyJJttRa6w5D6l/1lmCp6j/XeqnDFB2QOv2Aj0eBIVAZ/BOzbT2Ga8nphB4XSHgvZvGnsJoOOz8bFzH4EfdPKcgrSqhtgtX7XMtWeihVQn2tH42hEBZDlzp+pcxundVIdDqS/1iWbN07eZMgVj4G2EWN70H3llCzYuHaFDLv5wa8KYLYeJPlsluhrCGJc5NDUaHYU3ZYSWnQhqhOsJb6hRwYDj1EhvSXjeQprqT9NAiiBm4+ch6vIWOZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM4PR11MB6117.namprd11.prod.outlook.com (2603:10b6:8:b3::19) by
 DM4PR11MB6042.namprd11.prod.outlook.com (2603:10b6:8:61::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6455.46; Tue, 13 Jun 2023 07:54:05 +0000
Received: from DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809]) by DM4PR11MB6117.namprd11.prod.outlook.com
 ([fe80::9e4f:80cc:e0aa:6809%2]) with mapi id 15.20.6477.028; Tue, 13 Jun 2023
 07:54:04 +0000
From: "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
To: "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>, "davem@davemloft.net"
	<davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>,
	"pabeni@redhat.com" <pabeni@redhat.com>, "edumazet@google.com"
	<edumazet@google.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "Loktionov, Aleksandr" <aleksandr.loktionov@intel.com>
Subject: RE: [PATCH net v3 3/3] igb: fix nvm.ops.read() error handling
Thread-Topic: [PATCH net v3 3/3] igb: fix nvm.ops.read() error handling
Thread-Index: AQHZnXBtLvxU0qgt9k+xBK8ORzJLNa+IXW+w
Date: Tue, 13 Jun 2023 07:54:04 +0000
Message-ID: <DM4PR11MB611716995F764188DAC94A148255A@DM4PR11MB6117.namprd11.prod.outlook.com>
References: <20230612205208.115292-1-anthony.l.nguyen@intel.com>
 <20230612205208.115292-4-anthony.l.nguyen@intel.com>
In-Reply-To: <20230612205208.115292-4-anthony.l.nguyen@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM4PR11MB6117:EE_|DM4PR11MB6042:EE_
x-ms-office365-filtering-correlation-id: 6b7bf78f-2a5b-4c96-3f81-08db6be35c03
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mplXoXYN7q1OYbNib8DINeKvTbfrFPOI30FjICDpsA+4kHikNuBfuWn7U0YbKj/bluyQi68cTMvAvF4kKa0Rgj9IYnf41WKG8Y8BGkeeobTIiohV2CEp2fYCOUxxk8U2n0q5phz9YipBk9UnisCMJVREGxlU0arXxanBX/LeSFWUcpXFqXLvUu8tvIMTdt+Ys6bpzlgO+DHOOcEe6nELlezaQ5Yc4Nuu1SpzCDqYp90JF+W+fbpWidsxj1MeDFMjmRx4xtDEVNrOX0vSQ75UBcjc03kxJI0HuBcUuJBzjmgDq6zXybZNMgqaZ3UGE4p+ppRSeTo08guMk47qmYvKXL3N4cPguDXJtJ7Ot67o7PsqAeuhOXGVGhrn+GXs8ja4VFzpFEx5fwDEa6Dvrx+XWyv5nL7ccPmhHe8WTW3PXsmUeS15BibZWTbU5Ijfcpn6C0Wq8wd1yDdU4ZFq9MjjPB7Wt6m/Wm15gdxAYadlANK2ALaOq+fkOlYgB0IsXZWBJC+02CZaagtmDe4H5PsYKkRRMx3KSQgBeSkBOQCo5doDmY1u8KpJiEn/JjYaT4t0k6hAeKOKUR8wQKORyQMNyxmMfbHI/Fnda2ZT50LJM+gtzVAjNPO9VfhghWQ2XCo+
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR11MB6117.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(366004)(376002)(39860400002)(346002)(451199021)(5660300002)(52536014)(8936002)(8676002)(2906002)(76116006)(66946007)(64756008)(66476007)(66446008)(66556008)(110136005)(71200400001)(7696005)(4326008)(107886003)(6506007)(9686003)(26005)(316002)(41300700001)(186003)(82960400001)(83380400001)(478600001)(33656002)(38070700005)(55016003)(38100700002)(122000001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G1/5WW6k49qaB7zIFubDtP7bdjMoFokzy0b5Qdi0PnAYwMrMn7epDQCvoRpC?=
 =?us-ascii?Q?tSbFN3XX0+gpIbTDX6Z7Xug7GotYBAwHhWN2uZz3sov07Bv8l7NzWNANQp1z?=
 =?us-ascii?Q?Je+41fqERMzqj4s9CvGoWG6Fbu8xyhMaj4IO/och12QPe0fxBTVr9Z6JG+LO?=
 =?us-ascii?Q?zFagck1cr143za2qHOXz47yYs0PjTdJTLLY6ZGaa8FQlGek4namw5ri/kmXt?=
 =?us-ascii?Q?0qxN3SINkCkfpLOu50TMmPBhNN10c6X6bx6rwzvkZOUvecI//S9QjpbG2ApK?=
 =?us-ascii?Q?aE5iHni5QS7aEW9HHwm9BMop4WglztK25eVUhGT9EwFDA4wLqGTR5dCz3V0R?=
 =?us-ascii?Q?FU9z9Q+O1L8xuzDGnMyjnsfeTUt1Mi4KyRzjpzE40Ract4MRKIurE7C/WxUE?=
 =?us-ascii?Q?YySxMyQAXrZdUex/vfuje2d/uijqctXzomP2dQ/wFzaH3SOaPHQICiUQjqTd?=
 =?us-ascii?Q?HlfQhmUh03jrfPxvq6L1oIR6QQnktg34Inb2/k05E5MqhAGOsNEsZcbHyoq7?=
 =?us-ascii?Q?vnuPZQJGYOfSgRqzu8dU4iT9cgab0FiRxN+a9Fw6msDTbhFsPc4sSqKZgUnz?=
 =?us-ascii?Q?/Zlftxa0GKchAlY9q8hUgiWtTuNkQAyHTQNdrXfbAXa8GlvKi7LjywLbDUqN?=
 =?us-ascii?Q?0C1LGnm0BtJjNxOBFr6hoU2Us/RTO24Ah9rLVM91FZG/Q79htO1l3yNFw8bg?=
 =?us-ascii?Q?i32+ps9VPyGxsSm0d3JHhWhbccaPHnEAUhHNFPih7t8WGd+yLmhDm82KDvbn?=
 =?us-ascii?Q?cYF35DXXvKR7enZFQY42EDO+ToJVMwQ0ADRAXCk9UlzjcPbnuM522N0SAREI?=
 =?us-ascii?Q?ZT8kHZqWzVxwni23PK7uOnhmZ36j/B3pkL+YGd5IuRLLpx3AD7Sa2FzBbuhz?=
 =?us-ascii?Q?ELxEPHZImej1v5mP/jrsgJYPlHjoH8N1ofIdrXfaQAaN5cXWS3TmkdwUJ+LP?=
 =?us-ascii?Q?1G9Ir0LgRFMnQoRIE3YLf6R2ByUsPfyI2v0O5os1+UWZ22gEmdTH0iYp5+iD?=
 =?us-ascii?Q?EryApsIoXEuC8z0SCEL8Tr9KHLLEs2bKV/Y5pJt2QoxyMLO/+r+wNvtWCLsj?=
 =?us-ascii?Q?wUu1JHzJuyBT5yF5KU8wWuu7ovbnXpz8vwp5Uy1Fi47/VRRzFm4Eorf7vjh3?=
 =?us-ascii?Q?dJ3n2GfjaOXEK0QPLlxvmab6KRbadNhUeIMwTacHjb8gdSH5XEYNoT5Jr4pQ?=
 =?us-ascii?Q?cMK1GSc/AgorRJzw4VxwdIGUATaKXDwdk8kiNudhjPWHgn+CGuShhaUy3iDb?=
 =?us-ascii?Q?45mE0PPaH+LDMnQbz+RYnsXdbFAbYQEM4AVB9cvp01GqEleEjZLUcmQsUHhT?=
 =?us-ascii?Q?mzKLzhp1fUgUtqXL1szBRnnPwyiNDDSJGhXAWhRiiwQvztm/i/3pX5yb6eyr?=
 =?us-ascii?Q?oUhgUGJ3kBsjaYjOKkpHZS3MbXCMck1UyZpnskz3HB8oARofS0ZjubzXQXoX?=
 =?us-ascii?Q?H0/LmpTMZZhzwHXQBH/RVZrBMe+utaD2h6u9RgCYWuCxlJrqW1bZSgoB6AMH?=
 =?us-ascii?Q?GT6z3TsiwFy+/+J/sPfWZthTfrhm3kC7vKgnZQ4e2btF7m6auYPEJ4TuSGxJ?=
 =?us-ascii?Q?sTASAK0IZ5fRSUCqObmnND88rqmGghnUWDQ0+Irg?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM4PR11MB6117.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b7bf78f-2a5b-4c96-3f81-08db6be35c03
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2023 07:54:04.8192
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: oV4cKeMF7r/S3pJTyR7GF+nSAFZWQysJD6jUSZdJXAqzuggjYEKr49jT2TFRNR7gm7OTIqOAYKl67DV3IPLVYkRuVfpcQDmx/2DFS3nFic8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR11MB6042
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> From: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
>=20
> Add error handling into igb_set_eeprom() function, in case
> nvm.ops.read() fails just quit with error code asap.
>=20
> Fixes: 9d5c824399de ("igb: PCI-Express 82575 Gigabit Ethernet driver")
> Signed-off-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
> Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> ---
>  drivers/net/ethernet/intel/igb/igb_ethtool.c | 3 +++
>  1 file changed, 3 insertions(+)
>=20
> diff --git a/drivers/net/ethernet/intel/igb/igb_ethtool.c b/drivers/net/e=
thernet/intel/igb/igb_ethtool.c
> index 7d60da1b7bf4..319ed601eaa1 100644
> --- a/drivers/net/ethernet/intel/igb/igb_ethtool.c
> +++ b/drivers/net/ethernet/intel/igb/igb_ethtool.c
> @@ -822,6 +822,8 @@ static int igb_set_eeprom(struct net_device *netdev,
>  		 */
>  		ret_val =3D hw->nvm.ops.read(hw, last_word, 1,
>  				   &eeprom_buff[last_word - first_word]);
> +		if (ret_val)
> +			goto out;
>  	}
>=20
>  	/* Device's eeprom is always little-endian, word addressable */
> @@ -841,6 +843,7 @@ static int igb_set_eeprom(struct net_device *netdev,
>  		hw->nvm.ops.update(hw);
>=20
>  	igb_set_fw_version(adapter);
> +out:
>  	kfree(eeprom_buff);
>  	return ret_val;
>  }
> --
> 2.38.1


