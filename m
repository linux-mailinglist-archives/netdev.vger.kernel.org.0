Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 026A54BEF47
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238646AbiBVBz7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 20:55:59 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiBVBz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 20:55:58 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1F4925C4B;
        Mon, 21 Feb 2022 17:55:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645494932; x=1677030932;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=bPIff9rJ/n8Mknr7b8zQh7Bley0ca+xpOOvnU3Vr8Jk=;
  b=YAEUA4QHaZiFhBTXF2eiNrlUeD/sWN9ZqfZajt5i3C+h+mZx+dQ4zQMx
   VKI5zH30/k8CVUY3NN6FFiL+M+L27X/aYUna0AIQLLv0NvnQnHZPAmTt7
   JH6Kl2VsQaG71Y9YL2Hgses1U6ys2vpkqs8SU0UOe/Nkf8sfqML7HliZ9
   6VMYi7yrz4vpCdaI0CGw3htO84mK8e1egCs9jGGhAoF/ZVqh/kK/X66Nx
   UbOIIVENudSc/rGSoQu64SrJM0cS9soz07vdBj5z17nfGDAvB105rz0j/
   0tOtbExqLEBw4vk73GBycmij6y2dX07uLXZ6mi/jjTccRBU0R+1/XvEC0
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10265"; a="251360288"
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="251360288"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Feb 2022 17:55:30 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,387,1635231600"; 
   d="scan'208";a="778828848"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by fmsmga005.fm.intel.com with ESMTP; 21 Feb 2022 17:55:29 -0800
Received: from fmsmsx610.amr.corp.intel.com (10.18.126.90) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 21 Feb 2022 17:55:29 -0800
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx610.amr.corp.intel.com (10.18.126.90) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 21 Feb 2022 17:55:28 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Mon, 21 Feb 2022 17:55:28 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.41) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Mon, 21 Feb 2022 17:55:28 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUuHmVXIjB9QfvFlYP/mnGu4embVf4wg0xWv6BOmapFxCiDm7fa4wxzQyXfAMRdK26CKxH53YwO1S49mE9dmlnXGNpql3N8bTdSMGR9jnIc0JrppquQkvHsB9eJ76081EbA9SeQ7B3C1Lf1O/1Lg2T4RDe1zNxlwqR5IM8rTLJIJ7dP+A5kL+ISJVR8qA2VIUgXcoOPZy4xkFQyavADKuilKA4XM1RzWLdCEC4csTmdfauJhYQg4F0mSMLB/rag1kN+3gOC3saYqbr7rdOOuiqyhAUE0jlVyNQ61N2MB3WRuNx6zkEQ5h6tslrqkckkNRvf9UDA3JUTrUUkdGeuxwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oLTvG3z+325FUG12SuDdHE8mwBcbhaZCU7tLNb0oF2c=;
 b=h4+ZliXHPcolyjUUg8C5SUvcrFpDZcKItQZ5HhbPBcrUws9OsNCYch+7MI1gdUNVFiwd3kGD2wm/dNtVnSCFiujETOuFqpZF/d/A19Lb//Zh3X96pZkAF7oepJ2gu/BUzhUnRz4lH77hp7xFeKMf8hSEHmRaP94kZ9Fjg+gxc49g6Er87kICCNKhxxFF9p+Bjpd5YWde8saiEG1l9PZq/VWoIS4u8DIk+qZtpnbZPGhPz4JKSADzz+z+BZyPlCSd3POSqB8aAFVl1fG48pEZCxISaQJtP8t7ETsAmTXMvy2PYU60Nh+SLZ89wB46SP1XPyRiTAcNQDCmPPGR8Lq/Tg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BN9PR11MB5276.namprd11.prod.outlook.com (2603:10b6:408:135::18)
 by DM5PR11MB1305.namprd11.prod.outlook.com (2603:10b6:3:13::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.22; Tue, 22 Feb
 2022 01:55:20 +0000
Received: from BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d]) by BN9PR11MB5276.namprd11.prod.outlook.com
 ([fe80::f514:7aae:315b:4d8d%3]) with mapi id 15.20.4995.027; Tue, 22 Feb 2022
 01:55:20 +0000
From:   "Tian, Kevin" <kevin.tian@intel.com>
To:     Yishai Hadas <yishaih@nvidia.com>,
        "alex.williamson@redhat.com" <alex.williamson@redhat.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "jgg@nvidia.com" <jgg@nvidia.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>
CC:     "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "cohuck@redhat.com" <cohuck@redhat.com>,
        "Raj, Ashok" <ashok.raj@intel.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>
Subject: RE: [PATCH V8 mlx5-next 09/15] vfio: Define device migration protocol
 v2
Thread-Topic: [PATCH V8 mlx5-next 09/15] vfio: Define device migration
 protocol v2
