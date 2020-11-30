Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFD62C8C37
	for <lists+netdev@lfdr.de>; Mon, 30 Nov 2020 19:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387988AbgK3SJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 13:09:29 -0500
Received: from us-smtp-delivery-181.mimecast.com ([216.205.24.181]:38803 "EHLO
        us-smtp-delivery-181.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387935AbgK3SJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 13:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rbbn.com; s=mimecast20180816;
        t=1606759681;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=rXJkqZyL6lOuA4tIto5StCMSHNAbIKp/3OzubQIRIu0=;
        b=km2dXTP7xJtU5Zcr3ZLhGNT1ccC1f+MlpykmQQMk4qCNuDPxxn8rQXpN6Bx7RaS2VyErWG
        bJR5RmNmaDMH9Vj2hXz5X2YzEHSit9IFIjT7lbNHi9yW5L/PzDCw3dr3oRgX1pLkAnum8c
        0MgiHFG9eL50fl0cc5XB/a0acn6QgKA=
Received: from NAM11-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-524-x1lmD96EPZqvzSs9oeb8yg-1; Mon, 30 Nov 2020 13:05:25 -0500
Received: from MN2PR03MB4752.namprd03.prod.outlook.com (2603:10b6:208:af::30)
 by MN2PR03MB5326.namprd03.prod.outlook.com (2603:10b6:208:1f0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3611.23; Mon, 30 Nov
 2020 18:05:23 +0000
Received: from MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df]) by MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df%7]) with mapi id 15.20.3611.031; Mon, 30 Nov 2020
 18:05:23 +0000
From:   "Finer, Howard" <hfiner@rbbn.com>
To:     "j.vosburgh@gmail.com" <j.vosburgh@gmail.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "vfalico@gmail.com" <vfalico@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: bonding driver issue when configured for active/backup and using ARP
 monitoring
Thread-Topic: bonding driver issue when configured for active/backup and using
 ARP monitoring
