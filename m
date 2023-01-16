Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE0A66BE95
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231375AbjAPNDL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:03:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbjAPNCn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:02:43 -0500
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A18681EFF7;
        Mon, 16 Jan 2023 05:00:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1673874015; x=1705410015;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=GrHKsp2fiBSUnWGrmv8Gy8ETt5hltDZp2vMQHVl8cO0=;
  b=MjEbeqS5OacRxzv2FrcaX0sshd/u/DJlxvsT8BjDp8Q+Mrqe7kWgn5+s
   r3YJkqcX5Dw15ICjNByE1PwUgcy0CroYN3bWcaxrjc8Uo6NeUCQpqGuvc
   tOdWjjgkDXXfe6dIFurkdB5BFM3GT5ymE0YbG5H1Q7pj+Vxn1tFr4Or1H
   tAR6VT+IHIawbVUP7smJrHhzZD4KPTMiEIB+3DyyzD7rhQnVBJS9+DPsU
   WDgUHtlQA10EdI8ZlcLJ9fj+NtW5sg/y7Y8UPfW42WDSYw11JVQRQjGKn
   4pzRQMI9MmmYSBskNmOzy9poOqY4tLyucy0zgWa4RLth6mlTNWraksqyL
   w==;
X-IronPort-AV: E=Sophos;i="5.97,221,1669100400"; 
   d="scan'208";a="196828073"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 16 Jan 2023 06:00:13 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Mon, 16 Jan 2023 06:00:13 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.16 via Frontend
 Transport; Mon, 16 Jan 2023 06:00:12 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=O9JvFRIz437KT/krZEtXzbXm0CB1oa0HIpbAXL9ZrKuYYKZzBK64RVgK+bfwNOtMDhDcfGm6vnRVi7UJAVdFVy1eoXvH4NGetFnTCYjCPUSYUzOypeZFOQq+tAPrWtbvi2ad22xiISSPQUhcDR8T95VVCYGrUbGH0JZ0g3kpqEWLhx3yd2zAZWNVXOv7cGq3c9vRuqZUJN8pGVoO2y/I7wwSsK0ujVRNaXo1kw0bP9BqPbZd5GNnYfXCdQaFdbMvY88Wj2SJtljaWsrHpX0RZTEgZBVxgFUHkdIk8lX7DFgY3roBqQSZhFmk1mu+83XhgqSeeEihCMag+HpeZK9R9A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n80+3djVOZQJjTT7zFRvPiDFX2/gf0qfJXZ6JVuVojo=;
 b=C65M1xYz2F+XQzqAcPU6f2CCRQ9EQcCTr1H9dStAQLxGaNsu/1h203GsC6T+DxSNaR/uWjMdcy4DsBeB51C2Li0MZ/D+tYXfozHPFwbZWWm720dlVrqi616vN5ZoSqjo+vKUQc8/0c9O6/nKVlMyT0wbpHpERRiUoW4B9UV9wOdkchj+1TZgpUe5T7DbY0EQ9sN0CsmoXOuWpx/PNWLbWHWx1QG+tTwxlpE3t/h350IvEzbDFEgCGe6WE2OuyCub2ufo1ODZVxMZN2GxdoNVvnh1rTqeKgcGw1q6pSb/wWobYODWXsTLj2gxCaoG3GxpqTetQAMvzdxHUgFYK00HYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n80+3djVOZQJjTT7zFRvPiDFX2/gf0qfJXZ6JVuVojo=;
 b=vGHtjunEa3ML2H536TTcEPau5vEYd4I1GrTrh1Mxv6BW5h+dnrsmS7dBmDBRhmoRVFTGVH5PlyrjCLdxKnmn1QV7n4Rapixgrcl7/HEomepCC3dK2Q0pSL2qRNUzi1jm50ZIswb3xNvIEmQQty1IYHaUHyinnmHerkBNv9955Ts=
