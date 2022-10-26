Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42A4C60E400
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 17:01:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234343AbiJZPBw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Oct 2022 11:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233403AbiJZPBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Oct 2022 11:01:47 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2052.outbound.protection.outlook.com [40.107.223.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAFDC95ADF
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 08:01:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dsD0mSv4GGjnynyxVVaiaP32AfpHYVGUTuGxHeREnR8iDmbSBuSIW/peE/T7+o24lUXR2cCSKSOsq9bgrOCsFiSYj63vogPS7UK5Oqs7e3z8j6VaZYLwim4QRNlDYPHYD9x2a3ijCEgw2ujPNoHG/4vvjppE8aIbYyAiYe8tZmegIDPN97C+2Ux98GCi1RbVYJcrEcXBggAVzOVHRY6lFebVJifuqbq8rNfhm3hXzgawJlKR0DEfOHki2m8Kg2YmMnE2cHyzocTccVygc3YlmeorZce7lEg1XlgZApmRhMhfYkxSxlRhmbf1jp37SlSsROQtvvd3Qk18bT4zTN8I3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kGXaWKC4ztmqvjSmAjz54Q+cgVP6/HhOMz7fMTY7Sno=;
 b=hxfVxN7UaTJEY/pirmzFrJ3hca7l2V7GXyh7ADmjlvhcIUJVDj4MNVecC4Bxlv2VgVhMaMaS6ipuqqrSLkvWj/pHsKtaWjHj+Z4DyXhH76ZLPbC1kIVbW8ZnULSbnlrbhFp3adl1+9PYaZRQ/dZtHdqFEgOHFKgtJCXinbpRh6KoljTMyzc4QdXj+4nBtHf4Ufr8RwvJhUdvITU5Biol9cMic6IuvPomcuuab14fgbDgVuYJsRZ7a8ZoSmDJhlcFX6L28ifO4uyf6RaDLFUl2RPaRExsdEpNNsOjyZr34u+pguqfBdUULcbBjZMYya31pdlflyX+EK61WXMrlYXcUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kGXaWKC4ztmqvjSmAjz54Q+cgVP6/HhOMz7fMTY7Sno=;
 b=KgTU7YWPhDyMQdWZviPooVorXULueFzE59aAMa31Jzacya0MjYh4ymSAtS/N/9jgGtc7V4vYkUVUjKwCfidsZX/VAMUkpYzOoRZwTvjfpF2QrZ0kmlr27zr3yPofLOkGA0Oh0Wds5tMkIsbg+ul1RMLlwenGmsJRLkqkQHjueDMsF0jN3tl0W285+U80NytvQ1zKByza/0JSp5V94QFlmFImZcPzIYInMo3d7uFCx5UFqqIrDZ7I6N2h2+528OG5lilGQ7T9kcvn5KY6mI7wpcOST+7CU2rBbcGXuf9VsZiM4gmnFUlT86/xKNFWH+8U35ZdxA8zj0HR5mh4Z4IBdg==
Received: from DM6PR12MB3564.namprd12.prod.outlook.com (2603:10b6:5:11d::14)
 by DM4PR12MB5820.namprd12.prod.outlook.com (2603:10b6:8:64::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.29; Wed, 26 Oct 2022 15:01:44 +0000
Received: from DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7]) by DM6PR12MB3564.namprd12.prod.outlook.com
 ([fe80::76e5:c5e9:d656:b0d7%7]) with mapi id 15.20.5723.029; Wed, 26 Oct 2022
 15:01:42 +0000
From:   Shai Malin <smalin@nvidia.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Aurelien Aptel <aaptel@nvidia.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>,
        "leon@kernel.org" <leon@kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "sagi@grimberg.me" <sagi@grimberg.me>, "hch@lst.de" <hch@lst.de>,
        "kbusch@kernel.org" <kbusch@kernel.org>,
        "axboe@fb.com" <axboe@fb.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Or Gerlitz <ogerlitz@nvidia.com>,
        Yoray Zack <yorayz@nvidia.com>,
        Boris Pismenny <borisp@nvidia.com>,
        "aurelien.aptel@gmail.com" <aurelien.aptel@gmail.com>,
        "malin1024@gmail.com" <malin1024@gmail.com>
