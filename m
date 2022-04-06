Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8794F6557
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 18:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237021AbiDFQNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 12:13:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiDFQMU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 12:12:20 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2063.outbound.protection.outlook.com [40.107.212.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15A9C36FB60
        for <netdev@vger.kernel.org>; Tue,  5 Apr 2022 20:45:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=egSet2iAeKTvwtbw5v2ot8H4tNjzOV+YdKfDqVMb6iJy8xGTI3Pmau13y35sVNqkANCBBQBduWL3SlX7P1O6KL1A6o/kjo/QKHNMDmhDiegoD7vU4o4PcYZ244D5x5Ja0lpGGoAp1gqtrBcpz5yqeIYFwvEAJ9CooKuCUdIVWvH5TUAJse0jg0QvxM/H+WD6kUHjhrWBvuVWOk/7hQj7lZP6TqamgCYcFecxo16aNi+b0e+C/l2SvMPQjXhB0UZEY3ZbR+MGvo+TXZoVfMVTXDxNjr6artQQkM5fLpzLKIluuHazg53VnWLQyqS8GWCbCVgHnZvhBidjGryxvkhQog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=w/sgEWRSbinG7lPfs7cwzLiZmPWkrwuFqFml9puolv4=;
 b=n829DackAzblL/wNtkco46/iCsflIciGusocqJQ+6MFcJmaSpatdmj+9NbeLWxY9j9NBSJWO2jwH8y6VQKsvx2lCGCcr2shsc1lgme4IaLdpKMUV7ZHrzo1Z/jZ6MHeE37iOZmAkGbeBWEXSaQYjRJzqxD1I4EjRZWhJOCUGlQyhhzSn89kOytDLNSqyOyaPkguo+vrwg8p+DLkLvZ7ZL9D2p8AmWbMIjv/QpfLu82f/25X5UC6q4iETZdYbuo6nFspq/m8Gu2y2IpkHdyep8OBH7yrwE+fkRL69cdKhRlRPAXOSFnqTVbqS18uRsyw318VkDLK+7mZ0ytkHykZF5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=w/sgEWRSbinG7lPfs7cwzLiZmPWkrwuFqFml9puolv4=;
 b=JdnA/kg/3ymGdt2YrBfk/lc9W0uCFz5tppYdsyU62yhgNOGbJzI1G/jJ9zxgzXO9PewD0ns3VoLTWj+uRaWZCYv8RbifENyVzQF+cbjYhDUjRZ7tqHu+RDz1h8Zr67qjBz8vTNXfXDZH7qrmxdDlfN367Epy8obCvuiAT5GCQ9ON+lZVNGh/bpbfoD/4QjgOi77/pOAaiDaFWvk+6OXcCSwUXQBsWR3is+veve78gmzd5KUB/DFULouF2M4b3WCYBRfP1EBkRhvxN+BmXXzwvUPYsK5is6FcxCm5jfgZDiqgZRp1Rv4hADzF9oWQZRnjiLKeN9ZlvqO0B3/kmJzMLA==
Received: from PH0PR12MB5481.namprd12.prod.outlook.com (2603:10b6:510:d4::15)
 by MWHPR12MB1294.namprd12.prod.outlook.com (2603:10b6:300:10::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5123.31; Wed, 6 Apr
 2022 03:45:40 +0000
Received: from PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::9d86:35e6:f740:d3a1]) by PH0PR12MB5481.namprd12.prod.outlook.com
 ([fe80::9d86:35e6:f740:d3a1%3]) with mapi id 15.20.5123.031; Wed, 6 Apr 2022
 03:45:39 +0000
