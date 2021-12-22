Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14E8047CC02
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 05:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242315AbhLVERm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 23:17:42 -0500
Received: from mga03.intel.com ([134.134.136.65]:50326 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242314AbhLVERl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Dec 2021 23:17:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1640146661; x=1671682661;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=26yqcDIR7FgNG74zQzCqB6d8KHvyH/ShIfuzVBYUKJQ=;
  b=Ep4Nxh6Ylj75+QXQVai56JUFso3LtwIjy9xxZ5zP/Xh6kdKZ6jtizDUJ
   euy7UlXibBqkofXLwI9M/8D4SEn8IfwoZ5zXBuHgRMvYbDSb3yEUSf4uf
   di4zbdWFQOPqBjIK3o5bIuBfYSUfPfPJU8lcNlF5NCVc2eTrtEH3jRrPk
   1W6XrnwWP6qPQw/lat+lCB/97hoagcdIKC9HBK5gYIP1wrZlWXdGURMfA
   SI2Ypgpga4oN6hYOkcaf+MzQ6Okx4w8FhARs+kEnOjkT9xY29Tlpy9Cqx
   GG+yOjGdODBX889Sr8v6LWAosi5SKqG4bWHq6awyqR3rqxif5lSlqluEB
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10205"; a="240495579"
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="240495579"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Dec 2021 20:17:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,225,1635231600"; 
   d="scan'208";a="617002051"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga004.jf.intel.com with ESMTP; 21 Dec 2021 20:17:40 -0800
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 21 Dec 2021 20:17:39 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20 via Frontend Transport; Tue, 21 Dec 2021 20:17:39 -0800
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (104.47.58.168)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2308.20; Tue, 21 Dec 2021 20:17:39 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GwSPAAYarJ7Nswv2lnqtXgC1FrIyhheXsAI/7+DQ0Deq51NkLe7kJrq5wwjHXdjlWJXPu5Yxwt0tEhgSzCgZKrad18SBuXgTGGDscUvtshqWUSsqtc8yGhbxRRQVbXFv4+7yQohmdTbLYNCAPtF9U1nA0gbiESkz3XDSOI0Ru+e0YLnvh3XcpmQ72mSavZtve9fkgs2o3fGgmXNEbXDM4WtUyRyHQgBavgJW9yDi3ASy7YaVt3IQMCB4ztqKlXs7sgFDqglcWRC43z+vVfDvDbuc+jBXhmnkMqUzredP0KBpXZQ1fF1Ie8o0dvgJVwEjloJdQsGFbNz8EVgmurxVBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=99/lc0LfYsgeh21dMAg1wYbmbBgx5NHD3ccVeu3Ru1A=;
 b=EpodvvDuRRpE+6uv24qLECwSKj7QIgsTjjjT0fXtblvxuCbELSsv9k8S0w0ULdUCw9v1MQ9Omw+HEs0lPCn5081aIAxdPg3yGsiF54fSTniE9deyp0kAA11taTw/vXSEAFxt+m1H8zsM1vmKz6zfP6EkP5NvLqperxZUXR7MIfIJnmjsbvgVKUXoPlCHol7/V2LwMctdzHVLPvlHVzVuRJvrimgSXnqz6Z6tcgofzKURb0ToZ9h7pKaS347c9Irl1YiMnzdvJ9X7YIp74yniF4ZDd+KxNYA2ktCKb6z7Rk/0S6T2IXDXfE79ksHI0bT8m7TaoJzIhUrPZBwkq9e7dA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from BYAPR11MB3367.namprd11.prod.outlook.com (2603:10b6:a03:79::29)
 by BYAPR11MB3574.namprd11.prod.outlook.com (2603:10b6:a03:b1::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4801.17; Wed, 22 Dec
 2021 04:17:38 +0000
Received: from BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81]) by BYAPR11MB3367.namprd11.prod.outlook.com
 ([fe80::bc02:db0b:b6b9:4b81%5]) with mapi id 15.20.4801.020; Wed, 22 Dec 2021
 04:17:38 +0000
From:   "G, GurucharanX" <gurucharanx.g@intel.com>
To:     Ruud Bos <kernel.hbk@gmail.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH net-next v2 4/4] igb: support EXTTS on
 82580/i354/i350
Thread-Topic: [Intel-wired-lan] [PATCH net-next v2 4/4] igb: support EXTTS on
 82580/i354/i350
