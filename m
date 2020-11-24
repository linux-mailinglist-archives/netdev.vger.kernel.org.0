Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 100992C3025
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 19:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404121AbgKXSox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 13:44:53 -0500
Received: from us-smtp-delivery-181.mimecast.com ([216.205.24.181]:42389 "EHLO
        us-smtp-delivery-181.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2390971AbgKXSov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 13:44:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=rbbn.com; s=mimecast20180816;
        t=1606243489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=jWcAEjsGst2QqfuEC+c16jzMZzUfKKcofDuA+wFkEJY=;
        b=ZD2vylk6NqIeAMV0HUAsHlN/O3wgeg6Fgwv1ZfXjlfpC/GxPYytLcSCQrcsrL170QIVBtv
        NsdGdpL4Gz6Gmlz3iJm58+31pSG0m8suvmEsrs4KAZG4RPe9/cNHMrbs1jHMcZZW+QXQYa
        xgGeTTVNL/gJ85AxKqLprYQYfKjhCQk=
Received: from NAM12-BN8-obe.outbound.protection.outlook.com
 (mail-bn8nam12lp2173.outbound.protection.outlook.com [104.47.55.173])
 (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-363-N9MdL_neNfWWtwDdmuQjtQ-1; Tue, 24 Nov 2020 13:44:20 -0500
Received: from MN2PR03MB4752.namprd03.prod.outlook.com (2603:10b6:208:af::30)
 by MN2PR03MB4686.namprd03.prod.outlook.com (2603:10b6:208:a9::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3589.20; Tue, 24 Nov
 2020 18:44:18 +0000
Received: from MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df]) by MN2PR03MB4752.namprd03.prod.outlook.com
 ([fe80::e888:49b:bdd7:75df%7]) with mapi id 15.20.3589.030; Tue, 24 Nov 2020
 18:44:18 +0000
From:   "Finer, Howard" <hfiner@rbbn.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: bonding in active/backup with ARP monitoring does not silently switch
 the slaves
Thread-Topic: bonding in active/backup with ARP monitoring does not silently
 switch the slaves
Thread-Index: AdbCbOAfz/YdTZIfSnG9dmZAsTsCTw==
Date:   Tue, 24 Nov 2020 18:44:18 +0000
Message-ID: <MN2PR03MB475257C03E3F3DD4B75E0413B7FB0@MN2PR03MB4752.namprd03.prod.outlook.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [208.45.178.4]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a50fd3fd-b1cb-4833-4174-08d890a8f375
x-ms-traffictypediagnostic: MN2PR03MB4686:
x-microsoft-antispam-prvs: <MN2PR03MB46862AE248174665175F3C05B7FB0@MN2PR03MB4686.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0
x-microsoft-antispam-message-info: uzwAmov5W6VsEbKclvxcUFxC5N0UUf9RRBT8msXMIpFso+Vs9c20Zi/xs2z/ayPoORxr631oOQ7U76XGIZHVCMKN7rntsuGJxGzBzYR2ujhHyorkOe8DpnjEbCR9qoQHZx/Ht8eyLkoj8oTSTL7tJYk66ZaF3ID20E/c60XMXcQj0wWpWmJJCqLv8rdIti4rjjtOeH14vWIChBCB/AC3lPJEFUqtPvZrumzZsxqiCDqxzTr5fyNfF1b8uf1XZSQoJeeTNmpZdUh6rAA+Ba6vPyLzPid7EEs2w9pfwyH29lNtM1tJEDZmP5rANNBZTOPICh5j7lsY5l4VHq/KkO7Vzg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR03MB4752.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(396003)(376002)(136003)(366004)(346002)(39860400002)(7696005)(83380400001)(8936002)(55016002)(5660300002)(186003)(8676002)(478600001)(26005)(6506007)(9686003)(86362001)(64756008)(66556008)(66476007)(76116006)(6916009)(316002)(66946007)(2906002)(66446008)(52536014)(71200400001)(33656002);DIR:OUT;SFP:1101
x-ms-exchange-antispam-messagedata: SKckSFAFsCK6lE+jRjdx7ZfnJ2nAehAh4zZ4DxAlHoWVrGHFbVyiS4S2lu86G6B4ArMWQZ9eBgBxFrIYbAeKlBu5TqTh0DgIKfh6ME+Yl4l6Pk1eG3PA2yUUFeqoNqRH+hGcG/cgRdWGqEsybbVebU8CWljtnc8bCDgklBloMhyz2cW6uKgzAMT4Qg+Ye+Qo7YxMTNVXVTSntwZgSOMgOU9vkrkXijWTLpZdeQV5SdOMEIx6xgrxtBjFr+WX8Q/KAdrY3HICzlcDKmZHiZTja6EQhlf2E7x4WoE58n6NVUpb44asDxpS+OudtJRgrDrRynWnZ6QZrmlWJnm9c5GQe48Ofhn/7yn1pFaAGnsAmmliaSi/YCGUJSY8wZ8a0/BxMJimq4jZP2bAc+1Ee0S8xFxV2dPtrAK7P3jiW6tKaE8CcH+vNpOPKs5AnXYyLPoChvzAWOPER7uACsWUVwnAZJOQUJlBwqIZEziYmCN1XybmCLZ9PzBcZmvLEBfLh24cDpQbs24jf5DFZQ2vawGv817SoBm43NUilxmZWATtZaqyWSPgG3b8gwNWTBRF8m/+EPtga7nTjM+66rGqD8CXsWus9XCjSj0po/9jNPn/gBnIY83p9jybg6fttnQpOmho44PrzhhrOKp9v1kr4m4xcqH04+lhRVCxnccc1Sz0W/skt5HCPBvpy9Vl64JWWcyuNasP61fTP/vqRbFAc0TexMua/OT/gbuejknLy8qb3HsiGRoQ4fj50MnsRR/PWZylY82pTxddoatTmnsUgVL2HHcUmrRojdscetwOOq33BH5BsGomCDuu8JNs14A0NjkSXvLIay3GD87RHt53Ihw0cEnjbxXwXHKx5hgM6MnR3nlZSPFyUyKUb+KMaJjXzzWK9hu23XawQxLja/eDOd6/Eg==
x-ms-exchange-transport-forked: True
x-mc-unique: N9MdL_neNfWWtwDdmuQjtQ-1
x-originatororg: rbbn.com
x-ms-exchange-crosstenant-authas: Internal
x-ms-exchange-crosstenant-authsource: MN2PR03MB4752.namprd03.prod.outlook.com
x-ms-exchange-crosstenant-network-message-id: a50fd3fd-b1cb-4833-4174-08d890a8f375
x-ms-exchange-crosstenant-originalarrivaltime: 24 Nov 2020 18:44:18.4429 (UTC)
x-ms-exchange-crosstenant-fromentityheader: Hosted
x-ms-exchange-crosstenant-id: 29a671dc-ed7e-4a54-b1e5-8da1eb495dc3
x-ms-exchange-crosstenant-mailboxtype: HOSTED
x-ms-exchange-crosstenant-userprincipalname: YQGbjzEepAMJWhFtfLHshXwSWmbICCFYSswEWsnbgX9wxJ6AdikDfxSQgyYsJswr
x-ms-exchange-transport-crosstenantheadersstamped: MN2PR03MB4686
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

We use the bond driver in an active-backup configuration with ARP monitorin=
g. We also use the TIPC protocol which we run over the bond device. We are =
consistently seeing an issue in both the 3.16 and 4.19 kernels whereby when=
 the bond slave is switched TIPC is being notified of the change rather tha=
n it happening silently.  The problem that we see is that when the active s=
lave fails, a NETDEV_CHANGE event is being sent to the TIPC driver to notif=
y it that the link is down. This causes the TIPC driver to reset its bearer=
s and therefore break communication between the nodes that are clustered.
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
e bond driver will see no active slaves until it brings up the backup slave=
 on the next call to bond_activebackup_arp_mon.  Brining up that backup sla=
ve has to be attempted prior to notifying any peers of a change or else the=
y will see the outage.  In this case it seems the should_notify_rtnl flag h=
as to be set to false.    However, I also question if the switch to the bac=
kup slave should actually occur immediately like it does for MII and that t=
he backup should be immediately brought up/switched to without having to wa=
it for the next iteration.

As it currently is implemented there is no way to run TIPC over an active-b=
ackup ARP-monitored bond device.  I suspect there are other situations/uses=
 that would likewise have an issue with the 'erroneous' NETDEV_CHANGE being=
 issued.   Since TIPC (and others) have no idea what the dev is, it is not =
possible to ignore the event nor should it be ignored.  It therefore seems =
the event shouldn't be sent for this situation.   Please confirm the analys=
is above and provide a path forward since as currently implemented the func=
tionality is broken.

Thanks,
Howard Finer


