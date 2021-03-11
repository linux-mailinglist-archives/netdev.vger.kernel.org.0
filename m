Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C01733710F
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 12:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232602AbhCKLUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 06:20:36 -0500
Received: from mail-mw2nam10on2047.outbound.protection.outlook.com ([40.107.94.47]:40417
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232579AbhCKLUd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Mar 2021 06:20:33 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JIRIXj7LIRSrCURFo8jbjXwmvNdkQprQf0upWEBDAjh477x6O2SO4AWCPJ5MTS5IgW0E9UvblDXq8LLii6JMOVTHRcO5BIWfVZ7bY3m6wTWZiNEpLmkrnBtqFI73NAec5hCzX3U07f2pTRhzeZVEAE4luXoA8CQeFCaZhFzM3L3PARtJVsHbs4SP3XbEJXihx3410pRCZKyw1UK/5+E6Yh0nFu100UgvhTCrE11bEhQXS3i1HqNB8s5YLGB+PL6b7GEQR4kgsA7XTgQdoJTpmGdn8VHnYvFa2ioMjAhzS4T9lW9oOF9PCLFqcCYOTNJMVKxqgbYZEbynGIYj8329Rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLAbf5GPYqsJTxjz8PBSNtnQTxzhrxjOVeefMNcZwgM=;
 b=a6tJs4y9xrm9amSb7iJDmKb+WglsPWga8l4/C57EL17XGDaWW04tixxFTheQWUCcYpqI3PX6bCdchGH/mEJpMzXFG8MDpQJUsj43B4sGCL2Aq/bjBVpoDahxtv4A5fzOHY0ybR+bC3FIUeMBY+W0VKWaiJ/UsWrVEa6zR2S+hcz1zNKr8dSHrFQt54JFr5KAQPUG466SSg6J+fPbZHqWScKH7Uq6Y2Il3GTQ4im659wMpBIuL/eZgyCUQVTpgmwt+dwtk9z50eBpqfwdU8IOEHcFnUpidz6pVQuQtCtH0c26ow0KuVtOGUBW6SAqTlgicle0CP36G+/gpDUnlbUoYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uLAbf5GPYqsJTxjz8PBSNtnQTxzhrxjOVeefMNcZwgM=;
 b=hr4AyvZwkEsRNL5e1XvmBQFFnC/BAPV0EeANb6kM3dy+Mq0ky0p/gSWDJEc5h+/mY4lGHHonFIKxE6lAvbQnIbWJfw+yDVYSg/Njd0llAcRx5Z3ZIbi8I/waEIR7cvcr+LY4rioFSFjzjYvX8d3wmh7B4EfsdYrElhxSWfVWospSlh1RZsGFzjAm879wmnDbZy3DL9AAaXtidtXcS/w2PNKBDwCquuSZ1oW5DM6KiobVby9zpT4b3dRZ3cMI7dAqeMQ5mSt0P8FgZZEwgI4ZqACaAfSm6uLUCFap3KPGqwTN7fSpYs671PrdZTVLHftHC6oB2VKgQ1PqkRw3BQdLrg==
Received: from DM6PR12MB4516.namprd12.prod.outlook.com (2603:10b6:5:2ac::20)
 by DM6PR12MB3771.namprd12.prod.outlook.com (2603:10b6:5:1ca::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.30; Thu, 11 Mar
 2021 11:20:27 +0000
Received: from DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::6da1:b68:5ada:ebfd]) by DM6PR12MB4516.namprd12.prod.outlook.com
 ([fe80::6da1:b68:5ada:ebfd%9]) with mapi id 15.20.3912.031; Thu, 11 Mar 2021
 11:20:27 +0000
From:   Danielle Ratson <danieller@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "acardace@redhat.com" <acardace@redhat.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "gustavo@embeddedor.com" <gustavo@embeddedor.com>,
        "magnus.karlsson@intel.com" <magnus.karlsson@intel.com>,
        "ecree@solarflare.com" <ecree@solarflare.com>,
        Ido Schimmel <idosch@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        mlxsw <mlxsw@nvidia.com>
