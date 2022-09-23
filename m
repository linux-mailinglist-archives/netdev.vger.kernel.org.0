Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8406E5E712E
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 03:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231732AbiIWBKG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 21:10:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbiIWBJw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 21:09:52 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20AF82F644
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 18:09:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663895386; x=1695431386;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=wfk6jgoOag/q47Pq1u5kGq5BTc77zG6CQqbMan8SQz8=;
  b=TiYSSna1qzmLMXHDXsnrgJ18YIKUWXQvU9VTym3UY1rh0RqFNwg3hzFH
   2acFqFpKG8bNM532EwKGLKNqP+gGFLzUte5lmHnUVMsBGkTsUhv5aOZlf
   2J5vwsd02/se14/zPvjFssfNvLxYKBPDVihcBkQCWly/n3aHpWcCzJlNA
   Xgi0Lo+rkPMgzC4oqwyVyd9gByr1tbaByckCno72aXk724S27iPGUZAbA
   R3X2TkXJmG/HfRqPpZep2l0/jEBGLj+vPqHvalqLcYXapA7h7cIn9KGUu
   9NDAfRXyBLGLmoq/7wNgCpaVWo2pDIwYOW2ZyoQ3e5gjU+bAFumpOdu+r
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="300464372"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="300464372"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 18:09:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="653220324"
Received: from orsmsx601.amr.corp.intel.com ([10.22.229.14])
  by orsmga001.jf.intel.com with ESMTP; 22 Sep 2022 18:09:41 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 18:09:40 -0700
Received: from orsmsx601.amr.corp.intel.com (10.22.229.14) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Thu, 22 Sep 2022 18:09:40 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx601.amr.corp.intel.com (10.22.229.14) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Thu, 22 Sep 2022 18:09:40 -0700
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (104.47.73.174)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Thu, 22 Sep 2022 18:09:39 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BRfWE9CzrxJ4ulWx0q+6OxhQ655zFcWGux1CQF61sXWJBRMjRVB5Qh8+Z0II6aRICeEuCmpAnIK9mwXqZlMQSzyRYTZaeHMutvec4RIf/pe1D3JuHyjW3J3Cc0Z1/wsEVWLx7NgFeMPVBCw9+e5hHjdvqNnXYX7/Ls7FNGHYjQMjOSJbC3gJ63o//rcN738OeeQILBeGucU2tpuCMn+CMhGKaHfCehcPKkqnx6sqAeF3DW2AUYodRF8/csQQbC2liZAEtdMYYC9mu07GphrJt4gHYWLqdSD9oxULMkjf6jXFB7M0qefjedEIR8qED8c+AAW1sjGFpCazm3jsZ7EjAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+ewZGzfB5SfYOEoSKkhypxFEXknd86X8MYgdEkhjc7g=;
 b=J1MLJ3IfS6//xpnJ9qdIapVW5nFrazqUuC/fFbHjArpEq3rSa1WanfsjfYGTamopM1Zb2PyRCsIxHjXJHyNTQBsq77o/vXOwuH2NIDNS1KbU0X0XSxkfIYTrdp10FOEoN3IdmChpYyzauDURqx5asyJwbEF0UQQbEWKIeDvjoqqlIgNqSPwp63U4ZHp1d2rDelzWlO7DFqikQMC91IPQW4Ofhj3n7onIns17WqLVyj5De9ohvY6tQGhN6H8wM912L0u8F2pLa/bjG99h3o8tFz6rcmritNz08LcWCRqdKaBnUCZCFu3LWcjADC5IajqTjTASEK6u18QQIxeXUtMn2g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by CO1PR11MB4868.namprd11.prod.outlook.com (2603:10b6:303:90::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.18; Fri, 23 Sep
 2022 01:09:38 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::a0a4:bd71:e7c9:851a]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::a0a4:bd71:e7c9:851a%8]) with mapi id 15.20.5654.019; Fri, 23 Sep 2022
 01:09:38 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next PATCH v2 0/4] Extend action skbedit to RX queue mapping
Thread-Topic: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
 mapping
Thread-Index: AQHYwyBaPBOhs3BGO0uGs2JDALv3X63qa3KAgADC2YCAAElGAIAAzejw
Date:   Fri, 23 Sep 2022 01:09:38 +0000
Message-ID: <MWHPR11MB1293FB462DB6021E6B2916A5F1519@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166260012413.81018.8010396115034847972.stgit@anambiarhost.jf.intel.com>
        <20220921132929.3f4ca04d@kernel.org>
        <MWHPR11MB1293C87E3EC9BD7D64829F2FF14E9@MWHPR11MB1293.namprd11.prod.outlook.com>
 <20220922052908.4b5197d9@kernel.org>