From:   Parav Pandit <parav@nvidia.com>
To:     "08005325@163.com" <08005325@163.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Michael Qiu <qiudayu@archeros.com>
Subject: RE: [PATCH iproute2] vdpa: Add virtqueue pairs set capacity
Thread-Topic: [PATCH iproute2] vdpa: Add virtqueue pairs set capacity
Thread-Index: AQHYP2BSBfg1d33IlkeVlbxjPg3ZbaziUayA
Date:   Wed, 6 Apr 2022 03:45:39 +0000
Message-ID: <PH0PR12MB5481C986ECC2B7CA659DDFE4DCE79@PH0PR12MB5481.namprd12.prod.outlook.com>
References: <1648113553-10547-1-git-send-email-08005325@163.com>
In-Reply-To: <1648113553-10547-1-git-send-email-08005325@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: adcea63a-36ed-4873-906b-08da177feb26
x-ms-traffictypediagnostic: MWHPR12MB1294:EE_
x-microsoft-antispam-prvs: <MWHPR12MB1294D64EB2D2209BD328439FDCE79@MWHPR12MB1294.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gerhm0xHuFdQN3UASrs/1wSLy/ZYNESCz+IYaZ33LRMnDMOZkLQuWeJnyiH4+zuWHt8IKFiXndsOJpuxoc5M5lwgILl3nLv5bSBk1+5eLwgBbkAxcHXHO/R5Nts+r07K3GR30ERYwWamDUdlif1VuMvUuuxyltBEvHemOieaDWyu5kKvsNitxAU4dnzJTZ3aIS4p7cy5Glgh06IVD2DRSfnQDth522xIxTNGtI5cgkAAPAkO+HC0ZPqYKHhz6KhlckusS2EDvpVouURk2t7S2LNa4EThggNMDOpJczZITV68yYElsjIiYYkuTh0otOfUUWT3Fuipb7Z/ixWqussDIbVwQBpz5D3Jznf/FnNXAHpJrxwtVI4YuhZo8sZRp3o1MIrhshrmmgvIzcVi3EjAmqIbBtZz431QqX2P/Sn3BZQJA4EOz+qvu7pJ1/MFC8rDp2CPsdrk9W07n68cSHNdjjv0ACIQSPMdeFVqt6Bg/ZyxTRUqzA+G4ER3Q5/qsVxFN/QALZdmrMBFZZuLgtFnVmf+V6h7/Eq/9THA7Ev2O0Ru5pQT/2ONO0XHE2UfooEJ5rC7j3IGfAakr0ly5P7LXMJAsdvlWnv/sE6PvW+KaJpxHpu6F3DBL8hdrTOq7G1RsAyZfC6z664mZyPXfnTlOYBON31XZ604IsKvbGGBPc76xrvc6Efr9IDiDcy656eMyOjro4SzPpIzgtC+yim2mQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5481.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(38070700005)(4326008)(55016003)(5660300002)(33656002)(54906003)(8936002)(110136005)(316002)(52536014)(71200400001)(64756008)(66476007)(66556008)(66946007)(76116006)(83380400001)(66446008)(8676002)(2906002)(38100700002)(86362001)(508600001)(9686003)(186003)(7696005)(122000001)(6506007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?ou0Z0dbRXGl8rZoqGIDE/BDS4E4WnSh9OlXC++8nuDScXCcXPWI5ZXCTvSVL?=
 =?us-ascii?Q?v6CjcwM/vwusEJpzzjnDeZrzvJSbYQyGcmBm7SJ3HmMGBPpjsbGSvfBzovbV?=
 =?us-ascii?Q?8T7LcADRT8VUhuMtr4uY3Xrj/L/8A6DRXvg+lj0QGLeCz9jG25iNxraxFS6F?=
 =?us-ascii?Q?VoEfHMgfsKAO3gk1fDc+vmG3/5Z5PRifJXWRq5qvFDyPXW0ADhs27wqGr1vT?=
 =?us-ascii?Q?Unw6u1BfKHhx8M1n1FkNN3e6VONTmy6iQwHX31DD0VsKkZr/CxXXBVuoKlAa?=
 =?us-ascii?Q?+7pGfCADux94CqQULraKVF4jNpBT0zHtmbTftYiZzSaynAaZ5g8HO+UmvsVV?=
 =?us-ascii?Q?u0vwzwvtgrWq44RXym5UwQOo4OJ5AIKpzI3zjbR0mA0VS6qKTSRiQtQm77Ks?=
 =?us-ascii?Q?2V06DEirnz4jRehmrqNEaD7zXJ1gqD8Bhsmrc+rv2GxRHNEud8UEeuBx/NX1?=
 =?us-ascii?Q?eZPLqpzO3DzA1tm+cXQPtklF7RrpE48SNFmHeHbBsEp+U6OasOYbCNz2jEIx?=
 =?us-ascii?Q?Tv+99riHee9WE4Clh2jTbjdelFxoEF5PF6pblrNwtRozPMFDgq0DxysCX0Nh?=
 =?us-ascii?Q?kW+XW2WOSa0WozsMGoM89sgLxnNIjIb6y7VejvVLt8YxqywWCKJKlKkNSxTR?=
 =?us-ascii?Q?n21M0xrMrqqWWQP2h4d7xjql8vOzr7gQKCLwPHJ+4S2Df3S51JaZz7TJaKEq?=
 =?us-ascii?Q?gF27RcIHrx9h/d2LatW15RJY/THOCw6fQPOhLMc4vUcTDG1WhybIa5nnzo9t?=
 =?us-ascii?Q?1D/U0l132CaoWQGS+CaDOqpoCCPLOzZEBIYqOczDUA6dFkGArsVBkPRqoFyX?=
 =?us-ascii?Q?GVkARN7cLVU1wdsgb7WiVY+MsEVYMGXBL5L61UB1H8SNBu+GlFRRHuQ18DVg?=
 =?us-ascii?Q?UTnrKXJ0OVz3XpS+v6oAuV03bUbHnVUT/TJ7jXicW06Zl9Jff4CTDBZkMlZz?=
 =?us-ascii?Q?uZVdtght+ItK0tf5uLk3w3S4U9cE0BgmKOTNc3pprRpCgWK4FFu8s6C1D0Sf?=
 =?us-ascii?Q?tDJr35EIiw8hNx11SDjYnJzKA5NdHRK3mazY1eqPxqul5P9nvus+8comBOyK?=
 =?us-ascii?Q?wMrMdadKqCG5GBiL6zl78sd6vg7N329hUYrM9iE7wrpaWXpsQV6/a5QsZL++?=
 =?us-ascii?Q?pXhubzdJtzkPdNR0QokDSTickw0KE7+qCUXAc0ZljVNEFIB2eAinHgQAuw55?=
 =?us-ascii?Q?qLxIpaH9fFsbTQPvwNEG4Zui/JDSGBDOSNEAaub7MlAIhJsLxkeXbQuUqsKt?=
 =?us-ascii?Q?77KdFWhXijdtt579Htya+k5NJhCHd4EWVXqaf/XOmUQ5lh36SBVdwfvMCdqI?=
 =?us-ascii?Q?zQSOFeIm0H9WRWtBdsn6Kk0jUcXRrDh5ayhjtAxw/xXH6hM9ZAaRpmHibOPA?=
 =?us-ascii?Q?Oznbfa4HcrDouc/Wo4h6x52OBtxxDIm4PwsU/+lUm8fqs/PIfM+RVaZcsbQD?=
 =?us-ascii?Q?kioTeejsLuPoS6H/O3OT8z3c210x3+N315d2KHY8/CnTwwQKK4q4GJ09ioVb?=
 =?us-ascii?Q?r6AaFJKI+Db1L0OS0rwOlwlZTLNQtxeMrDmxBM/uNq6PILGVKWaK+0vSMByI?=
 =?us-ascii?Q?Ozm1bGQSxI35v9NciK++9laMIuqV1RzLsnm5pZg0tVe4veEIRZzL3sJpfGBZ?=
 =?us-ascii?Q?U5aneM+rtub9/ujTI6h7MWqUzOlRsa6kXBvftz70XssNzi8B9g6pP+TTWcvu?=
 =?us-ascii?Q?t2VtUAxRm8ZeMHs9K3uaLssfeLC3Lh094JCJOS6REHxihzRKFSw1nCq2Jy7/?=
 =?us-ascii?Q?22/ewwQf7tFva83WbylB42Uvq/UQaPjC+BaqaLjGIuWLz+pAuTLE?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5481.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: adcea63a-36ed-4873-906b-08da177feb26
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Apr 2022 03:45:39.8711
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: tyGnUsuhb/+BR1gavf7kEK7H3oQs4FTeX4J2A7t+AfGYtA3qQHUbJtrBIG47boB+XyE/ZcDzwMaOXGYeYZc3SQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR12MB1294
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> From: 08005325@163.com <08005325@163.com>
> Sent: Thursday, March 24, 2022 5:19 AM
>=20
> From: Michael Qiu <qiudayu@archeros.com>
>
Sorry for the late response.
Please see short comments below.
=20
> vdpa framework not only support query the max virtqueue pair, but also fo=
r
> the set action.
>=20
> This patch enable this capacity, and it is very useful for VMs  who needs
> multiqueue support.
>
A simpler rewrite as below.
This patch enables user to set max vq pairs for the net vdpa device during =
device addition time.
An example,

$ vdpa dev add ..  please give exact command that other users can copy.

=20
> Signed-off-by: Michael Qiu <qiudayu@archeros.com>
> ---
>  vdpa/vdpa.c | 17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
>=20
> diff --git a/vdpa/vdpa.c b/vdpa/vdpa.c
> index f048e47..434d68e 100644
> --- a/vdpa/vdpa.c
> +++ b/vdpa/vdpa.c
> @@ -23,6 +23,7 @@
>  #define VDPA_OPT_VDEV_HANDLE           BIT(3)
>  #define VDPA_OPT_VDEV_MAC              BIT(4)
>  #define VDPA_OPT_VDEV_MTU              BIT(5)
> +#define VDPA_OPT_VDEV_QUEUE_PAIRS      BIT(6)
>=20
>  struct vdpa_opts {
>         uint64_t present; /* flags of present items */ @@ -32,6 +33,7 @@
> struct vdpa_opts {
>         unsigned int device_id;
>         char mac[ETH_ALEN];
>         uint16_t mtu;
> +       uint16_t max_vq_pairs;
>  };
>=20
>  struct vdpa {
> @@ -219,6 +221,8 @@ static void vdpa_opts_put(struct nlmsghdr *nlh,
> struct vdpa *vdpa)
>                              sizeof(opts->mac), opts->mac);
>         if (opts->present & VDPA_OPT_VDEV_MTU)
>                 mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MTU, opts-
> >mtu);
> +       if (opts->present & VDPA_OPT_VDEV_QUEUE_PAIRS)
> +               mnl_attr_put_u16(nlh, VDPA_ATTR_DEV_NET_CFG_MAX_VQP,
> + opts->max_vq_pairs);
>  }
>=20
>  static int vdpa_argv_parse(struct vdpa *vdpa, int argc, char **argv, @@ =
-
> 287,6 +291,15 @@ static int vdpa_argv_parse(struct vdpa *vdpa, int argc,
> char **argv,
>=20
>                         NEXT_ARG_FWD();
>                         o_found |=3D VDPA_OPT_VDEV_MTU;
> +               } else if ((strcmp(*argv, "max_vq_pairs") =3D=3D 0) &&

Currently on query side this is printed as "max_vqp".
Please keep the same name on argument too to keep symmetry in get and set.

> +                          (o_all & VDPA_OPT_VDEV_QUEUE_PAIRS)) {
> +                       NEXT_ARG_FWD();
> +                       err =3D vdpa_argv_u16(vdpa, argc, argv, &opts->ma=
x_vq_pairs);
> +                       if (err)
> +                               return err;
> +
> +                       NEXT_ARG_FWD();
> +                       o_found |=3D VDPA_OPT_VDEV_QUEUE_PAIRS;
>                 } else {
>                         fprintf(stderr, "Unknown option \"%s\"\n", *argv)=
;
>                         return -EINVAL;
> @@ -467,7 +480,7 @@ static int cmd_mgmtdev(struct vdpa *vdpa, int argc,
> char **argv)  static void cmd_dev_help(void)  {
>         fprintf(stderr, "Usage: vdpa dev show [ DEV ]\n");
> -       fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ]\n");
> +       fprintf(stderr, "       vdpa dev add name NAME mgmtdev
> MANAGEMENTDEV [ mac MACADDR ] [ mtu MTU ] [ max_vq_pairs N ]\n");
>         fprintf(stderr, "       vdpa dev del DEV\n");
>         fprintf(stderr, "Usage: vdpa dev config COMMAND [ OPTIONS ]\n"); =
 }
> @@ -557,7 +570,7 @@ static int cmd_dev_add(struct vdpa *vdpa, int argc,
> char **argv)
>                                           NLM_F_REQUEST | NLM_F_ACK);
>         err =3D vdpa_argv_parse_put(nlh, vdpa, argc, argv,
>                                   VDPA_OPT_VDEV_MGMTDEV_HANDLE |
> VDPA_OPT_VDEV_NAME,
> -                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU);
> +                                 VDPA_OPT_VDEV_MAC | VDPA_OPT_VDEV_MTU
> + | VDPA_OPT_VDEV_QUEUE_PAIRS);
>         if (err)
>                 return err;
>=20
> --
> 1.8.3.1

Please also extend the man page for this addition with example in man/man8/=
vdpa-dev.8.
