Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C773FFA79
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 08:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345599AbhICGii (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 02:38:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:2889 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230128AbhICGih (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 02:38:37 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10095"; a="216202901"
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="216202901"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2021 23:37:37 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.85,264,1624345200"; 
   d="scan'208";a="511355876"
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82])
  by orsmga001.jf.intel.com with ESMTP; 02 Sep 2021 23:37:37 -0700
Received: from fmsmsx608.amr.corp.intel.com (10.18.126.88) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:37:36 -0700
Received: from fmsmsx604.amr.corp.intel.com (10.18.126.84) by
 fmsmsx608.amr.corp.intel.com (10.18.126.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 2 Sep 2021 23:37:36 -0700
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 2 Sep 2021 23:37:36 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.103)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.10; Thu, 2 Sep 2021 23:37:35 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CrgIz8KFyePqFHv5Aqw3XV8XflBSGM3kttOmHTnmbEDaLJGcJ4QayBGDTEcPg91WS6anqNplx/BnP5qIUn94O29FQHhF+SODpmC0L/+wfsy6lXadDAia6g8mua3vaWW3QJngs0f5OjXzy0KGxKB8iTTp4emTKZhFy21rPrZNScszrbQI8SO4xMLwEaEM9tSNZCo6DoH6ZJK38m71KVI5iwAU0dS7mS+zXz0U/e5KJBojDCMSADY2Dv7To7nxQ4cXtTN5PVsiAv2t8xcDzY7cAbIhfS+9Mv/014IvXeSpTUAQdzorNHgYubGGhwSmfSK/V3LHPSJicU/M715BK68pAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=TbhKoIXLai8Qd0rtLlCxNO04fPq6zIFi61T/RS7VkS8=;
 b=MZGY7dv/CVu48F2PrpJRQRVtLyrdvjB6yZh/d3PODV3hNfnx9n/8dMOoSDR0Lxagjmg0gkaRMoUoLXCPs5a10iLRr3bRq60BJxdXIoFLbZcTHjIouQ9/3RUFmoUxADeBRtVpGLPYoGb8tEjWaPX0c9zebearL+X55KQxQP/t5rZoxZx3l2K7dMHh1qWLw6eXrRB/QHI4q002ElkzUkYfxCAAjWJf2uuYu8cn0fpxM+TbGQSdzAq7hSOajMkq0lZP3aR84QDULaexUeF2M3+oxcD0WwndCdILDTomJUX2huheh5xuANQEIlvaMdy+fEYcU+VN7kupf+WWKzjNm/5cAQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TbhKoIXLai8Qd0rtLlCxNO04fPq6zIFi61T/RS7VkS8=;
 b=M8GVKTip0IkJ7Cq7ZLbuQPG1kcnc2ADNLcwjP0zzVcrOvZGEXdmQEajZ/cMkF/asTt8raBxka7qo5CC8ouggDz5S1bAZrREAoRkxaHaTF62QkayKMC7hO1t7gIQJnaHTH2onM6A3edD/B1tiCKIifwTjiMtU8YtkLAhTR/vqgko=
Received: from PH0PR11MB5144.namprd11.prod.outlook.com (2603:10b6:510:3e::20)
 by PH0PR11MB5191.namprd11.prod.outlook.com (2603:10b6:510:3e::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.20; Fri, 3 Sep
 2021 06:37:31 +0000
Received: from PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885]) by PH0PR11MB5144.namprd11.prod.outlook.com
 ([fe80::105f:b75f:c95e:f885%3]) with mapi id 15.20.4478.022; Fri, 3 Sep 2021
 06:37:31 +0000
From:   "Kuruvinakunnel, George" <george.kuruvinakunnel@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "joamaki@gmail.com" <joamaki@gmail.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "toke@redhat.com" <toke@redhat.com>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH v7 intel-next 4/9] ice: unify xdp_rings
 accesses
Thread-Topic: [Intel-wired-lan] [PATCH v7 intel-next 4/9] ice: unify xdp_rings
 accesses
