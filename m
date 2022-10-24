Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C75609E59
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 11:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229588AbiJXJ4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 05:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbiJXJ4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 05:56:18 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FB594DB64
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 02:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1666605377; x=1698141377;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=3TVt+BRalDOEofqDph1D4Mcmkhr9c3sZbJNckvSQsrU=;
  b=aYYAI1Jk/dkVx5lehSUBRbrocmwmL9Ha2ba3johsP648WkhGtEnH/fDq
   QcySh5eWKDL12WgHSqDA5+S9/CsgRqZmadYNxzDE+7DvFz6txEIXWhC2A
   Wk8Ymy9NBkiVD3nbD1C0gD35IGR8E87d4/SzSWPYVB7ANNs19JhAbXzPA
   TLfdYjbjw/erksaEKydoykxAYmdLa2XajBetWEE5RGkr5T9apclVZikNu
   bhEMqunbFqjoL6ICwKVKEF3IiWSAfZ1Exs3JbomtSxKW3hvX8SRjsuYIT
   scFPrRywk/LFvkRm0l/KphhwwUlOs2OW8aKYmMhaBwfPsNvPXz3sG0Trn
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="287098659"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="287098659"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Oct 2022 02:56:17 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10509"; a="960370563"
X-IronPort-AV: E=Sophos;i="5.95,207,1661842800"; 
   d="scan'208";a="960370563"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by fmsmga005.fm.intel.com with ESMTP; 24 Oct 2022 02:56:16 -0700
Received: from fmsmsx603.amr.corp.intel.com (10.18.126.83) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 24 Oct 2022 02:56:16 -0700
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Mon, 24 Oct 2022 02:56:16 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.48) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Mon, 24 Oct 2022 02:56:16 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MAdFUMG6658r6EXFCLVBI/t94yMDUdXPkYjv+UX1mDk6lC0KzlvMOJlo6ZgVc1cRvDwmK31S95d9Np9tQHig4+mFZM1wacj/phK2/sOnWNL0/Vk3SGHVY994CZ+BqhWrp8kQGepLvztfQv+BIAuKlX+WAhC3311o+20VIUtOt+DoCo5ALAYrHWz/wRrA0G53Bfw+i2gQZYc/i0q6Dkom5O41daThAecIo5NLam+xQLIeQlCxlUfWqnKpMMyGYWIr7zJIeZGknNfsV4wFCG9L5lHVk4+y98iQWOq+iEpkwN8gC+TSyhusxOBnvtkZ+1+n1mnX8lZT5nQxo0o+vdQjyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3TVt+BRalDOEofqDph1D4Mcmkhr9c3sZbJNckvSQsrU=;
 b=Fy4cMCSvzXA43332KhFCirqe5y5dfDSxixpB2PSuGtsk1P5M/qyNLusWjGxNx2cSxyzkFhoFee0w7qI9U7OSsGWnnDlQ9jJt8iQP+piFQylOoYGTEA/5UaR8i/T/4yZ8YeqYjEOUTR3KpUGDn93BhxrxihkUm6KWGkzjJ1klR3IL9ysMuFLlXLUFFix48PJ5WdriGWii/BgbMj4dgU3YTzPsRbwSovNaknTsWqwIw7S2yFqiVw444fXpww9QH+F6Xs+/X4hc8rYiEOsWjcQtrbvhWvQYfsT+u/54hRMqMbLKUelekV/N0gcgpSbxg813w9EPGyamrw3MrEUPaFgzgQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from SA2PR11MB5100.namprd11.prod.outlook.com (2603:10b6:806:119::11)
 by CY8PR11MB7241.namprd11.prod.outlook.com (2603:10b6:930:94::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.26; Mon, 24 Oct
 2022 09:56:14 +0000
Received: from SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::50a5:d88c:e104:48bd]) by SA2PR11MB5100.namprd11.prod.outlook.com
 ([fe80::50a5:d88c:e104:48bd%5]) with mapi id 15.20.5723.033; Mon, 24 Oct 2022
 09:56:14 +0000
From:   "Keller, Jacob E" <jacob.e.keller@intel.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Laba, SlawomirX" <slawomirx.laba@intel.com>,
        "Jaron, MichalX" <michalx.jaron@intel.com>,
        "Palczewski, Mateusz" <mateusz.palczewski@intel.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>
Subject: RE: [PATCH net] i40e: Fix ethtool rx-flow-hash setting for X722
Thread-Topic: [PATCH net] i40e: Fix ethtool rx-flow-hash setting for X722
Thread-Index: AQHY5ZV8M3VJKbINVkWs+cG7bAaF564cMJyAgAEh1bA=
Date:   Mon, 24 Oct 2022 09:56:14 +0000
Message-ID: <SA2PR11MB5100DF495182B7328D763913D62E9@SA2PR11MB5100.namprd11.prod.outlook.com>
References: <20221021213819.3958289-1-jacob.e.keller@intel.com>
 <Y1VuCYixOEqWgBdc@unreal>
