Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1225625401
	for <lists+netdev@lfdr.de>; Fri, 11 Nov 2022 07:45:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiKKGpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 01:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232082AbiKKGpW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 01:45:22 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D129271F3F;
        Thu, 10 Nov 2022 22:45:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1668149122; x=1699685122;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Uenebq0yN3mwWfDHZwD0J/mWO7W9nJto3mle1EosGg0=;
  b=HpXioAsjUqVXDEoOZkZtNYUaxt0naOHgSy+GIB+jIQ8vajc8ykjAZlO6
   N/anXs7JeHdXB4mRzyxcApDnrLkcx66cMZKPz0dOGbI1jqAUs55dguVet
   8gOSmBkzhHhRbJycVhDYTK9+JWzwxle8Ze4vHxF2uH2rb2AVrGgUdXqFd
   rSccI8oD4SUxg1SZ+ThR7+2wB11OZ/loGRhU6N4d7vTmWFniB0mr/Ykro
   ap4XGbu28BN1OIymrIBMyXfhmdaFAvswNg0Wq40RBWhxvYxL6EOoQKzJr
   Efw4H57kiu/qsHyvQ9D/hB0wJG0iVSd0LbefC13ts0kyXtwtoksA2H+7m
   g==;
X-IronPort-AV: E=Sophos;i="5.96,156,1665471600"; 
   d="scan'208";a="183046108"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Nov 2022 23:45:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Thu, 10 Nov 2022 23:45:20 -0700
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Thu, 10 Nov 2022 23:45:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=X+PS1Q4K81xCxF1BBXAVfntTIVuWmLEcIJJIAK4n7b7pqLMsmt2fFdzCr9mblnVa2/tZ2ZkHVwzFbfycyXK7kjC+7al0txEcnP3UJ3X+96+MxhdDts1ka6Mkb7yWmRdacmuH4PcqLLIwX2eKcDxjOXH1JPalNCUupttK5X8nD1TiRL0iZlsYX78AytM3UDW0hNkMNXOI39ZeSESF5IL8wsPP2cGm1TcQHMK7H7bo2oaWjLuxQBUZw6jCJWezPnPjGHJUJtX94eIA49lrT6G/RC+xt3UncsIsf1tQFMmFeg11YgXp7BNmEQA8GlZP4jmgqCcJRHMENfMbEl8PKlEB0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9oA3qwx7SHkat1O814gTyTxxaDZghL/kEzj+tZcY0Ug=;
 b=n7FBe6KEplLGCQjQ3Cs62Z/bJ6MggiVx9JfDiTx653/in5jzh6WZ0nHx6shC40UHuUEnD9WisCPxHtsLSpKZJ+Davrowf4SkE3wnRDJ4/cZ9JZ0Mbk5KQeyuV6RF4MGxjBzg/Lte31pK1LhTGe7NHLTGLAbOAR1hN37rk3fqSPGKy6FPiDXIIDRyMlrV5t0iBb6NmQz8eJSPcqj5fGHI91mUqQvgayAne7uGBWu9CgVLp2/mfdZyCglHQWtIdMzfTkFv3imBtIWkX9OTqKU3He1uIS1MdMKEuc68W71oYtRUXO95IBg9RK05Bum2mGqenXfCPEg7waHU+9VJsQhSQg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9oA3qwx7SHkat1O814gTyTxxaDZghL/kEzj+tZcY0Ug=;
 b=TUyjDI6AeS9/a2UXqd9stPUIEJcb+GSCPR2bb+AnQ0cqhBM64XZj56xLP1g67rOMdJOKVs8ckvV+0qZB+nWgpFCsDO1GSaXwekx2eiNUMBUf7QN06psJRRL4qhnu6Qhpe0lQ8q179aaa/WM/g5SE4AuRafL/6hDk18XSrkpdddY=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by MN2PR11MB4743.namprd11.prod.outlook.com (2603:10b6:208:260::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5813.13; Fri, 11 Nov
 2022 06:45:18 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4a9a:513a:b0bb:fb05]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::4a9a:513a:b0bb:fb05%5]) with mapi id 15.20.5813.013; Fri, 11 Nov 2022
 06:45:18 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <joe@perches.com>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>, <UNGLinuxDriver@microchip.com>,
        <lkp@intel.com>
