Return-Path: <netdev+bounces-9608-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 03F4372A037
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 18:32:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 44E7C1C21177
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 16:32:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14CA9111B0;
	Fri,  9 Jun 2023 16:32:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C661B915
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 16:32:29 +0000 (UTC)
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A941B9
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 09:32:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686328348; x=1717864348;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=BRPb78yUp1T1tysILjKFd9819phU8+/Hg9K8IdFbIhU=;
  b=Kk7nQ2301vugLEHh8YOLFt2ZAcD2nFs8T9naU6jQQKsD8wq7+w3N0z08
   JhABLw8i1srP9aq91YshJLlPHc4mT2TVjMWX6zZjDSQQMCgXVY2qAIOph
   lwQ+lzYDhRvzzviI7+RAlCLSFAtH3MGXx4C0hiBaJFJuGJNix3AIcwcRm
   wSHutg/tZX5b72MSEisG3WtAHurIpzFio5ehvYGQSsAjOBtzoim4mhU0S
   Ctqy8VQDnB/bfVTvmorhecxHGo6L/ONzaQr1ID8mGiEew7FhTKhDvd51Q
   pT3aCJvQZATvbcn/WSjTW0s4S32mn9Df+OY4v4nNDf2ely6ZJThK1dxI3
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="423515252"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="423515252"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 09:32:28 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957209268"
X-IronPort-AV: E=Sophos;i="6.00,229,1681196400"; 
   d="scan'208";a="957209268"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2023 09:32:27 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Fri, 9 Jun 2023 09:32:27 -0700
Received: from ORSEDG601.ED.cps.intel.com (10.7.248.6) by
 orsmsx611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Fri, 9 Jun 2023 09:32:27 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.175)
 by edgegateway.intel.com (134.134.137.102) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Fri, 9 Jun 2023 09:32:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b61kBkgF2e8CitO0HrI2q5d2XfZ9799ucZ0L+L2RYqkuwXGJKwpXczAM9KBhT+Re2/o3PS7Zy/gpNeV049Wyu2xkfTwERKy3km+/6A8yqIwzr/drEXnDRFoyY/Y3VqiZpdx025IwVW7Owar2e7XIeqlEOmt6zNw80AkZvUE/BKr9le72G0rzkIeK/htsm8oZTGR45IJLctqrki/KAgp/Lp6t5uGaUQ2xHPY0YL5zzrhkRGyEKDrNswZRqe9zxOGUuCtQ4BWHQLnU1f3qu+7/FY8U50A6xnAOBjT6Vj68aoT66VPBRGtg7H8Ve/jf+8pKaflVvT7xvT3lG8EA8qsDFQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lovM5RJtld+1J9oAwBF8hyvOrjFENZ7Zehr1oDoM8hg=;
 b=d18A4vRp/YYilSDFwS+lhd8L5KXGtlSJSk/KEx+Z5m5JYnV4pKrclz5S52cYxSvsr2NxInQfjQ8Jd02C8x8nJMEi4ltl/ig7OGsC+AsJ4ihbvIV/+eMoWHmuZMecYwGZ0lyWNhrjgqh3AFs57sR4G82N9Bml45sApUK29zn6Ct48wvdMdiq0/3yKy3XwrrLWFWS9OLkbkoLNULGFhpnYiQTuAgcNji7fYSfoDGJB0qb3pW2BgK5NKFRxIoTY802eZ46+WOEJF9zxnzdclBXulPjXsC8qFF3lFTtWHSdEPIXABaL4rfgg0w+0rWAQalBCBFBvSfi6/u4DvQUDta3e6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by DS0PR11MB6375.namprd11.prod.outlook.com (2603:10b6:8:c9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.28; Fri, 9 Jun
 2023 16:32:27 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5e37:38f7:33d2:137a%6]) with mapi id 15.20.6455.030; Fri, 9 Jun 2023
 16:32:27 +0000
From: "Ertman, David M" <david.m.ertman@intel.com>
To: Simon Horman <simon.horman@corigine.com>
CC: "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>,
	"daniel.machon@microchip.com" <daniel.machon@microchip.com>
Subject: RE: [PATCH iwl-next v3 06/10] ice: Flesh out implementation of
 support for SRIOV on bonded interface
Thread-Topic: [PATCH iwl-next v3 06/10] ice: Flesh out implementation of
 support for SRIOV on bonded interface
Thread-Index: AQHZmjQsaFSLqVaJM0qO8XdiSZCXbK+CLYCAgAB6sNA=
Date: Fri, 9 Jun 2023 16:32:27 +0000
Message-ID: <MW5PR11MB58110D453C6E6BB15AD4A53ADD51A@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230608180618.574171-1-david.m.ertman@intel.com>
 <20230608180618.574171-7-david.m.ertman@intel.com>
 <ZILqX7x7RP/cN5+0@corigine.com>
