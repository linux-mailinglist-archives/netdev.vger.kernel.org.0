Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B44F35A018A
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 20:46:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239547AbiHXSqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 14:46:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238644AbiHXSqS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 14:46:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73AB77A774
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 11:46:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661366777; x=1692902777;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bM/QihfpDvq3Jm/poNBbPVxGjZb48xomGl1Ttqp4zV0=;
  b=E64g9qZLqhYjTzdv35mmCYJSFCMRS+kfcI6nLQ3jd4/HjsSDbv/0kThM
   a2Ck14H5bmnuqVfYWUKhJueyQ2oVBypNRd5rM899dPNcwb4iUe2biDS5u
   UYSEXMTuW6lewfvZV6rSQBdj6LBxw0zPvHaIaEWCdWanTvX9TBq9q/B/P
   w8QOulFmeX60sJna0Npk34OpaFdZZVVsne+JZt+tNWW7iZbr6i4pIjEHr
   zhHIZCjqNkfs4nwmLvJqUT1ICNskE0H+BPrV6Nvp18MQeWAAbfrcySdha
   pm4mv0SwHdTl+Uhgmwj8mB3ajQAjNeAKdqtRguLS23npiCHsiq3lyKXiA
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10449"; a="273801666"
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="273801666"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2022 11:46:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,261,1654585200"; 
   d="scan'208";a="560714402"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga003.jf.intel.com with ESMTP; 24 Aug 2022 11:46:16 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 11:46:16 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 24 Aug 2022 11:46:16 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Wed, 24 Aug 2022 11:46:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Wed, 24 Aug 2022 11:46:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UtP1I2BsFLdWpeBWcH6VgAbwAJHUTpFRX62Y4nO2oJ7QO6CnG1hFCnkrGsMROZfa8BOHnO58BQeMnePZv7ALulA+JB6Naahe5biqEmu1tdGUybYAF7NphB6eJ3/UdRN+ofF6jrBH73Y25DOtiaR+emfHGWbwSrQDQwH+AwxzLEjVLQ+CE3c0o7Rm4T5pZBam8OGBteL6NiywaWnGuUb4+T1/A6XtSBcmzOoTxrQG6vA/iPpkbhUlPEm6NV/Go5BcS4WOQu2ek+yjxBettD/EpsGWBUhUpJXDAOaODRMkUc1bVj+a6mbWCWguoqGJoC9JMJ4bGeNerV/RBtCuVw5Bew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=bM/QihfpDvq3Jm/poNBbPVxGjZb48xomGl1Ttqp4zV0=;
 b=T12r7IN25/uep6VRd2G2tc9cXHrYXHvzi0nBoF7BTY8mkXRyxik170KSWHqv8XFsrVEyaNMrUH5m6js15yJpFupzFhrg6M0JXJ1MYAu2DckSgNbI5doyz3wzT+dA/m/ZcaXrCa+ZrkIUBkACI5MWm2/60wN92ivYaKSYPs6DabWXvgq+vGqpU9mHfQCzrAPWA7S8YiVU8JxdnlvqLsZDTUIaiaRlSd2Yv9UHrnwswsmLjzUqgc96upFAPA5w0/8ABjECtTJmYHf+MiGI/Rp0A7oWl62d0Uf9fQaAm812a+myo7XD57eomWNgOGMHIi6Oqd+CXqULKz7g0hoDviRGzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by DM5PR11MB0076.namprd11.prod.outlook.com (2603:10b6:4:6b::28) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5546.21; Wed, 24 Aug
 2022 18:46:14 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5874:aaae:2f96:918a%9]) with mapi id 15.20.5566.014; Wed, 24 Aug 2022
 18:46:13 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Jiri Pirko <jiri@resnulli.us>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "idosch@nvidia.com" <idosch@nvidia.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "vikas.gupta@broadcom.com" <vikas.gupta@broadcom.com>,
        "gospo@broadcom.com" <gospo@broadcom.com>
Subject: RE: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Thread-Topic: [patch net-next v2 4/4] net: devlink: expose the info about
 version representing a component
Thread-Index: AQHYtkkWIcI2dxy1T0mjsJmFZSav0K27zKYAgAA8AICAANiggIAA3yIAgACRicCAAAuBAIAAB2UA
Date:   Wed, 24 Aug 2022 18:46:13 +0000
Message-ID: <CO1PR11MB508914851DFC032B7E6A3324D6739@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220822170247.974743-1-jiri@resnulli.us>
        <20220822170247.974743-5-jiri@resnulli.us>
        <20220822200116.76f1d11b@kernel.org>    <YwR1URDk56l5VLDZ@nanopsycho>
        <20220823123121.0ae00393@kernel.org>    <YwXmNqxEYDk+An2A@nanopsycho>
        <CO1PR11MB508905A2019ED7C98C2CEB6FD6739@CO1PR11MB5089.namprd11.prod.outlook.com>
 <20220824111202.140ad1fb@kernel.org>
