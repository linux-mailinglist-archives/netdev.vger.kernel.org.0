Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7A8A30B0E7
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 20:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232866AbhBATzm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 14:55:42 -0500
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:5115 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhBATuj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Feb 2021 14:50:39 -0500
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B60185b670000>; Mon, 01 Feb 2021 11:49:59 -0800
Received: from HQMAIL101.nvidia.com (172.20.187.10) by HQMAIL101.nvidia.com
 (172.20.187.10) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 1 Feb
 2021 19:49:59 +0000
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (104.47.56.172)
 by HQMAIL101.nvidia.com (172.20.187.10) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Mon, 1 Feb 2021 19:49:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lTjhGzp8v6vud95ndbG7nuAy/WZFyfKrVOsl7DuZukcG79yzr/mSBJyPRjlCRcG/7ExhWbEtTweXprdA3EELe3DVtwAneEumPD6e6dcubiVdeaqL8uUUH1LFzMxAfg/d/YKQaGMvUeQBJPozV6IlKY9J/0jF6S4XFvy5+f8D8ZrtFVSut96gIyYUK9QiwL/jNzlqhMRodqXIzpbnzEglLBmcbBVykJ139Ee+J+2OVczKMHKbYI31Xp9n+HW1a4wd/jqeftbfzOVRJEbQ5WnQbJvTQYsmTDQH3dDJ83IZaoYghHR3HtXv7vsxN5XvWwapkV8nTsUstC3QwmWNuexVEw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HBxjH5neZr6v8x3G/aQ1+fw1xLMh9ixsDSfRPtAU7iA=;
 b=MxW8cEieimVSbIwHqmVtz5o8bx93JFaii6H/LDxqoJbANjiaI9hn7esHtsdc1M714TVQD/vzzZDqyBKFNJ9Xn8StH3w/vP+KBNSNMvh21ofDdIAR0Vhke8X8ZVl8L18W0QQpKte4XCUw6qjCImAhfsD0A+ucjmYIUEeONYPriHzwQPirM6ah85oPNt85k9dRAhUcqfbexbBpW9SycSXsWNhePi/3WGIi5bDESjUUgSB0PSGeujiqcWkIIyUsf1Gv3JOPuth9gk2DHCxcgeRWPyIjbPwBMYU8pe+jnENEEvD7yfmNJSisHllVdF6ulGG06gKyDMJNZ6E78YQNz5LTvg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM6PR12MB3834.namprd12.prod.outlook.com (2603:10b6:5:14a::12)
 by DM6PR12MB3211.namprd12.prod.outlook.com (2603:10b6:5:15c::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Mon, 1 Feb
 2021 19:49:54 +0000
Received: from DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4]) by DM6PR12MB3834.namprd12.prod.outlook.com
 ([fe80::d6b:736:fa28:5e4%7]) with mapi id 15.20.3805.025; Mon, 1 Feb 2021
 19:49:54 +0000
Date:   Mon, 1 Feb 2021 15:49:52 -0400
From:   Jason Gunthorpe <jgg@nvidia.com>
To:     Yishai Hadas <yishaih@nvidia.com>
CC:     Saeed Mahameed <saeed@kernel.org>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next v1] RDMA/mlx5: Cleanup the synchronize_srcu()
 from the ODP flow
