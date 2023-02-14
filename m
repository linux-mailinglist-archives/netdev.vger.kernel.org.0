Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2ADE6970AF
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 23:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjBNWYg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 17:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232183AbjBNWYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 17:24:30 -0500
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48F0828869;
        Tue, 14 Feb 2023 14:24:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676413469; x=1707949469;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lDA5uB2UoRESHPZ6t6KyhDvre3d2FLAYBP13HD/fplU=;
  b=Rd4EwYCo89DOEBl2LZew0yzOzSHgmdqN5kSJnoGZAlKr8oKqXMdEp8kk
   M7I1qmjWXiMH+WEVPn4kuLSOzHxC6mz0Mh4JBFYgIgqw+uv3O4Az/waqx
   TvgPSjtx3RfTFeD3DMRWAW97Yf9Yn1xMOnuDtlOAy8ACEUVW4SiLhHlqk
   MBc0DMjBYwlia4wfGbk8iSoWCGF9dj6HmvXGF1M+kPT+knO8EKdsavQWg
   UMdSdmqinq9HafnTI0FKGZYNpJvFA0eep12ylkCq8t4sP++MqCtdNT2Dr
   Argf4MOhsvs5XcpNfKkoacZqDk2lsDdLcDTKeQSNCqT4hHYGOWIzuR9nW
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="311652139"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="311652139"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Feb 2023 14:24:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10621"; a="699716569"
X-IronPort-AV: E=Sophos;i="5.97,297,1669104000"; 
   d="scan'208";a="699716569"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2023 14:24:08 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 14 Feb 2023 14:24:08 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 14 Feb 2023 14:24:08 -0800
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 14 Feb 2023 14:24:07 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ctq7nZ48hoGfRZ4EXujYa0nsYRYoCaqlUo5zZg84eN5ZiTk8KmutgZGDtFmaz5NYNGphWMG12TxT0+6aerT0cT9SONa95rMRR6ZpIBKkr9etQ63dM9z0PcizdvBDXT63/5IYPbJHSMci/DhnUg080MSxp2CWUt6NVxJuirzeFQacUTYdrufU/xSgVt5yP1RI8aVp4bUpYwazJjVeSttBuBjd54s0AimHFq3oftr0u2SU89ySW9B3QqG+fP3liqpPghHcZZAMyZTQEiCsgX3pyVMeDPagzOqZ5Q1nIQjvCL2H1d8GXr4FTqrocjsxfxI940UMSfcbuxAXJoYxslW4Hw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=wvEctjz2h0RzL6uhmdsqAjvm44rWrMX1chrEW6dWI1w=;
 b=TM9aZNtFTWPBD7MSlQ71huxQzoWywqUT+I3XTWtkI3P372fCbmqRR0Xqscmk3bwwUE6RRfJcUR4zbv9BfdAzzVlM/eOhMVUd+xAb4Lcj6C+nGcEwGSTLXzMov7u5cIdLR5BCxppTWsKSIRp+0PopcsDBk8PX02OKktafic+rD5Km+SpvA0ap0KUrgddZ9ibcfOI3pkDnGqUyOIxlaAGYS0XDiMYaG/bVeJE0FsHiTACnBOXmL4Hd+GdLOwbZYi3dcsZfB/8JgRh0PMlcKKwHrsVfczWJYaEq3nrXepp+7R3M4vllLexvxiBKOEs6IsugGhfBhE8cm7F69y+lFX3XLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW5PR11MB5811.namprd11.prod.outlook.com (2603:10b6:303:198::18)
 by PH7PR11MB5818.namprd11.prod.outlook.com (2603:10b6:510:132::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.24; Tue, 14 Feb
 2023 22:24:04 +0000
Received: from MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5d3d:f1f7:d54c:f117]) by MW5PR11MB5811.namprd11.prod.outlook.com
 ([fe80::5d3d:f1f7:d54c:f117%5]) with mapi id 15.20.6086.024; Tue, 14 Feb 2023
 22:24:04 +0000
From:   "Ertman, David M" <david.m.ertman@intel.com>
To:     Leon Romanovsky <leonro@nvidia.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        poros <poros@redhat.com>, ivecera <ivecera@redhat.com>,
        "Saleem, Shiraz" <shiraz.saleem@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
        Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/unplug
 under RTNL lock
