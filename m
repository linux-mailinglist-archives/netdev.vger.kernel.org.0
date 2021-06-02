Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9464239869C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 12:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhFBKfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 06:35:19 -0400
Received: from mga09.intel.com ([134.134.136.24]:46820 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232476AbhFBKfJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Jun 2021 06:35:09 -0400
IronPort-SDR: H0srE3xM651KygVgtus0Wiu8jfiw2TiwpsTPdcAP92z6jp3M6Cg1mNEjohIBjWSdbxij9YM9dg
 RW7dW0wNIXSw==
X-IronPort-AV: E=McAfee;i="6200,9189,10002"; a="203751571"
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="203751571"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2021 03:33:20 -0700
IronPort-SDR: RjaAbV2pMbhdjK2mVUnu60PFordaYgrMRR15MJI9tWcWFcafAnDoGq+I36nGY//F8xEZe29FQh
 PJmplDBSPsHw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.83,242,1616482800"; 
   d="scan'208";a="467412150"
Received: from orsmsx603.amr.corp.intel.com ([10.22.229.16])
  by fmsmga004.fm.intel.com with ESMTP; 02 Jun 2021 03:33:20 -0700
Received: from orsmsx608.amr.corp.intel.com (10.22.229.21) by
 ORSMSX603.amr.corp.intel.com (10.22.229.16) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 03:33:19 -0700
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX608.amr.corp.intel.com (10.22.229.21) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.4; Wed, 2 Jun 2021 03:33:19 -0700
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2242.4
 via Frontend Transport; Wed, 2 Jun 2021 03:33:19 -0700
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.102)
 by edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.4; Wed, 2 Jun 2021 03:33:18 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cu11Ah5giLsQYCNBaxsJVYrs4/MM6pdWDVmH7bxcMtR3DZLqRKezFDE1Da7A2/O3pRkfV3QRex5J8zi7BC5a3+FW0PLBBkdVmKHf/wKzToI62p+JhJ53lr/bYDpZ2/oLMQAgAebRe6etEjCy829XP1bMkXX63izeJ8xhWFtUAK4wV77F/uOVA+2TIeCnbTIaTpPVhldoVxflxE60ivbQs7bkDGWzXxWFRfjcZ5Qdl0hbZIOGofBzkzVODR1FzzA/CQcba3naRm1fP0UXWIePoJOVGbxUIY9I7DGL73HsvL7Zj6KN6wJzcaet0nUNs6tBk4s+h/LebHgYS4yI8oQywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Vqg0U2Sri9q/OX5vYN+wSd7J5ALN7Q05gllI0jjlh4=;
 b=mZBYnekVgWFfrKhG8vWduxfR4U8lAFtaB1YbC2DZpqab2p8ZDmaWiSrmxLJptBEqXRZJoDu49Y7pEr0tg1/cKQ0qY6s9pqjsuVUc531SVcFsTY1dhukkuq68ITksiBIN3DUsIFeUGztLtupC3/elEThn3DHHe0BNHMhwg9auu4DNtJ5fq1mlNPdd9AYiyuyZnyC7du67fbnRoSW8mlmzjepzSkpL3bjBEyGaDoa3I3Lu2iIvS+btULCXqNkDBRr7pzHfQ4FJEm5qN5ZB3kCoNQ2YaXeSQW9/9FrxdSEnsDvawmWMTh15yQs3WMLs7b3/bTjNzd6ARgoqvxKGQ1zpcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+Vqg0U2Sri9q/OX5vYN+wSd7J5ALN7Q05gllI0jjlh4=;
 b=bKsRzacLUmH/5+cfDXPVOzPiw5lrcfmE6vI2revUCycwvSpxYtyHuDzqthCljtBo5s5oNFMR0rW1ve2YXAjNeDIOiFd6PaWlTPtzwTAibdKEnxBElPAJHkoYDICibTwAkmbUpCSI2s9jg4CSmIMvOfgsRalT2l6yg5P9AEfswNA=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM6PR11MB3355.namprd11.prod.outlook.com (2603:10b6:5:5d::21) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4173.27; Wed, 2 Jun 2021 10:33:16 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::ac71:f532:33f7:a9d7%3]) with mapi id 15.20.4195.020; Wed, 2 Jun 2021
 10:33:16 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bjorn@kernel.org" <bjorn@kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-net] ice: track AF_XDP ZC enabled
 queues in bitmap