In-Reply-To: <20220824111202.140ad1fb@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 515cf5ef-c7d5-420a-09bb-08da8600ebb1
x-ms-traffictypediagnostic: DM5PR11MB0076:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Y7mSSyhCMdNVtCoP+KPyYgztKIb2CVCrCt5bgAzfsIWdHer0hxh9eb7P/Mkt3cki9oaiJ6FSI9C8IdYnCbo+K8r7MirlQdDMnKuLtklZ8QKvIubi03u+r+eUaFa45hsZmS4ZtpF3j0cqNLvXoy4LFivFxnCRTI8oGwXLooeFUvQEqNkfxk8Oswc0ALavSa4VU6Hw2GP1keoI4KdC1ZbakxViJOmJBYS0NE3tXgpIavMOHcvDEefJ3vruNoDYagTYjOUYjL/15DrzUlGTwEodYxu3L6mgZW6eKm4IenZvyEyAHlxhoMbgR4i1+Sbdjip81ne8dDQ00ZjgKLXWafhV/3majzJnak/Ws6OXGvS+L/NxEb/0mvijMQbSexihJMUPXsvIjJrmG4IBU4jsJle20MItNEPBhqVbaLj/BXZqPV93EyZBh7b00oGsrHDajgDrT8y+wu/y8zymU42TRHTyaGoniqpHUoM9om41zRcp6exc8Sk65H89BCcm5SrKRBvH8KJinCbTS5DV06IRKEV5oyfObAQH95c6o5yLOKA5Lx/+G+KijDWN0jZC+bGDFjPE9w6lW1rTXmxO/r4pctUnmtb6hAqxI7akt74laHjQ3nWVW0Uxkd3tJvxgcsOyfzc/+6+u2gg+Ald86jZpSyKecJhrSxwmHakNENAYZBn16qmPNNhd5Q7U6OqfHASt8cRwIbxdeDeTMghm1iP3PwX6kI8K4fSl8p/K5mkLeEgrU11bahl5ol5hYBfOT4Sq9a8/4RTuIRfnLhHJdw7Sj0Pyfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(39860400002)(136003)(376002)(396003)(66946007)(122000001)(5660300002)(66476007)(66446008)(66556008)(38070700005)(8676002)(6506007)(38100700002)(478600001)(316002)(41300700001)(76116006)(7696005)(82960400001)(4326008)(26005)(8936002)(64756008)(9686003)(7416002)(52536014)(6916009)(55016003)(83380400001)(54906003)(2906002)(186003)(53546011)(71200400001)(86362001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?u9g8Sek+E8utyUCMkBcK91yfqmk4YDrTec4ffaMgE8I+jcH+9rUr7wOdZ4Bi?=
 =?us-ascii?Q?L0TJ86IOVu9acSPRNl+cqPzJE0VTkZRUd3rRxrDKKYX77Ayb2PCidjDgI9gk?=
 =?us-ascii?Q?UECA8ML/nesV+m/ongykmy8jjxuygW/DKM7MWz1GxplTjk26nyqxG/5m/KDO?=
 =?us-ascii?Q?TKTfoTUFldqKHs4vorw1TT0HFYaZHINABHHkasV/B83k3PH47KyCGQci2HUn?=
 =?us-ascii?Q?jLoy8uw6ilcipgZ0UcK3EZUaf0x/D/GVTh0e8bdvxzQ4f7/hv31q2cEa18Um?=
 =?us-ascii?Q?YOel/zUjEXh/DcrYvk78ONLxi1e0lpRXDw8kCA4Tz2b2N10oh13W3rIx4YbV?=
 =?us-ascii?Q?vx2Evo3KaXFkGYsfrqGj9YK252Y20vZL9sEF0TJEzr2jeXSnI6XvdBgVrTlh?=
 =?us-ascii?Q?pr8r06+nC+xja383gTh9pBIeJdkyAz0ng0XRTbOa4FXBAHGubGlQRNP97gOA?=
 =?us-ascii?Q?zu9CYPNlUz1uzgTPdRtoLZ2qcFInTku28WjhcPtUdtnaThJXeUmEoBmIKCaX?=
 =?us-ascii?Q?DusDEYQqUReQDh83iTw08Er6i9WmeEpawta+2ugjPiPnnxRTTJb/7nz11UXw?=
 =?us-ascii?Q?gUvJq8fD2ViZuinzYEzrJ7/E5nlLoJaBh3axMYwUS2OvIEFG9OlUIuqhSkfM?=
 =?us-ascii?Q?yJqJEZbWmJT19uQjxKvThPwTgee5f81QE+oEzI5lcNEVYp6LEPTVt4JLJgvf?=
 =?us-ascii?Q?0SGrSrkLJVafXeGDSdIMaY/FW7SibbhBGRkSn5vfTgtznFgkAGxTdFsSmpTL?=
 =?us-ascii?Q?iUNH8SRr4ntHjuuaXCaRJLc2BFe45ejAg2g9/3hkSJ1eLmyEQu5uZRAjUcgL?=
 =?us-ascii?Q?GeksIEjAyugWNgLeq8/2WD2pR9Q+k0uFLuzf6vNe9YIJuuxiRnlxw1mTD/Mv?=
 =?us-ascii?Q?d+IO5RNf3NYkiY6cdle9FNhPVEmxwX8n4hs4BUljcm0BJS+4K4LHrVFn1V/I?=
 =?us-ascii?Q?clUJ9sikLIi1a4AzE+50qdBamjSz8TB7+DfJVN878NutrMrSf+uNLlIfMIGp?=
 =?us-ascii?Q?cgpksvZ+kH37l7YNlAk8cARrF+TsR0bvmpzE0nnuD4vWCJGaB/aXHa7YL2d2?=
 =?us-ascii?Q?6oNmtUaFc92mXzmKB7KKpZPCPXyJYAdHzawQdogxKe/P/QjDCh4c00KTHDLr?=
 =?us-ascii?Q?xanMn6pvlPUqYi0J03N9zq8R759qgcfsM5eiCnsorsT9fV2N2XUt/Kf7npuS?=
 =?us-ascii?Q?33mIaMnLXkXlG6nq7ZjVgVyy9tA6BFB9mpYIqMS9UYH/fbKObAElHM/RVAVt?=
 =?us-ascii?Q?ji/ys1/pRMLLX6SEQLBYSolZf6bQ+xPIB0Bu9aT2YIaW0oLUlcO9fHaTzJsb?=
 =?us-ascii?Q?3cdievy8SkQ/sM9Qkp7g+TA3XzQpTDSiv75uNwFCWHU2iTKOU2KcbP/eMHgX?=
 =?us-ascii?Q?Abv7bjSIRTe0kXSM65nRI1flSpiGCiPGpwKATbnGALnzuFkAM9aos8p3gWA5?=
 =?us-ascii?Q?/oq6MKeCJs209lYErHqIrZjp6MfEo3TL2AWfQmrvkH+uxrgwXRPcrrvT28rD?=
 =?us-ascii?Q?wzd1w8yVt4hHnQI7dsSnYi8RQfqwkHw9YcETaqTW97C7CiHQ651Bpc48VpSa?=
 =?us-ascii?Q?CCgsQmhrgpVeISrrDIKQ4X9YryLGlE+re25ezrh/?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 515cf5ef-c7d5-420a-09bb-08da8600ebb1
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Aug 2022 18:46:13.8091
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: KVlOvb+VQoJj/+ET2DpOIFlg2NuMm4nrkzqeBdfztpmBhD6lhMddlBvT+TDeEFoOHagPlp0WbVY6V2CS0YMrLYVgkrOUfTsTptk2oVuHSKk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB0076
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, August 24, 2022 11:12 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jiri Pirko <jiri@resnulli.us>; netdev@vger.kernel.org; davem@davemlof=
t.net;
> idosch@nvidia.com; pabeni@redhat.com; edumazet@google.com;
> saeedm@nvidia.com; vikas.gupta@broadcom.com; gospo@broadcom.com
> Subject: Re: [patch net-next v2 4/4] net: devlink: expose the info about =
version
> representing a component
>=20
> On Wed, 24 Aug 2022 17:31:46 +0000 Keller, Jacob E wrote:
> > > Well, I thought it would be polite to let the user know what componen=
t
> > > he can pass to the kernel. Now, it is try-fail/success game. But if y=
ou
> > > think it is okay to let the user in the doubts, no problem. I will dr=
op
> > > the patch.
> >
> > I would prefer exposing this as well since it lets the user know which =
names are
> valid for flashing.
> >
> > I do have some patches for ice to support individual component update a=
s well
> I can post soon.
>=20
> Gentlemen, I had multiple false starts myself adding information
> to device info, flashing and health reporters. Adding APIs which
> will actually be _useful_ in production is not trivial. I have
> the advantage of being able to talk to Meta's production team first
> so none of my patches made it to the list.
>=20
> To be clear I'm not saying (nor believe) that Meta's needs or processes
> are in any way "the right way to go" or otherwise should dictate
> the APIs. It's just an example I have direct access to.
>=20
> I don't think I'm out of line asking you for a clear use case.
> Just knowing something is flashable is not sufficient information,
> the user needs to know what the component actually describes and
> what binary to use to update it.
>=20

At least for ice, the same binary would be used for individual component up=
date. the PLDM firmware binary header describes where each component is wit=
hin it, and is decoded by lib/pldmfw, we just need to translate the PLDM he=
ader codes to the userspace names.

The old tools which Intel supports do have support for such an individual c=
omponent update, but the demand wasn't very high, so I never got around to =
posting the patches to support this. There are some corner cases where it m=
ight be helpful to flash (or reflash) a single component, but it seems some=
what less useful for most end-users and mostly would be useful for internal=
 engineering and debugging.

Users would still need to know what each component is, and there isn't much=
 the kernel API itself can do here. We do document a short description, but=
 that is going to be limited in usefulness since it likely depends on a lot=
 of related knowledge.

Thanks,
Jake

> Since we have no use of component flashing now it's all cart
> before the horse.
>=20
> Coincidentally I doubt anyone is making serious use of the health
> infrastructure.

There haven't been a lot of implementations here, which makes it hard to de=
velop tooling, and then without tooling no one wants to write the implement=
ation....