Subject: Re: [PATCH net-next] net: dcb: move getapptrust to separate function
Thread-Topic: [PATCH net-next] net: dcb: move getapptrust to separate function
Thread-Index: AQHY9OgDJPilDH1/CUmOWEpqQ4wOy644Wb6AgADxvQA=
Date:   Fri, 11 Nov 2022 06:45:18 +0000
Message-ID: <Y23x/PSlybLqaQIS@DEN-LT-70577>
References: <20221110094623.3395670-1-daniel.machon@microchip.com>
 <87eduaoj8g.fsf@nvidia.com>
In-Reply-To: <87eduaoj8g.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|MN2PR11MB4743:EE_
x-ms-office365-filtering-correlation-id: d8e8b28a-229e-4400-d9d0-08dac3b04c2a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jjsBzWEaIS0DLfOd79oFLirnhePH2Q4VJvARq3aempO28DAPGC7Lgru1v2qRaGhdejHD2a8OAKLs0EYAsIGKOmc2peKbI+ln8dMuOPqaxrL26pfvKJpOA4b9FqzUX89fA4YJRA+yhtbE5X+9d85psVoy5j0e7K1fjqLKumgoBO31BN9TjxZCr9LGGaMFktzk864sIBdBjJrokZzMMHFzS6YQuU+AgcyXp/6y8YLrSaMNTRNbW3550gtOki7GFNjC48yyyz1bksPN/U2r/+HduhlSjGbgs7Z0Fe5hYA6MbioUsZx/v5ezY0nhLxF2VageGjzqgs5X0fcU+ulZTqU6mJ0aotTvVKqDwy1g1A9VAr0b35wd+jwlLhUbCAFIa2YfiKiCAk7yiMJPYJfB4koSl4i+7PxZtGRCOeQoBactMpd82t2DWH8uKscnNNvy/JIOiyP7iSR3qRewf+9xhI9/kHkSpvqYwS4zBbgm5mRQJyqp5bpGVe6YdLYbsXIbYmw2pUo9x4024z42gX8ntLSupGBTR/ruxmQ5reINGrBOqfgDCkl3ri0Mb/43bJZfweJZVGvUR0mt7ZoULUExToDzF1WvZNfTSpgnLYprFnJCP06zRWb24k/aH0Es6Qz3O9hLMFqofsey4xXgDYG1IPgGxy4Xe3FVKhcgbQ+rBMN7D9el7ni7FJZATm+8pcZBb4Lc7FBZVjN9JgrtiY54Yugk/b5qquCmucczJiOGeccLqtfzLUn7L++5Kcnvup+ZraFWwwW+qVWcu2xy8LxA899YBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(366004)(39860400002)(346002)(376002)(396003)(451199015)(5660300002)(186003)(8936002)(478600001)(6486002)(316002)(6916009)(6506007)(54906003)(2906002)(122000001)(71200400001)(76116006)(86362001)(6512007)(26005)(91956017)(33716001)(38070700005)(7416002)(4326008)(66946007)(41300700001)(66476007)(9686003)(8676002)(66556008)(64756008)(66446008)(38100700002)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OgU3jnCVefW6PgVmAGZA+7wb93LazdYGQ58ifqUK0fE3/wVWCO6DeDnnq/qr?=
 =?us-ascii?Q?AGVozMQZZN6LX9TnBvlImnwGDWWpJ3mxbxqL+3xyr3k2dSP6LG3kJsgSvdLy?=
 =?us-ascii?Q?CWFwKnrIOHciR0ruI5/eIROMphO60MlGhRoKHbK/UhLn2wGaBeETQyDgCnS7?=
 =?us-ascii?Q?vyEI9xYcTnKfdZb97jrZtPAvvtqaRYwx+ngiThXtlk8F0vTTJm2QElJJj6e2?=
 =?us-ascii?Q?vi2UYS8ZBKBj28txPPnSN/BQ11jLvbIX4Ekoo/hETt33cXqqsgYqtM34vVu4?=
 =?us-ascii?Q?QhZfcTlFy4F6GY+AX14RiffuVjqWExRag+kX9oZISedG/Q6z9JhQs4Reykys?=
 =?us-ascii?Q?iCQzSPpwlNZGEMAemX91C72D7Pcaadoqhemi6RiaZjsowHzqBhTR793M/ZDX?=
 =?us-ascii?Q?fqvBgh1I1E/uTGlJ4WGV7Ut/gwgIP32aTLxRIrjrGo4IS9VursrLyeEz8DC+?=
 =?us-ascii?Q?Xo8hT5eGQ74jdXUiZqcPvbP8Ll9fq2EcZb2JvvMAM5I/SuFxWSpsCoPfdcWf?=
 =?us-ascii?Q?DMJtZjUvqjxD8xWB8CcK8ENzifjdK39pEu6pNrrr52CGwS3VeTPxIxscrYN9?=
 =?us-ascii?Q?O4SdbBY3O+yfmLZFoGzhtEyAZXoLOyN6wtW+YktOlYe/cKeY+ZOXEg8aY0d7?=
 =?us-ascii?Q?wN6gh4oK5Zaovq8AgtNu12gaYRcJndlVn3acv1PskCDoqulO/TyD7jZ8PVVV?=
 =?us-ascii?Q?XV8Ur24xVVmUnkcHO/1IlP0QIXFh3x9nTJac2jkhZoahEjJEo7mYjy7AO4Qj?=
 =?us-ascii?Q?VlkDMhSQByRkcphhMtxu+k5bEVtB+sJlgysaqc++A2C+yhtvFL83IaANofjb?=
 =?us-ascii?Q?tPzDJMwLi080ESUIt2sMPtqmuYjz9/fI7BYExdsVUrGiz0JenMX3E+xsmUMZ?=
 =?us-ascii?Q?rX4slQWVBiXUrkhr8DW7ciX+IMy1AOHRuu3fmXROkuAflFjx71a9ntX1M2Ow?=
 =?us-ascii?Q?dPwQNC5bmfo48mRWy/fWa4JUiXXlCWhH3Bawh1bO+lBDx2O1yEgerkgZUsPY?=
 =?us-ascii?Q?r05alg48jAsycs0YX17xQcQzNU4Q8K/GCVJCDoxQ2lgTei24VTkwCO0ywULr?=
 =?us-ascii?Q?2DQv0tEfqnYMt9KD/LlNupm7+DFdrKZ6mI+gkPS6RrmWNpvWn6HJZCSjwBQF?=
 =?us-ascii?Q?MzVEKvqr+2XEBxZNeGQARWrQ2kJ7aLVMYru+UZCwOzVP24FduP1BVwCXVcWP?=
 =?us-ascii?Q?FrJMA7G+7j8s10O1/PlkFvsf3MinV+Pb5JoioeL0Ox73GhowCIk3DXN0Iniq?=
 =?us-ascii?Q?aeYcqrLS4dMDC1fT446JbYYCZxoOcNwP2AJu3bYjyPfkiJjZYaYIkDJZnDAn?=
 =?us-ascii?Q?H8c9LY4Q9dfZ/TzPDdPUoutMOeF7uXGQ4d6dG+9U8RhBSzi0hEtY4P6wsu7F?=
 =?us-ascii?Q?NOqUD8lp1yysOGB+HSRHxEHaFULherB/bhjZFGh1KD1IehCPaWzLyOTjiVb+?=
 =?us-ascii?Q?fBps4Ng3ZYxuVnzzVbMoZ7NpLOUU4YrusLMXvu6G4KHGgWnKjl6Z5ifAY8Z5?=
 =?us-ascii?Q?VcQsF8hf7yZIGUYc8pgEHL/OTbyoaW1Rz6F+lbSXHWQJ7S8QjejaFTXEB9Rv?=
 =?us-ascii?Q?mBuUPtcWJ7jS1m26q6Gtqwl7ByEZUNgHa8CRw3td9KM2yTXNqk4QqsyNxmBt?=
 =?us-ascii?Q?W58fJNbkrM1eJLlbLpgiep4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5E31ECD4200BBC448C096858C85759D9@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8e8b28a-229e-4400-d9d0-08dac3b04c2a
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2022 06:45:18.5258
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Nq7ZTyHlUKU3Z8iJbMJJ+i1DkCTjSRi34DRYev2w+/tz2PbeNtVhreJ7oa3rBdTZbSAoXuQc19IWhdX9mua492H/8iuLD+5s6BOxE0NZbx0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4743
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Den Thu, Nov 10, 2022 at 05:30:43PM +0100 skrev Petr Machata:
> EXTERNAL EMAIL: Do not click links or open attachments unless you know th=
e content is safe
>=20
> Daniel Machon <daniel.machon@microchip.com> writes:
>=20
> > diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> > index cec0632f96db..3f4d88c1ec78 100644
> > --- a/net/dcb/dcbnl.c
> > +++ b/net/dcb/dcbnl.c
> > @@ -1060,11 +1060,52 @@ static int dcbnl_build_peer_app(struct net_devi=
ce *netdev, struct sk_buff* skb,
> >       return err;
> >  }
> >
> > +static int dcbnl_getapptrust(struct net_device *netdev, struct sk_buff=
 *skb)