Thread-Topic: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/unplug
 under RTNL lock
Thread-Index: AQHZNbwxlZA30J3NYUy363eW2hehKa652ZiAgBU++pA=
Date:   Tue, 14 Feb 2023 22:24:04 +0000
Message-ID: <MW5PR11MB58119C1D62DAC020FB32ED00DDA29@MW5PR11MB5811.namprd11.prod.outlook.com>
References: <20230131213703.1347761-1-anthony.l.nguyen@intel.com>
 <20230131213703.1347761-2-anthony.l.nguyen@intel.com>
 <Y9o1wbLykLodmbDd@unreal>
In-Reply-To: <Y9o1wbLykLodmbDd@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR11MB5811:EE_|PH7PR11MB5818:EE_
x-ms-office365-filtering-correlation-id: f22f6904-a367-4fde-7986-08db0eda2e45
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: D21o9hy1ZO7VIqGmPBrRSjbCzyjVHdSzlU+BWEwMNEuHsah/YijjM0945bfUpXZufG/xpd4J0Vkq65mGoA4wlyqG2CLyk2hQXKOGxiec8avx1IST9a978q02mf5a4SrvtiJcyo1YMgLLYvG46QJZkfENm3CBSu/ZhdiuazizhJmIDFL0ugHo3P2MmcfuE5VYhVz96o5usZvvjNWf6O0/bF0Rf2pIXdKkmRpmnQvuqO6pmkPpV07CeHy9B84VTpl0NhmR60Sel68WBgRHXZj8KajtObym9qyNDNbyGgcuobMsSxp5SrnZ5cHlIboKytAWAnX1krYtXeuvNVuZIdXjptigqOLkYgzTzBfirgkIcdz8rSZhmPKt2BGIZjcMrD0P3wdvTJpxB/s2U9vVR0EAdb3kAo0m8OJaXCRXEbbiyYHDO7jvFebJI4Fqs9EuefbWBVMOmgQPDAxTetaN2euo2298BEqRvDVdvtoWliIDptPEZadeHqovjPYImwLnVM7n2mrYOPbV5ahJR772CT2ywZ52PBqaHeLFnSDW8cBp4W1Z+DbAMj+4DjMu54MHop2BlHlHxiHPPDW0rRIEDhZiqHtbV/Uxa+Ob5v58TfHY/GLjJY37Kzmb1EX5pOmGpl6vWqIYGSl8s37EXbIuBYfdrSCejzGoic+Cd60xJ5qiN9hR/BBtSstjXC2NWzGz7Uj8
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR11MB5811.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(346002)(376002)(396003)(366004)(136003)(451199018)(54906003)(6636002)(8676002)(4326008)(64756008)(7416002)(110136005)(5660300002)(52536014)(966005)(66446008)(316002)(8936002)(38100700002)(82960400001)(122000001)(83380400001)(7696005)(478600001)(86362001)(33656002)(71200400001)(2906002)(9686003)(186003)(6506007)(53546011)(26005)(38070700005)(66556008)(66476007)(66946007)(55016003)(76116006)(41300700001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?SPGqsGvPhdsswHIvShJUsPOTI1D3YJtekSqxBJK0z6xkUMhQ/Y0CeXdBu+yr?=
 =?us-ascii?Q?QSLOPUlNA/2cwYE1DnWLeUU4ho9qZbaoAXg4wpEEM01DC5NpECIEm6A/Gvkc?=
 =?us-ascii?Q?y8PLog+56pjlQufv3iyhlQCMP+8p7OJIfvc4IN2RkqoPIZUggN/brxaIE143?=
 =?us-ascii?Q?lfoBWPpCySSnjINu3SaQ0YwmBZ600PK4+xn2NL1De102xt8uGELc9MczJn5e?=
 =?us-ascii?Q?2KMZE83uivoqZ+C+FX9kj2aquIzC4i/iqdeYo4qljHWKgbW0+hehTwcxOhOy?=
 =?us-ascii?Q?wL060VUe4mRgKxe3AI3o9RlTCmpQXqe4ffTXb0UagiH9Al/q+mB1NbNHXIWL?=
 =?us-ascii?Q?n7uJ6O2PnrFUWY0361bD/RPUpMMDO8eIe2GWqObhtw4nhxSOs41wzTMdDXGE?=
 =?us-ascii?Q?XOjiSz0Q/NWlw9UzGPzgep0dqC00uM3qpaamjPqOOWD7p3bTFtRsAdZr9gRq?=
 =?us-ascii?Q?gTuIQXfl94WHURn2LcRkfz8mS5pX/IN5VXsVr1V1CMw5kaUFBD8zo7KsIw7L?=
 =?us-ascii?Q?66hO1syfZDfROTKHSbp1zj1DTC5udHaUdfUdLSIjoFScbUhvDt2J3YHZDCnS?=
 =?us-ascii?Q?eb8kAQ2vgKii8lPfQDy8wUheJyYFUvEuCxB1xkVwWxI+FE5pi0zpZwiXSOU1?=
 =?us-ascii?Q?lPMn25VA2/YitTa7Iz5Ls2G/eYJWnsU+5ziVSPrZ5+6pYYBdmlf5xOlBdL//?=
 =?us-ascii?Q?kBRu/K1rS8tl9wpxTgr0ZWI+NDGCUPOBHLVrnbnF5unAuYYk647X9jP4Motn?=
 =?us-ascii?Q?wiJl8wLVn+xo6jZoDN7BOTrJyOepiffdi1x6FqCYlNePJ1ILXIVWQs2oDZRM?=
 =?us-ascii?Q?MbHW7hxLOnziupcnWtqsPqZdsGlqYhYa6TXdBe234jsyM1/2kvrCndkQ7Bcg?=
 =?us-ascii?Q?OQcy1U9hK8C9ouvoAogJx75ksUWjsw7cfh7cGw8bl9J7qpwkkwjtC3qBqIOu?=
 =?us-ascii?Q?/vgUuWk1S/PxhN2I73R9e3Zq3Tw9rBvzOYKDlal7LUmeWGXVa8nvkSThcZDh?=
 =?us-ascii?Q?euk2WDhJ9v4ctY7kyq3xPr4AgwCNXIM/2G6PdLFI7LvBLDKnggsqsvINUrRx?=
 =?us-ascii?Q?iDshhtY3SIjdc/g4neXkfvW+W7w67SP84va9K1aABKsIKkBAo0/tsk6Kt/yV?=
 =?us-ascii?Q?JCzfN2KmoXLAX10gRiEFtCLujn/caC5sjsjMi7gb1/bFPo3BWmhHZNnBvlFZ?=
 =?us-ascii?Q?qS1dkXCkgYqPiAj6xu+hZb3PYn8RLhx7bD+5MSOpwlESnm+5WAu9eE3K+wSA?=
 =?us-ascii?Q?sCjhB0hMrRLwOCXQMPjw6mpoU4ACRqNSgPjYCAo6dJqzYSOSsyyobtdqAdda?=
 =?us-ascii?Q?vpOLRnqqOhJDmpMxPCM+4PLuV0ljb9lcC7POUDml3eRHI8GJzxnVQ4x4WSgx?=
 =?us-ascii?Q?4D1qJF2LMRVNbklz/Fgch3v9Aur+wFxqXz/khz7GJTU3XtQvDFwb6pQjmUWK?=
 =?us-ascii?Q?Ujf9v0ZNaxyp/YnWwIgBaz3paGOxgMn6RB2wfzAttpKNxqLsn5/UdCCjbXxk?=
 =?us-ascii?Q?lccBgmTYjeCTVQ2oxRFuTFeGxgirsjv1teWdgxKS96dh7odEGRUSBKB3ZOo5?=
 =?us-ascii?Q?57Yaa7hAXqW2JJY7c1Zn1tDDNNrHqtZZ8ucKwzBiOSHDWJjXwAxcg8ipi0r4?=
 =?us-ascii?Q?WQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR11MB5811.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f22f6904-a367-4fde-7986-08db0eda2e45
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Feb 2023 22:24:04.4553
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JfSMIcOmaFqKvnSELEkgAgHarXpy4LEQ3qBYZDEQELOsp1WxLgUIsgR1YSH7KjY6DPYXHnFBpU+axTjsIq8Kd7Ejg8AysNoBu7YR+OSfybw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR11MB5818
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Leon Romanovsky <leonro@nvidia.com>
> Sent: Wednesday, February 1, 2023 1:50 AM
> Subject: Re: [PATCH net 1/6] ice: avoid bonding causing auxiliary plug/un=
plug
> under RTNL lock
>=20
> On Tue, Jan 31, 2023 at 01:36:58PM -0800, Tony Nguyen wrote:
> > From: Dave Ertman <david.m.ertman@intel.com>
> >
> > RDMA is not supported in ice on a PF that has been added to a bonded
> > interface. To enforce this, when an interface enters a bond, we unplug
> > the auxiliary device that supports RDMA functionality.  This unplug
> > currently happens in the context of handling the netdev bonding event.
> > This event is sent to the ice driver under RTNL context.  This is causi=
ng
> > a deadlock where the RDMA driver is waiting for the RTNL lock to comple=
te
> > the removal.
> >
> > Defer the unplugging/re-plugging of the auxiliary device to the service
> > task so that it is not performed under the RTNL lock context.
> >
> > Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
> > Link: https://lore.kernel.org/linux-rdma/68b14b11-d0c7-65c9-4eeb-
> 0487c95e395d@leemhuis.info/
> > Fixes: 5cb1ebdbc434 ("ice: Fix race condition during interface enslave"=
)
> > Fixes: 4eace75e0853 ("RDMA/irdma: Report the correct link speed")
> > Signed-off-by: Dave Ertman <david.m.ertman@intel.com>
> > Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
> > Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent
> worker at Intel)
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >  drivers/net/ethernet/intel/ice/ice.h      | 14 +++++---------
> >  drivers/net/ethernet/intel/ice/ice_main.c | 17 +++++++----------
> >  2 files changed, 12 insertions(+), 19 deletions(-)
>=20
> <...>
>=20
> > index 5f86e4111fa9..055494dbcce0 100644
> > --- a/drivers/net/ethernet/intel/ice/ice_main.c
> > +++ b/drivers/net/ethernet/intel/ice/ice_main.c
> > @@ -2290,18 +2290,15 @@ static void ice_service_task(struct work_struct
> *work)
> >  		}
> >  	}
> >
> > -	if (test_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags)) {
> > -		/* Plug aux device per request */
> > +	/* Plug aux device per request */
> > +	if (test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf->flags))
>=20
> Very interesting pattern. You are not holding any locks while running
> ice_service_task() and clear bits before you actually performed requested
> operation.
>=20
> How do you protect from races while testing bits in other places of ice
> driver?

