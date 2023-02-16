Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB2FE6989D8
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 02:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbjBPBcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Feb 2023 20:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbjBPBcu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Feb 2023 20:32:50 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A1F5420E
        for <netdev@vger.kernel.org>; Wed, 15 Feb 2023 17:32:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676511169; x=1708047169;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=TBiHeM/xFCz1o97w64Jw4ui1jTdOwKnbZCZ0jfaNK7s=;
  b=AEwx2Ov57tlTwrJzRqNbGhDl5h9q0r7VAx/DBuEYaJuBnqGqajLctAHw
   IH/Vqx5JUO1/kTdHBiTgqF4TV5+LrlGVOKbOkTDNRPH0B7/D0U5iAghaN
   dkW3zk9aDVLsdLf8gdxLSZkl8eoguN+cCDtP063BHu2B3xWPDd0AQXLVS
   wVNd6TirzbsY0U05cwPtUSKo4lOpCxEpcCe+3t0iztrkl1DueRAsJeqcG
   aOtkI6cax8Mmpd0tY3ePFXICpgMdSudAaXk8hFl1aK+2X+pf3RNOGcIim
   mLq5SsKv4r83o++HhsBGYW8FadaaEgMHPQuSy9ieIR+my3e0+vStEAUDr
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="330235513"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="330235513"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2023 17:32:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10622"; a="700321503"
X-IronPort-AV: E=Sophos;i="5.97,301,1669104000"; 
   d="scan'208";a="700321503"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by orsmga008.jf.intel.com with ESMTP; 15 Feb 2023 17:32:48 -0800
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 17:32:48 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Wed, 15 Feb 2023 17:32:48 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Wed, 15 Feb 2023 17:32:48 -0800
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (104.47.55.109)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Wed, 15 Feb 2023 17:32:47 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nY6/WzNoNCezgQpqTwin6VPh2Rq+/RIlgKlQZkA8SMHfmKBrjvQ19ZAigIpHlzdFlJjW1GUUKlSQ6iaF/Rx5F4tbAqC5fZy6/uGAa+fSxI20z5NjBSqVEiqpZK8MK6Gw36omob5RXBLOPsd0woRRk0SzjesFb0K1CpHbKxnf0591K5E1oQiYR4nphJwCBxiBSzYd+pzxNNXNFFJx3getYy+23D42tHNlJfzMHKK2MStFGc9AVGk9mdWUv6fXmX6ejiCjBhdvATlUQ2OYGuIG5T2bsi0mclRjN3vsgHdM2rPpQlOpAl+YEC1VqJ5yVjZsKPPr+Iuk0jsmINT0CWvowg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/Ui+058I1mRucGCBV3NAxS9/8FEF671z8HAKPMbD4Rk=;
 b=LK54oymLRZkefhBZMK3YYgHieMqB2/KcHMUdyMjXGUTaKW015Z+yhxqBWT+gzI0Joj0YxQDgzvInxZhNPsb0nM6Ua96ukXlpmxzy6bj/QrnFmHLbQb0JhNu4bhbvXG2cT6b7QE8KptKlQUSvLOgrqx/5g8WS3Ka/mpiaKoCcRj+3o/GrMsV5M33JoE9CQFFVBq2Z+rdERaRDQtijMFfWjJBYm1CGgMzL0CnQHXq7FU+HMqSVemvWOmmI2St/rrEAtq76+jGbLujRZuFar6Vgeqebdb10g2Ghnyjeb2FBABTiqYZd9gDSyWGLgtt/If9QISjYTjMuNZq6KY0wy/0RZA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6764.namprd11.prod.outlook.com (2603:10b6:303:209::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Thu, 16 Feb
 2023 01:32:41 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::5697:a11e:691e:6acf%6]) with mapi id 15.20.6086.024; Thu, 16 Feb 2023
 01:32:41 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Ido Schimmel <idosch@nvidia.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "jiri@nvidia.com" <jiri@nvidia.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "mlxsw@nvidia.com" <mlxsw@nvidia.com>
