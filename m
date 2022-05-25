Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0F45335A0
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 05:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236946AbiEYDOi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 May 2022 23:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiEYDOg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 May 2022 23:14:36 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCE160D8E;
        Tue, 24 May 2022 20:14:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653448473; x=1684984473;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3xyEZcow9RFFqFRgNy6DiHmjQoc7yyZwWEZGXBSAVAg=;
  b=ezB9jGBIktMNWAwpE2IA8kyUWqiyo8oyoqLkUV+e5ors4AETI2Bo74rn
   l/43im8/QfJLbFtkqU4oXOZm6O4wWz7mGYeUDPBD480WOj8M0jE9p5eUG
   hJw1cgA/4D5jQdQyL0fsHxVVn9wJNMMxRWjWrlOfvLT9vatN2cAhdI/o2
   t7zOLqzkkJUqiXxd5D3hV/rfmcmqkD1W+Ps6odOfun4URDuvOPErIrCxF
   wka51BM2aUsgju9IFlZo+sKSSLtiFJn56GvL63kR5wWr7KBb1+VVXAi8f
   ASQ/Po8zboa/PPZWaTfIyP451PiadF7YTsPYDcOl80JdFddUuLjgTxwFd
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10357"; a="360094438"
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="360094438"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2022 20:14:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,250,1647327600"; 
   d="scan'208";a="901308010"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga005.fm.intel.com with ESMTP; 24 May 2022 20:14:32 -0700
Received: from orsmsx611.amr.corp.intel.com (10.22.229.24) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 20:14:31 -0700
Received: from orsmsx607.amr.corp.intel.com (10.22.229.20) by
 ORSMSX611.amr.corp.intel.com (10.22.229.24) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Tue, 24 May 2022 20:14:31 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx607.amr.corp.intel.com (10.22.229.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Tue, 24 May 2022 20:14:31 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Tue, 24 May 2022 20:14:31 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a6hmeqpjkXSfrPDYAjBf1JUhnIa42gDjV+phT3LrDxPvkf6myoYRj266OZaw4+pd5lPef8SAS0KRzXVWRHNBMu3vrXXBixkHigK7VfOLiLB3p+j6H3R3pzvKhwyDo6yxU0ZIuJEHOiAO6r8T0K5fDtsF28EgurwxyQdeyrBtmLwf2VjwdUKnVEI4x3I0fzB8S9Vl/5RZSToifc9LBOZ4RX4wVKw7OqWN3h3PKTnFuBTi36IyIZwQps4TBxJeSPU2UvAoNRZK10HNPBRIS9ijhld29L5yj+5uAaiRxApppf+ks+LMCUhaxXG34ttB4I62nbVdW45SfG/Ue5KfsIqqjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FiWN9OwhpNf10N6K3ndLm4DNBN9juMWbQM/VCctrqvs=;
 b=cGS1hpx1X7sStFsTmqDbXsa539jAfjydtlbfmYd3/X3ZPctjHFyN/xV6SxiHRswkGgZqft1Cx9aTBayd7jToeH/8KmPqe1xFB02KCInTCeJ8jTYlfzxBPVqmKGvyCAyvII8xLVsuqn+Ntx79iWGE+/yW6aGfIVgav1QnPo1JXpsD7xl+OCE2NnDR+qnN25sqH88+fXKOwk9kt+uDNYIO2FqWIWBQr17cGMpNegWs15A3mfindOUF2yR2ZNp2CzmpPduZ0l3Q54OmfGALVi22Cw5VzkZQeVh15GQEertBdIFoM/rZ5hgZbzVYn9NNW26TxWQCDrTGM3L3bYn7TRjk9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by DM6PR11MB4283.namprd11.prod.outlook.com (2603:10b6:5:206::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Wed, 25 May
 2022 03:14:29 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::829:3da:fb91:c8e7%6]) with mapi id 15.20.5293.013; Wed, 25 May 2022
 03:14:29 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Eric Dumazet" <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
CC:     "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] ice: Use correct order for the
 parameters of devm_kcalloc()
Thread-Topic: [Intel-wired-lan] [PATCH] ice: Use correct order for the
 parameters of devm_kcalloc()