In-Reply-To: <ZILqX7x7RP/cN5+0@corigine.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|DS0PR11MB6375:EE_
x-ms-office365-filtering-correlation-id: 3948a918-68a0-40f2-eb68-08db69071cc5
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EUHRoaxeT9k9m//1i9wCjrMjIjUiCRRxCy2nnXf1y5Z2M6UBIcygnIauiYAXWMa6H9G9AUmMgm86H1/NdhowDPWrtQevL8IU7Jv+2pAVK5bNhcfBDTTUNYYMqhdyKuogaRULGaCVHSihCvVUUVjGixEMrlYH+eqE7eVjn7C2fFqOOkYebjUtydaUl8np/H0xINU+tPYT847FFBfDSOk0L7HSt+JW8YQL4u8GPfqmrvYxinVTKvAVYEkmxCzlDJBCOgM1nvp5wCQzxDPaeZ3dbUFEmh2EwgbnhuP02BD395ggvNX+hf3LGF4MeQdkHMFeKu0qBPJ4M9p+oKSzcyQpmd2C83IIDkdH4cosgt18OZ9iXqaVc8fXozs3n7A3BxN6A7t/zkKEGZBUnKLP/Nt5rNQFFWx1uomwBQkKRkLH1mAl2e/RyEhsZJCwDl4wMqNeM+ybJtTAVrq0k4OwYYMEODBg3v8eddG2ZwMAjvoSftJVEWoTfSwhNZWhhaQ9GasQqvhaWjX5Pz/GoNKVSrhuednNYHPG5lQIOBnVbufeydx4/SPaZXFSeeL4DkkWIVZry/lRdiU8mrhqSS/oct6xEVJKPTmTF2mlNwpRmBRc0KIYpYJfkHY1YrAXwtsk8x8T
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(83380400001)(38100700002)(55016003)(33656002)(86362001)(122000001)(82960400001)(478600001)(38070700005)(316002)(66446008)(71200400001)(7696005)(54906003)(76116006)(8676002)(4326008)(5660300002)(66476007)(66556008)(52536014)(6916009)(64756008)(8936002)(2906002)(41300700001)(66946007)(9686003)(26005)(53546011)(6506007)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?lADUs/zHF/et+96bpXWeEpNECh+Li7t+U6xM8ZUDfN6yifH2wBhXJUf5M2g7?=
 =?us-ascii?Q?Emsmfhs2USA1QhkxItHir06rUVx9KZTVoKoRs3edReGNTcSHrNl4mev5b/SV?=
 =?us-ascii?Q?ug5yRKnaubK8eaB9PSs2/BvQvVuF3SvyBsEK82nXsPn5ZseN/1NB4qm7ezXJ?=
 =?us-ascii?Q?c2c57FcKTSQWvJsmpflDBFAuM9kcH+Ab8EYtWQPQ3wjss6t7yJ/oC18Dd5vc?=
 =?us-ascii?Q?stEU4etgL1O0gzACyoFRSXEQeKl76yUlkUVSJj36LHsnabL/Kap5E9sANMHh?=
 =?us-ascii?Q?z3a8QdZ4JN0+2tKcJ2jdiZURN5IVnD1Y/37GitUG6OrpARaXI/hYkqUaBJv5?=
 =?us-ascii?Q?HZm3HrdxUkX2ganiwYUZfYkR65yC1BS7Q1Q381BEwdrjO/f3QFdl8secvdCG?=
 =?us-ascii?Q?xHiT7t8Hu72Vr+LDjB4m2VPo45kMW9/1DL7ANp+REOUuDUEV8/aJaWYgT2LW?=
 =?us-ascii?Q?Ok7m3YXMVPQoY7ipId5D9dVickXS5pZMQRicGXD1D47/SzhieZwgHZ+U0PS5?=
 =?us-ascii?Q?NDNxAMXaVorcUi7A/ehI15KccLBScwCo89qv5AKl4VxD9urn9lJ6pePON0nP?=
 =?us-ascii?Q?RLpAF0YTva5teVDlJcg4DeJJq5mwxtPOS5Ajijur5V93877PU+gU5NQ8CkhS?=
 =?us-ascii?Q?b5cjkuok3x7bYXi3ObWvzu32y6bxcNJf1n9n+i6OzPyxaaFfqs5YNRBO7p5O?=
 =?us-ascii?Q?NxMtG0rl0DYYW0x5Gi/oFxxicuO+HvAXAe6rgEm3jss46KySfjeuHjyxqQA9?=
 =?us-ascii?Q?dNaJCDrf+mWhQWveSS3ssiSNinUWdPKscjTsvpvVuaJHEMDzZqby5O19HLn9?=
 =?us-ascii?Q?tuTsMAsI43p9BQ9dG3w9IepwG0v7X71Uu0E4jSH3xkh+sxVouLhwJSuwQpTh?=
 =?us-ascii?Q?AVSbNcoJZ4pbXx0liGE90NQ5eF2k8LBolCrflLyEyiVqBlEdn9JFvlzsHNGm?=
 =?us-ascii?Q?cQ8oy0C/ZwgVvkQaysYya0vtc1vSYlgN2waZfXDKhrDXuKO4UCIOHMsosoDA?=
 =?us-ascii?Q?RpPL8niabqRXDTSqF/t7iY71b5wqrKmx11tmE3FmKOFsYM/qolz18kCuWDw/?=
 =?us-ascii?Q?HqRfYzdeIijn8BK9ZpkpuZNdoK01Nld3uQ7nBnCBPCa2ok+hJQfz9GURFmhm?=
 =?us-ascii?Q?jYkkNKvLLfwc+d3gl6VdOf1ipkTkLh/P4kJ6rXOzqg8378gllT5vJyMi3AwK?=
 =?us-ascii?Q?sc6aT2XWnTDxrFwUn+XtOAW3CLG5XKTxHCfEOm0heoegSwBI+EO4VoUaBYzH?=
 =?us-ascii?Q?H8NqmBHOx4ZEVdUYab67srKoAI15VxmymS54XHVf3/zofjbbQSRD1evVb2IG?=
 =?us-ascii?Q?1EztqfkwLWAaj5ri1ZIiTjYQr2vZk4U7Lx09nLVSgHDoC/B5GXbD+CvfL+vK?=
 =?us-ascii?Q?OzBIrA9Ou9Vlro4xTrZmX8ilZRoM+ogvJnytppGn09OJUeHWDKmwScpsN0XY?=
 =?us-ascii?Q?inqDYY5jEB4sj8v9DJk2D9IJPGaH4v0Grhb58379t72XO3MzHu5nKmBBD6ml?=
 =?us-ascii?Q?3sQt6CbIb++Drxt0O/usouHEav0wsQkXX+f2A8N3bVqVoxsGhHdTrg98+2sj?=
 =?us-ascii?Q?FaKnPuNSTDhHGPw6n7QYiFyc0LS2NKTLkGJ4kl7Q?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3948a918-68a0-40f2-eb68-08db69071cc5
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Jun 2023 16:32:27.1128
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: njTuX+qdtn1r2b4rXm4CE8/bT0r3kTAr8KbmqO+pHj+V0+B6xHpLMROBTTzw4YkewX4F5Q2+uiqyM1b5QMzsO9JNFc/8eHSFXDKK84YJ4W0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR11MB6375
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

