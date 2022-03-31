Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 271AE4EE23D
	for <lists+netdev@lfdr.de>; Thu, 31 Mar 2022 22:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241021AbiCaUEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Mar 2022 16:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbiCaUEh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Mar 2022 16:04:37 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71B9B2325C5;
        Thu, 31 Mar 2022 13:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648756969; x=1680292969;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=sPTfvoVI9/PG9xeReVB4sUoVC9MtTUGspbLQHdq2/Qg=;
  b=G6HwE6sggX+s2iuQ130wb8YhHpEaloUC06Oykjmce0rOjNLGG/cKjn+7
   aJ0V+B+ruQjhTkb+bvIKnrc7Ob3IAlD4ylHv6SCa7LK4Z9rEZdQskgxzo
   EaggktDCTbOHmysgS+Br+dCN2nUrE7ATvXi5L9KO2U/KBTaXsx1LbqTGv
   MhxZPN6ZM5CceZJdLb6duaBVbaP+Mu3G4cpry6AXjrulDHCTZkuH0Ybpd
   6QICNuI0INpDL1O500Y+16Foybcq8tgT6b2Ym1oEHIItV3ezrrQI4LuyB
   3tgTDjsGDl3r9CSs7kygAa/LozbZT9fLZE56wkNFQmPA1TAA0nd2mprTE
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10302"; a="260128245"
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="260128245"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2022 13:02:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,225,1643702400"; 
   d="scan'208";a="655043343"
Received: from orsmsx606.amr.corp.intel.com ([10.22.229.19])
  by orsmga004.jf.intel.com with ESMTP; 31 Mar 2022 13:02:48 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX606.amr.corp.intel.com (10.22.229.19) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 13:02:48 -0700
Received: from orsmsx612.amr.corp.intel.com (10.22.229.25) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 31 Mar 2022 13:02:48 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx612.amr.corp.intel.com (10.22.229.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 31 Mar 2022 13:02:48 -0700
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.173)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 31 Mar 2022 13:02:48 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RrUBZGxLILv7rusdtMBfbBmwAjn/v/sI0dB3Gr5PFd2tLRDl/Vd3gP5W/M2FjiulXHZtkjNd6PUZy8CdBaU+vv1xCXivhDSZgIe3a2300NEoN50h61fXo0vCy4HtF2FmdmDcKPpvemQmzU8PNnDER0RQG9PL5V2EepZx8qxBsjRDtbXZAr/j4KFnW1rPj+MwW850p99mYL1tq9VpPYGsHBM2hu+ArmCGOMkTPdnTUkWo/AMpWNwqPazs7rwO3O43P81w55g5tQi2z77lczbwIzekY1pDwzAtgtdJQE2aD8c9fY/yHzr1gBzXKBa0I02+OgMFMTGj5omlonmjT32+Yw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=jmdGrnMcDTjkzG1siJb/7T5A5+GhDVW1RL6YlmYc2FM=;
 b=aV33hIj6zdTHGmksxpama9jtMgWvSIEPN5Yp6PG5HKR498lHmopWSssS6DTSGHIZvrLI+MCrylVj9u62H60Kwml5ty+2RgLvR+ctIMvAjNhD8i6pAzVH3s8oRI5FfmUI5C7EezOmdf0G9jx82dGo8PqJCIqEkDT2XTJDhRl+HRlwFCa9RGAqANYGRnBhUzaGFkxtAstepl0BgUrIv+634IZYM2yNLhy3FYPF3InmbtChZ4mOiayzSOsL3HvQO2SP5vL2VQFhk8q2IXKKqNR3tgGYX9ojCHuSqe1JKovGUnAYcyrsEjPiyq+4DgMFR0bsuTs5xM1Go/wps9QuW9r9mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MWHPR11MB1840.namprd11.prod.outlook.com (2603:10b6:300:112::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.23; Thu, 31 Mar
 2022 20:02:43 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::8441:e1ac:f3ae:12b8%8]) with mapi id 15.20.5102.025; Thu, 31 Mar 2022
 20:02:43 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>, mschmidt <mschmidt@redhat.com>,
        Brett Creeley <brett.creeley@intel.com>,
        open list <linux-kernel@vger.kernel.org>,
        poros <poros@redhat.com>, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
 ice_vc_process_vf_msg()
