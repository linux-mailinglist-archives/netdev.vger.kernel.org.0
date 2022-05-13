Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83789525E96
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 11:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378545AbiEMIsc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 04:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348408AbiEMIs0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 04:48:26 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2046.outbound.protection.outlook.com [40.107.20.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02D5213F1CE
        for <netdev@vger.kernel.org>; Fri, 13 May 2022 01:48:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVjbD6KDr/yfpFto/uuvY/R8VKxzDGLlV4Mh44kuV1XbdJtY3ocd7hfr5iamDqpNUAnTyfo4v2PtYSgnf59eGzIGafNcZq/zIPOD9tFyxQXRITcR0x1raWzHonEcTBmoaz6vY5I6t775eDg+zZWPNVlKxM6CzhEG1cYR7hhC/gFsBzULj0/CSQEOcyUpjpf7DL5JT6ew1iKWNE599T1B7kON/m0mPVDHvpLN+oeVsITaIBUYjDQAfyxsENwaITp6xtg92J6JjTEU0nKXOd++4cWe4o073pICknAYuYSnRmHdrKjknCtYFZiRuCx592m4mPWV+uY2sGMjopodoluHjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=o41ieMXa81N5hM6QaM1+Lr/MN7S3OjMTppu4vRQ2GSA=;
 b=kqXuMOOuOk/IEMKhqYaP2209J7+YOvn/hRLYuLhpi7D+zOW/nLDlh61Ojjzq0hEGYqkbn7QRiUMvExqVYLC7DGcmturGLxJXkbN5spFwzbuaUscI3g8qQsMSj0aWbk0/WI+boxPOfsUGIFt11t9xYORIcumjtTZt5fWFWn9cTCKOt66ktxhcIr2Gs3WhJ01JtFpEbQ8NC8oVJpeDML2TQiG7Cxs7wiKhi23fwQ/hFL7OGE/mSjS2s4dcVH5NiPJQz1O152DTMEAul9MJLj+air8AqMG49W/nAKmMiKw+exi/hm2vYz+7JJ4udQowmdYY50aha4jk/szE6f4Ai6igxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o41ieMXa81N5hM6QaM1+Lr/MN7S3OjMTppu4vRQ2GSA=;
 b=rqsmtGwPP4u0gH5t43jiBZjtT2BvbKKsAsL029M2NWgPlOqJAoS1Kr9azLioj4Av/UaWdHd+MoKnZOucq7aILUPINa6upxsQLhsCtVv7VxcCtOb6VHhV9Wxxar+olKkt3HArJfJQ91roH+BaN4hi/I/RaBVxLaHW30/rwaT/mgQ=
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com (2603:10a6:803:55::19)
 by AM0PR04MB5636.eurprd04.prod.outlook.com (2603:10a6:208:130::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5250.14; Fri, 13 May
 2022 08:48:21 +0000
Received: from VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5]) by VI1PR04MB5136.eurprd04.prod.outlook.com
 ([fe80::fd1f:cc16:dafe:4bf5%5]) with mapi id 15.20.5250.014; Fri, 13 May 2022
 08:48:21 +0000
From:   Vladimir Oltean <vladimir.oltean@nxp.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
CC:     Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>,
        syzbot <syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com>
Subject: Re: [syzbot] WARNING: suspicious RCU usage in
 bond_ethtool_get_ts_info
Thread-Topic: [syzbot] WARNING: suspicious RCU usage in
 bond_ethtool_get_ts_info
Thread-Index: AQHYZmv/LQU3l0oisU2vJ3+vTf735a0cf4uA
Date:   Fri, 13 May 2022 08:48:20 +0000
Message-ID: <20220513084819.zrg4ssnw667rhndt@skbuf>
References: <000000000000fd857805ded5a88e@google.com>
 <Yn25ppe3XtdsxJt+@Laptop-X1>
