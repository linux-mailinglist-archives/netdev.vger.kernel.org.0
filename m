Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 846C3632ED0
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 22:30:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229669AbiKUVaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 16:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbiKUVaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 16:30:19 -0500
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3ABB2B62B;
        Mon, 21 Nov 2022 13:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669066217; x=1700602217;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=lmPoNwoL1o7k3jNcgh2Y2bgsi2iiAC8r0t69g2t0UTs=;
  b=guaL52dUpVsz0BgQBa95HdmBfjVOrSQo4izU601914dofb6QvLwjX/E5
   USfD7NmRjlNoEG9fJVXgu9zfkWtpo6igk5BbZ3ZZF9khYhPP/8nvmTA3w
   +VmmW0UJG9acAVO/NNyhmZm8Ldo1EDl453jGdmAAdv0a5vwd+7DIUbk0g
   ksscrJ43fT6346AyS6cukwp2w19iK/ezHxWlka0S5rjO8oVryD4O3kYoC
   psv9J1xd7JJIdGy8VKa0LfvSJvtrfv/D/OJkN9uMrmX+FZRlmP8BxBHb5
   gELz9XVviav2n4FhAzyXURufIx1CMEko61Z/LzeDsp1ncd73e4vZFn+0O
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="377925176"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="377925176"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Nov 2022 13:30:16 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10538"; a="591911180"
X-IronPort-AV: E=Sophos;i="5.96,182,1665471600"; 
   d="scan'208";a="591911180"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga003.jf.intel.com with ESMTP; 21 Nov 2022 13:30:14 -0800
Received: from fmsmsx612.amr.corp.intel.com (10.18.126.92) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 13:30:13 -0800
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx612.amr.corp.intel.com (10.18.126.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 21 Nov 2022 13:30:13 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 21 Nov 2022 13:30:13 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 21 Nov 2022 13:30:13 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YwK7U3q73mKoDaNE3gI1RqMLdKCbUjiVOID5ey/v7bjwGaIVM3ouDdA9yvUFsRc3xxtOdETQD+eHKv3DXvyCcHKvy9hTWuXcxj9TnsfWErJgDLazznHJUJbRi+NXPqc4d5W2af0ikzv74Lu9E2uG9FdRVV8uBrNaMyvv0pAR8uPWKb/JLpvBKD03pL0hDuMJ5bsc0P1juz3Uf38bRLtbZpCXC9nDFNKcN2u48lu47COiuhtab700IoPvGp1NV2bKk7IgdWz79boVRy/tyn7Tv6PtOejzXfUsnSwLs7SyMrUK/GdsZukFtb+gGeQKXZ6MlTxuVI1hVlcPYzSi3stqhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xTpJOmcfS6T7suOUajN8kggVgF65xtMk4RreLrD29Ho=;
 b=dQ7as/LDztAtvUOHF1Ny+Xe2R/vzUQtT1J5ICIMKw3J1M4DKsxdD/S5hJ26a1+8lRaAQDOw8bzPdo/yySeA+GAprMJb08RC2AqTZrSecH8CkfMw4Q5K9UMbIqfEMwsf/Sz45mCx6rDT2RRxBQvcFMHW4Ea8pdXdcSYc2aGeJcChBUbISgk3oig40efT/dIB/0yWYsqO2mVYzNrSHOfEmFqH0NnoqKPRdlH1UZZQQwML/NMo4BxUTBtmtWM7mHghaE023XYeu/ozbVis0BKci3YSDA1mg1bbWhUIzstYenXbw7zclOqCYtOlSSZEw61uOVJ4p4Iq8JPXGsKOaPGjt+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from CO1PR11MB5089.namprd11.prod.outlook.com (2603:10b6:303:9b::16)
 by MW4PR11MB6762.namprd11.prod.outlook.com (2603:10b6:303:20c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 21:30:10 +0000
Received: from CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28]) by CO1PR11MB5089.namprd11.prod.outlook.com
 ([fe80::9e54:f368:48d1:7a28%3]) with mapi id 15.20.5813.017; Mon, 21 Nov 2022
 21:30:10 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Andrew Lunn <andrew@lunn.ch>