Received: from PH0PR11MB5580.namprd11.prod.outlook.com (2603:10b6:510:e5::10)
 by PH8PR11MB6706.namprd11.prod.outlook.com (2603:10b6:510:1c5::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.13; Mon, 16 Jan
 2023 13:00:11 +0000
Received: from PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::1ac5:42cb:a1d7:c6a1]) by PH0PR11MB5580.namprd11.prod.outlook.com
 ([fe80::1ac5:42cb:a1d7:c6a1%8]) with mapi id 15.20.6002.013; Mon, 16 Jan 2023
 13:00:11 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <error27@gmail.com>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <maxime.chevallier@bootlin.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Thread-Topic: [PATCH net-next 2/6] net: dcb: add new common function for
 set/del of app/rewr entries
Thread-Index: AQHZJsEEnFbJ+CUja0WnZfWTFKCrSq6cb8yAgASXnoA=
Date:   Mon, 16 Jan 2023 13:00:10 +0000
Message-ID: <Y8VKWcqGEjPOvCQE@DEN-LT-70577>
References: <20230112201554.752144-1-daniel.machon@microchip.com>
 <20230112201554.752144-3-daniel.machon@microchip.com>
 <875ydazcfa.fsf@nvidia.com>
In-Reply-To: <875ydazcfa.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR11MB5580:EE_|PH8PR11MB6706:EE_
x-ms-office365-filtering-correlation-id: 453dd267-5859-4a36-1a23-08daf7c199ed
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fxlVfQS9oSIO+6nuhgwJp5kFJzx3HqKobTMFDysH3x41cc3v9wTwEdNlovrvnM9Bfv5DMr5s/Kv/jwyN1tsl+2j04d2/OVRztoYij/gGNofQwr8Lbx9Dl705QL1jjK12l1eZpSXP+kuJT9v9eJz4AfUxa687kyisUAAUaIW3qn41AVQNBqWvXflGq+5g/ckXbFaiI/jDuYdtrO+jRdz9B1dsnYmB61+nHg62ngWlQJfxmfK5lwMb6DTGTTMyef606BdZVUXjebJ6ln1sHdaFvnAUzKnOjNPyA12z+YqHWeMjy07fo6604qAFu4OP+xn5IJlDsjzm2XNfefdcxL1JpW07k5G4fUQ/jQN24NSw8zgbxEqasBS17ZPoofBKhNWf9HFR3/6GYd00oLRQ/tePvmyYZHjPDUDHBsLWC2Xs+ICAFFa9lwx/vBDKh1EI/6AsGbOwaYFjbMGxF3051rJ1X3+9zI6bXsaT7oxMvEfPEFPrrRkfggwgUGRmnIauividKfTS5QC5CT0sc7L4z9to9wB8uhmj9dZ1LUmFeaS0ywfhAfylKl4QotdoMZHZ+jsHo34eMrPLmIxJ3qvXgduPKX8zRemwAMVoZ887LMkp5yDflRaBtYXapyuKYZ8PDK/YGq82VL9wHc/Jw0+hZT7OSG3kjrtylYNv8LuLMZNd0s/1mSTW8dgUS0+qxhm4rpbK3fE2VSRcHw8BXaDzRO6Qcg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5580.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(396003)(366004)(376002)(346002)(39860400002)(451199015)(76116006)(71200400001)(6506007)(2906002)(26005)(66556008)(66946007)(64756008)(6916009)(66446008)(9686003)(6486002)(478600001)(6512007)(186003)(66476007)(41300700001)(8936002)(66899015)(4326008)(5660300002)(7416002)(38100700002)(8676002)(83380400001)(91956017)(122000001)(38070700005)(33716001)(86362001)(54906003)(316002)(19627235002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sMSdklfJ0pcP6yWanZVROG03v4T5D7DUJUuLhSKFm8VhpLJfdqpa5HvVY+5T?=
 =?us-ascii?Q?avJw9B+W/7RRuoP6Qge2sC28ty0mj8VyAwuoMhGSS90EFh2Q1XHvJE6IPu/m?=
 =?us-ascii?Q?AOxI35Z4kn8S2d6MvTuWqmaXrjR23fTIijAMLdLuLgNOppX+idQ8KUhzpueE?=
 =?us-ascii?Q?sletCtt2xt11eb0qXlNwW1zbrG1IjtJKFRiF2zdhfQTJXD6XJSruJahJAzZd?=
 =?us-ascii?Q?+ape/3xQzHcPBATQgfcrWFAz63EKS2EhgfbFCV9u/P8AdtdolH2OomnWweZ4?=
 =?us-ascii?Q?NnVusy8+96y9U1/4IIbJwCkKk0KQP14NLjdzmy4jtem24sr2bxSM8FXSN/TM?=
 =?us-ascii?Q?Qzgd1519d8JCeDahVI6Bv+Q9jm8yyptYcSN5lRgQs6gEU7VTy7JqkWijqLey?=
 =?us-ascii?Q?wQZubGqcxHQjnDJYgFe/2B56xf3crAgcAK+4fPBc0WJaXzSp8Esm4QBoVzMZ?=
 =?us-ascii?Q?3VHnSYU+MKw79XoO2J4F0Sh6mj82boBbaL6CfzApK4F1OCJAsZ3GUW09Z6Yt?=
 =?us-ascii?Q?FHp5dTgLsR7WxU5FDivrlY/vIq6dK1onbQfyRH95LqgBlHr1nPfj4OOq+zWR?=
 =?us-ascii?Q?0jBpliRFiSjUOK2vfNc97Amc26X3mzsUM6p0fWs0I8dziYbtmceuzScF6/Wz?=
 =?us-ascii?Q?IJITbkqa31CI6StB6XDQzEEt0Oi1Ve4S61H+j+tnx94Q168nRBQ85wO/L9lp?=
 =?us-ascii?Q?hYo5CJ4eDTH9/zlqdqUSsuHjbnZy6fcc3In8EpjV0y76yE34RrdTftaq0B8l?=
 =?us-ascii?Q?Z4naRh7UAXdqsKjBuI10k8pFWBLXE1xXNmTs6I8OPsJPg4oezYKrKaw+lsC7?=
 =?us-ascii?Q?U2sRbTfuburVTirzW6zgIhqnqHnKaLPJtSrBmDEGh4GjtVcn9JwtYFeDP0b4?=
 =?us-ascii?Q?opfs+aEhh00AbyPlHnNOcrRHGFU73vCdI+ki3jYp6NUdwHwcjjPtvZNkwK3V?=
 =?us-ascii?Q?HEA8B+wv9gMqw9o27f0xcSm6GTPdU6B8R6fZZnGIVvksHF7sl826f/jlq0ZO?=
 =?us-ascii?Q?ndJ5+5K1PJjG2jJstBPo8G6kv88tYk+EjWZBydXQQoRE7PMmSS9v8cKLxf7K?=
 =?us-ascii?Q?JBBZYw1BILYyLM4uaIVD+nFbe7AfF4jRrNGq53CtI4n1ho742mA46beWaEj+?=
 =?us-ascii?Q?ZSfOauQvn+L4TIchrLvApXKAGmvbKClpGYv6aM1Nb5P4VRhUz60V8C66cfwD?=
 =?us-ascii?Q?le8xS9gBNFwPCGOxnAQ7x0cCn98xGr5C6qguIUcBLzHNRDFckU/Dzct07eQj?=
 =?us-ascii?Q?pn888wEpT2QY49UkGRfPDbQmfds7Aw8MoxX+SHF2Di6QDqystVDmPEU8vWWh?=
 =?us-ascii?Q?lzL7mVKbPqWs2BE5xEEQPUSVlpltdbjSQRbUaQor2mPdzURgEkaXyg4JpOla?=
 =?us-ascii?Q?M26rictNiIMAR5wf8PtTkMeIl4DbCgXQthoCHgsM/ombjkIMExE4JWU3pbIo?=
 =?us-ascii?Q?nuggS1NmqZOSBVg6qnGqbyVgqMjs9Jb8/AtF6rI63ue+MdB8TrLvAswvtt1P?=
 =?us-ascii?Q?RKhwamta3eeQLoVSKpFVFeDBmqQHj+SKSGHqARarbSHU0BysWR4FX11xLcDt?=
 =?us-ascii?Q?3UCFcK2kYq91QN2p7anwCOJ1hXlxUfOr1a17xSBbH3yKf/t09xRbE7uex1CN?=
 =?us-ascii?Q?4egevp7LmVfwhsSeliFsWk4=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <F2524BD175D2094BB69A8F3978D0678E@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5580.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 453dd267-5859-4a36-1a23-08daf7c199ed
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jan 2023 13:00:10.9079
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LfBcFxLlfiFsClAX25q84MRl0xZik4AoOY6O3d2D/9SlKLyP1+2TBE2YrSUXkU5qNv+OPyjTSNdd7y/T8zVT94OsbRqiJQyijIsHgMFZsRg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR11MB6706
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
> > ---
> >  net/dcb/dcbnl.c | 104 +++++++++++++++++++++++-------------------------
> >  1 file changed, 49 insertions(+), 55 deletions(-)
> >
> > diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
> > index a76bdf6f0198..6d19564e19a8 100644
> > --- a/net/dcb/dcbnl.c
> > +++ b/net/dcb/dcbnl.c
> > @@ -1099,6 +1099,45 @@ static int dcbnl_getapptrust(struct net_device *=
netdev, struct sk_buff *skb)
> >       return err;
> >  }
> >
> > +/* Set or delete APP table or rewrite table entries. The APP struct is=
 validated
> > + * and the appropriate callback function is called.
> > + */
> > +static int dcbnl_apprewr_setdel(struct nlattr *attr, struct net_device=
 *netdev,
> > +                             int (*setdel)(struct net_device *dev,
> > +                                           struct dcb_app *app),
> > +                             int (*ops_setdel)(struct net_device *dev,
> > +                                               struct dcb_app *app))
>=20
> The name makes it look like it's rewrite-specific. Maybe make it
> _app_table_? Given both DCB app and DCB rewrite use app table as the
> database... Dunno. Not a big deal.

