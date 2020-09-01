Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3D73258ACD
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 10:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726326AbgIAIxb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 04:53:31 -0400
Received: from nat-hk.nvidia.com ([203.18.50.4]:24234 "EHLO nat-hk.nvidia.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726064AbgIAIxa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Sep 2020 04:53:30 -0400
Received: from hkpgpgate101.nvidia.com (Not Verified[10.18.92.100]) by nat-hk.nvidia.com (using TLS: TLSv1.2, DES-CBC3-SHA)
        id <B5f4e0c060000>; Tue, 01 Sep 2020 16:53:26 +0800
Received: from HKMAIL103.nvidia.com ([10.18.16.12])
  by hkpgpgate101.nvidia.com (PGP Universal service);
  Tue, 01 Sep 2020 01:53:26 -0700
X-PGP-Universal: processed;
        by hkpgpgate101.nvidia.com on Tue, 01 Sep 2020 01:53:26 -0700
Received: from HKMAIL103.nvidia.com (10.18.16.12) by HKMAIL103.nvidia.com
 (10.18.16.12) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Tue, 1 Sep
 2020 08:53:25 +0000
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 HKMAIL103.nvidia.com (10.18.16.12) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Tue, 1 Sep 2020 08:53:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPoPNWiisRzRGXJzTiQVhvDoIvmfWeZzxhnC99ySt/9gqKvlPZbEV0N79PSeVIf/zRIl5UZ+PSYXyISbg6FJVlR+90gxKwHbhdTNZ4f+8uc5Od2H9c09xC8HuQCRTZI9Fv9mWFaKu3SrM0EGXiwikWm1u8EZ2k+okTsh1l3cxSIg9H49lZSKHOYFXKIeaQj6Apn2YDyHMuSOIG/uUI1uQ7RVHg8hYKqAb3x2d2ZB6RU5wcEUExOTH5YQCpVkp/Z1AkFLK3BzYfnW14qqfcgBL1DKXgcV76E7ZtyeC3SxE0vfLRseKVKpe+WAVV6IdKYaaP9oO7CxZAdvvH8gHoyk5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DCjmayVD/LzuSmCnw6gXoeVRrU/uZsKDvf5eHkY8ed0=;
 b=TV9VDog/B09Dm++P4kAZf0Re0lrkodl47VKXD5g6NcgjridmX6YNVLMtHRf3j5lRu81fKbLVGPx0s5kJGZNmBoOFOcc/5hcXfYBnsXRNClvynl0Z/dvBgZaSs7vJbn4iivPddZpGvN3zr/xGJ3BoP/xT3cCkgDJ8j806GExfEivL4b/q3QKEK38bhxoDlquU1+2+VUAMY0PvSR1LjtgSjP9vF1tx4K2kJZrkEdd3DGtPjdGJ8riE+M96jZAo4i0Md9bbMraJ7cX0lFe+beSXDZ4knM6oSljSTJPmw4Nv55sZDE2sHAeSF2tBzJjNu3W3knpjeivk9B8VvlOY+7hhww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from BY5PR12MB4322.namprd12.prod.outlook.com (2603:10b6:a03:20a::20)
 by BY5PR12MB4243.namprd12.prod.outlook.com (2603:10b6:a03:20f::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3326.23; Tue, 1 Sep
 2020 08:53:23 +0000
Received: from BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707]) by BY5PR12MB4322.namprd12.prod.outlook.com
 ([fe80::b5f0:8a21:df98:7707%7]) with mapi id 15.20.3326.025; Tue, 1 Sep 2020
 08:53:23 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     Jiri Pirko <jiri@resnulli.us>
CC:     Jakub Kicinski <kuba@kernel.org>,
        Parav Pandit <parav@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "roid@mellanox.com" <roid@mellanox.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        Jiri Pirko <jiri@nvidia.com>