Thread-Topic: [Intel-wired-lan] [PATCH intel-net] ice: track AF_XDP ZC enabled
 queues in bitmap
Thread-Index: AQHXO6EZgNrl0snv1E+/ZLZ1T6LwTqsAtOng
Date:   Wed, 2 Jun 2021 10:33:15 +0000
Message-ID: <DM6PR11MB3292493370843B06FBCDC454F13D9@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20210427195209.54217-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20210427195209.54217-1-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.5.1.3
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [198.175.68.44]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f84b5e4d-8da4-45c4-2390-08d925b1d4e6
x-ms-traffictypediagnostic: DM6PR11MB3355:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB33556392EC930251C26F245BF13D9@DM6PR11MB3355.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: InEn68yn6NlLLXWFFkrhTTD4Rp05H/PLVET/9yd77s3BJz9zmODpjITYpS1I8W0gkuI8eBAhA21QPdqycTMS7O10GadKjpnWpmqeAj2mzhXcdKLNOHt9T/0xf3GxV9Kn5oPlK0nxnxaY8iTi+wSxK2MqwJ1agIFeICg7jHL5PmDnMXTOHkJBpKm1UcqbwcZ2xB+ppWIwaD/Z+ZD9nvXKVQiIXjo7R3EkI9EO7YRqCGNisf7ZjINiOfpXZqA3iy4pkaONfpJ5Gd7xStwmZZsB0eUM7Bfy1yHZadtuK+3zQF+OsSVnZvLOKI10Inx8WJ4JMYo8K39t4O1mHOcx5yAOJyHoFWYvgCvB9zTQ/XBsuTub/5x1g/fWouSEZgm77AZEwg/8U43EQQy/95jkpwjY3SFHDcqSbWlfEulrsidxQrU4FXvg/aTFg/uGD5qOkCu77sCc1I2GMEJIpjPBCOLqNjABdPAT1ugIzzHCnwx58qvGR7KobeBiFEWHjikCDeNPRr3De/18GM/22MRmx7XSb81Vw3kPDRV5vu74oUYMcv6C/8dhu50VSZwLwxcBYd7cJhljzM7HZt5vcjNB/xg32Y6qdmL+7vC6HBsAWKUlJkI=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(396003)(346002)(366004)(39860400002)(478600001)(71200400001)(122000001)(2906002)(76116006)(52536014)(110136005)(83380400001)(66946007)(316002)(33656002)(38100700002)(5660300002)(66556008)(8676002)(86362001)(53546011)(55016002)(6506007)(107886003)(7696005)(66446008)(64756008)(4326008)(54906003)(9686003)(8936002)(186003)(66476007)(26005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?/WE/1vtxeXGBXmD47imH0azUat0lgkXEcAEd3xr6M87jx1VRHbaVHlIGh2JL?=
 =?us-ascii?Q?IHXnMQ0d+GuV9lhpBtglM7IYb6kY3zpgGa0jNCJn34NmJBq0uCR7faF+EbKY?=
 =?us-ascii?Q?W/xjPcW1ZHzKF+/xOSQN46YYoSPJTY6nBc9iaxWoFGMzafrh2V4LlK3umfKr?=
 =?us-ascii?Q?9kWUlqDgGP4pII9K/sO20L1TtGnjsEloSKjp4a99bk9X5lVJYZ3ZGnwU7Fr6?=
 =?us-ascii?Q?nbNFH2lyfTqiKtRU7TwYnCIqx68LeNC3TgD4JXYhHjAEFlsgGQJq0FMa2/xA?=
 =?us-ascii?Q?rkiuBjBCNn6NDGJ/8Cbr7KwozBfBG2zNE8VUhHilTx0r3RjSMVWlYff93FH5?=
 =?us-ascii?Q?a48pBQ7wZYB3JmwxpXltYhVsRl1BYMyJJUA0aR5pM0YJ7+ZzLvVS2FbP5SxQ?=
 =?us-ascii?Q?woUyuIWRK3BcpgjV68sCdC3XJt2RY5cU3hBOLjWlbWeurSI7GPSnI1lkSIGP?=
 =?us-ascii?Q?tSJd0yWatLGIeDcdKeIq3SrKzpjBGOl/jBkYrQ9zl7zs/FpBSV9itZ4ltz1D?=
 =?us-ascii?Q?RlFSfirsIbrrGmXJJsMLPx8mxrW6ofPmoaK73mjoYWtHMW9nyVXeYE5XlKKg?=
 =?us-ascii?Q?WJJf5x6UDPFumB2/58XqvX79FXmECK9cHOZCEkrr2MBEgUXvoFOIV1jd01c6?=
 =?us-ascii?Q?vUbDd4h+BL9bR9l5GbSw1H1p4OdcFaPkflH3yeykxa6h5IpegiMPLS2glSXp?=
 =?us-ascii?Q?fu0zMQTk36Yx0K067XVBWjicx4smfZukgK2WcNJLnR/rewBodT4sRsqAI5CT?=
 =?us-ascii?Q?sdsE53HZNC1gS1rPWucEtM4BvmbwT+7KPwpOvOhmBwR0eMqeF4nvrMh9K6zP?=
 =?us-ascii?Q?j3+bUuYYAboiMbnFvTJGjeoIV8Td008xb3w6qOEzs8TkHN4VlpbF4bCKdSmg?=
 =?us-ascii?Q?xzj7/fDAl6qdjNU1rxiLRaag1iciXavU8FkzKcaBE2pLA60fDItUWJX3bAQH?=
 =?us-ascii?Q?4WCZhBREPunHmDxVxcR2qmu85mA7ptdyzsjuYylUk4hS2xXpQnhZDp2WGVHy?=
 =?us-ascii?Q?ya4CAcRvSzsCftdJNCj4wyT0Rz/KI0Jt8lHN4nlvdVXtPErPH6Zes9CWlFBe?=
 =?us-ascii?Q?C+3XbwgfbxgmR2HlOQZHT4H1qS9XJ/K2BahyHJj+vNgm71+CcVekw8aMKipn?=
 =?us-ascii?Q?fhSe4KZJ/KRV0Q0Q+5/yKXpeHhvPPAT9U9Kbas3ULCL7HpNVhiuNoMOhB5hU?=
 =?us-ascii?Q?g1iDvy0Jhlzr1K6oBPU/WWvzh2LhoSQXKtin3LmRJSEBmp0W3ZtZWGwjZZza?=
 =?us-ascii?Q?W4YzzG1JGyVrxOJ1X1pIF+6SXhhmjg7VuSHrasHW+LdqHCvDSVGvM9C7PQnN?=
 =?us-ascii?Q?phhlMANB0WinRHJLYJ3WjH94?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84b5e4d-8da4-45c4-2390-08d925b1d4e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 02 Jun 2021 10:33:15.9634
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 43Be4bxRSaDbPf9JNt0JEDa3oHwrEWBBjpC5/LL0UuaylP50CYKJOee7QqfKxy68nFHcctux4gitMwa9RQsdGXoGT70nTEqUcGkPG6Va3LE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3355
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Wednesday, April 28, 2021 1:22 AM
> To: intel-wired-lan@lists.osuosl.org
> Cc: netdev@vger.kernel.org; bjorn@kernel.org; kuba@kernel.org;
> bpf@vger.kernel.org; davem@davemloft.net; Karlsson, Magnus
> <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-net] ice: track AF_XDP ZC enabled
> queues in bitmap
>=20
> Commit c7a219048e45 ("ice: Remove xsk_buff_pool from VSI structure")
> silently introduced a regression and broke the Tx side of AF_XDP in copy
> mode. xsk_pool on ice_ring is set only based on the existence of the XDP
> prog on the VSI which in turn picks ice_clean_tx_irq_zc to be executed.
> That is not something that should happen for copy mode as it should use t=
he
> regular data path ice_clean_tx_irq.
>=20
> This results in a following splat when xdpsock is run in txonly or l2fwd
> scenarios in copy mode:
>=20
> <snip>
> [  106.050195] BUG: kernel NULL pointer dereference, address:
> 0000000000000030 [  106.057269] #PF: supervisor read access in kernel
> mode [  106.062493] #PF: error_code(0x0000) - not-present page [
> 106.067709] PGD 0 P4D 0 [  106.070293] Oops: 0000 [#1] PREEMPT SMP
> NOPTI [  106.074721] CPU: 61 PID: 0 Comm: swapper/61 Not tainted 5.12.0-
> rc2+ #45 [  106.081436] Hardware name: Intel Corporation
> S2600WFT/S2600WFT, BIOS SE5C620.86B.02.01.0008.031920191559
> 03/19/2019 [  106.092027] RIP: 0010:xp_raw_get_dma+0x36/0x50 [
> 106.096551] Code: 74 14 48 b8 ff ff ff ff ff ff 00 00 48 21 f0 48 c1 ee 3=
0 48 01
> c6 48 8b 87 90 00 00 00 48 89 f2 81 e6 ff 0f 00 00 48 c1 ea 0c <48> 8b 04=
 d0 48
> 83 e0 fe 48 01 f0 c3 66 66 2e 0f 1f 84 00 00 00 00 [  106.115588] RSP:
> 0018:ffffc9000d694e50 EFLAGS: 00010206 [  106.120893] RAX:
> 0000000000000000 RBX: ffff88984b8c8a00 RCX: ffff889852581800 [
> 106.128137] RDX: 0000000000000006 RSI: 0000000000000000 RDI:
> ffff88984cd8b800 [  106.135383] RBP: ffff888123b50001 R08:
> ffff889896800000 R09: 0000000000000800 [  106.142628] R10:
> 0000000000000000 R11: ffffffff826060c0 R12: 00000000000000ff [
> 106.149872] R13: 0000000000000000 R14: 0000000000000040 R15:
> ffff888123b50018 [  106.157117] FS:  0000000000000000(0000)
> GS:ffff8897e0f40000(0000) knlGS:0000000000000000 [  106.165332] CS:  0010
> DS: 0000 ES: 0000 CR0: 0000000080050033 [  106.171163] CR2:
> 0000000000000030 CR3: 000000000560a004 CR4: 00000000007706e0 [
> 106.178408] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000 [  106.185653] DR3: 0000000000000000 DR6:
> 00000000fffe0ff0 DR7: 0000000000000400 [  106.192898] PKRU: 55555554 [
> 106.195653] Call Trace:
> [  106.198143]  <IRQ>
> [  106.200196]  ice_clean_tx_irq_zc+0x183/0x2a0 [ice] [  106.205087]
> ice_napi_poll+0x3e/0x590 [ice] [  106.209356]  __napi_poll+0x2a/0x160 [
> 106.212911]  net_rx_action+0xd6/0x200 [  106.216634]
> __do_softirq+0xbf/0x29b [  106.220274]  irq_exit_rcu+0x88/0xc0 [
> 106.223819]  common_interrupt+0x7b/0xa0 [  106.227719]  </IRQ> [
> 106.229857]  asm_common_interrupt+0x1e/0x40 </snip>
>=20
> Fix this by introducing the bitmap of queues that are zero-copy enabled,
> where each bit, corresponding to a queue id that xsk pool is being config=
ured
> on, will be set/cleared within ice_xsk_pool_{en,dis}able and checked with=
in
> ice_xsk_pool(). The latter is a function used for deciding which napi pol=
l
> routine is executed.
> Idea is being taken from our other drivers such as i40e and ixbge.
>=20
> Fixes: c7a219048e45 ("ice: Remove xsk_buff_pool from VSI structure")
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice.h     |  8 +++++---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 10 ++++++++++
> drivers/net/ethernet/intel/ice/ice_xsk.c |  3 +++
>  3 files changed, 18 insertions(+), 3 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
