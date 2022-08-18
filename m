Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036E259892D
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 18:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344913AbiHRQoJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 12:44:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344908AbiHRQoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 12:44:04 -0400
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2041.outbound.protection.outlook.com [40.107.236.41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B362E82FBA;
        Thu, 18 Aug 2022 09:44:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oSKYrTlqw0hiAqg3FjFLVka5wrkH46qEBAwUHxm1EgRw8Rd13w/J9Fyys0/7clpuDZCrritW0rlDP+YRVmJo+dDrlvs1zkWLHZPD5w29dpzLoQVKnZtgZ/zmMiZUoEVM4mNx9WjqfxzIN90GD/fQYQh8sP9ubbQlbYlq7zxL19VnZqkfMo5FLpaNWCdEnkKGcY+h9gWK5Y2OGSWbZW3Brn4d/f9XR4TtMqB2mpsD0bGtohFoCWaASuhqYS4M1M1jfgA1lS3c2VINC39aOCxMebjSV0/w+zvG1hBzg4QBDsI37uKF8HMHfBNLrgdsWXXe9ZCP2VG9w1fiTvzzbDr9MA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FLoPba+hmi2COSchEWTHIb4EuzpA/AFnG2OUEAIeIYY=;
 b=YxpBhiAzkA4P9l5VLU4Zk+xcOgPvta6A/vwT5PEmko3B0w3vHEUXkbNd5I4bJnq4NGsXSg6SHz1l83GZFKrKVgcjVrSJxdQlFwmneC6/KggsdwHjyRpKAJCKcdjtkmkcaRjVn3sac4Tf7h0DS4XRDWZyn8WKbPxJiYEER3ssJOkgJnWVi7MsOL0zkJHjfmAHklfHADF+mm/6sfPix7/5+fDVUufXvymGswp+lQijK23aSpvJl2+m0AOxARelT+/IgI61tuIaOdMgCR0knfz0UvlqUF/iDuyxcI2ffocGW0/Qd0KhrQK+Dy3PLfAORQqRKjS9FoEj5KtYljURGYEogw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FLoPba+hmi2COSchEWTHIb4EuzpA/AFnG2OUEAIeIYY=;
 b=lDHZW51TDtuR6AX/xnCR8FkNFo2A+kZ7+X/NC4WFAL1I/18FIhPu2RiZ05d2OaZCjxJx/T/a591O0kNgnSAEagqOQSO4KSr0W+eOLYBbK1k3UXTQIxkRuis2Q9ctWTHB/tdkY9cztTw4cg9b49+aapKqlKFb+ZcAQAsmFRy27EehKIWXsYhK0x5laEeMTWb7aquKLGjOuzkXt6vUg98MAvIN0DzMy86pQfzjTnaj6DYjDDBI95dqsI0cp9uRPqVwBqF2wOETwGUV80+X7IZK6hL3b5P4rjsn7XtDosGqVAMd1dpqYXyDtYTOOsc1lIPPu1Lj4AXKE52f8TEjTrSnEw==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by CH2PR12MB4293.namprd12.prod.outlook.com (2603:10b6:610:7e::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5525.19; Thu, 18 Aug
 2022 16:44:00 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::957c:a0c7:9353:411e%5]) with mapi id 15.20.5525.019; Thu, 18 Aug 2022
 16:44:00 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "ecree@xilinx.com" <ecree@xilinx.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-net-drivers@amd.com" <linux-net-drivers@amd.com>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "edumazet@google.com" <edumazet@google.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "jacob.e.keller@intel.com" <jacob.e.keller@intel.com>,
        "jesse.brandeburg@intel.com" <jesse.brandeburg@intel.com>,
        "michael.chan@broadcom.com" <michael.chan@broadcom.com>,
        "andy@greyhouse.net" <andy@greyhouse.net>,
        "saeed@kernel.org" <saeed@kernel.org>,
        "jiri@resnulli.us" <jiri@resnulli.us>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "simon.horman@corigine.com" <simon.horman@corigine.com>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "rdunlap@infradead.org" <rdunlap@infradead.org>,
        Edward Cree <ecree.xilinx@gmail.com>,
        Parav Pandit <parav@nvidia.com>
Subject: RE: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
Thread-Topic: [RFC PATCH v2 net-next] docs: net: add an explanation of VF (and
 other) Representors
Thread-Index: AQHYsLKxC8Bzg8j1w0iCXIgeBDjl+620zG5A
Date:   Thu, 18 Aug 2022 16:44:00 +0000
Message-ID: <PH0PR12MB5481AD558AD7A17928D78081DC6D9@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <20220815142251.8909-1-ecree@xilinx.com>
In-Reply-To: <20220815142251.8909-1-ecree@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: c1a3f923-bd07-4f2e-b6d4-08da8138da27
x-ms-traffictypediagnostic: CH2PR12MB4293:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IeK/pi7hxFrvJdFa+Y4F6eyPNqlMZVFT0XmXI7t8vc3LX9xf94XspHAGl4kNMV2pbDv3h7xWqDH7j4EmSVJr/uSJ/ciW0kcSEARHhAen3gpI9LWHT5HsrTVZT8AFXX9Bl6S292aXBACy1NQW9XIsF7+OXvKVUopyrZfjsoncJ1n70VHVeBjnDgKKDkES32VUOSNkyZUNXRhAUzsF2S6f61tDbgR0GcYwjnzAyAN3e01HUlJAcW3D+epVE2c8jMGedVeRHP9D9aLfnuGgS/5PofssxDU1OC6YJMn3A5Mogxy6P0Gvh2cIUMegL0/8UOgUTg3PxfQYl5T0JXvSM9IwWxwZ6uJoZ8hRuIb0/1P1HdJPPoPLPYX9IR1bYfHQiti0psvnubRrSiHJupmfLVNczDb+Q9CE1NukJ0x64LIXmrzRLhY9xphoOzgWUVF3Sv4V69IVBJjDoxOZek1YaJmVlAaZZHe0lxeaBbii6+DtZWnZyIifbVFRgfkCgc1sBaqxagmJIxZAlV0U6NogDspsKJ3G2HmNBdf/CDc67Psxv+4cJ4txKmZDCKo9Z+j6JWlMeWu3O9ank413V2v+fusHOjvWcKt9DIDDH7MEz2h9KnJaQ9bEERJfpGY7Se5abestFcBcq5hmjrgiSxZcr2Ju0ROX7SozA/NB6hLtDZNqrg6CS/NXCBUW9x/1VgyXmlrmF/upLAgMooJT/QNNkOCm0YUo2o0gcwlbqAQc3ZR2q3Ter8IHCDrVhqNHKVAa+xW+0r6hcZdH/IAlipCf5PTvPGb6Fa5etS+0WCg1db+QlbWXBzLPLIkB1jOOGHPMNOQJdagrJY71a7Lpbb/jpYTplOr/+bVa2LpDlREmHTbfgk8=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(366004)(346002)(39860400002)(136003)(396003)(376002)(2906002)(41300700001)(478600001)(76116006)(7416002)(66946007)(66476007)(4326008)(55016003)(64756008)(66556008)(110136005)(966005)(8676002)(86362001)(71200400001)(66446008)(33656002)(316002)(26005)(107886003)(9686003)(6506007)(54906003)(7696005)(38100700002)(83380400001)(38070700005)(52536014)(5660300002)(122000001)(8936002)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?4cOvFmlMpd3dgpauElwzy038TLpuIMb4pjKvg26VMtu9DeJGX6MjnLpvCa/P?=
 =?us-ascii?Q?Qb4ZR8jd8Fd9xDBhgBx2OafzbvpEXOF4aLiDcuNwkNIMqXT8PvuzYNtj5zkQ?=
 =?us-ascii?Q?65q8XLfPQ5HTJRrUgtJgciscvbiSGDVtMkKn8HM2atGlb1BcyjPqmvlGPIyB?=
 =?us-ascii?Q?zVVPi1yISglnHEjlCeJCkOtli+8ueTK2DRdBKCsau9zLYwzN+aJkh6mjkXuu?=
 =?us-ascii?Q?jmjm4GofVl+3nw0v2Ir0RlU9MQp7c5VbxEtWXe9x3WqGWB9MFIhNIG3wzyjB?=
 =?us-ascii?Q?YGhUgBhpAf/6gOAdz9IizSCxmwYQJDFHyhJR6J4rfuI67i2pEcJ84oJzdCQ+?=
 =?us-ascii?Q?djnE1nZBb730RZTTN2FgPZPwAP93H4nN1M2jvhLBpycNweuhwjaBei3v5uoc?=
 =?us-ascii?Q?ePRKkUf6REG46pevkq76LJWu31lgvDoGjk96rqos59gO+5/PE1zX6tMQ36BH?=
 =?us-ascii?Q?gpQy0s3Lvf5QNymcV/Cp5NWSRpiMmagF0Lc4263u3SkoL6HNyimhv+/ObhM5?=
 =?us-ascii?Q?8A4LiMkLCs8Qx8O1nt00+dQrL4fFfnQl2XnavbtVfb5LO1yM/CUi3dzGHgUT?=
 =?us-ascii?Q?2lCGe2qUhcDPbeBBsPiKycjxZQFkluFU3XMYpPvyHkF4C4F1Fhc+VLa35mkb?=
 =?us-ascii?Q?8ZKiauSdvt7Oks2+uDKkrOYowyzegoln2xngxDlgJ2fcImMbGuMV1ILw9B7Z?=
 =?us-ascii?Q?7tEofNHfKJyjZ7kxAKqCGCFBm6/JaYiDCBXAFMsogyBKRx+chVvbzLzrynhB?=
 =?us-ascii?Q?q6A8RfNfnlTr21uG2+c2LaXesvXaRf6OroMP3nnmfvGY3mppCbM/PG95Chw6?=
 =?us-ascii?Q?pW+vonwjk7j2YnspihNqJrWdhZWh4uOG0010qx0YyqY2WHDdGYrm4ARVtfR7?=
 =?us-ascii?Q?mOHQzTqEEmYscDBe3jTSsatpOOogEFDhNbzDL+NCGBYXtU1Oik3QwgQEei7N?=
 =?us-ascii?Q?b8MX2xq2kMiXDi8f7aS1NWJwx7rFrX3eeXTHNheDf8rgylKJJIOqDWyqXsaf?=
 =?us-ascii?Q?9qyIMhxxQ6QnLg9iE9Yz+BuCjbztOSDMm6w0B65Taki3pTrkbLi00NBFWTiU?=
 =?us-ascii?Q?bLq3TnVqz5B9T3cNbXvIJyHJbUPSC6UWXkuOOOgS1fYST15Ou4GcDQNhpnou?=
 =?us-ascii?Q?boNdPdMMXxywhWBoxU+d3ZHJ1s0CR+3eXWp6QAKPo5/rYUCmuHjA8pVgmKab?=
 =?us-ascii?Q?TfSM/pD6yTi350QiYUBAphyRzRsjC90CRoe9LbzcYFhA4gkQf+DbmKgbJnEz?=
 =?us-ascii?Q?ThIqvGPqmYQuGqcdyTfXWBWDiNPPqgKzIyHgm19GTzo0Mmw/uIvUoeNyZDkf?=
 =?us-ascii?Q?TapK90+5AKIf39b4fzDxoM7YmD2lpdbFONwIlmd9l1SlX3hzU0bTp9CqjsZv?=
 =?us-ascii?Q?NdFzfMP3fswvSTbtoRit6kizVTRBD7oMTg0VjX+6PVmxFbF/XdSyiqJHVOtz?=
 =?us-ascii?Q?x7weWeGLY/0A78XuK/hBqc9O+9D4+GSx4QwcOwz3P/rTtGY9DtrlyqiM2Oir?=
 =?us-ascii?Q?eu6gi1wGkcUG8+XDDLi4hQfi0/ZBdmEsS+JJcshMcC2hByENWxvcSB1uW9h8?=
 =?us-ascii?Q?B9WmyOxiDZE7q3+QxxM=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c1a3f923-bd07-4f2e-b6d4-08da8138da27
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Aug 2022 16:44:00.3909
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VmiDICyn1oKlWsTKMQpha/8CD35F+GVngrv3oymsYZ//dW+0CG0A2Y54Qld56ZfSOmvKkQQGVNtwd5TIVe1UAw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4293
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: ecree@xilinx.com <ecree@xilinx.com>
> Sent: Monday, August 15, 2022 10:23 AM
>=20
> +
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +Network Function Representors
Given current documentation of the patch:

s/Network Function Representors/Network Function Port Representors.

> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
Most of the text below describes "netdev" device of the switchdev device.

A switchdev device' netdevice only represents the port of the representee.

Hence the document title is not truly justified what it wants to say.

A _whole_ network function is represented today using=20
a. netdevice represents representee's network port

b. devlink port function for function management

This good documentation is probably best placed in switchdev.rst may be wit=
h a NIC specific section.
This will connect the two dots nicely.

[..]
> +Motivation
> +----------
> +Network function representors bring the standard Linux networking stack
Network functions port representors; here and at other places ...

> +to virtual switches and IOV devices.  Just as each port of a
> +Linux-controlled switch has a separate netdev, so each virtual function
> +has one.  When the system boots, and before any offload is configured,
> +all packets from the virtual functions appear in the networking stack of=
 the
> PF via the representors.
> +The PF can thus always communicate freely with the virtual functions.
> +The PF can configure standard Linux forwarding between representors,
> +the uplink or any other netdev (routing, bridging, TC classifiers).
> +
> +Thus, a representor is both a control plane object (representing the
> +function in administrative commands)=20
Certain part of the function administrative commands that doesn't directly =
fit to netdev.
They are through devlink port + function.

> and a data plane object (one end of a
> virtual pipe).
> +As a virtual link endpoint, the representor can be configured like any
> +other netdevice; in some cases (e.g. link state) the representee will
> +follow the representor's configuration, while in others there are
> +separate APIs to configure the representee.
> +
> +Definitions
> +-----------
> +
> +This document uses the term "master PF" to refer to the PCIe function
s/master PF/switchdev function
or
s/master PF/switchdev