CC:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        Maxim Korotkov <korotkov.maxim.s@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Tom Rix <trix@redhat.com>, Marco Bonelli <marco@mebeim.net>,
        Edward Cree <ecree@solarflare.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: RE: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
Thread-Topic: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_id()
Thread-Index: AQHY/X7qeqK51hvWY0SWiEWUHH/t+a5JavoAgAAOygCAAGv28A==
Date:   Mon, 21 Nov 2022 21:30:10 +0000
Message-ID: <CO1PR11MB5089CE1CCC215FF180724D10D60A9@CO1PR11MB5089.namprd11.prod.outlook.com>
References: <20221121075618.15877-1-korotkov.maxim.s@gmail.com>
 <Y3uGyrxeSbajJqpr@lunn.ch>
 <20221121150314.393682-1-alexandr.lobakin@intel.com>
In-Reply-To: <20221121150314.393682-1-alexandr.lobakin@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: CO1PR11MB5089:EE_|MW4PR11MB6762:EE_
x-ms-office365-filtering-correlation-id: ecb7b342-ce39-40d2-0342-08dacc079188
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oTm2bjnFfaPYz5PXvT90ib+V3bY1imaoZN23EuUUEoJBd+waSsJKTEbsBzSM3F76ZOjC1pqicRZdULto2/p0/yOLd5iu+Qxx33wBF5YUlEpDoID3TZ/t8dwM4RGtoMNBypDfg4oEE4eiho6bCTHv6Osc3TK09slcthFpH3Op+MDlVuRBS6eqRByKSDKI+9cxMGwj/FX5lLmn7iaUZS9qwQAwSqk2jWbzc2XwBpTHm9einQqS6MXL5q5W2SqrW+LJzi/CwUMjnHBOjQFSX7xn5Ba5/us0n58tnLCpqb935cHVIOWP5wCSWxduemHpxYMfhKnS5xGh+ckjkF/X9QYUO3jvJbxLlu8ZWqi7Dx79BgT4UNtTpFXU1lgobBAL/lNdyNTPJJTvE8WYpz3BwGyHrtefnPzsGnrMx/XA0NEawIJ4hlAK4YQgO0hGrZM3gwHhufDYfw3X0hRHdO9qa6idBD/8q3j81kymFf8HgX6bnrNrU3S+ykpFx4GEXd5vJ9uq1olGGXEGUEsphSWSQukLhEO1EwwTOWyINBdnEIJ1ZBKCC5p8k2Zq5gTxQRxDq8rmPSMJ2ACdhPrgBZ06xvJhifuBHQYqG0n43rK0BnH7RxspEDe2arr9b2afH7UkINNGpBHwodnb1XJX3zuNqwTwqDZP1BB0krIsA0ru9VLertmO74C9FINz0L0C/eGgfpgknumiu3DsBY5SIg8i9bOKc7EnL92UDUTSHnP8gT1jyPQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR11MB5089.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(136003)(396003)(376002)(451199015)(38070700005)(86362001)(33656002)(7696005)(6506007)(53546011)(82960400001)(38100700002)(122000001)(66556008)(7416002)(8936002)(2906002)(52536014)(83380400001)(41300700001)(55016003)(8676002)(9686003)(26005)(5660300002)(66446008)(316002)(186003)(478600001)(54906003)(71200400001)(66946007)(4326008)(66476007)(76116006)(64756008)(966005)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?s++L/Oerqb+YjUwKji7XsUevPdl12456fivG+lZDy08uV72bWnP+qxwZ7zcB?=
 =?us-ascii?Q?uJiU+ZCB3Rn3dbzxq4DqQJHHSB2t5qSvlzhm4DhMHUWq1SW1HR5z0prr8ylV?=
 =?us-ascii?Q?XNDGSmNw4qVO/IXne6x5T/h4ILj/gIh3FYJq8hYrM2/e5R79PN89YAcwZ93O?=
 =?us-ascii?Q?pzKUdKsfiF8nvZO1GjJjYNMy1UVguinEY0+YEt6qmIMSLmubbZko6kFi/yXo?=
 =?us-ascii?Q?PlEM+RyMT8+V1bO2NyY51c3tNi8H7etvpiruvRMadEikrz01Y+DQmcPOFXLc?=
 =?us-ascii?Q?22BLVXjKb5gL1z4Y4IyXhxhQjXuQK2trwdlDQ+d+Gf0K5sx/ZljfYlP59SHa?=
 =?us-ascii?Q?O/3ITd+y9N2hUiZNdHT+F6gckFQE4TgL8Wz2VkJnezEThzq2M+Rko2At91C2?=
 =?us-ascii?Q?q44+BUAyQCUmvuBzTVyLTObdKW6B8Mtu0YD+u5uJPY/xd4Qqk4iVp1qHnPIa?=
 =?us-ascii?Q?ldJXWYs0PLMi006c3Cdq8aY27gzxKUbT1HSDP2ar7y23aBPM5X2ECxbCvEjw?=
 =?us-ascii?Q?rpj/gL0MxBXltsM9pNNR6uKlnJxwiWx3pBqpXiwGaMZtv+bRUHeDUf/wLt8U?=
 =?us-ascii?Q?WLtgSGpXKH+R3cNVlTw5I6tReD2ys+PYdOH0xTuL+1+CMhYYHj4IKCVuudMA?=
 =?us-ascii?Q?to028f/Y/7yk7ktAP2n8X/q0LQamz2wAOKU18BQJ+pFaI1ZGihCmi9yEdC4X?=
 =?us-ascii?Q?UDs/yxJYyJhwHYvvMREMyvZVSIch7qTsovmMSi2bhL/EESWF6eI6ibA8V+yE?=
 =?us-ascii?Q?WiCVy8YDZRUTUPGP+GjeRHuQbUmgkEcSvwjO8h1A7In3RGorKEi9hr3Saa4E?=
 =?us-ascii?Q?rInQnkQawr0R1qEk2NeGN5kmCk8G4y0IVJZ5nHDcGJsuwnE4bh6DkhnmTK7Q?=
 =?us-ascii?Q?RJIgzvTscLWeD8S9PQWM7Spq8gHI2ZxWcvCXrIIwAoCDMTJiDPj/2aIYou03?=
 =?us-ascii?Q?IuUtD5kbSF9yeGte+5bBXWXL5o+kaf8DJnE4HJa21k3vmMadDIX1jPBFXv8u?=
 =?us-ascii?Q?6R8Xq1gXj0WcUemrnmJteYZJ7ot5kxJuprmAv9+QxcAI5jPadh1iYQ2hilm7?=
 =?us-ascii?Q?untfYjU0q1mPvi2tG4NRe08uae2FUus87XgrnUvxc5v5na7PBccJ12Oe1FG6?=
 =?us-ascii?Q?cp1HlmhGtt85yrAsSTnM7/DTJe/dqZuHj+XcDwCss3jdjC2LU1U0t/0KByK9?=
 =?us-ascii?Q?Loz2stZ86sEYlxqe0U/UUtXCP5Kvuf8etPuPC7uc//OOOzjsT+N6xAsJu3R/?=
 =?us-ascii?Q?RDuO6WbtrrtVg5/4VxOvPVGYWez32SjfKtWOw02s/2GMX+6zzB+zefE4r+VG?=
 =?us-ascii?Q?6xQ3ugNhFSxtk75TlFkqo2TyZ4ETQpPq1uqGVE4VU8ik7fagGWqwyGAaHAZ6?=
 =?us-ascii?Q?73q7Vj0rR8BPK74vvHob3ooGUvvFwQtBmuxc1k9J2aLMXU7lSPjDa9oG75g/?=
 =?us-ascii?Q?AnCf1zTSMZuE9iWKbn+ns+jjmN6BWZZ0ITN2F6d0+VIdTOQM7Tq+JyuQS81H?=
 =?us-ascii?Q?ZNyfAsnNCZT0NwBzHsLqkxNWJm7hV2Kbk734HqIAXARNN7Bf1gvZpDGQNcuw?=
 =?us-ascii?Q?dELnpsktwSTFUu90veikSLx4VPS7l9dmK0/+F7NV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CO1PR11MB5089.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ecb7b342-ce39-40d2-0342-08dacc079188
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Nov 2022 21:30:10.4325
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CjQLc8FGVDQ0L03qn180WDEvCv/aW4ESh2UUU+aaE+i/wP38tMbmVGpdC2fVs6g024ZAr71nPNrZMSew3WXNz3F9cMazYUcAHXdU0ui14Q0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR11MB6762
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
> From: Alexander Lobakin <alexandr.lobakin@intel.com>
> Sent: Monday, November 21, 2022 7:03 AM
> To: Andrew Lunn <andrew@lunn.ch>
> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>; Maxim Korotkov
> <korotkov.maxim.s@gmail.com>; David S. Miller <davem@davemloft.net>; Eric
> Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo
> Abeni <pabeni@redhat.com>; Guangbin Huang
> <huangguangbin2@huawei.com>; Tom Rix <trix@redhat.com>; Marco Bonelli
> <marco@mebeim.net>; Edward Cree <ecree@solarflare.com>;
> netdev@vger.kernel.org; linux-kernel@vger.kernel.org; lvc-
> project@linuxtesting.org
> Subject: Re: [PATCH] ethtool: avoiding integer overflow in ethtool_phys_i=
d()
>=20
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Mon, 21 Nov 2022 15:10:18 +0100
>=20
> > On Mon, Nov 21, 2022 at 10:56:18AM +0300, Maxim Korotkov wrote:
> > > The value of an arithmetic expression "n * id.data" is subject
> > > to possible overflow due to a failure to cast operands to a larger da=
ta
> > > type before performing arithmetic. Added cast of first operand to u64
> > > for avoiding overflow.
> > >
> > > Found by Linux Verification Center (linuxtesting.org) with SVACE.
> > >
> > > Fixes: 2adc6edcaec0 ("ethtool: fix error handling in ethtool_phys_id"=
)
> > > Signed-off-by: Maxim Korotkov <korotkov.maxim.s@gmail.com>
> > > ---
> > >  net/ethtool/ioctl.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/net/ethtool/ioctl.c b/net/ethtool/ioctl.c
> > > index 6a7308de192d..cf87e53c2e74 100644
> > > --- a/net/ethtool/ioctl.c
> > > +++ b/net/ethtool/ioctl.c
> > > @@ -2007,7 +2007,7 @@ static int ethtool_phys_id(struct net_device *d=
ev,
> void __user *useraddr)
> > >  	} else {
> > >  		/* Driver expects to be called at twice the frequency in rc */
> > >  		int n =3D rc * 2, interval =3D HZ / n;
> > > -		u64 count =3D n * id.data, i =3D 0;
> > > +		u64 count =3D (u64)n * id.data, i =3D 0;
> >
> >
> > How about moving the code around a bit, change n to a u64 and drop the
> > cast? Does this look correct?
> >
> > 		int interval =3D HZ / rc / 2;
> > 		u64 n =3D rc * 2;
> > 		u64 count =3D n * id.data;
> >
> > 		i =3D 0;
> >
> > I just don't like casts, they suggest the underlying types are wrong,
> > so should fix that, not add a cast.
>=20
> This particular one is absolutely fine. When you want to multiply
> u32 by u32, you always need a cast, otherwise the result will be
> truncated. mul_u32_u32() does it the very same way[0].
>=20

Why not just use mul_u32_u32 then?

Thanks,
Jake

> >
> > 	Andrew
> >
>=20
> [0] https://elixir.bootlin.com/linux/v6.1-
> rc6/source/include/linux/math64.h#L153
>=20
> Thanks,
> Olek
