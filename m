Return-Path: <netdev+bounces-2531-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A81A470260A
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AED021C2098C
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:28:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C539A8469;
	Mon, 15 May 2023 07:28:40 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B787C23D4
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:28:40 +0000 (UTC)
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BDEDA
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 00:28:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1684135718; x=1715671718;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z5UHdg0lH5Go/uHVxzyMIkfZKtbbOwZBiNMfoDfFWkY=;
  b=GiKLXYnX35PbvKi7zPzwYWkZKn9ZotLFOovVU8G+loHgpBD/XqOnoiPH
   zNZe+jx/ldXY+c151csocarqqC1ZkySKOb4APrFhVDLzZUauDneYSAviE
   pniadYwjmod+573sfXqMzzbYWr/JkLPXeOebccQWxKzTzxglgBuPS0M4N
   +UsZ/k8N8+3yiup+N4hSiTehzbvfL6jdw+kR1hnDExHreUs6A6QSdAHcX
   17lw51zps/8VHCxeaYs8+ih6ZHTb7aO1n8IxwRqoibNKsOG8P+GfwOwn1
   2aZdbbGBIthJAugFRm68ezmpC4Q9iyRAmcfgHHgix6p+oq8yO2Vbl0z4I
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="437469351"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="437469351"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 May 2023 00:28:23 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10710"; a="790564018"
X-IronPort-AV: E=Sophos;i="5.99,276,1677571200"; 
   d="scan'208";a="790564018"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by FMSMGA003.fm.intel.com with ESMTP; 15 May 2023 00:28:18 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 00:28:16 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Mon, 15 May 2023 00:28:15 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Mon, 15 May 2023 00:28:15 -0700
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (104.47.51.42) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Mon, 15 May 2023 00:28:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ACYmgs4SbCc9iVBQpuzK40WZM/IUPSHjVmA4nrxklmZ8FoqsIawvhakOreBy47qTPEvVKCVduWlPtoLpWz4006GKthYmq5L8rWSVF+Wlf/nkWAwyoTNCca21W14wzBHD1806RvFK2caexAL5U8axcuSSjU9bwzjGAdHC9eMNABXDU3fCVvCDQZ06SbZixxTEXoc4xQkzrqYIqSCH/dPQynZ0+HuitQzSyEj1SqZCe4z+u21I+K7SwnaVtq7pLdAzyrXZYSyV13XZ1UOzaafKYxOn7k9qkijkljn76LD1SHlbcfVe50A1YyiO3+KcHYjgozKiHLYRLgEzeHL0HXmjRg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o1MW0m/mShrWrvizmoiNT6N2uK5rr3rPGiUYfbQ0S/w=;
 b=G9vmR5SiQeaP7GLPcK1UmVTVLXc5m11KggIuuDLl2J3bJ+iu1o3mP2cIwFI5DnIz71WLv62Esg7oYU5dF7flH9P9Vv0U6Jt6ua+XRilUY0d6N1tthWZOdNZs43ui2hd4e5hgVtn8P8nNHzKzUIWjN/azMX5Lf0J5DtPL3pA2uuZZOJirJBuiqLFIo3RF5QEypJbpgjbIIUTMd0rdVqq9bcCapjWHak+WO4cJ14pYzl/smKfM6Ls00wvqa9LVpJDGog3+8JI9gXbsMRtusfzXvEO7SuPMbBUrGc5j+Zt0XRpZ9TACNoBS2d9e6/l8+grMky8GYuuc9ryPIBWrQsD6oA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BL0PR11MB3122.namprd11.prod.outlook.com (2603:10b6:208:75::32)
 by SA0PR11MB4750.namprd11.prod.outlook.com (2603:10b6:806:9d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6387.30; Mon, 15 May
 2023 07:28:08 +0000
Received: from BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::1029:7958:5ad6:bace]) by BL0PR11MB3122.namprd11.prod.outlook.com
 ([fe80::1029:7958:5ad6:bace%4]) with mapi id 15.20.6363.033; Mon, 15 May 2023
 07:28:08 +0000
From: "Pucha, HimasekharX Reddy" <himasekharx.reddy.pucha@intel.com>
To: "Drewek, Wojciech" <wojciech.drewek@intel.com>,
	"intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH iwl-next] ice: Remove LAG+SRIOV mutual
 exclusion
Thread-Topic: [Intel-wired-lan] [PATCH iwl-next] ice: Remove LAG+SRIOV mutual
 exclusion