In-Reply-To: <Yn25ppe3XtdsxJt+@Laptop-X1>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nxp.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d59683e9-4122-480e-2587-08da34bd5537
x-ms-traffictypediagnostic: AM0PR04MB5636:EE_
x-microsoft-antispam-prvs: <AM0PR04MB5636AD200620FF514EDEDD03E0CA9@AM0PR04MB5636.eurprd04.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BAkU4qvTGaJT7EZ7vyX8u5ntxt8b+Nnuq79CymTg38biCOm9/3wrxrHnjrmKmBG9LuZojse1A0VnHluC27SggHzGxa+GsanAf07Oym+RaKayq0Aq2xaSPsqT7csphSl17xC3kOA0FWITktoXxMwnCPSNclaSYr2IwkRumSHP0m5AezLnDpJSkhRyZWXsTJpb1sEBc6nj+oYfo2WvJELwmgXwloHQSPF/2WVMfK8oIW9kXd/yU9jh0HmroiiJL2sGGK0Dq3JlWwgR9bipn8Hnty7YR60iXYvTol1kyoftEbTSrrGKrsfHcY6i1eV0xGEjah8de1nc3W5kYscKZKf9x8oZbwl/A1+r4PnSASSBTJatBLkoA0nebFXLn6O5ejilZhLmc4QiiMZ3DevB4s6eQQr1vCyx+BEHj/ImQ5JsPi7GGAT8ewc1j2HRLvtsumKHlRmC0inaAJoRaTBCTD/sCC2LlRlg0fFWBw82K9poXpy+A0nv/k5Gce0gju1n0ewbvsYrJ/zM2ZTv5zCqawAaoW8SNjG6sz3Knc0mn+QJ9ul9d4j2KN7vG8eLWaFgMfr/CR8gXEWXAAPV1APMQvbGwsYpso+ZrGHHTkN/NazNel56Wk2jbkeeZvxOU4yFrwZwasfkR061P7toMy7yYXDFg24SKDk/YYovSK2Z1ihU/mpscJnccYDdL8UDlPTgp5SEyW3oJ9qRgrhEzjH2KyCSXekogQ5cL4i8GE9vnxL2w2MIc+5mczv3t3OEM2444aQhvhsxZ85zGpuAIDGCgC7jqcIOsVeEJchOCAwjqpZaTQH+mquu34hMJQqqMb4uwE4C
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5136.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(38070700005)(38100700002)(6486002)(54906003)(71200400001)(83380400001)(186003)(6512007)(9686003)(26005)(508600001)(33716001)(5660300002)(8936002)(2906002)(44832011)(7416002)(8676002)(91956017)(4326008)(966005)(316002)(6916009)(6506007)(86362001)(64756008)(66556008)(76116006)(66476007)(66446008)(1076003)(66946007)(122000001)(99710200001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?5Cq7UH6yKGkN703p6Oj37GWrVUQQaBufabBKw/b+0I9iJ0MH9MP8aghxGf5r?=
 =?us-ascii?Q?oUQrtUROm/ekzNhXMmsI36gVOt7pW0aJq9yiA0pEpCSazjBJSghD3myDAcZM?=
 =?us-ascii?Q?CXsNZU/vQWRKjRco4qknEX0gCCdG2sY7S6CXpUoYfJyS5Bra330azVm67TWW?=
 =?us-ascii?Q?3iMp8gv5l7vY3gzI/NkC/YzhycuQAovkkCil6zN6d0XAI4riKVlvejaPlnKD?=
 =?us-ascii?Q?yZxSX0U7MJIvhpsyv1LJ4c1v9PFalXKuKuGxY9OJue+DrvZBARYTPPFthEmf?=
 =?us-ascii?Q?Kele4n/g1ONCv/BfV8WjxO+64UXsQiftukNAq8Rd61+S544rZezAktn3ml0D?=
 =?us-ascii?Q?cXAphm1dlrtRcgsLD3jsVwlM5EuQlOl8rFSaPNc7rSua3OJkTUNFAD/o73sL?=
 =?us-ascii?Q?oMLzdeZlD//LgN2FBQbTUA8OduyZZQcfgH5x7FZQ+bNgN1C+VBb6v709xi7/?=
 =?us-ascii?Q?I6n+DoITpxAqKwQ9SEpy3wHPbBVpzatVGDgC3yukis/Be6Mjk9rbC3Cp5Gph?=
 =?us-ascii?Q?kwbQOuEIL67QKehb9JMJFeVEanbbsJjFEfHZpc48/QF54H6HChOzaZL3Risy?=
 =?us-ascii?Q?HIXLv+m/AxmlKAs+9ktImGl0Jep7eHxuotyU/yuARNVWTrEgpZO7jo2so0fg?=
 =?us-ascii?Q?ZtsDxTj5xLcitDXteaq/duvC90tMBj9HKRrJOG+J/DW5ZKJmICfibe46l4IN?=
 =?us-ascii?Q?DEerOt1/wsUooGe8/Z3OhvziSIVqAsb6r3wGrmnFXTNbuqjYSMEGQ2zYmkFW?=
 =?us-ascii?Q?bx0nJJ9dcS1D74ZdWxhX//k56tUxOessO8EJzI+KFJJAk1vQ9FRSHdzWlXC0?=
 =?us-ascii?Q?hcPswjUizQG/woZUpPBU5gbrd5DaTg9Ngc5h/akZYrepBZG7fRuYpV3A9Bq1?=
 =?us-ascii?Q?fuR1EjcevSi8mpZBGtaCaE+HNojKycXvQGLHJYXwbuDq+Gj5CVDEhzrohWFa?=
 =?us-ascii?Q?2GhEWFj1civCzVDzNwdQdM9fyw+PRqKVDpdy0LcfMY7UsBApOUow3DkNYmmU?=
 =?us-ascii?Q?rspJIP9o5R8nq3fbiNQzPCU1Qv47DOUTMjWB16FiYS+xkMcUvydu5X8q6pw3?=
 =?us-ascii?Q?4QBCXd/sOJYlMElaVXJ3Fzk4xL12abKEQtC9Fm7N3aWBKPvcwx3MC2IGNXi8?=
 =?us-ascii?Q?BQm2+RU2LtdrpLQqtfKa2iNPUyYUouSu0/isinEXAtsVHYNbxd8hcQrX0Ucw?=
 =?us-ascii?Q?RjdPNqfhueXoXQBNNWKXFxHfKqo5NwlVZTOT16OTzjWQFs6rq+BwcVNMrIiX?=
 =?us-ascii?Q?jdOgN9/97oenos7iMRmTbTCZjBt9rzotxv0XQI+gdy0in7UUcKDPAhj2+opd?=
 =?us-ascii?Q?xQ6HrT3wlG63Ppcx5+C3Ei5dhSLq26n6AZsImWEcz6mrqfLM88/H+Dbw51AM?=
 =?us-ascii?Q?eyzLI8Krc3Psn/wxaP2VB5KKQdHS928BFVonE68T0euHPxmpqF+dHtkjWQba?=
 =?us-ascii?Q?+OsHKg+omkT8f+tf5fi2xk+Kla96Lb5Yaa1HHW1xuN28kryPDXF6kLwkKZMN?=
 =?us-ascii?Q?67TlwjmptC+ERzLxcVY2dIYjZqudEERBOy9JhNGIFmvMEMVBGJAqvpjYlfXt?=
 =?us-ascii?Q?EarimBDte2Pe9GD835HQ4GeSuLbPL035NOxno1uuBaEnaEtZ9MScEFPhMT4d?=
 =?us-ascii?Q?W7ZR43wQIJ7u67YQlLMYjQ90+SwfS+F+JsvfvJu6ji+KkvdbaHOEwjzAHiqZ?=
 =?us-ascii?Q?4GTcM7zOWpWxh83tRqX04yGOnK1LkaYotlCk0L8mHj6difO1I/zskdcNEVs4?=
 =?us-ascii?Q?dy1TF7i9A/Xa8fyE74m/zQgA1GROp5I=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7A339F646F263041BA921D1E210BCD61@eurprd04.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5136.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d59683e9-4122-480e-2587-08da34bd5537
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2022 08:48:20.8862
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JKfJGMEy6MD9iV5MZJNIfZ9sYde4a7qM0bAkYItu0FXE030A3/RHA69J/K/2gPJkSPMZRzGdLfftfKRCIO/6Qg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5636
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 13, 2022 at 09:51:34AM +0800, Hangbin Liu wrote:
> Remove bpf guys from cc list.
>=20
> On Thu, May 12, 2022 at 12:35:28PM -0700, syzbot wrote:
> >=20
> > The issue was bisected to:
> >=20
> > commit aa6034678e873db8bd5c5a4b73f8b88c469374d6
> > Author: Hangbin Liu <liuhangbin@gmail.com>
> > Date:   Fri Jan 21 08:25:18 2022 +0000
> >=20
> >     bonding: use rcu_dereference_rtnl when get bonding active slave
> >=20
> > bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D16fce349=
f00000
> > final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D15fce349=
f00000
> > console output: https://syzkaller.appspot.com/x/log.txt?x=3D11fce349f00=
000
> >=20
> > IMPORTANT: if you fix the issue, please add the following tag to the co=
mmit:
> > Reported-by: syzbot+92beb3d46aab498710fa@syzkaller.appspotmail.com
> > Fixes: aa6034678e87 ("bonding: use rcu_dereference_rtnl when get bondin=
g active slave")
> >=20
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> > WARNING: suspicious RCU usage
> > 5.18.0-rc5-syzkaller-01392-g01f4685797a5 #0 Not tainted
> > -----------------------------
> > include/net/bonding.h:353 suspicious rcu_dereference_check() usage!
> >=20
> > other info that might help us debug this:
> >=20
> >=20
> > rcu_scheduler_active =3D 2, debug_locks =3D 1
> > 1 lock held by syz-executor317/3599:
> >  #0: ffff88801de78130 (sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock incl=
ude/net/sock.h:1680 [inline]
> >  #0: ffff88801de78130 (sk_lock-AF_INET){+.+.}-{0:0}, at: sock_setsockop=
t+0x1e3/0x2ec0 net/core/sock.c:1066
> >=20
> > stack backtrace:
> > CPU: 0 PID: 3599 Comm: syz-executor317 Not tainted 5.18.0-rc5-syzkaller=
-01392-g01f4685797a5 #0
> > Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS=
 Google 01/01/2011
> > Call Trace:
> >  <TASK>
> >  __dump_stack lib/dump_stack.c:88 [inline]
> >  dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
> >  bond_option_active_slave_get_rcu include/net/bonding.h:353 [inline]
> >  bond_ethtool_get_ts_info+0x32c/0x3a0 drivers/net/bonding/bond_main.c:5=
595
> >  __ethtool_get_ts_info+0x173/0x240 net/ethtool/common.c:554
> >  ethtool_get_phc_vclocks+0x99/0x110 net/ethtool/common.c:568
> >  sock_timestamping_bind_phc net/core/sock.c:869 [inline]
> >  sock_set_timestamping+0x3a3/0x7e0 net/core/sock.c:916
> >  sock_setsockopt+0x543/0x2ec0 net/core/sock.c:1221
>=20
> Oh, I forgot to check setsockopt path...
>=20
> Hi Vladimir, Jay,
>=20
> Do you think if I should revert my previous commit, or just add
> rcu_read_lock()/rcu_read_unlock() back to bond_ethtool_get_ts_info()?
>=20
> Thanks
> Hangbin

Hi Hangbin,

sock_timestamping_bind_phc() appears to run unlocked, with the exception
of the rcu_read_lock() in dev_get_by_index() in which there is a dev_hold()=
.
I'm thinking that this dev_hold ensures that the bonding interface does
not go away, but it still does not ensure that the active slave does not
go away.

I only looked superficially at this because I am AFK today, but I think
I would put rcu_read_lock() in bond_ethtool_get_ts_info(), but not the
way in which it was before, but rather for the entire time during which
real_dev, ops and phydev are being dereferenced.=
