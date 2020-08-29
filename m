Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8A925648E
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 05:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgH2DoS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 23:44:18 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:64061 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgH2DoM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 23:44:12 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.77]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f49cf050001>; Sat, 29 Aug 2020 11:44:06 +0800
Received: from HKMAIL102.nvidia.com ([10.18.16.11])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Fri, 28 Aug 2020 20:44:06 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Fri, 28 Aug 2020 20:44:06 -0700
Received: from HKMAIL102.nvidia.com (10.18.16.11) by HKMAIL102.nvidia.com
 (10.18.16.11) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Sat, 29 Aug
 2020 03:44:02 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.174)
 by HKMAIL102.nvidia.com (10.18.16.11) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Sat, 29 Aug 2020 03:44:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mfvu8DX2gdFu0QyySfbx5yFc/hyK6gdhUevshJ/tD6UP+ZsU433fjA58JJFkJuaz6a4qFcElW8xK6eBB8xlwRAN3Jlr7Qs6+9J46FjMG/jCrbdLtiK9p5S5rOZoATa323JSjTSCsmtioXtobZqE8+m/5fyyXX+h1UOqE49S4zWWB3mDN0EmeLfzFu+0SQpCwhQE3ntSSseiQDU2z9QPBrXlqoZRNiy6nWWx/OiSD7nd5qSmL3+Jwx0WEty+3QnVjHK8s8yJS+pViA9bWh4k+29WxyPcXCrpuPWpTkza7DNGw6Hp5v4gFj5Zo7oPTEEZqn3LDZXNPZPkd6vPsI8doSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=leyokYJcO/BIM9U1WCo9uO69meP8MJ2LUZJBASuu7vA=;
 b=oCml2dbyvgROS6bf/leXhhmW3Jx9Hj9XhXhyxGjBmVYtZIt71mQxnz8fpuAIkGsoG2PMPqFTK8XVvE2KP8M6bjV972W2F4TNBjqbX1ypzgYm8HL+8z7Re1J3ISMNOtNYxLJGqVK2zGpV9W6kWf0kD0sKDXPMnmoNa9mOH56aLm/WJ8bCtPSF5HV6YOUW5U5xL+tVXUlgVL+ZlXwWguL6WvEVcsDCDbJq0I1BlZzWSNbzfsOG5v2vExKUiJe7a8WuliK2746s4NpfP1bZrcCEFtiJIj7KpRNCxvpIhk951IBi/219c1IHf4z26kHFxIXAkx3rW0NjmmivKFB7VTXrUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BYAPR12MB3174.namprd12.prod.outlook.com (2603:10b6:a03:133::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Sat, 29 Aug
 2020 03:43:59 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3326.023; Sat, 29 Aug 2020
 03:43:59 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAANgrgIAAsB0A
Date:   Sat, 29 Aug 2020 03:43:58 +0000
Message-ID: <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
        <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
        <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 4d6a8b10-cf74-4b47-a349-08d84bcdc367
x-ms-traffictypediagnostic: BYAPR12MB3174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BYAPR12MB31748E6282FF1D49AF1B600EDC530@BYAPR12MB3174.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: sL5Y2sEhKrsgx9SVTfw8Opzr6lPvewtowto5oMkMZ8vZUS1+2xy/mpA9jGyHdmZJzi1+sfvxvigkZVwdQMF91d5Yt7rg7BiEdHwuxgpLJ7BgrVeqrXqtmYTufvP9SIEmcNMhjxuSTcvwkbXpN4KeWpCWW5M7CEwBUwiGM28NnyZmHfVg9CBMkcuWTQo0O+u1ZLUKI4G6atV5YeNjtaQfa7+n/IFY1Eo+kfaoA5+H/lnPwmkVYUhhwlPARCPawXAgbi3GryD6FuWMRQodVTCQq1bChwQeXO7ks3OQQmKGFEgLpahKTagDKhn8CrqwMKeo2V5Gz8ntNNyB1juwvk65BA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(39860400002)(366004)(136003)(76116006)(5660300002)(83380400001)(52536014)(7696005)(55236004)(71200400001)(66446008)(9686003)(66476007)(64756008)(86362001)(66946007)(54906003)(66556008)(2906002)(55016002)(26005)(8936002)(6506007)(4326008)(107886003)(186003)(478600001)(316002)(6916009)(33656002)(8676002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: tWU8AbFeqEICKoJUlYw/Dcm6SPIgbxX2z9AgUuLaDmtFBHA2mUaLkNnk18kd+euX5CQYjrp9sHXnVjNifh6cf3MeSthPunpq+EpQAr6i2Rxc+P3cKora6SX3/SqVNzs5ZtmgM1H89EiHNBtS4oEStTX++TG54RVgl6HonD8QRPf4+FdoYSAl7mqRccZ1vYgkc4EYm/GrHEvY4jYPgQV1ZmyAZmRTvlBkYpmYXHNwL/HDnQGfpUb1FtfW/kgr33JnHjBtwARLz1gRxoEEiniAs/STeWido1l+u2bkHPC3IvaTq3e3/5igr0hsXk12IDyMSLNbYWmDd5fWyHSVuHXk8d4Yn4DLxMvjAbHG7TLXyqMrPncTdGrEd7Iyy1UV01zzbga3+0ETcJttmL7QU+Ee+x0CKIzK679lKnjtHyqqPGZmfmMXaNOkirEkpgwF92wigtLWK3EBGxfKPYoCSipKYNaqeR95AqKCtsgUO7O1SBmtLg4+ltQWhRbsi2uFG5nJLjIPVVtPyiBSD6/RXJaW2hvtUlK+bgHNL32BXwC5bI2eZTYw7eiasVIB3EtYQ4fVsCxvrm+Z3+LQoEIllNbqC6+GrGKGp2o7uw0BwU/3D8WhZSG+aOd3jaxU6364wxg6iNklrtz4bTw/htRH/bt6TA==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d6a8b10-cf74-4b47-a349-08d84bcdc367
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Aug 2020 03:43:58.9686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: kG6hA4tNOsBvT2t2ucgJeNWR5zAJ42bu+LeIUnfYdI0Z4TPVc8QiPND+5k0BnT3WpTwHiq/qKh7A2+M7HZmZKQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3174
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598672646; bh=leyokYJcO/BIM9U1WCo9uO69meP8MJ2LUZJBASuu7vA=;
        h=X-PGP-Universal:ARC-Seal:ARC-Message-Signature:
         ARC-Authentication-Results:From:To:CC:Subject:Thread-Topic:
         Thread-Index:Date:Message-ID:References:In-Reply-To:
         Accept-Language:Content-Language:X-MS-Has-Attach:
         X-MS-TNEF-Correlator:authentication-results:x-originating-ip:
         x-ms-publictraffictype:x-ms-office365-filtering-correlation-id:
         x-ms-traffictypediagnostic:x-ms-exchange-transport-forked:
         x-microsoft-antispam-prvs:x-ms-oob-tlc-oobclassifiers:
         x-ms-exchange-senderadcheck:x-microsoft-antispam:
         x-microsoft-antispam-message-info:x-forefront-antispam-report:
         x-ms-exchange-antispam-messagedata:Content-Type:
         Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=rDlhlstkTFJxcaivF7VMPAQdI0EGEejmiKZ0i7vbaqx8KaIP5DEEF1obWjJuvPDvZ
         iq+ZjSKtx7E5RkN/U4wmJz0WMFRudgnqJZn1cTF32n6Unmkq6WaiC0NXRWO5SYkjtB
         IeZ+dIpHvELFAnjdszg7ySXd/pJw9EDKtDSKZYpXL4uKbSHdT9yEtLrcBujL5Y76ub
         uU8S+Exogl7SfU0549gwHHo4bs0SiCoIICb06AKD8MOTqjX5w54qHfFyMGBzJQONQK
         YKZ3xCFVQbfJvzsNEVqxM+z2PFfl51nM4rfjZVqbGq5w1UYGkAAtr3UOyhJLs0suEM
         FqJPiKtuhBprQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Friday, August 28, 2020 10:14 PM
>=20
> On Fri, 28 Aug 2020 04:27:19 +0000 Parav Pandit wrote:
> > > From: Jakub Kicinski <kuba@kernel.org>
> > > Sent: Friday, August 28, 2020 3:12 AM
> > >
> > > On Thu, 27 Aug 2020 20:15:01 +0000 Parav Pandit wrote:
> > > > > From: Jakub Kicinski <kuba@kernel.org>
> > > > >
> > > > > I find it strange that you have pfnum 0 everywhere but then
> > > > > different controllers.
> > > > There are multiple PFs, connected to different PCI RC. So device
> > > > has same pfnum for both the PFs.
> > > >
> > > > > For MultiHost at Netronome we've used pfnum to distinguish
> > > > > between the hosts. ASIC must have some unique identifiers for eac=
h PF.
> > > > Yes. there is. It is identified by a unique controller number;
> > > > internally it is called host_number. But internal host_number is
> > > > misleading term as multiple cables of same physical card can be
> > > > plugged into single host. So identifying based on a unique
> > > > (controller) number and matching that up on external cable is desir=
ed.
> > > >
> > > > > I'm not aware of any practical reason for creating PFs on one RC
> > > > > without reinitializing all the others.
> > > > I may be misunderstanding, but how is initialization is related
> > > > multiple PFs?
> > >
> > > If the number of PFs is static it should be possible to understand
> > > which one is on which system.
> >
> > How? How do we tell that pfnum A means external system.
> > Want to avoid such 'implicit' notion.
>=20
> How do you tell that controller A means external system?
Which is why I started with annotating only external controllers, mainly to=
 avoid renaming and breaking current scheme for non_smartnic cases which po=
ssibly is the most user base.

But probably external pcipf/vf/sf port flavours are more intuitive combined=
 with controller number.
More below.

>=20
> > > > > I can see how having multiple controllers may make things
> > > > > clearer, but adding another layer of IDs while the one under it
> > > > > is unused
> > > > > (pfnum=3D0) feels very unnecessary.
> > > > pfnum=3D0 is used today. not sure I understand your comment about
> > > > being unused. Can you please explain?
> > >
> > > You examples only ever have pfnum 0:
> > >
> > Because both controllers have pfnum 0.
> >
> > > From patch 2:
> > >
> > > $ devlink port show pci/0000:00:08.0/2
> > > pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour pcivf
> > > pfnum 0 vfnum 1 splittable false
> > >   function:
> > >     hw_addr 00:00:00:00:00:00
> > >
> > > $ devlink port show -jp pci/0000:00:08.0/2 {
> > >     "port": {
> > >         "pci/0000:00:08.0/1": {
> > >             "type": "eth",
> > >             "netdev": "eth7",
> > >             "controller": 0,
> > >             "flavour": "pcivf",
> > >             "pfnum": 0,
> > >             "vfnum": 1,
> > >             "splittable": false,
> > >             "function": {
> > >                 "hw_addr": "00:00:00:00:00:00"
> > >             }
> > >         }
> > >     }
> > > }
> > >
> > > From earlier email:
> > >
> > > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> > > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
> > >
> > > If you never use pfnum, you can just put the controller ID there, lik=
e
> Netronome.
> > >
> > It likely not going to work for us. Because pfnum is not some randomly
> generated number.
> > It is linked to the underlying PCI pf number. {pf0, pf1...}
> > Orchestration sw uses this to identify representor of a PF-VF pair.
>=20
> For orchestration software which is unaware of controllers ports will sti=
ll alias
> on pf/vf nums.
>
Yes.
Orchestration which will be aware of controller, will use it.
=20
> Besides you have one devlink instance per port currently so I'm guessing =
there is
> no pf1 ever, in your case...
>
Currently there are multiple devlink instance. One for pf0, other for pf1.
Ports of both instances have the same switch id.
=20
> > Replacing pfnum with controller number breaks this; and it still doesn'=
t tell user
> that it's the pf on other_host.
>=20
> Neither does the opaque controller id.=20
Which is why I tossed the epcipf (external pci pf) port flavour that fits i=
n current model.
But doesn't allow multiple external hosts under same eswitch for those devi=
ces which has same pci pf, vf numbers among those hosts. (and it is the cas=
e for mlnx).

> Maybe now you understand better why I wanted peer objects :/
>
I wasn't against peer object. But showing netdev of peer object assumed no_=
smartnic, it also assume other_side is also similar Linux kernel.
Anyways, I make humble request get over the past to move forward. :-)

> > So it is used, and would like to continue to use even if there are mult=
iple PFs
> port (that has same pfnum) under the same eswitch.
> >
> > In an alternative,
> > Currently we have pcipf, pcivf (and pcisf) flavours. May be if we intro=
duce new
> flavour say 'epcipf' to indicate external pci PF/VF/SF ports?
> > There can be better name than epcipf. I just put epcipf to differentiat=
e it.
> > However these ports have same attributes as pcipf, pcivf, pcisf flavour=
s.
>=20
> I don't think the controllers are a terrible idea. Seems like a fairly re=
asonable
> extension.
Ok.=20
> But MLX don't seem to need them. And you have a history of trying to
> make the Linux APIs look like your FW API.
>=20
Because there are two devlink instances for each PF?
I think for now an epcipf, epcivf flavour would just suffice due to lack of=
 multiple devlink instances.
But in long run it is better to have the controller covering few topologies=
.
Otherwise we will break the rep naming later when multiple controllers are =
managed by single eswitch (without notion of controller).

Sometime my text is confusing. :-) so adding example of the thoughts below.
Example: Eswitch side devlink port show for multi-host setup considering th=
e smartnic.

$ devlink port show
pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
pci/0000:00:08.0/2: type eth netdev enp0s8f0_c0pf0 flavour epcipf pfnum 0
                                                                           =
                                  ^^^^^ new port flavour.
pci/0000:00:08.1/0: type eth netdev enp0s8f1 flavour physical
pci/0000:00:08.1/1: type eth netdev enp0s8f1_pf1 flavour pcipf pfnum 1
pci/0000:00:08.1/2: type eth netdev enp0s8f1_c0pf1 flavour epcipf pfnum 1

Here one controller has two pci pfs (0,1}. Eswitch shows that they are exte=
rnal pci ports.
Whenever (not sure when), mlnx converts to single devlink instance, this wi=
ll continue to work.
It will also work when multiple controller(s) (of external host) ports have=
 same switch_id (for orchestration).
And this doesn't break any backward compatibility for non multihost, non sm=
atnic users.

> Jiri, would you mind chiming in? What's your take?

Will wait for his inputs..