Message-ID: <20210201194952.GS4247@nvidia.com>
References: <20210128064812.1921519-1-leon@kernel.org>
 <c79124a204f2207f5f1fae69cc34fb08d91d3535.camel@kernel.org>
 <549b337b-b51e-c984-a4d8-72f9f738be9c@nvidia.com>
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <549b337b-b51e-c984-a4d8-72f9f738be9c@nvidia.com>
X-ClientProxiedBy: BL1PR13CA0125.namprd13.prod.outlook.com
 (2603:10b6:208:2bb::10) To DM6PR12MB3834.namprd12.prod.outlook.com
 (2603:10b6:5:14a::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mlx.ziepe.ca (142.162.115.133) by BL1PR13CA0125.namprd13.prod.outlook.com (2603:10b6:208:2bb::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.13 via Frontend Transport; Mon, 1 Feb 2021 19:49:54 +0000
Received: from jgg by mlx with local (Exim 4.94)        (envelope-from <jgg@nvidia.com>)        id 1l6fCq-002JGk-KY; Mon, 01 Feb 2021 15:49:52 -0400
X-Header: ProcessedBy-CMR-outbound
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1612208999; bh=kEtrRsuido8TLUti8q11CoXcBe5X0kjjn+lrzfxfvYQ=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:Date:
         From:To:CC:Subject:Message-ID:References:Content-Type:
         Content-Disposition:Content-Transfer-Encoding:In-Reply-To:
         X-ClientProxiedBy:MIME-Version:
         X-MS-Exchange-MessageSentRepresentingType:X-Header;
        b=g0yMjO4wBPTLgSC6Ze/Lnx01bC5NtVy9J6D6WdixHJZtIW7/z/vyMbi7G1H4HpaMM
         d5CuWjRIDlQg8fOrEuZcV0FY2NNjFIF9476ndfc47u0ew33sQSVU7LAfaZw3Zf1eSN
         2lNmghMOf2iB0hbWbsLU1e6j9vJPVlCE9Yy4tolr2Mo2Ddv6MxKH8xxcc8ABfDVKwn
         HGbk5DXhNKGMraGOVS7c6NL7A5nvI/l1kmt5+R3q8X+JVdS2sWDC+DEGxNheBOsJuQ
         yqcbw1qpoyVhtWnuztDFJBsJ4Psb/k8AjUZni0sCgaGzXKOWrX+CyGEbaD0UNSIsZd
         GVqU1+q6ClaHA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 03:24:50PM +0200, Yishai Hadas wrote:
> On 1/29/2021 2:23 PM, Saeed Mahameed wrote:
> > > diff --git a/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > index 9eb51f06d3ae..50af84e76fb6 100644
> > > +++ b/drivers/net/ethernet/mellanox/mlx5/core/mr.c
> > > @@ -56,6 +56,7 @@ int mlx5_core_create_mkey(struct mlx5_core_dev
> > > *dev,
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mkey->size =3D MLX5_=
GET64(mkc, mkc, len);
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mkey->key |=3D mlx5_=
idx_to_mkey(mkey_index);
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mkey->pd =3D MLX5_GE=
T(mkc, mkc, pd);
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0init_waitqueue_head(&mkey-=
>wait);
> > >=20
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0mlx5_core_dbg(dev, "=
out 0x%x, mkey 0x%x\n", mkey_index, mkey-
> > > > key);
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return 0;
> > > diff --git a/include/linux/mlx5/driver.h
> > > b/include/linux/mlx5/driver.h
> > > index 4901b4fadabb..f9e7036ae5a5 100644
> > > +++ b/include/linux/mlx5/driver.h
> > > @@ -373,6 +373,8 @@ struct mlx5_core_mkey {
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0key;
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0pd;
> > >  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0u32=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0type;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0struct wait_queue_head wai=
t;
> > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0refcount_t usecount;
> > mlx5_core_mkey is used everywhere in mlx5_core and we don't care about
> > odp complexity, i would like to keep the core simple and primitive as
> > it is today.
> > please keep the layer separation and find a way to manage refcount and
> > wait queue in mlx5_ib driver..
> >=20
> The alternative could really be to come with some wrapped mlx5_ib structu=
re
> that will hold 'mlx5_core_mkey' and will add those two fields.

Yes

struct mlx5_ib_mkey
{
   struct mlx5_core_mkey mkey;
   struct wait_queue_head wait;
   refcount_t usecount;
}

struct mlx5_ib_mr/mw/devx
{
    struct mlx5_ib_mkey mkey;
}

The odp_mkeys XA will store pointers to mlx5_ib_mkey (not core_mkey)
and container_of() to go back to the MW, devx or MR.

> Having it per object (e.g. mlx5_ib_mr, mlx5_ib_mw, mlx5_ib_devx_mr)
> increasing locking scope and branches on data path to find the refcount
> field per its 'type'.=C2=A0 (see mlx5_core_mkey->type).

It is free, just use container_of, no change to locking/etc

Jason