Subject: RE: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Topic: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Thread-Index: AQHWeugVEZjy8+Bcu0qKDL1vbGgf/KlJitKAgABAGdCAAQhmgIAAinbQgADtLwCAABeykIAAHVgAgABmzECAANgrgIAAsB0AgAUMOQCAAAZkMA==
Date:   Tue, 1 Sep 2020 08:53:23 +0000
Message-ID: <BY5PR12MB43229CA19D3D8215BC9BEFECDC2E0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
 <BY5PR12MB4322E2E21395BD1553B8E375DC540@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200826130747.4d886a09@kicinski-fedora-PC1C0HJN>
 <BY5PR12MB432276DBB3345AD328D787E4DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827113216.7b9a3a25@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43221CAA3D77DB7DB490B012DC550@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200827144206.3c2cad03@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB432271E4F9028831FA75B7E0DC520@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200828094343.6c4ff16a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <BY5PR12MB43220099C235E238D6AF89EADC530@BY5PR12MB4322.namprd12.prod.outlook.com>
 <20200901081906.GE3794@nanopsycho.orion>
In-Reply-To: <20200901081906.GE3794@nanopsycho.orion>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: resnulli.us; dkim=none (message not signed)
 header.d=none;resnulli.us; dmarc=none action=none header.from=nvidia.com;
x-originating-ip: [49.207.209.10]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 96323e7c-5944-4740-5685-08d84e547bb7
x-ms-traffictypediagnostic: BY5PR12MB4243:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BY5PR12MB4243068BF8CBEA1D756DCEA2DC2E0@BY5PR12MB4243.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: V615UFQbaa9X9H2bCmeGa/vUsVPkaI0/CmyMKtLBIZRV5hCjgFhAlRvUJsKkBZQxGnPa8EU+CXDvkM0KKA5KS0OUydGddXiR5Jq/j8W8i0p/f5er9YDe3Y7OSyCXCcxkH2VTtkg9Oj2dOtnd+BhUeDb1lF0kyCrpY1IlXnTW8+C2Wp/R4bP24+U2CWlKtetJTcRzV3VgY0+L7FjB5kGvHMEngMmX8Gm74gSAAUp92HpVtB+e7IBMYsx6nOzpRaaSbbVF4/RRsALi0i0XdDpfsGh3t0FIKno5SoaWcQl5uEWgsHMsWdnWCszInYSx4ajM6BZthx8BiAXl85VGRzDNJw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR12MB4322.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(366004)(376002)(396003)(346002)(39860400002)(6916009)(54906003)(83380400001)(66556008)(52536014)(9686003)(66946007)(478600001)(7696005)(33656002)(76116006)(316002)(86362001)(8676002)(66446008)(6506007)(186003)(55016002)(66476007)(8936002)(64756008)(107886003)(26005)(5660300002)(4326008)(71200400001)(2906002)(55236004);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ehVBHi7infJ/ocgPlaaNrvWbHq2vAodVsQyb9K0t8d7hC579gLCHsbgcG9ySwFDlPVZkc7OJplAvgekvmbrhjKi8M09taeQpoTm7h+BUAmaXAsYmzF162pAT4oquH2wKG3CFur7eNnmVpwj2WWzyCKZAxVjxQJ0lvqTzYgfs6Dbmv0210290WPPbsdlRpzvordP/yNj2T/VR0UIlKxspL7haALUIPZIxiwFo8QJoAX2ZqYHAqIbk+K0vu+PgyxNB/1L6t1vMTE6syLwJ/0TnlUjSJ1c2ozUzNBXJj6+k98MAYVMbpzsxuY4wixPvMLdoAGeMYifKyjH7D7Jol+3vZP7FK1/YssOJX37bTVunUUs6H0A+pC7I7wpc9e4x3o3zf/xMvXUnV+IMiwCn2qZ31Hvxyd3y5rjmlx3/+xwMu+HLAPhiXNoL/380KS/sI0yx+EvB0ZhzAdul6MrRgTpmyVbw7fp4GKUjczemDDoeY/TOCRydSx8t+vl5DICQsPFXvu3iKU5Z1ql+gu5bIs3yIQxbjs4tC7CTDEH2dMUmFB3+GUkhnEwrAMeFKMNYxCPiqrqAZLJc5ZXz7AZHEeMiocV2iNkiUFHVA+3KEYwcLwQjmijB4/B2sR6cTPwU9vBHElkqF+y6JSLUIuxzMf2qCQ==
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BY5PR12MB4322.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96323e7c-5944-4740-5685-08d84e547bb7
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Sep 2020 08:53:23.2379
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ff2w5I7JbP3enWgb1I0a633qK57KGupSqNYQpvrPUrqSbnnaumfPzdHpAJf75owlX8TPEHt0EStDMK4mAX1XlQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR12MB4243
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1598950406; bh=DCjmayVD/LzuSmCnw6gXoeVRrU/uZsKDvf5eHkY8ed0=;
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
        b=gknW0Gl3onfaSdvm8sXaaB9CZVLYG/fqezJwwWpzoD1HEeUrdykIwD5c9E6FXVx0X
         TSUSE15adVz+fY8qN8uC8X1Uq6OQK9Mubf+swRIgkzgrzM3ABcuK9Z8TAWuUI6/wDZ
         MmTM+anEQrIMNVos3tpqLi09TfAs2PYP8QEYXpNfpburUVi4M11mKMy93E6CyVQUdg
         wM0DWMUvjosKBLNPyPnuFVRqAeERButl6UGwM1fADkkm3RhiSR9UuyFFvwE2Dtue82
         mAYmJBN/a+goSHM6qvW4+6droGlNiRwU/WnAWgXYCboaHMlEkO+QhFEAxdnATYtgiQ
         3GnJi8s2Liqsw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: Jiri Pirko <jiri@resnulli.us>
