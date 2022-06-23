Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B3A7557D27
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 15:39:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231667AbiFWNjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 09:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231341AbiFWNjk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jun 2022 09:39:40 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86DF21836D
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 06:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655991579; x=1687527579;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=kJdnQe+mqI+6Qcrn2jVL4wrB2tTwPymdJz0l2LNTmZs=;
  b=hkarnURpEhw7J6fqCP6yiGVb8hxsULez/2Fu7st6/MJjGdPOw3l+eiNs
   sPGF8Gubi+L1W67ighhexnPAojsAjL4mqaC3A1o7l71GWtyUTJFdBwBit
   4NnF3DHeFq5cGL5J8uE4VynP3iWUeFScU1793dCkBqlwiUyza5skeeRVS
   lwG3JY2bT9J9cGKlg3INU2Ev1qQ7GaRU5O9Vu6ipFr2bd4Z3m+muuS7/G
   QDkA45XVlEngBEoIabS5UJzTlgGAQtDBPMaoQs61QCOyduABLvARm6wZI
   IqtWLtd6gfDncqta5bXRommGzgWzarH9FEsUQAyRWFaP3OEtA0zQUSSuL
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10386"; a="263754462"
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="263754462"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jun 2022 06:39:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,216,1650956400"; 
   d="scan'208";a="644745686"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga008.fm.intel.com with ESMTP; 23 Jun 2022 06:39:38 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 06:39:38 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27; Thu, 23 Jun 2022 06:39:37 -0700
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.27 via Frontend Transport; Thu, 23 Jun 2022 06:39:37 -0700
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.41) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.27; Thu, 23 Jun 2022 06:39:37 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MJC7IsbD2sevWH86cPdfALWWSOfQ+7BKWGc6nupuqYCXaGoZwsdbrb6UHCN+4TkWzY1z48DqLxWLM1BKiZkd7JyInQ/GJnILKwAuEWGGSdmr9EJFxw5WvRS8w/drfj/HIJzP4Dn8+7airiygtFyK3NDfuve28uXJ+jKrdKXu2st8vWA1Dj9/wuvkJDp0i49oMEOBOIfP9hDQHy3YE9bi0rkAz5FMhSEgjvrMOiTSZrVgj9lf8iG3n9xop6X4+Prohx1CdikFJD3+m+GH8MQcC1Gv/oM9HlyJkP0BXS1ZTaBRMR4M2V1tib9yt9dEfUDbteOuL4p9eQvwI3HBNRC9dA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kJdnQe+mqI+6Qcrn2jVL4wrB2tTwPymdJz0l2LNTmZs=;
 b=HNPoizV9TosR8wNpcoRlxe2hX7EymZWl30SiJoAFGquw+BAqcRae8PWjvniv38UZnYRaly2iS3jivgucitol/qA1dXRNHtRLOEOXFnfd3lA7hrlujxHgPFkRiMqiFEzu0ngHd4TcwIcZ2yop9QAKuJoF4C1Zq5KEkhWJ9Q0A4O+DPvgqW4HAeTRbVCEqj4TJIKZoq21GHivpTaRikoAu6r2gQpu/VFyHQam0H3TanVW6ZvUqYFSoLieuKHtbRJnfsqZyFL9IgWMyfESIvZv2tiDV3yJ6mhMTeji9DfcNMLsspMrybt05catCuohKZsxI990p6O2dnUkvn/kryAd4fw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MW4PR11MB5800.namprd11.prod.outlook.com (2603:10b6:303:186::21)
 by BN7PR11MB2626.namprd11.prod.outlook.com (2603:10b6:406:b1::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Thu, 23 Jun
 2022 13:39:35 +0000
Received: from MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::f57e:d03d:b339:c30c]) by MW4PR11MB5800.namprd11.prod.outlook.com
 ([fe80::f57e:d03d:b339:c30c%3]) with mapi id 15.20.5373.015; Thu, 23 Jun 2022
 13:39:35 +0000
From:   "Kolacinski, Karol" <karol.kolacinski@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "G, GurucharanX" <gurucharanx.g@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: Re: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Thread-Topic: [PATCH net-next 3/3] ice: add write functionality for GNSS TTY
Thread-Index: AQHYajQ/+5Nk/nCT4Euu3FZzl2q0S60lpXKAgAcRTA2AABJcAIAwbhiy
Date:   Thu, 23 Jun 2022 13:39:35 +0000
Message-ID: <MW4PR11MB58003D5B00016D1F30E0DC0686B59@MW4PR11MB5800.namprd11.prod.outlook.com>
References: <20220517211935.1949447-1-anthony.l.nguyen@intel.com>
        <20220517211935.1949447-4-anthony.l.nguyen@intel.com>
        <20220518215723.28383e8e@kernel.org>
        <MW4PR11MB58005F4C9EFF1DF1541A421C86D49@MW4PR11MB5800.namprd11.prod.outlook.com>
 <20220523105850.606a75c1@kernel.org>