In-Reply-To: <Y1VuCYixOEqWgBdc@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: SA2PR11MB5100:EE_|CY8PR11MB7241:EE_
x-ms-office365-filtering-correlation-id: 76166a01-1196-423f-7247-08dab5a5fd17
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: XHUfx7oSZvrgvKYeE1YOSRIhIkEtW91ySFJbF5xDjss+WE3iQ+vIU6iXgnnJAzLgCPtpySD/EIN6QLZIieUSfXp/9/1qTWevqfu9Q917NtKuHtd5zUZhgPnvSHMFxiqiiuy0YXN/byiHa7wdXQSi1oZQSlNvBaHzNIgL9vNnBDroEVHqIXp2vHW41SZpW7S8CNlCHcVsBJTJokjg6Yj2cYa2dcu6rZ/s1IEzOxmsiGFFKuYxRX1URIKHEre5RlJz9lBk6B86wYC4gjPYvm3OnU5qE+DbU7rHTDSIJDPEUXZ6Zy/dD3f7cSweRF/3574OY2MUfgezSjfxhyn1wixxSQGx44HwUbgEBMr2rTts0KgkZiMmIKTbCHx5dMBk07Md8GJLR/SBGEV9laBXaHON7QPepeQAjtVPLhcXlnPRrsyNd5rOlSDwkl1O5CsddVmDIUvSkuCRf4NEUYrDZQ1X7rvyeJ0Pz0SG22Hc299mbPugRUyOfEsYwd/clUbXSS1ayF0S8P+563gVECXQLWEjLop0wg+eJ6mW7XcSK0gwz+CjylLbi3+mTdTfek7LEsQ+RJxYstebuBi5ErMRxtiETO6qigjf+QU1ULGnxkuRCLmmjZLzj83C6wKWWtgl71NvxRBSSEPZ/i46+KbeqiRW/bnJjqQBfcNyiL+V6MnIC2Q7hFQuqNaH8gam+G6WG5t+L/626AXhgqMrRCcpn1Ewz0XH5/Cgp0zHWdVhrgNCzqTJyjfYi3dhHjj75v3SzqH9e10IwxCbCo8Mp1eNbZf0WQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SA2PR11MB5100.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(346002)(376002)(366004)(136003)(451199015)(38070700005)(55016003)(33656002)(107886003)(6916009)(53546011)(54906003)(6506007)(66556008)(66946007)(66476007)(76116006)(64756008)(9686003)(7696005)(26005)(71200400001)(83380400001)(8676002)(86362001)(186003)(82960400001)(38100700002)(122000001)(316002)(478600001)(2906002)(41300700001)(52536014)(66446008)(8936002)(4326008)(5660300002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?dklUnCW0VWyWVX+CfRdlzhmer0V/X2U6Gh1gRkod5slZgP6yPADElJiVEDEM?=
 =?us-ascii?Q?wp5pNXx9YchtXsZLbvDj00cUTjrd7aIGBv7VE0PQwVxNuMkbln67JHJ2djJY?=
 =?us-ascii?Q?5ydiZxmxccducBz5aNLKChORFM4ngnAFRaFZNLjicYFyrQfRtv88ZTdJa4Mp?=
 =?us-ascii?Q?EwxRr1yUTWUWhkuB2zMRSGR29Z9Av4bYtX/GmotAWVT0k+91ztIQotRQJbuf?=
 =?us-ascii?Q?GNAI29rTB4DHKYT9NP3GqXQfsPJWWLoUs+yOnoXMPtoTU6/gN6QYdeLjsZ7e?=
 =?us-ascii?Q?WU/GQajLXieq/vXbXm0tsR8jAg0JpocOoLlbfNX1u4ZZBKCN1c8XzE2NN9jv?=
 =?us-ascii?Q?hbN8grN1A1LKTp/T182qaN1CpzqWKs6GewTMb9/c8SdZz3DLNgRDe/WLmIfx?=
 =?us-ascii?Q?KJxc5fGDtQk1DEmmij8pkQtqxKBmBrAHS1XHBqWejpECTxJ+fw2osXrkP2fv?=
 =?us-ascii?Q?Eeu+sCSrFCQVaGQVBTA7gk/mNKAf+Pr2t9REnZeBZk2Zqu4nmzyYQZDY04qy?=
 =?us-ascii?Q?FeBefwPO76IqbK3TaS30+xvucltRMiFzAExtzfdJhGcL7isx5QR4/szHraXE?=
 =?us-ascii?Q?+psbz0Ea+WQ0qCUJ3aTuDSwxl213ho27bExkQshH+hSw+9KEFdmM41TyDGqM?=
 =?us-ascii?Q?znvHoz/JEOGQUwUZQ7TTqn1Yc8Tibjj/sB0gOGsPctq8cgdN4mVlBu1bLCNP?=
 =?us-ascii?Q?Si9QgWsrGagr4fIKbGo3hOqQoYntvQgErNKRYxw3n4kpjbIl/7l2vWE5AXm8?=
 =?us-ascii?Q?vZs/4Go7Mufd4XRxMidHVUjahxE3iySqt+IWeD1Mq1hRHUz2M5o7JzU/pRwp?=
 =?us-ascii?Q?YIJSHKhQCgJ0CpEmVcbNZEACAQutU1uyFb8v3oeNiFBVjjvnoa9/GQhVk85c?=
 =?us-ascii?Q?mkVxjvEwBY0v9iHC7y6goO4Pu7NCO+L7E3RA/6yNn1dI9dyG34ieaoKx8EOX?=
 =?us-ascii?Q?R4Dt1G2VoU59BMmznayklw3zwkKlbGLk6KQT9INoI7lk6906PrEfLZJ7ogub?=
 =?us-ascii?Q?Z/BV3CjyHiGkj6PZkr+2+7p5ZASCWqWeOWAMkSLg20asALPKZr9ER8qFRwzl?=
 =?us-ascii?Q?fHuKHqNQGrFFvBC0GYsHgg1Y+nuOhsg8i7vWrmJJiYa8hU9JcGBOXSyfD4uj?=
 =?us-ascii?Q?gIz9C1MJigaZsjvhV+ZlnxURxx64yJGtD/y070AlFto2AE6/KIGNd7IJsRcJ?=
 =?us-ascii?Q?Dt9KRMdHKI74RqvTVvE+ztxydPY+QJS9a8PC3oX3VlvXZQGvRiPCbw91mwWv?=
 =?us-ascii?Q?iF/hH08+1bUf9gqm/CSyVF+x5nJxWHgKTsSTm0MBR4/yG0YyF+j3OLb61+l+?=
 =?us-ascii?Q?Fvgix5GNvcdAcEcp4QJowcO51Ci7soBMClRdJWbvHlgrFSDyJfhhiLK/HU1t?=
 =?us-ascii?Q?s1O8PwCN6j/HzL8Y9x4oGTNY8H2/2SecZH0icdVbJBAcTcByjV7WRg4vJCcW?=
 =?us-ascii?Q?5YtbbLHsPvnf7kSnMj3IC2gO1PjDIq+r//DqJu99aTLnEHHOTKnk0JUzFZtm?=
 =?us-ascii?Q?v4MNXvSJDd2hUTzqejJd4hKaklrIRGk1pTgW1w9kaRo3qYlIuT4hksF5/GeC?=
 =?us-ascii?Q?d2wyPlGUkYY0fluzVDOPyp3rznvkdfpLHRMlSnkT?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SA2PR11MB5100.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 76166a01-1196-423f-7247-08dab5a5fd17
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Oct 2022 09:56:14.6593
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vjXxx5zmFXcWodhT0xwJGQNKi5Whlo+XEnmMpsjtBK19D89I97G7YMlJwPFanLlLwcFKh/3uyoYP8RcdRO1mJWZxv1PsvSqJodG39Pxg+T8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR11MB7241
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
> From: Leon Romanovsky <leon@kernel.org>
> Sent: Sunday, October 23, 2022 9:39 AM
> To: Keller, Jacob E <jacob.e.keller@intel.com>
> Cc: Jakub Kicinski <kuba@kernel.org>; David Miller <davem@davemloft.net>;
> netdev@vger.kernel.org; Laba, SlawomirX <slawomirx.laba@intel.com>; Jaron=
,
> MichalX <michalx.jaron@intel.com>; Palczewski, Mateusz
> <mateusz.palczewski@intel.com>; G, GurucharanX <gurucharanx.g@intel.com>
> Subject: Re: [PATCH net] i40e: Fix ethtool rx-flow-hash setting for X722
>=20
> On Fri, Oct 21, 2022 at 02:38:19PM -0700, Jacob Keller wrote:
> > From: Slawomir Laba <slawomirx.laba@intel.com>
> >
> > When enabling flow type for RSS hash via ethtool:
> >
> > ethtool -N $pf rx-flow-hash tcp4|tcp6|udp4|udp6 s|d
> >
> > the driver would fail to setup this setting on X722
> > device since it was using the mask on the register
> > dedicated for X710 devices.
> >
> > Apply a different mask on the register when setting the
> > RSS hash for the X722 device.
> >
> > When displaying the flow types enabled via ethtool:
> >
> > ethtool -n $pf rx-flow-hash tcp4|tcp6|udp4|udp6
> >
> > the driver would print wrong values for X722 device.
> >
> > Fix this issue by testing masks for X722 device in
> > i40e_get_rss_hash_opts function.
> >
> > Fixes: eb0dd6e4a3b3 ("i40e: Allow RSS Hash set with less than four
> parameters")
> > Signed-off-by: Slawomir Laba <slawomirx.laba@intel.com>
> > Signed-off-by: Michal Jaron <michalx.jaron@intel.com>
> > Signed-off-by: Mateusz Palczewski <mateusz.palczewski@intel.com>
> > Tested-by: Gurucharan <gurucharanx.g@intel.com> (A Contingent worker at
> Intel)
> > ---
>=20
> Jacob,
>=20
> I don't see your SOB here.
>=20
> Thanks

Oops, yep I forgot to add it. I think I need to resend this anyways due to =
a conflict. Will make a v2.

Thanks,
Jake
