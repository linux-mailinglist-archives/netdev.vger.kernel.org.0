Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9A7A455DFB
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 15:28:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233103AbhKRObP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 09:31:15 -0500
Received: from mail-eopbgr60107.outbound.protection.outlook.com ([40.107.6.107]:23958
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233068AbhKRObO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 09:31:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QxdENT6iWjEeCL6C+Hl7sjc6LT0Mzi8QKECEu5/uaUjlYsqcKrpjRsAjPTmX7B0pS7PsyNUcx0YcktjOHQgE72aHDt3NFjHYlVhr50/IVpSpv4mWVB+i0ue7aMGrfs95P6Lf2c3E0x6xIXfirmX81AGk1fvRRj8rHRb+AJ2k5L0ZAVi4LoKGcxGzkx7NmS2JogsYNWJW1c+a1hC871dyKUnU5lvEe6QtYjtMGQEAz0qcJYF0cMtPYfjl8zL8r8nehQ3q7GfbqA1zKUmL9Ffc4Nb9mWu4n/9lfKIskIBHILPpCraMoANxwPfPjv3pi01lRrVpPtrM0nhqKXJzuSfPvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ukw+F8OlFKYnXRm4ZZcGSJjFRpEEF2IriZce5z3iE4A=;
 b=EzrC/D0kouf+AxNWrHqechZBD68bpZygeDGhiwRgwXx1Pc1fquzQTW+LAUFCMKZqIWBHilftkIpbBOOp484J6ElgKUuFZVnVZtMhX0UB0SCrsiq6RleiQfj9LTGt8wgQRfMp+1Ua1kCLbIx/2Vi9/nF1PED7o41nK4ICcfPhtHYta8g28srFwUXBrEOBkoX3ivPB8nPccV5uJ52ME0lNfoURY0kGOJFoB0I+thI+6tEhx4y28wm2r0STdyfZMhtPBd4rPqFZeVbHIUqJBenCZUhUQfxeci0sZXXMykC8FGcwqgVjGUxCyuVm+GCwcvwKQlPpqG9u1IbM672QXMfctA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=plvision.eu; dmarc=pass action=none header.from=plvision.eu;
 dkim=pass header.d=plvision.eu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=plvision.eu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ukw+F8OlFKYnXRm4ZZcGSJjFRpEEF2IriZce5z3iE4A=;
 b=FjPNc6uF4AC5s0ynSNdkT1+5qw3lzea6KPp5GRYHrLcjz2H/ZjEk96QvMF7pYgeLHkCPS54ZvYGhgj1GHHFYtWCU4tRBOnZgWxUxseYTU3swsc39tte+CaUautOuSMWji3YISW82uQm6uPpnzKje3MamLDWr7UVBODwPmnoycc0=
Received: from AM0P190MB0721.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:1a0::24)
 by AM0P190MB0788.EURP190.PROD.OUTLOOK.COM (2603:10a6:208:198::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.21; Thu, 18 Nov
 2021 14:28:13 +0000
Received: from AM0P190MB0721.EURP190.PROD.OUTLOOK.COM
 ([fe80::51a2:f804:af89:1c51]) by AM0P190MB0721.EURP190.PROD.OUTLOOK.COM
 ([fe80::51a2:f804:af89:1c51%9]) with mapi id 15.20.4713.021; Thu, 18 Nov 2021
 14:28:13 +0000
From:   Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mickeyr@marvell.com" <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Volodymyr Mytnyk <vmytnyk@marvell.com>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net] net: marvell: prestera: fix brige port operation
Thread-Topic: [PATCH net] net: marvell: prestera: fix brige port operation
Thread-Index: AQHX25fKzpoMjMiw7UirNXMLlQh9S6wH9PqAgAFWNFA=
Date:   Thu, 18 Nov 2021 14:28:12 +0000
Message-ID: <AM0P190MB07218D91BF57C903690DF4518F9B9@AM0P190MB0721.EURP190.PROD.OUTLOOK.COM>
References: <1637142232-19344-1-git-send-email-volodymyr.mytnyk@plvision.eu>
 <20211117171054.cupmcwwi2ruxjxuh@skbuf>
In-Reply-To: <20211117171054.cupmcwwi2ruxjxuh@skbuf>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=plvision.eu;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da381e59-e21c-4f2f-816b-08d9aa9fa72d
x-ms-traffictypediagnostic: AM0P190MB0788:
x-microsoft-antispam-prvs: <AM0P190MB0788BBBC95DB6DF89EEF0AD08F9B9@AM0P190MB0788.EURP190.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: N4G+Zh50PwJKycNxa8dvGc1Bm5NP1ttMaMhM00ji/95NU4UPUJjAxJubQEMHmJWFw1lwrwLKrAhPRIPTyXQlUZzPuN/BEW9M5sZvPd2xX+EzYj4S5Fby80o+MgFXx2KhKnQ1M2dQVlV7uINj7xubDh6dGGK+DLutoLPy3ea8miyusOkHQvrVwooehvkQ+zwGUPdG7hrJ27RduvuPydAV+B10dZTScsmD/olbTquXl1NJ2u3CE7BK5LtDaBOiEUUehyusQtGcGgNU+umWux9MuS0gHXabtwinTbXDSwMJYcBtnCgi0uu+eN4iYwPvzy1fh0W4M7Jmn3lgJAS0xoa+F4s25QckMdQ3VuotvihSRXkMGuzgpHEvmOoqezwMD1Emyp3jb3qzB7vga2FWbAPj0MWY6Z+2VhugJDPE39jvDkZY9kV3JqN/nSzuqfhJL4cuu6VpphjxNLkX7MFQ5g1PRje1AH9bOaXjT2paqiVySpItygZdbpQF2uMRPOYvQryT62q2riIt7jm7kithUM5c5vNx/1H2BlvNePvkDJRXVUYoN4sDKrg4Zwgp85euBB1IrKqluD91gRTFYXq8I8KW3btb8k/sTg8H4u6YZ13lXcnU8+pU6SjHXIaGJJNkc1YIzwALe5h6JWgQ++V0VWEqBJfDlk/Tbs1IWJGSM7aF9TuLUQC21DwA9RBerdRaZb9JItYVYHGekxjAwMKrhlczfQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0P190MB0721.EURP190.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(366004)(396003)(136003)(39830400003)(376002)(346002)(186003)(44832011)(26005)(38100700002)(66446008)(8676002)(122000001)(55016002)(9686003)(86362001)(8936002)(64756008)(45080400002)(66556008)(66476007)(6506007)(33656002)(76116006)(66946007)(508600001)(71200400001)(2906002)(316002)(52536014)(83380400001)(54906003)(5660300002)(6916009)(4326008)(7696005)(38070700005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?3HpYbxfsfeWKyOMLJ/xoeKyr/BR+OO8PS80aavMMVQUl9Kf//3OWrOxX8y7f?=
 =?us-ascii?Q?/HxPtLhlPXS6VHsYDZthz4k0gW1tD3zOPEJf2iBfFhw6dCBlqbPMt1Bjb+tH?=
 =?us-ascii?Q?qfFx8hUd0FNtkk7eNv+p5//1tkj6You3GOVPMjpDk5KmLX9JMc6eSIk70mBh?=
 =?us-ascii?Q?1OT6vYEN3cJ4U9U41p68iLd77nhUKc/fTNeDN878nNr8JOQaSe7S4mHicxeb?=
 =?us-ascii?Q?lrVyhDFElEYhUuGoKukSQsRtNlQPbziRvDOEtYeFN6Koo0Ig//s7U7QEEBQn?=
 =?us-ascii?Q?UmEqBk46y/zkWCK27f2p4/SbIJFWmIri7A2ZRxcG9QFOJ8O2MU7c2YW5bxGR?=
 =?us-ascii?Q?5/r9zrbrqREryNnlSIgLDNaz2Q3pKqm1rRPSLGI8eKQEY38zDw5pt4ArY5FV?=
 =?us-ascii?Q?Wf1T4d+aSXcM9Rjl7AfXUW8ZaYTbTQbRKoEqFDs6j8L0ZUb4J1e/03r8QOod?=
 =?us-ascii?Q?uQ6+6PZ5w9ppxOr8eLFffgZxLMA3T3ukyjz//DvGqoey8IPs3N206JQ+Ly1J?=
 =?us-ascii?Q?UN8asntOE9lv1YHKigWnKfnyxmm5/+xFRzT9Ev8y74gTe8ZXTTHNJA9YK1LC?=
 =?us-ascii?Q?7uXfyLwu+X3wSZJrtdCmvqp6xcCbarkD0RMkJ+1WU4FDtizXGvW7LXcthqMr?=
 =?us-ascii?Q?HB4QChx97GYERbFv9Uf5KWKOhOGtlHTc3cICaMqRO5slVcMxSEAi5cc/IdL+?=
 =?us-ascii?Q?pF1M/Inl/8QsVdsLOno0gWOJZrORYPCwuvvfgNvYv/doyxugrM/mPHpm0wgG?=
 =?us-ascii?Q?oZCF29Pzshz3jlKvLw/KlRC7znc46Jc3l8ZZPhW7GbFTVBXL68V6mECB7icp?=
 =?us-ascii?Q?z+DCZmwIH/U5Rdc7CZvVJD3ErAbTqiNhLTf9SkKr8GVkvuUg+9eTGpVec+KR?=
 =?us-ascii?Q?9lhXFDaOTMY3UOrcj5otbL5NlgTKSw9j+h7mZzUG0zpOX1C1NM7EVKtOnx2c?=
 =?us-ascii?Q?sjmBed25CtZU3MG11PbP9qOT4llwqNwR4iyr2AzcGqMrdKDGOpT458w95Ngu?=
 =?us-ascii?Q?Kh25cYRyVZCPp8qaxDhEF71yZ90mgfEHLawVIuNnnF58sZgmxeCWrQ7ZZ1d2?=
 =?us-ascii?Q?3qaVs7kv+im4Y3Q8Z2Y57U19LIs++089I2ncmz7ax/DkETA1HfitIcNd+4Y5?=
 =?us-ascii?Q?nyAhhWwWpGhLJpOpDFh9BMf5HqPELNsFWkzReUrtEZdXxP4sNyLYMoK2WPz1?=
 =?us-ascii?Q?An5eX100x4BrdkYGGeVzArlDSssHczSJ2rtflQyoowWH0s0/mS4VMmgumudH?=
 =?us-ascii?Q?6RsiGoTJzDRVfqGk/cleeMtp3OEvdrWEm411pFjn61Tw8j3n+eQa67Dk5Itp?=
 =?us-ascii?Q?3up0yiR3Q3/n2veyNkndNxyYlMXMO92Me/2kJpp+BYCtT/xYFHxTZlluhXPa?=
 =?us-ascii?Q?yq9UlRFmQJ5nd5/AKgddtYSWpddrNtQt0wwJ6kzMuZyH7b8AU3esHq6vqQaM?=
 =?us-ascii?Q?MLx/VSyEEu+6O69aAYXM+9u623rE+TPEWQyoQxnlA1p0nSu8KS+W8lXIyH9n?=
 =?us-ascii?Q?rE+7zoNf0+MXY9vyvx3I20qDAXPFTRvPI4XwQ9d5VSiBjkrJJwMKQN4g8cKX?=
 =?us-ascii?Q?Qkj5pOoRn8NBjqILy41rYy8znOh8mfddVaXU1aZAmubvwfcSpzT4Q5wgua0y?=
 =?us-ascii?Q?lzZAfxRQ/JC3mY3OfmOc/I7ehr/L4w4shxZpuENaFfAOKvqlJJLuStLOIy+J?=
 =?us-ascii?Q?JheSxw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: plvision.eu
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0P190MB0721.EURP190.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: da381e59-e21c-4f2f-816b-08d9aa9fa72d
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2021 14:28:12.9690
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 03707b74-30f3-46b6-a0e0-ff0a7438c9c4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jhHoN2ZDgS6Mkn/baiLNvhIr0PMD6XdV2neGllgX9iUVSq9r7Ou0HkE1koPTu1Ov6YZAmctGi/Y1ZIRNCzDmj5zsrJz2Z7oohaBj4nRWz7U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0P190MB0788
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Wed, Nov 17, 2021 at 11:43:51AM +0200, Volodymyr Mytnyk wrote:
> > From: Volodymyr Mytnyk <vmytnyk@marvell.com>
> >=20
> > - handle SWITCHDEV_BRPORT_[UN]OFFLOADED events for
> >   switchdev_bridge_port_offload to avoid fail return.
> > - fix error path handling in prestera_bridge_port_join to
> >   fix double free issue (see below).
> >=20
> > Trace:
> >   Internal error: Oops: 96000044 [#1] SMP
> >   Modules linked in: prestera_pci prestera uio_pdrv_genirq
> >   CPU: 1 PID: 881 Comm: ip Not tainted 5.15.0 #1
> >   pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=3D--)
> >   pc : prestera_bridge_destroy+0x2c/0xb0 [prestera]
> >   lr : prestera_bridge_port_join+0x2cc/0x350 [prestera]
> >   sp : ffff800011a1b0f0
> >   ...
> >   x2 : ffff000109ca6c80 x1 : dead000000000100 x0 : dead000000000122
> >    Call trace:
> >   prestera_bridge_destroy+0x2c/0xb0 [prestera]
> >   prestera_bridge_port_join+0x2cc/0x350 [prestera]
> >   prestera_netdev_port_event.constprop.0+0x3c4/0x450 [prestera]
> >   prestera_netdev_event_handler+0xf4/0x110 [prestera]
> >   raw_notifier_call_chain+0x54/0x80
> >   call_netdevice_notifiers_info+0x54/0xa0
> >   __netdev_upper_dev_link+0x19c/0x380
> >=20
> > Fixes: 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which=
=20
> > bridge ports are offloaded")
> > Signed-off-by: Volodymyr Mytnyk <vmytnyk@marvell.com>
> > ---
> >  drivers/net/ethernet/marvell/prestera/prestera_switchdev.c | 9=20
> > +++++----
> >  1 file changed, 5 insertions(+), 4 deletions(-)
> >=20
> > diff --git=20
> > a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c=20
> > b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> > index 3ce6ccd0f539..f1bc6699ec8b 100644
> > --- a/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> > +++ b/drivers/net/ethernet/marvell/prestera/prestera_switchdev.c
> > @@ -497,8 +497,8 @@ int prestera_bridge_port_join(struct net_device=20
> > *br_dev,
> > =20
> >  	br_port =3D prestera_bridge_port_add(bridge, port->dev);
> >  	if (IS_ERR(br_port)) {
> > -		err =3D PTR_ERR(br_port);
> > -		goto err_brport_create;
> > +		prestera_bridge_put(bridge);
> > +		return PTR_ERR(br_port);
> >  	}
>=20
> Here is how the function looked _before_ my patch:
>=20
> int prestera_bridge_port_join(struct net_device *br_dev,
> 			      struct prestera_port *port)
> {
> 	struct prestera_switchdev *swdev =3D port->sw->swdev;
> 	struct prestera_bridge_port *br_port;
> 	struct prestera_bridge *bridge;
> 	int err;
>=20
> 	bridge =3D prestera_bridge_by_dev(swdev, br_dev);
> 	if (!bridge) {
> 		bridge =3D prestera_bridge_create(swdev, br_dev);
> 		if (IS_ERR(bridge))
> 			return PTR_ERR(bridge);
> 	}
>=20
> 	br_port =3D prestera_bridge_port_add(bridge, port->dev);
> 	if (IS_ERR(br_port)) {
> 		err =3D PTR_ERR(br_port);
> 		goto err_brport_create;
> 	}
>=20
> 	if (bridge->vlan_enabled)
> 		return 0;
>=20
> 	err =3D prestera_bridge_1d_port_join(br_port);
> 	if (err)
> 		goto err_port_join;
>=20
> 	return 0;
>=20
> err_port_join:
> 	prestera_bridge_port_put(br_port);
> err_brport_create:
> 	prestera_bridge_put(bridge);
> 	return err;
> }
>=20
> The double free is due to the fact that prestera_bridge_port_put() calls
> prestera_bridge_put() by itself too.
>=20
> But the code was already buggy, for example the error path of
> prestera_bridge_1d_port_join() would trigger this double free as well.
> The change itself is ok (but is very poorly explained), if
> prestera_bridge_port_add() fails, you want to undo just prestera_bridge_c=
reate(), otherwise, prestera_bridge_port_put() will undo both prestera_brid=
ge_port_add() and prestera_bridge_create().
>=20
> So the honest Fixes: tag should be:
>=20
> Fixes: e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implem=
entation")

Right, the double free was before. Will change this the commit tag with e11=
89d9a5fbe. Thx.

>=20
> because you want this change to be backported even to stable kernels wher=
e commit 2f5dc00f7a3e ("net: bridge: switchdev: let drivers inform which br=
idge ports are offloaded") is not present.
>=20
> > =20
> >  	err =3D switchdev_bridge_port_offload(br_port->dev, port->dev, NULL,=
=20
> > @@ -519,8 +519,6 @@ int prestera_bridge_port_join(struct net_device *br=
_dev,
> >  	switchdev_bridge_port_unoffload(br_port->dev, NULL, NULL, NULL);
> >  err_switchdev_offload:
> >  	prestera_bridge_port_put(br_port);
> > -err_brport_create:
> > -	prestera_bridge_put(bridge);
> >  	return err;
> >  }
> > =20
> > @@ -1123,6 +1121,9 @@ static int prestera_switchdev_blk_event(struct no=
tifier_block *unused,
> >  						     prestera_netdev_check,
> >  						     prestera_port_obj_attr_set);
> >  		break;
> > +	case SWITCHDEV_BRPORT_OFFLOADED:
> > +	case SWITCHDEV_BRPORT_UNOFFLOADED:
> > +		return NOTIFY_DONE;
> >  	default:
> >  		err =3D -EOPNOTSUPP;
>=20
> May I suggest that the root cause of the problem is that you're returning=
 -EOPNOTSUPP here? The switchdev events may just as well not be destined fo=
r your prestera switch. You should return NOTIFY_DONE ("don't
> care") for event types you don't know how to handle.

Yes, I think NOTIFY_DONE can be returned by default. It makes sense to spli=
t this change into two commits with their fix tag set respectively.=20

>=20
> And technically, this part of the patch should have:
> Fixes: 957e2235e526 ("net: make switchdev_bridge_port_{,unoffload} loosel=
y coupled with the bridge")
>=20

Regards,
   Volodymyr