Thread-Index: AQHYJkCH07CQB0sr10KjEWYxyXMEIaye0dWg
Date:   Tue, 22 Feb 2022 01:55:20 +0000
Message-ID: <BN9PR11MB52769CE4DE386BDF1325F8698C3B9@BN9PR11MB5276.namprd11.prod.outlook.com>
References: <20220220095716.153757-1-yishaih@nvidia.com>
 <20220220095716.153757-10-yishaih@nvidia.com>
In-Reply-To: <20220220095716.153757-10-yishaih@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14eff236-9990-4b61-b03d-08d9f5a661fd
x-ms-traffictypediagnostic: DM5PR11MB1305:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR11MB1305B9161D6CF1992DC824FE8C3B9@DM5PR11MB1305.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GPDg3PcX1ThXL3wyqtUUscBjHDPPdV6jQZKYMnyZiqRZWrE36WH/1WA8KoROTHFzFsdaRkFqG7B5aol+AUWlxbTAOEInOydW6qhYAsvfBuQC3EvlQqMpZ+Xih7ZTWyxy+dP6cPKWjM7zMtXdAw4tgHvmznMe+a5DOdFhpdhn1ubnek+hMonOf3843jfDDsz9pG/I4kqgfeh3B8MxnzHVuwHj3169BPSyEQHKpZQMfGFEW0Ul7RzxGuvQcq+4yEYS57yUk5valMwuJbD97Lx5Yjcvjlmy1wINeRuYyaZlJBvpyEjMPVSPns9ycjdaSRzAud54eMISNoY5d/Ttee5Og3k1Fjm7Xtv4HMvu7Oe6URrAxMgkOpyeTeHSqBrY4T4BxcP3XdnT3nGxXNN24rYwGA/uws5+cvQ9Ijh2NxnCOGGQzxpCxS0AadU7GKEsmWgE6hl+1Eufq/LvJuwQ1ouT5wri7E9rPY25ilXpypvKhIGFqSuyogGWH6qmfPNUKK9v2W/u+An3kQAgFa4KQ5YtGpHILN7gWN4C7O7wcorwG+rLXWRY0eC15hE//csRU7PuSiwXSPIPtxYy3xOcOcFZH/8aKw3bSD7/ya/jRRpPD8kgzzq+xNBT3elNSCXnTvmxqoegEFwQa+qnd0l9XrR7db5xgl9MmkI7sSEmQbTfdq9PSxdDbqeMKfrEzUuVhUCeuKUpJIKpLZiS5P3NPYw+45hYrEYOElf8M4mQJy98hUmDa6w3Nx7XzoyiZsyA6CeOL+5Yn0kHEaRrN8ShWkP2jugDNc3r80UTILSaxIo8QtI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN9PR11MB5276.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(38070700005)(4326008)(76116006)(66446008)(26005)(66476007)(64756008)(66556008)(66946007)(8676002)(508600001)(186003)(966005)(122000001)(9686003)(33656002)(71200400001)(38100700002)(86362001)(82960400001)(316002)(7696005)(54906003)(110136005)(52536014)(7416002)(6506007)(30864003)(83380400001)(2906002)(8936002)(55016003)(5660300002)(559001)(579004);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4wNbNof7cHeMyc2/Hn4QoRYMe/gThr2wG0eRipiwwUDyFguziPvZc439G3CA?=
 =?us-ascii?Q?8p4koyfr3cCv+XX5K4aihP+4Y17PEtDrTXRt/pYICCNZmxgFMbsW5PWbA4nW?=
 =?us-ascii?Q?iVfYu8XA1ACjCF5xjMKscd/vhNZxPai/zjZVvP8/0VnZOBeL3eqSbvuutWLg?=
 =?us-ascii?Q?zlBTwI5eZk3X0XxWHMaVzinhGOlBrxAyLUB3lZcoTjpgAN7aWHV32G03h4la?=
 =?us-ascii?Q?H3f/FIwE+kwzBJzZrFIkc9rBIgepxsJ2LzWik0F2GLQc5vEqfxYuLA8HlyZC?=
 =?us-ascii?Q?Ro8DdpetSxbHbxR863MewaingrYwWty7tJdbjaw27pPpPS7BtkokBMNTMcvI?=
 =?us-ascii?Q?Ahhnx6i9gkVq9SmUGxkeDuHsknbdQ3i+R6c6luwyX5GwPN3d3Y25Keu9JJDh?=
 =?us-ascii?Q?WNkP2MTVC1L/oFKYnc6uRdQUPWkNz/rfKpmFSfIYNZxT4aHoEXfw7jki/Xgn?=
 =?us-ascii?Q?OEW7JNSO/JdV3fkETHmefo4MbidtE8yZT/6nV7fZVKlUeCgtOxx65rvzuxvw?=
 =?us-ascii?Q?iTK1AUjb4FFbSd5leJP8Xlhs/BnFPSOyT7p7G17K8VdsSqX5/29Eq3W2TS11?=
 =?us-ascii?Q?xysyMZM8sk/epXmvV6M7MYLJKzWGZ8190VLQKBnZ986ZLaMerh6TMgRW565M?=
 =?us-ascii?Q?Bk4Q/0bVGZ/exG9L85sijiAJrLI68f2mYx/+e60sGmzrJtBKuibcoalL+4jN?=
 =?us-ascii?Q?OtXKX6jAzrhl7F6gm+cu7Vg0llFlLaUkYuVML5lFxMEPbeBzpJPrcMmKIlmx?=
 =?us-ascii?Q?HB/AUxeuYmwlvs0zO70ye5TGv3WkIncb6noYWxr1JPTIosyeGvCl6C30FanR?=
 =?us-ascii?Q?vc8hUg0XuNnyUnSow3L9hrP+LQ2UtPAmf9HaGLWDR67WNTc/nK66N/xMt92p?=
 =?us-ascii?Q?LFVmP3eOVGQNMjqfimu9JTWO08Iy6RvFaScOQeUyPWV2CsqqJjiwYHuaSjE5?=
 =?us-ascii?Q?E0cMUGjqP7skWLnsR9kfdR11qUAG6GlPlzn8lw7yqQzmmxX3Ly2LEHewKW4F?=
 =?us-ascii?Q?V/oil6/bHMdBAzO/0RZlOdn2wcYGNf4/Lfcha7ks/UNhXNkq93kAUXap7NAh?=
 =?us-ascii?Q?XQr/IltBKtkc/oL12K7chBYOkIJLcLExzE7FUP2d6y85Uv2EPrsbImjy4ziA?=
 =?us-ascii?Q?AjGSj1+Bo0Pk+OXTHKUoW+WfpouOvEvV0OaPzu2EmAwhzhyjnWmwL9b9elX5?=
 =?us-ascii?Q?GVpoF5uTZjxT/EkYQ74d/+OwHZLvb3AsuyKpfrxTA0ZYDLhTfTjdAhpwtPZt?=
 =?us-ascii?Q?mm2Qz3tf0Ljzqga0PMhO1IJRNu5Mb5MsU1imrwrDdIZyFeBTWiXi3VQZOvlh?=
 =?us-ascii?Q?kJeMibqQc1JXCcsVccp5eqZ/d6k6VO4Fbuu9A0Pr/Gnv7/fp4tM/KDpL+LnZ?=
 =?us-ascii?Q?ff4yU0uBVM+as1SF1+p6Ga6qOccI8sf62WU3LV6sF2FsXdMlLsQJoYbDGRFG?=
 =?us-ascii?Q?cJAWYmCavid2wbz+abcDah/65aBYClfTx3nx2q6ZUe0B4aIkHVh25eKruZoT?=
 =?us-ascii?Q?aR/ls6YcpdXJbHE6Mkm5DX76TmUcBeQJk4/OC9uIlVmcQ56stAaP/Ez5C25F?=
 =?us-ascii?Q?AO4TtYaPHcHpc2aIPmlD9wZSHegiHjj917Kkamk2Zj4V+YQQTEHZcg3SsLam?=
 =?us-ascii?Q?Uw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN9PR11MB5276.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14eff236-9990-4b61-b03d-08d9f5a661fd
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Feb 2022 01:55:20.5465
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CwGGx4xZRGoSAy9Y74ddVLJWnO0K80mUC2VyHwEvZ3ALNCUnjwKpHlG84UxC0WXJ67vkMytf4ciihV6UEjjn5w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1305
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Yishai Hadas <yishaih@nvidia.com>
> Sent: Sunday, February 20, 2022 5:57 PM
>=20
> From: Jason Gunthorpe <jgg@nvidia.com>
>=20
> Replace the existing region based migration protocol with an ioctl based
> protocol. The two protocols have the same general semantic behaviors, but
> the way the data is transported is changed.
>=20
> This is the STOP_COPY portion of the new protocol, it defines the 5 state=
s
> for basic stop and copy migration and the protocol to move the migration
> data in/out of the kernel.
>=20
> Compared to the clarification of the v1 protocol Alex proposed:
>=20
> https://lore.kernel.org/r/163909282574.728533.7460416142511440919.stgit
> @omen
>=20
> This has a few deliberate functional differences:
>=20
>  - ERROR arcs allow the device function to remain unchanged.
>=20
>  - The protocol is not required to return to the original state on
>    transition failure. Instead userspace can execute an unwind back to
>    the original state, reset, or do something else without needing kernel
>    support. This simplifies the kernel design and should userspace choose
>    a policy like always reset, avoids doing useless work in the kernel
>    on error handling paths.
>=20
>  - PRE_COPY is made optional, userspace must discover it before using it.
>    This reflects the fact that the majority of drivers we are aware of
>    right now will not implement PRE_COPY.
>=20
>  - segmentation is not part of the data stream protocol, the receiver
>    does not have to reproduce the framing boundaries.
>=20
> The hybrid FSM for the device_state is described as a Mealy machine by
> documenting each of the arcs the driver is required to implement. Definin=
g
> the remaining set of old/new device_state transitions as 'combination
> transitions' which are naturally defined as taking multiple FSM arcs alon=
g
> the shortest path within the FSM's digraph allows a complete matrix of
> transitions.
>=20
> A new VFIO_DEVICE_FEATURE of
> VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is
> defined to replace writing to the device_state field in the region. This
> allows returning a brand new FD whenever the requested transition opens
> a data transfer session.
>=20
> The VFIO core code implements the new feature and provides a helper
> function to the driver. Using the helper the driver only has to
> implement 6 of the FSM arcs and the other combination transitions are
> elaborated consistently from those arcs.
>=20
> A new VFIO_DEVICE_FEATURE of VFIO_DEVICE_FEATURE_MIGRATION is
> defined to
> report the capability for migration and indicate which set of states and
> arcs are supported by the device. The FSM provides a lot of flexibility t=
o
> make backwards compatible extensions but the VFIO_DEVICE_FEATURE also
> allows for future breaking extensions for scenarios that cannot support
> even the basic STOP_COPY requirements.
>=20
> The VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE with the GET option (i.e.
> VFIO_DEVICE_FEATURE_GET) can be used to read the current migration state
> of the VFIO device.
>=20
> Data transfer sessions are now carried over a file descriptor, instead of
> the region. The FD functions for the lifetime of the data transfer
> session. read() and write() transfer the data with normal Linux stream FD
> semantics. This design allows future expansion to support poll(),
> io_uring, and other performance optimizations.
>=20
> The complicated mmap mode for data transfer is discarded as current qemu
> doesn't take meaningful advantage of it, and the new qemu implementation
> avoids substantially all the performance penalty of using a read() on the
> region.
>=20
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> Tested-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Reviewed-by: Kevin Tian <kevin.tian@intel.com>

