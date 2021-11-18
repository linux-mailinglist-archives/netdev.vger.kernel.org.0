Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3CE4557BB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245074AbhKRJJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:09:29 -0500
Received: from mga04.intel.com ([192.55.52.120]:20400 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245022AbhKRJJK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 04:09:10 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="232868158"
X-IronPort-AV: E=Sophos;i="5.87,244,1631602800"; 
   d="scan'208";a="232868158"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 01:05:13 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,244,1631602800"; 
   d="scan'208";a="587139254"
Received: from fmsmsx603.amr.corp.intel.com ([10.18.126.83])
  by FMSMGA003.fm.intel.com with ESMTP; 18 Nov 2021 01:05:13 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx603.amr.corp.intel.com (10.18.126.83) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 18 Nov 2021 01:05:13 -0800
Received: from fmsmsx607.amr.corp.intel.com (10.18.126.87) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 18 Nov 2021 01:05:12 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx607.amr.corp.intel.com (10.18.126.87) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 18 Nov 2021 01:05:12 -0800
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (104.47.57.42) by
 edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 18 Nov 2021 01:05:11 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MLol9SZVsa0RcV6uSMhqYfyzdPUNpAvRBWci+tkYi0Bhgue7fW6luY1U4Xozirn9nVjgzsrXZ869235uUANNZLxBIpOWbQdMZmUKuXjVbXoKPhPe3rwX8an+c7s67rym8PN/bGALUsikBpnOJNn8MObz5hwUq/AyeG1pN1KlMWDLRjviaJwsAZqtqYWOTxlT771XgVqtYL27UfnErCo6WOqHJ50b6pj8erriVgcYNppO0gQl14V7ZSi50RiwlX0prxe+E1gRZ422Cu3oFeq0A42BhT4RxeRWJ7AtdjkY5tO58i1RG59KuFZI0SI5N+YK6l2Nj0SLrYMBsqW+sd6exg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=CYRmbRho5L23cxd49awelLwU1VqgU+jnV2WOnYqkbpk=;
 b=aBxPzcQ5kKIBxeiOd2EFJJnE/OOYKQwozX9kETeIuu/LQy1hPt64RpqENUqUrb68+SO6LOsOVCchG01D1pn6sWE/bF9vWZgP6dyOeJ5j+T/k8U4/Vgr9HENCVf6pEjGUB1Ni+3OGmPnuUeLI5T15CQMSnxk2T0ccou4UWx2BU/Tq5SGHkeeKkCc/Enbqw+H+tchmi312QiJnREV2aEeEPQ3ZFP/Rpe3mYI9FfmlIGjVLjAaeZjvkHNMtoCDoFWzXLY+gKuIl8lGFPgG6JVwqj7u0vYdXnPwkmcJwpvDPC8lHfhFzFHGMLluYdw8yeYkREy90d20pudwAI8QO8fNSDQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CYRmbRho5L23cxd49awelLwU1VqgU+jnV2WOnYqkbpk=;
 b=zqGKDBU6srKck1i+CeG/MT7Z7rE1SJEtoRc+7qIdAR3l4k7FIuNg6t5kJ4+Lqbo3pAxTdBXQ+JruBXoAkj7j10v79kZy9iuIfSzz2JDPom8HHE/JArus0CwmAPabr3s+AP65frpKLmrOuLmWQJUYIKSR22mbIzCLkFIt9qlusEA=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM5PR11MB1993.namprd11.prod.outlook.com (2603:10b6:3:12::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Thu, 18 Nov 2021 09:05:07 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::f072:4a0d:54c7:170a]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::f072:4a0d:54c7:170a%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 09:05:07 +0000
From:   "Bhandare, KiranX" <kiranx.bhandare@intel.com>
To:     "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>
CC:     "Lobakin, Alexandr" <alexandr.lobakin@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Plantykow, Marta A" <marta.a.plantykow@intel.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>
Subject: RE: [Intel-wired-lan] [PATCH intel-next 1/2] ice: fix vsi->txq_map
 sizing
Thread-Topic: [Intel-wired-lan] [PATCH intel-next 1/2] ice: fix vsi->txq_map
 sizing
Thread-Index: AQHXynmHpaNfSZ3yxUekox+9xup/J6wJIZPw
Date:   Thu, 18 Nov 2021 09:05:07 +0000
Message-ID: <DM6PR11MB32922DF618203E2040B6A84DF19B9@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211026164719.1766911-1-maciej.fijalkowski@intel.com>
 <20211026164719.1766911-2-maciej.fijalkowski@intel.com>
In-Reply-To: <20211026164719.1766911-2-maciej.fijalkowski@intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-version: 11.6.200.16
dlp-product: dlpe-windows
dlp-reaction: no-action
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2bdb7345-78ad-40b6-e727-08d9aa7284af
x-ms-traffictypediagnostic: DM5PR11MB1993:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR11MB19935B52343379FD021ECC73F19B9@DM5PR11MB1993.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iQEm0rJTA6Ct+Z3h3V6CB7jJdN8WXkvY6h6TuT/2W8ZUtqMSZWxdVsfI63pWOr29Ef216wLSZOAjYv8j2lFoALiYUSMpBoVGkumdxSNP0ol2ogi+IP7OwxySIbea8S7l22GzW5QTQuVlthRDnBtEDbM4U8zzrIvxAc2g8kIJdiMU1qVGFq8jKjJFUf0CeUNIDoQo7h2cEuMjhD79UqKQ9EPp99fiUvMsDccGApxnc38xay3YPm/+/ayZ5sBtFjJWZaI6ESXVvWb6d2/sRDQnY49Hz/YfYStK6lbJBefgCtxF0O4Ub214V3/dDrzzd7jm0QvGiWRAq5xpAnmvqyl607NKI2/+tT02L8G1pMTayby0bqkbsZOhFf+0iSzlYay1V6QcBfm8ys7KGS4ofr1zJDRhf+QemCbwauu9/moIN0bG/e0G4Cnc8AjZKZ2F9Ted/RgCRoINOaBys92uQ/qDLZx9q2jqsHD9G8lW5Q2zPGXnwPm+qJ5ldn5Vw67yGlUn4RKhN5nZFqC2345DmKCJoz2cWnx9EaCCzMZESy62fF2QYCASByZ7ZiVObMUcGT0K4MEfEVJISUheVBSNfW8DfWAp9dI/pduPLd9P4L+ot6MoQ0s2Xq6GD2THseoSunIQ2ajf6canSMvYSIgeM5zKj7Zyr9B+e5kP187j0Ci6CLGclG1ZfkZhwMVWG4nvo62VNa6aNt9wm5bLNRgyMFWdYA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(86362001)(122000001)(53546011)(6506007)(107886003)(55016002)(2906002)(26005)(38070700005)(4326008)(82960400001)(7696005)(38100700002)(83380400001)(8936002)(66556008)(66946007)(186003)(66446008)(76116006)(66476007)(316002)(64756008)(110136005)(71200400001)(54906003)(8676002)(5660300002)(508600001)(52536014)(9686003)(33656002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?WNUlv1wHY97z+ywI3V387b3ZcmqKFfSp/N9kdm35O/B0Xkw9K7YVh8PBRou4?=
 =?us-ascii?Q?k00tEWSZ+TWaZsUktsREJ9Oe9ZONqIkri1sM5Lbo8Ag0ZaMFppd0wQKprOSg?=
 =?us-ascii?Q?75tsOw0Mog2ROvKtFU8cEDbhUxSzs4KSC4c0xgiMw1QHigQQXCgQruV+ZB15?=
 =?us-ascii?Q?MpbZ6e/38soqk9kj+/gK95LpF0tMeEgRLn4K4eRDocKc/apKwdVQW6zMQzJq?=
 =?us-ascii?Q?khCc85uDQFkNpGlwaXEBdOHTEMAS4Gu56YZfyP8OMxzZoIuGP9LyLIwcFpVg?=
 =?us-ascii?Q?g+lJGcMAbTyLdavAgvAmXb5n1H22W89/JW/r/SZdvo38HBMdS1BO514gHKGW?=
 =?us-ascii?Q?qB9EVCjQ2r5L3ipLvRPF6Aex/IqwlxAN6t6l1APzMU7VVXKypNHjruGRbW1Y?=
 =?us-ascii?Q?BWMtDrEavkPYlznhgqni475V8JVg9TUEfJmQ+Rkm8fnY3KB9y4T1k6XPeWS2?=
 =?us-ascii?Q?Gpne56JKdiIbn+4/7iY815BEXGN2ha+4YQvsMxWoPd28XLFGTpmJx9atsWSv?=
 =?us-ascii?Q?BxhYObQ5fn0yXWXEy/0FGz7dnZ2aw6ALkYiInbSxCxBfAeWn3ZnaLO/13Id7?=
 =?us-ascii?Q?aeyhvXBjBKITKzTk1SreiVpMyav+gxkRMFgKxorLJO3qdwVLkgkRlorB5d91?=
 =?us-ascii?Q?BPQA8Caw5ffMSZO2PIYUw0vyqpFq9Pw625kaGblWnorE5O8BtCT930rBH+mt?=
 =?us-ascii?Q?8zxlL5lL9zoelADPm2sdm6oQcYFyiAHEygDBomhxQwPTrF0uoHvS0vdtQFf2?=
 =?us-ascii?Q?eieuMFwMutUluZJcxmki6JsJ8JVOdAmUmc2YzWMB4v+6zaSulJH3bagXmtYl?=
 =?us-ascii?Q?J+2d1gkERnwXAG2b4Z5Z6RIIVWPYBnZmR2wiHfadz4+O6o4xJGompm4mOjPN?=
 =?us-ascii?Q?a1uGsGiVLh5J8ugW1BvkbViXlWpW0o1M1ZeYG/lUMUcjTJUwtJYlFLKcdlGK?=
 =?us-ascii?Q?Fv5iuU+TcOH8DGnahzeKr1oOm6zWdlhdPcg6Ejr0MBe1gNRQyiizbEc6yYNr?=
 =?us-ascii?Q?l469qgm/DKPmmOmTjNjiL+Bzruk+t5WN57QikN/DQobjE8qm2YbBmti4an6r?=
 =?us-ascii?Q?6+Nv2bnZe9M6sqvxZ2XrPAlyyCprSnaJacY31C/dFPD209OGGKefTdH6YqXY?=
 =?us-ascii?Q?DcHZRP8Mit8qQMvg5jTYVP44LJ+hRMIudAJoqP1iR5HR0S+FzDoOn2GxVPYx?=
 =?us-ascii?Q?7X6xyMRrwQJmGvI9Jprw21ZZAYozFrlqbD6px4HNTxsq7fCnrkAcGeyAGmZQ?=
 =?us-ascii?Q?qEi5VN/Pn8sdK4xcsvXL8sT/6lcv5V+fyb2wMqcn3LWowoCm9y+Jn27KFN1Q?=
 =?us-ascii?Q?1DvlQJ1gls7tq5FSVQYrkygMW8hEmsT3ECGH0LuVdr15KCrs4OzbnIWVq4oe?=
 =?us-ascii?Q?cMrUlYf3Z2wnKKd3twKFPr8MKMhbq7/HHv0gy6FoqBPgFma4yjk1ETbrLqc0?=
 =?us-ascii?Q?YYEC7PCVT1nMHLS3POv660Nkj4vQZo0fiahMmSjOkPeFZCxw+8CEGQQRSpuz?=
 =?us-ascii?Q?iEDGgzJB8i23Tc17gDlSE8AnBz0SPgkY51ebAMrgqQTjhm4JYp+hSdm1GBmt?=
 =?us-ascii?Q?FYWyEegluKIbpEwfsUo6J0uqfnv5GgENZo2zCShSSWK2EDTyp8WeN+05q63f?=
 =?us-ascii?Q?EK/KsUj4HlB09JZUvJv25pkk+UoiH3kD9XQ6PAG/SEcnj5WtbghlxhG0QIkE?=
 =?us-ascii?Q?QPjbsw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2bdb7345-78ad-40b6-e727-08d9aa7284af
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 09:05:07.6751
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0uckb7oZtOHl7Ptz85S8Bpi+JFneQBFPwIoAyRk+ytCKwcuZiWNgjOe3xXayA7D+1KZcN4HrtOBRfm67RSukVLXj5WwEfjRlu+wegdX1r2Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1993
X-OriginatorOrg: intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of
> Maciej Fijalkowski
> Sent: Tuesday, October 26, 2021 10:17 PM
> To: intel-wired-lan@lists.osuosl.org
> Cc: Lobakin, Alexandr <alexandr.lobakin@intel.com>;
> netdev@vger.kernel.org; Plantykow, Marta A
> <marta.a.plantykow@intel.com>; kuba@kernel.org; bpf@vger.kernel.org;
> davem@davemloft.net; Karlsson, Magnus <magnus.karlsson@intel.com>
> Subject: [Intel-wired-lan] [PATCH intel-next 1/2] ice: fix vsi->txq_map s=
izing
>=20
> The approach of having XDP queue per CPU regardless of user's setting
> exposed a hidden bug that could occur in case when Rx queue count differ
> from Tx queue count. Currently vsi->txq_map's size is equal to the double=
d
> vsi->alloc_txq, which is not correct due to the fact that XDP rings were
> previously based on the Rx queue count. Below splat can be seen when
> ethtool -L is used and XDP rings are configured:
>=20
> [  682.875339] BUG: kernel NULL pointer dereference, address:
> 000000000000000f [  682.883403] #PF: supervisor read access in kernel mod=
e
> [  682.889345] #PF: error_code(0x0000) - not-present page [  682.895289]
> PGD 0 P4D 0 [  682.898218] Oops: 0000 [#1] PREEMPT SMP PTI
> [  682.903055] CPU: 42 PID: 2878 Comm: ethtool Tainted: G           OE   =
  5.15.0-
> rc5+ #1
> [  682.912214] Hardware name: Intel Corp. GRANTLEY/GRANTLEY, BIOS
> GRRFCRB1.86B.0276.D07.1605190235 05/19/2016 [  682.923380] RIP:
> 0010:devres_remove+0x44/0x130 [  682.928527] Code: 49 89 f4 55 48 89 fd
> 4c 89 ff 53 48 83 ec 10 e8 92 b9 49 00 48 8b 9d a8 02 00 00 48 8d 8d a0 0=
2 00
> 00 49 89 c2 48 39 cb 74 0f <4c> 3b 63 10 74 25 48 8b 5b 08 48 39 cb 75 f1=
 4c
> 89 ff 4c 89 d6 e8 [  682.950237] RSP: 0018:ffffc90006a679f0 EFLAGS:
> 00010002 [  682.956285] RAX: 0000000000000286 RBX: ffffffffffffffff RCX:
> ffff88908343a370 [  682.964538] RDX: 0000000000000001 RSI:
> ffffffff81690d60 RDI: 0000000000000000 [  682.972789] RBP:
> ffff88908343a0d0 R08: 0000000000000000 R09: 0000000000000000 [
> 682.981040] R10: 0000000000000286 R11: 3fffffffffffffff R12: ffffffff8169=
0d60
> [  682.989282] R13: ffffffff81690a00 R14: ffff8890819807a8 R15:
> ffff88908343a36c [  682.997535] FS:  00007f08c7bfa740(0000)
> GS:ffff88a03fd00000(0000) knlGS:0000000000000000 [  683.006910] CS:  0010
> DS: 0000 ES: 0000 CR0: 0000000080050033 [  683.013557] CR2:
> 000000000000000f CR3: 0000001080a66003 CR4: 00000000003706e0 [
> 683.021819] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000 [  683.030075] DR3: 0000000000000000 DR6:
> 00000000fffe0ff0 DR7: 0000000000000400 [  683.038336] Call Trace:
> [  683.041167]  devm_kfree+0x33/0x50
> [  683.045004]  ice_vsi_free_arrays+0x5e/0xc0 [ice] [  683.050380]
> ice_vsi_rebuild+0x4c8/0x750 [ice] [  683.055543]
> ice_vsi_recfg_qs+0x9a/0x110 [ice] [  683.060697]
> ice_set_channels+0x14f/0x290 [ice] [  683.065962]
> ethnl_set_channels+0x333/0x3f0 [  683.070807]
> genl_family_rcv_msg_doit+0xea/0x150
> [  683.076152]  genl_rcv_msg+0xde/0x1d0
> [  683.080289]  ? channels_prepare_data+0x60/0x60 [  683.085432]  ?
> genl_get_cmd+0xd0/0xd0 [  683.089667]  netlink_rcv_skb+0x50/0xf0 [
> 683.094006]  genl_rcv+0x24/0x40 [  683.097638]
> netlink_unicast+0x239/0x340 [  683.102177]  netlink_sendmsg+0x22e/0x470 [
> 683.106717]  sock_sendmsg+0x5e/0x60 [  683.110756]
> __sys_sendto+0xee/0x150 [  683.114894]  ? handle_mm_fault+0xd0/0x2a0 [
> 683.119535]  ? do_user_addr_fault+0x1f3/0x690 [  683.134173]
> __x64_sys_sendto+0x25/0x30 [  683.148231]  do_syscall_64+0x3b/0xc0 [
> 683.161992]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> Fix this by taking into account the value that num_possible_cpus() yields=
 in
> addition to vsi->alloc_txq instead of doubling the latter.
>=20
> Fixes: efc2214b6047 ("ice: Add support for XDP")
> Fixes: 22bf877e528f ("ice: introduce XDP_TX fallback path")
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_lib.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel


