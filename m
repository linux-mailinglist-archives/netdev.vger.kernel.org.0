Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFBB6136CA
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 13:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbiJaMqd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 08:46:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231318AbiJaMqJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 08:46:09 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4641CFAD5;
        Mon, 31 Oct 2022 05:46:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1667220367; x=1698756367;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=Gv+oyFnjtEJQ1UGWq3ZCuY9sHfaHEDEYv6k7KNAprxQ=;
  b=ILnjZNM+mq5J8FIbuF9qM3t7wElCVD60fc0COLDOIJfsRrqkQv4LEp5d
   r1ST3MP6UOA4IRbDvEo0jB0xTmrDCVHNmVgNyq5xhZwaWiYGENmQT1RM2
   eU76WIU04+rmqG9el1ubw/8++OmUn0rnqF5hdZjOF9vfIZ77zcJWO+6Nu
   BUF3oi7ReFAgjGQKS69zTnvTfBy2903f+XP1ITQWA8gtvxrMJ4mpKOH01
   zb6tPY1qeS+FgIFonjIO2GnFLJbgzRX7YBbYwkkERInTqF7vCa7C4AwWI
   PoTSEkm7s/E+086rJ216um+znevv0vj1JQlITnQkL18BYSIT0jmzMpgjC
   Q==;
X-IronPort-AV: E=Sophos;i="5.95,227,1661842800"; 
   d="scan'208";a="187044017"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Oct 2022 05:45:58 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12; Mon, 31 Oct 2022 05:45:57 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.12 via Frontend Transport; Mon, 31 Oct 2022 05:45:57 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=H4U7AqVsR2AMelsGvSpLzk6gKJMZsfwr9QYjnu2sjIa7aVbZnSIIXD5bsEG3D+/zwhxmC1wRZ50nTefvvZoE4pfBCcgwVfyhfgNWELIK3zS/gMUDqLwwe/KNHsipoKUcVPV3HXLpSM9PDJkwff+rNMf8PkzCqbzBqg0JyrG5sK9x7x07KeM96nX2aQ0O/LJit1hf+eXMfXQJz/38+cI2BU3X+bbqXHO4YnLr+6iF7gEB0RuQONkRH2q1+sRFnE3JZZ/vIy0OprzMrlv1eghukeylkEkrnmC5fJDQjYfEVBX4HMfDazLOuP5hw5suFvqUWIC2MLLb9Z0fd8g7k8vGMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=rwsAgmtgaGURxyqKPd3ueOjSKNL329RmpipWIutvdys=;
 b=KMQVdCRXIXx2M7lvVDTDrRXHDsEk3eF8IIzw1yMPUnIMbLNJV5LOm1XqFWXl9UY9A8ySizOtVYc98Ro3tR61DEWFi4IwjnOB5zlUKQsEzcduUX9KDfTKrdMUIPylJ/XsFxhjXKKuM4T4DqI5C1nqHlO1GvvPtm75YGMiPhXeMKTRKzwM7A8idnBPkGWxm8YvjTmsuHnQMZfFCpkDbvICy2i3GXbY8viLADz9lcUy++vDpgXVnLAoiKVbV8tdqnclZhdg43At2JWU7tjnVNy03hDN/kdH52qIka8eMpug01SyBPjyda/YWrnwvyvvoX0MGUqXjgMT8ABW7e+rrnd4Ig==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rwsAgmtgaGURxyqKPd3ueOjSKNL329RmpipWIutvdys=;
 b=LUu3Eh0RqB2vO/snvmrGDzITGA80qFAEYkFGn4lGZTUOU6fYV1EqbjCXZ/9+k06+067t0VzNfkmEepeVsSx8rMgtSPiA8ZAaqKCuA92B0QbYFqx8a0IRwhqHwUQufgEan+CmmmbbfZNedsTI6kmoCqo8sE6rbnFd/Lq9Vi6fb0U=
Received: from CO6PR11MB5569.namprd11.prod.outlook.com (2603:10b6:303:139::20)
 by SJ0PR11MB6623.namprd11.prod.outlook.com (2603:10b6:a03:479::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.19; Mon, 31 Oct
 2022 12:45:56 +0000
Received: from CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::d02f:4ea6:e2ce:4a93]) by CO6PR11MB5569.namprd11.prod.outlook.com
 ([fe80::d02f:4ea6:e2ce:4a93%6]) with mapi id 15.20.5769.019; Mon, 31 Oct 2022
 12:45:56 +0000
From:   <Daniel.Machon@microchip.com>
To:     <petrm@nvidia.com>
CC:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <maxime.chevallier@bootlin.com>, <thomas.petazzoni@bootlin.com>,
        <edumazet@google.com>, <kuba@kernel.org>, <pabeni@redhat.com>,
        <Lars.Povlsen@microchip.com>, <Steen.Hegelund@microchip.com>,
        <UNGLinuxDriver@microchip.com>, <joe@perches.com>,
        <linux@armlinux.org.uk>, <Horatiu.Vultur@microchip.com>,
        <Julia.Lawall@inria.fr>, <vladimir.oltean@nxp.com>,
        <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH net-next v4 2/6] net: dcb: add new apptrust attribute
Thread-Topic: [PATCH net-next v4 2/6] net: dcb: add new apptrust attribute
Thread-Index: AQHY6rNmzkvI/HYxK0+8z78mmLSQGK4ocgOAgAAI3QA=
Date:   Mon, 31 Oct 2022 12:45:55 +0000
Message-ID: <Y1/F5n+geZHAitoW@DEN-LT-70577>
References: <20221028100320.786984-1-daniel.machon@microchip.com>
 <20221028100320.786984-3-daniel.machon@microchip.com>
 <87k04gw54m.fsf@nvidia.com>