> Sent: Tuesday, September 1, 2020 1:49 PM
>=20
> >> > How? How do we tell that pfnum A means external system.
> >> > Want to avoid such 'implicit' notion.
> >>
> >> How do you tell that controller A means external system?
>=20
> Perhaps the attr name could be explicitly containing "external" word?
> Like:
> "ext_controller" or "extnum" (similar to "pfnum" and "vfnum") something
> like that.

How about ecnum "external controller number"?
Tiny change in the phys_port_name below example.

>=20
>=20
> >Which is why I started with annotating only external controllers, mainly=
 to
> avoid renaming and breaking current scheme for non_smartnic cases which
> possibly is the most user base.
> >
> >But probably external pcipf/vf/sf port flavours are more intuitive combi=
ned
> with controller number.
> >More below.
> >
> >>
> >> > > > > I can see how having multiple controllers may make things
> >> > > > > clearer, but adding another layer of IDs while the one under
> >> > > > > it is unused
> >> > > > > (pfnum=3D0) feels very unnecessary.
> >> > > > pfnum=3D0 is used today. not sure I understand your comment abou=
t
> >> > > > being unused. Can you please explain?
> >> > >
> >> > > You examples only ever have pfnum 0:
> >> > >
> >> > Because both controllers have pfnum 0.
> >> >
> >> > > From patch 2:
> >> > >
> >> > > $ devlink port show pci/0000:00:08.0/2
> >> > > pci/0000:00:08.0/2: type eth netdev eth7 controller 0 flavour
> >> > > pcivf pfnum 0 vfnum 1 splittable false
> >> > >   function:
> >> > >     hw_addr 00:00:00:00:00:00
> >> > >
> >> > > $ devlink port show -jp pci/0000:00:08.0/2 {
> >> > >     "port": {
> >> > >         "pci/0000:00:08.0/1": {
> >> > >             "type": "eth",
> >> > >             "netdev": "eth7",
> >> > >             "controller": 0,
> >> > >             "flavour": "pcivf",
> >> > >             "pfnum": 0,
> >> > >             "vfnum": 1,
> >> > >             "splittable": false,
> >> > >             "function": {
> >> > >                 "hw_addr": "00:00:00:00:00:00"
> >> > >             }
> >> > >         }
> >> > >     }
> >> > > }
> >> > >
> >> > > From earlier email:
> >> > >
> >> > > pci/0000:00:08.0/1: type eth netdev eth6 flavour pcipf pfnum 0
> >> > > pci/0000:00:08.0/2: type eth netdev eth7 flavour pcipf pfnum 0
> >> > >
> >> > > If you never use pfnum, you can just put the controller ID there,
> >> > > like
> >> Netronome.
> >> > >
> >> > It likely not going to work for us. Because pfnum is not some
> >> > randomly
> >> generated number.
> >> > It is linked to the underlying PCI pf number. {pf0, pf1...}
> >> > Orchestration sw uses this to identify representor of a PF-VF pair.
> >>
> >> For orchestration software which is unaware of controllers ports will
> >> still alias on pf/vf nums.
> >>
> >Yes.
> >Orchestration which will be aware of controller, will use it.
> >
> >> Besides you have one devlink instance per port currently so I'm
> >> guessing there is no pf1 ever, in your case...
> >>
> >Currently there are multiple devlink instance. One for pf0, other for pf=
1.
> >Ports of both instances have the same switch id.
> >
> >> > Replacing pfnum with controller number breaks this; and it still
> >> > doesn't tell user
> >> that it's the pf on other_host.
> >>
> >> Neither does the opaque controller id.
> >Which is why I tossed the epcipf (external pci pf) port flavour that fit=
s in
> current model.
> >But doesn't allow multiple external hosts under same eswitch for those
> devices which has same pci pf, vf numbers among those hosts. (and it is t=
he
> case for mlnx).
> >
> >> Maybe now you understand better why I wanted peer objects :/
> >>
> >I wasn't against peer object. But showing netdev of peer object assumed
> no_smartnic, it also assume other_side is also similar Linux kernel.
> >Anyways, I make humble request get over the past to move forward. :-)
> >
> >> > So it is used, and would like to continue to use even if there are
> >> > multiple PFs
> >> port (that has same pfnum) under the same eswitch.
> >> >
> >> > In an alternative,
> >> > Currently we have pcipf, pcivf (and pcisf) flavours. May be if we
> >> > introduce new
> >> flavour say 'epcipf' to indicate external pci PF/VF/SF ports?
> >> > There can be better name than epcipf. I just put epcipf to different=
iate
> it.
> >> > However these ports have same attributes as pcipf, pcivf, pcisf flav=
ours.
> >>
> >> I don't think the controllers are a terrible idea. Seems like a
> >> fairly reasonable extension.
> >Ok.
> >> But MLX don't seem to need them. And you have a history of trying to
> >> make the Linux APIs look like your FW API.
> >>
> >Because there are two devlink instances for each PF?
> >I think for now an epcipf, epcivf flavour would just suffice due to lack=
 of