> ---
>  drivers/vfio/vfio.c       | 199 ++++++++++++++++++++++++++++++++++++++
>  include/linux/vfio.h      |  18 ++++
>  include/uapi/linux/vfio.h | 173 ++++++++++++++++++++++++++++++---
>  3 files changed, 377 insertions(+), 13 deletions(-)
>=20
> diff --git a/drivers/vfio/vfio.c b/drivers/vfio/vfio.c
> index 71763e2ac561..b37ab27b511f 100644
> --- a/drivers/vfio/vfio.c
> +++ b/drivers/vfio/vfio.c
> @@ -1557,6 +1557,197 @@ static int vfio_device_fops_release(struct inode
> *inode, struct file *filep)
>  	return 0;
>  }
>=20
> +/*
> + * vfio_mig_get_next_state - Compute the next step in the FSM
> + * @cur_fsm - The current state the device is in
> + * @new_fsm - The target state to reach
> + * @next_fsm - Pointer to the next step to get to new_fsm
> + *
> + * Return 0 upon success, otherwise -errno
> + * Upon success the next step in the state progression between cur_fsm a=
nd
> + * new_fsm will be set in next_fsm.
> + *
> + * This breaks down requests for combination transitions into smaller st=
eps
> and
> + * returns the next step to get to new_fsm. The function may need to be
> called
> + * multiple times before reaching new_fsm.
> + *
> + */
> +int vfio_mig_get_next_state(struct vfio_device *device,
> +			    enum vfio_device_mig_state cur_fsm,
> +			    enum vfio_device_mig_state new_fsm,
> +			    enum vfio_device_mig_state *next_fsm)
> +{
> +	enum { VFIO_DEVICE_NUM_STATES =3D
> VFIO_DEVICE_STATE_RESUMING + 1 };
> +	/*
> +	 * The coding in this table requires the driver to implement 6
> +	 * FSM arcs:
> +	 *         RESUMING -> STOP
> +	 *         RUNNING -> STOP
> +	 *         STOP -> RESUMING
> +	 *         STOP -> RUNNING
> +	 *         STOP -> STOP_COPY
> +	 *         STOP_COPY -> STOP
> +	 *
> +	 * The coding will step through multiple states for these combination
> +	 * transitions:
> +	 *         RESUMING -> STOP -> RUNNING
> +	 *         RESUMING -> STOP -> STOP_COPY
> +	 *         RUNNING -> STOP -> RESUMING
> +	 *         RUNNING -> STOP -> STOP_COPY
> +	 *         STOP_COPY -> STOP -> RESUMING
> +	 *         STOP_COPY -> STOP -> RUNNING
> +	 */
> +	static const u8
> vfio_from_fsm_table[VFIO_DEVICE_NUM_STATES][VFIO_DEVICE_NUM_STA
> TES] =3D {
> +		[VFIO_DEVICE_STATE_STOP] =3D {
> +			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP_COPY,
> +			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RUNNING] =3D {
> +			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_RUNNING,
> +			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_STOP_COPY] =3D {
> +			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP_COPY,
> +			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_RESUMING] =3D {
> +			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_STOP,
> +			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_RESUMING,
> +			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
> +		},
> +		[VFIO_DEVICE_STATE_ERROR] =3D {
> +			[VFIO_DEVICE_STATE_STOP] =3D
> VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RUNNING] =3D
> VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_STOP_COPY] =3D
> VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_RESUMING] =3D
> VFIO_DEVICE_STATE_ERROR,
> +			[VFIO_DEVICE_STATE_ERROR] =3D
> VFIO_DEVICE_STATE_ERROR,
> +		},
> +	};
> +
> +	if (WARN_ON(cur_fsm >=3D ARRAY_SIZE(vfio_from_fsm_table)))
> +		return -EINVAL;
> +
> +	if (new_fsm >=3D ARRAY_SIZE(vfio_from_fsm_table))
> +		return -EINVAL;
> +
> +	*next_fsm =3D vfio_from_fsm_table[cur_fsm][new_fsm];
> +	return (*next_fsm !=3D VFIO_DEVICE_STATE_ERROR) ? 0 : -EINVAL;
> +}
> +EXPORT_SYMBOL_GPL(vfio_mig_get_next_state);
> +
> +/*
> + * Convert the drivers's struct file into a FD number and return it to
> userspace
> + */
> +static int vfio_ioct_mig_return_fd(struct file *filp, void __user *arg,
> +				   struct vfio_device_feature_mig_state *mig)
> +{
> +	int ret;
> +	int fd;
> +
> +	fd =3D get_unused_fd_flags(O_CLOEXEC);
> +	if (fd < 0) {
> +		ret =3D fd;
> +		goto out_fput;
> +	}
> +
> +	mig->data_fd =3D fd;
> +	if (copy_to_user(arg, mig, sizeof(*mig))) {
> +		ret =3D -EFAULT;
> +		goto out_put_unused;
> +	}
> +	fd_install(fd, filp);
> +	return 0;
> +
> +out_put_unused:
> +	put_unused_fd(fd);
> +out_fput:
> +	fput(filp);
> +	return ret;
> +}
> +
> +static int
> +vfio_ioctl_device_feature_mig_device_state(struct vfio_device *device,
> +					   u32 flags, void __user *arg,
> +					   size_t argsz)
> +{
> +	size_t minsz =3D
> +		offsetofend(struct vfio_device_feature_mig_state, data_fd);
> +	struct vfio_device_feature_mig_state mig;
> +	struct file *filp =3D NULL;
> +	int ret;
> +
> +	if (!device->ops->migration_set_state ||
> +	    !device->ops->migration_get_state)
> +		return -ENOTTY;
> +
> +	ret =3D vfio_check_feature(flags, argsz,
> +				 VFIO_DEVICE_FEATURE_SET |
> +				 VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(mig));
> +	if (ret !=3D 1)
> +		return ret;
> +
> +	if (copy_from_user(&mig, arg, minsz))
> +		return -EFAULT;
> +
> +	if (flags & VFIO_DEVICE_FEATURE_GET) {
> +		enum vfio_device_mig_state curr_state;
> +
> +		ret =3D device->ops->migration_get_state(device, &curr_state);
> +		if (ret)
> +			return ret;
> +		mig.device_state =3D curr_state;
> +		goto out_copy;
> +	}
> +
> +	/* Handle the VFIO_DEVICE_FEATURE_SET */
> +	filp =3D device->ops->migration_set_state(device, mig.device_state);
> +	if (IS_ERR(filp) || !filp)
> +		goto out_copy;
> +
> +	return vfio_ioct_mig_return_fd(filp, arg, &mig);
> +out_copy:
> +	mig.data_fd =3D -1;
> +	if (copy_to_user(arg, &mig, sizeof(mig)))
> +		return -EFAULT;
> +	if (IS_ERR(filp))
> +		return PTR_ERR(filp);
> +	return 0;
> +}
> +
> +static int vfio_ioctl_device_feature_migration(struct vfio_device *devic=
e,
> +					       u32 flags, void __user *arg,
> +					       size_t argsz)
> +{
> +	struct vfio_device_feature_migration mig =3D {
> +		.flags =3D VFIO_MIGRATION_STOP_COPY,
> +	};
> +	int ret;
> +
> +	if (!device->ops->migration_set_state ||
> +	    !device->ops->migration_get_state)
> +		return -ENOTTY;
> +
> +	ret =3D vfio_check_feature(flags, argsz, VFIO_DEVICE_FEATURE_GET,
> +				 sizeof(mig));
> +	if (ret !=3D 1)
> +		return ret;
> +	if (copy_to_user(arg, &mig, sizeof(mig)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
>  static int vfio_ioctl_device_feature(struct vfio_device *device,
>  				     struct vfio_device_feature __user *arg)
>  {
> @@ -1582,6 +1773,14 @@ static int vfio_ioctl_device_feature(struct
> vfio_device *device,
>  		return -EINVAL;
>=20
>  	switch (feature.flags & VFIO_DEVICE_FEATURE_MASK) {
> +	case VFIO_DEVICE_FEATURE_MIGRATION:
> +		return vfio_ioctl_device_feature_migration(
> +			device, feature.flags, arg->data,
> +			feature.argsz - minsz);
> +	case VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE:
> +		return vfio_ioctl_device_feature_mig_device_state(
> +			device, feature.flags, arg->data,
> +			feature.argsz - minsz);
>  	default:
>  		if (unlikely(!device->ops->device_feature))
>  			return -EINVAL;
> diff --git a/include/linux/vfio.h b/include/linux/vfio.h
> index ca69516f869d..3bbadcdbc9c8 100644
> --- a/include/linux/vfio.h
> +++ b/include/linux/vfio.h
> @@ -56,6 +56,14 @@ struct vfio_device {
>   *         match, -errno for abort (ex. match with insufficient or incor=
rect
>   *         additional args)
>   * @device_feature: Fill in the VFIO_DEVICE_FEATURE ioctl
> + * @migration_set_state: Optional callback to change the migration state=
 for
> + *         devices that support migration. The returned FD is used for d=
ata
> + *         transfer according to the FSM definition. The driver is respo=
nsible
> + *         to ensure that FD reaches end of stream or error whenever the
> + *         migration FSM leaves a data transfer state or before close_de=
vice()
> + *         returns.
> + * @migration_get_state: Optional callback to get the migration state fo=
r
> + *         devices that support migration.
>   */
>  struct vfio_device_ops {
>  	char	*name;
> @@ -72,6 +80,11 @@ struct vfio_device_ops {
>  	int	(*match)(struct vfio_device *vdev, char *buf);
>  	int	(*device_feature)(struct vfio_device *device, u32 flags,
>  				  void __user *arg, size_t argsz);
> +	struct file *(*migration_set_state)(
> +		struct vfio_device *device,
> +		enum vfio_device_mig_state new_state);
> +	int (*migration_get_state)(struct vfio_device *device,
> +				   enum vfio_device_mig_state *curr_state);
>  };
>=20
>  /**
> @@ -114,6 +127,11 @@ extern void vfio_device_put(struct vfio_device
> *device);
>=20
>  int vfio_assign_device_set(struct vfio_device *device, void *set_id);
>=20
> +int vfio_mig_get_next_state(struct vfio_device *device,
> +			    enum vfio_device_mig_state cur_fsm,
> +			    enum vfio_device_mig_state new_fsm,
> +			    enum vfio_device_mig_state *next_fsm);
> +
>  /*
>   * External user API
>   */
> diff --git a/include/uapi/linux/vfio.h b/include/uapi/linux/vfio.h
> index ef33ea002b0b..02b836ea8f46 100644
> --- a/include/uapi/linux/vfio.h
> +++ b/include/uapi/linux/vfio.h
> @@ -605,25 +605,25 @@ struct vfio_region_gfx_edid {
>=20
>  struct vfio_device_migration_info {
>  	__u32 device_state;         /* VFIO device state */
> -#define VFIO_DEVICE_STATE_STOP      (0)
> -#define VFIO_DEVICE_STATE_RUNNING   (1 << 0)
> -#define VFIO_DEVICE_STATE_SAVING    (1 << 1)
> -#define VFIO_DEVICE_STATE_RESUMING  (1 << 2)
> -#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_RUNNING | \
> -				     VFIO_DEVICE_STATE_SAVING |  \
> -				     VFIO_DEVICE_STATE_RESUMING)
> +#define VFIO_DEVICE_STATE_V1_STOP      (0)
> +#define VFIO_DEVICE_STATE_V1_RUNNING   (1 << 0)
> +#define VFIO_DEVICE_STATE_V1_SAVING    (1 << 1)
> +#define VFIO_DEVICE_STATE_V1_RESUMING  (1 << 2)
> +#define VFIO_DEVICE_STATE_MASK      (VFIO_DEVICE_STATE_V1_RUNNING
> | \
> +				     VFIO_DEVICE_STATE_V1_SAVING |  \
> +				     VFIO_DEVICE_STATE_V1_RESUMING)
>=20
>  #define VFIO_DEVICE_STATE_VALID(state) \
> -	(state & VFIO_DEVICE_STATE_RESUMING ? \
> -	(state & VFIO_DEVICE_STATE_MASK) =3D=3D
> VFIO_DEVICE_STATE_RESUMING : 1)
> +	(state & VFIO_DEVICE_STATE_V1_RESUMING ? \
> +	(state & VFIO_DEVICE_STATE_MASK) =3D=3D
> VFIO_DEVICE_STATE_V1_RESUMING : 1)
>=20
>  #define VFIO_DEVICE_STATE_IS_ERROR(state) \
> -	((state & VFIO_DEVICE_STATE_MASK) =3D=3D
> (VFIO_DEVICE_STATE_SAVING | \
> -					      VFIO_DEVICE_STATE_RESUMING))
> +	((state & VFIO_DEVICE_STATE_MASK) =3D=3D
> (VFIO_DEVICE_STATE_V1_SAVING | \
> +
> VFIO_DEVICE_STATE_V1_RESUMING))
>=20
>  #define VFIO_DEVICE_STATE_SET_ERROR(state) \
> -	((state & ~VFIO_DEVICE_STATE_MASK) |
> VFIO_DEVICE_SATE_SAVING | \
> -					     VFIO_DEVICE_STATE_RESUMING)
> +	((state & ~VFIO_DEVICE_STATE_MASK) |
> VFIO_DEVICE_STATE_V1_SAVING | \
> +
> VFIO_DEVICE_STATE_V1_RESUMING)
>=20
>  	__u32 reserved;
>  	__u64 pending_bytes;
> @@ -1002,6 +1002,153 @@ struct vfio_device_feature {
>   */
>  #define VFIO_DEVICE_FEATURE_PCI_VF_TOKEN	(0)
>=20
> +/*
> + * Indicates the device can support the migration API through
> + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE. If present flags must be
> non-zero and
> + * VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE is supported. The RUNNING
> and
> + * ERROR states are always supported if this GET succeeds.
> + *
> + * VFIO_MIGRATION_STOP_COPY means that STOP, STOP_COPY and
> + * RESUMING are supported.
> + */
> +struct vfio_device_feature_migration {
> +	__aligned_u64 flags;
> +#define VFIO_MIGRATION_STOP_COPY	(1 << 0)
> +};
> +#define VFIO_DEVICE_FEATURE_MIGRATION 1
> +
> +/*
> + * Upon VFIO_DEVICE_FEATURE_SET, execute a migration state change on
> the VFIO
> + * device. The new state is supplied in device_state, see enum
> + * vfio_device_mig_state for details
> + *
> + * The kernel migration driver must fully transition the device to the n=
ew
> state
> + * value before the operation returns to the user.
> + *
> + * The kernel migration driver must not generate asynchronous device sta=
te
> + * transitions outside of manipulation by the user or the
> VFIO_DEVICE_RESET
> + * ioctl as described above.
> + *
> + * If this function fails then current device_state may be the original
> + * operating state or some other state along the combination transition =
path.
> + * The user can then decide if it should execute a VFIO_DEVICE_RESET,
> attempt
> + * to return to the original state, or attempt to return to some other s=
tate
> + * such as RUNNING or STOP.
> + *
> + * If the new_state starts a new data transfer session then the FD assoc=
iated
> + * with that session is returned in data_fd. The user is responsible to =
close
> + * this FD when it is finished. The user must consider the migration dat=
a
> + * segments carried over the FD to be opaque and non-fungible. During
> RESUMING,
> + * the data segments must be written in the same order they came out of
> the
> + * saving side FD.
> + *
> + * Upon VFIO_DEVICE_FEATURE_GET, get the current migration state of the
> VFIO
> + * device, data_fd will be -1.
> + */
> +struct vfio_device_feature_mig_state {
> +	__u32 device_state; /* From enum vfio_device_mig_state */
> +	__s32 data_fd;
> +};
> +#define VFIO_DEVICE_FEATURE_MIG_DEVICE_STATE 2
> +
> +/*
> + * The device migration Finite State Machine is described by the enum
> + * vfio_device_mig_state. Some of the FSM arcs will create a migration d=
ata
> + * transfer session by returning a FD, in this case the migration data w=
ill
> + * flow over the FD using read() and write() as discussed below.
> + *
> + * There are 5 states to support VFIO_MIGRATION_STOP_COPY:
> + *  RUNNING - The device is running normally
> + *  STOP - The device does not change the internal or external state
> + *  STOP_COPY - The device internal state can be read out
> + *  RESUMING - The device is stopped and is loading a new internal state
> + *  ERROR - The device has failed and must be reset
> + *
> + * The FSM takes actions on the arcs between FSM states. The driver
> implements
> + * the following behavior for the FSM arcs:
> + *
> + * RUNNING -> STOP
> + * STOP_COPY -> STOP
> + *   While in STOP the device must stop the operation of the device. The
> device
> + *   must not generate interrupts, DMA, or any other change to external
> state.
> + *   It must not change its internal state. When stopped the device and
> kernel
> + *   migration driver must accept and respond to interaction to support
> external
> + *   subsystems in the STOP state, for example PCI MSI-X and PCI config
> space.
> + *   Failure by the user to restrict device access while in STOP must no=
t result
> + *   in error conditions outside the user context (ex. host system fault=
s).
> + *
> + *   The STOP_COPY arc will terminate a data transfer session.
> + *
> + * RESUMING -> STOP
> + *   Leaving RESUMING terminates a data transfer session and indicates t=
he
> + *   device should complete processing of the data delivered by write().=
 The
> + *   kernel migration driver should complete the incorporation of data
> written
> + *   to the data transfer FD into the device internal state and perform
> + *   final validity and consistency checking of the new device state. If=
 the
> + *   user provided data is found to be incomplete, inconsistent, or othe=
rwise
> + *   invalid, the migration driver must fail the SET_STATE ioctl and
> + *   optionally go to the ERROR state as described below.
> + *
> + *   While in STOP the device has the same behavior as other STOP states
> + *   described above.
> + *
> + *   To abort a RESUMING session the device must be reset.
> + *
> + * STOP -> RUNNING
> + *   While in RUNNING the device is fully operational, the device may
> generate
> + *   interrupts, DMA, respond to MMIO, all vfio device regions are funct=
ional,
> + *   and the device may advance its internal state.
> + *
> + * STOP -> STOP_COPY
> + *   This arc begin the process of saving the device state and will retu=
rn a
> + *   new data_fd.
> + *
> + *   While in the STOP_COPY state the device has the same behavior as ST=
OP
> + *   with the addition that the data transfers session continues to stre=
am the
> + *   migration state. End of stream on the FD indicates the entire devic=
e
> + *   state has been transferred.
> + *
> + *   The user should take steps to restrict access to vfio device region=
s while
> + *   the device is in STOP_COPY or risk corruption of the device migrati=
on
> data
> + *   stream.
> + *
> + * STOP -> RESUMING
> + *   Entering the RESUMING state starts a process of restoring the devic=
e
> state
> + *   and will return a new data_fd. The data stream fed into the data_fd
> should
> + *   be taken from the data transfer output of a single FD during saving=
 from
> + *   a compatible device. The migration driver may alter/reset the inter=
nal
> + *   device state for this arc if required to prepare the device to rece=
ive the
> + *   migration data.
> + *
> + * any -> ERROR
> + *   ERROR cannot be specified as a device state, however any transition
> request
> + *   can be failed with an errno return and may then move the device_sta=
te
> into
> + *   ERROR. In this case the device was unable to execute the requested =
arc
> and
> + *   was also unable to restore the device to any valid device_state.
> + *   To recover from ERROR VFIO_DEVICE_RESET must be used to return the
> + *   device_state back to RUNNING.
> + *
> + * The remaining possible transitions are interpreted as combinations of=
 the
> + * above FSM arcs. As there are multiple paths through the FSM arcs the
> path
> + * should be selected based on the following rules:
> + *   - Select the shortest path.
> + * Refer to vfio_mig_get_next_state() for the result of the algorithm.
> + *
> + * The automatic transit through the FSM arcs that make up the
> combination
> + * transition is invisible to the user. When working with combination ar=
cs
> the
> + * user may see any step along the path in the device_state if SET_STATE
> + * fails. When handling these types of errors users should anticipate fu=
ture
> + * revisions of this protocol using new states and those states becoming
> + * visible in this case.
> + */
> +enum vfio_device_mig_state {
> +	VFIO_DEVICE_STATE_ERROR =3D 0,
> +	VFIO_DEVICE_STATE_STOP =3D 1,
> +	VFIO_DEVICE_STATE_RUNNING =3D 2,
> +	VFIO_DEVICE_STATE_STOP_COPY =3D 3,
> +	VFIO_DEVICE_STATE_RESUMING =3D 4,
> +};
> +
>  /* -------- API for Type1 VFIO IOMMU -------- */
>=20
>  /**
> --
> 2.18.1