In-Reply-To: <20220922052908.4b5197d9@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.500.17
dlp-reaction: no-action
dlp-product: dlpe-windows
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MWHPR11MB1293:EE_|CO1PR11MB4868:EE_
x-ms-office365-filtering-correlation-id: 973a7ed4-b104-41af-ed84-08da9d004990
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: db6AZozgTgA5IvI8rK6XgI26PgXLgtdqV7HGdY7rtv13mmdiagL+XKn4tFuiyE/quVq/vc9xjFAKdx/girbvjXpk1XytiHKGFob8g9fuG/dahujJbgDuVqFbdqwY1AYzP9sjC5neTeRaGV7rNVL8e4YYWm+AWeUWBJkImVjA35sakyhMd9IweG5O6Qx1VBkVnTNYpHYLeLI04DAbELfy+hJsGmvBSruhcbMSeakEw+4hZoADomyQox2uLUW3GeMhe+MmHNyVA4+IRp+/x6e3PJhsa7waTPzCkYmr6g7gI+lmDTDTfybI8iReO40CDLSgLsrBZZOPKrv3JHVs3YHbnAueHlw5a4Jqb7fprAAEhIAYLt4BYh4fJI0+jdLPUdFnHsVPEeysBzmn7NIu8w5+Zt6KohXPoI0DPsRGOxH1ItcwQmRrDrgdxtVdg9wMwhwYF9zJq/iBASTJkfJI4iwBD/cczzI2DqFaa78Hs0xwQ4VvRNYdDmA4CM/+HJsDw3LcTvTOUfoRH1w9kKKlsJP4Rg/afmKu4OfAYfIbefhdTyDfZzeI0O/9sZG0+7AZIwFaABsjz7EYMT1dnnaFfG9VxgWnZJHBjV5VUiyhJsEEGDoK+9/hy5I1hgzT0su7qv+oaQ/VXd8VS7UdVKhG11iwNoDo5f1rSKk77KcgoXdtScUbQXsGvQv7HPtPtbkKlB9d6RUq9OgN2n2ijz35dIq/3Zsb7mBmP04VYv5SS0zV+rqafFsz5my+REFwwn+zzFf9uP9LnJ0jGwdilk1KMHwlPQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(376002)(39860400002)(366004)(346002)(396003)(451199015)(8676002)(186003)(107886003)(33656002)(71200400001)(86362001)(2906002)(122000001)(38100700002)(478600001)(5660300002)(82960400001)(6916009)(52536014)(64756008)(9686003)(316002)(41300700001)(4326008)(83380400001)(66946007)(53546011)(76116006)(26005)(55016003)(6506007)(54906003)(66476007)(38070700005)(8936002)(66556008)(7696005)(66446008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?mMe8N/JN1dwOqJ3LuOk+hylIwRekQMp3tWm+Kqh9JbFHLDORksersWb44ajg?=
 =?us-ascii?Q?ix6Bq5S892Y8qGzSu0NieFrNhG2QIMX6iNScBh1MN9VDWoM3q2K+Q94RBIrB?=
 =?us-ascii?Q?+Zkz8HaLsEiiGeSoEkHcc3aggZdUept0UgYZRSHbJdqzZu1WzFonIN61lcDm?=
 =?us-ascii?Q?Y73v2Y2Fm8aeZzbZcQx4eeniqeDkbl6aeyRDwIu04alfaHr/M+e61KxNYCtc?=
 =?us-ascii?Q?k3wEiHuV1+dTM1V/fiEdGWwspgDkM42Tk5vxyqETm0Oc03Wn1Ywx+kCJAhxf?=
 =?us-ascii?Q?6Et6hN21ja2xiRflDIEMc3OFiQyQ9OPtZTOEW4V1GGXlYAdfZtHrENusFk/h?=
 =?us-ascii?Q?JGKq4vcZnRuqURI7WwK8Zhh6ojI2gg5FXW8XJfhv4z+OZxuii4LI3NPoAQ/G?=
 =?us-ascii?Q?8vq2adP8ptnR3d18xv7aqs5HxQ4ZVoDX1BJlgu6s8PVJiYM7xWlRbv2W2J7C?=
 =?us-ascii?Q?gyB7MOkZM6Mey0QTAlUcL3TlE11iHCBolx6RKAH8vRKxhV8Z8tAbni2sGN2y?=
 =?us-ascii?Q?Yqq8Wi5EVRV9dzQQlwpbBMr///wYU0OR/CE4a0+bNww4C4BFfq7+FfUIaznq?=
 =?us-ascii?Q?TCxaG+OmzlwXDxKL76KdAq1NKDe2LY2tb1Wig3DZhi3LohmgeQsZOBZRpvyG?=
 =?us-ascii?Q?iQLfhEB0Qw7gtg70LqDq7zhRPCFcadyY8cVYczaz9qysUUfisENHdAe3gnR7?=
 =?us-ascii?Q?aI8VWDEJ5ml4keEAzbp83r+KUfm5EHAc3tpc8TxEXBsx16iCH05iXL7ygTar?=
 =?us-ascii?Q?AKD4juP5X6W3cS2nbsBvUdIhq+V2F8NlC8v+xGP0PB5LeaWXUR5zfgqZO98L?=
 =?us-ascii?Q?BhsfyMEhiWaUASaHH0l/sM9MmOeYLF9gzihv5peo+ASQRBj3THKFqElZ3u98?=
 =?us-ascii?Q?y+BJ+DPTABS8sNnHfYCThe0vKmy3VQwq3s4cby33gztneScaRDE4dWDn1HZk?=
 =?us-ascii?Q?2e8Is4LjsKID52m9lJdwLnH2/a8c4Dn78uuSLzZQyEu+8zfLv5ocIpXyhJjZ?=
 =?us-ascii?Q?kdQjG7Oj+oAX61lp/1hONA1dd4O1ZTQgocLS6W9yWY3NIWun1hXBvZk1uqfy?=
 =?us-ascii?Q?aQ52g86BlIaoX5z6cMM99kx8HGirhhxDXGCctKfBQvoxxCfoKuuBHFv29YWU?=
 =?us-ascii?Q?b7lQR2gjb2y5Ga21em6hJtOWhiWNKAi8X/cmWyynaqwdB2q4qNow7CJevf4b?=
 =?us-ascii?Q?X2wsCW84ORqTwoD9biggnfIhGYqA10khpIIF+2tAFDvzjEvdrGPHuUCCZmUp?=
 =?us-ascii?Q?gBqZ3lE4qRhek7aWKBTMAt5PPH0Sxm7MjfSWKSXjBEqeNsdLTBO6pW8qNei8?=
 =?us-ascii?Q?dS4dq0ZANqcemKyziBG5ckYkYBmBJAeMwkKvcIV+PerXH53RrTHwRYPjoqJC?=
 =?us-ascii?Q?xzq8hTkzYUJ7v42CohrtX+0JVEqB7na/vOh3VrHpHHL2pn9/M05ylIx8yZZS?=
 =?us-ascii?Q?grIABOiplNLQWVUpAC88rVEIO+i08cmkKTeREbIijAIFC1/tzaagJdhhOU/5?=
 =?us-ascii?Q?M8OxSNFMEn++CKpXAh9zTqEpu2CtyiJVXJcVIdLZo7brplteddpj3fIUXVZG?=
 =?us-ascii?Q?FKVXomVLRi1Xsv0sRP6JV7v7eL1pRQyG7n/jPOD8rP3vZgXj4OBDLtkkG5IA?=
 =?us-ascii?Q?Qg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 973a7ed4-b104-41af-ed84-08da9d004990
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Sep 2022 01:09:38.5673
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ruYrQxjkwoY/zV3QHWdwqnvH6nCF/bsypjdARj4tI2FPucfq3bhEZ7LFpJTOYKs7L9ZLYk/80DZ9Fw3/Sy9IksahbUdDbd84QlX1HDB3ROQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR11MB4868
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, September 22, 2022 5:29 AM
> To: Nambiar, Amritha <amritha.nambiar@intel.com>
> Cc: netdev@vger.kernel.org; alexander.duyck@gmail.com;
> jhs@mojatatu.com; jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes,
> Vinicius <vinicius.gomes@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next PATCH v2 0/4] Extend action skbedit to RX queue
> mapping
>=20
> On Thu, 22 Sep 2022 08:19:07 +0000 Nambiar, Amritha wrote:
> > > Alex pointed out that it'd be worth documenting the priorities of
> > > aRFS vs this thing, which one will be used if HW matches both.
> >
> > Sure, I will document the priorities of aRFS and TC filter selecting
> > the Rx queue. On Intel E810 devices, the TC filter selecting Rx queue
> > has higher priority over aRFS (Flow director filter) if both the filter=
s
> > are matched.
>=20
> Is it configurable? :S If we think about RSS context selection we'd
> expect the context to be selected based on for example the IPv6 daddr
> of the container but we still want aRFS to select the exact queue...