Especially when you have below text of granting these privileges to a VF/SF=
...
It also aligns to devlink switchdev device notion.
Less new terms for readers and admins to learn. :)

[..]
> Packets transmitted on the
> +   representor netdevice should be delivered to the representee; packets
> +   transmitted to the representee which fail to match any switching rule
> should
> +   be received on the representor netdevice.  (That is, there is a virtu=
al pipe
> +   connecting the representor to the representee, similar in concept to =
a
> veth
> +   pair.)
Please add text that,
Packets transmitted by the representee and when they are not offloaded, suc=
h packets are delivered to the port representor netdevice.

> +What functions should have a representor?
> +-----------------------------------------
> +
> +Essentially, for each virtual port on the device's internal switch,
                                                                           =
 ^^^^
You probably wanted to say master PF internal switch here.

Better to word it as, each virtual port of a switchdev, there should be...

> +there should be a representor.
> +Some vendors have chosen to omit representors for the uplink and the
> +physical network port, which can simplify usage (the uplink netdev
> +becomes in effect the physical port's representor) but does not
> +generalise to devices with multiple ports or uplinks.
> +
> +Thus, the following should all have representors:
> +
> + - VFs belonging to the master PF.
> + - Other PFs on the local PCIe controller, and any VFs belonging to them=
.
Local and/or external PCIe controllers.

> + - PFs and VFs on other PCIe controllers on the device (e.g. for any
> embedded
> +   System-on-Chip within the SmartNIC).
> + - PFs and VFs with other personalities, including network block devices
> (such
> +   as a vDPA virtio-blk PF backed by remote/distributed storage), if the=
ir
> +   network access is implemented through a virtual switch port.
> +   Note that such functions can require a representor despite the
> representee
> +   not having a netdev.
This looks a big undertaking to represent them via "netdevice".
Mostly they cannot be well represented by the netdevice.

Even a network function was not fully fitting into the existing port repres=
entor netdevice.
In some cases, such vDPA devices are affiliated to the switchdev, but they =
use one or multiple of its ports.
In second scenario, today vdpa devices are used without switchdev device to=
o.

Configuring vDPA device's block size, capacity, iops just doesn't make sens=
e to control via netdevice representation.

vdpa has its own subsystem [1] to manage its backend.

So please remove above vdpa related documentation that doesn't reflect the =
current kernel.

[1] https://man7.org/linux/man-pages/man8/vdpa.8.html

> + - Subfunctions (SFs) belonging to any of the above PFs or VFs, if they =
have
> +   their own port on the switch (as opposed to using their parent PF's p=
ort).
Not sure why the text has _if_ for SF and not for the VF.
Do you see a SF device in the kernel that doesn't have their own port, due =
to which there is _if_ added?

> + - Any accelerators or plugins on the device whose interface to the netw=
ork
> is
> +   through a virtual switch port, even if they do not have a correspondi=
ng
> PCIe
> +   PF or VF.
> +
Above vdpa block is good example that cannot be represent by the netdev por=
t representor.
I would imagine other accelerators won't be able to fit in the netdev repre=
sentation.

> +How are representors created?
> +-----------------------------
> +
> +The driver instance attached to the master PF should enumerate the
> +virtual ports on the switch, and for each representee, create a
> +pure-software netdevice which has some form of in-kernel reference to
> +the PF's own netdevice or driver private data (``netdev_priv()``).
Today a user can create new virtual ports. Hence, these port represnetors a=
nd function representors are created dynamically without enumeration.
Please add text describing both ways.

For mlx5 case a representor netdevice has real queue from which tx/rx DMA h=
appens from the device to/from network.
It is not entirely pure software per say.
Hence, "pure-software" is misleading. Please drop that word.

> +If switch ports can dynamically appear/disappear, the PF driver should
> +create and destroy representors appropriately.
> +The operations of the representor netdevice will generally involve
> +acting through the master PF.  For example, ``ndo_start_xmit()`` might
> +send the packet through a hardware TX queue attached to the master PF,
> +with either packet metadata or queue configuration marking it for delive=
ry
> to the representee.
Sharing/not sharing TX and RX queue among representor netdevices is not yet=
 well established.
Mostly my knowledge is ancient on sharing model.

In mlx5 driver queues are per representor netdevice. For others may be diff=
erent.

Is there a way for the netdev to tell that it shares resources/queues with =
other netdevices?

So better to say:
The operations of the representor netdevice will generally involve using re=
sources/queues attached to the netdevice.

> +
> +How are representors identified?
> +--------------------------------
> +
> +The representor netdevice should *not* directly refer to a PCIe device (=
e.g.
> +through ``net_dev->dev.parent`` / ``SET_NETDEV_DEV()``), either of the
> +representee or of the master PF.
This isn't true.
Representor netdevices are connected to the switchdev device PCI function.
Without linking to PCI device, udev scriptology needs to grep among thousan=
ds of netdevices and its very inefficient.

May be a better code in future to take the dev.parent directly from the dev=
link port a netdevice is attached to.

> +There are as yet no established conventions for naming representors
> +which do not correspond to PCIe functions (e.g. accelerators and plugins=
).
Netdevice represents the networking port of the function.
So, this is not applicable text here.

> +Configuring the representee's MAC
> +---------------------------------
> +
> +
> +Currently there is no way to use the representor to set the station
> +permanent MAC address of the representee; other methods available to
> do this include:
Just rewrite above line as:
Representee's MAC can be configured using ..

Overall looks good doc to add apart from above comments to fix.