> > +{
> > +     const struct dcbnl_rtnl_ops *ops =3D netdev->dcbnl_ops;
> > +     int nselectors, err;
> > +     u8 *selectors;
> > +
> > +     selectors =3D kzalloc(IEEE_8021QAZ_APP_SEL_MAX + 1, GFP_KERNEL);
> > +     if (!selectors)
> > +             return -ENOMEM;
> > +
> > +     err =3D ops->dcbnl_getapptrust(netdev, selectors, &nselectors);
> > +
> > +     if (!err) {
> > +             struct nlattr *apptrust;
> > +             int i;
>=20
> (Maybe consider moving these up to the function scope. This scope
> business made sense in the generic function, IMHO is not as useful with
> a focused function like this one.)

I dont mind doing that, however, this 'scope business' is just staying true
to the rest of the dcbnl code :-) - that said, I think I agree with your
point.

>=20
> > +
> > +             err =3D -EMSGSIZE;
> > +
> > +             apptrust =3D nla_nest_start(skb, DCB_ATTR_DCB_APP_TRUST_T=
ABLE);
> > +             if (!apptrust)
> > +                     goto nla_put_failure;
> > +
> > +             for (i =3D 0; i < nselectors; i++) {
> > +                     enum ieee_attrs_app type =3D
> > +                             dcbnl_app_attr_type_get(selectors[i]);
>=20
> Doesn't checkpatch warn about this? There should be a blank line after
> the variable declaration block. (Even if there wasn't one there in the
> original code either.)

Nope, no warning. And I think it has something to do with the way the line
is split.

>=20
> > +                     err =3D nla_put_u8(skb, type, selectors[i]);
> > +                     if (err) {
> > +                             nla_nest_cancel(skb, apptrust);
> > +                             goto nla_put_failure;
> > +                     }
> > +             }
> > +             nla_nest_end(skb, apptrust);
> > +     }
> > +
> > +     err =3D 0;
> > +
> > +nla_put_failure:
> > +     kfree(selectors);
> > +     return err;
> > +}
> > +=