This behavior is similar on E810 currently, i.e., TC filter selects the set
of queues (like the RSS context), and then the flow director filter can
be used to select the exact queue within the queue-set. We want to have
the ability to select the exact queue within the queue-set via TC (and not
flow director filter).

On E810, TC filters are added to hardware block called the "switch". This
block supports two types of actions in hardware termed as "forward to
queue" and  "forward to queue-set". aRFS filters are added to a different
HW block called the "flow director" (FD). The FD block comes after the swit=
ch
block in the HW pipeline. The FD block has certain restrictions (can only
have filters with the same packet type). The switch table does not have
this restriction.

When both the TC filter and FD filter competes for queue selection (i.e. bo=
th
filters are matched and action is to set a queue), the pipeline resolves
conflicts based on metadata priority. The priorities are not user configura=
ble.
The ICE driver programs these priorities based on metadata at each stage,
action etc. Switch (TC) filters with forward-to-queue action have higher=20
priority over FD filter assigning a queue. The hash filter has lowest prior=
ity.

> Is there a counterargument for giving the flow director higher prio?

Isn't the HW behavior on RX (WRT to setting the queue) consistent
with what we have in SW for TX ? In SW, TX queue set via TC filter
(skbedit action) has the highest precedence over XPS and jhash (lowest).=20