Thread-Index: AQHXlPP/ZEGLNWooXUu480nb0gYvq6uR8dVg
Date:   Fri, 3 Sep 2021 06:37:31 +0000
Message-ID: <PH0PR11MB51448229AD1C3E3DFCBA97D6E2CF9@PH0PR11MB5144.namprd11.prod.outlook.com>
References: <20210819120004.34392-1-maciej.fijalkowski@intel.com>
 <20210819120004.34392-5-maciej.fijalkowski@intel.com>
In-Reply-To: <20210819120004.34392-5-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.5.1.3
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6042d62f-836a-48a6-c9fe-08d96ea54e89
x-ms-traffictypediagnostic: PH0PR11MB5191:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <PH0PR11MB51916F49D8E5CE62122029FBE2CF9@PH0PR11MB5191.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Qk0z9dEEZc//0Ek/p2miTkPlgdtwsv6rN18dowzAhndwsCbgtDNnC7PqjuupMj22yKgzT/AeZYeJO9QHYcdqRgpmuYpzBFogqwNTT34QRhQlmu/ixqjtFsHqU918XPPPyb98cxBt9wLXqJffDc42uVjPgEvwsO3W0/W87BevUgrLFkctUYnTQToAhvpf2EVhCkX3Z1hD0ca4mX/2OJ9fLCEXjP/fYxq7OScZNeYJpnV3Af3AfSYlGzWR72FeFldJsoNrMbUZBte9yywmezYImbTi4p1f4qNMTGzXc1zwpOhEorXDtx8MbGqBsVoG6UOabXMsUlktLCfyzxg2U6xDMRDWWsCtHJi/0o8Njl1UAfp3q1g1np7GMaE0BYGmdjcuCuvuGJnwWauC7YdsTQTkcx9QPs+df2wKIDbVt6/EawZsGZO6Tkq01cwB6B15YtpLo1tW2zqFLTCpTmUDosq7OtRXyZrp8GQiZFqDTtkQbj/iU6PXJakzWBUTb2WfSRVpAAc1i1h56uxuwqfJjUnCpWP8zZ28VhKC7PqcYrM1JFTjQvit2YStfPRCRjlfrdHbsvzozXCwJ+qqmLm2SWYqnkfvBIu83ljvWFfthEscGZTkzDZlbiL7rTIfw/W6mLnlZ8FeMGTud8aQjL1X+7icTnqC7acl0pgDYdfCo36TOBxK2q2jS3KivVQS2aXcuZ8nmwqv8mzbVWpT9KNjEYwxx6gv+0D8TMhu6HQDlmVYFFU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5144.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(346002)(396003)(39860400002)(376002)(136003)(66946007)(7696005)(66446008)(64756008)(66556008)(76116006)(55016002)(53546011)(6506007)(66476007)(8676002)(122000001)(71200400001)(54906003)(110136005)(478600001)(4326008)(38100700002)(38070700005)(107886003)(33656002)(186003)(26005)(86362001)(316002)(52536014)(9686003)(5660300002)(83380400001)(2906002)(8936002)(557034005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?XmGmuxG5oS0AVOZ+1a7kuDlP379fR7FZJ7REW2Tc+RHQC/Zlc/io3klood5S?=
 =?us-ascii?Q?x1diJqjMRThvDiYL3vB5O/tK18S22WswUsfc94MalNHpDHHsM6VukhYWVgwD?=
 =?us-ascii?Q?0bI+LyvV/2zFdXWyfsBa/lEQZkfjE/j8qO+E2Hq/Rhi6Ln0goqYub4/a97C4?=
 =?us-ascii?Q?x1wo9609uB3zMTUPWApNkNha+zA93mhQ9Segu4YjYhqalKq7YAlZa7yAklVz?=
 =?us-ascii?Q?stuSbfimoroRj55BOVuQgPUvqedmDmwa8XeTSx9WfoSWeo3MKwqKjLHv7DpM?=
 =?us-ascii?Q?vdXnFjelfjPWwnp0RTcS+V8Fje8L2oedKYE9sqASEbpCmO5mQvHXrwp9V9ee?=
 =?us-ascii?Q?WSAYAopCDU5yXA/41Tv2Eo9hae0cGH/dTxgWe5zotsdH0y7ClfaMHnIYjoG4?=
 =?us-ascii?Q?Twigu74Qa0FySHA+0EsS/r63DX+NC03rFrtvhrSo4sj2DoACDxqomZUKJGGt?=
 =?us-ascii?Q?HSAab4jtDalC/hxCD6DuHrVVXdfN9/hv/YeoDkpFh0ViISy7NMc6YN3GTfdj?=
 =?us-ascii?Q?BkSCCoKKMK265vRa1D2OwnlyNQnrYpFxrGmJulZpNqZ9RpWB+TwEtO4Wzv+X?=
 =?us-ascii?Q?rNeMtm1pBE6QU92LTwKUpuyontv7QtM4KLPzKO84vSRmT95lr6zEqpMOSP6N?=
 =?us-ascii?Q?GRmdcBBkN8ZacvotG67aG18wUNUs9SXrStZiEv79K7Y9zWdUPtPJEUpLZGLo?=
 =?us-ascii?Q?OlItBlzqRzVIvy43INQaTA5/30RhgFi9NoqgUeKtLov8C9/lcBUf1Sd13c8w?=
 =?us-ascii?Q?U2MlXTInoLevJ6fK7i33nT+xAB8bIWFq1oCS6MPGvxRyA6ZolBlTt2wBfS7p?=
 =?us-ascii?Q?8HE+4NC8oOZOmkKUkzJwxoDU7J8iZAvy9kn4f1UNk6PB2P4fGNgD9bbncV9F?=
 =?us-ascii?Q?AB57eutBtkL6zFppZJ+PcZAchIbSH5Eckwu+wovyTiw5Dl/H9VMlXpSQ5UX8?=
 =?us-ascii?Q?GSJdJbvBcSn/NtcSrUC6pRVKKkQ78yf0ybIJBkGhYR9LEe3hyGZ2/WEIwt3O?=
 =?us-ascii?Q?zTvIghw0j5/7tfFVz4nyTHqVlhVC1uwh5Dxv0ZWmA5gE5IuVMChkMlTAdWyr?=
 =?us-ascii?Q?EzkWI4ql3IVCh8Wvc64qQt42ouOw2y7WA8k5SoUDBmBrI1wbJoRIBloRB3Fh?=
 =?us-ascii?Q?gVMDF9TmNU0W5oaiXcyhFyMxUn7720UjSDYc7ZSQe18o6ZVq5ptLYJx6fnsJ?=
 =?us-ascii?Q?ADsk+xKd+zFFSw2uKJ/gEon/ohIJ8KRqP+D1utvsFHzr8o9OaoxLpCNAm1HQ?=
 =?us-ascii?Q?RcKWpoI3oIJF57M3rKPBjNWtxUO790nBwzmr3rF7oOU97lruRihfN6dLkMYy?=
 =?us-ascii?Q?tBM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5144.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6042d62f-836a-48a6-c9fe-08d96ea54e89
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2021 06:37:31.4315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: de3YYupiAR8KQjJJ1VIsEIr97SR1TkGYuzOmErdZkJSJ3vKDA3rZkVEfUT+IEusI4EmVsApLtJltIkd0QHj6xU+T27kRg9LFWq4geDwla8E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5191
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of M=
aciej
> Fijalkowski
> Sent: Thursday, August 19, 2021 5:30 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: joamaki@gmail.com; Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; toke@redhat.com; bjorn@kernel.org; kuba@kernel.or=
g;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH v7 intel-next 4/9] ice: unify xdp_rings=
 accesses
>=20
> There has been a long lasting issue of improper xdp_rings indexing for XD=
P_TX
> and XDP_REDIRECT actions. Given that currently rx_ring->q_index is mixed =
with
> smp_processor_id(), there could be a situation where Tx descriptors are p=
roduced
> onto XDP Tx ring, but tail is never bumped - for example pin a particular=
 queue id
> to non-matching IRQ line.
>=20
> Address this problem by ignoring the user ring count setting and always i=
nitialize
> the xdp_rings array to be of num_possible_cpus() size. Then, always use t=
he
> smp_processor_id() as an index to xdp_rings array. This provides serializ=
ation as
> at given time only a single softirq can run on a particular CPU.
>=20
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c      | 2 +-
>  drivers/net/ethernet/intel/ice/ice_main.c     | 2 +-
>  drivers/net/ethernet/intel/ice/ice_txrx_lib.c | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>=20

Tested-by: George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