Thread-Index: AQHYbOAT1oZDZfZmq0+fVfjHECezkq0u8TXA
Date:   Wed, 25 May 2022 03:14:29 +0000
Message-ID: <BYAPR11MB3367EA050DB996F600CF46C9FCD69@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <627df513c3acf65f9aa5f43ca2bf7826a73c0c7b.1653116222.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <627df513c3acf65f9aa5f43ca2bf7826a73c0c7b.1653116222.git.christophe.jaillet@wanadoo.fr>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14f7a909-5e1c-41e2-f254-08da3dfcae52
x-ms-traffictypediagnostic: DM6PR11MB4283:EE_
x-microsoft-antispam-prvs: <DM6PR11MB4283098B3E9F4291A160636BFCD69@DM6PR11MB4283.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: HLW/2Xp813NaK/vwt2l9nm9LnJIEfCE+vcwQiPdIcSQ7AVLsZ6xAZg+9+MvTf5w1bTibVWm0vHKc53sty2WiJGxIcb0vNrgz5K9DMIyXyyFDQwQYbGWM2oLpEK7+o3PPOx/DejbogCl71kC94mMOnMEDf4nHh+8Fzeshh4++xD7DI6NzljejG+vw+EUZRDpYJnVKJvkH8bZUWCUIgFYanWThuRmVHGRLVa+xGe6DGSMo384+rlEZnGn0ldzWHJoOIkvjzW3cXitiR3lhsImoGWGOvmDPHHyGSfWJz5Oa1D1MLrFK6JCaFg8tjb1djRGduW9Gb6Dt3WEG+9UXPvB7NUq6eJAHDySPY3jTPmkTUQPLqN7QxM9/9cWQGRSUShfeakYuUIbyoYm+nPqFQyPgWafmYq7Gon8jCiVsavpVYfkrpV7sGdH0dDm/hJGjSaZwH8ojXR6Rj2dCTo2CHse1WtWd1rSQMeh8tPkQWViF/8z3/SB+pdY6IhrkVJgeJbaTfk7e4tYnUo+iPFJW1rLQoY5W62SAJpzM8u2vvObd3WwqLvq6l64QMhJ7ODQtUoJSDKR9zDlIGFG7eYBbSk4CSOWEkX/jyJ12ln3Qs2jwzVg/h9cbpZ4uXncMyfVu1Z+KnSLMppvx0exCsqNQK7Ps5HAC0XEQdiY4/x3B7x1IkBz8EcLtCkIs6VjizQLDwbxm7lgcy9rSuwnXp2ixj9gMBA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(5660300002)(64756008)(55016003)(122000001)(186003)(8936002)(52536014)(76116006)(71200400001)(8676002)(66946007)(66446008)(4326008)(66476007)(110136005)(316002)(54906003)(86362001)(7696005)(6506007)(26005)(508600001)(66556008)(9686003)(38100700002)(53546011)(2906002)(38070700005)(83380400001)(82960400001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?Wc8pzagId506+pOAruVxQ2bYVdeXu91Ivjut42E1PIOSedwqslwDYX6tBZhL?=
 =?us-ascii?Q?fblAdKvAQ/2BaxDfkifY8VxpCdBvCSl3M3CTxKcjEqyenLFPwiC6gSmuas26?=
 =?us-ascii?Q?NN1OQw1e88D72MM+vZokaAhtjwazh5hy93MbWPkm70ilgcn6JXEJgKwntlux?=
 =?us-ascii?Q?Ndtfkj83S2gpR6+oOmymaYavAJez4QfpIDkqYUGRzVG/UQBBsdiIXyy7d5rP?=
 =?us-ascii?Q?ZIRehbdSVeD4AraD4XV2riFPQnTCF4d9lPPjIJ6S/eMZeh7Ar99MWbMrm2yr?=
 =?us-ascii?Q?QiSxgm2K+L/WgpPjjmultX6SpzFi7o7oD3d66cmK4Vwjy957fwajQNQaej4m?=
 =?us-ascii?Q?sl2nB4R9f2cbFFexkBRpAj+nMBE1zePSnXVSX/KtmDIl4Qbeya6/qZShRbHA?=
 =?us-ascii?Q?xk1DMVqYEDRSH4+J0+KPtTPK2fDhS0c6OjduCyiJs6zzx0k25NPf9ITHwceK?=
 =?us-ascii?Q?NTzKOFa7P4k8SQKyKhiOM3u8CXyzMO3wqvdyQ6j73XZPGdLtUdC3ej2N4CEt?=
 =?us-ascii?Q?ulXWQvV8BYXJ1uT0YYohereIkuvJqGRET75Cgt5U9r7ocUpL1XTlUxV0G+6W?=
 =?us-ascii?Q?3Ptj2TlTRybXfDhAp7Pc0cRwcytnBIRZCpZmhHokhDuNQjOjyUaxCPcGhxn9?=
 =?us-ascii?Q?wd1oXjHUmqWJ0E5KA0HnVrw3rTUIabgarXljp+zAafwFOqIZDSzVKTiYIwV7?=
 =?us-ascii?Q?fLYGdPOfI7FmEAfd4wVJIZH67duAh8FhytvntK0V/UElwZa+m3QjChIIiLpN?=
 =?us-ascii?Q?PlN50nE3HFCIW4jKmZnP5vP56oP2ClmnwJ3VXhfAekFpKi/3apFSWxOTTFlz?=
 =?us-ascii?Q?sl8YcwRpXYl7LlgVEaQ0vTdurKy1rDsZDr/ktOuv6hB2zAichzNmDZADUyxN?=
 =?us-ascii?Q?F70jNDk+6wtbSY9Ibv75c32JZ+qloGFwqSbywADmpnEYEJQE5B3RQoMHgLLI?=
 =?us-ascii?Q?O4BcnEXC7tyrJjRVpytoiKNk6enqn0EOq09gsO/LJgqT2m4s50qbMlRJ6AK+?=
 =?us-ascii?Q?aXzDIkLacez12KL4qaINtOfTrkFm/VZWQAI2lc0WdnQYBgLIE0hq2o1q7iyQ?=
 =?us-ascii?Q?xO15YFB0NXqHFUn2uQfbe3ESIF2QIx8tg9h9iVOAxj58QMldyNjeWpy34Soh?=
 =?us-ascii?Q?1GYlFRDltxWyH+mynbqC6NPw9IYOoBYiZdhiqWdNPfWs66Nn3hA7n6kAebDD?=
 =?us-ascii?Q?P+WtdzLzsnqkY+B+353eFZvV2E5f+q9B3kM3Xy1zoQ+qnsJhSMMPDIb60fG9?=
 =?us-ascii?Q?vXLS18whAF+Fpay6fggOR74Su5lLwgeWzrOKkXLkOBvLAcNCB5Y2/9Mx2fbz?=
 =?us-ascii?Q?uXsApLYo0T85EzDUZSfYunTm3YcjW5/lgEN3VhZ4hUnttFYBuDdYPc1fGUI2?=
 =?us-ascii?Q?SxtKg+4VGYJNJe7ijH61BdD/MxJMJkGb+KozWDQKhxNIwqGclXRDbij5YWEx?=
 =?us-ascii?Q?lBPczuo2t1T3WwlFtyh/Of1rz69qvS25+KfuZf5JCTum2GzdHx1BR1okHqlK?=
 =?us-ascii?Q?18hN2gUPOVIDcXKX/2pMO0OOGjcEx0DgwCPafHArggjwafeZGi/i7IBhPnhI?=
 =?us-ascii?Q?4ZSCiUQCMdLGziSHx8tT89PaiDXSWMoyZg0dYfBMa3lK7n/Es+3BqHVkKdaP?=
 =?us-ascii?Q?2lER8d7txqCvhCEfUFqkjw3Gzn27qW2At+K1vn2DYV6lOgjKgdoQ+5XYl1uS?=
 =?us-ascii?Q?b2paq1JcuG2+XnwnGyjmPj8f08S4cMPGFVDR3qL4LAqSB7y5w55WMNrkcWnv?=
 =?us-ascii?Q?QYMnesBG6w=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14f7a909-5e1c-41e2-f254-08da3dfcae52
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 May 2022 03:14:29.1602
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 6FP0unXAVkedMTjvcUNMmzWXWXqrrA3NA5ZgEu3N3mfwkgPmIh48MDbdS4Ks9dFeR5khoDmOho/0hn/Yfv8p5g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4283
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Christophe JAILLET
> Sent: Saturday, May 21, 2022 12:27 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; David S. Miller <davem@davemloft.net>;
> Eric Dumazet <edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>;
> Paolo Abeni <pabeni@redhat.com>
> Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>; intel-wired-
> lan@lists.osuosl.org; kernel-janitors@vger.kernel.org; linux-
> kernel@vger.kernel.org; netdev@vger.kernel.org
> Subject: [Intel-wired-lan] [PATCH] ice: Use correct order for the paramet=
ers
> of devm_kcalloc()
>=20
> We should have 'n', then 'size', not the opposite.
> This is harmless because the 2 values are just multiplied, but having the
> correct order silence a (unpublished yet) smatch warning.
>=20
> While at it use '*tun_seg' instead '*seg'. The both variable have the sam=
e
> type, so the result is the same, but it lokks more logical.
>=20
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> ---
>  drivers/net/ethernet/intel/ice/ice_ethtool_fdir.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20

Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at Int=
el)
