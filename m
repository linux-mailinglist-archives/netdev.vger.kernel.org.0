Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0A74557B3
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 10:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234547AbhKRJIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 04:08:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:47669 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244975AbhKRJHY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 04:07:24 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10171"; a="234090898"
X-IronPort-AV: E=Sophos;i="5.87,244,1631602800"; 
   d="scan'208";a="234090898"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2021 01:03:15 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.87,244,1631602800"; 
   d="scan'208";a="568397986"
Received: from fmsmsx604.amr.corp.intel.com ([10.18.126.84])
  by fmsmga004.fm.intel.com with ESMTP; 18 Nov 2021 01:03:13 -0800
Received: from fmsmsx609.amr.corp.intel.com (10.18.126.89) by
 fmsmsx604.amr.corp.intel.com (10.18.126.84) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12; Thu, 18 Nov 2021 01:03:12 -0800
Received: from fmsedg602.ED.cps.intel.com (10.1.192.136) by
 fmsmsx609.amr.corp.intel.com (10.18.126.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2242.12 via Frontend Transport; Thu, 18 Nov 2021 01:03:12 -0800
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (104.47.58.104)
 by edgegateway.intel.com (192.55.55.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2242.12; Thu, 18 Nov 2021 01:03:12 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=SLpALqmE3943Ps6yYThjrqkKTERLDLa8FTDnazpzLQV5sZeGA4i+zagzuwlQMyK5BakzjeOyairMCLyVlO0SekwqW6we35/ebCY5UUH9OAZSHMGp1pjN/iexGnIe0ZtwHZ6C8eYIcS3/UG0lljmPSi/zTH4SK4g0C7xvqiYLPd3mDYDc5kwa7eT9W6Yk5m79ZyppmWGJmPLs1lhlu+Ai+3I5evYU6L9tN67bCA1JQ4T4+Yob7FExQ3kucs8XYewZfDpxC6OrJP7/VQRF6kGy2mOkTU6CwL8kN5I3P+FxiTvSh6N06wr9BBmsc+308AZbfVhHr90B1gibPC2F16iBpw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SyR4PzCP6DpyxzByznSbkNThoXSEV9o34wL3JtxKm6M=;
 b=L+k2dhfbO32LenKaVLGpZVSE8DgbFy40iz+zr6waItC0ck23XIGauixOBXwUH4U5mIiiQBTvyFP/TG6TKhDrXayRc7F8TJWfcRJ/s9D3sfnK9qMqqQXIhC/dGqY0GXz+Rgox2paE5ZgcRJ+1VtrAfB6VF/spIUiOts6/x0LCCDLc/EPMa0Y9fJXgvUYquJrPyGFp3Uj7VtUrbbi8dioGp6tZJLDtkTZTWB/AfWoBlyIndaPKpm3XGuA8KJzjXYgDzG3oPmjq1GKquaIft3Ts+aGeZRPDLgr3HrGKB63JaRgIXGVTMoC51Qpxn9MHLALCs+hzVqye7J7/tKbis2PqBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SyR4PzCP6DpyxzByznSbkNThoXSEV9o34wL3JtxKm6M=;
 b=bJRuxl5f3Dnt9rY915h7s06LMOqkFOka8k/9NS58kGuhUu1LPbYgyMBAagVxd3cUBKYMTlK1k7c0FUcDZzKYkTXhnzmW+EPYo0dUUsHBQrRg5Pdq8SUboean5tcPvVTCOUkrbuen2cRzozjRycfEyCkWvGK98/QUbepcxBWdq3c=
Received: from DM6PR11MB3292.namprd11.prod.outlook.com (2603:10b6:5:5a::21) by
 DM5PR11MB1993.namprd11.prod.outlook.com (2603:10b6:3:12::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4690.27; Thu, 18 Nov 2021 09:03:10 +0000
Received: from DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::f072:4a0d:54c7:170a]) by DM6PR11MB3292.namprd11.prod.outlook.com
 ([fe80::f072:4a0d:54c7:170a%7]) with mapi id 15.20.4690.027; Thu, 18 Nov 2021
 09:03:10 +0000
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
Subject: RE: [Intel-wired-lan] [PATCH intel-next 2/2] ice: avoid bpf_prog
 refcount underflow
Thread-Topic: [Intel-wired-lan] [PATCH intel-next 2/2] ice: avoid bpf_prog
 refcount underflow
Thread-Index: AQHXynmDe2qZKIG3F0eDpA3mHeXYgawJIKFA
Date:   Thu, 18 Nov 2021 09:03:10 +0000
Message-ID: <DM6PR11MB32927456F152029AD3EF665EF19B9@DM6PR11MB3292.namprd11.prod.outlook.com>
References: <20211026164719.1766911-1-maciej.fijalkowski@intel.com>
 <20211026164719.1766911-3-maciej.fijalkowski@intel.com>
In-Reply-To: <20211026164719.1766911-3-maciej.fijalkowski@intel.com>
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
x-ms-office365-filtering-correlation-id: fb676624-b52d-42c0-5cb1-08d9aa723ebe
x-ms-traffictypediagnostic: DM5PR11MB1993:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-microsoft-antispam-prvs: <DM5PR11MB19935E0E801EA2DB421C47E5F19B9@DM5PR11MB1993.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: umh2yvugrFGDxr0qnqCVvuNxsA3x1tHysUq+Cc/wFlcSAE+1WbLVa7IU0dl2zPqHQsNGWY4CNXhc54pDv+0jCdLk5iLw1QaoDQCotxb4+guAk5bPKKzgMY1DelhKSI+GJ1kMAV61I/X4FS7w8OP+4SkJHTlItB0ur1zuQE/7782j5taAhuM0O3VHK6j1L1MN4ASsG8SajKy9yXU006ZwxP/a2hUpKm1Dmmhojb5HT7J4wSk47sK1INyTbrR9SnDIoaZjUhHV/I7ysvOiiBsp7hQ7PhixGGaHSvidMzNBE7Z7KpfHVRgMMMg2B/jN14WiPWIxrb90N/sQG4i4Fh2mCPVdTeBPGRR/488iRdLar7w4A5ZgzJhGqUK37+0KolUf0xDOieKwFhSCYVZNOX5U2qB/Nu1SzC3M7zeHzHP9l2I3p5+PbNfxMJRERHehbjlSd5hdtc9sgwckff0UbFyobkOMjDpofZUUk/3LITZnTP8HeFg+WukqzJwOWa3QSwTRVL1ixGQ1lh0xG6veR8C5Hd9q7e+jkqmAhNUWUJRBrZGl1iuuSGvXXzcdEjyNBCEsIN5lU4hpYdTKOVkKsScbheGSRx9KBOHwwsKyn+1s8KpgrgLZuid6MvhaMoLTCRPQIcaQp+gh6onjJ515+gbUCFYvBT/2qPdUVjazPodX2J5ef/kR1KxjFti5evCuXNpvFjQrZIugJcwH5nVAereDRg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR11MB3292.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66446008)(76116006)(66476007)(66556008)(66946007)(186003)(71200400001)(54906003)(316002)(64756008)(110136005)(8936002)(9686003)(33656002)(5660300002)(8676002)(52536014)(508600001)(45080400002)(55016002)(2906002)(26005)(6506007)(53546011)(86362001)(122000001)(107886003)(7696005)(82960400001)(83380400001)(38100700002)(38070700005)(4326008);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?x/YFfJK/042ZWf4XcYeqJJCznS928UiaMNYw1qWibRITrxhdA4sytOKBvefh?=
 =?us-ascii?Q?J7aOrc4yQPOoZidulJslh9xDADmxIZoBdG0z9ioMI1r+bRkID6A7bblE0eoi?=
 =?us-ascii?Q?PKG0xxYUruRgGjM6pcgc6pj5X/BaceMzsTSg0FHUG8ytkhxKvc0UA3hSgJhT?=
 =?us-ascii?Q?iyxz9UqlZXm3vJE8LqOLJZJqylpF5n5CHF6NL2GiEur2zaaEZs7hLJCdoZc+?=
 =?us-ascii?Q?PJAaMfjoEpmeqyBZKXK9DCOPZaDtzCdnVrvl2k0MSQE/nPMJhoBhKH7+JPbr?=
 =?us-ascii?Q?F9PqF3uFOyPg0CCVw9fGvCfweZ3NTEl4ayf4AeFgdQ1mkgz63UktFqrEUC01?=
 =?us-ascii?Q?UuFJRJarqsVjK5OGCscls2OrEHUG9z+JmRVLeu3eXnOYMZctHce+ouVaJ7Ht?=
 =?us-ascii?Q?CTwZUVYAU7hzuv8YYOOPdv/3yZ70PRdXMYrxAWo4shrntZ8VxYhO6R20ranI?=
 =?us-ascii?Q?eppK+7uKxIfUSahlLmNRIkAdtvZnsUrTN4jJ3BwYMrJqK9apPudmdBU3E8KM?=
 =?us-ascii?Q?nUeE7bFmhsKvdoaimSyhxttV+JAjvrLPUTpPhffcH/8vneNZ4kUD9NE4y4cZ?=
 =?us-ascii?Q?HzPs1L/Db7rHnnQp6wFVBy36oOdkuqGUZYb2NyPWKe4t34M4G7RyFevAJQFp?=
 =?us-ascii?Q?uVQrAEYyD7i0bC/VJuF3GMipAXfT76xjB7lu3WiBRDqKxvPLxPZuukvZX/6N?=
 =?us-ascii?Q?7NjsQT8hDqtY0ahVu3wEkx6L/3BfBhfRk/yw8U6rXqSZ2tWOsFei458KIzpP?=
 =?us-ascii?Q?PECaLfLO+A8Dft4C8U1mH9k7Ra+ZkSrHtrwLm528R+KRz81iVKSAe0Dn8AWQ?=
 =?us-ascii?Q?RDiOr9MvUbFFN4tqzKWD5UNzsudjyOot995oB3ssrF9cGTotP9A9CGz0UY6p?=
 =?us-ascii?Q?MyfDZGQpPNw7KCijE7qOMFg2AhLUfn3hE3TXuj4T3LUsLZJOU8dkcWF3FmbD?=
 =?us-ascii?Q?0iCpOhIuFliCtNA6heI7BY92ZeVpfZXBWffMcuIOmd60K9WQln1ev+ftU4H4?=
 =?us-ascii?Q?z4ednXmamkFeCDMxCmiKndJXbl+KRAF0w+JczVb3EcqyuzpBl/IsVcLA6RuF?=
 =?us-ascii?Q?7CPsVt6MSod5nU8OQkwv986smJwUL807/DJFbXPk8QBMUDjWu6ssRJb3QNt3?=
 =?us-ascii?Q?PV8gjeI4oJHkW+4kS11wYhKO94T8rDf1s7Ys7BaTolXOfugAQjIfxOt4smH7?=
 =?us-ascii?Q?3tFanS3FO105b2BM1ZOVPe4AoX5j8BM1dtgnJEmwU2Em29CWY5GerzewFhLY?=
 =?us-ascii?Q?Rz9q7En8a9xyH2jbEkS7ANyDacZ+ULTTMILYwVyfZhmwxHMCBlC1Huacv9w8?=
 =?us-ascii?Q?ppP0/ZJlz6U90dCADt5DlThZtMStPN92ffC63I9yZAK5DH7Fz7aa5BLqejIQ?=
 =?us-ascii?Q?lIuinn/YHWWnSLbwyBg8QLS8CtYxTetSpg5APEFGWWOKXvQX/wozLiW0eUmD?=
 =?us-ascii?Q?Mv87FAUXg+fecm8Zk6ANe68qzjylyvyRfDpChi1rzhCRbBIWr7Z8W4lZi89I?=
 =?us-ascii?Q?gg3tddrYOEROHwpoSxKKQcqO3eqeaQEWr4dwIPeEiEvCUgOBJaM0nhlG94kO?=
 =?us-ascii?Q?ZzH573HFV8Ztyjwl1yYxkwom1K0tfRhdG6OzHFGqIo306TndEl8bLGPRmaGf?=
 =?us-ascii?Q?BnGirkcS90rMTdtsL9gOQXy/pc+8h3H6vUxNQw1zijWE6raxLYwXWoAlir2m?=
 =?us-ascii?Q?whdYgA=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR11MB3292.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fb676624-b52d-42c0-5cb1-08d9aa723ebe
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 09:03:10.4223
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VFuEqo0SnfVfwp4yj4pVJzsZwhvzONBwYq+PX2s7Y2tt86uTOQGmM6JjzijqUj/GBU0EZF3r3gTl/yNOEskakiV1JZLBElPeKr1rOVLwFTE=
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
> Subject: [Intel-wired-lan] [PATCH intel-next 2/2] ice: avoid bpf_prog ref=
count
> underflow
>=20
> From: Marta Plantykow <marta.a.plantykow@intel.com>
>=20
> Ice driver has the routines for managing XDP resources that are shared
> between ndo_bpf op and VSI rebuild flow. The latter takes place for examp=
le
> when user changes queue count on an interface via ethtool's set_channels(=
).
>=20
> There is an issue around the bpf_prog refcounting when VSI is being rebui=
lt -
> since ice_prepare_xdp_rings() is called with vsi->xdp_prog as an argument
> that is used later on by ice_vsi_assign_bpf_prog(), same bpf_prog pointer=
s
> are swapped with each other. Then it is also interpreted as an 'old_prog'
> which in turn causes us to call bpf_prog_put on it that will decrement it=
s
> refcount.
>=20
> Below splat can be interpreted in a way that due to zero refcount of a
> bpf_prog it is wiped out from the system while kernel still tries to refe=
r to it:
>=20
> [  481.069429] BUG: unable to handle page fault for address:
> ffffc9000640f038 [  481.077390] #PF: supervisor read access in kernel mod=
e [
> 481.083335] #PF: error_code(0x0000) - not-present page [  481.089276] PGD
> 100000067 P4D 100000067 PUD 1001cb067 PMD 106d2b067 PTE 0 [
> 481.097141] Oops: 0000 [#1] PREEMPT SMP PTI
> [  481.101980] CPU: 12 PID: 3339 Comm: sudo Tainted: G           OE     5=
.15.0-
> rc5+ #1
> [  481.110840] Hardware name: Intel Corp. GRANTLEY/GRANTLEY, BIOS
> GRRFCRB1.86B.0276.D07.1605190235 05/19/2016 [  481.122021] RIP:
> 0010:dev_xdp_prog_id+0x25/0x40 [  481.127265] Code: 80 00 00 00 00 0f 1f
> 44 00 00 89 f6 48 c1 e6 04 48 01 fe 48 8b 86 98 08 00 00 48 85 c0 74 13 4=
8 8b
> 50 18 31 c0 48 85 d2 74 07 <48> 8b 42 38 8b 40 20 c3 48 8b 96 90 08 00 00=
 eb
> e8 66 2e 0f 1f 84 [  481.148991] RSP: 0018:ffffc90007b63868 EFLAGS:
> 00010286 [  481.155034] RAX: 0000000000000000 RBX: ffff889080824000
> RCX: 0000000000000000 [  481.163278] RDX: ffffc9000640f000 RSI:
> ffff889080824010 RDI: ffff889080824000 [  481.171527] RBP:
> ffff888107af7d00 R08: 0000000000000000 R09: ffff88810db5f6e0 [
> 481.179776] R10: 0000000000000000 R11: ffff8890885b9988 R12:
> ffff88810db5f4bc [  481.188026] R13: 0000000000000000 R14:
> 0000000000000000 R15: 0000000000000000 [  481.196276] FS:
> 00007f5466d5bec0(0000) GS:ffff88903fb00000(0000)
> knlGS:0000000000000000 [  481.205633] CS:  0010 DS: 0000 ES: 0000 CR0:
> 0000000080050033 [  481.212279] CR2: ffffc9000640f038 CR3:
> 000000014429c006 CR4: 00000000003706e0 [  481.220530] DR0:
> 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000 [
> 481.228771] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400 [  481.237029] Call Trace:
> [  481.239856]  rtnl_fill_ifinfo+0x768/0x12e0 [  481.244602]
> rtnl_dump_ifinfo+0x525/0x650 [  481.249246]  ? __alloc_skb+0xa5/0x280 [
> 481.253484]  netlink_dump+0x168/0x3c0 [  481.257725]
> netlink_recvmsg+0x21e/0x3e0 [  481.262263]  ____sys_recvmsg+0x87/0x170
> [  481.266707]  ? __might_fault+0x20/0x30 [  481.271046]  ?
> _copy_from_user+0x66/0xa0 [  481.275591]  ? iovec_from_user+0xf6/0x1c0 [
> 481.280226]  ___sys_recvmsg+0x82/0x100 [  481.284566]  ?
> sock_sendmsg+0x5e/0x60 [  481.288791]  ? __sys_sendto+0xee/0x150 [
> 481.293129]  __sys_recvmsg+0x56/0xa0 [  481.297267]
> do_syscall_64+0x3b/0xc0 [  481.301395]
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> [  481.307238] RIP: 0033:0x7f5466f39617
> [  481.311373] Code: 0c 00 f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb bd 0f 1=
f 00 f3 0f
> 1e fa 64 8b 04 25 18 00 00 00 85 c0 75 10 b8 2f 00 00 00 0f 05 <48> 3d 00=
 f0 ff
> ff 77 51 c3 48 83 ec 28 89 54 24 1c 48 89 74 24 10 [  481.342944] RSP:
> 002b:00007ffedc7f4308 EFLAGS: 00000246 ORIG_RAX: 000000000000002f [
> 481.361783] RAX: ffffffffffffffda RBX: 00007ffedc7f5460 RCX:
> 00007f5466f39617 [  481.380278] RDX: 0000000000000000 RSI:
> 00007ffedc7f5360 RDI: 0000000000000003 [  481.398500] RBP:
> 00007ffedc7f53f0 R08: 0000000000000000 R09: 000055d556f04d50 [
> 481.416463] R10: 0000000000000077 R11: 0000000000000246 R12:
> 00007ffedc7f5360 [  481.434131] R13: 00007ffedc7f5350 R14:
> 00007ffedc7f5344 R15: 0000000000000e98 [  481.451520] Modules linked in:
> ice(OE) af_packet binfmt_misc nls_iso8859_1 ipmi_ssif intel_rapl_msr
> intel_rapl_common x86_pkg_temp_thermal intel_powerclamp mxm_wmi
> mei_me coretemp mei ipmi_si ipmi_msghandler wmi acpi_pad
> acpi_power_meter ip_tables x_tables autofs4 crct10dif_pclmul crc32_pclmul
> ghash_clmulni_intel aesni_intel ahci crypto_simd cryptd libahci lpc_ich [=
last
> unloaded: ice] [  481.528558] CR2: ffffc9000640f038 [  481.542041] ---[ e=
nd
> trace d1f24c9ecf5b61c1 ]---
>=20
> Fix this by only calling ice_vsi_assign_bpf_prog() inside
> ice_prepare_xdp_rings() when current vsi->xdp_prog pointer is NULL.
> This way set_channels() flow will not attempt to swap the vsi->xdp_prog
> pointers with itself.
>=20
> Also, sprinkle around some comments that provide a reasoning about
> correlation between driver and kernel in terms of bpf_prog refcount.
>=20
> Fixes: efc2214b6047 ("ice: Add support for XDP")
> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> Signed-off-by: Marta Plantykow <marta.a.plantykow@intel.com> [ Maciej:
> don't assign the prog if already present, expand commit
>   message ]
> Co-developed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  drivers/net/ethernet/intel/ice/ice_main.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
>=20

Tested-by: Kiran Bhandare <kiranx.bhandare@intel.com>  A Contingent Worker =
at Intel