Thread-Index: AdbHQ00ZgN9FZpM9RKmwxP/JkIcJoA==
Date:   Mon, 30 Nov 2020 18:05:23 +0000
Message-ID: <MN2PR03MB47526B686EF6E0F8D81A9397B7F50@MN2PR03MB4752.namprd03.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [208.45.178.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: f5b6e6eb-f7c7-43a0-7c4d-08d8955a81ef
x-ms-traffictypediagnostic: MN2PR03MB5326:
x-microsoft-antispam-prvs: <MN2PR03MB53262A30EE80DCB3912CF46FB7F50@MN2PR03MB5326.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: EYQULpEukVKYgZOqwOM/pvtHUL+/fLGh03NrR+dsKtwtl5SWGL0NMhmvBXRL6+CTzCtgyKSGRfyzwEcURY7t0cwGeBHGI2vO2vaoOycpfbIU+UHGngrPda9q6TMnLiT3KGVhIiZoJQljcYQKNIbgTRbzvEPSSobjXUN9IKj5U1SeUywFKEB6qrfgcrP5hP0lBNpFtl+XjD8wr86yLvproehi38wOpjP7ILzVbynZzKra5poMQgukg07MDOfN84dxPuU6ClClyH4273Hi0F3U/PPswNKboUa00pzgnZHWDmmjqNysMHvKOrLWdqmzR2kU
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR03MB4752.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(366004)(136003)(346002)(39860400002)(376002)(66476007)(110136005)(71200400001)(8936002)(66446008)(316002)(66556008)(86362001)(5660300002)(4326008)(52536014)(9686003)(478600001)(2906002)(7696005)(76116006)(64756008)(8676002)(26005)(6506007)(55016002)(33656002)(66946007)(186003)(83380400001);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: =?iso-8859-1?Q?MhRCtuQJfRIoCnpiKpDoW/mnzxfoRkXjfxIgcHd1ltNze0DOVKzlcLdxj6?=
 =?iso-8859-1?Q?5v8lRh3ieq00tR8u1ddjuoaBBo+mY4wAreSJZA0lXViauw3FZq/dRWArhw?=
 =?iso-8859-1?Q?EFoJao2MEgXU2YvM/TynJYOFJwzBw5B1Updw8vy9mwDWO0rxQfp+WTnnft?=
 =?iso-8859-1?Q?FrjOPJbfNnROMfyk+GBOjQXtMmqOEk9Ghtxgs9zS+EQujf3zAuCCp9LE/u?=
 =?iso-8859-1?Q?HHVdCvE1Kp5nD7MBJe9q1aVfnOjBvj5NJnaDJJP90apKuRxSg1kUnMVuKB?=
 =?iso-8859-1?Q?0Kqp3MQZTI5sLJJfIBV3z5nk2q1s/x+iLSOr0a134FoRChj0J18x7VKLBr?=
 =?iso-8859-1?Q?KjjZV0k9NA/pAWs8HJgfIUs0ifv/Xy4k2/9c4CTtXGSgoXsn4CjJhwjwfc?=
 =?iso-8859-1?Q?CZ4FE5SLZI9CAy/Ng94HJ9ZXFbG/q4hZBvAiguiduPYNJrfcAvV1NZqI+7?=
 =?iso-8859-1?Q?9RUQPrfnXHLqJ8HVBJwrUrN/QDez4zgplsE6ttRTXVpI3F651nkJ/nf0UT?=
 =?iso-8859-1?Q?QxWrUSnUHYiqpBdSyvggWwsI/NItgLaM6PnnsiNswRd9DqeJxcedFWa5TP?=
 =?iso-8859-1?Q?Fz3pXG4XVuWwNLLJ2e5dgBQvl6RyJKSGWLfT2t2t7vQnMKo21t/QXSsp2G?=
 =?iso-8859-1?Q?HSuqaQelXQ1LEio4aOZFKcl8vdvDnd+Ee2ASQ0o8g0hddvaIP27yDiCvV2?=
 =?iso-8859-1?Q?RxZeZ6CVoYRxUde6L6/r+R4q8gcXCaprOlPyjT8IhiSjujp9pFM2BmtS21?=
 =?iso-8859-1?Q?Abo4kMNDn9JjMCqBrZHCjtCM2zVkykHL/ozq7PDrwKJMHjzO0tEQSxB7Vk?=
 =?iso-8859-1?Q?3OjLmH9FtBEBgW0GaV9Cz7XWA5sRy2EgIKoWxkBD6mpuvMFZpm5m+EREjW?=
 =?iso-8859-1?Q?i8Wvno0o38M58cunMuztsjKKZhZYb7T/VyL5DOowm2KdP3EARNEHaZEmiR?=
 =?iso-8859-1?Q?rj6Stry6jDiWVD/V+x4gQz0kDJWDL6oz97uQpzzPtF5gxEjTr+IjAvt4F8?=
 =?iso-8859-1?Q?L9uqGkRofzj/EoxkE=3D?=
x-ms-exchange-transport-forked: True
x-mc-unique: x1lmD96EPZqvzSs9oeb8yg-1
x-originatororg: rbbn.com
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: MN2PR03MB4752.namprd03.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: f5b6e6eb-f7c7-43a0-7c4d-08d8955a81ef
x-ms-exchange-crosstenant-originalarrivaltime: 30 Nov 2020 18:05:23.1556 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 29a671dc-ed7e-4a54-b1e5-8da1eb495dc3
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: nYJZuZkRwt2WsQoa2PgsVebnV68KLa6zh0jMAlXnKs9vych3cKWoyHjNV6sIWQ2x
x-ms-exchange-transport-crosstenantheadersstamped: MN2PR03MB5326
MIME-Version: 1.0
Authentication-Results: relay.mimecast.com;
        auth=pass smtp.auth=CUSA81A106 smtp.mailfrom=hfiner@rbbn.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: rbbn.com
Content-Language: en-US
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

We use the bonding driver in an active-backup configuration with ARP monito=
ring. We also use the TIPC protocol which we run over the bond device. We a=
re consistently seeing an issue in both the 3.16 and 4.19 kernels whereby w=
hen the bond slave is switched TIPC is being notified of the change rather =
than it happening silently.  The problem that we see is that when the activ=
e slave fails, a NETDEV_CHANGE event is being sent to the TIPC driver to no=
tify it that the link is down. This causes the TIPC driver to reset its bea=
rers and therefore break communication between the nodes that are clustered=
.
With some additional instrumentation in thee driver, I see this in /var/log=
/syslog:
<6> 1 2020-11-20T18:14:19.159524+01:00 LABNBS5B kernel - - - [65818.378287]=
 bond0: link status definitely down for interface eth0, disabling it
<6> 1 2020-11-20T18:14:19.159536+01:00 LABNBS5B kernel - - - [65818.378296]=
 bond0: now running without any active interface!
<6> 1 2020-11-20T18:14:19.159537+01:00 LABNBS5B kernel - - - [65818.378304]=
 bond0: bond_activebackup_arp_mon: notify_rtnl, slave state notify/slave li=
nk notify
<6> 1 2020-11-20T18:14:19.159538+01:00 LABNBS5B kernel - - - [65818.378835]=
 netdev change bearer <eth:bond0>
<6> 1 2020-11-20T18:14:19.263523+01:00 LABNBS5B kernel - - - [65818.482384]=
 bond0: link status definitely up for interface eth1
<6> 1 2020-11-20T18:14:19.263534+01:00 LABNBS5B kernel - - - [65818.482387]=
 bond0: making interface eth1 the new active one
<6> 1 2020-11-20T18:14:19.263536+01:00 LABNBS5B kernel - - - [65818.482633]=
 bond0: first active interface up!
<6> 1 2020-11-20T18:14:19.263537+01:00 LABNBS5B kernel - - - [65818.482671]=
 netdev change bearer <eth:bond0>
<6> 1 2020-11-20T18:14:19.367523+01:00 LABNBS5B kernel - - - [65818.586228]=
 bond0: bond_activebackup_arp_mon: call_netdevice_notifiers NETDEV_NOTIFY_P=
EERS

There is no issue when using MII monitoring instead of ARP monitoring since=
 when the slave is detected as down, it immediately switches to the backup =
as it sees that slave as being up and ready.    But when using ARP monitori=
ng, only one of the slaves is 'up'.  So when the active slave goes down, th=
e bonding driver will see no active slaves until it brings up the backup sl=
ave on the next call to bond_activebackup_arp_mon.  Bringing up that backup=
 slave has to be attempted prior to notifying any peers of a change or else=
 they will see the outage.  In this case it seems the should_notify_rtnl fl=
ag has to be set to false.    However, I also question if the switch to the=
 backup slave should actually occur immediately like it does for MII and th=
at the backup should be immediately 'brought up/switched to' without having=
 to wait for the next iteration.

static void bond_activebackup_arp_mon(struct bonding *bond)
{
                bool should_notify_peers =3D false;
                bool should_notify_rtnl =3D false;
                int delta_in_ticks;

                delta_in_ticks =3D msecs_to_jiffies(bond->params.arp_interv=
al);

                if (!bond_has_slaves(bond))
                                goto re_arm;

                rcu_read_lock();

                should_notify_peers =3D bond_should_notify_peers(bond);

                if (bond_ab_arp_inspect(bond)) {
                                rcu_read_unlock();

                                /* Race avoidance with bond_close flush of =
workqueue */
                                if (!rtnl_trylock()) {
                                                delta_in_ticks =3D 1;
                                                should_notify_peers =3D fal=
se;
                                                goto re_arm;
                                }

                                bond_ab_arp_commit(bond);

                                rtnl_unlock();
                                rcu_read_lock();
                }

                should_notify_rtnl =3D bond_ab_arp_probe(bond);
                rcu_read_unlock();

re_arm:
                if (bond->params.arp_interval)
                                queue_delayed_work(bond->wq, &bond->arp_wor=
k, delta_in_ticks);

                if (should_notify_peers || should_notify_rtnl) {
                                if (!rtnl_trylock())
                                                return;

                                if (should_notify_peers)
        {
            netdev_info(bond->dev, "bond_activebackup_arp_mon: call_netdevi=
ce_notifiers NETDEV_NOTIFY_PEERS\n");

                                                call_netdevice_notifiers(NE=
TDEV_NOTIFY_PEERS,
                                                                           =
                     bond->dev);
        }
                                if (should_notify_rtnl) {

            netdev_info(bond->dev, "bond_activebackup_arp_mon: notify_rtnl,=
 slave state notify/slave link notify\n");
                                                bond_slave_state_notify(bon=
d);
                                                bond_slave_link_notify(bond=
);
                                }

                                rtnl_unlock();
                }
}

As it currently behaves there is no way to run TIPC over an active-backup A=
RP-monitored bond device.  I suspect there are other situations/uses that w=
ould likewise have an issue with the 'erroneous' NETDEV_CHANGE being issued=
.   Since TIPC (and others) have no idea what the dev is, it is not possibl=
e to ignore the event nor should it be ignored.  It therefore seems the eve=
nt shouldn't be sent for this situation.   Please confirm the analysis abov=
e and provide a path forward since as currently implemented the functionali=
ty is broken.

Thanks,
Howard Finer
hfiner@rbbn.com


