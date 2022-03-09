Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EB504D2B48
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 10:04:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbiCIJE4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 04:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229623AbiCIJEz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 04:04:55 -0500
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (mail-sn1anam02on2068.outbound.protection.outlook.com [40.107.96.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED4D1405C0
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 01:03:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HGcHWNpVPduGYIFSHt0F8PCQhg2eX4yI2AEwSw5sEKDWCepZCUKNCYiiegBmD8i5heErBpjAwnNcItKabn8dnQqgpyQIXdNfkEdOMr3yeFxZZB2Vv3bX8w13tHUHKDxp/eX8XW+OK8egsL5SyOYsh0CLVN+nOGIAsG9kx2MLadtANCB01uBpS4titFan/Ndao8DCf9M9qPAV82SxuvkAMsUhs4if7hjkj+Y87VWvh8WAIfT/6Vf2ZE9B1kMeZkfxQvuYTmXIuYjX8nL/DUR2EEmPbM10D4CQbi8qcx+X8i4/sG9Ct1XC3s+qQt+faSyIv+ZqLYvqkPn8f+H9uHu5qA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=z/UplNMzszX3H+I4eAjTdWLqfMDhMPA/0eQXcZl8hjg=;
 b=BBFKCIZMOOumuL6+Rwz0rk10KSJmcuHOjA0EgsRgLJAEK+1YxFsmlJGc1QYXd05uytQgQfkzSos7QW0kw3Q1Q7LImYmt6wHlAGrhxfNLLLraPDV6pQb89k06mgwjnXtaTtqYaZiGA3TgOnbI/kRWuFG2hHYL1TGuvSBjQ1PHKEIaeC+d91yZ/X1ziERjxtH1mtexQ8U4TT1ljFZNecXGzhV0wEXNA/EfhFJwFdmjCy7OyX/eTNngi9agrT1E2VQoTKAOvlpOz2xKLStt2qpHQJMfsIDRFldBXkJdI07S9LC1KqIj97qJv1K9BA5euMaj71U9WT4HXs72g/8whB1UUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z/UplNMzszX3H+I4eAjTdWLqfMDhMPA/0eQXcZl8hjg=;
 b=OtsPCT7Bua/iymrp+GvPYPWHakrjT6Wt5CAee5Yq3Emh1sQ7qmp2DFhI9UdryaqVRSoiL2KX8bLv3bVwazIeYDW0P/N+eZuMc7RpYhdq3G/UOtBlV8soxNE+d5sa0gleFp6vUK3Kg9/ATZwrPYywU2jMEZfqCBiqLvjM0rErzOBlHrRUr88q9CRFQp/DsjqhWRSTureENdgT4qjoraiWG+LOJW9Yt36DyjfRxCBtjiI/yg3ZbtCcl3CYT8ynEToosk0xzcodK+YTHhuzIhXlZbSAac4sBKxC9pjZtHl/p3m62PYX0HutCvdpmq+B03o+fuO6AKcu5YgagdLSpZSa1w==
Received: from DM8PR12MB5400.namprd12.prod.outlook.com (2603:10b6:8:3b::12) by
 DM6PR12MB5022.namprd12.prod.outlook.com (2603:10b6:5:20e::20) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.14; Wed, 9 Mar 2022 09:03:53 +0000
Received: from DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627]) by DM8PR12MB5400.namprd12.prod.outlook.com
 ([fe80::c53a:18b3:d87f:f627%5]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 09:03:53 +0000
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
Thread-Index: AQHYLgKNg+BCuYZ5uU2uKXZ2Uu8GOay2y8GAgAABTIA=
Date:   Wed, 9 Mar 2022 09:03:53 +0000
Message-ID: <DM8PR12MB5400B21166928A0ABB42061AAB0A9@DM8PR12MB5400.namprd12.prod.outlook.com>
References: <20220302065444.138615-1-elic@nvidia.com>
 <20220302065444.138615-4-elic@nvidia.com>
 <PH0PR12MB548172B198631CFC8A99D82CDC0A9@PH0PR12MB5481.namprd12.prod.outlook.com>
In-Reply-To: <PH0PR12MB548172B198631CFC8A99D82CDC0A9@PH0PR12MB5481.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: cbd39a71-953e-49e2-7901-08da01abbc14
x-ms-traffictypediagnostic: DM6PR12MB5022:EE_
x-microsoft-antispam-prvs: <DM6PR12MB5022CE6AEA8D586486CF78E0AB0A9@DM6PR12MB5022.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ph7cU5Lmmq+7+QLRYKfDOCzzs9EiuZFE90EIBqpdC/Yz5Q7I0Bc8m2NN64zf1K0LmG2db0BHy8XnVpgqWhE4co+3ch5BDOwHmnJM38QMn0QpSl4taFkbRxHPKoMOZz+66wO5VOgEF4SMFih5CmhLDwLnhg6UDx6Cubi9qHrJU2yJesMo4QTsJIav+5SgIeqFkI9/OT7kqOiZzoShXXBETo7iXIc8eA3XIkoMc6gBHUGdsyXrDA1LDnq/ekbp7HKC/9z8LBhcoQpykuey7Ig2Cf0/zJIFbL5ePEIxvkRtPtdm4GiogOisAOhshivEJSWWtzGQUaHv0z8MjN95tWePSyotud2gYGAVqlzLXEyOVJDmScmp1XTyrwKzOLdMdDFOXxi/b+lcrzit0HyHx+Nim5MUIOUxwFVw9bJKvihPSt3gt9poe6yOY848h2WjjyHfP0jCXnYFpfZ6Eqh1rRAr4ecgt7+d2H4QfmLHvUQxXGUThTnAKkyolMeQdyr/ASyyv4pKedDC6ddSNGhf4bWOZEUyJtaka9eQIafQeKbJU9hliQv/LVi8Z6HmbpgiEUF3/lar1QNHCmX8O0enbh+5C9mV0sXI7MPSkmV52D+ChwR100keb1okiXWTyzFoROzb5KA1vXtQ7uyQEAvbCE4i1PyvWDIeVaDLXLRpstU2z8qSwdP9xqWanTjdcQb9+DcfTj+DbaJbIXpVpICfbJFA2A==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR12MB5400.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(64756008)(8676002)(66446008)(76116006)(2906002)(66556008)(38100700002)(66946007)(4326008)(66476007)(54906003)(122000001)(71200400001)(52536014)(110136005)(38070700005)(8936002)(5660300002)(55016003)(53546011)(86362001)(508600001)(316002)(6506007)(33656002)(7696005)(186003)(26005)(9686003)(83380400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?G4/4JObX/N0ZWHdCTUbEeme8WgEVEfIiFZKSXltlgyiTLypNIIiV1Yssh/kf?=
 =?us-ascii?Q?+MAo/hvfsalVxPGCJg72oE0S0WcSQEMhI7189LW8m8WuBDaGepKYs9HD/sSF?=
 =?us-ascii?Q?axU6eByhhezcx7wZ5VbCktk9/zHo5hr11cb6rhK49mCzaZc/24pmfTTGh+Yv?=
 =?us-ascii?Q?eILd6Ni+Kh6SQfQBQG3b7e4JeTCQgtwBrBDjLyJPI03OvG7JdBP+BFKckJcv?=
 =?us-ascii?Q?ih18mJ0d3/INWuQpvKk2xD6aNCNcfgpSUveSc1zM/Agdg/RY28yCvWmUYsdh?=
 =?us-ascii?Q?9tz8dpImCuL9X9x/0JRI+2z6LV/YJjrYPsKenIIQO7XGMtaNbOJLHgO//OKW?=
 =?us-ascii?Q?EclNqHbcUydiT52pPB0CvcTbIwqR8EpxMGq1yIlgOChrUGAYhEDMBjd+yRiV?=
 =?us-ascii?Q?n/djJ5OaMtn/YeUT1c7YZR6kMfGzg7WLTAZ5ZKM9nYEeW25R1JoB/c52/nav?=
 =?us-ascii?Q?mBME1UmaTeDuZ2kIzAUggyIgX9T8GYn/J+Ih6mPpC6v5cCKWES/law1q9ulN?=
 =?us-ascii?Q?CB7jMOP9R0yTXNDik5a/W5mdeIOFBZlzM1X7gZzDzictDX8gv/I0BqQocW/s?=
 =?us-ascii?Q?pBlqhTyNHvvaAqT4yhCRiPW3QqWLtmDEbzFy1DN0/VGkaESrzaa5keZSrFjU?=
 =?us-ascii?Q?iLdY+0CBE6k1E73HnZynTikCJfJsQltEkdtoOq9fEMgD96djYesfWyUybVxM?=
 =?us-ascii?Q?vQ+ifP4QvzIwc5UlyfTE0PxSQWWz2AwFCtmOXmCrLuJs68p3RdcL7QtNujL6?=
 =?us-ascii?Q?tyOxk8lwVA/YmwnP12iIjutrCFgMY3VJtqkG9U72vGL1GxhyvvdrCa5Wk9IN?=
 =?us-ascii?Q?F5o/1s3PU9xWKH/QA4XxXk69RbrrFIfwS+wDqjjIAB8WmEe2stfsqGqtTi1b?=
 =?us-ascii?Q?mVqudp7OeGxNGAuDlPPDhUPoFbKlEtSf0QPzqqDs5Y6tm/U3MlHNjO7MsqFu?=
 =?us-ascii?Q?FZOX0yJgPasjjROSFtx4YM1+xAR+TGkmOOX2XQtcd9GKpJX3LaSYxsZGLkbb?=
 =?us-ascii?Q?pGDXEtSUAhOInJLqxdZcRaPef7O8CZJZqrJUIOv4TF0rC/sLXEOYWR+NueyT?=
 =?us-ascii?Q?TMtOuCBCcTfskVtiOHJnjokecaucKJcvBqNg4z7uH4UMn7ZschQE5dKw5BdV?=
 =?us-ascii?Q?SsNQVlfrG2vgVsxq4CVVcpsjqCAv3OO39dQc4IHOccCuHs2Gv4pq4wtezZtp?=
 =?us-ascii?Q?vwjzRQtqSUeemTY2MYBd7msoB9/c6IoOq9FAuozZjRC7BfusQ5OSMHA5bjNF?=
 =?us-ascii?Q?4hhhk9iGpTY/1LtvSalu407JiOgnpKw/lnbXhdMkdLGW2GgAz6xXOvo7Mu6/?=
 =?us-ascii?Q?of8qTNoBSBiZrib/RqevaOm88sbNHBMCK4E910t0qCFwt/JBxYN8QCpdh7KO?=
 =?us-ascii?Q?OrPV9/3I8/zI5/6uYzo4qa+52wKrbvy1SDHeRZdwORk34ELHaCeGsQL2E+k2?=
 =?us-ascii?Q?kKafq/3SSxDq/2BCFM9G92U2wXJirQKafz5LFkWo32hw2c6oxGI8JptjzoKo?=
 =?us-ascii?Q?ckOP2WVFD5poJpx23beyfcveJJkXsLX1chFA1ZSFadpLeWNigDelFhjFPg?=
 =?us-ascii?Q?=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR12MB5400.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cbd39a71-953e-49e2-7901-08da01abbc14
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Mar 2022 09:03:53.1902
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dynOIEwvfB2a4k8eyPUKGmZkRxVbHIPsjd78g1mTlwC22T5sQxZM3Z1+QqN265Qn
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB5022
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
> From: Parav Pandit <parav@nvidia.com>
> Sent: Wednesday, March 9, 2022 10:59 AM
> To: Eli Cohen <elic@nvidia.com>; stephen@networkplumber.org;
> netdev@vger.kernel.org; virtualization@lists.linux-foundation.org
> Cc: jasowang@redhat.com; mst@redhat.com; lulu@redhat.com; si-
> wei.liu@oracle.com
> Subject: RE: [PATCH v4 3/4] vdpa: Support for configuring max VQ pairs fo=
r a
> device
>=20
>=20
> > From: Eli Cohen <elic@nvidia.com>
> > Sent: Wednesday, March 2, 2022 12:25 PM
> > --- a/vdpa/include/uapi/linux/vdpa.h
> > +++ b/vdpa/include/uapi/linux/vdpa.h
> > @@ -41,6 +41,7 @@ enum vdpa_attr {
> >  	VDPA_ATTR_DEV_NET_CFG_MTU,		/* u16 */
> >
> >  	VDPA_ATTR_DEV_NEGOTIATED_FEATURES,	/* u64 */
> > +	VDPA_ATTR_DEV_MGMTDEV_MAX_VQS,          /* u32 */
> >
> Its u32 here, but in the code below at places, it is mix of u16 and u32.
> Please make it consistent to be u32 or u16 to match to kernel at all plac=
es.
>=20
> >  	/* new attributes must be added above here */
> >  	VDPA_ATTR_MAX,
> > diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c index
> > 5f1aa91a4b96..22064c755baa 100644
> > --- a/vdpa/vdpa.c
> > +++ b/vdpa/vdpa.c
> > @@ -25,6 +25,7 @@
> >  #define VDPA_OPT_VDEV_HANDLE		BIT(3)
> >  #define VDPA_OPT_VDEV_MAC		BIT(4)
> >  #define VDPA_OPT_VDEV_MTU		BIT(5)
> > +#define VDPA_OPT_MAX_VQP		BIT(6)
> >
> >  struct vdpa_opts {
> >  	uint64_t present; /* flags of present items */ @@ -34,6 +35,7 @@
> > struct vdpa_opts {
> >  	unsigned int device_id;
> >  	char mac[ETH_ALEN];
> >  	uint16_t mtu;
> > +	uint16_t max_vqp;
> >  };
> >
> u16 here.

It should be u32. I will fix and resend.

>=20
> >  struct vdpa {
> > @@ -81,6 +83,7 @@ static const enum mnl_attr_data_type
> > vdpa_policy[VDPA_ATTR_MAX + 1] =3D {
> >  	[VDPA_ATTR_DEV_MAX_VQS] =3D MNL_TYPE_U32,
> >  	[VDPA_ATTR_DEV_MAX_VQ_SIZE] =3D MNL_TYPE_U16,
> >  	[VDPA_ATTR_DEV_NEGOTIATED_FEATURES] =3D MNL_TYPE_U64,
> > +	[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS] =3D MNL_TYPE_U32,
> >  };
> u32 here, but code is doing u16.
>=20
> >
> >  static int attr_cb(const struct nlattr *attr, void *data) @@ -222,6
> > +225,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh, struct vdpa
> *vdpa)
> >  			     sizeof(opts->mac), opts->mac);
> >  	if (opts->present & VDPA_OPT_VDEV_MTU)
> >  		mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU,
> opts-
> > >mtu);
> > +	if (opts->present & VDPA_OPT_MAX_VQP)
> > +		mnl_attr_put_u16(nlh,
> VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
> > opts->max_vqp);
> >  }
> >
> u16 here.
>=20
> >  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv,
> > @@ -
> > 290,6 +295,14 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int
> > argc, char **argv,
> >
> >  			NEXT_ARG_FWD();
> >  			o_found |=3D VDPA_OPT_VDEV_MTU;
> > +		} else if ((matches(*argv, "max_vqp")  =3D=3D 0) && (o_optional &
> > VDPA_OPT_MAX_VQP)) {
> > +			NEXT_ARG_FWD();
> > +			err =3D vdpa_argv_u16(vdpa, argc, argv, &opts-
> > >max_vqp);
> > +			if (err)
> > +				return err;
> > +
> > +			NEXT_ARG_FWD();
> > +			o_found |=3D VDPA_OPT_MAX_VQP;
> >  		} else {
> >  			fprintf(stderr, "Unknown option \"%s\"\n", *argv);
> >  			return -EINVAL;
> > @@ -501,6 +514,15 @@ static void pr_out_mgmtdev_show(struct vdpa
> > *vdpa, const struct nlmsghdr *nlh,
> >  		pr_out_array_end(vdpa);
> >  	}
> >
> > +	if (tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]) {
> > +		uint16_t num_vqs;
> > +
> > +		if (!vdpa->json_output)
> > +			printf("\n");
> > +		num_vqs =3D
> > mnl_attr_get_u16(tb[VDPA_ATTR_DEV_MGMTDEV_MAX_VQS]);
> > +		print_uint(PRINT_ANY, "max_supported_vqs", "
> > max_supported_vqs %d", num_vqs);
> > +	}
> > +
> >  	pr_out_handle_end(vdpa);
> >  }
> >
> > @@ -560,7 +582,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int
> > argc, char **argv)  static void cmd_dev_help(void)  {
> >  	fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> > -	fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> > MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> > +	fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> > MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [max_vqp
> MAX_VQ_PAIRS]\n");
> >  	fprintf(stderr, "       vdpa dev del DEV\n");
> >  	fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n");  }
> > @@ -650,7 +672,8 @@ static int cmd_dev_add(struct vdpa *vdpa, int
> > argc, char **argv)
> >  					  NLM_F_REQUEST | NLM_F_ACK);
> >  	err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
> >  				  VDPA_OPT_VDEV_MGMTDEV_HANDLE |
> > VDPA_OPT_VDEV_NAME,
> > -				  VDPA_OPT_VDEV_MAC |
> > VDPA_OPT_VDEV_MTU);
> > +				  VDPA_OPT_VDEV_MAC |
> > VDPA_OPT_VDEV_MTU |
> > +				  VDPA_OPT_MAX_VQP);
> >  	if (err)
> >  		return err;
> >
> > --
> > 2.35.1

