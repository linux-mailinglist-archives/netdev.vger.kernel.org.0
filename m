Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42D414D2B63
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:06:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbiCIJHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:07:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiCIJHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:07:19 -0500
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (mail-bn8nam11on2055.outbound.protection.outlook.com [40.107.236.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E1716BCCA
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:06:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KH0Ogxocq+1xxPUJ+C7WuSEQYUKqDOuqURBjl+Z3APe+ys3X1OkBbS/hNe1FwQMHQpZaw7qa0Kt65dPy3RFVnd0CBxR5pXezHBj7VMzR/ndnAE9ymU5P6Cn1JRlCSu8mMhJ2gkLmN0P/0hNxp7uo/LWabwVqZTzJmetC/X50BZ2NyorWq8fYCT16/T6ijVB0qBHLT07BrOvnHjoXaKvtnJM8NF/7wu87fPa2x9elD2BdTBQeZeqZLgzok+1W07Bpzv6sHZhtY6TCx8Cn68jlzRHqfnhWM9ZDoqLsE0A5ryMmD6sHCVZUZrcPDH2W++HIunJZmgxq4pKfRyOX6AeQeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3lMya3CI2yeP8jYxNXoXkBjf6zFbz3x3yMV33kbGFbY=;
 b=jZ651x+5hs1aFpUdyeW/nptw+1vj84Kx8vazjH3+g1UfMg3J3GbXtsKGXnJz6oWj+Bo1YC+iZNe0SQqKYDWZ2GhSDxFxqRFEcvMe/Z2llZulPxFwMhj9f1siApLY9xzmbMEN/BtZw9X2fHsC3ooE2RBKCWlBodnAM7E17etvZD2m0uUviwKhv9WV0JgEL0/6d88JpyHc+ndYcgp+YMC7WD+3c+8uuhB8CfUxHz6MhWuGsg/GRXWBNDuAM9oIHtlYw3Krtv9+g0G8MlcXli+lUo5Ygv24aLMk5dKfy4WGU7AhoJvpJfmvP2RGW9onWWTqy2eSlSXgTUviNBqqV2CAJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3lMya3CI2yeP8jYxNXoXkBjf6zFbz3x3yMV33kbGFbY=;
 b=f8IwsuC3+/pMZzztpgsOsYYreJZcKZVbjHIg7tjGQXMHlk9cuy6lgFZiqTtsz2rAucQxCRLWQjRFGVm7vymsBYqnRaDYyjHUYbJdx/r1Mdksxii8Jc+yxOIpm6b9MTzG/kfhhYh/7Q7l5QTQVuXrAZeK1mjgpFncRAaP4B0w8+QlBinLi6XDXdCvbiH3JTZbGA/P+4XbMIrxlrCgzrpb4uQcZeTi60DfYkExG0eYJiOTwMsoDMIrx0c/2Inj39d+krJOZ/4MDhO2uftGeIGej/P+cSjzuKYDMUPtbfFeT2PSGqcLH5PMoKD9LCYHJ6a9kg/fcRWvCbl/tpyMMsdwmQ==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 MWHPR12MB1390.namprd12.prod.outlook.com (2603:10b6:300:12::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.16; Wed, 9 Mar 2022 09:06:18 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 09:06:18 +0000
From:   Eli Cohen <elic@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
CC:     "jasowang@redhat.com" <jasowang@redhat.com>,
        "mst@redhat.com" <mst@redhat.com>,
        "lulu@redhat.com" <lulu@redhat.com>,
        "si-wei.liu@oracle.com" <si-wei.liu@oracle.com>
Subject: RE: [PATCH v4 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Topic: [PATCH v4 3/4] vdpa: Support for configuring max VQ pairs for a
 device
Thread-Index: AQHYLgKNg+BCuYZ5uU2uKXZ2Uu8GOay2y8GAgAABTICAAACzEA==
Date:   Wed, 9 Mar 2022 09:06:18 +0000
Message-ID: <DM8PR12MB5400D277188F317E598922DFAB0A9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220302065444.138615-1-elic@nvidia.com>
 <20220302065444.138615-4-elic@nvidia.com>
 <PH0PR12MB548172B198631CFC8A99D82CDC0A9@PH0PR12MB5481.namprd12.prod.outlook.com>
 <DM8PR12MB5400B21166928A0ABB42061AAB0A9@DM8PR12MB5400.namprd12.prod.outlook.com>
In-Reply-To: <DM8PR12MB5400B21166928A0ABB42061AAB0A9@DM8PR12MB5400.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 0f8251d2-7fc1-4f37-d519-08da01ac129a
x-ms-traffictypediagnostic: MWHPR12MB1390:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1390D9156A1F94263E1C372EAB0A9@MWHPR12MB1390.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PsJzSI6tDrgRa20sAx+0L4uzE5fWaNVOQMACTq7aQ3xyIL2PeNtfeDkfCS24hkQd69HKpeL7g4IftiRimz5mUQyjpntkdIfm2hDfIN8ReIGwnjSyWPjlBwHCguZBoesXcnh9N4fk39zOGZoSLzKye3bHu3Kl8mQHetiyKnqCx8SsFrikDcdZujo8wi3nwJU06hxKYTmWWB0OsuzwaeSnSQ5heIh06LMKKVIqiksHhimu7tb9Wo2VULo/VA7hS54qUX+uWibg6tjAaXQ9hEZzIGXVQRZyCJIqvTFQFflFLfZIuKD8QWsuQ1X5Q3rJKwHL64r33K3bMduW5t7lfiq+DDx1thTBldZQIBKqtVA9twJy3PBHLPgsvH/imM9QGddIo1E9qx2aO7KbXw0kHfeM7wdlRV5GaLHpKt1zVb/BWUzsEYWNpQsHSmZH7k4f7SidF+7XeV4M0RMOf4wBqbaRAIxRCRAjDU1d+/2VgPYrUj9e6DzBlepLafwf0y4Zsrgl+HZNF8/0ka812Je9KfVgiRN2NkExtQzInrVKfBvH2xA8QV4/4Qm9ALbNB7KhLjdeYJwqnNH8AE0TQBxFF4EhAJkPJ67ymCKKv0kXVDKufn1tQbXzoS6+xqjWr3xttWTuf/31yJBK2iyxD6IW+VBl3e9Jo6W4cMzBw+XY45Q39i2D53sduoWwLc1Fn2ld8zFgWiQFLD2CPnfykC1eK5UUfg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(2906002)(9686003)(2940100002)(86362001)(71200400001)(26005)(186003)(38100700002)(316002)(33656002)(110136005)(54906003)(122000001)(55016003)(83380400001)(66446008)(66476007)(64756008)(8676002)(38070700005)(66946007)(76116006)(4326008)(66556008)(508600001)(52536014)(53546011)(5660300002)(8936002)(7696005)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?JHYu3Ry9wlzYmaJ1nUmzPDMA7KjCslOmcX2aHpxcjtaBhs4ssuiKjImUKs4w?=
 =?us-ascii?Q?62kefSUk0yZzHhX6cHh1Mg+8q987OfaMQtlmtf3HPWf47zZ+iQsyWmXyN3Qx?=
 =?us-ascii?Q?7TY2VEnV+Tk6Z36Ns+7/ljPY8/OmlwzW02zO2xpcrovjnwDx0BKrdipcj4g3?=
 =?us-ascii?Q?4mX1YhXF42j768sBBInv2QVrlwNW06tX2KZoUBUlQqndeU5XohBF0LGZBzP5?=
 =?us-ascii?Q?y1GVoEVZf7Kygc52FyfNHOF9UF2WbyGtmyXjasaj2EDi6YNw6Cp3Xx7fEwUa?=
 =?us-ascii?Q?4MQw6Pq85fdArjDWfMwKs/nLQvb+JcfnZCS9mdmwyAfXd9eKy68E9x77POcl?=
 =?us-ascii?Q?R/5F2FchTjwFGezoYess2MdwsDgLXAupJ7Y2EY/DQG1I8/NskCuwN8JPl2MK?=
 =?us-ascii?Q?9HXilozS/FnBGpo1e9YBVySm3I8G4VSR4e+1F249807Mw16nuTNBe5qmP22A?=
 =?us-ascii?Q?ZtY+8s1blA5IlyH7jYA8yH6CwTIXNzIgILyFzC2OlEDBtbUhWvsgPpuTIHKF?=
 =?us-ascii?Q?ubVXVD8OHmQ4DmAv+ptfnJKlGTfQrPaorqPwC2KL8AW4kYkQweXc2ziIffbR?=
 =?us-ascii?Q?4RrDUaznNC0dA1gf+3U1z5FB1frr82h2hPxrldMr5e7raMvd1wPadnNptE7K?=
 =?us-ascii?Q?3zB13YhEJFDsu3D3R3sP+9XQt4wG5rBZRd5N3BbjF5bZ077BKeJBd2if7cpw?=
 =?us-ascii?Q?oFATOFSSy1tyqP7+8k3PIoUA2TqQLKJodjF75T5R6YLvEvnXm2ZJ8NxBKXof?=
 =?us-ascii?Q?oYuufuEaS5eQjesBjtMIdKF5/QUhU5Dah0FTIxuNffhXQ5+3gazR5JP21jBc?=
 =?us-ascii?Q?EZYpGuo3+EeJAHGp9qBqQiOeM6O+uZp1fo8a7dfHqAH6WF/+7DiDXXqOzMhc?=
 =?us-ascii?Q?04SMSqIgVDQFisOmCW3YyJglGTqXmD/q7oCJQZ+jeJxte7ApoLLnSer4HweG?=
 =?us-ascii?Q?UcQ8ZDI7T4fMTJ7YcIyCJwkjP4q5/ExEdI/gv68mEUcpogrSn8CvjE3Ypm95?=
 =?us-ascii?Q?eTUzziUC7jZTbO2ungjZZVnTKIUUya/b74G5griak7eO22MIZNxqsxUXEQdX?=
 =?us-ascii?Q?OA2KvUKke63/PL+r6+tqK3cpKa/kxWD4cuGW6iJ3aFbZE0XVroYDtQj9MNnH?=
 =?us-ascii?Q?9uULTvkeibbJKargPVv0HHFerf1dZd64khJdE6nTMSPXr8xorKyUAhTrJ+SK?=
 =?us-ascii?Q?RnHlYBqWG5GvUZEynSRG4pPQDh8mPbMVZfqz2KvJNvDP0k/86ttcHcxc34Wd?=
 =?us-ascii?Q?ueg0htNAWC2azrwi+E7Nv0uFqu99SlqHOm35G2NHolCt+N1pmG9t/ByCFrNx?=
 =?us-ascii?Q?TBrEFAcpJoBxyfxp0Kj+67DUzpc9pu0PeKDg54p75WmMgrn9VRh22t8Kw82n?=
 =?us-ascii?Q?nPxSMSZ4DAvEoQGrzDsKQFbU32yfSsTh0rsd5ASNVURaqE72mnoh9lXrrv+s?=
 =?us-ascii?Q?Br7xFdDrPaAINo+TVxTD9NO+ubLR9JLjs51LwlCz3QkaBPgObdmktgtwjEJa?=
 =?us-ascii?Q?6PUDzDG9OLThMlY3y7Lq6nMty2FK2EHyaSaLwsBwqETNp35t0zTo7DxDkQ?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f8251d2-7fc1-4f37-d519-08da01ac129a
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 09:06:18.4005
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: NnIyywlelJXecp4x2LasCczsITtZFrqnp0C0N4oBjHZM4umQFW8bBP37DOh/ReAR
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1390
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Eli Cohen
> Sent: Wednesday, March 9, 2022 11:04 AM
> To: Parav Pandit <parav@nvidia.com>; stephen@networkplumber.org;
> netdev@vger.kernel.org; virtualization@lists.linux-foundation.org
> Cc: jasowang@redhat.com; mst@redhat.com; lulu@redhat.com; si-
> wei.liu@oracle.com
> Subject: RE: [PATCH v4 3/4] vdpa: Support for configuring max VQ pairs fo=
r a
> device
>=20
>=20
>=20
> > -----Original Message-----
> > From: Parav Pandit <parav@nvidia.com>
> > Sent: Wednesday, March 9, 2022 10:59 AM
> > To: Eli Cohen <elic@nvidia.com>; stephen@networkplumber.org;
> > netdev@vger.kernel.org; virtualization@lists.linux-foundation.org
> > Cc: jasowang@redhat.com; mst@redhat.com; lulu@redhat.com; si-
> > wei.liu@oracle.com
> > Subject: RE: [PATCH v4 3/4] vdpa: Support for configuring max VQ pairs
> > for a device
> >
> >
> > > From: Eli Cohen <elic@nvidia.com>
> > > Sent: Wednesday, March 2, 2022 12:25 PM
> > > --- a/vdpa/include/uapi/linux/vdpa.h
> > > +++ b/vdpa/include/uapi/linux/vdpa.h
> > > @@ -41,6 +41,7 @@ enum vdpa_attr {
> > >  	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
> > >
> > >  	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> > > +	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> > >
> > Its u32 here, but in the code below at places, it is mix of u16 and u32=
.
> > Please make it consistent to be u32 or u16 to match to kernel at all pl=
aces.
> >
> > >  	/* new attributes must be added above here */
> > >  	VDPA_ATTR_MAX,
> > > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c index
> > > 5f1aa91a4b96..22064c755baa 100644
> > > --- a/vdpa/vdpa.c
> > > +++ b/vdpa/vdpa.c
> > > @@ -25,6 +25,7 @@
> > >  #define VDPA_OPT_VDEV_HANDLE		BIT(3)
> > >  #define VDPA_OPT_VDEV_MAC		BIT(4)
> > >  #define VDPA_OPT_VDEV_MTU		BIT(5)
> > > +#define VDPA_OPT_MAX_VQP		BIT(6)
> > >
> > >  struct vdpa_opts {
> > >  	uint64_t present; /* flags of present items */ @@ -34,6 +35,7 @@
> > > struct vdpa_opts {
> > >  	unsigned int device_id;
> > >  	char mac[ETH_ALEN];
> > >  	uint16_t mtu;
> > > +	uint16_t max_vqp;
> > >  };
> > >
> > u16 here.
>=20
> It should be u32. I will fix and resend.
Sorry, I meant u16.
>=20
> >
> > >  struct vdpa {
> > > @@ -81,6 +83,7 @@ static const enum mnl_attr_data_type
> > > vdpa_policy[VDPA_ATTR_MAX + 1] =3D {
> > >  	[VDPA_ATTR_DEV_MAX_VQS] =3D MNL_TYPE_U32,
> > >  	[VDPA_ATTR_DEV_MAX_VQ_SIZE] =3D MNL_TYPE_U16,
> > >  	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] =3D MNL_TYPE_U64,
> > > +	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] =3D MNL_TYPE_U32,
> > >  };
> > u32 here, but code is doing u16.
> >
> > >
> > >  static int attr_cb(const struct nlattr *attr, void *data) @@ -222,6
> > > +225,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct
> > > +vdpa
> > *vdpa)
> > >  			     sizeof(opts->mac), opts->mac);
> > >  	if (opts->present & VDPA_OPT_VDEV_MTU)
> > >  		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU,
> > opts-
> > > >mtu);
> > > +	if (opts->present & VDPA_OPT_MAX_VQP)
> > > +		mnl_attr_put_u16(nlh,
> > VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
> > > opts->max_vqp);
> > >  }
> > >
> > u16 here.
> >
> > >  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char
> > > **argv, @@ -
> > > 290,6 +295,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int
> > > argc, char **argv,
> > >
> > >  			NEXT_ARG_FWD();
> > >  			o_found |=3D VDPA_OPT_VDEV_MTU;
> > > +		} else if ((matches(*argv, "max_vqp")  =3D=3D 0) && (o_optional &
> > > VDPA_OPT_MAX_VQP)) {
> > > +			NEXT_ARG_FWD();
> > > +			err =3D vdpa_argv_u16(vdpa, argc, argv, &opts-
> > > >max_vqp);
> > > +			if (err)
> > > +				return err;
> > > +
> > > +			NEXT_ARG_FWD();
> > > +			o_found |=3D VDPA_OPT_MAX_VQP;
> > >  		} else {
> > >  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
> > >  			return -EINVAL;
> > > @@ -501,6 +514,15 @@ static void pr_out_mgmtdev_show(struct vdpa
> > > *vdpa, const struct nlmsghdr *nlh,
> > >  		pr_out_array_end(vdpa);
> > >  	}
> > >
> > > +	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> > > +		uint16_t num_vqs;
> > > +
> > > +		if (!vdpa->json_output)
> > > +			printf("\n");
> > > +		num_vqs =3D
> > > mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> > > +		print_uint(PRINT_ANY, "max_supported_vqs", "
> > > max_supported_vqs %d", num_vqs);
> > > +	}
> > > +
> > >  	pr_out_handle_end(vdpa);
> > >  }
> > >
> > > @@ -560,7 +582,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int
> > > argc, char **argv)  static void cmd_dev_help(void)  {
> > >  	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> > > -	fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> > > MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> > > +	fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> > > MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [max_vqp
> > MAX_VQ_PAIRS]\n");
> > >  	fprintf(stderr, "       vdpa dev del DEV\n");
> > >  	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");
> > > } @@ -650,7 +672,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int
> > > argc, char **argv)
> > >  					  NLM_F_REQUEST | NLM_F_ACK);
> > >  	err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> > >  				  VDPA_OPT_VDEV_MGMTDEV_HANDLE |
> VDPA_OPT_VDEV_NAME,
> > > -				  VDPA_OPT_VDEV_MAC |
> > > VDPA_OPT_VDEV_MTU);
> > > +				  VDPA_OPT_VDEV_MAC |
> > > VDPA_OPT_VDEV_MTU |
> > > +				  VDPA_OPT_MAX_VQP);
> > >  	if (err)
> > >  		return err;
> > >
> > > --
> > > 2.35.1