Thread-Index: AQHXzAm3CUyZ3RRZTECnY70tWaqDJqw+PXJg
Date:   Wed, 22 Dec 2021 04:17:37 +0000
Message-ID: <BYAPR11MB33670A9B2D87F28FD502B478FC7D9@BYAPR11MB3367.namprd11.prod.outlook.com>
References: <20211028143459.903439-1-kernel.hbk@gmail.com>
 <20211028143459.903439-5-kernel.hbk@gmail.com>
In-Reply-To: <20211028143459.903439-5-kernel.hbk@gmail.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 263c3300-b452-48c7-1973-08d9c501fd0f
x-ms-traffictypediagnostic: BYAPR11MB3574:EE_
x-microsoft-antispam-prvs: <BYAPR11MB3574DAACE4789AF5BFEFE5D3FC7D9@BYAPR11MB3574.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 8ln3CiJRRr4Ux6jgZ9I5Q0cAM0JdzHrAL0FL33ak4tJBL7/OsCd6XWO2HzB18/nONyJMCLsznhN1UffiiIVw33Piu+t4UmOlxLiekvQjOZQ4Nm0VJ3KivUHY8e2AyxrA72TOrorT303p4LGXBCJbLoSBu9bISBnSTkuyl5Knm4UAqp072CYlJ9+CY9Qp3ABW8IKSBYy90dDNJLbhj4M7bwudmUak33nS0dlLUuGeRlO4yjwwCyQPQN7fwM9/Z0emCzOEjC1SNQ+sS4PQ02pmN+A4D63yamRm/MkLXcUNOgx7Fqk3gqcEL2+WjCJhDq213Cs7Wo98IFTwXmMkc6N/H1U6D0DP6F4GmzM9n3HvN7ZKC6ThtgVxwX/JwW8MC6GO5n+ZzV8AKDDRzB+AXOmQC3BIcWzhuMzbZVuaE7r0a63vzX1nHOwEn4VzbX/clBatZ0zevGSEfRNMaT6BRgfgBBiioTD3a0U1O8zMuwekl0qVtg5ZiSiVlFeG6+z4cliH0NUGUWzhPDDbJxsEfmntOexsaKUU2fjlfYHDfq2ayPmj1Oej2vWRrOEEqDfuFog55YOI27fb/FLBKY5KSw1O2TpUMi4iHs/kq80j+hU9xTKp7GABwiub0gV4s84Mpe1cj0Ri2imoqYoAI5eyp5hqXNfsDgirmQNFYkCO2ccFNuk64a/lo4zQSqi29N1BANvaiwM9L/S97qMywUIGQYL9Uw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB3367.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(186003)(26005)(4326008)(2906002)(53546011)(82960400001)(38070700005)(52536014)(316002)(6506007)(9686003)(110136005)(5660300002)(71200400001)(8676002)(7696005)(8936002)(76116006)(33656002)(66556008)(508600001)(38100700002)(66946007)(66446008)(64756008)(66476007)(86362001)(4744005)(55016003)(54906003)(122000001)(83380400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?za0ayib7/rhHhgv8XNsos6qCEFqXRcVUAwYkj4TbJQWmykFuGfwyHJO8miJQ?=
 =?us-ascii?Q?hl8ZpHNWCxmYSNy5YFRDvI3UTcaBCUZoxvWkdhpG+uTXzgTtu3ccB3+Kynx8?=
 =?us-ascii?Q?C0StxhZJfiMEfHj5zhoqrSV+kO1VpCWJY7hLcNseFox95GoNdYg2Bz5z9nEt?=
 =?us-ascii?Q?Q4zDGYN9hchyT4cz4RyJjCmQeb9tTb02FuUDBc+WkKtbxaqLt/uysAYWD88C?=
 =?us-ascii?Q?CWBrTed6vFTzncQSy2Iyg7kdXbXDeAcqG9ZMF70W1b1VbN7CKSCEtzMVt7xI?=
 =?us-ascii?Q?U2eQFZNRx896NA99kYOSVoOMpzDq32k1+papuxS1MLDCT3wBS4GrbUB5xMuv?=
 =?us-ascii?Q?ZZgvmXPimTFU/7bTHUqiRSGdj4iNE4BDr3LpuGzgyz0fWbYCxfawB1eU26MU?=
 =?us-ascii?Q?6dRu0E6SHeEA18a4EcAbiCc5faYK+Q3MjeRnv+XYiLXiWgO7ZKCO+RbIIEPD?=
 =?us-ascii?Q?5/3G/o/WczEzNfL47vcteDMRuXIJTEqE687P0cI2hsDjqDbbnYYiA+bpUyJq?=
 =?us-ascii?Q?nt3nZdNBFbmlBvj+Zo3aC2aaklEPV7kVVLuZJF0N54VQSNCam0QKyqczOozZ?=
 =?us-ascii?Q?oqDh36j36UM41fdwMFc11nqNs2aJpanJMAIiaTFd8LO3pKWmwy9mrNEwG6t4?=
 =?us-ascii?Q?hdFCREkUJU7tjqZM/9ePQNVYJnq0KGEK3f+mvrKr8MWOUkCW/NlmhAJ79++j?=
 =?us-ascii?Q?WdBYW90ogRPZTuA0n47tCLyowM9w4G2sMBhVYA49Hc6rZur8N4Lx+s3kL89W?=
 =?us-ascii?Q?ymn5dXm/UJ8aNbvWqndZGcAAbKc3A3+5BwAr6+HEAPm2e2lfYLZ6e9Y9YpFT?=
 =?us-ascii?Q?UQXhtgdmubDhMNoBTRBhNVtomjyBWxaNySzNB28qoqEU+78zhuwTfieMsp/4?=
 =?us-ascii?Q?3EhqMefMJb8WNAHCL1jtyI+HYQoUNtRoIVpoafoDWfL3C1Y05k+2Ftv32Mia?=
 =?us-ascii?Q?9cGxkkFSLHwKlBs86lrsA57igr4vnhpRSHd7u3U5EmOWYCYeYHxVVwjcdSSC?=
 =?us-ascii?Q?BXdDcyR5Ks+IyE7P/mr4A8VK3WUYE1+SHbb+65X5h+GLht33pPXfuAW+En9F?=
 =?us-ascii?Q?+0vYgyikFbMga6Kp+aCisbDC42Rs5vTRz4hduawYR0pwnM+CZr1oha9PdKAl?=
 =?us-ascii?Q?X+R00RFNloXMX0iLUGzAHTPxs8iauRpMHHwy2JgK2yWoyQKxjqjQZB556CwA?=
 =?us-ascii?Q?8Hh3tI1jMMu/71kZOxADzUWnZLmUsgXg+xHIMV9aO4J0T7UWf/WsDxRcR89z?=
 =?us-ascii?Q?gGMz3xJw9+zl8dYAy5URahgEOl/bLCcrH70mm4DSRNZyddySf2gkJtX7qmb1?=
 =?us-ascii?Q?Rge1QHaoJ+HicBmgm/u76rZNGs/6q/grK26dAOu/RQNbYzRJS89CSLBuhCkE?=
 =?us-ascii?Q?zlFzLcdW7PDHi5buEe/m1C3oXN+qvioS175oCPoC2b2u3xskQqCzlEu8g69P?=
 =?us-ascii?Q?dkyB7OPEqdNiJvYpPHRI/no8IAfC6a/mNj2oo/5Uw9ajv9Mdup+bpYdQvQ/A?=
 =?us-ascii?Q?MjnnWe/jYOSyDwa7+ItKDRCEH3IsrbEk9IY8oVpmArJTO+dt/wRafkRaE9r9?=
 =?us-ascii?Q?4d6cd6+e6XNJX1kwDtgRNAh8mDx9CgfYQdSZU9YlbxLECdyKBMnIVwPZ/3su?=
 =?us-ascii?Q?cQ=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB3367.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 263c3300-b452-48c7-1973-08d9c501fd0f
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Dec 2021 04:17:37.9494
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yp1QEnWZhFi6n2lEQ72SumKSmgzqJAzCz1Du97E1e2/mxXcZs2kEuA09I2TRrcU0a/mQCBc0rfjOi++jMTpsPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3574
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of R=
uud
> Bos
> Sent: Thursday, October 28, 2021 8:05 PM
> To: Brandeburg, Jesse <jesse.brandeburg@intel.com>; Nguyen, Anthony L
> <anthony.l.nguyen@intel.com>; intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; richardcochran@gmail.com; Ruud Bos
> <kernel.hbk@gmail.com>; davem@davemloft.net; kuba@kernel.org
> Subject: [Intel-wired-lan] [PATCH net-next v2 4/4] igb: support EXTTS on
> 82580/i354/i350
>=20
> Support for the PTP pin function on 82580/i354/i350 based adapters.
> Because the time registers of these adapters do not have the nice split i=
n
> second rollovers as the i210 has, the implementation is slightly more com=
plex
> compared to the i210 implementation.
>=20
> Signed-off-by: Ruud Bos <kernel.hbk@gmail.com>
> ---
>  drivers/net/ethernet/intel/igb/igb_main.c | 20 ++++++++++---
> drivers/net/ethernet/intel/igb/igb_ptp.c  | 36 ++++++++++++++++++++++-
>  2 files changed, 51 insertions(+), 5 deletions(-)
>=20

Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at I=
ntel)