Subject: RE: [PATCH net] ethtool: Add indicator field for link_mode validity
 to link_ksettings
Thread-Topic: [PATCH net] ethtool: Add indicator field for link_mode validity
 to link_ksettings
Thread-Index: AQHXENYt/EtnbsrjdkyzmzqEnwYicqp0K9CAgAqDcRA=
Date:   Thu, 11 Mar 2021 11:20:27 +0000
Message-ID: <DM6PR12MB451613A284ADE2C5AF64D545D8909@DM6PR12MB4516.namprd12.prod.outlook.com>
References: <20210304090933.3538255-1-danieller@nvidia.com>
 <20210304104653.65d7af1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210304104653.65d7af1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [93.173.23.32]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a3d7c18a-c96a-418f-a853-08d8e47fac28
x-ms-traffictypediagnostic: DM6PR12MB3771:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR12MB3771AFC8EF0E814BCBA7010DD8909@DM6PR12MB3771.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a1rcBnSJsimJoU8cgIhrgOtYwnjluUImBe5uYJzIujpCKpAMBIg26i+MZuVDRjfYmT8/YshiGUzJzHmsT2CoFf9fHMZJv4agrtxD4KmStD7gmZeTdYI0LGbs8RgnAXNCC4OGxmdrd9CTOTCAQnzomGBPwYOgkcfKq0hJ+grws6tulqIxjCJQGkl6NyMoYzryU/7RaoJVNE5CaD7pbedqLuWfGuljHR2an2fbsR5wjyx9DEF5p+bhCZ7kgiUgiaEyy0sR7cHO+uN03jgtiOzoJ8FyMZBsZ6p4K/HVXjQqc8Qt8aZ+zA33jSwdZnUrnzfIaFKyRUhxlrw3rjMO1Dl2TJFZD1eNCQbD8L9JQVJTXALKbSqo9FzXWtbvMxbbHspXMs4FWNMoFUCCaBH5A/I5D91LVnUqzxo2meNNaHX7mhco2G3pqkSuBLlmtOMGlSiyj51tt8b78bbaMkcBUCXbh0QMcM9FRrrEtgBMs/24GIZ/T+HlkC9nJJZj72ir8jamgwfaYZ8tVItij1zQJYF2rw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4516.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(136003)(396003)(376002)(346002)(39860400002)(9686003)(6506007)(53546011)(107886003)(4326008)(478600001)(7416002)(33656002)(8936002)(83380400001)(76116006)(66446008)(64756008)(2906002)(66556008)(52536014)(54906003)(8676002)(66946007)(66476007)(316002)(26005)(55016002)(71200400001)(86362001)(6916009)(5660300002)(7696005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?4p3iUZSlCIa3lK4+JOmi2HyayMPU2s5VOeI+TitwawgF81yK2tKVg0CeJhZI?=
 =?us-ascii?Q?cDuD7FwIoPHdCvDa3vuIFcMpCVEVeUa+dq3u8+6J/+9TQQTRHgVLMDc4Nprq?=
 =?us-ascii?Q?oeUo/j6FTiIRaibTPH6DRRLHqrm5XauVjv4LmJzzxIFMgCWxIQexIQLoQDmE?=
 =?us-ascii?Q?X3bwnRpANUVPpRJMDgFJge1ce08hSmpyApUitNuU+97nKSZerLxQ4yDHKQ22?=
 =?us-ascii?Q?9CH9Xp572YR7ZvNPh1xHm7wKT4ZE65uBt7Mcx1a7TEA6N8YS3A0HBKghTp8q?=
 =?us-ascii?Q?R4/SOm06Alt/scAJehFTQDBPdAP0eHlp049cAKOkkOOhkJuM+HdL7t/XRxq+?=
 =?us-ascii?Q?GhQswFup5CFFe8iu6N9L86rv9RAMX01FfLT1g0PLtdlu1z2KoOCeRtoCAG2W?=
 =?us-ascii?Q?eSMDW3xyfB8gZ0gQRNYH0WtaIoBogTHHgReFN33+QQ66RDafMlQIeWOyM37r?=
 =?us-ascii?Q?M9gZFgEf6SPq+/J9i22aVxdM78T6L2FpxqIyLN6FKVowv80rb+LDIEIi502k?=
 =?us-ascii?Q?RRZ0QpTcY5quKLChOyJxTDMfb2b6pBS319WdT5FlMnMzSTRo2hPOVTuCaMRW?=
 =?us-ascii?Q?3zXrERuCrlrISLbv6vGv4MsU4KxgOjSKdJn73eCMIsNWuNQbJo/iHSq5ImEp?=
 =?us-ascii?Q?OAQJLN4brDMlm5a4O3X3cQCEu5VqYfZIKEF9/xipSvsRRchGAM2aGtQx6Atz?=
 =?us-ascii?Q?rwhQ4xzwcxuYol6vnWg7fW7YIaFl/io4bvIxKy6YBusSP4E/Fsl99I5SD42t?=
 =?us-ascii?Q?UzGd4xYJXYBnxPJJOpCBiEyjRYTQ1j9cBUMNMugu5leR3P/6W/mRta3HfXgp?=
 =?us-ascii?Q?8WAwdFqg0xKFXbPli8aGCERQMIgl63BYcaXLz9Z1aVnaNqlioNnwVkBp001B?=
 =?us-ascii?Q?8bL7m6+lnTlJpyMTcMRN0MCVSASwKdJodJbwwVZezuSOB2p5weqvc2Eg6tFn?=
 =?us-ascii?Q?DfoQlZDlc4f+SC3QeSgj+2gcGssjogOxONeadc6+9OP38kelDkrC3eG3WHyP?=
 =?us-ascii?Q?yEaJxPLfEmg4ljhgSoIiEpFAkLxfj3agxNCeMXpnjt+KoF40gbdGkaFOedlI?=
 =?us-ascii?Q?8fUBmDh+wXpA6YR/ZlWiV1jJQihe/8d7H8T4jW551QRGzvK2CRrWA98mDKXY?=
 =?us-ascii?Q?kK8fzHZihesAa4P/enirdlcSStb1LcrwcEHXwyVGZn+AejM3f0EegZPPD4OA?=
 =?us-ascii?Q?DDXKveuUcjRM4Yeahu2MLyUJfOudj8AtJ19pa+XkZBLGA7eaetDaUhfu5Zvs?=
 =?us-ascii?Q?KLD1jxxF4oOe2d07s4mm3t9vwMkhrf//S2GIuFxSQIRpFjFjkdyKiADYf3Xj?=
 =?us-ascii?Q?m6o=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4516.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a3d7c18a-c96a-418f-a853-08d8e47fac28
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Mar 2021 11:20:27.2015
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: /tY1SstGi9IUu1LnjRthUeJAWQWvMpkGFwwyU7qy6y+GskQ8PR7F9eSQLG7rJAoCi2jeV9hx6pPwtw2ZcIp8zQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3771
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, March 4, 2021 8:47 PM
> To: Danielle Ratson <danieller@nvidia.com>
> Cc: netdev@vger.kernel.org; davem@davemloft.net; eric.dumazet@gmail.com; =
andrew@lunn.ch; mkubecek@suse.cz;
> f.fainelli@gmail.com; acardace@redhat.com; irusskikh@marvell.com; gustavo=
@embeddedor.com; magnus.karlsson@intel.com;
> ecree@solarflare.com; Ido Schimmel <idosch@nvidia.com>; Jiri Pirko <jiri@=
nvidia.com>; mlxsw <mlxsw@nvidia.com>
> Subject: Re: [PATCH net] ethtool: Add indicator field for link_mode valid=
ity to link_ksettings
>=20
> On Thu, 4 Mar 2021 11:09:33 +0200 Danielle Ratson wrote:
> > Some drivers clear the 'ethtool_link_ksettings' struct in their
> > get_link_ksettings() callback, before populating it with actual values.
> > Such drivers will set the new 'link_mode' field to zero, resulting in
> > user space receiving wrong link mode information given that zero is a
> > valid value for the field.
> >
> > Fix this by introducing a new boolean field ('link_mode_valid'), which
> > indicates whether the 'link_mode' field is valid or not. Set it in
> > mlxsw which is currently the only driver supporting the new API.
> >
> > Another problem is that some drivers (notably tun) can report random
> > values in the 'link_mode' field. This can result in a general
> > protection fault when the field is used as an index to the
> > 'link_mode_params' array [1].
> >
> > This happens because such drivers implement their set_link_ksettings()
> > callback by simply overwriting their private copy of
> > 'ethtool_link_ksettings' struct with the one they get from the stack,
> > which is not always properly initialized.
> >
> > Fix this by making sure that the new 'link_mode_valid' field is always
> > initialized to 'false' before invoking the set_link_ksettings()
> > callback.
> >
> > [1]
> > general protection fault, probably for non-canonical address
> > 0xdffffc00f14cc32c: 0000 [#1] PREEMPT SMP KASAN
> > KASAN: probably user-memory-access in range
> > [0x000000078a661960-0x000000078a661967]
> > CPU: 0 PID: 8452 Comm: syz-executor360 Not tainted 5.11.0-syzkaller #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine,
> > BIOS Google 01/01/2011
> > RIP: 0010:__ethtool_get_link_ksettings+0x1a3/0x3a0
> > net/ethtool/ioctl.c:446
> > Code: b7 3e fa 83 fd ff 0f 84 30 01 00 00 e8 16 b0 3e fa 48 8d 3c ed
> > 60 d5 69 8a 48 b8 00 00 00 00 00 fc ff df 48 89 fa 48 c1 ea 03 <0f> b6
> > 14 02 48 89 f8 83 e0 07 83 c0 03
> > +38 d0 7c 08 84 d2 0f 85 b9
> > RSP: 0018:ffffc900019df7a0 EFLAGS: 00010202
> > RAX: dffffc0000000000 RBX: ffff888026136008 RCX: 0000000000000000
> > RDX: 00000000f14cc32c RSI: ffffffff873439ca RDI: 000000078a661960
> > RBP: 00000000ffff8880 R08: 00000000ffffffff R09: ffff88802613606f
> > R10: ffffffff873439bc R11: 0000000000000000 R12: 0000000000000000
> > R13: ffff88802613606c R14: ffff888011d0c210 R15: ffff888011d0c210
> > FS:  0000000000749300(0000) GS:ffff8880b9c00000(0000)
> > knlGS:0000000000000000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00000000004b60f0 CR3: 00000000185c2000 CR4: 00000000001506f0
> > DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> > DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400 Call
> > Trace:
> >  linkinfo_prepare_data+0xfd/0x280 net/ethtool/linkinfo.c:37
> >  ethnl_default_notify+0x1dc/0x630 net/ethtool/netlink.c:586
> >  ethtool_notify+0xbd/0x1f0 net/ethtool/netlink.c:656
> >  ethtool_set_link_ksettings+0x277/0x330 net/ethtool/ioctl.c:620
> >  dev_ethtool+0x2b35/0x45d0 net/ethtool/ioctl.c:2842
> >  dev_ioctl+0x463/0xb70 net/core/dev_ioctl.c:440
> >  sock_do_ioctl+0x148/0x2d0 net/socket.c:1060
> >  sock_ioctl+0x477/0x6a0 net/socket.c:1177  vfs_ioctl fs/ioctl.c:48
> > [inline]  __do_sys_ioctl fs/ioctl.c:753 [inline]  __se_sys_ioctl
> > fs/ioctl.c:739 [inline]
> >  __x64_sys_ioctl+0x193/0x200 fs/ioctl.c:739
> >  do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
> >  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> >
> > Fixes: c8907043c6ac9 ("ethtool: Get link mode in use instead of speed
> > and duplex parameters")
> > Signed-off-by: Danielle Ratson <danieller@nvidia.com>
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Reviewed-by: Ido Schimmel <idosch@nvidia.com>
>=20
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>
>=20
> BTW shouldn't __ethtool_get_link_ksettings() be moved to common.c?

I'll send a patch for net-next, thanks.
