Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B41264F2EC
	for <lists+netdev@lfdr.de>; Fri, 16 Dec 2022 22:06:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231816AbiLPVGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Dec 2022 16:06:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230171AbiLPVGV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Dec 2022 16:06:21 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680A112AE0
        for <netdev@vger.kernel.org>; Fri, 16 Dec 2022 13:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1671224780; x=1702760780;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=iqHiOSVv5+vPLh78vRA2eVvJ/sJq1hhSuATp4l4PfMI=;
  b=CtUGKZxgeY22zgLyKfnADktNZg20c6ah0pVWt1isVXoYLFm4HVqZANOo
   wg/VvyIr6599zf/CgsO483qaq3gsUNPx6JrFSgsukFKSXIK7GQG3+fAjI
   WkqfUo0SD8WJYwebMaMeO2GRUmybrzKGtokpGrp+oFixzF7kpeLd4AVb9
   Ibw8pcVmQIPhdFX/Jrp8H24ZOu5WnRVCqddOM2v5FX1aseI7N2oVbQsC+
   M34rHuaA5OKQ3u6uvpLjJrUXY7FZKzhSRjWgMy5/gMymc2v9ETw//ea9X
   UpwEfxU6VwIh9hezQxHNR9w3/qFjkJMyXRczPcUB5DorBhDT8QTSLdyTJ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="320228891"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="320228891"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Dec 2022 13:06:19 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10563"; a="718500767"
X-IronPort-AV: E=Sophos;i="5.96,251,1665471600"; 
   d="scan'208";a="718500767"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by fmsmga004.fm.intel.com with ESMTP; 16 Dec 2022 13:06:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 13:06:18 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Fri, 16 Dec 2022 13:06:17 -0800
Received: from ORSEDG602.ED.cps.intel.com (10.7.248.7) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Fri, 16 Dec 2022 13:06:17 -0800
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (104.47.66.42) by
 edgegateway.intel.com (134.134.137.103) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Fri, 16 Dec 2022 13:06:17 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xjaey9zQFiJZsYhmLxOh/tnvIHhV6CHbtJQh90PflT0Vntr1dKnS+Jwczhbnfi1UbI+n25sL1oyQYiueGjzIujUFyvwXNRtbUc3O1MTY0uAl3DeCdyC4Tu3bsQh5b5efbxDMnfxhNL+JA/VUHzPocBeA9ZR/8JdJO8Z/O/xjnLULEmHNGCmYTJKuFmZzkEQVCYRKDJhAKlTjokIHm6xMDRHzt9lHwXfZ1rpSg70dJVSXiRWEhzK3QcwQXYYFW6mnWb8suARke8YPYocB6ZfDfPJBg22lZAKVuz0xPOT7JupJC3xZtbna1bB5V5QZHGhBY/F8U7Ob7n6nzYIRbjmMLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=iqHiOSVv5+vPLh78vRA2eVvJ/sJq1hhSuATp4l4PfMI=;
 b=Sz1Tx+g1RtOEvjCXrFs4Wpq7xvLcCyKRnjKQq0XJRj1rLCeWjU2Xx8tmVUjTf0O3qu9ROIsRPEPVi4OEyhYnSnfnycryXOKaeJIpnRBqppp3jIF7DvtI/U84uWR7bshUuNts3pfcTAzjCV/isCcbIMl5QNbd/h/RzwYI6NfxV6Ddl/QTxNt0OaRpO+imqwJZJP7AtrP/F+tfeSm1wOoBjgdqlY9tWoCZAzFoUJrtn/+1/MsB1s4r9HIBwWrYxPSpymjmCu567P9ZV8QnMk+MJ5EDc1dOlJag6drFaCGBVi5NhaAPyGRpWLUKrtVAHPxYbLbtFLqcN3UlIvPVaHoH+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from IA1PR11MB6266.namprd11.prod.outlook.com (2603:10b6:208:3e6::12)
 by BN9PR11MB5529.namprd11.prod.outlook.com (2603:10b6:408:102::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5924.16; Fri, 16 Dec
 2022 21:06:15 +0000
Received: from IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c]) by IA1PR11MB6266.namprd11.prod.outlook.com
 ([fe80::5d37:e213:a4e0:c41c%7]) with mapi id 15.20.5924.012; Fri, 16 Dec 2022
 21:06:15 +0000
