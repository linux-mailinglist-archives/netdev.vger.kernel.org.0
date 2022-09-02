Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 308B75AAA36
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 10:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235508AbiIBIhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 04:37:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235816AbiIBIhV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 04:37:21 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F36DE6A492
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 01:37:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1662107839; x=1693643839;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=z1EODS2cdVkj15Vxvpr+9sVLbukLGu8MYRSq1F41QTs=;
  b=h+BUO/M7Aqp0GFToOEDdHEOuheyhJtnX44C4xIUT1mf5ZH6yRhvyiWpG
   qVL2chEcVorcCCufegnmtTv9HQ/L5Wr27PGZrsaW0JEYdjDCb2TCbyF+J
   YX7AG3KrdbkoRX4oGRepwbIRbP3dzsEIKSY+v1QPLK2NMCplfvihjgLh6
   6mWFdCjGM0HdRWthQXs48WauK2GUqqJBVJX1fbMJcirgdMCkFwqobZPYW
   fontdIDWiJH6fLHJIlG2/f8DAO/Fih3gJ1XcQyM+tlMgWvhCzaByiZi2p
   CEEDFsB8Z5ahwyFRMZ60uSnFnP+URyKEMBvH0Ysmzx/c2x+Wk84R9kSRh
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10457"; a="276336690"
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="276336690"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2022 01:37:19 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,283,1654585200"; 
   d="scan'208";a="589997363"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga006.jf.intel.com with ESMTP; 02 Sep 2022 01:37:16 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 2 Sep 2022 01:37:16 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 2 Sep 2022 01:37:16 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (104.47.57.175)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 2 Sep 2022 01:37:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fEnXgVehG++znisdFhQ+g5QHKYSL0buG3StPqFQE0WvOIrZUhZOnFAGY0xlONypcxGy9J8tDIx2V8UrgN70S+aQqlAyUJgx5zlFByAGbrMHPuqt0Q458pklDlIcLKgojXuE4YglHNj86GXQo02wNM7Gqa9n85lvb50iPcdA7GwmC4wiJDOItjoy/9DB96sliLaVgvTJ0bhvaXVjDG0aQrWXYXiIpfCkuAlgXRM3ZtjTflly3vlD4pi8JFwzWeq5xZHnIF67D7flxcV7DG30bZDp/QqWlDNCgIRgsTRSXVLV1Wx3nG1KXLpoHH7x47dwvPTWJsdBK0IVrDYs2RKmXrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z1EODS2cdVkj15Vxvpr+9sVLbukLGu8MYRSq1F41QTs=;
 b=Y1ML75zA7JDY6eU+UyzY89llzkOjfRfBLl+Sb7qoUwk8beyQ2Ed6Diu/yPy4PLS2n94p63Luhl61CrrIcWXY04jUEfLO/AVSt+gCFoHUxWGDHWAJYfMwLk37Nwt3ZI/tDw4RK6fzy38tQ6YAhDpQj2L/g1nw9gp3CYWngW/0ySrsIIrLMZcIDa9NZRN60qummfloZw/1NkD+uKQAotWKL2S2fXqJJ3XkyMc+VUEPqpodOVwhGyXhmthvfj7uBi4lKOuwNpR19mEgNrNm5r9fesrNZaRcW2zwnshYlL9icQsfmhNrme/XlSfyVyW3EW8o1uXXObzxtPjyaAq8wJJX7Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from MWHPR11MB1293.namprd11.prod.outlook.com (2603:10b6:300:1e::8)
 by SA0PR11MB4573.namprd11.prod.outlook.com (2603:10b6:806:98::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5588.10; Fri, 2 Sep
 2022 08:37:14 +0000
Received: from MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51]) by MWHPR11MB1293.namprd11.prod.outlook.com
 ([fe80::95e3:8cbb:2a7b:ae51%7]) with mapi id 15.20.5588.010; Fri, 2 Sep 2022
 08:37:13 +0000
From:   "Nambiar, Amritha" <amritha.nambiar@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "alexander.h.duyck@intel.com" <alexander.h.duyck@intel.com>,
        "jhs@mojatatu.com" <jhs@mojatatu.com>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "xiyou.wangcong@gmail.com" <xiyou.wangcong@gmail.com>,
        "Gomes, Vinicius" <vinicius.gomes@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next PATCH 0/3] Extend action skbedit to RX queue mapping
Thread-Topic: [net-next PATCH 0/3] Extend action skbedit to RX queue mapping
Thread-Index: AQHYvFLjmRuBSRgAcU+kpo6w+qse363J4VeAgAHsA+A=
Date:   Fri, 2 Sep 2022 08:37:13 +0000
Message-ID: <MWHPR11MB12933087A1354A97E6F9440FF17A9@MWHPR11MB1293.namprd11.prod.outlook.com>
References: <166185158175.65874.17492440987811366231.stgit@anambiarhost.jf.intel.com>
 <20220831194611.4113660a@kernel.org>
