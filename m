Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89C4960FA9B
	for <lists+netdev@lfdr.de>; Thu, 27 Oct 2022 16:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235277AbiJ0Olm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Oct 2022 10:41:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234425AbiJ0Oll (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Oct 2022 10:41:41 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817EA17FD72;
        Thu, 27 Oct 2022 07:41:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666881700; x=1698417700;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iBasXxM1v1UVYuhdBKRjQgYIsZjfe89UwTAw/JzvpP0=;
  b=N+WIg6mdRI1Os+v31DErxS6L4B/sJcVTa0Pg04zg0N+29dcAq9XqTM+U
   iU+8glxoOoA2alS6v13+84Fb7iKEKPvje3BP3BO63XFqw0iSgwuiEc5DX
   uYO7JbcO1mVEi2Xfelj8W9uUs1veCtnd81exrE9WuQUB27nTNs3YA9AsJ
   YMVg6EYXTt5IfUUg4/sg+Toe6rwbup/rqzYXRI2jRynkNcieIJ/T6W495
   WX2GQJwf0ugkCo8lvKC0nHEWR5Dk2bzc1tEr8Nl5a3/zgsivsBboivkMN
   xUTJ0LRe8dsyFCEx6mPFdwZq3nqJI0320ok6YM1/EoYpvPpsye2/bQc4C
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="287957116"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="287957116"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Oct 2022 07:41:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10512"; a="737709180"
X-IronPort-AV: E=Sophos;i="5.95,217,1661842800"; 
   d="scan'208";a="737709180"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga002.fm.intel.com with ESMTP; 27 Oct 2022 07:41:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:41:36 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 27 Oct 2022 07:41:35 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 27 Oct 2022 07:41:35 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.105)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 27 Oct 2022 07:41:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UTV0R7vC0RaavCJw+0mTAiF7wPYMSe7Kx5woROJw2zi2HZ3WCZa3zAmBPwFVaBMm/vlsua7qOiDejgBKTllgkciTkld4AESQ0SR0Ctv6OKUly/Yv5dLMFTO2ORSFPPGERe+/VFzAt2gvnvUWZJ5+6W9Sw+RpnznNz8k16NK7fGclHUFQpfvvfjGkntgmKlds6DUyTbrOt9sWjq2KmaGedpwbLgD+mu/4ohLDOYcsFi/21ES5CNiI2M+D8YR5vmDmRxxMYUIncPa8q+GhIrJnugyysF6K2wVpCjkz3Uowlbr6t/dekSc6mj1BNfGCFaFk2xdI12q49ieyzh1Dg6Se8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/de3hYiMaX/glLz8zfE86vVqGZewdXLixSXbuibguj4=;
 b=NEiYuDimmYJx0WJNdgLwW8Pc5ijbFVGKiy8DMvnrfESHrJkfIH5Ee3NtKsJlbKktoLnUkLEmkQzlHcFCnVyOR1w5OZ0Bksruvyt1ZzlyP8iabAyuc6dbuRqjCTv5OUn82EgtC9WgKA7rI52hiF8RIReCo+p0z5ueOvXCsXH9zIa2NknIcFsMDyI5yW/aqCKW85dP/X3hQ7t2HZw04DJuf2sJWJvqYOolsvY09M51uNb/sEQUu2ogDTQMFofeyAhv9kmy86jXr5/LZcISG7eYw7vbFyM1MEAn4u8zH0peHzkXwhmX0mywykOvILYXgJJ1vTU0sYvlwzqDTL5sxpzOtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by SA1PR11MB6821.namprd11.prod.outlook.com (2603:10b6:806:29d::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5769.14; Thu, 27 Oct
 2022 14:41:34 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::888:2df7:7c31:e1e5]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::888:2df7:7c31:e1e5%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 14:41:34 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Akihiko Odaki <akihiko.odaki@daynix.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Yuri Benditovich" <yuri.benditovich@daynix.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Yan Vugenfirer <yan@daynix.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: RE: [Intel-wired-lan] [PATCH] e1000e: Fix TX dispatch condition