> -----Original Message-----
> From: Simon Horman <simon.horman@corigine.com>
> Sent: Friday, June 9, 2023 2:01 AM
> To: Ertman, David M <david.m.ertman@intel.com>
> Cc: intel-wired-lan@lists.osuosl.org; netdev@vger.kernel.org;
> daniel.machon@microchip.com
> Subject: Re: [PATCH iwl-next v3 06/10] ice: Flesh out implementation of
> support for SRIOV on bonded interface
>=20
> On Thu, Jun 08, 2023 at 11:06:14AM -0700, Dave Ertman wrote:
>=20
> ...
>=20

...

> > +
> > +	/* add parent if none were free */
> > +	if (!n_prt) {
>=20
> Hi Dave,
>=20
> I suppose this can't happen.
> But if aggnode->num_children is 0 then n_prt will be uninitialised here.

If aggnode->num_children is 0, something very wrong (to the point of the de=
vice failing probe)
would have to have happened.  But, you are correct, it would be better to i=
nitialize n_prt to NULL.
That is a nice catch!

>=20
> > +		u16 num_nodes_added;
> > +		u32 first_teid;
> > +		int status;

...

> > +	/* find parent in primary tree */
> > +	pi =3D hw->port_info;
> > +	tc_node =3D ice_sched_get_tc_node(pi, tc);
> > +	if (!tc_node) {
> > +		dev_warn(dev, "Failure to find TC node in failover tree\n");
> > +		goto resume_reclaim;
> > +	}
> > +
> > +	aggnode =3D ice_sched_get_agg_node(pi, tc_node,
> ICE_DFLT_AGG_ID);
> > +	if (!aggnode) {
> > +		dev_warn(dev, "Failure to find aggreagte node in failover
> tree\n");
> > +		goto resume_reclaim;
> > +	}
> > +
> > +	aggl =3D ice_sched_get_agg_layer(hw);
> > +	vsil =3D ice_sched_get_vsi_layer(hw);
> > +
> > +	for (n =3D aggl + 1; n < vsil; n++)
> > +		num_nodes[n] =3D 1;
> > +
> > +	for (n =3D 0; n < aggnode->num_children; n++) {
> > +		n_prt =3D ice_sched_get_free_vsi_parent(hw, aggnode-
> >children[n],
> > +						      num_nodes);
> > +		if (n_prt)
> > +			break;
> > +	}
> > +
> > +	/* if no free parent found - add one */
> > +	if (!n_prt) {
>=20
> Likewise, here too.

Actually, this code was refactored out into a subfunction in patch 10/10 fo=
r
this series.  In the subfunction, n_prt is initialized to NULL (for purpose=
s of
using it as a return value.  I need to move that refactoring back into this
patch since there are multiple uses this far back.  Thanks for pointing thi=
s
one out to me!

I will send this change out in patch set v4!

DaveE

>=20
> > +		u16 num_nodes_added;
> > +		u32 first_teid;