In-Reply-To: <20220831194611.4113660a@kernel.org>
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
x-ms-office365-filtering-correlation-id: ccebffdd-200f-456d-bb72-08da8cbe55c5
x-ms-traffictypediagnostic: SA0PR11MB4573:EE_
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: r3omeHPQhyKuKD6+/x8ymCiS/LJkUfE4eNgJvfP0dPtj0tYGBvSMlxJoZCRfNy15NSYnwdXBKF1/CpGfGuLLLyOaCd4cJXOUs8UZlHtTcZz+Kcwsht6uH5IQJ1XFZlwDtXgx4C0VUplY9kb3S25QijiWtgxQHQOxFVXPuhQPHYPIi2/wFOyXyQGKlx6KwyAroCj2q5mpwdmkDELDGBiXfyCk4RrW9AREr5VtkEqsGxCzG/JLYDg6+C+9jIYeO8QqiMdJ0FCGVyXNCCkP+KZONqyCOVP41q/904ZO91+1e66B9lTGcZyHWZVVmW14AFkVaUG5htLXQocRAJdyRcKBdbbK+CpD0uYCk6HMfGPTGNxV5BmQ9R28aitztYblY5ohEB6HhPqSW0ctEYr1wAszgyyNA8xsIS3TG+oBYBrkwjRMfmWQYmReA6jWaoW94HVJuZXFd+Vin4KAwZpxRLNF3dg8lds13Szly1rnpWbTTJ+/L9F6hwdNz/ncfxFV/5jptsv6SGd8XfjzaCUlNBn846vapH9z3XS8npQrcXQzJVF2MU48gdOisZ3QAPpvPRvzKOlmAHH3OR+TOkhx/Xg3ZFsKdU+lX6odcp+PQL9R5QvT97AsKHFSYqfy9DUh6FrnQY2c6RABfMLOS47zg5PyLCLHg3VbD2udIh5t+/QawBTHa8RLsmeFcZGe7bmPSApt898sUAtp+QCxlTiwnSmD+p0voiezBUxtZ29cSuh/tZAoAOYhDO54Y+gT3K4NJjjhJeaBy9wqRjZrAfPxvdNcVAKtwzc9HuE4s8qwYMSwyGQ=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1293.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(396003)(39860400002)(136003)(366004)(86362001)(38100700002)(82960400001)(38070700005)(8676002)(122000001)(64756008)(66946007)(478600001)(4326008)(66446008)(66556008)(66476007)(55016003)(5660300002)(6916009)(966005)(76116006)(54906003)(71200400001)(316002)(186003)(83380400001)(107886003)(26005)(7696005)(53546011)(6506007)(52536014)(9686003)(2906002)(8936002)(41300700001)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?8P3rPdgV7mQf0UXuuL1wHDs/cbEqjsG8uC0vElUjMNrnLpBfPqHNHibgfMDo?=
 =?us-ascii?Q?lZAQ+4NfLeMtbqvs2zTKJWs/iaXeFSkarMl5O2Nu6WOXXaYmeLmFltA3SIVD?=
 =?us-ascii?Q?AhjXuBeHLQ2nT9rvSyP/Gz7iR6t3K6CoaAK2KDbgiwkv+9w7PKgukHkUZ2g8?=
 =?us-ascii?Q?06hX+v1V9XNEzJl0qIpt0rVmMpsoIm2etR3aqC80yTYrj2jRRN432lMygxOl?=
 =?us-ascii?Q?ZkEULxU+DkdQSrKBzgtmkG5lFtwdfIrHK3XqzGLWr//SnDzaEcXck+Z9kalL?=
 =?us-ascii?Q?C9guR2L3PO+2rgryLa18DyA9Mepv0BYBNmHQYckC/wZMzAHX+Y3r3P0v3MFf?=
 =?us-ascii?Q?GPAgMbyjdjB7iFHve3DDJ7VoW5nYJDxMV8rDMZW/YENHAzC+YzodAPBVqae5?=
 =?us-ascii?Q?VXHzxQ7EyYI0hxtGCrSa/VZ9nmvCC170GOFq5mu+Z5ISuVE5p9DqwGHfCv3l?=
 =?us-ascii?Q?+PxhxD15Gsu2W5hh87FWFCXtxDLmBpUVHw1PGKEAzVc1TDC7LzE1+SqWqmGU?=
 =?us-ascii?Q?7VLAE6xyOuFAsG9l1BJx+qhyPIyfDYqo+OpJWmpyawB9EK02MIsomFfwtCkB?=
 =?us-ascii?Q?ueOSYcSXZUCmcLg0sBsQr+H+I+wDu2kgDPxlkecdJ5U20q7c+bjhflyRFpHO?=
 =?us-ascii?Q?ORySUs0bHKxK9wC4rR4Bh53T9MghTL8m8/XcvWv0BIM3IKN6oOJcbY2HEJZx?=
 =?us-ascii?Q?Mpx8ljLonGbWACjUxsSpsAI6i5yQuon8L46apEUltebd8xTRWt8f2FKQ4hLr?=
 =?us-ascii?Q?WS1jYlqJ5XB7LfWNCnvha01LF4U94X6y9zWAqgD6PwZas4FBdONBDY8uesaT?=
 =?us-ascii?Q?C0l5f7N4uMZKKDFPzOaVl/xwKS0ygCO/iduL26Aw1n9ZP7I/lHCYynyvc1Gl?=
 =?us-ascii?Q?nTbzseFy2/m+vTVHu8H9BvMXr4TBkrSA/xfFAAvoZfYFwGU3+d88cmn+isFP?=
 =?us-ascii?Q?5mkEpdLSliC0b/4UD2nVRiRjNBKuwYKf+u8NqaAR90MUpDny6H5Oo5Rcsyi5?=
 =?us-ascii?Q?ZoYzi1PLQrqR63CGR0q0vANff5LoM1gLM4rhPNt56ozykJiYN8leR7LzZKHx?=
 =?us-ascii?Q?8ckyGtD/GePAVMtl0QasO0SV7ARLqZxv5m4+Sg9mJb3gA0i5UX62ZmPVxnDF?=
 =?us-ascii?Q?aWJ+s8KIsfLPsP8nh6h9SklJv9/vm6HKpHhPD3pGr7VrnKuIpFRNc/WlYObf?=
 =?us-ascii?Q?f01u4sh+Mvt5fTiscVNR+Rbz2yb8pEOKRG9+VVtOQku/eMicvpRbyCHsx/fx?=
 =?us-ascii?Q?C0D1g/J8O13WD4ixfomUE9KKnpadssiXk6Ka6Z1JTcy6kSqQHjtYBolIV38G?=
 =?us-ascii?Q?Yw7uRftjXYtdFunDj2GKJeGoRaySJv84sjnByw7lfgc8fxGXtMIJVyObo8KI?=
 =?us-ascii?Q?Hi7nzWlhbfXpPbTwbkVoZwkT5LsKZowcDYdInRU0F2vqSjTqHBU9ZWnvHbFp?=
 =?us-ascii?Q?AxRpnEjKOwxh/PgXle3Je1fSdprTAQ7lHrq5oqcY8JRpkWKAd2ksi63ftRLf?=
 =?us-ascii?Q?cvXtUBPlGjD4+O3bPWprDXqyyAQDJBcvYzxWj/Ql6nwsrxAduKOcAOiw1S9H?=
 =?us-ascii?Q?My9qsVSmEC0PaoPbdmvMKiU8HHraWorS7XlI5oFfY7AC9IsiFs1uGPtInPKE?=
 =?us-ascii?Q?xg=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MWHPR11MB1293.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ccebffdd-200f-456d-bb72-08da8cbe55c5
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Sep 2022 08:37:13.6730
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RMqbmhWdG3ZcagkPjPTacrWrTSfblxagEySGOg9Z5CM4Z+8Atsodw3APA7cQXbIPXX00YA+A8ac6iuUo5bL3QztK38O7oj/O9rzjorIH2ZE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4573
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Wednesday, August 31, 2022 7:46 PM
> To: Nambiar, Amritha <amritha.nambiar@intel.com>
> Cc: netdev@vger.kernel.org; alexander.h.duyck@intel.com;
> jhs@mojatatu.com; jiri@resnulli.us; xiyou.wangcong@gmail.com; Gomes,
> Vinicius <vinicius.gomes@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next PATCH 0/3] Extend action skbedit to RX queue mappi=
ng
>=20
> On Tue, 30 Aug 2022 02:28:39 -0700 Amritha Nambiar wrote:
> > Based on the discussion on
> > https://lore.kernel.org/netdev/20220429171717.5b0b2a81@kernel.org/,
> > the following series extends skbedit tc action to RX queue mapping.
> > Currently, skbedit action in tc allows overriding of transmit queue.
> > Extending this ability of skedit action supports the selection of recei=
ve
> > queue for incoming packets. Offloading this action is added for receive
> > side. Enabled ice driver to offload this type of filter into the
> > hardware for accepting packets to the device's receive queue.
>=20
> Thinking about this again - is redirecting to a queue really the most
> useful API to expose? Wouldn't users want to redirect to a set of
> queues, i.e. RSS context?
>=20
> Or in your case the redirect to a set of queues is done by assigning
> a class?
>=20
We already support redirecting to a set of queues using the 'hw_tc' option
of tc-flower. From the man page of tc-flower:
"hw_tc TCID - Specify a hardware traffic class to pass matching packets on =
to.
 TCID is in the range 0 through 15."
We needed two levels of filtering via TC, the first level selects the set o=
f
queues, and an additional level that selects a queue within the queue-set=20
(from the first level). Hence redirecting to a queue as an action. The addi=
tional
advantage is that being a tc-action allows using other action controls on t=
his,
action chaining via "pipe" with other tc actions, and continuing classifica=
tion
via action control "continue" etc.

> Either way we should start documenting things, so please find (/create)
> some place under Documentation/networking where we can make notes for
> posterity.

Agree. I'll update the man page for tc-skbedit action. I can add notes in
Documentation/networking as well.