Subject: RE: [PATCH net] devlink: Fix netdev notifier chain corruption
Thread-Topic: [PATCH net] devlink: Fix netdev notifier chain corruption
Thread-Index: AQHZQQ+04oo712qhuEeyePJWV4sCZa7Qyt2g
Date:   Thu, 16 Feb 2023 01:32:41 +0000
Message-ID: <CO1PR11MB5089AA5163E9748300AA0E97D6A09@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20230215073139.1360108-1-idosch@nvidia.com>
In-Reply-To: <20230215073139.1360108-1-idosch@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MW4PR11MB6764:EE_
x-ms-office365-filtering-correlation-id: c140bada-2205-4768-b5ba-08db0fbdb206
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: WPUe0kIvp8k42MISMCa8iNmaHjtwc6DJqEb2pQZcc5DRB84kcPmH0fZ9SOPUEjUV9hC8Zb71/4isDHXhB3jKlZY1uCtzvjG4AH9wpd1R+hmTECsP/uHmKSkNqiOKLys2XgReyg2bXGKH5yXme2PhI9RBbTVb+A4rFF4cmZj+Bmc9nquUZRPVtrGCRZUVj/SsNHfyXlYRhJiN6RW3rGzbEoRQcPIrER1dnXhkQuJFsejLOfPsez0VEiKVRygnvCErk0LdRfM/NASKvFW8vylmj45hOqVZA2DiNbYCRIHdXYV0bwPZjAV67WqqcMIOvubdKzPUuG/jgGxl5N6hnw3eGdGf9vUQ+NXuIFSVjndGoPTbbyA/c4d1m5wMr5f3wr6rNHZF7qbeOAiMh5M5iPGmomJdhsvf/xPR1CkIyzkkaVXBsMYFj8ATxCU5yWWgAbgLKjhefzy/Syw5CQYFgFT9AIVRpZpfq8aV+rLh60KygUkzvOI8nCLkim3IJg5xDQxI0KcCM+chf3QoM27M1mpYnXqHHIvAJLRfwS1GuEhGS0t2o2Mam2woH3aOwhCfKAnwxz8BsqLsenKsyn5ljA08i2zdL9L4VI7oVfZBz8RAVvxJMgq1gz9IKcNkN8Mftj4o86/Bw0XylLLAKcjeJiacBa/SEKtjlhr/vF9UKx6LHSF5swiEz1ucoFKXeOA715XBJom0lSU/bWphbZ7vXseMkw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(346002)(39860400002)(136003)(376002)(366004)(396003)(451199018)(54906003)(110136005)(33656002)(55016003)(83380400001)(478600001)(71200400001)(6506007)(7696005)(53546011)(186003)(26005)(9686003)(41300700001)(38100700002)(82960400001)(5660300002)(86362001)(52536014)(38070700005)(8936002)(316002)(66476007)(64756008)(66556008)(66946007)(2906002)(66446008)(8676002)(4326008)(76116006)(122000001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?tk83LHhtgK0ljum0eZoVaaX0z3VqmeEoSOZW3YEffoLVF7UekbUVrmIKgImT?=
 =?us-ascii?Q?euKrVl55CC670aeNzdMVb4pHd6D0vtEuHL1MEMUD2UYY9iUP3Bhh4phAs5gH?=
 =?us-ascii?Q?ebzoNRq20j2hFY9ppjutCn2mupF9ke63xdHW0MRht9Q90Bydm79heu5zeFV9?=
 =?us-ascii?Q?bSR0sQKnDxdL+yryYFwIHdyIjgR5wXMZvR1XY40hHolClUZOeg2cDh2UDehE?=
 =?us-ascii?Q?3oVsrHzSKF3eDpxIyVik00fXTu8e51el8ZgktUHR3jLICxtHV8/GjjvQ0RnB?=
 =?us-ascii?Q?r11U5VD94Ro9YVgB2Dgmf0AH5WP9Jmu/S26TOq0T0EWlp1D54dNLll+wlU0c?=
 =?us-ascii?Q?0PYSxTJ5+EJbh4IVuDGScoFZf9QhLIY454u7b6mwOHPzCVJGc0+7sD1MP5AI?=
 =?us-ascii?Q?9IV8VLXT4XJy84MBqdJAnhUdtMu6qDCgvOPmGACegQtCFguhsHlTtnHzLDKk?=
 =?us-ascii?Q?5XtV1Q60EDhMwHWrno/zth4icCd9bfAE61aJI9R21o+HNl/rZ5+zl8iEIwwt?=
 =?us-ascii?Q?zIgHmbCsk1R1EMJFYJ/Hy/fTv5fWTq+YRgTwkWa1iTZh53Obt166bDpH2hWB?=
 =?us-ascii?Q?8vbcwY2JX0pk5amECbCbeMrPreXrG/ZXgEm+Y6LN/f8BYC27AgFAPTaJapvA?=
 =?us-ascii?Q?X0YdqngS3swfD6p3WMVLvhZlyteUElAqR6fBWj8FW9XIfPvJCgjx/rrcY34e?=
 =?us-ascii?Q?ZyaW3rsIasIrPPSo4KdS0/41GUxLG94jE1PV0mMujy2nRmHIPdXXV8e17T24?=
 =?us-ascii?Q?hvCb51tZVO+HKbDjXlGtEUb8s+15sRILj66Egd1l2cNsbdhn+jOh7NKowMlF?=
 =?us-ascii?Q?XDm7eLVCTPq17k9KpxH9qKYHXkAEMQ0rVXp28g81w7TCdo6zQedmNyn0osLL?=
 =?us-ascii?Q?gpwucPAOledqiZgqA8Wf0P3gwSltFdPLANq1GpxJ6/b7LsklKFsitfvkj6oc?=
 =?us-ascii?Q?lxRM2Woaf7ZfZBN4GrIwntMvCqlos4s173UrFLpSKPdFH5i70p3LwLddG1nB?=
 =?us-ascii?Q?a4EQ7Xur9yZpbyUsATaisDFzFRt2KsM6cKG38qShLYQrLjf1VDwZrmPbA0m5?=
 =?us-ascii?Q?urLyaY1PO7XgVxQIkf0PgaFYrdb3RUHDi8zHV37oyZpZn6YrZEJQp4VmTY8o?=
 =?us-ascii?Q?2iRvibXZd/bzKyqJmNjDgW9UShpQa0nazghcFYBxasVlM6KBJzloUa8BQNBu?=
 =?us-ascii?Q?zc0tKW2OolDH9FPskxo8kK8kPp+s/nJc1W1dMnbTovjeylUs5s5hYaKA30aC?=
 =?us-ascii?Q?DeHWBQ+99p1Hv986ynPbwauywJPiytVxwdT/AX/Se9UO8Yb1V9WnvaW6h1Tt?=
 =?us-ascii?Q?D4X5aHx4ba399uY3eECwtf/FIIqMYRAFOKpyLdiPd2ZLwCgjdtve3JunMvjf?=
 =?us-ascii?Q?Hn4FuEsqgtAevUDO0hOtoDiTyaHwr5Vf8Vuret0trC5gUCssvvJmwGZNN2tr?=
 =?us-ascii?Q?KJbpE+JCfGeOsOcKM6iHv33vucXQFlAZqo9LUCrRcpQK2XwNnqUhCzrg7Wb7?=
 =?us-ascii?Q?bD0nzKdpSV1ABkTEfNHRQoS+ZnAEmijLZk1CyvoKM0iR92xkWRcsEtJy3iG1?=
 =?us-ascii?Q?OSMf3W/yDlMisT1A8ApyV1iNGZZyHIMYvn0BI/xeQtq6rI+P7bOi4g7UvWs6?=
 =?us-ascii?Q?YA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c140bada-2205-4768-b5ba-08db0fbdb206
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Feb 2023 01:32:41.2451
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: leFZ5thILU5hY2cOuFAbf/7sdWF9wop9q6B9hJrXFBhFYc0t65t2iBP7UNaj4dZe07AkmtyePpdbGSgfo50Uby/5SFQ/t0GRQyqWdrQUbJE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6764
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
> From: Ido Schimmel <idosch@nvidia.com>
> Sent: Tuesday, February 14, 2023 11:32 PM
> To: netdev@vger.kernel.org
> Cc: davem@davemloft.net; kuba@kernel.org; pabeni@redhat.com;
> edumazet@google.com; jiri@nvidia.com; Keller, Jacob E
> <jacob.e.keller@intel.com>; sfr@canb.auug.org.au; mlxsw@nvidia.com; Ido
> Schimmel <idosch@nvidia.com>
> Subject: [PATCH net] devlink: Fix netdev notifier chain corruption
>=20
> Cited commit changed devlink to register its netdev notifier block on
> the global netdev notifier chain instead of on the per network namespace
> one.
>=20
> However, when changing the network namespace of the devlink instance,
> devlink still tries to unregister its notifier block from the chain of
> the old namespace and register it on the chain of the new namespace.
> This results in corruption of the notifier chains, as the same notifier
> block is registered on two different chains: The global one and the per
> network namespace one. In turn, this causes other problems such as the
> inability to dismantle namespaces due to netdev reference count issues.
>=20
> Fix by preventing devlink from moving its notifier block between
> namespaces.
>=20
> Reproducer:
>=20
>  # echo "10 1" > /sys/bus/netdevsim/new_device
>  # ip netns add test123
>  # devlink dev reload netdevsim/netdevsim10 netns test123
>  # ip netns del test123
>  [   71.935619] unregister_netdevice: waiting for lo to become free. Usag=
e count =3D
> 2
>  [   71.938348] leaked reference.
>=20
> Fixes: 565b4824c39f ("devlink: change port event netdev notifier from per=
-net to
> global")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> Reviewed-by: Jiri Pirko <jiri@nvidia.com>

Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