In-Reply-To: <87k04gw54m.fsf@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=microchip.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO6PR11MB5569:EE_|SJ0PR11MB6623:EE_
x-ms-office365-filtering-correlation-id: e48fba67-2aa1-44ba-df3d-08dabb3dda73
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UiZZTvAnqEgsNgEeAL52kdSaK5b3QByy/B1Cdhk1KCUGK2/zIia/0o2OOguP8tPRUgdV0fh7/3GNDhlFJ0eGYIT1V/GWBVFQtRZkxNwgUaeeqB7FnLB30KJGhnWWthw4z/r8BfbIMi52pW2KvZXQ8MkS1WMJKcir60Y4DFdAndskgUAV8p7KWHtMOBXymyqrn+AwWfHFs1DURk3VlAvkj6cnLU8EK4BBxoBIXcgp6llglaqkMI918UG3nW0yUgk59M2xlzgKCTv6oR44n9QXRViWsRAL8CpUmuj5pQQyTZ04lKOYnd2/immGif1NORFOC5quvoHjoDDH9sMipSlRBlVsjG/6/N3nBNOM1RcPehsorqSOiOrLlymaSzvRhi9II9omx8vaX/jxOyFqqYg8K4XbKUPsHjnEyFdEHBchvb4lk3B0OpZK9Wp/axfEsKPSqwGkQSuQebEMyjDrNnzNcnX57Uky/vuroDkc8gDYz5H6JiPVlmxDn60qR9AeCjQhq1PxmFjPM/oX3wE1sFtKNHZtPllel5L74PYK/zIoWcyaoZOosbXikI8VXljVoUv+PU+abr+ET3A5GkyrDe0dN82R1AwwztHf7rBP2GLIxjTLto2kEGfKXQOWqWc+SjSBE+JWSOkzWVtW9cD9PP/hQeGT/kmfaRQ7DVvW34jloA2E5p4nmGetFSpBjRv8heqApIC01/sNv065Bm0+8XIyXn4lDySGaqpEah7Ws/qVx0Fe0sQIjk1qSWW4NlEUECViJNULglDd38L7FxVWgUANYg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR11MB5569.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(7916004)(136003)(346002)(376002)(39860400002)(396003)(366004)(451199015)(38070700005)(186003)(33716001)(8676002)(64756008)(4326008)(6506007)(66556008)(76116006)(66946007)(66476007)(66446008)(6916009)(316002)(54906003)(91956017)(8936002)(5660300002)(9686003)(86362001)(41300700001)(26005)(6512007)(7416002)(6486002)(71200400001)(38100700002)(2906002)(122000001)(478600001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?OOfiERTH0uR/EFOUlOMGpgrOU7Q86c5fN+CmdOJr81oSopWjQhZAnyp8mdLb?=
 =?us-ascii?Q?aYuFU0JEPhBX5FrBN3DU9IWBuaC2rxgjpKDtiz7gjbNRkU9xiZdhkFhIVnZc?=
 =?us-ascii?Q?US8BlTSC7p8+K1ew5ynlciVkrq4LrsT89We4tfuyDMaizg5Mc7vhWB7FvtwC?=
 =?us-ascii?Q?m0PSfaoi/UUoZTwE4CbQyXAD/NHchRQWuYjbJRNC6c9/0ftzCdb3RJBshUeo?=
 =?us-ascii?Q?c+f7ca4Nyuzpx/yxRXdVaXcD3Un78M5DCv4iS1uqh5BElc5EUyNjW0aqGqVH?=
 =?us-ascii?Q?27Ey8aQU9e5io3Be/5i5tqQlhwI2PbIoSvzd7AuqGqBWN5cADz51m98/xm77?=
 =?us-ascii?Q?tTmg3l7giK16vrGU0eJ2Hy6DoQnkpNVCSkEcZGODEJ7nMk5n9fJKaA6531eV?=
 =?us-ascii?Q?I5mBCit1glGQij+3qN9OtW/s2uC3emTp+4Xatbn09xrdZYt7FMbSrtrV67Ar?=
 =?us-ascii?Q?gP5/QcRVm79TIa6CwuGpEye4i5/+AVdKYuwP9brzY/mrrkuji4tPkvtCDghs?=
 =?us-ascii?Q?Yejo1y6kckMgk0WRCYWdJkPeyVoAqdz/JoZRLp8G+Cm6QqCbrJtiZxhmtTBf?=
 =?us-ascii?Q?WWBd70t5W0jM693Lp6PbSwLrP565lt+jfqad7KhW2DdY80u7X2B7ne5Mj/E8?=
 =?us-ascii?Q?PnSycQjKOdVBCRVWmBb+n3zrkUvtnm3VWjEB2kX/nDENQ8H2LmrDZZtWSQOJ?=
 =?us-ascii?Q?i35xBrYROvs+ki1BOnyZNU1Stv80u6gAwjPYU43EOvOQT0YCA9w8tS8773ku?=
 =?us-ascii?Q?ndlCuINtKS1EBgkchUaQW8aUpM9e23tImO2PHAopcWTVzWHiLvFGIyoIDa8Z?=
 =?us-ascii?Q?9l1Pqu8dXVdbbMcV59YhelnS+vCEsmJczOg9RlhSgjkmvJHBIeeGGShxJ3tc?=
 =?us-ascii?Q?bpLHEjdDS4CXamnDYKyoRtWmeptnus6zVUIbNpi0HHAAtxL+0BHaLmCFCfCK?=
 =?us-ascii?Q?q43BfRZ9RMkg8yDL0Gfvbuh8kyIptduAgemrVvj4fVN7Yy9yJ0dhm629PzP8?=
 =?us-ascii?Q?g4M4yh85mG/iTVhjamsUolt2xenNF5Q68Dv4/6QfNetsyXmBqQskx4GKgVX4?=
 =?us-ascii?Q?6pRsaIe+dEin7nAoWv1prbVgNchTqL9z4pp4MXoNl92XYiHTgOYTUNls3QEt?=
 =?us-ascii?Q?yruXCv06IIyfVworgJwOQ8eCNl1OQuMzGaim0LI0iG8h2s1u+n0cg82bf4qW?=
 =?us-ascii?Q?Tcne0IEgAEwIa1tc3iY5K9jE6+JS980prNyAinttmPqVH9znIANU9oR2B/xV?=
 =?us-ascii?Q?tS6vwNGXzgtYIGnGl57j7ieI4tjmsdJ0c2xCX10sEF3g9eANCa9BG4fUX+/c?=
 =?us-ascii?Q?IvqMjaZcTatW285fMiu7llQzUVAc9mDihVQ5p2E9oUnD43lfK5CqcCtJ9vEI?=
 =?us-ascii?Q?EE3Q3ARo5YNcNkeRcaQyxNWdeqsJYnPAgx6rAobwmvW/lcc7HjtaSL7kaNha?=
 =?us-ascii?Q?r0zvvUiUxnqzRrbs1so5tLJpi1thqTUmTeAyxYmEs66kj5U6PP59viuOul0F?=
 =?us-ascii?Q?siWOAlK9LYQoHTAuuTfZIdZmEoaman6tUIF4coIm16dFtkvtQjU3GwoMzaqg?=
 =?us-ascii?Q?MqKFoRoxiDUcW2Aam/goiREugFasWOQ4BgdNNsrGLX2TYaPVZ2Z6tJd1btE3?=
 =?us-ascii?Q?g4mZC9miMjYf7EF+VqcuIO0=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <257F66476E87E74794A9699F53B9408C@namprd11.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO6PR11MB5569.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e48fba67-2aa1-44ba-df3d-08dabb3dda73
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Oct 2022 12:45:55.8616
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FQHfvLoyybWqBvVXNjK6Ka/e7BjxD1pgP2bUxfYy0GujFKZpD2LCFQxneRHghqEzwzrwfkI9c2Wt2kq2k5T/v/ue/8DUvhvAq/GWCef+VaE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR11MB6623
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +     if (ieee[DCB_ATTR_DCB_APP_TRUST_TABLE]) {
> > +             u8 selectors[IEEE_8021QAZ_APP_SEL_MAX + 1] =3D {0};
> > +             struct nlattr *attr;
> > +             int nselectors =3D 0;
> > +             u8 selector;
> > +             int rem, i;
> > +
> > +             if (!ops->dcbnl_setapptrust) {
> > +                     err =3D -EOPNOTSUPP;
> > +                     goto err;
> > +             }
> > +
> > +             nla_for_each_nested(attr, ieee[DCB_ATTR_DCB_APP_TRUST_TAB=
LE],
> > +                                 rem) {
> > +                     if (nla_type(attr) !=3D DCB_ATTR_DCB_APP_TRUST ||
> > +                         nla_len(attr) !=3D 1 ||
> > +                         nselectors >=3D sizeof(selectors)) {
> > +                             err =3D -EINVAL;
> > +                             goto err;
> > +                     }
> > +
> > +                     selector =3D nla_get_u8(attr);
> > +                     switch (selector) {
> > +                     case IEEE_8021QAZ_APP_SEL_ETHERTYPE:
> > +                     case IEEE_8021QAZ_APP_SEL_STREAM:
> > +                     case IEEE_8021QAZ_APP_SEL_DGRAM:
> > +                     case IEEE_8021QAZ_APP_SEL_ANY:
> > +                     case IEEE_8021QAZ_APP_SEL_DSCP:
> > +                     case DCB_APP_SEL_PCP:
>=20
> This assumes that the range of DCB attributes will never overlap with
> the range of IEEE attributes. Wasn't the original reason for introducing
> the DCB nest to not have to make this assumption?
>=20
> I.e. now that we split DCB and IEEE attributes in the APP_TABLE
> attribute, shouldn't it be done here as well?

Hmm, doesn't hurt to do strict checking here as well. We can even get rid
of the DCB_ATTR_DCB_APP_TRUST attr and just pass DCB_ATTR_DCB_APP and
DCB_ATTR_IEEE_APP? Then use the same functions to do the checking.

/ Daniel=