> multiple devlink instances.
> >But in long run it is better to have the controller covering few topolog=
ies.
> >Otherwise we will break the rep naming later when multiple controllers a=
re
> managed by single eswitch (without notion of controller).
> >
> >Sometime my text is confusing. :-) so adding example of the thoughts
> below.
> >Example: Eswitch side devlink port show for multi-host setup considering
> the smartnic.
> >
> >$ devlink port show
> >pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
> >pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
> >pci/0000:00:08.0/2: type eth netdev enp0s8f0_c0pf0 flavour epcipf pfnum =
0
> >                                                                        =
                                     ^^^^^ new port
> flavour.
> >pci/0000:00:08.1/0: type eth netdev enp0s8f1 flavour physical
> >pci/0000:00:08.1/1: type eth netdev enp0s8f1_pf1 flavour pcipf pfnum 1
> >pci/0000:00:08.1/2: type eth netdev enp0s8f1_c0pf1 flavour epcipf pfnum
> >1
> >
> >Here one controller has two pci pfs (0,1}. Eswitch shows that they are
> external pci ports.
> >Whenever (not sure when), mlnx converts to single devlink instance, this
> will continue to work.
> >It will also work when multiple controller(s) (of external host) ports h=
ave
> same switch_id (for orchestration).
> >And this doesn't break any backward compatibility for non multihost, non
> smatnic users.
> >
> >> Jiri, would you mind chiming in? What's your take?
> >
> >Will wait for his inputs..
>=20
> I don't see the need for new flavour. The port is still pf same as the lo=
cal pf, it
> only resides on a different host. We just need to make sure to resolve th=
e
> conflict between PFX and PFX on 2 different hosts (local/ext or ext/ext)
>=20
Yes. I agree. I do not have strong opinion on new flavour as long as we mak=
e clear that this is for the external controller.

> So I think that for local PFs, no change is needed.
Yep.

> The external PFs need to have an extra attribute with "external
> enumeration" what would be used for the representor netdev name as well.
>=20
> pci/0000:00:08.0/0: type eth netdev enp0s8f0 flavour physical
> pci/0000:00:08.0/1: type eth netdev enp0s8f0_pf0 flavour pcipf pfnum 0
> pci/0000:00:08.0/2: type eth netdev enp0s8f0_e0pf0 flavour pcipf extnum 0
> pfnum 0

How about a prefix of "ec" instead of "e", like?
pci/0000:00:08.0/2: type eth netdev enp0s8f0_ec0pf0 flavour pcipf ecnum 0 p=
fnum 0
                                                                           =
          ^^^^
> pci/0000:00:08.0/3: type eth netdev enp0s8f0_e1pf0 flavour pcipf extnum 1
> pfnum 0