From:   "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
Subject: RE: [PATCH ethtool-next v1 0/3] add netlink support for rss get
Thread-Topic: [PATCH ethtool-next v1 0/3] add netlink support for rss get
Thread-Index: AQHZEBkczq3a7/0Q0kWYGptyx+GyjK5uUgQAgAKxycA=
Date:   Fri, 16 Dec 2022 21:06:15 +0000
Message-ID: <IA1PR11MB626636E87327F2BF9C8EDF36E4E69@IA1PR11MB6266.namprd11.prod.outlook.com>
References: <20221214235418.1033834-1-sudheer.mogilappagari@intel.com>
 <20221214195544.65896858@kernel.org>
In-Reply-To: <20221214195544.65896858@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: IA1PR11MB6266:EE_|BN9PR11MB5529:EE_
x-ms-office365-filtering-correlation-id: 86649496-a631-4703-9dc5-08dadfa95e83
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: j5Fyc8dD1DHJNAvnvEDMZemBtL49P6brTO2C+WWNFqBV20Jo4z0nykOWFBf+PPwA1HcA4eRV0bOkuT/5TO4DSOvJUFhjFvtKIsTU4wfQKSPSSTFuVsBKKlrifGBPW9mh+m1gftztvYf9TcTIzc7kEkRyHeAgeHT80LWkJ7Njv+reXP1i22vPWmivuvziQOG3TyywLImlwvUTGVlbGOf38PbZqCi+K2ZT13G+GuJgxWwu+IauVo6rzNVI5l70oWvqp0dkSoyFjq3IOO0T7F5jf+DXTfSp7YnoIwZ1LekpkJu1B4gipIQtwYfdamjkmhmiDvl0ZwGyGB3bswqIlxuYee9pcOOSpIFMv/SYeAHrxV3OyUn89tRgru2wjeaaYUsQpKjAq8V+YJZDDoOhNMB+XLCm1QTJSiDaLMFoF4inQhzzZ05G/ZoZZ30gYSA2YBrMRO75LXqkMbHrOPn2e8shhkE0yqeBR5WlPXqJMlJJdSqNg3K2GBmQVVxwMQFaumjAGTA0NBGCxnmH40ClGKMVy4SIS7G/+Uri7a9j9o+MldWnkGINHdnAeovpkTNJPjmiREIqW7V8G6lI5YYBdOV9MCUKtO0GWvLxzqC7tkF5GI2ygi0JrKqoC1WlTkdqGiq6IEsE3+K1UFWmqewre2YFlM3ml6MmBWzN+L0giVAfkC5HntogFsykyOb0bEmH1/3F70WLYYVhVETYkvDPjgd3zw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:IA1PR11MB6266.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(376002)(136003)(366004)(396003)(39860400002)(451199015)(82960400001)(66556008)(66446008)(66476007)(8936002)(66946007)(52536014)(76116006)(2906002)(8676002)(4326008)(64756008)(38070700005)(5660300002)(4744005)(38100700002)(83380400001)(122000001)(33656002)(86362001)(478600001)(316002)(6916009)(54906003)(71200400001)(55016003)(41300700001)(7696005)(107886003)(6506007)(9686003)(26005)(186003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bfYX+YdxYK0o+VJe/BLSVD4gCmWWbqBCXhA4Mpp75TwncvpReniLl3YWPyzx?=
 =?us-ascii?Q?8Qj8+zTbhG6rU7a9byjQzAh9JibILqF63AMOP0iwv6qszu1yx4jyzE5cJpbP?=
 =?us-ascii?Q?3GOF9QLe+3QhOSSR6eiA8lJs4cwIHfkWyV+zRm19+n4pRplcB0mYFI4EZuNf?=
 =?us-ascii?Q?8LvZMY5D0T52N9I1tfvL9seJS98fWeyEy6svMapT64VHYjkC1UB6nUaYIRyG?=
 =?us-ascii?Q?hOszTWwVhNhl+tFhZzlrStyRqugkz4I/BIALiORjQezElFBRiPlPC3jEhcqg?=
 =?us-ascii?Q?UaOl2aQsw1J/K4DG1upeIzGQvT3ugk8DJr8TgucscvRKPToIJdFMtajtFFxz?=
 =?us-ascii?Q?6ZO9F8Ooyjfiw7K/XOqXiOZSAgQDMFF/3Qv0zIADIvD79Uc63vYLk8CZqZQ8?=
 =?us-ascii?Q?3/YxVckV5mFyEjFnqueuweAFWWsL9cfXAzwmY985kUGiLlm0MPjsHLv9ZHRI?=
 =?us-ascii?Q?hMM9aZKEwmzXgS/Ypd60wcCy30HgMzyRvhKI7xgDwfOv48Jj4LzBNK2MAh93?=
 =?us-ascii?Q?J2ZOZZq+gWplDUpTDd3MvRbzyp88TPoBZwK2/NraeQzQINasSJELxvjOVq6D?=
 =?us-ascii?Q?V0/YPAlNl1q12gsMbaE2N0rWaBghvb8L1l3gnJZxCgvy06Ihz4TkFUAv576J?=
 =?us-ascii?Q?l7qe9pu4b21rNu67G/GcSc0/+92gAnWYg0YC0HFMPaQNQba3UxDSUVhqsPGY?=
 =?us-ascii?Q?bsFiXN53zlCBa3Q6YMsxoC8hcyPlT2DEXTL/jKvbtEk2z3+cnZs7qWU7R8lk?=
 =?us-ascii?Q?RVc4zopz0XEUW4oLcN5yHVmcs7p+TZDHGHF9zEh16aBiQeTQLgAg+d3T3sEo?=
 =?us-ascii?Q?HtIMWxfNodnSCTAVVFbCKqIpwivSZyj0IJLUKLEhA7v9qRa5HwymNKUpsygx?=
 =?us-ascii?Q?2uzA/i50AsQtze4+dc9Ky6HFqH3pkfpqHdCfUuKdLWpWu7yge9ztxUFjyiJN?=
 =?us-ascii?Q?0wQJsD5/oas8LSKlbBYIS51jKwtSfdspbs4gXorKv67VgvSY8O9IKRAdt7Pq?=
 =?us-ascii?Q?lqC+WfVtFBBY/QQO2joUHAcL8AIxdHGzxuvRiqzhjXz8ujGd1Z3D8vO0Yooc?=
 =?us-ascii?Q?MzCQWXFBvSCrzxguYn24R6ieHLikDwaDE3tiMZra1QLgST67b+RXpx2xWOfY?=
 =?us-ascii?Q?obboMHP2BcOU9UgARHYcEV0cN0K/D70VsacyHXAZp7A3UX50OcqhE+brZsYv?=
 =?us-ascii?Q?rm/VSoP205xO0xMc9AZIJchvFnft3wuTNorzG7qDs9Uy1QJdjY+c5Pp8ylzU?=
 =?us-ascii?Q?mb2qPdOQ7vlrPhQloqb+SHqv8TEFed26ZKEpujGm/VFd0KE1/XdVcDfweQzg?=
 =?us-ascii?Q?tG+ksNLpsA+5+bIQdB0/xzeCQoow3aAVU5aIIb4qtryMiUhhMF5hTJg7SZao?=
 =?us-ascii?Q?elui9nyi5G636zw/+A8wkGOz5dpieEHbC/F9FXRFbOuExLZKy2u5+NnEextj?=
 =?us-ascii?Q?p0KjK6TMjVbop9OG+kxYXtgcp2FUmdfTNIDtGsL8PKJ0dR6KfCMH2utqLdXY?=
 =?us-ascii?Q?fvNIRBLbAOqY1EAsYuIYXaG/PCMxWO6JltHBiJJ8QBuoVi2pRTy8HzbPWAGK?=
 =?us-ascii?Q?gKhL4tQUy5PNzFrBlcbbyAROutlEytCDSAVYdSecI7hmMQMeGDop09Ke1TgZ?=
 =?us-ascii?Q?BQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: IA1PR11MB6266.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86649496-a631-4703-9dc5-08dadfa95e83
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2022 21:06:15.3872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lo3jLDQ8tMx5dKX2R93LiW7MROuPYBhVFBCBYefs+lIkAJqqzOAOQzak626Rb0lalFhU68NXPt+8HU+Qkd5CQrIZW5vSu1X7tbEVeJ9o7Zc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR11MB5529
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Subject: Re: [PATCH ethtool-next v1 0/3] add netlink support for rss
> get
>=20
> On Wed, 14 Dec 2022 15:54:15 -0800 Sudheer Mogilappagari wrote:
> > These patches add netlink based handler to fetch RSS information
> using
> > "ethtool -x <eth> [context %d]" command.
>=20
> Can we please support JSON output from the start?
> I can't stress enough how useful json output is in practice.

Sure. Will send out v2 with JSON support.