Leon,

Thanks for the review and sorry for the late reply, got sidetracked into an=
other project.

Your review caused us to re-evaluate the plug/unplug flow, and since these =
bits are only set/cleared in
the bonding event flow, and the UNPLUG bit set clears the PLUG bit, we atta=
in the desired outcome
in all cases if we swap the order that we evaluate the bits in the service =
task.

Any multi-event situation that happens between or during service task will =
be handled in the expected way.

DaveE

>=20
> Thanks
>=20
> >  		ice_plug_aux_dev(pf);
> >
> > -		/* Mark plugging as done but check whether unplug was
> > -		 * requested during ice_plug_aux_dev() call
> > -		 * (e.g. from ice_clear_rdma_cap()) and if so then
> > -		 * plug aux device.
> > -		 */
> > -		if (!test_and_clear_bit(ICE_FLAG_PLUG_AUX_DEV, pf-
> >flags))
> > -			ice_unplug_aux_dev(pf);
> > -	}
> > +	/* unplug aux dev per request, if an unplug request came in
> > +	 * while processing a plug request, this will handle it
> > +	 */
> > +	if (test_and_clear_bit(ICE_FLAG_UNPLUG_AUX_DEV, pf->flags))
> > +		ice_unplug_aux_dev(pf);
> >
> >  	if (test_and_clear_bit(ICE_FLAG_MTU_CHANGED, pf->flags)) {
> >  		struct iidc_event *event;
> > --
> > 2.38.1
> >
