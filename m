Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43496EF855
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 18:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229937AbjDZQWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 12:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDZQWb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 12:22:31 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C74EE72
        for <netdev@vger.kernel.org>; Wed, 26 Apr 2023 09:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1682526150; x=1714062150;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=csI89+7PFUp9k4JjEvl1Em7/s6KUSf0nbvVH+gn8xUw=;
  b=lPXlB95KQesGe4m0sjjhp7sACF1cpDmPE7cBuFMetAqTZFS6Xg2I+wWm
   MeV7VwVtPwKD1QJEhyEzFMvWiDX0A3DZFcIWMYKNPCBd03uUizu6cns/u
   JEgKsvYQcgUExGNZg+e768QP6pwJUg3inLHhF5fkhb0jpaY18lgkVn4BE
   P580NSMTgkE2AO5gzDnHbwTCw+PeeZI3ae1IXseNpdWH78L1PkhQP2SX1
   49AQ2FpzakWYrdRCXtytwjZ++0yq4KfHA7qL7nbYPs/GJcfEKre/iJCt+
   VCq4e1D84oJPhS9b//Qevr/O7PxDwmat9s6X845OWqQvnnDM4QV7Sg2gw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="327480589"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="327480589"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2023 09:22:29 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10692"; a="726607779"
X-IronPort-AV: E=Sophos;i="5.99,228,1677571200"; 
   d="scan'208";a="726607779"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga001.jf.intel.com with ESMTP; 26 Apr 2023 09:22:28 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Wed, 26 Apr 2023 09:22:27 -0700
Received: from FMSEDG603.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23 via Frontend Transport; Wed, 26 Apr 2023 09:22:27 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.170)
 by edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.23; Wed, 26 Apr 2023 09:22:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UMZa5pO6eKyreDpo8UWRHzQzYs0QIbafmM/QXYr0VqZfbycPnoQdvlHCkBe2EXo4ZYL/nvd4DZAZqVOD++RCMzFKmpz0Ed4j5Zf1y7D0wwnXUIc2W+S3R1kcEW1AiF86P3zOu6KYhGUQzscUkRYMivT5Y3p++sB8Z0K6UqVtZ2mwsahFrgVYpbrrkyGHJAIx6rNhnSJxtgrntiR1rpiJfp2AadK434WWstJfUke2NOGdHipmluZcBsRUKvvu1OAvaUZaSaeBWZeq9BUSEZq8Nxa0Rj2T/c0dgkoMXBeYKZO4rZwpOEsGc+yMQ49cbkkbhgB8uyYTjZLvMXorBZBK6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jDTsWl9Ajq1lZfmRdoPWTc61qlnKKHjCIeCluEcSrGY=;
 b=IEfGVxaowmf2inTUu5sAo8+TmXcyg2DWwqWFoqJrMjN1xANV9rSC5ThbxQ0r+thiKAU36UEkj9Hu83yIzEMVdIMMZpMTRXaj96V/YUjI9PnLpwuCRq2MOk3xwxfyWgMVIOZJFAbc4BSRznIXnZz+Kkmg9ztdDxr7INveHVQMW89YOASbTb/bRqkWT50vsuZTe4TAb3UlcKA5NDUzMham9o6nodVuLiSBbO1UC8UdUl8+m2y39GP2a+qiBDnkSmDMf1zYgKYhS/f/0zLFmLlrJDsb3ulkfff2ZsSrl9EWQKSuwTbEtZtGRDeeB7wQI4ZJ/yNSpXuB9dZB4eF3X+AQ0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW6PR11MB8309.namprd11.prod.outlook.com (2603:10b6:303:24c::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 16:22:25 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3c6f:a70d:414b:98f7]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::3c6f:a70d:414b:98f7%4]) with mapi id 15.20.6340.021; Wed, 26 Apr 2023
 16:22:25 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Wesierski, DawidX" <dawidx.wesierski@intel.com>,
        "Maziarz, Kamil" <kamil.maziarz@intel.com>,
        "Romanowski, Rafal" <rafal.romanowski@intel.com>