Thread-Index: AQHZhLFPH/PaWta65UGLfwp4hH3RYq9a8Zyg
Date: Mon, 15 May 2023 07:28:08 +0000
Message-ID: <BL0PR11MB3122FF228A65C85EA784A1FEBD789@BL0PR11MB3122.namprd11.prod.outlook.com>
References: <20230512090652.190058-1-wojciech.drewek@intel.com>
In-Reply-To: <20230512090652.190058-1-wojciech.drewek@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BL0PR11MB3122:EE_|SA0PR11MB4750:EE_
x-ms-office365-filtering-correlation-id: 312dcc68-912a-4bda-967a-08db5515ee25
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ER3xDaZR/ZjbX0aCRx8exzF9foZ74M2FR8mqGAdEWr6OgDBm3H1NX0UNAcG62jTsGvih3Jgv0n+IjEoOcLcT2we/A+DzB26tE1iAACIH+/zhXiQrEHUd8XOx754oEQFMECyBhaqp+plt/u4W6HuvOZJtNMDZzu98xsEpswFbk4XcUswcFesalwr5ZW+ZCzla4lcGBLLsR9manbR1vSuUvj/COTe+p73mloo1kyVQB1omNv52MXslC9jsZBd63qCOcZLWWzBZfofjNoLKPAeYXoEtYh7yJKNYPhcG0xsdXEXIpK22JhW+k6wbXgm5jDh0iJu93qFXOfEvoygOVrRFqe1PEA+SaOU6FgeWpDb1QgyBxJpu0CNwqowIiiAZQA6AwOvlNst3IAz+rqUlNXBu57+uon4hw2lH+JdUWrNaeZ4ig1rOIbJDXjp01pv6aDuxtHWUmmvTFwDrIHddyP6en+8yYQ8nGAZYB596YtKR97ge6xT+AFK48CMMwvUytUTqYfTYTD2BBMp4tSM4rjV+ObKbFMjSq7HGJFIpRh3WzJBkPPNDR27UVAKtwrdL8SODBl935zfqeK+PVmXY0lKNEVQ6Wv5AIaS8pNAsMDnZouX66YpBBB1eMh6V6bwc+CG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL0PR11MB3122.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(346002)(136003)(39860400002)(366004)(376002)(396003)(451199021)(71200400001)(316002)(4326008)(64756008)(66446008)(66476007)(66556008)(66946007)(82960400001)(33656002)(186003)(26005)(8676002)(8936002)(52536014)(41300700001)(6506007)(86362001)(5660300002)(7696005)(2906002)(76116006)(83380400001)(9686003)(122000001)(53546011)(38100700002)(110136005)(55016003)(38070700005)(478600001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?oH7uA9K6tPLQYZUwEi3HkenfiIk+DDuL5EGG29YMY47PBee7YTfGLX9dNS6A?=
 =?us-ascii?Q?Me8cexGBC9wezDl9KnoQAa/GqBfSsQ1uRwqKWnHqfcQlQE029PgsjHa1yRTv?=
 =?us-ascii?Q?1m7JKPAcgGKZ0GRFLgw+OXPv0uYwI/fmb8xbWtp1sxNJ4lsFPmF5A65ighzj?=
 =?us-ascii?Q?pX0Hi3D+65vhuLFKEei1g3M+uLXXrMqWUMDEmzo3Qt/zf6p5yVgmfPnUteZI?=
 =?us-ascii?Q?KP7h5/yTnHzL3+mSJRDG3W8EVvfYvMVQsmmdiQZHDAP+vlg/QYgqtEZKLUwD?=
 =?us-ascii?Q?+nDHM4WEr0SKYYr0NxM8sbKSFnWPlJCPXh1hbofqnyD4Im+wPXpKwW0HRqfY?=
 =?us-ascii?Q?N1cEs9iJKSJZiehVHUJFhOvRQMXtdZJWMoI8hHz9GSOm9u4yy9S5U7p7EKgJ?=
 =?us-ascii?Q?YLWUXNA/7iQL73IS3pn3ng7zp3rN+yV6mBVPQIOA/OK4L0X5d4k6GWlr9gZE?=
 =?us-ascii?Q?QDfQ/wytCYryzdIhH/XYZN/P3oF7BEI/qIUzG/GLUrckk51j8n9gio/ESz7o?=
 =?us-ascii?Q?g8kjweQesv5hS28Tr4ydARd/IoAM7Gk2AjYl9qeCOKjDhi1khieafBbsKZeB?=
 =?us-ascii?Q?cUpmpPhxWcaPKzfGtn3j0dLtjCA/hmBZzKqsrHOJHyfF9tHYJ+j69pRP7gmq?=
 =?us-ascii?Q?2IxtW2nVzgEDyPp5n39Xdc0zJwGXErk3qaNbW42z06g/QGXPBSNsECrkAdV5?=
 =?us-ascii?Q?ov+Y2Vv020fw4/T+NJ7B6tG/RNBKpwnBneIEyZkpX1rfrMBohtdkveWpM9SB?=
 =?us-ascii?Q?cWBC33/yyFTiIB9K/U6UE+R6FDTAGNkJvpL51ri7BkxgxNLI96jMGMoSydv6?=
 =?us-ascii?Q?NVnUSPDKO+8Pfk9JthSItuox/EBWNHwev7YIHJgDMVh2fnMM2oNdZfWboakw?=
 =?us-ascii?Q?5DOKVflgAoOFgnoPR5JPDDoQbcN+qjOEWExceJZ04PZd0u30EaPMyMhuF58v?=
 =?us-ascii?Q?bcr1VDpQMM+zEYDo0m7hRuyl7IitL6RNXIKvq+AlYZclGS0lCIsZbryIkP7c?=
 =?us-ascii?Q?OucUKHYnSzYhrSoHbRtKyJRFQzK/rFJjM67WftfaIHFRRAY4hy7ua9moaCE6?=
 =?us-ascii?Q?it6/QjlnfcPZBbgP3s5ZwiIZAfNi0wMuJwVWosFzcIsE52TEOlP9UFvty7C7?=
 =?us-ascii?Q?kIYyhL7vtuhv8fY9bDf841rGKGjVFhgjnsXzmold00yBLIrj7Ijx0fkPr+fx?=
 =?us-ascii?Q?lBcMuugLt2blOETWXbV7yopLOY5c/BW7sAONxB6Zs9TNI+twf2PYI30tkOxY?=
 =?us-ascii?Q?5bas5KUgVKTJ38NPM2je+jn2ilZa4I9lolWusDJ9dPWpvEXfjC8fDyvIVpe+?=
 =?us-ascii?Q?GtP9TOrtj1EA98eUqaReYyWxK9OUTeMNHFFdWDb2fSqenINxloPB0ZFEVU5+?=
 =?us-ascii?Q?CIMkEZhoxMWFxD8m+fyl5FVNKUjtOgH5YFL5Lg/zpk7dlbdD757pgkeM0+vw?=
 =?us-ascii?Q?qF2a0WyWDR2sQEtW07KET4QJW+ZYBG5QeBly+qgHtCw4iHl34nXPXGRyob1C?=
 =?us-ascii?Q?WHIviipt7Kct18Y/PBI4XkOm2+e2b3FIOWQS8aITYRRGo1tkAlI/SIk4Hsdo?=
 =?us-ascii?Q?MBQpG2RjaQwXWIsPstuqePqqbQvnVoFe9oEt/GacjIRZe8M7z9qyaEtnN2KI?=
 =?us-ascii?Q?dg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL0PR11MB3122.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 312dcc68-912a-4bda-967a-08db5515ee25
X-MS-Exchange-CrossTenant-originalarrivaltime: 15 May 2023 07:28:08.0844
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: QtPuPISk8s6QAydBsPosMfUW4IswEIddw0WznCPIlMQy7pf26AK1LwtPfkOb5lyVDG1TU3B+Ce4ZoycvigSzEpcT2Hox+kl5qIB01c9OcArbiIHcGUeBWCLz0oCAPM68
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4750
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of W=
ojciech Drewek
> Sent: Friday, May 12, 2023 2:37 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH iwl-next] ice: Remove LAG+SRIOV mutual =
exclusion
>
> From: Dave Ertman <david.m.ertman@intel.com>
>
>There was a change previously to stop SR-IOV and LAG from existing on the =
same interface.  This was to prevent the violation of LACP (Link Aggregatio=
n Control Protocol).  The method to achieve this was to add a no-op Rx hand=
ler onto the netdev when SR-IOV VFs were present, thus blocking bonding, br=
idging, etc from claiming the interface by adding its own Rx handler.  Also=
, when an interface was added into a aggregate, then the SR-IOV capability =
was set to false.
>
> There are some users that have in house solutions using both SR-IOV and b=
ridging/bonding that this method interferes with (e.g. creating duplicate V=
Fs on the bonded interfaces and failing between them when the interface fai=
ls over).
>
> It makes more sense to provide the most functionality possible, the restr=
iction on co-existence of these features will be removed.  No additional fu=
nctionality is currently being provided beyond what existed before the co-e=
xistence restriction was put into place.  It is up to the end user to not i=
mplement a solution that would interfere with existing network protocols.
>
> Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> Signed-off-by: Wojciech Drewek <wojciech.drewek@intel.com>
> ---
> .../device_drivers/ethernet/intel/ice.rst     | 18 -------
> drivers/net/ethernet/intel/ice/ice.h          | 19 -------
> drivers/net/ethernet/intel/ice/ice_lag.c      | 12 -----
> drivers/net/ethernet/intel/ice/ice_lag.h      | 53 -------------------
> drivers/net/ethernet/intel/ice/ice_lib.c      |  2 -
> drivers/net/ethernet/intel/ice/ice_sriov.c    |  4 --
> 6 files changed, 108 deletions(-)
>

Tested-by: Pucha Himasekhar Reddy <himasekharx.reddy.pucha@intel.com> (A Co=
ntingent worker at Intel)