In-Reply-To: <20220523105850.606a75c1@kernel.org>
Accept-Language: pl-PL, en-US
Content-Language: pl-PL
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
suggested_attachment_session_id: e7abd041-a6db-5089-0dae-0db92a5e9dae
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 247b19c0-95b1-45c2-01c6-08da551dcfd9
x-ms-traffictypediagnostic: BN7PR11MB2626:EE_
x-microsoft-antispam-prvs: <BN7PR11MB26267FE327013C3692FC684A86B59@BN7PR11MB2626.namprd11.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: yb4sWSni82RDmIg0wHtwBfJzWIIi9/Vuh+ZSQaliKIGLLWLhBKdCoH8xlq/OY3rnHhfIOfD20LEadHtgIKPei7M8ER1suysww3hiJkwFkuPMOgmIl1OXJ6fAIXSE9ygufFHCm/eORLPG+PtEDgP3eoeISQIndW4rn9WuDAniGrj0SmvTcsCyN6BKVK/zWA7b17s0T5/ipTNO3VvuFLIZvWj49OT9yyyAbyLaO+kWIzsx+alNC0uIykVFTV1rOrksZE9yimsbllllWr8vjlPHNfm8Y1HQRPE681cpbAkWtHGclmleDTH4XUjiFmOecRzEj1kNPA/fAHmH6TdSSvAgV5v6bYiHfNVOm0HlaL92cRX99RiEk4onaT/DiL5WH9swS7vpbIF7q3ifUDYbCt2XjqIUnXqNRWBO9rCPYkZ41oh6CTNQ/J5MF738H950E1iUmnMQaePaX2MlHBSoSL2lRYhsq+14EKw2yP1oSGlzE7wlwn3bQSSz+ALqhnohgGf4tkBFazuBo3Ol7Po3jFdixmxNBOOtNRHWcdoLgBGSZ3mzObfKcGKsqYuj90CJm2NqGNE8orLkEFgubnJR5wHC+/pU2xBSaDCGhSLeBGDKaqDF4gBnaFY03WFU+cgVTjUU+LJ12AfEBmH3J936tVDCuIITgccoooThr1NdXyoh/QiDVwlHlkNWr1zVFS2t5sOxFHgCMpTRLKrFCxYzscNe7b45x2/AVLq6qhZgEXnN6j+gLToe2kb1saX9dusr1RmaNELbYThH0gPUKJn5zUR2yw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW4PR11MB5800.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(346002)(366004)(136003)(376002)(396003)(39860400002)(478600001)(33656002)(66476007)(76116006)(41300700001)(8676002)(55016003)(91956017)(71200400001)(38100700002)(64756008)(66446008)(7696005)(4326008)(66556008)(4744005)(6506007)(5660300002)(186003)(66946007)(122000001)(54906003)(9686003)(6916009)(26005)(86362001)(107886003)(8936002)(2906002)(316002)(52536014)(38070700005)(82960400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-2?Q?u5WLewE+lQ8JyTEo7VEfGMwik3hxfrC0Baghi3TvroQCwA7meCi2jgijCo?=
 =?iso-8859-2?Q?/FQdTgcBYODyvW7e1FdWCm3RImG/tqRydniNPt82BVhDsX70eTlyMzXQbg?=
 =?iso-8859-2?Q?skdMk9CS0ccA0Wy/GtwifpTelG2CXuop0pZHdn8cvydArKRY5mChUvHpTB?=
 =?iso-8859-2?Q?znjytxa4V+I2Rk2B7N+MyaGUe14ntBJu3SFVUL8Pr/eezeCJZOjAgQ/PWG?=
 =?iso-8859-2?Q?srVUwzpIJNQ+vGm44UA9I33PZw1kcCLlYGSSLcL4Ied6p+97iRzPELH2z8?=
 =?iso-8859-2?Q?7XFTsZbGYz1oCAA/fhwPM34CZN3Cg8w7fzgh3+XV5AZcLpAsd7XRmuKcaf?=
 =?iso-8859-2?Q?UHUhaBvlgdgKNYGy6TmHHD0KeCZ5yWD5XTs/EFn3uBAXvHp2v/2Gi28ZM+?=
 =?iso-8859-2?Q?VkFRiN3GVq8292M+un2udNz6pdp8Y3uT+JtANgk2dwgW3Reaqv/LxHmlJU?=
 =?iso-8859-2?Q?rZxo8XFoAnS6CN5ubCB/32M1Uxy7AB3PLjGD7f/wU7ajmJLEjc0gMUGvBn?=
 =?iso-8859-2?Q?d/MuVemspxNDcwbl0QmMm8LSuXVPMBCqLVefZoWW0xube+L2ZBQpgrFPH7?=
 =?iso-8859-2?Q?s7kHu8KF5lXyyzSxzoACMt0Y0bKpVDdod1GBC0JZfv3mLHnCLLRcFmS/Wo?=
 =?iso-8859-2?Q?BMGR7oWOLDYJivQWf5ygHgqEVCTWz4MObNFNxvMVR7oqAYDcR/zhCWVkF+?=
 =?iso-8859-2?Q?f12PU/et4K9Qt0jWQld2ICLGyaFb/oShCdu6e5nV2XTX7ZiM/xmViXHUPU?=
 =?iso-8859-2?Q?AptqWXRg0iyuddirMflCex/2KmiIBf3SFTv9ilyC+Bx6f2PaeFTYzOYgaR?=
 =?iso-8859-2?Q?c04UUSH36ks4bV2N2SRA7FLGVk8TQw8AvC7jnNW68TV9yx6M3UjgxZvk5B?=
 =?iso-8859-2?Q?69O9T+xy+9rKWcUbHCYh3ZxVWS0XPS3hEjTUbveo/Se44PEHPSSgLf+cXD?=
 =?iso-8859-2?Q?DFNjcwJxpJVW2BOmJwGhTAJZhgJNia0SidKSbDvr7d5RJxgvo3phnAHmJR?=
 =?iso-8859-2?Q?7xCvkrkFlGR9HBuFGYJn1oZoh7gB+opAc60JmB1F6Ruor60xt9Zz2lf9Y/?=
 =?iso-8859-2?Q?hI3SU1AM/dRA8MifUJx8VJNhQaxo33z/rSACxyaZjN4WwqYRgrLELERqLS?=
 =?iso-8859-2?Q?5bM2REbW7zQeTM21uun4F76SSNxmoDd+T17uSbWbsPstucddGzKGdZGDCt?=
 =?iso-8859-2?Q?pxpjwdOwR6ecgqqKOlqKAv+lZAcxQ6+pPWR4u2umFDevO6h9oTeKdA3s8j?=
 =?iso-8859-2?Q?1J9fmRk0yfl6WblC/VjC1lmBE9e9+jW8tUH2nzRmtOugr+tUJ8SqmsvVBL?=
 =?iso-8859-2?Q?/Z+EYEghg8FrCrmRx01qLkS+Lw8FR/H2QSYRGUwlzPxp9MeVAxknXlp/2B?=
 =?iso-8859-2?Q?3FS/Op+W+4QQ2egI75UA8Q/OXWa8jZImoYaGYcuMyxmkuI6UqgBCfic+a6?=
 =?iso-8859-2?Q?PycvORZ7AYSaGe9enp5VL7c2f279W5VbM0rXCnGtrXidtR4P5YlExoYe4i?=
 =?iso-8859-2?Q?I195zlOiXjuT68cFlxDUt0Brr/y2QiCmpkp4HGAEEv/5kr+3zTiHYCkOu8?=
 =?iso-8859-2?Q?KQRLs7XRcLWEkHQfjD0NxaDA/bvwEO7BWNIq1pDD73uJ6ncZKCaH6AVmqK?=
 =?iso-8859-2?Q?osw+sFYDmbGZQgAer76kWoPZ1xvMNLnGli3p/6ANk2UZAgDYJClNaCFMaF?=
 =?iso-8859-2?Q?mnxyWNjq4IwEY8M6K3HW0JWmW0DOFOKNPPmoqnebcLJHmYSE44EQwNjQdz?=
 =?iso-8859-2?Q?bpRJdwBDD4mjOYDGxU6XYJzq06E+DUY9146DXmHnek/QDTdEEIJBEja3jv?=
 =?iso-8859-2?Q?WSAjgyeL+mOHE6LwE/Zu7Hv6ycpXPLs=3D?=
Content-Type: text/plain; charset="iso-8859-2"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW4PR11MB5800.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 247b19c0-95b1-45c2-01c6-08da551dcfd9
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jun 2022 13:39:35.5708
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: azLKO8tOCp83HYwm480gkENFtgRltYgDvDs3WFYWeGDpfliGsx01HXCW9uAB8QHdfhrgcl9jmgLaq9i9/dbqYnZP8C3uFBxKvPwWN82kydU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN7PR11MB2626
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 May 2022 19:58 +0000 Jakub Kicinski wrote:=0A=
> I meant discovered at the uAPI level. Imagine I plug in a shiny E810T=0A=
> with a GNSS receiver into a box, the PRSNT_N bit is set and the driver=0A=
> registered the ttys. How do I find the GNSS under /dev ?=0A=
=0A=
If the module is physically present, driver creates 2 TTYs for each support=
ed=0A=
device in /dev, ttyGNSS_<device>:<function>_0 and _1. First one (_0) is RW =
and=0A=
the second one is RO.=0A=
The protocol of write commands is dependent on the GNSS module as the drive=
r=0A=
writes raw bytes from the TTY to the GNSS i2c.=0A=
=0A=
I added this to Documentation/.=0A=
=0A=
Thanks,=0A=
Karol=