Subject: RE: [PATCH net 2/3] ice: Fix ice VF reset during iavf initialization
Thread-Topic: [PATCH net 2/3] ice: Fix ice VF reset during iavf initialization
Thread-Index: AQHZd5gB5cGX3kRXU0O5m0FmgMoDba89J12AgACe1zA=
Date:   Wed, 26 Apr 2023 16:22:25 +0000
Message-ID: <CO1PR11MB5089EE31C5E298306B8BF7A5D6659@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230425170127.2522312-1-anthony.l.nguyen@intel.com>
 <20230425170127.2522312-3-anthony.l.nguyen@intel.com>
 <20230426064941.GF27649@unreal>
In-Reply-To: <20230426064941.GF27649@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MW6PR11MB8309:EE_
x-ms-office365-filtering-correlation-id: 8a888c3c-cb8e-4fa9-efc3-08db46726c34
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KePRWfez+ki3oPl9afJB9/CPqGnoK9WBSMbXYyrL1cAEdRdf3ywAwtiyZdeaLrSB8W5rJjYp299a/H8ASiB2PlNO4NRAWhX1YPHzcq4qtlAbNVh8z6c5OpX1xSfak3dFA9VJlZeH+BIou4vRba2OyCROmxOHx5ZEFxCgD2TyDJV/fb14Xf+/pP6OtH1A8/qoIkayS45/HoATwEHT17ZaolvyUoqwd6sOUDJx+stzPmZAiXhX6hn3H+VUptTV1a9I+BU9F/oFp1Ixs4R4bxhn+bw9SlFM2FeC4A+dLJ0O2XcCzbHT029IwEfXltEYsmD8iuEoDLh0a2ScVL4IdVgE5Vs20JdGk5j1Lr8XE8+wnQcRH7rgQ0UozvcGEKQIoIz3+GnTdCv7la0A8+hJ7qpXd9NaB4kRY5Fa+4FUSNtrCGeBAfQZ8aVrsQ5/fYQHkKS/MNhasXt5AbQS5ou14adimQWrZkKD1IzJfVJ8hhHZneAqtjt9dkQnhdDKP+9hi1vHkkxdFYuUi/ZSoajHOSF+XWfoLXQEJt4FaQavH/nWK8lg1IxVeSaap2RALRE5UgfKZ+IsbTtjN+rXF45g2OCay+hpG9erOnQ6hcR7XxUhOqfU8uwAcqXi+NUHUi/WCJJC
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(136003)(376002)(346002)(39860400002)(366004)(451199021)(55016003)(122000001)(82960400001)(38100700002)(107886003)(26005)(6506007)(186003)(53546011)(38070700005)(9686003)(83380400001)(2906002)(8936002)(8676002)(33656002)(5660300002)(52536014)(86362001)(54906003)(478600001)(71200400001)(7696005)(64756008)(66446008)(66476007)(6636002)(66556008)(41300700001)(4326008)(66946007)(316002)(76116006)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bDEoVy4ayf0z6dkQ1w39nz+LqHfTV7eCtsdaeBmDgQSXdWA5j6kzIQxn/HlL?=
 =?us-ascii?Q?dBPxPSUb/yPjsCtJRg0vQ1qBLJ4QyHtJS9EKGpv0PlpcE9TwbkCUFKJvdyWv?=
 =?us-ascii?Q?h8n2N19ng1jWyy/lvaS0LVCh+YnrWg0EPLo8KM9KFJgr5fMcsDFxnr6m15P+?=
 =?us-ascii?Q?7AJutO5EyOpUV47GEeZEKBE0mU4afoDIBgUjqhfyJY6MpyRtzleRmA4pIHZd?=
 =?us-ascii?Q?8f+fK5StFRJJHw4gtFM3c9uIiLxYoAUY56GlEwDMekYXHZRzkyzeqFl692mB?=
 =?us-ascii?Q?sCXJ5Dzeh42bTdIAGc3LQYae+Z+gmnoAg8kfrBE55T89j9/q3GKDF0mD8MG1?=
 =?us-ascii?Q?SN85zC31o76W7dxLFMf3m2Bgf46Jr6i04d6RpmJpBN41gG5Sz16B4nxEAOHd?=
 =?us-ascii?Q?x539VJyugu8Z9xU3SU74q5DwxKrlst3b9S+v32ryHy/9AtQdO5svjKmnREY/?=
 =?us-ascii?Q?5PlwkrJdI1TPfKeeIl0td5OhupbmaGtiQ00HejYZoS58rRvftrkg2LrKbURr?=
 =?us-ascii?Q?FyjQPjCIzakslc9/1rcuRri+lf5T2xsSax8miivjpg6W6ZVg/VxkBT5IAvco?=
 =?us-ascii?Q?Spmji5WcZVXxUeAhk64kL0h8YrRJjZaBenVn5MR6HpYKBDEGtXrUnVB63o6H?=
 =?us-ascii?Q?5qCh63laKE5ezk6e5i9xuMEsFQ9sisErxCoJB1J/BdPSwqtF9fhH5UQSfA+9?=
 =?us-ascii?Q?+LxdMU+ZIn+WE+hmbpmRrzsb5qb7eK3Xg3gbHurIKWpkq/DB+3QvssHeT4Mc?=
 =?us-ascii?Q?OGY+xG38qQ9ULTArR0POHbPfSInyGt40BmMsb2bqVakrmLVWGvXoT4jgIWOa?=
 =?us-ascii?Q?DH3FN5rn7ZvBdySQvw6+JXGNd/fIulAHAT3hKOF+TuKTfCFueDfZ1mgwFsR0?=
 =?us-ascii?Q?ZsRvRlgDO9F1uFdofJAnwSzVg1JgC0Y1x27PwYWyGQSVCUjDK/FJPSwTvRZ7?=
 =?us-ascii?Q?VAemJXzR1F5JFKBdXf0FGUjVogu0/IyAEso9R9kgMBJX4STneS0FuN7vEIqo?=
 =?us-ascii?Q?HfMt7N0XT28ex2HxHcxOdcNkuaSBFAQ063+Lf+satdqwASjB+Qk9i7+ClDnl?=
 =?us-ascii?Q?43keo1tLti5mZFQNr9rQ0QWFbYvevT77USEL/3ePQ8bGfdtWE3aT1owRBvlh?=
 =?us-ascii?Q?QUkmSyIPR/k9I0tslGCZ1Dy3OWHykcyw4h+oYn08VJqoenrgbevRl5oyoA8I?=
 =?us-ascii?Q?WBEz9IgjpDr9yhjdCOzKBL7CGz7mR+oActGCkkYK8h6WO3Q5ZQhe9qfe0Cil?=
 =?us-ascii?Q?cz5AGdTdWyCBLI9P9nMnSWl3SuNKOSXWFZ/XKG6lsC88DJ4C4B4gxmIBP1zW?=
 =?us-ascii?Q?Gc7eBaNwqqYSjeQtP6CWEoKb6onitgQu39qwGkDaj4rp+trIaPids0dvwHrd?=
 =?us-ascii?Q?RLZARFwyc0MPKuOUeAUGWjZEQiQ83eVaqA7Oo5Au41zH53LOeLgZPaL2iDmB?=
 =?us-ascii?Q?g/8+ZNfqFzWzc36vsDqX680WgXPdyTjMnqTEdDCwDY/h4YT0ZUBAAXYotBcT?=
 =?us-ascii?Q?s+0WpTz+CHuxClPJyBntW7DpFAlrJ273fTkhl4M7vxyc03W3CJRBF4WQjndI?=
 =?us-ascii?Q?ZLTcnq2Ws2D3BHuMa0hE3quuiCA/6h47eIjNTXY4?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8a888c3c-cb8e-4fa9-efc3-08db46726c34
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Apr 2023 16:22:25.8535
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PiToTupj48Dl5Lr7EuSwsbWScSTV5Ws8euFML3G0JV3mF+gW2fXbvyj8mHhVPBJLk9Qv0Fc8L4+/FZ0Bdjz3x7oB6AxMWMTv+ixLJMSKMm0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW6PR11MB8309
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Tuesday, April 25, 2023 11:50 PM
> To: Nguyen, Anthony L <anthony.l.nguyen@intel.com>
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; netdev@vger.kernel.org; Wesierski, DawidX
> <dawidx.wesierski@intel.com>; Maziarz, Kamil <kamil.maziarz@intel.com>;
> Keller, Jacob E <jacob.e.keller@intel.com>; Romanowski, Rafal
> <rafal.romanowski@intel.com>
> Subject: Re: [PATCH net 2/3] ice: Fix ice VF reset during iavf initializa=
tion
>=20
> On Tue, Apr 25, 2023 at 10:01:26AM -0700, Tony Nguyen wrote:
> > From: Dawid Wesierski <dawidx.wesierski@intel.com>
> >
> > Fix the current implementation that causes ice_trigger_vf_reset()
> > to start resetting the VF even when the VF is still resetting itself
> > and initializing adminq. This leads to a series of -53 errors
> > (failed to init adminq) from the IAVF.
> >
> > Change the state of the vf_state field to be not active when the IAVF
> > asks for a reset. To avoid issues caused by the VF being reset too
> > early, make sure to wait until receiving the message on the message
> > box to know the exact state of the IAVF driver.
> >
> > Fixes: c54d209c78b8 ("ice: Wait for VF to be reset/ready before configu=
ration")
> > Signed-off-by: Dawid Wesierski <dawidx.wesierski@intel.com>
> > Signed-off-by: Kamil Maziarz <kamil.maziarz@intel.com>
> > Acked-by: Jacob Keller <Jacob.e.keller@intel.com>
> > Tested-by: Rafal Romanowski <rafal.romanowski@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice_sriov.c    |  8 ++++----
> >  drivers/net/ethernet/intel/ice/ice_vf_lib.c   | 19 +++++++++++++++++++
> >  drivers/net/ethernet/intel/ice/ice_vf_lib.h   |  1 +
> >  drivers/net/ethernet/intel/ice/ice_virtchnl.c |  1 +
> >  4 files changed, 25 insertions(+), 4 deletions(-)
>=20
> <...>
>=20
> > -	ret =3D ice_check_vf_ready_for_cfg(vf);
> > +	ret =3D ice_check_vf_ready_for_reset(vf);
> >  	if (ret)
> >  		goto out_put_vf;
>=20
> <...>
>=20
> > +/**
> > + * ice_check_vf_ready_for_reset - check if VF is ready to be reset
> > + * @vf: VF to check if it's ready to be reset
> > + *
> > + * The purpose of this function is to ensure that the VF is not in res=
et,
> > + * disabled, and is both initialized and active, thus enabling us to s=
afely
> > + * initialize another reset.
> > + */
> > +int ice_check_vf_ready_for_reset(struct ice_vf *vf)
> > +{
> > +	int ret;
> > +
> > +	ret =3D ice_check_vf_ready_for_cfg(vf);
> > +	if (!ret && !test_bit(ICE_VF_STATE_ACTIVE, vf->vf_states))
> > +		ret =3D -EAGAIN;
>=20
> I don't know your driver enough to say how it is it possible to find VF
> "resetting itself" and PF trying to reset VF at the same time.
>=20


VF can request a reset via virtchnl, and the PF can request a reset due to =
system administration activity such as changing a configuration.

> But what I see is that ICE_VF_STATE_ACTIVE bit check is racy and you
> don't really fix the root cause of calling to reset without proper lockin=
g.
>=20

I think there's some confusing re-use of words going on in the commit messa=
ge. It describes what the VF does while recovering and re-initializing from=
 a reset. I think the goal is to prevent starting another reset until the f=
irst one has recovered. I am not sure we can use a standard lock here becau=
se we likely do want to be able to recover if the VF driver doesn't respond=
 in a sufficient time.

I don't know exactly what problem this commit claims to fix.

> Thanks
>=20
> > +
> > +	return ret;
> > +}
>=20
> <...>
>=20
> >  	case VIRTCHNL_OP_RESET_VF:
> > +		clear_bit(ICE_VF_STATE_ACTIVE, vf->vf_states);
> >  		ops->reset_vf(vf);
> >  		break;
> >  	case VIRTCHNL_OP_ADD_ETH_ADDR:
> > --
> > 2.38.1
> >