Thread-Topic: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
 ice_vc_process_vf_msg()
Thread-Index: AQHYRO057BJtvqZxeEyUMOJlKAIrPqzZeKaAgAArCwCAAEY+YA==
Date:   Thu, 31 Mar 2022 20:02:43 +0000
Message-ID: <CO1PR11MB50891AEAC5604FD63BEB5C76D6E19@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20220331105005.2580771-1-ivecera@redhat.com>
        <YkWpNVXYEBo/u3dm@boxer> <20220331174832.68e17c4a@ceranb>
In-Reply-To: <20220331174832.68e17c4a@ceranb>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3622b626-6dbc-46a4-76db-08da13516b40
x-ms-traffictypediagnostic: MWHPR11MB1840:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <MWHPR11MB1840C734A83294AC079F8928D6E19@MWHPR11MB1840.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: twehps7guh7yxvJGijghiQ3eJSMyZ+kv8ju2q0wBXkoiQ1h/oZ3do/u4piLr4TLN5L9sDlPKeVHopWYHbC38m6cudsYMyOnrMPOB25E+cwXZ7+5poV81SbUUcPagHY5QDMsKIkLVoaC7gUasdW0+2AQVHC1L9ZvbkNRV6wI5pq7xUosZ8wU08nH+npsLZ49VmO1tWtQJX7BMRwX/G+S5C1M+sh+/Rze0EKhsGV3jTP0VUiXbL03a3wvBARPwJsf3nazzXjeBIMa128yXVOP4wbbQruIFWzEe1WH9v/jkp4NdxRioXOJ722ediMA8NPehFCc4aQG7XRXRD2P30yoDh87IWL7lO08Ab+G6UZwDnIyMNgX7R/zvRYDJboq6D4ab1HYQWZqcGT6s+E+RBvMD34/HBVyFriGANf2eMrvOK9yAVuwLm38VLhzucIHDvil0leyvftOyNXYG6EfqdPeYEkg2JtjMBiFYnkPQ0ExuAnhbXuM4VI32PjldxMN0BwwR2iOIik2wF1NeT2NJYzU7N8Rp2gw2+aHrKL6tzDyOBpmphkgeJKddA8HIhPR1jUWm0Q4k4rejxMWDOx5f2urksPS2ZcGk+QFJMNKNIpks76/U9p2UPKkiOm7Ow9qj6JPDBCXHLSjUfuJE7uHnl5tgh2LbJA0ldVWMUUwl+o3Jtbbz4nO2exkt008v+67dun4nKSqu775IcIZUbKW/VCSQGQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(2906002)(33656002)(316002)(55016003)(53546011)(6506007)(7696005)(66446008)(66476007)(64756008)(8936002)(86362001)(8676002)(52536014)(38070700005)(5660300002)(66946007)(508600001)(4326008)(76116006)(66556008)(82960400001)(71200400001)(122000001)(38100700002)(26005)(186003)(110136005)(9686003)(6636002)(83380400001)(54906003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ZVf8458fyFY4rQqd6TKf8OCA48+YjLWNLvaqK/ms6psB3vXCsY+DuFWxjpM7?=
 =?us-ascii?Q?cSWjGNE6mYmS/+lSt0IvnPlpQik7851fxs+L8o1OcZDyTjPdHu5JqBYq3O2E?=
 =?us-ascii?Q?uCeun3OD1oAB1PObDkiHxm0bJDdu0islJGuBmjwJPPdZNsCthMYojV63fk71?=
 =?us-ascii?Q?mguiNW6r0D3z3AEBmVxnsNdPIjMuD5BP8ygmcEITfcUh1yv/FIgwFG2V2L+4?=
 =?us-ascii?Q?X2VWyA3FG0cO/FF5w/+sbGynH3Ia8d0b2spObjS0GFaHNu0401jwEvEynfSd?=
 =?us-ascii?Q?NpvmafelaQPv5LbWlDcExsDD79gxJc1c/h+VS7gnnyG/5PCeQOvx4J7vLd54?=
 =?us-ascii?Q?uBUNSi1u9pAN33ej/qX+j82SpEMwnSC9967jZgMUaH9gvjPErRZ5r+HF6v+M?=
 =?us-ascii?Q?bYWRtgog0cWvqF9t37D64eQAFwiiUfzTL7ickUqnDWvXnJRcTmctZa8sZx6O?=
 =?us-ascii?Q?MeApdbC9CpWjs7qnsDS3+qLGEa+cU/Ltybze+9X7GT6iE6goj0yTYjpiALSZ?=
 =?us-ascii?Q?ohujNnEu1l2WllsqMLypdVzapUsqa5/xiYXXzDUsmKH3BCLjtPmpoWnBBEl2?=
 =?us-ascii?Q?OnGuExdo2pl/ujX94e9blb7dxf2LdgmpZ1QykVc1EzD8BoN/GvKK2GBvUvSU?=
 =?us-ascii?Q?2GLbqFksJifIWjhpZ06UVKT2c7lOBvxRnu1KTy15ixUkMlohImORp409EzX5?=
 =?us-ascii?Q?d3c/lrD2IWO01On08y9RqV+Z70YaoQHCPkSx5N/zCfrtfv0FQ7DC5C8AkcIl?=
 =?us-ascii?Q?RKYGE0rAdtDHBOGuBZoNtTlPAqzy1H2hs3OhDnHSGrngY/XnS0jLMEjHHHwQ?=
 =?us-ascii?Q?gmnRYL+C6V+ffH52lBPe+XK8KBkR2dyUUy9b79wqFTOU3ktHQdX2N0RWk4Ho?=
 =?us-ascii?Q?6h4+DMchZjgSvqCzbrrTpRg/mEwpsesfUaO1+BbCmm/6PaaSIWct/J667yyD?=
 =?us-ascii?Q?oAzAYjXUdbiuBVA+hrdsIBrvRF1VXFIbQ9le1sgU16GN+HAg9DqI7jQOOE/w?=
 =?us-ascii?Q?y53lPiwopFRUPkNg1j2N5cZbqc/30PiUbM159C9ymJB8dGP8CmhOBL1uzib3?=
 =?us-ascii?Q?myPHcfXlbpgUFH3poyum8DOdKEkTCWuu7D5lt8XH7cLuHP35lcsN3hA7lDol?=
 =?us-ascii?Q?OqmFXRc2GYtJFGb22a47lxsdm0Egyer1Pq1Kjl6s2G70AJHV7pzBY3jAFLtb?=
 =?us-ascii?Q?gJd5FLrokXJjQBymfZ1Z5tWQFWy8M+KQak3ZTDMbNFbwghBJo03xota9Malu?=
 =?us-ascii?Q?SRviJU784LTXHlNc/kyw2Nb1cpqfGalsec7IlAYIOvzAAHP9l6rjCaZtwn3z?=
 =?us-ascii?Q?P6JA5SIgXI/FQzod/RD0PKjvI8kwmJ3ZZrJbnOK5CjlmKEJBRBT8rEInWPrq?=
 =?us-ascii?Q?aBserIJsnLEw2bd0WvoRQ22QtOX+DSvAhwTm/1fa1ZyiQ0HvGsFNCC3pOzCL?=
 =?us-ascii?Q?Cdal81r89IRPkE4f8BtFHisHcf5jTWTAcb3xVKmPRKgZGldZDe0P88+EOTLq?=
 =?us-ascii?Q?9fxLWIfi9po21+9hQhsmxjTJnyk7X5agivDHZPfUf1Hi4h56OXMGjGTW1+kh?=
 =?us-ascii?Q?JQpgHi88Ro+F/kZboP9F7xYu5fXe89MpuF28PUsWFE8L+oQWd+/Yg1XQLO/M?=
 =?us-ascii?Q?AirvyX1fUZ9UIKgWzMyvWuDczMrXOr6QHwhflNq0y7/49FIxqPaybAwnvIel?=
 =?us-ascii?Q?BYbuJ03X+hGOlPyEmGg/QHNkLkWnandN+hZDYA4iMjGMEbVTPEX6Og3z1ikO?=
 =?us-ascii?Q?uat7fgvSDg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3622b626-6dbc-46a4-76db-08da13516b40
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Mar 2022 20:02:43.7606
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VO3NHVLpPqaVyTM3MZDKoxoStLZURQsSCnZuxM/NBTtK2ioJHJqZ5sobhOPAtQ5tIwxUoOBJDBKxt786ukC8bC7AHMFTZKVu1tFpYKATGrI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1840
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Ivan Vecera <ivecera@redhat.com>
> Sent: Thursday, March 31, 2022 8:49 AM
> To: Fijalkowski, Maciej <maciej.fijalkowski@intel.com>
> Cc: netdev@vger.kernel.org; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; mschmidt <mschmidt@redhat.com>; Brett Creele=
y
> <brett.creeley@intel.com>; open list <linux-kernel@vger.kernel.org>; poro=
s
> <poros@redhat.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni
> <pabeni@redhat.com>; David S. Miller <davem@davemloft.net>
> Subject: Re: [Intel-wired-lan] [PATCH net] ice: Fix incorrect locking in
> ice_vc_process_vf_msg()
>=20
> On Thu, 31 Mar 2022 15:14:29 +0200
> Maciej Fijalkowski <maciej.fijalkowski@intel.com> wrote:
>=20
> > On Thu, Mar 31, 2022 at 12:50:04PM +0200, Ivan Vecera wrote:
> > > Usage of mutex_trylock() in ice_vc_process_vf_msg() is incorrect
> > > because message sent from VF is ignored and never processed.
> > >
> > > Use mutex_lock() instead to fix the issue. It is safe because this
> >
> > We need to know what is *the* issue in the first place.
> > Could you please provide more context what is being fixed to the reader=
s
> > that don't have an access to bugzilla?
> >
> > Specifically, what is the case that ignoring a particular message when
> > mutex is already held is a broken behavior?
>=20
> Reproducer:
>=20
> <code>
> #!/bin/sh
>=20
> set -xe
>=20
> PF=3D"ens7f0"
> VF=3D"${PF}v0"
>=20
> echo 1 > /sys/class/net/${PF}/device/sriov_numvfs
> sleep 2
>=20
> ip link set ${VF} up
> ip addr add 172.30.29.11/24 dev ${VF}
>=20
> while true; do
>=20
> # Set VF to be trusted
> ip link set ${PF} vf 0 trust on
>=20
> # Ping server again
> ping -c5 172.30.29.2 || {
>         echo Ping failed
>         ip link show dev ${VF} # <- No carrier here
>         break
> }
>=20
> ip link set ${PF} vf 0 trust off
> sleep 1
>=20
> done
>=20
> echo 0 > /sys/class/net/${PF}/device/sriov_numvfs
> </code>
>=20
> <sample>
> [root@wsfd-advnetlab150 ~]# uname -r
> 5.17.0+ # Current net.git HEAD
> [root@wsfd-advnetlab150 ~]# ./repro_simple.sh
> + PF=3Dens7f0
> + VF=3Dens7f0v0
> + echo 1
> + sleep 2
> + ip link set ens7f0v0 up
> + ip addr add 172.30.29.11/24 dev ens7f0v0
> + true
> + ip link set ens7f0 vf 0 trust on
> + ping -c5 172.30.29.2
> PING 172.30.29.2 (172.30.29.2) 56(84) bytes of data.
> 64 bytes from 172.30.29.2: icmp_seq=3D2 ttl=3D64 time=3D0.820 ms
> 64 bytes from 172.30.29.2: icmp_seq=3D3 ttl=3D64 time=3D0.142 ms
> 64 bytes from 172.30.29.2: icmp_seq=3D4 ttl=3D64 time=3D0.128 ms
> 64 bytes from 172.30.29.2: icmp_seq=3D5 ttl=3D64 time=3D0.129 ms
>=20
> --- 172.30.29.2 ping statistics ---
> 5 packets transmitted, 4 received, 20% packet loss, time 4110ms
> rtt min/avg/max/mdev =3D 0.128/0.304/0.820/0.298 ms
> + ip link set ens7f0 vf 0 trust off
> + sleep 1
> + true
> + ip link set ens7f0 vf 0 trust on
> + ping -c5 172.30.29.2
> PING 172.30.29.2 (172.30.29.2) 56(84) bytes of data.
> From 172.30.29.11 icmp_seq=3D1 Destination Host Unreachable
> From 172.30.29.11 icmp_seq=3D2 Destination Host Unreachable
> From 172.30.29.11 icmp_seq=3D3 Destination Host Unreachable
>=20
> --- 172.30.29.2 ping statistics ---
> 5 packets transmitted, 0 received, +3 errors, 100% packet loss, time 4125=
ms
> pipe 3
> + echo Ping failed
> Ping failed
> + ip link show dev ens7f0v0
> 20: ens7f0v0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc mq
> state DOWN mode DEFAULT group default qlen 1000
>     link/ether de:69:e3:a5:68:b6 brd ff:ff:ff:ff:ff:ff
>     altname enp202s0f0v0
> + break
> + echo 0
>=20
> [root@wsfd-advnetlab150 ~]# dmesg | tail -8
> [  220.265891] iavf 0000:ca:01.0: Reset indication received from the PF
> [  220.272250] iavf 0000:ca:01.0: Scheduling reset task
> [  220.277217] iavf 0000:ca:01.0: Hardware reset detected
> [  220.292854] ice 0000:ca:00.0: VF 0 is now trusted
> [  220.295027] ice 0000:ca:00.0: VF 0 is being configured in another cont=
ext that
> will trigger a VFR, so there is no need to handle this message
> [  234.445819] iavf 0000:ca:01.0: PF returned error -64 (IAVF_NOT_SUPPORT=
ED)
> to our request 9
> [  234.466827] iavf 0000:ca:01.0: Failed to delete MAC filter, error
> IAVF_NOT_SUPPORTED
> [  234.474574] iavf 0000:ca:01.0: Remove device
> </sample>
>=20
> User set VF to be trusted so .ndo_set_vf_trust (ice_set_vf_trust) is call=
ed.
> Function ice_set_vf_trust() takes vf->cfg_lock and calls ice_vc_reset_vf(=
) that
> sends message to iavf that initiates reset task. During this reset task i=
avf sends
> config messages to ice. These messages are handled in ice_service_task() =
context
> via ice_clean_adminq_subtask() -> __ice_clean_ctrlq() ->
> ice_vc_process_vf_msg().

Right. Because the reset isn't finished in the PF by the time that the call=
er starts sending messages back.

I also think that this could be buggy if cfg_lock is held elsewhere too (th=
ough reset is the most likely problem).

Especially since the recent changes we did in ice to hold cfg_lock in more =
places to protect against concurrently configuring VFs. I think I agree wit=
h Ivans change (though perhaps we should re-test some cases for why we made=
 this a try lock originally).

The only other concern was mentioned in a different message by Brett. Perha=
ps we also want to cancel any outstanding messages from the VF when we star=
t a reset (since we're going to reset the VF and we don't really want to pr=
ocess any of its messages that were issued before the reset).

Thanks,
Jake

>=20
> Function ice_vc_process_vf_msg() tries to take vf->cfg_lock but this can =
be locked
> from ice_set_vf_trust() yet (as in sample above). The lock attempt failed=
 so the
> function
> returns, message is not processed.
>=20
> Thanks,
> Ivan