Subject: RE: [PATCH v7 01/23] net: Introduce direct data placement tcp offload
Thread-Topic: [PATCH v7 01/23] net: Introduce direct data placement tcp
 offload
Thread-Index: AQHY6HobywKcS3CUh0e9rdSVQmztBq4ftFCAgAENjtA=
Date:   Wed, 26 Oct 2022 15:01:42 +0000
Message-ID: <DM6PR12MB3564FB23C582CEF338D11435BC309@DM6PR12MB3564.namprd12.prod.outlook.com>
References: <20221025135958.6242-1-aaptel@nvidia.com>
        <20221025135958.6242-2-aaptel@nvidia.com>
 <20221025153925.64b5b040@kernel.org>
In-Reply-To: <20221025153925.64b5b040@kernel.org>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR12MB3564:EE_|DM4PR12MB5820:EE_
x-ms-office365-filtering-correlation-id: ca7e9caa-afdf-48b4-3466-08dab762fe31
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EXzP/+dUr/Axrhc7QHSH71HdMcTwdUfvg966RMnt0ZWQLwpodYCjt1J68XqbjJijWKTL8GaIvKAs3VeSqY6NOkOj3KJQaylLHTTVx84sYMDkPBBwLpfYjA8wzW/I6GRJFKJYWU+q/iRIMwaUniKp/Dd1nChv/mRvvnOZnPkCf1mq4yU+6qDEYwKLuE2iRTorHu7FU69+bD4zzJshlaSxCwpiLiCVeZKaYFDPfRbwRDXWFIYfXe7egRLi9TAWvJ6Nm0YO/+X6mqAC/LBE0hzm2Qp1nzf2YJtbwwpbSltNlW374fFYUX7peyD56KdCAAToMiUgiMLKwqR0MjCCYO1+cLrYVTkmyK8w7I+1YXXdNzxHtyJo5tn6jlvaFchQJjooHTdFgnVUGGpd9PyBc/uAlNl1KWonuHI8MfR93lznPZ/gvXvizVbOPEXdfJd9wVefO56x+BxAL8HOEMgmg2pCbV4TffmU/vCt+fJ0uKvB/67htvXuj1kyeXZD4RgTWQ2tKqXwtHzS/Jd2wb0nIdIdTLwXGh6k92JkzHkVVL6N9Og/B64eCKqouZf2Qq2MpV2ooVTYh0KEAGjPrGeonir5sBDdI6yRJXxxoHEXdrqLQhOJZmBbSTJeSV0aacSw27XGMr6s8eqKj0lDKOHmCtiA2VJ6ht3PeZyUJtTJUtN4pE/ACsqpJ9yfdZ02giwk7d2K99eeBFamNyiz1NUsz8C/EDtQauoGd6W3YrW6b5n8lCocBAseFbAsSCotEL0p/4fMy3b615PCqGd4e4seEOnW9w==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB3564.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(376002)(346002)(396003)(39860400002)(136003)(451199015)(55016003)(41300700001)(38070700005)(83380400001)(66556008)(6636002)(8936002)(2906002)(86362001)(186003)(5660300002)(122000001)(9686003)(7416002)(52536014)(4326008)(6506007)(110136005)(66946007)(54906003)(71200400001)(316002)(26005)(66446008)(38100700002)(66476007)(8676002)(7696005)(76116006)(478600001)(33656002)(64756008);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?NqzLWn36qRnUYHR0mu4UgcGEtt1N4Zsmx7lFvn3LcX2N2OkNijwLdaYH4G/x?=
 =?us-ascii?Q?zN2DKFS0pL7S6jKwrWn8PKC2c4fHXwy133ohpLdxv6rVH2CoUUX21D+5rMYU?=
 =?us-ascii?Q?bFW/xmXNPm5SKTYMcvneVbQB6RoUHT5T2Er7FD3LVhnuQVOv2R0//EwRiSim?=
 =?us-ascii?Q?vPEph9qDwX8d6lMpoqARJtTEN7C8hSFqmYhrkQrddOJuhLh6/JTyWzV1PQg3?=
 =?us-ascii?Q?MzwePqwUaYmStfyjl/T5y6EZc+xGqUEpmbaN6qQXu2QcXSmFnir6TaFFBdgw?=
 =?us-ascii?Q?hOFuk9Fo/ZytmjzIb/OiiqGoozkpHbXlwSiaKF4K1ZM7vNeb/l5ipokp+TsE?=
 =?us-ascii?Q?NP2X0qxW9H85nV7eoyVDd16FpmIBV5q83baNPFRMhDR9Kkw+VuylOpnJ7mDL?=
 =?us-ascii?Q?64uXRyepAs7qxk4irat2LP4WQ33LoDAr56XpRXcM0LfT65SaQtSn1c5nimpH?=
 =?us-ascii?Q?Ed+wakUPox8giHbnQhi0IkFljN6BcoiLQya23ct8P3o+43ApszRSn4xml31x?=
 =?us-ascii?Q?4vpbRpaRFrDBgcQGbS/NyknNCeXJGAbt1lIlMKRqnpB6gZKUC2rfy8nvuXZA?=
 =?us-ascii?Q?qiTJl2wf4n9fd57YSql21Soy0/83Z5PNvdUsuREjYMvsjmhq7Y8nIYEpV/ui?=
 =?us-ascii?Q?+CQA06uQ4UWgp/A80R3mN4d9Rd6Tr/6kSmZ9VYm2V5ni5q37xNIFefufK5qX?=
 =?us-ascii?Q?36o+08kOJJkZvtCQSwpJokVGonW4Wvab2dUfixZYKLXjz6yPbBUICVbCjAv0?=
 =?us-ascii?Q?UBsMjYsafgeiTLnChKjLN9aEU3z8OzJG8vLKzHCbkQz0+Y0Avfdnest9H32R?=
 =?us-ascii?Q?jGnKd/K3N1fMtwz11fb/8brzvjrGTmJZOrZcclNZRIJnr5rjnbbpPnGqL+AQ?=
 =?us-ascii?Q?v0L8udKyxgVZuxkzk24deel8bja19KtXrzblJ2KwzZKOx4lKuG5AfWq1TqhS?=
 =?us-ascii?Q?08G3I8zjq9EQvKf1QdsZuCj8cA6k6KIFyDaO02NrtQC0FDBF3Llj4+8y/+xx?=
 =?us-ascii?Q?3Df6bJof+avbuzaffkQM/hj4S6dj7czPzc3p9OVdvV8UKSZ/kFmxOaaFoXk9?=
 =?us-ascii?Q?MvQzMGQZPOcwrWJjthnS+spTkoqei8657Iq7vkOgXQwIsUWBoZGLtM+7kQsu?=
 =?us-ascii?Q?IYBbUPBmG3gG7qOuG9VqDs9oWXiy2dzxHeKNm7I+zYywhtbOBz9KIDxvitMP?=
 =?us-ascii?Q?tCeCIjGyHdJd0bKQ7iOWIU8oVHBJ/Jxyo7W/b01I0jbVCb4mqSVWN7r0/vFr?=
 =?us-ascii?Q?eFCMwhUWoYl4OEtx2i3n88o5MYlSdlUM+v7Ix374+LGecr1yMfGRtvqoYSy7?=
 =?us-ascii?Q?vaArZzH732hkRFUVSQLza4NkyCoQPgIMxOJWslHDnxRu54TfG7vnT8PqUhBF?=
 =?us-ascii?Q?7r6aJqJK4O24nms4ethpb7L1o3D9qDpcHUGHeJ0ptncoHNs1RdD/RcLqI2ra?=
 =?us-ascii?Q?5UuyLQibfNxWilps7QySJaGUFiicyo2mROyZGRropEL7jY4VpgRM/m6DOD66?=
 =?us-ascii?Q?ZTCM6OAAAMsNpDiIfYzAOSYGDuEW/XpJjf6p/wsItW7ot4yey1wX+be7uEeZ?=
 =?us-ascii?Q?JrbxQO7EjlMWph0LZB0q2LG+9xP+Kj9c/U/ZVFxY?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB3564.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca7e9caa-afdf-48b4-3466-08dab762fe31
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2022 15:01:42.5349
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: RPmD2jaKLMmXi3FnDOqT4SI8C7eDqsKPm1QYL9jBwNoVq+YBWEChFRrRWKbImaY/qSFOn/vFjDqmmpev9ozeWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR12MB5820
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Oct 2022 at 23:39, Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue, 25 Oct 2022 16:59:36 +0300 Aurelien Aptel wrote:
> > diff --git a/include/linux/netdev_features.h b/include/linux/netdev_fea=
tures.h
> > index 7c2d77d75a88..bf7391aa04c7 100644
> > --- a/include/linux/netdev_features.h
> > +++ b/include/linux/netdev_features.h
> > @@ -14,7 +14,7 @@ typedef u64 netdev_features_t;
> >  enum {
> >       NETIF_F_SG_BIT,                 /* Scatter/gather IO. */
> >       NETIF_F_IP_CSUM_BIT,            /* Can checksum TCP/UDP over IPv4=
. */
> > -     __UNUSED_NETIF_F_1,
> > +     NETIF_F_HW_ULP_DDP_BIT,         /* ULP direct data placement offl=
oad */
>=20
> Why do you need a feature bit if there is a whole caps / limit querying
> mechanism?

The caps are used for the HW device to publish the supported=20
capabilities/limitation, while the feature bit is used for the DDP=20
enablement "per net-device".

Disabling will be required in case that another feature which is=20
mutually exclusive to the DDP is needed (as an example in the mlx case,=20
CQE compress which is controlled from ethtool).

>=20
> >       NETIF_F_HW_CSUM_BIT,            /* Can checksum all the packets. =
*/
> >       NETIF_F_IPV6_CSUM_BIT,          /* Can checksum TCP/UDP over IPV6=
 */
> >       NETIF_F_HIGHDMA_BIT,            /* Can DMA to high memory. */
> > @@ -168,6 +168,7 @@ enum {
> >  #define NETIF_F_HW_HSR_TAG_RM        __NETIF_F(HW_HSR_TAG_RM)
> >  #define NETIF_F_HW_HSR_FWD   __NETIF_F(HW_HSR_FWD)
> >  #define NETIF_F_HW_HSR_DUP   __NETIF_F(HW_HSR_DUP)
> > +#define NETIF_F_HW_ULP_DDP   __NETIF_F(HW_ULP_DDP)
> >
> >  /* Finds the next feature with the highest number of the range of star=
t-1 till 0.
> >   */
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index eddf8ee270e7..84554f26ad6b 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -1043,6 +1043,7 @@ struct dev_ifalias {
> >
> >  struct devlink;
> >  struct tlsdev_ops;
> > +struct ulp_ddp_dev_ops;
>=20
> I thought forward declarations are not required for struct members,
> are they?

Right, thanks, we will remove it.

>=20
> >  struct netdev_net_notifier {
> >       struct list_head list;
> > @@ -2096,6 +2097,10 @@ struct net_device {
> >       const struct tlsdev_ops *tlsdev_ops;
> >  #endif
> >
> > +#if IS_ENABLED(CONFIG_ULP_DDP)
> > +     const struct ulp_ddp_dev_ops *ulp_ddp_ops;
> > +#endif
>=20
> It's somewhat unclear to me why we add ops to struct net_device,
> rather than to ops.. can you explain?

We were trying to follow the TLS design which is similar.
Can you please clarify what do you mean by "rather than to ops.."?

>=20
> >       const struct header_ops *header_ops;
> >
> >       unsigned char           operstate;
>=20
> > +#include <linux/netdevice.h>
> > +#include <net/inet_connection_sock.h>
> > +#include <net/sock.h>
> > +
> > +enum ulp_ddp_type {
> > +     ULP_DDP_NVME =3D 1,
>=20
> I think the DDP and the NVME parts should have more separation.
>=20
> Are you planning to implement pure TCP placement, without NIC trying
> to also "add value" by processing whatever TCP is carrying.

We are not planning to implement pure TCP placement.
As we will present in the netdev, this is doable only if the HW is L5 aware=
.

>=20
> Can you split the DDP and NVME harder in the API, somehow?

We can simplify the layering by using union per ulp_ddp_type.
There are no nvme structures or definitions needed in ulp_ddp.

>=20
> > +};
> > +
> > +enum ulp_ddp_offload_capabilities {
> > +     ULP_DDP_C_NVME_TCP =3D 1,
> > +     ULP_DDP_C_NVME_TCP_DDGST_RX =3D 2,
> > +};
> > +
> > +/**
> > + * struct ulp_ddp_limits - Generic ulp ddp limits: tcp ddp
> > + * protocol limits.
> > + * Protocol implementations must use this as the first member.
> > + * Add new instances of ulp_ddp_limits below (nvme-tcp, etc.).
> > + *
> > + * @type:            type of this limits struct
> > + * @offload_capabilities:bitmask of supported offload types
> > + * @max_ddp_sgl_len: maximum sgl size supported (zero means no limit)
> > + * @io_threshold:    minimum payload size required to offload
> > + * @buf:             protocol-specific limits struct (if any)
> > + */
> > +struct ulp_ddp_limits {
>=20
> Why is this called limits not capabilities / caps?

We will change it to caps.

>=20
> > +     enum ulp_ddp_type       type;
> > +     u64                     offload_capabilities;
> > +     int                     max_ddp_sgl_len;
> > +     int                     io_threshold;
> > +     unsigned char           buf[];
>=20
> Just put a union of all the protos here.

Sure.

>=20
> > +};
> > +
> > +/**
> > + * struct nvme_tcp_ddp_limits - nvme tcp driver limitations
> > + *
> > + * @lmt:             generic ULP limits struct
> > + * @full_ccid_range: true if the driver supports the full CID range
> > + */
> > +struct nvme_tcp_ddp_limits {
> > +     struct ulp_ddp_limits   lmt;
> > +
> > +     bool                    full_ccid_range;
> > +};
>=20
> > diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> > index 0640453fce54..df37db420110 100644
> > --- a/net/ipv4/tcp_input.c
> > +++ b/net/ipv4/tcp_input.c
> > @@ -5233,6 +5233,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_hea=
d
> *list, struct rb_root *root,
> >               memcpy(nskb->cb, skb->cb, sizeof(skb->cb));
> >  #ifdef CONFIG_TLS_DEVICE
> >               nskb->decrypted =3D skb->decrypted;
> > +#endif
> > +#ifdef CONFIG_ULP_DDP
> > +             nskb->ulp_ddp =3D skb->ulp_ddp;
> > +             nskb->ulp_crc =3D skb->ulp_crc;
> >  #endif
> >               TCP_SKB_CB(nskb)->seq =3D TCP_SKB_CB(nskb)->end_seq =3D s=
tart;
> >               if (list)
> > @@ -5266,6 +5270,10 @@ tcp_collapse(struct sock *sk, struct sk_buff_hea=
d
> *list, struct rb_root *root,
> >  #ifdef CONFIG_TLS_DEVICE
> >                               if (skb->decrypted !=3D nskb->decrypted)
> >                                       goto end;
> > +#endif
> > +#ifdef CONFIG_ULP_DDP
>=20
> no ifdef needed

Thanks, we will remove it.

>=20
> > +                             if (skb_is_ulp_crc(skb) !=3D skb_is_ulp_c=
rc(nskb))
> > +                                     goto end;
> >  #endif
> >                       }
> >               }