Yeah, the other shared funcs are called _app_* too, so lets stick with
that naming. Agreed.

> >  /* Handle IEEE 802.1Qaz/802.1Qau/802.1Qbb GET commands. */
> >  static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *net=
dev)
> >  {
> > @@ -1568,36 +1607,11 @@ static int dcbnl_ieee_set(struct net_device *ne=
tdev, struct nlmsghdr *nlh,
> >       }
> >
> >       if (ieee[DCB_ATTR_IEEE_APP_TABLE]) {
> > -             struct nlattr *attr;
> > -             int rem;
> > -
> > -             nla_for_each_nested(attr, ieee[DCB_ATTR_IEEE_APP_TABLE], =
rem) {
> > -                     enum ieee_attrs_app type =3D nla_type(attr);
> > -                     struct dcb_app *app_data;
> > -
> > -                     if (!dcbnl_app_attr_type_validate(type))
> > -                             continue;
> > -
> > -                     if (nla_len(attr) < sizeof(struct dcb_app)) {
> > -                             err =3D -ERANGE;
> > -                             goto err;
> > -                     }
> > -
> > -                     app_data =3D nla_data(attr);
> > -
> > -                     if (!dcbnl_app_selector_validate(type,
> > -                                                      app_data->select=
or)) {
> > -                             err =3D -EINVAL;
> > -                             goto err;
> > -                     }
> > -
> > -                     if (ops->ieee_setapp)
> > -                             err =3D ops->ieee_setapp(netdev, app_data=
);
> > -                     else
> > -                             err =3D dcb_ieee_setapp(netdev, app_data)=
;
> > -                     if (err)
> > -                             goto err;
> > -             }
> > +             err =3D dcbnl_apprewr_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE=
],
> > +                                        netdev, dcb_ieee_setapp,
> > +                                        ops->ieee_setapp);
>=20
> This could pre-resolve the callback to use and pass one pointer:
>=20
>                 err =3D dcbnl_apprewr_setdel(ieee[DCB_ATTR_IEEE_APP_TABLE=
], netdev,
>                                            ops->ieee_setapp ?: dcb_ieee_s=
etapp);

Agreed.=20

Will make the suggested changes in v2 - thank you Petr.

/Daniel