Thread-Topic: [Intel-wired-lan] [PATCH] e1000e: Fix TX dispatch condition
Thread-Index: AQHY4i/wwnBgA5Ygw0OeRm02KRN3h64iX+ew
Date:   Thu, 27 Oct 2022 14:41:33 +0000
Message-ID: <BYAPR11MB3367A2CB5BE0D529EED85EC6FC339@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20221013050044.11862-1-akihiko.odaki@daynix.com>
In-Reply-To: <20221013050044.11862-1-akihiko.odaki@daynix.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: BYAPR11MB3367:EE_|SA1PR11MB6821:EE_
x-ms-office365-filtering-correlation-id: 44b9700e-6401-4023-acb8-08dab8295851
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 9+FoaoM1I2BqkyuZkr8OHgLwh2b6M/Iatrxru6mTJiHfMdDq1ZnUeUuS/NQwVdP71avVNI3grS/BHJeTe1gCti2QOsQhfnwm7mY0kYiwZEPzVFEANMj+dekSDxjeOBn2r2QlAhv4KOihAdu+uWH59gjQ+uMlWP1aSai/ONayRfWPssgT4VKmmGfs83+U02+PCTGdlPvt9yaRPE8y9eetQbUSIanD/biISRPxARvUCirz+B1oGANZ//euQZgV05GmA2JqKA3BRBSWL2W4MNfmoJO8VDhzu7wBQ2tfsnTeFnDnEpF9gDjT/LmI+VvR64jcd0+ncpjMI7nAeTnl74H9kl3TMfDX7fHhhryct2HVpEg0xdq93XZRmPTnr1cQLrLyOftpZzvss5+KtkvUcWNcJuExYSeRnX+Bx5dJHjwyqluyTiecd6e6k5tMEFf4uG/3rkbIv5KIL37iuuJ7d+H0iFIIb2gTqm7WoH23G9oBweLIjOgfr8vvkeronqPlcTrqStYVM8EnETI6mBaFLtivXwx7UVbSCAizcmXgu9S5RYky8nfxZhoOnTd3gbZmqQdC9eC39PLApGGSNGBYEJ63aZMsLm1Zo4BFCe6TPtjoX3AAnhv+rMzLoiDH4pZgVLBvpWpm2Kkdi8E4kX3vn9udZVNUaASyyF7bqn3mzDWdqHN7rxzL3BGY6NT+jqKdji367f83q1WxbckWIb4e90fJGqrbE8exkO+dUFmoXS9mnFbp3LxHkffvTySb1lxhwctQtiY5s/Gq9dfzes03sE5KdA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(396003)(39860400002)(366004)(136003)(376002)(346002)(451199015)(122000001)(186003)(41300700001)(38100700002)(9686003)(64756008)(38070700005)(26005)(66446008)(66946007)(66556008)(8676002)(82960400001)(76116006)(4326008)(316002)(7416002)(2906002)(66476007)(5660300002)(55016003)(86362001)(54906003)(6916009)(8936002)(478600001)(52536014)(33656002)(71200400001)(83380400001)(6506007)(7696005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?hnK71U1pYEw2Y66+nYmwwHGe3nth3wr7/YfIaqDm3FxKysPml77naj2v+ZGR?=
 =?us-ascii?Q?Hqo8yUa0RL8wV3LER0KoMRj7leoIHGBaygzudZlaDBbelIoeJ9ItqNRCcnf5?=
 =?us-ascii?Q?nKXpcCkOlgbLQHB8MjUFlc+ttdQJ26U3QXYNLA6mOFyMOF2F+sASCPGVEKOC?=
 =?us-ascii?Q?IzZQdCeNb2xYIMoaY7hez7Hj5tN5GMPXl3jU4sCedRmrn+wRlMo1jpPOq/Cm?=
 =?us-ascii?Q?zKgO1rTULCF1Wq6gcVx78AtJEqauZb7AyeY8cFemBkmS2wqPsDx3Hml5yh8S?=
 =?us-ascii?Q?kal+XCkdTKIWROw1D36n8eUkJ//hz1/EaFh+EFTMSsx9HEAJH4yuyH/8JpuE?=
 =?us-ascii?Q?NtTLemQSBhVrrisAzHuhPT2qwZ2wARovc7KJ+dS65oT8wzuTeZWq5A/vXY5m?=
 =?us-ascii?Q?+Kz3WG9ADrNuahFVuUWdZI/e4CNAKPpeZZQYkkccFad4pZT1t8AUzxw3YFXW?=
 =?us-ascii?Q?KB8bGgspuhnACkPeKqIxz4ao3ranuCbppzspJFRw07RdmTk3YcXDPfvCQbBa?=
 =?us-ascii?Q?I871eqM+gpxr7vw51m1VlNrcLLkkonnflUDv1XM8xiC4B7gFvGfrgzQSNADM?=
 =?us-ascii?Q?FubXZGoeZF37fBd+YotVDTOWqUhw9lYaoxF316tV4MGUNGS3diZe+eDFmXPi?=
 =?us-ascii?Q?7rxrHRJm3BHXXzwR0pb6ES71Zyr50O9wbgdj2gEA5DfeaOu+c5dq8v0MRDvI?=
 =?us-ascii?Q?lpmxGBWtalqeVRx671D+emecJMpMmv6teL25lCZzqxLW/yAGVCHJJafRdeoK?=
 =?us-ascii?Q?5n2NjPDWXXDjwk9ajW3mtqN+jg9G62WSB24aXYO/aWPaeODYclh+K1Mfo3sP?=
 =?us-ascii?Q?pUKqIsJwEQihqznNfQ0vdszUBLzbi/Q4cze+k4zQTT1fCzb9tLuqTPIc8m3A?=
 =?us-ascii?Q?xjOHqnEfOySkQMi7x1tlXt8lzcq4vL9kJdMJoGkOneyUr4btL/KZRkTbDpUu?=
 =?us-ascii?Q?4D6HPyoAdbrGGD02dKOHfM0Ihw2BlSG/54DpmkXOq6dRS+fKB0UJhG/BKxF1?=
 =?us-ascii?Q?BUZZ0jyRdJ2PlzoJQWaFhYCcetbj9Z1L+KcFK1pjtGnqP3Qau78IY2hozR+y?=
 =?us-ascii?Q?OxZQ0uKWbV6b5TrrU5P8HC4QYXatKxz35CxcaKgToYcoLJzlpYgFMXsJsXhX?=
 =?us-ascii?Q?VtOXXQQ460LLpy7lPzo87uPUX2PB9iCmUlS6ANyhQ5WK7vR6emlkS36BS2Ci?=
 =?us-ascii?Q?oBqilb/LulYDmhrwsDykp/fKx9GebqAf4FxrEOzDCnDlEtdx34JotwxWZz5P?=
 =?us-ascii?Q?/3f+WOxDIxsgyAVVNJ4a0GyDi1i4E5q22C6ql4rWXrBG97KZzZn1S2IKNdtC?=
 =?us-ascii?Q?tM6c3eQvcI8Paue2RXnDiqBrHra/7d4HsQ4E8ZHeMnd5hE9yCRNIocNkQwv9?=
 =?us-ascii?Q?JRYQgbm+mJh4H6q8MShRopCwkVWGkwXULm3ZlOZNBFcJPmlJ5vUoPWmTpDaL?=
 =?us-ascii?Q?p6QN/U64piukVRkgsPH9np/E/MTC+ifPk7y3Fq2X5PFpN35oqs02AyheKapZ?=
 =?us-ascii?Q?y8UG+Wxw1JBuyRFVr65st/m5zd3Rrxn/WtVPUGwUi4Y1Z7L+U4epybdytkCt?=
 =?us-ascii?Q?bE5MUUNmMb79LLKfY2XnKndT43kxPz0WRa9QOwwP?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 44b9700e-6401-4023-acb8-08dab8295851
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Oct 2022 14:41:34.0639
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Wf59LtLHkfjxPwASBYN6QVe46VPPwLBCSwq5XWAP7VmH9aNnDWro6sBDZtlz6b6cMOeGGaIK+GBoP5O2Q96Zfg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR11MB6821
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Akihiko Odaki
> Sent: Thursday, October 13, 2022 10:31 AM
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; Yuri Benditovic=
h
> <yuri.benditovich@daynix.com>; Eric Dumazet <edumazet@google.com>;
> Jakub Kicinski <kuba@kernel.org>; Yan Vugenfirer <yan@daynix.com>; intel-
> wired-lan@lists.osuosl.org; Paolo Abeni <pabeni@redhat.com>; David S.
> Miller <davem@davemloft.net>
> Subject: [Intel-wired-lan] [PATCH] e1000e: Fix TX dispatch condition
>=20
> e1000_xmit_frame is expected to stop the queue and dispatch frames to
> hardware if there is not sufficient space for the next frame in the buffe=
r, but
> sometimes it failed to do so because the estimated maxmium size of frame
> was wrong. As the consequence, the later invocation of e1000_xmit_frame
> failed with NETDEV_TX_BUSY, and the frame in the buffer remained forever,
> resulting in a watchdog failure.
>=20
> This change fixes the estimated size by making it match with the conditio=
n for
> NETDEV_TX_BUSY. Apparently, the old estimation failed to account for the
> following lines which determines the space requirement for not causing
> NETDEV_TX_BUSY:
> >	/* reserve a descriptor for the offload context */
> >	if ((mss) || (skb->ip_summed =3D=3D CHECKSUM_PARTIAL))
> >		count++;
> >	count++;
> >
> >	count +=3D DIV_ROUND_UP(len, adapter->tx_fifo_limit);
>=20
> This issue was found with http-stress02 test included in Linux Test Proje=
ct
> 20220930.
>=20
> Signed-off-by: Akihiko Odaki <akihiko.odaki@daynix.com>
> ---
>  drivers/net/ethernet/intel/e1000e/netdev.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
